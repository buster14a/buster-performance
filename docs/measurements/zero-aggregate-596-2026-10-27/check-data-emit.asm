
../head/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008e1b60 <check_data_emit>:
  8e1b60:	55                   	push   rbp
  8e1b61:	41 57                	push   r15
  8e1b63:	41 56                	push   r14
  8e1b65:	41 55                	push   r13
  8e1b67:	41 54                	push   r12
  8e1b69:	53                   	push   rbx
  8e1b6a:	48 81 ec f8 05 00 00 	sub    rsp,0x5f8
  8e1b71:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  8e1b78:	00 00 
  8e1b7a:	4c 8b ac 24 50 06 00 	mov    r13,QWORD PTR [rsp+0x650]
  8e1b81:	00 
  8e1b82:	48 8b 9c 24 48 06 00 	mov    rbx,QWORD PTR [rsp+0x648]
  8e1b89:	00 
  8e1b8a:	4c 8b 94 24 40 06 00 	mov    r10,QWORD PTR [rsp+0x640]
  8e1b91:	00 
  8e1b92:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e1b96:	48 89 84 24 f0 05 00 	mov    QWORD PTR [rsp+0x5f0],rax
  8e1b9d:	00 
  8e1b9e:	48 b8 00 00 00 00 ff 	movabs rax,0xffffffff00000000
  8e1ba5:	ff ff ff 
  8e1ba8:	49 39 da             	cmp    r10,rbx
  8e1bab:	49 89 45 00          	mov    QWORD PTR [r13+0x0],rax
  8e1baf:	41 c7 45 08 ff ff ff 	mov    DWORD PTR [r13+0x8],0xffffffff
  8e1bb6:	ff 
  8e1bb7:	c4 c1 7a 7f 45 0c    	vmovdqu XMMWORD PTR [r13+0xc],xmm0
  8e1bbd:	c4 c1 7a 7f 45 18    	vmovdqu XMMWORD PTR [r13+0x18],xmm0
  8e1bc3:	0f 94 c0             	sete   al
  8e1bc6:	81 f9 01 00 00 40    	cmp    ecx,0x40000001
  8e1bcc:	4d 8b 62 08          	mov    r12,QWORD PTR [r10+0x8]
  8e1bd0:	4c 8b 7b 08          	mov    r15,QWORD PTR [rbx+0x8]
  8e1bd4:	41 0f 93 c2          	setae  r10b
  8e1bd8:	41 08 c2             	or     r10b,al
  8e1bdb:	75 23                	jne    8e1c00 <check_data_emit+0xa0>
  8e1bdd:	85 c9                	test   ecx,ecx
  8e1bdf:	74 0a                	je     8e1beb <check_data_emit+0x8b>
  8e1be1:	48 85 d2             	test   rdx,rdx
  8e1be4:	74 1a                	je     8e1c00 <check_data_emit+0xa0>
  8e1be6:	4d 85 c0             	test   r8,r8
  8e1be9:	74 15                	je     8e1c00 <check_data_emit+0xa0>
  8e1beb:	48 8b ac 24 30 06 00 	mov    rbp,QWORD PTR [rsp+0x630]
  8e1bf2:	00 
  8e1bf3:	83 bd 18 01 00 00 00 	cmp    DWORD PTR [rbp+0x118],0x0
  8e1bfa:	0f 84 80 00 00 00    	je     8e1c80 <check_data_emit+0x120>
  8e1c00:	41 c7 45 00 01 00 00 	mov    DWORD PTR [r13+0x0],0x1
  8e1c07:	00 
  8e1c08:	4c 3b 7b 08          	cmp    r15,QWORD PTR [rbx+0x8]
  8e1c0c:	0f 87 cf 34 00 00    	ja     8e50e1 <check_data_emit+0x3581>
  8e1c12:	4c 89 7b 08          	mov    QWORD PTR [rbx+0x8],r15
  8e1c16:	41 83 7d 00 00       	cmp    DWORD PTR [r13+0x0],0x0
  8e1c1b:	74 46                	je     8e1c63 <check_data_emit+0x103>
  8e1c1d:	48 8b 84 24 40 06 00 	mov    rax,QWORD PTR [rsp+0x640]
  8e1c24:	00 
  8e1c25:	4c 3b 60 08          	cmp    r12,QWORD PTR [rax+0x8]
  8e1c29:	0f 87 b2 34 00 00    	ja     8e50e1 <check_data_emit+0x3581>
  8e1c2f:	4c 89 60 08          	mov    QWORD PTR [rax+0x8],r12
  8e1c33:	41 83 7d 00 00       	cmp    DWORD PTR [r13+0x0],0x0
  8e1c38:	0f 94 c0             	sete   al
  8e1c3b:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  8e1c42:	00 00 
  8e1c44:	48 3b 8c 24 f0 05 00 	cmp    rcx,QWORD PTR [rsp+0x5f0]
  8e1c4b:	00 
  8e1c4c:	75 2a                	jne    8e1c78 <check_data_emit+0x118>
  8e1c4e:	48 81 c4 f8 05 00 00 	add    rsp,0x5f8
  8e1c55:	5b                   	pop    rbx
  8e1c56:	41 5c                	pop    r12
  8e1c58:	41 5d                	pop    r13
  8e1c5a:	41 5e                	pop    r14
  8e1c5c:	41 5f                	pop    r15
  8e1c5e:	5d                   	pop    rbp
  8e1c5f:	c5 f8 77             	vzeroupper
  8e1c62:	c3                   	ret
  8e1c63:	b0 01                	mov    al,0x1
  8e1c65:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  8e1c6c:	00 00 
  8e1c6e:	48 3b 8c 24 f0 05 00 	cmp    rcx,QWORD PTR [rsp+0x5f0]
  8e1c75:	00 
  8e1c76:	74 d6                	je     8e1c4e <check_data_emit+0xee>
  8e1c78:	c5 f8 77             	vzeroupper
  8e1c7b:	e8 a0 bc ee ff       	call   7cd920 <__stack_chk_fail@plt>
  8e1c80:	8b 45 60             	mov    eax,DWORD PTR [rbp+0x60]
  8e1c83:	85 c0                	test   eax,eax
  8e1c85:	0f 84 75 ff ff ff    	je     8e1c00 <check_data_emit+0xa0>
  8e1c8b:	44 8b 95 b8 00 00 00 	mov    r10d,DWORD PTR [rbp+0xb8]
  8e1c92:	45 85 d2             	test   r10d,r10d
  8e1c95:	0f 84 65 ff ff ff    	je     8e1c00 <check_data_emit+0xa0>
  8e1c9b:	44 8b 9d e0 00 00 00 	mov    r11d,DWORD PTR [rbp+0xe0]
  8e1ca2:	45 85 db             	test   r11d,r11d
  8e1ca5:	0f 84 55 ff ff ff    	je     8e1c00 <check_data_emit+0xa0>
  8e1cab:	44 8b b5 f0 00 00 00 	mov    r14d,DWORD PTR [rbp+0xf0]
  8e1cb2:	45 85 f6             	test   r14d,r14d
  8e1cb5:	0f 84 45 ff ff ff    	je     8e1c00 <check_data_emit+0xa0>
  8e1cbb:	3b 45 64             	cmp    eax,DWORD PTR [rbp+0x64]
  8e1cbe:	0f 87 3c ff ff ff    	ja     8e1c00 <check_data_emit+0xa0>
  8e1cc4:	44 3b 95 bc 00 00 00 	cmp    r10d,DWORD PTR [rbp+0xbc]
  8e1ccb:	0f 87 2f ff ff ff    	ja     8e1c00 <check_data_emit+0xa0>
  8e1cd1:	44 3b 9d e4 00 00 00 	cmp    r11d,DWORD PTR [rbp+0xe4]
  8e1cd8:	0f 87 22 ff ff ff    	ja     8e1c00 <check_data_emit+0xa0>
  8e1cde:	44 3b b5 f4 00 00 00 	cmp    r14d,DWORD PTR [rbp+0xf4]
  8e1ce5:	0f 87 15 ff ff ff    	ja     8e1c00 <check_data_emit+0xa0>
  8e1ceb:	48 85 f6             	test   rsi,rsi
  8e1cee:	74 1f                	je     8e1d0f <check_data_emit+0x1af>
  8e1cf0:	83 be d8 00 00 00 00 	cmp    DWORD PTR [rsi+0xd8],0x0
  8e1cf7:	75 09                	jne    8e1d02 <check_data_emit+0x1a2>
  8e1cf9:	83 be a4 00 00 00 00 	cmp    DWORD PTR [rsi+0xa4],0x0
  8e1d00:	74 0d                	je     8e1d0f <check_data_emit+0x1af>
  8e1d02:	41 c7 45 00 02 00 00 	mov    DWORD PTR [r13+0x0],0x2
  8e1d09:	00 
  8e1d0a:	e9 f9 fe ff ff       	jmp    8e1c08 <check_data_emit+0xa8>
  8e1d0f:	48 89 7c 24 28       	mov    QWORD PTR [rsp+0x28],rdi
  8e1d14:	85 c9                	test   ecx,ecx
  8e1d16:	74 37                	je     8e1d4f <check_data_emit+0x1ef>
  8e1d18:	48 8b 03             	mov    rax,QWORD PTR [rbx]
  8e1d1b:	48 8b 7b 08          	mov    rdi,QWORD PTR [rbx+0x8]
  8e1d1f:	48 c7 44 24 70 00 00 	mov    QWORD PTR [rsp+0x70],0x0
  8e1d26:	00 00 
  8e1d28:	4c 8d 5c 07 07       	lea    r11,[rdi+rax*1+0x7]
  8e1d2d:	48 01 c7             	add    rdi,rax
  8e1d30:	49 83 e3 f8          	and    r11,0xfffffffffffffff8
  8e1d34:	4c 89 5c 24 68       	mov    QWORD PTR [rsp+0x68],r11
  8e1d39:	49 39 fb             	cmp    r11,rdi
  8e1d3c:	0f 83 de 2b 00 00    	jae    8e4920 <check_data_emit+0x2dc0>
  8e1d42:	41 c7 45 00 06 00 00 	mov    DWORD PTR [r13+0x0],0x6
  8e1d49:	00 
  8e1d4a:	e9 b9 fe ff ff       	jmp    8e1c08 <check_data_emit+0xa8>
  8e1d4f:	48 c7 44 24 70 00 00 	mov    QWORD PTR [rsp+0x70],0x0
  8e1d56:	00 00 
  8e1d58:	45 31 d2             	xor    r10d,r10d
  8e1d5b:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
  8e1d62:	00 00 
  8e1d64:	31 ed                	xor    ebp,ebp
  8e1d66:	4c 8b b4 24 30 06 00 	mov    r14,QWORD PTR [rsp+0x630]
  8e1d6d:	00 
  8e1d6e:	85 c9                	test   ecx,ecx
  8e1d70:	48 89 ac 24 d0 00 00 	mov    QWORD PTR [rsp+0xd0],rbp
  8e1d77:	00 
  8e1d78:	89 4c 24 64          	mov    DWORD PTR [rsp+0x64],ecx
  8e1d7c:	0f 94 c0             	sete   al
  8e1d7f:	45 85 d2             	test   r10d,r10d
  8e1d82:	41 0f 95 c3          	setne  r11b
  8e1d86:	41 08 c3             	or     r11b,al
  8e1d89:	0f 85 c5 2b 00 00    	jne    8e4954 <check_data_emit+0x2df4>
  8e1d8f:	89 c8                	mov    eax,ecx
  8e1d91:	48 89 84 24 08 01 00 	mov    QWORD PTR [rsp+0x108],rax
  8e1d98:	00 
  8e1d99:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e1d9d:	31 c0                	xor    eax,eax
  8e1d9f:	48 c7 84 24 98 00 00 	mov    QWORD PTR [rsp+0x98],0x0
  8e1da6:	00 00 00 00 00 
  8e1dab:	c7 44 24 7c 00 00 00 	mov    DWORD PTR [rsp+0x7c],0x0
  8e1db2:	00 
  8e1db3:	48 c7 44 24 70 00 00 	mov    QWORD PTR [rsp+0x70],0x0
  8e1dba:	00 00 
  8e1dbc:	48 89 b4 24 d8 00 00 	mov    QWORD PTR [rsp+0xd8],rsi
  8e1dc3:	00 
  8e1dc4:	44 89 8c 24 ac 00 00 	mov    DWORD PTR [rsp+0xac],r9d
  8e1dcb:	00 
  8e1dcc:	4c 89 84 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],r8
  8e1dd3:	00 
  8e1dd4:	48 89 94 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rdx
  8e1ddb:	00 
  8e1ddc:	4c 8d 1c 80          	lea    r11,[rax+rax*4]
  8e1de0:	48 89 84 24 f0 00 00 	mov    QWORD PTR [rsp+0xf0],rax
  8e1de7:	00 
  8e1de8:	48 8d 04 40          	lea    rax,[rax+rax*2]
  8e1dec:	4c 8b 53 08          	mov    r10,QWORD PTR [rbx+0x8]
  8e1df0:	48 c1 e0 04          	shl    rax,0x4
  8e1df4:	c4 a1 7e 7f 44 dd 00 	vmovdqu YMMWORD PTR [rbp+r11*8+0x0],ymm0
  8e1dfb:	4a c7 44 dd 20 00 00 	mov    QWORD PTR [rbp+r11*8+0x20],0x0
  8e1e02:	00 00 
  8e1e04:	4c 89 5c 24 18       	mov    QWORD PTR [rsp+0x18],r11
  8e1e09:	48 89 44 24 58       	mov    QWORD PTR [rsp+0x58],rax
  8e1e0e:	8b 04 02             	mov    eax,DWORD PTR [rdx+rax*1]
  8e1e11:	4c 89 94 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],r10
  8e1e18:	00 
  8e1e19:	41 89 c3             	mov    r11d,eax
  8e1e1c:	41 c1 eb 03          	shr    r11d,0x3
  8e1e20:	0f 84 89 00 00 00    	je     8e1eaf <check_data_emit+0x34f>
  8e1e26:	41 ba 00 00 00 00    	mov    r10d,0x0
  8e1e2c:	41 be 00 00 00 00    	mov    r14d,0x0
  8e1e32:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0x0
  8e1e39:	00 00 00 00 00 
  8e1e3e:	44 3b 5f 48          	cmp    r11d,DWORD PTR [rdi+0x48]
  8e1e42:	0f 83 c1 00 00 00    	jae    8e1f09 <check_data_emit+0x3a9>
  8e1e48:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
  8e1e4b:	42 0f b6 2c 1f       	movzx  ebp,BYTE PTR [rdi+r11*1]
  8e1e50:	48 89 7c 24 10       	mov    QWORD PTR [rsp+0x10],rdi
  8e1e55:	40 84 ed             	test   bpl,bpl
  8e1e58:	74 69                	je     8e1ec3 <check_data_emit+0x363>
  8e1e5a:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e1e5f:	4c 8b 57 10          	mov    r10,QWORD PTR [rdi+0x10]
  8e1e63:	40 80 fd 0f          	cmp    bpl,0xf
  8e1e67:	75 73                	jne    8e1edc <check_data_emit+0x37c>
  8e1e69:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e1e6e:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0x0
  8e1e75:	00 00 00 00 00 
  8e1e7a:	4c 8b 77 20          	mov    r14,QWORD PTR [rdi+0x20]
  8e1e7e:	43 8b 2c 9e          	mov    ebp,DWORD PTR [r14+r11*4]
  8e1e82:	41 be 00 00 00 00    	mov    r14d,0x0
  8e1e88:	89 6c 24 40          	mov    DWORD PTR [rsp+0x40],ebp
  8e1e8c:	c1 ed 03             	shr    ebp,0x3
  8e1e8f:	41 f6 04 2a 04       	test   BYTE PTR [r10+rbp*1],0x4
  8e1e94:	41 ba 00 00 00 00    	mov    r10d,0x0
  8e1e9a:	74 6d                	je     8e1f09 <check_data_emit+0x3a9>
  8e1e9c:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  8e1ea1:	83 e0 07             	and    eax,0x7
  8e1ea4:	0b 44 24 40          	or     eax,DWORD PTR [rsp+0x40]
  8e1ea8:	41 0f b6 2c 2a       	movzx  ebp,BYTE PTR [r10+rbp*1]
  8e1ead:	eb 4b                	jmp    8e1efa <check_data_emit+0x39a>
  8e1eaf:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0x0
  8e1eb6:	00 00 00 00 00 
  8e1ebb:	45 31 d2             	xor    r10d,r10d
  8e1ebe:	45 31 f6             	xor    r14d,r14d
  8e1ec1:	eb 46                	jmp    8e1f09 <check_data_emit+0x3a9>
  8e1ec3:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e1ec8:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0x0
  8e1ecf:	00 00 00 00 00 
  8e1ed4:	45 31 d2             	xor    r10d,r10d
  8e1ed7:	45 31 f6             	xor    r14d,r14d
  8e1eda:	eb 2d                	jmp    8e1f09 <check_data_emit+0x3a9>
  8e1edc:	43 f6 04 1a 04       	test   BYTE PTR [r10+r11*1],0x4
  8e1ee1:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e1ee6:	41 ba 00 00 00 00    	mov    r10d,0x0
  8e1eec:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0x0
  8e1ef3:	00 00 00 00 00 
  8e1ef8:	74 0f                	je     8e1f09 <check_data_emit+0x3a9>
  8e1efa:	44 0f b6 f5          	movzx  r14d,bpl
  8e1efe:	41 b2 01             	mov    r10b,0x1
  8e1f01:	48 89 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],rax
  8e1f08:	00 
  8e1f09:	48 8b 6c 24 58       	mov    rbp,QWORD PTR [rsp+0x58]
  8e1f0e:	44 89 f0             	mov    eax,r14d
  8e1f11:	25 fe 00 00 00       	and    eax,0xfe
  8e1f16:	44 89 74 24 50       	mov    DWORD PTR [rsp+0x50],r14d
  8e1f1b:	48 01 d5             	add    rbp,rdx
  8e1f1e:	83 f8 10             	cmp    eax,0x10
  8e1f21:	44 89 f0             	mov    eax,r14d
  8e1f24:	0f 94 44 24 10       	sete   BYTE PTR [rsp+0x10]
  8e1f29:	25 fb 00 00 00       	and    eax,0xfb
  8e1f2e:	48 89 6c 24 58       	mov    QWORD PTR [rsp+0x58],rbp
  8e1f33:	83 f8 08             	cmp    eax,0x8
  8e1f36:	0f 94 44 24 38       	sete   BYTE PTR [rsp+0x38]
  8e1f3b:	41 83 fe 0d          	cmp    r14d,0xd
  8e1f3f:	0f 94 44 24 48       	sete   BYTE PTR [rsp+0x48]
  8e1f44:	45 84 d2             	test   r10b,r10b
  8e1f47:	0f 84 31 31 00 00    	je     8e507e <check_data_emit+0x351e>
  8e1f4d:	48 8b 47 18          	mov    rax,QWORD PTR [rdi+0x18]
  8e1f51:	4c 8b 17             	mov    r10,QWORD PTR [rdi]
  8e1f54:	46 0f b6 34 18       	movzx  r14d,BYTE PTR [rax+r11*1]
  8e1f59:	0f b6 45 29          	movzx  eax,BYTE PTR [rbp+0x29]
  8e1f5d:	41 38 c6             	cmp    r14b,al
  8e1f60:	41 0f 47 c6          	cmova  eax,r14d
  8e1f64:	43 80 3c 1a 0f       	cmp    BYTE PTR [r10+r11*1],0xf
  8e1f69:	75 0c                	jne    8e1f77 <check_data_emit+0x417>
  8e1f6b:	4c 8b 57 20          	mov    r10,QWORD PTR [rdi+0x20]
  8e1f6f:	47 8b 1c 9a          	mov    r11d,DWORD PTR [r10+r11*4]
  8e1f73:	41 c1 eb 03          	shr    r11d,0x3
  8e1f77:	48 8b 7f 38          	mov    rdi,QWORD PTR [rdi+0x38]
  8e1f7b:	4c 8b 94 24 d0 00 00 	mov    r10,QWORD PTR [rsp+0xd0]
  8e1f82:	00 
  8e1f83:	4c 8b 74 24 18       	mov    r14,QWORD PTR [rsp+0x18]
  8e1f88:	4a 8b 3c df          	mov    rdi,QWORD PTR [rdi+r11*8]
  8e1f8c:	4c 8b 5c 24 58       	mov    r11,QWORD PTR [rsp+0x58]
  8e1f91:	4f 8d 34 f2          	lea    r14,[r10+r14*8]
  8e1f95:	4c 89 74 24 20       	mov    QWORD PTR [rsp+0x20],r14
  8e1f9a:	49 89 7e 08          	mov    QWORD PTR [r14+0x8],rdi
  8e1f9e:	4d 8b 53 10          	mov    r10,QWORD PTR [r11+0x10]
  8e1fa2:	4d 85 d2             	test   r10,r10
  8e1fa5:	74 18                	je     8e1fbf <check_data_emit+0x45f>
  8e1fa7:	49 8b 4a 08          	mov    rcx,QWORD PTR [r10+0x8]
  8e1fab:	48 85 c9             	test   rcx,rcx
  8e1fae:	74 0f                	je     8e1fbf <check_data_emit+0x45f>
  8e1fb0:	48 39 f9             	cmp    rcx,rdi
  8e1fb3:	0f 82 f0 30 00 00    	jb     8e50a9 <check_data_emit+0x3549>
  8e1fb9:	49 89 4e 08          	mov    QWORD PTR [r14+0x8],rcx
  8e1fbd:	eb 03                	jmp    8e1fc2 <check_data_emit+0x462>
  8e1fbf:	48 89 f9             	mov    rcx,rdi
  8e1fc2:	48 8b b4 24 30 06 00 	mov    rsi,QWORD PTR [rsp+0x630]
  8e1fc9:	00 
  8e1fca:	41 ba 03 00 00 00    	mov    r10d,0x3
  8e1fd0:	3c 20                	cmp    al,0x20
  8e1fd2:	0f 87 61 31 00 00    	ja     8e5139 <check_data_emit+0x35d9>
  8e1fd8:	48 ba 00 ff ff ff ff 	movabs rdx,0x1fffffffffffff00
  8e1fdf:	ff ff 1f 
  8e1fe2:	48 8d ba ff 00 00 00 	lea    rdi,[rdx+0xff]
  8e1fe9:	48 39 f9             	cmp    rcx,rdi
  8e1fec:	0f 87 47 31 00 00    	ja     8e5139 <check_data_emit+0x35d9>
  8e1ff2:	41 88 46 20          	mov    BYTE PTR [r14+0x20],al
  8e1ff6:	41 ba 05 00 00 00    	mov    r10d,0x5
  8e1ffc:	41 8b 43 04          	mov    eax,DWORD PTR [r11+0x4]
  8e2000:	48 85 c0             	test   rax,rax
  8e2003:	0f 84 30 31 00 00    	je     8e5139 <check_data_emit+0x35d9>
  8e2009:	44 39 c8             	cmp    eax,r9d
  8e200c:	0f 83 27 31 00 00    	jae    8e5139 <check_data_emit+0x35d9>
  8e2012:	41 8b 04 80          	mov    eax,DWORD PTR [r8+rax*4]
  8e2016:	48 85 c0             	test   rax,rax
  8e2019:	0f 84 1a 31 00 00    	je     8e5139 <check_data_emit+0x35d9>
  8e201f:	3b 86 b8 00 00 00    	cmp    eax,DWORD PTR [rsi+0xb8]
  8e2025:	0f 83 0e 31 00 00    	jae    8e5139 <check_data_emit+0x35d9>
  8e202b:	41 89 46 1c          	mov    DWORD PTR [r14+0x1c],eax
  8e202f:	48 8b 8e 88 00 00 00 	mov    rcx,QWORD PTR [rsi+0x88]
  8e2036:	0f b6 14 01          	movzx  edx,BYTE PTR [rcx+rax*1]
  8e203a:	83 e2 0f             	and    edx,0xf
  8e203d:	83 fa 06             	cmp    edx,0x6
  8e2040:	74 09                	je     8e204b <check_data_emit+0x4eb>
  8e2042:	83 fa 01             	cmp    edx,0x1
  8e2045:	0f 85 ee 30 00 00    	jne    8e5139 <check_data_emit+0x35d9>
  8e204b:	48 8b 96 90 00 00 00 	mov    rdx,QWORD PTR [rsi+0x90]
  8e2052:	80 3c 02 01          	cmp    BYTE PTR [rdx+rax*1],0x1
  8e2056:	0f 87 dd 30 00 00    	ja     8e5139 <check_data_emit+0x35d9>
  8e205c:	48 8b 56 70          	mov    rdx,QWORD PTR [rsi+0x70]
  8e2060:	83 3c 82 00          	cmp    DWORD PTR [rdx+rax*4],0x0
  8e2064:	0f 85 cf 30 00 00    	jne    8e5139 <check_data_emit+0x35d9>
  8e206a:	49 8b 43 10          	mov    rax,QWORD PTR [r11+0x10]
  8e206e:	48 c7 84 24 b0 01 00 	mov    QWORD PTR [rsp+0x1b0],0x0
  8e2075:	00 00 00 00 00 
  8e207a:	c7 84 24 ac 01 00 00 	mov    DWORD PTR [rsp+0x1ac],0x0
  8e2081:	00 00 00 00 
  8e2085:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
  8e208a:	48 85 c0             	test   rax,rax
  8e208d:	0f 84 ee 00 00 00    	je     8e2181 <check_data_emit+0x621>
  8e2093:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  8e2098:	41 8b 33             	mov    esi,DWORD PTR [r11]
  8e209b:	48 89 bc 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],rdi
  8e20a2:	00 
  8e20a3:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e20a8:	31 c9                	xor    ecx,ecx
  8e20aa:	45 31 c0             	xor    r8d,r8d
  8e20ad:	45 31 c9             	xor    r9d,r9d
  8e20b0:	8b 10                	mov    edx,DWORD PTR [rax]
  8e20b2:	83 e6 f8             	and    esi,0xfffffff8
  8e20b5:	83 e2 f8             	and    edx,0xfffffff8
  8e20b8:	c5 f8 77             	vzeroupper
  8e20bb:	e8 e0 41 90 00       	call   11e62a0 <type_compatible_at>
  8e20c0:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
  8e20c5:	83 79 1c 00          	cmp    DWORD PTR [rcx+0x1c],0x0
  8e20c9:	0f 85 c5 2f 00 00    	jne    8e5094 <check_data_emit+0x3534>
  8e20cf:	83 79 18 00          	cmp    DWORD PTR [rcx+0x18],0x0
  8e20d3:	0f 84 5e 01 00 00    	je     8e2237 <check_data_emit+0x6d7>
  8e20d9:	48 83 79 10 00       	cmp    QWORD PTR [rcx+0x10],0x0
  8e20de:	41 ba 02 00 00 00    	mov    r10d,0x2
  8e20e4:	0f 84 4f 30 00 00    	je     8e5139 <check_data_emit+0x35d9>
  8e20ea:	83 f8 01             	cmp    eax,0x1
  8e20ed:	0f 85 ac 2f 00 00    	jne    8e509f <check_data_emit+0x353f>
  8e20f3:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e20f8:	48 8b 74 24 40       	mov    rsi,QWORD PTR [rsp+0x40]
  8e20fd:	48 8d 8c 24 b0 01 00 	lea    rcx,[rsp+0x1b0]
  8e2104:	00 
  8e2105:	4c 8d 84 24 ac 01 00 	lea    r8,[rsp+0x1ac]
  8e210c:	00 
  8e210d:	48 89 da             	mov    rdx,rbx
  8e2110:	e8 7b 3c fa ff       	call   885d90 <check_initializer_live>
  8e2115:	8b 8c 24 ac 01 00 00 	mov    ecx,DWORD PTR [rsp+0x1ac]
  8e211c:	85 c0                	test   eax,eax
  8e211e:	0f 94 c2             	sete   dl
  8e2121:	48 85 c9             	test   rcx,rcx
  8e2124:	40 0f 95 c6          	setne  sil
  8e2128:	40 20 d6             	and    sil,dl
  8e212b:	40 80 fe 01          	cmp    sil,0x1
  8e212f:	0f 85 37 02 00 00    	jne    8e236c <check_data_emit+0x80c>
  8e2135:	48 8b 3b             	mov    rdi,QWORD PTR [rbx]
  8e2138:	48 8b 53 08          	mov    rdx,QWORD PTR [rbx+0x8]
  8e213c:	48 8d 44 3a 07       	lea    rax,[rdx+rdi*1+0x7]
  8e2141:	48 01 fa             	add    rdx,rdi
  8e2144:	48 83 e0 f8          	and    rax,0xfffffffffffffff8
  8e2148:	48 39 d0             	cmp    rax,rdx
  8e214b:	72 2d                	jb     8e217a <check_data_emit+0x61a>
  8e214d:	48 89 c6             	mov    rsi,rax
  8e2150:	48 29 fe             	sub    rsi,rdi
  8e2153:	48 8b 7b 10          	mov    rdi,QWORD PTR [rbx+0x10]
  8e2157:	48 8d 14 cd 00 00 00 	lea    rdx,[rcx*8+0x0]
  8e215e:	00 
  8e215f:	48 8d 14 52          	lea    rdx,[rdx+rdx*2]
  8e2163:	48 29 f7             	sub    rdi,rsi
  8e2166:	41 0f 92 c0          	setb   r8b
  8e216a:	48 39 fa             	cmp    rdx,rdi
  8e216d:	40 0f 97 c7          	seta   dil
  8e2171:	44 08 c7             	or     dil,r8b
  8e2174:	0f 84 2a 02 00 00    	je     8e23a4 <check_data_emit+0x844>
  8e217a:	31 c0                	xor    eax,eax
  8e217c:	e9 2a 02 00 00       	jmp    8e23ab <check_data_emit+0x84b>
  8e2181:	41 80 7b 28 01       	cmp    BYTE PTR [r11+0x28],0x1
  8e2186:	0f 85 c5 00 00 00    	jne    8e2251 <check_data_emit+0x6f1>
  8e218c:	48 8b 44 24 58       	mov    rax,QWORD PTR [rsp+0x58]
  8e2191:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
  8e2196:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  8e219a:	48 3b 42 08          	cmp    rax,QWORD PTR [rdx+0x8]
  8e219e:	0f 85 da 2e 00 00    	jne    8e507e <check_data_emit+0x351e>
  8e21a4:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
  8e21a9:	8b 52 1c             	mov    edx,DWORD PTR [rdx+0x1c]
  8e21ac:	0f b6 0c 11          	movzx  ecx,BYTE PTR [rcx+rdx*1]
  8e21b0:	80 e1 0f             	and    cl,0xf
  8e21b3:	48 85 c0             	test   rax,rax
  8e21b6:	0f 84 d0 01 00 00    	je     8e238c <check_data_emit+0x82c>
  8e21bc:	83 7c 24 50 08       	cmp    DWORD PTR [rsp+0x50],0x8
  8e21c1:	0f 85 b7 2e 00 00    	jne    8e507e <check_data_emit+0x351e>
  8e21c7:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  8e21cc:	48 83 7a 18 00       	cmp    QWORD PTR [rdx+0x18],0x0
  8e21d1:	0f 84 a7 2e 00 00    	je     8e507e <check_data_emit+0x351e>
  8e21d7:	41 ba 01 00 00 00    	mov    r10d,0x1
  8e21dd:	80 f9 01             	cmp    cl,0x1
  8e21e0:	0f 85 53 2f 00 00    	jne    8e5139 <check_data_emit+0x35d9>
  8e21e6:	48 8b 7b 08          	mov    rdi,QWORD PTR [rbx+0x8]
  8e21ea:	48 8b 4b 10          	mov    rcx,QWORD PTR [rbx+0x10]
  8e21ee:	48 29 f9             	sub    rcx,rdi
  8e21f1:	0f 82 0c 2f 00 00    	jb     8e5103 <check_data_emit+0x35a3>
  8e21f7:	48 39 c8             	cmp    rax,rcx
  8e21fa:	0f 87 03 2f 00 00    	ja     8e5103 <check_data_emit+0x35a3>
  8e2200:	48 01 f8             	add    rax,rdi
  8e2203:	48 03 3b             	add    rdi,QWORD PTR [rbx]
  8e2206:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
  8e220b:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
  8e220f:	48 89 39             	mov    QWORD PTR [rcx],rdi
  8e2212:	0f 84 71 2e 00 00    	je     8e5089 <check_data_emit+0x3529>
  8e2218:	48 8b 44 24 58       	mov    rax,QWORD PTR [rsp+0x58]
  8e221d:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
  8e2222:	48 8b 70 18          	mov    rsi,QWORD PTR [rax+0x18]
  8e2226:	48 8b 51 08          	mov    rdx,QWORD PTR [rcx+0x8]
  8e222a:	c5 f8 77             	vzeroupper
  8e222d:	e8 5e c0 ee ff       	call   7ce290 <memcpy@plt>
  8e2232:	e9 90 15 00 00       	jmp    8e37c7 <check_data_emit+0x1c67>
  8e2237:	83 f8 01             	cmp    eax,0x1
  8e223a:	0f 85 5f 2e 00 00    	jne    8e509f <check_data_emit+0x353f>
  8e2240:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x0
  8e2247:	00 00 00 00 00 
  8e224c:	e9 c6 01 00 00       	jmp    8e2417 <check_data_emit+0x8b7>
  8e2251:	0f b6 44 24 38       	movzx  eax,BYTE PTR [rsp+0x38]
  8e2256:	0a 44 24 10          	or     al,BYTE PTR [rsp+0x10]
  8e225a:	0a 44 24 48          	or     al,BYTE PTR [rsp+0x48]
  8e225e:	74 0f                	je     8e226f <check_data_emit+0x70f>
  8e2260:	48 8b 44 24 58       	mov    rax,QWORD PTR [rsp+0x58]
  8e2265:	83 78 08 ff          	cmp    DWORD PTR [rax+0x8],0xffffffff
  8e2269:	0f 84 58 15 00 00    	je     8e37c7 <check_data_emit+0x1c67>
  8e226f:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e2274:	48 8b b4 24 d8 00 00 	mov    rsi,QWORD PTR [rsp+0xd8]
  8e227b:	00 
  8e227c:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  8e2281:	48 8b 8c 24 b0 00 00 	mov    rcx,QWORD PTR [rsp+0xb0]
  8e2288:	00 
  8e2289:	44 8b 84 24 ac 00 00 	mov    r8d,DWORD PTR [rsp+0xac]
  8e2290:	00 
  8e2291:	4c 8b 8c 24 30 06 00 	mov    r9,QWORD PTR [rsp+0x630]
  8e2298:	00 
  8e2299:	48 8d 84 24 f0 01 00 	lea    rax,[rsp+0x1f0]
  8e22a0:	00 
  8e22a1:	48 89 04 24          	mov    QWORD PTR [rsp],rax
  8e22a5:	c5 f8 77             	vzeroupper
  8e22a8:	e8 83 2f 00 00       	call   8e5230 <check_data_plan_scalar>
  8e22ad:	89 c5                	mov    ebp,eax
  8e22af:	85 c0                	test   eax,eax
  8e22b1:	0f 85 05 15 00 00    	jne    8e37bc <check_data_emit+0x1c5c>
  8e22b7:	48 8b 7b 08          	mov    rdi,QWORD PTR [rbx+0x8]
  8e22bb:	48 8b 4b 10          	mov    rcx,QWORD PTR [rbx+0x10]
  8e22bf:	48 29 f9             	sub    rcx,rdi
  8e22c2:	0f 82 e0 0b 00 00    	jb     8e2ea8 <check_data_emit+0x1348>
  8e22c8:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e22cd:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  8e22d1:	48 39 c8             	cmp    rax,rcx
  8e22d4:	0f 87 ce 0b 00 00    	ja     8e2ea8 <check_data_emit+0x1348>
  8e22da:	48 01 f8             	add    rax,rdi
  8e22dd:	48 03 3b             	add    rdi,QWORD PTR [rbx]
  8e22e0:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
  8e22e5:	bd 06 00 00 00       	mov    ebp,0x6
  8e22ea:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
  8e22ee:	48 89 39             	mov    QWORD PTR [rcx],rdi
  8e22f1:	0f 84 c5 14 00 00    	je     8e37bc <check_data_emit+0x1c5c>
  8e22f7:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e22fc:	48 8d b4 24 f0 01 00 	lea    rsi,[rsp+0x1f0]
  8e2303:	00 
  8e2304:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  8e2308:	e8 83 bf ee ff       	call   7ce290 <memcpy@plt>
  8e230d:	8b 84 24 14 02 00 00 	mov    eax,DWORD PTR [rsp+0x214]
  8e2314:	85 c0                	test   eax,eax
  8e2316:	0f 84 9e 14 00 00    	je     8e37ba <check_data_emit+0x1c5a>
  8e231c:	48 8b 33             	mov    rsi,QWORD PTR [rbx]
  8e231f:	48 8b 53 08          	mov    rdx,QWORD PTR [rbx+0x8]
  8e2323:	48 8d 4c 32 07       	lea    rcx,[rdx+rsi*1+0x7]
  8e2328:	48 01 f2             	add    rdx,rsi
  8e232b:	48 83 e1 f8          	and    rcx,0xfffffffffffffff8
  8e232f:	48 39 d1             	cmp    rcx,rdx
  8e2332:	72 26                	jb     8e235a <check_data_emit+0x7fa>
  8e2334:	48 89 ca             	mov    rdx,rcx
  8e2337:	48 29 f2             	sub    rdx,rsi
  8e233a:	48 8b 73 10          	mov    rsi,QWORD PTR [rbx+0x10]
  8e233e:	48 29 d6             	sub    rsi,rdx
  8e2341:	40 0f 92 c7          	setb   dil
  8e2345:	48 83 fe 18          	cmp    rsi,0x18
  8e2349:	40 0f 92 c6          	setb   sil
  8e234d:	40 08 fe             	or     sil,dil
  8e2350:	40 80 fe 01          	cmp    sil,0x1
  8e2354:	0f 85 21 14 00 00    	jne    8e377b <check_data_emit+0x1c1b>
  8e235a:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e235f:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
  8e2366:	00 
  8e2367:	e9 50 14 00 00       	jmp    8e37bc <check_data_emit+0x1c5c>
  8e236c:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
  8e2371:	48 c7 42 10 00 00 00 	mov    QWORD PTR [rdx+0x10],0x0
  8e2378:	00 
  8e2379:	85 c0                	test   eax,eax
  8e237b:	0f 85 ab 2d 00 00    	jne    8e512c <check_data_emit+0x35cc>
  8e2381:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e2386:	48 8d 50 10          	lea    rdx,[rax+0x10]
  8e238a:	eb 2c                	jmp    8e23b8 <check_data_emit+0x858>
  8e238c:	83 7c 24 50 08       	cmp    DWORD PTR [rsp+0x50],0x8
  8e2391:	0f 95 c0             	setne  al
  8e2394:	80 f9 01             	cmp    cl,0x1
  8e2397:	0f 95 c1             	setne  cl
  8e239a:	08 c1                	or     cl,al
  8e239c:	0f b6 e9             	movzx  ebp,cl
  8e239f:	e9 18 14 00 00       	jmp    8e37bc <check_data_emit+0x1c5c>
  8e23a4:	48 01 d6             	add    rsi,rdx
  8e23a7:	48 89 73 08          	mov    QWORD PTR [rbx+0x8],rsi
  8e23ab:	48 8b 74 24 20       	mov    rsi,QWORD PTR [rsp+0x20]
  8e23b0:	48 8d 56 10          	lea    rdx,[rsi+0x10]
  8e23b4:	48 89 46 10          	mov    QWORD PTR [rsi+0x10],rax
  8e23b8:	48 8b 43 08          	mov    rax,QWORD PTR [rbx+0x8]
  8e23bc:	48 8b 73 10          	mov    rsi,QWORD PTR [rbx+0x10]
  8e23c0:	48 29 c6             	sub    rsi,rax
  8e23c3:	0f 82 c0 2c 00 00    	jb     8e5089 <check_data_emit+0x3529>
  8e23c9:	48 89 c7             	mov    rdi,rax
  8e23cc:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  8e23d1:	8b 40 18             	mov    eax,DWORD PTR [rax+0x18]
  8e23d4:	48 c1 e0 05          	shl    rax,0x5
  8e23d8:	48 39 f0             	cmp    rax,rsi
  8e23db:	0f 87 a8 2c 00 00    	ja     8e5089 <check_data_emit+0x3529>
  8e23e1:	48 01 f8             	add    rax,rdi
  8e23e4:	48 03 3b             	add    rdi,QWORD PTR [rbx]
  8e23e7:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
  8e23eb:	48 89 bc 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rdi
  8e23f2:	00 
  8e23f3:	48 85 c9             	test   rcx,rcx
  8e23f6:	74 0a                	je     8e2402 <check_data_emit+0x8a2>
  8e23f8:	48 83 3a 00          	cmp    QWORD PTR [rdx],0x0
  8e23fc:	0f 84 87 2c 00 00    	je     8e5089 <check_data_emit+0x3529>
  8e2402:	48 83 bc 24 80 00 00 	cmp    QWORD PTR [rsp+0x80],0x0
  8e2409:	00 00 
  8e240b:	41 ba 06 00 00 00    	mov    r10d,0x6
  8e2411:	0f 84 22 2d 00 00    	je     8e5139 <check_data_emit+0x35d9>
  8e2417:	48 8b 44 24 58       	mov    rax,QWORD PTR [rsp+0x58]
  8e241c:	80 78 28 00          	cmp    BYTE PTR [rax+0x28],0x0
  8e2420:	0f 85 58 2c 00 00    	jne    8e507e <check_data_emit+0x351e>
  8e2426:	48 8b 8c 24 80 00 00 	mov    rcx,QWORD PTR [rsp+0x80]
  8e242d:	00 
  8e242e:	48 8b 84 24 b0 01 00 	mov    rax,QWORD PTR [rsp+0x1b0]
  8e2435:	00 
  8e2436:	31 ed                	xor    ebp,ebp
  8e2438:	48 c7 84 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],0x0
  8e243f:	00 00 00 00 00 
  8e2444:	48 c7 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],0x0
  8e244b:	00 00 00 00 00 
  8e2450:	48 c7 84 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],0x0
  8e2457:	00 00 00 00 00 
  8e245c:	45 31 db             	xor    r11d,r11d
  8e245f:	4c 8d b1 c0 00 00 00 	lea    r14,[rcx+0xc0]
  8e2466:	48 89 84 24 00 01 00 	mov    QWORD PTR [rsp+0x100],rax
  8e246d:	00 
  8e246e:	48 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],rcx
  8e2473:	eb 6b                	jmp    8e24e0 <check_data_emit+0x980>
  8e2475:	4c 8b 5c 24 50       	mov    r11,QWORD PTR [rsp+0x50]
  8e247a:	4c 8b 74 24 48       	mov    r14,QWORD PTR [rsp+0x48]
  8e247f:	48 8b 6c 24 38       	mov    rbp,QWORD PTR [rsp+0x38]
  8e2484:	48 8b bc 24 88 00 00 	mov    rdi,QWORD PTR [rsp+0x88]
  8e248b:	00 
  8e248c:	48 c1 e0 03          	shl    rax,0x3
  8e2490:	48 85 d2             	test   rdx,rdx
  8e2493:	41 ba 01 00 00 00    	mov    r10d,0x1
  8e2499:	48 0f 45 c2          	cmovne rax,rdx
  8e249d:	48 3b bc 24 b8 00 00 	cmp    rdi,QWORD PTR [rsp+0xb8]
  8e24a4:	00 
  8e24a5:	0f 93 c2             	setae  dl
  8e24a8:	48 01 f8             	add    rax,rdi
  8e24ab:	48 3b 84 24 a0 00 00 	cmp    rax,QWORD PTR [rsp+0xa0]
  8e24b2:	00 
  8e24b3:	0f 96 c0             	setbe  al
  8e24b6:	08 d0                	or     al,dl
  8e24b8:	48 8b 94 24 c0 00 00 	mov    rdx,QWORD PTR [rsp+0xc0]
  8e24bf:	00 
  8e24c0:	20 c2                	and    dl,al
  8e24c2:	48 89 94 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rdx
  8e24c9:	00 
  8e24ca:	48 83 44 24 30 20    	add    QWORD PTR [rsp+0x30],0x20
  8e24d0:	48 ff c5             	inc    rbp
  8e24d3:	49 83 c6 20          	add    r14,0x20
  8e24d7:	45 85 d2             	test   r10d,r10d
  8e24da:	0f 85 59 2c 00 00    	jne    8e5139 <check_data_emit+0x35d9>
  8e24e0:	48 8b 54 24 40       	mov    rdx,QWORD PTR [rsp+0x40]
  8e24e5:	8b 42 18             	mov    eax,DWORD PTR [rdx+0x18]
  8e24e8:	48 39 c5             	cmp    rbp,rax
  8e24eb:	0f 83 44 09 00 00    	jae    8e2e35 <check_data_emit+0x12d5>
  8e24f1:	48 8b 42 10          	mov    rax,QWORD PTR [rdx+0x10]
  8e24f5:	48 69 d5 b0 00 00 00 	imul   rdx,rbp,0xb0
  8e24fc:	44 8b 4c 10 04       	mov    r9d,DWORD PTR [rax+rdx*1+0x4]
  8e2501:	48 8d 3c 10          	lea    rdi,[rax+rdx*1]
  8e2505:	41 c1 e9 03          	shr    r9d,0x3
  8e2509:	74 58                	je     8e2563 <check_data_emit+0xa03>
  8e250b:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  8e2510:	44 3b 49 48          	cmp    r9d,DWORD PTR [rcx+0x48]
  8e2514:	73 4d                	jae    8e2563 <check_data_emit+0xa03>
  8e2516:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  8e251b:	44 8b 07             	mov    r8d,DWORD PTR [rdi]
  8e251e:	48 8b 31             	mov    rsi,QWORD PTR [rcx]
  8e2521:	46 0f b6 14 0e       	movzx  r10d,BYTE PTR [rsi+r9*1]
  8e2526:	45 84 d2             	test   r10b,r10b
  8e2529:	40 0f 95 c6          	setne  sil
  8e252d:	45 85 c0             	test   r8d,r8d
  8e2530:	75 36                	jne    8e2568 <check_data_emit+0xa08>
  8e2532:	45 84 d2             	test   r10b,r10b
  8e2535:	74 31                	je     8e2568 <check_data_emit+0xa08>
  8e2537:	41 80 fa 0f          	cmp    r10b,0xf
  8e253b:	75 11                	jne    8e254e <check_data_emit+0x9ee>
  8e253d:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  8e2542:	48 8b 71 20          	mov    rsi,QWORD PTR [rcx+0x20]
  8e2546:	46 8b 0c 8e          	mov    r9d,DWORD PTR [rsi+r9*4]
  8e254a:	41 c1 e9 03          	shr    r9d,0x3
  8e254e:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  8e2553:	45 31 c0             	xor    r8d,r8d
  8e2556:	48 8b 71 38          	mov    rsi,QWORD PTR [rcx+0x38]
  8e255a:	4e 8d 0c ce          	lea    r9,[rsi+r9*8]
  8e255e:	40 b6 01             	mov    sil,0x1
  8e2561:	eb 09                	jmp    8e256c <check_data_emit+0xa0c>
  8e2563:	44 8b 07             	mov    r8d,DWORD PTR [rdi]
  8e2566:	31 f6                	xor    esi,esi
  8e2568:	4c 8d 4f 30          	lea    r9,[rdi+0x30]
  8e256c:	48 8b 4c 10 18       	mov    rcx,QWORD PTR [rax+rdx*1+0x18]
  8e2571:	8b 57 20             	mov    edx,DWORD PTR [rdi+0x20]
  8e2574:	49 8b 01             	mov    rax,QWORD PTR [r9]
  8e2577:	48 89 7c 24 10       	mov    QWORD PTR [rsp+0x10],rdi
  8e257c:	41 89 ca             	mov    r10d,ecx
  8e257f:	41 83 e2 07          	and    r10d,0x7
  8e2583:	49 8d 7c 12 07       	lea    rdi,[r10+rdx*1+0x7]
  8e2588:	48 c1 ef 03          	shr    rdi,0x3
  8e258c:	48 85 d2             	test   rdx,rdx
  8e258f:	48 0f 44 f8          	cmove  rdi,rax
  8e2593:	48 89 7c 24 18       	mov    QWORD PTR [rsp+0x18],rdi
  8e2598:	40 84 f6             	test   sil,sil
  8e259b:	0f 84 dc 00 00 00    	je     8e267d <check_data_emit+0xb1d>
  8e25a1:	48 8b 74 24 20       	mov    rsi,QWORD PTR [rsp+0x20]
  8e25a6:	4c 89 74 24 48       	mov    QWORD PTR [rsp+0x48],r14
  8e25ab:	48 89 cf             	mov    rdi,rcx
  8e25ae:	48 c1 ef 03          	shr    rdi,0x3
  8e25b2:	48 85 d2             	test   rdx,rdx
  8e25b5:	48 89 6c 24 38       	mov    QWORD PTR [rsp+0x38],rbp
  8e25ba:	4c 89 5c 24 50       	mov    QWORD PTR [rsp+0x50],r11
  8e25bf:	40 0f 94 c5          	sete   bpl
  8e25c3:	4d 85 d2             	test   r10,r10
  8e25c6:	41 0f 95 c3          	setne  r11b
  8e25ca:	41 83 f8 01          	cmp    r8d,0x1
  8e25ce:	41 0f 95 c2          	setne  r10b
  8e25d2:	4c 8b 76 08          	mov    r14,QWORD PTR [rsi+0x8]
  8e25d6:	31 f6                	xor    esi,esi
  8e25d8:	49 29 fe             	sub    r14,rdi
  8e25db:	0f 82 5e 02 00 00    	jb     8e283f <check_data_emit+0xcdf>
  8e25e1:	48 89 bc 24 88 00 00 	mov    QWORD PTR [rsp+0x88],rdi
  8e25e8:	00 
  8e25e9:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
  8e25ee:	4c 39 74 24 18       	cmp    QWORD PTR [rsp+0x18],r14
  8e25f3:	0f 87 e0 01 00 00    	ja     8e27d9 <check_data_emit+0xc79>
  8e25f9:	41 20 eb             	and    r11b,bpl
  8e25fc:	4c 8b 8c 24 30 06 00 	mov    r9,QWORD PTR [rsp+0x630]
  8e2603:	00 
  8e2604:	4c 8b 5c 24 50       	mov    r11,QWORD PTR [rsp+0x50]
  8e2609:	0f 85 cf 01 00 00    	jne    8e27de <check_data_emit+0xc7e>
  8e260f:	41 08 ea             	or     r10b,bpl
  8e2612:	0f 84 c6 01 00 00    	je     8e27de <check_data_emit+0xc7e>
  8e2618:	4c 8b 74 24 48       	mov    r14,QWORD PTR [rsp+0x48]
  8e261d:	48 8b 6c 24 38       	mov    rbp,QWORD PTR [rsp+0x38]
  8e2622:	45 8d 50 ff          	lea    r10d,[r8-0x1]
  8e2626:	31 f6                	xor    esi,esi
  8e2628:	41 83 fa 02          	cmp    r10d,0x2
  8e262c:	73 6f                	jae    8e269d <check_data_emit+0xb3d>
  8e262e:	41 83 f8 01          	cmp    r8d,0x1
  8e2632:	0f 85 1b 02 00 00    	jne    8e2853 <check_data_emit+0xcf3>
  8e2638:	48 83 7c 24 18 00    	cmp    QWORD PTR [rsp+0x18],0x0
  8e263e:	41 ba 00 00 00 00    	mov    r10d,0x0
  8e2644:	0f 84 a4 01 00 00    	je     8e27ee <check_data_emit+0xc8e>
  8e264a:	48 89 8c 24 88 00 00 	mov    QWORD PTR [rsp+0x88],rcx
  8e2651:	00 
  8e2652:	48 8b 4f 28          	mov    rcx,QWORD PTR [rdi+0x28]
  8e2656:	48 85 c9             	test   rcx,rcx
  8e2659:	0f 84 16 fe ff ff    	je     8e2475 <check_data_emit+0x915>
  8e265f:	40 b6 3d             	mov    sil,0x3d
  8e2662:	c4 e2 c8 f5 74 24 18 	bzhi   rsi,QWORD PTR [rsp+0x18],rsi
  8e2669:	48 83 fe 40          	cmp    rsi,0x40
  8e266d:	0f 83 96 02 00 00    	jae    8e2909 <check_data_emit+0xda9>
  8e2673:	45 31 c9             	xor    r9d,r9d
  8e2676:	31 ed                	xor    ebp,ebp
  8e2678:	e9 4f 03 00 00       	jmp    8e29cc <check_data_emit+0xe6c>
  8e267d:	31 f6                	xor    esi,esi
  8e267f:	41 ba 01 00 00 00    	mov    r10d,0x1
  8e2685:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
  8e268a:	48 8b 54 24 18       	mov    rdx,QWORD PTR [rsp+0x18]
  8e268f:	48 85 d2             	test   rdx,rdx
  8e2692:	0f 85 64 01 00 00    	jne    8e27fc <check_data_emit+0xc9c>
  8e2698:	e9 2d fe ff ff       	jmp    8e24ca <check_data_emit+0x96a>
  8e269d:	41 ba 01 00 00 00    	mov    r10d,0x1
  8e26a3:	45 85 c0             	test   r8d,r8d
  8e26a6:	0f 85 42 01 00 00    	jne    8e27ee <check_data_emit+0xc8e>
  8e26ac:	c7 84 24 a8 01 00 00 	mov    DWORD PTR [rsp+0x1a8],0x0
  8e26b3:	00 00 00 00 
  8e26b7:	48 8d 84 24 40 01 00 	lea    rax,[rsp+0x140]
  8e26be:	00 
  8e26bf:	48 89 cd             	mov    rbp,rcx
  8e26c2:	48 8d 8c 24 a8 01 00 	lea    rcx,[rsp+0x1a8]
  8e26c9:	00 
  8e26ca:	44 8b 84 24 ac 00 00 	mov    r8d,DWORD PTR [rsp+0xac]
  8e26d1:	00 
  8e26d2:	48 8d b4 24 f0 01 00 	lea    rsi,[rsp+0x1f0]
  8e26d9:	00 
  8e26da:	48 8d 94 24 10 01 00 	lea    rdx,[rsp+0x110]
  8e26e1:	00 
  8e26e2:	62 f1 fe 48 6f 47 01 	vmovdqu64 zmm0,ZMMWORD PTR [rdi+0x40]
  8e26e9:	62 f1 fe 48 6f 8f 60 	vmovdqu64 zmm1,ZMMWORD PTR [rdi+0x60]
  8e26f0:	00 00 00 
  8e26f3:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x160],zmm1
  8e26fa:	60 01 00 00 
  8e26fe:	62 f1 fe 48 7f 44 24 	vmovdqu64 ZMMWORD PTR [rsp+0x140],zmm0
  8e2705:	05 
  8e2706:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e270a:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x2c8],zmm0
  8e2711:	c8 02 00 00 
  8e2715:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x1f0],zmm0
  8e271c:	f0 01 00 00 
  8e2720:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x270],zmm0
  8e2727:	70 02 00 00 
  8e272b:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x2b0],zmm0
  8e2732:	b0 02 00 00 
  8e2736:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x230],zmm0
  8e273d:	30 02 00 00 
  8e2741:	48 89 84 24 f8 01 00 	mov    QWORD PTR [rsp+0x1f8],rax
  8e2748:	00 
  8e2749:	48 8d 84 24 18 01 00 	lea    rax,[rsp+0x118]
  8e2750:	00 
  8e2751:	48 89 8c 24 10 02 00 	mov    QWORD PTR [rsp+0x210],rcx
  8e2758:	00 
  8e2759:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e275d:	c7 84 24 90 02 00 00 	mov    DWORD PTR [rsp+0x290],0x1
  8e2764:	01 00 00 00 
  8e2768:	48 8b 8c 24 b0 00 00 	mov    rcx,QWORD PTR [rsp+0xb0]
  8e276f:	00 
  8e2770:	c5 fe 7f 00          	vmovdqu YMMWORD PTR [rax],ymm0
  8e2774:	48 c7 40 20 00 00 00 	mov    QWORD PTR [rax+0x20],0x0
  8e277b:	00 
  8e277c:	8b 47 04             	mov    eax,DWORD PTR [rdi+0x4]
  8e277f:	89 84 24 10 01 00 00 	mov    DWORD PTR [rsp+0x110],eax
  8e2786:	48 8b 44 24 58       	mov    rax,QWORD PTR [rsp+0x58]
  8e278b:	8b 40 04             	mov    eax,DWORD PTR [rax+0x4]
  8e278e:	89 84 24 14 01 00 00 	mov    DWORD PTR [rsp+0x114],eax
  8e2795:	8b 47 0c             	mov    eax,DWORD PTR [rdi+0xc]
  8e2798:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e279d:	89 84 24 1c 01 00 00 	mov    DWORD PTR [rsp+0x11c],eax
  8e27a4:	48 8d 84 24 b8 01 00 	lea    rax,[rsp+0x1b8]
  8e27ab:	00 
  8e27ac:	48 89 04 24          	mov    QWORD PTR [rsp],rax
  8e27b0:	c5 f8 77             	vzeroupper
  8e27b3:	e8 78 2a 00 00       	call   8e5230 <check_data_plan_scalar>
  8e27b8:	85 c0                	test   eax,eax
  8e27ba:	0f 84 a5 00 00 00    	je     8e2865 <check_data_emit+0xd05>
  8e27c0:	41 89 c2             	mov    r10d,eax
  8e27c3:	31 f6                	xor    esi,esi
  8e27c5:	4c 8b 5c 24 50       	mov    r11,QWORD PTR [rsp+0x50]
  8e27ca:	4c 8b 74 24 48       	mov    r14,QWORD PTR [rsp+0x48]
  8e27cf:	48 8b 6c 24 38       	mov    rbp,QWORD PTR [rsp+0x38]
  8e27d4:	e9 ac fe ff ff       	jmp    8e2685 <check_data_emit+0xb25>
  8e27d9:	4c 8b 5c 24 50       	mov    r11,QWORD PTR [rsp+0x50]
  8e27de:	4c 8b 74 24 48       	mov    r14,QWORD PTR [rsp+0x48]
  8e27e3:	48 8b 6c 24 38       	mov    rbp,QWORD PTR [rsp+0x38]
  8e27e8:	41 ba 01 00 00 00    	mov    r10d,0x1
  8e27ee:	48 8b 54 24 18       	mov    rdx,QWORD PTR [rsp+0x18]
  8e27f3:	48 85 d2             	test   rdx,rdx
  8e27f6:	0f 84 ce fc ff ff    	je     8e24ca <check_data_emit+0x96a>
  8e27fc:	8b 47 20             	mov    eax,DWORD PTR [rdi+0x20]
  8e27ff:	48 8b 7f 18          	mov    rdi,QWORD PTR [rdi+0x18]
  8e2803:	48 c1 e2 03          	shl    rdx,0x3
  8e2807:	48 85 c0             	test   rax,rax
  8e280a:	48 0f 45 d0          	cmovne rdx,rax
  8e280e:	41 08 f3             	or     r11b,sil
  8e2811:	48 89 d0             	mov    rax,rdx
  8e2814:	40 84 f6             	test   sil,sil
  8e2817:	0f 84 80 fc ff ff    	je     8e249d <check_data_emit+0x93d>
  8e281d:	48 01 f8             	add    rax,rdi
  8e2820:	b2 01                	mov    dl,0x1
  8e2822:	48 89 bc 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rdi
  8e2829:	00 
  8e282a:	48 89 94 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rdx
  8e2831:	00 
  8e2832:	48 89 84 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rax
  8e2839:	00 
  8e283a:	e9 8b fc ff ff       	jmp    8e24ca <check_data_emit+0x96a>
  8e283f:	4c 8b 5c 24 50       	mov    r11,QWORD PTR [rsp+0x50]
  8e2844:	4c 8b 74 24 48       	mov    r14,QWORD PTR [rsp+0x48]
  8e2849:	48 8b 6c 24 38       	mov    rbp,QWORD PTR [rsp+0x38]
  8e284e:	e9 2c fe ff ff       	jmp    8e267f <check_data_emit+0xb1f>
  8e2853:	45 31 d2             	xor    r10d,r10d
  8e2856:	48 8b 54 24 18       	mov    rdx,QWORD PTR [rsp+0x18]
  8e285b:	48 85 d2             	test   rdx,rdx
  8e285e:	75 9c                	jne    8e27fc <check_data_emit+0xc9c>
  8e2860:	e9 65 fc ff ff       	jmp    8e24ca <check_data_emit+0x96a>
  8e2865:	48 8b 44 24 10       	mov    rax,QWORD PTR [rsp+0x10]
  8e286a:	8b 40 20             	mov    eax,DWORD PTR [rax+0x20]
  8e286d:	85 c0                	test   eax,eax
  8e286f:	0f 84 19 03 00 00    	je     8e2b8e <check_data_emit+0x102e>
  8e2875:	83 bc 24 dc 01 00 00 	cmp    DWORD PTR [rsp+0x1dc],0x0
  8e287c:	00 
  8e287d:	41 ba 01 00 00 00    	mov    r10d,0x1
  8e2883:	0f 85 3a ff ff ff    	jne    8e27c3 <check_data_emit+0xc63>
  8e2889:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
  8e288e:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
  8e2893:	8b 49 04             	mov    ecx,DWORD PTR [rcx+0x4]
  8e2896:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
  8e2899:	89 ce                	mov    esi,ecx
  8e289b:	c1 ee 03             	shr    esi,0x3
  8e289e:	0f b6 3c 32          	movzx  edi,BYTE PTR [rdx+rsi*1]
  8e28a2:	40 80 ff 0f          	cmp    dil,0xf
  8e28a6:	75 15                	jne    8e28bd <check_data_emit+0xd5d>
  8e28a8:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  8e28ad:	48 8b 49 20          	mov    rcx,QWORD PTR [rcx+0x20]
  8e28b1:	8b 0c b1             	mov    ecx,DWORD PTR [rcx+rsi*4]
  8e28b4:	89 ce                	mov    esi,ecx
  8e28b6:	c1 ee 03             	shr    esi,0x3
  8e28b9:	0f b6 3c 32          	movzx  edi,BYTE PTR [rdx+rsi*1]
  8e28bd:	40 80 ff 12          	cmp    dil,0x12
  8e28c1:	75 1b                	jne    8e28de <check_data_emit+0xd7e>
  8e28c3:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e28c8:	48 8b 7f 10          	mov    rdi,QWORD PTR [rdi+0x10]
  8e28cc:	f6 04 37 04          	test   BYTE PTR [rdi+rsi*1],0x4
  8e28d0:	74 0c                	je     8e28de <check_data_emit+0xd7e>
  8e28d2:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  8e28d7:	48 8b 49 20          	mov    rcx,QWORD PTR [rcx+0x20]
  8e28db:	8b 0c b1             	mov    ecx,DWORD PTR [rcx+rsi*4]
  8e28de:	c1 e9 03             	shr    ecx,0x3
  8e28e1:	0f b6 14 0a          	movzx  edx,BYTE PTR [rdx+rcx*1]
  8e28e5:	83 fa 02             	cmp    edx,0x2
  8e28e8:	0f 84 6d 02 00 00    	je     8e2b5b <check_data_emit+0xffb>
  8e28ee:	83 fa 05             	cmp    edx,0x5
  8e28f1:	0f 85 cc fe ff ff    	jne    8e27c3 <check_data_emit+0xc63>
  8e28f7:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
  8e28fc:	48 8b 52 30          	mov    rdx,QWORD PTR [rdx+0x30]
  8e2900:	48 8b 0c ca          	mov    rcx,QWORD PTR [rdx+rcx*8]
  8e2904:	e9 62 02 00 00       	jmp    8e2b6b <check_data_emit+0x100b>
  8e2909:	4c 8d 46 c0          	lea    r8,[rsi-0x40]
  8e290d:	4d 89 c1             	mov    r9,r8
  8e2910:	49 c1 e9 06          	shr    r9,0x6
  8e2914:	49 ff c1             	inc    r9
  8e2917:	44 89 cf             	mov    edi,r9d
  8e291a:	83 e7 07             	and    edi,0x7
  8e291d:	49 81 f8 c0 01 00 00 	cmp    r8,0x1c0
  8e2924:	73 09                	jae    8e292f <check_data_emit+0xdcf>
  8e2926:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e292a:	45 31 c0             	xor    r8d,r8d
  8e292d:	eb 60                	jmp    8e298f <check_data_emit+0xe2f>
  8e292f:	49 83 e1 f8          	and    r9,0xfffffffffffffff8
  8e2933:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e2937:	45 31 c0             	xor    r8d,r8d
  8e293a:	62 b1 fe 48 6f 0c 01 	vmovdqu64 zmm1,ZMMWORD PTR [rcx+r8*1]
  8e2941:	62 b1 fe 48 6f 54 01 	vmovdqu64 zmm2,ZMMWORD PTR [rcx+r8*1+0x80]
  8e2948:	02 
  8e2949:	62 b1 fe 48 6f 5c 01 	vmovdqu64 zmm3,ZMMWORD PTR [rcx+r8*1+0x100]
  8e2950:	04 
  8e2951:	62 b1 fe 48 6f 64 01 	vmovdqu64 zmm4,ZMMWORD PTR [rcx+r8*1+0x180]
  8e2958:	06 
  8e2959:	62 b3 f5 48 25 44 01 	vpternlogq zmm0,zmm1,ZMMWORD PTR [rcx+r8*1+0x40],0xfe
  8e2960:	01 fe 
  8e2962:	62 b3 ed 48 25 44 01 	vpternlogq zmm0,zmm2,ZMMWORD PTR [rcx+r8*1+0xc0],0xfe
  8e2969:	03 fe 
  8e296b:	62 b3 e5 48 25 44 01 	vpternlogq zmm0,zmm3,ZMMWORD PTR [rcx+r8*1+0x140],0xfe
  8e2972:	05 fe 
  8e2974:	62 b3 dd 48 25 44 01 	vpternlogq zmm0,zmm4,ZMMWORD PTR [rcx+r8*1+0x1c0],0xfe
  8e297b:	07 fe 
  8e297d:	49 81 c0 00 02 00 00 	add    r8,0x200
  8e2984:	49 83 c1 f8          	add    r9,0xfffffffffffffff8
  8e2988:	75 b0                	jne    8e293a <check_data_emit+0xdda>
  8e298a:	48 85 ff             	test   rdi,rdi
  8e298d:	74 19                	je     8e29a8 <check_data_emit+0xe48>
  8e298f:	49 01 c8             	add    r8,rcx
  8e2992:	c1 e7 06             	shl    edi,0x6
  8e2995:	45 31 c9             	xor    r9d,r9d
  8e2998:	62 91 fd 48 eb 04 08 	vporq  zmm0,zmm0,ZMMWORD PTR [r8+r9*1]
  8e299f:	49 83 c1 40          	add    r9,0x40
  8e29a3:	4c 39 cf             	cmp    rdi,r9
  8e29a6:	75 f0                	jne    8e2998 <check_data_emit+0xe38>
  8e29a8:	48 bf 00 ff ff ff ff 	movabs rdi,0x1fffffffffffff00
  8e29af:	ff ff 1f 
  8e29b2:	62 f2 7d 48 27 c0    	vptestmd k0,zmm0,zmm0
  8e29b8:	48 8d af c0 00 00 00 	lea    rbp,[rdi+0xc0]
  8e29bf:	48 23 6c 24 18       	and    rbp,QWORD PTR [rsp+0x18]
  8e29c4:	c5 f8 98 c0          	kortestw k0,k0
  8e29c8:	41 0f 95 c1          	setne  r9b
  8e29cc:	49 89 f3             	mov    r11,rsi
  8e29cf:	49 29 eb             	sub    r11,rbp
  8e29d2:	0f 86 47 01 00 00    	jbe    8e2b1f <check_data_emit+0xfbf>
  8e29d8:	49 83 fb 10          	cmp    r11,0x10
  8e29dc:	73 08                	jae    8e29e6 <check_data_emit+0xe86>
  8e29de:	48 89 ef             	mov    rdi,rbp
  8e29e1:	e9 2d 01 00 00       	jmp    8e2b13 <check_data_emit+0xfb3>
  8e29e6:	49 81 fb 00 01 00 00 	cmp    r11,0x100
  8e29ed:	73 08                	jae    8e29f7 <check_data_emit+0xe97>
  8e29ef:	45 31 d2             	xor    r10d,r10d
  8e29f2:	e9 b8 00 00 00       	jmp    8e2aaf <check_data_emit+0xf4f>
  8e29f7:	48 bf 00 ff ff ff ff 	movabs rdi,0x1fffffffffffff00
  8e29fe:	ff ff 1f 
  8e2a01:	4d 89 da             	mov    r10,r11
  8e2a04:	45 0f b6 c1          	movzx  r8d,r9b
  8e2a08:	4c 8d 8c 29 c0 00 00 	lea    r9,[rcx+rbp*1+0xc0]
  8e2a0f:	00 
  8e2a10:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e2a14:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  8e2a18:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  8e2a1c:	49 21 fa             	and    r10,rdi
  8e2a1f:	c4 c1 79 6e c8       	vmovd  xmm1,r8d
  8e2a24:	45 31 c0             	xor    r8d,r8d
  8e2a27:	4a 8d 7c 15 00       	lea    rdi,[rbp+r10*1+0x0]
  8e2a2c:	62 91 f5 48 eb 4c 01 	vporq  zmm1,zmm1,ZMMWORD PTR [r9+r8*1-0xc0]
  8e2a33:	fd 
  8e2a34:	62 91 e5 48 eb 5c 01 	vporq  zmm3,zmm3,ZMMWORD PTR [r9+r8*1-0x80]
  8e2a3b:	fe 
  8e2a3c:	62 91 ed 48 eb 54 01 	vporq  zmm2,zmm2,ZMMWORD PTR [r9+r8*1-0x40]
  8e2a43:	ff 
  8e2a44:	62 91 fd 48 eb 04 01 	vporq  zmm0,zmm0,ZMMWORD PTR [r9+r8*1]
  8e2a4b:	49 81 c0 00 01 00 00 	add    r8,0x100
  8e2a52:	4d 39 c2             	cmp    r10,r8
  8e2a55:	75 d5                	jne    8e2a2c <check_data_emit+0xecc>
  8e2a57:	62 f1 e5 48 eb c9    	vporq  zmm1,zmm3,zmm1
  8e2a5d:	62 f3 ed 48 25 c1 fe 	vpternlogq zmm0,zmm2,zmm1,0xfe
  8e2a64:	62 f3 fd 48 3b c1 01 	vextracti64x4 ymm1,zmm0,0x1
  8e2a6b:	62 f1 fd 48 eb c1    	vporq  zmm0,zmm0,zmm1
  8e2a71:	c4 e3 7d 39 c1 01    	vextracti128 xmm1,ymm0,0x1
  8e2a77:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2a7b:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e2a80:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2a84:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e2a89:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2a8d:	c5 f1 72 d0 10       	vpsrld xmm1,xmm0,0x10
  8e2a92:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2a96:	c5 f1 71 d0 08       	vpsrlw xmm1,xmm0,0x8
  8e2a9b:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2a9f:	c4 c1 79 7e c1       	vmovd  r9d,xmm0
  8e2aa4:	4d 39 d3             	cmp    r11,r10
  8e2aa7:	74 76                	je     8e2b1f <check_data_emit+0xfbf>
  8e2aa9:	41 f6 c3 f0          	test   r11b,0xf0
  8e2aad:	74 64                	je     8e2b13 <check_data_emit+0xfb3>
  8e2aaf:	4c 8b 74 24 18       	mov    r14,QWORD PTR [rsp+0x18]
  8e2ab4:	45 0f b6 c1          	movzx  r8d,r9b
  8e2ab8:	49 01 ea             	add    r10,rbp
  8e2abb:	c4 c1 79 6e c0       	vmovd  xmm0,r8d
  8e2ac0:	49 89 f0             	mov    r8,rsi
  8e2ac3:	41 83 e6 0f          	and    r14d,0xf
  8e2ac7:	4d 29 f3             	sub    r11,r14
  8e2aca:	4d 29 f0             	sub    r8,r14
  8e2acd:	4c 89 df             	mov    rdi,r11
  8e2ad0:	48 01 ef             	add    rdi,rbp
  8e2ad3:	4d 89 f3             	mov    r11,r14
  8e2ad6:	c4 a1 79 eb 04 11    	vpor   xmm0,xmm0,XMMWORD PTR [rcx+r10*1]
  8e2adc:	49 83 c2 10          	add    r10,0x10
  8e2ae0:	4d 39 d0             	cmp    r8,r10
  8e2ae3:	75 f1                	jne    8e2ad6 <check_data_emit+0xf76>
  8e2ae5:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e2aea:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2aee:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e2af3:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2af7:	c5 f1 72 d0 10       	vpsrld xmm1,xmm0,0x10
  8e2afc:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2b00:	c5 f1 71 d0 08       	vpsrlw xmm1,xmm0,0x8
  8e2b05:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2b09:	c4 c1 79 7e c1       	vmovd  r9d,xmm0
  8e2b0e:	4d 85 db             	test   r11,r11
  8e2b11:	74 0c                	je     8e2b1f <check_data_emit+0xfbf>
  8e2b13:	44 0a 0c 39          	or     r9b,BYTE PTR [rcx+rdi*1]
  8e2b17:	48 ff c7             	inc    rdi
  8e2b1a:	48 39 fe             	cmp    rsi,rdi
  8e2b1d:	75 f4                	jne    8e2b13 <check_data_emit+0xfb3>
  8e2b1f:	4c 8b 5c 24 50       	mov    r11,QWORD PTR [rsp+0x50]
  8e2b24:	4c 8b 74 24 48       	mov    r14,QWORD PTR [rsp+0x48]
  8e2b29:	48 8b 6c 24 38       	mov    rbp,QWORD PTR [rsp+0x38]
  8e2b2e:	48 8b bc 24 88 00 00 	mov    rdi,QWORD PTR [rsp+0x88]
  8e2b35:	00 
  8e2b36:	45 84 c9             	test   r9b,r9b
  8e2b39:	0f 95 c1             	setne  cl
  8e2b3c:	48 c1 e0 03          	shl    rax,0x3
  8e2b40:	48 85 d2             	test   rdx,rdx
  8e2b43:	48 0f 45 c2          	cmovne rax,rdx
  8e2b47:	45 31 d2             	xor    r10d,r10d
  8e2b4a:	41 08 cb             	or     r11b,cl
  8e2b4d:	45 84 c9             	test   r9b,r9b
  8e2b50:	0f 85 c7 fc ff ff    	jne    8e281d <check_data_emit+0xcbd>
  8e2b56:	e9 42 f9 ff ff       	jmp    8e249d <check_data_emit+0x93d>
  8e2b5b:	48 8d 0c 49          	lea    rcx,[rcx+rcx*2]
  8e2b5f:	48 8d 15 ca a3 bc ff 	lea    rdx,[rip+0xffffffffffbca3ca]        # 4acf30 <type_integer_info>
  8e2b66:	0f b6 4c 4a 02       	movzx  ecx,BYTE PTR [rdx+rcx*2+0x2]
  8e2b6b:	48 8d 51 ff          	lea    rdx,[rcx-0x1]
  8e2b6f:	31 f6                	xor    esi,esi
  8e2b71:	48 83 fa 7f          	cmp    rdx,0x7f
  8e2b75:	0f 87 4a fc ff ff    	ja     8e27c5 <check_data_emit+0xc65>
  8e2b7b:	3d 80 00 00 00       	cmp    eax,0x80
  8e2b80:	0f 87 3f fc ff ff    	ja     8e27c5 <check_data_emit+0xc65>
  8e2b86:	39 c8                	cmp    eax,ecx
  8e2b88:	0f 87 37 fc ff ff    	ja     8e27c5 <check_data_emit+0xc65>
  8e2b8e:	c5 fe 6f 84 24 b8 01 	vmovdqu ymm0,YMMWORD PTR [rsp+0x1b8]
  8e2b95:	00 00 
  8e2b97:	48 8b 54 24 38       	mov    rdx,QWORD PTR [rsp+0x38]
  8e2b9c:	48 8b 84 24 80 00 00 	mov    rax,QWORD PTR [rsp+0x80]
  8e2ba3:	00 
  8e2ba4:	48 8b 74 24 10       	mov    rsi,QWORD PTR [rsp+0x10]
  8e2ba9:	48 c1 e2 05          	shl    rdx,0x5
  8e2bad:	c5 fe 7f 04 10       	vmovdqu YMMWORD PTR [rax+rdx*1],ymm0
  8e2bb2:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
  8e2bb7:	48 8d 0c c5 00 00 00 	lea    rcx,[rax*8+0x0]
  8e2bbe:	00 
  8e2bbf:	8b 46 20             	mov    eax,DWORD PTR [rsi+0x20]
  8e2bc2:	48 85 c0             	test   rax,rax
  8e2bc5:	48 89 84 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],rax
  8e2bcc:	00 
  8e2bcd:	48 0f 45 c8          	cmovne rcx,rax
  8e2bd1:	48 89 ce             	mov    rsi,rcx
  8e2bd4:	48 c1 ee 03          	shr    rsi,0x3
  8e2bd8:	48 81 f9 00 02 00 00 	cmp    rcx,0x200
  8e2bdf:	73 07                	jae    8e2be8 <check_data_emit+0x1088>
  8e2be1:	45 31 c0             	xor    r8d,r8d
  8e2be4:	31 ff                	xor    edi,edi
  8e2be6:	eb 31                	jmp    8e2c19 <check_data_emit+0x10b9>
  8e2be8:	4c 8b 44 24 30       	mov    r8,QWORD PTR [rsp+0x30]
  8e2bed:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e2bf1:	48 89 f0             	mov    rax,rsi
  8e2bf4:	31 ff                	xor    edi,edi
  8e2bf6:	62 d1 fd 48 eb 04 38 	vporq  zmm0,zmm0,ZMMWORD PTR [r8+rdi*1]
  8e2bfd:	48 83 c7 40          	add    rdi,0x40
  8e2c01:	48 83 c0 c0          	add    rax,0xffffffffffffffc0
  8e2c05:	48 83 f8 3f          	cmp    rax,0x3f
  8e2c09:	77 eb                	ja     8e2bf6 <check_data_emit+0x1096>
  8e2c0b:	62 f2 7d 48 27 c0    	vptestmd k0,zmm0,zmm0
  8e2c11:	c5 f8 98 c0          	kortestw k0,k0
  8e2c15:	41 0f 95 c0          	setne  r8b
  8e2c19:	49 89 f1             	mov    r9,rsi
  8e2c1c:	49 29 f9             	sub    r9,rdi
  8e2c1f:	0f 86 59 01 00 00    	jbe    8e2d7e <check_data_emit+0x121e>
  8e2c25:	49 83 f9 10          	cmp    r9,0x10
  8e2c29:	73 0d                	jae    8e2c38 <check_data_emit+0x10d8>
  8e2c2b:	4c 8b 74 24 30       	mov    r14,QWORD PTR [rsp+0x30]
  8e2c30:	49 89 fb             	mov    r11,rdi
  8e2c33:	e9 3a 01 00 00       	jmp    8e2d72 <check_data_emit+0x1212>
  8e2c38:	49 81 f9 00 01 00 00 	cmp    r9,0x100
  8e2c3f:	73 0d                	jae    8e2c4e <check_data_emit+0x10ee>
  8e2c41:	4c 8b 74 24 30       	mov    r14,QWORD PTR [rsp+0x30]
  8e2c46:	45 31 d2             	xor    r10d,r10d
  8e2c49:	e9 bc 00 00 00       	jmp    8e2d0a <check_data_emit+0x11aa>
  8e2c4e:	4c 8b 74 24 48       	mov    r14,QWORD PTR [rsp+0x48]
  8e2c53:	48 b8 00 ff ff ff ff 	movabs rax,0x1fffffffffffff00
  8e2c5a:	ff ff 1f 
  8e2c5d:	4d 89 ca             	mov    r10,r9
  8e2c60:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e2c64:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  8e2c68:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  8e2c6c:	49 21 c2             	and    r10,rax
  8e2c6f:	41 0f b6 c0          	movzx  eax,r8b
  8e2c73:	45 31 c0             	xor    r8d,r8d
  8e2c76:	c5 f9 6e c8          	vmovd  xmm1,eax
  8e2c7a:	4e 8d 1c 17          	lea    r11,[rdi+r10*1]
  8e2c7e:	49 8d 04 3e          	lea    rax,[r14+rdi*1]
  8e2c82:	62 b1 f5 48 eb 4c 00 	vporq  zmm1,zmm1,ZMMWORD PTR [rax+r8*1-0xc0]
  8e2c89:	fd 
  8e2c8a:	62 b1 e5 48 eb 5c 00 	vporq  zmm3,zmm3,ZMMWORD PTR [rax+r8*1-0x80]
  8e2c91:	fe 
  8e2c92:	62 b1 ed 48 eb 54 00 	vporq  zmm2,zmm2,ZMMWORD PTR [rax+r8*1-0x40]
  8e2c99:	ff 
  8e2c9a:	62 b1 fd 48 eb 04 00 	vporq  zmm0,zmm0,ZMMWORD PTR [rax+r8*1]
  8e2ca1:	49 81 c0 00 01 00 00 	add    r8,0x100
  8e2ca8:	4d 39 c2             	cmp    r10,r8
  8e2cab:	75 d5                	jne    8e2c82 <check_data_emit+0x1122>
  8e2cad:	62 f1 e5 48 eb c9    	vporq  zmm1,zmm3,zmm1
  8e2cb3:	62 f3 ed 48 25 c1 fe 	vpternlogq zmm0,zmm2,zmm1,0xfe
  8e2cba:	62 f3 fd 48 3b c1 01 	vextracti64x4 ymm1,zmm0,0x1
  8e2cc1:	62 f1 fd 48 eb c1    	vporq  zmm0,zmm0,zmm1
  8e2cc7:	c4 e3 7d 39 c1 01    	vextracti128 xmm1,ymm0,0x1
  8e2ccd:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2cd1:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e2cd6:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2cda:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e2cdf:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2ce3:	c5 f1 72 d0 10       	vpsrld xmm1,xmm0,0x10
  8e2ce8:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2cec:	c5 f1 71 d0 08       	vpsrlw xmm1,xmm0,0x8
  8e2cf1:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2cf5:	c4 c1 79 7e c0       	vmovd  r8d,xmm0
  8e2cfa:	4d 39 d1             	cmp    r9,r10
  8e2cfd:	74 7f                	je     8e2d7e <check_data_emit+0x121e>
  8e2cff:	4c 8b 74 24 30       	mov    r14,QWORD PTR [rsp+0x30]
  8e2d04:	41 f6 c1 f0          	test   r9b,0xf0
  8e2d08:	74 68                	je     8e2d72 <check_data_emit+0x1212>
  8e2d0a:	48 b8 00 ff ff ff ff 	movabs rax,0x1fffffffffffff00
  8e2d11:	ff ff 1f 
  8e2d14:	45 0f b6 c0          	movzx  r8d,r8b
  8e2d18:	48 05 f0 00 00 00    	add    rax,0xf0
  8e2d1e:	c4 c1 79 6e c0       	vmovd  xmm0,r8d
  8e2d23:	4d 8d 04 3e          	lea    r8,[r14+rdi*1]
  8e2d27:	4c 21 c8             	and    rax,r9
  8e2d2a:	48 01 c7             	add    rdi,rax
  8e2d2d:	c4 81 79 eb 04 10    	vpor   xmm0,xmm0,XMMWORD PTR [r8+r10*1]
  8e2d33:	49 83 c2 10          	add    r10,0x10
  8e2d37:	4c 39 d0             	cmp    rax,r10
  8e2d3a:	75 f1                	jne    8e2d2d <check_data_emit+0x11cd>
  8e2d3c:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e2d41:	4c 8b 74 24 30       	mov    r14,QWORD PTR [rsp+0x30]
  8e2d46:	49 89 fb             	mov    r11,rdi
  8e2d49:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2d4d:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e2d52:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2d56:	c5 f1 72 d0 10       	vpsrld xmm1,xmm0,0x10
  8e2d5b:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2d5f:	c5 f1 71 d0 08       	vpsrlw xmm1,xmm0,0x8
  8e2d64:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e2d68:	c4 c1 79 7e c0       	vmovd  r8d,xmm0
  8e2d6d:	49 39 c1             	cmp    r9,rax
  8e2d70:	74 0c                	je     8e2d7e <check_data_emit+0x121e>
  8e2d72:	47 0a 04 1e          	or     r8b,BYTE PTR [r14+r11*1]
  8e2d76:	49 ff c3             	inc    r11
  8e2d79:	4c 39 de             	cmp    rsi,r11
  8e2d7c:	75 f4                	jne    8e2d72 <check_data_emit+0x1212>
  8e2d7e:	48 85 c9             	test   rcx,rcx
  8e2d81:	74 1d                	je     8e2da0 <check_data_emit+0x1240>
  8e2d83:	48 83 e1 07          	and    rcx,0x7
  8e2d87:	74 17                	je     8e2da0 <check_data_emit+0x1240>
  8e2d89:	48 03 94 24 80 00 00 	add    rdx,QWORD PTR [rsp+0x80]
  8e2d90:	00 
  8e2d91:	b0 ff                	mov    al,0xff
  8e2d93:	d2 e0                	shl    al,cl
  8e2d95:	f6 d0                	not    al
  8e2d97:	22 04 32             	and    al,BYTE PTR [rdx+rsi*1]
  8e2d9a:	44 08 c0             	or     al,r8b
  8e2d9d:	41 89 c0             	mov    r8d,eax
  8e2da0:	83 bc 24 f8 00 00 00 	cmp    DWORD PTR [rsp+0xf8],0x0
  8e2da7:	00 
  8e2da8:	8b 84 24 dc 01 00 00 	mov    eax,DWORD PTR [rsp+0x1dc]
  8e2daf:	0f 94 c1             	sete   cl
  8e2db2:	45 84 c0             	test   r8b,r8b
  8e2db5:	40 0f 95 c6          	setne  sil
  8e2db9:	85 c0                	test   eax,eax
  8e2dbb:	0f 95 c2             	setne  dl
  8e2dbe:	45 31 d2             	xor    r10d,r10d
  8e2dc1:	20 ca                	and    dl,cl
  8e2dc3:	80 fa 01             	cmp    dl,0x1
  8e2dc6:	0f 85 f9 f9 ff ff    	jne    8e27c5 <check_data_emit+0xc65>
  8e2dcc:	48 8b 8c 24 00 01 00 	mov    rcx,QWORD PTR [rsp+0x100]
  8e2dd3:	00 
  8e2dd4:	48 8b 54 24 38       	mov    rdx,QWORD PTR [rsp+0x38]
  8e2dd9:	80 3c 11 00          	cmp    BYTE PTR [rcx+rdx*1],0x0
  8e2ddd:	0f 84 e2 f9 ff ff    	je     8e27c5 <check_data_emit+0xc65>
  8e2de3:	48 c1 ed 23          	shr    rbp,0x23
  8e2de7:	74 0b                	je     8e2df4 <check_data_emit+0x1294>
  8e2de9:	41 ba 03 00 00 00    	mov    r10d,0x3
  8e2def:	e9 d1 f9 ff ff       	jmp    8e27c5 <check_data_emit+0xc65>
  8e2df4:	4c 8b 44 24 20       	mov    r8,QWORD PTR [rsp+0x20]
  8e2df9:	c5 f9 6e 8c 24 88 00 	vmovd  xmm1,DWORD PTR [rsp+0x88]
  8e2e00:	00 00 
  8e2e02:	48 8b bc 24 e0 01 00 	mov    rdi,QWORD PTR [rsp+0x1e0]
  8e2e09:	00 
  8e2e0a:	c5 f9 6e c0          	vmovd  xmm0,eax
  8e2e0e:	41 8b 50 18          	mov    edx,DWORD PTR [r8+0x18]
  8e2e12:	49 8b 48 10          	mov    rcx,QWORD PTR [r8+0x10]
  8e2e16:	c5 f1 62 c0          	vpunpckldq xmm0,xmm1,xmm0
  8e2e1a:	c5 fa 7e c0          	vmovq  xmm0,xmm0
  8e2e1e:	48 8d 14 52          	lea    rdx,[rdx+rdx*2]
  8e2e22:	c5 fa 7f 04 d1       	vmovdqu XMMWORD PTR [rcx+rdx*8],xmm0
  8e2e27:	48 89 7c d1 10       	mov    QWORD PTR [rcx+rdx*8+0x10],rdi
  8e2e2c:	41 ff 40 18          	inc    DWORD PTR [r8+0x18]
  8e2e30:	e9 90 f9 ff ff       	jmp    8e27c5 <check_data_emit+0xc65>
  8e2e35:	44 89 d9             	mov    ecx,r11d
  8e2e38:	f6 d1                	not    cl
  8e2e3a:	0a 8c 24 c0 00 00 00 	or     cl,BYTE PTR [rsp+0xc0]
  8e2e41:	f6 c1 01             	test   cl,0x1
  8e2e44:	0f 85 10 01 00 00    	jne    8e2f5a <check_data_emit+0x13fa>
  8e2e4a:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
  8e2e4f:	b1 01                	mov    cl,0x1
  8e2e51:	89 4c 24 10          	mov    DWORD PTR [rsp+0x10],ecx
  8e2e55:	83 7a 18 00          	cmp    DWORD PTR [rdx+0x18],0x0
  8e2e59:	0f 85 20 01 00 00    	jne    8e2f7f <check_data_emit+0x141f>
  8e2e5f:	48 8b 4b 08          	mov    rcx,QWORD PTR [rbx+0x8]
  8e2e63:	bd 06 00 00 00       	mov    ebp,0x6
  8e2e68:	48 89 8c 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rcx
  8e2e6f:	00 
  8e2e70:	85 c0                	test   eax,eax
  8e2e72:	0f 88 b6 00 00 00    	js     8e2f2e <check_data_emit+0x13ce>
  8e2e78:	48 8b 0b             	mov    rcx,QWORD PTR [rbx]
  8e2e7b:	48 8b b4 24 b8 00 00 	mov    rsi,QWORD PTR [rsp+0xb8]
  8e2e82:	00 
  8e2e83:	48 8d 7c 0e 07       	lea    rdi,[rsi+rcx*1+0x7]
  8e2e88:	48 8d 14 0e          	lea    rdx,[rsi+rcx*1]
  8e2e8c:	48 83 e7 f8          	and    rdi,0xfffffffffffffff8
  8e2e90:	48 89 7c 24 10       	mov    QWORD PTR [rsp+0x10],rdi
  8e2e95:	48 39 d7             	cmp    rdi,rdx
  8e2e98:	73 24                	jae    8e2ebe <check_data_emit+0x135e>
  8e2e9a:	45 31 d2             	xor    r10d,r10d
  8e2e9d:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
  8e2ea4:	00 00 
  8e2ea6:	eb 75                	jmp    8e2f1d <check_data_emit+0x13bd>
  8e2ea8:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e2ead:	bd 06 00 00 00       	mov    ebp,0x6
  8e2eb2:	48 c7 00 00 00 00 00 	mov    QWORD PTR [rax],0x0
  8e2eb9:	e9 fe 08 00 00       	jmp    8e37bc <check_data_emit+0x1c5c>
  8e2ebe:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
  8e2ec3:	4c 8b 43 10          	mov    r8,QWORD PTR [rbx+0x10]
  8e2ec7:	48 89 c6             	mov    rsi,rax
  8e2eca:	48 c1 e6 04          	shl    rsi,0x4
  8e2ece:	48 29 cf             	sub    rdi,rcx
  8e2ed1:	4d 89 c1             	mov    r9,r8
  8e2ed4:	49 29 f9             	sub    r9,rdi
  8e2ed7:	72 2a                	jb     8e2f03 <check_data_emit+0x13a3>
  8e2ed9:	4c 39 ce             	cmp    rsi,r9
  8e2edc:	77 25                	ja     8e2f03 <check_data_emit+0x13a3>
  8e2ede:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  8e2ee3:	48 01 f7             	add    rdi,rsi
  8e2ee6:	4d 89 c1             	mov    r9,r8
  8e2ee9:	48 89 7b 08          	mov    QWORD PTR [rbx+0x8],rdi
  8e2eed:	4c 89 d2             	mov    rdx,r10
  8e2ef0:	48 01 f2             	add    rdx,rsi
  8e2ef3:	48 89 d7             	mov    rdi,rdx
  8e2ef6:	48 29 cf             	sub    rdi,rcx
  8e2ef9:	48 89 54 24 10       	mov    QWORD PTR [rsp+0x10],rdx
  8e2efe:	49 29 f9             	sub    r9,rdi
  8e2f01:	eb 03                	jmp    8e2f06 <check_data_emit+0x13a6>
  8e2f03:	45 31 d2             	xor    r10d,r10d
  8e2f06:	4c 39 c7             	cmp    rdi,r8
  8e2f09:	77 92                	ja     8e2e9d <check_data_emit+0x133d>
  8e2f0b:	4c 39 ce             	cmp    rsi,r9
  8e2f0e:	77 8d                	ja     8e2e9d <check_data_emit+0x133d>
  8e2f10:	48 01 f7             	add    rdi,rsi
  8e2f13:	48 89 7b 08          	mov    QWORD PTR [rbx+0x8],rdi
  8e2f17:	48 01 cf             	add    rdi,rcx
  8e2f1a:	48 89 fa             	mov    rdx,rdi
  8e2f1d:	48 8d 72 03          	lea    rsi,[rdx+0x3]
  8e2f21:	48 83 e6 fc          	and    rsi,0xfffffffffffffffc
  8e2f25:	48 39 d6             	cmp    rsi,rdx
  8e2f28:	0f 83 0d 02 00 00    	jae    8e313b <check_data_emit+0x15db>
  8e2f2e:	45 31 db             	xor    r11d,r11d
  8e2f31:	48 8b 84 24 b8 00 00 	mov    rax,QWORD PTR [rsp+0xb8]
  8e2f38:	00 
  8e2f39:	48 3b 43 08          	cmp    rax,QWORD PTR [rbx+0x8]
  8e2f3d:	0f 87 9e 21 00 00    	ja     8e50e1 <check_data_emit+0x3581>
  8e2f43:	48 8b 84 24 b8 00 00 	mov    rax,QWORD PTR [rsp+0xb8]
  8e2f4a:	00 
  8e2f4b:	41 89 ea             	mov    r10d,ebp
  8e2f4e:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
  8e2f52:	85 ed                	test   ebp,ebp
  8e2f54:	0f 85 df 21 00 00    	jne    8e5139 <check_data_emit+0x35d9>
  8e2f5a:	b0 01                	mov    al,0x1
  8e2f5c:	89 44 24 10          	mov    DWORD PTR [rsp+0x10],eax
  8e2f60:	41 f6 c3 01          	test   r11b,0x1
  8e2f64:	75 19                	jne    8e2f7f <check_data_emit+0x141f>
  8e2f66:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e2f6b:	31 d2                	xor    edx,edx
  8e2f6d:	c7 44 24 10 00 00 00 	mov    DWORD PTR [rsp+0x10],0x0
  8e2f74:	00 
  8e2f75:	83 78 18 00          	cmp    DWORD PTR [rax+0x18],0x0
  8e2f79:	0f 84 a2 01 00 00    	je     8e3121 <check_data_emit+0x15c1>
  8e2f7f:	48 8b 7b 08          	mov    rdi,QWORD PTR [rbx+0x8]
  8e2f83:	48 8b 4b 10          	mov    rcx,QWORD PTR [rbx+0x10]
  8e2f87:	48 29 f9             	sub    rcx,rdi
  8e2f8a:	0f 82 73 21 00 00    	jb     8e5103 <check_data_emit+0x35a3>
  8e2f90:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e2f95:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  8e2f99:	48 39 c8             	cmp    rax,rcx
  8e2f9c:	0f 87 61 21 00 00    	ja     8e5103 <check_data_emit+0x35a3>
  8e2fa2:	48 01 f8             	add    rax,rdi
  8e2fa5:	48 03 3b             	add    rdi,QWORD PTR [rbx]
  8e2fa8:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
  8e2fad:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
  8e2fb1:	48 89 39             	mov    QWORD PTR [rcx],rdi
  8e2fb4:	0f 84 cf 20 00 00    	je     8e5089 <check_data_emit+0x3529>
  8e2fba:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e2fbf:	31 f6                	xor    esi,esi
  8e2fc1:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  8e2fc5:	c5 f8 77             	vzeroupper
  8e2fc8:	e8 a3 b1 ee ff       	call   7ce170 <memset@plt>
  8e2fcd:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  8e2fd2:	83 78 18 00          	cmp    DWORD PTR [rax+0x18],0x0
  8e2fd6:	0f 84 f3 07 00 00    	je     8e37cf <check_data_emit+0x1c6f>
  8e2fdc:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
  8e2fe1:	48 8b 6c 24 20       	mov    rbp,QWORD PTR [rsp+0x20]
  8e2fe6:	48 8b 54 24 40       	mov    rdx,QWORD PTR [rsp+0x40]
  8e2feb:	45 31 d2             	xor    r10d,r10d
  8e2fee:	45 31 f6             	xor    r14d,r14d
  8e2ff1:	eb 27                	jmp    8e301a <check_data_emit+0x14ba>
  8e2ff3:	48 8b 76 28          	mov    rsi,QWORD PTR [rsi+0x28]
  8e2ff7:	e8 94 b2 ee ff       	call   7ce290 <memcpy@plt>
  8e2ffc:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
  8e3001:	48 8b 54 24 40       	mov    rdx,QWORD PTR [rsp+0x40]
  8e3006:	4c 8b 54 24 18       	mov    r10,QWORD PTR [rsp+0x18]
  8e300b:	8b 4a 18             	mov    ecx,DWORD PTR [rdx+0x18]
  8e300e:	49 ff c2             	inc    r10
  8e3011:	49 39 ca             	cmp    r10,rcx
  8e3014:	0f 83 b5 07 00 00    	jae    8e37cf <check_data_emit+0x1c6f>
  8e301a:	48 8b 7a 10          	mov    rdi,QWORD PTR [rdx+0x10]
  8e301e:	4d 69 c2 b0 00 00 00 	imul   r8,r10,0xb0
  8e3025:	42 8b 0c 07          	mov    ecx,DWORD PTR [rdi+r8*1]
  8e3029:	4a 8d 34 07          	lea    rsi,[rdi+r8*1]
  8e302d:	85 c9                	test   ecx,ecx
  8e302f:	74 06                	je     8e3037 <check_data_emit+0x14d7>
  8e3031:	48 8d 56 30          	lea    rdx,[rsi+0x30]
  8e3035:	eb 23                	jmp    8e305a <check_data_emit+0x14fa>
  8e3037:	8b 56 04             	mov    edx,DWORD PTR [rsi+0x4]
  8e303a:	4c 8b 08             	mov    r9,QWORD PTR [rax]
  8e303d:	c1 ea 03             	shr    edx,0x3
  8e3040:	41 80 3c 11 0f       	cmp    BYTE PTR [r9+rdx*1],0xf
  8e3045:	75 0b                	jne    8e3052 <check_data_emit+0x14f2>
  8e3047:	4c 8b 48 20          	mov    r9,QWORD PTR [rax+0x20]
  8e304b:	41 8b 14 91          	mov    edx,DWORD PTR [r9+rdx*4]
  8e304f:	c1 ea 03             	shr    edx,0x3
  8e3052:	4c 8b 48 38          	mov    r9,QWORD PTR [rax+0x38]
  8e3056:	49 8d 14 d1          	lea    rdx,[r9+rdx*8]
  8e305a:	83 7e 20 00          	cmp    DWORD PTR [rsi+0x20],0x0
  8e305e:	4c 89 54 24 18       	mov    QWORD PTR [rsp+0x18],r10
  8e3063:	74 73                	je     8e30d8 <check_data_emit+0x1578>
  8e3065:	4c 89 d2             	mov    rdx,r10
  8e3068:	48 c1 e2 05          	shl    rdx,0x5
  8e306c:	48 03 94 24 80 00 00 	add    rdx,QWORD PTR [rsp+0x80]
  8e3073:	00 
  8e3074:	31 ff                	xor    edi,edi
  8e3076:	eb 44                	jmp    8e30bc <check_data_emit+0x155c>
  8e3078:	48 89 f9             	mov    rcx,rdi
  8e307b:	48 c1 e9 03          	shr    rcx,0x3
  8e307f:	41 89 fb             	mov    r11d,edi
  8e3082:	41 83 e3 07          	and    r11d,0x7
  8e3086:	44 0f b6 14 0a       	movzx  r10d,BYTE PTR [rdx+rcx*1]
  8e308b:	41 0f b6 c9          	movzx  ecx,r9b
  8e308f:	45 0f a3 da          	bt     r10d,r11d
  8e3093:	41 0f 43 ce          	cmovae ecx,r14d
  8e3097:	4c 8b 55 00          	mov    r10,QWORD PTR [rbp+0x0]
  8e309b:	49 c1 e8 03          	shr    r8,0x3
  8e309f:	41 f6 d1             	not    r9b
  8e30a2:	48 ff c7             	inc    rdi
  8e30a5:	47 22 0c 02          	and    r9b,BYTE PTR [r10+r8*1]
  8e30a9:	41 08 c9             	or     r9b,cl
  8e30ac:	47 88 0c 02          	mov    BYTE PTR [r10+r8*1],r9b
  8e30b0:	8b 4e 20             	mov    ecx,DWORD PTR [rsi+0x20]
  8e30b3:	48 39 cf             	cmp    rdi,rcx
  8e30b6:	0f 83 45 ff ff ff    	jae    8e3001 <check_data_emit+0x14a1>
  8e30bc:	4c 8b 46 18          	mov    r8,QWORD PTR [rsi+0x18]
  8e30c0:	41 b1 01             	mov    r9b,0x1
  8e30c3:	49 01 f8             	add    r8,rdi
  8e30c6:	44 89 c1             	mov    ecx,r8d
  8e30c9:	80 e1 07             	and    cl,0x7
  8e30cc:	41 d2 e1             	shl    r9b,cl
  8e30cf:	83 3e 00             	cmp    DWORD PTR [rsi],0x0
  8e30d2:	74 a4                	je     8e3078 <check_data_emit+0x1518>
  8e30d4:	31 c9                	xor    ecx,ecx
  8e30d6:	eb bf                	jmp    8e3097 <check_data_emit+0x1537>
  8e30d8:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
  8e30db:	48 85 d2             	test   rdx,rdx
  8e30de:	0f 84 1d ff ff ff    	je     8e3001 <check_data_emit+0x14a1>
  8e30e4:	4a 8b 7c 07 18       	mov    rdi,QWORD PTR [rdi+r8*1+0x18]
  8e30e9:	48 c1 ef 03          	shr    rdi,0x3
  8e30ed:	48 03 7d 00          	add    rdi,QWORD PTR [rbp+0x0]
  8e30f1:	83 f9 01             	cmp    ecx,0x1
  8e30f4:	0f 84 f9 fe ff ff    	je     8e2ff3 <check_data_emit+0x1493>
  8e30fa:	83 f9 02             	cmp    ecx,0x2
  8e30fd:	75 0c                	jne    8e310b <check_data_emit+0x15ab>
  8e30ff:	31 f6                	xor    esi,esi
  8e3101:	e8 6a b0 ee ff       	call   7ce170 <memset@plt>
  8e3106:	e9 f1 fe ff ff       	jmp    8e2ffc <check_data_emit+0x149c>
  8e310b:	48 8b 74 24 18       	mov    rsi,QWORD PTR [rsp+0x18]
  8e3110:	48 c1 e6 05          	shl    rsi,0x5
  8e3114:	48 03 b4 24 80 00 00 	add    rsi,QWORD PTR [rsp+0x80]
  8e311b:	00 
  8e311c:	e9 d6 fe ff ff       	jmp    8e2ff7 <check_data_emit+0x1497>
  8e3121:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e3126:	c7 44 24 10 00 00 00 	mov    DWORD PTR [rsp+0x10],0x0
  8e312d:	00 
  8e312e:	48 8d 48 18          	lea    rcx,[rax+0x18]
  8e3132:	48 83 c0 10          	add    rax,0x10
  8e3136:	e9 e5 0a 00 00       	jmp    8e3c20 <check_data_emit+0x20c0>
  8e313b:	48 89 f2             	mov    rdx,rsi
  8e313e:	48 29 ca             	sub    rdx,rcx
  8e3141:	48 8b 4b 10          	mov    rcx,QWORD PTR [rbx+0x10]
  8e3145:	45 31 db             	xor    r11d,r11d
  8e3148:	48 29 d1             	sub    rcx,rdx
  8e314b:	0f 82 e0 fd ff ff    	jb     8e2f31 <check_data_emit+0x13d1>
  8e3151:	48 01 c0             	add    rax,rax
  8e3154:	48 c1 e0 02          	shl    rax,0x2
  8e3158:	48 39 c8             	cmp    rax,rcx
  8e315b:	0f 87 d0 fd ff ff    	ja     8e2f31 <check_data_emit+0x13d1>
  8e3161:	48 01 c2             	add    rdx,rax
  8e3164:	4d 85 d2             	test   r10,r10
  8e3167:	41 bb 00 00 00 00    	mov    r11d,0x0
  8e316d:	0f 95 c0             	setne  al
  8e3170:	48 83 7c 24 10 00    	cmp    QWORD PTR [rsp+0x10],0x0
  8e3176:	48 89 53 08          	mov    QWORD PTR [rbx+0x8],rdx
  8e317a:	0f 95 c1             	setne  cl
  8e317d:	20 c1                	and    cl,al
  8e317f:	48 85 f6             	test   rsi,rsi
  8e3182:	0f 95 c0             	setne  al
  8e3185:	31 d2                	xor    edx,edx
  8e3187:	84 c1                	test   cl,al
  8e3189:	b9 06 00 00 00       	mov    ecx,0x6
  8e318e:	0f 45 ca             	cmovne ecx,edx
  8e3191:	89 8c 24 88 00 00 00 	mov    DWORD PTR [rsp+0x88],ecx
  8e3198:	0f 84 93 fd ff ff    	je     8e2f31 <check_data_emit+0x13d1>
  8e319e:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  8e31a3:	83 78 18 00          	cmp    DWORD PTR [rax+0x18],0x0
  8e31a7:	0f 84 e9 00 00 00    	je     8e3296 <check_data_emit+0x1736>
  8e31ad:	b8 30 00 00 00       	mov    eax,0x30
  8e31b2:	45 31 db             	xor    r11d,r11d
  8e31b5:	31 c9                	xor    ecx,ecx
  8e31b7:	48 8b 54 24 40       	mov    rdx,QWORD PTR [rsp+0x40]
  8e31bc:	48 8b 52 10          	mov    rdx,QWORD PTR [rdx+0x10]
  8e31c0:	8b 7c 02 d4          	mov    edi,DWORD PTR [rdx+rax*1-0x2c]
  8e31c4:	c1 ef 03             	shr    edi,0x3
  8e31c7:	0f 84 19 20 00 00    	je     8e51e6 <check_data_emit+0x3686>
  8e31cd:	4c 8b 44 24 28       	mov    r8,QWORD PTR [rsp+0x28]
  8e31d2:	41 3b 78 48          	cmp    edi,DWORD PTR [r8+0x48]
  8e31d6:	0f 83 0a 20 00 00    	jae    8e51e6 <check_data_emit+0x3686>
  8e31dc:	4c 8b 44 24 28       	mov    r8,QWORD PTR [rsp+0x28]
  8e31e1:	4d 8b 00             	mov    r8,QWORD PTR [r8]
  8e31e4:	45 0f b6 04 38       	movzx  r8d,BYTE PTR [r8+rdi*1]
  8e31e9:	45 84 c0             	test   r8b,r8b
  8e31ec:	0f 84 f4 1f 00 00    	je     8e51e6 <check_data_emit+0x3686>
  8e31f2:	44 8b 4c 02 d0       	mov    r9d,DWORD PTR [rdx+rax*1-0x30]
  8e31f7:	41 83 f9 02          	cmp    r9d,0x2
  8e31fb:	0f 87 e5 1f 00 00    	ja     8e51e6 <check_data_emit+0x3686>
  8e3201:	45 85 c9             	test   r9d,r9d
  8e3204:	74 06                	je     8e320c <check_data_emit+0x16ac>
  8e3206:	4c 8d 04 02          	lea    r8,[rdx+rax*1]
  8e320a:	eb 23                	jmp    8e322f <check_data_emit+0x16cf>
  8e320c:	41 80 f8 0f          	cmp    r8b,0xf
  8e3210:	75 10                	jne    8e3222 <check_data_emit+0x16c2>
  8e3212:	4c 8b 44 24 28       	mov    r8,QWORD PTR [rsp+0x28]
  8e3217:	4d 8b 40 20          	mov    r8,QWORD PTR [r8+0x20]
  8e321b:	41 8b 3c b8          	mov    edi,DWORD PTR [r8+rdi*4]
  8e321f:	c1 ef 03             	shr    edi,0x3
  8e3222:	4c 8b 44 24 28       	mov    r8,QWORD PTR [rsp+0x28]
  8e3227:	4d 8b 40 38          	mov    r8,QWORD PTR [r8+0x38]
  8e322b:	4d 8d 04 f8          	lea    r8,[r8+rdi*8]
  8e322f:	8b 7c 02 f0          	mov    edi,DWORD PTR [rdx+rax*1-0x10]
  8e3233:	48 85 ff             	test   rdi,rdi
  8e3236:	75 15                	jne    8e324d <check_data_emit+0x16ed>
  8e3238:	49 8b 38             	mov    rdi,QWORD PTR [r8]
  8e323b:	48 3b bc 24 e0 00 00 	cmp    rdi,QWORD PTR [rsp+0xe0]
  8e3242:	00 
  8e3243:	0f 87 9d 1f 00 00    	ja     8e51e6 <check_data_emit+0x3686>
  8e3249:	48 c1 e7 03          	shl    rdi,0x3
  8e324d:	4c 8b 44 02 e8       	mov    r8,QWORD PTR [rdx+rax*1-0x18]
  8e3252:	4d 89 c1             	mov    r9,r8
  8e3255:	49 01 f9             	add    r9,rdi
  8e3258:	0f 82 88 1f 00 00    	jb     8e51e6 <check_data_emit+0x3686>
  8e325e:	4d 89 de             	mov    r14,r11
  8e3261:	45 8d 4b 01          	lea    r9d,[r11+0x1]
  8e3265:	45 89 f3             	mov    r11d,r14d
  8e3268:	4f 89 04 da          	mov    QWORD PTR [r10+r11*8],r8
  8e326c:	41 83 c6 02          	add    r14d,0x2
  8e3270:	48 ff c1             	inc    rcx
  8e3273:	48 03 7c 02 e8       	add    rdi,QWORD PTR [rdx+rax*1-0x18]
  8e3278:	48 8b 54 24 40       	mov    rdx,QWORD PTR [rsp+0x40]
  8e327d:	48 05 b0 00 00 00    	add    rax,0xb0
  8e3283:	4d 89 f3             	mov    r11,r14
  8e3286:	4b 89 3c ca          	mov    QWORD PTR [r10+r9*8],rdi
  8e328a:	8b 52 18             	mov    edx,DWORD PTR [rdx+0x18]
  8e328d:	48 39 d1             	cmp    rcx,rdx
  8e3290:	0f 82 21 ff ff ff    	jb     8e31b7 <check_data_emit+0x1657>
  8e3296:	44 89 d8             	mov    eax,r11d
  8e3299:	89 c7                	mov    edi,eax
  8e329b:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
  8e32a0:	83 e0 f8             	and    eax,0xfffffff8
  8e32a3:	83 e7 07             	and    edi,0x7
  8e32a6:	45 31 c9             	xor    r9d,r9d
  8e32a9:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
  8e32ae:	eb 18                	jmp    8e32c8 <check_data_emit+0x1768>
  8e32b0:	49 83 f9 37          	cmp    r9,0x37
  8e32b4:	0f 87 15 10 00 00    	ja     8e42cf <check_data_emit+0x276f>
  8e32ba:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  8e32bf:	49 83 c1 08          	add    r9,0x8
  8e32c3:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
  8e32c8:	48 83 7c 24 18 00    	cmp    QWORD PTR [rsp+0x18],0x0
  8e32ce:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e32d2:	4c 89 d0             	mov    rax,r10
  8e32d5:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x5b0],zmm0
  8e32dc:	b0 05 00 00 
  8e32e0:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x570],zmm0
  8e32e7:	70 05 00 00 
  8e32eb:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x530],zmm0
  8e32f2:	30 05 00 00 
  8e32f6:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x4f0],zmm0
  8e32fd:	f0 04 00 00 
  8e3301:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x4b0],zmm0
  8e3308:	b0 04 00 00 
  8e330c:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x470],zmm0
  8e3313:	70 04 00 00 
  8e3317:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x430],zmm0
  8e331e:	30 04 00 00 
  8e3322:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x3f0],zmm0
  8e3329:	f0 03 00 00 
  8e332d:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x3b0],zmm0
  8e3334:	b0 03 00 00 
  8e3338:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x370],zmm0
  8e333f:	70 03 00 00 
  8e3343:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x330],zmm0
  8e334a:	30 03 00 00 
  8e334e:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x2f0],zmm0
  8e3355:	f0 02 00 00 
  8e3359:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x2b0],zmm0
  8e3360:	b0 02 00 00 
  8e3364:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x270],zmm0
  8e336b:	70 02 00 00 
  8e336f:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x230],zmm0
  8e3376:	30 02 00 00 
  8e337a:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x1f0],zmm0
  8e3381:	f0 01 00 00 
  8e3385:	0f 84 df 00 00 00    	je     8e346a <check_data_emit+0x190a>
  8e338b:	83 7c 24 18 08       	cmp    DWORD PTR [rsp+0x18],0x8
  8e3390:	73 07                	jae    8e3399 <check_data_emit+0x1839>
  8e3392:	31 d2                	xor    edx,edx
  8e3394:	e9 b0 00 00 00       	jmp    8e3449 <check_data_emit+0x18e9>
  8e3399:	48 8b 4c 24 38       	mov    rcx,QWORD PTR [rsp+0x38]
  8e339e:	31 d2                	xor    edx,edx
  8e33a0:	c4 62 b3 f7 14 d0    	shrx   r10,QWORD PTR [rax+rdx*8],r9
  8e33a6:	45 0f b6 d2          	movzx  r10d,r10b
  8e33aa:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e33b1:	00 
  8e33b2:	c4 62 b3 f7 54 d0 08 	shrx   r10,QWORD PTR [rax+rdx*8+0x8],r9
  8e33b9:	45 0f b6 d2          	movzx  r10d,r10b
  8e33bd:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e33c4:	00 
  8e33c5:	c4 62 b3 f7 54 d0 10 	shrx   r10,QWORD PTR [rax+rdx*8+0x10],r9
  8e33cc:	45 0f b6 d2          	movzx  r10d,r10b
  8e33d0:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e33d7:	00 
  8e33d8:	c4 62 b3 f7 54 d0 18 	shrx   r10,QWORD PTR [rax+rdx*8+0x18],r9
  8e33df:	45 0f b6 d2          	movzx  r10d,r10b
  8e33e3:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e33ea:	00 
  8e33eb:	c4 62 b3 f7 54 d0 20 	shrx   r10,QWORD PTR [rax+rdx*8+0x20],r9
  8e33f2:	45 0f b6 d2          	movzx  r10d,r10b
  8e33f6:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e33fd:	00 
  8e33fe:	c4 62 b3 f7 54 d0 28 	shrx   r10,QWORD PTR [rax+rdx*8+0x28],r9
  8e3405:	45 0f b6 d2          	movzx  r10d,r10b
  8e3409:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e3410:	00 
  8e3411:	c4 62 b3 f7 54 d0 30 	shrx   r10,QWORD PTR [rax+rdx*8+0x30],r9
  8e3418:	45 0f b6 d2          	movzx  r10d,r10b
  8e341c:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e3423:	00 
  8e3424:	c4 62 b3 f7 54 d0 38 	shrx   r10,QWORD PTR [rax+rdx*8+0x38],r9
  8e342b:	48 83 c2 08          	add    rdx,0x8
  8e342f:	45 0f b6 d2          	movzx  r10d,r10b
  8e3433:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e343a:	00 
  8e343b:	48 39 d1             	cmp    rcx,rdx
  8e343e:	0f 85 5c ff ff ff    	jne    8e33a0 <check_data_emit+0x1840>
  8e3444:	48 85 ff             	test   rdi,rdi
  8e3447:	74 21                	je     8e346a <check_data_emit+0x190a>
  8e3449:	48 8d 14 d0          	lea    rdx,[rax+rdx*8]
  8e344d:	45 31 d2             	xor    r10d,r10d
  8e3450:	c4 22 b3 f7 1c d2    	shrx   r11,QWORD PTR [rdx+r10*8],r9
  8e3456:	49 ff c2             	inc    r10
  8e3459:	45 0f b6 db          	movzx  r11d,r11b
  8e345d:	42 ff 84 9c f0 01 00 	inc    DWORD PTR [rsp+r11*4+0x1f0]
  8e3464:	00 
  8e3465:	4c 39 d7             	cmp    rdi,r10
  8e3468:	75 e6                	jne    8e3450 <check_data_emit+0x18f0>
  8e346a:	45 31 d2             	xor    r10d,r10d
  8e346d:	31 d2                	xor    edx,edx
  8e346f:	44 8b 9c 94 f0 01 00 	mov    r11d,DWORD PTR [rsp+rdx*4+0x1f0]
  8e3476:	00 
  8e3477:	44 89 94 94 f0 01 00 	mov    DWORD PTR [rsp+rdx*4+0x1f0],r10d
  8e347e:	00 
  8e347f:	45 01 d3             	add    r11d,r10d
  8e3482:	44 8b 94 94 f4 01 00 	mov    r10d,DWORD PTR [rsp+rdx*4+0x1f4]
  8e3489:	00 
  8e348a:	44 89 9c 94 f4 01 00 	mov    DWORD PTR [rsp+rdx*4+0x1f4],r11d
  8e3491:	00 
  8e3492:	8b 8c 94 f8 01 00 00 	mov    ecx,DWORD PTR [rsp+rdx*4+0x1f8]
  8e3499:	45 01 da             	add    r10d,r11d
  8e349c:	44 89 94 94 f8 01 00 	mov    DWORD PTR [rsp+rdx*4+0x1f8],r10d
  8e34a3:	00 
  8e34a4:	44 01 d1             	add    ecx,r10d
  8e34a7:	44 8b 94 94 fc 01 00 	mov    r10d,DWORD PTR [rsp+rdx*4+0x1fc]
  8e34ae:	00 
  8e34af:	89 8c 94 fc 01 00 00 	mov    DWORD PTR [rsp+rdx*4+0x1fc],ecx
  8e34b6:	44 8b 84 94 00 02 00 	mov    r8d,DWORD PTR [rsp+rdx*4+0x200]
  8e34bd:	00 
  8e34be:	41 01 ca             	add    r10d,ecx
  8e34c1:	44 89 94 94 00 02 00 	mov    DWORD PTR [rsp+rdx*4+0x200],r10d
  8e34c8:	00 
  8e34c9:	45 01 d0             	add    r8d,r10d
  8e34cc:	44 8b 94 94 04 02 00 	mov    r10d,DWORD PTR [rsp+rdx*4+0x204]
  8e34d3:	00 
  8e34d4:	44 89 84 94 04 02 00 	mov    DWORD PTR [rsp+rdx*4+0x204],r8d
  8e34db:	00 
  8e34dc:	8b 8c 94 08 02 00 00 	mov    ecx,DWORD PTR [rsp+rdx*4+0x208]
  8e34e3:	45 01 c2             	add    r10d,r8d
  8e34e6:	44 89 94 94 08 02 00 	mov    DWORD PTR [rsp+rdx*4+0x208],r10d
  8e34ed:	00 
  8e34ee:	44 01 d1             	add    ecx,r10d
  8e34f1:	44 8b 94 94 0c 02 00 	mov    r10d,DWORD PTR [rsp+rdx*4+0x20c]
  8e34f8:	00 
  8e34f9:	89 8c 94 0c 02 00 00 	mov    DWORD PTR [rsp+rdx*4+0x20c],ecx
  8e3500:	44 8b 84 94 10 02 00 	mov    r8d,DWORD PTR [rsp+rdx*4+0x210]
  8e3507:	00 
  8e3508:	41 01 ca             	add    r10d,ecx
  8e350b:	44 89 94 94 10 02 00 	mov    DWORD PTR [rsp+rdx*4+0x210],r10d
  8e3512:	00 
  8e3513:	45 01 d0             	add    r8d,r10d
  8e3516:	44 8b 94 94 14 02 00 	mov    r10d,DWORD PTR [rsp+rdx*4+0x214]
  8e351d:	00 
  8e351e:	44 89 84 94 14 02 00 	mov    DWORD PTR [rsp+rdx*4+0x214],r8d
  8e3525:	00 
  8e3526:	8b 8c 94 18 02 00 00 	mov    ecx,DWORD PTR [rsp+rdx*4+0x218]
  8e352d:	45 01 c2             	add    r10d,r8d
  8e3530:	44 89 94 94 18 02 00 	mov    DWORD PTR [rsp+rdx*4+0x218],r10d
  8e3537:	00 
  8e3538:	44 01 d1             	add    ecx,r10d
  8e353b:	44 8b 94 94 1c 02 00 	mov    r10d,DWORD PTR [rsp+rdx*4+0x21c]
  8e3542:	00 
  8e3543:	89 8c 94 1c 02 00 00 	mov    DWORD PTR [rsp+rdx*4+0x21c],ecx
  8e354a:	44 8b 84 94 20 02 00 	mov    r8d,DWORD PTR [rsp+rdx*4+0x220]
  8e3551:	00 
  8e3552:	41 01 ca             	add    r10d,ecx
  8e3555:	44 89 94 94 20 02 00 	mov    DWORD PTR [rsp+rdx*4+0x220],r10d
  8e355c:	00 
  8e355d:	45 01 d0             	add    r8d,r10d
  8e3560:	44 8b 94 94 24 02 00 	mov    r10d,DWORD PTR [rsp+rdx*4+0x224]
  8e3567:	00 
  8e3568:	44 89 84 94 24 02 00 	mov    DWORD PTR [rsp+rdx*4+0x224],r8d
  8e356f:	00 
  8e3570:	8b 8c 94 28 02 00 00 	mov    ecx,DWORD PTR [rsp+rdx*4+0x228]
  8e3577:	45 01 c2             	add    r10d,r8d
  8e357a:	44 89 94 94 28 02 00 	mov    DWORD PTR [rsp+rdx*4+0x228],r10d
  8e3581:	00 
  8e3582:	44 01 d1             	add    ecx,r10d
  8e3585:	44 8b 94 94 2c 02 00 	mov    r10d,DWORD PTR [rsp+rdx*4+0x22c]
  8e358c:	00 
  8e358d:	89 8c 94 2c 02 00 00 	mov    DWORD PTR [rsp+rdx*4+0x22c],ecx
  8e3594:	48 83 c2 10          	add    rdx,0x10
  8e3598:	41 01 ca             	add    r10d,ecx
  8e359b:	48 81 fa 00 01 00 00 	cmp    rdx,0x100
  8e35a2:	0f 85 c7 fe ff ff    	jne    8e346f <check_data_emit+0x190f>
  8e35a8:	48 83 7c 24 18 00    	cmp    QWORD PTR [rsp+0x18],0x0
  8e35ae:	0f 84 fc fc ff ff    	je     8e32b0 <check_data_emit+0x1750>
  8e35b4:	83 7c 24 18 08       	cmp    DWORD PTR [rsp+0x18],0x8
  8e35b9:	73 0c                	jae    8e35c7 <check_data_emit+0x1a67>
  8e35bb:	48 8b 6c 24 10       	mov    rbp,QWORD PTR [rsp+0x10]
  8e35c0:	31 d2                	xor    edx,edx
  8e35c2:	e9 52 01 00 00       	jmp    8e3719 <check_data_emit+0x1bb9>
  8e35c7:	4c 8b 74 24 10       	mov    r14,QWORD PTR [rsp+0x10]
  8e35cc:	48 8b 6c 24 38       	mov    rbp,QWORD PTR [rsp+0x38]
  8e35d1:	31 d2                	xor    edx,edx
  8e35d3:	48 8b 0c d0          	mov    rcx,QWORD PTR [rax+rdx*8]
  8e35d7:	c4 62 b3 f7 c1       	shrx   r8,rcx,r9
  8e35dc:	45 0f b6 c0          	movzx  r8d,r8b
  8e35e0:	46 8b 94 84 f0 01 00 	mov    r10d,DWORD PTR [rsp+r8*4+0x1f0]
  8e35e7:	00 
  8e35e8:	45 8d 5a 01          	lea    r11d,[r10+0x1]
  8e35ec:	46 89 9c 84 f0 01 00 	mov    DWORD PTR [rsp+r8*4+0x1f0],r11d
  8e35f3:	00 
  8e35f4:	4b 89 0c d6          	mov    QWORD PTR [r14+r10*8],rcx
  8e35f8:	48 8b 4c d0 08       	mov    rcx,QWORD PTR [rax+rdx*8+0x8]
  8e35fd:	c4 62 b3 f7 c1       	shrx   r8,rcx,r9
  8e3602:	45 0f b6 c0          	movzx  r8d,r8b
  8e3606:	46 8b 94 84 f0 01 00 	mov    r10d,DWORD PTR [rsp+r8*4+0x1f0]
  8e360d:	00 
  8e360e:	45 8d 5a 01          	lea    r11d,[r10+0x1]
  8e3612:	46 89 9c 84 f0 01 00 	mov    DWORD PTR [rsp+r8*4+0x1f0],r11d
  8e3619:	00 
  8e361a:	4b 89 0c d6          	mov    QWORD PTR [r14+r10*8],rcx
  8e361e:	48 8b 4c d0 10       	mov    rcx,QWORD PTR [rax+rdx*8+0x10]
  8e3623:	c4 62 b3 f7 c1       	shrx   r8,rcx,r9
  8e3628:	45 0f b6 c0          	movzx  r8d,r8b
  8e362c:	46 8b 94 84 f0 01 00 	mov    r10d,DWORD PTR [rsp+r8*4+0x1f0]
  8e3633:	00 
  8e3634:	45 8d 5a 01          	lea    r11d,[r10+0x1]
  8e3638:	46 89 9c 84 f0 01 00 	mov    DWORD PTR [rsp+r8*4+0x1f0],r11d
  8e363f:	00 
  8e3640:	4b 89 0c d6          	mov    QWORD PTR [r14+r10*8],rcx
  8e3644:	48 8b 4c d0 18       	mov    rcx,QWORD PTR [rax+rdx*8+0x18]
  8e3649:	c4 62 b3 f7 c1       	shrx   r8,rcx,r9
  8e364e:	45 0f b6 c0          	movzx  r8d,r8b
  8e3652:	46 8b 94 84 f0 01 00 	mov    r10d,DWORD PTR [rsp+r8*4+0x1f0]
  8e3659:	00 
  8e365a:	45 8d 5a 01          	lea    r11d,[r10+0x1]
  8e365e:	46 89 9c 84 f0 01 00 	mov    DWORD PTR [rsp+r8*4+0x1f0],r11d
  8e3665:	00 
  8e3666:	4b 89 0c d6          	mov    QWORD PTR [r14+r10*8],rcx
  8e366a:	48 8b 4c d0 20       	mov    rcx,QWORD PTR [rax+rdx*8+0x20]
  8e366f:	c4 62 b3 f7 c1       	shrx   r8,rcx,r9
  8e3674:	45 0f b6 c0          	movzx  r8d,r8b
  8e3678:	46 8b 94 84 f0 01 00 	mov    r10d,DWORD PTR [rsp+r8*4+0x1f0]
  8e367f:	00 
  8e3680:	45 8d 5a 01          	lea    r11d,[r10+0x1]
  8e3684:	46 89 9c 84 f0 01 00 	mov    DWORD PTR [rsp+r8*4+0x1f0],r11d
  8e368b:	00 
  8e368c:	4b 89 0c d6          	mov    QWORD PTR [r14+r10*8],rcx
  8e3690:	48 8b 4c d0 28       	mov    rcx,QWORD PTR [rax+rdx*8+0x28]
  8e3695:	c4 62 b3 f7 c1       	shrx   r8,rcx,r9
  8e369a:	45 0f b6 c0          	movzx  r8d,r8b
  8e369e:	46 8b 94 84 f0 01 00 	mov    r10d,DWORD PTR [rsp+r8*4+0x1f0]
  8e36a5:	00 
  8e36a6:	45 8d 5a 01          	lea    r11d,[r10+0x1]
  8e36aa:	46 89 9c 84 f0 01 00 	mov    DWORD PTR [rsp+r8*4+0x1f0],r11d
  8e36b1:	00 
  8e36b2:	4b 89 0c d6          	mov    QWORD PTR [r14+r10*8],rcx
  8e36b6:	48 8b 4c d0 30       	mov    rcx,QWORD PTR [rax+rdx*8+0x30]
  8e36bb:	c4 62 b3 f7 c1       	shrx   r8,rcx,r9
  8e36c0:	45 0f b6 c0          	movzx  r8d,r8b
  8e36c4:	46 8b 94 84 f0 01 00 	mov    r10d,DWORD PTR [rsp+r8*4+0x1f0]
  8e36cb:	00 
  8e36cc:	45 8d 5a 01          	lea    r11d,[r10+0x1]
  8e36d0:	46 89 9c 84 f0 01 00 	mov    DWORD PTR [rsp+r8*4+0x1f0],r11d
  8e36d7:	00 
  8e36d8:	4b 89 0c d6          	mov    QWORD PTR [r14+r10*8],rcx
  8e36dc:	48 8b 4c d0 38       	mov    rcx,QWORD PTR [rax+rdx*8+0x38]
  8e36e1:	48 83 c2 08          	add    rdx,0x8
  8e36e5:	c4 62 b3 f7 c1       	shrx   r8,rcx,r9
  8e36ea:	45 0f b6 c0          	movzx  r8d,r8b
  8e36ee:	46 8b 94 84 f0 01 00 	mov    r10d,DWORD PTR [rsp+r8*4+0x1f0]
  8e36f5:	00 
  8e36f6:	45 8d 5a 01          	lea    r11d,[r10+0x1]
  8e36fa:	46 89 9c 84 f0 01 00 	mov    DWORD PTR [rsp+r8*4+0x1f0],r11d
  8e3701:	00 
  8e3702:	4b 89 0c d6          	mov    QWORD PTR [r14+r10*8],rcx
  8e3706:	48 39 d5             	cmp    rbp,rdx
  8e3709:	0f 85 c4 fe ff ff    	jne    8e35d3 <check_data_emit+0x1a73>
  8e370f:	f6 44 24 18 07       	test   BYTE PTR [rsp+0x18],0x7
  8e3714:	4c 89 f5             	mov    rbp,r14
  8e3717:	74 35                	je     8e374e <check_data_emit+0x1bee>
  8e3719:	48 8d 14 d0          	lea    rdx,[rax+rdx*8]
  8e371d:	45 31 d2             	xor    r10d,r10d
  8e3720:	4e 8b 1c d2          	mov    r11,QWORD PTR [rdx+r10*8]
  8e3724:	49 ff c2             	inc    r10
  8e3727:	c4 42 b3 f7 f3       	shrx   r14,r11,r9
  8e372c:	45 0f b6 f6          	movzx  r14d,r14b
  8e3730:	42 8b 8c b4 f0 01 00 	mov    ecx,DWORD PTR [rsp+r14*4+0x1f0]
  8e3737:	00 
  8e3738:	44 8d 41 01          	lea    r8d,[rcx+0x1]
  8e373c:	46 89 84 b4 f0 01 00 	mov    DWORD PTR [rsp+r14*4+0x1f0],r8d
  8e3743:	00 
  8e3744:	4c 89 5c cd 00       	mov    QWORD PTR [rbp+rcx*8+0x0],r11
  8e3749:	4c 39 d7             	cmp    rdi,r10
  8e374c:	75 d2                	jne    8e3720 <check_data_emit+0x1bc0>
  8e374e:	49 83 f9 38          	cmp    r9,0x38
  8e3752:	0f 82 62 fb ff ff    	jb     8e32ba <check_data_emit+0x175a>
  8e3758:	48 8b 4c 24 18       	mov    rcx,QWORD PTR [rsp+0x18]
  8e375d:	89 c8                	mov    eax,ecx
  8e375f:	83 e0 03             	and    eax,0x3
  8e3762:	83 f9 04             	cmp    ecx,0x4
  8e3765:	0f 83 72 0b 00 00    	jae    8e42dd <check_data_emit+0x277d>
  8e376b:	31 d2                	xor    edx,edx
  8e376d:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
  8e3774:	00 00 
  8e3776:	e9 b5 0c 00 00       	jmp    8e4430 <check_data_emit+0x28d0>
  8e377b:	48 8b 74 24 20       	mov    rsi,QWORD PTR [rsp+0x20]
  8e3780:	48 83 c2 18          	add    rdx,0x18
  8e3784:	48 89 53 08          	mov    QWORD PTR [rbx+0x8],rdx
  8e3788:	48 89 4e 10          	mov    QWORD PTR [rsi+0x10],rcx
  8e378c:	48 85 c9             	test   rcx,rcx
  8e378f:	74 2b                	je     8e37bc <check_data_emit+0x1c5c>
  8e3791:	c5 f9 6e c0          	vmovd  xmm0,eax
  8e3795:	c4 e2 79 00 05 82 01 	vpshufb xmm0,xmm0,XMMWORD PTR [rip+0xffffffffffcc0182]        # 5a3920 <abi_test_hex.digits+0x1ed0>
  8e379c:	cc ff 
  8e379e:	48 8b 94 24 18 02 00 	mov    rdx,QWORD PTR [rsp+0x218]
  8e37a5:	00 
  8e37a6:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e37ab:	c5 fa 7f 01          	vmovdqu XMMWORD PTR [rcx],xmm0
  8e37af:	48 89 51 10          	mov    QWORD PTR [rcx+0x10],rdx
  8e37b3:	c7 40 18 01 00 00 00 	mov    DWORD PTR [rax+0x18],0x1
  8e37ba:	31 ed                	xor    ebp,ebp
  8e37bc:	41 89 ea             	mov    r10d,ebp
  8e37bf:	85 ed                	test   ebp,ebp
  8e37c1:	0f 85 72 19 00 00    	jne    8e5139 <check_data_emit+0x35d9>
  8e37c7:	c7 44 24 10 00 00 00 	mov    DWORD PTR [rsp+0x10],0x0
  8e37ce:	00 
  8e37cf:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e37d4:	8b 70 18             	mov    esi,DWORD PTR [rax+0x18]
  8e37d7:	48 83 fe 02          	cmp    rsi,0x2
  8e37db:	0f 82 bf 03 00 00    	jb     8e3ba0 <check_data_emit+0x2040>
  8e37e1:	48 8b 03             	mov    rax,QWORD PTR [rbx]
  8e37e4:	48 8b 53 08          	mov    rdx,QWORD PTR [rbx+0x8]
  8e37e8:	48 8d 4c 02 07       	lea    rcx,[rdx+rax*1+0x7]
  8e37ed:	48 01 c2             	add    rdx,rax
  8e37f0:	48 83 e1 f8          	and    rcx,0xfffffffffffffff8
  8e37f4:	48 39 d1             	cmp    rcx,rdx
  8e37f7:	73 04                	jae    8e37fd <check_data_emit+0x1c9d>
  8e37f9:	31 c0                	xor    eax,eax
  8e37fb:	eb 36                	jmp    8e3833 <check_data_emit+0x1cd3>
  8e37fd:	48 8b 7b 10          	mov    rdi,QWORD PTR [rbx+0x10]
  8e3801:	48 89 ca             	mov    rdx,rcx
  8e3804:	48 29 c2             	sub    rdx,rax
  8e3807:	48 29 d7             	sub    rdi,rdx
  8e380a:	72 ed                	jb     8e37f9 <check_data_emit+0x1c99>
  8e380c:	48 89 f0             	mov    rax,rsi
  8e380f:	48 c1 e0 03          	shl    rax,0x3
  8e3813:	4c 8d 04 40          	lea    r8,[rax+rax*2]
  8e3817:	b8 00 00 00 00       	mov    eax,0x0
  8e381c:	49 39 f8             	cmp    r8,rdi
  8e381f:	77 12                	ja     8e3833 <check_data_emit+0x1cd3>
  8e3821:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e3826:	4c 01 c2             	add    rdx,r8
  8e3829:	48 89 53 08          	mov    QWORD PTR [rbx+0x8],rdx
  8e382d:	8b 70 18             	mov    esi,DWORD PTR [rax+0x18]
  8e3830:	48 89 c8             	mov    rax,rcx
  8e3833:	83 fe 02             	cmp    esi,0x2
  8e3836:	72 09                	jb     8e3841 <check_data_emit+0x1ce1>
  8e3838:	48 85 c0             	test   rax,rax
  8e383b:	0f 84 48 18 00 00    	je     8e5089 <check_data_emit+0x3529>
  8e3841:	83 fe 02             	cmp    esi,0x2
  8e3844:	0f 82 56 03 00 00    	jb     8e3ba0 <check_data_emit+0x2040>
  8e384a:	4c 8b 74 24 20       	mov    r14,QWORD PTR [rsp+0x20]
  8e384f:	31 c9                	xor    ecx,ecx
  8e3851:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  8e3855:	49 8b 7e 10          	mov    rdi,QWORD PTR [r14+0x10]
  8e3859:	41 89 f0             	mov    r8d,esi
  8e385c:	48 89 fa             	mov    rdx,rdi
  8e385f:	44 89 c7             	mov    edi,r8d
  8e3862:	83 e7 07             	and    edi,0x7
  8e3865:	ff ce                	dec    esi
  8e3867:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x5b0],zmm1
  8e386e:	b0 05 00 00 
  8e3872:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x570],zmm1
  8e3879:	70 05 00 00 
  8e387d:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x530],zmm1
  8e3884:	30 05 00 00 
  8e3888:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x4f0],zmm1
  8e388f:	f0 04 00 00 
  8e3893:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x4b0],zmm1
  8e389a:	b0 04 00 00 
  8e389e:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x470],zmm1
  8e38a5:	70 04 00 00 
  8e38a9:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x430],zmm1
  8e38b0:	30 04 00 00 
  8e38b4:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x3f0],zmm1
  8e38bb:	f0 03 00 00 
  8e38bf:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x3b0],zmm1
  8e38c6:	b0 03 00 00 
  8e38ca:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x370],zmm1
  8e38d1:	70 03 00 00 
  8e38d5:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x330],zmm1
  8e38dc:	30 03 00 00 
  8e38e0:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x2f0],zmm1
  8e38e7:	f0 02 00 00 
  8e38eb:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x2b0],zmm1
  8e38f2:	b0 02 00 00 
  8e38f6:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x270],zmm1
  8e38fd:	70 02 00 00 
  8e3901:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x230],zmm1
  8e3908:	30 02 00 00 
  8e390c:	62 f1 fe 48 7f 8c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x1f0],zmm1
  8e3913:	f0 01 00 00 
  8e3917:	83 fe 07             	cmp    esi,0x7
  8e391a:	73 07                	jae    8e3923 <check_data_emit+0x1dc3>
  8e391c:	31 f6                	xor    esi,esi
  8e391e:	e9 b7 00 00 00       	jmp    8e39da <check_data_emit+0x1e7a>
  8e3923:	41 83 e0 f8          	and    r8d,0xfffffff8
  8e3927:	49 89 d1             	mov    r9,rdx
  8e392a:	31 f6                	xor    esi,esi
  8e392c:	c4 42 73 f7 11       	shrx   r10d,DWORD PTR [r9],ecx
  8e3931:	48 83 c6 08          	add    rsi,0x8
  8e3935:	45 0f b6 d2          	movzx  r10d,r10b
  8e3939:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e3940:	00 
  8e3941:	c4 42 73 f7 51 18    	shrx   r10d,DWORD PTR [r9+0x18],ecx
  8e3947:	45 0f b6 d2          	movzx  r10d,r10b
  8e394b:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e3952:	00 
  8e3953:	c4 42 73 f7 51 30    	shrx   r10d,DWORD PTR [r9+0x30],ecx
  8e3959:	45 0f b6 d2          	movzx  r10d,r10b
  8e395d:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e3964:	00 
  8e3965:	c4 42 73 f7 51 48    	shrx   r10d,DWORD PTR [r9+0x48],ecx
  8e396b:	45 0f b6 d2          	movzx  r10d,r10b
  8e396f:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e3976:	00 
  8e3977:	c4 42 73 f7 51 60    	shrx   r10d,DWORD PTR [r9+0x60],ecx
  8e397d:	45 0f b6 d2          	movzx  r10d,r10b
  8e3981:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e3988:	00 
  8e3989:	c4 42 73 f7 51 78    	shrx   r10d,DWORD PTR [r9+0x78],ecx
  8e398f:	45 0f b6 d2          	movzx  r10d,r10b
  8e3993:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e399a:	00 
  8e399b:	c4 42 73 f7 91 90 00 	shrx   r10d,DWORD PTR [r9+0x90],ecx
  8e39a2:	00 00 
  8e39a4:	45 0f b6 d2          	movzx  r10d,r10b
  8e39a8:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e39af:	00 
  8e39b0:	c4 42 73 f7 91 a8 00 	shrx   r10d,DWORD PTR [r9+0xa8],ecx
  8e39b7:	00 00 
  8e39b9:	49 81 c1 c0 00 00 00 	add    r9,0xc0
  8e39c0:	45 0f b6 d2          	movzx  r10d,r10b
  8e39c4:	42 ff 84 94 f0 01 00 	inc    DWORD PTR [rsp+r10*4+0x1f0]
  8e39cb:	00 
  8e39cc:	49 39 f0             	cmp    r8,rsi
  8e39cf:	0f 85 57 ff ff ff    	jne    8e392c <check_data_emit+0x1dcc>
  8e39d5:	48 85 ff             	test   rdi,rdi
  8e39d8:	74 2d                	je     8e3a07 <check_data_emit+0x1ea7>
  8e39da:	48 8d 34 76          	lea    rsi,[rsi+rsi*2]
  8e39de:	c1 e7 03             	shl    edi,0x3
  8e39e1:	45 31 c0             	xor    r8d,r8d
  8e39e4:	48 8d 3c 7f          	lea    rdi,[rdi+rdi*2]
  8e39e8:	48 8d 34 f2          	lea    rsi,[rdx+rsi*8]
  8e39ec:	c4 22 73 f7 0c 06    	shrx   r9d,DWORD PTR [rsi+r8*1],ecx
  8e39f2:	49 83 c0 18          	add    r8,0x18
  8e39f6:	45 0f b6 c9          	movzx  r9d,r9b
  8e39fa:	42 ff 84 8c f0 01 00 	inc    DWORD PTR [rsp+r9*4+0x1f0]
  8e3a01:	00 
  8e3a02:	4c 39 c7             	cmp    rdi,r8
  8e3a05:	75 e5                	jne    8e39ec <check_data_emit+0x1e8c>
  8e3a07:	31 ff                	xor    edi,edi
  8e3a09:	31 f6                	xor    esi,esi
  8e3a0b:	44 8b 84 b4 f0 01 00 	mov    r8d,DWORD PTR [rsp+rsi*4+0x1f0]
  8e3a12:	00 
  8e3a13:	89 bc b4 f0 01 00 00 	mov    DWORD PTR [rsp+rsi*4+0x1f0],edi
  8e3a1a:	41 01 f8             	add    r8d,edi
  8e3a1d:	8b bc b4 f4 01 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x1f4]
  8e3a24:	44 89 84 b4 f4 01 00 	mov    DWORD PTR [rsp+rsi*4+0x1f4],r8d
  8e3a2b:	00 
  8e3a2c:	44 8b 8c b4 f8 01 00 	mov    r9d,DWORD PTR [rsp+rsi*4+0x1f8]
  8e3a33:	00 
  8e3a34:	44 01 c7             	add    edi,r8d
  8e3a37:	89 bc b4 f8 01 00 00 	mov    DWORD PTR [rsp+rsi*4+0x1f8],edi
  8e3a3e:	41 01 f9             	add    r9d,edi
  8e3a41:	8b bc b4 fc 01 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x1fc]
  8e3a48:	44 89 8c b4 fc 01 00 	mov    DWORD PTR [rsp+rsi*4+0x1fc],r9d
  8e3a4f:	00 
  8e3a50:	44 8b 94 b4 00 02 00 	mov    r10d,DWORD PTR [rsp+rsi*4+0x200]
  8e3a57:	00 
  8e3a58:	44 01 cf             	add    edi,r9d
  8e3a5b:	89 bc b4 00 02 00 00 	mov    DWORD PTR [rsp+rsi*4+0x200],edi
  8e3a62:	41 01 fa             	add    r10d,edi
  8e3a65:	8b bc b4 04 02 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x204]
  8e3a6c:	44 89 94 b4 04 02 00 	mov    DWORD PTR [rsp+rsi*4+0x204],r10d
  8e3a73:	00 
  8e3a74:	44 8b 8c b4 08 02 00 	mov    r9d,DWORD PTR [rsp+rsi*4+0x208]
  8e3a7b:	00 
  8e3a7c:	44 01 d7             	add    edi,r10d
  8e3a7f:	89 bc b4 08 02 00 00 	mov    DWORD PTR [rsp+rsi*4+0x208],edi
  8e3a86:	41 01 f9             	add    r9d,edi
  8e3a89:	8b bc b4 0c 02 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x20c]
  8e3a90:	44 89 8c b4 0c 02 00 	mov    DWORD PTR [rsp+rsi*4+0x20c],r9d
  8e3a97:	00 
  8e3a98:	44 8b 94 b4 10 02 00 	mov    r10d,DWORD PTR [rsp+rsi*4+0x210]
  8e3a9f:	00 
  8e3aa0:	44 01 cf             	add    edi,r9d
  8e3aa3:	89 bc b4 10 02 00 00 	mov    DWORD PTR [rsp+rsi*4+0x210],edi
  8e3aaa:	41 01 fa             	add    r10d,edi
  8e3aad:	8b bc b4 14 02 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x214]
  8e3ab4:	44 89 94 b4 14 02 00 	mov    DWORD PTR [rsp+rsi*4+0x214],r10d
  8e3abb:	00 
  8e3abc:	44 8b 8c b4 18 02 00 	mov    r9d,DWORD PTR [rsp+rsi*4+0x218]
  8e3ac3:	00 
  8e3ac4:	44 01 d7             	add    edi,r10d
  8e3ac7:	89 bc b4 18 02 00 00 	mov    DWORD PTR [rsp+rsi*4+0x218],edi
  8e3ace:	41 01 f9             	add    r9d,edi
  8e3ad1:	8b bc b4 1c 02 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x21c]
  8e3ad8:	44 89 8c b4 1c 02 00 	mov    DWORD PTR [rsp+rsi*4+0x21c],r9d
  8e3adf:	00 
  8e3ae0:	44 8b 94 b4 20 02 00 	mov    r10d,DWORD PTR [rsp+rsi*4+0x220]
  8e3ae7:	00 
  8e3ae8:	44 01 cf             	add    edi,r9d
  8e3aeb:	89 bc b4 20 02 00 00 	mov    DWORD PTR [rsp+rsi*4+0x220],edi
  8e3af2:	41 01 fa             	add    r10d,edi
  8e3af5:	8b bc b4 24 02 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x224]
  8e3afc:	44 89 94 b4 24 02 00 	mov    DWORD PTR [rsp+rsi*4+0x224],r10d
  8e3b03:	00 
  8e3b04:	44 8b 8c b4 28 02 00 	mov    r9d,DWORD PTR [rsp+rsi*4+0x228]
  8e3b0b:	00 
  8e3b0c:	44 01 d7             	add    edi,r10d
  8e3b0f:	89 bc b4 28 02 00 00 	mov    DWORD PTR [rsp+rsi*4+0x228],edi
  8e3b16:	41 01 f9             	add    r9d,edi
  8e3b19:	8b bc b4 2c 02 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x22c]
  8e3b20:	44 89 8c b4 2c 02 00 	mov    DWORD PTR [rsp+rsi*4+0x22c],r9d
  8e3b27:	00 
  8e3b28:	48 83 c6 10          	add    rsi,0x10
  8e3b2c:	44 01 cf             	add    edi,r9d
  8e3b2f:	48 81 fe 00 01 00 00 	cmp    rsi,0x100
  8e3b36:	0f 85 cf fe ff ff    	jne    8e3a0b <check_data_emit+0x1eab>
  8e3b3c:	48 89 d7             	mov    rdi,rdx
  8e3b3f:	45 31 c0             	xor    r8d,r8d
  8e3b42:	c4 e2 73 f7 37       	shrx   esi,DWORD PTR [rdi],ecx
  8e3b47:	4c 8b 5f 10          	mov    r11,QWORD PTR [rdi+0x10]
  8e3b4b:	49 ff c0             	inc    r8
  8e3b4e:	40 0f b6 f6          	movzx  esi,sil
  8e3b52:	44 8b 8c b4 f0 01 00 	mov    r9d,DWORD PTR [rsp+rsi*4+0x1f0]
  8e3b59:	00 
  8e3b5a:	4f 8d 14 49          	lea    r10,[r9+r9*2]
  8e3b5e:	41 ff c1             	inc    r9d
  8e3b61:	4e 89 5c d0 10       	mov    QWORD PTR [rax+r10*8+0x10],r11
  8e3b66:	c5 fa 6f 07          	vmovdqu xmm0,XMMWORD PTR [rdi]
  8e3b6a:	48 83 c7 18          	add    rdi,0x18
  8e3b6e:	c4 a1 7a 7f 04 d0    	vmovdqu XMMWORD PTR [rax+r10*8],xmm0
  8e3b74:	44 89 8c b4 f0 01 00 	mov    DWORD PTR [rsp+rsi*4+0x1f0],r9d
  8e3b7b:	00 
  8e3b7c:	41 8b 76 18          	mov    esi,DWORD PTR [r14+0x18]
  8e3b80:	49 39 f0             	cmp    r8,rsi
  8e3b83:	72 bd                	jb     8e3b42 <check_data_emit+0x1fe2>
  8e3b85:	83 fe 02             	cmp    esi,0x2
  8e3b88:	72 12                	jb     8e3b9c <check_data_emit+0x203c>
  8e3b8a:	48 89 c7             	mov    rdi,rax
  8e3b8d:	48 89 d0             	mov    rax,rdx
  8e3b90:	83 f9 18             	cmp    ecx,0x18
  8e3b93:	8d 49 08             	lea    ecx,[rcx+0x8]
  8e3b96:	0f 82 bd fc ff ff    	jb     8e3859 <check_data_emit+0x1cf9>
  8e3b9c:	41 8b 76 18          	mov    esi,DWORD PTR [r14+0x18]
  8e3ba0:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e3ba5:	48 8d 48 18          	lea    rcx,[rax+0x18]
  8e3ba9:	48 83 c0 10          	add    rax,0x10
  8e3bad:	85 f6                	test   esi,esi
  8e3baf:	74 6d                	je     8e3c1e <check_data_emit+0x20be>
  8e3bb1:	4c 8b 84 24 b0 00 00 	mov    r8,QWORD PTR [rsp+0xb0]
  8e3bb8:	00 
  8e3bb9:	4c 8b 9c 24 30 06 00 	mov    r11,QWORD PTR [rsp+0x630]
  8e3bc0:	00 
  8e3bc1:	be 08 00 00 00       	mov    esi,0x8
  8e3bc6:	31 ff                	xor    edi,edi
  8e3bc8:	48 8b 10             	mov    rdx,QWORD PTR [rax]
  8e3bcb:	41 ba 05 00 00 00    	mov    r10d,0x5
  8e3bd1:	44 8b 4c 32 fc       	mov    r9d,DWORD PTR [rdx+rsi*1-0x4]
  8e3bd6:	47 8b 0c 88          	mov    r9d,DWORD PTR [r8+r9*4]
  8e3bda:	4d 85 c9             	test   r9,r9
  8e3bdd:	0f 84 56 15 00 00    	je     8e5139 <check_data_emit+0x35d9>
  8e3be3:	45 3b 8b b8 00 00 00 	cmp    r9d,DWORD PTR [r11+0xb8]
  8e3bea:	0f 83 49 15 00 00    	jae    8e5139 <check_data_emit+0x35d9>
  8e3bf0:	4d 8b 93 88 00 00 00 	mov    r10,QWORD PTR [r11+0x88]
  8e3bf7:	47 0f b6 14 0a       	movzx  r10d,BYTE PTR [r10+r9*1]
  8e3bfc:	41 80 e2 0f          	and    r10b,0xf
  8e3c00:	41 80 fa 06          	cmp    r10b,0x6
  8e3c04:	0f 84 cf 14 00 00    	je     8e50d9 <check_data_emit+0x3579>
  8e3c0a:	44 89 0c 32          	mov    DWORD PTR [rdx+rsi*1],r9d
  8e3c0e:	48 ff c7             	inc    rdi
  8e3c11:	48 83 c6 18          	add    rsi,0x18
  8e3c15:	8b 11                	mov    edx,DWORD PTR [rcx]
  8e3c17:	48 39 d7             	cmp    rdi,rdx
  8e3c1a:	72 ac                	jb     8e3bc8 <check_data_emit+0x2068>
  8e3c1c:	eb 02                	jmp    8e3c20 <check_data_emit+0x20c0>
  8e3c1e:	31 d2                	xor    edx,edx
  8e3c20:	48 83 7c 24 40 00    	cmp    QWORD PTR [rsp+0x40],0x0
  8e3c26:	0f 85 5a 02 00 00    	jne    8e3e86 <check_data_emit+0x2326>
  8e3c2c:	48 8b 74 24 20       	mov    rsi,QWORD PTR [rsp+0x20]
  8e3c31:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
  8e3c34:	48 85 f6             	test   rsi,rsi
  8e3c37:	0f 84 49 02 00 00    	je     8e3e86 <check_data_emit+0x2326>
  8e3c3d:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
  8e3c42:	4c 8b 47 08          	mov    r8,QWORD PTR [rdi+0x8]
  8e3c46:	40 b7 3d             	mov    dil,0x3d
  8e3c49:	c4 c2 c0 f5 f8       	bzhi   rdi,r8,rdi
  8e3c4e:	4c 89 44 24 18       	mov    QWORD PTR [rsp+0x18],r8
  8e3c53:	48 83 ff 40          	cmp    rdi,0x40
  8e3c57:	73 0a                	jae    8e3c63 <check_data_emit+0x2103>
  8e3c59:	45 31 c0             	xor    r8d,r8d
  8e3c5c:	31 ed                	xor    ebp,ebp
  8e3c5e:	e9 c5 00 00 00       	jmp    8e3d28 <check_data_emit+0x21c8>
  8e3c63:	4c 8d 4f c0          	lea    r9,[rdi-0x40]
  8e3c67:	4d 89 ca             	mov    r10,r9
  8e3c6a:	49 c1 ea 06          	shr    r10,0x6
  8e3c6e:	49 ff c2             	inc    r10
  8e3c71:	45 89 d0             	mov    r8d,r10d
  8e3c74:	41 83 e0 07          	and    r8d,0x7
  8e3c78:	49 81 f9 c0 01 00 00 	cmp    r9,0x1c0
  8e3c7f:	73 09                	jae    8e3c8a <check_data_emit+0x212a>
  8e3c81:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e3c85:	45 31 c9             	xor    r9d,r9d
  8e3c88:	eb 60                	jmp    8e3cea <check_data_emit+0x218a>
  8e3c8a:	49 83 e2 f8          	and    r10,0xfffffffffffffff8
  8e3c8e:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e3c92:	45 31 c9             	xor    r9d,r9d
  8e3c95:	62 b1 fe 48 6f 0c 0e 	vmovdqu64 zmm1,ZMMWORD PTR [rsi+r9*1]
  8e3c9c:	62 b1 fe 48 6f 54 0e 	vmovdqu64 zmm2,ZMMWORD PTR [rsi+r9*1+0x80]
  8e3ca3:	02 
  8e3ca4:	62 b1 fe 48 6f 5c 0e 	vmovdqu64 zmm3,ZMMWORD PTR [rsi+r9*1+0x100]
  8e3cab:	04 
  8e3cac:	62 b1 fe 48 6f 64 0e 	vmovdqu64 zmm4,ZMMWORD PTR [rsi+r9*1+0x180]
  8e3cb3:	06 
  8e3cb4:	62 b3 f5 48 25 44 0e 	vpternlogq zmm0,zmm1,ZMMWORD PTR [rsi+r9*1+0x40],0xfe
  8e3cbb:	01 fe 
  8e3cbd:	62 b3 ed 48 25 44 0e 	vpternlogq zmm0,zmm2,ZMMWORD PTR [rsi+r9*1+0xc0],0xfe
  8e3cc4:	03 fe 
  8e3cc6:	62 b3 e5 48 25 44 0e 	vpternlogq zmm0,zmm3,ZMMWORD PTR [rsi+r9*1+0x140],0xfe
  8e3ccd:	05 fe 
  8e3ccf:	62 b3 dd 48 25 44 0e 	vpternlogq zmm0,zmm4,ZMMWORD PTR [rsi+r9*1+0x1c0],0xfe
  8e3cd6:	07 fe 
  8e3cd8:	49 81 c1 00 02 00 00 	add    r9,0x200
  8e3cdf:	49 83 c2 f8          	add    r10,0xfffffffffffffff8
  8e3ce3:	75 b0                	jne    8e3c95 <check_data_emit+0x2135>
  8e3ce5:	4d 85 c0             	test   r8,r8
  8e3ce8:	74 1a                	je     8e3d04 <check_data_emit+0x21a4>
  8e3cea:	49 01 f1             	add    r9,rsi
  8e3ced:	41 c1 e0 06          	shl    r8d,0x6
  8e3cf1:	45 31 d2             	xor    r10d,r10d
  8e3cf4:	62 91 fd 48 eb 04 11 	vporq  zmm0,zmm0,ZMMWORD PTR [r9+r10*1]
  8e3cfb:	49 83 c2 40          	add    r10,0x40
  8e3cff:	4d 39 d0             	cmp    r8,r10
  8e3d02:	75 f0                	jne    8e3cf4 <check_data_emit+0x2194>
  8e3d04:	49 b8 00 ff ff ff ff 	movabs r8,0x1fffffffffffff00
  8e3d0b:	ff ff 1f 
  8e3d0e:	62 f2 7d 48 27 c0    	vptestmd k0,zmm0,zmm0
  8e3d14:	49 8d a8 c0 00 00 00 	lea    rbp,[r8+0xc0]
  8e3d1b:	48 23 6c 24 18       	and    rbp,QWORD PTR [rsp+0x18]
  8e3d20:	c5 f8 98 c0          	kortestw k0,k0
  8e3d24:	41 0f 95 c0          	setne  r8b
  8e3d28:	49 89 fe             	mov    r14,rdi
  8e3d2b:	49 29 ee             	sub    r14,rbp
  8e3d2e:	0f 86 47 01 00 00    	jbe    8e3e7b <check_data_emit+0x231b>
  8e3d34:	49 83 fe 10          	cmp    r14,0x10
  8e3d38:	73 08                	jae    8e3d42 <check_data_emit+0x21e2>
  8e3d3a:	49 89 e9             	mov    r9,rbp
  8e3d3d:	e9 2d 01 00 00       	jmp    8e3e6f <check_data_emit+0x230f>
  8e3d42:	49 81 fe 00 01 00 00 	cmp    r14,0x100
  8e3d49:	73 08                	jae    8e3d53 <check_data_emit+0x21f3>
  8e3d4b:	45 31 db             	xor    r11d,r11d
  8e3d4e:	e9 b8 00 00 00       	jmp    8e3e0b <check_data_emit+0x22ab>
  8e3d53:	45 0f b6 c0          	movzx  r8d,r8b
  8e3d57:	49 b9 00 ff ff ff ff 	movabs r9,0x1fffffffffffff00
  8e3d5e:	ff ff 1f 
  8e3d61:	4d 89 f3             	mov    r11,r14
  8e3d64:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e3d68:	45 31 d2             	xor    r10d,r10d
  8e3d6b:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  8e3d6f:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  8e3d73:	4d 21 cb             	and    r11,r9
  8e3d76:	c4 c1 79 6e c8       	vmovd  xmm1,r8d
  8e3d7b:	4c 8d 84 2e c0 00 00 	lea    r8,[rsi+rbp*1+0xc0]
  8e3d82:	00 
  8e3d83:	4e 8d 4c 1d 00       	lea    r9,[rbp+r11*1+0x0]
  8e3d88:	62 91 f5 48 eb 4c 10 	vporq  zmm1,zmm1,ZMMWORD PTR [r8+r10*1-0xc0]
  8e3d8f:	fd 
  8e3d90:	62 91 e5 48 eb 5c 10 	vporq  zmm3,zmm3,ZMMWORD PTR [r8+r10*1-0x80]
  8e3d97:	fe 
  8e3d98:	62 91 ed 48 eb 54 10 	vporq  zmm2,zmm2,ZMMWORD PTR [r8+r10*1-0x40]
  8e3d9f:	ff 
  8e3da0:	62 91 fd 48 eb 04 10 	vporq  zmm0,zmm0,ZMMWORD PTR [r8+r10*1]
  8e3da7:	49 81 c2 00 01 00 00 	add    r10,0x100
  8e3dae:	4d 39 d3             	cmp    r11,r10
  8e3db1:	75 d5                	jne    8e3d88 <check_data_emit+0x2228>
  8e3db3:	62 f1 e5 48 eb c9    	vporq  zmm1,zmm3,zmm1
  8e3db9:	62 f3 ed 48 25 c1 fe 	vpternlogq zmm0,zmm2,zmm1,0xfe
  8e3dc0:	62 f3 fd 48 3b c1 01 	vextracti64x4 ymm1,zmm0,0x1
  8e3dc7:	62 f1 fd 48 eb c1    	vporq  zmm0,zmm0,zmm1
  8e3dcd:	c4 e3 7d 39 c1 01    	vextracti128 xmm1,ymm0,0x1
  8e3dd3:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3dd7:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e3ddc:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3de0:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e3de5:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3de9:	c5 f1 72 d0 10       	vpsrld xmm1,xmm0,0x10
  8e3dee:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3df2:	c5 f1 71 d0 08       	vpsrlw xmm1,xmm0,0x8
  8e3df7:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3dfb:	c4 c1 79 7e c0       	vmovd  r8d,xmm0
  8e3e00:	4d 39 de             	cmp    r14,r11
  8e3e03:	74 76                	je     8e3e7b <check_data_emit+0x231b>
  8e3e05:	41 f6 c6 f0          	test   r14b,0xf0
  8e3e09:	74 64                	je     8e3e6f <check_data_emit+0x230f>
  8e3e0b:	4c 8b 54 24 18       	mov    r10,QWORD PTR [rsp+0x18]
  8e3e10:	45 0f b6 c0          	movzx  r8d,r8b
  8e3e14:	49 01 eb             	add    r11,rbp
  8e3e17:	c4 c1 79 6e c0       	vmovd  xmm0,r8d
  8e3e1c:	49 89 f8             	mov    r8,rdi
  8e3e1f:	41 83 e2 0f          	and    r10d,0xf
  8e3e23:	4d 29 d6             	sub    r14,r10
  8e3e26:	4d 29 d0             	sub    r8,r10
  8e3e29:	4d 89 f1             	mov    r9,r14
  8e3e2c:	49 01 e9             	add    r9,rbp
  8e3e2f:	4d 89 d6             	mov    r14,r10
  8e3e32:	c4 a1 79 eb 04 1e    	vpor   xmm0,xmm0,XMMWORD PTR [rsi+r11*1]
  8e3e38:	49 83 c3 10          	add    r11,0x10
  8e3e3c:	4d 39 d8             	cmp    r8,r11
  8e3e3f:	75 f1                	jne    8e3e32 <check_data_emit+0x22d2>
  8e3e41:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e3e46:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3e4a:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e3e4f:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3e53:	c5 f1 72 d0 10       	vpsrld xmm1,xmm0,0x10
  8e3e58:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3e5c:	c5 f1 71 d0 08       	vpsrlw xmm1,xmm0,0x8
  8e3e61:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e3e65:	c4 c1 79 7e c0       	vmovd  r8d,xmm0
  8e3e6a:	4d 85 f6             	test   r14,r14
  8e3e6d:	74 0c                	je     8e3e7b <check_data_emit+0x231b>
  8e3e6f:	46 0a 04 0e          	or     r8b,BYTE PTR [rsi+r9*1]
  8e3e73:	49 ff c1             	inc    r9
  8e3e76:	4c 39 cf             	cmp    rdi,r9
  8e3e79:	75 f4                	jne    8e3e6f <check_data_emit+0x230f>
  8e3e7b:	45 84 c0             	test   r8b,r8b
  8e3e7e:	40 0f 95 c6          	setne  sil
  8e3e82:	89 74 24 10          	mov    DWORD PTR [rsp+0x10],esi
  8e3e86:	48 8b bc 24 30 06 00 	mov    rdi,QWORD PTR [rsp+0x630]
  8e3e8d:	00 
  8e3e8e:	4c 8b 44 24 20       	mov    r8,QWORD PTR [rsp+0x20]
  8e3e93:	85 d2                	test   edx,edx
  8e3e95:	40 0f 95 c6          	setne  sil
  8e3e99:	40 0a 74 24 10       	or     sil,BYTE PTR [rsp+0x10]
  8e3e9e:	48 8b bf 88 00 00 00 	mov    rdi,QWORD PTR [rdi+0x88]
  8e3ea5:	45 8b 40 1c          	mov    r8d,DWORD PTR [r8+0x1c]
  8e3ea9:	42 0f b6 3c 07       	movzx  edi,BYTE PTR [rdi+r8*1]
  8e3eae:	40 80 e7 0f          	and    dil,0xf
  8e3eb2:	40 80 ff 06          	cmp    dil,0x6
  8e3eb6:	75 07                	jne    8e3ebf <check_data_emit+0x235f>
  8e3eb8:	b2 08                	mov    dl,0x8
  8e3eba:	40 28 f2             	sub    dl,sil
  8e3ebd:	eb 20                	jmp    8e3edf <check_data_emit+0x237f>
  8e3ebf:	f6 84 24 90 00 00 00 	test   BYTE PTR [rsp+0x90],0x1
  8e3ec6:	01 
  8e3ec7:	75 07                	jne    8e3ed0 <check_data_emit+0x2370>
  8e3ec9:	89 f2                	mov    edx,esi
  8e3ecb:	80 f2 0d             	xor    dl,0xd
  8e3ece:	eb 0f                	jmp    8e3edf <check_data_emit+0x237f>
  8e3ed0:	85 d2                	test   edx,edx
  8e3ed2:	ba 0b 00 00 00       	mov    edx,0xb
  8e3ed7:	bf 01 00 00 00       	mov    edi,0x1
  8e3edc:	0f 44 d7             	cmove  edx,edi
  8e3edf:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
  8e3ee4:	88 57 21             	mov    BYTE PTR [rdi+0x21],dl
  8e3ee7:	48 8b 7c 24 58       	mov    rdi,QWORD PTR [rsp+0x58]
  8e3eec:	80 7f 28 01          	cmp    BYTE PTR [rdi+0x28],0x1
  8e3ef0:	75 45                	jne    8e3f37 <check_data_emit+0x23d7>
  8e3ef2:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
  8e3ef7:	4c 8b 02             	mov    r8,QWORD PTR [rdx]
  8e3efa:	48 8b 7a 20          	mov    rdi,QWORD PTR [rdx+0x20]
  8e3efe:	48 8b 94 24 90 00 00 	mov    rdx,QWORD PTR [rsp+0x90]
  8e3f05:	00 
  8e3f06:	c1 ea 03             	shr    edx,0x3
  8e3f09:	8b 14 97             	mov    edx,DWORD PTR [rdi+rdx*4]
  8e3f0c:	c1 ea 03             	shr    edx,0x3
  8e3f0f:	41 80 3c 10 0f       	cmp    BYTE PTR [r8+rdx*1],0xf
  8e3f14:	75 06                	jne    8e3f1c <check_data_emit+0x23bc>
  8e3f16:	8b 14 97             	mov    edx,DWORD PTR [rdi+rdx*4]
  8e3f19:	c1 ea 03             	shr    edx,0x3
  8e3f1c:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e3f21:	48 8b 7f 38          	mov    rdi,QWORD PTR [rdi+0x38]
  8e3f25:	48 83 3c d7 01       	cmp    QWORD PTR [rdi+rdx*8],0x1
  8e3f2a:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
  8e3f2f:	0f 94 c2             	sete   dl
  8e3f32:	fe c2                	inc    dl
  8e3f34:	88 57 21             	mov    BYTE PTR [rdi+0x21],dl
  8e3f37:	48 83 7c 24 40 00    	cmp    QWORD PTR [rsp+0x40],0x0
  8e3f3d:	0f 94 c2             	sete   dl
  8e3f40:	40 08 f2             	or     dl,sil
  8e3f43:	f6 c2 01             	test   dl,0x1
  8e3f46:	75 25                	jne    8e3f6d <check_data_emit+0x240d>
  8e3f48:	48 c7 00 00 00 00 00 	mov    QWORD PTR [rax],0x0
  8e3f4f:	48 8b 94 24 e8 00 00 	mov    rdx,QWORD PTR [rsp+0xe8]
  8e3f56:	00 
  8e3f57:	48 3b 53 08          	cmp    rdx,QWORD PTR [rbx+0x8]
  8e3f5b:	0f 87 80 11 00 00    	ja     8e50e1 <check_data_emit+0x3581>
  8e3f61:	48 8b 94 24 e8 00 00 	mov    rdx,QWORD PTR [rsp+0xe8]
  8e3f68:	00 
  8e3f69:	48 89 53 08          	mov    QWORD PTR [rbx+0x8],rdx
  8e3f6d:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
  8e3f72:	41 c7 45 00 00 00 00 	mov    DWORD PTR [r13+0x0],0x0
  8e3f79:	00 
  8e3f7a:	48 8b 7c 24 68       	mov    rdi,QWORD PTR [rsp+0x68]
  8e3f7f:	8b 72 1c             	mov    esi,DWORD PTR [rdx+0x1c]
  8e3f82:	89 f2                	mov    edx,esi
  8e3f84:	c1 ea 06             	shr    edx,0x6
  8e3f87:	48 8b 3c d7          	mov    rdi,QWORD PTR [rdi+rdx*8]
  8e3f8b:	48 0f a3 f7          	bt     rdi,rsi
  8e3f8f:	0f 82 82 11 00 00    	jb     8e5117 <check_data_emit+0x35b7>
  8e3f95:	41 b8 01 00 00 00    	mov    r8d,0x1
  8e3f9b:	c4 c2 c9 f7 f0       	shlx   rsi,r8,rsi
  8e3fa0:	4c 8b 44 24 68       	mov    r8,QWORD PTR [rsp+0x68]
  8e3fa5:	48 09 fe             	or     rsi,rdi
  8e3fa8:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
  8e3fad:	49 89 34 d0          	mov    QWORD PTR [r8+rdx*8],rsi
  8e3fb1:	0f b6 77 21          	movzx  esi,BYTE PTR [rdi+0x21]
  8e3fb5:	83 fe 08             	cmp    esi,0x8
  8e3fb8:	74 25                	je     8e3fdf <check_data_emit+0x247f>
  8e3fba:	ba 00 00 00 00       	mov    edx,0x0
  8e3fbf:	83 fe 0d             	cmp    esi,0xd
  8e3fc2:	74 1d                	je     8e3fe1 <check_data_emit+0x2481>
  8e3fc4:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
  8e3fc9:	48 8b b4 24 98 00 00 	mov    rsi,QWORD PTR [rsp+0x98]
  8e3fd0:	00 
  8e3fd1:	48 8b 52 08          	mov    rdx,QWORD PTR [rdx+0x8]
  8e3fd5:	48 01 d6             	add    rsi,rdx
  8e3fd8:	73 07                	jae    8e3fe1 <check_data_emit+0x2481>
  8e3fda:	e9 aa 10 00 00       	jmp    8e5089 <check_data_emit+0x3529>
  8e3fdf:	31 d2                	xor    edx,edx
  8e3fe1:	8b 09                	mov    ecx,DWORD PTR [rcx]
  8e3fe3:	8b 74 24 7c          	mov    esi,DWORD PTR [rsp+0x7c]
  8e3fe7:	01 ce                	add    esi,ecx
  8e3fe9:	0f 82 9a 10 00 00    	jb     8e5089 <check_data_emit+0x3529>
  8e3fef:	48 85 c9             	test   rcx,rcx
  8e3ff2:	74 0f                	je     8e4003 <check_data_emit+0x24a3>
  8e3ff4:	48 8b 00             	mov    rax,QWORD PTR [rax]
  8e3ff7:	83 f9 09             	cmp    ecx,0x9
  8e3ffa:	73 11                	jae    8e400d <check_data_emit+0x24ad>
  8e3ffc:	31 f6                	xor    esi,esi
  8e3ffe:	e9 1d 02 00 00       	jmp    8e4220 <check_data_emit+0x26c0>
  8e4003:	4c 8b 4c 24 70       	mov    r9,QWORD PTR [rsp+0x70]
  8e4008:	e9 4e 02 00 00       	jmp    8e425b <check_data_emit+0x26fb>
  8e400d:	83 f9 21             	cmp    ecx,0x21
  8e4010:	73 07                	jae    8e4019 <check_data_emit+0x24b9>
  8e4012:	31 f6                	xor    esi,esi
  8e4014:	e9 56 01 00 00       	jmp    8e416f <check_data_emit+0x260f>
  8e4019:	c5 f9 6e 44 24 70    	vmovd  xmm0,DWORD PTR [rsp+0x70]
  8e401f:	62 71 fd 48 6f 05 97 	vmovdqa64 zmm8,ZMMWORD PTR [rip+0xffffffffffbc4e97]        # 4a8ec0 <cbuiltin_test_generated.edges+0xc830>
  8e4026:	4e bc ff 
  8e4029:	62 71 fd 48 6f 0d cd 	vmovdqa64 zmm9,ZMMWORD PTR [rip+0xffffffffffbc4ecd]        # 4a8f00 <cbuiltin_test_generated.edges+0xc870>
  8e4030:	4e bc ff 
  8e4033:	62 72 fd 48 59 15 33 	vpbroadcastq zmm10,QWORD PTR [rip+0xffffffffffcd8133]        # 5bc170 <link_program_emit_worker.forms+0xd38>
  8e403a:	81 cd ff 
  8e403d:	62 72 fd 48 59 1d 31 	vpbroadcastq zmm11,QWORD PTR [rip+0xffffffffffcd8131]        # 5bc178 <link_program_emit_worker.forms+0xd40>
  8e4044:	81 cd ff 
  8e4047:	89 cf                	mov    edi,ecx
  8e4049:	83 e7 1f             	and    edi,0x1f
  8e404c:	be 20 00 00 00       	mov    esi,0x20
  8e4051:	4c 8d 80 50 02 00 00 	lea    r8,[rax+0x250]
  8e4058:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  8e405c:	49 89 c9             	mov    r9,rcx
  8e405f:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  8e4063:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  8e4067:	48 0f 44 fe          	cmove  rdi,rsi
  8e406b:	48 89 ce             	mov    rsi,rcx
  8e406e:	48 29 fe             	sub    rsi,rdi
  8e4071:	62 d1 fe 48 6f 60 f7 	vmovdqu64 zmm4,ZMMWORD PTR [r8-0x240]
  8e4078:	62 d1 fe 48 6f 68 fa 	vmovdqu64 zmm5,ZMMWORD PTR [r8-0x180]
  8e407f:	62 d1 fe 48 6f 70 fd 	vmovdqu64 zmm6,ZMMWORD PTR [r8-0xc0]
  8e4086:	62 d1 fe 48 6f 38    	vmovdqu64 zmm7,ZMMWORD PTR [r8]
  8e408c:	49 83 c1 e0          	add    r9,0xffffffffffffffe0
  8e4090:	62 d2 bd 48 7e 60 f8 	vpermt2q zmm4,zmm8,ZMMWORD PTR [r8-0x200]
  8e4097:	62 d2 bd 48 7e 68 fb 	vpermt2q zmm5,zmm8,ZMMWORD PTR [r8-0x140]
  8e409e:	62 d2 bd 48 7e 70 fe 	vpermt2q zmm6,zmm8,ZMMWORD PTR [r8-0x80]
  8e40a5:	62 d2 bd 48 7e 78 01 	vpermt2q zmm7,zmm8,ZMMWORD PTR [r8+0x40]
  8e40ac:	62 d2 b5 48 7e 60 f9 	vpermt2q zmm4,zmm9,ZMMWORD PTR [r8-0x1c0]
  8e40b3:	62 d2 b5 48 7e 68 fc 	vpermt2q zmm5,zmm9,ZMMWORD PTR [r8-0x100]
  8e40ba:	62 d2 b5 48 7e 70 ff 	vpermt2q zmm6,zmm9,ZMMWORD PTR [r8-0x40]
  8e40c1:	62 d2 b5 48 7e 78 02 	vpermt2q zmm7,zmm9,ZMMWORD PTR [r8+0x80]
  8e40c8:	49 81 c0 00 03 00 00 	add    r8,0x300
  8e40cf:	62 d1 dd 48 d4 e2    	vpaddq zmm4,zmm4,zmm10
  8e40d5:	62 d1 d5 48 d4 ea    	vpaddq zmm5,zmm5,zmm10
  8e40db:	62 d1 cd 48 d4 f2    	vpaddq zmm6,zmm6,zmm10
  8e40e1:	62 d1 c5 48 d4 fa    	vpaddq zmm7,zmm7,zmm10
  8e40e7:	62 d3 dd 48 1e c3 01 	vpcmpltuq k0,zmm4,zmm11
  8e40ee:	62 d3 d5 48 1e cb 01 	vpcmpltuq k1,zmm5,zmm11
  8e40f5:	62 d3 cd 48 1e d3 01 	vpcmpltuq k2,zmm6,zmm11
  8e40fc:	62 d3 c5 48 1e db 01 	vpcmpltuq k3,zmm7,zmm11
  8e4103:	62 f2 7e 28 38 e0    	vpmovm2d ymm4,k0
  8e4109:	c5 fd fa c4          	vpsubd ymm0,ymm0,ymm4
  8e410d:	62 f2 7e 28 38 e1    	vpmovm2d ymm4,k1
  8e4113:	c5 f5 fa cc          	vpsubd ymm1,ymm1,ymm4
  8e4117:	62 f2 7e 28 38 e2    	vpmovm2d ymm4,k2
  8e411d:	c5 ed fa d4          	vpsubd ymm2,ymm2,ymm4
  8e4121:	62 f2 7e 28 38 e3    	vpmovm2d ymm4,k3
  8e4127:	c5 e5 fa dc          	vpsubd ymm3,ymm3,ymm4
  8e412b:	4c 39 cf             	cmp    rdi,r9
  8e412e:	0f 85 3d ff ff ff    	jne    8e4071 <check_data_emit+0x2511>
  8e4134:	c5 f5 fe c0          	vpaddd ymm0,ymm1,ymm0
  8e4138:	c5 e5 fe ca          	vpaddd ymm1,ymm3,ymm2
  8e413c:	c5 f5 fe c0          	vpaddd ymm0,ymm1,ymm0
  8e4140:	c4 e3 7d 39 c1 01    	vextracti128 xmm1,ymm0,0x1
  8e4146:	c5 f9 fe c1          	vpaddd xmm0,xmm0,xmm1
  8e414a:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e414f:	c5 f9 fe c1          	vpaddd xmm0,xmm0,xmm1
  8e4153:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e4158:	c5 f9 fe c1          	vpaddd xmm0,xmm0,xmm1
  8e415c:	c4 c1 79 7e c0       	vmovd  r8d,xmm0
  8e4161:	4c 89 44 24 70       	mov    QWORD PTR [rsp+0x70],r8
  8e4166:	83 ff 09             	cmp    edi,0x9
  8e4169:	0f 82 b1 00 00 00    	jb     8e4220 <check_data_emit+0x26c0>
  8e416f:	c5 f9 6e 44 24 70    	vmovd  xmm0,DWORD PTR [rsp+0x70]
  8e4175:	62 f1 fd 48 6f 15 41 	vmovdqa64 zmm2,ZMMWORD PTR [rip+0xffffffffffbc4d41]        # 4a8ec0 <cbuiltin_test_generated.edges+0xc830>
  8e417c:	4d bc ff 
  8e417f:	62 f1 fd 48 6f 1d 77 	vmovdqa64 zmm3,ZMMWORD PTR [rip+0xffffffffffbc4d77]        # 4a8f00 <cbuiltin_test_generated.edges+0xc870>
  8e4186:	4d bc ff 
  8e4189:	62 f2 fd 48 59 25 dd 	vpbroadcastq zmm4,QWORD PTR [rip+0xffffffffffcd7fdd]        # 5bc170 <link_program_emit_worker.forms+0xd38>
  8e4190:	7f cd ff 
  8e4193:	62 f2 fd 48 59 2d db 	vpbroadcastq zmm5,QWORD PTR [rip+0xffffffffffcd7fdb]        # 5bc178 <link_program_emit_worker.forms+0xd40>
  8e419a:	7f cd ff 
  8e419d:	89 cf                	mov    edi,ecx
  8e419f:	49 89 f0             	mov    r8,rsi
  8e41a2:	83 e7 07             	and    edi,0x7
  8e41a5:	be 08 00 00 00       	mov    esi,0x8
  8e41aa:	48 0f 44 fe          	cmove  rdi,rsi
  8e41ae:	48 89 ce             	mov    rsi,rcx
  8e41b1:	48 29 fe             	sub    rsi,rdi
  8e41b4:	4c 01 c7             	add    rdi,r8
  8e41b7:	4f 8d 04 40          	lea    r8,[r8+r8*2]
  8e41bb:	48 29 cf             	sub    rdi,rcx
  8e41be:	4e 8d 44 c0 10       	lea    r8,[rax+r8*8+0x10]
  8e41c3:	62 d1 fe 48 6f 08    	vmovdqu64 zmm1,ZMMWORD PTR [r8]
  8e41c9:	62 d2 ed 48 7e 48 01 	vpermt2q zmm1,zmm2,ZMMWORD PTR [r8+0x40]
  8e41d0:	62 d2 e5 48 7e 48 02 	vpermt2q zmm1,zmm3,ZMMWORD PTR [r8+0x80]
  8e41d7:	49 81 c0 c0 00 00 00 	add    r8,0xc0
  8e41de:	48 83 c7 08          	add    rdi,0x8
  8e41e2:	62 f1 f5 48 d4 cc    	vpaddq zmm1,zmm1,zmm4
  8e41e8:	62 f3 f5 48 1e c5 01 	vpcmpltuq k0,zmm1,zmm5
  8e41ef:	62 f2 7e 28 38 c8    	vpmovm2d ymm1,k0
  8e41f5:	c5 fd fa c1          	vpsubd ymm0,ymm0,ymm1
  8e41f9:	75 c8                	jne    8e41c3 <check_data_emit+0x2663>
  8e41fb:	c4 e3 7d 39 c1 01    	vextracti128 xmm1,ymm0,0x1
  8e4201:	c5 f9 fe c1          	vpaddd xmm0,xmm0,xmm1
  8e4205:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e420a:	c5 f9 fe c1          	vpaddd xmm0,xmm0,xmm1
  8e420e:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e4213:	c5 f9 fe c1          	vpaddd xmm0,xmm0,xmm1
  8e4217:	c5 f9 7e c7          	vmovd  edi,xmm0
  8e421b:	48 89 7c 24 70       	mov    QWORD PTR [rsp+0x70],rdi
  8e4220:	4c 8b 4c 24 70       	mov    r9,QWORD PTR [rsp+0x70]
  8e4225:	48 8d 3c 76          	lea    rdi,[rsi+rsi*2]
  8e4229:	49 b8 00 00 00 00 ff 	movabs r8,0xffffffff00000000
  8e4230:	ff ff ff 
  8e4233:	49 c7 c2 00 00 00 80 	mov    r10,0xffffffff80000000
  8e423a:	48 8d 44 f8 10       	lea    rax,[rax+rdi*8+0x10]
  8e423f:	48 89 cf             	mov    rdi,rcx
  8e4242:	48 29 f7             	sub    rdi,rsi
  8e4245:	48 8b 30             	mov    rsi,QWORD PTR [rax]
  8e4248:	4c 01 d6             	add    rsi,r10
  8e424b:	4c 39 c6             	cmp    rsi,r8
  8e424e:	41 83 d1 00          	adc    r9d,0x0
  8e4252:	48 83 c0 18          	add    rax,0x18
  8e4256:	48 ff cf             	dec    rdi
  8e4259:	75 ea                	jne    8e4245 <check_data_emit+0x26e5>
  8e425b:	41 83 7d 00 00       	cmp    DWORD PTR [r13+0x0],0x0
  8e4260:	48 8b 84 24 f0 00 00 	mov    rax,QWORD PTR [rsp+0xf0]
  8e4267:	00 
  8e4268:	48 8b 74 24 58       	mov    rsi,QWORD PTR [rsp+0x58]
  8e426d:	4c 89 4c 24 70       	mov    QWORD PTR [rsp+0x70],r9
  8e4272:	0f 85 d2 0e 00 00    	jne    8e514a <check_data_emit+0x35ea>
  8e4278:	48 01 94 24 98 00 00 	add    QWORD PTR [rsp+0x98],rdx
  8e427f:	00 
  8e4280:	01 4c 24 7c          	add    DWORD PTR [rsp+0x7c],ecx
  8e4284:	8b 4c 24 64          	mov    ecx,DWORD PTR [rsp+0x64]
  8e4288:	48 8b 94 24 c8 00 00 	mov    rdx,QWORD PTR [rsp+0xc8]
  8e428f:	00 
  8e4290:	44 8b 8c 24 ac 00 00 	mov    r9d,DWORD PTR [rsp+0xac]
  8e4297:	00 
  8e4298:	4c 8b 84 24 b0 00 00 	mov    r8,QWORD PTR [rsp+0xb0]
  8e429f:	00 
  8e42a0:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e42a5:	4c 8b b4 24 30 06 00 	mov    r14,QWORD PTR [rsp+0x630]
  8e42ac:	00 
  8e42ad:	48 8b ac 24 d0 00 00 	mov    rbp,QWORD PTR [rsp+0xd0]
  8e42b4:	00 
  8e42b5:	48 ff c0             	inc    rax
  8e42b8:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e42bc:	48 3b 84 24 08 01 00 	cmp    rax,QWORD PTR [rsp+0x108]
  8e42c3:	00 
  8e42c4:	0f 82 12 db ff ff    	jb     8e1ddc <check_data_emit+0x27c>
  8e42ca:	e9 50 0e 00 00       	jmp    8e511f <check_data_emit+0x35bf>
  8e42cf:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
  8e42d6:	00 00 
  8e42d8:	e9 aa 01 00 00       	jmp    8e4487 <check_data_emit+0x2927>
  8e42dd:	48 8b 4c 24 18       	mov    rcx,QWORD PTR [rsp+0x18]
  8e42e2:	31 d2                	xor    edx,edx
  8e42e4:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
  8e42eb:	00 00 
  8e42ed:	83 e1 fc             	and    ecx,0xfffffffc
  8e42f0:	48 89 4c 24 18       	mov    QWORD PTR [rsp+0x18],rcx
  8e42f5:	eb 36                	jmp    8e432d <check_data_emit+0x27cd>
  8e42f7:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
  8e42fc:	48 8b 7c d1 18       	mov    rdi,QWORD PTR [rcx+rdx*8+0x18]
  8e4301:	4c 8b 4c 24 30       	mov    r9,QWORD PTR [rsp+0x30]
  8e4306:	4c 8b 44 24 10       	mov    r8,QWORD PTR [rsp+0x10]
  8e430b:	44 89 c9             	mov    ecx,r9d
  8e430e:	49 89 3c c8          	mov    QWORD PTR [r8+rcx*8],rdi
  8e4312:	44 89 0c 8e          	mov    DWORD PTR [rsi+rcx*4],r9d
  8e4316:	41 ff c1             	inc    r9d
  8e4319:	4c 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],r9
  8e431e:	48 83 c2 04          	add    rdx,0x4
  8e4322:	48 39 54 24 18       	cmp    QWORD PTR [rsp+0x18],rdx
  8e4327:	0f 84 fe 00 00 00    	je     8e442b <check_data_emit+0x28cb>
  8e432d:	83 7c 24 30 00       	cmp    DWORD PTR [rsp+0x30],0x0
  8e4332:	74 18                	je     8e434c <check_data_emit+0x27ec>
  8e4334:	4c 8b 44 24 10       	mov    r8,QWORD PTR [rsp+0x10]
  8e4339:	48 8b 4c 24 30       	mov    rcx,QWORD PTR [rsp+0x30]
  8e433e:	49 8b 3c d0          	mov    rdi,QWORD PTR [r8+rdx*8]
  8e4342:	ff c9                	dec    ecx
  8e4344:	49 39 3c c8          	cmp    QWORD PTR [r8+rcx*8],rdi
  8e4348:	75 0b                	jne    8e4355 <check_data_emit+0x27f5>
  8e434a:	eb 26                	jmp    8e4372 <check_data_emit+0x2812>
  8e434c:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
  8e4351:	48 8b 3c d1          	mov    rdi,QWORD PTR [rcx+rdx*8]
  8e4355:	4c 8b 4c 24 30       	mov    r9,QWORD PTR [rsp+0x30]
  8e435a:	4c 8b 44 24 10       	mov    r8,QWORD PTR [rsp+0x10]
  8e435f:	44 89 c9             	mov    ecx,r9d
  8e4362:	49 89 3c c8          	mov    QWORD PTR [r8+rcx*8],rdi
  8e4366:	44 89 0c 8e          	mov    DWORD PTR [rsi+rcx*4],r9d
  8e436a:	41 ff c1             	inc    r9d
  8e436d:	4c 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],r9
  8e4372:	83 7c 24 30 00       	cmp    DWORD PTR [rsp+0x30],0x0
  8e4377:	74 19                	je     8e4392 <check_data_emit+0x2832>
  8e4379:	4c 8b 44 24 10       	mov    r8,QWORD PTR [rsp+0x10]
  8e437e:	48 8b 4c 24 30       	mov    rcx,QWORD PTR [rsp+0x30]
  8e4383:	49 8b 7c d0 08       	mov    rdi,QWORD PTR [r8+rdx*8+0x8]
  8e4388:	ff c9                	dec    ecx
  8e438a:	49 39 3c c8          	cmp    QWORD PTR [r8+rcx*8],rdi
  8e438e:	75 0c                	jne    8e439c <check_data_emit+0x283c>
  8e4390:	eb 27                	jmp    8e43b9 <check_data_emit+0x2859>
  8e4392:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
  8e4397:	48 8b 7c d1 08       	mov    rdi,QWORD PTR [rcx+rdx*8+0x8]
  8e439c:	4c 8b 4c 24 30       	mov    r9,QWORD PTR [rsp+0x30]
  8e43a1:	4c 8b 44 24 10       	mov    r8,QWORD PTR [rsp+0x10]
  8e43a6:	44 89 c9             	mov    ecx,r9d
  8e43a9:	49 89 3c c8          	mov    QWORD PTR [r8+rcx*8],rdi
  8e43ad:	44 89 0c 8e          	mov    DWORD PTR [rsi+rcx*4],r9d
  8e43b1:	41 ff c1             	inc    r9d
  8e43b4:	4c 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],r9
  8e43b9:	83 7c 24 30 00       	cmp    DWORD PTR [rsp+0x30],0x0
  8e43be:	74 19                	je     8e43d9 <check_data_emit+0x2879>
  8e43c0:	4c 8b 44 24 10       	mov    r8,QWORD PTR [rsp+0x10]
  8e43c5:	48 8b 4c 24 30       	mov    rcx,QWORD PTR [rsp+0x30]
  8e43ca:	49 8b 7c d0 10       	mov    rdi,QWORD PTR [r8+rdx*8+0x10]
  8e43cf:	ff c9                	dec    ecx
  8e43d1:	49 39 3c c8          	cmp    QWORD PTR [r8+rcx*8],rdi
  8e43d5:	75 0c                	jne    8e43e3 <check_data_emit+0x2883>
  8e43d7:	eb 27                	jmp    8e4400 <check_data_emit+0x28a0>
  8e43d9:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
  8e43de:	48 8b 7c d1 10       	mov    rdi,QWORD PTR [rcx+rdx*8+0x10]
  8e43e3:	4c 8b 4c 24 30       	mov    r9,QWORD PTR [rsp+0x30]
  8e43e8:	4c 8b 44 24 10       	mov    r8,QWORD PTR [rsp+0x10]
  8e43ed:	44 89 c9             	mov    ecx,r9d
  8e43f0:	49 89 3c c8          	mov    QWORD PTR [r8+rcx*8],rdi
  8e43f4:	44 89 0c 8e          	mov    DWORD PTR [rsi+rcx*4],r9d
  8e43f8:	41 ff c1             	inc    r9d
  8e43fb:	4c 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],r9
  8e4400:	83 7c 24 30 00       	cmp    DWORD PTR [rsp+0x30],0x0
  8e4405:	0f 84 ec fe ff ff    	je     8e42f7 <check_data_emit+0x2797>
  8e440b:	4c 8b 44 24 10       	mov    r8,QWORD PTR [rsp+0x10]
  8e4410:	48 8b 4c 24 30       	mov    rcx,QWORD PTR [rsp+0x30]
  8e4415:	49 8b 7c d0 18       	mov    rdi,QWORD PTR [r8+rdx*8+0x18]
  8e441a:	ff c9                	dec    ecx
  8e441c:	49 39 3c c8          	cmp    QWORD PTR [r8+rcx*8],rdi
  8e4420:	0f 85 db fe ff ff    	jne    8e4301 <check_data_emit+0x27a1>
  8e4426:	e9 f3 fe ff ff       	jmp    8e431e <check_data_emit+0x27be>
  8e442b:	48 85 c0             	test   rax,rax
  8e442e:	74 57                	je     8e4487 <check_data_emit+0x2927>
  8e4430:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
  8e4435:	48 8d 0c d1          	lea    rcx,[rcx+rdx*8]
  8e4439:	31 d2                	xor    edx,edx
  8e443b:	eb 29                	jmp    8e4466 <check_data_emit+0x2906>
  8e443d:	48 8b 3c d1          	mov    rdi,QWORD PTR [rcx+rdx*8]
  8e4441:	4c 8b 54 24 30       	mov    r10,QWORD PTR [rsp+0x30]
  8e4446:	4c 8b 4c 24 10       	mov    r9,QWORD PTR [rsp+0x10]
  8e444b:	45 89 d0             	mov    r8d,r10d
  8e444e:	4b 89 3c c1          	mov    QWORD PTR [r9+r8*8],rdi
  8e4452:	46 89 14 86          	mov    DWORD PTR [rsi+r8*4],r10d
  8e4456:	41 ff c2             	inc    r10d
  8e4459:	4c 89 54 24 30       	mov    QWORD PTR [rsp+0x30],r10
  8e445e:	48 ff c2             	inc    rdx
  8e4461:	48 39 d0             	cmp    rax,rdx
  8e4464:	74 21                	je     8e4487 <check_data_emit+0x2927>
  8e4466:	83 7c 24 30 00       	cmp    DWORD PTR [rsp+0x30],0x0
  8e446b:	74 d0                	je     8e443d <check_data_emit+0x28dd>
  8e446d:	48 8b 7c 24 30       	mov    rdi,QWORD PTR [rsp+0x30]
  8e4472:	4c 8b 4c 24 10       	mov    r9,QWORD PTR [rsp+0x10]
  8e4477:	44 8d 47 ff          	lea    r8d,[rdi-0x1]
  8e447b:	48 8b 3c d1          	mov    rdi,QWORD PTR [rcx+rdx*8]
  8e447f:	4b 39 3c c1          	cmp    QWORD PTR [r9+r8*8],rdi
  8e4483:	75 bc                	jne    8e4441 <check_data_emit+0x28e1>
  8e4485:	eb d7                	jmp    8e445e <check_data_emit+0x28fe>
  8e4487:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  8e448c:	45 31 db             	xor    r11d,r11d
  8e448f:	8b 40 18             	mov    eax,DWORD PTR [rax+0x18]
  8e4492:	48 89 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rax
  8e4499:	00 
  8e449a:	48 85 c0             	test   rax,rax
  8e449d:	0f 84 71 04 00 00    	je     8e4914 <check_data_emit+0x2db4>
  8e44a3:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  8e44a8:	48 8b 8c 24 a0 00 00 	mov    rcx,QWORD PTR [rsp+0xa0]
  8e44af:	00 
  8e44b0:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  8e44b4:	48 ff c9             	dec    rcx
  8e44b7:	48 89 8c 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rcx
  8e44be:	00 
  8e44bf:	48 69 c9 b0 00 00 00 	imul   rcx,rcx,0xb0
  8e44c6:	48 89 c7             	mov    rdi,rax
  8e44c9:	8b 44 08 04          	mov    eax,DWORD PTR [rax+rcx*1+0x4]
  8e44cd:	c1 e8 03             	shr    eax,0x3
  8e44d0:	0f 84 32 0d 00 00    	je     8e5208 <check_data_emit+0x36a8>
  8e44d6:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
  8e44db:	3b 42 48             	cmp    eax,DWORD PTR [rdx+0x48]
  8e44de:	0f 83 24 0d 00 00    	jae    8e5208 <check_data_emit+0x36a8>
  8e44e4:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
  8e44e9:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
  8e44ec:	0f b6 14 02          	movzx  edx,BYTE PTR [rdx+rax*1]
  8e44f0:	84 d2                	test   dl,dl
  8e44f2:	0f 84 10 0d 00 00    	je     8e5208 <check_data_emit+0x36a8>
  8e44f8:	48 01 cf             	add    rdi,rcx
  8e44fb:	8b 0f                	mov    ecx,DWORD PTR [rdi]
  8e44fd:	48 89 7c 24 50       	mov    QWORD PTR [rsp+0x50],rdi
  8e4502:	83 f9 02             	cmp    ecx,0x2
  8e4505:	0f 87 fd 0c 00 00    	ja     8e5208 <check_data_emit+0x36a8>
  8e450b:	85 c9                	test   ecx,ecx
  8e450d:	74 0b                	je     8e451a <check_data_emit+0x29ba>
  8e450f:	48 8b 44 24 50       	mov    rax,QWORD PTR [rsp+0x50]
  8e4514:	48 8d 48 30          	lea    rcx,[rax+0x30]
  8e4518:	eb 21                	jmp    8e453b <check_data_emit+0x29db>
  8e451a:	80 fa 0f             	cmp    dl,0xf
  8e451d:	75 0f                	jne    8e452e <check_data_emit+0x29ce>
  8e451f:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  8e4524:	48 8b 49 20          	mov    rcx,QWORD PTR [rcx+0x20]
  8e4528:	8b 04 81             	mov    eax,DWORD PTR [rcx+rax*4]
  8e452b:	c1 e8 03             	shr    eax,0x3
  8e452e:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  8e4533:	48 8b 49 38          	mov    rcx,QWORD PTR [rcx+0x38]
  8e4537:	48 8d 0c c1          	lea    rcx,[rcx+rax*8]
  8e453b:	48 8b 44 24 50       	mov    rax,QWORD PTR [rsp+0x50]
  8e4540:	8b 40 20             	mov    eax,DWORD PTR [rax+0x20]
  8e4543:	48 85 c0             	test   rax,rax
  8e4546:	75 15                	jne    8e455d <check_data_emit+0x29fd>
  8e4548:	48 8b 01             	mov    rax,QWORD PTR [rcx]
  8e454b:	48 3b 84 24 e0 00 00 	cmp    rax,QWORD PTR [rsp+0xe0]
  8e4552:	00 
  8e4553:	0f 87 af 0c 00 00    	ja     8e5208 <check_data_emit+0x36a8>
  8e4559:	48 c1 e0 03          	shl    rax,0x3
  8e455d:	48 8b 4c 24 50       	mov    rcx,QWORD PTR [rsp+0x50]
  8e4562:	48 8b 51 18          	mov    rdx,QWORD PTR [rcx+0x18]
  8e4566:	48 01 d0             	add    rax,rdx
  8e4569:	0f 82 99 0c 00 00    	jb     8e5208 <check_data_emit+0x36a8>
  8e456f:	83 7c 24 30 00       	cmp    DWORD PTR [rsp+0x30],0x0
  8e4574:	74 65                	je     8e45db <check_data_emit+0x2a7b>
  8e4576:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  8e457b:	48 8b 7c 24 30       	mov    rdi,QWORD PTR [rsp+0x30]
  8e4580:	31 c9                	xor    ecx,ecx
  8e4582:	eb 07                	jmp    8e458b <check_data_emit+0x2a2b>
  8e4584:	44 89 cf             	mov    edi,r9d
  8e4587:	39 f9                	cmp    ecx,edi
  8e4589:	73 1c                	jae    8e45a7 <check_data_emit+0x2a47>
  8e458b:	41 89 f8             	mov    r8d,edi
  8e458e:	41 29 c8             	sub    r8d,ecx
  8e4591:	41 d1 e8             	shr    r8d,1
  8e4594:	45 8d 0c 08          	lea    r9d,[r8+rcx*1]
  8e4598:	4b 39 14 ca          	cmp    QWORD PTR [r10+r9*8],rdx
  8e459c:	73 e6                	jae    8e4584 <check_data_emit+0x2a24>
  8e459e:	41 8d 4c 08 01       	lea    ecx,[r8+rcx*1+0x1]
  8e45a3:	39 f9                	cmp    ecx,edi
  8e45a5:	72 e4                	jb     8e458b <check_data_emit+0x2a2b>
  8e45a7:	48 8b 54 24 30       	mov    rdx,QWORD PTR [rsp+0x30]
  8e45ac:	45 31 f6             	xor    r14d,r14d
  8e45af:	eb 08                	jmp    8e45b9 <check_data_emit+0x2a59>
  8e45b1:	44 89 c2             	mov    edx,r8d
  8e45b4:	41 39 d6             	cmp    r14d,edx
  8e45b7:	73 1b                	jae    8e45d4 <check_data_emit+0x2a74>
  8e45b9:	89 d7                	mov    edi,edx
  8e45bb:	44 29 f7             	sub    edi,r14d
  8e45be:	d1 ef                	shr    edi,1
  8e45c0:	46 8d 04 37          	lea    r8d,[rdi+r14*1]
  8e45c4:	4b 39 04 c2          	cmp    QWORD PTR [r10+r8*8],rax
  8e45c8:	73 e7                	jae    8e45b1 <check_data_emit+0x2a51>
  8e45ca:	46 8d 74 37 01       	lea    r14d,[rdi+r14*1+0x1]
  8e45cf:	41 39 d6             	cmp    r14d,edx
  8e45d2:	72 e5                	jb     8e45b9 <check_data_emit+0x2a59>
  8e45d4:	4c 89 74 24 38       	mov    QWORD PTR [rsp+0x38],r14
  8e45d9:	eb 0b                	jmp    8e45e6 <check_data_emit+0x2a86>
  8e45db:	31 c9                	xor    ecx,ecx
  8e45dd:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
  8e45e4:	00 00 
  8e45e6:	89 c8                	mov    eax,ecx
  8e45e8:	89 c7                	mov    edi,eax
  8e45ea:	89 c0                	mov    eax,eax
  8e45ec:	8b 04 86             	mov    eax,DWORD PTR [rsi+rax*4]
  8e45ef:	39 f8                	cmp    eax,edi
  8e45f1:	75 f5                	jne    8e45e8 <check_data_emit+0x2a88>
  8e45f3:	89 ca                	mov    edx,ecx
  8e45f5:	8b 04 96             	mov    eax,DWORD PTR [rsi+rdx*4]
  8e45f8:	39 c8                	cmp    eax,ecx
  8e45fa:	75 04                	jne    8e4600 <check_data_emit+0x2aa0>
  8e45fc:	31 c0                	xor    eax,eax
  8e45fe:	eb 18                	jmp    8e4618 <check_data_emit+0x2ab8>
  8e4600:	48 8d 0c 96          	lea    rcx,[rsi+rdx*4]
  8e4604:	89 39                	mov    DWORD PTR [rcx],edi
  8e4606:	89 c2                	mov    edx,eax
  8e4608:	48 8d 0c 96          	lea    rcx,[rsi+rdx*4]
  8e460c:	8b 14 96             	mov    edx,DWORD PTR [rsi+rdx*4]
  8e460f:	39 c2                	cmp    edx,eax
  8e4611:	89 d0                	mov    eax,edx
  8e4613:	75 ef                	jne    8e4604 <check_data_emit+0x2aa4>
  8e4615:	44 89 d8             	mov    eax,r11d
  8e4618:	3b 7c 24 38          	cmp    edi,DWORD PTR [rsp+0x38]
  8e461c:	0f 83 d5 02 00 00    	jae    8e48f7 <check_data_emit+0x2d97>
  8e4622:	a8 01                	test   al,0x1
  8e4624:	0f 85 cd 02 00 00    	jne    8e48f7 <check_data_emit+0x2d97>
  8e462a:	48 8b 84 24 a0 00 00 	mov    rax,QWORD PTR [rsp+0xa0]
  8e4631:	00 
  8e4632:	4c 8b 54 24 50       	mov    r10,QWORD PTR [rsp+0x50]
  8e4637:	44 89 d9             	mov    ecx,r11d
  8e463a:	48 c1 e0 05          	shl    rax,0x5
  8e463e:	48 03 84 24 80 00 00 	add    rax,QWORD PTR [rsp+0x80]
  8e4645:	00 
  8e4646:	48 89 84 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rax
  8e464d:	00 
  8e464e:	41 8b 02             	mov    eax,DWORD PTR [r10]
  8e4651:	41 89 fb             	mov    r11d,edi
  8e4654:	83 f8 01             	cmp    eax,0x1
  8e4657:	74 1b                	je     8e4674 <check_data_emit+0x2b14>
  8e4659:	4c 8b 8c 24 c0 00 00 	mov    r9,QWORD PTR [rsp+0xc0]
  8e4660:	00 
  8e4661:	83 f8 02             	cmp    eax,0x2
  8e4664:	75 12                	jne    8e4678 <check_data_emit+0x2b18>
  8e4666:	4c 8b 4c 24 38       	mov    r9,QWORD PTR [rsp+0x38]
  8e466b:	ff c7                	inc    edi
  8e466d:	89 c8                	mov    eax,ecx
  8e466f:	e9 39 02 00 00       	jmp    8e48ad <check_data_emit+0x2d4d>
  8e4674:	4d 8b 4a 28          	mov    r9,QWORD PTR [r10+0x28]
  8e4678:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
  8e467d:	49 8b 42 18          	mov    rax,QWORD PTR [r10+0x18]
  8e4681:	4c 89 5c 24 18       	mov    QWORD PTR [rsp+0x18],r11
  8e4686:	4a 8b 14 d9          	mov    rdx,QWORD PTR [rcx+r11*8]
  8e468a:	4a 8b 4c d9 08       	mov    rcx,QWORD PTR [rcx+r11*8+0x8]
  8e468f:	48 29 c2             	sub    rdx,rax
  8e4692:	48 29 c1             	sub    rcx,rax
  8e4695:	48 89 cd             	mov    rbp,rcx
  8e4698:	48 29 d1             	sub    rcx,rdx
  8e469b:	49 89 d6             	mov    r14,rdx
  8e469e:	76 34                	jbe    8e46d4 <check_data_emit+0x2b74>
  8e46a0:	4c 89 f0             	mov    rax,r14
  8e46a3:	48 83 e0 07          	and    rax,0x7
  8e46a7:	74 2b                	je     8e46d4 <check_data_emit+0x2b74>
  8e46a9:	41 b8 08 00 00 00    	mov    r8d,0x8
  8e46af:	49 29 c0             	sub    r8,rax
  8e46b2:	4c 39 c1             	cmp    rcx,r8
  8e46b5:	4c 0f 42 c1          	cmovb  r8,rcx
  8e46b9:	4c 89 f1             	mov    rcx,r14
  8e46bc:	48 c1 e9 03          	shr    rcx,0x3
  8e46c0:	41 0f b6 0c 09       	movzx  ecx,BYTE PTR [r9+rcx*1]
  8e46c5:	4d 01 c6             	add    r14,r8
  8e46c8:	c4 e2 7b f7 c1       	shrx   eax,ecx,eax
  8e46cd:	c4 e2 38 f5 d0       	bzhi   edx,eax,r8d
  8e46d2:	eb 02                	jmp    8e46d6 <check_data_emit+0x2b76>
  8e46d4:	31 d2                	xor    edx,edx
  8e46d6:	49 89 ea             	mov    r10,rbp
  8e46d9:	4d 89 f0             	mov    r8,r14
  8e46dc:	49 c1 ea 03          	shr    r10,0x3
  8e46e0:	49 c1 e8 03          	shr    r8,0x3
  8e46e4:	4c 89 d0             	mov    rax,r10
  8e46e7:	4c 29 c0             	sub    rax,r8
  8e46ea:	48 83 f8 40          	cmp    rax,0x40
  8e46ee:	72 28                	jb     8e4718 <check_data_emit+0x2bb8>
  8e46f0:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e46f4:	62 91 fd 48 eb 04 01 	vporq  zmm0,zmm0,ZMMWORD PTR [r9+r8*1]
  8e46fb:	49 83 c0 40          	add    r8,0x40
  8e46ff:	48 83 c0 c0          	add    rax,0xffffffffffffffc0
  8e4703:	48 83 f8 3f          	cmp    rax,0x3f
  8e4707:	77 eb                	ja     8e46f4 <check_data_emit+0x2b94>
  8e4709:	62 f2 7d 48 27 c0    	vptestmd k0,zmm0,zmm0
  8e470f:	c5 f8 98 c0          	kortestw k0,k0
  8e4713:	0f 95 c0             	setne  al
  8e4716:	08 c2                	or     dl,al
  8e4718:	4c 89 d0             	mov    rax,r10
  8e471b:	4c 29 c0             	sub    rax,r8
  8e471e:	0f 86 4e 01 00 00    	jbe    8e4872 <check_data_emit+0x2d12>
  8e4724:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
  8e4729:	48 83 f8 10          	cmp    rax,0x10
  8e472d:	73 08                	jae    8e4737 <check_data_emit+0x2bd7>
  8e472f:	4c 89 c1             	mov    rcx,r8
  8e4732:	e9 2f 01 00 00       	jmp    8e4866 <check_data_emit+0x2d06>
  8e4737:	48 81 7c 24 48 00 01 	cmp    QWORD PTR [rsp+0x48],0x100
  8e473e:	00 00 
  8e4740:	73 08                	jae    8e474a <check_data_emit+0x2bea>
  8e4742:	45 31 db             	xor    r11d,r11d
  8e4745:	e9 b8 00 00 00       	jmp    8e4802 <check_data_emit+0x2ca2>
  8e474a:	4c 8b 5c 24 48       	mov    r11,QWORD PTR [rsp+0x48]
  8e474f:	48 b8 00 ff ff ff ff 	movabs rax,0x1fffffffffffff00
  8e4756:	ff ff 1f 
  8e4759:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  8e475d:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  8e4761:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  8e4765:	49 21 c3             	and    r11,rax
  8e4768:	0f b6 c2             	movzx  eax,dl
  8e476b:	31 d2                	xor    edx,edx
  8e476d:	c5 f9 6e c8          	vmovd  xmm1,eax
  8e4771:	4b 8d 84 01 c0 00 00 	lea    rax,[r9+r8*1+0xc0]
  8e4778:	00 
  8e4779:	4b 8d 0c 18          	lea    rcx,[r8+r11*1]
  8e477d:	62 f1 f5 48 eb 4c 10 	vporq  zmm1,zmm1,ZMMWORD PTR [rax+rdx*1-0xc0]
  8e4784:	fd 
  8e4785:	62 f1 e5 48 eb 5c 10 	vporq  zmm3,zmm3,ZMMWORD PTR [rax+rdx*1-0x80]
  8e478c:	fe 
  8e478d:	62 f1 ed 48 eb 54 10 	vporq  zmm2,zmm2,ZMMWORD PTR [rax+rdx*1-0x40]
  8e4794:	ff 
  8e4795:	62 f1 fd 48 eb 04 10 	vporq  zmm0,zmm0,ZMMWORD PTR [rax+rdx*1]
  8e479c:	48 81 c2 00 01 00 00 	add    rdx,0x100
  8e47a3:	49 39 d3             	cmp    r11,rdx
  8e47a6:	75 d5                	jne    8e477d <check_data_emit+0x2c1d>
  8e47a8:	62 f1 e5 48 eb c9    	vporq  zmm1,zmm3,zmm1
  8e47ae:	62 f3 ed 48 25 c1 fe 	vpternlogq zmm0,zmm2,zmm1,0xfe
  8e47b5:	62 f3 fd 48 3b c1 01 	vextracti64x4 ymm1,zmm0,0x1
  8e47bc:	62 f1 fd 48 eb c1    	vporq  zmm0,zmm0,zmm1
  8e47c2:	c4 e3 7d 39 c1 01    	vextracti128 xmm1,ymm0,0x1
  8e47c8:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e47cc:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e47d1:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e47d5:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e47da:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e47de:	c5 f1 72 d0 10       	vpsrld xmm1,xmm0,0x10
  8e47e3:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e47e7:	c5 f1 71 d0 08       	vpsrlw xmm1,xmm0,0x8
  8e47ec:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e47f0:	c5 f9 7e c2          	vmovd  edx,xmm0
  8e47f4:	4c 39 5c 24 48       	cmp    QWORD PTR [rsp+0x48],r11
  8e47f9:	74 77                	je     8e4872 <check_data_emit+0x2d12>
  8e47fb:	f6 44 24 48 f0       	test   BYTE PTR [rsp+0x48],0xf0
  8e4800:	74 64                	je     8e4866 <check_data_emit+0x2d06>
  8e4802:	48 b8 00 ff ff ff ff 	movabs rax,0x1fffffffffffff00
  8e4809:	ff ff 1f 
  8e480c:	0f b6 ca             	movzx  ecx,dl
  8e480f:	48 05 f0 00 00 00    	add    rax,0xf0
  8e4815:	48 23 44 24 48       	and    rax,QWORD PTR [rsp+0x48]
  8e481a:	c5 f9 6e c1          	vmovd  xmm0,ecx
  8e481e:	4b 8d 0c 01          	lea    rcx,[r9+r8*1]
  8e4822:	49 01 c0             	add    r8,rax
  8e4825:	c4 a1 79 eb 04 19    	vpor   xmm0,xmm0,XMMWORD PTR [rcx+r11*1]
  8e482b:	49 83 c3 10          	add    r11,0x10
  8e482f:	4c 39 d8             	cmp    rax,r11
  8e4832:	75 f1                	jne    8e4825 <check_data_emit+0x2cc5>
  8e4834:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  8e4839:	4c 89 c1             	mov    rcx,r8
  8e483c:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e4840:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  8e4845:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e4849:	c5 f1 72 d0 10       	vpsrld xmm1,xmm0,0x10
  8e484e:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e4852:	c5 f1 71 d0 08       	vpsrlw xmm1,xmm0,0x8
  8e4857:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  8e485b:	c5 f9 7e c2          	vmovd  edx,xmm0
  8e485f:	48 39 44 24 48       	cmp    QWORD PTR [rsp+0x48],rax
  8e4864:	74 0c                	je     8e4872 <check_data_emit+0x2d12>
  8e4866:	41 0a 14 09          	or     dl,BYTE PTR [r9+rcx*1]
  8e486a:	48 ff c1             	inc    rcx
  8e486d:	49 39 ca             	cmp    r10,rcx
  8e4870:	75 f4                	jne    8e4866 <check_data_emit+0x2d06>
  8e4872:	49 39 ee             	cmp    r14,rbp
  8e4875:	73 20                	jae    8e4897 <check_data_emit+0x2d37>
  8e4877:	48 89 e9             	mov    rcx,rbp
  8e487a:	48 83 e1 07          	and    rcx,0x7
  8e487e:	74 17                	je     8e4897 <check_data_emit+0x2d37>
  8e4880:	48 83 e5 f8          	and    rbp,0xfffffffffffffff8
  8e4884:	49 39 ee             	cmp    r14,rbp
  8e4887:	77 0e                	ja     8e4897 <check_data_emit+0x2d37>
  8e4889:	b0 ff                	mov    al,0xff
  8e488b:	d2 e0                	shl    al,cl
  8e488d:	f6 d0                	not    al
  8e488f:	43 22 04 11          	and    al,BYTE PTR [r9+r10*1]
  8e4893:	08 d0                	or     al,dl
  8e4895:	89 c2                	mov    edx,eax
  8e4897:	4c 8b 54 24 50       	mov    r10,QWORD PTR [rsp+0x50]
  8e489c:	4c 8b 4c 24 38       	mov    r9,QWORD PTR [rsp+0x38]
  8e48a1:	4c 8b 5c 24 18       	mov    r11,QWORD PTR [rsp+0x18]
  8e48a6:	ff c7                	inc    edi
  8e48a8:	84 d2                	test   dl,dl
  8e48aa:	0f 95 c0             	setne  al
  8e48ad:	89 f9                	mov    ecx,edi
  8e48af:	89 ca                	mov    edx,ecx
  8e48b1:	89 d7                	mov    edi,edx
  8e48b3:	89 d2                	mov    edx,edx
  8e48b5:	8b 14 96             	mov    edx,DWORD PTR [rsi+rdx*4]
  8e48b8:	39 fa                	cmp    edx,edi
  8e48ba:	75 f5                	jne    8e48b1 <check_data_emit+0x2d51>
  8e48bc:	41 89 c8             	mov    r8d,ecx
  8e48bf:	42 8b 14 86          	mov    edx,DWORD PTR [rsi+r8*4]
  8e48c3:	39 ca                	cmp    edx,ecx
  8e48c5:	74 19                	je     8e48e0 <check_data_emit+0x2d80>
  8e48c7:	4a 8d 0c 86          	lea    rcx,[rsi+r8*4]
  8e48cb:	89 39                	mov    DWORD PTR [rcx],edi
  8e48cd:	41 89 d0             	mov    r8d,edx
  8e48d0:	4a 8d 0c 86          	lea    rcx,[rsi+r8*4]
  8e48d4:	46 8b 04 86          	mov    r8d,DWORD PTR [rsi+r8*4]
  8e48d8:	41 39 d0             	cmp    r8d,edx
  8e48db:	44 89 c2             	mov    edx,r8d
  8e48de:	75 eb                	jne    8e48cb <check_data_emit+0x2d6b>
  8e48e0:	42 89 3c 9e          	mov    DWORD PTR [rsi+r11*4],edi
  8e48e4:	44 39 cf             	cmp    edi,r9d
  8e48e7:	73 13                	jae    8e48fc <check_data_emit+0x2d9c>
  8e48e9:	89 c2                	mov    edx,eax
  8e48eb:	31 c9                	xor    ecx,ecx
  8e48ed:	a8 01                	test   al,0x1
  8e48ef:	0f 84 59 fd ff ff    	je     8e464e <check_data_emit+0x2aee>
  8e48f5:	eb 07                	jmp    8e48fe <check_data_emit+0x2d9e>
  8e48f7:	4c 89 da             	mov    rdx,r11
  8e48fa:	eb 02                	jmp    8e48fe <check_data_emit+0x2d9e>
  8e48fc:	89 c2                	mov    edx,eax
  8e48fe:	48 83 bc 24 a0 00 00 	cmp    QWORD PTR [rsp+0xa0],0x0
  8e4905:	00 00 
  8e4907:	49 89 d3             	mov    r11,rdx
  8e490a:	74 08                	je     8e4914 <check_data_emit+0x2db4>
  8e490c:	a8 01                	test   al,0x1
  8e490e:	0f 84 8f fb ff ff    	je     8e44a3 <check_data_emit+0x2943>
  8e4914:	8b ac 24 88 00 00 00 	mov    ebp,DWORD PTR [rsp+0x88]
  8e491b:	e9 11 e6 ff ff       	jmp    8e2f31 <check_data_emit+0x13d1>
  8e4920:	89 cf                	mov    edi,ecx
  8e4922:	48 c1 e7 03          	shl    rdi,0x3
  8e4926:	4c 8b 5b 10          	mov    r11,QWORD PTR [rbx+0x10]
  8e492a:	4c 8d 14 bf          	lea    r10,[rdi+rdi*4]
  8e492e:	48 8b 7c 24 68       	mov    rdi,QWORD PTR [rsp+0x68]
  8e4933:	48 29 c7             	sub    rdi,rax
  8e4936:	49 29 fb             	sub    r11,rdi
  8e4939:	41 0f 92 c6          	setb   r14b
  8e493d:	4d 39 da             	cmp    r10,r11
  8e4940:	41 0f 97 c3          	seta   r11b
  8e4944:	45 08 f3             	or     r11b,r14b
  8e4947:	0f 84 1a 01 00 00    	je     8e4a67 <check_data_emit+0x2f07>
  8e494d:	31 ed                	xor    ebp,ebp
  8e494f:	e9 30 01 00 00       	jmp    8e4a84 <check_data_emit+0x2f24>
  8e4954:	45 31 c0             	xor    r8d,r8d
  8e4957:	48 c7 84 24 98 00 00 	mov    QWORD PTR [rsp+0x98],0x0
  8e495e:	00 00 00 00 00 
  8e4963:	85 c9                	test   ecx,ecx
  8e4965:	40 0f 94 c6          	sete   sil
  8e4969:	45 85 d2             	test   r10d,r10d
  8e496c:	40 0f 95 c7          	setne  dil
  8e4970:	0f 94 c0             	sete   al
  8e4973:	40 08 f7             	or     dil,sil
  8e4976:	0f 85 bc 01 00 00    	jne    8e4b38 <check_data_emit+0x2fd8>
  8e497c:	bf 01 00 00 00       	mov    edi,0x1
  8e4981:	89 c8                	mov    eax,ecx
  8e4983:	31 c9                	xor    ecx,ecx
  8e4985:	44 89 44 24 7c       	mov    DWORD PTR [rsp+0x7c],r8d
  8e498a:	48 89 94 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rdx
  8e4991:	00 
  8e4992:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
  8e4997:	eb 0e                	jmp    8e49a7 <check_data_emit+0x2e47>
  8e4999:	48 ff c1             	inc    rcx
  8e499c:	48 3b 4c 24 18       	cmp    rcx,QWORD PTR [rsp+0x18]
  8e49a1:	0f 83 83 01 00 00    	jae    8e4b2a <check_data_emit+0x2fca>
  8e49a7:	48 8d 04 89          	lea    rax,[rcx+rcx*4]
  8e49ab:	44 8b 44 c5 18       	mov    r8d,DWORD PTR [rbp+rax*8+0x18]
  8e49b0:	4d 85 c0             	test   r8,r8
  8e49b3:	74 e4                	je     8e4999 <check_data_emit+0x2e39>
  8e49b5:	48 8d 44 c5 00       	lea    rax,[rbp+rax*8+0x0]
  8e49ba:	4d 8b 96 88 00 00 00 	mov    r10,QWORD PTR [r14+0x88]
  8e49c1:	45 31 db             	xor    r11d,r11d
  8e49c4:	4c 8b 48 10          	mov    r9,QWORD PTR [rax+0x10]
  8e49c8:	49 83 c1 08          	add    r9,0x8
  8e49cc:	eb 0c                	jmp    8e49da <check_data_emit+0x2e7a>
  8e49ce:	49 ff c3             	inc    r11
  8e49d1:	49 83 c1 18          	add    r9,0x18
  8e49d5:	4d 39 c3             	cmp    r11,r8
  8e49d8:	73 bf                	jae    8e4999 <check_data_emit+0x2e39>
  8e49da:	41 8b 01             	mov    eax,DWORD PTR [r9]
  8e49dd:	41 f6 04 02 30       	test   BYTE PTR [r10+rax*1],0x30
  8e49e2:	75 ea                	jne    8e49ce <check_data_emit+0x2e6e>
  8e49e4:	49 8b b6 90 00 00 00 	mov    rsi,QWORD PTR [r14+0x90]
  8e49eb:	80 3c 06 07          	cmp    BYTE PTR [rsi+rax*1],0x7
  8e49ef:	74 dd                	je     8e49ce <check_data_emit+0x2e6e>
  8e49f1:	49 8b 76 70          	mov    rsi,QWORD PTR [r14+0x70]
  8e49f5:	8b 34 86             	mov    esi,DWORD PTR [rsi+rax*4]
  8e49f8:	48 85 f6             	test   rsi,rsi
  8e49fb:	74 1b                	je     8e4a18 <check_data_emit+0x2eb8>
  8e49fd:	41 3b 76 60          	cmp    esi,DWORD PTR [r14+0x60]
  8e4a01:	73 15                	jae    8e4a18 <check_data_emit+0x2eb8>
  8e4a03:	4d 8b 76 30          	mov    r14,QWORD PTR [r14+0x30]
  8e4a07:	8b 94 24 38 06 00 00 	mov    edx,DWORD PTR [rsp+0x638]
  8e4a0e:	41 39 14 b6          	cmp    DWORD PTR [r14+rsi*4],edx
  8e4a12:	40 0f 94 c6          	sete   sil
  8e4a16:	eb 02                	jmp    8e4a1a <check_data_emit+0x2eba>
  8e4a18:	31 f6                	xor    esi,esi
  8e4a1a:	48 8b 54 24 68       	mov    rdx,QWORD PTR [rsp+0x68]
  8e4a1f:	41 89 c6             	mov    r14d,eax
  8e4a22:	41 c1 ee 06          	shr    r14d,0x6
  8e4a26:	c4 e2 f9 f7 c7       	shlx   rax,rdi,rax
  8e4a2b:	4a 23 04 f2          	and    rax,QWORD PTR [rdx+r14*8]
  8e4a2f:	4c 8b b4 24 30 06 00 	mov    r14,QWORD PTR [rsp+0x630]
  8e4a36:	00 
  8e4a37:	75 95                	jne    8e49ce <check_data_emit+0x2e6e>
  8e4a39:	40 84 f6             	test   sil,sil
  8e4a3c:	75 90                	jne    8e49ce <check_data_emit+0x2e6e>
  8e4a3e:	48 8b 84 24 c8 00 00 	mov    rax,QWORD PTR [rsp+0xc8]
  8e4a45:	00 
  8e4a46:	48 8d 14 49          	lea    rdx,[rcx+rcx*2]
  8e4a4a:	41 c7 45 00 05 00 00 	mov    DWORD PTR [r13+0x0],0x5
  8e4a51:	00 
  8e4a52:	41 89 4d 04          	mov    DWORD PTR [r13+0x4],ecx
  8e4a56:	48 c1 e2 04          	shl    rdx,0x4
  8e4a5a:	8b 44 10 0c          	mov    eax,DWORD PTR [rax+rdx*1+0xc]
  8e4a5e:	41 89 45 08          	mov    DWORD PTR [r13+0x8],eax
  8e4a62:	e9 a1 d1 ff ff       	jmp    8e1c08 <check_data_emit+0xa8>
  8e4a67:	4c 8b 5c 24 68       	mov    r11,QWORD PTR [rsp+0x68]
  8e4a6c:	4c 01 d7             	add    rdi,r10
  8e4a6f:	48 89 7b 08          	mov    QWORD PTR [rbx+0x8],rdi
  8e4a73:	4c 89 dd             	mov    rbp,r11
  8e4a76:	4d 01 d3             	add    r11,r10
  8e4a79:	4c 89 df             	mov    rdi,r11
  8e4a7c:	48 29 c7             	sub    rdi,rax
  8e4a7f:	4c 89 5c 24 68       	mov    QWORD PTR [rsp+0x68],r11
  8e4a84:	4c 8b 53 10          	mov    r10,QWORD PTR [rbx+0x10]
  8e4a88:	49 29 fa             	sub    r10,rdi
  8e4a8b:	0f 82 b1 d2 ff ff    	jb     8e1d42 <check_data_emit+0x1e2>
  8e4a91:	48 8b 84 24 30 06 00 	mov    rax,QWORD PTR [rsp+0x630]
  8e4a98:	00 
  8e4a99:	8b 80 b8 00 00 00    	mov    eax,DWORD PTR [rax+0xb8]
  8e4a9f:	48 83 c0 3f          	add    rax,0x3f
  8e4aa3:	48 c1 e8 03          	shr    rax,0x3
  8e4aa7:	83 e0 f8             	and    eax,0xfffffff8
  8e4aaa:	4c 39 d0             	cmp    rax,r10
  8e4aad:	0f 87 8f d2 ff ff    	ja     8e1d42 <check_data_emit+0x1e2>
  8e4ab3:	48 01 c7             	add    rdi,rax
  8e4ab6:	48 89 7b 08          	mov    QWORD PTR [rbx+0x8],rdi
  8e4aba:	48 85 ed             	test   rbp,rbp
  8e4abd:	0f 84 7f d2 ff ff    	je     8e1d42 <check_data_emit+0x1e2>
  8e4ac3:	48 83 7c 24 68 00    	cmp    QWORD PTR [rsp+0x68],0x0
  8e4ac9:	0f 84 73 d2 ff ff    	je     8e1d42 <check_data_emit+0x1e2>
  8e4acf:	48 8b 7c 24 68       	mov    rdi,QWORD PTR [rsp+0x68]
  8e4ad4:	48 89 b4 24 d8 00 00 	mov    QWORD PTR [rsp+0xd8],rsi
  8e4adb:	00 
  8e4adc:	48 89 94 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rdx
  8e4ae3:	00 
  8e4ae4:	31 f6                	xor    esi,esi
  8e4ae6:	48 89 c2             	mov    rdx,rax
  8e4ae9:	89 4c 24 64          	mov    DWORD PTR [rsp+0x64],ecx
  8e4aed:	45 89 ce             	mov    r14d,r9d
  8e4af0:	4c 89 84 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],r8
  8e4af7:	00 
  8e4af8:	e8 73 96 ee ff       	call   7ce170 <memset@plt>
  8e4afd:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  8e4b02:	48 8b b4 24 d8 00 00 	mov    rsi,QWORD PTR [rsp+0xd8]
  8e4b09:	00 
  8e4b0a:	4c 8b 84 24 b0 00 00 	mov    r8,QWORD PTR [rsp+0xb0]
  8e4b11:	00 
  8e4b12:	48 8b 94 24 c8 00 00 	mov    rdx,QWORD PTR [rsp+0xc8]
  8e4b19:	00 
  8e4b1a:	8b 4c 24 64          	mov    ecx,DWORD PTR [rsp+0x64]
  8e4b1e:	45 8b 55 00          	mov    r10d,DWORD PTR [r13+0x0]
  8e4b22:	45 89 f1             	mov    r9d,r14d
  8e4b25:	e9 3c d2 ff ff       	jmp    8e1d66 <check_data_emit+0x206>
  8e4b2a:	8b 4c 24 64          	mov    ecx,DWORD PTR [rsp+0x64]
  8e4b2e:	44 8b 44 24 7c       	mov    r8d,DWORD PTR [rsp+0x7c]
  8e4b33:	b0 01                	mov    al,0x1
  8e4b35:	45 31 d2             	xor    r10d,r10d
  8e4b38:	84 c0                	test   al,al
  8e4b3a:	74 5c                	je     8e4b98 <check_data_emit+0x3038>
  8e4b3c:	48 8b 44 24 70       	mov    rax,QWORD PTR [rsp+0x70]
  8e4b41:	41 89 4d 10          	mov    DWORD PTR [r13+0x10],ecx
  8e4b45:	45 89 45 14          	mov    DWORD PTR [r13+0x14],r8d
  8e4b49:	41 89 45 18          	mov    DWORD PTR [r13+0x18],eax
  8e4b4d:	48 8b 84 24 98 00 00 	mov    rax,QWORD PTR [rsp+0x98]
  8e4b54:	00 
  8e4b55:	49 89 45 20          	mov    QWORD PTR [r13+0x20],rax
  8e4b59:	41 8b 46 64          	mov    eax,DWORD PTR [r14+0x64]
  8e4b5d:	41 2b 46 60          	sub    eax,DWORD PTR [r14+0x60]
  8e4b61:	39 c1                	cmp    ecx,eax
  8e4b63:	0f 87 d9 d1 ff ff    	ja     8e1d42 <check_data_emit+0x1e2>
  8e4b69:	41 8b 86 e4 00 00 00 	mov    eax,DWORD PTR [r14+0xe4]
  8e4b70:	41 2b 86 e0 00 00 00 	sub    eax,DWORD PTR [r14+0xe0]
  8e4b77:	41 39 c0             	cmp    r8d,eax
  8e4b7a:	0f 87 c2 d1 ff ff    	ja     8e1d42 <check_data_emit+0x1e2>
  8e4b80:	41 8b 86 f4 00 00 00 	mov    eax,DWORD PTR [r14+0xf4]
  8e4b87:	41 2b 86 f0 00 00 00 	sub    eax,DWORD PTR [r14+0xf0]
  8e4b8e:	39 44 24 70          	cmp    DWORD PTR [rsp+0x70],eax
  8e4b92:	0f 87 aa d1 ff ff    	ja     8e1d42 <check_data_emit+0x1e2>
  8e4b98:	48 c7 44 24 40 00 00 	mov    QWORD PTR [rsp+0x40],0x0
  8e4b9f:	00 00 
  8e4ba1:	45 85 d2             	test   r10d,r10d
  8e4ba4:	75 5e                	jne    8e4c04 <check_data_emit+0x30a4>
  8e4ba6:	48 83 bc 24 98 00 00 	cmp    QWORD PTR [rsp+0x98],0x0
  8e4bad:	00 00 
  8e4baf:	74 53                	je     8e4c04 <check_data_emit+0x30a4>
  8e4bb1:	48 8b 84 24 40 06 00 	mov    rax,QWORD PTR [rsp+0x640]
  8e4bb8:	00 
  8e4bb9:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
  8e4bbd:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
  8e4bc1:	48 29 c8             	sub    rax,rcx
  8e4bc4:	0f 82 78 d1 ff ff    	jb     8e1d42 <check_data_emit+0x1e2>
  8e4bca:	48 39 84 24 98 00 00 	cmp    QWORD PTR [rsp+0x98],rax
  8e4bd1:	00 
  8e4bd2:	0f 87 6a d1 ff ff    	ja     8e1d42 <check_data_emit+0x1e2>
  8e4bd8:	48 8b b4 24 98 00 00 	mov    rsi,QWORD PTR [rsp+0x98]
  8e4bdf:	00 
  8e4be0:	48 8b 84 24 40 06 00 	mov    rax,QWORD PTR [rsp+0x640]
  8e4be7:	00 
  8e4be8:	48 89 ca             	mov    rdx,rcx
  8e4beb:	48 01 d6             	add    rsi,rdx
  8e4bee:	48 03 10             	add    rdx,QWORD PTR [rax]
  8e4bf1:	48 89 70 08          	mov    QWORD PTR [rax+0x8],rsi
  8e4bf5:	48 89 54 24 40       	mov    QWORD PTR [rsp+0x40],rdx
  8e4bfa:	0f 84 42 d1 ff ff    	je     8e1d42 <check_data_emit+0x1e2>
  8e4c00:	45 8b 55 00          	mov    r10d,DWORD PTR [r13+0x0]
  8e4c04:	83 7c 24 64 00       	cmp    DWORD PTR [rsp+0x64],0x0
  8e4c09:	4c 8b b4 24 30 06 00 	mov    r14,QWORD PTR [rsp+0x630]
  8e4c10:	00 
  8e4c11:	48 bd 00 00 00 00 ff 	movabs rbp,0xffffffff00000000
  8e4c18:	ff ff ff 
  8e4c1b:	0f 84 e7 cf ff ff    	je     8e1c08 <check_data_emit+0xa8>
  8e4c21:	45 85 d2             	test   r10d,r10d
  8e4c24:	0f 85 de cf ff ff    	jne    8e1c08 <check_data_emit+0xa8>
  8e4c2a:	41 8b 4e 60          	mov    ecx,DWORD PTR [r14+0x60]
  8e4c2e:	49 8d 45 0c          	lea    rax,[r13+0xc]
  8e4c32:	31 d2                	xor    edx,edx
  8e4c34:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
  8e4c3b:	00 00 
  8e4c3d:	89 08                	mov    DWORD PTR [rax],ecx
  8e4c3f:	eb 10                	jmp    8e4c51 <check_data_emit+0x30f1>
  8e4c41:	8b 54 24 28          	mov    edx,DWORD PTR [rsp+0x28]
  8e4c45:	ff c2                	inc    edx
  8e4c47:	3b 54 24 64          	cmp    edx,DWORD PTR [rsp+0x64]
  8e4c4b:	0f 84 b7 cf ff ff    	je     8e1c08 <check_data_emit+0xa8>
  8e4c51:	48 8b 8c 24 d0 00 00 	mov    rcx,QWORD PTR [rsp+0xd0]
  8e4c58:	00 
  8e4c59:	89 d0                	mov    eax,edx
  8e4c5b:	48 8d 04 80          	lea    rax,[rax+rax*4]
  8e4c5f:	89 54 24 28          	mov    DWORD PTR [rsp+0x28],edx
  8e4c63:	4c 8d 14 c1          	lea    r10,[rcx+rax*8]
  8e4c67:	0f b6 44 c1 21       	movzx  eax,BYTE PTR [rcx+rax*8+0x21]
  8e4c6c:	4c 89 54 24 68       	mov    QWORD PTR [rsp+0x68],r10
  8e4c71:	83 f8 08             	cmp    eax,0x8
  8e4c74:	74 33                	je     8e4ca9 <check_data_emit+0x3149>
  8e4c76:	83 f8 0d             	cmp    eax,0xd
  8e4c79:	74 2e                	je     8e4ca9 <check_data_emit+0x3149>
  8e4c7b:	49 8b 52 08          	mov    rdx,QWORD PTR [r10+0x8]
  8e4c7f:	48 85 d2             	test   rdx,rdx
  8e4c82:	74 25                	je     8e4ca9 <check_data_emit+0x3149>
  8e4c84:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  8e4c89:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
  8e4c8e:	49 8b 32             	mov    rsi,QWORD PTR [r10]
  8e4c91:	48 8d 3c 08          	lea    rdi,[rax+rcx*1]
  8e4c95:	48 89 7c 24 18       	mov    QWORD PTR [rsp+0x18],rdi
  8e4c9a:	48 85 f6             	test   rsi,rsi
  8e4c9d:	74 0f                	je     8e4cae <check_data_emit+0x314e>
  8e4c9f:	c5 f8 77             	vzeroupper
  8e4ca2:	e8 e9 95 ee ff       	call   7ce290 <memcpy@plt>
  8e4ca7:	eb 0f                	jmp    8e4cb8 <check_data_emit+0x3158>
  8e4ca9:	45 31 db             	xor    r11d,r11d
  8e4cac:	eb 39                	jmp    8e4ce7 <check_data_emit+0x3187>
  8e4cae:	31 f6                	xor    esi,esi
  8e4cb0:	c5 f8 77             	vzeroupper
  8e4cb3:	e8 b8 94 ee ff       	call   7ce170 <memset@plt>
  8e4cb8:	4c 8b 54 24 68       	mov    r10,QWORD PTR [rsp+0x68]
  8e4cbd:	48 8b 44 24 10       	mov    rax,QWORD PTR [rsp+0x10]
  8e4cc2:	4c 8b b4 24 30 06 00 	mov    r14,QWORD PTR [rsp+0x630]
  8e4cc9:	00 
  8e4cca:	4c 8b 5c 24 18       	mov    r11,QWORD PTR [rsp+0x18]
  8e4ccf:	48 bd 00 00 00 00 ff 	movabs rbp,0xffffffff00000000
  8e4cd6:	ff ff ff 
  8e4cd9:	49 03 42 08          	add    rax,QWORD PTR [r10+0x8]
  8e4cdd:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
  8e4ce2:	41 0f b6 42 21       	movzx  eax,BYTE PTR [r10+0x21]
  8e4ce7:	41 0f b6 72 20       	movzx  esi,BYTE PTR [r10+0x20]
  8e4cec:	49 8b 4a 08          	mov    rcx,QWORD PTR [r10+0x8]
  8e4cf0:	3c 0d                	cmp    al,0xd
  8e4cf2:	74 08                	je     8e4cfc <check_data_emit+0x319c>
  8e4cf4:	0f b6 d0             	movzx  edx,al
  8e4cf7:	83 fa 08             	cmp    edx,0x8
  8e4cfa:	75 09                	jne    8e4d05 <check_data_emit+0x31a5>
  8e4cfc:	4d 85 db             	test   r11,r11
  8e4cff:	40 0f 94 c7          	sete   dil
  8e4d03:	eb 10                	jmp    8e4d15 <check_data_emit+0x31b5>
  8e4d05:	4d 85 db             	test   r11,r11
  8e4d08:	0f 95 c2             	setne  dl
  8e4d0b:	48 85 c9             	test   rcx,rcx
  8e4d0e:	40 0f 94 c7          	sete   dil
  8e4d12:	40 08 d7             	or     dil,dl
  8e4d15:	41 8b 56 60          	mov    edx,DWORD PTR [r14+0x60]
  8e4d19:	41 3b 56 64          	cmp    edx,DWORD PTR [r14+0x64]
  8e4d1d:	75 26                	jne    8e4d45 <check_data_emit+0x31e5>
  8e4d1f:	41 83 be 18 01 00 00 	cmp    DWORD PTR [r14+0x118],0x0
  8e4d26:	00 
  8e4d27:	c7 44 24 18 00 00 00 	mov    DWORD PTR [rsp+0x18],0x0
  8e4d2e:	00 
  8e4d2f:	0f 85 a8 00 00 00    	jne    8e4ddd <check_data_emit+0x327d>
  8e4d35:	41 c7 86 18 01 00 00 	mov    DWORD PTR [r14+0x118],0x1
  8e4d3c:	01 00 00 00 
  8e4d40:	e9 98 00 00 00       	jmp    8e4ddd <check_data_emit+0x327d>
  8e4d45:	44 8d 40 ff          	lea    r8d,[rax-0x1]
  8e4d49:	41 80 f8 0d          	cmp    r8b,0xd
  8e4d4d:	41 0f 92 c0          	setb   r8b
  8e4d51:	40 80 fe 21          	cmp    sil,0x21
  8e4d55:	41 0f 92 c1          	setb   r9b
  8e4d59:	45 20 c1             	and    r9b,r8b
  8e4d5c:	41 84 f9             	test   r9b,dil
  8e4d5f:	74 5f                	je     8e4dc0 <check_data_emit+0x3260>
  8e4d61:	49 8b 7e 20          	mov    rdi,QWORD PTR [r14+0x20]
  8e4d65:	89 54 24 18          	mov    DWORD PTR [rsp+0x18],edx
  8e4d69:	88 04 17             	mov    BYTE PTR [rdi+rdx*1],al
  8e4d6c:	49 8b 46 28          	mov    rax,QWORD PTR [r14+0x28]
  8e4d70:	40 88 34 10          	mov    BYTE PTR [rax+rdx*1],sil
  8e4d74:	8b b4 24 38 06 00 00 	mov    esi,DWORD PTR [rsp+0x638]
  8e4d7b:	49 8b 46 30          	mov    rax,QWORD PTR [r14+0x30]
  8e4d7f:	89 34 90             	mov    DWORD PTR [rax+rdx*4],esi
  8e4d82:	49 8b 46 38          	mov    rax,QWORD PTR [r14+0x38]
  8e4d86:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
  8e4d8a:	49 8b 46 40          	mov    rax,QWORD PTR [r14+0x40]
  8e4d8e:	4c 89 1c d0          	mov    QWORD PTR [rax+rdx*8],r11
  8e4d92:	49 8b 46 48          	mov    rax,QWORD PTR [r14+0x48]
  8e4d96:	c7 04 90 00 00 00 00 	mov    DWORD PTR [rax+rdx*4],0x0
  8e4d9d:	49 8b 46 50          	mov    rax,QWORD PTR [r14+0x50]
  8e4da1:	c7 04 90 00 00 00 00 	mov    DWORD PTR [rax+rdx*4],0x0
  8e4da8:	49 8b 46 58          	mov    rax,QWORD PTR [r14+0x58]
  8e4dac:	48 c7 04 d0 00 00 00 	mov    QWORD PTR [rax+rdx*8],0x0
  8e4db3:	00 
  8e4db4:	41 8b 76 60          	mov    esi,DWORD PTR [r14+0x60]
  8e4db8:	ff c6                	inc    esi
  8e4dba:	41 89 76 60          	mov    DWORD PTR [r14+0x60],esi
  8e4dbe:	eb 1f                	jmp    8e4ddf <check_data_emit+0x327f>
  8e4dc0:	41 83 be 18 01 00 00 	cmp    DWORD PTR [r14+0x118],0x0
  8e4dc7:	00 
  8e4dc8:	c7 44 24 18 00 00 00 	mov    DWORD PTR [rsp+0x18],0x0
  8e4dcf:	00 
  8e4dd0:	75 0b                	jne    8e4ddd <check_data_emit+0x327d>
  8e4dd2:	41 c7 86 18 01 00 00 	mov    DWORD PTR [r14+0x118],0x3
  8e4dd9:	03 00 00 00 
  8e4ddd:	89 d6                	mov    esi,edx
  8e4ddf:	41 8b 42 1c          	mov    eax,DWORD PTR [r10+0x1c]
  8e4de3:	48 85 c0             	test   rax,rax
  8e4de6:	0f 84 bb 03 00 00    	je     8e51a7 <check_data_emit+0x3647>
  8e4dec:	83 7c 24 18 00       	cmp    DWORD PTR [rsp+0x18],0x0
  8e4df1:	0f 84 b0 03 00 00    	je     8e51a7 <check_data_emit+0x3647>
  8e4df7:	41 3b 86 b8 00 00 00 	cmp    eax,DWORD PTR [r14+0xb8]
  8e4dfe:	0f 83 a3 03 00 00    	jae    8e51a7 <check_data_emit+0x3647>
  8e4e04:	39 74 24 18          	cmp    DWORD PTR [rsp+0x18],esi
  8e4e08:	0f 83 99 03 00 00    	jae    8e51a7 <check_data_emit+0x3647>
  8e4e0e:	49 8b 76 70          	mov    rsi,QWORD PTR [r14+0x70]
  8e4e12:	83 3c 86 00          	cmp    DWORD PTR [rsi+rax*4],0x0
  8e4e16:	0f 85 84 03 00 00    	jne    8e51a0 <check_data_emit+0x3640>
  8e4e1c:	49 8b 8e 90 00 00 00 	mov    rcx,QWORD PTR [r14+0x90]
  8e4e23:	80 3c 01 07          	cmp    BYTE PTR [rcx+rax*1],0x7
  8e4e27:	0f 84 73 03 00 00    	je     8e51a0 <check_data_emit+0x3640>
  8e4e2d:	49 8b 7a 08          	mov    rdi,QWORD PTR [r10+0x8]
  8e4e31:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
  8e4e35:	8b 54 24 18          	mov    edx,DWORD PTR [rsp+0x18]
  8e4e39:	48 3b 3c d1          	cmp    rdi,QWORD PTR [rcx+rdx*8]
  8e4e3d:	0f 87 5d 03 00 00    	ja     8e51a0 <check_data_emit+0x3640>
  8e4e43:	49 8b 4e 20          	mov    rcx,QWORD PTR [r14+0x20]
  8e4e47:	4d 8b 86 88 00 00 00 	mov    r8,QWORD PTR [r14+0x88]
  8e4e4e:	0f b6 0c 11          	movzx  ecx,BYTE PTR [rcx+rdx*1]
  8e4e52:	45 0f b6 04 00       	movzx  r8d,BYTE PTR [r8+rax*1]
  8e4e57:	80 c1 f9             	add    cl,0xf9
  8e4e5a:	41 80 e0 0f          	and    r8b,0xf
  8e4e5e:	80 f9 02             	cmp    cl,0x2
  8e4e61:	0f 92 c1             	setb   cl
  8e4e64:	41 80 f8 06          	cmp    r8b,0x6
  8e4e68:	41 0f 95 c0          	setne  r8b
  8e4e6c:	41 30 c8             	xor    r8b,cl
  8e4e6f:	0f 84 2b 03 00 00    	je     8e51a0 <check_data_emit+0x3640>
  8e4e75:	8b 4c 24 18          	mov    ecx,DWORD PTR [rsp+0x18]
  8e4e79:	89 0c 86             	mov    DWORD PTR [rsi+rax*4],ecx
  8e4e7c:	49 8b 4e 78          	mov    rcx,QWORD PTR [r14+0x78]
  8e4e80:	48 c7 04 c1 00 00 00 	mov    QWORD PTR [rcx+rax*8],0x0
  8e4e87:	00 
  8e4e88:	49 8b 8e 80 00 00 00 	mov    rcx,QWORD PTR [r14+0x80]
  8e4e8f:	48 89 3c c1          	mov    QWORD PTR [rcx+rax*8],rdi
  8e4e93:	49 8b 86 90 00 00 00 	mov    rax,QWORD PTR [r14+0x90]
  8e4e9a:	41 8b 4a 1c          	mov    ecx,DWORD PTR [r10+0x1c]
  8e4e9e:	c6 04 08 01          	mov    BYTE PTR [rax+rcx*1],0x1
  8e4ea2:	41 83 7a 18 00       	cmp    DWORD PTR [r10+0x18],0x0
  8e4ea7:	0f 84 94 fd ff ff    	je     8e4c41 <check_data_emit+0x30e1>
  8e4ead:	45 8b 86 e0 00 00 00 	mov    r8d,DWORD PTR [r14+0xe0]
  8e4eb4:	31 f6                	xor    esi,esi
  8e4eb6:	31 ff                	xor    edi,edi
  8e4eb8:	45 3b 86 e4 00 00 00 	cmp    r8d,DWORD PTR [r14+0xe4]
  8e4ebf:	0f 84 a3 02 00 00    	je     8e5168 <check_data_emit+0x3608>
  8e4ec5:	49 8b 4a 10          	mov    rcx,QWORD PTR [r10+0x10]
  8e4ec9:	4c 8b 4c 31 10       	mov    r9,QWORD PTR [rcx+rsi*1+0x10]
  8e4ece:	8b 04 31             	mov    eax,DWORD PTR [rcx+rsi*1]
  8e4ed1:	44 8b 5c 31 08       	mov    r11d,DWORD PTR [rcx+rsi*1+0x8]
  8e4ed6:	49 8d 89 00 00 00 80 	lea    rcx,[r9-0x80000000]
  8e4edd:	48 39 e9             	cmp    rcx,rbp
  8e4ee0:	73 14                	jae    8e4ef6 <check_data_emit+0x3396>
  8e4ee2:	41 8b 8e f0 00 00 00 	mov    ecx,DWORD PTR [r14+0xf0]
  8e4ee9:	41 3b 8e f4 00 00 00 	cmp    ecx,DWORD PTR [r14+0xf4]
  8e4ef0:	0f 84 72 02 00 00    	je     8e5168 <check_data_emit+0x3608>
  8e4ef6:	45 85 db             	test   r11d,r11d
  8e4ef9:	0f 84 62 02 00 00    	je     8e5161 <check_data_emit+0x3601>
  8e4eff:	8b 4c 24 18          	mov    ecx,DWORD PTR [rsp+0x18]
  8e4f03:	41 3b 4e 60          	cmp    ecx,DWORD PTR [r14+0x60]
  8e4f07:	0f 83 54 02 00 00    	jae    8e5161 <check_data_emit+0x3601>
  8e4f0d:	45 3b 9e b8 00 00 00 	cmp    r11d,DWORD PTR [r14+0xb8]
  8e4f14:	0f 83 47 02 00 00    	jae    8e5161 <check_data_emit+0x3601>
  8e4f1a:	49 8b 4e 40          	mov    rcx,QWORD PTR [r14+0x40]
  8e4f1e:	48 83 3c d1 00       	cmp    QWORD PTR [rcx+rdx*8],0x0
  8e4f23:	0f 84 31 02 00 00    	je     8e515a <check_data_emit+0x35fa>
  8e4f29:	4d 8b 56 38          	mov    r10,QWORD PTR [r14+0x38]
  8e4f2d:	48 8d 48 08          	lea    rcx,[rax+0x8]
  8e4f31:	4c 89 f5             	mov    rbp,r14
  8e4f34:	4d 8b 14 d2          	mov    r10,QWORD PTR [r10+rdx*8]
  8e4f38:	4c 39 d1             	cmp    rcx,r10
  8e4f3b:	77 66                	ja     8e4fa3 <check_data_emit+0x3443>
  8e4f3d:	4c 8b 75 50          	mov    r14,QWORD PTR [rbp+0x50]
  8e4f41:	45 8b 34 96          	mov    r14d,DWORD PTR [r14+rdx*4]
  8e4f45:	45 85 f6             	test   r14d,r14d
  8e4f48:	74 59                	je     8e4fa3 <check_data_emit+0x3443>
  8e4f4a:	48 8b 4d 48          	mov    rcx,QWORD PTR [rbp+0x48]
  8e4f4e:	44 03 34 91          	add    r14d,DWORD PTR [rcx+rdx*4]
  8e4f52:	45 39 c6             	cmp    r14d,r8d
  8e4f55:	49 89 ee             	mov    r14,rbp
  8e4f58:	0f 85 fc 01 00 00    	jne    8e515a <check_data_emit+0x35fa>
  8e4f5e:	4d 8b 96 d8 00 00 00 	mov    r10,QWORD PTR [r14+0xd8]
  8e4f65:	49 8b 8e c0 00 00 00 	mov    rcx,QWORD PTR [r14+0xc0]
  8e4f6c:	45 8d 70 ff          	lea    r14d,[r8-0x1]
  8e4f70:	48 8d 2d 19 53 51 01 	lea    rbp,[rip+0x1515319]        # 1dfa290 <link_fixup_kinds>
  8e4f77:	47 0f b6 14 32       	movzx  r10d,BYTE PTR [r10+r14*1]
  8e4f7c:	46 8b 34 b1          	mov    r14d,DWORD PTR [rcx+r14*4]
  8e4f80:	41 83 e2 7f          	and    r10d,0x7f
  8e4f84:	41 c1 e2 04          	shl    r10d,0x4
  8e4f88:	45 0f b6 54 2a 08    	movzx  r10d,BYTE PTR [r10+rbp*1+0x8]
  8e4f8e:	4d 01 f2             	add    r10,r14
  8e4f91:	4c 8b b4 24 30 06 00 	mov    r14,QWORD PTR [rsp+0x630]
  8e4f98:	00 
  8e4f99:	49 39 c2             	cmp    r10,rax
  8e4f9c:	76 18                	jbe    8e4fb6 <check_data_emit+0x3456>
  8e4f9e:	e9 b7 01 00 00       	jmp    8e515a <check_data_emit+0x35fa>
  8e4fa3:	49 89 ee             	mov    r14,rbp
  8e4fa6:	4c 39 d1             	cmp    rcx,r10
  8e4fa9:	0f 87 ab 01 00 00    	ja     8e515a <check_data_emit+0x35fa>
  8e4faf:	49 8b 8e c0 00 00 00 	mov    rcx,QWORD PTR [r14+0xc0]
  8e4fb6:	45 89 c2             	mov    r10d,r8d
  8e4fb9:	42 89 04 91          	mov    DWORD PTR [rcx+r10*4],eax
  8e4fbd:	48 bd 00 00 00 00 ff 	movabs rbp,0xffffffff00000000
  8e4fc4:	ff ff ff 
  8e4fc7:	49 8d 89 00 00 00 80 	lea    rcx,[r9-0x80000000]
  8e4fce:	49 8b 86 c8 00 00 00 	mov    rax,QWORD PTR [r14+0xc8]
  8e4fd5:	46 89 1c 90          	mov    DWORD PTR [rax+r10*4],r11d
  8e4fd9:	49 8b 86 d8 00 00 00 	mov    rax,QWORD PTR [r14+0xd8]
  8e4fe0:	42 c6 04 10 08       	mov    BYTE PTR [rax+r10*1],0x8
  8e4fe5:	49 8b 86 d0 00 00 00 	mov    rax,QWORD PTR [r14+0xd0]
  8e4fec:	46 89 0c 90          	mov    DWORD PTR [rax+r10*4],r9d
  8e4ff0:	48 39 e9             	cmp    rcx,rbp
  8e4ff3:	73 30                	jae    8e5025 <check_data_emit+0x34c5>
  8e4ff5:	49 8b 86 d8 00 00 00 	mov    rax,QWORD PTR [r14+0xd8]
  8e4ffc:	42 c6 04 10 88       	mov    BYTE PTR [rax+r10*1],0x88
  8e5001:	41 8b 86 f0 00 00 00 	mov    eax,DWORD PTR [r14+0xf0]
  8e5008:	49 8b 8e d0 00 00 00 	mov    rcx,QWORD PTR [r14+0xd0]
  8e500f:	42 89 04 91          	mov    DWORD PTR [rcx+r10*4],eax
  8e5013:	49 8b 8e e8 00 00 00 	mov    rcx,QWORD PTR [r14+0xe8]
  8e501a:	4c 89 0c c1          	mov    QWORD PTR [rcx+rax*8],r9
  8e501e:	41 ff 86 f0 00 00 00 	inc    DWORD PTR [r14+0xf0]
  8e5025:	49 8b 46 50          	mov    rax,QWORD PTR [r14+0x50]
  8e5029:	8b 0c 90             	mov    ecx,DWORD PTR [rax+rdx*4]
  8e502c:	85 c9                	test   ecx,ecx
  8e502e:	75 0f                	jne    8e503f <check_data_emit+0x34df>
  8e5030:	49 8b 46 48          	mov    rax,QWORD PTR [r14+0x48]
  8e5034:	44 89 04 90          	mov    DWORD PTR [rax+rdx*4],r8d
  8e5038:	49 8b 46 50          	mov    rax,QWORD PTR [r14+0x50]
  8e503c:	8b 0c 90             	mov    ecx,DWORD PTR [rax+rdx*4]
  8e503f:	ff c1                	inc    ecx
  8e5041:	4c 8b 54 24 68       	mov    r10,QWORD PTR [rsp+0x68]
  8e5046:	89 0c 90             	mov    DWORD PTR [rax+rdx*4],ecx
  8e5049:	41 8b 86 e0 00 00 00 	mov    eax,DWORD PTR [r14+0xe0]
  8e5050:	ff c0                	inc    eax
  8e5052:	41 89 86 e0 00 00 00 	mov    DWORD PTR [r14+0xe0],eax
  8e5059:	45 85 c0             	test   r8d,r8d
  8e505c:	0f 84 1c 01 00 00    	je     8e517e <check_data_emit+0x361e>
  8e5062:	41 8b 4a 18          	mov    ecx,DWORD PTR [r10+0x18]
  8e5066:	48 ff c7             	inc    rdi
  8e5069:	48 83 c6 18          	add    rsi,0x18
  8e506d:	41 89 c0             	mov    r8d,eax
  8e5070:	48 39 cf             	cmp    rdi,rcx
  8e5073:	0f 82 3f fe ff ff    	jb     8e4eb8 <check_data_emit+0x3358>
  8e5079:	e9 c3 fb ff ff       	jmp    8e4c41 <check_data_emit+0x30e1>
  8e507e:	41 ba 01 00 00 00    	mov    r10d,0x1
  8e5084:	e9 b0 00 00 00       	jmp    8e5139 <check_data_emit+0x35d9>
  8e5089:	41 ba 06 00 00 00    	mov    r10d,0x6
  8e508f:	e9 a5 00 00 00       	jmp    8e5139 <check_data_emit+0x35d9>
  8e5094:	41 ba 02 00 00 00    	mov    r10d,0x2
  8e509a:	e9 9a 00 00 00       	jmp    8e5139 <check_data_emit+0x35d9>
  8e509f:	31 c9                	xor    ecx,ecx
  8e50a1:	83 f8 02             	cmp    eax,0x2
  8e50a4:	e9 88 00 00 00       	jmp    8e5131 <check_data_emit+0x35d1>
  8e50a9:	3c 20                	cmp    al,0x20
  8e50ab:	77 2c                	ja     8e50d9 <check_data_emit+0x3579>
  8e50ad:	48 b9 00 ff ff ff ff 	movabs rcx,0x1fffffffffffff00
  8e50b4:	ff ff 1f 
  8e50b7:	41 ba 03 00 00 00    	mov    r10d,0x3
  8e50bd:	48 81 c1 ff 00 00 00 	add    rcx,0xff
  8e50c4:	48 39 cf             	cmp    rdi,rcx
  8e50c7:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
  8e50cc:	77 6b                	ja     8e5139 <check_data_emit+0x35d9>
  8e50ce:	88 41 20             	mov    BYTE PTR [rcx+0x20],al
  8e50d1:	41 ba 01 00 00 00    	mov    r10d,0x1
  8e50d7:	eb 60                	jmp    8e5139 <check_data_emit+0x35d9>
  8e50d9:	41 ba 03 00 00 00    	mov    r10d,0x3
  8e50df:	eb 58                	jmp    8e5139 <check_data_emit+0x35d9>
  8e50e1:	48 8d 3d ca df e4 ff 	lea    rdi,[rip+0xffffffffffe4dfca]        # 7330b2 <pp_string_value.meaning+0x7f813>
  8e50e8:	48 8d 35 29 d6 df ff 	lea    rsi,[rip+0xffffffffffdfd629]        # 6e2718 <pp_string_value.meaning+0x2ee79>
  8e50ef:	48 8d 0d 3d d6 df ff 	lea    rcx,[rip+0xffffffffffdfd63d]        # 6e2733 <pp_string_value.meaning+0x2ee94>
  8e50f6:	ba ce 00 00 00       	mov    edx,0xce
  8e50fb:	c5 f8 77             	vzeroupper
  8e50fe:	e8 8d 88 ee ff       	call   7cd990 <__assert_fail@plt>
  8e5103:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  8e5108:	41 ba 06 00 00 00    	mov    r10d,0x6
  8e510e:	48 c7 00 00 00 00 00 	mov    QWORD PTR [rax],0x0
  8e5115:	eb 22                	jmp    8e5139 <check_data_emit+0x35d9>
  8e5117:	41 ba 05 00 00 00    	mov    r10d,0x5
  8e511d:	eb 1a                	jmp    8e5139 <check_data_emit+0x35d9>
  8e511f:	44 8b 44 24 7c       	mov    r8d,DWORD PTR [rsp+0x7c]
  8e5124:	45 31 d2             	xor    r10d,r10d
  8e5127:	e9 37 f8 ff ff       	jmp    8e4963 <check_data_emit+0x2e03>
  8e512c:	31 c9                	xor    ecx,ecx
  8e512e:	83 f8 05             	cmp    eax,0x5
  8e5131:	0f 94 c1             	sete   cl
  8e5134:	44 8d 54 89 01       	lea    r10d,[rcx+rcx*4+0x1]
  8e5139:	48 8b 84 24 f0 00 00 	mov    rax,QWORD PTR [rsp+0xf0]
  8e5140:	00 
  8e5141:	48 8b 74 24 58       	mov    rsi,QWORD PTR [rsp+0x58]
  8e5146:	45 89 55 00          	mov    DWORD PTR [r13+0x0],r10d
  8e514a:	41 89 45 04          	mov    DWORD PTR [r13+0x4],eax
  8e514e:	8b 46 0c             	mov    eax,DWORD PTR [rsi+0xc]
  8e5151:	41 89 45 08          	mov    DWORD PTR [r13+0x8],eax
  8e5155:	e9 ae ca ff ff       	jmp    8e1c08 <check_data_emit+0xa8>
  8e515a:	b8 03 00 00 00       	mov    eax,0x3
  8e515f:	eb 0c                	jmp    8e516d <check_data_emit+0x360d>
  8e5161:	b8 02 00 00 00       	mov    eax,0x2
  8e5166:	eb 05                	jmp    8e516d <check_data_emit+0x360d>
  8e5168:	b8 01 00 00 00       	mov    eax,0x1
  8e516d:	41 83 be 18 01 00 00 	cmp    DWORD PTR [r14+0x118],0x0
  8e5174:	00 
  8e5175:	75 07                	jne    8e517e <check_data_emit+0x361e>
  8e5177:	41 89 86 18 01 00 00 	mov    DWORD PTR [r14+0x118],eax
  8e517e:	48 8d 3d de e6 db ff 	lea    rdi,[rip+0xffffffffffdbe6de]        # 6a3863 <fuzz_comment_end+0x40df2>
  8e5185:	48 8d 35 43 bd d3 ff 	lea    rsi,[rip+0xffffffffffd3bd43]        # 620ecf <foreign_touch.flags+0x4ada>
  8e518c:	48 8d 0d 46 d8 e0 ff 	lea    rcx,[rip+0xffffffffffe0d846]        # 6f29d9 <pp_string_value.meaning+0x3f13a>
  8e5193:	ba d6 03 00 00       	mov    edx,0x3d6
  8e5198:	c5 f8 77             	vzeroupper
  8e519b:	e8 f0 87 ee ff       	call   7cd990 <__assert_fail@plt>
  8e51a0:	b8 03 00 00 00       	mov    eax,0x3
  8e51a5:	eb 05                	jmp    8e51ac <check_data_emit+0x364c>
  8e51a7:	b8 02 00 00 00       	mov    eax,0x2
  8e51ac:	41 83 be 18 01 00 00 	cmp    DWORD PTR [r14+0x118],0x0
  8e51b3:	00 
  8e51b4:	75 0e                	jne    8e51c4 <check_data_emit+0x3664>
  8e51b6:	48 8b 8c 24 30 06 00 	mov    rcx,QWORD PTR [rsp+0x630]
  8e51bd:	00 
  8e51be:	89 81 18 01 00 00    	mov    DWORD PTR [rcx+0x118],eax
  8e51c4:	48 8d 3d 78 fc d1 ff 	lea    rdi,[rip+0xffffffffffd1fc78]        # 604e43 <parse_test_openers+0x389a6>
  8e51cb:	48 8d 35 fd bc d3 ff 	lea    rsi,[rip+0xffffffffffd3bcfd]        # 620ecf <foreign_touch.flags+0x4ada>
  8e51d2:	48 8d 0d 00 d8 e0 ff 	lea    rcx,[rip+0xffffffffffe0d800]        # 6f29d9 <pp_string_value.meaning+0x3f13a>
  8e51d9:	ba d0 03 00 00       	mov    edx,0x3d0
  8e51de:	c5 f8 77             	vzeroupper
  8e51e1:	e8 aa 87 ee ff       	call   7cd990 <__assert_fail@plt>
  8e51e6:	48 8d 3d 16 df ce ff 	lea    rdi,[rip+0xffffffffffcedf16]        # 5d3103 <parse_test_openers+0x6c66>
  8e51ed:	48 8d 35 db bc d3 ff 	lea    rsi,[rip+0xffffffffffd3bcdb]        # 620ecf <foreign_touch.flags+0x4ada>
  8e51f4:	48 8d 0d f8 1d e4 ff 	lea    rcx,[rip+0xffffffffffe41df8]        # 726ff3 <pp_string_value.meaning+0x73754>
  8e51fb:	ba bc 01 00 00       	mov    edx,0x1bc
  8e5200:	c5 f8 77             	vzeroupper
  8e5203:	e8 88 87 ee ff       	call   7cd990 <__assert_fail@plt>
  8e5208:	48 8d 3d f4 de ce ff 	lea    rdi,[rip+0xffffffffffcedef4]        # 5d3103 <parse_test_openers+0x6c66>
  8e520f:	48 8d 35 b9 bc d3 ff 	lea    rsi,[rip+0xffffffffffd3bcb9]        # 620ecf <foreign_touch.flags+0x4ada>
  8e5216:	48 8d 0d d6 1d e4 ff 	lea    rcx,[rip+0xffffffffffe41dd6]        # 726ff3 <pp_string_value.meaning+0x73754>
  8e521d:	ba e7 01 00 00       	mov    edx,0x1e7
  8e5222:	c5 f8 77             	vzeroupper
  8e5225:	e8 66 87 ee ff       	call   7cd990 <__assert_fail@plt>
