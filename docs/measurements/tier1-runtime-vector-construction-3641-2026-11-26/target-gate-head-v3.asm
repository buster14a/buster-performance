
/tmp/buster-3641-evidence/target-gate-head-v3.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <gate_lane0>:
   0:	push   %rbp
   1:	mov    %rsp,%rbp
   4:	sub    $0x40,%rsp
   8:	and    $0xffffffffffffffc0,%rsp
   c:	movq   $0x0,(%rsp)
  14:	movq   $0x0,0x8(%rsp)
  1d:	movq   $0x0,0x10(%rsp)
  26:	movq   $0x0,0x18(%rsp)
  2f:	movq   $0x0,0x20(%rsp)
  38:	movq   $0x0,0x28(%rsp)
  41:	movq   $0x0,0x30(%rsp)
  4a:	movq   $0x0,0x38(%rsp)
  53:	mov    %rsi,(%rsp)
  57:	vmovdqu (%rsp),%ymm0
  5c:	vmovdqu 0x20(%rsp),%ymm1
  62:	vmovdqu %ymm0,(%rdi)
  66:	vmovdqu %ymm1,0x20(%rdi)
  6b:	vzeroupper
  6e:	mov    %rbp,%rsp
  71:	pop    %rbp
  72:	ret
  73:	int3
  74:	int3
  75:	int3
  76:	int3
  77:	int3
  78:	int3
  79:	int3
  7a:	int3
  7b:	int3
  7c:	int3
  7d:	int3
  7e:	int3
  7f:	int3

0000000000000080 <gate_pair>:
  80:	push   %rbp
  81:	mov    %rsp,%rbp
  84:	sub    $0x40,%rsp
  88:	and    $0xffffffffffffffc0,%rsp
  8c:	movq   $0x0,(%rsp)
  94:	movq   $0x0,0x8(%rsp)
  9d:	movq   $0x0,0x10(%rsp)
  a6:	movq   $0x0,0x18(%rsp)
  af:	movq   $0x0,0x20(%rsp)
  b8:	movq   $0x0,0x28(%rsp)
  c1:	movq   $0x0,0x30(%rsp)
  ca:	movq   $0x0,0x38(%rsp)
  d3:	mov    %rsi,(%rsp)
  d7:	mov    %rdx,0x8(%rsp)
  dc:	mov    %rsi,0x10(%rsp)
  e1:	mov    %rdx,0x18(%rsp)
  e6:	mov    %rsi,0x20(%rsp)
  eb:	mov    %rdx,0x28(%rsp)
  f0:	mov    %rsi,0x30(%rsp)
  f5:	mov    %rdx,0x38(%rsp)
  fa:	vmovdqu (%rsp),%ymm0
  ff:	vmovdqu 0x20(%rsp),%ymm1
 105:	vmovdqu %ymm0,(%rdi)
 109:	vmovdqu %ymm1,0x20(%rdi)
 10e:	vzeroupper
 111:	mov    %rbp,%rsp
 114:	pop    %rbp
 115:	ret
 116:	int3
 117:	int3
 118:	int3
 119:	int3
 11a:	int3
 11b:	int3
 11c:	int3
 11d:	int3
 11e:	int3
 11f:	int3

0000000000000120 <gate_mixed>:
 120:	push   %rbp
 121:	mov    %rsp,%rbp
 124:	sub    $0x40,%rsp
 128:	and    $0xffffffffffffffc0,%rsp
 12c:	movq   $0x0,(%rsp)
 134:	movq   $0x0,0x8(%rsp)
 13d:	movq   $0x0,0x10(%rsp)
 146:	movq   $0x0,0x18(%rsp)
 14f:	movq   $0x0,0x20(%rsp)
 158:	movq   $0x0,0x28(%rsp)
 161:	movq   $0x0,0x30(%rsp)
 16a:	movq   $0x0,0x38(%rsp)
 173:	movabs $0x123456789abcdef,%rax
 17d:	mov    %rax,(%rsp)
 181:	mov    %rsi,0x8(%rsp)
 186:	movq   $0x0,0x10(%rsp)
 18f:	movq   $0xffffffffffffffff,0x18(%rsp)
 198:	mov    %rdx,0x20(%rsp)
 19d:	movabs $0x8000000000000000,%rax
 1a7:	mov    %rax,0x28(%rsp)
 1ac:	mov    %rsi,0x30(%rsp)
 1b1:	movq   $0x0,0x38(%rsp)
 1ba:	vmovdqu (%rsp),%ymm0
 1bf:	vmovdqu 0x20(%rsp),%ymm1
 1c5:	vmovdqu %ymm0,(%rdi)
 1c9:	vmovdqu %ymm1,0x20(%rdi)
 1ce:	vzeroupper
 1d1:	mov    %rbp,%rsp
 1d4:	pop    %rbp
 1d5:	ret
 1d6:	int3
 1d7:	int3
 1d8:	int3
 1d9:	int3
 1da:	int3
 1db:	int3
 1dc:	int3
 1dd:	int3
 1de:	int3
 1df:	int3

00000000000001e0 <gate_all>:
 1e0:	push   %rbp
 1e1:	mov    %rsp,%rbp
 1e4:	sub    $0x40,%rsp
 1e8:	and    $0xffffffffffffffc0,%rsp
 1ec:	movq   $0x0,(%rsp)
 1f4:	movq   $0x0,0x8(%rsp)
 1fd:	movq   $0x0,0x10(%rsp)
 206:	movq   $0x0,0x18(%rsp)
 20f:	movq   $0x0,0x20(%rsp)
 218:	movq   $0x0,0x28(%rsp)
 221:	movq   $0x0,0x30(%rsp)
 22a:	movq   $0x0,0x38(%rsp)
 233:	mov    (%rsi),%rax
 236:	mov    %rax,(%rsp)
 23a:	mov    0x10(%rsi),%rax
 23e:	mov    %rax,0x8(%rsp)
 243:	mov    0x20(%rsi),%rax
 247:	mov    %rax,0x10(%rsp)
 24c:	mov    0x30(%rsi),%rax
 250:	mov    %rax,0x18(%rsp)
 255:	mov    0x8(%rsi),%rax
 259:	mov    %rax,0x20(%rsp)
 25e:	mov    0x18(%rsi),%rax
 262:	mov    %rax,0x28(%rsp)
 267:	mov    0x28(%rsi),%rax
 26b:	mov    %rax,0x30(%rsp)
 270:	mov    0x38(%rsi),%rax
 274:	mov    %rax,0x38(%rsp)
 279:	vmovdqu (%rsp),%ymm0
 27e:	vmovdqu 0x20(%rsp),%ymm1
 284:	vmovdqu %ymm0,(%rdi)
 288:	vmovdqu %ymm1,0x20(%rdi)
 28d:	vzeroupper
 290:	mov    %rbp,%rsp
 293:	pop    %rbp
 294:	ret
