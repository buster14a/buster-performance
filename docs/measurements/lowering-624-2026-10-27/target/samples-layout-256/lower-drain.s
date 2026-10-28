
/home/david/buster-fast-bench/issue624/placements-layout/compiler-256:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008c2030 <check_lower_drain>:
  8c2030:	55                   	push   %rbp
  8c2031:	41 57                	push   %r15
  8c2033:	41 56                	push   %r14
  8c2035:	41 55                	push   %r13
  8c2037:	41 54                	push   %r12
  8c2039:	53                   	push   %rbx
  8c203a:	48 81 ec 08 02 00 00 	sub    $0x208,%rsp
  8c2041:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c2048:	00 00 
  8c204a:	49 89 fa             	mov    %rdi,%r10
  8c204d:	45 31 e4             	xor    %r12d,%r12d
  8c2050:	48 89 84 24 00 02 00 	mov    %rax,0x200(%rsp)
  8c2057:	00 
  8c2058:	8b bf 3c 01 00 00    	mov    0x13c(%rdi),%edi
  8c205e:	85 ff                	test   %edi,%edi
  8c2060:	0f 84 04 3e 00 00    	je     8c5e6a <check_lower_drain+0x3e3a>
  8c2066:	4c 89 54 24 20       	mov    %r10,0x20(%rsp)
  8c206b:	eb 2d                	jmp    8c209a <check_lower_drain+0x6a>
  8c206d:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c2072:	41 0f b6 d0          	movzbl %r8b,%edx
  8c2076:	c5 f8 77             	vzeroupper
  8c2079:	e8 c2 de 00 00       	call   8cff40 <check_lower_region>
  8c207e:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c2083:	49 ff c4             	inc    %r12
  8c2086:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c208b:	41 8b ba 3c 01 00 00 	mov    0x13c(%r10),%edi
  8c2092:	85 ff                	test   %edi,%edi
  8c2094:	0f 84 d0 3d 00 00    	je     8c5e6a <check_lower_drain+0x3e3a>
  8c209a:	49 8b 5a 08          	mov    0x8(%r10),%rbx
  8c209e:	83 bb f0 00 00 00 00 	cmpl   $0x0,0xf0(%rbx)
  8c20a5:	0f 85 bf 3d 00 00    	jne    8c5e6a <check_lower_drain+0x3e3a>
  8c20ab:	49 8b 52 18          	mov    0x18(%r10),%rdx
  8c20af:	ff cf                	dec    %edi
  8c20b1:	49 89 f8             	mov    %rdi,%r8
  8c20b4:	41 89 ba 3c 01 00 00 	mov    %edi,0x13c(%r10)
  8c20bb:	49 c1 e0 04          	shl    $0x4,%r8
  8c20bf:	4a 8b 34 02          	mov    (%rdx,%r8,1),%rsi
  8c20c3:	42 0f b6 4c 02 05    	movzbl 0x5(%rdx,%r8,1),%ecx
  8c20c9:	42 0f b6 44 02 04    	movzbl 0x4(%rdx,%r8,1),%eax
  8c20cf:	4e 8b 74 02 08       	mov    0x8(%rdx,%r8,1),%r14
  8c20d4:	48 89 f2             	mov    %rsi,%rdx
  8c20d7:	48 c1 ea 30          	shr    $0x30,%rdx
  8c20db:	83 f8 01             	cmp    $0x1,%eax
  8c20de:	0f 87 59 0d 00 00    	ja     8c2e3d <check_lower_drain+0xe0d>
  8c20e4:	85 c0                	test   %eax,%eax
  8c20e6:	74 48                	je     8c2130 <check_lower_drain+0x100>
  8c20e8:	80 fa 0f             	cmp    $0xf,%dl
  8c20eb:	0f 82 ef 01 00 00    	jb     8c22e0 <check_lower_drain+0x2b0>
  8c20f1:	83 bb f0 00 00 00 00 	cmpl   $0x0,0xf0(%rbx)
  8c20f8:	75 91                	jne    8c208b <check_lower_drain+0x5b>
  8c20fa:	48 8d 05 01 75 dc ff 	lea    -0x238aff(%rip),%rax        # 689602 <fuzz_comment_end+0x26cbc>
  8c2101:	48 89 83 00 01 00 00 	mov    %rax,0x100(%rbx)
  8c2108:	49 8b 42 08          	mov    0x8(%r10),%rax
  8c210c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2113:	0f 85 72 ff ff ff    	jne    8c208b <check_lower_drain+0x5b>
  8c2119:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c2120:	00 00 00 
  8c2123:	e9 0a 02 00 00       	jmp    8c2332 <check_lower_drain+0x302>
  8c2128:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8c212f:	00 
  8c2130:	49 8b 02             	mov    (%r10),%rax
  8c2133:	41 89 f7             	mov    %esi,%r15d
  8c2136:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
  8c213b:	4c 8b 28             	mov    (%rax),%r13
  8c213e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8c2143:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c2147:	46 8b 0c b8          	mov    (%rax,%r15,4),%r9d
  8c214b:	4d 85 c9             	test   %r9,%r9
  8c214e:	0f 84 ec 02 00 00    	je     8c2440 <check_lower_drain+0x410>
  8c2154:	41 80 ba f8 01 00 00 	cmpb   $0x0,0x1f8(%r10)
  8c215b:	00 
  8c215c:	0f 85 de 02 00 00    	jne    8c2440 <check_lower_drain+0x410>
  8c2162:	4d 8b 92 a8 01 00 00 	mov    0x1a8(%r10),%r10
  8c2169:	4d 85 d2             	test   %r10,%r10
  8c216c:	74 61                	je     8c21cf <check_lower_drain+0x19f>
  8c216e:	89 ca                	mov    %ecx,%edx
  8c2170:	80 e2 04             	and    $0x4,%dl
  8c2173:	75 5a                	jne    8c21cf <check_lower_drain+0x19f>
  8c2175:	f6 c1 01             	test   $0x1,%cl
  8c2178:	75 55                	jne    8c21cf <check_lower_drain+0x19f>
  8c217a:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c217f:	4f 8d 04 7f          	lea    (%r15,%r15,2),%r8
  8c2183:	49 c1 e0 05          	shl    $0x5,%r8
  8c2187:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8c218b:	4c 03 42 08          	add    0x8(%rdx),%r8
  8c218f:	41 83 78 0c 00       	cmpl   $0x0,0xc(%r8)
  8c2194:	74 39                	je     8c21cf <check_lower_drain+0x19f>
  8c2196:	41 83 78 54 00       	cmpl   $0x0,0x54(%r8)
  8c219b:	75 32                	jne    8c21cf <check_lower_drain+0x19f>
  8c219d:	41 0f b7 50 08       	movzwl 0x8(%r8),%edx
  8c21a2:	f7 c2 10 08 00 00    	test   $0x810,%edx
  8c21a8:	75 25                	jne    8c21cf <check_lower_drain+0x19f>
  8c21aa:	41 83 78 04 00       	cmpl   $0x0,0x4(%r8)
  8c21af:	75 1e                	jne    8c21cf <check_lower_drain+0x19f>
  8c21b1:	41 83 f9 3e          	cmp    $0x3e,%r9d
  8c21b5:	0f 87 f0 0e 00 00    	ja     8c30ab <check_lower_drain+0x107b>
  8c21bb:	48 ba 00 00 00 00 08 	movabs $0x4080000800000000,%rdx
  8c21c2:	00 80 40 
  8c21c5:	4c 0f a3 ca          	bt     %r9,%rdx
  8c21c9:	0f 83 dc 0e 00 00    	jae    8c30ab <check_lower_drain+0x107b>
  8c21cf:	41 83 f9 35          	cmp    $0x35,%r9d
  8c21d3:	41 8d 51 ff          	lea    -0x1(%r9),%edx
  8c21d7:	49 ba 05 00 80 00 18 	movabs $0x8001800800005,%r10
  8c21de:	00 08 00 
  8c21e1:	41 0f 92 c0          	setb   %r8b
  8c21e5:	c4 42 eb f7 d2       	shrx   %rdx,%r10,%r10
  8c21ea:	45 20 c2             	and    %r8b,%r10b
  8c21ed:	41 80 fa 01          	cmp    $0x1,%r10b
  8c21f1:	75 21                	jne    8c2214 <check_lower_drain+0x1e4>
  8c21f3:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  8c21f8:	4f 8d 1c 7f          	lea    (%r15,%r15,2),%r11
  8c21fc:	49 c1 e3 05          	shl    $0x5,%r11
  8c2200:	4d 8b 50 08          	mov    0x8(%r8),%r10
  8c2204:	4d 8b 42 08          	mov    0x8(%r10),%r8
  8c2208:	43 83 7c 18 0c 00    	cmpl   $0x0,0xc(%r8,%r11,1)
  8c220e:	0f 84 66 01 00 00    	je     8c237a <check_lower_drain+0x34a>
  8c2214:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c2219:	41 80 ba f9 01 00 00 	cmpb   $0x0,0x1f9(%r10)
  8c2220:	00 
  8c2221:	0f 85 19 02 00 00    	jne    8c2440 <check_lower_drain+0x410>
  8c2227:	49 8b 92 a8 01 00 00 	mov    0x1a8(%r10),%rdx
  8c222e:	48 85 d2             	test   %rdx,%rdx
  8c2231:	0f 84 09 02 00 00    	je     8c2440 <check_lower_drain+0x410>
  8c2237:	41 89 c8             	mov    %ecx,%r8d
  8c223a:	41 80 e0 05          	and    $0x5,%r8b
  8c223e:	0f 85 fc 01 00 00    	jne    8c2440 <check_lower_drain+0x410>
  8c2244:	41 ba 00 00 00 00    	mov    $0x0,%r10d
  8c224a:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
  8c224f:	31 ed                	xor    %ebp,%ebp
  8c2251:	41 83 f9 3f          	cmp    $0x3f,%r9d
  8c2255:	77 0c                	ja     8c2263 <check_lower_drain+0x233>
  8c2257:	48 8d 15 e2 d4 bf ff 	lea    -0x402b1e(%rip),%rdx        # 4bf740 <check_lower_batch_ops>
  8c225e:	45 0f b6 14 11       	movzbl (%r9,%rdx,1),%r10d
  8c2263:	4d 8b 45 10          	mov    0x10(%r13),%r8
  8c2267:	45 8d 59 fb          	lea    -0x5(%r9),%r11d
  8c226b:	41 83 fb 10          	cmp    $0x10,%r11d
  8c226f:	41 0f 92 c6          	setb   %r14b
  8c2273:	41 81 fa ff 00 00 00 	cmp    $0xff,%r10d
  8c227a:	0f 95 c3             	setne  %bl
  8c227d:	47 8b 04 b8          	mov    (%r8,%r15,4),%r8d
  8c2281:	4c 89 c2             	mov    %r8,%rdx
  8c2284:	4c 89 44 24 48       	mov    %r8,0x48(%rsp)
  8c2289:	41 83 fb 0f          	cmp    $0xf,%r11d
  8c228d:	77 0a                	ja     8c2299 <check_lower_drain+0x269>
  8c228f:	4d 8b 45 18          	mov    0x18(%r13),%r8
  8c2293:	43 8b 14 b8          	mov    (%r8,%r15,4),%edx
  8c2297:	89 d5                	mov    %edx,%ebp
  8c2299:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
  8c229e:	48 89 6c 24 58       	mov    %rbp,0x58(%rsp)
  8c22a3:	41 8b a8 40 01 00 00 	mov    0x140(%r8),%ebp
  8c22aa:	41 b8 00 00 00 01    	mov    $0x1000000,%r8d
  8c22b0:	81 fd 00 00 00 01    	cmp    $0x1000000,%ebp
  8c22b6:	44 0f 42 c5          	cmovb  %ebp,%r8d
  8c22ba:	45 85 d2             	test   %r10d,%r10d
  8c22bd:	74 0d                	je     8c22cc <check_lower_drain+0x29c>
  8c22bf:	41 81 fa fe 00 00 00 	cmp    $0xfe,%r10d
  8c22c6:	0f 85 3e 01 00 00    	jne    8c240a <check_lower_drain+0x3da>
  8c22cc:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c22d1:	e9 6a 01 00 00       	jmp    8c2440 <check_lower_drain+0x410>
  8c22d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8c22dd:	00 00 00 
  8c22e0:	41 8b 82 38 01 00 00 	mov    0x138(%r10),%eax
  8c22e7:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  8c22ec:	77 2d                	ja     8c231b <check_lower_drain+0x2eb>
  8c22ee:	41 3b 82 40 01 00 00 	cmp    0x140(%r10),%eax
  8c22f5:	73 24                	jae    8c231b <check_lower_drain+0x2eb>
  8c22f7:	41 80 ba f9 01 00 00 	cmpb   $0x1,0x1f9(%r10)
  8c22fe:	01 
  8c22ff:	75 47                	jne    8c2348 <check_lower_drain+0x318>
  8c2301:	40 0f b6 f6          	movzbl %sil,%esi
  8c2305:	0f b6 d2             	movzbl %dl,%edx
  8c2308:	4c 89 d7             	mov    %r10,%rdi
  8c230b:	4c 89 f1             	mov    %r14,%rcx
  8c230e:	c5 f8 77             	vzeroupper
  8c2311:	e8 0a c5 01 00       	call   8de820 <check_lower_emit_tracked>
  8c2316:	e9 6b fd ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c231b:	83 bb f0 00 00 00 00 	cmpl   $0x0,0xf0(%rbx)
  8c2322:	0f 85 63 fd ff ff    	jne    8c208b <check_lower_drain+0x5b>
  8c2328:	c7 83 f0 00 00 00 03 	movl   $0x3,0xf0(%rbx)
  8c232f:	00 00 00 
  8c2332:	41 8b 82 64 01 00 00 	mov    0x164(%r10),%eax
  8c2339:	49 8b 4a 08          	mov    0x8(%r10),%rcx
  8c233d:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c2343:	e9 43 fd ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c2348:	83 bb f0 00 00 00 00 	cmpl   $0x0,0xf0(%rbx)
  8c234f:	0f 85 36 fd ff ff    	jne    8c208b <check_lower_drain+0x5b>
  8c2355:	49 8b 4a 20          	mov    0x20(%r10),%rcx
  8c2359:	40 88 34 01          	mov    %sil,(%rcx,%rax,1)
  8c235d:	49 8b 4a 28          	mov    0x28(%r10),%rcx
  8c2361:	88 14 01             	mov    %dl,(%rcx,%rax,1)
  8c2364:	49 8b 4a 30          	mov    0x30(%r10),%rcx
  8c2368:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c236c:	ff c0                	inc    %eax
  8c236e:	41 89 82 38 01 00 00 	mov    %eax,0x138(%r10)
  8c2375:	e9 11 fd ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c237a:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c237e:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c2383:	48 bf 01 00 80 00 08 	movabs $0x8000800800001,%rdi
  8c238a:	00 08 00 
  8c238d:	48 0f a3 d7          	bt     %rdx,%rdi
  8c2391:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c2395:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c239b:	73 31                	jae    8c23ce <check_lower_drain+0x39e>
  8c239d:	49 83 f9 34          	cmp    $0x34,%r9
  8c23a1:	0f 94 c0             	sete   %al
  8c23a4:	45 31 c0             	xor    %r8d,%r8d
  8c23a7:	41 83 f9 34          	cmp    $0x34,%r9d
  8c23ab:	74 08                	je     8c23b5 <check_lower_drain+0x385>
  8c23ad:	49 8b 52 08          	mov    0x8(%r10),%rdx
  8c23b1:	46 8b 04 1a          	mov    (%rdx,%r11,1),%r8d
  8c23b5:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c23ba:	20 c8                	and    %cl,%al
  8c23bc:	31 d2                	xor    %edx,%edx
  8c23be:	0f b6 c8             	movzbl %al,%ecx
  8c23c1:	c5 f8 77             	vzeroupper
  8c23c4:	e8 f7 d4 00 00       	call   8cf8c0 <check_lower_operand>
  8c23c9:	e9 b5 fc ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c23ce:	49 8b 42 10          	mov    0x10(%r10),%rax
  8c23d2:	31 d2                	xor    %edx,%edx
  8c23d4:	41 83 f9 03          	cmp    $0x3,%r9d
  8c23d8:	48 89 df             	mov    %rbx,%rdi
  8c23db:	49 89 f6             	mov    %rsi,%r14
  8c23de:	0f 94 c2             	sete   %dl
  8c23e1:	49 c1 e7 05          	shl    $0x5,%r15
  8c23e5:	42 8b 2c 38          	mov    (%rax,%r15,1),%ebp
  8c23e9:	89 ee                	mov    %ebp,%esi
  8c23eb:	c5 f8 77             	vzeroupper
  8c23ee:	e8 1d d7 00 00       	call   8cfb10 <check_lower_truth>
  8c23f3:	48 89 df             	mov    %rbx,%rdi
  8c23f6:	44 89 f6             	mov    %r14d,%esi
  8c23f9:	31 d2                	xor    %edx,%edx
  8c23fb:	31 c9                	xor    %ecx,%ecx
  8c23fd:	41 89 e8             	mov    %ebp,%r8d
  8c2400:	e8 bb d4 00 00       	call   8cf8c0 <check_lower_operand>
  8c2405:	e9 79 fc ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c240a:	4c 8b 54 24 40       	mov    0x40(%rsp),%r10
  8c240f:	89 54 24 60          	mov    %edx,0x60(%rsp)
  8c2413:	44 89 5c 24 3c       	mov    %r11d,0x3c(%rsp)
  8c2418:	4f 8d 1c 7f          	lea    (%r15,%r15,2),%r11
  8c241c:	49 c1 e3 05          	shl    $0x5,%r11
  8c2420:	4d 8b 62 08          	mov    0x8(%r10),%r12
  8c2424:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c2429:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
  8c242e:	49 01 d3             	add    %rdx,%r11
  8c2431:	41 83 7b 44 00       	cmpl   $0x0,0x44(%r11)
  8c2436:	0f 84 84 06 00 00    	je     8c2ac0 <check_lower_drain+0xa90>
  8c243c:	0f 1f 40 00          	nopl   0x0(%rax)
  8c2440:	4d 89 ec             	mov    %r13,%r12
  8c2443:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8c2448:	4b 8d 3c 7f          	lea    (%r15,%r15,2),%rdi
  8c244c:	45 8b 82 b0 01 00 00 	mov    0x1b0(%r10),%r8d
  8c2453:	48 c1 e7 05          	shl    $0x5,%rdi
  8c2457:	49 8b 69 08          	mov    0x8(%r9),%rbp
  8c245b:	44 89 44 24 3c       	mov    %r8d,0x3c(%rsp)
  8c2460:	4c 8b 6d 08          	mov    0x8(%rbp),%r13
  8c2464:	41 8b 54 3d 00       	mov    0x0(%r13,%rdi,1),%edx
  8c2469:	c1 ea 03             	shr    $0x3,%edx
  8c246c:	44 39 c2             	cmp    %r8d,%edx
  8c246f:	73 2d                	jae    8c249e <check_lower_drain+0x46e>
  8c2471:	4d 8b 82 a0 01 00 00 	mov    0x1a0(%r10),%r8
  8c2478:	45 0f b6 04 10       	movzbl (%r8,%rdx,1),%r8d
  8c247d:	44 89 c3             	mov    %r8d,%ebx
  8c2480:	80 e3 04             	and    $0x4,%bl
  8c2483:	c0 eb 02             	shr    $0x2,%bl
  8c2486:	41 f6 c0 01          	test   $0x1,%r8b
  8c248a:	74 18                	je     8c24a4 <check_lower_drain+0x474>
  8c248c:	b2 08                	mov    $0x8,%dl
  8c248e:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
  8c2493:	b2 01                	mov    $0x1,%dl
  8c2495:	89 94 24 88 00 00 00 	mov    %edx,0x88(%rsp)
  8c249c:	eb 22                	jmp    8c24c0 <check_lower_drain+0x490>
  8c249e:	b2 ff                	mov    $0xff,%dl
  8c24a0:	31 db                	xor    %ebx,%ebx
  8c24a2:	eb 0c                	jmp    8c24b0 <check_lower_drain+0x480>
  8c24a4:	4d 8b 82 98 01 00 00 	mov    0x198(%r10),%r8
  8c24ab:	41 0f b6 14 10       	movzbl (%r8,%rdx,1),%edx
  8c24b0:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
  8c24b5:	c7 84 24 88 00 00 00 	movl   $0x0,0x88(%rsp)
  8c24bc:	00 00 00 00 
  8c24c0:	49 8b 51 10          	mov    0x10(%r9),%rdx
  8c24c4:	49 01 fd             	add    %rdi,%r13
  8c24c7:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
  8c24cc:	4d 8b 44 24 18       	mov    0x18(%r12),%r8
  8c24d1:	46 8b 1c b8          	mov    (%rax,%r15,4),%r11d
  8c24d5:	48 8b 45 10          	mov    0x10(%rbp),%rax
  8c24d9:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  8c24de:	42 8b 14 bf          	mov    (%rdi,%r15,4),%edx
  8c24e2:	4c 89 ff             	mov    %r15,%rdi
  8c24e5:	48 c1 e7 05          	shl    $0x5,%rdi
  8c24e9:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  8c24ee:	43 8b 14 b8          	mov    (%r8,%r15,4),%edx
  8c24f2:	48 89 94 24 80 00 00 	mov    %rdx,0x80(%rsp)
  8c24f9:	00 
  8c24fa:	8b 14 38             	mov    (%rax,%rdi,1),%edx
  8c24fd:	8b 44 38 08          	mov    0x8(%rax,%rdi,1),%eax
  8c2501:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  8c2506:	49 8b 44 24 08       	mov    0x8(%r12),%rax
  8c250b:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  8c2510:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c2514:	41 89 82 64 01 00 00 	mov    %eax,0x164(%r10)
  8c251b:	41 8b 7d 0c          	mov    0xc(%r13),%edi
  8c251f:	85 ff                	test   %edi,%edi
  8c2521:	74 07                	je     8c252a <check_lower_drain+0x4fa>
  8c2523:	41 83 7d 54 00       	cmpl   $0x0,0x54(%r13)
  8c2528:	74 05                	je     8c252f <check_lower_drain+0x4ff>
  8c252a:	45 31 c9             	xor    %r9d,%r9d
  8c252d:	eb 0c                	jmp    8c253b <check_lower_drain+0x50b>
  8c252f:	41 f7 45 08 10 08 00 	testl  $0x810,0x8(%r13)
  8c2536:	00 
  8c2537:	41 0f 94 c1          	sete   %r9b
  8c253b:	41 89 ca             	mov    %ecx,%r10d
  8c253e:	41 83 e2 02          	and    $0x2,%r10d
  8c2542:	89 c8                	mov    %ecx,%eax
  8c2544:	41 89 c8             	mov    %ecx,%r8d
  8c2547:	83 e0 04             	and    $0x4,%eax
  8c254a:	41 83 e0 01          	and    $0x1,%r8d
  8c254e:	45 09 da             	or     %r11d,%r10d
  8c2551:	74 0f                	je     8c2562 <check_lower_drain+0x532>
  8c2553:	4d 89 de             	mov    %r11,%r14
  8c2556:	41 83 fb 37          	cmp    $0x37,%r11d
  8c255a:	0f 84 0d fb ff ff    	je     8c206d <check_lower_drain+0x3d>
  8c2560:	eb 4e                	jmp    8c25b0 <check_lower_drain+0x580>
  8c2562:	45 8b 55 40          	mov    0x40(%r13),%r10d
  8c2566:	4d 89 de             	mov    %r11,%r14
  8c2569:	45 85 d2             	test   %r10d,%r10d
  8c256c:	74 42                	je     8c25b0 <check_lower_drain+0x580>
  8c256e:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c2573:	44 3b 92 c0 00 00 00 	cmp    0xc0(%rdx),%r10d
  8c257a:	73 34                	jae    8c25b0 <check_lower_drain+0x580>
  8c257c:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c2581:	41 ff ca             	dec    %r10d
  8c2584:	4c 8b 1a             	mov    (%rdx),%r11
  8c2587:	49 8b 93 90 02 00 00 	mov    0x290(%r11),%rdx
  8c258e:	42 80 3c 12 00       	cmpb   $0x0,(%rdx,%r10,1)
  8c2593:	74 1b                	je     8c25b0 <check_lower_drain+0x580>
  8c2595:	49 8b 93 78 02 00 00 	mov    0x278(%r11),%rdx
  8c259c:	42 80 3c 12 00       	cmpb   $0x0,(%rdx,%r10,1)
  8c25a1:	0f 84 ae 03 00 00    	je     8c2955 <check_lower_drain+0x925>
  8c25a7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8c25ae:	00 00 
  8c25b0:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  8c25b5:	4d 89 f3             	mov    %r14,%r11
  8c25b8:	45 84 c9             	test   %r9b,%r9b
  8c25bb:	74 50                	je     8c260d <check_lower_drain+0x5dd>
  8c25bd:	41 83 fb 23          	cmp    $0x23,%r11d
  8c25c1:	0f 84 8a 00 00 00    	je     8c2651 <check_lower_drain+0x621>
  8c25c7:	41 83 fb 3e          	cmp    $0x3e,%r11d
  8c25cb:	0f 84 80 00 00 00    	je     8c2651 <check_lower_drain+0x621>
  8c25d1:	41 83 7d 04 00       	cmpl   $0x0,0x4(%r13)
  8c25d6:	75 05                	jne    8c25dd <check_lower_drain+0x5ad>
  8c25d8:	f6 c1 01             	test   $0x1,%cl
  8c25db:	74 0e                	je     8c25eb <check_lower_drain+0x5bb>
  8c25dd:	89 da                	mov    %ebx,%edx
  8c25df:	08 ca                	or     %cl,%dl
  8c25e1:	f6 c2 01             	test   $0x1,%dl
  8c25e4:	74 27                	je     8c260d <check_lower_drain+0x5dd>
  8c25e6:	83 ff 03             	cmp    $0x3,%edi
  8c25e9:	75 22                	jne    8c260d <check_lower_drain+0x5dd>
  8c25eb:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c25f0:	85 c0                	test   %eax,%eax
  8c25f2:	0f 85 8b fa ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c25f8:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c25fd:	4c 89 ee             	mov    %r13,%rsi
  8c2600:	c5 f8 77             	vzeroupper
  8c2603:	e8 d8 89 00 00       	call   8cafe0 <check_lower_constant>
  8c2608:	e9 76 fa ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c260d:	41 83 fb 34          	cmp    $0x34,%r11d
  8c2611:	0f 84 8d 01 00 00    	je     8c27a4 <check_lower_drain+0x774>
  8c2617:	45 85 db             	test   %r11d,%r11d
  8c261a:	75 35                	jne    8c2651 <check_lower_drain+0x621>
  8c261c:	41 83 7d 00 08       	cmpl   $0x8,0x0(%r13)
  8c2621:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c2626:	0f 84 57 fa ff ff    	je     8c2083 <check_lower_drain+0x53>
  8c262c:	41 8b 75 40          	mov    0x40(%r13),%esi
  8c2630:	08 cb                	or     %cl,%bl
  8c2632:	f6 c3 01             	test   $0x1,%bl
  8c2635:	0f 84 a3 02 00 00    	je     8c28de <check_lower_drain+0x8ae>
  8c263b:	49 8b 55 48          	mov    0x48(%r13),%rdx
  8c263f:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c2644:	c5 f8 77             	vzeroupper
  8c2647:	e8 e4 96 00 00       	call   8cbd30 <check_lower_address>
  8c264c:	e9 32 fa ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c2651:	45 89 da             	mov    %r11d,%r10d
  8c2654:	41 83 e2 fe          	and    $0xfffffffe,%r10d
  8c2658:	41 83 fa 40          	cmp    $0x40,%r10d
  8c265c:	75 63                	jne    8c26c1 <check_lower_drain+0x691>
  8c265e:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c2663:	4c 8b 55 08          	mov    0x8(%rbp),%r10
  8c2667:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
  8c266c:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c2671:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8c2675:	4c 8b 03             	mov    (%rbx),%r8
  8c2678:	48 c1 e0 05          	shl    $0x5,%rax
  8c267c:	41 8b 14 02          	mov    (%r10,%rax,1),%edx
  8c2680:	c1 ea 03             	shr    $0x3,%edx
  8c2683:	41 80 3c 10 0f       	cmpb   $0xf,(%r8,%rdx,1)
  8c2688:	49 89 d1             	mov    %rdx,%r9
  8c268b:	75 0c                	jne    8c2699 <check_lower_drain+0x669>
  8c268d:	4c 8b 4b 20          	mov    0x20(%rbx),%r9
  8c2691:	45 8b 0c 91          	mov    (%r9,%rdx,4),%r9d
  8c2695:	41 c1 e9 03          	shr    $0x3,%r9d
  8c2699:	47 0f b6 04 08       	movzbl (%r8,%r9,1),%r8d
  8c269e:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c26a3:	41 80 f8 06          	cmp    $0x6,%r8b
  8c26a7:	0f 84 06 01 00 00    	je     8c27b3 <check_lower_drain+0x783>
  8c26ad:	41 83 fb 40          	cmp    $0x40,%r11d
  8c26b1:	0f 85 fc 00 00 00    	jne    8c27b3 <check_lower_drain+0x783>
  8c26b7:	83 e1 01             	and    $0x1,%ecx
  8c26ba:	31 d2                	xor    %edx,%edx
  8c26bc:	e9 62 06 00 00       	jmp    8c2d23 <check_lower_drain+0xcf3>
  8c26c1:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c26c6:	41 8d 53 c7          	lea    -0x39(%r11),%edx
  8c26ca:	83 fa 01             	cmp    $0x1,%edx
  8c26cd:	0f 87 33 01 00 00    	ja     8c2806 <check_lower_drain+0x7d6>
  8c26d3:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  8c26d8:	42 8b 1c b8          	mov    (%rax,%r15,4),%ebx
  8c26dc:	85 db                	test   %ebx,%ebx
  8c26de:	0f 84 43 01 00 00    	je     8c2827 <check_lower_drain+0x7f7>
  8c26e4:	49 8b 00             	mov    (%r8),%rax
  8c26e7:	3b 98 58 03 00 00    	cmp    0x358(%rax),%ebx
  8c26ed:	0f 87 34 01 00 00    	ja     8c2827 <check_lower_drain+0x7f7>
  8c26f3:	48 8b 80 50 03 00 00 	mov    0x350(%rax),%rax
  8c26fa:	48 8b 97 80 01 00 00 	mov    0x180(%rdi),%rdx
  8c2701:	ff cb                	dec    %ebx
  8c2703:	48 8d 0c db          	lea    (%rbx,%rbx,8),%rcx
  8c2707:	8b 44 88 14          	mov    0x14(%rax,%rcx,4),%eax
  8c270b:	3b 42 04             	cmp    0x4(%rdx),%eax
  8c270e:	0f 85 13 01 00 00    	jne    8c2827 <check_lower_drain+0x7f7>
  8c2714:	48 8b 87 98 00 00 00 	mov    0x98(%rdi),%rax
  8c271b:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c2720:	83 3c 98 ff          	cmpl   $0xffffffff,(%rax,%rbx,4)
  8c2724:	75 28                	jne    8c274e <check_lower_drain+0x71e>
  8c2726:	49 89 f6             	mov    %rsi,%r14
  8c2729:	be 08 00 00 00       	mov    $0x8,%esi
  8c272e:	4d 89 df             	mov    %r11,%r15
  8c2731:	c5 f8 77             	vzeroupper
  8c2734:	e8 f7 bd ff ff       	call   8be530 <check_lower_temporary>
  8c2739:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c273e:	4d 89 fb             	mov    %r15,%r11
  8c2741:	4c 89 f6             	mov    %r14,%rsi
  8c2744:	48 8b 8f 98 00 00 00 	mov    0x98(%rdi),%rcx
  8c274b:	89 04 99             	mov    %eax,(%rcx,%rbx,4)
  8c274e:	8b 87 3c 01 00 00    	mov    0x13c(%rdi),%eax
  8c2754:	3b 87 40 01 00 00    	cmp    0x140(%rdi),%eax
  8c275a:	0f 83 d3 05 00 00    	jae    8c2d33 <check_lower_drain+0xd03>
  8c2760:	4c 8b 8f 98 00 00 00 	mov    0x98(%rdi),%r9
  8c2767:	49 b8 01 00 00 00 01 	movabs $0x8000100000001,%r8
  8c276e:	00 08 00 
  8c2771:	8d 48 01             	lea    0x1(%rax),%ecx
  8c2774:	48 c1 e0 04          	shl    $0x4,%rax
  8c2778:	41 83 fb 39          	cmp    $0x39,%r11d
  8c277c:	49 8d 50 01          	lea    0x1(%r8),%rdx
  8c2780:	4d 8d 50 1d          	lea    0x1d(%r8),%r10
  8c2784:	4c 8b 47 18          	mov    0x18(%rdi),%r8
  8c2788:	49 0f 44 d2          	cmove  %r10,%rdx
  8c278c:	45 8b 0c 99          	mov    (%r9,%rbx,4),%r9d
  8c2790:	89 8f 3c 01 00 00    	mov    %ecx,0x13c(%rdi)
  8c2796:	49 89 14 00          	mov    %rdx,(%r8,%rax,1)
  8c279a:	4d 89 4c 00 08       	mov    %r9,0x8(%r8,%rax,1)
  8c279f:	e9 b6 05 00 00       	jmp    8c2d5a <check_lower_drain+0xd2a>
  8c27a4:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c27a9:	83 e1 01             	and    $0x1,%ecx
  8c27ac:	31 d2                	xor    %edx,%edx
  8c27ae:	45 31 c0             	xor    %r8d,%r8d
  8c27b1:	eb 67                	jmp    8c281a <check_lower_drain+0x7ea>
  8c27b3:	41 80 f8 06          	cmp    $0x6,%r8b
  8c27b7:	0f 84 a4 00 00 00    	je     8c2861 <check_lower_drain+0x831>
  8c27bd:	8b 87 3c 01 00 00    	mov    0x13c(%rdi),%eax
  8c27c3:	3b 87 40 01 00 00    	cmp    0x140(%rdi),%eax
  8c27c9:	0f 83 07 02 00 00    	jae    8c29d6 <check_lower_drain+0x9a6>
  8c27cf:	8d 50 01             	lea    0x1(%rax),%edx
  8c27d2:	48 8b 4f 18          	mov    0x18(%rdi),%rcx
  8c27d6:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  8c27dc:	48 c1 e0 04          	shl    $0x4,%rax
  8c27e0:	89 97 3c 01 00 00    	mov    %edx,0x13c(%rdi)
  8c27e6:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c27eb:	48 c1 e2 30          	shl    $0x30,%rdx
  8c27ef:	4a 8d 54 02 02       	lea    0x2(%rdx,%r8,1),%rdx
  8c27f4:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c27f8:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c27ff:	00 00 
  8c2801:	e9 f7 01 00 00       	jmp    8c29fd <check_lower_drain+0x9cd>
  8c2806:	41 83 fb 3b          	cmp    $0x3b,%r11d
  8c280a:	0f 85 b4 00 00 00    	jne    8c28c4 <check_lower_drain+0x894>
  8c2810:	31 d2                	xor    %edx,%edx
  8c2812:	31 c9                	xor    %ecx,%ecx
  8c2814:	41 b8 58 00 00 00    	mov    $0x58,%r8d
  8c281a:	c5 f8 77             	vzeroupper
  8c281d:	e8 9e d0 00 00       	call   8cf8c0 <check_lower_operand>
  8c2822:	e9 57 f8 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c2827:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c282b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2832:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c2837:	0f 85 46 f8 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c283d:	c7 80 f0 00 00 00 01 	movl   $0x1,0xf0(%rax)
  8c2844:	00 00 00 
  8c2847:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c284c:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c2852:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c2856:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c285c:	e9 22 f8 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c2861:	49 01 c2             	add    %rax,%r10
  8c2864:	41 83 7a 04 01       	cmpl   $0x1,0x4(%r10)
  8c2869:	0f 85 a5 01 00 00    	jne    8c2a14 <check_lower_drain+0x9e4>
  8c286f:	f6 c1 01             	test   $0x1,%cl
  8c2872:	0f 85 a8 03 00 00    	jne    8c2c20 <check_lower_drain+0xbf0>
  8c2878:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8c287e:	3b 8f 40 01 00 00    	cmp    0x140(%rdi),%ecx
  8c2884:	0f 83 6e 03 00 00    	jae    8c2bf8 <check_lower_drain+0xbc8>
  8c288a:	44 8d 41 01          	lea    0x1(%rcx),%r8d
  8c288e:	4c 8b 4f 18          	mov    0x18(%rdi),%r9
  8c2892:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
  8c2898:	48 c1 e1 04          	shl    $0x4,%rcx
  8c289c:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c28a3:	44 0f b6 44 24 50    	movzbl 0x50(%rsp),%r8d
  8c28a9:	49 c1 e0 30          	shl    $0x30,%r8
  8c28ad:	4f 8d 44 10 0b       	lea    0xb(%r8,%r10,1),%r8
  8c28b2:	4d 89 04 09          	mov    %r8,(%r9,%rcx,1)
  8c28b6:	49 c7 44 09 08 00 00 	movq   $0x0,0x8(%r9,%rcx,1)
  8c28bd:	00 00 
  8c28bf:	e9 5c 03 00 00       	jmp    8c2c20 <check_lower_drain+0xbf0>
  8c28c4:	41 8d 53 cb          	lea    -0x35(%r11),%edx
  8c28c8:	83 fa 01             	cmp    $0x1,%edx
  8c28cb:	0f 87 75 01 00 00    	ja     8c2a46 <check_lower_drain+0xa16>
  8c28d1:	c5 f8 77             	vzeroupper
  8c28d4:	e8 07 e0 00 00       	call   8d08e0 <check_lower_builtin_prepare>
  8c28d9:	e9 a0 f7 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c28de:	41 83 7d 04 01       	cmpl   $0x1,0x4(%r13)
  8c28e3:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c28e8:	0f 94 c0             	sete   %al
  8c28eb:	85 f6                	test   %esi,%esi
  8c28ed:	0f 95 c1             	setne  %cl
  8c28f0:	20 c1                	and    %al,%cl
  8c28f2:	80 f9 01             	cmp    $0x1,%cl
  8c28f5:	0f 85 81 01 00 00    	jne    8c2a7c <check_lower_drain+0xa4c>
  8c28fb:	41 8b 80 c0 00 00 00 	mov    0xc0(%r8),%eax
  8c2902:	39 c6                	cmp    %eax,%esi
  8c2904:	73 1b                	jae    8c2921 <check_lower_drain+0x8f1>
  8c2906:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8c290b:	83 c1 f5             	add    $0xfffffff5,%ecx
  8c290e:	80 f9 02             	cmp    $0x2,%cl
  8c2911:	77 0e                	ja     8c2921 <check_lower_drain+0x8f1>
  8c2913:	48 8b 4f 68          	mov    0x68(%rdi),%rcx
  8c2917:	83 3c b1 ff          	cmpl   $0xffffffff,(%rcx,%rsi,4)
  8c291b:	0f 84 ca 04 00 00    	je     8c2deb <check_lower_drain+0xdbb>
  8c2921:	39 c6                	cmp    %eax,%esi
  8c2923:	0f 83 53 01 00 00    	jae    8c2a7c <check_lower_drain+0xa4c>
  8c2929:	48 8b 47 68          	mov    0x68(%rdi),%rax
  8c292d:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c2930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c2935:	48 39 c1             	cmp    %rax,%rcx
  8c2938:	0f 84 d5 04 00 00    	je     8c2e13 <check_lower_drain+0xde3>
  8c293e:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c2943:	be 02 00 00 00       	mov    $0x2,%esi
  8c2948:	c5 f8 77             	vzeroupper
  8c294b:	e8 b0 35 00 00       	call   8c5f00 <check_lower_emit>
  8c2950:	e9 2e f7 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c2955:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c295a:	48 8b 49 28          	mov    0x28(%rcx),%rcx
  8c295e:	48 85 c9             	test   %rcx,%rcx
  8c2961:	0f 84 39 31 00 00    	je     8c5aa0 <check_lower_drain+0x3a70>
  8c2967:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  8c296b:	42 8b 14 91          	mov    (%rcx,%r10,4),%edx
  8c296f:	85 d2                	test   %edx,%edx
  8c2971:	0f 84 29 31 00 00    	je     8c5aa0 <check_lower_drain+0x3a70>
  8c2977:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c297c:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c2981:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8c2987:	3b 8f 40 01 00 00    	cmp    0x140(%rdi),%ecx
  8c298d:	0f 83 e1 03 00 00    	jae    8c2d74 <check_lower_drain+0xd44>
  8c2993:	c1 e8 02             	shr    $0x2,%eax
  8c2996:	48 8b 77 18          	mov    0x18(%rdi),%rsi
  8c299a:	49 c1 e0 28          	shl    $0x28,%r8
  8c299e:	44 8d 49 01          	lea    0x1(%rcx),%r9d
  8c29a2:	48 c1 e1 04          	shl    $0x4,%rcx
  8c29a6:	48 c1 e0 2a          	shl    $0x2a,%rax
  8c29aa:	44 89 8f 3c 01 00 00 	mov    %r9d,0x13c(%rdi)
  8c29b1:	4c 09 c0             	or     %r8,%rax
  8c29b4:	49 b8 00 00 00 00 00 	movabs $0x20000000000,%r8
  8c29bb:	02 00 00 
  8c29be:	4c 09 f8             	or     %r15,%rax
  8c29c1:	4c 09 c0             	or     %r8,%rax
  8c29c4:	48 89 04 0e          	mov    %rax,(%rsi,%rcx,1)
  8c29c8:	48 c7 44 0e 08 00 00 	movq   $0x0,0x8(%rsi,%rcx,1)
  8c29cf:	00 00 
  8c29d1:	e9 c5 03 00 00       	jmp    8c2d9b <check_lower_drain+0xd6b>
  8c29d6:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c29da:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c29e1:	75 1a                	jne    8c29fd <check_lower_drain+0x9cd>
  8c29e3:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c29ea:	00 00 00 
  8c29ed:	8b 87 64 01 00 00    	mov    0x164(%rdi),%eax
  8c29f3:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c29f7:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c29fd:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c2a03:	31 d2                	xor    %edx,%edx
  8c2a05:	31 c9                	xor    %ecx,%ecx
  8c2a07:	c5 f8 77             	vzeroupper
  8c2a0a:	e8 b1 ce 00 00       	call   8cf8c0 <check_lower_operand>
  8c2a0f:	e9 6f f6 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c2a14:	3b 54 24 3c          	cmp    0x3c(%rsp),%edx
  8c2a18:	73 12                	jae    8c2a2c <check_lower_drain+0x9fc>
  8c2a1a:	4c 8b 87 a0 01 00 00 	mov    0x1a0(%rdi),%r8
  8c2a21:	41 f6 04 10 02       	testb  $0x2,(%r8,%rdx,1)
  8c2a26:	0f 85 43 fe ff ff    	jne    8c286f <check_lower_drain+0x83f>
  8c2a2c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c2a30:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2a37:	0f 85 46 f6 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c2a3d:	48 8d 0d b1 fe e2 ff 	lea    -0x1d014f(%rip),%rcx        # 6f28f5 <pp_string_value.meaning+0x3eff1>
  8c2a44:	eb 4e                	jmp    8c2a94 <check_lower_drain+0xa64>
  8c2a46:	41 83 fb 3f          	cmp    $0x3f,%r11d
  8c2a4a:	74 23                	je     8c2a6f <check_lower_drain+0xa3f>
  8c2a4c:	41 83 fb 3c          	cmp    $0x3c,%r11d
  8c2a50:	0f 85 73 01 00 00    	jne    8c2bc9 <check_lower_drain+0xb99>
  8c2a56:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  8c2a5b:	b9 df fe ff ff       	mov    $0xfffffedf,%ecx
  8c2a60:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c2a64:	01 c8                	add    %ecx,%eax
  8c2a66:	83 f8 01             	cmp    $0x1,%eax
  8c2a69:	0f 87 45 03 00 00    	ja     8c2db4 <check_lower_drain+0xd84>
  8c2a6f:	c5 f8 77             	vzeroupper
  8c2a72:	e8 c9 e6 00 00       	call   8d1140 <check_lower_helper>
  8c2a77:	e9 02 f6 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c2a7c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c2a80:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2a87:	0f 85 f6 f5 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c2a8d:	48 8d 0d 83 18 e8 ff 	lea    -0x17e77d(%rip),%rcx        # 744317 <pp_decode_file_name.meaning+0xd13d>
  8c2a94:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c2a9b:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c2aa0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c2aa4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2aab:	0f 85 d2 f5 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c2ab1:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c2ab8:	00 00 00 
  8c2abb:	e9 87 fd ff ff       	jmp    8c2847 <check_lower_drain+0x817>
  8c2ac0:	41 83 7b 0c 00       	cmpl   $0x0,0xc(%r11)
  8c2ac5:	4c 89 64 24 78       	mov    %r12,0x78(%rsp)
  8c2aca:	41 89 dc             	mov    %ebx,%r12d
  8c2acd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8c2ad2:	48 89 94 24 80 00 00 	mov    %rdx,0x80(%rsp)
  8c2ad9:	00 
  8c2ada:	74 3f                	je     8c2b1b <check_lower_drain+0xaeb>
  8c2adc:	41 83 7b 54 00       	cmpl   $0x0,0x54(%r11)
  8c2ae1:	75 38                	jne    8c2b1b <check_lower_drain+0xaeb>
  8c2ae3:	45 0f b7 53 08       	movzwl 0x8(%r11),%r10d
  8c2ae8:	41 f7 c2 10 08 00 00 	test   $0x810,%r10d
  8c2aef:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c2af4:	75 25                	jne    8c2b1b <check_lower_drain+0xaeb>
  8c2af6:	41 83 7b 04 00       	cmpl   $0x0,0x4(%r11)
  8c2afb:	75 1e                	jne    8c2b1b <check_lower_drain+0xaeb>
  8c2afd:	41 83 f9 3e          	cmp    $0x3e,%r9d
  8c2b01:	0f 87 39 f9 ff ff    	ja     8c2440 <check_lower_drain+0x410>
  8c2b07:	48 ba 00 00 00 00 08 	movabs $0x4080000800000000,%rdx
  8c2b0e:	00 80 40 
  8c2b11:	4c 0f a3 ca          	bt     %r9,%rdx
  8c2b15:	0f 83 25 f9 ff ff    	jae    8c2440 <check_lower_drain+0x410>
  8c2b1b:	31 d2                	xor    %edx,%edx
  8c2b1d:	44 88 f2             	mov    %r14b,%dl
  8c2b20:	44 8d 72 01          	lea    0x1(%rdx),%r14d
  8c2b24:	41 39 f6             	cmp    %esi,%r14d
  8c2b27:	0f 87 13 f9 ff ff    	ja     8c2440 <check_lower_drain+0x410>
  8c2b2d:	44 03 74 24 48       	add    0x48(%rsp),%r14d
  8c2b32:	41 39 f6             	cmp    %esi,%r14d
  8c2b35:	0f 85 05 f9 ff ff    	jne    8c2440 <check_lower_drain+0x410>
  8c2b3b:	83 7c 24 3c 0f       	cmpl   $0xf,0x3c(%rsp)
  8c2b40:	77 16                	ja     8c2b58 <check_lower_drain+0xb28>
  8c2b42:	4c 8b 54 24 58       	mov    0x58(%rsp),%r10
  8c2b47:	41 ff c2             	inc    %r10d
  8c2b4a:	41 39 f2             	cmp    %esi,%r10d
  8c2b4d:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c2b52:	0f 85 e8 f8 ff ff    	jne    8c2440 <check_lower_drain+0x410>
  8c2b58:	45 2b 82 38 01 00 00 	sub    0x138(%r10),%r8d
  8c2b5f:	0f 82 db f8 ff ff    	jb     8c2440 <check_lower_drain+0x410>
  8c2b65:	44 88 e3             	mov    %r12b,%bl
  8c2b68:	44 8d 54 1a 01       	lea    0x1(%rdx,%rbx,1),%r10d
  8c2b6d:	45 39 c2             	cmp    %r8d,%r10d
  8c2b70:	0f 87 56 f7 ff ff    	ja     8c22cc <check_lower_drain+0x29c>
  8c2b76:	29 fd                	sub    %edi,%ebp
  8c2b78:	40 0f 93 c7          	setae  %dil
  8c2b7c:	83 fd 05             	cmp    $0x5,%ebp
  8c2b7f:	41 0f 93 c0          	setae  %r8b
  8c2b83:	41 20 f8             	and    %dil,%r8b
  8c2b86:	41 80 f8 01          	cmp    $0x1,%r8b
  8c2b8a:	0f 85 3c f7 ff ff    	jne    8c22cc <check_lower_drain+0x29c>
  8c2b90:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c2b95:	31 ff                	xor    %edi,%edi
  8c2b97:	41 83 f9 23          	cmp    $0x23,%r9d
  8c2b9b:	0f 8f f4 06 00 00    	jg     8c3295 <check_lower_drain+0x1265>
  8c2ba1:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
  8c2ba6:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
  8c2bab:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
  8c2bb0:	41 83 f9 01          	cmp    $0x1,%r9d
  8c2bb4:	0f 84 1f 0a 00 00    	je     8c35d9 <check_lower_drain+0x15a9>
  8c2bba:	41 83 f9 18          	cmp    $0x18,%r9d
  8c2bbe:	0f 84 15 0a 00 00    	je     8c35d9 <check_lower_drain+0x15a9>
  8c2bc4:	e9 05 0a 00 00       	jmp    8c35ce <check_lower_drain+0x159e>
  8c2bc9:	41 8d 53 be          	lea    -0x42(%r11),%edx
  8c2bcd:	83 fa 02             	cmp    $0x2,%edx
  8c2bd0:	0f 87 eb 01 00 00    	ja     8c2dc1 <check_lower_drain+0xd91>
  8c2bd6:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c2bda:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c2bdf:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2be6:	0f 85 97 f4 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c2bec:	48 8d 0d 26 b4 da ff 	lea    -0x254bda(%rip),%rcx        # 66e019 <fuzz_comment_end+0xb6d3>
  8c2bf3:	e9 9c fe ff ff       	jmp    8c2a94 <check_lower_drain+0xa64>
  8c2bf8:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c2bfc:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c2c03:	75 1b                	jne    8c2c20 <check_lower_drain+0xbf0>
  8c2c05:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c2c0c:	00 00 00 
  8c2c0f:	8b 8f 64 01 00 00    	mov    0x164(%rdi),%ecx
  8c2c15:	4c 8b 47 08          	mov    0x8(%rdi),%r8
  8c2c19:	41 89 88 f4 00 00 00 	mov    %ecx,0xf4(%r8)
  8c2c20:	41 83 fb 41          	cmp    $0x41,%r11d
  8c2c24:	0f 85 e9 00 00 00    	jne    8c2d13 <check_lower_drain+0xce3>
  8c2c2a:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8c2c30:	3b 8f 40 01 00 00    	cmp    0x140(%rdi),%ecx
  8c2c36:	73 30                	jae    8c2c68 <check_lower_drain+0xc38>
  8c2c38:	4c 8b 4f 18          	mov    0x18(%rdi),%r9
  8c2c3c:	44 8d 41 01          	lea    0x1(%rcx),%r8d
  8c2c40:	48 c1 e1 04          	shl    $0x4,%rcx
  8c2c44:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c2c4b:	49 b8 01 00 00 00 01 	movabs $0x8000100000001,%r8
  8c2c52:	00 08 00 
  8c2c55:	49 83 c0 14          	add    $0x14,%r8
  8c2c59:	4d 89 04 09          	mov    %r8,(%r9,%rcx,1)
  8c2c5d:	49 c7 44 09 08 01 00 	movq   $0x1,0x8(%r9,%rcx,1)
  8c2c64:	00 00 
  8c2c66:	eb 28                	jmp    8c2c90 <check_lower_drain+0xc60>
  8c2c68:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c2c6c:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c2c73:	75 1b                	jne    8c2c90 <check_lower_drain+0xc60>
  8c2c75:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c2c7c:	00 00 00 
  8c2c7f:	8b 8f 64 01 00 00    	mov    0x164(%rdi),%ecx
  8c2c85:	4c 8b 47 08          	mov    0x8(%rdi),%r8
  8c2c89:	41 89 88 f4 00 00 00 	mov    %ecx,0xf4(%r8)
  8c2c90:	4c 8b 4b 20          	mov    0x20(%rbx),%r9
  8c2c94:	4c 8b 03             	mov    (%rbx),%r8
  8c2c97:	41 8b 0c 91          	mov    (%r9,%rdx,4),%ecx
  8c2c9b:	48 8b 53 38          	mov    0x38(%rbx),%rdx
  8c2c9f:	c1 e9 03             	shr    $0x3,%ecx
  8c2ca2:	41 80 3c 08 0f       	cmpb   $0xf,(%r8,%rcx,1)
  8c2ca7:	75 07                	jne    8c2cb0 <check_lower_drain+0xc80>
  8c2ca9:	41 8b 0c 89          	mov    (%r9,%rcx,4),%ecx
  8c2cad:	c1 e9 03             	shr    $0x3,%ecx
  8c2cb0:	44 8b 8f 3c 01 00 00 	mov    0x13c(%rdi),%r9d
  8c2cb7:	44 3b 8f 40 01 00 00 	cmp    0x140(%rdi),%r9d
  8c2cbe:	73 2c                	jae    8c2cec <check_lower_drain+0xcbc>
  8c2cc0:	48 8b 0c ca          	mov    (%rdx,%rcx,8),%rcx
  8c2cc4:	4c 8b 57 18          	mov    0x18(%rdi),%r10
  8c2cc8:	45 8d 41 01          	lea    0x1(%r9),%r8d
  8c2ccc:	49 c1 e1 04          	shl    $0x4,%r9
  8c2cd0:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c2cd7:	49 b8 01 00 00 00 01 	movabs $0x8000100000001,%r8
  8c2cde:	00 08 00 
  8c2ce1:	4f 89 04 0a          	mov    %r8,(%r10,%r9,1)
  8c2ce5:	4b 89 4c 0a 08       	mov    %rcx,0x8(%r10,%r9,1)
  8c2cea:	eb 27                	jmp    8c2d13 <check_lower_drain+0xce3>
  8c2cec:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c2cf0:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c2cf7:	75 1a                	jne    8c2d13 <check_lower_drain+0xce3>
  8c2cf9:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c2d00:	00 00 00 
  8c2d03:	8b 8f 64 01 00 00    	mov    0x164(%rdi),%ecx
  8c2d09:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8c2d0d:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c2d13:	48 8b 55 08          	mov    0x8(%rbp),%rdx
  8c2d17:	31 c9                	xor    %ecx,%ecx
  8c2d19:	83 7c 02 04 01       	cmpl   $0x1,0x4(%rdx,%rax,1)
  8c2d1e:	0f 94 c1             	sete   %cl
  8c2d21:	31 d2                	xor    %edx,%edx
  8c2d23:	45 31 c0             	xor    %r8d,%r8d
  8c2d26:	c5 f8 77             	vzeroupper
  8c2d29:	e8 92 cb 00 00       	call   8cf8c0 <check_lower_operand>
  8c2d2e:	e9 50 f3 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c2d33:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c2d37:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2d3e:	75 1a                	jne    8c2d5a <check_lower_drain+0xd2a>
  8c2d40:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c2d47:	00 00 00 
  8c2d4a:	8b 87 64 01 00 00    	mov    0x164(%rdi),%eax
  8c2d50:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c2d54:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c2d5a:	41 83 fb 39          	cmp    $0x39,%r11d
  8c2d5e:	0f 85 1f f3 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c2d64:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c2d69:	41 b8 58 00 00 00    	mov    $0x58,%r8d
  8c2d6f:	e9 8f fc ff ff       	jmp    8c2a03 <check_lower_drain+0x9d3>
  8c2d74:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c2d78:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2d7f:	75 1a                	jne    8c2d9b <check_lower_drain+0xd6b>
  8c2d81:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c2d88:	00 00 00 
  8c2d8b:	8b 87 64 01 00 00    	mov    0x164(%rdi),%eax
  8c2d91:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c2d95:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c2d9b:	41 8b 75 40          	mov    0x40(%r13),%esi
  8c2d9f:	ff ca                	dec    %edx
  8c2da1:	ff ce                	dec    %esi
  8c2da3:	48 c1 e6 20          	shl    $0x20,%rsi
  8c2da7:	c5 f8 77             	vzeroupper
  8c2daa:	e8 a1 38 00 00       	call   8c6650 <check_lower_initializer>
  8c2daf:	e9 cf f2 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c2db4:	c5 f8 77             	vzeroupper
  8c2db7:	e8 f4 ec 00 00       	call   8d1ab0 <check_lower_miscellaneous_prepare>
  8c2dbc:	e9 bd f2 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c2dc1:	45 8d 43 e7          	lea    -0x19(%r11),%r8d
  8c2dc5:	41 83 f8 25          	cmp    $0x25,%r8d
  8c2dc9:	0f 87 8a 02 00 00    	ja     8c3059 <check_lower_drain+0x1029>
  8c2dcf:	4c 8d 0d f6 45 be ff 	lea    -0x41ba0a(%rip),%r9        # 4a73cc <cbuiltin_test_generated.edges+0xad3c>
  8c2dd6:	4b 63 14 81          	movslq (%r9,%r8,4),%rdx
  8c2dda:	4c 01 ca             	add    %r9,%rdx
  8c2ddd:	ff e2                	jmp    *%rdx
  8c2ddf:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c2de4:	31 d2                	xor    %edx,%edx
  8c2de6:	e9 c3 f9 ff ff       	jmp    8c27ae <check_lower_drain+0x77e>
  8c2deb:	49 8b 55 48          	mov    0x48(%r13),%rdx
  8c2def:	48 89 fb             	mov    %rdi,%rbx
  8c2df2:	c5 f8 77             	vzeroupper
  8c2df5:	e8 36 8f 00 00       	call   8cbd30 <check_lower_address>
  8c2dfa:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c2dff:	be 0a 00 00 00       	mov    $0xa,%esi
  8c2e04:	48 89 df             	mov    %rbx,%rdi
  8c2e07:	31 c9                	xor    %ecx,%ecx
  8c2e09:	e8 f2 30 00 00       	call   8c5f00 <check_lower_emit>
  8c2e0e:	e9 70 f2 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c2e13:	49 8b 80 80 00 00 00 	mov    0x80(%r8),%rax
  8c2e1a:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c2e1d:	48 85 c9             	test   %rcx,%rcx
  8c2e20:	0f 84 d6 00 00 00    	je     8c2efc <check_lower_drain+0xecc>
  8c2e26:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c2e2b:	be 04 00 00 00       	mov    $0x4,%esi
  8c2e30:	c5 f8 77             	vzeroupper
  8c2e33:	e8 c8 30 00 00       	call   8c5f00 <check_lower_emit>
  8c2e38:	e9 46 f2 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c2e3d:	8d 78 fe             	lea    -0x2(%rax),%edi
  8c2e40:	83 ff 04             	cmp    $0x4,%edi
  8c2e43:	0f 87 50 05 00 00    	ja     8c3399 <check_lower_drain+0x1369>
  8c2e49:	48 8d 0d 3c 45 be ff 	lea    -0x41bac4(%rip),%rcx        # 4a738c <cbuiltin_test_generated.edges+0xacfc>
  8c2e50:	48 63 04 b9          	movslq (%rcx,%rdi,4),%rax
  8c2e54:	48 01 c8             	add    %rcx,%rax
  8c2e57:	ff e0                	jmp    *%rax
  8c2e59:	41 8b 82 b0 01 00 00 	mov    0x1b0(%r10),%eax
  8c2e60:	89 f1                	mov    %esi,%ecx
  8c2e62:	c1 e9 03             	shr    $0x3,%ecx
  8c2e65:	4d 89 e5             	mov    %r12,%r13
  8c2e68:	39 c1                	cmp    %eax,%ecx
  8c2e6a:	73 11                	jae    8c2e7d <check_lower_drain+0xe4d>
  8c2e6c:	49 8b ba a0 01 00 00 	mov    0x1a0(%r10),%rdi
  8c2e73:	f6 04 0f 02          	testb  $0x2,(%rdi,%rcx,1)
  8c2e77:	0f 85 6a 0d 00 00    	jne    8c3be7 <check_lower_drain+0x1bb7>
  8c2e7d:	44 89 f2             	mov    %r14d,%edx
  8c2e80:	c1 ea 03             	shr    $0x3,%edx
  8c2e83:	39 c2                	cmp    %eax,%edx
  8c2e85:	73 11                	jae    8c2e98 <check_lower_drain+0xe68>
  8c2e87:	49 8b ba a0 01 00 00 	mov    0x1a0(%r10),%rdi
  8c2e8e:	f6 04 17 02          	testb  $0x2,(%rdi,%rdx,1)
  8c2e92:	0f 85 55 0d 00 00    	jne    8c3bed <check_lower_drain+0x1bbd>
  8c2e98:	41 b4 ff             	mov    $0xff,%r12b
  8c2e9b:	41 b7 ff             	mov    $0xff,%r15b
  8c2e9e:	39 c1                	cmp    %eax,%ecx
  8c2ea0:	73 1c                	jae    8c2ebe <check_lower_drain+0xe8e>
  8c2ea2:	49 8b 92 a0 01 00 00 	mov    0x1a0(%r10),%rdx
  8c2ea9:	41 b7 08             	mov    $0x8,%r15b
  8c2eac:	f6 04 0a 01          	testb  $0x1,(%rdx,%rcx,1)
  8c2eb0:	75 0c                	jne    8c2ebe <check_lower_drain+0xe8e>
  8c2eb2:	49 8b 92 98 01 00 00 	mov    0x198(%r10),%rdx
  8c2eb9:	44 0f b6 3c 0a       	movzbl (%rdx,%rcx,1),%r15d
  8c2ebe:	44 89 f2             	mov    %r14d,%edx
  8c2ec1:	c1 ea 03             	shr    $0x3,%edx
  8c2ec4:	39 c2                	cmp    %eax,%edx
  8c2ec6:	73 1c                	jae    8c2ee4 <check_lower_drain+0xeb4>
  8c2ec8:	49 8b ba a0 01 00 00 	mov    0x1a0(%r10),%rdi
  8c2ecf:	41 b4 08             	mov    $0x8,%r12b
  8c2ed2:	f6 04 17 01          	testb  $0x1,(%rdi,%rdx,1)
  8c2ed6:	75 0c                	jne    8c2ee4 <check_lower_drain+0xeb4>
  8c2ed8:	49 8b ba 98 01 00 00 	mov    0x198(%r10),%rdi
  8c2edf:	44 0f b6 24 17       	movzbl (%rdi,%rdx,1),%r12d
  8c2ee4:	39 c1                	cmp    %eax,%ecx
  8c2ee6:	0f 83 f9 08 00 00    	jae    8c37e5 <check_lower_drain+0x17b5>
  8c2eec:	49 8b ba a0 01 00 00 	mov    0x1a0(%r10),%rdi
  8c2ef3:	0f b6 0c 0f          	movzbl (%rdi,%rcx,1),%ecx
  8c2ef7:	e9 eb 08 00 00       	jmp    8c37e7 <check_lower_drain+0x17b7>
  8c2efc:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c2f00:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2f07:	0f 85 76 f1 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c2f0d:	e9 2b f9 ff ff       	jmp    8c283d <check_lower_drain+0x80d>
  8c2f12:	4c 8b 6d 60          	mov    0x60(%rbp),%r13
  8c2f16:	8b 85 b4 00 00 00    	mov    0xb4(%rbp),%eax
  8c2f1c:	ba 00 01 00 00       	mov    $0x100,%edx
  8c2f21:	48 89 f1             	mov    %rsi,%rcx
  8c2f24:	49 89 ce             	mov    %rcx,%r14
  8c2f27:	4c 89 ef             	mov    %r13,%rdi
  8c2f2a:	89 c6                	mov    %eax,%esi
  8c2f2c:	c5 f8 77             	vzeroupper
  8c2f2f:	e8 9c 9a fc ff       	call   88c9d0 <check_program_builtin_index>
  8c2f34:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c2f37:	0f 84 a8 02 00 00    	je     8c31e5 <check_lower_drain+0x11b5>
  8c2f3d:	4d 85 ed             	test   %r13,%r13
  8c2f40:	0f 84 9f 02 00 00    	je     8c31e5 <check_lower_drain+0x11b5>
  8c2f46:	89 c0                	mov    %eax,%eax
  8c2f48:	48 c1 e0 08          	shl    $0x8,%rax
  8c2f4c:	49 01 c5             	add    %rax,%r13
  8c2f4f:	41 83 bd d0 00 00 00 	cmpl   $0x0,0xd0(%r13)
  8c2f56:	00 
  8c2f57:	0f 84 88 02 00 00    	je     8c31e5 <check_lower_drain+0x11b5>
  8c2f5d:	41 83 bd f0 00 00 00 	cmpl   $0x0,0xf0(%r13)
  8c2f64:	00 
  8c2f65:	0f 84 7a 02 00 00    	je     8c31e5 <check_lower_drain+0x11b5>
  8c2f6b:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c2f70:	44 89 f6             	mov    %r14d,%esi
  8c2f73:	4c 89 ea             	mov    %r13,%rdx
  8c2f76:	e8 c5 ee 00 00       	call   8d1e40 <check_lower_math>
  8c2f7b:	e9 fe f0 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c2f80:	08 cb                	or     %cl,%bl
  8c2f82:	f6 c3 01             	test   $0x1,%bl
  8c2f85:	75 1f                	jne    8c2fa6 <check_lower_drain+0xf76>
  8c2f87:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c2f8c:	48 89 f3             	mov    %rsi,%rbx
  8c2f8f:	be 0a 00 00 00       	mov    $0xa,%esi
  8c2f94:	31 c9                	xor    %ecx,%ecx
  8c2f96:	c5 f8 77             	vzeroupper
  8c2f99:	e8 b2 34 00 00       	call   8c6450 <check_lower_instruction>
  8c2f9e:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c2fa3:	48 89 de             	mov    %rbx,%rsi
  8c2fa6:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
  8c2fab:	31 d2                	xor    %edx,%edx
  8c2fad:	31 c9                	xor    %ecx,%ecx
  8c2faf:	e9 66 f8 ff ff       	jmp    8c281a <check_lower_drain+0x7ea>
  8c2fb4:	4c 8b 6d 68          	mov    0x68(%rbp),%r13
  8c2fb8:	8b 85 b8 00 00 00    	mov    0xb8(%rbp),%eax
  8c2fbe:	ba b0 00 00 00       	mov    $0xb0,%edx
  8c2fc3:	48 89 f1             	mov    %rsi,%rcx
  8c2fc6:	49 89 ce             	mov    %rcx,%r14
  8c2fc9:	4c 89 ef             	mov    %r13,%rdi
  8c2fcc:	89 c6                	mov    %eax,%esi
  8c2fce:	c5 f8 77             	vzeroupper
  8c2fd1:	e8 fa 99 fc ff       	call   88c9d0 <check_program_builtin_index>
  8c2fd6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c2fd9:	0f 84 c1 2a 00 00    	je     8c5aa0 <check_lower_drain+0x3a70>
  8c2fdf:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c2fe4:	89 c1                	mov    %eax,%ecx
  8c2fe6:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c2fed:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c2ff2:	49 01 cd             	add    %rcx,%r13
  8c2ff5:	48 8b 0a             	mov    (%rdx),%rcx
  8c2ff8:	48 8b 51 38          	mov    0x38(%rcx),%rdx
  8c2ffc:	b1 01                	mov    $0x1,%cl
  8c2ffe:	42 81 3c ba 30 01 00 	cmpl   $0x130,(%rdx,%r15,4)
  8c3005:	00 
  8c3006:	75 0f                	jne    8c3017 <check_lower_drain+0xfe7>
  8c3008:	41 8b 8d 8c 00 00 00 	mov    0x8c(%r13),%ecx
  8c300f:	ff c9                	dec    %ecx
  8c3011:	83 f9 02             	cmp    $0x2,%ecx
  8c3014:	0f 92 c1             	setb   %cl
  8c3017:	84 c9                	test   %cl,%cl
  8c3019:	74 1c                	je     8c3037 <check_lower_drain+0x1007>
  8c301b:	41 83 bd a0 00 00 00 	cmpl   $0x0,0xa0(%r13)
  8c3022:	00 
  8c3023:	75 12                	jne    8c3037 <check_lower_drain+0x1007>
  8c3025:	41 83 7d 1c 00       	cmpl   $0x0,0x1c(%r13)
  8c302a:	74 0b                	je     8c3037 <check_lower_drain+0x1007>
  8c302c:	41 83 7d 64 00       	cmpl   $0x0,0x64(%r13)
  8c3031:	0f 84 fd 0c 00 00    	je     8c3d34 <check_lower_drain+0x1d04>
  8c3037:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c303b:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c3040:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3047:	0f 85 36 f0 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c304d:	48 8d 0d 57 f8 e2 ff 	lea    -0x1d07a9(%rip),%rcx        # 6f28ab <pp_string_value.meaning+0x3efa7>
  8c3054:	e9 3b fa ff ff       	jmp    8c2a94 <check_lower_drain+0xa64>
  8c3059:	41 83 fa 20          	cmp    $0x20,%r10d
  8c305d:	0f 85 a7 01 00 00    	jne    8c320a <check_lower_drain+0x11da>
  8c3063:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8c3068:	4c 89 5c 24 68       	mov    %r11,0x68(%rsp)
  8c306d:	49 89 ce             	mov    %rcx,%r14
  8c3070:	41 83 fb 21          	cmp    $0x21,%r11d
  8c3074:	0f 85 9a 03 00 00    	jne    8c3414 <check_lower_drain+0x13e4>
  8c307a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8c307f:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  8c3084:	48 8b 07             	mov    (%rdi),%rax
  8c3087:	89 f2                	mov    %esi,%edx
  8c3089:	c1 ea 03             	shr    $0x3,%edx
  8c308c:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  8c3090:	83 e6 07             	and    $0x7,%esi
  8c3093:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8c3097:	04 f8                	add    $0xf8,%al
  8c3099:	3c 03                	cmp    $0x3,%al
  8c309b:	b8 00 00 00 00       	mov    $0x0,%eax
  8c30a0:	0f 43 f0             	cmovae %eax,%esi
  8c30a3:	0b 34 91             	or     (%rcx,%rdx,4),%esi
  8c30a6:	e9 82 03 00 00       	jmp    8c342d <check_lower_drain+0x13fd>
  8c30ab:	45 8b 18             	mov    (%r8),%r11d
  8c30ae:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c30b3:	ba ff 00 00 00       	mov    $0xff,%edx
  8c30b8:	41 c1 eb 03          	shr    $0x3,%r11d
  8c30bc:	45 3b 9e b0 01 00 00 	cmp    0x1b0(%r14),%r11d
  8c30c3:	73 04                	jae    8c30c9 <check_lower_drain+0x1099>
  8c30c5:	43 8b 14 9a          	mov    (%r10,%r11,4),%edx
  8c30c9:	44 0f b6 da          	movzbl %dl,%r11d
  8c30cd:	45 8d 53 ff          	lea    -0x1(%r11),%r10d
  8c30d1:	41 83 fa 0a          	cmp    $0xa,%r10d
  8c30d5:	40 0f 93 c5          	setae  %bpl
  8c30d9:	f7 c2 00 05 00 00    	test   $0x500,%edx
  8c30df:	41 0f 95 c6          	setne  %r14b
  8c30e3:	41 08 ee             	or     %bpl,%r14b
  8c30e6:	0f 85 e3 f0 ff ff    	jne    8c21cf <check_lower_drain+0x19f>
  8c30ec:	41 83 78 44 00       	cmpl   $0x0,0x44(%r8)
  8c30f1:	0f 85 d8 f0 ff ff    	jne    8c21cf <check_lower_drain+0x19f>
  8c30f7:	41 8b 68 0c          	mov    0xc(%r8),%ebp
  8c30fb:	85 ed                	test   %ebp,%ebp
  8c30fd:	0f 84 cc f0 ff ff    	je     8c21cf <check_lower_drain+0x19f>
  8c3103:	41 83 78 54 00       	cmpl   $0x0,0x54(%r8)
  8c3108:	0f 85 c1 f0 ff ff    	jne    8c21cf <check_lower_drain+0x19f>
  8c310e:	45 0f b7 70 08       	movzwl 0x8(%r8),%r14d
  8c3113:	41 f7 c6 10 08 00 00 	test   $0x810,%r14d
  8c311a:	0f 85 af f0 ff ff    	jne    8c21cf <check_lower_drain+0x19f>
  8c3120:	41 83 78 04 00       	cmpl   $0x0,0x4(%r8)
  8c3125:	0f 85 a4 f0 ff ff    	jne    8c21cf <check_lower_drain+0x19f>
  8c312b:	41 83 f9 3e          	cmp    $0x3e,%r9d
  8c312f:	77 14                	ja     8c3145 <check_lower_drain+0x1115>
  8c3131:	49 be 00 00 00 00 08 	movabs $0x4080000800000000,%r14
  8c3138:	00 80 40 
  8c313b:	4d 0f a3 ce          	bt     %r9,%r14
  8c313f:	0f 82 8a f0 ff ff    	jb     8c21cf <check_lower_drain+0x19f>
  8c3145:	83 fd 01             	cmp    $0x1,%ebp
  8c3148:	0f 85 81 f0 ff ff    	jne    8c21cf <check_lower_drain+0x19f>
  8c314e:	49 8b 48 10          	mov    0x10(%r8),%rcx
  8c3152:	41 83 fb 06          	cmp    $0x6,%r11d
  8c3156:	77 3b                	ja     8c3193 <check_lower_drain+0x1163>
  8c3158:	41 d1 ea             	shr    $1,%r10d
  8c315b:	b8 08 00 00 00       	mov    $0x8,%eax
  8c3160:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  8c3167:	c4 e2 29 f7 c0       	shlx   %r10d,%eax,%eax
  8c316c:	c4 e2 f8 f5 f9       	bzhi   %rax,%rcx,%rdi
  8c3171:	c4 e2 f9 f7 f6       	shlx   %rax,%rsi,%rsi
  8c3176:	ff c8                	dec    %eax
  8c3178:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c317d:	c4 e2 fb f7 c7       	shrx   %rax,%rdi,%rax
  8c3182:	48 85 c0             	test   %rax,%rax
  8c3185:	48 0f 44 f0          	cmove  %rax,%rsi
  8c3189:	f6 c2 01             	test   $0x1,%dl
  8c318c:	48 0f 45 ce          	cmovne %rsi,%rcx
  8c3190:	48 09 f9             	or     %rdi,%rcx
  8c3193:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c3197:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c319c:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c31a0:	89 86 64 01 00 00    	mov    %eax,0x164(%rsi)
  8c31a6:	80 fa 0f             	cmp    $0xf,%dl
  8c31a9:	0f 82 8f 25 00 00    	jb     8c573e <check_lower_drain+0x370e>
  8c31af:	83 bb f0 00 00 00 00 	cmpl   $0x0,0xf0(%rbx)
  8c31b6:	0f 85 c7 ee ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c31bc:	48 8d 05 3f 64 dc ff 	lea    -0x239bc1(%rip),%rax        # 689602 <fuzz_comment_end+0x26cbc>
  8c31c3:	48 89 83 00 01 00 00 	mov    %rax,0x100(%rbx)
  8c31ca:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c31cf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c31d3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c31da:	0f 85 a3 ee ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c31e0:	e9 cc f8 ff ff       	jmp    8c2ab1 <check_lower_drain+0xa81>
  8c31e5:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  8c31ea:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c31ef:	44 89 f6             	mov    %r14d,%esi
  8c31f2:	42 81 3c b8 52 01 00 	cmpl   $0x152,(%rax,%r15,4)
  8c31f9:	00 
  8c31fa:	0f 84 6f f8 ff ff    	je     8c2a6f <check_lower_drain+0xa3f>
  8c3200:	e8 5b f2 00 00       	call   8d2460 <check_lower_floating_prepare>
  8c3205:	e9 74 ee ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c320a:	45 8b 45 00          	mov    0x0(%r13),%r8d
  8c320e:	41 83 fb 24          	cmp    $0x24,%r11d
  8c3212:	0f 87 fd 0b 00 00    	ja     8c3e15 <check_lower_drain+0x1de5>
  8c3218:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8c321d:	45 89 d9             	mov    %r11d,%r9d
  8c3220:	4c 0f a3 ca          	bt     %r9,%rdx
  8c3224:	0f 83 ba 02 00 00    	jae    8c34e4 <check_lower_drain+0x14b4>
  8c322a:	44 89 c2             	mov    %r8d,%edx
  8c322d:	c1 ea 03             	shr    $0x3,%edx
  8c3230:	3b 54 24 3c          	cmp    0x3c(%rsp),%edx
  8c3234:	73 14                	jae    8c324a <check_lower_drain+0x121a>
  8c3236:	4c 8b b7 a0 01 00 00 	mov    0x1a0(%rdi),%r14
  8c323d:	89 d2                	mov    %edx,%edx
  8c323f:	41 f6 04 16 02       	testb  $0x2,(%r14,%rdx,1)
  8c3244:	0f 85 bd 07 00 00    	jne    8c3a07 <check_lower_drain+0x19d7>
  8c324a:	41 8d 53 fe          	lea    -0x2(%r11),%edx
  8c324e:	83 fa 23             	cmp    $0x23,%edx
  8c3251:	0f 87 15 0c 00 00    	ja     8c3e6c <check_lower_drain+0x1e3c>
  8c3257:	4c 8d 0d 06 42 be ff 	lea    -0x41bdfa(%rip),%r9        # 4a7464 <cbuiltin_test_generated.edges+0xadd4>
  8c325e:	49 63 14 91          	movslq (%r9,%rdx,4),%rdx
  8c3262:	4c 01 ca             	add    %r9,%rdx
  8c3265:	ff e2                	jmp    *%rdx
  8c3267:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c326c:	31 c0                	xor    %eax,%eax
  8c326e:	41 83 fb 02          	cmp    $0x2,%r11d
  8c3272:	49 89 f6             	mov    %rsi,%r14
  8c3275:	48 89 fb             	mov    %rdi,%rbx
  8c3278:	0f 95 c0             	setne  %al
  8c327b:	31 c9                	xor    %ecx,%ecx
  8c327d:	83 c0 07             	add    $0x7,%eax
  8c3280:	89 c6                	mov    %eax,%esi
  8c3282:	c5 f8 77             	vzeroupper
  8c3285:	e8 c6 31 00 00       	call   8c6450 <check_lower_instruction>
  8c328a:	48 89 df             	mov    %rbx,%rdi
  8c328d:	44 89 f6             	mov    %r14d,%esi
  8c3290:	e9 11 fd ff ff       	jmp    8c2fa6 <check_lower_drain+0xf76>
  8c3295:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
  8c329a:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
  8c329f:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
  8c32a4:	41 83 f9 24          	cmp    $0x24,%r9d
  8c32a8:	0f 84 2b 03 00 00    	je     8c35d9 <check_lower_drain+0x15a9>
  8c32ae:	41 83 f9 34          	cmp    $0x34,%r9d
  8c32b2:	0f 85 16 03 00 00    	jne    8c35ce <check_lower_drain+0x159e>
  8c32b8:	44 8b 5c 24 3c       	mov    0x3c(%rsp),%r11d
  8c32bd:	45 31 c9             	xor    %r9d,%r9d
  8c32c0:	e9 32 03 00 00       	jmp    8c35f7 <check_lower_drain+0x15c7>
  8c32c5:	48 89 f0             	mov    %rsi,%rax
  8c32c8:	48 c1 e8 20          	shr    $0x20,%rax
  8c32cc:	48 bf 00 00 00 00 ff 	movabs $0xff00000000,%rdi
  8c32d3:	00 00 00 
  8c32d6:	48 89 f1             	mov    %rsi,%rcx
  8c32d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8c32df:	48 21 f9             	and    %rdi,%rcx
  8c32e2:	fe c8                	dec    %al
  8c32e4:	bf 01 12 08 00       	mov    $0x81201,%edi
  8c32e9:	c4 e2 7b f7 ff       	shrx   %eax,%edi,%edi
  8c32ee:	40 f6 c7 01          	test   $0x1,%dil
  8c32f2:	44 89 f7             	mov    %r14d,%edi
  8c32f5:	41 0f 45 f8          	cmovne %r8d,%edi
  8c32f9:	3c 14                	cmp    $0x14,%al
  8c32fb:	48 b8 00 00 00 00 01 	movabs $0x100000000,%rax
  8c3302:	00 00 00 
  8c3305:	41 0f 43 fe          	cmovae %r14d,%edi
  8c3309:	48 39 c1             	cmp    %rax,%rcx
  8c330c:	0f 45 d7             	cmovne %edi,%edx
  8c330f:	4c 89 d7             	mov    %r10,%rdi
  8c3312:	c5 f8 77             	vzeroupper
  8c3315:	e8 46 94 00 00       	call   8cc760 <check_lower_miscellaneous_emit>
  8c331a:	e9 67 ed ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c331f:	4c 89 d7             	mov    %r10,%rdi
  8c3322:	c5 f8 77             	vzeroupper
  8c3325:	e8 46 b5 ff ff       	call   8be870 <check_lower_control>
  8c332a:	e9 57 ed ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c332f:	48 89 f0             	mov    %rsi,%rax
  8c3332:	48 c1 e8 20          	shr    $0x20,%rax
  8c3336:	48 bf 00 00 00 00 ff 	movabs $0xff00000000,%rdi
  8c333d:	00 00 00 
  8c3340:	48 89 f1             	mov    %rsi,%rcx
  8c3343:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8c3349:	48 21 f9             	and    %rdi,%rcx
  8c334c:	fe c8                	dec    %al
  8c334e:	bf 01 12 08 00       	mov    $0x81201,%edi
  8c3353:	c4 e2 7b f7 ff       	shrx   %eax,%edi,%edi
  8c3358:	40 f6 c7 01          	test   $0x1,%dil
  8c335c:	44 89 f7             	mov    %r14d,%edi
  8c335f:	41 0f 45 f8          	cmovne %r8d,%edi
  8c3363:	3c 14                	cmp    $0x14,%al
  8c3365:	48 b8 00 00 00 00 01 	movabs $0x100000000,%rax
  8c336c:	00 00 00 
  8c336f:	41 0f 43 fe          	cmovae %r14d,%edi
  8c3373:	48 39 c1             	cmp    %rax,%rcx
  8c3376:	0f 45 d7             	cmovne %edi,%edx
  8c3379:	4c 89 d7             	mov    %r10,%rdi
  8c337c:	c5 f8 77             	vzeroupper
  8c337f:	e8 dc 92 00 00       	call   8cc660 <check_lower_builtin_emit>
  8c3384:	e9 fd ec ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c3389:	4c 89 d7             	mov    %r10,%rdi
  8c338c:	c5 f8 77             	vzeroupper
  8c338f:	e8 1c 2b 00 00       	call   8c5eb0 <check_lower_place>
  8c3394:	e9 ed ec ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c3399:	8d 78 f9             	lea    -0x7(%rax),%edi
  8c339c:	40 80 ff 01          	cmp    $0x1,%dil
  8c33a0:	0f 87 5b 01 00 00    	ja     8c3501 <check_lower_drain+0x14d1>
  8c33a6:	48 89 f1             	mov    %rsi,%rcx
  8c33a9:	48 c1 e9 20          	shr    $0x20,%rcx
  8c33ad:	b8 01 12 08 00       	mov    $0x81201,%eax
  8c33b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8c33b8:	0f b6 f9             	movzbl %cl,%edi
  8c33bb:	fe c9                	dec    %cl
  8c33bd:	c4 e2 73 f7 c0       	shrx   %ecx,%eax,%eax
  8c33c2:	a8 01                	test   $0x1,%al
  8c33c4:	44 89 f0             	mov    %r14d,%eax
  8c33c7:	41 0f 45 c0          	cmovne %r8d,%eax
  8c33cb:	80 f9 14             	cmp    $0x14,%cl
  8c33ce:	89 f1                	mov    %esi,%ecx
  8c33d0:	41 0f 43 c6          	cmovae %r14d,%eax
  8c33d4:	83 ff 01             	cmp    $0x1,%edi
  8c33d7:	0f 45 d0             	cmovne %eax,%edx
  8c33da:	48 c1 e1 05          	shl    $0x5,%rcx
  8c33de:	49 03 8a 30 01 00 00 	add    0x130(%r10),%rcx
  8c33e5:	83 ff 08             	cmp    $0x8,%edi
  8c33e8:	0f 85 e4 03 00 00    	jne    8c37d2 <check_lower_drain+0x17a2>
  8c33ee:	8b 39                	mov    (%rcx),%edi
  8c33f0:	41 b8 b3 fe ff ff    	mov    $0xfffffeb3,%r8d
  8c33f6:	44 01 c7             	add    %r8d,%edi
  8c33f9:	83 ff 01             	cmp    $0x1,%edi
  8c33fc:	0f 87 d0 03 00 00    	ja     8c37d2 <check_lower_drain+0x17a2>
  8c3402:	4c 89 d7             	mov    %r10,%rdi
  8c3405:	89 c2                	mov    %eax,%edx
  8c3407:	c5 f8 77             	vzeroupper
  8c340a:	e8 f1 7d 01 00       	call   8db200 <check_lower_floating_strict>
  8c340f:	e9 72 ec ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c3414:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c3419:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  8c341d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8c3422:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8c3426:	48 c1 e0 05          	shl    $0x5,%rax
  8c342a:	8b 34 01             	mov    (%rcx,%rax,1),%esi
  8c342d:	48 c7 84 24 f8 01 00 	movq   $0x0,0x1f8(%rsp)
  8c3434:	00 00 00 00 00 
  8c3439:	48 8d 8c 24 f8 01 00 	lea    0x1f8(%rsp),%rcx
  8c3440:	00 
  8c3441:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  8c3446:	42 8b 14 b8          	mov    (%rax,%r15,4),%edx
  8c344a:	c5 f8 77             	vzeroupper
  8c344d:	e8 5e 0a 92 00       	call   11e3eb0 <type_find_member>
  8c3452:	41 8b 4d 08          	mov    0x8(%r13),%ecx
  8c3456:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c345b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c345f:	c5 f9 7f 84 24 e0 01 	vmovdqa %xmm0,0x1e0(%rsp)
  8c3466:	00 00 
  8c3468:	48 c7 84 24 f0 01 00 	movq   $0x0,0x1f0(%rsp)
  8c346f:	00 00 00 00 00 
  8c3474:	85 c0                	test   %eax,%eax
  8c3476:	74 1e                	je     8c3496 <check_lower_drain+0x1466>
  8c3478:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c347d:	f6 c1 04             	test   $0x4,%cl
  8c3480:	0f 85 b1 00 00 00    	jne    8c3537 <check_lower_drain+0x1507>
  8c3486:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  8c348d:	00 
  8c348e:	a8 07                	test   $0x7,%al
  8c3490:	0f 84 fb 08 00 00    	je     8c3d91 <check_lower_drain+0x1d61>
  8c3496:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c349a:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c349f:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c34a6:	0f 85 d7 eb ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c34ac:	48 8d 0d 1c d6 d5 ff 	lea    -0x2a29e4(%rip),%rcx        # 620acf <foreign_touch.flags+0x497a>
  8c34b3:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c34ba:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c34be:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c34c5:	0f 85 b8 eb ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c34cb:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c34d2:	00 00 00 
  8c34d5:	8b 87 64 01 00 00    	mov    0x164(%rdi),%eax
  8c34db:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c34df:	e9 72 f3 ff ff       	jmp    8c2856 <check_lower_drain+0x826>
  8c34e4:	48 ba 02 00 00 01 10 	movabs $0x1001000002,%rdx
  8c34eb:	00 00 00 
  8c34ee:	4c 0f a3 ca          	bt     %r9,%rdx
  8c34f2:	0f 83 1d 09 00 00    	jae    8c3e15 <check_lower_drain+0x1de5>
  8c34f8:	31 d2                	xor    %edx,%edx
  8c34fa:	31 c9                	xor    %ecx,%ecx
  8c34fc:	e9 19 f3 ff ff       	jmp    8c281a <check_lower_drain+0x7ea>
  8c3501:	83 c0 f7             	add    $0xfffffff7,%eax
  8c3504:	83 f8 0a             	cmp    $0xa,%eax
  8c3507:	0f 87 52 13 00 00    	ja     8c485f <check_lower_drain+0x282f>
  8c350d:	48 8d 3d 8c 3e be ff 	lea    -0x41c174(%rip),%rdi        # 4a73a0 <cbuiltin_test_generated.edges+0xad10>
  8c3514:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
  8c3518:	48 01 f8             	add    %rdi,%rax
  8c351b:	ff e0                	jmp    *%rax
  8c351d:	49 8b 02             	mov    (%r10),%rax
  8c3520:	89 f1                	mov    %esi,%ecx
  8c3522:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  8c3526:	48 c1 e6 05          	shl    $0x5,%rsi
  8c352a:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c352e:	48 03 70 08          	add    0x8(%rax),%rsi
  8c3532:	e9 85 0f 00 00       	jmp    8c44bc <check_lower_drain+0x248c>
  8c3537:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  8c353c:	48 8d 94 24 e0 01 00 	lea    0x1e0(%rsp),%rdx
  8c3543:	00 
  8c3544:	e8 17 00 01 00       	call   8d3560 <check_lower_bit_member>
  8c3549:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c354e:	84 c0                	test   %al,%al
  8c3550:	0f 84 e5 06 00 00    	je     8c3c3b <check_lower_drain+0x1c0b>
  8c3556:	41 f6 c6 01          	test   $0x1,%r14b
  8c355a:	0f 85 4f 08 00 00    	jne    8c3daf <check_lower_drain+0x1d7f>
  8c3560:	8b 84 24 ec 01 00 00 	mov    0x1ec(%rsp),%eax
  8c3567:	0f b6 8c 24 f0 01 00 	movzbl 0x1f0(%rsp),%ecx
  8c356e:	00 
  8c356f:	0f b6 94 24 f1 01 00 	movzbl 0x1f1(%rsp),%edx
  8c3576:	00 
  8c3577:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c357b:	c5 fe 7f 84 24 c0 01 	vmovdqu %ymm0,0x1c0(%rsp)
  8c3582:	00 00 
  8c3584:	c7 84 24 c0 01 00 00 	movl   $0x10,0x1c0(%rsp)
  8c358b:	10 00 00 00 
  8c358f:	8d 04 c5 f8 ff ff ff 	lea    -0x8(,%rax,8),%eax
  8c3596:	0b 84 24 e8 01 00 00 	or     0x1e8(%rsp),%eax
  8c359d:	c1 e1 09             	shl    $0x9,%ecx
  8c35a0:	c1 e2 0d             	shl    $0xd,%edx
  8c35a3:	09 ca                	or     %ecx,%edx
  8c35a5:	09 c2                	or     %eax,%edx
  8c35a7:	89 94 24 c8 01 00 00 	mov    %edx,0x1c8(%rsp)
  8c35ae:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c35b5:	00 00 
  8c35b7:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c35bc:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c35c1:	c5 f8 77             	vzeroupper
  8c35c4:	e8 37 6c 00 00       	call   8ca200 <check_lower_push>
  8c35c9:	e9 e1 07 00 00       	jmp    8c3daf <check_lower_drain+0x1d7f>
  8c35ce:	4d 89 fb             	mov    %r15,%r11
  8c35d1:	49 c1 e3 05          	shl    $0x5,%r11
  8c35d5:	4d 03 58 10          	add    0x10(%r8),%r11
  8c35d9:	45 8b 0b             	mov    (%r11),%r9d
  8c35dc:	44 8b 5c 24 3c       	mov    0x3c(%rsp),%r11d
  8c35e1:	41 83 fb 0f          	cmp    $0xf,%r11d
  8c35e5:	77 10                	ja     8c35f7 <check_lower_drain+0x15c7>
  8c35e7:	49 8b 78 10          	mov    0x10(%r8),%rdi
  8c35eb:	4d 89 f8             	mov    %r15,%r8
  8c35ee:	49 c1 e0 05          	shl    $0x5,%r8
  8c35f2:	42 8b 7c 07 08       	mov    0x8(%rdi,%r8,1),%edi
  8c35f7:	42 83 3c b0 00       	cmpl   $0x0,(%rax,%r14,4)
  8c35fc:	74 1c                	je     8c361a <check_lower_drain+0x15ea>
  8c35fe:	4c 8b a4 24 80 00 00 	mov    0x80(%rsp),%r12
  8c3605:	00 
  8c3606:	4f 8d 04 76          	lea    (%r14,%r14,2),%r8
  8c360a:	49 c1 e0 05          	shl    $0x5,%r8
  8c360e:	43 83 7c 04 0c 01    	cmpl   $0x1,0xc(%r12,%r8,1)
  8c3614:	0f 85 26 ee ff ff    	jne    8c2440 <check_lower_drain+0x410>
  8c361a:	41 83 fb 0f          	cmp    $0xf,%r11d
  8c361e:	77 26                	ja     8c3646 <check_lower_drain+0x1616>
  8c3620:	41 89 d8             	mov    %ebx,%r8d
  8c3623:	42 83 3c 80 00       	cmpl   $0x0,(%rax,%r8,4)
  8c3628:	74 1c                	je     8c3646 <check_lower_drain+0x1616>
  8c362a:	4c 8b 9c 24 80 00 00 	mov    0x80(%rsp),%r11
  8c3631:	00 
  8c3632:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
  8c3636:	49 c1 e0 05          	shl    $0x5,%r8
  8c363a:	43 83 7c 03 0c 01    	cmpl   $0x1,0xc(%r11,%r8,1)
  8c3640:	0f 85 fa ed ff ff    	jne    8c2440 <check_lower_drain+0x410>
  8c3646:	45 85 c9             	test   %r9d,%r9d
  8c3649:	74 1d                	je     8c3668 <check_lower_drain+0x1638>
  8c364b:	4c 8b 9c 24 80 00 00 	mov    0x80(%rsp),%r11
  8c3652:	00 
  8c3653:	4f 8d 04 76          	lea    (%r14,%r14,2),%r8
  8c3657:	49 c1 e0 05          	shl    $0x5,%r8
  8c365b:	47 8b 1c 03          	mov    (%r11,%r8,1),%r11d
  8c365f:	45 39 d9             	cmp    %r11d,%r9d
  8c3662:	0f 85 b0 00 00 00    	jne    8c3718 <check_lower_drain+0x16e8>
  8c3668:	83 7c 24 3c 0f       	cmpl   $0xf,0x3c(%rsp)
  8c366d:	77 24                	ja     8c3693 <check_lower_drain+0x1663>
  8c366f:	85 ff                	test   %edi,%edi
  8c3671:	74 20                	je     8c3693 <check_lower_drain+0x1663>
  8c3673:	4c 8b 9c 24 80 00 00 	mov    0x80(%rsp),%r11
  8c367a:	00 
  8c367b:	41 89 d8             	mov    %ebx,%r8d
  8c367e:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
  8c3682:	49 c1 e0 05          	shl    $0x5,%r8
  8c3686:	47 8b 1c 03          	mov    (%r11,%r8,1),%r11d
  8c368a:	44 39 df             	cmp    %r11d,%edi
  8c368d:	0f 85 ec 05 00 00    	jne    8c3c7f <check_lower_drain+0x1c4f>
  8c3693:	45 8b 82 b0 01 00 00 	mov    0x1b0(%r10),%r8d
  8c369a:	45 89 cb             	mov    %r9d,%r11d
  8c369d:	41 c1 eb 03          	shr    $0x3,%r11d
  8c36a1:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  8c36a7:	45 39 c3             	cmp    %r8d,%r11d
  8c36aa:	73 0c                	jae    8c36b8 <check_lower_drain+0x1688>
  8c36ac:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  8c36b1:	45 89 da             	mov    %r11d,%r10d
  8c36b4:	46 8b 14 93          	mov    (%rbx,%r10,4),%r10d
  8c36b8:	45 85 c9             	test   %r9d,%r9d
  8c36bb:	0f 84 16 02 00 00    	je     8c38d7 <check_lower_drain+0x18a7>
  8c36c1:	8b 6c 24 3c          	mov    0x3c(%rsp),%ebp
  8c36c5:	45 31 c9             	xor    %r9d,%r9d
  8c36c8:	45 0f b6 da          	movzbl %r10b,%r11d
  8c36cc:	83 fd 02             	cmp    $0x2,%ebp
  8c36cf:	41 0f 92 c1          	setb   %r9b
  8c36d3:	83 fd 10             	cmp    $0x10,%ebp
  8c36d6:	0f 93 c3             	setae  %bl
  8c36d9:	41 c1 e1 0b          	shl    $0xb,%r9d
  8c36dd:	41 81 c9 00 07 00 00 	or     $0x700,%r9d
  8c36e4:	41 83 fb 0b          	cmp    $0xb,%r11d
  8c36e8:	41 0f 92 c3          	setb   %r11b
  8c36ec:	45 85 ca             	test   %r9d,%r10d
  8c36ef:	41 0f 94 c1          	sete   %r9b
  8c36f3:	45 20 d9             	and    %r11b,%r9b
  8c36f6:	41 80 f9 01          	cmp    $0x1,%r9b
  8c36fa:	75 09                	jne    8c3705 <check_lower_drain+0x16d5>
  8c36fc:	83 fd 10             	cmp    $0x10,%ebp
  8c36ff:	0f 82 e2 01 00 00    	jb     8c38e7 <check_lower_drain+0x18b7>
  8c3705:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c370a:	45 84 c9             	test   %r9b,%r9b
  8c370d:	0f 84 2d ed ff ff    	je     8c2440 <check_lower_drain+0x410>
  8c3713:	e9 2a 02 00 00       	jmp    8c3942 <check_lower_drain+0x1912>
  8c3718:	41 8b 9a b0 01 00 00 	mov    0x1b0(%r10),%ebx
  8c371f:	41 c1 eb 03          	shr    $0x3,%r11d
  8c3723:	41 b8 ff 00 00 00    	mov    $0xff,%r8d
  8c3729:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  8c372f:	41 39 db             	cmp    %ebx,%r11d
  8c3732:	73 09                	jae    8c373d <check_lower_drain+0x170d>
  8c3734:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
  8c3739:	47 8b 14 9a          	mov    (%r10,%r11,4),%r10d
  8c373d:	45 89 cb             	mov    %r9d,%r11d
  8c3740:	41 c1 eb 03          	shr    $0x3,%r11d
  8c3744:	41 39 db             	cmp    %ebx,%r11d
  8c3747:	73 0c                	jae    8c3755 <check_lower_drain+0x1725>
  8c3749:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  8c374e:	45 89 d8             	mov    %r11d,%r8d
  8c3751:	46 8b 04 83          	mov    (%rbx,%r8,4),%r8d
  8c3755:	41 f7 c2 00 01 00 00 	test   $0x100,%r10d
  8c375c:	45 0f b6 da          	movzbl %r10b,%r11d
  8c3760:	bd 08 00 00 00       	mov    $0x8,%ebp
  8c3765:	41 0f b6 d8          	movzbl %r8b,%ebx
  8c3769:	44 0f 45 dd          	cmovne %ebp,%r11d
  8c376d:	41 f7 c0 00 01 00 00 	test   $0x100,%r8d
  8c3774:	0f 45 dd             	cmovne %ebp,%ebx
  8c3777:	41 39 db             	cmp    %ebx,%r11d
  8c377a:	0f 94 c3             	sete   %bl
  8c377d:	41 83 fb 0f          	cmp    $0xf,%r11d
  8c3781:	41 0f 92 c3          	setb   %r11b
  8c3785:	41 20 db             	and    %bl,%r11b
  8c3788:	41 80 fb 01          	cmp    $0x1,%r11b
  8c378c:	0f 85 3a eb ff ff    	jne    8c22cc <check_lower_drain+0x29c>
  8c3792:	45 89 c3             	mov    %r8d,%r11d
  8c3795:	41 c1 eb 08          	shr    $0x8,%r11d
  8c3799:	41 c1 ea 08          	shr    $0x8,%r10d
  8c379d:	44 89 db             	mov    %r11d,%ebx
  8c37a0:	44 31 d3             	xor    %r10d,%ebx
  8c37a3:	f6 c3 01             	test   $0x1,%bl
  8c37a6:	0f 85 20 eb ff ff    	jne    8c22cc <check_lower_drain+0x29c>
  8c37ac:	45 09 d3             	or     %r10d,%r11d
  8c37af:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c37b4:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
  8c37b9:	41 81 e0 00 10 00 00 	and    $0x1000,%r8d
  8c37c0:	41 83 e3 02          	and    $0x2,%r11d
  8c37c4:	45 09 d8             	or     %r11d,%r8d
  8c37c7:	0f 85 73 ec ff ff    	jne    8c2440 <check_lower_drain+0x410>
  8c37cd:	e9 96 fe ff ff       	jmp    8c3668 <check_lower_drain+0x1638>
  8c37d2:	4c 89 d7             	mov    %r10,%rdi
  8c37d5:	48 89 ce             	mov    %rcx,%rsi
  8c37d8:	c5 f8 77             	vzeroupper
  8c37db:	e8 d0 98 01 00       	call   8dd0b0 <check_lower_floating_recipe>
  8c37e0:	e9 a1 e8 ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c37e5:	31 c9                	xor    %ecx,%ecx
  8c37e7:	39 c2                	cmp    %eax,%edx
  8c37e9:	73 0a                	jae    8c37f5 <check_lower_drain+0x17c5>
  8c37eb:	49 8b ba a0 01 00 00 	mov    0x1a0(%r10),%rdi
  8c37f2:	32 0c 17             	xor    (%rdi,%rdx,1),%cl
  8c37f5:	49 8b 3a             	mov    (%r10),%rdi
  8c37f8:	45 84 e4             	test   %r12b,%r12b
  8c37fb:	41 0f 95 c0          	setne  %r8b
  8c37ff:	41 20 c8             	and    %cl,%r8b
  8c3802:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
  8c3806:	41 80 ff 0e          	cmp    $0xe,%r15b
  8c380a:	0f 87 8e 00 00 00    	ja     8c389e <check_lower_drain+0x186e>
  8c3810:	41 80 fc 0e          	cmp    $0xe,%r12b
  8c3814:	0f 87 84 00 00 00    	ja     8c389e <check_lower_drain+0x186e>
  8c381a:	45 84 c0             	test   %r8b,%r8b
  8c381d:	75 7f                	jne    8c389e <check_lower_drain+0x186e>
  8c381f:	45 84 e4             	test   %r12b,%r12b
  8c3822:	0f 84 cb 06 00 00    	je     8c3ef3 <check_lower_drain+0x1ec3>
  8c3828:	39 c2                	cmp    %eax,%edx
  8c382a:	73 11                	jae    8c383d <check_lower_drain+0x180d>
  8c382c:	49 8b 82 a0 01 00 00 	mov    0x1a0(%r10),%rax
  8c3833:	f6 04 10 10          	testb  $0x10,(%rax,%rdx,1)
  8c3837:	0f 85 16 0b 00 00    	jne    8c4353 <check_lower_drain+0x2323>
  8c383d:	44 89 f8             	mov    %r15d,%eax
  8c3840:	24 0e                	and    $0xe,%al
  8c3842:	3c 0c                	cmp    $0xc,%al
  8c3844:	0f 85 6b 0a 00 00    	jne    8c42b5 <check_lower_drain+0x2285>
  8c384a:	41 8d 44 24 f7       	lea    -0x9(%r12),%eax
  8c384f:	3c 02                	cmp    $0x2,%al
  8c3851:	0f 87 5e 0a 00 00    	ja     8c42b5 <check_lower_drain+0x2285>
  8c3857:	31 c0                	xor    %eax,%eax
  8c3859:	41 80 ff 0c          	cmp    $0xc,%r15b
  8c385d:	41 0f b6 ef          	movzbl %r15b,%ebp
  8c3861:	4c 89 d7             	mov    %r10,%rdi
  8c3864:	4c 89 d3             	mov    %r10,%rbx
  8c3867:	0f 95 c0             	setne  %al
  8c386a:	89 ee                	mov    %ebp,%esi
  8c386c:	8d 04 c5 70 00 00 00 	lea    0x70(,%rax,8),%eax
  8c3873:	89 84 24 b0 00 00 00 	mov    %eax,0xb0(%rsp)
  8c387a:	c5 f8 77             	vzeroupper
  8c387d:	e8 ae ac ff ff       	call   8be530 <check_lower_temporary>
  8c3882:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c3886:	41 89 c6             	mov    %eax,%r14d
  8c3889:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c3890:	0f 84 1c 11 00 00    	je     8c49b2 <check_lower_drain+0x2982>
  8c3896:	45 31 ff             	xor    %r15d,%r15d
  8c3899:	e9 6c 11 00 00       	jmp    8c4a0a <check_lower_drain+0x29da>
  8c389e:	48 8d 05 f9 82 d2 ff 	lea    -0x2d7d07(%rip),%rax        # 5ebb9e <parse_test_openers+0x1fa11>
  8c38a5:	45 84 c0             	test   %r8b,%r8b
  8c38a8:	75 18                	jne    8c38c2 <check_lower_drain+0x1892>
  8c38aa:	41 80 ff 0f          	cmp    $0xf,%r15b
  8c38ae:	44 0f 43 f6          	cmovae %esi,%r14d
  8c38b2:	44 89 f6             	mov    %r14d,%esi
  8c38b5:	c5 f8 77             	vzeroupper
  8c38b8:	e8 a3 ab ff ff       	call   8be460 <check_lower_type_feature>
  8c38bd:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c38c2:	83 bb f0 00 00 00 00 	cmpl   $0x0,0xf0(%rbx)
  8c38c9:	4d 89 ec             	mov    %r13,%r12
  8c38cc:	0f 85 b9 e7 ff ff    	jne    8c208b <check_lower_drain+0x5b>
  8c38d2:	e9 2a e8 ff ff       	jmp    8c2101 <check_lower_drain+0xd1>
  8c38d7:	83 7c 24 3c 0f       	cmpl   $0xf,0x3c(%rsp)
  8c38dc:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c38e1:	b3 01                	mov    $0x1,%bl
  8c38e3:	77 5d                	ja     8c3942 <check_lower_drain+0x1912>
  8c38e5:	31 db                	xor    %ebx,%ebx
  8c38e7:	41 89 fa             	mov    %edi,%r10d
  8c38ea:	41 c1 ea 03          	shr    $0x3,%r10d
  8c38ee:	41 b9 ff 00 00 00    	mov    $0xff,%r9d
  8c38f4:	45 39 c2             	cmp    %r8d,%r10d
  8c38f7:	73 0c                	jae    8c3905 <check_lower_drain+0x18d5>
  8c38f9:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
  8c38fe:	45 89 d0             	mov    %r10d,%r8d
  8c3901:	47 8b 0c 81          	mov    (%r9,%r8,4),%r9d
  8c3905:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c390a:	85 ff                	test   %edi,%edi
  8c390c:	74 34                	je     8c3942 <check_lower_drain+0x1912>
  8c390e:	49 89 d3             	mov    %rdx,%r11
  8c3911:	31 d2                	xor    %edx,%edx
  8c3913:	83 7c 24 3c 02       	cmpl   $0x2,0x3c(%rsp)
  8c3918:	45 0f b6 c1          	movzbl %r9b,%r8d
  8c391c:	40 0f 92 c7          	setb   %dil
  8c3920:	41 83 f8 0a          	cmp    $0xa,%r8d
  8c3924:	0f 87 16 eb ff ff    	ja     8c2440 <check_lower_drain+0x410>
  8c392a:	40 88 fa             	mov    %dil,%dl
  8c392d:	c1 e2 0b             	shl    $0xb,%edx
  8c3930:	81 ca 00 07 00 00    	or     $0x700,%edx
  8c3936:	41 21 d1             	and    %edx,%r9d
  8c3939:	4c 89 da             	mov    %r11,%rdx
  8c393c:	0f 85 fe ea ff ff    	jne    8c2440 <check_lower_drain+0x410>
  8c3942:	83 ca 02             	or     $0x2,%edx
  8c3945:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8c394a:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  8c394f:	4c 89 d7             	mov    %r10,%rdi
  8c3952:	44 89 f6             	mov    %r14d,%esi
  8c3955:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
  8c395a:	e8 e1 c3 00 00       	call   8cfd40 <check_lower_batch_classify>
  8c395f:	83 7c 24 3c 10       	cmpl   $0x10,0x3c(%rsp)
  8c3964:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c3969:	c4 e3 79 16 c7 01    	vpextrd $0x1,%xmm0,%edi
  8c396f:	c4 c3 79 16 c0 02    	vpextrd $0x2,%xmm0,%r8d
  8c3975:	44 0f 43 c7          	cmovae %edi,%r8d
  8c3979:	4d 8b 0a             	mov    (%r10),%r9
  8c397c:	41 0f b6 d0          	movzbl %r8b,%edx
  8c3980:	8d 42 ff             	lea    -0x1(%rdx),%eax
  8c3983:	83 f8 0a             	cmp    $0xa,%eax
  8c3986:	0f 92 c0             	setb   %al
  8c3989:	41 f7 c0 00 05 00 00 	test   $0x500,%r8d
  8c3990:	0f 94 c1             	sete   %cl
  8c3993:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
  8c3998:	84 c1                	test   %al,%cl
  8c399a:	0f 84 85 02 00 00    	je     8c3c25 <check_lower_drain+0x1bf5>
  8c39a0:	49 8b 41 08          	mov    0x8(%r9),%rax
  8c39a4:	4b 8d 34 76          	lea    (%r14,%r14,2),%rsi
  8c39a8:	48 c1 e6 05          	shl    $0x5,%rsi
  8c39ac:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c39b0:	44 8b 54 30 40       	mov    0x40(%rax,%rsi,1),%r10d
  8c39b5:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  8c39bc:	00 
  8c39bd:	4d 85 d2             	test   %r10,%r10
  8c39c0:	0f 84 f3 05 00 00    	je     8c3fb9 <check_lower_drain+0x1f89>
  8c39c6:	45 3b 91 c0 00 00 00 	cmp    0xc0(%r9),%r10d
  8c39cd:	40 0f 92 c5          	setb   %bpl
  8c39d1:	e9 e5 05 00 00       	jmp    8c3fbb <check_lower_drain+0x1f8b>
  8c39d6:	4c 8b 7c 24 60       	mov    0x60(%rsp),%r15
  8c39db:	31 d2                	xor    %edx,%edx
  8c39dd:	41 83 fb 03          	cmp    $0x3,%r11d
  8c39e1:	49 89 f6             	mov    %rsi,%r14
  8c39e4:	48 89 fb             	mov    %rdi,%rbx
  8c39e7:	0f 94 c2             	sete   %dl
  8c39ea:	44 89 fe             	mov    %r15d,%esi
  8c39ed:	c5 f8 77             	vzeroupper
  8c39f0:	e8 1b c1 00 00       	call   8cfb10 <check_lower_truth>
  8c39f5:	48 89 df             	mov    %rbx,%rdi
  8c39f8:	44 89 f6             	mov    %r14d,%esi
  8c39fb:	31 d2                	xor    %edx,%edx
  8c39fd:	31 c9                	xor    %ecx,%ecx
  8c39ff:	45 89 f8             	mov    %r15d,%r8d
  8c3a02:	e9 13 ee ff ff       	jmp    8c281a <check_lower_drain+0x7ea>
  8c3a07:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8c3a0c:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8c3a11:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  8c3a16:	4c 89 db             	mov    %r11,%rbx
  8c3a19:	c5 f8 77             	vzeroupper
  8c3a1c:	e8 cf ae fe ff       	call   8ae8f0 <check_lower_complex_element>
  8c3a21:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c3a26:	c1 e8 03             	shr    $0x3,%eax
  8c3a29:	b1 ff                	mov    $0xff,%cl
  8c3a2b:	3b 44 24 3c          	cmp    0x3c(%rsp),%eax
  8c3a2f:	73 0b                	jae    8c3a3c <check_lower_drain+0x1a0c>
  8c3a31:	48 8b 8f 98 01 00 00 	mov    0x198(%rdi),%rcx
  8c3a38:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c3a3c:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c3a41:	48 8b 55 08          	mov    0x8(%rbp),%rdx
  8c3a45:	49 89 d8             	mov    %rbx,%r8
  8c3a48:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8c3a4c:	48 c1 e0 05          	shl    $0x5,%rax
  8c3a50:	8b 34 02             	mov    (%rdx,%rax,1),%esi
  8c3a53:	89 c8                	mov    %ecx,%eax
  8c3a55:	c1 ee 03             	shr    $0x3,%esi
  8c3a58:	3b 74 24 3c          	cmp    0x3c(%rsp),%esi
  8c3a5c:	73 10                	jae    8c3a6e <check_lower_drain+0x1a3e>
  8c3a5e:	41 f6 04 36 02       	testb  $0x2,(%r14,%rsi,1)
  8c3a63:	0f b6 c1             	movzbl %cl,%eax
  8c3a66:	be 08 00 00 00       	mov    $0x8,%esi
  8c3a6b:	0f 45 c6             	cmovne %esi,%eax
  8c3a6e:	41 83 f8 02          	cmp    $0x2,%r8d
  8c3a72:	74 2c                	je     8c3aa0 <check_lower_drain+0x1a70>
  8c3a74:	41 83 f8 04          	cmp    $0x4,%r8d
  8c3a78:	74 26                	je     8c3aa0 <check_lower_drain+0x1a70>
  8c3a7a:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
  8c3a81:	00 
  8c3a82:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  8c3a86:	48 c1 e6 05          	shl    $0x5,%rsi
  8c3a8a:	8b 14 32             	mov    (%rdx,%rsi,1),%edx
  8c3a8d:	c1 ea 03             	shr    $0x3,%edx
  8c3a90:	3b 54 24 3c          	cmp    0x3c(%rsp),%edx
  8c3a94:	73 0a                	jae    8c3aa0 <check_lower_drain+0x1a70>
  8c3a96:	41 f6 04 16 02       	testb  $0x2,(%r14,%rdx,1)
  8c3a9b:	41 b6 08             	mov    $0x8,%r14b
  8c3a9e:	75 03                	jne    8c3aa3 <check_lower_drain+0x1a73>
  8c3aa0:	41 89 ce             	mov    %ecx,%r14d
  8c3aa3:	44 0f b6 f8          	movzbl %al,%r15d
  8c3aa7:	44 89 fe             	mov    %r15d,%esi
  8c3aaa:	e8 81 aa ff ff       	call   8be530 <check_lower_temporary>
  8c3aaf:	48 89 da             	mov    %rbx,%rdx
  8c3ab2:	89 c1                	mov    %eax,%ecx
  8c3ab4:	83 fa 02             	cmp    $0x2,%edx
  8c3ab7:	74 21                	je     8c3ada <check_lower_drain+0x1aaa>
  8c3ab9:	83 fa 04             	cmp    $0x4,%edx
  8c3abc:	74 1c                	je     8c3ada <check_lower_drain+0x1aaa>
  8c3abe:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c3ac3:	41 0f b6 f6          	movzbl %r14b,%esi
  8c3ac7:	45 89 f4             	mov    %r14d,%r12d
  8c3aca:	41 89 c6             	mov    %eax,%r14d
  8c3acd:	e8 5e aa ff ff       	call   8be530 <check_lower_temporary>
  8c3ad2:	89 c1                	mov    %eax,%ecx
  8c3ad4:	44 89 f0             	mov    %r14d,%eax
  8c3ad7:	45 89 e6             	mov    %r12d,%r14d
  8c3ada:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c3adf:	41 89 c4             	mov    %eax,%r12d
  8c3ae2:	41 89 cd             	mov    %ecx,%r13d
  8c3ae5:	4c 89 e8             	mov    %r13,%rax
  8c3ae8:	48 c1 e0 20          	shl    $0x20,%rax
  8c3aec:	c7 84 24 c0 01 00 00 	movl   $0x14,0x1c0(%rsp)
  8c3af3:	14 00 00 00 
  8c3af7:	4c 09 e0             	or     %r12,%rax
  8c3afa:	89 94 24 c4 01 00 00 	mov    %edx,0x1c4(%rsp)
  8c3b01:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
  8c3b08:	00 00 00 00 00 
  8c3b0d:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  8c3b14:	00 
  8c3b15:	48 c7 84 24 d8 01 00 	movq   $0x0,0x1d8(%rsp)
  8c3b1c:	00 00 00 00 00 
  8c3b21:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c3b28:	00 00 
  8c3b2a:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c3b2f:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c3b34:	c5 f8 77             	vzeroupper
  8c3b37:	e8 c4 66 00 00       	call   8ca200 <check_lower_push>
  8c3b3c:	83 fb 02             	cmp    $0x2,%ebx
  8c3b3f:	74 59                	je     8c3b9a <check_lower_drain+0x1b6a>
  8c3b41:	83 fb 04             	cmp    $0x4,%ebx
  8c3b44:	74 54                	je     8c3b9a <check_lower_drain+0x1b6a>
  8c3b46:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c3b4b:	41 0f b6 d6          	movzbl %r14b,%edx
  8c3b4f:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c3b54:	4c 89 e9             	mov    %r13,%rcx
  8c3b57:	48 89 df             	mov    %rbx,%rdi
  8c3b5a:	e8 f1 28 00 00       	call   8c6450 <check_lower_instruction>
  8c3b5f:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  8c3b66:	00 
  8c3b67:	48 8b 45 08          	mov    0x8(%rbp),%rax
  8c3b6b:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
  8c3b70:	48 89 df             	mov    %rbx,%rdi
  8c3b73:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c3b77:	48 c1 e1 05          	shl    $0x5,%rcx
  8c3b7b:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c3b7e:	e8 ed fa 00 00       	call   8d3670 <check_lower_complex_target>
  8c3b83:	ba 01 00 00 00       	mov    $0x1,%edx
  8c3b88:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c3b8d:	48 89 df             	mov    %rbx,%rdi
  8c3b90:	31 c9                	xor    %ecx,%ecx
  8c3b92:	41 89 c0             	mov    %eax,%r8d
  8c3b95:	e8 26 bd 00 00       	call   8cf8c0 <check_lower_operand>
  8c3b9a:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c3b9f:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c3ba4:	44 89 fa             	mov    %r15d,%edx
  8c3ba7:	4c 89 e1             	mov    %r12,%rcx
  8c3baa:	48 89 df             	mov    %rbx,%rdi
  8c3bad:	e8 9e 28 00 00       	call   8c6450 <check_lower_instruction>
  8c3bb2:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c3bb7:	48 8b 45 08          	mov    0x8(%rbp),%rax
  8c3bbb:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  8c3bc0:	48 89 df             	mov    %rbx,%rdi
  8c3bc3:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c3bc7:	48 c1 e1 05          	shl    $0x5,%rcx
  8c3bcb:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c3bce:	e8 9d fa 00 00       	call   8d3670 <check_lower_complex_target>
  8c3bd3:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c3bd8:	48 89 df             	mov    %rbx,%rdi
  8c3bdb:	31 d2                	xor    %edx,%edx
  8c3bdd:	31 c9                	xor    %ecx,%ecx
  8c3bdf:	41 89 c0             	mov    %eax,%r8d
  8c3be2:	e9 33 ec ff ff       	jmp    8c281a <check_lower_drain+0x7ea>
  8c3be7:	44 89 f2             	mov    %r14d,%edx
  8c3bea:	c1 ea 03             	shr    $0x3,%edx
  8c3bed:	39 c2                	cmp    %eax,%edx
  8c3bef:	73 19                	jae    8c3c0a <check_lower_drain+0x1bda>
  8c3bf1:	89 d2                	mov    %edx,%edx
  8c3bf3:	f6 04 17 01          	testb  $0x1,(%rdi,%rdx,1)
  8c3bf7:	75 11                	jne    8c3c0a <check_lower_drain+0x1bda>
  8c3bf9:	49 8b ba 98 01 00 00 	mov    0x198(%r10),%rdi
  8c3c00:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  8c3c04:	0f 84 8e f2 ff ff    	je     8c2e98 <check_lower_drain+0xe68>
  8c3c0a:	4c 89 d7             	mov    %r10,%rdi
  8c3c0d:	44 89 f2             	mov    %r14d,%edx
  8c3c10:	c5 f8 77             	vzeroupper
  8c3c13:	e8 78 41 01 00       	call   8d7d90 <check_lower_complex_conversion>
  8c3c18:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c3c1d:	4d 89 ec             	mov    %r13,%r12
  8c3c20:	e9 66 e4 ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c3c25:	4d 8b 21             	mov    (%r9),%r12
  8c3c28:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c3c2d:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  8c3c32:	49 8b 04 24          	mov    (%r12),%rax
  8c3c36:	e9 08 e8 ff ff       	jmp    8c2443 <check_lower_drain+0x413>
  8c3c3b:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c3c40:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8c3c44:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3c4b:	0f 85 32 e4 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c3c51:	48 8d 15 92 9a e4 ff 	lea    -0x1b656e(%rip),%rdx        # 70d6ea <pp_string_value.meaning+0x59de6>
  8c3c58:	48 89 90 00 01 00 00 	mov    %rdx,0x100(%rax)
  8c3c5f:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8c3c63:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3c6a:	0f 85 13 e4 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c3c70:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c3c77:	00 00 00 
  8c3c7a:	e9 cd eb ff ff       	jmp    8c284c <check_lower_drain+0x81c>
  8c3c7f:	41 8b 9a b0 01 00 00 	mov    0x1b0(%r10),%ebx
  8c3c86:	41 c1 eb 03          	shr    $0x3,%r11d
  8c3c8a:	41 b8 ff 00 00 00    	mov    $0xff,%r8d
  8c3c90:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  8c3c96:	41 39 db             	cmp    %ebx,%r11d
  8c3c99:	73 09                	jae    8c3ca4 <check_lower_drain+0x1c74>
  8c3c9b:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
  8c3ca0:	47 8b 14 9a          	mov    (%r10,%r11,4),%r10d
  8c3ca4:	41 89 fb             	mov    %edi,%r11d
  8c3ca7:	41 c1 eb 03          	shr    $0x3,%r11d
  8c3cab:	41 39 db             	cmp    %ebx,%r11d
  8c3cae:	73 0c                	jae    8c3cbc <check_lower_drain+0x1c8c>
  8c3cb0:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  8c3cb5:	45 89 d8             	mov    %r11d,%r8d
  8c3cb8:	46 8b 04 83          	mov    (%rbx,%r8,4),%r8d
  8c3cbc:	41 f7 c2 00 01 00 00 	test   $0x100,%r10d
  8c3cc3:	45 0f b6 da          	movzbl %r10b,%r11d
  8c3cc7:	bd 08 00 00 00       	mov    $0x8,%ebp
  8c3ccc:	41 0f b6 d8          	movzbl %r8b,%ebx
  8c3cd0:	44 0f 45 dd          	cmovne %ebp,%r11d
  8c3cd4:	41 f7 c0 00 01 00 00 	test   $0x100,%r8d
  8c3cdb:	0f 45 dd             	cmovne %ebp,%ebx
  8c3cde:	41 39 db             	cmp    %ebx,%r11d
  8c3ce1:	0f 94 c3             	sete   %bl
  8c3ce4:	41 83 fb 0f          	cmp    $0xf,%r11d
  8c3ce8:	41 0f 92 c3          	setb   %r11b
  8c3cec:	41 20 db             	and    %bl,%r11b
  8c3cef:	41 80 fb 01          	cmp    $0x1,%r11b
  8c3cf3:	0f 85 d3 e5 ff ff    	jne    8c22cc <check_lower_drain+0x29c>
  8c3cf9:	45 89 c3             	mov    %r8d,%r11d
  8c3cfc:	41 c1 eb 08          	shr    $0x8,%r11d
  8c3d00:	41 c1 ea 08          	shr    $0x8,%r10d
  8c3d04:	44 89 db             	mov    %r11d,%ebx
  8c3d07:	44 31 d3             	xor    %r10d,%ebx
  8c3d0a:	f6 c3 01             	test   $0x1,%bl
  8c3d0d:	0f 85 b9 e5 ff ff    	jne    8c22cc <check_lower_drain+0x29c>
  8c3d13:	45 09 d3             	or     %r10d,%r11d
  8c3d16:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c3d1b:	41 81 e0 00 10 00 00 	and    $0x1000,%r8d
  8c3d22:	41 83 e3 02          	and    $0x2,%r11d
  8c3d26:	45 09 d8             	or     %r11d,%r8d
  8c3d29:	0f 85 11 e7 ff ff    	jne    8c2440 <check_lower_drain+0x410>
  8c3d2f:	e9 5f f9 ff ff       	jmp    8c3693 <check_lower_drain+0x1663>
  8c3d34:	49 8b 8c 24 a0 00 00 	mov    0xa0(%r12),%rcx
  8c3d3b:	00 
  8c3d3c:	41 8b 5d 70          	mov    0x70(%r13),%ebx
  8c3d40:	ba 00 00 00 00       	mov    $0x0,%edx
  8c3d45:	42 8b 2c b9          	mov    (%rcx,%r15,4),%ebp
  8c3d49:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c3d4e:	83 fd 20             	cmp    $0x20,%ebp
  8c3d51:	c4 e2 51 f7 c9       	shlx   %ebp,%ecx,%ecx
  8c3d56:	0f 43 ca             	cmovae %edx,%ecx
  8c3d59:	85 d9                	test   %ebx,%ecx
  8c3d5b:	0f 84 a5 04 00 00    	je     8c4206 <check_lower_drain+0x21d6>
  8c3d61:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c3d65:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c3d6c:	0f 85 c3 04 00 00    	jne    8c4235 <check_lower_drain+0x2205>
  8c3d72:	c7 81 f0 00 00 00 01 	movl   $0x1,0xf0(%rcx)
  8c3d79:	00 00 00 
  8c3d7c:	8b 8f 64 01 00 00    	mov    0x164(%rdi),%ecx
  8c3d82:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8c3d86:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c3d8c:	e9 a4 04 00 00       	jmp    8c4235 <check_lower_drain+0x2205>
  8c3d91:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c3d96:	44 08 f3             	or     %r14b,%bl
  8c3d99:	f6 c3 01             	test   $0x1,%bl
  8c3d9c:	75 1e                	jne    8c3dbc <check_lower_drain+0x1d8c>
  8c3d9e:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c3da3:	be 0a 00 00 00       	mov    $0xa,%esi
  8c3da8:	31 c9                	xor    %ecx,%ecx
  8c3daa:	e8 a1 26 00 00       	call   8c6450 <check_lower_instruction>
  8c3daf:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  8c3db6:	00 
  8c3db7:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c3dbc:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c3dc1:	4c 8b 4c 24 68       	mov    0x68(%rsp),%r9
  8c3dc6:	48 83 f8 08          	cmp    $0x8,%rax
  8c3dca:	0f 82 cf 01 00 00    	jb     8c3f9f <check_lower_drain+0x1f6f>
  8c3dd0:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8c3dd6:	3b 8f 40 01 00 00    	cmp    0x140(%rdi),%ecx
  8c3ddc:	0f 83 35 01 00 00    	jae    8c3f17 <check_lower_drain+0x1ee7>
  8c3de2:	48 8b 57 18          	mov    0x18(%rdi),%rdx
  8c3de6:	44 8d 41 01          	lea    0x1(%rcx),%r8d
  8c3dea:	48 c1 e1 04          	shl    $0x4,%rcx
  8c3dee:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c3df5:	49 b8 01 00 00 00 01 	movabs $0x8000100000001,%r8
  8c3dfc:	00 08 00 
  8c3dff:	49 83 c0 14          	add    $0x14,%r8
  8c3e03:	4c 89 04 0a          	mov    %r8,(%rdx,%rcx,1)
  8c3e07:	48 c7 44 0a 08 01 00 	movq   $0x1,0x8(%rdx,%rcx,1)
  8c3e0e:	00 00 
  8c3e10:	e9 29 01 00 00       	jmp    8c3f3e <check_lower_drain+0x1f0e>
  8c3e15:	41 83 fa 10          	cmp    $0x10,%r10d
  8c3e19:	0f 85 2b f4 ff ff    	jne    8c324a <check_lower_drain+0x121a>
  8c3e1f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  8c3e24:	c1 ea 03             	shr    $0x3,%edx
  8c3e27:	3b 54 24 3c          	cmp    0x3c(%rsp),%edx
  8c3e2b:	0f 82 05 f4 ff ff    	jb     8c3236 <check_lower_drain+0x1206>
  8c3e31:	e9 14 f4 ff ff       	jmp    8c324a <check_lower_drain+0x121a>
  8c3e36:	85 c0                	test   %eax,%eax
  8c3e38:	ba 08 00 00 00       	mov    $0x8,%edx
  8c3e3d:	49 89 f6             	mov    %rsi,%r14
  8c3e40:	48 89 fb             	mov    %rdi,%rbx
  8c3e43:	44 0f 45 c2          	cmovne %edx,%r8d
  8c3e47:	ba 01 00 00 00       	mov    $0x1,%edx
  8c3e4c:	83 e1 01             	and    $0x1,%ecx
  8c3e4f:	c5 f8 77             	vzeroupper
  8c3e52:	e8 69 ba 00 00       	call   8cf8c0 <check_lower_operand>
  8c3e57:	48 89 df             	mov    %rbx,%rdi
  8c3e5a:	44 89 f6             	mov    %r14d,%esi
  8c3e5d:	31 d2                	xor    %edx,%edx
  8c3e5f:	31 c9                	xor    %ecx,%ecx
  8c3e61:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c3e67:	e9 ae e9 ff ff       	jmp    8c281a <check_lower_drain+0x7ea>
  8c3e6c:	41 8d 53 eb          	lea    -0x15(%r11),%edx
  8c3e70:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  8c3e75:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8c3e7a:	83 fa 02             	cmp    $0x2,%edx
  8c3e7d:	0f 87 9f 04 00 00    	ja     8c4322 <check_lower_drain+0x22f2>
  8c3e83:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8c3e88:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  8c3e8d:	44 89 d8             	mov    %r11d,%eax
  8c3e90:	83 f0 17             	xor    $0x17,%eax
  8c3e93:	4c 89 dd             	mov    %r11,%rbp
  8c3e96:	c6 84 24 c0 01 00 00 	movb   $0x0,0x1c0(%rsp)
  8c3e9d:	00 
  8c3e9e:	89 d1                	mov    %edx,%ecx
  8c3ea0:	33 8c 24 80 00 00 00 	xor    0x80(%rsp),%ecx
  8c3ea7:	09 c1                	or     %eax,%ecx
  8c3ea9:	48 8d 8c 24 c0 01 00 	lea    0x1c0(%rsp),%rcx
  8c3eb0:	00 
  8c3eb1:	0f 94 c3             	sete   %bl
  8c3eb4:	c5 f8 77             	vzeroupper
  8c3eb7:	e8 b4 86 fc ff       	call   88c570 <check_program_runtime_truth>
  8c3ebc:	84 c0                	test   %al,%al
  8c3ebe:	0f 84 7c 0a 00 00    	je     8c4940 <check_lower_drain+0x2910>
  8c3ec4:	83 fd 17             	cmp    $0x17,%ebp
  8c3ec7:	0f 85 0d 0d 00 00    	jne    8c4bda <check_lower_drain+0x2baa>
  8c3ecd:	44 0f b6 b4 24 c0 01 	movzbl 0x1c0(%rsp),%r14d
  8c3ed4:	00 00 
  8c3ed6:	45 8b 45 00          	mov    0x0(%r13),%r8d
  8c3eda:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c3edf:	ba 02 00 00 00       	mov    $0x2,%edx
  8c3ee4:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c3ee9:	31 c9                	xor    %ecx,%ecx
  8c3eeb:	44 29 f2             	sub    %r14d,%edx
  8c3eee:	e9 dc 10 00 00       	jmp    8c4fcf <check_lower_drain+0x2f9f>
  8c3ef3:	45 84 ff             	test   %r15b,%r15b
  8c3ef6:	0f 84 bc 04 00 00    	je     8c43b8 <check_lower_drain+0x2388>
  8c3efc:	41 0f b6 d7          	movzbl %r15b,%edx
  8c3f00:	be 23 00 00 00       	mov    $0x23,%esi
  8c3f05:	4c 89 d7             	mov    %r10,%rdi
  8c3f08:	31 c9                	xor    %ecx,%ecx
  8c3f0a:	c5 f8 77             	vzeroupper
  8c3f0d:	e8 ee 1f 00 00       	call   8c5f00 <check_lower_emit>
  8c3f12:	e9 01 fd ff ff       	jmp    8c3c18 <check_lower_drain+0x1be8>
  8c3f17:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c3f1b:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c3f22:	75 1a                	jne    8c3f3e <check_lower_drain+0x1f0e>
  8c3f24:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c3f2b:	00 00 00 
  8c3f2e:	8b 8f 64 01 00 00    	mov    0x164(%rdi),%ecx
  8c3f34:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8c3f38:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c3f3e:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8c3f44:	3b 8f 40 01 00 00    	cmp    0x140(%rdi),%ecx
  8c3f4a:	73 2c                	jae    8c3f78 <check_lower_drain+0x1f48>
  8c3f4c:	48 8b 57 18          	mov    0x18(%rdi),%rdx
  8c3f50:	44 8d 41 01          	lea    0x1(%rcx),%r8d
  8c3f54:	48 c1 e8 03          	shr    $0x3,%rax
  8c3f58:	48 c1 e1 04          	shl    $0x4,%rcx
  8c3f5c:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c3f63:	49 b8 01 00 00 00 01 	movabs $0x8000100000001,%r8
  8c3f6a:	00 08 00 
  8c3f6d:	4c 89 04 0a          	mov    %r8,(%rdx,%rcx,1)
  8c3f71:	48 89 44 0a 08       	mov    %rax,0x8(%rdx,%rcx,1)
  8c3f76:	eb 27                	jmp    8c3f9f <check_lower_drain+0x1f6f>
  8c3f78:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c3f7c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3f83:	75 1a                	jne    8c3f9f <check_lower_drain+0x1f6f>
  8c3f85:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c3f8c:	00 00 00 
  8c3f8f:	8b 87 64 01 00 00    	mov    0x164(%rdi),%eax
  8c3f95:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c3f99:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c3f9f:	31 c9                	xor    %ecx,%ecx
  8c3fa1:	41 83 f9 20          	cmp    $0x20,%r9d
  8c3fa5:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
  8c3faa:	0f 94 c1             	sete   %cl
  8c3fad:	31 d2                	xor    %edx,%edx
  8c3faf:	e8 0c b9 00 00       	call   8cf8c0 <check_lower_operand>
  8c3fb4:	e9 ca e0 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c3fb9:	31 ed                	xor    %ebp,%ebp
  8c3fbb:	4d 8b 21             	mov    (%r9),%r12
  8c3fbe:	c5 f9 7e c1          	vmovd  %xmm0,%ecx
  8c3fc2:	44 0f b6 c9          	movzbl %cl,%r9d
  8c3fc6:	4c 89 4c 24 78       	mov    %r9,0x78(%rsp)
  8c3fcb:	41 ff c9             	dec    %r9d
  8c3fce:	41 83 f9 0a          	cmp    $0xa,%r9d
  8c3fd2:	41 0f 93 c6          	setae  %r14b
  8c3fd6:	f7 c1 00 05 00 00    	test   $0x500,%ecx
  8c3fdc:	49 8b 04 24          	mov    (%r12),%rax
  8c3fe0:	41 0f 95 c3          	setne  %r11b
  8c3fe4:	45 08 f3             	or     %r14b,%r11b
  8c3fe7:	0f 85 f1 16 00 00    	jne    8c56de <check_lower_drain+0x36ae>
  8c3fed:	48 03 b4 24 80 00 00 	add    0x80(%rsp),%rsi
  8c3ff4:	00 
  8c3ff5:	83 7e 44 00          	cmpl   $0x0,0x44(%rsi)
  8c3ff9:	0f 85 df 16 00 00    	jne    8c56de <check_lower_drain+0x36ae>
  8c3fff:	4c 8b 5c 24 48       	mov    0x48(%rsp),%r11
  8c4004:	46 8b 1c 98          	mov    (%rax,%r11,4),%r11d
  8c4008:	45 85 db             	test   %r11d,%r11d
  8c400b:	44 89 5c 24 48       	mov    %r11d,0x48(%rsp)
  8c4010:	41 0f 94 c3          	sete   %r11b
  8c4014:	41 20 eb             	and    %bpl,%r11b
  8c4017:	41 80 fb 01          	cmp    $0x1,%r11b
  8c401b:	75 36                	jne    8c4053 <check_lower_drain+0x2023>
  8c401d:	4d 8b 9c 24 90 02 00 	mov    0x290(%r12),%r11
  8c4024:	00 
  8c4025:	45 8d 72 ff          	lea    -0x1(%r10),%r14d
  8c4029:	4c 89 b4 24 88 00 00 	mov    %r14,0x88(%rsp)
  8c4030:	00 
  8c4031:	43 80 3c 33 00       	cmpb   $0x0,(%r11,%r14,1)
  8c4036:	74 1b                	je     8c4053 <check_lower_drain+0x2023>
  8c4038:	4d 8b 9c 24 78 02 00 	mov    0x278(%r12),%r11
  8c403f:	00 
  8c4040:	4c 8b b4 24 88 00 00 	mov    0x88(%rsp),%r14
  8c4047:	00 
  8c4048:	43 80 3c 33 00       	cmpb   $0x0,(%r11,%r14,1)
  8c404d:	0f 84 8b 16 00 00    	je     8c56de <check_lower_drain+0x36ae>
  8c4053:	44 8b 5e 0c          	mov    0xc(%rsi),%r11d
  8c4057:	44 89 9c 24 88 00 00 	mov    %r11d,0x88(%rsp)
  8c405e:	00 
  8c405f:	45 85 db             	test   %r11d,%r11d
  8c4062:	74 1e                	je     8c4082 <check_lower_drain+0x2052>
  8c4064:	83 7e 54 00          	cmpl   $0x0,0x54(%rsi)
  8c4068:	75 18                	jne    8c4082 <check_lower_drain+0x2052>
  8c406a:	44 0f b7 5e 08       	movzwl 0x8(%rsi),%r11d
  8c406f:	41 f7 c3 10 08 00 00 	test   $0x810,%r11d
  8c4076:	75 0a                	jne    8c4082 <check_lower_drain+0x2052>
  8c4078:	83 7e 04 00          	cmpl   $0x0,0x4(%rsi)
  8c407c:	0f 84 38 16 00 00    	je     8c56ba <check_lower_drain+0x368a>
  8c4082:	83 7c 24 48 00       	cmpl   $0x0,0x48(%rsp)
  8c4087:	0f 85 51 16 00 00    	jne    8c56de <check_lower_drain+0x36ae>
  8c408d:	83 7e 04 01          	cmpl   $0x1,0x4(%rsi)
  8c4091:	0f 94 c1             	sete   %cl
  8c4094:	40 20 e9             	and    %bpl,%cl
  8c4097:	80 f9 01             	cmp    $0x1,%cl
  8c409a:	0f 85 3e 16 00 00    	jne    8c56de <check_lower_drain+0x36ae>
  8c40a0:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c40a5:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8c40aa:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  8c40ae:	46 8b 34 91          	mov    (%rcx,%r10,4),%r14d
  8c40b2:	48 8b 8e 80 00 00 00 	mov    0x80(%rsi),%rcx
  8c40b9:	42 8b 0c 91          	mov    (%rcx,%r10,4),%ecx
  8c40bd:	85 c9                	test   %ecx,%ecx
  8c40bf:	40 0f 94 c6          	sete   %sil
  8c40c3:	45 31 c9             	xor    %r9d,%r9d
  8c40c6:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  8c40ca:	41 0f 94 c1          	sete   %r9b
  8c40ce:	44 0f 44 f1          	cmove  %ecx,%r14d
  8c40d2:	43 8d 4c 09 02       	lea    0x2(%r9,%r9,1),%ecx
  8c40d7:	44 20 ce             	and    %r9b,%sil
  8c40da:	89 4c 24 48          	mov    %ecx,0x48(%rsp)
  8c40de:	40 08 f3             	or     %sil,%bl
  8c40e1:	0f 84 98 12 00 00    	je     8c537f <check_lower_drain+0x334f>
  8c40e7:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  8c40ec:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c40f1:	40 84 f6             	test   %sil,%sil
  8c40f4:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c40f9:	0f 85 44 e3 ff ff    	jne    8c2443 <check_lower_drain+0x413>
  8c40ff:	31 db                	xor    %ebx,%ebx
  8c4101:	45 31 db             	xor    %r11d,%r11d
  8c4104:	44 8b 4c 24 48       	mov    0x48(%rsp),%r9d
  8c4109:	41 c1 e8 10          	shr    $0x10,%r8d
  8c410d:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c4112:	41 0f b6 c0          	movzbl %r8b,%eax
  8c4116:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8c411c:	89 c1                	mov    %eax,%ecx
  8c411e:	c1 e1 10             	shl    $0x10,%ecx
  8c4121:	3d ff 00 00 00       	cmp    $0xff,%eax
  8c4126:	41 0f 44 c8          	cmove  %r8d,%ecx
  8c412a:	0f 95 c0             	setne  %al
  8c412d:	c1 e7 08             	shl    $0x8,%edi
  8c4130:	0f b7 f7             	movzwl %di,%esi
  8c4133:	41 09 c9             	or     %ecx,%r9d
  8c4136:	41 09 d9             	or     %ebx,%r9d
  8c4139:	83 7c 24 3c 10       	cmpl   $0x10,0x3c(%rsp)
  8c413e:	c4 c1 79 6e c1       	vmovd  %r9d,%xmm0
  8c4143:	0f 92 c1             	setb   %cl
  8c4146:	41 0f 43 f0          	cmovae %r8d,%esi
  8c414a:	c1 e2 10             	shl    $0x10,%edx
  8c414d:	c0 e0 02             	shl    $0x2,%al
  8c4150:	09 f2                	or     %esi,%edx
  8c4152:	03 54 24 78          	add    0x78(%rsp),%edx
  8c4156:	00 c9                	add    %cl,%cl
  8c4158:	40 b6 ff             	mov    $0xff,%sil
  8c415b:	08 c8                	or     %cl,%al
  8c415d:	fe c0                	inc    %al
  8c415f:	0f b6 c0             	movzbl %al,%eax
  8c4162:	f3 0f b8 c8          	popcnt %eax,%ecx
  8c4166:	c5 fb 92 c8          	kmovd  %eax,%k1
  8c416a:	49 8b 42 20          	mov    0x20(%r10),%rax
  8c416e:	c5 f9 6e ca          	vmovd  %edx,%xmm1
  8c4172:	41 8b 92 38 01 00 00 	mov    0x138(%r10),%edx
  8c4179:	40 d2 e6             	shl    %cl,%sil
  8c417c:	62 f2 7d 89 63 c0    	vpcompressb %xmm0,%xmm0{%k1}{z}
  8c4182:	40 f6 d6             	not    %sil
  8c4185:	62 f2 7d 89 63 c9    	vpcompressb %xmm1,%xmm1{%k1}{z}
  8c418b:	c5 fb 92 ce          	kmovd  %esi,%k1
  8c418f:	c5 f9 90 d1          	kmovb  %k1,%k2
  8c4193:	62 f1 7f 0a 7f 04 10 	vmovdqu8 %xmm0,(%rax,%rdx,1){%k2}
  8c419a:	c4 c1 f9 6e c3       	vmovq  %r11,%xmm0
  8c419f:	49 8b 42 28          	mov    0x28(%r10),%rax
  8c41a3:	41 8b 92 38 01 00 00 	mov    0x138(%r10),%edx
  8c41aa:	62 f1 7f 0a 7f 0c 10 	vmovdqu8 %xmm1,(%rax,%rdx,1){%k2}
  8c41b1:	c4 c1 f9 6e ce       	vmovq  %r14,%xmm1
  8c41b6:	49 8b 42 30          	mov    0x30(%r10),%rax
  8c41ba:	41 8b 92 38 01 00 00 	mov    0x138(%r10),%edx
  8c41c1:	c5 f1 6c c0          	vpunpcklqdq %xmm0,%xmm1,%xmm0
  8c41c5:	62 f1 fe 29 7f 04 d0 	vmovdqu64 %ymm0,(%rax,%rdx,8){%k1}
  8c41cc:	41 01 8a 38 01 00 00 	add    %ecx,0x138(%r10)
  8c41d3:	8b 4c 24 60          	mov    0x60(%rsp),%ecx
  8c41d7:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c41db:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c41de:	41 89 82 64 01 00 00 	mov    %eax,0x164(%r10)
  8c41e5:	8b 44 24 50          	mov    0x50(%rsp),%eax
  8c41e9:	62 f2 fd 08 7c c0    	vpbroadcastq %rax,%xmm0
  8c41ef:	c4 c1 79 d4 82 00 02 	vpaddq 0x200(%r10),%xmm0,%xmm0
  8c41f6:	00 00 
  8c41f8:	c4 c1 7a 7f 82 00 02 	vmovdqu %xmm0,0x200(%r10)
  8c41ff:	00 00 
  8c4201:	e9 85 de ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c4206:	49 8b 4c 24 38       	mov    0x38(%r12),%rcx
  8c420b:	42 81 3c b9 30 01 00 	cmpl   $0x130,(%rcx,%r15,4)
  8c4212:	00 
  8c4213:	75 20                	jne    8c4235 <check_lower_drain+0x2205>
  8c4215:	31 c9                	xor    %ecx,%ecx
  8c4217:	41 83 bd 8c 00 00 00 	cmpl   $0x2,0x8c(%r13)
  8c421e:	02 
  8c421f:	0f 94 c2             	sete   %dl
  8c4222:	83 fd 01             	cmp    $0x1,%ebp
  8c4225:	0f 85 36 fb ff ff    	jne    8c3d61 <check_lower_drain+0x1d31>
  8c422b:	88 d1                	mov    %dl,%cl
  8c422d:	39 cb                	cmp    %ecx,%ebx
  8c422f:	0f 85 2c fb ff ff    	jne    8c3d61 <check_lower_drain+0x1d31>
  8c4235:	48 8d 8c 24 c2 00 00 	lea    0xc2(%rsp),%rcx
  8c423c:	00 
  8c423d:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c4241:	c5 fa 7f 41 f6       	vmovdqu %xmm0,-0xa(%rcx)
  8c4246:	48 c7 41 06 00 00 00 	movq   $0x0,0x6(%rcx)
  8c424d:	00 
  8c424e:	c7 84 24 b0 00 00 00 	movl   $0xb,0xb0(%rsp)
  8c4255:	0b 00 00 00 
  8c4259:	89 84 24 b4 00 00 00 	mov    %eax,0xb4(%rsp)
  8c4260:	c5 fe 6f 84 24 b0 00 	vmovdqu 0xb0(%rsp),%ymm0
  8c4267:	00 00 
  8c4269:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c426e:	c5 f8 77             	vzeroupper
  8c4271:	e8 8a 5f 00 00       	call   8ca200 <check_lower_push>
  8c4276:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c427b:	85 ed                	test   %ebp,%ebp
  8c427d:	75 0d                	jne    8c428c <check_lower_drain+0x225c>
  8c427f:	e9 ff dd ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c4284:	85 ed                	test   %ebp,%ebp
  8c4286:	0f 84 f7 dd ff ff    	je     8c2083 <check_lower_drain+0x53>
  8c428c:	89 ea                	mov    %ebp,%edx
  8c428e:	8d 6a ff             	lea    -0x1(%rdx),%ebp
  8c4291:	83 fa 20             	cmp    $0x20,%edx
  8c4294:	77 ee                	ja     8c4284 <check_lower_drain+0x2254>
  8c4296:	0f a3 eb             	bt     %ebp,%ebx
  8c4299:	73 e9                	jae    8c4284 <check_lower_drain+0x2254>
  8c429b:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c42a0:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c42a6:	83 c2 02             	add    $0x2,%edx
  8c42a9:	44 89 f6             	mov    %r14d,%esi
  8c42ac:	31 c9                	xor    %ecx,%ecx
  8c42ae:	e8 0d b6 00 00       	call   8cf8c0 <check_lower_operand>
  8c42b3:	eb cf                	jmp    8c4284 <check_lower_drain+0x2254>
  8c42b5:	44 89 e0             	mov    %r12d,%eax
  8c42b8:	24 0e                	and    $0xe,%al
  8c42ba:	3c 0c                	cmp    $0xc,%al
  8c42bc:	0f 85 5d 06 00 00    	jne    8c491f <check_lower_drain+0x28ef>
  8c42c2:	41 8d 47 f7          	lea    -0x9(%r15),%eax
  8c42c6:	3c 02                	cmp    $0x2,%al
  8c42c8:	0f 87 51 06 00 00    	ja     8c491f <check_lower_drain+0x28ef>
  8c42ce:	31 c0                	xor    %eax,%eax
  8c42d0:	41 80 ff 0a          	cmp    $0xa,%r15b
  8c42d4:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c42d9:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c42de:	41 0f b6 ec          	movzbl %r12b,%ebp
  8c42e2:	0f 95 c0             	setne  %al
  8c42e5:	41 80 ff 09          	cmp    $0x9,%r15b
  8c42e9:	89 ee                	mov    %ebp,%esi
  8c42eb:	8d 04 c5 a0 00 00 00 	lea    0xa0(,%rax,8),%eax
  8c42f2:	0f 44 c1             	cmove  %ecx,%eax
  8c42f5:	48 89 df             	mov    %rbx,%rdi
  8c42f8:	89 84 24 b0 00 00 00 	mov    %eax,0xb0(%rsp)
  8c42ff:	c5 f8 77             	vzeroupper
  8c4302:	e8 29 a2 ff ff       	call   8be530 <check_lower_temporary>
  8c4307:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c430b:	41 89 c6             	mov    %eax,%r14d
  8c430e:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4315:	0f 84 9d 0a 00 00    	je     8c4db8 <check_lower_drain+0x2d88>
  8c431b:	31 c9                	xor    %ecx,%ecx
  8c431d:	e9 e1 0a 00 00       	jmp    8c4e03 <check_lower_drain+0x2dd3>
  8c4322:	4c 89 5c 24 68       	mov    %r11,0x68(%rsp)
  8c4327:	41 83 fb 38          	cmp    $0x38,%r11d
  8c432b:	0f 84 1c 07 00 00    	je     8c4a4d <check_lower_drain+0x2a1d>
  8c4331:	83 7c 24 68 22       	cmpl   $0x22,0x68(%rsp)
  8c4336:	0f 85 28 07 00 00    	jne    8c4a64 <check_lower_drain+0x2a34>
  8c433c:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4341:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4346:	c5 f8 77             	vzeroupper
  8c4349:	e8 f2 f4 00 00       	call   8d3840 <check_lower_call>
  8c434e:	e9 2b dd ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c4353:	41 8d 47 ff          	lea    -0x1(%r15),%eax
  8c4357:	3c 03                	cmp    $0x3,%al
  8c4359:	77 1c                	ja     8c4377 <check_lower_drain+0x2347>
  8c435b:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4360:	be 09 00 00 00       	mov    $0x9,%esi
  8c4365:	ba 05 00 00 00       	mov    $0x5,%edx
  8c436a:	31 c9                	xor    %ecx,%ecx
  8c436c:	c5 f8 77             	vzeroupper
  8c436f:	e8 8c 1b 00 00       	call   8c5f00 <check_lower_emit>
  8c4374:	41 b7 05             	mov    $0x5,%r15b
  8c4377:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c437c:	41 0f b6 d7          	movzbl %r15b,%edx
  8c4380:	be 01 00 00 00       	mov    $0x1,%esi
  8c4385:	31 c9                	xor    %ecx,%ecx
  8c4387:	48 89 df             	mov    %rbx,%rdi
  8c438a:	c5 f8 77             	vzeroupper
  8c438d:	e8 6e 1b 00 00       	call   8c5f00 <check_lower_emit>
  8c4392:	be 17 00 00 00       	mov    $0x17,%esi
  8c4397:	ba 05 00 00 00       	mov    $0x5,%edx
  8c439c:	48 89 df             	mov    %rbx,%rdi
  8c439f:	31 c9                	xor    %ecx,%ecx
  8c43a1:	e8 5a 1b 00 00       	call   8c5f00 <check_lower_emit>
  8c43a6:	48 89 df             	mov    %rbx,%rdi
  8c43a9:	be 09 00 00 00       	mov    $0x9,%esi
  8c43ae:	ba 02 00 00 00       	mov    $0x2,%edx
  8c43b3:	e9 81 05 00 00       	jmp    8c4939 <check_lower_drain+0x2909>
  8c43b8:	4d 89 ec             	mov    %r13,%r12
  8c43bb:	e9 cb dc ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c43c0:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
  8c43c5:	48 89 cb             	mov    %rcx,%rbx
  8c43c8:	4d 85 f6             	test   %r14,%r14
  8c43cb:	0f 84 7e 09 00 00    	je     8c4d4f <check_lower_drain+0x2d1f>
  8c43d1:	49 81 fe 01 01 00 00 	cmp    $0x101,%r14
  8c43d8:	0f 93 c0             	setae  %al
  8c43db:	08 d8                	or     %bl,%al
  8c43dd:	a8 01                	test   $0x1,%al
  8c43df:	0f 84 52 0a 00 00    	je     8c4e37 <check_lower_drain+0x2e07>
  8c43e5:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c43ea:	be 08 00 00 00       	mov    $0x8,%esi
  8c43ef:	c5 f8 77             	vzeroupper
  8c43f2:	e8 39 a1 ff ff       	call   8be530 <check_lower_temporary>
  8c43f7:	89 c5                	mov    %eax,%ebp
  8c43f9:	f6 c3 01             	test   $0x1,%bl
  8c43fc:	0f 84 88 0d 00 00    	je     8c518a <check_lower_drain+0x315a>
  8c4402:	4c 8b 7c 24 20       	mov    0x20(%rsp),%r15
  8c4407:	be 08 00 00 00       	mov    $0x8,%esi
  8c440c:	4c 89 ff             	mov    %r15,%rdi
  8c440f:	e8 1c a1 ff ff       	call   8be530 <check_lower_temporary>
  8c4414:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c4419:	ba 08 00 00 00       	mov    $0x8,%edx
  8c441e:	41 89 ec             	mov    %ebp,%r12d
  8c4421:	41 89 c5             	mov    %eax,%r13d
  8c4424:	4c 89 ff             	mov    %r15,%rdi
  8c4427:	4c 89 e1             	mov    %r12,%rcx
  8c442a:	e8 d1 1a 00 00       	call   8c5f00 <check_lower_emit>
  8c442f:	be 1e 00 00 00       	mov    $0x1e,%esi
  8c4434:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4439:	4c 89 ff             	mov    %r15,%rdi
  8c443c:	4c 89 e9             	mov    %r13,%rcx
  8c443f:	4c 89 6c 24 40       	mov    %r13,0x40(%rsp)
  8c4444:	e9 60 0d 00 00       	jmp    8c51a9 <check_lower_drain+0x3179>
  8c4449:	48 89 f0             	mov    %rsi,%rax
  8c444c:	48 c1 e8 20          	shr    $0x20,%rax
  8c4450:	48 bf 00 00 00 00 ff 	movabs $0xff00000000,%rdi
  8c4457:	00 00 00 
  8c445a:	48 89 f1             	mov    %rsi,%rcx
  8c445d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8c4463:	48 21 f9             	and    %rdi,%rcx
  8c4466:	fe c8                	dec    %al
  8c4468:	bf 01 12 08 00       	mov    $0x81201,%edi
  8c446d:	c4 e2 7b f7 ff       	shrx   %eax,%edi,%edi
  8c4472:	40 f6 c7 01          	test   $0x1,%dil
  8c4476:	44 89 f7             	mov    %r14d,%edi
  8c4479:	41 0f 45 f8          	cmovne %r8d,%edi
  8c447d:	3c 14                	cmp    $0x14,%al
  8c447f:	48 b8 00 00 00 00 01 	movabs $0x100000000,%rax
  8c4486:	00 00 00 
  8c4489:	41 0f 43 fe          	cmovae %r14d,%edi
  8c448d:	48 39 c1             	cmp    %rax,%rcx
  8c4490:	0f 45 d7             	cmovne %edi,%edx
  8c4493:	4c 89 d7             	mov    %r10,%rdi
  8c4496:	c5 f8 77             	vzeroupper
  8c4499:	e8 82 93 00 00       	call   8cd820 <check_lower_varargs_emit>
  8c449e:	e9 e3 db ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c44a3:	49 8b 02             	mov    (%r10),%rax
  8c44a6:	89 f1                	mov    %esi,%ecx
  8c44a8:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c44af:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c44b3:	48 8b 40 68          	mov    0x68(%rax),%rax
  8c44b7:	48 8d 74 08 10       	lea    0x10(%rax,%rcx,1),%rsi
  8c44bc:	4c 89 d7             	mov    %r10,%rdi
  8c44bf:	c5 f8 77             	vzeroupper
  8c44c2:	e8 19 6b 00 00       	call   8cafe0 <check_lower_constant>
  8c44c7:	e9 ba db ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c44cc:	41 8b 9a 74 01 00 00 	mov    0x174(%r10),%ebx
  8c44d3:	89 d8                	mov    %ebx,%eax
  8c44d5:	85 db                	test   %ebx,%ebx
  8c44d7:	0f 84 aa 08 00 00    	je     8c4d87 <check_lower_drain+0x2d57>
  8c44dd:	49 8b 4a 60          	mov    0x60(%r10),%rcx
  8c44e1:	41 89 c6             	mov    %eax,%r14d
  8c44e4:	be 23 00 00 00       	mov    $0x23,%esi
  8c44e9:	4c 89 d7             	mov    %r10,%rdi
  8c44ec:	42 0f b6 14 31       	movzbl (%rcx,%r14,1),%edx
  8c44f1:	31 c9                	xor    %ecx,%ecx
  8c44f3:	c5 f8 77             	vzeroupper
  8c44f6:	e8 05 1a 00 00       	call   8c5f00 <check_lower_emit>
  8c44fb:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c4500:	49 8b 42 58          	mov    0x58(%r10),%rax
  8c4504:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c4508:	85 c0                	test   %eax,%eax
  8c450a:	75 d1                	jne    8c44dd <check_lower_drain+0x24ad>
  8c450c:	4c 89 d7             	mov    %r10,%rdi
  8c450f:	e8 6c 6a 00 00       	call   8caf80 <check_lower_label>
  8c4514:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4519:	89 c6                	mov    %eax,%esi
  8c451b:	89 c5                	mov    %eax,%ebp
  8c451d:	e8 8e 19 00 00       	call   8c5eb0 <check_lower_place>
  8c4522:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4527:	be 26 00 00 00       	mov    $0x26,%esi
  8c452c:	89 e9                	mov    %ebp,%ecx
  8c452e:	31 d2                	xor    %edx,%edx
  8c4530:	e8 cb 19 00 00       	call   8c5f00 <check_lower_emit>
  8c4535:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c453a:	49 8b 42 60          	mov    0x60(%r10),%rax
  8c453e:	89 db                	mov    %ebx,%ebx
  8c4540:	be 01 00 00 00       	mov    $0x1,%esi
  8c4545:	4c 89 d7             	mov    %r10,%rdi
  8c4548:	31 c9                	xor    %ecx,%ecx
  8c454a:	0f b6 14 18          	movzbl (%rax,%rbx,1),%edx
  8c454e:	e8 fd 1e 00 00       	call   8c6450 <check_lower_instruction>
  8c4553:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c4558:	49 8b 42 58          	mov    0x58(%r10),%rax
  8c455c:	8b 1c 98             	mov    (%rax,%rbx,4),%ebx
  8c455f:	85 db                	test   %ebx,%ebx
  8c4561:	75 d7                	jne    8c453a <check_lower_drain+0x250a>
  8c4563:	e9 23 db ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c4568:	4c 89 d7             	mov    %r10,%rdi
  8c456b:	44 89 f6             	mov    %r14d,%esi
  8c456e:	c5 f8 77             	vzeroupper
  8c4571:	e8 0a 92 00 00       	call   8cd780 <check_lower_bit_read>
  8c4576:	e9 0b db ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c457b:	4c 89 d7             	mov    %r10,%rdi
  8c457e:	4c 89 f2             	mov    %r14,%rdx
  8c4581:	c5 f8 77             	vzeroupper
  8c4584:	e8 a7 77 00 00       	call   8cbd30 <check_lower_address>
  8c4589:	e9 f8 da ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c458e:	49 8b 02             	mov    (%r10),%rax
  8c4591:	89 f1                	mov    %esi,%ecx
  8c4593:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c4597:	44 89 f2             	mov    %r14d,%edx
  8c459a:	48 69 f2 b0 00 00 00 	imul   $0xb0,%rdx,%rsi
  8c45a1:	49 c1 ee 20          	shr    $0x20,%r14
  8c45a5:	4c 89 d7             	mov    %r10,%rdi
  8c45a8:	48 c1 e1 04          	shl    $0x4,%rcx
  8c45ac:	48 8b 40 28          	mov    0x28(%rax),%rax
  8c45b0:	48 8b 00             	mov    (%rax),%rax
  8c45b3:	48 03 74 08 10       	add    0x10(%rax,%rcx,1),%rsi
  8c45b8:	eb 4a                	jmp    8c4604 <check_lower_drain+0x25d4>
  8c45ba:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c45be:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xb0(%rsp)
  8c45c5:	b0 00 00 00 
  8c45c9:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x120(%rsp)
  8c45d0:	20 01 00 00 
  8c45d4:	44 89 f0             	mov    %r14d,%eax
  8c45d7:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xf0(%rsp)
  8c45de:	f0 00 00 00 
  8c45e2:	c7 84 24 b0 00 00 00 	movl   $0x2,0xb0(%rsp)
  8c45e9:	02 00 00 00 
  8c45ed:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  8c45f4:	00 
  8c45f5:	49 c1 ee 20          	shr    $0x20,%r14
  8c45f9:	4c 89 d7             	mov    %r10,%rdi
  8c45fc:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  8c4603:	00 
  8c4604:	44 89 f2             	mov    %r14d,%edx
  8c4607:	c5 f8 77             	vzeroupper
  8c460a:	e8 41 82 00 00       	call   8cc850 <check_lower_fill>
  8c460f:	e9 72 da ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c4614:	b8 03 06 00 00       	mov    $0x603,%eax
  8c4619:	44 89 f5             	mov    %r14d,%ebp
  8c461c:	c1 ed 09             	shr    $0x9,%ebp
  8c461f:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  8c4624:	45 89 f5             	mov    %r14d,%r13d
  8c4627:	41 83 e5 07          	and    $0x7,%r13d
  8c462b:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  8c4632:	00 00 00 00 00 
  8c4637:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
  8c463c:	be 08 00 00 00       	mov    $0x8,%esi
  8c4641:	4c 89 d7             	mov    %r10,%rdi
  8c4644:	c4 c2 78 f7 ce       	bextr  %eax,%r14d,%ecx
  8c4649:	44 89 f0             	mov    %r14d,%eax
  8c464c:	c1 e8 0d             	shr    $0xd,%eax
  8c464f:	40 80 e5 0f          	and    $0xf,%bpl
  8c4653:	44 89 ac 24 b8 00 00 	mov    %r13d,0xb8(%rsp)
  8c465a:	00 
  8c465b:	44 8d 79 01          	lea    0x1(%rcx),%r15d
  8c465f:	24 01                	and    $0x1,%al
  8c4661:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  8c4666:	48 8d 8c 24 c2 00 00 	lea    0xc2(%rsp),%rcx
  8c466d:	00 
  8c466e:	44 89 bc 24 bc 00 00 	mov    %r15d,0xbc(%rsp)
  8c4675:	00 
  8c4676:	40 88 ac 24 c0 00 00 	mov    %bpl,0xc0(%rsp)
  8c467d:	00 
  8c467e:	88 84 24 c1 00 00 00 	mov    %al,0xc1(%rsp)
  8c4685:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  8c468c:	41 83 ff 40          	cmp    $0x40,%r15d
  8c4690:	66 c7 41 04 00 00    	movw   $0x0,0x4(%rcx)
  8c4696:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c469c:	c4 62 81 f7 e0       	shlx   %r15,%rax,%r12
  8c46a1:	49 f7 d4             	not    %r12
  8c46a4:	4c 89 e3             	mov    %r12,%rbx
  8c46a7:	48 0f 44 d8          	cmove  %rax,%rbx
  8c46ab:	c5 f8 77             	vzeroupper
  8c46ae:	e8 7d 9e ff ff       	call   8be530 <check_lower_temporary>
  8c46b3:	89 44 24 58          	mov    %eax,0x58(%rsp)
  8c46b7:	40 80 fd 08          	cmp    $0x8,%bpl
  8c46bb:	74 16                	je     8c46d3 <check_lower_drain+0x26a3>
  8c46bd:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c46c2:	be 09 00 00 00       	mov    $0x9,%esi
  8c46c7:	ba 08 00 00 00       	mov    $0x8,%edx
  8c46cc:	31 c9                	xor    %ecx,%ecx
  8c46ce:	e8 2d 18 00 00       	call   8c5f00 <check_lower_emit>
  8c46d3:	41 83 ff 40          	cmp    $0x40,%r15d
  8c46d7:	74 2e                	je     8c4707 <check_lower_drain+0x26d7>
  8c46d9:	4c 8b 7c 24 20       	mov    0x20(%rsp),%r15
  8c46de:	be 01 00 00 00       	mov    $0x1,%esi
  8c46e3:	ba 08 00 00 00       	mov    $0x8,%edx
  8c46e8:	4c 89 e1             	mov    %r12,%rcx
  8c46eb:	4c 89 ff             	mov    %r15,%rdi
  8c46ee:	e8 0d 18 00 00       	call   8c5f00 <check_lower_emit>
  8c46f3:	be 10 00 00 00       	mov    $0x10,%esi
  8c46f8:	ba 08 00 00 00       	mov    $0x8,%edx
  8c46fd:	4c 89 ff             	mov    %r15,%rdi
  8c4700:	31 c9                	xor    %ecx,%ecx
  8c4702:	e8 f9 17 00 00       	call   8c5f00 <check_lower_emit>
  8c4707:	4c 89 f0             	mov    %r14,%rax
  8c470a:	48 c1 e8 20          	shr    $0x20,%rax
  8c470e:	8b 4c 24 58          	mov    0x58(%rsp),%ecx
  8c4712:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4717:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c471c:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4721:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8c4726:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c472b:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  8c4730:	41 8d 6c 05 08       	lea    0x8(%r13,%rax,1),%ebp
  8c4735:	c1 ed 03             	shr    $0x3,%ebp
  8c4738:	f3 44 0f b8 e5       	popcnt %ebp,%r12d
  8c473d:	e8 be 17 00 00       	call   8c5f00 <check_lower_emit>
  8c4742:	41 83 fc 01          	cmp    $0x1,%r12d
  8c4746:	77 19                	ja     8c4761 <check_lower_drain+0x2731>
  8c4748:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c474d:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c4752:	be 02 00 00 00       	mov    $0x2,%esi
  8c4757:	ba 08 00 00 00       	mov    $0x8,%edx
  8c475c:	e8 9f 17 00 00       	call   8c5f00 <check_lower_emit>
  8c4761:	4c 8b 7c 24 20       	mov    0x20(%rsp),%r15
  8c4766:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c476b:	be 02 00 00 00       	mov    $0x2,%esi
  8c4770:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4775:	4c 89 ff             	mov    %r15,%rdi
  8c4778:	e8 83 17 00 00       	call   8c5f00 <check_lower_emit>
  8c477d:	4c 89 ff             	mov    %r15,%rdi
  8c4780:	89 ee                	mov    %ebp,%esi
  8c4782:	e8 09 8a 01 00       	call   8dd190 <check_lower_bit_unit>
  8c4787:	41 83 e6 07          	and    $0x7,%r14d
  8c478b:	be 01 00 00 00       	mov    $0x1,%esi
  8c4790:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4795:	4c 89 ff             	mov    %r15,%rdi
  8c4798:	c4 e2 89 f7 cb       	shlx   %r14,%rbx,%rcx
  8c479d:	48 f7 d1             	not    %rcx
  8c47a0:	e8 5b 17 00 00       	call   8c5f00 <check_lower_emit>
  8c47a5:	be 10 00 00 00       	mov    $0x10,%esi
  8c47aa:	ba 08 00 00 00       	mov    $0x8,%edx
  8c47af:	4c 89 ff             	mov    %r15,%rdi
  8c47b2:	31 c9                	xor    %ecx,%ecx
  8c47b4:	e8 47 17 00 00       	call   8c5f00 <check_lower_emit>
  8c47b9:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c47be:	be 02 00 00 00       	mov    $0x2,%esi
  8c47c3:	ba 08 00 00 00       	mov    $0x8,%edx
  8c47c8:	4c 89 ff             	mov    %r15,%rdi
  8c47cb:	e8 30 17 00 00       	call   8c5f00 <check_lower_emit>
  8c47d0:	45 85 ed             	test   %r13d,%r13d
  8c47d3:	74 2e                	je     8c4803 <check_lower_drain+0x27d3>
  8c47d5:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c47da:	be 01 00 00 00       	mov    $0x1,%esi
  8c47df:	ba 08 00 00 00       	mov    $0x8,%edx
  8c47e4:	4c 89 f1             	mov    %r14,%rcx
  8c47e7:	48 89 df             	mov    %rbx,%rdi
  8c47ea:	e8 11 17 00 00       	call   8c5f00 <check_lower_emit>
  8c47ef:	be 13 00 00 00       	mov    $0x13,%esi
  8c47f4:	ba 08 00 00 00       	mov    $0x8,%edx
  8c47f9:	48 89 df             	mov    %rbx,%rdi
  8c47fc:	31 c9                	xor    %ecx,%ecx
  8c47fe:	e8 fd 16 00 00       	call   8c5f00 <check_lower_emit>
  8c4803:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4808:	be 11 00 00 00       	mov    $0x11,%esi
  8c480d:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4812:	31 c9                	xor    %ecx,%ecx
  8c4814:	e8 e7 16 00 00       	call   8c5f00 <check_lower_emit>
  8c4819:	41 83 fc 01          	cmp    $0x1,%r12d
  8c481d:	0f 87 86 02 00 00    	ja     8c4aa9 <check_lower_drain+0x2a79>
  8c4823:	83 fd 02             	cmp    $0x2,%ebp
  8c4826:	0f 84 71 0a 00 00    	je     8c529d <check_lower_drain+0x326d>
  8c482c:	83 fd 04             	cmp    $0x4,%ebp
  8c482f:	0f 84 64 0a 00 00    	je     8c5299 <check_lower_drain+0x3269>
  8c4835:	b3 08                	mov    $0x8,%bl
  8c4837:	83 fd 08             	cmp    $0x8,%ebp
  8c483a:	0f 84 73 0a 00 00    	je     8c52b3 <check_lower_drain+0x3283>
  8c4840:	b3 02                	mov    $0x2,%bl
  8c4842:	e9 58 0a 00 00       	jmp    8c529f <check_lower_drain+0x326f>
  8c4847:	ba 07 00 00 00       	mov    $0x7,%edx
  8c484c:	4c 89 d7             	mov    %r10,%rdi
  8c484f:	44 89 f6             	mov    %r14d,%esi
  8c4852:	c5 f8 77             	vzeroupper
  8c4855:	e8 c6 5e 00 00       	call   8ca720 <check_lower_vla_size>
  8c485a:	e9 27 d8 ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c485f:	48 89 f7             	mov    %rsi,%rdi
  8c4862:	48 c1 ef 20          	shr    $0x20,%rdi
  8c4866:	48 89 f0             	mov    %rsi,%rax
  8c4869:	40 0f b6 cf          	movzbl %dil,%ecx
  8c486d:	89 8c 24 90 00 00 00 	mov    %ecx,0x90(%rsp)
  8c4874:	89 b4 24 94 00 00 00 	mov    %esi,0x94(%rsp)
  8c487b:	40 80 ff 14          	cmp    $0x14,%dil
  8c487f:	0f 87 11 07 00 00    	ja     8c4f96 <check_lower_drain+0x2f66>
  8c4885:	be 02 24 10 00       	mov    $0x102402,%esi
  8c488a:	0f a3 ce             	bt     %ecx,%esi
  8c488d:	0f 83 03 07 00 00    	jae    8c4f96 <check_lower_drain+0x2f66>
  8c4893:	83 f9 01             	cmp    $0x1,%ecx
  8c4896:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c489b:	0f 45 d1             	cmovne %ecx,%edx
  8c489e:	89 94 24 98 00 00 00 	mov    %edx,0x98(%rsp)
  8c48a5:	c7 84 24 9c 00 00 00 	movl   $0x0,0x9c(%rsp)
  8c48ac:	00 00 00 00 
  8c48b0:	48 89 c1             	mov    %rax,%rcx
  8c48b3:	48 c1 e9 28          	shr    $0x28,%rcx
  8c48b7:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  8c48be:	00 
  8c48bf:	80 e1 01             	and    $0x1,%cl
  8c48c2:	88 8c 24 a8 00 00 00 	mov    %cl,0xa8(%rsp)
  8c48c9:	48 89 c1             	mov    %rax,%rcx
  8c48cc:	48 c1 e9 29          	shr    $0x29,%rcx
  8c48d0:	48 c1 e8 2a          	shr    $0x2a,%rax
  8c48d4:	80 e1 01             	and    $0x1,%cl
  8c48d7:	24 01                	and    $0x1,%al
  8c48d9:	88 8c 24 a9 00 00 00 	mov    %cl,0xa9(%rsp)
  8c48e0:	48 8d 8c 24 ab 00 00 	lea    0xab(%rsp),%rcx
  8c48e7:	00 
  8c48e8:	88 84 24 aa 00 00 00 	mov    %al,0xaa(%rsp)
  8c48ef:	c6 41 04 00          	movb   $0x0,0x4(%rcx)
  8c48f3:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c48f9:	c5 fe 6f 84 24 90 00 	vmovdqu 0x90(%rsp),%ymm0
  8c4900:	00 00 
  8c4902:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c4907:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c490c:	48 89 df             	mov    %rbx,%rdi
  8c490f:	c5 f8 77             	vzeroupper
  8c4912:	e8 f9 8f 00 00       	call   8cd910 <check_lower_complex_task>
  8c4917:	49 89 da             	mov    %rbx,%r10
  8c491a:	e9 6c d7 ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c491f:	45 38 e7             	cmp    %r12b,%r15b
  8c4922:	0f 84 f0 f2 ff ff    	je     8c3c18 <check_lower_drain+0x1be8>
  8c4928:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c492d:	41 0f b6 d4          	movzbl %r12b,%edx
  8c4931:	be 09 00 00 00       	mov    $0x9,%esi
  8c4936:	48 89 df             	mov    %rbx,%rdi
  8c4939:	31 c9                	xor    %ecx,%ecx
  8c493b:	e9 e4 04 00 00       	jmp    8c4e24 <check_lower_drain+0x2df4>
  8c4940:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c4945:	4c 89 f7             	mov    %r14,%rdi
  8c4948:	e8 33 66 00 00       	call   8caf80 <check_lower_label>
  8c494d:	4c 89 f7             	mov    %r14,%rdi
  8c4950:	89 44 24 40          	mov    %eax,0x40(%rsp)
  8c4954:	e8 27 66 00 00       	call   8caf80 <check_lower_label>
  8c4959:	41 89 c4             	mov    %eax,%r12d
  8c495c:	84 db                	test   %bl,%bl
  8c495e:	0f 84 e6 02 00 00    	je     8c4c4a <check_lower_drain+0x2c1a>
  8c4964:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c4969:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c496e:	c1 e8 03             	shr    $0x3,%eax
  8c4971:	b1 ff                	mov    $0xff,%cl
  8c4973:	3b 82 b0 01 00 00    	cmp    0x1b0(%rdx),%eax
  8c4979:	73 10                	jae    8c498b <check_lower_drain+0x295b>
  8c497b:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c4980:	48 8b 89 98 01 00 00 	mov    0x198(%rcx),%rcx
  8c4987:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c498b:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c4990:	0f b6 f1             	movzbl %cl,%esi
  8c4993:	4c 89 f7             	mov    %r14,%rdi
  8c4996:	e8 95 9b ff ff       	call   8be530 <check_lower_temporary>
  8c499b:	89 c0                	mov    %eax,%eax
  8c499d:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8c49a2:	4c 89 f7             	mov    %r14,%rdi
  8c49a5:	44 89 e6             	mov    %r12d,%esi
  8c49a8:	e8 23 ee 00 00       	call   8d37d0 <check_lower_mark>
  8c49ad:	e9 b8 02 00 00       	jmp    8c4c6a <check_lower_drain+0x2c3a>
  8c49b2:	31 c0                	xor    %eax,%eax
  8c49b4:	41 80 ff 0c          	cmp    $0xc,%r15b
  8c49b8:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c49bd:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c49c3:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  8c49c9:	0f 95 c0             	setne  %al
  8c49cc:	31 c9                	xor    %ecx,%ecx
  8c49ce:	41 80 fc 0a          	cmp    $0xa,%r12b
  8c49d2:	0f 95 c1             	setne  %cl
  8c49d5:	41 80 fc 09          	cmp    $0x9,%r12b
  8c49d9:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c49dc:	8d 14 cd a0 00 00 00 	lea    0xa0(,%rcx,8),%edx
  8c49e3:	8d 71 01             	lea    0x1(%rcx),%esi
  8c49e6:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c49eb:	0f 44 d1             	cmove  %ecx,%edx
  8c49ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c49f3:	0f 44 f1             	cmove  %ecx,%esi
  8c49f6:	48 8d 8c 24 b0 00 00 	lea    0xb0(%rsp),%rcx
  8c49fd:	00 
  8c49fe:	8d 74 06 05          	lea    0x5(%rsi,%rax,1),%esi
  8c4a02:	e8 e9 2e 01 00       	call   8d78f0 <check_lower_runtime_call>
  8c4a07:	41 89 c7             	mov    %eax,%r15d
  8c4a0a:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c4a0f:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c4a14:	45 89 f6             	mov    %r14d,%r14d
  8c4a17:	89 ea                	mov    %ebp,%edx
  8c4a19:	4c 89 f1             	mov    %r14,%rcx
  8c4a1c:	48 89 df             	mov    %rbx,%rdi
  8c4a1f:	e8 dc 14 00 00       	call   8c5f00 <check_lower_emit>
  8c4a24:	be 03 00 00 00       	mov    $0x3,%esi
  8c4a29:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4a2e:	48 89 df             	mov    %rbx,%rdi
  8c4a31:	4c 89 f1             	mov    %r14,%rcx
  8c4a34:	e8 c7 14 00 00       	call   8c5f00 <check_lower_emit>
  8c4a39:	41 0f b6 d4          	movzbl %r12b,%edx
  8c4a3d:	48 89 df             	mov    %rbx,%rdi
  8c4a40:	be 22 00 00 00       	mov    $0x22,%esi
  8c4a45:	4c 89 f9             	mov    %r15,%rcx
  8c4a48:	e9 d7 03 00 00       	jmp    8c4e24 <check_lower_drain+0x2df4>
  8c4a4d:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4a52:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4a57:	c5 f8 77             	vzeroupper
  8c4a5a:	e8 51 fb 00 00       	call   8d45b0 <check_lower_varargs_prepare>
  8c4a5f:	e9 1a d6 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c4a64:	83 7c 24 68 1b       	cmpl   $0x1b,0x68(%rsp)
  8c4a69:	0f 85 dc 03 00 00    	jne    8c4e4b <check_lower_drain+0x2e1b>
  8c4a6f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8c4a74:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  8c4a78:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  8c4a7c:	48 c1 e2 05          	shl    $0x5,%rdx
  8c4a80:	f6 44 11 08 04       	testb  $0x4,0x8(%rcx,%rdx,1)
  8c4a85:	0f 84 05 04 00 00    	je     8c4e90 <check_lower_drain+0x2e60>
  8c4a8b:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4a90:	31 d2                	xor    %edx,%edx
  8c4a92:	85 c0                	test   %eax,%eax
  8c4a94:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4a99:	0f 95 c2             	setne  %dl
  8c4a9c:	c5 f8 77             	vzeroupper
  8c4a9f:	e8 1c 09 01 00       	call   8d53c0 <check_lower_bit_assign>
  8c4aa4:	e9 d5 d5 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c4aa9:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
  8c4aae:	be 08 00 00 00       	mov    $0x8,%esi
  8c4ab3:	4c 89 ef             	mov    %r13,%rdi
  8c4ab6:	e8 75 9a ff ff       	call   8be530 <check_lower_temporary>
  8c4abb:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c4ac0:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4ac5:	41 89 c6             	mov    %eax,%r14d
  8c4ac8:	4c 89 ef             	mov    %r13,%rdi
  8c4acb:	4c 89 f1             	mov    %r14,%rcx
  8c4ace:	e8 2d 14 00 00       	call   8c5f00 <check_lower_emit>
  8c4ad3:	31 db                	xor    %ebx,%ebx
  8c4ad5:	eb 25                	jmp    8c4afc <check_lower_drain+0x2acc>
  8c4ad7:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  8c4adc:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c4ae1:	44 89 ea             	mov    %r13d,%edx
  8c4ae4:	31 c9                	xor    %ecx,%ecx
  8c4ae6:	4c 89 e7             	mov    %r12,%rdi
  8c4ae9:	e8 12 14 00 00       	call   8c5f00 <check_lower_emit>
  8c4aee:	44 01 fb             	add    %r15d,%ebx
  8c4af1:	4d 89 e5             	mov    %r12,%r13
  8c4af4:	39 eb                	cmp    %ebp,%ebx
  8c4af6:	0f 83 cb 07 00 00    	jae    8c52c7 <check_lower_drain+0x3297>
  8c4afc:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c4b00:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4b07:	0f 85 ba 07 00 00    	jne    8c52c7 <check_lower_drain+0x3297>
  8c4b0d:	89 e8                	mov    %ebp,%eax
  8c4b0f:	29 d8                	sub    %ebx,%eax
  8c4b11:	83 f8 07             	cmp    $0x7,%eax
  8c4b14:	76 0b                	jbe    8c4b21 <check_lower_drain+0x2af1>
  8c4b16:	41 b4 08             	mov    $0x8,%r12b
  8c4b19:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  8c4b1f:	eb 26                	jmp    8c4b47 <check_lower_drain+0x2b17>
  8c4b21:	83 f8 03             	cmp    $0x3,%eax
  8c4b24:	76 0b                	jbe    8c4b31 <check_lower_drain+0x2b01>
  8c4b26:	41 b4 06             	mov    $0x6,%r12b
  8c4b29:	41 bf 04 00 00 00    	mov    $0x4,%r15d
  8c4b2f:	eb 16                	jmp    8c4b47 <check_lower_drain+0x2b17>
  8c4b31:	45 31 e4             	xor    %r12d,%r12d
  8c4b34:	83 f8 02             	cmp    $0x2,%eax
  8c4b37:	41 0f 93 c4          	setae  %r12b
  8c4b3b:	45 8d 7c 24 01       	lea    0x1(%r12),%r15d
  8c4b40:	45 00 e4             	add    %r12b,%r12b
  8c4b43:	41 80 c4 02          	add    $0x2,%r12b
  8c4b47:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c4b4c:	be 02 00 00 00       	mov    $0x2,%esi
  8c4b51:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4b56:	4c 89 ef             	mov    %r13,%rdi
  8c4b59:	e8 a2 13 00 00       	call   8c5f00 <check_lower_emit>
  8c4b5e:	89 de                	mov    %ebx,%esi
  8c4b60:	4c 89 ef             	mov    %r13,%rdi
  8c4b63:	e8 48 75 00 00       	call   8cc0b0 <check_lower_offset>
  8c4b68:	be 02 00 00 00       	mov    $0x2,%esi
  8c4b6d:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4b72:	4c 89 ef             	mov    %r13,%rdi
  8c4b75:	4c 89 f1             	mov    %r14,%rcx
  8c4b78:	e8 83 13 00 00       	call   8c5f00 <check_lower_emit>
  8c4b7d:	85 db                	test   %ebx,%ebx
  8c4b7f:	74 32                	je     8c4bb3 <check_lower_drain+0x2b83>
  8c4b81:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
  8c4b86:	8d 0c dd 00 00 00 00 	lea    0x0(,%rbx,8),%ecx
  8c4b8d:	be 01 00 00 00       	mov    $0x1,%esi
  8c4b92:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4b97:	4c 89 ef             	mov    %r13,%rdi
  8c4b9a:	e8 61 13 00 00       	call   8c5f00 <check_lower_emit>
  8c4b9f:	be 14 00 00 00       	mov    $0x14,%esi
  8c4ba4:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4ba9:	4c 89 ef             	mov    %r13,%rdi
  8c4bac:	31 c9                	xor    %ecx,%ecx
  8c4bae:	e8 4d 13 00 00       	call   8c5f00 <check_lower_emit>
  8c4bb3:	45 0f b6 ec          	movzbl %r12b,%r13d
  8c4bb7:	41 80 fc 08          	cmp    $0x8,%r12b
  8c4bbb:	0f 84 16 ff ff ff    	je     8c4ad7 <check_lower_drain+0x2aa7>
  8c4bc1:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4bc6:	be 09 00 00 00       	mov    $0x9,%esi
  8c4bcb:	44 89 ea             	mov    %r13d,%edx
  8c4bce:	31 c9                	xor    %ecx,%ecx
  8c4bd0:	e8 2b 13 00 00       	call   8c5f00 <check_lower_emit>
  8c4bd5:	e9 fd fe ff ff       	jmp    8c4ad7 <check_lower_drain+0x2aa7>
  8c4bda:	44 0f b6 b4 24 c0 01 	movzbl 0x1c0(%rsp),%r14d
  8c4be1:	00 00 
  8c4be3:	83 fd 16             	cmp    $0x16,%ebp
  8c4be6:	0f 94 c0             	sete   %al
  8c4be9:	83 fd 15             	cmp    $0x15,%ebp
  8c4bec:	0f 94 c1             	sete   %cl
  8c4bef:	44 89 f2             	mov    %r14d,%edx
  8c4bf2:	44 20 f0             	and    %r14b,%al
  8c4bf5:	80 f2 01             	xor    $0x1,%dl
  8c4bf8:	20 ca                	and    %cl,%dl
  8c4bfa:	08 c2                	or     %al,%dl
  8c4bfc:	80 fa 01             	cmp    $0x1,%dl
  8c4bff:	0f 85 a1 03 00 00    	jne    8c4fa6 <check_lower_drain+0x2f76>
  8c4c05:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c4c0a:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c4c10:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c4c16:	0f 83 ef 06 00 00    	jae    8c530b <check_lower_drain+0x32db>
  8c4c1c:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c4c21:	8d 50 01             	lea    0x1(%rax),%edx
  8c4c24:	48 c1 e0 04          	shl    $0x4,%rax
  8c4c28:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c4c2c:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c4c32:	48 ba 01 00 00 00 01 	movabs $0x5000100000001,%rdx
  8c4c39:	00 05 00 
  8c4c3c:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c4c40:	4c 89 74 01 08       	mov    %r14,0x8(%rcx,%rax,1)
  8c4c45:	e9 8a 03 00 00       	jmp    8c4fd4 <check_lower_drain+0x2fa4>
  8c4c4a:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4c4f:	44 89 e6             	mov    %r12d,%esi
  8c4c52:	e8 79 eb 00 00       	call   8d37d0 <check_lower_mark>
  8c4c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c4c5c:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8c4c61:	83 fd 17             	cmp    $0x17,%ebp
  8c4c64:	0f 85 a3 03 00 00    	jne    8c500d <check_lower_drain+0x2fdd>
  8c4c6a:	45 8b 45 00          	mov    0x0(%r13),%r8d
  8c4c6e:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4c73:	ba 02 00 00 00       	mov    $0x2,%edx
  8c4c78:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4c7d:	31 c9                	xor    %ecx,%ecx
  8c4c7f:	e8 3c ac 00 00       	call   8cf8c0 <check_lower_operand>
  8c4c84:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c4c89:	8b 74 24 40          	mov    0x40(%rsp),%esi
  8c4c8d:	4c 89 f7             	mov    %r14,%rdi
  8c4c90:	e8 3b eb 00 00       	call   8d37d0 <check_lower_mark>
  8c4c95:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8c4c9a:	be 27 00 00 00       	mov    $0x27,%esi
  8c4c9f:	44 89 e1             	mov    %r12d,%ecx
  8c4ca2:	4c 89 f7             	mov    %r14,%rdi
  8c4ca5:	3c 01                	cmp    $0x1,%al
  8c4ca7:	0f b6 d0             	movzbl %al,%edx
  8c4caa:	83 de 00             	sbb    $0x0,%esi
  8c4cad:	e8 9e 17 00 00       	call   8c6450 <check_lower_instruction>
  8c4cb2:	83 fd 17             	cmp    $0x17,%ebp
  8c4cb5:	75 6a                	jne    8c4d21 <check_lower_drain+0x2cf1>
  8c4cb7:	45 8b 45 00          	mov    0x0(%r13),%r8d
  8c4cbb:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  8c4cc2:	00 
  8c4cc3:	39 44 24 58          	cmp    %eax,0x58(%rsp)
  8c4cc7:	0f 85 8d 03 00 00    	jne    8c505a <check_lower_drain+0x302a>
  8c4ccd:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c4cd2:	4c 8b 7c 24 60       	mov    0x60(%rsp),%r15
  8c4cd7:	44 89 c2             	mov    %r8d,%edx
  8c4cda:	4c 89 f7             	mov    %r14,%rdi
  8c4cdd:	44 89 fe             	mov    %r15d,%esi
  8c4ce0:	e8 db 55 00 00       	call   8ca2c0 <check_lower_convert>
  8c4ce5:	41 c1 ef 03          	shr    $0x3,%r15d
  8c4ce9:	b1 ff                	mov    $0xff,%cl
  8c4ceb:	45 3b be b0 01 00 00 	cmp    0x1b0(%r14),%r15d
  8c4cf2:	73 11                	jae    8c4d05 <check_lower_drain+0x2cd5>
  8c4cf4:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c4cf9:	48 8b 89 98 01 00 00 	mov    0x198(%rcx),%rcx
  8c4d00:	42 0f b6 0c 39       	movzbl (%rcx,%r15,1),%ecx
  8c4d05:	0f b6 d1             	movzbl %cl,%edx
  8c4d08:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4d0d:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c4d12:	be 02 00 00 00       	mov    $0x2,%esi
  8c4d17:	e8 34 17 00 00       	call   8c6450 <check_lower_instruction>
  8c4d1c:	e9 4f 03 00 00       	jmp    8c5070 <check_lower_drain+0x3040>
  8c4d21:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c4d26:	4c 8b 7c 24 78       	mov    0x78(%rsp),%r15
  8c4d2b:	31 d2                	xor    %edx,%edx
  8c4d2d:	4c 89 f7             	mov    %r14,%rdi
  8c4d30:	44 89 fe             	mov    %r15d,%esi
  8c4d33:	e8 d8 ad 00 00       	call   8cfb10 <check_lower_truth>
  8c4d38:	ba 01 00 00 00       	mov    $0x1,%edx
  8c4d3d:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4d42:	4c 89 f7             	mov    %r14,%rdi
  8c4d45:	31 c9                	xor    %ecx,%ecx
  8c4d47:	45 89 f8             	mov    %r15d,%r8d
  8c4d4a:	e9 1c 03 00 00       	jmp    8c506b <check_lower_drain+0x303b>
  8c4d4f:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4d54:	be 23 00 00 00       	mov    $0x23,%esi
  8c4d59:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4d5e:	31 c9                	xor    %ecx,%ecx
  8c4d60:	c5 f8 77             	vzeroupper
  8c4d63:	e8 98 11 00 00       	call   8c5f00 <check_lower_emit>
  8c4d68:	f6 c3 01             	test   $0x1,%bl
  8c4d6b:	0f 85 8b 05 00 00    	jne    8c52fc <check_lower_drain+0x32cc>
  8c4d71:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c4d76:	be 23 00 00 00       	mov    $0x23,%esi
  8c4d7b:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4d80:	31 c9                	xor    %ecx,%ecx
  8c4d82:	e9 fa 04 00 00       	jmp    8c5281 <check_lower_drain+0x3251>
  8c4d87:	4c 89 d7             	mov    %r10,%rdi
  8c4d8a:	c5 f8 77             	vzeroupper
  8c4d8d:	e8 ee 61 00 00       	call   8caf80 <check_lower_label>
  8c4d92:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4d97:	89 c6                	mov    %eax,%esi
  8c4d99:	89 c5                	mov    %eax,%ebp
  8c4d9b:	e8 10 11 00 00       	call   8c5eb0 <check_lower_place>
  8c4da0:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4da5:	be 26 00 00 00       	mov    $0x26,%esi
  8c4daa:	89 e9                	mov    %ebp,%ecx
  8c4dac:	31 d2                	xor    %edx,%edx
  8c4dae:	e8 4d 11 00 00       	call   8c5f00 <check_lower_emit>
  8c4db3:	e9 ce d2 ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c4db8:	31 c0                	xor    %eax,%eax
  8c4dba:	41 80 fc 0c          	cmp    $0xc,%r12b
  8c4dbe:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4dc3:	be 00 00 00 00       	mov    $0x0,%esi
  8c4dc8:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4dce:	45 89 f1             	mov    %r14d,%r9d
  8c4dd1:	0f 95 c0             	setne  %al
  8c4dd4:	31 c9                	xor    %ecx,%ecx
  8c4dd6:	41 80 ff 0a          	cmp    $0xa,%r15b
  8c4dda:	0f 95 c1             	setne  %cl
  8c4ddd:	8d 14 c5 70 00 00 00 	lea    0x70(,%rax,8),%edx
  8c4de4:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c4de7:	ff c1                	inc    %ecx
  8c4de9:	41 80 ff 09          	cmp    $0x9,%r15b
  8c4ded:	0f 44 ce             	cmove  %esi,%ecx
  8c4df0:	8d 74 01 0b          	lea    0xb(%rcx,%rax,1),%esi
  8c4df4:	48 8d 8c 24 b0 00 00 	lea    0xb0(%rsp),%rcx
  8c4dfb:	00 
  8c4dfc:	e8 ef 2a 01 00       	call   8d78f0 <check_lower_runtime_call>
  8c4e01:	89 c1                	mov    %eax,%ecx
  8c4e03:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c4e08:	be 22 00 00 00       	mov    $0x22,%esi
  8c4e0d:	31 d2                	xor    %edx,%edx
  8c4e0f:	48 89 df             	mov    %rbx,%rdi
  8c4e12:	e8 e9 10 00 00       	call   8c5f00 <check_lower_emit>
  8c4e17:	44 89 f1             	mov    %r14d,%ecx
  8c4e1a:	48 89 df             	mov    %rbx,%rdi
  8c4e1d:	be 02 00 00 00       	mov    $0x2,%esi
  8c4e22:	89 ea                	mov    %ebp,%edx
  8c4e24:	c5 f8 77             	vzeroupper
  8c4e27:	e8 d4 10 00 00       	call   8c5f00 <check_lower_emit>
  8c4e2c:	49 89 da             	mov    %rbx,%r10
  8c4e2f:	4d 89 ec             	mov    %r13,%r12
  8c4e32:	e9 54 d2 ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c4e37:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c4e3c:	be 29 00 00 00       	mov    $0x29,%esi
  8c4e41:	31 d2                	xor    %edx,%edx
  8c4e43:	4c 89 f1             	mov    %r14,%rcx
  8c4e46:	e9 36 04 00 00       	jmp    8c5281 <check_lower_drain+0x3251>
  8c4e4b:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8c4e50:	83 c1 da             	add    $0xffffffda,%ecx
  8c4e53:	83 f9 0d             	cmp    $0xd,%ecx
  8c4e56:	77 38                	ja     8c4e90 <check_lower_drain+0x2e60>
  8c4e58:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c4e5d:	48 8b 55 08          	mov    0x8(%rbp),%rdx
  8c4e61:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  8c4e65:	b1 01                	mov    $0x1,%cl
  8c4e67:	48 c1 e6 05          	shl    $0x5,%rsi
  8c4e6b:	f6 44 32 08 04       	testb  $0x4,0x8(%rdx,%rsi,1)
  8c4e70:	74 20                	je     8c4e92 <check_lower_drain+0x2e62>
  8c4e72:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4e77:	31 d2                	xor    %edx,%edx
  8c4e79:	85 c0                	test   %eax,%eax
  8c4e7b:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4e80:	0f 95 c2             	setne  %dl
  8c4e83:	c5 f8 77             	vzeroupper
  8c4e86:	e8 95 08 01 00       	call   8d5720 <check_lower_bit_update>
  8c4e8b:	e9 ee d1 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c4e90:	31 c9                	xor    %ecx,%ecx
  8c4e92:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  8c4e97:	83 c2 e5             	add    $0xffffffe5,%edx
  8c4e9a:	f7 c2 f7 ff ff ff    	test   $0xfffffff7,%edx
  8c4ea0:	0f 94 c2             	sete   %dl
  8c4ea3:	22 94 24 88 00 00 00 	and    0x88(%rsp),%dl
  8c4eaa:	80 fa 01             	cmp    $0x1,%dl
  8c4ead:	0f 85 84 02 00 00    	jne    8c5137 <check_lower_drain+0x3107>
  8c4eb3:	83 7c 24 68 23       	cmpl   $0x23,0x68(%rsp)
  8c4eb8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  8c4ebd:	75 10                	jne    8c4ecf <check_lower_drain+0x2e9f>
  8c4ebf:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c4ec4:	48 8b 89 b8 00 00 00 	mov    0xb8(%rcx),%rcx
  8c4ecb:	42 8b 1c b9          	mov    (%rcx,%r15,4),%ebx
  8c4ecf:	c4 e2 79 22 05 b0 24 	vpmovsxbq -0x41db50(%rip),%xmm0        # 4a7388 <cbuiltin_test_generated.edges+0xacf8>
  8c4ed6:	be ff 
  8c4ed8:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c4edd:	41 c1 e8 03          	shr    $0x3,%r8d
  8c4ee1:	c5 f8 29 84 24 a0 01 	vmovaps %xmm0,0x1a0(%rsp)
  8c4ee8:	00 00 
  8c4eea:	48 8b 09             	mov    (%rcx),%rcx
  8c4eed:	42 80 3c 01 0f       	cmpb   $0xf,(%rcx,%r8,1)
  8c4ef2:	75 11                	jne    8c4f05 <check_lower_drain+0x2ed5>
  8c4ef4:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c4ef9:	48 8b 49 20          	mov    0x20(%rcx),%rcx
  8c4efd:	46 8b 04 81          	mov    (%rcx,%r8,4),%r8d
  8c4f01:	41 c1 e8 03          	shr    $0x3,%r8d
  8c4f05:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c4f0a:	4c 8b 64 24 68       	mov    0x68(%rsp),%r12
  8c4f0f:	45 31 ff             	xor    %r15d,%r15d
  8c4f12:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  8c4f16:	41 83 fc 23          	cmp    $0x23,%r12d
  8c4f1a:	41 0f 95 c7          	setne  %r15b
  8c4f1e:	85 c0                	test   %eax,%eax
  8c4f20:	4a 8b 04 c1          	mov    (%rcx,%r8,8),%rax
  8c4f24:	48 8d 8c 24 b9 01 00 	lea    0x1b9(%rsp),%rcx
  8c4f2b:	00 
  8c4f2c:	48 89 84 24 b0 01 00 	mov    %rax,0x1b0(%rsp)
  8c4f33:	00 
  8c4f34:	0f 94 84 24 b8 01 00 	sete   0x1b8(%rsp)
  8c4f3b:	00 
  8c4f3c:	c7 41 03 00 00 00 00 	movl   $0x0,0x3(%rcx)
  8c4f43:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c4f49:	c5 fe 6f 84 24 a0 01 	vmovdqu 0x1a0(%rsp),%ymm0
  8c4f50:	00 00 
  8c4f52:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c4f57:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c4f5c:	4c 89 f7             	mov    %r14,%rdi
  8c4f5f:	c5 f8 77             	vzeroupper
  8c4f62:	e8 99 52 00 00       	call   8ca200 <check_lower_push>
  8c4f67:	45 8b 45 00          	mov    0x0(%r13),%r8d
  8c4f6b:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4f70:	4c 89 f7             	mov    %r14,%rdi
  8c4f73:	44 89 fa             	mov    %r15d,%edx
  8c4f76:	31 c9                	xor    %ecx,%ecx
  8c4f78:	e8 43 a9 00 00       	call   8cf8c0 <check_lower_operand>
  8c4f7d:	41 83 fc 1b          	cmp    $0x1b,%r12d
  8c4f81:	0f 85 33 04 00 00    	jne    8c53ba <check_lower_drain+0x338a>
  8c4f87:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4f8c:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4f91:	e9 49 de ff ff       	jmp    8c2ddf <check_lower_drain+0xdaf>
  8c4f96:	83 f9 01             	cmp    $0x1,%ecx
  8c4f99:	41 0f 45 d6          	cmovne %r14d,%edx
  8c4f9d:	49 c1 ee 20          	shr    $0x20,%r14
  8c4fa1:	e9 f8 f8 ff ff       	jmp    8c489e <check_lower_drain+0x286e>
  8c4fa6:	4c 8b 7c 24 20       	mov    0x20(%rsp),%r15
  8c4fab:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  8c4fb0:	31 d2                	xor    %edx,%edx
  8c4fb2:	4c 89 ff             	mov    %r15,%rdi
  8c4fb5:	44 89 e6             	mov    %r12d,%esi
  8c4fb8:	e8 53 ab 00 00       	call   8cfb10 <check_lower_truth>
  8c4fbd:	ba 01 00 00 00       	mov    $0x1,%edx
  8c4fc2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4fc7:	4c 89 ff             	mov    %r15,%rdi
  8c4fca:	31 c9                	xor    %ecx,%ecx
  8c4fcc:	45 89 e0             	mov    %r12d,%r8d
  8c4fcf:	e8 ec a8 00 00       	call   8cf8c0 <check_lower_operand>
  8c4fd4:	44 84 f3             	test   %r14b,%bl
  8c4fd7:	0f 85 a1 d0 ff ff    	jne    8c207e <check_lower_drain+0x4e>
  8c4fdd:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c4fe2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8c4fe7:	48 8b 01             	mov    (%rcx),%rax
  8c4fea:	48 8b 71 08          	mov    0x8(%rcx),%rsi
  8c4fee:	48 8b 38             	mov    (%rax),%rdi
  8c4ff1:	e8 1a e7 00 00       	call   8d3710 <check_program_runtime_effects>
  8c4ff6:	b9 08 00 00 00       	mov    $0x8,%ecx
  8c4ffb:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  8c5000:	84 c0                	test   %al,%al
  8c5002:	0f 84 76 d0 ff ff    	je     8c207e <check_lower_drain+0x4e>
  8c5008:	e9 0d 01 00 00       	jmp    8c511a <check_lower_drain+0x30ea>
  8c500d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5012:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5018:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c501e:	0f 83 21 03 00 00    	jae    8c5345 <check_lower_drain+0x3315>
  8c5024:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c5029:	31 c9                	xor    %ecx,%ecx
  8c502b:	83 fd 16             	cmp    $0x16,%ebp
  8c502e:	8d 70 01             	lea    0x1(%rax),%esi
  8c5031:	0f 94 c1             	sete   %cl
  8c5034:	48 c1 e0 04          	shl    $0x4,%rax
  8c5038:	48 8b 57 18          	mov    0x18(%rdi),%rdx
  8c503c:	89 b7 3c 01 00 00    	mov    %esi,0x13c(%rdi)
  8c5042:	48 be 01 00 00 00 01 	movabs $0x5000100000001,%rsi
  8c5049:	00 05 00 
  8c504c:	48 89 34 02          	mov    %rsi,(%rdx,%rax,1)
  8c5050:	48 89 4c 02 08       	mov    %rcx,0x8(%rdx,%rax,1)
  8c5055:	e9 2a fc ff ff       	jmp    8c4c84 <check_lower_drain+0x2c54>
  8c505a:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c505f:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c5064:	ba 01 00 00 00       	mov    $0x1,%edx
  8c5069:	31 c9                	xor    %ecx,%ecx
  8c506b:	e8 50 a8 00 00       	call   8cf8c0 <check_lower_operand>
  8c5070:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c5075:	8b 4c 24 40          	mov    0x40(%rsp),%ecx
  8c5079:	31 f6                	xor    %esi,%esi
  8c507b:	83 fd 16             	cmp    $0x16,%ebp
  8c507e:	ba 05 00 00 00       	mov    $0x5,%edx
  8c5083:	40 0f 94 c6          	sete   %sil
  8c5087:	83 ce 24             	or     $0x24,%esi
  8c508a:	4c 89 f7             	mov    %r14,%rdi
  8c508d:	e8 be 13 00 00       	call   8c6450 <check_lower_instruction>
  8c5092:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  8c5097:	4c 89 f7             	mov    %r14,%rdi
  8c509a:	31 d2                	xor    %edx,%edx
  8c509c:	e8 6f aa 00 00       	call   8cfb10 <check_lower_truth>
  8c50a1:	84 db                	test   %bl,%bl
  8c50a3:	74 75                	je     8c511a <check_lower_drain+0x30ea>
  8c50a5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c50aa:	48 8b 5c 24 60       	mov    0x60(%rsp),%rbx
  8c50af:	c1 eb 03             	shr    $0x3,%ebx
  8c50b2:	40 b5 ff             	mov    $0xff,%bpl
  8c50b5:	b0 ff                	mov    $0xff,%al
  8c50b7:	3b 99 b0 01 00 00    	cmp    0x1b0(%rcx),%ebx
  8c50bd:	73 10                	jae    8c50cf <check_lower_drain+0x309f>
  8c50bf:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c50c4:	48 8b 80 98 01 00 00 	mov    0x198(%rax),%rax
  8c50cb:	0f b6 04 18          	movzbl (%rax,%rbx,1),%eax
  8c50cf:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c50d4:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c50d9:	0f b6 d0             	movzbl %al,%edx
  8c50dc:	be 02 00 00 00       	mov    $0x2,%esi
  8c50e1:	4c 89 f7             	mov    %r14,%rdi
  8c50e4:	e8 67 13 00 00       	call   8c6450 <check_lower_instruction>
  8c50e9:	41 3b 9e b0 01 00 00 	cmp    0x1b0(%r14),%ebx
  8c50f0:	73 10                	jae    8c5102 <check_lower_drain+0x30d2>
  8c50f2:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c50f7:	48 8b 80 98 01 00 00 	mov    0x198(%rax),%rax
  8c50fe:	0f b6 2c 18          	movzbl (%rax,%rbx,1),%ebp
  8c5102:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c5107:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c510c:	40 0f b6 d5          	movzbl %bpl,%edx
  8c5110:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c5115:	e8 36 13 00 00       	call   8c6450 <check_lower_instruction>
  8c511a:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c511f:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c5124:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
  8c5129:	31 d2                	xor    %edx,%edx
  8c512b:	31 c9                	xor    %ecx,%ecx
  8c512d:	e8 8e a7 00 00       	call   8cf8c0 <check_lower_operand>
  8c5132:	e9 47 cf ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c5137:	83 7c 24 68 23       	cmpl   $0x23,0x68(%rsp)
  8c513c:	74 0b                	je     8c5149 <check_lower_drain+0x3119>
  8c513e:	83 7c 24 68 1b       	cmpl   $0x1b,0x68(%rsp)
  8c5143:	0f 85 e0 03 00 00    	jne    8c5529 <check_lower_drain+0x34f9>
  8c5149:	83 7c 24 68 23       	cmpl   $0x23,0x68(%rsp)
  8c514e:	0f 85 d0 02 00 00    	jne    8c5424 <check_lower_drain+0x33f4>
  8c5154:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5159:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c515e:	48 8b 80 b8 00 00 00 	mov    0xb8(%rax),%rax
  8c5165:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c5169:	48 39 c8             	cmp    %rcx,%rax
  8c516c:	0f 84 b2 02 00 00    	je     8c5424 <check_lower_drain+0x33f4>
  8c5172:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c5177:	48 c1 e0 02          	shl    $0x2,%rax
  8c517b:	48 8b 09             	mov    (%rcx),%rcx
  8c517e:	48 03 81 70 02 00 00 	add    0x270(%rcx),%rax
  8c5185:	e9 c3 02 00 00       	jmp    8c544d <check_lower_drain+0x341d>
  8c518a:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c518f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c5194:	41 89 ec             	mov    %ebp,%r12d
  8c5197:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c519c:	ba 08 00 00 00       	mov    $0x8,%edx
  8c51a1:	4c 89 e1             	mov    %r12,%rcx
  8c51a4:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8c51a9:	e8 52 0d 00 00       	call   8c5f00 <check_lower_emit>
  8c51ae:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c51b3:	4d 89 f7             	mov    %r14,%r15
  8c51b6:	45 31 ed             	xor    %r13d,%r13d
  8c51b9:	eb 58                	jmp    8c5213 <check_lower_drain+0x31e3>
  8c51bb:	4c 89 ee             	mov    %r13,%rsi
  8c51be:	e8 ed 6e 00 00       	call   8cc0b0 <check_lower_offset>
  8c51c3:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c51c8:	be 02 00 00 00       	mov    $0x2,%esi
  8c51cd:	ba 08 00 00 00       	mov    $0x8,%edx
  8c51d2:	4c 89 e1             	mov    %r12,%rcx
  8c51d5:	e8 26 0d 00 00       	call   8c5f00 <check_lower_emit>
  8c51da:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c51df:	4c 89 ee             	mov    %r13,%rsi
  8c51e2:	e8 c9 6e 00 00       	call   8cc0b0 <check_lower_offset>
  8c51e7:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c51ec:	be 29 00 00 00       	mov    $0x29,%esi
  8c51f1:	31 d2                	xor    %edx,%edx
  8c51f3:	48 89 e9             	mov    %rbp,%rcx
  8c51f6:	e8 05 0d 00 00       	call   8c5f00 <check_lower_emit>
  8c51fb:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c5200:	49 81 c5 00 01 00 00 	add    $0x100,%r13
  8c5207:	49 81 c7 00 ff ff ff 	add    $0xffffffffffffff00,%r15
  8c520e:	4d 39 f5             	cmp    %r14,%r13
  8c5211:	73 51                	jae    8c5264 <check_lower_drain+0x3234>
  8c5213:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c5217:	49 81 ff 00 01 00 00 	cmp    $0x100,%r15
  8c521e:	b8 00 01 00 00       	mov    $0x100,%eax
  8c5223:	49 0f 42 c7          	cmovb  %r15,%rax
  8c5227:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c522e:	75 34                	jne    8c5264 <check_lower_drain+0x3234>
  8c5230:	49 81 ff 00 01 00 00 	cmp    $0x100,%r15
  8c5237:	bd 00 01 00 00       	mov    $0x100,%ebp
  8c523c:	49 0f 42 ef          	cmovb  %r15,%rbp
  8c5240:	4c 39 f8             	cmp    %r15,%rax
  8c5243:	0f 84 72 ff ff ff    	je     8c51bb <check_lower_drain+0x318b>
  8c5249:	be 06 00 00 00       	mov    $0x6,%esi
  8c524e:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5253:	31 c9                	xor    %ecx,%ecx
  8c5255:	e8 a6 0c 00 00       	call   8c5f00 <check_lower_emit>
  8c525a:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c525f:	e9 57 ff ff ff       	jmp    8c51bb <check_lower_drain+0x318b>
  8c5264:	f6 c3 01             	test   $0x1,%bl
  8c5267:	0f 84 8f 00 00 00    	je     8c52fc <check_lower_drain+0x32cc>
  8c526d:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c5272:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c5277:	be 02 00 00 00       	mov    $0x2,%esi
  8c527c:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5281:	48 89 df             	mov    %rbx,%rdi
  8c5284:	c5 f8 77             	vzeroupper
  8c5287:	e8 74 0c 00 00       	call   8c5f00 <check_lower_emit>
  8c528c:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c5291:	49 89 da             	mov    %rbx,%r10
  8c5294:	e9 f2 cd ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c5299:	b3 06                	mov    $0x6,%bl
  8c529b:	eb 02                	jmp    8c529f <check_lower_drain+0x326f>
  8c529d:	b3 04                	mov    $0x4,%bl
  8c529f:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c52a4:	0f b6 d3             	movzbl %bl,%edx
  8c52a7:	be 09 00 00 00       	mov    $0x9,%esi
  8c52ac:	31 c9                	xor    %ecx,%ecx
  8c52ae:	e8 4d 0c 00 00       	call   8c5f00 <check_lower_emit>
  8c52b3:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c52b8:	0f b6 d3             	movzbl %bl,%edx
  8c52bb:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c52c0:	31 c9                	xor    %ecx,%ecx
  8c52c2:	e8 39 0c 00 00       	call   8c5f00 <check_lower_emit>
  8c52c7:	f6 44 24 70 04       	testb  $0x4,0x70(%rsp)
  8c52cc:	75 2e                	jne    8c52fc <check_lower_drain+0x32cc>
  8c52ce:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c52d3:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c52d8:	be 02 00 00 00       	mov    $0x2,%esi
  8c52dd:	ba 08 00 00 00       	mov    $0x8,%edx
  8c52e2:	48 89 df             	mov    %rbx,%rdi
  8c52e5:	e8 16 0c 00 00       	call   8c5f00 <check_lower_emit>
  8c52ea:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  8c52f1:	00 
  8c52f2:	48 89 df             	mov    %rbx,%rdi
  8c52f5:	31 d2                	xor    %edx,%edx
  8c52f7:	e8 74 85 01 00       	call   8dd870 <check_lower_bit_extract>
  8c52fc:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c5301:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c5306:	e9 80 cd ff ff       	jmp    8c208b <check_lower_drain+0x5b>
  8c530b:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5310:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5314:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c531b:	0f 85 b3 fc ff ff    	jne    8c4fd4 <check_lower_drain+0x2fa4>
  8c5321:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5326:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c532d:	00 00 00 
  8c5330:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5336:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c533a:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5340:	e9 8f fc ff ff       	jmp    8c4fd4 <check_lower_drain+0x2fa4>
  8c5345:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c534a:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c534e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5355:	0f 85 29 f9 ff ff    	jne    8c4c84 <check_lower_drain+0x2c54>
  8c535b:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5360:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5367:	00 00 00 
  8c536a:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5370:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5374:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c537a:	e9 05 f9 ff ff       	jmp    8c4c84 <check_lower_drain+0x2c54>
  8c537f:	8b 5c 24 58          	mov    0x58(%rsp),%ebx
  8c5383:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  8c538a:	00 
  8c538b:	48 8d 34 5b          	lea    (%rbx,%rbx,2),%rsi
  8c538f:	48 c1 e6 05          	shl    $0x5,%rsi
  8c5393:	8b 4c 31 40          	mov    0x40(%rcx,%rsi,1),%ecx
  8c5397:	48 85 c9             	test   %rcx,%rcx
  8c539a:	0f 84 02 02 00 00    	je     8c55a2 <check_lower_drain+0x3572>
  8c53a0:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8c53a5:	41 3b 89 c0 00 00 00 	cmp    0xc0(%r9),%ecx
  8c53ac:	41 0f 92 c1          	setb   %r9b
  8c53b0:	44 89 4c 24 58       	mov    %r9d,0x58(%rsp)
  8c53b5:	e9 f0 01 00 00       	jmp    8c55aa <check_lower_drain+0x357a>
  8c53ba:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  8c53bf:	48 8b 00             	mov    (%rax),%rax
  8c53c2:	3b 98 84 03 00 00    	cmp    0x384(%rax),%ebx
  8c53c8:	0f 83 d2 06 00 00    	jae    8c5aa0 <check_lower_drain+0x3a70>
  8c53ce:	48 8d 8c 24 88 01 00 	lea    0x188(%rsp),%rcx
  8c53d5:	00 
  8c53d6:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c53da:	c5 fa 7f 01          	vmovdqu %xmm0,(%rcx)
  8c53de:	48 c7 41 10 00 00 00 	movq   $0x0,0x10(%rcx)
  8c53e5:	00 
  8c53e6:	c7 84 24 80 01 00 00 	movl   $0xa,0x180(%rsp)
  8c53ed:	0a 00 00 00 
  8c53f1:	89 d9                	mov    %ebx,%ecx
  8c53f3:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
  8c53fa:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c53fd:	89 84 24 84 01 00 00 	mov    %eax,0x184(%rsp)
  8c5404:	c5 fe 6f 84 24 80 01 	vmovdqu 0x180(%rsp),%ymm0
  8c540b:	00 00 
  8c540d:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c5412:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c5417:	c5 f8 77             	vzeroupper
  8c541a:	e8 e1 4d 00 00       	call   8ca200 <check_lower_push>
  8c541f:	e9 5a cc ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c5424:	49 8b 04 24          	mov    (%r12),%rax
  8c5428:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c542d:	83 3c 88 00          	cmpl   $0x0,(%rax,%rcx,4)
  8c5431:	0f 85 a5 00 00 00    	jne    8c54dc <check_lower_drain+0x34ac>
  8c5437:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c543c:	48 8b 45 08          	mov    0x8(%rbp),%rax
  8c5440:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c5444:	48 c1 e1 05          	shl    $0x5,%rcx
  8c5448:	48 8d 44 08 40       	lea    0x40(%rax,%rcx,1),%rax
  8c544d:	8b 18                	mov    (%rax),%ebx
  8c544f:	48 85 db             	test   %rbx,%rbx
  8c5452:	0f 84 84 00 00 00    	je     8c54dc <check_lower_drain+0x34ac>
  8c5458:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  8c545d:	3b 98 c0 00 00 00    	cmp    0xc0(%rax),%ebx
  8c5463:	73 77                	jae    8c54dc <check_lower_drain+0x34ac>
  8c5465:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c546a:	b2 1e                	mov    $0x1e,%dl
  8c546c:	48 8b 40 68          	mov    0x68(%rax),%rax
  8c5470:	8b 04 98             	mov    (%rax,%rbx,4),%eax
  8c5473:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c5476:	75 2a                	jne    8c54a2 <check_lower_drain+0x3472>
  8c5478:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  8c547d:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8c5482:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8c5489:	83 c1 f5             	add    $0xfffffff5,%ecx
  8c548c:	8b 04 98             	mov    (%rax,%rbx,4),%eax
  8c548f:	80 f9 03             	cmp    $0x3,%cl
  8c5492:	0f 82 88 05 00 00    	jb     8c5a20 <check_lower_drain+0x39f0>
  8c5498:	b2 20                	mov    $0x20,%dl
  8c549a:	85 c0                	test   %eax,%eax
  8c549c:	0f 84 7e 05 00 00    	je     8c5a20 <check_lower_drain+0x39f0>
  8c54a2:	31 ed                	xor    %ebp,%ebp
  8c54a4:	83 7c 24 68 23       	cmpl   $0x23,0x68(%rsp)
  8c54a9:	0f b6 f2             	movzbl %dl,%esi
  8c54ac:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c54b1:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c54b6:	89 c1                	mov    %eax,%ecx
  8c54b8:	48 89 df             	mov    %rbx,%rdi
  8c54bb:	40 0f 95 c5          	setne  %bpl
  8c54bf:	c5 f8 77             	vzeroupper
  8c54c2:	e8 89 0f 00 00       	call   8c6450 <check_lower_instruction>
  8c54c7:	45 8b 45 00          	mov    0x0(%r13),%r8d
  8c54cb:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c54d0:	48 89 df             	mov    %rbx,%rdi
  8c54d3:	89 ea                	mov    %ebp,%edx
  8c54d5:	31 c9                	xor    %ecx,%ecx
  8c54d7:	e9 3e d3 ff ff       	jmp    8c281a <check_lower_drain+0x7ea>
  8c54dc:	83 7c 24 68 1b       	cmpl   $0x1b,0x68(%rsp)
  8c54e1:	0f 85 b9 05 00 00    	jne    8c5aa0 <check_lower_drain+0x3a70>
  8c54e7:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c54ec:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c54f1:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c54f6:	31 c9                	xor    %ecx,%ecx
  8c54f8:	48 89 df             	mov    %rbx,%rdi
  8c54fb:	c5 f8 77             	vzeroupper
  8c54fe:	e8 4d 0f 00 00       	call   8c6450 <check_lower_instruction>
  8c5503:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  8c5508:	45 8b 45 00          	mov    0x0(%r13),%r8d
  8c550c:	ba 01 00 00 00       	mov    $0x1,%edx
  8c5511:	48 89 df             	mov    %rbx,%rdi
  8c5514:	31 c9                	xor    %ecx,%ecx
  8c5516:	44 89 f6             	mov    %r14d,%esi
  8c5519:	e8 a2 a3 00 00       	call   8cf8c0 <check_lower_operand>
  8c551e:	48 89 df             	mov    %rbx,%rdi
  8c5521:	44 89 f6             	mov    %r14d,%esi
  8c5524:	e9 b6 d8 ff ff       	jmp    8c2ddf <check_lower_drain+0xdaf>
  8c5529:	84 c9                	test   %cl,%cl
  8c552b:	0f 84 c1 01 00 00    	je     8c56f2 <check_lower_drain+0x36c2>
  8c5531:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c5536:	48 8b 45 08          	mov    0x8(%rbp),%rax
  8c553a:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c553e:	48 c1 e1 05          	shl    $0x5,%rcx
  8c5542:	8b 04 08             	mov    (%rax,%rcx,1),%eax
  8c5545:	c1 e8 03             	shr    $0x3,%eax
  8c5548:	3b 44 24 3c          	cmp    0x3c(%rsp),%eax
  8c554c:	73 16                	jae    8c5564 <check_lower_drain+0x3534>
  8c554e:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5553:	48 8b 89 a0 01 00 00 	mov    0x1a0(%rcx),%rcx
  8c555a:	f6 04 01 02          	testb  $0x2,(%rcx,%rax,1)
  8c555e:	0f 85 41 02 00 00    	jne    8c57a5 <check_lower_drain+0x3775>
  8c5564:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c5569:	c1 e8 03             	shr    $0x3,%eax
  8c556c:	3b 44 24 3c          	cmp    0x3c(%rsp),%eax
  8c5570:	73 19                	jae    8c558b <check_lower_drain+0x355b>
  8c5572:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c5577:	48 89 c1             	mov    %rax,%rcx
  8c557a:	48 8b 82 a0 01 00 00 	mov    0x1a0(%rdx),%rax
  8c5581:	f6 04 08 02          	testb  $0x2,(%rax,%rcx,1)
  8c5585:	0f 85 1a 02 00 00    	jne    8c57a5 <check_lower_drain+0x3775>
  8c558b:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c5590:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c5595:	c5 f8 77             	vzeroupper
  8c5598:	e8 e3 0c 01 00       	call   8d6280 <check_lower_update>
  8c559d:	e9 dc ca ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c55a2:	c7 44 24 58 00 00 00 	movl   $0x0,0x58(%rsp)
  8c55a9:	00 
  8c55aa:	44 0f b6 cf          	movzbl %dil,%r9d
  8c55ae:	41 8d 69 ff          	lea    -0x1(%r9),%ebp
  8c55b2:	83 fd 0a             	cmp    $0xa,%ebp
  8c55b5:	41 0f 93 c3          	setae  %r11b
  8c55b9:	f7 c7 00 05 00 00    	test   $0x500,%edi
  8c55bf:	41 0f 95 c2          	setne  %r10b
  8c55c3:	45 08 da             	or     %r11b,%r10b
  8c55c6:	0f 85 12 01 00 00    	jne    8c56de <check_lower_drain+0x36ae>
  8c55cc:	4c 8b 94 24 80 00 00 	mov    0x80(%rsp),%r10
  8c55d3:	00 
  8c55d4:	49 01 f2             	add    %rsi,%r10
  8c55d7:	41 83 7a 44 00       	cmpl   $0x0,0x44(%r10)
  8c55dc:	0f 85 fc 00 00 00    	jne    8c56de <check_lower_drain+0x36ae>
  8c55e2:	8b 1c 98             	mov    (%rax,%rbx,4),%ebx
  8c55e5:	4d 89 d3             	mov    %r10,%r11
  8c55e8:	85 db                	test   %ebx,%ebx
  8c55ea:	40 0f 94 c6          	sete   %sil
  8c55ee:	40 22 74 24 58       	and    0x58(%rsp),%sil
  8c55f3:	40 80 fe 01          	cmp    $0x1,%sil
  8c55f7:	75 25                	jne    8c561e <check_lower_drain+0x35ee>
  8c55f9:	4d 8b 94 24 90 02 00 	mov    0x290(%r12),%r10
  8c5600:	00 
  8c5601:	8d 71 ff             	lea    -0x1(%rcx),%esi
  8c5604:	41 80 3c 32 00       	cmpb   $0x0,(%r10,%rsi,1)
  8c5609:	74 13                	je     8c561e <check_lower_drain+0x35ee>
  8c560b:	4d 8b 94 24 78 02 00 	mov    0x278(%r12),%r10
  8c5612:	00 
  8c5613:	41 80 3c 32 00       	cmpb   $0x0,(%r10,%rsi,1)
  8c5618:	0f 84 c0 00 00 00    	je     8c56de <check_lower_drain+0x36ae>
  8c561e:	41 8b 73 0c          	mov    0xc(%r11),%esi
  8c5622:	85 f6                	test   %esi,%esi
  8c5624:	74 20                	je     8c5646 <check_lower_drain+0x3616>
  8c5626:	41 83 7b 54 00       	cmpl   $0x0,0x54(%r11)
  8c562b:	75 19                	jne    8c5646 <check_lower_drain+0x3616>
  8c562d:	45 0f b7 53 08       	movzwl 0x8(%r11),%r10d
  8c5632:	41 f7 c2 10 08 00 00 	test   $0x810,%r10d
  8c5639:	75 0b                	jne    8c5646 <check_lower_drain+0x3616>
  8c563b:	41 83 7b 04 00       	cmpl   $0x0,0x4(%r11)
  8c5640:	0f 84 92 07 00 00    	je     8c5dd8 <check_lower_drain+0x3da8>
  8c5646:	85 db                	test   %ebx,%ebx
  8c5648:	0f 85 90 00 00 00    	jne    8c56de <check_lower_drain+0x36ae>
  8c564e:	41 83 7b 04 01       	cmpl   $0x1,0x4(%r11)
  8c5653:	40 0f 94 c6          	sete   %sil
  8c5657:	40 22 74 24 58       	and    0x58(%rsp),%sil
  8c565c:	40 80 fe 01          	cmp    $0x1,%sil
  8c5660:	75 7c                	jne    8c56de <check_lower_drain+0x36ae>
  8c5662:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c5667:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8c566c:	31 db                	xor    %ebx,%ebx
  8c566e:	48 8b 76 68          	mov    0x68(%rsi),%rsi
  8c5672:	44 8b 1c 8e          	mov    (%rsi,%rcx,4),%r11d
  8c5676:	49 8b b1 80 00 00 00 	mov    0x80(%r9),%rsi
  8c567d:	8b 0c 8e             	mov    (%rsi,%rcx,4),%ecx
  8c5680:	41 83 fb ff          	cmp    $0xffffffff,%r11d
  8c5684:	0f 94 c3             	sete   %bl
  8c5687:	c1 e3 09             	shl    $0x9,%ebx
  8c568a:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8c5690:	41 83 fb ff          	cmp    $0xffffffff,%r11d
  8c5694:	44 0f 44 d9          	cmove  %ecx,%r11d
  8c5698:	0f 85 c2 07 00 00    	jne    8c5e60 <check_lower_drain+0x3e30>
  8c569e:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c56a3:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c56a8:	85 c9                	test   %ecx,%ecx
  8c56aa:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  8c56af:	0f 84 8e cd ff ff    	je     8c2443 <check_lower_drain+0x413>
  8c56b5:	e9 4a ea ff ff       	jmp    8c4104 <check_lower_drain+0x20d4>
  8c56ba:	83 7c 24 48 3e       	cmpl   $0x3e,0x48(%rsp)
  8c56bf:	0f 87 e5 01 00 00    	ja     8c58aa <check_lower_drain+0x387a>
  8c56c5:	44 8b 54 24 48       	mov    0x48(%rsp),%r10d
  8c56ca:	49 bb 00 00 00 00 08 	movabs $0x4080000800000000,%r11
  8c56d1:	00 80 40 
  8c56d4:	4d 0f a3 d3          	bt     %r10,%r11
  8c56d8:	0f 83 cc 01 00 00    	jae    8c58aa <check_lower_drain+0x387a>
  8c56de:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c56e3:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  8c56e8:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c56ed:	e9 51 cd ff ff       	jmp    8c2443 <check_lower_drain+0x413>
  8c56f2:	83 7c 24 68 1d       	cmpl   $0x1d,0x68(%rsp)
  8c56f7:	0f 87 15 02 00 00    	ja     8c5912 <check_lower_drain+0x38e2>
  8c56fd:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8c5702:	b8 60 00 00 20       	mov    $0x20000060,%eax
  8c5707:	0f a3 c8             	bt     %ecx,%eax
  8c570a:	0f 83 02 02 00 00    	jae    8c5912 <check_lower_drain+0x38e2>
  8c5710:	4c 8b 6c 24 60       	mov    0x60(%rsp),%r13
  8c5715:	41 c1 ed 03          	shr    $0x3,%r13d
  8c5719:	44 3b 6c 24 3c       	cmp    0x3c(%rsp),%r13d
  8c571e:	0f 83 98 00 00 00    	jae    8c57bc <check_lower_drain+0x378c>
  8c5724:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5729:	48 8b 80 a0 01 00 00 	mov    0x1a0(%rax),%rax
  8c5730:	46 0f b6 24 28       	movzbl (%rax,%r13,1),%r12d
  8c5735:	41 80 e4 08          	and    $0x8,%r12b
  8c5739:	e9 81 00 00 00       	jmp    8c57bf <check_lower_drain+0x378f>
  8c573e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5743:	8b 80 38 01 00 00    	mov    0x138(%rax),%eax
  8c5749:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  8c574e:	77 39                	ja     8c5789 <check_lower_drain+0x3759>
  8c5750:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c5755:	3b 86 40 01 00 00    	cmp    0x140(%rsi),%eax
  8c575b:	73 2c                	jae    8c5789 <check_lower_drain+0x3759>
  8c575d:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c5762:	80 be f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rsi)
  8c5769:	0f 85 f8 01 00 00    	jne    8c5967 <check_lower_drain+0x3937>
  8c576f:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c5774:	0f b6 d2             	movzbl %dl,%edx
  8c5777:	be 01 00 00 00       	mov    $0x1,%esi
  8c577c:	c5 f8 77             	vzeroupper
  8c577f:	e8 9c 90 01 00       	call   8de820 <check_lower_emit_tracked>
  8c5784:	e9 fa c8 ff ff       	jmp    8c2083 <check_lower_drain+0x53>
  8c5789:	83 bb f0 00 00 00 00 	cmpl   $0x0,0xf0(%rbx)
  8c5790:	0f 85 ed c8 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c5796:	c7 83 f0 00 00 00 03 	movl   $0x3,0xf0(%rbx)
  8c579d:	00 00 00 
  8c57a0:	e9 a2 d0 ff ff       	jmp    8c2847 <check_lower_drain+0x817>
  8c57a5:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c57aa:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c57af:	c5 f8 77             	vzeroupper
  8c57b2:	e8 69 06 01 00       	call   8d5e20 <check_lower_complex_update>
  8c57b7:	e9 c2 c8 ff ff       	jmp    8c207e <check_lower_drain+0x4e>
  8c57bc:	45 31 e4             	xor    %r12d,%r12d
  8c57bf:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  8c57c4:	c1 e8 03             	shr    $0x3,%eax
  8c57c7:	3b 44 24 3c          	cmp    0x3c(%rsp),%eax
  8c57cb:	73 1b                	jae    8c57e8 <check_lower_drain+0x37b8>
  8c57cd:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c57d2:	48 8b 89 a0 01 00 00 	mov    0x1a0(%rcx),%rcx
  8c57d9:	44 0f b6 34 01       	movzbl (%rcx,%rax,1),%r14d
  8c57de:	41 80 e6 08          	and    $0x8,%r14b
  8c57e2:	41 c0 ee 03          	shr    $0x3,%r14b
  8c57e6:	eb 03                	jmp    8c57eb <check_lower_drain+0x37bb>
  8c57e8:	45 31 f6             	xor    %r14d,%r14d
  8c57eb:	45 84 e4             	test   %r12b,%r12b
  8c57ee:	75 2e                	jne    8c581e <check_lower_drain+0x37ee>
  8c57f0:	45 84 f6             	test   %r14b,%r14b
  8c57f3:	75 29                	jne    8c581e <check_lower_drain+0x37ee>
  8c57f5:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  8c57fa:	c5 f8 77             	vzeroupper
  8c57fd:	e8 5e 1a 01 00       	call   8d7260 <check_lower_binary>
  8c5802:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c5807:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c580c:	0f b6 f0             	movzbl %al,%esi
  8c580f:	31 c9                	xor    %ecx,%ecx
  8c5811:	48 89 df             	mov    %rbx,%rdi
  8c5814:	e8 37 0c 00 00       	call   8c6450 <check_lower_instruction>
  8c5819:	e9 5f 05 00 00       	jmp    8c5d7d <check_lower_drain+0x3d4d>
  8c581e:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  8c5823:	45 84 e4             	test   %r12b,%r12b
  8c5826:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c582b:	41 0f 95 c7          	setne  %r15b
  8c582f:	89 c5                	mov    %eax,%ebp
  8c5831:	0f 45 6c 24 60       	cmovne 0x60(%rsp),%ebp
  8c5836:	89 ee                	mov    %ebp,%esi
  8c5838:	c5 f8 77             	vzeroupper
  8c583b:	e8 80 17 01 00       	call   8d6fc0 <check_lower_stride>
  8c5840:	45 20 f7             	and    %r14b,%r15b
  8c5843:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8c5848:	41 80 ff 01          	cmp    $0x1,%r15b
  8c584c:	0f 85 4e 01 00 00    	jne    8c59a0 <check_lower_drain+0x3970>
  8c5852:	83 7c 24 68 06       	cmpl   $0x6,0x68(%rsp)
  8c5857:	0f 85 43 01 00 00    	jne    8c59a0 <check_lower_drain+0x3970>
  8c585d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5862:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5868:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c586e:	0f 83 4c 02 00 00    	jae    8c5ac0 <check_lower_drain+0x3a90>
  8c5874:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c5879:	8d 50 01             	lea    0x1(%rax),%edx
  8c587c:	48 c1 e0 04          	shl    $0x4,%rax
  8c5880:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c5884:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c588a:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c5891:	00 07 00 
  8c5894:	48 83 c2 0d          	add    $0xd,%rdx
  8c5898:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c589c:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c58a3:	00 00 
  8c58a5:	e9 47 02 00 00       	jmp    8c5af1 <check_lower_drain+0x3ac1>
  8c58aa:	83 bc 24 88 00 00 00 	cmpl   $0x1,0x88(%rsp)
  8c58b1:	01 
  8c58b2:	0f 85 26 fe ff ff    	jne    8c56de <check_lower_drain+0x36ae>
  8c58b8:	4c 8b 76 10          	mov    0x10(%rsi),%r14
  8c58bc:	83 7c 24 78 06       	cmpl   $0x6,0x78(%rsp)
  8c58c1:	c7 44 24 48 01 00 00 	movl   $0x1,0x48(%rsp)
  8c58c8:	00 
  8c58c9:	0f 87 09 03 00 00    	ja     8c5bd8 <check_lower_drain+0x3ba8>
  8c58cf:	41 d1 e9             	shr    $1,%r9d
  8c58d2:	be 08 00 00 00       	mov    $0x8,%esi
  8c58d7:	49 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%r10
  8c58de:	c4 e2 31 f7 f6       	shlx   %r9d,%esi,%esi
  8c58e3:	c4 42 c8 f5 de       	bzhi   %rsi,%r14,%r11
  8c58e8:	c4 42 c9 f7 ca       	shlx   %rsi,%r10,%r9
  8c58ed:	ff ce                	dec    %esi
  8c58ef:	41 be 00 00 00 00    	mov    $0x0,%r14d
  8c58f5:	c4 c2 cb f7 f3       	shrx   %rsi,%r11,%rsi
  8c58fa:	48 85 f6             	test   %rsi,%rsi
  8c58fd:	4c 0f 44 ce          	cmove  %rsi,%r9
  8c5901:	31 f6                	xor    %esi,%esi
  8c5903:	f6 c1 01             	test   $0x1,%cl
  8c5906:	4d 0f 45 f1          	cmovne %r9,%r14
  8c590a:	4d 09 de             	or     %r11,%r14
  8c590d:	e9 cc e7 ff ff       	jmp    8c40de <check_lower_drain+0x20ae>
  8c5912:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  8c5917:	c5 f8 77             	vzeroupper
  8c591a:	e8 41 19 01 00       	call   8d7260 <check_lower_binary>
  8c591f:	84 c0                	test   %al,%al
  8c5921:	0f 84 20 02 00 00    	je     8c5b47 <check_lower_drain+0x3b17>
  8c5927:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c592c:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c5931:	0f b6 e8             	movzbl %al,%ebp
  8c5934:	89 ee                	mov    %ebp,%esi
  8c5936:	48 89 df             	mov    %rbx,%rdi
  8c5939:	e8 42 19 01 00       	call   8d7280 <check_lower_operation>
  8c593e:	4c 8b 7c 24 78       	mov    0x78(%rsp),%r15
  8c5943:	48 89 df             	mov    %rbx,%rdi
  8c5946:	89 ee                	mov    %ebp,%esi
  8c5948:	44 89 fa             	mov    %r15d,%edx
  8c594b:	e8 40 1d 01 00       	call   8d7690 <check_lower_count>
  8c5950:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  8c5955:	48 89 df             	mov    %rbx,%rdi
  8c5958:	ba 01 00 00 00       	mov    $0x1,%edx
  8c595d:	31 c9                	xor    %ecx,%ecx
  8c595f:	45 89 f8             	mov    %r15d,%r8d
  8c5962:	e9 2a 04 00 00       	jmp    8c5d91 <check_lower_drain+0x3d61>
  8c5967:	83 bb f0 00 00 00 00 	cmpl   $0x0,0xf0(%rbx)
  8c596e:	0f 85 0f c7 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c5974:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c5979:	49 ff c4             	inc    %r12
  8c597c:	48 8b 77 20          	mov    0x20(%rdi),%rsi
  8c5980:	c6 04 06 01          	movb   $0x1,(%rsi,%rax,1)
  8c5984:	48 8b 77 28          	mov    0x28(%rdi),%rsi
  8c5988:	88 14 06             	mov    %dl,(%rsi,%rax,1)
  8c598b:	48 8b 57 30          	mov    0x30(%rdi),%rdx
  8c598f:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c5993:	ff c0                	inc    %eax
  8c5995:	89 87 38 01 00 00    	mov    %eax,0x138(%rdi)
  8c599b:	e9 e6 c6 ff ff       	jmp    8c2086 <check_lower_drain+0x56>
  8c59a0:	83 7c 24 68 1d       	cmpl   $0x1d,0x68(%rsp)
  8c59a5:	0f 95 c0             	setne  %al
  8c59a8:	0a 5c 24 70          	or     0x70(%rsp),%bl
  8c59ac:	08 c3                	or     %al,%bl
  8c59ae:	f6 c3 01             	test   $0x1,%bl
  8c59b1:	0f 84 b7 01 00 00    	je     8c5b6e <check_lower_drain+0x3b3e>
  8c59b7:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c59bc:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c59c1:	89 ee                	mov    %ebp,%esi
  8c59c3:	e8 18 17 01 00       	call   8d70e0 <check_lower_scale>
  8c59c8:	83 7c 24 68 06       	cmpl   $0x6,0x68(%rsp)
  8c59cd:	0f 85 c3 01 00 00    	jne    8c5b96 <check_lower_drain+0x3b66>
  8c59d3:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c59d8:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c59de:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c59e4:	0f 83 b4 03 00 00    	jae    8c5d9e <check_lower_drain+0x3d6e>
  8c59ea:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c59ef:	8d 50 01             	lea    0x1(%rax),%edx
  8c59f2:	48 c1 e0 04          	shl    $0x4,%rax
  8c59f6:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c59fa:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c5a00:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c5a07:	00 07 00 
  8c5a0a:	48 83 c2 06          	add    $0x6,%rdx
  8c5a0e:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c5a12:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c5a19:	00 00 
  8c5a1b:	e9 76 01 00 00       	jmp    8c5b96 <check_lower_drain+0x3b66>
  8c5a20:	83 7c 24 68 1b       	cmpl   $0x1b,0x68(%rsp)
  8c5a25:	0f 84 bc fa ff ff    	je     8c54e7 <check_lower_drain+0x34b7>
  8c5a2b:	85 c0                	test   %eax,%eax
  8c5a2d:	74 71                	je     8c5aa0 <check_lower_drain+0x3a70>
  8c5a2f:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  8c5a34:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c5a39:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c5a3e:	31 c9                	xor    %ecx,%ecx
  8c5a40:	4c 89 f7             	mov    %r14,%rdi
  8c5a43:	c5 f8 77             	vzeroupper
  8c5a46:	e8 05 0a 00 00       	call   8c6450 <check_lower_instruction>
  8c5a4b:	45 8b 45 00          	mov    0x0(%r13),%r8d
  8c5a4f:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c5a54:	4c 89 f7             	mov    %r14,%rdi
  8c5a57:	31 d2                	xor    %edx,%edx
  8c5a59:	31 c9                	xor    %ecx,%ecx
  8c5a5b:	e8 60 9e 00 00       	call   8cf8c0 <check_lower_operand>
  8c5a60:	48 8d 84 24 68 01 00 	lea    0x168(%rsp),%rax
  8c5a67:	00 
  8c5a68:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c5a6c:	4c 89 f7             	mov    %r14,%rdi
  8c5a6f:	c5 fa 7f 00          	vmovdqu %xmm0,(%rax)
  8c5a73:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8c5a7a:	00 
  8c5a7b:	c7 84 24 60 01 00 00 	movl   $0xa,0x160(%rsp)
  8c5a82:	0a 00 00 00 
  8c5a86:	89 9c 24 64 01 00 00 	mov    %ebx,0x164(%rsp)
  8c5a8d:	c5 fe 6f 84 24 60 01 	vmovdqu 0x160(%rsp),%ymm0
  8c5a94:	00 00 
  8c5a96:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c5a9b:	e9 77 f9 ff ff       	jmp    8c5417 <check_lower_drain+0x33e7>
  8c5aa0:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5aa5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5aa9:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5ab0:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c5ab5:	0f 85 c8 c5 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c5abb:	e9 7d cd ff ff       	jmp    8c283d <check_lower_drain+0x80d>
  8c5ac0:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5ac5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5ac9:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5ad0:	75 1f                	jne    8c5af1 <check_lower_drain+0x3ac1>
  8c5ad2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5ad7:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5ade:	00 00 00 
  8c5ae1:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5ae7:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5aeb:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5af1:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
  8c5af7:	0f 84 e2 00 00 00    	je     8c5bdf <check_lower_drain+0x3baf>
  8c5afd:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5b02:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5b08:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c5b0e:	0f 83 45 01 00 00    	jae    8c5c59 <check_lower_drain+0x3c29>
  8c5b14:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c5b19:	8d 50 01             	lea    0x1(%rax),%edx
  8c5b1c:	48 c1 e0 04          	shl    $0x4,%rax
  8c5b20:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c5b24:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c5b2a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8c5b2f:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c5b36:	00 07 00 
  8c5b39:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c5b3d:	48 89 74 01 08       	mov    %rsi,0x8(%rcx,%rax,1)
  8c5b42:	e9 43 01 00 00       	jmp    8c5c8a <check_lower_drain+0x3c5a>
  8c5b47:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5b4c:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c5b51:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5b55:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5b5c:	0f 85 21 c5 ff ff    	jne    8c2083 <check_lower_drain+0x53>
  8c5b62:	48 8d 0d 2b 08 e1 ff 	lea    -0x1ef7d5(%rip),%rcx        # 6d6394 <pp_string_value.meaning+0x22a90>
  8c5b69:	e9 26 cf ff ff       	jmp    8c2a94 <check_lower_drain+0xa64>
  8c5b6e:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c5b73:	0f b6 54 24 50       	movzbl 0x50(%rsp),%edx
  8c5b78:	be 0a 00 00 00       	mov    $0xa,%esi
  8c5b7d:	31 c9                	xor    %ecx,%ecx
  8c5b7f:	48 89 df             	mov    %rbx,%rdi
  8c5b82:	e8 c9 08 00 00       	call   8c6450 <check_lower_instruction>
  8c5b87:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c5b8c:	48 89 df             	mov    %rbx,%rdi
  8c5b8f:	89 ee                	mov    %ebp,%esi
  8c5b91:	e8 4a 15 01 00       	call   8d70e0 <check_lower_scale>
  8c5b96:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c5b9b:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
  8c5ba0:	45 31 f6             	xor    %r14d,%r14d
  8c5ba3:	45 84 e4             	test   %r12b,%r12b
  8c5ba6:	41 b8 50 00 00 00    	mov    $0x50,%r8d
  8c5bac:	41 0f 94 c6          	sete   %r14b
  8c5bb0:	41 c0 ec 03          	shr    $0x3,%r12b
  8c5bb4:	31 c9                	xor    %ecx,%ecx
  8c5bb6:	41 0f b6 d4          	movzbl %r12b,%edx
  8c5bba:	48 89 df             	mov    %rbx,%rdi
  8c5bbd:	44 89 fe             	mov    %r15d,%esi
  8c5bc0:	e8 fb 9c 00 00       	call   8cf8c0 <check_lower_operand>
  8c5bc5:	48 89 df             	mov    %rbx,%rdi
  8c5bc8:	44 89 fe             	mov    %r15d,%esi
  8c5bcb:	44 89 f2             	mov    %r14d,%edx
  8c5bce:	31 c9                	xor    %ecx,%ecx
  8c5bd0:	41 89 e8             	mov    %ebp,%r8d
  8c5bd3:	e9 42 cc ff ff       	jmp    8c281a <check_lower_drain+0x7ea>
  8c5bd8:	31 f6                	xor    %esi,%esi
  8c5bda:	e9 ff e4 ff ff       	jmp    8c40de <check_lower_drain+0x20ae>
  8c5bdf:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c5be4:	48 8b 08             	mov    (%rax),%rcx
  8c5be7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8c5beb:	42 80 3c 29 0f       	cmpb   $0xf,(%rcx,%r13,1)
  8c5bf0:	75 0e                	jne    8c5c00 <check_lower_drain+0x3bd0>
  8c5bf2:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  8c5bf7:	89 d5                	mov    %edx,%ebp
  8c5bf9:	83 e5 07             	and    $0x7,%ebp
  8c5bfc:	42 0b 2c a8          	or     (%rax,%r13,4),%ebp
  8c5c00:	89 ea                	mov    %ebp,%edx
  8c5c02:	c1 ea 03             	shr    $0x3,%edx
  8c5c05:	83 e5 07             	and    $0x7,%ebp
  8c5c08:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c5c0c:	0f b6 0c 11          	movzbl (%rcx,%rdx,1),%ecx
  8c5c10:	80 c1 f8             	add    $0xf8,%cl
  8c5c13:	80 f9 03             	cmp    $0x3,%cl
  8c5c16:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c5c1b:	0f 43 e9             	cmovae %ecx,%ebp
  8c5c1e:	0b 2c 90             	or     (%rax,%rdx,4),%ebp
  8c5c21:	c5 fe 7f 84 24 c0 01 	vmovdqu %ymm0,0x1c0(%rsp)
  8c5c28:	00 00 
  8c5c2a:	c7 84 24 c0 01 00 00 	movl   $0x13,0x1c0(%rsp)
  8c5c31:	13 00 00 00 
  8c5c35:	89 ac 24 c8 01 00 00 	mov    %ebp,0x1c8(%rsp)
  8c5c3c:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c5c43:	00 00 
  8c5c45:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c5c4a:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c5c4f:	c5 f8 77             	vzeroupper
  8c5c52:	e8 a9 45 00 00       	call   8ca200 <check_lower_push>
  8c5c57:	eb 31                	jmp    8c5c8a <check_lower_drain+0x3c5a>
  8c5c59:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5c5e:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5c62:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5c69:	75 1f                	jne    8c5c8a <check_lower_drain+0x3c5a>
  8c5c6b:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5c70:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5c77:	00 00 00 
  8c5c7a:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5c80:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5c84:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5c8a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5c8f:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5c95:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c5c9b:	73 33                	jae    8c5cd0 <check_lower_drain+0x3ca0>
  8c5c9d:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c5ca2:	8d 50 01             	lea    0x1(%rax),%edx
  8c5ca5:	48 c1 e0 04          	shl    $0x4,%rax
  8c5ca9:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c5cad:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c5cb3:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c5cba:	00 07 00 
  8c5cbd:	48 83 c2 08          	add    $0x8,%rdx
  8c5cc1:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c5cc5:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c5ccc:	00 00 
  8c5cce:	eb 31                	jmp    8c5d01 <check_lower_drain+0x3cd1>
  8c5cd0:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5cd5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5cd9:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5ce0:	75 1f                	jne    8c5d01 <check_lower_drain+0x3cd1>
  8c5ce2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5ce7:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5cee:	00 00 00 
  8c5cf1:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5cf7:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5cfb:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5d01:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5d06:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5d0c:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c5d12:	73 33                	jae    8c5d47 <check_lower_drain+0x3d17>
  8c5d14:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8c5d19:	8d 50 01             	lea    0x1(%rax),%edx
  8c5d1c:	48 c1 e0 04          	shl    $0x4,%rax
  8c5d20:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c5d24:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c5d2a:	48 ba 01 00 00 00 01 	movabs $0x8000100000001,%rdx
  8c5d31:	00 08 00 
  8c5d34:	48 83 c2 0b          	add    $0xb,%rdx
  8c5d38:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c5d3c:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c5d43:	00 00 
  8c5d45:	eb 31                	jmp    8c5d78 <check_lower_drain+0x3d48>
  8c5d47:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5d4c:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5d50:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5d57:	75 1f                	jne    8c5d78 <check_lower_drain+0x3d48>
  8c5d59:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5d5e:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5d65:	00 00 00 
  8c5d68:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5d6e:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5d72:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5d78:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8c5d7d:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  8c5d82:	ba 01 00 00 00       	mov    $0x1,%edx
  8c5d87:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
  8c5d8c:	48 89 df             	mov    %rbx,%rdi
  8c5d8f:	31 c9                	xor    %ecx,%ecx
  8c5d91:	44 89 f6             	mov    %r14d,%esi
  8c5d94:	e8 27 9b 00 00       	call   8cf8c0 <check_lower_operand>
  8c5d99:	e9 ec d4 ff ff       	jmp    8c328a <check_lower_drain+0x125a>
  8c5d9e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c5da3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5da7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5dae:	0f 85 e2 fd ff ff    	jne    8c5b96 <check_lower_drain+0x3b66>
  8c5db4:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5db9:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5dc0:	00 00 00 
  8c5dc3:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5dc9:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5dcd:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5dd3:	e9 be fd ff ff       	jmp    8c5b96 <check_lower_drain+0x3b66>
  8c5dd8:	83 fb 3e             	cmp    $0x3e,%ebx
  8c5ddb:	77 16                	ja     8c5df3 <check_lower_drain+0x3dc3>
  8c5ddd:	49 ba 00 00 00 00 08 	movabs $0x4080000800000000,%r10
  8c5de4:	00 80 40 
  8c5de7:	89 d9                	mov    %ebx,%ecx
  8c5de9:	49 0f a3 ca          	bt     %rcx,%r10
  8c5ded:	0f 82 eb f8 ff ff    	jb     8c56de <check_lower_drain+0x36ae>
  8c5df3:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  8c5df8:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c5dfd:	83 fe 01             	cmp    $0x1,%esi
  8c5e00:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c5e05:	0f 85 38 c6 ff ff    	jne    8c2443 <check_lower_drain+0x413>
  8c5e0b:	4d 8b 5b 10          	mov    0x10(%r11),%r11
  8c5e0f:	bb 00 01 00 00       	mov    $0x100,%ebx
  8c5e14:	41 83 f9 06          	cmp    $0x6,%r9d
  8c5e18:	77 46                	ja     8c5e60 <check_lower_drain+0x3e30>
  8c5e1a:	d1 ed                	shr    $1,%ebp
  8c5e1c:	b8 08 00 00 00       	mov    $0x8,%eax
  8c5e21:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  8c5e28:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c5e2d:	c4 e2 51 f7 c0       	shlx   %ebp,%eax,%eax
  8c5e32:	c4 c2 f8 f5 f3       	bzhi   %rax,%r11,%rsi
  8c5e37:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
  8c5e3c:	ff c8                	dec    %eax
  8c5e3e:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8c5e44:	c4 e2 fb f7 c6       	shrx   %rax,%rsi,%rax
  8c5e49:	48 85 c0             	test   %rax,%rax
  8c5e4c:	48 0f 44 c8          	cmove  %rax,%rcx
  8c5e50:	40 f6 c7 01          	test   $0x1,%dil
  8c5e54:	4c 0f 45 d9          	cmovne %rcx,%r11
  8c5e58:	49 09 f3             	or     %rsi,%r11
  8c5e5b:	e9 a4 e2 ff ff       	jmp    8c4104 <check_lower_drain+0x20d4>
  8c5e60:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
  8c5e65:	e9 9a e2 ff ff       	jmp    8c4104 <check_lower_drain+0x20d4>
  8c5e6a:	4d 01 a2 00 02 00 00 	add    %r12,0x200(%r10)
  8c5e71:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c5e78:	00 00 
  8c5e7a:	48 3b 84 24 00 02 00 	cmp    0x200(%rsp),%rax
  8c5e81:	00 
  8c5e82:	75 15                	jne    8c5e99 <check_lower_drain+0x3e69>
  8c5e84:	48 81 c4 08 02 00 00 	add    $0x208,%rsp
  8c5e8b:	5b                   	pop    %rbx
  8c5e8c:	41 5c                	pop    %r12
  8c5e8e:	41 5d                	pop    %r13
  8c5e90:	41 5e                	pop    %r14
  8c5e92:	41 5f                	pop    %r15
  8c5e94:	5d                   	pop    %rbp
  8c5e95:	c5 f8 77             	vzeroupper
  8c5e98:	c3                   	ret
  8c5e99:	c5 f8 77             	vzeroupper
  8c5e9c:	e8 cf 7e f0 ff       	call   7cdd70 <__stack_chk_fail@plt>
