
k_o2.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	mov    %edi,%eax
   2:	xor    %esi,%eax
   4:	ret
   5:	nopl   (%rax)

0000000000000008 <k_max>:
   8:	mov    %esi,%eax
   a:	cmp    %esi,%edi
   c:	cmovg  %edi,%eax
   f:	ret

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

0000000000000070 <k_condsum>:
  70:	test   %esi,%esi
  72:	jle    8a <k_condsum+0x1a>
  74:	mov    %esi,%r8d
  77:	mov    %r8d,%ecx
  7a:	and    $0x3,%ecx
  7d:	xor    %edx,%edx
  7f:	cmp    $0x4,%esi
  82:	jae    8d <k_condsum+0x1d>
  84:	xor    %esi,%esi
  86:	xor    %eax,%eax
  88:	jmp    f5 <k_condsum+0x85>
  8a:	xor    %eax,%eax
  8c:	ret
  8d:	and    $0x7ffffffc,%r8d
  94:	xor    %esi,%esi
  96:	xor    %eax,%eax
  98:	nopl   0x0(%rax,%rax,1)
  a0:	mov    (%rdi,%rsi,4),%r9d
  a4:	mov    0x4(%rdi,%rsi,4),%r10d
  a9:	cmp    $0x81,%r9d
  b0:	cmovl  %edx,%r9d
  b4:	add    %r9,%rax
  b7:	cmp    $0x81,%r10d
  be:	cmovl  %edx,%r10d
  c2:	mov    0x8(%rdi,%rsi,4),%r9d
  c7:	cmp    $0x81,%r9d
  ce:	cmovl  %edx,%r9d
  d2:	add    %r10,%r9
  d5:	add    %rax,%r9
  d8:	mov    0xc(%rdi,%rsi,4),%eax
  dc:	cmp    $0x81,%eax
  e1:	cmovl  %edx,%eax
  e4:	add    %r9,%rax
  e7:	add    $0x4,%rsi
  eb:	cmp    %rsi,%r8
  ee:	jne    a0 <k_condsum+0x30>
  f0:	test   %rcx,%rcx
  f3:	je     11a <k_condsum+0xaa>
  f5:	lea    (%rdi,%rsi,4),%rsi
  f9:	xor    %edi,%edi
  fb:	nopl   0x0(%rax,%rax,1)
 100:	mov    (%rsi,%rdi,4),%r8d
 104:	cmp    $0x81,%r8d
 10b:	cmovl  %edx,%r8d
 10f:	add    %r8,%rax
 112:	inc    %rdi
 115:	cmp    %rdi,%rcx
 118:	jne    100 <k_condsum+0x90>
 11a:	ret
 11b:	nopl   0x0(%rax,%rax,1)

0000000000000120 <k_abssum>:
 120:	test   %esi,%esi
 122:	jle    12f <k_abssum+0xf>
 124:	cmp    $0x1,%esi
 127:	jne    132 <k_abssum+0x12>
 129:	xor    %ecx,%ecx
 12b:	xor    %eax,%eax
 12d:	jmp    186 <k_abssum+0x66>
 12f:	xor    %eax,%eax
 131:	ret
 132:	mov    %esi,%edx
 134:	mov    %edx,%esi
 136:	and    $0x7ffffffe,%esi
 13c:	xor    %ecx,%ecx
 13e:	xor    %eax,%eax
 140:	mov    (%rdi,%rcx,4),%r8d
 144:	mov    0x4(%rdi,%rcx,4),%r9d
 149:	mov    %r8d,%r10d
 14c:	neg    %r10d
 14f:	cmp    $0x81,%r8d
 156:	cmovge %r8d,%r10d
 15a:	movslq %r10d,%r8
 15d:	mov    %rax,%r10
 160:	add    %r8,%r10
 163:	mov    %r9d,%eax
 166:	neg    %eax
 168:	cmp    $0x81,%r9d
 16f:	cmovge %r9d,%eax
 173:	cltq
 175:	add    %r10,%rax
 178:	add    $0x2,%rcx
 17c:	cmp    %rcx,%rsi
 17f:	jne    140 <k_abssum+0x20>
 181:	test   $0x1,%dl
 184:	je     19e <k_abssum+0x7e>
 186:	mov    %rax,%rdx
 189:	mov    (%rdi,%rcx,4),%eax
 18c:	mov    %eax,%ecx
 18e:	neg    %ecx
 190:	cmp    $0x81,%eax
 195:	cmovge %eax,%ecx
 198:	movslq %ecx,%rax
 19b:	add    %rdx,%rax
 19e:	ret
 19f:	nop

00000000000001a0 <k_runmax>:
 1a0:	test   %esi,%esi
 1a2:	jle    1b8 <k_runmax+0x18>
 1a4:	mov    %esi,%r8d
 1a7:	mov    %r8d,%ecx
 1aa:	and    $0x3,%ecx
 1ad:	cmp    $0x4,%esi
 1b0:	jae    1bb <k_runmax+0x1b>
 1b2:	xor    %edx,%edx
 1b4:	xor    %eax,%eax
 1b6:	jmp    20e <k_runmax+0x6e>
 1b8:	xor    %eax,%eax
 1ba:	ret
 1bb:	and    $0x7ffffffc,%r8d
 1c2:	xor    %edx,%edx
 1c4:	xor    %eax,%eax
 1c6:	jmp    1d9 <k_runmax+0x39>
 1c8:	nopl   0x0(%rax,%rax,1)
 1d0:	add    $0x4,%rdx
 1d4:	cmp    %rdx,%r8
 1d7:	je     209 <k_runmax+0x69>
 1d9:	mov    (%rdi,%rdx,4),%r9d
 1dd:	mov    0x4(%rdi,%rdx,4),%esi
 1e1:	cmp    %eax,%r9d
 1e4:	cmovg  %r9d,%eax
 1e8:	cmp    %eax,%esi
 1ea:	jg     1ee <k_runmax+0x4e>
 1ec:	mov    %eax,%esi
 1ee:	mov    0x8(%rdi,%rdx,4),%r9d
 1f3:	cmp    %esi,%r9d
 1f6:	jg     1fb <k_runmax+0x5b>
 1f8:	mov    %esi,%r9d
 1fb:	mov    0xc(%rdi,%rdx,4),%eax
 1ff:	cmp    %r9d,%eax
 202:	jg     1d0 <k_runmax+0x30>
 204:	mov    %r9d,%eax
 207:	jmp    1d0 <k_runmax+0x30>
 209:	test   %rcx,%rcx
 20c:	je     230 <k_runmax+0x90>
 20e:	lea    (%rdi,%rdx,4),%rdx
 212:	xor    %esi,%esi
 214:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 220:	mov    (%rdx,%rsi,4),%edi
 223:	cmp    %eax,%edi
 225:	cmovg  %edi,%eax
 228:	inc    %rsi
 22b:	cmp    %rsi,%rcx
 22e:	jne    220 <k_runmax+0x80>
 230:	ret
