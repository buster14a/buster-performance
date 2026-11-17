
k_always.o:     file format elf64-x86-64


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

0000000000000010 <k_best>:
  10:	mov    $0xffffffff,%eax
  15:	xor    %ecx,%ecx
  17:	jmp    32 <k_best+0x22>
  19:	mov    %rcx,%rdx
  1c:	movsd  (%rdi,%rdx,8),%xmm1
  21:	ucomisd %xmm0,%xmm1
  25:	mov    %eax,%r11d
  28:	cmove  %ecx,%eax
  2b:	cmovp  %r11d,%eax
  2f:	add    $0x1,%ecx
  32:	cmp    %esi,%ecx
  34:	jl     19 <k_best+0x9>
  36:	ret
  37:	int3
  38:	int3
  39:	int3
  3a:	int3
  3b:	int3
  3c:	int3
  3d:	int3
  3e:	int3
  3f:	int3

0000000000000040 <k_equal>:
  40:	xor    %eax,%eax
  42:	xor    %ecx,%ecx
  44:	jmp    68 <k_equal+0x28>
  46:	mov    %rcx,%rdx
  49:	movsd  (%rdi,%rdx,8),%xmm1
  4e:	lea    0x5(%rax),%rdx
  52:	add    $0x1,%rax
  56:	ucomisd %xmm0,%xmm1
  5a:	mov    %rax,%r11
  5d:	cmove  %rdx,%rax
  61:	cmovp  %r11,%rax
  65:	add    $0x1,%ecx
  68:	cmp    %esi,%ecx
  6a:	jl     46 <k_equal+0x6>
  6c:	ret
  6d:	int3
  6e:	int3
  6f:	int3

0000000000000070 <k_sum>:
  70:	xor    %eax,%eax
  72:	xor    %r8d,%r8d
  75:	jmp    96 <k_sum+0x26>
  77:	mov    %r8,%r9
  7a:	movsd  (%rdi,%r9,8),%xmm1
  80:	ucomisd %xmm0,%xmm1
  84:	mov    %rdx,%r9
  87:	cmovne %rcx,%r9
  8b:	cmovp  %rcx,%r9
  8f:	add    %r9,%rax
  92:	add    $0x1,%r8d
  96:	cmp    %esi,%r8d
  99:	jl     77 <k_sum+0x7>
  9b:	ret
  9c:	int3
  9d:	int3
  9e:	int3
  9f:	int3

00000000000000a0 <k_lt>:
  a0:	ucomisd %xmm0,%xmm1
  a4:	mov    %esi,%eax
  a6:	cmova  %edi,%eax
  a9:	ret
  aa:	int3
  ab:	int3
  ac:	int3
  ad:	int3
  ae:	int3
  af:	int3

00000000000000b0 <k_eq>:
  b0:	ucomisd %xmm1,%xmm0
  b4:	mov    %edi,%eax
  b6:	cmovne %esi,%eax
  b9:	cmovp  %esi,%eax
  bc:	ret
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <k_ne>:
  c0:	ucomiss %xmm1,%xmm0
  c3:	mov    %esi,%eax
  c5:	cmovne %edi,%eax
  c8:	cmovp  %edi,%eax
  cb:	ret
