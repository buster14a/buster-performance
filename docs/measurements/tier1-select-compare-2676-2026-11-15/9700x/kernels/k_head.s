
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
  10:	cmp    %esi,%edi
  12:	mov    %esi,%eax
  14:	cmovg  %edi,%eax
  17:	ret
  18:	int3
  19:	int3
  1a:	int3
  1b:	int3
  1c:	int3
  1d:	int3
  1e:	int3
  1f:	int3

0000000000000020 <k_clamp>:
  20:	xor    %eax,%eax
  22:	mov    $0xff,%ecx
  27:	cmp    $0xff,%edi
  2d:	cmovle %edi,%ecx
  30:	test   %edi,%edi
  32:	cmovge %ecx,%eax
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

0000000000000090 <k_condsum>:
  90:	xor    %eax,%eax
  92:	xor    %ecx,%ecx
  94:	jmp    b3 <k_condsum+0x23>
  96:	mov    %rcx,%rdx
  99:	movslq (%rdi,%rdx,4),%rdx
  9d:	xor    %r8d,%r8d
  a0:	mov    %rdx,%r9
  a3:	cmp    $0x80,%edx
  a9:	cmovg  %r9,%r8
  ad:	add    %r8,%rax
  b0:	add    $0x1,%ecx
  b3:	cmp    %esi,%ecx
  b5:	jl     96 <k_condsum+0x6>
  b7:	ret
  b8:	int3
  b9:	int3
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <k_abssum>:
  c0:	xor    %eax,%eax
  c2:	xor    %ecx,%ecx
  c4:	jmp    e6 <k_abssum+0x26>
  c6:	mov    %rcx,%rdx
  c9:	movslq (%rdi,%rdx,4),%rdx
  cd:	mov    %edx,%r8d
  d0:	neg    %r8d
  d3:	cmp    $0x80,%edx
  d9:	cmovg  %edx,%r8d
  dd:	movslq %r8d,%rdx
  e0:	add    %rdx,%rax
  e3:	add    $0x1,%ecx
  e6:	cmp    %esi,%ecx
  e8:	jl     c6 <k_abssum+0x6>
  ea:	ret
  eb:	int3
  ec:	int3
  ed:	int3
  ee:	int3
  ef:	int3

00000000000000f0 <k_runmax>:
  f0:	xor    %eax,%eax
  f2:	xor    %ecx,%ecx
  f4:	jmp    f9 <k_runmax+0x9>
  f6:	add    $0x1,%ecx
  f9:	cmp    %esi,%ecx
  fb:	jge    10d <k_runmax+0x1d>
  fd:	mov    %rcx,%rdx
 100:	cmp    (%rdi,%rdx,4),%eax
 103:	jge    f6 <k_runmax+0x6>
 105:	mov    %rcx,%rax
 108:	mov    (%rdi,%rax,4),%eax
 10b:	jmp    f6 <k_runmax+0x6>
 10d:	ret
