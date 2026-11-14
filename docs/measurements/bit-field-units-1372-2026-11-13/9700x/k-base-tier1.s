
out/k-base-tier1.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	movzwl (%rdi),%eax
   3:	shl    $0x36,%rax
   7:	shr    $0x39,%rax
   b:	movzbl (%rdi),%ecx
   e:	shl    $0x3d,%rcx
  12:	shr    $0x3d,%rcx
  16:	add    %ecx,%eax
  18:	and    $0x7f,%rax
  1c:	movzwl (%rdi),%ecx
  1f:	and    $0xfffffffffffffc07,%rcx
  26:	shl    $0x3,%rax
  2a:	or     %rcx,%rax
  2d:	mov    %ax,(%rdi)
  30:	movzwl 0x1(%rdi),%eax
  34:	shl    $0x31,%rax
  38:	shr    $0x33,%rax
  3c:	movzwl 0x2(%rdi),%ecx
  40:	shl    $0x30,%rcx
  44:	shr    $0x37,%rcx
  48:	xor    %ecx,%eax
  4a:	and    $0x1fff,%rax
  50:	movzwl 0x1(%rdi),%ecx
  54:	and    $0xffffffffffff8003,%rcx
  5b:	shl    $0x2,%rax
  5f:	or     %rcx,%rax
  62:	mov    %ax,0x1(%rdi)
  66:	movzbl (%rdi),%eax
  69:	shl    $0x3d,%rax
  6d:	shr    $0x3d,%rax
  71:	movzwl (%rdi),%ecx
  74:	shl    $0x36,%rcx
  78:	shr    $0x39,%rcx
  7c:	add    %ecx,%eax
  7e:	movzwl 0x1(%rdi),%ecx
  82:	shl    $0x31,%rcx
  86:	shr    $0x33,%rcx
  8a:	add    %ecx,%eax
  8c:	movzwl 0x2(%rdi),%ecx
  90:	shl    $0x30,%rcx
  94:	shr    $0x37,%rcx
  98:	add    %ecx,%eax
  9a:	ret
