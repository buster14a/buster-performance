
candidate1.o:     file format elf64-x86-64


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
  30:	dd d0                	fst    %st(0)
  32:	48 8b c8             	mov    %rax,%rcx
  35:	d9 c8                	fxch   %st(0)
  37:	db 39                	fstpt  (%rcx)
  39:	31 c9                	xor    %ecx,%ecx
  3b:	eb 36                	jmp    73 <affine+0x73>
  3d:	db 28                	fldt   (%rax)
  3f:	dd d0                	fst    %st(0)
  41:	d9 c8                	fxch   %st(0)
  43:	d9 05 00 00 00 00    	flds   0x0(%rip)        # 49 <affine+0x49>
			45: R_X86_64_PC32	.Lbuster_literal_0-0x4
  49:	de c9                	fmulp  %st,%st(1)
  4b:	dd d0                	fst    %st(0)
  4d:	8b 14 8f             	mov    (%rdi,%rcx,4),%edx
  50:	44 8b da             	mov    %edx,%r11d
  53:	44 89 9c 24 88 00 00 	mov    %r11d,0x88(%rsp)
  5a:	00 
  5b:	db 84 24 88 00 00 00 	fildl  0x88(%rsp)
  62:	dd d0                	fst    %st(0)
  64:	d9 c9                	fxch   %st(1)
  66:	d9 c9                	fxch   %st(1)
  68:	de c1                	faddp  %st,%st(1)
  6a:	dd d0                	fst    %st(0)
  6c:	d9 c8                	fxch   %st(0)
  6e:	db 38                	fstpt  (%rax)
  70:	83 c1 01             	add    $0x1,%ecx
  73:	3b ce                	cmp    %esi,%ecx
  75:	7c c6                	jl     3d <affine+0x3d>
  77:	db 28                	fldt   (%rax)
  79:	db 7c 24 70          	fstpt  0x70(%rsp)
  7d:	db 6c 24 70          	fldt   0x70(%rsp)
  81:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  88:	c3                   	ret
  89:	cc                   	int3
  8a:	cc                   	int3
  8b:	cc                   	int3
  8c:	cc                   	int3
  8d:	cc                   	int3
  8e:	cc                   	int3
  8f:	cc                   	int3

0000000000000090 <sum>:
  90:	48 8d 44 24 88       	lea    -0x78(%rsp),%rax
  95:	48 c7 44 24 88 00 00 	movq   $0x0,-0x78(%rsp)
  9c:	00 00 
  9e:	48 c7 44 24 90 00 00 	movq   $0x0,-0x70(%rsp)
  a5:	00 00 
  a7:	31 c9                	xor    %ecx,%ecx
  a9:	44 8b d9             	mov    %ecx,%r11d
  ac:	44 89 5c 24 f0       	mov    %r11d,-0x10(%rsp)
  b1:	db 44 24 f0          	fildl  -0x10(%rsp)
  b5:	dd d0                	fst    %st(0)
  b7:	48 8b c8             	mov    %rax,%rcx
  ba:	d9 c8                	fxch   %st(0)
  bc:	db 39                	fstpt  (%rcx)
  be:	31 c9                	xor    %ecx,%ecx
  c0:	eb 21                	jmp    e3 <sum+0x53>
  c2:	db 28                	fldt   (%rax)
  c4:	dd d0                	fst    %st(0)
  c6:	48 8b d1             	mov    %rcx,%rdx
  c9:	48 c1 e2 04          	shl    $0x4,%rdx
  cd:	48 03 d7             	add    %rdi,%rdx
  d0:	db 2a                	fldt   (%rdx)
  d2:	dd d0                	fst    %st(0)
  d4:	d9 c9                	fxch   %st(1)
  d6:	d9 c9                	fxch   %st(1)
  d8:	de c1                	faddp  %st,%st(1)
  da:	dd d0                	fst    %st(0)
  dc:	d9 c8                	fxch   %st(0)
  de:	db 38                	fstpt  (%rax)
  e0:	83 c1 01             	add    $0x1,%ecx
  e3:	3b ce                	cmp    %esi,%ecx
  e5:	7c db                	jl     c2 <sum+0x32>
  e7:	db 28                	fldt   (%rax)
  e9:	db 7c 24 d8          	fstpt  -0x28(%rsp)
  ed:	db 6c 24 d8          	fldt   -0x28(%rsp)
  f1:	c3                   	ret
  f2:	cc                   	int3
  f3:	cc                   	int3
  f4:	cc                   	int3
  f5:	cc                   	int3
  f6:	cc                   	int3
  f7:	cc                   	int3
  f8:	cc                   	int3
  f9:	cc                   	int3
  fa:	cc                   	int3
  fb:	cc                   	int3
  fc:	cc                   	int3
  fd:	cc                   	int3
  fe:	cc                   	int3
  ff:	cc                   	int3

0000000000000100 <dot>:
 100:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
 107:	48 8d 04 24          	lea    (%rsp),%rax
 10b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
 112:	00 
 113:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
 11a:	00 00 
 11c:	31 c9                	xor    %ecx,%ecx
 11e:	44 8b d9             	mov    %ecx,%r11d
 121:	44 89 9c 24 88 00 00 	mov    %r11d,0x88(%rsp)
 128:	00 
 129:	db 84 24 88 00 00 00 	fildl  0x88(%rsp)
 130:	dd d0                	fst    %st(0)
 132:	48 8b c8             	mov    %rax,%rcx
 135:	d9 c8                	fxch   %st(0)
 137:	db 39                	fstpt  (%rcx)
 139:	31 c9                	xor    %ecx,%ecx
 13b:	eb 39                	jmp    176 <dot+0x76>
 13d:	db 28                	fldt   (%rax)
 13f:	dd d0                	fst    %st(0)
 141:	4c 8b c1             	mov    %rcx,%r8
 144:	49 c1 e0 04          	shl    $0x4,%r8
 148:	4c 03 c7             	add    %rdi,%r8
 14b:	41 db 28             	fldt   (%r8)
 14e:	dd d0                	fst    %st(0)
 150:	4c 8b c1             	mov    %rcx,%r8
 153:	49 c1 e0 04          	shl    $0x4,%r8
 157:	4c 03 c6             	add    %rsi,%r8
 15a:	41 db 28             	fldt   (%r8)
 15d:	dd d0                	fst    %st(0)
 15f:	d9 c9                	fxch   %st(1)
 161:	d9 c9                	fxch   %st(1)
 163:	de c9                	fmulp  %st,%st(1)
 165:	dd d0                	fst    %st(0)
 167:	d9 c9                	fxch   %st(1)
 169:	d9 c9                	fxch   %st(1)
 16b:	de c1                	faddp  %st,%st(1)
 16d:	dd d0                	fst    %st(0)
 16f:	d9 c8                	fxch   %st(0)
 171:	db 38                	fstpt  (%rax)
 173:	83 c1 01             	add    $0x1,%ecx
 176:	3b ca                	cmp    %edx,%ecx
 178:	7c c3                	jl     13d <dot+0x3d>
 17a:	db 28                	fldt   (%rax)
 17c:	db 7c 24 70          	fstpt  0x70(%rsp)
 180:	db 6c 24 70          	fldt   0x70(%rsp)
 184:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
 18b:	c3                   	ret
