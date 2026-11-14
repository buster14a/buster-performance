
out/k-clang-O2.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	mov    (%rdi),%eax
   2:	mov    %eax,%edx
   4:	and    $0x7,%edx
   7:	lea    (%rax,%rdx,8),%ecx
   a:	mov    %ecx,%esi
   c:	and    $0x3f8,%esi
  12:	mov    %eax,%r8d
  15:	and    $0xff800007,%r8d
  1c:	or     %esi,%r8d
  1f:	mov    %eax,%esi
  21:	shr    $0xd,%esi
  24:	and    $0x7fc00,%esi
  2a:	mov    %eax,%r9d
  2d:	and    $0x7ffc00,%r9d
  34:	xor    %esi,%r9d
  37:	or     %r9d,%r8d
  3a:	mov    %r8d,(%rdi)
  3d:	shr    $0x3,%ecx
  40:	and    $0x7f,%ecx
  43:	shr    $0xa,%r9d
  47:	shr    $0x17,%eax
  4a:	add    %edx,%eax
  4c:	add    %r9d,%eax
  4f:	add    %ecx,%eax
  51:	ret
