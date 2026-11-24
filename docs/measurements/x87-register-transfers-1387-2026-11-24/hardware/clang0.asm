
clang0.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <affine>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   8:	89 75 f4             	mov    %esi,-0xc(%rbp)
   b:	d9 ee                	fldz
   d:	db 7d e0             	fstpt  -0x20(%rbp)
  10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  17:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  1d:	7d 2c                	jge    4b <affine+0x4b>
  1f:	db 6d e0             	fldt   -0x20(%rbp)
  22:	d9 05 00 00 00 00    	flds   0x0(%rip)        # 28 <affine+0x28>
			24: R_X86_64_PC32	.LCPI0_0-0x4
  28:	de c9                	fmulp  %st,%st(1)
  2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2e:	48 63 4d dc          	movslq -0x24(%rbp),%rcx
  32:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  35:	89 45 d8             	mov    %eax,-0x28(%rbp)
  38:	db 45 d8             	fildl  -0x28(%rbp)
  3b:	de c1                	faddp  %st,%st(1)
  3d:	db 7d e0             	fstpt  -0x20(%rbp)
  40:	8b 45 dc             	mov    -0x24(%rbp),%eax
  43:	83 c0 01             	add    $0x1,%eax
  46:	89 45 dc             	mov    %eax,-0x24(%rbp)
  49:	eb cc                	jmp    17 <affine+0x17>
  4b:	db 6d e0             	fldt   -0x20(%rbp)
  4e:	5d                   	pop    %rbp
  4f:	c3                   	ret

0000000000000050 <sum>:
  50:	55                   	push   %rbp
  51:	48 89 e5             	mov    %rsp,%rbp
  54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  58:	89 75 f4             	mov    %esi,-0xc(%rbp)
  5b:	d9 ee                	fldz
  5d:	db 7d e0             	fstpt  -0x20(%rbp)
  60:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  67:	8b 45 dc             	mov    -0x24(%rbp),%eax
  6a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  6d:	7d 22                	jge    91 <sum+0x41>
  6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  73:	48 63 4d dc          	movslq -0x24(%rbp),%rcx
  77:	48 c1 e1 04          	shl    $0x4,%rcx
  7b:	db 2c 08             	fldt   (%rax,%rcx,1)
  7e:	db 6d e0             	fldt   -0x20(%rbp)
  81:	de c1                	faddp  %st,%st(1)
  83:	db 7d e0             	fstpt  -0x20(%rbp)
  86:	8b 45 dc             	mov    -0x24(%rbp),%eax
  89:	83 c0 01             	add    $0x1,%eax
  8c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8f:	eb d6                	jmp    67 <sum+0x17>
  91:	db 6d e0             	fldt   -0x20(%rbp)
  94:	5d                   	pop    %rbp
  95:	c3                   	ret
  96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  9d:	00 00 00 

00000000000000a0 <dot>:
  a0:	55                   	push   %rbp
  a1:	48 89 e5             	mov    %rsp,%rbp
  a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  ac:	89 55 ec             	mov    %edx,-0x14(%rbp)
  af:	d9 ee                	fldz
  b1:	db 7d d0             	fstpt  -0x30(%rbp)
  b4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  bb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  be:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  c1:	7d 2b                	jge    ee <dot+0x4e>
  c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  c7:	48 63 4d cc          	movslq -0x34(%rbp),%rcx
  cb:	48 c1 e1 04          	shl    $0x4,%rcx
  cf:	db 2c 08             	fldt   (%rax,%rcx,1)
  d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  d6:	db 2c 08             	fldt   (%rax,%rcx,1)
  d9:	de c9                	fmulp  %st,%st(1)
  db:	db 6d d0             	fldt   -0x30(%rbp)
  de:	de c1                	faddp  %st,%st(1)
  e0:	db 7d d0             	fstpt  -0x30(%rbp)
  e3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  e6:	83 c0 01             	add    $0x1,%eax
  e9:	89 45 cc             	mov    %eax,-0x34(%rbp)
  ec:	eb cd                	jmp    bb <dot+0x1b>
  ee:	db 6d d0             	fldt   -0x30(%rbp)
  f1:	5d                   	pop    %rbp
  f2:	c3                   	ret
