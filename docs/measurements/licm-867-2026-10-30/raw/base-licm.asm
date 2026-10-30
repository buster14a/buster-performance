
/home/david/buster-fast-bench/codex-pr915-20261030/base/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000ff3cc0 <ir_optimize_licm>:
  ff3cc0:	55                   	push   %rbp
  ff3cc1:	48 89 e5             	mov    %rsp,%rbp
  ff3cc4:	41 57                	push   %r15
  ff3cc6:	41 56                	push   %r14
  ff3cc8:	41 55                	push   %r13
  ff3cca:	41 54                	push   %r12
  ff3ccc:	53                   	push   %rbx
  ff3ccd:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
  ff3cd1:	48 81 ec 40 0b 00 00 	sub    $0xb40,%rsp
  ff3cd8:	48 8b 46 08          	mov    0x8(%rsi),%rax
  ff3cdc:	4c 8b 72 08          	mov    0x8(%rdx),%r14
  ff3ce0:	48 89 d3             	mov    %rdx,%rbx
  ff3ce3:	49 89 fc             	mov    %rdi,%r12
  ff3ce6:	48 8d bc 24 98 02 00 00 	lea    0x298(%rsp),%rdi
  ff3cee:	ba 28 05 00 00       	mov    $0x528,%edx
  ff3cf3:	49 89 cf             	mov    %rcx,%r15
  ff3cf6:	49 89 f5             	mov    %rsi,%r13
  ff3cf9:	31 f6                	xor    %esi,%esi
  ff3cfb:	4c 89 84 24 f0 00 00 00 	mov    %r8,0xf0(%rsp)
  ff3d03:	48 89 8c 24 b8 00 00 00 	mov    %rcx,0xb8(%rsp)
  ff3d0b:	49 c1 ef 20          	shr    $0x20,%r15
  ff3d0f:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
  ff3d17:	e8 84 5d 90 ff       	call   8f9aa0 <memset@plt>
  ff3d1c:	4c 89 7c 24 70       	mov    %r15,0x70(%rsp)
  ff3d21:	49 39 dd             	cmp    %rbx,%r13
  ff3d24:	74 32                	je     ff3d58 <ir_optimize_licm+0x98>
  ff3d26:	48 8d bc 24 98 02 00 00 	lea    0x298(%rsp),%rdi
  ff3d2e:	4c 89 e6             	mov    %r12,%rsi
  ff3d31:	4c 89 ea             	mov    %r13,%rdx
  ff3d34:	48 89 d9             	mov    %rbx,%rcx
  ff3d37:	45 89 f8             	mov    %r15d,%r8d
  ff3d3a:	e8 81 03 01 00       	call   10040c0 <ir_optimize_prepare>
  ff3d3f:	49 89 c1             	mov    %rax,%r9
  ff3d42:	48 89 94 24 d8 00 00 00 	mov    %rdx,0xd8(%rsp)
  ff3d4a:	45 89 cf             	mov    %r9d,%r15d
  ff3d4d:	45 85 c9             	test   %r9d,%r9d
  ff3d50:	0f 85 b1 04 00 00    	jne    ff4207 <ir_optimize_licm+0x547>
  ff3d56:	eb 22                	jmp    ff3d7a <ir_optimize_licm+0xba>
  ff3d58:	48 c7 84 24 d8 00 00 00 00 00 00 00 	movq   $0x0,0xd8(%rsp)
  ff3d64:	49 b9 07 00 00 00 ff ff ff ff 	movabs $0xffffffff00000007,%r9
  ff3d6e:	45 89 cf             	mov    %r9d,%r15d
  ff3d71:	45 85 c9             	test   %r9d,%r9d
  ff3d74:	0f 85 8d 04 00 00    	jne    ff4207 <ir_optimize_licm+0x547>
  ff3d7a:	48 8b 84 24 a0 02 00 00 	mov    0x2a0(%rsp),%rax
  ff3d82:	c5 fe 6f 84 24 a8 02 00 00 	vmovdqu 0x2a8(%rsp),%ymm0
  ff3d8b:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  ff3d90:	4c 89 4c 24 20       	mov    %r9,0x20(%rsp)
  ff3d95:	4c 8d 8c 24 70 05 00 00 	lea    0x570(%rsp),%r9
  ff3d9d:	48 8d 94 24 c0 07 00 00 	lea    0x7c0(%rsp),%rdx
  ff3da5:	41 b8 00 00 00 04    	mov    $0x4000000,%r8d
  ff3dab:	48 89 df             	mov    %rbx,%rdi
  ff3dae:	4c 89 ee             	mov    %r13,%rsi
  ff3db1:	48 89 84 24 c0 07 00 00 	mov    %rax,0x7c0(%rsp)
  ff3db9:	41 83 7c 24 48 01    	cmpl   $0x1,0x48(%r12)
  ff3dbf:	19 c0                	sbb    %eax,%eax
  ff3dc1:	89 84 24 c8 07 00 00 	mov    %eax,0x7c8(%rsp)
  ff3dc8:	48 b8 00 00 00 00 02 00 00 00 	movabs $0x200000000,%rax
  ff3dd2:	c7 84 24 cc 07 00 00 00 00 00 00 	movl   $0x0,0x7cc(%rsp)
  ff3ddd:	c5 fe 7f 84 24 d0 07 00 00 	vmovdqu %ymm0,0x7d0(%rsp)
  ff3de6:	48 8d 0c 48          	lea    (%rax,%rcx,2),%rcx
  ff3dea:	c5 f8 77             	vzeroupper
  ff3ded:	e8 ee 14 e5 ff       	call   e452e0 <dominators_analyze>
  ff3df2:	31 c9                	xor    %ecx,%ecx
  ff3df4:	83 f8 02             	cmp    $0x2,%eax
  ff3df7:	0f 95 c2             	setne  %dl
  ff3dfa:	85 c0                	test   %eax,%eax
  ff3dfc:	74 14                	je     ff3e12 <ir_optimize_licm+0x152>
  ff3dfe:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff3e03:	88 d1                	mov    %dl,%cl
  ff3e05:	44 8d 3c cd 02 00 00 00 	lea    0x2(,%rcx,8),%r15d
  ff3e0d:	e9 f5 03 00 00       	jmp    ff4207 <ir_optimize_licm+0x547>
  ff3e12:	45 8b 7c 24 38       	mov    0x38(%r12),%r15d
  ff3e17:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
  ff3e1c:	4c 89 b4 24 98 00 00 00 	mov    %r14,0x98(%rsp)
  ff3e24:	4d 85 ff             	test   %r15,%r15
  ff3e27:	0f 84 dc 00 00 00    	je     ff3f09 <ir_optimize_licm+0x249>
  ff3e2d:	48 8b 0b             	mov    (%rbx),%rcx
  ff3e30:	48 8b 43 08          	mov    0x8(%rbx),%rax
  ff3e34:	4c 8d 64 08 3f       	lea    0x3f(%rax,%rcx,1),%r12
  ff3e39:	48 01 c8             	add    %rcx,%rax
  ff3e3c:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff3e40:	49 39 c4             	cmp    %rax,%r12
  ff3e43:	0f 82 c0 00 00 00    	jb     ff3f09 <ir_optimize_licm+0x249>
  ff3e49:	4c 89 e0             	mov    %r12,%rax
  ff3e4c:	48 29 c8             	sub    %rcx,%rax
  ff3e4f:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  ff3e53:	4e 8d 34 bd 00 00 00 00 	lea    0x0(,%r15,4),%r14
  ff3e5b:	48 29 c1             	sub    %rax,%rcx
  ff3e5e:	0f 92 c2             	setb   %dl
  ff3e61:	49 39 ce             	cmp    %rcx,%r14
  ff3e64:	0f 97 c1             	seta   %cl
  ff3e67:	08 d1                	or     %dl,%cl
  ff3e69:	0f 85 9a 00 00 00    	jne    ff3f09 <ir_optimize_licm+0x249>
  ff3e6f:	4c 01 f0             	add    %r14,%rax
  ff3e72:	48 89 43 08          	mov    %rax,0x8(%rbx)
  ff3e76:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  ff3e7a:	48 39 c8             	cmp    %rcx,%rax
  ff3e7d:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff3e81:	48 89 43 20          	mov    %rax,0x20(%rbx)
  ff3e85:	4d 85 e4             	test   %r12,%r12
  ff3e88:	74 7f                	je     ff3f09 <ir_optimize_licm+0x249>
  ff3e8a:	4c 89 e7             	mov    %r12,%rdi
  ff3e8d:	31 f6                	xor    %esi,%esi
  ff3e8f:	4c 89 f2             	mov    %r14,%rdx
  ff3e92:	e8 09 5c 90 ff       	call   8f9aa0 <memset@plt>
  ff3e97:	4c 89 a4 24 38 06 00 00 	mov    %r12,0x638(%rsp)
  ff3e9f:	48 8b 0b             	mov    (%rbx),%rcx
  ff3ea2:	48 8b 43 08          	mov    0x8(%rbx),%rax
  ff3ea6:	4c 8d 64 08 3f       	lea    0x3f(%rax,%rcx,1),%r12
  ff3eab:	48 01 c8             	add    %rcx,%rax
  ff3eae:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff3eb2:	49 39 c4             	cmp    %rax,%r12
  ff3eb5:	0f 82 04 03 00 00    	jb     ff41bf <ir_optimize_licm+0x4ff>
  ff3ebb:	4c 89 e0             	mov    %r12,%rax
  ff3ebe:	48 29 c8             	sub    %rcx,%rax
  ff3ec1:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  ff3ec5:	48 29 c1             	sub    %rax,%rcx
  ff3ec8:	0f 92 c2             	setb   %dl
  ff3ecb:	49 39 ce             	cmp    %rcx,%r14
  ff3ece:	0f 97 c1             	seta   %cl
  ff3ed1:	08 d1                	or     %dl,%cl
  ff3ed3:	0f 85 e6 02 00 00    	jne    ff41bf <ir_optimize_licm+0x4ff>
  ff3ed9:	4c 01 f0             	add    %r14,%rax
  ff3edc:	48 89 43 08          	mov    %rax,0x8(%rbx)
  ff3ee0:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  ff3ee4:	48 39 c8             	cmp    %rcx,%rax
  ff3ee7:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff3eeb:	48 89 43 20          	mov    %rax,0x20(%rbx)
  ff3eef:	4d 85 e4             	test   %r12,%r12
  ff3ef2:	0f 84 c7 02 00 00    	je     ff41bf <ir_optimize_licm+0x4ff>
  ff3ef8:	4c 89 e7             	mov    %r12,%rdi
  ff3efb:	31 f6                	xor    %esi,%esi
  ff3efd:	4c 89 f2             	mov    %r14,%rdx
  ff3f00:	e8 9b 5b 90 ff       	call   8f9aa0 <memset@plt>
  ff3f05:	b3 01                	mov    $0x1,%bl
  ff3f07:	eb 15                	jmp    ff3f1e <ir_optimize_licm+0x25e>
  ff3f09:	4d 85 ff             	test   %r15,%r15
  ff3f0c:	48 c7 84 24 38 06 00 00 00 00 00 00 	movq   $0x0,0x638(%rsp)
  ff3f18:	0f 94 c3             	sete   %bl
  ff3f1b:	45 31 e4             	xor    %r12d,%r12d
  ff3f1e:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff3f23:	4d 85 ff             	test   %r15,%r15
  ff3f26:	41 89 de             	mov    %ebx,%r14d
  ff3f29:	4c 89 a4 24 40 06 00 00 	mov    %r12,0x640(%rsp)
  ff3f31:	0f 94 c0             	sete   %al
  ff3f34:	41 80 f6 01          	xor    $0x1,%r14b
  ff3f38:	44 08 f0             	or     %r14b,%al
  ff3f3b:	75 7c                	jne    ff3fb9 <ir_optimize_licm+0x2f9>
  ff3f3d:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  ff3f42:	48 8b 08             	mov    (%rax),%rcx
  ff3f45:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff3f49:	4c 8d 64 08 3f       	lea    0x3f(%rax,%rcx,1),%r12
  ff3f4e:	48 01 c8             	add    %rcx,%rax
  ff3f51:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff3f55:	49 39 c4             	cmp    %rax,%r12
  ff3f58:	0f 82 72 02 00 00    	jb     ff41d0 <ir_optimize_licm+0x510>
  ff3f5e:	4c 89 e0             	mov    %r12,%rax
  ff3f61:	48 29 c8             	sub    %rcx,%rax
  ff3f64:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff3f69:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff3f6d:	48 29 c1             	sub    %rax,%rcx
  ff3f70:	0f 92 c2             	setb   %dl
  ff3f73:	4c 39 f9             	cmp    %r15,%rcx
  ff3f76:	0f 92 c1             	setb   %cl
  ff3f79:	08 d1                	or     %dl,%cl
  ff3f7b:	0f 85 4f 02 00 00    	jne    ff41d0 <ir_optimize_licm+0x510>
  ff3f81:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  ff3f86:	4c 01 f8             	add    %r15,%rax
  ff3f89:	48 89 42 08          	mov    %rax,0x8(%rdx)
  ff3f8d:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  ff3f91:	48 39 c8             	cmp    %rcx,%rax
  ff3f94:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff3f98:	48 89 42 20          	mov    %rax,0x20(%rdx)
  ff3f9c:	4d 85 e4             	test   %r12,%r12
  ff3f9f:	0f 84 2b 02 00 00    	je     ff41d0 <ir_optimize_licm+0x510>
  ff3fa5:	4c 89 e7             	mov    %r12,%rdi
  ff3fa8:	31 f6                	xor    %esi,%esi
  ff3faa:	4c 89 fa             	mov    %r15,%rdx
  ff3fad:	e8 ee 5a 90 ff       	call   8f9aa0 <memset@plt>
  ff3fb2:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff3fb7:	eb 03                	jmp    ff3fbc <ir_optimize_licm+0x2fc>
  ff3fb9:	45 31 e4             	xor    %r12d,%r12d
  ff3fbc:	4d 85 ff             	test   %r15,%r15
  ff3fbf:	4c 89 a4 24 48 06 00 00 	mov    %r12,0x648(%rsp)
  ff3fc7:	0f 94 c0             	sete   %al
  ff3fca:	44 08 f0             	or     %r14b,%al
  ff3fcd:	75 7c                	jne    ff404b <ir_optimize_licm+0x38b>
  ff3fcf:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  ff3fd4:	48 8b 08             	mov    (%rax),%rcx
  ff3fd7:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff3fdb:	4c 8d 64 08 3f       	lea    0x3f(%rax,%rcx,1),%r12
  ff3fe0:	48 01 c8             	add    %rcx,%rax
  ff3fe3:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff3fe7:	49 39 c4             	cmp    %rax,%r12
  ff3fea:	0f 82 ec 01 00 00    	jb     ff41dc <ir_optimize_licm+0x51c>
  ff3ff0:	4c 89 e0             	mov    %r12,%rax
  ff3ff3:	48 29 c8             	sub    %rcx,%rax
  ff3ff6:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff3ffb:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff3fff:	48 29 c1             	sub    %rax,%rcx
  ff4002:	0f 92 c2             	setb   %dl
  ff4005:	4c 39 f9             	cmp    %r15,%rcx
  ff4008:	0f 92 c1             	setb   %cl
  ff400b:	08 d1                	or     %dl,%cl
  ff400d:	0f 85 c9 01 00 00    	jne    ff41dc <ir_optimize_licm+0x51c>
  ff4013:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  ff4018:	4c 01 f8             	add    %r15,%rax
  ff401b:	48 89 42 08          	mov    %rax,0x8(%rdx)
  ff401f:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  ff4023:	48 39 c8             	cmp    %rcx,%rax
  ff4026:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff402a:	48 89 42 20          	mov    %rax,0x20(%rdx)
  ff402e:	4d 85 e4             	test   %r12,%r12
  ff4031:	0f 84 a5 01 00 00    	je     ff41dc <ir_optimize_licm+0x51c>
  ff4037:	4c 89 e7             	mov    %r12,%rdi
  ff403a:	31 f6                	xor    %esi,%esi
  ff403c:	4c 89 fa             	mov    %r15,%rdx
  ff403f:	e8 5c 5a 90 ff       	call   8f9aa0 <memset@plt>
  ff4044:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff4049:	eb 03                	jmp    ff404e <ir_optimize_licm+0x38e>
  ff404b:	45 31 e4             	xor    %r12d,%r12d
  ff404e:	4d 85 ff             	test   %r15,%r15
  ff4051:	4c 89 a4 24 50 06 00 00 	mov    %r12,0x650(%rsp)
  ff4059:	0f 94 c0             	sete   %al
  ff405c:	44 08 f0             	or     %r14b,%al
  ff405f:	0f 85 82 00 00 00    	jne    ff40e7 <ir_optimize_licm+0x427>
  ff4065:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff406a:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
  ff4072:	48 8b 0b             	mov    (%rbx),%rcx
  ff4075:	48 8b 43 08          	mov    0x8(%rbx),%rax
  ff4079:	4c 8d 64 08 3f       	lea    0x3f(%rax,%rcx,1),%r12
  ff407e:	48 01 c8             	add    %rcx,%rax
  ff4081:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff4085:	49 39 c4             	cmp    %rax,%r12
  ff4088:	0f 82 67 01 00 00    	jb     ff41f5 <ir_optimize_licm+0x535>
  ff408e:	4c 89 e0             	mov    %r12,%rax
  ff4091:	48 29 c8             	sub    %rcx,%rax
  ff4094:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  ff4098:	48 29 c1             	sub    %rax,%rcx
  ff409b:	0f 92 c2             	setb   %dl
  ff409e:	4c 39 f9             	cmp    %r15,%rcx
  ff40a1:	0f 92 c1             	setb   %cl
  ff40a4:	08 d1                	or     %dl,%cl
  ff40a6:	0f 85 49 01 00 00    	jne    ff41f5 <ir_optimize_licm+0x535>
  ff40ac:	4c 01 f8             	add    %r15,%rax
  ff40af:	48 89 43 08          	mov    %rax,0x8(%rbx)
  ff40b3:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  ff40b7:	48 39 c8             	cmp    %rcx,%rax
  ff40ba:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff40be:	48 89 43 20          	mov    %rax,0x20(%rbx)
  ff40c2:	4d 85 e4             	test   %r12,%r12
  ff40c5:	0f 84 2a 01 00 00    	je     ff41f5 <ir_optimize_licm+0x535>
  ff40cb:	4c 89 e7             	mov    %r12,%rdi
  ff40ce:	31 f6                	xor    %esi,%esi
  ff40d0:	4c 89 fa             	mov    %r15,%rdx
  ff40d3:	e8 c8 59 90 ff       	call   8f9aa0 <memset@plt>
  ff40d8:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff40dd:	4c 89 a4 24 58 06 00 00 	mov    %r12,0x658(%rsp)
  ff40e5:	eb 27                	jmp    ff410e <ir_optimize_licm+0x44e>
  ff40e7:	48 c7 84 24 58 06 00 00 00 00 00 00 	movq   $0x0,0x658(%rsp)
  ff40f3:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff40f9:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
  ff4101:	84 db                	test   %bl,%bl
  ff4103:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff4108:	0f 84 f9 00 00 00    	je     ff4207 <ir_optimize_licm+0x547>
  ff410e:	48 8b 8c 24 98 02 00 00 	mov    0x298(%rsp),%rcx
  ff4116:	83 79 38 00          	cmpl   $0x0,0x38(%rcx)
  ff411a:	0f 84 6a 01 00 00    	je     ff428a <ir_optimize_licm+0x5ca>
  ff4120:	31 c0                	xor    %eax,%eax
  ff4122:	31 d2                	xor    %edx,%edx
  ff4124:	eb 19                	jmp    ff413f <ir_optimize_licm+0x47f>
  ff4126:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
  ff4130:	8b 79 38             	mov    0x38(%rcx),%edi
  ff4133:	48 ff c2             	inc    %rdx
  ff4136:	48 39 fa             	cmp    %rdi,%rdx
  ff4139:	0f 83 4d 01 00 00    	jae    ff428c <ir_optimize_licm+0x5cc>
  ff413f:	48 8b b4 24 c8 02 00 00 	mov    0x2c8(%rsp),%rsi
  ff4147:	48 8b bc 24 38 06 00 00 	mov    0x638(%rsp),%rdi
  ff414f:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
  ff4152:	89 34 97             	mov    %esi,(%rdi,%rdx,4)
  ff4155:	48 8b 31             	mov    (%rcx),%rsi
  ff4158:	80 3c 16 02          	cmpb   $0x2,(%rsi,%rdx,1)
  ff415c:	75 d2                	jne    ff4130 <ir_optimize_licm+0x470>
  ff415e:	48 8b b4 24 50 06 00 00 	mov    0x650(%rsp),%rsi
  ff4166:	c6 04 16 01          	movb   $0x1,(%rsi,%rdx,1)
  ff416a:	48 8b b4 24 e8 03 00 00 	mov    0x3e8(%rsp),%rsi
  ff4172:	80 3c 16 00          	cmpb   $0x0,(%rsi,%rdx,1)
  ff4176:	75 b8                	jne    ff4130 <ir_optimize_licm+0x470>
  ff4178:	c6 04 16 01          	movb   $0x1,(%rsi,%rdx,1)
  ff417c:	48 8b b4 24 f0 03 00 00 	mov    0x3f0(%rsp),%rsi
  ff4184:	8b bc 24 fc 03 00 00 	mov    0x3fc(%rsp),%edi
  ff418b:	89 14 be             	mov    %edx,(%rsi,%rdi,4)
  ff418e:	8b b4 24 fc 03 00 00 	mov    0x3fc(%rsp),%esi
  ff4195:	ff c6                	inc    %esi
  ff4197:	89 b4 24 fc 03 00 00 	mov    %esi,0x3fc(%rsp)
  ff419e:	48 8b bc 24 98 02 00 00 	mov    0x298(%rsp),%rdi
  ff41a6:	3b 77 38             	cmp    0x38(%rdi),%esi
  ff41a9:	0f 44 f0             	cmove  %eax,%esi
  ff41ac:	89 b4 24 fc 03 00 00 	mov    %esi,0x3fc(%rsp)
  ff41b3:	ff 84 24 00 04 00 00 	incl   0x400(%rsp)
  ff41ba:	e9 71 ff ff ff       	jmp    ff4130 <ir_optimize_licm+0x470>
  ff41bf:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff41c4:	48 c7 84 24 40 06 00 00 00 00 00 00 	movq   $0x0,0x640(%rsp)
  ff41d0:	48 c7 84 24 48 06 00 00 00 00 00 00 	movq   $0x0,0x648(%rsp)
  ff41dc:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff41e1:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
  ff41e9:	48 c7 84 24 50 06 00 00 00 00 00 00 	movq   $0x0,0x650(%rsp)
  ff41f5:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff41fb:	48 c7 84 24 58 06 00 00 00 00 00 00 	movq   $0x0,0x658(%rsp)
  ff4207:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  ff420b:	62 f1 fe 48 7f 84 24 30 02 00 00 	vmovdqu64 %zmm0,0x230(%rsp)
  ff4216:	62 f1 fd 48 7f 44 24 08 	vmovdqa64 %zmm0,0x200(%rsp)
  ff421e:	62 f1 fd 48 7f 44 24 07 	vmovdqa64 %zmm0,0x1c0(%rsp)
  ff4226:	62 f1 fd 48 7f 44 24 06 	vmovdqa64 %zmm0,0x180(%rsp)
  ff422e:	62 f1 fd 48 7f 44 24 05 	vmovdqa64 %zmm0,0x140(%rsp)
  ff4236:	48 8b 84 24 f8 00 00 00 	mov    0xf8(%rsp),%rax
  ff423e:	49 3b 45 08          	cmp    0x8(%r13),%rax
  ff4242:	0f 87 4f 27 00 00    	ja     ff6997 <ir_optimize_licm+0x2cd7>
  ff4248:	49 89 45 08          	mov    %rax,0x8(%r13)
  ff424c:	44 89 f9             	mov    %r15d,%ecx
  ff424f:	48 8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%rdx
  ff4257:	4c 3b 73 08          	cmp    0x8(%rbx),%r14
  ff425b:	0f 87 36 27 00 00    	ja     ff6997 <ir_optimize_licm+0x2cd7>
  ff4261:	48 b8 00 00 00 00 ff ff ff ff 	movabs $0xffffffff00000000,%rax
  ff426b:	4c 89 73 08          	mov    %r14,0x8(%rbx)
  ff426f:	49 21 c1             	and    %rax,%r9
  ff4272:	49 09 c9             	or     %rcx,%r9
  ff4275:	4c 89 c8             	mov    %r9,%rax
  ff4278:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  ff427c:	5b                   	pop    %rbx
  ff427d:	41 5c                	pop    %r12
  ff427f:	41 5d                	pop    %r13
  ff4281:	41 5e                	pop    %r14
  ff4283:	41 5f                	pop    %r15
  ff4285:	5d                   	pop    %rbp
  ff4286:	c5 f8 77             	vzeroupper
  ff4289:	c3                   	ret
  ff428a:	31 ff                	xor    %edi,%edi
  ff428c:	8b b4 24 00 04 00 00 	mov    0x400(%rsp),%esi
  ff4293:	4d 89 cc             	mov    %r9,%r12
  ff4296:	85 f6                	test   %esi,%esi
  ff4298:	0f 84 16 01 00 00    	je     ff43b4 <ir_optimize_licm+0x6f4>
  ff429e:	31 c0                	xor    %eax,%eax
  ff42a0:	eb 1d                	jmp    ff42bf <ir_optimize_licm+0x5ff>
  ff42a2:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  ff42b0:	8b b4 24 00 04 00 00 	mov    0x400(%rsp),%esi
  ff42b7:	85 f6                	test   %esi,%esi
  ff42b9:	0f 84 f2 00 00 00    	je     ff43b1 <ir_optimize_licm+0x6f1>
  ff42bf:	48 8b 94 24 f0 03 00 00 	mov    0x3f0(%rsp),%rdx
  ff42c7:	8b bc 24 f8 03 00 00 	mov    0x3f8(%rsp),%edi
  ff42ce:	8b 14 ba             	mov    (%rdx,%rdi,4),%edx
  ff42d1:	ff c7                	inc    %edi
  ff42d3:	89 bc 24 f8 03 00 00 	mov    %edi,0x3f8(%rsp)
  ff42da:	4c 8b 84 24 98 02 00 00 	mov    0x298(%rsp),%r8
  ff42e2:	4c 8b 8c 24 e8 03 00 00 	mov    0x3e8(%rsp),%r9
  ff42ea:	41 3b 78 38          	cmp    0x38(%r8),%edi
  ff42ee:	0f 44 f8             	cmove  %eax,%edi
  ff42f1:	ff ce                	dec    %esi
  ff42f3:	89 bc 24 f8 03 00 00 	mov    %edi,0x3f8(%rsp)
  ff42fa:	89 b4 24 00 04 00 00 	mov    %esi,0x400(%rsp)
  ff4301:	41 c6 04 11 00       	movb   $0x0,(%r9,%rdx,1)
  ff4306:	48 8b bc 24 d8 02 00 00 	mov    0x2d8(%rsp),%rdi
  ff430e:	8b 34 97             	mov    (%rdi,%rdx,4),%esi
  ff4311:	3b 74 97 04          	cmp    0x4(%rdi,%rdx,4),%esi
  ff4315:	72 21                	jb     ff4338 <ir_optimize_licm+0x678>
  ff4317:	eb 97                	jmp    ff42b0 <ir_optimize_licm+0x5f0>
  ff4319:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  ff4320:	48 8b bc 24 d8 02 00 00 	mov    0x2d8(%rsp),%rdi
  ff4328:	48 ff c6             	inc    %rsi
  ff432b:	8b 7c 97 04          	mov    0x4(%rdi,%rdx,4),%edi
  ff432f:	48 39 fe             	cmp    %rdi,%rsi
  ff4332:	0f 83 78 ff ff ff    	jae    ff42b0 <ir_optimize_licm+0x5f0>
  ff4338:	48 8b bc 24 e0 02 00 00 	mov    0x2e0(%rsp),%rdi
  ff4340:	4c 8b 84 24 50 06 00 00 	mov    0x650(%rsp),%r8
  ff4348:	8b 3c f7             	mov    (%rdi,%rsi,8),%edi
  ff434b:	41 80 3c 38 00       	cmpb   $0x0,(%r8,%rdi,1)
  ff4350:	75 ce                	jne    ff4320 <ir_optimize_licm+0x660>
  ff4352:	41 c6 04 38 01       	movb   $0x1,(%r8,%rdi,1)
  ff4357:	4c 8b 84 24 e8 03 00 00 	mov    0x3e8(%rsp),%r8
  ff435f:	41 80 3c 38 00       	cmpb   $0x0,(%r8,%rdi,1)
  ff4364:	75 ba                	jne    ff4320 <ir_optimize_licm+0x660>
  ff4366:	41 c6 04 38 01       	movb   $0x1,(%r8,%rdi,1)
  ff436b:	4c 8b 84 24 f0 03 00 00 	mov    0x3f0(%rsp),%r8
  ff4373:	44 8b 8c 24 fc 03 00 00 	mov    0x3fc(%rsp),%r9d
  ff437b:	43 89 3c 88          	mov    %edi,(%r8,%r9,4)
  ff437f:	8b bc 24 fc 03 00 00 	mov    0x3fc(%rsp),%edi
  ff4386:	ff c7                	inc    %edi
  ff4388:	89 bc 24 fc 03 00 00 	mov    %edi,0x3fc(%rsp)
  ff438f:	4c 8b 84 24 98 02 00 00 	mov    0x298(%rsp),%r8
  ff4397:	41 3b 78 38          	cmp    0x38(%r8),%edi
  ff439b:	0f 44 f8             	cmove  %eax,%edi
  ff439e:	89 bc 24 fc 03 00 00 	mov    %edi,0x3fc(%rsp)
  ff43a5:	ff 84 24 00 04 00 00 	incl   0x400(%rsp)
  ff43ac:	e9 6f ff ff ff       	jmp    ff4320 <ir_optimize_licm+0x660>
  ff43b1:	8b 79 38             	mov    0x38(%rcx),%edi
  ff43b4:	85 ff                	test   %edi,%edi
  ff43b6:	0f 84 7f 00 00 00    	je     ff443b <ir_optimize_licm+0x77b>
  ff43bc:	62 f1 fd 48 6f 05 ba 52 51 ff 	vmovdqa64 -0xaead46(%rip),%zmm0        # 509680 <check_builtin_atomic_rmw_test_clang.native_source+0x124d0>
  ff43c6:	48 8b 84 24 48 06 00 00 	mov    0x648(%rsp),%rax
  ff43ce:	48 8b 94 24 50 06 00 00 	mov    0x650(%rsp),%rdx
  ff43d6:	41 89 fa             	mov    %edi,%r10d
  ff43d9:	bf 10 00 00 00       	mov    $0x10,%edi
  ff43de:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  ff43e4:	31 f6                	xor    %esi,%esi
  ff43e6:	45 31 c9             	xor    %r9d,%r9d
  ff43e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  ff43f0:	49 01 f2             	add    %rsi,%r10
  ff43f3:	4c 8b 19             	mov    (%rcx),%r11
  ff43f6:	49 83 fa 10          	cmp    $0x10,%r10
  ff43fa:	4c 0f 43 d7          	cmovae %rdi,%r10
  ff43fe:	48 83 c6 f0          	add    $0xfffffffffffffff0,%rsi
  ff4402:	c4 42 29 f7 d0       	shlx   %r10d,%r8d,%r10d
  ff4407:	41 f7 d2             	not    %r10d
  ff440a:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
  ff440f:	62 91 7f 89 6f 0c 0b 	vmovdqu8 (%r11,%r9,1),%xmm1{%k1}{z}
  ff4416:	62 b1 7f 89 6f 14 0a 	vmovdqu8 (%rdx,%r9,1),%xmm2{%k1}{z}
  ff441d:	62 f2 75 48 8d c8    	vpermb %zmm0,%zmm1,%zmm1
  ff4423:	c5 e9 df c9          	vpandn %xmm1,%xmm2,%xmm1
  ff4427:	62 b1 7f 09 7f 0c 08 	vmovdqu8 %xmm1,(%rax,%r9,1){%k1}
  ff442e:	49 83 c1 10          	add    $0x10,%r9
  ff4432:	44 8b 51 38          	mov    0x38(%rcx),%r10d
  ff4436:	4d 39 d1             	cmp    %r10,%r9
  ff4439:	72 b5                	jb     ff43f0 <ir_optimize_licm+0x730>
  ff443b:	8b 94 24 7c 05 00 00 	mov    0x57c(%rsp),%edx
  ff4442:	48 85 d2             	test   %rdx,%rdx
  ff4445:	0f 84 da 00 00 00    	je     ff4525 <ir_optimize_licm+0x865>
  ff444b:	48 8b 0b             	mov    (%rbx),%rcx
  ff444e:	48 8b 43 08          	mov    0x8(%rbx),%rax
  ff4452:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff4458:	4d 89 e1             	mov    %r12,%r9
  ff445b:	48 8d 7c 08 3f       	lea    0x3f(%rax,%rcx,1),%rdi
  ff4460:	48 01 c8             	add    %rcx,%rax
  ff4463:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff4467:	48 39 c7             	cmp    %rax,%rdi
  ff446a:	0f 82 97 fd ff ff    	jb     ff4207 <ir_optimize_licm+0x547>
  ff4470:	48 89 f8             	mov    %rdi,%rax
  ff4473:	48 29 c8             	sub    %rcx,%rax
  ff4476:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  ff447a:	48 29 c1             	sub    %rax,%rcx
  ff447d:	0f 82 84 fd ff ff    	jb     ff4207 <ir_optimize_licm+0x547>
  ff4483:	48 c1 e2 02          	shl    $0x2,%rdx
  ff4487:	48 39 ca             	cmp    %rcx,%rdx
  ff448a:	0f 87 77 fd ff ff    	ja     ff4207 <ir_optimize_licm+0x547>
  ff4490:	48 01 d0             	add    %rdx,%rax
  ff4493:	48 89 43 08          	mov    %rax,0x8(%rbx)
  ff4497:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  ff449b:	48 39 c8             	cmp    %rcx,%rax
  ff449e:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff44a2:	48 89 43 20          	mov    %rax,0x20(%rbx)
  ff44a6:	48 85 ff             	test   %rdi,%rdi
  ff44a9:	0f 84 58 fd ff ff    	je     ff4207 <ir_optimize_licm+0x547>
  ff44af:	31 f6                	xor    %esi,%esi
  ff44b1:	31 db                	xor    %ebx,%ebx
  ff44b3:	48 89 bc 24 a8 00 00 00 	mov    %rdi,0xa8(%rsp)
  ff44bb:	c5 f8 77             	vzeroupper
  ff44be:	e8 dd 55 90 ff       	call   8f9aa0 <memset@plt>
  ff44c3:	4c 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%r9
  ff44cb:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  ff44d0:	eb 19                	jmp    ff44eb <ir_optimize_licm+0x82b>
  ff44d2:	31 c0                	xor    %eax,%eax
  ff44d4:	41 89 1c 81          	mov    %ebx,(%r9,%rax,4)
  ff44d8:	48 ff c3             	inc    %rbx
  ff44db:	8b 84 24 7c 05 00 00 	mov    0x57c(%rsp),%eax
  ff44e2:	48 39 c3             	cmp    %rax,%rbx
  ff44e5:	0f 83 31 04 00 00    	jae    ff491c <ir_optimize_licm+0xc5c>
  ff44eb:	48 89 d8             	mov    %rbx,%rax
  ff44ee:	48 85 db             	test   %rbx,%rbx
  ff44f1:	74 df                	je     ff44d2 <ir_optimize_licm+0x812>
  ff44f3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  ff4500:	8d 48 ff             	lea    -0x1(%rax),%ecx
  ff4503:	48 8b b4 24 08 06 00 00 	mov    0x608(%rsp),%rsi
  ff450b:	41 8b 14 89          	mov    (%r9,%rcx,4),%edx
  ff450f:	8b 3c 96             	mov    (%rsi,%rdx,4),%edi
  ff4512:	3b 3c 9e             	cmp    (%rsi,%rbx,4),%edi
  ff4515:	76 bd                	jbe    ff44d4 <ir_optimize_licm+0x814>
  ff4517:	41 89 14 81          	mov    %edx,(%r9,%rax,4)
  ff451b:	48 ff c8             	dec    %rax
  ff451e:	48 85 c9             	test   %rcx,%rcx
  ff4521:	75 dd                	jne    ff4500 <ir_optimize_licm+0x840>
  ff4523:	eb ad                	jmp    ff44d2 <ir_optimize_licm+0x812>
  ff4525:	4c 8b 84 24 98 02 00 00 	mov    0x298(%rsp),%r8
  ff452d:	4d 89 e1             	mov    %r12,%r9
  ff4530:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  ff4534:	62 f1 fe 48 7f 84 24 30 02 00 00 	vmovdqu64 %zmm0,0x230(%rsp)
  ff453f:	62 f1 fd 48 7f 44 24 08 	vmovdqa64 %zmm0,0x200(%rsp)
  ff4547:	62 f1 fd 48 7f 44 24 07 	vmovdqa64 %zmm0,0x1c0(%rsp)
  ff454f:	62 f1 fd 48 7f 44 24 06 	vmovdqa64 %zmm0,0x180(%rsp)
  ff4557:	62 f1 fd 48 7f 44 24 05 	vmovdqa64 %zmm0,0x140(%rsp)
  ff455f:	48 8b 03             	mov    (%rbx),%rax
  ff4562:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  ff4566:	4c 8d 74 01 3f       	lea    0x3f(%rcx,%rax,1),%r14
  ff456b:	48 01 c1             	add    %rax,%rcx
  ff456e:	49 83 e6 c0          	and    $0xffffffffffffffc0,%r14
  ff4572:	49 39 ce             	cmp    %rcx,%r14
  ff4575:	0f 83 34 02 00 00    	jae    ff47af <ir_optimize_licm+0xaef>
  ff457b:	31 c0                	xor    %eax,%eax
  ff457d:	49 8d 48 38          	lea    0x38(%r8),%rcx
  ff4581:	31 ff                	xor    %edi,%edi
  ff4583:	48 c7 84 24 a0 00 00 00 00 00 00 00 	movq   $0x0,0xa0(%rsp)
  ff458f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  ff4594:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  ff4599:	45 31 e4             	xor    %r12d,%r12d
  ff459c:	31 f6                	xor    %esi,%esi
  ff459e:	45 31 d2             	xor    %r10d,%r10d
  ff45a1:	c4 c1 7c 10 40 70    	vmovups 0x70(%r8),%ymm0
  ff45a7:	4d 8b 70 38          	mov    0x38(%r8),%r14
  ff45ab:	4d 8b 58 48          	mov    0x48(%r8),%r11
  ff45af:	31 db                	xor    %ebx,%ebx
  ff45b1:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  ff45b6:	44 89 f2             	mov    %r14d,%edx
  ff45b9:	c5 fc 11 84 24 14 01 00 00 	vmovups %ymm0,0x114(%rsp)
  ff45c2:	c4 c1 7c 10 40 5c    	vmovups 0x5c(%r8),%ymm0
  ff45c8:	c5 fc 29 84 24 00 01 00 00 	vmovaps %ymm0,0x100(%rsp)
  ff45d1:	62 d1 fe 48 6f 80 9c 00 00 00 	vmovdqu64 0x9c(%r8),%zmm0
  ff45db:	62 d1 fe 48 6f 88 dc 00 00 00 	vmovdqu64 0xdc(%r8),%zmm1
  ff45e5:	62 d1 fe 48 6f 90 f0 00 00 00 	vmovdqu64 0xf0(%r8),%zmm2
  ff45ef:	62 f1 fd 48 7f 4c 24 20 	vmovdqa64 %zmm1,0x800(%rsp)
  ff45f7:	62 f1 fd 48 7f 44 24 1f 	vmovdqa64 %zmm0,0x7c0(%rsp)
  ff45ff:	62 f1 fe 48 7f 94 24 14 08 00 00 	vmovdqu64 %zmm2,0x814(%rsp)
  ff460a:	40 84 f6             	test   %sil,%sil
  ff460d:	0f 84 be 00 00 00    	je     ff46d1 <ir_optimize_licm+0xa11>
  ff4613:	45 85 f6             	test   %r14d,%r14d
  ff4616:	0f 84 b5 00 00 00    	je     ff46d1 <ir_optimize_licm+0xa11>
  ff461c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff4621:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff4627:	48 8b 0e             	mov    (%rsi),%rcx
  ff462a:	48 8b 46 08          	mov    0x8(%rsi),%rax
  ff462e:	48 8d 5c 08 3f       	lea    0x3f(%rax,%rcx,1),%rbx
  ff4633:	48 01 c8             	add    %rcx,%rax
  ff4636:	48 83 e3 c0          	and    $0xffffffffffffffc0,%rbx
  ff463a:	48 39 c3             	cmp    %rax,%rbx
  ff463d:	0f 82 e0 12 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff4643:	48 89 d8             	mov    %rbx,%rax
  ff4646:	48 29 c8             	sub    %rcx,%rax
  ff4649:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  ff464d:	48 29 c1             	sub    %rax,%rcx
  ff4650:	0f 82 cd 12 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff4656:	48 39 d1             	cmp    %rdx,%rcx
  ff4659:	0f 82 c4 12 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff465f:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff4664:	48 01 d0             	add    %rdx,%rax
  ff4667:	4c 89 a4 24 b8 00 00 00 	mov    %r12,0xb8(%rsp)
  ff466f:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
  ff4674:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff4678:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff467c:	48 39 c8             	cmp    %rcx,%rax
  ff467f:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff4683:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff4687:	48 85 db             	test   %rbx,%rbx
  ff468a:	0f 84 93 12 00 00    	je     ff5923 <ir_optimize_licm+0x1c63>
  ff4690:	48 89 d8             	mov    %rbx,%rax
  ff4693:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  ff4698:	48 89 c7             	mov    %rax,%rdi
  ff469b:	31 f6                	xor    %esi,%esi
  ff469d:	4d 89 c7             	mov    %r8,%r15
  ff46a0:	4d 89 d4             	mov    %r10,%r12
  ff46a3:	4d 89 de             	mov    %r11,%r14
  ff46a6:	c5 f8 77             	vzeroupper
  ff46a9:	e8 f2 53 90 ff       	call   8f9aa0 <memset@plt>
  ff46ae:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff46b3:	4d 89 f3             	mov    %r14,%r11
  ff46b6:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
  ff46bb:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff46c0:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  ff46c5:	4d 89 e2             	mov    %r12,%r10
  ff46c8:	4d 89 f8             	mov    %r15,%r8
  ff46cb:	8b 10                	mov    (%rax),%edx
  ff46cd:	89 d0                	mov    %edx,%eax
  ff46cf:	eb 10                	jmp    ff46e1 <ir_optimize_licm+0xa21>
  ff46d1:	4c 89 a4 24 b8 00 00 00 	mov    %r12,0xb8(%rsp)
  ff46d9:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
  ff46de:	44 89 f0             	mov    %r14d,%eax
  ff46e1:	85 c0                	test   %eax,%eax
  ff46e3:	41 89 f4             	mov    %esi,%r12d
  ff46e6:	0f 94 c1             	sete   %cl
  ff46e9:	41 80 f4 01          	xor    $0x1,%r12b
  ff46ed:	44 08 e1             	or     %r12b,%cl
  ff46f0:	0f 85 4c 01 00 00    	jne    ff4842 <ir_optimize_licm+0xb82>
  ff46f6:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff46fb:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff4701:	48 8b 0e             	mov    (%rsi),%rcx
  ff4704:	48 8b 46 08          	mov    0x8(%rsi),%rax
  ff4708:	48 8d 7c 08 3f       	lea    0x3f(%rax,%rcx,1),%rdi
  ff470d:	48 01 c8             	add    %rcx,%rax
  ff4710:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff4714:	48 39 c7             	cmp    %rax,%rdi
  ff4717:	0f 82 06 12 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff471d:	48 89 f8             	mov    %rdi,%rax
  ff4720:	48 29 c8             	sub    %rcx,%rax
  ff4723:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  ff4727:	48 29 c1             	sub    %rax,%rcx
  ff472a:	0f 82 f3 11 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff4730:	48 39 d1             	cmp    %rdx,%rcx
  ff4733:	0f 82 ea 11 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff4739:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff473e:	48 01 d0             	add    %rdx,%rax
  ff4741:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
  ff4746:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff474a:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff474e:	48 39 c8             	cmp    %rcx,%rax
  ff4751:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff4755:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff4759:	48 85 ff             	test   %rdi,%rdi
  ff475c:	0f 84 c1 11 00 00    	je     ff5923 <ir_optimize_licm+0x1c63>
  ff4762:	31 f6                	xor    %esi,%esi
  ff4764:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  ff4769:	48 89 fb             	mov    %rdi,%rbx
  ff476c:	4d 89 c7             	mov    %r8,%r15
  ff476f:	4c 89 54 24 60       	mov    %r10,0x60(%rsp)
  ff4774:	4d 89 de             	mov    %r11,%r14
  ff4777:	c5 f8 77             	vzeroupper
  ff477a:	e8 21 53 90 ff       	call   8f9aa0 <memset@plt>
  ff477f:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff4784:	48 89 df             	mov    %rbx,%rdi
  ff4787:	4d 89 f3             	mov    %r14,%r11
  ff478a:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
  ff478f:	4c 8b 54 24 60       	mov    0x60(%rsp),%r10
  ff4794:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff4799:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
  ff479e:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  ff47a3:	4d 89 f8             	mov    %r15,%r8
  ff47a6:	8b 10                	mov    (%rax),%edx
  ff47a8:	89 d0                	mov    %edx,%eax
  ff47aa:	e9 95 00 00 00       	jmp    ff4844 <ir_optimize_licm+0xb84>
  ff47af:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  ff47b3:	4c 89 f1             	mov    %r14,%rcx
  ff47b6:	48 29 c1             	sub    %rax,%rcx
  ff47b9:	31 c0                	xor    %eax,%eax
  ff47bb:	48 29 ce             	sub    %rcx,%rsi
  ff47be:	0f 82 b9 fd ff ff    	jb     ff457d <ir_optimize_licm+0x8bd>
  ff47c4:	41 8b 50 48          	mov    0x48(%r8),%edx
  ff47c8:	48 8d 14 95 04 00 00 00 	lea    0x4(,%rdx,4),%rdx
  ff47d0:	48 39 f2             	cmp    %rsi,%rdx
  ff47d3:	0f 87 a4 fd ff ff    	ja     ff457d <ir_optimize_licm+0x8bd>
  ff47d9:	48 01 d1             	add    %rdx,%rcx
  ff47dc:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  ff47e0:	48 8b 43 20          	mov    0x20(%rbx),%rax
  ff47e4:	48 39 c1             	cmp    %rax,%rcx
  ff47e7:	48 0f 46 c8          	cmovbe %rax,%rcx
  ff47eb:	48 89 4b 20          	mov    %rcx,0x20(%rbx)
  ff47ef:	4d 85 f6             	test   %r14,%r14
  ff47f2:	0f 84 83 fd ff ff    	je     ff457b <ir_optimize_licm+0x8bb>
  ff47f8:	4c 89 f7             	mov    %r14,%rdi
  ff47fb:	31 f6                	xor    %esi,%esi
  ff47fd:	4d 89 c4             	mov    %r8,%r12
  ff4800:	c5 f8 77             	vzeroupper
  ff4803:	e8 98 52 90 ff       	call   8f9aa0 <memset@plt>
  ff4808:	41 8b 54 24 48       	mov    0x48(%r12),%edx
  ff480d:	4d 89 e0             	mov    %r12,%r8
  ff4810:	48 85 d2             	test   %rdx,%rdx
  ff4813:	0f 84 ae 0d 00 00    	je     ff55c7 <ir_optimize_licm+0x1907>
  ff4819:	48 8b 03             	mov    (%rbx),%rax
  ff481c:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  ff4820:	48 8d 7c 01 3f       	lea    0x3f(%rcx,%rax,1),%rdi
  ff4825:	48 01 c1             	add    %rax,%rcx
  ff4828:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff482c:	48 39 cf             	cmp    %rcx,%rdi
  ff482f:	0f 83 83 0e 00 00    	jae    ff56b8 <ir_optimize_licm+0x19f8>
  ff4835:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff483a:	4c 89 f0             	mov    %r14,%rax
  ff483d:	e9 3b fd ff ff       	jmp    ff457d <ir_optimize_licm+0x8bd>
  ff4842:	31 ff                	xor    %edi,%edi
  ff4844:	85 c0                	test   %eax,%eax
  ff4846:	4c 89 54 24 60       	mov    %r10,0x60(%rsp)
  ff484b:	0f 94 c1             	sete   %cl
  ff484e:	44 08 e1             	or     %r12b,%cl
  ff4851:	0f 85 9f 0b 00 00    	jne    ff53f6 <ir_optimize_licm+0x1736>
  ff4857:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff485c:	49 89 fa             	mov    %rdi,%r10
  ff485f:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff4865:	48 8b 0e             	mov    (%rsi),%rcx
  ff4868:	48 8b 46 08          	mov    0x8(%rsi),%rax
  ff486c:	48 8d 7c 08 3f       	lea    0x3f(%rax,%rcx,1),%rdi
  ff4871:	48 01 c8             	add    %rcx,%rax
  ff4874:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff4878:	48 39 c7             	cmp    %rax,%rdi
  ff487b:	0f 82 a2 10 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff4881:	48 89 bc 24 b0 00 00 00 	mov    %rdi,0xb0(%rsp)
  ff4889:	48 29 cf             	sub    %rcx,%rdi
  ff488c:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  ff4890:	48 29 f9             	sub    %rdi,%rcx
  ff4893:	0f 82 8a 10 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff4899:	48 39 d1             	cmp    %rdx,%rcx
  ff489c:	0f 82 81 10 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff48a2:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff48a7:	48 01 d7             	add    %rdx,%rdi
  ff48aa:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
  ff48af:	48 89 7e 08          	mov    %rdi,0x8(%rsi)
  ff48b3:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff48b7:	48 39 cf             	cmp    %rcx,%rdi
  ff48ba:	48 0f 46 f9          	cmovbe %rcx,%rdi
  ff48be:	48 83 bc 24 b0 00 00 00 00 	cmpq   $0x0,0xb0(%rsp)
  ff48c7:	48 89 7e 20          	mov    %rdi,0x20(%rsi)
  ff48cb:	0f 84 52 10 00 00    	je     ff5923 <ir_optimize_licm+0x1c63>
  ff48d1:	48 8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%rdi
  ff48d9:	31 f6                	xor    %esi,%esi
  ff48db:	4c 89 f3             	mov    %r14,%rbx
  ff48de:	4c 89 54 24 40       	mov    %r10,0x40(%rsp)
  ff48e3:	4d 89 c7             	mov    %r8,%r15
  ff48e6:	4d 89 de             	mov    %r11,%r14
  ff48e9:	c5 f8 77             	vzeroupper
  ff48ec:	e8 af 51 90 ff       	call   8f9aa0 <memset@plt>
  ff48f1:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff48f6:	4d 89 f3             	mov    %r14,%r11
  ff48f9:	49 89 de             	mov    %rbx,%r14
  ff48fc:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  ff4901:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff4906:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
  ff490b:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  ff4910:	4d 89 f8             	mov    %r15,%r8
  ff4913:	8b 10                	mov    (%rax),%edx
  ff4915:	89 d0                	mov    %edx,%eax
  ff4917:	e9 e6 0a 00 00       	jmp    ff5402 <ir_optimize_licm+0x1742>
  ff491c:	4c 8b 84 24 98 02 00 00 	mov    0x298(%rsp),%r8
  ff4924:	4d 85 ff             	test   %r15,%r15
  ff4927:	0f 94 84 24 88 00 00 00 	sete   0x88(%rsp)
  ff492f:	85 c0                	test   %eax,%eax
  ff4931:	0f 84 81 0c 00 00    	je     ff55b8 <ir_optimize_licm+0x18f8>
  ff4937:	62 f2 7d 48 58 2d d3 b1 62 ff 	vpbroadcastd -0x9d4e2d(%rip),%zmm5        # 61fb14 <check_test_member_scaling.timed+0xa74>
  ff4941:	62 f3 4d 48 25 f6 ff 	vpternlogd $0xff,%zmm6,%zmm6,%zmm6
  ff4948:	31 c9                	xor    %ecx,%ecx
  ff494a:	4c 89 44 24 28       	mov    %r8,0x28(%rsp)
  ff494f:	4c 89 ac 24 e8 00 00 00 	mov    %r13,0xe8(%rsp)
  ff4957:	eb 2f                	jmp    ff4988 <ir_optimize_licm+0xcc8>
  ff4959:	ff 84 24 98 07 00 00 	incl   0x798(%rsp)
  ff4960:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff4965:	48 8b 8c 24 d0 00 00 00 	mov    0xd0(%rsp),%rcx
  ff496d:	8b 84 24 7c 05 00 00 	mov    0x57c(%rsp),%eax
  ff4974:	4c 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%r9
  ff497c:	48 ff c1             	inc    %rcx
  ff497f:	48 39 c1             	cmp    %rax,%rcx
  ff4982:	0f 83 41 0b 00 00    	jae    ff54c9 <ir_optimize_licm+0x1809>
  ff4988:	48 89 8c 24 d0 00 00 00 	mov    %rcx,0xd0(%rsp)
  ff4990:	41 8b 0c 89          	mov    (%r9,%rcx,4),%ecx
  ff4994:	48 8b 94 24 f8 05 00 00 	mov    0x5f8(%rsp),%rdx
  ff499c:	48 8b b4 24 b8 02 00 00 	mov    0x2b8(%rsp),%rsi
  ff49a4:	8b 14 8a             	mov    (%rdx,%rcx,4),%edx
  ff49a7:	8b 1c 96             	mov    (%rsi,%rdx,4),%ebx
  ff49aa:	8b 7c 96 04          	mov    0x4(%rsi,%rdx,4),%edi
  ff49ae:	39 fb                	cmp    %edi,%ebx
  ff49b0:	73 a7                	jae    ff4959 <ir_optimize_licm+0xc99>
  ff49b2:	48 8b b4 24 c0 02 00 00 	mov    0x2c0(%rsp),%rsi
  ff49ba:	48 8b 94 24 c8 05 00 00 	mov    0x5c8(%rsp),%rdx
  ff49c2:	39 c1                	cmp    %eax,%ecx
  ff49c4:	73 44                	jae    ff4a0a <ir_optimize_licm+0xd4a>
  ff49c6:	4c 8b 94 24 88 05 00 00 	mov    0x588(%rsp),%r10
  ff49ce:	44 8b 8c 24 70 05 00 00 	mov    0x570(%rsp),%r9d
  ff49d6:	48 89 d8             	mov    %rbx,%rax
  ff49d9:	48 29 f8             	sub    %rdi,%rax
  ff49dc:	48 29 df             	sub    %rbx,%rdi
  ff49df:	41 89 fb             	mov    %edi,%r11d
  ff49e2:	41 83 e3 03          	and    $0x3,%r11d
  ff49e6:	4c 0f af d1          	imul   %rcx,%r10
  ff49ea:	49 c1 e2 03          	shl    $0x3,%r10
  ff49ee:	4c 03 94 24 10 06 00 00 	add    0x610(%rsp),%r10
  ff49f6:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  ff49fa:	76 2f                	jbe    ff4a2b <ir_optimize_licm+0xd6b>
  ff49fc:	45 31 c0             	xor    %r8d,%r8d
  ff49ff:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
  ff4a05:	e9 1f 02 00 00       	jmp    ff4c29 <ir_optimize_licm+0xf69>
  ff4a0a:	49 89 f9             	mov    %rdi,%r9
  ff4a0d:	49 29 d9             	sub    %rbx,%r9
  ff4a10:	49 83 f9 10          	cmp    $0x10,%r9
  ff4a14:	0f 83 7b 01 00 00    	jae    ff4b95 <ir_optimize_licm+0xed5>
  ff4a1a:	45 31 c0             	xor    %r8d,%r8d
  ff4a1d:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
  ff4a23:	48 89 d8             	mov    %rbx,%rax
  ff4a26:	e9 fc 02 00 00       	jmp    ff4d27 <ir_optimize_licm+0x1067>
  ff4a2b:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
  ff4a2f:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
  ff4a35:	45 31 c0             	xor    %r8d,%r8d
  ff4a38:	eb 11                	jmp    ff4a4b <ir_optimize_licm+0xd8b>
  ff4a3a:	41 89 c4             	mov    %eax,%r12d
  ff4a3d:	48 83 c3 04          	add    $0x4,%rbx
  ff4a41:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
  ff4a45:	0f 84 d5 01 00 00    	je     ff4c20 <ir_optimize_licm+0xf60>
  ff4a4b:	8b 04 9e             	mov    (%rsi,%rbx,4),%eax
  ff4a4e:	83 3c 82 ff          	cmpl   $0xffffffff,(%rdx,%rax,4)
  ff4a52:	74 42                	je     ff4a96 <ir_optimize_licm+0xdd6>
  ff4a54:	44 39 c8             	cmp    %r9d,%eax
  ff4a57:	0f 83 88 00 00 00    	jae    ff4ae5 <ir_optimize_licm+0xe25>
  ff4a5d:	41 89 c6             	mov    %eax,%r14d
  ff4a60:	41 c1 ee 06          	shr    $0x6,%r14d
  ff4a64:	c4 02 fb f7 34 f2    	shrx   %rax,(%r10,%r14,8),%r14
  ff4a6a:	45 89 f7             	mov    %r14d,%r15d
  ff4a6d:	41 f6 d7             	not    %r15b
  ff4a70:	45 0f b6 ff          	movzbl %r15b,%r15d
  ff4a74:	41 83 e7 01          	and    $0x1,%r15d
  ff4a78:	45 01 f8             	add    %r15d,%r8d
  ff4a7b:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  ff4a80:	41 f6 c6 01          	test   $0x1,%r14b
  ff4a84:	41 0f 45 c4          	cmovne %r12d,%eax
  ff4a88:	44 8b 74 9e 04       	mov    0x4(%rsi,%rbx,4),%r14d
  ff4a8d:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff4a92:	75 11                	jne    ff4aa5 <ir_optimize_licm+0xde5>
  ff4a94:	eb 5e                	jmp    ff4af4 <ir_optimize_licm+0xe34>
  ff4a96:	44 89 e0             	mov    %r12d,%eax
  ff4a99:	44 8b 74 9e 04       	mov    0x4(%rsi,%rbx,4),%r14d
  ff4a9e:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff4aa3:	74 4f                	je     ff4af4 <ir_optimize_licm+0xe34>
  ff4aa5:	45 39 ce             	cmp    %r9d,%r14d
  ff4aa8:	0f 83 85 00 00 00    	jae    ff4b33 <ir_optimize_licm+0xe73>
  ff4aae:	45 89 f7             	mov    %r14d,%r15d
  ff4ab1:	41 c1 ef 06          	shr    $0x6,%r15d
  ff4ab5:	c4 02 8b f7 3c fa    	shrx   %r14,(%r10,%r15,8),%r15
  ff4abb:	45 89 fc             	mov    %r15d,%r12d
  ff4abe:	41 f6 d4             	not    %r12b
  ff4ac1:	45 0f b6 e4          	movzbl %r12b,%r12d
  ff4ac5:	41 83 e4 01          	and    $0x1,%r12d
  ff4ac9:	45 01 e0             	add    %r12d,%r8d
  ff4acc:	41 f6 c7 01          	test   $0x1,%r15b
  ff4ad0:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  ff4ad5:	44 0f 45 f0          	cmovne %eax,%r14d
  ff4ad9:	8b 44 9e 08          	mov    0x8(%rsi,%rbx,4),%eax
  ff4add:	83 3c 82 ff          	cmpl   $0xffffffff,(%rdx,%rax,4)
  ff4ae1:	75 1e                	jne    ff4b01 <ir_optimize_licm+0xe41>
  ff4ae3:	eb 5b                	jmp    ff4b40 <ir_optimize_licm+0xe80>
  ff4ae5:	41 ff c0             	inc    %r8d
  ff4ae8:	44 8b 74 9e 04       	mov    0x4(%rsi,%rbx,4),%r14d
  ff4aed:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff4af2:	75 b1                	jne    ff4aa5 <ir_optimize_licm+0xde5>
  ff4af4:	41 89 c6             	mov    %eax,%r14d
  ff4af7:	8b 44 9e 08          	mov    0x8(%rsi,%rbx,4),%eax
  ff4afb:	83 3c 82 ff          	cmpl   $0xffffffff,(%rdx,%rax,4)
  ff4aff:	74 3f                	je     ff4b40 <ir_optimize_licm+0xe80>
  ff4b01:	44 39 c8             	cmp    %r9d,%eax
  ff4b04:	73 3f                	jae    ff4b45 <ir_optimize_licm+0xe85>
  ff4b06:	41 89 c7             	mov    %eax,%r15d
  ff4b09:	41 c1 ef 06          	shr    $0x6,%r15d
  ff4b0d:	c4 02 fb f7 3c fa    	shrx   %rax,(%r10,%r15,8),%r15
  ff4b13:	45 89 fc             	mov    %r15d,%r12d
  ff4b16:	41 f6 d4             	not    %r12b
  ff4b19:	45 0f b6 e4          	movzbl %r12b,%r12d
  ff4b1d:	41 83 e4 01          	and    $0x1,%r12d
  ff4b21:	45 01 e0             	add    %r12d,%r8d
  ff4b24:	41 f6 c7 01          	test   $0x1,%r15b
  ff4b28:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  ff4b2d:	41 0f 45 c6          	cmovne %r14d,%eax
  ff4b31:	eb 15                	jmp    ff4b48 <ir_optimize_licm+0xe88>
  ff4b33:	41 ff c0             	inc    %r8d
  ff4b36:	8b 44 9e 08          	mov    0x8(%rsi,%rbx,4),%eax
  ff4b3a:	83 3c 82 ff          	cmpl   $0xffffffff,(%rdx,%rax,4)
  ff4b3e:	75 c1                	jne    ff4b01 <ir_optimize_licm+0xe41>
  ff4b40:	44 89 f0             	mov    %r14d,%eax
  ff4b43:	eb 03                	jmp    ff4b48 <ir_optimize_licm+0xe88>
  ff4b45:	41 ff c0             	inc    %r8d
  ff4b48:	44 8b 64 9e 0c       	mov    0xc(%rsi,%rbx,4),%r12d
  ff4b4d:	42 83 3c a2 ff       	cmpl   $0xffffffff,(%rdx,%r12,4)
  ff4b52:	0f 84 e2 fe ff ff    	je     ff4a3a <ir_optimize_licm+0xd7a>
  ff4b58:	45 39 cc             	cmp    %r9d,%r12d
  ff4b5b:	73 30                	jae    ff4b8d <ir_optimize_licm+0xecd>
  ff4b5d:	45 89 e6             	mov    %r12d,%r14d
  ff4b60:	41 c1 ee 06          	shr    $0x6,%r14d
  ff4b64:	c4 02 9b f7 34 f2    	shrx   %r12,(%r10,%r14,8),%r14
  ff4b6a:	45 89 f7             	mov    %r14d,%r15d
  ff4b6d:	41 f6 d7             	not    %r15b
  ff4b70:	45 0f b6 ff          	movzbl %r15b,%r15d
  ff4b74:	41 83 e7 01          	and    $0x1,%r15d
  ff4b78:	45 01 f8             	add    %r15d,%r8d
  ff4b7b:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  ff4b80:	41 f6 c6 01          	test   $0x1,%r14b
  ff4b84:	44 0f 45 e0          	cmovne %eax,%r12d
  ff4b88:	e9 b0 fe ff ff       	jmp    ff4a3d <ir_optimize_licm+0xd7d>
  ff4b8d:	41 ff c0             	inc    %r8d
  ff4b90:	e9 a8 fe ff ff       	jmp    ff4a3d <ir_optimize_licm+0xd7d>
  ff4b95:	4d 89 ca             	mov    %r9,%r10
  ff4b98:	49 83 e2 f0          	and    $0xfffffffffffffff0,%r10
  ff4b9c:	4c 8d 04 9e          	lea    (%rsi,%rbx,4),%r8
  ff4ba0:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
  ff4ba4:	62 f3 75 48 25 c9 ff 	vpternlogd $0xff,%zmm1,%zmm1,%zmm1
  ff4bab:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  ff4baf:	45 31 db             	xor    %r11d,%r11d
  ff4bb2:	49 8d 04 1a          	lea    (%r10,%rbx,1),%rax
  ff4bb6:	eb 19                	jmp    ff4bd1 <ir_optimize_licm+0xf11>
  ff4bb8:	62 f2 7e 48 38 d0    	vpmovm2d %k0,%zmm2
  ff4bbe:	62 f1 7d 48 fa c2    	vpsubd %zmm2,%zmm0,%zmm0
  ff4bc4:	49 83 c3 10          	add    $0x10,%r11
  ff4bc8:	4d 39 da             	cmp    %r11,%r10
  ff4bcb:	0f 84 b0 00 00 00    	je     ff4c81 <ir_optimize_licm+0xfc1>
  ff4bd1:	62 92 7d 48 35 1c 98 	vpmovzxdq (%r8,%r11,4),%zmm3
  ff4bd8:	62 92 7d 48 35 54 98 01 	vpmovzxdq 0x20(%r8,%r11,4),%zmm2
  ff4be0:	c5 fd 46 d0          	kxnorb %k0,%k0,%k2
  ff4be4:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  ff4be8:	62 f2 7d 4a 91 24 9a 	vpgatherqd (%rdx,%zmm3,4),%ymm4{%k2}
  ff4bef:	c5 fd 46 d0          	kxnorb %k0,%k0,%k2
  ff4bf3:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
  ff4bf7:	62 f2 7d 4a 91 1c 92 	vpgatherqd (%rdx,%zmm2,4),%ymm3{%k2}
  ff4bfe:	62 f3 dd 48 3a d3 01 	vinserti64x4 $0x1,%ymm3,%zmm4,%zmm2
  ff4c05:	62 f3 6d 48 1f c6 04 	vpcmpneqd %zmm6,%zmm2,%k0
  ff4c0c:	c5 f8 98 c0          	kortestw %k0,%k0
  ff4c10:	74 a6                	je     ff4bb8 <ir_optimize_licm+0xef8>
  ff4c12:	62 91 fe 48 6f 0c 98 	vmovdqu64 (%r8,%r11,4),%zmm1
  ff4c19:	c4 e1 f8 90 c8       	kmovq  %k0,%k1
  ff4c1e:	eb 98                	jmp    ff4bb8 <ir_optimize_licm+0xef8>
  ff4c20:	4d 85 db             	test   %r11,%r11
  ff4c23:	0f 84 1d 01 00 00    	je     ff4d46 <ir_optimize_licm+0x1086>
  ff4c29:	48 8d 04 9e          	lea    (%rsi,%rbx,4),%rax
  ff4c2d:	44 89 e7             	mov    %r12d,%edi
  ff4c30:	31 f6                	xor    %esi,%esi
  ff4c32:	eb 12                	jmp    ff4c46 <ir_optimize_licm+0xf86>
  ff4c34:	41 89 fc             	mov    %edi,%r12d
  ff4c37:	48 ff c6             	inc    %rsi
  ff4c3a:	44 89 e7             	mov    %r12d,%edi
  ff4c3d:	49 39 f3             	cmp    %rsi,%r11
  ff4c40:	0f 84 00 01 00 00    	je     ff4d46 <ir_optimize_licm+0x1086>
  ff4c46:	44 8b 24 b0          	mov    (%rax,%rsi,4),%r12d
  ff4c4a:	42 83 3c a2 ff       	cmpl   $0xffffffff,(%rdx,%r12,4)
  ff4c4f:	74 e3                	je     ff4c34 <ir_optimize_licm+0xf74>
  ff4c51:	45 39 cc             	cmp    %r9d,%r12d
  ff4c54:	73 26                	jae    ff4c7c <ir_optimize_licm+0xfbc>
  ff4c56:	44 89 e3             	mov    %r12d,%ebx
  ff4c59:	c1 eb 06             	shr    $0x6,%ebx
  ff4c5c:	c4 c2 9b f7 1c da    	shrx   %r12,(%r10,%rbx,8),%rbx
  ff4c62:	41 89 de             	mov    %ebx,%r14d
  ff4c65:	41 f6 d6             	not    %r14b
  ff4c68:	45 0f b6 f6          	movzbl %r14b,%r14d
  ff4c6c:	41 83 e6 01          	and    $0x1,%r14d
  ff4c70:	45 01 f0             	add    %r14d,%r8d
  ff4c73:	f6 c3 01             	test   $0x1,%bl
  ff4c76:	44 0f 45 e7          	cmovne %edi,%r12d
  ff4c7a:	eb bb                	jmp    ff4c37 <ir_optimize_licm+0xf77>
  ff4c7c:	41 ff c0             	inc    %r8d
  ff4c7f:	eb b6                	jmp    ff4c37 <ir_optimize_licm+0xf77>
  ff4c81:	62 f1 fd 48 7f 4c 24 2b 	vmovdqa64 %zmm1,0xac0(%rsp)
  ff4c89:	c5 f1 76 c9          	vpcmpeqd %xmm1,%xmm1,%xmm1
  ff4c8d:	c4 e3 f9 30 c1 08    	kshiftrw $0x8,%k1,%k0
  ff4c93:	62 f2 75 09 66 0d f3 5d 61 ff 	vpblendmb -0x9ea20d(%rip),%xmm1,%xmm1{%k1}        # 60aa90 <tier0_program_class_type.types+0x3b70>
  ff4c9d:	c5 f5 45 c0          	korb   %k0,%k1,%k0
  ff4ca1:	c4 e3 79 30 d0 04    	kshiftrb $0x4,%k0,%k2
  ff4ca7:	c5 fc 45 c2          	korw   %k2,%k0,%k0
  ff4cab:	c4 e3 79 30 d0 02    	kshiftrb $0x2,%k0,%k2
  ff4cb1:	c5 fc 45 c2          	korw   %k2,%k0,%k0
  ff4cb5:	c4 e3 79 30 d0 01    	kshiftrb $0x1,%k0,%k2
  ff4cbb:	c5 fc 45 c2          	korw   %k2,%k0,%k0
  ff4cbf:	c5 7b 93 c0          	kmovd  %k0,%r8d
  ff4cc3:	c5 e9 71 d1 08       	vpsrlw $0x8,%xmm1,%xmm2
  ff4cc8:	41 80 e0 01          	and    $0x1,%r8b
  ff4ccc:	c5 f1 da ca          	vpminub %xmm2,%xmm1,%xmm1
  ff4cd0:	41 80 f8 01          	cmp    $0x1,%r8b
  ff4cd4:	c4 e2 79 41 c9       	vphminposuw %xmm1,%xmm1
  ff4cd9:	45 19 e4             	sbb    %r12d,%r12d
  ff4cdc:	c4 c1 79 7e c8       	vmovd  %xmm1,%r8d
  ff4ce1:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
  ff4ce8:	41 f6 d0             	not    %r8b
  ff4ceb:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
  ff4cf1:	45 0f b6 c0          	movzbl %r8b,%r8d
  ff4cf5:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
  ff4cfb:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
  ff4cff:	41 83 e0 0f          	and    $0xf,%r8d
  ff4d03:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
  ff4d08:	46 0b a4 84 c0 0a 00 00 	or     0xac0(%rsp,%r8,4),%r12d
  ff4d10:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
  ff4d14:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
  ff4d19:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
  ff4d1d:	c4 c1 79 7e c0       	vmovd  %xmm0,%r8d
  ff4d22:	4d 39 d1             	cmp    %r10,%r9
  ff4d25:	74 1f                	je     ff4d46 <ir_optimize_licm+0x1086>
  ff4d27:	44 8b 0c 86          	mov    (%rsi,%rax,4),%r9d
  ff4d2b:	45 31 d2             	xor    %r10d,%r10d
  ff4d2e:	42 83 3c 8a ff       	cmpl   $0xffffffff,(%rdx,%r9,4)
  ff4d33:	41 0f 95 c2          	setne  %r10b
  ff4d37:	45 0f 45 e1          	cmovne %r9d,%r12d
  ff4d3b:	48 ff c0             	inc    %rax
  ff4d3e:	45 01 d0             	add    %r10d,%r8d
  ff4d41:	48 39 c7             	cmp    %rax,%rdi
  ff4d44:	75 e1                	jne    ff4d27 <ir_optimize_licm+0x1067>
  ff4d46:	48 8b 84 24 30 06 00 00 	mov    0x630(%rsp),%rax
  ff4d4e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  ff4d53:	49 bb ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%r11
  ff4d5d:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1)
  ff4d61:	0f 85 f2 fb ff ff    	jne    ff4959 <ir_optimize_licm+0xc99>
  ff4d67:	41 83 f8 01          	cmp    $0x1,%r8d
  ff4d6b:	0f 85 e8 fb ff ff    	jne    ff4959 <ir_optimize_licm+0xc99>
  ff4d71:	48 8b 94 24 a8 02 00 00 	mov    0x2a8(%rsp),%rdx
  ff4d79:	44 89 e0             	mov    %r12d,%eax
  ff4d7c:	8b 74 82 04          	mov    0x4(%rdx,%rax,4),%esi
  ff4d80:	2b 34 82             	sub    (%rdx,%rax,4),%esi
  ff4d83:	83 fe 01             	cmp    $0x1,%esi
  ff4d86:	0f 85 cd fb ff ff    	jne    ff4959 <ir_optimize_licm+0xc99>
  ff4d8c:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  ff4d90:	0f 84 c3 fb ff ff    	je     ff4959 <ir_optimize_licm+0xc99>
  ff4d96:	ff 84 24 94 07 00 00 	incl   0x794(%rsp)
  ff4d9d:	41 83 7a 38 00       	cmpl   $0x0,0x38(%r10)
  ff4da2:	0f 84 a5 05 00 00    	je     ff534d <ir_optimize_licm+0x168d>
  ff4da8:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff4dad:	31 d2                	xor    %edx,%edx
  ff4daf:	eb 2d                	jmp    ff4dde <ir_optimize_licm+0x111e>
  ff4db1:	48 8b b4 24 48 06 00 00 	mov    0x648(%rsp),%rsi
  ff4db9:	80 3c 16 00          	cmpb   $0x0,(%rsi,%rdx,1)
  ff4dbd:	0f 95 04 17          	setne  (%rdi,%rdx,1)
  ff4dc1:	31 f6                	xor    %esi,%esi
  ff4dc3:	48 8b bc 24 40 06 00 00 	mov    0x640(%rsp),%rdi
  ff4dcb:	89 34 97             	mov    %esi,(%rdi,%rdx,4)
  ff4dce:	48 ff c2             	inc    %rdx
  ff4dd1:	41 8b 72 38          	mov    0x38(%r10),%esi
  ff4dd5:	48 39 f2             	cmp    %rsi,%rdx
  ff4dd8:	0f 83 ce 00 00 00    	jae    ff4eac <ir_optimize_licm+0x11ec>
  ff4dde:	3b 8c 24 7c 05 00 00 	cmp    0x57c(%rsp),%ecx
  ff4de5:	73 47                	jae    ff4e2e <ir_optimize_licm+0x116e>
  ff4de7:	48 8b b4 24 38 06 00 00 	mov    0x638(%rsp),%rsi
  ff4def:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
  ff4df2:	3b b4 24 70 05 00 00 	cmp    0x570(%rsp),%esi
  ff4df9:	73 33                	jae    ff4e2e <ir_optimize_licm+0x116e>
  ff4dfb:	48 8b bc 24 88 05 00 00 	mov    0x588(%rsp),%rdi
  ff4e03:	41 89 f0             	mov    %esi,%r8d
  ff4e06:	41 c1 e8 06          	shr    $0x6,%r8d
  ff4e0a:	48 0f af f9          	imul   %rcx,%rdi
  ff4e0e:	48 c1 e7 03          	shl    $0x3,%rdi
  ff4e12:	48 03 bc 24 10 06 00 00 	add    0x610(%rsp),%rdi
  ff4e1a:	4e 8b 04 c7          	mov    (%rdi,%r8,8),%r8
  ff4e1e:	48 8b bc 24 58 06 00 00 	mov    0x658(%rsp),%rdi
  ff4e26:	49 0f a3 f0          	bt     %rsi,%r8
  ff4e2a:	72 85                	jb     ff4db1 <ir_optimize_licm+0x10f1>
  ff4e2c:	eb 08                	jmp    ff4e36 <ir_optimize_licm+0x1176>
  ff4e2e:	48 8b bc 24 58 06 00 00 	mov    0x658(%rsp),%rdi
  ff4e36:	c6 04 17 00          	movb   $0x0,(%rdi,%rdx,1)
  ff4e3a:	48 8b b4 24 38 06 00 00 	mov    0x638(%rsp),%rsi
  ff4e42:	44 8b 84 24 70 05 00 00 	mov    0x570(%rsp),%r8d
  ff4e4a:	8b 3c 96             	mov    (%rsi,%rdx,4),%edi
  ff4e4d:	31 f6                	xor    %esi,%esi
  ff4e4f:	44 39 c7             	cmp    %r8d,%edi
  ff4e52:	0f 83 6b ff ff ff    	jae    ff4dc3 <ir_optimize_licm+0x1103>
  ff4e58:	45 39 c4             	cmp    %r8d,%r12d
  ff4e5b:	0f 83 62 ff ff ff    	jae    ff4dc3 <ir_optimize_licm+0x1103>
  ff4e61:	4c 8b 84 24 b8 05 00 00 	mov    0x5b8(%rsp),%r8
  ff4e69:	41 83 3c b8 ff       	cmpl   $0xffffffff,(%r8,%rdi,4)
  ff4e6e:	0f 84 4f ff ff ff    	je     ff4dc3 <ir_optimize_licm+0x1103>
  ff4e74:	41 83 3c 80 ff       	cmpl   $0xffffffff,(%r8,%rax,4)
  ff4e79:	0f 84 44 ff ff ff    	je     ff4dc3 <ir_optimize_licm+0x1103>
  ff4e7f:	4c 8b 8c 24 e0 05 00 00 	mov    0x5e0(%rsp),%r9
  ff4e87:	45 8b 04 81          	mov    (%r9,%rax,4),%r8d
  ff4e8b:	45 39 04 b9          	cmp    %r8d,(%r9,%rdi,4)
  ff4e8f:	0f 87 2e ff ff ff    	ja     ff4dc3 <ir_optimize_licm+0x1103>
  ff4e95:	4c 8b 8c 24 e8 05 00 00 	mov    0x5e8(%rsp),%r9
  ff4e9d:	31 f6                	xor    %esi,%esi
  ff4e9f:	45 3b 04 b9          	cmp    (%r9,%rdi,4),%r8d
  ff4ea3:	40 0f 92 c6          	setb   %sil
  ff4ea7:	e9 17 ff ff ff       	jmp    ff4dc3 <ir_optimize_licm+0x1103>
  ff4eac:	4d 85 ff             	test   %r15,%r15
  ff4eaf:	0f 94 c0             	sete   %al
  ff4eb2:	85 f6                	test   %esi,%esi
  ff4eb4:	0f 99 c1             	setns  %cl
  ff4eb7:	84 c8                	test   %cl,%al
  ff4eb9:	0f 84 9c 04 00 00    	je     ff535b <ir_optimize_licm+0x169b>
  ff4ebf:	83 bc 24 b8 00 00 00 00 	cmpl   $0x0,0xb8(%rsp)
  ff4ec7:	0f 84 af 04 00 00    	je     ff537c <ir_optimize_licm+0x16bc>
  ff4ecd:	48 8b 84 24 58 06 00 00 	mov    0x658(%rsp),%rax
  ff4ed5:	4c 8b 84 24 40 06 00 00 	mov    0x640(%rsp),%r8
  ff4edd:	48 8b 8c 24 98 02 00 00 	mov    0x298(%rsp),%rcx
  ff4ee5:	31 d2                	xor    %edx,%edx
  ff4ee7:	4c 89 64 24 60       	mov    %r12,0x60(%rsp)
  ff4eec:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  ff4ef1:	4c 89 44 24 58       	mov    %r8,0x58(%rsp)
  ff4ef6:	eb 29                	jmp    ff4f21 <ir_optimize_licm+0x1261>
  ff4ef8:	8b 94 24 90 00 00 00 	mov    0x90(%rsp),%edx
  ff4eff:	48 ff 84 24 a0 07 00 00 	incq   0x7a0(%rsp)
  ff4f07:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  ff4f0c:	ff c2                	inc    %edx
  ff4f0e:	3b 94 24 b8 00 00 00 	cmp    0xb8(%rsp),%edx
  ff4f15:	0f 92 c0             	setb   %al
  ff4f18:	41 84 c1             	test   %al,%r9b
  ff4f1b:	0f 84 55 04 00 00    	je     ff5376 <ir_optimize_licm+0x16b6>
  ff4f21:	8b 79 38             	mov    0x38(%rcx),%edi
  ff4f24:	48 85 ff             	test   %rdi,%rdi
  ff4f27:	0f 84 3f 04 00 00    	je     ff536c <ir_optimize_licm+0x16ac>
  ff4f2d:	89 94 24 90 00 00 00 	mov    %edx,0x90(%rsp)
  ff4f34:	ba 01 00 00 00       	mov    $0x1,%edx
  ff4f39:	45 31 d2             	xor    %r10d,%r10d
  ff4f3c:	45 31 f6             	xor    %r14d,%r14d
  ff4f3f:	45 31 c9             	xor    %r9d,%r9d
  ff4f42:	31 f6                	xor    %esi,%esi
  ff4f44:	e9 0c 01 00 00       	jmp    ff5055 <ir_optimize_licm+0x1395>
  ff4f49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  ff4f50:	31 db                	xor    %ebx,%ebx
  ff4f52:	45 31 e4             	xor    %r12d,%r12d
  ff4f55:	45 31 f6             	xor    %r14d,%r14d
  ff4f58:	8b 54 24 68          	mov    0x68(%rsp),%edx
  ff4f5c:	44 89 f0             	mov    %r14d,%eax
  ff4f5f:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  ff4f63:	41 f7 d6             	not    %r14d
  ff4f66:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  ff4f6b:	4c 8b ac 24 e8 00 00 00 	mov    0xe8(%rsp),%r13
  ff4f73:	21 d0                	and    %edx,%eax
  ff4f75:	c5 fb 92 c8          	kmovd  %eax,%k1
  ff4f79:	48 8b 41 20          	mov    0x20(%rcx),%rax
  ff4f7d:	62 f1 7e c9 6f 04 b0 	vmovdqu32 (%rax,%rsi,4),%zmm0{%k1}{z}
  ff4f84:	62 d2 7d 49 90 0c 80 	vpgatherdd (%r8,%zmm0,4),%zmm1{%k1}
  ff4f8b:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
  ff4f91:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  ff4f95:	c5 fb 93 c0          	kmovd  %k0,%eax
  ff4f99:	41 09 c6             	or     %eax,%r14d
  ff4f9c:	41 21 d6             	and    %edx,%r14d
  ff4f9f:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  ff4fa4:	44 89 f0             	mov    %r14d,%eax
  ff4fa7:	44 21 e0             	and    %r12d,%eax
  ff4faa:	41 f7 d4             	not    %r12d
  ff4fad:	c5 fb 92 c8          	kmovd  %eax,%k1
  ff4fb1:	48 8b 41 28          	mov    0x28(%rcx),%rax
  ff4fb5:	62 f1 7e c9 6f 04 b0 	vmovdqu32 (%rax,%rsi,4),%zmm0{%k1}{z}
  ff4fbc:	62 d2 7d 49 90 0c 80 	vpgatherdd (%r8,%zmm0,4),%zmm1{%k1}
  ff4fc3:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
  ff4fc9:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  ff4fcd:	c5 fb 93 c0          	kmovd  %k0,%eax
  ff4fd1:	41 09 c4             	or     %eax,%r12d
  ff4fd4:	45 21 f4             	and    %r14d,%r12d
  ff4fd7:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  ff4fdc:	44 89 e0             	mov    %r12d,%eax
  ff4fdf:	21 d8                	and    %ebx,%eax
  ff4fe1:	f7 d3                	not    %ebx
  ff4fe3:	c5 fb 92 c8          	kmovd  %eax,%k1
  ff4fe7:	48 8b 41 30          	mov    0x30(%rcx),%rax
  ff4feb:	62 f1 7e c9 6f 04 b0 	vmovdqu32 (%rax,%rsi,4),%zmm0{%k1}{z}
  ff4ff2:	62 d2 7d 49 90 0c 80 	vpgatherdd (%r8,%zmm0,4),%zmm1{%k1}
  ff4ff9:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
  ff4fff:	c5 fb 93 c0          	kmovd  %k0,%eax
  ff5003:	09 c3                	or     %eax,%ebx
  ff5005:	49 8d 04 b0          	lea    (%r8,%rsi,4),%rax
  ff5009:	44 21 e3             	and    %r12d,%ebx
  ff500c:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  ff5011:	c5 fb 92 cb          	kmovd  %ebx,%k1
  ff5015:	62 f1 7e 49 7f 28    	vmovdqu32 %zmm5,(%rax){%k1}
  ff501b:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
  ff5023:	48 01 84 24 a8 07 00 00 	add    %rax,0x7a8(%rsp)
  ff502b:	66 85 db             	test   %bx,%bx
  ff502e:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff5033:	8b 79 38             	mov    0x38(%rcx),%edi
  ff5036:	0f 95 c0             	setne  %al
  ff5039:	48 83 c6 10          	add    $0x10,%rsi
  ff503d:	49 83 c6 f0          	add    $0xfffffffffffffff0,%r14
  ff5041:	49 83 c2 40          	add    $0x40,%r10
  ff5045:	48 83 c2 10          	add    $0x10,%rdx
  ff5049:	41 08 c1             	or     %al,%r9b
  ff504c:	48 39 fe             	cmp    %rdi,%rsi
  ff504f:	0f 83 a3 fe ff ff    	jae    ff4ef8 <ir_optimize_licm+0x1238>
  ff5055:	48 89 fb             	mov    %rdi,%rbx
  ff5058:	48 29 f3             	sub    %rsi,%rbx
  ff505b:	b8 10 00 00 00       	mov    $0x10,%eax
  ff5060:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  ff5065:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  ff506a:	4c 89 74 24 50       	mov    %r14,0x50(%rsp)
  ff506f:	48 83 fb 10          	cmp    $0x10,%rbx
  ff5073:	48 0f 43 d8          	cmovae %rax,%rbx
  ff5077:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ff507c:	c4 e2 61 f7 c0       	shlx   %ebx,%eax,%eax
  ff5081:	48 89 9c 24 a0 00 00 00 	mov    %rbx,0xa0(%rsp)
  ff5089:	f7 d0                	not    %eax
  ff508b:	c5 fb 92 c8          	kmovd  %eax,%k1
  ff508f:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  ff5094:	62 d1 7e c9 6f 0c b0 	vmovdqu32 (%r8,%rsi,4),%zmm1{%k1}{z}
  ff509b:	62 f1 7f 89 6f 04 30 	vmovdqu8 (%rax,%rsi,1),%xmm0{%k1}{z}
  ff50a2:	62 f2 76 48 27 c9    	vptestnmd %zmm1,%zmm1,%k1
  ff50a8:	62 f2 7d 09 26 c0    	vptestmb %xmm0,%xmm0,%k0{%k1}
  ff50ae:	c5 fb 93 c0          	kmovd  %k0,%eax
  ff50b2:	c4 e2 60 f5 c0       	bzhi   %ebx,%eax,%eax
  ff50b7:	89 44 24 68          	mov    %eax,0x68(%rsp)
  ff50bb:	48 39 f7             	cmp    %rsi,%rdi
  ff50be:	0f 84 8c fe ff ff    	je     ff4f50 <ir_optimize_licm+0x1290>
  ff50c4:	4c 01 f7             	add    %r14,%rdi
  ff50c7:	4c 8b 01             	mov    (%rcx),%r8
  ff50ca:	41 bf 10 00 00 00    	mov    $0x10,%r15d
  ff50d0:	b8 01 00 00 00       	mov    $0x1,%eax
  ff50d5:	48 83 ff 10          	cmp    $0x10,%rdi
  ff50d9:	4c 0f 42 ff          	cmovb  %rdi,%r15
  ff50dd:	41 83 ff 02          	cmp    $0x2,%r15d
  ff50e1:	44 0f 42 f8          	cmovb  %eax,%r15d
  ff50e5:	4c 89 84 24 b0 00 00 00 	mov    %r8,0xb0(%rsp)
  ff50ed:	48 83 ff 02          	cmp    $0x2,%rdi
  ff50f1:	73 10                	jae    ff5103 <ir_optimize_licm+0x1443>
  ff50f3:	31 db                	xor    %ebx,%ebx
  ff50f5:	45 31 e4             	xor    %r12d,%r12d
  ff50f8:	45 31 f6             	xor    %r14d,%r14d
  ff50fb:	45 31 ed             	xor    %r13d,%r13d
  ff50fe:	e9 99 01 00 00       	jmp    ff529c <ir_optimize_licm+0x15dc>
  ff5103:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  ff5108:	41 83 e7 1e          	and    $0x1e,%r15d
  ff510c:	49 8d 3c 10          	lea    (%r8,%rdx,1),%rdi
  ff5110:	31 db                	xor    %ebx,%ebx
  ff5112:	45 31 e4             	xor    %r12d,%r12d
  ff5115:	45 31 f6             	xor    %r14d,%r14d
  ff5118:	45 31 ed             	xor    %r13d,%r13d
  ff511b:	eb 45                	jmp    ff5162 <ir_optimize_licm+0x14a2>
  ff511d:	0f 1f 00             	nopl   (%rax)
  ff5120:	44 89 c0             	mov    %r8d,%eax
  ff5123:	41 8d 55 01          	lea    0x1(%r13),%edx
  ff5127:	83 e0 01             	and    $0x1,%eax
  ff512a:	49 83 c5 02          	add    $0x2,%r13
  ff512e:	c4 e2 69 f7 c0       	shlx   %edx,%eax,%eax
  ff5133:	41 09 c6             	or     %eax,%r14d
  ff5136:	b8 01 01 00 00       	mov    $0x101,%eax
  ff513b:	c4 c2 78 f7 c0       	bextr  %eax,%r8d,%eax
  ff5140:	c4 e2 69 f7 c0       	shlx   %edx,%eax,%eax
  ff5145:	41 09 c4             	or     %eax,%r12d
  ff5148:	b8 02 01 00 00       	mov    $0x102,%eax
  ff514d:	c4 c2 78 f7 c0       	bextr  %eax,%r8d,%eax
  ff5152:	c4 e2 69 f7 c0       	shlx   %edx,%eax,%eax
  ff5157:	09 c3                	or     %eax,%ebx
  ff5159:	4d 39 fd             	cmp    %r15,%r13
  ff515c:	0f 84 25 01 00 00    	je     ff5287 <ir_optimize_licm+0x15c7>
  ff5162:	46 0f b6 4c 2f ff    	movzbl -0x1(%rdi,%r13,1),%r9d
  ff5168:	48 8d 05 91 26 52 ff 	lea    -0xadd96f(%rip),%rax        # 517800 <ir_operand_table>
  ff516f:	45 0f b6 04 01       	movzbl (%r9,%rax,1),%r8d
  ff5174:	4d 0f a3 cb          	bt     %r9,%r11
  ff5178:	72 5c                	jb     ff51d6 <ir_optimize_licm+0x1516>
  ff517a:	4c 8b 59 20          	mov    0x20(%rcx),%r11
  ff517e:	48 8d 05 3b 28 52 ff 	lea    -0xadd7c5(%rip),%rax        # 5179c0 <ir_optional_table>
  ff5185:	45 0f b6 0c 01       	movzbl (%r9,%rax,1),%r9d
  ff518a:	31 c0                	xor    %eax,%eax
  ff518c:	4d 01 d3             	add    %r10,%r11
  ff518f:	43 83 3c ab ff       	cmpl   $0xffffffff,(%r11,%r13,4)
  ff5194:	4c 8b 59 28          	mov    0x28(%rcx),%r11
  ff5198:	0f 95 c0             	setne  %al
  ff519b:	4d 01 d3             	add    %r10,%r11
  ff519e:	31 d2                	xor    %edx,%edx
  ff51a0:	43 83 3c ab ff       	cmpl   $0xffffffff,(%r11,%r13,4)
  ff51a5:	0f 95 c2             	setne  %dl
  ff51a8:	45 31 db             	xor    %r11d,%r11d
  ff51ab:	01 d2                	add    %edx,%edx
  ff51ad:	09 c2                	or     %eax,%edx
  ff51af:	48 8b 41 30          	mov    0x30(%rcx),%rax
  ff51b3:	4c 01 d0             	add    %r10,%rax
  ff51b6:	42 83 3c a8 ff       	cmpl   $0xffffffff,(%rax,%r13,4)
  ff51bb:	41 0f 95 c3          	setne  %r11b
  ff51bf:	41 c1 e3 02          	shl    $0x2,%r11d
  ff51c3:	41 09 d3             	or     %edx,%r11d
  ff51c6:	45 21 cb             	and    %r9d,%r11d
  ff51c9:	45 09 d8             	or     %r11d,%r8d
  ff51cc:	49 bb ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%r11
  ff51d6:	44 89 c0             	mov    %r8d,%eax
  ff51d9:	83 e0 01             	and    $0x1,%eax
  ff51dc:	46 0f b6 0c 2f       	movzbl (%rdi,%r13,1),%r9d
  ff51e1:	c4 e2 11 f7 c0       	shlx   %r13d,%eax,%eax
  ff51e6:	41 09 c6             	or     %eax,%r14d
  ff51e9:	b8 01 01 00 00       	mov    $0x101,%eax
  ff51ee:	c4 c2 78 f7 c0       	bextr  %eax,%r8d,%eax
  ff51f3:	c4 e2 11 f7 c0       	shlx   %r13d,%eax,%eax
  ff51f8:	41 09 c4             	or     %eax,%r12d
  ff51fb:	b8 02 01 00 00       	mov    $0x102,%eax
  ff5200:	c4 c2 78 f7 c0       	bextr  %eax,%r8d,%eax
  ff5205:	c4 e2 11 f7 c0       	shlx   %r13d,%eax,%eax
  ff520a:	09 c3                	or     %eax,%ebx
  ff520c:	48 8d 05 ed 25 52 ff 	lea    -0xadda13(%rip),%rax        # 517800 <ir_operand_table>
  ff5213:	4d 0f a3 cb          	bt     %r9,%r11
  ff5217:	45 0f b6 04 01       	movzbl (%r9,%rax,1),%r8d
  ff521c:	0f 82 fe fe ff ff    	jb     ff5120 <ir_optimize_licm+0x1460>
  ff5222:	48 8d 05 97 27 52 ff 	lea    -0xadd869(%rip),%rax        # 5179c0 <ir_optional_table>
  ff5229:	31 d2                	xor    %edx,%edx
  ff522b:	45 0f b6 0c 01       	movzbl (%r9,%rax,1),%r9d
  ff5230:	48 8b 41 20          	mov    0x20(%rcx),%rax
  ff5234:	4c 01 d0             	add    %r10,%rax
  ff5237:	42 83 7c a8 04 ff    	cmpl   $0xffffffff,0x4(%rax,%r13,4)
  ff523d:	48 8b 41 28          	mov    0x28(%rcx),%rax
  ff5241:	0f 95 c2             	setne  %dl
  ff5244:	4c 01 d0             	add    %r10,%rax
  ff5247:	45 31 db             	xor    %r11d,%r11d
  ff524a:	42 83 7c a8 04 ff    	cmpl   $0xffffffff,0x4(%rax,%r13,4)
  ff5250:	48 8b 41 30          	mov    0x30(%rcx),%rax
  ff5254:	41 0f 95 c3          	setne  %r11b
  ff5258:	4c 01 d0             	add    %r10,%rax
  ff525b:	45 01 db             	add    %r11d,%r11d
  ff525e:	41 09 d3             	or     %edx,%r11d
  ff5261:	31 d2                	xor    %edx,%edx
  ff5263:	42 83 7c a8 04 ff    	cmpl   $0xffffffff,0x4(%rax,%r13,4)
  ff5269:	0f 95 c2             	setne  %dl
  ff526c:	c1 e2 02             	shl    $0x2,%edx
  ff526f:	44 09 da             	or     %r11d,%edx
  ff5272:	49 bb ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%r11
  ff527c:	44 21 ca             	and    %r9d,%edx
  ff527f:	41 09 d0             	or     %edx,%r8d
  ff5282:	e9 99 fe ff ff       	jmp    ff5120 <ir_optimize_licm+0x1460>
  ff5287:	f6 44 24 40 01       	testb  $0x1,0x40(%rsp)
  ff528c:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  ff5291:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
  ff5296:	0f 84 bc fc ff ff    	je     ff4f58 <ir_optimize_licm+0x1298>
  ff529c:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
  ff52a4:	4d 8d 7c 35 00       	lea    0x0(%r13,%rsi,1),%r15
  ff52a9:	46 0f b6 04 38       	movzbl (%rax,%r15,1),%r8d
  ff52ae:	48 8d 05 4b 25 52 ff 	lea    -0xaddab5(%rip),%rax        # 517800 <ir_operand_table>
  ff52b5:	41 0f b6 04 00       	movzbl (%r8,%rax,1),%eax
  ff52ba:	4d 0f a3 c3          	bt     %r8,%r11
  ff52be:	72 4e                	jb     ff530e <ir_optimize_licm+0x164e>
  ff52c0:	4c 8b 49 20          	mov    0x20(%rcx),%r9
  ff52c4:	48 8d 15 f5 26 52 ff 	lea    -0xadd90b(%rip),%rdx        # 5179c0 <ir_optional_table>
  ff52cb:	31 ff                	xor    %edi,%edi
  ff52cd:	41 0f b6 14 10       	movzbl (%r8,%rdx,1),%edx
  ff52d2:	4c 8b 41 28          	mov    0x28(%rcx),%r8
  ff52d6:	43 83 3c b9 ff       	cmpl   $0xffffffff,(%r9,%r15,4)
  ff52db:	40 0f 95 c7          	setne  %dil
  ff52df:	45 31 c9             	xor    %r9d,%r9d
  ff52e2:	43 83 3c b8 ff       	cmpl   $0xffffffff,(%r8,%r15,4)
  ff52e7:	41 0f 95 c1          	setne  %r9b
  ff52eb:	45 31 c0             	xor    %r8d,%r8d
  ff52ee:	45 01 c9             	add    %r9d,%r9d
  ff52f1:	41 09 f9             	or     %edi,%r9d
  ff52f4:	48 8b 79 30          	mov    0x30(%rcx),%rdi
  ff52f8:	42 83 3c bf ff       	cmpl   $0xffffffff,(%rdi,%r15,4)
  ff52fd:	41 0f 95 c0          	setne  %r8b
  ff5301:	41 c1 e0 02          	shl    $0x2,%r8d
  ff5305:	45 09 c8             	or     %r9d,%r8d
  ff5308:	41 21 d0             	and    %edx,%r8d
  ff530b:	44 09 c0             	or     %r8d,%eax
  ff530e:	89 c7                	mov    %eax,%edi
  ff5310:	83 e7 01             	and    $0x1,%edi
  ff5313:	ba 01 01 00 00       	mov    $0x101,%edx
  ff5318:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  ff531d:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
  ff5322:	c4 e2 11 f7 ff       	shlx   %r13d,%edi,%edi
  ff5327:	41 09 fe             	or     %edi,%r14d
  ff532a:	c4 e2 68 f7 f8       	bextr  %edx,%eax,%edi
  ff532f:	c4 e2 11 f7 ff       	shlx   %r13d,%edi,%edi
  ff5334:	41 09 fc             	or     %edi,%r12d
  ff5337:	bf 02 01 00 00       	mov    $0x102,%edi
  ff533c:	c4 e2 40 f7 c0       	bextr  %edi,%eax,%eax
  ff5341:	c4 e2 11 f7 c0       	shlx   %r13d,%eax,%eax
  ff5346:	09 c3                	or     %eax,%ebx
  ff5348:	e9 0b fc ff ff       	jmp    ff4f58 <ir_optimize_licm+0x1298>
  ff534d:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff5352:	4d 85 ff             	test   %r15,%r15
  ff5355:	0f 84 64 fb ff ff    	je     ff4ebf <ir_optimize_licm+0x11ff>
  ff535b:	0f b6 84 24 88 00 00 00 	movzbl 0x88(%rsp),%eax
  ff5363:	08 84 24 b8 07 00 00 	or     %al,0x7b8(%rsp)
  ff536a:	eb 18                	jmp    ff5384 <ir_optimize_licm+0x16c4>
  ff536c:	48 ff 84 24 a0 07 00 00 	incq   0x7a0(%rsp)
  ff5374:	eb 34                	jmp    ff53aa <ir_optimize_licm+0x16ea>
  ff5376:	41 f6 c1 01          	test   $0x1,%r9b
  ff537a:	74 2e                	je     ff53aa <ir_optimize_licm+0x16ea>
  ff537c:	c6 84 24 b8 07 00 00 01 	movb   $0x1,0x7b8(%rsp)
  ff5384:	48 8d bc 24 98 02 00 00 	lea    0x298(%rsp),%rdi
  ff538c:	c5 f8 77             	vzeroupper
  ff538f:	e8 7c 68 01 00       	call   100bc10 <ir_licm_worklist>
  ff5394:	62 f2 7d 48 58 2d 76 a7 62 ff 	vpbroadcastd -0x9d588a(%rip),%zmm5        # 61fb14 <check_test_member_scaling.timed+0xa74>
  ff539e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  ff53a3:	62 f3 4d 48 25 f6 ff 	vpternlogd $0xff,%zmm6,%zmm6,%zmm6
  ff53aa:	41 8b 42 38          	mov    0x38(%r10),%eax
  ff53ae:	85 c0                	test   %eax,%eax
  ff53b0:	0f 84 af f5 ff ff    	je     ff4965 <ir_optimize_licm+0xca5>
  ff53b6:	31 c9                	xor    %ecx,%ecx
  ff53b8:	eb 0e                	jmp    ff53c8 <ir_optimize_licm+0x1708>
  ff53ba:	48 ff c1             	inc    %rcx
  ff53bd:	89 c2                	mov    %eax,%edx
  ff53bf:	48 39 d1             	cmp    %rdx,%rcx
  ff53c2:	0f 83 9d f5 ff ff    	jae    ff4965 <ir_optimize_licm+0xca5>
  ff53c8:	48 8b 94 24 58 06 00 00 	mov    0x658(%rsp),%rdx
  ff53d0:	80 3c 0a 00          	cmpb   $0x0,(%rdx,%rcx,1)
  ff53d4:	74 e4                	je     ff53ba <ir_optimize_licm+0x16fa>
  ff53d6:	48 8b 94 24 40 06 00 00 	mov    0x640(%rsp),%rdx
  ff53de:	83 3c 8a 00          	cmpl   $0x0,(%rdx,%rcx,4)
  ff53e2:	74 d6                	je     ff53ba <ir_optimize_licm+0x16fa>
  ff53e4:	48 8b 84 24 38 06 00 00 	mov    0x638(%rsp),%rax
  ff53ec:	44 89 24 88          	mov    %r12d,(%rax,%rcx,4)
  ff53f0:	41 8b 42 38          	mov    0x38(%r10),%eax
  ff53f4:	eb c4                	jmp    ff53ba <ir_optimize_licm+0x16fa>
  ff53f6:	48 c7 84 24 b0 00 00 00 00 00 00 00 	movq   $0x0,0xb0(%rsp)
  ff5402:	85 c0                	test   %eax,%eax
  ff5404:	0f 94 c1             	sete   %cl
  ff5407:	44 08 e1             	or     %r12b,%cl
  ff540a:	0f 85 cb 00 00 00    	jne    ff54db <ir_optimize_licm+0x181b>
  ff5410:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5415:	49 89 fa             	mov    %rdi,%r10
  ff5418:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff541e:	48 8b 0e             	mov    (%rsi),%rcx
  ff5421:	48 8b 46 08          	mov    0x8(%rsi),%rax
  ff5425:	48 8d 7c 08 3f       	lea    0x3f(%rax,%rcx,1),%rdi
  ff542a:	48 01 c8             	add    %rcx,%rax
  ff542d:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff5431:	48 39 c7             	cmp    %rax,%rdi
  ff5434:	0f 82 e9 04 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff543a:	48 89 f8             	mov    %rdi,%rax
  ff543d:	48 29 c8             	sub    %rcx,%rax
  ff5440:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  ff5444:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
  ff5449:	48 29 c1             	sub    %rax,%rcx
  ff544c:	0f 82 d1 04 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff5452:	48 39 d1             	cmp    %rdx,%rcx
  ff5455:	0f 82 c8 04 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff545b:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5460:	48 01 d0             	add    %rdx,%rax
  ff5463:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff5467:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff546b:	48 39 c8             	cmp    %rcx,%rax
  ff546e:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff5472:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff5476:	48 85 ff             	test   %rdi,%rdi
  ff5479:	0f 84 a4 04 00 00    	je     ff5923 <ir_optimize_licm+0x1c63>
  ff547f:	31 f6                	xor    %esi,%esi
  ff5481:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  ff5486:	4c 89 54 24 40       	mov    %r10,0x40(%rsp)
  ff548b:	48 89 bc 24 d0 00 00 00 	mov    %rdi,0xd0(%rsp)
  ff5493:	4d 89 c7             	mov    %r8,%r15
  ff5496:	4d 89 de             	mov    %r11,%r14
  ff5499:	c5 f8 77             	vzeroupper
  ff549c:	e8 ff 45 90 ff       	call   8f9aa0 <memset@plt>
  ff54a1:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff54a6:	4d 89 f3             	mov    %r14,%r11
  ff54a9:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  ff54ae:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
  ff54b3:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff54b8:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
  ff54bd:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  ff54c2:	4d 89 f8             	mov    %r15,%r8
  ff54c5:	8b 00                	mov    (%rax),%eax
  ff54c7:	eb 1e                	jmp    ff54e7 <ir_optimize_licm+0x1827>
  ff54c9:	4c 8b 84 24 98 02 00 00 	mov    0x298(%rsp),%r8
  ff54d1:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff54d6:	e9 55 f0 ff ff       	jmp    ff4530 <ir_optimize_licm+0x870>
  ff54db:	48 c7 84 24 d0 00 00 00 00 00 00 00 	movq   $0x0,0xd0(%rsp)
  ff54e7:	85 c0                	test   %eax,%eax
  ff54e9:	0f 94 c1             	sete   %cl
  ff54ec:	44 08 e1             	or     %r12b,%cl
  ff54ef:	0f 85 e8 00 00 00    	jne    ff55dd <ir_optimize_licm+0x191d>
  ff54f5:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff54fa:	48 89 7c 24 40       	mov    %rdi,0x40(%rsp)
  ff54ff:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff5505:	48 8b 16             	mov    (%rsi),%rdx
  ff5508:	48 8b 4e 08          	mov    0x8(%rsi),%rcx
  ff550c:	48 8d 7c 11 3f       	lea    0x3f(%rcx,%rdx,1),%rdi
  ff5511:	48 01 d1             	add    %rdx,%rcx
  ff5514:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff5518:	48 39 cf             	cmp    %rcx,%rdi
  ff551b:	0f 82 02 04 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff5521:	48 8b 76 10          	mov    0x10(%rsi),%rsi
  ff5525:	48 89 bc 24 90 00 00 00 	mov    %rdi,0x90(%rsp)
  ff552d:	48 29 d7             	sub    %rdx,%rdi
  ff5530:	48 29 fe             	sub    %rdi,%rsi
  ff5533:	0f 82 ea 03 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff5539:	89 c2                	mov    %eax,%edx
  ff553b:	48 c1 e2 02          	shl    $0x2,%rdx
  ff553f:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
  ff5544:	48 39 f2             	cmp    %rsi,%rdx
  ff5547:	0f 87 d6 03 00 00    	ja     ff5923 <ir_optimize_licm+0x1c63>
  ff554d:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5552:	48 01 d7             	add    %rdx,%rdi
  ff5555:	48 89 7e 08          	mov    %rdi,0x8(%rsi)
  ff5559:	48 8b 46 20          	mov    0x20(%rsi),%rax
  ff555d:	48 39 c7             	cmp    %rax,%rdi
  ff5560:	48 0f 46 f8          	cmovbe %rax,%rdi
  ff5564:	48 83 bc 24 90 00 00 00 00 	cmpq   $0x0,0x90(%rsp)
  ff556d:	48 89 7e 20          	mov    %rdi,0x20(%rsi)
  ff5571:	0f 84 ac 03 00 00    	je     ff5923 <ir_optimize_licm+0x1c63>
  ff5577:	48 8b bc 24 90 00 00 00 	mov    0x90(%rsp),%rdi
  ff557f:	31 f6                	xor    %esi,%esi
  ff5581:	4c 89 f3             	mov    %r14,%rbx
  ff5584:	4d 89 c7             	mov    %r8,%r15
  ff5587:	4d 89 de             	mov    %r11,%r14
  ff558a:	c5 f8 77             	vzeroupper
  ff558d:	e8 0e 45 90 ff       	call   8f9aa0 <memset@plt>
  ff5592:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff5597:	4d 89 f3             	mov    %r14,%r11
  ff559a:	49 89 de             	mov    %rbx,%r14
  ff559d:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  ff55a2:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff55a7:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
  ff55ac:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  ff55b1:	4d 89 f8             	mov    %r15,%r8
  ff55b4:	8b 00                	mov    (%rax),%eax
  ff55b6:	eb 31                	jmp    ff55e9 <ir_optimize_licm+0x1929>
  ff55b8:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff55bd:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff55c2:	e9 69 ef ff ff       	jmp    ff4530 <ir_optimize_licm+0x870>
  ff55c7:	48 c7 84 24 a0 00 00 00 00 00 00 00 	movq   $0x0,0xa0(%rsp)
  ff55d3:	4c 89 74 24 50       	mov    %r14,0x50(%rsp)
  ff55d8:	e9 39 01 00 00       	jmp    ff5716 <ir_optimize_licm+0x1a56>
  ff55dd:	48 c7 84 24 90 00 00 00 00 00 00 00 	movq   $0x0,0x90(%rsp)
  ff55e9:	85 c0                	test   %eax,%eax
  ff55eb:	0f 94 c1             	sete   %cl
  ff55ee:	44 08 e1             	or     %r12b,%cl
  ff55f1:	0f 85 65 01 00 00    	jne    ff575c <ir_optimize_licm+0x1a9c>
  ff55f7:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff55fc:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff5602:	48 8b 11             	mov    (%rcx),%rdx
  ff5605:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  ff5609:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
  ff560e:	48 01 d1             	add    %rdx,%rcx
  ff5611:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
  ff5615:	48 39 ce             	cmp    %rcx,%rsi
  ff5618:	0f 82 05 03 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff561e:	48 89 f1             	mov    %rsi,%rcx
  ff5621:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
  ff5626:	48 89 f3             	mov    %rsi,%rbx
  ff5629:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff562e:	48 29 d1             	sub    %rdx,%rcx
  ff5631:	48 89 7c 24 40       	mov    %rdi,0x40(%rsp)
  ff5636:	4c 89 9c 24 a8 00 00 00 	mov    %r11,0xa8(%rsp)
  ff563e:	4c 89 44 24 28       	mov    %r8,0x28(%rsp)
  ff5643:	48 8b 76 10          	mov    0x10(%rsi),%rsi
  ff5647:	48 29 ce             	sub    %rcx,%rsi
  ff564a:	0f 82 d3 02 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff5650:	89 c2                	mov    %eax,%edx
  ff5652:	48 c1 e2 02          	shl    $0x2,%rdx
  ff5656:	48 39 f2             	cmp    %rsi,%rdx
  ff5659:	0f 87 c4 02 00 00    	ja     ff5923 <ir_optimize_licm+0x1c63>
  ff565f:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5664:	48 01 d1             	add    %rdx,%rcx
  ff5667:	48 89 4e 08          	mov    %rcx,0x8(%rsi)
  ff566b:	48 8b 46 20          	mov    0x20(%rsi),%rax
  ff566f:	48 39 c1             	cmp    %rax,%rcx
  ff5672:	48 0f 46 c8          	cmovbe %rax,%rcx
  ff5676:	48 89 4e 20          	mov    %rcx,0x20(%rsi)
  ff567a:	48 85 db             	test   %rbx,%rbx
  ff567d:	0f 84 a0 02 00 00    	je     ff5923 <ir_optimize_licm+0x1c63>
  ff5683:	48 89 df             	mov    %rbx,%rdi
  ff5686:	31 f6                	xor    %esi,%esi
  ff5688:	c5 f8 77             	vzeroupper
  ff568b:	e8 10 44 90 ff       	call   8f9aa0 <memset@plt>
  ff5690:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff5695:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  ff569a:	4c 8b 9c 24 a8 00 00 00 	mov    0xa8(%rsp),%r11
  ff56a2:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
  ff56a7:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff56ac:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  ff56b1:	8b 00                	mov    (%rax),%eax
  ff56b3:	e9 ab 00 00 00       	jmp    ff5763 <ir_optimize_licm+0x1aa3>
  ff56b8:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  ff56bc:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff56c1:	48 89 f9             	mov    %rdi,%rcx
  ff56c4:	48 29 c1             	sub    %rax,%rcx
  ff56c7:	48 29 ce             	sub    %rcx,%rsi
  ff56ca:	0f 82 f2 01 00 00    	jb     ff58c2 <ir_optimize_licm+0x1c02>
  ff56d0:	48 c1 e2 02          	shl    $0x2,%rdx
  ff56d4:	4c 89 f0             	mov    %r14,%rax
  ff56d7:	48 39 f2             	cmp    %rsi,%rdx
  ff56da:	0f 87 9d ee ff ff    	ja     ff457d <ir_optimize_licm+0x8bd>
  ff56e0:	48 01 d1             	add    %rdx,%rcx
  ff56e3:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  ff56e7:	48 8b 43 20          	mov    0x20(%rbx),%rax
  ff56eb:	48 39 c1             	cmp    %rax,%rcx
  ff56ee:	48 0f 46 c8          	cmovbe %rax,%rcx
  ff56f2:	48 89 4b 20          	mov    %rcx,0x20(%rbx)
  ff56f6:	48 85 ff             	test   %rdi,%rdi
  ff56f9:	0f 84 c3 01 00 00    	je     ff58c2 <ir_optimize_licm+0x1c02>
  ff56ff:	31 f6                	xor    %esi,%esi
  ff5701:	4c 89 74 24 50       	mov    %r14,0x50(%rsp)
  ff5706:	48 89 bc 24 a0 00 00 00 	mov    %rdi,0xa0(%rsp)
  ff570e:	e8 8d 43 90 ff       	call   8f9aa0 <memset@plt>
  ff5713:	4d 89 e0             	mov    %r12,%r8
  ff5716:	41 8b 50 38          	mov    0x38(%r8),%edx
  ff571a:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff571f:	49 8d 40 38          	lea    0x38(%r8),%rax
  ff5723:	40 b6 01             	mov    $0x1,%sil
  ff5726:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  ff572b:	48 85 d2             	test   %rdx,%rdx
  ff572e:	0f 84 eb 00 00 00    	je     ff581f <ir_optimize_licm+0x1b5f>
  ff5734:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5739:	48 8b 0e             	mov    (%rsi),%rcx
  ff573c:	48 8b 46 08          	mov    0x8(%rsi),%rax
  ff5740:	48 8d 7c 08 3f       	lea    0x3f(%rax,%rcx,1),%rdi
  ff5745:	48 01 c8             	add    %rcx,%rax
  ff5748:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff574c:	48 39 c7             	cmp    %rax,%rdi
  ff574f:	0f 83 d4 00 00 00    	jae    ff5829 <ir_optimize_licm+0x1b69>
  ff5755:	31 ff                	xor    %edi,%edi
  ff5757:	e9 3d ee ff ff       	jmp    ff4599 <ir_optimize_licm+0x8d9>
  ff575c:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
  ff5761:	31 db                	xor    %ebx,%ebx
  ff5763:	85 c0                	test   %eax,%eax
  ff5765:	49 89 fa             	mov    %rdi,%r10
  ff5768:	0f 94 c1             	sete   %cl
  ff576b:	41 08 cc             	or     %cl,%r12b
  ff576e:	0f 85 56 01 00 00    	jne    ff58ca <ir_optimize_licm+0x1c0a>
  ff5774:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5779:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff577f:	48 8b 16             	mov    (%rsi),%rdx
  ff5782:	48 8b 4e 08          	mov    0x8(%rsi),%rcx
  ff5786:	48 8d 7c 11 3f       	lea    0x3f(%rcx,%rdx,1),%rdi
  ff578b:	48 01 d1             	add    %rdx,%rcx
  ff578e:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff5792:	48 39 cf             	cmp    %rcx,%rdi
  ff5795:	0f 82 88 01 00 00    	jb     ff5923 <ir_optimize_licm+0x1c63>
  ff579b:	48 8b 76 10          	mov    0x10(%rsi),%rsi
  ff579f:	48 89 f9             	mov    %rdi,%rcx
  ff57a2:	48 29 d1             	sub    %rdx,%rcx
  ff57a5:	48 89 9c 24 88 00 00 00 	mov    %rbx,0x88(%rsp)
  ff57ad:	4c 89 54 24 40       	mov    %r10,0x40(%rsp)
  ff57b2:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  ff57b7:	4c 89 9c 24 a8 00 00 00 	mov    %r11,0xa8(%rsp)
  ff57bf:	48 89 7c 24 38       	mov    %rdi,0x38(%rsp)
  ff57c4:	48 29 ce             	sub    %rcx,%rsi
  ff57c7:	0f 82 51 01 00 00    	jb     ff591e <ir_optimize_licm+0x1c5e>
  ff57cd:	89 c2                	mov    %eax,%edx
  ff57cf:	48 c1 e2 02          	shl    $0x2,%rdx
  ff57d3:	48 39 f2             	cmp    %rsi,%rdx
  ff57d6:	0f 87 42 01 00 00    	ja     ff591e <ir_optimize_licm+0x1c5e>
  ff57dc:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff57e1:	48 01 d1             	add    %rdx,%rcx
  ff57e4:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff57e9:	48 89 4e 08          	mov    %rcx,0x8(%rsi)
  ff57ed:	48 8b 46 20          	mov    0x20(%rsi),%rax
  ff57f1:	48 39 c1             	cmp    %rax,%rcx
  ff57f4:	48 0f 46 c8          	cmovbe %rax,%rcx
  ff57f8:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  ff57fe:	48 89 4e 20          	mov    %rcx,0x20(%rsi)
  ff5802:	0f 84 1b 01 00 00    	je     ff5923 <ir_optimize_licm+0x1c63>
  ff5808:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  ff580d:	31 f6                	xor    %esi,%esi
  ff580f:	4d 89 c4             	mov    %r8,%r12
  ff5812:	c5 f8 77             	vzeroupper
  ff5815:	e8 86 42 90 ff       	call   8f9aa0 <memset@plt>
  ff581a:	e9 dc 00 00 00       	jmp    ff58fb <ir_optimize_licm+0x1c3b>
  ff581f:	31 ff                	xor    %edi,%edi
  ff5821:	45 31 e4             	xor    %r12d,%r12d
  ff5824:	e9 75 ed ff ff       	jmp    ff459e <ir_optimize_licm+0x8de>
  ff5829:	48 89 f8             	mov    %rdi,%rax
  ff582c:	48 29 c8             	sub    %rcx,%rax
  ff582f:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  ff5833:	48 29 c1             	sub    %rax,%rcx
  ff5836:	0f 82 f9 00 00 00    	jb     ff5935 <ir_optimize_licm+0x1c75>
  ff583c:	48 c1 e2 02          	shl    $0x2,%rdx
  ff5840:	48 39 ca             	cmp    %rcx,%rdx
  ff5843:	0f 87 ec 00 00 00    	ja     ff5935 <ir_optimize_licm+0x1c75>
  ff5849:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff584e:	48 01 d0             	add    %rdx,%rax
  ff5851:	48 89 fb             	mov    %rdi,%rbx
  ff5854:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff5858:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff585c:	48 39 c8             	cmp    %rcx,%rax
  ff585f:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff5863:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff5867:	48 85 db             	test   %rbx,%rbx
  ff586a:	0f 84 03 02 00 00    	je     ff5a73 <ir_optimize_licm+0x1db3>
  ff5870:	48 89 df             	mov    %rbx,%rdi
  ff5873:	31 f6                	xor    %esi,%esi
  ff5875:	e8 26 42 90 ff       	call   8f9aa0 <memset@plt>
  ff587a:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff587f:	8b 10                	mov    (%rax),%edx
  ff5881:	48 85 d2             	test   %rdx,%rdx
  ff5884:	0f 84 00 02 00 00    	je     ff5a8a <ir_optimize_licm+0x1dca>
  ff588a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  ff588f:	48 8b 08             	mov    (%rax),%rcx
  ff5892:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff5896:	4c 8d 7c 08 3f       	lea    0x3f(%rax,%rcx,1),%r15
  ff589b:	48 01 c8             	add    %rcx,%rax
  ff589e:	49 83 e7 c0          	and    $0xffffffffffffffc0,%r15
  ff58a2:	49 39 c7             	cmp    %rax,%r15
  ff58a5:	0f 83 f7 01 00 00    	jae    ff5aa2 <ir_optimize_licm+0x1de2>
  ff58ab:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff58b0:	4d 89 e0             	mov    %r12,%r8
  ff58b3:	31 f6                	xor    %esi,%esi
  ff58b5:	45 31 d2             	xor    %r10d,%r10d
  ff58b8:	31 ff                	xor    %edi,%edi
  ff58ba:	49 89 dc             	mov    %rbx,%r12
  ff58bd:	e9 df ec ff ff       	jmp    ff45a1 <ir_optimize_licm+0x8e1>
  ff58c2:	4c 89 f0             	mov    %r14,%rax
  ff58c5:	e9 b3 ec ff ff       	jmp    ff457d <ir_optimize_licm+0x8bd>
  ff58ca:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff58d0:	40 84 f6             	test   %sil,%sil
  ff58d3:	74 4e                	je     ff5923 <ir_optimize_licm+0x1c63>
  ff58d5:	4d 89 c4             	mov    %r8,%r12
  ff58d8:	48 89 9c 24 88 00 00 00 	mov    %rbx,0x88(%rsp)
  ff58e0:	4c 89 54 24 40       	mov    %r10,0x40(%rsp)
  ff58e5:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  ff58ea:	4c 89 9c 24 a8 00 00 00 	mov    %r11,0xa8(%rsp)
  ff58f2:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
  ff58fb:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  ff5900:	48 8b 08             	mov    (%rax),%rcx
  ff5903:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff5907:	48 8d 54 08 3f       	lea    0x3f(%rax,%rcx,1),%rdx
  ff590c:	48 01 c8             	add    %rcx,%rax
  ff590f:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
  ff5913:	48 39 c2             	cmp    %rax,%rdx
  ff5916:	73 2c                	jae    ff5944 <ir_optimize_licm+0x1c84>
  ff5918:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff591e:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff5923:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff5928:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
  ff5930:	e9 01 e9 ff ff       	jmp    ff4236 <ir_optimize_licm+0x576>
  ff5935:	45 31 e4             	xor    %r12d,%r12d
  ff5938:	31 f6                	xor    %esi,%esi
  ff593a:	45 31 d2             	xor    %r10d,%r10d
  ff593d:	31 ff                	xor    %edi,%edi
  ff593f:	e9 5d ec ff ff       	jmp    ff45a1 <ir_optimize_licm+0x8e1>
  ff5944:	48 89 d0             	mov    %rdx,%rax
  ff5947:	48 29 c8             	sub    %rcx,%rax
  ff594a:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff594f:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
  ff5957:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff595b:	48 29 c1             	sub    %rax,%rcx
  ff595e:	72 b8                	jb     ff5918 <ir_optimize_licm+0x1c58>
  ff5960:	41 8b 54 24 48       	mov    0x48(%r12),%edx
  ff5965:	48 8d 14 95 04 00 00 00 	lea    0x4(,%rdx,4),%rdx
  ff596d:	48 39 ca             	cmp    %rcx,%rdx
  ff5970:	77 a6                	ja     ff5918 <ir_optimize_licm+0x1c58>
  ff5972:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5977:	48 01 d0             	add    %rdx,%rax
  ff597a:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff597e:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff5982:	48 39 c8             	cmp    %rcx,%rax
  ff5985:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff5989:	48 83 bc 24 c0 00 00 00 00 	cmpq   $0x0,0xc0(%rsp)
  ff5992:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff5996:	74 80                	je     ff5918 <ir_optimize_licm+0x1c58>
  ff5998:	48 8b bc 24 c0 00 00 00 	mov    0xc0(%rsp),%rdi
  ff59a0:	31 f6                	xor    %esi,%esi
  ff59a2:	31 db                	xor    %ebx,%ebx
  ff59a4:	c5 f8 77             	vzeroupper
  ff59a7:	e8 f4 40 90 ff       	call   8f9aa0 <memset@plt>
  ff59ac:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff59b1:	83 38 00             	cmpl   $0x0,(%rax)
  ff59b4:	0f 84 53 02 00 00    	je     ff5c0d <ir_optimize_licm+0x1f4d>
  ff59ba:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  ff59bf:	31 ff                	xor    %edi,%edi
  ff59c1:	45 31 f6             	xor    %r14d,%r14d
  ff59c4:	31 c0                	xor    %eax,%eax
  ff59c6:	eb 20                	jmp    ff59e8 <ir_optimize_licm+0x1d28>
  ff59c8:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
  ff59cd:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff59d0:	48 8d 7c 4f 01       	lea    0x1(%rdi,%rcx,2),%rdi
  ff59d5:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  ff59da:	48 ff c0             	inc    %rax
  ff59dd:	8b 09                	mov    (%rcx),%ecx
  ff59df:	48 39 c8             	cmp    %rcx,%rax
  ff59e2:	0f 83 56 01 00 00    	jae    ff5b3e <ir_optimize_licm+0x1e7e>
  ff59e8:	48 8b 8c 24 38 06 00 00 	mov    0x638(%rsp),%rcx
  ff59f0:	48 8b 94 24 c8 02 00 00 	mov    0x2c8(%rsp),%rdx
  ff59f8:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff59fb:	3b 0c 82             	cmp    (%rdx,%rax,4),%ecx
  ff59fe:	74 0b                	je     ff5a0b <ir_optimize_licm+0x1d4b>
  ff5a00:	ff 44 8e 04          	incl   0x4(%rsi,%rcx,4)
  ff5a04:	ff 84 24 90 07 00 00 	incl   0x790(%rsp)
  ff5a0b:	49 8b 0c 24          	mov    (%r12),%rcx
  ff5a0f:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  ff5a13:	83 f9 38             	cmp    $0x38,%ecx
  ff5a16:	74 18                	je     ff5a30 <ir_optimize_licm+0x1d70>
  ff5a18:	83 f9 32             	cmp    $0x32,%ecx
  ff5a1b:	74 ab                	je     ff59c8 <ir_optimize_licm+0x1d08>
  ff5a1d:	83 f9 2f             	cmp    $0x2f,%ecx
  ff5a20:	75 26                	jne    ff5a48 <ir_optimize_licm+0x1d88>
  ff5a22:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
  ff5a27:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff5a2a:	48 8d 3c 4f          	lea    (%rdi,%rcx,2),%rdi
  ff5a2e:	eb a5                	jmp    ff59d5 <ir_optimize_licm+0x1d15>
  ff5a30:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
  ff5a35:	83 3c 81 ff          	cmpl   $0xffffffff,(%rcx,%rax,4)
  ff5a39:	74 9a                	je     ff59d5 <ir_optimize_licm+0x1d15>
  ff5a3b:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
  ff5a40:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff5a43:	48 01 cf             	add    %rcx,%rdi
  ff5a46:	eb 8d                	jmp    ff59d5 <ir_optimize_licm+0x1d15>
  ff5a48:	80 c1 d3             	add    $0xd3,%cl
  ff5a4b:	80 f9 01             	cmp    $0x1,%cl
  ff5a4e:	77 85                	ja     ff59d5 <ir_optimize_licm+0x1d15>
  ff5a50:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
  ff5a55:	49 8b 94 24 90 00 00 00 	mov    0x90(%r12),%rdx
  ff5a5d:	49 ff c6             	inc    %r14
  ff5a60:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff5a63:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  ff5a67:	8b 4c ca 04          	mov    0x4(%rdx,%rcx,8),%ecx
  ff5a6b:	48 01 cf             	add    %rcx,%rdi
  ff5a6e:	e9 62 ff ff ff       	jmp    ff59d5 <ir_optimize_licm+0x1d15>
  ff5a73:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff5a78:	4d 89 e0             	mov    %r12,%r8
  ff5a7b:	31 f6                	xor    %esi,%esi
  ff5a7d:	45 31 d2             	xor    %r10d,%r10d
  ff5a80:	45 31 e4             	xor    %r12d,%r12d
  ff5a83:	31 ff                	xor    %edi,%edi
  ff5a85:	e9 17 eb ff ff       	jmp    ff45a1 <ir_optimize_licm+0x8e1>
  ff5a8a:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff5a8f:	45 31 d2             	xor    %r10d,%r10d
  ff5a92:	4d 89 e0             	mov    %r12,%r8
  ff5a95:	31 ff                	xor    %edi,%edi
  ff5a97:	40 b6 01             	mov    $0x1,%sil
  ff5a9a:	49 89 dc             	mov    %rbx,%r12
  ff5a9d:	e9 ff ea ff ff       	jmp    ff45a1 <ir_optimize_licm+0x8e1>
  ff5aa2:	4c 89 f8             	mov    %r15,%rax
  ff5aa5:	48 29 c8             	sub    %rcx,%rax
  ff5aa8:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff5aad:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff5ab1:	48 29 c1             	sub    %rax,%rcx
  ff5ab4:	0f 82 f1 fd ff ff    	jb     ff58ab <ir_optimize_licm+0x1beb>
  ff5aba:	48 c1 e2 02          	shl    $0x2,%rdx
  ff5abe:	48 39 ca             	cmp    %rcx,%rdx
  ff5ac1:	0f 87 e4 fd ff ff    	ja     ff58ab <ir_optimize_licm+0x1beb>
  ff5ac7:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5acc:	48 01 d0             	add    %rdx,%rax
  ff5acf:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff5ad3:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff5ad7:	48 39 c8             	cmp    %rcx,%rax
  ff5ada:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff5ade:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff5ae2:	4d 85 ff             	test   %r15,%r15
  ff5ae5:	0f 84 c0 fd ff ff    	je     ff58ab <ir_optimize_licm+0x1beb>
  ff5aeb:	4c 89 ff             	mov    %r15,%rdi
  ff5aee:	31 f6                	xor    %esi,%esi
  ff5af0:	e8 ab 3f 90 ff       	call   8f9aa0 <memset@plt>
  ff5af5:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  ff5afa:	8b 10                	mov    (%rax),%edx
  ff5afc:	48 85 d2             	test   %rdx,%rdx
  ff5aff:	0f 84 16 08 00 00    	je     ff631b <ir_optimize_licm+0x265b>
  ff5b05:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  ff5b0a:	48 8b 08             	mov    (%rax),%rcx
  ff5b0d:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff5b11:	4c 8d 74 08 3f       	lea    0x3f(%rax,%rcx,1),%r14
  ff5b16:	48 01 c8             	add    %rcx,%rax
  ff5b19:	49 83 e6 c0          	and    $0xffffffffffffffc0,%r14
  ff5b1d:	49 39 c6             	cmp    %rax,%r14
  ff5b20:	0f 83 d9 08 00 00    	jae    ff63ff <ir_optimize_licm+0x273f>
  ff5b26:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff5b2b:	4d 89 e0             	mov    %r12,%r8
  ff5b2e:	31 f6                	xor    %esi,%esi
  ff5b30:	45 31 d2             	xor    %r10d,%r10d
  ff5b33:	4c 89 ff             	mov    %r15,%rdi
  ff5b36:	49 89 dc             	mov    %rbx,%r12
  ff5b39:	e9 63 ea ff ff       	jmp    ff45a1 <ir_optimize_licm+0x8e1>
  ff5b3e:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff5b43:	48 89 f8             	mov    %rdi,%rax
  ff5b46:	4c 09 f0             	or     %r14,%rax
  ff5b49:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  ff5b4f:	48 89 bc 24 c8 00 00 00 	mov    %rdi,0xc8(%rsp)
  ff5b57:	48 c1 e8 20          	shr    $0x20,%rax
  ff5b5b:	0f 85 c2 fd ff ff    	jne    ff5923 <ir_optimize_licm+0x1c63>
  ff5b61:	48 83 bc 24 c8 00 00 00 00 	cmpq   $0x0,0xc8(%rsp)
  ff5b6a:	48 c7 84 24 e0 00 00 00 00 00 00 00 	movq   $0x0,0xe0(%rsp)
  ff5b76:	0f 84 b2 07 00 00    	je     ff632e <ir_optimize_licm+0x266e>
  ff5b7c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  ff5b81:	48 8b 08             	mov    (%rax),%rcx
  ff5b84:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff5b88:	48 8d 74 08 3f       	lea    0x3f(%rax,%rcx,1),%rsi
  ff5b8d:	48 01 c8             	add    %rcx,%rax
  ff5b90:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
  ff5b94:	48 89 74 24 78       	mov    %rsi,0x78(%rsp)
  ff5b99:	48 39 c6             	cmp    %rax,%rsi
  ff5b9c:	0f 82 76 fd ff ff    	jb     ff5918 <ir_optimize_licm+0x1c58>
  ff5ba2:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  ff5ba7:	48 29 c8             	sub    %rcx,%rax
  ff5baa:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff5baf:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff5bb3:	48 29 c1             	sub    %rax,%rcx
  ff5bb6:	0f 82 5c fd ff ff    	jb     ff5918 <ir_optimize_licm+0x1c58>
  ff5bbc:	48 8b 94 24 c8 00 00 00 	mov    0xc8(%rsp),%rdx
  ff5bc4:	48 8d 14 95 00 00 00 00 	lea    0x0(,%rdx,4),%rdx
  ff5bcc:	48 39 ca             	cmp    %rcx,%rdx
  ff5bcf:	0f 87 43 fd ff ff    	ja     ff5918 <ir_optimize_licm+0x1c58>
  ff5bd5:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff5bda:	48 01 d0             	add    %rdx,%rax
  ff5bdd:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff5be1:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff5be5:	48 39 c8             	cmp    %rcx,%rax
  ff5be8:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff5bec:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
  ff5bf2:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff5bf6:	0f 84 1c fd ff ff    	je     ff5918 <ir_optimize_licm+0x1c58>
  ff5bfc:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  ff5c01:	31 f6                	xor    %esi,%esi
  ff5c03:	e8 98 3e 90 ff       	call   8f9aa0 <memset@plt>
  ff5c08:	e9 36 07 00 00       	jmp    ff6343 <ir_optimize_licm+0x2683>
  ff5c0d:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
  ff5c16:	48 c7 84 24 c8 00 00 00 00 00 00 00 	movq   $0x0,0xc8(%rsp)
  ff5c22:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
  ff5c2e:	48 c7 84 24 e0 00 00 00 00 00 00 00 	movq   $0x0,0xe0(%rsp)
  ff5c3a:	41 83 7c 24 48 00    	cmpl   $0x0,0x48(%r12)
  ff5c40:	74 6d                	je     ff5caf <ir_optimize_licm+0x1fef>
  ff5c42:	48 83 7c 24 50 ff    	cmpq   $0xffffffffffffffff,0x50(%rsp)
  ff5c48:	74 33                	je     ff5c7d <ir_optimize_licm+0x1fbd>
  ff5c4a:	48 83 bc 24 a0 00 00 00 ff 	cmpq   $0xffffffffffffffff,0xa0(%rsp)
  ff5c53:	74 28                	je     ff5c7d <ir_optimize_licm+0x1fbd>
  ff5c55:	31 c0                	xor    %eax,%eax
  ff5c57:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  ff5c5c:	48 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%rsi
  ff5c64:	8b 0c 82             	mov    (%rdx,%rax,4),%ecx
  ff5c67:	01 4c 82 04          	add    %ecx,0x4(%rdx,%rax,4)
  ff5c6b:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
  ff5c6e:	48 ff c0             	inc    %rax
  ff5c71:	41 8b 5c 24 48       	mov    0x48(%r12),%ebx
  ff5c76:	48 39 d8             	cmp    %rbx,%rax
  ff5c79:	72 dc                	jb     ff5c57 <ir_optimize_licm+0x1f97>
  ff5c7b:	eb 32                	jmp    ff5caf <ir_optimize_licm+0x1fef>
  ff5c7d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  ff5c82:	31 c9                	xor    %ecx,%ecx
  ff5c84:	8b 00                	mov    (%rax),%eax
  ff5c86:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  ff5c8b:	89 c2                	mov    %eax,%edx
  ff5c8d:	48 8b bc 24 a0 00 00 00 	mov    0xa0(%rsp),%rdi
  ff5c95:	8b 44 8e 04          	mov    0x4(%rsi,%rcx,4),%eax
  ff5c99:	01 d0                	add    %edx,%eax
  ff5c9b:	89 44 8e 04          	mov    %eax,0x4(%rsi,%rcx,4)
  ff5c9f:	89 14 8f             	mov    %edx,(%rdi,%rcx,4)
  ff5ca2:	48 ff c1             	inc    %rcx
  ff5ca5:	41 8b 5c 24 48       	mov    0x48(%r12),%ebx
  ff5caa:	48 39 d9             	cmp    %rbx,%rcx
  ff5cad:	72 d7                	jb     ff5c86 <ir_optimize_licm+0x1fc6>
  ff5caf:	8b 94 24 00 03 00 00 	mov    0x300(%rsp),%edx
  ff5cb6:	85 d2                	test   %edx,%edx
  ff5cb8:	74 7b                	je     ff5d35 <ir_optimize_licm+0x2075>
  ff5cba:	49 8b 4c 24 40       	mov    0x40(%r12),%rcx
  ff5cbf:	4c 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%r10
  ff5cc7:	4c 8b 9c 24 a0 00 00 00 	mov    0xa0(%rsp),%r11
  ff5ccf:	4d 89 e1             	mov    %r12,%r9
  ff5cd2:	31 c0                	xor    %eax,%eax
  ff5cd4:	eb 11                	jmp    ff5ce7 <ir_optimize_licm+0x2027>
  ff5cd6:	8b 94 24 00 03 00 00 	mov    0x300(%rsp),%edx
  ff5cdd:	48 ff c0             	inc    %rax
  ff5ce0:	89 d6                	mov    %edx,%esi
  ff5ce2:	48 39 f0             	cmp    %rsi,%rax
  ff5ce5:	73 47                	jae    ff5d2e <ir_optimize_licm+0x206e>
  ff5ce7:	48 8b b4 24 48 03 00 00 	mov    0x348(%rsp),%rsi
  ff5cef:	8b 34 86             	mov    (%rsi,%rax,4),%esi
  ff5cf2:	8b 3c b1             	mov    (%rcx,%rsi,4),%edi
  ff5cf5:	3b 7c b1 04          	cmp    0x4(%rcx,%rsi,4),%edi
  ff5cf9:	72 0e                	jb     ff5d09 <ir_optimize_licm+0x2049>
  ff5cfb:	eb e0                	jmp    ff5cdd <ir_optimize_licm+0x201d>
  ff5cfd:	8b 54 b1 04          	mov    0x4(%rcx,%rsi,4),%edx
  ff5d01:	48 ff c7             	inc    %rdi
  ff5d04:	48 39 d7             	cmp    %rdx,%rdi
  ff5d07:	73 cd                	jae    ff5cd6 <ir_optimize_licm+0x2016>
  ff5d09:	48 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%rdx
  ff5d11:	8b 14 ba             	mov    (%rdx,%rdi,4),%edx
  ff5d14:	39 f2                	cmp    %esi,%edx
  ff5d16:	74 e5                	je     ff5cfd <ir_optimize_licm+0x203d>
  ff5d18:	41 8b 0c 93          	mov    (%r11,%rdx,4),%ecx
  ff5d1c:	44 8d 41 01          	lea    0x1(%rcx),%r8d
  ff5d20:	45 89 04 93          	mov    %r8d,(%r11,%rdx,4)
  ff5d24:	41 89 3c 8a          	mov    %edi,(%r10,%rcx,4)
  ff5d28:	49 8b 49 40          	mov    0x40(%r9),%rcx
  ff5d2c:	eb cf                	jmp    ff5cfd <ir_optimize_licm+0x203d>
  ff5d2e:	41 8b 59 48          	mov    0x48(%r9),%ebx
  ff5d32:	4d 89 cc             	mov    %r9,%r12
  ff5d35:	85 db                	test   %ebx,%ebx
  ff5d37:	0f 84 4f 02 00 00    	je     ff5f8c <ir_optimize_licm+0x22cc>
  ff5d3d:	31 c0                	xor    %eax,%eax
  ff5d3f:	31 c9                	xor    %ecx,%ecx
  ff5d41:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
  ff5d46:	eb 22                	jmp    ff5d6a <ir_optimize_licm+0x20aa>
  ff5d48:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  ff5d4d:	ff ca                	dec    %edx
  ff5d4f:	89 c6                	mov    %eax,%esi
  ff5d51:	ff c0                	inc    %eax
  ff5d53:	4c 89 7c 24 68       	mov    %r15,0x68(%rsp)
  ff5d58:	41 89 14 b7          	mov    %edx,(%r15,%rsi,4)
  ff5d5c:	41 8b 54 24 48       	mov    0x48(%r12),%edx
  ff5d61:	48 39 d1             	cmp    %rdx,%rcx
  ff5d64:	0f 83 f9 01 00 00    	jae    ff5f63 <ir_optimize_licm+0x22a3>
  ff5d6a:	48 8b 94 24 c0 00 00 00 	mov    0xc0(%rsp),%rdx
  ff5d72:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  ff5d75:	49 8b 54 24 40       	mov    0x40(%r12),%rdx
  ff5d7a:	8b 3c 8a             	mov    (%rdx,%rcx,4),%edi
  ff5d7d:	8b 54 8a 04          	mov    0x4(%rdx,%rcx,4),%edx
  ff5d81:	8d 77 01             	lea    0x1(%rdi),%esi
  ff5d84:	39 d6                	cmp    %edx,%esi
  ff5d86:	73 45                	jae    ff5dcd <ir_optimize_licm+0x210d>
  ff5d88:	41 89 f8             	mov    %edi,%r8d
  ff5d8b:	41 29 d0             	sub    %edx,%r8d
  ff5d8e:	89 f6                	mov    %esi,%esi
  ff5d90:	41 89 fa             	mov    %edi,%r10d
  ff5d93:	41 f7 d0             	not    %r8d
  ff5d96:	41 83 e0 07          	and    $0x7,%r8d
  ff5d9a:	74 38                	je     ff5dd4 <ir_optimize_licm+0x2114>
  ff5d9c:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  ff5da1:	eb 0b                	jmp    ff5dae <ir_optimize_licm+0x20ee>
  ff5da3:	48 ff c6             	inc    %rsi
  ff5da6:	41 ff c2             	inc    %r10d
  ff5da9:	41 ff c8             	dec    %r8d
  ff5dac:	74 2b                	je     ff5dd9 <ir_optimize_licm+0x2119>
  ff5dae:	4c 8b 8c 24 38 06 00 00 	mov    0x638(%rsp),%r9
  ff5db6:	45 89 d3             	mov    %r10d,%r11d
  ff5db9:	47 8b 0c 99          	mov    (%r9,%r11,4),%r9d
  ff5dbd:	4c 39 c9             	cmp    %r9,%rcx
  ff5dc0:	75 e1                	jne    ff5da3 <ir_optimize_licm+0x20e3>
  ff5dc2:	41 89 c1             	mov    %eax,%r9d
  ff5dc5:	ff c0                	inc    %eax
  ff5dc7:	47 89 14 8f          	mov    %r10d,(%r15,%r9,4)
  ff5dcb:	eb d6                	jmp    ff5da3 <ir_optimize_licm+0x20e3>
  ff5dcd:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  ff5dd2:	eb 15                	jmp    ff5de9 <ir_optimize_licm+0x2129>
  ff5dd4:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  ff5dd9:	41 89 d0             	mov    %edx,%r8d
  ff5ddc:	41 29 f8             	sub    %edi,%r8d
  ff5ddf:	41 83 c0 fe          	add    $0xfffffffe,%r8d
  ff5de3:	41 83 f8 07          	cmp    $0x7,%r8d
  ff5de7:	73 3c                	jae    ff5e25 <ir_optimize_licm+0x2165>
  ff5de9:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
  ff5dee:	4c 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%r10
  ff5df6:	41 8b 34 89          	mov    (%r9,%rcx,4),%esi
  ff5dfa:	48 ff c1             	inc    %rcx
  ff5dfd:	41 3b 34 89          	cmp    (%r9,%rcx,4),%esi
  ff5e01:	0f 83 41 ff ff ff    	jae    ff5d48 <ir_optimize_licm+0x2088>
  ff5e07:	41 8b 3c b2          	mov    (%r10,%rsi,4),%edi
  ff5e0b:	41 89 c0             	mov    %eax,%r8d
  ff5e0e:	ff c0                	inc    %eax
  ff5e10:	48 ff c6             	inc    %rsi
  ff5e13:	43 89 3c 87          	mov    %edi,(%r15,%r8,4)
  ff5e17:	41 8b 3c 89          	mov    (%r9,%rcx,4),%edi
  ff5e1b:	48 39 fe             	cmp    %rdi,%rsi
  ff5e1e:	72 e7                	jb     ff5e07 <ir_optimize_licm+0x2147>
  ff5e20:	e9 23 ff ff ff       	jmp    ff5d48 <ir_optimize_licm+0x2088>
  ff5e25:	89 d7                	mov    %edx,%edi
  ff5e27:	f7 df                	neg    %edi
  ff5e29:	4c 8d 04 b5 00 00 00 00 	lea    0x0(,%rsi,4),%r8
  ff5e31:	45 31 c9             	xor    %r9d,%r9d
  ff5e34:	48 01 f7             	add    %rsi,%rdi
  ff5e37:	eb 11                	jmp    ff5e4a <ir_optimize_licm+0x218a>
  ff5e39:	46 8d 54 0e 07       	lea    0x7(%rsi,%r9,1),%r10d
  ff5e3e:	49 83 c1 08          	add    $0x8,%r9
  ff5e42:	41 89 fb             	mov    %edi,%r11d
  ff5e45:	45 01 cb             	add    %r9d,%r11d
  ff5e48:	74 9f                	je     ff5de9 <ir_optimize_licm+0x2129>
  ff5e4a:	4c 8b 9c 24 38 06 00 00 	mov    0x638(%rsp),%r11
  ff5e52:	44 89 d3             	mov    %r10d,%ebx
  ff5e55:	45 8b 1c 9b          	mov    (%r11,%rbx,4),%r11d
  ff5e59:	4c 39 d9             	cmp    %r11,%rcx
  ff5e5c:	75 09                	jne    ff5e67 <ir_optimize_licm+0x21a7>
  ff5e5e:	41 89 c3             	mov    %eax,%r11d
  ff5e61:	ff c0                	inc    %eax
  ff5e63:	47 89 14 9f          	mov    %r10d,(%r15,%r11,4)
  ff5e67:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff5e6f:	4d 01 c2             	add    %r8,%r10
  ff5e72:	47 8b 14 8a          	mov    (%r10,%r9,4),%r10d
  ff5e76:	4c 39 d1             	cmp    %r10,%rcx
  ff5e79:	75 0d                	jne    ff5e88 <ir_optimize_licm+0x21c8>
  ff5e7b:	41 89 c3             	mov    %eax,%r11d
  ff5e7e:	46 8d 14 0e          	lea    (%rsi,%r9,1),%r10d
  ff5e82:	ff c0                	inc    %eax
  ff5e84:	47 89 14 9f          	mov    %r10d,(%r15,%r11,4)
  ff5e88:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff5e90:	4d 01 c2             	add    %r8,%r10
  ff5e93:	47 8b 54 8a 04       	mov    0x4(%r10,%r9,4),%r10d
  ff5e98:	4c 39 d1             	cmp    %r10,%rcx
  ff5e9b:	75 0e                	jne    ff5eab <ir_optimize_licm+0x21eb>
  ff5e9d:	46 8d 54 0e 01       	lea    0x1(%rsi,%r9,1),%r10d
  ff5ea2:	41 89 c3             	mov    %eax,%r11d
  ff5ea5:	ff c0                	inc    %eax
  ff5ea7:	47 89 14 9f          	mov    %r10d,(%r15,%r11,4)
  ff5eab:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff5eb3:	4d 01 c2             	add    %r8,%r10
  ff5eb6:	47 8b 54 8a 08       	mov    0x8(%r10,%r9,4),%r10d
  ff5ebb:	4c 39 d1             	cmp    %r10,%rcx
  ff5ebe:	75 0e                	jne    ff5ece <ir_optimize_licm+0x220e>
  ff5ec0:	46 8d 54 0e 02       	lea    0x2(%rsi,%r9,1),%r10d
  ff5ec5:	41 89 c3             	mov    %eax,%r11d
  ff5ec8:	ff c0                	inc    %eax
  ff5eca:	47 89 14 9f          	mov    %r10d,(%r15,%r11,4)
  ff5ece:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff5ed6:	4d 01 c2             	add    %r8,%r10
  ff5ed9:	47 8b 54 8a 0c       	mov    0xc(%r10,%r9,4),%r10d
  ff5ede:	4c 39 d1             	cmp    %r10,%rcx
  ff5ee1:	75 0e                	jne    ff5ef1 <ir_optimize_licm+0x2231>
  ff5ee3:	46 8d 54 0e 03       	lea    0x3(%rsi,%r9,1),%r10d
  ff5ee8:	41 89 c3             	mov    %eax,%r11d
  ff5eeb:	ff c0                	inc    %eax
  ff5eed:	47 89 14 9f          	mov    %r10d,(%r15,%r11,4)
  ff5ef1:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff5ef9:	4d 01 c2             	add    %r8,%r10
  ff5efc:	47 8b 54 8a 10       	mov    0x10(%r10,%r9,4),%r10d
  ff5f01:	4c 39 d1             	cmp    %r10,%rcx
  ff5f04:	75 0e                	jne    ff5f14 <ir_optimize_licm+0x2254>
  ff5f06:	46 8d 54 0e 04       	lea    0x4(%rsi,%r9,1),%r10d
  ff5f0b:	41 89 c3             	mov    %eax,%r11d
  ff5f0e:	ff c0                	inc    %eax
  ff5f10:	47 89 14 9f          	mov    %r10d,(%r15,%r11,4)
  ff5f14:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff5f1c:	4d 01 c2             	add    %r8,%r10
  ff5f1f:	47 8b 54 8a 14       	mov    0x14(%r10,%r9,4),%r10d
  ff5f24:	4c 39 d1             	cmp    %r10,%rcx
  ff5f27:	75 0e                	jne    ff5f37 <ir_optimize_licm+0x2277>
  ff5f29:	46 8d 54 0e 05       	lea    0x5(%rsi,%r9,1),%r10d
  ff5f2e:	41 89 c3             	mov    %eax,%r11d
  ff5f31:	ff c0                	inc    %eax
  ff5f33:	47 89 14 9f          	mov    %r10d,(%r15,%r11,4)
  ff5f37:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff5f3f:	4d 01 c2             	add    %r8,%r10
  ff5f42:	47 8b 54 8a 18       	mov    0x18(%r10,%r9,4),%r10d
  ff5f47:	4c 39 d1             	cmp    %r10,%rcx
  ff5f4a:	0f 85 e9 fe ff ff    	jne    ff5e39 <ir_optimize_licm+0x2179>
  ff5f50:	46 8d 54 0e 06       	lea    0x6(%rsi,%r9,1),%r10d
  ff5f55:	41 89 c3             	mov    %eax,%r11d
  ff5f58:	ff c0                	inc    %eax
  ff5f5a:	47 89 14 9f          	mov    %r10d,(%r15,%r11,4)
  ff5f5e:	e9 d6 fe ff ff       	jmp    ff5e39 <ir_optimize_licm+0x2179>
  ff5f63:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
  ff5f6b:	89 04 91             	mov    %eax,(%rcx,%rdx,4)
  ff5f6e:	85 c0                	test   %eax,%eax
  ff5f70:	74 28                	je     ff5f9a <ir_optimize_licm+0x22da>
  ff5f72:	89 c1                	mov    %eax,%ecx
  ff5f74:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  ff5f79:	83 e1 07             	and    $0x7,%ecx
  ff5f7c:	83 f8 08             	cmp    $0x8,%eax
  ff5f7f:	0f 83 e0 04 00 00    	jae    ff6465 <ir_optimize_licm+0x27a5>
  ff5f85:	31 c0                	xor    %eax,%eax
  ff5f87:	e9 57 05 00 00       	jmp    ff64e3 <ir_optimize_licm+0x2823>
  ff5f8c:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
  ff5f94:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  ff5f9a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  ff5f9f:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  ff5fa4:	48 8b 8c 24 b0 00 00 00 	mov    0xb0(%rsp),%rcx
  ff5fac:	c5 fd 6f 84 24 00 01 00 00 	vmovdqa 0x100(%rsp),%ymm0
  ff5fb5:	c5 fe 6f 9c 24 14 01 00 00 	vmovdqu 0x114(%rsp),%ymm3
  ff5fbe:	62 f1 7c 48 10 8c 24 14 08 00 00 	vmovups 0x814(%rsp),%zmm1
  ff5fc9:	62 f1 fd 48 6f 54 24 1f 	vmovdqa64 0x7c0(%rsp),%zmm2
  ff5fd1:	4c 89 eb             	mov    %r13,%rbx
  ff5fd4:	48 33 5c 24 18       	xor    0x18(%rsp),%rbx
  ff5fd9:	48 8d bc 24 40 01 00 00 	lea    0x140(%rsp),%rdi
  ff5fe1:	48 89 bc 24 98 02 00 00 	mov    %rdi,0x298(%rsp)
  ff5fe9:	48 89 84 24 40 01 00 00 	mov    %rax,0x140(%rsp)
  ff5ff1:	48 89 94 24 48 01 00 00 	mov    %rdx,0x148(%rsp)
  ff5ff9:	48 89 8c 24 50 01 00 00 	mov    %rcx,0x150(%rsp)
  ff6001:	48 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%rdx
  ff6009:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
  ff6011:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
  ff6019:	48 89 94 24 58 01 00 00 	mov    %rdx,0x158(%rsp)
  ff6021:	48 89 8c 24 60 01 00 00 	mov    %rcx,0x160(%rsp)
  ff6029:	48 8b 94 24 88 00 00 00 	mov    0x88(%rsp),%rdx
  ff6031:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  ff6036:	48 89 94 24 68 01 00 00 	mov    %rdx,0x168(%rsp)
  ff603e:	48 89 8c 24 70 01 00 00 	mov    %rcx,0x170(%rsp)
  ff6046:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  ff604b:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
  ff6053:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
  ff605b:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
  ff6063:	48 8b 94 24 a8 00 00 00 	mov    0xa8(%rsp),%rdx
  ff606b:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  ff6070:	48 89 94 24 88 01 00 00 	mov    %rdx,0x188(%rsp)
  ff6078:	48 89 8c 24 90 01 00 00 	mov    %rcx,0x190(%rsp)
  ff6080:	89 84 24 98 01 00 00 	mov    %eax,0x198(%rsp)
  ff6087:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
  ff608f:	c5 fe 7f 84 24 9c 01 00 00 	vmovdqu %ymm0,0x19c(%rsp)
  ff6098:	c5 fe 7f 9c 24 b0 01 00 00 	vmovdqu %ymm3,0x1b0(%rsp)
  ff60a1:	48 89 84 24 d0 01 00 00 	mov    %rax,0x1d0(%rsp)
  ff60a9:	48 8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%rax
  ff60b1:	89 84 24 d8 01 00 00 	mov    %eax,0x1d8(%rsp)
  ff60b8:	62 f1 7c 48 11 8c 24 30 02 00 00 	vmovups %zmm1,0x230(%rsp)
  ff60c3:	62 f1 fd 48 6f 4c 24 20 	vmovdqa64 0x800(%rsp),%zmm1
  ff60cb:	62 f1 fe 48 7f 94 24 dc 01 00 00 	vmovdqu64 %zmm2,0x1dc(%rsp)
  ff60d6:	62 f1 fe 48 7f 8c 24 1c 02 00 00 	vmovdqu64 %zmm1,0x21c(%rsp)
  ff60e1:	c5 f8 77             	vzeroupper
  ff60e4:	e8 e7 c4 e2 ff       	call   e225d0 <ir_check_shape>
  ff60e9:	89 c1                	mov    %eax,%ecx
  ff60eb:	4c 8d 78 03          	lea    0x3(%rax),%r15
  ff60ef:	48 09 d9             	or     %rbx,%rcx
  ff60f2:	4c 0f 45 f8          	cmovne %rax,%r15
  ff60f6:	45 85 ff             	test   %r15d,%r15d
  ff60f9:	74 10                	je     ff610b <ir_optimize_licm+0x244b>
  ff60fb:	45 85 ff             	test   %r15d,%r15d
  ff60fe:	74 25                	je     ff6125 <ir_optimize_licm+0x2465>
  ff6100:	45 85 ff             	test   %r15d,%r15d
  ff6103:	0f 85 15 f8 ff ff    	jne    ff591e <ir_optimize_licm+0x1c5e>
  ff6109:	eb 45                	jmp    ff6150 <ir_optimize_licm+0x2490>
  ff610b:	48 8d bc 24 40 01 00 00 	lea    0x140(%rsp),%rdi
  ff6113:	be 01 00 00 00       	mov    $0x1,%esi
  ff6118:	e8 63 ca e2 ff       	call   e22b80 <ir_check_rows>
  ff611d:	49 89 c7             	mov    %rax,%r15
  ff6120:	45 85 ff             	test   %r15d,%r15d
  ff6123:	75 db                	jne    ff6100 <ir_optimize_licm+0x2440>
  ff6125:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff612a:	48 8d 8c 24 a0 02 00 00 	lea    0x2a0(%rsp),%rcx
  ff6132:	48 8d bc 24 40 01 00 00 	lea    0x140(%rsp),%rdi
  ff613a:	4c 89 ea             	mov    %r13,%rdx
  ff613d:	e8 fe dd e2 ff       	call   e23f40 <ir_cfg_validated>
  ff6142:	89 c0                	mov    %eax,%eax
  ff6144:	49 09 c7             	or     %rax,%r15
  ff6147:	45 85 ff             	test   %r15d,%r15d
  ff614a:	0f 85 ce f7 ff ff    	jne    ff591e <ir_optimize_licm+0x1c5e>
  ff6150:	83 bc 24 88 01 00 00 00 	cmpl   $0x0,0x188(%rsp)
  ff6158:	74 69                	je     ff61c3 <ir_optimize_licm+0x2503>
  ff615a:	31 c0                	xor    %eax,%eax
  ff615c:	eb 0f                	jmp    ff616d <ir_optimize_licm+0x24ad>
  ff615e:	8b 8c 24 88 01 00 00 	mov    0x188(%rsp),%ecx
  ff6165:	48 ff c0             	inc    %rax
  ff6168:	48 39 c8             	cmp    %rcx,%rax
  ff616b:	73 56                	jae    ff61c3 <ir_optimize_licm+0x2503>
  ff616d:	48 8b 8c 24 50 03 00 00 	mov    0x350(%rsp),%rcx
  ff6175:	48 8b 94 24 d0 03 00 00 	mov    0x3d0(%rsp),%rdx
  ff617d:	83 3c 81 ff          	cmpl   $0xffffffff,(%rcx,%rax,4)
  ff6181:	0f 95 04 02          	setne  (%rdx,%rax,1)
  ff6185:	48 8b 94 24 a8 02 00 00 	mov    0x2a8(%rsp),%rdx
  ff618d:	8b 0c 82             	mov    (%rdx,%rax,4),%ecx
  ff6190:	3b 4c 82 04          	cmp    0x4(%rdx,%rax,4),%ecx
  ff6194:	73 c8                	jae    ff615e <ir_optimize_licm+0x249e>
  ff6196:	48 8b 94 24 d0 03 00 00 	mov    0x3d0(%rsp),%rdx
  ff619e:	48 8b b4 24 d8 03 00 00 	mov    0x3d8(%rsp),%rsi
  ff61a6:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx
  ff61aa:	88 14 0e             	mov    %dl,(%rsi,%rcx,1)
  ff61ad:	48 ff c1             	inc    %rcx
  ff61b0:	48 8b 94 24 a8 02 00 00 	mov    0x2a8(%rsp),%rdx
  ff61b8:	8b 54 82 04          	mov    0x4(%rdx,%rax,4),%edx
  ff61bc:	48 39 d1             	cmp    %rdx,%rcx
  ff61bf:	72 d5                	jb     ff6196 <ir_optimize_licm+0x24d6>
  ff61c1:	eb 9b                	jmp    ff615e <ir_optimize_licm+0x249e>
  ff61c3:	83 bc 24 78 01 00 00 00 	cmpl   $0x0,0x178(%rsp)
  ff61cb:	74 3f                	je     ff620c <ir_optimize_licm+0x254c>
  ff61cd:	31 c0                	xor    %eax,%eax
  ff61cf:	48 8b 8c 24 c0 03 00 00 	mov    0x3c0(%rsp),%rcx
  ff61d7:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  ff61db:	48 8b 8c 24 c8 02 00 00 	mov    0x2c8(%rsp),%rcx
  ff61e3:	48 8b 94 24 d0 03 00 00 	mov    0x3d0(%rsp),%rdx
  ff61eb:	48 8b b4 24 e0 03 00 00 	mov    0x3e0(%rsp),%rsi
  ff61f3:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff61f6:	0f b6 0c 0a          	movzbl (%rdx,%rcx,1),%ecx
  ff61fa:	88 0c 06             	mov    %cl,(%rsi,%rax,1)
  ff61fd:	48 ff c0             	inc    %rax
  ff6200:	8b 8c 24 78 01 00 00 	mov    0x178(%rsp),%ecx
  ff6207:	48 39 c8             	cmp    %rcx,%rax
  ff620a:	72 c3                	jb     ff61cf <ir_optimize_licm+0x250f>
  ff620c:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff6211:	4c 8d a4 24 60 06 00 00 	lea    0x660(%rsp),%r12
  ff6219:	48 8d bc 24 98 02 00 00 	lea    0x298(%rsp),%rdi
  ff6221:	48 b9 00 00 00 00 40 00 00 00 	movabs $0x4000000000,%rcx
  ff622b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  ff6230:	4c 89 ee             	mov    %r13,%rsi
  ff6233:	4d 89 e1             	mov    %r12,%r9
  ff6236:	48 89 da             	mov    %rbx,%rdx
  ff6239:	e8 c2 ed 00 00       	call   1005000 <ir_optimize_rewrite>
  ff623e:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff6243:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
  ff624b:	41 89 c7             	mov    %eax,%r15d
  ff624e:	85 c0                	test   %eax,%eax
  ff6250:	0f 85 e0 df ff ff    	jne    ff4236 <ir_optimize_licm+0x576>
  ff6256:	48 89 d9             	mov    %rbx,%rcx
  ff6259:	48 8b 5b 08          	mov    0x8(%rbx),%rbx
  ff625d:	48 8d bc 24 c0 07 00 00 	lea    0x7c0(%rsp),%rdi
  ff6265:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  ff6269:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  ff626e:	62 f1 fe 48 7f 84 24 58 0a 00 00 	vmovdqu64 %zmm0,0xa58(%rsp)
  ff6279:	62 f1 fe 48 7f 84 24 48 0a 00 00 	vmovdqu64 %zmm0,0xa48(%rsp)
  ff6284:	62 f1 fe 48 7f 84 24 08 0a 00 00 	vmovdqu64 %zmm0,0xa08(%rsp)
  ff628f:	62 f1 fe 48 7f 84 24 c8 09 00 00 	vmovdqu64 %zmm0,0x9c8(%rsp)
  ff629a:	62 f1 fe 48 7f 84 24 88 09 00 00 	vmovdqu64 %zmm0,0x988(%rsp)
  ff62a5:	62 f1 fe 48 7f 84 24 48 09 00 00 	vmovdqu64 %zmm0,0x948(%rsp)
  ff62b0:	62 f1 fe 48 7f 84 24 08 09 00 00 	vmovdqu64 %zmm0,0x908(%rsp)
  ff62bb:	62 f1 fe 48 7f 84 24 c8 08 00 00 	vmovdqu64 %zmm0,0x8c8(%rsp)
  ff62c6:	62 f1 fe 48 7f 84 24 88 08 00 00 	vmovdqu64 %zmm0,0x888(%rsp)
  ff62d1:	62 f1 fe 48 7f 84 24 48 08 00 00 	vmovdqu64 %zmm0,0x848(%rsp)
  ff62dc:	62 f1 fe 48 7f 84 24 08 08 00 00 	vmovdqu64 %zmm0,0x808(%rsp)
  ff62e7:	62 f1 fe 48 7f 84 24 c8 07 00 00 	vmovdqu64 %zmm0,0x7c8(%rsp)
  ff62f2:	4c 89 e6             	mov    %r12,%rsi
  ff62f5:	4c 89 ea             	mov    %r13,%rdx
  ff62f8:	c5 f8 77             	vzeroupper
  ff62fb:	e8 c0 dd 00 00       	call   10040c0 <ir_optimize_prepare>
  ff6300:	48 89 c1             	mov    %rax,%rcx
  ff6303:	48 89 94 24 d8 00 00 00 	mov    %rdx,0xd8(%rsp)
  ff630b:	85 c9                	test   %ecx,%ecx
  ff630d:	0f 84 75 05 00 00    	je     ff6888 <ir_optimize_licm+0x2bc8>
  ff6313:	49 89 c1             	mov    %rax,%r9
  ff6316:	e9 c5 05 00 00       	jmp    ff68e0 <ir_optimize_licm+0x2c20>
  ff631b:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff6320:	4d 89 e0             	mov    %r12,%r8
  ff6323:	4c 89 ff             	mov    %r15,%rdi
  ff6326:	45 31 d2             	xor    %r10d,%r10d
  ff6329:	e9 69 f7 ff ff       	jmp    ff5a97 <ir_optimize_licm+0x1dd7>
  ff632e:	48 c7 84 24 c8 00 00 00 00 00 00 00 	movq   $0x0,0xc8(%rsp)
  ff633a:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
  ff6343:	4d 85 f6             	test   %r14,%r14
  ff6346:	0f 84 2b 05 00 00    	je     ff6877 <ir_optimize_licm+0x2bb7>
  ff634c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  ff6351:	48 8b 08             	mov    (%rax),%rcx
  ff6354:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff6358:	48 8d 74 08 3f       	lea    0x3f(%rax,%rcx,1),%rsi
  ff635d:	48 01 c8             	add    %rcx,%rax
  ff6360:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
  ff6364:	48 89 b4 24 80 00 00 00 	mov    %rsi,0x80(%rsp)
  ff636c:	48 39 c6             	cmp    %rax,%rsi
  ff636f:	0f 82 a3 f5 ff ff    	jb     ff5918 <ir_optimize_licm+0x1c58>
  ff6375:	4a 8d 04 f5 00 00 00 00 	lea    0x0(,%r14,8),%rax
  ff637d:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  ff6381:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
  ff6389:	48 29 c8             	sub    %rcx,%rax
  ff638c:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff6391:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff6395:	48 29 c1             	sub    %rax,%rcx
  ff6398:	40 0f 92 c6          	setb   %sil
  ff639c:	48 39 ca             	cmp    %rcx,%rdx
  ff639f:	0f 97 c1             	seta   %cl
  ff63a2:	40 08 f1             	or     %sil,%cl
  ff63a5:	0f 85 6d f5 ff ff    	jne    ff5918 <ir_optimize_licm+0x1c58>
  ff63ab:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff63b0:	48 01 d0             	add    %rdx,%rax
  ff63b3:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff63b8:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  ff63be:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff63c2:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff63c6:	48 39 c8             	cmp    %rcx,%rax
  ff63c9:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff63cd:	48 83 bc 24 80 00 00 00 00 	cmpq   $0x0,0x80(%rsp)
  ff63d6:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff63da:	0f 84 43 f5 ff ff    	je     ff5923 <ir_optimize_licm+0x1c63>
  ff63e0:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
  ff63e8:	31 f6                	xor    %esi,%esi
  ff63ea:	e8 b1 36 90 ff       	call   8f9aa0 <memset@plt>
  ff63ef:	44 89 f0             	mov    %r14d,%eax
  ff63f2:	48 89 84 24 e0 00 00 00 	mov    %rax,0xe0(%rsp)
  ff63fa:	e9 3b f8 ff ff       	jmp    ff5c3a <ir_optimize_licm+0x1f7a>
  ff63ff:	4c 89 f0             	mov    %r14,%rax
  ff6402:	48 29 c8             	sub    %rcx,%rax
  ff6405:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff640a:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff640e:	48 29 c1             	sub    %rax,%rcx
  ff6411:	0f 82 48 04 00 00    	jb     ff685f <ir_optimize_licm+0x2b9f>
  ff6417:	48 c1 e2 02          	shl    $0x2,%rdx
  ff641b:	48 39 ca             	cmp    %rcx,%rdx
  ff641e:	0f 87 3b 04 00 00    	ja     ff685f <ir_optimize_licm+0x2b9f>
  ff6424:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff6429:	48 01 d0             	add    %rdx,%rax
  ff642c:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff6430:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff6434:	48 39 c8             	cmp    %rcx,%rax
  ff6437:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff643b:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff643f:	4d 85 f6             	test   %r14,%r14
  ff6442:	0f 84 de f6 ff ff    	je     ff5b26 <ir_optimize_licm+0x1e66>
  ff6448:	4c 89 f7             	mov    %r14,%rdi
  ff644b:	31 f6                	xor    %esi,%esi
  ff644d:	e8 4e 36 90 ff       	call   8f9aa0 <memset@plt>
  ff6452:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff6457:	4d 89 f2             	mov    %r14,%r10
  ff645a:	4d 89 e0             	mov    %r12,%r8
  ff645d:	4c 89 ff             	mov    %r15,%rdi
  ff6460:	e9 32 f6 ff ff       	jmp    ff5a97 <ir_optimize_licm+0x1dd7>
  ff6465:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
  ff646a:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
  ff646f:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  ff6474:	83 e2 f8             	and    $0xfffffff8,%edx
  ff6477:	31 c0                	xor    %eax,%eax
  ff6479:	41 8b 34 80          	mov    (%r8,%rax,4),%esi
  ff647d:	8d 78 01             	lea    0x1(%rax),%edi
  ff6480:	41 89 04 b1          	mov    %eax,(%r9,%rsi,4)
  ff6484:	41 8b 74 80 04       	mov    0x4(%r8,%rax,4),%esi
  ff6489:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff648d:	8d 78 02             	lea    0x2(%rax),%edi
  ff6490:	41 8b 74 80 08       	mov    0x8(%r8,%rax,4),%esi
  ff6495:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff6499:	8d 78 03             	lea    0x3(%rax),%edi
  ff649c:	41 8b 74 80 0c       	mov    0xc(%r8,%rax,4),%esi
  ff64a1:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff64a5:	8d 78 04             	lea    0x4(%rax),%edi
  ff64a8:	41 8b 74 80 10       	mov    0x10(%r8,%rax,4),%esi
  ff64ad:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff64b1:	8d 78 05             	lea    0x5(%rax),%edi
  ff64b4:	41 8b 74 80 14       	mov    0x14(%r8,%rax,4),%esi
  ff64b9:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff64bd:	8d 78 06             	lea    0x6(%rax),%edi
  ff64c0:	41 8b 74 80 18       	mov    0x18(%r8,%rax,4),%esi
  ff64c5:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff64c9:	8d 78 07             	lea    0x7(%rax),%edi
  ff64cc:	41 8b 74 80 1c       	mov    0x1c(%r8,%rax,4),%esi
  ff64d1:	48 83 c0 08          	add    $0x8,%rax
  ff64d5:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff64d9:	48 39 d0             	cmp    %rdx,%rax
  ff64dc:	75 9b                	jne    ff6479 <ir_optimize_licm+0x27b9>
  ff64de:	48 85 c9             	test   %rcx,%rcx
  ff64e1:	74 18                	je     ff64fb <ir_optimize_licm+0x283b>
  ff64e3:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  ff64e8:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  ff64ed:	8b 14 82             	mov    (%rdx,%rax,4),%edx
  ff64f0:	89 04 96             	mov    %eax,(%rsi,%rdx,4)
  ff64f3:	48 ff c0             	inc    %rax
  ff64f6:	48 ff c9             	dec    %rcx
  ff64f9:	75 ed                	jne    ff64e8 <ir_optimize_licm+0x2828>
  ff64fb:	45 31 e4             	xor    %r12d,%r12d
  ff64fe:	45 31 f6             	xor    %r14d,%r14d
  ff6501:	c7 44 24 50 00 00 00 00 	movl   $0x0,0x50(%rsp)
  ff6509:	eb 5c                	jmp    ff6567 <ir_optimize_licm+0x28a7>
  ff650b:	48 8b 84 24 88 00 00 00 	mov    0x88(%rsp),%rax
  ff6513:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
  ff6518:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  ff651d:	44 89 e2             	mov    %r12d,%edx
  ff6520:	46 89 24 b0          	mov    %r12d,(%rax,%r14,4)
  ff6524:	48 8d 3c 96          	lea    (%rsi,%rdx,4),%rdi
  ff6528:	49 8b 40 28          	mov    0x28(%r8),%rax
  ff652c:	49 8b 48 30          	mov    0x30(%r8),%rcx
  ff6530:	8b 34 98             	mov    (%rax,%rbx,4),%esi
  ff6533:	8b 0c 99             	mov    (%rcx,%rbx,4),%ecx
  ff6536:	48 c1 e6 02          	shl    $0x2,%rsi
  ff653a:	49 03 70 50          	add    0x50(%r8),%rsi
  ff653e:	4c 8d 7c 09 01       	lea    0x1(%rcx,%rcx,1),%r15
  ff6543:	48 01 c9             	add    %rcx,%rcx
  ff6546:	48 8d 14 8d 04 00 00 00 	lea    0x4(,%rcx,4),%rdx
  ff654e:	e8 7d 36 90 ff       	call   8f9bd0 <memcpy@plt>
  ff6553:	45 01 e7             	add    %r12d,%r15d
  ff6556:	45 89 fc             	mov    %r15d,%r12d
  ff6559:	49 ff c6             	inc    %r14
  ff655c:	4c 3b 74 24 30       	cmp    0x30(%rsp),%r14
  ff6561:	0f 84 33 fa ff ff    	je     ff5f9a <ir_optimize_licm+0x22da>
  ff6567:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  ff656c:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  ff6571:	48 ba ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%rdx
  ff657b:	42 8b 1c b0          	mov    (%rax,%r14,4),%ebx
  ff657f:	48 8b 01             	mov    (%rcx),%rax
  ff6582:	0f b6 0c 18          	movzbl (%rax,%rbx,1),%ecx
  ff6586:	48 8d 05 73 12 52 ff 	lea    -0xaded8d(%rip),%rax        # 517800 <ir_operand_table>
  ff658d:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
  ff6591:	48 0f a3 ca          	bt     %rcx,%rdx
  ff6595:	72 4e                	jb     ff65e5 <ir_optimize_licm+0x2925>
  ff6597:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  ff659c:	45 31 c0             	xor    %r8d,%r8d
  ff659f:	48 8d 15 1a 14 52 ff 	lea    -0xadebe6(%rip),%rdx        # 5179c0 <ir_optional_table>
  ff65a6:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
  ff65aa:	49 8b 71 20          	mov    0x20(%r9),%rsi
  ff65ae:	49 8b 79 28          	mov    0x28(%r9),%rdi
  ff65b2:	83 3c 9e ff          	cmpl   $0xffffffff,(%rsi,%rbx,4)
  ff65b6:	41 0f 95 c0          	setne  %r8b
  ff65ba:	31 f6                	xor    %esi,%esi
  ff65bc:	83 3c 9f ff          	cmpl   $0xffffffff,(%rdi,%rbx,4)
  ff65c0:	49 8b 79 30          	mov    0x30(%r9),%rdi
  ff65c4:	40 0f 95 c6          	setne  %sil
  ff65c8:	01 f6                	add    %esi,%esi
  ff65ca:	44 09 c6             	or     %r8d,%esi
  ff65cd:	45 31 c0             	xor    %r8d,%r8d
  ff65d0:	83 3c 9f ff          	cmpl   $0xffffffff,(%rdi,%rbx,4)
  ff65d4:	41 0f 95 c0          	setne  %r8b
  ff65d8:	41 c1 e0 02          	shl    $0x2,%r8d
  ff65dc:	41 09 f0             	or     %esi,%r8d
  ff65df:	41 21 d0             	and    %edx,%r8d
  ff65e2:	44 09 c0             	or     %r8d,%eax
  ff65e5:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  ff65ea:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  ff65ef:	42 88 0c 32          	mov    %cl,(%rdx,%r14,1)
  ff65f3:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  ff65f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  ff65fc:	0f b6 0c 19          	movzbl (%rcx,%rbx,1),%ecx
  ff6600:	42 88 0c 36          	mov    %cl,(%rsi,%r14,1)
  ff6604:	48 8b b4 24 b0 00 00 00 	mov    0xb0(%rsp),%rsi
  ff660c:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  ff6610:	0f b6 0c 19          	movzbl (%rcx,%rbx,1),%ecx
  ff6614:	42 88 0c 36          	mov    %cl,(%rsi,%r14,1)
  ff6618:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
  ff6620:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  ff6624:	0f b6 0c 19          	movzbl (%rcx,%rbx,1),%ecx
  ff6628:	42 88 0c 36          	mov    %cl,(%rsi,%r14,1)
  ff662c:	48 8d 0c 9d 00 00 00 00 	lea    0x0(,%rbx,4),%rcx
  ff6634:	48 8b 52 20          	mov    0x20(%rdx),%rdx
  ff6638:	48 01 ca             	add    %rcx,%rdx
  ff663b:	a8 01                	test   $0x1,%al
  ff663d:	74 0b                	je     ff664a <ir_optimize_licm+0x298a>
  ff663f:	8b 12                	mov    (%rdx),%edx
  ff6641:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  ff6646:	48 8d 14 96          	lea    (%rsi,%rdx,4),%rdx
  ff664a:	8b 12                	mov    (%rdx),%edx
  ff664c:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
  ff6654:	42 89 14 b6          	mov    %edx,(%rsi,%r14,4)
  ff6658:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  ff665d:	48 8b 52 28          	mov    0x28(%rdx),%rdx
  ff6661:	48 01 ca             	add    %rcx,%rdx
  ff6664:	a8 02                	test   $0x2,%al
  ff6666:	74 0b                	je     ff6673 <ir_optimize_licm+0x29b3>
  ff6668:	8b 12                	mov    (%rdx),%edx
  ff666a:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  ff666f:	48 8d 14 96          	lea    (%rsi,%rdx,4),%rdx
  ff6673:	8b 12                	mov    (%rdx),%edx
  ff6675:	48 8b b4 24 88 00 00 00 	mov    0x88(%rsp),%rsi
  ff667d:	42 89 14 b6          	mov    %edx,(%rsi,%r14,4)
  ff6681:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff6686:	48 03 4e 30          	add    0x30(%rsi),%rcx
  ff668a:	a8 04                	test   $0x4,%al
  ff668c:	74 0b                	je     ff6699 <ir_optimize_licm+0x29d9>
  ff668e:	8b 01                	mov    (%rcx),%eax
  ff6690:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  ff6695:	48 8d 0c 82          	lea    (%rdx,%rax,4),%rcx
  ff6699:	8b 01                	mov    (%rcx),%eax
  ff669b:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  ff66a0:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  ff66a5:	42 89 04 b2          	mov    %eax,(%rdx,%r14,4)
  ff66a9:	48 8b 01             	mov    (%rcx),%rax
  ff66ac:	0f b6 04 18          	movzbl (%rax,%rbx,1),%eax
  ff66b0:	83 f8 38             	cmp    $0x38,%eax
  ff66b3:	0f 84 91 00 00 00    	je     ff674a <ir_optimize_licm+0x2a8a>
  ff66b9:	83 f8 32             	cmp    $0x32,%eax
  ff66bc:	0f 84 49 fe ff ff    	je     ff650b <ir_optimize_licm+0x284b>
  ff66c2:	83 f8 2f             	cmp    $0x2f,%eax
  ff66c5:	0f 85 db 00 00 00    	jne    ff67a6 <ir_optimize_licm+0x2ae6>
  ff66cb:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
  ff66d3:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  ff66d8:	46 89 24 b0          	mov    %r12d,(%rax,%r14,4)
  ff66dc:	48 8b 41 28          	mov    0x28(%rcx),%rax
  ff66e0:	83 3c 98 00          	cmpl   $0x0,(%rax,%rbx,4)
  ff66e4:	0f 84 6f fe ff ff    	je     ff6559 <ir_optimize_licm+0x2899>
  ff66ea:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
  ff66ef:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
  ff66f4:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
  ff66f9:	31 c0                	xor    %eax,%eax
  ff66fb:	31 c9                	xor    %ecx,%ecx
  ff66fd:	49 8b 70 20          	mov    0x20(%r8),%rsi
  ff6701:	49 8b 78 50          	mov    0x50(%r8),%rdi
  ff6705:	41 8d 14 04          	lea    (%r12,%rax,1),%edx
  ff6709:	ff c1                	inc    %ecx
  ff670b:	8b 34 9e             	mov    (%rsi,%rbx,4),%esi
  ff670e:	01 c6                	add    %eax,%esi
  ff6710:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
  ff6713:	41 8d 7c 04 01       	lea    0x1(%r12,%rax,1),%edi
  ff6718:	41 89 34 92          	mov    %esi,(%r10,%rdx,4)
  ff671c:	49 8b 50 20          	mov    0x20(%r8),%rdx
  ff6720:	49 8b 70 50          	mov    0x50(%r8),%rsi
  ff6724:	8b 14 9a             	mov    (%rdx,%rbx,4),%edx
  ff6727:	8d 54 10 01          	lea    0x1(%rax,%rdx,1),%edx
  ff672b:	83 c0 02             	add    $0x2,%eax
  ff672e:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
  ff6731:	41 8b 14 91          	mov    (%r9,%rdx,4),%edx
  ff6735:	41 89 14 ba          	mov    %edx,(%r10,%rdi,4)
  ff6739:	49 8b 50 28          	mov    0x28(%r8),%rdx
  ff673d:	3b 0c 9a             	cmp    (%rdx,%rbx,4),%ecx
  ff6740:	72 bb                	jb     ff66fd <ir_optimize_licm+0x2a3d>
  ff6742:	41 01 c4             	add    %eax,%r12d
  ff6745:	e9 0f fe ff ff       	jmp    ff6559 <ir_optimize_licm+0x2899>
  ff674a:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  ff674f:	48 8b 40 28          	mov    0x28(%rax),%rax
  ff6753:	83 3c 98 ff          	cmpl   $0xffffffff,(%rax,%rbx,4)
  ff6757:	0f 84 fc fd ff ff    	je     ff6559 <ir_optimize_licm+0x2899>
  ff675d:	48 8b 84 24 88 00 00 00 	mov    0x88(%rsp),%rax
  ff6765:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  ff676a:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  ff676f:	46 89 24 b0          	mov    %r12d,(%rax,%r14,4)
  ff6773:	44 89 e0             	mov    %r12d,%eax
  ff6776:	48 8d 3c 81          	lea    (%rcx,%rax,4),%rdi
  ff677a:	49 8b 47 28          	mov    0x28(%r15),%rax
  ff677e:	49 8b 4f 30          	mov    0x30(%r15),%rcx
  ff6782:	8b 34 98             	mov    (%rax,%rbx,4),%esi
  ff6785:	8b 14 99             	mov    (%rcx,%rbx,4),%edx
  ff6788:	48 c1 e6 02          	shl    $0x2,%rsi
  ff678c:	49 03 77 50          	add    0x50(%r15),%rsi
  ff6790:	48 c1 e2 02          	shl    $0x2,%rdx
  ff6794:	e8 37 34 90 ff       	call   8f9bd0 <memcpy@plt>
  ff6799:	49 8b 47 30          	mov    0x30(%r15),%rax
  ff679d:	44 03 24 98          	add    (%rax,%rbx,4),%r12d
  ff67a1:	e9 b3 fd ff ff       	jmp    ff6559 <ir_optimize_licm+0x2899>
  ff67a6:	04 d3                	add    $0xd3,%al
  ff67a8:	3c 01                	cmp    $0x1,%al
  ff67aa:	0f 87 a9 fd ff ff    	ja     ff6559 <ir_optimize_licm+0x2899>
  ff67b0:	8b 54 24 50          	mov    0x50(%rsp),%edx
  ff67b4:	48 8b 8c 24 88 00 00 00 	mov    0x88(%rsp),%rcx
  ff67bc:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff67c1:	42 89 14 b1          	mov    %edx,(%rcx,%r14,4)
  ff67c5:	89 d0                	mov    %edx,%eax
  ff67c7:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  ff67cb:	48 8b 4e 28          	mov    0x28(%rsi),%rcx
  ff67cf:	48 8b 96 90 00 00 00 	mov    0x90(%rsi),%rdx
  ff67d6:	48 8b b4 24 80 00 00 00 	mov    0x80(%rsp),%rsi
  ff67de:	8b 0c 99             	mov    (%rcx,%rbx,4),%ecx
  ff67e1:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  ff67e5:	c5 fa 6f 04 ca       	vmovdqu (%rdx,%rcx,8),%xmm0
  ff67ea:	c5 fa 7f 04 c6       	vmovdqu %xmm0,(%rsi,%rax,8)
  ff67ef:	48 8b 4c ca 10       	mov    0x10(%rdx,%rcx,8),%rcx
  ff67f4:	44 89 24 c6          	mov    %r12d,(%rsi,%rax,8)
  ff67f8:	48 89 4c c6 10       	mov    %rcx,0x10(%rsi,%rax,8)
  ff67fd:	83 7c c6 04 00       	cmpl   $0x0,0x4(%rsi,%rax,8)
  ff6802:	74 52                	je     ff6856 <ir_optimize_licm+0x2b96>
  ff6804:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
  ff680c:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  ff6811:	4c 8b 54 24 60       	mov    0x60(%rsp),%r10
  ff6816:	4c 8b 5c 24 78       	mov    0x78(%rsp),%r11
  ff681b:	48 8d 0c c1          	lea    (%rcx,%rax,8),%rcx
  ff681f:	31 c0                	xor    %eax,%eax
  ff6821:	49 8b 71 28          	mov    0x28(%r9),%rsi
  ff6825:	4d 8b 81 90 00 00 00 	mov    0x90(%r9),%r8
  ff682c:	49 8b 79 50          	mov    0x50(%r9),%rdi
  ff6830:	41 8d 14 04          	lea    (%r12,%rax,1),%edx
  ff6834:	8b 34 9e             	mov    (%rsi,%rbx,4),%esi
  ff6837:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  ff683b:	41 8b 34 f0          	mov    (%r8,%rsi,8),%esi
  ff683f:	01 c6                	add    %eax,%esi
  ff6841:	ff c0                	inc    %eax
  ff6843:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
  ff6846:	41 8b 34 b2          	mov    (%r10,%rsi,4),%esi
  ff684a:	41 89 34 93          	mov    %esi,(%r11,%rdx,4)
  ff684e:	3b 41 04             	cmp    0x4(%rcx),%eax
  ff6851:	72 ce                	jb     ff6821 <ir_optimize_licm+0x2b61>
  ff6853:	41 01 c4             	add    %eax,%r12d
  ff6856:	ff 44 24 50          	incl   0x50(%rsp)
  ff685a:	e9 fa fc ff ff       	jmp    ff6559 <ir_optimize_licm+0x2899>
  ff685f:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff6864:	4d 89 e0             	mov    %r12,%r8
  ff6867:	31 f6                	xor    %esi,%esi
  ff6869:	4c 89 ff             	mov    %r15,%rdi
  ff686c:	45 31 d2             	xor    %r10d,%r10d
  ff686f:	49 89 dc             	mov    %rbx,%r12
  ff6872:	e9 2a dd ff ff       	jmp    ff45a1 <ir_optimize_licm+0x8e1>
  ff6877:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
  ff6883:	e9 b2 f3 ff ff       	jmp    ff5c3a <ir_optimize_licm+0x1f7a>
  ff6888:	c5 fa 6f 84 24 90 08 00 00 	vmovdqu 0x890(%rsp),%xmm0
  ff6891:	8b 84 24 a8 06 00 00 	mov    0x6a8(%rsp),%eax
  ff6898:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  ff689d:	48 8d 94 24 00 01 00 00 	lea    0x100(%rsp),%rdx
  ff68a5:	4c 89 e7             	mov    %r12,%rdi
  ff68a8:	c5 f9 7f 84 24 00 01 00 00 	vmovdqa %xmm0,0x100(%rsp)
  ff68b1:	89 84 24 10 01 00 00 	mov    %eax,0x110(%rsp)
  ff68b8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  ff68bd:	c7 84 24 14 01 00 00 00 00 00 00 	movl   $0x0,0x114(%rsp)
  ff68c8:	f6 d0                	not    %al
  ff68ca:	0f b6 c8             	movzbl %al,%ecx
  ff68cd:	83 e1 01             	and    $0x1,%ecx
  ff68d0:	e8 eb ae e2 ff       	call   e217c0 <ir_verify_path>
  ff68d5:	49 89 c1             	mov    %rax,%r9
  ff68d8:	48 89 94 24 d8 00 00 00 	mov    %rdx,0xd8(%rsp)
  ff68e0:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff68e5:	48 3b 59 08          	cmp    0x8(%rcx),%rbx
  ff68e9:	0f 87 a8 00 00 00    	ja     ff6997 <ir_optimize_licm+0x2cd7>
  ff68ef:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  ff68f4:	48 89 59 08          	mov    %rbx,0x8(%rcx)
  ff68f8:	45 85 c9             	test   %r9d,%r9d
  ff68fb:	74 08                	je     ff6905 <ir_optimize_licm+0x2c45>
  ff68fd:	45 89 cf             	mov    %r9d,%r15d
  ff6900:	e9 1e f0 ff ff       	jmp    ff5923 <ir_optimize_licm+0x1c63>
  ff6905:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
  ff690d:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
  ff6915:	4c 29 f3             	sub    %r14,%rbx
  ff6918:	48 89 9c 24 b0 07 00 00 	mov    %rbx,0x7b0(%rsp)
  ff6920:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  ff6925:	62 d1 7c 48 10 84 24 20 01 00 00 	vmovups 0x120(%r12),%zmm0
  ff6930:	62 f1 7c 48 11 81 20 01 00 00 	vmovups %zmm0,0x120(%rcx)
  ff693a:	62 d1 7c 48 10 44 24 04 	vmovups 0x100(%r12),%zmm0
  ff6942:	62 f1 7c 48 11 41 04 	vmovups %zmm0,0x100(%rcx)
  ff6949:	62 d1 fe 48 6f 04 24 	vmovdqu64 (%r12),%zmm0
  ff6950:	62 d1 fe 48 6f 4c 24 01 	vmovdqu64 0x40(%r12),%zmm1
  ff6958:	62 d1 fe 48 6f 54 24 02 	vmovdqu64 0x80(%r12),%zmm2
  ff6960:	62 d1 fe 48 6f 5c 24 03 	vmovdqu64 0xc0(%r12),%zmm3
  ff6968:	62 f1 fe 48 7f 59 03 	vmovdqu64 %zmm3,0xc0(%rcx)
  ff696f:	62 f1 fe 48 7f 51 02 	vmovdqu64 %zmm2,0x80(%rcx)
  ff6976:	62 f1 fe 48 7f 49 01 	vmovdqu64 %zmm1,0x40(%rcx)
  ff697d:	62 f1 fe 48 7f 01    	vmovdqu64 %zmm0,(%rcx)
  ff6983:	31 c9                	xor    %ecx,%ecx
  ff6985:	48 8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%rdx
  ff698d:	4c 3b 73 08          	cmp    0x8(%rbx),%r14
  ff6991:	0f 86 ca d8 ff ff    	jbe    ff4261 <ir_optimize_licm+0x5a1>
  ff6997:	48 8d 3d 90 4a 83 ff 	lea    -0x7cb570(%rip),%rdi        # 82b42e <pp_string_value.meaning+0xb844e>
  ff699e:	48 8d 35 2c 37 7c ff 	lea    -0x83c8d4(%rip),%rsi        # 7ba0d1 <pp_string_value.meaning+0x470f1>
  ff69a5:	48 8d 0d 40 37 7c ff 	lea    -0x83c8c0(%rip),%rcx        # 7ba0ec <pp_string_value.meaning+0x4710c>
  ff69ac:	ba 5b 01 00 00       	mov    $0x15b,%edx
  ff69b1:	c5 f8 77             	vzeroupper
  ff69b4:	e8 27 28 90 ff       	call   8f91e0 <__assert_fail@plt>
