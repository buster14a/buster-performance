
head/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000009f1210 <pp_parameter_insert>:
  9f1210:	55                   	push   %rbp
  9f1211:	41 57                	push   %r15
  9f1213:	41 56                	push   %r14
  9f1215:	41 55                	push   %r13
  9f1217:	41 54                	push   %r12
  9f1219:	53                   	push   %rbx
  9f121a:	48 83 ec 18          	sub    $0x18,%rsp
  9f121e:	48 8b 87 80 00 00 00 	mov    0x80(%rdi),%rax
  9f1225:	48 85 c0             	test   %rax,%rax
  9f1228:	74 65                	je     9f128f <pp_parameter_insert+0x7f>
  9f122a:	44 8b 87 88 00 00 00 	mov    0x88(%rdi),%r8d
  9f1231:	49 b9 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r9
  9f1238:	79 37 9e 
  9f123b:	41 89 f2             	mov    %esi,%r10d
  9f123e:	4d 0f af ca          	imul   %r10,%r9
  9f1242:	49 c1 e9 20          	shr    $0x20,%r9
  9f1246:	41 ff c8             	dec    %r8d
  9f1249:	45 21 c1             	and    %r8d,%r9d
  9f124c:	4e 8b 14 c8          	mov    (%rax,%r9,8),%r10
  9f1250:	4d 85 d2             	test   %r10,%r10
  9f1253:	74 26                	je     9f127b <pp_parameter_insert+0x6b>
  9f1255:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  9f125c:	00 00 00 00 
  9f1260:	4d 89 d3             	mov    %r10,%r11
  9f1263:	49 c1 eb 20          	shr    $0x20,%r11
  9f1267:	44 39 de             	cmp    %r11d,%esi
  9f126a:	74 0f                	je     9f127b <pp_parameter_insert+0x6b>
  9f126c:	41 ff c1             	inc    %r9d
  9f126f:	45 21 c1             	and    %r8d,%r9d
  9f1272:	4e 8b 14 c8          	mov    (%rax,%r9,8),%r10
  9f1276:	4d 85 d2             	test   %r10,%r10
  9f1279:	75 e5                	jne    9f1260 <pp_parameter_insert+0x50>
  9f127b:	41 ff ca             	dec    %r10d
  9f127e:	b0 01                	mov    $0x1,%al
  9f1280:	44 89 11             	mov    %r10d,(%rcx)
  9f1283:	41 83 fa ff          	cmp    $0xffffffff,%r10d
  9f1287:	0f 85 64 02 00 00    	jne    9f14f1 <pp_parameter_insert+0x2e1>
  9f128d:	eb 7a                	jmp    9f1309 <pp_parameter_insert+0xf9>
  9f128f:	8b 87 8c 00 00 00    	mov    0x8c(%rdi),%eax
  9f1295:	80 bf 90 00 00 00 00 	cmpb   $0x0,0x90(%rdi)
  9f129c:	74 3a                	je     9f12d8 <pp_parameter_insert+0xc8>
  9f129e:	41 b8 ff ff 00 00    	mov    $0xffff,%r8d
  9f12a4:	62 f2 7d 48 7c ce    	vpbroadcastd %esi,%zmm1
  9f12aa:	c4 c2 78 f5 c0       	bzhi   %eax,%r8d,%eax
  9f12af:	c5 fb 92 c8          	kmovd  %eax,%k1
  9f12b3:	62 f1 7e c9 6f 07    	vmovdqu32 (%rdi),%zmm0{%k1}{z}
  9f12b9:	62 f1 7d 48 76 c1    	vpcmpeqd %zmm1,%zmm0,%k0
  9f12bf:	c5 f8 99 c1          	ktestw %k1,%k0
  9f12c3:	74 3e                	je     9f1303 <pp_parameter_insert+0xf3>
  9f12c5:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
  9f12c9:	c5 fb 93 c0          	kmovd  %k0,%eax
  9f12cd:	f3 0f bc c0          	tzcnt  %eax,%eax
  9f12d1:	44 8b 54 87 40       	mov    0x40(%rdi,%rax,4),%r10d
  9f12d6:	eb a6                	jmp    9f127e <pp_parameter_insert+0x6e>
  9f12d8:	48 85 c0             	test   %rax,%rax
  9f12db:	74 26                	je     9f1303 <pp_parameter_insert+0xf3>
  9f12dd:	45 31 c0             	xor    %r8d,%r8d
  9f12e0:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  9f12e6:	42 39 34 87          	cmp    %esi,(%rdi,%r8,4)
  9f12ea:	75 05                	jne    9f12f1 <pp_parameter_insert+0xe1>
  9f12ec:	46 8b 4c 87 40       	mov    0x40(%rdi,%r8,4),%r9d
  9f12f1:	41 83 f9 ff          	cmp    $0xffffffff,%r9d
  9f12f5:	0f 85 dd 00 00 00    	jne    9f13d8 <pp_parameter_insert+0x1c8>
  9f12fb:	49 ff c0             	inc    %r8
  9f12fe:	4c 39 c0             	cmp    %r8,%rax
  9f1301:	75 dd                	jne    9f12e0 <pp_parameter_insert+0xd0>
  9f1303:	c7 01 ff ff ff ff    	movl   $0xffffffff,(%rcx)
  9f1309:	48 8b 9f 80 00 00 00 	mov    0x80(%rdi),%rbx
  9f1310:	8b 87 8c 00 00 00    	mov    0x8c(%rdi),%eax
  9f1316:	48 85 db             	test   %rbx,%rbx
  9f1319:	0f 94 c1             	sete   %cl
  9f131c:	48 83 f8 10          	cmp    $0x10,%rax
  9f1320:	41 0f 92 c0          	setb   %r8b
  9f1324:	41 20 c8             	and    %cl,%r8b
  9f1327:	41 80 f8 01          	cmp    $0x1,%r8b
  9f132b:	75 0f                	jne    9f133c <pp_parameter_insert+0x12c>
  9f132d:	89 34 87             	mov    %esi,(%rdi,%rax,4)
  9f1330:	8b 87 8c 00 00 00    	mov    0x8c(%rdi),%eax
  9f1336:	89 54 87 40          	mov    %edx,0x40(%rdi,%rax,4)
  9f133a:	eb 5e                	jmp    9f139a <pp_parameter_insert+0x18a>
  9f133c:	44 8b b7 88 00 00 00 	mov    0x88(%rdi),%r14d
  9f1343:	44 89 f1             	mov    %r14d,%ecx
  9f1346:	d1 e9                	shr    $1,%ecx
  9f1348:	39 c8                	cmp    %ecx,%eax
  9f134a:	73 55                	jae    9f13a1 <pp_parameter_insert+0x191>
  9f134c:	48 b8 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%rax
  9f1353:	79 37 9e 
  9f1356:	89 f1                	mov    %esi,%ecx
  9f1358:	49 89 c8             	mov    %rcx,%r8
  9f135b:	49 c1 e0 20          	shl    $0x20,%r8
  9f135f:	41 ff ce             	dec    %r14d
  9f1362:	48 0f af c1          	imul   %rcx,%rax
  9f1366:	89 d1                	mov    %edx,%ecx
  9f1368:	48 ff c1             	inc    %rcx
  9f136b:	4c 09 c1             	or     %r8,%rcx
  9f136e:	48 c1 e8 20          	shr    $0x20,%rax
  9f1372:	44 21 f0             	and    %r14d,%eax
  9f1375:	48 8b 14 c3          	mov    (%rbx,%rax,8),%rdx
  9f1379:	48 85 d2             	test   %rdx,%rdx
  9f137c:	74 18                	je     9f1396 <pp_parameter_insert+0x186>
  9f137e:	66 90                	xchg   %ax,%ax
  9f1380:	48 c1 ea 20          	shr    $0x20,%rdx
  9f1384:	39 d6                	cmp    %edx,%esi
  9f1386:	74 0e                	je     9f1396 <pp_parameter_insert+0x186>
  9f1388:	ff c0                	inc    %eax
  9f138a:	44 21 f0             	and    %r14d,%eax
  9f138d:	48 8b 14 c3          	mov    (%rbx,%rax,8),%rdx
  9f1391:	48 85 d2             	test   %rdx,%rdx
  9f1394:	75 ea                	jne    9f1380 <pp_parameter_insert+0x170>
  9f1396:	48 89 0c c3          	mov    %rcx,(%rbx,%rax,8)
  9f139a:	b1 01                	mov    $0x1,%cl
  9f139c:	e9 47 01 00 00       	jmp    9f14e8 <pp_parameter_insert+0x2d8>
  9f13a1:	4c 8b a7 98 00 00 00 	mov    0x98(%rdi),%r12
  9f13a8:	4d 85 e4             	test   %r12,%r12
  9f13ab:	0f 85 03 01 00 00    	jne    9f14b4 <pp_parameter_insert+0x2a4>
  9f13b1:	49 c7 c5 60 f5 ff ff 	mov    $0xfffffffffffff560,%r13
  9f13b8:	64 48 8b 04 25 00 00 	mov    %fs:0x0,%rax
  9f13bf:	00 00 
  9f13c1:	64 49 83 7d 20 00    	cmpq   $0x0,%fs:0x20(%r13)
  9f13c7:	4e 8d 64 28 20       	lea    0x20(%rax,%r13,1),%r12
  9f13cc:	74 14                	je     9f13e2 <pp_parameter_insert+0x1d2>
  9f13ce:	64 49 8b 45 28       	mov    %fs:0x28(%r13),%rax
  9f13d3:	e9 ce 00 00 00       	jmp    9f14a6 <pp_parameter_insert+0x296>
  9f13d8:	44 89 09             	mov    %r9d,(%rcx)
  9f13db:	b0 01                	mov    $0x1,%al
  9f13dd:	e9 0f 01 00 00       	jmp    9f14f1 <pp_parameter_insert+0x2e1>
  9f13e2:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  9f13e6:	48 bb 00 00 20 00 10 	movabs $0x1000200000,%rbx
  9f13ed:	00 00 00 
  9f13f0:	ba 03 00 00 00       	mov    $0x3,%edx
  9f13f5:	b9 22 40 00 00       	mov    $0x4022,%ecx
  9f13fa:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  9f1400:	89 74 24 08          	mov    %esi,0x8(%rsp)
  9f1404:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  9f1409:	45 31 ff             	xor    %r15d,%r15d
  9f140c:	31 ff                	xor    %edi,%edi
  9f140e:	45 31 c9             	xor    %r9d,%r9d
  9f1411:	48 89 de             	mov    %rbx,%rsi
  9f1414:	c5 f8 77             	vzeroupper
  9f1417:	e8 64 cf dd ff       	call   7ce380 <mmap@plt>
  9f141c:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  9f1420:	74 51                	je     9f1473 <pp_parameter_insert+0x263>
  9f1422:	4c 8d b0 ff ff 20 00 	lea    0x20ffff(%rax),%r14
  9f1429:	ba 0f 00 00 00       	mov    $0xf,%edx
  9f142e:	48 89 c7             	mov    %rax,%rdi
  9f1431:	49 81 e6 00 00 e0 ff 	and    $0xffffffffffe00000,%r14
  9f1438:	4d 89 f7             	mov    %r14,%r15
  9f143b:	49 29 c7             	sub    %rax,%r15
  9f143e:	4c 89 fe             	mov    %r15,%rsi
  9f1441:	49 8d af 00 00 ff ff 	lea    -0x10000(%r15),%rbp
  9f1448:	e8 e3 ce dd ff       	call   7ce330 <madvise@plt>
  9f144d:	48 89 de             	mov    %rbx,%rsi
  9f1450:	4c 29 fe             	sub    %r15,%rsi
  9f1453:	ba 0e 00 00 00       	mov    $0xe,%edx
  9f1458:	4c 89 f7             	mov    %r14,%rdi
  9f145b:	e8 d0 ce dd ff       	call   7ce330 <madvise@plt>
  9f1460:	48 81 c3 00 00 e0 ff 	add    $0xffffffffffe00000,%rbx
  9f1467:	49 81 c6 00 00 ff ff 	add    $0xffffffffffff0000,%r14
  9f146e:	49 89 df             	mov    %rbx,%r15
  9f1471:	eb 05                	jmp    9f1478 <pp_parameter_insert+0x268>
  9f1473:	45 31 f6             	xor    %r14d,%r14d
  9f1476:	31 ed                	xor    %ebp,%ebp
  9f1478:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  9f147d:	64 4d 89 75 20       	mov    %r14,%fs:0x20(%r13)
  9f1482:	64 49 c7 45 28 00 00 	movq   $0x0,%fs:0x28(%r13)
  9f1489:	00 00 
  9f148b:	64 4d 89 7d 30       	mov    %r15,%fs:0x30(%r13)
  9f1490:	64 49 89 6d 38       	mov    %rbp,%fs:0x38(%r13)
  9f1495:	8b 74 24 08          	mov    0x8(%rsp),%esi
  9f1499:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  9f149d:	31 c0                	xor    %eax,%eax
  9f149f:	44 8b b7 88 00 00 00 	mov    0x88(%rdi),%r14d
  9f14a6:	4c 89 a7 98 00 00 00 	mov    %r12,0x98(%rdi)
  9f14ad:	48 89 87 a0 00 00 00 	mov    %rax,0xa0(%rdi)
  9f14b4:	44 89 f0             	mov    %r14d,%eax
  9f14b7:	45 85 f6             	test   %r14d,%r14d
  9f14ba:	8d 0c 00             	lea    (%rax,%rax,1),%ecx
  9f14bd:	41 be 40 00 00 00    	mov    $0x40,%r14d
  9f14c3:	44 0f 45 f1          	cmovne %ecx,%r14d
  9f14c7:	41 39 c6             	cmp    %eax,%r14d
  9f14ca:	76 1a                	jbe    9f14e6 <pp_parameter_insert+0x2d6>
  9f14cc:	49 8b 04 24          	mov    (%r12),%rax
  9f14d0:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  9f14d5:	48 8d 5c 01 07       	lea    0x7(%rcx,%rax,1),%rbx
  9f14da:	48 01 c1             	add    %rax,%rcx
  9f14dd:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
  9f14e1:	48 39 cb             	cmp    %rcx,%rbx
  9f14e4:	73 1d                	jae    9f1503 <pp_parameter_insert+0x2f3>
  9f14e6:	31 c9                	xor    %ecx,%ecx
  9f14e8:	0f b6 c1             	movzbl %cl,%eax
  9f14eb:	01 87 8c 00 00 00    	add    %eax,0x8c(%rdi)
  9f14f1:	48 83 c4 18          	add    $0x18,%rsp
  9f14f5:	5b                   	pop    %rbx
  9f14f6:	41 5c                	pop    %r12
  9f14f8:	41 5d                	pop    %r13
  9f14fa:	41 5e                	pop    %r14
  9f14fc:	41 5f                	pop    %r15
  9f14fe:	5d                   	pop    %rbp
  9f14ff:	c5 f8 77             	vzeroupper
  9f1502:	c3                   	ret
  9f1503:	4d 8b 4c 24 10       	mov    0x10(%r12),%r9
  9f1508:	49 89 d8             	mov    %rbx,%r8
  9f150b:	49 29 c0             	sub    %rax,%r8
  9f150e:	31 c9                	xor    %ecx,%ecx
  9f1510:	4d 29 c1             	sub    %r8,%r9
  9f1513:	72 d3                	jb     9f14e8 <pp_parameter_insert+0x2d8>
  9f1515:	44 89 f0             	mov    %r14d,%eax
  9f1518:	48 c1 e0 03          	shl    $0x3,%rax
  9f151c:	4c 39 c8             	cmp    %r9,%rax
  9f151f:	77 c7                	ja     9f14e8 <pp_parameter_insert+0x2d8>
  9f1521:	49 01 c0             	add    %rax,%r8
  9f1524:	4d 89 44 24 08       	mov    %r8,0x8(%r12)
  9f1529:	48 85 db             	test   %rbx,%rbx
  9f152c:	74 b8                	je     9f14e6 <pp_parameter_insert+0x2d6>
  9f152e:	49 89 ff             	mov    %rdi,%r15
  9f1531:	89 f5                	mov    %esi,%ebp
  9f1533:	41 89 d4             	mov    %edx,%r12d
  9f1536:	48 89 df             	mov    %rbx,%rdi
  9f1539:	31 f6                	xor    %esi,%esi
  9f153b:	48 89 c2             	mov    %rax,%rdx
  9f153e:	c5 f8 77             	vzeroupper
  9f1541:	e8 2a cc dd ff       	call   7ce170 <memset@plt>
  9f1546:	31 c0                	xor    %eax,%eax
  9f1548:	49 83 bf 80 00 00 00 	cmpq   $0x0,0x80(%r15)
  9f154f:	00 
  9f1550:	44 89 e2             	mov    %r12d,%edx
  9f1553:	89 ee                	mov    %ebp,%esi
  9f1555:	4c 89 ff             	mov    %r15,%rdi
  9f1558:	0f 94 c0             	sete   %al
  9f155b:	45 8b 84 87 88 00 00 	mov    0x88(%r15,%rax,4),%r8d
  9f1562:	00 
  9f1563:	4d 85 c0             	test   %r8,%r8
  9f1566:	0f 84 79 01 00 00    	je     9f16e5 <pp_parameter_insert+0x4d5>
  9f156c:	48 b8 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%rax
  9f1573:	79 37 9e 
  9f1576:	41 8d 4e ff          	lea    -0x1(%r14),%ecx
  9f157a:	41 83 f8 01          	cmp    $0x1,%r8d
  9f157e:	75 08                	jne    9f1588 <pp_parameter_insert+0x378>
  9f1580:	45 31 c9             	xor    %r9d,%r9d
  9f1583:	e9 ff 00 00 00       	jmp    9f1687 <pp_parameter_insert+0x477>
  9f1588:	45 89 c2             	mov    %r8d,%r10d
  9f158b:	41 83 e2 fe          	and    $0xfffffffe,%r10d
  9f158f:	45 31 c9             	xor    %r9d,%r9d
  9f1592:	eb 11                	jmp    9f15a5 <pp_parameter_insert+0x395>
  9f1594:	4e 89 1c fb          	mov    %r11,(%rbx,%r15,8)
  9f1598:	49 83 c1 02          	add    $0x2,%r9
  9f159c:	4d 39 d1             	cmp    %r10,%r9
  9f159f:	0f 84 dc 00 00 00    	je     9f1681 <pp_parameter_insert+0x471>
  9f15a5:	4c 8b 9f 80 00 00 00 	mov    0x80(%rdi),%r11
  9f15ac:	4d 85 db             	test   %r11,%r11
  9f15af:	74 0b                	je     9f15bc <pp_parameter_insert+0x3ac>
  9f15b1:	4f 8b 1c cb          	mov    (%r11,%r9,8),%r11
  9f15b5:	4d 85 db             	test   %r11,%r11
  9f15b8:	75 15                	jne    9f15cf <pp_parameter_insert+0x3bf>
  9f15ba:	eb 50                	jmp    9f160c <pp_parameter_insert+0x3fc>
  9f15bc:	46 8b 3c 8f          	mov    (%rdi,%r9,4),%r15d
  9f15c0:	46 8b 5c 8f 40       	mov    0x40(%rdi,%r9,4),%r11d
  9f15c5:	49 c1 e7 20          	shl    $0x20,%r15
  9f15c9:	49 ff c3             	inc    %r11
  9f15cc:	4d 09 fb             	or     %r15,%r11
  9f15cf:	4d 89 dc             	mov    %r11,%r12
  9f15d2:	49 c1 ec 20          	shr    $0x20,%r12
  9f15d6:	4d 89 e7             	mov    %r12,%r15
  9f15d9:	4c 0f af f8          	imul   %rax,%r15
  9f15dd:	49 c1 ef 20          	shr    $0x20,%r15
  9f15e1:	41 21 cf             	and    %ecx,%r15d
  9f15e4:	4e 8b 2c fb          	mov    (%rbx,%r15,8),%r13
  9f15e8:	4d 85 ed             	test   %r13,%r13
  9f15eb:	74 1b                	je     9f1608 <pp_parameter_insert+0x3f8>
  9f15ed:	0f 1f 00             	nopl   (%rax)
  9f15f0:	49 c1 ed 20          	shr    $0x20,%r13
  9f15f4:	45 39 ec             	cmp    %r13d,%r12d
  9f15f7:	74 0f                	je     9f1608 <pp_parameter_insert+0x3f8>
  9f15f9:	41 ff c7             	inc    %r15d
  9f15fc:	41 21 cf             	and    %ecx,%r15d
  9f15ff:	4e 8b 2c fb          	mov    (%rbx,%r15,8),%r13
  9f1603:	4d 85 ed             	test   %r13,%r13
  9f1606:	75 e8                	jne    9f15f0 <pp_parameter_insert+0x3e0>
  9f1608:	4e 89 1c fb          	mov    %r11,(%rbx,%r15,8)
  9f160c:	4c 8b bf 80 00 00 00 	mov    0x80(%rdi),%r15
  9f1613:	4d 8d 59 01          	lea    0x1(%r9),%r11
  9f1617:	4d 85 ff             	test   %r15,%r15
  9f161a:	74 0e                	je     9f162a <pp_parameter_insert+0x41a>
  9f161c:	4f 8b 1c df          	mov    (%r15,%r11,8),%r11
  9f1620:	4d 85 db             	test   %r11,%r11
  9f1623:	75 18                	jne    9f163d <pp_parameter_insert+0x42d>
  9f1625:	e9 6e ff ff ff       	jmp    9f1598 <pp_parameter_insert+0x388>
  9f162a:	46 8b 3c 9f          	mov    (%rdi,%r11,4),%r15d
  9f162e:	46 8b 5c 9f 40       	mov    0x40(%rdi,%r11,4),%r11d
  9f1633:	49 c1 e7 20          	shl    $0x20,%r15
  9f1637:	49 ff c3             	inc    %r11
  9f163a:	4d 09 fb             	or     %r15,%r11
  9f163d:	4d 89 dc             	mov    %r11,%r12
  9f1640:	49 c1 ec 20          	shr    $0x20,%r12
  9f1644:	4d 89 e7             	mov    %r12,%r15
  9f1647:	4c 0f af f8          	imul   %rax,%r15
  9f164b:	49 c1 ef 20          	shr    $0x20,%r15
  9f164f:	41 21 cf             	and    %ecx,%r15d
  9f1652:	4e 8b 2c fb          	mov    (%rbx,%r15,8),%r13
  9f1656:	4d 85 ed             	test   %r13,%r13
  9f1659:	0f 84 35 ff ff ff    	je     9f1594 <pp_parameter_insert+0x384>
  9f165f:	90                   	nop
  9f1660:	49 c1 ed 20          	shr    $0x20,%r13
  9f1664:	45 39 ec             	cmp    %r13d,%r12d
  9f1667:	0f 84 27 ff ff ff    	je     9f1594 <pp_parameter_insert+0x384>
  9f166d:	41 ff c7             	inc    %r15d
  9f1670:	41 21 cf             	and    %ecx,%r15d
  9f1673:	4e 8b 2c fb          	mov    (%rbx,%r15,8),%r13
  9f1677:	4d 85 ed             	test   %r13,%r13
  9f167a:	75 e4                	jne    9f1660 <pp_parameter_insert+0x450>
  9f167c:	e9 13 ff ff ff       	jmp    9f1594 <pp_parameter_insert+0x384>
  9f1681:	41 f6 c0 01          	test   $0x1,%r8b
  9f1685:	74 5e                	je     9f16e5 <pp_parameter_insert+0x4d5>
  9f1687:	4c 8b 87 80 00 00 00 	mov    0x80(%rdi),%r8
  9f168e:	4d 85 c0             	test   %r8,%r8
  9f1691:	74 0b                	je     9f169e <pp_parameter_insert+0x48e>
  9f1693:	4f 8b 04 c8          	mov    (%r8,%r9,8),%r8
  9f1697:	4d 85 c0             	test   %r8,%r8
  9f169a:	75 15                	jne    9f16b1 <pp_parameter_insert+0x4a1>
  9f169c:	eb 47                	jmp    9f16e5 <pp_parameter_insert+0x4d5>
  9f169e:	46 8b 14 8f          	mov    (%rdi,%r9,4),%r10d
  9f16a2:	46 8b 44 8f 40       	mov    0x40(%rdi,%r9,4),%r8d
  9f16a7:	49 c1 e2 20          	shl    $0x20,%r10
  9f16ab:	49 ff c0             	inc    %r8
  9f16ae:	4d 09 d0             	or     %r10,%r8
  9f16b1:	4d 89 c1             	mov    %r8,%r9
  9f16b4:	49 c1 e9 20          	shr    $0x20,%r9
  9f16b8:	49 0f af c1          	imul   %r9,%rax
  9f16bc:	48 c1 e8 20          	shr    $0x20,%rax
  9f16c0:	21 c8                	and    %ecx,%eax
  9f16c2:	4c 8b 14 c3          	mov    (%rbx,%rax,8),%r10
  9f16c6:	4d 85 d2             	test   %r10,%r10
  9f16c9:	74 16                	je     9f16e1 <pp_parameter_insert+0x4d1>
  9f16cb:	49 c1 ea 20          	shr    $0x20,%r10
  9f16cf:	45 39 d1             	cmp    %r10d,%r9d
  9f16d2:	74 0d                	je     9f16e1 <pp_parameter_insert+0x4d1>
  9f16d4:	ff c0                	inc    %eax
  9f16d6:	21 c8                	and    %ecx,%eax
  9f16d8:	4c 8b 14 c3          	mov    (%rbx,%rax,8),%r10
  9f16dc:	4d 85 d2             	test   %r10,%r10
  9f16df:	75 ea                	jne    9f16cb <pp_parameter_insert+0x4bb>
  9f16e1:	4c 89 04 c3          	mov    %r8,(%rbx,%rax,8)
  9f16e5:	48 89 9f 80 00 00 00 	mov    %rbx,0x80(%rdi)
  9f16ec:	44 89 b7 88 00 00 00 	mov    %r14d,0x88(%rdi)
  9f16f3:	e9 54 fc ff ff       	jmp    9f134c <pp_parameter_insert+0x13c>
