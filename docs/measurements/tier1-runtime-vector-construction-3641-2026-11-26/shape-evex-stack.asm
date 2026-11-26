
/tmp/buster-3641-evidence/patterns-head-subject.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <patterns_and>:
   0:	lea    0xb(%rdx),%rax
   4:	cmp    %rsi,%rdi
   7:	jge    24 <patterns_and+0x24>
   9:	cmp    %rdx,%rsi
   c:	jge    24 <patterns_and+0x24>
   e:	lea    0x7(%rdi),%rax
  12:	mov    0x0(%rip),%rcx        # 19 <patterns_and+0x19>
  19:	add    $0x1,%rcx
  1d:	mov    %rcx,0x0(%rip)        # 24 <patterns_and+0x24>
  24:	ret
  25:	int3
  26:	int3
  27:	int3
  28:	int3
  29:	int3
  2a:	int3
  2b:	int3
  2c:	int3
  2d:	int3
  2e:	int3
  2f:	int3

0000000000000030 <patterns_or>:
  30:	lea    0xb(%rdx),%rax
  34:	cmp    %rsi,%rdi
  37:	jl     3e <patterns_or+0xe>
  39:	cmp    %rdx,%rsi
  3c:	jne    54 <patterns_or+0x24>
  3e:	lea    0x7(%rdi),%rax
  42:	mov    0x0(%rip),%rcx        # 49 <patterns_or+0x19>
  49:	add    $0x1,%rcx
  4d:	mov    %rcx,0x0(%rip)        # 54 <patterns_or+0x24>
  54:	ret
  55:	int3
  56:	int3
  57:	int3
  58:	int3
  59:	int3
  5a:	int3
  5b:	int3
  5c:	int3
  5d:	int3
  5e:	int3
  5f:	int3

0000000000000060 <patterns_not_and>:
  60:	mov    $0xffffffffffffffff,%rax
  67:	test   %rdi,%rdi
  6a:	je     71 <patterns_not_and+0x11>
  6c:	test   %rsi,%rsi
  6f:	jg     85 <patterns_not_and+0x25>
  71:	mov    0x0(%rip),%rcx        # 78 <patterns_not_and+0x18>
  78:	add    $0x1,%rcx
  7c:	mov    %rcx,0x0(%rip)        # 83 <patterns_not_and+0x23>
  83:	jmp    8a <patterns_not_and+0x2a>
  85:	mov    -0x8(%rdi,%rsi,8),%rax
  8a:	ret
  8b:	int3
  8c:	int3
  8d:	int3
  8e:	int3
  8f:	int3

0000000000000090 <patterns_chain>:
  90:	lea    0xb(%rcx),%rax
  94:	cmp    %rsi,%rdi
  97:	jge    b9 <patterns_chain+0x29>
  99:	cmp    %rdx,%rsi
  9c:	jge    b9 <patterns_chain+0x29>
  9e:	cmp    %rcx,%rdx
  a1:	jge    b9 <patterns_chain+0x29>
  a3:	lea    0x7(%rdi),%rax
  a7:	mov    0x0(%rip),%rcx        # ae <patterns_chain+0x1e>
  ae:	add    $0x1,%rcx
  b2:	mov    %rcx,0x0(%rip)        # b9 <patterns_chain+0x29>
  b9:	ret
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <patterns_flag>:
  c0:	xor    %eax,%eax
  c2:	jmp    ce <patterns_flag+0xe>
  c4:	cmp    (%rdi,%rax,8),%rdx
  c8:	je     da <patterns_flag+0x1a>
  ca:	add    $0x1,%rax
  ce:	cmp    %rsi,%rax
  d1:	jl     c4 <patterns_flag+0x4>
  d3:	mov    $0x3,%eax
  d8:	jmp    f1 <patterns_flag+0x31>
  da:	mov    $0x5,%eax
  df:	mov    0x0(%rip),%rcx        # e6 <patterns_flag+0x26>
  e6:	add    $0x1,%rcx
  ea:	mov    %rcx,0x0(%rip)        # f1 <patterns_flag+0x31>
  f1:	ret
  f2:	int3
  f3:	int3
  f4:	int3
  f5:	int3
  f6:	int3
  f7:	int3
  f8:	int3
  f9:	int3
  fa:	int3
  fb:	int3
  fc:	int3
  fd:	int3
  fe:	int3
  ff:	int3

0000000000000100 <patterns_store>:
 100:	movb   $0xf9,(%rdi)
 103:	movw   $0x12c,0x2(%rdi)
 109:	movl   $0x12345678,0x4(%rdi)
 110:	movq   $0x7fffffff,0x8(%rdi)
 118:	movq   $0xffffffffffffffff,0x10(%rdi)
 120:	movq   $0x0,0x18(%rdi)
 128:	ret
 129:	int3
 12a:	int3
 12b:	int3
 12c:	int3
 12d:	int3
 12e:	int3
 12f:	int3

0000000000000130 <patterns_field>:
 130:	mov    (%rdi),%eax
 132:	and    $0x7f,%eax
 135:	mov    (%rsi,%rax,4),%eax
 138:	mov    0x4(%rdi),%ecx
 13b:	and    $0x7f,%ecx
 13e:	add    %ecx,%eax
 140:	ret
 141:	int3
 142:	int3
 143:	int3
 144:	int3
 145:	int3
 146:	int3
 147:	int3
 148:	int3
 149:	int3
 14a:	int3
 14b:	int3
 14c:	int3
 14d:	int3
 14e:	int3
 14f:	int3

0000000000000150 <patterns_scale>:
 150:	add    %rsi,%rdi
 153:	lea    (%rdi,%rsi,1),%rax
 157:	ret
 158:	int3
 159:	int3
 15a:	int3
 15b:	int3
 15c:	int3
 15d:	int3
 15e:	int3
 15f:	int3

0000000000000160 <patterns_dispatch>:
 160:	lea    0x0(%rip),%rax        # 167 <patterns_dispatch+0x7>
 167:	xor    %ecx,%ecx
 169:	xor    %edx,%edx
 16b:	movzbl (%rdi),%r8d
 16f:	mov    (%rax,%r8,8),%r8
 173:	jmp    *%r8
 176:	mov    -0x10(%rsi,%rcx,8),%r8
 17b:	add    -0x8(%rsi,%rcx,8),%r8
 180:	mov    %r8,-0x10(%rsi,%rcx,8)
 185:	sub    $0x1,%rcx
 189:	add    $0x1,%rdx
 18d:	movzbl (%rdi,%rdx,1),%r8d
 192:	mov    (%rax,%r8,8),%r8
 196:	jmp    *%r8
 199:	mov    -0x10(%rsi,%rcx,8),%r8
 19e:	sub    -0x8(%rsi,%rcx,8),%r8
 1a3:	mov    %r8,-0x10(%rsi,%rcx,8)
 1a8:	sub    $0x1,%rcx
 1ac:	add    $0x1,%rdx
 1b0:	movzbl (%rdi,%rdx,1),%r8d
 1b5:	mov    (%rax,%r8,8),%r8
 1b9:	jmp    *%r8
 1bc:	movzbl 0x1(%rdi,%rdx,1),%r8d
 1c2:	mov    %r8,(%rsi,%rcx,8)
 1c6:	add    $0x1,%rcx
 1ca:	add    $0x2,%rdx
 1ce:	movzbl (%rdi,%rdx,1),%r8d
 1d3:	mov    (%rax,%r8,8),%r8
 1d7:	jmp    *%r8
 1da:	mov    -0x8(%rsi,%rcx,8),%rax
 1df:	ret

00000000000001e0 <patterns_fetch>:
 1e0:	lea    0x0(%rip),%rax        # 1e7 <patterns_fetch+0x7>
 1e7:	xor    %ecx,%ecx
 1e9:	lea    0x4(%rdi),%rdx
 1ed:	mov    (%rdi),%edi
 1ef:	mov    %edi,%r8d
 1f2:	and    $0x3,%r8d
 1f6:	mov    (%rax,%r8,8),%r8
 1fa:	jmp    *%r8
 1fd:	mov    -0x10(%rsi,%rcx,8),%rdi
 202:	add    -0x8(%rsi,%rcx,8),%rdi
 207:	mov    %rdi,-0x10(%rsi,%rcx,8)
 20c:	sub    $0x1,%rcx
 210:	mov    (%rdx),%edi
 212:	add    $0x4,%rdx
 216:	mov    %edi,%r8d
 219:	and    $0x3,%r8d
 21d:	mov    (%rax,%r8,8),%r8
 221:	jmp    *%r8
 224:	shr    $0x2,%edi
 227:	mov    %rdi,(%rsi,%rcx,8)
 22b:	add    $0x1,%rcx
 22f:	mov    (%rdx),%edi
 231:	add    $0x4,%rdx
 235:	mov    %edi,%r8d
 238:	and    $0x3,%r8d
 23c:	mov    (%rax,%r8,8),%r8
 240:	jmp    *%r8
 243:	mov    -0x8(%rsi,%rcx,8),%rdi
 248:	mov    %rdi,(%rsi,%rcx,8)
 24c:	add    $0x1,%rcx
 250:	mov    (%rdx),%edi
 252:	add    $0x4,%rdx
 256:	mov    %edi,%r8d
 259:	and    $0x3,%r8d
 25d:	mov    (%rax,%r8,8),%r8
 261:	jmp    *%r8
 264:	mov    -0x8(%rsi,%rcx,8),%rax
 269:	ret
 26a:	int3
 26b:	int3
 26c:	int3
 26d:	int3
 26e:	int3
 26f:	int3

0000000000000270 <patterns_spilled>:
 270:	push   %rbx
 271:	push   %rbp
 272:	push   %r12
 274:	push   %r13
 276:	push   %r14
 278:	push   %r15
 27a:	sub    $0x28,%rsp
 27e:	lea    0x0(%rip),%rbx        # 285 <patterns_spilled+0x15>
 285:	mov    (%rdi),%rbp
 288:	mov    0x8(%rdi),%r12
 28c:	mov    0x10(%rdi),%r13
 290:	mov    0x18(%rdi),%r14
 294:	lea    0x4(%rsi),%r15
 298:	mov    (%rsi),%eax
 29a:	mov    %eax,%ecx
 29c:	and    $0x3,%ecx
 29f:	mov    (%rbx,%rcx,8),%rcx
 2a3:	jmp    *%rcx
 2a5:	mov    %eax,%ecx
 2a7:	shr    $0x2,%ecx
 2aa:	and    $0x7,%ecx
 2ad:	lea    0x0(%rbp,%rcx,8),%rbx
 2b2:	mov    %eax,%ecx
 2b4:	shr    $0x5,%ecx
 2b7:	and    $0x7,%ecx
 2ba:	and    $0x3,%ecx
 2bd:	mov    %rbx,0x18(%rsp)
 2c2:	mov    0x0(%r13,%rcx,8),%rbx
 2c7:	shr    $0x8,%eax
 2ca:	and    $0x7,%eax
 2cd:	mov    %r14,0x10(%rsp)
 2d2:	mov    (%r12,%rax,8),%r14
 2d6:	xor    %eax,%eax
 2d8:	cmpq   $0x45,(%rbx)
 2dc:	jne    2f1 <patterns_spilled+0x81>
 2de:	mov    %rdi,(%rsp)
 2e2:	mov    %rbx,%rdi
 2e5:	mov    %r14,%rsi
 2e8:	call   2ed <patterns_spilled+0x7d>
 2ed:	mov    (%rsp),%rdi
 2f1:	test   %rax,%rax
 2f4:	je     33a <patterns_spilled+0xca>
 2f6:	mov    (%rax),%rax
 2f9:	mov    0x18(%rsp),%rbx
 2fe:	mov    %rax,(%rbx)
 301:	mov    0x10(%rsp),%r14
 306:	test   %r14,%r14
 309:	je     321 <patterns_spilled+0xb1>
 30b:	mov    %rdi,(%rsp)
 30f:	mov    %r15,%rsi
 312:	call   317 <patterns_spilled+0xa7>
 317:	mov    %rax,%r14
 31a:	mov    (%rsp),%rdi
 31e:	mov    (%rdi),%rbp
 321:	mov    (%r15),%eax
 324:	add    $0x4,%r15
 328:	mov    %eax,%ecx
 32a:	and    $0x3,%ecx
 32d:	lea    0x0(%rip),%rbx        # 334 <patterns_spilled+0xc4>
 334:	mov    (%rbx,%rcx,8),%rcx
 338:	jmp    *%rcx
 33a:	mov    %rbp,0x8(%rsp)
 33f:	mov    %rbx,%rbp
 342:	mov    0x18(%rsp),%rbx
 347:	mov    %rdi,(%rsp)
 34b:	mov    %rbp,%rsi
 34e:	mov    %r14,%rdx
 351:	mov    %rbx,%rcx
 354:	call   359 <patterns_spilled+0xe9>
 359:	mov    %rax,%r14
 35c:	mov    (%rsp),%rdi
 360:	test   %r14,%r14
 363:	jne    30b <patterns_spilled+0x9b>
 365:	mov    0x8(%rsp),%rbp
 36a:	jmp    321 <patterns_spilled+0xb1>
 36c:	mov    %eax,%ecx
 36e:	shr    $0x2,%ecx
 371:	and    $0x7,%ecx
 374:	mov    0x0(%rbp,%rcx,8),%rdx
 379:	shr    $0x5,%eax
 37c:	and    $0x7,%eax
 37f:	mov    0x0(%rbp,%rax,8),%rax
 384:	add    (%r12),%rax
 388:	mov    0x0(%r13),%rsi
 38c:	add    0x8(%rsi),%rax
 390:	mov    0x30(%r12),%rsi
 395:	mov    0x10(%r13),%r8
 399:	imul   0x8(%r8),%rsi
 39e:	add    %rsi,%rax
 3a1:	mov    0x38(%r12),%rsi
 3a6:	mov    0x18(%r13),%r8
 3aa:	xor    0x8(%r8),%rsi
 3ae:	add    %rsi,%rax
 3b1:	add    %r14,%rax
 3b4:	add    %rdx,%rax
 3b7:	mov    %rax,0x0(%rbp,%rcx,8)
 3bc:	mov    (%r15),%eax
 3bf:	add    $0x4,%r15
 3c3:	mov    %eax,%ecx
 3c5:	and    $0x3,%ecx
 3c8:	lea    0x0(%rip),%rbx        # 3cf <patterns_spilled+0x15f>
 3cf:	mov    (%rbx,%rcx,8),%rcx
 3d3:	jmp    *%rcx
 3d5:	mov    %eax,%ecx
 3d7:	shr    $0x2,%ecx
 3da:	and    $0x7,%ecx
 3dd:	shr    $0x5,%eax
 3e0:	and    $0x7,%eax
 3e3:	mov    (%r12,%rax,8),%rax
 3e7:	add    0x10(%r12),%rax
 3ec:	mov    0x8(%r13),%rdx
 3f0:	add    0x8(%rdx),%rax
 3f4:	mov    0x28(%r12),%rdx
 3f9:	mov    0x10(%r13),%rsi
 3fd:	imul   0x10(%rsi),%rdx
 402:	add    %rdx,%rax
 405:	mov    0x20(%r12),%rdx
 40a:	mov    0x18(%r13),%rsi
 40e:	xor    0x10(%rsi),%rdx
 412:	add    %rdx,%rax
 415:	add    %r14,%rax
 418:	mov    %rax,0x0(%rbp,%rcx,8)
 41d:	mov    (%r15),%eax
 420:	add    $0x4,%r15
 424:	mov    %eax,%ecx
 426:	and    $0x3,%ecx
 429:	lea    0x0(%rip),%rbx        # 430 <patterns_spilled+0x1c0>
 430:	mov    (%rbx,%rcx,8),%rcx
 434:	jmp    *%rcx
 436:	shr    $0x2,%eax
 439:	and    $0x7,%eax
 43c:	mov    0x0(%rbp,%rax,8),%rax
 441:	add    $0x28,%rsp
 445:	pop    %r15
 447:	pop    %r14
 449:	pop    %r13
 44b:	pop    %r12
 44d:	pop    %rbp
 44e:	pop    %rbx
 44f:	ret

0000000000000450 <patterns_gsub>:
 450:	push   %rbx
 451:	push   %rbp
 452:	push   %r12
 454:	push   %r13
 456:	push   %r14
 458:	push   %r15
 45a:	sub    $0x28,%rsp
 45e:	mov    0x60(%rsp),%ebx
 462:	lea    (%rdx,%rcx,1),%rbp
 466:	xor    %r12d,%r12d
 469:	movsbl (%r8),%r13d
 46d:	xor    %r14d,%r14d
 470:	cmp    $0x5e,%r13d
 474:	je     482 <patterns_gsub+0x32>
 476:	mov    %ebx,0x20(%rsp)
 47a:	mov    %rdx,%rbx
 47d:	mov    %r8,%r15
 480:	jmp    4e5 <patterns_gsub+0x95>
 482:	lea    0x1(%r8),%r15
 486:	mov    %ebx,0x20(%rsp)
 48a:	mov    %rdx,%rbx
 48d:	jmp    4e5 <patterns_gsub+0x95>
 48f:	cmp    %rbp,%rbx
 492:	jae    4e0 <patterns_gsub+0x90>
 494:	mov    0x8(%rsi),%rax
 498:	cmp    0x10(%rsi),%rax
 49c:	jb     4c2 <patterns_gsub+0x72>
 49e:	mov    %rsi,(%rsp)
 4a2:	mov    %rdi,0x8(%rsp)
 4a7:	mov    %r9,0x10(%rsp)
 4ac:	mov    %rsi,%rdi
 4af:	call   4b4 <patterns_gsub+0x64>
 4b4:	mov    (%rsp),%rsi
 4b8:	mov    0x8(%rsp),%rdi
 4bd:	mov    0x10(%rsp),%r9
 4c2:	mov    (%rsi),%rax
 4c5:	mov    0x8(%rsi),%rcx
 4c9:	lea    0x1(%rcx),%rdx
 4cd:	mov    %rdx,0x8(%rsi)
 4d1:	movzbl (%rbx),%edx
 4d4:	add    $0x1,%rbx
 4d8:	mov    %dl,(%rax,%rcx,1)
 4db:	jmp    56b <patterns_gsub+0x11b>
 4e0:	jmp    5aa <patterns_gsub+0x15a>
 4e5:	cmp    %r9,%r14
 4e8:	jge    5aa <patterns_gsub+0x15a>
 4ee:	mov    %r15,0x18(%rsp)
 4f3:	mov    %rsi,(%rsp)
 4f7:	mov    %rdi,0x8(%rsp)
 4fc:	mov    %r9,0x10(%rsp)
 501:	mov    %rbx,%rsi
 504:	mov    %r15,%rdx
 507:	call   50c <patterns_gsub+0xbc>
 50c:	mov    %rax,%r15
 50f:	mov    (%rsp),%rsi
 513:	mov    0x8(%rsp),%rdi
 518:	mov    0x10(%rsp),%r9
 51d:	test   %r15,%r15
 520:	jne    52c <patterns_gsub+0xdc>
 522:	mov    0x18(%rsp),%r15
 527:	jmp    48f <patterns_gsub+0x3f>
 52c:	cmp    %r12,%r15
 52f:	jne    53b <patterns_gsub+0xeb>
 531:	mov    0x18(%rsp),%r15
 536:	jmp    48f <patterns_gsub+0x3f>
 53b:	add    $0x1,%r14
 53f:	mov    0x20(%rsp),%r12d
 544:	mov    %rbx,%rdx
 547:	mov    %r15,%rcx
 54a:	mov    %r12,%r8
 54d:	call   552 <patterns_gsub+0x102>
 552:	mov    (%rsp),%rsi
 556:	mov    0x8(%rsp),%rdi
 55b:	mov    0x10(%rsp),%r9
 560:	mov    %r15,%rbx
 563:	mov    %r15,%r12
 566:	mov    0x18(%rsp),%r15
 56b:	cmp    $0x5e,%r13d
 56f:	jne    4e5 <patterns_gsub+0x95>
 575:	jmp    5aa <patterns_gsub+0x15a>
 577:	mov    0x8(%rsi),%rax
 57b:	cmp    0x10(%rsi),%rax
 57f:	jb     591 <patterns_gsub+0x141>
 581:	mov    %rsi,(%rsp)
 585:	mov    %rsi,%rdi
 588:	call   58d <patterns_gsub+0x13d>
 58d:	mov    (%rsp),%rsi
 591:	mov    (%rsi),%rax
 594:	mov    0x8(%rsi),%rcx
 598:	lea    0x1(%rcx),%rdx
 59c:	mov    %rdx,0x8(%rsi)
 5a0:	movzbl (%rbx),%edx
 5a3:	add    $0x1,%rbx
 5a7:	mov    %dl,(%rax,%rcx,1)
 5aa:	cmp    %rbp,%rbx
 5ad:	jb     577 <patterns_gsub+0x127>
 5af:	mov    %r14,%rax
 5b2:	add    $0x28,%rsp
 5b6:	pop    %r15
 5b8:	pop    %r14
 5ba:	pop    %r13
 5bc:	pop    %r12
 5be:	pop    %rbp
 5bf:	pop    %rbx
 5c0:	ret
 5c1:	int3
 5c2:	int3
 5c3:	int3
 5c4:	int3
 5c5:	int3
 5c6:	int3
 5c7:	int3
 5c8:	int3
 5c9:	int3
 5ca:	int3
 5cb:	int3
 5cc:	int3
 5cd:	int3
 5ce:	int3
 5cf:	int3

00000000000005d0 <patterns_sector>:
 5d0:	push   %rbx
 5d1:	push   %rbp
 5d2:	push   %r12
 5d4:	push   %r13
 5d6:	push   %r14
 5d8:	push   %r15
 5da:	sub    $0x18,%rsp
 5de:	lea    0x8(%rsp),%rbx
 5e3:	mov    (%rdi),%rbp
 5e6:	movslq 0x0(%rbp),%rax
 5ea:	mov    0x8(%rbp),%rcx
 5ee:	cqto
 5f0:	idiv   %rcx
 5f3:	mov    0x8(%rdi),%ecx
 5f6:	sub    $0x1,%ecx
 5f9:	sub    $0x1,%eax
 5fc:	not    %eax
 5fe:	and    %eax,%ecx
 600:	lea    0x1(%rcx),%r12d
 604:	xor    %r13d,%r13d
 607:	xor    %r14d,%r14d
 60a:	xor    %r15d,%r15d
 60d:	mov    0x8(%rdi),%eax
 610:	cmp    0x10(%rbp),%eax
 613:	jbe    61f <patterns_sector+0x4f>
 615:	mov    0x8(%rdi),%eax
 618:	sub    %r12d,%eax
 61b:	lea    0x1(%rax),%r13d
 61f:	xor    %r14d,%r14d
 622:	mov    %r13d,0x10(%rsp)
 627:	xor    %ebx,%ebx
 629:	jmp    672 <patterns_sector+0xa2>
 62b:	mov    %rdi,(%rsp)
 62f:	mov    %rbp,%rdi
 632:	mov    %r13,%rsi
 635:	call   63a <patterns_sector+0x6a>
 63a:	mov    %rax,0x8(%rsp)
 63f:	mov    (%rsp),%rdi
 643:	test   %rax,%rax
 646:	je     66e <patterns_sector+0x9e>
 648:	mov    0x8(%rsp),%rax
 64d:	movzwl 0xc(%rax),%eax
 651:	and    $0x8,%eax
 654:	test   %eax,%eax
 656:	mov    $0x0,%eax
 65b:	setne  %al
 65e:	mov    $0x1,%ecx
 663:	test   %eax,%eax
 665:	cmove  %ebx,%ebx
 668:	test   %eax,%eax
 66a:	cmovne %ecx,%r15d
 66e:	add    $0x1,%r14d
 672:	mov    0x10(%rsp),%r13d
 677:	cmp    %r13d,%r14d
 67a:	jge    6c4 <patterns_sector+0xf4>
 67c:	test   %ebx,%ebx
 67e:	jne    6c4 <patterns_sector+0xf4>
 680:	lea    (%r12,%r14,1),%r13d
 684:	cmp    0x8(%rdi),%r13d
 688:	je     6a5 <patterns_sector+0xd5>
 68a:	mov    0x18(%rbp),%rax
 68e:	mov    %rdi,(%rsp)
 692:	mov    %rax,%rdi
 695:	mov    %r13,%rsi
 698:	call   69d <patterns_sector+0xcd>
 69d:	mov    (%rsp),%rdi
 6a1:	test   %eax,%eax
 6a3:	jne    62b <patterns_sector+0x5b>
 6a5:	lea    0x8(%rsp),%rbx
 6aa:	mov    %rbx,%rdx
 6ad:	mov    %rdi,(%rsp)
 6b1:	mov    %rbp,%rdi
 6b4:	mov    %r13,%rsi
 6b7:	call   6bc <patterns_sector+0xec>
 6bc:	mov    %eax,%ebx
 6be:	mov    (%rsp),%rdi
 6c2:	jmp    66e <patterns_sector+0x9e>
 6c4:	xor    %eax,%eax
 6c6:	test   %r15d,%r15d
 6c9:	je     6e5 <patterns_sector+0x115>
 6cb:	xor    %ecx,%ecx
 6cd:	mov    0x10(%rsp),%r13d
 6d2:	jmp    6e0 <patterns_sector+0x110>
 6d4:	add    $0x1,%rax
 6d8:	add    $0x1,%ecx
 6db:	mov    0x10(%rsp),%r13d
 6e0:	cmp    %r13d,%ecx
 6e3:	jl     6d4 <patterns_sector+0x104>
 6e5:	imul   $0x3e8,%ebx,%ecx
 6eb:	movslq %ecx,%rcx
 6ee:	add    %rcx,%rax
 6f1:	add    $0x18,%rsp
 6f5:	pop    %r15
 6f7:	pop    %r14
 6f9:	pop    %r13
 6fb:	pop    %r12
 6fd:	pop    %rbp
 6fe:	pop    %rbx
 6ff:	ret

0000000000000700 <patterns_max>:
 700:	cmp    %rsi,%rdi
 703:	mov    %rsi,%rax
 706:	cmovg  %rdi,%rax
 70a:	ret
 70b:	int3
 70c:	int3
 70d:	int3
 70e:	int3
 70f:	int3

0000000000000710 <patterns_clamp>:
 710:	xor    %eax,%eax
 712:	mov    $0xff,%ecx
 717:	cmp    $0xff,%edi
 71d:	cmovle %edi,%ecx
 720:	test   %edi,%edi
 722:	cmovge %ecx,%eax
 725:	ret
 726:	int3
 727:	int3
 728:	int3
 729:	int3
 72a:	int3
 72b:	int3
 72c:	int3
 72d:	int3
 72e:	int3
 72f:	int3

0000000000000730 <patterns_sum>:
 730:	xor    %eax,%eax
 732:	xor    %ecx,%ecx
 734:	jmp    74d <patterns_sum+0x1d>
 736:	movslq (%rdi,%rcx,4),%rdx
 73a:	xor    %r8d,%r8d
 73d:	cmp    $0x80,%edx
 743:	cmovg  %rdx,%r8
 747:	add    %r8,%rax
 74a:	add    $0x1,%ecx
 74d:	cmp    %esi,%ecx
 74f:	jl     736 <patterns_sum+0x6>
 751:	ret
 752:	int3
 753:	int3
 754:	int3
 755:	int3
 756:	int3
 757:	int3
 758:	int3
 759:	int3
 75a:	int3
 75b:	int3
 75c:	int3
 75d:	int3
 75e:	int3
 75f:	int3

0000000000000760 <patterns_loaded>:
 760:	cmpl   $0x7,(%rdi)
 763:	mov    %edx,%eax
 765:	cmove  %esi,%eax
 768:	ret
 769:	int3
 76a:	int3
 76b:	int3
 76c:	int3
 76d:	int3
 76e:	int3
 76f:	int3

0000000000000770 <patterns_loaded_other>:
 770:	cmp    (%rdi),%esi
 772:	mov    %ecx,%eax
 774:	cmovg  %edx,%eax
 777:	ret
 778:	int3
 779:	int3
 77a:	int3
 77b:	int3
 77c:	int3
 77d:	int3
 77e:	int3
 77f:	int3

0000000000000780 <patterns_mixed>:
 780:	cmp    %esi,%edi
 782:	mov    %rcx,%rax
 785:	cmovl  %rdx,%rax
 789:	ret
 78a:	int3
 78b:	int3
 78c:	int3
 78d:	int3
 78e:	int3
 78f:	int3

0000000000000790 <patterns_arms_signed>:
 790:	xor    %eax,%eax
 792:	xor    %ecx,%ecx
 794:	jmp    7ad <patterns_arms_signed+0x1d>
 796:	movslq (%rdi,%rcx,4),%rdx
 79a:	mov    $0x1,%r8d
 7a0:	test   %edx,%edx
 7a2:	cmovg  %rdx,%r8
 7a6:	add    %r8,%rax
 7a9:	add    $0x1,%rcx
 7ad:	cmp    %rsi,%rcx
 7b0:	jl     796 <patterns_arms_signed+0x6>
 7b2:	ret
 7b3:	int3
 7b4:	int3
 7b5:	int3
 7b6:	int3
 7b7:	int3
 7b8:	int3
 7b9:	int3
 7ba:	int3
 7bb:	int3
 7bc:	int3
 7bd:	int3
 7be:	int3
 7bf:	int3

00000000000007c0 <patterns_arms_unsigned>:
 7c0:	xor    %eax,%eax
 7c2:	xor    %ecx,%ecx
 7c4:	jmp    7dd <patterns_arms_unsigned+0x1d>
 7c6:	mov    (%rdi,%rcx,4),%edx
 7c9:	mov    $0x1,%r8d
 7cf:	cmp    $0x7,%edx
 7d2:	cmova  %rdx,%r8
 7d6:	add    %r8,%rax
 7d9:	add    $0x1,%rcx
 7dd:	cmp    %rsi,%rcx
 7e0:	jl     7c6 <patterns_arms_unsigned+0x6>
 7e2:	ret
 7e3:	int3
 7e4:	int3
 7e5:	int3
 7e6:	int3
 7e7:	int3
 7e8:	int3
 7e9:	int3
 7ea:	int3
 7eb:	int3
 7ec:	int3
 7ed:	int3
 7ee:	int3
 7ef:	int3

00000000000007f0 <patterns_arms_half>:
 7f0:	xor    %eax,%eax
 7f2:	xor    %ecx,%ecx
 7f4:	jmp    811 <patterns_arms_half+0x21>
 7f6:	movzwl (%rdi,%rcx,2),%edx
 7fa:	mov    $0x2,%r8d
 800:	cmp    $0x12c,%edx
 806:	cmovg  %rdx,%r8
 80a:	add    %r8,%rax
 80d:	add    $0x1,%rcx
 811:	cmp    %rsi,%rcx
 814:	jl     7f6 <patterns_arms_half+0x6>
 816:	ret
 817:	int3
 818:	int3
 819:	int3
 81a:	int3
 81b:	int3
 81c:	int3
 81d:	int3
 81e:	int3
 81f:	int3

0000000000000820 <patterns_unsigned>:
 820:	xor    %eax,%eax
 822:	cmp    %esi,%edi
 824:	cmovae %edx,%eax
 827:	ret
 828:	int3
 829:	int3
 82a:	int3
 82b:	int3
 82c:	int3
 82d:	int3
 82e:	int3
 82f:	int3

0000000000000830 <patterns_float_less>:
 830:	ucomisd %xmm0,%xmm1
 834:	mov    %esi,%eax
 836:	cmova  %edi,%eax
 839:	ret
 83a:	int3
 83b:	int3
 83c:	int3
 83d:	int3
 83e:	int3
 83f:	int3

0000000000000840 <patterns_float_not_greater>:
 840:	ucomiss %xmm1,%xmm0
 843:	mov    %rsi,%rax
 846:	cmovbe %rdi,%rax
 84a:	ret
 84b:	int3
 84c:	int3
 84d:	int3
 84e:	int3
 84f:	int3

0000000000000850 <patterns_float_count>:
 850:	xor    %eax,%eax
 852:	xor    %ecx,%ecx
 854:	jmp    86e <patterns_float_count+0x1e>
 856:	movsd  (%rdi,%rcx,8),%xmm1
 85b:	lea    0x3(%rax),%rdx
 85f:	sub    $0x1,%rax
 863:	ucomisd %xmm0,%xmm1
 867:	cmovae %rdx,%rax
 86b:	add    $0x1,%ecx
 86e:	cmp    %esi,%ecx
 870:	jl     856 <patterns_float_count+0x6>
 872:	ret
 873:	int3
 874:	int3
 875:	int3
 876:	int3
 877:	int3
 878:	int3
 879:	int3
 87a:	int3
 87b:	int3
 87c:	int3
 87d:	int3
 87e:	int3
 87f:	int3

0000000000000880 <patterns_float_sign>:
 880:	xorps  %xmm1,%xmm1
 883:	ucomisd %xmm0,%xmm1
 887:	jbe    893 <patterns_float_sign+0x13>
 889:	mov    $0xffffffff,%eax
 88e:	mov    %rax,%rcx
 891:	jmp    8a4 <patterns_float_sign+0x24>
 893:	xorps  %xmm1,%xmm1
 896:	mov    $0x1,%eax
 89b:	xor    %ecx,%ecx
 89d:	ucomisd %xmm1,%xmm0
 8a1:	cmova  %eax,%ecx
 8a4:	mov    %ecx,%eax
 8a6:	ret
 8a7:	int3
 8a8:	int3
 8a9:	int3
 8aa:	int3
 8ab:	int3
 8ac:	int3
 8ad:	int3
 8ae:	int3
 8af:	int3

00000000000008b0 <patterns_float_equal>:
 8b0:	ucomisd %xmm1,%xmm0
 8b4:	mov    %edi,%eax
 8b6:	cmovne %esi,%eax
 8b9:	cmovp  %esi,%eax
 8bc:	ret
 8bd:	int3
 8be:	int3
 8bf:	int3

00000000000008c0 <patterns_float_unequal>:
 8c0:	xor    %eax,%eax
 8c2:	ucomiss %xmm1,%xmm0
 8c5:	cmovne %rdi,%rax
 8c9:	cmovp  %rdi,%rax
 8cd:	ret
 8ce:	int3
 8cf:	int3

00000000000008d0 <patterns_float_equal_sum>:
 8d0:	xor    %eax,%eax
 8d2:	xor    %r8d,%r8d
 8d5:	jmp    8f3 <patterns_float_equal_sum+0x23>
 8d7:	movsd  (%rdi,%r8,8),%xmm1
 8dd:	ucomisd %xmm0,%xmm1
 8e1:	mov    %rdx,%r9
 8e4:	cmovne %rcx,%r9
 8e8:	cmovp  %rcx,%r9
 8ec:	add    %r9,%rax
 8ef:	add    $0x1,%r8d
 8f3:	cmp    %esi,%r8d
 8f6:	jl     8d7 <patterns_float_equal_sum+0x7>
 8f8:	ret
 8f9:	int3
 8fa:	int3
 8fb:	int3
 8fc:	int3
 8fd:	int3
 8fe:	int3
 8ff:	int3

0000000000000900 <patterns_float_equal_count>:
 900:	mov    $0x1,%eax
 905:	xor    %ecx,%ecx
 907:	jmp    92f <patterns_float_equal_count+0x2f>
 909:	movsd  (%rdi,%rcx,8),%xmm1
 90e:	xor    %edx,%edx
 910:	ucomisd %xmm0,%xmm1
 914:	sete   %dl
 917:	setnp  %r11b
 91b:	and    %r11b,%dl
 91e:	lea    (%rax,%rax,2),%r8
 922:	add    $0x1,%rax
 926:	test   %edx,%edx
 928:	cmovne %r8,%rax
 92c:	add    $0x1,%ecx
 92f:	cmp    %esi,%ecx
 931:	jl     909 <patterns_float_equal_count+0x9>
 933:	ret
 934:	int3
 935:	int3
 936:	int3
 937:	int3
 938:	int3
 939:	int3
 93a:	int3
 93b:	int3
 93c:	int3
 93d:	int3
 93e:	int3
 93f:	int3

0000000000000940 <patterns_float_last_unequal>:
 940:	mov    $0xffffffff,%eax
 945:	xor    %ecx,%ecx
 947:	jmp    95a <patterns_float_last_unequal+0x1a>
 949:	movss  (%rdi,%rcx,4),%xmm1
 94e:	ucomiss %xmm0,%xmm1
 951:	cmovne %ecx,%eax
 954:	cmovp  %ecx,%eax
 957:	add    $0x1,%ecx
 95a:	cmp    %esi,%ecx
 95c:	jl     949 <patterns_float_last_unequal+0x9>
 95e:	ret
 95f:	int3

0000000000000960 <patterns_whole_literal>:
 960:	push   %rbp
 961:	mov    %rsp,%rbp
 964:	sub    $0x40,%rsp
 968:	and    $0xffffffffffffffc0,%rsp
 96c:	movups (%rsi),%xmm0
 96f:	movups 0x10(%rsi),%xmm1
 973:	movups 0x20(%rsi),%xmm2
 977:	movups 0x30(%rsi),%xmm3
 97b:	movups %xmm0,(%rsp)
 97f:	movups %xmm1,0x10(%rsp)
 984:	movups %xmm2,0x20(%rsp)
 989:	movups %xmm3,0x30(%rsp)
 98e:	mov    (%rsp),%rax
 992:	mov    %rax,(%rdi)
 995:	mov    0x8(%rsp),%rax
 99a:	mov    %rax,0x8(%rdi)
 99e:	mov    0x10(%rsp),%rax
 9a3:	mov    %rax,0x10(%rdi)
 9a7:	mov    0x18(%rsp),%rax
 9ac:	mov    %rax,0x18(%rdi)
 9b0:	mov    0x20(%rsp),%rax
 9b5:	mov    %rax,0x20(%rdi)
 9b9:	mov    0x28(%rsp),%rax
 9be:	mov    %rax,0x28(%rdi)
 9c2:	mov    0x30(%rsp),%rax
 9c7:	mov    %rax,0x30(%rdi)
 9cb:	mov    0x38(%rsp),%rax
 9d0:	mov    %rax,0x38(%rdi)
 9d4:	mov    %rbp,%rsp
 9d7:	pop    %rbp
 9d8:	ret
 9d9:	int3
 9da:	int3
 9db:	int3
 9dc:	int3
 9dd:	int3
 9de:	int3
 9df:	int3

00000000000009e0 <patterns_whole_declaration>:
 9e0:	push   %rbp
 9e1:	mov    %rsp,%rbp
 9e4:	sub    $0x40,%rsp
 9e8:	and    $0xffffffffffffffc0,%rsp
 9ec:	movups (%rsi),%xmm0
 9ef:	movups 0x10(%rsi),%xmm1
 9f3:	movups 0x20(%rsi),%xmm2
 9f7:	movups 0x30(%rsi),%xmm3
 9fb:	movups %xmm0,(%rsp)
 9ff:	movups %xmm1,0x10(%rsp)
 a04:	movups %xmm2,0x20(%rsp)
 a09:	movups %xmm3,0x30(%rsp)
 a0e:	mov    (%rsp),%rax
 a12:	mov    %rax,(%rdi)
 a15:	mov    0x8(%rsp),%rax
 a1a:	mov    %rax,0x8(%rdi)
 a1e:	mov    0x10(%rsp),%rax
 a23:	mov    %rax,0x10(%rdi)
 a27:	mov    0x18(%rsp),%rax
 a2c:	mov    %rax,0x18(%rdi)
 a30:	mov    0x20(%rsp),%rax
 a35:	mov    %rax,0x20(%rdi)
 a39:	mov    0x28(%rsp),%rax
 a3e:	mov    %rax,0x28(%rdi)
 a42:	mov    0x30(%rsp),%rax
 a47:	mov    %rax,0x30(%rdi)
 a4b:	mov    0x38(%rsp),%rax
 a50:	mov    %rax,0x38(%rdi)
 a54:	mov    %rbp,%rsp
 a57:	pop    %rbp
 a58:	ret
 a59:	int3
 a5a:	int3
 a5b:	int3
 a5c:	int3
 a5d:	int3
 a5e:	int3
 a5f:	int3

0000000000000a60 <patterns_whole_union>:
 a60:	push   %rbp
 a61:	mov    %rsp,%rbp
 a64:	sub    $0x40,%rsp
 a68:	and    $0xffffffffffffffc0,%rsp
 a6c:	movups (%rsi),%xmm0
 a6f:	movups 0x10(%rsi),%xmm1
 a73:	movups 0x20(%rsi),%xmm2
 a77:	movups 0x30(%rsi),%xmm3
 a7b:	movups %xmm0,(%rsp)
 a7f:	movups %xmm1,0x10(%rsp)
 a84:	movups %xmm2,0x20(%rsp)
 a89:	movups %xmm3,0x30(%rsp)
 a8e:	mov    (%rsp),%rax
 a92:	mov    %rax,(%rdi)
 a95:	mov    0x8(%rsp),%rax
 a9a:	mov    %rax,0x8(%rdi)
 a9e:	mov    0x10(%rsp),%rax
 aa3:	mov    %rax,0x10(%rdi)
 aa7:	mov    0x18(%rsp),%rax
 aac:	mov    %rax,0x18(%rdi)
 ab0:	mov    0x20(%rsp),%rax
 ab5:	mov    %rax,0x20(%rdi)
 ab9:	mov    0x28(%rsp),%rax
 abe:	mov    %rax,0x28(%rdi)
 ac2:	mov    0x30(%rsp),%rax
 ac7:	mov    %rax,0x30(%rdi)
 acb:	mov    0x38(%rsp),%rax
 ad0:	mov    %rax,0x38(%rdi)
 ad4:	mov    %rbp,%rsp
 ad7:	pop    %rbp
 ad8:	ret
 ad9:	int3
 ada:	int3
 adb:	int3
 adc:	int3
 add:	int3
 ade:	int3
 adf:	int3

0000000000000ae0 <patterns_whole_member>:
 ae0:	push   %rbp
 ae1:	mov    %rsp,%rbp
 ae4:	sub    $0x40,%rsp
 ae8:	and    $0xffffffffffffffc0,%rsp
 aec:	movups (%rdi),%xmm0
 aef:	movups 0x10(%rdi),%xmm1
 af3:	movups 0x20(%rdi),%xmm2
 af7:	movups 0x30(%rdi),%xmm3
 afb:	movups %xmm0,(%rsp)
 aff:	movups %xmm1,0x10(%rsp)
 b04:	movups %xmm2,0x20(%rsp)
 b09:	movups %xmm3,0x30(%rsp)
 b0e:	mov    0x18(%rsp),%rax
 b13:	xor    0x30(%rsp),%rax
 b18:	mov    %rbp,%rsp
 b1b:	pop    %rbp
 b1c:	ret
 b1d:	int3
 b1e:	int3
 b1f:	int3

0000000000000b20 <patterns_whole_override>:
 b20:	push   %rbp
 b21:	mov    %rsp,%rbp
 b24:	sub    $0x40,%rsp
 b28:	and    $0xffffffffffffffc0,%rsp
 b2c:	movq   $0x0,(%rsp)
 b34:	movq   $0x0,0x8(%rsp)
 b3d:	movq   $0x0,0x10(%rsp)
 b46:	movq   $0x0,0x18(%rsp)
 b4f:	movq   $0x0,0x20(%rsp)
 b58:	movq   $0x0,0x28(%rsp)
 b61:	movq   $0x0,0x30(%rsp)
 b6a:	movq   $0x0,0x38(%rsp)
 b73:	movq   $0x5,0x8(%rsp)
 b7c:	mov    (%rsp),%rax
 b80:	mov    %rax,(%rdi)
 b83:	mov    0x8(%rsp),%rax
 b88:	mov    %rax,0x8(%rdi)
 b8c:	mov    0x10(%rsp),%rax
 b91:	mov    %rax,0x10(%rdi)
 b95:	mov    0x18(%rsp),%rax
 b9a:	mov    %rax,0x18(%rdi)
 b9e:	mov    0x20(%rsp),%rax
 ba3:	mov    %rax,0x20(%rdi)
 ba7:	mov    0x28(%rsp),%rax
 bac:	mov    %rax,0x28(%rdi)
 bb0:	mov    0x30(%rsp),%rax
 bb5:	mov    %rax,0x30(%rdi)
 bb9:	mov    0x38(%rsp),%rax
 bbe:	mov    %rax,0x38(%rdi)
 bc2:	mov    %rbp,%rsp
 bc5:	pop    %rbp
 bc6:	ret
 bc7:	int3
 bc8:	int3
 bc9:	int3
 bca:	int3
 bcb:	int3
 bcc:	int3
 bcd:	int3
 bce:	int3
 bcf:	int3

0000000000000bd0 <patterns_whole_volatile>:
 bd0:	push   %rbp
 bd1:	mov    %rsp,%rbp
 bd4:	sub    $0x40,%rsp
 bd8:	and    $0xffffffffffffffc0,%rsp
 bdc:	movq   $0x0,(%rsp)
 be4:	movq   $0x0,0x8(%rsp)
 bed:	movq   $0x0,0x10(%rsp)
 bf6:	movq   $0x0,0x18(%rsp)
 bff:	movq   $0x0,0x20(%rsp)
 c08:	movq   $0x0,0x28(%rsp)
 c11:	movq   $0x0,0x30(%rsp)
 c1a:	movq   $0x0,0x38(%rsp)
 c23:	movups (%rsi),%xmm0
 c26:	movups 0x10(%rsi),%xmm1
 c2a:	movups 0x20(%rsi),%xmm2
 c2e:	movups 0x30(%rsi),%xmm3
 c32:	movups %xmm0,(%rsp)
 c36:	movups %xmm1,0x10(%rsp)
 c3b:	movups %xmm2,0x20(%rsp)
 c40:	movups %xmm3,0x30(%rsp)
 c45:	mov    (%rsp),%rax
 c49:	mov    %rax,(%rdi)
 c4c:	mov    0x8(%rsp),%rax
 c51:	mov    %rax,0x8(%rdi)
 c55:	mov    0x10(%rsp),%rax
 c5a:	mov    %rax,0x10(%rdi)
 c5e:	mov    0x18(%rsp),%rax
 c63:	mov    %rax,0x18(%rdi)
 c67:	mov    0x20(%rsp),%rax
 c6c:	mov    %rax,0x20(%rdi)
 c70:	mov    0x28(%rsp),%rax
 c75:	mov    %rax,0x28(%rdi)
 c79:	mov    0x30(%rsp),%rax
 c7e:	mov    %rax,0x30(%rdi)
 c82:	mov    0x38(%rsp),%rax
 c87:	mov    %rax,0x38(%rdi)
 c8b:	mov    %rbp,%rsp
 c8e:	pop    %rbp
 c8f:	ret

/tmp/buster-3641-evidence/constructors-head.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <patterns_construct_lane0>:
   0:	vmovq  %rsi,%xmm0
   5:	{evex} vmovq %xmm0,%xmm0
   b:	vmovdqu32 %zmm0,(%rdi)
  11:	vzeroupper
  14:	ret
  15:	int3
  16:	int3
  17:	int3
  18:	int3
  19:	int3
  1a:	int3
  1b:	int3
  1c:	int3
  1d:	int3
  1e:	int3
  1f:	int3

0000000000000020 <patterns_construct_pair>:
  20:	vpbroadcastq %rsi,%xmm0
  26:	vmovaps %xmm0,%xmm1
  2a:	{evex} vpinsrq $0x1,%rdx,%xmm1,%xmm1
  31:	vmovaps %xmm0,%xmm2
  35:	{evex} vpinsrq $0x1,%rdx,%xmm2,%xmm2
  3c:	vmovaps %xmm0,%xmm3
  40:	{evex} vpinsrq $0x1,%rdx,%xmm3,%xmm3
  47:	{evex} vpinsrq $0x1,%rdx,%xmm0,%xmm0
  4e:	vmovdqa64 %xmm1,%xmm1
  54:	vinserti32x4 $0x1,%xmm2,%ymm1,%ymm1
  5b:	vmovdqa64 %xmm3,%xmm3
  61:	vinserti32x4 $0x1,%xmm0,%ymm3,%ymm3
  68:	vmovdqa64 %ymm1,%ymm1
  6e:	vinserti64x4 $0x1,%ymm3,%zmm1,%zmm1
  75:	vmovdqu32 %zmm1,(%rdi)
  7b:	vzeroupper
  7e:	ret
  7f:	int3

0000000000000080 <patterns_construct_inlined>:
  80:	vpbroadcastq %rsi,%xmm0
  86:	{evex} vpinsrq $0x1,%rdx,%xmm0,%xmm0
  8d:	vmovdqa64 %xmm0,%xmm0
  93:	vmovdqa64 %ymm0,%ymm0
  99:	vmovdqu32 %zmm0,(%rdi)
  9f:	vzeroupper
  a2:	ret
  a3:	int3
  a4:	int3
  a5:	int3
  a6:	int3
  a7:	int3
  a8:	int3
  a9:	int3
  aa:	int3
  ab:	int3
  ac:	int3
  ad:	int3
  ae:	int3
  af:	int3

00000000000000b0 <patterns_construct_mixed>:
  b0:	vpxord %xmm0,%xmm0,%xmm0
  b6:	movabs $0x123456789abcdef,%rax
  c0:	vmovaps %xmm0,%xmm1
  c4:	{evex} vpinsrq $0x0,%rax,%xmm1,%xmm1
  cb:	{evex} vpinsrq $0x1,%rsi,%xmm1,%xmm1
  d2:	mov    $0xffffffffffffffff,%rax
  d9:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
  e0:	vpbroadcastq %rdx,%xmm2
  e6:	movabs $0x8000000000000000,%rax
  f0:	{evex} vpinsrq $0x1,%rax,%xmm2,%xmm2
  f7:	vpbroadcastq %rsi,%xmm3
  fd:	xor    %eax,%eax
  ff:	{evex} vpinsrq $0x1,%rax,%xmm3,%xmm3
 106:	vmovdqa64 %xmm1,%xmm1
 10c:	vinserti32x4 $0x1,%xmm0,%ymm1,%ymm1
 113:	vmovdqa64 %xmm2,%xmm2
 119:	vinserti32x4 $0x1,%xmm3,%ymm2,%ymm2
 120:	vmovdqa64 %ymm1,%ymm1
 126:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm1
 12d:	vmovdqu32 %zmm1,(%rdi)
 133:	vzeroupper
 136:	ret
 137:	int3
 138:	int3
 139:	int3
 13a:	int3
 13b:	int3
 13c:	int3
 13d:	int3
 13e:	int3
 13f:	int3

0000000000000140 <patterns_construct_all>:
 140:	mov    (%rsi),%rax
 143:	mov    0x10(%rsi),%rcx
 147:	mov    0x20(%rsi),%rdx
 14b:	mov    0x30(%rsi),%r8
 14f:	mov    0x8(%rsi),%r9
 153:	mov    0x18(%rsi),%r10
 157:	mov    %rdi,-0x8(%rsp)
 15c:	mov    0x28(%rsi),%rdi
 160:	mov    0x38(%rsi),%rsi
 164:	vpbroadcastq %rax,%xmm0
 16a:	{evex} vpinsrq $0x1,-0x18(%rsp),%xmm0,%xmm0
 171:	vpbroadcastq %rdx,%xmm1
 177:	{evex} vpinsrq $0x1,%r8,%xmm1,%xmm1
 17e:	vpbroadcastq %r9,%xmm2
 184:	{evex} vpinsrq $0x1,%r10,%xmm2,%xmm2
 18b:	vpbroadcastq %rdi,%xmm3
 191:	{evex} vpinsrq $0x1,%rsi,%xmm3,%xmm3
 198:	vmovdqa64 %xmm0,%xmm0
 19e:	vinserti32x4 $0x1,%xmm1,%ymm0,%ymm0
 1a5:	vmovdqa64 %xmm2,%xmm2
 1ab:	vinserti32x4 $0x1,%xmm3,%ymm2,%ymm2
 1b2:	vmovdqa64 %ymm0,%ymm0
 1b8:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 1bf:	mov    -0x8(%rsp),%rdi
 1c4:	vmovdqu32 %zmm0,(%rdi)
 1ca:	vzeroupper
 1cd:	ret
 1ce:	int3
 1cf:	int3

00000000000001d0 <patterns_construct_ends>:
 1d0:	vpbroadcastq %rsi,%xmm0
 1d6:	xor    %eax,%eax
 1d8:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 1df:	vpxord %xmm1,%xmm1,%xmm1
 1e5:	{evex} vpinsrq $0x1,%rdx,%xmm1,%xmm1
 1ec:	vmovdqa64 %xmm0,%xmm0
 1f2:	vpxord %ymm2,%ymm2,%ymm2
 1f8:	vinserti32x4 $0x1,%xmm1,%ymm2,%ymm2
 1ff:	vmovdqa64 %ymm0,%ymm0
 205:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 20c:	vmovdqu32 %zmm0,(%rdi)
 212:	vzeroupper
 215:	ret
 216:	int3
 217:	int3
 218:	int3
 219:	int3
 21a:	int3
 21b:	int3
 21c:	int3
 21d:	int3
 21e:	int3
 21f:	int3

0000000000000220 <patterns_construct_splat>:
 220:	vpbroadcastq %rsi,%zmm0
 226:	vmovdqu32 %zmm0,(%rdi)
 22c:	vzeroupper
 22f:	ret

0000000000000230 <patterns_construct_constant>:
 230:	vmovdqu32 0x0(%rip),%zmm0        # 23a <patterns_construct_constant+0xa>
 23a:	vmovdqu32 %zmm0,(%rdi)
 240:	vzeroupper
 243:	ret
 244:	int3
 245:	int3
 246:	int3
 247:	int3
 248:	int3
 249:	int3
 24a:	int3
 24b:	int3
 24c:	int3
 24d:	int3
 24e:	int3
 24f:	int3

0000000000000250 <patterns_construct_u32>:
 250:	vpbroadcastd %esi,%xmm0
 256:	xor    %eax,%eax
 258:	{evex} vpinsrd $0x1,%eax,%xmm0,%xmm0
 25f:	{evex} vpinsrd $0x2,%edx,%xmm0,%xmm0
 266:	mov    $0x80000000,%eax
 26b:	{evex} vpinsrd $0x3,%eax,%xmm0,%xmm0
 272:	vmovdqa64 %xmm0,%xmm0
 278:	vmovdqa64 %ymm0,%ymm0
 27e:	vmovdqu32 %zmm0,(%rdi)
 284:	vzeroupper
 287:	ret
 288:	int3
 289:	int3
 28a:	int3
 28b:	int3
 28c:	int3
 28d:	int3
 28e:	int3
 28f:	int3

0000000000000290 <patterns_construct_u16>:
 290:	movzwl %si,%eax
 293:	movzwl %dx,%ecx
 296:	vpbroadcastw %eax,%xmm0
 29c:	xor    %eax,%eax
 29e:	{evex} vpinsrw $0x1,%eax,%xmm0,%xmm0
 2a5:	{evex} vpinsrw $0x2,%ecx,%xmm0,%xmm0
 2ac:	mov    $0x8000,%eax
 2b1:	{evex} vpinsrw $0x3,%eax,%xmm0,%xmm0
 2b8:	xor    %eax,%eax
 2ba:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 2c1:	vmovdqa64 %xmm0,%xmm0
 2c7:	vmovdqa64 %ymm0,%ymm0
 2cd:	vmovdqu32 %zmm0,(%rdi)
 2d3:	vzeroupper
 2d6:	ret
 2d7:	int3
 2d8:	int3
 2d9:	int3
 2da:	int3
 2db:	int3
 2dc:	int3
 2dd:	int3
 2de:	int3
 2df:	int3

00000000000002e0 <patterns_construct_u8>:
 2e0:	movzbl %sil,%eax
 2e4:	movzbl %dl,%ecx
 2e7:	vpbroadcastb %eax,%xmm0
 2ed:	xor    %eax,%eax
 2ef:	{evex} vpinsrb $0x1,%eax,%xmm0,%xmm0
 2f6:	{evex} vpinsrb $0x2,%ecx,%xmm0,%xmm0
 2fd:	mov    $0x80,%eax
 302:	{evex} vpinsrb $0x3,%eax,%xmm0,%xmm0
 309:	xor    %eax,%eax
 30b:	{evex} vpinsrd $0x1,%eax,%xmm0,%xmm0
 312:	xor    %eax,%eax
 314:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 31b:	vmovdqa64 %xmm0,%xmm0
 321:	vmovdqa64 %ymm0,%ymm0
 327:	vmovdqu32 %zmm0,(%rdi)
 32d:	vzeroupper
 330:	ret
 331:	int3
 332:	int3
 333:	int3
 334:	int3
 335:	int3
 336:	int3
 337:	int3
 338:	int3
 339:	int3
 33a:	int3
 33b:	int3
 33c:	int3
 33d:	int3
 33e:	int3
 33f:	int3

0000000000000340 <patterns_construct_volatile>:
 340:	mov    (%rsi),%rax
 343:	mov    (%rsi),%rcx
 346:	mov    (%rsi),%rdx
 349:	mov    (%rsi),%r8
 34c:	mov    (%rsi),%r9
 34f:	mov    (%rsi),%r10
 352:	mov    %rdi,-0x8(%rsp)
 357:	mov    (%rsi),%rdi
 35a:	mov    (%rsi),%rsi
 35d:	vpbroadcastq %rax,%xmm0
 363:	{evex} vpinsrq $0x1,%rcx,%xmm0,%xmm0
 36a:	vpbroadcastq %rdx,%xmm1
 370:	{evex} vpinsrq $0x1,%r8,%xmm1,%xmm1
 377:	vpbroadcastq %r9,%xmm2
 37d:	{evex} vpinsrq $0x1,%r10,%xmm2,%xmm2
 384:	vpbroadcastq %rdi,%xmm3
 38a:	{evex} vpinsrq $0x1,%rsi,%xmm3,%xmm3
 391:	vmovdqa64 %xmm0,%xmm0
 397:	vinserti32x4 $0x1,%xmm1,%ymm0,%ymm0
 39e:	vmovdqa64 %xmm2,%xmm2
 3a4:	vinserti32x4 $0x1,%xmm3,%ymm2,%ymm2
 3ab:	vmovdqa64 %ymm0,%ymm0
 3b1:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 3b8:	mov    -0x8(%rsp),%rdi
 3bd:	vmovdqu32 %zmm0,(%rdi)
 3c3:	vzeroupper
 3c6:	ret
 3c7:	int3
 3c8:	int3
 3c9:	int3
 3ca:	int3
 3cb:	int3
 3cc:	int3
 3cd:	int3
 3ce:	int3
 3cf:	int3

00000000000003d0 <patterns_construct_effects>:
 3d0:	mov    (%rsi),%rax
 3d3:	lea    0x1(%rax),%rcx
 3d7:	mov    %rcx,(%rsi)
 3da:	mov    (%rsi),%rcx
 3dd:	lea    0x1(%rcx),%r8
 3e1:	mov    %r8,(%rsi)
 3e4:	vpbroadcastq %rax,%xmm0
 3ea:	{evex} vpinsrq $0x1,%rdx,%xmm0,%xmm0
 3f1:	vpbroadcastq %rcx,%xmm1
 3f7:	{evex} vpinsrq $0x1,%rdx,%xmm1,%xmm1
 3fe:	vmovdqa64 %xmm0,%xmm0
 404:	vinserti32x4 $0x1,%xmm1,%ymm0,%ymm0
 40b:	vmovdqa64 %ymm0,%ymm0
 411:	vmovdqu32 %zmm0,(%rdi)
 417:	vzeroupper
 41a:	ret
 41b:	int3
 41c:	int3
 41d:	int3
 41e:	int3
 41f:	int3

0000000000000420 <patterns_construct_call>:
 420:	sub    $0x18,%rsp
 424:	mov    %rcx,(%rsp)
 428:	mov    %rdx,0x8(%rsp)
 42d:	mov    %rdi,0x10(%rsp)
 432:	mov    %rsi,%rdi
 435:	vzeroupper
 438:	call   43d <patterns_construct_call+0x1d>
 43d:	mov    0x8(%rsp),%rdx
 442:	vpbroadcastq %rdx,%xmm0
 448:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 44f:	mov    (%rsp),%rcx
 453:	vpbroadcastq %rcx,%xmm1
 459:	xor    %eax,%eax
 45b:	{evex} vpinsrq $0x1,%rax,%xmm1,%xmm1
 462:	vmovdqa64 %xmm0,%xmm0
 468:	vinserti32x4 $0x1,%xmm1,%ymm0,%ymm0
 46f:	vmovdqa64 %ymm0,%ymm0
 475:	mov    0x10(%rsp),%rdi
 47a:	vmovdqu32 %zmm0,(%rdi)
 480:	vzeroupper
 483:	add    $0x18,%rsp
 487:	ret
 488:	int3
 489:	int3
 48a:	int3
 48b:	int3
 48c:	int3
 48d:	int3
 48e:	int3
 48f:	int3

0000000000000490 <patterns_construct_escape>:
 490:	push   %rbp
 491:	mov    %rsp,%rbp
 494:	sub    $0x50,%rsp
 498:	and    $0xffffffffffffffc0,%rsp
 49c:	lea    (%rsp),%rax
 4a0:	movq   $0x0,(%rsp)
 4a8:	movq   $0x0,0x8(%rsp)
 4b1:	movq   $0x0,0x10(%rsp)
 4ba:	movq   $0x0,0x18(%rsp)
 4c3:	movq   $0x0,0x20(%rsp)
 4cc:	movq   $0x0,0x28(%rsp)
 4d5:	movq   $0x0,0x30(%rsp)
 4de:	movq   $0x0,0x38(%rsp)
 4e7:	mov    %rsi,(%rsp)
 4eb:	mov    %rdi,0x40(%rsp)
 4f0:	mov    %rax,%rdi
 4f3:	mov    %rdx,%rsi
 4f6:	vzeroupper
 4f9:	call   4fe <patterns_construct_escape+0x6e>
 4fe:	vmovdqu32 (%rsp),%zmm0
 505:	mov    0x40(%rsp),%rdi
 50a:	vmovdqu32 %zmm0,(%rdi)
 510:	vzeroupper
 513:	mov    %rbp,%rsp
 516:	pop    %rbp
 517:	ret
