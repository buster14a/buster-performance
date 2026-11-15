
k_o0.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	push   %rbp
   1:	mov    %rsp,%rbp
   4:	mov    %edi,-0x4(%rbp)
   7:	mov    %esi,-0x8(%rbp)
   a:	mov    -0x4(%rbp),%eax
   d:	xor    -0x8(%rbp),%eax
  10:	pop    %rbp
  11:	ret
  12:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)

0000000000000020 <k_max>:
  20:	push   %rbp
  21:	mov    %rsp,%rbp
  24:	mov    %edi,-0x4(%rbp)
  27:	mov    %esi,-0x8(%rbp)
  2a:	mov    -0x4(%rbp),%eax
  2d:	cmp    -0x8(%rbp),%eax
  30:	jle    3a <k_max+0x1a>
  32:	mov    -0x4(%rbp),%eax
  35:	mov    %eax,-0xc(%rbp)
  38:	jmp    40 <k_max+0x20>
  3a:	mov    -0x8(%rbp),%eax
  3d:	mov    %eax,-0xc(%rbp)
  40:	mov    -0xc(%rbp),%eax
  43:	pop    %rbp
  44:	ret
  45:	data16 cs nopw 0x0(%rax,%rax,1)

0000000000000050 <k_clamp>:
  50:	push   %rbp
  51:	mov    %rsp,%rbp
  54:	mov    %edi,-0x4(%rbp)
  57:	cmpl   $0x0,-0x4(%rbp)
  5b:	jge    64 <k_clamp+0x14>
  5d:	xor    %eax,%eax
  5f:	mov    %eax,-0x8(%rbp)
  62:	jmp    83 <k_clamp+0x33>
  64:	cmpl   $0xff,-0x4(%rbp)
  6b:	jle    77 <k_clamp+0x27>
  6d:	mov    $0xff,%eax
  72:	mov    %eax,-0xc(%rbp)
  75:	jmp    7d <k_clamp+0x2d>
  77:	mov    -0x4(%rbp),%eax
  7a:	mov    %eax,-0xc(%rbp)
  7d:	mov    -0xc(%rbp),%eax
  80:	mov    %eax,-0x8(%rbp)
  83:	mov    -0x8(%rbp),%eax
  86:	pop    %rbp
  87:	ret
  88:	nopl   0x0(%rax,%rax,1)

0000000000000090 <k_and>:
  90:	push   %rbp
  91:	mov    %rsp,%rbp
  94:	mov    %edi,-0x4(%rbp)
  97:	mov    %esi,-0x8(%rbp)
  9a:	xor    %eax,%eax
  9c:	cmpl   $0x80,-0x4(%rbp)
  a3:	mov    %al,-0x9(%rbp)
  a6:	jge    b5 <k_and+0x25>
  a8:	cmpl   $0x80,-0x8(%rbp)
  af:	setl   %al
  b2:	mov    %al,-0x9(%rbp)
  b5:	mov    -0x9(%rbp),%al
  b8:	and    $0x1,%al
  ba:	pop    %rbp
  bb:	ret
  bc:	nopl   0x0(%rax)

00000000000000c0 <k_andor>:
  c0:	push   %rbp
  c1:	mov    %rsp,%rbp
  c4:	mov    %edi,-0x4(%rbp)
  c7:	mov    %esi,-0x8(%rbp)
  ca:	mov    %edx,-0xc(%rbp)
  cd:	mov    -0x4(%rbp),%ecx
  d0:	xor    %eax,%eax
  d2:	cmp    -0x8(%rbp),%ecx
  d5:	mov    %al,-0xd(%rbp)
  d8:	jge    f7 <k_andor+0x37>
  da:	mov    -0x8(%rbp),%ecx
  dd:	mov    $0x1,%al
  df:	cmp    -0xc(%rbp),%ecx
  e2:	mov    %al,-0xe(%rbp)
  e5:	jl     f1 <k_andor+0x31>
  e7:	cmpl   $0x0,-0xc(%rbp)
  eb:	sete   %al
  ee:	mov    %al,-0xe(%rbp)
  f1:	mov    -0xe(%rbp),%al
  f4:	mov    %al,-0xd(%rbp)
  f7:	mov    -0xd(%rbp),%al
  fa:	and    $0x1,%al
  fc:	pop    %rbp
  fd:	ret
  fe:	xchg   %ax,%ax

0000000000000100 <k_condsum>:
 100:	push   %rbp
 101:	mov    %rsp,%rbp
 104:	mov    %rdi,-0x8(%rbp)
 108:	mov    %esi,-0xc(%rbp)
 10b:	movq   $0x0,-0x18(%rbp)
 113:	movl   $0x0,-0x1c(%rbp)
 11a:	mov    -0x1c(%rbp),%eax
 11d:	cmp    -0xc(%rbp),%eax
 120:	jge    154 <k_condsum+0x54>
 122:	mov    -0x8(%rbp),%rax
 126:	movslq -0x1c(%rbp),%rcx
 12a:	cmpl   $0x80,(%rax,%rcx,4)
 131:	jle    147 <k_condsum+0x47>
 133:	mov    -0x8(%rbp),%rax
 137:	movslq -0x1c(%rbp),%rcx
 13b:	movslq (%rax,%rcx,4),%rax
 13f:	add    -0x18(%rbp),%rax
 143:	mov    %rax,-0x18(%rbp)
 147:	jmp    149 <k_condsum+0x49>
 149:	mov    -0x1c(%rbp),%eax
 14c:	add    $0x1,%eax
 14f:	mov    %eax,-0x1c(%rbp)
 152:	jmp    11a <k_condsum+0x1a>
 154:	mov    -0x18(%rbp),%rax
 158:	pop    %rbp
 159:	ret
 15a:	nopw   0x0(%rax,%rax,1)

0000000000000160 <k_abssum>:
 160:	push   %rbp
 161:	mov    %rsp,%rbp
 164:	mov    %rdi,-0x8(%rbp)
 168:	mov    %esi,-0xc(%rbp)
 16b:	movq   $0x0,-0x18(%rbp)
 173:	movl   $0x0,-0x1c(%rbp)
 17a:	mov    -0x1c(%rbp),%eax
 17d:	cmp    -0xc(%rbp),%eax
 180:	jge    1cb <k_abssum+0x6b>
 182:	mov    -0x8(%rbp),%rax
 186:	movslq -0x1c(%rbp),%rcx
 18a:	cmpl   $0x80,(%rax,%rcx,4)
 191:	jle    1a3 <k_abssum+0x43>
 193:	mov    -0x8(%rbp),%rax
 197:	movslq -0x1c(%rbp),%rcx
 19b:	mov    (%rax,%rcx,4),%eax
 19e:	mov    %eax,-0x20(%rbp)
 1a1:	jmp    1b3 <k_abssum+0x53>
 1a3:	mov    -0x8(%rbp),%rcx
 1a7:	movslq -0x1c(%rbp),%rdx
 1ab:	xor    %eax,%eax
 1ad:	sub    (%rcx,%rdx,4),%eax
 1b0:	mov    %eax,-0x20(%rbp)
 1b3:	mov    -0x20(%rbp),%eax
 1b6:	cltq
 1b8:	add    -0x18(%rbp),%rax
 1bc:	mov    %rax,-0x18(%rbp)
 1c0:	mov    -0x1c(%rbp),%eax
 1c3:	add    $0x1,%eax
 1c6:	mov    %eax,-0x1c(%rbp)
 1c9:	jmp    17a <k_abssum+0x1a>
 1cb:	mov    -0x18(%rbp),%rax
 1cf:	pop    %rbp
 1d0:	ret
 1d1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)

00000000000001e0 <k_runmax>:
 1e0:	push   %rbp
 1e1:	mov    %rsp,%rbp
 1e4:	mov    %rdi,-0x8(%rbp)
 1e8:	mov    %esi,-0xc(%rbp)
 1eb:	movl   $0x0,-0x10(%rbp)
 1f2:	movl   $0x0,-0x14(%rbp)
 1f9:	mov    -0x14(%rbp),%eax
 1fc:	cmp    -0xc(%rbp),%eax
 1ff:	jge    238 <k_runmax+0x58>
 201:	mov    -0x8(%rbp),%rax
 205:	movslq -0x14(%rbp),%rcx
 209:	mov    (%rax,%rcx,4),%eax
 20c:	cmp    -0x10(%rbp),%eax
 20f:	jle    221 <k_runmax+0x41>
 211:	mov    -0x8(%rbp),%rax
 215:	movslq -0x14(%rbp),%rcx
 219:	mov    (%rax,%rcx,4),%eax
 21c:	mov    %eax,-0x18(%rbp)
 21f:	jmp    227 <k_runmax+0x47>
 221:	mov    -0x10(%rbp),%eax
 224:	mov    %eax,-0x18(%rbp)
 227:	mov    -0x18(%rbp),%eax
 22a:	mov    %eax,-0x10(%rbp)
 22d:	mov    -0x14(%rbp),%eax
 230:	add    $0x1,%eax
 233:	mov    %eax,-0x14(%rbp)
 236:	jmp    1f9 <k_runmax+0x19>
 238:	mov    -0x10(%rbp),%eax
 23b:	pop    %rbp
 23c:	ret
