
/home/david/buster-fast-bench/codex-180-fix-20261026-caller-fixed/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000cac2e0 <x86_match_initialize>:
  cac2e0:	55                   	push   %rbp
  cac2e1:	41 57                	push   %r15
  cac2e3:	41 56                	push   %r14
  cac2e5:	41 55                	push   %r13
  cac2e7:	41 54                	push   %r12
  cac2e9:	53                   	push   %rbx
  cac2ea:	48 81 ec 08 69 00 00 	sub    $0x6908,%rsp
  cac2f1:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
  cac2fa:	ba a8 66 06 00       	mov    $0x666a8,%edx
  cac2ff:	49 89 f6             	mov    %rsi,%r14
  cac302:	31 f6                	xor    %esi,%esi
  cac304:	48 89 fb             	mov    %rdi,%rbx
  cac307:	48 89 84 24 00 69 00 00 	mov    %rax,0x6900(%rsp)
  cac30f:	e8 1c 80 ab ff       	call   764330 <memset@plt>
  cac314:	49 8b 06             	mov    (%r14),%rax
  cac317:	c4 e2 79 78 0d 60 ab 7a ff 	vpbroadcastb -0x8554a0(%rip),%xmm1        # 456e80 <files_test_contexts.directories.rel+0xac4>
  cac320:	89 c1                	mov    %eax,%ecx
  cac322:	48 c1 e8 12          	shr    $0x12,%rax
  cac326:	81 e1 ff ff ff 00    	and    $0xffffff,%ecx
  cac32c:	25 00 00 00 01       	and    $0x1000000,%eax
  cac331:	09 c8                	or     %ecx,%eax
  cac333:	48 8d 0d 06 b0 79 ff 	lea    -0x864ffa(%rip),%rcx        # 447340 <x86_target_compact_requirements>
  cac33a:	35 ff ff ff 7f       	xor    $0x7fffffff,%eax
  cac33f:	62 f2 7d 48 7c c0    	vpbroadcastd %eax,%zmm0
  cac345:	48 c7 c0 70 ff ff ff 	mov    $0xffffffffffffff70,%rax
  cac34c:	0f 1f 40 00          	nopl   0x0(%rax)
  cac350:	62 f1 fd 48 6f 54 81 09 	vmovdqa64 0x240(%rcx,%rax,4),%zmm2
  cac358:	62 f1 fd 48 6f 5c 81 0a 	vmovdqa64 0x280(%rcx,%rax,4),%zmm3
  cac360:	62 f1 fd 48 6f 64 81 0b 	vmovdqa64 0x2c0(%rcx,%rax,4),%zmm4
  cac368:	62 f1 fd 48 6f 6c 81 0c 	vmovdqa64 0x300(%rcx,%rax,4),%zmm5
  cac370:	62 f2 6e 48 27 c8    	vptestnmd %zmm0,%zmm2,%k1
  cac376:	62 f2 6d 49 27 ca    	vptestmd %zmm2,%zmm2,%k1{%k1}
  cac37c:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac382:	62 f2 66 48 27 c8    	vptestnmd %zmm0,%zmm3,%k1
  cac388:	c5 fa 7f 94 03 94 37 03 00 	vmovdqu %xmm2,0x33794(%rbx,%rax,1)
  cac391:	62 f2 65 49 27 cb    	vptestmd %zmm3,%zmm3,%k1{%k1}
  cac397:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac39d:	62 f2 5e 48 27 c8    	vptestnmd %zmm0,%zmm4,%k1
  cac3a3:	c5 fa 7f 94 03 a4 37 03 00 	vmovdqu %xmm2,0x337a4(%rbx,%rax,1)
  cac3ac:	62 f2 5d 49 27 cc    	vptestmd %zmm4,%zmm4,%k1{%k1}
  cac3b2:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac3b8:	62 f2 56 48 27 c8    	vptestnmd %zmm0,%zmm5,%k1
  cac3be:	c5 fa 7f 94 03 b4 37 03 00 	vmovdqu %xmm2,0x337b4(%rbx,%rax,1)
  cac3c7:	62 f2 55 49 27 cd    	vptestmd %zmm5,%zmm5,%k1{%k1}
  cac3cd:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac3d3:	c5 fa 7f 94 03 c4 37 03 00 	vmovdqu %xmm2,0x337c4(%rbx,%rax,1)
  cac3dc:	62 f1 fd 48 6f 54 81 0d 	vmovdqa64 0x340(%rcx,%rax,4),%zmm2
  cac3e4:	62 f2 6e 48 27 c8    	vptestnmd %zmm0,%zmm2,%k1
  cac3ea:	62 f2 6d 49 27 ca    	vptestmd %zmm2,%zmm2,%k1{%k1}
  cac3f0:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac3f6:	c5 fa 7f 94 03 d4 37 03 00 	vmovdqu %xmm2,0x337d4(%rbx,%rax,1)
  cac3ff:	62 f1 fd 48 6f 54 81 0e 	vmovdqa64 0x380(%rcx,%rax,4),%zmm2
  cac407:	62 f2 6e 48 27 c8    	vptestnmd %zmm0,%zmm2,%k1
  cac40d:	62 f2 6d 49 27 ca    	vptestmd %zmm2,%zmm2,%k1{%k1}
  cac413:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac419:	c5 fa 7f 94 03 e4 37 03 00 	vmovdqu %xmm2,0x337e4(%rbx,%rax,1)
  cac422:	62 f1 fd 48 6f 54 81 0f 	vmovdqa64 0x3c0(%rcx,%rax,4),%zmm2
  cac42a:	62 f2 6e 48 27 c8    	vptestnmd %zmm0,%zmm2,%k1
  cac430:	62 f2 6d 49 27 ca    	vptestmd %zmm2,%zmm2,%k1{%k1}
  cac436:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac43c:	c5 fa 7f 94 03 f4 37 03 00 	vmovdqu %xmm2,0x337f4(%rbx,%rax,1)
  cac445:	62 f1 fd 48 6f 54 81 10 	vmovdqa64 0x400(%rcx,%rax,4),%zmm2
  cac44d:	62 f2 6e 48 27 c8    	vptestnmd %zmm0,%zmm2,%k1
  cac453:	62 f2 6d 49 27 ca    	vptestmd %zmm2,%zmm2,%k1{%k1}
  cac459:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac45f:	c5 fa 7f 94 03 04 38 03 00 	vmovdqu %xmm2,0x33804(%rbx,%rax,1)
  cac468:	62 f1 fd 48 6f 54 81 11 	vmovdqa64 0x440(%rcx,%rax,4),%zmm2
  cac470:	62 f2 6e 48 27 c8    	vptestnmd %zmm0,%zmm2,%k1
  cac476:	62 f2 6d 49 27 ca    	vptestmd %zmm2,%zmm2,%k1{%k1}
  cac47c:	62 f1 7f 89 6f d1    	vmovdqu8 %xmm1,%xmm2{%k1}{z}
  cac482:	c5 fa 7f 94 03 14 38 03 00 	vmovdqu %xmm2,0x33814(%rbx,%rax,1)
  cac48b:	48 05 90 00 00 00    	add    $0x90,%rax
  cac491:	48 3d 10 20 00 00    	cmp    $0x2010,%rax
  cac497:	0f 82 b3 fe ff ff    	jb     cac350 <x86_match_initialize+0x70>
  cac49d:	4c 8d 35 5c e8 da 00 	lea    0xdae85c(%rip),%r14        # 1a5ad00 <x86_form_descriptions>
  cac4a4:	41 bd 04 37 03 00    	mov    $0x33704,%r13d
  cac4aa:	31 ed                	xor    %ebp,%ebp
  cac4ac:	31 d2                	xor    %edx,%edx
  cac4ae:	eb 19                	jmp    cac4c9 <x86_match_initialize+0x1e9>
  cac4b0:	31 d2                	xor    %edx,%edx
  cac4b2:	4c 89 f5             	mov    %r14,%rbp
  cac4b5:	49 83 c6 28          	add    $0x28,%r14
  cac4b9:	49 ff c5             	inc    %r13
  cac4bc:	49 81 fd 35 57 03 00 	cmp    $0x35735,%r13
  cac4c3:	0f 84 2d 01 00 00    	je     cac5f6 <x86_match_initialize+0x316>
  cac4c9:	42 c6 84 2c bc 11 fd ff 00 	movb   $0x0,-0x2ee44(%rsp,%r13,1)
  cac4d2:	42 80 3c 2b 00       	cmpb   $0x0,(%rbx,%r13,1)
  cac4d7:	74 dc                	je     cac4b5 <x86_match_initialize+0x1d5>
  cac4d9:	48 85 ed             	test   %rbp,%rbp
  cac4dc:	74 32                	je     cac510 <x86_match_initialize+0x230>
  cac4de:	48 8b 45 00          	mov    0x0(%rbp),%rax
  cac4e2:	49 3b 06             	cmp    (%r14),%rax
  cac4e5:	75 29                	jne    cac510 <x86_match_initialize+0x230>
  cac4e7:	0f b6 45 1c          	movzbl 0x1c(%rbp),%eax
  cac4eb:	41 3a 46 1c          	cmp    0x1c(%r14),%al
  cac4ef:	75 1f                	jne    cac510 <x86_match_initialize+0x230>
  cac4f1:	0f b6 45 1d          	movzbl 0x1d(%rbp),%eax
  cac4f5:	41 3a 46 1d          	cmp    0x1d(%r14),%al
  cac4f9:	75 15                	jne    cac510 <x86_match_initialize+0x230>
  cac4fb:	0f b6 45 11          	movzbl 0x11(%rbp),%eax
  cac4ff:	41 3a 46 11          	cmp    0x11(%r14),%al
  cac503:	75 0b                	jne    cac510 <x86_match_initialize+0x230>
  cac505:	f6 c2 01             	test   $0x1,%dl
  cac508:	75 18                	jne    cac522 <x86_match_initialize+0x242>
  cac50a:	31 d2                	xor    %edx,%edx
  cac50c:	eb a7                	jmp    cac4b5 <x86_match_initialize+0x1d5>
  cac50e:	66 90                	xchg   %ax,%ax
  cac510:	4c 89 f7             	mov    %r14,%rdi
  cac513:	c5 f8 77             	vzeroupper
  cac516:	e8 25 97 00 00       	call   cb5c40 <x86_match_supported>
  cac51b:	4c 89 f5             	mov    %r14,%rbp
  cac51e:	84 c0                	test   %al,%al
  cac520:	74 8e                	je     cac4b0 <x86_match_initialize+0x1d0>
  cac522:	41 0f b6 46 1b       	movzbl 0x1b(%r14),%eax
  cac527:	b2 01                	mov    $0x1,%dl
  cac529:	48 83 f8 26          	cmp    $0x26,%rax
  cac52d:	77 86                	ja     cac4b5 <x86_match_initialize+0x1d5>
  cac52f:	48 b9 ff 37 03 00 40 00 00 00 	movabs $0x40000337ff,%rcx
  cac539:	48 0f a3 c1          	bt     %rax,%rcx
  cac53d:	0f 83 72 ff ff ff    	jae    cac4b5 <x86_match_initialize+0x1d5>
  cac543:	4d 8b 3e             	mov    (%r14),%r15
  cac546:	42 c6 84 2c bc 11 fd ff 01 	movb   $0x1,-0x2ee44(%rsp,%r13,1)
  cac54f:	4c 89 ff             	mov    %r15,%rdi
  cac552:	c5 f8 77             	vzeroupper
  cac555:	e8 a6 78 ab ff       	call   763e00 <strlen@plt>
  cac55a:	48 83 f8 05          	cmp    $0x5,%rax
  cac55e:	74 37                	je     cac597 <x86_match_initialize+0x2b7>
  cac560:	49 89 c4             	mov    %rax,%r12
  cac563:	48 83 f8 06          	cmp    $0x6,%rax
  cac567:	75 58                	jne    cac5c1 <x86_match_initialize+0x2e1>
  cac569:	41 0f b7 77 04       	movzwl 0x4(%r15),%esi
  cac56e:	41 8b 07             	mov    (%r15),%eax
  cac571:	b9 6d 6f 76 61       	mov    $0x61766f6d,%ecx
  cac576:	31 d2                	xor    %edx,%edx
  cac578:	31 c8                	xor    %ecx,%eax
  cac57a:	81 f6 62 73 00 00    	xor    $0x7362,%esi
  cac580:	09 c6                	or     %eax,%esi
  cac582:	48 8d 05 7b 5b 93 ff 	lea    -0x6ca485(%rip),%rax        # 5e2104 <foreign_touch.flags+0xebd7>
  cac589:	0f 95 c2             	setne  %dl
  cac58c:	4c 0f 44 f8          	cmove  %rax,%r15
  cac590:	4c 8d 64 52 03       	lea    0x3(%rdx,%rdx,2),%r12
  cac595:	eb 2a                	jmp    cac5c1 <x86_match_initialize+0x2e1>
  cac597:	41 0f b6 57 04       	movzbl 0x4(%r15),%edx
  cac59c:	41 8b 07             	mov    (%r15),%eax
  cac59f:	b9 70 75 73 68       	mov    $0x68737570,%ecx
  cac5a4:	45 31 e4             	xor    %r12d,%r12d
  cac5a7:	31 c8                	xor    %ecx,%eax
  cac5a9:	83 f2 77             	xor    $0x77,%edx
  cac5ac:	09 c2                	or     %eax,%edx
  cac5ae:	48 8d 05 97 6f 8d ff 	lea    -0x729069(%rip),%rax        # 58354c <c_fragment_reader_cursor_tests.leaf_phases+0x118>
  cac5b5:	41 0f 94 c4          	sete   %r12b
  cac5b9:	4c 0f 44 f8          	cmove  %rax,%r15
  cac5bd:	49 83 f4 05          	xor    $0x5,%r12
  cac5c1:	48 89 df             	mov    %rbx,%rdi
  cac5c4:	4c 89 fe             	mov    %r15,%rsi
  cac5c7:	4c 89 e2             	mov    %r12,%rdx
  cac5ca:	e8 71 9e 00 00       	call   cb6440 <x86_match_bucket>
  cac5cf:	89 c1                	mov    %eax,%ecx
  cac5d1:	c1 e1 04             	shl    $0x4,%ecx
  cac5d4:	b2 01                	mov    $0x1,%dl
  cac5d6:	4c 89 3c 0b          	mov    %r15,(%rbx,%rcx,1)
  cac5da:	4c 89 64 0b 08       	mov    %r12,0x8(%rbx,%rcx,1)
  cac5df:	66 42 89 84 6c 48 9a f9 ff 	mov    %ax,-0x665b8(%rsp,%r13,2)
  cac5e8:	89 c0                	mov    %eax,%eax
  cac5ea:	ff 84 83 04 20 00 00 	incl   0x2004(%rbx,%rax,4)
  cac5f1:	e9 bf fe ff ff       	jmp    cac4b5 <x86_match_initialize+0x1d5>
  cac5f6:	48 8d b3 00 20 00 00 	lea    0x2000(%rbx),%rsi
  cac5fd:	31 c9                	xor    %ecx,%ecx
  cac5ff:	31 c0                	xor    %eax,%eax
  cac601:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  cac610:	03 84 8b 04 20 00 00 	add    0x2004(%rbx,%rcx,4),%eax
  cac617:	89 84 8b 04 20 00 00 	mov    %eax,0x2004(%rbx,%rcx,4)
  cac61e:	03 84 8b 08 20 00 00 	add    0x2008(%rbx,%rcx,4),%eax
  cac625:	89 84 8b 08 20 00 00 	mov    %eax,0x2008(%rbx,%rcx,4)
  cac62c:	03 84 8b 0c 20 00 00 	add    0x200c(%rbx,%rcx,4),%eax
  cac633:	89 84 8b 0c 20 00 00 	mov    %eax,0x200c(%rbx,%rcx,4)
  cac63a:	03 84 8b 10 20 00 00 	add    0x2010(%rbx,%rcx,4),%eax
  cac641:	89 84 8b 10 20 00 00 	mov    %eax,0x2010(%rbx,%rcx,4)
  cac648:	03 84 8b 14 20 00 00 	add    0x2014(%rbx,%rcx,4),%eax
  cac64f:	89 84 8b 14 20 00 00 	mov    %eax,0x2014(%rbx,%rcx,4)
  cac656:	03 84 8b 18 20 00 00 	add    0x2018(%rbx,%rcx,4),%eax
  cac65d:	89 84 8b 18 20 00 00 	mov    %eax,0x2018(%rbx,%rcx,4)
  cac664:	03 84 8b 1c 20 00 00 	add    0x201c(%rbx,%rcx,4),%eax
  cac66b:	89 84 8b 1c 20 00 00 	mov    %eax,0x201c(%rbx,%rcx,4)
  cac672:	03 84 8b 20 20 00 00 	add    0x2020(%rbx,%rcx,4),%eax
  cac679:	89 84 8b 20 20 00 00 	mov    %eax,0x2020(%rbx,%rcx,4)
  cac680:	03 84 8b 24 20 00 00 	add    0x2024(%rbx,%rcx,4),%eax
  cac687:	89 84 8b 24 20 00 00 	mov    %eax,0x2024(%rbx,%rcx,4)
  cac68e:	03 84 8b 28 20 00 00 	add    0x2028(%rbx,%rcx,4),%eax
  cac695:	89 84 8b 28 20 00 00 	mov    %eax,0x2028(%rbx,%rcx,4)
  cac69c:	03 84 8b 2c 20 00 00 	add    0x202c(%rbx,%rcx,4),%eax
  cac6a3:	89 84 8b 2c 20 00 00 	mov    %eax,0x202c(%rbx,%rcx,4)
  cac6aa:	03 84 8b 30 20 00 00 	add    0x2030(%rbx,%rcx,4),%eax
  cac6b1:	89 84 8b 30 20 00 00 	mov    %eax,0x2030(%rbx,%rcx,4)
  cac6b8:	03 84 8b 34 20 00 00 	add    0x2034(%rbx,%rcx,4),%eax
  cac6bf:	89 84 8b 34 20 00 00 	mov    %eax,0x2034(%rbx,%rcx,4)
  cac6c6:	03 84 8b 38 20 00 00 	add    0x2038(%rbx,%rcx,4),%eax
  cac6cd:	89 84 8b 38 20 00 00 	mov    %eax,0x2038(%rbx,%rcx,4)
  cac6d4:	03 84 8b 3c 20 00 00 	add    0x203c(%rbx,%rcx,4),%eax
  cac6db:	89 84 8b 3c 20 00 00 	mov    %eax,0x203c(%rbx,%rcx,4)
  cac6e2:	03 84 8b 40 20 00 00 	add    0x2040(%rbx,%rcx,4),%eax
  cac6e9:	89 84 8b 40 20 00 00 	mov    %eax,0x2040(%rbx,%rcx,4)
  cac6f0:	48 83 c1 10          	add    $0x10,%rcx
  cac6f4:	48 81 f9 00 02 00 00 	cmp    $0x200,%rcx
  cac6fb:	0f 85 0f ff ff ff    	jne    cac610 <x86_match_initialize+0x330>
  cac701:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  cac706:	ba 00 08 00 00       	mov    $0x800,%edx
  cac70b:	c5 f8 77             	vzeroupper
  cac70e:	e8 3d 7d ab ff       	call   764450 <memcpy@plt>
  cac713:	31 f6                	xor    %esi,%esi
  cac715:	eb 4e                	jmp    cac765 <x86_match_initialize+0x485>
  cac717:	b8 00 00 00 02       	mov    $0x2000000,%eax
  cac71c:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  cac722:	41 83 fa 01          	cmp    $0x1,%r10d
  cac726:	4d 0f 44 c7          	cmove  %r15,%r8
  cac72a:	41 c1 e2 10          	shl    $0x10,%r10d
  cac72e:	41 c1 e3 04          	shl    $0x4,%r11d
  cac732:	41 0f b6 08          	movzbl (%r8),%ecx
  cac736:	41 09 ea             	or     %ebp,%r10d
  cac739:	45 09 da             	or     %r11d,%r10d
  cac73c:	41 09 c2             	or     %eax,%r10d
  cac73f:	49 69 c1 80 82 00 00 	imul   $0x8280,%r9,%rax
  cac746:	c1 e1 08             	shl    $0x8,%ecx
  cac749:	41 09 ca             	or     %ecx,%r10d
  cac74c:	45 89 14 04          	mov    %r10d,(%r12,%rax,1)
  cac750:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  cac755:	48 ff c6             	inc    %rsi
  cac758:	48 81 fe 31 20 00 00 	cmp    $0x2031,%rsi
  cac75f:	0f 84 bf 09 00 00    	je     cad124 <x86_match_initialize+0xe44>
  cac765:	80 bc 34 c0 48 00 00 01 	cmpb   $0x1,0x48c0(%rsp,%rsi,1)
  cac76d:	75 e6                	jne    cac755 <x86_match_initialize+0x475>
  cac76f:	48 8d 04 b6          	lea    (%rsi,%rsi,4),%rax
  cac773:	48 8d 0d 86 e5 da 00 	lea    0xdae586(%rip),%rcx        # 1a5ad00 <x86_form_descriptions>
  cac77a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  cac77f:	41 b0 01             	mov    $0x1,%r8b
  cac782:	4c 8d 3c c1          	lea    (%rcx,%rax,8),%r15
  cac786:	0f b6 4c c1 1b       	movzbl 0x1b(%rcx,%rax,8),%ecx
  cac78b:	31 c0                	xor    %eax,%eax
  cac78d:	48 83 f9 26          	cmp    $0x26,%rcx
  cac791:	0f 87 db 00 00 00    	ja     cac872 <x86_match_initialize+0x592>
  cac797:	48 8d 15 e6 a6 7a ff 	lea    -0x85591a(%rip),%rdx        # 456e84 <files_test_contexts.directories.rel+0xac8>
  cac79e:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  cac7a2:	48 01 d1             	add    %rdx,%rcx
  cac7a5:	ff e1                	jmp    *%rcx
  cac7a7:	b1 01                	mov    $0x1,%cl
  cac7a9:	45 31 c0             	xor    %r8d,%r8d
  cac7ac:	31 ff                	xor    %edi,%edi
  cac7ae:	89 0c 24             	mov    %ecx,(%rsp)
  cac7b1:	e9 c3 00 00 00       	jmp    cac879 <x86_match_initialize+0x599>
  cac7b6:	66 c7 44 24 4c 02 03 	movw   $0x302,0x4c(%rsp)
  cac7bd:	c6 44 24 4e 01       	movb   $0x1,0x4e(%rsp)
  cac7c2:	bf 03 00 00 00       	mov    $0x3,%edi
  cac7c7:	e9 a6 00 00 00       	jmp    cac872 <x86_match_initialize+0x592>
  cac7cc:	c6 44 24 4c 04       	movb   $0x4,0x4c(%rsp)
  cac7d1:	eb 69                	jmp    cac83c <x86_match_initialize+0x55c>
  cac7d3:	66 c7 44 24 4c 06 04 	movw   $0x406,0x4c(%rsp)
  cac7da:	e9 8e 00 00 00       	jmp    cac86d <x86_match_initialize+0x58d>
  cac7df:	66 c7 44 24 4c 01 02 	movw   $0x201,0x4c(%rsp)
  cac7e6:	e9 82 00 00 00       	jmp    cac86d <x86_match_initialize+0x58d>
  cac7eb:	66 c7 44 24 4c 02 01 	movw   $0x102,0x4c(%rsp)
  cac7f2:	eb 15                	jmp    cac809 <x86_match_initialize+0x529>
  cac7f4:	c6 44 24 4c 05       	movb   $0x5,0x4c(%rsp)
  cac7f9:	eb 41                	jmp    cac83c <x86_match_initialize+0x55c>
  cac7fb:	c6 44 24 4c 01       	movb   $0x1,0x4c(%rsp)
  cac800:	eb 3a                	jmp    cac83c <x86_match_initialize+0x55c>
  cac802:	66 c7 44 24 4c 01 02 	movw   $0x201,0x4c(%rsp)
  cac809:	c6 44 24 4e 04       	movb   $0x4,0x4e(%rsp)
  cac80e:	bf 03 00 00 00       	mov    $0x3,%edi
  cac813:	eb 5d                	jmp    cac872 <x86_match_initialize+0x592>
  cac815:	66 c7 44 24 4c 01 02 	movw   $0x201,0x4c(%rsp)
  cac81c:	c6 44 24 4e 07       	movb   $0x7,0x4e(%rsp)
  cac821:	bf 03 00 00 00       	mov    $0x3,%edi
  cac826:	eb 4a                	jmp    cac872 <x86_match_initialize+0x592>
  cac828:	bf 04 00 00 00       	mov    $0x4,%edi
  cac82d:	c7 44 24 4c 02 03 01 04 	movl   $0x4010302,0x4c(%rsp)
  cac835:	eb 3b                	jmp    cac872 <x86_match_initialize+0x592>
  cac837:	c6 44 24 4c 02       	movb   $0x2,0x4c(%rsp)
  cac83c:	b1 01                	mov    $0x1,%cl
  cac83e:	bf 01 00 00 00       	mov    $0x1,%edi
  cac843:	41 b0 01             	mov    $0x1,%r8b
  cac846:	89 0c 24             	mov    %ecx,(%rsp)
  cac849:	eb 2e                	jmp    cac879 <x86_match_initialize+0x599>
  cac84b:	66 c7 44 24 4c 02 01 	movw   $0x102,0x4c(%rsp)
  cac852:	eb 19                	jmp    cac86d <x86_match_initialize+0x58d>
  cac854:	66 c7 44 24 4c 01 04 	movw   $0x401,0x4c(%rsp)
  cac85b:	eb 10                	jmp    cac86d <x86_match_initialize+0x58d>
  cac85d:	66 c7 44 24 4c 01 07 	movw   $0x701,0x4c(%rsp)
  cac864:	eb 07                	jmp    cac86d <x86_match_initialize+0x58d>
  cac866:	66 c7 44 24 4c 01 08 	movw   $0x801,0x4c(%rsp)
  cac86d:	bf 02 00 00 00       	mov    $0x2,%edi
  cac872:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  cac879:	0f b7 8c 74 50 08 00 00 	movzwl 0x850(%rsp,%rsi,2),%ecx
  cac881:	44 89 44 24 04       	mov    %r8d,0x4(%rsp)
  cac886:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  cac88b:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  cac890:	44 8b 64 8c 50       	mov    0x50(%rsp,%rcx,4),%r12d
  cac895:	41 8d 54 24 01       	lea    0x1(%r12),%edx
  cac89a:	89 54 8c 50          	mov    %edx,0x50(%rsp,%rcx,4)
  cac89e:	42 89 b4 a3 04 28 00 00 	mov    %esi,0x2804(%rbx,%r12,4)
  cac8a6:	42 89 bc a3 84 aa 00 00 	mov    %edi,0xaa84(%rbx,%r12,4)
  cac8ae:	41 0f b7 6f 20       	movzwl 0x20(%r15),%ebp
  cac8b3:	40 f6 c5 04          	test   $0x4,%bpl
  cac8b7:	74 0c                	je     cac8c5 <x86_match_initialize+0x5e5>
  cac8b9:	b0 40                	mov    $0x40,%al
  cac8bb:	0f b6 c0             	movzbl %al,%eax
  cac8be:	41 f6 77 22          	divb   0x22(%r15)
  cac8c2:	0f b6 c0             	movzbl %al,%eax
  cac8c5:	42 89 84 a3 a4 57 03 00 	mov    %eax,0x357a4(%rbx,%r12,4)
  cac8cd:	45 0f b6 77 1a       	movzbl 0x1a(%r15),%r14d
  cac8d2:	4d 8b 2f             	mov    (%r15),%r13
  cac8d5:	45 85 f6             	test   %r14d,%r14d
  cac8d8:	0f 84 b8 01 00 00    	je     caca96 <x86_match_initialize+0x7b6>
  cac8de:	44 89 74 24 10       	mov    %r14d,0x10(%rsp)
  cac8e3:	48 8d 35 1d e9 8e ff 	lea    -0x7116e3(%rip),%rsi        # 59b207 <parse_test_openers+0x1004e>
  cac8ea:	4c 89 ef             	mov    %r13,%rdi
  cac8ed:	89 6c 24 2c          	mov    %ebp,0x2c(%rsp)
  cac8f1:	4c 89 64 24 38       	mov    %r12,0x38(%rsp)
  cac8f6:	4c 89 7c 24 20       	mov    %r15,0x20(%rsp)
  cac8fb:	e8 a0 7b ab ff       	call   7644a0 <strcmp@plt>
  cac900:	31 ed                	xor    %ebp,%ebp
  cac902:	85 c0                	test   %eax,%eax
  cac904:	48 8d 35 74 45 9f ff 	lea    -0x60ba8c(%rip),%rsi        # 6a0e7f <pp_string_value.meaning+0x43c33>
  cac90b:	4c 89 ef             	mov    %r13,%rdi
  cac90e:	0f 94 44 24 0f       	sete   0xf(%rsp)
  cac913:	e8 88 7b ab ff       	call   7644a0 <strcmp@plt>
  cac918:	45 31 e4             	xor    %r12d,%r12d
  cac91b:	85 c0                	test   %eax,%eax
  cac91d:	44 89 74 24 08       	mov    %r14d,0x8(%rsp)
  cac922:	4c 89 6c 24 30       	mov    %r13,0x30(%rsp)
  cac927:	41 0f 94 c7          	sete   %r15b
  cac92b:	31 c9                	xor    %ecx,%ecx
  cac92d:	41 83 fe 02          	cmp    $0x2,%r14d
  cac931:	0f 95 c2             	setne  %dl
  cac934:	0f 94 c0             	sete   %al
  cac937:	44 08 fa             	or     %r15b,%dl
  cac93a:	74 04                	je     cac940 <x86_match_initialize+0x660>
  cac93c:	88 c1                	mov    %al,%cl
  cac93e:	eb 16                	jmp    cac956 <x86_match_initialize+0x676>
  cac940:	48 8d 35 05 6c 8d ff 	lea    -0x7293fb(%rip),%rsi        # 58354c <c_fragment_reader_cursor_tests.leaf_phases+0x118>
  cac947:	4c 89 ef             	mov    %r13,%rdi
  cac94a:	e8 51 7b ab ff       	call   7644a0 <strcmp@plt>
  cac94f:	31 c9                	xor    %ecx,%ecx
  cac951:	85 c0                	test   %eax,%eax
  cac953:	0f 94 c1             	sete   %cl
  cac956:	45 88 fc             	mov    %r15b,%r12b
  cac959:	4c 8b 7c 24 20       	mov    0x20(%rsp),%r15
  cac95e:	0f b6 44 24 0f       	movzbl 0xf(%rsp),%eax
  cac963:	44 8b 74 24 2c       	mov    0x2c(%rsp),%r14d
  cac968:	c1 e1 09             	shl    $0x9,%ecx
  cac96b:	31 d2                	xor    %edx,%edx
  cac96d:	4c 8b 6c 24 38       	mov    0x38(%rsp),%r13
  cac972:	41 c1 e4 0d          	shl    $0xd,%r12d
  cac976:	45 0f b6 4f 1c       	movzbl 0x1c(%r15),%r9d
  cac97b:	40 88 c5             	mov    %al,%bpl
  cac97e:	41 0f b7 f6          	movzwl %r14w,%esi
  cac982:	c1 e5 08             	shl    $0x8,%ebp
  cac985:	89 f7                	mov    %esi,%edi
  cac987:	41 80 f9 02          	cmp    $0x2,%r9b
  cac98b:	0f 94 c2             	sete   %dl
  cac98e:	83 e7 08             	and    $0x8,%edi
  cac991:	45 31 c0             	xor    %r8d,%r8d
  cac994:	c1 e2 0a             	shl    $0xa,%edx
  cac997:	c1 e7 08             	shl    $0x8,%edi
  cac99a:	40 f6 c6 f0          	test   $0xf0,%sil
  cac99e:	41 0f 95 c0          	setne  %r8b
  cac9a2:	41 c1 e0 0c          	shl    $0xc,%r8d
  cac9a6:	41 09 f8             	or     %edi,%r8d
  cac9a9:	44 03 44 24 10       	add    0x10(%rsp),%r8d
  cac9ae:	41 09 e8             	or     %ebp,%r8d
  cac9b1:	45 09 e0             	or     %r12d,%r8d
  cac9b4:	41 09 c8             	or     %ecx,%r8d
  cac9b7:	41 09 d0             	or     %edx,%r8d
  cac9ba:	46 89 84 ab 24 da 03 00 	mov    %r8d,0x3da24(%rbx,%r13,4)
  cac9c2:	41 0f b6 4f 12       	movzbl 0x12(%r15),%ecx
  cac9c7:	45 84 c9             	test   %r9b,%r9b
  cac9ca:	0f 84 2f 01 00 00    	je     cacaff <x86_match_initialize+0x81f>
  cac9d0:	8b 6c 24 08          	mov    0x8(%rsp),%ebp
  cac9d4:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  cac9db:	31 c0                	xor    %eax,%eax
  cac9dd:	8d 14 cd 00 00 00 00 	lea    0x0(,%rcx,8),%edx
  cac9e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  cac9ea:	8d 72 ff             	lea    -0x1(%rdx),%esi
  cac9ed:	c4 c2 c9 f7 f8       	shlx   %rsi,%r8,%rdi
  cac9f2:	40 f6 c6 40          	test   $0x40,%sil
  cac9f6:	be 00 00 00 00       	mov    $0x0,%esi
  cac9fb:	49 0f 45 f9          	cmovne %r9,%rdi
  cac9ff:	85 c9                	test   %ecx,%ecx
  caca01:	49 0f 44 f9          	cmove  %r9,%rdi
  caca05:	4a 89 bc eb a8 5c 04 00 	mov    %rdi,0x45ca8(%rbx,%r13,8)
  caca0d:	74 19                	je     caca28 <x86_match_initialize+0x748>
  caca0f:	0f b6 c0             	movzbl %al,%eax
  caca12:	be 00 00 00 00       	mov    $0x0,%esi
  caca17:	29 c2                	sub    %eax,%edx
  caca19:	c4 c2 e9 f7 c0       	shlx   %rdx,%r8,%rax
  caca1e:	f6 c2 40             	test   $0x40,%dl
  caca21:	48 0f 44 f0          	cmove  %rax,%rsi
  caca25:	48 f7 d6             	not    %rsi
  caca28:	80 7c 24 04 00       	cmpb   $0x0,0x4(%rsp)
  caca2d:	4c 8b 54 24 18       	mov    0x18(%rsp),%r10
  caca32:	4a 89 b4 eb a8 61 05 00 	mov    %rsi,0x561a8(%rbx,%r13,8)
  caca3a:	0f 84 10 fd ff ff    	je     cac750 <x86_match_initialize+0x470>
  caca40:	49 8d 47 16          	lea    0x16(%r15),%rax
  caca44:	48 8d 8b 04 2d 01 00 	lea    0x12d04(%rbx),%rcx
  caca4b:	49 8d 57 1e          	lea    0x1e(%r15),%rdx
  caca4f:	49 8d 77 18          	lea    0x18(%r15),%rsi
  caca53:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  caca58:	31 c0                	xor    %eax,%eax
  caca5a:	83 fd 04             	cmp    $0x4,%ebp
  caca5d:	4e 8d 24 a9          	lea    (%rcx,%r13,4),%r12
  caca61:	0f 95 c0             	setne  %al
  caca64:	83 c0 03             	add    $0x3,%eax
  caca67:	89 44 24 04          	mov    %eax,0x4(%rsp)
  caca6b:	41 f6 c6 04          	test   $0x4,%r14b
  caca6f:	0f 85 f8 00 00 00    	jne    cacb6d <x86_match_initialize+0x88d>
  caca75:	41 89 e8             	mov    %ebp,%r8d
  caca78:	41 c1 e0 08          	shl    $0x8,%r8d
  caca7c:	41 83 fa 01          	cmp    $0x1,%r10d
  caca80:	41 83 d2 00          	adc    $0x0,%r10d
  caca84:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  caca88:	0f 84 01 01 00 00    	je     cacb8f <x86_match_initialize+0x8af>
  caca8e:	45 31 c9             	xor    %r9d,%r9d
  caca91:	e9 f8 04 00 00       	jmp    cacf8e <x86_match_initialize+0xcae>
  caca96:	48 8d 35 cf 3f 96 ff 	lea    -0x69c031(%rip),%rsi        # 610a6c <foreign_touch.flags+0x3d53f>
  caca9d:	4c 89 ef             	mov    %r13,%rdi
  cacaa0:	e8 fb 79 ab ff       	call   7644a0 <strcmp@plt>
  cacaa5:	c7 44 24 10 08 00 00 00 	movl   $0x8,0x10(%rsp)
  cacaad:	85 c0                	test   %eax,%eax
  cacaaf:	0f 84 2e fe ff ff    	je     cac8e3 <x86_match_initialize+0x603>
  cacab5:	48 8d 35 38 ad 9d ff 	lea    -0x6252c8(%rip),%rsi        # 6877f4 <pp_string_value.meaning+0x2a5a8>
  cacabc:	4c 89 ef             	mov    %r13,%rdi
  cacabf:	e8 dc 79 ab ff       	call   7644a0 <strcmp@plt>
  cacac4:	85 c0                	test   %eax,%eax
  cacac6:	0f 84 17 fe ff ff    	je     cac8e3 <x86_match_initialize+0x603>
  cacacc:	48 8d 35 c8 6a 8d ff 	lea    -0x729538(%rip),%rsi        # 58359b <c_fragment_reader_cursor_tests.leaf_phases+0x167>
  cacad3:	4c 89 ef             	mov    %r13,%rdi
  cacad6:	e8 c5 79 ab ff       	call   7644a0 <strcmp@plt>
  cacadb:	85 c0                	test   %eax,%eax
  cacadd:	0f 84 00 fe ff ff    	je     cac8e3 <x86_match_initialize+0x603>
  cacae3:	48 8d 35 b5 6a 8d ff 	lea    -0x72954b(%rip),%rsi        # 58359f <c_fragment_reader_cursor_tests.leaf_phases+0x16b>
  cacaea:	4c 89 ef             	mov    %r13,%rdi
  cacaed:	e8 ae 79 ab ff       	call   7644a0 <strcmp@plt>
  cacaf2:	85 c0                	test   %eax,%eax
  cacaf4:	0f 85 e4 fd ff ff    	jne    cac8de <x86_match_initialize+0x5fe>
  cacafa:	e9 e4 fd ff ff       	jmp    cac8e3 <x86_match_initialize+0x603>
  cacaff:	41 8b 57 08          	mov    0x8(%r15),%edx
  cacb03:	8b 6c 24 08          	mov    0x8(%rsp),%ebp
  cacb07:	b0 01                	mov    $0x1,%al
  cacb09:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  cacb10:	80 fa 83             	cmp    $0x83,%dl
  cacb13:	0f 84 c4 fe ff ff    	je     cac9dd <x86_match_initialize+0x6fd>
  cacb19:	81 e2 fe 00 00 00    	and    $0xfe,%edx
  cacb1f:	83 fa 6a             	cmp    $0x6a,%edx
  cacb22:	0f 84 b5 fe ff ff    	je     cac9dd <x86_match_initialize+0x6fd>
  cacb28:	83 f9 04             	cmp    $0x4,%ecx
  cacb2b:	0f 85 aa fe ff ff    	jne    cac9db <x86_match_initialize+0x6fb>
  cacb31:	41 80 7f 14 00       	cmpb   $0x0,0x14(%r15)
  cacb36:	b0 01                	mov    $0x1,%al
  cacb38:	75 1d                	jne    cacb57 <x86_match_initialize+0x877>
  cacb3a:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  cacb3f:	48 8d 35 06 6a 8d ff 	lea    -0x7295fa(%rip),%rsi        # 58354c <c_fragment_reader_cursor_tests.leaf_phases+0x118>
  cacb46:	e8 55 79 ab ff       	call   7644a0 <strcmp@plt>
  cacb4b:	85 c0                	test   %eax,%eax
  cacb4d:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  cacb54:	0f 94 c0             	sete   %al
  cacb57:	ba 20 00 00 00       	mov    $0x20,%edx
  cacb5c:	4a c7 84 eb a8 5c 04 00 00 00 00 80 	movq   $0xffffffff80000000,0x45ca8(%rbx,%r13,8)
  cacb68:	e9 a2 fe ff ff       	jmp    caca0f <x86_match_initialize+0x72f>
  cacb6d:	4d 8d 47 1a          	lea    0x1a(%r15),%r8
  cacb71:	49 83 c7 22          	add    $0x22,%r15
  cacb75:	41 83 fa 01          	cmp    $0x1,%r10d
  cacb79:	41 83 d2 00          	adc    $0x0,%r10d
  cacb7d:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  cacb81:	0f 84 e6 01 00 00    	je     cacd6d <x86_match_initialize+0xa8d>
  cacb87:	45 31 c9             	xor    %r9d,%r9d
  cacb8a:	e9 57 04 00 00       	jmp    cacfe6 <x86_match_initialize+0xd06>
  cacb8f:	48 8d 8b 84 af 01 00 	lea    0x1af84(%rbx),%rcx
  cacb96:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
  cacb9b:	41 83 e2 fe          	and    $0xfffffffe,%r10d
  cacb9f:	4c 89 e0             	mov    %r12,%rax
  cacba2:	45 31 c9             	xor    %r9d,%r9d
  cacba5:	4e 8d 1c a9          	lea    (%rcx,%r13,4),%r11
  cacba9:	eb 40                	jmp    cacbeb <x86_match_initialize+0x90b>
  cacbab:	bd 00 00 00 02       	mov    $0x2000000,%ebp
  cacbb0:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  cacbb6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
  cacbc0:	41 c1 e6 10          	shl    $0x10,%r14d
  cacbc4:	41 c1 e4 04          	shl    $0x4,%r12d
  cacbc8:	44 09 c5             	or     %r8d,%ebp
  cacbcb:	49 83 c1 02          	add    $0x2,%r9
  cacbcf:	45 09 fe             	or     %r15d,%r14d
  cacbd2:	45 09 e6             	or     %r12d,%r14d
  cacbd5:	44 09 f5             	or     %r14d,%ebp
  cacbd8:	41 89 2b             	mov    %ebp,(%r11)
  cacbdb:	49 81 c3 00 05 01 00 	add    $0x10500,%r11
  cacbe2:	4d 39 ca             	cmp    %r9,%r10
  cacbe5:	0f 84 95 03 00 00    	je     cacf80 <x86_match_initialize+0xca0>
  cacbeb:	46 0f b6 74 0c 4c    	movzbl 0x4c(%rsp,%r9,1),%r14d
  cacbf1:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  cacbf7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  cacbfd:	31 ed                	xor    %ebp,%ebp
  cacbff:	41 8d 7e ff          	lea    -0x1(%r14),%edi
  cacc03:	83 ff 07             	cmp    $0x7,%edi
  cacc06:	77 41                	ja     cacc49 <x86_match_initialize+0x969>
  cacc08:	4c 8d 25 65 a3 7a ff 	lea    -0x855c9b(%rip),%r12        # 456f74 <files_test_contexts.directories.rel+0xbb8>
  cacc0f:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  cacc15:	45 31 ed             	xor    %r13d,%r13d
  cacc18:	49 63 0c bc          	movslq (%r12,%rdi,4),%rcx
  cacc1c:	48 89 d7             	mov    %rdx,%rdi
  cacc1f:	4c 01 e1             	add    %r12,%rcx
  cacc22:	45 31 e4             	xor    %r12d,%r12d
  cacc25:	ff e1                	jmp    *%rcx
  cacc27:	45 31 e4             	xor    %r12d,%r12d
  cacc2a:	eb 74                	jmp    cacca0 <x86_match_initialize+0x9c0>
  cacc2c:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  cacc31:	eb 03                	jmp    cacc36 <x86_match_initialize+0x956>
  cacc33:	48 89 f7             	mov    %rsi,%rdi
  cacc36:	44 0f b7 2f          	movzwl (%rdi),%r13d
  cacc3a:	45 89 ec             	mov    %r13d,%r12d
  cacc3d:	41 c1 ed 03          	shr    $0x3,%r13d
  cacc41:	41 83 e4 0f          	and    $0xf,%r12d
  cacc45:	41 83 e5 06          	and    $0x6,%r13d
  cacc49:	44 89 f1             	mov    %r14d,%ecx
  cacc4c:	45 89 ef             	mov    %r13d,%r15d
  cacc4f:	80 e1 fe             	and    $0xfe,%cl
  cacc52:	80 f9 06             	cmp    $0x6,%cl
  cacc55:	75 49                	jne    cacca0 <x86_match_initialize+0x9c0>
  cacc57:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  cacc5d:	41 83 fe 07          	cmp    $0x7,%r14d
  cacc61:	75 0d                	jne    cacc70 <x86_match_initialize+0x990>
  cacc63:	bd 00 00 00 02       	mov    $0x2000000,%ebp
  cacc68:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  cacc6e:	eb 30                	jmp    cacca0 <x86_match_initialize+0x9c0>
  cacc70:	44 8b 64 24 08       	mov    0x8(%rsp),%r12d
  cacc75:	bd 00 00 00 01       	mov    $0x1000000,%ebp
  cacc7a:	41 83 fc 01          	cmp    $0x1,%r12d
  cacc7e:	74 20                	je     cacca0 <x86_match_initialize+0x9c0>
  cacc80:	41 83 fc 02          	cmp    $0x2,%r12d
  cacc84:	75 08                	jne    cacc8e <x86_match_initialize+0x9ae>
  cacc86:	41 bc 02 00 00 00    	mov    $0x2,%r12d
  cacc8c:	eb 12                	jmp    cacca0 <x86_match_initialize+0x9c0>
  cacc8e:	44 8b 64 24 04       	mov    0x4(%rsp),%r12d
  cacc93:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  cacca0:	41 c1 e6 10          	shl    $0x10,%r14d
  cacca4:	41 c1 e4 04          	shl    $0x4,%r12d
  cacca8:	44 09 c5             	or     %r8d,%ebp
  caccab:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  caccb1:	45 09 fe             	or     %r15d,%r14d
  caccb4:	45 09 e6             	or     %r12d,%r14d
  caccb7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  caccbd:	44 09 f5             	or     %r14d,%ebp
  caccc0:	41 89 ab 80 7d ff ff 	mov    %ebp,-0x8280(%r11)
  caccc7:	31 ed                	xor    %ebp,%ebp
  caccc9:	46 0f b6 74 0c 4d    	movzbl 0x4d(%rsp,%r9,1),%r14d
  cacccf:	41 8d 7e ff          	lea    -0x1(%r14),%edi
  caccd3:	83 ff 07             	cmp    $0x7,%edi
  caccd6:	77 44                	ja     cacd1c <x86_match_initialize+0xa3c>
  caccd8:	4c 8d 25 b5 a2 7a ff 	lea    -0x855d4b(%rip),%r12        # 456f94 <files_test_contexts.directories.rel+0xbd8>
  caccdf:	41 bf 08 00 00 00    	mov    $0x8,%r15d
  cacce5:	45 31 ed             	xor    %r13d,%r13d
  cacce8:	49 63 0c bc          	movslq (%r12,%rdi,4),%rcx
  caccec:	48 89 d7             	mov    %rdx,%rdi
  caccef:	4c 01 e1             	add    %r12,%rcx
  caccf2:	45 31 e4             	xor    %r12d,%r12d
  caccf5:	ff e1                	jmp    *%rcx
  caccf7:	45 31 e4             	xor    %r12d,%r12d
  caccfa:	e9 c1 fe ff ff       	jmp    cacbc0 <x86_match_initialize+0x8e0>
  caccff:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  cacd04:	eb 03                	jmp    cacd09 <x86_match_initialize+0xa29>
  cacd06:	48 89 f7             	mov    %rsi,%rdi
  cacd09:	44 0f b7 2f          	movzwl (%rdi),%r13d
  cacd0d:	45 89 ec             	mov    %r13d,%r12d
  cacd10:	41 c1 ed 03          	shr    $0x3,%r13d
  cacd14:	41 83 e4 0f          	and    $0xf,%r12d
  cacd18:	41 83 e5 06          	and    $0x6,%r13d
  cacd1c:	44 89 f1             	mov    %r14d,%ecx
  cacd1f:	45 89 ef             	mov    %r13d,%r15d
  cacd22:	80 e1 fe             	and    $0xfe,%cl
  cacd25:	80 f9 06             	cmp    $0x6,%cl
  cacd28:	0f 85 92 fe ff ff    	jne    cacbc0 <x86_match_initialize+0x8e0>
  cacd2e:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  cacd34:	41 83 fe 07          	cmp    $0x7,%r14d
  cacd38:	0f 84 6d fe ff ff    	je     cacbab <x86_match_initialize+0x8cb>
  cacd3e:	44 8b 64 24 08       	mov    0x8(%rsp),%r12d
  cacd43:	bd 00 00 00 01       	mov    $0x1000000,%ebp
  cacd48:	41 83 fc 01          	cmp    $0x1,%r12d
  cacd4c:	0f 84 6e fe ff ff    	je     cacbc0 <x86_match_initialize+0x8e0>
  cacd52:	41 83 fc 02          	cmp    $0x2,%r12d
  cacd56:	75 0b                	jne    cacd63 <x86_match_initialize+0xa83>
  cacd58:	41 bc 02 00 00 00    	mov    $0x2,%r12d
  cacd5e:	e9 5d fe ff ff       	jmp    cacbc0 <x86_match_initialize+0x8e0>
  cacd63:	44 8b 64 24 04       	mov    0x4(%rsp),%r12d
  cacd68:	e9 53 fe ff ff       	jmp    cacbc0 <x86_match_initialize+0x8e0>
  cacd6d:	48 8d 8b 84 af 01 00 	lea    0x1af84(%rbx),%rcx
  cacd74:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
  cacd79:	41 83 e2 fe          	and    $0xfffffffe,%r10d
  cacd7d:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  cacd82:	4c 89 f8             	mov    %r15,%rax
  cacd85:	45 31 c9             	xor    %r9d,%r9d
  cacd88:	4e 8d 1c a9          	lea    (%rcx,%r13,4),%r11
  cacd8c:	eb 4d                	jmp    cacddb <x86_match_initialize+0xafb>
  cacd8e:	41 bd 00 00 00 02    	mov    $0x2000000,%r13d
  cacd94:	bd 01 00 00 00       	mov    $0x1,%ebp
  cacd99:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  cacda0:	41 83 ff 01          	cmp    $0x1,%r15d
  cacda4:	4c 89 c1             	mov    %r8,%rcx
  cacda7:	48 0f 44 c8          	cmove  %rax,%rcx
  cacdab:	41 c1 e7 10          	shl    $0x10,%r15d
  cacdaf:	c1 e5 04             	shl    $0x4,%ebp
  cacdb2:	49 83 c1 02          	add    $0x2,%r9
  cacdb6:	0f b6 09             	movzbl (%rcx),%ecx
  cacdb9:	45 09 e7             	or     %r12d,%r15d
  cacdbc:	41 09 ef             	or     %ebp,%r15d
  cacdbf:	45 09 ef             	or     %r13d,%r15d
  cacdc2:	c1 e1 08             	shl    $0x8,%ecx
  cacdc5:	41 09 cf             	or     %ecx,%r15d
  cacdc8:	45 89 3b             	mov    %r15d,(%r11)
  cacdcb:	49 81 c3 00 05 01 00 	add    $0x10500,%r11
  cacdd2:	4d 39 ca             	cmp    %r9,%r10
  cacdd5:	0f 84 f8 01 00 00    	je     cacfd3 <x86_match_initialize+0xcf3>
  cacddb:	46 0f b6 7c 0c 4c    	movzbl 0x4c(%rsp,%r9,1),%r15d
  cacde1:	48 89 f7             	mov    %rsi,%rdi
  cacde4:	41 83 ff 01          	cmp    $0x1,%r15d
  cacde8:	75 46                	jne    cace30 <x86_match_initialize+0xb50>
  cacdea:	44 0f b7 37          	movzwl (%rdi),%r14d
  cacdee:	44 89 f5             	mov    %r14d,%ebp
  cacdf1:	41 c1 ee 03          	shr    $0x3,%r14d
  cacdf5:	83 e5 0f             	and    $0xf,%ebp
  cacdf8:	41 83 e6 06          	and    $0x6,%r14d
  cacdfc:	44 89 f9             	mov    %r15d,%ecx
  cacdff:	45 31 ed             	xor    %r13d,%r13d
  cace02:	45 89 f4             	mov    %r14d,%r12d
  cace05:	80 e1 fe             	and    $0xfe,%cl
  cace08:	80 f9 06             	cmp    $0x6,%cl
  cace0b:	75 53                	jne    cace60 <x86_match_initialize+0xb80>
  cace0d:	41 bc 02 00 00 00    	mov    $0x2,%r12d
  cace13:	41 83 ff 07          	cmp    $0x7,%r15d
  cace17:	0f 85 17 01 00 00    	jne    cacf34 <x86_match_initialize+0xc54>
  cace1d:	41 bd 00 00 00 02    	mov    $0x2000000,%r13d
  cace23:	bd 01 00 00 00       	mov    $0x1,%ebp
  cace28:	eb 36                	jmp    cace60 <x86_match_initialize+0xb80>
  cace2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  cace30:	41 8d 7f fe          	lea    -0x2(%r15),%edi
  cace34:	31 ed                	xor    %ebp,%ebp
  cace36:	83 ff 06             	cmp    $0x6,%edi
  cace39:	0f 87 31 01 00 00    	ja     cacf70 <x86_match_initialize+0xc90>
  cace3f:	4c 8d 35 da a0 7a ff 	lea    -0x855f26(%rip),%r14        # 456f20 <files_test_contexts.directories.rel+0xb64>
  cace46:	41 bc 08 00 00 00    	mov    $0x8,%r12d
  cace4c:	45 31 ed             	xor    %r13d,%r13d
  cace4f:	49 63 0c be          	movslq (%r14,%rdi,4),%rcx
  cace53:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  cace58:	4c 01 f1             	add    %r14,%rcx
  cace5b:	45 31 f6             	xor    %r14d,%r14d
  cace5e:	ff e1                	jmp    *%rcx
  cace60:	41 83 ff 01          	cmp    $0x1,%r15d
  cace64:	4c 89 c1             	mov    %r8,%rcx
  cace67:	48 89 f7             	mov    %rsi,%rdi
  cace6a:	48 0f 44 c8          	cmove  %rax,%rcx
  cace6e:	41 c1 e7 10          	shl    $0x10,%r15d
  cace72:	c1 e5 04             	shl    $0x4,%ebp
  cace75:	0f b6 09             	movzbl (%rcx),%ecx
  cace78:	45 09 e7             	or     %r12d,%r15d
  cace7b:	41 09 ef             	or     %ebp,%r15d
  cace7e:	45 09 ef             	or     %r13d,%r15d
  cace81:	c1 e1 08             	shl    $0x8,%ecx
  cace84:	41 09 cf             	or     %ecx,%r15d
  cace87:	45 89 bb 80 7d ff ff 	mov    %r15d,-0x8280(%r11)
  cace8e:	46 0f b6 7c 0c 4d    	movzbl 0x4d(%rsp,%r9,1),%r15d
  cace94:	41 83 ff 01          	cmp    $0x1,%r15d
  cace98:	75 66                	jne    cacf00 <x86_match_initialize+0xc20>
  cace9a:	44 0f b7 37          	movzwl (%rdi),%r14d
  cace9e:	44 89 f5             	mov    %r14d,%ebp
  cacea1:	41 c1 ee 03          	shr    $0x3,%r14d
  cacea5:	83 e5 0f             	and    $0xf,%ebp
  cacea8:	41 83 e6 06          	and    $0x6,%r14d
  caceac:	44 89 f9             	mov    %r15d,%ecx
  caceaf:	45 31 ed             	xor    %r13d,%r13d
  caceb2:	45 89 f4             	mov    %r14d,%r12d
  caceb5:	80 e1 fe             	and    $0xfe,%cl
  caceb8:	80 f9 06             	cmp    $0x6,%cl
  cacebb:	0f 85 df fe ff ff    	jne    cacda0 <x86_match_initialize+0xac0>
  cacec1:	41 bc 02 00 00 00    	mov    $0x2,%r12d
  cacec7:	41 83 ff 07          	cmp    $0x7,%r15d
  cacecb:	0f 84 bd fe ff ff    	je     cacd8e <x86_match_initialize+0xaae>
  caced1:	8b 6c 24 08          	mov    0x8(%rsp),%ebp
  caced5:	41 bd 00 00 00 01    	mov    $0x1000000,%r13d
  cacedb:	83 fd 01             	cmp    $0x1,%ebp
  cacede:	0f 84 bc fe ff ff    	je     cacda0 <x86_match_initialize+0xac0>
  cacee4:	83 fd 02             	cmp    $0x2,%ebp
  cacee7:	75 75                	jne    cacf5e <x86_match_initialize+0xc7e>
  cacee9:	bd 02 00 00 00       	mov    $0x2,%ebp
  caceee:	e9 ad fe ff ff       	jmp    cacda0 <x86_match_initialize+0xac0>
  cacef3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  cacf00:	41 8d 7f fe          	lea    -0x2(%r15),%edi
  cacf04:	31 ed                	xor    %ebp,%ebp
  cacf06:	83 ff 06             	cmp    $0x6,%edi
  cacf09:	77 6d                	ja     cacf78 <x86_match_initialize+0xc98>
  cacf0b:	4c 8d 35 2a a0 7a ff 	lea    -0x855fd6(%rip),%r14        # 456f3c <files_test_contexts.directories.rel+0xb80>
  cacf12:	41 bc 08 00 00 00    	mov    $0x8,%r12d
  cacf18:	45 31 ed             	xor    %r13d,%r13d
  cacf1b:	49 63 0c be          	movslq (%r14,%rdi,4),%rcx
  cacf1f:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  cacf24:	4c 01 f1             	add    %r14,%rcx
  cacf27:	45 31 f6             	xor    %r14d,%r14d
  cacf2a:	ff e1                	jmp    *%rcx
  cacf2c:	48 89 d7             	mov    %rdx,%rdi
  cacf2f:	e9 66 ff ff ff       	jmp    cace9a <x86_match_initialize+0xbba>
  cacf34:	8b 6c 24 08          	mov    0x8(%rsp),%ebp
  cacf38:	41 bd 00 00 00 01    	mov    $0x1000000,%r13d
  cacf3e:	83 fd 01             	cmp    $0x1,%ebp
  cacf41:	0f 84 19 ff ff ff    	je     cace60 <x86_match_initialize+0xb80>
  cacf47:	83 fd 02             	cmp    $0x2,%ebp
  cacf4a:	75 1b                	jne    cacf67 <x86_match_initialize+0xc87>
  cacf4c:	bd 02 00 00 00       	mov    $0x2,%ebp
  cacf51:	e9 0a ff ff ff       	jmp    cace60 <x86_match_initialize+0xb80>
  cacf56:	48 89 d7             	mov    %rdx,%rdi
  cacf59:	e9 8c fe ff ff       	jmp    cacdea <x86_match_initialize+0xb0a>
  cacf5e:	8b 6c 24 04          	mov    0x4(%rsp),%ebp
  cacf62:	e9 39 fe ff ff       	jmp    cacda0 <x86_match_initialize+0xac0>
  cacf67:	8b 6c 24 04          	mov    0x4(%rsp),%ebp
  cacf6b:	e9 f0 fe ff ff       	jmp    cace60 <x86_match_initialize+0xb80>
  cacf70:	45 31 f6             	xor    %r14d,%r14d
  cacf73:	e9 84 fe ff ff       	jmp    cacdfc <x86_match_initialize+0xb1c>
  cacf78:	45 31 f6             	xor    %r14d,%r14d
  cacf7b:	e9 2c ff ff ff       	jmp    caceac <x86_match_initialize+0xbcc>
  cacf80:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
  cacf85:	49 89 c4             	mov    %rax,%r12
  cacf88:	0f 84 c2 f7 ff ff    	je     cac750 <x86_match_initialize+0x470>
  cacf8e:	46 0f b6 54 0c 4c    	movzbl 0x4c(%rsp,%r9,1),%r10d
  cacf94:	41 be 00 00 00 00    	mov    $0x0,%r14d
  cacf9a:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  cacfa0:	45 31 db             	xor    %r11d,%r11d
  cacfa3:	41 8d 7a ff          	lea    -0x1(%r10),%edi
  cacfa7:	83 ff 07             	cmp    $0x7,%edi
  cacfaa:	0f 87 f5 00 00 00    	ja     cad0a5 <x86_match_initialize+0xdc5>
  cacfb0:	4c 8d 35 fd 9f 7a ff 	lea    -0x856003(%rip),%r14        # 456fb4 <files_test_contexts.directories.rel+0xbf8>
  cacfb7:	bd 08 00 00 00       	mov    $0x8,%ebp
  cacfbc:	45 31 ff             	xor    %r15d,%r15d
  cacfbf:	49 63 0c be          	movslq (%r14,%rdi,4),%rcx
  cacfc3:	4c 01 f1             	add    %r14,%rcx
  cacfc6:	45 31 f6             	xor    %r14d,%r14d
  cacfc9:	ff e1                	jmp    *%rcx
  cacfcb:	45 31 f6             	xor    %r14d,%r14d
  cacfce:	e9 25 01 00 00       	jmp    cad0f8 <x86_match_initialize+0xe18>
  cacfd3:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
  cacfd8:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  cacfdd:	49 89 c7             	mov    %rax,%r15
  cacfe0:	0f 84 6a f7 ff ff    	je     cac750 <x86_match_initialize+0x470>
  cacfe6:	46 0f b6 54 0c 4c    	movzbl 0x4c(%rsp,%r9,1),%r10d
  cacfec:	41 83 fa 01          	cmp    $0x1,%r10d
  cacff0:	75 5f                	jne    cad051 <x86_match_initialize+0xd71>
  cacff2:	44 0f b7 36          	movzwl (%rsi),%r14d
  cacff6:	45 89 f3             	mov    %r14d,%r11d
  cacff9:	41 c1 ee 03          	shr    $0x3,%r14d
  cacffd:	41 83 e3 0f          	and    $0xf,%r11d
  cad001:	41 83 e6 06          	and    $0x6,%r14d
  cad005:	44 89 d1             	mov    %r10d,%ecx
  cad008:	31 c0                	xor    %eax,%eax
  cad00a:	44 89 f5             	mov    %r14d,%ebp
  cad00d:	80 e1 fe             	and    $0xfe,%cl
  cad010:	80 f9 06             	cmp    $0x6,%cl
  cad013:	0f 85 09 f7 ff ff    	jne    cac722 <x86_match_initialize+0x442>
  cad019:	bd 02 00 00 00       	mov    $0x2,%ebp
  cad01e:	41 83 fa 07          	cmp    $0x7,%r10d
  cad022:	0f 84 ef f6 ff ff    	je     cac717 <x86_match_initialize+0x437>
  cad028:	44 8b 5c 24 08       	mov    0x8(%rsp),%r11d
  cad02d:	b8 00 00 00 01       	mov    $0x1000000,%eax
  cad032:	41 83 fb 01          	cmp    $0x1,%r11d
  cad036:	0f 84 e6 f6 ff ff    	je     cac722 <x86_match_initialize+0x442>
  cad03c:	41 83 fb 02          	cmp    $0x2,%r11d
  cad040:	0f 85 a3 00 00 00    	jne    cad0e9 <x86_match_initialize+0xe09>
  cad046:	41 bb 02 00 00 00    	mov    $0x2,%r11d
  cad04c:	e9 d1 f6 ff ff       	jmp    cac722 <x86_match_initialize+0x442>
  cad051:	41 8d 72 fe          	lea    -0x2(%r10),%esi
  cad055:	45 31 db             	xor    %r11d,%r11d
  cad058:	83 fe 06             	cmp    $0x6,%esi
  cad05b:	0f 87 bb 00 00 00    	ja     cad11c <x86_match_initialize+0xe3c>
  cad061:	48 8d 3d f0 9e 7a ff 	lea    -0x856110(%rip),%rdi        # 456f58 <files_test_contexts.directories.rel+0xb9c>
  cad068:	bd 08 00 00 00       	mov    $0x8,%ebp
  cad06d:	45 31 f6             	xor    %r14d,%r14d
  cad070:	31 c0                	xor    %eax,%eax
  cad072:	48 63 0c b7          	movslq (%rdi,%rsi,4),%rcx
  cad076:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  cad07b:	48 01 f9             	add    %rdi,%rcx
  cad07e:	ff e1                	jmp    *%rcx
  cad080:	48 89 d6             	mov    %rdx,%rsi
  cad083:	e9 6a ff ff ff       	jmp    cacff2 <x86_match_initialize+0xd12>
  cad088:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  cad08d:	eb 03                	jmp    cad092 <x86_match_initialize+0xdb2>
  cad08f:	48 89 f2             	mov    %rsi,%rdx
  cad092:	44 0f b7 3a          	movzwl (%rdx),%r15d
  cad096:	45 89 fe             	mov    %r15d,%r14d
  cad099:	41 c1 ef 03          	shr    $0x3,%r15d
  cad09d:	41 83 e6 0f          	and    $0xf,%r14d
  cad0a1:	41 83 e7 06          	and    $0x6,%r15d
  cad0a5:	44 89 d0             	mov    %r10d,%eax
  cad0a8:	44 89 fd             	mov    %r15d,%ebp
  cad0ab:	24 fe                	and    $0xfe,%al
  cad0ad:	3c 06                	cmp    $0x6,%al
  cad0af:	75 47                	jne    cad0f8 <x86_match_initialize+0xe18>
  cad0b1:	bd 02 00 00 00       	mov    $0x2,%ebp
  cad0b6:	41 83 fa 07          	cmp    $0x7,%r10d
  cad0ba:	75 0e                	jne    cad0ca <x86_match_initialize+0xdea>
  cad0bc:	41 bb 00 00 00 02    	mov    $0x2000000,%r11d
  cad0c2:	41 be 01 00 00 00    	mov    $0x1,%r14d
  cad0c8:	eb 2e                	jmp    cad0f8 <x86_match_initialize+0xe18>
  cad0ca:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  cad0cf:	41 bb 00 00 00 01    	mov    $0x1000000,%r11d
  cad0d5:	41 83 fe 01          	cmp    $0x1,%r14d
  cad0d9:	74 1d                	je     cad0f8 <x86_match_initialize+0xe18>
  cad0db:	41 83 fe 02          	cmp    $0x2,%r14d
  cad0df:	75 12                	jne    cad0f3 <x86_match_initialize+0xe13>
  cad0e1:	41 be 02 00 00 00    	mov    $0x2,%r14d
  cad0e7:	eb 0f                	jmp    cad0f8 <x86_match_initialize+0xe18>
  cad0e9:	44 8b 5c 24 04       	mov    0x4(%rsp),%r11d
  cad0ee:	e9 2f f6 ff ff       	jmp    cac722 <x86_match_initialize+0x442>
  cad0f3:	44 8b 74 24 04       	mov    0x4(%rsp),%r14d
  cad0f8:	41 c1 e2 10          	shl    $0x10,%r10d
  cad0fc:	41 c1 e6 04          	shl    $0x4,%r14d
  cad100:	49 69 c1 80 82 00 00 	imul   $0x8280,%r9,%rax
  cad107:	45 09 c3             	or     %r8d,%r11d
  cad10a:	41 09 ea             	or     %ebp,%r10d
  cad10d:	45 09 f2             	or     %r14d,%r10d
  cad110:	45 09 d3             	or     %r10d,%r11d
  cad113:	45 89 1c 04          	mov    %r11d,(%r12,%rax,1)
  cad117:	e9 34 f6 ff ff       	jmp    cac750 <x86_match_initialize+0x470>
  cad11c:	45 31 f6             	xor    %r14d,%r14d
  cad11f:	e9 e1 fe ff ff       	jmp    cad005 <x86_match_initialize+0xd25>
  cad124:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
  cad12d:	48 3b 84 24 00 69 00 00 	cmp    0x6900(%rsp),%rax
  cad135:	75 12                	jne    cad149 <x86_match_initialize+0xe69>
  cad137:	48 81 c4 08 69 00 00 	add    $0x6908,%rsp
  cad13e:	5b                   	pop    %rbx
  cad13f:	41 5c                	pop    %r12
  cad141:	41 5d                	pop    %r13
  cad143:	41 5e                	pop    %r14
  cad145:	41 5f                	pop    %r15
  cad147:	5d                   	pop    %rbp
  cad148:	c3                   	ret
  cad149:	e8 92 69 ab ff       	call   763ae0 <__stack_chk_fail@plt>
