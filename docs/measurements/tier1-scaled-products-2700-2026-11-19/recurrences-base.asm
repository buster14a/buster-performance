SCALE=2

object:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <kernel>:
   0:	xor    %eax,%eax
   2:	mov    %rsi,%rcx
   5:	mov    %rax,%rsi
   8:	mov    %rdi,%rax
   b:	jmp    1b <kernel+0x1b>
   d:	shl    $1,%eax
   f:	add    %ecx,%eax
  11:	mov    %eax,%edi
  13:	shr    $0x7,%edi
  16:	xor    %edi,%ecx
  18:	add    $0x1,%esi
  1b:	cmp    %edx,%esi
  1d:	jb     d <kernel+0xd>
  1f:	xor    %ecx,%eax
  21:	ret
SCALE=4

object:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <kernel>:
   0:	xor    %eax,%eax
   2:	mov    %rsi,%rcx
   5:	mov    %rax,%rsi
   8:	mov    %rdi,%rax
   b:	jmp    21 <kernel+0x21>
   d:	shl    $0x2,%rax
  11:	add    %rcx,%rax
  14:	mov    %rax,%rdi
  17:	shr    $0x7,%rdi
  1b:	xor    %rdi,%rcx
  1e:	add    $0x1,%esi
  21:	cmp    %edx,%esi
  23:	jb     d <kernel+0xd>
  25:	xor    %rcx,%rax
  28:	ret
SCALE=8

object:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <kernel>:
   0:	xor    %eax,%eax
   2:	mov    %rsi,%rcx
   5:	mov    %rax,%rsi
   8:	mov    %rdi,%rax
   b:	jmp    21 <kernel+0x21>
   d:	shl    $0x3,%rax
  11:	add    %rcx,%rax
  14:	mov    %rax,%rdi
  17:	shr    $0x7,%rdi
  1b:	xor    %rdi,%rcx
  1e:	add    $0x1,%esi
  21:	cmp    %edx,%esi
  23:	jb     d <kernel+0xd>
  25:	xor    %rcx,%rax
  28:	ret
