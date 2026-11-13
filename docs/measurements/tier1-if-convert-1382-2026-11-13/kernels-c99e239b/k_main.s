
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
  20:	test   %edi,%edi
  22:	jge    2b <k_clamp+0xb>
  24:	xor    %eax,%eax
  26:	mov    %rax,%rdi
  29:	jmp    3d <k_clamp+0x1d>
  2b:	cmp    $0xff,%edi
  31:	jle    3d <k_clamp+0x1d>
  33:	mov    $0xff,%eax
  38:	mov    %rax,%rdi
  3b:	jmp    3d <k_clamp+0x1d>
  3d:	mov    %edi,%eax
  3f:	ret

0000000000000040 <k_and>:
  40:	cmp    $0x80,%edi
  46:	jge    55 <k_and+0x15>
  48:	xor    %eax,%eax
  4a:	cmp    $0x80,%esi
  50:	setl   %al
  53:	jmp    57 <k_and+0x17>
  55:	xor    %eax,%eax
  57:	test   %eax,%eax
  59:	mov    $0x0,%eax
  5e:	setne  %al
  61:	ret
  62:	int3
  63:	int3
  64:	int3
  65:	int3
  66:	int3
  67:	int3
  68:	int3
  69:	int3
  6a:	int3
  6b:	int3
  6c:	int3
  6d:	int3
  6e:	int3
  6f:	int3

0000000000000070 <k_andor>:
  70:	cmp    %esi,%edi
  72:	jge    92 <k_andor+0x22>
  74:	cmp    %edx,%esi
  76:	jl     81 <k_andor+0x11>
  78:	xor    %eax,%eax
  7a:	test   %edx,%edx
  7c:	sete   %al
  7f:	jmp    86 <k_andor+0x16>
  81:	mov    $0x1,%eax
  86:	test   %eax,%eax
  88:	mov    $0x0,%eax
  8d:	setne  %al
  90:	jmp    94 <k_andor+0x24>
  92:	xor    %eax,%eax
  94:	test   %eax,%eax
  96:	mov    $0x0,%eax
  9b:	setne  %al
  9e:	ret
  9f:	int3

00000000000000a0 <k_condsum>:
  a0:	xor    %eax,%eax
  a2:	xor    %ecx,%ecx
  a4:	jmp    bf <k_condsum+0x1f>
  a6:	mov    %rcx,%rdx
  a9:	cmpl   $0x80,(%rdi,%rdx,4)
  b0:	jle    bc <k_condsum+0x1c>
  b2:	mov    %rcx,%rdx
  b5:	movslq (%rdi,%rdx,4),%rdx
  b9:	add    %rdx,%rax
  bc:	add    $0x1,%ecx
  bf:	cmp    %esi,%ecx
  c1:	jl     a6 <k_condsum+0x6>
  c3:	ret
  c4:	int3
  c5:	int3
  c6:	int3
  c7:	int3
  c8:	int3
  c9:	int3
  ca:	int3
  cb:	int3
  cc:	int3
  cd:	int3
  ce:	int3
  cf:	int3

00000000000000d0 <k_abssum>:
  d0:	xor    %eax,%eax
  d2:	xor    %ecx,%ecx
  d4:	jmp    e7 <k_abssum+0x17>
  d6:	mov    %rcx,%rdx
  d9:	mov    (%rdi,%rdx,4),%edx
  dc:	neg    %edx
  de:	movslq %edx,%rdx
  e1:	add    %rdx,%rax
  e4:	add    $0x1,%ecx
  e7:	cmp    %esi,%ecx
  e9:	jge    100 <k_abssum+0x30>
  eb:	mov    %rcx,%rdx
  ee:	cmpl   $0x80,(%rdi,%rdx,4)
  f5:	jle    d6 <k_abssum+0x6>
  f7:	mov    %rcx,%rdx
  fa:	movslq (%rdi,%rdx,4),%rdx
  fe:	jmp    de <k_abssum+0xe>
 100:	ret
 101:	int3
 102:	int3
 103:	int3
 104:	int3
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
