
chains/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008c39e0 <check_lower_drain>:
  8c39e0:	55                   	push   %rbp
  8c39e1:	41 57                	push   %r15
  8c39e3:	41 56                	push   %r14
  8c39e5:	41 55                	push   %r13
  8c39e7:	41 54                	push   %r12
  8c39e9:	53                   	push   %rbx
  8c39ea:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  8c39f1:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c39f8:	00 00 
  8c39fa:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  8c3a01:	00 
  8c3a02:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8c3a08:	85 c9                	test   %ecx,%ecx
  8c3a0a:	0f 84 4b 55 00 00    	je     8c8f5b <check_lower_drain+0x557b>
  8c3a10:	48 89 fb             	mov    %rdi,%rbx
  8c3a13:	e9 ea 00 00 00       	jmp    8c3b02 <check_lower_drain+0x122>
  8c3a18:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c3a1d:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c3a22:	4c 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%r14
  8c3a29:	00 
  8c3a2a:	48 8d bc 24 00 02 00 	lea    0x200(%rsp),%rdi
  8c3a31:	00 
  8c3a32:	4c 89 f6             	mov    %r14,%rsi
  8c3a35:	c5 f8 29 84 24 b0 00 	vmovaps %xmm0,0xb0(%rsp)
  8c3a3c:	00 00 
  8c3a3e:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3a42:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  8c3a49:	00 
  8c3a4a:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3a50:	89 84 24 c8 00 00 00 	mov    %eax,0xc8(%rsp)
  8c3a57:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3a5d:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3a62:	0f 43 c1             	cmovae %ecx,%eax
  8c3a65:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c3a6a:	89 84 24 cc 00 00 00 	mov    %eax,0xcc(%rsp)
  8c3a71:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c3a78:	00 
  8c3a79:	c5 f8 29 84 24 d0 00 	vmovaps %xmm0,0xd0(%rsp)
  8c3a80:	00 00 
  8c3a82:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c3a88:	89 84 24 e0 00 00 00 	mov    %eax,0xe0(%rsp)
  8c3a8f:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3a95:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c3a9a:	0f 43 c1             	cmovae %ecx,%eax
  8c3a9d:	89 84 24 e4 00 00 00 	mov    %eax,0xe4(%rsp)
  8c3aa4:	44 89 e0             	mov    %r12d,%eax
  8c3aa7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8c3aab:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3ab2:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  8c3ab6:	48 01 c2             	add    %rax,%rdx
  8c3ab9:	48 03 93 20 01 00 00 	add    0x120(%rbx),%rdx
  8c3ac0:	83 f1 01             	xor    $0x1,%ecx
  8c3ac3:	c5 f8 77             	vzeroupper
  8c3ac6:	e8 65 9a 97 00       	call   123d530 <cbuiltin_lower_append>
  8c3acb:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  8c3ad2:	00 
  8c3ad3:	48 89 df             	mov    %rbx,%rdi
  8c3ad6:	4c 89 f6             	mov    %r14,%rsi
  8c3ad9:	44 89 fa             	mov    %r15d,%edx
  8c3adc:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8c3ae1:	c5 fa 6f 84 24 00 02 	vmovdqu 0x200(%rsp),%xmm0
  8c3ae8:	00 00 
  8c3aea:	c5 fa 7f 04 24       	vmovdqu %xmm0,(%rsp)
  8c3aef:	e8 ec 1c 01 00       	call   8d57e0 <check_lower_builtin_finish>
  8c3af4:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c3afa:	85 c9                	test   %ecx,%ecx
  8c3afc:	0f 84 59 54 00 00    	je     8c8f5b <check_lower_drain+0x557b>
  8c3b02:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c3b06:	48 8b 00             	mov    (%rax),%rax
  8c3b09:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3b10:	0f 85 45 54 00 00    	jne    8c8f5b <check_lower_drain+0x557b>
  8c3b16:	48 8b 73 18          	mov    0x18(%rbx),%rsi
  8c3b1a:	8d 51 ff             	lea    -0x1(%rcx),%edx
  8c3b1d:	48 89 d7             	mov    %rdx,%rdi
  8c3b20:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c3b26:	48 c1 e7 04          	shl    $0x4,%rdi
  8c3b2a:	4c 8b 24 3e          	mov    (%rsi,%rdi,1),%r12
  8c3b2e:	4c 8b 7c 3e 08       	mov    0x8(%rsi,%rdi,1),%r15
  8c3b33:	4d 89 e0             	mov    %r12,%r8
  8c3b36:	49 c1 e8 20          	shr    $0x20,%r8
  8c3b3a:	41 0f b6 f8          	movzbl %r8b,%edi
  8c3b3e:	44 8d 4f ff          	lea    -0x1(%rdi),%r9d
  8c3b42:	41 83 f9 05          	cmp    $0x5,%r9d
  8c3b46:	0f 87 2f 02 00 00    	ja     8c3d7b <check_lower_drain+0x39b>
  8c3b4c:	48 8d 3d 3d 38 be ff 	lea    -0x41c7c3(%rip),%rdi        # 4a7390 <cbuiltin_test_generated.edges+0xad00>
  8c3b53:	4a 63 14 8f          	movslq (%rdi,%r9,4),%rdx
  8c3b57:	48 01 fa             	add    %rdi,%rdx
  8c3b5a:	ff e2                	jmp    *%rdx
  8c3b5c:	80 bb f8 01 00 00 00 	cmpb   $0x0,0x1f8(%rbx)
  8c3b63:	0f 84 5d 02 00 00    	je     8c3dc6 <check_lower_drain+0x3e6>
  8c3b69:	4c 89 e0             	mov    %r12,%rax
  8c3b6c:	48 c1 e8 30          	shr    $0x30,%rax
  8c3b70:	3c 0f                	cmp    $0xf,%al
  8c3b72:	0f 82 05 03 00 00    	jb     8c3e7d <check_lower_drain+0x49d>
  8c3b78:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c3b7c:	48 8b 00             	mov    (%rax),%rax
  8c3b7f:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3b86:	0f 85 68 ff ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c3b8c:	48 8d 0d 42 5c dc ff 	lea    -0x23a3be(%rip),%rcx        # 6897d5 <fuzz_comment_end+0x26cbc>
  8c3b93:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c3b9a:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c3b9e:	48 8b 00             	mov    (%rax),%rax
  8c3ba1:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3ba8:	0f 85 46 ff ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c3bae:	e9 64 15 00 00       	jmp    8c5117 <check_lower_drain+0x1737>
  8c3bb3:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c3bb9:	48 8b 53 48          	mov    0x48(%rbx),%rdx
  8c3bbd:	44 89 e0             	mov    %r12d,%eax
  8c3bc0:	89 0c 82             	mov    %ecx,(%rdx,%rax,4)
  8c3bc3:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c3bca:	0f 85 24 ff ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c3bd0:	48 8b 4b 50          	mov    0x50(%rbx),%rcx
  8c3bd4:	80 bb 7c 01 00 00 00 	cmpb   $0x0,0x17c(%rbx)
  8c3bdb:	75 14                	jne    8c3bf1 <check_lower_drain+0x211>
  8c3bdd:	8b 14 81             	mov    (%rcx,%rax,4),%edx
  8c3be0:	be 00 00 00 00       	mov    $0x0,%esi
  8c3be5:	83 fa ff             	cmp    $0xffffffff,%edx
  8c3be8:	0f 44 d6             	cmove  %esi,%edx
  8c3beb:	89 93 74 01 00 00    	mov    %edx,0x174(%rbx)
  8c3bf1:	83 3c 81 ff          	cmpl   $0xffffffff,(%rcx,%rax,4)
  8c3bf5:	75 09                	jne    8c3c00 <check_lower_drain+0x220>
  8c3bf7:	8b 93 74 01 00 00    	mov    0x174(%rbx),%edx
  8c3bfd:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  8c3c00:	c6 83 7c 01 00 00 01 	movb   $0x1,0x17c(%rbx)
  8c3c07:	e9 e8 fe ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c3c0c:	48 89 df             	mov    %rbx,%rdi
  8c3c0f:	44 89 e6             	mov    %r12d,%esi
  8c3c12:	c5 f8 77             	vzeroupper
  8c3c15:	e8 46 ac ff ff       	call   8be860 <check_lower_control>
  8c3c1a:	e9 d5 fe ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c3c1f:	8b 8b b0 01 00 00    	mov    0x1b0(%rbx),%ecx
  8c3c25:	44 89 e2             	mov    %r12d,%edx
  8c3c28:	c1 ea 03             	shr    $0x3,%edx
  8c3c2b:	39 ca                	cmp    %ecx,%edx
  8c3c2d:	73 11                	jae    8c3c40 <check_lower_drain+0x260>
  8c3c2f:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3c36:	f6 04 17 02          	testb  $0x2,(%rdi,%rdx,1)
  8c3c3a:	0f 85 c9 04 00 00    	jne    8c4109 <check_lower_drain+0x729>
  8c3c40:	44 89 fe             	mov    %r15d,%esi
  8c3c43:	c1 ee 03             	shr    $0x3,%esi
  8c3c46:	39 ce                	cmp    %ecx,%esi
  8c3c48:	73 11                	jae    8c3c5b <check_lower_drain+0x27b>
  8c3c4a:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3c51:	f6 04 37 02          	testb  $0x2,(%rdi,%rsi,1)
  8c3c55:	0f 85 b4 04 00 00    	jne    8c410f <check_lower_drain+0x72f>
  8c3c5b:	41 b6 ff             	mov    $0xff,%r14b
  8c3c5e:	40 b5 ff             	mov    $0xff,%bpl
  8c3c61:	39 ca                	cmp    %ecx,%edx
  8c3c63:	73 1b                	jae    8c3c80 <check_lower_drain+0x2a0>
  8c3c65:	48 8b b3 a0 01 00 00 	mov    0x1a0(%rbx),%rsi
  8c3c6c:	40 b5 08             	mov    $0x8,%bpl
  8c3c6f:	f6 04 16 01          	testb  $0x1,(%rsi,%rdx,1)
  8c3c73:	75 0b                	jne    8c3c80 <check_lower_drain+0x2a0>
  8c3c75:	48 8b b3 98 01 00 00 	mov    0x198(%rbx),%rsi
  8c3c7c:	0f b6 2c 16          	movzbl (%rsi,%rdx,1),%ebp
  8c3c80:	44 89 fe             	mov    %r15d,%esi
  8c3c83:	c1 ee 03             	shr    $0x3,%esi
  8c3c86:	39 ce                	cmp    %ecx,%esi
  8c3c88:	73 1c                	jae    8c3ca6 <check_lower_drain+0x2c6>
  8c3c8a:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3c91:	41 b6 08             	mov    $0x8,%r14b
  8c3c94:	f6 04 37 01          	testb  $0x1,(%rdi,%rsi,1)
  8c3c98:	75 0c                	jne    8c3ca6 <check_lower_drain+0x2c6>
  8c3c9a:	48 8b bb 98 01 00 00 	mov    0x198(%rbx),%rdi
  8c3ca1:	44 0f b6 34 37       	movzbl (%rdi,%rsi,1),%r14d
  8c3ca6:	39 ca                	cmp    %ecx,%edx
  8c3ca8:	0f 83 b7 02 00 00    	jae    8c3f65 <check_lower_drain+0x585>
  8c3cae:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3cb5:	0f b6 3c 17          	movzbl (%rdi,%rdx,1),%edi
  8c3cb9:	39 ce                	cmp    %ecx,%esi
  8c3cbb:	0f 82 aa 02 00 00    	jb     8c3f6b <check_lower_drain+0x58b>
  8c3cc1:	e9 b0 02 00 00       	jmp    8c3f76 <check_lower_drain+0x596>
  8c3cc6:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c3ccb:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c3cd0:	4c 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%r14
  8c3cd7:	00 
  8c3cd8:	48 8d bc 24 00 02 00 	lea    0x200(%rsp),%rdi
  8c3cdf:	00 
  8c3ce0:	4c 89 f6             	mov    %r14,%rsi
  8c3ce3:	c5 f8 29 84 24 b0 00 	vmovaps %xmm0,0xb0(%rsp)
  8c3cea:	00 00 
  8c3cec:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3cf0:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  8c3cf7:	00 
  8c3cf8:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3cfe:	89 84 24 c8 00 00 00 	mov    %eax,0xc8(%rsp)
  8c3d05:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3d0b:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3d10:	0f 43 c1             	cmovae %ecx,%eax
  8c3d13:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c3d18:	89 84 24 cc 00 00 00 	mov    %eax,0xcc(%rsp)
  8c3d1f:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c3d26:	00 
  8c3d27:	c5 f8 29 84 24 d0 00 	vmovaps %xmm0,0xd0(%rsp)
  8c3d2e:	00 00 
  8c3d30:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c3d36:	89 84 24 e0 00 00 00 	mov    %eax,0xe0(%rsp)
  8c3d3d:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3d43:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c3d48:	0f 43 c1             	cmovae %ecx,%eax
  8c3d4b:	89 84 24 e4 00 00 00 	mov    %eax,0xe4(%rsp)
  8c3d52:	44 89 e0             	mov    %r12d,%eax
  8c3d55:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
  8c3d59:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3d60:	48 c1 e2 02          	shl    $0x2,%rdx
  8c3d64:	48 03 93 28 01 00 00 	add    0x128(%rbx),%rdx
  8c3d6b:	83 f1 01             	xor    $0x1,%ecx
  8c3d6e:	c5 f8 77             	vzeroupper
  8c3d71:	e8 1a 16 98 00       	call   1245390 <cbuiltin_misc_append>
  8c3d76:	e9 50 fd ff ff       	jmp    8c3acb <check_lower_drain+0xeb>
  8c3d7b:	8d 4f f9             	lea    -0x7(%rdi),%ecx
  8c3d7e:	83 f9 01             	cmp    $0x1,%ecx
  8c3d81:	0f 87 bb 00 00 00    	ja     8c3e42 <check_lower_drain+0x462>
  8c3d87:	44 89 e2             	mov    %r12d,%edx
  8c3d8a:	48 c1 e2 05          	shl    $0x5,%rdx
  8c3d8e:	48 03 93 30 01 00 00 	add    0x130(%rbx),%rdx
  8c3d95:	83 ff 08             	cmp    $0x8,%edi
  8c3d98:	0f 85 24 01 00 00    	jne    8c3ec2 <check_lower_drain+0x4e2>
  8c3d9e:	8b 02                	mov    (%rdx),%eax
  8c3da0:	b9 b3 fe ff ff       	mov    $0xfffffeb3,%ecx
  8c3da5:	01 c8                	add    %ecx,%eax
  8c3da7:	83 f8 01             	cmp    $0x1,%eax
  8c3daa:	0f 87 12 01 00 00    	ja     8c3ec2 <check_lower_drain+0x4e2>
  8c3db0:	48 89 df             	mov    %rbx,%rdi
  8c3db3:	44 89 e6             	mov    %r12d,%esi
  8c3db6:	44 89 fa             	mov    %r15d,%edx
  8c3db9:	c5 f8 77             	vzeroupper
  8c3dbc:	e8 cf 22 01 00       	call   8d6090 <check_lower_floating_strict>
  8c3dc1:	e9 2e fd ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c3dc6:	83 f9 03             	cmp    $0x3,%ecx
  8c3dc9:	0f 82 9a fd ff ff    	jb     8c3b69 <check_lower_drain+0x189>
  8c3dcf:	80 bb f9 01 00 00 00 	cmpb   $0x0,0x1f9(%rbx)
  8c3dd6:	0f 85 8d fd ff ff    	jne    8c3b69 <check_lower_drain+0x189>
  8c3ddc:	8d 41 fe             	lea    -0x2(%rcx),%eax
  8c3ddf:	48 ba 00 00 00 00 01 	movabs $0x100000000,%rdx
  8c3de6:	00 00 00 
  8c3de9:	48 c1 e0 04          	shl    $0x4,%rax
  8c3ded:	0f b6 44 06 04       	movzbl 0x4(%rsi,%rax,1),%eax
  8c3df2:	48 c1 e0 20          	shl    $0x20,%rax
  8c3df6:	48 39 d0             	cmp    %rdx,%rax
  8c3df9:	0f 85 6a fd ff ff    	jne    8c3b69 <check_lower_drain+0x189>
  8c3dff:	83 c1 fd             	add    $0xfffffffd,%ecx
  8c3e02:	48 ba 00 00 00 00 01 	movabs $0x100000000,%rdx
  8c3e09:	00 00 00 
  8c3e0c:	48 c1 e1 04          	shl    $0x4,%rcx
  8c3e10:	48 8b 04 0e          	mov    (%rsi,%rcx,1),%rax
  8c3e14:	48 b9 00 00 00 00 ff 	movabs $0xff00000000,%rcx
  8c3e1b:	00 00 00 
  8c3e1e:	48 21 c8             	and    %rcx,%rax
  8c3e21:	48 39 d0             	cmp    %rdx,%rax
  8c3e24:	0f 85 3f fd ff ff    	jne    8c3b69 <check_lower_drain+0x189>
  8c3e2a:	48 89 df             	mov    %rbx,%rdi
  8c3e2d:	c5 f8 77             	vzeroupper
  8c3e30:	e8 1b b9 00 00       	call   8cf750 <check_lower_instruction_batch>
  8c3e35:	84 c0                	test   %al,%al
  8c3e37:	0f 85 b7 fc ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c3e3d:	e9 27 fd ff ff       	jmp    8c3b69 <check_lower_drain+0x189>
  8c3e42:	41 0f b6 c8          	movzbl %r8b,%ecx
  8c3e46:	83 c1 f7             	add    $0xfffffff7,%ecx
  8c3e49:	83 f9 0a             	cmp    $0xa,%ecx
  8c3e4c:	0f 87 ac 09 00 00    	ja     8c47fe <check_lower_drain+0xe1e>
  8c3e52:	48 8d 15 4f 35 be ff 	lea    -0x41cab1(%rip),%rdx        # 4a73a8 <cbuiltin_test_generated.edges+0xad18>
  8c3e59:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  8c3e5d:	48 01 d1             	add    %rdx,%rcx
  8c3e60:	ff e1                	jmp    *%rcx
  8c3e62:	48 8b 03             	mov    (%rbx),%rax
  8c3e65:	44 89 e1             	mov    %r12d,%ecx
  8c3e68:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  8c3e6c:	48 c1 e6 05          	shl    $0x5,%rsi
  8c3e70:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c3e74:	48 03 70 08          	add    0x8(%rax),%rsi
  8c3e78:	e9 c4 05 00 00       	jmp    8c4441 <check_lower_drain+0xa61>
  8c3e7d:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c3e83:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8c3e89:	0f 87 50 15 00 00    	ja     8c53df <check_lower_drain+0x19ff>
  8c3e8f:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c3e95:	0f 83 44 15 00 00    	jae    8c53df <check_lower_drain+0x19ff>
  8c3e9b:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c3ea2:	0f 85 9a 02 00 00    	jne    8c4142 <check_lower_drain+0x762>
  8c3ea8:	41 0f b6 f4          	movzbl %r12b,%esi
  8c3eac:	0f b6 d0             	movzbl %al,%edx
  8c3eaf:	48 89 df             	mov    %rbx,%rdi
  8c3eb2:	4c 89 f9             	mov    %r15,%rcx
  8c3eb5:	c5 f8 77             	vzeroupper
  8c3eb8:	e8 03 e0 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c3ebd:	e9 32 fc ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c3ec2:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c3ec7:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c3ecc:	4c 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%r14
  8c3ed3:	00 
  8c3ed4:	48 8d bc 24 00 02 00 	lea    0x200(%rsp),%rdi
  8c3edb:	00 
  8c3edc:	4c 89 f6             	mov    %r14,%rsi
  8c3edf:	c5 f8 29 84 24 b0 00 	vmovaps %xmm0,0xb0(%rsp)
  8c3ee6:	00 00 
  8c3ee8:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3eec:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  8c3ef3:	00 
  8c3ef4:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3efa:	89 84 24 c8 00 00 00 	mov    %eax,0xc8(%rsp)
  8c3f01:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3f07:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3f0c:	0f 43 c1             	cmovae %ecx,%eax
  8c3f0f:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c3f14:	89 84 24 cc 00 00 00 	mov    %eax,0xcc(%rsp)
  8c3f1b:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c3f22:	00 
  8c3f23:	c5 f8 29 84 24 d0 00 	vmovaps %xmm0,0xd0(%rsp)
  8c3f2a:	00 00 
  8c3f2c:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c3f32:	89 84 24 e0 00 00 00 	mov    %eax,0xe0(%rsp)
  8c3f39:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3f3f:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c3f44:	0f 43 c1             	cmovae %ecx,%eax
  8c3f47:	89 84 24 e4 00 00 00 	mov    %eax,0xe4(%rsp)
  8c3f4e:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3f55:	83 f1 01             	xor    $0x1,%ecx
  8c3f58:	c5 f8 77             	vzeroupper
  8c3f5b:	e8 80 29 98 00       	call   12468e0 <cbuiltin_float_lower_append>
  8c3f60:	e9 66 fb ff ff       	jmp    8c3acb <check_lower_drain+0xeb>
  8c3f65:	31 ff                	xor    %edi,%edi
  8c3f67:	39 ce                	cmp    %ecx,%esi
  8c3f69:	73 0b                	jae    8c3f76 <check_lower_drain+0x596>
  8c3f6b:	48 8b 93 a0 01 00 00 	mov    0x1a0(%rbx),%rdx
  8c3f72:	40 32 3c 32          	xor    (%rdx,%rsi,1),%dil
  8c3f76:	48 8b 13             	mov    (%rbx),%rdx
  8c3f79:	45 84 f6             	test   %r14b,%r14b
  8c3f7c:	41 0f 95 c1          	setne  %r9b
  8c3f80:	41 20 f9             	and    %dil,%r9b
  8c3f83:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8c3f87:	40 80 fd 0e          	cmp    $0xe,%bpl
  8c3f8b:	0f 87 a6 00 00 00    	ja     8c4037 <check_lower_drain+0x657>
  8c3f91:	41 80 fe 0e          	cmp    $0xe,%r14b
  8c3f95:	0f 87 9c 00 00 00    	ja     8c4037 <check_lower_drain+0x657>
  8c3f9b:	45 84 c9             	test   %r9b,%r9b
  8c3f9e:	0f 85 93 00 00 00    	jne    8c4037 <check_lower_drain+0x657>
  8c3fa4:	45 84 f6             	test   %r14b,%r14b
  8c3fa7:	0f 84 ce 01 00 00    	je     8c417b <check_lower_drain+0x79b>
  8c3fad:	39 ce                	cmp    %ecx,%esi
  8c3faf:	73 11                	jae    8c3fc2 <check_lower_drain+0x5e2>
  8c3fb1:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c3fb8:	f6 04 31 10          	testb  $0x10,(%rcx,%rsi,1)
  8c3fbc:	0f 85 7c 02 00 00    	jne    8c423e <check_lower_drain+0x85e>
  8c3fc2:	89 e9                	mov    %ebp,%ecx
  8c3fc4:	80 e1 0e             	and    $0xe,%cl
  8c3fc7:	80 f9 0c             	cmp    $0xc,%cl
  8c3fca:	0f 85 f1 01 00 00    	jne    8c41c1 <check_lower_drain+0x7e1>
  8c3fd0:	41 8d 4e f7          	lea    -0x9(%r14),%ecx
  8c3fd4:	80 f9 02             	cmp    $0x2,%cl
  8c3fd7:	0f 87 e4 01 00 00    	ja     8c41c1 <check_lower_drain+0x7e1>
  8c3fdd:	31 c0                	xor    %eax,%eax
  8c3fdf:	40 80 fd 0c          	cmp    $0xc,%bpl
  8c3fe3:	44 0f b6 ed          	movzbl %bpl,%r13d
  8c3fe7:	48 89 df             	mov    %rbx,%rdi
  8c3fea:	0f 95 c0             	setne  %al
  8c3fed:	44 89 ee             	mov    %r13d,%esi
  8c3ff0:	8d 04 c5 70 00 00 00 	lea    0x70(,%rax,8),%eax
  8c3ff7:	89 84 24 b0 00 00 00 	mov    %eax,0xb0(%rsp)
  8c3ffe:	c5 f8 77             	vzeroupper
  8c4001:	e8 1a a5 ff ff       	call   8be520 <check_lower_temporary>
  8c4006:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c400a:	41 89 c7             	mov    %eax,%r15d
  8c400d:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4014:	0f 84 5d 08 00 00    	je     8c4877 <check_lower_drain+0xe97>
  8c401a:	45 31 e4             	xor    %r12d,%r12d
  8c401d:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4023:	45 89 ff             	mov    %r15d,%r15d
  8c4026:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c402c:	0f 86 ac 08 00 00    	jbe    8c48de <check_lower_drain+0xefe>
  8c4032:	e9 d4 08 00 00       	jmp    8c490b <check_lower_drain+0xf2b>
  8c4037:	4c 8d 05 a1 7c d2 ff 	lea    -0x2d835f(%rip),%r8        # 5ebcdf <parse_test_openers+0x1f9e2>
  8c403e:	45 84 c9             	test   %r9b,%r9b
  8c4041:	0f 85 a8 10 00 00    	jne    8c50ef <check_lower_drain+0x170f>
  8c4047:	48 8b 0a             	mov    (%rdx),%rcx
  8c404a:	40 80 fd 0f          	cmp    $0xf,%bpl
  8c404e:	45 0f 43 fc          	cmovae %r12d,%r15d
  8c4052:	44 89 ff             	mov    %r15d,%edi
  8c4055:	c1 ef 03             	shr    $0x3,%edi
  8c4058:	0f b6 34 39          	movzbl (%rcx,%rdi,1),%esi
  8c405c:	40 80 fe 0f          	cmp    $0xf,%sil
  8c4060:	75 12                	jne    8c4074 <check_lower_drain+0x694>
  8c4062:	48 8b 72 20          	mov    0x20(%rdx),%rsi
  8c4066:	44 8b 3c be          	mov    (%rsi,%rdi,4),%r15d
  8c406a:	44 89 ff             	mov    %r15d,%edi
  8c406d:	c1 ef 03             	shr    $0x3,%edi
  8c4070:	0f b6 34 39          	movzbl (%rcx,%rdi,1),%esi
  8c4074:	4c 8d 05 a8 0b d4 ff 	lea    -0x2bf458(%rip),%r8        # 604c23 <parse_test_openers+0x38926>
  8c407b:	40 80 fe 03          	cmp    $0x3,%sil
  8c407f:	0f 84 6a 10 00 00    	je     8c50ef <check_lower_drain+0x170f>
  8c4085:	41 83 e7 f8          	and    $0xfffffff8,%r15d
  8c4089:	4c 8d 05 93 0b d4 ff 	lea    -0x2bf46d(%rip),%r8        # 604c23 <parse_test_openers+0x38926>
  8c4090:	41 81 ff 88 00 00 00 	cmp    $0x88,%r15d
  8c4097:	0f 84 52 10 00 00    	je     8c50ef <check_lower_drain+0x170f>
  8c409d:	4c 8d 05 7f 0b d4 ff 	lea    -0x2bf481(%rip),%r8        # 604c23 <parse_test_openers+0x38926>
  8c40a4:	41 81 ff b0 00 00 00 	cmp    $0xb0,%r15d
  8c40ab:	0f 84 3e 10 00 00    	je     8c50ef <check_lower_drain+0x170f>
  8c40b1:	4c 8d 05 a5 19 e9 ff 	lea    -0x16e65b(%rip),%r8        # 755a5d <pp_decode_file_name.meaning+0x1e719>
  8c40b8:	40 80 fe 05          	cmp    $0x5,%sil
  8c40bc:	0f 84 2d 10 00 00    	je     8c50ef <check_lower_drain+0x170f>
  8c40c2:	44 0f b6 c6          	movzbl %sil,%r8d
  8c40c6:	41 83 f8 06          	cmp    $0x6,%r8d
  8c40ca:	0f 85 f1 0f 00 00    	jne    8c50c1 <check_lower_drain+0x16e1>
  8c40d0:	48 8b 52 20          	mov    0x20(%rdx),%rdx
  8c40d4:	8b 34 ba             	mov    (%rdx,%rdi,4),%esi
  8c40d7:	c1 ee 03             	shr    $0x3,%esi
  8c40da:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
  8c40de:	40 80 ff 0f          	cmp    $0xf,%dil
  8c40e2:	75 0a                	jne    8c40ee <check_lower_drain+0x70e>
  8c40e4:	8b 14 b2             	mov    (%rdx,%rsi,4),%edx
  8c40e7:	c1 ea 03             	shr    $0x3,%edx
  8c40ea:	0f b6 3c 11          	movzbl (%rcx,%rdx,1),%edi
  8c40ee:	40 80 ff 02          	cmp    $0x2,%dil
  8c40f2:	4c 8d 05 77 7b d2 ff 	lea    -0x2d8489(%rip),%r8        # 5ebc70 <parse_test_openers+0x1f973>
  8c40f9:	48 8d 0d aa ed d0 ff 	lea    -0x2f1256(%rip),%rcx        # 5d2eaa <parse_test_openers+0x6bad>
  8c4100:	4c 0f 44 c1          	cmove  %rcx,%r8
  8c4104:	e9 e6 0f 00 00       	jmp    8c50ef <check_lower_drain+0x170f>
  8c4109:	44 89 fe             	mov    %r15d,%esi
  8c410c:	c1 ee 03             	shr    $0x3,%esi
  8c410f:	39 ce                	cmp    %ecx,%esi
  8c4111:	73 19                	jae    8c412c <check_lower_drain+0x74c>
  8c4113:	89 f6                	mov    %esi,%esi
  8c4115:	f6 04 37 01          	testb  $0x1,(%rdi,%rsi,1)
  8c4119:	75 11                	jne    8c412c <check_lower_drain+0x74c>
  8c411b:	48 8b bb 98 01 00 00 	mov    0x198(%rbx),%rdi
  8c4122:	80 3c 37 00          	cmpb   $0x0,(%rdi,%rsi,1)
  8c4126:	0f 84 2f fb ff ff    	je     8c3c5b <check_lower_drain+0x27b>
  8c412c:	48 89 df             	mov    %rbx,%rdi
  8c412f:	44 89 e6             	mov    %r12d,%esi
  8c4132:	44 89 fa             	mov    %r15d,%edx
  8c4135:	c5 f8 77             	vzeroupper
  8c4138:	e8 43 e6 00 00       	call   8d2780 <check_lower_complex_conversion>
  8c413d:	e9 b2 f9 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c4142:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c4146:	48 8b 12             	mov    (%rdx),%rdx
  8c4149:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c4150:	0f 85 9e f9 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c4156:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c415a:	44 88 24 0a          	mov    %r12b,(%rdx,%rcx,1)
  8c415e:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c4162:	88 04 0a             	mov    %al,(%rdx,%rcx,1)
  8c4165:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c4169:	4c 89 3c c8          	mov    %r15,(%rax,%rcx,8)
  8c416d:	8d 41 01             	lea    0x1(%rcx),%eax
  8c4170:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4176:	e9 79 f9 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c417b:	40 84 ed             	test   %bpl,%bpl
  8c417e:	0f 84 70 f9 ff ff    	je     8c3af4 <check_lower_drain+0x114>
  8c4184:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c418a:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4191:	0f 87 4f 12 00 00    	ja     8c53e6 <check_lower_drain+0x1a06>
  8c4197:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c419d:	0f 83 43 12 00 00    	jae    8c53e6 <check_lower_drain+0x1a06>
  8c41a3:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c41aa:	0f 85 1a 0a 00 00    	jne    8c4bca <check_lower_drain+0x11ea>
  8c41b0:	40 0f b6 d5          	movzbl %bpl,%edx
  8c41b4:	be 23 00 00 00       	mov    $0x23,%esi
  8c41b9:	48 89 df             	mov    %rbx,%rdi
  8c41bc:	e9 0f 12 00 00       	jmp    8c53d0 <check_lower_drain+0x19f0>
  8c41c1:	44 89 f1             	mov    %r14d,%ecx
  8c41c4:	80 e1 0e             	and    $0xe,%cl
  8c41c7:	80 f9 0c             	cmp    $0xc,%cl
  8c41ca:	0f 85 61 06 00 00    	jne    8c4831 <check_lower_drain+0xe51>
  8c41d0:	8d 4d f7             	lea    -0x9(%rbp),%ecx
  8c41d3:	80 f9 02             	cmp    $0x2,%cl
  8c41d6:	0f 87 55 06 00 00    	ja     8c4831 <check_lower_drain+0xe51>
  8c41dc:	31 c0                	xor    %eax,%eax
  8c41de:	40 80 fd 0a          	cmp    $0xa,%bpl
  8c41e2:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c41e7:	45 0f b6 e6          	movzbl %r14b,%r12d
  8c41eb:	48 89 df             	mov    %rbx,%rdi
  8c41ee:	0f 95 c0             	setne  %al
  8c41f1:	40 80 fd 09          	cmp    $0x9,%bpl
  8c41f5:	44 89 e6             	mov    %r12d,%esi
  8c41f8:	8d 04 c5 a0 00 00 00 	lea    0xa0(,%rax,8),%eax
  8c41ff:	0f 44 c1             	cmove  %ecx,%eax
  8c4202:	89 84 24 b0 00 00 00 	mov    %eax,0xb0(%rsp)
  8c4209:	c5 f8 77             	vzeroupper
  8c420c:	e8 0f a3 ff ff       	call   8be520 <check_lower_temporary>
  8c4211:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4215:	41 89 c7             	mov    %eax,%r15d
  8c4218:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c421f:	0f 84 4e 0b 00 00    	je     8c4d73 <check_lower_drain+0x1393>
  8c4225:	31 c9                	xor    %ecx,%ecx
  8c4227:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c422d:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4233:	0f 86 91 0b 00 00    	jbe    8c4dca <check_lower_drain+0x13ea>
  8c4239:	e9 b5 0b 00 00       	jmp    8c4df3 <check_lower_drain+0x1413>
  8c423e:	8d 4d ff             	lea    -0x1(%rbp),%ecx
  8c4241:	80 f9 03             	cmp    $0x3,%cl
  8c4244:	0f 87 2b 10 00 00    	ja     8c5275 <check_lower_drain+0x1895>
  8c424a:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c4250:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4257:	0f 87 04 0c 00 00    	ja     8c4e61 <check_lower_drain+0x1481>
  8c425d:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4263:	0f 83 f8 0b 00 00    	jae    8c4e61 <check_lower_drain+0x1481>
  8c4269:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4270:	0f 85 cf 0f 00 00    	jne    8c5245 <check_lower_drain+0x1865>
  8c4276:	be 09 00 00 00       	mov    $0x9,%esi
  8c427b:	ba 05 00 00 00       	mov    $0x5,%edx
  8c4280:	48 89 df             	mov    %rbx,%rdi
  8c4283:	31 c9                	xor    %ecx,%ecx
  8c4285:	c5 f8 77             	vzeroupper
  8c4288:	e8 33 dc 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c428d:	40 b5 05             	mov    $0x5,%bpl
  8c4290:	e9 e0 0f 00 00       	jmp    8c5275 <check_lower_drain+0x1895>
  8c4295:	4d 85 ff             	test   %r15,%r15
  8c4298:	0f 84 8d 0a 00 00    	je     8c4d2b <check_lower_drain+0x134b>
  8c429e:	48 b9 00 00 00 00 00 	movabs $0x10000000000,%rcx
  8c42a5:	01 00 00 
  8c42a8:	49 85 cc             	test   %rcx,%r12
  8c42ab:	0f 95 c1             	setne  %cl
  8c42ae:	49 81 ff 01 01 00 00 	cmp    $0x101,%r15
  8c42b5:	0f 93 c2             	setae  %dl
  8c42b8:	08 ca                	or     %cl,%dl
  8c42ba:	0f 84 66 0b 00 00    	je     8c4e26 <check_lower_drain+0x1446>
  8c42c0:	44 8b b3 48 01 00 00 	mov    0x148(%rbx),%r14d
  8c42c7:	49 81 fe ff ff 00 00 	cmp    $0xffff,%r14
  8c42ce:	0f 87 b1 0e 00 00    	ja     8c5185 <check_lower_drain+0x17a5>
  8c42d4:	44 3b b3 4c 01 00 00 	cmp    0x14c(%rbx),%r14d
  8c42db:	0f 83 a4 0e 00 00    	jae    8c5185 <check_lower_drain+0x17a5>
  8c42e1:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8c42e8:	42 c6 04 30 08       	movb   $0x8,(%rax,%r14,1)
  8c42ed:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
  8c42f4:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c42f9:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
  8c4300:	42 c7 04 b0 00 00 00 	movl   $0x0,(%rax,%r14,4)
  8c4307:	00 
  8c4308:	48 8b 83 e0 00 00 00 	mov    0xe0(%rbx),%rax
  8c430f:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c4314:	48 8b 83 b0 00 00 00 	mov    0xb0(%rbx),%rax
  8c431b:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c4320:	ff 83 48 01 00 00    	incl   0x148(%rbx)
  8c4326:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c432a:	48 8b 00             	mov    (%rax),%rax
  8c432d:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4334:	0f 85 6c 0e 00 00    	jne    8c51a6 <check_lower_drain+0x17c6>
  8c433a:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  8c4341:	42 c6 04 30 08       	movb   $0x8,(%rax,%r14,1)
  8c4346:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8c434c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c4353:	01 00 00 
  8c4356:	49 85 c4             	test   %rax,%r12
  8c4359:	0f 85 60 0e 00 00    	jne    8c51bf <check_lower_drain+0x17df>
  8c435f:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4365:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c436b:	0f 86 6f 0e 00 00    	jbe    8c51e0 <check_lower_drain+0x1800>
  8c4371:	e9 9c 0e 00 00       	jmp    8c5212 <check_lower_drain+0x1832>
  8c4376:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c437b:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c4380:	4c 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%r14
  8c4387:	00 
  8c4388:	48 8d bc 24 00 02 00 	lea    0x200(%rsp),%rdi
  8c438f:	00 
  8c4390:	4c 89 f6             	mov    %r14,%rsi
  8c4393:	c5 f8 29 84 24 b0 00 	vmovaps %xmm0,0xb0(%rsp)
  8c439a:	00 00 
  8c439c:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c43a0:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  8c43a7:	00 
  8c43a8:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c43ae:	89 84 24 c8 00 00 00 	mov    %eax,0xc8(%rsp)
  8c43b5:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c43bb:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c43c0:	0f 43 c1             	cmovae %ecx,%eax
  8c43c3:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c43c8:	89 84 24 cc 00 00 00 	mov    %eax,0xcc(%rsp)
  8c43cf:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c43d6:	00 
  8c43d7:	c5 f8 29 84 24 d0 00 	vmovaps %xmm0,0xd0(%rsp)
  8c43de:	00 00 
  8c43e0:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c43e6:	89 84 24 e0 00 00 00 	mov    %eax,0xe0(%rsp)
  8c43ed:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c43f3:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c43f8:	0f 43 c1             	cmovae %ecx,%eax
  8c43fb:	89 84 24 e4 00 00 00 	mov    %eax,0xe4(%rsp)
  8c4402:	44 89 e0             	mov    %r12d,%eax
  8c4405:	48 6b d0 34          	imul   $0x34,%rax,%rdx
  8c4409:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c4410:	48 03 93 d0 01 00 00 	add    0x1d0(%rbx),%rdx
  8c4417:	83 f1 01             	xor    $0x1,%ecx
  8c441a:	c5 f8 77             	vzeroupper
  8c441d:	e8 0e 5b 98 00       	call   1249f30 <cbuiltin_varargs_append>
  8c4422:	e9 a4 f6 ff ff       	jmp    8c3acb <check_lower_drain+0xeb>
  8c4427:	48 8b 03             	mov    (%rbx),%rax
  8c442a:	44 89 e1             	mov    %r12d,%ecx
  8c442d:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c4434:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c4438:	48 8b 40 68          	mov    0x68(%rax),%rax
  8c443c:	48 8d 74 08 10       	lea    0x10(%rax,%rcx,1),%rsi
  8c4441:	48 89 df             	mov    %rbx,%rdi
  8c4444:	c5 f8 77             	vzeroupper
  8c4447:	e8 84 9c 00 00       	call   8ce0d0 <check_lower_constant>
  8c444c:	e9 a3 f6 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c4451:	8b ab 74 01 00 00    	mov    0x174(%rbx),%ebp
  8c4457:	89 e8                	mov    %ebp,%eax
  8c4459:	85 ed                	test   %ebp,%ebp
  8c445b:	75 5f                	jne    8c44bc <check_lower_drain+0xadc>
  8c445d:	8b 8b 44 01 00 00    	mov    0x144(%rbx),%ecx
  8c4463:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4469:	0f 83 cf 04 00 00    	jae    8c493e <check_lower_drain+0xf5e>
  8c446f:	48 8b 43 48          	mov    0x48(%rbx),%rax
  8c4473:	c7 04 88 ff ff ff ff 	movl   $0xffffffff,(%rax,%rcx,4)
  8c447a:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4481:	75 0b                	jne    8c448e <check_lower_drain+0xaae>
  8c4483:	48 8b 43 50          	mov    0x50(%rbx),%rax
  8c4487:	c7 04 88 ff ff ff ff 	movl   $0xffffffff,(%rax,%rcx,4)
  8c448e:	ff 83 44 01 00 00    	incl   0x144(%rbx)
  8c4494:	e9 cf 04 00 00       	jmp    8c4968 <check_lower_drain+0xf88>
  8c4499:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8c44a0:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c44a4:	48 8b 00             	mov    (%rax),%rax
  8c44a7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c44ae:	74 7c                	je     8c452c <check_lower_drain+0xb4c>
  8c44b0:	48 8b 43 58          	mov    0x58(%rbx),%rax
  8c44b4:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c44b8:	85 c0                	test   %eax,%eax
  8c44ba:	74 a1                	je     8c445d <check_lower_drain+0xa7d>
  8c44bc:	48 8b 4b 60          	mov    0x60(%rbx),%rcx
  8c44c0:	41 89 c6             	mov    %eax,%r14d
  8c44c3:	42 0f b6 04 31       	movzbl (%rcx,%r14,1),%eax
  8c44c8:	3c 0f                	cmp    $0xf,%al
  8c44ca:	73 d4                	jae    8c44a0 <check_lower_drain+0xac0>
  8c44cc:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c44d2:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8c44d8:	77 36                	ja     8c4510 <check_lower_drain+0xb30>
  8c44da:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c44e0:	73 2e                	jae    8c4510 <check_lower_drain+0xb30>
  8c44e2:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c44e9:	0f 85 7e 00 00 00    	jne    8c456d <check_lower_drain+0xb8d>
  8c44ef:	0f b6 d0             	movzbl %al,%edx
  8c44f2:	be 23 00 00 00       	mov    $0x23,%esi
  8c44f7:	48 89 df             	mov    %rbx,%rdi
  8c44fa:	31 c9                	xor    %ecx,%ecx
  8c44fc:	c5 f8 77             	vzeroupper
  8c44ff:	e8 bc d9 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c4504:	eb aa                	jmp    8c44b0 <check_lower_drain+0xad0>
  8c4506:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8c450d:	00 00 00 
  8c4510:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4514:	48 8b 00             	mov    (%rax),%rax
  8c4517:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c451e:	75 90                	jne    8c44b0 <check_lower_drain+0xad0>
  8c4520:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4527:	00 00 00 
  8c452a:	eb 2c                	jmp    8c4558 <check_lower_drain+0xb78>
  8c452c:	48 8d 0d a2 52 dc ff 	lea    -0x23ad5e(%rip),%rcx        # 6897d5 <fuzz_comment_end+0x26cbc>
  8c4533:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c453a:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c453e:	48 8b 01             	mov    (%rcx),%rax
  8c4541:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4548:	0f 85 62 ff ff ff    	jne    8c44b0 <check_lower_drain+0xad0>
  8c454e:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c4555:	00 00 00 
  8c4558:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c455e:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4562:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4568:	e9 43 ff ff ff       	jmp    8c44b0 <check_lower_drain+0xad0>
  8c456d:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c4571:	48 8b 12             	mov    (%rdx),%rdx
  8c4574:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c457b:	0f 85 2f ff ff ff    	jne    8c44b0 <check_lower_drain+0xad0>
  8c4581:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c4585:	c6 04 0a 23          	movb   $0x23,(%rdx,%rcx,1)
  8c4589:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c458d:	88 04 0a             	mov    %al,(%rdx,%rcx,1)
  8c4590:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c4594:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c459b:	00 
  8c459c:	ff c1                	inc    %ecx
  8c459e:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c45a4:	e9 07 ff ff ff       	jmp    8c44b0 <check_lower_drain+0xad0>
  8c45a9:	b8 03 06 00 00       	mov    $0x603,%eax
  8c45ae:	45 89 fe             	mov    %r15d,%r14d
  8c45b1:	41 83 e6 07          	and    $0x7,%r14d
  8c45b5:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  8c45bc:	00 00 00 00 00 
  8c45c1:	48 8d 94 24 c2 00 00 	lea    0xc2(%rsp),%rdx
  8c45c8:	00 
  8c45c9:	48 89 df             	mov    %rbx,%rdi
  8c45cc:	c4 c2 78 f7 c7       	bextr  %eax,%r15d,%eax
  8c45d1:	44 89 b4 24 b8 00 00 	mov    %r14d,0xb8(%rsp)
  8c45d8:	00 
  8c45d9:	41 8d 74 06 08       	lea    0x8(%r14,%rax,1),%esi
  8c45de:	8d 48 01             	lea    0x1(%rax),%ecx
  8c45e1:	89 8c 24 bc 00 00 00 	mov    %ecx,0xbc(%rsp)
  8c45e8:	44 89 f9             	mov    %r15d,%ecx
  8c45eb:	c1 e9 09             	shr    $0x9,%ecx
  8c45ee:	41 c1 ef 0d          	shr    $0xd,%r15d
  8c45f2:	80 e1 0f             	and    $0xf,%cl
  8c45f5:	c1 ee 03             	shr    $0x3,%esi
  8c45f8:	41 80 e7 01          	and    $0x1,%r15b
  8c45fc:	88 8c 24 c0 00 00 00 	mov    %cl,0xc0(%rsp)
  8c4603:	44 88 bc 24 c1 00 00 	mov    %r15b,0xc1(%rsp)
  8c460a:	00 
  8c460b:	66 c7 42 04 00 00    	movw   $0x0,0x4(%rdx)
  8c4611:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
  8c4617:	c5 f8 77             	vzeroupper
  8c461a:	e8 21 39 01 00       	call   8d7f40 <check_lower_bit_unit>
  8c461f:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  8c4626:	00 
  8c4627:	48 89 df             	mov    %rbx,%rdi
  8c462a:	44 89 f2             	mov    %r14d,%edx
  8c462d:	e8 ee 3f 01 00       	call   8d8620 <check_lower_bit_extract>
  8c4632:	e9 bd f4 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c4637:	48 89 df             	mov    %rbx,%rdi
  8c463a:	44 89 e6             	mov    %r12d,%esi
  8c463d:	4c 89 fa             	mov    %r15,%rdx
  8c4640:	c5 f8 77             	vzeroupper
  8c4643:	e8 d8 a7 00 00       	call   8cee20 <check_lower_address>
  8c4648:	e9 a7 f4 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c464d:	48 8b 03             	mov    (%rbx),%rax
  8c4650:	44 89 e1             	mov    %r12d,%ecx
  8c4653:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c4657:	44 89 fa             	mov    %r15d,%edx
  8c465a:	48 69 f2 b0 00 00 00 	imul   $0xb0,%rdx,%rsi
  8c4661:	49 c1 ef 20          	shr    $0x20,%r15
  8c4665:	48 89 df             	mov    %rbx,%rdi
  8c4668:	48 c1 e1 04          	shl    $0x4,%rcx
  8c466c:	48 8b 40 28          	mov    0x28(%rax),%rax
  8c4670:	48 8b 00             	mov    (%rax),%rax
  8c4673:	48 03 74 08 10       	add    0x10(%rax,%rcx,1),%rsi
  8c4678:	eb 4a                	jmp    8c46c4 <check_lower_drain+0xce4>
  8c467a:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c467e:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xb0(%rsp)
  8c4685:	b0 00 00 00 
  8c4689:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x120(%rsp)
  8c4690:	20 01 00 00 
  8c4694:	44 89 f8             	mov    %r15d,%eax
  8c4697:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xf0(%rsp)
  8c469e:	f0 00 00 00 
  8c46a2:	c7 84 24 b0 00 00 00 	movl   $0x2,0xb0(%rsp)
  8c46a9:	02 00 00 00 
  8c46ad:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  8c46b4:	00 
  8c46b5:	49 c1 ef 20          	shr    $0x20,%r15
  8c46b9:	48 89 df             	mov    %rbx,%rdi
  8c46bc:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  8c46c3:	00 
  8c46c4:	44 89 fa             	mov    %r15d,%edx
  8c46c7:	c5 f8 77             	vzeroupper
  8c46ca:	e8 d1 b1 00 00       	call   8cf8a0 <check_lower_fill>
  8c46cf:	e9 20 f4 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c46d4:	ba 07 00 00 00       	mov    $0x7,%edx
  8c46d9:	48 89 df             	mov    %rbx,%rdi
  8c46dc:	44 89 fe             	mov    %r15d,%esi
  8c46df:	c5 f8 77             	vzeroupper
  8c46e2:	e8 29 91 00 00       	call   8cd810 <check_lower_vla_size>
  8c46e7:	e9 08 f4 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c46ec:	b9 03 06 00 00       	mov    $0x603,%ecx
  8c46f1:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  8c46f8:	44 89 fa             	mov    %r15d,%edx
  8c46fb:	c1 ea 0d             	shr    $0xd,%edx
  8c46fe:	45 89 fd             	mov    %r15d,%r13d
  8c4701:	41 83 e5 07          	and    $0x7,%r13d
  8c4705:	48 8d b4 24 c2 00 00 	lea    0xc2(%rsp),%rsi
  8c470c:	00 
  8c470d:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  8c4714:	00 00 00 00 00 
  8c4719:	c4 c2 70 f7 ff       	bextr  %ecx,%r15d,%edi
  8c471e:	44 89 f9             	mov    %r15d,%ecx
  8c4721:	c1 e9 09             	shr    $0x9,%ecx
  8c4724:	80 e2 01             	and    $0x1,%dl
  8c4727:	44 89 ac 24 b8 00 00 	mov    %r13d,0xb8(%rsp)
  8c472e:	00 
  8c472f:	8d 6f 01             	lea    0x1(%rdi),%ebp
  8c4732:	80 e1 0f             	and    $0xf,%cl
  8c4735:	c4 42 d1 f7 f0       	shlx   %rbp,%r8,%r14
  8c473a:	83 fd 40             	cmp    $0x40,%ebp
  8c473d:	89 ac 24 bc 00 00 00 	mov    %ebp,0xbc(%rsp)
  8c4744:	88 8c 24 c0 00 00 00 	mov    %cl,0xc0(%rsp)
  8c474b:	88 94 24 c1 00 00 00 	mov    %dl,0xc1(%rsp)
  8c4752:	66 c7 46 04 00 00    	movw   $0x0,0x4(%rsi)
  8c4758:	c7 06 00 00 00 00    	movl   $0x0,(%rsi)
  8c475e:	49 f7 d6             	not    %r14
  8c4761:	4c 89 f6             	mov    %r14,%rsi
  8c4764:	49 0f 44 f0          	cmove  %r8,%rsi
  8c4768:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8c476d:	8b b3 48 01 00 00    	mov    0x148(%rbx),%esi
  8c4773:	48 81 fe ff ff 00 00 	cmp    $0xffff,%rsi
  8c477a:	0f 87 a1 02 00 00    	ja     8c4a21 <check_lower_drain+0x1041>
  8c4780:	3b b3 4c 01 00 00    	cmp    0x14c(%rbx),%esi
  8c4786:	0f 83 95 02 00 00    	jae    8c4a21 <check_lower_drain+0x1041>
  8c478c:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8c4793:	c6 04 30 08          	movb   $0x8,(%rax,%rsi,1)
  8c4797:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
  8c479e:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c47a2:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
  8c47a9:	c7 04 b0 00 00 00 00 	movl   $0x0,(%rax,%rsi,4)
  8c47b0:	48 8b 83 e0 00 00 00 	mov    0xe0(%rbx),%rax
  8c47b7:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c47bb:	48 8b 83 b0 00 00 00 	mov    0xb0(%rbx),%rax
  8c47c2:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c47c6:	ff 83 48 01 00 00    	incl   0x148(%rbx)
  8c47cc:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c47d0:	48 8b 00             	mov    (%rax),%rax
  8c47d3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c47da:	0f 85 62 02 00 00    	jne    8c4a42 <check_lower_drain+0x1062>
  8c47e0:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  8c47e7:	c6 04 30 08          	movb   $0x8,(%rax,%rsi,1)
  8c47eb:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c47f0:	80 f9 08             	cmp    $0x8,%cl
  8c47f3:	0f 84 8a 0c 00 00    	je     8c5483 <check_lower_drain+0x1aa3>
  8c47f9:	e9 52 02 00 00       	jmp    8c4a50 <check_lower_drain+0x1070>
  8c47fe:	83 ff 14             	cmp    $0x14,%edi
  8c4801:	0f 82 9f 02 00 00    	jb     8c4aa6 <check_lower_drain+0x10c6>
  8c4807:	0f 85 75 07 00 00    	jne    8c4f82 <check_lower_drain+0x15a2>
  8c480d:	c7 84 24 90 00 00 00 	movl   $0x14,0x90(%rsp)
  8c4814:	14 00 00 00 
  8c4818:	44 89 a4 24 94 00 00 	mov    %r12d,0x94(%rsp)
  8c481f:	00 
  8c4820:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  8c4827:	00 00 00 00 00 
  8c482c:	e9 77 07 00 00       	jmp    8c4fa8 <check_lower_drain+0x15c8>
  8c4831:	44 38 f5             	cmp    %r14b,%bpl
  8c4834:	0f 84 ba f2 ff ff    	je     8c3af4 <check_lower_drain+0x114>
  8c483a:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c4840:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4847:	0f 87 99 0b 00 00    	ja     8c53e6 <check_lower_drain+0x1a06>
  8c484d:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4853:	0f 83 8d 0b 00 00    	jae    8c53e6 <check_lower_drain+0x1a06>
  8c4859:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4860:	0f 85 3d 19 00 00    	jne    8c61a3 <check_lower_drain+0x27c3>
  8c4866:	41 0f b6 d6          	movzbl %r14b,%edx
  8c486a:	48 89 df             	mov    %rbx,%rdi
  8c486d:	be 09 00 00 00       	mov    $0x9,%esi
  8c4872:	e9 59 0b 00 00       	jmp    8c53d0 <check_lower_drain+0x19f0>
  8c4877:	31 c0                	xor    %eax,%eax
  8c4879:	40 80 fd 0c          	cmp    $0xc,%bpl
  8c487d:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4883:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  8c4889:	48 89 df             	mov    %rbx,%rdi
  8c488c:	0f 95 c0             	setne  %al
  8c488f:	31 c9                	xor    %ecx,%ecx
  8c4891:	41 80 fe 0a          	cmp    $0xa,%r14b
  8c4895:	0f 95 c1             	setne  %cl
  8c4898:	41 80 fe 09          	cmp    $0x9,%r14b
  8c489c:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c489f:	8d 14 cd a0 00 00 00 	lea    0xa0(,%rcx,8),%edx
  8c48a6:	8d 71 01             	lea    0x1(%rcx),%esi
  8c48a9:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c48ae:	0f 44 d1             	cmove  %ecx,%edx
  8c48b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c48b6:	0f 44 f1             	cmove  %ecx,%esi
  8c48b9:	48 8d 8c 24 b0 00 00 	lea    0xb0(%rsp),%rcx
  8c48c0:	00 
  8c48c1:	8d 74 06 05          	lea    0x5(%rsi,%rax,1),%esi
  8c48c5:	e8 76 0a 01 00       	call   8d5340 <check_lower_runtime_call>
  8c48ca:	41 89 c4             	mov    %eax,%r12d
  8c48cd:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c48d3:	45 89 ff             	mov    %r15d,%r15d
  8c48d6:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c48dc:	77 2d                	ja     8c490b <check_lower_drain+0xf2b>
  8c48de:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c48e4:	73 25                	jae    8c490b <check_lower_drain+0xf2b>
  8c48e6:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c48ed:	0f 85 05 03 00 00    	jne    8c4bf8 <check_lower_drain+0x1218>
  8c48f3:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c48f8:	48 89 df             	mov    %rbx,%rdi
  8c48fb:	44 89 ea             	mov    %r13d,%edx
  8c48fe:	4c 89 f9             	mov    %r15,%rcx
  8c4901:	e8 ba d5 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c4906:	e9 1d 03 00 00       	jmp    8c4c28 <check_lower_drain+0x1248>
  8c490b:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c490f:	48 8b 00             	mov    (%rax),%rax
  8c4912:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4919:	0f 85 09 03 00 00    	jne    8c4c28 <check_lower_drain+0x1248>
  8c491f:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4926:	00 00 00 
  8c4929:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c492f:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4933:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4939:	e9 ea 02 00 00       	jmp    8c4c28 <check_lower_drain+0x1248>
  8c493e:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4942:	48 8b 00             	mov    (%rax),%rax
  8c4945:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c494c:	75 1a                	jne    8c4968 <check_lower_drain+0xf88>
  8c494e:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4955:	00 00 00 
  8c4958:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c495e:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c4962:	89 82 f4 00 00 00    	mov    %eax,0xf4(%rdx)
  8c4968:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c496e:	48 8b 53 48          	mov    0x48(%rbx),%rdx
  8c4972:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  8c4975:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c497c:	75 3d                	jne    8c49bb <check_lower_drain+0xfdb>
  8c497e:	48 8b 53 50          	mov    0x50(%rbx),%rdx
  8c4982:	80 bb 7c 01 00 00 00 	cmpb   $0x0,0x17c(%rbx)
  8c4989:	75 14                	jne    8c499f <check_lower_drain+0xfbf>
  8c498b:	8b 34 8a             	mov    (%rdx,%rcx,4),%esi
  8c498e:	bf 00 00 00 00       	mov    $0x0,%edi
  8c4993:	83 fe ff             	cmp    $0xffffffff,%esi
  8c4996:	0f 44 f7             	cmove  %edi,%esi
  8c4999:	89 b3 74 01 00 00    	mov    %esi,0x174(%rbx)
  8c499f:	83 3c 8a ff          	cmpl   $0xffffffff,(%rdx,%rcx,4)
  8c49a3:	75 0f                	jne    8c49b4 <check_lower_drain+0xfd4>
  8c49a5:	8b 83 74 01 00 00    	mov    0x174(%rbx),%eax
  8c49ab:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  8c49ae:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c49b4:	c6 83 7c 01 00 00 01 	movb   $0x1,0x17c(%rbx)
  8c49bb:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  8c49c0:	77 2c                	ja     8c49ee <check_lower_drain+0x100e>
  8c49c2:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c49c8:	73 24                	jae    8c49ee <check_lower_drain+0x100e>
  8c49ca:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c49d1:	0f 85 b9 04 00 00    	jne    8c4e90 <check_lower_drain+0x14b0>
  8c49d7:	be 26 00 00 00       	mov    $0x26,%esi
  8c49dc:	48 89 df             	mov    %rbx,%rdi
  8c49df:	31 d2                	xor    %edx,%edx
  8c49e1:	c5 f8 77             	vzeroupper
  8c49e4:	e8 d7 d4 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c49e9:	e9 1d 05 00 00       	jmp    8c4f0b <check_lower_drain+0x152b>
  8c49ee:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c49f2:	48 8b 00             	mov    (%rax),%rax
  8c49f5:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c49fc:	0f 85 09 05 00 00    	jne    8c4f0b <check_lower_drain+0x152b>
  8c4a02:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4a09:	00 00 00 
  8c4a0c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4a12:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4a16:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4a1c:	e9 ea 04 00 00       	jmp    8c4f0b <check_lower_drain+0x152b>
  8c4a21:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4a28:	0f 84 24 07 00 00    	je     8c5152 <check_lower_drain+0x1772>
  8c4a2e:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4a32:	48 8b 00             	mov    (%rax),%rax
  8c4a35:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4a3c:	0f 84 9e fd ff ff    	je     8c47e0 <check_lower_drain+0xe00>
  8c4a42:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c4a47:	80 f9 08             	cmp    $0x8,%cl
  8c4a4a:	0f 84 33 0a 00 00    	je     8c5483 <check_lower_drain+0x1aa3>
  8c4a50:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4a56:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4a5c:	0f 87 ed 04 00 00    	ja     8c4f4f <check_lower_drain+0x156f>
  8c4a62:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4a68:	0f 83 e1 04 00 00    	jae    8c4f4f <check_lower_drain+0x156f>
  8c4a6e:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4a75:	0f 85 d4 09 00 00    	jne    8c544f <check_lower_drain+0x1a6f>
  8c4a7b:	be 09 00 00 00       	mov    $0x9,%esi
  8c4a80:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4a85:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8c4a8a:	48 89 df             	mov    %rbx,%rdi
  8c4a8d:	31 c9                	xor    %ecx,%ecx
  8c4a8f:	c5 f8 77             	vzeroupper
  8c4a92:	e8 29 d4 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c4a97:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4a9c:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c4aa1:	e9 dd 09 00 00       	jmp    8c5483 <check_lower_drain+0x1aa3>
  8c4aa6:	80 bb f8 01 00 00 00 	cmpb   $0x0,0x1f8(%rbx)
  8c4aad:	0f 85 a6 1e 00 00    	jne    8c6959 <check_lower_drain+0x2f79>
  8c4ab3:	4c 8b 9b a8 01 00 00 	mov    0x1a8(%rbx),%r11
  8c4aba:	48 b9 00 00 00 00 00 	movabs $0x40000000000,%rcx
  8c4ac1:	04 00 00 
  8c4ac4:	4d 85 db             	test   %r11,%r11
  8c4ac7:	0f 94 c0             	sete   %al
  8c4aca:	49 85 cc             	test   %rcx,%r12
  8c4acd:	0f 95 c1             	setne  %cl
  8c4ad0:	08 c1                	or     %al,%cl
  8c4ad2:	0f 85 01 1e 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c4ad8:	4c 8b 03             	mov    (%rbx),%r8
  8c4adb:	44 89 e7             	mov    %r12d,%edi
  8c4ade:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  8c4ae2:	48 c1 e1 05          	shl    $0x5,%rcx
  8c4ae6:	49 8b 00             	mov    (%r8),%rax
  8c4ae9:	49 8b 70 08          	mov    0x8(%r8),%rsi
  8c4aed:	4c 8b 10             	mov    (%rax),%r10
  8c4af0:	48 03 4e 08          	add    0x8(%rsi),%rcx
  8c4af4:	45 8b 0c ba          	mov    (%r10,%rdi,4),%r9d
  8c4af8:	45 85 c9             	test   %r9d,%r9d
  8c4afb:	74 5e                	je     8c4b5b <check_lower_drain+0x117b>
  8c4afd:	48 be 00 00 00 00 00 	movabs $0x10000000000,%rsi
  8c4b04:	01 00 00 
  8c4b07:	49 85 f4             	test   %rsi,%r12
  8c4b0a:	0f 85 c9 1d 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c4b10:	83 79 0c 00          	cmpl   $0x0,0xc(%rcx)
  8c4b14:	0f 84 bf 1d 00 00    	je     8c68d9 <check_lower_drain+0x2ef9>
  8c4b1a:	83 79 54 00          	cmpl   $0x0,0x54(%rcx)
  8c4b1e:	0f 85 b5 1d 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c4b24:	0f b7 71 08          	movzwl 0x8(%rcx),%esi
  8c4b28:	f7 c6 10 08 00 00    	test   $0x810,%esi
  8c4b2e:	0f 85 a5 1d 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c4b34:	83 79 04 00          	cmpl   $0x0,0x4(%rcx)
  8c4b38:	0f 85 9b 1d 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c4b3e:	41 83 f9 3e          	cmp    $0x3e,%r9d
  8c4b42:	77 17                	ja     8c4b5b <check_lower_drain+0x117b>
  8c4b44:	49 ba 00 00 00 00 08 	movabs $0x4080000800000000,%r10
  8c4b4b:	00 80 40 
  8c4b4e:	44 89 ce             	mov    %r9d,%esi
  8c4b51:	49 0f a3 f2          	bt     %rsi,%r10
  8c4b55:	0f 82 7e 1d 00 00    	jb     8c68d9 <check_lower_drain+0x2ef9>
  8c4b5b:	8b 71 40             	mov    0x40(%rcx),%esi
  8c4b5e:	48 85 f6             	test   %rsi,%rsi
  8c4b61:	0f 84 af 1b 00 00    	je     8c6716 <check_lower_drain+0x2d36>
  8c4b67:	45 8b b0 c0 00 00 00 	mov    0xc0(%r8),%r14d
  8c4b6e:	49 bf 00 00 00 00 00 	movabs $0x20000000000,%r15
  8c4b75:	02 00 00 
  8c4b78:	44 39 f6             	cmp    %r14d,%esi
  8c4b7b:	41 0f 92 c2          	setb   %r10b
  8c4b7f:	31 ed                	xor    %ebp,%ebp
  8c4b81:	4d 85 fc             	test   %r15,%r12
  8c4b84:	0f 85 91 1b 00 00    	jne    8c671b <check_lower_drain+0x2d3b>
  8c4b8a:	45 85 c9             	test   %r9d,%r9d
  8c4b8d:	0f 85 88 1b 00 00    	jne    8c671b <check_lower_drain+0x2d3b>
  8c4b93:	44 39 f6             	cmp    %r14d,%esi
  8c4b96:	0f 83 7f 1b 00 00    	jae    8c671b <check_lower_drain+0x2d3b>
  8c4b9c:	4c 8b b8 90 02 00 00 	mov    0x290(%rax),%r15
  8c4ba3:	44 8d 76 ff          	lea    -0x1(%rsi),%r14d
  8c4ba7:	41 b2 01             	mov    $0x1,%r10b
  8c4baa:	43 80 3c 37 00       	cmpb   $0x0,(%r15,%r14,1)
  8c4baf:	0f 84 64 1b 00 00    	je     8c6719 <check_lower_drain+0x2d39>
  8c4bb5:	4c 8b b8 78 02 00 00 	mov    0x278(%rax),%r15
  8c4bbc:	43 80 3c 37 00       	cmpb   $0x0,(%r15,%r14,1)
  8c4bc1:	40 0f 94 c5          	sete   %bpl
  8c4bc5:	e9 51 1b 00 00       	jmp    8c671b <check_lower_drain+0x2d3b>
  8c4bca:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4bd1:	0f 85 1d ef ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c4bd7:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c4bdb:	c6 04 08 23          	movb   $0x23,(%rax,%rcx,1)
  8c4bdf:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c4be3:	40 88 2c 08          	mov    %bpl,(%rax,%rcx,1)
  8c4be7:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c4beb:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c4bf2:	00 
  8c4bf3:	e9 75 f5 ff ff       	jmp    8c416d <check_lower_drain+0x78d>
  8c4bf8:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c4bfc:	48 8b 09             	mov    (%rcx),%rcx
  8c4bff:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4c06:	75 20                	jne    8c4c28 <check_lower_drain+0x1248>
  8c4c08:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4c0c:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c4c10:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4c14:	40 88 2c 01          	mov    %bpl,(%rcx,%rax,1)
  8c4c18:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4c1c:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c4c20:	ff c0                	inc    %eax
  8c4c22:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4c28:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4c2e:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4c34:	77 28                	ja     8c4c5e <check_lower_drain+0x127e>
  8c4c36:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4c3c:	73 20                	jae    8c4c5e <check_lower_drain+0x127e>
  8c4c3e:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4c45:	75 43                	jne    8c4c8a <check_lower_drain+0x12aa>
  8c4c47:	be 03 00 00 00       	mov    $0x3,%esi
  8c4c4c:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4c51:	48 89 df             	mov    %rbx,%rdi
  8c4c54:	4c 89 f9             	mov    %r15,%rcx
  8c4c57:	e8 64 d2 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c4c5c:	eb 5c                	jmp    8c4cba <check_lower_drain+0x12da>
  8c4c5e:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4c62:	48 8b 00             	mov    (%rax),%rax
  8c4c65:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4c6c:	75 4c                	jne    8c4cba <check_lower_drain+0x12da>
  8c4c6e:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4c75:	00 00 00 
  8c4c78:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4c7e:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4c82:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4c88:	eb 30                	jmp    8c4cba <check_lower_drain+0x12da>
  8c4c8a:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c4c8e:	48 8b 09             	mov    (%rcx),%rcx
  8c4c91:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4c98:	75 20                	jne    8c4cba <check_lower_drain+0x12da>
  8c4c9a:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4c9e:	c6 04 01 03          	movb   $0x3,(%rcx,%rax,1)
  8c4ca2:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4ca6:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c4caa:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4cae:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c4cb2:	ff c0                	inc    %eax
  8c4cb4:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4cba:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4cc0:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4cc6:	0f 87 ab 03 00 00    	ja     8c5077 <check_lower_drain+0x1697>
  8c4ccc:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4cd2:	0f 83 9f 03 00 00    	jae    8c5077 <check_lower_drain+0x1697>
  8c4cd8:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4cdf:	75 19                	jne    8c4cfa <check_lower_drain+0x131a>
  8c4ce1:	41 0f b6 d6          	movzbl %r14b,%edx
  8c4ce5:	be 22 00 00 00       	mov    $0x22,%esi
  8c4cea:	48 89 df             	mov    %rbx,%rdi
  8c4ced:	4c 89 e1             	mov    %r12,%rcx
  8c4cf0:	e8 cb d1 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c4cf5:	e9 fa ed ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c4cfa:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c4cfe:	48 8b 09             	mov    (%rcx),%rcx
  8c4d01:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4d08:	0f 85 e6 ed ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c4d0e:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4d12:	c6 04 01 22          	movb   $0x22,(%rcx,%rax,1)
  8c4d16:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4d1a:	44 88 34 01          	mov    %r14b,(%rcx,%rax,1)
  8c4d1e:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4d22:	4c 89 24 c1          	mov    %r12,(%rcx,%rax,8)
  8c4d26:	e9 17 07 00 00       	jmp    8c5442 <check_lower_drain+0x1a62>
  8c4d2b:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c4d31:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4d38:	0f 87 e8 03 00 00    	ja     8c5126 <check_lower_drain+0x1746>
  8c4d3e:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4d44:	0f 83 dc 03 00 00    	jae    8c5126 <check_lower_drain+0x1746>
  8c4d4a:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4d51:	0f 85 6e 14 00 00    	jne    8c61c5 <check_lower_drain+0x27e5>
  8c4d57:	be 23 00 00 00       	mov    $0x23,%esi
  8c4d5c:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4d61:	48 89 df             	mov    %rbx,%rdi
  8c4d64:	31 c9                	xor    %ecx,%ecx
  8c4d66:	c5 f8 77             	vzeroupper
  8c4d69:	e8 52 d1 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c4d6e:	e9 7f 14 00 00       	jmp    8c61f2 <check_lower_drain+0x2812>
  8c4d73:	31 c0                	xor    %eax,%eax
  8c4d75:	41 80 fe 0c          	cmp    $0xc,%r14b
  8c4d79:	be 00 00 00 00       	mov    $0x0,%esi
  8c4d7e:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4d84:	48 89 df             	mov    %rbx,%rdi
  8c4d87:	45 89 f9             	mov    %r15d,%r9d
  8c4d8a:	0f 95 c0             	setne  %al
  8c4d8d:	31 c9                	xor    %ecx,%ecx
  8c4d8f:	40 80 fd 0a          	cmp    $0xa,%bpl
  8c4d93:	0f 95 c1             	setne  %cl
  8c4d96:	8d 14 c5 70 00 00 00 	lea    0x70(,%rax,8),%edx
  8c4d9d:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c4da0:	ff c1                	inc    %ecx
  8c4da2:	40 80 fd 09          	cmp    $0x9,%bpl
  8c4da6:	0f 44 ce             	cmove  %esi,%ecx
  8c4da9:	8d 74 01 0b          	lea    0xb(%rcx,%rax,1),%esi
  8c4dad:	48 8d 8c 24 b0 00 00 	lea    0xb0(%rsp),%rcx
  8c4db4:	00 
  8c4db5:	e8 86 05 01 00       	call   8d5340 <check_lower_runtime_call>
  8c4dba:	89 c1                	mov    %eax,%ecx
  8c4dbc:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4dc2:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4dc8:	77 29                	ja     8c4df3 <check_lower_drain+0x1413>
  8c4dca:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4dd0:	73 21                	jae    8c4df3 <check_lower_drain+0x1413>
  8c4dd2:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4dd9:	0f 85 31 02 00 00    	jne    8c5010 <check_lower_drain+0x1630>
  8c4ddf:	be 22 00 00 00       	mov    $0x22,%esi
  8c4de4:	48 89 df             	mov    %rbx,%rdi
  8c4de7:	31 d2                	xor    %edx,%edx
  8c4de9:	e8 d2 d0 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c4dee:	e9 4d 02 00 00       	jmp    8c5040 <check_lower_drain+0x1660>
  8c4df3:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4df7:	48 8b 00             	mov    (%rax),%rax
  8c4dfa:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4e01:	0f 85 39 02 00 00    	jne    8c5040 <check_lower_drain+0x1660>
  8c4e07:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4e0e:	00 00 00 
  8c4e11:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4e17:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4e1b:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4e21:	e9 1a 02 00 00       	jmp    8c5040 <check_lower_drain+0x1660>
  8c4e26:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c4e2c:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4e33:	0f 87 ad 05 00 00    	ja     8c53e6 <check_lower_drain+0x1a06>
  8c4e39:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4e3f:	0f 83 a1 05 00 00    	jae    8c53e6 <check_lower_drain+0x1a06>
  8c4e45:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4e4c:	0f 85 8d 15 00 00    	jne    8c63df <check_lower_drain+0x29ff>
  8c4e52:	48 89 df             	mov    %rbx,%rdi
  8c4e55:	be 29 00 00 00       	mov    $0x29,%esi
  8c4e5a:	31 d2                	xor    %edx,%edx
  8c4e5c:	e9 51 f0 ff ff       	jmp    8c3eb2 <check_lower_drain+0x4d2>
  8c4e61:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4e68:	40 b5 05             	mov    $0x5,%bpl
  8c4e6b:	0f 85 04 04 00 00    	jne    8c5275 <check_lower_drain+0x1895>
  8c4e71:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4e78:	00 00 00 
  8c4e7b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4e81:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4e85:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4e8b:	e9 e5 03 00 00       	jmp    8c5275 <check_lower_drain+0x1895>
  8c4e90:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c4e94:	48 8b 12             	mov    (%rdx),%rdx
  8c4e97:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c4e9e:	75 6b                	jne    8c4f0b <check_lower_drain+0x152b>
  8c4ea0:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c4ea4:	89 c6                	mov    %eax,%esi
  8c4ea6:	ff c0                	inc    %eax
  8c4ea8:	c6 04 32 26          	movb   $0x26,(%rdx,%rsi,1)
  8c4eac:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c4eb0:	c6 04 32 00          	movb   $0x0,(%rdx,%rsi,1)
  8c4eb4:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c4eb8:	48 89 0c f2          	mov    %rcx,(%rdx,%rsi,8)
  8c4ebc:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4ec2:	eb 47                	jmp    8c4f0b <check_lower_drain+0x152b>
  8c4ec4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c4ecb:	00 00 00 00 00 
  8c4ed0:	48 8b 73 60          	mov    0x60(%rbx),%rsi
  8c4ed4:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c4ed8:	8d 79 01             	lea    0x1(%rcx),%edi
  8c4edb:	48 c1 e1 04          	shl    $0x4,%rcx
  8c4edf:	0f b6 34 06          	movzbl (%rsi,%rax,1),%esi
  8c4ee3:	89 bb 3c 01 00 00    	mov    %edi,0x13c(%rbx)
  8c4ee9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8c4eee:	48 c1 e6 30          	shl    $0x30,%rsi
  8c4ef2:	48 8d 74 37 02       	lea    0x2(%rdi,%rsi,1),%rsi
  8c4ef7:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c4efb:	48 c7 44 0a 08 00 00 	movq   $0x0,0x8(%rdx,%rcx,1)
  8c4f02:	00 00 
  8c4f04:	48 8b 4b 58          	mov    0x58(%rbx),%rcx
  8c4f08:	8b 2c 81             	mov    (%rcx,%rax,4),%ebp
  8c4f0b:	85 ed                	test   %ebp,%ebp
  8c4f0d:	0f 84 e1 eb ff ff    	je     8c3af4 <check_lower_drain+0x114>
  8c4f13:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c4f19:	89 e8                	mov    %ebp,%eax
  8c4f1b:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4f21:	72 ad                	jb     8c4ed0 <check_lower_drain+0x14f0>
  8c4f23:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c4f27:	48 8b 09             	mov    (%rcx),%rcx
  8c4f2a:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4f31:	75 d1                	jne    8c4f04 <check_lower_drain+0x1524>
  8c4f33:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c4f3a:	00 00 00 
  8c4f3d:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c4f43:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c4f47:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c4f4d:	eb b5                	jmp    8c4f04 <check_lower_drain+0x1524>
  8c4f4f:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4f53:	48 8b 00             	mov    (%rax),%rax
  8c4f56:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4f5d:	0f 85 20 05 00 00    	jne    8c5483 <check_lower_drain+0x1aa3>
  8c4f63:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4f6a:	00 00 00 
  8c4f6d:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4f73:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4f77:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4f7d:	e9 01 05 00 00       	jmp    8c5483 <check_lower_drain+0x1aa3>
  8c4f82:	89 bc 24 90 00 00 00 	mov    %edi,0x90(%rsp)
  8c4f89:	44 89 a4 24 94 00 00 	mov    %r12d,0x94(%rsp)
  8c4f90:	00 
  8c4f91:	44 89 bc 24 98 00 00 	mov    %r15d,0x98(%rsp)
  8c4f98:	00 
  8c4f99:	c7 84 24 9c 00 00 00 	movl   $0x0,0x9c(%rsp)
  8c4fa0:	00 00 00 00 
  8c4fa4:	49 c1 ef 20          	shr    $0x20,%r15
  8c4fa8:	4c 89 e0             	mov    %r12,%rax
  8c4fab:	48 c1 e8 28          	shr    $0x28,%rax
  8c4faf:	4c 89 bc 24 a0 00 00 	mov    %r15,0xa0(%rsp)
  8c4fb6:	00 
  8c4fb7:	48 8d 8c 24 ab 00 00 	lea    0xab(%rsp),%rcx
  8c4fbe:	00 
  8c4fbf:	48 89 df             	mov    %rbx,%rdi
  8c4fc2:	24 01                	and    $0x1,%al
  8c4fc4:	88 84 24 a8 00 00 00 	mov    %al,0xa8(%rsp)
  8c4fcb:	4c 89 e0             	mov    %r12,%rax
  8c4fce:	48 c1 e8 29          	shr    $0x29,%rax
  8c4fd2:	49 c1 ec 2a          	shr    $0x2a,%r12
  8c4fd6:	24 01                	and    $0x1,%al
  8c4fd8:	41 80 e4 01          	and    $0x1,%r12b
  8c4fdc:	88 84 24 a9 00 00 00 	mov    %al,0xa9(%rsp)
  8c4fe3:	44 88 a4 24 aa 00 00 	mov    %r12b,0xaa(%rsp)
  8c4fea:	00 
  8c4feb:	c6 41 04 00          	movb   $0x0,0x4(%rcx)
  8c4fef:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c4ff5:	c5 fe 6f 84 24 90 00 	vmovdqu 0x90(%rsp),%ymm0
  8c4ffc:	00 00 
  8c4ffe:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c5003:	c5 f8 77             	vzeroupper
  8c5006:	e8 c5 b7 00 00       	call   8d07d0 <check_lower_complex_task>
  8c500b:	e9 e4 ea ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c5010:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c5014:	48 8b 12             	mov    (%rdx),%rdx
  8c5017:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c501e:	75 20                	jne    8c5040 <check_lower_drain+0x1660>
  8c5020:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c5024:	c6 04 02 22          	movb   $0x22,(%rdx,%rax,1)
  8c5028:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c502c:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
  8c5030:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c5034:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c5038:	ff c0                	inc    %eax
  8c503a:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5040:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5046:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c504c:	77 29                	ja     8c5077 <check_lower_drain+0x1697>
  8c504e:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5054:	73 21                	jae    8c5077 <check_lower_drain+0x1697>
  8c5056:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c505d:	44 89 f9             	mov    %r15d,%ecx
  8c5060:	75 2e                	jne    8c5090 <check_lower_drain+0x16b0>
  8c5062:	be 02 00 00 00       	mov    $0x2,%esi
  8c5067:	48 89 df             	mov    %rbx,%rdi
  8c506a:	44 89 e2             	mov    %r12d,%edx
  8c506d:	e8 4e ce 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5072:	e9 7d ea ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c5077:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c507b:	48 8b 00             	mov    (%rax),%rax
  8c507e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5085:	0f 85 69 ea ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c508b:	e9 63 03 00 00       	jmp    8c53f3 <check_lower_drain+0x1a13>
  8c5090:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c5094:	48 8b 12             	mov    (%rdx),%rdx
  8c5097:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c509e:	0f 85 50 ea ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c50a4:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c50a8:	c6 04 02 02          	movb   $0x2,(%rdx,%rax,1)
  8c50ac:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c50b0:	44 88 34 02          	mov    %r14b,(%rdx,%rax,1)
  8c50b4:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c50b8:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c50bc:	e9 81 03 00 00       	jmp    8c5442 <check_lower_drain+0x1a62>
  8c50c1:	89 f1                	mov    %esi,%ecx
  8c50c3:	4c 8d 05 f1 d9 e2 ff 	lea    -0x1d260f(%rip),%r8        # 6f2abb <pp_string_value.meaning+0x3efe4>
  8c50ca:	80 e1 fe             	and    $0xfe,%cl
  8c50cd:	80 f9 0c             	cmp    $0xc,%cl
  8c50d0:	74 1d                	je     8c50ef <check_lower_drain+0x170f>
  8c50d2:	4c 8d 05 67 27 e2 ff 	lea    -0x1dd899(%rip),%r8        # 6e7840 <pp_string_value.meaning+0x33d69>
  8c50d9:	40 80 fe 0e          	cmp    $0xe,%sil
  8c50dd:	74 10                	je     8c50ef <check_lower_drain+0x170f>
  8c50df:	4c 8d 05 ca 6b d2 ff 	lea    -0x2d9436(%rip),%r8        # 5ebcb0 <parse_test_openers+0x1f9b3>
  8c50e6:	80 f9 10             	cmp    $0x10,%cl
  8c50e9:	0f 85 10 16 00 00    	jne    8c66ff <check_lower_drain+0x2d1f>
  8c50ef:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c50f6:	0f 85 f8 e9 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c50fc:	4c 89 80 00 01 00 00 	mov    %r8,0x100(%rax)
  8c5103:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5107:	48 8b 00             	mov    (%rax),%rax
  8c510a:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5111:	0f 85 dd e9 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c5117:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c511e:	00 00 00 
  8c5121:	e9 d7 02 00 00       	jmp    8c53fd <check_lower_drain+0x1a1d>
  8c5126:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c512d:	0f 85 bf 10 00 00    	jne    8c61f2 <check_lower_drain+0x2812>
  8c5133:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c513a:	00 00 00 
  8c513d:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5143:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5147:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c514d:	e9 a0 10 00 00       	jmp    8c61f2 <check_lower_drain+0x2812>
  8c5152:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5159:	00 00 00 
  8c515c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5162:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c5166:	89 82 f4 00 00 00    	mov    %eax,0xf4(%rdx)
  8c516c:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5170:	48 8b 00             	mov    (%rax),%rax
  8c5173:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c517a:	0f 85 c2 f8 ff ff    	jne    8c4a42 <check_lower_drain+0x1062>
  8c5180:	e9 5b f6 ff ff       	jmp    8c47e0 <check_lower_drain+0xe00>
  8c5185:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c518c:	0f 84 3a 15 00 00    	je     8c66cc <check_lower_drain+0x2cec>
  8c5192:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5196:	48 8b 00             	mov    (%rax),%rax
  8c5199:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c51a0:	0f 84 94 f1 ff ff    	je     8c433a <check_lower_drain+0x95a>
  8c51a6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8c51ac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c51b3:	01 00 00 
  8c51b6:	49 85 c4             	test   %rax,%r12
  8c51b9:	0f 84 a0 f1 ff ff    	je     8c435f <check_lower_drain+0x97f>
  8c51bf:	be 08 00 00 00       	mov    $0x8,%esi
  8c51c4:	48 89 df             	mov    %rbx,%rdi
  8c51c7:	c5 f8 77             	vzeroupper
  8c51ca:	e8 51 93 ff ff       	call   8be520 <check_lower_temporary>
  8c51cf:	41 89 c5             	mov    %eax,%r13d
  8c51d2:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c51d8:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c51de:	77 32                	ja     8c5212 <check_lower_drain+0x1832>
  8c51e0:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c51e6:	73 2a                	jae    8c5212 <check_lower_drain+0x1832>
  8c51e8:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c51ef:	0f 85 0c 12 00 00    	jne    8c6401 <check_lower_drain+0x2a21>
  8c51f5:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c51fa:	ba 08 00 00 00       	mov    $0x8,%edx
  8c51ff:	48 89 df             	mov    %rbx,%rdi
  8c5202:	4c 89 f1             	mov    %r14,%rcx
  8c5205:	c5 f8 77             	vzeroupper
  8c5208:	e8 b3 cc 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c520d:	e9 1f 12 00 00       	jmp    8c6431 <check_lower_drain+0x2a51>
  8c5212:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5216:	48 8b 00             	mov    (%rax),%rax
  8c5219:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5220:	0f 85 0b 12 00 00    	jne    8c6431 <check_lower_drain+0x2a51>
  8c5226:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c522d:	00 00 00 
  8c5230:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5236:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c523a:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5240:	e9 ec 11 00 00       	jmp    8c6431 <check_lower_drain+0x2a51>
  8c5245:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c524c:	40 b5 05             	mov    $0x5,%bpl
  8c524f:	75 24                	jne    8c5275 <check_lower_drain+0x1895>
  8c5251:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c5255:	c6 04 08 09          	movb   $0x9,(%rax,%rcx,1)
  8c5259:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c525d:	c6 04 08 05          	movb   $0x5,(%rax,%rcx,1)
  8c5261:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c5265:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c526c:	00 
  8c526d:	ff c1                	inc    %ecx
  8c526f:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c5275:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c527b:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5281:	77 29                	ja     8c52ac <check_lower_drain+0x18cc>
  8c5283:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5289:	73 21                	jae    8c52ac <check_lower_drain+0x18cc>
  8c528b:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5292:	75 44                	jne    8c52d8 <check_lower_drain+0x18f8>
  8c5294:	40 0f b6 d5          	movzbl %bpl,%edx
  8c5298:	be 01 00 00 00       	mov    $0x1,%esi
  8c529d:	48 89 df             	mov    %rbx,%rdi
  8c52a0:	31 c9                	xor    %ecx,%ecx
  8c52a2:	c5 f8 77             	vzeroupper
  8c52a5:	e8 16 cc 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c52aa:	eb 60                	jmp    8c530c <check_lower_drain+0x192c>
  8c52ac:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c52b0:	48 8b 00             	mov    (%rax),%rax
  8c52b3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c52ba:	75 50                	jne    8c530c <check_lower_drain+0x192c>
  8c52bc:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c52c3:	00 00 00 
  8c52c6:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c52cc:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c52d0:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c52d6:	eb 34                	jmp    8c530c <check_lower_drain+0x192c>
  8c52d8:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c52dc:	48 8b 09             	mov    (%rcx),%rcx
  8c52df:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c52e6:	75 24                	jne    8c530c <check_lower_drain+0x192c>
  8c52e8:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c52ec:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c52f0:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c52f4:	40 88 2c 01          	mov    %bpl,(%rcx,%rax,1)
  8c52f8:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c52fc:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5303:	00 
  8c5304:	ff c0                	inc    %eax
  8c5306:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c530c:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5312:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5318:	77 2a                	ja     8c5344 <check_lower_drain+0x1964>
  8c531a:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5320:	73 22                	jae    8c5344 <check_lower_drain+0x1964>
  8c5322:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5329:	75 45                	jne    8c5370 <check_lower_drain+0x1990>
  8c532b:	be 17 00 00 00       	mov    $0x17,%esi
  8c5330:	ba 05 00 00 00       	mov    $0x5,%edx
  8c5335:	48 89 df             	mov    %rbx,%rdi
  8c5338:	31 c9                	xor    %ecx,%ecx
  8c533a:	c5 f8 77             	vzeroupper
  8c533d:	e8 7e cb 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5342:	eb 60                	jmp    8c53a4 <check_lower_drain+0x19c4>
  8c5344:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5348:	48 8b 00             	mov    (%rax),%rax
  8c534b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5352:	75 50                	jne    8c53a4 <check_lower_drain+0x19c4>
  8c5354:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c535b:	00 00 00 
  8c535e:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5364:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5368:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c536e:	eb 34                	jmp    8c53a4 <check_lower_drain+0x19c4>
  8c5370:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5374:	48 8b 09             	mov    (%rcx),%rcx
  8c5377:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c537e:	75 24                	jne    8c53a4 <check_lower_drain+0x19c4>
  8c5380:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5384:	c6 04 01 17          	movb   $0x17,(%rcx,%rax,1)
  8c5388:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c538c:	c6 04 01 05          	movb   $0x5,(%rcx,%rax,1)
  8c5390:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5394:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c539b:	00 
  8c539c:	ff c0                	inc    %eax
  8c539e:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c53a4:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c53aa:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c53b0:	77 2d                	ja     8c53df <check_lower_drain+0x19ff>
  8c53b2:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c53b8:	73 25                	jae    8c53df <check_lower_drain+0x19ff>
  8c53ba:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c53c1:	75 4f                	jne    8c5412 <check_lower_drain+0x1a32>
  8c53c3:	48 89 df             	mov    %rbx,%rdi
  8c53c6:	be 09 00 00 00       	mov    $0x9,%esi
  8c53cb:	ba 02 00 00 00       	mov    $0x2,%edx
  8c53d0:	31 c9                	xor    %ecx,%ecx
  8c53d2:	c5 f8 77             	vzeroupper
  8c53d5:	e8 e6 ca 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c53da:	e9 15 e7 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c53df:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c53e3:	48 8b 00             	mov    (%rax),%rax
  8c53e6:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c53ed:	0f 85 01 e7 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c53f3:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c53fa:	00 00 00 
  8c53fd:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5403:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5407:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c540d:	e9 e2 e6 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c5412:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5416:	48 8b 09             	mov    (%rcx),%rcx
  8c5419:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5420:	0f 85 ce e6 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c5426:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c542a:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c542e:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5432:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5436:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c543a:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5441:	00 
  8c5442:	ff c0                	inc    %eax
  8c5444:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c544a:	e9 a5 e6 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c544f:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5453:	48 8b 09             	mov    (%rcx),%rcx
  8c5456:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c545d:	75 24                	jne    8c5483 <check_lower_drain+0x1aa3>
  8c545f:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5463:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c5467:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c546b:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c546f:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5473:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c547a:	00 
  8c547b:	ff c0                	inc    %eax
  8c547d:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5483:	83 fd 40             	cmp    $0x40,%ebp
  8c5486:	0f 84 43 01 00 00    	je     8c55cf <check_lower_drain+0x1bef>
  8c548c:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5492:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5498:	77 36                	ja     8c54d0 <check_lower_drain+0x1af0>
  8c549a:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c54a0:	73 2e                	jae    8c54d0 <check_lower_drain+0x1af0>
  8c54a2:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c54a9:	75 51                	jne    8c54fc <check_lower_drain+0x1b1c>
  8c54ab:	be 01 00 00 00       	mov    $0x1,%esi
  8c54b0:	ba 08 00 00 00       	mov    $0x8,%edx
  8c54b5:	48 89 fd             	mov    %rdi,%rbp
  8c54b8:	48 89 df             	mov    %rbx,%rdi
  8c54bb:	4c 89 f1             	mov    %r14,%rcx
  8c54be:	c5 f8 77             	vzeroupper
  8c54c1:	e8 fa c9 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c54c6:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c54cb:	48 89 ef             	mov    %rbp,%rdi
  8c54ce:	eb 5c                	jmp    8c552c <check_lower_drain+0x1b4c>
  8c54d0:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c54d4:	48 8b 00             	mov    (%rax),%rax
  8c54d7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c54de:	75 4c                	jne    8c552c <check_lower_drain+0x1b4c>
  8c54e0:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c54e7:	00 00 00 
  8c54ea:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c54f0:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c54f4:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c54fa:	eb 30                	jmp    8c552c <check_lower_drain+0x1b4c>
  8c54fc:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5500:	48 8b 09             	mov    (%rcx),%rcx
  8c5503:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c550a:	75 20                	jne    8c552c <check_lower_drain+0x1b4c>
  8c550c:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5510:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c5514:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5518:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c551c:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5520:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c5524:	ff c0                	inc    %eax
  8c5526:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c552c:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5532:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5538:	77 35                	ja     8c556f <check_lower_drain+0x1b8f>
  8c553a:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5540:	73 2d                	jae    8c556f <check_lower_drain+0x1b8f>
  8c5542:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5549:	75 50                	jne    8c559b <check_lower_drain+0x1bbb>
  8c554b:	be 10 00 00 00       	mov    $0x10,%esi
  8c5550:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5555:	49 89 fe             	mov    %rdi,%r14
  8c5558:	48 89 df             	mov    %rbx,%rdi
  8c555b:	31 c9                	xor    %ecx,%ecx
  8c555d:	c5 f8 77             	vzeroupper
  8c5560:	e8 5b c9 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5565:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c556a:	4c 89 f7             	mov    %r14,%rdi
  8c556d:	eb 60                	jmp    8c55cf <check_lower_drain+0x1bef>
  8c556f:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5573:	48 8b 00             	mov    (%rax),%rax
  8c5576:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c557d:	75 50                	jne    8c55cf <check_lower_drain+0x1bef>
  8c557f:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5586:	00 00 00 
  8c5589:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c558f:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5593:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5599:	eb 34                	jmp    8c55cf <check_lower_drain+0x1bef>
  8c559b:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c559f:	48 8b 09             	mov    (%rcx),%rcx
  8c55a2:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c55a9:	75 24                	jne    8c55cf <check_lower_drain+0x1bef>
  8c55ab:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c55af:	c6 04 01 10          	movb   $0x10,(%rcx,%rax,1)
  8c55b3:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c55b7:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c55bb:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c55bf:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c55c6:	00 
  8c55c7:	ff c0                	inc    %eax
  8c55c9:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c55cf:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c55d5:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c55db:	77 33                	ja     8c5610 <check_lower_drain+0x1c30>
  8c55dd:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c55e3:	73 2b                	jae    8c5610 <check_lower_drain+0x1c30>
  8c55e5:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c55ec:	75 4e                	jne    8c563c <check_lower_drain+0x1c5c>
  8c55ee:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c55f3:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c55f8:	ba 08 00 00 00       	mov    $0x8,%edx
  8c55fd:	49 89 fe             	mov    %rdi,%r14
  8c5600:	48 89 df             	mov    %rbx,%rdi
  8c5603:	c5 f8 77             	vzeroupper
  8c5606:	e8 b5 c8 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c560b:	4c 89 f7             	mov    %r14,%rdi
  8c560e:	eb 5c                	jmp    8c566c <check_lower_drain+0x1c8c>
  8c5610:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5614:	48 8b 00             	mov    (%rax),%rax
  8c5617:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c561e:	75 4c                	jne    8c566c <check_lower_drain+0x1c8c>
  8c5620:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5627:	00 00 00 
  8c562a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5630:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5634:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c563a:	eb 30                	jmp    8c566c <check_lower_drain+0x1c8c>
  8c563c:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5640:	48 8b 09             	mov    (%rcx),%rcx
  8c5643:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c564a:	75 20                	jne    8c566c <check_lower_drain+0x1c8c>
  8c564c:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5650:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c5654:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5658:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c565c:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5660:	48 89 34 c1          	mov    %rsi,(%rcx,%rax,8)
  8c5664:	ff c0                	inc    %eax
  8c5666:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c566c:	45 8d 74 3d 08       	lea    0x8(%r13,%rdi,1),%r14d
  8c5671:	4c 89 f8             	mov    %r15,%rax
  8c5674:	48 c1 e8 20          	shr    $0x20,%rax
  8c5678:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8c567d:	41 c1 ee 03          	shr    $0x3,%r14d
  8c5681:	f3 41 0f b8 ee       	popcnt %r14d,%ebp
  8c5686:	83 fd 01             	cmp    $0x1,%ebp
  8c5689:	0f 87 9c 00 00 00    	ja     8c572b <check_lower_drain+0x1d4b>
  8c568f:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5695:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c569b:	77 2d                	ja     8c56ca <check_lower_drain+0x1cea>
  8c569d:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c56a3:	73 25                	jae    8c56ca <check_lower_drain+0x1cea>
  8c56a5:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c56ac:	75 48                	jne    8c56f6 <check_lower_drain+0x1d16>
  8c56ae:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c56b3:	be 02 00 00 00       	mov    $0x2,%esi
  8c56b8:	ba 08 00 00 00       	mov    $0x8,%edx
  8c56bd:	48 89 df             	mov    %rbx,%rdi
  8c56c0:	c5 f8 77             	vzeroupper
  8c56c3:	e8 f8 c7 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c56c8:	eb 61                	jmp    8c572b <check_lower_drain+0x1d4b>
  8c56ca:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c56ce:	48 8b 00             	mov    (%rax),%rax
  8c56d1:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c56d8:	75 51                	jne    8c572b <check_lower_drain+0x1d4b>
  8c56da:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c56e1:	00 00 00 
  8c56e4:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c56ea:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c56ee:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c56f4:	eb 35                	jmp    8c572b <check_lower_drain+0x1d4b>
  8c56f6:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c56fa:	48 8b 09             	mov    (%rcx),%rcx
  8c56fd:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5704:	75 25                	jne    8c572b <check_lower_drain+0x1d4b>
  8c5706:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c570a:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c570f:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5713:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5717:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c571b:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c571f:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c5723:	ff c0                	inc    %eax
  8c5725:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c572b:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5731:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5737:	77 2d                	ja     8c5766 <check_lower_drain+0x1d86>
  8c5739:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c573f:	73 25                	jae    8c5766 <check_lower_drain+0x1d86>
  8c5741:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5748:	75 48                	jne    8c5792 <check_lower_drain+0x1db2>
  8c574a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c574f:	be 02 00 00 00       	mov    $0x2,%esi
  8c5754:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5759:	48 89 df             	mov    %rbx,%rdi
  8c575c:	c5 f8 77             	vzeroupper
  8c575f:	e8 5c c7 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5764:	eb 61                	jmp    8c57c7 <check_lower_drain+0x1de7>
  8c5766:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c576a:	48 8b 00             	mov    (%rax),%rax
  8c576d:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5774:	75 51                	jne    8c57c7 <check_lower_drain+0x1de7>
  8c5776:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c577d:	00 00 00 
  8c5780:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5786:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c578a:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5790:	eb 35                	jmp    8c57c7 <check_lower_drain+0x1de7>
  8c5792:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5796:	48 8b 09             	mov    (%rcx),%rcx
  8c5799:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c57a0:	75 25                	jne    8c57c7 <check_lower_drain+0x1de7>
  8c57a2:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c57a6:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c57ab:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c57af:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c57b3:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c57b7:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c57bb:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c57bf:	ff c0                	inc    %eax
  8c57c1:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c57c7:	48 89 df             	mov    %rbx,%rdi
  8c57ca:	44 89 f6             	mov    %r14d,%esi
  8c57cd:	c5 f8 77             	vzeroupper
  8c57d0:	e8 6b 27 01 00       	call   8d7f40 <check_lower_bit_unit>
  8c57d5:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c57db:	41 83 e7 07          	and    $0x7,%r15d
  8c57df:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c57e5:	77 2f                	ja     8c5816 <check_lower_drain+0x1e36>
  8c57e7:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c57ed:	73 27                	jae    8c5816 <check_lower_drain+0x1e36>
  8c57ef:	c4 e2 81 f7 4c 24 30 	shlx   %r15,0x30(%rsp),%rcx
  8c57f6:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c57fd:	48 f7 d1             	not    %rcx
  8c5800:	75 40                	jne    8c5842 <check_lower_drain+0x1e62>
  8c5802:	be 01 00 00 00       	mov    $0x1,%esi
  8c5807:	ba 08 00 00 00       	mov    $0x8,%edx
  8c580c:	48 89 df             	mov    %rbx,%rdi
  8c580f:	e8 ac c6 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5814:	eb 5c                	jmp    8c5872 <check_lower_drain+0x1e92>
  8c5816:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c581a:	48 8b 00             	mov    (%rax),%rax
  8c581d:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5824:	75 4c                	jne    8c5872 <check_lower_drain+0x1e92>
  8c5826:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c582d:	00 00 00 
  8c5830:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5836:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c583a:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5840:	eb 30                	jmp    8c5872 <check_lower_drain+0x1e92>
  8c5842:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c5846:	48 8b 12             	mov    (%rdx),%rdx
  8c5849:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c5850:	75 20                	jne    8c5872 <check_lower_drain+0x1e92>
  8c5852:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c5856:	c6 04 02 01          	movb   $0x1,(%rdx,%rax,1)
  8c585a:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c585e:	c6 04 02 08          	movb   $0x8,(%rdx,%rax,1)
  8c5862:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c5866:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c586a:	ff c0                	inc    %eax
  8c586c:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5872:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5878:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c587e:	77 27                	ja     8c58a7 <check_lower_drain+0x1ec7>
  8c5880:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5886:	73 1f                	jae    8c58a7 <check_lower_drain+0x1ec7>
  8c5888:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c588f:	75 42                	jne    8c58d3 <check_lower_drain+0x1ef3>
  8c5891:	be 10 00 00 00       	mov    $0x10,%esi
  8c5896:	ba 08 00 00 00       	mov    $0x8,%edx
  8c589b:	48 89 df             	mov    %rbx,%rdi
  8c589e:	31 c9                	xor    %ecx,%ecx
  8c58a0:	e8 1b c6 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c58a5:	eb 60                	jmp    8c5907 <check_lower_drain+0x1f27>
  8c58a7:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c58ab:	48 8b 00             	mov    (%rax),%rax
  8c58ae:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c58b5:	75 50                	jne    8c5907 <check_lower_drain+0x1f27>
  8c58b7:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c58be:	00 00 00 
  8c58c1:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c58c7:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c58cb:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c58d1:	eb 34                	jmp    8c5907 <check_lower_drain+0x1f27>
  8c58d3:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c58d7:	48 8b 09             	mov    (%rcx),%rcx
  8c58da:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c58e1:	75 24                	jne    8c5907 <check_lower_drain+0x1f27>
  8c58e3:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c58e7:	c6 04 01 10          	movb   $0x10,(%rcx,%rax,1)
  8c58eb:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c58ef:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c58f3:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c58f7:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c58fe:	00 
  8c58ff:	ff c0                	inc    %eax
  8c5901:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5907:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c590d:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5913:	77 2a                	ja     8c593f <check_lower_drain+0x1f5f>
  8c5915:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c591b:	73 22                	jae    8c593f <check_lower_drain+0x1f5f>
  8c591d:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5924:	75 45                	jne    8c596b <check_lower_drain+0x1f8b>
  8c5926:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c592b:	be 02 00 00 00       	mov    $0x2,%esi
  8c5930:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5935:	48 89 df             	mov    %rbx,%rdi
  8c5938:	e8 83 c5 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c593d:	eb 61                	jmp    8c59a0 <check_lower_drain+0x1fc0>
  8c593f:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5943:	48 8b 00             	mov    (%rax),%rax
  8c5946:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c594d:	75 51                	jne    8c59a0 <check_lower_drain+0x1fc0>
  8c594f:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5956:	00 00 00 
  8c5959:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c595f:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5963:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5969:	eb 35                	jmp    8c59a0 <check_lower_drain+0x1fc0>
  8c596b:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c596f:	48 8b 09             	mov    (%rcx),%rcx
  8c5972:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5979:	75 25                	jne    8c59a0 <check_lower_drain+0x1fc0>
  8c597b:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c597f:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c5984:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5988:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c598c:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5990:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5994:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c5998:	ff c0                	inc    %eax
  8c599a:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c59a0:	45 85 ed             	test   %r13d,%r13d
  8c59a3:	0f 84 27 01 00 00    	je     8c5ad0 <check_lower_drain+0x20f0>
  8c59a9:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c59af:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c59b5:	77 28                	ja     8c59df <check_lower_drain+0x1fff>
  8c59b7:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c59bd:	73 20                	jae    8c59df <check_lower_drain+0x1fff>
  8c59bf:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c59c6:	75 43                	jne    8c5a0b <check_lower_drain+0x202b>
  8c59c8:	be 01 00 00 00       	mov    $0x1,%esi
  8c59cd:	ba 08 00 00 00       	mov    $0x8,%edx
  8c59d2:	48 89 df             	mov    %rbx,%rdi
  8c59d5:	4c 89 f9             	mov    %r15,%rcx
  8c59d8:	e8 e3 c4 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c59dd:	eb 5c                	jmp    8c5a3b <check_lower_drain+0x205b>
  8c59df:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c59e3:	48 8b 00             	mov    (%rax),%rax
  8c59e6:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c59ed:	75 4c                	jne    8c5a3b <check_lower_drain+0x205b>
  8c59ef:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c59f6:	00 00 00 
  8c59f9:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c59ff:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5a03:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5a09:	eb 30                	jmp    8c5a3b <check_lower_drain+0x205b>
  8c5a0b:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5a0f:	48 8b 09             	mov    (%rcx),%rcx
  8c5a12:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5a19:	75 20                	jne    8c5a3b <check_lower_drain+0x205b>
  8c5a1b:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5a1f:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c5a23:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5a27:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5a2b:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5a2f:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c5a33:	ff c0                	inc    %eax
  8c5a35:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5a3b:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5a41:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5a47:	77 27                	ja     8c5a70 <check_lower_drain+0x2090>
  8c5a49:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5a4f:	73 1f                	jae    8c5a70 <check_lower_drain+0x2090>
  8c5a51:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5a58:	75 42                	jne    8c5a9c <check_lower_drain+0x20bc>
  8c5a5a:	be 13 00 00 00       	mov    $0x13,%esi
  8c5a5f:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5a64:	48 89 df             	mov    %rbx,%rdi
  8c5a67:	31 c9                	xor    %ecx,%ecx
  8c5a69:	e8 52 c4 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5a6e:	eb 60                	jmp    8c5ad0 <check_lower_drain+0x20f0>
  8c5a70:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5a74:	48 8b 00             	mov    (%rax),%rax
  8c5a77:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5a7e:	75 50                	jne    8c5ad0 <check_lower_drain+0x20f0>
  8c5a80:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5a87:	00 00 00 
  8c5a8a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5a90:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5a94:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5a9a:	eb 34                	jmp    8c5ad0 <check_lower_drain+0x20f0>
  8c5a9c:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5aa0:	48 8b 09             	mov    (%rcx),%rcx
  8c5aa3:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5aaa:	75 24                	jne    8c5ad0 <check_lower_drain+0x20f0>
  8c5aac:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5ab0:	c6 04 01 13          	movb   $0x13,(%rcx,%rax,1)
  8c5ab4:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5ab8:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5abc:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5ac0:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5ac7:	00 
  8c5ac8:	ff c0                	inc    %eax
  8c5aca:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5ad0:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5ad6:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5adc:	77 27                	ja     8c5b05 <check_lower_drain+0x2125>
  8c5ade:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5ae4:	73 1f                	jae    8c5b05 <check_lower_drain+0x2125>
  8c5ae6:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5aed:	75 42                	jne    8c5b31 <check_lower_drain+0x2151>
  8c5aef:	be 11 00 00 00       	mov    $0x11,%esi
  8c5af4:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5af9:	48 89 df             	mov    %rbx,%rdi
  8c5afc:	31 c9                	xor    %ecx,%ecx
  8c5afe:	e8 bd c3 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5b03:	eb 60                	jmp    8c5b65 <check_lower_drain+0x2185>
  8c5b05:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5b09:	48 8b 00             	mov    (%rax),%rax
  8c5b0c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5b13:	75 50                	jne    8c5b65 <check_lower_drain+0x2185>
  8c5b15:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5b1c:	00 00 00 
  8c5b1f:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5b25:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5b29:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5b2f:	eb 34                	jmp    8c5b65 <check_lower_drain+0x2185>
  8c5b31:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5b35:	48 8b 09             	mov    (%rcx),%rcx
  8c5b38:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5b3f:	75 24                	jne    8c5b65 <check_lower_drain+0x2185>
  8c5b41:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5b45:	c6 04 01 11          	movb   $0x11,(%rcx,%rax,1)
  8c5b49:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5b4d:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5b51:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5b55:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5b5c:	00 
  8c5b5d:	ff c0                	inc    %eax
  8c5b5f:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5b65:	83 fd 01             	cmp    $0x1,%ebp
  8c5b68:	77 29                	ja     8c5b93 <check_lower_drain+0x21b3>
  8c5b6a:	41 83 fe 02          	cmp    $0x2,%r14d
  8c5b6e:	0f 84 42 01 00 00    	je     8c5cb6 <check_lower_drain+0x22d6>
  8c5b74:	41 83 fe 04          	cmp    $0x4,%r14d
  8c5b78:	0f 84 33 01 00 00    	je     8c5cb1 <check_lower_drain+0x22d1>
  8c5b7e:	40 b5 08             	mov    $0x8,%bpl
  8c5b81:	41 83 fe 08          	cmp    $0x8,%r14d
  8c5b85:	0f 84 fd 06 00 00    	je     8c6288 <check_lower_drain+0x28a8>
  8c5b8b:	40 b5 02             	mov    $0x2,%bpl
  8c5b8e:	e9 26 01 00 00       	jmp    8c5cb9 <check_lower_drain+0x22d9>
  8c5b93:	44 8b bb 48 01 00 00 	mov    0x148(%rbx),%r15d
  8c5b9a:	49 81 ff ff ff 00 00 	cmp    $0xffff,%r15
  8c5ba1:	77 7a                	ja     8c5c1d <check_lower_drain+0x223d>
  8c5ba3:	44 3b bb 4c 01 00 00 	cmp    0x14c(%rbx),%r15d
  8c5baa:	73 71                	jae    8c5c1d <check_lower_drain+0x223d>
  8c5bac:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8c5bb3:	42 c6 04 38 08       	movb   $0x8,(%rax,%r15,1)
  8c5bb8:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
  8c5bbf:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
  8c5bc4:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
  8c5bcb:	42 c7 04 b8 00 00 00 	movl   $0x0,(%rax,%r15,4)
  8c5bd2:	00 
  8c5bd3:	48 8b 83 e0 00 00 00 	mov    0xe0(%rbx),%rax
  8c5bda:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
  8c5bdf:	48 8b 83 b0 00 00 00 	mov    0xb0(%rbx),%rax
  8c5be6:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
  8c5beb:	ff 83 48 01 00 00    	incl   0x148(%rbx)
  8c5bf1:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5bf5:	48 8b 00             	mov    (%rax),%rax
  8c5bf8:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5bff:	75 40                	jne    8c5c41 <check_lower_drain+0x2261>
  8c5c01:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  8c5c08:	42 c6 04 38 08       	movb   $0x8,(%rax,%r15,1)
  8c5c0d:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5c13:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5c19:	76 34                	jbe    8c5c4f <check_lower_drain+0x226f>
  8c5c1b:	eb 61                	jmp    8c5c7e <check_lower_drain+0x229e>
  8c5c1d:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5c21:	48 8b 00             	mov    (%rax),%rax
  8c5c24:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5c2b:	0f 84 f0 05 00 00    	je     8c6221 <check_lower_drain+0x2841>
  8c5c31:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5c35:	48 8b 00             	mov    (%rax),%rax
  8c5c38:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5c3f:	74 c0                	je     8c5c01 <check_lower_drain+0x2221>
  8c5c41:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5c47:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5c4d:	77 2f                	ja     8c5c7e <check_lower_drain+0x229e>
  8c5c4f:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5c55:	73 27                	jae    8c5c7e <check_lower_drain+0x229e>
  8c5c57:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5c5e:	0f 85 c3 00 00 00    	jne    8c5d27 <check_lower_drain+0x2347>
  8c5c64:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c5c69:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5c6e:	48 89 df             	mov    %rbx,%rdi
  8c5c71:	4c 89 f9             	mov    %r15,%rcx
  8c5c74:	e8 47 c2 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5c79:	e9 d9 00 00 00       	jmp    8c5d57 <check_lower_drain+0x2377>
  8c5c7e:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5c82:	48 8b 00             	mov    (%rax),%rax
  8c5c85:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5c8c:	0f 85 c5 00 00 00    	jne    8c5d57 <check_lower_drain+0x2377>
  8c5c92:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5c99:	00 00 00 
  8c5c9c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5ca2:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5ca6:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5cac:	e9 a6 00 00 00       	jmp    8c5d57 <check_lower_drain+0x2377>
  8c5cb1:	40 b5 06             	mov    $0x6,%bpl
  8c5cb4:	eb 03                	jmp    8c5cb9 <check_lower_drain+0x22d9>
  8c5cb6:	40 b5 04             	mov    $0x4,%bpl
  8c5cb9:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5cbf:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5cc5:	77 2d                	ja     8c5cf4 <check_lower_drain+0x2314>
  8c5cc7:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5ccd:	73 25                	jae    8c5cf4 <check_lower_drain+0x2314>
  8c5ccf:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5cd6:	0f 85 78 05 00 00    	jne    8c6254 <check_lower_drain+0x2874>
  8c5cdc:	40 0f b6 d5          	movzbl %bpl,%edx
  8c5ce0:	be 09 00 00 00       	mov    $0x9,%esi
  8c5ce5:	48 89 df             	mov    %rbx,%rdi
  8c5ce8:	31 c9                	xor    %ecx,%ecx
  8c5cea:	e8 d1 c1 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5cef:	e9 94 05 00 00       	jmp    8c6288 <check_lower_drain+0x28a8>
  8c5cf4:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5cf8:	48 8b 00             	mov    (%rax),%rax
  8c5cfb:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5d02:	0f 85 80 05 00 00    	jne    8c6288 <check_lower_drain+0x28a8>
  8c5d08:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5d0f:	00 00 00 
  8c5d12:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5d18:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5d1c:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5d22:	e9 61 05 00 00       	jmp    8c6288 <check_lower_drain+0x28a8>
  8c5d27:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5d2b:	48 8b 09             	mov    (%rcx),%rcx
  8c5d2e:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5d35:	75 20                	jne    8c5d57 <check_lower_drain+0x2377>
  8c5d37:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5d3b:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c5d3f:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5d43:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5d47:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5d4b:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c5d4f:	ff c0                	inc    %eax
  8c5d51:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5d57:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  8c5d5c:	45 31 ff             	xor    %r15d,%r15d
  8c5d5f:	eb 1f                	jmp    8c5d80 <check_lower_drain+0x23a0>
  8c5d61:	41 0f b6 d5          	movzbl %r13b,%edx
  8c5d65:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c5d6a:	48 89 df             	mov    %rbx,%rdi
  8c5d6d:	31 c9                	xor    %ecx,%ecx
  8c5d6f:	e8 4c c1 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5d74:	41 01 ef             	add    %ebp,%r15d
  8c5d77:	45 39 f7             	cmp    %r14d,%r15d
  8c5d7a:	0f 83 9c 05 00 00    	jae    8c631c <check_lower_drain+0x293c>
  8c5d80:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5d84:	48 8b 00             	mov    (%rax),%rax
  8c5d87:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5d8e:	0f 85 88 05 00 00    	jne    8c631c <check_lower_drain+0x293c>
  8c5d94:	44 89 f1             	mov    %r14d,%ecx
  8c5d97:	44 29 f9             	sub    %r15d,%ecx
  8c5d9a:	83 f9 07             	cmp    $0x7,%ecx
  8c5d9d:	76 21                	jbe    8c5dc0 <check_lower_drain+0x23e0>
  8c5d9f:	41 b5 08             	mov    $0x8,%r13b
  8c5da2:	bd 08 00 00 00       	mov    $0x8,%ebp
  8c5da7:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5dad:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5db4:	76 4c                	jbe    8c5e02 <check_lower_drain+0x2422>
  8c5db6:	eb 78                	jmp    8c5e30 <check_lower_drain+0x2450>
  8c5db8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8c5dbf:	00 
  8c5dc0:	83 f9 03             	cmp    $0x3,%ecx
  8c5dc3:	76 19                	jbe    8c5dde <check_lower_drain+0x23fe>
  8c5dc5:	41 b5 06             	mov    $0x6,%r13b
  8c5dc8:	bd 04 00 00 00       	mov    $0x4,%ebp
  8c5dcd:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5dd3:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5dda:	76 26                	jbe    8c5e02 <check_lower_drain+0x2422>
  8c5ddc:	eb 52                	jmp    8c5e30 <check_lower_drain+0x2450>
  8c5dde:	45 31 ed             	xor    %r13d,%r13d
  8c5de1:	83 f9 02             	cmp    $0x2,%ecx
  8c5de4:	41 0f 93 c5          	setae  %r13b
  8c5de8:	41 8d 6d 01          	lea    0x1(%r13),%ebp
  8c5dec:	45 00 ed             	add    %r13b,%r13b
  8c5def:	41 80 c5 02          	add    $0x2,%r13b
  8c5df3:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5df9:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5e00:	77 2e                	ja     8c5e30 <check_lower_drain+0x2450>
  8c5e02:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c5e08:	73 26                	jae    8c5e30 <check_lower_drain+0x2450>
  8c5e0a:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5e11:	75 39                	jne    8c5e4c <check_lower_drain+0x246c>
  8c5e13:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5e18:	be 02 00 00 00       	mov    $0x2,%esi
  8c5e1d:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5e22:	48 89 df             	mov    %rbx,%rdi
  8c5e25:	e8 96 c0 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5e2a:	eb 45                	jmp    8c5e71 <check_lower_drain+0x2491>
  8c5e2c:	0f 1f 40 00          	nopl   0x0(%rax)
  8c5e30:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5e37:	00 00 00 
  8c5e3a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5e40:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5e44:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5e4a:	eb 25                	jmp    8c5e71 <check_lower_drain+0x2491>
  8c5e4c:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c5e50:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c5e55:	c6 04 08 02          	movb   $0x2,(%rax,%rcx,1)
  8c5e59:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c5e5d:	c6 04 08 08          	movb   $0x8,(%rax,%rcx,1)
  8c5e61:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c5e65:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
  8c5e69:	ff c1                	inc    %ecx
  8c5e6b:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c5e71:	44 89 fe             	mov    %r15d,%esi
  8c5e74:	48 89 df             	mov    %rbx,%rdi
  8c5e77:	e8 24 93 00 00       	call   8cf1a0 <check_lower_offset>
  8c5e7c:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5e82:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5e88:	77 36                	ja     8c5ec0 <check_lower_drain+0x24e0>
  8c5e8a:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5e90:	73 2e                	jae    8c5ec0 <check_lower_drain+0x24e0>
  8c5e92:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5e99:	75 51                	jne    8c5eec <check_lower_drain+0x250c>
  8c5e9b:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c5ea0:	be 02 00 00 00       	mov    $0x2,%esi
  8c5ea5:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5eaa:	48 89 df             	mov    %rbx,%rdi
  8c5ead:	e8 0e c0 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5eb2:	eb 7c                	jmp    8c5f30 <check_lower_drain+0x2550>
  8c5eb4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c5ebb:	00 00 00 00 00 
  8c5ec0:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5ec4:	48 8b 00             	mov    (%rax),%rax
  8c5ec7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5ece:	75 60                	jne    8c5f30 <check_lower_drain+0x2550>
  8c5ed0:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5ed7:	00 00 00 
  8c5eda:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5ee0:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5ee4:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5eea:	eb 44                	jmp    8c5f30 <check_lower_drain+0x2550>
  8c5eec:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5ef0:	48 8b 09             	mov    (%rcx),%rcx
  8c5ef3:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5efa:	75 34                	jne    8c5f30 <check_lower_drain+0x2550>
  8c5efc:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5f00:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c5f05:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5f09:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5f0d:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5f11:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5f15:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c5f19:	ff c0                	inc    %eax
  8c5f1b:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5f21:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c5f28:	0f 1f 84 00 00 00 00 
  8c5f2f:	00 
  8c5f30:	45 85 ff             	test   %r15d,%r15d
  8c5f33:	0f 84 37 01 00 00    	je     8c6070 <check_lower_drain+0x2690>
  8c5f39:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5f3f:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5f45:	77 2d                	ja     8c5f74 <check_lower_drain+0x2594>
  8c5f47:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5f4d:	73 25                	jae    8c5f74 <check_lower_drain+0x2594>
  8c5f4f:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5f56:	42 8d 0c fd 00 00 00 	lea    0x0(,%r15,8),%ecx
  8c5f5d:	00 
  8c5f5e:	75 40                	jne    8c5fa0 <check_lower_drain+0x25c0>
  8c5f60:	be 01 00 00 00       	mov    $0x1,%esi
  8c5f65:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5f6a:	48 89 df             	mov    %rbx,%rdi
  8c5f6d:	e8 4e bf 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c5f72:	eb 5c                	jmp    8c5fd0 <check_lower_drain+0x25f0>
  8c5f74:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5f78:	48 8b 00             	mov    (%rax),%rax
  8c5f7b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5f82:	75 4c                	jne    8c5fd0 <check_lower_drain+0x25f0>
  8c5f84:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5f8b:	00 00 00 
  8c5f8e:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5f94:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5f98:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5f9e:	eb 30                	jmp    8c5fd0 <check_lower_drain+0x25f0>
  8c5fa0:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c5fa4:	48 8b 12             	mov    (%rdx),%rdx
  8c5fa7:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c5fae:	75 20                	jne    8c5fd0 <check_lower_drain+0x25f0>
  8c5fb0:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c5fb4:	c6 04 02 01          	movb   $0x1,(%rdx,%rax,1)
  8c5fb8:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c5fbc:	c6 04 02 08          	movb   $0x8,(%rdx,%rax,1)
  8c5fc0:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c5fc4:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c5fc8:	ff c0                	inc    %eax
  8c5fca:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5fd0:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5fd6:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5fdc:	77 27                	ja     8c6005 <check_lower_drain+0x2625>
  8c5fde:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5fe4:	73 1f                	jae    8c6005 <check_lower_drain+0x2625>
  8c5fe6:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5fed:	75 42                	jne    8c6031 <check_lower_drain+0x2651>
  8c5fef:	be 14 00 00 00       	mov    $0x14,%esi
  8c5ff4:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5ff9:	48 89 df             	mov    %rbx,%rdi
  8c5ffc:	31 c9                	xor    %ecx,%ecx
  8c5ffe:	e8 bd be 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c6003:	eb 6b                	jmp    8c6070 <check_lower_drain+0x2690>
  8c6005:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6009:	48 8b 00             	mov    (%rax),%rax
  8c600c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6013:	75 5b                	jne    8c6070 <check_lower_drain+0x2690>
  8c6015:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c601c:	00 00 00 
  8c601f:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6025:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6029:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c602f:	eb 3f                	jmp    8c6070 <check_lower_drain+0x2690>
  8c6031:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6035:	48 8b 09             	mov    (%rcx),%rcx
  8c6038:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c603f:	75 2f                	jne    8c6070 <check_lower_drain+0x2690>
  8c6041:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c6045:	c6 04 01 14          	movb   $0x14,(%rcx,%rax,1)
  8c6049:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c604d:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c6051:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c6055:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c605c:	00 
  8c605d:	ff c0                	inc    %eax
  8c605f:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c6065:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  8c606c:	00 00 00 00 
  8c6070:	41 80 fd 08          	cmp    $0x8,%r13b
  8c6074:	0f 84 96 00 00 00    	je     8c6110 <check_lower_drain+0x2730>
  8c607a:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c6080:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c6086:	77 26                	ja     8c60ae <check_lower_drain+0x26ce>
  8c6088:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c608e:	73 1e                	jae    8c60ae <check_lower_drain+0x26ce>
  8c6090:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c6097:	75 41                	jne    8c60da <check_lower_drain+0x26fa>
  8c6099:	41 0f b6 d5          	movzbl %r13b,%edx
  8c609d:	be 09 00 00 00       	mov    $0x9,%esi
  8c60a2:	48 89 df             	mov    %rbx,%rdi
  8c60a5:	31 c9                	xor    %ecx,%ecx
  8c60a7:	e8 14 be 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c60ac:	eb 62                	jmp    8c6110 <check_lower_drain+0x2730>
  8c60ae:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c60b2:	48 8b 00             	mov    (%rax),%rax
  8c60b5:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c60bc:	75 52                	jne    8c6110 <check_lower_drain+0x2730>
  8c60be:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c60c5:	00 00 00 
  8c60c8:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c60ce:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c60d2:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c60d8:	eb 36                	jmp    8c6110 <check_lower_drain+0x2730>
  8c60da:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c60de:	48 8b 09             	mov    (%rcx),%rcx
  8c60e1:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c60e8:	75 26                	jne    8c6110 <check_lower_drain+0x2730>
  8c60ea:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c60ee:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c60f2:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c60f6:	44 88 2c 01          	mov    %r13b,(%rcx,%rax,1)
  8c60fa:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c60fe:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c6105:	00 
  8c6106:	ff c0                	inc    %eax
  8c6108:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c610e:	66 90                	xchg   %ax,%ax
  8c6110:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c6116:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c611c:	77 52                	ja     8c6170 <check_lower_drain+0x2790>
  8c611e:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6124:	73 4a                	jae    8c6170 <check_lower_drain+0x2790>
  8c6126:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c612d:	0f 84 2e fc ff ff    	je     8c5d61 <check_lower_drain+0x2381>
  8c6133:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6137:	48 8b 09             	mov    (%rcx),%rcx
  8c613a:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c6141:	0f 85 2d fc ff ff    	jne    8c5d74 <check_lower_drain+0x2394>
  8c6147:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c614b:	c6 04 01 1d          	movb   $0x1d,(%rcx,%rax,1)
  8c614f:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c6153:	44 88 2c 01          	mov    %r13b,(%rcx,%rax,1)
  8c6157:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c615b:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c6162:	00 
  8c6163:	ff c0                	inc    %eax
  8c6165:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c616b:	e9 04 fc ff ff       	jmp    8c5d74 <check_lower_drain+0x2394>
  8c6170:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6174:	48 8b 00             	mov    (%rax),%rax
  8c6177:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c617e:	0f 85 f0 fb ff ff    	jne    8c5d74 <check_lower_drain+0x2394>
  8c6184:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c618b:	00 00 00 
  8c618e:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6194:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6198:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c619e:	e9 d1 fb ff ff       	jmp    8c5d74 <check_lower_drain+0x2394>
  8c61a3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c61aa:	0f 85 44 d9 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c61b0:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c61b4:	c6 04 08 09          	movb   $0x9,(%rax,%rcx,1)
  8c61b8:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c61bc:	44 88 34 08          	mov    %r14b,(%rax,%rcx,1)
  8c61c0:	e9 22 ea ff ff       	jmp    8c4be7 <check_lower_drain+0x1207>
  8c61c5:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c61cc:	75 24                	jne    8c61f2 <check_lower_drain+0x2812>
  8c61ce:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c61d2:	c6 04 08 23          	movb   $0x23,(%rax,%rcx,1)
  8c61d6:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c61da:	c6 04 08 08          	movb   $0x8,(%rax,%rcx,1)
  8c61de:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c61e2:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c61e9:	00 
  8c61ea:	ff c1                	inc    %ecx
  8c61ec:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c61f2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c61f9:	01 00 00 
  8c61fc:	49 85 c4             	test   %rax,%r12
  8c61ff:	0f 85 ef d8 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c6205:	be 23 00 00 00       	mov    $0x23,%esi
  8c620a:	ba 08 00 00 00       	mov    $0x8,%edx
  8c620f:	48 89 df             	mov    %rbx,%rdi
  8c6212:	31 c9                	xor    %ecx,%ecx
  8c6214:	c5 f8 77             	vzeroupper
  8c6217:	e8 74 2d 00 00       	call   8c8f90 <check_lower_emit>
  8c621c:	e9 d3 d8 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c6221:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6228:	00 00 00 
  8c622b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6231:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6235:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c623b:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c623f:	48 8b 00             	mov    (%rax),%rax
  8c6242:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6249:	0f 85 f2 f9 ff ff    	jne    8c5c41 <check_lower_drain+0x2261>
  8c624f:	e9 ad f9 ff ff       	jmp    8c5c01 <check_lower_drain+0x2221>
  8c6254:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6258:	48 8b 09             	mov    (%rcx),%rcx
  8c625b:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c6262:	75 24                	jne    8c6288 <check_lower_drain+0x28a8>
  8c6264:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c6268:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c626c:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c6270:	40 88 2c 01          	mov    %bpl,(%rcx,%rax,1)
  8c6274:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c6278:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c627f:	00 
  8c6280:	ff c0                	inc    %eax
  8c6282:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c6288:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c628e:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c6294:	77 26                	ja     8c62bc <check_lower_drain+0x28dc>
  8c6296:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c629c:	73 1e                	jae    8c62bc <check_lower_drain+0x28dc>
  8c629e:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c62a5:	75 41                	jne    8c62e8 <check_lower_drain+0x2908>
  8c62a7:	40 0f b6 d5          	movzbl %bpl,%edx
  8c62ab:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c62b0:	48 89 df             	mov    %rbx,%rdi
  8c62b3:	31 c9                	xor    %ecx,%ecx
  8c62b5:	e8 06 bc 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c62ba:	eb 60                	jmp    8c631c <check_lower_drain+0x293c>
  8c62bc:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c62c0:	48 8b 00             	mov    (%rax),%rax
  8c62c3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c62ca:	75 50                	jne    8c631c <check_lower_drain+0x293c>
  8c62cc:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c62d3:	00 00 00 
  8c62d6:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c62dc:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c62e0:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c62e6:	eb 34                	jmp    8c631c <check_lower_drain+0x293c>
  8c62e8:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c62ec:	48 8b 09             	mov    (%rcx),%rcx
  8c62ef:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c62f6:	75 24                	jne    8c631c <check_lower_drain+0x293c>
  8c62f8:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c62fc:	c6 04 01 1d          	movb   $0x1d,(%rcx,%rax,1)
  8c6300:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c6304:	40 88 2c 01          	mov    %bpl,(%rcx,%rax,1)
  8c6308:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c630c:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c6313:	00 
  8c6314:	ff c0                	inc    %eax
  8c6316:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c631c:	48 b8 00 00 00 00 00 	movabs $0x40000000000,%rax
  8c6323:	04 00 00 
  8c6326:	49 85 c4             	test   %rax,%r12
  8c6329:	0f 85 c5 d7 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c632f:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c6335:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c633b:	77 2a                	ja     8c6367 <check_lower_drain+0x2987>
  8c633d:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6343:	73 22                	jae    8c6367 <check_lower_drain+0x2987>
  8c6345:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c634c:	75 45                	jne    8c6393 <check_lower_drain+0x29b3>
  8c634e:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c6353:	be 02 00 00 00       	mov    $0x2,%esi
  8c6358:	ba 08 00 00 00       	mov    $0x8,%edx
  8c635d:	48 89 df             	mov    %rbx,%rdi
  8c6360:	e8 5b bb 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c6365:	eb 61                	jmp    8c63c8 <check_lower_drain+0x29e8>
  8c6367:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c636b:	48 8b 00             	mov    (%rax),%rax
  8c636e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6375:	75 51                	jne    8c63c8 <check_lower_drain+0x29e8>
  8c6377:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c637e:	00 00 00 
  8c6381:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6387:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c638b:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6391:	eb 35                	jmp    8c63c8 <check_lower_drain+0x29e8>
  8c6393:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6397:	48 8b 09             	mov    (%rcx),%rcx
  8c639a:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c63a1:	75 25                	jne    8c63c8 <check_lower_drain+0x29e8>
  8c63a3:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c63a7:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c63ac:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c63b0:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c63b4:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c63b8:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c63bc:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c63c0:	ff c0                	inc    %eax
  8c63c2:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c63c8:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  8c63cf:	00 
  8c63d0:	48 89 df             	mov    %rbx,%rdi
  8c63d3:	31 d2                	xor    %edx,%edx
  8c63d5:	e8 46 22 01 00       	call   8d8620 <check_lower_bit_extract>
  8c63da:	e9 15 d7 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c63df:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c63e6:	0f 85 08 d7 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c63ec:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c63f0:	c6 04 08 29          	movb   $0x29,(%rax,%rcx,1)
  8c63f4:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c63f8:	c6 04 08 00          	movb   $0x0,(%rax,%rcx,1)
  8c63fc:	e9 64 dd ff ff       	jmp    8c4165 <check_lower_drain+0x785>
  8c6401:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6405:	48 8b 09             	mov    (%rcx),%rcx
  8c6408:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c640f:	75 20                	jne    8c6431 <check_lower_drain+0x2a51>
  8c6411:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c6415:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c6419:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c641d:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c6421:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c6425:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c6429:	ff c0                	inc    %eax
  8c642b:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c6431:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c6438:	01 00 00 
  8c643b:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
  8c6440:	49 85 c4             	test   %rax,%r12
  8c6443:	74 18                	je     8c645d <check_lower_drain+0x2a7d>
  8c6445:	be 1e 00 00 00       	mov    $0x1e,%esi
  8c644a:	ba 08 00 00 00       	mov    $0x8,%edx
  8c644f:	48 89 df             	mov    %rbx,%rdi
  8c6452:	4c 89 e9             	mov    %r13,%rcx
  8c6455:	c5 f8 77             	vzeroupper
  8c6458:	e8 33 2b 00 00       	call   8c8f90 <check_lower_emit>
  8c645d:	4c 89 6c 24 30       	mov    %r13,0x30(%rsp)
  8c6462:	4d 89 fd             	mov    %r15,%r13
  8c6465:	31 ed                	xor    %ebp,%ebp
  8c6467:	eb 29                	jmp    8c6492 <check_lower_drain+0x2ab2>
  8c6469:	be 29 00 00 00       	mov    $0x29,%esi
  8c646e:	48 89 df             	mov    %rbx,%rdi
  8c6471:	31 d2                	xor    %edx,%edx
  8c6473:	4c 89 f1             	mov    %r14,%rcx
  8c6476:	e8 45 ba 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c647b:	48 81 c5 00 01 00 00 	add    $0x100,%rbp
  8c6482:	49 81 c5 00 ff ff ff 	add    $0xffffffffffffff00,%r13
  8c6489:	4c 39 fd             	cmp    %r15,%rbp
  8c648c:	0f 83 08 02 00 00    	jae    8c669a <check_lower_drain+0x2cba>
  8c6492:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6496:	49 81 fd 00 01 00 00 	cmp    $0x100,%r13
  8c649d:	b9 00 01 00 00       	mov    $0x100,%ecx
  8c64a2:	48 8b 00             	mov    (%rax),%rax
  8c64a5:	49 0f 42 cd          	cmovb  %r13,%rcx
  8c64a9:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c64b0:	0f 85 e4 01 00 00    	jne    8c669a <check_lower_drain+0x2cba>
  8c64b6:	49 81 fd 00 01 00 00 	cmp    $0x100,%r13
  8c64bd:	41 be 00 01 00 00    	mov    $0x100,%r14d
  8c64c3:	4d 0f 42 f5          	cmovb  %r13,%r14
  8c64c7:	4c 39 e9             	cmp    %r13,%rcx
  8c64ca:	0f 84 80 00 00 00    	je     8c6550 <check_lower_drain+0x2b70>
  8c64d0:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c64d6:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c64dd:	77 2a                	ja     8c6509 <check_lower_drain+0x2b29>
  8c64df:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c64e5:	73 22                	jae    8c6509 <check_lower_drain+0x2b29>
  8c64e7:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c64ee:	75 35                	jne    8c6525 <check_lower_drain+0x2b45>
  8c64f0:	be 06 00 00 00       	mov    $0x6,%esi
  8c64f5:	ba 08 00 00 00       	mov    $0x8,%edx
  8c64fa:	48 89 df             	mov    %rbx,%rdi
  8c64fd:	31 c9                	xor    %ecx,%ecx
  8c64ff:	c5 f8 77             	vzeroupper
  8c6502:	e8 b9 b9 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c6507:	eb 47                	jmp    8c6550 <check_lower_drain+0x2b70>
  8c6509:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6510:	00 00 00 
  8c6513:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6519:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c651d:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6523:	eb 2b                	jmp    8c6550 <check_lower_drain+0x2b70>
  8c6525:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c6529:	c6 04 08 06          	movb   $0x6,(%rax,%rcx,1)
  8c652d:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c6531:	c6 04 08 08          	movb   $0x8,(%rax,%rcx,1)
  8c6535:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c6539:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c6540:	00 
  8c6541:	ff c1                	inc    %ecx
  8c6543:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c6549:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8c6550:	48 89 df             	mov    %rbx,%rdi
  8c6553:	48 89 ee             	mov    %rbp,%rsi
  8c6556:	c5 f8 77             	vzeroupper
  8c6559:	e8 42 8c 00 00       	call   8cf1a0 <check_lower_offset>
  8c655e:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c6564:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c656a:	77 2a                	ja     8c6596 <check_lower_drain+0x2bb6>
  8c656c:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6572:	73 22                	jae    8c6596 <check_lower_drain+0x2bb6>
  8c6574:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c657b:	75 45                	jne    8c65c2 <check_lower_drain+0x2be2>
  8c657d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c6582:	be 02 00 00 00       	mov    $0x2,%esi
  8c6587:	ba 08 00 00 00       	mov    $0x8,%edx
  8c658c:	48 89 df             	mov    %rbx,%rdi
  8c658f:	e8 2c b9 01 00       	call   8e1ec0 <check_lower_emit_tracked>
  8c6594:	eb 6a                	jmp    8c6600 <check_lower_drain+0x2c20>
  8c6596:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c659a:	48 8b 00             	mov    (%rax),%rax
  8c659d:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c65a4:	75 5a                	jne    8c6600 <check_lower_drain+0x2c20>
  8c65a6:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c65ad:	00 00 00 
  8c65b0:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c65b6:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c65ba:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c65c0:	eb 3e                	jmp    8c6600 <check_lower_drain+0x2c20>
  8c65c2:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c65c6:	48 8b 09             	mov    (%rcx),%rcx
  8c65c9:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c65d0:	75 2e                	jne    8c6600 <check_lower_drain+0x2c20>
  8c65d2:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c65d6:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c65db:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c65df:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c65e3:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c65e7:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c65eb:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c65ef:	ff c0                	inc    %eax
  8c65f1:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c65f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8c65fe:	00 00 
  8c6600:	48 89 df             	mov    %rbx,%rdi
  8c6603:	48 89 ee             	mov    %rbp,%rsi
  8c6606:	e8 95 8b 00 00       	call   8cf1a0 <check_lower_offset>
  8c660b:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c6611:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c6617:	77 4e                	ja     8c6667 <check_lower_drain+0x2c87>
  8c6619:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c661f:	73 46                	jae    8c6667 <check_lower_drain+0x2c87>
  8c6621:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c6628:	0f 84 3b fe ff ff    	je     8c6469 <check_lower_drain+0x2a89>
  8c662e:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6632:	48 8b 09             	mov    (%rcx),%rcx
  8c6635:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c663c:	0f 85 39 fe ff ff    	jne    8c647b <check_lower_drain+0x2a9b>
  8c6642:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c6646:	c6 04 01 29          	movb   $0x29,(%rcx,%rax,1)
  8c664a:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c664e:	c6 04 01 00          	movb   $0x0,(%rcx,%rax,1)
  8c6652:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c6656:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c665a:	ff c0                	inc    %eax
  8c665c:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c6662:	e9 14 fe ff ff       	jmp    8c647b <check_lower_drain+0x2a9b>
  8c6667:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c666b:	48 8b 00             	mov    (%rax),%rax
  8c666e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6675:	0f 85 00 fe ff ff    	jne    8c647b <check_lower_drain+0x2a9b>
  8c667b:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6682:	00 00 00 
  8c6685:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c668b:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c668f:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6695:	e9 e1 fd ff ff       	jmp    8c647b <check_lower_drain+0x2a9b>
  8c669a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c66a1:	01 00 00 
  8c66a4:	49 85 c4             	test   %rax,%r12
  8c66a7:	0f 84 47 d4 ff ff    	je     8c3af4 <check_lower_drain+0x114>
  8c66ad:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c66b2:	be 02 00 00 00       	mov    $0x2,%esi
  8c66b7:	ba 08 00 00 00       	mov    $0x8,%edx
  8c66bc:	48 89 df             	mov    %rbx,%rdi
  8c66bf:	c5 f8 77             	vzeroupper
  8c66c2:	e8 c9 28 00 00       	call   8c8f90 <check_lower_emit>
  8c66c7:	e9 28 d4 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c66cc:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c66d3:	00 00 00 
  8c66d6:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c66dc:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c66e0:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c66e6:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c66ea:	48 8b 00             	mov    (%rax),%rax
  8c66ed:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c66f4:	0f 85 ac ea ff ff    	jne    8c51a6 <check_lower_drain+0x17c6>
  8c66fa:	e9 3b dc ff ff       	jmp    8c433a <check_lower_drain+0x95a>
  8c66ff:	40 80 fe 0a          	cmp    $0xa,%sil
  8c6703:	4c 8d 05 cb 30 dc ff 	lea    -0x23cf35(%rip),%r8        # 6897d5 <fuzz_comment_end+0x26cbc>
  8c670a:	48 8d 0d af c7 d0 ff 	lea    -0x2f3851(%rip),%rcx        # 5d2ec0 <parse_test_openers+0x6bc3>
  8c6711:	e9 ea d9 ff ff       	jmp    8c4100 <check_lower_drain+0x720>
  8c6716:	45 31 d2             	xor    %r10d,%r10d
  8c6719:	31 ed                	xor    %ebp,%ebp
  8c671b:	49 be 00 00 00 00 00 	movabs $0x10000000000,%r14
  8c6722:	01 00 00 
  8c6725:	4d 85 f4             	test   %r14,%r12
  8c6728:	74 49                	je     8c6773 <check_lower_drain+0x2d93>
  8c672a:	45 85 c9             	test   %r9d,%r9d
  8c672d:	75 44                	jne    8c6773 <check_lower_drain+0x2d93>
  8c672f:	83 79 04 01          	cmpl   $0x1,0x4(%rcx)
  8c6733:	0f 85 a0 01 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c6739:	83 39 08             	cmpl   $0x8,(%rcx)
  8c673c:	0f 84 97 01 00 00    	je     8c68d9 <check_lower_drain+0x2ef9>
  8c6742:	83 79 44 00          	cmpl   $0x0,0x44(%rcx)
  8c6746:	41 f6 d2             	not    %r10b
  8c6749:	41 0f 95 c0          	setne  %r8b
  8c674d:	41 08 ea             	or     %bpl,%r10b
  8c6750:	45 08 c2             	or     %r8b,%r10b
  8c6753:	41 f6 c2 01          	test   $0x1,%r10b
  8c6757:	0f 85 7c 01 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c675d:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c6761:	8b 04 b8             	mov    (%rax,%rdi,4),%eax
  8c6764:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c676a:	48 8b 51 48          	mov    0x48(%rcx),%rdx
  8c676e:	e9 f4 04 00 00       	jmp    8c6c67 <check_lower_drain+0x3287>
  8c6773:	49 ba 00 00 00 00 00 	movabs $0x10000000000,%r10
  8c677a:	01 00 00 
  8c677d:	4d 85 d4             	test   %r10,%r12
  8c6780:	0f 85 53 01 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c6786:	44 8b 31             	mov    (%rcx),%r14d
  8c6789:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  8c678f:	41 c1 ee 03          	shr    $0x3,%r14d
  8c6793:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c679a:	73 04                	jae    8c67a0 <check_lower_drain+0x2dc0>
  8c679c:	47 8b 14 b3          	mov    (%r11,%r14,4),%r10d
  8c67a0:	48 85 f6             	test   %rsi,%rsi
  8c67a3:	74 0d                	je     8c67b2 <check_lower_drain+0x2dd2>
  8c67a5:	41 3b b0 c0 00 00 00 	cmp    0xc0(%r8),%esi
  8c67ac:	40 0f 92 c5          	setb   %bpl
  8c67b0:	eb 02                	jmp    8c67b4 <check_lower_drain+0x2dd4>
  8c67b2:	31 ed                	xor    %ebp,%ebp
  8c67b4:	45 0f b6 f2          	movzbl %r10b,%r14d
  8c67b8:	45 8d 5e ff          	lea    -0x1(%r14),%r11d
  8c67bc:	41 83 fb 0a          	cmp    $0xa,%r11d
  8c67c0:	41 0f 93 c7          	setae  %r15b
  8c67c4:	41 f7 c2 00 05 00 00 	test   $0x500,%r10d
  8c67cb:	41 0f 95 c5          	setne  %r13b
  8c67cf:	45 08 fd             	or     %r15b,%r13b
  8c67d2:	0f 85 01 01 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c67d8:	83 79 44 00          	cmpl   $0x0,0x44(%rcx)
  8c67dc:	0f 85 f7 00 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c67e2:	45 85 c9             	test   %r9d,%r9d
  8c67e5:	49 bd 00 00 00 00 00 	movabs $0x20000000000,%r13
  8c67ec:	02 00 00 
  8c67ef:	41 0f 94 c7          	sete   %r15b
  8c67f3:	4d 85 ec             	test   %r13,%r12
  8c67f6:	41 0f 94 c5          	sete   %r13b
  8c67fa:	41 20 ed             	and    %bpl,%r13b
  8c67fd:	45 20 fd             	and    %r15b,%r13b
  8c6800:	41 80 fd 01          	cmp    $0x1,%r13b
  8c6804:	75 26                	jne    8c682c <check_lower_drain+0x2e4c>
  8c6806:	4c 8b a8 90 02 00 00 	mov    0x290(%rax),%r13
  8c680d:	44 8d 7e ff          	lea    -0x1(%rsi),%r15d
  8c6811:	43 80 7c 3d 00 00    	cmpb   $0x0,0x0(%r13,%r15,1)
  8c6817:	74 13                	je     8c682c <check_lower_drain+0x2e4c>
  8c6819:	4c 8b a8 78 02 00 00 	mov    0x278(%rax),%r13
  8c6820:	43 80 7c 3d 00 00    	cmpb   $0x0,0x0(%r13,%r15,1)
  8c6826:	0f 84 ad 00 00 00    	je     8c68d9 <check_lower_drain+0x2ef9>
  8c682c:	44 8b 79 0c          	mov    0xc(%rcx),%r15d
  8c6830:	45 85 ff             	test   %r15d,%r15d
  8c6833:	74 1a                	je     8c684f <check_lower_drain+0x2e6f>
  8c6835:	83 79 54 00          	cmpl   $0x0,0x54(%rcx)
  8c6839:	75 14                	jne    8c684f <check_lower_drain+0x2e6f>
  8c683b:	44 0f b7 69 08       	movzwl 0x8(%rcx),%r13d
  8c6840:	41 f7 c5 10 08 00 00 	test   $0x810,%r13d
  8c6847:	75 06                	jne    8c684f <check_lower_drain+0x2e6f>
  8c6849:	83 79 04 00          	cmpl   $0x0,0x4(%rcx)
  8c684d:	74 69                	je     8c68b8 <check_lower_drain+0x2ed8>
  8c684f:	45 85 c9             	test   %r9d,%r9d
  8c6852:	0f 85 81 00 00 00    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c6858:	83 79 04 01          	cmpl   $0x1,0x4(%rcx)
  8c685c:	0f 94 c1             	sete   %cl
  8c685f:	40 20 e9             	and    %bpl,%cl
  8c6862:	80 f9 01             	cmp    $0x1,%cl
  8c6865:	75 72                	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c6867:	48 8b 4b 68          	mov    0x68(%rbx),%rcx
  8c686b:	4d 8b 80 80 00 00 00 	mov    0x80(%r8),%r8
  8c6872:	8b 0c b1             	mov    (%rcx,%rsi,4),%ecx
  8c6875:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
  8c6879:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8c687c:	41 0f 94 c1          	sete   %r9b
  8c6880:	45 00 c9             	add    %r9b,%r9b
  8c6883:	41 80 c1 02          	add    $0x2,%r9b
  8c6887:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8c688a:	0f 44 ce             	cmove  %esi,%ecx
  8c688d:	75 04                	jne    8c6893 <check_lower_drain+0x2eb3>
  8c688f:	85 f6                	test   %esi,%esi
  8c6891:	74 46                	je     8c68d9 <check_lower_drain+0x2ef9>
  8c6893:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c6897:	41 0f b6 f1          	movzbl %r9b,%esi
  8c689b:	41 0f b6 d2          	movzbl %r10b,%edx
  8c689f:	8b 04 b8             	mov    (%rax,%rdi,4),%eax
  8c68a2:	48 89 df             	mov    %rbx,%rdi
  8c68a5:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c68ab:	c5 f8 77             	vzeroupper
  8c68ae:	e8 dd 26 00 00       	call   8c8f90 <check_lower_emit>
  8c68b3:	e9 66 23 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c68b8:	41 83 f9 3e          	cmp    $0x3e,%r9d
  8c68bc:	0f 87 07 10 00 00    	ja     8c78c9 <check_lower_drain+0x3ee9>
  8c68c2:	49 b8 00 00 00 00 08 	movabs $0x4080000800000000,%r8
  8c68c9:	00 80 40 
  8c68cc:	44 89 ce             	mov    %r9d,%esi
  8c68cf:	49 0f a3 f0          	bt     %rsi,%r8
  8c68d3:	0f 83 f0 0f 00 00    	jae    8c78c9 <check_lower_drain+0x3ee9>
  8c68d9:	80 bb f9 01 00 00 00 	cmpb   $0x0,0x1f9(%rbx)
  8c68e0:	75 77                	jne    8c6959 <check_lower_drain+0x2f79>
  8c68e2:	4c 8b bb a8 01 00 00 	mov    0x1a8(%rbx),%r15
  8c68e9:	48 b9 00 00 00 00 00 	movabs $0x40000000000,%rcx
  8c68f0:	04 00 00 
  8c68f3:	4d 85 ff             	test   %r15,%r15
  8c68f6:	0f 94 c0             	sete   %al
  8c68f9:	49 85 cc             	test   %rcx,%r12
  8c68fc:	0f 95 c1             	setne  %cl
  8c68ff:	08 c1                	or     %al,%cl
  8c6901:	75 56                	jne    8c6959 <check_lower_drain+0x2f79>
  8c6903:	4c 8b 03             	mov    (%rbx),%r8
  8c6906:	44 89 e1             	mov    %r12d,%ecx
  8c6909:	49 8b 28             	mov    (%r8),%rbp
  8c690c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  8c6910:	8b 34 88             	mov    (%rax,%rcx,4),%esi
  8c6913:	48 83 fe 34          	cmp    $0x34,%rsi
  8c6917:	0f 87 af 06 00 00    	ja     8c6fcc <check_lower_drain+0x35ec>
  8c691d:	48 bf 02 00 00 01 12 	movabs $0x10001201000002,%rdi
  8c6924:	00 10 00 
  8c6927:	48 0f a3 f7          	bt     %rsi,%rdi
  8c692b:	0f 83 9b 06 00 00    	jae    8c6fcc <check_lower_drain+0x35ec>
  8c6931:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c6938:	01 00 00 
  8c693b:	31 d2                	xor    %edx,%edx
  8c693d:	48 89 df             	mov    %rbx,%rdi
  8c6940:	44 89 e6             	mov    %r12d,%esi
  8c6943:	49 85 c4             	test   %rax,%r12
  8c6946:	0f 95 c2             	setne  %dl
  8c6949:	c5 f8 77             	vzeroupper
  8c694c:	e8 9f 2c 01 00       	call   8d95f0 <check_lower_batch_chain>
  8c6951:	84 c0                	test   %al,%al
  8c6953:	0f 85 9b d1 ff ff    	jne    8c3af4 <check_lower_drain+0x114>
  8c6959:	48 8b 33             	mov    (%rbx),%rsi
  8c695c:	44 89 e5             	mov    %r12d,%ebp
  8c695f:	48 8d 44 6d 00       	lea    0x0(%rbp,%rbp,2),%rax
  8c6964:	8b 93 b0 01 00 00    	mov    0x1b0(%rbx),%edx
  8c696a:	48 c1 e0 05          	shl    $0x5,%rax
  8c696e:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  8c6972:	89 54 24 48          	mov    %edx,0x48(%rsp)
  8c6976:	4c 8b 77 08          	mov    0x8(%rdi),%r14
  8c697a:	41 8b 0c 06          	mov    (%r14,%rax,1),%ecx
  8c697e:	c1 e9 03             	shr    $0x3,%ecx
  8c6981:	39 d1                	cmp    %edx,%ecx
  8c6983:	73 2b                	jae    8c69b0 <check_lower_drain+0x2fd0>
  8c6985:	48 8b 93 a0 01 00 00 	mov    0x1a0(%rbx),%rdx
  8c698c:	0f b6 14 0a          	movzbl (%rdx,%rcx,1),%edx
  8c6990:	41 89 d0             	mov    %edx,%r8d
  8c6993:	41 80 e0 04          	and    $0x4,%r8b
  8c6997:	41 c0 e8 02          	shr    $0x2,%r8b
  8c699b:	44 89 44 24 54       	mov    %r8d,0x54(%rsp)
  8c69a0:	f6 c2 01             	test   $0x1,%dl
  8c69a3:	74 18                	je     8c69bd <check_lower_drain+0x2fdd>
  8c69a5:	b1 01                	mov    $0x1,%cl
  8c69a7:	41 b3 08             	mov    $0x8,%r11b
  8c69aa:	89 4c 24 78          	mov    %ecx,0x78(%rsp)
  8c69ae:	eb 21                	jmp    8c69d1 <check_lower_drain+0x2ff1>
  8c69b0:	41 b3 ff             	mov    $0xff,%r11b
  8c69b3:	c7 44 24 54 00 00 00 	movl   $0x0,0x54(%rsp)
  8c69ba:	00 
  8c69bb:	eb 0c                	jmp    8c69c9 <check_lower_drain+0x2fe9>
  8c69bd:	48 8b 93 98 01 00 00 	mov    0x198(%rbx),%rdx
  8c69c4:	44 0f b6 1c 0a       	movzbl (%rdx,%rcx,1),%r11d
  8c69c9:	c7 44 24 78 00 00 00 	movl   $0x0,0x78(%rsp)
  8c69d0:	00 
  8c69d1:	4c 8b 3e             	mov    (%rsi),%r15
  8c69d4:	49 01 c6             	add    %rax,%r14
  8c69d7:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  8c69db:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  8c69e0:	48 89 7c 24 38       	mov    %rdi,0x38(%rsp)
  8c69e5:	49 8b 47 18          	mov    0x18(%r15),%rax
  8c69e9:	49 8b 17             	mov    (%r15),%rdx
  8c69ec:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
  8c69f1:	49 8b 77 10          	mov    0x10(%r15),%rsi
  8c69f5:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
  8c69f8:	44 8b 14 aa          	mov    (%rdx,%rbp,4),%r10d
  8c69fc:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  8c6a00:	44 8b 2c ae          	mov    (%rsi,%rbp,4),%r13d
  8c6a04:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  8c6a0b:	00 
  8c6a0c:	48 89 e8             	mov    %rbp,%rax
  8c6a0f:	48 c1 e0 05          	shl    $0x5,%rax
  8c6a13:	8b 0c 02             	mov    (%rdx,%rax,1),%ecx
  8c6a16:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  8c6a1b:	8b 4c 02 08          	mov    0x8(%rdx,%rax,1),%ecx
  8c6a1f:	49 8b 47 08          	mov    0x8(%r15),%rax
  8c6a23:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
  8c6a26:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c6a2c:	41 8b 56 0c          	mov    0xc(%r14),%edx
  8c6a30:	85 d2                	test   %edx,%edx
  8c6a32:	74 07                	je     8c6a3b <check_lower_drain+0x305b>
  8c6a34:	41 83 7e 54 00       	cmpl   $0x0,0x54(%r14)
  8c6a39:	74 04                	je     8c6a3f <check_lower_drain+0x305f>
  8c6a3b:	31 ff                	xor    %edi,%edi
  8c6a3d:	eb 0c                	jmp    8c6a4b <check_lower_drain+0x306b>
  8c6a3f:	41 f7 46 08 10 08 00 	testl  $0x810,0x8(%r14)
  8c6a46:	00 
  8c6a47:	40 0f 94 c7          	sete   %dil
  8c6a4b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c6a52:	01 00 00 
  8c6a55:	48 be 00 00 00 00 00 	movabs $0x40000000000,%rsi
  8c6a5c:	04 00 00 
  8c6a5f:	4d 89 e0             	mov    %r12,%r8
  8c6a62:	49 21 c0             	and    %rax,%r8
  8c6a65:	4c 89 e0             	mov    %r12,%rax
  8c6a68:	48 21 f0             	and    %rsi,%rax
  8c6a6b:	4c 89 c6             	mov    %r8,%rsi
  8c6a6e:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  8c6a73:	48 c1 ee 28          	shr    $0x28,%rsi
  8c6a77:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
  8c6a7e:	02 00 00 
  8c6a81:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  8c6a86:	49 85 c4             	test   %rax,%r12
  8c6a89:	0f 85 1d 01 00 00    	jne    8c6bac <check_lower_drain+0x31cc>
  8c6a8f:	45 85 d2             	test   %r10d,%r10d
  8c6a92:	0f 85 14 01 00 00    	jne    8c6bac <check_lower_drain+0x31cc>
  8c6a98:	45 8b 46 40          	mov    0x40(%r14),%r8d
  8c6a9c:	45 85 c0             	test   %r8d,%r8d
  8c6a9f:	0f 84 24 01 00 00    	je     8c6bc9 <check_lower_drain+0x31e9>
  8c6aa5:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6aaa:	44 3b 80 c0 00 00 00 	cmp    0xc0(%rax),%r8d
  8c6ab1:	0f 83 12 01 00 00    	jae    8c6bc9 <check_lower_drain+0x31e9>
  8c6ab7:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6abc:	41 ff c8             	dec    %r8d
  8c6abf:	4c 8b 08             	mov    (%rax),%r9
  8c6ac2:	4c 89 e8             	mov    %r13,%rax
  8c6ac5:	4d 89 f5             	mov    %r14,%r13
  8c6ac8:	4d 89 de             	mov    %r11,%r14
  8c6acb:	49 89 cb             	mov    %rcx,%r11
  8c6ace:	4c 89 d1             	mov    %r10,%rcx
  8c6ad1:	4d 8b 91 90 02 00 00 	mov    0x290(%r9),%r10
  8c6ad8:	43 80 3c 02 00       	cmpb   $0x0,(%r10,%r8,1)
  8c6add:	49 89 ca             	mov    %rcx,%r10
  8c6ae0:	4c 89 d9             	mov    %r11,%rcx
  8c6ae3:	4d 89 f3             	mov    %r14,%r11
  8c6ae6:	4d 89 ee             	mov    %r13,%r14
  8c6ae9:	49 89 c5             	mov    %rax,%r13
  8c6aec:	0f 84 d7 00 00 00    	je     8c6bc9 <check_lower_drain+0x31e9>
  8c6af2:	4d 8b 89 78 02 00 00 	mov    0x278(%r9),%r9
  8c6af9:	43 80 3c 01 00       	cmpb   $0x0,(%r9,%r8,1)
  8c6afe:	0f 85 c5 00 00 00    	jne    8c6bc9 <check_lower_drain+0x31e9>
  8c6b04:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6b09:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8c6b0d:	48 85 c9             	test   %rcx,%rcx
  8c6b10:	0f 84 de 20 00 00    	je     8c8bf4 <check_lower_drain+0x5214>
  8c6b16:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  8c6b1a:	46 8b 3c 81          	mov    (%rcx,%r8,4),%r15d
  8c6b1e:	45 85 ff             	test   %r15d,%r15d
  8c6b21:	0f 84 cd 20 00 00    	je     8c8bf4 <check_lower_drain+0x5214>
  8c6b27:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c6b2c:	48 8d 8c 24 c2 00 00 	lea    0xc2(%rsp),%rcx
  8c6b33:	00 
  8c6b34:	c7 84 24 b0 00 00 00 	movl   $0x0,0xb0(%rsp)
  8c6b3b:	00 00 00 00 
  8c6b3f:	44 89 a4 24 b4 00 00 	mov    %r12d,0xb4(%rsp)
  8c6b46:	00 
  8c6b47:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c6b4b:	48 89 df             	mov    %rbx,%rdi
  8c6b4e:	c5 fa 7f 41 f6       	vmovdqu %xmm0,-0xa(%rcx)
  8c6b53:	40 88 b4 24 c8 00 00 	mov    %sil,0xc8(%rsp)
  8c6b5a:	00 
  8c6b5b:	c6 84 24 c9 00 00 00 	movb   $0x1,0xc9(%rsp)
  8c6b62:	01 
  8c6b63:	48 c1 e8 2a          	shr    $0x2a,%rax
  8c6b67:	88 84 24 ca 00 00 00 	mov    %al,0xca(%rsp)
  8c6b6e:	c6 41 0d 00          	movb   $0x0,0xd(%rcx)
  8c6b72:	c7 41 09 00 00 00 00 	movl   $0x0,0x9(%rcx)
  8c6b79:	c5 fe 6f 84 24 b0 00 	vmovdqu 0xb0(%rsp),%ymm0
  8c6b80:	00 00 
  8c6b82:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c6b87:	c5 f8 77             	vzeroupper
  8c6b8a:	e8 01 67 00 00       	call   8cd290 <check_lower_push>
  8c6b8f:	41 8b 76 40          	mov    0x40(%r14),%esi
  8c6b93:	41 ff cf             	dec    %r15d
  8c6b96:	48 89 df             	mov    %rbx,%rdi
  8c6b99:	4c 89 fa             	mov    %r15,%rdx
  8c6b9c:	ff ce                	dec    %esi
  8c6b9e:	48 c1 e6 20          	shl    $0x20,%rsi
  8c6ba2:	e8 39 2b 00 00       	call   8c96e0 <check_lower_initializer>
  8c6ba7:	e9 72 20 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6bac:	41 83 fa 37          	cmp    $0x37,%r10d
  8c6bb0:	75 17                	jne    8c6bc9 <check_lower_drain+0x31e9>
  8c6bb2:	40 0f b6 d6          	movzbl %sil,%edx
  8c6bb6:	48 89 df             	mov    %rbx,%rdi
  8c6bb9:	44 89 e6             	mov    %r12d,%esi
  8c6bbc:	c5 f8 77             	vzeroupper
  8c6bbf:	e8 ec 34 01 00       	call   8da0b0 <check_lower_region>
  8c6bc4:	e9 55 20 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6bc9:	40 84 ff             	test   %dil,%dil
  8c6bcc:	74 60                	je     8c6c2e <check_lower_drain+0x324e>
  8c6bce:	41 83 fa 23          	cmp    $0x23,%r10d
  8c6bd2:	0f 84 9f 00 00 00    	je     8c6c77 <check_lower_drain+0x3297>
  8c6bd8:	41 83 fa 3e          	cmp    $0x3e,%r10d
  8c6bdc:	0f 84 95 00 00 00    	je     8c6c77 <check_lower_drain+0x3297>
  8c6be2:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c6be8:	75 07                	jne    8c6bf1 <check_lower_drain+0x3211>
  8c6bea:	41 83 7e 04 00       	cmpl   $0x0,0x4(%r14)
  8c6bef:	74 1e                	je     8c6c0f <check_lower_drain+0x322f>
  8c6bf1:	8b 44 24 54          	mov    0x54(%rsp),%eax
  8c6bf5:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c6bfb:	89 c7                	mov    %eax,%edi
  8c6bfd:	40 0f 94 c6          	sete   %sil
  8c6c01:	40 80 f7 01          	xor    $0x1,%dil
  8c6c05:	40 84 fe             	test   %dil,%sil
  8c6c08:	75 24                	jne    8c6c2e <check_lower_drain+0x324e>
  8c6c0a:	83 fa 03             	cmp    $0x3,%edx
  8c6c0d:	75 1f                	jne    8c6c2e <check_lower_drain+0x324e>
  8c6c0f:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  8c6c15:	0f 85 03 20 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c6c1b:	48 89 df             	mov    %rbx,%rdi
  8c6c1e:	4c 89 f6             	mov    %r14,%rsi
  8c6c21:	c5 f8 77             	vzeroupper
  8c6c24:	e8 a7 74 00 00       	call   8ce0d0 <check_lower_constant>
  8c6c29:	e9 f0 1f 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6c2e:	41 83 fa 34          	cmp    $0x34,%r10d
  8c6c32:	0f 84 99 00 00 00    	je     8c6cd1 <check_lower_drain+0x32f1>
  8c6c38:	45 85 d2             	test   %r10d,%r10d
  8c6c3b:	75 3a                	jne    8c6c77 <check_lower_drain+0x3297>
  8c6c3d:	41 83 3e 08          	cmpl   $0x8,(%r14)
  8c6c41:	0f 84 d7 1f 00 00    	je     8c8c1e <check_lower_drain+0x523e>
  8c6c47:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c6c4d:	8b 4c 24 54          	mov    0x54(%rsp),%ecx
  8c6c51:	41 8b 76 40          	mov    0x40(%r14),%esi
  8c6c55:	0f 94 c0             	sete   %al
  8c6c58:	80 f1 01             	xor    $0x1,%cl
  8c6c5b:	84 c8                	test   %cl,%al
  8c6c5d:	0f 85 40 02 00 00    	jne    8c6ea3 <check_lower_drain+0x34c3>
  8c6c63:	49 8b 56 48          	mov    0x48(%r14),%rdx
  8c6c67:	48 89 df             	mov    %rbx,%rdi
  8c6c6a:	c5 f8 77             	vzeroupper
  8c6c6d:	e8 ae 81 00 00       	call   8cee20 <check_lower_address>
  8c6c72:	e9 a7 1f 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6c77:	44 89 d2             	mov    %r10d,%edx
  8c6c7a:	83 e2 fe             	and    $0xfffffffe,%edx
  8c6c7d:	83 fa 40             	cmp    $0x40,%edx
  8c6c80:	75 72                	jne    8c6cf4 <check_lower_drain+0x3314>
  8c6c82:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c6c87:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  8c6c8c:	4f 8d 74 6d 00       	lea    0x0(%r13,%r13,2),%r14
  8c6c91:	49 c1 e6 05          	shl    $0x5,%r14
  8c6c95:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c6c99:	48 8b 4d 00          	mov    0x0(%rbp),%rcx
  8c6c9d:	46 8b 3c 30          	mov    (%rax,%r14,1),%r15d
  8c6ca1:	41 c1 ef 03          	shr    $0x3,%r15d
  8c6ca5:	42 80 3c 39 0f       	cmpb   $0xf,(%rcx,%r15,1)
  8c6caa:	4c 89 fa             	mov    %r15,%rdx
  8c6cad:	75 0b                	jne    8c6cba <check_lower_drain+0x32da>
  8c6caf:	48 8b 55 20          	mov    0x20(%rbp),%rdx
  8c6cb3:	42 8b 14 ba          	mov    (%rdx,%r15,4),%edx
  8c6cb7:	c1 ea 03             	shr    $0x3,%edx
  8c6cba:	0f b6 0c 11          	movzbl (%rcx,%rdx,1),%ecx
  8c6cbe:	80 f9 06             	cmp    $0x6,%cl
  8c6cc1:	0f 84 ef 00 00 00    	je     8c6db6 <check_lower_drain+0x33d6>
  8c6cc7:	41 83 fa 40          	cmp    $0x40,%r10d
  8c6ccb:	0f 85 e5 00 00 00    	jne    8c6db6 <check_lower_drain+0x33d6>
  8c6cd1:	31 c9                	xor    %ecx,%ecx
  8c6cd3:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c6cd9:	0f 95 c1             	setne  %cl
  8c6cdc:	48 89 df             	mov    %rbx,%rdi
  8c6cdf:	44 89 e6             	mov    %r12d,%esi
  8c6ce2:	31 d2                	xor    %edx,%edx
  8c6ce4:	45 31 c0             	xor    %r8d,%r8d
  8c6ce7:	c5 f8 77             	vzeroupper
  8c6cea:	e8 61 3d 01 00       	call   8daa50 <check_lower_operand>
  8c6cef:	e9 2a 1f 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6cf4:	41 8d 72 c7          	lea    -0x39(%r10),%esi
  8c6cf8:	83 fe 01             	cmp    $0x1,%esi
  8c6cfb:	0f 87 d8 00 00 00    	ja     8c6dd9 <check_lower_drain+0x33f9>
  8c6d01:	49 8b 47 38          	mov    0x38(%r15),%rax
  8c6d05:	44 8b 34 a8          	mov    (%rax,%rbp,4),%r14d
  8c6d09:	45 85 f6             	test   %r14d,%r14d
  8c6d0c:	0f 84 e2 1e 00 00    	je     8c8bf4 <check_lower_drain+0x5214>
  8c6d12:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6d17:	48 8b 00             	mov    (%rax),%rax
  8c6d1a:	44 3b b0 58 03 00 00 	cmp    0x358(%rax),%r14d
  8c6d21:	0f 87 cd 1e 00 00    	ja     8c8bf4 <check_lower_drain+0x5214>
  8c6d27:	48 8b 80 50 03 00 00 	mov    0x350(%rax),%rax
  8c6d2e:	48 8b 93 80 01 00 00 	mov    0x180(%rbx),%rdx
  8c6d35:	41 ff ce             	dec    %r14d
  8c6d38:	4b 8d 0c f6          	lea    (%r14,%r14,8),%rcx
  8c6d3c:	8b 44 88 14          	mov    0x14(%rax,%rcx,4),%eax
  8c6d40:	3b 42 04             	cmp    0x4(%rdx),%eax
  8c6d43:	0f 85 ab 1e 00 00    	jne    8c8bf4 <check_lower_drain+0x5214>
  8c6d49:	48 8b 83 98 00 00 00 	mov    0x98(%rbx),%rax
  8c6d50:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c6d54:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c6d57:	75 2c                	jne    8c6d85 <check_lower_drain+0x33a5>
  8c6d59:	be 08 00 00 00       	mov    $0x8,%esi
  8c6d5e:	48 89 df             	mov    %rbx,%rdi
  8c6d61:	4d 89 d7             	mov    %r10,%r15
  8c6d64:	c5 f8 77             	vzeroupper
  8c6d67:	e8 b4 77 ff ff       	call   8be520 <check_lower_temporary>
  8c6d6c:	48 8b 8b 98 00 00 00 	mov    0x98(%rbx),%rcx
  8c6d73:	4d 89 fa             	mov    %r15,%r10
  8c6d76:	42 89 04 b1          	mov    %eax,(%rcx,%r14,4)
  8c6d7a:	48 8b 83 98 00 00 00 	mov    0x98(%rbx),%rax
  8c6d81:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c6d85:	41 83 fa 39          	cmp    $0x39,%r10d
  8c6d89:	be 02 00 00 00       	mov    $0x2,%esi
  8c6d8e:	ba 1e 00 00 00       	mov    $0x1e,%edx
  8c6d93:	89 c1                	mov    %eax,%ecx
  8c6d95:	48 89 df             	mov    %rbx,%rdi
  8c6d98:	4d 89 d6             	mov    %r10,%r14
  8c6d9b:	0f 44 f2             	cmove  %edx,%esi
  8c6d9e:	ba 08 00 00 00       	mov    $0x8,%edx
  8c6da3:	c5 f8 77             	vzeroupper
  8c6da6:	e8 35 27 00 00       	call   8c94e0 <check_lower_instruction>
  8c6dab:	41 83 fe 39          	cmp    $0x39,%r14d
  8c6daf:	74 32                	je     8c6de3 <check_lower_drain+0x3403>
  8c6db1:	e9 68 1e 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6db6:	80 f9 06             	cmp    $0x6,%cl
  8c6db9:	74 45                	je     8c6e00 <check_lower_drain+0x3420>
  8c6dbb:	41 0f b6 d3          	movzbl %r11b,%edx
  8c6dbf:	be 01 00 00 00       	mov    $0x1,%esi
  8c6dc4:	48 89 df             	mov    %rbx,%rdi
  8c6dc7:	31 c9                	xor    %ecx,%ecx
  8c6dc9:	c5 f8 77             	vzeroupper
  8c6dcc:	e8 0f 27 00 00       	call   8c94e0 <check_lower_instruction>
  8c6dd1:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c6dd7:	eb 10                	jmp    8c6de9 <check_lower_drain+0x3409>
  8c6dd9:	41 83 fa 3b          	cmp    $0x3b,%r10d
  8c6ddd:	0f 85 a0 00 00 00    	jne    8c6e83 <check_lower_drain+0x34a3>
  8c6de3:	41 b8 58 00 00 00    	mov    $0x58,%r8d
  8c6de9:	48 89 df             	mov    %rbx,%rdi
  8c6dec:	44 89 e6             	mov    %r12d,%esi
  8c6def:	31 d2                	xor    %edx,%edx
  8c6df1:	31 c9                	xor    %ecx,%ecx
  8c6df3:	c5 f8 77             	vzeroupper
  8c6df6:	e8 55 3c 01 00       	call   8daa50 <check_lower_operand>
  8c6dfb:	e9 1e 1e 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6e00:	4c 01 f0             	add    %r14,%rax
  8c6e03:	83 78 04 01          	cmpl   $0x1,0x4(%rax)
  8c6e07:	0f 85 0a 01 00 00    	jne    8c6f17 <check_lower_drain+0x3537>
  8c6e0d:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c6e13:	75 1c                	jne    8c6e31 <check_lower_drain+0x3451>
  8c6e15:	41 0f b6 d3          	movzbl %r11b,%edx
  8c6e19:	be 0a 00 00 00       	mov    $0xa,%esi
  8c6e1e:	48 89 df             	mov    %rbx,%rdi
  8c6e21:	31 c9                	xor    %ecx,%ecx
  8c6e23:	4d 89 d5             	mov    %r10,%r13
  8c6e26:	c5 f8 77             	vzeroupper
  8c6e29:	e8 b2 26 00 00       	call   8c94e0 <check_lower_instruction>
  8c6e2e:	4d 89 ea             	mov    %r13,%r10
  8c6e31:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  8c6e36:	41 83 fa 41          	cmp    $0x41,%r10d
  8c6e3a:	0f 85 1a 04 00 00    	jne    8c725a <check_lower_drain+0x387a>
  8c6e40:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c6e46:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6e4c:	0f 83 5d 03 00 00    	jae    8c71af <check_lower_drain+0x37cf>
  8c6e52:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c6e56:	8d 50 01             	lea    0x1(%rax),%edx
  8c6e59:	48 c1 e0 04          	shl    $0x4,%rax
  8c6e5d:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c6e63:	48 ba 01 00 00 00 01 	movabs $0x8000100000001,%rdx
  8c6e6a:	00 08 00 
  8c6e6d:	48 83 c2 14          	add    $0x14,%rdx
  8c6e71:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c6e75:	48 c7 44 01 08 01 00 	movq   $0x1,0x8(%rcx,%rax,1)
  8c6e7c:	00 00 
  8c6e7e:	e9 56 03 00 00       	jmp    8c71d9 <check_lower_drain+0x37f9>
  8c6e83:	41 8d 72 cb          	lea    -0x35(%r10),%esi
  8c6e87:	83 fe 01             	cmp    $0x1,%esi
  8c6e8a:	0f 87 bd 00 00 00    	ja     8c6f4d <check_lower_drain+0x356d>
  8c6e90:	48 89 df             	mov    %rbx,%rdi
  8c6e93:	44 89 e6             	mov    %r12d,%esi
  8c6e96:	c5 f8 77             	vzeroupper
  8c6e99:	e8 02 3e 01 00       	call   8daca0 <check_lower_builtin_prepare>
  8c6e9e:	e9 7b 1d 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6ea3:	41 83 7e 04 01       	cmpl   $0x1,0x4(%r14)
  8c6ea8:	0f 94 c0             	sete   %al
  8c6eab:	85 f6                	test   %esi,%esi
  8c6ead:	0f 95 c1             	setne  %cl
  8c6eb0:	20 c1                	and    %al,%cl
  8c6eb2:	80 f9 01             	cmp    $0x1,%cl
  8c6eb5:	0f 85 cc 00 00 00    	jne    8c6f87 <check_lower_drain+0x35a7>
  8c6ebb:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6ec0:	8b 80 c0 00 00 00    	mov    0xc0(%rax),%eax
  8c6ec6:	39 c6                	cmp    %eax,%esi
  8c6ec8:	73 17                	jae    8c6ee1 <check_lower_drain+0x3501>
  8c6eca:	41 8d 4b f5          	lea    -0xb(%r11),%ecx
  8c6ece:	80 f9 02             	cmp    $0x2,%cl
  8c6ed1:	77 0e                	ja     8c6ee1 <check_lower_drain+0x3501>
  8c6ed3:	48 8b 4b 68          	mov    0x68(%rbx),%rcx
  8c6ed7:	83 3c b1 ff          	cmpl   $0xffffffff,(%rcx,%rsi,4)
  8c6edb:	0f 84 de 03 00 00    	je     8c72bf <check_lower_drain+0x38df>
  8c6ee1:	39 c6                	cmp    %eax,%esi
  8c6ee3:	0f 83 9e 00 00 00    	jae    8c6f87 <check_lower_drain+0x35a7>
  8c6ee9:	48 8b 43 68          	mov    0x68(%rbx),%rax
  8c6eed:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c6ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c6ef5:	48 39 c1             	cmp    %rax,%rcx
  8c6ef8:	0f 84 eb 03 00 00    	je     8c72e9 <check_lower_drain+0x3909>
  8c6efe:	41 0f b6 d3          	movzbl %r11b,%edx
  8c6f02:	be 02 00 00 00       	mov    $0x2,%esi
  8c6f07:	48 89 df             	mov    %rbx,%rdi
  8c6f0a:	c5 f8 77             	vzeroupper
  8c6f0d:	e8 7e 20 00 00       	call   8c8f90 <check_lower_emit>
  8c6f12:	e9 07 1d 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6f17:	44 3b 7c 24 48       	cmp    0x48(%rsp),%r15d
  8c6f1c:	73 12                	jae    8c6f30 <check_lower_drain+0x3550>
  8c6f1e:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c6f25:	42 f6 04 38 02       	testb  $0x2,(%rax,%r15,1)
  8c6f2a:	0f 85 dd fe ff ff    	jne    8c6e0d <check_lower_drain+0x342d>
  8c6f30:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6f34:	48 8b 00             	mov    (%rax),%rax
  8c6f37:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6f3e:	0f 85 da 1c 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c6f44:	48 8d 0d 7d bb e2 ff 	lea    -0x1d4483(%rip),%rcx        # 6f2ac8 <pp_string_value.meaning+0x3eff1>
  8c6f4b:	eb 55                	jmp    8c6fa2 <check_lower_drain+0x35c2>
  8c6f4d:	41 83 fa 3f          	cmp    $0x3f,%r10d
  8c6f51:	74 21                	je     8c6f74 <check_lower_drain+0x3594>
  8c6f53:	41 83 fa 3c          	cmp    $0x3c,%r10d
  8c6f57:	0f 85 25 02 00 00    	jne    8c7182 <check_lower_drain+0x37a2>
  8c6f5d:	49 8b 47 38          	mov    0x38(%r15),%rax
  8c6f61:	b9 df fe ff ff       	mov    $0xfffffedf,%ecx
  8c6f66:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
  8c6f69:	01 c8                	add    %ecx,%eax
  8c6f6b:	83 f8 01             	cmp    $0x1,%eax
  8c6f6e:	0f 87 fa 02 00 00    	ja     8c726e <check_lower_drain+0x388e>
  8c6f74:	48 89 df             	mov    %rbx,%rdi
  8c6f77:	44 89 e6             	mov    %r12d,%esi
  8c6f7a:	c5 f8 77             	vzeroupper
  8c6f7d:	e8 7e 45 01 00       	call   8db500 <check_lower_helper>
  8c6f82:	e9 97 1c 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c6f87:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6f8b:	48 8b 00             	mov    (%rax),%rax
  8c6f8e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6f95:	0f 85 83 1c 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c6f9b:	48 8d 0d df d4 e7 ff 	lea    -0x182b21(%rip),%rcx        # 744481 <pp_decode_file_name.meaning+0xd13d>
  8c6fa2:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c6fa9:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6fad:	48 8b 01             	mov    (%rcx),%rax
  8c6fb0:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6fb7:	0f 85 61 1c 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c6fbd:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c6fc4:	00 00 00 
  8c6fc7:	e9 42 1c 00 00       	jmp    8c8c0e <check_lower_drain+0x522e>
  8c6fcc:	48 bf 00 00 00 00 00 	movabs $0x10000000000,%rdi
  8c6fd3:	01 00 00 
  8c6fd6:	49 85 fc             	test   %rdi,%r12
  8c6fd9:	0f 85 7a f9 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c6fdf:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8c6fe5:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  8c6fec:	00 00 
  8c6fee:	83 fe 3f             	cmp    $0x3f,%esi
  8c6ff1:	77 0c                	ja     8c6fff <check_lower_drain+0x361f>
  8c6ff3:	48 8d 3d c6 88 bf ff 	lea    -0x40773a(%rip),%rdi        # 4bf8c0 <check_lower_batch_ops>
  8c6ffa:	44 0f b6 2c 3e       	movzbl (%rsi,%rdi,1),%r13d
  8c6fff:	4c 8b 5d 10          	mov    0x10(%rbp),%r11
  8c7003:	44 8d 76 fb          	lea    -0x5(%rsi),%r14d
  8c7007:	41 83 fe 10          	cmp    $0x10,%r14d
  8c700b:	44 89 74 24 38       	mov    %r14d,0x38(%rsp)
  8c7010:	40 0f 92 c7          	setb   %dil
  8c7014:	45 31 c9             	xor    %r9d,%r9d
  8c7017:	41 81 fd ff 00 00 00 	cmp    $0xff,%r13d
  8c701e:	0f 95 44 24 58       	setne  0x58(%rsp)
  8c7023:	45 8b 14 8b          	mov    (%r11,%rcx,4),%r10d
  8c7027:	4d 89 d3             	mov    %r10,%r11
  8c702a:	4c 89 54 24 30       	mov    %r10,0x30(%rsp)
  8c702f:	41 83 fe 0f          	cmp    $0xf,%r14d
  8c7033:	77 10                	ja     8c7045 <check_lower_drain+0x3665>
  8c7035:	4c 8b 5d 18          	mov    0x18(%rbp),%r11
  8c7039:	45 8b 1c 8b          	mov    (%r11,%rcx,4),%r11d
  8c703d:	45 89 de             	mov    %r11d,%r14d
  8c7040:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
  8c7045:	44 89 5c 24 54       	mov    %r11d,0x54(%rsp)
  8c704a:	44 8b 9b 40 01 00 00 	mov    0x140(%rbx),%r11d
  8c7051:	41 be 00 00 00 01    	mov    $0x1000000,%r14d
  8c7057:	41 81 fb 00 00 00 01 	cmp    $0x1000000,%r11d
  8c705e:	45 0f 42 f3          	cmovb  %r11d,%r14d
  8c7062:	45 85 ed             	test   %r13d,%r13d
  8c7065:	0f 84 ee f8 ff ff    	je     8c6959 <check_lower_drain+0x2f79>
  8c706b:	41 81 fd fe 00 00 00 	cmp    $0xfe,%r13d
  8c7072:	0f 84 e1 f8 ff ff    	je     8c6959 <check_lower_drain+0x2f79>
  8c7078:	4d 8b 40 08          	mov    0x8(%r8),%r8
  8c707c:	4d 8b 50 08          	mov    0x8(%r8),%r10
  8c7080:	4c 89 44 24 48       	mov    %r8,0x48(%rsp)
  8c7085:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  8c7089:	49 c1 e0 05          	shl    $0x5,%r8
  8c708d:	4d 01 d0             	add    %r10,%r8
  8c7090:	4c 89 54 24 60       	mov    %r10,0x60(%rsp)
  8c7095:	41 83 78 44 00       	cmpl   $0x0,0x44(%r8)
  8c709a:	0f 85 b9 f8 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c70a0:	41 83 78 0c 00       	cmpl   $0x0,0xc(%r8)
  8c70a5:	74 39                	je     8c70e0 <check_lower_drain+0x3700>
  8c70a7:	41 83 78 54 00       	cmpl   $0x0,0x54(%r8)
  8c70ac:	75 32                	jne    8c70e0 <check_lower_drain+0x3700>
  8c70ae:	45 0f b7 68 08       	movzwl 0x8(%r8),%r13d
  8c70b3:	41 f7 c5 10 08 00 00 	test   $0x810,%r13d
  8c70ba:	75 24                	jne    8c70e0 <check_lower_drain+0x3700>
  8c70bc:	41 83 78 04 00       	cmpl   $0x0,0x4(%r8)
  8c70c1:	75 1d                	jne    8c70e0 <check_lower_drain+0x3700>
  8c70c3:	83 fe 3e             	cmp    $0x3e,%esi
  8c70c6:	0f 87 8d f8 ff ff    	ja     8c6959 <check_lower_drain+0x2f79>
  8c70cc:	49 bd 00 00 00 00 08 	movabs $0x4080000800000000,%r13
  8c70d3:	00 80 40 
  8c70d6:	49 0f a3 f5          	bt     %rsi,%r13
  8c70da:	0f 83 79 f8 ff ff    	jae    8c6959 <check_lower_drain+0x2f79>
  8c70e0:	45 31 ed             	xor    %r13d,%r13d
  8c70e3:	41 88 fd             	mov    %dil,%r13b
  8c70e6:	41 8d 7d 01          	lea    0x1(%r13),%edi
  8c70ea:	4c 89 6c 24 40       	mov    %r13,0x40(%rsp)
  8c70ef:	44 39 e7             	cmp    %r12d,%edi
  8c70f2:	0f 87 61 f8 ff ff    	ja     8c6959 <check_lower_drain+0x2f79>
  8c70f8:	03 7c 24 30          	add    0x30(%rsp),%edi
  8c70fc:	44 39 e7             	cmp    %r12d,%edi
  8c70ff:	0f 85 54 f8 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c7105:	83 7c 24 38 0f       	cmpl   $0xf,0x38(%rsp)
  8c710a:	77 10                	ja     8c711c <check_lower_drain+0x373c>
  8c710c:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c7111:	ff c7                	inc    %edi
  8c7113:	44 39 e7             	cmp    %r12d,%edi
  8c7116:	0f 85 3d f8 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c711c:	44 2b b3 38 01 00 00 	sub    0x138(%rbx),%r14d
  8c7123:	0f 82 30 f8 ff ff    	jb     8c6959 <check_lower_drain+0x2f79>
  8c7129:	0f b6 7c 24 58       	movzbl 0x58(%rsp),%edi
  8c712e:	41 88 f9             	mov    %dil,%r9b
  8c7131:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  8c7136:	42 8d 7c 0f 01       	lea    0x1(%rdi,%r9,1),%edi
  8c713b:	44 39 f7             	cmp    %r14d,%edi
  8c713e:	0f 87 15 f8 ff ff    	ja     8c6959 <check_lower_drain+0x2f79>
  8c7144:	41 29 d3             	sub    %edx,%r11d
  8c7147:	0f 93 c2             	setae  %dl
  8c714a:	41 83 fb 05          	cmp    $0x5,%r11d
  8c714e:	40 0f 93 c7          	setae  %dil
  8c7152:	40 20 d7             	and    %dl,%dil
  8c7155:	40 80 ff 01          	cmp    $0x1,%dil
  8c7159:	0f 85 fa f7 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c715f:	45 31 f6             	xor    %r14d,%r14d
  8c7162:	83 fe 23             	cmp    $0x23,%esi
  8c7165:	0f 8f 44 07 00 00    	jg     8c78af <check_lower_drain+0x3ecf>
  8c716b:	83 fe 01             	cmp    $0x1,%esi
  8c716e:	0f 84 d6 0a 00 00    	je     8c7c4a <check_lower_drain+0x426a>
  8c7174:	83 fe 18             	cmp    $0x18,%esi
  8c7177:	0f 84 cd 0a 00 00    	je     8c7c4a <check_lower_drain+0x426a>
  8c717d:	e9 b8 0a 00 00       	jmp    8c7c3a <check_lower_drain+0x425a>
  8c7182:	41 8d 72 be          	lea    -0x42(%r10),%esi
  8c7186:	83 fe 02             	cmp    $0x2,%esi
  8c7189:	0f 87 f2 00 00 00    	ja     8c7281 <check_lower_drain+0x38a1>
  8c718f:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7193:	48 8b 00             	mov    (%rax),%rax
  8c7196:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c719d:	0f 85 7b 1a 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c71a3:	48 8d 0d 42 70 da ff 	lea    -0x258fbe(%rip),%rcx        # 66e1ec <fuzz_comment_end+0xb6d3>
  8c71aa:	e9 f3 fd ff ff       	jmp    8c6fa2 <check_lower_drain+0x35c2>
  8c71af:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c71b3:	48 8b 00             	mov    (%rax),%rax
  8c71b6:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c71bd:	75 1a                	jne    8c71d9 <check_lower_drain+0x37f9>
  8c71bf:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c71c6:	00 00 00 
  8c71c9:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c71cf:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c71d3:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c71d9:	48 8b 55 20          	mov    0x20(%rbp),%rdx
  8c71dd:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  8c71e1:	48 8b 4d 38          	mov    0x38(%rbp),%rcx
  8c71e5:	42 8b 04 ba          	mov    (%rdx,%r15,4),%eax
  8c71e9:	c1 e8 03             	shr    $0x3,%eax
  8c71ec:	80 3c 06 0f          	cmpb   $0xf,(%rsi,%rax,1)
  8c71f0:	75 06                	jne    8c71f8 <check_lower_drain+0x3818>
  8c71f2:	8b 04 82             	mov    (%rdx,%rax,4),%eax
  8c71f5:	c1 e8 03             	shr    $0x3,%eax
  8c71f8:	8b 93 3c 01 00 00    	mov    0x13c(%rbx),%edx
  8c71fe:	3b 93 40 01 00 00    	cmp    0x140(%rbx),%edx
  8c7204:	73 2a                	jae    8c7230 <check_lower_drain+0x3850>
  8c7206:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8c720a:	4c 8b 43 18          	mov    0x18(%rbx),%r8
  8c720e:	8d 72 01             	lea    0x1(%rdx),%esi
  8c7211:	48 c1 e2 04          	shl    $0x4,%rdx
  8c7215:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c721b:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c7222:	00 08 00 
  8c7225:	49 89 34 10          	mov    %rsi,(%r8,%rdx,1)
  8c7229:	49 89 44 10 08       	mov    %rax,0x8(%r8,%rdx,1)
  8c722e:	eb 2a                	jmp    8c725a <check_lower_drain+0x387a>
  8c7230:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7234:	48 8b 00             	mov    (%rax),%rax
  8c7237:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c723e:	75 1a                	jne    8c725a <check_lower_drain+0x387a>
  8c7240:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c7247:	00 00 00 
  8c724a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c7250:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c7254:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c725a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c725e:	31 c9                	xor    %ecx,%ecx
  8c7260:	42 83 7c 30 04 01    	cmpl   $0x1,0x4(%rax,%r14,1)
  8c7266:	0f 94 c1             	sete   %cl
  8c7269:	e9 6e fa ff ff       	jmp    8c6cdc <check_lower_drain+0x32fc>
  8c726e:	48 89 df             	mov    %rbx,%rdi
  8c7271:	44 89 e6             	mov    %r12d,%esi
  8c7274:	c5 f8 77             	vzeroupper
  8c7277:	e8 f4 4b 01 00       	call   8dbe70 <check_lower_miscellaneous_prepare>
  8c727c:	e9 9d 19 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c7281:	41 8d 72 e7          	lea    -0x19(%r10),%esi
  8c7285:	4c 89 5c 24 68       	mov    %r11,0x68(%rsp)
  8c728a:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  8c728f:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  8c7294:	83 fe 25             	cmp    $0x25,%esi
  8c7297:	0f 87 c8 01 00 00    	ja     8c7465 <check_lower_drain+0x3a85>
  8c729d:	48 8d 3d 30 01 be ff 	lea    -0x41fed0(%rip),%rdi        # 4a73d4 <cbuiltin_test_generated.edges+0xad44>
  8c72a4:	48 63 34 b7          	movslq (%rdi,%rsi,4),%rsi
  8c72a8:	48 01 fe             	add    %rdi,%rsi
  8c72ab:	ff e6                	jmp    *%rsi
  8c72ad:	48 89 df             	mov    %rbx,%rdi
  8c72b0:	44 89 e6             	mov    %r12d,%esi
  8c72b3:	31 d2                	xor    %edx,%edx
  8c72b5:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c72ba:	e9 25 fa ff ff       	jmp    8c6ce4 <check_lower_drain+0x3304>
  8c72bf:	49 8b 56 48          	mov    0x48(%r14),%rdx
  8c72c3:	48 89 df             	mov    %rbx,%rdi
  8c72c6:	4d 89 de             	mov    %r11,%r14
  8c72c9:	c5 f8 77             	vzeroupper
  8c72cc:	e8 4f 7b 00 00       	call   8cee20 <check_lower_address>
  8c72d1:	41 0f b6 d6          	movzbl %r14b,%edx
  8c72d5:	be 0a 00 00 00       	mov    $0xa,%esi
  8c72da:	48 89 df             	mov    %rbx,%rdi
  8c72dd:	31 c9                	xor    %ecx,%ecx
  8c72df:	e8 ac 1c 00 00       	call   8c8f90 <check_lower_emit>
  8c72e4:	e9 35 19 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c72e9:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c72ee:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8c72f5:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c72f8:	48 85 c9             	test   %rcx,%rcx
  8c72fb:	0f 84 f3 18 00 00    	je     8c8bf4 <check_lower_drain+0x5214>
  8c7301:	41 0f b6 d3          	movzbl %r11b,%edx
  8c7305:	be 04 00 00 00       	mov    $0x4,%esi
  8c730a:	48 89 df             	mov    %rbx,%rdi
  8c730d:	c5 f8 77             	vzeroupper
  8c7310:	e8 7b 1c 00 00       	call   8c8f90 <check_lower_emit>
  8c7315:	e9 04 19 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c731a:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c731f:	ba 00 01 00 00       	mov    $0x100,%edx
  8c7324:	44 89 e1             	mov    %r12d,%ecx
  8c7327:	4c 8b 70 60          	mov    0x60(%rax),%r14
  8c732b:	8b b0 b4 00 00 00    	mov    0xb4(%rax),%esi
  8c7331:	4c 89 f7             	mov    %r14,%rdi
  8c7334:	c5 f8 77             	vzeroupper
  8c7337:	e8 94 56 fc ff       	call   88c9d0 <check_program_builtin_index>
  8c733c:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c733f:	0f 84 61 01 00 00    	je     8c74a6 <check_lower_drain+0x3ac6>
  8c7345:	4d 85 f6             	test   %r14,%r14
  8c7348:	0f 84 58 01 00 00    	je     8c74a6 <check_lower_drain+0x3ac6>
  8c734e:	89 c0                	mov    %eax,%eax
  8c7350:	48 c1 e0 08          	shl    $0x8,%rax
  8c7354:	49 01 c6             	add    %rax,%r14
  8c7357:	41 83 be d0 00 00 00 	cmpl   $0x0,0xd0(%r14)
  8c735e:	00 
  8c735f:	0f 84 41 01 00 00    	je     8c74a6 <check_lower_drain+0x3ac6>
  8c7365:	41 83 be f0 00 00 00 	cmpl   $0x0,0xf0(%r14)
  8c736c:	00 
  8c736d:	0f 84 33 01 00 00    	je     8c74a6 <check_lower_drain+0x3ac6>
  8c7373:	48 89 df             	mov    %rbx,%rdi
  8c7376:	44 89 e6             	mov    %r12d,%esi
  8c7379:	4c 89 f2             	mov    %r14,%rdx
  8c737c:	e8 7f 4e 01 00       	call   8dc200 <check_lower_math>
  8c7381:	e9 98 18 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c7386:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c738c:	0f 95 c0             	setne  %al
  8c738f:	0a 44 24 54          	or     0x54(%rsp),%al
  8c7393:	75 17                	jne    8c73ac <check_lower_drain+0x39cc>
  8c7395:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c739a:	be 0a 00 00 00       	mov    $0xa,%esi
  8c739f:	48 89 df             	mov    %rbx,%rdi
  8c73a2:	31 c9                	xor    %ecx,%ecx
  8c73a4:	c5 f8 77             	vzeroupper
  8c73a7:	e8 34 21 00 00       	call   8c94e0 <check_lower_instruction>
  8c73ac:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  8c73b1:	48 89 df             	mov    %rbx,%rdi
  8c73b4:	44 89 e6             	mov    %r12d,%esi
  8c73b7:	31 d2                	xor    %edx,%edx
  8c73b9:	31 c9                	xor    %ecx,%ecx
  8c73bb:	c5 f8 77             	vzeroupper
  8c73be:	e8 8d 36 01 00       	call   8daa50 <check_lower_operand>
  8c73c3:	e9 56 18 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c73c8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c73cd:	ba b0 00 00 00       	mov    $0xb0,%edx
  8c73d2:	44 89 e1             	mov    %r12d,%ecx
  8c73d5:	4c 8b 70 68          	mov    0x68(%rax),%r14
  8c73d9:	8b b0 b8 00 00 00    	mov    0xb8(%rax),%esi
  8c73df:	4c 89 f7             	mov    %r14,%rdi
  8c73e2:	c5 f8 77             	vzeroupper
  8c73e5:	e8 e6 55 fc ff       	call   88c9d0 <check_program_builtin_index>
  8c73ea:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c73ed:	0f 84 01 18 00 00    	je     8c8bf4 <check_lower_drain+0x5214>
  8c73f3:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c73f8:	89 c1                	mov    %eax,%ecx
  8c73fa:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c7401:	49 01 ce             	add    %rcx,%r14
  8c7404:	48 8b 0a             	mov    (%rdx),%rcx
  8c7407:	48 8b 51 38          	mov    0x38(%rcx),%rdx
  8c740b:	b1 01                	mov    $0x1,%cl
  8c740d:	81 3c aa 30 01 00 00 	cmpl   $0x130,(%rdx,%rbp,4)
  8c7414:	75 0f                	jne    8c7425 <check_lower_drain+0x3a45>
  8c7416:	41 8b 8e 8c 00 00 00 	mov    0x8c(%r14),%ecx
  8c741d:	ff c9                	dec    %ecx
  8c741f:	83 f9 02             	cmp    $0x2,%ecx
  8c7422:	0f 92 c1             	setb   %cl
  8c7425:	84 c9                	test   %cl,%cl
  8c7427:	74 1c                	je     8c7445 <check_lower_drain+0x3a65>
  8c7429:	41 83 be a0 00 00 00 	cmpl   $0x0,0xa0(%r14)
  8c7430:	00 
  8c7431:	75 12                	jne    8c7445 <check_lower_drain+0x3a65>
  8c7433:	41 83 7e 1c 00       	cmpl   $0x0,0x1c(%r14)
  8c7438:	74 0b                	je     8c7445 <check_lower_drain+0x3a65>
  8c743a:	41 83 7e 64 00       	cmpl   $0x0,0x64(%r14)
  8c743f:	0f 84 8e 03 00 00    	je     8c77d3 <check_lower_drain+0x3df3>
  8c7445:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7449:	48 8b 00             	mov    (%rax),%rax
  8c744c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c7453:	0f 85 c5 17 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c7459:	48 8d 0d 1e b6 e2 ff 	lea    -0x1d49e2(%rip),%rcx        # 6f2a7e <pp_string_value.meaning+0x3efa7>
  8c7460:	e9 3d fb ff ff       	jmp    8c6fa2 <check_lower_drain+0x35c2>
  8c7465:	83 fa 20             	cmp    $0x20,%edx
  8c7468:	75 5d                	jne    8c74c7 <check_lower_drain+0x3ae7>
  8c746a:	83 7c 24 28 21       	cmpl   $0x21,0x28(%rsp)
  8c746f:	0f 85 d6 00 00 00    	jne    8c754b <check_lower_drain+0x3b6b>
  8c7475:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c747a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8c747f:	48 8b 01             	mov    (%rcx),%rax
  8c7482:	89 f2                	mov    %esi,%edx
  8c7484:	c1 ea 03             	shr    $0x3,%edx
  8c7487:	48 8b 49 20          	mov    0x20(%rcx),%rcx
  8c748b:	83 e6 07             	and    $0x7,%esi
  8c748e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8c7492:	04 f8                	add    $0xf8,%al
  8c7494:	3c 03                	cmp    $0x3,%al
  8c7496:	b8 00 00 00 00       	mov    $0x0,%eax
  8c749b:	0f 43 f0             	cmovae %eax,%esi
  8c749e:	0b 34 91             	or     (%rcx,%rdx,4),%esi
  8c74a1:	e9 ba 00 00 00       	jmp    8c7560 <check_lower_drain+0x3b80>
  8c74a6:	49 8b 47 38          	mov    0x38(%r15),%rax
  8c74aa:	81 3c a8 52 01 00 00 	cmpl   $0x152,(%rax,%rbp,4)
  8c74b1:	0f 84 bd fa ff ff    	je     8c6f74 <check_lower_drain+0x3594>
  8c74b7:	48 89 df             	mov    %rbx,%rdi
  8c74ba:	44 89 e6             	mov    %r12d,%esi
  8c74bd:	e8 5e 53 01 00       	call   8dc820 <check_lower_floating_prepare>
  8c74c2:	e9 57 17 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c74c7:	45 8b 06             	mov    (%r14),%r8d
  8c74ca:	83 7c 24 28 24       	cmpl   $0x24,0x28(%rsp)
  8c74cf:	0f 87 1d 01 00 00    	ja     8c75f2 <check_lower_drain+0x3c12>
  8c74d5:	8b 74 24 28          	mov    0x28(%rsp),%esi
  8c74d9:	bf f4 01 00 00       	mov    $0x1f4,%edi
  8c74de:	48 0f a3 f7          	bt     %rsi,%rdi
  8c74e2:	0f 83 f6 00 00 00    	jae    8c75de <check_lower_drain+0x3bfe>
  8c74e8:	44 89 c2             	mov    %r8d,%edx
  8c74eb:	c1 ea 03             	shr    $0x3,%edx
  8c74ee:	3b 54 24 48          	cmp    0x48(%rsp),%edx
  8c74f2:	73 1b                	jae    8c750f <check_lower_drain+0x3b2f>
  8c74f4:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c74fb:	89 d2                	mov    %edx,%edx
  8c74fd:	f6 04 10 02          	testb  $0x2,(%rax,%rdx,1)
  8c7501:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  8c7508:	00 
  8c7509:	0f 85 cc 01 00 00    	jne    8c76db <check_lower_drain+0x3cfb>
  8c750f:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c7514:	8d 51 fe             	lea    -0x2(%rcx),%edx
  8c7517:	83 fa 23             	cmp    $0x23,%edx
  8c751a:	0f 87 38 04 00 00    	ja     8c7958 <check_lower_drain+0x3f78>
  8c7520:	48 8d 35 45 ff bd ff 	lea    -0x4200bb(%rip),%rsi        # 4a746c <cbuiltin_test_generated.edges+0xaddc>
  8c7527:	48 63 14 96          	movslq (%rsi,%rdx,4),%rdx
  8c752b:	48 01 f2             	add    %rsi,%rdx
  8c752e:	ff e2                	jmp    *%rdx
  8c7530:	31 f6                	xor    %esi,%esi
  8c7532:	83 7c 24 28 02       	cmpl   $0x2,0x28(%rsp)
  8c7537:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c753c:	48 89 df             	mov    %rbx,%rdi
  8c753f:	40 0f 95 c6          	setne  %sil
  8c7543:	83 c6 07             	add    $0x7,%esi
  8c7546:	e9 57 fe ff ff       	jmp    8c73a2 <check_lower_drain+0x39c2>
  8c754b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c7550:	4b 8d 44 6d 00       	lea    0x0(%r13,%r13,2),%rax
  8c7555:	48 c1 e0 05          	shl    $0x5,%rax
  8c7559:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c755d:	8b 34 01             	mov    (%rcx,%rax,1),%esi
  8c7560:	48 c7 84 24 f8 01 00 	movq   $0x0,0x1f8(%rsp)
  8c7567:	00 00 00 00 00 
  8c756c:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  8c7571:	48 8d 8c 24 f8 01 00 	lea    0x1f8(%rsp),%rcx
  8c7578:	00 
  8c7579:	49 8b 47 38          	mov    0x38(%r15),%rax
  8c757d:	8b 14 a8             	mov    (%rax,%rbp,4),%edx
  8c7580:	c5 f8 77             	vzeroupper
  8c7583:	e8 28 f8 91 00       	call   11e6db0 <type_find_member>
  8c7588:	41 8b 4e 08          	mov    0x8(%r14),%ecx
  8c758c:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c7590:	c5 f9 7f 84 24 e0 01 	vmovdqa %xmm0,0x1e0(%rsp)
  8c7597:	00 00 
  8c7599:	48 c7 84 24 f0 01 00 	movq   $0x0,0x1f0(%rsp)
  8c75a0:	00 00 00 00 00 
  8c75a5:	85 c0                	test   %eax,%eax
  8c75a7:	74 15                	je     8c75be <check_lower_drain+0x3bde>
  8c75a9:	f6 c1 04             	test   $0x4,%cl
  8c75ac:	75 64                	jne    8c7612 <check_lower_drain+0x3c32>
  8c75ae:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  8c75b5:	00 
  8c75b6:	a8 07                	test   $0x7,%al
  8c75b8:	0f 84 79 02 00 00    	je     8c7837 <check_lower_drain+0x3e57>
  8c75be:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c75c2:	48 8b 00             	mov    (%rax),%rax
  8c75c5:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c75cc:	0f 85 4c 16 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c75d2:	48 8d 0d f1 96 d5 ff 	lea    -0x2a690f(%rip),%rcx        # 620cca <foreign_touch.flags+0x49a2>
  8c75d9:	e9 c4 f9 ff ff       	jmp    8c6fa2 <check_lower_drain+0x35c2>
  8c75de:	48 bf 02 00 00 01 10 	movabs $0x1001000002,%rdi
  8c75e5:	00 00 00 
  8c75e8:	48 0f a3 f7          	bt     %rsi,%rdi
  8c75ec:	0f 82 bf fd ff ff    	jb     8c73b1 <check_lower_drain+0x39d1>
  8c75f2:	83 fa 10             	cmp    $0x10,%edx
  8c75f5:	0f 85 14 ff ff ff    	jne    8c750f <check_lower_drain+0x3b2f>
  8c75fb:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c7600:	c1 ea 03             	shr    $0x3,%edx
  8c7603:	3b 54 24 48          	cmp    0x48(%rsp),%edx
  8c7607:	0f 82 e7 fe ff ff    	jb     8c74f4 <check_lower_drain+0x3b14>
  8c760d:	e9 fd fe ff ff       	jmp    8c750f <check_lower_drain+0x3b2f>
  8c7612:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c7617:	48 8d 94 24 e0 01 00 	lea    0x1e0(%rsp),%rdx
  8c761e:	00 
  8c761f:	44 89 e6             	mov    %r12d,%esi
  8c7622:	e8 f9 62 01 00       	call   8dd920 <check_lower_bit_member>
  8c7627:	84 c0                	test   %al,%al
  8c7629:	0f 84 84 01 00 00    	je     8c77b3 <check_lower_drain+0x3dd3>
  8c762f:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c7635:	0f 85 1f 02 00 00    	jne    8c785a <check_lower_drain+0x3e7a>
  8c763b:	8b 84 24 ec 01 00 00 	mov    0x1ec(%rsp),%eax
  8c7642:	0f b6 8c 24 f0 01 00 	movzbl 0x1f0(%rsp),%ecx
  8c7649:	00 
  8c764a:	0f b6 94 24 f1 01 00 	movzbl 0x1f1(%rsp),%edx
  8c7651:	00 
  8c7652:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c7656:	c5 fe 7f 84 24 c0 01 	vmovdqu %ymm0,0x1c0(%rsp)
  8c765d:	00 00 
  8c765f:	c7 84 24 c0 01 00 00 	movl   $0x10,0x1c0(%rsp)
  8c7666:	10 00 00 00 
  8c766a:	48 89 df             	mov    %rbx,%rdi
  8c766d:	8d 04 c5 f8 ff ff ff 	lea    -0x8(,%rax,8),%eax
  8c7674:	0b 84 24 e8 01 00 00 	or     0x1e8(%rsp),%eax
  8c767b:	c1 e1 09             	shl    $0x9,%ecx
  8c767e:	c1 e2 0d             	shl    $0xd,%edx
  8c7681:	09 ca                	or     %ecx,%edx
  8c7683:	09 c2                	or     %eax,%edx
  8c7685:	89 94 24 c8 01 00 00 	mov    %edx,0x1c8(%rsp)
  8c768c:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c7693:	00 00 
  8c7695:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c769a:	c5 f8 77             	vzeroupper
  8c769d:	e8 ee 5b 00 00       	call   8cd290 <check_lower_push>
  8c76a2:	e9 b3 01 00 00       	jmp    8c785a <check_lower_drain+0x3e7a>
  8c76a7:	31 d2                	xor    %edx,%edx
  8c76a9:	83 7c 24 28 03       	cmpl   $0x3,0x28(%rsp)
  8c76ae:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
  8c76b3:	48 89 df             	mov    %rbx,%rdi
  8c76b6:	0f 94 c2             	sete   %dl
  8c76b9:	44 89 f6             	mov    %r14d,%esi
  8c76bc:	c5 f8 77             	vzeroupper
  8c76bf:	e8 0c 64 01 00       	call   8ddad0 <check_lower_truth>
  8c76c4:	48 89 df             	mov    %rbx,%rdi
  8c76c7:	44 89 e6             	mov    %r12d,%esi
  8c76ca:	31 d2                	xor    %edx,%edx
  8c76cc:	31 c9                	xor    %ecx,%ecx
  8c76ce:	45 89 f0             	mov    %r14d,%r8d
  8c76d1:	e8 7a 33 01 00       	call   8daa50 <check_lower_operand>
  8c76d6:	e9 43 15 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c76db:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  8c76e0:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8c76e5:	c5 f8 77             	vzeroupper
  8c76e8:	e8 03 72 fe ff       	call   8ae8f0 <check_lower_complex_element>
  8c76ed:	c1 e8 03             	shr    $0x3,%eax
  8c76f0:	b1 ff                	mov    $0xff,%cl
  8c76f2:	3b 44 24 48          	cmp    0x48(%rsp),%eax
  8c76f6:	73 0b                	jae    8c7703 <check_lower_drain+0x3d23>
  8c76f8:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c76ff:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c7703:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c7708:	4b 8d 44 6d 00       	lea    0x0(%r13,%r13,2),%rax
  8c770d:	48 c1 e0 05          	shl    $0x5,%rax
  8c7711:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8c7715:	8b 34 02             	mov    (%rdx,%rax,1),%esi
  8c7718:	89 c8                	mov    %ecx,%eax
  8c771a:	c1 ee 03             	shr    $0x3,%esi
  8c771d:	3b 74 24 48          	cmp    0x48(%rsp),%esi
  8c7721:	73 17                	jae    8c773a <check_lower_drain+0x3d5a>
  8c7723:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  8c772a:	00 
  8c772b:	f6 04 30 02          	testb  $0x2,(%rax,%rsi,1)
  8c772f:	0f b6 c1             	movzbl %cl,%eax
  8c7732:	be 08 00 00 00       	mov    $0x8,%esi
  8c7737:	0f 45 c6             	cmovne %esi,%eax
  8c773a:	83 7c 24 28 02       	cmpl   $0x2,0x28(%rsp)
  8c773f:	74 34                	je     8c7775 <check_lower_drain+0x3d95>
  8c7741:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  8c7746:	74 2d                	je     8c7775 <check_lower_drain+0x3d95>
  8c7748:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
  8c774f:	00 
  8c7750:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  8c7754:	48 c1 e6 05          	shl    $0x5,%rsi
  8c7758:	8b 14 32             	mov    (%rdx,%rsi,1),%edx
  8c775b:	c1 ea 03             	shr    $0x3,%edx
  8c775e:	3b 54 24 48          	cmp    0x48(%rsp),%edx
  8c7762:	73 11                	jae    8c7775 <check_lower_drain+0x3d95>
  8c7764:	48 8b b4 24 88 00 00 	mov    0x88(%rsp),%rsi
  8c776b:	00 
  8c776c:	40 b5 08             	mov    $0x8,%bpl
  8c776f:	f6 04 16 02          	testb  $0x2,(%rsi,%rdx,1)
  8c7773:	75 02                	jne    8c7777 <check_lower_drain+0x3d97>
  8c7775:	89 cd                	mov    %ecx,%ebp
  8c7777:	0f b6 f0             	movzbl %al,%esi
  8c777a:	48 89 df             	mov    %rbx,%rdi
  8c777d:	89 74 24 20          	mov    %esi,0x20(%rsp)
  8c7781:	e8 9a 6d ff ff       	call   8be520 <check_lower_temporary>
  8c7786:	83 7c 24 28 02       	cmpl   $0x2,0x28(%rsp)
  8c778b:	41 89 c6             	mov    %eax,%r14d
  8c778e:	0f 84 f0 02 00 00    	je     8c7a84 <check_lower_drain+0x40a4>
  8c7794:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  8c7799:	44 89 f0             	mov    %r14d,%eax
  8c779c:	0f 84 e5 02 00 00    	je     8c7a87 <check_lower_drain+0x40a7>
  8c77a2:	40 0f b6 f5          	movzbl %bpl,%esi
  8c77a6:	48 89 df             	mov    %rbx,%rdi
  8c77a9:	e8 72 6d ff ff       	call   8be520 <check_lower_temporary>
  8c77ae:	e9 d4 02 00 00       	jmp    8c7a87 <check_lower_drain+0x40a7>
  8c77b3:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c77b7:	48 8b 00             	mov    (%rax),%rax
  8c77ba:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c77c1:	0f 85 57 14 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c77c7:	48 8d 0d 8e 60 e4 ff 	lea    -0x1b9f72(%rip),%rcx        # 70d85c <pp_string_value.meaning+0x59d85>
  8c77ce:	e9 cf f7 ff ff       	jmp    8c6fa2 <check_lower_drain+0x35c2>
  8c77d3:	49 8b 8f a0 00 00 00 	mov    0xa0(%r15),%rcx
  8c77da:	41 8b 76 70          	mov    0x70(%r14),%esi
  8c77de:	ba 00 00 00 00       	mov    $0x0,%edx
  8c77e3:	44 8b 2c a9          	mov    (%rcx,%rbp,4),%r13d
  8c77e7:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c77ec:	89 74 24 20          	mov    %esi,0x20(%rsp)
  8c77f0:	41 83 fd 20          	cmp    $0x20,%r13d
  8c77f4:	c4 e2 11 f7 c9       	shlx   %r13d,%ecx,%ecx
  8c77f9:	0f 43 ca             	cmovae %edx,%ecx
  8c77fc:	85 f1                	test   %esi,%ecx
  8c77fe:	0f 84 8c 03 00 00    	je     8c7b90 <check_lower_drain+0x41b0>
  8c7804:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c7808:	48 8b 09             	mov    (%rcx),%rcx
  8c780b:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c7812:	0f 85 a8 03 00 00    	jne    8c7bc0 <check_lower_drain+0x41e0>
  8c7818:	c7 81 f0 00 00 00 01 	movl   $0x1,0xf0(%rcx)
  8c781f:	00 00 00 
  8c7822:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c7828:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c782c:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c7832:	e9 89 03 00 00       	jmp    8c7bc0 <check_lower_drain+0x41e0>
  8c7837:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c783d:	0f 95 c1             	setne  %cl
  8c7840:	0a 4c 24 54          	or     0x54(%rsp),%cl
  8c7844:	75 1c                	jne    8c7862 <check_lower_drain+0x3e82>
  8c7846:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c784b:	be 0a 00 00 00       	mov    $0xa,%esi
  8c7850:	48 89 df             	mov    %rbx,%rdi
  8c7853:	31 c9                	xor    %ecx,%ecx
  8c7855:	e8 86 1c 00 00       	call   8c94e0 <check_lower_instruction>
  8c785a:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  8c7861:	00 
  8c7862:	48 83 f8 08          	cmp    $0x8,%rax
  8c7866:	0f 82 f7 01 00 00    	jb     8c7a63 <check_lower_drain+0x4083>
  8c786c:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c7872:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c7878:	0f 83 59 01 00 00    	jae    8c79d7 <check_lower_drain+0x3ff7>
  8c787e:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c7882:	8d 71 01             	lea    0x1(%rcx),%esi
  8c7885:	48 c1 e1 04          	shl    $0x4,%rcx
  8c7889:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c788f:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c7896:	00 08 00 
  8c7899:	48 83 c6 14          	add    $0x14,%rsi
  8c789d:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c78a1:	48 c7 44 0a 08 01 00 	movq   $0x1,0x8(%rdx,%rcx,1)
  8c78a8:	00 00 
  8c78aa:	e9 52 01 00 00       	jmp    8c7a01 <check_lower_drain+0x4021>
  8c78af:	83 fe 24             	cmp    $0x24,%esi
  8c78b2:	0f 84 92 03 00 00    	je     8c7c4a <check_lower_drain+0x426a>
  8c78b8:	83 fe 34             	cmp    $0x34,%esi
  8c78bb:	0f 85 79 03 00 00    	jne    8c7c3a <check_lower_drain+0x425a>
  8c78c1:	45 31 ed             	xor    %r13d,%r13d
  8c78c4:	e9 9d 03 00 00       	jmp    8c7c66 <check_lower_drain+0x4286>
  8c78c9:	41 83 ff 01          	cmp    $0x1,%r15d
  8c78cd:	0f 85 06 f0 ff ff    	jne    8c68d9 <check_lower_drain+0x2ef9>
  8c78d3:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  8c78d7:	41 b1 01             	mov    $0x1,%r9b
  8c78da:	41 83 fe 06          	cmp    $0x6,%r14d
  8c78de:	0f 87 af ef ff ff    	ja     8c6893 <check_lower_drain+0x2eb3>
  8c78e4:	41 d1 eb             	shr    $1,%r11d
  8c78e7:	ba 08 00 00 00       	mov    $0x8,%edx
  8c78ec:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  8c78f3:	c4 e2 21 f7 d2       	shlx   %r11d,%edx,%edx
  8c78f8:	c4 62 e8 f5 c1       	bzhi   %rdx,%rcx,%r8
  8c78fd:	8d 4a ff             	lea    -0x1(%rdx),%ecx
  8c7900:	c4 e2 e9 f7 f6       	shlx   %rdx,%rsi,%rsi
  8c7905:	c4 c2 f3 f7 c8       	shrx   %rcx,%r8,%rcx
  8c790a:	48 85 c9             	test   %rcx,%rcx
  8c790d:	48 0f 44 f1          	cmove  %rcx,%rsi
  8c7911:	41 f6 c2 01          	test   $0x1,%r10b
  8c7915:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c791a:	48 0f 45 ce          	cmovne %rsi,%rcx
  8c791e:	4c 09 c1             	or     %r8,%rcx
  8c7921:	e9 6d ef ff ff       	jmp    8c6893 <check_lower_drain+0x2eb3>
  8c7926:	31 c9                	xor    %ecx,%ecx
  8c7928:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c792e:	b8 08 00 00 00       	mov    $0x8,%eax
  8c7933:	ba 01 00 00 00       	mov    $0x1,%edx
  8c7938:	48 89 df             	mov    %rbx,%rdi
  8c793b:	44 89 e6             	mov    %r12d,%esi
  8c793e:	0f 95 c1             	setne  %cl
  8c7941:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  8c7947:	44 0f 45 c0          	cmovne %eax,%r8d
  8c794b:	c5 f8 77             	vzeroupper
  8c794e:	e8 fd 30 01 00       	call   8daa50 <check_lower_operand>
  8c7953:	e9 79 f4 ff ff       	jmp    8c6dd1 <check_lower_drain+0x33f1>
  8c7958:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c795d:	8d 51 eb             	lea    -0x15(%rcx),%edx
  8c7960:	83 fa 02             	cmp    $0x2,%edx
  8c7963:	0f 87 29 04 00 00    	ja     8c7d92 <check_lower_drain+0x43b2>
  8c7969:	4c 89 ea             	mov    %r13,%rdx
  8c796c:	89 d1                	mov    %edx,%ecx
  8c796e:	33 8c 24 80 00 00 00 	xor    0x80(%rsp),%ecx
  8c7975:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c797a:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c797f:	83 f0 17             	xor    $0x17,%eax
  8c7982:	c6 84 24 c0 01 00 00 	movb   $0x0,0x1c0(%rsp)
  8c7989:	00 
  8c798a:	44 89 e6             	mov    %r12d,%esi
  8c798d:	09 c1                	or     %eax,%ecx
  8c798f:	48 8d 8c 24 c0 01 00 	lea    0x1c0(%rsp),%rcx
  8c7996:	00 
  8c7997:	40 0f 94 c5          	sete   %bpl
  8c799b:	c5 f8 77             	vzeroupper
  8c799e:	e8 cd 4b fc ff       	call   88c570 <check_program_runtime_truth>
  8c79a3:	84 c0                	test   %al,%al
  8c79a5:	0f 84 eb 04 00 00    	je     8c7e96 <check_lower_drain+0x44b6>
  8c79ab:	83 7c 24 28 17       	cmpl   $0x17,0x28(%rsp)
  8c79b0:	0f 85 b3 07 00 00    	jne    8c8169 <check_lower_drain+0x4789>
  8c79b6:	44 0f b6 bc 24 c0 01 	movzbl 0x1c0(%rsp),%r15d
  8c79bd:	00 00 
  8c79bf:	45 8b 06             	mov    (%r14),%r8d
  8c79c2:	ba 02 00 00 00       	mov    $0x2,%edx
  8c79c7:	48 89 df             	mov    %rbx,%rdi
  8c79ca:	44 89 e6             	mov    %r12d,%esi
  8c79cd:	31 c9                	xor    %ecx,%ecx
  8c79cf:	44 29 fa             	sub    %r15d,%edx
  8c79d2:	e9 a1 0a 00 00       	jmp    8c8478 <check_lower_drain+0x4a98>
  8c79d7:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c79db:	48 8b 09             	mov    (%rcx),%rcx
  8c79de:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c79e5:	75 1a                	jne    8c7a01 <check_lower_drain+0x4021>
  8c79e7:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c79ee:	00 00 00 
  8c79f1:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c79f7:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c79fb:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c7a01:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c7a07:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c7a0d:	73 2a                	jae    8c7a39 <check_lower_drain+0x4059>
  8c7a0f:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c7a13:	8d 71 01             	lea    0x1(%rcx),%esi
  8c7a16:	48 c1 e8 03          	shr    $0x3,%rax
  8c7a1a:	48 c1 e1 04          	shl    $0x4,%rcx
  8c7a1e:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c7a24:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c7a2b:	00 08 00 
  8c7a2e:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c7a32:	48 89 44 0a 08       	mov    %rax,0x8(%rdx,%rcx,1)
  8c7a37:	eb 2a                	jmp    8c7a63 <check_lower_drain+0x4083>
  8c7a39:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7a3d:	48 8b 00             	mov    (%rax),%rax
  8c7a40:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c7a47:	75 1a                	jne    8c7a63 <check_lower_drain+0x4083>
  8c7a49:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c7a50:	00 00 00 
  8c7a53:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c7a59:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c7a5d:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c7a63:	31 c9                	xor    %ecx,%ecx
  8c7a65:	83 7c 24 28 20       	cmpl   $0x20,0x28(%rsp)
  8c7a6a:	48 89 df             	mov    %rbx,%rdi
  8c7a6d:	44 89 e6             	mov    %r12d,%esi
  8c7a70:	0f 94 c1             	sete   %cl
  8c7a73:	31 d2                	xor    %edx,%edx
  8c7a75:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  8c7a7a:	e8 d1 2f 01 00       	call   8daa50 <check_lower_operand>
  8c7a7f:	e9 9a 11 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c7a84:	44 89 f0             	mov    %r14d,%eax
  8c7a87:	41 89 c7             	mov    %eax,%r15d
  8c7a8a:	4c 89 f8             	mov    %r15,%rax
  8c7a8d:	48 c1 e0 20          	shl    $0x20,%rax
  8c7a91:	45 89 f6             	mov    %r14d,%r14d
  8c7a94:	c7 84 24 c0 01 00 00 	movl   $0x14,0x1c0(%rsp)
  8c7a9b:	14 00 00 00 
  8c7a9f:	44 89 a4 24 c4 01 00 	mov    %r12d,0x1c4(%rsp)
  8c7aa6:	00 
  8c7aa7:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
  8c7aae:	00 00 00 00 00 
  8c7ab3:	48 89 df             	mov    %rbx,%rdi
  8c7ab6:	4c 09 f0             	or     %r14,%rax
  8c7ab9:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  8c7ac0:	00 
  8c7ac1:	48 c7 84 24 d8 01 00 	movq   $0x0,0x1d8(%rsp)
  8c7ac8:	00 00 00 00 00 
  8c7acd:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c7ad4:	00 00 
  8c7ad6:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c7adb:	c5 f8 77             	vzeroupper
  8c7ade:	e8 ad 57 00 00       	call   8cd290 <check_lower_push>
  8c7ae3:	83 7c 24 28 02       	cmpl   $0x2,0x28(%rsp)
  8c7ae8:	74 59                	je     8c7b43 <check_lower_drain+0x4163>
  8c7aea:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  8c7aef:	74 52                	je     8c7b43 <check_lower_drain+0x4163>
  8c7af1:	40 0f b6 d5          	movzbl %bpl,%edx
  8c7af5:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c7afa:	48 89 df             	mov    %rbx,%rdi
  8c7afd:	4c 89 f9             	mov    %r15,%rcx
  8c7b00:	e8 db 19 00 00       	call   8c94e0 <check_lower_instruction>
  8c7b05:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c7b0a:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  8c7b11:	00 
  8c7b12:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  8c7b17:	48 89 df             	mov    %rbx,%rdi
  8c7b1a:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c7b1e:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c7b22:	48 c1 e1 05          	shl    $0x5,%rcx
  8c7b26:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c7b29:	e8 02 5f 01 00       	call   8dda30 <check_lower_complex_target>
  8c7b2e:	ba 01 00 00 00       	mov    $0x1,%edx
  8c7b33:	48 89 df             	mov    %rbx,%rdi
  8c7b36:	44 89 e6             	mov    %r12d,%esi
  8c7b39:	31 c9                	xor    %ecx,%ecx
  8c7b3b:	41 89 c0             	mov    %eax,%r8d
  8c7b3e:	e8 0d 2f 01 00       	call   8daa50 <check_lower_operand>
  8c7b43:	8b 54 24 20          	mov    0x20(%rsp),%edx
  8c7b47:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c7b4c:	48 89 df             	mov    %rbx,%rdi
  8c7b4f:	4c 89 f1             	mov    %r14,%rcx
  8c7b52:	e8 89 19 00 00       	call   8c94e0 <check_lower_instruction>
  8c7b57:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c7b5c:	4b 8d 4c 6d 00       	lea    0x0(%r13,%r13,2),%rcx
  8c7b61:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c7b66:	48 89 df             	mov    %rbx,%rdi
  8c7b69:	48 c1 e1 05          	shl    $0x5,%rcx
  8c7b6d:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c7b71:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c7b74:	e8 b7 5e 01 00       	call   8dda30 <check_lower_complex_target>
  8c7b79:	48 89 df             	mov    %rbx,%rdi
  8c7b7c:	44 89 e6             	mov    %r12d,%esi
  8c7b7f:	31 d2                	xor    %edx,%edx
  8c7b81:	31 c9                	xor    %ecx,%ecx
  8c7b83:	41 89 c0             	mov    %eax,%r8d
  8c7b86:	e8 c5 2e 01 00       	call   8daa50 <check_lower_operand>
  8c7b8b:	e9 8e 10 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c7b90:	49 8b 4f 38          	mov    0x38(%r15),%rcx
  8c7b94:	81 3c a9 30 01 00 00 	cmpl   $0x130,(%rcx,%rbp,4)
  8c7b9b:	75 23                	jne    8c7bc0 <check_lower_drain+0x41e0>
  8c7b9d:	31 c9                	xor    %ecx,%ecx
  8c7b9f:	41 83 be 8c 00 00 00 	cmpl   $0x2,0x8c(%r14)
  8c7ba6:	02 
  8c7ba7:	0f 94 c2             	sete   %dl
  8c7baa:	41 83 fd 01          	cmp    $0x1,%r13d
  8c7bae:	0f 85 50 fc ff ff    	jne    8c7804 <check_lower_drain+0x3e24>
  8c7bb4:	88 d1                	mov    %dl,%cl
  8c7bb6:	39 4c 24 20          	cmp    %ecx,0x20(%rsp)
  8c7bba:	0f 85 44 fc ff ff    	jne    8c7804 <check_lower_drain+0x3e24>
  8c7bc0:	48 8d 8c 24 08 02 00 	lea    0x208(%rsp),%rcx
  8c7bc7:	00 
  8c7bc8:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c7bcc:	48 89 df             	mov    %rbx,%rdi
  8c7bcf:	c5 fa 7f 01          	vmovdqu %xmm0,(%rcx)
  8c7bd3:	48 c7 41 10 00 00 00 	movq   $0x0,0x10(%rcx)
  8c7bda:	00 
  8c7bdb:	c7 84 24 00 02 00 00 	movl   $0xb,0x200(%rsp)
  8c7be2:	0b 00 00 00 
  8c7be6:	89 84 24 04 02 00 00 	mov    %eax,0x204(%rsp)
  8c7bed:	c5 fe 6f 84 24 00 02 	vmovdqu 0x200(%rsp),%ymm0
  8c7bf4:	00 00 
  8c7bf6:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c7bfb:	c5 f8 77             	vzeroupper
  8c7bfe:	e8 8d 56 00 00       	call   8cd290 <check_lower_push>
  8c7c03:	45 85 ed             	test   %r13d,%r13d
  8c7c06:	0f 84 12 10 00 00    	je     8c8c1e <check_lower_drain+0x523e>
  8c7c0c:	44 89 ea             	mov    %r13d,%edx
  8c7c0f:	44 8d 6a ff          	lea    -0x1(%rdx),%r13d
  8c7c13:	83 fa 20             	cmp    $0x20,%edx
  8c7c16:	77 eb                	ja     8c7c03 <check_lower_drain+0x4223>
  8c7c18:	8b 44 24 20          	mov    0x20(%rsp),%eax
  8c7c1c:	44 0f a3 e8          	bt     %r13d,%eax
  8c7c20:	73 e1                	jae    8c7c03 <check_lower_drain+0x4223>
  8c7c22:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c7c28:	83 c2 02             	add    $0x2,%edx
  8c7c2b:	48 89 df             	mov    %rbx,%rdi
  8c7c2e:	44 89 e6             	mov    %r12d,%esi
  8c7c31:	31 c9                	xor    %ecx,%ecx
  8c7c33:	e8 18 2e 01 00       	call   8daa50 <check_lower_operand>
  8c7c38:	eb c9                	jmp    8c7c03 <check_lower_drain+0x4223>
  8c7c3a:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c7c3f:	49 89 c8             	mov    %rcx,%r8
  8c7c42:	49 c1 e0 05          	shl    $0x5,%r8
  8c7c46:	4c 03 42 10          	add    0x10(%rdx),%r8
  8c7c4a:	45 8b 28             	mov    (%r8),%r13d
  8c7c4d:	83 7c 24 38 0f       	cmpl   $0xf,0x38(%rsp)
  8c7c52:	77 12                	ja     8c7c66 <check_lower_drain+0x4286>
  8c7c54:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c7c59:	48 c1 e1 05          	shl    $0x5,%rcx
  8c7c5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8c7c61:	44 8b 74 0a 08       	mov    0x8(%rdx,%rcx,1),%r14d
  8c7c66:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c7c6b:	83 3c 88 00          	cmpl   $0x0,(%rax,%rcx,4)
  8c7c6f:	74 1d                	je     8c7c8e <check_lower_drain+0x42ae>
  8c7c71:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c7c76:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  8c7c7b:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c7c7f:	48 c1 e1 05          	shl    $0x5,%rcx
  8c7c83:	83 7c 0a 0c 01       	cmpl   $0x1,0xc(%rdx,%rcx,1)
  8c7c88:	0f 85 cb ec ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c7c8e:	83 7c 24 38 0f       	cmpl   $0xf,0x38(%rsp)
  8c7c93:	77 22                	ja     8c7cb7 <check_lower_drain+0x42d7>
  8c7c95:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
  8c7c99:	83 3c 88 00          	cmpl   $0x0,(%rax,%rcx,4)
  8c7c9d:	74 18                	je     8c7cb7 <check_lower_drain+0x42d7>
  8c7c9f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  8c7ca4:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
  8c7ca8:	48 c1 e0 05          	shl    $0x5,%rax
  8c7cac:	83 7c 02 0c 01       	cmpl   $0x1,0xc(%rdx,%rax,1)
  8c7cb1:	0f 85 a2 ec ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c7cb7:	45 85 ed             	test   %r13d,%r13d
  8c7cba:	74 30                	je     8c7cec <check_lower_drain+0x430c>
  8c7cbc:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c7cc1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8c7cc6:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8c7cca:	48 c1 e0 05          	shl    $0x5,%rax
  8c7cce:	8b 34 01             	mov    (%rcx,%rax,1),%esi
  8c7cd1:	41 39 f5             	cmp    %esi,%r13d
  8c7cd4:	74 16                	je     8c7cec <check_lower_drain+0x430c>
  8c7cd6:	48 89 df             	mov    %rbx,%rdi
  8c7cd9:	44 89 ea             	mov    %r13d,%edx
  8c7cdc:	c5 f8 77             	vzeroupper
  8c7cdf:	e8 9c 57 00 00       	call   8cd480 <check_lower_conversion_empty>
  8c7ce4:	84 c0                	test   %al,%al
  8c7ce6:	0f 84 6d ec ff ff    	je     8c6959 <check_lower_drain+0x2f79>
  8c7cec:	83 7c 24 38 0f       	cmpl   $0xf,0x38(%rsp)
  8c7cf1:	77 34                	ja     8c7d27 <check_lower_drain+0x4347>
  8c7cf3:	45 85 f6             	test   %r14d,%r14d
  8c7cf6:	74 2f                	je     8c7d27 <check_lower_drain+0x4347>
  8c7cf8:	8b 44 24 20          	mov    0x20(%rsp),%eax
  8c7cfc:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8c7d01:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8c7d05:	48 c1 e0 05          	shl    $0x5,%rax
  8c7d09:	8b 34 01             	mov    (%rcx,%rax,1),%esi
  8c7d0c:	41 39 f6             	cmp    %esi,%r14d
  8c7d0f:	74 16                	je     8c7d27 <check_lower_drain+0x4347>
  8c7d11:	48 89 df             	mov    %rbx,%rdi
  8c7d14:	44 89 f2             	mov    %r14d,%edx
  8c7d17:	c5 f8 77             	vzeroupper
  8c7d1a:	e8 61 57 00 00       	call   8cd480 <check_lower_conversion_empty>
  8c7d1f:	84 c0                	test   %al,%al
  8c7d21:	0f 84 32 ec ff ff    	je     8c6959 <check_lower_drain+0x2f79>
  8c7d27:	8b 83 b0 01 00 00    	mov    0x1b0(%rbx),%eax
  8c7d2d:	44 89 ea             	mov    %r13d,%edx
  8c7d30:	c1 ea 03             	shr    $0x3,%edx
  8c7d33:	b9 ff 00 00 00       	mov    $0xff,%ecx
  8c7d38:	39 c2                	cmp    %eax,%edx
  8c7d3a:	73 06                	jae    8c7d42 <check_lower_drain+0x4362>
  8c7d3c:	89 d1                	mov    %edx,%ecx
  8c7d3e:	41 8b 0c 8f          	mov    (%r15,%rcx,4),%ecx
  8c7d42:	45 85 ed             	test   %r13d,%r13d
  8c7d45:	74 74                	je     8c7dbb <check_lower_drain+0x43db>
  8c7d47:	8b 74 24 38          	mov    0x38(%rsp),%esi
  8c7d4b:	31 d2                	xor    %edx,%edx
  8c7d4d:	83 fe 02             	cmp    $0x2,%esi
  8c7d50:	0f 92 c2             	setb   %dl
  8c7d53:	83 fe 10             	cmp    $0x10,%esi
  8c7d56:	40 0f 93 c6          	setae  %sil
  8c7d5a:	c1 e2 0b             	shl    $0xb,%edx
  8c7d5d:	89 74 24 58          	mov    %esi,0x58(%rsp)
  8c7d61:	0f b6 f1             	movzbl %cl,%esi
  8c7d64:	81 ca 00 07 00 00    	or     $0x700,%edx
  8c7d6a:	83 fe 0b             	cmp    $0xb,%esi
  8c7d6d:	40 0f 92 c6          	setb   %sil
  8c7d71:	85 d1                	test   %edx,%ecx
  8c7d73:	0f 94 c1             	sete   %cl
  8c7d76:	40 20 f1             	and    %sil,%cl
  8c7d79:	80 f9 01             	cmp    $0x1,%cl
  8c7d7c:	75 07                	jne    8c7d85 <check_lower_drain+0x43a5>
  8c7d7e:	83 7c 24 38 10       	cmpl   $0x10,0x38(%rsp)
  8c7d83:	72 4b                	jb     8c7dd0 <check_lower_drain+0x43f0>
  8c7d85:	84 c9                	test   %cl,%cl
  8c7d87:	0f 84 cc eb ff ff    	je     8c6959 <check_lower_drain+0x2f79>
  8c7d8d:	e9 80 00 00 00       	jmp    8c7e12 <check_lower_drain+0x4432>
  8c7d92:	83 7c 24 28 38       	cmpl   $0x38,0x28(%rsp)
  8c7d97:	0f 84 58 01 00 00    	je     8c7ef5 <check_lower_drain+0x4515>
  8c7d9d:	83 7c 24 28 22       	cmpl   $0x22,0x28(%rsp)
  8c7da2:	0f 85 60 01 00 00    	jne    8c7f08 <check_lower_drain+0x4528>
  8c7da8:	48 89 df             	mov    %rbx,%rdi
  8c7dab:	44 89 e6             	mov    %r12d,%esi
  8c7dae:	c5 f8 77             	vzeroupper
  8c7db1:	e8 7a 60 01 00       	call   8dde30 <check_lower_call>
  8c7db6:	e9 63 0e 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c7dbb:	83 7c 24 38 0f       	cmpl   $0xf,0x38(%rsp)
  8c7dc0:	b1 01                	mov    $0x1,%cl
  8c7dc2:	89 4c 24 58          	mov    %ecx,0x58(%rsp)
  8c7dc6:	77 4a                	ja     8c7e12 <check_lower_drain+0x4432>
  8c7dc8:	c7 44 24 58 00 00 00 	movl   $0x0,0x58(%rsp)
  8c7dcf:	00 
  8c7dd0:	44 89 f2             	mov    %r14d,%edx
  8c7dd3:	c1 ea 03             	shr    $0x3,%edx
  8c7dd6:	b9 ff 00 00 00       	mov    $0xff,%ecx
  8c7ddb:	39 c2                	cmp    %eax,%edx
  8c7ddd:	73 06                	jae    8c7de5 <check_lower_drain+0x4405>
  8c7ddf:	89 d0                	mov    %edx,%eax
  8c7de1:	41 8b 0c 87          	mov    (%r15,%rax,4),%ecx
  8c7de5:	45 85 f6             	test   %r14d,%r14d
  8c7de8:	74 28                	je     8c7e12 <check_lower_drain+0x4432>
  8c7dea:	31 c0                	xor    %eax,%eax
  8c7dec:	83 7c 24 38 02       	cmpl   $0x2,0x38(%rsp)
  8c7df1:	0f b6 f1             	movzbl %cl,%esi
  8c7df4:	0f 92 c2             	setb   %dl
  8c7df7:	83 fe 0a             	cmp    $0xa,%esi
  8c7dfa:	0f 87 59 eb ff ff    	ja     8c6959 <check_lower_drain+0x2f79>
  8c7e00:	88 d0                	mov    %dl,%al
  8c7e02:	c1 e0 0b             	shl    $0xb,%eax
  8c7e05:	0d 00 07 00 00       	or     $0x700,%eax
  8c7e0a:	21 c1                	and    %eax,%ecx
  8c7e0c:	0f 85 47 eb ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c7e12:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c7e17:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c7e1c:	48 89 df             	mov    %rbx,%rdi
  8c7e1f:	83 ca 02             	or     $0x2,%edx
  8c7e22:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  8c7e27:	e8 d4 21 01 00       	call   8da000 <check_lower_batch_classify>
  8c7e2c:	83 7c 24 38 10       	cmpl   $0x10,0x38(%rsp)
  8c7e31:	c4 e3 79 16 c1 01    	vpextrd $0x1,%xmm0,%ecx
  8c7e37:	c4 e3 79 16 c6 02    	vpextrd $0x2,%xmm0,%esi
  8c7e3d:	0f 43 f1             	cmovae %ecx,%esi
  8c7e40:	40 0f b6 c6          	movzbl %sil,%eax
  8c7e44:	8d 50 ff             	lea    -0x1(%rax),%edx
  8c7e47:	83 fa 0a             	cmp    $0xa,%edx
  8c7e4a:	0f 93 c2             	setae  %dl
  8c7e4d:	f7 c6 00 05 00 00    	test   $0x500,%esi
  8c7e53:	40 0f 95 c7          	setne  %dil
  8c7e57:	40 08 d7             	or     %dl,%dil
  8c7e5a:	0f 85 f9 ea ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c7e60:	4c 8b 03             	mov    (%rbx),%r8
  8c7e63:	49 8b 50 08          	mov    0x8(%r8),%rdx
  8c7e67:	4c 8b 4a 08          	mov    0x8(%rdx),%r9
  8c7e6b:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c7e70:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  8c7e74:	48 c1 e7 05          	shl    $0x5,%rdi
  8c7e78:	45 8b 7c 39 40       	mov    0x40(%r9,%rdi,1),%r15d
  8c7e7d:	4d 85 ff             	test   %r15,%r15
  8c7e80:	0f 84 c8 00 00 00    	je     8c7f4e <check_lower_drain+0x456e>
  8c7e86:	45 3b b8 c0 00 00 00 	cmp    0xc0(%r8),%r15d
  8c7e8d:	41 0f 92 c3          	setb   %r11b
  8c7e91:	e9 bb 00 00 00       	jmp    8c7f51 <check_lower_drain+0x4571>
  8c7e96:	48 89 df             	mov    %rbx,%rdi
  8c7e99:	e8 d2 61 00 00       	call   8ce070 <check_lower_label>
  8c7e9e:	48 89 df             	mov    %rbx,%rdi
  8c7ea1:	89 44 24 20          	mov    %eax,0x20(%rsp)
  8c7ea5:	e8 c6 61 00 00       	call   8ce070 <check_lower_label>
  8c7eaa:	41 89 c7             	mov    %eax,%r15d
  8c7ead:	40 84 ed             	test   %bpl,%bpl
  8c7eb0:	0f 84 1e 03 00 00    	je     8c81d4 <check_lower_drain+0x47f4>
  8c7eb6:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  8c7ebb:	c1 e8 03             	shr    $0x3,%eax
  8c7ebe:	b1 ff                	mov    $0xff,%cl
  8c7ec0:	3b 83 b0 01 00 00    	cmp    0x1b0(%rbx),%eax
  8c7ec6:	73 0b                	jae    8c7ed3 <check_lower_drain+0x44f3>
  8c7ec8:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c7ecf:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c7ed3:	0f b6 f1             	movzbl %cl,%esi
  8c7ed6:	48 89 df             	mov    %rbx,%rdi
  8c7ed9:	e8 42 66 ff ff       	call   8be520 <check_lower_temporary>
  8c7ede:	89 c0                	mov    %eax,%eax
  8c7ee0:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8c7ee5:	48 89 df             	mov    %rbx,%rdi
  8c7ee8:	44 89 fe             	mov    %r15d,%esi
  8c7eeb:	e8 d0 5e 01 00       	call   8dddc0 <check_lower_mark>
  8c7ef0:	e9 ff 02 00 00       	jmp    8c81f4 <check_lower_drain+0x4814>
  8c7ef5:	48 89 df             	mov    %rbx,%rdi
  8c7ef8:	44 89 e6             	mov    %r12d,%esi
  8c7efb:	c5 f8 77             	vzeroupper
  8c7efe:	e8 9d 6c 01 00       	call   8deba0 <check_lower_varargs_prepare>
  8c7f03:	e9 16 0d 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c7f08:	83 7c 24 28 1b       	cmpl   $0x1b,0x28(%rsp)
  8c7f0d:	0f 85 a6 03 00 00    	jne    8c82b9 <check_lower_drain+0x48d9>
  8c7f13:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c7f18:	4b 8d 74 6d 00       	lea    0x0(%r13,%r13,2),%rsi
  8c7f1d:	48 c1 e6 05          	shl    $0x5,%rsi
  8c7f21:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8c7f25:	f6 44 32 08 04       	testb  $0x4,0x8(%rdx,%rsi,1)
  8c7f2a:	0f 84 cf 03 00 00    	je     8c82ff <check_lower_drain+0x491f>
  8c7f30:	31 d2                	xor    %edx,%edx
  8c7f32:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  8c7f38:	48 89 df             	mov    %rbx,%rdi
  8c7f3b:	44 89 e6             	mov    %r12d,%esi
  8c7f3e:	0f 95 c2             	setne  %dl
  8c7f41:	c5 f8 77             	vzeroupper
  8c7f44:	e8 67 7a 01 00       	call   8df9b0 <check_lower_bit_assign>
  8c7f49:	e9 d0 0c 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c7f4e:	45 31 db             	xor    %r11d,%r11d
  8c7f51:	c4 c1 79 7e c2       	vmovd  %xmm0,%r10d
  8c7f56:	41 0f b6 d2          	movzbl %r10b,%edx
  8c7f5a:	44 8d 72 ff          	lea    -0x1(%rdx),%r14d
  8c7f5e:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  8c7f63:	41 83 fe 0a          	cmp    $0xa,%r14d
  8c7f67:	0f 93 c2             	setae  %dl
  8c7f6a:	41 f7 c2 00 05 00 00 	test   $0x500,%r10d
  8c7f71:	41 0f 95 c5          	setne  %r13b
  8c7f75:	41 08 d5             	or     %dl,%r13b
  8c7f78:	0f 85 db e9 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c7f7e:	4c 01 cf             	add    %r9,%rdi
  8c7f81:	83 7f 44 00          	cmpl   $0x0,0x44(%rdi)
  8c7f85:	0f 85 ce e9 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c7f8b:	49 8b 10             	mov    (%r8),%rdx
  8c7f8e:	4c 8b 2a             	mov    (%rdx),%r13
  8c7f91:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  8c7f96:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c7f9b:	41 8b 54 95 00       	mov    0x0(%r13,%rdx,4),%edx
  8c7fa0:	4c 89 ac 24 80 00 00 	mov    %r13,0x80(%rsp)
  8c7fa7:	00 
  8c7fa8:	85 d2                	test   %edx,%edx
  8c7faa:	89 54 24 30          	mov    %edx,0x30(%rsp)
  8c7fae:	0f 94 c2             	sete   %dl
  8c7fb1:	44 20 da             	and    %r11b,%dl
  8c7fb4:	80 fa 01             	cmp    $0x1,%dl
  8c7fb7:	75 39                	jne    8c7ff2 <check_lower_drain+0x4612>
  8c7fb9:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c7fbe:	4c 8b aa 90 02 00 00 	mov    0x290(%rdx),%r13
  8c7fc5:	41 8d 57 ff          	lea    -0x1(%r15),%edx
  8c7fc9:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  8c7fce:	41 80 7c 15 00 00    	cmpb   $0x0,0x0(%r13,%rdx,1)
  8c7fd4:	74 1c                	je     8c7ff2 <check_lower_drain+0x4612>
  8c7fd6:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c7fdb:	4c 8b 6c 24 78       	mov    0x78(%rsp),%r13
  8c7fe0:	48 8b 92 78 02 00 00 	mov    0x278(%rdx),%rdx
  8c7fe7:	42 80 3c 2a 00       	cmpb   $0x0,(%rdx,%r13,1)
  8c7fec:	0f 84 67 e9 ff ff    	je     8c6959 <check_lower_drain+0x2f79>
  8c7ff2:	8b 57 0c             	mov    0xc(%rdi),%edx
  8c7ff5:	89 54 24 78          	mov    %edx,0x78(%rsp)
  8c7ff9:	85 d2                	test   %edx,%edx
  8c7ffb:	74 1c                	je     8c8019 <check_lower_drain+0x4639>
  8c7ffd:	83 7f 54 00          	cmpl   $0x0,0x54(%rdi)
  8c8001:	75 16                	jne    8c8019 <check_lower_drain+0x4639>
  8c8003:	0f b7 57 08          	movzwl 0x8(%rdi),%edx
  8c8007:	f7 c2 10 08 00 00    	test   $0x810,%edx
  8c800d:	75 0a                	jne    8c8019 <check_lower_drain+0x4639>
  8c800f:	83 7f 04 00          	cmpl   $0x0,0x4(%rdi)
  8c8013:	0f 84 69 0a 00 00    	je     8c8a82 <check_lower_drain+0x50a2>
  8c8019:	83 7c 24 30 00       	cmpl   $0x0,0x30(%rsp)
  8c801e:	0f 85 35 e9 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c8024:	83 7f 04 01          	cmpl   $0x1,0x4(%rdi)
  8c8028:	0f 94 c2             	sete   %dl
  8c802b:	44 20 da             	and    %r11b,%dl
  8c802e:	80 fa 01             	cmp    $0x1,%dl
  8c8031:	0f 85 22 e9 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c8037:	48 8b 53 68          	mov    0x68(%rbx),%rdx
  8c803b:	42 8b 3c ba          	mov    (%rdx,%r15,4),%edi
  8c803f:	49 8b 90 80 00 00 00 	mov    0x80(%r8),%rdx
  8c8046:	42 8b 14 ba          	mov    (%rdx,%r15,4),%edx
  8c804a:	85 d2                	test   %edx,%edx
  8c804c:	41 0f 94 c3          	sete   %r11b
  8c8050:	45 31 d2             	xor    %r10d,%r10d
  8c8053:	83 ff ff             	cmp    $0xffffffff,%edi
  8c8056:	41 0f 94 c2          	sete   %r10b
  8c805a:	0f 44 fa             	cmove  %edx,%edi
  8c805d:	43 8d 54 12 02       	lea    0x2(%r10,%r10,1),%edx
  8c8062:	45 20 d3             	and    %r10b,%r11b
  8c8065:	89 54 24 30          	mov    %edx,0x30(%rsp)
  8c8069:	8b 54 24 58          	mov    0x58(%rsp),%edx
  8c806d:	44 08 da             	or     %r11b,%dl
  8c8070:	0f 84 79 07 00 00    	je     8c87ef <check_lower_drain+0x4e0f>
  8c8076:	45 84 db             	test   %r11b,%r11b
  8c8079:	0f 85 da e8 ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c807f:	45 31 db             	xor    %r11d,%r11d
  8c8082:	45 31 c9             	xor    %r9d,%r9d
  8c8085:	44 8b 74 24 30       	mov    0x30(%rsp),%r14d
  8c808a:	c1 ee 10             	shr    $0x10,%esi
  8c808d:	41 ba 00 00 00 00    	mov    $0x0,%r10d
  8c8093:	c4 e1 f9 6e cf       	vmovq  %rdi,%xmm1
  8c8098:	40 0f b6 d6          	movzbl %sil,%edx
  8c809c:	41 89 d0             	mov    %edx,%r8d
  8c809f:	41 c1 e0 10          	shl    $0x10,%r8d
  8c80a3:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8c80a9:	45 0f 44 c2          	cmove  %r10d,%r8d
  8c80ad:	40 0f 95 c6          	setne  %sil
  8c80b1:	c1 e1 08             	shl    $0x8,%ecx
  8c80b4:	0f b7 c9             	movzwl %cx,%ecx
  8c80b7:	45 09 c6             	or     %r8d,%r14d
  8c80ba:	45 09 de             	or     %r11d,%r14d
  8c80bd:	83 7c 24 38 10       	cmpl   $0x10,0x38(%rsp)
  8c80c2:	c4 c1 79 6e c6       	vmovd  %r14d,%xmm0
  8c80c7:	0f 92 c2             	setb   %dl
  8c80ca:	41 0f 43 ca          	cmovae %r10d,%ecx
  8c80ce:	c1 e0 10             	shl    $0x10,%eax
  8c80d1:	40 c0 e6 02          	shl    $0x2,%sil
  8c80d5:	00 d2                	add    %dl,%dl
  8c80d7:	09 c8                	or     %ecx,%eax
  8c80d9:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c80dd:	03 44 24 60          	add    0x60(%rsp),%eax
  8c80e1:	40 08 d6             	or     %dl,%sil
  8c80e4:	8b 93 38 01 00 00    	mov    0x138(%rbx),%edx
  8c80ea:	40 fe c6             	inc    %sil
  8c80ed:	c5 fb 92 ce          	kmovd  %esi,%k1
  8c80f1:	c5 f9 90 d1          	kmovb  %k1,%k2
  8c80f5:	62 f2 7d 0a 63 04 11 	vpcompressb %xmm0,(%rcx,%rdx,1){%k2}
  8c80fc:	c5 f9 6e c0          	vmovd  %eax,%xmm0
  8c8100:	40 0f b6 c6          	movzbl %sil,%eax
  8c8104:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c8108:	8b 93 38 01 00 00    	mov    0x138(%rbx),%edx
  8c810e:	f3 0f b8 c0          	popcnt %eax,%eax
  8c8112:	62 f2 7d 0a 63 04 11 	vpcompressb %xmm0,(%rcx,%rdx,1){%k2}
  8c8119:	c4 c1 f9 6e c1       	vmovq  %r9,%xmm0
  8c811e:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c8122:	8b 93 38 01 00 00    	mov    0x138(%rbx),%edx
  8c8128:	c5 f1 6c c0          	vpunpcklqdq %xmm0,%xmm1,%xmm0
  8c812c:	62 f2 fd 49 8b 04 d1 	vpcompressq %zmm0,(%rcx,%rdx,8){%k1}
  8c8133:	01 83 38 01 00 00    	add    %eax,0x138(%rbx)
  8c8139:	8b 4c 24 54          	mov    0x54(%rsp),%ecx
  8c813d:	48 8b 45 08          	mov    0x8(%rbp),%rax
  8c8141:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c8144:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c814a:	8b 44 24 40          	mov    0x40(%rsp),%eax
  8c814e:	62 f2 fd 08 7c c0    	vpbroadcastq %rax,%xmm0
  8c8154:	c5 f9 d4 83 00 02 00 	vpaddq 0x200(%rbx),%xmm0,%xmm0
  8c815b:	00 
  8c815c:	c5 fa 7f 83 00 02 00 	vmovdqu %xmm0,0x200(%rbx)
  8c8163:	00 
  8c8164:	e9 8b b9 ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c8169:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c816e:	44 0f b6 bc 24 c0 01 	movzbl 0x1c0(%rsp),%r15d
  8c8175:	00 00 
  8c8177:	83 f9 16             	cmp    $0x16,%ecx
  8c817a:	44 89 fa             	mov    %r15d,%edx
  8c817d:	0f 94 c0             	sete   %al
  8c8180:	83 f9 15             	cmp    $0x15,%ecx
  8c8183:	0f 94 c1             	sete   %cl
  8c8186:	80 f2 01             	xor    $0x1,%dl
  8c8189:	44 20 f8             	and    %r15b,%al
  8c818c:	20 ca                	and    %cl,%dl
  8c818e:	08 c2                	or     %al,%dl
  8c8190:	80 fa 01             	cmp    $0x1,%dl
  8c8193:	0f 85 bd 02 00 00    	jne    8c8456 <check_lower_drain+0x4a76>
  8c8199:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c819f:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c81a5:	0f 83 4e 04 00 00    	jae    8c85f9 <check_lower_drain+0x4c19>
  8c81ab:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c81af:	8d 50 01             	lea    0x1(%rax),%edx
  8c81b2:	48 c1 e0 04          	shl    $0x4,%rax
  8c81b6:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c81bc:	48 ba 01 00 00 00 01 	movabs $0x5000100000001,%rdx
  8c81c3:	00 05 00 
  8c81c6:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c81ca:	4c 89 7c 01 08       	mov    %r15,0x8(%rcx,%rax,1)
  8c81cf:	e9 a9 02 00 00       	jmp    8c847d <check_lower_drain+0x4a9d>
  8c81d4:	48 89 df             	mov    %rbx,%rdi
  8c81d7:	44 89 fe             	mov    %r15d,%esi
  8c81da:	e8 e1 5b 01 00       	call   8dddc0 <check_lower_mark>
  8c81df:	83 7c 24 28 17       	cmpl   $0x17,0x28(%rsp)
  8c81e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c81e9:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8c81ee:	0f 85 c0 02 00 00    	jne    8c84b4 <check_lower_drain+0x4ad4>
  8c81f4:	45 8b 06             	mov    (%r14),%r8d
  8c81f7:	ba 02 00 00 00       	mov    $0x2,%edx
  8c81fc:	48 89 df             	mov    %rbx,%rdi
  8c81ff:	44 89 e6             	mov    %r12d,%esi
  8c8202:	31 c9                	xor    %ecx,%ecx
  8c8204:	e8 47 28 01 00       	call   8daa50 <check_lower_operand>
  8c8209:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c820d:	48 89 df             	mov    %rbx,%rdi
  8c8210:	e8 ab 5b 01 00       	call   8dddc0 <check_lower_mark>
  8c8215:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c821a:	be 27 00 00 00       	mov    $0x27,%esi
  8c821f:	44 89 f9             	mov    %r15d,%ecx
  8c8222:	48 89 df             	mov    %rbx,%rdi
  8c8225:	3c 01                	cmp    $0x1,%al
  8c8227:	0f b6 d0             	movzbl %al,%edx
  8c822a:	83 de 00             	sbb    $0x0,%esi
  8c822d:	e8 ae 12 00 00       	call   8c94e0 <check_lower_instruction>
  8c8232:	83 7c 24 28 17       	cmpl   $0x17,0x28(%rsp)
  8c8237:	75 59                	jne    8c8292 <check_lower_drain+0x48b2>
  8c8239:	45 8b 06             	mov    (%r14),%r8d
  8c823c:	44 3b ac 24 80 00 00 	cmp    0x80(%rsp),%r13d
  8c8243:	00 
  8c8244:	0f 85 af 02 00 00    	jne    8c84f9 <check_lower_drain+0x4b19>
  8c824a:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
  8c824f:	48 89 df             	mov    %rbx,%rdi
  8c8252:	44 89 c2             	mov    %r8d,%edx
  8c8255:	44 89 f6             	mov    %r14d,%esi
  8c8258:	e8 f3 50 00 00       	call   8cd350 <check_lower_convert>
  8c825d:	41 c1 ee 03          	shr    $0x3,%r14d
  8c8261:	b1 ff                	mov    $0xff,%cl
  8c8263:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c826a:	73 0c                	jae    8c8278 <check_lower_drain+0x4898>
  8c826c:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c8273:	42 0f b6 0c 31       	movzbl (%rcx,%r14,1),%ecx
  8c8278:	0f b6 d1             	movzbl %cl,%edx
  8c827b:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c8280:	be 02 00 00 00       	mov    $0x2,%esi
  8c8285:	48 89 df             	mov    %rbx,%rdi
  8c8288:	e8 53 12 00 00       	call   8c94e0 <check_lower_instruction>
  8c828d:	e9 79 02 00 00       	jmp    8c850b <check_lower_drain+0x4b2b>
  8c8292:	4c 8b 74 24 70       	mov    0x70(%rsp),%r14
  8c8297:	48 89 df             	mov    %rbx,%rdi
  8c829a:	31 d2                	xor    %edx,%edx
  8c829c:	44 89 f6             	mov    %r14d,%esi
  8c829f:	e8 2c 58 01 00       	call   8ddad0 <check_lower_truth>
  8c82a4:	ba 01 00 00 00       	mov    $0x1,%edx
  8c82a9:	48 89 df             	mov    %rbx,%rdi
  8c82ac:	44 89 e6             	mov    %r12d,%esi
  8c82af:	31 c9                	xor    %ecx,%ecx
  8c82b1:	45 89 f0             	mov    %r14d,%r8d
  8c82b4:	e9 4d 02 00 00       	jmp    8c8506 <check_lower_drain+0x4b26>
  8c82b9:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c82be:	8d 51 da             	lea    -0x26(%rcx),%edx
  8c82c1:	83 fa 0d             	cmp    $0xd,%edx
  8c82c4:	77 39                	ja     8c82ff <check_lower_drain+0x491f>
  8c82c6:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c82cb:	4b 8d 7c 6d 00       	lea    0x0(%r13,%r13,2),%rdi
  8c82d0:	b2 01                	mov    $0x1,%dl
  8c82d2:	48 c1 e7 05          	shl    $0x5,%rdi
  8c82d6:	48 8b 70 08          	mov    0x8(%rax),%rsi
  8c82da:	f6 44 3e 08 04       	testb  $0x4,0x8(%rsi,%rdi,1)
  8c82df:	74 20                	je     8c8301 <check_lower_drain+0x4921>
  8c82e1:	31 d2                	xor    %edx,%edx
  8c82e3:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  8c82e9:	48 89 df             	mov    %rbx,%rdi
  8c82ec:	44 89 e6             	mov    %r12d,%esi
  8c82ef:	0f 95 c2             	setne  %dl
  8c82f2:	c5 f8 77             	vzeroupper
  8c82f5:	e8 16 7a 01 00       	call   8dfd10 <check_lower_bit_update>
  8c82fa:	e9 1f 09 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c82ff:	31 d2                	xor    %edx,%edx
  8c8301:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c8306:	8d 71 e5             	lea    -0x1b(%rcx),%esi
  8c8309:	f7 c6 f7 ff ff ff    	test   $0xfffffff7,%esi
  8c830f:	40 0f 94 c6          	sete   %sil
  8c8313:	40 22 74 24 78       	and    0x78(%rsp),%sil
  8c8318:	40 80 fe 01          	cmp    $0x1,%sil
  8c831c:	0f 85 8e 02 00 00    	jne    8c85b0 <check_lower_drain+0x4bd0>
  8c8322:	83 7c 24 28 23       	cmpl   $0x23,0x28(%rsp)
  8c8327:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8c832d:	75 0b                	jne    8c833a <check_lower_drain+0x495a>
  8c832f:	48 8b 8b b8 00 00 00 	mov    0xb8(%rbx),%rcx
  8c8336:	44 8b 2c a9          	mov    (%rcx,%rbp,4),%r13d
  8c833a:	c4 e2 79 22 05 49 f0 	vpmovsxbq -0x420fb7(%rip),%xmm0        # 4a738c <cbuiltin_test_generated.edges+0xacfc>
  8c8341:	bd ff 
  8c8343:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c8348:	41 c1 e8 03          	shr    $0x3,%r8d
  8c834c:	c5 f8 29 84 24 a0 01 	vmovaps %xmm0,0x1a0(%rsp)
  8c8353:	00 00 
  8c8355:	48 8b 08             	mov    (%rax),%rcx
  8c8358:	42 80 3c 01 0f       	cmpb   $0xf,(%rcx,%r8,1)
  8c835d:	75 11                	jne    8c8370 <check_lower_drain+0x4990>
  8c835f:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c8364:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8c8368:	46 8b 04 81          	mov    (%rcx,%r8,4),%r8d
  8c836c:	41 c1 e8 03          	shr    $0x3,%r8d
  8c8370:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c8375:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
  8c837a:	45 31 ff             	xor    %r15d,%r15d
  8c837d:	48 89 df             	mov    %rbx,%rdi
  8c8380:	48 8b 48 38          	mov    0x38(%rax),%rcx
  8c8384:	83 fd 23             	cmp    $0x23,%ebp
  8c8387:	41 0f 95 c7          	setne  %r15b
  8c838b:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  8c8391:	4a 8b 04 c1          	mov    (%rcx,%r8,8),%rax
  8c8395:	48 8d 8c 24 b9 01 00 	lea    0x1b9(%rsp),%rcx
  8c839c:	00 
  8c839d:	48 89 84 24 b0 01 00 	mov    %rax,0x1b0(%rsp)
  8c83a4:	00 
  8c83a5:	0f 94 84 24 b8 01 00 	sete   0x1b8(%rsp)
  8c83ac:	00 
  8c83ad:	c7 41 03 00 00 00 00 	movl   $0x0,0x3(%rcx)
  8c83b4:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c83ba:	c5 fe 6f 84 24 a0 01 	vmovdqu 0x1a0(%rsp),%ymm0
  8c83c1:	00 00 
  8c83c3:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c83c8:	c5 f8 77             	vzeroupper
  8c83cb:	e8 c0 4e 00 00       	call   8cd290 <check_lower_push>
  8c83d0:	45 8b 06             	mov    (%r14),%r8d
  8c83d3:	48 89 df             	mov    %rbx,%rdi
  8c83d6:	44 89 e6             	mov    %r12d,%esi
  8c83d9:	44 89 fa             	mov    %r15d,%edx
  8c83dc:	31 c9                	xor    %ecx,%ecx
  8c83de:	e8 6d 26 01 00       	call   8daa50 <check_lower_operand>
  8c83e3:	83 fd 1b             	cmp    $0x1b,%ebp
  8c83e6:	0f 84 c1 ee ff ff    	je     8c72ad <check_lower_drain+0x38cd>
  8c83ec:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c83f1:	48 8b 00             	mov    (%rax),%rax
  8c83f4:	44 3b a8 84 03 00 00 	cmp    0x384(%rax),%r13d
  8c83fb:	0f 83 f3 07 00 00    	jae    8c8bf4 <check_lower_drain+0x5214>
  8c8401:	48 8d 8c 24 88 01 00 	lea    0x188(%rsp),%rcx
  8c8408:	00 
  8c8409:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c840d:	c5 fa 7f 01          	vmovdqu %xmm0,(%rcx)
  8c8411:	48 c7 41 10 00 00 00 	movq   $0x0,0x10(%rcx)
  8c8418:	00 
  8c8419:	c7 84 24 80 01 00 00 	movl   $0xa,0x180(%rsp)
  8c8420:	0a 00 00 00 
  8c8424:	44 89 e9             	mov    %r13d,%ecx
  8c8427:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
  8c842e:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c8431:	89 84 24 84 01 00 00 	mov    %eax,0x184(%rsp)
  8c8438:	c5 fe 6f 84 24 80 01 	vmovdqu 0x180(%rsp),%ymm0
  8c843f:	00 00 
  8c8441:	48 89 df             	mov    %rbx,%rdi
  8c8444:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c8449:	c5 f8 77             	vzeroupper
  8c844c:	e8 3f 4e 00 00       	call   8cd290 <check_lower_push>
  8c8451:	e9 c8 07 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c8456:	4c 8b 74 24 70       	mov    0x70(%rsp),%r14
  8c845b:	48 89 df             	mov    %rbx,%rdi
  8c845e:	31 d2                	xor    %edx,%edx
  8c8460:	44 89 f6             	mov    %r14d,%esi
  8c8463:	e8 68 56 01 00       	call   8ddad0 <check_lower_truth>
  8c8468:	ba 01 00 00 00       	mov    $0x1,%edx
  8c846d:	48 89 df             	mov    %rbx,%rdi
  8c8470:	44 89 e6             	mov    %r12d,%esi
  8c8473:	31 c9                	xor    %ecx,%ecx
  8c8475:	45 89 f0             	mov    %r14d,%r8d
  8c8478:	e8 d3 25 01 00       	call   8daa50 <check_lower_operand>
  8c847d:	44 84 fd             	test   %r15b,%bpl
  8c8480:	0f 85 98 07 00 00    	jne    8c8c1e <check_lower_drain+0x523e>
  8c8486:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c848b:	44 89 ea             	mov    %r13d,%edx
  8c848e:	48 8b 01             	mov    (%rcx),%rax
  8c8491:	48 8b 71 08          	mov    0x8(%rcx),%rsi
  8c8495:	48 8b 38             	mov    (%rax),%rdi
  8c8498:	e8 63 58 01 00       	call   8ddd00 <check_program_runtime_effects>
  8c849d:	b9 08 00 00 00       	mov    $0x8,%ecx
  8c84a2:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  8c84a7:	84 c0                	test   %al,%al
  8c84a9:	0f 85 f2 00 00 00    	jne    8c85a1 <check_lower_drain+0x4bc1>
  8c84af:	e9 6a 07 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c84b4:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c84ba:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c84c0:	0f 83 66 01 00 00    	jae    8c862c <check_lower_drain+0x4c4c>
  8c84c6:	31 c9                	xor    %ecx,%ecx
  8c84c8:	83 7c 24 28 16       	cmpl   $0x16,0x28(%rsp)
  8c84cd:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c84d1:	8d 70 01             	lea    0x1(%rax),%esi
  8c84d4:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c84da:	48 be 01 00 00 00 01 	movabs $0x5000100000001,%rsi
  8c84e1:	00 05 00 
  8c84e4:	0f 94 c1             	sete   %cl
  8c84e7:	48 c1 e0 04          	shl    $0x4,%rax
  8c84eb:	48 89 34 02          	mov    %rsi,(%rdx,%rax,1)
  8c84ef:	48 89 4c 02 08       	mov    %rcx,0x8(%rdx,%rax,1)
  8c84f4:	e9 10 fd ff ff       	jmp    8c8209 <check_lower_drain+0x4829>
  8c84f9:	48 89 df             	mov    %rbx,%rdi
  8c84fc:	44 89 e6             	mov    %r12d,%esi
  8c84ff:	ba 01 00 00 00       	mov    $0x1,%edx
  8c8504:	31 c9                	xor    %ecx,%ecx
  8c8506:	e8 45 25 01 00       	call   8daa50 <check_lower_operand>
  8c850b:	31 f6                	xor    %esi,%esi
  8c850d:	83 7c 24 28 16       	cmpl   $0x16,0x28(%rsp)
  8c8512:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
  8c8516:	ba 05 00 00 00       	mov    $0x5,%edx
  8c851b:	48 89 df             	mov    %rbx,%rdi
  8c851e:	40 0f 94 c6          	sete   %sil
  8c8522:	83 ce 24             	or     $0x24,%esi
  8c8525:	e8 b6 0f 00 00       	call   8c94e0 <check_lower_instruction>
  8c852a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8c852f:	48 89 df             	mov    %rbx,%rdi
  8c8532:	31 d2                	xor    %edx,%edx
  8c8534:	e8 97 55 01 00       	call   8ddad0 <check_lower_truth>
  8c8539:	40 84 ed             	test   %bpl,%bpl
  8c853c:	74 63                	je     8c85a1 <check_lower_drain+0x4bc1>
  8c853e:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
  8c8543:	41 c1 ee 03          	shr    $0x3,%r14d
  8c8547:	40 b5 ff             	mov    $0xff,%bpl
  8c854a:	b0 ff                	mov    $0xff,%al
  8c854c:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c8553:	73 0c                	jae    8c8561 <check_lower_drain+0x4b81>
  8c8555:	48 8b 83 98 01 00 00 	mov    0x198(%rbx),%rax
  8c855c:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax
  8c8561:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c8566:	0f b6 d0             	movzbl %al,%edx
  8c8569:	be 02 00 00 00       	mov    $0x2,%esi
  8c856e:	48 89 df             	mov    %rbx,%rdi
  8c8571:	e8 6a 0f 00 00       	call   8c94e0 <check_lower_instruction>
  8c8576:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c857d:	73 0c                	jae    8c858b <check_lower_drain+0x4bab>
  8c857f:	48 8b 83 98 01 00 00 	mov    0x198(%rbx),%rax
  8c8586:	42 0f b6 2c 30       	movzbl (%rax,%r14,1),%ebp
  8c858b:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c8590:	40 0f b6 d5          	movzbl %bpl,%edx
  8c8594:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c8599:	48 89 df             	mov    %rbx,%rdi
  8c859c:	e8 3f 0f 00 00       	call   8c94e0 <check_lower_instruction>
  8c85a1:	48 89 df             	mov    %rbx,%rdi
  8c85a4:	44 89 e6             	mov    %r12d,%esi
  8c85a7:	31 d2                	xor    %edx,%edx
  8c85a9:	31 c9                	xor    %ecx,%ecx
  8c85ab:	e9 c5 f4 ff ff       	jmp    8c7a75 <check_lower_drain+0x4095>
  8c85b0:	83 7c 24 28 23       	cmpl   $0x23,0x28(%rsp)
  8c85b5:	74 0b                	je     8c85c2 <check_lower_drain+0x4be2>
  8c85b7:	83 7c 24 28 1b       	cmpl   $0x1b,0x28(%rsp)
  8c85bc:	0f 85 8b 01 00 00    	jne    8c874d <check_lower_drain+0x4d6d>
  8c85c2:	83 7c 24 28 23       	cmpl   $0x23,0x28(%rsp)
  8c85c7:	0f 85 92 00 00 00    	jne    8c865f <check_lower_drain+0x4c7f>
  8c85cd:	48 8b 83 b8 00 00 00 	mov    0xb8(%rbx),%rax
  8c85d4:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c85d9:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
  8c85dc:	48 39 c8             	cmp    %rcx,%rax
  8c85df:	74 7e                	je     8c865f <check_lower_drain+0x4c7f>
  8c85e1:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c85e6:	48 c1 e0 02          	shl    $0x2,%rax
  8c85ea:	48 8b 09             	mov    (%rcx),%rcx
  8c85ed:	48 03 81 70 02 00 00 	add    0x270(%rcx),%rax
  8c85f4:	e9 8b 00 00 00       	jmp    8c8684 <check_lower_drain+0x4ca4>
  8c85f9:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c85fd:	48 8b 00             	mov    (%rax),%rax
  8c8600:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8607:	0f 85 70 fe ff ff    	jne    8c847d <check_lower_drain+0x4a9d>
  8c860d:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8614:	00 00 00 
  8c8617:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c861d:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8621:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8627:	e9 51 fe ff ff       	jmp    8c847d <check_lower_drain+0x4a9d>
  8c862c:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8630:	48 8b 00             	mov    (%rax),%rax
  8c8633:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c863a:	0f 85 c9 fb ff ff    	jne    8c8209 <check_lower_drain+0x4829>
  8c8640:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8647:	00 00 00 
  8c864a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8650:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8654:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c865a:	e9 aa fb ff ff       	jmp    8c8209 <check_lower_drain+0x4829>
  8c865f:	49 8b 07             	mov    (%r15),%rax
  8c8662:	42 83 3c a8 00       	cmpl   $0x0,(%rax,%r13,4)
  8c8667:	0f 85 a4 00 00 00    	jne    8c8711 <check_lower_drain+0x4d31>
  8c866d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c8672:	4b 8d 4c 6d 00       	lea    0x0(%r13,%r13,2),%rcx
  8c8677:	48 c1 e1 05          	shl    $0x5,%rcx
  8c867b:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c867f:	48 8d 44 08 40       	lea    0x40(%rax,%rcx,1),%rax
  8c8684:	44 8b 38             	mov    (%rax),%r15d
  8c8687:	4d 85 ff             	test   %r15,%r15
  8c868a:	0f 84 81 00 00 00    	je     8c8711 <check_lower_drain+0x4d31>
  8c8690:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c8695:	44 3b b8 c0 00 00 00 	cmp    0xc0(%rax),%r15d
  8c869c:	73 73                	jae    8c8711 <check_lower_drain+0x4d31>
  8c869e:	48 8b 43 68          	mov    0x68(%rbx),%rax
  8c86a2:	b2 1e                	mov    $0x1e,%dl
  8c86a4:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c86a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c86ab:	75 2b                	jne    8c86d8 <check_lower_drain+0x4cf8>
  8c86ad:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c86b2:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8c86b7:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8c86be:	83 c1 f5             	add    $0xfffffff5,%ecx
  8c86c1:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c86c5:	80 f9 03             	cmp    $0x3,%cl
  8c86c8:	0f 82 b5 04 00 00    	jb     8c8b83 <check_lower_drain+0x51a3>
  8c86ce:	b2 20                	mov    $0x20,%dl
  8c86d0:	85 c0                	test   %eax,%eax
  8c86d2:	0f 84 ab 04 00 00    	je     8c8b83 <check_lower_drain+0x51a3>
  8c86d8:	45 31 ed             	xor    %r13d,%r13d
  8c86db:	83 7c 24 28 23       	cmpl   $0x23,0x28(%rsp)
  8c86e0:	0f b6 f2             	movzbl %dl,%esi
  8c86e3:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c86e8:	89 c1                	mov    %eax,%ecx
  8c86ea:	48 89 df             	mov    %rbx,%rdi
  8c86ed:	41 0f 95 c5          	setne  %r13b
  8c86f1:	c5 f8 77             	vzeroupper
  8c86f4:	e8 e7 0d 00 00       	call   8c94e0 <check_lower_instruction>
  8c86f9:	45 8b 06             	mov    (%r14),%r8d
  8c86fc:	48 89 df             	mov    %rbx,%rdi
  8c86ff:	44 89 e6             	mov    %r12d,%esi
  8c8702:	44 89 ea             	mov    %r13d,%edx
  8c8705:	31 c9                	xor    %ecx,%ecx
  8c8707:	e8 44 23 01 00       	call   8daa50 <check_lower_operand>
  8c870c:	e9 0d 05 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c8711:	83 7c 24 28 1b       	cmpl   $0x1b,0x28(%rsp)
  8c8716:	0f 85 d8 04 00 00    	jne    8c8bf4 <check_lower_drain+0x5214>
  8c871c:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8721:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c8726:	48 89 df             	mov    %rbx,%rdi
  8c8729:	31 c9                	xor    %ecx,%ecx
  8c872b:	c5 f8 77             	vzeroupper
  8c872e:	e8 ad 0d 00 00       	call   8c94e0 <check_lower_instruction>
  8c8733:	45 8b 06             	mov    (%r14),%r8d
  8c8736:	ba 01 00 00 00       	mov    $0x1,%edx
  8c873b:	48 89 df             	mov    %rbx,%rdi
  8c873e:	44 89 e6             	mov    %r12d,%esi
  8c8741:	31 c9                	xor    %ecx,%ecx
  8c8743:	e8 08 23 01 00       	call   8daa50 <check_lower_operand>
  8c8748:	e9 60 eb ff ff       	jmp    8c72ad <check_lower_drain+0x38cd>
  8c874d:	84 d2                	test   %dl,%dl
  8c874f:	74 60                	je     8c87b1 <check_lower_drain+0x4dd1>
  8c8751:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c8756:	4b 8d 4c 6d 00       	lea    0x0(%r13,%r13,2),%rcx
  8c875b:	48 c1 e1 05          	shl    $0x5,%rcx
  8c875f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c8763:	8b 04 08             	mov    (%rax,%rcx,1),%eax
  8c8766:	c1 e8 03             	shr    $0x3,%eax
  8c8769:	3b 44 24 48          	cmp    0x48(%rsp),%eax
  8c876d:	73 11                	jae    8c8780 <check_lower_drain+0x4da0>
  8c876f:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c8776:	f6 04 01 02          	testb  $0x2,(%rcx,%rax,1)
  8c877a:	0f 85 9d 00 00 00    	jne    8c881d <check_lower_drain+0x4e3d>
  8c8780:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  8c8785:	c1 e8 03             	shr    $0x3,%eax
  8c8788:	3b 44 24 48          	cmp    0x48(%rsp),%eax
  8c878c:	73 10                	jae    8c879e <check_lower_drain+0x4dbe>
  8c878e:	48 8b 93 a0 01 00 00 	mov    0x1a0(%rbx),%rdx
  8c8795:	48 89 c1             	mov    %rax,%rcx
  8c8798:	f6 04 0a 02          	testb  $0x2,(%rdx,%rcx,1)
  8c879c:	75 7f                	jne    8c881d <check_lower_drain+0x4e3d>
  8c879e:	48 89 df             	mov    %rbx,%rdi
  8c87a1:	44 89 e6             	mov    %r12d,%esi
  8c87a4:	c5 f8 77             	vzeroupper
  8c87a7:	e8 c4 80 01 00       	call   8e0870 <check_lower_update>
  8c87ac:	e9 6d 04 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c87b1:	83 7c 24 28 1d       	cmpl   $0x1d,0x28(%rsp)
  8c87b6:	0f 87 65 01 00 00    	ja     8c8921 <check_lower_drain+0x4f41>
  8c87bc:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c87c1:	b8 60 00 00 20       	mov    $0x20000060,%eax
  8c87c6:	0f a3 c8             	bt     %ecx,%eax
  8c87c9:	0f 83 52 01 00 00    	jae    8c8921 <check_lower_drain+0x4f41>
  8c87cf:	48 8b 6c 24 40       	mov    0x40(%rsp),%rbp
  8c87d4:	c1 ed 03             	shr    $0x3,%ebp
  8c87d7:	3b 6c 24 48          	cmp    0x48(%rsp),%ebp
  8c87db:	73 53                	jae    8c8830 <check_lower_drain+0x4e50>
  8c87dd:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c87e4:	44 0f b6 2c 28       	movzbl (%rax,%rbp,1),%r13d
  8c87e9:	41 80 e5 08          	and    $0x8,%r13b
  8c87ed:	eb 44                	jmp    8c8833 <check_lower_drain+0x4e53>
  8c87ef:	44 8b 5c 24 20       	mov    0x20(%rsp),%r11d
  8c87f4:	4f 8d 2c 5b          	lea    (%r11,%r11,2),%r13
  8c87f8:	49 c1 e5 05          	shl    $0x5,%r13
  8c87fc:	47 8b 54 29 40       	mov    0x40(%r9,%r13,1),%r10d
  8c8801:	4d 85 d2             	test   %r10,%r10
  8c8804:	0f 84 6a 01 00 00    	je     8c8974 <check_lower_drain+0x4f94>
  8c880a:	45 3b 90 c0 00 00 00 	cmp    0xc0(%r8),%r10d
  8c8811:	0f 92 c2             	setb   %dl
  8c8814:	89 54 24 20          	mov    %edx,0x20(%rsp)
  8c8818:	e9 5f 01 00 00       	jmp    8c897c <check_lower_drain+0x4f9c>
  8c881d:	48 89 df             	mov    %rbx,%rdi
  8c8820:	44 89 e6             	mov    %r12d,%esi
  8c8823:	c5 f8 77             	vzeroupper
  8c8826:	e8 e5 7b 01 00       	call   8e0410 <check_lower_complex_update>
  8c882b:	e9 ee 03 00 00       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c8830:	45 31 ed             	xor    %r13d,%r13d
  8c8833:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8c8838:	c1 e8 03             	shr    $0x3,%eax
  8c883b:	3b 44 24 48          	cmp    0x48(%rsp),%eax
  8c883f:	73 16                	jae    8c8857 <check_lower_drain+0x4e77>
  8c8841:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c8848:	44 0f b6 34 01       	movzbl (%rcx,%rax,1),%r14d
  8c884d:	41 80 e6 08          	and    $0x8,%r14b
  8c8851:	41 c0 ee 03          	shr    $0x3,%r14b
  8c8855:	eb 03                	jmp    8c885a <check_lower_drain+0x4e7a>
  8c8857:	45 31 f6             	xor    %r14d,%r14d
  8c885a:	45 84 ed             	test   %r13b,%r13b
  8c885d:	75 40                	jne    8c889f <check_lower_drain+0x4ebf>
  8c885f:	45 84 f6             	test   %r14b,%r14b
  8c8862:	75 3b                	jne    8c889f <check_lower_drain+0x4ebf>
  8c8864:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c8869:	c5 f8 77             	vzeroupper
  8c886c:	e8 5f 0d 01 00       	call   8d95d0 <check_lower_binary>
  8c8871:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8876:	0f b6 f0             	movzbl %al,%esi
  8c8879:	48 89 df             	mov    %rbx,%rdi
  8c887c:	31 c9                	xor    %ecx,%ecx
  8c887e:	e8 5d 0c 00 00       	call   8c94e0 <check_lower_instruction>
  8c8883:	ba 01 00 00 00       	mov    $0x1,%edx
  8c8888:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  8c888d:	48 89 df             	mov    %rbx,%rdi
  8c8890:	44 89 e6             	mov    %r12d,%esi
  8c8893:	31 c9                	xor    %ecx,%ecx
  8c8895:	e8 b6 21 01 00       	call   8daa50 <check_lower_operand>
  8c889a:	e9 0d eb ff ff       	jmp    8c73ac <check_lower_drain+0x39cc>
  8c889f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8c88a4:	45 84 ed             	test   %r13b,%r13b
  8c88a7:	48 89 df             	mov    %rbx,%rdi
  8c88aa:	41 0f 95 c7          	setne  %r15b
  8c88ae:	89 c6                	mov    %eax,%esi
  8c88b0:	0f 45 74 24 40       	cmovne 0x40(%rsp),%esi
  8c88b5:	89 74 24 20          	mov    %esi,0x20(%rsp)
  8c88b9:	c5 f8 77             	vzeroupper
  8c88bc:	e8 ef 8c 01 00       	call   8e15b0 <check_lower_stride>
  8c88c1:	45 20 f7             	and    %r14b,%r15b
  8c88c4:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  8c88c9:	41 80 ff 01          	cmp    $0x1,%r15b
  8c88cd:	0f 85 34 02 00 00    	jne    8c8b07 <check_lower_drain+0x5127>
  8c88d3:	83 7c 24 28 06       	cmpl   $0x6,0x28(%rsp)
  8c88d8:	0f 85 29 02 00 00    	jne    8c8b07 <check_lower_drain+0x5127>
  8c88de:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c88e4:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c88ea:	0f 83 3a 03 00 00    	jae    8c8c2a <check_lower_drain+0x524a>
  8c88f0:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c88f4:	8d 50 01             	lea    0x1(%rax),%edx
  8c88f7:	48 c1 e0 04          	shl    $0x4,%rax
  8c88fb:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8901:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8908:	00 07 00 
  8c890b:	48 83 c2 0d          	add    $0xd,%rdx
  8c890f:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8913:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c891a:	00 00 
  8c891c:	e9 33 03 00 00       	jmp    8c8c54 <check_lower_drain+0x5274>
  8c8921:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c8926:	c5 f8 77             	vzeroupper
  8c8929:	e8 a2 0c 01 00       	call   8d95d0 <check_lower_binary>
  8c892e:	84 c0                	test   %al,%al
  8c8930:	0f 84 6a 03 00 00    	je     8c8ca0 <check_lower_drain+0x52c0>
  8c8936:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c893b:	0f b6 e8             	movzbl %al,%ebp
  8c893e:	48 89 df             	mov    %rbx,%rdi
  8c8941:	89 ee                	mov    %ebp,%esi
  8c8943:	e8 08 8f 01 00       	call   8e1850 <check_lower_operation>
  8c8948:	4c 8b 74 24 70       	mov    0x70(%rsp),%r14
  8c894d:	48 89 df             	mov    %rbx,%rdi
  8c8950:	89 ee                	mov    %ebp,%esi
  8c8952:	44 89 f2             	mov    %r14d,%edx
  8c8955:	e8 06 93 01 00       	call   8e1c60 <check_lower_count>
  8c895a:	ba 01 00 00 00       	mov    $0x1,%edx
  8c895f:	48 89 df             	mov    %rbx,%rdi
  8c8962:	44 89 e6             	mov    %r12d,%esi
  8c8965:	31 c9                	xor    %ecx,%ecx
  8c8967:	45 89 f0             	mov    %r14d,%r8d
  8c896a:	e8 e1 20 01 00       	call   8daa50 <check_lower_operand>
  8c896f:	e9 38 ea ff ff       	jmp    8c73ac <check_lower_drain+0x39cc>
  8c8974:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%rsp)
  8c897b:	00 
  8c897c:	44 0f b6 f9          	movzbl %cl,%r15d
  8c8980:	41 8d 57 ff          	lea    -0x1(%r15),%edx
  8c8984:	83 fa 0a             	cmp    $0xa,%edx
  8c8987:	89 54 24 58          	mov    %edx,0x58(%rsp)
  8c898b:	0f 93 c2             	setae  %dl
  8c898e:	f7 c1 00 05 00 00    	test   $0x500,%ecx
  8c8994:	41 0f 95 c6          	setne  %r14b
  8c8998:	41 08 d6             	or     %dl,%r14b
  8c899b:	0f 85 b8 df ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c89a1:	4d 01 e9             	add    %r13,%r9
  8c89a4:	41 83 79 44 00       	cmpl   $0x0,0x44(%r9)
  8c89a9:	0f 85 aa df ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c89af:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  8c89b6:	00 
  8c89b7:	46 8b 34 9a          	mov    (%rdx,%r11,4),%r14d
  8c89bb:	45 85 f6             	test   %r14d,%r14d
  8c89be:	0f 94 c2             	sete   %dl
  8c89c1:	22 54 24 20          	and    0x20(%rsp),%dl
  8c89c5:	80 fa 01             	cmp    $0x1,%dl
  8c89c8:	75 2e                	jne    8c89f8 <check_lower_drain+0x5018>
  8c89ca:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c89cf:	4c 8b 9a 90 02 00 00 	mov    0x290(%rdx),%r11
  8c89d6:	41 8d 52 ff          	lea    -0x1(%r10),%edx
  8c89da:	41 80 3c 13 00       	cmpb   $0x0,(%r11,%rdx,1)
  8c89df:	74 17                	je     8c89f8 <check_lower_drain+0x5018>
  8c89e1:	4c 8b 5c 24 48       	mov    0x48(%rsp),%r11
  8c89e6:	4d 8b 9b 78 02 00 00 	mov    0x278(%r11),%r11
  8c89ed:	41 80 3c 13 00       	cmpb   $0x0,(%r11,%rdx,1)
  8c89f2:	0f 84 61 df ff ff    	je     8c6959 <check_lower_drain+0x2f79>
  8c89f8:	41 8b 51 0c          	mov    0xc(%r9),%edx
  8c89fc:	85 d2                	test   %edx,%edx
  8c89fe:	74 20                	je     8c8a20 <check_lower_drain+0x5040>
  8c8a00:	41 83 79 54 00       	cmpl   $0x0,0x54(%r9)
  8c8a05:	75 19                	jne    8c8a20 <check_lower_drain+0x5040>
  8c8a07:	45 0f b7 59 08       	movzwl 0x8(%r9),%r11d
  8c8a0c:	41 f7 c3 10 08 00 00 	test   $0x810,%r11d
  8c8a13:	75 0b                	jne    8c8a20 <check_lower_drain+0x5040>
  8c8a15:	41 83 79 04 00       	cmpl   $0x0,0x4(%r9)
  8c8a1a:	0f 84 bb 04 00 00    	je     8c8edb <check_lower_drain+0x54fb>
  8c8a20:	45 85 f6             	test   %r14d,%r14d
  8c8a23:	0f 85 30 df ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c8a29:	41 83 79 04 01       	cmpl   $0x1,0x4(%r9)
  8c8a2e:	0f 94 c2             	sete   %dl
  8c8a31:	22 54 24 20          	and    0x20(%rsp),%dl
  8c8a35:	80 fa 01             	cmp    $0x1,%dl
  8c8a38:	0f 85 1b df ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c8a3e:	48 8b 53 68          	mov    0x68(%rbx),%rdx
  8c8a42:	45 31 db             	xor    %r11d,%r11d
  8c8a45:	46 8b 0c 92          	mov    (%rdx,%r10,4),%r9d
  8c8a49:	49 8b 90 80 00 00 00 	mov    0x80(%r8),%rdx
  8c8a50:	42 8b 14 92          	mov    (%rdx,%r10,4),%edx
  8c8a54:	41 83 f9 ff          	cmp    $0xffffffff,%r9d
  8c8a58:	41 0f 94 c3          	sete   %r11b
  8c8a5c:	41 c1 e3 09          	shl    $0x9,%r11d
  8c8a60:	41 81 c3 00 02 00 00 	add    $0x200,%r11d
  8c8a67:	41 83 f9 ff          	cmp    $0xffffffff,%r9d
  8c8a6b:	44 0f 44 ca          	cmove  %edx,%r9d
  8c8a6f:	0f 85 10 f6 ff ff    	jne    8c8085 <check_lower_drain+0x46a5>
  8c8a75:	85 d2                	test   %edx,%edx
  8c8a77:	0f 84 dc de ff ff    	je     8c6959 <check_lower_drain+0x2f79>
  8c8a7d:	e9 03 f6 ff ff       	jmp    8c8085 <check_lower_drain+0x46a5>
  8c8a82:	83 7c 24 30 3e       	cmpl   $0x3e,0x30(%rsp)
  8c8a87:	77 18                	ja     8c8aa1 <check_lower_drain+0x50c1>
  8c8a89:	8b 54 24 30          	mov    0x30(%rsp),%edx
  8c8a8d:	49 bb 00 00 00 00 08 	movabs $0x4080000800000000,%r11
  8c8a94:	00 80 40 
  8c8a97:	49 0f a3 d3          	bt     %rdx,%r11
  8c8a9b:	0f 82 b8 de ff ff    	jb     8c6959 <check_lower_drain+0x2f79>
  8c8aa1:	83 7c 24 78 01       	cmpl   $0x1,0x78(%rsp)
  8c8aa6:	0f 85 ad de ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c8aac:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
  8c8ab0:	83 7c 24 60 06       	cmpl   $0x6,0x60(%rsp)
  8c8ab5:	c7 44 24 30 01 00 00 	movl   $0x1,0x30(%rsp)
  8c8abc:	00 
  8c8abd:	0f 87 10 04 00 00    	ja     8c8ed3 <check_lower_drain+0x54f3>
  8c8ac3:	41 d1 ee             	shr    $1,%r14d
  8c8ac6:	ba 08 00 00 00       	mov    $0x8,%edx
  8c8acb:	49 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%r11
  8c8ad2:	c4 e2 09 f7 d2       	shlx   %r14d,%edx,%edx
  8c8ad7:	c4 62 e8 f5 ff       	bzhi   %rdx,%rdi,%r15
  8c8adc:	c4 42 e9 f7 f3       	shlx   %rdx,%r11,%r14
  8c8ae1:	ff ca                	dec    %edx
  8c8ae3:	bf 00 00 00 00       	mov    $0x0,%edi
  8c8ae8:	c4 c2 eb f7 d7       	shrx   %rdx,%r15,%rdx
  8c8aed:	48 85 d2             	test   %rdx,%rdx
  8c8af0:	4c 0f 44 f2          	cmove  %rdx,%r14
  8c8af4:	45 31 db             	xor    %r11d,%r11d
  8c8af7:	41 f6 c2 01          	test   $0x1,%r10b
  8c8afb:	49 0f 45 fe          	cmovne %r14,%rdi
  8c8aff:	4c 09 ff             	or     %r15,%rdi
  8c8b02:	e9 62 f5 ff ff       	jmp    8c8069 <check_lower_drain+0x4689>
  8c8b07:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c8b0d:	0f 95 c0             	setne  %al
  8c8b10:	83 7c 24 28 1d       	cmpl   $0x1d,0x28(%rsp)
  8c8b15:	0f 95 c1             	setne  %cl
  8c8b18:	0a 44 24 54          	or     0x54(%rsp),%al
  8c8b1c:	08 c8                	or     %cl,%al
  8c8b1e:	0f 84 9c 01 00 00    	je     8c8cc0 <check_lower_drain+0x52e0>
  8c8b24:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c8b28:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c8b2d:	48 89 df             	mov    %rbx,%rdi
  8c8b30:	e8 9b 8b 01 00       	call   8e16d0 <check_lower_scale>
  8c8b35:	83 7c 24 28 06       	cmpl   $0x6,0x28(%rsp)
  8c8b3a:	0f 85 a5 01 00 00    	jne    8c8ce5 <check_lower_drain+0x5305>
  8c8b40:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8b46:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8b4c:	0f 83 4e 03 00 00    	jae    8c8ea0 <check_lower_drain+0x54c0>
  8c8b52:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8b56:	8d 50 01             	lea    0x1(%rax),%edx
  8c8b59:	48 c1 e0 04          	shl    $0x4,%rax
  8c8b5d:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8b63:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8b6a:	00 07 00 
  8c8b6d:	48 83 c2 06          	add    $0x6,%rdx
  8c8b71:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8b75:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8b7c:	00 00 
  8c8b7e:	e9 62 01 00 00       	jmp    8c8ce5 <check_lower_drain+0x5305>
  8c8b83:	83 7c 24 28 1b       	cmpl   $0x1b,0x28(%rsp)
  8c8b88:	0f 84 8e fb ff ff    	je     8c871c <check_lower_drain+0x4d3c>
  8c8b8e:	85 c0                	test   %eax,%eax
  8c8b90:	74 62                	je     8c8bf4 <check_lower_drain+0x5214>
  8c8b92:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8b97:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c8b9c:	48 89 df             	mov    %rbx,%rdi
  8c8b9f:	31 c9                	xor    %ecx,%ecx
  8c8ba1:	c5 f8 77             	vzeroupper
  8c8ba4:	e8 37 09 00 00       	call   8c94e0 <check_lower_instruction>
  8c8ba9:	45 8b 06             	mov    (%r14),%r8d
  8c8bac:	48 89 df             	mov    %rbx,%rdi
  8c8baf:	44 89 e6             	mov    %r12d,%esi
  8c8bb2:	31 d2                	xor    %edx,%edx
  8c8bb4:	31 c9                	xor    %ecx,%ecx
  8c8bb6:	e8 95 1e 01 00       	call   8daa50 <check_lower_operand>
  8c8bbb:	48 8d 84 24 68 01 00 	lea    0x168(%rsp),%rax
  8c8bc2:	00 
  8c8bc3:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c8bc7:	c5 fa 7f 00          	vmovdqu %xmm0,(%rax)
  8c8bcb:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8c8bd2:	00 
  8c8bd3:	c7 84 24 60 01 00 00 	movl   $0xa,0x160(%rsp)
  8c8bda:	0a 00 00 00 
  8c8bde:	44 89 bc 24 64 01 00 	mov    %r15d,0x164(%rsp)
  8c8be5:	00 
  8c8be6:	c5 fe 6f 84 24 60 01 	vmovdqu 0x160(%rsp),%ymm0
  8c8bed:	00 00 
  8c8bef:	e9 4d f8 ff ff       	jmp    8c8441 <check_lower_drain+0x4a61>
  8c8bf4:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8bf8:	48 8b 00             	mov    (%rax),%rax
  8c8bfb:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8c02:	75 1a                	jne    8c8c1e <check_lower_drain+0x523e>
  8c8c04:	c7 80 f0 00 00 00 01 	movl   $0x1,0xf0(%rax)
  8c8c0b:	00 00 00 
  8c8c0e:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8c14:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8c18:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8c1e:	48 ff 83 00 02 00 00 	incq   0x200(%rbx)
  8c8c25:	e9 ca ae ff ff       	jmp    8c3af4 <check_lower_drain+0x114>
  8c8c2a:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8c2e:	48 8b 00             	mov    (%rax),%rax
  8c8c31:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8c38:	75 1a                	jne    8c8c54 <check_lower_drain+0x5274>
  8c8c3a:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8c41:	00 00 00 
  8c8c44:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8c4a:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8c4e:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8c54:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c8c5a:	0f 84 c2 00 00 00    	je     8c8d22 <check_lower_drain+0x5342>
  8c8c60:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8c66:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8c6c:	0f 83 2c 01 00 00    	jae    8c8d9e <check_lower_drain+0x53be>
  8c8c72:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8c76:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c8c7b:	8d 50 01             	lea    0x1(%rax),%edx
  8c8c7e:	48 c1 e0 04          	shl    $0x4,%rax
  8c8c82:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8c88:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8c8f:	00 07 00 
  8c8c92:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8c96:	48 89 74 01 08       	mov    %rsi,0x8(%rcx,%rax,1)
  8c8c9b:	e9 28 01 00 00       	jmp    8c8dc8 <check_lower_drain+0x53e8>
  8c8ca0:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8ca4:	48 8b 00             	mov    (%rax),%rax
  8c8ca7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8cae:	0f 85 6a ff ff ff    	jne    8c8c1e <check_lower_drain+0x523e>
  8c8cb4:	48 8d 0d ac d8 e0 ff 	lea    -0x1f2754(%rip),%rcx        # 6d6567 <pp_string_value.meaning+0x22a90>
  8c8cbb:	e9 e2 e2 ff ff       	jmp    8c6fa2 <check_lower_drain+0x35c2>
  8c8cc0:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8cc5:	be 0a 00 00 00       	mov    $0xa,%esi
  8c8cca:	48 89 df             	mov    %rbx,%rdi
  8c8ccd:	31 c9                	xor    %ecx,%ecx
  8c8ccf:	e8 0c 08 00 00       	call   8c94e0 <check_lower_instruction>
  8c8cd4:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c8cd8:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c8cdd:	48 89 df             	mov    %rbx,%rdi
  8c8ce0:	e8 eb 89 01 00       	call   8e16d0 <check_lower_scale>
  8c8ce5:	31 ed                	xor    %ebp,%ebp
  8c8ce7:	45 84 ed             	test   %r13b,%r13b
  8c8cea:	41 b8 50 00 00 00    	mov    $0x50,%r8d
  8c8cf0:	48 89 df             	mov    %rbx,%rdi
  8c8cf3:	44 89 e6             	mov    %r12d,%esi
  8c8cf6:	40 0f 94 c5          	sete   %bpl
  8c8cfa:	41 c0 ed 03          	shr    $0x3,%r13b
  8c8cfe:	31 c9                	xor    %ecx,%ecx
  8c8d00:	41 0f b6 d5          	movzbl %r13b,%edx
  8c8d04:	e8 47 1d 01 00       	call   8daa50 <check_lower_operand>
  8c8d09:	44 8b 44 24 20       	mov    0x20(%rsp),%r8d
  8c8d0e:	48 89 df             	mov    %rbx,%rdi
  8c8d11:	44 89 e6             	mov    %r12d,%esi
  8c8d14:	89 ea                	mov    %ebp,%edx
  8c8d16:	31 c9                	xor    %ecx,%ecx
  8c8d18:	e8 33 1d 01 00       	call   8daa50 <check_lower_operand>
  8c8d1d:	e9 fc fe ff ff       	jmp    8c8c1e <check_lower_drain+0x523e>
  8c8d22:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c8d27:	48 8b 08             	mov    (%rax),%rcx
  8c8d2a:	48 8b 40 20          	mov    0x20(%rax),%rax
  8c8d2e:	80 3c 29 0f          	cmpb   $0xf,(%rcx,%rbp,1)
  8c8d32:	75 0f                	jne    8c8d43 <check_lower_drain+0x5363>
  8c8d34:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c8d39:	83 e2 07             	and    $0x7,%edx
  8c8d3c:	0b 14 a8             	or     (%rax,%rbp,4),%edx
  8c8d3f:	89 54 24 20          	mov    %edx,0x20(%rsp)
  8c8d43:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c8d47:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c8d4b:	48 89 df             	mov    %rbx,%rdi
  8c8d4e:	89 f2                	mov    %esi,%edx
  8c8d50:	c1 ea 03             	shr    $0x3,%edx
  8c8d53:	83 e6 07             	and    $0x7,%esi
  8c8d56:	0f b6 0c 11          	movzbl (%rcx,%rdx,1),%ecx
  8c8d5a:	80 c1 f8             	add    $0xf8,%cl
  8c8d5d:	80 f9 03             	cmp    $0x3,%cl
  8c8d60:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c8d65:	0f 43 f1             	cmovae %ecx,%esi
  8c8d68:	0b 34 90             	or     (%rax,%rdx,4),%esi
  8c8d6b:	c5 fe 7f 84 24 c0 01 	vmovdqu %ymm0,0x1c0(%rsp)
  8c8d72:	00 00 
  8c8d74:	c7 84 24 c0 01 00 00 	movl   $0x13,0x1c0(%rsp)
  8c8d7b:	13 00 00 00 
  8c8d7f:	89 b4 24 c8 01 00 00 	mov    %esi,0x1c8(%rsp)
  8c8d86:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c8d8d:	00 00 
  8c8d8f:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c8d94:	c5 f8 77             	vzeroupper
  8c8d97:	e8 f4 44 00 00       	call   8cd290 <check_lower_push>
  8c8d9c:	eb 2a                	jmp    8c8dc8 <check_lower_drain+0x53e8>
  8c8d9e:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8da2:	48 8b 00             	mov    (%rax),%rax
  8c8da5:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8dac:	75 1a                	jne    8c8dc8 <check_lower_drain+0x53e8>
  8c8dae:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8db5:	00 00 00 
  8c8db8:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8dbe:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8dc2:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8dc8:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8dce:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8dd4:	73 2e                	jae    8c8e04 <check_lower_drain+0x5424>
  8c8dd6:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8dda:	8d 50 01             	lea    0x1(%rax),%edx
  8c8ddd:	48 c1 e0 04          	shl    $0x4,%rax
  8c8de1:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8de7:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8dee:	00 07 00 
  8c8df1:	48 83 c2 08          	add    $0x8,%rdx
  8c8df5:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8df9:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8e00:	00 00 
  8c8e02:	eb 2a                	jmp    8c8e2e <check_lower_drain+0x544e>
  8c8e04:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8e08:	48 8b 00             	mov    (%rax),%rax
  8c8e0b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8e12:	75 1a                	jne    8c8e2e <check_lower_drain+0x544e>
  8c8e14:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8e1b:	00 00 00 
  8c8e1e:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8e24:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8e28:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8e2e:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8e34:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8e3a:	73 31                	jae    8c8e6d <check_lower_drain+0x548d>
  8c8e3c:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8e40:	8d 50 01             	lea    0x1(%rax),%edx
  8c8e43:	48 c1 e0 04          	shl    $0x4,%rax
  8c8e47:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8e4d:	48 ba 01 00 00 00 01 	movabs $0x8000100000001,%rdx
  8c8e54:	00 08 00 
  8c8e57:	48 83 c2 0b          	add    $0xb,%rdx
  8c8e5b:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8e5f:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8e66:	00 00 
  8c8e68:	e9 16 fa ff ff       	jmp    8c8883 <check_lower_drain+0x4ea3>
  8c8e6d:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8e71:	48 8b 00             	mov    (%rax),%rax
  8c8e74:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8e7b:	0f 85 02 fa ff ff    	jne    8c8883 <check_lower_drain+0x4ea3>
  8c8e81:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8e88:	00 00 00 
  8c8e8b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8e91:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8e95:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8e9b:	e9 e3 f9 ff ff       	jmp    8c8883 <check_lower_drain+0x4ea3>
  8c8ea0:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8ea4:	48 8b 00             	mov    (%rax),%rax
  8c8ea7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8eae:	0f 85 31 fe ff ff    	jne    8c8ce5 <check_lower_drain+0x5305>
  8c8eb4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8ebb:	00 00 00 
  8c8ebe:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8ec4:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8ec8:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8ece:	e9 12 fe ff ff       	jmp    8c8ce5 <check_lower_drain+0x5305>
  8c8ed3:	45 31 db             	xor    %r11d,%r11d
  8c8ed6:	e9 8e f1 ff ff       	jmp    8c8069 <check_lower_drain+0x4689>
  8c8edb:	41 83 fe 3e          	cmp    $0x3e,%r14d
  8c8edf:	77 17                	ja     8c8ef8 <check_lower_drain+0x5518>
  8c8ee1:	49 ba 00 00 00 00 08 	movabs $0x4080000800000000,%r10
  8c8ee8:	00 80 40 
  8c8eeb:	45 89 f0             	mov    %r14d,%r8d
  8c8eee:	4d 0f a3 c2          	bt     %r8,%r10
  8c8ef2:	0f 82 61 da ff ff    	jb     8c6959 <check_lower_drain+0x2f79>
  8c8ef8:	83 fa 01             	cmp    $0x1,%edx
  8c8efb:	0f 85 58 da ff ff    	jne    8c6959 <check_lower_drain+0x2f79>
  8c8f01:	4d 8b 49 10          	mov    0x10(%r9),%r9
  8c8f05:	41 bb 00 01 00 00    	mov    $0x100,%r11d
  8c8f0b:	41 83 ff 06          	cmp    $0x6,%r15d
  8c8f0f:	0f 87 70 f1 ff ff    	ja     8c8085 <check_lower_drain+0x46a5>
  8c8f15:	44 8b 44 24 58       	mov    0x58(%rsp),%r8d
  8c8f1a:	ba 08 00 00 00       	mov    $0x8,%edx
  8c8f1f:	49 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%r10
  8c8f26:	41 d1 e8             	shr    $1,%r8d
  8c8f29:	c4 e2 39 f7 d2       	shlx   %r8d,%edx,%edx
  8c8f2e:	c4 42 e9 f7 c2       	shlx   %rdx,%r10,%r8
  8c8f33:	c4 42 e8 f5 d1       	bzhi   %rdx,%r9,%r10
  8c8f38:	ff ca                	dec    %edx
  8c8f3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8c8f40:	c4 c2 eb f7 d2       	shrx   %rdx,%r10,%rdx
  8c8f45:	48 85 d2             	test   %rdx,%rdx
  8c8f48:	4c 0f 44 c2          	cmove  %rdx,%r8
  8c8f4c:	f6 c1 01             	test   $0x1,%cl
  8c8f4f:	4d 0f 45 c8          	cmovne %r8,%r9
  8c8f53:	4d 09 d1             	or     %r10,%r9
  8c8f56:	e9 2a f1 ff ff       	jmp    8c8085 <check_lower_drain+0x46a5>
  8c8f5b:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c8f62:	00 00 
  8c8f64:	48 3b 84 24 20 02 00 	cmp    0x220(%rsp),%rax
  8c8f6b:	00 
  8c8f6c:	75 15                	jne    8c8f83 <check_lower_drain+0x55a3>
  8c8f6e:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  8c8f75:	5b                   	pop    %rbx
  8c8f76:	41 5c                	pop    %r12
  8c8f78:	41 5d                	pop    %r13
  8c8f7a:	41 5e                	pop    %r14
  8c8f7c:	41 5f                	pop    %r15
  8c8f7e:	5d                   	pop    %rbp
  8c8f7f:	c5 f8 77             	vzeroupper
  8c8f82:	c3                   	ret
  8c8f83:	c5 f8 77             	vzeroupper
  8c8f86:	e8 35 4e f0 ff       	call   7cddc0 <__stack_chk_fail@plt>
