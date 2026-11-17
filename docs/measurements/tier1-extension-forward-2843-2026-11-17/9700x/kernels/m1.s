
m1.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_one>:
   0:	xor    %eax,%eax
   2:	xor    %ecx,%ecx
   4:	jmp    20 <k_one+0x20>
   6:	movslq (%rdi,%rcx,4),%rdx
   a:	mov    %rdx,%r8
   d:	mov    $0x1,%r9d
  13:	test   %edx,%edx
  15:	cmovg  %r8,%r9
  19:	add    %r9,%rax
  1c:	add    $0x1,%rcx
  20:	cmp    %rsi,%rcx
  23:	jl     6 <k_one+0x6>
  25:	ret
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

0000000000000030 <k_unsigned>:
  30:	xor    %eax,%eax
  32:	xor    %ecx,%ecx
  34:	jmp    50 <k_unsigned+0x20>
  36:	mov    (%rdi,%rcx,4),%edx
  39:	mov    %rdx,%r8
  3c:	mov    $0x1,%r9d
  42:	cmp    $0x7,%edx
  45:	cmova  %r8,%r9
  49:	add    %r9,%rax
  4c:	add    $0x1,%rcx
  50:	cmp    %rsi,%rcx
  53:	jl     36 <k_unsigned+0x6>
  55:	ret
  56:	int3
  57:	int3
  58:	int3
  59:	int3
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <k_half>:
  60:	xor    %eax,%eax
  62:	xor    %ecx,%ecx
  64:	jmp    84 <k_half+0x24>
  66:	movzwl (%rdi,%rcx,2),%edx
  6a:	mov    %rdx,%r8
  6d:	mov    $0x2,%r9d
  73:	cmp    $0x12c,%edx
  79:	cmovg  %r8,%r9
  7d:	add    %r9,%rax
  80:	add    $0x1,%rcx
  84:	cmp    %rsi,%rcx
  87:	jl     66 <k_half+0x6>
  89:	ret
  8a:	int3
  8b:	int3
  8c:	int3
  8d:	int3
  8e:	int3
  8f:	int3

0000000000000090 <k_both>:
  90:	xor    %eax,%eax
  92:	xor    %ecx,%ecx
  94:	jmp    b2 <k_both+0x22>
  96:	mov    (%rdi,%rcx,4),%edx
  99:	mov    $0x1,%r8d
  9f:	mov    $0x2,%r9d
  a5:	test   %edx,%edx
  a7:	cmovg  %r8,%r9
  ab:	add    %r9,%rax
  ae:	add    $0x1,%rcx
  b2:	cmp    %rsi,%rcx
  b5:	jl     96 <k_both+0x6>
  b7:	ret
  b8:	int3
  b9:	int3
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <k_logic>:
  c0:	xor    %eax,%eax
  c2:	xor    %ecx,%ecx
  c4:	jmp    e6 <k_logic+0x26>
  c6:	mov    (%rdi,%rcx,4),%edx
  c9:	xor    %r8d,%r8d
  cc:	cmp    $0x3e8,%edx
  d2:	setl   %r8b
  d6:	xor    %r9d,%r9d
  d9:	test   %edx,%edx
  db:	cmovg  %r8,%r9
  df:	add    %r9,%rax
  e2:	add    $0x1,%rcx
  e6:	cmp    %rsi,%rcx
  e9:	jl     c6 <k_logic+0x6>
  eb:	ret
