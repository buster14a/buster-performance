
out/k-head-tier0.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	mov    %rdi,%rsi
   3:	mov    %rsi,%rax
   6:	mov    (%rax),%eax
   8:	mov    %eax,%eax
   a:	shl    $0x36,%rax
   e:	shr    $0x39,%rax
  12:	mov    %rdi,%rcx
  15:	mov    (%rcx),%ecx
  17:	mov    %ecx,%ecx
  19:	shl    $0x3d,%rcx
  1d:	shr    $0x3d,%rcx
  21:	add    %ecx,%eax
  23:	mov    %eax,%eax
  25:	and    $0x7f,%rax
  29:	mov    %rax,%r9
  2c:	mov    %rsi,%rax
  2f:	mov    %rsi,%rcx
  32:	mov    (%rcx),%ecx
  34:	mov    %ecx,%ecx
  36:	and    $0xfffffffffffffc07,%rcx
  3d:	mov    %r9,%rdx
  40:	shl    $0x3,%rdx
  44:	or     %rdx,%rcx
  47:	mov    %ecx,(%rax)
  49:	mov    %rdi,%r8
  4c:	mov    %r8,%rax
  4f:	mov    (%rax),%eax
  51:	mov    %eax,%eax
  53:	shl    $0x29,%rax
  57:	shr    $0x33,%rax
  5b:	mov    %rdi,%rcx
  5e:	mov    (%rcx),%ecx
  60:	mov    %ecx,%ecx
  62:	shl    $0x20,%rcx
  66:	shr    $0x37,%rcx
  6a:	xor    %ecx,%eax
  6c:	mov    %eax,%eax
  6e:	and    $0x1fff,%rax
  74:	mov    %rax,%r10
  77:	mov    %r8,%rax
  7a:	mov    %r8,%rcx
  7d:	mov    (%rcx),%ecx
  7f:	mov    %ecx,%ecx
  81:	and    $0xffffffffff8003ff,%rcx
  88:	mov    %r10,%rdx
  8b:	shl    $0xa,%rdx
  8f:	or     %rdx,%rcx
  92:	mov    %ecx,(%rax)
  94:	mov    %rdi,%rax
  97:	mov    (%rax),%eax
  99:	mov    %eax,%eax
  9b:	shl    $0x3d,%rax
  9f:	shr    $0x3d,%rax
  a3:	mov    %rdi,%rcx
  a6:	mov    (%rcx),%ecx
  a8:	mov    %ecx,%ecx
  aa:	shl    $0x36,%rcx
  ae:	shr    $0x39,%rcx
  b2:	add    %ecx,%eax
  b4:	mov    %rdi,%rcx
  b7:	mov    (%rcx),%ecx
  b9:	mov    %ecx,%ecx
  bb:	shl    $0x29,%rcx
  bf:	shr    $0x33,%rcx
  c3:	add    %ecx,%eax
  c5:	mov    %rdi,%rcx
  c8:	mov    (%rcx),%ecx
  ca:	mov    %ecx,%ecx
  cc:	shl    $0x20,%rcx
  d0:	shr    $0x37,%rcx
  d4:	add    %ecx,%eax
  d6:	ret
