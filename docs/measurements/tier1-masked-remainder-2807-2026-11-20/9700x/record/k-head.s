
bin/k-head.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_sum_i32>:
       0:	xor    %eax,%eax
       2:	xor    %edx,%edx
       4:	mov    %rdi,%r8
       7:	xor    %ecx,%ecx
       9:	test   %rsi,%rsi
       c:	mov    %rcx,%r9
       f:	cmova  %rsi,%r9
      13:	mov    %r9,%r10
      16:	and    $0xfffffffffffffff8,%r10
      1a:	xor    %ecx,%ecx
      1c:	test   %r9,%r9
      1f:	setne  %cl
      22:	vpxord %zmm0,%zmm0,%zmm0
      28:	test   %ecx,%ecx
      2a:	je     e0 <k_sum_i32+0xe0>
      30:	test   %r10,%r10
      33:	je     51 <k_sum_i32+0x51>
      35:	vmovdqu32 (%r8,%rdx,4),%ymm1
      3c:	vpmovsxdq %ymm1,%zmm1
      42:	vpaddq %zmm1,%zmm0,%zmm0
      48:	add    $0x8,%rdx
      4c:	cmp    %r10,%rdx
      4f:	jb     35 <k_sum_i32+0x35>
      51:	mov    %r9,%rax
      54:	and    $0x7,%rax
      58:	test   %rax,%rax
      5b:	je     a3 <k_sum_i32+0xa3>
      5d:	mov    $0x1,%edx
      62:	mov    %eax,%ecx
      64:	mov    %rdx,%rax
      67:	shl    %cl,%rax
      6a:	sub    $0x1,%rax
      6e:	movzbl %al,%eax
      71:	kmovb  %eax,%k1
      75:	lea    (%r8,%r10,4),%r8
      79:	vpxord %ymm1,%ymm1,%ymm1
      7f:	vmovdqu32 (%r8),%ymm1{%k1}
      85:	vpmovsxdq %ymm1,%zmm1
      8b:	vmovdqa64 %zmm1,%zmm15
      91:	vmovdqa64 %zmm0,%zmm1
      97:	vpaddq %zmm15,%zmm0,%zmm1{%k1}
      9d:	vmovdqa64 %zmm1,%zmm0
      a3:	vextracti64x4 $0x1,%zmm0,%ymm15
      aa:	{evex} vpaddq %ymm15,%ymm0,%ymm0
      b0:	vextracti32x4 $0x1,%ymm0,%xmm15
      b7:	{evex} vpaddq %xmm15,%xmm0,%xmm0
      bd:	{evex} vpshufd $0x4e,%xmm0,%xmm15
      c4:	{evex} vpaddq %xmm15,%xmm0,%xmm0
      ca:	{evex} vmovq %xmm0,%rax
      d0:	mov    %r9,%rdx
      d3:	jmp    e0 <k_sum_i32+0xe0>
      d5:	movslq (%rdi,%rdx,4),%rcx
      d9:	add    %rcx,%rax
      dc:	add    $0x1,%rdx
      e0:	cmp    %rsi,%rdx
      e3:	jb     d5 <k_sum_i32+0xd5>
      e5:	ret
      e6:	int3
      e7:	int3
      e8:	int3
      e9:	int3
      ea:	int3
      eb:	int3
      ec:	int3
      ed:	int3
      ee:	int3
      ef:	int3

00000000000000f0 <k_sum_u8>:
      f0:	xor    %eax,%eax
      f2:	xor    %edx,%edx
      f4:	mov    %rdi,%r8
      f7:	xor    %ecx,%ecx
      f9:	test   %rsi,%rsi
      fc:	mov    %rcx,%r9
      ff:	cmova  %rsi,%r9
     103:	mov    %r9,%r10
     106:	and    $0xfffffffffffffff0,%r10
     10a:	xor    %ecx,%ecx
     10c:	test   %r9,%r9
     10f:	setne  %cl
     112:	vpxord %zmm0,%zmm0,%zmm0
     118:	test   %ecx,%ecx
     11a:	je     1db <k_sum_u8+0xeb>
     120:	test   %r10,%r10
     123:	je     141 <k_sum_u8+0x51>
     125:	vmovdqu32 (%r8,%rdx,1),%xmm1
     12c:	vpmovzxbd %xmm1,%zmm1
     132:	vpaddd %zmm1,%zmm0,%zmm0
     138:	add    $0x10,%rdx
     13c:	cmp    %r10,%rdx
     13f:	jb     125 <k_sum_u8+0x35>
     141:	mov    %r9,%rax
     144:	and    $0xf,%rax
     148:	test   %rax,%rax
     14b:	je     192 <k_sum_u8+0xa2>
     14d:	mov    $0x1,%edx
     152:	mov    %eax,%ecx
     154:	mov    %rdx,%rax
     157:	shl    %cl,%rax
     15a:	sub    $0x1,%rax
     15e:	movzwl %ax,%eax
     161:	kmovw  %eax,%k1
     165:	add    %r10,%r8
     168:	vpxord %xmm1,%xmm1,%xmm1
     16e:	vmovdqu8 (%r8),%xmm1{%k1}
     174:	vpmovzxbd %xmm1,%zmm1
     17a:	vmovdqa64 %zmm1,%zmm15
     180:	vmovdqa64 %zmm0,%zmm1
     186:	vpaddd %zmm15,%zmm0,%zmm1{%k1}
     18c:	vmovdqa64 %zmm1,%zmm0
     192:	vextracti64x4 $0x1,%zmm0,%ymm15
     199:	{evex} vpaddd %ymm15,%ymm0,%ymm0
     19f:	vextracti32x4 $0x1,%ymm0,%xmm15
     1a6:	{evex} vpaddd %xmm15,%xmm0,%xmm0
     1ac:	{evex} vpshufd $0x4e,%xmm0,%xmm15
     1b3:	{evex} vpaddd %xmm15,%xmm0,%xmm0
     1b9:	{evex} vpshufd $0xb1,%xmm0,%xmm15
     1c0:	{evex} vpaddd %xmm15,%xmm0,%xmm0
     1c6:	{evex} vmovd %xmm0,%eax
     1cc:	mov    %r9,%rdx
     1cf:	jmp    1db <k_sum_u8+0xeb>
     1d1:	movzbl (%rdi,%rdx,1),%ecx
     1d5:	add    %ecx,%eax
     1d7:	add    $0x1,%rdx
     1db:	cmp    %rsi,%rdx
     1de:	jb     1d1 <k_sum_u8+0xe1>
     1e0:	ret
     1e1:	int3
     1e2:	int3
     1e3:	int3
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

00000000000001f0 <k_dot_i16>:
     1f0:	mov    %rdi,%r9
     1f3:	mov    %rsi,%r10
     1f6:	xor    %ecx,%ecx
     1f8:	test   %rdx,%rdx
     1fb:	cmova  %rdx,%rcx
     1ff:	mov    %rcx,%r8
     202:	and    $0xfffffffffffffff0,%r8
     206:	xor    %eax,%eax
     208:	test   %rcx,%rcx
     20b:	setne  %al
     20e:	vpxord %zmm0,%zmm0,%zmm0
     214:	test   %eax,%eax
     216:	jne    222 <k_dot_i16+0x32>
     218:	xor    %eax,%eax
     21a:	xor    %r8d,%r8d
     21d:	jmp    330 <k_dot_i16+0x140>
     222:	test   %r8,%r8
     225:	jne    22c <k_dot_i16+0x3c>
     227:	mov    %rcx,%rax
     22a:	jmp    260 <k_dot_i16+0x70>
     22c:	mov    %rcx,%rax
     22f:	xor    %ecx,%ecx
     231:	vmovdqu32 (%r9,%rcx,2),%ymm1
     238:	vpmovsxwd %ymm1,%zmm1
     23e:	vmovdqu32 (%r10,%rcx,2),%ymm2
     245:	vpmovsxwd %ymm2,%zmm2
     24b:	vpmulld %zmm2,%zmm1,%zmm2
     251:	vpaddd %zmm2,%zmm0,%zmm0
     257:	add    $0x10,%rcx
     25b:	cmp    %r8,%rcx
     25e:	jb     231 <k_dot_i16+0x41>
     260:	mov    %rax,%rcx
     263:	and    $0xf,%rcx
     267:	test   %rcx,%rcx
     26a:	jne    273 <k_dot_i16+0x83>
     26c:	mov    %rsi,-0x8(%rsp)
     271:	jmp    2d5 <k_dot_i16+0xe5>
     273:	mov    %rsi,-0x8(%rsp)
     278:	mov    $0x1,%esi
     27d:	shl    %cl,%rsi
     280:	sub    $0x1,%rsi
     284:	movzwl %si,%ecx
     287:	kmovw  %ecx,%k1
     28b:	lea    (%r9,%r8,2),%r9
     28f:	vpxord %ymm2,%ymm2,%ymm2
     295:	vmovdqa64 %ymm2,%ymm1
     29b:	vmovdqu16 (%r9),%ymm1{%k1}
     2a1:	vpmovsxwd %ymm1,%zmm1
     2a7:	lea    (%r10,%r8,2),%r10
     2ab:	vmovdqu16 (%r10),%ymm2{%k1}
     2b1:	vpmovsxwd %ymm2,%zmm2
     2b7:	vpmulld %zmm2,%zmm1,%zmm2
     2bd:	vmovdqa64 %zmm2,%zmm15
     2c3:	vmovdqa64 %zmm0,%zmm2
     2c9:	vpaddd %zmm15,%zmm0,%zmm2{%k1}
     2cf:	vmovdqa64 %zmm2,%zmm0
     2d5:	vextracti64x4 $0x1,%zmm0,%ymm15
     2dc:	{evex} vpaddd %ymm15,%ymm0,%ymm0
     2e2:	vextracti32x4 $0x1,%ymm0,%xmm15
     2e9:	{evex} vpaddd %xmm15,%xmm0,%xmm0
     2ef:	{evex} vpshufd $0x4e,%xmm0,%xmm15
     2f6:	{evex} vpaddd %xmm15,%xmm0,%xmm0
     2fc:	{evex} vpshufd $0xb1,%xmm0,%xmm15
     303:	{evex} vpaddd %xmm15,%xmm0,%xmm0
     309:	{evex} vmovd %xmm0,%ecx
     30f:	mov    -0x8(%rsp),%rsi
     314:	mov    %rax,%r8
     317:	mov    %rcx,%rax
     31a:	jmp    330 <k_dot_i16+0x140>
     31c:	movswl (%rdi,%r8,2),%ecx
     321:	movswl (%rsi,%r8,2),%r9d
     326:	imul   %r9d,%ecx
     32a:	add    %ecx,%eax
     32c:	add    $0x1,%r8
     330:	cmp    %rdx,%r8
     333:	jb     31c <k_dot_i16+0x12c>
     335:	ret
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

0000000000000340 <k_max_i32>:
     340:	mov    $0x80000000,%eax
     345:	xor    %ecx,%ecx
     347:	jmp    355 <k_max_i32+0x15>
     349:	cmp    (%rdi,%rcx,4),%eax
     34c:	jge    351 <k_max_i32+0x11>
     34e:	mov    (%rdi,%rcx,4),%eax
     351:	add    $0x1,%rcx
     355:	cmp    %rsi,%rcx
     358:	jb     349 <k_max_i32+0x9>
     35a:	ret
     35b:	int3
     35c:	int3
     35d:	int3
     35e:	int3
     35f:	int3

0000000000000360 <k_count_eq_u8>:
     360:	movzbl %dl,%eax
     363:	xor    %ecx,%ecx
     365:	xor    %edx,%edx
     367:	jmp    385 <k_count_eq_u8+0x25>
     369:	movzbl (%rdi,%rdx,1),%r8d
     36e:	mov    %eax,%r9d
     371:	cmp    %r9d,%r8d
     374:	mov    $0x0,%r8d
     37a:	sete   %r8b
     37e:	add    %r8,%rcx
     381:	add    $0x1,%rdx
     385:	cmp    %rsi,%rdx
     388:	jb     369 <k_count_eq_u8+0x9>
     38a:	mov    %rcx,%rax
     38d:	ret
     38e:	int3
     38f:	int3

0000000000000390 <k_cond_sum_i32>:
     390:	xor    %eax,%eax
     392:	mov    %rdi,%r9
     395:	xor    %ecx,%ecx
     397:	test   %rsi,%rsi
     39a:	mov    %rcx,%r10
     39d:	cmova  %rsi,%r10
     3a1:	mov    %r10,%rcx
     3a4:	and    $0xfffffffffffffff8,%rcx
     3a8:	xor    %r8d,%r8d
     3ab:	test   %r10,%r10
     3ae:	setne  %r8b
     3b2:	vpbroadcastd %edx,%ymm0
     3b8:	vpxord %zmm1,%zmm1,%zmm1
     3be:	vpxord %zmm2,%zmm2,%zmm2
     3c4:	test   %r8d,%r8d
     3c7:	jne    3d1 <k_cond_sum_i32+0x41>
     3c9:	xor    %r8d,%r8d
     3cc:	jmp    4af <k_cond_sum_i32+0x11f>
     3d1:	test   %rcx,%rcx
     3d4:	jne    3db <k_cond_sum_i32+0x4b>
     3d6:	mov    %rcx,%rax
     3d9:	jmp    40a <k_cond_sum_i32+0x7a>
     3db:	mov    %rcx,%rax
     3de:	xor    %r8d,%r8d
     3e1:	vmovdqu32 (%r9,%r8,4),%ymm3
     3e8:	vpcmpnled %ymm0,%ymm3,%k1
     3ef:	vpmovsxdq %ymm3,%zmm3
     3f5:	vpblendmq %zmm3,%zmm1,%zmm3{%k1}
     3fb:	vpaddq %zmm3,%zmm2,%zmm2
     401:	add    $0x8,%r8
     405:	cmp    %rax,%r8
     408:	jb     3e1 <k_cond_sum_i32+0x51>
     40a:	mov    %r10,%rcx
     40d:	and    $0x7,%rcx
     411:	test   %rcx,%rcx
     414:	je     466 <k_cond_sum_i32+0xd6>
     416:	mov    $0x1,%r8d
     41c:	shl    %cl,%r8
     41f:	sub    $0x1,%r8
     423:	movzbl %r8b,%ecx
     427:	kmovb  %ecx,%k1
     42b:	lea    (%r9,%rax,4),%r9
     42f:	vpxord %ymm3,%ymm3,%ymm3
     435:	vmovdqu32 (%r9),%ymm3{%k1}
     43b:	vpcmpnled %ymm0,%ymm3,%k2
     442:	vpmovsxdq %ymm3,%zmm3
     448:	vpblendmq %zmm3,%zmm1,%zmm3{%k2}
     44e:	vmovdqa64 %zmm3,%zmm15
     454:	vmovdqa64 %zmm2,%zmm3
     45a:	vpaddq %zmm15,%zmm2,%zmm3{%k1}
     460:	vmovdqa64 %zmm3,%zmm2
     466:	vextracti64x4 $0x1,%zmm2,%ymm15
     46d:	{evex} vpaddq %ymm15,%ymm2,%ymm2
     473:	vextracti32x4 $0x1,%ymm2,%xmm15
     47a:	{evex} vpaddq %xmm15,%xmm2,%xmm2
     480:	{evex} vpshufd $0x4e,%xmm2,%xmm15
     487:	{evex} vpaddq %xmm15,%xmm2,%xmm2
     48d:	{evex} vmovq %xmm2,%rax
     493:	mov    %r10,%r8
     496:	jmp    4af <k_cond_sum_i32+0x11f>
     498:	movslq (%rdi,%r8,4),%rcx
     49c:	xor    %r9d,%r9d
     49f:	mov    %rcx,%r10
     4a2:	cmp    %edx,%ecx
     4a4:	cmovg  %r10,%r9
     4a8:	add    %r9,%rax
     4ab:	add    $0x1,%r8
     4af:	cmp    %rsi,%r8
     4b2:	jb     498 <k_cond_sum_i32+0x108>
     4b4:	ret
     4b5:	int3
     4b6:	int3
     4b7:	int3
     4b8:	int3
     4b9:	int3
     4ba:	int3
     4bb:	int3
     4bc:	int3
     4bd:	int3
     4be:	int3
     4bf:	int3

00000000000004c0 <k_popcount_u64>:
     4c0:	xor    %eax,%eax
     4c2:	xor    %edx,%edx
     4c4:	mov    %rdi,%r8
     4c7:	xor    %ecx,%ecx
     4c9:	test   %rsi,%rsi
     4cc:	mov    %rcx,%r9
     4cf:	cmova  %rsi,%r9
     4d3:	mov    %r9,%r10
     4d6:	and    $0xfffffffffffffff8,%r10
     4da:	xor    %ecx,%ecx
     4dc:	test   %r9,%r9
     4df:	setne  %cl
     4e2:	vpxord %zmm0,%zmm0,%zmm0
     4e8:	test   %ecx,%ecx
     4ea:	je     5c0 <k_popcount_u64+0x100>
     4f0:	test   %r10,%r10
     4f3:	je     51d <k_popcount_u64+0x5d>
     4f5:	vmovdqu32 (%r8,%rdx,8),%zmm1
     4fc:	vpopcntq %zmm1,%zmm1
     502:	vpmovqd %zmm1,%ymm1
     508:	vpmovsxdq %ymm1,%zmm1
     50e:	vpaddq %zmm1,%zmm0,%zmm0
     514:	add    $0x8,%rdx
     518:	cmp    %r10,%rdx
     51b:	jb     4f5 <k_popcount_u64+0x35>
     51d:	mov    %r9,%rax
     520:	and    $0x7,%rax
     524:	test   %rax,%rax
     527:	je     57b <k_popcount_u64+0xbb>
     529:	mov    $0x1,%edx
     52e:	mov    %eax,%ecx
     530:	mov    %rdx,%rax
     533:	shl    %cl,%rax
     536:	sub    $0x1,%rax
     53a:	movzbl %al,%eax
     53d:	kmovb  %eax,%k1
     541:	lea    (%r8,%r10,8),%r8
     545:	vpxord %zmm1,%zmm1,%zmm1
     54b:	vmovdqu64 (%r8),%zmm1{%k1}
     551:	vpopcntq %zmm1,%zmm1
     557:	vpmovqd %zmm1,%ymm1
     55d:	vpmovsxdq %ymm1,%zmm1
     563:	vmovdqa64 %zmm1,%zmm15
     569:	vmovdqa64 %zmm0,%zmm1
     56f:	vpaddq %zmm15,%zmm0,%zmm1{%k1}
     575:	vmovdqa64 %zmm1,%zmm0
     57b:	vextracti64x4 $0x1,%zmm0,%ymm15
     582:	{evex} vpaddq %ymm15,%ymm0,%ymm0
     588:	vextracti32x4 $0x1,%ymm0,%xmm15
     58f:	{evex} vpaddq %xmm15,%xmm0,%xmm0
     595:	{evex} vpshufd $0x4e,%xmm0,%xmm15
     59c:	{evex} vpaddq %xmm15,%xmm0,%xmm0
     5a2:	{evex} vmovq %xmm0,%rax
     5a8:	mov    %r9,%rdx
     5ab:	jmp    5c0 <k_popcount_u64+0x100>
     5ad:	mov    (%rdi,%rdx,8),%rcx
     5b1:	popcnt %rcx,%rcx
     5b6:	movslq %ecx,%rcx
     5b9:	add    %rcx,%rax
     5bc:	add    $0x1,%rdx
     5c0:	cmp    %rsi,%rdx
     5c3:	jb     5ad <k_popcount_u64+0xed>
     5c5:	ret
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

00000000000005d0 <k_aos_sum>:
     5d0:	xor    %eax,%eax
     5d2:	xor    %ecx,%ecx
     5d4:	jmp    5f8 <k_aos_sum+0x28>
     5d6:	mov    %rcx,%rdx
     5d9:	shl    $0x4,%rdx
     5dd:	movslq (%rdi,%rdx,1),%rdx
     5e1:	mov    %rcx,%r8
     5e4:	shl    $0x4,%r8
     5e8:	movslq 0x8(%rdi,%r8,1),%r8
     5ed:	imul   %r8,%rdx
     5f1:	add    %rdx,%rax
     5f4:	add    $0x1,%rcx
     5f8:	cmp    %rsi,%rcx
     5fb:	jb     5d6 <k_aos_sum+0x6>
     5fd:	ret
     5fe:	int3
     5ff:	int3

0000000000000600 <k_add_i32>:
     600:	mov    %rdi,%r8
     603:	mov    %rsi,%r9
     606:	mov    %rdx,%r10
     609:	xor    %eax,%eax
     60b:	test   %rcx,%rcx
     60e:	cmova  %rcx,%rax
     612:	mov    %rdx,-0x30(%rsp)
     617:	mov    %rax,%rdx
     61a:	and    $0xfffffffffffffff0,%rdx
     61e:	mov    %rsi,-0x38(%rsp)
     623:	xor    %esi,%esi
     625:	test   %rax,%rax
     628:	setne  %sil
     62c:	mov    %rdi,-0x40(%rsp)
     631:	movabs $0x100000000000000,%rdi
     63b:	cmp    %rdi,%rax
     63e:	mov    $0x0,%edi
     643:	setb   %dil
     647:	test   %esi,%esi
     649:	cmovne %edi,%esi
     64c:	mov    %r8,%rdi
     64f:	mov    %rcx,-0x28(%rsp)
     654:	mov    %rdi,%rcx
     657:	mov    %r8,-0x20(%rsp)
     65c:	mov    %rax,%r8
     65f:	shl    $0x2,%r8
     663:	mov    %r9,-0x18(%rsp)
     668:	mov    %rdx,-0x8(%rsp)
     66d:	mov    %rax,%rdx
     670:	shl    $0x2,%rdx
     674:	mov    %r10,-0x10(%rsp)
     679:	mov    %r9,%r10
     67c:	sub    %rcx,%r10
     67f:	sub    %r9,%rcx
     682:	cmp    %r8,%r10
     685:	mov    $0x0,%r8d
     68b:	setae  %r8b
     68f:	cmp    %rdx,%rcx
     692:	mov    $0x0,%ecx
     697:	setae  %cl
     69a:	test   %r8d,%r8d
     69d:	cmovne %ecx,%r8d
     6a1:	test   %esi,%esi
     6a3:	cmovne %r8d,%esi
     6a7:	mov    %rax,%rcx
     6aa:	shl    $0x2,%rcx
     6ae:	mov    -0x10(%rsp),%rdx
     6b3:	mov    %rdx,%r8
     6b6:	mov    %rax,%r9
     6b9:	shl    $0x2,%r9
     6bd:	mov    %r8,%r10
     6c0:	sub    %rdi,%r10
     6c3:	sub    %r8,%rdi
     6c6:	cmp    %rcx,%r10
     6c9:	mov    $0x0,%ecx
     6ce:	setae  %cl
     6d1:	cmp    %r9,%rdi
     6d4:	mov    $0x0,%edi
     6d9:	setae  %dil
     6dd:	test   %ecx,%ecx
     6df:	cmovne %edi,%ecx
     6e2:	test   %esi,%esi
     6e4:	cmovne %ecx,%esi
     6e7:	test   %esi,%esi
     6e9:	jne    701 <k_add_i32+0x101>
     6eb:	mov    -0x40(%rsp),%rdi
     6f0:	mov    -0x38(%rsp),%rsi
     6f5:	mov    -0x30(%rsp),%rdx
     6fa:	xor    %eax,%eax
     6fc:	jmp    7b4 <k_add_i32+0x1b4>
     701:	mov    -0x8(%rsp),%rsi
     706:	test   %rsi,%rsi
     709:	jne    717 <k_add_i32+0x117>
     70b:	mov    -0x20(%rsp),%r8
     710:	mov    -0x18(%rsp),%r9
     715:	jmp    747 <k_add_i32+0x147>
     717:	mov    -0x20(%rsp),%r8
     71c:	mov    -0x18(%rsp),%r9
     721:	xor    %edi,%edi
     723:	vmovdqu32 (%r9,%rdi,4),%zmm0
     72a:	vmovdqu32 (%rdx,%rdi,4),%zmm1
     731:	vpaddd %zmm1,%zmm0,%zmm1
     737:	vmovdqu32 %zmm1,(%r8,%rdi,4)
     73e:	add    $0x10,%rdi
     742:	cmp    %rsi,%rdi
     745:	jb     723 <k_add_i32+0x123>
     747:	mov    %rax,%rcx
     74a:	and    $0xf,%rcx
     74e:	test   %rcx,%rcx
     751:	je     796 <k_add_i32+0x196>
     753:	mov    $0x1,%edi
     758:	shl    %cl,%rdi
     75b:	sub    $0x1,%rdi
     75f:	movzwl %di,%ecx
     762:	kmovw  %ecx,%k1
     766:	lea    (%r9,%rsi,4),%r9
     76a:	vpxord %zmm1,%zmm1,%zmm1
     770:	vmovdqa64 %zmm1,%zmm0
     776:	vmovdqu32 (%r9),%zmm0{%k1}
     77c:	lea    (%rdx,%rsi,4),%rdx
     780:	vmovdqu32 (%rdx),%zmm1{%k1}
     786:	vpaddd %zmm1,%zmm0,%zmm1
     78c:	lea    (%r8,%rsi,4),%r8
     790:	vmovdqu32 %zmm1,(%r8){%k1}
     796:	mov    -0x40(%rsp),%rdi
     79b:	mov    -0x38(%rsp),%rsi
     7a0:	mov    -0x30(%rsp),%rdx
     7a5:	jmp    7b4 <k_add_i32+0x1b4>
     7a7:	mov    (%rsi,%rax,4),%ecx
     7aa:	add    (%rdx,%rax,4),%ecx
     7ad:	mov    %ecx,(%rdi,%rax,4)
     7b0:	add    $0x1,%rax
     7b4:	mov    -0x28(%rsp),%r8
     7b9:	cmp    %r8,%rax
     7bc:	jb     7a7 <k_add_i32+0x1a7>
     7be:	ret
     7bf:	int3

00000000000007c0 <k_saxpy_f32>:
     7c0:	xor    %eax,%eax
     7c2:	jmp    7d8 <k_saxpy_f32+0x18>
     7c4:	movss  (%rdi,%rax,4),%xmm1
     7c9:	vfmadd231ss (%rsi,%rax,4),%xmm0,%xmm1
     7cf:	movss  %xmm1,(%rdi,%rax,4)
     7d4:	add    $0x1,%rax
     7d8:	cmp    %rdx,%rax
     7db:	jb     7c4 <k_saxpy_f32+0x4>
     7dd:	ret
     7de:	int3
     7df:	int3

00000000000007e0 <k_scale_u8>:
     7e0:	mov    %rdi,%r8
     7e3:	mov    %rsi,%r9
     7e6:	xor    %r10d,%r10d
     7e9:	test   %rcx,%rcx
     7ec:	cmova  %rcx,%r10
     7f0:	mov    %r10,%rax
     7f3:	and    $0xfffffffffffffff0,%rax
     7f7:	mov    %rsi,-0x18(%rsp)
     7fc:	xor    %esi,%esi
     7fe:	test   %r10,%r10
     801:	setne  %sil
     805:	mov    %rdi,-0x20(%rsp)
     80a:	movabs $0x100000000000000,%rdi
     814:	cmp    %rdi,%r10
     817:	mov    $0x0,%edi
     81c:	setb   %dil
     820:	test   %esi,%esi
     822:	cmovne %edi,%esi
     825:	mov    %r8,%rdi
     828:	mov    %rcx,-0x10(%rsp)
     82d:	mov    %r9,%rcx
     830:	mov    %r8,-0x8(%rsp)
     835:	mov    %rcx,%r8
     838:	sub    %rdi,%r8
     83b:	sub    %rcx,%rdi
     83e:	xor    %ecx,%ecx
     840:	cmp    %r10,%r8
     843:	setae  %cl
     846:	cmp    %r10,%rdi
     849:	mov    $0x0,%edi
     84e:	setae  %dil
     852:	test   %ecx,%ecx
     854:	cmovne %edi,%ecx
     857:	test   %esi,%esi
     859:	cmovne %ecx,%esi
     85c:	vpbroadcastd %edx,%zmm0
     862:	mov    $0x8,%r11d
     868:	vpbroadcastd %r11d,%zmm1
     86e:	test   %esi,%esi
     870:	jne    883 <k_scale_u8+0xa3>
     872:	mov    -0x20(%rsp),%rdi
     877:	mov    -0x18(%rsp),%rsi
     87c:	xor    %eax,%eax
     87e:	jmp    92e <k_scale_u8+0x14e>
     883:	test   %rax,%rax
     886:	jne    88f <k_scale_u8+0xaf>
     888:	mov    -0x8(%rsp),%r8
     88d:	jmp    8c5 <k_scale_u8+0xe5>
     88f:	mov    -0x8(%rsp),%r8
     894:	xor    %esi,%esi
     896:	vmovdqu32 (%r9,%rsi,1),%xmm2
     89d:	vpmovzxbd %xmm2,%zmm2
     8a3:	vpmulld %zmm0,%zmm2,%zmm2
     8a9:	vpsrlvd %zmm1,%zmm2,%zmm2
     8af:	vpmovdb %zmm2,%xmm2
     8b5:	vmovdqu32 %xmm2,(%r8,%rsi,1)
     8bc:	add    $0x10,%rsi
     8c0:	cmp    %rax,%rsi
     8c3:	jb     896 <k_scale_u8+0xb6>
     8c5:	mov    %r10,%rcx
     8c8:	and    $0xf,%rcx
     8cc:	test   %rcx,%rcx
     8cf:	je     90e <k_scale_u8+0x12e>
     8d1:	mov    $0x1,%esi
     8d6:	shl    %cl,%rsi
     8d9:	sub    $0x1,%rsi
     8dd:	movzwl %si,%ecx
     8e0:	kmovw  %ecx,%k1
     8e4:	add    %rax,%r9
     8e7:	vpxord %xmm2,%xmm2,%xmm2
     8ed:	vmovdqu8 (%r9),%xmm2{%k1}
     8f3:	vpmovzxbd %xmm2,%zmm2
     8f9:	vpmulld %zmm0,%zmm2,%zmm2
     8ff:	vpsrlvd %zmm1,%zmm2,%zmm2
     905:	add    %rax,%r8
     908:	vpmovdb %zmm2,(%r8){%k1}
     90e:	mov    -0x20(%rsp),%rdi
     913:	mov    -0x18(%rsp),%rsi
     918:	mov    %r10,%rax
     91b:	jmp    92e <k_scale_u8+0x14e>
     91d:	movzbl (%rsi,%rax,1),%ecx
     921:	imul   %edx,%ecx
     924:	shr    $0x8,%ecx
     927:	mov    %cl,(%rdi,%rax,1)
     92a:	add    $0x1,%rax
     92e:	mov    -0x10(%rsp),%r8
     933:	cmp    %r8,%rax
     936:	jb     91d <k_scale_u8+0x13d>
     938:	ret
     939:	int3
     93a:	int3
     93b:	int3
     93c:	int3
     93d:	int3
     93e:	int3
     93f:	int3

0000000000000940 <k_blend_u8>:
     940:	mov    %rdi,%r9
     943:	mov    %rsi,%r10
     946:	mov    %rdx,%rax
     949:	mov    %rdx,-0x30(%rsp)
     94e:	mov    $0x100,%edx
     953:	sub    %ecx,%edx
     955:	mov    %rsi,-0x38(%rsp)
     95a:	xor    %esi,%esi
     95c:	test   %r8,%r8
     95f:	cmova  %r8,%rsi
     963:	mov    %rdi,-0x40(%rsp)
     968:	mov    %rsi,%rdi
     96b:	and    $0xfffffffffffffff0,%rdi
     96f:	mov    %r8,-0x28(%rsp)
     974:	xor    %r8d,%r8d
     977:	test   %rsi,%rsi
     97a:	setne  %r8b
     97e:	mov    %rdi,-0x10(%rsp)
     983:	movabs $0x100000000000000,%rdi
     98d:	cmp    %rdi,%rsi
     990:	mov    $0x0,%edi
     995:	setb   %dil
     999:	test   %r8d,%r8d
     99c:	cmovne %edi,%r8d
     9a0:	mov    %r9,%rdi
     9a3:	mov    %r9,-0x20(%rsp)
     9a8:	mov    %rdi,%r9
     9ab:	mov    %r10,-0x18(%rsp)
     9b0:	mov    %edx,-0x8(%rsp)
     9b4:	mov    %r10,%rdx
     9b7:	sub    %r9,%rdx
     9ba:	sub    %r10,%r9
     9bd:	cmp    %rsi,%rdx
     9c0:	mov    $0x0,%edx
     9c5:	setae  %dl
     9c8:	cmp    %rsi,%r9
     9cb:	mov    $0x0,%r9d
     9d1:	setae  %r9b
     9d5:	test   %edx,%edx
     9d7:	cmovne %r9d,%edx
     9db:	test   %r8d,%r8d
     9de:	cmovne %edx,%r8d
     9e2:	mov    %rax,%rdx
     9e5:	mov    %rdx,%r9
     9e8:	sub    %rdi,%r9
     9eb:	sub    %rdx,%rdi
     9ee:	xor    %edx,%edx
     9f0:	cmp    %rsi,%r9
     9f3:	setae  %dl
     9f6:	cmp    %rsi,%rdi
     9f9:	mov    $0x0,%edi
     9fe:	setae  %dil
     a02:	test   %edx,%edx
     a04:	cmovne %edi,%edx
     a07:	test   %r8d,%r8d
     a0a:	cmovne %edx,%r8d
     a0e:	vpbroadcastd %ecx,%zmm0
     a14:	mov    -0x8(%rsp),%edx
     a18:	vpbroadcastd %edx,%zmm1
     a1e:	mov    $0x8,%r11d
     a24:	vpbroadcastd %r11d,%zmm2
     a2a:	test   %r8d,%r8d
     a2d:	jne    a48 <k_blend_u8+0x108>
     a2f:	mov    -0x38(%rsp),%rsi
     a34:	mov    -0x30(%rsp),%rdx
     a39:	mov    %rcx,%rdi
     a3c:	mov    -0x28(%rsp),%r8
     a41:	xor    %eax,%eax
     a43:	jmp    b6c <k_blend_u8+0x22c>
     a48:	mov    -0x10(%rsp),%rdx
     a4d:	test   %rdx,%rdx
     a50:	jne    a61 <k_blend_u8+0x121>
     a52:	mov    %rcx,%rdi
     a55:	mov    -0x20(%rsp),%r9
     a5a:	mov    -0x18(%rsp),%r10
     a5f:	jmp    ab9 <k_blend_u8+0x179>
     a61:	mov    %rcx,%rdi
     a64:	mov    -0x20(%rsp),%r9
     a69:	mov    -0x18(%rsp),%r10
     a6e:	xor    %r8d,%r8d
     a71:	vmovdqu32 (%r10,%r8,1),%xmm3
     a78:	vpmovzxbd %xmm3,%zmm3
     a7e:	vpmulld %zmm0,%zmm3,%zmm3
     a84:	vmovdqu32 (%rax,%r8,1),%xmm4
     a8b:	vpmovzxbd %xmm4,%zmm4
     a91:	vpmulld %zmm1,%zmm4,%zmm4
     a97:	vpaddd %zmm4,%zmm3,%zmm4
     a9d:	vpsrlvd %zmm2,%zmm4,%zmm4
     aa3:	vpmovdb %zmm4,%xmm4
     aa9:	vmovdqu32 %xmm4,(%r9,%r8,1)
     ab0:	add    $0x10,%r8
     ab4:	cmp    %rdx,%r8
     ab7:	jb     a71 <k_blend_u8+0x131>
     ab9:	mov    %rsi,%rcx
     abc:	and    $0xf,%rcx
     ac0:	test   %rcx,%rcx
     ac3:	je     b22 <k_blend_u8+0x1e2>
     ac5:	mov    $0x1,%r8d
     acb:	shl    %cl,%r8
     ace:	sub    $0x1,%r8
     ad2:	movzwl %r8w,%ecx
     ad6:	kmovw  %ecx,%k1
     ada:	add    %rdx,%r10
     add:	vpxord %xmm4,%xmm4,%xmm4
     ae3:	movaps %xmm4,%xmm3
     ae6:	vmovdqu8 (%r10),%xmm3{%k1}
     aec:	vpmovzxbd %xmm3,%zmm3
     af2:	vpmulld %zmm0,%zmm3,%zmm3
     af8:	add    %rdx,%rax
     afb:	vmovdqu8 (%rax),%xmm4{%k1}
     b01:	vpmovzxbd %xmm4,%zmm4
     b07:	vpmulld %zmm1,%zmm4,%zmm4
     b0d:	vpaddd %zmm4,%zmm3,%zmm4
     b13:	vpsrlvd %zmm2,%zmm4,%zmm4
     b19:	add    %rdx,%r9
     b1c:	vpmovdb %zmm4,(%r9){%k1}
     b22:	mov    -0x30(%rsp),%rdx
     b27:	mov    -0x28(%rsp),%r8
     b2c:	mov    %rsi,%rax
     b2f:	mov    -0x38(%rsp),%rsi
     b34:	jmp    b6c <k_blend_u8+0x22c>
     b36:	mov    %r8,-0x28(%rsp)
     b3b:	movzbl (%rsi,%rax,1),%ecx
     b3f:	imul   %edi,%ecx
     b42:	movzbl (%rdx,%rax,1),%r8d
     b47:	mov    $0x100,%r9d
     b4d:	sub    %edi,%r9d
     b50:	imul   %r9d,%r8d
     b54:	add    %r8d,%ecx
     b57:	shr    $0x8,%ecx
     b5a:	mov    -0x40(%rsp),%r8
     b5f:	mov    %cl,(%r8,%rax,1)
     b63:	add    $0x1,%rax
     b67:	mov    -0x28(%rsp),%r8
     b6c:	cmp    %r8,%rax
     b6f:	jb     b36 <k_blend_u8+0x1f6>
     b71:	ret
     b72:	int3
     b73:	int3
     b74:	int3
     b75:	int3
     b76:	int3
     b77:	int3
     b78:	int3
     b79:	int3
     b7a:	int3
     b7b:	int3
     b7c:	int3
     b7d:	int3
     b7e:	int3
     b7f:	int3

0000000000000b80 <k_clamp_i32>:
     b80:	mov    %rsi,%r9
     b83:	mov    %rdi,%r10
     b86:	movslq %r8d,%rax
     b89:	mov    %rsi,-0x38(%rsp)
     b8e:	xor    %esi,%esi
     b90:	test   %r8d,%r8d
     b93:	cmovg  %rax,%rsi
     b97:	mov    %rsi,%rax
     b9a:	and    $0xfffffffffffffff0,%rax
     b9e:	mov    %rdi,-0x40(%rsp)
     ba3:	mov    %eax,%edi
     ba5:	mov    %edi,-0x4(%rsp)
     ba9:	mov    %esi,%edi
     bab:	mov    %rdi,-0x10(%rsp)
     bb0:	xor    %edi,%edi
     bb2:	test   %rsi,%rsi
     bb5:	setne  %dil
     bb9:	mov    %r8d,-0x8(%rsp)
     bbe:	movabs $0x100000000000000,%r8
     bc8:	cmp    %r8,%rsi
     bcb:	mov    $0x0,%r8d
     bd1:	setb   %r8b
     bd5:	test   %edi,%edi
     bd7:	cmovne %r8d,%edi
     bdb:	mov    %r10,%r8
     bde:	mov    %r10,-0x28(%rsp)
     be3:	mov    %rsi,%r10
     be6:	shl    $0x2,%r10
     bea:	mov    %r9,-0x30(%rsp)
     bef:	mov    %rsi,-0x20(%rsp)
     bf4:	shl    $0x2,%rsi
     bf8:	mov    %rax,-0x18(%rsp)
     bfd:	mov    %r9,%rax
     c00:	sub    %r8,%rax
     c03:	sub    %r9,%r8
     c06:	cmp    %r10,%rax
     c09:	mov    $0x0,%eax
     c0e:	setae  %al
     c11:	cmp    %rsi,%r8
     c14:	mov    $0x0,%esi
     c19:	setae  %sil
     c1d:	test   %eax,%eax
     c1f:	cmovne %esi,%eax
     c22:	test   %edi,%edi
     c24:	cmovne %eax,%edi
     c27:	vpbroadcastd %edx,%zmm0
     c2d:	vpbroadcastd %ecx,%zmm1
     c33:	test   %edi,%edi
     c35:	jne    c4b <k_clamp_i32+0xcb>
     c37:	mov    -0x40(%rsp),%rdi
     c3c:	mov    %rcx,%rsi
     c3f:	mov    -0x8(%rsp),%r8d
     c44:	xor    %eax,%eax
     c46:	jmp    d43 <k_clamp_i32+0x1c3>
     c4b:	mov    -0x18(%rsp),%rax
     c50:	test   %rax,%rax
     c53:	jne    c64 <k_clamp_i32+0xe4>
     c55:	mov    %rcx,%rsi
     c58:	mov    -0x30(%rsp),%r9
     c5d:	mov    -0x28(%rsp),%r10
     c62:	jmp    caf <k_clamp_i32+0x12f>
     c64:	mov    %rcx,%rsi
     c67:	mov    -0x30(%rsp),%r9
     c6c:	mov    -0x28(%rsp),%r10
     c71:	mov    -0x4(%rsp),%edi
     c75:	xor    %r8d,%r8d
     c78:	mov    %r8,%rcx
     c7b:	vmovdqu32 (%r9,%rcx,4),%zmm2
     c82:	vpcmpltd %zmm0,%zmm2,%k1
     c89:	vpcmpnled %zmm1,%zmm2,%k2
     c90:	vpblendmd %zmm1,%zmm2,%zmm2{%k2}
     c96:	vpblendmd %zmm0,%zmm2,%zmm2{%k1}
     c9c:	vmovdqu32 %zmm2,(%r10,%rcx,4)
     ca3:	add    $0x10,%r8d
     ca7:	movslq %r8d,%r8
     caa:	cmp    %edi,%r8d
     cad:	jl     c78 <k_clamp_i32+0xf8>
     caf:	mov    -0x20(%rsp),%rcx
     cb4:	and    $0xf,%rcx
     cb8:	test   %rcx,%rcx
     cbb:	je     d04 <k_clamp_i32+0x184>
     cbd:	mov    $0x1,%edi
     cc2:	shl    %cl,%rdi
     cc5:	sub    $0x1,%rdi
     cc9:	movzwl %di,%ecx
     ccc:	kmovw  %ecx,%k1
     cd0:	lea    (%r9,%rax,4),%r9
     cd4:	vpxord %zmm2,%zmm2,%zmm2
     cda:	vmovdqu32 (%r9),%zmm2{%k1}
     ce0:	vpcmpltd %zmm0,%zmm2,%k2
     ce7:	vpcmpnled %zmm1,%zmm2,%k3
     cee:	vpblendmd %zmm1,%zmm2,%zmm2{%k3}
     cf4:	vpblendmd %zmm0,%zmm2,%zmm2{%k2}
     cfa:	lea    (%r10,%rax,4),%r10
     cfe:	vmovdqu32 %zmm2,(%r10){%k1}
     d04:	mov    -0x40(%rsp),%rdi
     d09:	mov    -0x8(%rsp),%r8d
     d0e:	mov    -0x10(%rsp),%rax
     d13:	jmp    d43 <k_clamp_i32+0x1c3>
     d15:	mov    %r8d,-0x8(%rsp)
     d1a:	movslq %eax,%rcx
     d1d:	mov    -0x38(%rsp),%r8
     d22:	mov    (%r8,%rcx,4),%r9d
     d26:	cmp    %esi,%r9d
     d29:	mov    %r9d,%r10d
     d2c:	cmovg  %esi,%r10d
     d30:	cmp    %edx,%r9d
     d33:	cmovl  %edx,%r10d
     d37:	mov    %r10d,(%rdi,%rcx,4)
     d3b:	add    $0x1,%eax
     d3e:	mov    -0x8(%rsp),%r8d
     d43:	cmp    %r8d,%eax
     d46:	jl     d15 <k_clamp_i32+0x195>
     d48:	ret
     d49:	int3
     d4a:	int3
     d4b:	int3
     d4c:	int3
     d4d:	int3
     d4e:	int3
     d4f:	int3

0000000000000d50 <k_i32_to_f32>:
     d50:	xor    %eax,%eax
     d52:	jmp    d69 <k_i32_to_f32+0x19>
     d54:	xorps  %xmm1,%xmm1
     d57:	cvtsi2ssl (%rsi,%rax,4),%xmm1
     d5c:	mulss  %xmm0,%xmm1
     d60:	movss  %xmm1,(%rdi,%rax,4)
     d65:	add    $0x1,%rax
     d69:	cmp    %rdx,%rax
     d6c:	jb     d54 <k_i32_to_f32+0x4>
     d6e:	ret
     d6f:	int3

0000000000000d70 <k_fill_u32>:
     d70:	xor    %eax,%eax
     d72:	mov    %rdi,%r8
     d75:	xor    %ecx,%ecx
     d77:	test   %rdx,%rdx
     d7a:	mov    %rcx,%r9
     d7d:	cmova  %rdx,%r9
     d81:	mov    %r9,%r10
     d84:	and    $0xfffffffffffffff0,%r10
     d88:	xor    %ecx,%ecx
     d8a:	test   %r9,%r9
     d8d:	setne  %cl
     d90:	vpbroadcastd %esi,%zmm0
     d96:	test   %ecx,%ecx
     d98:	je     dec <k_fill_u32+0x7c>
     d9a:	test   %r10,%r10
     d9d:	je     daf <k_fill_u32+0x3f>
     d9f:	vmovdqu32 %zmm0,(%r8,%rax,4)
     da6:	add    $0x10,%rax
     daa:	cmp    %r10,%rax
     dad:	jb     d9f <k_fill_u32+0x2f>
     daf:	mov    %r9,%rax
     db2:	and    $0xf,%rax
     db6:	test   %rax,%rax
     db9:	je     de0 <k_fill_u32+0x70>
     dbb:	mov    $0x1,%ecx
     dc0:	mov    %rcx,%r11
     dc3:	mov    %eax,%ecx
     dc5:	shl    %cl,%r11
     dc8:	mov    %r11,%rax
     dcb:	sub    $0x1,%rax
     dcf:	movzwl %ax,%eax
     dd2:	kmovw  %eax,%k1
     dd6:	lea    (%r8,%r10,4),%r8
     dda:	vmovdqu32 %zmm0,(%r8){%k1}
     de0:	mov    %r9,%rax
     de3:	jmp    dec <k_fill_u32+0x7c>
     de5:	mov    %esi,(%rdi,%rax,4)
     de8:	add    $0x1,%rax
     dec:	cmp    %rdx,%rax
     def:	jb     de5 <k_fill_u32+0x75>
     df1:	ret
     df2:	int3
     df3:	int3
     df4:	int3
     df5:	int3
     df6:	int3
     df7:	int3
     df8:	int3
     df9:	int3
     dfa:	int3
     dfb:	int3
     dfc:	int3
     dfd:	int3
     dfe:	int3
     dff:	int3

0000000000000e00 <k_copy_u8>:
     e00:	mov    %rdi,%r8
     e03:	mov    %rsi,%r9
     e06:	xor    %ecx,%ecx
     e08:	test   %rdx,%rdx
     e0b:	mov    %rcx,%r10
     e0e:	cmova  %rdx,%r10
     e12:	mov    %r10,%rcx
     e15:	and    $0xffffffffffffffc0,%rcx
     e19:	xor    %eax,%eax
     e1b:	test   %r10,%r10
     e1e:	setne  %al
     e21:	mov    %rsi,-0x10(%rsp)
     e26:	movabs $0x100000000000000,%rsi
     e30:	cmp    %rsi,%r10
     e33:	mov    $0x0,%esi
     e38:	setb   %sil
     e3c:	test   %eax,%eax
     e3e:	cmovne %esi,%eax
     e41:	mov    %r8,%rsi
     e44:	mov    %rdi,-0x18(%rsp)
     e49:	mov    %r9,%rdi
     e4c:	mov    %rdx,-0x8(%rsp)
     e51:	mov    %rdi,%rdx
     e54:	sub    %rsi,%rdx
     e57:	sub    %rdi,%rsi
     e5a:	cmp    %r10,%rdx
     e5d:	mov    $0x0,%edx
     e62:	setae  %dl
     e65:	cmp    %r10,%rsi
     e68:	mov    $0x0,%esi
     e6d:	setae  %sil
     e71:	test   %edx,%edx
     e73:	cmovne %esi,%edx
     e76:	test   %eax,%eax
     e78:	cmovne %edx,%eax
     e7b:	test   %eax,%eax
     e7d:	jne    e95 <k_copy_u8+0x95>
     e7f:	mov    -0x18(%rsp),%rdi
     e84:	mov    -0x10(%rsp),%rsi
     e89:	mov    -0x8(%rsp),%rdx
     e8e:	xor    %eax,%eax
     e90:	jmp    f19 <k_copy_u8+0x119>
     e95:	test   %rcx,%rcx
     e98:	jne    e9f <k_copy_u8+0x9f>
     e9a:	mov    %rcx,%rax
     e9d:	jmp    ebb <k_copy_u8+0xbb>
     e9f:	mov    %rcx,%rax
     ea2:	xor    %edx,%edx
     ea4:	vmovdqu32 (%r9,%rdx,1),%zmm0
     eab:	vmovdqu32 %zmm0,(%r8,%rdx,1)
     eb2:	add    $0x40,%rdx
     eb6:	cmp    %rax,%rdx
     eb9:	jb     ea4 <k_copy_u8+0xa4>
     ebb:	mov    %r10,%rcx
     ebe:	and    $0x3f,%rcx
     ec2:	test   %rcx,%rcx
     ec5:	je     ef0 <k_copy_u8+0xf0>
     ec7:	mov    $0x1,%edx
     ecc:	shl    %cl,%rdx
     ecf:	sub    $0x1,%rdx
     ed3:	kmovq  %rdx,%k1
     ed8:	add    %rax,%r9
     edb:	vpxord %zmm0,%zmm0,%zmm0
     ee1:	vmovdqu8 (%r9),%zmm0{%k1}
     ee7:	add    %rax,%r8
     eea:	vmovdqu8 %zmm0,(%r8){%k1}
     ef0:	mov    -0x18(%rsp),%rdi
     ef5:	mov    -0x10(%rsp),%rsi
     efa:	mov    -0x8(%rsp),%rdx
     eff:	mov    %r10,%rax
     f02:	jmp    f19 <k_copy_u8+0x119>
     f04:	mov    %rdx,-0x8(%rsp)
     f09:	movzbl (%rsi,%rax,1),%ecx
     f0d:	mov    %cl,(%rdi,%rax,1)
     f10:	add    $0x1,%rax
     f14:	mov    -0x8(%rsp),%rdx
     f19:	cmp    %rdx,%rax
     f1c:	jb     f04 <k_copy_u8+0x104>
     f1e:	ret
     f1f:	int3

0000000000000f20 <k_stencil3_u8>:
     f20:	mov    %rdi,%r8
     f23:	mov    %rsi,%r9
     f26:	mov    %rsi,%r10
     f29:	mov    %rsi,%rcx
     f2c:	mov    %rdx,%rax
     f2f:	sub    $0x2,%rax
     f33:	mov    %rdi,-0x40(%rsp)
     f38:	xor    %edi,%edi
     f3a:	cmp    $0x2,%rdx
     f3e:	cmova  %rax,%rdi
     f42:	mov    %rdi,%rax
     f45:	and    $0xfffffffffffffff0,%rax
     f49:	mov    %rdx,-0x30(%rsp)
     f4e:	lea    0x1(%rax),%rdx
     f52:	mov    %rdx,-0x10(%rsp)
     f57:	lea    0x1(%rdi),%rdx
     f5b:	mov    %rdx,-0x8(%rsp)
     f60:	xor    %edx,%edx
     f62:	test   %rdi,%rdi
     f65:	setne  %dl
     f68:	mov    %rsi,-0x38(%rsp)
     f6d:	mov    $0x1,%esi
     f72:	test   %edx,%edx
     f74:	cmovne %esi,%edx
     f77:	movabs $0x100000000000000,%rsi
     f81:	cmp    %rsi,%rdi
     f84:	mov    $0x0,%esi
     f89:	setb   %sil
     f8d:	test   %edx,%edx
     f8f:	cmovne %esi,%edx
     f92:	lea    0x1(%r8),%rsi
     f96:	mov    %r8,-0x28(%rsp)
     f9b:	mov    %rsi,%r8
     f9e:	mov    %r9,-0x20(%rsp)
     fa3:	mov    %rax,-0x18(%rsp)
     fa8:	mov    %r9,%rax
     fab:	sub    %r8,%rax
     fae:	sub    %r9,%r8
     fb1:	cmp    %rdi,%rax
     fb4:	mov    $0x0,%eax
     fb9:	setae  %al
     fbc:	cmp    %rdi,%r8
     fbf:	mov    $0x0,%r8d
     fc5:	setae  %r8b
     fc9:	test   %eax,%eax
     fcb:	cmovne %r8d,%eax
     fcf:	test   %edx,%edx
     fd1:	cmovne %eax,%edx
     fd4:	mov    %rsi,%rax
     fd7:	lea    0x1(%r10),%r8
     fdb:	mov    %r8,%r9
     fde:	sub    %rax,%r9
     fe1:	sub    %r8,%rax
     fe4:	xor    %r8d,%r8d
     fe7:	cmp    %rdi,%r9
     fea:	setae  %r8b
     fee:	cmp    %rdi,%rax
     ff1:	mov    $0x0,%eax
     ff6:	setae  %al
     ff9:	test   %r8d,%r8d
     ffc:	cmovne %eax,%r8d
    1000:	test   %edx,%edx
    1002:	cmovne %r8d,%edx
    1006:	lea    0x2(%rcx),%rax
    100a:	mov    %rax,%r8
    100d:	sub    %rsi,%r8
    1010:	sub    %rax,%rsi
    1013:	xor    %eax,%eax
    1015:	cmp    %rdi,%r8
    1018:	setae  %al
    101b:	cmp    %rdi,%rsi
    101e:	mov    $0x0,%esi
    1023:	setae  %sil
    1027:	test   %eax,%eax
    1029:	cmovne %esi,%eax
    102c:	test   %edx,%edx
    102e:	cmovne %eax,%edx
    1031:	mov    $0x2,%r11d
    1037:	vpbroadcastd %r11d,%zmm0
    103d:	mov    $0x2,%r11d
    1043:	vpbroadcastd %r11d,%zmm1
    1049:	mov    $0x2,%r11d
    104f:	vpbroadcastd %r11d,%zmm2
    1055:	test   %edx,%edx
    1057:	jne    1072 <k_stencil3_u8+0x152>
    1059:	mov    -0x40(%rsp),%rdi
    105e:	mov    -0x38(%rsp),%rsi
    1063:	mov    -0x30(%rsp),%rdx
    1068:	mov    $0x1,%eax
    106d:	jmp    11cc <k_stencil3_u8+0x2ac>
    1072:	mov    -0x18(%rsp),%rax
    1077:	test   %rax,%rax
    107a:	jne    1090 <k_stencil3_u8+0x170>
    107c:	mov    -0x28(%rsp),%r8
    1081:	mov    -0x20(%rsp),%r9
    1086:	mov    %rcx,%rax
    1089:	mov    -0x10(%rsp),%rdx
    108e:	jmp    110a <k_stencil3_u8+0x1ea>
    1090:	mov    -0x28(%rsp),%r8
    1095:	mov    -0x20(%rsp),%r9
    109a:	mov    %rcx,%rax
    109d:	mov    -0x10(%rsp),%rdx
    10a2:	mov    $0x1,%esi
    10a7:	vmovdqu32 -0x1(%r9,%rsi,1),%xmm3
    10b2:	vpmovzxbd %xmm3,%zmm3
    10b8:	vmovdqu32 (%r10,%rsi,1),%xmm4
    10bf:	vpmovzxbd %xmm4,%zmm4
    10c5:	vpmulld %zmm4,%zmm0,%zmm4
    10cb:	vpaddd %zmm4,%zmm3,%zmm4
    10d1:	vmovdqu32 0x1(%rax,%rsi,1),%xmm3
    10dc:	vpmovzxbd %xmm3,%zmm3
    10e2:	vpaddd %zmm3,%zmm4,%zmm3
    10e8:	vpaddd %zmm1,%zmm3,%zmm3
    10ee:	vpsravd %zmm2,%zmm3,%zmm3
    10f4:	vpmovdb %zmm3,%xmm3
    10fa:	vmovdqu32 %xmm3,(%r8,%rsi,1)
    1101:	add    $0x10,%rsi
    1105:	cmp    %rdx,%rsi
    1108:	jb     10a7 <k_stencil3_u8+0x187>
    110a:	and    $0xf,%rdi
    110e:	test   %rdi,%rdi
    1111:	je     118c <k_stencil3_u8+0x26c>
    1113:	mov    $0x1,%esi
    1118:	mov    %edi,%ecx
    111a:	shl    %cl,%rsi
    111d:	sub    $0x1,%rsi
    1121:	movzwl %si,%ecx
    1124:	kmovw  %ecx,%k1
    1128:	lea    -0x1(%r9,%rdx,1),%r9
    112d:	vpxord %xmm3,%xmm3,%xmm3
    1133:	movaps %xmm3,%xmm4
    1136:	vmovdqu8 (%r9),%xmm4{%k1}
    113c:	vpmovzxbd %xmm4,%zmm4
    1142:	add    %rdx,%r10
    1145:	movaps %xmm3,%xmm5
    1148:	vmovdqu8 (%r10),%xmm5{%k1}
    114e:	vpmovzxbd %xmm5,%zmm5
    1154:	vpmulld %zmm5,%zmm0,%zmm5
    115a:	vpaddd %zmm5,%zmm4,%zmm5
    1160:	lea    0x1(%rax,%rdx,1),%rax
    1165:	vmovdqu8 (%rax),%xmm3{%k1}
    116b:	vpmovzxbd %xmm3,%zmm3
    1171:	vpaddd %zmm3,%zmm5,%zmm3
    1177:	vpaddd %zmm1,%zmm3,%zmm3
    117d:	vpsravd %zmm2,%zmm3,%zmm3
    1183:	add    %rdx,%r8
    1186:	vpmovdb %zmm3,(%r8){%k1}
    118c:	mov    -0x40(%rsp),%rdi
    1191:	mov    -0x38(%rsp),%rsi
    1196:	mov    -0x30(%rsp),%rdx
    119b:	mov    -0x8(%rsp),%rax
    11a0:	jmp    11cc <k_stencil3_u8+0x2ac>
    11a2:	mov    %rdx,-0x30(%rsp)
    11a7:	movzbl -0x1(%rsi,%rax,1),%ecx
    11ac:	movzbl (%rsi,%rax,1),%edx
    11b0:	lea    (%rcx,%rdx,2),%ecx
    11b3:	movzbl 0x1(%rsi,%rax,1),%edx
    11b8:	add    %edx,%ecx
    11ba:	add    $0x2,%ecx
    11bd:	sar    $0x2,%ecx
    11c0:	mov    %cl,(%rdi,%rax,1)
    11c3:	add    $0x1,%rax
    11c7:	mov    -0x30(%rsp),%rdx
    11cc:	lea    0x1(%rax),%rcx
    11d0:	cmp    %rdx,%rcx
    11d3:	jb     11a2 <k_stencil3_u8+0x282>
    11d5:	ret
    11d6:	int3
    11d7:	int3
    11d8:	int3
    11d9:	int3
    11da:	int3
    11db:	int3
    11dc:	int3
    11dd:	int3
    11de:	int3
    11df:	int3

00000000000011e0 <k_rgb_to_gray>:
    11e0:	xor    %eax,%eax
    11e2:	jmp    1233 <k_rgb_to_gray+0x53>
    11e4:	mov    %rax,%rcx
    11e7:	lea    (%rax,%rax,2),%r8d
    11eb:	movslq %r8d,%r8
    11ee:	movzbl (%rsi,%r8,1),%r8d
    11f3:	imul   $0x4d,%r8d,%r8d
    11f7:	lea    (%rax,%rax,2),%r9d
    11fb:	add    $0x1,%r9d
    11ff:	movslq %r9d,%r9
    1202:	movzbl (%rsi,%r9,1),%r9d
    1207:	imul   $0x96,%r9d,%r9d
    120e:	add    %r9d,%r8d
    1211:	lea    (%rax,%rax,2),%r9d
    1215:	add    $0x2,%r9d
    1219:	movslq %r9d,%r9
    121c:	movzbl (%rsi,%r9,1),%r9d
    1221:	imul   $0x1d,%r9d,%r9d
    1225:	add    %r9d,%r8d
    1228:	sar    $0x8,%r8d
    122c:	mov    %r8b,(%rdi,%rcx,1)
    1230:	add    $0x1,%eax
    1233:	cmp    %edx,%eax
    1235:	jl     11e4 <k_rgb_to_gray+0x4>
    1237:	ret
    1238:	int3
    1239:	int3
    123a:	int3
    123b:	int3
    123c:	int3
    123d:	int3
    123e:	int3
    123f:	int3

0000000000001240 <k_matmul_f32>:
    1240:	xor    %eax,%eax
    1242:	mov    %rax,%r9
    1245:	jmp    12a0 <k_matmul_f32+0x60>
    1247:	mov    %r9,%r10
    124a:	imul   %rcx,%r10
    124e:	add    %rax,%r10
    1251:	movss  (%rdi,%r10,4),%xmm1
    1257:	mov    %rsi,-0x8(%rsp)
    125c:	mov    %r8,%rsi
    125f:	imul   %rcx,%rsi
    1263:	add    %rax,%rsi
    1266:	vfmadd231ss (%rdx,%rsi,4),%xmm0,%xmm1
    126c:	movss  %xmm1,(%rdi,%r10,4)
    1272:	add    $0x1,%rax
    1276:	mov    -0x8(%rsp),%rsi
    127b:	cmp    %rcx,%rax
    127e:	jb     1247 <k_matmul_f32+0x7>
    1280:	add    $0x1,%r8
    1284:	cmp    %rcx,%r8
    1287:	jae    129c <k_matmul_f32+0x5c>
    1289:	mov    %r9,%rax
    128c:	imul   %rcx,%rax
    1290:	add    %r8,%rax
    1293:	movss  (%rsi,%rax,4),%xmm0
    1298:	xor    %eax,%eax
    129a:	jmp    127b <k_matmul_f32+0x3b>
    129c:	add    $0x1,%r9
    12a0:	cmp    %rcx,%r9
    12a3:	jae    12aa <k_matmul_f32+0x6a>
    12a5:	xor    %r8d,%r8d
    12a8:	jmp    1284 <k_matmul_f32+0x44>
    12aa:	ret
    12ab:	int3
    12ac:	int3
    12ad:	int3
    12ae:	int3
    12af:	int3

00000000000012b0 <k_dot_f32>:
    12b0:	xorps  %xmm0,%xmm0
    12b3:	xor    %eax,%eax
    12b5:	jmp    12c6 <k_dot_f32+0x16>
    12b7:	movss  (%rdi,%rax,4),%xmm1
    12bc:	vfmadd231ss (%rsi,%rax,4),%xmm1,%xmm0
    12c2:	add    $0x1,%rax
    12c6:	cmp    %rdx,%rax
    12c9:	jb     12b7 <k_dot_f32+0x7>
    12cb:	ret
    12cc:	int3
    12cd:	int3
    12ce:	int3
    12cf:	int3

00000000000012d0 <k_prefix_sum_i32>:
    12d0:	mov    $0x1,%eax
    12d5:	jmp    12e5 <k_prefix_sum_i32+0x15>
    12d7:	mov    (%rdi,%rax,4),%ecx
    12da:	add    -0x4(%rdi,%rax,4),%ecx
    12de:	mov    %ecx,(%rdi,%rax,4)
    12e1:	add    $0x1,%rax
    12e5:	cmp    %rsi,%rax
    12e8:	jb     12d7 <k_prefix_sum_i32+0x7>
    12ea:	ret
    12eb:	int3
    12ec:	int3
    12ed:	int3
    12ee:	int3
    12ef:	int3

00000000000012f0 <k_histogram_u8>:
    12f0:	xor    %eax,%eax
    12f2:	jmp    1308 <k_histogram_u8+0x18>
    12f4:	movzbl (%rsi,%rax,1),%ecx
    12f8:	mov    (%rdi,%rcx,4),%r8d
    12fc:	add    $0x1,%r8d
    1300:	mov    %r8d,(%rdi,%rcx,4)
    1304:	add    $0x1,%rax
    1308:	cmp    %rdx,%rax
    130b:	jb     12f4 <k_histogram_u8+0x4>
    130d:	ret
    130e:	int3
    130f:	int3

0000000000001310 <k_find_u8>:
    1310:	movzbl %dl,%eax
    1313:	xor    %ecx,%ecx
    1315:	jmp    1327 <k_find_u8+0x17>
    1317:	movzbl (%rdi,%rcx,1),%edx
    131b:	mov    %eax,%r8d
    131e:	cmp    %r8d,%edx
    1321:	je     132c <k_find_u8+0x1c>
    1323:	add    $0x1,%rcx
    1327:	cmp    %rsi,%rcx
    132a:	jb     1317 <k_find_u8+0x7>
    132c:	mov    %rcx,%rax
    132f:	ret

0000000000001330 <k_crc32_table>:
    1330:	mov    $0xffffffff,%eax
    1335:	xor    %ecx,%ecx
    1337:	jmp    1353 <k_crc32_table+0x23>
    1339:	movzbl (%rdi,%rcx,1),%r8d
    133e:	xor    %eax,%r8d
    1341:	and    $0xff,%r8d
    1348:	shr    $0x8,%eax
    134b:	xor    (%rdx,%r8,4),%eax
    134f:	add    $0x1,%rcx
    1353:	cmp    %rsi,%rcx
    1356:	jb     1339 <k_crc32_table+0x9>
    1358:	not    %eax
    135a:	ret
    135b:	int3
    135c:	int3
    135d:	int3
    135e:	int3
    135f:	int3

0000000000001360 <k_fnv1a>:
    1360:	mov    $0x811c9dc5,%eax
    1365:	xor    %ecx,%ecx
    1367:	jmp    1379 <k_fnv1a+0x19>
    1369:	movzbl (%rdi,%rcx,1),%edx
    136d:	xor    %edx,%eax
    136f:	imul   $0x1000193,%eax,%eax
    1375:	add    $0x1,%rcx
    1379:	cmp    %rsi,%rcx
    137c:	jb     1369 <k_fnv1a+0x9>
    137e:	ret
