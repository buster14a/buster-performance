
kernel-clang.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	89 f8                	mov    %edi,%eax
   2:	31 f0                	xor    %esi,%eax
   4:	c3                   	ret
   5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   c:	00 00 00 00

0000000000000010 <k_best>:
  10:	85 f6                	test   %esi,%esi
  12:	7e 1a                	jle    2e <k_best+0x1e>
  14:	41 89 f0             	mov    %esi,%r8d
  17:	44 89 c1             	mov    %r8d,%ecx
  1a:	83 e1 07             	and    $0x7,%ecx
  1d:	83 fe 08             	cmp    $0x8,%esi
  20:	73 12                	jae    34 <k_best+0x24>
  22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  27:	31 d2                	xor    %edx,%edx
  29:	e9 b2 00 00 00       	jmp    e0 <k_best+0xd0>
  2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  33:	c3                   	ret
  34:	41 81 e0 f8 ff ff 7f 	and    $0x7ffffff8,%r8d
  3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  40:	31 d2                	xor    %edx,%edx
  42:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  49:	1f 84 00 00 00 00 00
  50:	c5 f9 2e 04 d7       	vucomisd (%rdi,%rdx,8),%xmm0
  55:	89 d6                	mov    %edx,%esi
  57:	0f 45 f0             	cmovne %eax,%esi
  5a:	0f 4a f0             	cmovp  %eax,%esi
  5d:	c5 f9 2e 44 d7 08    	vucomisd 0x8(%rdi,%rdx,8),%xmm0
  63:	8d 42 01             	lea    0x1(%rdx),%eax
  66:	0f 45 c6             	cmovne %esi,%eax
  69:	0f 4a c6             	cmovp  %esi,%eax
  6c:	c5 f9 2e 44 d7 10    	vucomisd 0x10(%rdi,%rdx,8),%xmm0
  72:	8d 72 02             	lea    0x2(%rdx),%esi
  75:	0f 45 f0             	cmovne %eax,%esi
  78:	0f 4a f0             	cmovp  %eax,%esi
  7b:	c5 f9 2e 44 d7 18    	vucomisd 0x18(%rdi,%rdx,8),%xmm0
  81:	8d 42 03             	lea    0x3(%rdx),%eax
  84:	0f 45 c6             	cmovne %esi,%eax
  87:	0f 4a c6             	cmovp  %esi,%eax
  8a:	c5 f9 2e 44 d7 20    	vucomisd 0x20(%rdi,%rdx,8),%xmm0
  90:	8d 72 04             	lea    0x4(%rdx),%esi
  93:	0f 45 f0             	cmovne %eax,%esi
  96:	0f 4a f0             	cmovp  %eax,%esi
  99:	c5 f9 2e 44 d7 28    	vucomisd 0x28(%rdi,%rdx,8),%xmm0
  9f:	8d 42 05             	lea    0x5(%rdx),%eax
  a2:	0f 45 c6             	cmovne %esi,%eax
  a5:	0f 4a c6             	cmovp  %esi,%eax
  a8:	c5 f9 2e 44 d7 30    	vucomisd 0x30(%rdi,%rdx,8),%xmm0
  ae:	8d 72 06             	lea    0x6(%rdx),%esi
  b1:	0f 45 f0             	cmovne %eax,%esi
  b4:	0f 4a f0             	cmovp  %eax,%esi
  b7:	c5 f9 2e 44 d7 38    	vucomisd 0x38(%rdi,%rdx,8),%xmm0
  bd:	8d 42 07             	lea    0x7(%rdx),%eax
  c0:	0f 45 c6             	cmovne %esi,%eax
  c3:	0f 4a c6             	cmovp  %esi,%eax
  c6:	48 83 c2 08          	add    $0x8,%rdx
  ca:	4c 39 c2             	cmp    %r8,%rdx
  cd:	75 81                	jne    50 <k_best+0x40>
  cf:	48 85 c9             	test   %rcx,%rcx
  d2:	74 23                	je     f7 <k_best+0xe7>
  d4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  db:	00 00 00 00 00
  e0:	c5 f9 2e 04 d7       	vucomisd (%rdi,%rdx,8),%xmm0
  e5:	89 c6                	mov    %eax,%esi
  e7:	89 d0                	mov    %edx,%eax
  e9:	0f 45 c6             	cmovne %esi,%eax
  ec:	0f 4a c6             	cmovp  %esi,%eax
  ef:	48 ff c2             	inc    %rdx
  f2:	48 ff c9             	dec    %rcx
  f5:	75 e9                	jne    e0 <k_best+0xd0>
  f7:	c3                   	ret
  f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  ff:	00

0000000000000100 <k_equal>:
 100:	85 f6                	test   %esi,%esi
 102:	7e 17                	jle    11b <k_equal+0x1b>
 104:	41 89 f0             	mov    %esi,%r8d
 107:	44 89 c1             	mov    %r8d,%ecx
 10a:	83 e1 07             	and    $0x7,%ecx
 10d:	83 fe 08             	cmp    $0x8,%esi
 110:	73 0c                	jae    11e <k_equal+0x1e>
 112:	31 d2                	xor    %edx,%edx
 114:	31 c0                	xor    %eax,%eax
 116:	e9 af 00 00 00       	jmp    1ca <k_equal+0xca>
 11b:	31 c0                	xor    %eax,%eax
 11d:	c3                   	ret
 11e:	41 81 e0 f8 ff ff 7f 	and    $0x7ffffff8,%r8d
 125:	31 d2                	xor    %edx,%edx
 127:	31 c0                	xor    %eax,%eax
 129:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 130:	62 f1 ff 08 c2 04 d7 	vcmpeqsd (%rdi,%rdx,8),%xmm0,%k0
 137:	00
 138:	c5 f8 93 f0          	kmovw  %k0,%esi
 13c:	62 f1 ff 08 c2 44 d7 	vcmpeqsd 0x8(%rdi,%rdx,8),%xmm0,%k0
 143:	01 00
 145:	48 8d 04 b0          	lea    (%rax,%rsi,4),%rax
 149:	c5 f8 93 f0          	kmovw  %k0,%esi
 14d:	62 f1 ff 08 c2 44 d7 	vcmpeqsd 0x10(%rdi,%rdx,8),%xmm0,%k0
 154:	02 00
 156:	48 8d 04 b0          	lea    (%rax,%rsi,4),%rax
 15a:	c5 f8 93 f0          	kmovw  %k0,%esi
 15e:	62 f1 ff 08 c2 44 d7 	vcmpeqsd 0x18(%rdi,%rdx,8),%xmm0,%k0
 165:	03 00
 167:	48 8d 04 b0          	lea    (%rax,%rsi,4),%rax
 16b:	c5 f8 93 f0          	kmovw  %k0,%esi
 16f:	62 f1 ff 08 c2 44 d7 	vcmpeqsd 0x20(%rdi,%rdx,8),%xmm0,%k0
 176:	04 00
 178:	48 8d 04 b0          	lea    (%rax,%rsi,4),%rax
 17c:	c5 f8 93 f0          	kmovw  %k0,%esi
 180:	62 f1 ff 08 c2 44 d7 	vcmpeqsd 0x28(%rdi,%rdx,8),%xmm0,%k0
 187:	05 00
 189:	48 8d 04 b0          	lea    (%rax,%rsi,4),%rax
 18d:	c5 f8 93 f0          	kmovw  %k0,%esi
 191:	62 f1 ff 08 c2 44 d7 	vcmpeqsd 0x30(%rdi,%rdx,8),%xmm0,%k0
 198:	06 00
 19a:	48 8d 04 b0          	lea    (%rax,%rsi,4),%rax
 19e:	c5 f8 93 f0          	kmovw  %k0,%esi
 1a2:	62 f1 ff 08 c2 44 d7 	vcmpeqsd 0x38(%rdi,%rdx,8),%xmm0,%k0
 1a9:	07 00
 1ab:	48 83 c2 08          	add    $0x8,%rdx
 1af:	48 8d 04 b0          	lea    (%rax,%rsi,4),%rax
 1b3:	c5 f8 93 f0          	kmovw  %k0,%esi
 1b7:	48 8d 44 b0 08       	lea    0x8(%rax,%rsi,4),%rax
 1bc:	49 39 d0             	cmp    %rdx,%r8
 1bf:	0f 85 6b ff ff ff    	jne    130 <k_equal+0x30>
 1c5:	48 85 c9             	test   %rcx,%rcx
 1c8:	74 1f                	je     1e9 <k_equal+0xe9>
 1ca:	48 8d 14 d7          	lea    (%rdi,%rdx,8),%rdx
 1ce:	31 f6                	xor    %esi,%esi
 1d0:	62 f1 ff 08 c2 04 f2 	vcmpeqsd (%rdx,%rsi,8),%xmm0,%k0
 1d7:	00
 1d8:	48 ff c6             	inc    %rsi
 1db:	c5 f8 93 f8          	kmovw  %k0,%edi
 1df:	48 8d 44 b8 01       	lea    0x1(%rax,%rdi,4),%rax
 1e4:	48 39 f1             	cmp    %rsi,%rcx
 1e7:	75 e7                	jne    1d0 <k_equal+0xd0>
 1e9:	c3                   	ret
 1ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000001f0 <k_sum>:
 1f0:	85 f6                	test   %esi,%esi
 1f2:	7e 18                	jle    20c <k_sum+0x1c>
 1f4:	41 89 f1             	mov    %esi,%r9d
 1f7:	45 89 c8             	mov    %r9d,%r8d
 1fa:	41 83 e0 07          	and    $0x7,%r8d
 1fe:	83 fe 08             	cmp    $0x8,%esi
 201:	73 0c                	jae    20f <k_sum+0x1f>
 203:	31 f6                	xor    %esi,%esi
 205:	31 c0                	xor    %eax,%eax
 207:	e9 c6 00 00 00       	jmp    2d2 <k_sum+0xe2>
 20c:	31 c0                	xor    %eax,%eax
 20e:	c3                   	ret
 20f:	53                   	push   %rbx
 210:	41 81 e1 f8 ff ff 7f 	and    $0x7ffffff8,%r9d
 217:	31 f6                	xor    %esi,%esi
 219:	31 c0                	xor    %eax,%eax
 21b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 220:	c5 f9 2e 04 f7       	vucomisd (%rdi,%rsi,8),%xmm0
 225:	49 89 d2             	mov    %rdx,%r10
 228:	49 89 d3             	mov    %rdx,%r11
 22b:	48 89 d3             	mov    %rdx,%rbx
 22e:	4c 0f 45 d1          	cmovne %rcx,%r10
 232:	4c 0f 4a d1          	cmovp  %rcx,%r10
 236:	49 01 c2             	add    %rax,%r10
 239:	c5 f9 2e 44 f7 08    	vucomisd 0x8(%rdi,%rsi,8),%xmm0
 23f:	48 89 d0             	mov    %rdx,%rax
 242:	48 0f 45 c1          	cmovne %rcx,%rax
 246:	48 0f 4a c1          	cmovp  %rcx,%rax
 24a:	c5 f9 2e 44 f7 10    	vucomisd 0x10(%rdi,%rsi,8),%xmm0
 250:	4c 0f 45 d9          	cmovne %rcx,%r11
 254:	4c 0f 4a d9          	cmovp  %rcx,%r11
 258:	49 01 c3             	add    %rax,%r11
 25b:	48 89 d0             	mov    %rdx,%rax
 25e:	4d 01 d3             	add    %r10,%r11
 261:	c5 f9 2e 44 f7 18    	vucomisd 0x18(%rdi,%rsi,8),%xmm0
 267:	49 89 d2             	mov    %rdx,%r10
 26a:	48 0f 45 c1          	cmovne %rcx,%rax
 26e:	48 0f 4a c1          	cmovp  %rcx,%rax
 272:	c5 f9 2e 44 f7 20    	vucomisd 0x20(%rdi,%rsi,8),%xmm0
 278:	4c 0f 45 d1          	cmovne %rcx,%r10
 27c:	4c 0f 4a d1          	cmovp  %rcx,%r10
 280:	49 01 c2             	add    %rax,%r10
 283:	c5 f9 2e 44 f7 28    	vucomisd 0x28(%rdi,%rsi,8),%xmm0
 289:	48 89 d0             	mov    %rdx,%rax
 28c:	48 0f 45 d9          	cmovne %rcx,%rbx
 290:	48 0f 4a d9          	cmovp  %rcx,%rbx
 294:	4c 01 d3             	add    %r10,%rbx
 297:	49 89 d2             	mov    %rdx,%r10
 29a:	4c 01 db             	add    %r11,%rbx
 29d:	c5 f9 2e 44 f7 30    	vucomisd 0x30(%rdi,%rsi,8),%xmm0
 2a3:	4c 0f 45 d1          	cmovne %rcx,%r10
 2a7:	4c 0f 4a d1          	cmovp  %rcx,%r10
 2ab:	c5 f9 2e 44 f7 38    	vucomisd 0x38(%rdi,%rsi,8),%xmm0
 2b1:	48 0f 45 c1          	cmovne %rcx,%rax
 2b5:	48 0f 4a c1          	cmovp  %rcx,%rax
 2b9:	48 83 c6 08          	add    $0x8,%rsi
 2bd:	4c 01 d0             	add    %r10,%rax
 2c0:	48 01 d8             	add    %rbx,%rax
 2c3:	49 39 f1             	cmp    %rsi,%r9
 2c6:	0f 85 54 ff ff ff    	jne    220 <k_sum+0x30>
 2cc:	4d 85 c0             	test   %r8,%r8
 2cf:	5b                   	pop    %rbx
 2d0:	74 29                	je     2fb <k_sum+0x10b>
 2d2:	48 8d 34 f7          	lea    (%rdi,%rsi,8),%rsi
 2d6:	31 ff                	xor    %edi,%edi
 2d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 2df:	00
 2e0:	c5 f9 2e 04 fe       	vucomisd (%rsi,%rdi,8),%xmm0
 2e5:	49 89 d1             	mov    %rdx,%r9
 2e8:	4c 0f 45 c9          	cmovne %rcx,%r9
 2ec:	4c 0f 4a c9          	cmovp  %rcx,%r9
 2f0:	48 ff c7             	inc    %rdi
 2f3:	4c 01 c8             	add    %r9,%rax
 2f6:	49 39 f8             	cmp    %rdi,%r8
 2f9:	75 e5                	jne    2e0 <k_sum+0xf0>
 2fb:	c3                   	ret
 2fc:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000300 <k_lt>:
 300:	c5 f9 2e c8          	vucomisd %xmm0,%xmm1
 304:	89 f8                	mov    %edi,%eax
 306:	0f 46 c6             	cmovbe %esi,%eax
 309:	c3                   	ret
 30a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000000310 <k_eq>:
 310:	c5 f9 2e c1          	vucomisd %xmm1,%xmm0
 314:	89 f8                	mov    %edi,%eax
 316:	0f 45 c6             	cmovne %esi,%eax
 319:	0f 4a c6             	cmovp  %esi,%eax
 31c:	c3                   	ret
 31d:	0f 1f 00             	nopl   (%rax)

0000000000000320 <k_ne>:
 320:	c5 f8 2e c1          	vucomiss %xmm1,%xmm0
 324:	89 f0                	mov    %esi,%eax
 326:	0f 45 c7             	cmovne %edi,%eax
 329:	0f 4a c7             	cmovp  %edi,%eax
 32c:	c3                   	ret
