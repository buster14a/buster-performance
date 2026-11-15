
k_head.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	mov    %edi,%eax
   2:	xor    %esi,%eax
   4:	ret
   5:	int3
   6:	int3
   7:	int3
   8:	int3
   9:	int3
   a:	int3
   b:	int3
   c:	int3
   d:	int3
   e:	int3
   f:	int3

0000000000000010 <k_clamp>:
  10:	xor    %eax,%eax
  12:	test   %edi,%edi
  14:	setl   %al
  17:	xor    %ecx,%ecx
  19:	xor    %edx,%edx
  1b:	cmp    $0xff,%edi
  21:	setg   %dl
  24:	mov    $0xff,%esi
  29:	test   %edx,%edx
  2b:	cmovne %esi,%edi
  2e:	test   %eax,%eax
  30:	mov    %edi,%eax
  32:	cmovne %ecx,%eax
  35:	ret
  36:	int3
  37:	int3
  38:	int3
  39:	int3
  3a:	int3
  3b:	int3
  3c:	int3
  3d:	int3
  3e:	int3
  3f:	int3

0000000000000040 <k_and>:
  40:	xor    %eax,%eax
  42:	cmp    $0x80,%edi
  48:	setl   %al
  4b:	xor    %ecx,%ecx
  4d:	cmp    $0x80,%esi
  53:	setl   %cl
  56:	and    %ecx,%eax
  58:	ret
  59:	int3
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <k_andor>:
  60:	xor    %eax,%eax
  62:	cmp    %esi,%edi
  64:	setl   %al
  67:	xor    %ecx,%ecx
  69:	cmp    %edx,%esi
  6b:	setl   %cl
  6e:	test   %edx,%edx
  70:	mov    $0x0,%edx
  75:	sete   %dl
  78:	or     %edx,%ecx
  7a:	and    %ecx,%eax
  7c:	ret
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <k_andori>:
  80:	xor    %eax,%eax
  82:	cmp    %esi,%edi
  84:	setl   %al
  87:	xor    %ecx,%ecx
  89:	cmp    %edx,%esi
  8b:	setl   %cl
  8e:	test   %edx,%edx
  90:	mov    $0x0,%edx
  95:	sete   %dl
  98:	or     %edx,%ecx
  9a:	and    %ecx,%eax
  9c:	ret
