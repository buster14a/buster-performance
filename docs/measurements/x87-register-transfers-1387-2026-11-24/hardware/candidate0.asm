
candidate0.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <affine>:
   0:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
   7:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
   e:	00 
   f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  16:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  1d:	00 
  1e:	48 83 c0 08          	add    $0x8,%rax
  22:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  29:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  30:	00 
  31:	31 c9                	xor    %ecx,%ecx
  33:	89 4c 24 f8          	mov    %ecx,-0x8(%rsp)
  37:	db 44 24 f8          	fildl  -0x8(%rsp)
  3b:	dd d0                	fst    %st(0)
  3d:	d9 c8                	fxch   %st(0)
  3f:	db 38                	fstpt  (%rax)
  41:	45 31 c0             	xor    %r8d,%r8d
  44:	44 3b c6             	cmp    %esi,%r8d
  47:	7d 43                	jge    8c <affine+0x8c>
  49:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
  50:	dd d0                	fst    %st(0)
  52:	d9 c8                	fxch   %st(0)
  54:	d9 05 00 00 00 00    	flds   0x0(%rip)        # 5a <affine+0x5a>
			56: R_X86_64_PC32	.Lbuster_literal_0-0x4
  5a:	de c9                	fmulp  %st,%st(1)
  5c:	dd d0                	fst    %st(0)
  5e:	48 8b cf             	mov    %rdi,%rcx
  61:	49 63 d0             	movslq %r8d,%rdx
  64:	8b 0c 91             	mov    (%rcx,%rdx,4),%ecx
  67:	89 4c 24 f8          	mov    %ecx,-0x8(%rsp)
  6b:	db 44 24 f8          	fildl  -0x8(%rsp)
  6f:	dd d0                	fst    %st(0)
  71:	d9 c9                	fxch   %st(1)
  73:	d9 c9                	fxch   %st(1)
  75:	de c1                	faddp  %st,%st(1)
  77:	dd d0                	fst    %st(0)
  79:	d9 c8                	fxch   %st(0)
  7b:	db bc 24 f0 00 00 00 	fstpt  0xf0(%rsp)
  82:	41 8b c0             	mov    %r8d,%eax
  85:	ff c0                	inc    %eax
  87:	41 89 c0             	mov    %eax,%r8d
  8a:	eb b8                	jmp    44 <affine+0x44>
  8c:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
  93:	db 3c 24             	fstpt  (%rsp)
  96:	db 2c 24             	fldt   (%rsp)
  99:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  a0:	c3                   	ret
  a1:	cc                   	int3
  a2:	cc                   	int3
  a3:	cc                   	int3
  a4:	cc                   	int3
  a5:	cc                   	int3
  a6:	cc                   	int3
  a7:	cc                   	int3
  a8:	cc                   	int3
  a9:	cc                   	int3
  aa:	cc                   	int3
  ab:	cc                   	int3
  ac:	cc                   	int3
  ad:	cc                   	int3
  ae:	cc                   	int3
  af:	cc                   	int3

00000000000000b0 <sum>:
  b0:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  b7:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  be:	00 
  bf:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  c6:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  cd:	00 
  ce:	48 83 c0 08          	add    $0x8,%rax
  d2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  d9:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  e0:	00 
  e1:	31 c9                	xor    %ecx,%ecx
  e3:	89 4c 24 f8          	mov    %ecx,-0x8(%rsp)
  e7:	db 44 24 f8          	fildl  -0x8(%rsp)
  eb:	dd d0                	fst    %st(0)
  ed:	d9 c8                	fxch   %st(0)
  ef:	db 38                	fstpt  (%rax)
  f1:	45 31 c0             	xor    %r8d,%r8d
  f4:	44 3b c6             	cmp    %esi,%r8d
  f7:	7d 35                	jge    12e <sum+0x7e>
  f9:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
 100:	dd d0                	fst    %st(0)
 102:	48 8b cf             	mov    %rdi,%rcx
 105:	49 63 d0             	movslq %r8d,%rdx
 108:	48 6b d2 10          	imul   $0x10,%rdx,%rdx
 10c:	48 03 ca             	add    %rdx,%rcx
 10f:	db 29                	fldt   (%rcx)
 111:	dd d0                	fst    %st(0)
 113:	d9 c9                	fxch   %st(1)
 115:	d9 c9                	fxch   %st(1)
 117:	de c1                	faddp  %st,%st(1)
 119:	dd d0                	fst    %st(0)
 11b:	d9 c8                	fxch   %st(0)
 11d:	db bc 24 f0 00 00 00 	fstpt  0xf0(%rsp)
 124:	41 8b c0             	mov    %r8d,%eax
 127:	ff c0                	inc    %eax
 129:	41 89 c0             	mov    %eax,%r8d
 12c:	eb c6                	jmp    f4 <sum+0x44>
 12e:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
 135:	db 3c 24             	fstpt  (%rsp)
 138:	db 2c 24             	fldt   (%rsp)
 13b:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
 142:	c3                   	ret
 143:	cc                   	int3
 144:	cc                   	int3
 145:	cc                   	int3
 146:	cc                   	int3
 147:	cc                   	int3
 148:	cc                   	int3
 149:	cc                   	int3
 14a:	cc                   	int3
 14b:	cc                   	int3
 14c:	cc                   	int3
 14d:	cc                   	int3
 14e:	cc                   	int3
 14f:	cc                   	int3

0000000000000150 <dot>:
 150:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
 157:	4c 8b ce             	mov    %rsi,%r9
 15a:	4c 8b d2             	mov    %rdx,%r10
 15d:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
 164:	00 
 165:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
 16c:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
 173:	00 
 174:	48 83 c0 08          	add    $0x8,%rax
 178:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
 17f:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
 186:	00 
 187:	31 c9                	xor    %ecx,%ecx
 189:	89 4c 24 f8          	mov    %ecx,-0x8(%rsp)
 18d:	db 44 24 f8          	fildl  -0x8(%rsp)
 191:	dd d0                	fst    %st(0)
 193:	d9 c8                	fxch   %st(0)
 195:	db 38                	fstpt  (%rax)
 197:	45 31 c0             	xor    %r8d,%r8d
 19a:	45 3b c2             	cmp    %r10d,%r8d
 19d:	7d 4e                	jge    1ed <dot+0x9d>
 19f:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
 1a6:	dd d0                	fst    %st(0)
 1a8:	48 8b cf             	mov    %rdi,%rcx
 1ab:	49 63 d0             	movslq %r8d,%rdx
 1ae:	48 6b d2 10          	imul   $0x10,%rdx,%rdx
 1b2:	48 03 ca             	add    %rdx,%rcx
 1b5:	db 29                	fldt   (%rcx)
 1b7:	dd d0                	fst    %st(0)
 1b9:	49 8b d1             	mov    %r9,%rdx
 1bc:	49 63 f0             	movslq %r8d,%rsi
 1bf:	48 6b f6 10          	imul   $0x10,%rsi,%rsi
 1c3:	48 03 d6             	add    %rsi,%rdx
 1c6:	db 2a                	fldt   (%rdx)
 1c8:	dd d0                	fst    %st(0)
 1ca:	d9 c9                	fxch   %st(1)
 1cc:	d9 c9                	fxch   %st(1)
 1ce:	de c9                	fmulp  %st,%st(1)
 1d0:	dd d0                	fst    %st(0)
 1d2:	d9 c9                	fxch   %st(1)
 1d4:	d9 c9                	fxch   %st(1)
 1d6:	de c1                	faddp  %st,%st(1)
 1d8:	dd d0                	fst    %st(0)
 1da:	d9 c8                	fxch   %st(0)
 1dc:	db bc 24 f0 00 00 00 	fstpt  0xf0(%rsp)
 1e3:	41 8b c0             	mov    %r8d,%eax
 1e6:	ff c0                	inc    %eax
 1e8:	41 89 c0             	mov    %eax,%r8d
 1eb:	eb ad                	jmp    19a <dot+0x4a>
 1ed:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
 1f4:	db 3c 24             	fstpt  (%rsp)
 1f7:	db 2c 24             	fldt   (%rsp)
 1fa:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
 201:	c3                   	ret
