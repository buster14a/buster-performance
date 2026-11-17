
k_o2.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	mov    %edi,%eax
   2:	xor    %esi,%eax
   4:	ret
   5:	data16 cs nopw 0x0(%rax,%rax,1)

0000000000000010 <k_lt>:
  10:	mov    %edi,%eax
  12:	ucomisd %xmm0,%xmm1
  16:	cmovbe %esi,%eax
  19:	ret
  1a:	nopw   0x0(%rax,%rax,1)

0000000000000020 <k_ge>:
  20:	ucomiss %xmm1,%xmm0
  23:	mov    %edi,%eax
  25:	cmovb  %esi,%eax
  28:	ret
  29:	nopl   0x0(%rax)

0000000000000030 <k_nle>:
  30:	ucomisd %xmm0,%xmm1
  34:	mov    %rdi,%rax
  37:	cmovae %rsi,%rax
  3b:	ret
  3c:	nopl   0x0(%rax)

0000000000000040 <k_eq>:
  40:	mov    %edi,%eax
  42:	ucomisd %xmm1,%xmm0
  46:	cmovne %esi,%eax
  49:	cmovp  %esi,%eax
  4c:	ret
  4d:	nopl   (%rax)

0000000000000050 <k_ne>:
  50:	mov    %esi,%eax
  52:	ucomiss %xmm1,%xmm0
  55:	cmovne %edi,%eax
  58:	cmovp  %edi,%eax
  5b:	ret
  5c:	nopl   0x0(%rax)

0000000000000060 <k_count>:
  60:	test   %esi,%esi
  62:	jle    78 <k_count+0x18>
  64:	mov    %esi,%r8d
  67:	mov    %r8d,%ecx
  6a:	and    $0x3,%ecx
  6d:	cmp    $0x4,%esi
  70:	jae    7b <k_count+0x1b>
  72:	xor    %edx,%edx
  74:	xor    %eax,%eax
  76:	jmp    f3 <k_count+0x93>
  78:	xor    %eax,%eax
  7a:	ret
  7b:	and    $0x7ffffffc,%r8d
  82:	xor    %edx,%edx
  84:	xor    %eax,%eax
  86:	cs nopw 0x0(%rax,%rax,1)
  90:	movsd  (%rdi,%rdx,8),%xmm1
  95:	xor    %esi,%esi
  97:	ucomisd %xmm0,%xmm1
  9b:	seta   %sil
  9f:	movsd  0x8(%rdi,%rdx,8),%xmm1
  a5:	xor    %r9d,%r9d
  a8:	ucomisd %xmm0,%xmm1
  ac:	lea    (%rax,%rsi,4),%rax
  b0:	seta   %r9b
  b4:	lea    (%rax,%r9,4),%rax
  b8:	movsd  0x10(%rdi,%rdx,8),%xmm1
  be:	xor    %esi,%esi
  c0:	ucomisd %xmm0,%xmm1
  c4:	seta   %sil
  c8:	movsd  0x18(%rdi,%rdx,8),%xmm1
  ce:	xor    %r9d,%r9d
  d1:	ucomisd %xmm0,%xmm1
  d5:	seta   %r9b
  d9:	lea    (%rax,%rsi,4),%rax
  dd:	lea    (%rax,%r9,4),%rax
  e1:	add    $0xfffffffffffffffc,%rax
  e5:	add    $0x4,%rdx
  e9:	cmp    %rdx,%r8
  ec:	jne    90 <k_count+0x30>
  ee:	test   %rcx,%rcx
  f1:	je     11e <k_count+0xbe>
  f3:	lea    (%rdi,%rdx,8),%rdx
  f7:	xor    %esi,%esi
  f9:	nopl   0x0(%rax)
 100:	movsd  (%rdx,%rsi,8),%xmm1
 105:	xor    %edi,%edi
 107:	ucomisd %xmm0,%xmm1
 10b:	seta   %dil
 10f:	lea    (%rax,%rdi,4),%rax
 113:	dec    %rax
 116:	inc    %rsi
 119:	cmp    %rsi,%rcx
 11c:	jne    100 <k_count+0xa0>
 11e:	ret
 11f:	nop

0000000000000120 <k_equal>:
 120:	test   %esi,%esi
 122:	jle    13b <k_equal+0x1b>
 124:	mov    %esi,%r8d
 127:	mov    %r8d,%ecx
 12a:	and    $0x3,%ecx
 12d:	cmp    $0x4,%esi
 130:	jae    13e <k_equal+0x1e>
 132:	xor    %edx,%edx
 134:	xor    %eax,%eax
 136:	jmp    1bd <k_equal+0x9d>
 13b:	xor    %eax,%eax
 13d:	ret
 13e:	and    $0x7ffffffc,%r8d
 145:	xor    %edx,%edx
 147:	xor    %eax,%eax
 149:	nopl   0x0(%rax)
 150:	movsd  (%rdi,%rdx,8),%xmm1
 155:	cmpeqsd %xmm0,%xmm1
 15a:	movq   %xmm1,%rsi
 15f:	and    $0x1,%esi
 162:	lea    (%rax,%rsi,4),%rax
 166:	movsd  0x8(%rdi,%rdx,8),%xmm1
 16c:	cmpeqsd %xmm0,%xmm1
 171:	movq   %xmm1,%rsi
 176:	and    $0x1,%esi
 179:	lea    (%rax,%rsi,4),%rax
 17d:	movsd  0x10(%rdi,%rdx,8),%xmm1
 183:	cmpeqsd %xmm0,%xmm1
 188:	movq   %xmm1,%rsi
 18d:	and    $0x1,%esi
 190:	lea    (%rax,%rsi,4),%rax
 194:	movsd  0x18(%rdi,%rdx,8),%xmm1
 19a:	cmpeqsd %xmm0,%xmm1
 19f:	movq   %xmm1,%rsi
 1a4:	and    $0x1,%esi
 1a7:	lea    (%rax,%rsi,4),%rax
 1ab:	add    $0x4,%rax
 1af:	add    $0x4,%rdx
 1b3:	cmp    %rdx,%r8
 1b6:	jne    150 <k_equal+0x30>
 1b8:	test   %rcx,%rcx
 1bb:	je     1f1 <k_equal+0xd1>
 1bd:	lea    (%rdi,%rdx,8),%rdx
 1c1:	xor    %esi,%esi
 1c3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1d0:	movsd  (%rdx,%rsi,8),%xmm1
 1d5:	cmpeqsd %xmm0,%xmm1
 1da:	movq   %xmm1,%rdi
 1df:	and    $0x1,%edi
 1e2:	lea    (%rax,%rdi,4),%rax
 1e6:	inc    %rax
 1e9:	inc    %rsi
 1ec:	cmp    %rsi,%rcx
 1ef:	jne    1d0 <k_equal+0xb0>
 1f1:	ret
