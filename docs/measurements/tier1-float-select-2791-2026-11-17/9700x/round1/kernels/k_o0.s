
k_o0.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	push   %rbp
   1:	mov    %rsp,%rbp
   4:	movsd  %xmm0,-0x8(%rbp)
   9:	movsd  %xmm1,-0x10(%rbp)
   e:	mov    %edi,-0x14(%rbp)
  11:	mov    %esi,-0x18(%rbp)
  14:	mov    -0x14(%rbp),%eax
  17:	xor    -0x18(%rbp),%eax
  1a:	pop    %rbp
  1b:	ret
  1c:	nopl   0x0(%rax)

0000000000000020 <k_lt>:
  20:	push   %rbp
  21:	mov    %rsp,%rbp
  24:	movsd  %xmm0,-0x8(%rbp)
  29:	movsd  %xmm1,-0x10(%rbp)
  2e:	mov    %edi,-0x14(%rbp)
  31:	mov    %esi,-0x18(%rbp)
  34:	movsd  -0x8(%rbp),%xmm1
  39:	movsd  -0x10(%rbp),%xmm0
  3e:	ucomisd %xmm1,%xmm0
  42:	jbe    4c <k_lt+0x2c>
  44:	mov    -0x14(%rbp),%eax
  47:	mov    %eax,-0x1c(%rbp)
  4a:	jmp    52 <k_lt+0x32>
  4c:	mov    -0x18(%rbp),%eax
  4f:	mov    %eax,-0x1c(%rbp)
  52:	mov    -0x1c(%rbp),%eax
  55:	pop    %rbp
  56:	ret
  57:	nopw   0x0(%rax,%rax,1)

0000000000000060 <k_ge>:
  60:	push   %rbp
  61:	mov    %rsp,%rbp
  64:	movss  %xmm0,-0x4(%rbp)
  69:	movss  %xmm1,-0x8(%rbp)
  6e:	mov    %edi,-0xc(%rbp)
  71:	mov    %esi,-0x10(%rbp)
  74:	movss  -0x4(%rbp),%xmm0
  79:	ucomiss -0x8(%rbp),%xmm0
  7d:	jb     87 <k_ge+0x27>
  7f:	mov    -0xc(%rbp),%eax
  82:	mov    %eax,-0x14(%rbp)
  85:	jmp    8d <k_ge+0x2d>
  87:	mov    -0x10(%rbp),%eax
  8a:	mov    %eax,-0x14(%rbp)
  8d:	mov    -0x14(%rbp),%eax
  90:	pop    %rbp
  91:	ret
  92:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)

00000000000000a0 <k_nle>:
  a0:	push   %rbp
  a1:	mov    %rsp,%rbp
  a4:	movsd  %xmm0,-0x8(%rbp)
  a9:	movsd  %xmm1,-0x10(%rbp)
  ae:	mov    %rdi,-0x18(%rbp)
  b2:	mov    %rsi,-0x20(%rbp)
  b6:	movsd  -0x8(%rbp),%xmm1
  bb:	movsd  -0x10(%rbp),%xmm0
  c0:	ucomisd %xmm1,%xmm0
  c4:	jae    d0 <k_nle+0x30>
  c6:	mov    -0x18(%rbp),%rax
  ca:	mov    %rax,-0x28(%rbp)
  ce:	jmp    d8 <k_nle+0x38>
  d0:	mov    -0x20(%rbp),%rax
  d4:	mov    %rax,-0x28(%rbp)
  d8:	mov    -0x28(%rbp),%rax
  dc:	pop    %rbp
  dd:	ret
  de:	xchg   %ax,%ax

00000000000000e0 <k_eq>:
  e0:	push   %rbp
  e1:	mov    %rsp,%rbp
  e4:	movsd  %xmm0,-0x8(%rbp)
  e9:	movsd  %xmm1,-0x10(%rbp)
  ee:	mov    %edi,-0x14(%rbp)
  f1:	mov    %esi,-0x18(%rbp)
  f4:	movsd  -0x8(%rbp),%xmm0
  f9:	ucomisd -0x10(%rbp),%xmm0
  fe:	jne    10a <k_eq+0x2a>
 100:	jp     10a <k_eq+0x2a>
 102:	mov    -0x14(%rbp),%eax
 105:	mov    %eax,-0x1c(%rbp)
 108:	jmp    110 <k_eq+0x30>
 10a:	mov    -0x18(%rbp),%eax
 10d:	mov    %eax,-0x1c(%rbp)
 110:	mov    -0x1c(%rbp),%eax
 113:	pop    %rbp
 114:	ret
 115:	data16 cs nopw 0x0(%rax,%rax,1)

0000000000000120 <k_ne>:
 120:	push   %rbp
 121:	mov    %rsp,%rbp
 124:	movss  %xmm0,-0x4(%rbp)
 129:	movss  %xmm1,-0x8(%rbp)
 12e:	mov    %edi,-0xc(%rbp)
 131:	mov    %esi,-0x10(%rbp)
 134:	movss  -0x4(%rbp),%xmm0
 139:	ucomiss -0x8(%rbp),%xmm0
 13d:	jne    143 <k_ne+0x23>
 13f:	jp     143 <k_ne+0x23>
 141:	jmp    14b <k_ne+0x2b>
 143:	mov    -0xc(%rbp),%eax
 146:	mov    %eax,-0x14(%rbp)
 149:	jmp    151 <k_ne+0x31>
 14b:	mov    -0x10(%rbp),%eax
 14e:	mov    %eax,-0x14(%rbp)
 151:	mov    -0x14(%rbp),%eax
 154:	pop    %rbp
 155:	ret
 156:	cs nopw 0x0(%rax,%rax,1)

0000000000000160 <k_count>:
 160:	push   %rbp
 161:	mov    %rsp,%rbp
 164:	mov    %rdi,-0x8(%rbp)
 168:	mov    %esi,-0xc(%rbp)
 16b:	movsd  %xmm0,-0x18(%rbp)
 170:	movq   $0x0,-0x20(%rbp)
 178:	movl   $0x0,-0x24(%rbp)
 17f:	mov    -0x24(%rbp),%eax
 182:	cmp    -0xc(%rbp),%eax
 185:	jge    1c2 <k_count+0x62>
 187:	mov    -0x8(%rbp),%rax
 18b:	movslq -0x24(%rbp),%rcx
 18f:	movsd  (%rax,%rcx,8),%xmm0
 194:	ucomisd -0x18(%rbp),%xmm0
 199:	jbe    1a9 <k_count+0x49>
 19b:	mov    -0x20(%rbp),%rax
 19f:	add    $0x3,%rax
 1a3:	mov    %rax,-0x20(%rbp)
 1a7:	jmp    1b5 <k_count+0x55>
 1a9:	mov    -0x20(%rbp),%rax
 1ad:	sub    $0x1,%rax
 1b1:	mov    %rax,-0x20(%rbp)
 1b5:	jmp    1b7 <k_count+0x57>
 1b7:	mov    -0x24(%rbp),%eax
 1ba:	add    $0x1,%eax
 1bd:	mov    %eax,-0x24(%rbp)
 1c0:	jmp    17f <k_count+0x1f>
 1c2:	mov    -0x20(%rbp),%rax
 1c6:	pop    %rbp
 1c7:	ret
 1c8:	nopl   0x0(%rax,%rax,1)

00000000000001d0 <k_equal>:
 1d0:	push   %rbp
 1d1:	mov    %rsp,%rbp
 1d4:	mov    %rdi,-0x8(%rbp)
 1d8:	mov    %esi,-0xc(%rbp)
 1db:	movsd  %xmm0,-0x18(%rbp)
 1e0:	movq   $0x0,-0x20(%rbp)
 1e8:	movl   $0x0,-0x24(%rbp)
 1ef:	mov    -0x24(%rbp),%eax
 1f2:	cmp    -0xc(%rbp),%eax
 1f5:	jge    234 <k_equal+0x64>
 1f7:	mov    -0x8(%rbp),%rax
 1fb:	movslq -0x24(%rbp),%rcx
 1ff:	movsd  (%rax,%rcx,8),%xmm0
 204:	ucomisd -0x18(%rbp),%xmm0
 209:	jne    21b <k_equal+0x4b>
 20b:	jp     21b <k_equal+0x4b>
 20d:	mov    -0x20(%rbp),%rax
 211:	add    $0x5,%rax
 215:	mov    %rax,-0x20(%rbp)
 219:	jmp    227 <k_equal+0x57>
 21b:	mov    -0x20(%rbp),%rax
 21f:	add    $0x1,%rax
 223:	mov    %rax,-0x20(%rbp)
 227:	jmp    229 <k_equal+0x59>
 229:	mov    -0x24(%rbp),%eax
 22c:	add    $0x1,%eax
 22f:	mov    %eax,-0x24(%rbp)
 232:	jmp    1ef <k_equal+0x1f>
 234:	mov    -0x20(%rbp),%rax
 238:	pop    %rbp
 239:	ret
