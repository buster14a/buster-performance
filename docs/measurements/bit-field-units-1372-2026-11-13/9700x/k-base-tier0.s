
out/k-base-tier0.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	mov    %rdi,%rsi
   3:	mov    %rsi,%rax
   6:	movzwl (%rax),%eax
   9:	movzwl %ax,%eax
   c:	shl    $0x36,%rax
  10:	shr    $0x39,%rax
  14:	mov    %rdi,%rcx
  17:	movzbl (%rcx),%ecx
  1a:	movzbl %cl,%ecx
  1d:	shl    $0x3d,%rcx
  21:	shr    $0x3d,%rcx
  25:	add    %ecx,%eax
  27:	mov    %eax,%eax
  29:	and    $0x7f,%rax
  2d:	mov    %rax,%r9
  30:	mov    %rsi,%rax
  33:	mov    %rsi,%rcx
  36:	movzwl (%rcx),%ecx
  39:	movzwl %cx,%ecx
  3c:	and    $0xfffffffffffffc07,%rcx
  43:	mov    %r9,%rdx
  46:	shl    $0x3,%rdx
  4a:	or     %rdx,%rcx
  4d:	mov    %cx,(%rax)
  50:	mov    %rdi,%rax
  53:	inc    %rax
  56:	mov    %rax,%r8
  59:	mov    %r8,%rax
  5c:	movzwl (%rax),%eax
  5f:	movzwl %ax,%eax
  62:	shl    $0x31,%rax
  66:	shr    $0x33,%rax
  6a:	mov    %rdi,%rcx
  6d:	movzwl 0x2(%rcx),%ecx
  71:	movzwl %cx,%ecx
  74:	shl    $0x30,%rcx
  78:	shr    $0x37,%rcx
  7c:	xor    %ecx,%eax
  7e:	mov    %eax,%eax
  80:	and    $0x1fff,%rax
  86:	mov    %rax,%r10
  89:	mov    %r8,%rax
  8c:	mov    %r8,%rcx
  8f:	movzwl (%rcx),%ecx
  92:	movzwl %cx,%ecx
  95:	and    $0xffffffffffff8003,%rcx
  9c:	mov    %r10,%rdx
  9f:	shl    $0x2,%rdx
  a3:	or     %rdx,%rcx
  a6:	mov    %cx,(%rax)
  a9:	mov    %rdi,%rax
  ac:	movzbl (%rax),%eax
  af:	movzbl %al,%eax
  b2:	shl    $0x3d,%rax
  b6:	shr    $0x3d,%rax
  ba:	mov    %rdi,%rcx
  bd:	movzwl (%rcx),%ecx
  c0:	movzwl %cx,%ecx
  c3:	shl    $0x36,%rcx
  c7:	shr    $0x39,%rcx
  cb:	add    %ecx,%eax
  cd:	mov    %rdi,%rcx
  d0:	movzwl 0x1(%rcx),%ecx
  d4:	movzwl %cx,%ecx
  d7:	shl    $0x31,%rcx
  db:	shr    $0x33,%rcx
  df:	add    %ecx,%eax
  e1:	mov    %rdi,%rcx
  e4:	movzwl 0x2(%rcx),%ecx
  e8:	movzwl %cx,%ecx
  eb:	shl    $0x30,%rcx
  ef:	shr    $0x37,%rcx
  f3:	add    %ecx,%eax
  f5:	ret
