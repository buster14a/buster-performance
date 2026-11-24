
base0.o:     file format elf64-x86-64


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
  3b:	db 7c 24 10          	fstpt  0x10(%rsp)
  3f:	db 6c 24 10          	fldt   0x10(%rsp)
  43:	db 38                	fstpt  (%rax)
  45:	45 31 c0             	xor    %r8d,%r8d
  48:	44 3b c6             	cmp    %esi,%r8d
  4b:	7d 60                	jge    ad <affine+0xad>
  4d:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
  54:	db 3c 24             	fstpt  (%rsp)
  57:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5e:	00 
  5f:	c7 44 24 14 00 00 00 	movl   $0x80000000,0x14(%rsp)
  66:	80 
  67:	66 c7 44 24 18 fe 3f 	movw   $0x3ffe,0x18(%rsp)
  6e:	db 2c 24             	fldt   (%rsp)
  71:	db 6c 24 10          	fldt   0x10(%rsp)
  75:	de c9                	fmulp  %st,%st(1)
  77:	db 3c 24             	fstpt  (%rsp)
  7a:	48 8b cf             	mov    %rdi,%rcx
  7d:	49 63 d0             	movslq %r8d,%rdx
  80:	8b 0c 91             	mov    (%rcx,%rdx,4),%ecx
  83:	89 4c 24 f8          	mov    %ecx,-0x8(%rsp)
  87:	db 44 24 f8          	fildl  -0x8(%rsp)
  8b:	db 7c 24 10          	fstpt  0x10(%rsp)
  8f:	db 2c 24             	fldt   (%rsp)
  92:	db 6c 24 10          	fldt   0x10(%rsp)
  96:	de c1                	faddp  %st,%st(1)
  98:	d9 c0                	fld    %st(0)
  9a:	dd d8                	fstp   %st(0)
  9c:	db bc 24 f0 00 00 00 	fstpt  0xf0(%rsp)
  a3:	41 8b c0             	mov    %r8d,%eax
  a6:	ff c0                	inc    %eax
  a8:	41 89 c0             	mov    %eax,%r8d
  ab:	eb 9b                	jmp    48 <affine+0x48>
  ad:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
  b4:	db 3c 24             	fstpt  (%rsp)
  b7:	db 2c 24             	fldt   (%rsp)
  ba:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  c1:	c3                   	ret
  c2:	cc                   	int3
  c3:	cc                   	int3
  c4:	cc                   	int3
  c5:	cc                   	int3
  c6:	cc                   	int3
  c7:	cc                   	int3
  c8:	cc                   	int3
  c9:	cc                   	int3
  ca:	cc                   	int3
  cb:	cc                   	int3
  cc:	cc                   	int3
  cd:	cc                   	int3
  ce:	cc                   	int3
  cf:	cc                   	int3

00000000000000d0 <sum>:
  d0:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  d7:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  de:	00 
  df:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  e6:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
  ed:	00 
  ee:	48 83 c0 08          	add    $0x8,%rax
  f2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  f9:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
 100:	00 
 101:	31 c9                	xor    %ecx,%ecx
 103:	89 4c 24 f8          	mov    %ecx,-0x8(%rsp)
 107:	db 44 24 f8          	fildl  -0x8(%rsp)
 10b:	db 7c 24 10          	fstpt  0x10(%rsp)
 10f:	db 6c 24 10          	fldt   0x10(%rsp)
 113:	db 38                	fstpt  (%rax)
 115:	45 31 c0             	xor    %r8d,%r8d
 118:	44 3b c6             	cmp    %esi,%r8d
 11b:	7d 3b                	jge    158 <sum+0x88>
 11d:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
 124:	db 3c 24             	fstpt  (%rsp)
 127:	48 8b cf             	mov    %rdi,%rcx
 12a:	49 63 d0             	movslq %r8d,%rdx
 12d:	48 6b d2 10          	imul   $0x10,%rdx,%rdx
 131:	48 03 ca             	add    %rdx,%rcx
 134:	db 29                	fldt   (%rcx)
 136:	db 7c 24 10          	fstpt  0x10(%rsp)
 13a:	db 2c 24             	fldt   (%rsp)
 13d:	db 6c 24 10          	fldt   0x10(%rsp)
 141:	de c1                	faddp  %st,%st(1)
 143:	d9 c0                	fld    %st(0)
 145:	dd d8                	fstp   %st(0)
 147:	db bc 24 f0 00 00 00 	fstpt  0xf0(%rsp)
 14e:	41 8b c0             	mov    %r8d,%eax
 151:	ff c0                	inc    %eax
 153:	41 89 c0             	mov    %eax,%r8d
 156:	eb c0                	jmp    118 <sum+0x48>
 158:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
 15f:	db 3c 24             	fstpt  (%rsp)
 162:	db 2c 24             	fldt   (%rsp)
 165:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
 16c:	c3                   	ret
 16d:	cc                   	int3
 16e:	cc                   	int3
 16f:	cc                   	int3

0000000000000170 <dot>:
 170:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
 177:	4c 8b ce             	mov    %rsi,%r9
 17a:	4c 8b d2             	mov    %rdx,%r10
 17d:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
 184:	00 
 185:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
 18c:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
 193:	00 
 194:	48 83 c0 08          	add    $0x8,%rax
 198:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
 19f:	48 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%rax
 1a6:	00 
 1a7:	31 c9                	xor    %ecx,%ecx
 1a9:	89 4c 24 f8          	mov    %ecx,-0x8(%rsp)
 1ad:	db 44 24 f8          	fildl  -0x8(%rsp)
 1b1:	db 7c 24 10          	fstpt  0x10(%rsp)
 1b5:	db 6c 24 10          	fldt   0x10(%rsp)
 1b9:	db 38                	fstpt  (%rax)
 1bb:	45 31 c0             	xor    %r8d,%r8d
 1be:	45 3b c2             	cmp    %r10d,%r8d
 1c1:	7d 5c                	jge    21f <dot+0xaf>
 1c3:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
 1ca:	db 3c 24             	fstpt  (%rsp)
 1cd:	48 8b cf             	mov    %rdi,%rcx
 1d0:	49 63 d0             	movslq %r8d,%rdx
 1d3:	48 6b d2 10          	imul   $0x10,%rdx,%rdx
 1d7:	48 03 ca             	add    %rdx,%rcx
 1da:	db 29                	fldt   (%rcx)
 1dc:	db 7c 24 10          	fstpt  0x10(%rsp)
 1e0:	49 8b d1             	mov    %r9,%rdx
 1e3:	49 63 f0             	movslq %r8d,%rsi
 1e6:	48 6b f6 10          	imul   $0x10,%rsi,%rsi
 1ea:	48 03 d6             	add    %rsi,%rdx
 1ed:	db 2a                	fldt   (%rdx)
 1ef:	db 7c 24 20          	fstpt  0x20(%rsp)
 1f3:	db 6c 24 10          	fldt   0x10(%rsp)
 1f7:	db 6c 24 20          	fldt   0x20(%rsp)
 1fb:	de c9                	fmulp  %st,%st(1)
 1fd:	db 7c 24 10          	fstpt  0x10(%rsp)
 201:	db 2c 24             	fldt   (%rsp)
 204:	db 6c 24 10          	fldt   0x10(%rsp)
 208:	de c1                	faddp  %st,%st(1)
 20a:	d9 c0                	fld    %st(0)
 20c:	dd d8                	fstp   %st(0)
 20e:	db bc 24 f0 00 00 00 	fstpt  0xf0(%rsp)
 215:	41 8b c0             	mov    %r8d,%eax
 218:	ff c0                	inc    %eax
 21a:	41 89 c0             	mov    %eax,%r8d
 21d:	eb 9f                	jmp    1be <dot+0x4e>
 21f:	db ac 24 f0 00 00 00 	fldt   0xf0(%rsp)
 226:	db 3c 24             	fstpt  (%rsp)
 229:	db 2c 24             	fldt   (%rsp)
 22c:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
 233:	c3                   	ret
