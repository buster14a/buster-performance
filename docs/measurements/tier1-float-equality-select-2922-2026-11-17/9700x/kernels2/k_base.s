
k_base.o:     file format elf64-x86-64


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
  17:	jmp    39 <k_best+0x29>
  19:	mov    %rcx,%rdx
  1c:	movsd  (%rdi,%rdx,8),%xmm1
  21:	xor    %edx,%edx
  23:	ucomisd %xmm0,%xmm1
  27:	sete   %dl
  2a:	setnp  %r11b
  2e:	and    %r11b,%dl
  31:	test   %edx,%edx
  33:	cmovne %ecx,%eax
  36:	add    $0x1,%ecx
  39:	cmp    %esi,%ecx
  3b:	jl     19 <k_best+0x9>
  3d:	ret
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
  85:	jmp    b3 <k_sum+0x33>
  87:	mov    %r8,%r9
  8a:	movsd  (%rdi,%r9,8),%xmm1
  90:	xor    %r9d,%r9d
  93:	ucomisd %xmm0,%xmm1
  97:	sete   %r9b
  9b:	setnp  %r11b
  9f:	and    %r11b,%r9b
  a2:	test   %r9d,%r9d
  a5:	mov    %rcx,%r9
  a8:	cmovne %rdx,%r9
  ac:	add    %r9,%rax
  af:	add    $0x1,%r8d
  b3:	cmp    %esi,%r8d
  b6:	jl     87 <k_sum+0x7>
  b8:	ret
  b9:	int3
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <k_lt>:
  c0:	ucomisd %xmm0,%xmm1
  c4:	mov    %esi,%eax
  c6:	cmova  %edi,%eax
  c9:	ret
  ca:	int3
  cb:	int3
  cc:	int3
  cd:	int3
  ce:	int3
  cf:	int3

00000000000000d0 <k_eq>:
  d0:	xor    %eax,%eax
  d2:	ucomisd %xmm1,%xmm0
  d6:	sete   %al
  d9:	setnp  %r11b
  dd:	and    %r11b,%al
  e0:	test   %eax,%eax
  e2:	mov    %esi,%eax
  e4:	cmovne %edi,%eax
  e7:	ret
  e8:	int3
  e9:	int3
  ea:	int3
  eb:	int3
  ec:	int3
  ed:	int3
  ee:	int3
  ef:	int3

00000000000000f0 <k_ne>:
  f0:	xor    %eax,%eax
  f2:	ucomiss %xmm1,%xmm0
  f5:	setne  %al
  f8:	setp   %r11b
  fc:	or     %r11b,%al
  ff:	test   %eax,%eax
 101:	mov    %esi,%eax
 103:	cmovne %edi,%eax
 106:	ret
