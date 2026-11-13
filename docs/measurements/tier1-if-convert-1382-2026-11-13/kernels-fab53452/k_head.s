
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

0000000000000010 <k_max>:
  10:	xor    %eax,%eax
  12:	cmp    %esi,%edi
  14:	setg   %al
  17:	test   %eax,%eax
  19:	mov    %esi,%eax
  1b:	cmovne %edi,%eax
  1e:	ret
  1f:	int3

0000000000000020 <k_clamp>:
  20:	xor    %eax,%eax
  22:	test   %edi,%edi
  24:	setl   %al
  27:	xor    %ecx,%ecx
  29:	xor    %edx,%edx
  2b:	cmp    $0xff,%edi
  31:	setg   %dl
  34:	mov    $0xff,%esi
  39:	test   %edx,%edx
  3b:	mov    %edi,%edx
  3d:	cmovne %esi,%edx
  40:	test   %eax,%eax
  42:	mov    %edx,%eax
  44:	cmovne %ecx,%eax
  47:	ret
  48:	int3
  49:	int3
  4a:	int3
  4b:	int3
  4c:	int3
  4d:	int3
  4e:	int3
  4f:	int3

0000000000000050 <k_and>:
  50:	xor    %eax,%eax
  52:	cmp    $0x80,%edi
  58:	setl   %al
  5b:	xor    %ecx,%ecx
  5d:	cmp    $0x80,%esi
  63:	setl   %cl
  66:	test   %eax,%eax
  68:	cmovne %ecx,%eax
  6b:	ret
  6c:	int3
  6d:	int3
  6e:	int3
  6f:	int3

0000000000000070 <k_andor>:
  70:	xor    %eax,%eax
  72:	cmp    %esi,%edi
  74:	setl   %al
  77:	xor    %ecx,%ecx
  79:	cmp    %edx,%esi
  7b:	setl   %cl
  7e:	test   %edx,%edx
  80:	mov    $0x0,%edx
  85:	sete   %dl
  88:	test   %ecx,%ecx
  8a:	cmove  %edx,%ecx
  8d:	test   %eax,%eax
  8f:	cmovne %ecx,%eax
  92:	ret
  93:	int3
  94:	int3
  95:	int3
  96:	int3
  97:	int3
  98:	int3
  99:	int3
  9a:	int3
  9b:	int3
  9c:	int3
  9d:	int3
  9e:	int3
  9f:	int3

00000000000000a0 <k_condsum>:
  a0:	xor    %eax,%eax
  a2:	xor    %ecx,%ecx
  a4:	jmp    ca <k_condsum+0x2a>
  a6:	mov    %rcx,%rdx
  a9:	movslq (%rdi,%rdx,4),%rdx
  ad:	xor    %r8d,%r8d
  b0:	cmp    $0x80,%edx
  b6:	setg   %r8b
  ba:	xor    %r9d,%r9d
  bd:	test   %r8d,%r8d
  c0:	cmove  %r9,%rdx
  c4:	add    %rdx,%rax
  c7:	add    $0x1,%ecx
  ca:	cmp    %esi,%ecx
  cc:	jl     a6 <k_condsum+0x6>
  ce:	ret
  cf:	int3

00000000000000d0 <k_abssum>:
  d0:	xor    %eax,%eax
  d2:	xor    %ecx,%ecx
  d4:	jmp    100 <k_abssum+0x30>
  d6:	mov    %rcx,%rdx
  d9:	movslq (%rdi,%rdx,4),%rdx
  dd:	xor    %r8d,%r8d
  e0:	cmp    $0x80,%edx
  e6:	setg   %r8b
  ea:	mov    %edx,%r9d
  ed:	neg    %r9d
  f0:	test   %r8d,%r8d
  f3:	cmove  %r9d,%edx
  f7:	movslq %edx,%rdx
  fa:	add    %rdx,%rax
  fd:	add    $0x1,%ecx
 100:	cmp    %esi,%ecx
 102:	jl     d6 <k_abssum+0x6>
 104:	ret
 105:	int3
 106:	int3
 107:	int3
 108:	int3
 109:	int3
 10a:	int3
 10b:	int3
 10c:	int3
 10d:	int3
 10e:	int3
 10f:	int3

0000000000000110 <k_runmax>:
 110:	xor    %eax,%eax
 112:	xor    %ecx,%ecx
 114:	jmp    119 <k_runmax+0x9>
 116:	add    $0x1,%ecx
 119:	cmp    %esi,%ecx
 11b:	jge    12d <k_runmax+0x1d>
 11d:	mov    %rcx,%rdx
 120:	cmp    (%rdi,%rdx,4),%eax
 123:	jge    116 <k_runmax+0x6>
 125:	mov    %rcx,%rax
 128:	mov    (%rdi,%rax,4),%eax
 12b:	jmp    116 <k_runmax+0x6>
 12d:	ret
