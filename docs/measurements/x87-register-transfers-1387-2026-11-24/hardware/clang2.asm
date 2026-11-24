
clang2.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <affine>:
   0:	d9 ee                	fldz
   2:	85 f6                	test   %esi,%esi
   4:	0f 8e 9f 00 00 00    	jle    a9 <affine+0xa9>
   a:	dd d8                	fstp   %st(0)
   c:	89 f1                	mov    %esi,%ecx
   e:	89 c8                	mov    %ecx,%eax
  10:	83 e0 03             	and    $0x3,%eax
  13:	d9 ee                	fldz
  15:	83 fe 04             	cmp    $0x4,%esi
  18:	73 04                	jae    1e <affine+0x1e>
  1a:	31 d2                	xor    %edx,%edx
  1c:	eb 5f                	jmp    7d <affine+0x7d>
  1e:	dd d8                	fstp   %st(0)
  20:	81 e1 fc ff ff 7f    	and    $0x7ffffffc,%ecx
  26:	d9 ee                	fldz
  28:	31 d2                	xor    %edx,%edx
  2a:	d9 05 00 00 00 00    	flds   0x0(%rip)        # 30 <affine+0x30>
			2c: R_X86_64_PC32	.LCPI0_0-0x4
  30:	dc c9                	fmul   %st,%st(1)
  32:	8b 34 97             	mov    (%rdi,%rdx,4),%esi
  35:	44 8b 44 97 04       	mov    0x4(%rdi,%rdx,4),%r8d
  3a:	89 74 24 f0          	mov    %esi,-0x10(%rsp)
  3e:	d9 c9                	fxch   %st(1)
  40:	da 44 24 f0          	fiaddl -0x10(%rsp)
  44:	d8 c9                	fmul   %st(1),%st
  46:	44 89 44 24 fc       	mov    %r8d,-0x4(%rsp)
  4b:	da 44 24 fc          	fiaddl -0x4(%rsp)
  4f:	d8 c9                	fmul   %st(1),%st
  51:	8b 74 97 08          	mov    0x8(%rdi,%rdx,4),%esi
  55:	89 74 24 f8          	mov    %esi,-0x8(%rsp)
  59:	da 44 24 f8          	fiaddl -0x8(%rsp)
  5d:	d8 c9                	fmul   %st(1),%st
  5f:	8b 74 97 0c          	mov    0xc(%rdi,%rdx,4),%esi
  63:	89 74 24 f4          	mov    %esi,-0xc(%rsp)
  67:	da 44 24 f4          	fiaddl -0xc(%rsp)
  6b:	48 83 c2 04          	add    $0x4,%rdx
  6f:	48 39 d1             	cmp    %rdx,%rcx
  72:	d9 c9                	fxch   %st(1)
  74:	75 ba                	jne    30 <affine+0x30>
  76:	dd d8                	fstp   %st(0)
  78:	48 85 c0             	test   %rax,%rax
  7b:	74 2c                	je     a9 <affine+0xa9>
  7d:	48 8d 0c 97          	lea    (%rdi,%rdx,4),%rcx
  81:	31 d2                	xor    %edx,%edx
  83:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  8a:	84 00 00 00 00 00 
  90:	d8 0d 00 00 00 00    	fmuls  0x0(%rip)        # 96 <affine+0x96>
			92: R_X86_64_PC32	.LCPI0_0-0x4
  96:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
  99:	89 74 24 ec          	mov    %esi,-0x14(%rsp)
  9d:	da 44 24 ec          	fiaddl -0x14(%rsp)
  a1:	48 ff c2             	inc    %rdx
  a4:	48 39 d0             	cmp    %rdx,%rax
  a7:	75 e7                	jne    90 <affine+0x90>
  a9:	c3                   	ret
  aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000000b0 <sum>:
  b0:	d9 ee                	fldz
  b2:	85 f6                	test   %esi,%esi
  b4:	7e 78                	jle    12e <sum+0x7e>
  b6:	dd d8                	fstp   %st(0)
  b8:	89 f2                	mov    %esi,%edx
  ba:	89 d0                	mov    %edx,%eax
  bc:	83 e0 03             	and    $0x3,%eax
  bf:	d9 ee                	fldz
  c1:	83 fe 04             	cmp    $0x4,%esi
  c4:	73 04                	jae    ca <sum+0x1a>
  c6:	31 c9                	xor    %ecx,%ecx
  c8:	eb 3b                	jmp    105 <sum+0x55>
  ca:	dd d8                	fstp   %st(0)
  cc:	81 e2 fc ff ff 7f    	and    $0x7ffffffc,%edx
  d2:	48 8d 77 30          	lea    0x30(%rdi),%rsi
  d6:	d9 ee                	fldz
  d8:	31 c9                	xor    %ecx,%ecx
  da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  e0:	db 6e d0             	fldt   -0x30(%rsi)
  e3:	de c1                	faddp  %st,%st(1)
  e5:	db 6e e0             	fldt   -0x20(%rsi)
  e8:	de c1                	faddp  %st,%st(1)
  ea:	db 6e f0             	fldt   -0x10(%rsi)
  ed:	de c1                	faddp  %st,%st(1)
  ef:	db 2e                	fldt   (%rsi)
  f1:	de c1                	faddp  %st,%st(1)
  f3:	48 83 c1 04          	add    $0x4,%rcx
  f7:	48 83 c6 40          	add    $0x40,%rsi
  fb:	48 39 ca             	cmp    %rcx,%rdx
  fe:	75 e0                	jne    e0 <sum+0x30>
 100:	48 85 c0             	test   %rax,%rax
 103:	74 29                	je     12e <sum+0x7e>
 105:	48 c1 e1 04          	shl    $0x4,%rcx
 109:	48 01 cf             	add    %rcx,%rdi
 10c:	c1 e0 04             	shl    $0x4,%eax
 10f:	31 c9                	xor    %ecx,%ecx
 111:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 118:	0f 1f 84 00 00 00 00 
 11f:	00 
 120:	db 2c 0f             	fldt   (%rdi,%rcx,1)
 123:	de c1                	faddp  %st,%st(1)
 125:	48 83 c1 10          	add    $0x10,%rcx
 129:	48 39 c8             	cmp    %rcx,%rax
 12c:	75 f2                	jne    120 <sum+0x70>
 12e:	c3                   	ret
 12f:	90                   	nop

0000000000000130 <dot>:
 130:	d9 ee                	fldz
 132:	85 d2                	test   %edx,%edx
 134:	7e 64                	jle    19a <dot+0x6a>
 136:	dd d8                	fstp   %st(0)
 138:	d9 ee                	fldz
 13a:	83 fa 01             	cmp    $0x1,%edx
 13d:	75 04                	jne    143 <dot+0x13>
 13f:	31 c0                	xor    %eax,%eax
 141:	eb 49                	jmp    18c <dot+0x5c>
 143:	dd d8                	fstp   %st(0)
 145:	89 d1                	mov    %edx,%ecx
 147:	89 ca                	mov    %ecx,%edx
 149:	81 e2 fe ff ff 7f    	and    $0x7ffffffe,%edx
 14f:	d9 ee                	fldz
 151:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 157:	31 c0                	xor    %eax,%eax
 159:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 160:	42 db 6c 07 f0       	fldt   -0x10(%rdi,%r8,1)
 165:	42 db 6c 06 f0       	fldt   -0x10(%rsi,%r8,1)
 16a:	de c9                	fmulp  %st,%st(1)
 16c:	de c1                	faddp  %st,%st(1)
 16e:	42 db 2c 07          	fldt   (%rdi,%r8,1)
 172:	42 db 2c 06          	fldt   (%rsi,%r8,1)
 176:	de c9                	fmulp  %st,%st(1)
 178:	de c1                	faddp  %st,%st(1)
 17a:	48 83 c0 02          	add    $0x2,%rax
 17e:	49 83 c0 20          	add    $0x20,%r8
 182:	48 39 c2             	cmp    %rax,%rdx
 185:	75 d9                	jne    160 <dot+0x30>
 187:	f6 c1 01             	test   $0x1,%cl
 18a:	74 0e                	je     19a <dot+0x6a>
 18c:	48 c1 e0 04          	shl    $0x4,%rax
 190:	db 2c 07             	fldt   (%rdi,%rax,1)
 193:	db 2c 06             	fldt   (%rsi,%rax,1)
 196:	de c9                	fmulp  %st,%st(1)
 198:	de c1                	faddp  %st,%st(1)
 19a:	c3                   	ret
