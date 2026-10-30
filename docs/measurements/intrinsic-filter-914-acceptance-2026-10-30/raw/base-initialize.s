
work/pr914-acceptance/bin/base/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

000000000093b380 <check_input_intrinsic_initialize>:
  93b380:	55                   	push   rbp
  93b381:	41 57                	push   r15
  93b383:	41 56                	push   r14
  93b385:	41 55                	push   r13
  93b387:	41 54                	push   r12
  93b389:	53                   	push   rbx
  93b38a:	48 81 ec 68 03 00 00 	sub    rsp,0x368
  93b391:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  93b398:	00 00 
  93b39a:	49 89 fa             	mov    r10,rdi
  93b39d:	45 31 ed             	xor    r13d,r13d
  93b3a0:	31 d2                	xor    edx,edx
  93b3a2:	48 89 84 24 60 03 00 	mov    QWORD PTR [rsp+0x360],rax
  93b3a9:	00 
  93b3aa:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
  93b3b1:	00 00 
  93b3b3:	c7 44 24 14 00 00 00 	mov    DWORD PTR [rsp+0x14],0x0
  93b3ba:	00 
  93b3bb:	c7 44 24 0c 00 00 00 	mov    DWORD PTR [rsp+0xc],0x0
  93b3c2:	00 
  93b3c3:	48 89 7c 24 18       	mov    QWORD PTR [rsp+0x18],rdi
  93b3c8:	48 8b 07             	mov    rax,QWORD PTR [rdi]
  93b3cb:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
  93b3cf:	48 8b 77 10          	mov    rsi,QWORD PTR [rdi+0x10]
  93b3d3:	48 89 84 24 f0 00 00 	mov    QWORD PTR [rsp+0xf0],rax
  93b3da:	00 
  93b3db:	48 8b 86 98 02 00 00 	mov    rax,QWORD PTR [rsi+0x298]
  93b3e2:	48 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],rcx
  93b3e7:	48 8b 4f 20          	mov    rcx,QWORD PTR [rdi+0x20]
  93b3eb:	48 8b 77 28          	mov    rsi,QWORD PTR [rdi+0x28]
  93b3ef:	48 89 84 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],rax
  93b3f6:	00 
  93b3f7:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
  93b3fb:	48 8d 8c 24 60 02 00 	lea    rcx,[rsp+0x260]
  93b402:	00 
  93b403:	62 f2 fd 48 7c c1    	vpbroadcastq zmm0,rcx
  93b409:	62 f1 fd 48 d4 0d 6d 	vpaddq zmm1,zmm0,ZMMWORD PTR [rip+0xffffffffffb7c26d]        # 4b7680 <cbuiltin_test_generated.edges+0x1320>
  93b410:	c2 b7 ff 
  93b413:	62 f1 fd 48 d4 05 a3 	vpaddq zmm0,zmm0,ZMMWORD PTR [rip+0xffffffffffb7c2a3]        # 4b76c0 <cbuiltin_test_generated.edges+0x1360>
  93b41a:	c2 b7 ff 
  93b41d:	48 89 84 24 38 01 00 	mov    QWORD PTR [rsp+0x138],rax
  93b424:	00 
  93b425:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
  93b429:	62 f1 fe 48 7f 44 24 	vmovdqu64 ZMMWORD PTR [rsp+0x1c0],zmm0
  93b430:	07 
  93b431:	62 f2 7d 48 5a 05 85 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc9d85]        # 6051c0 <abi_test_hex.digits+0x370>
  93b438:	9d cc ff 
  93b43b:	62 f1 fe 48 7f 4c 24 	vmovdqu64 ZMMWORD PTR [rsp+0x200],zmm1
  93b442:	08 
  93b443:	48 89 84 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],rax
  93b44a:	00 
  93b44b:	eb 1d                	jmp    93b46a <check_input_intrinsic_initialize+0xea>
  93b44d:	0f 1f 00             	nop    DWORD PTR [rax]
  93b450:	b0 01                	mov    al,0x1
  93b452:	8b 54 24 3c          	mov    edx,DWORD PTR [rsp+0x3c]
  93b456:	4c 89 44 24 30       	mov    QWORD PTR [rsp+0x30],r8
  93b45b:	89 6c 24 0c          	mov    DWORD PTR [rsp+0xc],ebp
  93b45f:	83 c2 40             	add    edx,0x40
  93b462:	84 c0                	test   al,al
  93b464:	0f 84 12 1c 00 00    	je     93d07c <check_input_intrinsic_initialize+0x1cfc>
  93b46a:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  93b46f:	3b 50 40             	cmp    edx,DWORD PTR [rax+0x40]
  93b472:	0f 83 b2 0f 00 00    	jae    93c42a <check_input_intrinsic_initialize+0x10aa>
  93b478:	49 8b 72 08          	mov    rsi,QWORD PTR [r10+0x8]
  93b47c:	49 8b 02             	mov    rax,QWORD PTR [r10]
  93b47f:	8b 6c 24 0c          	mov    ebp,DWORD PTR [rsp+0xc]
  93b483:	4c 8b 44 24 30       	mov    r8,QWORD PTR [rsp+0x30]
  93b488:	89 54 24 3c          	mov    DWORD PTR [rsp+0x3c],edx
  93b48c:	8b 4e 40             	mov    ecx,DWORD PTR [rsi+0x40]
  93b48f:	48 8b 80 98 02 00 00 	mov    rax,QWORD PTR [rax+0x298]
  93b496:	29 d1                	sub    ecx,edx
  93b498:	83 f9 3f             	cmp    ecx,0x3f
  93b49b:	77 33                	ja     93b4d0 <check_input_intrinsic_initialize+0x150>
  93b49d:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  93b4a4:	89 ca                	mov    edx,ecx
  93b4a6:	c4 62 e8 f5 ff       	bzhi   r15,rdi,rdx
  93b4ab:	80 3e 00             	cmp    BYTE PTR [rsi],0x0
  93b4ae:	75 7a                	jne    93b52a <check_input_intrinsic_initialize+0x1aa>
  93b4b0:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
  93b4b4:	8b 54 24 3c          	mov    edx,DWORD PTR [rsp+0x3c]
  93b4b8:	c4 c1 fb 92 cf       	kmovq  k1,r15
  93b4bd:	62 f1 7d 49 74 14 17 	vpcmpeqb k2{k1},zmm0,ZMMWORD PTR [rdi+rdx*1]
  93b4c4:	eb 2a                	jmp    93b4f0 <check_input_intrinsic_initialize+0x170>
  93b4c6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  93b4cd:	00 00 00 
  93b4d0:	80 3e 00             	cmp    BYTE PTR [rsi],0x0
  93b4d3:	49 c7 c7 ff ff ff ff 	mov    r15,0xffffffffffffffff
  93b4da:	75 57                	jne    93b533 <check_input_intrinsic_initialize+0x1b3>
  93b4dc:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
  93b4e0:	8b 54 24 3c          	mov    edx,DWORD PTR [rsp+0x3c]
  93b4e4:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93b4e9:	62 f1 7d 48 74 14 17 	vpcmpeqb k2,zmm0,ZMMWORD PTR [rdi+rdx*1]
  93b4f0:	48 8b 76 60          	mov    rsi,QWORD PTR [rsi+0x60]
  93b4f4:	62 f1 fd 48 6f c8    	vmovdqa64 zmm1,zmm0
  93b4fa:	62 f1 7f c9 6f 04 16 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rsi+rdx*1]
  93b501:	62 f1 7d 4a 74 c1    	vpcmpeqb k0{k2},zmm0,zmm1
  93b507:	62 f1 fd 48 6f c1    	vmovdqa64 zmm0,zmm1
  93b50d:	c4 e1 f4 41 c0       	kandq  k0,k1,k0
  93b512:	c4 61 fb 93 f8       	kmovq  r15,k0
  93b517:	48 85 c0             	test   rax,rax
  93b51a:	74 0e                	je     93b52a <check_input_intrinsic_initialize+0x1aa>
  93b51c:	49 83 ba d0 05 00 00 	cmp    QWORD PTR [r10+0x5d0],0x0
  93b523:	00 
  93b524:	0f 84 b1 0e 00 00    	je     93c3db <check_input_intrinsic_initialize+0x105b>
  93b52a:	4d 85 ff             	test   r15,r15
  93b52d:	0f 84 1d ff ff ff    	je     93b450 <check_input_intrinsic_initialize+0xd0>
  93b533:	44 8b 64 24 3c       	mov    r12d,DWORD PTR [rsp+0x3c]
  93b538:	4c 89 a4 24 00 01 00 	mov    QWORD PTR [rsp+0x100],r12
  93b53f:	00 
  93b540:	49 8b 4a 08          	mov    rcx,QWORD PTR [r10+0x8]
  93b544:	31 c0                	xor    eax,eax
  93b546:	f3 49 0f bc c7       	tzcnt  rax,r15
  93b54b:	4c 09 e0             	or     rax,r12
  93b54e:	48 8b 51 20          	mov    rdx,QWORD PTR [rcx+0x20]
  93b552:	80 3c 02 02          	cmp    BYTE PTR [rdx+rax*1],0x2
  93b556:	0f 85 94 01 00 00    	jne    93b6f0 <check_input_intrinsic_initialize+0x370>
  93b55c:	48 8b 49 60          	mov    rcx,QWORD PTR [rcx+0x60]
  93b560:	80 3c 01 02          	cmp    BYTE PTR [rcx+rax*1],0x2
  93b564:	0f 85 86 01 00 00    	jne    93b6f0 <check_input_intrinsic_initialize+0x370>
  93b56a:	49 8b 0a             	mov    rcx,QWORD PTR [r10]
  93b56d:	48 8b 89 98 02 00 00 	mov    rcx,QWORD PTR [rcx+0x298]
  93b574:	48 85 c9             	test   rcx,rcx
  93b577:	74 0a                	je     93b583 <check_input_intrinsic_initialize+0x203>
  93b579:	49 83 ba d0 05 00 00 	cmp    QWORD PTR [r10+0x5d0],0x0
  93b580:	00 
  93b581:	74 72                	je     93b5f5 <check_input_intrinsic_initialize+0x275>
  93b583:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
  93b588:	48 8b 49 28          	mov    rcx,QWORD PTR [rcx+0x28]
  93b58c:	44 8b 34 81          	mov    r14d,DWORD PTR [rcx+rax*4]
  93b590:	4d 85 c0             	test   r8,r8
  93b593:	75 33                	jne    93b5c8 <check_input_intrinsic_initialize+0x248>
  93b595:	f6 44 24 14 01       	test   BYTE PTR [rsp+0x14],0x1
  93b59a:	75 2c                	jne    93b5c8 <check_input_intrinsic_initialize+0x248>
  93b59c:	49 8b 4a 28          	mov    rcx,QWORD PTR [r10+0x28]
  93b5a0:	48 8b 01             	mov    rax,QWORD PTR [rcx]
  93b5a3:	48 8b 51 08          	mov    rdx,QWORD PTR [rcx+0x8]
  93b5a7:	48 8d 5c 02 3f       	lea    rbx,[rdx+rax*1+0x3f]
  93b5ac:	48 01 c2             	add    rdx,rax
  93b5af:	48 83 e3 c0          	and    rbx,0xffffffffffffffc0
  93b5b3:	48 39 d3             	cmp    rbx,rdx
  93b5b6:	73 49                	jae    93b601 <check_input_intrinsic_initialize+0x281>
  93b5b8:	b0 01                	mov    al,0x1
  93b5ba:	b1 01                	mov    cl,0x1
  93b5bc:	45 31 c0             	xor    r8d,r8d
  93b5bf:	89 4c 24 14          	mov    DWORD PTR [rsp+0x14],ecx
  93b5c3:	e9 d6 00 00 00       	jmp    93b69e <check_input_intrinsic_initialize+0x31e>
  93b5c8:	f6 44 24 14 01       	test   BYTE PTR [rsp+0x14],0x1
  93b5cd:	b0 01                	mov    al,0x1
  93b5cf:	b1 01                	mov    cl,0x1
  93b5d1:	89 4c 24 14          	mov    DWORD PTR [rsp+0x14],ecx
  93b5d5:	0f 85 c3 00 00 00    	jne    93b69e <check_input_intrinsic_initialize+0x31e>
  93b5db:	43 83 3c b0 ff       	cmp    DWORD PTR [r8+r14*4],0xffffffff
  93b5e0:	c7 44 24 14 00 00 00 	mov    DWORD PTR [rsp+0x14],0x0
  93b5e7:	00 
  93b5e8:	0f 85 02 01 00 00    	jne    93b6f0 <check_input_intrinsic_initialize+0x370>
  93b5ee:	31 c0                	xor    eax,eax
  93b5f0:	e9 a9 00 00 00       	jmp    93b69e <check_input_intrinsic_initialize+0x31e>
  93b5f5:	80 3c 01 00          	cmp    BYTE PTR [rcx+rax*1],0x0
  93b5f9:	0f 85 f1 00 00 00    	jne    93b6f0 <check_input_intrinsic_initialize+0x370>
  93b5ff:	eb 82                	jmp    93b583 <check_input_intrinsic_initialize+0x203>
  93b601:	48 8b 71 10          	mov    rsi,QWORD PTR [rcx+0x10]
  93b605:	48 89 da             	mov    rdx,rbx
  93b608:	48 29 c2             	sub    rdx,rax
  93b60b:	b0 01                	mov    al,0x1
  93b60d:	48 29 d6             	sub    rsi,rdx
  93b610:	72 a8                	jb     93b5ba <check_input_intrinsic_initialize+0x23a>
  93b612:	48 8b bc 24 b0 00 00 	mov    rdi,QWORD PTR [rsp+0xb0]
  93b619:	00 
  93b61a:	41 b1 01             	mov    r9b,0x1
  93b61d:	41 b8 00 00 00 00    	mov    r8d,0x0
  93b623:	44 89 4c 24 14       	mov    DWORD PTR [rsp+0x14],r9d
  93b628:	8b bf 88 00 00 00    	mov    edi,DWORD PTR [rdi+0x88]
  93b62e:	48 c1 e7 02          	shl    rdi,0x2
  93b632:	48 39 f7             	cmp    rdi,rsi
  93b635:	77 67                	ja     93b69e <check_input_intrinsic_initialize+0x31e>
  93b637:	48 01 fa             	add    rdx,rdi
  93b63a:	48 89 51 08          	mov    QWORD PTR [rcx+0x8],rdx
  93b63e:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
  93b642:	48 39 c2             	cmp    rdx,rax
  93b645:	48 0f 46 d0          	cmovbe rdx,rax
  93b649:	48 89 51 20          	mov    QWORD PTR [rcx+0x20],rdx
  93b64d:	48 85 db             	test   rbx,rbx
  93b650:	0f 84 62 ff ff ff    	je     93b5b8 <check_input_intrinsic_initialize+0x238>
  93b656:	48 8b 84 24 b0 00 00 	mov    rax,QWORD PTR [rsp+0xb0]
  93b65d:	00 
  93b65e:	be ff 00 00 00       	mov    esi,0xff
  93b663:	48 89 df             	mov    rdi,rbx
  93b666:	8b 90 88 00 00 00    	mov    edx,DWORD PTR [rax+0x88]
  93b66c:	48 c1 e2 02          	shl    rdx,0x2
  93b670:	c5 f8 77             	vzeroupper
  93b673:	e8 b8 b0 fc ff       	call   906730 <memset@plt>
  93b678:	62 f2 7d 48 5a 05 3e 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc9b3e]        # 6051c0 <abi_test_hex.digits+0x370>
  93b67f:	9b cc ff 
  93b682:	4c 8b 54 24 18       	mov    r10,QWORD PTR [rsp+0x18]
  93b687:	49 89 d8             	mov    r8,rbx
  93b68a:	43 83 3c b0 ff       	cmp    DWORD PTR [r8+r14*4],0xffffffff
  93b68f:	c7 44 24 14 00 00 00 	mov    DWORD PTR [rsp+0x14],0x0
  93b696:	00 
  93b697:	75 57                	jne    93b6f0 <check_input_intrinsic_initialize+0x370>
  93b699:	e9 50 ff ff ff       	jmp    93b5ee <check_input_intrinsic_initialize+0x26e>
  93b69e:	48 8b bc 24 b0 00 00 	mov    rdi,QWORD PTR [rsp+0xb0]
  93b6a5:	00 
  93b6a6:	44 89 ee             	mov    esi,r13d
  93b6a9:	48 8b 4f 10          	mov    rcx,QWORD PTR [rdi+0x10]
  93b6ad:	42 8b 14 f1          	mov    edx,DWORD PTR [rcx+r14*8]
  93b6b1:	42 8b 4c f1 04       	mov    ecx,DWORD PTR [rcx+r14*8+0x4]
  93b6b6:	48 03 57 50          	add    rdx,QWORD PTR [rdi+0x50]
  93b6ba:	44 89 b4 b4 40 02 00 	mov    DWORD PTR [rsp+rsi*4+0x240],r14d
  93b6c1:	00 
  93b6c2:	48 c1 e6 04          	shl    rsi,0x4
  93b6c6:	48 89 94 34 60 02 00 	mov    QWORD PTR [rsp+rsi*1+0x260],rdx
  93b6cd:	00 
  93b6ce:	89 8c 34 68 02 00 00 	mov    DWORD PTR [rsp+rsi*1+0x268],ecx
  93b6d5:	c7 84 34 6c 02 00 00 	mov    DWORD PTR [rsp+rsi*1+0x26c],0x0
  93b6dc:	00 00 00 00 
  93b6e0:	84 c0                	test   al,al
  93b6e2:	75 08                	jne    93b6ec <check_input_intrinsic_initialize+0x36c>
  93b6e4:	43 c7 04 b0 00 00 00 	mov    DWORD PTR [r8+r14*4],0x0
  93b6eb:	00 
  93b6ec:	41 ff c5             	inc    r13d
  93b6ef:	90                   	nop
  93b6f0:	b0 01                	mov    al,0x1
  93b6f2:	41 83 fd 08          	cmp    r13d,0x8
  93b6f6:	0f 85 c7 0c 00 00    	jne    93c3c3 <check_input_intrinsic_initialize+0x1043>
  93b6fc:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  93b701:	4c 89 bc 24 08 01 00 	mov    QWORD PTR [rsp+0x108],r15
  93b708:	00 
  93b709:	4c 89 44 24 30       	mov    QWORD PTR [rsp+0x30],r8
  93b70e:	89 6c 24 0c          	mov    DWORD PTR [rsp+0xc],ebp
  93b712:	80 38 01             	cmp    BYTE PTR [rax],0x1
  93b715:	0f 85 f5 00 00 00    	jne    93b810 <check_input_intrinsic_initialize+0x490>
  93b71b:	31 c0                	xor    eax,eax
  93b71d:	eb 21                	jmp    93b740 <check_input_intrinsic_initialize+0x3c0>
  93b71f:	90                   	nop
  93b720:	45 31 e4             	xor    r12d,r12d
  93b723:	48 8b 84 24 90 00 00 	mov    rax,QWORD PTR [rsp+0x90]
  93b72a:	00 
  93b72b:	4c 89 a4 c4 e0 02 00 	mov    QWORD PTR [rsp+rax*8+0x2e0],r12
  93b732:	00 
  93b733:	48 ff c0             	inc    rax
  93b736:	48 83 f8 08          	cmp    rax,0x8
  93b73a:	0f 84 3e 0a 00 00    	je     93c17e <check_input_intrinsic_initialize+0xdfe>
  93b740:	48 89 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],rax
  93b747:	00 
  93b748:	48 c1 e0 04          	shl    rax,0x4
  93b74c:	48 8b 8c 04 60 02 00 	mov    rcx,QWORD PTR [rsp+rax*1+0x260]
  93b753:	00 
  93b754:	8b b4 04 68 02 00 00 	mov    esi,DWORD PTR [rsp+rax*1+0x268]
  93b75b:	48 85 c9             	test   rcx,rcx
  93b75e:	48 89 4c 24 60       	mov    QWORD PTR [rsp+0x60],rcx
  93b763:	0f 94 c0             	sete   al
  93b766:	85 f6                	test   esi,esi
  93b768:	0f 94 c1             	sete   cl
  93b76b:	08 c1                	or     cl,al
  93b76d:	75 b1                	jne    93b720 <check_input_intrinsic_initialize+0x3a0>
  93b76f:	41 bd bf 0e 00 00    	mov    r13d,0xebf
  93b775:	45 31 e4             	xor    r12d,r12d
  93b778:	45 31 ff             	xor    r15d,r15d
  93b77b:	89 74 24 10          	mov    DWORD PTR [rsp+0x10],esi
  93b77f:	eb 38                	jmp    93b7b9 <check_input_intrinsic_initialize+0x439>
  93b781:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93b788:	0f 1f 84 00 00 00 00 
  93b78f:	00 
  93b790:	39 ee                	cmp    esi,ebp
  93b792:	0f 97 c0             	seta   al
  93b795:	1c 00                	sbb    al,0x0
  93b797:	0f be c0             	movsx  eax,al
  93b79a:	85 c0                	test   eax,eax
  93b79c:	41 8d 4e 01          	lea    ecx,[r14+0x1]
  93b7a0:	45 0f 48 ee          	cmovs  r13d,r14d
  93b7a4:	4c 0f 44 e3          	cmove  r12,rbx
  93b7a8:	45 0f 44 ef          	cmove  r13d,r15d
  93b7ac:	44 0f 4f f9          	cmovg  r15d,ecx
  93b7b0:	45 39 ef             	cmp    r15d,r13d
  93b7b3:	0f 83 6a ff ff ff    	jae    93b723 <check_input_intrinsic_initialize+0x3a3>
  93b7b9:	45 89 ee             	mov    r14d,r13d
  93b7bc:	45 29 fe             	sub    r14d,r15d
  93b7bf:	48 8d 0d ba a3 89 01 	lea    rcx,[rip+0x189a3ba]        # 21d5b80 <builtin_intrinsic_infos>
  93b7c6:	41 d1 ee             	shr    r14d,1
  93b7c9:	45 01 fe             	add    r14d,r15d
  93b7cc:	4b 8d 04 76          	lea    rax,[r14+r14*2]
  93b7d0:	48 c1 e0 05          	shl    rax,0x5
  93b7d4:	8b 6c 08 40          	mov    ebp,DWORD PTR [rax+rcx*1+0x40]
  93b7d8:	48 8d 1c 01          	lea    rbx,[rcx+rax*1]
  93b7dc:	85 ed                	test   ebp,ebp
  93b7de:	74 b0                	je     93b790 <check_input_intrinsic_initialize+0x410>
  93b7e0:	39 ee                	cmp    esi,ebp
  93b7e2:	89 ea                	mov    edx,ebp
  93b7e4:	48 8b 7c 24 60       	mov    rdi,QWORD PTR [rsp+0x60]
  93b7e9:	0f 42 d6             	cmovb  edx,esi
  93b7ec:	48 8b 33             	mov    rsi,QWORD PTR [rbx]
  93b7ef:	c5 f8 77             	vzeroupper
  93b7f2:	e8 09 af fc ff       	call   906700 <memcmp@plt>
  93b7f7:	62 f2 7d 48 5a 05 bf 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc99bf]        # 6051c0 <abi_test_hex.digits+0x370>
  93b7fe:	99 cc ff 
  93b801:	8b 74 24 10          	mov    esi,DWORD PTR [rsp+0x10]
  93b805:	85 c0                	test   eax,eax
  93b807:	75 91                	jne    93b79a <check_input_intrinsic_initialize+0x41a>
  93b809:	eb 85                	jmp    93b790 <check_input_intrinsic_initialize+0x410>
  93b80b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
  93b810:	62 f1 fe 48 6f 4c 24 	vmovdqu64 zmm1,ZMMWORD PTR [rsp+0x200]
  93b817:	08 
  93b818:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  93b81c:	62 f1 fe 48 7f 84 24 	vmovdqu64 ZMMWORD PTR [rsp+0x2e0],zmm0
  93b823:	e0 02 00 00 
  93b827:	c5 fd 46 c8          	kxnorb k1,k0,k0
  93b82b:	62 f1 fe 48 6f 54 24 	vmovdqu64 zmm2,ZMMWORD PTR [rsp+0x1c0]
  93b832:	07 
  93b833:	62 f2 fd 49 91 04 0d 	vpgatherqq zmm0{k1},QWORD PTR [zmm1*1+0x0]
  93b83a:	00 00 00 00 
  93b83e:	62 f2 fd 48 27 c8    	vptestmq k1,zmm0,zmm0
  93b844:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  93b848:	c4 e1 f8 90 d1       	kmovq  k2,k1
  93b84d:	62 f2 7d 4a 91 04 15 	vpgatherqd ymm0{k2},DWORD PTR [zmm2*1+0x0]
  93b854:	00 00 00 00 
  93b858:	62 f2 7d 29 27 d0    	vptestmd k2{k1},ymm0,ymm0
  93b85e:	62 f2 7e 28 38 c2    	vpmovm2d ymm0,k2
  93b864:	c4 e2 7d 0e c0       	vtestps ymm0,ymm0
  93b869:	62 f2 7d 48 5a 05 4d 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc994d]        # 6051c0 <abi_test_hex.digits+0x370>
  93b870:	99 cc ff 
  93b873:	0f 84 05 09 00 00    	je     93c17e <check_input_intrinsic_initialize+0xdfe>
  93b879:	8b 94 24 78 02 00 00 	mov    edx,DWORD PTR [rsp+0x278]
  93b880:	8b 8c 24 88 02 00 00 	mov    ecx,DWORD PTR [rsp+0x288]
  93b887:	62 f2 7d aa 58 05 cb 	vpbroadcastd ymm0{k2}{z},DWORD PTR [rip+0xffffffffffce47cb]        # 62005c <link_program_emit_worker.forms+0x4a4>
  93b88e:	47 ce ff 
  93b891:	8b 84 24 68 02 00 00 	mov    eax,DWORD PTR [rsp+0x268]
  93b898:	4c 8b 8c 24 60 02 00 	mov    r9,QWORD PTR [rsp+0x260]
  93b89f:	00 
  93b8a0:	4c 8b 84 24 70 02 00 	mov    r8,QWORD PTR [rsp+0x270]
  93b8a7:	00 
  93b8a8:	8b bc 24 98 02 00 00 	mov    edi,DWORD PTR [rsp+0x298]
  93b8af:	8b b4 24 d8 02 00 00 	mov    esi,DWORD PTR [rsp+0x2d8]
  93b8b6:	44 8b a4 24 a8 02 00 	mov    r12d,DWORD PTR [rsp+0x2a8]
  93b8bd:	00 
  93b8be:	44 8b ac 24 b8 02 00 	mov    r13d,DWORD PTR [rsp+0x2b8]
  93b8c5:	00 
  93b8c6:	8b ac 24 c8 02 00 00 	mov    ebp,DWORD PTR [rsp+0x2c8]
  93b8cd:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  93b8d1:	89 54 24 50          	mov    DWORD PTR [rsp+0x50],edx
  93b8d5:	89 4c 24 2c          	mov    DWORD PTR [rsp+0x2c],ecx
  93b8d9:	48 8b 94 24 80 02 00 	mov    rdx,QWORD PTR [rsp+0x280]
  93b8e0:	00 
  93b8e1:	48 8b 8c 24 90 02 00 	mov    rcx,QWORD PTR [rsp+0x290]
  93b8e8:	00 
  93b8e9:	89 84 24 88 00 00 00 	mov    DWORD PTR [rsp+0x88],eax
  93b8f0:	4c 89 8c 24 78 01 00 	mov    QWORD PTR [rsp+0x178],r9
  93b8f7:	00 
  93b8f8:	4c 89 84 24 70 01 00 	mov    QWORD PTR [rsp+0x170],r8
  93b8ff:	00 
  93b900:	89 7c 24 48          	mov    DWORD PTR [rsp+0x48],edi
  93b904:	89 74 24 5c          	mov    DWORD PTR [rsp+0x5c],esi
  93b908:	48 89 94 24 68 01 00 	mov    QWORD PTR [rsp+0x168],rdx
  93b90f:	00 
  93b910:	48 89 8c 24 60 01 00 	mov    QWORD PTR [rsp+0x160],rcx
  93b917:	00 
  93b918:	48 8b 94 24 a0 02 00 	mov    rdx,QWORD PTR [rsp+0x2a0]
  93b91f:	00 
  93b920:	48 8b 8c 24 b0 02 00 	mov    rcx,QWORD PTR [rsp+0x2b0]
  93b927:	00 
  93b928:	48 89 94 24 58 01 00 	mov    QWORD PTR [rsp+0x158],rdx
  93b92f:	00 
  93b930:	48 89 8c 24 50 01 00 	mov    QWORD PTR [rsp+0x150],rcx
  93b937:	00 
  93b938:	48 8b 94 24 c0 02 00 	mov    rdx,QWORD PTR [rsp+0x2c0]
  93b93f:	00 
  93b940:	48 8b 8c 24 d0 02 00 	mov    rcx,QWORD PTR [rsp+0x2d0]
  93b947:	00 
  93b948:	48 89 94 24 48 01 00 	mov    QWORD PTR [rsp+0x148],rdx
  93b94f:	00 
  93b950:	48 89 8c 24 40 01 00 	mov    QWORD PTR [rsp+0x140],rcx
  93b957:	00 
  93b958:	48 8b 94 24 e0 02 00 	mov    rdx,QWORD PTR [rsp+0x2e0]
  93b95f:	00 
  93b960:	48 8b 8c 24 e8 02 00 	mov    rcx,QWORD PTR [rsp+0x2e8]
  93b967:	00 
  93b968:	48 89 54 24 40       	mov    QWORD PTR [rsp+0x40],rdx
  93b96d:	48 89 8c 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],rcx
  93b974:	00 
  93b975:	48 8b 94 24 f0 02 00 	mov    rdx,QWORD PTR [rsp+0x2f0]
  93b97c:	00 
  93b97d:	48 8b 8c 24 f8 02 00 	mov    rcx,QWORD PTR [rsp+0x2f8]
  93b984:	00 
  93b985:	48 89 94 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],rdx
  93b98c:	00 
  93b98d:	48 89 8c 24 d8 00 00 	mov    QWORD PTR [rsp+0xd8],rcx
  93b994:	00 
  93b995:	48 8b 94 24 00 03 00 	mov    rdx,QWORD PTR [rsp+0x300]
  93b99c:	00 
  93b99d:	48 8b 8c 24 08 03 00 	mov    rcx,QWORD PTR [rsp+0x308]
  93b9a4:	00 
  93b9a5:	48 89 94 24 d0 00 00 	mov    QWORD PTR [rsp+0xd0],rdx
  93b9ac:	00 
  93b9ad:	48 89 8c 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rcx
  93b9b4:	00 
  93b9b5:	48 8b 94 24 10 03 00 	mov    rdx,QWORD PTR [rsp+0x310]
  93b9bc:	00 
  93b9bd:	48 8b 8c 24 18 03 00 	mov    rcx,QWORD PTR [rsp+0x318]
  93b9c4:	00 
  93b9c5:	48 89 94 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rdx
  93b9cc:	00 
  93b9cd:	48 89 8c 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rcx
  93b9d4:	00 
  93b9d5:	e9 81 00 00 00       	jmp    93ba5b <check_input_intrinsic_initialize+0x6db>
  93b9da:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  93b9e0:	44 39 f5             	cmp    ebp,r14d
  93b9e3:	48 8b 8c 24 c0 00 00 	mov    rcx,QWORD PTR [rsp+0xc0]
  93b9ea:	00 
  93b9eb:	0f 97 c0             	seta   al
  93b9ee:	1c 00                	sbb    al,0x0
  93b9f0:	44 39 f5             	cmp    ebp,r14d
  93b9f3:	0f be c0             	movsx  eax,al
  93b9f6:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93b9fc:	c4 e3 75 02 c8 40    	vpblendd ymm1,ymm1,ymm0,0x40
  93ba02:	49 0f 44 cf          	cmove  rcx,r15
  93ba06:	48 89 8c 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rcx
  93ba0d:	00 
  93ba0e:	84 db                	test   bl,bl
  93ba10:	0f 88 4a 01 00 00    	js     93bb60 <check_input_intrinsic_initialize+0x7e0>
  93ba16:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  93ba1a:	62 f1 75 2a 66 c8    	vpcmpgtd k1{k2},ymm1,ymm0
  93ba20:	62 f1 7d aa 72 e1 1f 	vpsrad ymm0{k2}{z},ymm1,0x1f
  93ba27:	c5 f5 76 c9          	vpcmpeqd ymm1,ymm1,ymm1
  93ba2b:	62 f1 65 29 fa d1    	vpsubd ymm2{k1},ymm3,ymm1
  93ba31:	c5 fe 6f 8c 24 a0 01 	vmovdqu ymm1,YMMWORD PTR [rsp+0x1a0]
  93ba38:	00 00 
  93ba3a:	c4 e3 6d 4c c3 00    	vpblendvb ymm0,ymm2,ymm3,ymm0
  93ba40:	62 f1 7d 29 6f c1    	vmovdqa32 ymm0{k1},ymm1
  93ba46:	c5 fd 66 ca          	vpcmpgtd ymm1,ymm0,ymm2
  93ba4a:	62 f1 7d 28 66 d2    	vpcmpgtd k2,ymm0,ymm2
  93ba50:	c4 e2 7d 0e c9       	vtestps ymm1,ymm1
  93ba55:	0f 84 9c 06 00 00    	je     93c0f7 <check_input_intrinsic_initialize+0xd77>
  93ba5b:	c5 fe 7f 84 24 a0 01 	vmovdqu YMMWORD PTR [rsp+0x1a0],ymm0
  93ba62:	00 00 
  93ba64:	c5 fd fa c2          	vpsubd ymm0,ymm0,ymm2
  93ba68:	c5 f9 93 da          	kmovb  ebx,k2
  93ba6c:	c5 f8 91 54 24 10    	kmovw  WORD PTR [rsp+0x10],k2
  93ba72:	c5 fe 7f 94 24 90 00 	vmovdqu YMMWORD PTR [rsp+0x90],ymm2
  93ba79:	00 00 
  93ba7b:	c5 fd 72 d0 01       	vpsrld ymm0,ymm0,0x1
  93ba80:	c5 fd fe da          	vpaddd ymm3,ymm0,ymm2
  93ba84:	c5 fe 7f 9c 24 10 01 	vmovdqu YMMWORD PTR [rsp+0x110],ymm3
  93ba8b:	00 00 
  93ba8d:	f6 c3 01             	test   bl,0x1
  93ba90:	75 4e                	jne    93bae0 <check_input_intrinsic_initialize+0x760>
  93ba92:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  93ba96:	f6 c3 02             	test   bl,0x2
  93ba99:	0f 85 81 01 00 00    	jne    93bc20 <check_input_intrinsic_initialize+0x8a0>
  93ba9f:	f6 c3 04             	test   bl,0x4
  93baa2:	0f 85 43 02 00 00    	jne    93bceb <check_input_intrinsic_initialize+0x96b>
  93baa8:	f6 c3 08             	test   bl,0x8
  93baab:	0f 85 fa 02 00 00    	jne    93bdab <check_input_intrinsic_initialize+0xa2b>
  93bab1:	c4 e3 7d 39 dc 01    	vextracti128 xmm4,ymm3,0x1
  93bab7:	c5 f9 7f a4 24 80 01 	vmovdqa XMMWORD PTR [rsp+0x180],xmm4
  93babe:	00 00 
  93bac0:	f6 c3 10             	test   bl,0x10
  93bac3:	0f 85 c1 03 00 00    	jne    93be8a <check_input_intrinsic_initialize+0xb0a>
  93bac9:	f6 c3 20             	test   bl,0x20
  93bacc:	0f 85 85 04 00 00    	jne    93bf57 <check_input_intrinsic_initialize+0xbd7>
  93bad2:	f6 c3 40             	test   bl,0x40
  93bad5:	0f 84 33 ff ff ff    	je     93ba0e <check_input_intrinsic_initialize+0x68e>
  93badb:	e9 47 05 00 00       	jmp    93c027 <check_input_intrinsic_initialize+0xca7>
  93bae0:	c5 f9 7e d8          	vmovd  eax,xmm3
  93bae4:	48 8d 0d 95 a0 89 01 	lea    rcx,[rip+0x189a095]        # 21d5b80 <builtin_intrinsic_infos>
  93baeb:	8b 94 24 88 00 00 00 	mov    edx,DWORD PTR [rsp+0x88]
  93baf2:	48 98                	cdqe
  93baf4:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93baf8:	48 c1 e0 05          	shl    rax,0x5
  93bafc:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93bb01:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  93bb05:	44 39 f2             	cmp    edx,r14d
  93bb08:	44 89 f0             	mov    eax,r14d
  93bb0b:	0f 42 c2             	cmovb  eax,edx
  93bb0e:	85 c0                	test   eax,eax
  93bb10:	0f 84 da 00 00 00    	je     93bbf0 <check_input_intrinsic_initialize+0x870>
  93bb16:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  93bb19:	48 8b bc 24 78 01 00 	mov    rdi,QWORD PTR [rsp+0x178]
  93bb20:	00 
  93bb21:	89 c2                	mov    edx,eax
  93bb23:	c5 f8 77             	vzeroupper
  93bb26:	e8 d5 ab fc ff       	call   906700 <memcmp@plt>
  93bb2b:	c5 fe 6f 9c 24 10 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x110]
  93bb32:	00 00 
  93bb34:	c5 fe 6f 94 24 90 00 	vmovdqu ymm2,YMMWORD PTR [rsp+0x90]
  93bb3b:	00 00 
  93bb3d:	c5 f8 90 54 24 10    	kmovw  k2,WORD PTR [rsp+0x10]
  93bb43:	85 c0                	test   eax,eax
  93bb45:	0f 84 a5 00 00 00    	je     93bbf0 <check_input_intrinsic_initialize+0x870>
  93bb4b:	c5 f9 6e c8          	vmovd  xmm1,eax
  93bb4f:	f6 c3 02             	test   bl,0x2
  93bb52:	0f 85 c8 00 00 00    	jne    93bc20 <check_input_intrinsic_initialize+0x8a0>
  93bb58:	e9 42 ff ff ff       	jmp    93ba9f <check_input_intrinsic_initialize+0x71f>
  93bb5d:	0f 1f 00             	nop    DWORD PTR [rax]
  93bb60:	c4 e3 79 16 e0 03    	vpextrd eax,xmm4,0x3
  93bb66:	48 8d 0d 13 a0 89 01 	lea    rcx,[rip+0x189a013]        # 21d5b80 <builtin_intrinsic_infos>
  93bb6d:	8b 54 24 5c          	mov    edx,DWORD PTR [rsp+0x5c]
  93bb71:	48 98                	cdqe
  93bb73:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93bb77:	48 c1 e0 05          	shl    rax,0x5
  93bb7b:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93bb80:	48 8d 1c 01          	lea    rbx,[rcx+rax*1]
  93bb84:	44 39 f2             	cmp    edx,r14d
  93bb87:	44 89 f0             	mov    eax,r14d
  93bb8a:	0f 42 c2             	cmovb  eax,edx
  93bb8d:	85 c0                	test   eax,eax
  93bb8f:	0f 84 2b 05 00 00    	je     93c0c0 <check_input_intrinsic_initialize+0xd40>
  93bb95:	48 8b 33             	mov    rsi,QWORD PTR [rbx]
  93bb98:	48 8b bc 24 40 01 00 	mov    rdi,QWORD PTR [rsp+0x140]
  93bb9f:	00 
  93bba0:	89 c2                	mov    edx,eax
  93bba2:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  93bba8:	c5 f8 77             	vzeroupper
  93bbab:	e8 50 ab fc ff       	call   906700 <memcmp@plt>
  93bbb0:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  93bbb6:	c5 fe 6f 9c 24 10 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x110]
  93bbbd:	00 00 
  93bbbf:	c5 fe 6f 94 24 90 00 	vmovdqu ymm2,YMMWORD PTR [rsp+0x90]
  93bbc6:	00 00 
  93bbc8:	c5 f8 90 54 24 10    	kmovw  k2,WORD PTR [rsp+0x10]
  93bbce:	85 c0                	test   eax,eax
  93bbd0:	0f 84 ea 04 00 00    	je     93c0c0 <check_input_intrinsic_initialize+0xd40>
  93bbd6:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93bbdc:	c4 e3 75 02 c8 80    	vpblendd ymm1,ymm1,ymm0,0x80
  93bbe2:	e9 2f fe ff ff       	jmp    93ba16 <check_input_intrinsic_initialize+0x696>
  93bbe7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  93bbee:	00 00 
  93bbf0:	8b 8c 24 88 00 00 00 	mov    ecx,DWORD PTR [rsp+0x88]
  93bbf7:	44 39 f1             	cmp    ecx,r14d
  93bbfa:	0f 97 c0             	seta   al
  93bbfd:	1c 00                	sbb    al,0x0
  93bbff:	44 39 f1             	cmp    ecx,r14d
  93bc02:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
  93bc07:	0f be c0             	movsx  eax,al
  93bc0a:	c5 f9 6e c8          	vmovd  xmm1,eax
  93bc0e:	49 0f 44 cf          	cmove  rcx,r15
  93bc12:	48 89 4c 24 40       	mov    QWORD PTR [rsp+0x40],rcx
  93bc17:	f6 c3 02             	test   bl,0x2
  93bc1a:	0f 84 7f fe ff ff    	je     93ba9f <check_input_intrinsic_initialize+0x71f>
  93bc20:	c4 e3 79 16 d8 01    	vpextrd eax,xmm3,0x1
  93bc26:	48 8d 0d 53 9f 89 01 	lea    rcx,[rip+0x1899f53]        # 21d5b80 <builtin_intrinsic_infos>
  93bc2d:	8b 54 24 50          	mov    edx,DWORD PTR [rsp+0x50]
  93bc31:	48 98                	cdqe
  93bc33:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93bc37:	48 c1 e0 05          	shl    rax,0x5
  93bc3b:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93bc40:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  93bc44:	44 39 f2             	cmp    edx,r14d
  93bc47:	44 89 f0             	mov    eax,r14d
  93bc4a:	0f 42 c2             	cmovb  eax,edx
  93bc4d:	85 c0                	test   eax,eax
  93bc4f:	74 5f                	je     93bcb0 <check_input_intrinsic_initialize+0x930>
  93bc51:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  93bc54:	48 8b bc 24 70 01 00 	mov    rdi,QWORD PTR [rsp+0x170]
  93bc5b:	00 
  93bc5c:	89 c2                	mov    edx,eax
  93bc5e:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  93bc64:	c5 f8 77             	vzeroupper
  93bc67:	e8 94 aa fc ff       	call   906700 <memcmp@plt>
  93bc6c:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  93bc72:	c5 fe 6f 9c 24 10 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x110]
  93bc79:	00 00 
  93bc7b:	c5 fe 6f 94 24 90 00 	vmovdqu ymm2,YMMWORD PTR [rsp+0x90]
  93bc82:	00 00 
  93bc84:	c5 f8 90 54 24 10    	kmovw  k2,WORD PTR [rsp+0x10]
  93bc8a:	85 c0                	test   eax,eax
  93bc8c:	74 22                	je     93bcb0 <check_input_intrinsic_initialize+0x930>
  93bc8e:	c4 e3 71 22 c0 01    	vpinsrd xmm0,xmm1,eax,0x1
  93bc94:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93bc9a:	f6 c3 04             	test   bl,0x4
  93bc9d:	75 4c                	jne    93bceb <check_input_intrinsic_initialize+0x96b>
  93bc9f:	e9 04 fe ff ff       	jmp    93baa8 <check_input_intrinsic_initialize+0x728>
  93bca4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93bcab:	00 00 00 00 00 
  93bcb0:	8b 4c 24 50          	mov    ecx,DWORD PTR [rsp+0x50]
  93bcb4:	44 39 f1             	cmp    ecx,r14d
  93bcb7:	0f 97 c0             	seta   al
  93bcba:	1c 00                	sbb    al,0x0
  93bcbc:	44 39 f1             	cmp    ecx,r14d
  93bcbf:	48 8b 8c 24 e8 00 00 	mov    rcx,QWORD PTR [rsp+0xe8]
  93bcc6:	00 
  93bcc7:	0f be c0             	movsx  eax,al
  93bcca:	c4 e3 71 22 c0 01    	vpinsrd xmm0,xmm1,eax,0x1
  93bcd0:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93bcd6:	49 0f 44 cf          	cmove  rcx,r15
  93bcda:	48 89 8c 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],rcx
  93bce1:	00 
  93bce2:	f6 c3 04             	test   bl,0x4
  93bce5:	0f 84 bd fd ff ff    	je     93baa8 <check_input_intrinsic_initialize+0x728>
  93bceb:	c4 e3 79 16 d8 02    	vpextrd eax,xmm3,0x2
  93bcf1:	48 8d 0d 88 9e 89 01 	lea    rcx,[rip+0x1899e88]        # 21d5b80 <builtin_intrinsic_infos>
  93bcf8:	8b 54 24 2c          	mov    edx,DWORD PTR [rsp+0x2c]
  93bcfc:	48 98                	cdqe
  93bcfe:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93bd02:	48 c1 e0 05          	shl    rax,0x5
  93bd06:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93bd0b:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  93bd0f:	44 39 f2             	cmp    edx,r14d
  93bd12:	44 89 f0             	mov    eax,r14d
  93bd15:	0f 42 c2             	cmovb  eax,edx
  93bd18:	85 c0                	test   eax,eax
  93bd1a:	74 54                	je     93bd70 <check_input_intrinsic_initialize+0x9f0>
  93bd1c:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  93bd1f:	48 8b bc 24 68 01 00 	mov    rdi,QWORD PTR [rsp+0x168]
  93bd26:	00 
  93bd27:	89 c2                	mov    edx,eax
  93bd29:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  93bd2f:	c5 f8 77             	vzeroupper
  93bd32:	e8 c9 a9 fc ff       	call   906700 <memcmp@plt>
  93bd37:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  93bd3d:	c5 fe 6f 9c 24 10 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x110]
  93bd44:	00 00 
  93bd46:	c5 fe 6f 94 24 90 00 	vmovdqu ymm2,YMMWORD PTR [rsp+0x90]
  93bd4d:	00 00 
  93bd4f:	c5 f8 90 54 24 10    	kmovw  k2,WORD PTR [rsp+0x10]
  93bd55:	85 c0                	test   eax,eax
  93bd57:	74 17                	je     93bd70 <check_input_intrinsic_initialize+0x9f0>
  93bd59:	c4 e3 71 22 c0 02    	vpinsrd xmm0,xmm1,eax,0x2
  93bd5f:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93bd65:	f6 c3 08             	test   bl,0x8
  93bd68:	0f 84 43 fd ff ff    	je     93bab1 <check_input_intrinsic_initialize+0x731>
  93bd6e:	eb 3b                	jmp    93bdab <check_input_intrinsic_initialize+0xa2b>
  93bd70:	8b 4c 24 2c          	mov    ecx,DWORD PTR [rsp+0x2c]
  93bd74:	44 39 f1             	cmp    ecx,r14d
  93bd77:	0f 97 c0             	seta   al
  93bd7a:	1c 00                	sbb    al,0x0
  93bd7c:	44 39 f1             	cmp    ecx,r14d
  93bd7f:	48 8b 8c 24 e0 00 00 	mov    rcx,QWORD PTR [rsp+0xe0]
  93bd86:	00 
  93bd87:	0f be c0             	movsx  eax,al
  93bd8a:	c4 e3 71 22 c0 02    	vpinsrd xmm0,xmm1,eax,0x2
  93bd90:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93bd96:	49 0f 44 cf          	cmove  rcx,r15
  93bd9a:	48 89 8c 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],rcx
  93bda1:	00 
  93bda2:	f6 c3 08             	test   bl,0x8
  93bda5:	0f 84 06 fd ff ff    	je     93bab1 <check_input_intrinsic_initialize+0x731>
  93bdab:	c4 e3 79 16 d8 03    	vpextrd eax,xmm3,0x3
  93bdb1:	48 8d 0d c8 9d 89 01 	lea    rcx,[rip+0x1899dc8]        # 21d5b80 <builtin_intrinsic_infos>
  93bdb8:	8b 54 24 48          	mov    edx,DWORD PTR [rsp+0x48]
  93bdbc:	48 98                	cdqe
  93bdbe:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93bdc2:	48 c1 e0 05          	shl    rax,0x5
  93bdc6:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93bdcb:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  93bdcf:	44 39 f2             	cmp    edx,r14d
  93bdd2:	44 89 f0             	mov    eax,r14d
  93bdd5:	0f 42 c2             	cmovb  eax,edx
  93bdd8:	85 c0                	test   eax,eax
  93bdda:	74 64                	je     93be40 <check_input_intrinsic_initialize+0xac0>
  93bddc:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  93bddf:	48 8b bc 24 60 01 00 	mov    rdi,QWORD PTR [rsp+0x160]
  93bde6:	00 
  93bde7:	89 c2                	mov    edx,eax
  93bde9:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  93bdef:	c5 f8 77             	vzeroupper
  93bdf2:	e8 09 a9 fc ff       	call   906700 <memcmp@plt>
  93bdf7:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  93bdfd:	c5 fe 6f 9c 24 10 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x110]
  93be04:	00 00 
  93be06:	c5 fe 6f 94 24 90 00 	vmovdqu ymm2,YMMWORD PTR [rsp+0x90]
  93be0d:	00 00 
  93be0f:	c5 f8 90 54 24 10    	kmovw  k2,WORD PTR [rsp+0x10]
  93be15:	85 c0                	test   eax,eax
  93be17:	74 27                	je     93be40 <check_input_intrinsic_initialize+0xac0>
  93be19:	c4 e3 71 22 c0 03    	vpinsrd xmm0,xmm1,eax,0x3
  93be1f:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93be25:	c4 e3 7d 39 dc 01    	vextracti128 xmm4,ymm3,0x1
  93be2b:	c5 f9 7f a4 24 80 01 	vmovdqa XMMWORD PTR [rsp+0x180],xmm4
  93be32:	00 00 
  93be34:	f6 c3 10             	test   bl,0x10
  93be37:	0f 84 8c fc ff ff    	je     93bac9 <check_input_intrinsic_initialize+0x749>
  93be3d:	eb 4b                	jmp    93be8a <check_input_intrinsic_initialize+0xb0a>
  93be3f:	90                   	nop
  93be40:	8b 4c 24 48          	mov    ecx,DWORD PTR [rsp+0x48]
  93be44:	44 39 f1             	cmp    ecx,r14d
  93be47:	0f 97 c0             	seta   al
  93be4a:	1c 00                	sbb    al,0x0
  93be4c:	44 39 f1             	cmp    ecx,r14d
  93be4f:	48 8b 8c 24 d8 00 00 	mov    rcx,QWORD PTR [rsp+0xd8]
  93be56:	00 
  93be57:	0f be c0             	movsx  eax,al
  93be5a:	c4 e3 71 22 c0 03    	vpinsrd xmm0,xmm1,eax,0x3
  93be60:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93be66:	49 0f 44 cf          	cmove  rcx,r15
  93be6a:	48 89 8c 24 d8 00 00 	mov    QWORD PTR [rsp+0xd8],rcx
  93be71:	00 
  93be72:	c4 e3 7d 39 dc 01    	vextracti128 xmm4,ymm3,0x1
  93be78:	c5 f9 7f a4 24 80 01 	vmovdqa XMMWORD PTR [rsp+0x180],xmm4
  93be7f:	00 00 
  93be81:	f6 c3 10             	test   bl,0x10
  93be84:	0f 84 3f fc ff ff    	je     93bac9 <check_input_intrinsic_initialize+0x749>
  93be8a:	c5 f9 7e e0          	vmovd  eax,xmm4
  93be8e:	48 8d 0d eb 9c 89 01 	lea    rcx,[rip+0x1899ceb]        # 21d5b80 <builtin_intrinsic_infos>
  93be95:	48 98                	cdqe
  93be97:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93be9b:	48 c1 e0 05          	shl    rax,0x5
  93be9f:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93bea4:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  93bea8:	45 39 f4             	cmp    r12d,r14d
  93beab:	44 89 f0             	mov    eax,r14d
  93beae:	41 0f 42 c4          	cmovb  eax,r12d
  93beb2:	85 c0                	test   eax,eax
  93beb4:	74 6a                	je     93bf20 <check_input_intrinsic_initialize+0xba0>
  93beb6:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  93beb9:	48 8b bc 24 58 01 00 	mov    rdi,QWORD PTR [rsp+0x158]
  93bec0:	00 
  93bec1:	89 c2                	mov    edx,eax
  93bec3:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  93bec9:	c5 f8 77             	vzeroupper
  93becc:	e8 2f a8 fc ff       	call   906700 <memcmp@plt>
  93bed1:	c5 f9 6f a4 24 80 01 	vmovdqa xmm4,XMMWORD PTR [rsp+0x180]
  93bed8:	00 00 
  93beda:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  93bee0:	c5 fe 6f 9c 24 10 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x110]
  93bee7:	00 00 
  93bee9:	c5 fe 6f 94 24 90 00 	vmovdqu ymm2,YMMWORD PTR [rsp+0x90]
  93bef0:	00 00 
  93bef2:	c5 f8 90 54 24 10    	kmovw  k2,WORD PTR [rsp+0x10]
  93bef8:	85 c0                	test   eax,eax
  93befa:	74 24                	je     93bf20 <check_input_intrinsic_initialize+0xba0>
  93befc:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93bf02:	c4 e3 75 02 c8 10    	vpblendd ymm1,ymm1,ymm0,0x10
  93bf08:	f6 c3 20             	test   bl,0x20
  93bf0b:	0f 84 c1 fb ff ff    	je     93bad2 <check_input_intrinsic_initialize+0x752>
  93bf11:	eb 44                	jmp    93bf57 <check_input_intrinsic_initialize+0xbd7>
  93bf13:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93bf1a:	84 00 00 00 00 00 
  93bf20:	45 39 f4             	cmp    r12d,r14d
  93bf23:	48 8b 8c 24 d0 00 00 	mov    rcx,QWORD PTR [rsp+0xd0]
  93bf2a:	00 
  93bf2b:	0f 97 c0             	seta   al
  93bf2e:	1c 00                	sbb    al,0x0
  93bf30:	45 39 f4             	cmp    r12d,r14d
  93bf33:	0f be c0             	movsx  eax,al
  93bf36:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93bf3c:	c4 e3 75 02 c8 10    	vpblendd ymm1,ymm1,ymm0,0x10
  93bf42:	49 0f 44 cf          	cmove  rcx,r15
  93bf46:	48 89 8c 24 d0 00 00 	mov    QWORD PTR [rsp+0xd0],rcx
  93bf4d:	00 
  93bf4e:	f6 c3 20             	test   bl,0x20
  93bf51:	0f 84 7b fb ff ff    	je     93bad2 <check_input_intrinsic_initialize+0x752>
  93bf57:	c4 e3 79 16 e0 01    	vpextrd eax,xmm4,0x1
  93bf5d:	48 8d 0d 1c 9c 89 01 	lea    rcx,[rip+0x1899c1c]        # 21d5b80 <builtin_intrinsic_infos>
  93bf64:	48 98                	cdqe
  93bf66:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93bf6a:	48 c1 e0 05          	shl    rax,0x5
  93bf6e:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93bf73:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  93bf77:	45 39 f5             	cmp    r13d,r14d
  93bf7a:	44 89 f0             	mov    eax,r14d
  93bf7d:	41 0f 42 c5          	cmovb  eax,r13d
  93bf81:	85 c0                	test   eax,eax
  93bf83:	74 6b                	je     93bff0 <check_input_intrinsic_initialize+0xc70>
  93bf85:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  93bf88:	48 8b bc 24 50 01 00 	mov    rdi,QWORD PTR [rsp+0x150]
  93bf8f:	00 
  93bf90:	89 c2                	mov    edx,eax
  93bf92:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  93bf98:	c5 f8 77             	vzeroupper
  93bf9b:	e8 60 a7 fc ff       	call   906700 <memcmp@plt>
  93bfa0:	c5 f9 6f a4 24 80 01 	vmovdqa xmm4,XMMWORD PTR [rsp+0x180]
  93bfa7:	00 00 
  93bfa9:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  93bfaf:	c5 fe 6f 9c 24 10 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x110]
  93bfb6:	00 00 
  93bfb8:	c5 fe 6f 94 24 90 00 	vmovdqu ymm2,YMMWORD PTR [rsp+0x90]
  93bfbf:	00 00 
  93bfc1:	c5 f8 90 54 24 10    	kmovw  k2,WORD PTR [rsp+0x10]
  93bfc7:	85 c0                	test   eax,eax
  93bfc9:	74 25                	je     93bff0 <check_input_intrinsic_initialize+0xc70>
  93bfcb:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93bfd1:	c4 e3 75 02 c8 20    	vpblendd ymm1,ymm1,ymm0,0x20
  93bfd7:	f6 c3 40             	test   bl,0x40
  93bfda:	0f 84 2e fa ff ff    	je     93ba0e <check_input_intrinsic_initialize+0x68e>
  93bfe0:	eb 45                	jmp    93c027 <check_input_intrinsic_initialize+0xca7>
  93bfe2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93bfe9:	1f 84 00 00 00 00 00 
  93bff0:	45 39 f5             	cmp    r13d,r14d
  93bff3:	48 8b 8c 24 c8 00 00 	mov    rcx,QWORD PTR [rsp+0xc8]
  93bffa:	00 
  93bffb:	0f 97 c0             	seta   al
  93bffe:	1c 00                	sbb    al,0x0
  93c000:	45 39 f5             	cmp    r13d,r14d
  93c003:	0f be c0             	movsx  eax,al
  93c006:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93c00c:	c4 e3 75 02 c8 20    	vpblendd ymm1,ymm1,ymm0,0x20
  93c012:	49 0f 44 cf          	cmove  rcx,r15
  93c016:	48 89 8c 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rcx
  93c01d:	00 
  93c01e:	f6 c3 40             	test   bl,0x40
  93c021:	0f 84 e7 f9 ff ff    	je     93ba0e <check_input_intrinsic_initialize+0x68e>
  93c027:	c4 e3 79 16 e0 02    	vpextrd eax,xmm4,0x2
  93c02d:	48 8d 0d 4c 9b 89 01 	lea    rcx,[rip+0x1899b4c]        # 21d5b80 <builtin_intrinsic_infos>
  93c034:	48 98                	cdqe
  93c036:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93c03a:	48 c1 e0 05          	shl    rax,0x5
  93c03e:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93c043:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  93c047:	44 39 f5             	cmp    ebp,r14d
  93c04a:	44 89 f0             	mov    eax,r14d
  93c04d:	0f 42 c5             	cmovb  eax,ebp
  93c050:	85 c0                	test   eax,eax
  93c052:	0f 84 88 f9 ff ff    	je     93b9e0 <check_input_intrinsic_initialize+0x660>
  93c058:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  93c05b:	48 8b bc 24 48 01 00 	mov    rdi,QWORD PTR [rsp+0x148]
  93c062:	00 
  93c063:	89 c2                	mov    edx,eax
  93c065:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  93c06b:	c5 f8 77             	vzeroupper
  93c06e:	e8 8d a6 fc ff       	call   906700 <memcmp@plt>
  93c073:	c5 f9 6f a4 24 80 01 	vmovdqa xmm4,XMMWORD PTR [rsp+0x180]
  93c07a:	00 00 
  93c07c:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  93c082:	c5 fe 6f 9c 24 10 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x110]
  93c089:	00 00 
  93c08b:	c5 fe 6f 94 24 90 00 	vmovdqu ymm2,YMMWORD PTR [rsp+0x90]
  93c092:	00 00 
  93c094:	c5 f8 90 54 24 10    	kmovw  k2,WORD PTR [rsp+0x10]
  93c09a:	85 c0                	test   eax,eax
  93c09c:	0f 84 3e f9 ff ff    	je     93b9e0 <check_input_intrinsic_initialize+0x660>
  93c0a2:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93c0a8:	c4 e3 75 02 c8 40    	vpblendd ymm1,ymm1,ymm0,0x40
  93c0ae:	e9 5b f9 ff ff       	jmp    93ba0e <check_input_intrinsic_initialize+0x68e>
  93c0b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93c0ba:	84 00 00 00 00 00 
  93c0c0:	8b 4c 24 5c          	mov    ecx,DWORD PTR [rsp+0x5c]
  93c0c4:	44 39 f1             	cmp    ecx,r14d
  93c0c7:	0f 97 c0             	seta   al
  93c0ca:	1c 00                	sbb    al,0x0
  93c0cc:	44 39 f1             	cmp    ecx,r14d
  93c0cf:	48 8b 8c 24 b8 00 00 	mov    rcx,QWORD PTR [rsp+0xb8]
  93c0d6:	00 
  93c0d7:	0f be c0             	movsx  eax,al
  93c0da:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93c0e0:	c4 e3 75 02 c8 80    	vpblendd ymm1,ymm1,ymm0,0x80
  93c0e6:	48 0f 44 cb          	cmove  rcx,rbx
  93c0ea:	48 89 8c 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rcx
  93c0f1:	00 
  93c0f2:	e9 1f f9 ff ff       	jmp    93ba16 <check_input_intrinsic_initialize+0x696>
  93c0f7:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  93c0fc:	48 8b 8c 24 e8 00 00 	mov    rcx,QWORD PTR [rsp+0xe8]
  93c103:	00 
  93c104:	48 8b 94 24 e0 00 00 	mov    rdx,QWORD PTR [rsp+0xe0]
  93c10b:	00 
  93c10c:	62 f2 7d 48 5a 05 aa 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc90aa]        # 6051c0 <abi_test_hex.digits+0x370>
  93c113:	90 cc ff 
  93c116:	48 89 84 24 e0 02 00 	mov    QWORD PTR [rsp+0x2e0],rax
  93c11d:	00 
  93c11e:	48 89 8c 24 e8 02 00 	mov    QWORD PTR [rsp+0x2e8],rcx
  93c125:	00 
  93c126:	48 8b 8c 24 d8 00 00 	mov    rcx,QWORD PTR [rsp+0xd8]
  93c12d:	00 
  93c12e:	48 89 94 24 f0 02 00 	mov    QWORD PTR [rsp+0x2f0],rdx
  93c135:	00 
  93c136:	48 8b 94 24 d0 00 00 	mov    rdx,QWORD PTR [rsp+0xd0]
  93c13d:	00 
  93c13e:	48 89 8c 24 f8 02 00 	mov    QWORD PTR [rsp+0x2f8],rcx
  93c145:	00 
  93c146:	48 8b 8c 24 c8 00 00 	mov    rcx,QWORD PTR [rsp+0xc8]
  93c14d:	00 
  93c14e:	48 89 94 24 00 03 00 	mov    QWORD PTR [rsp+0x300],rdx
  93c155:	00 
  93c156:	48 8b 94 24 c0 00 00 	mov    rdx,QWORD PTR [rsp+0xc0]
  93c15d:	00 
  93c15e:	48 89 8c 24 08 03 00 	mov    QWORD PTR [rsp+0x308],rcx
  93c165:	00 
  93c166:	48 8b 8c 24 b8 00 00 	mov    rcx,QWORD PTR [rsp+0xb8]
  93c16d:	00 
  93c16e:	48 89 94 24 10 03 00 	mov    QWORD PTR [rsp+0x310],rdx
  93c175:	00 
  93c176:	48 89 8c 24 18 03 00 	mov    QWORD PTR [rsp+0x318],rcx
  93c17d:	00 
  93c17e:	4c 8b 44 24 30       	mov    r8,QWORD PTR [rsp+0x30]
  93c183:	4d 85 c0             	test   r8,r8
  93c186:	0f 84 ba 01 00 00    	je     93c346 <check_input_intrinsic_initialize+0xfc6>
  93c18c:	48 8b 84 24 e0 02 00 	mov    rax,QWORD PTR [rsp+0x2e0]
  93c193:	00 
  93c194:	4c 8b 54 24 18       	mov    r10,QWORD PTR [rsp+0x18]
  93c199:	8b 6c 24 0c          	mov    ebp,DWORD PTR [rsp+0xc]
  93c19d:	4c 8b bc 24 08 01 00 	mov    r15,QWORD PTR [rsp+0x108]
  93c1a4:	00 
  93c1a5:	4c 8b a4 24 00 01 00 	mov    r12,QWORD PTR [rsp+0x100]
  93c1ac:	00 
  93c1ad:	48 85 c0             	test   rax,rax
  93c1b0:	74 26                	je     93c1d8 <check_input_intrinsic_initialize+0xe58>
  93c1b2:	48 8d 0d c7 99 89 01 	lea    rcx,[rip+0x18999c7]        # 21d5b80 <builtin_intrinsic_infos>
  93c1b9:	ff c5                	inc    ebp
  93c1bb:	48 29 c8             	sub    rax,rcx
  93c1be:	8b 8c 24 40 02 00 00 	mov    ecx,DWORD PTR [rsp+0x240]
  93c1c5:	48 c1 e8 05          	shr    rax,0x5
  93c1c9:	69 c0 ab aa aa aa    	imul   eax,eax,0xaaaaaaab
  93c1cf:	0d 00 00 00 80       	or     eax,0x80000000
  93c1d4:	41 89 04 88          	mov    DWORD PTR [r8+rcx*4],eax
  93c1d8:	48 8b 84 24 e8 02 00 	mov    rax,QWORD PTR [rsp+0x2e8]
  93c1df:	00 
  93c1e0:	48 85 c0             	test   rax,rax
  93c1e3:	74 26                	je     93c20b <check_input_intrinsic_initialize+0xe8b>
  93c1e5:	48 8d 0d 94 99 89 01 	lea    rcx,[rip+0x1899994]        # 21d5b80 <builtin_intrinsic_infos>
  93c1ec:	ff c5                	inc    ebp
  93c1ee:	48 29 c8             	sub    rax,rcx
  93c1f1:	8b 8c 24 44 02 00 00 	mov    ecx,DWORD PTR [rsp+0x244]
  93c1f8:	48 c1 e8 05          	shr    rax,0x5
  93c1fc:	69 c0 ab aa aa aa    	imul   eax,eax,0xaaaaaaab
  93c202:	0d 00 00 00 80       	or     eax,0x80000000
  93c207:	41 89 04 88          	mov    DWORD PTR [r8+rcx*4],eax
  93c20b:	48 8b 84 24 f0 02 00 	mov    rax,QWORD PTR [rsp+0x2f0]
  93c212:	00 
  93c213:	48 85 c0             	test   rax,rax
  93c216:	74 26                	je     93c23e <check_input_intrinsic_initialize+0xebe>
  93c218:	48 8d 0d 61 99 89 01 	lea    rcx,[rip+0x1899961]        # 21d5b80 <builtin_intrinsic_infos>
  93c21f:	ff c5                	inc    ebp
  93c221:	48 29 c8             	sub    rax,rcx
  93c224:	8b 8c 24 48 02 00 00 	mov    ecx,DWORD PTR [rsp+0x248]
  93c22b:	48 c1 e8 05          	shr    rax,0x5
  93c22f:	69 c0 ab aa aa aa    	imul   eax,eax,0xaaaaaaab
  93c235:	0d 00 00 00 80       	or     eax,0x80000000
  93c23a:	41 89 04 88          	mov    DWORD PTR [r8+rcx*4],eax
  93c23e:	48 8b 84 24 f8 02 00 	mov    rax,QWORD PTR [rsp+0x2f8]
  93c245:	00 
  93c246:	48 85 c0             	test   rax,rax
  93c249:	74 26                	je     93c271 <check_input_intrinsic_initialize+0xef1>
  93c24b:	48 8d 0d 2e 99 89 01 	lea    rcx,[rip+0x189992e]        # 21d5b80 <builtin_intrinsic_infos>
  93c252:	ff c5                	inc    ebp
  93c254:	48 29 c8             	sub    rax,rcx
  93c257:	8b 8c 24 4c 02 00 00 	mov    ecx,DWORD PTR [rsp+0x24c]
  93c25e:	48 c1 e8 05          	shr    rax,0x5
  93c262:	69 c0 ab aa aa aa    	imul   eax,eax,0xaaaaaaab
  93c268:	0d 00 00 00 80       	or     eax,0x80000000
  93c26d:	41 89 04 88          	mov    DWORD PTR [r8+rcx*4],eax
  93c271:	48 8b 84 24 00 03 00 	mov    rax,QWORD PTR [rsp+0x300]
  93c278:	00 
  93c279:	48 85 c0             	test   rax,rax
  93c27c:	74 26                	je     93c2a4 <check_input_intrinsic_initialize+0xf24>
  93c27e:	48 8d 0d fb 98 89 01 	lea    rcx,[rip+0x18998fb]        # 21d5b80 <builtin_intrinsic_infos>
  93c285:	ff c5                	inc    ebp
  93c287:	48 29 c8             	sub    rax,rcx
  93c28a:	8b 8c 24 50 02 00 00 	mov    ecx,DWORD PTR [rsp+0x250]
  93c291:	48 c1 e8 05          	shr    rax,0x5
  93c295:	69 c0 ab aa aa aa    	imul   eax,eax,0xaaaaaaab
  93c29b:	0d 00 00 00 80       	or     eax,0x80000000
  93c2a0:	41 89 04 88          	mov    DWORD PTR [r8+rcx*4],eax
  93c2a4:	48 8b 84 24 08 03 00 	mov    rax,QWORD PTR [rsp+0x308]
  93c2ab:	00 
  93c2ac:	48 85 c0             	test   rax,rax
  93c2af:	74 26                	je     93c2d7 <check_input_intrinsic_initialize+0xf57>
  93c2b1:	48 8d 0d c8 98 89 01 	lea    rcx,[rip+0x18998c8]        # 21d5b80 <builtin_intrinsic_infos>
  93c2b8:	ff c5                	inc    ebp
  93c2ba:	48 29 c8             	sub    rax,rcx
  93c2bd:	8b 8c 24 54 02 00 00 	mov    ecx,DWORD PTR [rsp+0x254]
  93c2c4:	48 c1 e8 05          	shr    rax,0x5
  93c2c8:	69 c0 ab aa aa aa    	imul   eax,eax,0xaaaaaaab
  93c2ce:	0d 00 00 00 80       	or     eax,0x80000000
  93c2d3:	41 89 04 88          	mov    DWORD PTR [r8+rcx*4],eax
  93c2d7:	48 8b 84 24 10 03 00 	mov    rax,QWORD PTR [rsp+0x310]
  93c2de:	00 
  93c2df:	48 85 c0             	test   rax,rax
  93c2e2:	74 26                	je     93c30a <check_input_intrinsic_initialize+0xf8a>
  93c2e4:	48 8d 0d 95 98 89 01 	lea    rcx,[rip+0x1899895]        # 21d5b80 <builtin_intrinsic_infos>
  93c2eb:	ff c5                	inc    ebp
  93c2ed:	48 29 c8             	sub    rax,rcx
  93c2f0:	8b 8c 24 58 02 00 00 	mov    ecx,DWORD PTR [rsp+0x258]
  93c2f7:	48 c1 e8 05          	shr    rax,0x5
  93c2fb:	69 c0 ab aa aa aa    	imul   eax,eax,0xaaaaaaab
  93c301:	0d 00 00 00 80       	or     eax,0x80000000
  93c306:	41 89 04 88          	mov    DWORD PTR [r8+rcx*4],eax
  93c30a:	48 8b 8c 24 18 03 00 	mov    rcx,QWORD PTR [rsp+0x318]
  93c311:	00 
  93c312:	b0 01                	mov    al,0x1
  93c314:	48 85 c9             	test   rcx,rcx
  93c317:	0f 84 a3 00 00 00    	je     93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c31d:	48 8d 15 5c 98 89 01 	lea    rdx,[rip+0x189985c]        # 21d5b80 <builtin_intrinsic_infos>
  93c324:	ff c5                	inc    ebp
  93c326:	48 29 d1             	sub    rcx,rdx
  93c329:	8b 94 24 5c 02 00 00 	mov    edx,DWORD PTR [rsp+0x25c]
  93c330:	48 c1 e9 05          	shr    rcx,0x5
  93c334:	69 c9 ab aa aa aa    	imul   ecx,ecx,0xaaaaaaab
  93c33a:	81 c9 00 00 00 80    	or     ecx,0x80000000
  93c340:	41 89 0c 90          	mov    DWORD PTR [r8+rdx*4],ecx
  93c344:	eb 7a                	jmp    93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c346:	31 c0                	xor    eax,eax
  93c348:	48 83 bc 24 e0 02 00 	cmp    QWORD PTR [rsp+0x2e0],0x0
  93c34f:	00 00 
  93c351:	4c 8b 54 24 18       	mov    r10,QWORD PTR [rsp+0x18]
  93c356:	8b 6c 24 0c          	mov    ebp,DWORD PTR [rsp+0xc]
  93c35a:	4c 8b bc 24 08 01 00 	mov    r15,QWORD PTR [rsp+0x108]
  93c361:	00 
  93c362:	4c 8b a4 24 00 01 00 	mov    r12,QWORD PTR [rsp+0x100]
  93c369:	00 
  93c36a:	75 54                	jne    93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c36c:	48 83 bc 24 e8 02 00 	cmp    QWORD PTR [rsp+0x2e8],0x0
  93c373:	00 00 
  93c375:	75 49                	jne    93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c377:	48 83 bc 24 f0 02 00 	cmp    QWORD PTR [rsp+0x2f0],0x0
  93c37e:	00 00 
  93c380:	75 3e                	jne    93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c382:	48 83 bc 24 f8 02 00 	cmp    QWORD PTR [rsp+0x2f8],0x0
  93c389:	00 00 
  93c38b:	75 33                	jne    93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c38d:	48 83 bc 24 00 03 00 	cmp    QWORD PTR [rsp+0x300],0x0
  93c394:	00 00 
  93c396:	75 28                	jne    93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c398:	48 83 bc 24 08 03 00 	cmp    QWORD PTR [rsp+0x308],0x0
  93c39f:	00 00 
  93c3a1:	75 1d                	jne    93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c3a3:	48 83 bc 24 10 03 00 	cmp    QWORD PTR [rsp+0x310],0x0
  93c3aa:	00 00 
  93c3ac:	75 12                	jne    93c3c0 <check_input_intrinsic_initialize+0x1040>
  93c3ae:	48 83 bc 24 18 03 00 	cmp    QWORD PTR [rsp+0x318],0x0
  93c3b5:	00 00 
  93c3b7:	0f 94 c0             	sete   al
  93c3ba:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  93c3c0:	45 31 ed             	xor    r13d,r13d
  93c3c3:	c4 c2 80 f3 cf       	blsr   r15,r15
  93c3c8:	0f 84 84 f0 ff ff    	je     93b452 <check_input_intrinsic_initialize+0xd2>
  93c3ce:	84 c0                	test   al,al
  93c3d0:	0f 85 6a f1 ff ff    	jne    93b540 <check_input_intrinsic_initialize+0x1c0>
  93c3d6:	e9 77 f0 ff ff       	jmp    93b452 <check_input_intrinsic_initialize+0xd2>
  93c3db:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93c3e0:	83 f9 3f             	cmp    ecx,0x3f
  93c3e3:	77 13                	ja     93c3f8 <check_input_intrinsic_initialize+0x1078>
  93c3e5:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  93c3ec:	89 c9                	mov    ecx,ecx
  93c3ee:	c4 e2 f0 f5 ce       	bzhi   rcx,rsi,rcx
  93c3f3:	c4 e1 fb 92 c9       	kmovq  k1,rcx
  93c3f8:	62 f1 7f c9 6f 04 10 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rax+rdx*1]
  93c3ff:	62 f2 7d 49 26 c0    	vptestmb k0{k1},zmm0,zmm0
  93c405:	62 f2 7d 48 5a 05 b1 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc8db1]        # 6051c0 <abi_test_hex.digits+0x370>
  93c40c:	8d cc ff 
  93c40f:	c4 e1 f8 44 c0       	knotq  k0,k0
  93c414:	c4 e1 fb 93 c0       	kmovq  rax,k0
  93c419:	49 21 c7             	and    r15,rax
  93c41c:	4d 85 ff             	test   r15,r15
  93c41f:	0f 85 0e f1 ff ff    	jne    93b533 <check_input_intrinsic_initialize+0x1b3>
  93c425:	e9 26 f0 ff ff       	jmp    93b450 <check_input_intrinsic_initialize+0xd0>
  93c42a:	8b 44 24 0c          	mov    eax,DWORD PTR [rsp+0xc]
  93c42e:	45 85 ed             	test   r13d,r13d
  93c431:	0f 84 14 01 00 00    	je     93c54b <check_input_intrinsic_initialize+0x11cb>
  93c437:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  93c43c:	80 38 00             	cmp    BYTE PTR [rax],0x0
  93c43f:	44 89 e8             	mov    eax,r13d
  93c442:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
  93c447:	0f 84 0b 01 00 00    	je     93c558 <check_input_intrinsic_initialize+0x11d8>
  93c44d:	31 c0                	xor    eax,eax
  93c44f:	eb 33                	jmp    93c484 <check_input_intrinsic_initialize+0x1104>
  93c451:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93c458:	0f 1f 84 00 00 00 00 
  93c45f:	00 
  93c460:	45 31 e4             	xor    r12d,r12d
  93c463:	48 8b 84 24 90 00 00 	mov    rax,QWORD PTR [rsp+0x90]
  93c46a:	00 
  93c46b:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  93c470:	4c 89 a4 c4 e0 02 00 	mov    QWORD PTR [rsp+rax*8+0x2e0],r12
  93c477:	00 
  93c478:	48 ff c0             	inc    rax
  93c47b:	48 39 f8             	cmp    rax,rdi
  93c47e:	0f 84 ca 05 00 00    	je     93ca4e <check_input_intrinsic_initialize+0x16ce>
  93c484:	48 89 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],rax
  93c48b:	00 
  93c48c:	48 c1 e0 04          	shl    rax,0x4
  93c490:	48 8b 8c 04 60 02 00 	mov    rcx,QWORD PTR [rsp+rax*1+0x260]
  93c497:	00 
  93c498:	8b b4 04 68 02 00 00 	mov    esi,DWORD PTR [rsp+rax*1+0x268]
  93c49f:	48 85 c9             	test   rcx,rcx
  93c4a2:	48 89 4c 24 60       	mov    QWORD PTR [rsp+0x60],rcx
  93c4a7:	0f 94 c0             	sete   al
  93c4aa:	85 f6                	test   esi,esi
  93c4ac:	0f 94 c1             	sete   cl
  93c4af:	08 c1                	or     cl,al
  93c4b1:	75 ad                	jne    93c460 <check_input_intrinsic_initialize+0x10e0>
  93c4b3:	41 bd bf 0e 00 00    	mov    r13d,0xebf
  93c4b9:	45 31 e4             	xor    r12d,r12d
  93c4bc:	45 31 ff             	xor    r15d,r15d
  93c4bf:	89 74 24 10          	mov    DWORD PTR [rsp+0x10],esi
  93c4c3:	eb 34                	jmp    93c4f9 <check_input_intrinsic_initialize+0x1179>
  93c4c5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  93c4cc:	00 00 00 00 
  93c4d0:	39 ee                	cmp    esi,ebp
  93c4d2:	0f 97 c0             	seta   al
  93c4d5:	1c 00                	sbb    al,0x0
  93c4d7:	0f be c0             	movsx  eax,al
  93c4da:	85 c0                	test   eax,eax
  93c4dc:	41 8d 4e 01          	lea    ecx,[r14+0x1]
  93c4e0:	45 0f 48 ee          	cmovs  r13d,r14d
  93c4e4:	4c 0f 44 e3          	cmove  r12,rbx
  93c4e8:	45 0f 44 ef          	cmove  r13d,r15d
  93c4ec:	44 0f 4f f9          	cmovg  r15d,ecx
  93c4f0:	45 39 ef             	cmp    r15d,r13d
  93c4f3:	0f 83 6a ff ff ff    	jae    93c463 <check_input_intrinsic_initialize+0x10e3>
  93c4f9:	45 89 ee             	mov    r14d,r13d
  93c4fc:	45 29 fe             	sub    r14d,r15d
  93c4ff:	48 8d 0d 7a 96 89 01 	lea    rcx,[rip+0x189967a]        # 21d5b80 <builtin_intrinsic_infos>
  93c506:	41 d1 ee             	shr    r14d,1
  93c509:	45 01 fe             	add    r14d,r15d
  93c50c:	4b 8d 04 76          	lea    rax,[r14+r14*2]
  93c510:	48 c1 e0 05          	shl    rax,0x5
  93c514:	8b 6c 08 40          	mov    ebp,DWORD PTR [rax+rcx*1+0x40]
  93c518:	48 8d 1c 01          	lea    rbx,[rcx+rax*1]
  93c51c:	85 ed                	test   ebp,ebp
  93c51e:	74 b0                	je     93c4d0 <check_input_intrinsic_initialize+0x1150>
  93c520:	39 ee                	cmp    esi,ebp
  93c522:	89 ea                	mov    edx,ebp
  93c524:	48 8b 7c 24 60       	mov    rdi,QWORD PTR [rsp+0x60]
  93c529:	0f 42 d6             	cmovb  edx,esi
  93c52c:	48 8b 33             	mov    rsi,QWORD PTR [rbx]
  93c52f:	c5 f8 77             	vzeroupper
  93c532:	e8 c9 a1 fc ff       	call   906700 <memcmp@plt>
  93c537:	62 f2 7d 48 5a 05 7f 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc8c7f]        # 6051c0 <abi_test_hex.digits+0x370>
  93c53e:	8c cc ff 
  93c541:	8b 74 24 10          	mov    esi,DWORD PTR [rsp+0x10]
  93c545:	85 c0                	test   eax,eax
  93c547:	75 91                	jne    93c4da <check_input_intrinsic_initialize+0x115a>
  93c549:	eb 85                	jmp    93c4d0 <check_input_intrinsic_initialize+0x1150>
  93c54b:	85 c0                	test   eax,eax
  93c54d:	0f 85 c2 06 00 00    	jne    93cc15 <check_input_intrinsic_initialize+0x1895>
  93c553:	e9 9b 09 00 00       	jmp    93cef3 <check_input_intrinsic_initialize+0x1b73>
  93c558:	31 c9                	xor    ecx,ecx
  93c55a:	44 89 6c 24 40       	mov    DWORD PTR [rsp+0x40],r13d
  93c55f:	eb 26                	jmp    93c587 <check_input_intrinsic_initialize+0x1207>
  93c561:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93c568:	0f 1f 84 00 00 00 00 
  93c56f:	00 
  93c570:	48 8b 4c 24 50       	mov    rcx,QWORD PTR [rsp+0x50]
  93c575:	44 8b 6c 24 40       	mov    r13d,DWORD PTR [rsp+0x40]
  93c57a:	03 4c 24 2c          	add    ecx,DWORD PTR [rsp+0x2c]
  93c57e:	44 39 e9             	cmp    ecx,r13d
  93c581:	0f 83 b8 04 00 00    	jae    93ca3f <check_input_intrinsic_initialize+0x16bf>
  93c587:	44 89 ea             	mov    edx,r13d
  93c58a:	29 ca                	sub    edx,ecx
  93c58c:	b8 08 00 00 00       	mov    eax,0x8
  93c591:	48 89 4c 24 50       	mov    QWORD PTR [rsp+0x50],rcx
  93c596:	83 fa 08             	cmp    edx,0x8
  93c599:	0f 43 d0             	cmovae edx,eax
  93c59c:	41 29 cd             	sub    r13d,ecx
  93c59f:	89 54 24 2c          	mov    DWORD PTR [rsp+0x2c],edx
  93c5a3:	74 cb                	je     93c570 <check_input_intrinsic_initialize+0x11f0>
  93c5a5:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
  93c5aa:	89 d1                	mov    ecx,edx
  93c5ac:	48 c7 84 cc e0 02 00 	mov    QWORD PTR [rsp+rcx*8+0x2e0],0x0
  93c5b3:	00 00 00 00 00 
  93c5b8:	48 89 8c 24 90 00 00 	mov    QWORD PTR [rsp+0x90],rcx
  93c5bf:	00 
  93c5c0:	48 c1 e1 04          	shl    rcx,0x4
  93c5c4:	48 83 bc 0c 60 02 00 	cmp    QWORD PTR [rsp+rcx*1+0x260],0x0
  93c5cb:	00 00 
  93c5cd:	74 24                	je     93c5f3 <check_input_intrinsic_initialize+0x1273>
  93c5cf:	48 8d 8c 0c 60 02 00 	lea    rcx,[rsp+rcx*1+0x260]
  93c5d6:	00 
  93c5d7:	be bf 0e 00 00       	mov    esi,0xebf
  93c5dc:	8b 49 08             	mov    ecx,DWORD PTR [rcx+0x8]
  93c5df:	85 c9                	test   ecx,ecx
  93c5e1:	0f 45 ce             	cmovne ecx,esi
  93c5e4:	c5 f9 6e c9          	vmovd  xmm1,ecx
  93c5e8:	41 83 fd 01          	cmp    r13d,0x1
  93c5ec:	75 15                	jne    93c603 <check_input_intrinsic_initialize+0x1283>
  93c5ee:	e9 8d 02 00 00       	jmp    93c880 <check_input_intrinsic_initialize+0x1500>
  93c5f3:	31 c9                	xor    ecx,ecx
  93c5f5:	c5 f9 6e c9          	vmovd  xmm1,ecx
  93c5f9:	41 83 fd 01          	cmp    r13d,0x1
  93c5fd:	0f 84 7d 02 00 00    	je     93c880 <check_input_intrinsic_initialize+0x1500>
  93c603:	8d 4a 01             	lea    ecx,[rdx+0x1]
  93c606:	48 c7 84 cc e0 02 00 	mov    QWORD PTR [rsp+rcx*8+0x2e0],0x0
  93c60d:	00 00 00 00 00 
  93c612:	48 c1 e1 04          	shl    rcx,0x4
  93c616:	48 83 bc 0c 60 02 00 	cmp    QWORD PTR [rsp+rcx*1+0x260],0x0
  93c61d:	00 00 
  93c61f:	74 2c                	je     93c64d <check_input_intrinsic_initialize+0x12cd>
  93c621:	48 8d 8c 0c 60 02 00 	lea    rcx,[rsp+rcx*1+0x260]
  93c628:	00 
  93c629:	be bf 0e 00 00       	mov    esi,0xebf
  93c62e:	8b 49 08             	mov    ecx,DWORD PTR [rcx+0x8]
  93c631:	85 c9                	test   ecx,ecx
  93c633:	0f 45 ce             	cmovne ecx,esi
  93c636:	c4 e3 71 22 c1 01    	vpinsrd xmm0,xmm1,ecx,0x1
  93c63c:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93c642:	41 83 fd 02          	cmp    r13d,0x2
  93c646:	75 1d                	jne    93c665 <check_input_intrinsic_initialize+0x12e5>
  93c648:	e9 33 02 00 00       	jmp    93c880 <check_input_intrinsic_initialize+0x1500>
  93c64d:	31 c9                	xor    ecx,ecx
  93c64f:	c4 e3 71 22 c1 01    	vpinsrd xmm0,xmm1,ecx,0x1
  93c655:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93c65b:	41 83 fd 02          	cmp    r13d,0x2
  93c65f:	0f 84 1b 02 00 00    	je     93c880 <check_input_intrinsic_initialize+0x1500>
  93c665:	8d 4a 02             	lea    ecx,[rdx+0x2]
  93c668:	48 c7 84 cc e0 02 00 	mov    QWORD PTR [rsp+rcx*8+0x2e0],0x0
  93c66f:	00 00 00 00 00 
  93c674:	48 c1 e1 04          	shl    rcx,0x4
  93c678:	48 83 bc 0c 60 02 00 	cmp    QWORD PTR [rsp+rcx*1+0x260],0x0
  93c67f:	00 00 
  93c681:	74 2c                	je     93c6af <check_input_intrinsic_initialize+0x132f>
  93c683:	48 8d 8c 0c 60 02 00 	lea    rcx,[rsp+rcx*1+0x260]
  93c68a:	00 
  93c68b:	be bf 0e 00 00       	mov    esi,0xebf
  93c690:	8b 49 08             	mov    ecx,DWORD PTR [rcx+0x8]
  93c693:	85 c9                	test   ecx,ecx
  93c695:	0f 45 ce             	cmovne ecx,esi
  93c698:	c4 e3 71 22 c1 02    	vpinsrd xmm0,xmm1,ecx,0x2
  93c69e:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93c6a4:	41 83 fd 03          	cmp    r13d,0x3
  93c6a8:	75 1d                	jne    93c6c7 <check_input_intrinsic_initialize+0x1347>
  93c6aa:	e9 d1 01 00 00       	jmp    93c880 <check_input_intrinsic_initialize+0x1500>
  93c6af:	31 c9                	xor    ecx,ecx
  93c6b1:	c4 e3 71 22 c1 02    	vpinsrd xmm0,xmm1,ecx,0x2
  93c6b7:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93c6bd:	41 83 fd 03          	cmp    r13d,0x3
  93c6c1:	0f 84 b9 01 00 00    	je     93c880 <check_input_intrinsic_initialize+0x1500>
  93c6c7:	8d 4a 03             	lea    ecx,[rdx+0x3]
  93c6ca:	48 c7 84 cc e0 02 00 	mov    QWORD PTR [rsp+rcx*8+0x2e0],0x0
  93c6d1:	00 00 00 00 00 
  93c6d6:	48 c1 e1 04          	shl    rcx,0x4
  93c6da:	48 83 bc 0c 60 02 00 	cmp    QWORD PTR [rsp+rcx*1+0x260],0x0
  93c6e1:	00 00 
  93c6e3:	74 2c                	je     93c711 <check_input_intrinsic_initialize+0x1391>
  93c6e5:	48 8d 8c 0c 60 02 00 	lea    rcx,[rsp+rcx*1+0x260]
  93c6ec:	00 
  93c6ed:	be bf 0e 00 00       	mov    esi,0xebf
  93c6f2:	8b 49 08             	mov    ecx,DWORD PTR [rcx+0x8]
  93c6f5:	85 c9                	test   ecx,ecx
  93c6f7:	0f 45 ce             	cmovne ecx,esi
  93c6fa:	c4 e3 71 22 c1 03    	vpinsrd xmm0,xmm1,ecx,0x3
  93c700:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93c706:	41 83 fd 04          	cmp    r13d,0x4
  93c70a:	75 1d                	jne    93c729 <check_input_intrinsic_initialize+0x13a9>
  93c70c:	e9 6f 01 00 00       	jmp    93c880 <check_input_intrinsic_initialize+0x1500>
  93c711:	31 c9                	xor    ecx,ecx
  93c713:	c4 e3 71 22 c1 03    	vpinsrd xmm0,xmm1,ecx,0x3
  93c719:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  93c71f:	41 83 fd 04          	cmp    r13d,0x4
  93c723:	0f 84 57 01 00 00    	je     93c880 <check_input_intrinsic_initialize+0x1500>
  93c729:	8d 4a 04             	lea    ecx,[rdx+0x4]
  93c72c:	48 c7 84 cc e0 02 00 	mov    QWORD PTR [rsp+rcx*8+0x2e0],0x0
  93c733:	00 00 00 00 00 
  93c738:	48 c1 e1 04          	shl    rcx,0x4
  93c73c:	48 83 bc 0c 60 02 00 	cmp    QWORD PTR [rsp+rcx*1+0x260],0x0
  93c743:	00 00 
  93c745:	74 2c                	je     93c773 <check_input_intrinsic_initialize+0x13f3>
  93c747:	48 8d 8c 0c 60 02 00 	lea    rcx,[rsp+rcx*1+0x260]
  93c74e:	00 
  93c74f:	be bf 0e 00 00       	mov    esi,0xebf
  93c754:	8b 49 08             	mov    ecx,DWORD PTR [rcx+0x8]
  93c757:	85 c9                	test   ecx,ecx
  93c759:	0f 45 ce             	cmovne ecx,esi
  93c75c:	62 f2 7d 28 7c c1    	vpbroadcastd ymm0,ecx
  93c762:	c4 e3 75 02 c8 10    	vpblendd ymm1,ymm1,ymm0,0x10
  93c768:	41 83 fd 05          	cmp    r13d,0x5
  93c76c:	75 1d                	jne    93c78b <check_input_intrinsic_initialize+0x140b>
  93c76e:	e9 0d 01 00 00       	jmp    93c880 <check_input_intrinsic_initialize+0x1500>
  93c773:	31 c9                	xor    ecx,ecx
  93c775:	62 f2 7d 28 7c c1    	vpbroadcastd ymm0,ecx
  93c77b:	c4 e3 75 02 c8 10    	vpblendd ymm1,ymm1,ymm0,0x10
  93c781:	41 83 fd 05          	cmp    r13d,0x5
  93c785:	0f 84 f5 00 00 00    	je     93c880 <check_input_intrinsic_initialize+0x1500>
  93c78b:	8d 4a 05             	lea    ecx,[rdx+0x5]
  93c78e:	48 c7 84 cc e0 02 00 	mov    QWORD PTR [rsp+rcx*8+0x2e0],0x0
  93c795:	00 00 00 00 00 
  93c79a:	48 c1 e1 04          	shl    rcx,0x4
  93c79e:	48 83 bc 0c 60 02 00 	cmp    QWORD PTR [rsp+rcx*1+0x260],0x0
  93c7a5:	00 00 
  93c7a7:	74 2c                	je     93c7d5 <check_input_intrinsic_initialize+0x1455>
  93c7a9:	48 8d 8c 0c 60 02 00 	lea    rcx,[rsp+rcx*1+0x260]
  93c7b0:	00 
  93c7b1:	be bf 0e 00 00       	mov    esi,0xebf
  93c7b6:	8b 49 08             	mov    ecx,DWORD PTR [rcx+0x8]
  93c7b9:	85 c9                	test   ecx,ecx
  93c7bb:	0f 45 ce             	cmovne ecx,esi
  93c7be:	62 f2 7d 28 7c c1    	vpbroadcastd ymm0,ecx
  93c7c4:	c4 e3 75 02 c8 20    	vpblendd ymm1,ymm1,ymm0,0x20
  93c7ca:	41 83 fd 06          	cmp    r13d,0x6
  93c7ce:	75 1d                	jne    93c7ed <check_input_intrinsic_initialize+0x146d>
  93c7d0:	e9 ab 00 00 00       	jmp    93c880 <check_input_intrinsic_initialize+0x1500>
  93c7d5:	31 c9                	xor    ecx,ecx
  93c7d7:	62 f2 7d 28 7c c1    	vpbroadcastd ymm0,ecx
  93c7dd:	c4 e3 75 02 c8 20    	vpblendd ymm1,ymm1,ymm0,0x20
  93c7e3:	41 83 fd 06          	cmp    r13d,0x6
  93c7e7:	0f 84 93 00 00 00    	je     93c880 <check_input_intrinsic_initialize+0x1500>
  93c7ed:	8d 4a 06             	lea    ecx,[rdx+0x6]
  93c7f0:	48 c7 84 cc e0 02 00 	mov    QWORD PTR [rsp+rcx*8+0x2e0],0x0
  93c7f7:	00 00 00 00 00 
  93c7fc:	48 c1 e1 04          	shl    rcx,0x4
  93c800:	48 83 bc 0c 60 02 00 	cmp    QWORD PTR [rsp+rcx*1+0x260],0x0
  93c807:	00 00 
  93c809:	74 17                	je     93c822 <check_input_intrinsic_initialize+0x14a2>
  93c80b:	48 8d 8c 0c 60 02 00 	lea    rcx,[rsp+rcx*1+0x260]
  93c812:	00 
  93c813:	be bf 0e 00 00       	mov    esi,0xebf
  93c818:	8b 49 08             	mov    ecx,DWORD PTR [rcx+0x8]
  93c81b:	85 c9                	test   ecx,ecx
  93c81d:	0f 45 ce             	cmovne ecx,esi
  93c820:	eb 02                	jmp    93c824 <check_input_intrinsic_initialize+0x14a4>
  93c822:	31 c9                	xor    ecx,ecx
  93c824:	62 f2 7d 28 7c c1    	vpbroadcastd ymm0,ecx
  93c82a:	c4 e3 75 02 c8 40    	vpblendd ymm1,ymm1,ymm0,0x40
  93c830:	41 83 fd 07          	cmp    r13d,0x7
  93c834:	74 4a                	je     93c880 <check_input_intrinsic_initialize+0x1500>
  93c836:	8d 42 07             	lea    eax,[rdx+0x7]
  93c839:	48 c7 84 c4 e0 02 00 	mov    QWORD PTR [rsp+rax*8+0x2e0],0x0
  93c840:	00 00 00 00 00 
  93c845:	48 c1 e0 04          	shl    rax,0x4
  93c849:	48 83 bc 04 60 02 00 	cmp    QWORD PTR [rsp+rax*1+0x260],0x0
  93c850:	00 00 
  93c852:	74 17                	je     93c86b <check_input_intrinsic_initialize+0x14eb>
  93c854:	48 8d 84 04 60 02 00 	lea    rax,[rsp+rax*1+0x260]
  93c85b:	00 
  93c85c:	b9 bf 0e 00 00       	mov    ecx,0xebf
  93c861:	8b 40 08             	mov    eax,DWORD PTR [rax+0x8]
  93c864:	85 c0                	test   eax,eax
  93c866:	0f 45 c1             	cmovne eax,ecx
  93c869:	eb 02                	jmp    93c86d <check_input_intrinsic_initialize+0x14ed>
  93c86b:	31 c0                	xor    eax,eax
  93c86d:	62 f2 7d 28 7c c0    	vpbroadcastd ymm0,eax
  93c873:	c4 e3 75 02 c8 80    	vpblendd ymm1,ymm1,ymm0,0x80
  93c879:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  93c880:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  93c884:	c5 f5 66 c2          	vpcmpgtd ymm0,ymm1,ymm2
  93c888:	c4 e2 7d 0e c0       	vtestps ymm0,ymm0
  93c88d:	0f 84 dd fc ff ff    	je     93c570 <check_input_intrinsic_initialize+0x11f0>
  93c893:	48 8b 8c 24 90 00 00 	mov    rcx,QWORD PTR [rsp+0x90]
  93c89a:	00 
  93c89b:	8b 5c 24 2c          	mov    ebx,DWORD PTR [rsp+0x2c]
  93c89f:	48 8d 84 24 68 02 00 	lea    rax,[rsp+0x268]
  93c8a6:	00 
  93c8a7:	62 f1 75 28 66 d2    	vpcmpgtd k2,ymm1,ymm2
  93c8ad:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  93c8b1:	48 c1 e1 04          	shl    rcx,0x4
  93c8b5:	48 01 c1             	add    rcx,rax
  93c8b8:	48 89 8c 24 88 00 00 	mov    QWORD PTR [rsp+0x88],rcx
  93c8bf:	00 
  93c8c0:	eb 76                	jmp    93c938 <check_input_intrinsic_initialize+0x15b8>
  93c8c2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93c8c9:	1f 84 00 00 00 00 00 
  93c8d0:	c5 fe 6f 84 24 20 03 	vmovdqu ymm0,YMMWORD PTR [rsp+0x320]
  93c8d7:	00 00 
  93c8d9:	c5 fe 6f 9c 24 a0 01 	vmovdqu ymm3,YMMWORD PTR [rsp+0x1a0]
  93c8e0:	00 00 
  93c8e2:	c5 fe 6f a4 24 80 01 	vmovdqu ymm4,YMMWORD PTR [rsp+0x180]
  93c8e9:	00 00 
  93c8eb:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  93c8ef:	c5 f5 76 c9          	vpcmpeqd ymm1,ymm1,ymm1
  93c8f3:	62 f1 7d 2a 66 ca    	vpcmpgtd k1{k2},ymm0,ymm2
  93c8f9:	62 f1 7d aa 72 e0 1f 	vpsrad ymm0{k2}{z},ymm0,0x1f
  93c900:	62 f1 5d 29 fa d9    	vpsubd ymm3{k1},ymm4,ymm1
  93c906:	c5 fe 6f 8c 24 10 01 	vmovdqu ymm1,YMMWORD PTR [rsp+0x110]
  93c90d:	00 00 
  93c90f:	c4 e3 65 4c c4 00    	vpblendvb ymm0,ymm3,ymm4,ymm0
  93c915:	62 f1 7d 29 6f c1    	vmovdqa32 ymm0{k1},ymm1
  93c91b:	c5 fd 66 cb          	vpcmpgtd ymm1,ymm0,ymm3
  93c91f:	62 f1 7d 28 66 d3    	vpcmpgtd k2,ymm0,ymm3
  93c925:	c4 e2 7d 0e c9       	vtestps ymm1,ymm1
  93c92a:	c5 fd 6f c8          	vmovdqa ymm1,ymm0
  93c92e:	c5 fd 6f c3          	vmovdqa ymm0,ymm3
  93c932:	0f 84 38 fc ff ff    	je     93c570 <check_input_intrinsic_initialize+0x11f0>
  93c938:	4c 8b a4 24 88 00 00 	mov    r12,QWORD PTR [rsp+0x88]
  93c93f:	00 
  93c940:	c5 fd 6f d8          	vmovdqa ymm3,ymm0
  93c944:	c5 f5 fa c0          	vpsubd ymm0,ymm1,ymm0
  93c948:	c5 f9 93 f2          	kmovb  esi,k2
  93c94c:	45 31 ed             	xor    r13d,r13d
  93c94f:	c5 fe 7f 8c 24 10 01 	vmovdqu YMMWORD PTR [rsp+0x110],ymm1
  93c956:	00 00 
  93c958:	c5 fe 7f 9c 24 a0 01 	vmovdqu YMMWORD PTR [rsp+0x1a0],ymm3
  93c95f:	00 00 
  93c961:	c5 fe 7f 94 24 20 03 	vmovdqu YMMWORD PTR [rsp+0x320],ymm2
  93c968:	00 00 
  93c96a:	c5 f8 91 54 24 60    	kmovw  WORD PTR [rsp+0x60],k2
  93c970:	c5 fd 72 d0 01       	vpsrld ymm0,ymm0,0x1
  93c975:	89 74 24 10          	mov    DWORD PTR [rsp+0x10],esi
  93c979:	c5 fd fe c3          	vpaddd ymm0,ymm0,ymm3
  93c97d:	c5 fe 7f 84 24 80 01 	vmovdqu YMMWORD PTR [rsp+0x180],ymm0
  93c984:	00 00 
  93c986:	c5 fe 7f 84 24 40 03 	vmovdqu YMMWORD PTR [rsp+0x340],ymm0
  93c98d:	00 00 
  93c98f:	eb 27                	jmp    93c9b8 <check_input_intrinsic_initialize+0x1638>
  93c991:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93c998:	0f 1f 84 00 00 00 00 
  93c99f:	00 
  93c9a0:	42 89 84 ac 20 03 00 	mov    DWORD PTR [rsp+r13*4+0x320],eax
  93c9a7:	00 
  93c9a8:	49 ff c5             	inc    r13
  93c9ab:	49 83 c4 10          	add    r12,0x10
  93c9af:	4c 39 eb             	cmp    rbx,r13
  93c9b2:	0f 84 18 ff ff ff    	je     93c8d0 <check_input_intrinsic_initialize+0x1550>
  93c9b8:	44 0f a3 ee          	bt     esi,r13d
  93c9bc:	73 ea                	jae    93c9a8 <check_input_intrinsic_initialize+0x1628>
  93c9be:	4a 63 84 ac 40 03 00 	movsxd rax,DWORD PTR [rsp+r13*4+0x340]
  93c9c5:	00 
  93c9c6:	48 8d 0d b3 91 89 01 	lea    rcx,[rip+0x18991b3]        # 21d5b80 <builtin_intrinsic_infos>
  93c9cd:	41 8b 2c 24          	mov    ebp,DWORD PTR [r12]
  93c9d1:	48 8d 04 40          	lea    rax,[rax+rax*2]
  93c9d5:	48 c1 e0 05          	shl    rax,0x5
  93c9d9:	44 8b 74 08 40       	mov    r14d,DWORD PTR [rax+rcx*1+0x40]
  93c9de:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  93c9e2:	44 39 f5             	cmp    ebp,r14d
  93c9e5:	44 89 f0             	mov    eax,r14d
  93c9e8:	0f 42 c5             	cmovb  eax,ebp
  93c9eb:	85 c0                	test   eax,eax
  93c9ed:	74 20                	je     93ca0f <check_input_intrinsic_initialize+0x168f>
  93c9ef:	49 8b 7c 24 f8       	mov    rdi,QWORD PTR [r12-0x8]
  93c9f4:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  93c9f7:	89 c2                	mov    edx,eax
  93c9f9:	c5 f8 77             	vzeroupper
  93c9fc:	e8 ff 9c fc ff       	call   906700 <memcmp@plt>
  93ca01:	8b 74 24 10          	mov    esi,DWORD PTR [rsp+0x10]
  93ca05:	c5 f8 90 54 24 60    	kmovw  k2,WORD PTR [rsp+0x60]
  93ca0b:	85 c0                	test   eax,eax
  93ca0d:	75 91                	jne    93c9a0 <check_input_intrinsic_initialize+0x1620>
  93ca0f:	44 39 f5             	cmp    ebp,r14d
  93ca12:	0f 97 c0             	seta   al
  93ca15:	1c 00                	sbb    al,0x0
  93ca17:	0f be c0             	movsx  eax,al
  93ca1a:	42 89 84 ac 20 03 00 	mov    DWORD PTR [rsp+r13*4+0x320],eax
  93ca21:	00 
  93ca22:	44 39 f5             	cmp    ebp,r14d
  93ca25:	75 81                	jne    93c9a8 <check_input_intrinsic_initialize+0x1628>
  93ca27:	48 8b 84 24 90 00 00 	mov    rax,QWORD PTR [rsp+0x90]
  93ca2e:	00 
  93ca2f:	44 01 e8             	add    eax,r13d
  93ca32:	4c 89 bc c4 e0 02 00 	mov    QWORD PTR [rsp+rax*8+0x2e0],r15
  93ca39:	00 
  93ca3a:	e9 69 ff ff ff       	jmp    93c9a8 <check_input_intrinsic_initialize+0x1628>
  93ca3f:	62 f2 7d 48 5a 05 77 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc8777]        # 6051c0 <abi_test_hex.digits+0x370>
  93ca46:	87 cc ff 
  93ca49:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  93ca4e:	4c 8b 54 24 30       	mov    r10,QWORD PTR [rsp+0x30]
  93ca53:	4c 8b 5c 24 18       	mov    r11,QWORD PTR [rsp+0x18]
  93ca58:	44 8b 4c 24 0c       	mov    r9d,DWORD PTR [rsp+0xc]
  93ca5d:	4d 85 d2             	test   r10,r10
  93ca60:	74 16                	je     93ca78 <check_input_intrinsic_initialize+0x16f8>
  93ca62:	89 f8                	mov    eax,edi
  93ca64:	48 8d 4f ff          	lea    rcx,[rdi-0x1]
  93ca68:	83 e0 03             	and    eax,0x3
  93ca6b:	48 83 f9 03          	cmp    rcx,0x3
  93ca6f:	73 2f                	jae    93caa0 <check_input_intrinsic_initialize+0x1720>
  93ca71:	31 c9                	xor    ecx,ecx
  93ca73:	e9 27 01 00 00       	jmp    93cb9f <check_input_intrinsic_initialize+0x181f>
  93ca78:	b9 01 00 00 00       	mov    ecx,0x1
  93ca7d:	4d 89 da             	mov    r10,r11
  93ca80:	48 83 bc cc d8 02 00 	cmp    QWORD PTR [rsp+rcx*8+0x2d8],0x0
  93ca87:	00 00 
  93ca89:	0f 94 c0             	sete   al
  93ca8c:	0f 85 70 01 00 00    	jne    93cc02 <check_input_intrinsic_initialize+0x1882>
  93ca92:	48 39 f9             	cmp    rcx,rdi
  93ca95:	48 8d 49 01          	lea    rcx,[rcx+0x1]
  93ca99:	72 e5                	jb     93ca80 <check_input_intrinsic_initialize+0x1700>
  93ca9b:	e9 62 01 00 00       	jmp    93cc02 <check_input_intrinsic_initialize+0x1882>
  93caa0:	83 e7 fc             	and    edi,0xfffffffc
  93caa3:	31 c9                	xor    ecx,ecx
  93caa5:	eb 16                	jmp    93cabd <check_input_intrinsic_initialize+0x173d>
  93caa7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  93caae:	00 00 
  93cab0:	48 83 c1 04          	add    rcx,0x4
  93cab4:	48 39 cf             	cmp    rdi,rcx
  93cab7:	0f 84 dd 00 00 00    	je     93cb9a <check_input_intrinsic_initialize+0x181a>
  93cabd:	48 8b 94 cc e0 02 00 	mov    rdx,QWORD PTR [rsp+rcx*8+0x2e0]
  93cac4:	00 
  93cac5:	48 85 d2             	test   rdx,rdx
  93cac8:	74 28                	je     93caf2 <check_input_intrinsic_initialize+0x1772>
  93caca:	48 8d 35 af 90 89 01 	lea    rsi,[rip+0x18990af]        # 21d5b80 <builtin_intrinsic_infos>
  93cad1:	41 ff c1             	inc    r9d
  93cad4:	48 29 f2             	sub    rdx,rsi
  93cad7:	8b b4 8c 40 02 00 00 	mov    esi,DWORD PTR [rsp+rcx*4+0x240]
  93cade:	48 c1 ea 05          	shr    rdx,0x5
  93cae2:	69 d2 ab aa aa aa    	imul   edx,edx,0xaaaaaaab
  93cae8:	81 ca 00 00 00 80    	or     edx,0x80000000
  93caee:	41 89 14 b2          	mov    DWORD PTR [r10+rsi*4],edx
  93caf2:	48 8b 94 cc e8 02 00 	mov    rdx,QWORD PTR [rsp+rcx*8+0x2e8]
  93caf9:	00 
  93cafa:	48 85 d2             	test   rdx,rdx
  93cafd:	74 28                	je     93cb27 <check_input_intrinsic_initialize+0x17a7>
  93caff:	48 8d 35 7a 90 89 01 	lea    rsi,[rip+0x189907a]        # 21d5b80 <builtin_intrinsic_infos>
  93cb06:	41 ff c1             	inc    r9d
  93cb09:	48 29 f2             	sub    rdx,rsi
  93cb0c:	8b b4 8c 44 02 00 00 	mov    esi,DWORD PTR [rsp+rcx*4+0x244]
  93cb13:	48 c1 ea 05          	shr    rdx,0x5
  93cb17:	69 d2 ab aa aa aa    	imul   edx,edx,0xaaaaaaab
  93cb1d:	81 ca 00 00 00 80    	or     edx,0x80000000
  93cb23:	41 89 14 b2          	mov    DWORD PTR [r10+rsi*4],edx
  93cb27:	48 8b 94 cc f0 02 00 	mov    rdx,QWORD PTR [rsp+rcx*8+0x2f0]
  93cb2e:	00 
  93cb2f:	48 85 d2             	test   rdx,rdx
  93cb32:	74 28                	je     93cb5c <check_input_intrinsic_initialize+0x17dc>
  93cb34:	48 8d 35 45 90 89 01 	lea    rsi,[rip+0x1899045]        # 21d5b80 <builtin_intrinsic_infos>
  93cb3b:	41 ff c1             	inc    r9d
  93cb3e:	48 29 f2             	sub    rdx,rsi
  93cb41:	8b b4 8c 48 02 00 00 	mov    esi,DWORD PTR [rsp+rcx*4+0x248]
  93cb48:	48 c1 ea 05          	shr    rdx,0x5
  93cb4c:	69 d2 ab aa aa aa    	imul   edx,edx,0xaaaaaaab
  93cb52:	81 ca 00 00 00 80    	or     edx,0x80000000
  93cb58:	41 89 14 b2          	mov    DWORD PTR [r10+rsi*4],edx
  93cb5c:	48 8b 94 cc f8 02 00 	mov    rdx,QWORD PTR [rsp+rcx*8+0x2f8]
  93cb63:	00 
  93cb64:	48 85 d2             	test   rdx,rdx
  93cb67:	0f 84 43 ff ff ff    	je     93cab0 <check_input_intrinsic_initialize+0x1730>
  93cb6d:	48 8d 35 0c 90 89 01 	lea    rsi,[rip+0x189900c]        # 21d5b80 <builtin_intrinsic_infos>
  93cb74:	41 ff c1             	inc    r9d
  93cb77:	48 29 f2             	sub    rdx,rsi
  93cb7a:	8b b4 8c 4c 02 00 00 	mov    esi,DWORD PTR [rsp+rcx*4+0x24c]
  93cb81:	48 c1 ea 05          	shr    rdx,0x5
  93cb85:	69 d2 ab aa aa aa    	imul   edx,edx,0xaaaaaaab
  93cb8b:	81 ca 00 00 00 80    	or     edx,0x80000000
  93cb91:	41 89 14 b2          	mov    DWORD PTR [r10+rsi*4],edx
  93cb95:	e9 16 ff ff ff       	jmp    93cab0 <check_input_intrinsic_initialize+0x1730>
  93cb9a:	48 85 c0             	test   rax,rax
  93cb9d:	74 59                	je     93cbf8 <check_input_intrinsic_initialize+0x1878>
  93cb9f:	48 8d 94 8c 40 02 00 	lea    rdx,[rsp+rcx*4+0x240]
  93cba6:	00 
  93cba7:	48 8d 8c cc e0 02 00 	lea    rcx,[rsp+rcx*8+0x2e0]
  93cbae:	00 
  93cbaf:	31 f6                	xor    esi,esi
  93cbb1:	eb 15                	jmp    93cbc8 <check_input_intrinsic_initialize+0x1848>
  93cbb3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93cbba:	84 00 00 00 00 00 
  93cbc0:	48 ff c6             	inc    rsi
  93cbc3:	48 39 f0             	cmp    rax,rsi
  93cbc6:	74 30                	je     93cbf8 <check_input_intrinsic_initialize+0x1878>
  93cbc8:	48 8b 3c f1          	mov    rdi,QWORD PTR [rcx+rsi*8]
  93cbcc:	48 85 ff             	test   rdi,rdi
  93cbcf:	74 ef                	je     93cbc0 <check_input_intrinsic_initialize+0x1840>
  93cbd1:	4c 8d 05 a8 8f 89 01 	lea    r8,[rip+0x1898fa8]        # 21d5b80 <builtin_intrinsic_infos>
  93cbd8:	41 ff c1             	inc    r9d
  93cbdb:	4c 29 c7             	sub    rdi,r8
  93cbde:	44 8b 04 b2          	mov    r8d,DWORD PTR [rdx+rsi*4]
  93cbe2:	48 c1 ef 05          	shr    rdi,0x5
  93cbe6:	69 ff ab aa aa aa    	imul   edi,edi,0xaaaaaaab
  93cbec:	81 cf 00 00 00 80    	or     edi,0x80000000
  93cbf2:	43 89 3c 82          	mov    DWORD PTR [r10+r8*4],edi
  93cbf6:	eb c8                	jmp    93cbc0 <check_input_intrinsic_initialize+0x1840>
  93cbf8:	b0 01                	mov    al,0x1
  93cbfa:	4d 89 da             	mov    r10,r11
  93cbfd:	44 89 4c 24 0c       	mov    DWORD PTR [rsp+0xc],r9d
  93cc02:	84 c0                	test   al,al
  93cc04:	0f 84 e1 02 00 00    	je     93ceeb <check_input_intrinsic_initialize+0x1b6b>
  93cc0a:	83 7c 24 0c 00       	cmp    DWORD PTR [rsp+0xc],0x0
  93cc0f:	0f 84 d6 02 00 00    	je     93ceeb <check_input_intrinsic_initialize+0x1b6b>
  93cc15:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  93cc1a:	8b 40 40             	mov    eax,DWORD PTR [rax+0x40]
  93cc1d:	48 85 c0             	test   rax,rax
  93cc20:	0f 84 e2 02 00 00    	je     93cf08 <check_input_intrinsic_initialize+0x1b88>
  93cc26:	49 8b 32             	mov    rsi,QWORD PTR [r10]
  93cc29:	49 8b 4a 08          	mov    rcx,QWORD PTR [r10+0x8]
  93cc2d:	8b 6c 24 0c          	mov    ebp,DWORD PTR [rsp+0xc]
  93cc31:	4c 8b 64 24 30       	mov    r12,QWORD PTR [rsp+0x30]
  93cc36:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  93cc3d:	4d 89 d5             	mov    r13,r10
  93cc40:	45 31 f6             	xor    r14d,r14d
  93cc43:	45 31 c0             	xor    r8d,r8d
  93cc46:	8b 51 40             	mov    edx,DWORD PTR [rcx+0x40]
  93cc49:	48 8b b6 98 02 00 00 	mov    rsi,QWORD PTR [rsi+0x298]
  93cc50:	eb 1b                	jmp    93cc6d <check_input_intrinsic_initialize+0x18ed>
  93cc52:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93cc59:	1f 84 00 00 00 00 00 
  93cc60:	49 83 c0 40          	add    r8,0x40
  93cc64:	49 39 c0             	cmp    r8,rax
  93cc67:	0f 83 71 02 00 00    	jae    93cede <check_input_intrinsic_initialize+0x1b5e>
  93cc6d:	41 89 d2             	mov    r10d,edx
  93cc70:	45 29 c2             	sub    r10d,r8d
  93cc73:	41 83 fa 3f          	cmp    r10d,0x3f
  93cc77:	77 27                	ja     93cca0 <check_input_intrinsic_initialize+0x1920>
  93cc79:	45 89 d1             	mov    r9d,r10d
  93cc7c:	c4 62 b0 f5 cf       	bzhi   r9,rdi,r9
  93cc81:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  93cc84:	75 70                	jne    93ccf6 <check_input_intrinsic_initialize+0x1976>
  93cc86:	4c 8b 59 20          	mov    r11,QWORD PTR [rcx+0x20]
  93cc8a:	c4 c1 fb 92 c9       	kmovq  k1,r9
  93cc8f:	62 91 7d 49 74 14 03 	vpcmpeqb k2{k1},zmm0,ZMMWORD PTR [r11+r8*1]
  93cc96:	eb 24                	jmp    93ccbc <check_input_intrinsic_initialize+0x193c>
  93cc98:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  93cc9f:	00 
  93cca0:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  93cca3:	49 c7 c1 ff ff ff ff 	mov    r9,0xffffffffffffffff
  93ccaa:	75 53                	jne    93ccff <check_input_intrinsic_initialize+0x197f>
  93ccac:	4c 8b 49 20          	mov    r9,QWORD PTR [rcx+0x20]
  93ccb0:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93ccb5:	62 91 7d 48 74 14 01 	vpcmpeqb k2,zmm0,ZMMWORD PTR [r9+r8*1]
  93ccbc:	4c 8b 49 60          	mov    r9,QWORD PTR [rcx+0x60]
  93ccc0:	62 f1 fd 48 6f c8    	vmovdqa64 zmm1,zmm0
  93ccc6:	62 91 7f c9 6f 04 01 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [r9+r8*1]
  93cccd:	62 f1 7d 4a 74 c1    	vpcmpeqb k0{k2},zmm0,zmm1
  93ccd3:	62 f1 fd 48 6f c1    	vmovdqa64 zmm0,zmm1
  93ccd9:	c4 e1 f4 41 c0       	kandq  k0,k1,k0
  93ccde:	c4 61 fb 93 c8       	kmovq  r9,k0
  93cce3:	48 85 f6             	test   rsi,rsi
  93cce6:	74 0e                	je     93ccf6 <check_input_intrinsic_initialize+0x1976>
  93cce8:	49 83 bd d0 05 00 00 	cmp    QWORD PTR [r13+0x5d0],0x0
  93ccef:	00 
  93ccf0:	0f 84 9e 01 00 00    	je     93ce94 <check_input_intrinsic_initialize+0x1b14>
  93ccf6:	4d 85 c9             	test   r9,r9
  93ccf9:	0f 84 61 ff ff ff    	je     93cc60 <check_input_intrinsic_initialize+0x18e0>
  93ccff:	4c 8b 51 20          	mov    r10,QWORD PTR [rcx+0x20]
  93cd03:	48 85 f6             	test   rsi,rsi
  93cd06:	75 23                	jne    93cd2b <check_input_intrinsic_initialize+0x19ab>
  93cd08:	e9 ee 00 00 00       	jmp    93cdfb <check_input_intrinsic_initialize+0x1a7b>
  93cd0d:	4c 8b 6c 24 18       	mov    r13,QWORD PTR [rsp+0x18]
  93cd12:	8b 6c 24 0c          	mov    ebp,DWORD PTR [rsp+0xc]
  93cd16:	4c 8b 64 24 30       	mov    r12,QWORD PTR [rsp+0x30]
  93cd1b:	41 01 de             	add    r14d,ebx
  93cd1e:	66 90                	xchg   ax,ax
  93cd20:	c4 c2 b0 f3 c9       	blsr   r9,r9
  93cd25:	0f 84 35 ff ff ff    	je     93cc60 <check_input_intrinsic_initialize+0x18e0>
  93cd2b:	45 31 ff             	xor    r15d,r15d
  93cd2e:	f3 4d 0f bc f9       	tzcnt  r15,r9
  93cd33:	4d 09 c7             	or     r15,r8
  93cd36:	45 89 fb             	mov    r11d,r15d
  93cd39:	43 80 3c 1a 02       	cmp    BYTE PTR [r10+r11*1],0x2
  93cd3e:	75 e0                	jne    93cd20 <check_input_intrinsic_initialize+0x19a0>
  93cd40:	48 8b 59 60          	mov    rbx,QWORD PTR [rcx+0x60]
  93cd44:	42 80 3c 1b 02       	cmp    BYTE PTR [rbx+r11*1],0x2
  93cd49:	75 d5                	jne    93cd20 <check_input_intrinsic_initialize+0x19a0>
  93cd4b:	49 83 bd d0 05 00 00 	cmp    QWORD PTR [r13+0x5d0],0x0
  93cd52:	00 
  93cd53:	74 77                	je     93cdcc <check_input_intrinsic_initialize+0x1a4c>
  93cd55:	48 8b 5c 24 20       	mov    rbx,QWORD PTR [rsp+0x20]
  93cd5a:	48 8b 5b 28          	mov    rbx,QWORD PTR [rbx+0x28]
  93cd5e:	42 8b 1c 9b          	mov    ebx,DWORD PTR [rbx+r11*4]
  93cd62:	41 83 3c 9c fe       	cmp    DWORD PTR [r12+rbx*4],0xfffffffe
  93cd67:	7f b7                	jg     93cd20 <check_input_intrinsic_initialize+0x19a0>
  93cd69:	31 db                	xor    ebx,ebx
  93cd6b:	44 39 f8             	cmp    eax,r15d
  93cd6e:	76 a2                	jbe    93cd12 <check_input_intrinsic_initialize+0x1992>
  93cd70:	4c 8b 7c 24 20       	mov    r15,QWORD PTR [rsp+0x20]
  93cd75:	4d 8d 6b 01          	lea    r13,[r11+0x1]
  93cd79:	4d 8b 7f 70          	mov    r15,QWORD PTR [r15+0x70]
  93cd7d:	47 8b 24 9f          	mov    r12d,DWORD PTR [r15+r11*4]
  93cd81:	45 39 e5             	cmp    r13d,r12d
  93cd84:	73 87                	jae    93cd0d <check_input_intrinsic_initialize+0x198d>
  93cd86:	41 39 c4             	cmp    r12d,eax
  93cd89:	73 82                	jae    93cd0d <check_input_intrinsic_initialize+0x198d>
  93cd8b:	48 8b 6c 24 20       	mov    rbp,QWORD PTR [rsp+0x20]
  93cd90:	48 8b 6d 60          	mov    rbp,QWORD PTR [rbp+0x60]
  93cd94:	42 80 7c 1d 00 02    	cmp    BYTE PTR [rbp+r11*1+0x0],0x2
  93cd9a:	0f 85 6d ff ff ff    	jne    93cd0d <check_input_intrinsic_initialize+0x198d>
  93cda0:	42 80 7c 2d 00 23    	cmp    BYTE PTR [rbp+r13*1+0x0],0x23
  93cda6:	0f 85 61 ff ff ff    	jne    93cd0d <check_input_intrinsic_initialize+0x198d>
  93cdac:	42 80 7c 25 00 3c    	cmp    BYTE PTR [rbp+r12*1+0x0],0x3c
  93cdb2:	4c 8b 6c 24 18       	mov    r13,QWORD PTR [rsp+0x18]
  93cdb7:	0f 85 55 ff ff ff    	jne    93cd12 <check_input_intrinsic_initialize+0x1992>
  93cdbd:	31 db                	xor    ebx,ebx
  93cdbf:	47 39 64 9f 04       	cmp    DWORD PTR [r15+r11*4+0x4],r12d
  93cdc4:	0f 94 c3             	sete   bl
  93cdc7:	e9 46 ff ff ff       	jmp    93cd12 <check_input_intrinsic_initialize+0x1992>
  93cdcc:	42 80 3c 1e 00       	cmp    BYTE PTR [rsi+r11*1],0x0
  93cdd1:	0f 85 49 ff ff ff    	jne    93cd20 <check_input_intrinsic_initialize+0x19a0>
  93cdd7:	e9 79 ff ff ff       	jmp    93cd55 <check_input_intrinsic_initialize+0x19d5>
  93cddc:	4c 8b 6c 24 18       	mov    r13,QWORD PTR [rsp+0x18]
  93cde1:	8b 6c 24 0c          	mov    ebp,DWORD PTR [rsp+0xc]
  93cde5:	4c 8b 64 24 30       	mov    r12,QWORD PTR [rsp+0x30]
  93cdea:	45 01 de             	add    r14d,r11d
  93cded:	0f 1f 00             	nop    DWORD PTR [rax]
  93cdf0:	c4 c2 b0 f3 c9       	blsr   r9,r9
  93cdf5:	0f 84 65 fe ff ff    	je     93cc60 <check_input_intrinsic_initialize+0x18e0>
  93cdfb:	45 31 ff             	xor    r15d,r15d
  93cdfe:	f3 4d 0f bc f9       	tzcnt  r15,r9
  93ce03:	4d 09 c7             	or     r15,r8
  93ce06:	44 89 fb             	mov    ebx,r15d
  93ce09:	41 80 3c 1a 02       	cmp    BYTE PTR [r10+rbx*1],0x2
  93ce0e:	75 e0                	jne    93cdf0 <check_input_intrinsic_initialize+0x1a70>
  93ce10:	4c 8b 59 60          	mov    r11,QWORD PTR [rcx+0x60]
  93ce14:	41 80 3c 1b 02       	cmp    BYTE PTR [r11+rbx*1],0x2
  93ce19:	75 d5                	jne    93cdf0 <check_input_intrinsic_initialize+0x1a70>
  93ce1b:	4c 8b 5c 24 20       	mov    r11,QWORD PTR [rsp+0x20]
  93ce20:	4d 8b 5b 28          	mov    r11,QWORD PTR [r11+0x28]
  93ce24:	45 8b 1c 9b          	mov    r11d,DWORD PTR [r11+rbx*4]
  93ce28:	43 83 3c 9c fe       	cmp    DWORD PTR [r12+r11*4],0xfffffffe
  93ce2d:	7f c1                	jg     93cdf0 <check_input_intrinsic_initialize+0x1a70>
  93ce2f:	45 31 db             	xor    r11d,r11d
  93ce32:	44 39 f8             	cmp    eax,r15d
  93ce35:	76 aa                	jbe    93cde1 <check_input_intrinsic_initialize+0x1a61>
  93ce37:	4c 8b 7c 24 20       	mov    r15,QWORD PTR [rsp+0x20]
  93ce3c:	4c 8d 6b 01          	lea    r13,[rbx+0x1]
  93ce40:	4d 8b 7f 70          	mov    r15,QWORD PTR [r15+0x70]
  93ce44:	45 8b 24 9f          	mov    r12d,DWORD PTR [r15+rbx*4]
  93ce48:	45 39 e5             	cmp    r13d,r12d
  93ce4b:	73 8f                	jae    93cddc <check_input_intrinsic_initialize+0x1a5c>
  93ce4d:	41 39 c4             	cmp    r12d,eax
  93ce50:	73 8a                	jae    93cddc <check_input_intrinsic_initialize+0x1a5c>
  93ce52:	48 8b 6c 24 20       	mov    rbp,QWORD PTR [rsp+0x20]
  93ce57:	48 8b 6d 60          	mov    rbp,QWORD PTR [rbp+0x60]
  93ce5b:	80 7c 1d 00 02       	cmp    BYTE PTR [rbp+rbx*1+0x0],0x2
  93ce60:	0f 85 76 ff ff ff    	jne    93cddc <check_input_intrinsic_initialize+0x1a5c>
  93ce66:	42 80 7c 2d 00 23    	cmp    BYTE PTR [rbp+r13*1+0x0],0x23
  93ce6c:	0f 85 6a ff ff ff    	jne    93cddc <check_input_intrinsic_initialize+0x1a5c>
  93ce72:	42 80 7c 25 00 3c    	cmp    BYTE PTR [rbp+r12*1+0x0],0x3c
  93ce78:	4c 8b 6c 24 18       	mov    r13,QWORD PTR [rsp+0x18]
  93ce7d:	0f 85 5e ff ff ff    	jne    93cde1 <check_input_intrinsic_initialize+0x1a61>
  93ce83:	45 31 db             	xor    r11d,r11d
  93ce86:	45 39 64 9f 04       	cmp    DWORD PTR [r15+rbx*4+0x4],r12d
  93ce8b:	41 0f 94 c3          	sete   r11b
  93ce8f:	e9 4d ff ff ff       	jmp    93cde1 <check_input_intrinsic_initialize+0x1a61>
  93ce94:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93ce99:	41 83 fa 3f          	cmp    r10d,0x3f
  93ce9d:	77 0d                	ja     93ceac <check_input_intrinsic_initialize+0x1b2c>
  93ce9f:	45 89 d2             	mov    r10d,r10d
  93cea2:	c4 62 a8 f5 d7       	bzhi   r10,rdi,r10
  93cea7:	c4 c1 fb 92 ca       	kmovq  k1,r10
  93ceac:	62 b1 7f c9 6f 04 06 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rsi+r8*1]
  93ceb3:	62 f2 7d 49 26 c0    	vptestmb k0{k1},zmm0,zmm0
  93ceb9:	62 f2 7d 48 5a 05 fd 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffcc82fd]        # 6051c0 <abi_test_hex.digits+0x370>
  93cec0:	82 cc ff 
  93cec3:	c4 e1 f8 44 c0       	knotq  k0,k0
  93cec8:	c4 61 fb 93 d0       	kmovq  r10,k0
  93cecd:	4d 21 d1             	and    r9,r10
  93ced0:	4d 85 c9             	test   r9,r9
  93ced3:	0f 85 26 fe ff ff    	jne    93ccff <check_input_intrinsic_initialize+0x197f>
  93ced9:	e9 82 fd ff ff       	jmp    93cc60 <check_input_intrinsic_initialize+0x18e0>
  93cede:	48 8d 3c 85 04 00 00 	lea    rdi,[rax*4+0x4]
  93cee5:	00 
  93cee6:	4d 89 ea             	mov    r10,r13
  93cee9:	eb 29                	jmp    93cf14 <check_input_intrinsic_initialize+0x1b94>
  93ceeb:	84 c0                	test   al,al
  93ceed:	0f 84 89 01 00 00    	je     93d07c <check_input_intrinsic_initialize+0x1cfc>
  93cef3:	49 8b 42 28          	mov    rax,QWORD PTR [r10+0x28]
  93cef7:	48 8b 8c 24 f8 00 00 	mov    rcx,QWORD PTR [rsp+0xf8]
  93cefe:	00 
  93ceff:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
  93cf03:	e9 70 01 00 00       	jmp    93d078 <check_input_intrinsic_initialize+0x1cf8>
  93cf08:	8b 6c 24 0c          	mov    ebp,DWORD PTR [rsp+0xc]
  93cf0c:	45 31 f6             	xor    r14d,r14d
  93cf0f:	bf 04 00 00 00       	mov    edi,0x4
  93cf14:	49 8b 42 20          	mov    rax,QWORD PTR [r10+0x20]
  93cf18:	48 8b 08             	mov    rcx,QWORD PTR [rax]
  93cf1b:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  93cf1f:	48 8d 74 0a 3f       	lea    rsi,[rdx+rcx*1+0x3f]
  93cf24:	48 01 ca             	add    rdx,rcx
  93cf27:	48 83 e6 c0          	and    rsi,0xffffffffffffffc0
  93cf2b:	48 39 d6             	cmp    rsi,rdx
  93cf2e:	73 04                	jae    93cf34 <check_input_intrinsic_initialize+0x1bb4>
  93cf30:	31 db                	xor    ebx,ebx
  93cf32:	eb 3d                	jmp    93cf71 <check_input_intrinsic_initialize+0x1bf1>
  93cf34:	4c 8b 48 10          	mov    r9,QWORD PTR [rax+0x10]
  93cf38:	49 89 f0             	mov    r8,rsi
  93cf3b:	49 29 c8             	sub    r8,rcx
  93cf3e:	31 db                	xor    ebx,ebx
  93cf40:	4d 29 c1             	sub    r9,r8
  93cf43:	72 2c                	jb     93cf71 <check_input_intrinsic_initialize+0x1bf1>
  93cf45:	4c 39 cf             	cmp    rdi,r9
  93cf48:	77 27                	ja     93cf71 <check_input_intrinsic_initialize+0x1bf1>
  93cf4a:	49 01 f8             	add    r8,rdi
  93cf4d:	48 89 f3             	mov    rbx,rsi
  93cf50:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
  93cf54:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
  93cf58:	49 39 c8             	cmp    r8,rcx
  93cf5b:	4c 0f 46 c1          	cmovbe r8,rcx
  93cf5f:	4c 89 40 20          	mov    QWORD PTR [rax+0x20],r8
  93cf63:	49 8b 42 20          	mov    rax,QWORD PTR [r10+0x20]
  93cf67:	48 8b 08             	mov    rcx,QWORD PTR [rax]
  93cf6a:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  93cf6e:	48 01 ca             	add    rdx,rcx
  93cf71:	48 8d 72 07          	lea    rsi,[rdx+0x7]
  93cf75:	48 83 e6 f8          	and    rsi,0xfffffffffffffff8
  93cf79:	48 39 d6             	cmp    rsi,rdx
  93cf7c:	73 05                	jae    93cf83 <check_input_intrinsic_initialize+0x1c03>
  93cf7e:	45 31 ff             	xor    r15d,r15d
  93cf81:	eb 39                	jmp    93cfbc <check_input_intrinsic_initialize+0x1c3c>
  93cf83:	48 89 f2             	mov    rdx,rsi
  93cf86:	48 29 ca             	sub    rdx,rcx
  93cf89:	48 8b 48 10          	mov    rcx,QWORD PTR [rax+0x10]
  93cf8d:	45 31 ff             	xor    r15d,r15d
  93cf90:	48 29 d1             	sub    rcx,rdx
  93cf93:	72 27                	jb     93cfbc <check_input_intrinsic_initialize+0x1c3c>
  93cf95:	89 ef                	mov    edi,ebp
  93cf97:	48 69 ff 30 01 00 00 	imul   rdi,rdi,0x130
  93cf9e:	48 39 cf             	cmp    rdi,rcx
  93cfa1:	77 19                	ja     93cfbc <check_input_intrinsic_initialize+0x1c3c>
  93cfa3:	48 01 fa             	add    rdx,rdi
  93cfa6:	49 89 f7             	mov    r15,rsi
  93cfa9:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  93cfad:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
  93cfb1:	48 39 ca             	cmp    rdx,rcx
  93cfb4:	48 0f 46 d1          	cmovbe rdx,rcx
  93cfb8:	48 89 50 20          	mov    QWORD PTR [rax+0x20],rdx
  93cfbc:	45 85 f6             	test   r14d,r14d
  93cfbf:	74 20                	je     93cfe1 <check_input_intrinsic_initialize+0x1c61>
  93cfc1:	49 8b 42 20          	mov    rax,QWORD PTR [r10+0x20]
  93cfc5:	48 8b 30             	mov    rsi,QWORD PTR [rax]
  93cfc8:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  93cfcc:	48 8d 4c 32 07       	lea    rcx,[rdx+rsi*1+0x7]
  93cfd1:	48 01 f2             	add    rdx,rsi
  93cfd4:	48 83 e1 f8          	and    rcx,0xfffffffffffffff8
  93cfd8:	48 39 d1             	cmp    rcx,rdx
  93cfdb:	0f 83 f4 00 00 00    	jae    93d0d5 <check_input_intrinsic_initialize+0x1d55>
  93cfe1:	45 31 e4             	xor    r12d,r12d
  93cfe4:	45 85 f6             	test   r14d,r14d
  93cfe7:	0f 94 c0             	sete   al
  93cfea:	4d 85 e4             	test   r12,r12
  93cfed:	0f 95 c1             	setne  cl
  93cff0:	48 83 7c 24 30 00    	cmp    QWORD PTR [rsp+0x30],0x0
  93cff6:	0f 84 80 00 00 00    	je     93d07c <check_input_intrinsic_initialize+0x1cfc>
  93cffc:	48 85 db             	test   rbx,rbx
  93cfff:	74 7b                	je     93d07c <check_input_intrinsic_initialize+0x1cfc>
  93d001:	4d 85 ff             	test   r15,r15
  93d004:	74 76                	je     93d07c <check_input_intrinsic_initialize+0x1cfc>
  93d006:	08 c8                	or     al,cl
  93d008:	74 72                	je     93d07c <check_input_intrinsic_initialize+0x1cfc>
  93d00a:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  93d00f:	48 89 df             	mov    rdi,rbx
  93d012:	31 f6                	xor    esi,esi
  93d014:	4d 89 d5             	mov    r13,r10
  93d017:	8b 40 40             	mov    eax,DWORD PTR [rax+0x40]
  93d01a:	48 8d 14 85 04 00 00 	lea    rdx,[rax*4+0x4]
  93d021:	00 
  93d022:	c5 f8 77             	vzeroupper
  93d025:	e8 06 97 fc ff       	call   906730 <memset@plt>
  93d02a:	48 8b 44 24 30       	mov    rax,QWORD PTR [rsp+0x30]
  93d02f:	48 8b 94 24 f0 00 00 	mov    rdx,QWORD PTR [rsp+0xf0]
  93d036:	00 
  93d037:	8b 4c 24 0c          	mov    ecx,DWORD PTR [rsp+0xc]
  93d03b:	49 89 85 80 02 00 00 	mov    QWORD PTR [r13+0x280],rax
  93d042:	48 89 9a c0 02 00 00 	mov    QWORD PTR [rdx+0x2c0],rbx
  93d049:	4c 89 ba a0 02 00 00 	mov    QWORD PTR [rdx+0x2a0],r15
  93d050:	c7 82 a8 02 00 00 00 	mov    DWORD PTR [rdx+0x2a8],0x0
  93d057:	00 00 00 
  93d05a:	89 8a ac 02 00 00    	mov    DWORD PTR [rdx+0x2ac],ecx
  93d060:	4c 89 a2 b0 02 00 00 	mov    QWORD PTR [rdx+0x2b0],r12
  93d067:	c7 82 b8 02 00 00 00 	mov    DWORD PTR [rdx+0x2b8],0x0
  93d06e:	00 00 00 
  93d071:	44 89 b2 bc 02 00 00 	mov    DWORD PTR [rdx+0x2bc],r14d
  93d078:	b0 01                	mov    al,0x1
  93d07a:	eb 31                	jmp    93d0ad <check_input_intrinsic_initialize+0x1d2d>
  93d07c:	49 8b 42 20          	mov    rax,QWORD PTR [r10+0x20]
  93d080:	48 8b 8c 24 38 01 00 	mov    rcx,QWORD PTR [rsp+0x138]
  93d087:	00 
  93d088:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
  93d08c:	48 8b 8c 24 f8 00 00 	mov    rcx,QWORD PTR [rsp+0xf8]
  93d093:	00 
  93d094:	49 8b 42 28          	mov    rax,QWORD PTR [r10+0x28]
  93d098:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
  93d09c:	48 8b 84 24 f0 00 00 	mov    rax,QWORD PTR [rsp+0xf0]
  93d0a3:	00 
  93d0a4:	c6 80 9e 05 00 00 01 	mov    BYTE PTR [rax+0x59e],0x1
  93d0ab:	31 c0                	xor    eax,eax
  93d0ad:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  93d0b4:	00 00 
  93d0b6:	48 3b 8c 24 60 03 00 	cmp    rcx,QWORD PTR [rsp+0x360]
  93d0bd:	00 
  93d0be:	75 59                	jne    93d119 <check_input_intrinsic_initialize+0x1d99>
  93d0c0:	48 81 c4 68 03 00 00 	add    rsp,0x368
  93d0c7:	5b                   	pop    rbx
  93d0c8:	41 5c                	pop    r12
  93d0ca:	41 5d                	pop    r13
  93d0cc:	41 5e                	pop    r14
  93d0ce:	41 5f                	pop    r15
  93d0d0:	5d                   	pop    rbp
  93d0d1:	c5 f8 77             	vzeroupper
  93d0d4:	c3                   	ret
  93d0d5:	48 8b 78 10          	mov    rdi,QWORD PTR [rax+0x10]
  93d0d9:	48 89 ca             	mov    rdx,rcx
  93d0dc:	48 29 f2             	sub    rdx,rsi
  93d0df:	45 31 e4             	xor    r12d,r12d
  93d0e2:	48 29 d7             	sub    rdi,rdx
  93d0e5:	0f 82 f9 fe ff ff    	jb     93cfe4 <check_input_intrinsic_initialize+0x1c64>
  93d0eb:	44 89 f6             	mov    esi,r14d
  93d0ee:	48 c1 e6 05          	shl    rsi,0x5
  93d0f2:	48 39 fe             	cmp    rsi,rdi
  93d0f5:	0f 87 e9 fe ff ff    	ja     93cfe4 <check_input_intrinsic_initialize+0x1c64>
  93d0fb:	48 01 f2             	add    rdx,rsi
  93d0fe:	49 89 cc             	mov    r12,rcx
  93d101:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  93d105:	48 8b 70 20          	mov    rsi,QWORD PTR [rax+0x20]
  93d109:	48 39 f2             	cmp    rdx,rsi
  93d10c:	48 0f 46 d6          	cmovbe rdx,rsi
  93d110:	48 89 50 20          	mov    QWORD PTR [rax+0x20],rdx
  93d114:	e9 cb fe ff ff       	jmp    93cfe4 <check_input_intrinsic_initialize+0x1c64>
  93d119:	c5 f8 77             	vzeroupper
  93d11c:	e8 cf 8c fc ff       	call   905df0 <__stack_chk_fail@plt>
