
k_o2.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	mov    %edi,%eax
   2:	xor    %esi,%eax
   4:	ret
   5:	data16 cs nopw 0x0(%rax,%rax,1)

0000000000000010 <k_clamp>:
  10:	xor    %ecx,%ecx
  12:	test   %edi,%edi
  14:	cmovg  %edi,%ecx
  17:	cmp    $0xff,%ecx
  1d:	mov    $0xff,%eax
  22:	cmovl  %ecx,%eax
  25:	ret
  26:	cs nopw 0x0(%rax,%rax,1)

0000000000000030 <k_and>:
  30:	cmp    $0x80,%edi
  36:	setl   %cl
  39:	cmp    $0x80,%esi
  3f:	setl   %al
  42:	and    %cl,%al
  44:	ret
  45:	data16 cs nopw 0x0(%rax,%rax,1)

0000000000000050 <k_andor>:
  50:	cmp    %esi,%edi
  52:	setl   %cl
  55:	cmp    %edx,%esi
  57:	setl   %sil
  5b:	test   %edx,%edx
  5d:	sete   %al
  60:	or     %sil,%al
  63:	and    %cl,%al
  65:	ret
  66:	cs nopw 0x0(%rax,%rax,1)

0000000000000070 <k_andori>:
  70:	cmp    %esi,%edi
  72:	setl   %al
  75:	cmp    %edx,%esi
  77:	setl   %cl
  7a:	test   %edx,%edx
  7c:	sete   %dl
  7f:	or     %cl,%dl
  81:	and    %al,%dl
  83:	movzbl %dl,%eax
  86:	ret
