
base1.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <affine>:
   0:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
   7:	48 8d 04 24          	lea    (%rsp),%rax
   b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  12:	00 
  13:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  1a:	00 00 
  1c:	31 c9                	xor    %ecx,%ecx
  1e:	44 8b d9             	mov    %ecx,%r11d
  21:	44 89 9c 24 88 00 00 	mov    %r11d,0x88(%rsp)
  28:	00 
  29:	db 84 24 88 00 00 00 	fildl  0x88(%rsp)
  30:	db 7c 24 10          	fstpt  0x10(%rsp)
  34:	48 8b c8             	mov    %rax,%rcx
  37:	db 6c 24 10          	fldt   0x10(%rsp)
  3b:	db 39                	fstpt  (%rcx)
  3d:	31 c9                	xor    %ecx,%ecx
  3f:	eb 42                	jmp    83 <affine+0x83>
  41:	db 28                	fldt   (%rax)
  43:	db 7c 24 20          	fstpt  0x20(%rsp)
  47:	db 6c 24 20          	fldt   0x20(%rsp)
  4b:	d9 05 00 00 00 00    	flds   0x0(%rip)        # 51 <affine+0x51>
			4d: R_X86_64_PC32	.Lbuster_literal_0-0x4
  51:	de c9                	fmulp  %st,%st(1)
  53:	db 7c 24 40          	fstpt  0x40(%rsp)
  57:	8b 14 8f             	mov    (%rdi,%rcx,4),%edx
  5a:	44 8b da             	mov    %edx,%r11d
  5d:	44 89 9c 24 88 00 00 	mov    %r11d,0x88(%rsp)
  64:	00 
  65:	db 84 24 88 00 00 00 	fildl  0x88(%rsp)
  6c:	db 7c 24 50          	fstpt  0x50(%rsp)
  70:	db 6c 24 40          	fldt   0x40(%rsp)
  74:	db 6c 24 50          	fldt   0x50(%rsp)
  78:	de c1                	faddp  %st,%st(1)
  7a:	d9 c0                	fld    %st(0)
  7c:	dd d8                	fstp   %st(0)
  7e:	db 38                	fstpt  (%rax)
  80:	83 c1 01             	add    $0x1,%ecx
  83:	3b ce                	cmp    %esi,%ecx
  85:	7c ba                	jl     41 <affine+0x41>
  87:	db 28                	fldt   (%rax)
  89:	db 7c 24 70          	fstpt  0x70(%rsp)
  8d:	db 6c 24 70          	fldt   0x70(%rsp)
  91:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  98:	c3                   	ret
  99:	cc                   	int3
  9a:	cc                   	int3
  9b:	cc                   	int3
  9c:	cc                   	int3
  9d:	cc                   	int3
  9e:	cc                   	int3
  9f:	cc                   	int3

00000000000000a0 <sum>:
  a0:	48 8d 44 24 88       	lea    -0x78(%rsp),%rax
  a5:	48 c7 44 24 88 00 00 	movq   $0x0,-0x78(%rsp)
  ac:	00 00 
  ae:	48 c7 44 24 90 00 00 	movq   $0x0,-0x70(%rsp)
  b5:	00 00 
  b7:	31 c9                	xor    %ecx,%ecx
  b9:	44 8b d9             	mov    %ecx,%r11d
  bc:	44 89 5c 24 f0       	mov    %r11d,-0x10(%rsp)
  c1:	db 44 24 f0          	fildl  -0x10(%rsp)
  c5:	db 7c 24 98          	fstpt  -0x68(%rsp)
  c9:	48 8b c8             	mov    %rax,%rcx
  cc:	db 6c 24 98          	fldt   -0x68(%rsp)
  d0:	db 39                	fstpt  (%rcx)
  d2:	31 c9                	xor    %ecx,%ecx
  d4:	eb 29                	jmp    ff <sum+0x5f>
  d6:	db 28                	fldt   (%rax)
  d8:	db 7c 24 a8          	fstpt  -0x58(%rsp)
  dc:	48 8b d1             	mov    %rcx,%rdx
  df:	48 c1 e2 04          	shl    $0x4,%rdx
  e3:	48 03 d7             	add    %rdi,%rdx
  e6:	db 2a                	fldt   (%rdx)
  e8:	db 7c 24 b8          	fstpt  -0x48(%rsp)
  ec:	db 6c 24 a8          	fldt   -0x58(%rsp)
  f0:	db 6c 24 b8          	fldt   -0x48(%rsp)
  f4:	de c1                	faddp  %st,%st(1)
  f6:	d9 c0                	fld    %st(0)
  f8:	dd d8                	fstp   %st(0)
  fa:	db 38                	fstpt  (%rax)
  fc:	83 c1 01             	add    $0x1,%ecx
  ff:	3b ce                	cmp    %esi,%ecx
 101:	7c d3                	jl     d6 <sum+0x36>
 103:	db 28                	fldt   (%rax)
 105:	db 7c 24 d8          	fstpt  -0x28(%rsp)
 109:	db 6c 24 d8          	fldt   -0x28(%rsp)
 10d:	c3                   	ret
 10e:	cc                   	int3
 10f:	cc                   	int3

0000000000000110 <dot>:
 110:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
 117:	48 8d 04 24          	lea    (%rsp),%rax
 11b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
 122:	00 
 123:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
 12a:	00 00 
 12c:	31 c9                	xor    %ecx,%ecx
 12e:	44 8b d9             	mov    %ecx,%r11d
 131:	44 89 9c 24 88 00 00 	mov    %r11d,0x88(%rsp)
 138:	00 
 139:	db 84 24 88 00 00 00 	fildl  0x88(%rsp)
 140:	db 7c 24 10          	fstpt  0x10(%rsp)
 144:	48 8b c8             	mov    %rax,%rcx
 147:	db 6c 24 10          	fldt   0x10(%rsp)
 14b:	db 39                	fstpt  (%rcx)
 14d:	31 c9                	xor    %ecx,%ecx
 14f:	eb 49                	jmp    19a <dot+0x8a>
 151:	db 28                	fldt   (%rax)
 153:	db 7c 24 20          	fstpt  0x20(%rsp)
 157:	4c 8b c1             	mov    %rcx,%r8
 15a:	49 c1 e0 04          	shl    $0x4,%r8
 15e:	4c 03 c7             	add    %rdi,%r8
 161:	41 db 28             	fldt   (%r8)
 164:	db 7c 24 30          	fstpt  0x30(%rsp)
 168:	4c 8b c1             	mov    %rcx,%r8
 16b:	49 c1 e0 04          	shl    $0x4,%r8
 16f:	4c 03 c6             	add    %rsi,%r8
 172:	41 db 28             	fldt   (%r8)
 175:	db 7c 24 40          	fstpt  0x40(%rsp)
 179:	db 6c 24 30          	fldt   0x30(%rsp)
 17d:	db 6c 24 40          	fldt   0x40(%rsp)
 181:	de c9                	fmulp  %st,%st(1)
 183:	db 7c 24 50          	fstpt  0x50(%rsp)
 187:	db 6c 24 20          	fldt   0x20(%rsp)
 18b:	db 6c 24 50          	fldt   0x50(%rsp)
 18f:	de c1                	faddp  %st,%st(1)
 191:	d9 c0                	fld    %st(0)
 193:	dd d8                	fstp   %st(0)
 195:	db 38                	fstpt  (%rax)
 197:	83 c1 01             	add    $0x1,%ecx
 19a:	3b ca                	cmp    %edx,%ecx
 19c:	7c b3                	jl     151 <dot+0x41>
 19e:	db 28                	fldt   (%rax)
 1a0:	db 7c 24 70          	fstpt  0x70(%rsp)
 1a4:	db 6c 24 70          	fldt   0x70(%rsp)
 1a8:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
 1af:	c3                   	ret
