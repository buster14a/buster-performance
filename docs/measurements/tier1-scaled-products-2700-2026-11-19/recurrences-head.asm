SCALE=2

object:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <kernel>:
   0:	xor    %eax,%eax
   2:	mov    %rsi,%rcx
   5:	mov    %rax,%rsi
   8:	mov    %rdi,%rax
   b:	jmp    1a <kernel+0x1a>
   d:	lea    (%rcx,%rax,2),%eax
  10:	mov    %eax,%edi
  12:	shr    $0x7,%edi
  15:	xor    %edi,%ecx
  17:	add    $0x1,%esi
  1a:	cmp    %edx,%esi
  1c:	jb     d <kernel+0xd>
  1e:	xor    %ecx,%eax
  20:	ret
SCALE=4

object:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <kernel>:
   0:	xor    %eax,%eax
   2:	mov    %rsi,%rcx
   5:	mov    %rax,%rsi
   8:	mov    %rdi,%rax
   b:	jmp    1e <kernel+0x1e>
   d:	lea    (%rcx,%rax,4),%rax
  11:	mov    %rax,%rdi
  14:	shr    $0x7,%rdi
  18:	xor    %rdi,%rcx
  1b:	add    $0x1,%esi
  1e:	cmp    %edx,%esi
  20:	jb     d <kernel+0xd>
  22:	xor    %rcx,%rax
  25:	ret
SCALE=8

object:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <kernel>:
   0:	xor    %eax,%eax
   2:	mov    %rsi,%rcx
   5:	mov    %rax,%rsi
   8:	mov    %rdi,%rax
   b:	jmp    1e <kernel+0x1e>
   d:	lea    (%rcx,%rax,8),%rax
  11:	mov    %rax,%rdi
  14:	shr    $0x7,%rdi
  18:	xor    %rdi,%rcx
  1b:	add    $0x1,%esi
  1e:	cmp    %edx,%esi
  20:	jb     d <kernel+0xd>
  22:	xor    %rcx,%rax
  25:	ret
