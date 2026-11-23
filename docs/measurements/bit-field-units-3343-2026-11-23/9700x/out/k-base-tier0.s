
out/k-base-tier0.o:     file format elf64-x86-64


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
 10a:	movzbl (%rcx),%ecx
 10d:	movzbl %cl,%ecx
 110:	and    $0xfffffffffffffff8,%rcx
 114:	or     %rbx,%rcx
 117:	mov    %cl,(%rax)
 119:	lea    (%rsp),%rax
 11d:	mov    %rax,%r10
 120:	mov    %esi,%eax
 122:	inc    %eax
 124:	mov    %eax,%eax
 126:	and    $0x7f,%rax
 12a:	mov    %rax,%rbp
 12d:	mov    %r10,%rax
 130:	mov    %r10,%rcx
 133:	movzwl (%rcx),%ecx
 136:	movzwl %cx,%ecx
 139:	and    $0xfffffffffffffc07,%rcx
 140:	mov    %rbp,%rdx
 143:	shl    $0x3,%rdx
 147:	or     %rdx,%rcx
 14a:	mov    %cx,(%rax)
 14d:	lea    (%rsp),%rax
 151:	inc    %rax
 154:	mov    %rax,%r9
 157:	mov    %esi,%eax
 159:	add    $0x2,%eax
 15c:	mov    %eax,%eax
 15e:	and    $0x1fff,%rax
 164:	mov    %rax,%r12
 167:	mov    %r9,%rax
 16a:	mov    %r9,%rcx
 16d:	movzwl (%rcx),%ecx
 170:	movzwl %cx,%ecx
 173:	and    $0xffffffffffff8003,%rcx
 17a:	mov    %r12,%rdx
 17d:	shl    $0x2,%rdx
 181:	or     %rdx,%rcx
 184:	mov    %cx,(%rax)
 187:	lea    (%rsp),%rax
 18b:	add    $0x2,%rax
 18f:	mov    %rax,%r8
 192:	mov    %esi,%eax
 194:	add    $0x3,%eax
 197:	mov    %eax,%eax
 199:	and    $0x1ff,%rax
 19f:	mov    %rax,%r13
 1a2:	mov    %r8,%rax
 1a5:	mov    %r8,%rcx
 1a8:	movzwl (%rcx),%ecx
 1ab:	movzwl %cx,%ecx
 1ae:	and    $0xffffffffffff007f,%rcx
 1b5:	mov    %r13,%rdx
 1b8:	shl    $0x7,%rdx
 1bc:	or     %rdx,%rcx
 1bf:	mov    %cx,(%rax)
 1c2:	mov    %rdi,%rax
 1c5:	lea    (%rsp),%rcx
 1c9:	mov    (%rcx),%edx
 1cb:	mov    %edx,(%rax)
 1cd:	mov    %rdi,%rax
 1d0:	mov    (%rax),%eax
 1d2:	mov    %eax,%eax
 1d4:	shl    $0x36,%rax
 1d8:	shr    $0x39,%rax
 1dc:	add    $0x8,%rsp
 1e0:	pop    %r13
 1e2:	pop    %r12
 1e4:	pop    %rbp
 1e5:	pop    %rbx
 1e6:	ret
 1e7:	int3
 1e8:	int3
 1e9:	int3
 1ea:	int3
 1eb:	int3
 1ec:	int3
 1ed:	int3
 1ee:	int3
 1ef:	int3

00000000000001f0 <k_union>:
 1f0:	push   %rbx
 1f1:	push   %rbp
 1f2:	push   %r12
 1f4:	push   %r13
 1f6:	push   %r14
 1f8:	push   %r15
 1fa:	sub    $0x8,%rsp
 1fe:	mov    %rdi,%rsi
 201:	mov    %rsi,%r9
 204:	mov    %r9,%rax
 207:	movzwl (%rax),%eax
 20a:	movzwl %ax,%eax
 20d:	mov    %r9,%rcx
 210:	movzbl 0x2(%rcx),%ecx
 214:	movzbl %cl,%ecx
 217:	shl    $0x10,%rcx
 21b:	or     %rcx,%rax
 21e:	shl    $0x2f,%rax
 222:	shr    $0x2f,%rax
 226:	mov    %rdi,%rcx
 229:	movzbl (%rcx),%ecx
 22c:	movzbl %cl,%ecx
 22f:	shl    $0x3d,%rcx
 233:	shr    $0x3d,%rcx
 237:	add    %ecx,%eax
 239:	mov    %eax,%eax
 23b:	and    $0x1ffff,%rax
 241:	mov    %rax,%r15
 244:	mov    %rsi,%r10
 247:	mov    %r10,%rax
 24a:	movzwl (%rax),%eax
 24d:	movzwl %ax,%eax
 250:	mov    %r10,%rcx
 253:	movzbl 0x2(%rcx),%ecx
 257:	movzbl %cl,%ecx
 25a:	shl    $0x10,%rcx
 25e:	or     %rcx,%rax
 261:	and    $0xfffffffffffe0000,%rax
 267:	or     %r15,%rax
 26a:	mov    %rax,%r11
 26d:	mov    %rsi,%rax
 270:	movzwl %r11w,%ecx
 274:	mov    %cx,(%rax)
 277:	mov    %rsi,%rax
 27a:	add    $0x2,%rax
 27e:	mov    %r11,%rcx
 281:	shr    $0x10,%rcx
 285:	mov    %cl,(%rax)
 287:	mov    %rdi,%r8
 28a:	mov    %r8,%rbx
 28d:	mov    %rbx,%rax
 290:	mov    (%rax),%eax
 292:	mov    %eax,%eax
 294:	mov    %rbx,%rcx
 297:	movzbl 0x4(%rcx),%ecx
 29b:	movzbl %cl,%ecx
 29e:	shl    $0x20,%rcx
 2a2:	or     %rcx,%rax
 2a5:	shl    $0x18,%rax
 2a9:	shr    $0x18,%rax
 2ad:	mov    %rdi,%rbp
 2b0:	mov    %rbp,%rcx
 2b3:	movzwl (%rcx),%ecx
 2b6:	movzwl %cx,%ecx
 2b9:	mov    %rbp,%rdx
 2bc:	movzbl 0x2(%rdx),%edx
 2c0:	movzbl %dl,%edx
 2c3:	shl    $0x10,%rdx
 2c7:	or     %rdx,%rcx
 2ca:	shl    $0x2f,%rcx
 2ce:	shr    $0x2f,%rcx
 2d2:	mov    %ecx,%ecx
 2d4:	add    %rcx,%rax
 2d7:	movabs $0xffffffffff,%rcx
 2e1:	and    %rcx,%rax
 2e4:	mov    %rax,(%rsp)
 2e8:	mov    %r8,%r12
 2eb:	mov    %r12,%rax
 2ee:	mov    (%rax),%eax
 2f0:	mov    %eax,%eax
 2f2:	mov    %r12,%rcx
 2f5:	movzbl 0x4(%rcx),%ecx
 2f9:	movzbl %cl,%ecx
 2fc:	shl    $0x20,%rcx
 300:	or     %rcx,%rax
 303:	movabs $0xffffff0000000000,%rcx
 30d:	and    %rcx,%rax
 310:	or     (%rsp),%rax
 314:	mov    %rax,%r13
 317:	mov    %r8,%rax
 31a:	mov    %r13d,%ecx
 31d:	mov    %ecx,(%rax)
 31f:	mov    %r8,%rax
 322:	add    $0x4,%rax
 326:	mov    %r13,%rcx
 329:	shr    $0x20,%rcx
 32d:	mov    %cl,(%rax)
 32f:	mov    %rdi,%rax
 332:	movzbl (%rax),%eax
 335:	movzbl %al,%eax
 338:	shl    $0x3d,%rax
 33c:	shr    $0x3d,%rax
 340:	mov    %rdi,%r14
 343:	mov    %r14,%rcx
 346:	movzwl (%rcx),%ecx
 349:	movzwl %cx,%ecx
 34c:	mov    %r14,%rdx
 34f:	movzbl 0x2(%rdx),%edx
 353:	movzbl %dl,%edx
 356:	shl    $0x10,%rdx
 35a:	or     %rdx,%rcx
 35d:	shl    $0x2f,%rcx
 361:	shr    $0x2f,%rcx
 365:	add    %ecx,%eax
 367:	add    $0x8,%rsp
 36b:	pop    %r15
 36d:	pop    %r14
 36f:	pop    %r13
 371:	pop    %r12
 373:	pop    %rbp
 374:	pop    %rbx
 375:	ret
 376:	int3
 377:	int3
 378:	int3
 379:	int3
 37a:	int3
 37b:	int3
 37c:	int3
 37d:	int3
 37e:	int3
 37f:	int3

0000000000000380 <k_ms>:
 380:	mov    %rdi,%rsi
 383:	mov    %rsi,%rax
 386:	movzwl (%rax),%eax
 389:	movzwl %ax,%eax
 38c:	shl    $0x36,%rax
 390:	shr    $0x39,%rax
 394:	mov    %rdi,%rcx
 397:	movzbl (%rcx),%ecx
 39a:	movzbl %cl,%ecx
 39d:	shl    $0x3d,%rcx
 3a1:	shr    $0x3d,%rcx
 3a5:	add    %ecx,%eax
 3a7:	mov    %eax,%eax
 3a9:	and    $0x7f,%rax
 3ad:	mov    %rax,%r9
 3b0:	mov    %rsi,%rax
 3b3:	mov    %rsi,%rcx
 3b6:	movzwl (%rcx),%ecx
 3b9:	movzwl %cx,%ecx
 3bc:	and    $0xfffffffffffffc07,%rcx
 3c3:	mov    %r9,%rdx
 3c6:	shl    $0x3,%rdx
 3ca:	or     %rdx,%rcx
 3cd:	mov    %cx,(%rax)
 3d0:	mov    %rdi,%rax
 3d3:	add    $0x4,%rax
 3d7:	mov    %rax,%r8
 3da:	mov    %r8,%rax
 3dd:	movzbl (%rax),%eax
 3e0:	movzbl %al,%eax
 3e3:	shl    $0x3b,%rax
 3e7:	shr    $0x3b,%rax
 3eb:	movzwl %ax,%eax
 3ee:	mov    %rdi,%rcx
 3f1:	movzbl 0x6(%rcx),%ecx
 3f5:	movzbl %cl,%ecx
 3f8:	shl    $0x3c,%rcx
 3fc:	shr    $0x3c,%rcx
 400:	movzbl %cl,%ecx
 403:	xor    %ecx,%eax
 405:	movzwl %ax,%eax
 408:	and    $0x1f,%rax
 40c:	mov    %rax,%r10
 40f:	mov    %r8,%rax
 412:	mov    %r8,%rcx
 415:	movzbl (%rcx),%ecx
 418:	movzbl %cl,%ecx
 41b:	and    $0xffffffffffffffe0,%rcx
 41f:	or     %r10,%rcx
 422:	mov    %cl,(%rax)
 424:	mov    %rdi,%rax
 427:	movzbl (%rax),%eax
 42a:	movzbl %al,%eax
 42d:	shl    $0x3d,%rax
 431:	shr    $0x3d,%rax
 435:	mov    %rdi,%rcx
 438:	movzwl (%rcx),%ecx
 43b:	movzwl %cx,%ecx
 43e:	shl    $0x36,%rcx
 442:	shr    $0x39,%rcx
 446:	add    %ecx,%eax
 448:	mov    %rdi,%rcx
 44b:	movzbl 0x4(%rcx),%ecx
 44f:	movzbl %cl,%ecx
 452:	shl    $0x3b,%rcx
 456:	shr    $0x3b,%rcx
 45a:	movzwl %cx,%ecx
 45d:	add    %ecx,%eax
 45f:	mov    %rdi,%rcx
 462:	movzbl 0x6(%rcx),%ecx
 466:	movzbl %cl,%ecx
 469:	shl    $0x3c,%rcx
 46d:	shr    $0x3c,%rcx
 471:	movzbl %cl,%ecx
 474:	add    %ecx,%eax
 476:	ret
 477:	int3
 478:	int3
 479:	int3
 47a:	int3
 47b:	int3
 47c:	int3
 47d:	int3
 47e:	int3
 47f:	int3

0000000000000480 <k_wide>:
 480:	push   %rbx
 481:	push   %rbp
 482:	push   %r12
 484:	push   %r13
 486:	push   %r14
 488:	push   %r15
 48a:	sub    $0x10,%rsp
 48e:	mov    %rdi,%rax
 491:	add    $0x3,%rax
 495:	mov    %rax,%rsi
 498:	mov    %rsi,%r9
 49b:	mov    %r9,%rax
 49e:	mov    (%rax),%eax
 4a0:	mov    %eax,%eax
 4a2:	mov    %r9,%rcx
 4a5:	movzbl 0x4(%rcx),%ecx
 4a9:	movzbl %cl,%ecx
 4ac:	shl    $0x20,%rcx
 4b0:	or     %rcx,%rax
 4b3:	shl    $0x1c,%rax
 4b7:	shr    $0x22,%rax
 4bb:	mov    %rdi,%rcx
 4be:	mov    (%rcx),%ecx
 4c0:	mov    %ecx,%ecx
 4c2:	shl    $0x22,%rcx
 4c6:	shr    $0x22,%rcx
 4ca:	add    %ecx,%eax
 4cc:	mov    %eax,%eax
 4ce:	and    $0x3fffffff,%rax
 4d4:	mov    %rax,(%rsp)
 4d8:	mov    %rsi,%r10
 4db:	mov    %r10,%rax
 4de:	mov    (%rax),%eax
 4e0:	mov    %eax,%eax
 4e2:	mov    %r10,%rcx
 4e5:	movzbl 0x4(%rcx),%ecx
 4e9:	movzbl %cl,%ecx
 4ec:	shl    $0x20,%rcx
 4f0:	or     %rcx,%rax
 4f3:	movabs $0xfffffff00000003f,%rcx
 4fd:	and    %rcx,%rax
 500:	mov    (%rsp),%rcx
 504:	shl    $0x6,%rcx
 508:	or     %rcx,%rax
 50b:	mov    %rax,%r11
 50e:	mov    %rsi,%rax
 511:	mov    %r11d,%ecx
 514:	mov    %ecx,(%rax)
 516:	mov    %rsi,%rax
 519:	add    $0x4,%rax
 51d:	mov    %r11,%rcx
 520:	shr    $0x20,%rcx
 524:	mov    %cl,(%rax)
 526:	mov    %rdi,%rax
 529:	add    $0x7,%rax
 52d:	mov    %rax,%r8
 530:	mov    %r8,%rbx
 533:	mov    %rbx,%rax
 536:	mov    (%rax),%eax
 538:	mov    %eax,%eax
 53a:	mov    %rbx,%rcx
 53d:	movzbl 0x4(%rcx),%ecx
 541:	movzbl %cl,%ecx
 544:	shl    $0x20,%rcx
 548:	or     %rcx,%rax
 54b:	shl    $0x1e,%rax
 54f:	shr    $0x22,%rax
 553:	mov    %rdi,%rcx
 556:	add    $0x3,%rcx
 55a:	mov    %rcx,%rbp
 55d:	mov    %rbp,%rcx
 560:	mov    (%rcx),%ecx
 562:	mov    %ecx,%ecx
 564:	mov    %rbp,%rdx
 567:	movzbl 0x4(%rdx),%edx
 56b:	movzbl %dl,%edx
 56e:	shl    $0x20,%rdx
 572:	or     %rdx,%rcx
 575:	shl    $0x1c,%rcx
 579:	shr    $0x22,%rcx
 57d:	xor    %ecx,%eax
 57f:	mov    %eax,%eax
 581:	and    $0x3fffffff,%rax
 587:	mov    %rax,0x8(%rsp)
 58c:	mov    %r8,%r12
 58f:	mov    %r12,%rax
 592:	mov    (%rax),%eax
 594:	mov    %eax,%eax
 596:	mov    %r12,%rcx
 599:	movzbl 0x4(%rcx),%ecx
 59d:	movzbl %cl,%ecx
 5a0:	shl    $0x20,%rcx
 5a4:	or     %rcx,%rax
 5a7:	movabs $0xfffffffc0000000f,%rcx
 5b1:	and    %rcx,%rax
 5b4:	mov    0x8(%rsp),%rcx
 5b9:	shl    $0x4,%rcx
 5bd:	or     %rcx,%rax
 5c0:	mov    %rax,%r13
 5c3:	mov    %r8,%rax
 5c6:	mov    %r13d,%ecx
 5c9:	mov    %ecx,(%rax)
 5cb:	mov    %r8,%rax
 5ce:	add    $0x4,%rax
 5d2:	mov    %r13,%rcx
 5d5:	shr    $0x20,%rcx
 5d9:	mov    %cl,(%rax)
 5db:	mov    %rdi,%rax
 5de:	mov    (%rax),%eax
 5e0:	mov    %eax,%eax
 5e2:	shl    $0x22,%rax
 5e6:	shr    $0x22,%rax
 5ea:	mov    %rdi,%rcx
 5ed:	add    $0x3,%rcx
 5f1:	mov    %rcx,%r14
 5f4:	mov    %r14,%rcx
 5f7:	mov    (%rcx),%ecx
 5f9:	mov    %ecx,%ecx
 5fb:	mov    %r14,%rdx
 5fe:	movzbl 0x4(%rdx),%edx
 602:	movzbl %dl,%edx
 605:	shl    $0x20,%rdx
 609:	or     %rdx,%rcx
 60c:	shl    $0x1c,%rcx
 610:	shr    $0x22,%rcx
 614:	add    %ecx,%eax
 616:	mov    %rdi,%rcx
 619:	add    $0x7,%rcx
 61d:	mov    %rcx,%r15
 620:	mov    %r15,%rcx
 623:	mov    (%rcx),%ecx
 625:	mov    %ecx,%ecx
 627:	mov    %r15,%rdx
 62a:	movzbl 0x4(%rdx),%edx
 62e:	movzbl %dl,%edx
 631:	shl    $0x20,%rdx
 635:	or     %rdx,%rcx
 638:	shl    $0x1e,%rcx
 63c:	shr    $0x22,%rcx
 640:	add    %ecx,%eax
 642:	add    $0x10,%rsp
 646:	pop    %r15
 648:	pop    %r14
 64a:	pop    %r13
 64c:	pop    %r12
 64e:	pop    %rbp
 64f:	pop    %rbx
 650:	ret
