
measure:     file format elf64-x86-64


Disassembly of section .init:

Disassembly of section .plt:

Disassembly of section .text:

00000000000071d0 <tier1_allocation_filter_fixed>:
    71d0:	55                   	push   %rbp
    71d1:	41 57                	push   %r15
    71d3:	41 56                	push   %r14
    71d5:	41 55                	push   %r13
    71d7:	41 54                	push   %r12
    71d9:	53                   	push   %rbx
    71da:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
    71e1:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    71e8:	00 00 
    71ea:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
    71f1:	00 
    71f2:	b0 01                	mov    $0x1,%al
    71f4:	44 8b 97 90 00 00 00 	mov    0x90(%rdi),%r10d
    71fb:	4d 85 d2             	test   %r10,%r10
    71fe:	0f 84 2a 02 00 00    	je     742e <tier1_allocation_filter_fixed+0x25e>
    7204:	44 8b 5f 5c          	mov    0x5c(%rdi),%r11d
    7208:	4d 85 db             	test   %r11,%r11
    720b:	0f 84 1d 02 00 00    	je     742e <tier1_allocation_filter_fixed+0x25e>
    7211:	44 8b 7f 64          	mov    0x64(%rdi),%r15d
    7215:	4c 89 db             	mov    %r11,%rbx
    7218:	47 8d 34 13          	lea    (%r11,%r10,1),%r14d
    721c:	49 0f af da          	imul   %r10,%rbx
    7220:	49 c1 e6 04          	shl    $0x4,%r14
    7224:	4d 01 f7             	add    %r14,%r15
    7227:	4c 39 fb             	cmp    %r15,%rbx
    722a:	0f 86 fe 00 00 00    	jbe    732e <tier1_allocation_filter_fixed+0x15e>
    7230:	4c 8b 1e             	mov    (%rsi),%r11
    7233:	48 8b 46 08          	mov    0x8(%rsi),%rax
    7237:	4a 8d 5c 18 03       	lea    0x3(%rax,%r11,1),%rbx
    723c:	4c 01 d8             	add    %r11,%rax
    723f:	48 83 e3 fc          	and    $0xfffffffffffffffc,%rbx
    7243:	48 39 c3             	cmp    %rax,%rbx
    7246:	0f 82 e0 01 00 00    	jb     742c <tier1_allocation_filter_fixed+0x25c>
    724c:	48 89 d8             	mov    %rbx,%rax
    724f:	4c 29 d8             	sub    %r11,%rax
    7252:	4c 8b 5e 10          	mov    0x10(%rsi),%r11
    7256:	49 c1 e2 02          	shl    $0x2,%r10
    725a:	49 29 c3             	sub    %rax,%r11
    725d:	40 0f 92 c5          	setb   %bpl
    7261:	4d 39 da             	cmp    %r11,%r10
    7264:	41 0f 97 c3          	seta   %r11b
    7268:	41 08 eb             	or     %bpl,%r11b
    726b:	0f 85 bb 01 00 00    	jne    742c <tier1_allocation_filter_fixed+0x25c>
    7271:	4c 01 d0             	add    %r10,%rax
    7274:	48 89 46 08          	mov    %rax,0x8(%rsi)
    7278:	48 85 db             	test   %rbx,%rbx
    727b:	0f 84 ab 01 00 00    	je     742c <tier1_allocation_filter_fixed+0x25c>
    7281:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
    7285:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xd0(%rsp)
    728c:	d0 00 00 00 
    7290:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x90(%rsp)
    7297:	90 00 00 00 
    729b:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x50(%rsp)
    72a2:	50 00 00 00 
    72a6:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x10(%rsp)
    72ad:	10 00 00 00 
    72b1:	49 89 d6             	mov    %rdx,%r14
    72b4:	89 cd                	mov    %ecx,%ebp
    72b6:	4d 89 cf             	mov    %r9,%r15
    72b9:	49 89 fc             	mov    %rdi,%r12
    72bc:	31 f6                	xor    %esi,%esi
    72be:	4d 89 c5             	mov    %r8,%r13
    72c1:	8b 47 64             	mov    0x64(%rdi),%eax
    72c4:	4c 89 c7             	mov    %r8,%rdi
    72c7:	48 8d 14 85 08 00 00 	lea    0x8(,%rax,4),%rdx
    72ce:	00 
    72cf:	c5 f8 77             	vzeroupper
    72d2:	e8 b9 9d ff ff       	call   1090 <memset@plt>
    72d7:	41 83 bc 24 90 00 00 	cmpl   $0x0,0x90(%r12)
    72de:	00 00 
    72e0:	4c 89 e9             	mov    %r13,%rcx
    72e3:	4c 89 e2             	mov    %r12,%rdx
    72e6:	74 26                	je     730e <tier1_allocation_filter_fixed+0x13e>
    72e8:	31 c0                	xor    %eax,%eax
    72ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    72f0:	48 8b 72 70          	mov    0x70(%rdx),%rsi
    72f4:	8b 34 86             	mov    (%rsi,%rax,4),%esi
    72f7:	8b 3c b1             	mov    (%rcx,%rsi,4),%edi
    72fa:	89 3c 83             	mov    %edi,(%rbx,%rax,4)
    72fd:	48 ff c0             	inc    %rax
    7300:	89 04 b1             	mov    %eax,(%rcx,%rsi,4)
    7303:	8b b2 90 00 00 00    	mov    0x90(%rdx),%esi
    7309:	48 39 f0             	cmp    %rsi,%rax
    730c:	72 e2                	jb     72f0 <tier1_allocation_filter_fixed+0x120>
    730e:	b0 01                	mov    $0x1,%al
    7310:	85 ed                	test   %ebp,%ebp
    7312:	0f 84 16 01 00 00    	je     742e <tier1_allocation_filter_fixed+0x25e>
    7318:	4c 89 f7             	mov    %r14,%rdi
    731b:	41 89 e8             	mov    %ebp,%r8d
    731e:	45 31 f6             	xor    %r14d,%r14d
    7321:	45 31 c9             	xor    %r9d,%r9d
    7324:	4c 89 7c 24 08       	mov    %r15,0x8(%rsp)
    7329:	e9 77 01 00 00       	jmp    74a5 <tier1_allocation_filter_fixed+0x2d5>
    732e:	ba 10 00 00 00       	mov    $0x10,%edx
    7333:	be ff ff ff ff       	mov    $0xffffffff,%esi
    7338:	31 c9                	xor    %ecx,%ecx
    733a:	eb 16                	jmp    7352 <tier1_allocation_filter_fixed+0x182>
    733c:	0f 1f 40 00          	nopl   0x0(%rax)
    7340:	48 ff c1             	inc    %rcx
    7343:	44 89 d3             	mov    %r10d,%ebx
    7346:	45 89 c3             	mov    %r8d,%r11d
    7349:	48 39 d9             	cmp    %rbx,%rcx
    734c:	0f 83 dc 00 00 00    	jae    742e <tier1_allocation_filter_fixed+0x25e>
    7352:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    7358:	45 85 db             	test   %r11d,%r11d
    735b:	74 e3                	je     7340 <tier1_allocation_filter_fixed+0x170>
    735d:	45 31 c0             	xor    %r8d,%r8d
    7360:	45 31 d2             	xor    %r10d,%r10d
    7363:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    736a:	84 00 00 00 00 00 
    7370:	45 01 c3             	add    %r8d,%r11d
    7373:	4c 8b 77 08          	mov    0x8(%rdi),%r14
    7377:	44 89 d3             	mov    %r10d,%ebx
    737a:	4c 8b 27             	mov    (%rdi),%r12
    737d:	4c 8b 7f 20          	mov    0x20(%rdi),%r15
    7381:	41 83 fb 10          	cmp    $0x10,%r11d
    7385:	44 0f 43 da          	cmovae %edx,%r11d
    7389:	41 83 c2 10          	add    $0x10,%r10d
    738d:	41 83 c0 f0          	add    $0xfffffff0,%r8d
    7391:	c4 62 21 f7 de       	shlx   %r11d,%esi,%r11d
    7396:	41 f7 d3             	not    %r11d
    7399:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
    739e:	4c 8b 5f 78          	mov    0x78(%rdi),%r11
    73a2:	62 d1 7e c9 6f 0c 9e 	vmovdqu32 (%r14,%rbx,4),%zmm1{%k1}{z}
    73a9:	4c 8b b7 88 00 00 00 	mov    0x88(%rdi),%r14
    73b0:	62 d1 7f 89 6f 14 1f 	vmovdqu8 (%r15,%rbx,1),%xmm2{%k1}{z}
    73b7:	62 d1 7e c9 6f 04 9c 	vmovdqu32 (%r12,%rbx,4),%zmm0{%k1}{z}
    73be:	4c 8b 7f 70          	mov    0x70(%rdi),%r15
    73c2:	c4 c2 79 78 1c 0e    	vpbroadcastb (%r14,%rcx,1),%xmm3
    73c8:	4c 8b b7 80 00 00 00 	mov    0x80(%rdi),%r14
    73cf:	62 f1 6d 08 74 d3    	vpcmpeqb %xmm3,%xmm2,%k2
    73d5:	62 d3 7d 5a 1e 14 8b 	vpcmpltud (%r11,%rcx,4){1to16},%zmm0,%k2{%k2}
    73dc:	01 
    73dd:	62 d1 7e c9 6f 04 99 	vmovdqu32 (%r9,%rbx,4),%zmm0{%k1}{z}
    73e4:	62 d3 75 5a 1e 04 8f 	vpcmpnleud (%r15,%rcx,4){1to16},%zmm1,%k0{%k2}
    73eb:	06 
    73ec:	c4 c1 79 6e 0c 8e    	vmovd  (%r14,%rcx,4),%xmm1
    73f2:	62 f3 f5 08 25 c9 0f 	vpternlogq $0xf,%xmm1,%xmm1,%xmm1
    73f9:	c5 fc 41 c9          	kandw  %k1,%k0,%k1
    73fd:	62 f2 7d 48 58 c9    	vpbroadcastd %xmm1,%zmm1
    7403:	62 f1 75 48 db c0    	vpandd %zmm0,%zmm1,%zmm0
    7409:	62 d1 7e 49 7f 04 99 	vmovdqu32 %zmm0,(%r9,%rbx,4){%k1}
    7410:	44 8b 5f 5c          	mov    0x5c(%rdi),%r11d
    7414:	45 39 da             	cmp    %r11d,%r10d
    7417:	0f 82 53 ff ff ff    	jb     7370 <tier1_allocation_filter_fixed+0x1a0>
    741d:	44 8b 97 90 00 00 00 	mov    0x90(%rdi),%r10d
    7424:	45 89 d8             	mov    %r11d,%r8d
    7427:	e9 14 ff ff ff       	jmp    7340 <tier1_allocation_filter_fixed+0x170>
    742c:	31 c0                	xor    %eax,%eax
    742e:	64 48 8b 0c 25 28 00 	mov    %fs:0x28,%rcx
    7435:	00 00 
    7437:	48 3b 8c 24 10 01 00 	cmp    0x110(%rsp),%rcx
    743e:	00 
    743f:	0f 85 36 02 00 00    	jne    767b <tier1_allocation_filter_fixed+0x4ab>
    7445:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
    744c:	5b                   	pop    %rbx
    744d:	41 5c                	pop    %r12
    744f:	41 5d                	pop    %r13
    7451:	41 5e                	pop    %r14
    7453:	41 5f                	pop    %r15
    7455:	5d                   	pop    %rbp
    7456:	c5 f8 77             	vzeroupper
    7459:	c3                   	ret
    745a:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
    745f:	45 89 de             	mov    %r11d,%r14d
    7462:	4c 8b 5a 20          	mov    0x20(%rdx),%r11
    7466:	48 8b 32             	mov    (%rdx),%rsi
    7469:	47 0f b6 1c 13       	movzbl (%r11,%r10,1),%r11d
    746e:	62 b2 7d 48 58 04 96 	vpbroadcastd (%rsi,%r10,4),%zmm0
    7475:	41 c1 e3 07          	shl    $0x7,%r11d
    7479:	62 b3 7d 48 1e 84 1c 	vpcmpnltud 0x10(%rsp,%r11,1),%zmm0,%k0
    7480:	10 00 00 00 05 
    7485:	62 b3 7d 48 1e 8c 1c 	vpcmpnltud 0x50(%rsp,%r11,1),%zmm0,%k1
    748c:	50 00 00 00 05 
    7491:	c5 f4 4b c0          	kunpckwd %k0,%k1,%k0
    7495:	c5 fb 93 f0          	kmovd  %k0,%esi
    7499:	43 21 34 97          	and    %esi,(%r15,%r10,4)
    749d:	49 ff c1             	inc    %r9
    74a0:	4d 39 c1             	cmp    %r8,%r9
    74a3:	74 89                	je     742e <tier1_allocation_filter_fixed+0x25e>
    74a5:	46 8b 14 8f          	mov    (%rdi,%r9,4),%r10d
    74a9:	41 f7 c2 01 00 00 80 	test   $0x80000001,%r10d
    74b0:	75 eb                	jne    749d <tier1_allocation_filter_fixed+0x2cd>
    74b2:	4c 8b 5a 08          	mov    0x8(%rdx),%r11
    74b6:	41 d1 ea             	shr    $1,%r10d
    74b9:	47 8b 1c 93          	mov    (%r11,%r10,4),%r11d
    74bd:	45 39 de             	cmp    %r11d,%r14d
    74c0:	73 a0                	jae    7462 <tier1_allocation_filter_fixed+0x292>
    74c2:	44 89 dd             	mov    %r11d,%ebp
    74c5:	44 29 f5             	sub    %r14d,%ebp
    74c8:	45 89 f7             	mov    %r14d,%r15d
    74cb:	4d 89 fe             	mov    %r15,%r14
    74ce:	40 f6 c5 01          	test   $0x1,%bpl
    74d2:	0f 84 82 00 00 00    	je     755a <tier1_allocation_filter_fixed+0x38a>
    74d8:	46 8b 34 b9          	mov    (%rcx,%r15,4),%r14d
    74dc:	45 85 f6             	test   %r14d,%r14d
    74df:	74 75                	je     7556 <tier1_allocation_filter_fixed+0x386>
    74e1:	4c 8b a2 88 00 00 00 	mov    0x88(%rdx),%r12
    74e8:	4c 8b 6a 78          	mov    0x78(%rdx),%r13
    74ec:	48 8b aa 80 00 00 00 	mov    0x80(%rdx),%rbp
    74f3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    74fa:	84 00 00 00 00 00 
    7500:	41 ff ce             	dec    %r14d
    7503:	43 0f b6 34 34       	movzbl (%r12,%r14,1),%esi
    7508:	62 92 7d 48 58 44 b5 	vpbroadcastd 0x0(%r13,%r14,4),%zmm0
    750f:	00 
    7510:	c4 a1 78 90 4c b5 00 	kmovw  0x0(%rbp,%r14,4),%k1
    7517:	c4 a1 78 90 54 b5 02 	kmovw  0x2(%rbp,%r14,4),%k2
    751e:	c1 e6 07             	shl    $0x7,%esi
    7521:	62 f2 7d 48 3f 8c 34 	vpmaxud 0x10(%rsp,%rsi,1),%zmm0,%zmm1
    7528:	10 00 00 00 
    752c:	62 f1 7e 49 7f 8c 34 	vmovdqu32 %zmm1,0x10(%rsp,%rsi,1){%k1}
    7533:	10 00 00 00 
    7537:	62 f2 7d 48 3f 84 34 	vpmaxud 0x50(%rsp,%rsi,1),%zmm0,%zmm0
    753e:	50 00 00 00 
    7542:	62 f1 7e 4a 7f 84 34 	vmovdqu32 %zmm0,0x50(%rsp,%rsi,1){%k2}
    7549:	50 00 00 00 
    754d:	46 8b 34 b3          	mov    (%rbx,%r14,4),%r14d
    7551:	45 85 f6             	test   %r14d,%r14d
    7554:	75 aa                	jne    7500 <tier1_allocation_filter_fixed+0x330>
    7556:	4d 8d 77 01          	lea    0x1(%r15),%r14
    755a:	49 8d 73 ff          	lea    -0x1(%r11),%rsi
    755e:	4c 39 fe             	cmp    %r15,%rsi
    7561:	75 1a                	jne    757d <tier1_allocation_filter_fixed+0x3ad>
    7563:	e9 f2 fe ff ff       	jmp    745a <tier1_allocation_filter_fixed+0x28a>
    7568:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    756f:	00 
    7570:	49 83 c6 02          	add    $0x2,%r14
    7574:	4d 39 de             	cmp    %r11,%r14
    7577:	0f 84 dd fe ff ff    	je     745a <tier1_allocation_filter_fixed+0x28a>
    757d:	46 8b 3c b1          	mov    (%rcx,%r14,4),%r15d
    7581:	45 85 ff             	test   %r15d,%r15d
    7584:	74 70                	je     75f6 <tier1_allocation_filter_fixed+0x426>
    7586:	4c 8b a2 88 00 00 00 	mov    0x88(%rdx),%r12
    758d:	4c 8b 6a 78          	mov    0x78(%rdx),%r13
    7591:	48 8b aa 80 00 00 00 	mov    0x80(%rdx),%rbp
    7598:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    759f:	00 
    75a0:	41 ff cf             	dec    %r15d
    75a3:	43 0f b6 34 3c       	movzbl (%r12,%r15,1),%esi
    75a8:	62 92 7d 48 58 44 bd 	vpbroadcastd 0x0(%r13,%r15,4),%zmm0
    75af:	00 
    75b0:	c4 a1 78 90 4c bd 00 	kmovw  0x0(%rbp,%r15,4),%k1
    75b7:	c4 a1 78 90 54 bd 02 	kmovw  0x2(%rbp,%r15,4),%k2
    75be:	c1 e6 07             	shl    $0x7,%esi
    75c1:	62 f2 7d 48 3f 8c 34 	vpmaxud 0x10(%rsp,%rsi,1),%zmm0,%zmm1
    75c8:	10 00 00 00 
    75cc:	62 f1 7e 49 7f 8c 34 	vmovdqu32 %zmm1,0x10(%rsp,%rsi,1){%k1}
    75d3:	10 00 00 00 
    75d7:	62 f2 7d 48 3f 84 34 	vpmaxud 0x50(%rsp,%rsi,1),%zmm0,%zmm0
    75de:	50 00 00 00 
    75e2:	62 f1 7e 4a 7f 84 34 	vmovdqu32 %zmm0,0x50(%rsp,%rsi,1){%k2}
    75e9:	50 00 00 00 
    75ed:	46 8b 3c bb          	mov    (%rbx,%r15,4),%r15d
    75f1:	45 85 ff             	test   %r15d,%r15d
    75f4:	75 aa                	jne    75a0 <tier1_allocation_filter_fixed+0x3d0>
    75f6:	46 8b 7c b1 04       	mov    0x4(%rcx,%r14,4),%r15d
    75fb:	45 85 ff             	test   %r15d,%r15d
    75fe:	0f 84 6c ff ff ff    	je     7570 <tier1_allocation_filter_fixed+0x3a0>
    7604:	4c 8b a2 88 00 00 00 	mov    0x88(%rdx),%r12
    760b:	4c 8b 6a 78          	mov    0x78(%rdx),%r13
    760f:	48 8b aa 80 00 00 00 	mov    0x80(%rdx),%rbp
    7616:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    761d:	00 00 00 
    7620:	41 ff cf             	dec    %r15d
    7623:	43 0f b6 34 3c       	movzbl (%r12,%r15,1),%esi
    7628:	62 92 7d 48 58 44 bd 	vpbroadcastd 0x0(%r13,%r15,4),%zmm0
    762f:	00 
    7630:	c4 a1 78 90 4c bd 00 	kmovw  0x0(%rbp,%r15,4),%k1
    7637:	c4 a1 78 90 54 bd 02 	kmovw  0x2(%rbp,%r15,4),%k2
    763e:	c1 e6 07             	shl    $0x7,%esi
    7641:	62 f2 7d 48 3f 8c 34 	vpmaxud 0x10(%rsp,%rsi,1),%zmm0,%zmm1
    7648:	10 00 00 00 
    764c:	62 f1 7e 49 7f 8c 34 	vmovdqu32 %zmm1,0x10(%rsp,%rsi,1){%k1}
    7653:	10 00 00 00 
    7657:	62 f2 7d 48 3f 84 34 	vpmaxud 0x50(%rsp,%rsi,1),%zmm0,%zmm0
    765e:	50 00 00 00 
    7662:	62 f1 7e 4a 7f 84 34 	vmovdqu32 %zmm0,0x50(%rsp,%rsi,1){%k2}
    7669:	50 00 00 00 
    766d:	46 8b 3c bb          	mov    (%rbx,%r15,4),%r15d
    7671:	45 85 ff             	test   %r15d,%r15d
    7674:	75 aa                	jne    7620 <tier1_allocation_filter_fixed+0x450>
    7676:	e9 f5 fe ff ff       	jmp    7570 <tier1_allocation_filter_fixed+0x3a0>
    767b:	c5 f8 77             	vzeroupper
    767e:	e8 cd 99 ff ff       	call   1050 <__stack_chk_fail@plt>

Disassembly of section .fini:
