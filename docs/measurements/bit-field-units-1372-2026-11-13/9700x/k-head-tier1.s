
out/k-head-tier1.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	mov    (%rdi),%eax
   2:	shl    $0x36,%rax
   6:	shr    $0x39,%rax
   a:	mov    (%rdi),%ecx
   c:	shl    $0x3d,%rcx
  10:	shr    $0x3d,%rcx
  14:	add    %ecx,%eax
  16:	and    $0x7f,%rax
  1a:	mov    (%rdi),%ecx
  1c:	and    $0xfffffffffffffc07,%rcx
  23:	shl    $0x3,%rax
  27:	or     %rcx,%rax
  2a:	mov    %eax,(%rdi)
  2c:	mov    (%rdi),%eax
  2e:	shl    $0x29,%rax
  32:	shr    $0x33,%rax
  36:	mov    (%rdi),%ecx
  38:	shl    $0x20,%rcx
  3c:	shr    $0x37,%rcx
  40:	xor    %ecx,%eax
  42:	and    $0x1fff,%rax
  48:	mov    (%rdi),%ecx
  4a:	and    $0xffffffffff8003ff,%rcx
  51:	shl    $0xa,%rax
  55:	or     %rcx,%rax
  58:	mov    %eax,(%rdi)
  5a:	mov    (%rdi),%eax
  5c:	shl    $0x3d,%rax
  60:	shr    $0x3d,%rax
  64:	mov    (%rdi),%ecx
  66:	shl    $0x36,%rcx
  6a:	shr    $0x39,%rcx
  6e:	add    %ecx,%eax
  70:	mov    (%rdi),%ecx
  72:	shl    $0x29,%rcx
  76:	shr    $0x33,%rcx
  7a:	add    %ecx,%eax
  7c:	mov    (%rdi),%ecx
  7e:	shl    $0x20,%rcx
  82:	shr    $0x37,%rcx
  86:	add    %ecx,%eax
  88:	ret
