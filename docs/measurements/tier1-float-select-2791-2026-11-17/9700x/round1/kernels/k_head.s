
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
  40:	ucomisd %xmm1,%xmm0
  44:	mov    %edi,%eax
  46:	cmovne %esi,%eax
  49:	cmovp  %esi,%eax
  4c:	ret
  4d:	int3
  4e:	int3
  4f:	int3

0000000000000050 <k_ne>:
  50:	ucomiss %xmm1,%xmm0
  53:	mov    %esi,%eax
  55:	cmovne %edi,%eax
  58:	cmovp  %edi,%eax
  5b:	ret
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <k_count>:
  60:	xor    %eax,%eax
  62:	xor    %ecx,%ecx
  64:	jmp    81 <k_count+0x21>
  66:	mov    %rcx,%rdx
  69:	movsd  (%rdi,%rdx,8),%xmm1
  6e:	lea    0x3(%rax),%rdx
  72:	sub    $0x1,%rax
  76:	ucomisd %xmm0,%xmm1
  7a:	cmova  %rdx,%rax
  7e:	add    $0x1,%ecx
  81:	cmp    %esi,%ecx
  83:	jl     66 <k_count+0x6>
  85:	ret
  86:	int3
  87:	int3
  88:	int3
  89:	int3
  8a:	int3
  8b:	int3
  8c:	int3
  8d:	int3
  8e:	int3
  8f:	int3

0000000000000090 <k_equal>:
  90:	xor    %eax,%eax
  92:	xor    %ecx,%ecx
  94:	jmp    b8 <k_equal+0x28>
  96:	mov    %rcx,%rdx
  99:	movsd  (%rdi,%rdx,8),%xmm1
  9e:	lea    0x5(%rax),%rdx
  a2:	add    $0x1,%rax
  a6:	ucomisd %xmm0,%xmm1
  aa:	mov    %rax,%r11
  ad:	cmove  %rdx,%rax
  b1:	cmovp  %r11,%rax
  b5:	add    $0x1,%ecx
  b8:	cmp    %esi,%ecx
  ba:	jl     96 <k_equal+0x6>
  bc:	ret
