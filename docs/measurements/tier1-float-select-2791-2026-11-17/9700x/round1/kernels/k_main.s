
k_main.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	mov    %edi,%eax
   2:	xor    %esi,%eax
   4:	ret
   5:	int3
   6:	int3
   7:	int3
   8:	int3
   9:	int3
   a:	int3
   b:	int3
   c:	int3
   d:	int3
   e:	int3
   f:	int3

0000000000000010 <k_lt>:
  10:	xor    %eax,%eax
  12:	ucomisd %xmm0,%xmm1
  16:	seta   %al
  19:	test   %eax,%eax
  1b:	mov    %esi,%eax
  1d:	cmovne %edi,%eax
  20:	ret
  21:	int3
  22:	int3
  23:	int3
  24:	int3
  25:	int3
  26:	int3
  27:	int3
  28:	int3
  29:	int3
  2a:	int3
  2b:	int3
  2c:	int3
  2d:	int3
  2e:	int3
  2f:	int3

0000000000000030 <k_ge>:
  30:	xor    %eax,%eax
  32:	ucomiss %xmm1,%xmm0
  35:	setae  %al
  38:	test   %eax,%eax
  3a:	mov    %esi,%eax
  3c:	cmovne %edi,%eax
  3f:	ret

0000000000000040 <k_nle>:
  40:	xor    %eax,%eax
  42:	ucomisd %xmm0,%xmm1
  46:	setae  %al
  49:	test   %eax,%eax
  4b:	mov    $0x0,%eax
  50:	sete   %al
  53:	test   %eax,%eax
  55:	mov    %rsi,%rax
  58:	cmovne %rdi,%rax
  5c:	ret
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <k_eq>:
  60:	xor    %eax,%eax
  62:	ucomisd %xmm1,%xmm0
  66:	sete   %al
  69:	setnp  %r11b
  6d:	and    %r11b,%al
  70:	test   %eax,%eax
  72:	mov    %esi,%eax
  74:	cmovne %edi,%eax
  77:	ret
  78:	int3
  79:	int3
  7a:	int3
  7b:	int3
  7c:	int3
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <k_ne>:
  80:	xor    %eax,%eax
  82:	ucomiss %xmm1,%xmm0
  85:	setne  %al
  88:	setp   %r11b
  8c:	or     %r11b,%al
  8f:	test   %eax,%eax
  91:	mov    %esi,%eax
  93:	cmovne %edi,%eax
  96:	ret
  97:	int3
  98:	int3
  99:	int3
  9a:	int3
  9b:	int3
  9c:	int3
  9d:	int3
  9e:	int3
  9f:	int3

00000000000000a0 <k_count>:
  a0:	xor    %eax,%eax
  a2:	xor    %ecx,%ecx
  a4:	jmp    c8 <k_count+0x28>
  a6:	mov    %rcx,%rdx
  a9:	movsd  (%rdi,%rdx,8),%xmm1
  ae:	xor    %edx,%edx
  b0:	ucomisd %xmm0,%xmm1
  b4:	seta   %dl
  b7:	lea    0x3(%rax),%r8
  bb:	sub    $0x1,%rax
  bf:	test   %edx,%edx
  c1:	cmovne %r8,%rax
  c5:	add    $0x1,%ecx
  c8:	cmp    %esi,%ecx
  ca:	jl     a6 <k_count+0x6>
  cc:	ret
  cd:	int3
  ce:	int3
  cf:	int3

00000000000000d0 <k_equal>:
  d0:	xor    %eax,%eax
  d2:	xor    %ecx,%ecx
  d4:	jmp    ff <k_equal+0x2f>
  d6:	mov    %rcx,%rdx
  d9:	movsd  (%rdi,%rdx,8),%xmm1
  de:	xor    %edx,%edx
  e0:	ucomisd %xmm0,%xmm1
  e4:	sete   %dl
  e7:	setnp  %r11b
  eb:	and    %r11b,%dl
  ee:	lea    0x5(%rax),%r8
  f2:	add    $0x1,%rax
  f6:	test   %edx,%edx
  f8:	cmovne %r8,%rax
  fc:	add    $0x1,%ecx
  ff:	cmp    %esi,%ecx
 101:	jl     d6 <k_equal+0x6>
 103:	ret
