
issue-451-68e113ee/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000966480 <tokenize_c_counted_raw_no_separators>:
  966480:	55                   	push   rbp
  966481:	48 89 e5             	mov    rbp,rsp
  966484:	41 57                	push   r15
  966486:	41 56                	push   r14
  966488:	41 55                	push   r13
  96648a:	41 54                	push   r12
  96648c:	53                   	push   rbx
  96648d:	48 83 e4 c0          	and    rsp,0xffffffffffffffc0
  966491:	48 81 ec 80 2c 00 00 	sub    rsp,0x2c80
  966498:	62 f2 7d 48 5a 05 be 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffac53be]        # 42b860 <c_testsuite_feature.marker+0x135c>
  96649f:	53 ac ff 
  9664a2:	62 f2 7d 48 5a 0d c4 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffac53c4]        # 42b870 <c_testsuite_feature.marker+0x136c>
  9664a9:	53 ac ff 
  9664ac:	62 f2 7d 48 5a 3d ca 	vbroadcasti32x4 zmm7,XMMWORD PTR [rip+0xffffffffffac53ca]        # 42b880 <c_testsuite_feature.marker+0x137c>
  9664b3:	53 ac ff 
  9664b6:	62 72 7d 48 5a 05 d0 	vbroadcasti32x4 zmm8,XMMWORD PTR [rip+0xffffffffffac53d0]        # 42b890 <c_testsuite_feature.marker+0x138c>
  9664bd:	53 ac ff 
  9664c0:	48 89 8c 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],rcx
  9664c7:	00 
  9664c8:	48 c7 c1 ff ff ff ff 	mov    rcx,0xffffffffffffffff
  9664cf:	4d 89 c2             	mov    r10,r8
  9664d2:	49 89 f6             	mov    r14,rsi
  9664d5:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  9664dc:	00 00 
  9664de:	48 89 84 24 40 2c 00 	mov    QWORD PTR [rsp+0x2c40],rax
  9664e5:	00 
  9664e6:	b8 40 00 00 00       	mov    eax,0x40
  9664eb:	48 89 54 24 30       	mov    QWORD PTR [rsp+0x30],rdx
  9664f0:	4c 39 f2             	cmp    rdx,r14
  9664f3:	0f 83 7c 01 00 00    	jae    966675 <tokenize_c_counted_raw_no_separators+0x1f5>
  9664f9:	48 8b 54 24 30       	mov    rdx,QWORD PTR [rsp+0x30]
  9664fe:	eb 08                	jmp    966508 <tokenize_c_counted_raw_no_separators+0x88>
  966500:	48 ff c2             	inc    rdx
  966503:	49 39 d6             	cmp    r14,rdx
  966506:	74 28                	je     966530 <tokenize_c_counted_raw_no_separators+0xb0>
  966508:	0f b6 34 17          	movzx  esi,BYTE PTR [rdi+rdx*1]
  96650c:	44 8d 46 f7          	lea    r8d,[rsi-0x9]
  966510:	41 83 f8 05          	cmp    r8d,0x5
  966514:	72 ea                	jb     966500 <tokenize_c_counted_raw_no_separators+0x80>
  966516:	83 fe 20             	cmp    esi,0x20
  966519:	74 e5                	je     966500 <tokenize_c_counted_raw_no_separators+0x80>
  96651b:	85 f6                	test   esi,esi
  96651d:	74 e1                	je     966500 <tokenize_c_counted_raw_no_separators+0x80>
  96651f:	eb 12                	jmp    966533 <tokenize_c_counted_raw_no_separators+0xb3>
  966521:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  966528:	0f 1f 84 00 00 00 00 
  96652f:	00 
  966530:	4c 89 f2             	mov    rdx,r14
  966533:	48 8d 72 01          	lea    rsi,[rdx+0x1]
  966537:	4c 39 f6             	cmp    rsi,r14
  96653a:	0f 83 35 01 00 00    	jae    966675 <tokenize_c_counted_raw_no_separators+0x1f5>
  966540:	80 3c 17 2f          	cmp    BYTE PTR [rdi+rdx*1],0x2f
  966544:	0f 85 2b 01 00 00    	jne    966675 <tokenize_c_counted_raw_no_separators+0x1f5>
  96654a:	0f b6 34 37          	movzx  esi,BYTE PTR [rdi+rsi*1]
  96654e:	83 fe 2f             	cmp    esi,0x2f
  966551:	74 09                	je     96655c <tokenize_c_counted_raw_no_separators+0xdc>
  966553:	83 fe 2a             	cmp    esi,0x2a
  966556:	0f 85 19 01 00 00    	jne    966675 <tokenize_c_counted_raw_no_separators+0x1f5>
  96655c:	48 83 c2 02          	add    rdx,0x2
  966560:	4c 39 f2             	cmp    rdx,r14
  966563:	0f 83 0c 01 00 00    	jae    966675 <tokenize_c_counted_raw_no_separators+0x1f5>
  966569:	40 80 fe 2f          	cmp    sil,0x2f
  96656d:	75 61                	jne    9665d0 <tokenize_c_counted_raw_no_separators+0x150>
  96656f:	90                   	nop
  966570:	4c 89 f6             	mov    rsi,r14
  966573:	48 29 d6             	sub    rsi,rdx
  966576:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  96657b:	48 83 fe 3f          	cmp    rsi,0x3f
  96657f:	77 0a                	ja     96658b <tokenize_c_counted_raw_no_separators+0x10b>
  966581:	c4 62 c8 f5 c1       	bzhi   r8,rcx,rsi
  966586:	c4 c1 fb 92 c8       	kmovq  k1,r8
  96658b:	62 f1 7f c9 6f 14 17 	vmovdqu8 zmm2{k1}{z},ZMMWORD PTR [rdi+rdx*1]
  966592:	62 f1 6d 48 74 0d a4 	vpcmpeqb k1,zmm2,ZMMWORD PTR [rip+0xffffffffffaa54a4]        # 40ba40 <__abi_tag+0xae84>
  966599:	54 aa ff 
  96659c:	62 f1 6d 48 74 d1    	vpcmpeqb k2,zmm2,zmm1
  9665a2:	62 f1 6d 48 74 c0    	vpcmpeqb k0,zmm2,zmm0
  9665a8:	c4 e1 f4 45 ca       	korq   k1,k1,k2
  9665ad:	c4 e1 f8 98 c1       	kortestq k0,k1
  9665b2:	0f 85 98 00 00 00    	jne    966650 <tokenize_c_counted_raw_no_separators+0x1d0>
  9665b8:	48 83 fe 40          	cmp    rsi,0x40
  9665bc:	48 0f 43 f0          	cmovae rsi,rax
  9665c0:	48 01 f2             	add    rdx,rsi
  9665c3:	4c 39 f2             	cmp    rdx,r14
  9665c6:	72 a8                	jb     966570 <tokenize_c_counted_raw_no_separators+0xf0>
  9665c8:	e9 a8 00 00 00       	jmp    966675 <tokenize_c_counted_raw_no_separators+0x1f5>
  9665cd:	0f 1f 00             	nop    DWORD PTR [rax]
  9665d0:	31 db                	xor    ebx,ebx
  9665d2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  9665d9:	1f 84 00 00 00 00 00 
  9665e0:	4c 89 f6             	mov    rsi,r14
  9665e3:	48 29 d6             	sub    rsi,rdx
  9665e6:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  9665eb:	48 83 fe 3f          	cmp    rsi,0x3f
  9665ef:	77 0a                	ja     9665fb <tokenize_c_counted_raw_no_separators+0x17b>
  9665f1:	c4 62 c8 f5 c1       	bzhi   r8,rcx,rsi
  9665f6:	c4 c1 fb 92 c8       	kmovq  k1,r8
  9665fb:	62 f1 7f c9 6f 14 17 	vmovdqu8 zmm2{k1}{z},ZMMWORD PTR [rdi+rdx*1]
  966602:	62 f1 6d 48 74 c0    	vpcmpeqb k0,zmm2,zmm0
  966608:	c4 61 fb 93 c0       	kmovq  r8,k0
  96660d:	62 f1 6d 48 74 c7    	vpcmpeqb k0,zmm2,zmm7
  966613:	c4 61 fb 93 f8       	kmovq  r15,k0
  966618:	62 d1 6d 48 74 c0    	vpcmpeqb k0,zmm2,zmm8
  96661e:	4a 8d 1c 7b          	lea    rbx,[rbx+r15*2]
  966622:	c4 61 fb 93 d8       	kmovq  r11,k0
  966627:	4c 21 db             	and    rbx,r11
  96662a:	4c 09 c3             	or     rbx,r8
  96662d:	75 30                	jne    96665f <tokenize_c_counted_raw_no_separators+0x1df>
  96662f:	49 c1 ef 3f          	shr    r15,0x3f
  966633:	48 83 fe 40          	cmp    rsi,0x40
  966637:	48 0f 43 f0          	cmovae rsi,rax
  96663b:	4c 89 fb             	mov    rbx,r15
  96663e:	48 01 f2             	add    rdx,rsi
  966641:	4c 39 f2             	cmp    rdx,r14
  966644:	72 9a                	jb     9665e0 <tokenize_c_counted_raw_no_separators+0x160>
  966646:	eb 2d                	jmp    966675 <tokenize_c_counted_raw_no_separators+0x1f5>
  966648:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  96664f:	00 
  966650:	c4 e1 fc 45 c9       	korq   k1,k0,k1
  966655:	c4 61 fb 93 c0       	kmovq  r8,k0
  96665a:	c4 e1 fb 93 d9       	kmovq  rbx,k1
  96665f:	31 f6                	xor    esi,esi
  966661:	f3 48 0f bc f3       	tzcnt  rsi,rbx
  966666:	48 8d 54 16 01       	lea    rdx,[rsi+rdx*1+0x1]
  96666b:	49 0f a3 f0          	bt     r8,rsi
  96666f:	0f 83 76 fe ff ff    	jae    9664eb <tokenize_c_counted_raw_no_separators+0x6b>
  966675:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96667a:	62 71 fd 48 6f 15 7c 	vmovdqa64 zmm10,ZMMWORD PTR [rip+0xffffffffffaa547c]        # 40bb00 <__abi_tag+0xaf44>
  966681:	54 aa ff 
  966684:	62 71 fd 48 6f 1d b2 	vmovdqa64 zmm11,ZMMWORD PTR [rip+0xffffffffffaa54b2]        # 40bb40 <__abi_tag+0xaf84>
  96668b:	54 aa ff 
  96668e:	62 71 fd 48 6f 25 e8 	vmovdqa64 zmm12,ZMMWORD PTR [rip+0xffffffffffaa54e8]        # 40bb80 <__abi_tag+0xafc4>
  966695:	54 aa ff 
  966698:	62 71 fd 48 6f 2d 1e 	vmovdqa64 zmm13,ZMMWORD PTR [rip+0xffffffffffaa551e]        # 40bbc0 <__abi_tag+0xb004>
  96669f:	55 aa ff 
  9666a2:	62 72 7d 48 5a 35 f4 	vbroadcasti32x4 zmm14,XMMWORD PTR [rip+0xffffffffffac51f4]        # 42b8a0 <c_testsuite_feature.marker+0x139c>
  9666a9:	51 ac ff 
  9666ac:	62 72 7d 48 5a 3d fa 	vbroadcasti32x4 zmm15,XMMWORD PTR [rip+0xffffffffffac51fa]        # 42b8b0 <c_testsuite_feature.marker+0x13ac>
  9666b3:	51 ac ff 
  9666b6:	62 e2 7d 48 5a 05 00 	vbroadcasti32x4 zmm16,XMMWORD PTR [rip+0xffffffffffac5200]        # 42b8c0 <c_testsuite_feature.marker+0x13bc>
  9666bd:	52 ac ff 
  9666c0:	62 e2 7d 48 5a 0d 06 	vbroadcasti32x4 zmm17,XMMWORD PTR [rip+0xffffffffffac5206]        # 42b8d0 <c_testsuite_feature.marker+0x13cc>
  9666c7:	52 ac ff 
  9666ca:	62 e2 7d 48 5a 15 0c 	vbroadcasti32x4 zmm18,XMMWORD PTR [rip+0xffffffffffac520c]        # 42b8e0 <c_testsuite_feature.marker+0x13dc>
  9666d1:	52 ac ff 
  9666d4:	62 e2 7d 48 5a 1d 12 	vbroadcasti32x4 zmm19,XMMWORD PTR [rip+0xffffffffffac5212]        # 42b8f0 <c_testsuite_feature.marker+0x13ec>
  9666db:	52 ac ff 
  9666de:	62 e1 fd 48 6f 25 98 	vmovdqa64 zmm20,ZMMWORD PTR [rip+0xffffffffffaa5698]        # 40bd80 <__abi_tag+0xb1c4>
  9666e5:	56 aa ff 
  9666e8:	62 e2 7d 48 5a 2d 0e 	vbroadcasti32x4 zmm21,XMMWORD PTR [rip+0xffffffffffac520e]        # 42b900 <c_testsuite_feature.marker+0x13fc>
  9666ef:	52 ac ff 
  9666f2:	62 e2 7d 48 5a 35 14 	vbroadcasti32x4 zmm22,XMMWORD PTR [rip+0xffffffffffac5214]        # 42b910 <c_testsuite_feature.marker+0x140c>
  9666f9:	52 ac ff 
  9666fc:	62 e2 7d 48 5a 3d 1a 	vbroadcasti32x4 zmm23,XMMWORD PTR [rip+0xffffffffffac521a]        # 42b920 <c_testsuite_feature.marker+0x141c>
  966703:	52 ac ff 
  966706:	62 62 7d 48 5a 05 20 	vbroadcasti32x4 zmm24,XMMWORD PTR [rip+0xffffffffffac5220]        # 42b930 <c_testsuite_feature.marker+0x142c>
  96670d:	52 ac ff 
  966710:	48 89 f9             	mov    rcx,rdi
  966713:	48 83 e1 c0          	and    rcx,0xffffffffffffffc0
  966717:	4d 89 f0             	mov    r8,r14
  96671a:	89 fa                	mov    edx,edi
  96671c:	4d 8d 2c 38          	lea    r13,[r8+rdi*1]
  966720:	83 e2 3f             	and    edx,0x3f
  966723:	48 c7 c3 ff ff ff ff 	mov    rbx,0xffffffffffffffff
  96672a:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  96672e:	62 71 7c 48 28 0d 88 	vmovaps zmm9,ZMMWORD PTR [rip+0xffffffffffaa5388]        # 40bac0 <__abi_tag+0xaf04>
  966735:	53 aa ff 
  966738:	62 f1 fd 48 7f 84 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2c00],zmm0
  96673f:	00 2c 00 00 
  966743:	62 f1 fd 48 7f 84 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2bc0],zmm0
  96674a:	c0 2b 00 00 
  96674e:	62 f1 fd 48 7f 84 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2b80],zmm0
  966755:	80 2b 00 00 
  966759:	4c 89 44 24 28       	mov    QWORD PTR [rsp+0x28],r8
  96675e:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  966762:	48 89 c8             	mov    rax,rcx
  966765:	48 29 f8             	sub    rax,rdi
  966768:	49 29 cd             	sub    r13,rcx
  96676b:	48 89 8c 24 20 02 00 	mov    QWORD PTR [rsp+0x220],rcx
  966772:	00 
  966773:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
  966778:	49 89 f6             	mov    r14,rsi
  96677b:	49 29 c6             	sub    r14,rax
  96677e:	48 01 f2             	add    rdx,rsi
  966781:	31 f6                	xor    esi,esi
  966783:	49 83 e6 c0          	and    r14,0xffffffffffffffc0
  966787:	4a 8d 04 31          	lea    rax,[rcx+r14*1]
  96678b:	4c 89 e9             	mov    rcx,r13
  96678e:	4c 29 f1             	sub    rcx,r14
  966791:	4c 29 f2             	sub    rdx,r14
  966794:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  96679b:	00 00 00 00 00 
  9667a0:	48 85 d2             	test   rdx,rdx
  9667a3:	0f 8f 5a 01 00 00    	jg     966903 <tokenize_c_counted_raw_no_separators+0x483>
  9667a9:	48 83 f9 40          	cmp    rcx,0x40
  9667ad:	0f 8c 50 01 00 00    	jl     966903 <tokenize_c_counted_raw_no_separators+0x483>
  9667b3:	62 f1 fd 48 6f 14 f0 	vmovdqa64 zmm2,ZMMWORD PTR [rax+rsi*8]
  9667ba:	62 d1 fd 48 6f da    	vmovdqa64 zmm3,zmm10
  9667c0:	62 41 fd 48 6f cc    	vmovdqa64 zmm25,zmm12
  9667c6:	62 d2 6d 48 7d db    	vpermt2b zmm3,zmm2,zmm11
  9667cc:	62 42 6d 48 7d cd    	vpermt2b zmm25,zmm2,zmm13
  9667d2:	62 f2 7e 48 29 c2    	vpmovb2m k0,zmm2
  9667d8:	62 f1 fd 48 7f 54 f4 	vmovdqa64 ZMMWORD PTR [rsp+rsi*8+0x13c0],zmm2
  9667df:	4f 
  9667e0:	c4 e1 f8 98 c0       	kortestq k0,k0
  9667e5:	0f 85 02 01 00 00    	jne    9668ed <tokenize_c_counted_raw_no_separators+0x46d>
  9667eb:	62 91 fd 48 6f e1    	vmovdqa64 zmm4,zmm25
  9667f1:	62 f2 35 48 7d e0    	vpermt2b zmm4,zmm9,zmm0
  9667f7:	62 92 0d 48 00 c1    	vpshufb zmm0,zmm14,zmm25
  9667fd:	62 b2 65 48 00 da    	vpshufb zmm3,zmm3,zmm18
  966803:	48 83 c1 c0          	add    rcx,0xffffffffffffffc0
  966807:	48 83 c2 c0          	add    rdx,0xffffffffffffffc0
  96680b:	62 f3 e5 40 ce db 00 	vgf2p8affineqb zmm3,zmm19,zmm3,0x0
  966812:	62 93 5d 48 3f c9 04 	vpcmpneqb k1,zmm4,zmm25
  966819:	62 f2 05 48 00 e4    	vpshufb zmm4,zmm15,zmm4
  96681f:	62 f2 5d 40 8d db    	vpermb zmm3,zmm20,zmm3
  966825:	62 f1 dd 48 db c0    	vpandq zmm0,zmm4,zmm0
  96682b:	62 b1 fd 48 db e0    	vpandq zmm4,zmm0,zmm16
  966831:	62 62 7d 49 66 d4    	vpblendmb zmm26{k1},zmm0,zmm4
  966837:	62 d1 6d 48 74 c8    	vpcmpeqb k1,zmm2,zmm8
  96683d:	62 92 75 40 00 e1    	vpshufb zmm4,zmm17,zmm25
  966843:	62 91 fd 48 6f ea    	vmovdqa64 zmm5,zmm26
  966849:	62 f2 35 48 7d e9    	vpermt2b zmm5,zmm9,zmm1
  96684f:	c4 e1 f8 91 8c 34 80 	kmovq  QWORD PTR [rsp+rsi*1+0x1e80],k1
  966856:	1e 00 00 
  966859:	62 f1 6d 48 74 cf    	vpcmpeqb k1,zmm2,zmm7
  96685f:	62 f1 fd 48 7f 5c f4 	vmovdqa64 ZMMWORD PTR [rsp+rsi*8+0xc80],zmm3
  966866:	32 
  966867:	c4 e1 f8 91 8c 34 00 	kmovq  QWORD PTR [rsp+rsi*1+0x1f00],k1
  96686e:	1f 00 00 
  966871:	62 b1 6d 48 74 cd    	vpcmpeqb k1,zmm2,zmm21
  966877:	c4 e1 f8 91 8c 34 80 	kmovq  QWORD PTR [rsp+rsi*1+0x1f80],k1
  96687e:	1f 00 00 
  966881:	62 f2 7e 48 29 c8    	vpmovb2m k1,zmm0
  966887:	c4 e1 f8 91 8c 34 00 	kmovq  QWORD PTR [rsp+rsi*1+0x2000],k1
  96688e:	20 00 00 
  966891:	62 b2 7d 48 26 ce    	vptestmb k1,zmm0,zmm22
  966897:	62 91 fd 48 6f c1    	vmovdqa64 zmm0,zmm25
  96689d:	c4 e1 f8 91 8c 34 80 	kmovq  QWORD PTR [rsp+rsi*1+0x2080],k1
  9668a4:	20 00 00 
  9668a7:	62 b2 2d 40 26 cf    	vptestmb k1,zmm26,zmm23
  9668ad:	62 f1 dd 48 db cd    	vpandq zmm1,zmm4,zmm5
  9668b3:	c4 e1 f8 91 8c 34 00 	kmovq  QWORD PTR [rsp+rsi*1+0x2100],k1
  9668ba:	21 00 00 
  9668bd:	62 92 75 48 26 c8    	vptestmb k1,zmm1,zmm24
  9668c3:	62 91 fd 48 6f ca    	vmovdqa64 zmm1,zmm26
  9668c9:	c4 e1 f8 91 8c 34 80 	kmovq  QWORD PTR [rsp+rsi*1+0x2180],k1
  9668d0:	21 00 00 
  9668d3:	c4 e1 f8 91 84 34 80 	kmovq  QWORD PTR [rsp+rsi*1+0x2280],k0
  9668da:	22 00 00 
  9668dd:	48 83 c6 08          	add    rsi,0x8
  9668e1:	48 83 fe 48          	cmp    rsi,0x48
  9668e5:	0f 85 b5 fe ff ff    	jne    9667a0 <tokenize_c_counted_raw_no_separators+0x320>
  9668eb:	eb 7b                	jmp    966968 <tokenize_c_counted_raw_no_separators+0x4e8>
  9668ed:	c4 e1 f8 44 c8       	knotq  k1,k0
  9668f2:	62 f1 7f c9 6f db    	vmovdqu8 zmm3{k1}{z},zmm3
  9668f8:	62 01 7f c9 6f c9    	vmovdqu8 zmm25{k1}{z},zmm25
  9668fe:	e9 e8 fe ff ff       	jmp    9667eb <tokenize_c_counted_raw_no_separators+0x36b>
  966903:	45 31 c0             	xor    r8d,r8d
  966906:	48 85 c9             	test   rcx,rcx
  966909:	4d 89 cc             	mov    r12,r9
  96690c:	4c 8d 59 c0          	lea    r11,[rcx-0x40]
  966910:	4d 89 f7             	mov    r15,r14
  966913:	41 0f 9f c1          	setg   r9b
  966917:	49 83 fb c1          	cmp    r11,0xffffffffffffffc1
  96691b:	73 08                	jae    966925 <tokenize_c_counted_raw_no_separators+0x4a5>
  96691d:	45 88 c8             	mov    r8b,r9b
  966920:	49 f7 d8             	neg    r8
  966923:	eb 05                	jmp    96692a <tokenize_c_counted_raw_no_separators+0x4aa>
  966925:	c4 62 f0 f5 c3       	bzhi   r8,rbx,rcx
  96692a:	4d 89 fe             	mov    r14,r15
  96692d:	48 85 d2             	test   rdx,rdx
  966930:	7e 18                	jle    96694a <tokenize_c_counted_raw_no_separators+0x4ca>
  966932:	48 83 fa 3f          	cmp    rdx,0x3f
  966936:	76 05                	jbe    96693d <tokenize_c_counted_raw_no_separators+0x4bd>
  966938:	45 31 c0             	xor    r8d,r8d
  96693b:	eb 0d                	jmp    96694a <tokenize_c_counted_raw_no_separators+0x4ca>
  96693d:	c4 62 e8 f5 cb       	bzhi   r9,rbx,rdx
  966942:	4d 89 fe             	mov    r14,r15
  966945:	c4 42 b0 f2 c0       	andn   r8,r9,r8
  96694a:	62 f2 7d 48 5a 15 ec 	vbroadcasti32x4 zmm2,XMMWORD PTR [rip+0xffffffffffac4fec]        # 42b940 <c_testsuite_feature.marker+0x143c>
  966951:	4f ac ff 
  966954:	c4 c1 fb 92 c8       	kmovq  k1,r8
  966959:	4d 89 e1             	mov    r9,r12
  96695c:	62 f2 6d 49 66 14 f0 	vpblendmb zmm2{k1},zmm2,ZMMWORD PTR [rax+rsi*8]
  966963:	e9 52 fe ff ff       	jmp    9667ba <tokenize_c_counted_raw_no_separators+0x33a>
  966968:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
  96696d:	48 8b 8c 24 20 02 00 	mov    rcx,QWORD PTR [rsp+0x220]
  966974:	00 
  966975:	48 8b 54 24 30       	mov    rdx,QWORD PTR [rsp+0x30]
  96697a:	62 61 fd 48 6f 25 bc 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffaa57bc]        # 40c140 <__abi_tag+0xb584>
  966981:	57 aa ff 
  966984:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  96698b:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  96698f:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x5c0],zmm0
  966996:	17 
  966997:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  96699b:	48 89 7c 24 50       	mov    QWORD PTR [rsp+0x50],rdi
  9669a0:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  9669a6:	48 c7 84 24 f0 00 00 	mov    QWORD PTR [rsp+0xf0],0x0
  9669ad:	00 00 00 00 00 
  9669b2:	31 f6                	xor    esi,esi
  9669b4:	4c 89 8c 24 68 04 00 	mov    QWORD PTR [rsp+0x468],r9
  9669bb:	00 
  9669bc:	4d 89 cf             	mov    r15,r9
  9669bf:	48 c7 84 24 40 02 00 	mov    QWORD PTR [rsp+0x240],0x0
  9669c6:	00 00 00 00 00 
  9669cb:	48 c7 84 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],0x0
  9669d2:	00 00 00 00 00 
  9669d7:	48 c7 84 24 28 02 00 	mov    QWORD PTR [rsp+0x228],0x0
  9669de:	00 00 00 00 00 
  9669e3:	48 c7 84 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],0x0
  9669ea:	00 00 00 00 00 
  9669ef:	48 c7 84 24 00 07 00 	mov    QWORD PTR [rsp+0x700],0x0
  9669f6:	00 00 00 00 00 
  9669fb:	48 c7 84 24 c0 02 00 	mov    QWORD PTR [rsp+0x2c0],0x0
  966a02:	00 00 00 00 00 
  966a07:	48 c7 84 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],0x0
  966a0e:	00 00 00 00 00 
  966a13:	48 c7 84 24 40 01 00 	mov    QWORD PTR [rsp+0x140],0x0
  966a1a:	00 00 00 00 00 
  966a1f:	48 c7 84 24 38 02 00 	mov    QWORD PTR [rsp+0x238],0x0
  966a26:	00 00 00 00 00 
  966a2b:	48 c7 84 24 c0 04 00 	mov    QWORD PTR [rsp+0x4c0],0x0
  966a32:	00 00 00 00 00 
  966a37:	48 c7 84 24 00 01 00 	mov    QWORD PTR [rsp+0x100],0x0
  966a3e:	00 00 00 00 00 
  966a43:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x640],zmm0
  966a4a:	19 
  966a4b:	62 71 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0xa40],zmm9
  966a52:	29 
  966a53:	48 05 00 fe ff ff    	add    rax,0xfffffffffffffe00
  966a59:	4e 8d a4 31 40 02 00 	lea    r12,[rcx+r14*1+0x240]
  966a60:	00 
  966a61:	48 89 84 24 70 04 00 	mov    QWORD PTR [rsp+0x470],rax
  966a68:	00 
  966a69:	4c 89 f0             	mov    rax,r14
  966a6c:	48 f7 d8             	neg    rax
  966a6f:	48 89 84 24 d8 00 00 	mov    QWORD PTR [rsp+0xd8],rax
  966a76:	00 
  966a77:	49 8d 85 c0 fd ff ff 	lea    rax,[r13-0x240]
  966a7e:	49 81 c5 80 fd ff ff 	add    r13,0xfffffffffffffd80
  966a85:	48 89 84 24 10 02 00 	mov    QWORD PTR [rsp+0x210],rax
  966a8c:	00 
  966a8d:	48 89 f8             	mov    rax,rdi
  966a90:	48 29 c8             	sub    rax,rcx
  966a93:	4c 89 ac 24 18 02 00 	mov    QWORD PTR [rsp+0x218],r13
  966a9a:	00 
  966a9b:	4c 8b ac 24 b0 00 00 	mov    r13,QWORD PTR [rsp+0xb0]
  966aa2:	00 
  966aa3:	48 8d 84 10 c0 fd ff 	lea    rax,[rax+rdx*1-0x240]
  966aaa:	ff 
  966aab:	48 89 84 24 08 02 00 	mov    QWORD PTR [rsp+0x208],rax
  966ab2:	00 
  966ab3:	4a 8d 44 31 01       	lea    rax,[rcx+r14*1+0x1]
  966ab8:	48 89 84 24 00 02 00 	mov    QWORD PTR [rsp+0x200],rax
  966abf:	00 
  966ac0:	4a 8d 44 31 41       	lea    rax,[rcx+r14*1+0x41]
  966ac5:	48 89 84 24 f8 01 00 	mov    QWORD PTR [rsp+0x1f8],rax
  966acc:	00 
  966acd:	4a 8d 84 31 81 00 00 	lea    rax,[rcx+r14*1+0x81]
  966ad4:	00 
  966ad5:	48 89 84 24 f0 01 00 	mov    QWORD PTR [rsp+0x1f0],rax
  966adc:	00 
  966add:	4a 8d 84 31 c1 00 00 	lea    rax,[rcx+r14*1+0xc1]
  966ae4:	00 
  966ae5:	48 89 84 24 e8 01 00 	mov    QWORD PTR [rsp+0x1e8],rax
  966aec:	00 
  966aed:	4a 8d 84 31 01 01 00 	lea    rax,[rcx+r14*1+0x101]
  966af4:	00 
  966af5:	48 89 84 24 e0 01 00 	mov    QWORD PTR [rsp+0x1e0],rax
  966afc:	00 
  966afd:	4a 8d 84 31 41 01 00 	lea    rax,[rcx+r14*1+0x141]
  966b04:	00 
  966b05:	48 89 84 24 d8 01 00 	mov    QWORD PTR [rsp+0x1d8],rax
  966b0c:	00 
  966b0d:	4a 8d 84 31 81 01 00 	lea    rax,[rcx+r14*1+0x181]
  966b14:	00 
  966b15:	48 89 84 24 d0 01 00 	mov    QWORD PTR [rsp+0x1d0],rax
  966b1c:	00 
  966b1d:	4a 8d 84 31 c1 01 00 	lea    rax,[rcx+r14*1+0x1c1]
  966b24:	00 
  966b25:	31 c9                	xor    ecx,ecx
  966b27:	48 89 84 24 c8 01 00 	mov    QWORD PTR [rsp+0x1c8],rax
  966b2e:	00 
  966b2f:	48 8d 84 24 c0 13 00 	lea    rax,[rsp+0x13c0]
  966b36:	00 
  966b37:	48 89 44 24 58       	mov    QWORD PTR [rsp+0x58],rax
  966b3c:	b8 01 00 00 00       	mov    eax,0x1
  966b41:	48 89 84 24 30 02 00 	mov    QWORD PTR [rsp+0x230],rax
  966b48:	00 
  966b49:	31 c0                	xor    eax,eax
  966b4b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
  966b50:	48 89 84 24 98 00 00 	mov    QWORD PTR [rsp+0x98],rax
  966b57:	00 
  966b58:	48 69 c6 80 08 00 00 	imul   rax,rsi,0x880
  966b5f:	4c 89 74 24 40       	mov    QWORD PTR [rsp+0x40],r14
  966b64:	48 89 b4 24 78 04 00 	mov    QWORD PTR [rsp+0x478],rsi
  966b6b:	00 
  966b6c:	48 8d 9c 04 80 1a 00 	lea    rbx,[rsp+rax*1+0x1a80]
  966b73:	00 
  966b74:	48 8b 44 24 48       	mov    rax,QWORD PTR [rsp+0x48]
  966b79:	49 8d 3c 06          	lea    rdi,[r14+rax*1]
  966b7d:	49 8d 94 06 00 02 00 	lea    rdx,[r14+rax*1+0x200]
  966b84:	00 
  966b85:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  966b8a:	48 8d 04 f6          	lea    rax,[rsi+rsi*8]
  966b8e:	48 89 7c 24 38       	mov    QWORD PTR [rsp+0x38],rdi
  966b93:	48 89 54 24 78       	mov    QWORD PTR [rsp+0x78],rdx
  966b98:	4c 39 f2             	cmp    rdx,r14
  966b9b:	0f 8d 4f 1a 00 00    	jge    9685f0 <tokenize_c_counted_raw_no_separators+0x2170>
  966ba1:	49 89 c6             	mov    r14,rax
  966ba4:	49 c1 e6 06          	shl    r14,0x6
  966ba8:	49 89 f1             	mov    r9,rsi
  966bab:	49 83 f1 01          	xor    r9,0x1
  966baf:	62 b1 7c 48 28 44 34 	vmovaps zmm0,ZMMWORD PTR [rsp+r14*1+0xe80]
  966bb6:	3a 
  966bb7:	4c 8b b3 40 04 00 00 	mov    r14,QWORD PTR [rbx+0x440]
  966bbe:	49 69 f1 80 08 00 00 	imul   rsi,r9,0x880
  966bc5:	4f 8d 0c c9          	lea    r9,[r9+r9*8]
  966bc9:	49 c1 e1 06          	shl    r9,0x6
  966bcd:	4c 89 b4 34 80 1e 00 	mov    QWORD PTR [rsp+rsi*1+0x1e80],r14
  966bd4:	00 
  966bd5:	4c 8b b3 c0 04 00 00 	mov    r14,QWORD PTR [rbx+0x4c0]
  966bdc:	62 b1 7c 48 29 44 0c 	vmovaps ZMMWORD PTR [rsp+r9*1+0xc80],zmm0
  966be3:	32 
  966be4:	4c 89 b4 34 00 1f 00 	mov    QWORD PTR [rsp+rsi*1+0x1f00],r14
  966beb:	00 
  966bec:	4c 8b b3 40 05 00 00 	mov    r14,QWORD PTR [rbx+0x540]
  966bf3:	4c 89 b4 34 80 1f 00 	mov    QWORD PTR [rsp+rsi*1+0x1f80],r14
  966bfa:	00 
  966bfb:	4c 8b b3 c0 05 00 00 	mov    r14,QWORD PTR [rbx+0x5c0]
  966c02:	4c 89 b4 34 00 20 00 	mov    QWORD PTR [rsp+rsi*1+0x2000],r14
  966c09:	00 
  966c0a:	4c 8b b3 40 06 00 00 	mov    r14,QWORD PTR [rbx+0x640]
  966c11:	4c 89 b4 34 80 20 00 	mov    QWORD PTR [rsp+rsi*1+0x2080],r14
  966c18:	00 
  966c19:	4c 8b b3 c0 06 00 00 	mov    r14,QWORD PTR [rbx+0x6c0]
  966c20:	4c 89 b4 34 00 21 00 	mov    QWORD PTR [rsp+rsi*1+0x2100],r14
  966c27:	00 
  966c28:	4c 8b b3 40 07 00 00 	mov    r14,QWORD PTR [rbx+0x740]
  966c2f:	4c 89 b4 34 80 21 00 	mov    QWORD PTR [rsp+rsi*1+0x2180],r14
  966c36:	00 
  966c37:	4c 8b b3 c0 07 00 00 	mov    r14,QWORD PTR [rbx+0x7c0]
  966c3e:	4c 89 b4 34 00 22 00 	mov    QWORD PTR [rsp+rsi*1+0x2200],r14
  966c45:	00 
  966c46:	4c 8b b3 40 08 00 00 	mov    r14,QWORD PTR [rbx+0x840]
  966c4d:	4c 89 b4 34 80 22 00 	mov    QWORD PTR [rsp+rsi*1+0x2280],r14
  966c54:	00 
  966c55:	48 3b 54 24 30       	cmp    rdx,QWORD PTR [rsp+0x30]
  966c5a:	0f 8c 24 1b 00 00    	jl     968784 <tokenize_c_counted_raw_no_separators+0x2304>
  966c60:	4c 8d b7 40 04 00 00 	lea    r14,[rdi+0x440]
  966c67:	4c 3b 74 24 28       	cmp    r14,QWORD PTR [rsp+0x28]
  966c6c:	0f 8f 12 1b 00 00    	jg     968784 <tokenize_c_counted_raw_no_separators+0x2304>
  966c72:	4c 8b b4 24 20 02 00 	mov    r14,QWORD PTR [rsp+0x220]
  966c79:	00 
  966c7a:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  966c7f:	49 8d 94 3e 00 02 00 	lea    rdx,[r14+rdi*1+0x200]
  966c86:	00 
  966c87:	48 8d bc 24 c0 0c 00 	lea    rdi,[rsp+0xcc0]
  966c8e:	00 
  966c8f:	45 31 f6             	xor    r14d,r14d
  966c92:	49 01 f9             	add    r9,rdi
  966c95:	48 8d bc 24 88 22 00 	lea    rdi,[rsp+0x2288]
  966c9c:	00 
  966c9d:	48 01 fe             	add    rsi,rdi
  966ca0:	48 89 94 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],rdx
  966ca7:	00 
  966ca8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  966caf:	00 
  966cb0:	62 91 fd 48 6f 14 f4 	vmovdqa64 zmm2,ZMMWORD PTR [r12+r14*8]
  966cb7:	62 d1 fd 48 6f c2    	vmovdqa64 zmm0,zmm10
  966cbd:	62 d1 fd 48 6f cc    	vmovdqa64 zmm1,zmm12
  966cc3:	62 d2 6d 48 7d c3    	vpermt2b zmm0,zmm2,zmm11
  966cc9:	62 d2 6d 48 7d cd    	vpermt2b zmm1,zmm2,zmm13
  966ccf:	62 f2 7e 48 29 c2    	vpmovb2m k0,zmm2
  966cd5:	c4 e1 f8 98 c0       	kortestq k0,k0
  966cda:	0f 85 f5 00 00 00    	jne    966dd5 <tokenize_c_counted_raw_no_separators+0x955>
  966ce0:	62 f1 fd 48 6f d9    	vmovdqa64 zmm3,zmm1
  966ce6:	62 92 35 48 7d d9    	vpermt2b zmm3,zmm9,zmm25
  966cec:	62 f2 0d 48 00 e1    	vpshufb zmm4,zmm14,zmm1
  966cf2:	62 b2 7d 48 00 c2    	vpshufb zmm0,zmm0,zmm18
  966cf8:	62 f2 75 40 00 e9    	vpshufb zmm5,zmm17,zmm1
  966cfe:	62 61 fd 48 6f c9    	vmovdqa64 zmm25,zmm1
  966d04:	62 f3 e5 40 ce c0 00 	vgf2p8affineqb zmm0,zmm19,zmm0,0x0
  966d0b:	62 f3 65 48 3f c9 04 	vpcmpneqb k1,zmm3,zmm1
  966d12:	62 f2 05 48 00 db    	vpshufb zmm3,zmm15,zmm3
  966d18:	62 f2 5d 40 8d c0    	vpermb zmm0,zmm20,zmm0
  966d1e:	62 f1 e5 48 db e4    	vpandq zmm4,zmm3,zmm4
  966d24:	62 b1 dd 48 db d8    	vpandq zmm3,zmm4,zmm16
  966d2a:	62 f2 5d 49 66 db    	vpblendmb zmm3{k1},zmm4,zmm3
  966d30:	62 d1 6d 48 74 c8    	vpcmpeqb k1,zmm2,zmm8
  966d36:	62 f1 fd 48 6f f3    	vmovdqa64 zmm6,zmm3
  966d3c:	62 92 35 48 7d f2    	vpermt2b zmm6,zmm9,zmm26
  966d42:	c4 a1 f8 91 8c 36 00 	kmovq  QWORD PTR [rsi+r14*1-0x400],k1
  966d49:	fc ff ff 
  966d4c:	62 f1 6d 48 74 cf    	vpcmpeqb k1,zmm2,zmm7
  966d52:	62 91 fd 48 7f 04 f1 	vmovdqa64 ZMMWORD PTR [r9+r14*8],zmm0
  966d59:	62 61 fd 48 6f d3    	vmovdqa64 zmm26,zmm3
  966d5f:	c4 a1 f8 91 8c 36 80 	kmovq  QWORD PTR [rsi+r14*1-0x380],k1
  966d66:	fc ff ff 
  966d69:	62 b1 6d 48 74 cd    	vpcmpeqb k1,zmm2,zmm21
  966d6f:	c4 a1 f8 91 8c 36 00 	kmovq  QWORD PTR [rsi+r14*1-0x300],k1
  966d76:	fd ff ff 
  966d79:	62 f2 7e 48 29 cc    	vpmovb2m k1,zmm4
  966d7f:	c4 a1 f8 91 8c 36 80 	kmovq  QWORD PTR [rsi+r14*1-0x280],k1
  966d86:	fd ff ff 
  966d89:	62 b2 5d 48 26 ce    	vptestmb k1,zmm4,zmm22
  966d8f:	c4 a1 f8 91 8c 36 00 	kmovq  QWORD PTR [rsi+r14*1-0x200],k1
  966d96:	fe ff ff 
  966d99:	62 b2 65 48 26 cf    	vptestmb k1,zmm3,zmm23
  966d9f:	62 f1 d5 48 db ee    	vpandq zmm5,zmm5,zmm6
  966da5:	c4 a1 f8 91 8c 36 80 	kmovq  QWORD PTR [rsi+r14*1-0x180],k1
  966dac:	fe ff ff 
  966daf:	62 92 55 48 26 c8    	vptestmb k1,zmm5,zmm24
  966db5:	c4 a1 f8 91 8c 36 00 	kmovq  QWORD PTR [rsi+r14*1-0x100],k1
  966dbc:	ff ff ff 
  966dbf:	c4 a1 f8 91 04 36    	kmovq  QWORD PTR [rsi+r14*1],k0
  966dc5:	49 83 c6 08          	add    r14,0x8
  966dc9:	49 83 fe 40          	cmp    r14,0x40
  966dcd:	0f 85 dd fe ff ff    	jne    966cb0 <tokenize_c_counted_raw_no_separators+0x830>
  966dd3:	eb 1b                	jmp    966df0 <tokenize_c_counted_raw_no_separators+0x970>
  966dd5:	c4 e1 f8 44 c8       	knotq  k1,k0
  966dda:	62 f1 7f c9 6f c0    	vmovdqu8 zmm0{k1}{z},zmm0
  966de0:	62 f1 7f c9 6f c9    	vmovdqu8 zmm1{k1}{z},zmm1
  966de6:	e9 f5 fe ff ff       	jmp    966ce0 <tokenize_c_counted_raw_no_separators+0x860>
  966deb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
  966df0:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  966df5:	62 61 fd 48 6f d3    	vmovdqa64 zmm26,zmm3
  966dfb:	62 61 fd 48 6f c9    	vmovdqa64 zmm25,zmm1
  966e01:	48 8b 7c 24 38       	mov    rdi,QWORD PTR [rsp+0x38]
  966e06:	62 f1 fd 48 6f 3d b0 	vmovdqa64 zmm7,ZMMWORD PTR [rip+0xffffffffffaa50b0]        # 40bec0 <__abi_tag+0xb304>
  966e0d:	50 aa ff 
  966e10:	62 71 fd 48 6f 05 e6 	vmovdqa64 zmm8,ZMMWORD PTR [rip+0xffffffffffaa50e6]        # 40bf00 <__abi_tag+0xb344>
  966e17:	50 aa ff 
  966e1a:	62 71 fd 48 6f 0d 1c 	vmovdqa64 zmm9,ZMMWORD PTR [rip+0xffffffffffaa511c]        # 40bf40 <__abi_tag+0xb384>
  966e21:	51 aa ff 
  966e24:	62 71 fd 48 6f 15 52 	vmovdqa64 zmm10,ZMMWORD PTR [rip+0xffffffffffaa5152]        # 40bf80 <__abi_tag+0xb3c4>
  966e2b:	51 aa ff 
  966e2e:	62 72 7d 48 5a 1d 18 	vbroadcasti32x4 zmm11,XMMWORD PTR [rip+0xffffffffffac4b18]        # 42b950 <c_testsuite_feature.marker+0x144c>
  966e35:	4b ac ff 
  966e38:	62 71 fd 48 6f 25 3e 	vmovdqa64 zmm12,ZMMWORD PTR [rip+0xffffffffffaa523e]        # 40c080 <__abi_tag+0xb4c4>
  966e3f:	52 aa ff 
  966e42:	62 72 7d 48 58 2d 40 	vpbroadcastd zmm13,DWORD PTR [rip+0xffffffffffc65740]        # 5cc58c <x86_effects_unknown+0x11c>
  966e49:	57 c6 ff 
  966e4c:	f6 c1 01             	test   cl,0x1
  966e4f:	0f 84 9b 04 00 00    	je     9672f0 <tokenize_c_counted_raw_no_separators+0xe70>
  966e55:	48 8b 8c 24 00 05 00 	mov    rcx,QWORD PTR [rsp+0x500]
  966e5c:	00 
  966e5d:	48 8b 54 24 78       	mov    rdx,QWORD PTR [rsp+0x78]
  966e62:	62 f2 7d 48 7c c9    	vpbroadcastd zmm1,ecx
  966e68:	31 c9                	xor    ecx,ecx
  966e6a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  966e70:	48 89 ce             	mov    rsi,rcx
  966e73:	48 c1 e6 06          	shl    rsi,0x6
  966e77:	c4 e1 f8 90 8c cc 00 	kmovq  k1,QWORD PTR [rsp+rcx*8+0x1100]
  966e7e:	11 00 00 
  966e81:	62 f1 fd 48 6f d7    	vmovdqa64 zmm2,zmm7
  966e87:	c4 e1 f8 90 94 cc c0 	kmovq  k2,QWORD PTR [rsp+rcx*8+0x11c0]
  966e8e:	11 00 00 
  966e91:	4c 8b 8c cc 00 12 00 	mov    r9,QWORD PTR [rsp+rcx*8+0x1200]
  966e98:	00 
  966e99:	62 d1 fd 48 6f 04 33 	vmovdqa64 zmm0,ZMMWORD PTR [r11+rsi*1]
  966ea0:	62 d1 7d 48 fc 9c 33 	vpaddb zmm3,zmm0,ZMMWORD PTR [r11+rsi*1+0x1]
  966ea7:	01 00 00 00 
  966eab:	62 d2 7d 48 7d d0    	vpermt2b zmm2,zmm0,zmm8
  966eb1:	62 f1 65 48 fc db    	vpaddb zmm3,zmm3,zmm3
  966eb7:	62 f1 65 48 fc db    	vpaddb zmm3,zmm3,zmm3
  966ebd:	62 f1 65 48 fc c0    	vpaddb zmm0,zmm3,zmm0
  966ec3:	62 d1 fd 48 6f d9    	vmovdqa64 zmm3,zmm9
  966ec9:	62 d2 7d 48 7d da    	vpermt2b zmm3,zmm0,zmm10
  966ecf:	62 f1 7f 4a 6f d3    	vmovdqu8 zmm2{k2},zmm3
  966ed5:	4d 85 c9             	test   r9,r9
  966ed8:	0f 85 ea 00 00 00    	jne    966fc8 <tokenize_c_counted_raw_no_separators+0xb48>
  966ede:	c4 e1 f8 90 94 cc 40 	kmovq  k2,QWORD PTR [rsp+rcx*8+0x1140]
  966ee5:	11 00 00 
  966ee8:	41 0f a3 c8          	bt     r8d,ecx
  966eec:	0f 82 f9 00 00 00    	jb     966feb <tokenize_c_counted_raw_no_separators+0xb6b>
  966ef2:	c4 e1 f8 90 9c cc 80 	kmovq  k3,QWORD PTR [rsp+rcx*8+0x1180]
  966ef9:	11 00 00 
  966efc:	62 d1 ed 48 eb c3    	vporq  zmm0,zmm2,zmm11
  966f02:	62 f1 7f 4b 6f d0    	vmovdqu8 zmm2{k3},zmm0
  966f08:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  966f0c:	62 f2 7d c9 63 d0    	vpcompressb zmm0{k1}{z},zmm2
  966f12:	62 d1 fe 48 7f 45 00 	vmovdqu64 ZMMWORD PTR [r13+0x0],zmm0
  966f19:	c5 d9 ef e4          	vpxor  xmm4,xmm4,xmm4
  966f1d:	62 72 7d c9 63 e4    	vpcompressb zmm4{k1}{z},zmm12
  966f23:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  966f27:	62 72 7d ca 63 e3    	vpcompressb zmm3{k2}{z},zmm12
  966f2d:	62 91 75 48 fa d3    	vpsubd zmm2,zmm1,zmm27
  966f33:	48 8b b4 cc 00 13 00 	mov    rsi,QWORD PTR [rsp+rcx*8+0x1300]
  966f3a:	00 
  966f3b:	4c 8b 8c cc 40 13 00 	mov    r9,QWORD PTR [rsp+rcx*8+0x1340]
  966f42:	00 
  966f43:	62 f2 7d 48 31 c4    	vpmovzxbd zmm0,xmm4
  966f49:	62 72 7d 48 31 f3    	vpmovzxbd zmm14,xmm3
  966f4f:	c4 e3 7d 39 e5 01    	vextracti128 xmm5,ymm4,0x1
  966f55:	62 f1 75 48 fe c0    	vpaddd zmm0,zmm1,zmm0
  966f5b:	62 d1 fe 48 7f 02    	vmovdqu64 ZMMWORD PTR [r10],zmm0
  966f61:	62 d1 6d 48 fe c6    	vpaddd zmm0,zmm2,zmm14
  966f67:	62 d1 fe 48 7f 07    	vmovdqu64 ZMMWORD PTR [r15],zmm0
  966f6d:	c4 e2 7d 31 c5       	vpmovzxbd ymm0,xmm5
  966f72:	c5 f5 fe c0          	vpaddd ymm0,ymm1,ymm0
  966f76:	c4 c1 7e 7f 42 40    	vmovdqu YMMWORD PTR [r10+0x40],ymm0
  966f7c:	c4 e3 7d 39 d8 01    	vextracti128 xmm0,ymm3,0x1
  966f82:	c4 e2 7d 31 f0       	vpmovzxbd ymm6,xmm0
  966f87:	c5 ed fe f6          	vpaddd ymm6,ymm2,ymm6
  966f8b:	c4 c1 7e 7f 77 40    	vmovdqu YMMWORD PTR [r15+0x40],ymm6
  966f91:	48 83 fe 18          	cmp    rsi,0x18
  966f95:	0f 87 b6 02 00 00    	ja     967251 <tokenize_c_counted_raw_no_separators+0xdd1>
  966f9b:	49 83 f9 18          	cmp    r9,0x18
  966f9f:	0f 87 ac 02 00 00    	ja     967251 <tokenize_c_counted_raw_no_separators+0xdd1>
  966fa5:	4d 8d 14 b2          	lea    r10,[r10+rsi*4]
  966fa9:	4f 8d 3c 8f          	lea    r15,[r15+r9*4]
  966fad:	49 01 f5             	add    r13,rsi
  966fb0:	62 d1 75 48 fe cd    	vpaddd zmm1,zmm1,zmm13
  966fb6:	48 ff c1             	inc    rcx
  966fb9:	48 83 f9 08          	cmp    rcx,0x8
  966fbd:	0f 85 ad fe ff ff    	jne    966e70 <tokenize_c_counted_raw_no_separators+0x9f0>
  966fc3:	e9 2d 03 00 00       	jmp    9672f5 <tokenize_c_counted_raw_no_separators+0xe75>
  966fc8:	c4 c1 fb 92 d1       	kmovq  k2,r9
  966fcd:	62 f2 7d 4a 8d 15 e9 	vpermb zmm2{k2},zmm0,ZMMWORD PTR [rip+0xffffffffffaa4fe9]        # 40bfc0 <__abi_tag+0xb404>
  966fd4:	4f aa ff 
  966fd7:	c4 e1 f8 90 94 cc 40 	kmovq  k2,QWORD PTR [rsp+rcx*8+0x1140]
  966fde:	11 00 00 
  966fe1:	41 0f a3 c8          	bt     r8d,ecx
  966fe5:	0f 83 07 ff ff ff    	jae    966ef2 <tokenize_c_counted_raw_no_separators+0xa72>
  966feb:	c4 e1 f8 90 a4 cc 40 	kmovq  k4,QWORD PTR [rsp+rcx*8+0x1240]
  966ff2:	12 00 00 
  966ff5:	c4 e1 f8 90 9c cc 80 	kmovq  k3,QWORD PTR [rsp+rcx*8+0x1180]
  966ffc:	11 00 00 
  966fff:	62 f1 7f 4c 6f 15 f7 	vmovdqu8 zmm2{k4},ZMMWORD PTR [rip+0xffffffffffaa4ff7]        # 40c000 <__abi_tag+0xb444>
  967006:	4f aa ff 
  967009:	62 d1 ed 48 eb c3    	vporq  zmm0,zmm2,zmm11
  96700f:	62 f1 7f 4b 6f d0    	vmovdqu8 zmm2{k3},zmm0
  967015:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  967019:	62 f2 7d c9 63 d0    	vpcompressb zmm0{k1}{z},zmm2
  96701f:	62 d1 fe 48 7f 45 00 	vmovdqu64 ZMMWORD PTR [r13+0x0],zmm0
  967026:	4c 8b 8c cc c0 12 00 	mov    r9,QWORD PTR [rsp+rcx*8+0x12c0]
  96702d:	00 
  96702e:	4c 0b 8c cc 80 12 00 	or     r9,QWORD PTR [rsp+rcx*8+0x1280]
  967035:	00 
  967036:	0f 84 dd fe ff ff    	je     966f19 <tokenize_c_counted_raw_no_separators+0xa99>
  96703c:	48 03 b4 24 00 05 00 	add    rsi,QWORD PTR [rsp+0x500]
  967043:	00 
  967044:	4c 8b b4 cc c0 12 00 	mov    r14,QWORD PTR [rsp+rcx*8+0x12c0]
  96704b:	00 
  96704c:	4c 89 8c 24 40 05 00 	mov    QWORD PTR [rsp+0x540],r9
  967053:	00 
  967054:	f3 4d 0f bc c9       	tzcnt  r9,r9
  967059:	4d 0f a3 ce          	bt     r14,r9
  96705d:	73 10                	jae    96706f <tokenize_c_counted_raw_no_separators+0xbef>
  96705f:	c7 84 24 80 01 00 00 	mov    DWORD PTR [rsp+0x180],0x0
  967066:	00 00 00 00 
  96706a:	e9 8d 01 00 00       	jmp    9671fc <tokenize_c_counted_raw_no_separators+0xd7c>
  96706f:	4a 8d 3c 0e          	lea    rdi,[rsi+r9*1]
  967073:	4c 89 8c 24 80 02 00 	mov    QWORD PTR [rsp+0x280],r9
  96707a:	00 
  96707b:	48 3b 7c 24 30       	cmp    rdi,QWORD PTR [rsp+0x30]
  967080:	4c 8b 4c 24 28       	mov    r9,QWORD PTR [rsp+0x28]
  967085:	0f 9d 84 24 80 01 00 	setge  BYTE PTR [rsp+0x180]
  96708c:	00 
  96708d:	4c 39 cf             	cmp    rdi,r9
  967090:	41 0f 9c c6          	setl   r14b
  967094:	44 84 b4 24 80 01 00 	test   BYTE PTR [rsp+0x180],r14b
  96709b:	00 
  96709c:	0f 84 c6 00 00 00    	je     967168 <tokenize_c_counted_raw_no_separators+0xce8>
  9670a2:	4c 8b 74 24 50       	mov    r14,QWORD PTR [rsp+0x50]
  9670a7:	48 89 bc 24 00 03 00 	mov    QWORD PTR [rsp+0x300],rdi
  9670ae:	00 
  9670af:	45 0f b6 34 3e       	movzx  r14d,BYTE PTR [r14+rdi*1]
  9670b4:	48 ff c7             	inc    rdi
  9670b7:	48 89 bc 24 80 01 00 	mov    QWORD PTR [rsp+0x180],rdi
  9670be:	00 
  9670bf:	41 80 fe 55          	cmp    r14b,0x55
  9670c3:	44 89 f7             	mov    edi,r14d
  9670c6:	44 88 b4 24 40 03 00 	mov    BYTE PTR [rsp+0x340],r14b
  9670cd:	00 
  9670ce:	41 0f 94 c6          	sete   r14b
  9670d2:	41 80 c6 03          	add    r14b,0x3
  9670d6:	40 80 ff 4c          	cmp    dil,0x4c
  9670da:	bf 01 00 00 00       	mov    edi,0x1
  9670df:	45 0f b6 f6          	movzx  r14d,r14b
  9670e3:	44 89 b4 24 80 03 00 	mov    DWORD PTR [rsp+0x380],r14d
  9670ea:	00 
  9670eb:	44 0f 44 f7          	cmove  r14d,edi
  9670ef:	80 bc 24 40 03 00 00 	cmp    BYTE PTR [rsp+0x340],0x75
  9670f6:	75 
  9670f7:	48 8b bc 24 80 01 00 	mov    rdi,QWORD PTR [rsp+0x180]
  9670fe:	00 
  9670ff:	44 89 b4 24 80 05 00 	mov    DWORD PTR [rsp+0x580],r14d
  967106:	00 
  967107:	0f 94 84 24 40 03 00 	sete   BYTE PTR [rsp+0x340]
  96710e:	00 
  96710f:	4c 39 cf             	cmp    rdi,r9
  967112:	41 0f 9c c6          	setl   r14b
  967116:	44 22 b4 24 40 03 00 	and    r14b,BYTE PTR [rsp+0x340]
  96711d:	00 
  96711e:	41 80 fe 01          	cmp    r14b,0x1
  967122:	75 52                	jne    967176 <tokenize_c_counted_raw_no_separators+0xcf6>
  967124:	4c 8b 8c 24 00 03 00 	mov    r9,QWORD PTR [rsp+0x300]
  96712b:	00 
  96712c:	4d 8d 71 02          	lea    r14,[r9+0x2]
  967130:	4c 89 b4 24 80 05 00 	mov    QWORD PTR [rsp+0x580],r14
  967137:	00 
  967138:	4c 8b 74 24 50       	mov    r14,QWORD PTR [rsp+0x50]
  96713d:	43 80 7c 0e 01 38    	cmp    BYTE PTR [r14+r9*1+0x1],0x38
  967143:	44 8b b4 24 80 03 00 	mov    r14d,DWORD PTR [rsp+0x380]
  96714a:	00 
  96714b:	49 89 f9             	mov    r9,rdi
  96714e:	bf 02 00 00 00       	mov    edi,0x2
  967153:	44 0f 44 f7          	cmove  r14d,edi
  967157:	4c 89 cf             	mov    rdi,r9
  96715a:	48 0f 44 bc 24 80 05 	cmove  rdi,QWORD PTR [rsp+0x580]
  967161:	00 00 
  967163:	45 89 f1             	mov    r9d,r14d
  967166:	eb 06                	jmp    96716e <tokenize_c_counted_raw_no_separators+0xcee>
  967168:	48 ff c7             	inc    rdi
  96716b:	41 b1 03             	mov    r9b,0x3
  96716e:	44 89 8c 24 80 05 00 	mov    DWORD PTR [rsp+0x580],r9d
  967175:	00 
  967176:	48 3b 7c 24 30       	cmp    rdi,QWORD PTR [rsp+0x30]
  96717b:	41 b6 03             	mov    r14b,0x3
  96717e:	4c 8b 8c 24 80 02 00 	mov    r9,QWORD PTR [rsp+0x280]
  967185:	00 
  967186:	44 89 b4 24 80 01 00 	mov    DWORD PTR [rsp+0x180],r14d
  96718d:	00 
  96718e:	0f 9c 84 24 40 03 00 	setl   BYTE PTR [rsp+0x340]
  967195:	00 
  967196:	48 3b 7c 24 28       	cmp    rdi,QWORD PTR [rsp+0x28]
  96719b:	0f 9d 84 24 00 03 00 	setge  BYTE PTR [rsp+0x300]
  9671a2:	00 
  9671a3:	44 0f b6 b4 24 00 03 	movzx  r14d,BYTE PTR [rsp+0x300]
  9671aa:	00 00 
  9671ac:	44 0a b4 24 40 03 00 	or     r14b,BYTE PTR [rsp+0x340]
  9671b3:	00 
  9671b4:	44 8b b4 24 80 05 00 	mov    r14d,DWORD PTR [rsp+0x580]
  9671bb:	00 
  9671bc:	75 2d                	jne    9671eb <tokenize_c_counted_raw_no_separators+0xd6b>
  9671be:	4c 8b 4c 24 50       	mov    r9,QWORD PTR [rsp+0x50]
  9671c3:	45 31 f6             	xor    r14d,r14d
  9671c6:	41 80 3c 39 22       	cmp    BYTE PTR [r9+rdi*1],0x22
  9671cb:	4c 8b 8c 24 80 02 00 	mov    r9,QWORD PTR [rsp+0x280]
  9671d2:	00 
  9671d3:	41 0f 94 c6          	sete   r14b
  9671d7:	43 8d 7c b6 03       	lea    edi,[r14+r14*4+0x3]
  9671dc:	44 8b b4 24 80 05 00 	mov    r14d,DWORD PTR [rsp+0x580]
  9671e3:	00 
  9671e4:	89 bc 24 80 01 00 00 	mov    DWORD PTR [rsp+0x180],edi
  9671eb:	8b bc 24 80 01 00 00 	mov    edi,DWORD PTR [rsp+0x180]
  9671f2:	44 00 f7             	add    dil,r14b
  9671f5:	89 bc 24 80 01 00 00 	mov    DWORD PTR [rsp+0x180],edi
  9671fc:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  967203:	c4 62 b0 f5 f7       	bzhi   r14,rdi,r9
  967208:	4c 23 b4 cc 00 11 00 	and    r14,QWORD PTR [rsp+rcx*8+0x1100]
  96720f:	00 
  967210:	48 8b bc 24 40 05 00 	mov    rdi,QWORD PTR [rsp+0x540]
  967217:	00 
  967218:	f3 4d 0f b8 f6       	popcnt r14,r14
  96721d:	47 0f b6 4c 35 00    	movzx  r9d,BYTE PTR [r13+r14*1+0x0]
  967223:	41 80 e1 80          	and    r9b,0x80
  967227:	44 02 8c 24 80 01 00 	add    r9b,BYTE PTR [rsp+0x180]
  96722e:	00 
  96722f:	47 88 4c 35 00       	mov    BYTE PTR [r13+r14*1+0x0],r9b
  967234:	45 31 c9             	xor    r9d,r9d
  967237:	c4 e2 b0 f3 cf       	blsr   r9,rdi
  96723c:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  967241:	48 8b 7c 24 38       	mov    rdi,QWORD PTR [rsp+0x38]
  967246:	0f 84 cd fc ff ff    	je     966f19 <tokenize_c_counted_raw_no_separators+0xa99>
  96724c:	e9 f3 fd ff ff       	jmp    967044 <tokenize_c_counted_raw_no_separators+0xbc4>
  967251:	62 f2 7d 48 31 ed    	vpmovzxbd zmm5,xmm5
  967257:	62 f3 7d 48 39 e6 02 	vextracti32x4 xmm6,zmm4,0x2
  96725e:	62 f3 7d 48 39 e4 03 	vextracti32x4 xmm4,zmm4,0x3
  967265:	62 f2 7d 48 31 c0    	vpmovzxbd zmm0,xmm0
  96726b:	62 f2 7d 48 31 e4    	vpmovzxbd zmm4,xmm4
  967271:	62 f1 75 48 fe ed    	vpaddd zmm5,zmm1,zmm5
  967277:	62 f1 6d 48 fe c0    	vpaddd zmm0,zmm2,zmm0
  96727d:	62 d1 fe 48 7f 6a 01 	vmovdqu64 ZMMWORD PTR [r10+0x40],zmm5
  967284:	62 f2 7d 48 31 ee    	vpmovzxbd zmm5,xmm6
  96728a:	62 f1 75 48 fe e4    	vpaddd zmm4,zmm1,zmm4
  967290:	62 f1 75 48 fe ed    	vpaddd zmm5,zmm1,zmm5
  967296:	62 d1 fe 48 7f 6a 02 	vmovdqu64 ZMMWORD PTR [r10+0x80],zmm5
  96729d:	62 d1 fe 48 7f 62 03 	vmovdqu64 ZMMWORD PTR [r10+0xc0],zmm4
  9672a4:	62 f3 7d 48 39 dc 02 	vextracti32x4 xmm4,zmm3,0x2
  9672ab:	62 d1 fe 48 7f 47 01 	vmovdqu64 ZMMWORD PTR [r15+0x40],zmm0
  9672b2:	62 f3 7d 48 39 db 03 	vextracti32x4 xmm3,zmm3,0x3
  9672b9:	62 f2 7d 48 31 c4    	vpmovzxbd zmm0,xmm4
  9672bf:	62 f1 6d 48 fe c0    	vpaddd zmm0,zmm2,zmm0
  9672c5:	62 d1 fe 48 7f 47 02 	vmovdqu64 ZMMWORD PTR [r15+0x80],zmm0
  9672cc:	62 f2 7d 48 31 c3    	vpmovzxbd zmm0,xmm3
  9672d2:	62 f1 6d 48 fe c0    	vpaddd zmm0,zmm2,zmm0
  9672d8:	62 d1 fe 48 7f 47 03 	vmovdqu64 ZMMWORD PTR [r15+0xc0],zmm0
  9672df:	e9 c1 fc ff ff       	jmp    966fa5 <tokenize_c_counted_raw_no_separators+0xb25>
  9672e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  9672eb:	00 00 00 00 00 
  9672f0:	48 8b 54 24 78       	mov    rdx,QWORD PTR [rsp+0x78]
  9672f5:	48 c1 e0 06          	shl    rax,0x6
  9672f9:	62 71 fd 48 6f 15 fd 	vmovdqa64 zmm10,ZMMWORD PTR [rip+0xffffffffffaa4dfd]        # 40c100 <__abi_tag+0xb544>
  967300:	4d aa ff 
  967303:	48 8d 8f 40 02 00 00 	lea    rcx,[rdi+0x240]
  96730a:	49 c7 c3 ff ff ff ff 	mov    r11,0xffffffffffffffff
  967311:	62 f1 fd 48 6f 54 04 	vmovdqa64 zmm2,ZMMWORD PTR [rsp+rax*1+0xd00]
  967318:	34 
  967319:	62 f1 fd 48 6f 5c 04 	vmovdqa64 zmm3,ZMMWORD PTR [rsp+rax*1+0xd40]
  967320:	35 
  967321:	62 f1 fd 48 6f 7c 04 	vmovdqa64 zmm7,ZMMWORD PTR [rsp+rax*1+0xd80]
  967328:	36 
  967329:	62 f1 fd 48 6f 6c 04 	vmovdqa64 zmm5,ZMMWORD PTR [rsp+rax*1+0xdc0]
  967330:	37 
  967331:	62 71 fd 48 6f 4c 04 	vmovdqa64 zmm9,ZMMWORD PTR [rsp+rax*1+0xe00]
  967338:	38 
  967339:	62 f1 fd 48 6f 44 04 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+rax*1+0xc80]
  967340:	32 
  967341:	62 f1 fd 48 6f 4c 04 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+rax*1+0xcc0]
  967348:	33 
  967349:	62 71 ed 48 6c db    	vpunpcklqdq zmm11,zmm2,zmm3
  96734f:	62 f1 ed 48 6d d3    	vpunpckhqdq zmm2,zmm2,zmm3
  967355:	62 f1 c5 48 6c f5    	vpunpcklqdq zmm6,zmm7,zmm5
  96735b:	62 f1 c5 48 6d dd    	vpunpckhqdq zmm3,zmm7,zmm5
  967361:	62 f1 fd 48 6f 7c 04 	vmovdqa64 zmm7,ZMMWORD PTR [rsp+rax*1+0xe40]
  967368:	39 
  967369:	62 f1 fd 48 6c e1    	vpunpcklqdq zmm4,zmm0,zmm1
  96736f:	62 f1 fd 48 6d c1    	vpunpckhqdq zmm0,zmm0,zmm1
  967375:	62 f1 fd 48 6f c8    	vmovdqa64 zmm1,zmm0
  96737b:	62 f2 ad 48 7e c2    	vpermt2q zmm0,zmm10,zmm2
  967381:	62 71 b5 48 6c c7    	vpunpcklqdq zmm8,zmm9,zmm7
  967387:	62 f1 b5 48 6d ef    	vpunpckhqdq zmm5,zmm9,zmm7
  96738d:	62 71 fd 48 6f 0d 29 	vmovdqa64 zmm9,ZMMWORD PTR [rip+0xffffffffffaa4d29]        # 40c0c0 <__abi_tag+0xb504>
  967394:	4d aa ff 
  967397:	62 f1 fd 48 6f fc    	vmovdqa64 zmm7,zmm4
  96739d:	62 d2 ad 48 7e e3    	vpermt2q zmm4,zmm10,zmm11
  9673a3:	62 f2 b5 48 7e ca    	vpermt2q zmm1,zmm9,zmm2
  9673a9:	62 f1 fd 48 6f d6    	vmovdqa64 zmm2,zmm6
  9673af:	62 d2 b5 48 7e d0    	vpermt2q zmm2,zmm9,zmm8
  9673b5:	62 d2 ad 48 7e f0    	vpermt2q zmm6,zmm10,zmm8
  9673bb:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x640]
  9673c2:	19 
  9673c3:	62 d2 b5 48 7e fb    	vpermt2q zmm7,zmm9,zmm11
  9673c9:	62 71 fd 48 6f db    	vmovdqa64 zmm11,zmm3
  9673cf:	62 f2 ad 48 7e dd    	vpermt2q zmm3,zmm10,zmm5
  9673d5:	62 72 b5 48 7e dd    	vpermt2q zmm11,zmm9,zmm5
  9673db:	62 e3 c5 48 43 ca 44 	vshufi64x2 zmm17,zmm7,zmm2,0x44
  9673e2:	62 53 f5 48 43 eb 44 	vshufi64x2 zmm13,zmm1,zmm11,0x44
  9673e9:	62 53 f5 48 43 db ee 	vshufi64x2 zmm11,zmm1,zmm11,0xee
  9673f0:	62 e3 c5 48 43 e2 ee 	vshufi64x2 zmm20,zmm7,zmm2,0xee
  9673f7:	62 63 fd 48 43 f3 44 	vshufi64x2 zmm30,zmm0,zmm3,0x44
  9673fe:	62 f3 dd 48 43 ce 44 	vshufi64x2 zmm1,zmm4,zmm6,0x44
  967405:	62 f3 dd 48 43 ee ee 	vshufi64x2 zmm5,zmm4,zmm6,0xee
  96740c:	62 e3 fd 48 43 f3 ee 	vshufi64x2 zmm22,zmm0,zmm3,0xee
  967413:	62 e1 fd 48 7f 0b    	vmovdqa64 ZMMWORD PTR [rbx],zmm17
  967419:	62 71 fd 48 7f 6b 02 	vmovdqa64 ZMMWORD PTR [rbx+0x80],zmm13
  967420:	62 f1 fd 48 7f 4b 04 	vmovdqa64 ZMMWORD PTR [rbx+0x100],zmm1
  967427:	62 61 fd 48 7f 73 06 	vmovdqa64 ZMMWORD PTR [rbx+0x180],zmm30
  96742e:	62 e1 fd 48 7f 63 08 	vmovdqa64 ZMMWORD PTR [rbx+0x200],zmm20
  967435:	62 71 fd 48 7f 5b 0a 	vmovdqa64 ZMMWORD PTR [rbx+0x280],zmm11
  96743c:	62 f1 fd 48 7f 6b 0c 	vmovdqa64 ZMMWORD PTR [rbx+0x300],zmm5
  967443:	62 e1 fd 48 7f 73 0e 	vmovdqa64 ZMMWORD PTR [rbx+0x380],zmm22
  96744a:	62 91 fd 48 6f d6    	vmovdqa64 zmm2,zmm30
  967450:	4c 39 f1             	cmp    rcx,r14
  967453:	0f 8f a9 11 00 00    	jg     968602 <tokenize_c_counted_raw_no_separators+0x2182>
  967459:	48 3b 7c 24 30       	cmp    rdi,QWORD PTR [rsp+0x30]
  96745e:	4c 8b 8c 24 98 00 00 	mov    r9,QWORD PTR [rsp+0x98]
  967465:	00 
  967466:	4c 8b 84 24 40 01 00 	mov    r8,QWORD PTR [rsp+0x140]
  96746d:	00 
  96746e:	0f 9c c1             	setl   cl
  967471:	4c 39 f2             	cmp    rdx,r14
  967474:	40 0f 9f c6          	setg   sil
  967478:	40 08 ce             	or     sil,cl
  96747b:	75 28                	jne    9674a5 <tokenize_c_counted_raw_no_separators+0x1025>
  96747d:	62 f2 fd 48 59 05 e9 	vpbroadcastq zmm0,QWORD PTR [rip+0xffffffffffc652e9]        # 5cc770 <x86_effects_unknown+0x300>
  967484:	52 c6 ff 
  967487:	48 8b 75 28          	mov    rsi,QWORD PTR [rbp+0x28]
  96748b:	62 f2 8e 40 27 c9    	vptestnmq k1,zmm30,zmm1
  967491:	48 89 f9             	mov    rcx,rdi
  967494:	48 c1 e9 06          	shr    rcx,0x6
  967498:	62 92 fd 49 55 c6    	vpopcntq zmm0{k1},zmm30
  96749e:	62 f2 7e 48 32 04 0e 	vpmovqb QWORD PTR [rsi+rcx*1],zmm0
  9674a5:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x5c0]
  9674ac:	17 
  9674ad:	48 8d 8c 04 80 0c 00 	lea    rcx,[rsp+rax*1+0xc80]
  9674b4:	00 
  9674b5:	62 61 fd 48 6f 43 10 	vmovdqa64 zmm24,ZMMWORD PTR [rbx+0x400]
  9674bc:	62 f1 fd 48 6f 5b 12 	vmovdqa64 zmm3,ZMMWORD PTR [rbx+0x480]
  9674c3:	62 f1 fd 48 6f 63 14 	vmovdqa64 zmm4,ZMMWORD PTR [rbx+0x500]
  9674ca:	62 71 fd 48 6f 4b 16 	vmovdqa64 zmm9,ZMMWORD PTR [rbx+0x580]
  9674d1:	62 61 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x540],zmm25
  9674d8:	15 
  9674d9:	62 61 fd 48 7f 54 24 	vmovdqa64 ZMMWORD PTR [rsp+0x580],zmm26
  9674e0:	16 
  9674e1:	62 f1 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x340],zmm5
  9674e8:	0d 
  9674e9:	62 e1 fd 48 6f 41 08 	vmovdqa64 zmm16,ZMMWORD PTR [rcx+0x200]
  9674f0:	c4 e1 f9 7e c0       	vmovq  rax,xmm0
  9674f5:	4c 09 c0             	or     rax,r8
  9674f8:	48 89 c6             	mov    rsi,rax
  9674fb:	48 0b b4 24 e0 00 00 	or     rsi,QWORD PTR [rsp+0xe0]
  967502:	00 
  967503:	62 e1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x500],zmm16
  96750a:	14 
  96750b:	0f 85 22 11 00 00    	jne    968633 <tokenize_c_counted_raw_no_separators+0x21b3>
  967511:	62 b2 cd 40 27 c6    	vptestmq k0,zmm22,zmm22
  967517:	c5 fb 93 c8          	kmovd  ecx,k0
  96751b:	84 c9                	test   cl,cl
  96751d:	0f 85 10 11 00 00    	jne    968633 <tokenize_c_counted_raw_no_separators+0x21b3>
  967523:	62 f3 6d 48 25 d2 ff 	vpternlogd zmm2,zmm2,zmm2,0xff
  96752a:	c4 41 09 ef f6       	vpxor  xmm14,xmm14,xmm14
  96752f:	c4 41 01 ef ff       	vpxor  xmm15,xmm15,xmm15
  967534:	62 01 15 00 ef ed    	vpxord xmm29,xmm29,xmm29
  96753a:	62 f1 fd 48 6f 0d 3c 	vmovdqa64 zmm1,ZMMWORD PTR [rip+0xffffffffffaa4c3c]        # 40c180 <__abi_tag+0xb5c4>
  967541:	4c aa ff 
  967544:	48 8b 8b c0 04 00 00 	mov    rcx,QWORD PTR [rbx+0x4c0]
  96754b:	62 f1 fd 48 6f f3    	vmovdqa64 zmm6,zmm3
  967551:	48 8b 83 40 04 00 00 	mov    rax,QWORD PTR [rbx+0x440]
  967558:	c4 e1 f9 6e c1       	vmovq  xmm0,rcx
  96755d:	62 f3 fd 48 03 c3 01 	valignq zmm0,zmm0,zmm3,0x1
  967564:	62 d2 f5 48 7e f0    	vpermt2q zmm6,zmm1,zmm8
  96756a:	62 f3 7d 48 39 d9 03 	vextracti32x4 xmm1,zmm3,0x3
  967571:	62 f3 fd 48 71 c3 3f 	vpshldq zmm0,zmm0,zmm3,0x3f
  967578:	c4 e3 f9 16 ce 01    	vpextrq rsi,xmm1,0x1
  96757e:	48 0f ac ce 3f       	shrd   rsi,rcx,0x3f
  967583:	62 91 fd 48 db f8    	vpandq zmm7,zmm0,zmm24
  967589:	89 c1                	mov    ecx,eax
  96758b:	21 f1                	and    ecx,esi
  96758d:	62 f3 e5 48 71 c6 01 	vpshldq zmm0,zmm3,zmm6,0x1
  967594:	c5 f9 6e c9          	vmovd  xmm1,ecx
  967598:	62 91 fd 48 db f0    	vpandq zmm6,zmm0,zmm24
  96759e:	62 f3 f5 48 03 ce 01 	valignq zmm1,zmm1,zmm6,0x1
  9675a5:	62 f3 f5 48 71 ce 3e 	vpshldq zmm1,zmm1,zmm6,0x3e
  9675ac:	62 f1 f5 48 eb c0    	vporq  zmm0,zmm1,zmm0
  9675b2:	62 f2 7d 48 27 c7    	vptestmd k0,zmm0,zmm7
  9675b8:	c5 f8 98 c0          	kortestw k0,k0
  9675bc:	0f 85 c2 3b 00 00    	jne    96b184 <tokenize_c_counted_raw_no_separators+0x4d04>
  9675c2:	c5 fa 7e 8c 24 00 01 	vmovq  xmm1,QWORD PTR [rsp+0x100]
  9675c9:	00 00 
  9675cb:	62 f1 fd 48 6f dd    	vmovdqa64 zmm3,zmm5
  9675d1:	62 e3 fd 48 3b c0 01 	vextracti64x4 ymm0,zmm16,0x1
  9675d8:	4c 8b 84 24 c0 02 00 	mov    r8,QWORD PTR [rsp+0x2c0]
  9675df:	00 
  9675e0:	62 71 ed 48 db d5    	vpandq zmm10,zmm2,zmm5
  9675e6:	62 b3 fd 48 03 c4 01 	valignq zmm0,zmm0,zmm20,0x1
  9675ed:	62 b3 fd 48 71 c4 3f 	vpshldq zmm0,zmm0,zmm20,0x3f
  9675f4:	62 f2 9d 40 7e d9    	vpermt2q zmm3,zmm28,zmm1
  9675fa:	62 f3 d5 48 71 cb 02 	vpshldq zmm1,zmm5,zmm3,0x2
  967601:	62 d1 f5 48 df d9    	vpandnq zmm3,zmm1,zmm9
  967607:	62 b1 fd 48 6f c9    	vmovdqa64 zmm1,zmm17
  96760d:	62 d2 9d 40 7e c8    	vpermt2q zmm1,zmm28,zmm8
  967613:	62 51 ed 48 db cb    	vpandq zmm9,zmm2,zmm11
  967619:	c5 f9 6e 94 24 00 07 	vmovd  xmm2,DWORD PTR [rsp+0x700]
  967620:	00 00 
  967622:	62 f3 fd 48 25 dd f8 	vpternlogq zmm3,zmm0,zmm5,0xf8
  967629:	62 b3 dd 48 25 d9 fe 	vpternlogq zmm3,zmm4,zmm17,0xfe
  967630:	62 f3 f5 40 71 c1 01 	vpshldq zmm0,zmm17,zmm1,0x1
  967637:	62 b1 7d 08 70 c8 ee 	vpshufd xmm1,xmm16,0xee
  96763e:	62 d3 f5 48 03 cd 01 	valignq zmm1,zmm1,zmm13,0x1
  967645:	62 d3 f5 48 71 cd 3f 	vpshldq zmm1,zmm1,zmm13,0x3f
  96764c:	62 f1 f5 48 db e4    	vpandq zmm4,zmm1,zmm4
  967652:	62 d3 fd 48 25 e5 f2 	vpternlogq zmm4,zmm0,zmm13,0xf2
  967659:	62 f1 e5 48 d4 c4    	vpaddq zmm0,zmm3,zmm4
  96765f:	62 f3 fd 48 1e c3 01 	vpcmpltuq k0,zmm0,zmm3
  967666:	c5 f9 93 c8          	kmovb  ecx,k0
  96766a:	62 92 fd 48 29 c3    	vpcmpeqq k0,zmm0,zmm27
  967670:	c5 f9 93 f0          	kmovb  esi,k0
  967674:	c5 fb 93 f8          	kmovd  edi,k0
  967678:	41 01 f0             	add    r8d,esi
  96767b:	45 8d 04 48          	lea    r8d,[r8+rcx*2]
  96767f:	44 89 c1             	mov    ecx,r8d
  967682:	40 30 f9             	xor    cl,dil
  967685:	c5 fb 92 c1          	kmovd  k0,ecx
  967689:	b9 00 00 00 00       	mov    ecx,0x0
  96768e:	62 f2 fe 48 38 c8    	vpmovm2q zmm1,k0
  967694:	62 f1 fd 48 fb c9    	vpsubq zmm1,zmm0,zmm1
  96769a:	c4 e1 f9 6e c0       	vmovq  xmm0,rax
  96769f:	31 c0                	xor    eax,eax
  9676a1:	41 83 f9 04          	cmp    r9d,0x4
  9676a5:	62 93 fd 48 03 c0 01 	valignq zmm0,zmm0,zmm24,0x1
  9676ac:	0f 94 c0             	sete   al
  9676af:	62 f3 e5 48 25 cc 8c 	vpternlogq zmm1,zmm3,zmm4,0x8c
  9676b6:	62 51 f5 48 df da    	vpandnq zmm11,zmm1,zmm10
  9676bc:	62 93 fd 48 71 c0 3f 	vpshldq zmm0,zmm0,zmm24,0x3f
  9676c3:	62 11 fd 48 db e0    	vpandq zmm12,zmm0,zmm24
  9676c9:	c5 f9 6e c0          	vmovd  xmm0,eax
  9676cd:	44 89 c8             	mov    eax,r9d
  9676d0:	0f 44 c1             	cmove  eax,ecx
  9676d3:	31 c9                	xor    ecx,ecx
  9676d5:	45 85 c9             	test   r9d,r9d
  9676d8:	62 f1 fd 48 f3 d2    	vpsllq zmm2,zmm0,xmm2
  9676de:	40 0f 94 c6          	sete   sil
  9676e2:	31 ff                	xor    edi,edi
  9676e4:	85 c0                	test   eax,eax
  9676e6:	62 51 9d 48 eb e9    	vporq  zmm13,zmm12,zmm9
  9676ec:	40 0f 95 c7          	setne  dil
  9676f0:	62 73 a5 48 25 ef fe 	vpternlogq zmm13,zmm11,zmm7,0xfe
  9676f7:	62 f1 cd 48 df da    	vpandnq zmm3,zmm6,zmm2
  9676fd:	62 f3 cd 48 1e c3 01 	vpcmpltuq k0,zmm6,zmm3
  967704:	62 f2 cd 48 29 cb    	vpcmpeqq k1,zmm6,zmm3
  96770a:	62 f1 cd 48 fb db    	vpsubq zmm3,zmm6,zmm3
  967710:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967714:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967718:	c5 fd 47 c1          	kxorb  k0,k0,k1
  96771c:	62 f2 fe 48 38 e0    	vpmovm2q zmm4,k0
  967722:	62 71 e5 48 d4 c4    	vpaddq zmm8,zmm3,zmm4
  967728:	62 73 cd 48 25 c2 8c 	vpternlogq zmm8,zmm6,zmm2,0x8c
  96772f:	62 f3 bd 48 1e c0 01 	vpcmpltuq k0,zmm8,zmm0
  967736:	62 f2 bd 48 29 c8    	vpcmpeqq k1,zmm8,zmm0
  96773c:	62 f1 bd 48 fb d0    	vpsubq zmm2,zmm8,zmm0
  967742:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967746:	c5 fd 4a c1          	kaddb  k0,k0,k1
  96774a:	c5 fd 47 c1          	kxorb  k0,k0,k1
  96774e:	62 f2 fe 48 38 d8    	vpmovm2q zmm3,k0
  967754:	62 f1 ed 48 d4 d3    	vpaddq zmm2,zmm2,zmm3
  96775a:	62 f3 bd 48 25 d0 fe 	vpternlogq zmm2,zmm8,zmm0,0xfe
  967761:	c5 f9 6e c7          	vmovd  xmm0,edi
  967765:	62 d3 ed 48 25 c5 f2 	vpternlogq zmm0,zmm2,zmm13,0xf2
  96776c:	62 f2 7d 48 27 c0    	vptestmd k0,zmm0,zmm0
  967772:	c5 f8 98 c0          	kortestw k0,k0
  967776:	0f 84 64 04 00 00    	je     967be0 <tokenize_c_counted_raw_no_separators+0x1760>
  96777c:	62 93 8d 40 03 c7 07 	valignq zmm0,zmm30,zmm31,0x7
  967783:	62 93 bd 48 03 e7 07 	valignq zmm4,zmm8,zmm31,0x7
  96778a:	40 88 f1             	mov    cl,sil
  96778d:	62 71 fd 48 7f 7c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x140],zmm15
  967794:	05 
  967795:	62 81 95 48 eb e6    	vporq  zmm20,zmm13,zmm30
  96779b:	62 71 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x280],zmm14
  9677a2:	0a 
  9677a3:	c4 41 09 ef f6       	vpxor  xmm14,xmm14,xmm14
  9677a8:	62 a1 7d 00 ef c0    	vpxord xmm16,xmm16,xmm16
  9677ae:	62 a1 55 00 ef ed    	vpxord xmm21,xmm21,xmm21
  9677b4:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  9677b8:	c5 f9 6e d9          	vmovd  xmm3,ecx
  9677bc:	31 c9                	xor    ecx,ecx
  9677be:	83 f8 01             	cmp    eax,0x1
  9677c1:	62 f3 8d 40 71 c0 01 	vpshldq zmm0,zmm30,zmm0,0x1
  9677c8:	62 73 bd 48 71 fc 01 	vpshldq zmm15,zmm8,zmm4,0x1
  9677cf:	0f 94 c1             	sete   cl
  9677d2:	c5 d9 ef e4          	vpxor  xmm4,xmm4,xmm4
  9677d6:	62 e1 7d 08 6e c9    	vmovd  xmm17,ecx
  9677dc:	31 c9                	xor    ecx,ecx
  9677de:	83 f8 02             	cmp    eax,0x2
  9677e1:	62 f1 fd 48 eb db    	vporq  zmm3,zmm0,zmm3
  9677e7:	0f 94 c1             	sete   cl
  9677ea:	31 c0                	xor    eax,eax
  9677ec:	62 21 fd 48 6f c1    	vmovdqa64 zmm24,zmm17
  9677f2:	62 73 ed 48 25 fb f2 	vpternlogq zmm15,zmm2,zmm3,0xf2
  9677f9:	c4 e2 79 22 1d 3e 4c 	vpmovsxbq xmm3,WORD PTR [rip+0xffffffffffaa4c3e]        # 40c440 <__abi_tag+0xb884>
  967800:	aa ff 
  967802:	62 e1 7d 08 6e d1    	vmovd  xmm18,ecx
  967808:	62 d3 dd 40 1e c7 01 	vpcmpltuq k0,zmm20,zmm15
  96780f:	62 d2 dd 40 29 cf    	vpcmpeqq k1,zmm20,zmm15
  967815:	62 c1 dd 40 fb f7    	vpsubq zmm22,zmm20,zmm15
  96781b:	c5 fd 4a c0          	kaddb  k0,k0,k0
  96781f:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967823:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967827:	62 e1 fd 48 eb db    	vporq  zmm19,zmm0,zmm3
  96782d:	62 f2 fe 48 38 d8    	vpmovm2q zmm3,k0
  967833:	62 f1 cd 40 d4 c3    	vpaddq zmm0,zmm22,zmm3
  967839:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  96783d:	62 a1 fd 48 6f f2    	vmovdqa64 zmm22,zmm18
  967843:	62 c1 fd 48 df fd    	vpandnq zmm23,zmm0,zmm13
  967849:	e9 98 00 00 00       	jmp    9678e6 <tokenize_c_counted_raw_no_separators+0x1466>
  96784e:	66 90                	xchg   ax,ax
  967850:	62 91 cd 40 eb c1    	vporq  zmm0,zmm22,zmm25
  967856:	62 51 c5 40 eb f6    	vporq  zmm14,zmm23,zmm14
  96785c:	62 81 fd 40 eb c0    	vporq  zmm16,zmm16,zmm24
  967862:	62 81 fd 48 eb f6    	vporq  zmm22,zmm0,zmm30
  967868:	62 b3 cd 40 1e c3 01 	vpcmpltuq k0,zmm22,zmm19
  96786f:	62 b2 cd 40 29 cb    	vpcmpeqq k1,zmm22,zmm19
  967875:	62 a1 cd 40 fb f3    	vpsubq zmm22,zmm22,zmm19
  96787b:	c5 fd 4a c0          	kaddb  k0,k0,k0
  96787f:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967883:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967887:	62 e2 fe 48 38 f8    	vpmovm2q zmm23,k0
  96788d:	62 a1 cd 40 d4 f7    	vpaddq zmm22,zmm22,zmm23
  967893:	62 e1 cd 40 df f0    	vpandnq zmm22,zmm22,zmm0
  967899:	62 b3 dd 40 1e c6 01 	vpcmpltuq k0,zmm20,zmm22
  9678a0:	62 b2 dd 40 29 ce    	vpcmpeqq k1,zmm20,zmm22
  9678a6:	62 b1 dd 40 fb c6    	vpsubq zmm0,zmm20,zmm22
  9678ac:	62 01 3d 00 ef c0    	vpxord xmm24,xmm24,xmm24
  9678b2:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9678b6:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9678ba:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9678be:	62 e2 fe 48 38 f0    	vpmovm2q zmm22,k0
  9678c4:	62 b1 fd 48 d4 c6    	vpaddq zmm0,zmm0,zmm22
  9678ca:	62 a1 4d 00 ef f6    	vpxord xmm22,xmm22,xmm22
  9678d0:	62 c1 fd 48 df fd    	vpandnq zmm23,zmm0,zmm13
  9678d6:	62 b2 45 40 27 c7    	vptestmd k0,zmm23,zmm23
  9678dc:	c5 f8 98 c0          	kortestw k0,k0
  9678e0:	0f 84 3a 02 00 00    	je     967b20 <tokenize_c_counted_raw_no_separators+0x16a0>
  9678e6:	62 41 c5 40 db c9    	vpandq zmm25,zmm23,zmm9
  9678ec:	62 41 c5 40 db d3    	vpandq zmm26,zmm23,zmm11
  9678f2:	62 01 bd 40 eb d9    	vporq  zmm27,zmm24,zmm25
  9678f8:	62 b1 ad 40 eb c6    	vporq  zmm0,zmm26,zmm22
  9678fe:	62 61 a5 40 eb e0    	vporq  zmm28,zmm27,zmm0
  967904:	62 92 1d 40 27 c4    	vptestmd k0,zmm28,zmm28
  96790a:	c5 f8 98 c0          	kortestw k0,k0
  96790e:	0f 84 dc 00 00 00    	je     9679f0 <tokenize_c_counted_raw_no_separators+0x1570>
  967914:	62 93 8d 40 1e c3 01 	vpcmpltuq k0,zmm30,zmm27
  96791b:	62 92 8d 40 29 cb    	vpcmpeqq k1,zmm30,zmm27
  967921:	62 01 b5 40 eb ca    	vporq  zmm25,zmm25,zmm26
  967927:	62 01 8d 40 fb db    	vpsubq zmm27,zmm30,zmm27
  96792d:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967931:	62 03 b5 40 03 d7 07 	valignq zmm26,zmm25,zmm31,0x7
  967938:	62 f1 b5 40 eb ed    	vporq  zmm5,zmm25,zmm5
  96793e:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967942:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967946:	62 f2 8d 40 29 c8    	vpcmpeqq k1,zmm30,zmm0
  96794c:	62 03 b5 40 71 d2 01 	vpshldq zmm26,zmm25,zmm26,0x1
  967953:	62 62 fe 48 38 e0    	vpmovm2q zmm28,k0
  967959:	62 f3 8d 40 1e c0 01 	vpcmpltuq k0,zmm30,zmm0
  967960:	62 01 a5 40 d4 dc    	vpaddq zmm27,zmm27,zmm28
  967966:	62 f1 8d 40 fb c0    	vpsubq zmm0,zmm30,zmm0
  96796c:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967970:	62 41 a5 40 db d9    	vpandq zmm27,zmm27,zmm9
  967976:	62 03 cd 40 25 c2 fe 	vpternlogq zmm24,zmm22,zmm26,0xfe
  96797d:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967981:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967985:	62 62 fe 48 38 e0    	vpmovm2q zmm28,k0
  96798b:	62 91 fd 48 d4 c4    	vpaddq zmm0,zmm0,zmm28
  967991:	62 d3 a5 40 25 c2 ec 	vpternlogq zmm0,zmm27,zmm10,0xec
  967998:	62 01 fd 48 eb de    	vporq  zmm27,zmm0,zmm30
  96799e:	62 93 a5 40 1e c0 01 	vpcmpltuq k0,zmm27,zmm24
  9679a5:	62 92 a5 40 29 c8    	vpcmpeqq k1,zmm27,zmm24
  9679ab:	62 81 a5 40 fb f0    	vpsubq zmm22,zmm27,zmm24
  9679b1:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9679b5:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9679b9:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9679bd:	62 62 fe 48 38 c0    	vpmovm2q zmm24,k0
  9679c3:	62 81 cd 40 d4 f0    	vpaddq zmm22,zmm22,zmm24
  9679c9:	62 93 cd 40 25 c6 10 	vpternlogq zmm0,zmm22,zmm30,0x10
  9679d0:	62 93 cd 40 25 e6 f2 	vpternlogq zmm4,zmm22,zmm30,0xf2
  9679d7:	62 83 fd 48 03 f7 07 	valignq zmm22,zmm0,zmm31,0x7
  9679de:	62 f1 fd 48 eb db    	vporq  zmm3,zmm0,zmm3
  9679e4:	62 a3 fd 48 71 f6 01 	vpshldq zmm22,zmm0,zmm22,0x1
  9679eb:	eb 09                	jmp    9679f6 <tokenize_c_counted_raw_no_separators+0x1576>
  9679ed:	0f 1f 00             	nop    DWORD PTR [rax]
  9679f0:	62 a1 4d 00 ef f6    	vpxord xmm22,xmm22,xmm22
  9679f6:	62 61 c5 40 db cf    	vpandq zmm25,zmm23,zmm7
  9679fc:	62 c3 c5 40 25 ec f8 	vpternlogq zmm21,zmm23,zmm12,0xf8
  967a03:	62 92 35 40 27 c1    	vptestmd k0,zmm25,zmm25
  967a09:	c5 f8 98 c0          	kortestw k0,k0
  967a0d:	0f 84 86 fe ff ff    	je     967899 <tokenize_c_counted_raw_no_separators+0x1419>
  967a13:	62 93 b5 40 03 c7 07 	valignq zmm0,zmm25,zmm31,0x7
  967a1a:	62 f3 b5 40 71 c0 03 	vpshldq zmm0,zmm25,zmm0,0x3
  967a21:	62 e1 cd 48 df f8    	vpandnq zmm23,zmm6,zmm0
  967a27:	62 b3 cd 48 1e c7 01 	vpcmpltuq k0,zmm6,zmm23
  967a2e:	62 b2 cd 48 29 cf    	vpcmpeqq k1,zmm6,zmm23
  967a34:	62 a1 cd 48 fb ff    	vpsubq zmm23,zmm6,zmm23
  967a3a:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967a3e:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967a42:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967a46:	62 62 fe 48 38 c0    	vpmovm2q zmm24,k0
  967a4c:	62 81 c5 40 d4 f8    	vpaddq zmm23,zmm23,zmm24
  967a52:	62 e3 cd 48 25 f8 8c 	vpternlogq zmm23,zmm6,zmm0,0x8c
  967a59:	62 93 c5 40 1e c1 01 	vpcmpltuq k0,zmm23,zmm25
  967a60:	62 92 c5 40 29 c9    	vpcmpeqq k1,zmm23,zmm25
  967a66:	62 91 c5 40 fb c1    	vpsubq zmm0,zmm23,zmm25
  967a6c:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967a70:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967a74:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967a78:	62 62 fe 48 38 c0    	vpmovm2q zmm24,k0
  967a7e:	62 01 fd 48 d4 c0    	vpaddq zmm24,zmm0,zmm24
  967a84:	62 93 c5 40 03 c7 07 	valignq zmm0,zmm23,zmm31,0x7
  967a8b:	62 03 c5 40 25 c1 fe 	vpternlogq zmm24,zmm23,zmm25,0xfe
  967a92:	62 92 3d 40 27 c6    	vptestmd k0,zmm24,zmm30
  967a98:	62 63 c5 40 71 c8 01 	vpshldq zmm25,zmm23,zmm0,0x1
  967a9f:	c5 f8 98 c0          	kortestw k0,k0
  967aa3:	0f 84 a7 fd ff ff    	je     967850 <tokenize_c_counted_raw_no_separators+0x13d0>
  967aa9:	62 91 8d 40 df c1    	vpandnq zmm0,zmm30,zmm25
  967aaf:	b0 01                	mov    al,0x1
  967ab1:	62 f3 8d 40 1e c0 01 	vpcmpltuq k0,zmm30,zmm0
  967ab8:	62 f2 8d 40 29 c8    	vpcmpeqq k1,zmm30,zmm0
  967abe:	62 f1 8d 40 fb c0    	vpsubq zmm0,zmm30,zmm0
  967ac4:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967ac8:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967acc:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967ad0:	62 62 fe 48 38 d0    	vpmovm2q zmm26,k0
  967ad6:	62 91 fd 48 d4 c2    	vpaddq zmm0,zmm0,zmm26
  967adc:	62 91 fd 48 ef c6    	vpxorq zmm0,zmm0,zmm30
  967ae2:	62 93 b5 40 25 c0 fe 	vpternlogq zmm0,zmm25,zmm24,0xfe
  967ae9:	62 f1 fd 48 df ed    	vpandnq zmm5,zmm0,zmm5
  967aef:	62 f1 fd 48 df db    	vpandnq zmm3,zmm0,zmm3
  967af5:	62 f1 fd 48 df e4    	vpandnq zmm4,zmm0,zmm4
  967afb:	62 a1 fd 48 df ed    	vpandnq zmm21,zmm0,zmm21
  967b01:	62 a1 fd 48 df c0    	vpandnq zmm16,zmm0,zmm16
  967b07:	62 a1 fd 48 df f6    	vpandnq zmm22,zmm0,zmm22
  967b0d:	e9 3e fd ff ff       	jmp    967850 <tokenize_c_counted_raw_no_separators+0x13d0>
  967b12:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  967b19:	1f 84 00 00 00 00 00 
  967b20:	a8 01                	test   al,0x1
  967b22:	0f 85 b0 21 00 00    	jne    969cd8 <tokenize_c_counted_raw_no_separators+0x3858>
  967b28:	41 8d 41 ff          	lea    eax,[r9-0x1]
  967b2c:	31 c9                	xor    ecx,ecx
  967b2e:	62 f1 fd 40 eb d2    	vporq  zmm2,zmm16,zmm2
  967b34:	62 51 8d 48 eb c0    	vporq  zmm8,zmm14,zmm8
  967b3a:	62 e1 fd 48 6f 44 24 	vmovdqa64 zmm16,ZMMWORD PTR [rsp+0x500]
  967b41:	14 
  967b42:	62 71 fd 48 6f 74 24 	vmovdqa64 zmm14,ZMMWORD PTR [rsp+0x280]
  967b49:	0a 
  967b4a:	62 71 fd 48 6f 7c 24 	vmovdqa64 zmm15,ZMMWORD PTR [rsp+0x140]
  967b51:	05 
  967b52:	62 71 dd 48 eb d3    	vporq  zmm10,zmm4,zmm3
  967b58:	83 f8 02             	cmp    eax,0x2
  967b5b:	0f 92 c1             	setb   cl
  967b5e:	31 c0                	xor    eax,eax
  967b60:	41 83 f9 03          	cmp    r9d,0x3
  967b64:	0f 94 c0             	sete   al
  967b67:	c5 f9 6e c1          	vmovd  xmm0,ecx
  967b6b:	c5 f9 6e f0          	vmovd  xmm6,eax
  967b6f:	62 f1 d5 48 eb c0    	vporq  zmm0,zmm5,zmm0
  967b75:	62 f1 d5 40 eb f6    	vporq  zmm6,zmm21,zmm6
  967b7b:	62 f3 8d 40 1e c6 01 	vpcmpltuq k0,zmm30,zmm6
  967b82:	62 f2 8d 40 29 ce    	vpcmpeqq k1,zmm30,zmm6
  967b88:	62 f1 8d 40 fb f6    	vpsubq zmm6,zmm30,zmm6
  967b8e:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967b92:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967b96:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967b9a:	62 f2 ad 48 29 c8    	vpcmpeqq k1,zmm10,zmm0
  967ba0:	62 72 fe 48 38 c8    	vpmovm2q zmm9,k0
  967ba6:	62 f3 ad 48 1e c0 01 	vpcmpltuq k0,zmm10,zmm0
  967bad:	62 f1 ad 48 fb c0    	vpsubq zmm0,zmm10,zmm0
  967bb3:	62 d1 cd 48 d4 f1    	vpaddq zmm6,zmm6,zmm9
  967bb9:	c5 fd 4a c0          	kaddb  k0,k0,k0
  967bbd:	62 f1 8d 40 df f6    	vpandnq zmm6,zmm30,zmm6
  967bc3:	c5 fd 4a c1          	kaddb  k0,k0,k1
  967bc7:	c5 fd 47 c1          	kxorb  k0,k0,k1
  967bcb:	62 72 fe 48 38 c8    	vpmovm2q zmm9,k0
  967bd1:	62 d1 fd 48 d4 c1    	vpaddq zmm0,zmm0,zmm9
  967bd7:	62 71 fd 48 eb cb    	vporq  zmm9,zmm0,zmm3
  967bdd:	eb 16                	jmp    967bf5 <tokenize_c_counted_raw_no_separators+0x1775>
  967bdf:	90                   	nop
  967be0:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  967be4:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  967be8:	c5 d9 ef e4          	vpxor  xmm4,xmm4,xmm4
  967bec:	c4 41 31 ef c9       	vpxor  xmm9,xmm9,xmm9
  967bf1:	c5 c9 ef f6          	vpxor  xmm6,xmm6,xmm6
  967bf5:	62 d3 7d 48 39 d2 03 	vextracti32x4 xmm10,zmm2,0x3
  967bfc:	62 73 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm8,0x3
  967c03:	c4 63 f9 16 d0 01    	vpextrq rax,xmm10,0x1
  967c09:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  967c0f:	c4 e2 f0 f2 f0       	andn   rsi,rcx,rax
  967c14:	4c 39 f2             	cmp    rdx,r14
  967c17:	7c 09                	jl     967c22 <tokenize_c_counted_raw_no_separators+0x17a2>
  967c19:	48 85 f6             	test   rsi,rsi
  967c1c:	0f 88 62 35 00 00    	js     96b184 <tokenize_c_counted_raw_no_separators+0x4d04>
  967c22:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x5c0]
  967c29:	17 
  967c2a:	4d 89 de             	mov    r14,r11
  967c2d:	ba 04 00 00 00       	mov    edx,0x4
  967c32:	48 89 b4 24 40 06 00 	mov    QWORD PTR [rsp+0x640],rsi
  967c39:	00 
  967c3a:	c4 c3 f9 16 c3 01    	vpextrq r11,xmm0,0x1
  967c40:	62 f3 7d 48 39 d8 03 	vextracti32x4 xmm0,zmm3,0x3
  967c47:	c4 e3 f9 16 c0 01    	vpextrq rax,xmm0,0x1
  967c4d:	62 73 7d 48 39 c8 03 	vextracti32x4 xmm0,zmm9,0x3
  967c54:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  967c5a:	48 09 f0             	or     rax,rsi
  967c5d:	62 f3 7d 48 39 f0 03 	vextracti32x4 xmm0,zmm6,0x3
  967c64:	c4 e2 f8 f2 c9       	andn   rcx,rax,rcx
  967c69:	c4 e3 f9 16 c0 01    	vpextrq rax,xmm0,0x1
  967c6f:	62 f3 7d 48 39 f8 03 	vextracti32x4 xmm0,zmm7,0x3
  967c76:	48 c1 e8 3f          	shr    rax,0x3f
  967c7a:	c5 a9 db c0          	vpand  xmm0,xmm10,xmm0
  967c7e:	48 85 f6             	test   rsi,rsi
  967c81:	8d 04 40             	lea    eax,[rax+rax*2]
  967c84:	c4 e3 f9 16 c7 01    	vpextrq rdi,xmm0,0x1
  967c8a:	48 89 fe             	mov    rsi,rdi
  967c8d:	0f 48 c2             	cmovs  eax,edx
  967c90:	48 c1 ee 3e          	shr    rsi,0x3e
  967c94:	48 c1 ef 3f          	shr    rdi,0x3f
  967c98:	48 83 fe 01          	cmp    rsi,0x1
  967c9c:	83 df ff             	sbb    edi,0xffffffff
  967c9f:	48 85 c9             	test   rcx,rcx
  967ca2:	0f 88 3c 0e 00 00    	js     968ae4 <tokenize_c_counted_raw_no_separators+0x2664>
  967ca8:	31 f6                	xor    esi,esi
  967caa:	62 f3 b5 48 25 f2 fe 	vpternlogq zmm6,zmm9,zmm2,0xfe
  967cb1:	62 71 fd 48 6f 53 20 	vmovdqa64 zmm10,ZMMWORD PTR [rbx+0x800]
  967cb8:	62 73 ad 48 25 fe 54 	vpternlogq zmm15,zmm10,zmm6,0x54
  967cbf:	62 53 ed 48 25 fe f8 	vpternlogq zmm15,zmm2,zmm14,0xf8
  967cc6:	62 d2 05 48 27 c7    	vptestmd k0,zmm15,zmm15
  967ccc:	c5 f8 98 c0          	kortestw k0,k0
  967cd0:	0f 85 ae 34 00 00    	jne    96b184 <tokenize_c_counted_raw_no_separators+0x4d04>
  967cd6:	62 61 fd 48 6f 5b 0e 	vmovdqa64 zmm27,ZMMWORD PTR [rbx+0x380]
  967cdd:	62 f1 fd 48 6f 3b    	vmovdqa64 zmm7,ZMMWORD PTR [rbx]
  967ce3:	62 e1 fd 48 6f 53 02 	vmovdqa64 zmm18,ZMMWORD PTR [rbx+0x80]
  967cea:	62 71 fd 48 6f 5b 04 	vmovdqa64 zmm11,ZMMWORD PTR [rbx+0x100]
  967cf1:	62 71 fd 48 6f 6b 06 	vmovdqa64 zmm13,ZMMWORD PTR [rbx+0x180]
  967cf8:	62 71 fd 48 6f 73 0a 	vmovdqa64 zmm14,ZMMWORD PTR [rbx+0x280]
  967cff:	62 71 fd 48 6f 63 0c 	vmovdqa64 zmm12,ZMMWORD PTR [rbx+0x300]
  967d06:	62 71 fd 48 6f 7b 12 	vmovdqa64 zmm15,ZMMWORD PTR [rbx+0x480]
  967d0d:	62 71 fd 48 6f 4b 14 	vmovdqa64 zmm9,ZMMWORD PTR [rbx+0x500]
  967d14:	62 61 fd 48 6f 43 18 	vmovdqa64 zmm24,ZMMWORD PTR [rbx+0x600]
  967d1b:	62 e1 fd 48 6f 73 1a 	vmovdqa64 zmm22,ZMMWORD PTR [rbx+0x680]
  967d22:	62 e1 fd 48 6f 7b 1c 	vmovdqa64 zmm23,ZMMWORD PTR [rbx+0x700]
  967d29:	62 a3 7d 48 39 c1 02 	vextracti32x4 xmm17,zmm16,0x2
  967d30:	44 89 84 24 98 00 00 	mov    DWORD PTR [rsp+0x98],r8d
  967d37:	00 
  967d38:	48 89 bc 24 00 07 00 	mov    QWORD PTR [rsp+0x700],rdi
  967d3f:	00 
  967d40:	62 03 cd 48 25 eb 02 	vpternlogq zmm29,zmm6,zmm27,0x2
  967d47:	62 92 15 40 27 c5    	vptestmd k0,zmm29,zmm29
  967d4d:	c5 f8 98 c0          	kortestw k0,k0
  967d51:	0f 85 81 0e 00 00    	jne    968bd8 <tokenize_c_counted_raw_no_separators+0x2758>
  967d57:	62 e3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm16,0x3
  967d5e:	c4 c1 f9 7e c0       	vmovq  r8,xmm0
  967d63:	c4 c1 f9 6e c0       	vmovq  xmm0,r8
  967d68:	62 f2 5d 48 27 c4    	vptestmd k0,zmm4,zmm4
  967d6e:	89 f7                	mov    edi,esi
  967d70:	62 f3 fd 48 03 c3 01 	valignq zmm0,zmm0,zmm3,0x1
  967d77:	c5 f8 98 c0          	kortestw k0,k0
  967d7b:	0f 94 c1             	sete   cl
  967d7e:	40 80 f7 01          	xor    dil,0x1
  967d82:	62 e3 fd 48 71 c3 3f 	vpshldq zmm16,zmm0,zmm3,0x3f
  967d89:	62 e3 9d 48 25 c5 80 	vpternlogq zmm16,zmm12,zmm5,0x80
  967d90:	40 84 f9             	test   cl,dil
  967d93:	0f 84 85 10 00 00    	je     968e1e <tokenize_c_counted_raw_no_separators+0x299e>
  967d99:	62 e1 fd 48 6f 25 1d 	vmovdqa64 zmm20,ZMMWORD PTR [rip+0xffffffffffaa451d]        # 40c2c0 <__abi_tag+0xb704>
  967da0:	45 aa ff 
  967da3:	62 71 fd 48 7f 7c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x280],zmm15
  967daa:	0a 
  967dab:	62 11 fd 48 6f c3    	vmovdqa64 zmm8,zmm27
  967db1:	62 11 fd 48 6f fd    	vmovdqa64 zmm15,zmm29
  967db7:	62 61 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x180],zmm30
  967dbe:	06 
  967dbf:	40 f6 c6 01          	test   sil,0x1
  967dc3:	75 06                	jne    967dcb <tokenize_c_counted_raw_no_separators+0x194b>
  967dc5:	62 a1 5d 00 ef e4    	vpxord xmm20,xmm20,xmm20
  967dcb:	48 8b 8b 40 06 00 00 	mov    rcx,QWORD PTR [rbx+0x640]
  967dd2:	62 e1 fe 08 7e 6c 24 	vmovq  xmm21,QWORD PTR [rsp+0xf8]
  967dd9:	1f 
  967dda:	62 f1 fd 48 6f c6    	vmovdqa64 zmm0,zmm6
  967de0:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
  967de6:	62 61 fd 08 6e c9    	vmovq  xmm25,rcx
  967dec:	62 61 7d 08 6e d1    	vmovd  xmm26,ecx
  967df2:	62 03 b5 40 03 c8 01 	valignq zmm25,zmm25,zmm24,0x1
  967df9:	62 03 b5 40 71 c0 3f 	vpshldq zmm24,zmm25,zmm24,0x3f
  967e00:	62 91 35 00 72 d2 01 	vpsrld xmm25,xmm26,0x1
  967e07:	62 b3 f5 48 25 c5 fe 	vpternlogq zmm0,zmm1,zmm21,0xfe
  967e0e:	62 03 b5 40 03 c8 01 	valignq zmm25,zmm25,zmm24,0x1
  967e15:	62 03 b5 40 71 c8 3e 	vpshldq zmm25,zmm25,zmm24,0x3e
  967e1c:	62 01 b5 40 db c0    	vpandq zmm24,zmm25,zmm24
  967e22:	62 61 fe 08 7e 8b 40 	vmovq  xmm25,QWORD PTR [rbx+0x740]
  967e29:	07 00 00 
  967e2c:	62 01 fd 48 df e8    	vpandnq zmm29,zmm0,zmm24
  967e32:	62 f1 bd 40 eb c0    	vporq  zmm0,zmm24,zmm0
  967e38:	62 61 fe 08 7e 83 c0 	vmovq  xmm24,QWORD PTR [rbx+0x6c0]
  967e3f:	06 00 00 
  967e42:	62 23 95 40 03 db 07 	valignq zmm27,zmm29,zmm19,0x7
  967e49:	62 03 95 40 71 e3 02 	vpshldq zmm28,zmm29,zmm27,0x2
  967e50:	62 23 b5 40 03 cf 01 	valignq zmm25,zmm25,zmm23,0x1
  967e57:	62 23 bd 40 03 c6 01 	valignq zmm24,zmm24,zmm22,0x1
  967e5e:	62 a3 b5 40 71 ff 3e 	vpshldq zmm23,zmm25,zmm23,0x3e
  967e65:	62 03 95 40 71 cb 01 	vpshldq zmm25,zmm29,zmm27,0x1
  967e6c:	62 03 95 40 71 db 03 	vpshldq zmm27,zmm29,zmm27,0x3
  967e73:	62 23 bd 40 71 fe 3f 	vpshldq zmm31,zmm24,zmm22,0x3f
  967e7a:	62 21 fd 48 df f7    	vpandnq zmm30,zmm0,zmm23
  967e80:	62 23 fd 48 25 ff 10 	vpternlogq zmm31,zmm0,zmm23,0x10
  967e87:	62 b3 8d 40 03 c3 07 	valignq zmm0,zmm30,zmm19,0x7
  967e8e:	62 23 85 40 03 c3 07 	valignq zmm24,zmm31,zmm19,0x7
  967e95:	62 81 85 40 eb f6    	vporq  zmm22,zmm31,zmm30
  967e9b:	62 63 8d 40 71 d0 02 	vpshldq zmm26,zmm30,zmm0,0x2
  967ea2:	62 e1 bd 40 eb f8    	vporq  zmm23,zmm24,zmm0
  967ea8:	62 91 cd 40 eb c5    	vporq  zmm0,zmm22,zmm29
  967eae:	62 a3 cd 40 71 ff 01 	vpshldq zmm23,zmm22,zmm23,0x1
  967eb5:	62 03 c5 40 25 e1 fe 	vpternlogq zmm28,zmm23,zmm25,0xfe
  967ebc:	62 03 ad 40 25 e3 fe 	vpternlogq zmm28,zmm26,zmm27,0xfe
  967ec3:	62 f2 1d 40 27 c0    	vptestmd k0,zmm28,zmm0
  967ec9:	c5 f8 98 c0          	kortestw k0,k0
  967ecd:	0f 85 ea 12 00 00    	jne    9691bd <tokenize_c_counted_raw_no_separators+0x2d3d>
  967ed3:	62 81 fd 48 6f fd    	vmovdqa64 zmm23,zmm29
  967ed9:	62 01 fd 48 6f ce    	vmovdqa64 zmm25,zmm30
  967edf:	62 81 fd 48 6f f7    	vmovdqa64 zmm22,zmm31
  967ee5:	62 61 fd 48 6f 35 51 	vmovdqa64 zmm30,ZMMWORD PTR [rip+0xffffffffffaa4251]        # 40c140 <__abi_tag+0xb584>
  967eec:	42 aa ff 
  967eef:	62 e3 7d 48 39 f0 03 	vextracti32x4 xmm0,zmm22,0x3
  967ef6:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  967efc:	48 85 c9             	test   rcx,rcx
  967eff:	78 1f                	js     967f20 <tokenize_c_counted_raw_no_separators+0x1aa0>
  967f01:	62 63 7d 48 39 c8 03 	vextracti32x4 xmm0,zmm25,0x3
  967f08:	c4 e3 f9 16 c6 01    	vpextrq rsi,xmm0,0x1
  967f0e:	48 c1 ee 3e          	shr    rsi,0x3e
  967f12:	74 1c                	je     967f30 <tokenize_c_counted_raw_no_separators+0x1ab0>
  967f14:	31 c9                	xor    ecx,ecx
  967f16:	83 fe 01             	cmp    esi,0x1
  967f19:	0f 95 c1             	setne  cl
  967f1c:	ff c1                	inc    ecx
  967f1e:	eb 40                	jmp    967f60 <tokenize_c_counted_raw_no_separators+0x1ae0>
  967f20:	b9 01 00 00 00       	mov    ecx,0x1
  967f25:	eb 39                	jmp    967f60 <tokenize_c_counted_raw_no_separators+0x1ae0>
  967f27:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  967f2e:	00 00 
  967f30:	62 e3 7d 48 39 f8 03 	vextracti32x4 xmm0,zmm23,0x3
  967f37:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  967f3d:	48 c1 e9 3d          	shr    rcx,0x3d
  967f41:	0f 84 96 06 00 00    	je     9685dd <tokenize_c_counted_raw_no_separators+0x215d>
  967f47:	f3 48 0f bd f1       	lzcnt  rsi,rcx
  967f4c:	b9 40 00 00 00       	mov    ecx,0x40
  967f51:	29 f1                	sub    ecx,esi
  967f53:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  967f5a:	84 00 00 00 00 00 
  967f60:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  967f67:	89 ce                	mov    esi,ecx
  967f69:	fe c9                	dec    cl
  967f6b:	c4 e2 c8 f5 d2       	bzhi   rdx,rdx,rsi
  967f70:	48 89 94 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],rdx
  967f77:	00 
  967f78:	ba 01 00 00 00       	mov    edx,0x1
  967f7d:	c4 e2 f1 f7 f2       	shlx   rsi,rdx,rcx
  967f82:	62 d1 b5 40 db c1    	vpandq zmm0,zmm25,zmm9
  967f88:	62 a3 fd 48 03 db 07 	valignq zmm19,zmm0,zmm19,0x7
  967f8f:	62 23 fd 48 71 eb 01 	vpshldq zmm29,zmm0,zmm19,0x1
  967f96:	62 a3 fd 48 71 db 02 	vpshldq zmm19,zmm0,zmm19,0x2
  967f9d:	62 81 e5 40 eb dd    	vporq  zmm19,zmm19,zmm29
  967fa3:	62 a3 cd 48 25 dd fe 	vpternlogq zmm19,zmm6,zmm21,0xfe
  967faa:	62 f3 e5 40 25 c8 10 	vpternlogq zmm1,zmm19,zmm0,0x10
  967fb1:	c5 fa 7e 84 24 c0 04 	vmovq  xmm0,QWORD PTR [rsp+0x4c0]
  967fb8:	00 00 
  967fba:	62 e1 fd 48 6f d9    	vmovdqa64 zmm19,zmm1
  967fc0:	62 e2 8d 40 7e d8    	vpermt2q zmm19,zmm30,zmm0
  967fc6:	62 b3 f5 48 71 c3 01 	vpshldq zmm0,zmm1,zmm19,0x1
  967fcd:	62 61 fd 48 df e9    	vpandnq zmm29,zmm0,zmm1
  967fd3:	62 83 b5 48 25 d5 02 	vpternlogq zmm18,zmm9,zmm29,0x2
  967fda:	62 b2 6d 40 27 c2    	vptestmd k0,zmm18,zmm18
  967fe0:	c5 f8 98 c0          	kortestw k0,k0
  967fe4:	0f 85 9a 31 00 00    	jne    96b184 <tokenize_c_counted_raw_no_separators+0x4d04>
  967fea:	62 73 7d 48 39 e0 03 	vextracti32x4 xmm0,zmm12,0x3
  967ff1:	89 84 24 40 03 00 00 	mov    DWORD PTR [rsp+0x340],eax
  967ff8:	62 e1 fd 48 6f df    	vmovdqa64 zmm19,zmm7
  967ffe:	62 e3 f5 48 25 de 10 	vpternlogq zmm19,zmm1,zmm6,0x10
  968005:	48 8b 94 24 40 02 00 	mov    rdx,QWORD PTR [rsp+0x240]
  96800c:	00 
  96800d:	62 c1 fd 08 7e c9    	vmovq  r9,xmm17
  968013:	4c 89 9c 24 40 01 00 	mov    QWORD PTR [rsp+0x140],r11
  96801a:	00 
  96801b:	c4 e3 f9 16 c0 01    	vpextrq rax,xmm0,0x1
  968021:	c5 fa 7e 84 24 38 02 	vmovq  xmm0,QWORD PTR [rsp+0x238]
  968028:	00 00 
  96802a:	62 a1 fd 48 6f d3    	vmovdqa64 zmm18,zmm19
  968030:	49 d1 e9             	shr    r9,1
  968033:	45 21 c1             	and    r9d,r8d
  968036:	48 89 c1             	mov    rcx,rax
  968039:	48 c1 e9 3e          	shr    rcx,0x3e
  96803d:	c4 e2 70 f2 8b c0 05 	andn   ecx,ecx,DWORD PTR [rbx+0x5c0]
  968044:	00 00 
  968046:	44 0b 8b 40 05 00 00 	or     r9d,DWORD PTR [rbx+0x540]
  96804d:	62 e3 7d 08 16 cb 02 	vpextrd ebx,xmm17,0x2
  968054:	62 a3 7d 48 39 d9 03 	vextracti32x4 xmm17,zmm19,0x3
  96805b:	44 09 c3             	or     ebx,r8d
  96805e:	62 c3 fd 08 16 cb 01 	vpextrq r11,xmm17,0x1
  968065:	4c 89 9c 24 38 02 00 	mov    QWORD PTR [rsp+0x238],r11
  96806c:	00 
  96806d:	62 e2 8d 40 7e d0    	vpermt2q zmm18,zmm30,zmm0
  968073:	62 b3 e5 40 71 c2 01 	vpshldq zmm0,zmm19,zmm18,0x1
  96807a:	62 e1 fd 48 6f 54 24 	vmovdqa64 zmm18,ZMMWORD PTR [rsp+0x500]
  968081:	14 
  968082:	62 21 fd 48 df fb    	vpandnq zmm31,zmm0,zmm19
  968088:	62 a3 ed 40 03 d3 01 	valignq zmm18,zmm18,zmm19,0x1
  96808f:	62 a3 ed 40 71 d3 3f 	vpshldq zmm18,zmm18,zmm19,0x3f
  968096:	62 a1 ed 40 df d3    	vpandnq zmm18,zmm18,zmm19
  96809c:	62 e1 fd 08 7e d7    	vmovq  rdi,xmm18
  9680a2:	c4 e2 e8 f2 ff       	andn   rdi,rdx,rdi
  9680a7:	48 8b 94 24 b8 00 00 	mov    rdx,QWORD PTR [rsp+0xb8]
  9680ae:	00 
  9680af:	62 63 ed 00 22 f7 00 	vpinsrq xmm30,xmm18,rdi,0x0
  9680b6:	c4 e1 f9 7e ef       	vmovq  rdi,xmm5
  9680bb:	62 03 6d 40 38 f6 00 	vinserti32x4 zmm30,zmm18,xmm30,0x0
  9680c2:	c4 e2 e8 f2 ff       	andn   rdi,rdx,rdi
  9680c7:	83 e3 07             	and    ebx,0x7
  9680ca:	0f 94 c2             	sete   dl
  9680cd:	4d 85 db             	test   r11,r11
  9680d0:	62 e3 d5 08 22 d7 00 	vpinsrq xmm18,xmm5,rdi,0x0
  9680d7:	41 0f 99 c6          	setns  r14b
  9680db:	62 a3 55 48 38 d2 00 	vinserti32x4 zmm18,zmm5,xmm18,0x0
  9680e2:	41 08 d6             	or     r14b,dl
  9680e5:	41 80 fe 01          	cmp    r14b,0x1
  9680e9:	0f 85 9c 12 00 00    	jne    96938b <tokenize_c_counted_raw_no_separators+0x2f0b>
  9680ef:	62 f2 fd 48 27 c5    	vptestmq k0,zmm0,zmm5
  9680f5:	c5 fb 93 f8          	kmovd  edi,k0
  9680f9:	40 84 ff             	test   dil,dil
  9680fc:	0f 85 89 12 00 00    	jne    96938b <tokenize_c_counted_raw_no_separators+0x2f0b>
  968102:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  968106:	62 a1 75 00 ef c9    	vpxord xmm17,xmm17,xmm17
  96810c:	31 db                	xor    ebx,ebx
  96810e:	48 c7 84 24 40 02 00 	mov    QWORD PTR [rsp+0x240],0x0
  968115:	00 00 00 00 00 
  96811a:	62 53 c5 48 25 dd fe 	vpternlogq zmm11,zmm7,zmm13,0xfe
  968121:	62 f1 ed 48 df 54 24 	vpandnq zmm2,zmm2,ZMMWORD PTR [rsp+0x180]
  968128:	06 
  968129:	62 a1 b5 40 eb ff    	vporq  zmm23,zmm25,zmm23
  96812f:	62 93 d5 40 25 f4 fe 	vpternlogq zmm6,zmm21,zmm28,0xfe
  968136:	48 8b 94 24 b8 00 00 	mov    rdx,QWORD PTR [rsp+0xb8]
  96813d:	00 
  96813e:	4c 8b 74 24 38       	mov    r14,QWORD PTR [rsp+0x38]
  968143:	62 53 a5 48 25 e6 fe 	vpternlogq zmm12,zmm11,zmm14,0xfe
  96814a:	62 21 c5 40 eb ce    	vporq  zmm25,zmm23,zmm22
  968150:	62 53 9d 48 25 d0 fe 	vpternlogq zmm10,zmm12,zmm8,0xfe
  968157:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x500]
  96815e:	14 
  96815f:	62 93 f5 48 25 f1 fe 	vpternlogq zmm6,zmm1,zmm25,0xfe
  968166:	62 03 95 40 25 f9 fe 	vpternlogq zmm31,zmm29,zmm25,0xfe
  96816d:	62 d3 85 48 25 f2 0d 	vpternlogq zmm6,zmm15,zmm10,0xd
  968174:	62 63 ed 40 25 fe fe 	vpternlogq zmm31,zmm18,zmm6,0xfe
  96817b:	62 61 fd 08 7e ff    	vmovq  rdi,xmm31
  968181:	c4 e2 e8 f2 ff       	andn   rdi,rdx,rdi
  968186:	62 f3 85 00 22 c7 00 	vpinsrq xmm0,xmm31,rdi,0x0
  96818d:	62 f2 6d 48 27 c2    	vptestmd k0,zmm2,zmm2
  968193:	62 73 05 40 38 d0 00 	vinserti32x4 zmm10,zmm31,xmm0,0x0
  96819a:	c5 f8 98 c0          	kortestw k0,k0
  96819e:	74 4e                	je     9681ee <tokenize_c_counted_raw_no_separators+0x1d6e>
  9681a0:	4c 89 ef             	mov    rdi,r13
  9681a3:	48 2b bc 24 b0 00 00 	sub    rdi,QWORD PTR [rsp+0xb0]
  9681aa:	00 
  9681ab:	48 8d 94 24 11 2c 00 	lea    rdx,[rsp+0x2c11]
  9681b2:	00 
  9681b3:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  9681b7:	c5 fe 7f 42 0f       	vmovdqu YMMWORD PTR [rdx+0xf],ymm0
  9681bc:	c5 fe 7f 02          	vmovdqu YMMWORD PTR [rdx],ymm0
  9681c0:	62 f1 fd 48 7f 94 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2b80],zmm2
  9681c7:	80 2b 00 00 
  9681cb:	62 71 fd 48 7f 94 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2bc0],zmm10
  9681d2:	c0 2b 00 00 
  9681d6:	4c 89 b4 24 00 2c 00 	mov    QWORD PTR [rsp+0x2c00],r14
  9681dd:	00 
  9681de:	48 89 bc 24 08 2c 00 	mov    QWORD PTR [rsp+0x2c08],rdi
  9681e5:	00 
  9681e6:	c6 84 24 10 2c 00 00 	mov    BYTE PTR [rsp+0x2c10],0x1
  9681ed:	01 
  9681ee:	c5 79 7e c7          	vmovd  edi,xmm8
  9681f2:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  9681f6:	62 f3 fd 48 03 c4 01 	valignq zmm0,zmm0,zmm4,0x1
  9681fd:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  968203:	62 71 fd 48 6f 2d b3 	vmovdqa64 zmm13,ZMMWORD PTR [rip+0xffffffffffaa39b3]        # 40bbc0 <__abi_tag+0xb004>
  96820a:	39 aa ff 
  96820d:	4c 8b 5c 24 58       	mov    r11,QWORD PTR [rsp+0x58]
  968212:	62 a3 ed 40 25 c8 f8 	vpternlogq zmm17,zmm18,zmm16,0xf8
  968219:	62 51 95 40 db c9    	vpandq zmm9,zmm29,zmm9
  96821f:	62 71 fd 48 7f 54 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1100],zmm10
  968226:	44 
  968227:	62 52 fd 48 55 da    	vpopcntq zmm11,zmm10
  96822d:	41 09 f9             	or     r9d,edi
  968230:	41 09 c9             	or     r9d,ecx
  968233:	62 f3 fd 48 71 c4 3f 	vpshldq zmm0,zmm0,zmm4,0x3f
  96823a:	c4 c1 79 6e e1       	vmovd  xmm4,r9d
  96823f:	62 f3 dd 48 03 e1 01 	valignq zmm4,zmm4,zmm1,0x1
  968246:	62 23 fd 48 25 dc fe 	vpternlogq zmm27,zmm0,zmm20,0xfe
  96824d:	62 93 cd 40 71 c0 01 	vpshldq zmm0,zmm22,zmm24,0x1
  968254:	62 f3 dd 48 71 e1 3f 	vpshldq zmm4,zmm4,zmm1,0x3f
  96825b:	62 93 a5 40 25 c2 fe 	vpternlogq zmm0,zmm27,zmm26,0xfe
  968262:	62 f1 dd 48 df e1    	vpandnq zmm4,zmm4,zmm1
  968268:	62 63 fd 48 25 f4 fe 	vpternlogq zmm30,zmm0,zmm4,0xfe
  96826f:	62 93 ed 48 03 e7 07 	valignq zmm4,zmm2,zmm31,0x7
  968276:	62 f3 8d 40 25 f3 fe 	vpternlogq zmm6,zmm30,zmm3,0xfe
  96827d:	62 f1 ad 48 eb da    	vporq  zmm3,zmm10,zmm2
  968283:	c4 e1 f9 7e f1       	vmovq  rcx,xmm6
  968288:	48 0b 8c 24 28 02 00 	or     rcx,QWORD PTR [rsp+0x228]
  96828f:	00 
  968290:	62 f3 ed 48 71 e4 01 	vpshldq zmm4,zmm2,zmm4,0x1
  968297:	c4 e3 c9 22 c1 00    	vpinsrq xmm0,xmm6,rcx,0x0
  96829d:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  9682a2:	62 f3 4d 48 38 c0 00 	vinserti32x4 zmm0,zmm6,xmm0,0x0
  9682a9:	c5 fa 7e b4 24 30 02 	vmovq  xmm6,QWORD PTR [rsp+0x230]
  9682b0:	00 00 
  9682b2:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1140],zmm0
  9682b9:	45 
  9682ba:	62 72 fd 48 55 e0    	vpopcntq zmm12,zmm0
  9682c0:	62 f1 dd 48 eb e6    	vporq  zmm4,zmm4,zmm6
  9682c6:	62 f3 e5 48 1e c4 01 	vpcmpltuq k0,zmm3,zmm4
  9682cd:	62 f2 e5 48 29 cc    	vpcmpeqq k1,zmm3,zmm4
  9682d3:	62 f1 e5 48 fb e4    	vpsubq zmm4,zmm3,zmm4
  9682d9:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9682dd:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9682e1:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9682e5:	62 f2 fe 48 38 f0    	vpmovm2q zmm6,k0
  9682eb:	62 f1 dd 48 d4 e6    	vpaddq zmm4,zmm4,zmm6
  9682f1:	62 d1 dd 48 df f2    	vpandnq zmm6,zmm4,zmm10
  9682f7:	62 f1 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1180],zmm6
  9682fe:	46 
  9682ff:	62 61 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x11c0],zmm25
  968306:	47 
  968307:	62 e1 fd 48 7f 7c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1200],zmm23
  96830e:	48 
  96830f:	62 71 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1240],zmm9
  968316:	49 
  968317:	62 f1 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1280],zmm5
  96831e:	4a 
  96831f:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x12c0],zmm17
  968326:	4b 
  968327:	62 c3 d5 48 25 c9 fe 	vpternlogq zmm17,zmm5,zmm9,0xfe
  96832e:	62 71 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1300],zmm11
  968335:	4c 
  968336:	62 71 fd 48 7f 64 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1340],zmm12
  96833d:	4d 
  96833e:	4c 89 9c 24 80 13 00 	mov    QWORD PTR [rsp+0x1380],r11
  968345:	00 
  968346:	4c 89 b4 24 88 13 00 	mov    QWORD PTR [rsp+0x1388],r14
  96834d:	00 
  96834e:	62 b2 f5 40 27 c1    	vptestmq k0,zmm17,zmm17
  968354:	c5 79 93 c0          	kmovb  r8d,k0
  968358:	44 89 84 24 90 13 00 	mov    DWORD PTR [rsp+0x1390],r8d
  96835f:	00 
  968360:	48 39 4c 24 78       	cmp    QWORD PTR [rsp+0x78],rcx
  968365:	0f 8d 92 2d 00 00    	jge    96b0fd <tokenize_c_counted_raw_no_separators+0x4c7d>
  96836b:	b9 08 01 00 00       	mov    ecx,0x108
  968370:	48 89 84 24 00 01 00 	mov    QWORD PTR [rsp+0x100],rax
  968377:	00 
  968378:	62 f3 7d 48 39 d0 03 	vextracti32x4 xmm0,zmm2,0x3
  96837f:	62 72 7d 48 5a 05 07 	vbroadcasti32x4 zmm8,XMMWORD PTR [rip+0xffffffffffac3507]        # 42b890 <c_testsuite_feature.marker+0x138c>
  968386:	35 ac ff 
  968389:	62 71 fd 48 6f 4c 24 	vmovdqa64 zmm9,ZMMWORD PTR [rsp+0xa40]
  968390:	29 
  968391:	62 71 fd 48 6f 15 65 	vmovdqa64 zmm10,ZMMWORD PTR [rip+0xffffffffffaa3765]        # 40bb00 <__abi_tag+0xaf44>
  968398:	37 aa ff 
  96839b:	62 71 fd 48 6f 1d 9b 	vmovdqa64 zmm11,ZMMWORD PTR [rip+0xffffffffffaa379b]        # 40bb40 <__abi_tag+0xaf84>
  9683a2:	37 aa ff 
  9683a5:	62 71 fd 48 6f 25 d1 	vmovdqa64 zmm12,ZMMWORD PTR [rip+0xffffffffffaa37d1]        # 40bb80 <__abi_tag+0xafc4>
  9683ac:	37 aa ff 
  9683af:	62 72 7d 48 5a 35 e7 	vbroadcasti32x4 zmm14,XMMWORD PTR [rip+0xffffffffffac34e7]        # 42b8a0 <c_testsuite_feature.marker+0x139c>
  9683b6:	34 ac ff 
  9683b9:	62 72 7d 48 5a 3d ed 	vbroadcasti32x4 zmm15,XMMWORD PTR [rip+0xffffffffffac34ed]        # 42b8b0 <c_testsuite_feature.marker+0x13ac>
  9683c0:	34 ac ff 
  9683c3:	62 e2 7d 48 5a 05 f3 	vbroadcasti32x4 zmm16,XMMWORD PTR [rip+0xffffffffffac34f3]        # 42b8c0 <c_testsuite_feature.marker+0x13bc>
  9683ca:	34 ac ff 
  9683cd:	62 e2 7d 48 5a 0d f9 	vbroadcasti32x4 zmm17,XMMWORD PTR [rip+0xffffffffffac34f9]        # 42b8d0 <c_testsuite_feature.marker+0x13cc>
  9683d4:	34 ac ff 
  9683d7:	62 e2 7d 48 5a 15 ff 	vbroadcasti32x4 zmm18,XMMWORD PTR [rip+0xffffffffffac34ff]        # 42b8e0 <c_testsuite_feature.marker+0x13dc>
  9683de:	34 ac ff 
  9683e1:	62 e2 7d 48 5a 1d 05 	vbroadcasti32x4 zmm19,XMMWORD PTR [rip+0xffffffffffac3505]        # 42b8f0 <c_testsuite_feature.marker+0x13ec>
  9683e8:	35 ac ff 
  9683eb:	62 e1 fd 48 6f 25 8b 	vmovdqa64 zmm20,ZMMWORD PTR [rip+0xffffffffffaa398b]        # 40bd80 <__abi_tag+0xb1c4>
  9683f2:	39 aa ff 
  9683f5:	62 e2 7d 48 5a 2d 01 	vbroadcasti32x4 zmm21,XMMWORD PTR [rip+0xffffffffffac3501]        # 42b900 <c_testsuite_feature.marker+0x13fc>
  9683fc:	35 ac ff 
  9683ff:	62 e2 7d 48 5a 35 07 	vbroadcasti32x4 zmm22,XMMWORD PTR [rip+0xffffffffffac3507]        # 42b910 <c_testsuite_feature.marker+0x140c>
  968406:	35 ac ff 
  968409:	62 e2 7d 48 5a 3d 0d 	vbroadcasti32x4 zmm23,XMMWORD PTR [rip+0xffffffffffac350d]        # 42b920 <c_testsuite_feature.marker+0x141c>
  968410:	35 ac ff 
  968413:	62 62 7d 48 5a 05 13 	vbroadcasti32x4 zmm24,XMMWORD PTR [rip+0xffffffffffac3513]        # 42b930 <c_testsuite_feature.marker+0x142c>
  96841a:	35 ac ff 
  96841d:	62 61 fd 48 6f 4c 24 	vmovdqa64 zmm25,ZMMWORD PTR [rsp+0x540]
  968424:	15 
  968425:	62 61 fd 48 6f 54 24 	vmovdqa64 zmm26,ZMMWORD PTR [rsp+0x580]
  96842c:	16 
  96842d:	62 61 fd 48 6f 25 09 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffaa3d09]        # 40c140 <__abi_tag+0xb584>
  968434:	3d aa ff 
  968437:	48 89 9c 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rbx
  96843e:	00 
  96843f:	48 89 b4 24 28 02 00 	mov    QWORD PTR [rsp+0x228],rsi
  968446:	00 
  968447:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  96844e:	c4 e2 70 f7 84 24 98 	bextr  eax,DWORD PTR [rsp+0x98],ecx
  968455:	00 00 00 
  968458:	48 8b 8c 24 00 07 00 	mov    rcx,QWORD PTR [rsp+0x700]
  96845f:	00 
  968460:	48 89 84 24 c0 02 00 	mov    QWORD PTR [rsp+0x2c0],rax
  968467:	00 
  968468:	48 8b 84 24 40 06 00 	mov    rax,QWORD PTR [rsp+0x640]
  96846f:	00 
  968470:	48 c1 f8 3f          	sar    rax,0x3f
  968474:	21 c1                	and    ecx,eax
  968476:	4c 89 f0             	mov    rax,r14
  968479:	4c 8b 74 24 40       	mov    r14,QWORD PTR [rsp+0x40]
  96847e:	48 89 84 24 00 05 00 	mov    QWORD PTR [rsp+0x500],rax
  968485:	00 
  968486:	8b 84 24 40 03 00 00 	mov    eax,DWORD PTR [rsp+0x340]
  96848d:	48 89 8c 24 00 07 00 	mov    QWORD PTR [rsp+0x700],rcx
  968494:	00 
  968495:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  96849b:	62 f3 7d 48 39 e0 03 	vextracti32x4 xmm0,zmm4,0x3
  9684a2:	c4 e3 f9 16 c7 01    	vpextrq rdi,xmm0,0x1
  9684a8:	62 f3 7d 48 39 d8 03 	vextracti32x4 xmm0,zmm3,0x3
  9684af:	c4 c3 f9 16 c1 01    	vpextrq r9,xmm0,0x1
  9684b5:	62 f3 7d 48 39 c8 03 	vextracti32x4 xmm0,zmm1,0x3
  9684bc:	62 f3 7d 48 39 f9 03 	vextracti32x4 xmm1,zmm7,0x3
  9684c3:	62 f2 7d 48 5a 3d b3 	vbroadcasti32x4 zmm7,XMMWORD PTR [rip+0xffffffffffac33b3]        # 42b880 <c_testsuite_feature.marker+0x137c>
  9684ca:	33 ac ff 
  9684cd:	c4 e2 b0 f2 d7       	andn   rdx,r9,rdi
  9684d2:	48 8b bc 24 78 04 00 	mov    rdi,QWORD PTR [rsp+0x478]
  9684d9:	00 
  9684da:	c4 e3 f9 16 84 24 c0 	vpextrq QWORD PTR [rsp+0x4c0],xmm0,0x1
  9684e1:	04 00 00 01 
  9684e5:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x280]
  9684ec:	0a 
  9684ed:	4c 8b 8c 24 e8 00 00 	mov    r9,QWORD PTR [rsp+0xe8]
  9684f4:	00 
  9684f5:	48 09 ca             	or     rdx,rcx
  9684f8:	49 81 c6 00 02 00 00 	add    r14,0x200
  9684ff:	48 c1 ea 3f          	shr    rdx,0x3f
  968503:	48 89 94 24 30 02 00 	mov    QWORD PTR [rsp+0x230],rdx
  96850a:	00 
  96850b:	48 8b 94 24 f0 00 00 	mov    rdx,QWORD PTR [rsp+0xf0]
  968512:	00 
  968513:	48 83 f7 01          	xor    rdi,0x1
  968517:	4c 89 4c 24 58       	mov    QWORD PTR [rsp+0x58],r9
  96851c:	48 89 fe             	mov    rsi,rdi
  96851f:	48 8d 4a 01          	lea    rcx,[rdx+0x1]
  968523:	48 83 fa 02          	cmp    rdx,0x2
  968527:	ba 00 00 00 00       	mov    edx,0x0
  96852c:	62 f3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm0,0x3
  968533:	48 0f 45 d1          	cmovne rdx,rcx
  968537:	48 81 84 24 10 02 00 	add    QWORD PTR [rsp+0x210],0xfffffffffffffe00
  96853e:	00 00 fe ff ff 
  968543:	48 81 84 24 18 02 00 	add    QWORD PTR [rsp+0x218],0xfffffffffffffe00
  96854a:	00 00 fe ff ff 
  96854f:	48 81 84 24 08 02 00 	add    QWORD PTR [rsp+0x208],0xfffffffffffffe00
  968556:	00 00 fe ff ff 
  96855b:	48 81 84 24 00 02 00 	add    QWORD PTR [rsp+0x200],0x200
  968562:	00 00 02 00 00 
  968567:	48 81 84 24 f8 01 00 	add    QWORD PTR [rsp+0x1f8],0x200
  96856e:	00 00 02 00 00 
  968573:	48 81 84 24 f0 01 00 	add    QWORD PTR [rsp+0x1f0],0x200
  96857a:	00 00 02 00 00 
  96857f:	48 81 84 24 e8 01 00 	add    QWORD PTR [rsp+0x1e8],0x200
  968586:	00 00 02 00 00 
  96858b:	48 81 84 24 e0 01 00 	add    QWORD PTR [rsp+0x1e0],0x200
  968592:	00 00 02 00 00 
  968597:	48 81 84 24 d8 01 00 	add    QWORD PTR [rsp+0x1d8],0x200
  96859e:	00 00 02 00 00 
  9685a3:	48 81 84 24 d0 01 00 	add    QWORD PTR [rsp+0x1d0],0x200
  9685aa:	00 00 02 00 00 
  9685af:	48 81 84 24 c8 01 00 	add    QWORD PTR [rsp+0x1c8],0x200
  9685b6:	00 00 02 00 00 
  9685bb:	c5 f1 6d c0          	vpunpckhqdq xmm0,xmm1,xmm0
  9685bf:	49 81 c4 00 02 00 00 	add    r12,0x200
  9685c6:	b1 01                	mov    cl,0x1
  9685c8:	48 89 94 24 f0 00 00 	mov    QWORD PTR [rsp+0xf0],rdx
  9685cf:	00 
  9685d0:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x640],zmm0
  9685d7:	19 
  9685d8:	e9 73 e5 ff ff       	jmp    966b50 <tokenize_c_counted_raw_no_separators+0x6d0>
  9685dd:	48 c7 84 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],0x0
  9685e4:	00 00 00 00 00 
  9685e9:	31 f6                	xor    esi,esi
  9685eb:	e9 92 f9 ff ff       	jmp    967f82 <tokenize_c_counted_raw_no_separators+0x1b02>
  9685f0:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  9685f5:	48 89 94 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],rdx
  9685fc:	00 
  9685fd:	e9 04 e8 ff ff       	jmp    966e06 <tokenize_c_counted_raw_no_separators+0x986>
  968602:	48 89 f9             	mov    rcx,rdi
  968605:	4c 89 f7             	mov    rdi,r14
  968608:	48 29 cf             	sub    rdi,rcx
  96860b:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  968612:	48 c7 c1 ff ff ff ff 	mov    rcx,0xffffffffffffffff
  968619:	48 85 ff             	test   rdi,rdi
  96861c:	0f 8e 0b 1b 00 00    	jle    96a12d <tokenize_c_counted_raw_no_separators+0x3cad>
  968622:	48 83 ff 3f          	cmp    rdi,0x3f
  968626:	0f 86 f9 1a 00 00    	jbe    96a125 <tokenize_c_counted_raw_no_separators+0x3ca5>
  96862c:	31 c9                	xor    ecx,ecx
  96862e:	e9 fa 1a 00 00       	jmp    96a12d <tokenize_c_counted_raw_no_separators+0x3cad>
  968633:	62 e3 7d 28 39 c0 01 	vextracti32x4 xmm0,ymm16,0x1
  96863a:	62 f1 8d 40 df c9    	vpandnq zmm1,zmm30,zmm1
  968640:	62 f1 fd 48 7f 64 24 	vmovdqa64 ZMMWORD PTR [rsp+0x300],zmm4
  968647:	0c 
  968648:	62 71 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x380],zmm9
  96864f:	0e 
  968650:	62 f1 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x480],zmm3
  968657:	12 
  968658:	c4 e3 f9 16 c6 01    	vpextrq rsi,xmm0,0x1
  96865e:	89 f1                	mov    ecx,esi
  968660:	44 21 d9             	and    ecx,r11d
  968663:	c5 f9 6e c1          	vmovd  xmm0,ecx
  968667:	62 f3 fd 48 03 c2 01 	valignq zmm0,zmm0,zmm2,0x1
  96866e:	62 f3 fd 48 71 c2 3f 	vpshldq zmm0,zmm0,zmm2,0x3f
  968675:	62 21 fd 48 db ee    	vpandq zmm29,zmm0,zmm22
  96867b:	48 85 c0             	test   rax,rax
  96867e:	0f 85 e6 1c 00 00    	jne    96a36a <tokenize_c_counted_raw_no_separators+0x3eea>
  968684:	62 92 95 40 27 c5    	vptestmq k0,zmm29,zmm29
  96868a:	c4 41 09 ef f6       	vpxor  xmm14,xmm14,xmm14
  96868f:	c5 fb 93 c0          	kmovd  eax,k0
  968693:	84 c0                	test   al,al
  968695:	0f 85 cf 1c 00 00    	jne    96a36a <tokenize_c_counted_raw_no_separators+0x3eea>
  96869b:	c4 41 01 ef ff       	vpxor  xmm15,xmm15,xmm15
  9686a0:	62 e3 7d 28 39 c0 01 	vextracti32x4 xmm0,ymm16,0x1
  9686a7:	c5 f9 7e c0          	vmovd  eax,xmm0
  9686ab:	c4 e2 48 f2 c0       	andn   eax,esi,eax
  9686b0:	c5 f9 6e c0          	vmovd  xmm0,eax
  9686b4:	62 f3 fd 48 03 c1 01 	valignq zmm0,zmm0,zmm1,0x1
  9686bb:	62 f3 fd 48 71 c1 3f 	vpshldq zmm0,zmm0,zmm1,0x3f
  9686c2:	62 b1 fd 48 db ce    	vpandq zmm1,zmm0,zmm22
  9686c8:	62 f2 75 48 27 c1    	vptestmd k0,zmm1,zmm1
  9686ce:	c5 f8 98 c0          	kortestw k0,k0
  9686d2:	0f 85 cd 23 00 00    	jne    96aaa5 <tokenize_c_counted_raw_no_separators+0x4625>
  9686d8:	c5 fa 7e 8c 24 e0 00 	vmovq  xmm1,QWORD PTR [rsp+0xe0]
  9686df:	00 00 
  9686e1:	62 f2 fd 48 59 25 8d 	vpbroadcastq zmm4,QWORD PTR [rip+0xffffffffffc6408d]        # 5cc778 <x86_effects_unknown+0x308>
  9686e8:	40 c6 ff 
  9686eb:	62 b1 95 40 ef c6    	vpxorq zmm0,zmm29,zmm22
  9686f1:	62 71 fd 48 6f 4c 24 	vmovdqa64 zmm9,ZMMWORD PTR [rsp+0x380]
  9686f8:	0e 
  9686f9:	62 f1 f5 48 df d0    	vpandnq zmm2,zmm1,zmm0
  9686ff:	62 93 ed 48 03 df 07 	valignq zmm3,zmm2,zmm31,0x7
  968706:	62 f3 ed 48 71 db 01 	vpshldq zmm3,zmm2,zmm3,0x1
  96870d:	62 f1 e5 48 eb dc    	vporq  zmm3,zmm3,zmm4
  968713:	62 f3 e5 48 1e c2 01 	vpcmpltuq k0,zmm3,zmm2
  96871a:	62 f2 e5 48 29 ca    	vpcmpeqq k1,zmm3,zmm2
  968720:	62 f1 e5 48 fb d2    	vpsubq zmm2,zmm3,zmm2
  968726:	c5 fd 4a c0          	kaddb  k0,k0,k0
  96872a:	c5 fd 4a c1          	kaddb  k0,k0,k1
  96872e:	c5 fd 47 c1          	kxorb  k0,k0,k1
  968732:	62 f2 fe 48 38 d8    	vpmovm2q zmm3,k0
  968738:	62 f1 ed 48 d4 d3    	vpaddq zmm2,zmm2,zmm3
  96873e:	62 f1 ed 48 ef d4    	vpxorq zmm2,zmm2,zmm4
  968744:	62 f3 7d 48 39 c4 03 	vextracti32x4 xmm4,zmm0,0x3
  96874b:	62 f3 7d 48 39 d3 03 	vextracti32x4 xmm3,zmm2,0x3
  968752:	62 f3 fd 48 25 d1 e1 	vpternlogq zmm2,zmm0,zmm1,0xe1
  968759:	c5 e1 db dc          	vpand  xmm3,xmm3,xmm4
  96875d:	62 f1 fd 48 6f 64 24 	vmovdqa64 zmm4,ZMMWORD PTR [rsp+0x300]
  968764:	0c 
  968765:	c4 e3 f9 16 d8 01    	vpextrq rax,xmm3,0x1
  96876b:	62 f1 fd 48 6f 5c 24 	vmovdqa64 zmm3,ZMMWORD PTR [rsp+0x480]
  968772:	12 
  968773:	48 c1 e8 3f          	shr    rax,0x3f
  968777:	48 89 84 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],rax
  96877e:	00 
  96877f:	e9 b6 ed ff ff       	jmp    96753a <tokenize_c_counted_raw_no_separators+0x10ba>
  968784:	48 8b bc 24 f0 00 00 	mov    rdi,QWORD PTR [rsp+0xf0]
  96878b:	00 
  96878c:	48 c7 84 24 40 05 00 	mov    QWORD PTR [rsp+0x540],0x0
  968793:	00 00 00 00 00 
  968798:	4c 8d 77 01          	lea    r14,[rdi+0x1]
  96879c:	48 83 ff 02          	cmp    rdi,0x2
  9687a0:	bf 00 00 00 00       	mov    edi,0x0
  9687a5:	4c 0f 44 f7          	cmove  r14,rdi
  9687a9:	49 c1 e6 06          	shl    r14,0x6
  9687ad:	4b 8d 3c f6          	lea    rdi,[r14+r14*8]
  9687b1:	4c 8d b4 24 c0 0c 00 	lea    r14,[rsp+0xcc0]
  9687b8:	00 
  9687b9:	4d 01 f1             	add    r9,r14
  9687bc:	4c 8b b4 24 18 02 00 	mov    r14,QWORD PTR [rsp+0x218]
  9687c3:	00 
  9687c4:	48 8d 94 3c c0 13 00 	lea    rdx,[rsp+rdi*1+0x13c0]
  9687cb:	00 
  9687cc:	48 89 94 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],rdx
  9687d3:	00 
  9687d4:	48 89 fa             	mov    rdx,rdi
  9687d7:	48 8b 7c 24 58       	mov    rdi,QWORD PTR [rsp+0x58]
  9687dc:	4c 89 b4 24 00 03 00 	mov    QWORD PTR [rsp+0x300],r14
  9687e3:	00 
  9687e4:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  9687e9:	62 f1 fd 48 6f 47 08 	vmovdqa64 zmm0,ZMMWORD PTR [rdi+0x200]
  9687f0:	48 8d bc 24 00 14 00 	lea    rdi,[rsp+0x1400]
  9687f7:	00 
  9687f8:	62 f1 fd 48 7f 44 14 	vmovdqa64 ZMMWORD PTR [rsp+rdx*1+0x13c0],zmm0
  9687ff:	4f 
  968800:	48 01 fa             	add    rdx,rdi
  968803:	48 8b bc 24 10 02 00 	mov    rdi,QWORD PTR [rsp+0x210]
  96880a:	00 
  96880b:	48 89 94 24 80 03 00 	mov    QWORD PTR [rsp+0x380],rdx
  968812:	00 
  968813:	48 8d 94 24 88 22 00 	lea    rdx,[rsp+0x2288]
  96881a:	00 
  96881b:	48 01 d6             	add    rsi,rdx
  96881e:	48 8b 94 24 08 02 00 	mov    rdx,QWORD PTR [rsp+0x208]
  968825:	00 
  968826:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  96882d:	00 00 00 
  968830:	48 89 94 24 80 01 00 	mov    QWORD PTR [rsp+0x180],rdx
  968837:	00 
  968838:	48 89 bc 24 80 05 00 	mov    QWORD PTR [rsp+0x580],rdi
  96883f:	00 
  968840:	48 8b 94 24 d8 00 00 	mov    rdx,QWORD PTR [rsp+0xd8]
  968847:	00 
  968848:	48 8b bc 24 80 01 00 	mov    rdi,QWORD PTR [rsp+0x180]
  96884f:	00 
  968850:	48 01 fa             	add    rdx,rdi
  968853:	48 8b bc 24 80 05 00 	mov    rdi,QWORD PTR [rsp+0x580]
  96885a:	00 
  96885b:	48 89 94 24 40 03 00 	mov    QWORD PTR [rsp+0x340],rdx
  968862:	00 
  968863:	48 8b 94 24 d8 00 00 	mov    rdx,QWORD PTR [rsp+0xd8]
  96886a:	00 
  96886b:	48 01 fa             	add    rdx,rdi
  96886e:	48 8b bc 24 40 03 00 	mov    rdi,QWORD PTR [rsp+0x340]
  968875:	00 
  968876:	48 89 94 24 80 02 00 	mov    QWORD PTR [rsp+0x280],rdx
  96887d:	00 
  96887e:	48 85 ff             	test   rdi,rdi
  968881:	0f 8f a2 01 00 00    	jg     968a29 <tokenize_c_counted_raw_no_separators+0x25a9>
  968887:	48 83 bc 24 80 02 00 	cmp    QWORD PTR [rsp+0x280],0x40
  96888e:	00 40 
  968890:	0f 8c 93 01 00 00    	jl     968a29 <tokenize_c_counted_raw_no_separators+0x25a9>
  968896:	48 8b bc 24 40 05 00 	mov    rdi,QWORD PTR [rsp+0x540]
  96889d:	00 
  96889e:	62 d1 fd 48 6f 14 fc 	vmovdqa64 zmm2,ZMMWORD PTR [r12+rdi*8]
  9688a5:	62 d1 fd 48 6f c2    	vmovdqa64 zmm0,zmm10
  9688ab:	62 d1 fd 48 6f cc    	vmovdqa64 zmm1,zmm12
  9688b1:	48 8b 94 24 80 03 00 	mov    rdx,QWORD PTR [rsp+0x380]
  9688b8:	00 
  9688b9:	62 d2 6d 48 7d c3    	vpermt2b zmm0,zmm2,zmm11
  9688bf:	62 d2 6d 48 7d cd    	vpermt2b zmm1,zmm2,zmm13
  9688c5:	62 f2 7e 48 29 c2    	vpmovb2m k0,zmm2
  9688cb:	c4 e1 f8 98 c0       	kortestq k0,k0
  9688d0:	62 f1 fd 48 7f 14 fa 	vmovdqa64 ZMMWORD PTR [rdx+rdi*8],zmm2
  9688d7:	0f 85 36 01 00 00    	jne    968a13 <tokenize_c_counted_raw_no_separators+0x2593>
  9688dd:	62 f1 fd 48 6f d9    	vmovdqa64 zmm3,zmm1
  9688e3:	62 92 35 48 7d d9    	vpermt2b zmm3,zmm9,zmm25
  9688e9:	62 f2 0d 48 00 e1    	vpshufb zmm4,zmm14,zmm1
  9688ef:	62 b2 7d 48 00 c2    	vpshufb zmm0,zmm0,zmm18
  9688f5:	62 f2 75 40 00 e9    	vpshufb zmm5,zmm17,zmm1
  9688fb:	48 8b 94 24 80 01 00 	mov    rdx,QWORD PTR [rsp+0x180]
  968902:	00 
  968903:	48 83 84 24 00 03 00 	add    QWORD PTR [rsp+0x300],0xffffffffffffffc0
  96890a:	00 c0 
  96890c:	62 61 fd 48 6f c9    	vmovdqa64 zmm25,zmm1
  968912:	62 f3 e5 40 ce c0 00 	vgf2p8affineqb zmm0,zmm19,zmm0,0x0
  968919:	62 f3 65 48 3f c9 04 	vpcmpneqb k1,zmm3,zmm1
  968920:	62 f2 05 48 00 db    	vpshufb zmm3,zmm15,zmm3
  968926:	62 f2 5d 40 8d c0    	vpermb zmm0,zmm20,zmm0
  96892c:	48 83 c2 c0          	add    rdx,0xffffffffffffffc0
  968930:	48 89 94 24 80 01 00 	mov    QWORD PTR [rsp+0x180],rdx
  968937:	00 
  968938:	62 f1 e5 48 db e4    	vpandq zmm4,zmm3,zmm4
  96893e:	48 8b 94 24 80 01 00 	mov    rdx,QWORD PTR [rsp+0x180]
  968945:	00 
  968946:	62 b1 dd 48 db d8    	vpandq zmm3,zmm4,zmm16
  96894c:	62 f2 5d 49 66 db    	vpblendmb zmm3{k1},zmm4,zmm3
  968952:	62 d1 6d 48 74 c8    	vpcmpeqb k1,zmm2,zmm8
  968958:	62 f1 fd 48 6f f3    	vmovdqa64 zmm6,zmm3
  96895e:	62 92 35 48 7d f2    	vpermt2b zmm6,zmm9,zmm26
  968964:	c4 e1 f8 91 8c 3e 00 	kmovq  QWORD PTR [rsi+rdi*1-0x400],k1
  96896b:	fc ff ff 
  96896e:	62 f1 6d 48 74 cf    	vpcmpeqb k1,zmm2,zmm7
  968974:	62 d1 fd 48 7f 04 f9 	vmovdqa64 ZMMWORD PTR [r9+rdi*8],zmm0
  96897b:	62 61 fd 48 6f d3    	vmovdqa64 zmm26,zmm3
  968981:	c4 e1 f8 91 8c 3e 80 	kmovq  QWORD PTR [rsi+rdi*1-0x380],k1
  968988:	fc ff ff 
  96898b:	62 b1 6d 48 74 cd    	vpcmpeqb k1,zmm2,zmm21
  968991:	c4 e1 f8 91 8c 3e 00 	kmovq  QWORD PTR [rsi+rdi*1-0x300],k1
  968998:	fd ff ff 
  96899b:	62 f2 7e 48 29 cc    	vpmovb2m k1,zmm4
  9689a1:	c4 e1 f8 91 8c 3e 80 	kmovq  QWORD PTR [rsi+rdi*1-0x280],k1
  9689a8:	fd ff ff 
  9689ab:	62 b2 5d 48 26 ce    	vptestmb k1,zmm4,zmm22
  9689b1:	c4 e1 f8 91 8c 3e 00 	kmovq  QWORD PTR [rsi+rdi*1-0x200],k1
  9689b8:	fe ff ff 
  9689bb:	62 b2 65 48 26 cf    	vptestmb k1,zmm3,zmm23
  9689c1:	62 f1 d5 48 db ee    	vpandq zmm5,zmm5,zmm6
  9689c7:	c4 e1 f8 91 8c 3e 80 	kmovq  QWORD PTR [rsi+rdi*1-0x180],k1
  9689ce:	fe ff ff 
  9689d1:	62 92 55 48 26 c8    	vptestmb k1,zmm5,zmm24
  9689d7:	c4 e1 f8 91 8c 3e 00 	kmovq  QWORD PTR [rsi+rdi*1-0x100],k1
  9689de:	ff ff ff 
  9689e1:	c4 e1 f8 91 04 3e    	kmovq  QWORD PTR [rsi+rdi*1],k0
  9689e7:	48 83 c7 08          	add    rdi,0x8
  9689eb:	48 89 bc 24 40 05 00 	mov    QWORD PTR [rsp+0x540],rdi
  9689f2:	00 
  9689f3:	48 8b bc 24 80 05 00 	mov    rdi,QWORD PTR [rsp+0x580]
  9689fa:	00 
  9689fb:	48 83 c7 c0          	add    rdi,0xffffffffffffffc0
  9689ff:	48 83 bc 24 40 05 00 	cmp    QWORD PTR [rsp+0x540],0x40
  968a06:	00 40 
  968a08:	0f 85 22 fe ff ff    	jne    968830 <tokenize_c_counted_raw_no_separators+0x23b0>
  968a0e:	e9 e2 e3 ff ff       	jmp    966df5 <tokenize_c_counted_raw_no_separators+0x975>
  968a13:	c4 e1 f8 44 c8       	knotq  k1,k0
  968a18:	62 f1 7f c9 6f c0    	vmovdqu8 zmm0{k1}{z},zmm0
  968a1e:	62 f1 7f c9 6f c9    	vmovdqu8 zmm1{k1}{z},zmm1
  968a24:	e9 b4 fe ff ff       	jmp    9688dd <tokenize_c_counted_raw_no_separators+0x245d>
  968a29:	48 8b bc 24 d8 00 00 	mov    rdi,QWORD PTR [rsp+0xd8]
  968a30:	00 
  968a31:	48 8b 94 24 00 03 00 	mov    rdx,QWORD PTR [rsp+0x300]
  968a38:	00 
  968a39:	48 83 bc 24 80 02 00 	cmp    QWORD PTR [rsp+0x280],0x0
  968a40:	00 00 
  968a42:	4c 8d 34 17          	lea    r14,[rdi+rdx*1]
  968a46:	0f 9f 84 24 80 04 00 	setg   BYTE PTR [rsp+0x480]
  968a4d:	00 
  968a4e:	49 83 fe c1          	cmp    r14,0xffffffffffffffc1
  968a52:	73 12                	jae    968a66 <tokenize_c_counted_raw_no_separators+0x25e6>
  968a54:	0f b6 94 24 80 04 00 	movzx  edx,BYTE PTR [rsp+0x480]
  968a5b:	00 
  968a5c:	31 ff                	xor    edi,edi
  968a5e:	40 88 d7             	mov    dil,dl
  968a61:	48 f7 df             	neg    rdi
  968a64:	eb 14                	jmp    968a7a <tokenize_c_counted_raw_no_separators+0x25fa>
  968a66:	48 8b 94 24 80 02 00 	mov    rdx,QWORD PTR [rsp+0x280]
  968a6d:	00 
  968a6e:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  968a75:	c4 e2 e8 f5 ff       	bzhi   rdi,rdi,rdx
  968a7a:	48 8b 94 24 40 03 00 	mov    rdx,QWORD PTR [rsp+0x340]
  968a81:	00 
  968a82:	48 85 d2             	test   rdx,rdx
  968a85:	7e 12                	jle    968a99 <tokenize_c_counted_raw_no_separators+0x2619>
  968a87:	48 89 bc 24 80 02 00 	mov    QWORD PTR [rsp+0x280],rdi
  968a8e:	00 
  968a8f:	48 83 fa 3f          	cmp    rdx,0x3f
  968a93:	76 0e                	jbe    968aa3 <tokenize_c_counted_raw_no_separators+0x2623>
  968a95:	31 d2                	xor    edx,edx
  968a97:	eb 23                	jmp    968abc <tokenize_c_counted_raw_no_separators+0x263c>
  968a99:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  968a9e:	48 89 fa             	mov    rdx,rdi
  968aa1:	eb 1e                	jmp    968ac1 <tokenize_c_counted_raw_no_separators+0x2641>
  968aa3:	48 c7 c7 ff ff ff ff 	mov    rdi,0xffffffffffffffff
  968aaa:	c4 62 e8 f5 f7       	bzhi   r14,rdi,rdx
  968aaf:	48 8b bc 24 80 02 00 	mov    rdi,QWORD PTR [rsp+0x280]
  968ab6:	00 
  968ab7:	c4 e2 88 f2 d7       	andn   rdx,r14,rdi
  968abc:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  968ac1:	62 f2 7d 48 5a 05 75 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffac2e75]        # 42b940 <c_testsuite_feature.marker+0x143c>
  968ac8:	2e ac ff 
  968acb:	48 8b bc 24 40 05 00 	mov    rdi,QWORD PTR [rsp+0x540]
  968ad2:	00 
  968ad3:	c4 e1 fb 92 ca       	kmovq  k1,rdx
  968ad8:	62 d2 7d 49 66 14 fc 	vpblendmb zmm2{k1},zmm0,ZMMWORD PTR [r12+rdi*8]
  968adf:	e9 c1 fd ff ff       	jmp    9688a5 <tokenize_c_counted_raw_no_separators+0x2425>
  968ae4:	62 f3 7d 48 39 e8 03 	vextracti32x4 xmm0,zmm5,0x3
  968aeb:	b8 ff 01 00 00       	mov    eax,0x1ff
  968af0:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  968af6:	48 85 c9             	test   rcx,rcx
  968af9:	0f 85 83 00 00 00    	jne    968b82 <tokenize_c_counted_raw_no_separators+0x2702>
  968aff:	c4 e1 f9 7e c1       	vmovq  rcx,xmm0
  968b04:	b8 bf 01 00 00       	mov    eax,0x1bf
  968b09:	48 85 c9             	test   rcx,rcx
  968b0c:	75 74                	jne    968b82 <tokenize_c_counted_raw_no_separators+0x2702>
  968b0e:	62 f3 7d 48 39 e8 02 	vextracti32x4 xmm0,zmm5,0x2
  968b15:	b8 7f 01 00 00       	mov    eax,0x17f
  968b1a:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  968b20:	48 85 c9             	test   rcx,rcx
  968b23:	75 5d                	jne    968b82 <tokenize_c_counted_raw_no_separators+0x2702>
  968b25:	c4 e1 f9 7e c1       	vmovq  rcx,xmm0
  968b2a:	b8 3f 01 00 00       	mov    eax,0x13f
  968b2f:	48 85 c9             	test   rcx,rcx
  968b32:	75 4e                	jne    968b82 <tokenize_c_counted_raw_no_separators+0x2702>
  968b34:	c4 e3 7d 39 e8 01    	vextracti128 xmm0,ymm5,0x1
  968b3a:	b8 ff 00 00 00       	mov    eax,0xff
  968b3f:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  968b45:	48 85 c9             	test   rcx,rcx
  968b48:	75 38                	jne    968b82 <tokenize_c_counted_raw_no_separators+0x2702>
  968b4a:	c4 e3 7d 39 e8 01    	vextracti128 xmm0,ymm5,0x1
  968b50:	b8 bf 00 00 00       	mov    eax,0xbf
  968b55:	c4 e1 f9 7e c1       	vmovq  rcx,xmm0
  968b5a:	48 85 c9             	test   rcx,rcx
  968b5d:	75 23                	jne    968b82 <tokenize_c_counted_raw_no_separators+0x2702>
  968b5f:	c4 e3 f9 16 e9 01    	vpextrq rcx,xmm5,0x1
  968b65:	b8 7f 00 00 00       	mov    eax,0x7f
  968b6a:	48 85 c9             	test   rcx,rcx
  968b6d:	75 13                	jne    968b82 <tokenize_c_counted_raw_no_separators+0x2702>
  968b6f:	c4 e1 f9 7e e9       	vmovq  rcx,xmm5
  968b74:	b8 3f 00 00 00       	mov    eax,0x3f
  968b79:	48 85 c9             	test   rcx,rcx
  968b7c:	0f 84 06 20 00 00    	je     96ab88 <tokenize_c_counted_raw_no_separators+0x4708>
  968b82:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x340]
  968b89:	0d 
  968b8a:	f3 48 0f bd c9       	lzcnt  rcx,rcx
  968b8f:	29 c8                	sub    eax,ecx
  968b91:	89 c1                	mov    ecx,eax
  968b93:	c1 e8 06             	shr    eax,0x6
  968b96:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0xb00],zmm0
  968b9d:	2c 
  968b9e:	48 8b 84 c4 00 0b 00 	mov    rax,QWORD PTR [rsp+rax*8+0xb00]
  968ba5:	00 
  968ba6:	48 0f a3 c8          	bt     rax,rcx
  968baa:	0f 93 c0             	setae  al
  968bad:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  968bb2:	62 63 7d 48 39 e8 03 	vextracti32x4 xmm0,zmm29,0x3
  968bb9:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  968bbf:	48 85 c9             	test   rcx,rcx
  968bc2:	0f 88 56 15 00 00    	js     96a11e <tokenize_c_counted_raw_no_separators+0x3c9e>
  968bc8:	4d 85 db             	test   r11,r11
  968bcb:	0f 88 49 17 00 00    	js     96a31a <tokenize_c_counted_raw_no_separators+0x3e9a>
  968bd1:	31 c9                	xor    ecx,ecx
  968bd3:	e9 5b 17 00 00       	jmp    96a333 <tokenize_c_counted_raw_no_separators+0x3eb3>
  968bd8:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  968bdd:	62 62 7d 48 5a 15 79 	vbroadcasti32x4 zmm26,XMMWORD PTR [rip+0xffffffffffac2d79]        # 42b960 <c_testsuite_feature.marker+0x145c>
  968be4:	2d ac ff 
  968be7:	62 62 7d 48 5a 0d 7f 	vbroadcasti32x4 zmm25,XMMWORD PTR [rip+0xffffffffffac2d7f]        # 42b970 <c_testsuite_feature.marker+0x146c>
  968bee:	2d ac ff 
  968bf1:	62 62 7d 48 5a 3d 85 	vbroadcasti32x4 zmm31,XMMWORD PTR [rip+0xffffffffffac2d85]        # 42b980 <c_testsuite_feature.marker+0x147c>
  968bf8:	2d ac ff 
  968bfb:	62 f1 fd 48 6f 02    	vmovdqa64 zmm0,ZMMWORD PTR [rdx]
  968c01:	62 e1 fd 48 6f 42 01 	vmovdqa64 zmm16,ZMMWORD PTR [rdx+0x40]
  968c08:	62 e1 fd 48 6f 5a 02 	vmovdqa64 zmm19,ZMMWORD PTR [rdx+0x80]
  968c0f:	62 e1 fd 48 6f 62 03 	vmovdqa64 zmm20,ZMMWORD PTR [rdx+0xc0]
  968c16:	62 71 fd 48 6f 42 04 	vmovdqa64 zmm8,ZMMWORD PTR [rdx+0x100]
  968c1d:	62 61 fd 48 6f 62 05 	vmovdqa64 zmm28,ZMMWORD PTR [rdx+0x140]
  968c24:	62 81 fd 48 db ea    	vpandq zmm21,zmm0,zmm26
  968c2a:	62 91 7d 48 74 cf    	vpcmpeqb k1,zmm0,zmm31
  968c30:	62 91 fd 40 db c2    	vpandq zmm0,zmm16,zmm26
  968c36:	62 91 55 40 74 c1    	vpcmpeqb k0,zmm21,zmm25
  968c3c:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968c41:	62 91 7d 40 74 cf    	vpcmpeqb k1,zmm16,zmm31
  968c47:	62 81 bd 48 db c2    	vpandq zmm16,zmm8,zmm26
  968c4d:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  968c52:	62 91 7d 48 74 c1    	vpcmpeqb k0,zmm0,zmm25
  968c58:	62 91 e5 40 db c2    	vpandq zmm0,zmm19,zmm26
  968c5e:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968c63:	48 89 8c 24 40 01 00 	mov    QWORD PTR [rsp+0x140],rcx
  968c6a:	00 
  968c6b:	62 91 65 40 74 cf    	vpcmpeqb k1,zmm19,zmm31
  968c71:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  968c76:	62 91 7d 48 74 c1    	vpcmpeqb k0,zmm0,zmm25
  968c7c:	62 91 dd 40 db c2    	vpandq zmm0,zmm20,zmm26
  968c82:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968c87:	48 89 8c 24 00 01 00 	mov    QWORD PTR [rsp+0x100],rcx
  968c8e:	00 
  968c8f:	62 91 5d 40 74 cf    	vpcmpeqb k1,zmm20,zmm31
  968c95:	62 e1 fe 08 7e 64 24 	vmovq  xmm20,QWORD PTR [rsp+0x140]
  968c9c:	28 
  968c9d:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  968ca2:	62 91 7d 48 74 c1    	vpcmpeqb k0,zmm0,zmm25
  968ca8:	62 f1 fd 48 6f 42 07 	vmovdqa64 zmm0,ZMMWORD PTR [rdx+0x1c0]
  968caf:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968cb4:	62 91 3d 48 74 cf    	vpcmpeqb k1,zmm8,zmm31
  968cba:	62 71 fd 48 6f 42 06 	vmovdqa64 zmm8,ZMMWORD PTR [rdx+0x180]
  968cc1:	48 89 8c 24 c0 02 00 	mov    QWORD PTR [rsp+0x2c0],rcx
  968cc8:	00 
  968cc9:	c4 61 fb 93 c8       	kmovq  r9,k0
  968cce:	62 91 7d 40 74 c1    	vpcmpeqb k0,zmm16,zmm25
  968cd4:	62 81 9d 40 db c2    	vpandq zmm16,zmm28,zmm26
  968cda:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968cdf:	62 91 1d 40 74 cf    	vpcmpeqb k1,zmm28,zmm31
  968ce5:	c4 61 fb 93 f0       	kmovq  r14,k0
  968cea:	62 91 7d 40 74 c1    	vpcmpeqb k0,zmm16,zmm25
  968cf0:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968cf5:	62 c1 fd 08 6e de    	vmovq  xmm19,r14
  968cfb:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  968d00:	62 81 bd 48 db c2    	vpandq zmm16,zmm8,zmm26
  968d06:	62 91 3d 48 74 cf    	vpcmpeqb k1,zmm8,zmm31
  968d0c:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x500]
  968d13:	14 
  968d14:	62 91 7d 40 74 c1    	vpcmpeqb k0,zmm16,zmm25
  968d1a:	62 81 fd 48 db c2    	vpandq zmm16,zmm0,zmm26
  968d20:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968d25:	62 91 7d 48 74 cf    	vpcmpeqb k1,zmm0,zmm31
  968d2b:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  968d30:	62 91 7d 40 74 c1    	vpcmpeqb k0,zmm16,zmm25
  968d36:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968d3b:	62 e1 fd 08 6e c1    	vmovq  xmm16,rcx
  968d41:	c4 61 fb 93 c0       	kmovq  r8,k0
  968d46:	c4 c1 f9 6e c0       	vmovq  xmm0,r8
  968d4b:	62 f1 fd 00 6c c0    	vpunpcklqdq xmm0,xmm16,xmm0
  968d51:	62 e1 fd 08 6e c7    	vmovq  xmm16,rdi
  968d57:	62 a1 e5 00 6c c0    	vpunpcklqdq xmm16,xmm19,xmm16
  968d5d:	62 e1 fe 08 7e 5c 24 	vmovq  xmm19,QWORD PTR [rsp+0x2c0]
  968d64:	58 
  968d65:	62 f3 7d 20 38 c0 01 	vinserti32x4 ymm0,ymm16,xmm0,0x1
  968d6c:	62 c1 fd 08 6e c1    	vmovq  xmm16,r9
  968d72:	62 a1 e5 00 6c c0    	vpunpcklqdq xmm16,xmm19,xmm16
  968d78:	62 e1 fe 08 7e 5c 24 	vmovq  xmm19,QWORD PTR [rsp+0x100]
  968d7f:	20 
  968d80:	62 a1 dd 00 6c db    	vpunpcklqdq xmm19,xmm20,xmm19
  968d86:	62 e1 fd 48 6f 62 08 	vmovdqa64 zmm20,ZMMWORD PTR [rdx+0x200]
  968d8d:	62 a3 65 20 38 c0 01 	vinserti32x4 ymm16,ymm19,xmm16,0x1
  968d94:	62 f3 fd 40 3a c0 01 	vinserti64x4 zmm0,zmm16,ymm0,0x1
  968d9b:	62 c3 fd 48 00 c0 ff 	vpermq zmm16,zmm8,0xff
  968da2:	62 a3 7d 48 39 c0 02 	vextracti32x4 xmm16,zmm16,0x2
  968da9:	62 f1 8d 48 eb c0    	vporq  zmm0,zmm14,zmm0
  968daf:	62 a1 f5 00 eb c0    	vporq  xmm16,xmm17,xmm16
  968db5:	62 d3 a5 40 25 c4 fe 	vpternlogq zmm0,zmm27,zmm12,0xfe
  968dbc:	62 e3 7d 08 16 c7 02 	vpextrd edi,xmm16,0x2
  968dc3:	62 81 dd 40 db da    	vpandq zmm19,zmm20,zmm26
  968dc9:	62 91 5d 40 74 cf    	vpcmpeqb k1,zmm20,zmm31
  968dcf:	62 91 65 40 74 c1    	vpcmpeqb k0,zmm19,zmm25
  968dd5:	62 33 7d 48 39 c3 03 	vextracti32x4 xmm19,zmm8,0x3
  968ddc:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  968de1:	62 c1 fd 08 7e d8    	vmovq  r8,xmm19
  968de7:	45 89 c1             	mov    r9d,r8d
  968dea:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  968def:	41 09 f9             	or     r9d,edi
  968df2:	41 09 c9             	or     r9d,ecx
  968df5:	62 c1 7d 08 6e c1    	vmovd  xmm16,r9d
  968dfb:	62 e3 fd 40 03 c0 01 	valignq zmm16,zmm16,zmm0,0x1
  968e02:	62 f3 fd 40 71 c0 3f 	vpshldq zmm0,zmm16,zmm0,0x3f
  968e09:	62 92 7d 48 27 c5    	vptestmd k0,zmm0,zmm29
  968e0f:	c5 f8 98 c0          	kortestw k0,k0
  968e13:	0f 84 4a ef ff ff    	je     967d63 <tokenize_c_counted_raw_no_separators+0x18e3>
  968e19:	e9 66 23 00 00       	jmp    96b184 <tokenize_c_counted_raw_no_separators+0x4d04>
  968e1e:	40 0f b6 ce          	movzx  ecx,sil
  968e22:	62 f3 7d 48 39 e8 03 	vextracti32x4 xmm0,zmm5,0x3
  968e29:	62 b3 7d 48 39 eb 02 	vextracti32x4 xmm19,zmm5,0x2
  968e30:	c4 c3 7d 39 e8 01    	vextracti128 xmm8,ymm5,0x1
  968e36:	31 d2                	xor    edx,edx
  968e38:	c4 e3 f9 16 ac 24 80 	vpextrq QWORD PTR [rsp+0x80],xmm5,0x1
  968e3f:	00 00 00 01 
  968e43:	c5 f9 d6 6c 24 60    	vmovq  QWORD PTR [rsp+0x60],xmm5
  968e49:	c7 84 24 40 03 00 00 	mov    DWORD PTR [rsp+0x340],0x0
  968e50:	00 00 00 00 
  968e54:	83 e1 01             	and    ecx,0x1
  968e57:	c4 e3 f9 16 84 24 c0 	vpextrq QWORD PTR [rsp+0x2c0],xmm0,0x1
  968e5e:	02 00 00 01 
  968e62:	c5 f9 d6 84 24 80 01 	vmovq  QWORD PTR [rsp+0x180],xmm0
  968e69:	00 00 
  968e6b:	62 e3 fd 08 16 5c 24 	vpextrq QWORD PTR [rsp+0x280],xmm19,0x1
  968e72:	50 01 
  968e74:	62 e1 fd 08 d6 5c 24 	vmovq  QWORD PTR [rsp+0x300],xmm19
  968e7b:	60 
  968e7c:	c4 63 f9 16 84 24 80 	vpextrq QWORD PTR [rsp+0x380],xmm8,0x1
  968e83:	03 00 00 01 
  968e87:	c5 79 d6 84 24 80 04 	vmovq  QWORD PTR [rsp+0x480],xmm8
  968e8e:	00 00 
  968e90:	48 89 8c 24 c0 03 00 	mov    QWORD PTR [rsp+0x3c0],rcx
  968e97:	00 
  968e98:	eb 11                	jmp    968eab <tokenize_c_counted_raw_no_separators+0x2a2b>
  968e9a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  968ea0:	ff c2                	inc    edx
  968ea2:	83 fa 09             	cmp    edx,0x9
  968ea5:	0f 84 b2 04 00 00    	je     96935d <tokenize_c_counted_raw_no_separators+0x2edd>
  968eab:	62 f1 fd 48 7f 64 24 	vmovdqa64 ZMMWORD PTR [rsp+0xac0],zmm4
  968eb2:	2b 
  968eb3:	4c 8b 8c 24 c0 03 00 	mov    r9,QWORD PTR [rsp+0x3c0]
  968eba:	00 
  968ebb:	83 fa 08             	cmp    edx,0x8
  968ebe:	74 0d                	je     968ecd <tokenize_c_counted_raw_no_separators+0x2a4d>
  968ec0:	89 d1                	mov    ecx,edx
  968ec2:	83 e1 07             	and    ecx,0x7
  968ec5:	4c 8b 8c cc c0 0a 00 	mov    r9,QWORD PTR [rsp+rcx*8+0xac0]
  968ecc:	00 
  968ecd:	4d 85 c9             	test   r9,r9
  968ed0:	74 ce                	je     968ea0 <tokenize_c_counted_raw_no_separators+0x2a20>
  968ed2:	89 d1                	mov    ecx,edx
  968ed4:	c1 e1 06             	shl    ecx,0x6
  968ed7:	89 94 24 00 01 00 00 	mov    DWORD PTR [rsp+0x100],edx
  968ede:	48 89 8c 24 40 01 00 	mov    QWORD PTR [rsp+0x140],rcx
  968ee5:	00 
  968ee6:	eb 44                	jmp    968f2c <tokenize_c_counted_raw_no_separators+0x2aac>
  968ee8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  968eef:	00 
  968ef0:	44 89 f1             	mov    ecx,r14d
  968ef3:	41 c1 ee 06          	shr    r14d,0x6
  968ef7:	62 e1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0xa80],zmm16
  968efe:	2a 
  968eff:	62 d2 fd 48 7c c6    	vpbroadcastq zmm0,r14
  968f05:	62 f2 fd 48 29 0d b1 	vpcmpeqq k1,zmm0,ZMMWORD PTR [rip+0xffffffffffaa32b1]        # 40c1c0 <__abi_tag+0xb604>
  968f0c:	32 aa ff 
  968f0f:	4a 8b bc f4 80 0a 00 	mov    rdi,QWORD PTR [rsp+r14*8+0xa80]
  968f16:	00 
  968f17:	48 0f ab cf          	bts    rdi,rcx
  968f1b:	62 e2 fd 49 7c c7    	vpbroadcastq zmm16{k1},rdi
  968f21:	c4 c2 b0 f3 c9       	blsr   r9,r9
  968f26:	0f 84 74 ff ff ff    	je     968ea0 <tokenize_c_counted_raw_no_separators+0x2a20>
  968f2c:	31 ff                	xor    edi,edi
  968f2e:	f3 49 0f bc f9       	tzcnt  rdi,r9
  968f33:	48 03 bc 24 40 01 00 	add    rdi,QWORD PTR [rsp+0x140]
  968f3a:	00 
  968f3b:	48 81 ff c1 01 00 00 	cmp    rdi,0x1c1
  968f42:	72 4c                	jb     968f90 <tokenize_c_counted_raw_no_separators+0x2b10>
  968f44:	48 8b 8c 24 c0 02 00 	mov    rcx,QWORD PTR [rsp+0x2c0]
  968f4b:	00 
  968f4c:	83 fa 07             	cmp    edx,0x7
  968f4f:	77 22                	ja     968f73 <tokenize_c_counted_raw_no_separators+0x2af3>
  968f51:	48 8d 8f 40 fe ff ff 	lea    rcx,[rdi-0x1c0]
  968f58:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  968f5f:	c4 e2 f0 f5 ca       	bzhi   rcx,rdx,rcx
  968f64:	8b 94 24 00 01 00 00 	mov    edx,DWORD PTR [rsp+0x100]
  968f6b:	48 23 8c 24 c0 02 00 	and    rcx,QWORD PTR [rsp+0x2c0]
  968f72:	00 
  968f73:	41 be ff 01 00 00    	mov    r14d,0x1ff
  968f79:	48 85 c9             	test   rcx,rcx
  968f7c:	0f 85 fe 01 00 00    	jne    969180 <tokenize_c_counted_raw_no_separators+0x2d00>
  968f82:	eb 14                	jmp    968f98 <tokenize_c_counted_raw_no_separators+0x2b18>
  968f84:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  968f8b:	00 00 00 00 00 
  968f90:	81 ff 81 01 00 00    	cmp    edi,0x181
  968f96:	72 48                	jb     968fe0 <tokenize_c_counted_raw_no_separators+0x2b60>
  968f98:	48 8b 8c 24 80 01 00 	mov    rcx,QWORD PTR [rsp+0x180]
  968f9f:	00 
  968fa0:	83 fa 06             	cmp    edx,0x6
  968fa3:	77 22                	ja     968fc7 <tokenize_c_counted_raw_no_separators+0x2b47>
  968fa5:	48 8d 8f 80 fe ff ff 	lea    rcx,[rdi-0x180]
  968fac:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  968fb3:	c4 e2 f0 f5 ca       	bzhi   rcx,rdx,rcx
  968fb8:	8b 94 24 00 01 00 00 	mov    edx,DWORD PTR [rsp+0x100]
  968fbf:	48 23 8c 24 80 01 00 	and    rcx,QWORD PTR [rsp+0x180]
  968fc6:	00 
  968fc7:	41 be bf 01 00 00    	mov    r14d,0x1bf
  968fcd:	48 85 c9             	test   rcx,rcx
  968fd0:	0f 85 aa 01 00 00    	jne    969180 <tokenize_c_counted_raw_no_separators+0x2d00>
  968fd6:	eb 10                	jmp    968fe8 <tokenize_c_counted_raw_no_separators+0x2b68>
  968fd8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  968fdf:	00 
  968fe0:	81 ff 41 01 00 00    	cmp    edi,0x141
  968fe6:	72 40                	jb     969028 <tokenize_c_counted_raw_no_separators+0x2ba8>
  968fe8:	48 8b 8c 24 80 02 00 	mov    rcx,QWORD PTR [rsp+0x280]
  968fef:	00 
  968ff0:	83 fa 05             	cmp    edx,0x5
  968ff3:	77 22                	ja     969017 <tokenize_c_counted_raw_no_separators+0x2b97>
  968ff5:	48 8d 8f c0 fe ff ff 	lea    rcx,[rdi-0x140]
  968ffc:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  969003:	c4 e2 f0 f5 ca       	bzhi   rcx,rdx,rcx
  969008:	8b 94 24 00 01 00 00 	mov    edx,DWORD PTR [rsp+0x100]
  96900f:	48 23 8c 24 80 02 00 	and    rcx,QWORD PTR [rsp+0x280]
  969016:	00 
  969017:	41 be 7f 01 00 00    	mov    r14d,0x17f
  96901d:	48 85 c9             	test   rcx,rcx
  969020:	0f 85 5a 01 00 00    	jne    969180 <tokenize_c_counted_raw_no_separators+0x2d00>
  969026:	eb 08                	jmp    969030 <tokenize_c_counted_raw_no_separators+0x2bb0>
  969028:	81 ff 01 01 00 00    	cmp    edi,0x101
  96902e:	72 40                	jb     969070 <tokenize_c_counted_raw_no_separators+0x2bf0>
  969030:	48 8b 8c 24 00 03 00 	mov    rcx,QWORD PTR [rsp+0x300]
  969037:	00 
  969038:	83 fa 04             	cmp    edx,0x4
  96903b:	77 22                	ja     96905f <tokenize_c_counted_raw_no_separators+0x2bdf>
  96903d:	48 8d 8f 00 ff ff ff 	lea    rcx,[rdi-0x100]
  969044:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96904b:	c4 e2 f0 f5 ca       	bzhi   rcx,rdx,rcx
  969050:	8b 94 24 00 01 00 00 	mov    edx,DWORD PTR [rsp+0x100]
  969057:	48 23 8c 24 00 03 00 	and    rcx,QWORD PTR [rsp+0x300]
  96905e:	00 
  96905f:	41 be 3f 01 00 00    	mov    r14d,0x13f
  969065:	48 85 c9             	test   rcx,rcx
  969068:	0f 85 12 01 00 00    	jne    969180 <tokenize_c_counted_raw_no_separators+0x2d00>
  96906e:	eb 08                	jmp    969078 <tokenize_c_counted_raw_no_separators+0x2bf8>
  969070:	81 ff c1 00 00 00    	cmp    edi,0xc1
  969076:	72 40                	jb     9690b8 <tokenize_c_counted_raw_no_separators+0x2c38>
  969078:	48 8b 8c 24 80 03 00 	mov    rcx,QWORD PTR [rsp+0x380]
  96907f:	00 
  969080:	83 fa 03             	cmp    edx,0x3
  969083:	77 22                	ja     9690a7 <tokenize_c_counted_raw_no_separators+0x2c27>
  969085:	48 8d 8f 40 ff ff ff 	lea    rcx,[rdi-0xc0]
  96908c:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  969093:	c4 e2 f0 f5 ca       	bzhi   rcx,rdx,rcx
  969098:	8b 94 24 00 01 00 00 	mov    edx,DWORD PTR [rsp+0x100]
  96909f:	48 23 8c 24 80 03 00 	and    rcx,QWORD PTR [rsp+0x380]
  9690a6:	00 
  9690a7:	41 be ff 00 00 00    	mov    r14d,0xff
  9690ad:	48 85 c9             	test   rcx,rcx
  9690b0:	0f 85 ca 00 00 00    	jne    969180 <tokenize_c_counted_raw_no_separators+0x2d00>
  9690b6:	eb 08                	jmp    9690c0 <tokenize_c_counted_raw_no_separators+0x2c40>
  9690b8:	81 ff 81 00 00 00    	cmp    edi,0x81
  9690be:	72 3d                	jb     9690fd <tokenize_c_counted_raw_no_separators+0x2c7d>
  9690c0:	48 8b 8c 24 80 04 00 	mov    rcx,QWORD PTR [rsp+0x480]
  9690c7:	00 
  9690c8:	83 fa 02             	cmp    edx,0x2
  9690cb:	77 1f                	ja     9690ec <tokenize_c_counted_raw_no_separators+0x2c6c>
  9690cd:	48 8d 4f 80          	lea    rcx,[rdi-0x80]
  9690d1:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  9690d8:	c4 e2 f0 f5 ca       	bzhi   rcx,rdx,rcx
  9690dd:	8b 94 24 00 01 00 00 	mov    edx,DWORD PTR [rsp+0x100]
  9690e4:	48 23 8c 24 80 04 00 	and    rcx,QWORD PTR [rsp+0x480]
  9690eb:	00 
  9690ec:	41 be bf 00 00 00    	mov    r14d,0xbf
  9690f2:	48 85 c9             	test   rcx,rcx
  9690f5:	0f 85 85 00 00 00    	jne    969180 <tokenize_c_counted_raw_no_separators+0x2d00>
  9690fb:	eb 05                	jmp    969102 <tokenize_c_counted_raw_no_separators+0x2c82>
  9690fd:	83 ff 41             	cmp    edi,0x41
  969100:	72 39                	jb     96913b <tokenize_c_counted_raw_no_separators+0x2cbb>
  969102:	48 8b 8c 24 80 00 00 	mov    rcx,QWORD PTR [rsp+0x80]
  969109:	00 
  96910a:	83 fa 01             	cmp    edx,0x1
  96910d:	77 1f                	ja     96912e <tokenize_c_counted_raw_no_separators+0x2cae>
  96910f:	48 8d 4f c0          	lea    rcx,[rdi-0x40]
  969113:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96911a:	c4 e2 f0 f5 ca       	bzhi   rcx,rdx,rcx
  96911f:	8b 94 24 00 01 00 00 	mov    edx,DWORD PTR [rsp+0x100]
  969126:	48 23 8c 24 80 00 00 	and    rcx,QWORD PTR [rsp+0x80]
  96912d:	00 
  96912e:	41 be 7f 00 00 00    	mov    r14d,0x7f
  969134:	48 85 c9             	test   rcx,rcx
  969137:	75 47                	jne    969180 <tokenize_c_counted_raw_no_separators+0x2d00>
  969139:	eb 05                	jmp    969140 <tokenize_c_counted_raw_no_separators+0x2cc0>
  96913b:	48 85 ff             	test   rdi,rdi
  96913e:	74 64                	je     9691a4 <tokenize_c_counted_raw_no_separators+0x2d24>
  969140:	48 8b 4c 24 60       	mov    rcx,QWORD PTR [rsp+0x60]
  969145:	85 d2                	test   edx,edx
  969147:	74 0d                	je     969156 <tokenize_c_counted_raw_no_separators+0x2cd6>
  969149:	41 be 3f 00 00 00    	mov    r14d,0x3f
  96914f:	48 85 c9             	test   rcx,rcx
  969152:	75 2c                	jne    969180 <tokenize_c_counted_raw_no_separators+0x2d00>
  969154:	eb 4e                	jmp    9691a4 <tokenize_c_counted_raw_no_separators+0x2d24>
  969156:	48 c7 c1 ff ff ff ff 	mov    rcx,0xffffffffffffffff
  96915d:	c4 e2 c0 f5 c9       	bzhi   rcx,rcx,rdi
  969162:	48 23 4c 24 60       	and    rcx,QWORD PTR [rsp+0x60]
  969167:	41 be 3f 00 00 00    	mov    r14d,0x3f
  96916d:	48 85 c9             	test   rcx,rcx
  969170:	74 32                	je     9691a4 <tokenize_c_counted_raw_no_separators+0x2d24>
  969172:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  969179:	1f 84 00 00 00 00 00 
  969180:	f3 48 0f bd c9       	lzcnt  rcx,rcx
  969185:	41 29 ce             	sub    r14d,ecx
  969188:	41 83 fe 3f          	cmp    r14d,0x3f
  96918c:	0f 87 5e fd ff ff    	ja     968ef0 <tokenize_c_counted_raw_no_separators+0x2a70>
  969192:	48 8b 8c 24 b8 00 00 	mov    rcx,QWORD PTR [rsp+0xb8]
  969199:	00 
  96919a:	4c 0f a3 f1          	bt     rcx,r14
  96919e:	0f 83 4c fd ff ff    	jae    968ef0 <tokenize_c_counted_raw_no_separators+0x2a70>
  9691a4:	b1 01                	mov    cl,0x1
  9691a6:	89 8c 24 40 03 00 00 	mov    DWORD PTR [rsp+0x340],ecx
  9691ad:	c4 c2 b0 f3 c9       	blsr   r9,r9
  9691b2:	0f 85 74 fd ff ff    	jne    968f2c <tokenize_c_counted_raw_no_separators+0x2aac>
  9691b8:	e9 e3 fc ff ff       	jmp    968ea0 <tokenize_c_counted_raw_no_separators+0x2a20>
  9691bd:	62 a1 45 00 ef ff    	vpxord xmm23,xmm23,xmm23
  9691c3:	62 01 35 00 ef c9    	vpxord xmm25,xmm25,xmm25
  9691c9:	62 a1 4d 00 ef f6    	vpxord xmm22,xmm22,xmm22
  9691cf:	90                   	nop
  9691d0:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
  9691d6:	62 b3 85 40 03 c3 07 	valignq zmm0,zmm31,zmm19,0x7
  9691dd:	62 23 8d 40 03 c3 07 	valignq zmm24,zmm30,zmm19,0x7
  9691e4:	62 23 95 40 03 e3 07 	valignq zmm28,zmm29,zmm19,0x7
  9691eb:	62 01 8d 40 eb d7    	vporq  zmm26,zmm30,zmm31
  9691f1:	62 f1 bd 40 eb c0    	vporq  zmm0,zmm24,zmm0
  9691f7:	62 03 8d 40 71 c0 02 	vpshldq zmm24,zmm30,zmm24,0x2
  9691fe:	62 03 95 40 71 dc 01 	vpshldq zmm27,zmm29,zmm28,0x1
  969205:	62 f3 ad 40 71 c0 01 	vpshldq zmm0,zmm26,zmm0,0x1
  96920c:	62 03 fd 48 25 d8 fe 	vpternlogq zmm27,zmm0,zmm24,0xfe
  969213:	62 93 95 40 71 c4 02 	vpshldq zmm0,zmm29,zmm28,0x2
  96921a:	62 03 95 40 71 e4 03 	vpshldq zmm28,zmm29,zmm28,0x3
  969221:	62 63 a5 40 25 e0 fe 	vpternlogq zmm28,zmm27,zmm0,0xfe
  969228:	62 91 9d 40 df c7    	vpandnq zmm0,zmm28,zmm31
  96922e:	62 01 9d 40 df d6    	vpandnq zmm26,zmm28,zmm30
  969234:	62 01 9d 40 df c5    	vpandnq zmm24,zmm28,zmm29
  96923a:	62 23 fd 48 03 db 07 	valignq zmm27,zmm0,zmm19,0x7
  969241:	62 23 ad 40 03 e3 07 	valignq zmm28,zmm26,zmm19,0x7
  969248:	62 81 fd 48 eb da    	vporq  zmm19,zmm0,zmm26
  96924e:	62 a1 fd 48 eb f6    	vporq  zmm22,zmm0,zmm22
  969254:	62 01 ad 40 eb c9    	vporq  zmm25,zmm26,zmm25
  96925a:	62 a1 bd 40 eb ff    	vporq  zmm23,zmm24,zmm23
  969260:	62 e1 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x140],zmm19
  969267:	05 
  969268:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x140]
  96926f:	05 
  969270:	62 01 a5 40 eb dc    	vporq  zmm27,zmm27,zmm28
  969276:	62 03 ad 40 71 e4 02 	vpshldq zmm28,zmm26,zmm28,0x2
  96927d:	62 03 e5 40 71 db 01 	vpshldq zmm27,zmm19,zmm27,0x1
  969284:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
  96928a:	62 a3 bd 40 03 db 07 	valignq zmm19,zmm24,zmm19,0x7
  969291:	62 61 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x140],zmm27
  969298:	05 
  969299:	62 23 bd 40 71 db 01 	vpshldq zmm27,zmm24,zmm19,0x1
  9692a0:	62 01 9d 40 eb db    	vporq  zmm27,zmm28,zmm27
  9692a6:	62 23 bd 40 71 e3 02 	vpshldq zmm28,zmm24,zmm19,0x2
  9692ad:	62 a3 bd 40 71 db 03 	vpshldq zmm19,zmm24,zmm19,0x3
  9692b4:	62 83 a5 40 25 dc fe 	vpternlogq zmm19,zmm27,zmm28,0xfe
  9692bb:	62 e3 ad 40 25 5c 24 	vpternlogq zmm19,zmm26,ZMMWORD PTR [rsp+0x140],0xfe
  9692c2:	05 fe 
  9692c4:	62 e3 bd 40 25 d8 fe 	vpternlogq zmm19,zmm24,zmm0,0xfe
  9692cb:	62 01 e5 40 df ed    	vpandnq zmm29,zmm19,zmm29
  9692d1:	62 01 e5 40 df ff    	vpandnq zmm31,zmm19,zmm31
  9692d7:	62 01 e5 40 df f6    	vpandnq zmm30,zmm19,zmm30
  9692dd:	62 91 fd 48 6f c5    	vmovdqa64 zmm0,zmm29
  9692e3:	62 93 85 40 25 c6 fe 	vpternlogq zmm0,zmm31,zmm30,0xfe
  9692ea:	62 f2 7d 48 27 c0    	vptestmd k0,zmm0,zmm0
  9692f0:	c5 f8 98 c0          	kortestw k0,k0
  9692f4:	0f 85 d6 fe ff ff    	jne    9691d0 <tokenize_c_counted_raw_no_separators+0x2d50>
  9692fa:	62 01 25 00 ef db    	vpxord xmm27,xmm27,xmm27
  969300:	62 03 cd 40 03 c3 07 	valignq zmm24,zmm22,zmm27,0x7
  969307:	62 93 b5 40 03 c3 07 	valignq zmm0,zmm25,zmm27,0x7
  96930e:	62 03 c5 40 03 eb 07 	valignq zmm29,zmm23,zmm27,0x7
  969315:	62 81 cd 40 eb d9    	vporq  zmm19,zmm22,zmm25
  96931b:	62 61 bd 40 eb d0    	vporq  zmm26,zmm24,zmm0
  969321:	62 03 c5 40 71 dd 01 	vpshldq zmm27,zmm23,zmm29,0x1
  969328:	62 03 c5 40 71 e5 02 	vpshldq zmm28,zmm23,zmm29,0x2
  96932f:	62 83 e5 40 71 da 01 	vpshldq zmm19,zmm19,zmm26,0x1
  969336:	62 63 b5 40 71 d0 02 	vpshldq zmm26,zmm25,zmm0,0x2
  96933d:	62 03 e5 40 25 e3 fe 	vpternlogq zmm28,zmm19,zmm27,0xfe
  969344:	62 03 c5 40 71 dd 03 	vpshldq zmm27,zmm23,zmm29,0x3
  96934b:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
  969351:	62 03 a5 40 25 e2 fe 	vpternlogq zmm28,zmm27,zmm26,0xfe
  969358:	e9 88 eb ff ff       	jmp    967ee5 <tokenize_c_counted_raw_no_separators+0x1a65>
  96935d:	f6 84 24 40 03 00 00 	test   BYTE PTR [rsp+0x340],0x1
  969364:	01 
  969365:	0f 84 2e ea ff ff    	je     967d99 <tokenize_c_counted_raw_no_separators+0x1919>
  96936b:	4c 89 f9             	mov    rcx,r15
  96936e:	48 2b 8c 24 68 04 00 	sub    rcx,QWORD PTR [rsp+0x468]
  969375:	00 
  969376:	48 8b bc 24 b0 00 00 	mov    rdi,QWORD PTR [rsp+0xb0]
  96937d:	00 
  96937e:	48 c1 f9 02          	sar    rcx,0x2
  969382:	80 24 0f 80          	and    BYTE PTR [rdi+rcx*1],0x80
  969386:	e9 0e ea ff ff       	jmp    967d99 <tokenize_c_counted_raw_no_separators+0x1919>
  96938b:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  969390:	62 71 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x600],zmm14
  969397:	18 
  969398:	62 f1 7c 48 28 42 02 	vmovaps zmm0,ZMMWORD PTR [rdx+0x80]
  96939f:	62 e1 fd 48 6f 0a    	vmovdqa64 zmm17,ZMMWORD PTR [rdx]
  9693a5:	62 e1 fd 48 6f 5a 01 	vmovdqa64 zmm19,ZMMWORD PTR [rdx+0x40]
  9693ac:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x4c0],zmm0
  9693b3:	13 
  9693b4:	62 f1 7c 48 28 42 03 	vmovaps zmm0,ZMMWORD PTR [rdx+0xc0]
  9693bb:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x380],zmm17
  9693c2:	0e 
  9693c3:	62 e1 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x840],zmm19
  9693ca:	21 
  9693cb:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x240],zmm0
  9693d2:	09 
  9693d3:	62 f1 7c 48 28 42 04 	vmovaps zmm0,ZMMWORD PTR [rdx+0x100]
  9693da:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x100],zmm0
  9693e1:	04 
  9693e2:	62 f1 7c 48 28 42 05 	vmovaps zmm0,ZMMWORD PTR [rdx+0x140]
  9693e9:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x2c0],zmm0
  9693f0:	0b 
  9693f1:	62 f1 7c 48 28 42 06 	vmovaps zmm0,ZMMWORD PTR [rdx+0x180]
  9693f8:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x300],zmm0
  9693ff:	0c 
  969400:	62 f1 7c 48 28 42 07 	vmovaps zmm0,ZMMWORD PTR [rdx+0x1c0]
  969407:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x480],zmm0
  96940e:	12 
  96940f:	62 f2 7d 48 5a 05 77 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffac2577]        # 42b990 <c_testsuite_feature.marker+0x148c>
  969416:	25 ac ff 
  969419:	62 f1 75 40 74 c0    	vpcmpeqb k0,zmm17,zmm0
  96941f:	62 e2 7d 48 5a 0d 77 	vbroadcasti32x4 zmm17,XMMWORD PTR [rip+0xffffffffffac2577]        # 42b9a0 <c_testsuite_feature.marker+0x149c>
  969426:	25 ac ff 
  969429:	c4 61 fb 93 d8       	kmovq  r11,k0
  96942e:	62 f1 65 40 74 c0    	vpcmpeqb k0,zmm19,zmm0
  969434:	c4 61 fb 93 f0       	kmovq  r14,k0
  969439:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x4c0]
  969440:	13 
  969441:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  969446:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x240]
  96944d:	09 
  96944e:	48 89 bc 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rdi
  969455:	00 
  969456:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  96945b:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x100]
  969462:	04 
  969463:	48 89 bc 24 c0 03 00 	mov    QWORD PTR [rsp+0x3c0],rdi
  96946a:	00 
  96946b:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  969470:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x2c0]
  969477:	0b 
  969478:	48 89 7c 24 60       	mov    QWORD PTR [rsp+0x60],rdi
  96947d:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  969482:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x300]
  969489:	0c 
  96948a:	48 89 bc 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rdi
  969491:	00 
  969492:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  969497:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x480]
  96949e:	12 
  96949f:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x380]
  9694a6:	0e 
  9694a7:	48 89 bc 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rdi
  9694ae:	00 
  9694af:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  9694b4:	62 b1 7d 48 74 c1    	vpcmpeqb k0,zmm0,zmm17
  9694ba:	62 e2 7d 48 5a 0d ac 	vbroadcasti32x4 zmm17,XMMWORD PTR [rip+0xffffffffffac24ac]        # 42b970 <c_testsuite_feature.marker+0x146c>
  9694c1:	24 ac ff 
  9694c4:	62 b1 7d 48 74 c9    	vpcmpeqb k1,zmm0,zmm17
  9694ca:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x4c0]
  9694d1:	13 
  9694d2:	62 b1 65 40 74 d1    	vpcmpeqb k2,zmm19,zmm17
  9694d8:	c4 e1 fc 45 c1       	korq   k0,k0,k1
  9694dd:	62 f1 65 40 74 0d 59 	vpcmpeqb k1,zmm19,ZMMWORD PTR [rip+0xffffffffffaa2e59]        # 40c340 <__abi_tag+0xb784>
  9694e4:	2e aa ff 
  9694e7:	62 e2 7d 48 5a 1d af 	vbroadcasti32x4 zmm19,XMMWORD PTR [rip+0xffffffffffac24af]        # 42b9a0 <c_testsuite_feature.marker+0x149c>
  9694ee:	24 ac ff 
  9694f1:	c4 e1 f8 91 84 24 80 	kmovq  QWORD PTR [rsp+0x780],k0
  9694f8:	07 00 00 
  9694fb:	62 b1 7d 48 74 d9    	vpcmpeqb k3,zmm0,zmm17
  969501:	c4 e1 f4 45 ca       	korq   k1,k1,k2
  969506:	62 b1 7d 48 74 d3    	vpcmpeqb k2,zmm0,zmm19
  96950c:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x240]
  969513:	09 
  969514:	c4 e1 ec 45 d3       	korq   k2,k2,k3
  969519:	62 b1 7d 48 74 db    	vpcmpeqb k3,zmm0,zmm19
  96951f:	62 b1 7d 48 74 e1    	vpcmpeqb k4,zmm0,zmm17
  969525:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x100]
  96952c:	04 
  96952d:	c4 e1 e4 45 dc       	korq   k3,k3,k4
  969532:	62 b1 7d 48 74 e3    	vpcmpeqb k4,zmm0,zmm19
  969538:	62 b1 7d 48 74 e9    	vpcmpeqb k5,zmm0,zmm17
  96953e:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x2c0]
  969545:	0b 
  969546:	c4 e1 dc 45 e5       	korq   k4,k4,k5
  96954b:	62 b1 7d 48 74 eb    	vpcmpeqb k5,zmm0,zmm19
  969551:	62 b1 7d 48 74 f1    	vpcmpeqb k6,zmm0,zmm17
  969557:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x300]
  96955e:	0c 
  96955f:	c4 e1 d4 45 ee       	korq   k5,k5,k6
  969564:	62 b1 7d 48 74 f3    	vpcmpeqb k6,zmm0,zmm19
  96956a:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x480]
  969571:	12 
  969572:	62 b1 7d 48 74 f9    	vpcmpeqb k7,zmm0,zmm17
  969578:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  96957d:	c5 f9 7f 84 24 00 08 	vmovdqa XMMWORD PTR [rsp+0x800],xmm0
  969584:	00 00 
  969586:	c5 fb 10 84 24 c0 00 	vmovsd xmm0,QWORD PTR [rsp+0xc0]
  96958d:	00 00 
  96958f:	c4 e1 cc 45 f7       	korq   k6,k6,k7
  969594:	62 f1 65 40 74 3d a2 	vpcmpeqb k7,zmm19,ZMMWORD PTR [rip+0xffffffffffaa2da2]        # 40c340 <__abi_tag+0xb784>
  96959b:	2d aa ff 
  96959e:	62 b1 65 40 74 c1    	vpcmpeqb k0,zmm19,zmm17
  9695a4:	62 e1 ff 08 10 4c 24 	vmovsd xmm17,QWORD PTR [rsp+0x3c0]
  9695ab:	78 
  9695ac:	c5 f8 29 84 24 c0 07 	vmovaps XMMWORD PTR [rsp+0x7c0],xmm0
  9695b3:	00 00 
  9695b5:	c5 fb 10 84 24 a0 00 	vmovsd xmm0,QWORD PTR [rsp+0xa0]
  9695bc:	00 00 
  9695be:	c4 e1 c4 45 c0       	korq   k0,k7,k0
  9695c3:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  9695c8:	c4 e1 f8 90 84 24 80 	kmovq  k0,QWORD PTR [rsp+0x780]
  9695cf:	07 00 00 
  9695d2:	62 e1 7c 08 29 4c 24 	vmovaps XMMWORD PTR [rsp+0x3c0],xmm17
  9695d9:	3c 
  9695da:	62 e1 ff 08 10 4c 24 	vmovsd xmm17,QWORD PTR [rsp+0x80]
  9695e1:	10 
  9695e2:	c5 f8 29 84 24 40 07 	vmovaps XMMWORD PTR [rsp+0x740],xmm0
  9695e9:	00 00 
  9695eb:	c5 fb 10 44 24 60    	vmovsd xmm0,QWORD PTR [rsp+0x60]
  9695f1:	c5 f9 14 84 24 40 07 	vunpcklpd xmm0,xmm0,XMMWORD PTR [rsp+0x740]
  9695f8:	00 00 
  9695fa:	62 e1 7c 08 29 4c 24 	vmovaps XMMWORD PTR [rsp+0x80],xmm17
  969601:	08 
  969602:	62 c1 fd 08 6e ce    	vmovq  xmm17,r14
  969608:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x60],xmm17
  96960f:	06 
  969610:	62 c1 fd 08 6e cb    	vmovq  xmm17,r11
  969616:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0xc0],xmm17
  96961d:	0c 
  96961e:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  969624:	c4 e1 fb 93 fe       	kmovq  rdi,k6
  969629:	c5 fc 29 84 24 40 07 	vmovaps YMMWORD PTR [rsp+0x740],ymm0
  969630:	00 00 
  969632:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0xa0],xmm17
  969639:	0a 
  96963a:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  969640:	c4 e1 fb 93 fd       	kmovq  rdi,k5
  969645:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x9c0],xmm17
  96964c:	c0 09 00 00 
  969650:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  969656:	c4 e1 fb 93 fc       	kmovq  rdi,k4
  96965b:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x8c0],xmm17
  969662:	c0 08 00 00 
  969666:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  96966c:	c4 e1 fb 93 fb       	kmovq  rdi,k3
  969671:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x880],xmm17
  969678:	80 08 00 00 
  96967c:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  969682:	c4 e1 fb 93 fa       	kmovq  rdi,k2
  969687:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x450],xmm17
  96968e:	45 
  96968f:	62 e1 7c 48 28 4a 08 	vmovaps zmm17,ZMMWORD PTR [rdx+0x200]
  969696:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  96969b:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  9696a0:	62 e1 7c 48 29 4c 24 	vmovaps ZMMWORD PTR [rsp+0x900],zmm17
  9696a7:	24 
  9696a8:	62 e1 7c 08 28 4c 24 	vmovaps xmm17,XMMWORD PTR [rsp+0x7c0]
  9696af:	7c 
  9696b0:	62 e1 f5 00 14 8c 24 	vunpcklpd xmm17,xmm17,XMMWORD PTR [rsp+0x800]
  9696b7:	00 08 00 00 
  9696bb:	c5 f9 7f 84 24 00 08 	vmovdqa XMMWORD PTR [rsp+0x800],xmm0
  9696c2:	00 00 
  9696c4:	62 f2 7d 48 5a 05 e2 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffac22e2]        # 42b9b0 <c_testsuite_feature.marker+0x14ac>
  9696cb:	22 ac ff 
  9696ce:	62 e1 7c 08 29 8c 24 	vmovaps XMMWORD PTR [rsp+0x980],xmm17
  9696d5:	80 09 00 00 
  9696d9:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  9696df:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  9696e4:	62 f1 65 40 74 c8    	vpcmpeqb k1,zmm19,zmm0
  9696ea:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x380]
  9696f1:	0e 
  9696f2:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x7c0],xmm17
  9696f9:	7c 
  9696fa:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  969700:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  969705:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x300]
  96970c:	0c 
  96970d:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x780],xmm17
  969714:	78 
  969715:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  96971b:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x440],xmm17
  969722:	44 
  969723:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  969728:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x2c0]
  96972f:	0b 
  969730:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  969736:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x430],xmm17
  96973d:	43 
  96973e:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  969743:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x100]
  96974a:	04 
  96974b:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  969751:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x940],xmm17
  969758:	40 09 00 00 
  96975c:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  969761:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x240]
  969768:	09 
  969769:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  96976f:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x6f0],xmm17
  969776:	6f 
  969777:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  96977c:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x4c0]
  969783:	13 
  969784:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  96978a:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x6e0],xmm17
  969791:	6e 
  969792:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x840]
  969799:	21 
  96979a:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  96979f:	62 f1 75 40 74 c8    	vpcmpeqb k1,zmm17,zmm0
  9697a5:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  9697aa:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  9697af:	c5 f9 7f 84 24 d0 06 	vmovdqa XMMWORD PTR [rsp+0x6d0],xmm0
  9697b6:	00 00 
  9697b8:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  9697bd:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  9697c2:	c5 f9 7f 84 24 c0 06 	vmovdqa XMMWORD PTR [rsp+0x6c0],xmm0
  9697c9:	00 00 
  9697cb:	62 f2 7d 48 5a 05 eb 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffac21eb]        # 42b9c0 <c_testsuite_feature.marker+0x14bc>
  9697d2:	21 ac ff 
  9697d5:	62 e1 fd 08 6e df    	vmovq  xmm19,rdi
  9697db:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x480]
  9697e2:	12 
  9697e3:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x380]
  9697ea:	0e 
  9697eb:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x380],xmm19
  9697f2:	38 
  9697f3:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  9697f8:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x300]
  9697ff:	0c 
  969800:	62 e1 fd 08 6e df    	vmovq  xmm19,rdi
  969806:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x300],xmm19
  96980d:	30 
  96980e:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  969813:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x2c0]
  96981a:	0b 
  96981b:	62 e1 fd 08 6e df    	vmovq  xmm19,rdi
  969821:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x2c0],xmm19
  969828:	2c 
  969829:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  96982e:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x100]
  969835:	04 
  969836:	62 e1 fd 08 6e df    	vmovq  xmm19,rdi
  96983c:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x480],xmm19
  969843:	48 
  969844:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  969849:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x240]
  969850:	09 
  969851:	62 e1 fd 08 6e df    	vmovq  xmm19,rdi
  969857:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x240],xmm19
  96985e:	24 
  96985f:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  969864:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x4c0]
  96986b:	13 
  96986c:	62 e1 fd 08 6e df    	vmovq  xmm19,rdi
  969872:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x6b0],xmm19
  969879:	6b 
  96987a:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  96987f:	62 f1 75 40 74 c8    	vpcmpeqb k1,zmm17,zmm0
  969885:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  96988b:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  969890:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x840],xmm17
  969897:	40 08 00 00 
  96989b:	62 e1 fd 08 6e cf    	vmovq  xmm17,rdi
  9698a1:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  9698a6:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x6a0],xmm17
  9698ad:	6a 
  9698ae:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x900]
  9698b5:	24 
  9698b6:	62 e1 fd 08 6e df    	vmovq  xmm19,rdi
  9698bc:	62 f1 75 40 74 0d 3a 	vpcmpeqb k1,zmm17,ZMMWORD PTR [rip+0xffffffffffaa2a3a]        # 40c300 <__abi_tag+0xb744>
  9698c3:	2a aa ff 
  9698c6:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x690],xmm19
  9698cd:	69 
  9698ce:	62 e1 7c 08 28 5c 24 	vmovaps xmm19,XMMWORD PTR [rsp+0xc0]
  9698d5:	0c 
  9698d6:	62 e1 e5 00 14 5c 24 	vunpcklpd xmm19,xmm19,XMMWORD PTR [rsp+0x60]
  9698dd:	06 
  9698de:	62 f1 75 40 74 c0    	vpcmpeqb k0,zmm17,zmm0
  9698e4:	c4 e1 fb 93 f9       	kmovq  rdi,k1
  9698e9:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  9698ee:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  9698f3:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x900],zmm0
  9698fa:	24 
  9698fb:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  969900:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0xa00],zmm0
  969907:	28 
  969908:	c5 fc 28 84 24 40 07 	vmovaps ymm0,YMMWORD PTR [rsp+0x740]
  96990f:	00 00 
  969911:	62 e3 7d 28 18 8c 24 	vinsertf32x4 ymm17,ymm0,XMMWORD PTR [rsp+0x980],0x1
  969918:	80 09 00 00 01 
  96991d:	c5 f8 28 84 24 80 00 	vmovaps xmm0,XMMWORD PTR [rsp+0x80]
  969924:	00 00 
  969926:	c5 f9 14 84 24 c0 03 	vunpcklpd xmm0,xmm0,XMMWORD PTR [rsp+0x3c0]
  96992d:	00 00 
  96992f:	62 f3 65 20 18 c0 01 	vinsertf32x4 ymm0,ymm19,xmm0,0x1
  969936:	62 b3 fd 48 1a c1 01 	vinsertf64x4 zmm0,zmm0,ymm17,0x1
  96993d:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x100],zmm0
  969944:	04 
  969945:	c5 f8 28 84 24 c0 09 	vmovaps xmm0,XMMWORD PTR [rsp+0x9c0]
  96994c:	00 00 
  96994e:	62 e1 fd 08 14 4c 24 	vunpcklpd xmm17,xmm0,XMMWORD PTR [rsp+0xa0]
  969955:	0a 
  969956:	c5 f8 28 84 24 80 08 	vmovaps xmm0,XMMWORD PTR [rsp+0x880]
  96995d:	00 00 
  96995f:	62 e1 fd 08 14 9c 24 	vunpcklpd xmm19,xmm0,XMMWORD PTR [rsp+0x8c0]
  969966:	c0 08 00 00 
  96996a:	62 b3 65 20 18 c1 01 	vinsertf32x4 ymm0,ymm19,xmm17,0x1
  969971:	62 e1 7c 08 28 9c 24 	vmovaps xmm19,XMMWORD PTR [rsp+0x800]
  969978:	00 08 00 00 
  96997c:	62 e1 7c 08 28 4c 24 	vmovaps xmm17,XMMWORD PTR [rsp+0x780]
  969983:	78 
  969984:	62 e1 e5 00 14 5c 24 	vunpcklpd xmm19,xmm19,XMMWORD PTR [rsp+0x450]
  96998b:	45 
  96998c:	62 e1 f5 00 14 4c 24 	vunpcklpd xmm17,xmm17,XMMWORD PTR [rsp+0x7c0]
  969993:	7c 
  969994:	c5 fc 29 84 24 c0 04 	vmovaps YMMWORD PTR [rsp+0x4c0],ymm0
  96999b:	00 00 
  96999d:	62 a3 75 20 18 cb 01 	vinsertf32x4 ymm17,ymm17,xmm19,0x1
  9699a4:	62 f3 f5 40 1a 44 24 	vinsertf64x4 zmm0,zmm17,YMMWORD PTR [rsp+0x4c0],0x1
  9699ab:	26 01 
  9699ad:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x3c0],zmm0
  9699b4:	0f 
  9699b5:	c5 f8 28 84 24 30 04 	vmovaps xmm0,XMMWORD PTR [rsp+0x430]
  9699bc:	00 00 
  9699be:	62 e1 fd 08 14 4c 24 	vunpcklpd xmm17,xmm0,XMMWORD PTR [rsp+0x440]
  9699c5:	44 
  9699c6:	c5 f8 28 84 24 f0 06 	vmovaps xmm0,XMMWORD PTR [rsp+0x6f0]
  9699cd:	00 00 
  9699cf:	62 e1 fd 08 14 9c 24 	vunpcklpd xmm19,xmm0,XMMWORD PTR [rsp+0x940]
  9699d6:	40 09 00 00 
  9699da:	62 b3 65 20 18 c1 01 	vinsertf32x4 ymm0,ymm19,xmm17,0x1
  9699e1:	c5 fc 29 84 24 c0 04 	vmovaps YMMWORD PTR [rsp+0x4c0],ymm0
  9699e8:	00 00 
  9699ea:	c5 f8 28 84 24 d0 06 	vmovaps xmm0,XMMWORD PTR [rsp+0x6d0]
  9699f1:	00 00 
  9699f3:	62 e1 fd 08 14 5c 24 	vunpcklpd xmm19,xmm0,XMMWORD PTR [rsp+0x6e0]
  9699fa:	6e 
  9699fb:	c5 f8 28 84 24 80 03 	vmovaps xmm0,XMMWORD PTR [rsp+0x380]
  969a02:	00 00 
  969a04:	62 e1 fd 08 14 4c 24 	vunpcklpd xmm17,xmm0,XMMWORD PTR [rsp+0x6c0]
  969a0b:	6c 
  969a0c:	c5 f8 28 84 24 c0 02 	vmovaps xmm0,XMMWORD PTR [rsp+0x2c0]
  969a13:	00 00 
  969a15:	c5 f9 14 84 24 00 03 	vunpcklpd xmm0,xmm0,XMMWORD PTR [rsp+0x300]
  969a1c:	00 00 
  969a1e:	62 a3 75 20 18 cb 01 	vinsertf32x4 ymm17,ymm17,xmm19,0x1
  969a25:	62 e3 f5 40 1a 4c 24 	vinsertf64x4 zmm17,zmm17,YMMWORD PTR [rsp+0x4c0],0x1
  969a2c:	26 01 
  969a2e:	c5 f8 29 84 24 c0 02 	vmovaps XMMWORD PTR [rsp+0x2c0],xmm0
  969a35:	00 00 
  969a37:	c5 f8 28 84 24 40 02 	vmovaps xmm0,XMMWORD PTR [rsp+0x240]
  969a3e:	00 00 
  969a40:	62 e1 fd 08 14 5c 24 	vunpcklpd xmm19,xmm0,XMMWORD PTR [rsp+0x480]
  969a47:	48 
  969a48:	62 f3 65 20 18 44 24 	vinsertf32x4 ymm0,ymm19,XMMWORD PTR [rsp+0x2c0],0x1
  969a4f:	2c 01 
  969a51:	62 e1 7c 08 28 5c 24 	vmovaps xmm19,XMMWORD PTR [rsp+0x690]
  969a58:	69 
  969a59:	62 e1 e5 00 14 5c 24 	vunpcklpd xmm19,xmm19,XMMWORD PTR [rsp+0x6a0]
  969a60:	6a 
  969a61:	62 e1 7c 48 29 4c 24 	vmovaps ZMMWORD PTR [rsp+0x4c0],zmm17
  969a68:	13 
  969a69:	62 e1 74 40 56 4c 24 	vorps  zmm17,zmm17,ZMMWORD PTR [rsp+0x3c0]
  969a70:	0f 
  969a71:	c5 fc 29 84 24 40 02 	vmovaps YMMWORD PTR [rsp+0x240],ymm0
  969a78:	00 00 
  969a7a:	c5 f8 28 84 24 40 08 	vmovaps xmm0,XMMWORD PTR [rsp+0x840]
  969a81:	00 00 
  969a83:	c5 f9 14 84 24 b0 06 	vunpcklpd xmm0,xmm0,XMMWORD PTR [rsp+0x6b0]
  969a8a:	00 00 
  969a8c:	c5 f8 29 84 24 c0 02 	vmovaps XMMWORD PTR [rsp+0x2c0],xmm0
  969a93:	00 00 
  969a95:	62 e3 65 20 18 5c 24 	vinsertf32x4 ymm19,ymm19,XMMWORD PTR [rsp+0x2c0],0x1
  969a9c:	2c 01 
  969a9e:	62 e1 7c 48 29 4c 24 	vmovaps ZMMWORD PTR [rsp+0x2c0],zmm17
  969aa5:	0b 
  969aa6:	62 c1 fd 48 6f ce    	vmovdqa64 zmm17,zmm14
  969aac:	62 f3 e5 40 1a 44 24 	vinsertf64x4 zmm0,zmm19,YMMWORD PTR [rsp+0x240],0x1
  969ab3:	12 01 
  969ab5:	62 e1 fd 48 6f 1d 41 	vmovdqa64 zmm19,ZMMWORD PTR [rip+0xffffffffffaa2941]        # 40c400 <__abi_tag+0xb844>
  969abc:	29 aa ff 
  969abf:	62 e2 e5 40 7e 4c 24 	vpermt2q zmm17,zmm19,ZMMWORD PTR [rsp+0x500]
  969ac6:	14 
  969ac7:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x240],zmm0
  969ace:	09 
  969acf:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x100]
  969ad6:	04 
  969ad7:	62 d3 f5 40 71 c6 3f 	vpshldq zmm0,zmm17,zmm14,0x3f
  969ade:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x300],zmm17
  969ae5:	0c 
  969ae6:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x480],zmm0
  969aed:	12 
  969aee:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x900]
  969af5:	24 
  969af6:	62 b3 fd 48 03 c3 01 	valignq zmm0,zmm0,zmm19,0x1
  969afd:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x380],zmm0
  969b04:	0e 
  969b05:	62 b3 fd 48 71 c3 3f 	vpshldq zmm0,zmm0,zmm19,0x3f
  969b0c:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x3c0],zmm0
  969b13:	0f 
  969b14:	62 f3 f5 40 71 44 24 	vpshldq zmm0,zmm17,ZMMWORD PTR [rsp+0x600],0x3e
  969b1b:	18 3e 
  969b1d:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x3c0]
  969b24:	0f 
  969b25:	62 f3 f5 40 25 44 24 	vpternlogq zmm0,zmm17,ZMMWORD PTR [rsp+0x2c0],0x80
  969b2c:	0b 80 
  969b2e:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x240]
  969b35:	09 
  969b36:	62 f3 e5 40 25 44 24 	vpternlogq zmm0,zmm19,ZMMWORD PTR [rsp+0x480],0xf8
  969b3d:	12 f8 
  969b3f:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0xa00]
  969b46:	28 
  969b47:	62 a3 e5 40 03 d9 01 	valignq zmm19,zmm19,zmm17,0x1
  969b4e:	62 a3 e5 40 71 c9 3f 	vpshldq zmm17,zmm19,zmm17,0x3f
  969b55:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x380]
  969b5c:	0e 
  969b5d:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x240],zmm17
  969b64:	09 
  969b65:	62 e3 e5 40 71 4c 24 	vpshldq zmm17,zmm19,ZMMWORD PTR [rsp+0x100],0x3e
  969b6c:	04 3e 
  969b6e:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x100],zmm17
  969b75:	04 
  969b76:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x300]
  969b7d:	0c 
  969b7e:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x100]
  969b85:	04 
  969b86:	62 e3 f5 40 71 4c 24 	vpshldq zmm17,zmm17,ZMMWORD PTR [rsp+0x600],0x3d
  969b8d:	18 3d 
  969b8f:	62 e3 e5 40 25 4c 24 	vpternlogq zmm17,zmm19,ZMMWORD PTR [rsp+0x4c0],0x80
  969b96:	13 80 
  969b98:	62 e3 fd 48 25 4c 24 	vpternlogq zmm17,zmm0,ZMMWORD PTR [rsp+0x240],0xec
  969b9f:	09 ec 
  969ba1:	62 92 75 40 27 c7    	vptestmd k0,zmm17,zmm31
  969ba7:	c5 f8 98 c0          	kortestw k0,k0
  969bab:	0f 85 d3 15 00 00    	jne    96b184 <tokenize_c_counted_raw_no_separators+0x4d04>
  969bb1:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x2c0]
  969bb8:	0b 
  969bb9:	c5 f9 6e c3          	vmovd  xmm0,ebx
  969bbd:	4c 89 c7             	mov    rdi,r8
  969bc0:	48 d1 ef             	shr    rdi,1
  969bc3:	ba 3e 01 00 00       	mov    edx,0x13e
  969bc8:	62 f3 fd 48 03 c5 01 	valignq zmm0,zmm0,zmm5,0x1
  969bcf:	4c 21 c7             	and    rdi,r8
  969bd2:	62 e3 fd 48 71 cd 3f 	vpshldq zmm17,zmm0,zmm5,0x3f
  969bd9:	62 f3 fd 48 71 c5 3e 	vpshldq zmm0,zmm0,zmm5,0x3e
  969be0:	62 f1 85 40 db c0    	vpandq zmm0,zmm31,zmm0
  969be6:	62 a3 85 40 25 d9 80 	vpternlogq zmm19,zmm31,zmm17,0x80
  969bed:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x240]
  969bf4:	09 
  969bf5:	62 e3 fd 48 25 4c 24 	vpternlogq zmm17,zmm0,ZMMWORD PTR [rsp+0x4c0],0x80
  969bfc:	13 80 
  969bfe:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  969c02:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x240],zmm17
  969c09:	09 
  969c0a:	62 b1 f5 40 eb eb    	vporq  zmm5,zmm17,zmm19
  969c10:	62 f3 f5 40 03 c0 07 	valignq zmm0,zmm17,zmm0,0x7
  969c17:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x240]
  969c1e:	09 
  969c1f:	62 e3 f5 40 71 c8 01 	vpshldq zmm17,zmm17,zmm0,0x1
  969c26:	62 23 f5 40 25 f3 10 	vpternlogq zmm30,zmm17,zmm19,0x10
  969c2d:	62 a1 75 00 ef c9    	vpxord xmm17,xmm17,xmm17
  969c33:	62 a3 e5 40 03 c9 07 	valignq zmm17,zmm19,zmm17,0x7
  969c3a:	62 a3 e5 40 71 c9 01 	vpshldq zmm17,zmm19,zmm17,0x1
  969c41:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x100],zmm17
  969c48:	04 
  969c49:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x240]
  969c50:	09 
  969c51:	62 f3 f5 40 71 c0 02 	vpshldq zmm0,zmm17,zmm0,0x2
  969c58:	62 e3 fd 48 25 54 24 	vpternlogq zmm18,zmm0,ZMMWORD PTR [rsp+0x100],0x10
  969c5f:	04 10 
  969c61:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  969c66:	62 b3 fd 48 03 c0 01 	valignq zmm0,zmm0,zmm16,0x1
  969c6d:	62 a3 fd 48 71 c8 3f 	vpshldq zmm17,zmm0,zmm16,0x3f
  969c74:	62 b3 fd 48 71 c0 3e 	vpshldq zmm0,zmm0,zmm16,0x3e
  969c7b:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x100],zmm17
  969c82:	04 
  969c83:	62 e1 fd 48 db 4c 24 	vpandq zmm17,zmm0,ZMMWORD PTR [rsp+0x240]
  969c8a:	09 
  969c8b:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x240]
  969c92:	09 
  969c93:	62 e3 e5 40 25 4c 24 	vpternlogq zmm17,zmm19,ZMMWORD PTR [rsp+0x100],0xf8
  969c9a:	04 f8 
  969c9c:	62 a3 7d 48 39 db 03 	vextracti32x4 xmm19,zmm19,0x3
  969ca3:	62 e3 fd 08 16 df 01 	vpextrq rdi,xmm19,0x1
  969caa:	48 c1 ef 3f          	shr    rdi,0x3f
  969cae:	62 f3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm0,0x3
  969cb5:	c4 c3 f9 16 c3 01    	vpextrq r11,xmm0,0x1
  969cbb:	c4 42 e8 f7 c3       	bextr  r8,r11,rdx
  969cc0:	49 c1 eb 3f          	shr    r11,0x3f
  969cc4:	49 09 f8             	or     r8,rdi
  969cc7:	4c 89 9c 24 40 02 00 	mov    QWORD PTR [rsp+0x240],r11
  969cce:	00 
  969ccf:	4b 8d 1c 58          	lea    rbx,[r8+r11*2]
  969cd3:	e9 42 e4 ff ff       	jmp    96811a <tokenize_c_counted_raw_no_separators+0x1c9a>
  969cd8:	62 e1 8d 40 eb f6    	vporq  zmm22,zmm30,zmm6
  969cde:	31 c0                	xor    eax,eax
  969ce0:	62 61 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x3c0],zmm29
  969ce7:	0f 
  969ce8:	eb 27                	jmp    969d11 <tokenize_c_counted_raw_no_separators+0x3891>
  969cea:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  969cf0:	62 b1 fd 40 ef c7    	vpxorq zmm0,zmm16,zmm23
  969cf6:	62 92 7d 48 27 c6    	vptestmd k0,zmm0,zmm30
  969cfc:	c5 f8 98 c0          	kortestw k0,k0
  969d00:	0f 84 ba 03 00 00    	je     96a0c0 <tokenize_c_counted_raw_no_separators+0x3c40>
  969d06:	ff c0                	inc    eax
  969d08:	83 f8 04             	cmp    eax,0x4
  969d0b:	0f 84 73 14 00 00    	je     96b184 <tokenize_c_counted_raw_no_separators+0x4d04>
  969d11:	62 91 fd 40 db c6    	vpandq zmm0,zmm16,zmm30
  969d17:	62 a1 fd 48 6f f8    	vmovdqa64 zmm23,zmm16
  969d1d:	62 71 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x700],zmm14
  969d24:	1c 
  969d25:	c4 41 09 ef f6       	vpxor  xmm14,xmm14,xmm14
  969d2a:	62 a1 7d 00 ef c0    	vpxord xmm16,xmm16,xmm16
  969d30:	62 a1 55 00 ef ed    	vpxord xmm21,xmm21,xmm21
  969d36:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  969d3a:	62 21 fd 48 6f ca    	vmovdqa64 zmm25,zmm18
  969d40:	62 21 fd 48 6f d9    	vmovdqa64 zmm27,zmm17
  969d46:	62 93 fd 48 03 df 07 	valignq zmm3,zmm0,zmm31,0x7
  969d4d:	62 f3 fd 48 71 c3 01 	vpshldq zmm0,zmm0,zmm3,0x1
  969d54:	62 f3 cd 40 1e c0 01 	vpcmpltuq k0,zmm22,zmm0
  969d5b:	62 f2 cd 40 29 c8    	vpcmpeqq k1,zmm22,zmm0
  969d61:	62 f1 cd 40 fb d8    	vpsubq zmm3,zmm22,zmm0
  969d67:	c5 fd 4a c0          	kaddb  k0,k0,k0
  969d6b:	c5 fd 4a c1          	kaddb  k0,k0,k1
  969d6f:	c5 fd 47 c1          	kxorb  k0,k0,k1
  969d73:	62 f2 fe 48 38 e0    	vpmovm2q zmm4,k0
  969d79:	62 f1 e5 48 d4 dc    	vpaddq zmm3,zmm3,zmm4
  969d7f:	62 f1 e5 48 df de    	vpandnq zmm3,zmm3,zmm6
  969d85:	62 93 e5 48 03 e7 07 	valignq zmm4,zmm3,zmm31,0x7
  969d8c:	62 f3 e5 48 71 dc 01 	vpshldq zmm3,zmm3,zmm4,0x1
  969d93:	c5 d9 ef e4          	vpxor  xmm4,xmm4,xmm4
  969d97:	62 d3 fd 48 25 df f2 	vpternlogq zmm3,zmm0,zmm15,0xf2
  969d9e:	62 f3 dd 40 1e c3 01 	vpcmpltuq k0,zmm20,zmm3
  969da5:	62 f2 dd 40 29 cb    	vpcmpeqq k1,zmm20,zmm3
  969dab:	62 f1 dd 40 fb c3    	vpsubq zmm0,zmm20,zmm3
  969db1:	c5 fd 4a c0          	kaddb  k0,k0,k0
  969db5:	c5 fd 4a c1          	kaddb  k0,k0,k1
  969db9:	c5 fd 47 c1          	kxorb  k0,k0,k1
  969dbd:	62 f2 fe 48 38 d8    	vpmovm2q zmm3,k0
  969dc3:	62 f1 fd 48 d4 c3    	vpaddq zmm0,zmm0,zmm3
  969dc9:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  969dcd:	62 41 fd 48 df d5    	vpandnq zmm26,zmm0,zmm13
  969dd3:	e9 9e 00 00 00       	jmp    969e76 <tokenize_c_counted_raw_no_separators+0x39f6>
  969dd8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  969ddf:	00 
  969de0:	62 91 b5 40 eb c4    	vporq  zmm0,zmm25,zmm28
  969de6:	62 51 ad 40 eb f6    	vporq  zmm14,zmm26,zmm14
  969dec:	62 81 fd 40 eb c3    	vporq  zmm16,zmm16,zmm27
  969df2:	62 01 fd 48 eb ce    	vporq  zmm25,zmm0,zmm30
  969df8:	62 b3 b5 40 1e c3 01 	vpcmpltuq k0,zmm25,zmm19
  969dff:	62 b2 b5 40 29 cb    	vpcmpeqq k1,zmm25,zmm19
  969e05:	62 21 b5 40 fb cb    	vpsubq zmm25,zmm25,zmm19
  969e0b:	c5 fd 4a c0          	kaddb  k0,k0,k0
  969e0f:	c5 fd 4a c1          	kaddb  k0,k0,k1
  969e13:	c5 fd 47 c1          	kxorb  k0,k0,k1
  969e17:	62 62 fe 48 38 d0    	vpmovm2q zmm26,k0
  969e1d:	62 01 b5 40 d4 ca    	vpaddq zmm25,zmm25,zmm26
  969e23:	62 61 b5 40 df c8    	vpandnq zmm25,zmm25,zmm0
  969e29:	62 93 dd 40 1e c1 01 	vpcmpltuq k0,zmm20,zmm25
  969e30:	62 92 dd 40 29 c9    	vpcmpeqq k1,zmm20,zmm25
  969e36:	62 91 dd 40 fb c1    	vpsubq zmm0,zmm20,zmm25
  969e3c:	62 01 25 00 ef db    	vpxord xmm27,xmm27,xmm27
  969e42:	c5 fd 4a c0          	kaddb  k0,k0,k0
  969e46:	c5 fd 4a c1          	kaddb  k0,k0,k1
  969e4a:	c5 fd 47 c1          	kxorb  k0,k0,k1
  969e4e:	62 62 fe 48 38 c8    	vpmovm2q zmm25,k0
  969e54:	62 91 fd 48 d4 c1    	vpaddq zmm0,zmm0,zmm25
  969e5a:	62 01 35 00 ef c9    	vpxord xmm25,xmm25,xmm25
  969e60:	62 41 fd 48 df d5    	vpandnq zmm26,zmm0,zmm13
  969e66:	62 92 2d 40 27 c2    	vptestmd k0,zmm26,zmm26
  969e6c:	c5 f8 98 c0          	kortestw k0,k0
  969e70:	0f 84 7a fe ff ff    	je     969cf0 <tokenize_c_counted_raw_no_separators+0x3870>
  969e76:	62 41 ad 40 db eb    	vpandq zmm29,zmm26,zmm11
  969e7c:	62 41 ad 40 db e1    	vpandq zmm28,zmm26,zmm9
  969e82:	62 01 fd 48 6f c6    	vmovdqa64 zmm24,zmm30
  969e88:	62 01 a5 40 eb f4    	vporq  zmm30,zmm27,zmm28
  969e8e:	62 91 95 40 eb c1    	vporq  zmm0,zmm29,zmm25
  969e94:	62 61 8d 40 eb f8    	vporq  zmm31,zmm30,zmm0
  969e9a:	62 92 05 40 27 c7    	vptestmd k0,zmm31,zmm31
  969ea0:	c5 f8 98 c0          	kortestw k0,k0
  969ea4:	0f 84 e6 00 00 00    	je     969f90 <tokenize_c_counted_raw_no_separators+0x3b10>
  969eaa:	62 93 bd 40 1e c6 01 	vpcmpltuq k0,zmm24,zmm30
  969eb1:	62 92 bd 40 29 ce    	vpcmpeqq k1,zmm24,zmm30
  969eb7:	62 01 9d 40 eb e5    	vporq  zmm28,zmm28,zmm29
  969ebd:	62 01 bd 40 fb f6    	vpsubq zmm30,zmm24,zmm30
  969ec3:	c5 fd 4a c0          	kaddb  k0,k0,k0
  969ec7:	62 f1 9d 40 eb ed    	vporq  zmm5,zmm28,zmm5
  969ecd:	c5 fd 4a c1          	kaddb  k0,k0,k1
  969ed1:	c5 fd 47 c1          	kxorb  k0,k0,k1
  969ed5:	62 f2 bd 40 29 c8    	vpcmpeqq k1,zmm24,zmm0
  969edb:	62 62 fe 48 38 f8    	vpmovm2q zmm31,k0
  969ee1:	62 f3 bd 40 1e c0 01 	vpcmpltuq k0,zmm24,zmm0
  969ee8:	62 f1 bd 40 fb c0    	vpsubq zmm0,zmm24,zmm0
  969eee:	62 01 8d 40 d4 f7    	vpaddq zmm30,zmm30,zmm31
  969ef4:	c5 fd 4a c0          	kaddb  k0,k0,k0
  969ef8:	62 41 8d 40 db f1    	vpandq zmm30,zmm30,zmm9
  969efe:	c5 fd 4a c1          	kaddb  k0,k0,k1
  969f02:	c5 fd 47 c1          	kxorb  k0,k0,k1
  969f06:	62 62 fe 48 38 f8    	vpmovm2q zmm31,k0
  969f0c:	62 91 fd 48 d4 c7    	vpaddq zmm0,zmm0,zmm31
  969f12:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  969f18:	62 03 9d 40 03 ef 07 	valignq zmm29,zmm28,zmm31,0x7
  969f1f:	62 d3 8d 40 25 c2 ec 	vpternlogq zmm0,zmm30,zmm10,0xec
  969f26:	62 03 9d 40 71 ed 01 	vpshldq zmm29,zmm28,zmm29,0x1
  969f2d:	62 01 fd 48 eb f0    	vporq  zmm30,zmm0,zmm24
  969f33:	62 03 b5 40 25 dd fe 	vpternlogq zmm27,zmm25,zmm29,0xfe
  969f3a:	62 93 8d 40 1e c3 01 	vpcmpltuq k0,zmm30,zmm27
  969f41:	62 92 8d 40 29 cb    	vpcmpeqq k1,zmm30,zmm27
  969f47:	62 01 8d 40 fb cb    	vpsubq zmm25,zmm30,zmm27
  969f4d:	62 01 fd 48 6f f0    	vmovdqa64 zmm30,zmm24
  969f53:	c5 fd 4a c0          	kaddb  k0,k0,k0
  969f57:	c5 fd 4a c1          	kaddb  k0,k0,k1
  969f5b:	c5 fd 47 c1          	kxorb  k0,k0,k1
  969f5f:	62 62 fe 48 38 d8    	vpmovm2q zmm27,k0
  969f65:	62 01 b5 40 d4 cb    	vpaddq zmm25,zmm25,zmm27
  969f6b:	62 93 b5 40 25 c0 10 	vpternlogq zmm0,zmm25,zmm24,0x10
  969f72:	62 93 b5 40 25 e0 f2 	vpternlogq zmm4,zmm25,zmm24,0xf2
  969f79:	62 03 fd 48 03 cf 07 	valignq zmm25,zmm0,zmm31,0x7
  969f80:	62 f1 fd 48 eb db    	vporq  zmm3,zmm0,zmm3
  969f86:	62 03 fd 48 71 c9 01 	vpshldq zmm25,zmm0,zmm25,0x1
  969f8d:	eb 13                	jmp    969fa2 <tokenize_c_counted_raw_no_separators+0x3b22>
  969f8f:	90                   	nop
  969f90:	62 01 35 00 ef c9    	vpxord xmm25,xmm25,xmm25
  969f96:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  969f9c:	62 01 fd 48 6f f0    	vmovdqa64 zmm30,zmm24
  969fa2:	62 61 ad 40 db e7    	vpandq zmm28,zmm26,zmm7
  969fa8:	62 c3 ad 40 25 ec f8 	vpternlogq zmm21,zmm26,zmm12,0xf8
  969faf:	62 92 1d 40 27 c4    	vptestmd k0,zmm28,zmm28
  969fb5:	c5 f8 98 c0          	kortestw k0,k0
  969fb9:	0f 84 6a fe ff ff    	je     969e29 <tokenize_c_counted_raw_no_separators+0x39a9>
  969fbf:	62 93 9d 40 03 c7 07 	valignq zmm0,zmm28,zmm31,0x7
  969fc6:	62 f3 9d 40 71 c0 03 	vpshldq zmm0,zmm28,zmm0,0x3
  969fcd:	62 61 cd 48 df d0    	vpandnq zmm26,zmm6,zmm0
  969fd3:	62 93 cd 48 1e c2 01 	vpcmpltuq k0,zmm6,zmm26
  969fda:	62 92 cd 48 29 ca    	vpcmpeqq k1,zmm6,zmm26
  969fe0:	62 01 cd 48 fb d2    	vpsubq zmm26,zmm6,zmm26
  969fe6:	c5 fd 4a c0          	kaddb  k0,k0,k0
  969fea:	c5 fd 4a c1          	kaddb  k0,k0,k1
  969fee:	c5 fd 47 c1          	kxorb  k0,k0,k1
  969ff2:	62 62 fe 48 38 d8    	vpmovm2q zmm27,k0
  969ff8:	62 01 ad 40 d4 d3    	vpaddq zmm26,zmm26,zmm27
  969ffe:	62 63 cd 48 25 d0 8c 	vpternlogq zmm26,zmm6,zmm0,0x8c
  96a005:	62 93 ad 40 1e c4 01 	vpcmpltuq k0,zmm26,zmm28
  96a00c:	62 92 ad 40 29 cc    	vpcmpeqq k1,zmm26,zmm28
  96a012:	62 91 ad 40 fb c4    	vpsubq zmm0,zmm26,zmm28
  96a018:	c5 fd 4a c0          	kaddb  k0,k0,k0
  96a01c:	c5 fd 4a c1          	kaddb  k0,k0,k1
  96a020:	c5 fd 47 c1          	kxorb  k0,k0,k1
  96a024:	62 62 fe 48 38 d8    	vpmovm2q zmm27,k0
  96a02a:	62 01 fd 48 d4 db    	vpaddq zmm27,zmm0,zmm27
  96a030:	62 93 ad 40 03 c7 07 	valignq zmm0,zmm26,zmm31,0x7
  96a037:	62 03 ad 40 25 dc fe 	vpternlogq zmm27,zmm26,zmm28,0xfe
  96a03e:	62 92 25 40 27 c6    	vptestmd k0,zmm27,zmm30
  96a044:	62 63 ad 40 71 e0 01 	vpshldq zmm28,zmm26,zmm0,0x1
  96a04b:	c5 f8 98 c0          	kortestw k0,k0
  96a04f:	0f 84 8b fd ff ff    	je     969de0 <tokenize_c_counted_raw_no_separators+0x3960>
  96a055:	62 91 8d 40 df c4    	vpandnq zmm0,zmm30,zmm28
  96a05b:	62 f3 8d 40 1e c0 01 	vpcmpltuq k0,zmm30,zmm0
  96a062:	62 f2 8d 40 29 c8    	vpcmpeqq k1,zmm30,zmm0
  96a068:	62 f1 8d 40 fb c0    	vpsubq zmm0,zmm30,zmm0
  96a06e:	c5 fd 4a c0          	kaddb  k0,k0,k0
  96a072:	c5 fd 4a c1          	kaddb  k0,k0,k1
  96a076:	c5 fd 47 c1          	kxorb  k0,k0,k1
  96a07a:	62 62 fe 48 38 e8    	vpmovm2q zmm29,k0
  96a080:	62 91 fd 48 d4 c5    	vpaddq zmm0,zmm0,zmm29
  96a086:	62 91 fd 48 ef c6    	vpxorq zmm0,zmm0,zmm30
  96a08c:	62 93 9d 40 25 c3 fe 	vpternlogq zmm0,zmm28,zmm27,0xfe
  96a093:	62 f1 fd 48 df ed    	vpandnq zmm5,zmm0,zmm5
  96a099:	62 f1 fd 48 df db    	vpandnq zmm3,zmm0,zmm3
  96a09f:	62 f1 fd 48 df e4    	vpandnq zmm4,zmm0,zmm4
  96a0a5:	62 a1 fd 48 df ed    	vpandnq zmm21,zmm0,zmm21
  96a0ab:	62 a1 fd 48 df c0    	vpandnq zmm16,zmm0,zmm16
  96a0b1:	62 01 fd 48 df c9    	vpandnq zmm25,zmm0,zmm25
  96a0b7:	e9 24 fd ff ff       	jmp    969de0 <tokenize_c_counted_raw_no_separators+0x3960>
  96a0bc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
  96a0c0:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x700]
  96a0c7:	1c 
  96a0c8:	62 13 7d 48 39 f0 03 	vextracti32x4 xmm24,zmm14,0x3
  96a0cf:	62 a3 7d 48 39 ff 03 	vextracti32x4 xmm23,zmm23,0x3
  96a0d6:	62 83 7d 48 39 c1 03 	vextracti32x4 xmm25,zmm16,0x3
  96a0dd:	62 a1 b5 00 6d ff    	vpunpckhqdq xmm23,xmm25,xmm23
  96a0e3:	62 f3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm0,0x3
  96a0ea:	62 f1 bd 00 6d c0    	vpunpckhqdq xmm0,xmm24,xmm0
  96a0f0:	62 b1 fd 08 df c7    	vpandnq xmm0,xmm0,xmm23
  96a0f6:	62 e1 7d 08 70 f8 ee 	vpshufd xmm23,xmm0,0xee
  96a0fd:	62 b1 fd 08 ef c7    	vpxorq xmm0,xmm0,xmm23
  96a103:	c4 e1 f9 7e c1       	vmovq  rcx,xmm0
  96a108:	48 85 c9             	test   rcx,rcx
  96a10b:	0f 88 f5 fb ff ff    	js     969d06 <tokenize_c_counted_raw_no_separators+0x3886>
  96a111:	62 61 fd 48 6f 6c 24 	vmovdqa64 zmm29,ZMMWORD PTR [rsp+0x3c0]
  96a118:	0f 
  96a119:	e9 0a da ff ff       	jmp    967b28 <tokenize_c_counted_raw_no_separators+0x16a8>
  96a11e:	b1 01                	mov    cl,0x1
  96a120:	e9 0e 02 00 00       	jmp    96a333 <tokenize_c_counted_raw_no_separators+0x3eb3>
  96a125:	c4 e2 c0 f5 c9       	bzhi   rcx,rcx,rdi
  96a12a:	48 f7 d1             	not    rcx
  96a12d:	48 89 8c 24 80 01 00 	mov    QWORD PTR [rsp+0x180],rcx
  96a134:	00 
  96a135:	48 8d 4f c0          	lea    rcx,[rdi-0x40]
  96a139:	48 85 c9             	test   rcx,rcx
  96a13c:	7e 19                	jle    96a157 <tokenize_c_counted_raw_no_separators+0x3cd7>
  96a13e:	48 83 f9 3f          	cmp    rcx,0x3f
  96a142:	76 04                	jbe    96a148 <tokenize_c_counted_raw_no_separators+0x3cc8>
  96a144:	31 f6                	xor    esi,esi
  96a146:	eb 0f                	jmp    96a157 <tokenize_c_counted_raw_no_separators+0x3cd7>
  96a148:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96a14f:	c4 e2 f0 f5 f2       	bzhi   rsi,rdx,rcx
  96a154:	48 f7 d6             	not    rsi
  96a157:	48 8d 4f 80          	lea    rcx,[rdi-0x80]
  96a15b:	49 c7 c1 ff ff ff ff 	mov    r9,0xffffffffffffffff
  96a162:	49 c7 c0 ff ff ff ff 	mov    r8,0xffffffffffffffff
  96a169:	48 85 c9             	test   rcx,rcx
  96a16c:	7e 1a                	jle    96a188 <tokenize_c_counted_raw_no_separators+0x3d08>
  96a16e:	48 83 f9 3f          	cmp    rcx,0x3f
  96a172:	76 05                	jbe    96a179 <tokenize_c_counted_raw_no_separators+0x3cf9>
  96a174:	45 31 c0             	xor    r8d,r8d
  96a177:	eb 0f                	jmp    96a188 <tokenize_c_counted_raw_no_separators+0x3d08>
  96a179:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96a180:	c4 62 f0 f5 c2       	bzhi   r8,rdx,rcx
  96a185:	49 f7 d0             	not    r8
  96a188:	48 8d 8f 40 ff ff ff 	lea    rcx,[rdi-0xc0]
  96a18f:	48 85 c9             	test   rcx,rcx
  96a192:	7e 1a                	jle    96a1ae <tokenize_c_counted_raw_no_separators+0x3d2e>
  96a194:	48 83 f9 3f          	cmp    rcx,0x3f
  96a198:	76 05                	jbe    96a19f <tokenize_c_counted_raw_no_separators+0x3d1f>
  96a19a:	45 31 c9             	xor    r9d,r9d
  96a19d:	eb 0f                	jmp    96a1ae <tokenize_c_counted_raw_no_separators+0x3d2e>
  96a19f:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96a1a6:	c4 62 f0 f5 ca       	bzhi   r9,rdx,rcx
  96a1ab:	49 f7 d1             	not    r9
  96a1ae:	48 89 b4 24 00 05 00 	mov    QWORD PTR [rsp+0x500],rsi
  96a1b5:	00 
  96a1b6:	48 8d b7 00 ff ff ff 	lea    rsi,[rdi-0x100]
  96a1bd:	48 c7 c1 ff ff ff ff 	mov    rcx,0xffffffffffffffff
  96a1c4:	48 85 f6             	test   rsi,rsi
  96a1c7:	7e 12                	jle    96a1db <tokenize_c_counted_raw_no_separators+0x3d5b>
  96a1c9:	48 83 fe 3f          	cmp    rsi,0x3f
  96a1cd:	76 04                	jbe    96a1d3 <tokenize_c_counted_raw_no_separators+0x3d53>
  96a1cf:	31 c9                	xor    ecx,ecx
  96a1d1:	eb 08                	jmp    96a1db <tokenize_c_counted_raw_no_separators+0x3d5b>
  96a1d3:	c4 e2 c8 f5 c9       	bzhi   rcx,rcx,rsi
  96a1d8:	48 f7 d1             	not    rcx
  96a1db:	48 8d b7 c0 fe ff ff 	lea    rsi,[rdi-0x140]
  96a1e2:	48 85 f6             	test   rsi,rsi
  96a1e5:	7e 1a                	jle    96a201 <tokenize_c_counted_raw_no_separators+0x3d81>
  96a1e7:	48 83 fe 3f          	cmp    rsi,0x3f
  96a1eb:	76 05                	jbe    96a1f2 <tokenize_c_counted_raw_no_separators+0x3d72>
  96a1ed:	45 31 db             	xor    r11d,r11d
  96a1f0:	eb 0f                	jmp    96a201 <tokenize_c_counted_raw_no_separators+0x3d81>
  96a1f2:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96a1f9:	c4 62 c8 f5 da       	bzhi   r11,rdx,rsi
  96a1fe:	49 f7 d3             	not    r11
  96a201:	4c 89 84 24 40 05 00 	mov    QWORD PTR [rsp+0x540],r8
  96a208:	00 
  96a209:	4c 8d 87 80 fe ff ff 	lea    r8,[rdi-0x180]
  96a210:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  96a217:	49 c7 c6 ff ff ff ff 	mov    r14,0xffffffffffffffff
  96a21e:	4d 85 c0             	test   r8,r8
  96a221:	7e 1a                	jle    96a23d <tokenize_c_counted_raw_no_separators+0x3dbd>
  96a223:	49 83 f8 3f          	cmp    r8,0x3f
  96a227:	76 05                	jbe    96a22e <tokenize_c_counted_raw_no_separators+0x3dae>
  96a229:	45 31 f6             	xor    r14d,r14d
  96a22c:	eb 0f                	jmp    96a23d <tokenize_c_counted_raw_no_separators+0x3dbd>
  96a22e:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96a235:	c4 62 b8 f5 f2       	bzhi   r14,rdx,r8
  96a23a:	49 f7 d6             	not    r14
  96a23d:	48 81 c7 40 fe ff ff 	add    rdi,0xfffffffffffffe40
  96a244:	48 85 ff             	test   rdi,rdi
  96a247:	7e 19                	jle    96a262 <tokenize_c_counted_raw_no_separators+0x3de2>
  96a249:	48 83 ff 3f          	cmp    rdi,0x3f
  96a24d:	76 04                	jbe    96a253 <tokenize_c_counted_raw_no_separators+0x3dd3>
  96a24f:	31 f6                	xor    esi,esi
  96a251:	eb 0f                	jmp    96a262 <tokenize_c_counted_raw_no_separators+0x3de2>
  96a253:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96a25a:	c4 e2 c0 f5 f2       	bzhi   rsi,rdx,rdi
  96a25f:	48 f7 d6             	not    rsi
  96a262:	48 8b bc 24 70 04 00 	mov    rdi,QWORD PTR [rsp+0x470]
  96a269:	00 
  96a26a:	48 2b 7c 24 38       	sub    rdi,QWORD PTR [rsp+0x38]
  96a26f:	48 85 ff             	test   rdi,rdi
  96a272:	7e 1b                	jle    96a28f <tokenize_c_counted_raw_no_separators+0x3e0f>
  96a274:	49 c7 c0 ff ff ff ff 	mov    r8,0xffffffffffffffff
  96a27b:	48 83 ff 3f          	cmp    rdi,0x3f
  96a27f:	77 11                	ja     96a292 <tokenize_c_counted_raw_no_separators+0x3e12>
  96a281:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  96a288:	c4 62 c0 f5 c2       	bzhi   r8,rdx,rdi
  96a28d:	eb 03                	jmp    96a292 <tokenize_c_counted_raw_no_separators+0x3e12>
  96a28f:	45 31 c0             	xor    r8d,r8d
  96a292:	c5 fa 7e 84 24 80 01 	vmovq  xmm0,QWORD PTR [rsp+0x180]
  96a299:	00 00 
  96a29b:	b2 04                	mov    dl,0x4
  96a29d:	48 8b 7c 24 38       	mov    rdi,QWORD PTR [rsp+0x38]
  96a2a2:	c5 fb 92 ca          	kmovd  k1,edx
  96a2a6:	48 8b 94 24 40 05 00 	mov    rdx,QWORD PTR [rsp+0x540]
  96a2ad:	00 
  96a2ae:	c4 e3 f9 22 94 24 00 	vpinsrq xmm2,xmm0,QWORD PTR [rsp+0x500],0x1
  96a2b5:	05 00 00 01 
  96a2b9:	62 f3 7d 48 38 c2 00 	vinserti32x4 zmm0,zmm0,xmm2,0x0
  96a2c0:	62 f2 fd 49 7c c2    	vpbroadcastq zmm0{k1},rdx
  96a2c6:	b2 08                	mov    dl,0x8
  96a2c8:	c5 fb 92 ca          	kmovd  k1,edx
  96a2cc:	b2 10                	mov    dl,0x10
  96a2ce:	62 d2 fd 49 7c c1    	vpbroadcastq zmm0{k1},r9
  96a2d4:	c5 fb 92 ca          	kmovd  k1,edx
  96a2d8:	48 8b 54 24 78       	mov    rdx,QWORD PTR [rsp+0x78]
  96a2dd:	62 f2 fd 49 7c c1    	vpbroadcastq zmm0{k1},rcx
  96a2e3:	b1 20                	mov    cl,0x20
  96a2e5:	c5 fb 92 c9          	kmovd  k1,ecx
  96a2e9:	b1 40                	mov    cl,0x40
  96a2eb:	62 d2 fd 49 7c c3    	vpbroadcastq zmm0{k1},r11
  96a2f1:	c5 fb 92 c9          	kmovd  k1,ecx
  96a2f5:	b1 80                	mov    cl,0x80
  96a2f7:	4d 89 c3             	mov    r11,r8
  96a2fa:	62 d2 fd 49 7c c6    	vpbroadcastq zmm0{k1},r14
  96a300:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96a305:	c5 fb 92 c9          	kmovd  k1,ecx
  96a309:	62 f2 fd 49 7c c6    	vpbroadcastq zmm0{k1},rsi
  96a30f:	62 91 fd 48 df d6    	vpandnq zmm2,zmm0,zmm30
  96a315:	e9 3f d1 ff ff       	jmp    967459 <tokenize_c_counted_raw_no_separators+0xfd9>
  96a31a:	62 f2 7d 48 5a 05 1c 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffac161c]        # 42b940 <c_testsuite_feature.marker+0x143c>
  96a321:	16 ac ff 
  96a324:	62 f1 7d 48 74 42 08 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rdx+0x200]
  96a32b:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  96a330:	44 21 f1             	and    ecx,r14d
  96a333:	0f b6 f0             	movzx  esi,al
  96a336:	b8 02 00 00 00       	mov    eax,0x2
  96a33b:	62 e3 7d 28 39 c0 01 	vextracti32x4 xmm0,ymm16,0x1
  96a342:	29 f0                	sub    eax,esi
  96a344:	c4 e3 f9 16 c6 01    	vpextrq rsi,xmm0,0x1
  96a34a:	40 f6 c6 01          	test   sil,0x1
  96a34e:	40 0f 94 c6          	sete   sil
  96a352:	40 08 ce             	or     sil,cl
  96a355:	b9 00 00 00 00       	mov    ecx,0x0
  96a35a:	40 f6 c6 01          	test   sil,0x1
  96a35e:	0f 44 c1             	cmove  eax,ecx
  96a361:	40 80 f6 01          	xor    sil,0x1
  96a365:	e9 40 d9 ff ff       	jmp    967caa <tokenize_c_counted_raw_no_separators+0x182a>
  96a36a:	4c 8b 74 24 58       	mov    r14,QWORD PTR [rsp+0x58]
  96a36f:	62 f2 7d 48 5a 35 f7 	vbroadcasti32x4 zmm6,XMMWORD PTR [rip+0xffffffffffac14f7]        # 42b870 <c_testsuite_feature.marker+0x136c>
  96a376:	14 ac ff 
  96a379:	48 89 b4 24 40 04 00 	mov    QWORD PTR [rsp+0x440],rsi
  96a380:	00 
  96a381:	4c 89 9c 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],r11
  96a388:	00 
  96a389:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x8c0],zmm1
  96a390:	23 
  96a391:	62 61 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x740],zmm24
  96a398:	1d 
  96a399:	62 e1 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x980],zmm22
  96a3a0:	26 
  96a3a1:	62 e1 fd 48 7f 64 24 	vmovdqa64 ZMMWORD PTR [rsp+0x780],zmm20
  96a3a8:	1e 
  96a3a9:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x7c0],zmm17
  96a3b0:	1f 
  96a3b1:	62 71 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x800],zmm13
  96a3b8:	20 
  96a3b9:	62 71 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x840],zmm11
  96a3c0:	21 
  96a3c1:	62 61 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x180],zmm30
  96a3c8:	06 
  96a3c9:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  96a3cd:	4c 89 94 24 50 04 00 	mov    QWORD PTR [rsp+0x450],r10
  96a3d4:	00 
  96a3d5:	62 61 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x3c0],zmm29
  96a3dc:	0f 
  96a3dd:	62 d1 4d 48 74 06    	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14]
  96a3e3:	c4 e1 fb 93 c0       	kmovq  rax,k0
  96a3e8:	62 d1 4d 48 74 46 01 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x40]
  96a3ef:	c4 e1 f9 6e e0       	vmovq  xmm4,rax
  96a3f4:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  96a3f9:	62 d1 4d 48 74 46 02 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x80]
  96a400:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  96a405:	62 d1 4d 48 74 46 03 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0xc0]
  96a40c:	c4 e1 fb 93 f0       	kmovq  rsi,k0
  96a411:	62 d1 4d 48 74 46 04 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x100]
  96a418:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  96a41d:	62 d1 4d 48 74 46 05 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x140]
  96a424:	c4 e1 f9 6e df       	vmovq  xmm3,rdi
  96a429:	c4 61 fb 93 c0       	kmovq  r8,k0
  96a42e:	62 d1 4d 48 74 46 06 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x180]
  96a435:	c4 61 fb 93 c8       	kmovq  r9,k0
  96a43a:	62 d1 4d 48 74 46 07 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x1c0]
  96a441:	c4 c1 f9 6e c9       	vmovq  xmm1,r9
  96a446:	c4 61 fb 93 d8       	kmovq  r11,k0
  96a44b:	62 d1 4d 48 74 46 08 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x200]
  96a452:	c4 c1 f9 6e c3       	vmovq  xmm0,r11
  96a457:	4c 89 9c 24 30 04 00 	mov    QWORD PTR [rsp+0x430],r11
  96a45e:	00 
  96a45f:	c5 f1 6c c0          	vpunpcklqdq xmm0,xmm1,xmm0
  96a463:	c4 c1 f9 6e c8       	vmovq  xmm1,r8
  96a468:	c5 e1 6c c9          	vpunpcklqdq xmm1,xmm3,xmm1
  96a46c:	c4 e1 f9 6e da       	vmovq  xmm3,rdx
  96a471:	c4 e3 75 38 c0 01    	vinserti128 ymm0,ymm1,xmm0,0x1
  96a477:	c4 e1 f9 6e ce       	vmovq  xmm1,rsi
  96a47c:	c5 e1 6c c9          	vpunpcklqdq xmm1,xmm3,xmm1
  96a480:	c4 e1 f9 6e d9       	vmovq  xmm3,rcx
  96a485:	c5 d9 6c db          	vpunpcklqdq xmm3,xmm4,xmm3
  96a489:	c4 e3 65 38 c9 01    	vinserti128 ymm1,ymm3,xmm1,0x1
  96a48f:	62 91 fd 48 6f dd    	vmovdqa64 zmm3,zmm29
  96a495:	62 f2 9d 40 7e 5c 24 	vpermt2q zmm3,zmm28,ZMMWORD PTR [rsp+0x5c0]
  96a49c:	17 
  96a49d:	62 f3 f5 48 3a c8 01 	vinserti64x4 zmm1,zmm1,ymm0,0x1
  96a4a4:	c4 e1 fb 93 c0       	kmovq  rax,k0
  96a4a9:	62 f1 f5 48 df c2    	vpandnq zmm0,zmm1,zmm2
  96a4af:	c4 e1 f9 6e d0       	vmovq  xmm2,rax
  96a4b4:	62 f3 ed 48 03 d1 01 	valignq zmm2,zmm2,zmm1,0x1
  96a4bb:	62 f3 ed 48 71 d1 3f 	vpshldq zmm2,zmm2,zmm1,0x3f
  96a4c2:	62 f3 95 40 71 db 01 	vpshldq zmm3,zmm29,zmm3,0x1
  96a4c9:	62 f1 e5 48 db d2    	vpandq zmm2,zmm3,zmm2
  96a4cf:	62 f1 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x880],zmm3
  96a4d6:	22 
  96a4d7:	62 f2 6d 48 27 c0    	vptestmd k0,zmm2,zmm0
  96a4dd:	c5 f8 98 c0          	kortestw k0,k0
  96a4e1:	0f 85 9d 0c 00 00    	jne    96b184 <tokenize_c_counted_raw_no_separators+0x4d04>
  96a4e7:	62 f1 fd 48 6f 64 24 	vmovdqa64 zmm4,ZMMWORD PTR [rsp+0x880]
  96a4ee:	22 
  96a4ef:	62 f1 fd 48 6f 1d 87 	vmovdqa64 zmm3,ZMMWORD PTR [rip+0xffffffffffaa1c87]        # 40c180 <__abi_tag+0xb5c4>
  96a4f6:	1c aa ff 
  96a4f9:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x0
  96a500:	00 00 00 00 00 
  96a505:	62 f1 f5 48 db cc    	vpandq zmm1,zmm1,zmm4
  96a50b:	62 f1 fd 48 6f d1    	vmovdqa64 zmm2,zmm1
  96a511:	62 f2 e5 48 7e 54 24 	vpermt2q zmm2,zmm3,ZMMWORD PTR [rsp+0x5c0]
  96a518:	17 
  96a519:	62 f3 f5 48 71 ca 01 	vpshldq zmm1,zmm1,zmm2,0x1
  96a520:	62 f1 f5 48 db c0    	vpandq zmm0,zmm1,zmm0
  96a526:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x8c0]
  96a52d:	23 
  96a52e:	62 f3 dd 48 25 44 24 	vpternlogq zmm0,zmm4,ZMMWORD PTR [rsp+0x3c0],0xfe
  96a535:	0f fe 
  96a537:	62 f3 f5 48 03 d5 07 	valignq zmm2,zmm1,zmm5,0x7
  96a53e:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x940],zmm0
  96a545:	25 
  96a546:	62 f3 f5 48 71 c2 01 	vpshldq zmm0,zmm1,zmm2,0x1
  96a54d:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x9c0],zmm0
  96a554:	27 
  96a555:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  96a559:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x140],zmm0
  96a560:	05 
  96a561:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x280],zmm0
  96a568:	0a 
  96a569:	eb 1d                	jmp    96a588 <tokenize_c_counted_raw_no_separators+0x4108>
  96a56b:	48 8b 8c 24 80 00 00 	mov    rcx,QWORD PTR [rsp+0x80]
  96a572:	00 
  96a573:	48 ff c1             	inc    rcx
  96a576:	48 89 8c 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rcx
  96a57d:	00 
  96a57e:	48 83 f9 08          	cmp    rcx,0x8
  96a582:	0f 84 70 0a 00 00    	je     96aff8 <tokenize_c_counted_raw_no_separators+0x4b78>
  96a588:	62 f1 7c 48 28 44 24 	vmovaps zmm0,ZMMWORD PTR [rsp+0x3c0]
  96a58f:	0f 
  96a590:	48 8b 84 24 80 00 00 	mov    rax,QWORD PTR [rsp+0x80]
  96a597:	00 
  96a598:	8d 04 c5 00 00 00 00 	lea    eax,[rax*8+0x0]
  96a59f:	83 e0 38             	and    eax,0x38
  96a5a2:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0xbc0],zmm0
  96a5a9:	2f 
  96a5aa:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x9c0]
  96a5b1:	27 
  96a5b2:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0xc00],zmm0
  96a5b9:	30 
  96a5ba:	48 8b 8c 04 00 0c 00 	mov    rcx,QWORD PTR [rsp+rax*1+0xc00]
  96a5c1:	00 
  96a5c2:	c4 62 f0 f2 94 04 c0 	andn   r10,rcx,QWORD PTR [rsp+rax*1+0xbc0]
  96a5c9:	0b 00 00 
  96a5cc:	74 9d                	je     96a56b <tokenize_c_counted_raw_no_separators+0x40eb>
  96a5ce:	4c 8b 84 24 80 00 00 	mov    r8,QWORD PTR [rsp+0x80]
  96a5d5:	00 
  96a5d6:	48 8b 44 24 48       	mov    rax,QWORD PTR [rsp+0x48]
  96a5db:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
  96a5e0:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96a5e5:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96a5ea:	49 c1 e0 06          	shl    r8,0x6
  96a5ee:	48 01 c8             	add    rax,rcx
  96a5f1:	49 01 c0             	add    r8,rax
  96a5f4:	4c 89 84 24 00 06 00 	mov    QWORD PTR [rsp+0x600],r8
  96a5fb:	00 
  96a5fc:	eb 5b                	jmp    96a659 <tokenize_c_counted_raw_no_separators+0x41d9>
  96a5fe:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  96a605:	0a 
  96a606:	62 f2 fd 48 7c c1    	vpbroadcastq zmm0,rcx
  96a60c:	62 f2 fd 48 29 0d aa 	vpcmpeqq k1,zmm0,ZMMWORD PTR [rip+0xffffffffffaa1baa]        # 40c1c0 <__abi_tag+0xb604>
  96a613:	1b aa ff 
  96a616:	31 c0                	xor    eax,eax
  96a618:	c4 c2 f8 f3 da       	blsi   rax,r10
  96a61d:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0xb40],zmm1
  96a624:	2d 
  96a625:	48 8b 94 24 80 00 00 	mov    rdx,QWORD PTR [rsp+0x80]
  96a62c:	00 
  96a62d:	83 e2 07             	and    edx,0x7
  96a630:	48 0b 84 d4 40 0b 00 	or     rax,QWORD PTR [rsp+rdx*8+0xb40]
  96a637:	00 
  96a638:	62 f2 fd 49 7c c8    	vpbroadcastq zmm1{k1},rax
  96a63e:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x280],zmm1
  96a645:	0a 
  96a646:	4c 8b 84 24 00 06 00 	mov    r8,QWORD PTR [rsp+0x600]
  96a64d:	00 
  96a64e:	c4 c2 a8 f3 ca       	blsr   r10,r10
  96a653:	0f 84 12 ff ff ff    	je     96a56b <tokenize_c_counted_raw_no_separators+0x40eb>
  96a659:	31 c9                	xor    ecx,ecx
  96a65b:	f3 49 0f bc ca       	tzcnt  rcx,r10
  96a660:	41 b3 0a             	mov    r11b,0xa
  96a663:	49 8d 44 08 ff       	lea    rax,[r8+rcx*1-0x1]
  96a668:	48 39 f0             	cmp    rax,rsi
  96a66b:	0f 9c c2             	setl   dl
  96a66e:	4c 39 f0             	cmp    rax,r14
  96a671:	40 0f 9d c7          	setge  dil
  96a675:	40 08 d7             	or     dil,dl
  96a678:	75 0a                	jne    96a684 <tokenize_c_counted_raw_no_separators+0x4204>
  96a67a:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
  96a67f:	44 0f b6 1c 02       	movzx  r11d,BYTE PTR [rdx+rax*1]
  96a684:	4c 01 c1             	add    rcx,r8
  96a687:	ba 02 00 00 00       	mov    edx,0x2
  96a68c:	48 8d 41 01          	lea    rax,[rcx+0x1]
  96a690:	48 39 f0             	cmp    rax,rsi
  96a693:	40 0f 9c c7          	setl   dil
  96a697:	4c 39 f0             	cmp    rax,r14
  96a69a:	41 0f 9d c0          	setge  r8b
  96a69e:	41 08 f8             	or     r8b,dil
  96a6a1:	75 3c                	jne    96a6df <tokenize_c_counted_raw_no_separators+0x425f>
  96a6a3:	48 8b 7c 24 50       	mov    rdi,QWORD PTR [rsp+0x50]
  96a6a8:	80 3c 07 0d          	cmp    BYTE PTR [rdi+rax*1],0xd
  96a6ac:	75 31                	jne    96a6df <tokenize_c_counted_raw_no_separators+0x425f>
  96a6ae:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96a6b5:	05 
  96a6b6:	48 8d 41 02          	lea    rax,[rcx+0x2]
  96a6ba:	48 39 f0             	cmp    rax,rsi
  96a6bd:	40 0f 9c c7          	setl   dil
  96a6c1:	4c 39 f0             	cmp    rax,r14
  96a6c4:	41 0f 9d c0          	setge  r8b
  96a6c8:	41 08 f8             	or     r8b,dil
  96a6cb:	75 0b                	jne    96a6d8 <tokenize_c_counted_raw_no_separators+0x4258>
  96a6cd:	48 8b 7c 24 50       	mov    rdi,QWORD PTR [rsp+0x50]
  96a6d2:	80 3c 07 0a          	cmp    BYTE PTR [rdi+rax*1],0xa
  96a6d6:	75 0f                	jne    96a6e7 <tokenize_c_counted_raw_no_separators+0x4267>
  96a6d8:	ba 03 00 00 00       	mov    edx,0x3
  96a6dd:	eb 08                	jmp    96a6e7 <tokenize_c_counted_raw_no_separators+0x4267>
  96a6df:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96a6e6:	05 
  96a6e7:	48 01 ca             	add    rdx,rcx
  96a6ea:	b0 0a                	mov    al,0xa
  96a6ec:	48 39 f2             	cmp    rdx,rsi
  96a6ef:	40 0f 9c c7          	setl   dil
  96a6f3:	4c 39 f2             	cmp    rdx,r14
  96a6f6:	41 0f 9d c0          	setge  r8b
  96a6fa:	41 08 f8             	or     r8b,dil
  96a6fd:	75 09                	jne    96a708 <tokenize_c_counted_raw_no_separators+0x4288>
  96a6ff:	48 8b 44 24 50       	mov    rax,QWORD PTR [rsp+0x50]
  96a704:	0f b6 04 10          	movzx  eax,BYTE PTR [rax+rdx*1]
  96a708:	41 0f b6 d3          	movzx  edx,r11b
  96a70c:	48 89 94 24 c0 05 00 	mov    QWORD PTR [rsp+0x5c0],rdx
  96a713:	00 
  96a714:	80 fa 5c             	cmp    dl,0x5c
  96a717:	0f 84 8b 01 00 00    	je     96a8a8 <tokenize_c_counted_raw_no_separators+0x4428>
  96a71d:	83 fa 27             	cmp    edx,0x27
  96a720:	0f 84 82 01 00 00    	je     96a8a8 <tokenize_c_counted_raw_no_separators+0x4428>
  96a726:	48 83 c1 fe          	add    rcx,0xfffffffffffffffe
  96a72a:	41 b0 0a             	mov    r8b,0xa
  96a72d:	48 39 f1             	cmp    rcx,rsi
  96a730:	0f 9c c2             	setl   dl
  96a733:	4c 39 f1             	cmp    rcx,r14
  96a736:	40 0f 9d c7          	setge  dil
  96a73a:	40 08 d7             	or     dil,dl
  96a73d:	75 0a                	jne    96a749 <tokenize_c_counted_raw_no_separators+0x42c9>
  96a73f:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
  96a744:	44 0f b6 04 0a       	movzx  r8d,BYTE PTR [rdx+rcx*1]
  96a749:	40 b7 01             	mov    dil,0x1
  96a74c:	41 b1 01             	mov    r9b,0x1
  96a74f:	45 84 db             	test   r11b,r11b
  96a752:	78 14                	js     96a768 <tokenize_c_counted_raw_no_separators+0x42e8>
  96a754:	48 8b 94 24 c0 05 00 	mov    rdx,QWORD PTR [rsp+0x5c0]
  96a75b:	00 
  96a75c:	48 8d 0d dd 88 aa ff 	lea    rcx,[rip+0xffffffffffaa88dd]        # 413040 <c_char_properties>
  96a763:	44 0f b6 0c 0a       	movzx  r9d,BYTE PTR [rdx+rcx*1]
  96a768:	0f b6 c8             	movzx  ecx,al
  96a76b:	48 89 4c 24 60       	mov    QWORD PTR [rsp+0x60],rcx
  96a770:	8b 8c 24 80 00 00 00 	mov    ecx,DWORD PTR [rsp+0x80]
  96a777:	84 c0                	test   al,al
  96a779:	78 1f                	js     96a79a <tokenize_c_counted_raw_no_separators+0x431a>
  96a77b:	4c 89 da             	mov    rdx,r11
  96a77e:	3c 5c                	cmp    al,0x5c
  96a780:	0f 84 6d 02 00 00    	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a786:	4c 8b 5c 24 60       	mov    r11,QWORD PTR [rsp+0x60]
  96a78b:	48 8d 3d ae 88 aa ff 	lea    rdi,[rip+0xffffffffffaa88ae]        # 413040 <c_char_properties>
  96a792:	41 0f b6 3c 3b       	movzx  edi,BYTE PTR [r11+rdi*1]
  96a797:	49 89 d3             	mov    r11,rdx
  96a79a:	4c 89 da             	mov    rdx,r11
  96a79d:	41 f6 c1 01          	test   r9b,0x1
  96a7a1:	74 75                	je     96a818 <tokenize_c_counted_raw_no_separators+0x4398>
  96a7a3:	45 8d 4b bb          	lea    r9d,[r11-0x45]
  96a7a7:	41 80 f9 2c          	cmp    r9b,0x2c
  96a7ab:	41 0f 92 c0          	setb   r8b
  96a7af:	40 f6 c7 01          	test   dil,0x1
  96a7b3:	0f 85 3a 02 00 00    	jne    96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a7b9:	3c 2e                	cmp    al,0x2e
  96a7bb:	77 19                	ja     96a7d6 <tokenize_c_counted_raw_no_separators+0x4356>
  96a7bd:	4c 8b 5c 24 60       	mov    r11,QWORD PTR [rsp+0x60]
  96a7c2:	48 bf 00 00 00 00 84 	movabs rdi,0x408400000000
  96a7c9:	40 00 00 
  96a7cc:	4c 0f a3 df          	bt     rdi,r11
  96a7d0:	0f 82 1d 02 00 00    	jb     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a7d6:	48 be 01 08 00 00 01 	movabs rsi,0x80100000801
  96a7dd:	08 00 00 
  96a7e0:	c4 e2 b3 f7 f6       	shrx   rsi,rsi,r9
  96a7e5:	41 20 f0             	and    r8b,sil
  96a7e8:	0f 84 87 02 00 00    	je     96aa75 <tokenize_c_counted_raw_no_separators+0x45f5>
  96a7ee:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96a7f5:	05 
  96a7f6:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96a7fb:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96a800:	3c 2b                	cmp    al,0x2b
  96a802:	0f 84 eb 01 00 00    	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a808:	83 7c 24 60 2d       	cmp    DWORD PTR [rsp+0x60],0x2d
  96a80d:	0f 84 e0 01 00 00    	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a813:	e9 14 02 00 00       	jmp    96aa2c <tokenize_c_counted_raw_no_separators+0x45ac>
  96a818:	41 80 fb 2b          	cmp    r11b,0x2b
  96a81c:	74 2a                	je     96a848 <tokenize_c_counted_raw_no_separators+0x43c8>
  96a81e:	83 bc 24 c0 05 00 00 	cmp    DWORD PTR [rsp+0x5c0],0x2e
  96a825:	2e 
  96a826:	0f 84 ca 00 00 00    	je     96a8f6 <tokenize_c_counted_raw_no_separators+0x4476>
  96a82c:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96a833:	05 
  96a834:	83 bc 24 c0 05 00 00 	cmp    DWORD PTR [rsp+0x5c0],0x2d
  96a83b:	2d 
  96a83c:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96a841:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96a846:	75 3b                	jne    96a883 <tokenize_c_counted_raw_no_separators+0x4403>
  96a848:	45 0f b6 c0          	movzx  r8d,r8b
  96a84c:	41 83 c0 bb          	add    r8d,0xffffffbb
  96a850:	41 83 f8 2b          	cmp    r8d,0x2b
  96a854:	77 2d                	ja     96a883 <tokenize_c_counted_raw_no_separators+0x4403>
  96a856:	49 b9 01 08 00 00 01 	movabs r9,0x80100000801
  96a85d:	08 00 00 
  96a860:	4d 0f a3 c1          	bt     r9,r8
  96a864:	73 1d                	jae    96a883 <tokenize_c_counted_raw_no_separators+0x4403>
  96a866:	40 f6 c7 01          	test   dil,0x1
  96a86a:	0f 85 83 01 00 00    	jne    96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a870:	3c 27                	cmp    al,0x27
  96a872:	0f 84 7b 01 00 00    	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a878:	83 7c 24 60 2e       	cmp    DWORD PTR [rsp+0x60],0x2e
  96a87d:	0f 84 70 01 00 00    	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a883:	4c 89 94 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],r10
  96a88a:	00 
  96a88b:	84 c0                	test   al,al
  96a88d:	0f 88 97 00 00 00    	js     96a92a <tokenize_c_counted_raw_no_separators+0x44aa>
  96a893:	48 8b 7c 24 60       	mov    rdi,QWORD PTR [rsp+0x60]
  96a898:	48 8d 35 21 88 aa ff 	lea    rsi,[rip+0xffffffffffaa8821]        # 4130c0 <c_operator_classes>
  96a89f:	0f b6 34 37          	movzx  esi,BYTE PTR [rdi+rsi*1]
  96a8a3:	e9 84 00 00 00       	jmp    96a92c <tokenize_c_counted_raw_no_separators+0x44ac>
  96a8a8:	48 8b 44 24 48       	mov    rax,QWORD PTR [rsp+0x48]
  96a8ad:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
  96a8b2:	4c 8b 45 18          	mov    r8,QWORD PTR [rbp+0x18]
  96a8b6:	4c 8b 4d 20          	mov    r9,QWORD PTR [rbp+0x20]
  96a8ba:	48 8d bc 24 80 2b 00 	lea    rdi,[rsp+0x2b80]
  96a8c1:	00 
  96a8c2:	4c 89 94 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],r10
  96a8c9:	00 
  96a8ca:	4c 89 5c 24 60       	mov    QWORD PTR [rsp+0x60],r11
  96a8cf:	48 8d 14 01          	lea    rdx,[rcx+rax*1]
  96a8d3:	48 8b 4d 10          	mov    rcx,QWORD PTR [rbp+0x10]
  96a8d7:	c5 f8 77             	vzeroupper
  96a8da:	e8 c1 21 1f 01       	call   1b5caa0 <needs_scalar>
  96a8df:	48 8b 54 24 60       	mov    rdx,QWORD PTR [rsp+0x60]
  96a8e4:	4c 8b 94 24 a0 00 00 	mov    r10,QWORD PTR [rsp+0xa0]
  96a8eb:	00 
  96a8ec:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96a8f1:	e9 5b 01 00 00       	jmp    96aa51 <tokenize_c_counted_raw_no_separators+0x45d1>
  96a8f6:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96a8fd:	05 
  96a8fe:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96a903:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96a908:	40 f6 c7 01          	test   dil,0x1
  96a90c:	0f 85 e1 00 00 00    	jne    96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a912:	3c 27                	cmp    al,0x27
  96a914:	0f 84 d9 00 00 00    	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a91a:	83 7c 24 60 2e       	cmp    DWORD PTR [rsp+0x60],0x2e
  96a91f:	0f 84 ce 00 00 00    	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a925:	e9 1c fd ff ff       	jmp    96a646 <tokenize_c_counted_raw_no_separators+0x41c6>
  96a92a:	31 f6                	xor    esi,esi
  96a92c:	48 8b bc 24 c0 05 00 	mov    rdi,QWORD PTR [rsp+0x5c0]
  96a933:	00 
  96a934:	83 e7 7f             	and    edi,0x7f
  96a937:	4c 8d 05 82 87 aa ff 	lea    r8,[rip+0xffffffffffaa8782]        # 4130c0 <c_operator_classes>
  96a93e:	41 89 f1             	mov    r9d,esi
  96a941:	41 83 e1 0f          	and    r9d,0xf
  96a945:	4c 8d 15 74 1a ac ff 	lea    r10,[rip+0xffffffffffac1a74]        # 42c3c0 <c_second_char_channels>
  96a94c:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96a953:	05 
  96a954:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96a959:	42 0f b6 3c 07       	movzx  edi,BYTE PTR [rdi+r8*1]
  96a95e:	47 0f b6 0c 11       	movzx  r9d,BYTE PTR [r9+r10*1]
  96a963:	4c 8d 15 96 1a ac ff 	lea    r10,[rip+0xffffffffffac1a96]        # 42c400 <c_first_char_channels>
  96a96a:	41 89 f8             	mov    r8d,edi
  96a96d:	41 83 e0 0f          	and    r8d,0xf
  96a971:	47 22 0c 10          	and    r9b,BYTE PTR [r8+r10*1]
  96a975:	4c 8b 94 24 a0 00 00 	mov    r10,QWORD PTR [rsp+0xa0]
  96a97c:	00 
  96a97d:	45 0f b6 c1          	movzx  r8d,r9b
  96a981:	41 80 e1 f1          	and    r9b,0xf1
  96a985:	39 fe                	cmp    esi,edi
  96a987:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96a98c:	41 0f b6 f9          	movzx  edi,r9b
  96a990:	41 0f 44 f8          	cmove  edi,r8d
  96a994:	84 d2                	test   dl,dl
  96a996:	78 05                	js     96a99d <tokenize_c_counted_raw_no_separators+0x451d>
  96a998:	40 84 ff             	test   dil,dil
  96a99b:	75 56                	jne    96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a99d:	80 fa 2f             	cmp    dl,0x2f
  96a9a0:	75 2a                	jne    96a9cc <tokenize_c_counted_raw_no_separators+0x454c>
  96a9a2:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96a9a9:	05 
  96a9aa:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96a9af:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96a9b4:	4c 8b 94 24 a0 00 00 	mov    r10,QWORD PTR [rsp+0xa0]
  96a9bb:	00 
  96a9bc:	3c 2a                	cmp    al,0x2a
  96a9be:	74 33                	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a9c0:	83 7c 24 60 2f       	cmp    DWORD PTR [rsp+0x60],0x2f
  96a9c5:	74 2c                	je     96a9f3 <tokenize_c_counted_raw_no_separators+0x4573>
  96a9c7:	e9 7a fc ff ff       	jmp    96a646 <tokenize_c_counted_raw_no_separators+0x41c6>
  96a9cc:	80 fa 3a             	cmp    dl,0x3a
  96a9cf:	0f 85 b4 00 00 00    	jne    96aa89 <tokenize_c_counted_raw_no_separators+0x4609>
  96a9d5:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96a9dc:	05 
  96a9dd:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96a9e2:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96a9e7:	4c 8b 94 24 a0 00 00 	mov    r10,QWORD PTR [rsp+0xa0]
  96a9ee:	00 
  96a9ef:	3c 25                	cmp    al,0x25
  96a9f1:	75 39                	jne    96aa2c <tokenize_c_counted_raw_no_separators+0x45ac>
  96a9f3:	62 f2 fd 48 7c c1    	vpbroadcastq zmm0,rcx
  96a9f9:	62 f2 fd 48 29 0d bd 	vpcmpeqq k1,zmm0,ZMMWORD PTR [rip+0xffffffffffaa17bd]        # 40c1c0 <__abi_tag+0xb604>
  96aa00:	17 aa ff 
  96aa03:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0xb80],zmm1
  96aa0a:	2e 
  96aa0b:	31 ff                	xor    edi,edi
  96aa0d:	c4 c2 c0 f3 da       	blsi   rdi,r10
  96aa12:	4c 8b 84 24 80 00 00 	mov    r8,QWORD PTR [rsp+0x80]
  96aa19:	00 
  96aa1a:	41 83 e0 07          	and    r8d,0x7
  96aa1e:	4a 0b bc c4 80 0b 00 	or     rdi,QWORD PTR [rsp+r8*8+0xb80]
  96aa25:	00 
  96aa26:	62 f2 fd 49 7c cf    	vpbroadcastq zmm1{k1},rdi
  96aa2c:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x140],zmm1
  96aa33:	05 
  96aa34:	80 fa 2a             	cmp    dl,0x2a
  96aa37:	75 18                	jne    96aa51 <tokenize_c_counted_raw_no_separators+0x45d1>
  96aa39:	3c 5c                	cmp    al,0x5c
  96aa3b:	0f 84 bd fb ff ff    	je     96a5fe <tokenize_c_counted_raw_no_separators+0x417e>
  96aa41:	83 7c 24 60 2f       	cmp    DWORD PTR [rsp+0x60],0x2f
  96aa46:	0f 84 b2 fb ff ff    	je     96a5fe <tokenize_c_counted_raw_no_separators+0x417e>
  96aa4c:	e9 f5 fb ff ff       	jmp    96a646 <tokenize_c_counted_raw_no_separators+0x41c6>
  96aa51:	4c 8b 84 24 00 06 00 	mov    r8,QWORD PTR [rsp+0x600]
  96aa58:	00 
  96aa59:	80 fa 27             	cmp    dl,0x27
  96aa5c:	0f 84 48 07 00 00    	je     96b1aa <tokenize_c_counted_raw_no_separators+0x4d2a>
  96aa62:	83 bc 24 c0 05 00 00 	cmp    DWORD PTR [rsp+0x5c0],0x5c
  96aa69:	5c 
  96aa6a:	0f 85 de fb ff ff    	jne    96a64e <tokenize_c_counted_raw_no_separators+0x41ce>
  96aa70:	e9 35 07 00 00       	jmp    96b1aa <tokenize_c_counted_raw_no_separators+0x4d2a>
  96aa75:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96aa7c:	05 
  96aa7d:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96aa82:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96aa87:	eb a3                	jmp    96aa2c <tokenize_c_counted_raw_no_separators+0x45ac>
  96aa89:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x140]
  96aa90:	05 
  96aa91:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96aa96:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96aa9b:	4c 8b 94 24 a0 00 00 	mov    r10,QWORD PTR [rsp+0xa0]
  96aaa2:	00 
  96aaa3:	eb 87                	jmp    96aa2c <tokenize_c_counted_raw_no_separators+0x45ac>
  96aaa5:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96aaaa:	c4 e1 f9 7e ca       	vmovq  rdx,xmm1
  96aaaf:	62 81 fd 48 6f f8    	vmovdqa64 zmm23,zmm24
  96aab5:	62 a1 fd 48 6f ee    	vmovdqa64 zmm21,zmm22
  96aabb:	62 a1 fd 48 6f dc    	vmovdqa64 zmm19,zmm20
  96aac1:	62 a1 fd 48 6f d1    	vmovdqa64 zmm18,zmm17
  96aac7:	62 51 fd 48 6f e5    	vmovdqa64 zmm12,zmm13
  96aacd:	62 51 fd 48 6f d3    	vmovdqa64 zmm10,zmm11
  96aad3:	62 51 fd 48 6f cf    	vmovdqa64 zmm9,zmm15
  96aad9:	62 d1 fd 48 6f fe    	vmovdqa64 zmm7,zmm14
  96aadf:	4c 89 9c 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],r11
  96aae6:	00 
  96aae7:	62 f1 fd 48 6f f5    	vmovdqa64 zmm6,zmm5
  96aaed:	62 91 fd 48 6f e5    	vmovdqa64 zmm4,zmm29
  96aaf3:	62 91 fd 48 6f de    	vmovdqa64 zmm3,zmm30
  96aaf9:	4c 89 d1             	mov    rcx,r10
  96aafc:	48 85 d2             	test   rdx,rdx
  96aaff:	74 69                	je     96ab6a <tokenize_c_counted_raw_no_separators+0x46ea>
  96ab01:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  96ab06:	4c 8b 44 24 40       	mov    r8,QWORD PTR [rsp+0x40]
  96ab0b:	4c 01 c7             	add    rdi,r8
  96ab0e:	48 ff c7             	inc    rdi
  96ab11:	eb 17                	jmp    96ab2a <tokenize_c_counted_raw_no_separators+0x46aa>
  96ab13:	41 b8 00 24 00 00    	mov    r8d,0x2400
  96ab19:	4d 0f a3 d0          	bt     r8,r10
  96ab1d:	0f 82 66 06 00 00    	jb     96b189 <tokenize_c_counted_raw_no_separators+0x4d09>
  96ab23:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  96ab28:	74 40                	je     96ab6a <tokenize_c_counted_raw_no_separators+0x46ea>
  96ab2a:	45 31 c0             	xor    r8d,r8d
  96ab2d:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  96ab32:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  96ab36:	4d 39 f1             	cmp    r9,r14
  96ab39:	7d e8                	jge    96ab23 <tokenize_c_counted_raw_no_separators+0x46a3>
  96ab3b:	4c 03 84 24 00 02 00 	add    r8,QWORD PTR [rsp+0x200]
  96ab42:	00 
  96ab43:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  96ab47:	49 83 fa 20          	cmp    r10,0x20
  96ab4b:	77 d6                	ja     96ab23 <tokenize_c_counted_raw_no_separators+0x46a3>
  96ab4d:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  96ab54:	00 00 00 
  96ab57:	4d 0f a3 d3          	bt     r11,r10
  96ab5b:	73 b6                	jae    96ab13 <tokenize_c_counted_raw_no_separators+0x4693>
  96ab5d:	49 ff c1             	inc    r9
  96ab60:	49 ff c0             	inc    r8
  96ab63:	4d 39 f1             	cmp    r9,r14
  96ab66:	7c db                	jl     96ab43 <tokenize_c_counted_raw_no_separators+0x46c3>
  96ab68:	eb b9                	jmp    96ab23 <tokenize_c_counted_raw_no_separators+0x46a3>
  96ab6a:	c4 e3 f9 16 ca 01    	vpextrq rdx,xmm1,0x1
  96ab70:	48 85 d2             	test   rdx,rdx
  96ab73:	74 76                	je     96abeb <tokenize_c_counted_raw_no_separators+0x476b>
  96ab75:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  96ab7a:	4c 8b 44 24 40       	mov    r8,QWORD PTR [rsp+0x40]
  96ab7f:	4c 01 c7             	add    rdi,r8
  96ab82:	48 83 c7 41          	add    rdi,0x41
  96ab86:	eb 23                	jmp    96abab <tokenize_c_counted_raw_no_separators+0x472b>
  96ab88:	41 83 f9 02          	cmp    r9d,0x2
  96ab8c:	0f 95 c0             	setne  al
  96ab8f:	e9 19 e0 ff ff       	jmp    968bad <tokenize_c_counted_raw_no_separators+0x272d>
  96ab94:	41 b8 00 24 00 00    	mov    r8d,0x2400
  96ab9a:	4d 0f a3 d0          	bt     r8,r10
  96ab9e:	0f 82 e5 05 00 00    	jb     96b189 <tokenize_c_counted_raw_no_separators+0x4d09>
  96aba4:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  96aba9:	74 40                	je     96abeb <tokenize_c_counted_raw_no_separators+0x476b>
  96abab:	45 31 c0             	xor    r8d,r8d
  96abae:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  96abb3:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  96abb7:	4d 39 f1             	cmp    r9,r14
  96abba:	7d e8                	jge    96aba4 <tokenize_c_counted_raw_no_separators+0x4724>
  96abbc:	4c 03 84 24 f8 01 00 	add    r8,QWORD PTR [rsp+0x1f8]
  96abc3:	00 
  96abc4:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  96abc8:	49 83 fa 20          	cmp    r10,0x20
  96abcc:	77 d6                	ja     96aba4 <tokenize_c_counted_raw_no_separators+0x4724>
  96abce:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  96abd5:	00 00 00 
  96abd8:	4d 0f a3 d3          	bt     r11,r10
  96abdc:	73 b6                	jae    96ab94 <tokenize_c_counted_raw_no_separators+0x4714>
  96abde:	49 ff c1             	inc    r9
  96abe1:	49 ff c0             	inc    r8
  96abe4:	4d 39 f1             	cmp    r9,r14
  96abe7:	7c db                	jl     96abc4 <tokenize_c_counted_raw_no_separators+0x4744>
  96abe9:	eb b9                	jmp    96aba4 <tokenize_c_counted_raw_no_separators+0x4724>
  96abeb:	c4 e3 7d 39 c8 01    	vextracti128 xmm0,ymm1,0x1
  96abf1:	c4 e1 f9 7e c2       	vmovq  rdx,xmm0
  96abf6:	48 85 d2             	test   rdx,rdx
  96abf9:	74 6d                	je     96ac68 <tokenize_c_counted_raw_no_separators+0x47e8>
  96abfb:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  96ac00:	4c 8b 44 24 40       	mov    r8,QWORD PTR [rsp+0x40]
  96ac05:	4c 01 c7             	add    rdi,r8
  96ac08:	48 81 c7 81 00 00 00 	add    rdi,0x81
  96ac0f:	eb 17                	jmp    96ac28 <tokenize_c_counted_raw_no_separators+0x47a8>
  96ac11:	41 b8 00 24 00 00    	mov    r8d,0x2400
  96ac17:	4d 0f a3 d0          	bt     r8,r10
  96ac1b:	0f 82 68 05 00 00    	jb     96b189 <tokenize_c_counted_raw_no_separators+0x4d09>
  96ac21:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  96ac26:	74 40                	je     96ac68 <tokenize_c_counted_raw_no_separators+0x47e8>
  96ac28:	45 31 c0             	xor    r8d,r8d
  96ac2b:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  96ac30:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  96ac34:	4d 39 f1             	cmp    r9,r14
  96ac37:	7d e8                	jge    96ac21 <tokenize_c_counted_raw_no_separators+0x47a1>
  96ac39:	4c 03 84 24 f0 01 00 	add    r8,QWORD PTR [rsp+0x1f0]
  96ac40:	00 
  96ac41:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  96ac45:	49 83 fa 20          	cmp    r10,0x20
  96ac49:	77 d6                	ja     96ac21 <tokenize_c_counted_raw_no_separators+0x47a1>
  96ac4b:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  96ac52:	00 00 00 
  96ac55:	4d 0f a3 d3          	bt     r11,r10
  96ac59:	73 b6                	jae    96ac11 <tokenize_c_counted_raw_no_separators+0x4791>
  96ac5b:	49 ff c1             	inc    r9
  96ac5e:	49 ff c0             	inc    r8
  96ac61:	4d 39 f1             	cmp    r9,r14
  96ac64:	7c db                	jl     96ac41 <tokenize_c_counted_raw_no_separators+0x47c1>
  96ac66:	eb b9                	jmp    96ac21 <tokenize_c_counted_raw_no_separators+0x47a1>
  96ac68:	c4 e3 7d 39 c8 01    	vextracti128 xmm0,ymm1,0x1
  96ac6e:	c4 e3 f9 16 c2 01    	vpextrq rdx,xmm0,0x1
  96ac74:	48 85 d2             	test   rdx,rdx
  96ac77:	74 6d                	je     96ace6 <tokenize_c_counted_raw_no_separators+0x4866>
  96ac79:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  96ac7e:	4c 8b 44 24 40       	mov    r8,QWORD PTR [rsp+0x40]
  96ac83:	4c 01 c7             	add    rdi,r8
  96ac86:	48 81 c7 c1 00 00 00 	add    rdi,0xc1
  96ac8d:	eb 17                	jmp    96aca6 <tokenize_c_counted_raw_no_separators+0x4826>
  96ac8f:	41 b8 00 24 00 00    	mov    r8d,0x2400
  96ac95:	4d 0f a3 d0          	bt     r8,r10
  96ac99:	0f 82 ea 04 00 00    	jb     96b189 <tokenize_c_counted_raw_no_separators+0x4d09>
  96ac9f:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  96aca4:	74 40                	je     96ace6 <tokenize_c_counted_raw_no_separators+0x4866>
  96aca6:	45 31 c0             	xor    r8d,r8d
  96aca9:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  96acae:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  96acb2:	4d 39 f1             	cmp    r9,r14
  96acb5:	7d e8                	jge    96ac9f <tokenize_c_counted_raw_no_separators+0x481f>
  96acb7:	4c 03 84 24 e8 01 00 	add    r8,QWORD PTR [rsp+0x1e8]
  96acbe:	00 
  96acbf:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  96acc3:	49 83 fa 20          	cmp    r10,0x20
  96acc7:	77 d6                	ja     96ac9f <tokenize_c_counted_raw_no_separators+0x481f>
  96acc9:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  96acd0:	00 00 00 
  96acd3:	4d 0f a3 d3          	bt     r11,r10
  96acd7:	73 b6                	jae    96ac8f <tokenize_c_counted_raw_no_separators+0x480f>
  96acd9:	49 ff c1             	inc    r9
  96acdc:	49 ff c0             	inc    r8
  96acdf:	4d 39 f1             	cmp    r9,r14
  96ace2:	7c db                	jl     96acbf <tokenize_c_counted_raw_no_separators+0x483f>
  96ace4:	eb b9                	jmp    96ac9f <tokenize_c_counted_raw_no_separators+0x481f>
  96ace6:	62 f3 7d 48 39 ca 02 	vextracti32x4 xmm2,zmm1,0x2
  96aced:	c4 e1 f9 7e d2       	vmovq  rdx,xmm2
  96acf2:	48 85 d2             	test   rdx,rdx
  96acf5:	74 72                	je     96ad69 <tokenize_c_counted_raw_no_separators+0x48e9>
  96acf7:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  96acfc:	4c 8b 44 24 40       	mov    r8,QWORD PTR [rsp+0x40]
  96ad01:	4c 01 c7             	add    rdi,r8
  96ad04:	48 81 c7 01 01 00 00 	add    rdi,0x101
  96ad0b:	eb 17                	jmp    96ad24 <tokenize_c_counted_raw_no_separators+0x48a4>
  96ad0d:	41 b8 00 24 00 00    	mov    r8d,0x2400
  96ad13:	4d 0f a3 d0          	bt     r8,r10
  96ad17:	0f 82 6c 04 00 00    	jb     96b189 <tokenize_c_counted_raw_no_separators+0x4d09>
  96ad1d:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  96ad22:	74 45                	je     96ad69 <tokenize_c_counted_raw_no_separators+0x48e9>
  96ad24:	4c 8b 5c 24 28       	mov    r11,QWORD PTR [rsp+0x28]
  96ad29:	45 31 c0             	xor    r8d,r8d
  96ad2c:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  96ad31:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  96ad35:	4d 39 d9             	cmp    r9,r11
  96ad38:	7d e3                	jge    96ad1d <tokenize_c_counted_raw_no_separators+0x489d>
  96ad3a:	4c 03 84 24 e0 01 00 	add    r8,QWORD PTR [rsp+0x1e0]
  96ad41:	00 
  96ad42:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  96ad46:	49 83 fa 20          	cmp    r10,0x20
  96ad4a:	77 d1                	ja     96ad1d <tokenize_c_counted_raw_no_separators+0x489d>
  96ad4c:	49 be 00 1a 00 00 01 	movabs r14,0x100001a00
  96ad53:	00 00 00 
  96ad56:	4d 0f a3 d6          	bt     r14,r10
  96ad5a:	73 b1                	jae    96ad0d <tokenize_c_counted_raw_no_separators+0x488d>
  96ad5c:	49 ff c1             	inc    r9
  96ad5f:	49 ff c0             	inc    r8
  96ad62:	4d 39 d9             	cmp    r9,r11
  96ad65:	7c db                	jl     96ad42 <tokenize_c_counted_raw_no_separators+0x48c2>
  96ad67:	eb b4                	jmp    96ad1d <tokenize_c_counted_raw_no_separators+0x489d>
  96ad69:	c4 e3 f9 16 d2 01    	vpextrq rdx,xmm2,0x1
  96ad6f:	48 85 d2             	test   rdx,rdx
  96ad72:	74 72                	je     96ade6 <tokenize_c_counted_raw_no_separators+0x4966>
  96ad74:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  96ad79:	4c 8b 44 24 40       	mov    r8,QWORD PTR [rsp+0x40]
  96ad7e:	4c 01 c7             	add    rdi,r8
  96ad81:	48 81 c7 41 01 00 00 	add    rdi,0x141
  96ad88:	eb 17                	jmp    96ada1 <tokenize_c_counted_raw_no_separators+0x4921>
  96ad8a:	41 b8 00 24 00 00    	mov    r8d,0x2400
  96ad90:	4d 0f a3 d0          	bt     r8,r10
  96ad94:	0f 82 ef 03 00 00    	jb     96b189 <tokenize_c_counted_raw_no_separators+0x4d09>
  96ad9a:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  96ad9f:	74 45                	je     96ade6 <tokenize_c_counted_raw_no_separators+0x4966>
  96ada1:	4c 8b 5c 24 28       	mov    r11,QWORD PTR [rsp+0x28]
  96ada6:	45 31 c0             	xor    r8d,r8d
  96ada9:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  96adae:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  96adb2:	4d 39 d9             	cmp    r9,r11
  96adb5:	7d e3                	jge    96ad9a <tokenize_c_counted_raw_no_separators+0x491a>
  96adb7:	4c 03 84 24 d8 01 00 	add    r8,QWORD PTR [rsp+0x1d8]
  96adbe:	00 
  96adbf:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  96adc3:	49 83 fa 20          	cmp    r10,0x20
  96adc7:	77 d1                	ja     96ad9a <tokenize_c_counted_raw_no_separators+0x491a>
  96adc9:	49 be 00 1a 00 00 01 	movabs r14,0x100001a00
  96add0:	00 00 00 
  96add3:	4d 0f a3 d6          	bt     r14,r10
  96add7:	73 b1                	jae    96ad8a <tokenize_c_counted_raw_no_separators+0x490a>
  96add9:	49 ff c1             	inc    r9
  96addc:	49 ff c0             	inc    r8
  96addf:	4d 39 d9             	cmp    r9,r11
  96ade2:	7c db                	jl     96adbf <tokenize_c_counted_raw_no_separators+0x493f>
  96ade4:	eb b4                	jmp    96ad9a <tokenize_c_counted_raw_no_separators+0x491a>
  96ade6:	62 f3 7d 48 39 c9 03 	vextracti32x4 xmm1,zmm1,0x3
  96aded:	c4 e1 f9 7e ca       	vmovq  rdx,xmm1
  96adf2:	48 85 d2             	test   rdx,rdx
  96adf5:	74 72                	je     96ae69 <tokenize_c_counted_raw_no_separators+0x49e9>
  96adf7:	48 8b 7c 24 48       	mov    rdi,QWORD PTR [rsp+0x48]
  96adfc:	4c 8b 44 24 40       	mov    r8,QWORD PTR [rsp+0x40]
  96ae01:	4c 01 c7             	add    rdi,r8
  96ae04:	48 81 c7 81 01 00 00 	add    rdi,0x181
  96ae0b:	eb 17                	jmp    96ae24 <tokenize_c_counted_raw_no_separators+0x49a4>
  96ae0d:	41 b8 00 24 00 00    	mov    r8d,0x2400
  96ae13:	4d 0f a3 d0          	bt     r8,r10
  96ae17:	0f 82 6c 03 00 00    	jb     96b189 <tokenize_c_counted_raw_no_separators+0x4d09>
  96ae1d:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  96ae22:	74 45                	je     96ae69 <tokenize_c_counted_raw_no_separators+0x49e9>
  96ae24:	4c 8b 5c 24 28       	mov    r11,QWORD PTR [rsp+0x28]
  96ae29:	45 31 c0             	xor    r8d,r8d
  96ae2c:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  96ae31:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  96ae35:	4d 39 d9             	cmp    r9,r11
  96ae38:	7d e3                	jge    96ae1d <tokenize_c_counted_raw_no_separators+0x499d>
  96ae3a:	4c 03 84 24 d0 01 00 	add    r8,QWORD PTR [rsp+0x1d0]
  96ae41:	00 
  96ae42:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  96ae46:	49 83 fa 20          	cmp    r10,0x20
  96ae4a:	77 d1                	ja     96ae1d <tokenize_c_counted_raw_no_separators+0x499d>
  96ae4c:	49 be 00 1a 00 00 01 	movabs r14,0x100001a00
  96ae53:	00 00 00 
  96ae56:	4d 0f a3 d6          	bt     r14,r10
  96ae5a:	73 b1                	jae    96ae0d <tokenize_c_counted_raw_no_separators+0x498d>
  96ae5c:	49 ff c1             	inc    r9
  96ae5f:	49 ff c0             	inc    r8
  96ae62:	4d 39 d9             	cmp    r9,r11
  96ae65:	7c db                	jl     96ae42 <tokenize_c_counted_raw_no_separators+0x49c2>
  96ae67:	eb b4                	jmp    96ae1d <tokenize_c_counted_raw_no_separators+0x499d>
  96ae69:	62 61 fd 48 6f 25 cd 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffaa12cd]        # 40c140 <__abi_tag+0xb584>
  96ae70:	12 aa ff 
  96ae73:	62 e1 fd 48 6f 44 24 	vmovdqa64 zmm16,ZMMWORD PTR [rsp+0x500]
  96ae7a:	14 
  96ae7b:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x640]
  96ae82:	19 
  96ae83:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96ae88:	48 8b 54 24 78       	mov    rdx,QWORD PTR [rsp+0x78]
  96ae8d:	4c 8b 8c 24 98 00 00 	mov    r9,QWORD PTR [rsp+0x98]
  96ae94:	00 
  96ae95:	4c 8b 9c 24 c0 00 00 	mov    r11,QWORD PTR [rsp+0xc0]
  96ae9c:	00 
  96ae9d:	c4 e3 f9 16 cf 01    	vpextrq rdi,xmm1,0x1
  96aea3:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  96aeaa:	49 89 ca             	mov    r10,rcx
  96aead:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  96aeb3:	62 61 fd 48 6f f3    	vmovdqa64 zmm30,zmm3
  96aeb9:	62 61 fd 48 6f ec    	vmovdqa64 zmm29,zmm4
  96aebf:	62 f1 fd 48 6f ee    	vmovdqa64 zmm5,zmm6
  96aec5:	62 71 fd 48 6f f7    	vmovdqa64 zmm14,zmm7
  96aecb:	62 51 fd 48 6f f9    	vmovdqa64 zmm15,zmm9
  96aed1:	62 51 fd 48 6f da    	vmovdqa64 zmm11,zmm10
  96aed7:	62 51 fd 48 6f ec    	vmovdqa64 zmm13,zmm12
  96aedd:	62 a1 fd 48 6f ca    	vmovdqa64 zmm17,zmm18
  96aee3:	62 a1 fd 48 6f e3    	vmovdqa64 zmm20,zmm19
  96aee9:	62 a1 fd 48 6f f5    	vmovdqa64 zmm22,zmm21
  96aeef:	62 21 fd 48 6f c7    	vmovdqa64 zmm24,zmm23
  96aef5:	48 85 ff             	test   rdi,rdi
  96aef8:	0f 84 da d7 ff ff    	je     9686d8 <tokenize_c_counted_raw_no_separators+0x2258>
  96aefe:	48 8b 44 24 38       	mov    rax,QWORD PTR [rsp+0x38]
  96af03:	4c 8d 80 c1 01 00 00 	lea    r8,[rax+0x1c1]
  96af0a:	e9 9b 00 00 00       	jmp    96afaa <tokenize_c_counted_raw_no_separators+0x4b2a>
  96af0f:	ba 00 24 00 00       	mov    edx,0x2400
  96af14:	4c 0f a3 d2          	bt     rdx,r10
  96af18:	0f 82 6b 02 00 00    	jb     96b189 <tokenize_c_counted_raw_no_separators+0x4d09>
  96af1e:	62 61 fd 48 6f 25 18 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffaa1218]        # 40c140 <__abi_tag+0xb584>
  96af25:	12 aa ff 
  96af28:	62 e1 fd 48 6f 44 24 	vmovdqa64 zmm16,ZMMWORD PTR [rsp+0x500]
  96af2f:	14 
  96af30:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x640]
  96af37:	19 
  96af38:	48 8b 54 24 78       	mov    rdx,QWORD PTR [rsp+0x78]
  96af3d:	4c 8b 8c 24 98 00 00 	mov    r9,QWORD PTR [rsp+0x98]
  96af44:	00 
  96af45:	4c 8b 9c 24 c0 00 00 	mov    r11,QWORD PTR [rsp+0xc0]
  96af4c:	00 
  96af4d:	c4 e2 c0 f3 cf       	blsr   rdi,rdi
  96af52:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  96af59:	49 89 ca             	mov    r10,rcx
  96af5c:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  96af62:	62 61 fd 48 6f f3    	vmovdqa64 zmm30,zmm3
  96af68:	62 61 fd 48 6f ec    	vmovdqa64 zmm29,zmm4
  96af6e:	62 f1 fd 48 6f ee    	vmovdqa64 zmm5,zmm6
  96af74:	62 71 fd 48 6f f7    	vmovdqa64 zmm14,zmm7
  96af7a:	62 51 fd 48 6f f9    	vmovdqa64 zmm15,zmm9
  96af80:	62 51 fd 48 6f da    	vmovdqa64 zmm11,zmm10
  96af86:	62 51 fd 48 6f ec    	vmovdqa64 zmm13,zmm12
  96af8c:	62 a1 fd 48 6f ca    	vmovdqa64 zmm17,zmm18
  96af92:	62 a1 fd 48 6f e3    	vmovdqa64 zmm20,zmm19
  96af98:	62 a1 fd 48 6f f5    	vmovdqa64 zmm22,zmm21
  96af9e:	62 21 fd 48 6f c7    	vmovdqa64 zmm24,zmm23
  96afa4:	0f 84 2e d7 ff ff    	je     9686d8 <tokenize_c_counted_raw_no_separators+0x2258>
  96afaa:	31 d2                	xor    edx,edx
  96afac:	f3 48 0f bc d7       	tzcnt  rdx,rdi
  96afb1:	4e 8d 0c 02          	lea    r9,[rdx+r8*1]
  96afb5:	4d 39 f1             	cmp    r9,r14
  96afb8:	0f 8d 60 ff ff ff    	jge    96af1e <tokenize_c_counted_raw_no_separators+0x4a9e>
  96afbe:	48 03 94 24 c8 01 00 	add    rdx,QWORD PTR [rsp+0x1c8]
  96afc5:	00 
  96afc6:	44 0f b6 12          	movzx  r10d,BYTE PTR [rdx]
  96afca:	49 83 fa 20          	cmp    r10,0x20
  96afce:	0f 87 4a ff ff ff    	ja     96af1e <tokenize_c_counted_raw_no_separators+0x4a9e>
  96afd4:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  96afdb:	00 00 00 
  96afde:	4d 0f a3 d3          	bt     r11,r10
  96afe2:	0f 83 27 ff ff ff    	jae    96af0f <tokenize_c_counted_raw_no_separators+0x4a8f>
  96afe8:	49 ff c1             	inc    r9
  96afeb:	48 ff c2             	inc    rdx
  96afee:	4d 39 f1             	cmp    r9,r14
  96aff1:	7c d3                	jl     96afc6 <tokenize_c_counted_raw_no_separators+0x4b46>
  96aff3:	e9 26 ff ff ff       	jmp    96af1e <tokenize_c_counted_raw_no_separators+0x4a9e>
  96aff8:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x880]
  96afff:	22 
  96b000:	62 61 fd 48 6f 6c 24 	vmovdqa64 zmm29,ZMMWORD PTR [rsp+0x3c0]
  96b007:	0f 
  96b008:	62 61 fd 48 6f 74 24 	vmovdqa64 zmm30,ZMMWORD PTR [rsp+0x180]
  96b00f:	06 
  96b010:	62 61 fd 48 6f 25 26 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffaa1126]        # 40c140 <__abi_tag+0xb584>
  96b017:	11 aa ff 
  96b01a:	62 e1 fd 48 6f 44 24 	vmovdqa64 zmm16,ZMMWORD PTR [rsp+0x500]
  96b021:	14 
  96b022:	62 f1 fd 48 6f 6c 24 	vmovdqa64 zmm5,ZMMWORD PTR [rsp+0x340]
  96b029:	0d 
  96b02a:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x640]
  96b031:	19 
  96b032:	62 71 fd 48 6f 74 24 	vmovdqa64 zmm14,ZMMWORD PTR [rsp+0x280]
  96b039:	0a 
  96b03a:	62 71 fd 48 6f 7c 24 	vmovdqa64 zmm15,ZMMWORD PTR [rsp+0x140]
  96b041:	05 
  96b042:	62 71 fd 48 6f 5c 24 	vmovdqa64 zmm11,ZMMWORD PTR [rsp+0x840]
  96b049:	21 
  96b04a:	62 71 fd 48 6f 6c 24 	vmovdqa64 zmm13,ZMMWORD PTR [rsp+0x800]
  96b051:	20 
  96b052:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x7c0]
  96b059:	1f 
  96b05a:	62 e1 fd 48 6f 64 24 	vmovdqa64 zmm20,ZMMWORD PTR [rsp+0x780]
  96b061:	1e 
  96b062:	62 e1 fd 48 6f 74 24 	vmovdqa64 zmm22,ZMMWORD PTR [rsp+0x980]
  96b069:	26 
  96b06a:	62 61 fd 48 6f 44 24 	vmovdqa64 zmm24,ZMMWORD PTR [rsp+0x740]
  96b071:	1d 
  96b072:	4c 8b 94 24 50 04 00 	mov    r10,QWORD PTR [rsp+0x450]
  96b079:	00 
  96b07a:	4c 8b 74 24 28       	mov    r14,QWORD PTR [rsp+0x28]
  96b07f:	48 8b 54 24 78       	mov    rdx,QWORD PTR [rsp+0x78]
  96b084:	4c 8b 8c 24 98 00 00 	mov    r9,QWORD PTR [rsp+0x98]
  96b08b:	00 
  96b08c:	4c 8b 9c 24 c0 00 00 	mov    r11,QWORD PTR [rsp+0xc0]
  96b093:	00 
  96b094:	48 8b b4 24 40 04 00 	mov    rsi,QWORD PTR [rsp+0x440]
  96b09b:	00 
  96b09c:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  96b0a3:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  96b0a9:	62 f3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm0,0x3
  96b0b0:	62 63 7d 48 39 e9 03 	vextracti32x4 xmm1,zmm29,0x3
  96b0b7:	c5 f1 6d c0          	vpunpckhqdq xmm0,xmm1,xmm0
  96b0bb:	c4 e2 79 59 0d bc 16 	vpbroadcastq xmm1,QWORD PTR [rip+0xffffffffffc616bc]        # 5cc780 <x86_effects_unknown+0x310>
  96b0c2:	c6 ff 
  96b0c4:	c4 e3 f1 22 8c 24 30 	vpinsrq xmm1,xmm1,QWORD PTR [rsp+0x430],0x1
  96b0cb:	04 00 00 01 
  96b0cf:	62 f3 fd 08 25 0d 66 	vpternlogq xmm1,xmm0,XMMWORD PTR [rip+0xffffffffffac0766],0x80        # 42b840 <c_testsuite_feature.marker+0x133c>
  96b0d6:	07 ac ff 80 
  96b0da:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x940]
  96b0e1:	25 
  96b0e2:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x5c0],zmm1
  96b0e9:	17 
  96b0ea:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x8c0]
  96b0f1:	23 
  96b0f2:	62 01 fd 48 df f6    	vpandnq zmm30,zmm0,zmm30
  96b0f8:	e9 a3 d5 ff ff       	jmp    9686a0 <tokenize_c_counted_raw_no_separators+0x2220>
  96b0fd:	4c 89 ac 24 50 0c 00 	mov    QWORD PTR [rsp+0xc50],r13
  96b104:	00 
  96b105:	4c 89 94 24 58 0c 00 	mov    QWORD PTR [rsp+0xc58],r10
  96b10c:	00 
  96b10d:	4c 89 bc 24 60 0c 00 	mov    QWORD PTR [rsp+0xc60],r15
  96b114:	00 
  96b115:	4c 89 7c 24 10       	mov    QWORD PTR [rsp+0x10],r15
  96b11a:	48 8d bc 24 68 0c 00 	lea    rdi,[rsp+0xc68]
  96b121:	00 
  96b122:	48 8d b4 24 00 11 00 	lea    rsi,[rsp+0x1100]
  96b129:	00 
  96b12a:	c5 fa 6f 84 24 50 0c 	vmovdqu xmm0,XMMWORD PTR [rsp+0xc50]
  96b131:	00 00 
  96b133:	c5 fa 7f 04 24       	vmovdqu XMMWORD PTR [rsp],xmm0
  96b138:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
  96b13d:	48 8b 4c 24 30       	mov    rcx,QWORD PTR [rsp+0x30]
  96b142:	4c 8b 44 24 28       	mov    r8,QWORD PTR [rsp+0x28]
  96b147:	c5 f8 77             	vzeroupper
  96b14a:	e8 e1 60 ff ff       	call   961230 <write_chunk_outlined>
  96b14f:	48 8b 84 24 68 0c 00 	mov    rax,QWORD PTR [rsp+0xc68]
  96b156:	00 
  96b157:	48 2b 84 24 b0 00 00 	sub    rax,QWORD PTR [rsp+0xb0]
  96b15e:	00 
  96b15f:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  96b166:	00 00 
  96b168:	48 3b 8c 24 40 2c 00 	cmp    rcx,QWORD PTR [rsp+0x2c40]
  96b16f:	00 
  96b170:	75 52                	jne    96b1c4 <tokenize_c_counted_raw_no_separators+0x4d44>
  96b172:	48 8d 65 d8          	lea    rsp,[rbp-0x28]
  96b176:	5b                   	pop    rbx
  96b177:	41 5c                	pop    r12
  96b179:	41 5d                	pop    r13
  96b17b:	41 5e                	pop    r14
  96b17d:	41 5f                	pop    r15
  96b17f:	5d                   	pop    rbp
  96b180:	c5 f8 77             	vzeroupper
  96b183:	c3                   	ret
  96b184:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  96b189:	48 8d bc 24 80 2b 00 	lea    rdi,[rsp+0x2b80]
  96b190:	00 
  96b191:	48 8b 54 24 38       	mov    rdx,QWORD PTR [rsp+0x38]
  96b196:	48 8b 4d 10          	mov    rcx,QWORD PTR [rbp+0x10]
  96b19a:	4c 8b 45 18          	mov    r8,QWORD PTR [rbp+0x18]
  96b19e:	4c 8b 4d 20          	mov    r9,QWORD PTR [rbp+0x20]
  96b1a2:	c5 f8 77             	vzeroupper
  96b1a5:	e8 f6 18 1f 01       	call   1b5caa0 <needs_scalar>
  96b1aa:	48 c7 c0 fe ff ff ff 	mov    rax,0xfffffffffffffffe
  96b1b1:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  96b1b8:	00 00 
  96b1ba:	48 3b 8c 24 40 2c 00 	cmp    rcx,QWORD PTR [rsp+0x2c40]
  96b1c1:	00 
  96b1c2:	74 ae                	je     96b172 <tokenize_c_counted_raw_no_separators+0x4cf2>
  96b1c4:	c5 f8 77             	vzeroupper
  96b1c7:	e8 e4 f3 e8 ff       	call   7fa5b0 <__stack_chk_fail@plt>
