
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

000000000184c590 <builtin_intrinsic_filter_candidates>:
 184c590:	55                   	push   rbp
 184c591:	41 56                	push   r14
 184c593:	53                   	push   rbx
 184c594:	48 83 ec 50          	sub    rsp,0x50
 184c598:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
 184c59f:	00 00 
 184c5a1:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
 184c5a5:	41 89 f0             	mov    r8d,esi
 184c5a8:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
 184c5ad:	c5 fe 7f 44 24 20    	vmovdqu YMMWORD PTR [rsp+0x20],ymm0
 184c5b3:	c5 fe 7f 04 24       	vmovdqu YMMWORD PTR [rsp],ymm0
 184c5b8:	85 f6                	test   esi,esi
 184c5ba:	74 0e                	je     184c5ca <builtin_intrinsic_filter_candidates+0x3a>
 184c5bc:	83 fe 01             	cmp    esi,0x1
 184c5bf:	75 1d                	jne    184c5de <builtin_intrinsic_filter_candidates+0x4e>
 184c5c1:	31 c0                	xor    eax,eax
 184c5c3:	31 c9                	xor    ecx,ecx
 184c5c5:	e9 4e 01 00 00       	jmp    184c718 <builtin_intrinsic_filter_candidates+0x188>
 184c5ca:	b8 00 00 00 00       	mov    eax,0x0
 184c5cf:	31 c9                	xor    ecx,ecx
 184c5d1:	84 d2                	test   dl,dl
 184c5d3:	0f 84 d6 01 00 00    	je     184c7af <builtin_intrinsic_filter_candidates+0x21f>
 184c5d9:	e9 de 04 00 00       	jmp    184cabc <builtin_intrinsic_filter_candidates+0x52c>
 184c5de:	c5 fd 6f 05 3a 6a da 	vmovdqa ymm0,YMMWORD PTR [rip+0xfffffffffeda6a3a]        # 5f3020 <check_x86_lower_condition.sets+0x7e0>
 184c5e5:	fe 
 184c5e6:	c4 e2 79 21 0d 91 c5 	vpmovsxbd xmm1,DWORD PTR [rip+0xfffffffffeddc591]        # 628b80 <executable_lay_out.first_sections+0x3bc>
 184c5ed:	dd fe 
 184c5ef:	45 89 c1             	mov    r9d,r8d
 184c5f2:	41 83 e1 fe          	and    r9d,0xfffffffe
 184c5f6:	4c 8d 57 18          	lea    r10,[rdi+0x18]
 184c5fa:	31 c0                	xor    eax,eax
 184c5fc:	31 c9                	xor    ecx,ecx
 184c5fe:	eb 36                	jmp    184c636 <builtin_intrinsic_filter_candidates+0xa6>
 184c600:	8b 2b                	mov    ebp,DWORD PTR [rbx]
 184c602:	42 8b 5c 1b fc       	mov    ebx,DWORD PTR [rbx+r11*1-0x4]
 184c607:	45 69 db b9 79 37 9e 	imul   r11d,r11d,0x9e3779b9
 184c60e:	c4 e3 7b f0 db 13    	rorx   ebx,ebx,0x13
 184c614:	41 31 eb             	xor    r11d,ebp
 184c617:	41 31 db             	xor    r11d,ebx
 184c61a:	8d 58 01             	lea    ebx,[rax+0x1]
 184c61d:	0f ab d9             	bts    ecx,ebx
 184c620:	44 89 5c 84 24       	mov    DWORD PTR [rsp+rax*4+0x24],r11d
 184c625:	48 83 c0 02          	add    rax,0x2
 184c629:	49 83 c2 20          	add    r10,0x20
 184c62d:	49 39 c1             	cmp    r9,rax
 184c630:	0f 84 d8 00 00 00    	je     184c70e <builtin_intrinsic_filter_candidates+0x17e>
 184c636:	49 8b 5a e8          	mov    rbx,QWORD PTR [r10-0x18]
 184c63a:	48 85 db             	test   rbx,rbx
 184c63d:	74 6d                	je     184c6ac <builtin_intrinsic_filter_candidates+0x11c>
 184c63f:	45 8b 5a f0          	mov    r11d,DWORD PTR [r10-0x10]
 184c643:	4d 85 db             	test   r11,r11
 184c646:	74 64                	je     184c6ac <builtin_intrinsic_filter_candidates+0x11c>
 184c648:	41 83 fb 03          	cmp    r11d,0x3
 184c64c:	76 09                	jbe    184c657 <builtin_intrinsic_filter_candidates+0xc7>
 184c64e:	8b 2b                	mov    ebp,DWORD PTR [rbx]
 184c650:	42 8b 5c 1b fc       	mov    ebx,DWORD PTR [rbx+r11*1-0x4]
 184c655:	eb 3a                	jmp    184c691 <builtin_intrinsic_filter_candidates+0x101>
 184c657:	4d 8d 73 ff          	lea    r14,[r11-0x1]
 184c65b:	62 d2 fd 28 7c d6    	vpbroadcastq ymm2,r14
 184c661:	62 f3 ed 28 1e c8 05 	vpcmpnltuq k1,ymm2,ymm0
 184c668:	62 f1 7f 89 6f 13    	vmovdqu8 xmm2{k1}{z},XMMWORD PTR [rbx]
 184c66e:	c4 e2 79 31 d2       	vpmovzxbd xmm2,xmm2
 184c673:	62 f2 6d 89 47 d1    	vpsllvd xmm2{k1}{z},xmm2,xmm1
 184c679:	c5 f9 70 da ee       	vpshufd xmm3,xmm2,0xee
 184c67e:	c5 e9 eb d3          	vpor   xmm2,xmm2,xmm3
 184c682:	c5 f9 70 da 55       	vpshufd xmm3,xmm2,0x55
 184c687:	c5 e9 eb d3          	vpor   xmm2,xmm2,xmm3
 184c68b:	c5 f9 7e d3          	vmovd  ebx,xmm2
 184c68f:	89 dd                	mov    ebp,ebx
 184c691:	45 69 db b9 79 37 9e 	imul   r11d,r11d,0x9e3779b9
 184c698:	0f ab c1             	bts    ecx,eax
 184c69b:	c4 e3 7b f0 db 13    	rorx   ebx,ebx,0x13
 184c6a1:	41 31 eb             	xor    r11d,ebp
 184c6a4:	41 31 db             	xor    r11d,ebx
 184c6a7:	44 89 5c 84 20       	mov    DWORD PTR [rsp+rax*4+0x20],r11d
 184c6ac:	49 8b 5a f8          	mov    rbx,QWORD PTR [r10-0x8]
 184c6b0:	48 85 db             	test   rbx,rbx
 184c6b3:	0f 84 6c ff ff ff    	je     184c625 <builtin_intrinsic_filter_candidates+0x95>
 184c6b9:	45 8b 1a             	mov    r11d,DWORD PTR [r10]
 184c6bc:	4d 85 db             	test   r11,r11
 184c6bf:	0f 84 60 ff ff ff    	je     184c625 <builtin_intrinsic_filter_candidates+0x95>
 184c6c5:	41 83 fb 03          	cmp    r11d,0x3
 184c6c9:	0f 87 31 ff ff ff    	ja     184c600 <builtin_intrinsic_filter_candidates+0x70>
 184c6cf:	4d 8d 73 ff          	lea    r14,[r11-0x1]
 184c6d3:	62 d2 fd 28 7c d6    	vpbroadcastq ymm2,r14
 184c6d9:	62 f3 ed 28 1e c8 05 	vpcmpnltuq k1,ymm2,ymm0
 184c6e0:	62 f1 7f 89 6f 13    	vmovdqu8 xmm2{k1}{z},XMMWORD PTR [rbx]
 184c6e6:	c4 e2 79 31 d2       	vpmovzxbd xmm2,xmm2
 184c6eb:	62 f2 6d 89 47 d1    	vpsllvd xmm2{k1}{z},xmm2,xmm1
 184c6f1:	c5 f9 70 da ee       	vpshufd xmm3,xmm2,0xee
 184c6f6:	c5 e9 eb d3          	vpor   xmm2,xmm2,xmm3
 184c6fa:	c5 f9 70 da 55       	vpshufd xmm3,xmm2,0x55
 184c6ff:	c5 e9 eb d3          	vpor   xmm2,xmm2,xmm3
 184c703:	c5 f9 7e d3          	vmovd  ebx,xmm2
 184c707:	89 dd                	mov    ebp,ebx
 184c709:	e9 f9 fe ff ff       	jmp    184c607 <builtin_intrinsic_filter_candidates+0x77>
 184c70e:	41 f6 c0 01          	test   r8b,0x1
 184c712:	0f 84 87 00 00 00    	je     184c79f <builtin_intrinsic_filter_candidates+0x20f>
 184c718:	49 89 c2             	mov    r10,rax
 184c71b:	49 c1 e2 04          	shl    r10,0x4
 184c71f:	4e 8b 0c 17          	mov    r9,QWORD PTR [rdi+r10*1]
 184c723:	4d 85 c9             	test   r9,r9
 184c726:	74 77                	je     184c79f <builtin_intrinsic_filter_candidates+0x20f>
 184c728:	4c 01 d7             	add    rdi,r10
 184c72b:	8b 7f 08             	mov    edi,DWORD PTR [rdi+0x8]
 184c72e:	48 85 ff             	test   rdi,rdi
 184c731:	74 6c                	je     184c79f <builtin_intrinsic_filter_candidates+0x20f>
 184c733:	83 ff 03             	cmp    edi,0x3
 184c736:	76 0a                	jbe    184c742 <builtin_intrinsic_filter_candidates+0x1b2>
 184c738:	45 8b 11             	mov    r10d,DWORD PTR [r9]
 184c73b:	45 8b 4c 39 fc       	mov    r9d,DWORD PTR [r9+rdi*1-0x4]
 184c740:	eb 44                	jmp    184c786 <builtin_intrinsic_filter_candidates+0x1f6>
 184c742:	4c 8d 57 ff          	lea    r10,[rdi-0x1]
 184c746:	62 d2 fd 28 7c c2    	vpbroadcastq ymm0,r10
 184c74c:	62 f3 fd 28 1e 0d c9 	vpcmpnltuq k1,ymm0,YMMWORD PTR [rip+0xfffffffffeda68c9]        # 5f3020 <check_x86_lower_condition.sets+0x7e0>
 184c753:	68 da fe 05 
 184c757:	62 d1 7f 89 6f 01    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r9]
 184c75d:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
 184c762:	62 f2 7d 89 47 05 24 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xfffffffffedbe324]        # 60aa90 <tier0_program_class_type.types+0x5c0>
 184c769:	e3 db fe 
 184c76c:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
 184c771:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
 184c775:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
 184c77a:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
 184c77e:	c4 c1 79 7e c1       	vmovd  r9d,xmm0
 184c783:	45 89 ca             	mov    r10d,r9d
 184c786:	69 ff b9 79 37 9e    	imul   edi,edi,0x9e3779b9
 184c78c:	0f ab c1             	bts    ecx,eax
 184c78f:	c4 43 7b f0 c9 13    	rorx   r9d,r9d,0x13
 184c795:	44 31 d7             	xor    edi,r10d
 184c798:	44 31 cf             	xor    edi,r9d
 184c79b:	89 7c 84 20          	mov    DWORD PTR [rsp+rax*4+0x20],edi
 184c79f:	84 d2                	test   dl,dl
 184c7a1:	74 0c                	je     184c7af <builtin_intrinsic_filter_candidates+0x21f>
 184c7a3:	83 fe 08             	cmp    esi,0x8
 184c7a6:	73 47                	jae    184c7ef <builtin_intrinsic_filter_candidates+0x25f>
 184c7a8:	31 c0                	xor    eax,eax
 184c7aa:	e9 d1 01 00 00       	jmp    184c980 <builtin_intrinsic_filter_candidates+0x3f0>
 184c7af:	c5 fe 6f 44 24 20    	vmovdqu ymm0,YMMWORD PTR [rsp+0x20]
 184c7b5:	c5 f5 72 d0 10       	vpsrld ymm1,ymm0,0x10
 184c7ba:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
 184c7be:	62 f2 7d 38 40 05 b0 	vpmulld ymm0,ymm0,DWORD BCST [rip+0xfffffffffeddc3b0]        # 628b78 <executable_lay_out.first_sections+0x3b4>
 184c7c5:	c3 dd fe 
 184c7c8:	c5 f5 72 d0 0f       	vpsrld ymm1,ymm0,0xf
 184c7cd:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
 184c7d1:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
 184c7d5:	c4 e3 7d 0e c1 aa    	vpblendw ymm0,ymm0,ymm1,0xaa
 184c7db:	c5 fe 7f 04 24       	vmovdqu YMMWORD PTR [rsp],ymm0
 184c7e0:	85 f6                	test   esi,esi
 184c7e2:	0f 85 be 01 00 00    	jne    184c9a6 <builtin_intrinsic_filter_candidates+0x416>
 184c7e8:	31 c0                	xor    eax,eax
 184c7ea:	e9 cd 02 00 00       	jmp    184cabc <builtin_intrinsic_filter_candidates+0x52c>
 184c7ef:	83 fe 40             	cmp    esi,0x40
 184c7f2:	73 07                	jae    184c7fb <builtin_intrinsic_filter_candidates+0x26b>
 184c7f4:	31 c0                	xor    eax,eax
 184c7f6:	e9 23 01 00 00       	jmp    184c91e <builtin_intrinsic_filter_candidates+0x38e>
 184c7fb:	62 f2 7d 48 58 05 73 	vpbroadcastd zmm0,DWORD PTR [rip+0xfffffffffeddc373]        # 628b78 <executable_lay_out.first_sections+0x3b4>
 184c802:	c3 dd fe 
 184c805:	62 f2 7d 48 58 0d 6d 	vpbroadcastd zmm1,DWORD PTR [rip+0xfffffffffeddc36d]        # 628b7c <executable_lay_out.first_sections+0x3b8>
 184c80c:	c3 dd fe 
 184c80f:	44 89 c2             	mov    edx,r8d
 184c812:	c1 ea 06             	shr    edx,0x6
 184c815:	44 89 c0             	mov    eax,r8d
 184c818:	83 e0 c0             	and    eax,0xffffffc0
 184c81b:	31 ff                	xor    edi,edi
 184c81d:	48 c1 e2 08          	shl    rdx,0x8
 184c821:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
 184c828:	0f 1f 84 00 00 00 00 
 184c82f:	00 
 184c830:	62 f1 fe 48 6f 94 3c 	vmovdqu64 zmm2,ZMMWORD PTR [rsp+rdi*1+0x20]
 184c837:	20 00 00 00 
 184c83b:	62 f1 fe 48 6f 9c 3c 	vmovdqu64 zmm3,ZMMWORD PTR [rsp+rdi*1+0x60]
 184c842:	60 00 00 00 
 184c846:	62 f1 fe 48 6f a4 3c 	vmovdqu64 zmm4,ZMMWORD PTR [rsp+rdi*1+0xa0]
 184c84d:	a0 00 00 00 
 184c851:	62 f1 fe 48 6f ac 3c 	vmovdqu64 zmm5,ZMMWORD PTR [rsp+rdi*1+0xe0]
 184c858:	e0 00 00 00 
 184c85c:	62 f1 4d 48 72 d2 10 	vpsrld zmm6,zmm2,0x10
 184c863:	62 f1 45 48 72 d3 10 	vpsrld zmm7,zmm3,0x10
 184c86a:	62 f1 3d 48 72 d4 10 	vpsrld zmm8,zmm4,0x10
 184c871:	62 f1 35 48 72 d5 10 	vpsrld zmm9,zmm5,0x10
 184c878:	62 f1 4d 48 ef d2    	vpxord zmm2,zmm6,zmm2
 184c87e:	62 f1 45 48 ef db    	vpxord zmm3,zmm7,zmm3
 184c884:	62 f1 3d 48 ef e4    	vpxord zmm4,zmm8,zmm4
 184c88a:	62 f1 35 48 ef ed    	vpxord zmm5,zmm9,zmm5
 184c890:	62 f2 6d 48 40 d0    	vpmulld zmm2,zmm2,zmm0
 184c896:	62 f2 65 48 40 d8    	vpmulld zmm3,zmm3,zmm0
 184c89c:	62 f2 5d 48 40 e0    	vpmulld zmm4,zmm4,zmm0
 184c8a2:	62 f2 55 48 40 e8    	vpmulld zmm5,zmm5,zmm0
 184c8a8:	62 f1 4d 48 72 d2 0f 	vpsrld zmm6,zmm2,0xf
 184c8af:	62 f1 45 48 72 d3 0f 	vpsrld zmm7,zmm3,0xf
 184c8b6:	62 f1 3d 48 72 d4 0f 	vpsrld zmm8,zmm4,0xf
 184c8bd:	62 f1 35 48 72 d5 0f 	vpsrld zmm9,zmm5,0xf
 184c8c4:	62 f3 f5 48 25 f2 48 	vpternlogq zmm6,zmm1,zmm2,0x48
 184c8cb:	62 f3 f5 48 25 fb 48 	vpternlogq zmm7,zmm1,zmm3,0x48
 184c8d2:	62 73 f5 48 25 c4 48 	vpternlogq zmm8,zmm1,zmm4,0x48
 184c8d9:	62 73 f5 48 25 cd 48 	vpternlogq zmm9,zmm1,zmm5,0x48
 184c8e0:	62 f1 fe 48 7f 34 3c 	vmovdqu64 ZMMWORD PTR [rsp+rdi*1],zmm6
 184c8e7:	62 f1 fe 48 7f 7c 3c 	vmovdqu64 ZMMWORD PTR [rsp+rdi*1+0x40],zmm7
 184c8ee:	01 
 184c8ef:	62 71 fe 48 7f 44 3c 	vmovdqu64 ZMMWORD PTR [rsp+rdi*1+0x80],zmm8
 184c8f6:	02 
 184c8f7:	62 71 fe 48 7f 4c 3c 	vmovdqu64 ZMMWORD PTR [rsp+rdi*1+0xc0],zmm9
 184c8fe:	03 
 184c8ff:	48 81 c7 00 01 00 00 	add    rdi,0x100
 184c906:	48 39 fa             	cmp    rdx,rdi
 184c909:	0f 85 21 ff ff ff    	jne    184c830 <builtin_intrinsic_filter_candidates+0x2a0>
 184c90f:	44 39 c0             	cmp    eax,r8d
 184c912:	0f 84 8e 00 00 00    	je     184c9a6 <builtin_intrinsic_filter_candidates+0x416>
 184c918:	41 f6 c0 38          	test   r8b,0x38
 184c91c:	74 62                	je     184c980 <builtin_intrinsic_filter_candidates+0x3f0>
 184c91e:	c4 e2 7d 58 05 51 c2 	vpbroadcastd ymm0,DWORD PTR [rip+0xfffffffffeddc251]        # 628b78 <executable_lay_out.first_sections+0x3b4>
 184c925:	dd fe 
 184c927:	48 89 c2             	mov    rdx,rax
 184c92a:	44 89 c0             	mov    eax,r8d
 184c92d:	83 e0 f8             	and    eax,0xfffffff8
 184c930:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
 184c934:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
 184c93b:	00 00 00 00 00 
 184c940:	c5 fe 6f 54 94 20    	vmovdqu ymm2,YMMWORD PTR [rsp+rdx*4+0x20]
 184c946:	c5 e5 72 d2 10       	vpsrld ymm3,ymm2,0x10
 184c94b:	c5 e5 ef d2          	vpxor  ymm2,ymm3,ymm2
 184c94f:	c4 e2 6d 40 d0       	vpmulld ymm2,ymm2,ymm0
 184c954:	c5 e5 72 d2 0f       	vpsrld ymm3,ymm2,0xf
 184c959:	c5 e5 ef d2          	vpxor  ymm2,ymm3,ymm2
 184c95d:	c4 e3 6d 0e d1 aa    	vpblendw ymm2,ymm2,ymm1,0xaa
 184c963:	c5 fe 7f 14 94       	vmovdqu YMMWORD PTR [rsp+rdx*4],ymm2
 184c968:	48 83 c2 08          	add    rdx,0x8
 184c96c:	48 39 d0             	cmp    rax,rdx
 184c96f:	75 cf                	jne    184c940 <builtin_intrinsic_filter_candidates+0x3b0>
 184c971:	44 39 c0             	cmp    eax,r8d
 184c974:	74 30                	je     184c9a6 <builtin_intrinsic_filter_candidates+0x416>
 184c976:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
 184c97d:	00 00 00 
 184c980:	8b 54 84 20          	mov    edx,DWORD PTR [rsp+rax*4+0x20]
 184c984:	89 d7                	mov    edi,edx
 184c986:	c1 ef 10             	shr    edi,0x10
 184c989:	31 d7                	xor    edi,edx
 184c98b:	69 d7 2d 35 eb 7f    	imul   edx,edi,0x7feb352d
 184c991:	89 d7                	mov    edi,edx
 184c993:	c1 ef 0f             	shr    edi,0xf
 184c996:	31 d7                	xor    edi,edx
 184c998:	0f b7 d7             	movzx  edx,di
 184c99b:	89 14 84             	mov    DWORD PTR [rsp+rax*4],edx
 184c99e:	48 ff c0             	inc    rax
 184c9a1:	49 39 c0             	cmp    r8,rax
 184c9a4:	75 da                	jne    184c980 <builtin_intrinsic_filter_candidates+0x3f0>
 184c9a6:	44 89 c2             	mov    edx,r8d
 184c9a9:	83 e2 03             	and    edx,0x3
 184c9ac:	ff ce                	dec    esi
 184c9ae:	83 fe 03             	cmp    esi,0x3
 184c9b1:	73 09                	jae    184c9bc <builtin_intrinsic_filter_candidates+0x42c>
 184c9b3:	31 f6                	xor    esi,esi
 184c9b5:	31 c0                	xor    eax,eax
 184c9b7:	e9 c9 00 00 00       	jmp    184ca85 <builtin_intrinsic_filter_candidates+0x4f5>
 184c9bc:	41 83 e0 fc          	and    r8d,0xfffffffc
 184c9c0:	48 8d 3d 29 b4 ca fe 	lea    rdi,[rip+0xfffffffffecab429]        # 4f7df0 <builtin_intrinsic_filter_bits>
 184c9c7:	31 f6                	xor    esi,esi
 184c9c9:	31 c0                	xor    eax,eax
 184c9cb:	eb 10                	jmp    184c9dd <builtin_intrinsic_filter_candidates+0x44d>
 184c9cd:	0f 1f 00             	nop    DWORD PTR [rax]
 184c9d0:	48 83 c6 04          	add    rsi,0x4
 184c9d4:	49 39 f0             	cmp    r8,rsi
 184c9d7:	0f 84 a3 00 00 00    	je     184ca80 <builtin_intrinsic_filter_candidates+0x4f0>
 184c9dd:	0f a3 f1             	bt     ecx,esi
 184c9e0:	73 1d                	jae    184c9ff <builtin_intrinsic_filter_candidates+0x46f>
 184c9e2:	44 8b 0c b4          	mov    r9d,DWORD PTR [rsp+rsi*4]
 184c9e6:	45 89 ca             	mov    r10d,r9d
 184c9e9:	41 c1 ea 06          	shr    r10d,0x6
 184c9ed:	c4 22 b3 f7 0c d7    	shrx   r9,QWORD PTR [rdi+r10*8],r9
 184c9f3:	41 83 e1 01          	and    r9d,0x1
 184c9f7:	c4 42 49 f7 c9       	shlx   r9d,r9d,esi
 184c9fc:	44 09 c8             	or     eax,r9d
 184c9ff:	4c 8d 4e 01          	lea    r9,[rsi+0x1]
 184ca03:	44 0f a3 c9          	bt     ecx,r9d
 184ca07:	73 1e                	jae    184ca27 <builtin_intrinsic_filter_candidates+0x497>
 184ca09:	44 8b 54 b4 04       	mov    r10d,DWORD PTR [rsp+rsi*4+0x4]
 184ca0e:	45 89 d3             	mov    r11d,r10d
 184ca11:	41 c1 eb 06          	shr    r11d,0x6
 184ca15:	c4 22 ab f7 14 df    	shrx   r10,QWORD PTR [rdi+r11*8],r10
 184ca1b:	41 83 e2 01          	and    r10d,0x1
 184ca1f:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
 184ca24:	44 09 c8             	or     eax,r9d
 184ca27:	4c 8d 4e 02          	lea    r9,[rsi+0x2]
 184ca2b:	44 0f a3 c9          	bt     ecx,r9d
 184ca2f:	73 1e                	jae    184ca4f <builtin_intrinsic_filter_candidates+0x4bf>
 184ca31:	44 8b 54 b4 08       	mov    r10d,DWORD PTR [rsp+rsi*4+0x8]
 184ca36:	45 89 d3             	mov    r11d,r10d
 184ca39:	41 c1 eb 06          	shr    r11d,0x6
 184ca3d:	c4 22 ab f7 14 df    	shrx   r10,QWORD PTR [rdi+r11*8],r10
 184ca43:	41 83 e2 01          	and    r10d,0x1
 184ca47:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
 184ca4c:	44 09 c8             	or     eax,r9d
 184ca4f:	4c 8d 4e 03          	lea    r9,[rsi+0x3]
 184ca53:	44 0f a3 c9          	bt     ecx,r9d
 184ca57:	0f 83 73 ff ff ff    	jae    184c9d0 <builtin_intrinsic_filter_candidates+0x440>
 184ca5d:	44 8b 54 b4 0c       	mov    r10d,DWORD PTR [rsp+rsi*4+0xc]
 184ca62:	45 89 d3             	mov    r11d,r10d
 184ca65:	41 c1 eb 06          	shr    r11d,0x6
 184ca69:	c4 22 ab f7 14 df    	shrx   r10,QWORD PTR [rdi+r11*8],r10
 184ca6f:	41 83 e2 01          	and    r10d,0x1
 184ca73:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
 184ca78:	44 09 c8             	or     eax,r9d
 184ca7b:	e9 50 ff ff ff       	jmp    184c9d0 <builtin_intrinsic_filter_candidates+0x440>
 184ca80:	48 85 d2             	test   rdx,rdx
 184ca83:	74 37                	je     184cabc <builtin_intrinsic_filter_candidates+0x52c>
 184ca85:	48 8d 3d 64 b3 ca fe 	lea    rdi,[rip+0xfffffffffecab364]        # 4f7df0 <builtin_intrinsic_filter_bits>
 184ca8c:	eb 0a                	jmp    184ca98 <builtin_intrinsic_filter_candidates+0x508>
 184ca8e:	66 90                	xchg   ax,ax
 184ca90:	48 ff c6             	inc    rsi
 184ca93:	48 ff ca             	dec    rdx
 184ca96:	74 24                	je     184cabc <builtin_intrinsic_filter_candidates+0x52c>
 184ca98:	0f a3 f1             	bt     ecx,esi
 184ca9b:	73 f3                	jae    184ca90 <builtin_intrinsic_filter_candidates+0x500>
 184ca9d:	44 8b 04 b4          	mov    r8d,DWORD PTR [rsp+rsi*4]
 184caa1:	45 89 c1             	mov    r9d,r8d
 184caa4:	41 c1 e9 06          	shr    r9d,0x6
 184caa8:	c4 22 bb f7 04 cf    	shrx   r8,QWORD PTR [rdi+r9*8],r8
 184caae:	41 83 e0 01          	and    r8d,0x1
 184cab2:	c4 42 49 f7 c0       	shlx   r8d,r8d,esi
 184cab7:	44 09 c0             	or     eax,r8d
 184caba:	eb d4                	jmp    184ca90 <builtin_intrinsic_filter_candidates+0x500>
 184cabc:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
 184cac3:	00 00 
 184cac5:	48 3b 4c 24 48       	cmp    rcx,QWORD PTR [rsp+0x48]
 184caca:	75 0c                	jne    184cad8 <builtin_intrinsic_filter_candidates+0x548>
 184cacc:	48 83 c4 50          	add    rsp,0x50
 184cad0:	5b                   	pop    rbx
 184cad1:	41 5e                	pop    r14
 184cad3:	5d                   	pop    rbp
 184cad4:	c5 f8 77             	vzeroupper
 184cad7:	c3                   	ret
 184cad8:	c5 f8 77             	vzeroupper
 184cadb:	e8 b0 09 0b ff       	call   8fd490 <__stack_chk_fail@plt>
