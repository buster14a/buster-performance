
out/k-clang-O0.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	push   %rbp
   1:	mov    %rsp,%rbp
   4:	mov    %rdi,-0x8(%rbp)
   8:	mov    -0x8(%rbp),%rax
   c:	mov    (%rax),%ecx
   e:	and    $0x7,%ecx
  11:	mov    -0x8(%rbp),%rax
  15:	mov    (%rax),%edx
  17:	shr    $0x3,%edx
  1a:	and    $0x7f,%edx
  1d:	add    %ecx,%edx
  1f:	mov    (%rax),%ecx
  21:	and    $0x7f,%edx
  24:	shl    $0x3,%edx
  27:	and    $0xfffffc07,%ecx
  2d:	or     %edx,%ecx
  2f:	mov    %ecx,(%rax)
  31:	mov    -0x8(%rbp),%rax
  35:	mov    (%rax),%ecx
  37:	shr    $0x17,%ecx
  3a:	mov    -0x8(%rbp),%rax
  3e:	mov    (%rax),%edx
  40:	shr    $0xa,%edx
  43:	and    $0x1fff,%edx
  49:	xor    %ecx,%edx
  4b:	mov    (%rax),%ecx
  4d:	and    $0x1fff,%edx
  53:	shl    $0xa,%edx
  56:	and    $0xff8003ff,%ecx
  5c:	or     %edx,%ecx
  5e:	mov    %ecx,(%rax)
  60:	mov    -0x8(%rbp),%rax
  64:	mov    (%rax),%eax
  66:	and    $0x7,%eax
  69:	mov    -0x8(%rbp),%rcx
  6d:	mov    (%rcx),%ecx
  6f:	shr    $0x3,%ecx
  72:	and    $0x7f,%ecx
  75:	add    %ecx,%eax
  77:	mov    -0x8(%rbp),%rcx
  7b:	mov    (%rcx),%ecx
  7d:	shr    $0xa,%ecx
  80:	and    $0x1fff,%ecx
  86:	add    %ecx,%eax
  88:	mov    -0x8(%rbp),%rcx
  8c:	mov    (%rcx),%ecx
  8e:	shr    $0x17,%ecx
  91:	add    %ecx,%eax
  93:	pop    %rbp
  94:	ret
