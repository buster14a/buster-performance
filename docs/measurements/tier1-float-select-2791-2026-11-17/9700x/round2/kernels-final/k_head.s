
k_head.o:     file format elf64-x86-64


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
  10:	ucomisd %xmm0,%xmm1
  14:	mov    %esi,%eax
  16:	cmova  %edi,%eax
  19:	ret
  1a:	int3
  1b:	int3
  1c:	int3
  1d:	int3
  1e:	int3
  1f:	int3

0000000000000020 <k_ge>:
  20:	ucomiss %xmm1,%xmm0
  23:	mov    %esi,%eax
  25:	cmovae %edi,%eax
  28:	ret
  29:	int3
  2a:	int3
  2b:	int3
  2c:	int3
  2d:	int3
  2e:	int3
  2f:	int3

0000000000000030 <k_nle>:
  30:	ucomisd %xmm0,%xmm1
  34:	mov    %rsi,%rax
  37:	cmovb  %rdi,%rax
  3b:	ret
  3c:	int3
  3d:	int3
  3e:	int3
  3f:	int3

0000000000000040 <k_eq>:
  40:	xor    %eax,%eax
  42:	ucomisd %xmm1,%xmm0
  46:	sete   %al
  49:	setnp  %r11b
  4d:	and    %r11b,%al
  50:	test   %eax,%eax
  52:	mov    %esi,%eax
  54:	cmovne %edi,%eax
  57:	ret
  58:	int3
  59:	int3
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <k_ne>:
  60:	xor    %eax,%eax
  62:	ucomiss %xmm1,%xmm0
  65:	setne  %al
  68:	setp   %r11b
  6c:	or     %r11b,%al
  6f:	test   %eax,%eax
  71:	mov    %esi,%eax
  73:	cmovne %edi,%eax
  76:	ret
  77:	int3
  78:	int3
  79:	int3
  7a:	int3
  7b:	int3
  7c:	int3
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <k_count>:
  80:	xor    %eax,%eax
  82:	xor    %ecx,%ecx
  84:	jmp    a1 <k_count+0x21>
  86:	mov    %rcx,%rdx
  89:	movsd  (%rdi,%rdx,8),%xmm1
  8e:	lea    0x3(%rax),%rdx
  92:	sub    $0x1,%rax
  96:	ucomisd %xmm0,%xmm1
  9a:	cmova  %rdx,%rax
  9e:	add    $0x1,%ecx
  a1:	cmp    %esi,%ecx
  a3:	jl     86 <k_count+0x6>
  a5:	ret
  a6:	int3
  a7:	int3
  a8:	int3
  a9:	int3
  aa:	int3
  ab:	int3
  ac:	int3
  ad:	int3
  ae:	int3
  af:	int3

00000000000000b0 <k_equal>:
  b0:	xor    %eax,%eax
  b2:	xor    %ecx,%ecx
  b4:	jmp    df <k_equal+0x2f>
  b6:	mov    %rcx,%rdx
  b9:	movsd  (%rdi,%rdx,8),%xmm1
  be:	xor    %edx,%edx
  c0:	ucomisd %xmm0,%xmm1
  c4:	sete   %dl
  c7:	setnp  %r11b
  cb:	and    %r11b,%dl
  ce:	lea    0x5(%rax),%r8
  d2:	add    $0x1,%rax
  d6:	test   %edx,%edx
  d8:	cmovne %r8,%rax
  dc:	add    $0x1,%ecx
  df:	cmp    %esi,%ecx
  e1:	jl     b6 <k_equal+0x6>
  e3:	ret
