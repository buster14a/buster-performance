
bin/k-base.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_sum_i32>:
   0:	xor    %eax,%eax
   2:	xor    %ecx,%ecx
   4:	xor    %edx,%edx
   6:	test   %rsi,%rsi
   9:	cmova  %rsi,%rdx
   d:	and    $0xfffffffffffffff8,%rdx
  11:	xor    %r8d,%r8d
  14:	test   %rdx,%rdx
  17:	setne  %r8b
  1b:	vpxord %zmm0,%zmm0,%zmm0
  21:	test   %r8d,%r8d
  24:	je     7f <k_sum_i32+0x7f>
  26:	vmovdqu32 (%rdi,%rcx,4),%ymm1
  2d:	vpmovsxdq %ymm1,%zmm1
  33:	vpaddq %zmm1,%zmm0,%zmm0
  39:	add    $0x8,%rcx
  3d:	cmp    %rdx,%rcx
  40:	jb     26 <k_sum_i32+0x26>
  42:	vextracti64x4 $0x1,%zmm0,%ymm15
  49:	{evex} vpaddq %ymm15,%ymm0,%ymm0
  4f:	vextracti32x4 $0x1,%ymm0,%xmm15
  56:	{evex} vpaddq %xmm15,%xmm0,%xmm0
  5c:	{evex} vpshufd $0x4e,%xmm0,%xmm15
  63:	{evex} vpaddq %xmm15,%xmm0,%xmm0
  69:	{evex} vmovq %xmm0,%rax
  6f:	mov    %rdx,%rcx
  72:	jmp    7f <k_sum_i32+0x7f>
  74:	movslq (%rdi,%rcx,4),%rdx
  78:	add    %rdx,%rax
  7b:	add    $0x1,%rcx
  7f:	cmp    %rsi,%rcx
  82:	jb     74 <k_sum_i32+0x74>
  84:	ret
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

0000000000000090 <k_sum_u8>:
  90:	xor    %eax,%eax
  92:	xor    %ecx,%ecx
  94:	xor    %edx,%edx
  96:	test   %rsi,%rsi
  99:	cmova  %rsi,%rdx
  9d:	and    $0xfffffffffffffff0,%rdx
  a1:	xor    %r8d,%r8d
  a4:	test   %rdx,%rdx
  a7:	setne  %r8b
  ab:	vpxord %zmm0,%zmm0,%zmm0
  b1:	test   %r8d,%r8d
  b4:	je     11b <k_sum_u8+0x8b>
  b6:	vmovdqu32 (%rdi,%rcx,1),%xmm1
  bd:	vpmovzxbd %xmm1,%zmm1
  c3:	vpaddd %zmm1,%zmm0,%zmm0
  c9:	add    $0x10,%rcx
  cd:	cmp    %rdx,%rcx
  d0:	jb     b6 <k_sum_u8+0x26>
  d2:	vextracti64x4 $0x1,%zmm0,%ymm15
  d9:	{evex} vpaddd %ymm15,%ymm0,%ymm0
  df:	vextracti32x4 $0x1,%ymm0,%xmm15
  e6:	{evex} vpaddd %xmm15,%xmm0,%xmm0
  ec:	{evex} vpshufd $0x4e,%xmm0,%xmm15
  f3:	{evex} vpaddd %xmm15,%xmm0,%xmm0
  f9:	{evex} vpshufd $0xb1,%xmm0,%xmm15
 100:	{evex} vpaddd %xmm15,%xmm0,%xmm0
 106:	{evex} vmovd %xmm0,%eax
 10c:	mov    %rdx,%rcx
 10f:	jmp    11b <k_sum_u8+0x8b>
 111:	movzbl (%rdi,%rcx,1),%edx
 115:	add    %edx,%eax
 117:	add    $0x1,%rcx
 11b:	cmp    %rsi,%rcx
 11e:	jb     111 <k_sum_u8+0x81>
 120:	ret
 121:	int3
 122:	int3
 123:	int3
 124:	int3
 125:	int3
 126:	int3
 127:	int3
 128:	int3
 129:	int3
 12a:	int3
 12b:	int3
 12c:	int3
 12d:	int3
 12e:	int3
 12f:	int3

0000000000000130 <k_dot_i16>:
 130:	xor    %eax,%eax
 132:	xor    %ecx,%ecx
 134:	xor    %r8d,%r8d
 137:	test   %rdx,%rdx
 13a:	cmova  %rdx,%r8
 13e:	and    $0xfffffffffffffff0,%r8
 142:	xor    %r9d,%r9d
 145:	test   %r8,%r8
 148:	setne  %r9b
 14c:	vpxord %zmm0,%zmm0,%zmm0
 152:	test   %r9d,%r9d
 155:	je     1de <k_dot_i16+0xae>
 15b:	vmovdqu32 (%rdi,%rcx,2),%ymm1
 162:	vpmovsxwd %ymm1,%zmm1
 168:	vmovdqu32 (%rsi,%rcx,2),%ymm2
 16f:	vpmovsxwd %ymm2,%zmm2
 175:	vpmulld %zmm2,%zmm1,%zmm2
 17b:	vpaddd %zmm2,%zmm0,%zmm0
 181:	add    $0x10,%rcx
 185:	cmp    %r8,%rcx
 188:	jb     15b <k_dot_i16+0x2b>
 18a:	vextracti64x4 $0x1,%zmm0,%ymm15
 191:	{evex} vpaddd %ymm15,%ymm0,%ymm0
 197:	vextracti32x4 $0x1,%ymm0,%xmm15
 19e:	{evex} vpaddd %xmm15,%xmm0,%xmm0
 1a4:	{evex} vpshufd $0x4e,%xmm0,%xmm15
 1ab:	{evex} vpaddd %xmm15,%xmm0,%xmm0
 1b1:	{evex} vpshufd $0xb1,%xmm0,%xmm15
 1b8:	{evex} vpaddd %xmm15,%xmm0,%xmm0
 1be:	{evex} vmovd %xmm0,%eax
 1c4:	mov    %r8,%rcx
 1c7:	jmp    1de <k_dot_i16+0xae>
 1c9:	movswl (%rdi,%rcx,2),%r8d
 1ce:	movswl (%rsi,%rcx,2),%r9d
 1d3:	imul   %r9d,%r8d
 1d7:	add    %r8d,%eax
 1da:	add    $0x1,%rcx
 1de:	cmp    %rdx,%rcx
 1e1:	jb     1c9 <k_dot_i16+0x99>
 1e3:	ret
 1e4:	int3
 1e5:	int3
 1e6:	int3
 1e7:	int3
 1e8:	int3
 1e9:	int3
 1ea:	int3
 1eb:	int3
 1ec:	int3
 1ed:	int3
 1ee:	int3
 1ef:	int3

00000000000001f0 <k_max_i32>:
 1f0:	mov    $0x80000000,%eax
 1f5:	xor    %ecx,%ecx
 1f7:	jmp    205 <k_max_i32+0x15>
 1f9:	cmp    (%rdi,%rcx,4),%eax
 1fc:	jge    201 <k_max_i32+0x11>
 1fe:	mov    (%rdi,%rcx,4),%eax
 201:	add    $0x1,%rcx
 205:	cmp    %rsi,%rcx
 208:	jb     1f9 <k_max_i32+0x9>
 20a:	ret
 20b:	int3
 20c:	int3
 20d:	int3
 20e:	int3
 20f:	int3

0000000000000210 <k_count_eq_u8>:
 210:	movzbl %dl,%eax
 213:	xor    %ecx,%ecx
 215:	xor    %edx,%edx
 217:	jmp    235 <k_count_eq_u8+0x25>
 219:	movzbl (%rdi,%rdx,1),%r8d
 21e:	mov    %eax,%r9d
 221:	cmp    %r9d,%r8d
 224:	mov    $0x0,%r8d
 22a:	sete   %r8b
 22e:	add    %r8,%rcx
 231:	add    $0x1,%rdx
 235:	cmp    %rsi,%rdx
 238:	jb     219 <k_count_eq_u8+0x9>
 23a:	mov    %rcx,%rax
 23d:	ret
 23e:	int3
 23f:	int3

0000000000000240 <k_cond_sum_i32>:
 240:	xor    %eax,%eax
 242:	xor    %ecx,%ecx
 244:	xor    %r8d,%r8d
 247:	test   %rsi,%rsi
 24a:	cmova  %rsi,%r8
 24e:	and    $0xfffffffffffffff8,%r8
 252:	xor    %r9d,%r9d
 255:	test   %r8,%r8
 258:	setne  %r9b
 25c:	vpbroadcastd %edx,%ymm0
 262:	vpxord %zmm1,%zmm1,%zmm1
 268:	vpxord %zmm2,%zmm2,%zmm2
 26e:	test   %r9d,%r9d
 271:	je     2e6 <k_cond_sum_i32+0xa6>
 273:	vmovdqu32 (%rdi,%rcx,4),%ymm3
 27a:	vpcmpnled %ymm0,%ymm3,%k1
 281:	vpmovsxdq %ymm3,%zmm3
 287:	vpblendmq %zmm3,%zmm1,%zmm3{%k1}
 28d:	vpaddq %zmm3,%zmm2,%zmm2
 293:	add    $0x8,%rcx
 297:	cmp    %r8,%rcx
 29a:	jb     273 <k_cond_sum_i32+0x33>
 29c:	vextracti64x4 $0x1,%zmm2,%ymm15
 2a3:	{evex} vpaddq %ymm15,%ymm2,%ymm2
 2a9:	vextracti32x4 $0x1,%ymm2,%xmm15
 2b0:	{evex} vpaddq %xmm15,%xmm2,%xmm2
 2b6:	{evex} vpshufd $0x4e,%xmm2,%xmm15
 2bd:	{evex} vpaddq %xmm15,%xmm2,%xmm2
 2c3:	{evex} vmovq %xmm2,%rax
 2c9:	mov    %r8,%rcx
 2cc:	jmp    2e6 <k_cond_sum_i32+0xa6>
 2ce:	movslq (%rdi,%rcx,4),%r8
 2d2:	xor    %r9d,%r9d
 2d5:	mov    %r8,%r10
 2d8:	cmp    %edx,%r8d
 2db:	cmovg  %r10,%r9
 2df:	add    %r9,%rax
 2e2:	add    $0x1,%rcx
 2e6:	cmp    %rsi,%rcx
 2e9:	jb     2ce <k_cond_sum_i32+0x8e>
 2eb:	ret
 2ec:	int3
 2ed:	int3
 2ee:	int3
 2ef:	int3

00000000000002f0 <k_popcount_u64>:
 2f0:	xor    %eax,%eax
 2f2:	xor    %ecx,%ecx
 2f4:	xor    %edx,%edx
 2f6:	test   %rsi,%rsi
 2f9:	cmova  %rsi,%rdx
 2fd:	and    $0xfffffffffffffff8,%rdx
 301:	xor    %r8d,%r8d
 304:	test   %rdx,%rdx
 307:	setne  %r8b
 30b:	vpxord %zmm0,%zmm0,%zmm0
 311:	test   %r8d,%r8d
 314:	je     383 <k_popcount_u64+0x93>
 316:	vmovdqu32 (%rdi,%rcx,8),%zmm1
 31d:	vpopcntq %zmm1,%zmm1
 323:	vpmovqd %zmm1,%ymm1
 329:	vpmovsxdq %ymm1,%zmm1
 32f:	vpaddq %zmm1,%zmm0,%zmm0
 335:	add    $0x8,%rcx
 339:	cmp    %rdx,%rcx
 33c:	jb     316 <k_popcount_u64+0x26>
 33e:	vextracti64x4 $0x1,%zmm0,%ymm15
 345:	{evex} vpaddq %ymm15,%ymm0,%ymm0
 34b:	vextracti32x4 $0x1,%ymm0,%xmm15
 352:	{evex} vpaddq %xmm15,%xmm0,%xmm0
 358:	{evex} vpshufd $0x4e,%xmm0,%xmm15
 35f:	{evex} vpaddq %xmm15,%xmm0,%xmm0
 365:	{evex} vmovq %xmm0,%rax
 36b:	mov    %rdx,%rcx
 36e:	jmp    383 <k_popcount_u64+0x93>
 370:	mov    (%rdi,%rcx,8),%rdx
 374:	popcnt %rdx,%rdx
 379:	movslq %edx,%rdx
 37c:	add    %rdx,%rax
 37f:	add    $0x1,%rcx
 383:	cmp    %rsi,%rcx
 386:	jb     370 <k_popcount_u64+0x80>
 388:	ret
 389:	int3
 38a:	int3
 38b:	int3
 38c:	int3
 38d:	int3
 38e:	int3
 38f:	int3

0000000000000390 <k_aos_sum>:
 390:	xor    %eax,%eax
 392:	xor    %ecx,%ecx
 394:	jmp    3b8 <k_aos_sum+0x28>
 396:	mov    %rcx,%rdx
 399:	shl    $0x4,%rdx
 39d:	movslq (%rdi,%rdx,1),%rdx
 3a1:	mov    %rcx,%r8
 3a4:	shl    $0x4,%r8
 3a8:	movslq 0x8(%rdi,%r8,1),%r8
 3ad:	imul   %r8,%rdx
 3b1:	add    %rdx,%rax
 3b4:	add    $0x1,%rcx
 3b8:	cmp    %rsi,%rcx
 3bb:	jb     396 <k_aos_sum+0x6>
 3bd:	ret
 3be:	int3
 3bf:	int3

00000000000003c0 <k_add_i32>:
 3c0:	mov    %rdi,%r8
 3c3:	mov    %rsi,%r9
 3c6:	mov    %rdx,%r10
 3c9:	xor    %eax,%eax
 3cb:	test   %rcx,%rcx
 3ce:	cmova  %rcx,%rax
 3d2:	and    $0xfffffffffffffff0,%rax
 3d6:	mov    %rdx,-0x28(%rsp)
 3db:	xor    %edx,%edx
 3dd:	test   %rax,%rax
 3e0:	setne  %dl
 3e3:	mov    %rsi,-0x30(%rsp)
 3e8:	movabs $0x100000000000000,%rsi
 3f2:	cmp    %rsi,%rax
 3f5:	mov    $0x0,%esi
 3fa:	setb   %sil
 3fe:	test   %edx,%edx
 400:	cmovne %esi,%edx
 403:	mov    %r8,%rsi
 406:	mov    %rdi,-0x38(%rsp)
 40b:	mov    %rsi,%rdi
 40e:	mov    %r8,-0x18(%rsp)
 413:	mov    %rax,%r8
 416:	shl    $0x2,%r8
 41a:	mov    %r9,-0x10(%rsp)
 41f:	mov    %rcx,-0x20(%rsp)
 424:	mov    %rax,%rcx
 427:	shl    $0x2,%rcx
 42b:	mov    %r10,-0x8(%rsp)
 430:	mov    %r9,%r10
 433:	sub    %rdi,%r10
 436:	sub    %r9,%rdi
 439:	cmp    %r8,%r10
 43c:	mov    $0x0,%r8d
 442:	setae  %r8b
 446:	cmp    %rcx,%rdi
 449:	mov    $0x0,%ecx
 44e:	setae  %cl
 451:	test   %r8d,%r8d
 454:	cmovne %ecx,%r8d
 458:	test   %edx,%edx
 45a:	cmovne %r8d,%edx
 45e:	mov    %rax,%rcx
 461:	shl    $0x2,%rcx
 465:	mov    -0x8(%rsp),%rdi
 46a:	mov    %rdi,%r8
 46d:	mov    %rax,%r9
 470:	shl    $0x2,%r9
 474:	mov    %r8,%r10
 477:	sub    %rsi,%r10
 47a:	sub    %r8,%rsi
 47d:	cmp    %rcx,%r10
 480:	mov    $0x0,%ecx
 485:	setae  %cl
 488:	cmp    %r9,%rsi
 48b:	mov    $0x0,%esi
 490:	setae  %sil
 494:	test   %ecx,%ecx
 496:	cmovne %esi,%ecx
 499:	test   %edx,%edx
 49b:	cmovne %ecx,%edx
 49e:	test   %edx,%edx
 4a0:	jne    4ba <k_add_i32+0xfa>
 4a2:	mov    -0x38(%rsp),%rdi
 4a7:	mov    -0x30(%rsp),%rsi
 4ac:	mov    -0x28(%rsp),%rdx
 4b1:	mov    -0x20(%rsp),%rcx
 4b6:	xor    %eax,%eax
 4b8:	jmp    517 <k_add_i32+0x157>
 4ba:	mov    -0x18(%rsp),%r8
 4bf:	mov    -0x10(%rsp),%r9
 4c4:	xor    %ecx,%ecx
 4c6:	vmovdqu32 (%r9,%rcx,4),%zmm0
 4cd:	vmovdqu32 (%rdi,%rcx,4),%zmm1
 4d4:	vpaddd %zmm1,%zmm0,%zmm1
 4da:	vmovdqu32 %zmm1,(%r8,%rcx,4)
 4e1:	add    $0x10,%rcx
 4e5:	cmp    %rax,%rcx
 4e8:	jb     4c6 <k_add_i32+0x106>
 4ea:	mov    -0x38(%rsp),%rdi
 4ef:	mov    -0x30(%rsp),%rsi
 4f4:	mov    -0x28(%rsp),%rdx
 4f9:	mov    -0x20(%rsp),%rcx
 4fe:	jmp    517 <k_add_i32+0x157>
 500:	mov    %rcx,-0x20(%rsp)
 505:	mov    (%rsi,%rax,4),%ecx
 508:	add    (%rdx,%rax,4),%ecx
 50b:	mov    %ecx,(%rdi,%rax,4)
 50e:	add    $0x1,%rax
 512:	mov    -0x20(%rsp),%rcx
 517:	cmp    %rcx,%rax
 51a:	jb     500 <k_add_i32+0x140>
 51c:	ret
 51d:	int3
 51e:	int3
 51f:	int3

0000000000000520 <k_saxpy_f32>:
 520:	xor    %eax,%eax
 522:	jmp    538 <k_saxpy_f32+0x18>
 524:	movss  (%rdi,%rax,4),%xmm1
 529:	vfmadd231ss (%rsi,%rax,4),%xmm0,%xmm1
 52f:	movss  %xmm1,(%rdi,%rax,4)
 534:	add    $0x1,%rax
 538:	cmp    %rdx,%rax
 53b:	jb     524 <k_saxpy_f32+0x4>
 53d:	ret
 53e:	int3
 53f:	int3

0000000000000540 <k_scale_u8>:
 540:	mov    %rdi,%r8
 543:	mov    %rsi,%r9
 546:	xor    %r10d,%r10d
 549:	test   %rcx,%rcx
 54c:	cmova  %rcx,%r10
 550:	and    $0xfffffffffffffff0,%r10
 554:	xor    %eax,%eax
 556:	test   %r10,%r10
 559:	setne  %al
 55c:	mov    %rsi,-0x10(%rsp)
 561:	movabs $0x100000000000000,%rsi
 56b:	cmp    %rsi,%r10
 56e:	mov    $0x0,%esi
 573:	setb   %sil
 577:	test   %eax,%eax
 579:	cmovne %esi,%eax
 57c:	mov    %r8,%rsi
 57f:	mov    %rdi,-0x18(%rsp)
 584:	mov    %r9,%rdi
 587:	mov    %r8,-0x8(%rsp)
 58c:	mov    %rdi,%r8
 58f:	sub    %rsi,%r8
 592:	sub    %rdi,%rsi
 595:	xor    %edi,%edi
 597:	cmp    %r10,%r8
 59a:	setae  %dil
 59e:	cmp    %r10,%rsi
 5a1:	mov    $0x0,%esi
 5a6:	setae  %sil
 5aa:	test   %edi,%edi
 5ac:	cmovne %esi,%edi
 5af:	test   %eax,%eax
 5b1:	cmovne %edi,%eax
 5b4:	vpbroadcastd %edx,%zmm0
 5ba:	mov    $0x8,%r11d
 5c0:	vpbroadcastd %r11d,%zmm1
 5c6:	test   %eax,%eax
 5c8:	jne    5d8 <k_scale_u8+0x98>
 5ca:	mov    -0x18(%rsp),%rdi
 5cf:	mov    -0x10(%rsp),%rsi
 5d4:	xor    %eax,%eax
 5d6:	jmp    632 <k_scale_u8+0xf2>
 5d8:	mov    -0x8(%rsp),%r8
 5dd:	xor    %eax,%eax
 5df:	vmovdqu32 (%r9,%rax,1),%xmm2
 5e6:	vpmovzxbd %xmm2,%zmm2
 5ec:	vpmulld %zmm0,%zmm2,%zmm2
 5f2:	vpsrlvd %zmm1,%zmm2,%zmm2
 5f8:	vpmovdb %zmm2,%xmm2
 5fe:	vmovdqu32 %xmm2,(%r8,%rax,1)
 605:	add    $0x10,%rax
 609:	cmp    %r10,%rax
 60c:	jb     5df <k_scale_u8+0x9f>
 60e:	mov    -0x18(%rsp),%rdi
 613:	mov    -0x10(%rsp),%rsi
 618:	mov    %r10,%rax
 61b:	jmp    632 <k_scale_u8+0xf2>
 61d:	movzbl (%rsi,%rax,1),%r8d
 622:	imul   %edx,%r8d
 626:	shr    $0x8,%r8d
 62a:	mov    %r8b,(%rdi,%rax,1)
 62e:	add    $0x1,%rax
 632:	cmp    %rcx,%rax
 635:	jb     61d <k_scale_u8+0xdd>
 637:	ret
 638:	int3
 639:	int3
 63a:	int3
 63b:	int3
 63c:	int3
 63d:	int3
 63e:	int3
 63f:	int3

0000000000000640 <k_blend_u8>:
 640:	mov    %rdi,%r9
 643:	mov    %rsi,%r10
 646:	mov    %rdx,%rax
 649:	mov    %rdx,-0x28(%rsp)
 64e:	mov    $0x100,%edx
 653:	sub    %ecx,%edx
 655:	mov    %rsi,-0x30(%rsp)
 65a:	xor    %esi,%esi
 65c:	test   %r8,%r8
 65f:	cmova  %r8,%rsi
 663:	and    $0xfffffffffffffff0,%rsi
 667:	mov    %rdi,-0x38(%rsp)
 66c:	xor    %edi,%edi
 66e:	test   %rsi,%rsi
 671:	setne  %dil
 675:	mov    %r8,-0x20(%rsp)
 67a:	movabs $0x100000000000000,%r8
 684:	cmp    %r8,%rsi
 687:	mov    $0x0,%r8d
 68d:	setb   %r8b
 691:	test   %edi,%edi
 693:	cmovne %r8d,%edi
 697:	mov    %r9,%r8
 69a:	mov    %r9,-0x18(%rsp)
 69f:	mov    %r8,%r9
 6a2:	mov    %r10,-0x10(%rsp)
 6a7:	mov    %edx,-0x8(%rsp)
 6ab:	mov    %r10,%rdx
 6ae:	sub    %r9,%rdx
 6b1:	sub    %r10,%r9
 6b4:	cmp    %rsi,%rdx
 6b7:	mov    $0x0,%edx
 6bc:	setae  %dl
 6bf:	cmp    %rsi,%r9
 6c2:	mov    $0x0,%r9d
 6c8:	setae  %r9b
 6cc:	test   %edx,%edx
 6ce:	cmovne %r9d,%edx
 6d2:	test   %edi,%edi
 6d4:	cmovne %edx,%edi
 6d7:	mov    %rax,%rdx
 6da:	mov    %rdx,%r9
 6dd:	sub    %r8,%r9
 6e0:	sub    %rdx,%r8
 6e3:	xor    %edx,%edx
 6e5:	cmp    %rsi,%r9
 6e8:	setae  %dl
 6eb:	cmp    %rsi,%r8
 6ee:	mov    $0x0,%r8d
 6f4:	setae  %r8b
 6f8:	test   %edx,%edx
 6fa:	cmovne %r8d,%edx
 6fe:	test   %edi,%edi
 700:	cmovne %edx,%edi
 703:	vpbroadcastd %ecx,%zmm0
 709:	mov    -0x8(%rsp),%edx
 70d:	vpbroadcastd %edx,%zmm1
 713:	mov    $0x8,%r11d
 719:	vpbroadcastd %r11d,%zmm2
 71f:	test   %edi,%edi
 721:	jne    73e <k_blend_u8+0xfe>
 723:	mov    -0x38(%rsp),%rdi
 728:	mov    -0x30(%rsp),%rsi
 72d:	mov    -0x28(%rsp),%rdx
 732:	mov    -0x20(%rsp),%r8
 737:	xor    %eax,%eax
 739:	jmp    7df <k_blend_u8+0x19f>
 73e:	mov    -0x18(%rsp),%r9
 743:	mov    -0x10(%rsp),%r10
 748:	xor    %edx,%edx
 74a:	vmovdqu32 (%r10,%rdx,1),%xmm3
 751:	vpmovzxbd %xmm3,%zmm3
 757:	vpmulld %zmm0,%zmm3,%zmm3
 75d:	vmovdqu32 (%rax,%rdx,1),%xmm4
 764:	vpmovzxbd %xmm4,%zmm4
 76a:	vpmulld %zmm1,%zmm4,%zmm4
 770:	vpaddd %zmm4,%zmm3,%zmm4
 776:	vpsrlvd %zmm2,%zmm4,%zmm4
 77c:	vpmovdb %zmm4,%xmm4
 782:	vmovdqu32 %xmm4,(%r9,%rdx,1)
 789:	add    $0x10,%rdx
 78d:	cmp    %rsi,%rdx
 790:	jb     74a <k_blend_u8+0x10a>
 792:	mov    -0x38(%rsp),%rdi
 797:	mov    -0x28(%rsp),%rdx
 79c:	mov    -0x20(%rsp),%r8
 7a1:	mov    %rsi,%rax
 7a4:	mov    -0x30(%rsp),%rsi
 7a9:	jmp    7df <k_blend_u8+0x19f>
 7ab:	mov    %r8,-0x20(%rsp)
 7b0:	movzbl (%rsi,%rax,1),%r8d
 7b5:	imul   %ecx,%r8d
 7b9:	movzbl (%rdx,%rax,1),%r9d
 7be:	mov    $0x100,%r10d
 7c4:	sub    %ecx,%r10d
 7c7:	imul   %r10d,%r9d
 7cb:	add    %r9d,%r8d
 7ce:	shr    $0x8,%r8d
 7d2:	mov    %r8b,(%rdi,%rax,1)
 7d6:	add    $0x1,%rax
 7da:	mov    -0x20(%rsp),%r8
 7df:	cmp    %r8,%rax
 7e2:	jb     7ab <k_blend_u8+0x16b>
 7e4:	ret
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

00000000000007f0 <k_clamp_i32>:
 7f0:	mov    %rsi,%r9
 7f3:	mov    %rdi,%r10
 7f6:	movslq %r8d,%rax
 7f9:	mov    %rsi,-0x28(%rsp)
 7fe:	xor    %esi,%esi
 800:	test   %r8d,%r8d
 803:	cmovg  %rax,%rsi
 807:	and    $0xfffffffffffffff0,%rsi
 80b:	mov    %esi,%eax
 80d:	mov    %rax,-0x10(%rsp)
 812:	xor    %eax,%eax
 814:	test   %rsi,%rsi
 817:	setne  %al
 81a:	mov    %rdi,-0x30(%rsp)
 81f:	movabs $0x100000000000000,%rdi
 829:	cmp    %rdi,%rsi
 82c:	mov    $0x0,%edi
 831:	setb   %dil
 835:	test   %eax,%eax
 837:	cmovne %edi,%eax
 83a:	mov    %r10,%rdi
 83d:	mov    %r10,-0x18(%rsp)
 842:	mov    %rsi,%r10
 845:	shl    $0x2,%r10
 849:	mov    %r9,-0x20(%rsp)
 84e:	shl    $0x2,%rsi
 852:	mov    %r8d,-0x8(%rsp)
 857:	mov    %r9,%r8
 85a:	sub    %rdi,%r8
 85d:	sub    %r9,%rdi
 860:	cmp    %r10,%r8
 863:	mov    $0x0,%r8d
 869:	setae  %r8b
 86d:	cmp    %rsi,%rdi
 870:	mov    $0x0,%esi
 875:	setae  %sil
 879:	test   %r8d,%r8d
 87c:	cmovne %esi,%r8d
 880:	test   %eax,%eax
 882:	cmovne %r8d,%eax
 886:	vpbroadcastd %edx,%zmm0
 88c:	vpbroadcastd %ecx,%zmm1
 892:	test   %eax,%eax
 894:	jne    8ac <k_clamp_i32+0xbc>
 896:	mov    -0x30(%rsp),%rdi
 89b:	mov    -0x28(%rsp),%rsi
 8a0:	mov    -0x8(%rsp),%r8d
 8a5:	xor    %eax,%eax
 8a7:	jmp    92c <k_clamp_i32+0x13c>
 8ac:	mov    -0x20(%rsp),%r9
 8b1:	mov    -0x18(%rsp),%r10
 8b6:	mov    -0x10(%rsp),%rax
 8bb:	xor    %esi,%esi
 8bd:	mov    %rsi,%rdi
 8c0:	vmovdqu32 (%r9,%rdi,4),%zmm2
 8c7:	vpcmpltd %zmm0,%zmm2,%k1
 8ce:	vpcmpnled %zmm1,%zmm2,%k2
 8d5:	vpblendmd %zmm1,%zmm2,%zmm2{%k2}
 8db:	vpblendmd %zmm0,%zmm2,%zmm2{%k1}
 8e1:	vmovdqu32 %zmm2,(%r10,%rdi,4)
 8e8:	add    $0x10,%esi
 8eb:	movslq %esi,%rsi
 8ee:	cmp    %eax,%esi
 8f0:	jl     8bd <k_clamp_i32+0xcd>
 8f2:	mov    -0x30(%rsp),%rdi
 8f7:	mov    -0x28(%rsp),%rsi
 8fc:	mov    -0x8(%rsp),%r8d
 901:	jmp    92c <k_clamp_i32+0x13c>
 903:	mov    %r8d,-0x8(%rsp)
 908:	movslq %eax,%r8
 90b:	mov    (%rsi,%r8,4),%r9d
 90f:	cmp    %ecx,%r9d
 912:	mov    %r9d,%r10d
 915:	cmovg  %ecx,%r10d
 919:	cmp    %edx,%r9d
 91c:	cmovl  %edx,%r10d
 920:	mov    %r10d,(%rdi,%r8,4)
 924:	add    $0x1,%eax
 927:	mov    -0x8(%rsp),%r8d
 92c:	cmp    %r8d,%eax
 92f:	jl     903 <k_clamp_i32+0x113>
 931:	ret
 932:	int3
 933:	int3
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

0000000000000940 <k_i32_to_f32>:
 940:	xor    %eax,%eax
 942:	jmp    959 <k_i32_to_f32+0x19>
 944:	xorps  %xmm1,%xmm1
 947:	cvtsi2ssl (%rsi,%rax,4),%xmm1
 94c:	mulss  %xmm0,%xmm1
 950:	movss  %xmm1,(%rdi,%rax,4)
 955:	add    $0x1,%rax
 959:	cmp    %rdx,%rax
 95c:	jb     944 <k_i32_to_f32+0x4>
 95e:	ret
 95f:	int3

0000000000000960 <k_fill_u32>:
 960:	xor    %eax,%eax
 962:	xor    %ecx,%ecx
 964:	test   %rdx,%rdx
 967:	cmova  %rdx,%rcx
 96b:	and    $0xfffffffffffffff0,%rcx
 96f:	xor    %r8d,%r8d
 972:	test   %rcx,%rcx
 975:	setne  %r8b
 979:	vpbroadcastd %esi,%zmm0
 97f:	test   %r8d,%r8d
 982:	je     9a0 <k_fill_u32+0x40>
 984:	vmovdqu32 %zmm0,(%rdi,%rax,4)
 98b:	add    $0x10,%rax
 98f:	cmp    %rcx,%rax
 992:	jb     984 <k_fill_u32+0x24>
 994:	mov    %rcx,%rax
 997:	jmp    9a0 <k_fill_u32+0x40>
 999:	mov    %esi,(%rdi,%rax,4)
 99c:	add    $0x1,%rax
 9a0:	cmp    %rdx,%rax
 9a3:	jb     999 <k_fill_u32+0x39>
 9a5:	ret
 9a6:	int3
 9a7:	int3
 9a8:	int3
 9a9:	int3
 9aa:	int3
 9ab:	int3
 9ac:	int3
 9ad:	int3
 9ae:	int3
 9af:	int3

00000000000009b0 <k_copy_u8>:
 9b0:	mov    %rdi,%rcx
 9b3:	mov    %rsi,%r8
 9b6:	xor    %r9d,%r9d
 9b9:	test   %rdx,%rdx
 9bc:	cmova  %rdx,%r9
 9c0:	and    $0xffffffffffffffc0,%r9
 9c4:	xor    %r10d,%r10d
 9c7:	test   %r9,%r9
 9ca:	setne  %r10b
 9ce:	movabs $0x100000000000000,%rax
 9d8:	cmp    %rax,%r9
 9db:	mov    $0x0,%eax
 9e0:	setb   %al
 9e3:	test   %r10d,%r10d
 9e6:	cmovne %eax,%r10d
 9ea:	mov    %rcx,%rax
 9ed:	mov    %rcx,-0x8(%rsp)
 9f2:	mov    %r8,%rcx
 9f5:	mov    %rsi,-0x10(%rsp)
 9fa:	mov    %rcx,%rsi
 9fd:	sub    %rax,%rsi
 a00:	sub    %rcx,%rax
 a03:	xor    %ecx,%ecx
 a05:	cmp    %r9,%rsi
 a08:	setae  %cl
 a0b:	cmp    %r9,%rax
 a0e:	mov    $0x0,%eax
 a13:	setae  %al
 a16:	test   %ecx,%ecx
 a18:	cmovne %eax,%ecx
 a1b:	test   %r10d,%r10d
 a1e:	cmovne %ecx,%r10d
 a22:	test   %r10d,%r10d
 a25:	jne    a30 <k_copy_u8+0x80>
 a27:	mov    -0x10(%rsp),%rsi
 a2c:	xor    %eax,%eax
 a2e:	jmp    a63 <k_copy_u8+0xb3>
 a30:	mov    -0x8(%rsp),%rcx
 a35:	xor    %eax,%eax
 a37:	vmovdqu32 (%r8,%rax,1),%zmm0
 a3e:	vmovdqu32 %zmm0,(%rcx,%rax,1)
 a45:	add    $0x40,%rax
 a49:	cmp    %r9,%rax
 a4c:	jb     a37 <k_copy_u8+0x87>
 a4e:	mov    -0x10(%rsp),%rsi
 a53:	mov    %r9,%rax
 a56:	jmp    a63 <k_copy_u8+0xb3>
 a58:	movzbl (%rsi,%rax,1),%ecx
 a5c:	mov    %cl,(%rdi,%rax,1)
 a5f:	add    $0x1,%rax
 a63:	cmp    %rdx,%rax
 a66:	jb     a58 <k_copy_u8+0xa8>
 a68:	ret
 a69:	int3
 a6a:	int3
 a6b:	int3
 a6c:	int3
 a6d:	int3
 a6e:	int3
 a6f:	int3

0000000000000a70 <k_stencil3_u8>:
 a70:	mov    %rdi,%rcx
 a73:	mov    %rsi,%r8
 a76:	mov    %rsi,%r9
 a79:	mov    %rsi,%r10
 a7c:	mov    %rdx,%rax
 a7f:	sub    $0x2,%rax
 a83:	mov    %rdi,-0x30(%rsp)
 a88:	xor    %edi,%edi
 a8a:	cmp    $0x2,%rdx
 a8e:	cmova  %rax,%rdi
 a92:	and    $0xfffffffffffffff0,%rdi
 a96:	lea    0x1(%rdi),%rax
 a9a:	mov    %rax,-0x8(%rsp)
 a9f:	xor    %eax,%eax
 aa1:	test   %rdi,%rdi
 aa4:	setne  %al
 aa7:	mov    %rdx,-0x20(%rsp)
 aac:	mov    $0x1,%edx
 ab1:	test   %eax,%eax
 ab3:	cmovne %edx,%eax
 ab6:	movabs $0x100000000000000,%rdx
 ac0:	cmp    %rdx,%rdi
 ac3:	mov    $0x0,%edx
 ac8:	setb   %dl
 acb:	test   %eax,%eax
 acd:	cmovne %edx,%eax
 ad0:	lea    0x1(%rcx),%rdx
 ad4:	mov    %rcx,-0x18(%rsp)
 ad9:	mov    %rdx,%rcx
 adc:	mov    %r8,-0x10(%rsp)
 ae1:	mov    %rsi,-0x28(%rsp)
 ae6:	mov    %r8,%rsi
 ae9:	sub    %rcx,%rsi
 aec:	sub    %r8,%rcx
 aef:	cmp    %rdi,%rsi
 af2:	mov    $0x0,%esi
 af7:	setae  %sil
 afb:	cmp    %rdi,%rcx
 afe:	mov    $0x0,%ecx
 b03:	setae  %cl
 b06:	test   %esi,%esi
 b08:	cmovne %ecx,%esi
 b0b:	test   %eax,%eax
 b0d:	cmovne %esi,%eax
 b10:	mov    %rdx,%rcx
 b13:	lea    0x1(%r9),%rsi
 b17:	mov    %rsi,%r8
 b1a:	sub    %rcx,%r8
 b1d:	sub    %rsi,%rcx
 b20:	xor    %esi,%esi
 b22:	cmp    %rdi,%r8
 b25:	setae  %sil
 b29:	cmp    %rdi,%rcx
 b2c:	mov    $0x0,%ecx
 b31:	setae  %cl
 b34:	test   %esi,%esi
 b36:	cmovne %ecx,%esi
 b39:	test   %eax,%eax
 b3b:	cmovne %esi,%eax
 b3e:	lea    0x2(%r10),%rcx
 b42:	mov    %rcx,%rsi
 b45:	sub    %rdx,%rsi
 b48:	sub    %rcx,%rdx
 b4b:	xor    %ecx,%ecx
 b4d:	cmp    %rdi,%rsi
 b50:	setae  %cl
 b53:	cmp    %rdi,%rdx
 b56:	mov    $0x0,%edx
 b5b:	setae  %dl
 b5e:	test   %ecx,%ecx
 b60:	cmovne %edx,%ecx
 b63:	test   %eax,%eax
 b65:	cmovne %ecx,%eax
 b68:	mov    $0x2,%r11d
 b6e:	vpbroadcastd %r11d,%zmm0
 b74:	mov    $0x2,%r11d
 b7a:	vpbroadcastd %r11d,%zmm1
 b80:	mov    $0x2,%r11d
 b86:	vpbroadcastd %r11d,%zmm2
 b8c:	test   %eax,%eax
 b8e:	jne    ba9 <k_stencil3_u8+0x139>
 b90:	mov    -0x30(%rsp),%rdi
 b95:	mov    -0x28(%rsp),%rsi
 b9a:	mov    -0x20(%rsp),%rdx
 b9f:	mov    $0x1,%eax
 ba4:	jmp    c5b <k_stencil3_u8+0x1eb>
 ba9:	mov    -0x18(%rsp),%rcx
 bae:	mov    -0x10(%rsp),%r8
 bb3:	mov    -0x8(%rsp),%rax
 bb8:	mov    $0x1,%edx
 bbd:	vmovdqu32 -0x1(%r8,%rdx,1),%xmm3
 bc8:	vpmovzxbd %xmm3,%zmm3
 bce:	vmovdqu32 (%r9,%rdx,1),%xmm4
 bd5:	vpmovzxbd %xmm4,%zmm4
 bdb:	vpmulld %zmm4,%zmm0,%zmm4
 be1:	vpaddd %zmm4,%zmm3,%zmm4
 be7:	vmovdqu32 0x1(%r10,%rdx,1),%xmm3
 bf2:	vpmovzxbd %xmm3,%zmm3
 bf8:	vpaddd %zmm3,%zmm4,%zmm3
 bfe:	vpaddd %zmm1,%zmm3,%zmm3
 c04:	vpsravd %zmm2,%zmm3,%zmm3
 c0a:	vpmovdb %zmm3,%xmm3
 c10:	vmovdqu32 %xmm3,(%rcx,%rdx,1)
 c17:	add    $0x10,%rdx
 c1b:	cmp    %rax,%rdx
 c1e:	jb     bbd <k_stencil3_u8+0x14d>
 c20:	mov    -0x30(%rsp),%rdi
 c25:	mov    -0x28(%rsp),%rsi
 c2a:	mov    -0x20(%rsp),%rdx
 c2f:	jmp    c5b <k_stencil3_u8+0x1eb>
 c31:	mov    %rdx,-0x20(%rsp)
 c36:	movzbl -0x1(%rsi,%rax,1),%ecx
 c3b:	movzbl (%rsi,%rax,1),%edx
 c3f:	lea    (%rcx,%rdx,2),%ecx
 c42:	movzbl 0x1(%rsi,%rax,1),%edx
 c47:	add    %edx,%ecx
 c49:	add    $0x2,%ecx
 c4c:	sar    $0x2,%ecx
 c4f:	mov    %cl,(%rdi,%rax,1)
 c52:	add    $0x1,%rax
 c56:	mov    -0x20(%rsp),%rdx
 c5b:	lea    0x1(%rax),%rcx
 c5f:	cmp    %rdx,%rcx
 c62:	jb     c31 <k_stencil3_u8+0x1c1>
 c64:	ret
 c65:	int3
 c66:	int3
 c67:	int3
 c68:	int3
 c69:	int3
 c6a:	int3
 c6b:	int3
 c6c:	int3
 c6d:	int3
 c6e:	int3
 c6f:	int3

0000000000000c70 <k_rgb_to_gray>:
 c70:	xor    %eax,%eax
 c72:	jmp    cc3 <k_rgb_to_gray+0x53>
 c74:	mov    %rax,%rcx
 c77:	lea    (%rax,%rax,2),%r8d
 c7b:	movslq %r8d,%r8
 c7e:	movzbl (%rsi,%r8,1),%r8d
 c83:	imul   $0x4d,%r8d,%r8d
 c87:	lea    (%rax,%rax,2),%r9d
 c8b:	add    $0x1,%r9d
 c8f:	movslq %r9d,%r9
 c92:	movzbl (%rsi,%r9,1),%r9d
 c97:	imul   $0x96,%r9d,%r9d
 c9e:	add    %r9d,%r8d
 ca1:	lea    (%rax,%rax,2),%r9d
 ca5:	add    $0x2,%r9d
 ca9:	movslq %r9d,%r9
 cac:	movzbl (%rsi,%r9,1),%r9d
 cb1:	imul   $0x1d,%r9d,%r9d
 cb5:	add    %r9d,%r8d
 cb8:	sar    $0x8,%r8d
 cbc:	mov    %r8b,(%rdi,%rcx,1)
 cc0:	add    $0x1,%eax
 cc3:	cmp    %edx,%eax
 cc5:	jl     c74 <k_rgb_to_gray+0x4>
 cc7:	ret
 cc8:	int3
 cc9:	int3
 cca:	int3
 ccb:	int3
 ccc:	int3
 ccd:	int3
 cce:	int3
 ccf:	int3

0000000000000cd0 <k_matmul_f32>:
 cd0:	xor    %eax,%eax
 cd2:	mov    %rax,%r9
 cd5:	jmp    d30 <k_matmul_f32+0x60>
 cd7:	mov    %r9,%r10
 cda:	imul   %rcx,%r10
 cde:	add    %rax,%r10
 ce1:	movss  (%rdi,%r10,4),%xmm1
 ce7:	mov    %rsi,-0x8(%rsp)
 cec:	mov    %r8,%rsi
 cef:	imul   %rcx,%rsi
 cf3:	add    %rax,%rsi
 cf6:	vfmadd231ss (%rdx,%rsi,4),%xmm0,%xmm1
 cfc:	movss  %xmm1,(%rdi,%r10,4)
 d02:	add    $0x1,%rax
 d06:	mov    -0x8(%rsp),%rsi
 d0b:	cmp    %rcx,%rax
 d0e:	jb     cd7 <k_matmul_f32+0x7>
 d10:	add    $0x1,%r8
 d14:	cmp    %rcx,%r8
 d17:	jae    d2c <k_matmul_f32+0x5c>
 d19:	mov    %r9,%rax
 d1c:	imul   %rcx,%rax
 d20:	add    %r8,%rax
 d23:	movss  (%rsi,%rax,4),%xmm0
 d28:	xor    %eax,%eax
 d2a:	jmp    d0b <k_matmul_f32+0x3b>
 d2c:	add    $0x1,%r9
 d30:	cmp    %rcx,%r9
 d33:	jae    d3a <k_matmul_f32+0x6a>
 d35:	xor    %r8d,%r8d
 d38:	jmp    d14 <k_matmul_f32+0x44>
 d3a:	ret
 d3b:	int3
 d3c:	int3
 d3d:	int3
 d3e:	int3
 d3f:	int3

0000000000000d40 <k_dot_f32>:
 d40:	xorps  %xmm0,%xmm0
 d43:	xor    %eax,%eax
 d45:	jmp    d56 <k_dot_f32+0x16>
 d47:	movss  (%rdi,%rax,4),%xmm1
 d4c:	vfmadd231ss (%rsi,%rax,4),%xmm1,%xmm0
 d52:	add    $0x1,%rax
 d56:	cmp    %rdx,%rax
 d59:	jb     d47 <k_dot_f32+0x7>
 d5b:	ret
 d5c:	int3
 d5d:	int3
 d5e:	int3
 d5f:	int3

0000000000000d60 <k_prefix_sum_i32>:
 d60:	mov    $0x1,%eax
 d65:	jmp    d75 <k_prefix_sum_i32+0x15>
 d67:	mov    (%rdi,%rax,4),%ecx
 d6a:	add    -0x4(%rdi,%rax,4),%ecx
 d6e:	mov    %ecx,(%rdi,%rax,4)
 d71:	add    $0x1,%rax
 d75:	cmp    %rsi,%rax
 d78:	jb     d67 <k_prefix_sum_i32+0x7>
 d7a:	ret
 d7b:	int3
 d7c:	int3
 d7d:	int3
 d7e:	int3
 d7f:	int3

0000000000000d80 <k_histogram_u8>:
 d80:	xor    %eax,%eax
 d82:	jmp    d98 <k_histogram_u8+0x18>
 d84:	movzbl (%rsi,%rax,1),%ecx
 d88:	mov    (%rdi,%rcx,4),%r8d
 d8c:	add    $0x1,%r8d
 d90:	mov    %r8d,(%rdi,%rcx,4)
 d94:	add    $0x1,%rax
 d98:	cmp    %rdx,%rax
 d9b:	jb     d84 <k_histogram_u8+0x4>
 d9d:	ret
 d9e:	int3
 d9f:	int3

0000000000000da0 <k_find_u8>:
 da0:	movzbl %dl,%eax
 da3:	xor    %ecx,%ecx
 da5:	jmp    db7 <k_find_u8+0x17>
 da7:	movzbl (%rdi,%rcx,1),%edx
 dab:	mov    %eax,%r8d
 dae:	cmp    %r8d,%edx
 db1:	je     dbc <k_find_u8+0x1c>
 db3:	add    $0x1,%rcx
 db7:	cmp    %rsi,%rcx
 dba:	jb     da7 <k_find_u8+0x7>
 dbc:	mov    %rcx,%rax
 dbf:	ret

0000000000000dc0 <k_crc32_table>:
 dc0:	mov    $0xffffffff,%eax
 dc5:	xor    %ecx,%ecx
 dc7:	jmp    de3 <k_crc32_table+0x23>
 dc9:	movzbl (%rdi,%rcx,1),%r8d
 dce:	xor    %eax,%r8d
 dd1:	and    $0xff,%r8d
 dd8:	shr    $0x8,%eax
 ddb:	xor    (%rdx,%r8,4),%eax
 ddf:	add    $0x1,%rcx
 de3:	cmp    %rsi,%rcx
 de6:	jb     dc9 <k_crc32_table+0x9>
 de8:	not    %eax
 dea:	ret
 deb:	int3
 dec:	int3
 ded:	int3
 dee:	int3
 def:	int3

0000000000000df0 <k_fnv1a>:
 df0:	mov    $0x811c9dc5,%eax
 df5:	xor    %ecx,%ecx
 df7:	jmp    e09 <k_fnv1a+0x19>
 df9:	movzbl (%rdi,%rcx,1),%edx
 dfd:	xor    %edx,%eax
 dff:	imul   $0x1000193,%eax,%eax
 e05:	add    $0x1,%rcx
 e09:	cmp    %rsi,%rcx
 e0c:	jb     df9 <k_fnv1a+0x9>
 e0e:	ret
