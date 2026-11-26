
/tmp/buster-3641-evidence/constructors-head-noinline.o:     file format elf64-x86-64


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

0000000000000080 <patterns_construct_inline_value>:
  80:	sub    $0x48,%rsp
  84:	lea    (%rsp),%rax
  88:	vpbroadcastq %rdi,%xmm0
  8e:	{evex} vpinsrq $0x1,%rsi,%xmm0,%xmm0
  95:	vmovdqa64 %xmm0,%xmm0
  9b:	vmovdqa64 %ymm0,%ymm0
  a1:	vmovdqu32 %zmm0,(%rsp)
  a8:	vmovdqu64 (%rax),%zmm0
  ae:	add    $0x48,%rsp
  b2:	ret
  b3:	int3
  b4:	int3
  b5:	int3
  b6:	int3
  b7:	int3
  b8:	int3
  b9:	int3
  ba:	int3
  bb:	int3
  bc:	int3
  bd:	int3
  be:	int3
  bf:	int3

00000000000000c0 <patterns_construct_inlined>:
  c0:	sub    $0x48,%rsp
  c4:	mov    %rdi,0x40(%rsp)
  c9:	mov    %rsi,%rdi
  cc:	mov    %rdx,%rsi
  cf:	vzeroupper
  d2:	call   d7 <patterns_construct_inlined+0x17>
  d7:	vmovdqu64 %zmm0,(%rsp)
  de:	vmovdqu32 (%rsp),%zmm0
  e5:	mov    0x40(%rsp),%rdi
  ea:	vmovdqu32 %zmm0,(%rdi)
  f0:	vzeroupper
  f3:	add    $0x48,%rsp
  f7:	ret
  f8:	int3
  f9:	int3
  fa:	int3
  fb:	int3
  fc:	int3
  fd:	int3
  fe:	int3
  ff:	int3

0000000000000100 <patterns_construct_mixed>:
 100:	vpxord %xmm0,%xmm0,%xmm0
 106:	movabs $0x123456789abcdef,%rax
 110:	vmovaps %xmm0,%xmm1
 114:	{evex} vpinsrq $0x0,%rax,%xmm1,%xmm1
 11b:	{evex} vpinsrq $0x1,%rsi,%xmm1,%xmm1
 122:	mov    $0xffffffffffffffff,%rax
 129:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 130:	vpbroadcastq %rdx,%xmm2
 136:	movabs $0x8000000000000000,%rax
 140:	{evex} vpinsrq $0x1,%rax,%xmm2,%xmm2
 147:	vpbroadcastq %rsi,%xmm3
 14d:	xor    %eax,%eax
 14f:	{evex} vpinsrq $0x1,%rax,%xmm3,%xmm3
 156:	vmovdqa64 %xmm1,%xmm1
 15c:	vinserti32x4 $0x1,%xmm0,%ymm1,%ymm1
 163:	vmovdqa64 %xmm2,%xmm2
 169:	vinserti32x4 $0x1,%xmm3,%ymm2,%ymm2
 170:	vmovdqa64 %ymm1,%ymm1
 176:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm1
 17d:	vmovdqu32 %zmm1,(%rdi)
 183:	vzeroupper
 186:	ret
 187:	int3
 188:	int3
 189:	int3
 18a:	int3
 18b:	int3
 18c:	int3
 18d:	int3
 18e:	int3
 18f:	int3

0000000000000190 <patterns_construct_all>:
 190:	mov    (%rsi),%rax
 193:	mov    0x10(%rsi),%rcx
 197:	mov    0x20(%rsi),%rdx
 19b:	mov    0x30(%rsi),%r8
 19f:	mov    0x8(%rsi),%r9
 1a3:	mov    0x18(%rsi),%r10
 1a7:	mov    %rdi,-0x8(%rsp)
 1ac:	mov    0x28(%rsi),%rdi
 1b0:	mov    0x38(%rsi),%rsi
 1b4:	vpbroadcastq %rax,%xmm0
 1ba:	{evex} vpinsrq $0x1,%rcx,%xmm0,%xmm0
 1c1:	vpbroadcastq %rdx,%xmm1
 1c7:	{evex} vpinsrq $0x1,%r8,%xmm1,%xmm1
 1ce:	vpbroadcastq %r9,%xmm2
 1d4:	{evex} vpinsrq $0x1,%r10,%xmm2,%xmm2
 1db:	vpbroadcastq %rdi,%xmm3
 1e1:	{evex} vpinsrq $0x1,%rsi,%xmm3,%xmm3
 1e8:	vmovdqa64 %xmm0,%xmm0
 1ee:	vinserti32x4 $0x1,%xmm1,%ymm0,%ymm0
 1f5:	vmovdqa64 %xmm2,%xmm2
 1fb:	vinserti32x4 $0x1,%xmm3,%ymm2,%ymm2
 202:	vmovdqa64 %ymm0,%ymm0
 208:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 20f:	mov    -0x8(%rsp),%rdi
 214:	vmovdqu32 %zmm0,(%rdi)
 21a:	vzeroupper
 21d:	ret
 21e:	int3
 21f:	int3

0000000000000220 <patterns_construct_ends>:
 220:	vpbroadcastq %rsi,%xmm0
 226:	xor    %eax,%eax
 228:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 22f:	vpxord %xmm1,%xmm1,%xmm1
 235:	{evex} vpinsrq $0x1,%rdx,%xmm1,%xmm1
 23c:	vmovdqa64 %xmm0,%xmm0
 242:	vpxord %ymm2,%ymm2,%ymm2
 248:	vinserti32x4 $0x1,%xmm1,%ymm2,%ymm2
 24f:	vmovdqa64 %ymm0,%ymm0
 255:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 25c:	vmovdqu32 %zmm0,(%rdi)
 262:	vzeroupper
 265:	ret
 266:	int3
 267:	int3
 268:	int3
 269:	int3
 26a:	int3
 26b:	int3
 26c:	int3
 26d:	int3
 26e:	int3
 26f:	int3

0000000000000270 <patterns_construct_splat>:
 270:	vpbroadcastq %rsi,%zmm0
 276:	vmovdqu32 %zmm0,(%rdi)
 27c:	vzeroupper
 27f:	ret

0000000000000280 <patterns_construct_constant>:
 280:	vmovdqu32 0x0(%rip),%zmm0        # 28a <patterns_construct_constant+0xa>
 28a:	vmovdqu32 %zmm0,(%rdi)
 290:	vzeroupper
 293:	ret
 294:	int3
 295:	int3
 296:	int3
 297:	int3
 298:	int3
 299:	int3
 29a:	int3
 29b:	int3
 29c:	int3
 29d:	int3
 29e:	int3
 29f:	int3

00000000000002a0 <patterns_construct_u32>:
 2a0:	vpbroadcastd %esi,%xmm0
 2a6:	xor    %eax,%eax
 2a8:	{evex} vpinsrd $0x1,%eax,%xmm0,%xmm0
 2af:	{evex} vpinsrd $0x2,%edx,%xmm0,%xmm0
 2b6:	mov    $0x80000000,%eax
 2bb:	{evex} vpinsrd $0x3,%eax,%xmm0,%xmm0
 2c2:	vmovdqa64 %xmm0,%xmm0
 2c8:	vmovdqa64 %ymm0,%ymm0
 2ce:	vmovdqu32 %zmm0,(%rdi)
 2d4:	vzeroupper
 2d7:	ret
 2d8:	int3
 2d9:	int3
 2da:	int3
 2db:	int3
 2dc:	int3
 2dd:	int3
 2de:	int3
 2df:	int3

00000000000002e0 <patterns_construct_u16>:
 2e0:	movzwl %si,%eax
 2e3:	movzwl %dx,%ecx
 2e6:	vpbroadcastw %eax,%xmm0
 2ec:	xor    %eax,%eax
 2ee:	{evex} vpinsrw $0x1,%eax,%xmm0,%xmm0
 2f5:	{evex} vpinsrw $0x2,%ecx,%xmm0,%xmm0
 2fc:	mov    $0x8000,%eax
 301:	{evex} vpinsrw $0x3,%eax,%xmm0,%xmm0
 308:	xor    %eax,%eax
 30a:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 311:	vmovdqa64 %xmm0,%xmm0
 317:	vmovdqa64 %ymm0,%ymm0
 31d:	vmovdqu32 %zmm0,(%rdi)
 323:	vzeroupper
 326:	ret
 327:	int3
 328:	int3
 329:	int3
 32a:	int3
 32b:	int3
 32c:	int3
 32d:	int3
 32e:	int3
 32f:	int3

0000000000000330 <patterns_construct_u8>:
 330:	movzbl %sil,%eax
 334:	movzbl %dl,%ecx
 337:	vpbroadcastb %eax,%xmm0
 33d:	xor    %eax,%eax
 33f:	{evex} vpinsrb $0x1,%eax,%xmm0,%xmm0
 346:	{evex} vpinsrb $0x2,%ecx,%xmm0,%xmm0
 34d:	mov    $0x80,%eax
 352:	{evex} vpinsrb $0x3,%eax,%xmm0,%xmm0
 359:	xor    %eax,%eax
 35b:	{evex} vpinsrd $0x1,%eax,%xmm0,%xmm0
 362:	xor    %eax,%eax
 364:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 36b:	vmovdqa64 %xmm0,%xmm0
 371:	vmovdqa64 %ymm0,%ymm0
 377:	vmovdqu32 %zmm0,(%rdi)
 37d:	vzeroupper
 380:	ret
 381:	int3
 382:	int3
 383:	int3
 384:	int3
 385:	int3
 386:	int3
 387:	int3
 388:	int3
 389:	int3
 38a:	int3
 38b:	int3
 38c:	int3
 38d:	int3
 38e:	int3
 38f:	int3

0000000000000390 <patterns_construct_volatile>:
 390:	mov    (%rsi),%rax
 393:	mov    (%rsi),%rcx
 396:	mov    (%rsi),%rdx
 399:	mov    (%rsi),%r8
 39c:	mov    (%rsi),%r9
 39f:	mov    (%rsi),%r10
 3a2:	mov    %rdi,-0x8(%rsp)
 3a7:	mov    (%rsi),%rdi
 3aa:	mov    (%rsi),%rsi
 3ad:	vpbroadcastq %rax,%xmm0
 3b3:	{evex} vpinsrq $0x1,%rcx,%xmm0,%xmm0
 3ba:	vpbroadcastq %rdx,%xmm1
 3c0:	{evex} vpinsrq $0x1,%r8,%xmm1,%xmm1
 3c7:	vpbroadcastq %r9,%xmm2
 3cd:	{evex} vpinsrq $0x1,%r10,%xmm2,%xmm2
 3d4:	vpbroadcastq %rdi,%xmm3
 3da:	{evex} vpinsrq $0x1,%rsi,%xmm3,%xmm3
 3e1:	vmovdqa64 %xmm0,%xmm0
 3e7:	vinserti32x4 $0x1,%xmm1,%ymm0,%ymm0
 3ee:	vmovdqa64 %xmm2,%xmm2
 3f4:	vinserti32x4 $0x1,%xmm3,%ymm2,%ymm2
 3fb:	vmovdqa64 %ymm0,%ymm0
 401:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 408:	mov    -0x8(%rsp),%rdi
 40d:	vmovdqu32 %zmm0,(%rdi)
 413:	vzeroupper
 416:	ret
 417:	int3
 418:	int3
 419:	int3
 41a:	int3
 41b:	int3
 41c:	int3
 41d:	int3
 41e:	int3
 41f:	int3

0000000000000420 <patterns_construct_effects>:
 420:	mov    (%rsi),%rax
 423:	lea    0x1(%rax),%rcx
 427:	mov    %rcx,(%rsi)
 42a:	mov    (%rsi),%rcx
 42d:	lea    0x1(%rcx),%r8
 431:	mov    %r8,(%rsi)
 434:	vpbroadcastq %rax,%xmm0
 43a:	{evex} vpinsrq $0x1,%rdx,%xmm0,%xmm0
 441:	vpbroadcastq %rcx,%xmm1
 447:	{evex} vpinsrq $0x1,%rdx,%xmm1,%xmm1
 44e:	vmovdqa64 %xmm0,%xmm0
 454:	vinserti32x4 $0x1,%xmm1,%ymm0,%ymm0
 45b:	vmovdqa64 %ymm0,%ymm0
 461:	vmovdqu32 %zmm0,(%rdi)
 467:	vzeroupper
 46a:	ret
 46b:	int3
 46c:	int3
 46d:	int3
 46e:	int3
 46f:	int3

0000000000000470 <patterns_construct_call>:
 470:	sub    $0x18,%rsp
 474:	mov    %rcx,(%rsp)
 478:	mov    %rdx,0x8(%rsp)
 47d:	mov    %rdi,0x10(%rsp)
 482:	mov    %rsi,%rdi
 485:	vzeroupper
 488:	call   48d <patterns_construct_call+0x1d>
 48d:	mov    0x8(%rsp),%rdx
 492:	vpbroadcastq %rdx,%xmm0
 498:	{evex} vpinsrq $0x1,%rax,%xmm0,%xmm0
 49f:	mov    (%rsp),%rcx
 4a3:	vpbroadcastq %rcx,%xmm1
 4a9:	xor    %eax,%eax
 4ab:	{evex} vpinsrq $0x1,%rax,%xmm1,%xmm1
 4b2:	vmovdqa64 %xmm0,%xmm0
 4b8:	vinserti32x4 $0x1,%xmm1,%ymm0,%ymm0
 4bf:	vmovdqa64 %ymm0,%ymm0
 4c5:	mov    0x10(%rsp),%rdi
 4ca:	vmovdqu32 %zmm0,(%rdi)
 4d0:	vzeroupper
 4d3:	add    $0x18,%rsp
 4d7:	ret
 4d8:	int3
 4d9:	int3
 4da:	int3
 4db:	int3
 4dc:	int3
 4dd:	int3
 4de:	int3
 4df:	int3

00000000000004e0 <patterns_construct_escape>:
 4e0:	push   %rbp
 4e1:	mov    %rsp,%rbp
 4e4:	sub    $0x50,%rsp
 4e8:	and    $0xffffffffffffffc0,%rsp
 4ec:	lea    (%rsp),%rax
 4f0:	movq   $0x0,(%rsp)
 4f8:	movq   $0x0,0x8(%rsp)
 501:	movq   $0x0,0x10(%rsp)
 50a:	movq   $0x0,0x18(%rsp)
 513:	movq   $0x0,0x20(%rsp)
 51c:	movq   $0x0,0x28(%rsp)
 525:	movq   $0x0,0x30(%rsp)
 52e:	movq   $0x0,0x38(%rsp)
 537:	mov    %rsi,(%rsp)
 53b:	mov    %rdi,0x40(%rsp)
 540:	mov    %rax,%rdi
 543:	mov    %rdx,%rsi
 546:	vzeroupper
 549:	call   54e <patterns_construct_escape+0x6e>
 54e:	vmovdqu32 (%rsp),%zmm0
 555:	mov    0x40(%rsp),%rdi
 55a:	vmovdqu32 %zmm0,(%rdi)
 560:	vzeroupper
 563:	mov    %rbp,%rsp
 566:	pop    %rbp
 567:	ret
