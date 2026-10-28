
/home/david/buster-fast-bench/issue624/placements-hot/compiler-2048:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008c1fa0 <check_lower_drain>:
  8c1fa0:	55                   	push   %rbp
  8c1fa1:	41 57                	push   %r15
  8c1fa3:	41 56                	push   %r14
  8c1fa5:	41 55                	push   %r13
  8c1fa7:	41 54                	push   %r12
  8c1fa9:	53                   	push   %rbx
  8c1faa:	48 81 ec 08 02 00 00 	sub    $0x208,%rsp
  8c1fb1:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c1fb8:	00 00 
  8c1fba:	49 89 fd             	mov    %rdi,%r13
  8c1fbd:	31 ed                	xor    %ebp,%ebp
  8c1fbf:	48 89 84 24 00 02 00 	mov    %rax,0x200(%rsp)
  8c1fc6:	00 
  8c1fc7:	8b 87 3c 01 00 00    	mov    0x13c(%rdi),%eax
  8c1fcd:	85 c0                	test   %eax,%eax
  8c1fcf:	0f 84 5e 3f 00 00    	je     8c5f33 <check_lower_drain+0x3f93>
  8c1fd5:	4c 89 6c 24 28       	mov    %r13,0x28(%rsp)
  8c1fda:	eb 33                	jmp    8c200f <check_lower_drain+0x6f>
  8c1fdc:	0f 1f 40 00          	nopl   0x0(%rax)
  8c1fe0:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c1fe4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c1feb:	0f 84 b7 02 00 00    	je     8c22a8 <check_lower_drain+0x308>
  8c1ff1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c1ff8:	0f 1f 84 00 00 00 00 
  8c1fff:	00 
  8c2000:	41 8b 85 3c 01 00 00 	mov    0x13c(%r13),%eax
  8c2007:	85 c0                	test   %eax,%eax
  8c2009:	0f 84 24 3f 00 00    	je     8c5f33 <check_lower_drain+0x3f93>
  8c200f:	4d 8b 7d 08          	mov    0x8(%r13),%r15
  8c2013:	41 83 bf f0 00 00 00 	cmpl   $0x0,0xf0(%r15)
  8c201a:	00 
  8c201b:	0f 85 12 3f 00 00    	jne    8c5f33 <check_lower_drain+0x3f93>
  8c2021:	49 8b 4d 18          	mov    0x18(%r13),%rcx
  8c2025:	8d 50 ff             	lea    -0x1(%rax),%edx
  8c2028:	48 89 d7             	mov    %rdx,%rdi
  8c202b:	41 89 95 3c 01 00 00 	mov    %edx,0x13c(%r13)
  8c2032:	48 c1 e7 04          	shl    $0x4,%rdi
  8c2036:	48 8b 34 39          	mov    (%rcx,%rdi,1),%rsi
  8c203a:	4c 8b 74 39 08       	mov    0x8(%rcx,%rdi,1),%r14
  8c203f:	49 89 f0             	mov    %rsi,%r8
  8c2042:	49 c1 e8 20          	shr    $0x20,%r8
  8c2046:	41 0f b6 f8          	movzbl %r8b,%edi
  8c204a:	83 ff 01             	cmp    $0x1,%edi
  8c204d:	0f 87 e5 04 00 00    	ja     8c2538 <check_lower_drain+0x598>
  8c2053:	45 0f b6 85 f8 01 00 	movzbl 0x1f8(%r13),%r8d
  8c205a:	00 
  8c205b:	85 ff                	test   %edi,%edi
  8c205d:	74 61                	je     8c20c0 <check_lower_drain+0x120>
  8c205f:	45 84 c0             	test   %r8b,%r8b
  8c2062:	0f 84 98 01 00 00    	je     8c2200 <check_lower_drain+0x260>
  8c2068:	48 89 f0             	mov    %rsi,%rax
  8c206b:	48 c1 e8 30          	shr    $0x30,%rax
  8c206f:	3c 0f                	cmp    $0xf,%al
  8c2071:	0f 83 69 ff ff ff    	jae    8c1fe0 <check_lower_drain+0x40>
  8c2077:	41 8b 8d 38 01 00 00 	mov    0x138(%r13),%ecx
  8c207e:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8c2084:	0f 87 01 02 00 00    	ja     8c228b <check_lower_drain+0x2eb>
  8c208a:	41 3b 8d 40 01 00 00 	cmp    0x140(%r13),%ecx
  8c2091:	0f 83 f4 01 00 00    	jae    8c228b <check_lower_drain+0x2eb>
  8c2097:	41 80 bd f9 01 00 00 	cmpb   $0x1,0x1f9(%r13)
  8c209e:	01 
  8c209f:	0f 85 42 02 00 00    	jne    8c22e7 <check_lower_drain+0x347>
  8c20a5:	40 0f b6 f6          	movzbl %sil,%esi
  8c20a9:	0f b6 d0             	movzbl %al,%edx
  8c20ac:	4c 89 ef             	mov    %r13,%rdi
  8c20af:	4c 89 f1             	mov    %r14,%rcx
  8c20b2:	c5 f8 77             	vzeroupper
  8c20b5:	e8 26 c8 01 00       	call   8de8e0 <check_lower_emit_tracked>
  8c20ba:	e9 41 ff ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c20bf:	90                   	nop
  8c20c0:	48 89 6c 24 60       	mov    %rbp,0x60(%rsp)
  8c20c5:	45 84 c0             	test   %r8b,%r8b
  8c20c8:	0f 85 72 07 00 00    	jne    8c2840 <check_lower_drain+0x8a0>
  8c20ce:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c20d3:	48 b9 00 00 00 00 00 	movabs $0x40000000000,%rcx
  8c20da:	04 00 00 
  8c20dd:	49 8b 9d a8 01 00 00 	mov    0x1a8(%r13),%rbx
  8c20e4:	48 85 db             	test   %rbx,%rbx
  8c20e7:	0f 94 c0             	sete   %al
  8c20ea:	48 85 ce             	test   %rcx,%rsi
  8c20ed:	0f 95 c1             	setne  %cl
  8c20f0:	08 c1                	or     %al,%cl
  8c20f2:	0f 85 f5 05 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c20f8:	4d 8b 4d 00          	mov    0x0(%r13),%r9
  8c20fc:	41 89 f0             	mov    %esi,%r8d
  8c20ff:	4b 8d 0c 40          	lea    (%r8,%r8,2),%rcx
  8c2103:	48 c1 e1 05          	shl    $0x5,%rcx
  8c2107:	49 8b 39             	mov    (%r9),%rdi
  8c210a:	49 8b 41 08          	mov    0x8(%r9),%rax
  8c210e:	4c 8b 17             	mov    (%rdi),%r10
  8c2111:	48 03 48 08          	add    0x8(%rax),%rcx
  8c2115:	47 8b 1c 82          	mov    (%r10,%r8,4),%r11d
  8c2119:	45 85 db             	test   %r11d,%r11d
  8c211c:	74 5d                	je     8c217b <check_lower_drain+0x1db>
  8c211e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c2125:	01 00 00 
  8c2128:	48 85 c6             	test   %rax,%rsi
  8c212b:	0f 85 bc 05 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c2131:	83 79 0c 00          	cmpl   $0x0,0xc(%rcx)
  8c2135:	0f 84 b2 05 00 00    	je     8c26ed <check_lower_drain+0x74d>
  8c213b:	83 79 54 00          	cmpl   $0x0,0x54(%rcx)
  8c213f:	0f 85 a8 05 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c2145:	0f b7 41 08          	movzwl 0x8(%rcx),%eax
  8c2149:	a9 10 08 00 00       	test   $0x810,%eax
  8c214e:	0f 85 99 05 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c2154:	83 79 04 00          	cmpl   $0x0,0x4(%rcx)
  8c2158:	0f 85 8f 05 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c215e:	41 83 fb 3e          	cmp    $0x3e,%r11d
  8c2162:	77 17                	ja     8c217b <check_lower_drain+0x1db>
  8c2164:	49 ba 00 00 00 00 08 	movabs $0x4080000800000000,%r10
  8c216b:	00 80 40 
  8c216e:	44 89 d8             	mov    %r11d,%eax
  8c2171:	49 0f a3 c2          	bt     %rax,%r10
  8c2175:	0f 82 72 05 00 00    	jb     8c26ed <check_lower_drain+0x74d>
  8c217b:	8b 41 40             	mov    0x40(%rcx),%eax
  8c217e:	48 85 c0             	test   %rax,%rax
  8c2181:	0f 84 96 01 00 00    	je     8c231d <check_lower_drain+0x37d>
  8c2187:	45 8b b1 c0 00 00 00 	mov    0xc0(%r9),%r14d
  8c218e:	49 bc 00 00 00 00 00 	movabs $0x20000000000,%r12
  8c2195:	02 00 00 
  8c2198:	44 39 f0             	cmp    %r14d,%eax
  8c219b:	41 0f 92 c2          	setb   %r10b
  8c219f:	31 ed                	xor    %ebp,%ebp
  8c21a1:	4c 85 e6             	test   %r12,%rsi
  8c21a4:	0f 85 78 01 00 00    	jne    8c2322 <check_lower_drain+0x382>
  8c21aa:	45 85 db             	test   %r11d,%r11d
  8c21ad:	0f 85 6f 01 00 00    	jne    8c2322 <check_lower_drain+0x382>
  8c21b3:	44 39 f0             	cmp    %r14d,%eax
  8c21b6:	0f 83 66 01 00 00    	jae    8c2322 <check_lower_drain+0x382>
  8c21bc:	4c 8b a7 90 02 00 00 	mov    0x290(%rdi),%r12
  8c21c3:	44 8d 70 ff          	lea    -0x1(%rax),%r14d
  8c21c7:	41 b2 01             	mov    $0x1,%r10b
  8c21ca:	43 80 3c 34 00       	cmpb   $0x0,(%r12,%r14,1)
  8c21cf:	0f 84 b4 01 00 00    	je     8c2389 <check_lower_drain+0x3e9>
  8c21d5:	4c 8b a7 78 02 00 00 	mov    0x278(%rdi),%r12
  8c21dc:	43 80 3c 34 00       	cmpb   $0x0,(%r12,%r14,1)
  8c21e1:	40 0f 94 c5          	sete   %bpl
  8c21e5:	49 be 00 00 00 00 00 	movabs $0x10000000000,%r14
  8c21ec:	01 00 00 
  8c21ef:	4c 85 f6             	test   %r14,%rsi
  8c21f2:	0f 85 39 01 00 00    	jne    8c2331 <check_lower_drain+0x391>
  8c21f8:	e9 9d 01 00 00       	jmp    8c239a <check_lower_drain+0x3fa>
  8c21fd:	0f 1f 00             	nopl   (%rax)
  8c2200:	83 f8 03             	cmp    $0x3,%eax
  8c2203:	0f 82 5f fe ff ff    	jb     8c2068 <check_lower_drain+0xc8>
  8c2209:	41 80 bd f9 01 00 00 	cmpb   $0x0,0x1f9(%r13)
  8c2210:	00 
  8c2211:	0f 85 51 fe ff ff    	jne    8c2068 <check_lower_drain+0xc8>
  8c2217:	8d 50 fe             	lea    -0x2(%rax),%edx
  8c221a:	48 bf 00 00 00 00 ff 	movabs $0xff00000000,%rdi
  8c2221:	00 00 00 
  8c2224:	49 b8 00 00 00 00 01 	movabs $0x100000000,%r8
  8c222b:	00 00 00 
  8c222e:	48 c1 e2 04          	shl    $0x4,%rdx
  8c2232:	48 8b 14 11          	mov    (%rcx,%rdx,1),%rdx
  8c2236:	48 21 fa             	and    %rdi,%rdx
  8c2239:	4c 39 c2             	cmp    %r8,%rdx
  8c223c:	0f 85 26 fe ff ff    	jne    8c2068 <check_lower_drain+0xc8>
  8c2242:	83 c0 fd             	add    $0xfffffffd,%eax
  8c2245:	48 ba 00 00 00 00 01 	movabs $0x100000000,%rdx
  8c224c:	00 00 00 
  8c224f:	48 c1 e0 04          	shl    $0x4,%rax
  8c2253:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
  8c2257:	48 b9 00 00 00 00 ff 	movabs $0xff00000000,%rcx
  8c225e:	00 00 00 
  8c2261:	48 21 c8             	and    %rcx,%rax
  8c2264:	48 39 d0             	cmp    %rdx,%rax
  8c2267:	0f 85 fb fd ff ff    	jne    8c2068 <check_lower_drain+0xc8>
  8c226d:	4c 89 ef             	mov    %r13,%rdi
  8c2270:	48 89 f3             	mov    %rsi,%rbx
  8c2273:	c5 f8 77             	vzeroupper
  8c2276:	e8 a5 a4 00 00       	call   8cc720 <check_lower_instruction_batch>
  8c227b:	48 89 de             	mov    %rbx,%rsi
  8c227e:	84 c0                	test   %al,%al
  8c2280:	0f 85 7a fd ff ff    	jne    8c2000 <check_lower_drain+0x60>
  8c2286:	e9 dd fd ff ff       	jmp    8c2068 <check_lower_drain+0xc8>
  8c228b:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c228f:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2296:	0f 85 64 fd ff ff    	jne    8c2000 <check_lower_drain+0x60>
  8c229c:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c22a3:	00 00 00 
  8c22a6:	eb 29                	jmp    8c22d1 <check_lower_drain+0x331>
  8c22a8:	48 8d 0d 03 75 dc ff 	lea    -0x238afd(%rip),%rcx        # 6897b2 <fuzz_comment_end+0x26cbc>
  8c22af:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c22b6:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c22ba:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c22c1:	0f 85 39 fd ff ff    	jne    8c2000 <check_lower_drain+0x60>
  8c22c7:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c22ce:	00 00 00 
  8c22d1:	41 8b 85 64 01 00 00 	mov    0x164(%r13),%eax
  8c22d8:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  8c22dc:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c22e2:	e9 19 fd ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c22e7:	49 8b 55 08          	mov    0x8(%r13),%rdx
  8c22eb:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c22f2:	0f 85 08 fd ff ff    	jne    8c2000 <check_lower_drain+0x60>
  8c22f8:	49 8b 55 20          	mov    0x20(%r13),%rdx
  8c22fc:	40 88 34 0a          	mov    %sil,(%rdx,%rcx,1)
  8c2300:	49 8b 55 28          	mov    0x28(%r13),%rdx
  8c2304:	88 04 0a             	mov    %al,(%rdx,%rcx,1)
  8c2307:	49 8b 45 30          	mov    0x30(%r13),%rax
  8c230b:	4c 89 34 c8          	mov    %r14,(%rax,%rcx,8)
  8c230f:	ff c1                	inc    %ecx
  8c2311:	41 89 8d 38 01 00 00 	mov    %ecx,0x138(%r13)
  8c2318:	e9 e3 fc ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c231d:	45 31 d2             	xor    %r10d,%r10d
  8c2320:	31 ed                	xor    %ebp,%ebp
  8c2322:	49 be 00 00 00 00 00 	movabs $0x10000000000,%r14
  8c2329:	01 00 00 
  8c232c:	4c 85 f6             	test   %r14,%rsi
  8c232f:	74 69                	je     8c239a <check_lower_drain+0x3fa>
  8c2331:	45 85 db             	test   %r11d,%r11d
  8c2334:	75 64                	jne    8c239a <check_lower_drain+0x3fa>
  8c2336:	83 79 04 01          	cmpl   $0x1,0x4(%rcx)
  8c233a:	0f 85 ad 03 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c2340:	83 39 08             	cmpl   $0x8,(%rcx)
  8c2343:	0f 84 a4 03 00 00    	je     8c26ed <check_lower_drain+0x74d>
  8c2349:	83 79 44 00          	cmpl   $0x0,0x44(%rcx)
  8c234d:	41 f6 d2             	not    %r10b
  8c2350:	41 0f 95 c1          	setne  %r9b
  8c2354:	41 08 ea             	or     %bpl,%r10b
  8c2357:	45 08 ca             	or     %r9b,%r10b
  8c235a:	41 f6 c2 01          	test   $0x1,%r10b
  8c235e:	0f 85 89 03 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c2364:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8c2368:	4c 89 ef             	mov    %r13,%rdi
  8c236b:	89 c6                	mov    %eax,%esi
  8c236d:	42 8b 14 82          	mov    (%rdx,%r8,4),%edx
  8c2371:	41 89 95 64 01 00 00 	mov    %edx,0x164(%r13)
  8c2378:	48 8b 51 48          	mov    0x48(%rcx),%rdx
  8c237c:	c5 f8 77             	vzeroupper
  8c237f:	e8 6c 9a 00 00       	call   8cbdf0 <check_lower_address>
  8c2384:	e9 fc 37 00 00       	jmp    8c5b85 <check_lower_drain+0x3be5>
  8c2389:	31 ed                	xor    %ebp,%ebp
  8c238b:	49 be 00 00 00 00 00 	movabs $0x10000000000,%r14
  8c2392:	01 00 00 
  8c2395:	4c 85 f6             	test   %r14,%rsi
  8c2398:	75 97                	jne    8c2331 <check_lower_drain+0x391>
  8c239a:	49 ba 00 00 00 00 00 	movabs $0x10000000000,%r10
  8c23a1:	01 00 00 
  8c23a4:	4c 85 d6             	test   %r10,%rsi
  8c23a7:	0f 85 40 03 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c23ad:	44 8b 31             	mov    (%rcx),%r14d
  8c23b0:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  8c23b6:	41 c1 ee 03          	shr    $0x3,%r14d
  8c23ba:	45 3b b5 b0 01 00 00 	cmp    0x1b0(%r13),%r14d
  8c23c1:	73 04                	jae    8c23c7 <check_lower_drain+0x427>
  8c23c3:	46 8b 14 b3          	mov    (%rbx,%r14,4),%r10d
  8c23c7:	48 85 c0             	test   %rax,%rax
  8c23ca:	74 0d                	je     8c23d9 <check_lower_drain+0x439>
  8c23cc:	41 3b 81 c0 00 00 00 	cmp    0xc0(%r9),%eax
  8c23d3:	40 0f 92 c5          	setb   %bpl
  8c23d7:	eb 02                	jmp    8c23db <check_lower_drain+0x43b>
  8c23d9:	31 ed                	xor    %ebp,%ebp
  8c23db:	45 0f b6 f2          	movzbl %r10b,%r14d
  8c23df:	41 8d 5e ff          	lea    -0x1(%r14),%ebx
  8c23e3:	83 fb 0a             	cmp    $0xa,%ebx
  8c23e6:	41 0f 93 c4          	setae  %r12b
  8c23ea:	41 f7 c2 00 05 00 00 	test   $0x500,%r10d
  8c23f1:	41 0f 95 c5          	setne  %r13b
  8c23f5:	45 08 e5             	or     %r12b,%r13b
  8c23f8:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c23fd:	0f 85 ea 02 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c2403:	83 79 44 00          	cmpl   $0x0,0x44(%rcx)
  8c2407:	0f 85 e0 02 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c240d:	45 85 db             	test   %r11d,%r11d
  8c2410:	49 bd 00 00 00 00 00 	movabs $0x20000000000,%r13
  8c2417:	02 00 00 
  8c241a:	41 0f 94 c4          	sete   %r12b
  8c241e:	4c 85 ee             	test   %r13,%rsi
  8c2421:	41 0f 94 c5          	sete   %r13b
  8c2425:	41 20 ed             	and    %bpl,%r13b
  8c2428:	45 20 e5             	and    %r12b,%r13b
  8c242b:	41 80 fd 01          	cmp    $0x1,%r13b
  8c242f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c2434:	75 30                	jne    8c2466 <check_lower_drain+0x4c6>
  8c2436:	4c 8b af 90 02 00 00 	mov    0x290(%rdi),%r13
  8c243d:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8c2441:	43 80 7c 25 00 00    	cmpb   $0x0,0x0(%r13,%r12,1)
  8c2447:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c244c:	74 18                	je     8c2466 <check_lower_drain+0x4c6>
  8c244e:	4c 8b af 78 02 00 00 	mov    0x278(%rdi),%r13
  8c2455:	43 80 7c 25 00 00    	cmpb   $0x0,0x0(%r13,%r12,1)
  8c245b:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c2460:	0f 84 87 02 00 00    	je     8c26ed <check_lower_drain+0x74d>
  8c2466:	44 8b 61 0c          	mov    0xc(%rcx),%r12d
  8c246a:	45 85 e4             	test   %r12d,%r12d
  8c246d:	74 23                	je     8c2492 <check_lower_drain+0x4f2>
  8c246f:	83 79 54 00          	cmpl   $0x0,0x54(%rcx)
  8c2473:	75 1d                	jne    8c2492 <check_lower_drain+0x4f2>
  8c2475:	44 0f b7 69 08       	movzwl 0x8(%rcx),%r13d
  8c247a:	41 f7 c5 10 08 00 00 	test   $0x810,%r13d
  8c2481:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c2486:	75 0a                	jne    8c2492 <check_lower_drain+0x4f2>
  8c2488:	83 79 04 00          	cmpl   $0x0,0x4(%rcx)
  8c248c:	0f 84 3a 02 00 00    	je     8c26cc <check_lower_drain+0x72c>
  8c2492:	45 85 db             	test   %r11d,%r11d
  8c2495:	0f 85 52 02 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c249b:	83 79 04 01          	cmpl   $0x1,0x4(%rcx)
  8c249f:	0f 94 c1             	sete   %cl
  8c24a2:	40 20 e9             	and    %bpl,%cl
  8c24a5:	80 f9 01             	cmp    $0x1,%cl
  8c24a8:	0f 85 3f 02 00 00    	jne    8c26ed <check_lower_drain+0x74d>
  8c24ae:	49 8b 4d 68          	mov    0x68(%r13),%rcx
  8c24b2:	4d 8b 89 80 00 00 00 	mov    0x80(%r9),%r9
  8c24b9:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  8c24bc:	41 8b 04 81          	mov    (%r9,%rax,4),%eax
  8c24c0:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8c24c3:	41 0f 94 c3          	sete   %r11b
  8c24c7:	45 00 db             	add    %r11b,%r11b
  8c24ca:	41 80 c3 02          	add    $0x2,%r11b
  8c24ce:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8c24d1:	0f 44 c8             	cmove  %eax,%ecx
  8c24d4:	75 08                	jne    8c24de <check_lower_drain+0x53e>
  8c24d6:	85 c0                	test   %eax,%eax
  8c24d8:	0f 84 0f 02 00 00    	je     8c26ed <check_lower_drain+0x74d>
  8c24de:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c24e2:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
  8c24e6:	41 89 85 64 01 00 00 	mov    %eax,0x164(%r13)
  8c24ed:	41 80 fa 0f          	cmp    $0xf,%r10b
  8c24f1:	0f 82 88 01 00 00    	jb     8c267f <check_lower_drain+0x6df>
  8c24f7:	41 83 bf f0 00 00 00 	cmpl   $0x0,0xf0(%r15)
  8c24fe:	00 
  8c24ff:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
  8c2504:	0f 85 80 36 00 00    	jne    8c5b8a <check_lower_drain+0x3bea>
  8c250a:	48 8d 05 a1 72 dc ff 	lea    -0x238d5f(%rip),%rax        # 6897b2 <fuzz_comment_end+0x26cbc>
  8c2511:	49 89 87 00 01 00 00 	mov    %rax,0x100(%r15)
  8c2518:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c251c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2523:	0f 85 61 36 00 00    	jne    8c5b8a <check_lower_drain+0x3bea>
  8c2529:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c2530:	00 00 00 
  8c2533:	e9 66 15 00 00       	jmp    8c3a9e <check_lower_drain+0x1afe>
  8c2538:	41 0f b6 c0          	movzbl %r8b,%eax
  8c253c:	83 c0 fe             	add    $0xfffffffe,%eax
  8c253f:	83 f8 04             	cmp    $0x4,%eax
  8c2542:	0f 87 f3 00 00 00    	ja     8c263b <check_lower_drain+0x69b>
  8c2548:	48 8d 0d 3d 4e be ff 	lea    -0x41b1c3(%rip),%rcx        # 4a738c <cbuiltin_test_generated.edges+0xacfc>
  8c254f:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  8c2553:	48 01 c8             	add    %rcx,%rax
  8c2556:	ff e0                	jmp    *%rax
  8c2558:	41 8b 85 b0 01 00 00 	mov    0x1b0(%r13),%eax
  8c255f:	89 f1                	mov    %esi,%ecx
  8c2561:	c1 e9 03             	shr    $0x3,%ecx
  8c2564:	39 c1                	cmp    %eax,%ecx
  8c2566:	73 11                	jae    8c2579 <check_lower_drain+0x5d9>
  8c2568:	49 8b bd a0 01 00 00 	mov    0x1a0(%r13),%rdi
  8c256f:	f6 04 0f 02          	testb  $0x2,(%rdi,%rcx,1)
  8c2573:	0f 85 7d 18 00 00    	jne    8c3df6 <check_lower_drain+0x1e56>
  8c2579:	44 89 f2             	mov    %r14d,%edx
  8c257c:	c1 ea 03             	shr    $0x3,%edx
  8c257f:	39 c2                	cmp    %eax,%edx
  8c2581:	73 11                	jae    8c2594 <check_lower_drain+0x5f4>
  8c2583:	49 8b bd a0 01 00 00 	mov    0x1a0(%r13),%rdi
  8c258a:	f6 04 17 02          	testb  $0x2,(%rdi,%rdx,1)
  8c258e:	0f 85 68 18 00 00    	jne    8c3dfc <check_lower_drain+0x1e5c>
  8c2594:	b3 ff                	mov    $0xff,%bl
  8c2596:	41 b4 ff             	mov    $0xff,%r12b
  8c2599:	39 c1                	cmp    %eax,%ecx
  8c259b:	73 1c                	jae    8c25b9 <check_lower_drain+0x619>
  8c259d:	49 8b 95 a0 01 00 00 	mov    0x1a0(%r13),%rdx
  8c25a4:	41 b4 08             	mov    $0x8,%r12b
  8c25a7:	f6 04 0a 01          	testb  $0x1,(%rdx,%rcx,1)
  8c25ab:	75 0c                	jne    8c25b9 <check_lower_drain+0x619>
  8c25ad:	49 8b 95 98 01 00 00 	mov    0x198(%r13),%rdx
  8c25b4:	44 0f b6 24 0a       	movzbl (%rdx,%rcx,1),%r12d
  8c25b9:	44 89 f2             	mov    %r14d,%edx
  8c25bc:	c1 ea 03             	shr    $0x3,%edx
  8c25bf:	39 c2                	cmp    %eax,%edx
  8c25c1:	73 1a                	jae    8c25dd <check_lower_drain+0x63d>
  8c25c3:	49 8b bd a0 01 00 00 	mov    0x1a0(%r13),%rdi
  8c25ca:	b3 08                	mov    $0x8,%bl
  8c25cc:	f6 04 17 01          	testb  $0x1,(%rdi,%rdx,1)
  8c25d0:	75 0b                	jne    8c25dd <check_lower_drain+0x63d>
  8c25d2:	49 8b bd 98 01 00 00 	mov    0x198(%r13),%rdi
  8c25d9:	0f b6 1c 17          	movzbl (%rdi,%rdx,1),%ebx
  8c25dd:	39 c1                	cmp    %eax,%ecx
  8c25df:	0f 83 e8 14 00 00    	jae    8c3acd <check_lower_drain+0x1b2d>
  8c25e5:	49 8b bd a0 01 00 00 	mov    0x1a0(%r13),%rdi
  8c25ec:	0f b6 0c 0f          	movzbl (%rdi,%rcx,1),%ecx
  8c25f0:	e9 da 14 00 00       	jmp    8c3acf <check_lower_drain+0x1b2f>
  8c25f5:	4c 89 ef             	mov    %r13,%rdi
  8c25f8:	44 89 f2             	mov    %r14d,%edx
  8c25fb:	c5 f8 77             	vzeroupper
  8c25fe:	e8 6d a3 00 00       	call   8cc970 <check_lower_miscellaneous_emit>
  8c2603:	e9 f8 f9 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c2608:	4c 89 ef             	mov    %r13,%rdi
  8c260b:	c5 f8 77             	vzeroupper
  8c260e:	e8 4d c2 ff ff       	call   8be860 <check_lower_control>
  8c2613:	e9 e8 f9 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c2618:	4c 89 ef             	mov    %r13,%rdi
  8c261b:	44 89 f2             	mov    %r14d,%edx
  8c261e:	c5 f8 77             	vzeroupper
  8c2621:	e8 4a a2 00 00       	call   8cc870 <check_lower_builtin_emit>
  8c2626:	e9 d5 f9 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c262b:	4c 89 ef             	mov    %r13,%rdi
  8c262e:	c5 f8 77             	vzeroupper
  8c2631:	e8 3a 39 00 00       	call   8c5f70 <check_lower_place>
  8c2636:	e9 c5 f9 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c263b:	83 ff 08             	cmp    $0x8,%edi
  8c263e:	0f 87 89 12 00 00    	ja     8c38cd <check_lower_drain+0x192d>
  8c2644:	89 f0                	mov    %esi,%eax
  8c2646:	48 c1 e0 05          	shl    $0x5,%rax
  8c264a:	49 03 85 30 01 00 00 	add    0x130(%r13),%rax
  8c2651:	83 ff 08             	cmp    $0x8,%edi
  8c2654:	0f 85 5d 14 00 00    	jne    8c3ab7 <check_lower_drain+0x1b17>
  8c265a:	8b 08                	mov    (%rax),%ecx
  8c265c:	ba b3 fe ff ff       	mov    $0xfffffeb3,%edx
  8c2661:	01 d1                	add    %edx,%ecx
  8c2663:	83 f9 01             	cmp    $0x1,%ecx
  8c2666:	0f 87 4b 14 00 00    	ja     8c3ab7 <check_lower_drain+0x1b17>
  8c266c:	4c 89 ef             	mov    %r13,%rdi
  8c266f:	44 89 f2             	mov    %r14d,%edx
  8c2672:	c5 f8 77             	vzeroupper
  8c2675:	e8 46 8c 01 00       	call   8db2c0 <check_lower_floating_strict>
  8c267a:	e9 81 f9 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c267f:	41 8b 85 38 01 00 00 	mov    0x138(%r13),%eax
  8c2686:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
  8c268b:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  8c2690:	0f 87 ef 13 00 00    	ja     8c3a85 <check_lower_drain+0x1ae5>
  8c2696:	41 3b 85 40 01 00 00 	cmp    0x140(%r13),%eax
  8c269d:	0f 83 e2 13 00 00    	jae    8c3a85 <check_lower_drain+0x1ae5>
  8c26a3:	41 80 bd f9 01 00 00 	cmpb   $0x1,0x1f9(%r13)
  8c26aa:	01 
  8c26ab:	0f 85 27 18 00 00    	jne    8c3ed8 <check_lower_drain+0x1f38>
  8c26b1:	41 0f b6 f3          	movzbl %r11b,%esi
  8c26b5:	41 0f b6 d2          	movzbl %r10b,%edx
  8c26b9:	4c 89 ef             	mov    %r13,%rdi
  8c26bc:	c5 f8 77             	vzeroupper
  8c26bf:	e8 1c c2 01 00       	call   8de8e0 <check_lower_emit_tracked>
  8c26c4:	48 ff c5             	inc    %rbp
  8c26c7:	e9 34 f9 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c26cc:	41 83 fb 3e          	cmp    $0x3e,%r11d
  8c26d0:	0f 87 12 1b 00 00    	ja     8c41e8 <check_lower_drain+0x2248>
  8c26d6:	49 b9 00 00 00 00 08 	movabs $0x4080000800000000,%r9
  8c26dd:	00 80 40 
  8c26e0:	44 89 d8             	mov    %r11d,%eax
  8c26e3:	49 0f a3 c1          	bt     %rax,%r9
  8c26e7:	0f 83 fb 1a 00 00    	jae    8c41e8 <check_lower_drain+0x2248>
  8c26ed:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  8c26f1:	89 f0                	mov    %esi,%eax
  8c26f3:	49 bb 05 00 80 00 18 	movabs $0x8001800800005,%r11
  8c26fa:	00 08 00 
  8c26fd:	4c 8b 07             	mov    (%rdi),%r8
  8c2700:	49 8b 08             	mov    (%r8),%rcx
  8c2703:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  8c2706:	44 8d 49 ff          	lea    -0x1(%rcx),%r9d
  8c270a:	41 83 f9 34          	cmp    $0x34,%r9d
  8c270e:	c4 42 b3 f7 db       	shrx   %r9,%r11,%r11
  8c2713:	41 0f 92 c2          	setb   %r10b
  8c2717:	45 20 d3             	and    %r10b,%r11b
  8c271a:	41 80 fb 01          	cmp    $0x1,%r11b
  8c271e:	75 1c                	jne    8c273c <check_lower_drain+0x79c>
  8c2720:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  8c2724:	4c 8d 14 40          	lea    (%rax,%rax,2),%r10
  8c2728:	49 c1 e2 05          	shl    $0x5,%r10
  8c272c:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
  8c2730:	43 83 7c 13 0c 00    	cmpl   $0x0,0xc(%r11,%r10,1)
  8c2736:	0f 84 43 05 00 00    	je     8c2c7f <check_lower_drain+0xcdf>
  8c273c:	41 80 bd f9 01 00 00 	cmpb   $0x0,0x1f9(%r13)
  8c2743:	00 
  8c2744:	0f 85 f6 00 00 00    	jne    8c2840 <check_lower_drain+0x8a0>
  8c274a:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c274f:	48 bf 00 00 00 00 00 	movabs $0x50000000000,%rdi
  8c2756:	05 00 00 
  8c2759:	48 8b a8 a8 01 00 00 	mov    0x1a8(%rax),%rbp
  8c2760:	48 85 ed             	test   %rbp,%rbp
  8c2763:	0f 94 c1             	sete   %cl
  8c2766:	48 85 fe             	test   %rdi,%rsi
  8c2769:	40 0f 95 c7          	setne  %dil
  8c276d:	40 08 cf             	or     %cl,%dil
  8c2770:	0f 85 ca 00 00 00    	jne    8c2840 <check_lower_drain+0x8a0>
  8c2776:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c277b:	41 89 f1             	mov    %esi,%r9d
  8c277e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8c2783:	45 31 e4             	xor    %r12d,%r12d
  8c2786:	4c 8b 19             	mov    (%rcx),%r11
  8c2789:	4d 8b 3b             	mov    (%r11),%r15
  8c278c:	4d 8b 07             	mov    (%r15),%r8
  8c278f:	47 8b 14 88          	mov    (%r8,%r9,4),%r10d
  8c2793:	49 83 fa 3f          	cmp    $0x3f,%r10
  8c2797:	77 0c                	ja     8c27a5 <check_lower_drain+0x805>
  8c2799:	48 8d 0d 20 d1 bf ff 	lea    -0x402ee0(%rip),%rcx        # 4bf8c0 <check_lower_batch_ops>
  8c27a0:	41 0f b6 1c 0a       	movzbl (%r10,%rcx,1),%ebx
  8c27a5:	49 8b 7f 10          	mov    0x10(%r15),%rdi
  8c27a9:	45 8d 72 fb          	lea    -0x5(%r10),%r14d
  8c27ad:	41 83 fe 10          	cmp    $0x10,%r14d
  8c27b1:	44 89 74 24 48       	mov    %r14d,0x48(%rsp)
  8c27b6:	41 0f 92 c5          	setb   %r13b
  8c27ba:	31 c9                	xor    %ecx,%ecx
  8c27bc:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8c27c2:	0f 95 44 24 58       	setne  0x58(%rsp)
  8c27c7:	42 8b 04 8f          	mov    (%rdi,%r9,4),%eax
  8c27cb:	48 89 c7             	mov    %rax,%rdi
  8c27ce:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8c27d3:	41 83 fe 0f          	cmp    $0xf,%r14d
  8c27d7:	77 0b                	ja     8c27e4 <check_lower_drain+0x844>
  8c27d9:	49 8b 7f 18          	mov    0x18(%r15),%rdi
  8c27dd:	42 8b 3c 8f          	mov    (%rdi,%r9,4),%edi
  8c27e1:	41 89 fc             	mov    %edi,%r12d
  8c27e4:	89 bc 24 80 00 00 00 	mov    %edi,0x80(%rsp)
  8c27eb:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c27f0:	4c 89 64 24 50       	mov    %r12,0x50(%rsp)
  8c27f5:	44 8b a7 40 01 00 00 	mov    0x140(%rdi),%r12d
  8c27fc:	bf 00 00 00 01       	mov    $0x1000000,%edi
  8c2801:	41 81 fc 00 00 00 01 	cmp    $0x1000000,%r12d
  8c2808:	41 0f 42 fc          	cmovb  %r12d,%edi
  8c280c:	85 db                	test   %ebx,%ebx
  8c280e:	74 30                	je     8c2840 <check_lower_drain+0x8a0>
  8c2810:	81 fb fe 00 00 00    	cmp    $0xfe,%ebx
  8c2816:	74 28                	je     8c2840 <check_lower_drain+0x8a0>
  8c2818:	4d 8b 5b 08          	mov    0x8(%r11),%r11
  8c281c:	48 89 e8             	mov    %rbp,%rax
  8c281f:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  8c2823:	48 c1 e3 05          	shl    $0x5,%rbx
  8c2827:	49 8b 6b 08          	mov    0x8(%r11),%rbp
  8c282b:	48 01 eb             	add    %rbp,%rbx
  8c282e:	83 7b 44 00          	cmpl   $0x0,0x44(%rbx)
  8c2832:	0f 84 52 07 00 00    	je     8c2f8a <check_lower_drain+0xfea>
  8c2838:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8c283f:	00 
  8c2840:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
  8c2845:	41 89 f7             	mov    %esi,%r15d
  8c2848:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  8c284c:	48 c1 e1 05          	shl    $0x5,%rcx
  8c2850:	49 8b 28             	mov    (%r8),%rbp
  8c2853:	41 8b 90 b0 01 00 00 	mov    0x1b0(%r8),%edx
  8c285a:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  8c285e:	89 54 24 50          	mov    %edx,0x50(%rsp)
  8c2862:	4d 8b 74 24 08       	mov    0x8(%r12),%r14
  8c2867:	41 8b 04 0e          	mov    (%r14,%rcx,1),%eax
  8c286b:	c1 e8 03             	shr    $0x3,%eax
  8c286e:	39 d0                	cmp    %edx,%eax
  8c2870:	73 28                	jae    8c289a <check_lower_drain+0x8fa>
  8c2872:	49 8b 90 a0 01 00 00 	mov    0x1a0(%r8),%rdx
  8c2879:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx
  8c287d:	89 d7                	mov    %edx,%edi
  8c287f:	40 80 e7 04          	and    $0x4,%dil
  8c2883:	40 c0 ef 02          	shr    $0x2,%dil
  8c2887:	89 7c 24 48          	mov    %edi,0x48(%rsp)
  8c288b:	f6 c2 01             	test   $0x1,%dl
  8c288e:	74 16                	je     8c28a6 <check_lower_drain+0x906>
  8c2890:	b2 01                	mov    $0x1,%dl
  8c2892:	b0 08                	mov    $0x8,%al
  8c2894:	89 54 24 78          	mov    %edx,0x78(%rsp)
  8c2898:	eb 1f                	jmp    8c28b9 <check_lower_drain+0x919>
  8c289a:	b0 ff                	mov    $0xff,%al
  8c289c:	c7 44 24 48 00 00 00 	movl   $0x0,0x48(%rsp)
  8c28a3:	00 
  8c28a4:	eb 0b                	jmp    8c28b1 <check_lower_drain+0x911>
  8c28a6:	49 8b 90 98 01 00 00 	mov    0x198(%r8),%rdx
  8c28ad:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8c28b1:	c7 44 24 78 00 00 00 	movl   $0x0,0x78(%rsp)
  8c28b8:	00 
  8c28b9:	48 8b 5d 00          	mov    0x0(%rbp),%rbx
  8c28bd:	49 01 ce             	add    %rcx,%r14
  8c28c0:	4c 8b 6d 10          	mov    0x10(%rbp),%r13
  8c28c4:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c28c8:	48 8b 13             	mov    (%rbx),%rdx
  8c28cb:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
  8c28cf:	42 8b 0c b9          	mov    (%rcx,%r15,4),%ecx
  8c28d3:	46 8b 1c ba          	mov    (%rdx,%r15,4),%r11d
  8c28d7:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  8c28dc:	46 8b 14 bf          	mov    (%rdi,%r15,4),%r10d
  8c28e0:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  8c28e7:	00 
  8c28e8:	4c 89 f9             	mov    %r15,%rcx
  8c28eb:	48 c1 e1 05          	shl    $0x5,%rcx
  8c28ef:	8b 3c 0a             	mov    (%rdx,%rcx,1),%edi
  8c28f2:	44 8b 4c 0a 08       	mov    0x8(%rdx,%rcx,1),%r9d
  8c28f7:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c28fb:	42 8b 0c b9          	mov    (%rcx,%r15,4),%ecx
  8c28ff:	48 89 7c 24 58       	mov    %rdi,0x58(%rsp)
  8c2904:	41 89 88 64 01 00 00 	mov    %ecx,0x164(%r8)
  8c290b:	41 8b 4e 0c          	mov    0xc(%r14),%ecx
  8c290f:	85 c9                	test   %ecx,%ecx
  8c2911:	74 07                	je     8c291a <check_lower_drain+0x97a>
  8c2913:	41 83 7e 54 00       	cmpl   $0x0,0x54(%r14)
  8c2918:	74 04                	je     8c291e <check_lower_drain+0x97e>
  8c291a:	31 d2                	xor    %edx,%edx
  8c291c:	eb 0b                	jmp    8c2929 <check_lower_drain+0x989>
  8c291e:	41 f7 46 08 10 08 00 	testl  $0x810,0x8(%r14)
  8c2925:	00 
  8c2926:	0f 94 c2             	sete   %dl
  8c2929:	48 bf 00 00 00 00 00 	movabs $0x10000000000,%rdi
  8c2930:	01 00 00 
  8c2933:	49 89 f0             	mov    %rsi,%r8
  8c2936:	49 21 f8             	and    %rdi,%r8
  8c2939:	48 bf 00 00 00 00 00 	movabs $0x20000000000,%rdi
  8c2940:	02 00 00 
  8c2943:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  8c2948:	48 85 fe             	test   %rdi,%rsi
  8c294b:	0f 85 f1 00 00 00    	jne    8c2a42 <check_lower_drain+0xaa2>
  8c2951:	45 85 db             	test   %r11d,%r11d
  8c2954:	0f 85 e8 00 00 00    	jne    8c2a42 <check_lower_drain+0xaa2>
  8c295a:	41 8b 7e 40          	mov    0x40(%r14),%edi
  8c295e:	85 ff                	test   %edi,%edi
  8c2960:	0f 84 0a 01 00 00    	je     8c2a70 <check_lower_drain+0xad0>
  8c2966:	3b bd c0 00 00 00    	cmp    0xc0(%rbp),%edi
  8c296c:	0f 83 fe 00 00 00    	jae    8c2a70 <check_lower_drain+0xad0>
  8c2972:	4c 8b 45 00          	mov    0x0(%rbp),%r8
  8c2976:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c297b:	4c 89 ee             	mov    %r13,%rsi
  8c297e:	4d 89 f5             	mov    %r14,%r13
  8c2981:	4d 89 e6             	mov    %r12,%r14
  8c2984:	49 89 ec             	mov    %rbp,%r12
  8c2987:	4c 89 d5             	mov    %r10,%rbp
  8c298a:	49 89 c2             	mov    %rax,%r10
  8c298d:	4c 89 c8             	mov    %r9,%rax
  8c2990:	ff cf                	dec    %edi
  8c2992:	4d 8b 88 90 02 00 00 	mov    0x290(%r8),%r9
  8c2999:	41 80 3c 39 00       	cmpb   $0x0,(%r9,%rdi,1)
  8c299e:	49 89 c1             	mov    %rax,%r9
  8c29a1:	4c 89 d0             	mov    %r10,%rax
  8c29a4:	49 89 ea             	mov    %rbp,%r10
  8c29a7:	4c 89 e5             	mov    %r12,%rbp
  8c29aa:	4d 89 f4             	mov    %r14,%r12
  8c29ad:	4d 89 ee             	mov    %r13,%r14
  8c29b0:	49 89 f5             	mov    %rsi,%r13
  8c29b3:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c29b8:	0f 84 b2 00 00 00    	je     8c2a70 <check_lower_drain+0xad0>
  8c29be:	4d 8b 80 78 02 00 00 	mov    0x278(%r8),%r8
  8c29c5:	41 80 3c 38 00       	cmpb   $0x0,(%r8,%rdi,1)
  8c29ca:	0f 85 a0 00 00 00    	jne    8c2a70 <check_lower_drain+0xad0>
  8c29d0:	48 8b 45 28          	mov    0x28(%rbp),%rax
  8c29d4:	48 85 c0             	test   %rax,%rax
  8c29d7:	0f 84 72 31 00 00    	je     8c5b4f <check_lower_drain+0x3baf>
  8c29dd:	48 8b 40 10          	mov    0x10(%rax),%rax
  8c29e1:	8b 14 b8             	mov    (%rax,%rdi,4),%edx
  8c29e4:	85 d2                	test   %edx,%edx
  8c29e6:	0f 84 63 31 00 00    	je     8c5b4f <check_lower_drain+0x3baf>
  8c29ec:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c29f1:	8b 87 3c 01 00 00    	mov    0x13c(%rdi),%eax
  8c29f7:	3b 87 40 01 00 00    	cmp    0x140(%rdi),%eax
  8c29fd:	0f 83 1e 08 00 00    	jae    8c3221 <check_lower_drain+0x1281>
  8c2a03:	48 8b 4f 18          	mov    0x18(%rdi),%rcx
  8c2a07:	44 8d 40 01          	lea    0x1(%rax),%r8d
  8c2a0b:	48 c1 e0 04          	shl    $0x4,%rax
  8c2a0f:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c2a16:	49 b8 ff ff ff ff 00 	movabs $0x500ffffffff,%r8
  8c2a1d:	05 00 00 
  8c2a20:	4c 21 c6             	and    %r8,%rsi
  8c2a23:	49 b8 00 00 00 00 00 	movabs $0x20000000000,%r8
  8c2a2a:	02 00 00 
  8c2a2d:	4c 09 c6             	or     %r8,%rsi
  8c2a30:	48 89 34 01          	mov    %rsi,(%rcx,%rax,1)
  8c2a34:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c2a3b:	00 00 
  8c2a3d:	e9 06 08 00 00       	jmp    8c3248 <check_lower_drain+0x12a8>
  8c2a42:	41 83 fb 37          	cmp    $0x37,%r11d
  8c2a46:	75 28                	jne    8c2a70 <check_lower_drain+0xad0>
  8c2a48:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c2a4d:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2a52:	48 c1 e8 28          	shr    $0x28,%rax
  8c2a56:	0f b6 d0             	movzbl %al,%edx
  8c2a59:	c5 f8 77             	vzeroupper
  8c2a5c:	e8 9f d5 00 00       	call   8d0000 <check_lower_region>
  8c2a61:	e9 1a 31 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2a66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8c2a6d:	00 00 00 
  8c2a70:	84 d2                	test   %dl,%dl
  8c2a72:	74 66                	je     8c2ada <check_lower_drain+0xb3a>
  8c2a74:	41 83 fb 23          	cmp    $0x23,%r11d
  8c2a78:	0f 84 aa 00 00 00    	je     8c2b28 <check_lower_drain+0xb88>
  8c2a7e:	41 83 fb 3e          	cmp    $0x3e,%r11d
  8c2a82:	0f 84 a0 00 00 00    	je     8c2b28 <check_lower_drain+0xb88>
  8c2a88:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c2a8e:	75 07                	jne    8c2a97 <check_lower_drain+0xaf7>
  8c2a90:	41 83 7e 04 00       	cmpl   $0x0,0x4(%r14)
  8c2a95:	74 1b                	je     8c2ab2 <check_lower_drain+0xb12>
  8c2a97:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c2a9d:	8b 7c 24 48          	mov    0x48(%rsp),%edi
  8c2aa1:	0f 94 c2             	sete   %dl
  8c2aa4:	40 80 f7 01          	xor    $0x1,%dil
  8c2aa8:	40 84 fa             	test   %dil,%dl
  8c2aab:	75 2d                	jne    8c2ada <check_lower_drain+0xb3a>
  8c2aad:	83 f9 03             	cmp    $0x3,%ecx
  8c2ab0:	75 28                	jne    8c2ada <check_lower_drain+0xb3a>
  8c2ab2:	48 b8 00 00 00 00 00 	movabs $0x40000000000,%rax
  8c2ab9:	04 00 00 
  8c2abc:	48 85 c6             	test   %rax,%rsi
  8c2abf:	0f 85 bb 30 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c2ac5:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2aca:	4c 89 f6             	mov    %r14,%rsi
  8c2acd:	c5 f8 77             	vzeroupper
  8c2ad0:	e8 cb 85 00 00       	call   8cb0a0 <check_lower_constant>
  8c2ad5:	e9 a6 30 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2ada:	41 83 fb 34          	cmp    $0x34,%r11d
  8c2ade:	0f 84 9a 00 00 00    	je     8c2b7e <check_lower_drain+0xbde>
  8c2ae4:	45 85 db             	test   %r11d,%r11d
  8c2ae7:	75 3f                	jne    8c2b28 <check_lower_drain+0xb88>
  8c2ae9:	41 83 3e 08          	cmpl   $0x8,(%r14)
  8c2aed:	0f 84 8d 30 00 00    	je     8c5b80 <check_lower_drain+0x3be0>
  8c2af3:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c2af9:	8b 4c 24 48          	mov    0x48(%rsp),%ecx
  8c2afd:	41 8b 76 40          	mov    0x40(%r14),%esi
  8c2b01:	49 89 c7             	mov    %rax,%r15
  8c2b04:	0f 94 c0             	sete   %al
  8c2b07:	80 f1 01             	xor    $0x1,%cl
  8c2b0a:	84 c8                	test   %cl,%al
  8c2b0c:	0f 85 10 03 00 00    	jne    8c2e22 <check_lower_drain+0xe82>
  8c2b12:	49 8b 56 48          	mov    0x48(%r14),%rdx
  8c2b16:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2b1b:	c5 f8 77             	vzeroupper
  8c2b1e:	e8 cd 92 00 00       	call   8cbdf0 <check_lower_address>
  8c2b23:	e9 58 30 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2b28:	44 89 d9             	mov    %r11d,%ecx
  8c2b2b:	83 e1 fe             	and    $0xfffffffe,%ecx
  8c2b2e:	83 f9 40             	cmp    $0x40,%ecx
  8c2b31:	75 6d                	jne    8c2ba0 <check_lower_drain+0xc00>
  8c2b33:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
  8c2b38:	4c 89 d1             	mov    %r10,%rcx
  8c2b3b:	49 89 c2             	mov    %rax,%r10
  8c2b3e:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
  8c2b42:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  8c2b46:	48 c1 e0 05          	shl    $0x5,%rax
  8c2b4a:	8b 0c 02             	mov    (%rdx,%rax,1),%ecx
  8c2b4d:	c1 e9 03             	shr    $0x3,%ecx
  8c2b50:	80 3c 0f 0f          	cmpb   $0xf,(%rdi,%rcx,1)
  8c2b54:	49 89 c8             	mov    %rcx,%r8
  8c2b57:	75 0c                	jne    8c2b65 <check_lower_drain+0xbc5>
  8c2b59:	4d 8b 45 20          	mov    0x20(%r13),%r8
  8c2b5d:	45 8b 04 88          	mov    (%r8,%rcx,4),%r8d
  8c2b61:	41 c1 e8 03          	shr    $0x3,%r8d
  8c2b65:	42 0f b6 3c 07       	movzbl (%rdi,%r8,1),%edi
  8c2b6a:	40 80 ff 06          	cmp    $0x6,%dil
  8c2b6e:	0f 84 67 01 00 00    	je     8c2cdb <check_lower_drain+0xd3b>
  8c2b74:	41 83 fb 40          	cmp    $0x40,%r11d
  8c2b78:	0f 85 5d 01 00 00    	jne    8c2cdb <check_lower_drain+0xd3b>
  8c2b7e:	31 c9                	xor    %ecx,%ecx
  8c2b80:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c2b86:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2b8b:	0f 95 c1             	setne  %cl
  8c2b8e:	31 d2                	xor    %edx,%edx
  8c2b90:	45 31 c0             	xor    %r8d,%r8d
  8c2b93:	c5 f8 77             	vzeroupper
  8c2b96:	e8 35 cf 00 00       	call   8cfad0 <check_lower_operand>
  8c2b9b:	e9 e0 2f 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2ba0:	41 8d 53 c7          	lea    -0x39(%r11),%edx
  8c2ba4:	83 fa 01             	cmp    $0x1,%edx
  8c2ba7:	0f 87 85 01 00 00    	ja     8c2d32 <check_lower_drain+0xd92>
  8c2bad:	48 8b 43 38          	mov    0x38(%rbx),%rax
  8c2bb1:	42 8b 1c b8          	mov    (%rax,%r15,4),%ebx
  8c2bb5:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  8c2bba:	85 db                	test   %ebx,%ebx
  8c2bbc:	0f 84 96 01 00 00    	je     8c2d58 <check_lower_drain+0xdb8>
  8c2bc2:	48 8b 45 00          	mov    0x0(%rbp),%rax
  8c2bc6:	3b 98 58 03 00 00    	cmp    0x358(%rax),%ebx
  8c2bcc:	0f 87 86 01 00 00    	ja     8c2d58 <check_lower_drain+0xdb8>
  8c2bd2:	48 8b 80 50 03 00 00 	mov    0x350(%rax),%rax
  8c2bd9:	49 8b 97 80 01 00 00 	mov    0x180(%r15),%rdx
  8c2be0:	ff cb                	dec    %ebx
  8c2be2:	48 8d 0c db          	lea    (%rbx,%rbx,8),%rcx
  8c2be6:	8b 44 88 14          	mov    0x14(%rax,%rcx,4),%eax
  8c2bea:	3b 42 04             	cmp    0x4(%rdx),%eax
  8c2bed:	0f 85 65 01 00 00    	jne    8c2d58 <check_lower_drain+0xdb8>
  8c2bf3:	49 8b 87 98 00 00 00 	mov    0x98(%r15),%rax
  8c2bfa:	83 3c 98 ff          	cmpl   $0xffffffff,(%rax,%rbx,4)
  8c2bfe:	75 26                	jne    8c2c26 <check_lower_drain+0xc86>
  8c2c00:	49 89 f6             	mov    %rsi,%r14
  8c2c03:	be 08 00 00 00       	mov    $0x8,%esi
  8c2c08:	4c 89 ff             	mov    %r15,%rdi
  8c2c0b:	4d 89 dc             	mov    %r11,%r12
  8c2c0e:	c5 f8 77             	vzeroupper
  8c2c11:	e8 0a b9 ff ff       	call   8be520 <check_lower_temporary>
  8c2c16:	49 8b 8f 98 00 00 00 	mov    0x98(%r15),%rcx
  8c2c1d:	4d 89 e3             	mov    %r12,%r11
  8c2c20:	4c 89 f6             	mov    %r14,%rsi
  8c2c23:	89 04 99             	mov    %eax,(%rcx,%rbx,4)
  8c2c26:	41 8b 87 3c 01 00 00 	mov    0x13c(%r15),%eax
  8c2c2d:	41 3b 87 40 01 00 00 	cmp    0x140(%r15),%eax
  8c2c34:	0f 83 b0 05 00 00    	jae    8c31ea <check_lower_drain+0x124a>
  8c2c3a:	4d 8b 8f 98 00 00 00 	mov    0x98(%r15),%r9
  8c2c41:	4d 8b 47 18          	mov    0x18(%r15),%r8
  8c2c45:	48 bf 01 00 00 00 01 	movabs $0x8000100000001,%rdi
  8c2c4c:	00 08 00 
  8c2c4f:	8d 48 01             	lea    0x1(%rax),%ecx
  8c2c52:	48 c1 e0 04          	shl    $0x4,%rax
  8c2c56:	41 83 fb 39          	cmp    $0x39,%r11d
  8c2c5a:	48 8d 57 01          	lea    0x1(%rdi),%rdx
  8c2c5e:	48 8d 7f 1d          	lea    0x1d(%rdi),%rdi
  8c2c62:	48 0f 44 d7          	cmove  %rdi,%rdx
  8c2c66:	45 8b 0c 99          	mov    (%r9,%rbx,4),%r9d
  8c2c6a:	41 89 8f 3c 01 00 00 	mov    %ecx,0x13c(%r15)
  8c2c71:	49 89 14 00          	mov    %rdx,(%r8,%rax,1)
  8c2c75:	4d 89 4c 00 08       	mov    %r9,0x8(%r8,%rax,1)
  8c2c7a:	e9 93 05 00 00       	jmp    8c3212 <check_lower_drain+0x1272>
  8c2c7f:	49 8b 50 08          	mov    0x8(%r8),%rdx
  8c2c83:	49 b8 01 00 80 00 08 	movabs $0x8000800800001,%r8
  8c2c8a:	00 08 00 
  8c2c8d:	4d 0f a3 c8          	bt     %r9,%r8
  8c2c91:	8b 14 82             	mov    (%rdx,%rax,4),%edx
  8c2c94:	41 89 95 64 01 00 00 	mov    %edx,0x164(%r13)
  8c2c9b:	0f 83 c0 00 00 00    	jae    8c2d61 <check_lower_drain+0xdc1>
  8c2ca1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c2ca8:	01 00 00 
  8c2cab:	48 85 c6             	test   %rax,%rsi
  8c2cae:	0f 95 c0             	setne  %al
  8c2cb1:	45 31 c0             	xor    %r8d,%r8d
  8c2cb4:	83 f9 34             	cmp    $0x34,%ecx
  8c2cb7:	0f 94 c1             	sete   %cl
  8c2cba:	74 08                	je     8c2cc4 <check_lower_drain+0xd24>
  8c2cbc:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8c2cc0:	46 8b 04 12          	mov    (%rdx,%r10,1),%r8d
  8c2cc4:	20 c8                	and    %cl,%al
  8c2cc6:	4c 89 ef             	mov    %r13,%rdi
  8c2cc9:	31 d2                	xor    %edx,%edx
  8c2ccb:	0f b6 c8             	movzbl %al,%ecx
  8c2cce:	c5 f8 77             	vzeroupper
  8c2cd1:	e8 fa cd 00 00       	call   8cfad0 <check_lower_operand>
  8c2cd6:	e9 aa 2e 00 00       	jmp    8c5b85 <check_lower_drain+0x3be5>
  8c2cdb:	40 80 ff 06          	cmp    $0x6,%dil
  8c2cdf:	0f 84 b6 00 00 00    	je     8c2d9b <check_lower_drain+0xdfb>
  8c2ce5:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2cea:	8b 87 3c 01 00 00    	mov    0x13c(%rdi),%eax
  8c2cf0:	3b 87 40 01 00 00    	cmp    0x140(%rdi),%eax
  8c2cf6:	0f 83 97 01 00 00    	jae    8c2e93 <check_lower_drain+0xef3>
  8c2cfc:	8d 50 01             	lea    0x1(%rax),%edx
  8c2cff:	48 8b 4f 18          	mov    0x18(%rdi),%rcx
  8c2d03:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  8c2d09:	48 c1 e0 04          	shl    $0x4,%rax
  8c2d0d:	89 97 3c 01 00 00    	mov    %edx,0x13c(%rdi)
  8c2d13:	41 0f b6 d2          	movzbl %r10b,%edx
  8c2d17:	48 c1 e2 30          	shl    $0x30,%rdx
  8c2d1b:	4a 8d 54 02 02       	lea    0x2(%rdx,%r8,1),%rdx
  8c2d20:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c2d24:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c2d2b:	00 00 
  8c2d2d:	e9 88 01 00 00       	jmp    8c2eba <check_lower_drain+0xf1a>
  8c2d32:	41 83 fb 3b          	cmp    $0x3b,%r11d
  8c2d36:	0f 85 c7 00 00 00    	jne    8c2e03 <check_lower_drain+0xe63>
  8c2d3c:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2d41:	41 b8 58 00 00 00    	mov    $0x58,%r8d
  8c2d47:	31 d2                	xor    %edx,%edx
  8c2d49:	31 c9                	xor    %ecx,%ecx
  8c2d4b:	c5 f8 77             	vzeroupper
  8c2d4e:	e8 7d cd 00 00       	call   8cfad0 <check_lower_operand>
  8c2d53:	e9 28 2e 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2d58:	49 8b 47 08          	mov    0x8(%r15),%rax
  8c2d5c:	e9 f7 2d 00 00       	jmp    8c5b58 <check_lower_drain+0x3bb8>
  8c2d61:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
  8c2d65:	31 d2                	xor    %edx,%edx
  8c2d67:	83 f9 03             	cmp    $0x3,%ecx
  8c2d6a:	49 89 f6             	mov    %rsi,%r14
  8c2d6d:	0f 94 c2             	sete   %dl
  8c2d70:	48 c1 e0 05          	shl    $0x5,%rax
  8c2d74:	8b 2c 07             	mov    (%rdi,%rax,1),%ebp
  8c2d77:	4c 89 ef             	mov    %r13,%rdi
  8c2d7a:	89 ee                	mov    %ebp,%esi
  8c2d7c:	c5 f8 77             	vzeroupper
  8c2d7f:	e8 9c cf 00 00       	call   8cfd20 <check_lower_truth>
  8c2d84:	4c 89 ef             	mov    %r13,%rdi
  8c2d87:	44 89 f6             	mov    %r14d,%esi
  8c2d8a:	31 d2                	xor    %edx,%edx
  8c2d8c:	31 c9                	xor    %ecx,%ecx
  8c2d8e:	41 89 e8             	mov    %ebp,%r8d
  8c2d91:	e8 3a cd 00 00       	call   8cfad0 <check_lower_operand>
  8c2d96:	e9 ea 2d 00 00       	jmp    8c5b85 <check_lower_drain+0x3be5>
  8c2d9b:	48 01 c2             	add    %rax,%rdx
  8c2d9e:	83 7a 04 01          	cmpl   $0x1,0x4(%rdx)
  8c2da2:	0f 85 29 01 00 00    	jne    8c2ed1 <check_lower_drain+0xf31>
  8c2da8:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c2dae:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2db3:	0f 85 29 03 00 00    	jne    8c30e2 <check_lower_drain+0x1142>
  8c2db9:	8b 97 3c 01 00 00    	mov    0x13c(%rdi),%edx
  8c2dbf:	3b 97 40 01 00 00    	cmp    0x140(%rdi),%edx
  8c2dc5:	0f 83 ef 02 00 00    	jae    8c30ba <check_lower_drain+0x111a>
  8c2dcb:	44 8d 42 01          	lea    0x1(%rdx),%r8d
  8c2dcf:	4c 8b 4f 18          	mov    0x18(%rdi),%r9
  8c2dd3:	48 c1 e2 04          	shl    $0x4,%rdx
  8c2dd7:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c2dde:	45 0f b6 c2          	movzbl %r10b,%r8d
  8c2de2:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
  8c2de8:	49 c1 e0 30          	shl    $0x30,%r8
  8c2dec:	4f 8d 44 10 0b       	lea    0xb(%r8,%r10,1),%r8
  8c2df1:	4d 89 04 11          	mov    %r8,(%r9,%rdx,1)
  8c2df5:	49 c7 44 11 08 00 00 	movq   $0x0,0x8(%r9,%rdx,1)
  8c2dfc:	00 00 
  8c2dfe:	e9 df 02 00 00       	jmp    8c30e2 <check_lower_drain+0x1142>
  8c2e03:	41 8d 53 cb          	lea    -0x35(%r11),%edx
  8c2e07:	83 fa 01             	cmp    $0x1,%edx
  8c2e0a:	0f 87 fc 00 00 00    	ja     8c2f0c <check_lower_drain+0xf6c>
  8c2e10:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2e15:	c5 f8 77             	vzeroupper
  8c2e18:	e8 83 db 00 00       	call   8d09a0 <check_lower_builtin_prepare>
  8c2e1d:	e9 5e 2d 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2e22:	41 83 7e 04 01       	cmpl   $0x1,0x4(%r14)
  8c2e27:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2e2c:	0f 94 c0             	sete   %al
  8c2e2f:	85 f6                	test   %esi,%esi
  8c2e31:	0f 95 c1             	setne  %cl
  8c2e34:	20 c1                	and    %al,%cl
  8c2e36:	80 f9 01             	cmp    $0x1,%cl
  8c2e39:	0f 85 07 01 00 00    	jne    8c2f46 <check_lower_drain+0xfa6>
  8c2e3f:	8b 85 c0 00 00 00    	mov    0xc0(%rbp),%eax
  8c2e45:	39 c6                	cmp    %eax,%esi
  8c2e47:	73 17                	jae    8c2e60 <check_lower_drain+0xec0>
  8c2e49:	41 8d 4f f5          	lea    -0xb(%r15),%ecx
  8c2e4d:	80 f9 02             	cmp    $0x2,%cl
  8c2e50:	77 0e                	ja     8c2e60 <check_lower_drain+0xec0>
  8c2e52:	48 8b 4f 68          	mov    0x68(%rdi),%rcx
  8c2e56:	83 3c b1 ff          	cmpl   $0xffffffff,(%rcx,%rsi,4)
  8c2e5a:	0f 84 41 04 00 00    	je     8c32a1 <check_lower_drain+0x1301>
  8c2e60:	39 c6                	cmp    %eax,%esi
  8c2e62:	0f 83 de 00 00 00    	jae    8c2f46 <check_lower_drain+0xfa6>
  8c2e68:	48 8b 47 68          	mov    0x68(%rdi),%rax
  8c2e6c:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c2e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c2e74:	48 39 c1             	cmp    %rax,%rcx
  8c2e77:	0f 84 4b 04 00 00    	je     8c32c8 <check_lower_drain+0x1328>
  8c2e7d:	41 0f b6 d7          	movzbl %r15b,%edx
  8c2e81:	be 02 00 00 00       	mov    $0x2,%esi
  8c2e86:	c5 f8 77             	vzeroupper
  8c2e89:	e8 32 31 00 00       	call   8c5fc0 <check_lower_emit>
  8c2e8e:	e9 ed 2c 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2e93:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c2e97:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2e9e:	75 1a                	jne    8c2eba <check_lower_drain+0xf1a>
  8c2ea0:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c2ea7:	00 00 00 
  8c2eaa:	8b 87 64 01 00 00    	mov    0x164(%rdi),%eax
  8c2eb0:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c2eb4:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c2eba:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c2ec0:	31 d2                	xor    %edx,%edx
  8c2ec2:	31 c9                	xor    %ecx,%ecx
  8c2ec4:	c5 f8 77             	vzeroupper
  8c2ec7:	e8 04 cc 00 00       	call   8cfad0 <check_lower_operand>
  8c2ecc:	e9 af 2c 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2ed1:	3b 4c 24 50          	cmp    0x50(%rsp),%ecx
  8c2ed5:	73 16                	jae    8c2eed <check_lower_drain+0xf4d>
  8c2ed7:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c2edc:	48 8b 92 a0 01 00 00 	mov    0x1a0(%rdx),%rdx
  8c2ee3:	f6 04 0a 02          	testb  $0x2,(%rdx,%rcx,1)
  8c2ee7:	0f 85 bb fe ff ff    	jne    8c2da8 <check_lower_drain+0xe08>
  8c2eed:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c2ef2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c2ef6:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2efd:	0f 85 7d 2c 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c2f03:	48 8d 0d 9b fb e2 ff 	lea    -0x1d0465(%rip),%rcx        # 6f2aa5 <pp_string_value.meaning+0x3eff1>
  8c2f0a:	eb 52                	jmp    8c2f5e <check_lower_drain+0xfbe>
  8c2f0c:	41 83 fb 3f          	cmp    $0x3f,%r11d
  8c2f10:	74 22                	je     8c2f34 <check_lower_drain+0xf94>
  8c2f12:	41 83 fb 3c          	cmp    $0x3c,%r11d
  8c2f16:	0f 85 6f 01 00 00    	jne    8c308b <check_lower_drain+0x10eb>
  8c2f1c:	48 8b 43 38          	mov    0x38(%rbx),%rax
  8c2f20:	b9 df fe ff ff       	mov    $0xfffffedf,%ecx
  8c2f25:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c2f29:	01 c8                	add    %ecx,%eax
  8c2f2b:	83 f8 01             	cmp    $0x1,%eax
  8c2f2e:	0f 87 2d 03 00 00    	ja     8c3261 <check_lower_drain+0x12c1>
  8c2f34:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c2f39:	c5 f8 77             	vzeroupper
  8c2f3c:	e8 bf e2 00 00       	call   8d1200 <check_lower_helper>
  8c2f41:	e9 3a 2c 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c2f46:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c2f4a:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2f51:	0f 85 29 2c 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c2f57:	48 8d 0d 61 15 e8 ff 	lea    -0x17ea9f(%rip),%rcx        # 7444bf <pp_decode_file_name.meaning+0xd13d>
  8c2f5e:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c2f65:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c2f6a:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8c2f6e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c2f75:	0f 85 05 2c 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c2f7b:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c2f82:	00 00 00 
  8c2f85:	e9 e1 2b 00 00       	jmp    8c5b6b <check_lower_drain+0x3bcb>
  8c2f8a:	83 7b 0c 00          	cmpl   $0x0,0xc(%rbx)
  8c2f8e:	74 47                	je     8c2fd7 <check_lower_drain+0x1037>
  8c2f90:	83 7b 54 00          	cmpl   $0x0,0x54(%rbx)
  8c2f94:	75 41                	jne    8c2fd7 <check_lower_drain+0x1037>
  8c2f96:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  8c2f9b:	44 0f b7 73 08       	movzwl 0x8(%rbx),%r14d
  8c2fa0:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
  8c2fa5:	41 f7 c6 10 08 00 00 	test   $0x810,%r14d
  8c2fac:	75 29                	jne    8c2fd7 <check_lower_drain+0x1037>
  8c2fae:	83 7b 04 00          	cmpl   $0x0,0x4(%rbx)
  8c2fb2:	75 23                	jne    8c2fd7 <check_lower_drain+0x1037>
  8c2fb4:	41 83 fa 3e          	cmp    $0x3e,%r10d
  8c2fb8:	0f 87 82 f8 ff ff    	ja     8c2840 <check_lower_drain+0x8a0>
  8c2fbe:	49 bf 00 00 00 00 08 	movabs $0x4080000800000000,%r15
  8c2fc5:	00 80 40 
  8c2fc8:	4d 0f a3 d7          	bt     %r10,%r15
  8c2fcc:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
  8c2fd1:	0f 83 69 f8 ff ff    	jae    8c2840 <check_lower_drain+0x8a0>
  8c2fd7:	45 31 f6             	xor    %r14d,%r14d
  8c2fda:	45 88 ee             	mov    %r13b,%r14b
  8c2fdd:	45 8d 6e 01          	lea    0x1(%r14),%r13d
  8c2fe1:	4c 89 74 24 78       	mov    %r14,0x78(%rsp)
  8c2fe6:	41 39 f5             	cmp    %esi,%r13d
  8c2fe9:	0f 87 51 f8 ff ff    	ja     8c2840 <check_lower_drain+0x8a0>
  8c2fef:	44 03 6c 24 30       	add    0x30(%rsp),%r13d
  8c2ff4:	41 39 f5             	cmp    %esi,%r13d
  8c2ff7:	0f 85 43 f8 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c2ffd:	83 7c 24 48 0f       	cmpl   $0xf,0x48(%rsp)
  8c3002:	77 18                	ja     8c301c <check_lower_drain+0x107c>
  8c3004:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  8c3009:	4d 89 fd             	mov    %r15,%r13
  8c300c:	45 8d 7e 01          	lea    0x1(%r14),%r15d
  8c3010:	41 39 f7             	cmp    %esi,%r15d
  8c3013:	4d 89 ef             	mov    %r13,%r15
  8c3016:	0f 85 24 f8 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c301c:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  8c3021:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  8c3026:	41 2b be 38 01 00 00 	sub    0x138(%r14),%edi
  8c302d:	0f 82 0d f8 ff ff    	jb     8c2840 <check_lower_drain+0x8a0>
  8c3033:	44 0f b6 74 24 58    	movzbl 0x58(%rsp),%r14d
  8c3039:	4c 8b 7c 24 78       	mov    0x78(%rsp),%r15
  8c303e:	44 88 f1             	mov    %r14b,%cl
  8c3041:	41 8d 4c 0f 01       	lea    0x1(%r15,%rcx,1),%ecx
  8c3046:	39 f9                	cmp    %edi,%ecx
  8c3048:	0f 87 f2 f7 ff ff    	ja     8c2840 <check_lower_drain+0x8a0>
  8c304e:	41 29 d4             	sub    %edx,%r12d
  8c3051:	0f 93 c1             	setae  %cl
  8c3054:	41 83 fc 05          	cmp    $0x5,%r12d
  8c3058:	0f 93 c2             	setae  %dl
  8c305b:	20 ca                	and    %cl,%dl
  8c305d:	80 fa 01             	cmp    $0x1,%dl
  8c3060:	0f 85 da f7 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3066:	31 c9                	xor    %ecx,%ecx
  8c3068:	41 83 fa 23          	cmp    $0x23,%r10d
  8c306c:	0f 8f 60 04 00 00    	jg     8c34d2 <check_lower_drain+0x1532>
  8c3072:	41 83 fa 01          	cmp    $0x1,%r10d
  8c3076:	0f 84 b7 05 00 00    	je     8c3633 <check_lower_drain+0x1693>
  8c307c:	41 83 fa 18          	cmp    $0x18,%r10d
  8c3080:	0f 84 ad 05 00 00    	je     8c3633 <check_lower_drain+0x1693>
  8c3086:	e9 9d 05 00 00       	jmp    8c3628 <check_lower_drain+0x1688>
  8c308b:	41 8d 53 be          	lea    -0x42(%r11),%edx
  8c308f:	83 fa 02             	cmp    $0x2,%edx
  8c3092:	0f 87 db 01 00 00    	ja     8c3273 <check_lower_drain+0x12d3>
  8c3098:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c309d:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c30a1:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c30a8:	0f 85 d2 2a 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c30ae:	48 8d 0d 14 b1 da ff 	lea    -0x254eec(%rip),%rcx        # 66e1c9 <fuzz_comment_end+0xb6d3>
  8c30b5:	e9 a4 fe ff ff       	jmp    8c2f5e <check_lower_drain+0xfbe>
  8c30ba:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8c30be:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c30c5:	75 1b                	jne    8c30e2 <check_lower_drain+0x1142>
  8c30c7:	c7 82 f0 00 00 00 03 	movl   $0x3,0xf0(%rdx)
  8c30ce:	00 00 00 
  8c30d1:	8b 97 64 01 00 00    	mov    0x164(%rdi),%edx
  8c30d7:	4c 8b 47 08          	mov    0x8(%rdi),%r8
  8c30db:	41 89 90 f4 00 00 00 	mov    %edx,0xf4(%r8)
  8c30e2:	41 83 fb 41          	cmp    $0x41,%r11d
  8c30e6:	0f 85 ea 00 00 00    	jne    8c31d6 <check_lower_drain+0x1236>
  8c30ec:	8b 97 3c 01 00 00    	mov    0x13c(%rdi),%edx
  8c30f2:	3b 97 40 01 00 00    	cmp    0x140(%rdi),%edx
  8c30f8:	73 30                	jae    8c312a <check_lower_drain+0x118a>
  8c30fa:	4c 8b 4f 18          	mov    0x18(%rdi),%r9
  8c30fe:	44 8d 42 01          	lea    0x1(%rdx),%r8d
  8c3102:	48 c1 e2 04          	shl    $0x4,%rdx
  8c3106:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c310d:	49 b8 01 00 00 00 01 	movabs $0x8000100000001,%r8
  8c3114:	00 08 00 
  8c3117:	49 83 c0 14          	add    $0x14,%r8
  8c311b:	4d 89 04 11          	mov    %r8,(%r9,%rdx,1)
  8c311f:	49 c7 44 11 08 01 00 	movq   $0x1,0x8(%r9,%rdx,1)
  8c3126:	00 00 
  8c3128:	eb 28                	jmp    8c3152 <check_lower_drain+0x11b2>
  8c312a:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8c312e:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c3135:	75 1b                	jne    8c3152 <check_lower_drain+0x11b2>
  8c3137:	c7 82 f0 00 00 00 03 	movl   $0x3,0xf0(%rdx)
  8c313e:	00 00 00 
  8c3141:	8b 97 64 01 00 00    	mov    0x164(%rdi),%edx
  8c3147:	4c 8b 47 08          	mov    0x8(%rdi),%r8
  8c314b:	41 89 90 f4 00 00 00 	mov    %edx,0xf4(%r8)
  8c3152:	4d 8b 4d 20          	mov    0x20(%r13),%r9
  8c3156:	4d 8b 45 00          	mov    0x0(%r13),%r8
  8c315a:	49 8b 55 38          	mov    0x38(%r13),%rdx
  8c315e:	41 8b 0c 89          	mov    (%r9,%rcx,4),%ecx
  8c3162:	c1 e9 03             	shr    $0x3,%ecx
  8c3165:	41 80 3c 08 0f       	cmpb   $0xf,(%r8,%rcx,1)
  8c316a:	75 07                	jne    8c3173 <check_lower_drain+0x11d3>
  8c316c:	41 8b 0c 89          	mov    (%r9,%rcx,4),%ecx
  8c3170:	c1 e9 03             	shr    $0x3,%ecx
  8c3173:	44 8b 8f 3c 01 00 00 	mov    0x13c(%rdi),%r9d
  8c317a:	44 3b 8f 40 01 00 00 	cmp    0x140(%rdi),%r9d
  8c3181:	73 2c                	jae    8c31af <check_lower_drain+0x120f>
  8c3183:	48 8b 0c ca          	mov    (%rdx,%rcx,8),%rcx
  8c3187:	4c 8b 57 18          	mov    0x18(%rdi),%r10
  8c318b:	45 8d 41 01          	lea    0x1(%r9),%r8d
  8c318f:	49 c1 e1 04          	shl    $0x4,%r9
  8c3193:	44 89 87 3c 01 00 00 	mov    %r8d,0x13c(%rdi)
  8c319a:	49 b8 01 00 00 00 01 	movabs $0x8000100000001,%r8
  8c31a1:	00 08 00 
  8c31a4:	4f 89 04 0a          	mov    %r8,(%r10,%r9,1)
  8c31a8:	4b 89 4c 0a 08       	mov    %rcx,0x8(%r10,%r9,1)
  8c31ad:	eb 27                	jmp    8c31d6 <check_lower_drain+0x1236>
  8c31af:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c31b3:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c31ba:	75 1a                	jne    8c31d6 <check_lower_drain+0x1236>
  8c31bc:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c31c3:	00 00 00 
  8c31c6:	8b 8f 64 01 00 00    	mov    0x164(%rdi),%ecx
  8c31cc:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8c31d0:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c31d6:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
  8c31db:	31 c9                	xor    %ecx,%ecx
  8c31dd:	83 7c 02 04 01       	cmpl   $0x1,0x4(%rdx,%rax,1)
  8c31e2:	0f 94 c1             	sete   %cl
  8c31e5:	e9 a4 f9 ff ff       	jmp    8c2b8e <check_lower_drain+0xbee>
  8c31ea:	49 8b 47 08          	mov    0x8(%r15),%rax
  8c31ee:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c31f5:	75 1b                	jne    8c3212 <check_lower_drain+0x1272>
  8c31f7:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c31fe:	00 00 00 
  8c3201:	41 8b 87 64 01 00 00 	mov    0x164(%r15),%eax
  8c3208:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  8c320c:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c3212:	41 83 fb 39          	cmp    $0x39,%r11d
  8c3216:	0f 84 20 fb ff ff    	je     8c2d3c <check_lower_drain+0xd9c>
  8c321c:	e9 5f 29 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c3221:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c3225:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c322c:	75 1a                	jne    8c3248 <check_lower_drain+0x12a8>
  8c322e:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c3235:	00 00 00 
  8c3238:	8b 87 64 01 00 00    	mov    0x164(%rdi),%eax
  8c323e:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  8c3242:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c3248:	41 8b 76 40          	mov    0x40(%r14),%esi
  8c324c:	ff ca                	dec    %edx
  8c324e:	ff ce                	dec    %esi
  8c3250:	48 c1 e6 20          	shl    $0x20,%rsi
  8c3254:	c5 f8 77             	vzeroupper
  8c3257:	e8 b4 34 00 00       	call   8c6710 <check_lower_initializer>
  8c325c:	e9 1f 29 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c3261:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c3266:	c5 f8 77             	vzeroupper
  8c3269:	e8 02 e9 00 00       	call   8d1b70 <check_lower_miscellaneous_prepare>
  8c326e:	e9 0d 29 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c3273:	41 8d 53 e7          	lea    -0x19(%r11),%edx
  8c3277:	83 fa 25             	cmp    $0x25,%edx
  8c327a:	0f 87 df 01 00 00    	ja     8c345f <check_lower_drain+0x14bf>
  8c3280:	48 8d 3d 45 41 be ff 	lea    -0x41bebb(%rip),%rdi        # 4a73cc <cbuiltin_test_generated.edges+0xad3c>
  8c3287:	48 63 14 97          	movslq (%rdi,%rdx,4),%rdx
  8c328b:	48 01 fa             	add    %rdi,%rdx
  8c328e:	ff e2                	jmp    *%rdx
  8c3290:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c3295:	31 d2                	xor    %edx,%edx
  8c3297:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c329c:	e9 ef f8 ff ff       	jmp    8c2b90 <check_lower_drain+0xbf0>
  8c32a1:	49 8b 56 48          	mov    0x48(%r14),%rdx
  8c32a5:	48 89 fb             	mov    %rdi,%rbx
  8c32a8:	c5 f8 77             	vzeroupper
  8c32ab:	e8 40 8b 00 00       	call   8cbdf0 <check_lower_address>
  8c32b0:	41 0f b6 d7          	movzbl %r15b,%edx
  8c32b4:	be 0a 00 00 00       	mov    $0xa,%esi
  8c32b9:	48 89 df             	mov    %rbx,%rdi
  8c32bc:	31 c9                	xor    %ecx,%ecx
  8c32be:	e8 fd 2c 00 00       	call   8c5fc0 <check_lower_emit>
  8c32c3:	e9 b8 28 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c32c8:	48 8b 85 80 00 00 00 	mov    0x80(%rbp),%rax
  8c32cf:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c32d2:	48 85 c9             	test   %rcx,%rcx
  8c32d5:	74 16                	je     8c32ed <check_lower_drain+0x134d>
  8c32d7:	41 0f b6 d7          	movzbl %r15b,%edx
  8c32db:	be 04 00 00 00       	mov    $0x4,%esi
  8c32e0:	c5 f8 77             	vzeroupper
  8c32e3:	e8 d8 2c 00 00       	call   8c5fc0 <check_lower_emit>
  8c32e8:	e9 93 28 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c32ed:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8c32f1:	e9 62 28 00 00       	jmp    8c5b58 <check_lower_drain+0x3bb8>
  8c32f6:	4c 89 e0             	mov    %r12,%rax
  8c32f9:	4d 8b 64 24 60       	mov    0x60(%r12),%r12
  8c32fe:	8b 80 b4 00 00 00    	mov    0xb4(%rax),%eax
  8c3304:	ba 00 01 00 00       	mov    $0x100,%edx
  8c3309:	48 89 f1             	mov    %rsi,%rcx
  8c330c:	49 89 ce             	mov    %rcx,%r14
  8c330f:	4c 89 e7             	mov    %r12,%rdi
  8c3312:	89 c6                	mov    %eax,%esi
  8c3314:	c5 f8 77             	vzeroupper
  8c3317:	e8 b4 96 fc ff       	call   88c9d0 <check_program_builtin_index>
  8c331c:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c331f:	0f 84 89 01 00 00    	je     8c34ae <check_lower_drain+0x150e>
  8c3325:	4d 85 e4             	test   %r12,%r12
  8c3328:	0f 84 80 01 00 00    	je     8c34ae <check_lower_drain+0x150e>
  8c332e:	89 c0                	mov    %eax,%eax
  8c3330:	48 c1 e0 08          	shl    $0x8,%rax
  8c3334:	49 01 c4             	add    %rax,%r12
  8c3337:	41 83 bc 24 d0 00 00 	cmpl   $0x0,0xd0(%r12)
  8c333e:	00 00 
  8c3340:	0f 84 68 01 00 00    	je     8c34ae <check_lower_drain+0x150e>
  8c3346:	41 83 bc 24 f0 00 00 	cmpl   $0x0,0xf0(%r12)
  8c334d:	00 00 
  8c334f:	0f 84 59 01 00 00    	je     8c34ae <check_lower_drain+0x150e>
  8c3355:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c335a:	44 89 f6             	mov    %r14d,%esi
  8c335d:	4c 89 e2             	mov    %r12,%rdx
  8c3360:	e8 9b eb 00 00       	call   8d1f00 <check_lower_math>
  8c3365:	e9 16 28 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c336a:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c3370:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  8c3375:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
  8c337a:	48 89 c1             	mov    %rax,%rcx
  8c337d:	0f 95 c0             	setne  %al
  8c3380:	0a 44 24 48          	or     0x48(%rsp),%al
  8c3384:	75 21                	jne    8c33a7 <check_lower_drain+0x1407>
  8c3386:	0f b6 d1             	movzbl %cl,%edx
  8c3389:	48 89 f3             	mov    %rsi,%rbx
  8c338c:	be 0a 00 00 00       	mov    $0xa,%esi
  8c3391:	4c 89 f7             	mov    %r14,%rdi
  8c3394:	31 c9                	xor    %ecx,%ecx
  8c3396:	4d 89 c7             	mov    %r8,%r15
  8c3399:	c5 f8 77             	vzeroupper
  8c339c:	e8 6f 31 00 00       	call   8c6510 <check_lower_instruction>
  8c33a1:	4d 89 f8             	mov    %r15,%r8
  8c33a4:	48 89 de             	mov    %rbx,%rsi
  8c33a7:	4c 89 f7             	mov    %r14,%rdi
  8c33aa:	31 d2                	xor    %edx,%edx
  8c33ac:	31 c9                	xor    %ecx,%ecx
  8c33ae:	c5 f8 77             	vzeroupper
  8c33b1:	e8 1a c7 00 00       	call   8cfad0 <check_lower_operand>
  8c33b6:	e9 c5 27 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c33bb:	4c 89 e0             	mov    %r12,%rax
  8c33be:	4d 8b 64 24 68       	mov    0x68(%r12),%r12
  8c33c3:	8b 80 b8 00 00 00    	mov    0xb8(%rax),%eax
  8c33c9:	ba b0 00 00 00       	mov    $0xb0,%edx
  8c33ce:	48 89 f1             	mov    %rsi,%rcx
  8c33d1:	49 89 ce             	mov    %rcx,%r14
  8c33d4:	4c 89 e7             	mov    %r12,%rdi
  8c33d7:	89 c6                	mov    %eax,%esi
  8c33d9:	c5 f8 77             	vzeroupper
  8c33dc:	e8 ef 95 fc ff       	call   88c9d0 <check_program_builtin_index>
  8c33e1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c33e4:	0f 84 65 27 00 00    	je     8c5b4f <check_lower_drain+0x3baf>
  8c33ea:	89 c1                	mov    %eax,%ecx
  8c33ec:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c33f3:	49 01 cc             	add    %rcx,%r12
  8c33f6:	48 8b 4d 00          	mov    0x0(%rbp),%rcx
  8c33fa:	48 8b 51 38          	mov    0x38(%rcx),%rdx
  8c33fe:	b1 01                	mov    $0x1,%cl
  8c3400:	42 81 3c ba 30 01 00 	cmpl   $0x130,(%rdx,%r15,4)
  8c3407:	00 
  8c3408:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c340d:	75 10                	jne    8c341f <check_lower_drain+0x147f>
  8c340f:	41 8b 8c 24 8c 00 00 	mov    0x8c(%r12),%ecx
  8c3416:	00 
  8c3417:	ff c9                	dec    %ecx
  8c3419:	83 f9 02             	cmp    $0x2,%ecx
  8c341c:	0f 92 c1             	setb   %cl
  8c341f:	84 c9                	test   %cl,%cl
  8c3421:	74 1f                	je     8c3442 <check_lower_drain+0x14a2>
  8c3423:	41 83 bc 24 a0 00 00 	cmpl   $0x0,0xa0(%r12)
  8c342a:	00 00 
  8c342c:	75 14                	jne    8c3442 <check_lower_drain+0x14a2>
  8c342e:	41 83 7c 24 1c 00    	cmpl   $0x0,0x1c(%r12)
  8c3434:	74 0c                	je     8c3442 <check_lower_drain+0x14a2>
  8c3436:	41 83 7c 24 64 00    	cmpl   $0x0,0x64(%r12)
  8c343c:	0f 84 2e 0a 00 00    	je     8c3e70 <check_lower_drain+0x1ed0>
  8c3442:	48 8b 42 08          	mov    0x8(%rdx),%rax
  8c3446:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c344d:	0f 85 2d 27 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c3453:	48 8d 0d 01 f6 e2 ff 	lea    -0x1d09ff(%rip),%rcx        # 6f2a5b <pp_string_value.meaning+0x3efa7>
  8c345a:	e9 ff fa ff ff       	jmp    8c2f5e <check_lower_drain+0xfbe>
  8c345f:	83 f9 20             	cmp    $0x20,%ecx
  8c3462:	0f 85 85 00 00 00    	jne    8c34ed <check_lower_drain+0x154d>
  8c3468:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  8c346d:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c3472:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
  8c3477:	41 83 fb 21          	cmp    $0x21,%r11d
  8c347b:	0f 85 0f 01 00 00    	jne    8c3590 <check_lower_drain+0x15f0>
  8c3481:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  8c3486:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c348a:	49 8b 4d 20          	mov    0x20(%r13),%rcx
  8c348e:	89 f2                	mov    %esi,%edx
  8c3490:	c1 ea 03             	shr    $0x3,%edx
  8c3493:	83 e6 07             	and    $0x7,%esi
  8c3496:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8c349a:	04 f8                	add    $0xf8,%al
  8c349c:	3c 03                	cmp    $0x3,%al
  8c349e:	b8 00 00 00 00       	mov    $0x0,%eax
  8c34a3:	0f 43 f0             	cmovae %eax,%esi
  8c34a6:	0b 34 91             	or     (%rcx,%rdx,4),%esi
  8c34a9:	e9 f2 00 00 00       	jmp    8c35a0 <check_lower_drain+0x1600>
  8c34ae:	48 8b 43 38          	mov    0x38(%rbx),%rax
  8c34b2:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c34b7:	44 89 f6             	mov    %r14d,%esi
  8c34ba:	42 81 3c b8 52 01 00 	cmpl   $0x152,(%rax,%r15,4)
  8c34c1:	00 
  8c34c2:	0f 85 be 00 00 00    	jne    8c3586 <check_lower_drain+0x15e6>
  8c34c8:	e8 33 dd 00 00       	call   8d1200 <check_lower_helper>
  8c34cd:	e9 ae 26 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c34d2:	41 83 fa 24          	cmp    $0x24,%r10d
  8c34d6:	0f 84 57 01 00 00    	je     8c3633 <check_lower_drain+0x1693>
  8c34dc:	41 83 fa 34          	cmp    $0x34,%r10d
  8c34e0:	0f 85 42 01 00 00    	jne    8c3628 <check_lower_drain+0x1688>
  8c34e6:	31 d2                	xor    %edx,%edx
  8c34e8:	e9 5c 01 00 00       	jmp    8c3649 <check_lower_drain+0x16a9>
  8c34ed:	45 8b 06             	mov    (%r14),%r8d
  8c34f0:	41 83 fb 24          	cmp    $0x24,%r11d
  8c34f4:	0f 87 a1 0a 00 00    	ja     8c3f9b <check_lower_drain+0x1ffb>
  8c34fa:	bf f4 01 00 00       	mov    $0x1f4,%edi
  8c34ff:	44 89 da             	mov    %r11d,%edx
  8c3502:	48 0f a3 d7          	bt     %rdx,%rdi
  8c3506:	0f 83 a3 03 00 00    	jae    8c38af <check_lower_drain+0x190f>
  8c350c:	44 89 c1             	mov    %r8d,%ecx
  8c350f:	c1 e9 03             	shr    $0x3,%ecx
  8c3512:	3b 4c 24 50          	cmp    0x50(%rsp),%ecx
  8c3516:	73 18                	jae    8c3530 <check_lower_drain+0x1590>
  8c3518:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c351d:	89 c9                	mov    %ecx,%ecx
  8c351f:	48 8b 92 a0 01 00 00 	mov    0x1a0(%rdx),%rdx
  8c3526:	f6 04 0a 02          	testb  $0x2,(%rdx,%rcx,1)
  8c352a:	0f 85 d9 06 00 00    	jne    8c3c09 <check_lower_drain+0x1c69>
  8c3530:	41 8d 4b fe          	lea    -0x2(%r11),%ecx
  8c3534:	83 f9 23             	cmp    $0x23,%ecx
  8c3537:	0f 87 4f 0d 00 00    	ja     8c428c <check_lower_drain+0x22ec>
  8c353d:	48 8d 15 20 3f be ff 	lea    -0x41c0e0(%rip),%rdx        # 4a7464 <cbuiltin_test_generated.edges+0xadd4>
  8c3544:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  8c3548:	48 01 d1             	add    %rdx,%rcx
  8c354b:	ff e1                	jmp    *%rcx
  8c354d:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c3552:	48 89 c1             	mov    %rax,%rcx
  8c3555:	31 c0                	xor    %eax,%eax
  8c3557:	41 83 fb 02          	cmp    $0x2,%r11d
  8c355b:	0f b6 d1             	movzbl %cl,%edx
  8c355e:	49 89 f6             	mov    %rsi,%r14
  8c3561:	0f 95 c0             	setne  %al
  8c3564:	31 c9                	xor    %ecx,%ecx
  8c3566:	83 c0 07             	add    $0x7,%eax
  8c3569:	89 c6                	mov    %eax,%esi
  8c356b:	48 89 df             	mov    %rbx,%rdi
  8c356e:	c5 f8 77             	vzeroupper
  8c3571:	e8 9a 2f 00 00       	call   8c6510 <check_lower_instruction>
  8c3576:	48 89 df             	mov    %rbx,%rdi
  8c3579:	44 89 f6             	mov    %r14d,%esi
  8c357c:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
  8c3581:	e9 24 fe ff ff       	jmp    8c33aa <check_lower_drain+0x140a>
  8c3586:	e8 95 ef 00 00       	call   8d2520 <check_lower_floating_prepare>
  8c358b:	e9 f0 25 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c3590:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  8c3595:	4b 8d 04 52          	lea    (%r10,%r10,2),%rax
  8c3599:	48 c1 e0 05          	shl    $0x5,%rax
  8c359d:	8b 34 01             	mov    (%rcx,%rax,1),%esi
  8c35a0:	48 c7 84 24 f8 01 00 	movq   $0x0,0x1f8(%rsp)
  8c35a7:	00 00 00 00 00 
  8c35ac:	48 8d 8c 24 f8 01 00 	lea    0x1f8(%rsp),%rcx
  8c35b3:	00 
  8c35b4:	4c 89 ef             	mov    %r13,%rdi
  8c35b7:	48 8b 43 38          	mov    0x38(%rbx),%rax
  8c35bb:	42 8b 14 b8          	mov    (%rax,%r15,4),%edx
  8c35bf:	c5 f8 77             	vzeroupper
  8c35c2:	e8 e9 0f 92 00       	call   11e45b0 <type_find_member>
  8c35c7:	41 8b 4e 08          	mov    0x8(%r14),%ecx
  8c35cb:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c35cf:	c5 f9 7f 84 24 e0 01 	vmovdqa %xmm0,0x1e0(%rsp)
  8c35d6:	00 00 
  8c35d8:	48 c7 84 24 f0 01 00 	movq   $0x0,0x1f0(%rsp)
  8c35df:	00 00 00 00 00 
  8c35e4:	85 c0                	test   %eax,%eax
  8c35e6:	74 1e                	je     8c3606 <check_lower_drain+0x1666>
  8c35e8:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c35ed:	f6 c1 04             	test   $0x4,%cl
  8c35f0:	0f 85 12 03 00 00    	jne    8c3908 <check_lower_drain+0x1968>
  8c35f6:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  8c35fd:	00 
  8c35fe:	a8 07                	test   $0x7,%al
  8c3600:	0f 84 09 09 00 00    	je     8c3f0f <check_lower_drain+0x1f6f>
  8c3606:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c360b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8c360f:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3616:	0f 85 64 25 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c361c:	48 8d 15 5c d6 d5 ff 	lea    -0x2a29a4(%rip),%rdx        # 620c7f <foreign_touch.flags+0x497a>
  8c3623:	e9 21 08 00 00       	jmp    8c3e49 <check_lower_drain+0x1ea9>
  8c3628:	4c 89 cb             	mov    %r9,%rbx
  8c362b:	48 c1 e3 05          	shl    $0x5,%rbx
  8c362f:	49 03 5b 10          	add    0x10(%r11),%rbx
  8c3633:	8b 13                	mov    (%rbx),%edx
  8c3635:	83 7c 24 48 0f       	cmpl   $0xf,0x48(%rsp)
  8c363a:	77 0d                	ja     8c3649 <check_lower_drain+0x16a9>
  8c363c:	49 8b 4b 10          	mov    0x10(%r11),%rcx
  8c3640:	49 c1 e1 05          	shl    $0x5,%r9
  8c3644:	42 8b 4c 09 08       	mov    0x8(%rcx,%r9,1),%ecx
  8c3649:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8c364e:	41 83 3c b8 00       	cmpl   $0x0,(%r8,%rdi,4)
  8c3653:	74 18                	je     8c366d <check_lower_drain+0x16cd>
  8c3655:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8c365a:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  8c365e:	48 c1 e7 05          	shl    $0x5,%rdi
  8c3662:	83 7c 3d 0c 01       	cmpl   $0x1,0xc(%rbp,%rdi,1)
  8c3667:	0f 85 d3 f1 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c366d:	83 7c 24 48 0f       	cmpl   $0xf,0x48(%rsp)
  8c3672:	77 1e                	ja     8c3692 <check_lower_drain+0x16f2>
  8c3674:	8b 7c 24 50          	mov    0x50(%rsp),%edi
  8c3678:	41 83 3c b8 00       	cmpl   $0x0,(%r8,%rdi,4)
  8c367d:	74 13                	je     8c3692 <check_lower_drain+0x16f2>
  8c367f:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  8c3683:	48 c1 e7 05          	shl    $0x5,%rdi
  8c3687:	83 7c 3d 0c 01       	cmpl   $0x1,0xc(%rbp,%rdi,1)
  8c368c:	0f 85 ae f1 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3692:	85 d2                	test   %edx,%edx
  8c3694:	74 1b                	je     8c36b1 <check_lower_drain+0x1711>
  8c3696:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8c369b:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  8c369f:	48 c1 e7 05          	shl    $0x5,%rdi
  8c36a3:	44 8b 4c 3d 00       	mov    0x0(%rbp,%rdi,1),%r9d
  8c36a8:	44 39 ca             	cmp    %r9d,%edx
  8c36ab:	0f 85 53 01 00 00    	jne    8c3804 <check_lower_drain+0x1864>
  8c36b1:	83 7c 24 48 0f       	cmpl   $0xf,0x48(%rsp)
  8c36b6:	0f 87 cc 00 00 00    	ja     8c3788 <check_lower_drain+0x17e8>
  8c36bc:	85 c9                	test   %ecx,%ecx
  8c36be:	0f 84 c4 00 00 00    	je     8c3788 <check_lower_drain+0x17e8>
  8c36c4:	8b 7c 24 50          	mov    0x50(%rsp),%edi
  8c36c8:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  8c36cc:	48 c1 e7 05          	shl    $0x5,%rdi
  8c36d0:	44 8b 54 3d 00       	mov    0x0(%rbp,%rdi,1),%r10d
  8c36d5:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c36da:	8b bf b0 01 00 00    	mov    0x1b0(%rdi),%edi
  8c36e0:	44 39 d1             	cmp    %r10d,%ecx
  8c36e3:	0f 84 aa 00 00 00    	je     8c3793 <check_lower_drain+0x17f3>
  8c36e9:	41 c1 ea 03          	shr    $0x3,%r10d
  8c36ed:	41 b8 ff 00 00 00    	mov    $0xff,%r8d
  8c36f3:	41 b9 ff 00 00 00    	mov    $0xff,%r9d
  8c36f9:	41 39 fa             	cmp    %edi,%r10d
  8c36fc:	73 04                	jae    8c3702 <check_lower_drain+0x1762>
  8c36fe:	46 8b 0c 90          	mov    (%rax,%r10,4),%r9d
  8c3702:	41 89 ca             	mov    %ecx,%r10d
  8c3705:	41 c1 ea 03          	shr    $0x3,%r10d
  8c3709:	41 39 fa             	cmp    %edi,%r10d
  8c370c:	73 07                	jae    8c3715 <check_lower_drain+0x1775>
  8c370e:	45 89 d0             	mov    %r10d,%r8d
  8c3711:	46 8b 04 80          	mov    (%rax,%r8,4),%r8d
  8c3715:	41 f7 c1 00 01 00 00 	test   $0x100,%r9d
  8c371c:	45 0f b6 d1          	movzbl %r9b,%r10d
  8c3720:	bb 08 00 00 00       	mov    $0x8,%ebx
  8c3725:	45 0f b6 d8          	movzbl %r8b,%r11d
  8c3729:	44 0f 45 d3          	cmovne %ebx,%r10d
  8c372d:	41 f7 c0 00 01 00 00 	test   $0x100,%r8d
  8c3734:	44 0f 45 db          	cmovne %ebx,%r11d
  8c3738:	45 39 da             	cmp    %r11d,%r10d
  8c373b:	41 0f 94 c3          	sete   %r11b
  8c373f:	41 83 fa 0f          	cmp    $0xf,%r10d
  8c3743:	41 0f 92 c2          	setb   %r10b
  8c3747:	45 20 da             	and    %r11b,%r10b
  8c374a:	41 80 fa 01          	cmp    $0x1,%r10b
  8c374e:	0f 85 ec f0 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3754:	45 89 c2             	mov    %r8d,%r10d
  8c3757:	41 c1 ea 08          	shr    $0x8,%r10d
  8c375b:	41 c1 e9 08          	shr    $0x8,%r9d
  8c375f:	45 89 d3             	mov    %r10d,%r11d
  8c3762:	45 31 cb             	xor    %r9d,%r11d
  8c3765:	41 f6 c3 01          	test   $0x1,%r11b
  8c3769:	0f 85 d1 f0 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c376f:	45 09 ca             	or     %r9d,%r10d
  8c3772:	41 81 e0 00 10 00 00 	and    $0x1000,%r8d
  8c3779:	41 83 e2 02          	and    $0x2,%r10d
  8c377d:	45 09 d0             	or     %r10d,%r8d
  8c3780:	0f 85 ba f0 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3786:	eb 0b                	jmp    8c3793 <check_lower_drain+0x17f3>
  8c3788:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c378d:	8b bf b0 01 00 00    	mov    0x1b0(%rdi),%edi
  8c3793:	41 89 d1             	mov    %edx,%r9d
  8c3796:	41 c1 e9 03          	shr    $0x3,%r9d
  8c379a:	41 b8 ff 00 00 00    	mov    $0xff,%r8d
  8c37a0:	41 39 f9             	cmp    %edi,%r9d
  8c37a3:	73 07                	jae    8c37ac <check_lower_drain+0x180c>
  8c37a5:	45 89 c8             	mov    %r9d,%r8d
  8c37a8:	46 8b 04 80          	mov    (%rax,%r8,4),%r8d
  8c37ac:	44 8b 54 24 48       	mov    0x48(%rsp),%r10d
  8c37b1:	85 d2                	test   %edx,%edx
  8c37b3:	0f 84 e4 01 00 00    	je     8c399d <check_lower_drain+0x19fd>
  8c37b9:	31 d2                	xor    %edx,%edx
  8c37bb:	41 83 fa 02          	cmp    $0x2,%r10d
  8c37bf:	45 0f b6 c8          	movzbl %r8b,%r9d
  8c37c3:	0f 92 c2             	setb   %dl
  8c37c6:	41 83 fa 10          	cmp    $0x10,%r10d
  8c37ca:	41 0f 93 c6          	setae  %r14b
  8c37ce:	c1 e2 0b             	shl    $0xb,%edx
  8c37d1:	81 ca 00 07 00 00    	or     $0x700,%edx
  8c37d7:	41 83 f9 0b          	cmp    $0xb,%r9d
  8c37db:	41 0f 92 c1          	setb   %r9b
  8c37df:	41 85 d0             	test   %edx,%r8d
  8c37e2:	0f 94 c2             	sete   %dl
  8c37e5:	44 20 ca             	and    %r9b,%dl
  8c37e8:	80 fa 01             	cmp    $0x1,%dl
  8c37eb:	75 0a                	jne    8c37f7 <check_lower_drain+0x1857>
  8c37ed:	41 83 fa 10          	cmp    $0x10,%r10d
  8c37f1:	0f 82 b7 01 00 00    	jb     8c39ae <check_lower_drain+0x1a0e>
  8c37f7:	84 d2                	test   %dl,%dl
  8c37f9:	0f 84 41 f0 ff ff    	je     8c2840 <check_lower_drain+0x8a0>
  8c37ff:	e9 ec 01 00 00       	jmp    8c39f0 <check_lower_drain+0x1a50>
  8c3804:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c3809:	41 c1 e9 03          	shr    $0x3,%r9d
  8c380d:	41 b8 ff 00 00 00    	mov    $0xff,%r8d
  8c3813:	44 8b 97 b0 01 00 00 	mov    0x1b0(%rdi),%r10d
  8c381a:	bf ff 00 00 00       	mov    $0xff,%edi
  8c381f:	45 39 d1             	cmp    %r10d,%r9d
  8c3822:	73 04                	jae    8c3828 <check_lower_drain+0x1888>
  8c3824:	46 8b 04 88          	mov    (%rax,%r9,4),%r8d
  8c3828:	41 89 d1             	mov    %edx,%r9d
  8c382b:	41 c1 e9 03          	shr    $0x3,%r9d
  8c382f:	45 39 d1             	cmp    %r10d,%r9d
  8c3832:	73 06                	jae    8c383a <check_lower_drain+0x189a>
  8c3834:	44 89 cf             	mov    %r9d,%edi
  8c3837:	8b 3c b8             	mov    (%rax,%rdi,4),%edi
  8c383a:	41 f7 c0 00 01 00 00 	test   $0x100,%r8d
  8c3841:	45 0f b6 c8          	movzbl %r8b,%r9d
  8c3845:	41 bb 08 00 00 00    	mov    $0x8,%r11d
  8c384b:	44 0f b6 d7          	movzbl %dil,%r10d
  8c384f:	45 0f 45 cb          	cmovne %r11d,%r9d
  8c3853:	f7 c7 00 01 00 00    	test   $0x100,%edi
  8c3859:	45 0f 45 d3          	cmovne %r11d,%r10d
  8c385d:	45 39 d1             	cmp    %r10d,%r9d
  8c3860:	41 0f 94 c2          	sete   %r10b
  8c3864:	41 83 f9 0f          	cmp    $0xf,%r9d
  8c3868:	41 0f 92 c1          	setb   %r9b
  8c386c:	45 20 d1             	and    %r10b,%r9b
  8c386f:	41 80 f9 01          	cmp    $0x1,%r9b
  8c3873:	0f 85 c7 ef ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3879:	41 89 f9             	mov    %edi,%r9d
  8c387c:	41 c1 e9 08          	shr    $0x8,%r9d
  8c3880:	41 c1 e8 08          	shr    $0x8,%r8d
  8c3884:	45 89 ca             	mov    %r9d,%r10d
  8c3887:	45 31 c2             	xor    %r8d,%r10d
  8c388a:	41 f6 c2 01          	test   $0x1,%r10b
  8c388e:	0f 85 ac ef ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3894:	45 09 c1             	or     %r8d,%r9d
  8c3897:	81 e7 00 10 00 00    	and    $0x1000,%edi
  8c389d:	41 83 e1 02          	and    $0x2,%r9d
  8c38a1:	44 09 cf             	or     %r9d,%edi
  8c38a4:	0f 85 96 ef ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c38aa:	e9 02 fe ff ff       	jmp    8c36b1 <check_lower_drain+0x1711>
  8c38af:	48 bf 02 00 00 01 10 	movabs $0x1001000002,%rdi
  8c38b6:	00 00 00 
  8c38b9:	48 0f a3 d7          	bt     %rdx,%rdi
  8c38bd:	0f 83 d8 06 00 00    	jae    8c3f9b <check_lower_drain+0x1ffb>
  8c38c3:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c38c8:	e9 dd fa ff ff       	jmp    8c33aa <check_lower_drain+0x140a>
  8c38cd:	41 0f b6 c0          	movzbl %r8b,%eax
  8c38d1:	83 c0 f7             	add    $0xfffffff7,%eax
  8c38d4:	83 f8 0a             	cmp    $0xa,%eax
  8c38d7:	0f 87 1a 11 00 00    	ja     8c49f7 <check_lower_drain+0x2a57>
  8c38dd:	48 8d 0d bc 3a be ff 	lea    -0x41c544(%rip),%rcx        # 4a73a0 <cbuiltin_test_generated.edges+0xad10>
  8c38e4:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  8c38e8:	48 01 c8             	add    %rcx,%rax
  8c38eb:	ff e0                	jmp    *%rax
  8c38ed:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c38f1:	89 f1                	mov    %esi,%ecx
  8c38f3:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  8c38f7:	48 c1 e6 05          	shl    $0x5,%rsi
  8c38fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c38ff:	48 03 70 08          	add    0x8(%rax),%rsi
  8c3903:	e9 5b 0d 00 00       	jmp    8c4663 <check_lower_drain+0x26c3>
  8c3908:	48 8d 94 24 e0 01 00 	lea    0x1e0(%rsp),%rdx
  8c390f:	00 
  8c3910:	48 89 ef             	mov    %rbp,%rdi
  8c3913:	e8 08 fd 00 00       	call   8d3620 <check_lower_bit_member>
  8c3918:	84 c0                	test   %al,%al
  8c391a:	0f 84 0c 05 00 00    	je     8c3e2c <check_lower_drain+0x1e8c>
  8c3920:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c3926:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c392b:	0f 85 06 06 00 00    	jne    8c3f37 <check_lower_drain+0x1f97>
  8c3931:	8b 84 24 ec 01 00 00 	mov    0x1ec(%rsp),%eax
  8c3938:	0f b6 8c 24 f0 01 00 	movzbl 0x1f0(%rsp),%ecx
  8c393f:	00 
  8c3940:	0f b6 94 24 f1 01 00 	movzbl 0x1f1(%rsp),%edx
  8c3947:	00 
  8c3948:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c394c:	c5 fe 7f 84 24 c0 01 	vmovdqu %ymm0,0x1c0(%rsp)
  8c3953:	00 00 
  8c3955:	c7 84 24 c0 01 00 00 	movl   $0x10,0x1c0(%rsp)
  8c395c:	10 00 00 00 
  8c3960:	48 89 df             	mov    %rbx,%rdi
  8c3963:	8d 04 c5 f8 ff ff ff 	lea    -0x8(,%rax,8),%eax
  8c396a:	0b 84 24 e8 01 00 00 	or     0x1e8(%rsp),%eax
  8c3971:	c1 e1 09             	shl    $0x9,%ecx
  8c3974:	c1 e2 0d             	shl    $0xd,%edx
  8c3977:	09 ca                	or     %ecx,%edx
  8c3979:	09 c2                	or     %eax,%edx
  8c397b:	89 94 24 c8 01 00 00 	mov    %edx,0x1c8(%rsp)
  8c3982:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c3989:	00 00 
  8c398b:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c3990:	c5 f8 77             	vzeroupper
  8c3993:	e8 28 69 00 00       	call   8ca2c0 <check_lower_push>
  8c3998:	e9 9a 05 00 00       	jmp    8c3f37 <check_lower_drain+0x1f97>
  8c399d:	41 b6 01             	mov    $0x1,%r14b
  8c39a0:	41 83 fa 0f          	cmp    $0xf,%r10d
  8c39a4:	77 4a                	ja     8c39f0 <check_lower_drain+0x1a50>
  8c39a6:	44 8b 54 24 48       	mov    0x48(%rsp),%r10d
  8c39ab:	45 31 f6             	xor    %r14d,%r14d
  8c39ae:	41 89 c8             	mov    %ecx,%r8d
  8c39b1:	41 c1 e8 03          	shr    $0x3,%r8d
  8c39b5:	ba ff 00 00 00       	mov    $0xff,%edx
  8c39ba:	41 39 f8             	cmp    %edi,%r8d
  8c39bd:	73 06                	jae    8c39c5 <check_lower_drain+0x1a25>
  8c39bf:	44 89 c2             	mov    %r8d,%edx
  8c39c2:	8b 14 90             	mov    (%rax,%rdx,4),%edx
  8c39c5:	85 c9                	test   %ecx,%ecx
  8c39c7:	74 27                	je     8c39f0 <check_lower_drain+0x1a50>
  8c39c9:	31 c0                	xor    %eax,%eax
  8c39cb:	41 83 fa 02          	cmp    $0x2,%r10d
  8c39cf:	0f b6 fa             	movzbl %dl,%edi
  8c39d2:	0f 92 c1             	setb   %cl
  8c39d5:	83 ff 0a             	cmp    $0xa,%edi
  8c39d8:	0f 87 62 ee ff ff    	ja     8c2840 <check_lower_drain+0x8a0>
  8c39de:	88 c8                	mov    %cl,%al
  8c39e0:	c1 e0 0b             	shl    $0xb,%eax
  8c39e3:	0d 00 07 00 00       	or     $0x700,%eax
  8c39e8:	21 c2                	and    %eax,%edx
  8c39ea:	0f 85 50 ee ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c39f0:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
  8c39f5:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c39fa:	48 89 f3             	mov    %rsi,%rbx
  8c39fd:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c3a02:	83 ca 02             	or     $0x2,%edx
  8c3a05:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  8c3a0a:	e8 41 c5 00 00       	call   8cff50 <check_lower_batch_classify>
  8c3a0f:	83 7c 24 48 10       	cmpl   $0x10,0x48(%rsp)
  8c3a14:	c4 e3 79 16 c1 01    	vpextrd $0x1,%xmm0,%ecx
  8c3a1a:	c4 e3 79 16 c7 02    	vpextrd $0x2,%xmm0,%edi
  8c3a20:	48 89 de             	mov    %rbx,%rsi
  8c3a23:	0f 43 f9             	cmovae %ecx,%edi
  8c3a26:	40 0f b6 c7          	movzbl %dil,%eax
  8c3a2a:	8d 50 ff             	lea    -0x1(%rax),%edx
  8c3a2d:	83 fa 0a             	cmp    $0xa,%edx
  8c3a30:	0f 93 c2             	setae  %dl
  8c3a33:	f7 c7 00 05 00 00    	test   $0x500,%edi
  8c3a39:	41 0f 95 c0          	setne  %r8b
  8c3a3d:	41 08 d0             	or     %dl,%r8b
  8c3a40:	0f 85 fa ed ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3a46:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c3a4b:	44 89 74 24 58       	mov    %r14d,0x58(%rsp)
  8c3a50:	4c 8b 0a             	mov    (%rdx),%r9
  8c3a53:	49 8b 51 08          	mov    0x8(%r9),%rdx
  8c3a57:	4c 8b 52 08          	mov    0x8(%rdx),%r10
  8c3a5b:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c3a60:	4c 8d 1c 52          	lea    (%rdx,%rdx,2),%r11
  8c3a64:	49 c1 e3 05          	shl    $0x5,%r11
  8c3a68:	43 8b 6c 1a 40       	mov    0x40(%r10,%r11,1),%ebp
  8c3a6d:	48 85 ed             	test   %rbp,%rbp
  8c3a70:	0f 84 45 05 00 00    	je     8c3fbb <check_lower_drain+0x201b>
  8c3a76:	41 3b a9 c0 00 00 00 	cmp    0xc0(%r9),%ebp
  8c3a7d:	0f 92 c2             	setb   %dl
  8c3a80:	e9 38 05 00 00       	jmp    8c3fbd <check_lower_drain+0x201d>
  8c3a85:	41 83 bf f0 00 00 00 	cmpl   $0x0,0xf0(%r15)
  8c3a8c:	00 
  8c3a8d:	0f 85 f7 20 00 00    	jne    8c5b8a <check_lower_drain+0x3bea>
  8c3a93:	41 c7 87 f0 00 00 00 	movl   $0x3,0xf0(%r15)
  8c3a9a:	03 00 00 00 
  8c3a9e:	41 8b 85 64 01 00 00 	mov    0x164(%r13),%eax
  8c3aa5:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  8c3aa9:	48 ff c5             	inc    %rbp
  8c3aac:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c3ab2:	e9 49 e5 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c3ab7:	4c 89 ef             	mov    %r13,%rdi
  8c3aba:	48 89 c6             	mov    %rax,%rsi
  8c3abd:	44 89 f2             	mov    %r14d,%edx
  8c3ac0:	c5 f8 77             	vzeroupper
  8c3ac3:	e8 a8 96 01 00       	call   8dd170 <check_lower_floating_recipe>
  8c3ac8:	e9 33 e5 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c3acd:	31 c9                	xor    %ecx,%ecx
  8c3acf:	39 c2                	cmp    %eax,%edx
  8c3ad1:	73 0a                	jae    8c3add <check_lower_drain+0x1b3d>
  8c3ad3:	49 8b bd a0 01 00 00 	mov    0x1a0(%r13),%rdi
  8c3ada:	32 0c 17             	xor    (%rdi,%rdx,1),%cl
  8c3add:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  8c3ae1:	84 db                	test   %bl,%bl
  8c3ae3:	41 0f 95 c0          	setne  %r8b
  8c3ae7:	41 20 c8             	and    %cl,%r8b
  8c3aea:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
  8c3aee:	41 80 fc 0e          	cmp    $0xe,%r12b
  8c3af2:	0f 87 8c 00 00 00    	ja     8c3b84 <check_lower_drain+0x1be4>
  8c3af8:	80 fb 0e             	cmp    $0xe,%bl
  8c3afb:	0f 87 83 00 00 00    	ja     8c3b84 <check_lower_drain+0x1be4>
  8c3b01:	45 84 c0             	test   %r8b,%r8b
  8c3b04:	75 7e                	jne    8c3b84 <check_lower_drain+0x1be4>
  8c3b06:	84 db                	test   %bl,%bl
  8c3b08:	0f 84 11 08 00 00    	je     8c431f <check_lower_drain+0x237f>
  8c3b0e:	39 c2                	cmp    %eax,%edx
  8c3b10:	73 11                	jae    8c3b23 <check_lower_drain+0x1b83>
  8c3b12:	49 8b 85 a0 01 00 00 	mov    0x1a0(%r13),%rax
  8c3b19:	f6 04 10 10          	testb  $0x10,(%rax,%rdx,1)
  8c3b1d:	0f 85 fc 09 00 00    	jne    8c451f <check_lower_drain+0x257f>
  8c3b23:	44 89 e0             	mov    %r12d,%eax
  8c3b26:	48 89 6c 24 60       	mov    %rbp,0x60(%rsp)
  8c3b2b:	24 0e                	and    $0xe,%al
  8c3b2d:	3c 0c                	cmp    $0xc,%al
  8c3b2f:	0f 85 4d 09 00 00    	jne    8c4482 <check_lower_drain+0x24e2>
  8c3b35:	8d 43 f7             	lea    -0x9(%rbx),%eax
  8c3b38:	3c 02                	cmp    $0x2,%al
  8c3b3a:	0f 87 42 09 00 00    	ja     8c4482 <check_lower_drain+0x24e2>
  8c3b40:	31 c0                	xor    %eax,%eax
  8c3b42:	41 80 fc 0c          	cmp    $0xc,%r12b
  8c3b46:	41 0f b6 ec          	movzbl %r12b,%ebp
  8c3b4a:	4c 89 ef             	mov    %r13,%rdi
  8c3b4d:	0f 95 c0             	setne  %al
  8c3b50:	89 ee                	mov    %ebp,%esi
  8c3b52:	8d 04 c5 70 00 00 00 	lea    0x70(,%rax,8),%eax
  8c3b59:	89 84 24 b0 00 00 00 	mov    %eax,0xb0(%rsp)
  8c3b60:	c5 f8 77             	vzeroupper
  8c3b63:	e8 b8 a9 ff ff       	call   8be520 <check_lower_temporary>
  8c3b68:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  8c3b6c:	41 89 c6             	mov    %eax,%r14d
  8c3b6f:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c3b76:	0f 84 3f 0f 00 00    	je     8c4abb <check_lower_drain+0x2b1b>
  8c3b7c:	45 31 ff             	xor    %r15d,%r15d
  8c3b7f:	e9 8d 0f 00 00       	jmp    8c4b11 <check_lower_drain+0x2b71>
  8c3b84:	48 8d 05 c3 81 d2 ff 	lea    -0x2d7e3d(%rip),%rax        # 5ebd4e <parse_test_openers+0x1fa11>
  8c3b8b:	45 84 c0             	test   %r8b,%r8b
  8c3b8e:	75 13                	jne    8c3ba3 <check_lower_drain+0x1c03>
  8c3b90:	41 80 fc 0f          	cmp    $0xf,%r12b
  8c3b94:	44 0f 43 f6          	cmovae %esi,%r14d
  8c3b98:	44 89 f6             	mov    %r14d,%esi
  8c3b9b:	c5 f8 77             	vzeroupper
  8c3b9e:	e8 ad a8 ff ff       	call   8be450 <check_lower_type_feature>
  8c3ba3:	41 83 bf f0 00 00 00 	cmpl   $0x0,0xf0(%r15)
  8c3baa:	00 
  8c3bab:	0f 85 4f e4 ff ff    	jne    8c2000 <check_lower_drain+0x60>
  8c3bb1:	49 89 87 00 01 00 00 	mov    %rax,0x100(%r15)
  8c3bb8:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c3bbc:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3bc3:	0f 85 37 e4 ff ff    	jne    8c2000 <check_lower_drain+0x60>
  8c3bc9:	e9 f9 e6 ff ff       	jmp    8c22c7 <check_lower_drain+0x327>
  8c3bce:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c3bd3:	49 89 f6             	mov    %rsi,%r14
  8c3bd6:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  8c3bdb:	31 d2                	xor    %edx,%edx
  8c3bdd:	41 83 fb 03          	cmp    $0x3,%r11d
  8c3be1:	0f 94 c2             	sete   %dl
  8c3be4:	48 89 df             	mov    %rbx,%rdi
  8c3be7:	49 89 f7             	mov    %rsi,%r15
  8c3bea:	c5 f8 77             	vzeroupper
  8c3bed:	e8 2e c1 00 00       	call   8cfd20 <check_lower_truth>
  8c3bf2:	48 89 df             	mov    %rbx,%rdi
  8c3bf5:	44 89 f6             	mov    %r14d,%esi
  8c3bf8:	31 d2                	xor    %edx,%edx
  8c3bfa:	31 c9                	xor    %ecx,%ecx
  8c3bfc:	45 89 f8             	mov    %r15d,%r8d
  8c3bff:	e8 cc be 00 00       	call   8cfad0 <check_lower_operand>
  8c3c04:	e9 77 1f 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c3c09:	4c 89 ef             	mov    %r13,%rdi
  8c3c0c:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c3c11:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  8c3c16:	49 89 d6             	mov    %rdx,%r14
  8c3c19:	4c 89 64 24 48       	mov    %r12,0x48(%rsp)
  8c3c1e:	4c 89 54 24 30       	mov    %r10,0x30(%rsp)
  8c3c23:	4c 89 4c 24 68       	mov    %r9,0x68(%rsp)
  8c3c28:	4d 89 dd             	mov    %r11,%r13
  8c3c2b:	c5 f8 77             	vzeroupper
  8c3c2e:	e8 bd ac fe ff       	call   8ae8f0 <check_lower_complex_element>
  8c3c33:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c3c38:	c1 e8 03             	shr    $0x3,%eax
  8c3c3b:	b1 ff                	mov    $0xff,%cl
  8c3c3d:	3b 44 24 50          	cmp    0x50(%rsp),%eax
  8c3c41:	73 0c                	jae    8c3c4f <check_lower_drain+0x1caf>
  8c3c43:	49 8b 8c 24 98 01 00 	mov    0x198(%r12),%rcx
  8c3c4a:	00 
  8c3c4b:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c3c4f:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c3c54:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c3c59:	4c 89 ef             	mov    %r13,%rdi
  8c3c5c:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8c3c60:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8c3c64:	48 c1 e0 05          	shl    $0x5,%rax
  8c3c68:	8b 34 02             	mov    (%rdx,%rax,1),%esi
  8c3c6b:	89 c8                	mov    %ecx,%eax
  8c3c6d:	c1 ee 03             	shr    $0x3,%esi
  8c3c70:	3b 74 24 50          	cmp    0x50(%rsp),%esi
  8c3c74:	73 10                	jae    8c3c86 <check_lower_drain+0x1ce6>
  8c3c76:	41 f6 04 36 02       	testb  $0x2,(%r14,%rsi,1)
  8c3c7b:	0f b6 c1             	movzbl %cl,%eax
  8c3c7e:	be 08 00 00 00       	mov    $0x8,%esi
  8c3c83:	0f 45 c6             	cmovne %esi,%eax
  8c3c86:	83 ff 02             	cmp    $0x2,%edi
  8c3c89:	74 2a                	je     8c3cb5 <check_lower_drain+0x1d15>
  8c3c8b:	83 ff 04             	cmp    $0x4,%edi
  8c3c8e:	74 25                	je     8c3cb5 <check_lower_drain+0x1d15>
  8c3c90:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
  8c3c97:	00 
  8c3c98:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  8c3c9c:	48 c1 e6 05          	shl    $0x5,%rsi
  8c3ca0:	8b 14 32             	mov    (%rdx,%rsi,1),%edx
  8c3ca3:	c1 ea 03             	shr    $0x3,%edx
  8c3ca6:	3b 54 24 50          	cmp    0x50(%rsp),%edx
  8c3caa:	73 09                	jae    8c3cb5 <check_lower_drain+0x1d15>
  8c3cac:	41 f6 04 16 02       	testb  $0x2,(%r14,%rdx,1)
  8c3cb1:	b3 08                	mov    $0x8,%bl
  8c3cb3:	75 02                	jne    8c3cb7 <check_lower_drain+0x1d17>
  8c3cb5:	89 cb                	mov    %ecx,%ebx
  8c3cb7:	0f b6 e8             	movzbl %al,%ebp
  8c3cba:	4c 89 e7             	mov    %r12,%rdi
  8c3cbd:	89 ee                	mov    %ebp,%esi
  8c3cbf:	e8 5c a8 ff ff       	call   8be520 <check_lower_temporary>
  8c3cc4:	4c 89 ea             	mov    %r13,%rdx
  8c3cc7:	89 c1                	mov    %eax,%ecx
  8c3cc9:	83 fa 02             	cmp    $0x2,%edx
  8c3ccc:	74 18                	je     8c3ce6 <check_lower_drain+0x1d46>
  8c3cce:	83 fa 04             	cmp    $0x4,%edx
  8c3cd1:	74 13                	je     8c3ce6 <check_lower_drain+0x1d46>
  8c3cd3:	0f b6 f3             	movzbl %bl,%esi
  8c3cd6:	4c 89 e7             	mov    %r12,%rdi
  8c3cd9:	41 89 c6             	mov    %eax,%r14d
  8c3cdc:	e8 3f a8 ff ff       	call   8be520 <check_lower_temporary>
  8c3ce1:	89 c1                	mov    %eax,%ecx
  8c3ce3:	44 89 f0             	mov    %r14d,%eax
  8c3ce6:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c3ceb:	41 89 c7             	mov    %eax,%r15d
  8c3cee:	41 89 ce             	mov    %ecx,%r14d
  8c3cf1:	4c 89 f0             	mov    %r14,%rax
  8c3cf4:	48 c1 e0 20          	shl    $0x20,%rax
  8c3cf8:	c7 84 24 c0 01 00 00 	movl   $0x14,0x1c0(%rsp)
  8c3cff:	14 00 00 00 
  8c3d03:	4c 89 e7             	mov    %r12,%rdi
  8c3d06:	4c 09 f8             	or     %r15,%rax
  8c3d09:	89 94 24 c4 01 00 00 	mov    %edx,0x1c4(%rsp)
  8c3d10:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
  8c3d17:	00 00 00 00 00 
  8c3d1c:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  8c3d23:	00 
  8c3d24:	48 c7 84 24 d8 01 00 	movq   $0x0,0x1d8(%rsp)
  8c3d2b:	00 00 00 00 00 
  8c3d30:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c3d37:	00 00 
  8c3d39:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c3d3e:	c5 f8 77             	vzeroupper
  8c3d41:	e8 7a 65 00 00       	call   8ca2c0 <check_lower_push>
  8c3d46:	41 83 fd 02          	cmp    $0x2,%r13d
  8c3d4a:	74 59                	je     8c3da5 <check_lower_drain+0x1e05>
  8c3d4c:	41 83 fd 04          	cmp    $0x4,%r13d
  8c3d50:	74 53                	je     8c3da5 <check_lower_drain+0x1e05>
  8c3d52:	0f b6 d3             	movzbl %bl,%edx
  8c3d55:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c3d5a:	4c 89 e7             	mov    %r12,%rdi
  8c3d5d:	4c 89 f1             	mov    %r14,%rcx
  8c3d60:	e8 ab 27 00 00       	call   8c6510 <check_lower_instruction>
  8c3d65:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c3d6a:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  8c3d71:	00 
  8c3d72:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  8c3d77:	4c 89 e7             	mov    %r12,%rdi
  8c3d7a:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c3d7e:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c3d82:	48 c1 e1 05          	shl    $0x5,%rcx
  8c3d86:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c3d89:	e8 a2 f9 00 00       	call   8d3730 <check_lower_complex_target>
  8c3d8e:	ba 01 00 00 00       	mov    $0x1,%edx
  8c3d93:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c3d98:	4c 89 e7             	mov    %r12,%rdi
  8c3d9b:	31 c9                	xor    %ecx,%ecx
  8c3d9d:	41 89 c0             	mov    %eax,%r8d
  8c3da0:	e8 2b bd 00 00       	call   8cfad0 <check_lower_operand>
  8c3da5:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c3daa:	4c 89 e7             	mov    %r12,%rdi
  8c3dad:	89 ea                	mov    %ebp,%edx
  8c3daf:	4c 89 f9             	mov    %r15,%rcx
  8c3db2:	e8 59 27 00 00       	call   8c6510 <check_lower_instruction>
  8c3db7:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c3dbc:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c3dc1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8c3dc6:	4c 89 e7             	mov    %r12,%rdi
  8c3dc9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c3dcd:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c3dd1:	48 c1 e1 05          	shl    $0x5,%rcx
  8c3dd5:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c3dd8:	e8 53 f9 00 00       	call   8d3730 <check_lower_complex_target>
  8c3ddd:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c3de2:	4c 89 e7             	mov    %r12,%rdi
  8c3de5:	31 d2                	xor    %edx,%edx
  8c3de7:	31 c9                	xor    %ecx,%ecx
  8c3de9:	41 89 c0             	mov    %eax,%r8d
  8c3dec:	e8 df bc 00 00       	call   8cfad0 <check_lower_operand>
  8c3df1:	e9 8a 1d 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c3df6:	44 89 f2             	mov    %r14d,%edx
  8c3df9:	c1 ea 03             	shr    $0x3,%edx
  8c3dfc:	39 c2                	cmp    %eax,%edx
  8c3dfe:	73 19                	jae    8c3e19 <check_lower_drain+0x1e79>
  8c3e00:	89 d2                	mov    %edx,%edx
  8c3e02:	f6 04 17 01          	testb  $0x1,(%rdi,%rdx,1)
  8c3e06:	75 11                	jne    8c3e19 <check_lower_drain+0x1e79>
  8c3e08:	49 8b bd 98 01 00 00 	mov    0x198(%r13),%rdi
  8c3e0f:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  8c3e13:	0f 84 7b e7 ff ff    	je     8c2594 <check_lower_drain+0x5f4>
  8c3e19:	4c 89 ef             	mov    %r13,%rdi
  8c3e1c:	44 89 f2             	mov    %r14d,%edx
  8c3e1f:	c5 f8 77             	vzeroupper
  8c3e22:	e8 29 40 01 00       	call   8d7e50 <check_lower_complex_conversion>
  8c3e27:	e9 d4 e1 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c3e2c:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c3e31:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8c3e35:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3e3c:	0f 85 3e 1d 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c3e42:	48 8d 15 51 9a e4 ff 	lea    -0x1b65af(%rip),%rdx        # 70d89a <pp_string_value.meaning+0x59de6>
  8c3e49:	48 89 90 00 01 00 00 	mov    %rdx,0x100(%rax)
  8c3e50:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8c3e54:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3e5b:	0f 85 1f 1d 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c3e61:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c3e68:	00 00 00 
  8c3e6b:	e9 00 1d 00 00       	jmp    8c5b70 <check_lower_drain+0x3bd0>
  8c3e70:	48 8b 8b a0 00 00 00 	mov    0xa0(%rbx),%rcx
  8c3e77:	41 8b 6c 24 70       	mov    0x70(%r12),%ebp
  8c3e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  8c3e81:	46 8b 2c b9          	mov    (%rcx,%r15,4),%r13d
  8c3e85:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c3e8a:	41 83 fd 20          	cmp    $0x20,%r13d
  8c3e8e:	c4 e2 11 f7 c9       	shlx   %r13d,%ecx,%ecx
  8c3e93:	0f 43 ca             	cmovae %edx,%ecx
  8c3e96:	85 e9                	test   %ebp,%ecx
  8c3e98:	0f 84 39 05 00 00    	je     8c43d7 <check_lower_drain+0x2437>
  8c3e9e:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c3ea3:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c3ea7:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c3eae:	0f 85 53 05 00 00    	jne    8c4407 <check_lower_drain+0x2467>
  8c3eb4:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c3eb9:	c7 81 f0 00 00 00 01 	movl   $0x1,0xf0(%rcx)
  8c3ec0:	00 00 00 
  8c3ec3:	8b 8a 64 01 00 00    	mov    0x164(%rdx),%ecx
  8c3ec9:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8c3ecd:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c3ed3:	e9 2f 05 00 00       	jmp    8c4407 <check_lower_drain+0x2467>
  8c3ed8:	41 83 bf f0 00 00 00 	cmpl   $0x0,0xf0(%r15)
  8c3edf:	00 
  8c3ee0:	0f 85 a4 1c 00 00    	jne    8c5b8a <check_lower_drain+0x3bea>
  8c3ee6:	49 8b 55 20          	mov    0x20(%r13),%rdx
  8c3eea:	48 ff c5             	inc    %rbp
  8c3eed:	44 88 1c 02          	mov    %r11b,(%rdx,%rax,1)
  8c3ef1:	49 8b 55 28          	mov    0x28(%r13),%rdx
  8c3ef5:	44 88 14 02          	mov    %r10b,(%rdx,%rax,1)
  8c3ef9:	49 8b 55 30          	mov    0x30(%r13),%rdx
  8c3efd:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c3f01:	ff c0                	inc    %eax
  8c3f03:	41 89 85 38 01 00 00 	mov    %eax,0x138(%r13)
  8c3f0a:	e9 f1 e0 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c3f0f:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c3f15:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c3f1a:	0f 95 c1             	setne  %cl
  8c3f1d:	0a 4c 24 48          	or     0x48(%rsp),%cl
  8c3f21:	75 1c                	jne    8c3f3f <check_lower_drain+0x1f9f>
  8c3f23:	0f b6 54 24 70       	movzbl 0x70(%rsp),%edx
  8c3f28:	be 0a 00 00 00       	mov    $0xa,%esi
  8c3f2d:	48 89 df             	mov    %rbx,%rdi
  8c3f30:	31 c9                	xor    %ecx,%ecx
  8c3f32:	e8 d9 25 00 00       	call   8c6510 <check_lower_instruction>
  8c3f37:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  8c3f3e:	00 
  8c3f3f:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c3f44:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
  8c3f49:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8c3f4e:	48 83 f8 08          	cmp    $0x8,%rax
  8c3f52:	0f 82 67 04 00 00    	jb     8c43bf <check_lower_drain+0x241f>
  8c3f58:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c3f5e:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c3f64:	0f 83 cf 03 00 00    	jae    8c4339 <check_lower_drain+0x2399>
  8c3f6a:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c3f6e:	8d 79 01             	lea    0x1(%rcx),%edi
  8c3f71:	48 c1 e1 04          	shl    $0x4,%rcx
  8c3f75:	89 bb 3c 01 00 00    	mov    %edi,0x13c(%rbx)
  8c3f7b:	48 bf 01 00 00 00 01 	movabs $0x8000100000001,%rdi
  8c3f82:	00 08 00 
  8c3f85:	48 83 c7 14          	add    $0x14,%rdi
  8c3f89:	48 89 3c 0a          	mov    %rdi,(%rdx,%rcx,1)
  8c3f8d:	48 c7 44 0a 08 01 00 	movq   $0x1,0x8(%rdx,%rcx,1)
  8c3f94:	00 00 
  8c3f96:	e9 c5 03 00 00       	jmp    8c4360 <check_lower_drain+0x23c0>
  8c3f9b:	83 f9 10             	cmp    $0x10,%ecx
  8c3f9e:	0f 85 8c f5 ff ff    	jne    8c3530 <check_lower_drain+0x1590>
  8c3fa4:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c3fa9:	c1 e9 03             	shr    $0x3,%ecx
  8c3fac:	3b 4c 24 50          	cmp    0x50(%rsp),%ecx
  8c3fb0:	0f 82 62 f5 ff ff    	jb     8c3518 <check_lower_drain+0x1578>
  8c3fb6:	e9 75 f5 ff ff       	jmp    8c3530 <check_lower_drain+0x1590>
  8c3fbb:	31 d2                	xor    %edx,%edx
  8c3fbd:	c4 c1 79 7e c0       	vmovd  %xmm0,%r8d
  8c3fc2:	45 0f b6 f0          	movzbl %r8b,%r14d
  8c3fc6:	45 8d 66 ff          	lea    -0x1(%r14),%r12d
  8c3fca:	4c 89 74 24 70       	mov    %r14,0x70(%rsp)
  8c3fcf:	41 83 fc 0a          	cmp    $0xa,%r12d
  8c3fd3:	41 0f 93 c7          	setae  %r15b
  8c3fd7:	41 f7 c0 00 05 00 00 	test   $0x500,%r8d
  8c3fde:	41 0f 95 c5          	setne  %r13b
  8c3fe2:	45 08 fd             	or     %r15b,%r13b
  8c3fe5:	0f 85 55 e8 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3feb:	4d 01 d3             	add    %r10,%r11
  8c3fee:	41 83 7b 44 00       	cmpl   $0x0,0x44(%r11)
  8c3ff3:	0f 85 47 e8 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c3ff9:	4d 8b 31             	mov    (%r9),%r14
  8c3ffc:	4d 8b 3e             	mov    (%r14),%r15
  8c3fff:	4c 89 74 24 68       	mov    %r14,0x68(%rsp)
  8c4004:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  8c4009:	47 8b 34 b7          	mov    (%r15,%r14,4),%r14d
  8c400d:	4c 89 bc 24 88 00 00 	mov    %r15,0x88(%rsp)
  8c4014:	00 
  8c4015:	45 85 f6             	test   %r14d,%r14d
  8c4018:	41 0f 94 c7          	sete   %r15b
  8c401c:	41 20 d7             	and    %dl,%r15b
  8c401f:	41 80 ff 01          	cmp    $0x1,%r15b
  8c4023:	75 2e                	jne    8c4053 <check_lower_drain+0x20b3>
  8c4025:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  8c402a:	44 8d 6d ff          	lea    -0x1(%rbp),%r13d
  8c402e:	4d 8b bf 90 02 00 00 	mov    0x290(%r15),%r15
  8c4035:	43 80 3c 2f 00       	cmpb   $0x0,(%r15,%r13,1)
  8c403a:	74 17                	je     8c4053 <check_lower_drain+0x20b3>
  8c403c:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  8c4041:	4d 8b bf 78 02 00 00 	mov    0x278(%r15),%r15
  8c4048:	43 80 3c 2f 00       	cmpb   $0x0,(%r15,%r13,1)
  8c404d:	0f 84 ed e7 ff ff    	je     8c2840 <check_lower_drain+0x8a0>
  8c4053:	45 8b 6b 0c          	mov    0xc(%r11),%r13d
  8c4057:	45 85 ed             	test   %r13d,%r13d
  8c405a:	74 1f                	je     8c407b <check_lower_drain+0x20db>
  8c405c:	41 83 7b 54 00       	cmpl   $0x0,0x54(%r11)
  8c4061:	75 18                	jne    8c407b <check_lower_drain+0x20db>
  8c4063:	41 0f b7 73 08       	movzwl 0x8(%r11),%esi
  8c4068:	f7 c6 10 08 00 00    	test   $0x810,%esi
  8c406e:	75 0b                	jne    8c407b <check_lower_drain+0x20db>
  8c4070:	41 83 7b 04 00       	cmpl   $0x0,0x4(%r11)
  8c4075:	0f 84 a6 17 00 00    	je     8c5821 <check_lower_drain+0x3881>
  8c407b:	48 89 de             	mov    %rbx,%rsi
  8c407e:	45 85 f6             	test   %r14d,%r14d
  8c4081:	0f 85 b9 e7 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c4087:	41 83 7b 04 01       	cmpl   $0x1,0x4(%r11)
  8c408c:	41 0f 94 c0          	sete   %r8b
  8c4090:	41 20 d0             	and    %dl,%r8b
  8c4093:	41 80 f8 01          	cmp    $0x1,%r8b
  8c4097:	0f 85 a3 e7 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c409d:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c40a2:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  8c40a6:	44 8b 34 aa          	mov    (%rdx,%rbp,4),%r14d
  8c40aa:	49 8b 91 80 00 00 00 	mov    0x80(%r9),%rdx
  8c40b1:	8b 34 aa             	mov    (%rdx,%rbp,4),%esi
  8c40b4:	85 f6                	test   %esi,%esi
  8c40b6:	0f 94 c2             	sete   %dl
  8c40b9:	45 31 c0             	xor    %r8d,%r8d
  8c40bc:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  8c40c0:	41 0f 94 c0          	sete   %r8b
  8c40c4:	44 0f 44 f6          	cmove  %esi,%r14d
  8c40c8:	43 8d 74 00 02       	lea    0x2(%r8,%r8,1),%esi
  8c40cd:	44 20 c2             	and    %r8b,%dl
  8c40d0:	89 74 24 30          	mov    %esi,0x30(%rsp)
  8c40d4:	8b 74 24 58          	mov    0x58(%rsp),%esi
  8c40d8:	40 08 d6             	or     %dl,%sil
  8c40db:	0f 84 3a 13 00 00    	je     8c541b <check_lower_drain+0x347b>
  8c40e1:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8c40e6:	48 89 de             	mov    %rbx,%rsi
  8c40e9:	84 d2                	test   %dl,%dl
  8c40eb:	0f 85 4f e7 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c40f1:	45 31 d2             	xor    %r10d,%r10d
  8c40f4:	45 31 c0             	xor    %r8d,%r8d
  8c40f7:	44 8b 5c 24 30       	mov    0x30(%rsp),%r11d
  8c40fc:	c1 ef 10             	shr    $0x10,%edi
  8c40ff:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4104:	c4 c1 f9 6e ce       	vmovq  %r14,%xmm1
  8c4109:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
  8c410e:	40 0f b6 d7          	movzbl %dil,%edx
  8c4112:	bf 00 00 00 00       	mov    $0x0,%edi
  8c4117:	89 d6                	mov    %edx,%esi
  8c4119:	c1 e6 10             	shl    $0x10,%esi
  8c411c:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8c4122:	0f 44 f7             	cmove  %edi,%esi
  8c4125:	0f 95 c2             	setne  %dl
  8c4128:	c1 e1 08             	shl    $0x8,%ecx
  8c412b:	0f b7 c9             	movzwl %cx,%ecx
  8c412e:	41 09 f3             	or     %esi,%r11d
  8c4131:	45 09 d3             	or     %r10d,%r11d
  8c4134:	83 7c 24 48 10       	cmpl   $0x10,0x48(%rsp)
  8c4139:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
  8c413e:	40 0f 92 c6          	setb   %sil
  8c4142:	0f 43 cf             	cmovae %edi,%ecx
  8c4145:	c1 e0 10             	shl    $0x10,%eax
  8c4148:	c0 e2 02             	shl    $0x2,%dl
  8c414b:	40 00 f6             	add    %sil,%sil
  8c414e:	09 c8                	or     %ecx,%eax
  8c4150:	49 8b 4d 20          	mov    0x20(%r13),%rcx
  8c4154:	03 44 24 70          	add    0x70(%rsp),%eax
  8c4158:	40 08 f2             	or     %sil,%dl
  8c415b:	41 8b b5 38 01 00 00 	mov    0x138(%r13),%esi
  8c4162:	fe c2                	inc    %dl
  8c4164:	c5 fb 92 ca          	kmovd  %edx,%k1
  8c4168:	c5 f9 90 d1          	kmovb  %k1,%k2
  8c416c:	62 f2 7d 0a 63 04 31 	vpcompressb %xmm0,(%rcx,%rsi,1){%k2}
  8c4173:	c5 f9 6e c0          	vmovd  %eax,%xmm0
  8c4177:	0f b6 c2             	movzbl %dl,%eax
  8c417a:	49 8b 4d 28          	mov    0x28(%r13),%rcx
  8c417e:	41 8b b5 38 01 00 00 	mov    0x138(%r13),%esi
  8c4185:	f3 0f b8 c0          	popcnt %eax,%eax
  8c4189:	62 f2 7d 0a 63 04 31 	vpcompressb %xmm0,(%rcx,%rsi,1){%k2}
  8c4190:	c4 c1 f9 6e c0       	vmovq  %r8,%xmm0
  8c4195:	49 8b 4d 30          	mov    0x30(%r13),%rcx
  8c4199:	41 8b 95 38 01 00 00 	mov    0x138(%r13),%edx
  8c41a0:	c5 f1 6c c0          	vpunpcklqdq %xmm0,%xmm1,%xmm0
  8c41a4:	62 f2 fd 49 8b 04 d1 	vpcompressq %zmm0,(%rcx,%rdx,8){%k1}
  8c41ab:	41 01 85 38 01 00 00 	add    %eax,0x138(%r13)
  8c41b2:	8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%ecx
  8c41b9:	49 8b 41 08          	mov    0x8(%r9),%rax
  8c41bd:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c41c0:	41 89 85 64 01 00 00 	mov    %eax,0x164(%r13)
  8c41c7:	8b 44 24 78          	mov    0x78(%rsp),%eax
  8c41cb:	62 f2 fd 08 7c c0    	vpbroadcastq %rax,%xmm0
  8c41d1:	c4 c1 79 d4 85 00 02 	vpaddq 0x200(%r13),%xmm0,%xmm0
  8c41d8:	00 00 
  8c41da:	c4 c1 7a 7f 85 00 02 	vmovdqu %xmm0,0x200(%r13)
  8c41e1:	00 00 
  8c41e3:	e9 18 de ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c41e8:	41 83 fc 01          	cmp    $0x1,%r12d
  8c41ec:	0f 85 fb e4 ff ff    	jne    8c26ed <check_lower_drain+0x74d>
  8c41f2:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  8c41f6:	41 b3 01             	mov    $0x1,%r11b
  8c41f9:	41 83 fe 06          	cmp    $0x6,%r14d
  8c41fd:	0f 87 20 08 00 00    	ja     8c4a23 <check_lower_drain+0x2a83>
  8c4203:	d1 eb                	shr    $1,%ebx
  8c4205:	b8 08 00 00 00       	mov    $0x8,%eax
  8c420a:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  8c4211:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4216:	c4 e2 61 f7 c0       	shlx   %ebx,%eax,%eax
  8c421b:	c4 e2 f8 f5 f1       	bzhi   %rax,%rcx,%rsi
  8c4220:	c4 e2 f9 f7 d2       	shlx   %rax,%rdx,%rdx
  8c4225:	ff c8                	dec    %eax
  8c4227:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c422c:	c4 e2 fb f7 c6       	shrx   %rax,%rsi,%rax
  8c4231:	48 85 c0             	test   %rax,%rax
  8c4234:	48 0f 44 d0          	cmove  %rax,%rdx
  8c4238:	41 f6 c2 01          	test   $0x1,%r10b
  8c423c:	48 0f 45 ca          	cmovne %rdx,%rcx
  8c4240:	48 09 f1             	or     %rsi,%rcx
  8c4243:	e9 96 e2 ff ff       	jmp    8c24de <check_lower_drain+0x53e>
  8c4248:	31 c9                	xor    %ecx,%ecx
  8c424a:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c4250:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c4255:	48 b8 00 00 00 00 00 	movabs $0x40000000000,%rax
  8c425c:	04 00 00 
  8c425f:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4264:	49 89 f6             	mov    %rsi,%r14
  8c4267:	0f 95 c1             	setne  %cl
  8c426a:	48 85 c6             	test   %rax,%rsi
  8c426d:	48 89 df             	mov    %rbx,%rdi
  8c4270:	44 0f 45 c2          	cmovne %edx,%r8d
  8c4274:	ba 01 00 00 00       	mov    $0x1,%edx
  8c4279:	c5 f8 77             	vzeroupper
  8c427c:	e8 4f b8 00 00       	call   8cfad0 <check_lower_operand>
  8c4281:	48 89 df             	mov    %rbx,%rdi
  8c4284:	44 89 f6             	mov    %r14d,%esi
  8c4287:	e9 2e ec ff ff       	jmp    8c2eba <check_lower_drain+0xf1a>
  8c428c:	41 8d 4b eb          	lea    -0x15(%r11),%ecx
  8c4290:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  8c4295:	4c 89 4c 24 68       	mov    %r9,0x68(%rsp)
  8c429a:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c429f:	83 f9 02             	cmp    $0x2,%ecx
  8c42a2:	0f 87 46 02 00 00    	ja     8c44ee <check_lower_drain+0x254e>
  8c42a8:	44 89 d1             	mov    %r10d,%ecx
  8c42ab:	33 8c 24 80 00 00 00 	xor    0x80(%rsp),%ecx
  8c42b2:	44 89 d8             	mov    %r11d,%eax
  8c42b5:	83 f0 17             	xor    $0x17,%eax
  8c42b8:	4d 89 dd             	mov    %r11,%r13
  8c42bb:	c6 84 24 c0 01 00 00 	movb   $0x0,0x1c0(%rsp)
  8c42c2:	00 
  8c42c3:	48 89 eb             	mov    %rbp,%rbx
  8c42c6:	48 89 ef             	mov    %rbp,%rdi
  8c42c9:	4c 89 54 24 30       	mov    %r10,0x30(%rsp)
  8c42ce:	44 89 d2             	mov    %r10d,%edx
  8c42d1:	09 c1                	or     %eax,%ecx
  8c42d3:	48 8d 8c 24 c0 01 00 	lea    0x1c0(%rsp),%rcx
  8c42da:	00 
  8c42db:	0f 94 44 24 48       	sete   0x48(%rsp)
  8c42e0:	c5 f8 77             	vzeroupper
  8c42e3:	e8 88 82 fc ff       	call   88c570 <check_program_runtime_truth>
  8c42e8:	84 c0                	test   %al,%al
  8c42ea:	0f 84 58 07 00 00    	je     8c4a48 <check_lower_drain+0x2aa8>
  8c42f0:	41 83 fd 17          	cmp    $0x17,%r13d
  8c42f4:	0f 85 77 0a 00 00    	jne    8c4d71 <check_lower_drain+0x2dd1>
  8c42fa:	44 0f b6 bc 24 c0 01 	movzbl 0x1c0(%rsp),%r15d
  8c4301:	00 00 
  8c4303:	45 8b 06             	mov    (%r14),%r8d
  8c4306:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c430b:	ba 02 00 00 00       	mov    $0x2,%edx
  8c4310:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c4315:	31 c9                	xor    %ecx,%ecx
  8c4317:	44 29 fa             	sub    %r15d,%edx
  8c431a:	e9 3e 0e 00 00       	jmp    8c515d <check_lower_drain+0x31bd>
  8c431f:	45 84 e4             	test   %r12b,%r12b
  8c4322:	0f 84 d8 dc ff ff    	je     8c2000 <check_lower_drain+0x60>
  8c4328:	41 0f b6 d4          	movzbl %r12b,%edx
  8c432c:	be 23 00 00 00       	mov    $0x23,%esi
  8c4331:	4c 89 ef             	mov    %r13,%rdi
  8c4334:	e9 47 02 00 00       	jmp    8c4580 <check_lower_drain+0x25e0>
  8c4339:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c433d:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4344:	75 1a                	jne    8c4360 <check_lower_drain+0x23c0>
  8c4346:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c434d:	00 00 00 
  8c4350:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c4356:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c435a:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c4360:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c4366:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c436c:	73 2a                	jae    8c4398 <check_lower_drain+0x23f8>
  8c436e:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c4372:	8d 79 01             	lea    0x1(%rcx),%edi
  8c4375:	48 c1 e8 03          	shr    $0x3,%rax
  8c4379:	48 c1 e1 04          	shl    $0x4,%rcx
  8c437d:	89 bb 3c 01 00 00    	mov    %edi,0x13c(%rbx)
  8c4383:	48 bf 01 00 00 00 01 	movabs $0x8000100000001,%rdi
  8c438a:	00 08 00 
  8c438d:	48 89 3c 0a          	mov    %rdi,(%rdx,%rcx,1)
  8c4391:	48 89 44 0a 08       	mov    %rax,0x8(%rdx,%rcx,1)
  8c4396:	eb 27                	jmp    8c43bf <check_lower_drain+0x241f>
  8c4398:	48 8b 43 08          	mov    0x8(%rbx),%rax
  8c439c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c43a3:	75 1a                	jne    8c43bf <check_lower_drain+0x241f>
  8c43a5:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c43ac:	00 00 00 
  8c43af:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c43b5:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c43b9:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c43bf:	31 c9                	xor    %ecx,%ecx
  8c43c1:	41 83 f9 20          	cmp    $0x20,%r9d
  8c43c5:	48 89 df             	mov    %rbx,%rdi
  8c43c8:	0f 94 c1             	sete   %cl
  8c43cb:	31 d2                	xor    %edx,%edx
  8c43cd:	e8 fe b6 00 00       	call   8cfad0 <check_lower_operand>
  8c43d2:	e9 a9 17 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c43d7:	48 8b 4b 38          	mov    0x38(%rbx),%rcx
  8c43db:	42 81 3c b9 30 01 00 	cmpl   $0x130,(%rcx,%r15,4)
  8c43e2:	00 
  8c43e3:	75 22                	jne    8c4407 <check_lower_drain+0x2467>
  8c43e5:	31 c9                	xor    %ecx,%ecx
  8c43e7:	41 83 bc 24 8c 00 00 	cmpl   $0x2,0x8c(%r12)
  8c43ee:	00 02 
  8c43f0:	0f 94 c2             	sete   %dl
  8c43f3:	41 83 fd 01          	cmp    $0x1,%r13d
  8c43f7:	0f 85 a1 fa ff ff    	jne    8c3e9e <check_lower_drain+0x1efe>
  8c43fd:	88 d1                	mov    %dl,%cl
  8c43ff:	39 cd                	cmp    %ecx,%ebp
  8c4401:	0f 85 97 fa ff ff    	jne    8c3e9e <check_lower_drain+0x1efe>
  8c4407:	48 8d 8c 24 c2 00 00 	lea    0xc2(%rsp),%rcx
  8c440e:	00 
  8c440f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c4413:	c5 fa 7f 41 f6       	vmovdqu %xmm0,-0xa(%rcx)
  8c4418:	48 c7 41 06 00 00 00 	movq   $0x0,0x6(%rcx)
  8c441f:	00 
  8c4420:	c7 84 24 b0 00 00 00 	movl   $0xb,0xb0(%rsp)
  8c4427:	0b 00 00 00 
  8c442b:	89 84 24 b4 00 00 00 	mov    %eax,0xb4(%rsp)
  8c4432:	c5 fe 6f 84 24 b0 00 	vmovdqu 0xb0(%rsp),%ymm0
  8c4439:	00 00 
  8c443b:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c4440:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4445:	c5 f8 77             	vzeroupper
  8c4448:	e8 73 5e 00 00       	call   8ca2c0 <check_lower_push>
  8c444d:	45 85 ed             	test   %r13d,%r13d
  8c4450:	0f 84 2a 17 00 00    	je     8c5b80 <check_lower_drain+0x3be0>
  8c4456:	44 89 ea             	mov    %r13d,%edx
  8c4459:	44 8d 6a ff          	lea    -0x1(%rdx),%r13d
  8c445d:	83 fa 20             	cmp    $0x20,%edx
  8c4460:	77 eb                	ja     8c444d <check_lower_drain+0x24ad>
  8c4462:	44 0f a3 ed          	bt     %r13d,%ebp
  8c4466:	73 e5                	jae    8c444d <check_lower_drain+0x24ad>
  8c4468:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c446d:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c4473:	83 c2 02             	add    $0x2,%edx
  8c4476:	44 89 f6             	mov    %r14d,%esi
  8c4479:	31 c9                	xor    %ecx,%ecx
  8c447b:	e8 50 b6 00 00       	call   8cfad0 <check_lower_operand>
  8c4480:	eb cb                	jmp    8c444d <check_lower_drain+0x24ad>
  8c4482:	89 d8                	mov    %ebx,%eax
  8c4484:	24 0e                	and    $0xe,%al
  8c4486:	3c 0c                	cmp    $0xc,%al
  8c4488:	0f 85 9f 05 00 00    	jne    8c4a2d <check_lower_drain+0x2a8d>
  8c448e:	41 8d 44 24 f7       	lea    -0x9(%r12),%eax
  8c4493:	3c 02                	cmp    $0x2,%al
  8c4495:	0f 87 92 05 00 00    	ja     8c4a2d <check_lower_drain+0x2a8d>
  8c449b:	31 c0                	xor    %eax,%eax
  8c449d:	41 80 fc 0a          	cmp    $0xa,%r12b
  8c44a1:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  8c44a6:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c44ab:	0f b6 eb             	movzbl %bl,%ebp
  8c44ae:	0f 95 c0             	setne  %al
  8c44b1:	41 80 fc 09          	cmp    $0x9,%r12b
  8c44b5:	89 ee                	mov    %ebp,%esi
  8c44b7:	8d 04 c5 a0 00 00 00 	lea    0xa0(,%rax,8),%eax
  8c44be:	0f 44 c1             	cmove  %ecx,%eax
  8c44c1:	4c 89 ff             	mov    %r15,%rdi
  8c44c4:	89 84 24 b0 00 00 00 	mov    %eax,0xb0(%rsp)
  8c44cb:	c5 f8 77             	vzeroupper
  8c44ce:	e8 4d a0 ff ff       	call   8be520 <check_lower_temporary>
  8c44d3:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  8c44d7:	41 89 c6             	mov    %eax,%r14d
  8c44da:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c44e1:	0f 84 76 0a 00 00    	je     8c4f5d <check_lower_drain+0x2fbd>
  8c44e7:	31 c9                	xor    %ecx,%ecx
  8c44e9:	e9 b9 0a 00 00       	jmp    8c4fa7 <check_lower_drain+0x3007>
  8c44ee:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
  8c44f3:	41 83 fb 38          	cmp    $0x38,%r11d
  8c44f7:	0f 84 56 06 00 00    	je     8c4b53 <check_lower_drain+0x2bb3>
  8c44fd:	83 7c 24 40 22       	cmpl   $0x22,0x40(%rsp)
  8c4502:	0f 85 62 06 00 00    	jne    8c4b6a <check_lower_drain+0x2bca>
  8c4508:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c450d:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c4512:	c5 f8 77             	vzeroupper
  8c4515:	e8 e6 f3 00 00       	call   8d3900 <check_lower_call>
  8c451a:	e9 61 16 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c451f:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
  8c4524:	3c 03                	cmp    $0x3,%al
  8c4526:	77 1c                	ja     8c4544 <check_lower_drain+0x25a4>
  8c4528:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c452d:	be 09 00 00 00       	mov    $0x9,%esi
  8c4532:	ba 05 00 00 00       	mov    $0x5,%edx
  8c4537:	31 c9                	xor    %ecx,%ecx
  8c4539:	c5 f8 77             	vzeroupper
  8c453c:	e8 7f 1a 00 00       	call   8c5fc0 <check_lower_emit>
  8c4541:	41 b4 05             	mov    $0x5,%r12b
  8c4544:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4549:	41 0f b6 d4          	movzbl %r12b,%edx
  8c454d:	be 01 00 00 00       	mov    $0x1,%esi
  8c4552:	31 c9                	xor    %ecx,%ecx
  8c4554:	4c 89 ef             	mov    %r13,%rdi
  8c4557:	c5 f8 77             	vzeroupper
  8c455a:	e8 61 1a 00 00       	call   8c5fc0 <check_lower_emit>
  8c455f:	be 17 00 00 00       	mov    $0x17,%esi
  8c4564:	ba 05 00 00 00       	mov    $0x5,%edx
  8c4569:	4c 89 ef             	mov    %r13,%rdi
  8c456c:	31 c9                	xor    %ecx,%ecx
  8c456e:	e8 4d 1a 00 00       	call   8c5fc0 <check_lower_emit>
  8c4573:	4c 89 ef             	mov    %r13,%rdi
  8c4576:	be 09 00 00 00       	mov    $0x9,%esi
  8c457b:	ba 02 00 00 00       	mov    $0x2,%edx
  8c4580:	31 c9                	xor    %ecx,%ecx
  8c4582:	c5 f8 77             	vzeroupper
  8c4585:	e8 36 1a 00 00       	call   8c5fc0 <check_lower_emit>
  8c458a:	e9 71 da ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c458f:	48 89 6c 24 60       	mov    %rbp,0x60(%rsp)
  8c4594:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c4599:	4d 85 f6             	test   %r14,%r14
  8c459c:	0f 84 44 09 00 00    	je     8c4ee6 <check_lower_drain+0x2f46>
  8c45a2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c45a9:	01 00 00 
  8c45ac:	48 85 44 24 38       	test   %rax,0x38(%rsp)
  8c45b1:	0f 95 c0             	setne  %al
  8c45b4:	49 81 fe 01 01 00 00 	cmp    $0x101,%r14
  8c45bb:	0f 93 c1             	setae  %cl
  8c45be:	08 c1                	or     %al,%cl
  8c45c0:	0f 84 07 0a 00 00    	je     8c4fcd <check_lower_drain+0x302d>
  8c45c6:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c45cb:	be 08 00 00 00       	mov    $0x8,%esi
  8c45d0:	c5 f8 77             	vzeroupper
  8c45d3:	e8 48 9f ff ff       	call   8be520 <check_lower_temporary>
  8c45d8:	48 b9 00 00 00 00 00 	movabs $0x10000000000,%rcx
  8c45df:	01 00 00 
  8c45e2:	89 c5                	mov    %eax,%ebp
  8c45e4:	48 85 4c 24 38       	test   %rcx,0x38(%rsp)
  8c45e9:	0f 84 17 0d 00 00    	je     8c5306 <check_lower_drain+0x3366>
  8c45ef:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c45f4:	be 08 00 00 00       	mov    $0x8,%esi
  8c45f9:	48 89 df             	mov    %rbx,%rdi
  8c45fc:	e8 1f 9f ff ff       	call   8be520 <check_lower_temporary>
  8c4601:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c4606:	ba 08 00 00 00       	mov    $0x8,%edx
  8c460b:	41 89 ec             	mov    %ebp,%r12d
  8c460e:	41 89 c7             	mov    %eax,%r15d
  8c4611:	48 89 df             	mov    %rbx,%rdi
  8c4614:	4c 89 e1             	mov    %r12,%rcx
  8c4617:	e8 a4 19 00 00       	call   8c5fc0 <check_lower_emit>
  8c461c:	be 1e 00 00 00       	mov    $0x1e,%esi
  8c4621:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4626:	48 89 df             	mov    %rbx,%rdi
  8c4629:	4c 89 f9             	mov    %r15,%rcx
  8c462c:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  8c4631:	e9 ef 0c 00 00       	jmp    8c5325 <check_lower_drain+0x3385>
  8c4636:	4c 89 ef             	mov    %r13,%rdi
  8c4639:	44 89 f2             	mov    %r14d,%edx
  8c463c:	c5 f8 77             	vzeroupper
  8c463f:	e8 ec 93 00 00       	call   8cda30 <check_lower_varargs_emit>
  8c4644:	e9 b7 d9 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c4649:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c464d:	89 f1                	mov    %esi,%ecx
  8c464f:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c4656:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c465a:	48 8b 40 68          	mov    0x68(%rax),%rax
  8c465e:	48 8d 74 08 10       	lea    0x10(%rax,%rcx,1),%rsi
  8c4663:	4c 89 ef             	mov    %r13,%rdi
  8c4666:	c5 f8 77             	vzeroupper
  8c4669:	e8 32 6a 00 00       	call   8cb0a0 <check_lower_constant>
  8c466e:	e9 8d d9 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c4673:	41 8b 9d 74 01 00 00 	mov    0x174(%r13),%ebx
  8c467a:	49 89 ef             	mov    %rbp,%r15
  8c467d:	89 d8                	mov    %ebx,%eax
  8c467f:	85 db                	test   %ebx,%ebx
  8c4681:	0f 84 a6 08 00 00    	je     8c4f2d <check_lower_drain+0x2f8d>
  8c4687:	49 8b 4d 60          	mov    0x60(%r13),%rcx
  8c468b:	41 89 c6             	mov    %eax,%r14d
  8c468e:	be 23 00 00 00       	mov    $0x23,%esi
  8c4693:	4c 89 ef             	mov    %r13,%rdi
  8c4696:	42 0f b6 14 31       	movzbl (%rcx,%r14,1),%edx
  8c469b:	31 c9                	xor    %ecx,%ecx
  8c469d:	c5 f8 77             	vzeroupper
  8c46a0:	e8 1b 19 00 00       	call   8c5fc0 <check_lower_emit>
  8c46a5:	49 8b 45 58          	mov    0x58(%r13),%rax
  8c46a9:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c46ad:	85 c0                	test   %eax,%eax
  8c46af:	75 d6                	jne    8c4687 <check_lower_drain+0x26e7>
  8c46b1:	4c 89 ef             	mov    %r13,%rdi
  8c46b4:	e8 87 69 00 00       	call   8cb040 <check_lower_label>
  8c46b9:	89 c5                	mov    %eax,%ebp
  8c46bb:	4c 89 ef             	mov    %r13,%rdi
  8c46be:	89 c6                	mov    %eax,%esi
  8c46c0:	e8 ab 18 00 00       	call   8c5f70 <check_lower_place>
  8c46c5:	be 26 00 00 00       	mov    $0x26,%esi
  8c46ca:	89 e9                	mov    %ebp,%ecx
  8c46cc:	4c 89 ef             	mov    %r13,%rdi
  8c46cf:	31 d2                	xor    %edx,%edx
  8c46d1:	e8 ea 18 00 00       	call   8c5fc0 <check_lower_emit>
  8c46d6:	49 8b 45 60          	mov    0x60(%r13),%rax
  8c46da:	89 db                	mov    %ebx,%ebx
  8c46dc:	be 01 00 00 00       	mov    $0x1,%esi
  8c46e1:	4c 89 ef             	mov    %r13,%rdi
  8c46e4:	31 c9                	xor    %ecx,%ecx
  8c46e6:	0f b6 14 18          	movzbl (%rax,%rbx,1),%edx
  8c46ea:	e8 21 1e 00 00       	call   8c6510 <check_lower_instruction>
  8c46ef:	49 8b 45 58          	mov    0x58(%r13),%rax
  8c46f3:	8b 1c 98             	mov    (%rax,%rbx,4),%ebx
  8c46f6:	85 db                	test   %ebx,%ebx
  8c46f8:	75 dc                	jne    8c46d6 <check_lower_drain+0x2736>
  8c46fa:	e9 56 08 00 00       	jmp    8c4f55 <check_lower_drain+0x2fb5>
  8c46ff:	4c 89 ef             	mov    %r13,%rdi
  8c4702:	44 89 f6             	mov    %r14d,%esi
  8c4705:	c5 f8 77             	vzeroupper
  8c4708:	e8 83 92 00 00       	call   8cd990 <check_lower_bit_read>
  8c470d:	e9 ee d8 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c4712:	4c 89 ef             	mov    %r13,%rdi
  8c4715:	4c 89 f2             	mov    %r14,%rdx
  8c4718:	c5 f8 77             	vzeroupper
  8c471b:	e8 d0 76 00 00       	call   8cbdf0 <check_lower_address>
  8c4720:	e9 db d8 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c4725:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4729:	89 f1                	mov    %esi,%ecx
  8c472b:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c472f:	44 89 f2             	mov    %r14d,%edx
  8c4732:	48 69 f2 b0 00 00 00 	imul   $0xb0,%rdx,%rsi
  8c4739:	49 c1 ee 20          	shr    $0x20,%r14
  8c473d:	4c 89 ef             	mov    %r13,%rdi
  8c4740:	48 c1 e1 04          	shl    $0x4,%rcx
  8c4744:	48 8b 40 28          	mov    0x28(%rax),%rax
  8c4748:	48 8b 00             	mov    (%rax),%rax
  8c474b:	48 03 74 08 10       	add    0x10(%rax,%rcx,1),%rsi
  8c4750:	eb 4a                	jmp    8c479c <check_lower_drain+0x27fc>
  8c4752:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c4756:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xb0(%rsp)
  8c475d:	b0 00 00 00 
  8c4761:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x120(%rsp)
  8c4768:	20 01 00 00 
  8c476c:	44 89 f0             	mov    %r14d,%eax
  8c476f:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xf0(%rsp)
  8c4776:	f0 00 00 00 
  8c477a:	c7 84 24 b0 00 00 00 	movl   $0x2,0xb0(%rsp)
  8c4781:	02 00 00 00 
  8c4785:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  8c478c:	00 
  8c478d:	49 c1 ee 20          	shr    $0x20,%r14
  8c4791:	4c 89 ef             	mov    %r13,%rdi
  8c4794:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  8c479b:	00 
  8c479c:	44 89 f2             	mov    %r14d,%edx
  8c479f:	c5 f8 77             	vzeroupper
  8c47a2:	e8 b9 82 00 00       	call   8cca60 <check_lower_fill>
  8c47a7:	e9 54 d8 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c47ac:	b8 03 06 00 00       	mov    $0x603,%eax
  8c47b1:	48 89 6c 24 60       	mov    %rbp,0x60(%rsp)
  8c47b6:	44 89 f5             	mov    %r14d,%ebp
  8c47b9:	c1 ed 09             	shr    $0x9,%ebp
  8c47bc:	4c 89 ef             	mov    %r13,%rdi
  8c47bf:	45 89 f5             	mov    %r14d,%r13d
  8c47c2:	41 83 e5 07          	and    $0x7,%r13d
  8c47c6:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  8c47cd:	00 00 00 00 00 
  8c47d2:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c47d7:	be 08 00 00 00       	mov    $0x8,%esi
  8c47dc:	c4 c2 78 f7 ce       	bextr  %eax,%r14d,%ecx
  8c47e1:	44 89 f0             	mov    %r14d,%eax
  8c47e4:	c1 e8 0d             	shr    $0xd,%eax
  8c47e7:	40 80 e5 0f          	and    $0xf,%bpl
  8c47eb:	44 89 ac 24 b8 00 00 	mov    %r13d,0xb8(%rsp)
  8c47f2:	00 
  8c47f3:	44 8d 79 01          	lea    0x1(%rcx),%r15d
  8c47f7:	24 01                	and    $0x1,%al
  8c47f9:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  8c47fe:	48 8d 8c 24 c2 00 00 	lea    0xc2(%rsp),%rcx
  8c4805:	00 
  8c4806:	44 89 bc 24 bc 00 00 	mov    %r15d,0xbc(%rsp)
  8c480d:	00 
  8c480e:	40 88 ac 24 c0 00 00 	mov    %bpl,0xc0(%rsp)
  8c4815:	00 
  8c4816:	88 84 24 c1 00 00 00 	mov    %al,0xc1(%rsp)
  8c481d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  8c4824:	41 83 ff 40          	cmp    $0x40,%r15d
  8c4828:	66 c7 41 04 00 00    	movw   $0x0,0x4(%rcx)
  8c482e:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c4834:	c4 62 81 f7 e0       	shlx   %r15,%rax,%r12
  8c4839:	49 f7 d4             	not    %r12
  8c483c:	4c 89 e3             	mov    %r12,%rbx
  8c483f:	48 0f 44 d8          	cmove  %rax,%rbx
  8c4843:	c5 f8 77             	vzeroupper
  8c4846:	e8 d5 9c ff ff       	call   8be520 <check_lower_temporary>
  8c484b:	89 44 24 50          	mov    %eax,0x50(%rsp)
  8c484f:	40 80 fd 08          	cmp    $0x8,%bpl
  8c4853:	74 16                	je     8c486b <check_lower_drain+0x28cb>
  8c4855:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c485a:	be 09 00 00 00       	mov    $0x9,%esi
  8c485f:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4864:	31 c9                	xor    %ecx,%ecx
  8c4866:	e8 55 17 00 00       	call   8c5fc0 <check_lower_emit>
  8c486b:	41 83 ff 40          	cmp    $0x40,%r15d
  8c486f:	74 2e                	je     8c489f <check_lower_drain+0x28ff>
  8c4871:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  8c4876:	be 01 00 00 00       	mov    $0x1,%esi
  8c487b:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4880:	4c 89 e1             	mov    %r12,%rcx
  8c4883:	4c 89 ff             	mov    %r15,%rdi
  8c4886:	e8 35 17 00 00       	call   8c5fc0 <check_lower_emit>
  8c488b:	be 10 00 00 00       	mov    $0x10,%esi
  8c4890:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4895:	4c 89 ff             	mov    %r15,%rdi
  8c4898:	31 c9                	xor    %ecx,%ecx
  8c489a:	e8 21 17 00 00       	call   8c5fc0 <check_lower_emit>
  8c489f:	4c 89 f0             	mov    %r14,%rax
  8c48a2:	48 c1 e8 20          	shr    $0x20,%rax
  8c48a6:	8b 4c 24 50          	mov    0x50(%rsp),%ecx
  8c48aa:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c48af:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c48b4:	ba 08 00 00 00       	mov    $0x8,%edx
  8c48b9:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8c48be:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c48c3:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  8c48c8:	41 8d 6c 05 08       	lea    0x8(%r13,%rax,1),%ebp
  8c48cd:	c1 ed 03             	shr    $0x3,%ebp
  8c48d0:	f3 44 0f b8 e5       	popcnt %ebp,%r12d
  8c48d5:	e8 e6 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c48da:	41 83 fc 01          	cmp    $0x1,%r12d
  8c48de:	77 19                	ja     8c48f9 <check_lower_drain+0x2959>
  8c48e0:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c48e5:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c48ea:	be 02 00 00 00       	mov    $0x2,%esi
  8c48ef:	ba 08 00 00 00       	mov    $0x8,%edx
  8c48f4:	e8 c7 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c48f9:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  8c48fe:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c4903:	be 02 00 00 00       	mov    $0x2,%esi
  8c4908:	ba 08 00 00 00       	mov    $0x8,%edx
  8c490d:	4c 89 ff             	mov    %r15,%rdi
  8c4910:	e8 ab 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c4915:	4c 89 ff             	mov    %r15,%rdi
  8c4918:	89 ee                	mov    %ebp,%esi
  8c491a:	e8 31 89 01 00       	call   8dd250 <check_lower_bit_unit>
  8c491f:	41 83 e6 07          	and    $0x7,%r14d
  8c4923:	be 01 00 00 00       	mov    $0x1,%esi
  8c4928:	ba 08 00 00 00       	mov    $0x8,%edx
  8c492d:	4c 89 ff             	mov    %r15,%rdi
  8c4930:	c4 e2 89 f7 cb       	shlx   %r14,%rbx,%rcx
  8c4935:	48 f7 d1             	not    %rcx
  8c4938:	e8 83 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c493d:	be 10 00 00 00       	mov    $0x10,%esi
  8c4942:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4947:	4c 89 ff             	mov    %r15,%rdi
  8c494a:	31 c9                	xor    %ecx,%ecx
  8c494c:	e8 6f 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c4951:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c4956:	be 02 00 00 00       	mov    $0x2,%esi
  8c495b:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4960:	4c 89 ff             	mov    %r15,%rdi
  8c4963:	e8 58 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c4968:	45 85 ed             	test   %r13d,%r13d
  8c496b:	74 2e                	je     8c499b <check_lower_drain+0x29fb>
  8c496d:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c4972:	be 01 00 00 00       	mov    $0x1,%esi
  8c4977:	ba 08 00 00 00       	mov    $0x8,%edx
  8c497c:	4c 89 f1             	mov    %r14,%rcx
  8c497f:	48 89 df             	mov    %rbx,%rdi
  8c4982:	e8 39 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c4987:	be 13 00 00 00       	mov    $0x13,%esi
  8c498c:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4991:	48 89 df             	mov    %rbx,%rdi
  8c4994:	31 c9                	xor    %ecx,%ecx
  8c4996:	e8 25 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c499b:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c49a0:	be 11 00 00 00       	mov    $0x11,%esi
  8c49a5:	ba 08 00 00 00       	mov    $0x8,%edx
  8c49aa:	31 c9                	xor    %ecx,%ecx
  8c49ac:	e8 0f 16 00 00       	call   8c5fc0 <check_lower_emit>
  8c49b1:	41 83 fc 01          	cmp    $0x1,%r12d
  8c49b5:	0f 87 fb 01 00 00    	ja     8c4bb6 <check_lower_drain+0x2c16>
  8c49bb:	83 fd 02             	cmp    $0x2,%ebp
  8c49be:	0f 84 87 0a 00 00    	je     8c544b <check_lower_drain+0x34ab>
  8c49c4:	83 fd 04             	cmp    $0x4,%ebp
  8c49c7:	0f 84 7a 0a 00 00    	je     8c5447 <check_lower_drain+0x34a7>
  8c49cd:	b3 08                	mov    $0x8,%bl
  8c49cf:	83 fd 08             	cmp    $0x8,%ebp
  8c49d2:	0f 84 89 0a 00 00    	je     8c5461 <check_lower_drain+0x34c1>
  8c49d8:	b3 02                	mov    $0x2,%bl
  8c49da:	e9 6e 0a 00 00       	jmp    8c544d <check_lower_drain+0x34ad>
  8c49df:	ba 07 00 00 00       	mov    $0x7,%edx
  8c49e4:	4c 89 ef             	mov    %r13,%rdi
  8c49e7:	44 89 f6             	mov    %r14d,%esi
  8c49ea:	c5 f8 77             	vzeroupper
  8c49ed:	e8 ee 5d 00 00       	call   8ca7e0 <check_lower_vla_size>
  8c49f2:	e9 09 d6 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c49f7:	83 ff 14             	cmp    $0x14,%edi
  8c49fa:	0f 85 df 02 00 00    	jne    8c4cdf <check_lower_drain+0x2d3f>
  8c4a00:	c7 84 24 90 00 00 00 	movl   $0x14,0x90(%rsp)
  8c4a07:	14 00 00 00 
  8c4a0b:	89 b4 24 94 00 00 00 	mov    %esi,0x94(%rsp)
  8c4a12:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  8c4a19:	00 00 00 00 00 
  8c4a1e:	e9 e1 02 00 00       	jmp    8c4d04 <check_lower_drain+0x2d64>
  8c4a23:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4a28:	e9 b1 da ff ff       	jmp    8c24de <check_lower_drain+0x53e>
  8c4a2d:	41 38 dc             	cmp    %bl,%r12b
  8c4a30:	0f 84 7e 0a 00 00    	je     8c54b4 <check_lower_drain+0x3514>
  8c4a36:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4a3b:	0f b6 d3             	movzbl %bl,%edx
  8c4a3e:	be 09 00 00 00       	mov    $0x9,%esi
  8c4a43:	e9 db 04 00 00       	jmp    8c4f23 <check_lower_drain+0x2f83>
  8c4a48:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  8c4a4d:	4c 89 ff             	mov    %r15,%rdi
  8c4a50:	e8 eb 65 00 00       	call   8cb040 <check_lower_label>
  8c4a55:	4c 89 ff             	mov    %r15,%rdi
  8c4a58:	89 c5                	mov    %eax,%ebp
  8c4a5a:	e8 e1 65 00 00       	call   8cb040 <check_lower_label>
  8c4a5f:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
  8c4a64:	41 89 c7             	mov    %eax,%r15d
  8c4a67:	0f 84 76 03 00 00    	je     8c4de3 <check_lower_drain+0x2e43>
  8c4a6d:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c4a72:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c4a77:	c1 e8 03             	shr    $0x3,%eax
  8c4a7a:	b1 ff                	mov    $0xff,%cl
  8c4a7c:	3b 82 b0 01 00 00    	cmp    0x1b0(%rdx),%eax
  8c4a82:	73 10                	jae    8c4a94 <check_lower_drain+0x2af4>
  8c4a84:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c4a89:	48 8b 89 98 01 00 00 	mov    0x198(%rcx),%rcx
  8c4a90:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c4a94:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c4a99:	0f b6 f1             	movzbl %cl,%esi
  8c4a9c:	4c 89 e7             	mov    %r12,%rdi
  8c4a9f:	e8 7c 9a ff ff       	call   8be520 <check_lower_temporary>
  8c4aa4:	89 c0                	mov    %eax,%eax
  8c4aa6:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8c4aab:	4c 89 e7             	mov    %r12,%rdi
  8c4aae:	44 89 fe             	mov    %r15d,%esi
  8c4ab1:	e8 da ed 00 00       	call   8d3890 <check_lower_mark>
  8c4ab6:	e9 49 03 00 00       	jmp    8c4e04 <check_lower_drain+0x2e64>
  8c4abb:	31 c0                	xor    %eax,%eax
  8c4abd:	41 80 fc 0c          	cmp    $0xc,%r12b
  8c4ac1:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4ac6:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4acc:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  8c4ad2:	0f 95 c0             	setne  %al
  8c4ad5:	31 c9                	xor    %ecx,%ecx
  8c4ad7:	80 fb 0a             	cmp    $0xa,%bl
  8c4ada:	0f 95 c1             	setne  %cl
  8c4add:	80 fb 09             	cmp    $0x9,%bl
  8c4ae0:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c4ae3:	8d 14 cd a0 00 00 00 	lea    0xa0(,%rcx,8),%edx
  8c4aea:	8d 71 01             	lea    0x1(%rcx),%esi
  8c4aed:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c4af2:	0f 44 d1             	cmove  %ecx,%edx
  8c4af5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c4afa:	0f 44 f1             	cmove  %ecx,%esi
  8c4afd:	48 8d 8c 24 b0 00 00 	lea    0xb0(%rsp),%rcx
  8c4b04:	00 
  8c4b05:	8d 74 06 05          	lea    0x5(%rsi,%rax,1),%esi
  8c4b09:	e8 a2 2e 01 00       	call   8d79b0 <check_lower_runtime_call>
  8c4b0e:	41 89 c7             	mov    %eax,%r15d
  8c4b11:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4b16:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c4b1b:	45 89 f6             	mov    %r14d,%r14d
  8c4b1e:	89 ea                	mov    %ebp,%edx
  8c4b20:	4c 89 f1             	mov    %r14,%rcx
  8c4b23:	4c 89 ef             	mov    %r13,%rdi
  8c4b26:	e8 95 14 00 00       	call   8c5fc0 <check_lower_emit>
  8c4b2b:	be 03 00 00 00       	mov    $0x3,%esi
  8c4b30:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4b35:	4c 89 ef             	mov    %r13,%rdi
  8c4b38:	4c 89 f1             	mov    %r14,%rcx
  8c4b3b:	e8 80 14 00 00       	call   8c5fc0 <check_lower_emit>
  8c4b40:	0f b6 d3             	movzbl %bl,%edx
  8c4b43:	4c 89 ef             	mov    %r13,%rdi
  8c4b46:	be 22 00 00 00       	mov    $0x22,%esi
  8c4b4b:	4c 89 f9             	mov    %r15,%rcx
  8c4b4e:	e9 b6 08 00 00       	jmp    8c5409 <check_lower_drain+0x3469>
  8c4b53:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4b58:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c4b5d:	c5 f8 77             	vzeroupper
  8c4b60:	e8 0b fb 00 00       	call   8d4670 <check_lower_varargs_prepare>
  8c4b65:	e9 16 10 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c4b6a:	83 7c 24 40 1b       	cmpl   $0x1b,0x40(%rsp)
  8c4b6f:	0f 85 6c 04 00 00    	jne    8c4fe1 <check_lower_drain+0x3041>
  8c4b75:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  8c4b7a:	4b 8d 14 52          	lea    (%r10,%r10,2),%rdx
  8c4b7e:	48 c1 e2 05          	shl    $0x5,%rdx
  8c4b82:	f6 44 11 08 04       	testb  $0x4,0x8(%rcx,%rdx,1)
  8c4b87:	0f 84 a0 04 00 00    	je     8c502d <check_lower_drain+0x308d>
  8c4b8d:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c4b92:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4b97:	48 b8 00 00 00 00 00 	movabs $0x40000000000,%rax
  8c4b9e:	04 00 00 
  8c4ba1:	31 d2                	xor    %edx,%edx
  8c4ba3:	48 85 c6             	test   %rax,%rsi
  8c4ba6:	0f 95 c2             	setne  %dl
  8c4ba9:	c5 f8 77             	vzeroupper
  8c4bac:	e8 cf 08 01 00       	call   8d5480 <check_lower_bit_assign>
  8c4bb1:	e9 ca 0f 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c4bb6:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4bbb:	be 08 00 00 00       	mov    $0x8,%esi
  8c4bc0:	4c 89 ef             	mov    %r13,%rdi
  8c4bc3:	e8 58 99 ff ff       	call   8be520 <check_lower_temporary>
  8c4bc8:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c4bcd:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4bd2:	41 89 c6             	mov    %eax,%r14d
  8c4bd5:	4c 89 ef             	mov    %r13,%rdi
  8c4bd8:	4c 89 f1             	mov    %r14,%rcx
  8c4bdb:	e8 e0 13 00 00       	call   8c5fc0 <check_lower_emit>
  8c4be0:	31 db                	xor    %ebx,%ebx
  8c4be2:	eb 22                	jmp    8c4c06 <check_lower_drain+0x2c66>
  8c4be4:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4be9:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c4bee:	44 89 ea             	mov    %r13d,%edx
  8c4bf1:	31 c9                	xor    %ecx,%ecx
  8c4bf3:	49 89 fd             	mov    %rdi,%r13
  8c4bf6:	e8 c5 13 00 00       	call   8c5fc0 <check_lower_emit>
  8c4bfb:	44 01 fb             	add    %r15d,%ebx
  8c4bfe:	39 eb                	cmp    %ebp,%ebx
  8c4c00:	0f 83 6f 08 00 00    	jae    8c5475 <check_lower_drain+0x34d5>
  8c4c06:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c4c0a:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4c11:	0f 85 5e 08 00 00    	jne    8c5475 <check_lower_drain+0x34d5>
  8c4c17:	89 e8                	mov    %ebp,%eax
  8c4c19:	29 d8                	sub    %ebx,%eax
  8c4c1b:	83 f8 07             	cmp    $0x7,%eax
  8c4c1e:	76 0b                	jbe    8c4c2b <check_lower_drain+0x2c8b>
  8c4c20:	41 b4 08             	mov    $0x8,%r12b
  8c4c23:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  8c4c29:	eb 26                	jmp    8c4c51 <check_lower_drain+0x2cb1>
  8c4c2b:	83 f8 03             	cmp    $0x3,%eax
  8c4c2e:	76 0b                	jbe    8c4c3b <check_lower_drain+0x2c9b>
  8c4c30:	41 b4 06             	mov    $0x6,%r12b
  8c4c33:	41 bf 04 00 00 00    	mov    $0x4,%r15d
  8c4c39:	eb 16                	jmp    8c4c51 <check_lower_drain+0x2cb1>
  8c4c3b:	45 31 e4             	xor    %r12d,%r12d
  8c4c3e:	83 f8 02             	cmp    $0x2,%eax
  8c4c41:	41 0f 93 c4          	setae  %r12b
  8c4c45:	45 8d 7c 24 01       	lea    0x1(%r12),%r15d
  8c4c4a:	45 00 e4             	add    %r12b,%r12b
  8c4c4d:	41 80 c4 02          	add    $0x2,%r12b
  8c4c51:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c4c56:	be 02 00 00 00       	mov    $0x2,%esi
  8c4c5b:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4c60:	4c 89 ef             	mov    %r13,%rdi
  8c4c63:	e8 58 13 00 00       	call   8c5fc0 <check_lower_emit>
  8c4c68:	89 de                	mov    %ebx,%esi
  8c4c6a:	4c 89 ef             	mov    %r13,%rdi
  8c4c6d:	e8 fe 74 00 00       	call   8cc170 <check_lower_offset>
  8c4c72:	be 02 00 00 00       	mov    $0x2,%esi
  8c4c77:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4c7c:	4c 89 ef             	mov    %r13,%rdi
  8c4c7f:	4c 89 f1             	mov    %r14,%rcx
  8c4c82:	e8 39 13 00 00       	call   8c5fc0 <check_lower_emit>
  8c4c87:	85 db                	test   %ebx,%ebx
  8c4c89:	74 2d                	je     8c4cb8 <check_lower_drain+0x2d18>
  8c4c8b:	8d 0c dd 00 00 00 00 	lea    0x0(,%rbx,8),%ecx
  8c4c92:	be 01 00 00 00       	mov    $0x1,%esi
  8c4c97:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4c9c:	4c 89 ef             	mov    %r13,%rdi
  8c4c9f:	e8 1c 13 00 00       	call   8c5fc0 <check_lower_emit>
  8c4ca4:	be 14 00 00 00       	mov    $0x14,%esi
  8c4ca9:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4cae:	4c 89 ef             	mov    %r13,%rdi
  8c4cb1:	31 c9                	xor    %ecx,%ecx
  8c4cb3:	e8 08 13 00 00       	call   8c5fc0 <check_lower_emit>
  8c4cb8:	45 0f b6 ec          	movzbl %r12b,%r13d
  8c4cbc:	41 80 fc 08          	cmp    $0x8,%r12b
  8c4cc0:	0f 84 1e ff ff ff    	je     8c4be4 <check_lower_drain+0x2c44>
  8c4cc6:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4ccb:	be 09 00 00 00       	mov    $0x9,%esi
  8c4cd0:	44 89 ea             	mov    %r13d,%edx
  8c4cd3:	31 c9                	xor    %ecx,%ecx
  8c4cd5:	e8 e6 12 00 00       	call   8c5fc0 <check_lower_emit>
  8c4cda:	e9 05 ff ff ff       	jmp    8c4be4 <check_lower_drain+0x2c44>
  8c4cdf:	89 bc 24 90 00 00 00 	mov    %edi,0x90(%rsp)
  8c4ce6:	89 b4 24 94 00 00 00 	mov    %esi,0x94(%rsp)
  8c4ced:	44 89 b4 24 98 00 00 	mov    %r14d,0x98(%rsp)
  8c4cf4:	00 
  8c4cf5:	c7 84 24 9c 00 00 00 	movl   $0x0,0x9c(%rsp)
  8c4cfc:	00 00 00 00 
  8c4d00:	49 c1 ee 20          	shr    $0x20,%r14
  8c4d04:	48 89 f0             	mov    %rsi,%rax
  8c4d07:	48 c1 e8 28          	shr    $0x28,%rax
  8c4d0b:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  8c4d12:	00 
  8c4d13:	48 8d 8c 24 ab 00 00 	lea    0xab(%rsp),%rcx
  8c4d1a:	00 
  8c4d1b:	24 01                	and    $0x1,%al
  8c4d1d:	88 84 24 a8 00 00 00 	mov    %al,0xa8(%rsp)
  8c4d24:	48 89 f0             	mov    %rsi,%rax
  8c4d27:	48 c1 e8 29          	shr    $0x29,%rax
  8c4d2b:	48 c1 ee 2a          	shr    $0x2a,%rsi
  8c4d2f:	24 01                	and    $0x1,%al
  8c4d31:	40 80 e6 01          	and    $0x1,%sil
  8c4d35:	88 84 24 a9 00 00 00 	mov    %al,0xa9(%rsp)
  8c4d3c:	40 88 b4 24 aa 00 00 	mov    %sil,0xaa(%rsp)
  8c4d43:	00 
  8c4d44:	c6 41 04 00          	movb   $0x0,0x4(%rcx)
  8c4d48:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c4d4e:	c5 fe 6f 84 24 90 00 	vmovdqu 0x90(%rsp),%ymm0
  8c4d55:	00 00 
  8c4d57:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c4d5c:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4d61:	4c 89 ef             	mov    %r13,%rdi
  8c4d64:	c5 f8 77             	vzeroupper
  8c4d67:	e8 b4 8d 00 00       	call   8cdb20 <check_lower_complex_task>
  8c4d6c:	e9 8f d2 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c4d71:	44 0f b6 bc 24 c0 01 	movzbl 0x1c0(%rsp),%r15d
  8c4d78:	00 00 
  8c4d7a:	41 83 fd 16          	cmp    $0x16,%r13d
  8c4d7e:	0f 94 c0             	sete   %al
  8c4d81:	41 83 fd 15          	cmp    $0x15,%r13d
  8c4d85:	0f 94 c1             	sete   %cl
  8c4d88:	44 89 fa             	mov    %r15d,%edx
  8c4d8b:	44 20 f8             	and    %r15b,%al
  8c4d8e:	80 f2 01             	xor    $0x1,%dl
  8c4d91:	20 ca                	and    %cl,%dl
  8c4d93:	08 c2                	or     %al,%dl
  8c4d95:	80 fa 01             	cmp    $0x1,%dl
  8c4d98:	0f 85 96 03 00 00    	jne    8c5134 <check_lower_drain+0x3194>
  8c4d9e:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c4da3:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c4da9:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c4daf:	0f 83 0e 07 00 00    	jae    8c54c3 <check_lower_drain+0x3523>
  8c4db5:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8c4dba:	8d 50 01             	lea    0x1(%rax),%edx
  8c4dbd:	48 c1 e0 04          	shl    $0x4,%rax
  8c4dc1:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c4dc5:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c4dcb:	48 ba 01 00 00 00 01 	movabs $0x5000100000001,%rdx
  8c4dd2:	00 05 00 
  8c4dd5:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c4dd9:	4c 89 7c 01 08       	mov    %r15,0x8(%rcx,%rax,1)
  8c4dde:	e9 7f 03 00 00       	jmp    8c5162 <check_lower_drain+0x31c2>
  8c4de3:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4de8:	44 89 fe             	mov    %r15d,%esi
  8c4deb:	e8 a0 ea 00 00       	call   8d3890 <check_lower_mark>
  8c4df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c4df5:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8c4dfa:	41 83 fd 17          	cmp    $0x17,%r13d
  8c4dfe:	0f 85 94 03 00 00    	jne    8c5198 <check_lower_drain+0x31f8>
  8c4e04:	45 8b 06             	mov    (%r14),%r8d
  8c4e07:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4e0c:	ba 02 00 00 00       	mov    $0x2,%edx
  8c4e11:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c4e16:	31 c9                	xor    %ecx,%ecx
  8c4e18:	e8 b3 ac 00 00       	call   8cfad0 <check_lower_operand>
  8c4e1d:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c4e22:	89 ee                	mov    %ebp,%esi
  8c4e24:	4c 89 e7             	mov    %r12,%rdi
  8c4e27:	e8 64 ea 00 00       	call   8d3890 <check_lower_mark>
  8c4e2c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8c4e31:	be 27 00 00 00       	mov    $0x27,%esi
  8c4e36:	44 89 f9             	mov    %r15d,%ecx
  8c4e39:	4c 89 e7             	mov    %r12,%rdi
  8c4e3c:	3c 01                	cmp    $0x1,%al
  8c4e3e:	0f b6 d0             	movzbl %al,%edx
  8c4e41:	83 de 00             	sbb    $0x0,%esi
  8c4e44:	e8 c7 16 00 00       	call   8c6510 <check_lower_instruction>
  8c4e49:	41 83 fd 17          	cmp    $0x17,%r13d
  8c4e4d:	75 69                	jne    8c4eb8 <check_lower_drain+0x2f18>
  8c4e4f:	45 8b 06             	mov    (%r14),%r8d
  8c4e52:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  8c4e59:	00 
  8c4e5a:	39 44 24 30          	cmp    %eax,0x30(%rsp)
  8c4e5e:	0f 85 82 03 00 00    	jne    8c51e6 <check_lower_drain+0x3246>
  8c4e64:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  8c4e69:	4c 8b 7c 24 58       	mov    0x58(%rsp),%r15
  8c4e6e:	44 89 c2             	mov    %r8d,%edx
  8c4e71:	4c 89 f7             	mov    %r14,%rdi
  8c4e74:	44 89 fe             	mov    %r15d,%esi
  8c4e77:	e8 04 55 00 00       	call   8ca380 <check_lower_convert>
  8c4e7c:	41 c1 ef 03          	shr    $0x3,%r15d
  8c4e80:	b1 ff                	mov    $0xff,%cl
  8c4e82:	45 3b be b0 01 00 00 	cmp    0x1b0(%r14),%r15d
  8c4e89:	73 11                	jae    8c4e9c <check_lower_drain+0x2efc>
  8c4e8b:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c4e90:	48 8b 89 98 01 00 00 	mov    0x198(%rcx),%rcx
  8c4e97:	42 0f b6 0c 39       	movzbl (%rcx,%r15,1),%ecx
  8c4e9c:	0f b6 d1             	movzbl %cl,%edx
  8c4e9f:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4ea4:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8c4ea9:	be 02 00 00 00       	mov    $0x2,%esi
  8c4eae:	e8 5d 16 00 00       	call   8c6510 <check_lower_instruction>
  8c4eb3:	e9 44 03 00 00       	jmp    8c51fc <check_lower_drain+0x325c>
  8c4eb8:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  8c4ebd:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  8c4ec2:	31 d2                	xor    %edx,%edx
  8c4ec4:	4c 89 f7             	mov    %r14,%rdi
  8c4ec7:	44 89 fe             	mov    %r15d,%esi
  8c4eca:	e8 51 ae 00 00       	call   8cfd20 <check_lower_truth>
  8c4ecf:	ba 01 00 00 00       	mov    $0x1,%edx
  8c4ed4:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c4ed9:	4c 89 f7             	mov    %r14,%rdi
  8c4edc:	31 c9                	xor    %ecx,%ecx
  8c4ede:	45 89 f8             	mov    %r15d,%r8d
  8c4ee1:	e9 11 03 00 00       	jmp    8c51f7 <check_lower_drain+0x3257>
  8c4ee6:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4eeb:	be 23 00 00 00       	mov    $0x23,%esi
  8c4ef0:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4ef5:	31 c9                	xor    %ecx,%ecx
  8c4ef7:	c5 f8 77             	vzeroupper
  8c4efa:	e8 c1 10 00 00       	call   8c5fc0 <check_lower_emit>
  8c4eff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c4f06:	01 00 00 
  8c4f09:	48 85 44 24 38       	test   %rax,0x38(%rsp)
  8c4f0e:	0f 85 a0 05 00 00    	jne    8c54b4 <check_lower_drain+0x3514>
  8c4f14:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4f19:	be 23 00 00 00       	mov    $0x23,%esi
  8c4f1e:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4f23:	4c 89 ef             	mov    %r13,%rdi
  8c4f26:	31 c9                	xor    %ecx,%ecx
  8c4f28:	e9 dc 04 00 00       	jmp    8c5409 <check_lower_drain+0x3469>
  8c4f2d:	4c 89 ef             	mov    %r13,%rdi
  8c4f30:	c5 f8 77             	vzeroupper
  8c4f33:	e8 08 61 00 00       	call   8cb040 <check_lower_label>
  8c4f38:	89 c5                	mov    %eax,%ebp
  8c4f3a:	4c 89 ef             	mov    %r13,%rdi
  8c4f3d:	89 c6                	mov    %eax,%esi
  8c4f3f:	e8 2c 10 00 00       	call   8c5f70 <check_lower_place>
  8c4f44:	be 26 00 00 00       	mov    $0x26,%esi
  8c4f49:	89 e9                	mov    %ebp,%ecx
  8c4f4b:	4c 89 ef             	mov    %r13,%rdi
  8c4f4e:	31 d2                	xor    %edx,%edx
  8c4f50:	e8 6b 10 00 00       	call   8c5fc0 <check_lower_emit>
  8c4f55:	4c 89 fd             	mov    %r15,%rbp
  8c4f58:	e9 a3 d0 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c4f5d:	31 c0                	xor    %eax,%eax
  8c4f5f:	80 fb 0c             	cmp    $0xc,%bl
  8c4f62:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c4f67:	be 00 00 00 00       	mov    $0x0,%esi
  8c4f6c:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4f72:	45 89 f1             	mov    %r14d,%r9d
  8c4f75:	0f 95 c0             	setne  %al
  8c4f78:	31 c9                	xor    %ecx,%ecx
  8c4f7a:	41 80 fc 0a          	cmp    $0xa,%r12b
  8c4f7e:	0f 95 c1             	setne  %cl
  8c4f81:	8d 14 c5 70 00 00 00 	lea    0x70(,%rax,8),%edx
  8c4f88:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c4f8b:	ff c1                	inc    %ecx
  8c4f8d:	41 80 fc 09          	cmp    $0x9,%r12b
  8c4f91:	0f 44 ce             	cmove  %esi,%ecx
  8c4f94:	8d 74 01 0b          	lea    0xb(%rcx,%rax,1),%esi
  8c4f98:	48 8d 8c 24 b0 00 00 	lea    0xb0(%rsp),%rcx
  8c4f9f:	00 
  8c4fa0:	e8 0b 2a 01 00       	call   8d79b0 <check_lower_runtime_call>
  8c4fa5:	89 c1                	mov    %eax,%ecx
  8c4fa7:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4fac:	be 22 00 00 00       	mov    $0x22,%esi
  8c4fb1:	31 d2                	xor    %edx,%edx
  8c4fb3:	4c 89 ef             	mov    %r13,%rdi
  8c4fb6:	e8 05 10 00 00       	call   8c5fc0 <check_lower_emit>
  8c4fbb:	44 89 f1             	mov    %r14d,%ecx
  8c4fbe:	4c 89 ef             	mov    %r13,%rdi
  8c4fc1:	be 02 00 00 00       	mov    $0x2,%esi
  8c4fc6:	89 ea                	mov    %ebp,%edx
  8c4fc8:	e9 3c 04 00 00       	jmp    8c5409 <check_lower_drain+0x3469>
  8c4fcd:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c4fd2:	be 29 00 00 00       	mov    $0x29,%esi
  8c4fd7:	31 d2                	xor    %edx,%edx
  8c4fd9:	4c 89 f1             	mov    %r14,%rcx
  8c4fdc:	e9 25 04 00 00       	jmp    8c5406 <check_lower_drain+0x3466>
  8c4fe1:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c4fe6:	83 c1 da             	add    $0xffffffda,%ecx
  8c4fe9:	83 f9 0d             	cmp    $0xd,%ecx
  8c4fec:	77 3f                	ja     8c502d <check_lower_drain+0x308d>
  8c4fee:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
  8c4ff3:	4b 8d 34 52          	lea    (%r10,%r10,2),%rsi
  8c4ff7:	b1 01                	mov    $0x1,%cl
  8c4ff9:	48 c1 e6 05          	shl    $0x5,%rsi
  8c4ffd:	f6 44 32 08 04       	testb  $0x4,0x8(%rdx,%rsi,1)
  8c5002:	74 2b                	je     8c502f <check_lower_drain+0x308f>
  8c5004:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c5009:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c500e:	48 b8 00 00 00 00 00 	movabs $0x40000000000,%rax
  8c5015:	04 00 00 
  8c5018:	31 d2                	xor    %edx,%edx
  8c501a:	48 85 c6             	test   %rax,%rsi
  8c501d:	0f 95 c2             	setne  %dl
  8c5020:	c5 f8 77             	vzeroupper
  8c5023:	e8 b8 07 01 00       	call   8d57e0 <check_lower_bit_update>
  8c5028:	e9 53 0b 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c502d:	31 c9                	xor    %ecx,%ecx
  8c502f:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c5034:	83 c2 e5             	add    $0xffffffe5,%edx
  8c5037:	f7 c2 f7 ff ff ff    	test   $0xfffffff7,%edx
  8c503d:	0f 94 c2             	sete   %dl
  8c5040:	22 54 24 78          	and    0x78(%rsp),%dl
  8c5044:	80 fa 01             	cmp    $0x1,%dl
  8c5047:	0f 85 6a 02 00 00    	jne    8c52b7 <check_lower_drain+0x3317>
  8c504d:	83 7c 24 40 23       	cmpl   $0x23,0x40(%rsp)
  8c5052:	c7 44 24 30 ff ff ff 	movl   $0xffffffff,0x30(%rsp)
  8c5059:	ff 
  8c505a:	75 14                	jne    8c5070 <check_lower_drain+0x30d0>
  8c505c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5061:	48 8b 80 b8 00 00 00 	mov    0xb8(%rax),%rax
  8c5068:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c506c:	89 44 24 30          	mov    %eax,0x30(%rsp)
  8c5070:	c4 e2 79 22 05 0f 23 	vpmovsxbq -0x41dcf1(%rip),%xmm0        # 4a7388 <cbuiltin_test_generated.edges+0xacf8>
  8c5077:	be ff 
  8c5079:	41 c1 e8 03          	shr    $0x3,%r8d
  8c507d:	c5 f8 29 84 24 a0 01 	vmovaps %xmm0,0x1a0(%rsp)
  8c5084:	00 00 
  8c5086:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c508a:	42 80 3c 00 0f       	cmpb   $0xf,(%rax,%r8,1)
  8c508f:	75 0c                	jne    8c509d <check_lower_drain+0x30fd>
  8c5091:	49 8b 45 20          	mov    0x20(%r13),%rax
  8c5095:	46 8b 04 80          	mov    (%rax,%r8,4),%r8d
  8c5099:	41 c1 e8 03          	shr    $0x3,%r8d
  8c509d:	49 8b 45 38          	mov    0x38(%r13),%rax
  8c50a1:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  8c50a6:	4c 8b 6c 24 38       	mov    0x38(%rsp),%r13
  8c50ab:	45 31 ff             	xor    %r15d,%r15d
  8c50ae:	48 b9 00 00 00 00 00 	movabs $0x40000000000,%rcx
  8c50b5:	04 00 00 
  8c50b8:	4a 8b 04 c0          	mov    (%rax,%r8,8),%rax
  8c50bc:	83 fb 23             	cmp    $0x23,%ebx
  8c50bf:	41 0f 95 c7          	setne  %r15b
  8c50c3:	49 85 cd             	test   %rcx,%r13
  8c50c6:	48 8d 8c 24 b9 01 00 	lea    0x1b9(%rsp),%rcx
  8c50cd:	00 
  8c50ce:	48 89 84 24 b0 01 00 	mov    %rax,0x1b0(%rsp)
  8c50d5:	00 
  8c50d6:	0f 94 84 24 b8 01 00 	sete   0x1b8(%rsp)
  8c50dd:	00 
  8c50de:	c7 41 03 00 00 00 00 	movl   $0x0,0x3(%rcx)
  8c50e5:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c50eb:	c5 fe 6f 84 24 a0 01 	vmovdqu 0x1a0(%rsp),%ymm0
  8c50f2:	00 00 
  8c50f4:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c50f9:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8c50fe:	4c 89 e7             	mov    %r12,%rdi
  8c5101:	c5 f8 77             	vzeroupper
  8c5104:	e8 b7 51 00 00       	call   8ca2c0 <check_lower_push>
  8c5109:	45 8b 06             	mov    (%r14),%r8d
  8c510c:	4c 89 e7             	mov    %r12,%rdi
  8c510f:	44 89 ee             	mov    %r13d,%esi
  8c5112:	44 89 fa             	mov    %r15d,%edx
  8c5115:	31 c9                	xor    %ecx,%ecx
  8c5117:	e8 b4 a9 00 00       	call   8cfad0 <check_lower_operand>
  8c511c:	83 fb 1b             	cmp    $0x1b,%ebx
  8c511f:	0f 85 12 04 00 00    	jne    8c5537 <check_lower_drain+0x3597>
  8c5125:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c512a:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c512f:	e9 61 e1 ff ff       	jmp    8c3295 <check_lower_drain+0x12f5>
  8c5134:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  8c5139:	4c 8b 64 24 68       	mov    0x68(%rsp),%r12
  8c513e:	31 d2                	xor    %edx,%edx
  8c5140:	4c 89 f7             	mov    %r14,%rdi
  8c5143:	44 89 e6             	mov    %r12d,%esi
  8c5146:	e8 d5 ab 00 00       	call   8cfd20 <check_lower_truth>
  8c514b:	ba 01 00 00 00       	mov    $0x1,%edx
  8c5150:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c5155:	4c 89 f7             	mov    %r14,%rdi
  8c5158:	31 c9                	xor    %ecx,%ecx
  8c515a:	45 89 e0             	mov    %r12d,%r8d
  8c515d:	e8 6e a9 00 00       	call   8cfad0 <check_lower_operand>
  8c5162:	44 84 7c 24 48       	test   %r15b,0x48(%rsp)
  8c5167:	0f 85 13 0a 00 00    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c516d:	48 8b 03             	mov    (%rbx),%rax
  8c5170:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  8c5174:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c5179:	48 8b 38             	mov    (%rax),%rdi
  8c517c:	e8 4f e6 00 00       	call   8d37d0 <check_program_runtime_effects>
  8c5181:	b9 08 00 00 00       	mov    $0x8,%ecx
  8c5186:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
  8c518b:	84 c0                	test   %al,%al
  8c518d:	0f 85 15 01 00 00    	jne    8c52a8 <check_lower_drain+0x3308>
  8c5193:	e9 e8 09 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c5198:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c519d:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c51a3:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c51a9:	0f 83 4e 03 00 00    	jae    8c54fd <check_lower_drain+0x355d>
  8c51af:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c51b4:	31 c9                	xor    %ecx,%ecx
  8c51b6:	41 83 fd 16          	cmp    $0x16,%r13d
  8c51ba:	8d 70 01             	lea    0x1(%rax),%esi
  8c51bd:	0f 94 c1             	sete   %cl
  8c51c0:	48 c1 e0 04          	shl    $0x4,%rax
  8c51c4:	48 8b 57 18          	mov    0x18(%rdi),%rdx
  8c51c8:	89 b7 3c 01 00 00    	mov    %esi,0x13c(%rdi)
  8c51ce:	48 be 01 00 00 00 01 	movabs $0x5000100000001,%rsi
  8c51d5:	00 05 00 
  8c51d8:	48 89 34 02          	mov    %rsi,(%rdx,%rax,1)
  8c51dc:	48 89 4c 02 08       	mov    %rcx,0x8(%rdx,%rax,1)
  8c51e1:	e9 37 fc ff ff       	jmp    8c4e1d <check_lower_drain+0x2e7d>
  8c51e6:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c51eb:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c51f0:	ba 01 00 00 00       	mov    $0x1,%edx
  8c51f5:	31 c9                	xor    %ecx,%ecx
  8c51f7:	e8 d4 a8 00 00       	call   8cfad0 <check_lower_operand>
  8c51fc:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  8c5201:	31 f6                	xor    %esi,%esi
  8c5203:	41 83 fd 16          	cmp    $0x16,%r13d
  8c5207:	ba 05 00 00 00       	mov    $0x5,%edx
  8c520c:	89 e9                	mov    %ebp,%ecx
  8c520e:	40 0f 94 c6          	sete   %sil
  8c5212:	83 ce 24             	or     $0x24,%esi
  8c5215:	4c 89 f7             	mov    %r14,%rdi
  8c5218:	e8 f3 12 00 00       	call   8c6510 <check_lower_instruction>
  8c521d:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  8c5222:	4c 89 f7             	mov    %r14,%rdi
  8c5225:	31 d2                	xor    %edx,%edx
  8c5227:	e8 f4 aa 00 00       	call   8cfd20 <check_lower_truth>
  8c522c:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
  8c5231:	74 75                	je     8c52a8 <check_lower_drain+0x3308>
  8c5233:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5238:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
  8c523d:	c1 eb 03             	shr    $0x3,%ebx
  8c5240:	40 b5 ff             	mov    $0xff,%bpl
  8c5243:	b0 ff                	mov    $0xff,%al
  8c5245:	3b 99 b0 01 00 00    	cmp    0x1b0(%rcx),%ebx
  8c524b:	73 10                	jae    8c525d <check_lower_drain+0x32bd>
  8c524d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5252:	48 8b 80 98 01 00 00 	mov    0x198(%rax),%rax
  8c5259:	0f b6 04 18          	movzbl (%rax,%rbx,1),%eax
  8c525d:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  8c5262:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8c5267:	0f b6 d0             	movzbl %al,%edx
  8c526a:	be 02 00 00 00       	mov    $0x2,%esi
  8c526f:	4c 89 f7             	mov    %r14,%rdi
  8c5272:	e8 99 12 00 00       	call   8c6510 <check_lower_instruction>
  8c5277:	41 3b 9e b0 01 00 00 	cmp    0x1b0(%r14),%ebx
  8c527e:	73 10                	jae    8c5290 <check_lower_drain+0x32f0>
  8c5280:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5285:	48 8b 80 98 01 00 00 	mov    0x198(%rax),%rax
  8c528c:	0f b6 2c 18          	movzbl (%rax,%rbx,1),%ebp
  8c5290:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c5295:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8c529a:	40 0f b6 d5          	movzbl %bpl,%edx
  8c529e:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c52a3:	e8 68 12 00 00       	call   8c6510 <check_lower_instruction>
  8c52a8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c52ad:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c52b2:	e9 c5 e2 ff ff       	jmp    8c357c <check_lower_drain+0x15dc>
  8c52b7:	83 7c 24 40 23       	cmpl   $0x23,0x40(%rsp)
  8c52bc:	74 0b                	je     8c52c9 <check_lower_drain+0x3329>
  8c52be:	83 7c 24 40 1b       	cmpl   $0x1b,0x40(%rsp)
  8c52c3:	0f 85 cb 03 00 00    	jne    8c5694 <check_lower_drain+0x36f4>
  8c52c9:	83 7c 24 40 23       	cmpl   $0x23,0x40(%rsp)
  8c52ce:	0f 85 cf 02 00 00    	jne    8c55a3 <check_lower_drain+0x3603>
  8c52d4:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c52d9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c52de:	48 8b 80 b8 00 00 00 	mov    0xb8(%rax),%rax
  8c52e5:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c52e9:	48 39 c8             	cmp    %rcx,%rax
  8c52ec:	0f 84 b1 02 00 00    	je     8c55a3 <check_lower_drain+0x3603>
  8c52f2:	48 8b 4d 00          	mov    0x0(%rbp),%rcx
  8c52f6:	48 c1 e0 02          	shl    $0x2,%rax
  8c52fa:	48 03 81 70 02 00 00 	add    0x270(%rcx),%rax
  8c5301:	e9 bd 02 00 00       	jmp    8c55c3 <check_lower_drain+0x3623>
  8c5306:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c530b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c5310:	41 89 ec             	mov    %ebp,%r12d
  8c5313:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c5318:	ba 08 00 00 00       	mov    $0x8,%edx
  8c531d:	4c 89 e1             	mov    %r12,%rcx
  8c5320:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8c5325:	e8 96 0c 00 00       	call   8c5fc0 <check_lower_emit>
  8c532a:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c532f:	4d 89 f7             	mov    %r14,%r15
  8c5332:	45 31 ed             	xor    %r13d,%r13d
  8c5335:	eb 55                	jmp    8c538c <check_lower_drain+0x33ec>
  8c5337:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c533c:	4c 89 ee             	mov    %r13,%rsi
  8c533f:	48 89 df             	mov    %rbx,%rdi
  8c5342:	e8 29 6e 00 00       	call   8cc170 <check_lower_offset>
  8c5347:	be 02 00 00 00       	mov    $0x2,%esi
  8c534c:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5351:	48 89 df             	mov    %rbx,%rdi
  8c5354:	4c 89 e1             	mov    %r12,%rcx
  8c5357:	e8 64 0c 00 00       	call   8c5fc0 <check_lower_emit>
  8c535c:	48 89 df             	mov    %rbx,%rdi
  8c535f:	4c 89 ee             	mov    %r13,%rsi
  8c5362:	e8 09 6e 00 00       	call   8cc170 <check_lower_offset>
  8c5367:	be 29 00 00 00       	mov    $0x29,%esi
  8c536c:	48 89 df             	mov    %rbx,%rdi
  8c536f:	31 d2                	xor    %edx,%edx
  8c5371:	48 89 e9             	mov    %rbp,%rcx
  8c5374:	e8 47 0c 00 00       	call   8c5fc0 <check_lower_emit>
  8c5379:	49 81 c5 00 01 00 00 	add    $0x100,%r13
  8c5380:	49 81 c7 00 ff ff ff 	add    $0xffffffffffffff00,%r15
  8c5387:	4d 39 f5             	cmp    %r14,%r13
  8c538a:	73 51                	jae    8c53dd <check_lower_drain+0x343d>
  8c538c:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5390:	49 81 ff 00 01 00 00 	cmp    $0x100,%r15
  8c5397:	b8 00 01 00 00       	mov    $0x100,%eax
  8c539c:	49 0f 42 c7          	cmovb  %r15,%rax
  8c53a0:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c53a7:	75 34                	jne    8c53dd <check_lower_drain+0x343d>
  8c53a9:	49 81 ff 00 01 00 00 	cmp    $0x100,%r15
  8c53b0:	bd 00 01 00 00       	mov    $0x100,%ebp
  8c53b5:	49 0f 42 ef          	cmovb  %r15,%rbp
  8c53b9:	4c 39 f8             	cmp    %r15,%rax
  8c53bc:	0f 84 75 ff ff ff    	je     8c5337 <check_lower_drain+0x3397>
  8c53c2:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c53c7:	be 06 00 00 00       	mov    $0x6,%esi
  8c53cc:	ba 08 00 00 00       	mov    $0x8,%edx
  8c53d1:	31 c9                	xor    %ecx,%ecx
  8c53d3:	e8 e8 0b 00 00       	call   8c5fc0 <check_lower_emit>
  8c53d8:	e9 5a ff ff ff       	jmp    8c5337 <check_lower_drain+0x3397>
  8c53dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c53e4:	01 00 00 
  8c53e7:	48 85 44 24 38       	test   %rax,0x38(%rsp)
  8c53ec:	0f 84 c2 00 00 00    	je     8c54b4 <check_lower_drain+0x3514>
  8c53f2:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c53f7:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c53fc:	be 02 00 00 00       	mov    $0x2,%esi
  8c5401:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5406:	4c 89 ef             	mov    %r13,%rdi
  8c5409:	c5 f8 77             	vzeroupper
  8c540c:	e8 af 0b 00 00       	call   8c5fc0 <check_lower_emit>
  8c5411:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
  8c5416:	e9 e5 cb ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c541b:	44 8b 6c 24 50       	mov    0x50(%rsp),%r13d
  8c5420:	4b 8d 6c 6d 00       	lea    0x0(%r13,%r13,2),%rbp
  8c5425:	48 c1 e5 05          	shl    $0x5,%rbp
  8c5429:	45 8b 64 2a 40       	mov    0x40(%r10,%rbp,1),%r12d
  8c542e:	4d 85 e4             	test   %r12,%r12
  8c5431:	0f 84 d2 02 00 00    	je     8c5709 <check_lower_drain+0x3769>
  8c5437:	45 3b a1 c0 00 00 00 	cmp    0xc0(%r9),%r12d
  8c543e:	41 0f 92 c0          	setb   %r8b
  8c5442:	e9 c5 02 00 00       	jmp    8c570c <check_lower_drain+0x376c>
  8c5447:	b3 06                	mov    $0x6,%bl
  8c5449:	eb 02                	jmp    8c544d <check_lower_drain+0x34ad>
  8c544b:	b3 04                	mov    $0x4,%bl
  8c544d:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c5452:	0f b6 d3             	movzbl %bl,%edx
  8c5455:	be 09 00 00 00       	mov    $0x9,%esi
  8c545a:	31 c9                	xor    %ecx,%ecx
  8c545c:	e8 5f 0b 00 00       	call   8c5fc0 <check_lower_emit>
  8c5461:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c5466:	0f b6 d3             	movzbl %bl,%edx
  8c5469:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c546e:	31 c9                	xor    %ecx,%ecx
  8c5470:	e8 4b 0b 00 00       	call   8c5fc0 <check_lower_emit>
  8c5475:	48 b8 00 00 00 00 00 	movabs $0x40000000000,%rax
  8c547c:	04 00 00 
  8c547f:	48 85 44 24 38       	test   %rax,0x38(%rsp)
  8c5484:	75 2e                	jne    8c54b4 <check_lower_drain+0x3514>
  8c5486:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c548b:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8c5490:	be 02 00 00 00       	mov    $0x2,%esi
  8c5495:	ba 08 00 00 00       	mov    $0x8,%edx
  8c549a:	48 89 df             	mov    %rbx,%rdi
  8c549d:	e8 1e 0b 00 00       	call   8c5fc0 <check_lower_emit>
  8c54a2:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  8c54a9:	00 
  8c54aa:	48 89 df             	mov    %rbx,%rdi
  8c54ad:	31 d2                	xor    %edx,%edx
  8c54af:	e8 7c 84 01 00       	call   8dd930 <check_lower_bit_extract>
  8c54b4:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c54b9:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
  8c54be:	e9 3d cb ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c54c3:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c54c8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c54cc:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c54d3:	0f 85 89 fc ff ff    	jne    8c5162 <check_lower_drain+0x31c2>
  8c54d9:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c54de:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c54e5:	00 00 00 
  8c54e8:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c54ee:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c54f2:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c54f8:	e9 65 fc ff ff       	jmp    8c5162 <check_lower_drain+0x31c2>
  8c54fd:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5502:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5506:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c550d:	0f 85 0a f9 ff ff    	jne    8c4e1d <check_lower_drain+0x2e7d>
  8c5513:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5518:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c551f:	00 00 00 
  8c5522:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5528:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c552c:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5532:	e9 e6 f8 ff ff       	jmp    8c4e1d <check_lower_drain+0x2e7d>
  8c5537:	48 8b 45 00          	mov    0x0(%rbp),%rax
  8c553b:	8b 4c 24 30          	mov    0x30(%rsp),%ecx
  8c553f:	3b 88 84 03 00 00    	cmp    0x384(%rax),%ecx
  8c5545:	0f 83 04 06 00 00    	jae    8c5b4f <check_lower_drain+0x3baf>
  8c554b:	48 8d 8c 24 88 01 00 	lea    0x188(%rsp),%rcx
  8c5552:	00 
  8c5553:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c5557:	c5 fa 7f 01          	vmovdqu %xmm0,(%rcx)
  8c555b:	48 c7 41 10 00 00 00 	movq   $0x0,0x10(%rcx)
  8c5562:	00 
  8c5563:	c7 84 24 80 01 00 00 	movl   $0xa,0x180(%rsp)
  8c556a:	0a 00 00 00 
  8c556e:	8b 4c 24 30          	mov    0x30(%rsp),%ecx
  8c5572:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
  8c5579:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c557c:	89 84 24 84 01 00 00 	mov    %eax,0x184(%rsp)
  8c5583:	c5 fe 6f 84 24 80 01 	vmovdqu 0x180(%rsp),%ymm0
  8c558a:	00 00 
  8c558c:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c5591:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c5596:	c5 f8 77             	vzeroupper
  8c5599:	e8 22 4d 00 00       	call   8ca2c0 <check_lower_push>
  8c559e:	e9 dd 05 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c55a3:	48 8b 03             	mov    (%rbx),%rax
  8c55a6:	42 83 3c 90 00       	cmpl   $0x0,(%rax,%r10,4)
  8c55ab:	0f 85 97 00 00 00    	jne    8c5648 <check_lower_drain+0x36a8>
  8c55b1:	49 8b 44 24 08       	mov    0x8(%r12),%rax
  8c55b6:	4b 8d 0c 52          	lea    (%r10,%r10,2),%rcx
  8c55ba:	48 c1 e1 05          	shl    $0x5,%rcx
  8c55be:	48 8d 44 08 40       	lea    0x40(%rax,%rcx,1),%rax
  8c55c3:	8b 18                	mov    (%rax),%ebx
  8c55c5:	48 85 db             	test   %rbx,%rbx
  8c55c8:	74 7e                	je     8c5648 <check_lower_drain+0x36a8>
  8c55ca:	3b 9d c0 00 00 00    	cmp    0xc0(%rbp),%ebx
  8c55d0:	73 76                	jae    8c5648 <check_lower_drain+0x36a8>
  8c55d2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c55d7:	b2 1e                	mov    $0x1e,%dl
  8c55d9:	48 8b 40 68          	mov    0x68(%rax),%rax
  8c55dd:	8b 04 98             	mov    (%rax,%rbx,4),%eax
  8c55e0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c55e3:	75 25                	jne    8c560a <check_lower_drain+0x366a>
  8c55e5:	48 8b 85 80 00 00 00 	mov    0x80(%rbp),%rax
  8c55ec:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  8c55f1:	8b 04 98             	mov    (%rax,%rbx,4),%eax
  8c55f4:	83 c1 f5             	add    $0xfffffff5,%ecx
  8c55f7:	80 f9 03             	cmp    $0x3,%cl
  8c55fa:	0f 82 cb 04 00 00    	jb     8c5acb <check_lower_drain+0x3b2b>
  8c5600:	b2 20                	mov    $0x20,%dl
  8c5602:	85 c0                	test   %eax,%eax
  8c5604:	0f 84 c1 04 00 00    	je     8c5acb <check_lower_drain+0x3b2b>
  8c560a:	31 ed                	xor    %ebp,%ebp
  8c560c:	83 7c 24 40 23       	cmpl   $0x23,0x40(%rsp)
  8c5611:	0f b6 f2             	movzbl %dl,%esi
  8c5614:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c5619:	0f b6 54 24 70       	movzbl 0x70(%rsp),%edx
  8c561e:	89 c1                	mov    %eax,%ecx
  8c5620:	48 89 df             	mov    %rbx,%rdi
  8c5623:	40 0f 95 c5          	setne  %bpl
  8c5627:	c5 f8 77             	vzeroupper
  8c562a:	e8 e1 0e 00 00       	call   8c6510 <check_lower_instruction>
  8c562f:	45 8b 06             	mov    (%r14),%r8d
  8c5632:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c5637:	48 89 df             	mov    %rbx,%rdi
  8c563a:	89 ea                	mov    %ebp,%edx
  8c563c:	31 c9                	xor    %ecx,%ecx
  8c563e:	e8 8d a4 00 00       	call   8cfad0 <check_lower_operand>
  8c5643:	e9 38 05 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c5648:	83 7c 24 40 1b       	cmpl   $0x1b,0x40(%rsp)
  8c564d:	0f 85 fc 04 00 00    	jne    8c5b4f <check_lower_drain+0x3baf>
  8c5653:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c5658:	0f b6 54 24 70       	movzbl 0x70(%rsp),%edx
  8c565d:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c5662:	31 c9                	xor    %ecx,%ecx
  8c5664:	48 89 df             	mov    %rbx,%rdi
  8c5667:	c5 f8 77             	vzeroupper
  8c566a:	e8 a1 0e 00 00       	call   8c6510 <check_lower_instruction>
  8c566f:	45 8b 06             	mov    (%r14),%r8d
  8c5672:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
  8c5677:	ba 01 00 00 00       	mov    $0x1,%edx
  8c567c:	48 89 df             	mov    %rbx,%rdi
  8c567f:	31 c9                	xor    %ecx,%ecx
  8c5681:	44 89 f6             	mov    %r14d,%esi
  8c5684:	e8 47 a4 00 00       	call   8cfad0 <check_lower_operand>
  8c5689:	48 89 df             	mov    %rbx,%rdi
  8c568c:	44 89 f6             	mov    %r14d,%esi
  8c568f:	e9 01 dc ff ff       	jmp    8c3295 <check_lower_drain+0x12f5>
  8c5694:	84 c9                	test   %cl,%cl
  8c5696:	0f 84 0a 02 00 00    	je     8c58a6 <check_lower_drain+0x3906>
  8c569c:	49 8b 44 24 08       	mov    0x8(%r12),%rax
  8c56a1:	4b 8d 0c 52          	lea    (%r10,%r10,2),%rcx
  8c56a5:	48 c1 e1 05          	shl    $0x5,%rcx
  8c56a9:	8b 04 08             	mov    (%rax,%rcx,1),%eax
  8c56ac:	c1 e8 03             	shr    $0x3,%eax
  8c56af:	3b 44 24 50          	cmp    0x50(%rsp),%eax
  8c56b3:	73 16                	jae    8c56cb <check_lower_drain+0x372b>
  8c56b5:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c56ba:	48 8b 89 a0 01 00 00 	mov    0x1a0(%rcx),%rcx
  8c56c1:	f6 04 01 02          	testb  $0x2,(%rcx,%rax,1)
  8c56c5:	0f 85 1f 02 00 00    	jne    8c58ea <check_lower_drain+0x394a>
  8c56cb:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c56d0:	c1 e8 03             	shr    $0x3,%eax
  8c56d3:	3b 44 24 50          	cmp    0x50(%rsp),%eax
  8c56d7:	73 19                	jae    8c56f2 <check_lower_drain+0x3752>
  8c56d9:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c56de:	48 89 c1             	mov    %rax,%rcx
  8c56e1:	48 8b 82 a0 01 00 00 	mov    0x1a0(%rdx),%rax
  8c56e8:	f6 04 08 02          	testb  $0x2,(%rax,%rcx,1)
  8c56ec:	0f 85 f8 01 00 00    	jne    8c58ea <check_lower_drain+0x394a>
  8c56f2:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c56f7:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c56fc:	c5 f8 77             	vzeroupper
  8c56ff:	e8 3c 0c 01 00       	call   8d6340 <check_lower_update>
  8c5704:	e9 77 04 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c5709:	45 31 c0             	xor    %r8d,%r8d
  8c570c:	44 0f b6 d9          	movzbl %cl,%r11d
  8c5710:	41 8d 53 ff          	lea    -0x1(%r11),%edx
  8c5714:	83 fa 0a             	cmp    $0xa,%edx
  8c5717:	40 0f 93 c6          	setae  %sil
  8c571b:	f7 c1 00 05 00 00    	test   $0x500,%ecx
  8c5721:	41 0f 95 c7          	setne  %r15b
  8c5725:	41 08 f7             	or     %sil,%r15b
  8c5728:	48 89 de             	mov    %rbx,%rsi
  8c572b:	0f 85 0f d1 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c5731:	49 01 ea             	add    %rbp,%r10
  8c5734:	41 83 7a 44 00       	cmpl   $0x0,0x44(%r10)
  8c5739:	0f 85 01 d1 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c573f:	4c 8b bc 24 88 00 00 	mov    0x88(%rsp),%r15
  8c5746:	00 
  8c5747:	43 8b 2c af          	mov    (%r15,%r13,4),%ebp
  8c574b:	85 ed                	test   %ebp,%ebp
  8c574d:	41 0f 94 c7          	sete   %r15b
  8c5751:	45 20 c7             	and    %r8b,%r15b
  8c5754:	41 80 ff 01          	cmp    $0x1,%r15b
  8c5758:	75 2f                	jne    8c5789 <check_lower_drain+0x37e9>
  8c575a:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  8c575f:	45 8d 6c 24 ff       	lea    -0x1(%r12),%r13d
  8c5764:	4d 8b bf 90 02 00 00 	mov    0x290(%r15),%r15
  8c576b:	43 80 3c 2f 00       	cmpb   $0x0,(%r15,%r13,1)
  8c5770:	74 17                	je     8c5789 <check_lower_drain+0x37e9>
  8c5772:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  8c5777:	4d 8b bf 78 02 00 00 	mov    0x278(%r15),%r15
  8c577e:	43 80 3c 2f 00       	cmpb   $0x0,(%r15,%r13,1)
  8c5783:	0f 84 b7 d0 ff ff    	je     8c2840 <check_lower_drain+0x8a0>
  8c5789:	45 8b 6a 0c          	mov    0xc(%r10),%r13d
  8c578d:	45 85 ed             	test   %r13d,%r13d
  8c5790:	74 1f                	je     8c57b1 <check_lower_drain+0x3811>
  8c5792:	41 83 7a 54 00       	cmpl   $0x0,0x54(%r10)
  8c5797:	75 18                	jne    8c57b1 <check_lower_drain+0x3811>
  8c5799:	41 0f b7 72 08       	movzwl 0x8(%r10),%esi
  8c579e:	f7 c6 10 08 00 00    	test   $0x810,%esi
  8c57a4:	75 0b                	jne    8c57b1 <check_lower_drain+0x3811>
  8c57a6:	41 83 7a 04 00       	cmpl   $0x0,0x4(%r10)
  8c57ab:	0f 84 c0 06 00 00    	je     8c5e71 <check_lower_drain+0x3ed1>
  8c57b1:	48 89 de             	mov    %rbx,%rsi
  8c57b4:	85 ed                	test   %ebp,%ebp
  8c57b6:	0f 85 84 d0 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c57bc:	41 83 7a 04 01       	cmpl   $0x1,0x4(%r10)
  8c57c1:	0f 94 c2             	sete   %dl
  8c57c4:	44 20 c2             	and    %r8b,%dl
  8c57c7:	80 fa 01             	cmp    $0x1,%dl
  8c57ca:	0f 85 70 d0 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c57d0:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c57d5:	45 31 d2             	xor    %r10d,%r10d
  8c57d8:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  8c57dc:	46 8b 04 a2          	mov    (%rdx,%r12,4),%r8d
  8c57e0:	49 8b 91 80 00 00 00 	mov    0x80(%r9),%rdx
  8c57e7:	42 8b 14 a2          	mov    (%rdx,%r12,4),%edx
  8c57eb:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
  8c57ef:	41 0f 94 c2          	sete   %r10b
  8c57f3:	41 c1 e2 09          	shl    $0x9,%r10d
  8c57f7:	41 81 c2 00 02 00 00 	add    $0x200,%r10d
  8c57fe:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
  8c5802:	44 0f 44 c2          	cmove  %edx,%r8d
  8c5806:	0f 85 e3 06 00 00    	jne    8c5eef <check_lower_drain+0x3f4f>
  8c580c:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8c5811:	48 89 de             	mov    %rbx,%rsi
  8c5814:	85 d2                	test   %edx,%edx
  8c5816:	0f 84 24 d0 ff ff    	je     8c2840 <check_lower_drain+0x8a0>
  8c581c:	e9 d6 e8 ff ff       	jmp    8c40f7 <check_lower_drain+0x2157>
  8c5821:	48 89 de             	mov    %rbx,%rsi
  8c5824:	41 83 fe 3e          	cmp    $0x3e,%r14d
  8c5828:	77 17                	ja     8c5841 <check_lower_drain+0x38a1>
  8c582a:	49 bf 00 00 00 00 08 	movabs $0x4080000800000000,%r15
  8c5831:	00 80 40 
  8c5834:	44 89 f2             	mov    %r14d,%edx
  8c5837:	49 0f a3 d7          	bt     %rdx,%r15
  8c583b:	0f 82 ff cf ff ff    	jb     8c2840 <check_lower_drain+0x8a0>
  8c5841:	41 83 fd 01          	cmp    $0x1,%r13d
  8c5845:	0f 85 f5 cf ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c584b:	4d 8b 73 10          	mov    0x10(%r11),%r14
  8c584f:	83 7c 24 70 06       	cmpl   $0x6,0x70(%rsp)
  8c5854:	c7 44 24 30 01 00 00 	movl   $0x1,0x30(%rsp)
  8c585b:	00 
  8c585c:	0f 87 30 03 00 00    	ja     8c5b92 <check_lower_drain+0x3bf2>
  8c5862:	41 d1 ec             	shr    $1,%r12d
  8c5865:	ba 08 00 00 00       	mov    $0x8,%edx
  8c586a:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  8c5871:	c4 e2 19 f7 d2       	shlx   %r12d,%edx,%edx
  8c5876:	c4 42 e8 f5 de       	bzhi   %rdx,%r14,%r11
  8c587b:	c4 e2 e9 f7 f6       	shlx   %rdx,%rsi,%rsi
  8c5880:	ff ca                	dec    %edx
  8c5882:	41 be 00 00 00 00    	mov    $0x0,%r14d
  8c5888:	c4 c2 eb f7 d3       	shrx   %rdx,%r11,%rdx
  8c588d:	48 85 d2             	test   %rdx,%rdx
  8c5890:	48 0f 44 f2          	cmove  %rdx,%rsi
  8c5894:	31 d2                	xor    %edx,%edx
  8c5896:	41 f6 c0 01          	test   $0x1,%r8b
  8c589a:	4c 0f 45 f6          	cmovne %rsi,%r14
  8c589e:	4d 09 de             	or     %r11,%r14
  8c58a1:	e9 2e e8 ff ff       	jmp    8c40d4 <check_lower_drain+0x2134>
  8c58a6:	83 7c 24 40 1d       	cmpl   $0x1d,0x40(%rsp)
  8c58ab:	0f 87 3e 01 00 00    	ja     8c59ef <check_lower_drain+0x3a4f>
  8c58b1:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c58b6:	b8 60 00 00 20       	mov    $0x20000060,%eax
  8c58bb:	0f a3 c8             	bt     %ecx,%eax
  8c58be:	0f 83 2b 01 00 00    	jae    8c59ef <check_lower_drain+0x3a4f>
  8c58c4:	4c 8b 7c 24 58       	mov    0x58(%rsp),%r15
  8c58c9:	41 c1 ef 03          	shr    $0x3,%r15d
  8c58cd:	44 3b 7c 24 50       	cmp    0x50(%rsp),%r15d
  8c58d2:	73 2d                	jae    8c5901 <check_lower_drain+0x3961>
  8c58d4:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c58d9:	48 8b 80 a0 01 00 00 	mov    0x1a0(%rax),%rax
  8c58e0:	42 0f b6 1c 38       	movzbl (%rax,%r15,1),%ebx
  8c58e5:	80 e3 08             	and    $0x8,%bl
  8c58e8:	eb 19                	jmp    8c5903 <check_lower_drain+0x3963>
  8c58ea:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c58ef:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c58f4:	c5 f8 77             	vzeroupper
  8c58f7:	e8 e4 05 01 00       	call   8d5ee0 <check_lower_complex_update>
  8c58fc:	e9 7f 02 00 00       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c5901:	31 db                	xor    %ebx,%ebx
  8c5903:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c5908:	c1 e8 03             	shr    $0x3,%eax
  8c590b:	3b 44 24 50          	cmp    0x50(%rsp),%eax
  8c590f:	73 1b                	jae    8c592c <check_lower_drain+0x398c>
  8c5911:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5916:	48 8b 89 a0 01 00 00 	mov    0x1a0(%rcx),%rcx
  8c591d:	44 0f b6 34 01       	movzbl (%rcx,%rax,1),%r14d
  8c5922:	41 80 e6 08          	and    $0x8,%r14b
  8c5926:	41 c0 ee 03          	shr    $0x3,%r14b
  8c592a:	eb 03                	jmp    8c592f <check_lower_drain+0x398f>
  8c592c:	45 31 f6             	xor    %r14d,%r14d
  8c592f:	84 db                	test   %bl,%bl
  8c5931:	75 2e                	jne    8c5961 <check_lower_drain+0x39c1>
  8c5933:	45 84 f6             	test   %r14b,%r14b
  8c5936:	75 29                	jne    8c5961 <check_lower_drain+0x39c1>
  8c5938:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  8c593d:	c5 f8 77             	vzeroupper
  8c5940:	e8 db 19 01 00       	call   8d7320 <check_lower_binary>
  8c5945:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c594a:	0f b6 54 24 70       	movzbl 0x70(%rsp),%edx
  8c594f:	0f b6 f0             	movzbl %al,%esi
  8c5952:	31 c9                	xor    %ecx,%ecx
  8c5954:	48 89 df             	mov    %rbx,%rdi
  8c5957:	e8 b4 0b 00 00       	call   8c6510 <check_lower_instruction>
  8c595c:	e9 ef 04 00 00       	jmp    8c5e50 <check_lower_drain+0x3eb0>
  8c5961:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c5966:	84 db                	test   %bl,%bl
  8c5968:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c596d:	40 0f 95 c5          	setne  %bpl
  8c5971:	41 89 c4             	mov    %eax,%r12d
  8c5974:	44 0f 45 64 24 58    	cmovne 0x58(%rsp),%r12d
  8c597a:	44 89 e6             	mov    %r12d,%esi
  8c597d:	c5 f8 77             	vzeroupper
  8c5980:	e8 fb 16 01 00       	call   8d7080 <check_lower_stride>
  8c5985:	44 20 f5             	and    %r14b,%bpl
  8c5988:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8c598d:	40 80 fd 01          	cmp    $0x1,%bpl
  8c5991:	0f 85 ad 00 00 00    	jne    8c5a44 <check_lower_drain+0x3aa4>
  8c5997:	83 7c 24 40 06       	cmpl   $0x6,0x40(%rsp)
  8c599c:	0f 85 a2 00 00 00    	jne    8c5a44 <check_lower_drain+0x3aa4>
  8c59a2:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c59a7:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c59ad:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c59b3:	0f 83 e0 01 00 00    	jae    8c5b99 <check_lower_drain+0x3bf9>
  8c59b9:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8c59be:	8d 50 01             	lea    0x1(%rax),%edx
  8c59c1:	48 c1 e0 04          	shl    $0x4,%rax
  8c59c5:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c59c9:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c59cf:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c59d6:	00 07 00 
  8c59d9:	48 83 c2 0d          	add    $0xd,%rdx
  8c59dd:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c59e1:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c59e8:	00 00 
  8c59ea:	e9 db 01 00 00       	jmp    8c5bca <check_lower_drain+0x3c2a>
  8c59ef:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  8c59f4:	c5 f8 77             	vzeroupper
  8c59f7:	e8 24 19 01 00       	call   8d7320 <check_lower_binary>
  8c59fc:	84 c0                	test   %al,%al
  8c59fe:	0f 84 1c 02 00 00    	je     8c5c20 <check_lower_drain+0x3c80>
  8c5a04:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c5a09:	0f b6 54 24 70       	movzbl 0x70(%rsp),%edx
  8c5a0e:	0f b6 e8             	movzbl %al,%ebp
  8c5a11:	89 ee                	mov    %ebp,%esi
  8c5a13:	48 89 df             	mov    %rbx,%rdi
  8c5a16:	e8 25 19 01 00       	call   8d7340 <check_lower_operation>
  8c5a1b:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  8c5a20:	48 89 df             	mov    %rbx,%rdi
  8c5a23:	89 ee                	mov    %ebp,%esi
  8c5a25:	44 89 fa             	mov    %r15d,%edx
  8c5a28:	e8 23 1d 01 00       	call   8d7750 <check_lower_count>
  8c5a2d:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
  8c5a32:	48 89 df             	mov    %rbx,%rdi
  8c5a35:	ba 01 00 00 00       	mov    $0x1,%edx
  8c5a3a:	31 c9                	xor    %ecx,%ecx
  8c5a3c:	45 89 f8             	mov    %r15d,%r8d
  8c5a3f:	e9 20 04 00 00       	jmp    8c5e64 <check_lower_drain+0x3ec4>
  8c5a44:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c5a4a:	0f 95 c0             	setne  %al
  8c5a4d:	83 7c 24 40 1d       	cmpl   $0x1d,0x40(%rsp)
  8c5a52:	0f 95 c1             	setne  %cl
  8c5a55:	0a 44 24 48          	or     0x48(%rsp),%al
  8c5a59:	08 c8                	or     %cl,%al
  8c5a5b:	0f 84 e1 01 00 00    	je     8c5c42 <check_lower_drain+0x3ca2>
  8c5a61:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c5a66:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  8c5a6b:	44 89 e6             	mov    %r12d,%esi
  8c5a6e:	e8 2d 17 01 00       	call   8d71a0 <check_lower_scale>
  8c5a73:	83 7c 24 40 06       	cmpl   $0x6,0x40(%rsp)
  8c5a78:	0f 85 ed 01 00 00    	jne    8c5c6b <check_lower_drain+0x3ccb>
  8c5a7e:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5a83:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5a89:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c5a8f:	0f 83 64 04 00 00    	jae    8c5ef9 <check_lower_drain+0x3f59>
  8c5a95:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8c5a9a:	8d 50 01             	lea    0x1(%rax),%edx
  8c5a9d:	48 c1 e0 04          	shl    $0x4,%rax
  8c5aa1:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c5aa5:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c5aab:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c5ab2:	00 07 00 
  8c5ab5:	48 83 c2 06          	add    $0x6,%rdx
  8c5ab9:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c5abd:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c5ac4:	00 00 
  8c5ac6:	e9 a0 01 00 00       	jmp    8c5c6b <check_lower_drain+0x3ccb>
  8c5acb:	83 7c 24 40 1b       	cmpl   $0x1b,0x40(%rsp)
  8c5ad0:	0f 84 7d fb ff ff    	je     8c5653 <check_lower_drain+0x36b3>
  8c5ad6:	85 c0                	test   %eax,%eax
  8c5ad8:	74 75                	je     8c5b4f <check_lower_drain+0x3baf>
  8c5ada:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  8c5adf:	0f b6 54 24 70       	movzbl 0x70(%rsp),%edx
  8c5ae4:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c5ae9:	31 c9                	xor    %ecx,%ecx
  8c5aeb:	4c 89 ff             	mov    %r15,%rdi
  8c5aee:	c5 f8 77             	vzeroupper
  8c5af1:	e8 1a 0a 00 00       	call   8c6510 <check_lower_instruction>
  8c5af6:	45 8b 06             	mov    (%r14),%r8d
  8c5af9:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c5afe:	4c 89 ff             	mov    %r15,%rdi
  8c5b01:	31 d2                	xor    %edx,%edx
  8c5b03:	31 c9                	xor    %ecx,%ecx
  8c5b05:	e8 c6 9f 00 00       	call   8cfad0 <check_lower_operand>
  8c5b0a:	48 8d 84 24 68 01 00 	lea    0x168(%rsp),%rax
  8c5b11:	00 
  8c5b12:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c5b16:	4c 89 ff             	mov    %r15,%rdi
  8c5b19:	c5 fa 7f 00          	vmovdqu %xmm0,(%rax)
  8c5b1d:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8c5b24:	00 
  8c5b25:	c7 84 24 60 01 00 00 	movl   $0xa,0x160(%rsp)
  8c5b2c:	0a 00 00 00 
  8c5b30:	89 9c 24 64 01 00 00 	mov    %ebx,0x164(%rsp)
  8c5b37:	c5 fe 6f 84 24 60 01 	vmovdqu 0x160(%rsp),%ymm0
  8c5b3e:	00 00 
  8c5b40:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c5b45:	c5 f8 77             	vzeroupper
  8c5b48:	e8 73 47 00 00       	call   8ca2c0 <check_lower_push>
  8c5b4d:	eb 31                	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c5b4f:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5b54:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5b58:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5b5f:	75 1f                	jne    8c5b80 <check_lower_drain+0x3be0>
  8c5b61:	c7 80 f0 00 00 00 01 	movl   $0x1,0xf0(%rax)
  8c5b68:	00 00 00 
  8c5b6b:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5b70:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5b76:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5b7a:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5b80:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  8c5b85:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
  8c5b8a:	48 ff c5             	inc    %rbp
  8c5b8d:	e9 6e c4 ff ff       	jmp    8c2000 <check_lower_drain+0x60>
  8c5b92:	31 d2                	xor    %edx,%edx
  8c5b94:	e9 3b e5 ff ff       	jmp    8c40d4 <check_lower_drain+0x2134>
  8c5b99:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5b9e:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5ba2:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5ba9:	75 1f                	jne    8c5bca <check_lower_drain+0x3c2a>
  8c5bab:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5bb0:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5bb7:	00 00 00 
  8c5bba:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5bc0:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5bc4:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5bca:	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
  8c5bd0:	0f 84 d9 00 00 00    	je     8c5caf <check_lower_drain+0x3d0f>
  8c5bd6:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5bdb:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5be1:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c5be7:	0f 83 3f 01 00 00    	jae    8c5d2c <check_lower_drain+0x3d8c>
  8c5bed:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8c5bf2:	8d 50 01             	lea    0x1(%rax),%edx
  8c5bf5:	48 c1 e0 04          	shl    $0x4,%rax
  8c5bf9:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c5bfd:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c5c03:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  8c5c08:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c5c0f:	00 07 00 
  8c5c12:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c5c16:	48 89 74 01 08       	mov    %rsi,0x8(%rcx,%rax,1)
  8c5c1b:	e9 3d 01 00 00       	jmp    8c5d5d <check_lower_drain+0x3dbd>
  8c5c20:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5c25:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5c29:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5c30:	0f 85 4a ff ff ff    	jne    8c5b80 <check_lower_drain+0x3be0>
  8c5c36:	48 8d 0d 07 09 e1 ff 	lea    -0x1ef6f9(%rip),%rcx        # 6d6544 <pp_string_value.meaning+0x22a90>
  8c5c3d:	e9 1c d3 ff ff       	jmp    8c2f5e <check_lower_drain+0xfbe>
  8c5c42:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  8c5c47:	0f b6 54 24 70       	movzbl 0x70(%rsp),%edx
  8c5c4c:	be 0a 00 00 00       	mov    $0xa,%esi
  8c5c51:	31 c9                	xor    %ecx,%ecx
  8c5c53:	4c 89 f7             	mov    %r14,%rdi
  8c5c56:	e8 b5 08 00 00       	call   8c6510 <check_lower_instruction>
  8c5c5b:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  8c5c60:	4c 89 f7             	mov    %r14,%rdi
  8c5c63:	44 89 e6             	mov    %r12d,%esi
  8c5c66:	e8 35 15 01 00       	call   8d71a0 <check_lower_scale>
  8c5c6b:	45 31 f6             	xor    %r14d,%r14d
  8c5c6e:	84 db                	test   %bl,%bl
  8c5c70:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  8c5c75:	41 b8 50 00 00 00    	mov    $0x50,%r8d
  8c5c7b:	41 0f 94 c6          	sete   %r14b
  8c5c7f:	c0 eb 03             	shr    $0x3,%bl
  8c5c82:	31 c9                	xor    %ecx,%ecx
  8c5c84:	0f b6 d3             	movzbl %bl,%edx
  8c5c87:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c5c8c:	44 89 fe             	mov    %r15d,%esi
  8c5c8f:	48 89 df             	mov    %rbx,%rdi
  8c5c92:	e8 39 9e 00 00       	call   8cfad0 <check_lower_operand>
  8c5c97:	48 89 df             	mov    %rbx,%rdi
  8c5c9a:	44 89 fe             	mov    %r15d,%esi
  8c5c9d:	44 89 f2             	mov    %r14d,%edx
  8c5ca0:	31 c9                	xor    %ecx,%ecx
  8c5ca2:	45 89 e0             	mov    %r12d,%r8d
  8c5ca5:	e8 26 9e 00 00       	call   8cfad0 <check_lower_operand>
  8c5caa:	e9 d1 fe ff ff       	jmp    8c5b80 <check_lower_drain+0x3be0>
  8c5caf:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5cb3:	49 8b 45 20          	mov    0x20(%r13),%rax
  8c5cb7:	42 80 3c 39 0f       	cmpb   $0xf,(%rcx,%r15,1)
  8c5cbc:	75 10                	jne    8c5cce <check_lower_drain+0x3d2e>
  8c5cbe:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8c5cc3:	41 89 d4             	mov    %edx,%r12d
  8c5cc6:	41 83 e4 07          	and    $0x7,%r12d
  8c5cca:	46 0b 24 b8          	or     (%rax,%r15,4),%r12d
  8c5cce:	44 89 e2             	mov    %r12d,%edx
  8c5cd1:	c1 ea 03             	shr    $0x3,%edx
  8c5cd4:	41 83 e4 07          	and    $0x7,%r12d
  8c5cd8:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c5cdc:	0f b6 0c 11          	movzbl (%rcx,%rdx,1),%ecx
  8c5ce0:	80 c1 f8             	add    $0xf8,%cl
  8c5ce3:	80 f9 03             	cmp    $0x3,%cl
  8c5ce6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c5ceb:	44 0f 43 e1          	cmovae %ecx,%r12d
  8c5cef:	44 0b 24 90          	or     (%rax,%rdx,4),%r12d
  8c5cf3:	c5 fe 7f 84 24 c0 01 	vmovdqu %ymm0,0x1c0(%rsp)
  8c5cfa:	00 00 
  8c5cfc:	c7 84 24 c0 01 00 00 	movl   $0x13,0x1c0(%rsp)
  8c5d03:	13 00 00 00 
  8c5d07:	44 89 a4 24 c8 01 00 	mov    %r12d,0x1c8(%rsp)
  8c5d0e:	00 
  8c5d0f:	c5 fe 6f 84 24 c0 01 	vmovdqu 0x1c0(%rsp),%ymm0
  8c5d16:	00 00 
  8c5d18:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c5d1d:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c5d22:	c5 f8 77             	vzeroupper
  8c5d25:	e8 96 45 00 00       	call   8ca2c0 <check_lower_push>
  8c5d2a:	eb 31                	jmp    8c5d5d <check_lower_drain+0x3dbd>
  8c5d2c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5d31:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5d35:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5d3c:	75 1f                	jne    8c5d5d <check_lower_drain+0x3dbd>
  8c5d3e:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5d43:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5d4a:	00 00 00 
  8c5d4d:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5d53:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5d57:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5d5d:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5d62:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5d68:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c5d6e:	73 33                	jae    8c5da3 <check_lower_drain+0x3e03>
  8c5d70:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8c5d75:	8d 50 01             	lea    0x1(%rax),%edx
  8c5d78:	48 c1 e0 04          	shl    $0x4,%rax
  8c5d7c:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c5d80:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c5d86:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c5d8d:	00 07 00 
  8c5d90:	48 83 c2 08          	add    $0x8,%rdx
  8c5d94:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c5d98:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c5d9f:	00 00 
  8c5da1:	eb 31                	jmp    8c5dd4 <check_lower_drain+0x3e34>
  8c5da3:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5da8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5dac:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5db3:	75 1f                	jne    8c5dd4 <check_lower_drain+0x3e34>
  8c5db5:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5dba:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5dc1:	00 00 00 
  8c5dc4:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5dca:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5dce:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5dd4:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5dd9:	8b 81 3c 01 00 00    	mov    0x13c(%rcx),%eax
  8c5ddf:	3b 81 40 01 00 00    	cmp    0x140(%rcx),%eax
  8c5de5:	73 33                	jae    8c5e1a <check_lower_drain+0x3e7a>
  8c5de7:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8c5dec:	8d 50 01             	lea    0x1(%rax),%edx
  8c5def:	48 c1 e0 04          	shl    $0x4,%rax
  8c5df3:	48 8b 4e 18          	mov    0x18(%rsi),%rcx
  8c5df7:	89 96 3c 01 00 00    	mov    %edx,0x13c(%rsi)
  8c5dfd:	48 ba 01 00 00 00 01 	movabs $0x8000100000001,%rdx
  8c5e04:	00 08 00 
  8c5e07:	48 83 c2 0b          	add    $0xb,%rdx
  8c5e0b:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c5e0f:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c5e16:	00 00 
  8c5e18:	eb 31                	jmp    8c5e4b <check_lower_drain+0x3eab>
  8c5e1a:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5e1f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5e23:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5e2a:	75 1f                	jne    8c5e4b <check_lower_drain+0x3eab>
  8c5e2c:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5e31:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5e38:	00 00 00 
  8c5e3b:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5e41:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5e45:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5e4b:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8c5e50:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
  8c5e55:	ba 01 00 00 00       	mov    $0x1,%edx
  8c5e5a:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
  8c5e5f:	48 89 df             	mov    %rbx,%rdi
  8c5e62:	31 c9                	xor    %ecx,%ecx
  8c5e64:	44 89 f6             	mov    %r14d,%esi
  8c5e67:	e8 64 9c 00 00       	call   8cfad0 <check_lower_operand>
  8c5e6c:	e9 05 d7 ff ff       	jmp    8c3576 <check_lower_drain+0x15d6>
  8c5e71:	48 89 de             	mov    %rbx,%rsi
  8c5e74:	83 fd 3e             	cmp    $0x3e,%ebp
  8c5e77:	77 17                	ja     8c5e90 <check_lower_drain+0x3ef0>
  8c5e79:	49 b9 00 00 00 00 08 	movabs $0x4080000800000000,%r9
  8c5e80:	00 80 40 
  8c5e83:	41 89 e8             	mov    %ebp,%r8d
  8c5e86:	4d 0f a3 c1          	bt     %r8,%r9
  8c5e8a:	0f 82 b0 c9 ff ff    	jb     8c2840 <check_lower_drain+0x8a0>
  8c5e90:	41 83 fd 01          	cmp    $0x1,%r13d
  8c5e94:	0f 85 a6 c9 ff ff    	jne    8c2840 <check_lower_drain+0x8a0>
  8c5e9a:	4d 8b 42 10          	mov    0x10(%r10),%r8
  8c5e9e:	41 ba 00 01 00 00    	mov    $0x100,%r10d
  8c5ea4:	41 83 fb 06          	cmp    $0x6,%r11d
  8c5ea8:	77 45                	ja     8c5eef <check_lower_drain+0x3f4f>
  8c5eaa:	d1 ea                	shr    $1,%edx
  8c5eac:	be 08 00 00 00       	mov    $0x8,%esi
  8c5eb1:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
  8c5eb8:	c4 e2 69 f7 d6       	shlx   %edx,%esi,%edx
  8c5ebd:	c4 c2 e9 f7 f1       	shlx   %rdx,%r9,%rsi
  8c5ec2:	c4 42 e8 f5 c8       	bzhi   %rdx,%r8,%r9
  8c5ec7:	ff ca                	dec    %edx
  8c5ec9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8c5ecf:	c4 c2 eb f7 d1       	shrx   %rdx,%r9,%rdx
  8c5ed4:	48 85 d2             	test   %rdx,%rdx
  8c5ed7:	48 0f 44 f2          	cmove  %rdx,%rsi
  8c5edb:	f6 c1 01             	test   $0x1,%cl
  8c5ede:	4c 0f 45 c6          	cmovne %rsi,%r8
  8c5ee2:	4d 09 c8             	or     %r9,%r8
  8c5ee5:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8c5eea:	e9 08 e2 ff ff       	jmp    8c40f7 <check_lower_drain+0x2157>
  8c5eef:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8c5ef4:	e9 fe e1 ff ff       	jmp    8c40f7 <check_lower_drain+0x2157>
  8c5ef9:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5efe:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5f02:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5f09:	0f 85 5c fd ff ff    	jne    8c5c6b <check_lower_drain+0x3ccb>
  8c5f0f:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c5f14:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5f1b:	00 00 00 
  8c5f1e:	8b 81 64 01 00 00    	mov    0x164(%rcx),%eax
  8c5f24:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c5f28:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5f2e:	e9 38 fd ff ff       	jmp    8c5c6b <check_lower_drain+0x3ccb>
  8c5f33:	49 01 ad 00 02 00 00 	add    %rbp,0x200(%r13)
  8c5f3a:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c5f41:	00 00 
  8c5f43:	48 3b 84 24 00 02 00 	cmp    0x200(%rsp),%rax
  8c5f4a:	00 
  8c5f4b:	75 15                	jne    8c5f62 <check_lower_drain+0x3fc2>
  8c5f4d:	48 81 c4 08 02 00 00 	add    $0x208,%rsp
  8c5f54:	5b                   	pop    %rbx
  8c5f55:	41 5c                	pop    %r12
  8c5f57:	41 5d                	pop    %r13
  8c5f59:	41 5e                	pop    %r14
  8c5f5b:	41 5f                	pop    %r15
  8c5f5d:	5d                   	pop    %rbp
  8c5f5e:	c5 f8 77             	vzeroupper
  8c5f61:	c3                   	ret
  8c5f62:	c5 f8 77             	vzeroupper
  8c5f65:	e8 c6 7f f0 ff       	call   7cdf30 <__stack_chk_fail@plt>
