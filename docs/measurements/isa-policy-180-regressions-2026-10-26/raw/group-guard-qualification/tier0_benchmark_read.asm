
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000018d1340 <tier0_benchmark_read>:
 18d1340:	55                   	push   %rbp
 18d1341:	41 56                	push   %r14
 18d1343:	53                   	push   %rbx
 18d1344:	48 83 ec 20          	sub    $0x20,%rsp
 18d1348:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18d1351:	89 d5                	mov    %edx,%ebp
 18d1353:	49 89 f6             	mov    %rsi,%r14
 18d1356:	48 89 fb             	mov    %rdi,%rbx
 18d1359:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
 18d135e:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 18d1367:	45 85 f6             	test   %r14d,%r14d
 18d136a:	78 31                	js     18d139d <tier0_benchmark_read+0x5d>
 18d136c:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 18d1371:	ba 08 00 00 00       	mov    $0x8,%edx
 18d1376:	44 89 f7             	mov    %r14d,%edi
 18d1379:	e8 f2 2a e9 fe       	call   763e70 <read@plt>
 18d137e:	48 83 f8 08          	cmp    $0x8,%rax
 18d1382:	75 19                	jne    18d139d <tier0_benchmark_read+0x5d>
 18d1384:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18d1389:	48 89 43 08          	mov    %rax,0x8(%rbx)
 18d138d:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 18d1396:	4d 85 f6             	test   %r14,%r14
 18d1399:	79 16                	jns    18d13b1 <tier0_benchmark_read+0x71>
 18d139b:	eb 48                	jmp    18d13e5 <tier0_benchmark_read+0xa5>
 18d139d:	31 c0                	xor    %eax,%eax
 18d139f:	48 89 43 08          	mov    %rax,0x8(%rbx)
 18d13a3:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 18d13ac:	4d 85 f6             	test   %r14,%r14
 18d13af:	78 34                	js     18d13e5 <tier0_benchmark_read+0xa5>
 18d13b1:	49 c1 ee 20          	shr    $0x20,%r14
 18d13b5:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 18d13ba:	ba 08 00 00 00       	mov    $0x8,%edx
 18d13bf:	44 89 f7             	mov    %r14d,%edi
 18d13c2:	e8 a9 2a e9 fe       	call   763e70 <read@plt>
 18d13c7:	48 83 f8 08          	cmp    $0x8,%rax
 18d13cb:	75 18                	jne    18d13e5 <tier0_benchmark_read+0xa5>
 18d13cd:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18d13d2:	48 89 43 10          	mov    %rax,0x10(%rbx)
 18d13d6:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 18d13df:	85 ed                	test   %ebp,%ebp
 18d13e1:	79 15                	jns    18d13f8 <tier0_benchmark_read+0xb8>
 18d13e3:	eb 31                	jmp    18d1416 <tier0_benchmark_read+0xd6>
 18d13e5:	31 c0                	xor    %eax,%eax
 18d13e7:	48 89 43 10          	mov    %rax,0x10(%rbx)
 18d13eb:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 18d13f4:	85 ed                	test   %ebp,%ebp
 18d13f6:	78 1e                	js     18d1416 <tier0_benchmark_read+0xd6>
 18d13f8:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 18d13fd:	ba 08 00 00 00       	mov    $0x8,%edx
 18d1402:	89 ef                	mov    %ebp,%edi
 18d1404:	e8 67 2a e9 fe       	call   763e70 <read@plt>
 18d1409:	48 83 f8 08          	cmp    $0x8,%rax
 18d140d:	75 07                	jne    18d1416 <tier0_benchmark_read+0xd6>
 18d140f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18d1414:	eb 02                	jmp    18d1418 <tier0_benchmark_read+0xd8>
 18d1416:	31 c0                	xor    %eax,%eax
 18d1418:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 18d141d:	bf 04 00 00 00       	mov    $0x4,%edi
 18d1422:	48 89 43 18          	mov    %rax,0x18(%rbx)
 18d1426:	e8 85 26 e9 fe       	call   763ab0 <clock_gettime@plt>
 18d142b:	48 69 44 24 08 00 ca 9a 3b 	imul   $0x3b9aca00,0x8(%rsp),%rax
 18d1434:	48 03 44 24 10       	add    0x10(%rsp),%rax
 18d1439:	48 89 03             	mov    %rax,(%rbx)
 18d143c:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18d1445:	48 3b 44 24 18       	cmp    0x18(%rsp),%rax
 18d144a:	75 09                	jne    18d1455 <tier0_benchmark_read+0x115>
 18d144c:	48 83 c4 20          	add    $0x20,%rsp
 18d1450:	5b                   	pop    %rbx
 18d1451:	41 5e                	pop    %r14
 18d1453:	5d                   	pop    %rbp
 18d1454:	c3                   	ret
 18d1455:	e8 86 26 e9 fe       	call   763ae0 <__stack_chk_fail@plt>
