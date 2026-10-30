
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000933320 <check_input_intrinsic_initialize>:
  933320:	55                   	push   rbp
  933321:	41 57                	push   r15
  933323:	41 56                	push   r14
  933325:	41 55                	push   r13
  933327:	41 54                	push   r12
  933329:	53                   	push   rbx
  93332a:	48 81 ec e8 00 00 00 	sub    rsp,0xe8
  933331:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  933338:	00 00 
  93333a:	62 f2 7d 48 5a 0d bc 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffcd2bbc]        # 605f00 <abi_test_hex.digits+0x370>
  933341:	2b cd ff 
  933344:	45 31 c0             	xor    r8d,r8d
  933347:	31 ed                	xor    ebp,ebp
  933349:	45 31 ff             	xor    r15d,r15d
  93334c:	45 31 c9             	xor    r9d,r9d
  93334f:	48 89 84 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],rax
  933356:	00 
  933357:	48 89 3c 24          	mov    QWORD PTR [rsp],rdi
  93335b:	48 8b 07             	mov    rax,QWORD PTR [rdi]
  93335e:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
  933362:	48 8b 4f 10          	mov    rcx,QWORD PTR [rdi+0x10]
  933366:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
  93336b:	48 8b 81 98 02 00 00 	mov    rax,QWORD PTR [rcx+0x298]
  933372:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
  933377:	48 8b 57 20          	mov    rdx,QWORD PTR [rdi+0x20]
  93337b:	48 8b 4f 28          	mov    rcx,QWORD PTR [rdi+0x28]
  93337f:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
  933384:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
  933388:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
  93338d:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
  933391:	c7 44 24 3c 00 00 00 	mov    DWORD PTR [rsp+0x3c],0x0
  933398:	00 
  933399:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
  93339e:	eb 13                	jmp    9333b3 <check_input_intrinsic_initialize+0x93>
  9333a0:	b0 01                	mov    al,0x1
  9333a2:	44 8b 4c 24 1c       	mov    r9d,DWORD PTR [rsp+0x1c]
  9333a7:	41 83 c1 40          	add    r9d,0x40
  9333ab:	84 c0                	test   al,al
  9333ad:	0f 84 28 08 00 00    	je     933bdb <check_input_intrinsic_initialize+0x8bb>
  9333b3:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  9333b8:	44 3b 48 40          	cmp    r9d,DWORD PTR [rax+0x40]
  9333bc:	0f 83 d0 02 00 00    	jae    933692 <check_input_intrinsic_initialize+0x372>
  9333c2:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  9333c6:	44 89 4c 24 1c       	mov    DWORD PTR [rsp+0x1c],r9d
  9333cb:	49 8b 76 08          	mov    rsi,QWORD PTR [r14+0x8]
  9333cf:	49 8b 06             	mov    rax,QWORD PTR [r14]
  9333d2:	8b 4e 40             	mov    ecx,DWORD PTR [rsi+0x40]
  9333d5:	48 8b 80 98 02 00 00 	mov    rax,QWORD PTR [rax+0x298]
  9333dc:	44 29 c9             	sub    ecx,r9d
  9333df:	83 f9 3f             	cmp    ecx,0x3f
  9333e2:	77 2c                	ja     933410 <check_input_intrinsic_initialize+0xf0>
  9333e4:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  9333eb:	89 ca                	mov    edx,ecx
  9333ed:	c4 62 e8 f5 ef       	bzhi   r13,rdi,rdx
  9333f2:	80 3e 00             	cmp    BYTE PTR [rsi],0x0
  9333f5:	75 66                	jne    93345d <check_input_intrinsic_initialize+0x13d>
  9333f7:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
  9333fb:	c4 c1 fb 92 cd       	kmovq  k1,r13
  933400:	44 89 ca             	mov    edx,r9d
  933403:	62 f1 75 49 74 14 17 	vpcmpeqb k2{k1},zmm1,ZMMWORD PTR [rdi+rdx*1]
  93340a:	eb 23                	jmp    93342f <check_input_intrinsic_initialize+0x10f>
  93340c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
  933410:	80 3e 00             	cmp    BYTE PTR [rsi],0x0
  933413:	49 c7 c5 ff ff ff ff 	mov    r13,0xffffffffffffffff
  93341a:	75 4a                	jne    933466 <check_input_intrinsic_initialize+0x146>
  93341c:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
  933420:	44 89 ca             	mov    edx,r9d
  933423:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  933428:	62 f1 75 48 74 14 17 	vpcmpeqb k2,zmm1,ZMMWORD PTR [rdi+rdx*1]
  93342f:	48 8b 76 60          	mov    rsi,QWORD PTR [rsi+0x60]
  933433:	62 f1 7f c9 6f 04 16 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rsi+rdx*1]
  93343a:	62 f1 7d 4a 74 c1    	vpcmpeqb k0{k2},zmm0,zmm1
  933440:	c4 e1 f4 41 c0       	kandq  k0,k1,k0
  933445:	c4 61 fb 93 e8       	kmovq  r13,k0
  93344a:	48 85 c0             	test   rax,rax
  93344d:	74 0e                	je     93345d <check_input_intrinsic_initialize+0x13d>
  93344f:	49 83 be c8 05 00 00 	cmp    QWORD PTR [r14+0x5c8],0x0
  933456:	00 
  933457:	0f 84 f0 01 00 00    	je     93364d <check_input_intrinsic_initialize+0x32d>
  93345d:	4d 85 ed             	test   r13,r13
  933460:	0f 84 3a ff ff ff    	je     9333a0 <check_input_intrinsic_initialize+0x80>
  933466:	45 89 cc             	mov    r12d,r9d
  933469:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  933470:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
  933474:	31 c0                	xor    eax,eax
  933476:	f3 49 0f bc c5       	tzcnt  rax,r13
  93347b:	4c 09 e0             	or     rax,r12
  93347e:	48 8b 51 20          	mov    rdx,QWORD PTR [rcx+0x20]
  933482:	80 3c 02 02          	cmp    BYTE PTR [rdx+rax*1],0x2
  933486:	0f 85 60 01 00 00    	jne    9335ec <check_input_intrinsic_initialize+0x2cc>
  93348c:	48 8b 49 60          	mov    rcx,QWORD PTR [rcx+0x60]
  933490:	80 3c 01 02          	cmp    BYTE PTR [rcx+rax*1],0x2
  933494:	0f 85 52 01 00 00    	jne    9335ec <check_input_intrinsic_initialize+0x2cc>
  93349a:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
  93349d:	48 8b 89 98 02 00 00 	mov    rcx,QWORD PTR [rcx+0x298]
  9334a4:	48 85 c9             	test   rcx,rcx
  9334a7:	74 0a                	je     9334b3 <check_input_intrinsic_initialize+0x193>
  9334a9:	49 83 be c8 05 00 00 	cmp    QWORD PTR [r14+0x5c8],0x0
  9334b0:	00 
  9334b1:	74 64                	je     933517 <check_input_intrinsic_initialize+0x1f7>
  9334b3:	48 8b 4c 24 08       	mov    rcx,QWORD PTR [rsp+0x8]
  9334b8:	48 8b 49 28          	mov    rcx,QWORD PTR [rcx+0x28]
  9334bc:	8b 1c 81             	mov    ebx,DWORD PTR [rcx+rax*4]
  9334bf:	4d 85 c0             	test   r8,r8
  9334c2:	75 2f                	jne    9334f3 <check_input_intrinsic_initialize+0x1d3>
  9334c4:	41 f6 c7 01          	test   r15b,0x1
  9334c8:	75 29                	jne    9334f3 <check_input_intrinsic_initialize+0x1d3>
  9334ca:	49 8b 4e 28          	mov    rcx,QWORD PTR [r14+0x28]
  9334ce:	48 8b 01             	mov    rax,QWORD PTR [rcx]
  9334d1:	48 8b 51 08          	mov    rdx,QWORD PTR [rcx+0x8]
  9334d5:	4c 8d 74 02 3f       	lea    r14,[rdx+rax*1+0x3f]
  9334da:	48 01 c2             	add    rdx,rax
  9334dd:	49 83 e6 c0          	and    r14,0xffffffffffffffc0
  9334e1:	49 39 d6             	cmp    r14,rdx
  9334e4:	73 3d                	jae    933523 <check_input_intrinsic_initialize+0x203>
  9334e6:	b0 01                	mov    al,0x1
  9334e8:	45 31 c0             	xor    r8d,r8d
  9334eb:	41 b7 01             	mov    r15b,0x1
  9334ee:	e9 b8 00 00 00       	jmp    9335ab <check_input_intrinsic_initialize+0x28b>
  9334f3:	b0 01                	mov    al,0x1
  9334f5:	41 f6 c7 01          	test   r15b,0x1
  9334f9:	41 b7 01             	mov    r15b,0x1
  9334fc:	0f 85 a9 00 00 00    	jne    9335ab <check_input_intrinsic_initialize+0x28b>
  933502:	45 31 ff             	xor    r15d,r15d
  933505:	41 83 3c 98 ff       	cmp    DWORD PTR [r8+rbx*4],0xffffffff
  93350a:	0f 85 d8 00 00 00    	jne    9335e8 <check_input_intrinsic_initialize+0x2c8>
  933510:	31 c0                	xor    eax,eax
  933512:	e9 94 00 00 00       	jmp    9335ab <check_input_intrinsic_initialize+0x28b>
  933517:	80 3c 01 00          	cmp    BYTE PTR [rcx+rax*1],0x0
  93351b:	0f 85 cb 00 00 00    	jne    9335ec <check_input_intrinsic_initialize+0x2cc>
  933521:	eb 90                	jmp    9334b3 <check_input_intrinsic_initialize+0x193>
  933523:	48 8b 71 10          	mov    rsi,QWORD PTR [rcx+0x10]
  933527:	4c 89 f2             	mov    rdx,r14
  93352a:	48 29 c2             	sub    rdx,rax
  93352d:	b0 01                	mov    al,0x1
  93352f:	48 29 d6             	sub    rsi,rdx
  933532:	72 b4                	jb     9334e8 <check_input_intrinsic_initialize+0x1c8>
  933534:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
  933539:	41 b8 00 00 00 00    	mov    r8d,0x0
  93353f:	41 b7 01             	mov    r15b,0x1
  933542:	8b bf 88 00 00 00    	mov    edi,DWORD PTR [rdi+0x88]
  933548:	48 c1 e7 02          	shl    rdi,0x2
  93354c:	48 39 f7             	cmp    rdi,rsi
  93354f:	77 5a                	ja     9335ab <check_input_intrinsic_initialize+0x28b>
  933551:	48 01 fa             	add    rdx,rdi
  933554:	48 89 51 08          	mov    QWORD PTR [rcx+0x8],rdx
  933558:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
  93355c:	48 39 c2             	cmp    rdx,rax
  93355f:	48 0f 46 d0          	cmovbe rdx,rax
  933563:	48 89 51 20          	mov    QWORD PTR [rcx+0x20],rdx
  933567:	4d 85 f6             	test   r14,r14
  93356a:	0f 84 76 ff ff ff    	je     9334e6 <check_input_intrinsic_initialize+0x1c6>
  933570:	48 8b 44 24 10       	mov    rax,QWORD PTR [rsp+0x10]
  933575:	be ff 00 00 00       	mov    esi,0xff
  93357a:	4c 89 f7             	mov    rdi,r14
  93357d:	8b 90 88 00 00 00    	mov    edx,DWORD PTR [rax+0x88]
  933583:	48 c1 e2 02          	shl    rdx,0x2
  933587:	c5 f8 77             	vzeroupper
  93358a:	e8 f1 a8 fc ff       	call   8fde80 <memset@plt>
  93358f:	62 f2 7d 48 5a 0d 67 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffcd2967]        # 605f00 <abi_test_hex.digits+0x370>
  933596:	29 cd ff 
  933599:	4d 89 f0             	mov    r8,r14
  93359c:	45 31 ff             	xor    r15d,r15d
  93359f:	41 83 3c 98 ff       	cmp    DWORD PTR [r8+rbx*4],0xffffffff
  9335a4:	75 42                	jne    9335e8 <check_input_intrinsic_initialize+0x2c8>
  9335a6:	e9 65 ff ff ff       	jmp    933510 <check_input_intrinsic_initialize+0x1f0>
  9335ab:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
  9335b0:	89 ee                	mov    esi,ebp
  9335b2:	48 8b 4f 10          	mov    rcx,QWORD PTR [rdi+0x10]
  9335b6:	8b 14 d9             	mov    edx,DWORD PTR [rcx+rbx*8]
  9335b9:	8b 4c d9 04          	mov    ecx,DWORD PTR [rcx+rbx*8+0x4]
  9335bd:	48 03 57 50          	add    rdx,QWORD PTR [rdi+0x50]
  9335c1:	89 5c b4 40          	mov    DWORD PTR [rsp+rsi*4+0x40],ebx
  9335c5:	48 c1 e6 04          	shl    rsi,0x4
  9335c9:	48 89 54 34 60       	mov    QWORD PTR [rsp+rsi*1+0x60],rdx
  9335ce:	89 4c 34 68          	mov    DWORD PTR [rsp+rsi*1+0x68],ecx
  9335d2:	c7 44 34 6c 00 00 00 	mov    DWORD PTR [rsp+rsi*1+0x6c],0x0
  9335d9:	00 
  9335da:	84 c0                	test   al,al
  9335dc:	75 08                	jne    9335e6 <check_input_intrinsic_initialize+0x2c6>
  9335de:	41 c7 04 98 00 00 00 	mov    DWORD PTR [r8+rbx*4],0x0
  9335e5:	00 
  9335e6:	ff c5                	inc    ebp
  9335e8:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  9335ec:	b0 01                	mov    al,0x1
  9335ee:	83 fd 08             	cmp    ebp,0x8
  9335f1:	74 0d                	je     933600 <check_input_intrinsic_initialize+0x2e0>
  9335f3:	c4 c2 90 f3 cd       	blsr   r13,r13
  9335f8:	75 46                	jne    933640 <check_input_intrinsic_initialize+0x320>
  9335fa:	e9 a3 fd ff ff       	jmp    9333a2 <check_input_intrinsic_initialize+0x82>
  9335ff:	90                   	nop
  933600:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  933605:	48 8d 74 24 60       	lea    rsi,[rsp+0x60]
  93360a:	48 8d 54 24 40       	lea    rdx,[rsp+0x40]
  93360f:	b9 08 00 00 00       	mov    ecx,0x8
  933614:	4c 8d 4c 24 3c       	lea    r9,[rsp+0x3c]
  933619:	4c 89 c3             	mov    rbx,r8
  93361c:	8b 38                	mov    edi,DWORD PTR [rax]
  93361e:	c5 f8 77             	vzeroupper
  933621:	e8 ca 58 02 00       	call   958ef0 <check_input_intrinsic_lookup>
  933626:	62 f2 7d 48 5a 0d d0 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffcd28d0]        # 605f00 <abi_test_hex.digits+0x370>
  93362d:	28 cd ff 
  933630:	49 89 d8             	mov    r8,rbx
  933633:	31 ed                	xor    ebp,ebp
  933635:	c4 c2 90 f3 cd       	blsr   r13,r13
  93363a:	0f 84 62 fd ff ff    	je     9333a2 <check_input_intrinsic_initialize+0x82>
  933640:	84 c0                	test   al,al
  933642:	0f 85 28 fe ff ff    	jne    933470 <check_input_intrinsic_initialize+0x150>
  933648:	e9 55 fd ff ff       	jmp    9333a2 <check_input_intrinsic_initialize+0x82>
  93364d:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  933652:	83 f9 3f             	cmp    ecx,0x3f
  933655:	77 13                	ja     93366a <check_input_intrinsic_initialize+0x34a>
  933657:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  93365e:	89 c9                	mov    ecx,ecx
  933660:	c4 e2 f0 f5 ce       	bzhi   rcx,rsi,rcx
  933665:	c4 e1 fb 92 c9       	kmovq  k1,rcx
  93366a:	62 f1 7f c9 6f 04 10 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rax+rdx*1]
  933671:	62 f2 7d 49 26 c0    	vptestmb k0{k1},zmm0,zmm0
  933677:	c4 e1 f8 44 c0       	knotq  k0,k0
  93367c:	c4 e1 fb 93 c0       	kmovq  rax,k0
  933681:	49 21 c5             	and    r13,rax
  933684:	4d 85 ed             	test   r13,r13
  933687:	0f 85 d9 fd ff ff    	jne    933466 <check_input_intrinsic_initialize+0x146>
  93368d:	e9 0e fd ff ff       	jmp    9333a0 <check_input_intrinsic_initialize+0x80>
  933692:	85 ed                	test   ebp,ebp
  933694:	74 4e                	je     9336e4 <check_input_intrinsic_initialize+0x3c4>
  933696:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  93369b:	48 8d 74 24 60       	lea    rsi,[rsp+0x60]
  9336a0:	48 8d 54 24 40       	lea    rdx,[rsp+0x40]
  9336a5:	4c 8d 4c 24 3c       	lea    r9,[rsp+0x3c]
  9336aa:	89 e9                	mov    ecx,ebp
  9336ac:	4c 89 c3             	mov    rbx,r8
  9336af:	8b 38                	mov    edi,DWORD PTR [rax]
  9336b1:	c5 f8 77             	vzeroupper
  9336b4:	e8 37 58 02 00       	call   958ef0 <check_input_intrinsic_lookup>
  9336b9:	62 f2 7d 48 5a 0d 3d 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffcd283d]        # 605f00 <abi_test_hex.digits+0x370>
  9336c0:	28 cd ff 
  9336c3:	8b 4c 24 3c          	mov    ecx,DWORD PTR [rsp+0x3c]
  9336c7:	49 89 d8             	mov    r8,rbx
  9336ca:	85 c9                	test   ecx,ecx
  9336cc:	89 4c 24 10          	mov    DWORD PTR [rsp+0x10],ecx
  9336d0:	0f 95 c1             	setne  cl
  9336d3:	84 c8                	test   al,cl
  9336d5:	75 1d                	jne    9336f4 <check_input_intrinsic_initialize+0x3d4>
  9336d7:	84 c0                	test   al,al
  9336d9:	0f 84 fc 04 00 00    	je     933bdb <check_input_intrinsic_initialize+0x8bb>
  9336df:	e9 01 02 00 00       	jmp    9338e5 <check_input_intrinsic_initialize+0x5c5>
  9336e4:	8b 44 24 3c          	mov    eax,DWORD PTR [rsp+0x3c]
  9336e8:	89 44 24 10          	mov    DWORD PTR [rsp+0x10],eax
  9336ec:	85 c0                	test   eax,eax
  9336ee:	0f 84 f1 01 00 00    	je     9338e5 <check_input_intrinsic_initialize+0x5c5>
  9336f4:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  9336f9:	8b 40 40             	mov    eax,DWORD PTR [rax+0x40]
  9336fc:	48 85 c0             	test   rax,rax
  9336ff:	0f 84 f6 01 00 00    	je     9338fb <check_input_intrinsic_initialize+0x5db>
  933705:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  933709:	4c 89 c2             	mov    rdx,r8
  93370c:	45 31 ed             	xor    r13d,r13d
  93370f:	49 8b 36             	mov    rsi,QWORD PTR [r14]
  933712:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
  933716:	8b 69 40             	mov    ebp,DWORD PTR [rcx+0x40]
  933719:	48 8b b6 98 02 00 00 	mov    rsi,QWORD PTR [rsi+0x298]
  933720:	48 85 f6             	test   rsi,rsi
  933723:	0f 84 e0 01 00 00    	je     933909 <check_input_intrinsic_initialize+0x5e9>
  933729:	45 31 c0             	xor    r8d,r8d
  93372c:	eb 13                	jmp    933741 <check_input_intrinsic_initialize+0x421>
  93372e:	66 90                	xchg   ax,ax
  933730:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  933734:	49 83 c0 40          	add    r8,0x40
  933738:	49 39 c0             	cmp    r8,rax
  93373b:	0f 83 07 03 00 00    	jae    933a48 <check_input_intrinsic_initialize+0x728>
  933741:	41 89 ea             	mov    r10d,ebp
  933744:	45 29 c2             	sub    r10d,r8d
  933747:	41 83 fa 3f          	cmp    r10d,0x3f
  93374b:	77 33                	ja     933780 <check_input_intrinsic_initialize+0x460>
  93374d:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  933754:	45 89 d1             	mov    r9d,r10d
  933757:	c4 62 b0 f5 cf       	bzhi   r9,rdi,r9
  93375c:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  93375f:	75 64                	jne    9337c5 <check_input_intrinsic_initialize+0x4a5>
  933761:	4c 8b 59 20          	mov    r11,QWORD PTR [rcx+0x20]
  933765:	c4 c1 fb 92 c9       	kmovq  k1,r9
  93376a:	62 91 75 49 74 14 03 	vpcmpeqb k2{k1},zmm1,ZMMWORD PTR [r11+r8*1]
  933771:	eb 29                	jmp    93379c <check_input_intrinsic_initialize+0x47c>
  933773:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93377a:	84 00 00 00 00 00 
  933780:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  933783:	49 c7 c1 ff ff ff ff 	mov    r9,0xffffffffffffffff
  93378a:	75 42                	jne    9337ce <check_input_intrinsic_initialize+0x4ae>
  93378c:	4c 8b 49 20          	mov    r9,QWORD PTR [rcx+0x20]
  933790:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  933795:	62 91 75 48 74 14 01 	vpcmpeqb k2,zmm1,ZMMWORD PTR [r9+r8*1]
  93379c:	4c 8b 49 60          	mov    r9,QWORD PTR [rcx+0x60]
  9337a0:	49 83 be c8 05 00 00 	cmp    QWORD PTR [r14+0x5c8],0x0
  9337a7:	00 
  9337a8:	62 91 7f c9 6f 04 01 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [r9+r8*1]
  9337af:	62 f1 7d 4a 74 c1    	vpcmpeqb k0{k2},zmm0,zmm1
  9337b5:	c4 e1 f4 41 c0       	kandq  k0,k1,k0
  9337ba:	c4 61 fb 93 c8       	kmovq  r9,k0
  9337bf:	0f 84 d9 00 00 00    	je     93389e <check_input_intrinsic_initialize+0x57e>
  9337c5:	4d 85 c9             	test   r9,r9
  9337c8:	0f 84 62 ff ff ff    	je     933730 <check_input_intrinsic_initialize+0x410>
  9337ce:	4c 8b 51 20          	mov    r10,QWORD PTR [rcx+0x20]
  9337d2:	eb 17                	jmp    9337eb <check_input_intrinsic_initialize+0x4cb>
  9337d4:	89 fd                	mov    ebp,edi
  9337d6:	41 01 dd             	add    r13d,ebx
  9337d9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  9337e0:	c4 c2 b0 f3 c9       	blsr   r9,r9
  9337e5:	0f 84 45 ff ff ff    	je     933730 <check_input_intrinsic_initialize+0x410>
  9337eb:	45 31 f6             	xor    r14d,r14d
  9337ee:	f3 4d 0f bc f1       	tzcnt  r14,r9
  9337f3:	4d 09 c6             	or     r14,r8
  9337f6:	45 89 f3             	mov    r11d,r14d
  9337f9:	43 80 3c 1a 02       	cmp    BYTE PTR [r10+r11*1],0x2
  9337fe:	75 e0                	jne    9337e0 <check_input_intrinsic_initialize+0x4c0>
  933800:	48 8b 59 60          	mov    rbx,QWORD PTR [rcx+0x60]
  933804:	42 80 3c 1b 02       	cmp    BYTE PTR [rbx+r11*1],0x2
  933809:	75 d5                	jne    9337e0 <check_input_intrinsic_initialize+0x4c0>
  93380b:	48 8b 1c 24          	mov    rbx,QWORD PTR [rsp]
  93380f:	48 83 bb c8 05 00 00 	cmp    QWORD PTR [rbx+0x5c8],0x0
  933816:	00 
  933817:	74 75                	je     93388e <check_input_intrinsic_initialize+0x56e>
  933819:	48 8b 5c 24 08       	mov    rbx,QWORD PTR [rsp+0x8]
  93381e:	48 8b 5b 28          	mov    rbx,QWORD PTR [rbx+0x28]
  933822:	42 8b 1c 9b          	mov    ebx,DWORD PTR [rbx+r11*4]
  933826:	83 3c 9a fe          	cmp    DWORD PTR [rdx+rbx*4],0xfffffffe
  93382a:	7f b4                	jg     9337e0 <check_input_intrinsic_initialize+0x4c0>
  93382c:	31 db                	xor    ebx,ebx
  93382e:	44 39 f0             	cmp    eax,r14d
  933831:	76 a3                	jbe    9337d6 <check_input_intrinsic_initialize+0x4b6>
  933833:	4c 8b 74 24 08       	mov    r14,QWORD PTR [rsp+0x8]
  933838:	4d 8d 63 01          	lea    r12,[r11+0x1]
  93383c:	4d 8b 76 70          	mov    r14,QWORD PTR [r14+0x70]
  933840:	47 8b 3c 9e          	mov    r15d,DWORD PTR [r14+r11*4]
  933844:	45 39 fc             	cmp    r12d,r15d
  933847:	73 8d                	jae    9337d6 <check_input_intrinsic_initialize+0x4b6>
  933849:	41 39 c7             	cmp    r15d,eax
  93384c:	73 88                	jae    9337d6 <check_input_intrinsic_initialize+0x4b6>
  93384e:	89 ef                	mov    edi,ebp
  933850:	48 8b 6c 24 08       	mov    rbp,QWORD PTR [rsp+0x8]
  933855:	48 8b 6d 60          	mov    rbp,QWORD PTR [rbp+0x60]
  933859:	42 80 7c 1d 00 02    	cmp    BYTE PTR [rbp+r11*1+0x0],0x2
  93385f:	0f 85 6f ff ff ff    	jne    9337d4 <check_input_intrinsic_initialize+0x4b4>
  933865:	42 80 7c 25 00 23    	cmp    BYTE PTR [rbp+r12*1+0x0],0x23
  93386b:	0f 85 63 ff ff ff    	jne    9337d4 <check_input_intrinsic_initialize+0x4b4>
  933871:	42 80 7c 3d 00 3c    	cmp    BYTE PTR [rbp+r15*1+0x0],0x3c
  933877:	89 fd                	mov    ebp,edi
  933879:	0f 85 57 ff ff ff    	jne    9337d6 <check_input_intrinsic_initialize+0x4b6>
  93387f:	31 db                	xor    ebx,ebx
  933881:	47 39 7c 9e 04       	cmp    DWORD PTR [r14+r11*4+0x4],r15d
  933886:	0f 94 c3             	sete   bl
  933889:	e9 48 ff ff ff       	jmp    9337d6 <check_input_intrinsic_initialize+0x4b6>
  93388e:	42 80 3c 1e 00       	cmp    BYTE PTR [rsi+r11*1],0x0
  933893:	0f 85 47 ff ff ff    	jne    9337e0 <check_input_intrinsic_initialize+0x4c0>
  933899:	e9 7b ff ff ff       	jmp    933819 <check_input_intrinsic_initialize+0x4f9>
  93389e:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  9338a3:	41 83 fa 3f          	cmp    r10d,0x3f
  9338a7:	77 14                	ja     9338bd <check_input_intrinsic_initialize+0x59d>
  9338a9:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  9338b0:	45 89 d2             	mov    r10d,r10d
  9338b3:	c4 62 a8 f5 d7       	bzhi   r10,rdi,r10
  9338b8:	c4 c1 fb 92 ca       	kmovq  k1,r10
  9338bd:	62 b1 7f c9 6f 04 06 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rsi+r8*1]
  9338c4:	62 f2 7d 49 26 c0    	vptestmb k0{k1},zmm0,zmm0
  9338ca:	c4 e1 f8 44 c0       	knotq  k0,k0
  9338cf:	c4 61 fb 93 d0       	kmovq  r10,k0
  9338d4:	4d 21 d1             	and    r9,r10
  9338d7:	4d 85 c9             	test   r9,r9
  9338da:	0f 85 ee fe ff ff    	jne    9337ce <check_input_intrinsic_initialize+0x4ae>
  9338e0:	e9 4b fe ff ff       	jmp    933730 <check_input_intrinsic_initialize+0x410>
  9338e5:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
  9338e9:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  9338ee:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  9338f2:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
  9338f6:	e9 dc 02 00 00       	jmp    933bd7 <check_input_intrinsic_initialize+0x8b7>
  9338fb:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  9338ff:	31 c0                	xor    eax,eax
  933901:	45 31 ed             	xor    r13d,r13d
  933904:	e9 42 01 00 00       	jmp    933a4b <check_input_intrinsic_initialize+0x72b>
  933909:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  933910:	31 ff                	xor    edi,edi
  933912:	eb 19                	jmp    93392d <check_input_intrinsic_initialize+0x60d>
  933914:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93391b:	00 00 00 00 00 
  933920:	48 83 c7 40          	add    rdi,0x40
  933924:	48 39 c7             	cmp    rdi,rax
  933927:	0f 83 1b 01 00 00    	jae    933a48 <check_input_intrinsic_initialize+0x728>
  93392d:	41 89 e8             	mov    r8d,ebp
  933930:	41 29 f8             	sub    r8d,edi
  933933:	41 83 f8 40          	cmp    r8d,0x40
  933937:	73 27                	jae    933960 <check_input_intrinsic_initialize+0x640>
  933939:	45 89 c0             	mov    r8d,r8d
  93393c:	c4 62 b8 f5 c6       	bzhi   r8,rsi,r8
  933941:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  933944:	75 51                	jne    933997 <check_input_intrinsic_initialize+0x677>
  933946:	4c 8b 49 20          	mov    r9,QWORD PTR [rcx+0x20]
  93394a:	c4 c1 fb 92 c8       	kmovq  k1,r8
  93394f:	62 d1 75 49 74 14 39 	vpcmpeqb k2{k1},zmm1,ZMMWORD PTR [r9+rdi*1]
  933956:	eb 24                	jmp    93397c <check_input_intrinsic_initialize+0x65c>
  933958:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  93395f:	00 
  933960:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  933963:	49 c7 c0 ff ff ff ff 	mov    r8,0xffffffffffffffff
  93396a:	75 30                	jne    93399c <check_input_intrinsic_initialize+0x67c>
  93396c:	4c 8b 41 20          	mov    r8,QWORD PTR [rcx+0x20]
  933970:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  933975:	62 d1 75 48 74 14 38 	vpcmpeqb k2,zmm1,ZMMWORD PTR [r8+rdi*1]
  93397c:	4c 8b 41 60          	mov    r8,QWORD PTR [rcx+0x60]
  933980:	62 d1 7f c9 6f 04 38 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [r8+rdi*1]
  933987:	62 f1 7d 4a 74 c1    	vpcmpeqb k0{k2},zmm0,zmm1
  93398d:	c4 e1 f4 41 c0       	kandq  k0,k1,k0
  933992:	c4 61 fb 93 c0       	kmovq  r8,k0
  933997:	4d 85 c0             	test   r8,r8
  93399a:	74 84                	je     933920 <check_input_intrinsic_initialize+0x600>
  93399c:	4c 8b 49 20          	mov    r9,QWORD PTR [rcx+0x20]
  9339a0:	eb 19                	jmp    9339bb <check_input_intrinsic_initialize+0x69b>
  9339a2:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  9339a6:	45 01 d5             	add    r13d,r10d
  9339a9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  9339b0:	c4 c2 b8 f3 c8       	blsr   r8,r8
  9339b5:	0f 84 65 ff ff ff    	je     933920 <check_input_intrinsic_initialize+0x600>
  9339bb:	31 db                	xor    ebx,ebx
  9339bd:	f3 49 0f bc d8       	tzcnt  rbx,r8
  9339c2:	48 09 fb             	or     rbx,rdi
  9339c5:	41 89 db             	mov    r11d,ebx
  9339c8:	43 80 3c 19 02       	cmp    BYTE PTR [r9+r11*1],0x2
  9339cd:	75 e1                	jne    9339b0 <check_input_intrinsic_initialize+0x690>
  9339cf:	4c 8b 51 60          	mov    r10,QWORD PTR [rcx+0x60]
  9339d3:	43 80 3c 1a 02       	cmp    BYTE PTR [r10+r11*1],0x2
  9339d8:	75 d6                	jne    9339b0 <check_input_intrinsic_initialize+0x690>
  9339da:	4c 8b 54 24 08       	mov    r10,QWORD PTR [rsp+0x8]
  9339df:	4d 8b 52 28          	mov    r10,QWORD PTR [r10+0x28]
  9339e3:	47 8b 14 9a          	mov    r10d,DWORD PTR [r10+r11*4]
  9339e7:	42 83 3c 92 fe       	cmp    DWORD PTR [rdx+r10*4],0xfffffffe
  9339ec:	7f c2                	jg     9339b0 <check_input_intrinsic_initialize+0x690>
  9339ee:	45 31 d2             	xor    r10d,r10d
  9339f1:	39 d8                	cmp    eax,ebx
  9339f3:	76 ad                	jbe    9339a2 <check_input_intrinsic_initialize+0x682>
  9339f5:	48 8b 5c 24 08       	mov    rbx,QWORD PTR [rsp+0x8]
  9339fa:	4d 8d 7b 01          	lea    r15,[r11+0x1]
  9339fe:	48 8b 5b 70          	mov    rbx,QWORD PTR [rbx+0x70]
  933a02:	46 8b 34 9b          	mov    r14d,DWORD PTR [rbx+r11*4]
  933a06:	45 39 f7             	cmp    r15d,r14d
  933a09:	73 97                	jae    9339a2 <check_input_intrinsic_initialize+0x682>
  933a0b:	41 39 c6             	cmp    r14d,eax
  933a0e:	73 92                	jae    9339a2 <check_input_intrinsic_initialize+0x682>
  933a10:	4c 8b 64 24 08       	mov    r12,QWORD PTR [rsp+0x8]
  933a15:	4d 8b 64 24 60       	mov    r12,QWORD PTR [r12+0x60]
  933a1a:	43 80 3c 1c 02       	cmp    BYTE PTR [r12+r11*1],0x2
  933a1f:	75 81                	jne    9339a2 <check_input_intrinsic_initialize+0x682>
  933a21:	43 80 3c 3c 23       	cmp    BYTE PTR [r12+r15*1],0x23
  933a26:	0f 85 76 ff ff ff    	jne    9339a2 <check_input_intrinsic_initialize+0x682>
  933a2c:	43 80 3c 34 3c       	cmp    BYTE PTR [r12+r14*1],0x3c
  933a31:	0f 85 6b ff ff ff    	jne    9339a2 <check_input_intrinsic_initialize+0x682>
  933a37:	45 31 d2             	xor    r10d,r10d
  933a3a:	46 39 74 9b 04       	cmp    DWORD PTR [rbx+r11*4+0x4],r14d
  933a3f:	41 0f 94 c2          	sete   r10b
  933a43:	e9 5a ff ff ff       	jmp    9339a2 <check_input_intrinsic_initialize+0x682>
  933a48:	49 89 d0             	mov    r8,rdx
  933a4b:	49 8b 4e 20          	mov    rcx,QWORD PTR [r14+0x20]
  933a4f:	48 8b 11             	mov    rdx,QWORD PTR [rcx]
  933a52:	48 8b 71 08          	mov    rsi,QWORD PTR [rcx+0x8]
  933a56:	48 8d 7c 16 3f       	lea    rdi,[rsi+rdx*1+0x3f]
  933a5b:	48 01 d6             	add    rsi,rdx
  933a5e:	48 83 e7 c0          	and    rdi,0xffffffffffffffc0
  933a62:	48 39 f7             	cmp    rdi,rsi
  933a65:	73 58                	jae    933abf <check_input_intrinsic_initialize+0x79f>
  933a67:	45 31 f6             	xor    r14d,r14d
  933a6a:	48 8d 46 07          	lea    rax,[rsi+0x7]
  933a6e:	48 83 e0 f8          	and    rax,0xfffffffffffffff8
  933a72:	48 39 f0             	cmp    rax,rsi
  933a75:	0f 82 a5 00 00 00    	jb     933b20 <check_input_intrinsic_initialize+0x800>
  933a7b:	48 89 c6             	mov    rsi,rax
  933a7e:	48 29 d6             	sub    rsi,rdx
  933a81:	48 8b 51 10          	mov    rdx,QWORD PTR [rcx+0x10]
  933a85:	31 db                	xor    ebx,ebx
  933a87:	48 29 f2             	sub    rdx,rsi
  933a8a:	72 29                	jb     933ab5 <check_input_intrinsic_initialize+0x795>
  933a8c:	8b 7c 24 10          	mov    edi,DWORD PTR [rsp+0x10]
  933a90:	48 69 ff 30 01 00 00 	imul   rdi,rdi,0x130
  933a97:	48 39 d7             	cmp    rdi,rdx
  933a9a:	77 19                	ja     933ab5 <check_input_intrinsic_initialize+0x795>
  933a9c:	48 01 fe             	add    rsi,rdi
  933a9f:	48 89 c3             	mov    rbx,rax
  933aa2:	48 89 71 08          	mov    QWORD PTR [rcx+0x8],rsi
  933aa6:	48 8b 51 20          	mov    rdx,QWORD PTR [rcx+0x20]
  933aaa:	48 39 d6             	cmp    rsi,rdx
  933aad:	48 0f 46 f2          	cmovbe rsi,rdx
  933ab1:	48 89 71 20          	mov    QWORD PTR [rcx+0x20],rsi
  933ab5:	45 85 ed             	test   r13d,r13d
  933ab8:	75 6d                	jne    933b27 <check_input_intrinsic_initialize+0x807>
  933aba:	e9 8c 00 00 00       	jmp    933b4b <check_input_intrinsic_initialize+0x82b>
  933abf:	4c 8b 49 10          	mov    r9,QWORD PTR [rcx+0x10]
  933ac3:	4d 89 c2             	mov    r10,r8
  933ac6:	49 89 f8             	mov    r8,rdi
  933ac9:	49 29 d0             	sub    r8,rdx
  933acc:	45 31 f6             	xor    r14d,r14d
  933acf:	4d 29 c1             	sub    r9,r8
  933ad2:	72 38                	jb     933b0c <check_input_intrinsic_initialize+0x7ec>
  933ad4:	48 8d 04 85 04 00 00 	lea    rax,[rax*4+0x4]
  933adb:	00 
  933adc:	4c 39 c8             	cmp    rax,r9
  933adf:	77 2b                	ja     933b0c <check_input_intrinsic_initialize+0x7ec>
  933ae1:	49 01 c0             	add    r8,rax
  933ae4:	49 89 fe             	mov    r14,rdi
  933ae7:	4c 89 41 08          	mov    QWORD PTR [rcx+0x8],r8
  933aeb:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
  933aef:	49 39 c0             	cmp    r8,rax
  933af2:	4c 0f 46 c0          	cmovbe r8,rax
  933af6:	4c 89 41 20          	mov    QWORD PTR [rcx+0x20],r8
  933afa:	48 8b 0c 24          	mov    rcx,QWORD PTR [rsp]
  933afe:	48 8b 49 20          	mov    rcx,QWORD PTR [rcx+0x20]
  933b02:	48 8b 11             	mov    rdx,QWORD PTR [rcx]
  933b05:	48 8b 71 08          	mov    rsi,QWORD PTR [rcx+0x8]
  933b09:	48 01 d6             	add    rsi,rdx
  933b0c:	4d 89 d0             	mov    r8,r10
  933b0f:	48 8d 46 07          	lea    rax,[rsi+0x7]
  933b13:	48 83 e0 f8          	and    rax,0xfffffffffffffff8
  933b17:	48 39 f0             	cmp    rax,rsi
  933b1a:	0f 83 5b ff ff ff    	jae    933a7b <check_input_intrinsic_initialize+0x75b>
  933b20:	31 db                	xor    ebx,ebx
  933b22:	45 85 ed             	test   r13d,r13d
  933b25:	74 24                	je     933b4b <check_input_intrinsic_initialize+0x82b>
  933b27:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
  933b2b:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  933b2f:	48 8b 30             	mov    rsi,QWORD PTR [rax]
  933b32:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  933b36:	48 8d 4c 32 07       	lea    rcx,[rdx+rsi*1+0x7]
  933b3b:	48 01 f2             	add    rdx,rsi
  933b3e:	48 83 e1 f8          	and    rcx,0xfffffffffffffff8
  933b42:	48 39 d1             	cmp    rcx,rdx
  933b45:	0f 83 e4 00 00 00    	jae    933c2f <check_input_intrinsic_initialize+0x90f>
  933b4b:	45 31 ff             	xor    r15d,r15d
  933b4e:	45 85 ed             	test   r13d,r13d
  933b51:	0f 94 c0             	sete   al
  933b54:	4d 85 ff             	test   r15,r15
  933b57:	0f 95 c1             	setne  cl
  933b5a:	4d 85 c0             	test   r8,r8
  933b5d:	74 7c                	je     933bdb <check_input_intrinsic_initialize+0x8bb>
  933b5f:	4d 85 f6             	test   r14,r14
  933b62:	74 77                	je     933bdb <check_input_intrinsic_initialize+0x8bb>
  933b64:	48 85 db             	test   rbx,rbx
  933b67:	74 72                	je     933bdb <check_input_intrinsic_initialize+0x8bb>
  933b69:	08 c8                	or     al,cl
  933b6b:	74 6e                	je     933bdb <check_input_intrinsic_initialize+0x8bb>
  933b6d:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  933b72:	4c 89 f7             	mov    rdi,r14
  933b75:	31 f6                	xor    esi,esi
  933b77:	4d 89 c4             	mov    r12,r8
  933b7a:	8b 40 40             	mov    eax,DWORD PTR [rax+0x40]
  933b7d:	48 8d 14 85 04 00 00 	lea    rdx,[rax*4+0x4]
  933b84:	00 
  933b85:	c5 f8 77             	vzeroupper
  933b88:	e8 f3 a2 fc ff       	call   8fde80 <memset@plt>
  933b8d:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
  933b91:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
  933b96:	8b 4c 24 10          	mov    ecx,DWORD PTR [rsp+0x10]
  933b9a:	4c 89 a0 80 02 00 00 	mov    QWORD PTR [rax+0x280],r12
  933ba1:	4c 89 b2 c0 02 00 00 	mov    QWORD PTR [rdx+0x2c0],r14
  933ba8:	48 89 9a a0 02 00 00 	mov    QWORD PTR [rdx+0x2a0],rbx
  933baf:	c7 82 a8 02 00 00 00 	mov    DWORD PTR [rdx+0x2a8],0x0
  933bb6:	00 00 00 
  933bb9:	89 8a ac 02 00 00    	mov    DWORD PTR [rdx+0x2ac],ecx
  933bbf:	4c 89 ba b0 02 00 00 	mov    QWORD PTR [rdx+0x2b0],r15
  933bc6:	c7 82 b8 02 00 00 00 	mov    DWORD PTR [rdx+0x2b8],0x0
  933bcd:	00 00 00 
  933bd0:	44 89 aa bc 02 00 00 	mov    DWORD PTR [rdx+0x2bc],r13d
  933bd7:	b0 01                	mov    al,0x1
  933bd9:	eb 2c                	jmp    933c07 <check_input_intrinsic_initialize+0x8e7>
  933bdb:	48 8b 0c 24          	mov    rcx,QWORD PTR [rsp]
  933bdf:	48 8b 54 24 30       	mov    rdx,QWORD PTR [rsp+0x30]
  933be4:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
  933be8:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  933bec:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
  933bf1:	48 8b 41 28          	mov    rax,QWORD PTR [rcx+0x28]
  933bf5:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  933bf9:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  933bfe:	c6 80 9e 05 00 00 01 	mov    BYTE PTR [rax+0x59e],0x1
  933c05:	31 c0                	xor    eax,eax
  933c07:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  933c0e:	00 00 
  933c10:	48 3b 8c 24 e0 00 00 	cmp    rcx,QWORD PTR [rsp+0xe0]
  933c17:	00 
  933c18:	75 59                	jne    933c73 <check_input_intrinsic_initialize+0x953>
  933c1a:	48 81 c4 e8 00 00 00 	add    rsp,0xe8
  933c21:	5b                   	pop    rbx
  933c22:	41 5c                	pop    r12
  933c24:	41 5d                	pop    r13
  933c26:	41 5e                	pop    r14
  933c28:	41 5f                	pop    r15
  933c2a:	5d                   	pop    rbp
  933c2b:	c5 f8 77             	vzeroupper
  933c2e:	c3                   	ret
  933c2f:	48 8b 78 10          	mov    rdi,QWORD PTR [rax+0x10]
  933c33:	48 89 ca             	mov    rdx,rcx
  933c36:	48 29 f2             	sub    rdx,rsi
  933c39:	45 31 ff             	xor    r15d,r15d
  933c3c:	48 29 d7             	sub    rdi,rdx
  933c3f:	0f 82 09 ff ff ff    	jb     933b4e <check_input_intrinsic_initialize+0x82e>
  933c45:	44 89 ee             	mov    esi,r13d
  933c48:	48 c1 e6 05          	shl    rsi,0x5
  933c4c:	48 39 fe             	cmp    rsi,rdi
  933c4f:	0f 87 f9 fe ff ff    	ja     933b4e <check_input_intrinsic_initialize+0x82e>
  933c55:	48 01 f2             	add    rdx,rsi
  933c58:	49 89 cf             	mov    r15,rcx
  933c5b:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  933c5f:	48 8b 70 20          	mov    rsi,QWORD PTR [rax+0x20]
  933c63:	48 39 f2             	cmp    rdx,rsi
  933c66:	48 0f 46 d6          	cmovbe rdx,rsi
  933c6a:	48 89 50 20          	mov    QWORD PTR [rax+0x20],rdx
  933c6e:	e9 db fe ff ff       	jmp    933b4e <check_input_intrinsic_initialize+0x82e>
  933c73:	c5 f8 77             	vzeroupper
  933c76:	e8 c5 98 fc ff       	call   8fd540 <__stack_chk_fail@plt>
