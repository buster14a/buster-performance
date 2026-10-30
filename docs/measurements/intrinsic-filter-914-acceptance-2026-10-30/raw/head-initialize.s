
work/pr914-acceptance/bin/head/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

000000000093f380 <check_input_intrinsic_initialize>:
  93f380:	55                   	push   rbp
  93f381:	41 57                	push   r15
  93f383:	41 56                	push   r14
  93f385:	41 55                	push   r13
  93f387:	41 54                	push   r12
  93f389:	53                   	push   rbx
  93f38a:	48 81 ec e8 00 00 00 	sub    rsp,0xe8
  93f391:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  93f398:	00 00 
  93f39a:	62 f2 7d 48 5a 0d 3c 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffcc9e3c]        # 6091e0 <abi_test_hex.digits+0x370>
  93f3a1:	9e cc ff 
  93f3a4:	45 31 c0             	xor    r8d,r8d
  93f3a7:	31 ed                	xor    ebp,ebp
  93f3a9:	45 31 ff             	xor    r15d,r15d
  93f3ac:	45 31 c9             	xor    r9d,r9d
  93f3af:	48 89 84 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],rax
  93f3b6:	00 
  93f3b7:	48 89 3c 24          	mov    QWORD PTR [rsp],rdi
  93f3bb:	48 8b 07             	mov    rax,QWORD PTR [rdi]
  93f3be:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
  93f3c2:	48 8b 4f 10          	mov    rcx,QWORD PTR [rdi+0x10]
  93f3c6:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
  93f3cb:	48 8b 81 98 02 00 00 	mov    rax,QWORD PTR [rcx+0x298]
  93f3d2:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
  93f3d7:	48 8b 57 20          	mov    rdx,QWORD PTR [rdi+0x20]
  93f3db:	48 8b 4f 28          	mov    rcx,QWORD PTR [rdi+0x28]
  93f3df:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
  93f3e4:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
  93f3e8:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
  93f3ed:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
  93f3f1:	c7 44 24 3c 00 00 00 	mov    DWORD PTR [rsp+0x3c],0x0
  93f3f8:	00 
  93f3f9:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
  93f3fe:	eb 13                	jmp    93f413 <check_input_intrinsic_initialize+0x93>
  93f400:	b0 01                	mov    al,0x1
  93f402:	44 8b 4c 24 1c       	mov    r9d,DWORD PTR [rsp+0x1c]
  93f407:	41 83 c1 40          	add    r9d,0x40
  93f40b:	84 c0                	test   al,al
  93f40d:	0f 84 28 08 00 00    	je     93fc3b <check_input_intrinsic_initialize+0x8bb>
  93f413:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  93f418:	44 3b 48 40          	cmp    r9d,DWORD PTR [rax+0x40]
  93f41c:	0f 83 d0 02 00 00    	jae    93f6f2 <check_input_intrinsic_initialize+0x372>
  93f422:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  93f426:	44 89 4c 24 1c       	mov    DWORD PTR [rsp+0x1c],r9d
  93f42b:	49 8b 76 08          	mov    rsi,QWORD PTR [r14+0x8]
  93f42f:	49 8b 06             	mov    rax,QWORD PTR [r14]
  93f432:	8b 4e 40             	mov    ecx,DWORD PTR [rsi+0x40]
  93f435:	48 8b 80 98 02 00 00 	mov    rax,QWORD PTR [rax+0x298]
  93f43c:	44 29 c9             	sub    ecx,r9d
  93f43f:	83 f9 3f             	cmp    ecx,0x3f
  93f442:	77 2c                	ja     93f470 <check_input_intrinsic_initialize+0xf0>
  93f444:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  93f44b:	89 ca                	mov    edx,ecx
  93f44d:	c4 62 e8 f5 ef       	bzhi   r13,rdi,rdx
  93f452:	80 3e 00             	cmp    BYTE PTR [rsi],0x0
  93f455:	75 66                	jne    93f4bd <check_input_intrinsic_initialize+0x13d>
  93f457:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
  93f45b:	c4 c1 fb 92 cd       	kmovq  k1,r13
  93f460:	44 89 ca             	mov    edx,r9d
  93f463:	62 f1 75 49 74 14 17 	vpcmpeqb k2{k1},zmm1,ZMMWORD PTR [rdi+rdx*1]
  93f46a:	eb 23                	jmp    93f48f <check_input_intrinsic_initialize+0x10f>
  93f46c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
  93f470:	80 3e 00             	cmp    BYTE PTR [rsi],0x0
  93f473:	49 c7 c5 ff ff ff ff 	mov    r13,0xffffffffffffffff
  93f47a:	75 4a                	jne    93f4c6 <check_input_intrinsic_initialize+0x146>
  93f47c:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
  93f480:	44 89 ca             	mov    edx,r9d
  93f483:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93f488:	62 f1 75 48 74 14 17 	vpcmpeqb k2,zmm1,ZMMWORD PTR [rdi+rdx*1]
  93f48f:	48 8b 76 60          	mov    rsi,QWORD PTR [rsi+0x60]
  93f493:	62 f1 7f c9 6f 04 16 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rsi+rdx*1]
  93f49a:	62 f1 7d 4a 74 c1    	vpcmpeqb k0{k2},zmm0,zmm1
  93f4a0:	c4 e1 f4 41 c0       	kandq  k0,k1,k0
  93f4a5:	c4 61 fb 93 e8       	kmovq  r13,k0
  93f4aa:	48 85 c0             	test   rax,rax
  93f4ad:	74 0e                	je     93f4bd <check_input_intrinsic_initialize+0x13d>
  93f4af:	49 83 be d0 05 00 00 	cmp    QWORD PTR [r14+0x5d0],0x0
  93f4b6:	00 
  93f4b7:	0f 84 f0 01 00 00    	je     93f6ad <check_input_intrinsic_initialize+0x32d>
  93f4bd:	4d 85 ed             	test   r13,r13
  93f4c0:	0f 84 3a ff ff ff    	je     93f400 <check_input_intrinsic_initialize+0x80>
  93f4c6:	45 89 cc             	mov    r12d,r9d
  93f4c9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  93f4d0:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
  93f4d4:	31 c0                	xor    eax,eax
  93f4d6:	f3 49 0f bc c5       	tzcnt  rax,r13
  93f4db:	4c 09 e0             	or     rax,r12
  93f4de:	48 8b 51 20          	mov    rdx,QWORD PTR [rcx+0x20]
  93f4e2:	80 3c 02 02          	cmp    BYTE PTR [rdx+rax*1],0x2
  93f4e6:	0f 85 60 01 00 00    	jne    93f64c <check_input_intrinsic_initialize+0x2cc>
  93f4ec:	48 8b 49 60          	mov    rcx,QWORD PTR [rcx+0x60]
  93f4f0:	80 3c 01 02          	cmp    BYTE PTR [rcx+rax*1],0x2
  93f4f4:	0f 85 52 01 00 00    	jne    93f64c <check_input_intrinsic_initialize+0x2cc>
  93f4fa:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
  93f4fd:	48 8b 89 98 02 00 00 	mov    rcx,QWORD PTR [rcx+0x298]
  93f504:	48 85 c9             	test   rcx,rcx
  93f507:	74 0a                	je     93f513 <check_input_intrinsic_initialize+0x193>
  93f509:	49 83 be d0 05 00 00 	cmp    QWORD PTR [r14+0x5d0],0x0
  93f510:	00 
  93f511:	74 64                	je     93f577 <check_input_intrinsic_initialize+0x1f7>
  93f513:	48 8b 4c 24 08       	mov    rcx,QWORD PTR [rsp+0x8]
  93f518:	48 8b 49 28          	mov    rcx,QWORD PTR [rcx+0x28]
  93f51c:	8b 1c 81             	mov    ebx,DWORD PTR [rcx+rax*4]
  93f51f:	4d 85 c0             	test   r8,r8
  93f522:	75 2f                	jne    93f553 <check_input_intrinsic_initialize+0x1d3>
  93f524:	41 f6 c7 01          	test   r15b,0x1
  93f528:	75 29                	jne    93f553 <check_input_intrinsic_initialize+0x1d3>
  93f52a:	49 8b 4e 28          	mov    rcx,QWORD PTR [r14+0x28]
  93f52e:	48 8b 01             	mov    rax,QWORD PTR [rcx]
  93f531:	48 8b 51 08          	mov    rdx,QWORD PTR [rcx+0x8]
  93f535:	4c 8d 74 02 3f       	lea    r14,[rdx+rax*1+0x3f]
  93f53a:	48 01 c2             	add    rdx,rax
  93f53d:	49 83 e6 c0          	and    r14,0xffffffffffffffc0
  93f541:	49 39 d6             	cmp    r14,rdx
  93f544:	73 3d                	jae    93f583 <check_input_intrinsic_initialize+0x203>
  93f546:	b0 01                	mov    al,0x1
  93f548:	45 31 c0             	xor    r8d,r8d
  93f54b:	41 b7 01             	mov    r15b,0x1
  93f54e:	e9 b8 00 00 00       	jmp    93f60b <check_input_intrinsic_initialize+0x28b>
  93f553:	b0 01                	mov    al,0x1
  93f555:	41 f6 c7 01          	test   r15b,0x1
  93f559:	41 b7 01             	mov    r15b,0x1
  93f55c:	0f 85 a9 00 00 00    	jne    93f60b <check_input_intrinsic_initialize+0x28b>
  93f562:	45 31 ff             	xor    r15d,r15d
  93f565:	41 83 3c 98 ff       	cmp    DWORD PTR [r8+rbx*4],0xffffffff
  93f56a:	0f 85 d8 00 00 00    	jne    93f648 <check_input_intrinsic_initialize+0x2c8>
  93f570:	31 c0                	xor    eax,eax
  93f572:	e9 94 00 00 00       	jmp    93f60b <check_input_intrinsic_initialize+0x28b>
  93f577:	80 3c 01 00          	cmp    BYTE PTR [rcx+rax*1],0x0
  93f57b:	0f 85 cb 00 00 00    	jne    93f64c <check_input_intrinsic_initialize+0x2cc>
  93f581:	eb 90                	jmp    93f513 <check_input_intrinsic_initialize+0x193>
  93f583:	48 8b 71 10          	mov    rsi,QWORD PTR [rcx+0x10]
  93f587:	4c 89 f2             	mov    rdx,r14
  93f58a:	48 29 c2             	sub    rdx,rax
  93f58d:	b0 01                	mov    al,0x1
  93f58f:	48 29 d6             	sub    rsi,rdx
  93f592:	72 b4                	jb     93f548 <check_input_intrinsic_initialize+0x1c8>
  93f594:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
  93f599:	41 b8 00 00 00 00    	mov    r8d,0x0
  93f59f:	41 b7 01             	mov    r15b,0x1
  93f5a2:	8b bf 88 00 00 00    	mov    edi,DWORD PTR [rdi+0x88]
  93f5a8:	48 c1 e7 02          	shl    rdi,0x2
  93f5ac:	48 39 f7             	cmp    rdi,rsi
  93f5af:	77 5a                	ja     93f60b <check_input_intrinsic_initialize+0x28b>
  93f5b1:	48 01 fa             	add    rdx,rdi
  93f5b4:	48 89 51 08          	mov    QWORD PTR [rcx+0x8],rdx
  93f5b8:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
  93f5bc:	48 39 c2             	cmp    rdx,rax
  93f5bf:	48 0f 46 d0          	cmovbe rdx,rax
  93f5c3:	48 89 51 20          	mov    QWORD PTR [rcx+0x20],rdx
  93f5c7:	4d 85 f6             	test   r14,r14
  93f5ca:	0f 84 76 ff ff ff    	je     93f546 <check_input_intrinsic_initialize+0x1c6>
  93f5d0:	48 8b 44 24 10       	mov    rax,QWORD PTR [rsp+0x10]
  93f5d5:	be ff 00 00 00       	mov    esi,0xff
  93f5da:	4c 89 f7             	mov    rdi,r14
  93f5dd:	8b 90 88 00 00 00    	mov    edx,DWORD PTR [rax+0x88]
  93f5e3:	48 c1 e2 02          	shl    rdx,0x2
  93f5e7:	c5 f8 77             	vzeroupper
  93f5ea:	e8 41 b5 fc ff       	call   90ab30 <memset@plt>
  93f5ef:	62 f2 7d 48 5a 0d e7 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffcc9be7]        # 6091e0 <abi_test_hex.digits+0x370>
  93f5f6:	9b cc ff 
  93f5f9:	4d 89 f0             	mov    r8,r14
  93f5fc:	45 31 ff             	xor    r15d,r15d
  93f5ff:	41 83 3c 98 ff       	cmp    DWORD PTR [r8+rbx*4],0xffffffff
  93f604:	75 42                	jne    93f648 <check_input_intrinsic_initialize+0x2c8>
  93f606:	e9 65 ff ff ff       	jmp    93f570 <check_input_intrinsic_initialize+0x1f0>
  93f60b:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
  93f610:	89 ee                	mov    esi,ebp
  93f612:	48 8b 4f 10          	mov    rcx,QWORD PTR [rdi+0x10]
  93f616:	8b 14 d9             	mov    edx,DWORD PTR [rcx+rbx*8]
  93f619:	8b 4c d9 04          	mov    ecx,DWORD PTR [rcx+rbx*8+0x4]
  93f61d:	48 03 57 50          	add    rdx,QWORD PTR [rdi+0x50]
  93f621:	89 5c b4 40          	mov    DWORD PTR [rsp+rsi*4+0x40],ebx
  93f625:	48 c1 e6 04          	shl    rsi,0x4
  93f629:	48 89 54 34 60       	mov    QWORD PTR [rsp+rsi*1+0x60],rdx
  93f62e:	89 4c 34 68          	mov    DWORD PTR [rsp+rsi*1+0x68],ecx
  93f632:	c7 44 34 6c 00 00 00 	mov    DWORD PTR [rsp+rsi*1+0x6c],0x0
  93f639:	00 
  93f63a:	84 c0                	test   al,al
  93f63c:	75 08                	jne    93f646 <check_input_intrinsic_initialize+0x2c6>
  93f63e:	41 c7 04 98 00 00 00 	mov    DWORD PTR [r8+rbx*4],0x0
  93f645:	00 
  93f646:	ff c5                	inc    ebp
  93f648:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  93f64c:	b0 01                	mov    al,0x1
  93f64e:	83 fd 08             	cmp    ebp,0x8
  93f651:	74 0d                	je     93f660 <check_input_intrinsic_initialize+0x2e0>
  93f653:	c4 c2 90 f3 cd       	blsr   r13,r13
  93f658:	75 46                	jne    93f6a0 <check_input_intrinsic_initialize+0x320>
  93f65a:	e9 a3 fd ff ff       	jmp    93f402 <check_input_intrinsic_initialize+0x82>
  93f65f:	90                   	nop
  93f660:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  93f665:	48 8d 74 24 60       	lea    rsi,[rsp+0x60]
  93f66a:	48 8d 54 24 40       	lea    rdx,[rsp+0x40]
  93f66f:	b9 08 00 00 00       	mov    ecx,0x8
  93f674:	4c 8d 4c 24 3c       	lea    r9,[rsp+0x3c]
  93f679:	4c 89 c3             	mov    rbx,r8
  93f67c:	8b 38                	mov    edi,DWORD PTR [rax]
  93f67e:	c5 f8 77             	vzeroupper
  93f681:	e8 ca 58 02 00       	call   964f50 <check_input_intrinsic_lookup>
  93f686:	62 f2 7d 48 5a 0d 50 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffcc9b50]        # 6091e0 <abi_test_hex.digits+0x370>
  93f68d:	9b cc ff 
  93f690:	49 89 d8             	mov    r8,rbx
  93f693:	31 ed                	xor    ebp,ebp
  93f695:	c4 c2 90 f3 cd       	blsr   r13,r13
  93f69a:	0f 84 62 fd ff ff    	je     93f402 <check_input_intrinsic_initialize+0x82>
  93f6a0:	84 c0                	test   al,al
  93f6a2:	0f 85 28 fe ff ff    	jne    93f4d0 <check_input_intrinsic_initialize+0x150>
  93f6a8:	e9 55 fd ff ff       	jmp    93f402 <check_input_intrinsic_initialize+0x82>
  93f6ad:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93f6b2:	83 f9 3f             	cmp    ecx,0x3f
  93f6b5:	77 13                	ja     93f6ca <check_input_intrinsic_initialize+0x34a>
  93f6b7:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  93f6be:	89 c9                	mov    ecx,ecx
  93f6c0:	c4 e2 f0 f5 ce       	bzhi   rcx,rsi,rcx
  93f6c5:	c4 e1 fb 92 c9       	kmovq  k1,rcx
  93f6ca:	62 f1 7f c9 6f 04 10 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rax+rdx*1]
  93f6d1:	62 f2 7d 49 26 c0    	vptestmb k0{k1},zmm0,zmm0
  93f6d7:	c4 e1 f8 44 c0       	knotq  k0,k0
  93f6dc:	c4 e1 fb 93 c0       	kmovq  rax,k0
  93f6e1:	49 21 c5             	and    r13,rax
  93f6e4:	4d 85 ed             	test   r13,r13
  93f6e7:	0f 85 d9 fd ff ff    	jne    93f4c6 <check_input_intrinsic_initialize+0x146>
  93f6ed:	e9 0e fd ff ff       	jmp    93f400 <check_input_intrinsic_initialize+0x80>
  93f6f2:	85 ed                	test   ebp,ebp
  93f6f4:	74 4e                	je     93f744 <check_input_intrinsic_initialize+0x3c4>
  93f6f6:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  93f6fb:	48 8d 74 24 60       	lea    rsi,[rsp+0x60]
  93f700:	48 8d 54 24 40       	lea    rdx,[rsp+0x40]
  93f705:	4c 8d 4c 24 3c       	lea    r9,[rsp+0x3c]
  93f70a:	89 e9                	mov    ecx,ebp
  93f70c:	4c 89 c3             	mov    rbx,r8
  93f70f:	8b 38                	mov    edi,DWORD PTR [rax]
  93f711:	c5 f8 77             	vzeroupper
  93f714:	e8 37 58 02 00       	call   964f50 <check_input_intrinsic_lookup>
  93f719:	62 f2 7d 48 5a 0d bd 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffcc9abd]        # 6091e0 <abi_test_hex.digits+0x370>
  93f720:	9a cc ff 
  93f723:	8b 4c 24 3c          	mov    ecx,DWORD PTR [rsp+0x3c]
  93f727:	49 89 d8             	mov    r8,rbx
  93f72a:	85 c9                	test   ecx,ecx
  93f72c:	89 4c 24 10          	mov    DWORD PTR [rsp+0x10],ecx
  93f730:	0f 95 c1             	setne  cl
  93f733:	84 c8                	test   al,cl
  93f735:	75 1d                	jne    93f754 <check_input_intrinsic_initialize+0x3d4>
  93f737:	84 c0                	test   al,al
  93f739:	0f 84 fc 04 00 00    	je     93fc3b <check_input_intrinsic_initialize+0x8bb>
  93f73f:	e9 01 02 00 00       	jmp    93f945 <check_input_intrinsic_initialize+0x5c5>
  93f744:	8b 44 24 3c          	mov    eax,DWORD PTR [rsp+0x3c]
  93f748:	89 44 24 10          	mov    DWORD PTR [rsp+0x10],eax
  93f74c:	85 c0                	test   eax,eax
  93f74e:	0f 84 f1 01 00 00    	je     93f945 <check_input_intrinsic_initialize+0x5c5>
  93f754:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  93f759:	8b 40 40             	mov    eax,DWORD PTR [rax+0x40]
  93f75c:	48 85 c0             	test   rax,rax
  93f75f:	0f 84 f6 01 00 00    	je     93f95b <check_input_intrinsic_initialize+0x5db>
  93f765:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  93f769:	4c 89 c2             	mov    rdx,r8
  93f76c:	45 31 ed             	xor    r13d,r13d
  93f76f:	49 8b 36             	mov    rsi,QWORD PTR [r14]
  93f772:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
  93f776:	8b 69 40             	mov    ebp,DWORD PTR [rcx+0x40]
  93f779:	48 8b b6 98 02 00 00 	mov    rsi,QWORD PTR [rsi+0x298]
  93f780:	48 85 f6             	test   rsi,rsi
  93f783:	0f 84 e0 01 00 00    	je     93f969 <check_input_intrinsic_initialize+0x5e9>
  93f789:	45 31 c0             	xor    r8d,r8d
  93f78c:	eb 13                	jmp    93f7a1 <check_input_intrinsic_initialize+0x421>
  93f78e:	66 90                	xchg   ax,ax
  93f790:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  93f794:	49 83 c0 40          	add    r8,0x40
  93f798:	49 39 c0             	cmp    r8,rax
  93f79b:	0f 83 07 03 00 00    	jae    93faa8 <check_input_intrinsic_initialize+0x728>
  93f7a1:	41 89 ea             	mov    r10d,ebp
  93f7a4:	45 29 c2             	sub    r10d,r8d
  93f7a7:	41 83 fa 3f          	cmp    r10d,0x3f
  93f7ab:	77 33                	ja     93f7e0 <check_input_intrinsic_initialize+0x460>
  93f7ad:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  93f7b4:	45 89 d1             	mov    r9d,r10d
  93f7b7:	c4 62 b0 f5 cf       	bzhi   r9,rdi,r9
  93f7bc:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  93f7bf:	75 64                	jne    93f825 <check_input_intrinsic_initialize+0x4a5>
  93f7c1:	4c 8b 59 20          	mov    r11,QWORD PTR [rcx+0x20]
  93f7c5:	c4 c1 fb 92 c9       	kmovq  k1,r9
  93f7ca:	62 91 75 49 74 14 03 	vpcmpeqb k2{k1},zmm1,ZMMWORD PTR [r11+r8*1]
  93f7d1:	eb 29                	jmp    93f7fc <check_input_intrinsic_initialize+0x47c>
  93f7d3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93f7da:	84 00 00 00 00 00 
  93f7e0:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  93f7e3:	49 c7 c1 ff ff ff ff 	mov    r9,0xffffffffffffffff
  93f7ea:	75 42                	jne    93f82e <check_input_intrinsic_initialize+0x4ae>
  93f7ec:	4c 8b 49 20          	mov    r9,QWORD PTR [rcx+0x20]
  93f7f0:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93f7f5:	62 91 75 48 74 14 01 	vpcmpeqb k2,zmm1,ZMMWORD PTR [r9+r8*1]
  93f7fc:	4c 8b 49 60          	mov    r9,QWORD PTR [rcx+0x60]
  93f800:	49 83 be d0 05 00 00 	cmp    QWORD PTR [r14+0x5d0],0x0
  93f807:	00 
  93f808:	62 91 7f c9 6f 04 01 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [r9+r8*1]
  93f80f:	62 f1 7d 4a 74 c1    	vpcmpeqb k0{k2},zmm0,zmm1
  93f815:	c4 e1 f4 41 c0       	kandq  k0,k1,k0
  93f81a:	c4 61 fb 93 c8       	kmovq  r9,k0
  93f81f:	0f 84 d9 00 00 00    	je     93f8fe <check_input_intrinsic_initialize+0x57e>
  93f825:	4d 85 c9             	test   r9,r9
  93f828:	0f 84 62 ff ff ff    	je     93f790 <check_input_intrinsic_initialize+0x410>
  93f82e:	4c 8b 51 20          	mov    r10,QWORD PTR [rcx+0x20]
  93f832:	eb 17                	jmp    93f84b <check_input_intrinsic_initialize+0x4cb>
  93f834:	89 fd                	mov    ebp,edi
  93f836:	41 01 dd             	add    r13d,ebx
  93f839:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  93f840:	c4 c2 b0 f3 c9       	blsr   r9,r9
  93f845:	0f 84 45 ff ff ff    	je     93f790 <check_input_intrinsic_initialize+0x410>
  93f84b:	45 31 f6             	xor    r14d,r14d
  93f84e:	f3 4d 0f bc f1       	tzcnt  r14,r9
  93f853:	4d 09 c6             	or     r14,r8
  93f856:	45 89 f3             	mov    r11d,r14d
  93f859:	43 80 3c 1a 02       	cmp    BYTE PTR [r10+r11*1],0x2
  93f85e:	75 e0                	jne    93f840 <check_input_intrinsic_initialize+0x4c0>
  93f860:	48 8b 59 60          	mov    rbx,QWORD PTR [rcx+0x60]
  93f864:	42 80 3c 1b 02       	cmp    BYTE PTR [rbx+r11*1],0x2
  93f869:	75 d5                	jne    93f840 <check_input_intrinsic_initialize+0x4c0>
  93f86b:	48 8b 1c 24          	mov    rbx,QWORD PTR [rsp]
  93f86f:	48 83 bb d0 05 00 00 	cmp    QWORD PTR [rbx+0x5d0],0x0
  93f876:	00 
  93f877:	74 75                	je     93f8ee <check_input_intrinsic_initialize+0x56e>
  93f879:	48 8b 5c 24 08       	mov    rbx,QWORD PTR [rsp+0x8]
  93f87e:	48 8b 5b 28          	mov    rbx,QWORD PTR [rbx+0x28]
  93f882:	42 8b 1c 9b          	mov    ebx,DWORD PTR [rbx+r11*4]
  93f886:	83 3c 9a fe          	cmp    DWORD PTR [rdx+rbx*4],0xfffffffe
  93f88a:	7f b4                	jg     93f840 <check_input_intrinsic_initialize+0x4c0>
  93f88c:	31 db                	xor    ebx,ebx
  93f88e:	44 39 f0             	cmp    eax,r14d
  93f891:	76 a3                	jbe    93f836 <check_input_intrinsic_initialize+0x4b6>
  93f893:	4c 8b 74 24 08       	mov    r14,QWORD PTR [rsp+0x8]
  93f898:	4d 8d 63 01          	lea    r12,[r11+0x1]
  93f89c:	4d 8b 76 70          	mov    r14,QWORD PTR [r14+0x70]
  93f8a0:	47 8b 3c 9e          	mov    r15d,DWORD PTR [r14+r11*4]
  93f8a4:	45 39 fc             	cmp    r12d,r15d
  93f8a7:	73 8d                	jae    93f836 <check_input_intrinsic_initialize+0x4b6>
  93f8a9:	41 39 c7             	cmp    r15d,eax
  93f8ac:	73 88                	jae    93f836 <check_input_intrinsic_initialize+0x4b6>
  93f8ae:	89 ef                	mov    edi,ebp
  93f8b0:	48 8b 6c 24 08       	mov    rbp,QWORD PTR [rsp+0x8]
  93f8b5:	48 8b 6d 60          	mov    rbp,QWORD PTR [rbp+0x60]
  93f8b9:	42 80 7c 1d 00 02    	cmp    BYTE PTR [rbp+r11*1+0x0],0x2
  93f8bf:	0f 85 6f ff ff ff    	jne    93f834 <check_input_intrinsic_initialize+0x4b4>
  93f8c5:	42 80 7c 25 00 23    	cmp    BYTE PTR [rbp+r12*1+0x0],0x23
  93f8cb:	0f 85 63 ff ff ff    	jne    93f834 <check_input_intrinsic_initialize+0x4b4>
  93f8d1:	42 80 7c 3d 00 3c    	cmp    BYTE PTR [rbp+r15*1+0x0],0x3c
  93f8d7:	89 fd                	mov    ebp,edi
  93f8d9:	0f 85 57 ff ff ff    	jne    93f836 <check_input_intrinsic_initialize+0x4b6>
  93f8df:	31 db                	xor    ebx,ebx
  93f8e1:	47 39 7c 9e 04       	cmp    DWORD PTR [r14+r11*4+0x4],r15d
  93f8e6:	0f 94 c3             	sete   bl
  93f8e9:	e9 48 ff ff ff       	jmp    93f836 <check_input_intrinsic_initialize+0x4b6>
  93f8ee:	42 80 3c 1e 00       	cmp    BYTE PTR [rsi+r11*1],0x0
  93f8f3:	0f 85 47 ff ff ff    	jne    93f840 <check_input_intrinsic_initialize+0x4c0>
  93f8f9:	e9 7b ff ff ff       	jmp    93f879 <check_input_intrinsic_initialize+0x4f9>
  93f8fe:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93f903:	41 83 fa 3f          	cmp    r10d,0x3f
  93f907:	77 14                	ja     93f91d <check_input_intrinsic_initialize+0x59d>
  93f909:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  93f910:	45 89 d2             	mov    r10d,r10d
  93f913:	c4 62 a8 f5 d7       	bzhi   r10,rdi,r10
  93f918:	c4 c1 fb 92 ca       	kmovq  k1,r10
  93f91d:	62 b1 7f c9 6f 04 06 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rsi+r8*1]
  93f924:	62 f2 7d 49 26 c0    	vptestmb k0{k1},zmm0,zmm0
  93f92a:	c4 e1 f8 44 c0       	knotq  k0,k0
  93f92f:	c4 61 fb 93 d0       	kmovq  r10,k0
  93f934:	4d 21 d1             	and    r9,r10
  93f937:	4d 85 c9             	test   r9,r9
  93f93a:	0f 85 ee fe ff ff    	jne    93f82e <check_input_intrinsic_initialize+0x4ae>
  93f940:	e9 4b fe ff ff       	jmp    93f790 <check_input_intrinsic_initialize+0x410>
  93f945:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
  93f949:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  93f94e:	48 8b 40 28          	mov    rax,QWORD PTR [rax+0x28]
  93f952:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
  93f956:	e9 dc 02 00 00       	jmp    93fc37 <check_input_intrinsic_initialize+0x8b7>
  93f95b:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  93f95f:	31 c0                	xor    eax,eax
  93f961:	45 31 ed             	xor    r13d,r13d
  93f964:	e9 42 01 00 00       	jmp    93faab <check_input_intrinsic_initialize+0x72b>
  93f969:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  93f970:	31 ff                	xor    edi,edi
  93f972:	eb 19                	jmp    93f98d <check_input_intrinsic_initialize+0x60d>
  93f974:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  93f97b:	00 00 00 00 00 
  93f980:	48 83 c7 40          	add    rdi,0x40
  93f984:	48 39 c7             	cmp    rdi,rax
  93f987:	0f 83 1b 01 00 00    	jae    93faa8 <check_input_intrinsic_initialize+0x728>
  93f98d:	41 89 e8             	mov    r8d,ebp
  93f990:	41 29 f8             	sub    r8d,edi
  93f993:	41 83 f8 40          	cmp    r8d,0x40
  93f997:	73 27                	jae    93f9c0 <check_input_intrinsic_initialize+0x640>
  93f999:	45 89 c0             	mov    r8d,r8d
  93f99c:	c4 62 b8 f5 c6       	bzhi   r8,rsi,r8
  93f9a1:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  93f9a4:	75 51                	jne    93f9f7 <check_input_intrinsic_initialize+0x677>
  93f9a6:	4c 8b 49 20          	mov    r9,QWORD PTR [rcx+0x20]
  93f9aa:	c4 c1 fb 92 c8       	kmovq  k1,r8
  93f9af:	62 d1 75 49 74 14 39 	vpcmpeqb k2{k1},zmm1,ZMMWORD PTR [r9+rdi*1]
  93f9b6:	eb 24                	jmp    93f9dc <check_input_intrinsic_initialize+0x65c>
  93f9b8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  93f9bf:	00 
  93f9c0:	80 39 00             	cmp    BYTE PTR [rcx],0x0
  93f9c3:	49 c7 c0 ff ff ff ff 	mov    r8,0xffffffffffffffff
  93f9ca:	75 30                	jne    93f9fc <check_input_intrinsic_initialize+0x67c>
  93f9cc:	4c 8b 41 20          	mov    r8,QWORD PTR [rcx+0x20]
  93f9d0:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  93f9d5:	62 d1 75 48 74 14 38 	vpcmpeqb k2,zmm1,ZMMWORD PTR [r8+rdi*1]
  93f9dc:	4c 8b 41 60          	mov    r8,QWORD PTR [rcx+0x60]
  93f9e0:	62 d1 7f c9 6f 04 38 	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [r8+rdi*1]
  93f9e7:	62 f1 7d 4a 74 c1    	vpcmpeqb k0{k2},zmm0,zmm1
  93f9ed:	c4 e1 f4 41 c0       	kandq  k0,k1,k0
  93f9f2:	c4 61 fb 93 c0       	kmovq  r8,k0
  93f9f7:	4d 85 c0             	test   r8,r8
  93f9fa:	74 84                	je     93f980 <check_input_intrinsic_initialize+0x600>
  93f9fc:	4c 8b 49 20          	mov    r9,QWORD PTR [rcx+0x20]
  93fa00:	eb 19                	jmp    93fa1b <check_input_intrinsic_initialize+0x69b>
  93fa02:	4c 8b 34 24          	mov    r14,QWORD PTR [rsp]
  93fa06:	45 01 d5             	add    r13d,r10d
  93fa09:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  93fa10:	c4 c2 b8 f3 c8       	blsr   r8,r8
  93fa15:	0f 84 65 ff ff ff    	je     93f980 <check_input_intrinsic_initialize+0x600>
  93fa1b:	31 db                	xor    ebx,ebx
  93fa1d:	f3 49 0f bc d8       	tzcnt  rbx,r8
  93fa22:	48 09 fb             	or     rbx,rdi
  93fa25:	41 89 db             	mov    r11d,ebx
  93fa28:	43 80 3c 19 02       	cmp    BYTE PTR [r9+r11*1],0x2
  93fa2d:	75 e1                	jne    93fa10 <check_input_intrinsic_initialize+0x690>
  93fa2f:	4c 8b 51 60          	mov    r10,QWORD PTR [rcx+0x60]
  93fa33:	43 80 3c 1a 02       	cmp    BYTE PTR [r10+r11*1],0x2
  93fa38:	75 d6                	jne    93fa10 <check_input_intrinsic_initialize+0x690>
  93fa3a:	4c 8b 54 24 08       	mov    r10,QWORD PTR [rsp+0x8]
  93fa3f:	4d 8b 52 28          	mov    r10,QWORD PTR [r10+0x28]
  93fa43:	47 8b 14 9a          	mov    r10d,DWORD PTR [r10+r11*4]
  93fa47:	42 83 3c 92 fe       	cmp    DWORD PTR [rdx+r10*4],0xfffffffe
  93fa4c:	7f c2                	jg     93fa10 <check_input_intrinsic_initialize+0x690>
  93fa4e:	45 31 d2             	xor    r10d,r10d
  93fa51:	39 d8                	cmp    eax,ebx
  93fa53:	76 ad                	jbe    93fa02 <check_input_intrinsic_initialize+0x682>
  93fa55:	48 8b 5c 24 08       	mov    rbx,QWORD PTR [rsp+0x8]
  93fa5a:	4d 8d 7b 01          	lea    r15,[r11+0x1]
  93fa5e:	48 8b 5b 70          	mov    rbx,QWORD PTR [rbx+0x70]
  93fa62:	46 8b 34 9b          	mov    r14d,DWORD PTR [rbx+r11*4]
  93fa66:	45 39 f7             	cmp    r15d,r14d
  93fa69:	73 97                	jae    93fa02 <check_input_intrinsic_initialize+0x682>
  93fa6b:	41 39 c6             	cmp    r14d,eax
  93fa6e:	73 92                	jae    93fa02 <check_input_intrinsic_initialize+0x682>
  93fa70:	4c 8b 64 24 08       	mov    r12,QWORD PTR [rsp+0x8]
  93fa75:	4d 8b 64 24 60       	mov    r12,QWORD PTR [r12+0x60]
  93fa7a:	43 80 3c 1c 02       	cmp    BYTE PTR [r12+r11*1],0x2
  93fa7f:	75 81                	jne    93fa02 <check_input_intrinsic_initialize+0x682>
  93fa81:	43 80 3c 3c 23       	cmp    BYTE PTR [r12+r15*1],0x23
  93fa86:	0f 85 76 ff ff ff    	jne    93fa02 <check_input_intrinsic_initialize+0x682>
  93fa8c:	43 80 3c 34 3c       	cmp    BYTE PTR [r12+r14*1],0x3c
  93fa91:	0f 85 6b ff ff ff    	jne    93fa02 <check_input_intrinsic_initialize+0x682>
  93fa97:	45 31 d2             	xor    r10d,r10d
  93fa9a:	46 39 74 9b 04       	cmp    DWORD PTR [rbx+r11*4+0x4],r14d
  93fa9f:	41 0f 94 c2          	sete   r10b
  93faa3:	e9 5a ff ff ff       	jmp    93fa02 <check_input_intrinsic_initialize+0x682>
  93faa8:	49 89 d0             	mov    r8,rdx
  93faab:	49 8b 4e 20          	mov    rcx,QWORD PTR [r14+0x20]
  93faaf:	48 8b 11             	mov    rdx,QWORD PTR [rcx]
  93fab2:	48 8b 71 08          	mov    rsi,QWORD PTR [rcx+0x8]
  93fab6:	48 8d 7c 16 3f       	lea    rdi,[rsi+rdx*1+0x3f]
  93fabb:	48 01 d6             	add    rsi,rdx
  93fabe:	48 83 e7 c0          	and    rdi,0xffffffffffffffc0
  93fac2:	48 39 f7             	cmp    rdi,rsi
  93fac5:	73 58                	jae    93fb1f <check_input_intrinsic_initialize+0x79f>
  93fac7:	45 31 f6             	xor    r14d,r14d
  93faca:	48 8d 46 07          	lea    rax,[rsi+0x7]
  93face:	48 83 e0 f8          	and    rax,0xfffffffffffffff8
  93fad2:	48 39 f0             	cmp    rax,rsi
  93fad5:	0f 82 a5 00 00 00    	jb     93fb80 <check_input_intrinsic_initialize+0x800>
  93fadb:	48 89 c6             	mov    rsi,rax
  93fade:	48 29 d6             	sub    rsi,rdx
  93fae1:	48 8b 51 10          	mov    rdx,QWORD PTR [rcx+0x10]
  93fae5:	31 db                	xor    ebx,ebx
  93fae7:	48 29 f2             	sub    rdx,rsi
  93faea:	72 29                	jb     93fb15 <check_input_intrinsic_initialize+0x795>
  93faec:	8b 7c 24 10          	mov    edi,DWORD PTR [rsp+0x10]
  93faf0:	48 69 ff 30 01 00 00 	imul   rdi,rdi,0x130
  93faf7:	48 39 d7             	cmp    rdi,rdx
  93fafa:	77 19                	ja     93fb15 <check_input_intrinsic_initialize+0x795>
  93fafc:	48 01 fe             	add    rsi,rdi
  93faff:	48 89 c3             	mov    rbx,rax
  93fb02:	48 89 71 08          	mov    QWORD PTR [rcx+0x8],rsi
  93fb06:	48 8b 51 20          	mov    rdx,QWORD PTR [rcx+0x20]
  93fb0a:	48 39 d6             	cmp    rsi,rdx
  93fb0d:	48 0f 46 f2          	cmovbe rsi,rdx
  93fb11:	48 89 71 20          	mov    QWORD PTR [rcx+0x20],rsi
  93fb15:	45 85 ed             	test   r13d,r13d
  93fb18:	75 6d                	jne    93fb87 <check_input_intrinsic_initialize+0x807>
  93fb1a:	e9 8c 00 00 00       	jmp    93fbab <check_input_intrinsic_initialize+0x82b>
  93fb1f:	4c 8b 49 10          	mov    r9,QWORD PTR [rcx+0x10]
  93fb23:	4d 89 c2             	mov    r10,r8
  93fb26:	49 89 f8             	mov    r8,rdi
  93fb29:	49 29 d0             	sub    r8,rdx
  93fb2c:	45 31 f6             	xor    r14d,r14d
  93fb2f:	4d 29 c1             	sub    r9,r8
  93fb32:	72 38                	jb     93fb6c <check_input_intrinsic_initialize+0x7ec>
  93fb34:	48 8d 04 85 04 00 00 	lea    rax,[rax*4+0x4]
  93fb3b:	00 
  93fb3c:	4c 39 c8             	cmp    rax,r9
  93fb3f:	77 2b                	ja     93fb6c <check_input_intrinsic_initialize+0x7ec>
  93fb41:	49 01 c0             	add    r8,rax
  93fb44:	49 89 fe             	mov    r14,rdi
  93fb47:	4c 89 41 08          	mov    QWORD PTR [rcx+0x8],r8
  93fb4b:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
  93fb4f:	49 39 c0             	cmp    r8,rax
  93fb52:	4c 0f 46 c0          	cmovbe r8,rax
  93fb56:	4c 89 41 20          	mov    QWORD PTR [rcx+0x20],r8
  93fb5a:	48 8b 0c 24          	mov    rcx,QWORD PTR [rsp]
  93fb5e:	48 8b 49 20          	mov    rcx,QWORD PTR [rcx+0x20]
  93fb62:	48 8b 11             	mov    rdx,QWORD PTR [rcx]
  93fb65:	48 8b 71 08          	mov    rsi,QWORD PTR [rcx+0x8]
  93fb69:	48 01 d6             	add    rsi,rdx
  93fb6c:	4d 89 d0             	mov    r8,r10
  93fb6f:	48 8d 46 07          	lea    rax,[rsi+0x7]
  93fb73:	48 83 e0 f8          	and    rax,0xfffffffffffffff8
  93fb77:	48 39 f0             	cmp    rax,rsi
  93fb7a:	0f 83 5b ff ff ff    	jae    93fadb <check_input_intrinsic_initialize+0x75b>
  93fb80:	31 db                	xor    ebx,ebx
  93fb82:	45 85 ed             	test   r13d,r13d
  93fb85:	74 24                	je     93fbab <check_input_intrinsic_initialize+0x82b>
  93fb87:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
  93fb8b:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
  93fb8f:	48 8b 30             	mov    rsi,QWORD PTR [rax]
  93fb92:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
  93fb96:	48 8d 4c 32 07       	lea    rcx,[rdx+rsi*1+0x7]
  93fb9b:	48 01 f2             	add    rdx,rsi
  93fb9e:	48 83 e1 f8          	and    rcx,0xfffffffffffffff8
  93fba2:	48 39 d1             	cmp    rcx,rdx
  93fba5:	0f 83 e4 00 00 00    	jae    93fc8f <check_input_intrinsic_initialize+0x90f>
  93fbab:	45 31 ff             	xor    r15d,r15d
  93fbae:	45 85 ed             	test   r13d,r13d
  93fbb1:	0f 94 c0             	sete   al
  93fbb4:	4d 85 ff             	test   r15,r15
  93fbb7:	0f 95 c1             	setne  cl
  93fbba:	4d 85 c0             	test   r8,r8
  93fbbd:	74 7c                	je     93fc3b <check_input_intrinsic_initialize+0x8bb>
  93fbbf:	4d 85 f6             	test   r14,r14
  93fbc2:	74 77                	je     93fc3b <check_input_intrinsic_initialize+0x8bb>
  93fbc4:	48 85 db             	test   rbx,rbx
  93fbc7:	74 72                	je     93fc3b <check_input_intrinsic_initialize+0x8bb>
  93fbc9:	08 c8                	or     al,cl
  93fbcb:	74 6e                	je     93fc3b <check_input_intrinsic_initialize+0x8bb>
  93fbcd:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  93fbd2:	4c 89 f7             	mov    rdi,r14
  93fbd5:	31 f6                	xor    esi,esi
  93fbd7:	4d 89 c4             	mov    r12,r8
  93fbda:	8b 40 40             	mov    eax,DWORD PTR [rax+0x40]
  93fbdd:	48 8d 14 85 04 00 00 	lea    rdx,[rax*4+0x4]
  93fbe4:	00 
  93fbe5:	c5 f8 77             	vzeroupper
  93fbe8:	e8 43 af fc ff       	call   90ab30 <memset@plt>
  93fbed:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
  93fbf1:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
  93fbf6:	8b 4c 24 10          	mov    ecx,DWORD PTR [rsp+0x10]
  93fbfa:	4c 89 a0 80 02 00 00 	mov    QWORD PTR [rax+0x280],r12
  93fc01:	4c 89 b2 c0 02 00 00 	mov    QWORD PTR [rdx+0x2c0],r14
  93fc08:	48 89 9a a0 02 00 00 	mov    QWORD PTR [rdx+0x2a0],rbx
  93fc0f:	c7 82 a8 02 00 00 00 	mov    DWORD PTR [rdx+0x2a8],0x0
  93fc16:	00 00 00 
  93fc19:	89 8a ac 02 00 00    	mov    DWORD PTR [rdx+0x2ac],ecx
  93fc1f:	4c 89 ba b0 02 00 00 	mov    QWORD PTR [rdx+0x2b0],r15
  93fc26:	c7 82 b8 02 00 00 00 	mov    DWORD PTR [rdx+0x2b8],0x0
  93fc2d:	00 00 00 
  93fc30:	44 89 aa bc 02 00 00 	mov    DWORD PTR [rdx+0x2bc],r13d
  93fc37:	b0 01                	mov    al,0x1
  93fc39:	eb 2c                	jmp    93fc67 <check_input_intrinsic_initialize+0x8e7>
  93fc3b:	48 8b 0c 24          	mov    rcx,QWORD PTR [rsp]
  93fc3f:	48 8b 54 24 30       	mov    rdx,QWORD PTR [rsp+0x30]
  93fc44:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
  93fc48:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  93fc4c:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
  93fc51:	48 8b 41 28          	mov    rax,QWORD PTR [rcx+0x28]
  93fc55:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  93fc59:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  93fc5e:	c6 80 9e 05 00 00 01 	mov    BYTE PTR [rax+0x59e],0x1
  93fc65:	31 c0                	xor    eax,eax
  93fc67:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  93fc6e:	00 00 
  93fc70:	48 3b 8c 24 e0 00 00 	cmp    rcx,QWORD PTR [rsp+0xe0]
  93fc77:	00 
  93fc78:	75 59                	jne    93fcd3 <check_input_intrinsic_initialize+0x953>
  93fc7a:	48 81 c4 e8 00 00 00 	add    rsp,0xe8
  93fc81:	5b                   	pop    rbx
  93fc82:	41 5c                	pop    r12
  93fc84:	41 5d                	pop    r13
  93fc86:	41 5e                	pop    r14
  93fc88:	41 5f                	pop    r15
  93fc8a:	5d                   	pop    rbp
  93fc8b:	c5 f8 77             	vzeroupper
  93fc8e:	c3                   	ret
  93fc8f:	48 8b 78 10          	mov    rdi,QWORD PTR [rax+0x10]
  93fc93:	48 89 ca             	mov    rdx,rcx
  93fc96:	48 29 f2             	sub    rdx,rsi
  93fc99:	45 31 ff             	xor    r15d,r15d
  93fc9c:	48 29 d7             	sub    rdi,rdx
  93fc9f:	0f 82 09 ff ff ff    	jb     93fbae <check_input_intrinsic_initialize+0x82e>
  93fca5:	44 89 ee             	mov    esi,r13d
  93fca8:	48 c1 e6 05          	shl    rsi,0x5
  93fcac:	48 39 fe             	cmp    rsi,rdi
  93fcaf:	0f 87 f9 fe ff ff    	ja     93fbae <check_input_intrinsic_initialize+0x82e>
  93fcb5:	48 01 f2             	add    rdx,rsi
  93fcb8:	49 89 cf             	mov    r15,rcx
  93fcbb:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  93fcbf:	48 8b 70 20          	mov    rsi,QWORD PTR [rax+0x20]
  93fcc3:	48 39 f2             	cmp    rdx,rsi
  93fcc6:	48 0f 46 d6          	cmovbe rdx,rsi
  93fcca:	48 89 50 20          	mov    QWORD PTR [rax+0x20],rdx
  93fcce:	e9 db fe ff ff       	jmp    93fbae <check_input_intrinsic_initialize+0x82e>
  93fcd3:	c5 f8 77             	vzeroupper
  93fcd6:	e8 15 a5 fc ff       	call   90a1f0 <__stack_chk_fail@plt>
