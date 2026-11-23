
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
  52:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)

0000000000000060 <k_init>:
  60:	mov    %esi,%ecx
  62:	and    $0x7,%ecx
  65:	lea    0x8(,%rsi,8),%eax
  6c:	mov    %eax,%edx
  6e:	and    $0x3f8,%edx
  74:	or     %ecx,%edx
  76:	mov    %esi,%ecx
  78:	shl    $0xa,%ecx
  7b:	add    $0x800,%ecx
  81:	and    $0x7ffc00,%ecx
  87:	shl    $0x17,%esi
  8a:	or     %ecx,%esi
  8c:	lea    (%rsi,%rdx,1),%ecx
  8f:	add    $0x1800000,%ecx
  95:	mov    %ecx,(%rdi)
  97:	shr    $0x3,%eax
  9a:	and    $0x7f,%eax
  9d:	ret
  9e:	xchg   %ax,%ax

00000000000000a0 <k_union>:
  a0:	movzbl (%rdi),%eax
  a3:	and    $0x7,%eax
  a6:	mov    (%rdi),%ecx
  a8:	add    %ecx,%eax
  aa:	and    $0x1ffff,%eax
  af:	and    $0xfffe0000,%ecx
  b5:	or     %eax,%ecx
  b7:	mov    %ecx,(%rdi)
  b9:	mov    (%rdi),%rcx
  bc:	add    %rcx,%rax
  bf:	movabs $0xffffffffff,%rdx
  c9:	and    %rax,%rdx
  cc:	movabs $0xffffff0000000000,%rsi
  d6:	and    %rcx,%rsi
  d9:	or     %rdx,%rsi
  dc:	mov    %rsi,(%rdi)
  df:	mov    %eax,%ecx
  e1:	and    $0x7,%ecx
  e4:	and    $0x1ffff,%eax
  e9:	add    %ecx,%eax
  eb:	ret
  ec:	nopl   0x0(%rax)

00000000000000f0 <k_ms>:
  f0:	mov    (%rdi),%eax
  f2:	mov    %eax,%edx
  f4:	and    $0x7,%edx
  f7:	lea    (%rax,%rdx,8),%ecx
  fa:	mov    %ecx,%esi
  fc:	and    $0x3f8,%esi
 102:	and    $0xfffffc07,%eax
 107:	or     %esi,%eax
 109:	mov    %eax,(%rdi)
 10b:	movzbl 0x6(%rdi),%eax
 10f:	and    $0xf,%eax
 112:	movzwl 0x4(%rdi),%esi
 116:	mov    %esi,%r8d
 119:	and    $0x1f,%r8d
 11d:	xor    %eax,%r8d
 120:	and    $0xffffffe0,%esi
 123:	or     %r8d,%esi
 126:	mov    %si,0x4(%rdi)
 12a:	shr    $0x3,%ecx
 12d:	and    $0x7f,%ecx
 130:	add    %edx,%eax
 132:	add    %r8d,%eax
 135:	add    %ecx,%eax
 137:	ret
 138:	nopl   0x0(%rax,%rax,1)

0000000000000140 <k_wide>:
 140:	mov    0x8(%rdi),%esi
 143:	mov    (%rdi),%rcx
 146:	mov    %rcx,%rax
 149:	shr    $0x1e,%rax
 14d:	add    %ecx,%eax
 14f:	mov    %ecx,%edx
 151:	shrd   $0x3c,%rsi,%rcx
 156:	and    $0xfc000000,%esi
 15c:	and    $0x3fffffff,%edx
 162:	xor    %eax,%ecx
 164:	mov    %ecx,%r8d
 167:	and    $0x3fffffff,%r8d
 16e:	mov    %eax,%r9d
 171:	and    $0x3fffffff,%eax
 176:	add    %edx,%eax
 178:	add    %r8d,%eax
 17b:	shr    $0x4,%r8d
 17f:	or     %esi,%r8d
 182:	shl    $0x3c,%rcx
 186:	and    $0x3fffffff,%r9d
 18d:	shl    $0x1e,%r9
 191:	or     %rdx,%r9
 194:	or     %rcx,%r9
 197:	mov    %r8d,0x8(%rdi)
 19b:	mov    %r9,(%rdi)
 19e:	ret
