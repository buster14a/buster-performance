
k_o2.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	mov    %edi,%eax
   2:	xor    %esi,%eax
   4:	ret
   5:	data16 cs nopw 0x0(%rax,%rax,1)

0000000000000010 <k_best>:
  10:	test   %esi,%esi
  12:	jle    2b <k_best+0x1b>
  14:	mov    %esi,%r8d
  17:	mov    %r8d,%ecx
  1a:	and    $0x3,%ecx
  1d:	cmp    $0x4,%esi
  20:	jae    31 <k_best+0x21>
  22:	mov    $0xffffffff,%eax
  27:	xor    %edx,%edx
  29:	jmp    90 <k_best+0x80>
  2b:	mov    $0xffffffff,%eax
  30:	ret
  31:	and    $0x7ffffffc,%r8d
  38:	mov    $0xffffffff,%eax
  3d:	xor    %edx,%edx
  3f:	nop
  40:	ucomisd (%rdi,%rdx,8),%xmm0
  45:	mov    %edx,%esi
  47:	cmovne %eax,%esi
  4a:	cmovp  %eax,%esi
  4d:	lea    0x1(%rdx),%eax
  50:	ucomisd 0x8(%rdi,%rdx,8),%xmm0
  56:	cmovne %esi,%eax
  59:	cmovp  %esi,%eax
  5c:	lea    0x2(%rdx),%esi
  5f:	ucomisd 0x10(%rdi,%rdx,8),%xmm0
  65:	cmovne %eax,%esi
  68:	cmovp  %eax,%esi
  6b:	ucomisd 0x18(%rdi,%rdx,8),%xmm0
  71:	lea    0x3(%rdx),%eax
  74:	cmovne %esi,%eax
  77:	cmovp  %esi,%eax
  7a:	add    $0x4,%rdx
  7e:	cmp    %r8,%rdx
  81:	jne    40 <k_best+0x30>
  83:	test   %rcx,%rcx
  86:	je     a7 <k_best+0x97>
  88:	nopl   0x0(%rax,%rax,1)
  90:	ucomisd (%rdi,%rdx,8),%xmm0
  95:	mov    %eax,%esi
  97:	mov    %edx,%eax
  99:	cmovne %esi,%eax
  9c:	cmovp  %esi,%eax
  9f:	inc    %rdx
  a2:	dec    %rcx
  a5:	jne    90 <k_best+0x80>
  a7:	ret
  a8:	nopl   0x0(%rax,%rax,1)

00000000000000b0 <k_equal>:
  b0:	test   %esi,%esi
  b2:	jle    cb <k_equal+0x1b>
  b4:	mov    %esi,%r8d
  b7:	mov    %r8d,%ecx
  ba:	and    $0x3,%ecx
  bd:	cmp    $0x4,%esi
  c0:	jae    ce <k_equal+0x1e>
  c2:	xor    %edx,%edx
  c4:	xor    %eax,%eax
  c6:	jmp    14d <k_equal+0x9d>
  cb:	xor    %eax,%eax
  cd:	ret
  ce:	and    $0x7ffffffc,%r8d
  d5:	xor    %edx,%edx
  d7:	xor    %eax,%eax
  d9:	nopl   0x0(%rax)
  e0:	movsd  (%rdi,%rdx,8),%xmm1
  e5:	cmpeqsd %xmm0,%xmm1
  ea:	movq   %xmm1,%rsi
  ef:	and    $0x1,%esi
  f2:	lea    (%rax,%rsi,4),%rax
  f6:	movsd  0x8(%rdi,%rdx,8),%xmm1
  fc:	cmpeqsd %xmm0,%xmm1
 101:	movq   %xmm1,%rsi
 106:	and    $0x1,%esi
 109:	lea    (%rax,%rsi,4),%rax
 10d:	movsd  0x10(%rdi,%rdx,8),%xmm1
 113:	cmpeqsd %xmm0,%xmm1
 118:	movq   %xmm1,%rsi
 11d:	and    $0x1,%esi
 120:	lea    (%rax,%rsi,4),%rax
 124:	movsd  0x18(%rdi,%rdx,8),%xmm1
 12a:	cmpeqsd %xmm0,%xmm1
 12f:	movq   %xmm1,%rsi
 134:	and    $0x1,%esi
 137:	lea    (%rax,%rsi,4),%rax
 13b:	add    $0x4,%rax
 13f:	add    $0x4,%rdx
 143:	cmp    %rdx,%r8
 146:	jne    e0 <k_equal+0x30>
 148:	test   %rcx,%rcx
 14b:	je     181 <k_equal+0xd1>
 14d:	lea    (%rdi,%rdx,8),%rdx
 151:	xor    %esi,%esi
 153:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 160:	movsd  (%rdx,%rsi,8),%xmm1
 165:	cmpeqsd %xmm0,%xmm1
 16a:	movq   %xmm1,%rdi
 16f:	and    $0x1,%edi
 172:	lea    (%rax,%rdi,4),%rax
 176:	inc    %rax
 179:	inc    %rsi
 17c:	cmp    %rsi,%rcx
 17f:	jne    160 <k_equal+0xb0>
 181:	ret
 182:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)

0000000000000190 <k_sum>:
 190:	test   %esi,%esi
 192:	jle    1a9 <k_sum+0x19>
 194:	mov    %esi,%r9d
 197:	mov    %r9d,%r8d
 19a:	and    $0x3,%r8d
 19e:	cmp    $0x4,%esi
 1a1:	jae    1ac <k_sum+0x1c>
 1a3:	xor    %esi,%esi
 1a5:	xor    %eax,%eax
 1a7:	jmp    21d <k_sum+0x8d>
 1a9:	xor    %eax,%eax
 1ab:	ret
 1ac:	and    $0x7ffffffc,%r9d
 1b3:	xor    %esi,%esi
 1b5:	xor    %eax,%eax
 1b7:	nopw   0x0(%rax,%rax,1)
 1c0:	ucomisd (%rdi,%rsi,8),%xmm0
 1c5:	mov    %rdx,%r10
 1c8:	cmovne %rcx,%r10
 1cc:	cmovp  %rcx,%r10
 1d0:	add    %r10,%rax
 1d3:	ucomisd 0x8(%rdi,%rsi,8),%xmm0
 1d9:	mov    %rdx,%r10
 1dc:	cmovne %rcx,%r10
 1e0:	cmovp  %rcx,%r10
 1e4:	ucomisd 0x10(%rdi,%rsi,8),%xmm0
 1ea:	mov    %rdx,%r11
 1ed:	cmovne %rcx,%r11
 1f1:	cmovp  %rcx,%r11
 1f5:	add    %r10,%r11
 1f8:	add    %rax,%r11
 1fb:	ucomisd 0x18(%rdi,%rsi,8),%xmm0
 201:	mov    %rdx,%rax
 204:	cmovne %rcx,%rax
 208:	cmovp  %rcx,%rax
 20c:	add    %r11,%rax
 20f:	add    $0x4,%rsi
 213:	cmp    %rsi,%r9
 216:	jne    1c0 <k_sum+0x30>
 218:	test   %r8,%r8
 21b:	je     24b <k_sum+0xbb>
 21d:	lea    (%rdi,%rsi,8),%rsi
 221:	xor    %edi,%edi
 223:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 230:	ucomisd (%rsi,%rdi,8),%xmm0
 235:	mov    %rdx,%r9
 238:	cmovne %rcx,%r9
 23c:	cmovp  %rcx,%r9
 240:	add    %r9,%rax
 243:	inc    %rdi
 246:	cmp    %rdi,%r8
 249:	jne    230 <k_sum+0xa0>
 24b:	ret
 24c:	nopl   0x0(%rax)

0000000000000250 <k_lt>:
 250:	mov    %edi,%eax
 252:	ucomisd %xmm0,%xmm1
 256:	cmovbe %esi,%eax
 259:	ret
 25a:	nopw   0x0(%rax,%rax,1)

0000000000000260 <k_eq>:
 260:	mov    %edi,%eax
 262:	ucomisd %xmm1,%xmm0
 266:	cmovne %esi,%eax
 269:	cmovp  %esi,%eax
 26c:	ret
 26d:	nopl   (%rax)

0000000000000270 <k_ne>:
 270:	mov    %esi,%eax
 272:	ucomiss %xmm1,%xmm0
 275:	cmovne %edi,%eax
 278:	cmovp  %edi,%eax
 27b:	ret
