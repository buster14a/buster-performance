
k_final.o:     file format elf64-x86-64


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

0000000000000010 <k_best>:
  10:	mov    $0xffffffff,%eax
  15:	xor    %ecx,%ecx
  17:	jmp    32 <k_best+0x22>
  19:	mov    %rcx,%rdx
  1c:	movsd  (%rdi,%rdx,8),%xmm1
  21:	ucomisd %xmm0,%xmm1
  25:	mov    %eax,%r11d
  28:	cmove  %ecx,%eax
  2b:	cmovp  %r11d,%eax
  2f:	add    $0x1,%ecx
  32:	cmp    %esi,%ecx
  34:	jl     19 <k_best+0x9>
  36:	ret
  37:	int3
  38:	int3
  39:	int3
  3a:	int3
  3b:	int3
  3c:	int3
  3d:	int3
  3e:	int3
  3f:	int3

0000000000000040 <k_equal>:
  40:	xor    %eax,%eax
  42:	xor    %ecx,%ecx
  44:	jmp    6f <k_equal+0x2f>
  46:	mov    %rcx,%rdx
  49:	movsd  (%rdi,%rdx,8),%xmm1
  4e:	xor    %edx,%edx
  50:	ucomisd %xmm0,%xmm1
  54:	sete   %dl
  57:	setnp  %r11b
  5b:	and    %r11b,%dl
  5e:	lea    0x5(%rax),%r8
  62:	add    $0x1,%rax
  66:	test   %edx,%edx
  68:	cmovne %r8,%rax
  6c:	add    $0x1,%ecx
  6f:	cmp    %esi,%ecx
  71:	jl     46 <k_equal+0x6>
  73:	ret
  74:	int3
  75:	int3
  76:	int3
  77:	int3
  78:	int3
  79:	int3
  7a:	int3
  7b:	int3
  7c:	int3
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <k_sum>:
  80:	xor    %eax,%eax
  82:	xor    %r8d,%r8d
  85:	jmp    a6 <k_sum+0x26>
  87:	mov    %r8,%r9
  8a:	movsd  (%rdi,%r9,8),%xmm1
  90:	ucomisd %xmm0,%xmm1
  94:	mov    %rdx,%r9
  97:	cmovne %rcx,%r9
  9b:	cmovp  %rcx,%r9
  9f:	add    %r9,%rax
  a2:	add    $0x1,%r8d
  a6:	cmp    %esi,%r8d
  a9:	jl     87 <k_sum+0x7>
  ab:	ret
  ac:	int3
  ad:	int3
  ae:	int3
  af:	int3

00000000000000b0 <k_lt>:
  b0:	ucomisd %xmm0,%xmm1
  b4:	mov    %esi,%eax
  b6:	cmova  %edi,%eax
  b9:	ret
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <k_eq>:
  c0:	ucomisd %xmm1,%xmm0
  c4:	mov    %edi,%eax
  c6:	cmovne %esi,%eax
  c9:	cmovp  %esi,%eax
  cc:	ret
  cd:	int3
  ce:	int3
  cf:	int3

00000000000000d0 <k_ne>:
  d0:	ucomiss %xmm1,%xmm0
  d3:	mov    %esi,%eax
  d5:	cmovne %edi,%eax
  d8:	cmovp  %edi,%eax
  db:	ret
