
k_main.o:     file format elf64-x86-64


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
  56:	test   %eax,%eax
  58:	cmovne %ecx,%eax
  5b:	ret
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
  78:	test   %ecx,%ecx
  7a:	cmovne %ecx,%edx
  7d:	test   %eax,%eax
  7f:	cmovne %edx,%eax
  82:	ret
  83:	int3
  84:	int3
  85:	int3
  86:	int3
  87:	int3
  88:	int3
  89:	int3
  8a:	int3
  8b:	int3
  8c:	int3
  8d:	int3
  8e:	int3
  8f:	int3

0000000000000090 <k_andori>:
  90:	xor    %eax,%eax
  92:	cmp    %esi,%edi
  94:	setl   %al
  97:	xor    %ecx,%ecx
  99:	cmp    %edx,%esi
  9b:	setl   %cl
  9e:	test   %edx,%edx
  a0:	mov    $0x0,%edx
  a5:	sete   %dl
  a8:	test   %ecx,%ecx
  aa:	cmovne %ecx,%edx
  ad:	xor    %ecx,%ecx
  af:	test   %eax,%eax
  b1:	mov    %ecx,%eax
  b3:	cmovne %edx,%eax
  b6:	ret
