
/home/david/buster-fast-bench/codex-180-fix-20261026-caller-fixed/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000007c3b30 <instruction_is_valid>:
  7c3b30:	0f b7 47 0c          	movzwl 0xc(%rdi),%eax
  7c3b34:	89 c1                	mov    %eax,%ecx
  7c3b36:	81 e1 e0 7f 00 00    	and    $0x7fe0,%ecx
  7c3b3c:	81 f9 df 61 00 00    	cmp    $0x61df,%ecx
  7c3b42:	0f 87 e2 00 00 00    	ja     7c3c2a <instruction_is_valid+0xfa>
  7c3b48:	55                   	push   %rbp
  7c3b49:	41 57                	push   %r15
  7c3b4b:	41 56                	push   %r14
  7c3b4d:	41 55                	push   %r13
  7c3b4f:	41 54                	push   %r12
  7c3b51:	53                   	push   %rbx
  7c3b52:	48 83 ec 18          	sub    $0x18,%rsp
  7c3b56:	41 89 c5             	mov    %eax,%r13d
  7c3b59:	41 81 e5 ff 7f 00 00 	and    $0x7fff,%r13d
  7c3b60:	44 89 ea             	mov    %r13d,%edx
  7c3b63:	41 81 fd a0 20 00 00 	cmp    $0x20a0,%r13d
  7c3b6a:	0f 83 f8 0a 00 00    	jae    7c4668 <instruction_is_valid+0xb38>
  7c3b70:	89 d1                	mov    %edx,%ecx
  7c3b72:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  7c3b76:	4c 8d 05 93 bd 1b 01 	lea    0x11bbd93(%rip),%r8        # 197f910 <x86_form_descriptions>
  7c3b7d:	44 0f b6 77 0b       	movzbl 0xb(%rdi),%r14d
  7c3b82:	45 0f b6 7c c8 11    	movzbl 0x11(%r8,%rcx,8),%r15d
  7c3b88:	41 0f b7 6c c8 18    	movzwl 0x18(%r8,%rcx,8),%ebp
  7c3b8e:	49 8d 1c c8          	lea    (%r8,%rcx,8),%rbx
  7c3b92:	41 80 ff 01          	cmp    $0x1,%r15b
  7c3b96:	0f 94 c1             	sete   %cl
  7c3b99:	0f 85 90 00 00 00    	jne    7c3c2f <instruction_is_valid+0xff>
  7c3b9f:	81 fa 30 20 00 00    	cmp    $0x2030,%edx
  7c3ba5:	0f 87 41 01 00 00    	ja     7c3cec <instruction_is_valid+0x1bc>
  7c3bab:	44 0f b7 4b 16       	movzwl 0x16(%rbx),%r9d
  7c3bb0:	0f b6 57 08          	movzbl 0x8(%rdi),%edx
  7c3bb4:	45 89 c8             	mov    %r9d,%r8d
  7c3bb7:	41 83 e0 0f          	and    $0xf,%r8d
  7c3bbb:	0f 84 8f 00 00 00    	je     7c3c50 <instruction_is_valid+0x120>
  7c3bc1:	44 0f b6 63 1c       	movzbl 0x1c(%rbx),%r12d
  7c3bc6:	66 41 83 f8 01       	cmp    $0x1,%r8w
  7c3bcb:	75 0e                	jne    7c3bdb <instruction_is_valid+0xab>
  7c3bcd:	66 41 ba b0 00       	mov    $0xb0,%r10w
  7c3bd2:	45 84 e4             	test   %r12b,%r12b
  7c3bd5:	0f 84 8c 00 00 00    	je     7c3c67 <instruction_is_valid+0x137>
  7c3bdb:	45 0f b7 d8          	movzwl %r8w,%r11d
  7c3bdf:	41 80 fc 02          	cmp    $0x2,%r12b
  7c3be3:	75 10                	jne    7c3bf5 <instruction_is_valid+0xc5>
  7c3be5:	45 8d 63 fb          	lea    -0x5(%r11),%r12d
  7c3be9:	66 41 ba e0 00       	mov    $0xe0,%r10w
  7c3bee:	66 41 83 fc 03       	cmp    $0x3,%r12w
  7c3bf3:	72 72                	jb     7c3c67 <instruction_is_valid+0x137>
  7c3bf5:	45 89 cc             	mov    %r9d,%r12d
  7c3bf8:	41 83 e4 0e          	and    $0xe,%r12d
  7c3bfc:	66 41 ba f8 00       	mov    $0xf8,%r10w
  7c3c01:	66 41 83 fc 08       	cmp    $0x8,%r12w
  7c3c06:	74 5f                	je     7c3c67 <instruction_is_valid+0x137>
  7c3c08:	41 83 c3 f6          	add    $0xfffffff6,%r11d
  7c3c0c:	66 41 ba f0 00       	mov    $0xf0,%r10w
  7c3c11:	66 41 83 fb 05       	cmp    $0x5,%r11w
  7c3c16:	77 4f                	ja     7c3c67 <instruction_is_valid+0x137>
  7c3c18:	45 0f b7 d3          	movzwl %r11w,%r10d
  7c3c1c:	4c 8d 1d 9d 1c c5 ff 	lea    -0x3ae363(%rip),%r11        # 4158c0 <c_testsuite_feature.marker+0x22c>
  7c3c23:	47 0f b6 14 1a       	movzbl (%r10,%r11,1),%r10d
  7c3c28:	eb 3d                	jmp    7c3c67 <instruction_is_valid+0x137>
  7c3c2a:	31 c0                	xor    %eax,%eax
  7c3c2c:	24 01                	and    $0x1,%al
  7c3c2e:	c3                   	ret
  7c3c2f:	81 fa 30 20 00 00    	cmp    $0x2030,%edx
  7c3c35:	0f 87 b1 00 00 00    	ja     7c3cec <instruction_is_valid+0x1bc>
  7c3c3b:	80 7f 08 00          	cmpb   $0x0,0x8(%rdi)
  7c3c3f:	41 0f 94 c1          	sete   %r9b
  7c3c43:	85 ed                	test   %ebp,%ebp
  7c3c45:	0f 85 bd 00 00 00    	jne    7c3d08 <instruction_is_valid+0x1d8>
  7c3c4b:	e9 32 01 00 00       	jmp    7c3d82 <instruction_is_valid+0x252>
  7c3c50:	41 f7 c1 00 10 00 00 	test   $0x1000,%r9d
  7c3c57:	41 bb ff 00 00 00    	mov    $0xff,%r11d
  7c3c5d:	41 ba f0 00 00 00    	mov    $0xf0,%r10d
  7c3c63:	45 0f 44 d3          	cmove  %r11d,%r10d
  7c3c67:	41 bb 0a 01 00 00    	mov    $0x10a,%r11d
  7c3c6d:	45 0f b7 e2          	movzwl %r10w,%r12d
  7c3c71:	45 31 d2             	xor    %r10d,%r10d
  7c3c74:	c4 42 20 f7 d9       	bextr  %r11d,%r9d,%r11d
  7c3c79:	45 09 dc             	or     %r11d,%r12d
  7c3c7c:	41 f7 c1 00 08 00 00 	test   $0x800,%r9d
  7c3c83:	41 0f 95 c2          	setne  %r10b
  7c3c87:	47 8d 14 52          	lea    (%r10,%r10,2),%r10d
  7c3c8b:	45 09 e2             	or     %r12d,%r10d
  7c3c8e:	41 84 d2             	test   %dl,%r10b
  7c3c91:	41 0f 94 c1          	sete   %r9b
  7c3c95:	f6 c2 40             	test   $0x40,%dl
  7c3c98:	74 15                	je     7c3caf <instruction_is_valid+0x17f>
  7c3c9a:	41 89 d1             	mov    %edx,%r9d
  7c3c9d:	41 20 d2             	and    %dl,%r10b
  7c3ca0:	41 80 e1 1c          	and    $0x1c,%r9b
  7c3ca4:	41 80 f1 04          	xor    $0x4,%r9b
  7c3ca8:	45 08 d1             	or     %r10b,%r9b
  7c3cab:	41 0f 94 c1          	sete   %r9b
  7c3caf:	41 83 f8 0e          	cmp    $0xe,%r8d
  7c3cb3:	74 43                	je     7c3cf8 <instruction_is_valid+0x1c8>
  7c3cb5:	41 83 f8 0c          	cmp    $0xc,%r8d
  7c3cb9:	75 49                	jne    7c3d04 <instruction_is_valid+0x1d4>
  7c3cbb:	45 84 c9             	test   %r9b,%r9b
  7c3cbe:	74 2c                	je     7c3cec <instruction_is_valid+0x1bc>
  7c3cc0:	84 d2                	test   %dl,%dl
  7c3cc2:	0f 84 d3 02 00 00    	je     7c3f9b <instruction_is_valid+0x46b>
  7c3cc8:	80 fa 01             	cmp    $0x1,%dl
  7c3ccb:	41 0f 95 c0          	setne  %r8b
  7c3ccf:	80 fa 05             	cmp    $0x5,%dl
  7c3cd2:	41 0f 92 c2          	setb   %r10b
  7c3cd6:	45 20 c2             	and    %r8b,%r10b
  7c3cd9:	80 fa 08             	cmp    $0x8,%dl
  7c3cdc:	41 0f 94 c1          	sete   %r9b
  7c3ce0:	45 08 d1             	or     %r10b,%r9b
  7c3ce3:	85 ed                	test   %ebp,%ebp
  7c3ce5:	75 21                	jne    7c3d08 <instruction_is_valid+0x1d8>
  7c3ce7:	e9 96 00 00 00       	jmp    7c3d82 <instruction_is_valid+0x252>
  7c3cec:	45 31 c9             	xor    %r9d,%r9d
  7c3cef:	85 ed                	test   %ebp,%ebp
  7c3cf1:	75 15                	jne    7c3d08 <instruction_is_valid+0x1d8>
  7c3cf3:	e9 8a 00 00 00       	jmp    7c3d82 <instruction_is_valid+0x252>
  7c3cf8:	80 fa 06             	cmp    $0x6,%dl
  7c3cfb:	0f 92 c2             	setb   %dl
  7c3cfe:	44 20 ca             	and    %r9b,%dl
  7c3d01:	41 89 d1             	mov    %edx,%r9d
  7c3d04:	85 ed                	test   %ebp,%ebp
  7c3d06:	74 7a                	je     7c3d82 <instruction_is_valid+0x252>
  7c3d08:	41 f6 c6 04          	test   $0x4,%r14b
  7c3d0c:	0f 84 a4 00 00 00    	je     7c3db6 <instruction_is_valid+0x286>
  7c3d12:	44 89 fa             	mov    %r15d,%edx
  7c3d15:	80 e2 08             	and    $0x8,%dl
  7c3d18:	c0 ea 03             	shr    $0x3,%dl
  7c3d1b:	08 d1                	or     %dl,%cl
  7c3d1d:	44 20 c9             	and    %r9b,%cl
  7c3d20:	41 89 e9             	mov    %ebp,%r9d
  7c3d23:	41 c0 e9 05          	shr    $0x5,%r9b
  7c3d27:	41 80 fe 40          	cmp    $0x40,%r14b
  7c3d2b:	41 0f 92 c0          	setb   %r8b
  7c3d2f:	45 20 c8             	and    %r9b,%r8b
  7c3d32:	41 20 c8             	and    %cl,%r8b
  7c3d35:	41 80 f8 01          	cmp    $0x1,%r8b
  7c3d39:	0f 85 10 01 00 00    	jne    7c3e4f <instruction_is_valid+0x31f>
  7c3d3f:	41 f6 c6 20          	test   $0x20,%r14b
  7c3d43:	74 0c                	je     7c3d51 <instruction_is_valid+0x221>
  7c3d45:	44 89 f1             	mov    %r14d,%ecx
  7c3d48:	83 e1 18             	and    $0x18,%ecx
  7c3d4b:	0f 85 fe 00 00 00    	jne    7c3e4f <instruction_is_valid+0x31f>
  7c3d51:	41 f6 c6 10          	test   $0x10,%r14b
  7c3d55:	0f 94 c1             	sete   %cl
  7c3d58:	41 f6 c6 03          	test   $0x3,%r14b
  7c3d5c:	0f 95 c2             	setne  %dl
  7c3d5f:	84 d1                	test   %dl,%cl
  7c3d61:	0f 85 e8 00 00 00    	jne    7c3e4f <instruction_is_valid+0x31f>
  7c3d67:	0f b6 4f 09          	movzbl 0x9(%rdi),%ecx
  7c3d6b:	41 f6 c6 08          	test   $0x8,%r14b
  7c3d6f:	0f 85 9c 00 00 00    	jne    7c3e11 <instruction_is_valid+0x2e1>
  7c3d75:	84 c9                	test   %cl,%cl
  7c3d77:	0f 85 d2 00 00 00    	jne    7c3e4f <instruction_is_valid+0x31f>
  7c3d7d:	e9 94 00 00 00       	jmp    7c3e16 <instruction_is_valid+0x2e6>
  7c3d82:	45 84 c9             	test   %r9b,%r9b
  7c3d85:	0f 84 fd 03 00 00    	je     7c4188 <instruction_is_valid+0x658>
  7c3d8b:	80 7f 09 00          	cmpb   $0x0,0x9(%rdi)
  7c3d8f:	0f 85 f3 03 00 00    	jne    7c4188 <instruction_is_valid+0x658>
  7c3d95:	0f b6 4f 0a          	movzbl 0xa(%rdi),%ecx
  7c3d99:	41 81 fd a0 20 00 00 	cmp    $0x20a0,%r13d
  7c3da0:	0f 92 c0             	setb   %al
  7c3da3:	44 08 f1             	or     %r14b,%cl
  7c3da6:	0f 94 c1             	sete   %cl
  7c3da9:	84 c1                	test   %al,%cl
  7c3dab:	0f 84 d7 03 00 00    	je     7c4188 <instruction_is_valid+0x658>
  7c3db1:	e9 ac 02 00 00       	jmp    7c4062 <instruction_is_valid+0x532>
  7c3db6:	45 84 f6             	test   %r14b,%r14b
  7c3db9:	0f 94 c0             	sete   %al
  7c3dbc:	41 20 c1             	and    %al,%r9b
  7c3dbf:	41 80 f9 01          	cmp    $0x1,%r9b
  7c3dc3:	0f 85 3f 05 00 00    	jne    7c4308 <instruction_is_valid+0x7d8>
  7c3dc9:	41 81 fd a0 20 00 00 	cmp    $0x20a0,%r13d
  7c3dd0:	0f 93 c0             	setae  %al
  7c3dd3:	80 7f 0a 00          	cmpb   $0x0,0xa(%rdi)
  7c3dd7:	0f 95 c1             	setne  %cl
  7c3dda:	40 f6 c5 10          	test   $0x10,%bpl
  7c3dde:	0f 94 c2             	sete   %dl
  7c3de1:	08 c1                	or     %al,%cl
  7c3de3:	08 d1                	or     %dl,%cl
  7c3de5:	0f 85 1d 05 00 00    	jne    7c4308 <instruction_is_valid+0x7d8>
  7c3deb:	0f b6 47 09          	movzbl 0x9(%rdi),%eax
  7c3def:	0f b6 53 1c          	movzbl 0x1c(%rbx),%edx
  7c3df3:	49 89 fc             	mov    %rdi,%r12
  7c3df6:	89 ee                	mov    %ebp,%esi
  7c3df8:	31 c9                	xor    %ecx,%ecx
  7c3dfa:	89 c7                	mov    %eax,%edi
  7c3dfc:	e8 df 08 00 00       	call   7c46e0 <mode_register_is_valid>
  7c3e01:	4c 89 e7             	mov    %r12,%rdi
  7c3e04:	84 c0                	test   %al,%al
  7c3e06:	0f 85 56 02 00 00    	jne    7c4062 <instruction_is_valid+0x532>
  7c3e0c:	e9 f7 04 00 00       	jmp    7c4308 <instruction_is_valid+0x7d8>
  7c3e11:	80 f9 10             	cmp    $0x10,%cl
  7c3e14:	73 39                	jae    7c3e4f <instruction_is_valid+0x31f>
  7c3e16:	41 f6 c6 20          	test   $0x20,%r14b
  7c3e1a:	74 0a                	je     7c3e26 <instruction_is_valid+0x2f6>
  7c3e1c:	89 e9                	mov    %ebp,%ecx
  7c3e1e:	81 e1 00 01 00 00    	and    $0x100,%ecx
  7c3e24:	75 29                	jne    7c3e4f <instruction_is_valid+0x31f>
  7c3e26:	41 f6 c6 03          	test   $0x3,%r14b
  7c3e2a:	74 0a                	je     7c3e36 <instruction_is_valid+0x306>
  7c3e2c:	89 e9                	mov    %ebp,%ecx
  7c3e2e:	81 e1 00 02 00 00    	and    $0x200,%ecx
  7c3e34:	75 19                	jne    7c3e4f <instruction_is_valid+0x31f>
  7c3e36:	85 f6                	test   %esi,%esi
  7c3e38:	0f 84 80 01 00 00    	je     7c3fbe <instruction_is_valid+0x48e>
  7c3e3e:	0f b7 4b 16          	movzwl 0x16(%rbx),%ecx
  7c3e42:	83 e1 0f             	and    $0xf,%ecx
  7c3e45:	66 83 f9 0a          	cmp    $0xa,%cx
  7c3e49:	0f 85 6f 01 00 00    	jne    7c3fbe <instruction_is_valid+0x48e>
  7c3e4f:	31 c0                	xor    %eax,%eax
  7c3e51:	40 f6 c5 40          	test   $0x40,%bpl
  7c3e55:	0f 84 7c 01 00 00    	je     7c3fd7 <instruction_is_valid+0x4a7>
  7c3e5b:	44 89 f1             	mov    %r14d,%ecx
  7c3e5e:	83 e1 10             	and    $0x10,%ecx
  7c3e61:	c1 e9 04             	shr    $0x4,%ecx
  7c3e64:	20 c8                	and    %cl,%al
  7c3e66:	3c 01                	cmp    $0x1,%al
  7c3e68:	0f 85 9a 04 00 00    	jne    7c4308 <instruction_is_valid+0x7d8>
  7c3e6e:	0f b6 47 0a          	movzbl 0xa(%rdi),%eax
  7c3e72:	89 e9                	mov    %ebp,%ecx
  7c3e74:	83 e1 0f             	and    $0xf,%ecx
  7c3e77:	0f 84 d5 00 00 00    	je     7c3f52 <instruction_is_valid+0x422>
  7c3e7d:	44 0f b6 43 1c       	movzbl 0x1c(%rbx),%r8d
  7c3e82:	66 83 f9 01          	cmp    $0x1,%cx
  7c3e86:	75 0d                	jne    7c3e95 <instruction_is_valid+0x365>
  7c3e88:	66 ba b0 00          	mov    $0xb0,%dx
  7c3e8c:	45 84 c0             	test   %r8b,%r8b
  7c3e8f:	0f 84 d0 00 00 00    	je     7c3f65 <instruction_is_valid+0x435>
  7c3e95:	0f b7 d1             	movzwl %cx,%edx
  7c3e98:	8d 72 fb             	lea    -0x5(%rdx),%esi
  7c3e9b:	66 83 fe 02          	cmp    $0x2,%si
  7c3e9f:	77 0a                	ja     7c3eab <instruction_is_valid+0x37b>
  7c3ea1:	66 be e0 00          	mov    $0xe0,%si
  7c3ea5:	41 80 f8 02          	cmp    $0x2,%r8b
  7c3ea9:	74 2e                	je     7c3ed9 <instruction_is_valid+0x3a9>
  7c3eab:	41 89 e8             	mov    %ebp,%r8d
  7c3eae:	41 83 e0 0e          	and    $0xe,%r8d
  7c3eb2:	66 be f8 00          	mov    $0xf8,%si
  7c3eb6:	66 41 83 f8 08       	cmp    $0x8,%r8w
  7c3ebb:	74 1c                	je     7c3ed9 <instruction_is_valid+0x3a9>
  7c3ebd:	44 8d 41 f3          	lea    -0xd(%rcx),%r8d
  7c3ec1:	41 83 f8 03          	cmp    $0x3,%r8d
  7c3ec5:	72 12                	jb     7c3ed9 <instruction_is_valid+0x3a9>
  7c3ec7:	83 f9 0a             	cmp    $0xa,%ecx
  7c3eca:	0f 84 8f 07 00 00    	je     7c465f <instruction_is_valid+0xb2f>
  7c3ed0:	83 f9 0b             	cmp    $0xb,%ecx
  7c3ed3:	74 04                	je     7c3ed9 <instruction_is_valid+0x3a9>
  7c3ed5:	66 be f0 00          	mov    $0xf0,%si
  7c3ed9:	41 b9 0a 01 00 00    	mov    $0x10a,%r9d
  7c3edf:	41 89 c0             	mov    %eax,%r8d
  7c3ee2:	0f b7 f6             	movzwl %si,%esi
  7c3ee5:	c4 62 30 f7 cd       	bextr  %r9d,%ebp,%r9d
  7c3eea:	41 80 e0 40          	and    $0x40,%r8b
  7c3eee:	44 09 ce             	or     %r9d,%esi
  7c3ef1:	45 31 c9             	xor    %r9d,%r9d
  7c3ef4:	f7 c5 00 08 00 00    	test   $0x800,%ebp
  7c3efa:	41 0f 95 c1          	setne  %r9b
  7c3efe:	47 8d 0c 49          	lea    (%r9,%r9,2),%r9d
  7c3f02:	41 09 f1             	or     %esi,%r9d
  7c3f05:	41 20 c1             	and    %al,%r9b
  7c3f08:	45 08 c1             	or     %r8b,%r9b
  7c3f0b:	40 0f 94 c6          	sete   %sil
  7c3f0f:	66 83 f9 0e          	cmp    $0xe,%cx
  7c3f13:	0f 84 92 00 00 00    	je     7c3fab <instruction_is_valid+0x47b>
  7c3f19:	83 fa 0c             	cmp    $0xc,%edx
  7c3f1c:	0f 85 37 01 00 00    	jne    7c4059 <instruction_is_valid+0x529>
  7c3f22:	40 84 f6             	test   %sil,%sil
  7c3f25:	0f 84 dd 03 00 00    	je     7c4308 <instruction_is_valid+0x7d8>
  7c3f2b:	84 c0                	test   %al,%al
  7c3f2d:	0f 84 2f 01 00 00    	je     7c4062 <instruction_is_valid+0x532>
  7c3f33:	3c 01                	cmp    $0x1,%al
  7c3f35:	0f 95 c1             	setne  %cl
  7c3f38:	3c 05                	cmp    $0x5,%al
  7c3f3a:	0f 92 c2             	setb   %dl
  7c3f3d:	3c 08                	cmp    $0x8,%al
  7c3f3f:	0f 84 1d 01 00 00    	je     7c4062 <instruction_is_valid+0x532>
  7c3f45:	20 d1                	and    %dl,%cl
  7c3f47:	0f 84 bb 03 00 00    	je     7c4308 <instruction_is_valid+0x7d8>
  7c3f4d:	e9 10 01 00 00       	jmp    7c4062 <instruction_is_valid+0x532>
  7c3f52:	f7 c5 00 10 00 00    	test   $0x1000,%ebp
  7c3f58:	b9 ff 00 00 00       	mov    $0xff,%ecx
  7c3f5d:	ba f0 00 00 00       	mov    $0xf0,%edx
  7c3f62:	0f 44 d1             	cmove  %ecx,%edx
  7c3f65:	be 0a 01 00 00       	mov    $0x10a,%esi
  7c3f6a:	89 c1                	mov    %eax,%ecx
  7c3f6c:	0f b7 d2             	movzwl %dx,%edx
  7c3f6f:	c4 e2 48 f7 f5       	bextr  %esi,%ebp,%esi
  7c3f74:	80 e1 40             	and    $0x40,%cl
  7c3f77:	09 f2                	or     %esi,%edx
  7c3f79:	31 f6                	xor    %esi,%esi
  7c3f7b:	f7 c5 00 08 00 00    	test   $0x800,%ebp
  7c3f81:	40 0f 95 c6          	setne  %sil
  7c3f85:	8d 34 76             	lea    (%rsi,%rsi,2),%esi
  7c3f88:	09 d6                	or     %edx,%esi
  7c3f8a:	40 20 c6             	and    %al,%sil
  7c3f8d:	40 08 ce             	or     %cl,%sil
  7c3f90:	0f 85 72 03 00 00    	jne    7c4308 <instruction_is_valid+0x7d8>
  7c3f96:	e9 c7 00 00 00       	jmp    7c4062 <instruction_is_valid+0x532>
  7c3f9b:	41 b1 01             	mov    $0x1,%r9b
  7c3f9e:	85 ed                	test   %ebp,%ebp
  7c3fa0:	0f 85 62 fd ff ff    	jne    7c3d08 <instruction_is_valid+0x1d8>
  7c3fa6:	e9 e0 fd ff ff       	jmp    7c3d8b <instruction_is_valid+0x25b>
  7c3fab:	3c 06                	cmp    $0x6,%al
  7c3fad:	0f 92 c0             	setb   %al
  7c3fb0:	40 84 f0             	test   %sil,%al
  7c3fb3:	0f 85 a9 00 00 00    	jne    7c4062 <instruction_is_valid+0x532>
  7c3fb9:	e9 4a 03 00 00       	jmp    7c4308 <instruction_is_valid+0x7d8>
  7c3fbe:	49 89 fc             	mov    %rdi,%r12
  7c3fc1:	89 c7                	mov    %eax,%edi
  7c3fc3:	e8 28 08 00 00       	call   7c47f0 <x86_form_lacks_room>
  7c3fc8:	34 01                	xor    $0x1,%al
  7c3fca:	4c 89 e7             	mov    %r12,%rdi
  7c3fcd:	40 f6 c5 40          	test   $0x40,%bpl
  7c3fd1:	0f 85 84 fe ff ff    	jne    7c3e5b <instruction_is_valid+0x32b>
  7c3fd7:	40 84 ed             	test   %bpl,%bpl
  7c3fda:	78 31                	js     7c400d <instruction_is_valid+0x4dd>
  7c3fdc:	84 c0                	test   %al,%al
  7c3fde:	0f 84 24 03 00 00    	je     7c4308 <instruction_is_valid+0x7d8>
  7c3fe4:	0f b6 47 0a          	movzbl 0xa(%rdi),%eax
  7c3fe8:	41 f6 c6 10          	test   $0x10,%r14b
  7c3fec:	0f 84 0e 03 00 00    	je     7c4300 <instruction_is_valid+0x7d0>
  7c3ff2:	a8 40                	test   $0x40,%al
  7c3ff4:	0f 85 0e 03 00 00    	jne    7c4308 <instruction_is_valid+0x7d8>
  7c3ffa:	3c 10                	cmp    $0x10,%al
  7c3ffc:	0f 92 c1             	setb   %cl
  7c3fff:	3c 04                	cmp    $0x4,%al
  7c4001:	0f 95 c0             	setne  %al
  7c4004:	84 c1                	test   %al,%cl
  7c4006:	75 5a                	jne    7c4062 <instruction_is_valid+0x532>
  7c4008:	e9 fb 02 00 00       	jmp    7c4308 <instruction_is_valid+0x7d8>
  7c400d:	0f b6 4f 0a          	movzbl 0xa(%rdi),%ecx
  7c4011:	80 f9 04             	cmp    $0x4,%cl
  7c4014:	0f 94 c2             	sete   %dl
  7c4017:	41 f6 c6 03          	test   $0x3,%r14b
  7c401b:	40 0f 95 c6          	setne  %sil
  7c401f:	84 c0                	test   %al,%al
  7c4021:	0f 84 e1 02 00 00    	je     7c4308 <instruction_is_valid+0x7d8>
  7c4027:	44 89 f0             	mov    %r14d,%eax
  7c402a:	83 e0 18             	and    $0x18,%eax
  7c402d:	83 f8 08             	cmp    $0x8,%eax
  7c4030:	0f 84 d2 02 00 00    	je     7c4308 <instruction_is_valid+0x7d8>
  7c4036:	40 20 f2             	and    %sil,%dl
  7c4039:	0f 85 c9 02 00 00    	jne    7c4308 <instruction_is_valid+0x7d8>
  7c403f:	41 f6 c6 10          	test   $0x10,%r14b
  7c4043:	0f 84 ff 04 00 00    	je     7c4548 <instruction_is_valid+0xa18>
  7c4049:	80 f9 10             	cmp    $0x10,%cl
  7c404c:	40 0f 92 c6          	setb   %sil
  7c4050:	f6 c1 40             	test   $0x40,%cl
  7c4053:	0f 85 af 02 00 00    	jne    7c4308 <instruction_is_valid+0x7d8>
  7c4059:	40 84 f6             	test   %sil,%sil
  7c405c:	0f 84 a6 02 00 00    	je     7c4308 <instruction_is_valid+0x7d8>
  7c4062:	0f b7 73 1e          	movzwl 0x1e(%rbx),%esi
  7c4066:	0f b6 47 0e          	movzbl 0xe(%rdi),%eax
  7c406a:	85 f6                	test   %esi,%esi
  7c406c:	74 6b                	je     7c40d9 <instruction_is_valid+0x5a9>
  7c406e:	89 f2                	mov    %esi,%edx
  7c4070:	66 83 e2 0f          	and    $0xf,%dx
  7c4074:	0f b7 ca             	movzwl %dx,%ecx
  7c4077:	74 7a                	je     7c40f3 <instruction_is_valid+0x5c3>
  7c4079:	44 0f b6 4b 1c       	movzbl 0x1c(%rbx),%r9d
  7c407e:	66 83 fa 01          	cmp    $0x1,%dx
  7c4082:	75 0a                	jne    7c408e <instruction_is_valid+0x55e>
  7c4084:	66 41 b8 b0 00       	mov    $0xb0,%r8w
  7c4089:	45 84 c9             	test   %r9b,%r9b
  7c408c:	74 7b                	je     7c4109 <instruction_is_valid+0x5d9>
  7c408e:	44 8d 41 fb          	lea    -0x5(%rcx),%r8d
  7c4092:	66 41 83 f8 02       	cmp    $0x2,%r8w
  7c4097:	77 0b                	ja     7c40a4 <instruction_is_valid+0x574>
  7c4099:	66 41 b8 e0 00       	mov    $0xe0,%r8w
  7c409e:	41 80 f9 02          	cmp    $0x2,%r9b
  7c40a2:	74 65                	je     7c4109 <instruction_is_valid+0x5d9>
  7c40a4:	41 89 f1             	mov    %esi,%r9d
  7c40a7:	41 83 e1 0e          	and    $0xe,%r9d
  7c40ab:	66 41 b8 f8 00       	mov    $0xf8,%r8w
  7c40b0:	66 41 83 f9 08       	cmp    $0x8,%r9w
  7c40b5:	74 52                	je     7c4109 <instruction_is_valid+0x5d9>
  7c40b7:	44 8d 49 f6          	lea    -0xa(%rcx),%r9d
  7c40bb:	66 41 b8 f0 00       	mov    $0xf0,%r8w
  7c40c0:	66 41 83 f9 05       	cmp    $0x5,%r9w
  7c40c5:	77 42                	ja     7c4109 <instruction_is_valid+0x5d9>
  7c40c7:	45 0f b7 c1          	movzwl %r9w,%r8d
  7c40cb:	4c 8d 0d ee 17 c5 ff 	lea    -0x3ae812(%rip),%r9        # 4158c0 <c_testsuite_feature.marker+0x22c>
  7c40d2:	47 0f b6 04 08       	movzbl (%r8,%r9,1),%r8d
  7c40d7:	eb 30                	jmp    7c4109 <instruction_is_valid+0x5d9>
  7c40d9:	84 c0                	test   %al,%al
  7c40db:	40 0f 94 c6          	sete   %sil
  7c40df:	44 0f b6 57 0f       	movzbl 0xf(%rdi),%r10d
  7c40e4:	41 f6 c6 04          	test   $0x4,%r14b
  7c40e8:	0f 84 d2 00 00 00    	je     7c41c0 <instruction_is_valid+0x690>
  7c40ee:	e9 a2 00 00 00       	jmp    7c4195 <instruction_is_valid+0x665>
  7c40f3:	f7 c6 00 10 00 00    	test   $0x1000,%esi
  7c40f9:	41 b9 ff 00 00 00    	mov    $0xff,%r9d
  7c40ff:	41 b8 f0 00 00 00    	mov    $0xf0,%r8d
  7c4105:	45 0f 44 c1          	cmove  %r9d,%r8d
  7c4109:	41 b9 0a 01 00 00    	mov    $0x10a,%r9d
  7c410f:	45 0f b7 d0          	movzwl %r8w,%r10d
  7c4113:	45 31 c0             	xor    %r8d,%r8d
  7c4116:	c4 62 30 f7 ce       	bextr  %r9d,%esi,%r9d
  7c411b:	45 09 ca             	or     %r9d,%r10d
  7c411e:	f7 c6 00 08 00 00    	test   $0x800,%esi
  7c4124:	41 0f 95 c0          	setne  %r8b
  7c4128:	47 8d 04 40          	lea    (%r8,%r8,2),%r8d
  7c412c:	45 09 d0             	or     %r10d,%r8d
  7c412f:	41 84 c0             	test   %al,%r8b
  7c4132:	40 0f 94 c6          	sete   %sil
  7c4136:	a8 40                	test   $0x40,%al
  7c4138:	74 14                	je     7c414e <instruction_is_valid+0x61e>
  7c413a:	89 c6                	mov    %eax,%esi
  7c413c:	41 20 c0             	and    %al,%r8b
  7c413f:	40 80 e6 1c          	and    $0x1c,%sil
  7c4143:	40 80 f6 04          	xor    $0x4,%sil
  7c4147:	44 08 c6             	or     %r8b,%sil
  7c414a:	40 0f 94 c6          	sete   %sil
  7c414e:	66 83 fa 0e          	cmp    $0xe,%dx
  7c4152:	74 57                	je     7c41ab <instruction_is_valid+0x67b>
  7c4154:	83 f9 0c             	cmp    $0xc,%ecx
  7c4157:	75 31                	jne    7c418a <instruction_is_valid+0x65a>
  7c4159:	40 84 f6             	test   %sil,%sil
  7c415c:	74 2a                	je     7c4188 <instruction_is_valid+0x658>
  7c415e:	84 c0                	test   %al,%al
  7c4160:	0f 84 ef 03 00 00    	je     7c4555 <instruction_is_valid+0xa25>
  7c4166:	3c 01                	cmp    $0x1,%al
  7c4168:	0f 95 c1             	setne  %cl
  7c416b:	3c 05                	cmp    $0x5,%al
  7c416d:	0f 92 c2             	setb   %dl
  7c4170:	20 ca                	and    %cl,%dl
  7c4172:	3c 08                	cmp    $0x8,%al
  7c4174:	40 0f 94 c6          	sete   %sil
  7c4178:	40 08 d6             	or     %dl,%sil
  7c417b:	44 0f b6 57 0f       	movzbl 0xf(%rdi),%r10d
  7c4180:	41 f6 c6 04          	test   $0x4,%r14b
  7c4184:	74 3a                	je     7c41c0 <instruction_is_valid+0x690>
  7c4186:	eb 0d                	jmp    7c4195 <instruction_is_valid+0x665>
  7c4188:	31 f6                	xor    %esi,%esi
  7c418a:	44 0f b6 57 0f       	movzbl 0xf(%rdi),%r10d
  7c418f:	41 f6 c6 04          	test   $0x4,%r14b
  7c4193:	74 2b                	je     7c41c0 <instruction_is_valid+0x690>
  7c4195:	0f b6 43 1b          	movzbl 0x1b(%rbx),%eax
  7c4199:	24 fb                	and    $0xfb,%al
  7c419b:	3c 02                	cmp    $0x2,%al
  7c419d:	41 0f 94 c4          	sete   %r12b
  7c41a1:	40 84 f6             	test   %sil,%sil
  7c41a4:	75 26                	jne    7c41cc <instruction_is_valid+0x69c>
  7c41a6:	e9 62 01 00 00       	jmp    7c430d <instruction_is_valid+0x7dd>
  7c41ab:	3c 06                	cmp    $0x6,%al
  7c41ad:	0f 92 c0             	setb   %al
  7c41b0:	40 20 f0             	and    %sil,%al
  7c41b3:	89 c6                	mov    %eax,%esi
  7c41b5:	44 0f b6 57 0f       	movzbl 0xf(%rdi),%r10d
  7c41ba:	41 f6 c6 04          	test   $0x4,%r14b
  7c41be:	75 d5                	jne    7c4195 <instruction_is_valid+0x665>
  7c41c0:	45 31 e4             	xor    %r12d,%r12d
  7c41c3:	40 84 f6             	test   %sil,%sil
  7c41c6:	0f 84 44 01 00 00    	je     7c4310 <instruction_is_valid+0x7e0>
  7c41cc:	44 88 7c 24 0b       	mov    %r15b,0xb(%rsp)
  7c41d1:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  7c41d6:	89 6c 24 0c          	mov    %ebp,0xc(%rsp)
  7c41da:	44 89 f5             	mov    %r14d,%ebp
  7c41dd:	49 89 fd             	mov    %rdi,%r13
  7c41e0:	48 89 df             	mov    %rbx,%rdi
  7c41e3:	45 0f b6 f2          	movzbl %r10b,%r14d
  7c41e7:	45 89 d7             	mov    %r10d,%r15d
  7c41ea:	e8 71 06 00 00       	call   7c4860 <x86_template_checks>
  7c41ef:	c1 e8 18             	shr    $0x18,%eax
  7c41f2:	44 85 f0             	test   %r14d,%eax
  7c41f5:	74 22                	je     7c4219 <instruction_is_valid+0x6e9>
  7c41f7:	0f b6 44 24 0b       	movzbl 0xb(%rsp),%eax
  7c41fc:	4c 89 ef             	mov    %r13,%rdi
  7c41ff:	41 89 ee             	mov    %ebp,%r14d
  7c4202:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  7c4206:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  7c420b:	45 89 fa             	mov    %r15d,%r10d
  7c420e:	45 31 e4             	xor    %r12d,%r12d
  7c4211:	41 89 c7             	mov    %eax,%r15d
  7c4214:	e9 f7 00 00 00       	jmp    7c4310 <instruction_is_valid+0x7e0>
  7c4219:	41 f6 c7 07          	test   $0x7,%r15b
  7c421d:	45 89 fa             	mov    %r15d,%r10d
  7c4220:	41 89 ee             	mov    %ebp,%r14d
  7c4223:	0f 94 c0             	sete   %al
  7c4226:	45 84 ff             	test   %r15b,%r15b
  7c4229:	79 1c                	jns    7c4247 <instruction_is_valid+0x717>
  7c422b:	44 08 e0             	or     %r12b,%al
  7c422e:	74 17                	je     7c4247 <instruction_is_valid+0x717>
  7c4230:	4c 89 ef             	mov    %r13,%rdi
  7c4233:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  7c4237:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  7c423c:	44 0f b6 7c 24 0b    	movzbl 0xb(%rsp),%r15d
  7c4242:	e9 c6 00 00 00       	jmp    7c430d <instruction_is_valid+0x7dd>
  7c4247:	4c 89 ef             	mov    %r13,%rdi
  7c424a:	8b 43 08             	mov    0x8(%rbx),%eax
  7c424d:	0f b6 4b 10          	movzbl 0x10(%rbx),%ecx
  7c4251:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  7c4255:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  7c425a:	44 0f b6 7c 24 0b    	movzbl 0xb(%rsp),%r15d
  7c4260:	85 c9                	test   %ecx,%ecx
  7c4262:	0f 84 1a 03 00 00    	je     7c4582 <instruction_is_valid+0xa52>
  7c4268:	83 f9 02             	cmp    $0x2,%ecx
  7c426b:	0f 85 11 03 00 00    	jne    7c4582 <instruction_is_valid+0xa52>
  7c4271:	8d 14 cd 00 00 00 00 	lea    0x0(,%rcx,8),%edx
  7c4278:	80 c2 f8             	add    $0xf8,%dl
  7c427b:	c4 e2 6b f7 d0       	shrx   %edx,%eax,%edx
  7c4280:	80 fa 0f             	cmp    $0xf,%dl
  7c4283:	0f 84 f9 02 00 00    	je     7c4582 <instruction_is_valid+0xa52>
  7c4289:	0f b6 73 1c          	movzbl 0x1c(%rbx),%esi
  7c428d:	40 80 fe 02          	cmp    $0x2,%sil
  7c4291:	75 0d                	jne    7c42a0 <instruction_is_valid+0x770>
  7c4293:	41 89 d0             	mov    %edx,%r8d
  7c4296:	41 80 e0 fc          	and    $0xfc,%r8b
  7c429a:	41 80 f8 04          	cmp    $0x4,%r8b
  7c429e:	74 0a                	je     7c42aa <instruction_is_valid+0x77a>
  7c42a0:	40 80 fe 01          	cmp    $0x1,%sil
  7c42a4:	0f 85 d8 02 00 00    	jne    7c4582 <instruction_is_valid+0xa52>
  7c42aa:	80 fa 06             	cmp    $0x6,%dl
  7c42ad:	0f 85 cf 02 00 00    	jne    7c4582 <instruction_is_valid+0xa52>
  7c42b3:	89 c2                	mov    %eax,%edx
  7c42b5:	83 e2 7e             	and    $0x7e,%edx
  7c42b8:	83 fa 56             	cmp    $0x56,%edx
  7c42bb:	0f 85 c1 02 00 00    	jne    7c4582 <instruction_is_valid+0xa52>
  7c42c1:	8b 53 0c             	mov    0xc(%rbx),%edx
  7c42c4:	83 e2 fe             	and    $0xfffffffe,%edx
  7c42c7:	81 fa f2 00 00 00    	cmp    $0xf2,%edx
  7c42cd:	0f 85 af 02 00 00    	jne    7c4582 <instruction_is_valid+0xa52>
  7c42d3:	0f b6 57 08          	movzbl 0x8(%rdi),%edx
  7c42d7:	0f b6 77 0e          	movzbl 0xe(%rdi),%esi
  7c42db:	45 89 f0             	mov    %r14d,%r8d
  7c42de:	41 83 e0 04          	and    $0x4,%r8d
  7c42e2:	41 c1 e8 02          	shr    $0x2,%r8d
  7c42e6:	40 38 f2             	cmp    %sil,%dl
  7c42e9:	41 0f 94 c1          	sete   %r9b
  7c42ed:	45 08 c1             	or     %r8b,%r9b
  7c42f0:	0f 84 83 02 00 00    	je     7c4579 <instruction_is_valid+0xa49>
  7c42f6:	40 38 f2             	cmp    %sil,%dl
  7c42f9:	74 12                	je     7c430d <instruction_is_valid+0x7dd>
  7c42fb:	e9 82 02 00 00       	jmp    7c4582 <instruction_is_valid+0xa52>
  7c4300:	84 c0                	test   %al,%al
  7c4302:	0f 84 5a fd ff ff    	je     7c4062 <instruction_is_valid+0x532>
  7c4308:	44 0f b6 57 0f       	movzbl 0xf(%rdi),%r10d
  7c430d:	45 31 e4             	xor    %r12d,%r12d
  7c4310:	40 f6 c5 40          	test   $0x40,%bpl
  7c4314:	0f 94 c0             	sete   %al
  7c4317:	41 80 ff 01          	cmp    $0x1,%r15b
  7c431b:	0f 95 c1             	setne  %cl
  7c431e:	08 c1                	or     %al,%cl
  7c4320:	75 17                	jne    7c4339 <instruction_is_valid+0x809>
  7c4322:	80 7b 1b 02          	cmpb   $0x2,0x1b(%rbx)
  7c4326:	41 0f 95 c0          	setne  %r8b
  7c432a:	0f b6 57 08          	movzbl 0x8(%rdi),%edx
  7c432e:	0f b6 77 0a          	movzbl 0xa(%rdi),%esi
  7c4332:	40 38 f2             	cmp    %sil,%dl
  7c4335:	75 12                	jne    7c4349 <instruction_is_valid+0x819>
  7c4337:	eb 28                	jmp    7c4361 <instruction_is_valid+0x831>
  7c4339:	45 31 c0             	xor    %r8d,%r8d
  7c433c:	0f b6 57 08          	movzbl 0x8(%rdi),%edx
  7c4340:	0f b6 77 0a          	movzbl 0xa(%rdi),%esi
  7c4344:	40 38 f2             	cmp    %sil,%dl
  7c4347:	74 18                	je     7c4361 <instruction_is_valid+0x831>
  7c4349:	66 83 7b 1e 00       	cmpw   $0x0,0x1e(%rbx)
  7c434e:	74 72                	je     7c43c2 <instruction_is_valid+0x892>
  7c4350:	0f b6 47 0e          	movzbl 0xe(%rdi),%eax
  7c4354:	38 d0                	cmp    %dl,%al
  7c4356:	74 09                	je     7c4361 <instruction_is_valid+0x831>
  7c4358:	40 38 f0             	cmp    %sil,%al
  7c435b:	0f 94 c0             	sete   %al
  7c435e:	41 20 c0             	and    %al,%r8b
  7c4361:	b8 00 00 00 00       	mov    $0x0,%eax
  7c4366:	31 c9                	xor    %ecx,%ecx
  7c4368:	45 84 e4             	test   %r12b,%r12b
  7c436b:	74 75                	je     7c43e2 <instruction_is_valid+0x8b2>
  7c436d:	40 f6 c5 40          	test   $0x40,%bpl
  7c4371:	74 46                	je     7c43b9 <instruction_is_valid+0x889>
  7c4373:	80 7b 1c 02          	cmpb   $0x2,0x1c(%rbx)
  7c4377:	75 40                	jne    7c43b9 <instruction_is_valid+0x889>
  7c4379:	41 f6 c2 07          	test   $0x7,%r10b
  7c437d:	0f 94 c0             	sete   %al
  7c4380:	44 08 c0             	or     %r8b,%al
  7c4383:	a8 01                	test   $0x1,%al
  7c4385:	75 37                	jne    7c43be <instruction_is_valid+0x88e>
  7c4387:	80 7b 10 01          	cmpb   $0x1,0x10(%rbx)
  7c438b:	75 46                	jne    7c43d3 <instruction_is_valid+0x8a3>
  7c438d:	b8 8e 00 00 00       	mov    $0x8e,%eax
  7c4392:	33 43 08             	xor    0x8(%rbx),%eax
  7c4395:	41 89 d0             	mov    %edx,%r8d
  7c4398:	41 83 f0 01          	xor    $0x1,%r8d
  7c439c:	41 09 c0             	or     %eax,%r8d
  7c439f:	0f 95 c0             	setne  %al
  7c43a2:	41 0f 94 c0          	sete   %r8b
  7c43a6:	41 81 fd a0 20 00 00 	cmp    $0x20a0,%r13d
  7c43ad:	72 33                	jb     7c43e2 <instruction_is_valid+0x8b2>
  7c43af:	45 84 c0             	test   %r8b,%r8b
  7c43b2:	75 2e                	jne    7c43e2 <instruction_is_valid+0x8b2>
  7c43b4:	e9 c7 02 00 00       	jmp    7c4680 <instruction_is_valid+0xb50>
  7c43b9:	45 84 c0             	test   %r8b,%r8b
  7c43bc:	74 c9                	je     7c4387 <instruction_is_valid+0x857>
  7c43be:	31 c0                	xor    %eax,%eax
  7c43c0:	eb 20                	jmp    7c43e2 <instruction_is_valid+0x8b2>
  7c43c2:	45 31 c0             	xor    %r8d,%r8d
  7c43c5:	b8 00 00 00 00       	mov    $0x0,%eax
  7c43ca:	31 c9                	xor    %ecx,%ecx
  7c43cc:	45 84 e4             	test   %r12b,%r12b
  7c43cf:	75 9c                	jne    7c436d <instruction_is_valid+0x83d>
  7c43d1:	eb 0f                	jmp    7c43e2 <instruction_is_valid+0x8b2>
  7c43d3:	b0 01                	mov    $0x1,%al
  7c43d5:	41 81 fd a0 20 00 00 	cmp    $0x20a0,%r13d
  7c43dc:	0f 83 9e 02 00 00    	jae    7c4680 <instruction_is_valid+0xb50>
  7c43e2:	41 f6 c6 04          	test   $0x4,%r14b
  7c43e6:	75 04                	jne    7c43ec <instruction_is_valid+0x8bc>
  7c43e8:	0f b6 4f 09          	movzbl 0x9(%rdi),%ecx
  7c43ec:	09 d1                	or     %edx,%ecx
  7c43ee:	41 89 c8             	mov    %ecx,%r8d
  7c43f1:	41 83 e0 40          	and    $0x40,%r8d
  7c43f5:	41 c1 e8 06          	shr    $0x6,%r8d
  7c43f9:	80 7b 14 00          	cmpb   $0x0,0x14(%rbx)
  7c43fd:	75 5b                	jne    7c445a <instruction_is_valid+0x92a>
  7c43ff:	44 0f b6 4f 09       	movzbl 0x9(%rdi),%r9d
  7c4404:	40 08 d6             	or     %dl,%sil
  7c4407:	44 08 ce             	or     %r9b,%sil
  7c440a:	40 f6 c6 08          	test   $0x8,%sil
  7c440e:	75 4a                	jne    7c445a <instruction_is_valid+0x92a>
  7c4410:	80 e2 fc             	and    $0xfc,%dl
  7c4413:	80 fa 04             	cmp    $0x4,%dl
  7c4416:	75 0d                	jne    7c4425 <instruction_is_valid+0x8f5>
  7c4418:	0f b7 53 16          	movzwl 0x16(%rbx),%edx
  7c441c:	83 e2 0f             	and    $0xf,%edx
  7c441f:	66 83 fa 01          	cmp    $0x1,%dx
  7c4423:	74 35                	je     7c445a <instruction_is_valid+0x92a>
  7c4425:	83 e5 0f             	and    $0xf,%ebp
  7c4428:	44 89 f6             	mov    %r14d,%esi
  7c442b:	66 83 fd 01          	cmp    $0x1,%bp
  7c442f:	0f 95 c2             	setne  %dl
  7c4432:	83 e6 04             	and    $0x4,%esi
  7c4435:	c1 ee 02             	shr    $0x2,%esi
  7c4438:	40 08 d6             	or     %dl,%sil
  7c443b:	41 80 f9 04          	cmp    $0x4,%r9b
  7c443f:	0f 92 c2             	setb   %dl
  7c4442:	40 08 f2             	or     %sil,%dl
  7c4445:	74 05                	je     7c444c <instruction_is_valid+0x91c>
  7c4447:	45 31 c0             	xor    %r8d,%r8d
  7c444a:	eb 0e                	jmp    7c445a <instruction_is_valid+0x92a>
  7c444c:	c0 e9 06             	shr    $0x6,%cl
  7c444f:	41 80 f9 08          	cmp    $0x8,%r9b
  7c4453:	41 0f 92 c0          	setb   %r8b
  7c4457:	41 20 c8             	and    %cl,%r8b
  7c445a:	48 63 17             	movslq (%rdi),%rdx
  7c445d:	0f b6 4b 12          	movzbl 0x12(%rbx),%ecx
  7c4461:	41 80 f0 01          	xor    $0x1,%r8b
  7c4465:	44 20 c0             	and    %r8b,%al
  7c4468:	48 83 f9 03          	cmp    $0x3,%rcx
  7c446c:	77 42                	ja     7c44b0 <instruction_is_valid+0x980>
  7c446e:	48 8d 35 8b 78 c4 ff 	lea    -0x3b8775(%rip),%rsi        # 40bd00 <__abi_tag+0xb144>
  7c4475:	4c 63 04 8e          	movslq (%rsi,%rcx,4),%r8
  7c4479:	49 01 f0             	add    %rsi,%r8
  7c447c:	41 ff e0             	jmp    *%r8
  7c447f:	85 d2                	test   %edx,%edx
  7c4481:	40 0f 94 c6          	sete   %sil
  7c4485:	eb 26                	jmp    7c44ad <instruction_is_valid+0x97d>
  7c4487:	8d b2 00 80 00 00    	lea    0x8000(%rdx),%esi
  7c448d:	81 fe 00 80 01 00    	cmp    $0x18000,%esi
  7c4493:	eb 14                	jmp    7c44a9 <instruction_is_valid+0x979>
  7c4495:	81 fa 00 00 00 01    	cmp    $0x1000000,%edx
  7c449b:	eb 0c                	jmp    7c44a9 <instruction_is_valid+0x979>
  7c449d:	8d b2 80 00 00 00    	lea    0x80(%rdx),%esi
  7c44a3:	81 fe 80 01 00 00    	cmp    $0x180,%esi
  7c44a9:	40 0f 92 c6          	setb   %sil
  7c44ad:	40 20 f0             	and    %sil,%al
  7c44b0:	0f b6 73 1b          	movzbl 0x1b(%rbx),%esi
  7c44b4:	44 8d 46 e2          	lea    -0x1e(%rsi),%r8d
  7c44b8:	41 80 f8 03          	cmp    $0x3,%r8b
  7c44bc:	77 22                	ja     7c44e0 <instruction_is_valid+0x9b0>
  7c44be:	40 80 e6 3e          	and    $0x3e,%sil
  7c44c2:	49 c7 c1 00 ff ff ff 	mov    $0xffffffffffffff00,%r9
  7c44c9:	49 c7 c0 0f ff ff ff 	mov    $0xffffffffffffff0f,%r8
  7c44d0:	40 80 fe 20          	cmp    $0x20,%sil
  7c44d4:	4d 0f 44 c1          	cmove  %r9,%r8
  7c44d8:	49 85 d0             	test   %rdx,%r8
  7c44db:	0f 94 c2             	sete   %dl
  7c44de:	20 d0                	and    %dl,%al
  7c44e0:	8b 57 04             	mov    0x4(%rdi),%edx
  7c44e3:	0f b6 73 13          	movzbl 0x13(%rbx),%esi
  7c44e7:	83 fe 02             	cmp    $0x2,%esi
  7c44ea:	74 0a                	je     7c44f6 <instruction_is_valid+0x9c6>
  7c44ec:	83 fe 01             	cmp    $0x1,%esi
  7c44ef:	75 20                	jne    7c4511 <instruction_is_valid+0x9e1>
  7c44f1:	0f be ca             	movsbl %dl,%ecx
  7c44f4:	eb 03                	jmp    7c44f9 <instruction_is_valid+0x9c9>
  7c44f6:	0f bf ca             	movswl %dx,%ecx
  7c44f9:	39 d1                	cmp    %edx,%ecx
  7c44fb:	0f 94 c1             	sete   %cl
  7c44fe:	20 c8                	and    %cl,%al
  7c4500:	48 83 c4 18          	add    $0x18,%rsp
  7c4504:	5b                   	pop    %rbx
  7c4505:	41 5c                	pop    %r12
  7c4507:	41 5d                	pop    %r13
  7c4509:	41 5e                	pop    %r14
  7c450b:	41 5f                	pop    %r15
  7c450d:	5d                   	pop    %rbp
  7c450e:	24 01                	and    $0x1,%al
  7c4510:	c3                   	ret
  7c4511:	80 f9 06             	cmp    $0x6,%cl
  7c4514:	75 11                	jne    7c4527 <instruction_is_valid+0x9f7>
  7c4516:	81 c2 00 80 00 00    	add    $0x8000,%edx
  7c451c:	81 fa 00 80 01 00    	cmp    $0x18000,%edx
  7c4522:	0f 92 c1             	setb   %cl
  7c4525:	eb d7                	jmp    7c44fe <instruction_is_valid+0x9ce>
  7c4527:	41 83 e6 04          	and    $0x4,%r14d
  7c452b:	41 c1 ee 02          	shr    $0x2,%r14d
  7c452f:	40 84 f6             	test   %sil,%sil
  7c4532:	40 0f 95 c6          	setne  %sil
  7c4536:	80 f9 05             	cmp    $0x5,%cl
  7c4539:	0f 93 c1             	setae  %cl
  7c453c:	44 08 f6             	or     %r14b,%sil
  7c453f:	40 08 ce             	or     %cl,%sil
  7c4542:	75 bc                	jne    7c4500 <instruction_is_valid+0x9d0>
  7c4544:	85 d2                	test   %edx,%edx
  7c4546:	eb b3                	jmp    7c44fb <instruction_is_valid+0x9cb>
  7c4548:	84 c9                	test   %cl,%cl
  7c454a:	0f 85 b8 fd ff ff    	jne    7c4308 <instruction_is_valid+0x7d8>
  7c4550:	e9 0d fb ff ff       	jmp    7c4062 <instruction_is_valid+0x532>
  7c4555:	44 0f b6 57 0f       	movzbl 0xf(%rdi),%r10d
  7c455a:	41 f6 c6 04          	test   $0x4,%r14b
  7c455e:	74 11                	je     7c4571 <instruction_is_valid+0xa41>
  7c4560:	0f b6 43 1b          	movzbl 0x1b(%rbx),%eax
  7c4564:	24 fb                	and    $0xfb,%al
  7c4566:	3c 02                	cmp    $0x2,%al
  7c4568:	41 0f 94 c4          	sete   %r12b
  7c456c:	e9 5b fc ff ff       	jmp    7c41cc <instruction_is_valid+0x69c>
  7c4571:	45 31 e4             	xor    %r12d,%r12d
  7c4574:	e9 53 fc ff ff       	jmp    7c41cc <instruction_is_valid+0x69c>
  7c4579:	3a 57 09             	cmp    0x9(%rdi),%dl
  7c457c:	0f 84 8b fd ff ff    	je     7c430d <instruction_is_valid+0x7dd>
  7c4582:	66 83 7b 16 1f       	cmpw   $0x1f,0x16(%rbx)
  7c4587:	b2 01                	mov    $0x1,%dl
  7c4589:	75 3a                	jne    7c45c5 <instruction_is_valid+0xa95>
  7c458b:	0f b7 73 1e          	movzwl 0x1e(%rbx),%esi
  7c458f:	41 89 e8             	mov    %ebp,%r8d
  7c4592:	41 83 f0 1f          	xor    $0x1f,%r8d
  7c4596:	83 f6 1f             	xor    $0x1f,%esi
  7c4599:	66 41 09 f0          	or     %si,%r8w
  7c459d:	75 26                	jne    7c45c5 <instruction_is_valid+0xa95>
  7c459f:	0f b6 77 08          	movzbl 0x8(%rdi),%esi
  7c45a3:	0f b6 57 0e          	movzbl 0xe(%rdi),%edx
  7c45a7:	40 38 d6             	cmp    %dl,%sil
  7c45aa:	0f 84 5d fd ff ff    	je     7c430d <instruction_is_valid+0x7dd>
  7c45b0:	44 0f b6 47 09       	movzbl 0x9(%rdi),%r8d
  7c45b5:	44 38 c6             	cmp    %r8b,%sil
  7c45b8:	40 0f 95 c6          	setne  %sil
  7c45bc:	44 38 c2             	cmp    %r8b,%dl
  7c45bf:	0f 95 c2             	setne  %dl
  7c45c2:	40 20 f2             	and    %sil,%dl
  7c45c5:	0f b6 73 1c          	movzbl 0x1c(%rbx),%esi
  7c45c9:	40 80 fe 02          	cmp    $0x2,%sil
  7c45cd:	75 53                	jne    7c4622 <instruction_is_valid+0xaf2>
  7c45cf:	84 d2                	test   %dl,%dl
  7c45d1:	0f 84 36 fd ff ff    	je     7c430d <instruction_is_valid+0x7dd>
  7c45d7:	3d ff 04 00 00       	cmp    $0x4ff,%eax
  7c45dc:	0f 94 c1             	sete   %cl
  7c45df:	41 80 ff 0e          	cmp    $0xe,%r15b
  7c45e3:	0f 94 c2             	sete   %dl
  7c45e6:	3d 8f 04 00 00       	cmp    $0x48f,%eax
  7c45eb:	74 04                	je     7c45f1 <instruction_is_valid+0xac1>
  7c45ed:	20 ca                	and    %cl,%dl
  7c45ef:	74 66                	je     7c4657 <instruction_is_valid+0xb27>
  7c45f1:	0f b6 4f 0e          	movzbl 0xe(%rdi),%ecx
  7c45f5:	80 f9 04             	cmp    $0x4,%cl
  7c45f8:	0f 84 0f fd ff ff    	je     7c430d <instruction_is_valid+0x7dd>
  7c45fe:	0f b6 57 09          	movzbl 0x9(%rdi),%edx
  7c4602:	80 fa 04             	cmp    $0x4,%dl
  7c4605:	0f 84 02 fd ff ff    	je     7c430d <instruction_is_valid+0x7dd>
  7c460b:	3d 8f 04 00 00       	cmp    $0x48f,%eax
  7c4610:	0f 95 c0             	setne  %al
  7c4613:	38 d1                	cmp    %dl,%cl
  7c4615:	0f 95 c1             	setne  %cl
  7c4618:	08 c1                	or     %al,%cl
  7c461a:	0f 84 ed fc ff ff    	je     7c430d <instruction_is_valid+0x7dd>
  7c4620:	eb 35                	jmp    7c4657 <instruction_is_valid+0xb27>
  7c4622:	84 d2                	test   %dl,%dl
  7c4624:	0f 84 e3 fc ff ff    	je     7c430d <instruction_is_valid+0x7dd>
  7c462a:	80 f1 03             	xor    $0x3,%cl
  7c462d:	40 08 f1             	or     %sil,%cl
  7c4630:	75 25                	jne    7c4657 <instruction_is_valid+0xb27>
  7c4632:	89 c1                	mov    %eax,%ecx
  7c4634:	81 e1 00 ff ff ff    	and    $0xffffff00,%ecx
  7c463a:	41 b4 01             	mov    $0x1,%r12b
  7c463d:	81 f9 00 0f 0f 00    	cmp    $0xf0f00,%ecx
  7c4643:	0f 85 c7 fc ff ff    	jne    7c4310 <instruction_is_valid+0x7e0>
  7c4649:	0f b6 c0             	movzbl %al,%eax
  7c464c:	39 07                	cmp    %eax,(%rdi)
  7c464e:	41 0f 94 c4          	sete   %r12b
  7c4652:	e9 b9 fc ff ff       	jmp    7c4310 <instruction_is_valid+0x7e0>
  7c4657:	41 b4 01             	mov    $0x1,%r12b
  7c465a:	e9 b1 fc ff ff       	jmp    7c4310 <instruction_is_valid+0x7e0>
  7c465f:	66 ba fc 00          	mov    $0xfc,%dx
  7c4663:	e9 fd f8 ff ff       	jmp    7c3f65 <instruction_is_valid+0x435>
  7c4668:	44 89 ea             	mov    %r13d,%edx
  7c466b:	41 8d 8d 60 df ff ff 	lea    -0x20a0(%r13),%ecx
  7c4672:	81 ea 40 41 00 00    	sub    $0x4140,%edx
  7c4678:	0f 42 d1             	cmovb  %ecx,%edx
  7c467b:	e9 f0 f4 ff ff       	jmp    7c3b70 <instruction_is_valid+0x40>
  7c4680:	80 7b 1c 00          	cmpb   $0x0,0x1c(%rbx)
  7c4684:	b0 01                	mov    $0x1,%al
  7c4686:	41 89 eb             	mov    %ebp,%r11d
  7c4689:	45 89 f2             	mov    %r14d,%r10d
  7c468c:	49 89 f8             	mov    %rdi,%r8
  7c468f:	49 89 df             	mov    %rbx,%r15
  7c4692:	75 2e                	jne    7c46c2 <instruction_is_valid+0xb92>
  7c4694:	45 8b 4f 0c          	mov    0xc(%r15),%r9d
  7c4698:	4c 89 fb             	mov    %r15,%rbx
  7c469b:	4c 89 c7             	mov    %r8,%rdi
  7c469e:	45 89 d6             	mov    %r10d,%r14d
  7c46a1:	44 89 dd             	mov    %r11d,%ebp
  7c46a4:	45 85 c9             	test   %r9d,%r9d
  7c46a7:	0f 84 35 fd ff ff    	je     7c43e2 <instruction_is_valid+0x8b2>
  7c46ad:	31 c0                	xor    %eax,%eax
  7c46af:	41 80 f9 3e          	cmp    $0x3e,%r9b
  7c46b3:	40 0f 94 c7          	sete   %dil
  7c46b7:	40 08 f8             	or     %dil,%al
  7c46ba:	41 c1 e9 08          	shr    $0x8,%r9d
  7c46be:	75 ef                	jne    7c46af <instruction_is_valid+0xb7f>
  7c46c0:	34 01                	xor    $0x1,%al
  7c46c2:	4c 89 c7             	mov    %r8,%rdi
  7c46c5:	45 89 d6             	mov    %r10d,%r14d
  7c46c8:	44 89 dd             	mov    %r11d,%ebp
  7c46cb:	4c 89 fb             	mov    %r15,%rbx
  7c46ce:	e9 0f fd ff ff       	jmp    7c43e2 <instruction_is_valid+0x8b2>
