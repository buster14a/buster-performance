
out/k-head-tier0.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_bits>:
   0:	mov    %rdi,%rsi
   3:	mov    %rsi,%rax
   6:	mov    (%rax),%eax
   8:	mov    %eax,%eax
   a:	shl    $0x36,%rax
   e:	shr    $0x39,%rax
  12:	mov    %rdi,%rcx
  15:	mov    (%rcx),%ecx
  17:	mov    %ecx,%ecx
  19:	shl    $0x3d,%rcx
  1d:	shr    $0x3d,%rcx
  21:	add    %ecx,%eax
  23:	mov    %eax,%eax
  25:	and    $0x7f,%rax
  29:	mov    %rax,%r9
  2c:	mov    %rsi,%rax
  2f:	mov    %rsi,%rcx
  32:	mov    (%rcx),%ecx
  34:	mov    %ecx,%ecx
  36:	and    $0xfffffffffffffc07,%rcx
  3d:	mov    %r9,%rdx
  40:	shl    $0x3,%rdx
  44:	or     %rdx,%rcx
  47:	mov    %ecx,(%rax)
  49:	mov    %rdi,%r8
  4c:	mov    %r8,%rax
  4f:	mov    (%rax),%eax
  51:	mov    %eax,%eax
  53:	shl    $0x29,%rax
  57:	shr    $0x33,%rax
  5b:	mov    %rdi,%rcx
  5e:	mov    (%rcx),%ecx
  60:	mov    %ecx,%ecx
  62:	shl    $0x20,%rcx
  66:	shr    $0x37,%rcx
  6a:	xor    %ecx,%eax
  6c:	mov    %eax,%eax
  6e:	and    $0x1fff,%rax
  74:	mov    %rax,%r10
  77:	mov    %r8,%rax
  7a:	mov    %r8,%rcx
  7d:	mov    (%rcx),%ecx
  7f:	mov    %ecx,%ecx
  81:	and    $0xffffffffff8003ff,%rcx
  88:	mov    %r10,%rdx
  8b:	shl    $0xa,%rdx
  8f:	or     %rdx,%rcx
  92:	mov    %ecx,(%rax)
  94:	mov    %rdi,%rax
  97:	mov    (%rax),%eax
  99:	mov    %eax,%eax
  9b:	shl    $0x3d,%rax
  9f:	shr    $0x3d,%rax
  a3:	mov    %rdi,%rcx
  a6:	mov    (%rcx),%ecx
  a8:	mov    %ecx,%ecx
  aa:	shl    $0x36,%rcx
  ae:	shr    $0x39,%rcx
  b2:	add    %ecx,%eax
  b4:	mov    %rdi,%rcx
  b7:	mov    (%rcx),%ecx
  b9:	mov    %ecx,%ecx
  bb:	shl    $0x29,%rcx
  bf:	shr    $0x33,%rcx
  c3:	add    %ecx,%eax
  c5:	mov    %rdi,%rcx
  c8:	mov    (%rcx),%ecx
  ca:	mov    %ecx,%ecx
  cc:	shl    $0x20,%rcx
  d0:	shr    $0x37,%rcx
  d4:	add    %ecx,%eax
  d6:	ret
  d7:	int3
  d8:	int3
  d9:	int3
  da:	int3
  db:	int3
  dc:	int3
  dd:	int3
  de:	int3
  df:	int3

00000000000000e0 <k_init>:
  e0:	push   %rbx
  e1:	push   %rbp
  e2:	push   %r12
  e4:	push   %r13
  e6:	sub    $0x8,%rsp
  ea:	lea    (%rsp),%rax
  ee:	movl   $0x0,(%rax)
  f4:	lea    (%rsp),%rax
  f8:	mov    %rax,%r11
  fb:	mov    %esi,%eax
  fd:	and    $0x7,%rax
 101:	mov    %rax,%rbx
 104:	mov    %r11,%rax
 107:	mov    %r11,%rcx
 10a:	mov    (%rcx),%ecx
 10c:	mov    %ecx,%ecx
 10e:	and    $0xfffffffffffffff8,%rcx
 112:	or     %rbx,%rcx
 115:	mov    %ecx,(%rax)
 117:	lea    (%rsp),%rax
 11b:	mov    %rax,%r10
 11e:	mov    %esi,%eax
 120:	inc    %eax
 122:	mov    %eax,%eax
 124:	and    $0x7f,%rax
 128:	mov    %rax,%rbp
 12b:	mov    %r10,%rax
 12e:	mov    %r10,%rcx
 131:	mov    (%rcx),%ecx
 133:	mov    %ecx,%ecx
 135:	and    $0xfffffffffffffc07,%rcx
 13c:	mov    %rbp,%rdx
 13f:	shl    $0x3,%rdx
 143:	or     %rdx,%rcx
 146:	mov    %ecx,(%rax)
 148:	lea    (%rsp),%rax
 14c:	mov    %rax,%r9
 14f:	mov    %esi,%eax
 151:	add    $0x2,%eax
 154:	mov    %eax,%eax
 156:	and    $0x1fff,%rax
 15c:	mov    %rax,%r12
 15f:	mov    %r9,%rax
 162:	mov    %r9,%rcx
 165:	mov    (%rcx),%ecx
 167:	mov    %ecx,%ecx
 169:	and    $0xffffffffff8003ff,%rcx
 170:	mov    %r12,%rdx
 173:	shl    $0xa,%rdx
 177:	or     %rdx,%rcx
 17a:	mov    %ecx,(%rax)
 17c:	lea    (%rsp),%rax
 180:	mov    %rax,%r8
 183:	mov    %esi,%eax
 185:	add    $0x3,%eax
 188:	mov    %eax,%eax
 18a:	and    $0x1ff,%rax
 190:	mov    %rax,%r13
 193:	mov    %r8,%rax
 196:	mov    %r8,%rcx
 199:	mov    (%rcx),%ecx
 19b:	mov    %ecx,%ecx
 19d:	movabs $0xffffffff007fffff,%rdx
 1a7:	and    %rdx,%rcx
 1aa:	mov    %r13,%rdx
 1ad:	shl    $0x17,%rdx
 1b1:	or     %rdx,%rcx
 1b4:	mov    %ecx,(%rax)
 1b6:	mov    %rdi,%rax
 1b9:	lea    (%rsp),%rcx
 1bd:	mov    (%rcx),%edx
 1bf:	mov    %edx,(%rax)
 1c1:	mov    %rdi,%rax
 1c4:	mov    (%rax),%eax
 1c6:	mov    %eax,%eax
 1c8:	shl    $0x36,%rax
 1cc:	shr    $0x39,%rax
 1d0:	add    $0x8,%rsp
 1d4:	pop    %r13
 1d6:	pop    %r12
 1d8:	pop    %rbp
 1d9:	pop    %rbx
 1da:	ret
 1db:	int3
 1dc:	int3
 1dd:	int3
 1de:	int3
 1df:	int3

00000000000001e0 <k_union>:
 1e0:	mov    %rdi,%rsi
 1e3:	mov    %rsi,%rax
 1e6:	mov    (%rax),%eax
 1e8:	mov    %eax,%eax
 1ea:	shl    $0x2f,%rax
 1ee:	shr    $0x2f,%rax
 1f2:	mov    %rdi,%rcx
 1f5:	movzbl (%rcx),%ecx
 1f8:	movzbl %cl,%ecx
 1fb:	shl    $0x3d,%rcx
 1ff:	shr    $0x3d,%rcx
 203:	add    %ecx,%eax
 205:	mov    %eax,%eax
 207:	and    $0x1ffff,%rax
 20d:	mov    %rax,%r9
 210:	mov    %rsi,%rax
 213:	mov    %rsi,%rcx
 216:	mov    (%rcx),%ecx
 218:	mov    %ecx,%ecx
 21a:	and    $0xfffffffffffe0000,%rcx
 221:	or     %r9,%rcx
 224:	mov    %ecx,(%rax)
 226:	mov    %rdi,%r8
 229:	mov    %r8,%rax
 22c:	mov    (%rax),%rax
 22f:	shl    $0x18,%rax
 233:	shr    $0x18,%rax
 237:	mov    %rdi,%rcx
 23a:	mov    (%rcx),%ecx
 23c:	mov    %ecx,%ecx
 23e:	shl    $0x2f,%rcx
 242:	shr    $0x2f,%rcx
 246:	mov    %ecx,%ecx
 248:	add    %rcx,%rax
 24b:	movabs $0xffffffffff,%rcx
 255:	and    %rcx,%rax
 258:	mov    %rax,%r10
 25b:	mov    %r8,%rax
 25e:	mov    %r8,%rcx
 261:	mov    (%rcx),%rcx
 264:	movabs $0xffffff0000000000,%rdx
 26e:	and    %rdx,%rcx
 271:	or     %r10,%rcx
 274:	mov    %rcx,(%rax)
 277:	mov    %rdi,%rax
 27a:	movzbl (%rax),%eax
 27d:	movzbl %al,%eax
 280:	shl    $0x3d,%rax
 284:	shr    $0x3d,%rax
 288:	mov    %rdi,%rcx
 28b:	mov    (%rcx),%ecx
 28d:	mov    %ecx,%ecx
 28f:	shl    $0x2f,%rcx
 293:	shr    $0x2f,%rcx
 297:	add    %ecx,%eax
 299:	ret
 29a:	int3
 29b:	int3
 29c:	int3
 29d:	int3
 29e:	int3
 29f:	int3

00000000000002a0 <k_ms>:
 2a0:	mov    %rdi,%rsi
 2a3:	mov    %rsi,%rax
 2a6:	mov    (%rax),%eax
 2a8:	mov    %eax,%eax
 2aa:	shl    $0x36,%rax
 2ae:	shr    $0x39,%rax
 2b2:	mov    %rdi,%rcx
 2b5:	mov    (%rcx),%ecx
 2b7:	mov    %ecx,%ecx
 2b9:	shl    $0x3d,%rcx
 2bd:	shr    $0x3d,%rcx
 2c1:	add    %ecx,%eax
 2c3:	mov    %eax,%eax
 2c5:	and    $0x7f,%rax
 2c9:	mov    %rax,%r9
 2cc:	mov    %rsi,%rax
 2cf:	mov    %rsi,%rcx
 2d2:	mov    (%rcx),%ecx
 2d4:	mov    %ecx,%ecx
 2d6:	and    $0xfffffffffffffc07,%rcx
 2dd:	mov    %r9,%rdx
 2e0:	shl    $0x3,%rdx
 2e4:	or     %rdx,%rcx
 2e7:	mov    %ecx,(%rax)
 2e9:	mov    %rdi,%rax
 2ec:	add    $0x4,%rax
 2f0:	mov    %rax,%r8
 2f3:	mov    %r8,%rax
 2f6:	movzwl (%rax),%eax
 2f9:	movzwl %ax,%eax
 2fc:	shl    $0x3b,%rax
 300:	shr    $0x3b,%rax
 304:	movzwl %ax,%eax
 307:	mov    %rdi,%rcx
 30a:	movzbl 0x6(%rcx),%ecx
 30e:	movzbl %cl,%ecx
 311:	shl    $0x3c,%rcx
 315:	shr    $0x3c,%rcx
 319:	movzbl %cl,%ecx
 31c:	xor    %ecx,%eax
 31e:	movzwl %ax,%eax
 321:	and    $0x1f,%rax
 325:	mov    %rax,%r10
 328:	mov    %r8,%rax
 32b:	mov    %r8,%rcx
 32e:	movzwl (%rcx),%ecx
 331:	movzwl %cx,%ecx
 334:	and    $0xffffffffffffffe0,%rcx
 338:	or     %r10,%rcx
 33b:	mov    %cx,(%rax)
 33e:	mov    %rdi,%rax
 341:	mov    (%rax),%eax
 343:	mov    %eax,%eax
 345:	shl    $0x3d,%rax
 349:	shr    $0x3d,%rax
 34d:	mov    %rdi,%rcx
 350:	mov    (%rcx),%ecx
 352:	mov    %ecx,%ecx
 354:	shl    $0x36,%rcx
 358:	shr    $0x39,%rcx
 35c:	add    %ecx,%eax
 35e:	mov    %rdi,%rcx
 361:	movzwl 0x4(%rcx),%ecx
 365:	movzwl %cx,%ecx
 368:	shl    $0x3b,%rcx
 36c:	shr    $0x3b,%rcx
 370:	movzwl %cx,%ecx
 373:	add    %ecx,%eax
 375:	mov    %rdi,%rcx
 378:	movzbl 0x6(%rcx),%ecx
 37c:	movzbl %cl,%ecx
 37f:	shl    $0x3c,%rcx
 383:	shr    $0x3c,%rcx
 387:	movzbl %cl,%ecx
 38a:	add    %ecx,%eax
 38c:	ret
 38d:	int3
 38e:	int3
 38f:	int3

0000000000000390 <k_wide>:
 390:	push   %rbx
 391:	push   %rbp
 392:	mov    %rdi,%r8
 395:	mov    %r8,%rax
 398:	mov    (%rax),%rax
 39b:	shl    $0x4,%rax
 39f:	shr    $0x22,%rax
 3a3:	mov    %rdi,%rcx
 3a6:	mov    (%rcx),%rcx
 3a9:	shl    $0x22,%rcx
 3ad:	shr    $0x22,%rcx
 3b1:	add    %ecx,%eax
 3b3:	mov    %eax,%eax
 3b5:	and    $0x3fffffff,%rax
 3bb:	mov    %rax,%rbx
 3be:	mov    %r8,%rax
 3c1:	mov    %r8,%rcx
 3c4:	mov    (%rcx),%rcx
 3c7:	movabs $0xf00000003fffffff,%rdx
 3d1:	and    %rdx,%rcx
 3d4:	mov    %rbx,%rdx
 3d7:	shl    $0x1e,%rdx
 3db:	or     %rdx,%rcx
 3de:	mov    %rcx,(%rax)
 3e1:	mov    %rdi,%rsi
 3e4:	mov    %rsi,%r9
 3e7:	mov    %r9,%rax
 3ea:	mov    (%rax),%rax
 3ed:	shr    $0x3c,%rax
 3f1:	mov    %r9,%rcx
 3f4:	mov    0x8(%rcx),%ecx
 3f7:	mov    %ecx,%ecx
 3f9:	shl    $0x4,%rcx
 3fd:	or     %rcx,%rax
 400:	shl    $0x22,%rax
 404:	shr    $0x22,%rax
 408:	mov    %rdi,%rcx
 40b:	mov    (%rcx),%rcx
 40e:	shl    $0x4,%rcx
 412:	shr    $0x22,%rcx
 416:	xor    %ecx,%eax
 418:	mov    %eax,%eax
 41a:	and    $0x3fffffff,%rax
 420:	mov    %rax,%r10
 423:	mov    %rsi,%rax
 426:	mov    %rsi,%rcx
 429:	mov    (%rcx),%rcx
 42c:	movabs $0xfffffffffffffff,%rdx
 436:	and    %rdx,%rcx
 439:	mov    %r10,%rdx
 43c:	shl    $0x3c,%rdx
 440:	or     %rdx,%rcx
 443:	mov    %rcx,(%rax)
 446:	mov    %rsi,%rax
 449:	mov    0x8(%rax),%eax
 44c:	mov    %eax,%eax
 44e:	and    $0xfffffffffc000000,%rax
 454:	mov    %r10,%rcx
 457:	shr    $0x4,%rcx
 45b:	or     %rcx,%rax
 45e:	mov    %rax,%rbp
 461:	mov    %rsi,%rax
 464:	add    $0x8,%rax
 468:	mov    %ebp,%ecx
 46a:	mov    %ecx,(%rax)
 46c:	mov    %rdi,%rax
 46f:	mov    (%rax),%rax
 472:	shl    $0x22,%rax
 476:	shr    $0x22,%rax
 47a:	mov    %rdi,%rcx
 47d:	mov    (%rcx),%rcx
 480:	shl    $0x4,%rcx
 484:	shr    $0x22,%rcx
 488:	add    %ecx,%eax
 48a:	mov    %rdi,%r11
 48d:	mov    %r11,%rcx
 490:	mov    (%rcx),%rcx
 493:	shr    $0x3c,%rcx
 497:	mov    %r11,%rdx
 49a:	mov    0x8(%rdx),%edx
 49d:	mov    %edx,%edx
 49f:	shl    $0x4,%rdx
 4a3:	or     %rdx,%rcx
 4a6:	shl    $0x22,%rcx
 4aa:	shr    $0x22,%rcx
 4ae:	add    %ecx,%eax
 4b0:	pop    %rbp
 4b1:	pop    %rbx
 4b2:	ret
