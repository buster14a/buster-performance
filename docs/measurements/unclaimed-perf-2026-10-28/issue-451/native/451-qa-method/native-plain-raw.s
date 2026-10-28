
issue-451-68e113ee/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000944dd0 <tokenize_c_raw_no_separators>:
  944dd0:	55                   	push   rbp
  944dd1:	48 89 e5             	mov    rbp,rsp
  944dd4:	41 57                	push   r15
  944dd6:	41 56                	push   r14
  944dd8:	41 55                	push   r13
  944dda:	41 54                	push   r12
  944ddc:	53                   	push   rbx
  944ddd:	48 83 e4 c0          	and    rsp,0xffffffffffffffc0
  944de1:	48 81 ec c0 2c 00 00 	sub    rsp,0x2cc0
  944de8:	62 f2 7d 48 5a 05 1e 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffae5f1e]        # 42ad10 <c_testsuite_feature.marker+0x80c>
  944def:	5f ae ff 
  944df2:	62 f2 7d 48 5a 0d 24 	vbroadcasti32x4 zmm1,XMMWORD PTR [rip+0xffffffffffae5f24]        # 42ad20 <c_testsuite_feature.marker+0x81c>
  944df9:	5f ae ff 
  944dfc:	62 f2 7d 48 5a 3d 2a 	vbroadcasti32x4 zmm7,XMMWORD PTR [rip+0xffffffffffae5f2a]        # 42ad30 <c_testsuite_feature.marker+0x82c>
  944e03:	5f ae ff 
  944e06:	62 72 7d 48 5a 05 30 	vbroadcasti32x4 zmm8,XMMWORD PTR [rip+0xffffffffffae5f30]        # 42ad40 <c_testsuite_feature.marker+0x83c>
  944e0d:	5f ae ff 
  944e10:	48 89 8c 24 98 00 00 	mov    QWORD PTR [rsp+0x98],rcx
  944e17:	00 
  944e18:	48 c7 c1 ff ff ff ff 	mov    rcx,0xffffffffffffffff
  944e1f:	4d 89 c2             	mov    r10,r8
  944e22:	49 89 f3             	mov    r11,rsi
  944e25:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  944e2c:	00 00 
  944e2e:	48 89 84 24 80 2c 00 	mov    QWORD PTR [rsp+0x2c80],rax
  944e35:	00 
  944e36:	b8 40 00 00 00       	mov    eax,0x40
  944e3b:	48 89 74 24 28       	mov    QWORD PTR [rsp+0x28],rsi
  944e40:	48 89 54 24 30       	mov    QWORD PTR [rsp+0x30],rdx
  944e45:	4c 39 da             	cmp    rdx,r11
  944e48:	0f 83 ad 01 00 00    	jae    944ffb <tokenize_c_raw_no_separators+0x22b>
  944e4e:	48 8b 54 24 30       	mov    rdx,QWORD PTR [rsp+0x30]
  944e53:	eb 13                	jmp    944e68 <tokenize_c_raw_no_separators+0x98>
  944e55:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  944e5c:	00 00 00 00 
  944e60:	48 ff c2             	inc    rdx
  944e63:	49 39 d3             	cmp    r11,rdx
  944e66:	74 28                	je     944e90 <tokenize_c_raw_no_separators+0xc0>
  944e68:	0f b6 34 17          	movzx  esi,BYTE PTR [rdi+rdx*1]
  944e6c:	44 8d 46 f7          	lea    r8d,[rsi-0x9]
  944e70:	41 83 f8 05          	cmp    r8d,0x5
  944e74:	72 ea                	jb     944e60 <tokenize_c_raw_no_separators+0x90>
  944e76:	83 fe 20             	cmp    esi,0x20
  944e79:	74 e5                	je     944e60 <tokenize_c_raw_no_separators+0x90>
  944e7b:	85 f6                	test   esi,esi
  944e7d:	74 e1                	je     944e60 <tokenize_c_raw_no_separators+0x90>
  944e7f:	eb 12                	jmp    944e93 <tokenize_c_raw_no_separators+0xc3>
  944e81:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  944e88:	0f 1f 84 00 00 00 00 
  944e8f:	00 
  944e90:	4c 89 da             	mov    rdx,r11
  944e93:	48 8d 72 01          	lea    rsi,[rdx+0x1]
  944e97:	4c 39 de             	cmp    rsi,r11
  944e9a:	0f 83 5b 01 00 00    	jae    944ffb <tokenize_c_raw_no_separators+0x22b>
  944ea0:	80 3c 17 2f          	cmp    BYTE PTR [rdi+rdx*1],0x2f
  944ea4:	0f 85 51 01 00 00    	jne    944ffb <tokenize_c_raw_no_separators+0x22b>
  944eaa:	0f b6 34 37          	movzx  esi,BYTE PTR [rdi+rsi*1]
  944eae:	83 fe 2f             	cmp    esi,0x2f
  944eb1:	74 09                	je     944ebc <tokenize_c_raw_no_separators+0xec>
  944eb3:	83 fe 2a             	cmp    esi,0x2a
  944eb6:	0f 85 3f 01 00 00    	jne    944ffb <tokenize_c_raw_no_separators+0x22b>
  944ebc:	48 83 c2 02          	add    rdx,0x2
  944ec0:	4c 39 da             	cmp    rdx,r11
  944ec3:	0f 83 32 01 00 00    	jae    944ffb <tokenize_c_raw_no_separators+0x22b>
  944ec9:	40 80 fe 2f          	cmp    sil,0x2f
  944ecd:	75 61                	jne    944f30 <tokenize_c_raw_no_separators+0x160>
  944ecf:	90                   	nop
  944ed0:	4c 89 de             	mov    rsi,r11
  944ed3:	48 29 d6             	sub    rsi,rdx
  944ed6:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  944edb:	48 83 fe 3f          	cmp    rsi,0x3f
  944edf:	77 0a                	ja     944eeb <tokenize_c_raw_no_separators+0x11b>
  944ee1:	c4 62 c8 f5 c1       	bzhi   r8,rcx,rsi
  944ee6:	c4 c1 fb 92 c8       	kmovq  k1,r8
  944eeb:	62 f1 7f c9 6f 14 17 	vmovdqu8 zmm2{k1}{z},ZMMWORD PTR [rdi+rdx*1]
  944ef2:	62 f1 6d 48 74 0d 84 	vpcmpeqb k1,zmm2,ZMMWORD PTR [rip+0xffffffffffac1b84]        # 406a80 <__abi_tag+0x5ec4>
  944ef9:	1b ac ff 
  944efc:	62 f1 6d 48 74 d1    	vpcmpeqb k2,zmm2,zmm1
  944f02:	62 f1 6d 48 74 c0    	vpcmpeqb k0,zmm2,zmm0
  944f08:	c4 e1 f4 45 ca       	korq   k1,k1,k2
  944f0d:	c4 e1 f8 98 c1       	kortestq k0,k1
  944f12:	0f 85 98 00 00 00    	jne    944fb0 <tokenize_c_raw_no_separators+0x1e0>
  944f18:	48 83 fe 40          	cmp    rsi,0x40
  944f1c:	48 0f 43 f0          	cmovae rsi,rax
  944f20:	48 01 f2             	add    rdx,rsi
  944f23:	4c 39 da             	cmp    rdx,r11
  944f26:	72 a8                	jb     944ed0 <tokenize_c_raw_no_separators+0x100>
  944f28:	e9 ce 00 00 00       	jmp    944ffb <tokenize_c_raw_no_separators+0x22b>
  944f2d:	0f 1f 00             	nop    DWORD PTR [rax]
  944f30:	31 db                	xor    ebx,ebx
  944f32:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  944f39:	1f 84 00 00 00 00 00 
  944f40:	4c 89 de             	mov    rsi,r11
  944f43:	48 29 d6             	sub    rsi,rdx
  944f46:	c4 e1 fc 46 c8       	kxnorq k1,k0,k0
  944f4b:	48 83 fe 3f          	cmp    rsi,0x3f
  944f4f:	77 0a                	ja     944f5b <tokenize_c_raw_no_separators+0x18b>
  944f51:	c4 62 c8 f5 c1       	bzhi   r8,rcx,rsi
  944f56:	c4 c1 fb 92 c8       	kmovq  k1,r8
  944f5b:	62 f1 7f c9 6f 14 17 	vmovdqu8 zmm2{k1}{z},ZMMWORD PTR [rdi+rdx*1]
  944f62:	62 f1 6d 48 74 c0    	vpcmpeqb k0,zmm2,zmm0
  944f68:	c4 61 fb 93 c0       	kmovq  r8,k0
  944f6d:	62 f1 6d 48 74 c7    	vpcmpeqb k0,zmm2,zmm7
  944f73:	c4 61 fb 93 f0       	kmovq  r14,k0
  944f78:	62 d1 6d 48 74 c0    	vpcmpeqb k0,zmm2,zmm8
  944f7e:	4a 8d 1c 73          	lea    rbx,[rbx+r14*2]
  944f82:	c4 61 fb 93 d8       	kmovq  r11,k0
  944f87:	4c 21 db             	and    rbx,r11
  944f8a:	4c 09 c3             	or     rbx,r8
  944f8d:	75 51                	jne    944fe0 <tokenize_c_raw_no_separators+0x210>
  944f8f:	4c 8b 5c 24 28       	mov    r11,QWORD PTR [rsp+0x28]
  944f94:	49 c1 ee 3f          	shr    r14,0x3f
  944f98:	48 83 fe 40          	cmp    rsi,0x40
  944f9c:	48 0f 43 f0          	cmovae rsi,rax
  944fa0:	4c 89 f3             	mov    rbx,r14
  944fa3:	48 01 f2             	add    rdx,rsi
  944fa6:	4c 39 da             	cmp    rdx,r11
  944fa9:	72 95                	jb     944f40 <tokenize_c_raw_no_separators+0x170>
  944fab:	eb 4e                	jmp    944ffb <tokenize_c_raw_no_separators+0x22b>
  944fad:	0f 1f 00             	nop    DWORD PTR [rax]
  944fb0:	c4 e1 fc 45 c9       	korq   k1,k0,k1
  944fb5:	c4 61 fb 93 c0       	kmovq  r8,k0
  944fba:	c4 e1 fb 93 d9       	kmovq  rbx,k1
  944fbf:	31 f6                	xor    esi,esi
  944fc1:	f3 48 0f bc f3       	tzcnt  rsi,rbx
  944fc6:	48 8d 54 16 01       	lea    rdx,[rsi+rdx*1+0x1]
  944fcb:	49 0f a3 f0          	bt     r8,rsi
  944fcf:	0f 83 6b fe ff ff    	jae    944e40 <tokenize_c_raw_no_separators+0x70>
  944fd5:	eb 24                	jmp    944ffb <tokenize_c_raw_no_separators+0x22b>
  944fd7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  944fde:	00 00 
  944fe0:	4c 8b 5c 24 28       	mov    r11,QWORD PTR [rsp+0x28]
  944fe5:	31 f6                	xor    esi,esi
  944fe7:	f3 48 0f bc f3       	tzcnt  rsi,rbx
  944fec:	48 8d 54 16 01       	lea    rdx,[rsi+rdx*1+0x1]
  944ff1:	49 0f a3 f0          	bt     r8,rsi
  944ff5:	0f 83 45 fe ff ff    	jae    944e40 <tokenize_c_raw_no_separators+0x70>
  944ffb:	4c 8b 44 24 30       	mov    r8,QWORD PTR [rsp+0x30]
  945000:	62 71 fd 48 6f 15 36 	vmovdqa64 zmm10,ZMMWORD PTR [rip+0xffffffffffac1b36]        # 406b40 <__abi_tag+0x5f84>
  945007:	1b ac ff 
  94500a:	62 71 fd 48 6f 1d 6c 	vmovdqa64 zmm11,ZMMWORD PTR [rip+0xffffffffffac1b6c]        # 406b80 <__abi_tag+0x5fc4>
  945011:	1b ac ff 
  945014:	62 71 fd 48 6f 25 a2 	vmovdqa64 zmm12,ZMMWORD PTR [rip+0xffffffffffac1ba2]        # 406bc0 <__abi_tag+0x6004>
  94501b:	1b ac ff 
  94501e:	62 71 fd 48 6f 2d d8 	vmovdqa64 zmm13,ZMMWORD PTR [rip+0xffffffffffac1bd8]        # 406c00 <__abi_tag+0x6044>
  945025:	1b ac ff 
  945028:	62 72 7d 48 5a 35 1e 	vbroadcasti32x4 zmm14,XMMWORD PTR [rip+0xffffffffffae5d1e]        # 42ad50 <c_testsuite_feature.marker+0x84c>
  94502f:	5d ae ff 
  945032:	62 72 7d 48 5a 3d 24 	vbroadcasti32x4 zmm15,XMMWORD PTR [rip+0xffffffffffae5d24]        # 42ad60 <c_testsuite_feature.marker+0x85c>
  945039:	5d ae ff 
  94503c:	62 e2 7d 48 5a 05 2a 	vbroadcasti32x4 zmm16,XMMWORD PTR [rip+0xffffffffffae5d2a]        # 42ad70 <c_testsuite_feature.marker+0x86c>
  945043:	5d ae ff 
  945046:	62 e2 7d 48 5a 0d 30 	vbroadcasti32x4 zmm17,XMMWORD PTR [rip+0xffffffffffae5d30]        # 42ad80 <c_testsuite_feature.marker+0x87c>
  94504d:	5d ae ff 
  945050:	62 e2 7d 48 5a 15 36 	vbroadcasti32x4 zmm18,XMMWORD PTR [rip+0xffffffffffae5d36]        # 42ad90 <c_testsuite_feature.marker+0x88c>
  945057:	5d ae ff 
  94505a:	62 e2 7d 48 5a 1d 3c 	vbroadcasti32x4 zmm19,XMMWORD PTR [rip+0xffffffffffae5d3c]        # 42ada0 <c_testsuite_feature.marker+0x89c>
  945061:	5d ae ff 
  945064:	62 e1 fd 48 6f 25 52 	vmovdqa64 zmm20,ZMMWORD PTR [rip+0xffffffffffac1d52]        # 406dc0 <__abi_tag+0x6204>
  94506b:	1d ac ff 
  94506e:	62 e2 7d 48 5a 2d 38 	vbroadcasti32x4 zmm21,XMMWORD PTR [rip+0xffffffffffae5d38]        # 42adb0 <c_testsuite_feature.marker+0x8ac>
  945075:	5d ae ff 
  945078:	62 e2 7d 48 5a 35 3e 	vbroadcasti32x4 zmm22,XMMWORD PTR [rip+0xffffffffffae5d3e]        # 42adc0 <c_testsuite_feature.marker+0x8bc>
  94507f:	5d ae ff 
  945082:	62 e2 7d 48 5a 3d 44 	vbroadcasti32x4 zmm23,XMMWORD PTR [rip+0xffffffffffae5d44]        # 42add0 <c_testsuite_feature.marker+0x8cc>
  945089:	5d ae ff 
  94508c:	62 62 7d 48 5a 05 4a 	vbroadcasti32x4 zmm24,XMMWORD PTR [rip+0xffffffffffae5d4a]        # 42ade0 <c_testsuite_feature.marker+0x8dc>
  945093:	5d ae ff 
  945096:	48 89 f9             	mov    rcx,rdi
  945099:	48 83 e1 c0          	and    rcx,0xffffffffffffffc0
  94509d:	89 fa                	mov    edx,edi
  94509f:	4d 8d 3c 3b          	lea    r15,[r11+rdi*1]
  9450a3:	83 e2 3f             	and    edx,0x3f
  9450a6:	48 c7 c3 ff ff ff ff 	mov    rbx,0xffffffffffffffff
  9450ad:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  9450b1:	62 71 7c 48 28 0d 45 	vmovaps zmm9,ZMMWORD PTR [rip+0xffffffffffac1a45]        # 406b00 <__abi_tag+0x5f44>
  9450b8:	1a ac ff 
  9450bb:	62 f1 fd 48 7f 84 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2c40],zmm0
  9450c2:	40 2c 00 00 
  9450c6:	62 f1 fd 48 7f 84 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2c00],zmm0
  9450cd:	00 2c 00 00 
  9450d1:	62 f1 fd 48 7f 84 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2bc0],zmm0
  9450d8:	c0 2b 00 00 
  9450dc:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  9450e0:	48 89 c8             	mov    rax,rcx
  9450e3:	48 29 f8             	sub    rax,rdi
  9450e6:	49 29 cf             	sub    r15,rcx
  9450e9:	48 89 8c 24 e0 01 00 	mov    QWORD PTR [rsp+0x1e0],rcx
  9450f0:	00 
  9450f1:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
  9450f6:	4c 89 c6             	mov    rsi,r8
  9450f9:	48 29 c6             	sub    rsi,rax
  9450fc:	4c 01 c2             	add    rdx,r8
  9450ff:	48 83 e6 c0          	and    rsi,0xffffffffffffffc0
  945103:	48 8d 04 31          	lea    rax,[rcx+rsi*1]
  945107:	4c 89 f9             	mov    rcx,r15
  94510a:	48 29 f1             	sub    rcx,rsi
  94510d:	48 29 f2             	sub    rdx,rsi
  945110:	49 89 f6             	mov    r14,rsi
  945113:	31 f6                	xor    esi,esi
  945115:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  94511c:	00 00 00 00 
  945120:	48 85 d2             	test   rdx,rdx
  945123:	0f 8f 5a 01 00 00    	jg     945283 <tokenize_c_raw_no_separators+0x4b3>
  945129:	48 83 f9 40          	cmp    rcx,0x40
  94512d:	0f 8c 50 01 00 00    	jl     945283 <tokenize_c_raw_no_separators+0x4b3>
  945133:	62 f1 fd 48 6f 14 f0 	vmovdqa64 zmm2,ZMMWORD PTR [rax+rsi*8]
  94513a:	62 d1 fd 48 6f da    	vmovdqa64 zmm3,zmm10
  945140:	62 41 fd 48 6f cc    	vmovdqa64 zmm25,zmm12
  945146:	62 d2 6d 48 7d db    	vpermt2b zmm3,zmm2,zmm11
  94514c:	62 42 6d 48 7d cd    	vpermt2b zmm25,zmm2,zmm13
  945152:	62 f2 7e 48 29 c2    	vpmovb2m k0,zmm2
  945158:	62 f1 fd 48 7f 54 f4 	vmovdqa64 ZMMWORD PTR [rsp+rsi*8+0x1400],zmm2
  94515f:	50 
  945160:	c4 e1 f8 98 c0       	kortestq k0,k0
  945165:	0f 85 02 01 00 00    	jne    94526d <tokenize_c_raw_no_separators+0x49d>
  94516b:	62 91 fd 48 6f e1    	vmovdqa64 zmm4,zmm25
  945171:	62 f2 35 48 7d e0    	vpermt2b zmm4,zmm9,zmm0
  945177:	62 92 0d 48 00 c1    	vpshufb zmm0,zmm14,zmm25
  94517d:	62 b2 65 48 00 da    	vpshufb zmm3,zmm3,zmm18
  945183:	48 83 c1 c0          	add    rcx,0xffffffffffffffc0
  945187:	48 83 c2 c0          	add    rdx,0xffffffffffffffc0
  94518b:	62 f3 e5 40 ce db 00 	vgf2p8affineqb zmm3,zmm19,zmm3,0x0
  945192:	62 93 5d 48 3f c9 04 	vpcmpneqb k1,zmm4,zmm25
  945199:	62 f2 05 48 00 e4    	vpshufb zmm4,zmm15,zmm4
  94519f:	62 f2 5d 40 8d db    	vpermb zmm3,zmm20,zmm3
  9451a5:	62 f1 dd 48 db c0    	vpandq zmm0,zmm4,zmm0
  9451ab:	62 b1 fd 48 db e0    	vpandq zmm4,zmm0,zmm16
  9451b1:	62 62 7d 49 66 d4    	vpblendmb zmm26{k1},zmm0,zmm4
  9451b7:	62 d1 6d 48 74 c8    	vpcmpeqb k1,zmm2,zmm8
  9451bd:	62 92 75 40 00 e1    	vpshufb zmm4,zmm17,zmm25
  9451c3:	62 91 fd 48 6f ea    	vmovdqa64 zmm5,zmm26
  9451c9:	62 f2 35 48 7d e9    	vpermt2b zmm5,zmm9,zmm1
  9451cf:	c4 e1 f8 91 8c 34 c0 	kmovq  QWORD PTR [rsp+rsi*1+0x1ec0],k1
  9451d6:	1e 00 00 
  9451d9:	62 f1 6d 48 74 cf    	vpcmpeqb k1,zmm2,zmm7
  9451df:	62 f1 fd 48 7f 5c f4 	vmovdqa64 ZMMWORD PTR [rsp+rsi*8+0xcc0],zmm3
  9451e6:	33 
  9451e7:	c4 e1 f8 91 8c 34 40 	kmovq  QWORD PTR [rsp+rsi*1+0x1f40],k1
  9451ee:	1f 00 00 
  9451f1:	62 b1 6d 48 74 cd    	vpcmpeqb k1,zmm2,zmm21
  9451f7:	c4 e1 f8 91 8c 34 c0 	kmovq  QWORD PTR [rsp+rsi*1+0x1fc0],k1
  9451fe:	1f 00 00 
  945201:	62 f2 7e 48 29 c8    	vpmovb2m k1,zmm0
  945207:	c4 e1 f8 91 8c 34 40 	kmovq  QWORD PTR [rsp+rsi*1+0x2040],k1
  94520e:	20 00 00 
  945211:	62 b2 7d 48 26 ce    	vptestmb k1,zmm0,zmm22
  945217:	62 91 fd 48 6f c1    	vmovdqa64 zmm0,zmm25
  94521d:	c4 e1 f8 91 8c 34 c0 	kmovq  QWORD PTR [rsp+rsi*1+0x20c0],k1
  945224:	20 00 00 
  945227:	62 b2 2d 40 26 cf    	vptestmb k1,zmm26,zmm23
  94522d:	62 f1 dd 48 db cd    	vpandq zmm1,zmm4,zmm5
  945233:	c4 e1 f8 91 8c 34 40 	kmovq  QWORD PTR [rsp+rsi*1+0x2140],k1
  94523a:	21 00 00 
  94523d:	62 92 75 48 26 c8    	vptestmb k1,zmm1,zmm24
  945243:	62 91 fd 48 6f ca    	vmovdqa64 zmm1,zmm26
  945249:	c4 e1 f8 91 8c 34 c0 	kmovq  QWORD PTR [rsp+rsi*1+0x21c0],k1
  945250:	21 00 00 
  945253:	c4 e1 f8 91 84 34 c0 	kmovq  QWORD PTR [rsp+rsi*1+0x22c0],k0
  94525a:	22 00 00 
  94525d:	48 83 c6 08          	add    rsi,0x8
  945261:	48 83 fe 48          	cmp    rsi,0x48
  945265:	0f 85 b5 fe ff ff    	jne    945120 <tokenize_c_raw_no_separators+0x350>
  94526b:	eb 6c                	jmp    9452d9 <tokenize_c_raw_no_separators+0x509>
  94526d:	c4 e1 f8 44 c8       	knotq  k1,k0
  945272:	62 f1 7f c9 6f db    	vmovdqu8 zmm3{k1}{z},zmm3
  945278:	62 01 7f c9 6f c9    	vmovdqu8 zmm25{k1}{z},zmm25
  94527e:	e9 e8 fe ff ff       	jmp    94516b <tokenize_c_raw_no_separators+0x39b>
  945283:	45 31 c0             	xor    r8d,r8d
  945286:	48 85 c9             	test   rcx,rcx
  945289:	4c 8d 59 c0          	lea    r11,[rcx-0x40]
  94528d:	41 0f 9f c4          	setg   r12b
  945291:	49 83 fb c1          	cmp    r11,0xffffffffffffffc1
  945295:	73 08                	jae    94529f <tokenize_c_raw_no_separators+0x4cf>
  945297:	45 88 e0             	mov    r8b,r12b
  94529a:	49 f7 d8             	neg    r8
  94529d:	eb 05                	jmp    9452a4 <tokenize_c_raw_no_separators+0x4d4>
  94529f:	c4 62 f0 f5 c3       	bzhi   r8,rbx,rcx
  9452a4:	48 85 d2             	test   rdx,rdx
  9452a7:	7e 15                	jle    9452be <tokenize_c_raw_no_separators+0x4ee>
  9452a9:	48 83 fa 3f          	cmp    rdx,0x3f
  9452ad:	76 05                	jbe    9452b4 <tokenize_c_raw_no_separators+0x4e4>
  9452af:	45 31 c0             	xor    r8d,r8d
  9452b2:	eb 0a                	jmp    9452be <tokenize_c_raw_no_separators+0x4ee>
  9452b4:	c4 62 e8 f5 db       	bzhi   r11,rbx,rdx
  9452b9:	c4 42 a0 f2 c0       	andn   r8,r11,r8
  9452be:	62 f2 7d 48 5a 15 28 	vbroadcasti32x4 zmm2,XMMWORD PTR [rip+0xffffffffffae5b28]        # 42adf0 <c_testsuite_feature.marker+0x8ec>
  9452c5:	5b ae ff 
  9452c8:	c4 c1 fb 92 c8       	kmovq  k1,r8
  9452cd:	62 f2 6d 49 66 14 f0 	vpblendmb zmm2{k1},zmm2,ZMMWORD PTR [rax+rsi*8]
  9452d4:	e9 61 fe ff ff       	jmp    94513a <tokenize_c_raw_no_separators+0x36a>
  9452d9:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
  9452de:	48 8b 8c 24 e0 01 00 	mov    rcx,QWORD PTR [rsp+0x1e0]
  9452e5:	00 
  9452e6:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  9452eb:	62 61 fd 48 6f 25 8b 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffac1e8b]        # 407180 <__abi_tag+0x65c4>
  9452f2:	1e ac ff 
  9452f5:	4c 8b a4 24 98 00 00 	mov    r12,QWORD PTR [rsp+0x98]
  9452fc:	00 
  9452fd:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  945304:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  945308:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x480],zmm0
  94530f:	12 
  945310:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  945314:	4c 89 f2             	mov    rdx,r14
  945317:	48 89 7c 24 50       	mov    QWORD PTR [rsp+0x50],rdi
  94531c:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  945322:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x540],zmm0
  945329:	15 
  94532a:	48 c7 84 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],0x0
  945331:	00 00 00 00 00 
  945336:	4c 89 8c 24 e8 03 00 	mov    QWORD PTR [rsp+0x3e8],r9
  94533d:	00 
  94533e:	48 c7 84 24 00 02 00 	mov    QWORD PTR [rsp+0x200],0x0
  945345:	00 00 00 00 00 
  94534a:	48 c7 84 24 f8 01 00 	mov    QWORD PTR [rsp+0x1f8],0x0
  945351:	00 00 00 00 00 
  945356:	48 c7 84 24 e8 01 00 	mov    QWORD PTR [rsp+0x1e8],0x0
  94535d:	00 00 00 00 00 
  945362:	48 c7 84 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],0x0
  945369:	00 00 00 00 00 
  94536e:	48 c7 84 24 80 07 00 	mov    QWORD PTR [rsp+0x780],0x0
  945375:	00 00 00 00 00 
  94537a:	48 c7 44 24 60 00 00 	mov    QWORD PTR [rsp+0x60],0x0
  945381:	00 00 
  945383:	48 c7 84 24 c0 05 00 	mov    QWORD PTR [rsp+0x5c0],0x0
  94538a:	00 00 00 00 00 
  94538f:	48 c7 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],0x0
  945396:	00 00 00 00 00 
  94539b:	48 c7 84 24 80 02 00 	mov    QWORD PTR [rsp+0x280],0x0
  9453a2:	00 00 00 00 00 
  9453a7:	48 c7 84 24 40 03 00 	mov    QWORD PTR [rsp+0x340],0x0
  9453ae:	00 00 00 00 00 
  9453b3:	48 c7 84 24 40 04 00 	mov    QWORD PTR [rsp+0x440],0x0
  9453ba:	00 00 00 00 00 
  9453bf:	48 c7 84 24 80 05 00 	mov    QWORD PTR [rsp+0x580],0x0
  9453c6:	00 00 00 00 00 
  9453cb:	62 71 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0xa80],zmm9
  9453d2:	2a 
  9453d3:	48 05 00 fe ff ff    	add    rax,0xfffffffffffffe00
  9453d9:	4e 8d ac 31 40 02 00 	lea    r13,[rcx+r14*1+0x240]
  9453e0:	00 
  9453e1:	48 89 84 24 f0 03 00 	mov    QWORD PTR [rsp+0x3f0],rax
  9453e8:	00 
  9453e9:	4c 89 f0             	mov    rax,r14
  9453ec:	48 f7 d8             	neg    rax
  9453ef:	48 89 84 24 80 01 00 	mov    QWORD PTR [rsp+0x180],rax
  9453f6:	00 
  9453f7:	49 8d 87 c0 fd ff ff 	lea    rax,[r15-0x240]
  9453fe:	49 81 c7 80 fd ff ff 	add    r15,0xfffffffffffffd80
  945405:	48 89 84 24 d0 01 00 	mov    QWORD PTR [rsp+0x1d0],rax
  94540c:	00 
  94540d:	48 89 f8             	mov    rax,rdi
  945410:	48 29 c8             	sub    rax,rcx
  945413:	4c 89 bc 24 d8 01 00 	mov    QWORD PTR [rsp+0x1d8],r15
  94541a:	00 
  94541b:	4d 89 cf             	mov    r15,r9
  94541e:	48 8d 84 30 c0 fd ff 	lea    rax,[rax+rsi*1-0x240]
  945425:	ff 
  945426:	31 f6                	xor    esi,esi
  945428:	48 89 84 24 c8 01 00 	mov    QWORD PTR [rsp+0x1c8],rax
  94542f:	00 
  945430:	4a 8d 44 31 01       	lea    rax,[rcx+r14*1+0x1]
  945435:	48 89 84 24 c0 01 00 	mov    QWORD PTR [rsp+0x1c0],rax
  94543c:	00 
  94543d:	4a 8d 44 31 41       	lea    rax,[rcx+r14*1+0x41]
  945442:	48 89 84 24 b8 01 00 	mov    QWORD PTR [rsp+0x1b8],rax
  945449:	00 
  94544a:	4a 8d 84 31 81 00 00 	lea    rax,[rcx+r14*1+0x81]
  945451:	00 
  945452:	48 89 84 24 b0 01 00 	mov    QWORD PTR [rsp+0x1b0],rax
  945459:	00 
  94545a:	4a 8d 84 31 c1 00 00 	lea    rax,[rcx+r14*1+0xc1]
  945461:	00 
  945462:	48 89 84 24 a8 01 00 	mov    QWORD PTR [rsp+0x1a8],rax
  945469:	00 
  94546a:	4a 8d 84 31 01 01 00 	lea    rax,[rcx+r14*1+0x101]
  945471:	00 
  945472:	48 89 84 24 a0 01 00 	mov    QWORD PTR [rsp+0x1a0],rax
  945479:	00 
  94547a:	4a 8d 84 31 41 01 00 	lea    rax,[rcx+r14*1+0x141]
  945481:	00 
  945482:	48 89 84 24 98 01 00 	mov    QWORD PTR [rsp+0x198],rax
  945489:	00 
  94548a:	4a 8d 84 31 81 01 00 	lea    rax,[rcx+r14*1+0x181]
  945491:	00 
  945492:	48 89 84 24 90 01 00 	mov    QWORD PTR [rsp+0x190],rax
  945499:	00 
  94549a:	4a 8d 84 31 c1 01 00 	lea    rax,[rcx+r14*1+0x1c1]
  9454a1:	00 
  9454a2:	31 c9                	xor    ecx,ecx
  9454a4:	48 89 84 24 88 01 00 	mov    QWORD PTR [rsp+0x188],rax
  9454ab:	00 
  9454ac:	48 8d 84 24 00 14 00 	lea    rax,[rsp+0x1400]
  9454b3:	00 
  9454b4:	48 89 44 24 58       	mov    QWORD PTR [rsp+0x58],rax
  9454b9:	b8 01 00 00 00       	mov    eax,0x1
  9454be:	48 89 84 24 f0 01 00 	mov    QWORD PTR [rsp+0x1f0],rax
  9454c5:	00 
  9454c6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  9454cd:	00 00 00 
  9454d0:	48 69 c6 80 08 00 00 	imul   rax,rsi,0x880
  9454d7:	48 89 54 24 38       	mov    QWORD PTR [rsp+0x38],rdx
  9454dc:	48 89 b4 24 f8 03 00 	mov    QWORD PTR [rsp+0x3f8],rsi
  9454e3:	00 
  9454e4:	48 8d 9c 04 c0 1a 00 	lea    rbx,[rsp+rax*1+0x1ac0]
  9454eb:	00 
  9454ec:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  9454f1:	48 8d bc 02 00 02 00 	lea    rdi,[rdx+rax*1+0x200]
  9454f8:	00 
  9454f9:	4c 8d 0c 02          	lea    r9,[rdx+rax*1]
  9454fd:	48 8d 04 f6          	lea    rax,[rsi+rsi*8]
  945501:	48 89 7c 24 68       	mov    QWORD PTR [rsp+0x68],rdi
  945506:	48 3b 7c 24 28       	cmp    rdi,QWORD PTR [rsp+0x28]
  94550b:	0f 8d 4e 02 00 00    	jge    94575f <tokenize_c_raw_no_separators+0x98f>
  945511:	48 89 f2             	mov    rdx,rsi
  945514:	4d 89 ce             	mov    r14,r9
  945517:	49 89 c1             	mov    r9,rax
  94551a:	48 83 f2 01          	xor    rdx,0x1
  94551e:	49 c1 e1 06          	shl    r9,0x6
  945522:	62 b1 7c 48 28 44 0c 	vmovaps zmm0,ZMMWORD PTR [rsp+r9*1+0xec0]
  945529:	3b 
  94552a:	4c 8d 0c d2          	lea    r9,[rdx+rdx*8]
  94552e:	48 69 f2 80 08 00 00 	imul   rsi,rdx,0x880
  945535:	48 8b 93 40 04 00 00 	mov    rdx,QWORD PTR [rbx+0x440]
  94553c:	49 c1 e1 06          	shl    r9,0x6
  945540:	48 89 94 34 c0 1e 00 	mov    QWORD PTR [rsp+rsi*1+0x1ec0],rdx
  945547:	00 
  945548:	48 8b 93 c0 04 00 00 	mov    rdx,QWORD PTR [rbx+0x4c0]
  94554f:	62 b1 7c 48 29 44 0c 	vmovaps ZMMWORD PTR [rsp+r9*1+0xcc0],zmm0
  945556:	33 
  945557:	48 89 94 34 40 1f 00 	mov    QWORD PTR [rsp+rsi*1+0x1f40],rdx
  94555e:	00 
  94555f:	48 8b 93 40 05 00 00 	mov    rdx,QWORD PTR [rbx+0x540]
  945566:	48 89 94 34 c0 1f 00 	mov    QWORD PTR [rsp+rsi*1+0x1fc0],rdx
  94556d:	00 
  94556e:	48 8b 93 c0 05 00 00 	mov    rdx,QWORD PTR [rbx+0x5c0]
  945575:	48 89 94 34 40 20 00 	mov    QWORD PTR [rsp+rsi*1+0x2040],rdx
  94557c:	00 
  94557d:	48 8b 93 40 06 00 00 	mov    rdx,QWORD PTR [rbx+0x640]
  945584:	48 89 94 34 c0 20 00 	mov    QWORD PTR [rsp+rsi*1+0x20c0],rdx
  94558b:	00 
  94558c:	48 8b 93 c0 06 00 00 	mov    rdx,QWORD PTR [rbx+0x6c0]
  945593:	48 89 94 34 40 21 00 	mov    QWORD PTR [rsp+rsi*1+0x2140],rdx
  94559a:	00 
  94559b:	48 8b 93 40 07 00 00 	mov    rdx,QWORD PTR [rbx+0x740]
  9455a2:	48 89 94 34 c0 21 00 	mov    QWORD PTR [rsp+rsi*1+0x21c0],rdx
  9455a9:	00 
  9455aa:	48 8b 93 c0 07 00 00 	mov    rdx,QWORD PTR [rbx+0x7c0]
  9455b1:	48 89 94 34 40 22 00 	mov    QWORD PTR [rsp+rsi*1+0x2240],rdx
  9455b8:	00 
  9455b9:	48 8b 93 40 08 00 00 	mov    rdx,QWORD PTR [rbx+0x840]
  9455c0:	48 89 94 34 c0 22 00 	mov    QWORD PTR [rsp+rsi*1+0x22c0],rdx
  9455c7:	00 
  9455c8:	48 3b 7c 24 30       	cmp    rdi,QWORD PTR [rsp+0x30]
  9455cd:	0f 8c 9e 01 00 00    	jl     945771 <tokenize_c_raw_no_separators+0x9a1>
  9455d3:	49 8d 96 40 04 00 00 	lea    rdx,[r14+0x440]
  9455da:	48 3b 54 24 28       	cmp    rdx,QWORD PTR [rsp+0x28]
  9455df:	0f 8f 8c 01 00 00    	jg     945771 <tokenize_c_raw_no_separators+0x9a1>
  9455e5:	48 8b 94 24 e0 01 00 	mov    rdx,QWORD PTR [rsp+0x1e0]
  9455ec:	00 
  9455ed:	48 8b 7c 24 38       	mov    rdi,QWORD PTR [rsp+0x38]
  9455f2:	48 8d 94 3a 00 02 00 	lea    rdx,[rdx+rdi*1+0x200]
  9455f9:	00 
  9455fa:	48 89 94 24 a8 00 00 	mov    QWORD PTR [rsp+0xa8],rdx
  945601:	00 
  945602:	48 8d 94 24 00 0d 00 	lea    rdx,[rsp+0xd00]
  945609:	00 
  94560a:	49 01 d1             	add    r9,rdx
  94560d:	48 8d 94 24 c8 22 00 	lea    rdx,[rsp+0x22c8]
  945614:	00 
  945615:	48 01 d6             	add    rsi,rdx
  945618:	31 d2                	xor    edx,edx
  94561a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  945620:	62 d1 fd 48 6f 54 d5 	vmovdqa64 zmm2,ZMMWORD PTR [r13+rdx*8+0x0]
  945627:	00 
  945628:	62 d1 fd 48 6f c2    	vmovdqa64 zmm0,zmm10
  94562e:	62 d1 fd 48 6f cc    	vmovdqa64 zmm1,zmm12
  945634:	62 d2 6d 48 7d c3    	vpermt2b zmm0,zmm2,zmm11
  94563a:	62 d2 6d 48 7d cd    	vpermt2b zmm1,zmm2,zmm13
  945640:	62 f2 7e 48 29 c2    	vpmovb2m k0,zmm2
  945646:	c4 e1 f8 98 c0       	kortestq k0,k0
  94564b:	0f 85 f8 00 00 00    	jne    945749 <tokenize_c_raw_no_separators+0x979>
  945651:	62 f1 fd 48 6f d9    	vmovdqa64 zmm3,zmm1
  945657:	62 92 35 48 7d d9    	vpermt2b zmm3,zmm9,zmm25
  94565d:	62 f2 0d 48 00 e1    	vpshufb zmm4,zmm14,zmm1
  945663:	62 b2 7d 48 00 c2    	vpshufb zmm0,zmm0,zmm18
  945669:	62 f2 75 40 00 e9    	vpshufb zmm5,zmm17,zmm1
  94566f:	62 61 fd 48 6f c9    	vmovdqa64 zmm25,zmm1
  945675:	62 f3 e5 40 ce c0 00 	vgf2p8affineqb zmm0,zmm19,zmm0,0x0
  94567c:	62 f3 65 48 3f c9 04 	vpcmpneqb k1,zmm3,zmm1
  945683:	62 f2 05 48 00 db    	vpshufb zmm3,zmm15,zmm3
  945689:	62 f2 5d 40 8d c0    	vpermb zmm0,zmm20,zmm0
  94568f:	62 f1 e5 48 db e4    	vpandq zmm4,zmm3,zmm4
  945695:	62 b1 dd 48 db d8    	vpandq zmm3,zmm4,zmm16
  94569b:	62 f2 5d 49 66 db    	vpblendmb zmm3{k1},zmm4,zmm3
  9456a1:	62 d1 6d 48 74 c8    	vpcmpeqb k1,zmm2,zmm8
  9456a7:	62 f1 fd 48 6f f3    	vmovdqa64 zmm6,zmm3
  9456ad:	62 92 35 48 7d f2    	vpermt2b zmm6,zmm9,zmm26
  9456b3:	c4 e1 f8 91 8c 16 00 	kmovq  QWORD PTR [rsi+rdx*1-0x400],k1
  9456ba:	fc ff ff 
  9456bd:	62 f1 6d 48 74 cf    	vpcmpeqb k1,zmm2,zmm7
  9456c3:	62 d1 fd 48 7f 04 d1 	vmovdqa64 ZMMWORD PTR [r9+rdx*8],zmm0
  9456ca:	62 61 fd 48 6f d3    	vmovdqa64 zmm26,zmm3
  9456d0:	c4 e1 f8 91 8c 16 80 	kmovq  QWORD PTR [rsi+rdx*1-0x380],k1
  9456d7:	fc ff ff 
  9456da:	62 b1 6d 48 74 cd    	vpcmpeqb k1,zmm2,zmm21
  9456e0:	c4 e1 f8 91 8c 16 00 	kmovq  QWORD PTR [rsi+rdx*1-0x300],k1
  9456e7:	fd ff ff 
  9456ea:	62 f2 7e 48 29 cc    	vpmovb2m k1,zmm4
  9456f0:	c4 e1 f8 91 8c 16 80 	kmovq  QWORD PTR [rsi+rdx*1-0x280],k1
  9456f7:	fd ff ff 
  9456fa:	62 b2 5d 48 26 ce    	vptestmb k1,zmm4,zmm22
  945700:	c4 e1 f8 91 8c 16 00 	kmovq  QWORD PTR [rsi+rdx*1-0x200],k1
  945707:	fe ff ff 
  94570a:	62 b2 65 48 26 cf    	vptestmb k1,zmm3,zmm23
  945710:	62 f1 d5 48 db ee    	vpandq zmm5,zmm5,zmm6
  945716:	c4 e1 f8 91 8c 16 80 	kmovq  QWORD PTR [rsi+rdx*1-0x180],k1
  94571d:	fe ff ff 
  945720:	62 92 55 48 26 c8    	vptestmb k1,zmm5,zmm24
  945726:	c4 e1 f8 91 8c 16 00 	kmovq  QWORD PTR [rsi+rdx*1-0x100],k1
  94572d:	ff ff ff 
  945730:	c4 e1 f8 91 04 16    	kmovq  QWORD PTR [rsi+rdx*1],k0
  945736:	48 83 c2 08          	add    rdx,0x8
  94573a:	48 83 fa 40          	cmp    rdx,0x40
  94573e:	0f 85 dc fe ff ff    	jne    945620 <tokenize_c_raw_no_separators+0x850>
  945744:	e9 67 03 00 00       	jmp    945ab0 <tokenize_c_raw_no_separators+0xce0>
  945749:	c4 e1 f8 44 c8       	knotq  k1,k0
  94574e:	62 f1 7f c9 6f c0    	vmovdqu8 zmm0{k1}{z},zmm0
  945754:	62 f1 7f c9 6f c9    	vmovdqu8 zmm1{k1}{z},zmm1
  94575a:	e9 f2 fe ff ff       	jmp    945651 <tokenize_c_raw_no_separators+0x881>
  94575f:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  945764:	48 89 94 24 a8 00 00 	mov    QWORD PTR [rsp+0xa8],rdx
  94576b:	00 
  94576c:	e9 53 03 00 00       	jmp    945ac4 <tokenize_c_raw_no_separators+0xcf4>
  945771:	48 8b bc 24 b0 00 00 	mov    rdi,QWORD PTR [rsp+0xb0]
  945778:	00 
  945779:	48 c7 84 24 00 05 00 	mov    QWORD PTR [rsp+0x500],0x0
  945780:	00 00 00 00 00 
  945785:	48 8d 57 01          	lea    rdx,[rdi+0x1]
  945789:	48 83 ff 02          	cmp    rdi,0x2
  94578d:	bf 00 00 00 00       	mov    edi,0x0
  945792:	48 0f 44 d7          	cmove  rdx,rdi
  945796:	48 c1 e2 06          	shl    rdx,0x6
  94579a:	48 8d 3c d2          	lea    rdi,[rdx+rdx*8]
  94579e:	48 8d 94 3c 00 14 00 	lea    rdx,[rsp+rdi*1+0x1400]
  9457a5:	00 
  9457a6:	48 89 94 24 a8 00 00 	mov    QWORD PTR [rsp+0xa8],rdx
  9457ad:	00 
  9457ae:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  9457b3:	62 f1 fd 48 6f 42 08 	vmovdqa64 zmm0,ZMMWORD PTR [rdx+0x200]
  9457ba:	48 8d 94 24 40 14 00 	lea    rdx,[rsp+0x1440]
  9457c1:	00 
  9457c2:	62 f1 fd 48 7f 44 3c 	vmovdqa64 ZMMWORD PTR [rsp+rdi*1+0x1400],zmm0
  9457c9:	50 
  9457ca:	48 01 d7             	add    rdi,rdx
  9457cd:	48 8d 94 24 00 0d 00 	lea    rdx,[rsp+0xd00]
  9457d4:	00 
  9457d5:	49 01 d1             	add    r9,rdx
  9457d8:	48 8b 94 24 d8 01 00 	mov    rdx,QWORD PTR [rsp+0x1d8]
  9457df:	00 
  9457e0:	48 89 bc 24 00 03 00 	mov    QWORD PTR [rsp+0x300],rdi
  9457e7:	00 
  9457e8:	48 8d bc 24 c8 22 00 	lea    rdi,[rsp+0x22c8]
  9457ef:	00 
  9457f0:	48 01 fe             	add    rsi,rdi
  9457f3:	48 8b bc 24 c8 01 00 	mov    rdi,QWORD PTR [rsp+0x1c8]
  9457fa:	00 
  9457fb:	48 89 94 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rdx
  945802:	00 
  945803:	48 8b 94 24 d0 01 00 	mov    rdx,QWORD PTR [rsp+0x1d0]
  94580a:	00 
  94580b:	48 89 94 24 00 01 00 	mov    QWORD PTR [rsp+0x100],rdx
  945812:	00 
  945813:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  94581a:	84 00 00 00 00 00 
  945820:	48 8b 94 24 80 01 00 	mov    rdx,QWORD PTR [rsp+0x180]
  945827:	00 
  945828:	48 89 bc 24 40 02 00 	mov    QWORD PTR [rsp+0x240],rdi
  94582f:	00 
  945830:	48 01 d7             	add    rdi,rdx
  945833:	48 89 bc 24 40 06 00 	mov    QWORD PTR [rsp+0x640],rdi
  94583a:	00 
  94583b:	48 8b bc 24 00 01 00 	mov    rdi,QWORD PTR [rsp+0x100]
  945842:	00 
  945843:	48 01 fa             	add    rdx,rdi
  945846:	48 8b bc 24 40 06 00 	mov    rdi,QWORD PTR [rsp+0x640]
  94584d:	00 
  94584e:	48 85 ff             	test   rdi,rdi
  945851:	0f 8f 96 01 00 00    	jg     9459ed <tokenize_c_raw_no_separators+0xc1d>
  945857:	48 83 fa 40          	cmp    rdx,0x40
  94585b:	0f 8c 8c 01 00 00    	jl     9459ed <tokenize_c_raw_no_separators+0xc1d>
  945861:	48 8b 94 24 00 05 00 	mov    rdx,QWORD PTR [rsp+0x500]
  945868:	00 
  945869:	62 d1 fd 48 6f 54 d5 	vmovdqa64 zmm2,ZMMWORD PTR [r13+rdx*8+0x0]
  945870:	00 
  945871:	62 d1 fd 48 6f c2    	vmovdqa64 zmm0,zmm10
  945877:	62 d1 fd 48 6f cc    	vmovdqa64 zmm1,zmm12
  94587d:	48 8b bc 24 00 03 00 	mov    rdi,QWORD PTR [rsp+0x300]
  945884:	00 
  945885:	62 d2 6d 48 7d c3    	vpermt2b zmm0,zmm2,zmm11
  94588b:	62 d2 6d 48 7d cd    	vpermt2b zmm1,zmm2,zmm13
  945891:	62 f2 7e 48 29 c2    	vpmovb2m k0,zmm2
  945897:	c4 e1 f8 98 c0       	kortestq k0,k0
  94589c:	62 f1 fd 48 7f 14 d7 	vmovdqa64 ZMMWORD PTR [rdi+rdx*8],zmm2
  9458a3:	0f 85 2e 01 00 00    	jne    9459d7 <tokenize_c_raw_no_separators+0xc07>
  9458a9:	62 f1 fd 48 6f d9    	vmovdqa64 zmm3,zmm1
  9458af:	62 92 35 48 7d d9    	vpermt2b zmm3,zmm9,zmm25
  9458b5:	62 f2 0d 48 00 e1    	vpshufb zmm4,zmm14,zmm1
  9458bb:	62 b2 7d 48 00 c2    	vpshufb zmm0,zmm0,zmm18
  9458c1:	48 8b bc 24 00 01 00 	mov    rdi,QWORD PTR [rsp+0x100]
  9458c8:	00 
  9458c9:	62 f2 75 40 00 e9    	vpshufb zmm5,zmm17,zmm1
  9458cf:	48 83 84 24 c0 00 00 	add    QWORD PTR [rsp+0xc0],0xffffffffffffffc0
  9458d6:	00 c0 
  9458d8:	62 61 fd 48 6f c9    	vmovdqa64 zmm25,zmm1
  9458de:	62 f3 e5 40 ce c0 00 	vgf2p8affineqb zmm0,zmm19,zmm0,0x0
  9458e5:	62 f3 65 48 3f c9 04 	vpcmpneqb k1,zmm3,zmm1
  9458ec:	62 f2 05 48 00 db    	vpshufb zmm3,zmm15,zmm3
  9458f2:	62 f2 5d 40 8d c0    	vpermb zmm0,zmm20,zmm0
  9458f8:	48 83 c7 c0          	add    rdi,0xffffffffffffffc0
  9458fc:	48 89 bc 24 00 01 00 	mov    QWORD PTR [rsp+0x100],rdi
  945903:	00 
  945904:	48 8b bc 24 40 02 00 	mov    rdi,QWORD PTR [rsp+0x240]
  94590b:	00 
  94590c:	62 f1 e5 48 db e4    	vpandq zmm4,zmm3,zmm4
  945912:	62 b1 dd 48 db d8    	vpandq zmm3,zmm4,zmm16
  945918:	62 f2 5d 49 66 db    	vpblendmb zmm3{k1},zmm4,zmm3
  94591e:	62 d1 6d 48 74 c8    	vpcmpeqb k1,zmm2,zmm8
  945924:	62 f1 fd 48 6f f3    	vmovdqa64 zmm6,zmm3
  94592a:	62 92 35 48 7d f2    	vpermt2b zmm6,zmm9,zmm26
  945930:	c4 e1 f8 91 8c 16 00 	kmovq  QWORD PTR [rsi+rdx*1-0x400],k1
  945937:	fc ff ff 
  94593a:	62 f1 6d 48 74 cf    	vpcmpeqb k1,zmm2,zmm7
  945940:	62 d1 fd 48 7f 04 d1 	vmovdqa64 ZMMWORD PTR [r9+rdx*8],zmm0
  945947:	62 61 fd 48 6f d3    	vmovdqa64 zmm26,zmm3
  94594d:	c4 e1 f8 91 8c 16 80 	kmovq  QWORD PTR [rsi+rdx*1-0x380],k1
  945954:	fc ff ff 
  945957:	62 b1 6d 48 74 cd    	vpcmpeqb k1,zmm2,zmm21
  94595d:	48 83 c7 c0          	add    rdi,0xffffffffffffffc0
  945961:	c4 e1 f8 91 8c 16 00 	kmovq  QWORD PTR [rsi+rdx*1-0x300],k1
  945968:	fd ff ff 
  94596b:	62 f2 7e 48 29 cc    	vpmovb2m k1,zmm4
  945971:	c4 e1 f8 91 8c 16 80 	kmovq  QWORD PTR [rsi+rdx*1-0x280],k1
  945978:	fd ff ff 
  94597b:	62 b2 5d 48 26 ce    	vptestmb k1,zmm4,zmm22
  945981:	c4 e1 f8 91 8c 16 00 	kmovq  QWORD PTR [rsi+rdx*1-0x200],k1
  945988:	fe ff ff 
  94598b:	62 b2 65 48 26 cf    	vptestmb k1,zmm3,zmm23
  945991:	62 f1 d5 48 db ee    	vpandq zmm5,zmm5,zmm6
  945997:	c4 e1 f8 91 8c 16 80 	kmovq  QWORD PTR [rsi+rdx*1-0x180],k1
  94599e:	fe ff ff 
  9459a1:	62 92 55 48 26 c8    	vptestmb k1,zmm5,zmm24
  9459a7:	c4 e1 f8 91 8c 16 00 	kmovq  QWORD PTR [rsi+rdx*1-0x100],k1
  9459ae:	ff ff ff 
  9459b1:	c4 e1 f8 91 04 16    	kmovq  QWORD PTR [rsi+rdx*1],k0
  9459b7:	48 83 c2 08          	add    rdx,0x8
  9459bb:	48 89 94 24 00 05 00 	mov    QWORD PTR [rsp+0x500],rdx
  9459c2:	00 
  9459c3:	48 83 bc 24 00 05 00 	cmp    QWORD PTR [rsp+0x500],0x40
  9459ca:	00 40 
  9459cc:	0f 85 4e fe ff ff    	jne    945820 <tokenize_c_raw_no_separators+0xa50>
  9459d2:	e9 d9 00 00 00       	jmp    945ab0 <tokenize_c_raw_no_separators+0xce0>
  9459d7:	c4 e1 f8 44 c8       	knotq  k1,k0
  9459dc:	62 f1 7f c9 6f c0    	vmovdqu8 zmm0{k1}{z},zmm0
  9459e2:	62 f1 7f c9 6f c9    	vmovdqu8 zmm1{k1}{z},zmm1
  9459e8:	e9 bc fe ff ff       	jmp    9458a9 <tokenize_c_raw_no_separators+0xad9>
  9459ed:	48 85 d2             	test   rdx,rdx
  9459f0:	48 89 94 24 c0 02 00 	mov    QWORD PTR [rsp+0x2c0],rdx
  9459f7:	00 
  9459f8:	48 8b bc 24 c0 00 00 	mov    rdi,QWORD PTR [rsp+0xc0]
  9459ff:	00 
  945a00:	48 8b 94 24 80 01 00 	mov    rdx,QWORD PTR [rsp+0x180]
  945a07:	00 
  945a08:	0f 9f 84 24 00 04 00 	setg   BYTE PTR [rsp+0x400]
  945a0f:	00 
  945a10:	48 01 fa             	add    rdx,rdi
  945a13:	48 83 fa c1          	cmp    rdx,0xffffffffffffffc1
  945a17:	73 12                	jae    945a2b <tokenize_c_raw_no_separators+0xc5b>
  945a19:	0f b6 bc 24 00 04 00 	movzx  edi,BYTE PTR [rsp+0x400]
  945a20:	00 
  945a21:	31 d2                	xor    edx,edx
  945a23:	40 88 fa             	mov    dl,dil
  945a26:	48 f7 da             	neg    rdx
  945a29:	eb 14                	jmp    945a3f <tokenize_c_raw_no_separators+0xc6f>
  945a2b:	48 8b bc 24 c0 02 00 	mov    rdi,QWORD PTR [rsp+0x2c0]
  945a32:	00 
  945a33:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  945a3a:	c4 e2 c0 f5 d2       	bzhi   rdx,rdx,rdi
  945a3f:	48 8b bc 24 40 06 00 	mov    rdi,QWORD PTR [rsp+0x640]
  945a46:	00 
  945a47:	48 89 94 24 c0 02 00 	mov    QWORD PTR [rsp+0x2c0],rdx
  945a4e:	00 
  945a4f:	48 85 ff             	test   rdi,rdi
  945a52:	7e 0a                	jle    945a5e <tokenize_c_raw_no_separators+0xc8e>
  945a54:	48 83 ff 3f          	cmp    rdi,0x3f
  945a58:	76 16                	jbe    945a70 <tokenize_c_raw_no_separators+0xca0>
  945a5a:	31 ff                	xor    edi,edi
  945a5c:	eb 2b                	jmp    945a89 <tokenize_c_raw_no_separators+0xcb9>
  945a5e:	48 8b 94 24 00 05 00 	mov    rdx,QWORD PTR [rsp+0x500]
  945a65:	00 
  945a66:	48 8b bc 24 c0 02 00 	mov    rdi,QWORD PTR [rsp+0x2c0]
  945a6d:	00 
  945a6e:	eb 21                	jmp    945a91 <tokenize_c_raw_no_separators+0xcc1>
  945a70:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  945a77:	c4 e2 c0 f5 d2       	bzhi   rdx,rdx,rdi
  945a7c:	48 8b bc 24 c0 02 00 	mov    rdi,QWORD PTR [rsp+0x2c0]
  945a83:	00 
  945a84:	c4 e2 e8 f2 ff       	andn   rdi,rdx,rdi
  945a89:	48 8b 94 24 00 05 00 	mov    rdx,QWORD PTR [rsp+0x500]
  945a90:	00 
  945a91:	62 f2 7d 48 5a 05 55 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffae5355]        # 42adf0 <c_testsuite_feature.marker+0x8ec>
  945a98:	53 ae ff 
  945a9b:	c4 e1 fb 92 cf       	kmovq  k1,rdi
  945aa0:	62 d2 7d 49 66 54 d5 	vpblendmb zmm2{k1},zmm0,ZMMWORD PTR [r13+rdx*8+0x0]
  945aa7:	00 
  945aa8:	e9 c4 fd ff ff       	jmp    945871 <tokenize_c_raw_no_separators+0xaa1>
  945aad:	0f 1f 00             	nop    DWORD PTR [rax]
  945ab0:	48 8b 7c 24 68       	mov    rdi,QWORD PTR [rsp+0x68]
  945ab5:	62 61 fd 48 6f d3    	vmovdqa64 zmm26,zmm3
  945abb:	62 61 fd 48 6f c9    	vmovdqa64 zmm25,zmm1
  945ac1:	4d 89 f1             	mov    r9,r14
  945ac4:	62 f1 fd 48 6f 3d 32 	vmovdqa64 zmm7,ZMMWORD PTR [rip+0xffffffffffac1432]        # 406f00 <__abi_tag+0x6344>
  945acb:	14 ac ff 
  945ace:	62 71 fd 48 6f 05 68 	vmovdqa64 zmm8,ZMMWORD PTR [rip+0xffffffffffac1468]        # 406f40 <__abi_tag+0x6384>
  945ad5:	14 ac ff 
  945ad8:	62 71 fd 48 6f 0d 9e 	vmovdqa64 zmm9,ZMMWORD PTR [rip+0xffffffffffac149e]        # 406f80 <__abi_tag+0x63c4>
  945adf:	14 ac ff 
  945ae2:	62 71 fd 48 6f 15 d4 	vmovdqa64 zmm10,ZMMWORD PTR [rip+0xffffffffffac14d4]        # 406fc0 <__abi_tag+0x6404>
  945ae9:	14 ac ff 
  945aec:	62 72 7d 48 5a 1d 0a 	vbroadcasti32x4 zmm11,XMMWORD PTR [rip+0xffffffffffae530a]        # 42ae00 <c_testsuite_feature.marker+0x8fc>
  945af3:	53 ae ff 
  945af6:	62 71 fd 48 6f 25 c0 	vmovdqa64 zmm12,ZMMWORD PTR [rip+0xffffffffffac15c0]        # 4070c0 <__abi_tag+0x6504>
  945afd:	15 ac ff 
  945b00:	62 72 7d 48 58 2d 62 	vpbroadcastd zmm13,DWORD PTR [rip+0xffffffffffc86a62]        # 5cc56c <x86_effects_unknown+0xfc>
  945b07:	6a c8 ff 
  945b0a:	f6 c1 01             	test   cl,0x1
  945b0d:	0f 84 7d 04 00 00    	je     945f90 <tokenize_c_raw_no_separators+0x11c0>
  945b13:	48 8b 8c 24 c0 04 00 	mov    rcx,QWORD PTR [rsp+0x4c0]
  945b1a:	00 
  945b1b:	62 f2 7d 48 7c c9    	vpbroadcastd zmm1,ecx
  945b21:	31 c9                	xor    ecx,ecx
  945b23:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  945b2a:	84 00 00 00 00 00 
  945b30:	48 89 ce             	mov    rsi,rcx
  945b33:	48 c1 e6 06          	shl    rsi,0x6
  945b37:	c4 e1 f8 90 8c cc 40 	kmovq  k1,QWORD PTR [rsp+rcx*8+0x1140]
  945b3e:	11 00 00 
  945b41:	62 f1 fd 48 6f d7    	vmovdqa64 zmm2,zmm7
  945b47:	c4 e1 f8 90 94 cc 00 	kmovq  k2,QWORD PTR [rsp+rcx*8+0x1200]
  945b4e:	12 00 00 
  945b51:	48 8b 94 cc 40 12 00 	mov    rdx,QWORD PTR [rsp+rcx*8+0x1240]
  945b58:	00 
  945b59:	62 d1 fd 48 6f 04 33 	vmovdqa64 zmm0,ZMMWORD PTR [r11+rsi*1]
  945b60:	62 d1 7d 48 fc 9c 33 	vpaddb zmm3,zmm0,ZMMWORD PTR [r11+rsi*1+0x1]
  945b67:	01 00 00 00 
  945b6b:	62 d2 7d 48 7d d0    	vpermt2b zmm2,zmm0,zmm8
  945b71:	62 f1 65 48 fc db    	vpaddb zmm3,zmm3,zmm3
  945b77:	62 f1 65 48 fc db    	vpaddb zmm3,zmm3,zmm3
  945b7d:	62 f1 65 48 fc c0    	vpaddb zmm0,zmm3,zmm0
  945b83:	62 d1 fd 48 6f d9    	vmovdqa64 zmm3,zmm9
  945b89:	62 d2 7d 48 7d da    	vpermt2b zmm3,zmm0,zmm10
  945b8f:	62 f1 7f 4a 6f d3    	vmovdqu8 zmm2{k2},zmm3
  945b95:	48 85 d2             	test   rdx,rdx
  945b98:	0f 85 ea 00 00 00    	jne    945c88 <tokenize_c_raw_no_separators+0xeb8>
  945b9e:	c4 e1 f8 90 94 cc 80 	kmovq  k2,QWORD PTR [rsp+rcx*8+0x1180]
  945ba5:	11 00 00 
  945ba8:	41 0f a3 c8          	bt     r8d,ecx
  945bac:	0f 82 f9 00 00 00    	jb     945cab <tokenize_c_raw_no_separators+0xedb>
  945bb2:	c4 e1 f8 90 9c cc c0 	kmovq  k3,QWORD PTR [rsp+rcx*8+0x11c0]
  945bb9:	11 00 00 
  945bbc:	62 d1 ed 48 eb c3    	vporq  zmm0,zmm2,zmm11
  945bc2:	62 f1 7f 4b 6f d0    	vmovdqu8 zmm2{k3},zmm0
  945bc8:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  945bcc:	62 f2 7d c9 63 d0    	vpcompressb zmm0{k1}{z},zmm2
  945bd2:	62 d1 fe 48 7f 04 24 	vmovdqu64 ZMMWORD PTR [r12],zmm0
  945bd9:	c5 d9 ef e4          	vpxor  xmm4,xmm4,xmm4
  945bdd:	62 72 7d c9 63 e4    	vpcompressb zmm4{k1}{z},zmm12
  945be3:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  945be7:	62 72 7d ca 63 e3    	vpcompressb zmm3{k2}{z},zmm12
  945bed:	62 91 75 48 fa d3    	vpsubd zmm2,zmm1,zmm27
  945bf3:	48 8b 94 cc 40 13 00 	mov    rdx,QWORD PTR [rsp+rcx*8+0x1340]
  945bfa:	00 
  945bfb:	48 8b b4 cc 80 13 00 	mov    rsi,QWORD PTR [rsp+rcx*8+0x1380]
  945c02:	00 
  945c03:	62 f2 7d 48 31 c4    	vpmovzxbd zmm0,xmm4
  945c09:	62 72 7d 48 31 f3    	vpmovzxbd zmm14,xmm3
  945c0f:	c4 e3 7d 39 e5 01    	vextracti128 xmm5,ymm4,0x1
  945c15:	62 f1 75 48 fe c0    	vpaddd zmm0,zmm1,zmm0
  945c1b:	62 d1 fe 48 7f 02    	vmovdqu64 ZMMWORD PTR [r10],zmm0
  945c21:	62 d1 6d 48 fe c6    	vpaddd zmm0,zmm2,zmm14
  945c27:	62 d1 fe 48 7f 07    	vmovdqu64 ZMMWORD PTR [r15],zmm0
  945c2d:	c4 e2 7d 31 c5       	vpmovzxbd ymm0,xmm5
  945c32:	c5 f5 fe c0          	vpaddd ymm0,ymm1,ymm0
  945c36:	c4 c1 7e 7f 42 40    	vmovdqu YMMWORD PTR [r10+0x40],ymm0
  945c3c:	c4 e3 7d 39 d8 01    	vextracti128 xmm0,ymm3,0x1
  945c42:	c4 e2 7d 31 f0       	vpmovzxbd ymm6,xmm0
  945c47:	c5 ed fe f6          	vpaddd ymm6,ymm2,ymm6
  945c4b:	c4 c1 7e 7f 77 40    	vmovdqu YMMWORD PTR [r15+0x40],ymm6
  945c51:	48 83 fa 18          	cmp    rdx,0x18
  945c55:	0f 87 9d 02 00 00    	ja     945ef8 <tokenize_c_raw_no_separators+0x1128>
  945c5b:	48 83 fe 18          	cmp    rsi,0x18
  945c5f:	0f 87 93 02 00 00    	ja     945ef8 <tokenize_c_raw_no_separators+0x1128>
  945c65:	4d 8d 14 92          	lea    r10,[r10+rdx*4]
  945c69:	4d 8d 3c b7          	lea    r15,[r15+rsi*4]
  945c6d:	49 01 d4             	add    r12,rdx
  945c70:	62 d1 75 48 fe cd    	vpaddd zmm1,zmm1,zmm13
  945c76:	48 ff c1             	inc    rcx
  945c79:	48 83 f9 08          	cmp    rcx,0x8
  945c7d:	0f 85 ad fe ff ff    	jne    945b30 <tokenize_c_raw_no_separators+0xd60>
  945c83:	e9 08 03 00 00       	jmp    945f90 <tokenize_c_raw_no_separators+0x11c0>
  945c88:	c4 e1 fb 92 d2       	kmovq  k2,rdx
  945c8d:	62 f2 7d 4a 8d 15 69 	vpermb zmm2{k2},zmm0,ZMMWORD PTR [rip+0xffffffffffac1369]        # 407000 <__abi_tag+0x6444>
  945c94:	13 ac ff 
  945c97:	c4 e1 f8 90 94 cc 80 	kmovq  k2,QWORD PTR [rsp+rcx*8+0x1180]
  945c9e:	11 00 00 
  945ca1:	41 0f a3 c8          	bt     r8d,ecx
  945ca5:	0f 83 07 ff ff ff    	jae    945bb2 <tokenize_c_raw_no_separators+0xde2>
  945cab:	c4 e1 f8 90 a4 cc 80 	kmovq  k4,QWORD PTR [rsp+rcx*8+0x1280]
  945cb2:	12 00 00 
  945cb5:	c4 e1 f8 90 9c cc c0 	kmovq  k3,QWORD PTR [rsp+rcx*8+0x11c0]
  945cbc:	11 00 00 
  945cbf:	62 f1 7f 4c 6f 15 77 	vmovdqu8 zmm2{k4},ZMMWORD PTR [rip+0xffffffffffac1377]        # 407040 <__abi_tag+0x6484>
  945cc6:	13 ac ff 
  945cc9:	62 d1 ed 48 eb c3    	vporq  zmm0,zmm2,zmm11
  945ccf:	62 f1 7f 4b 6f d0    	vmovdqu8 zmm2{k3},zmm0
  945cd5:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  945cd9:	62 f2 7d c9 63 d0    	vpcompressb zmm0{k1}{z},zmm2
  945cdf:	62 d1 fe 48 7f 04 24 	vmovdqu64 ZMMWORD PTR [r12],zmm0
  945ce6:	48 8b 94 cc 00 13 00 	mov    rdx,QWORD PTR [rsp+rcx*8+0x1300]
  945ced:	00 
  945cee:	48 0b 94 cc c0 12 00 	or     rdx,QWORD PTR [rsp+rcx*8+0x12c0]
  945cf5:	00 
  945cf6:	0f 84 dd fe ff ff    	je     945bd9 <tokenize_c_raw_no_separators+0xe09>
  945cfc:	48 03 b4 24 c0 04 00 	add    rsi,QWORD PTR [rsp+0x4c0]
  945d03:	00 
  945d04:	4c 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],r9
  945d09:	4c 8b 8c cc 00 13 00 	mov    r9,QWORD PTR [rsp+rcx*8+0x1300]
  945d10:	00 
  945d11:	48 89 94 24 00 05 00 	mov    QWORD PTR [rsp+0x500],rdx
  945d18:	00 
  945d19:	f3 48 0f bc d2       	tzcnt  rdx,rdx
  945d1e:	48 89 94 24 40 06 00 	mov    QWORD PTR [rsp+0x640],rdx
  945d25:	00 
  945d26:	49 0f a3 d1          	bt     r9,rdx
  945d2a:	73 10                	jae    945d3c <tokenize_c_raw_no_separators+0xf6c>
  945d2c:	c7 84 24 00 01 00 00 	mov    DWORD PTR [rsp+0x100],0x0
  945d33:	00 00 00 00 
  945d37:	e9 69 01 00 00       	jmp    945ea5 <tokenize_c_raw_no_separators+0x10d5>
  945d3c:	4c 8d 0c 16          	lea    r9,[rsi+rdx*1]
  945d40:	4c 3b 4c 24 30       	cmp    r9,QWORD PTR [rsp+0x30]
  945d45:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
  945d4a:	4c 89 8c 24 00 01 00 	mov    QWORD PTR [rsp+0x100],r9
  945d51:	00 
  945d52:	41 0f 9d c6          	setge  r14b
  945d56:	49 39 d1             	cmp    r9,rdx
  945d59:	41 0f 9c c1          	setl   r9b
  945d5d:	45 84 ce             	test   r14b,r9b
  945d60:	0f 84 a9 00 00 00    	je     945e0f <tokenize_c_raw_no_separators+0x103f>
  945d66:	48 8b bc 24 00 01 00 	mov    rdi,QWORD PTR [rsp+0x100]
  945d6d:	00 
  945d6e:	4c 8b 4c 24 50       	mov    r9,QWORD PTR [rsp+0x50]
  945d73:	45 0f b6 34 39       	movzx  r14d,BYTE PTR [r9+rdi*1]
  945d78:	48 ff c7             	inc    rdi
  945d7b:	48 89 bc 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rdi
  945d82:	00 
  945d83:	bf 01 00 00 00       	mov    edi,0x1
  945d88:	41 80 fe 55          	cmp    r14b,0x55
  945d8c:	41 0f 94 c1          	sete   r9b
  945d90:	41 80 c1 03          	add    r9b,0x3
  945d94:	41 80 fe 4c          	cmp    r14b,0x4c
  945d98:	45 0f b6 c9          	movzx  r9d,r9b
  945d9c:	44 89 8c 24 00 03 00 	mov    DWORD PTR [rsp+0x300],r9d
  945da3:	00 
  945da4:	44 0f 44 cf          	cmove  r9d,edi
  945da8:	48 8b bc 24 c0 00 00 	mov    rdi,QWORD PTR [rsp+0xc0]
  945daf:	00 
  945db0:	41 80 fe 75          	cmp    r14b,0x75
  945db4:	41 0f 94 c6          	sete   r14b
  945db8:	44 89 8c 24 40 02 00 	mov    DWORD PTR [rsp+0x240],r9d
  945dbf:	00 
  945dc0:	48 39 d7             	cmp    rdi,rdx
  945dc3:	48 89 fa             	mov    rdx,rdi
  945dc6:	41 0f 9c c1          	setl   r9b
  945dca:	45 20 f1             	and    r9b,r14b
  945dcd:	41 80 f9 01          	cmp    r9b,0x1
  945dd1:	75 4c                	jne    945e1f <tokenize_c_raw_no_separators+0x104f>
  945dd3:	48 8b bc 24 00 01 00 	mov    rdi,QWORD PTR [rsp+0x100]
  945dda:	00 
  945ddb:	4c 8b 74 24 50       	mov    r14,QWORD PTR [rsp+0x50]
  945de0:	41 80 7c 3e 01 38    	cmp    BYTE PTR [r14+rdi*1+0x1],0x38
  945de6:	44 8b b4 24 00 03 00 	mov    r14d,DWORD PTR [rsp+0x300]
  945ded:	00 
  945dee:	4c 8d 4f 02          	lea    r9,[rdi+0x2]
  945df2:	48 89 d7             	mov    rdi,rdx
  945df5:	ba 02 00 00 00       	mov    edx,0x2
  945dfa:	44 0f 44 f2          	cmove  r14d,edx
  945dfe:	48 89 fa             	mov    rdx,rdi
  945e01:	48 8b 7c 24 68       	mov    rdi,QWORD PTR [rsp+0x68]
  945e06:	49 0f 44 d1          	cmove  rdx,r9
  945e0a:	45 89 f1             	mov    r9d,r14d
  945e0d:	eb 1d                	jmp    945e2c <tokenize_c_raw_no_separators+0x105c>
  945e0f:	48 8b 94 24 00 01 00 	mov    rdx,QWORD PTR [rsp+0x100]
  945e16:	00 
  945e17:	41 b1 03             	mov    r9b,0x3
  945e1a:	48 ff c2             	inc    rdx
  945e1d:	eb 0d                	jmp    945e2c <tokenize_c_raw_no_separators+0x105c>
  945e1f:	48 8b 7c 24 68       	mov    rdi,QWORD PTR [rsp+0x68]
  945e24:	44 8b 8c 24 40 02 00 	mov    r9d,DWORD PTR [rsp+0x240]
  945e2b:	00 
  945e2c:	48 3b 54 24 30       	cmp    rdx,QWORD PTR [rsp+0x30]
  945e31:	41 b6 03             	mov    r14b,0x3
  945e34:	44 89 b4 24 00 01 00 	mov    DWORD PTR [rsp+0x100],r14d
  945e3b:	00 
  945e3c:	0f 9c 84 24 40 02 00 	setl   BYTE PTR [rsp+0x240]
  945e43:	00 
  945e44:	48 3b 54 24 28       	cmp    rdx,QWORD PTR [rsp+0x28]
  945e49:	0f 9d 84 24 c0 00 00 	setge  BYTE PTR [rsp+0xc0]
  945e50:	00 
  945e51:	44 0f b6 b4 24 c0 00 	movzx  r14d,BYTE PTR [rsp+0xc0]
  945e58:	00 00 
  945e5a:	44 0a b4 24 40 02 00 	or     r14b,BYTE PTR [rsp+0x240]
  945e61:	00 
  945e62:	75 30                	jne    945e94 <tokenize_c_raw_no_separators+0x10c4>
  945e64:	49 89 d6             	mov    r14,rdx
  945e67:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
  945e6c:	44 89 8c 24 40 02 00 	mov    DWORD PTR [rsp+0x240],r9d
  945e73:	00 
  945e74:	45 31 c9             	xor    r9d,r9d
  945e77:	42 80 3c 32 22       	cmp    BYTE PTR [rdx+r14*1],0x22
  945e7c:	41 0f 94 c1          	sete   r9b
  945e80:	43 8d 54 89 03       	lea    edx,[r9+r9*4+0x3]
  945e85:	44 8b 8c 24 40 02 00 	mov    r9d,DWORD PTR [rsp+0x240]
  945e8c:	00 
  945e8d:	89 94 24 00 01 00 00 	mov    DWORD PTR [rsp+0x100],edx
  945e94:	8b 94 24 00 01 00 00 	mov    edx,DWORD PTR [rsp+0x100]
  945e9b:	44 00 ca             	add    dl,r9b
  945e9e:	89 94 24 00 01 00 00 	mov    DWORD PTR [rsp+0x100],edx
  945ea5:	4c 8b 8c 24 40 06 00 	mov    r9,QWORD PTR [rsp+0x640]
  945eac:	00 
  945ead:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  945eb4:	c4 62 b0 f5 ca       	bzhi   r9,rdx,r9
  945eb9:	4c 23 8c cc 40 11 00 	and    r9,QWORD PTR [rsp+rcx*8+0x1140]
  945ec0:	00 
  945ec1:	f3 4d 0f b8 c9       	popcnt r9,r9
  945ec6:	43 0f b6 14 0c       	movzx  edx,BYTE PTR [r12+r9*1]
  945ecb:	80 e2 80             	and    dl,0x80
  945ece:	02 94 24 00 01 00 00 	add    dl,BYTE PTR [rsp+0x100]
  945ed5:	43 88 14 0c          	mov    BYTE PTR [r12+r9*1],dl
  945ed9:	4c 8b 8c 24 00 05 00 	mov    r9,QWORD PTR [rsp+0x500]
  945ee0:	00 
  945ee1:	31 d2                	xor    edx,edx
  945ee3:	c4 c2 e8 f3 c9       	blsr   rdx,r9
  945ee8:	4c 8b 4c 24 48       	mov    r9,QWORD PTR [rsp+0x48]
  945eed:	0f 84 e6 fc ff ff    	je     945bd9 <tokenize_c_raw_no_separators+0xe09>
  945ef3:	e9 11 fe ff ff       	jmp    945d09 <tokenize_c_raw_no_separators+0xf39>
  945ef8:	62 f2 7d 48 31 ed    	vpmovzxbd zmm5,xmm5
  945efe:	62 f3 7d 48 39 e6 02 	vextracti32x4 xmm6,zmm4,0x2
  945f05:	62 f3 7d 48 39 e4 03 	vextracti32x4 xmm4,zmm4,0x3
  945f0c:	62 f2 7d 48 31 c0    	vpmovzxbd zmm0,xmm0
  945f12:	62 f2 7d 48 31 e4    	vpmovzxbd zmm4,xmm4
  945f18:	62 f1 75 48 fe ed    	vpaddd zmm5,zmm1,zmm5
  945f1e:	62 f1 6d 48 fe c0    	vpaddd zmm0,zmm2,zmm0
  945f24:	62 d1 fe 48 7f 6a 01 	vmovdqu64 ZMMWORD PTR [r10+0x40],zmm5
  945f2b:	62 f2 7d 48 31 ee    	vpmovzxbd zmm5,xmm6
  945f31:	62 f1 75 48 fe e4    	vpaddd zmm4,zmm1,zmm4
  945f37:	62 f1 75 48 fe ed    	vpaddd zmm5,zmm1,zmm5
  945f3d:	62 d1 fe 48 7f 6a 02 	vmovdqu64 ZMMWORD PTR [r10+0x80],zmm5
  945f44:	62 d1 fe 48 7f 62 03 	vmovdqu64 ZMMWORD PTR [r10+0xc0],zmm4
  945f4b:	62 f3 7d 48 39 dc 02 	vextracti32x4 xmm4,zmm3,0x2
  945f52:	62 d1 fe 48 7f 47 01 	vmovdqu64 ZMMWORD PTR [r15+0x40],zmm0
  945f59:	62 f3 7d 48 39 db 03 	vextracti32x4 xmm3,zmm3,0x3
  945f60:	62 f2 7d 48 31 c4    	vpmovzxbd zmm0,xmm4
  945f66:	62 f1 6d 48 fe c0    	vpaddd zmm0,zmm2,zmm0
  945f6c:	62 d1 fe 48 7f 47 02 	vmovdqu64 ZMMWORD PTR [r15+0x80],zmm0
  945f73:	62 f2 7d 48 31 c3    	vpmovzxbd zmm0,xmm3
  945f79:	62 f1 6d 48 fe c0    	vpaddd zmm0,zmm2,zmm0
  945f7f:	62 d1 fe 48 7f 47 03 	vmovdqu64 ZMMWORD PTR [r15+0xc0],zmm0
  945f86:	e9 da fc ff ff       	jmp    945c65 <tokenize_c_raw_no_separators+0xe95>
  945f8b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
  945f90:	48 c1 e0 06          	shl    rax,0x6
  945f94:	62 71 fd 48 6f 15 a2 	vmovdqa64 zmm10,ZMMWORD PTR [rip+0xffffffffffac11a2]        # 407140 <__abi_tag+0x6584>
  945f9b:	11 ac ff 
  945f9e:	4c 8b 44 24 60       	mov    r8,QWORD PTR [rsp+0x60]
  945fa3:	49 c7 c6 ff ff ff ff 	mov    r14,0xffffffffffffffff
  945faa:	49 8d 89 40 02 00 00 	lea    rcx,[r9+0x240]
  945fb1:	62 f1 fd 48 6f 54 04 	vmovdqa64 zmm2,ZMMWORD PTR [rsp+rax*1+0xd40]
  945fb8:	35 
  945fb9:	62 f1 fd 48 6f 5c 04 	vmovdqa64 zmm3,ZMMWORD PTR [rsp+rax*1+0xd80]
  945fc0:	36 
  945fc1:	62 f1 fd 48 6f 7c 04 	vmovdqa64 zmm7,ZMMWORD PTR [rsp+rax*1+0xdc0]
  945fc8:	37 
  945fc9:	62 f1 fd 48 6f 6c 04 	vmovdqa64 zmm5,ZMMWORD PTR [rsp+rax*1+0xe00]
  945fd0:	38 
  945fd1:	62 71 fd 48 6f 4c 04 	vmovdqa64 zmm9,ZMMWORD PTR [rsp+rax*1+0xe40]
  945fd8:	39 
  945fd9:	62 f1 fd 48 6f 44 04 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+rax*1+0xcc0]
  945fe0:	33 
  945fe1:	62 f1 fd 48 6f 4c 04 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+rax*1+0xd00]
  945fe8:	34 
  945fe9:	62 71 ed 48 6c db    	vpunpcklqdq zmm11,zmm2,zmm3
  945fef:	62 f1 ed 48 6d d3    	vpunpckhqdq zmm2,zmm2,zmm3
  945ff5:	62 f1 c5 48 6c f5    	vpunpcklqdq zmm6,zmm7,zmm5
  945ffb:	62 f1 c5 48 6d dd    	vpunpckhqdq zmm3,zmm7,zmm5
  946001:	62 f1 fd 48 6f 7c 04 	vmovdqa64 zmm7,ZMMWORD PTR [rsp+rax*1+0xe80]
  946008:	3a 
  946009:	62 f1 fd 48 6c e1    	vpunpcklqdq zmm4,zmm0,zmm1
  94600f:	62 f1 fd 48 6d c1    	vpunpckhqdq zmm0,zmm0,zmm1
  946015:	62 f1 fd 48 6f c8    	vmovdqa64 zmm1,zmm0
  94601b:	62 f2 ad 48 7e c2    	vpermt2q zmm0,zmm10,zmm2
  946021:	62 71 b5 48 6c c7    	vpunpcklqdq zmm8,zmm9,zmm7
  946027:	62 f1 b5 48 6d ef    	vpunpckhqdq zmm5,zmm9,zmm7
  94602d:	62 71 fd 48 6f 0d c9 	vmovdqa64 zmm9,ZMMWORD PTR [rip+0xffffffffffac10c9]        # 407100 <__abi_tag+0x6544>
  946034:	10 ac ff 
  946037:	62 f1 fd 48 6f fc    	vmovdqa64 zmm7,zmm4
  94603d:	62 d2 ad 48 7e e3    	vpermt2q zmm4,zmm10,zmm11
  946043:	62 f2 b5 48 7e ca    	vpermt2q zmm1,zmm9,zmm2
  946049:	62 f1 fd 48 6f d6    	vmovdqa64 zmm2,zmm6
  94604f:	62 d2 b5 48 7e d0    	vpermt2q zmm2,zmm9,zmm8
  946055:	62 d2 ad 48 7e f0    	vpermt2q zmm6,zmm10,zmm8
  94605b:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x540]
  946062:	15 
  946063:	62 d2 b5 48 7e fb    	vpermt2q zmm7,zmm9,zmm11
  946069:	62 71 fd 48 6f db    	vmovdqa64 zmm11,zmm3
  94606f:	62 72 b5 48 7e dd    	vpermt2q zmm11,zmm9,zmm5
  946075:	62 f2 ad 48 7e dd    	vpermt2q zmm3,zmm10,zmm5
  94607b:	62 e3 c5 48 43 ca 44 	vshufi64x2 zmm17,zmm7,zmm2,0x44
  946082:	62 e3 c5 48 43 e2 ee 	vshufi64x2 zmm20,zmm7,zmm2,0xee
  946089:	62 53 f5 48 43 eb 44 	vshufi64x2 zmm13,zmm1,zmm11,0x44
  946090:	62 53 f5 48 43 db ee 	vshufi64x2 zmm11,zmm1,zmm11,0xee
  946097:	62 63 fd 48 43 f3 44 	vshufi64x2 zmm30,zmm0,zmm3,0x44
  94609e:	62 f3 dd 48 43 fe 44 	vshufi64x2 zmm7,zmm4,zmm6,0x44
  9460a5:	62 f3 dd 48 43 ee ee 	vshufi64x2 zmm5,zmm4,zmm6,0xee
  9460ac:	62 f3 fd 48 43 d3 ee 	vshufi64x2 zmm2,zmm0,zmm3,0xee
  9460b3:	62 e1 fd 48 7f 0b    	vmovdqa64 ZMMWORD PTR [rbx],zmm17
  9460b9:	62 71 fd 48 7f 6b 02 	vmovdqa64 ZMMWORD PTR [rbx+0x80],zmm13
  9460c0:	62 f1 fd 48 7f 7b 04 	vmovdqa64 ZMMWORD PTR [rbx+0x100],zmm7
  9460c7:	62 61 fd 48 7f 73 06 	vmovdqa64 ZMMWORD PTR [rbx+0x180],zmm30
  9460ce:	62 e1 fd 48 7f 63 08 	vmovdqa64 ZMMWORD PTR [rbx+0x200],zmm20
  9460d5:	62 71 fd 48 7f 5b 0a 	vmovdqa64 ZMMWORD PTR [rbx+0x280],zmm11
  9460dc:	62 f1 fd 48 7f 6b 0c 	vmovdqa64 ZMMWORD PTR [rbx+0x300],zmm5
  9460e3:	62 f1 fd 48 7f 53 0e 	vmovdqa64 ZMMWORD PTR [rbx+0x380],zmm2
  9460ea:	62 91 fd 48 6f ce    	vmovdqa64 zmm1,zmm30
  9460f0:	48 3b 4c 24 28       	cmp    rcx,QWORD PTR [rsp+0x28]
  9460f5:	0f 8f 56 11 00 00    	jg     947251 <tokenize_c_raw_no_separators+0x2481>
  9460fb:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x480]
  946102:	12 
  946103:	48 8d 8c 04 c0 0c 00 	lea    rcx,[rsp+rax*1+0xcc0]
  94610a:	00 
  94610b:	62 e1 fd 48 6f 7b 10 	vmovdqa64 zmm23,ZMMWORD PTR [rbx+0x400]
  946112:	62 f1 fd 48 6f 5b 12 	vmovdqa64 zmm3,ZMMWORD PTR [rbx+0x480]
  946119:	62 61 fd 48 6f 43 14 	vmovdqa64 zmm24,ZMMWORD PTR [rbx+0x500]
  946120:	62 f1 fd 48 6f 63 16 	vmovdqa64 zmm4,ZMMWORD PTR [rbx+0x580]
  946127:	62 61 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x500],zmm25
  94612e:	14 
  94612f:	62 61 fd 48 7f 54 24 	vmovdqa64 ZMMWORD PTR [rsp+0x640],zmm26
  946136:	19 
  946137:	62 f1 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0xc0],zmm5
  94613e:	03 
  94613f:	4c 89 b4 24 00 03 00 	mov    QWORD PTR [rsp+0x300],r14
  946146:	00 
  946147:	62 e1 fd 48 6f 41 08 	vmovdqa64 zmm16,ZMMWORD PTR [rcx+0x200]
  94614e:	c4 e1 f9 7e c0       	vmovq  rax,xmm0
  946153:	48 0b 84 24 80 02 00 	or     rax,QWORD PTR [rsp+0x280]
  94615a:	00 
  94615b:	62 e1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x4c0],zmm16
  946162:	13 
  946163:	48 89 c2             	mov    rdx,rax
  946166:	48 0b 94 24 a0 00 00 	or     rdx,QWORD PTR [rsp+0xa0]
  94616d:	00 
  94616e:	0f 85 0d 11 00 00    	jne    947281 <tokenize_c_raw_no_separators+0x24b1>
  946174:	62 f2 ed 48 27 c2    	vptestmq k0,zmm2,zmm2
  94617a:	c5 fb 93 c8          	kmovd  ecx,k0
  94617e:	84 c9                	test   cl,cl
  946180:	0f 85 fb 10 00 00    	jne    947281 <tokenize_c_raw_no_separators+0x24b1>
  946186:	c4 41 09 ef f6       	vpxor  xmm14,xmm14,xmm14
  94618b:	62 f3 6d 48 25 d2 ff 	vpternlogd zmm2,zmm2,zmm2,0xff
  946192:	c4 41 01 ef ff       	vpxor  xmm15,xmm15,xmm15
  946197:	62 01 15 00 ef ed    	vpxord xmm29,xmm29,xmm29
  94619d:	62 f1 fd 48 6f 0d 19 	vmovdqa64 zmm1,ZMMWORD PTR [rip+0xffffffffffac1019]        # 4071c0 <__abi_tag+0x6604>
  9461a4:	10 ac ff 
  9461a7:	48 8b 8b c0 04 00 00 	mov    rcx,QWORD PTR [rbx+0x4c0]
  9461ae:	62 f1 fd 48 6f f3    	vmovdqa64 zmm6,zmm3
  9461b4:	48 8b 83 40 04 00 00 	mov    rax,QWORD PTR [rbx+0x440]
  9461bb:	c4 e1 f9 6e c1       	vmovq  xmm0,rcx
  9461c0:	62 f3 fd 48 03 c3 01 	valignq zmm0,zmm0,zmm3,0x1
  9461c7:	62 d2 f5 48 7e f0    	vpermt2q zmm6,zmm1,zmm8
  9461cd:	62 f3 7d 48 39 d9 03 	vextracti32x4 xmm1,zmm3,0x3
  9461d4:	62 f3 fd 48 71 c3 3f 	vpshldq zmm0,zmm0,zmm3,0x3f
  9461db:	c4 e3 f9 16 ca 01    	vpextrq rdx,xmm1,0x1
  9461e1:	48 0f ac ca 3f       	shrd   rdx,rcx,0x3f
  9461e6:	62 b1 fd 48 db ff    	vpandq zmm7,zmm0,zmm23
  9461ec:	89 c1                	mov    ecx,eax
  9461ee:	21 d1                	and    ecx,edx
  9461f0:	62 f3 e5 48 71 c6 01 	vpshldq zmm0,zmm3,zmm6,0x1
  9461f7:	c5 f9 6e c9          	vmovd  xmm1,ecx
  9461fb:	62 b1 fd 48 db f7    	vpandq zmm6,zmm0,zmm23
  946201:	62 f3 f5 48 03 ce 01 	valignq zmm1,zmm1,zmm6,0x1
  946208:	62 f3 f5 48 71 ce 3e 	vpshldq zmm1,zmm1,zmm6,0x3e
  94620f:	62 f1 f5 48 eb c0    	vporq  zmm0,zmm1,zmm0
  946215:	62 f2 7d 48 27 c7    	vptestmd k0,zmm0,zmm7
  94621b:	c5 f8 98 c0          	kortestw k0,k0
  94621f:	0f 85 e4 37 00 00    	jne    949a09 <tokenize_c_raw_no_separators+0x4c39>
  946225:	c5 fa 7e 8c 24 80 05 	vmovq  xmm1,QWORD PTR [rsp+0x580]
  94622c:	00 00 
  94622e:	62 f1 fd 48 6f dd    	vmovdqa64 zmm3,zmm5
  946234:	62 e3 fd 48 3b c0 01 	vextracti64x4 ymm0,zmm16,0x1
  94623b:	4c 8b 9c 24 c0 05 00 	mov    r11,QWORD PTR [rsp+0x5c0]
  946242:	00 
  946243:	62 51 ed 48 db cb    	vpandq zmm9,zmm2,zmm11
  946249:	62 71 ed 48 db d5    	vpandq zmm10,zmm2,zmm5
  94624f:	c5 f9 6e 94 24 80 07 	vmovd  xmm2,DWORD PTR [rsp+0x780]
  946256:	00 00 
  946258:	62 b3 fd 48 03 c4 01 	valignq zmm0,zmm0,zmm20,0x1
  94625f:	62 b3 fd 48 71 c4 3f 	vpshldq zmm0,zmm0,zmm20,0x3f
  946266:	62 f2 9d 40 7e d9    	vpermt2q zmm3,zmm28,zmm1
  94626c:	62 f3 d5 48 71 cb 02 	vpshldq zmm1,zmm5,zmm3,0x2
  946273:	62 f1 f5 48 df dc    	vpandnq zmm3,zmm1,zmm4
  946279:	62 b1 fd 48 6f c9    	vmovdqa64 zmm1,zmm17
  94627f:	62 d2 9d 40 7e c8    	vpermt2q zmm1,zmm28,zmm8
  946285:	62 f3 fd 48 25 dd f8 	vpternlogq zmm3,zmm0,zmm5,0xf8
  94628c:	62 b3 bd 40 25 d9 fe 	vpternlogq zmm3,zmm24,zmm17,0xfe
  946293:	62 f3 f5 40 71 c1 01 	vpshldq zmm0,zmm17,zmm1,0x1
  94629a:	62 b1 7d 08 70 c8 ee 	vpshufd xmm1,xmm16,0xee
  9462a1:	62 d3 f5 48 03 cd 01 	valignq zmm1,zmm1,zmm13,0x1
  9462a8:	62 d3 f5 48 71 cd 3f 	vpshldq zmm1,zmm1,zmm13,0x3f
  9462af:	62 91 f5 48 db e0    	vpandq zmm4,zmm1,zmm24
  9462b5:	62 d3 fd 48 25 e5 f2 	vpternlogq zmm4,zmm0,zmm13,0xf2
  9462bc:	62 f1 e5 48 d4 c4    	vpaddq zmm0,zmm3,zmm4
  9462c2:	62 f3 fd 48 1e c3 01 	vpcmpltuq k0,zmm0,zmm3
  9462c9:	c5 f9 93 c8          	kmovb  ecx,k0
  9462cd:	62 92 fd 48 29 c3    	vpcmpeqq k0,zmm0,zmm27
  9462d3:	c5 f9 93 d0          	kmovb  edx,k0
  9462d7:	c5 fb 93 f0          	kmovd  esi,k0
  9462db:	41 01 d3             	add    r11d,edx
  9462de:	45 8d 34 4b          	lea    r14d,[r11+rcx*2]
  9462e2:	44 89 f1             	mov    ecx,r14d
  9462e5:	40 30 f1             	xor    cl,sil
  9462e8:	c5 fb 92 c1          	kmovd  k0,ecx
  9462ec:	b9 00 00 00 00       	mov    ecx,0x0
  9462f1:	62 f2 fe 48 38 c8    	vpmovm2q zmm1,k0
  9462f7:	62 f1 fd 48 fb c9    	vpsubq zmm1,zmm0,zmm1
  9462fd:	c4 e1 f9 6e c0       	vmovq  xmm0,rax
  946302:	31 c0                	xor    eax,eax
  946304:	41 83 f8 04          	cmp    r8d,0x4
  946308:	62 b3 fd 48 03 c7 01 	valignq zmm0,zmm0,zmm23,0x1
  94630f:	0f 94 c0             	sete   al
  946312:	62 f3 e5 48 25 cc 8c 	vpternlogq zmm1,zmm3,zmm4,0x8c
  946319:	62 51 f5 48 df da    	vpandnq zmm11,zmm1,zmm10
  94631f:	62 b3 fd 48 71 c7 3f 	vpshldq zmm0,zmm0,zmm23,0x3f
  946326:	62 31 fd 48 db e7    	vpandq zmm12,zmm0,zmm23
  94632c:	c5 f9 6e c0          	vmovd  xmm0,eax
  946330:	44 89 c0             	mov    eax,r8d
  946333:	0f 44 c1             	cmove  eax,ecx
  946336:	31 c9                	xor    ecx,ecx
  946338:	45 85 c0             	test   r8d,r8d
  94633b:	62 f1 fd 48 f3 d2    	vpsllq zmm2,zmm0,xmm2
  946341:	0f 94 c2             	sete   dl
  946344:	31 f6                	xor    esi,esi
  946346:	85 c0                	test   eax,eax
  946348:	62 51 9d 48 eb e9    	vporq  zmm13,zmm12,zmm9
  94634e:	40 0f 95 c6          	setne  sil
  946352:	62 73 a5 48 25 ef fe 	vpternlogq zmm13,zmm11,zmm7,0xfe
  946359:	62 f1 cd 48 df da    	vpandnq zmm3,zmm6,zmm2
  94635f:	62 f3 cd 48 1e c3 01 	vpcmpltuq k0,zmm6,zmm3
  946366:	62 f2 cd 48 29 cb    	vpcmpeqq k1,zmm6,zmm3
  94636c:	62 f1 cd 48 fb db    	vpsubq zmm3,zmm6,zmm3
  946372:	c5 fd 4a c0          	kaddb  k0,k0,k0
  946376:	c5 fd 4a c1          	kaddb  k0,k0,k1
  94637a:	c5 fd 47 c1          	kxorb  k0,k0,k1
  94637e:	62 f2 fe 48 38 e0    	vpmovm2q zmm4,k0
  946384:	62 71 e5 48 d4 c4    	vpaddq zmm8,zmm3,zmm4
  94638a:	62 73 cd 48 25 c2 8c 	vpternlogq zmm8,zmm6,zmm2,0x8c
  946391:	62 f3 bd 48 1e c0 01 	vpcmpltuq k0,zmm8,zmm0
  946398:	62 f2 bd 48 29 c8    	vpcmpeqq k1,zmm8,zmm0
  94639e:	62 f1 bd 48 fb d0    	vpsubq zmm2,zmm8,zmm0
  9463a4:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9463a8:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9463ac:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9463b0:	62 f2 fe 48 38 d8    	vpmovm2q zmm3,k0
  9463b6:	62 f1 ed 48 d4 d3    	vpaddq zmm2,zmm2,zmm3
  9463bc:	62 f3 bd 48 25 d0 fe 	vpternlogq zmm2,zmm8,zmm0,0xfe
  9463c3:	c5 f9 6e c6          	vmovd  xmm0,esi
  9463c7:	62 d3 ed 48 25 c5 f2 	vpternlogq zmm0,zmm2,zmm13,0xf2
  9463ce:	62 f2 7d 48 27 c0    	vptestmd k0,zmm0,zmm0
  9463d4:	c5 f8 98 c0          	kortestw k0,k0
  9463d8:	0f 84 62 04 00 00    	je     946840 <tokenize_c_raw_no_separators+0x1a70>
  9463de:	62 93 8d 40 03 c7 07 	valignq zmm0,zmm30,zmm31,0x7
  9463e5:	62 93 bd 48 03 e7 07 	valignq zmm4,zmm8,zmm31,0x7
  9463ec:	88 d1                	mov    cl,dl
  9463ee:	62 71 fd 48 7f 7c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x280],zmm15
  9463f5:	0a 
  9463f6:	62 81 95 48 eb e6    	vporq  zmm20,zmm13,zmm30
  9463fc:	62 71 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x240],zmm14
  946403:	09 
  946404:	c4 41 09 ef f6       	vpxor  xmm14,xmm14,xmm14
  946409:	62 a1 7d 00 ef c0    	vpxord xmm16,xmm16,xmm16
  94640f:	62 a1 55 00 ef ed    	vpxord xmm21,xmm21,xmm21
  946415:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  946419:	c5 f9 6e d9          	vmovd  xmm3,ecx
  94641d:	31 c9                	xor    ecx,ecx
  94641f:	83 f8 01             	cmp    eax,0x1
  946422:	62 f3 8d 40 71 c0 01 	vpshldq zmm0,zmm30,zmm0,0x1
  946429:	62 73 bd 48 71 fc 01 	vpshldq zmm15,zmm8,zmm4,0x1
  946430:	0f 94 c1             	sete   cl
  946433:	c5 d9 ef e4          	vpxor  xmm4,xmm4,xmm4
  946437:	62 e1 7d 08 6e c9    	vmovd  xmm17,ecx
  94643d:	31 c9                	xor    ecx,ecx
  94643f:	83 f8 02             	cmp    eax,0x2
  946442:	62 f1 fd 48 eb db    	vporq  zmm3,zmm0,zmm3
  946448:	0f 94 c1             	sete   cl
  94644b:	31 c0                	xor    eax,eax
  94644d:	62 21 fd 48 6f c1    	vmovdqa64 zmm24,zmm17
  946453:	62 73 ed 48 25 fb f2 	vpternlogq zmm15,zmm2,zmm3,0xf2
  94645a:	c4 e2 79 22 1d 1d 10 	vpmovsxbq xmm3,WORD PTR [rip+0xffffffffffac101d]        # 407480 <__abi_tag+0x68c4>
  946461:	ac ff 
  946463:	62 e1 7d 08 6e d1    	vmovd  xmm18,ecx
  946469:	62 d3 dd 40 1e c7 01 	vpcmpltuq k0,zmm20,zmm15
  946470:	62 d2 dd 40 29 cf    	vpcmpeqq k1,zmm20,zmm15
  946476:	62 c1 dd 40 fb f7    	vpsubq zmm22,zmm20,zmm15
  94647c:	c5 fd 4a c0          	kaddb  k0,k0,k0
  946480:	c5 fd 4a c1          	kaddb  k0,k0,k1
  946484:	c5 fd 47 c1          	kxorb  k0,k0,k1
  946488:	62 e1 fd 48 eb db    	vporq  zmm19,zmm0,zmm3
  94648e:	62 f2 fe 48 38 d8    	vpmovm2q zmm3,k0
  946494:	62 f1 cd 40 d4 c3    	vpaddq zmm0,zmm22,zmm3
  94649a:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  94649e:	62 a1 fd 48 6f f2    	vmovdqa64 zmm22,zmm18
  9464a4:	62 c1 fd 48 df fd    	vpandnq zmm23,zmm0,zmm13
  9464aa:	e9 97 00 00 00       	jmp    946546 <tokenize_c_raw_no_separators+0x1776>
  9464af:	90                   	nop
  9464b0:	62 91 cd 40 eb c1    	vporq  zmm0,zmm22,zmm25
  9464b6:	62 51 c5 40 eb f6    	vporq  zmm14,zmm23,zmm14
  9464bc:	62 81 fd 40 eb c0    	vporq  zmm16,zmm16,zmm24
  9464c2:	62 81 fd 48 eb f6    	vporq  zmm22,zmm0,zmm30
  9464c8:	62 b3 cd 40 1e c3 01 	vpcmpltuq k0,zmm22,zmm19
  9464cf:	62 b2 cd 40 29 cb    	vpcmpeqq k1,zmm22,zmm19
  9464d5:	62 a1 cd 40 fb f3    	vpsubq zmm22,zmm22,zmm19
  9464db:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9464df:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9464e3:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9464e7:	62 e2 fe 48 38 f8    	vpmovm2q zmm23,k0
  9464ed:	62 a1 cd 40 d4 f7    	vpaddq zmm22,zmm22,zmm23
  9464f3:	62 e1 cd 40 df f0    	vpandnq zmm22,zmm22,zmm0
  9464f9:	62 b3 dd 40 1e c6 01 	vpcmpltuq k0,zmm20,zmm22
  946500:	62 b2 dd 40 29 ce    	vpcmpeqq k1,zmm20,zmm22
  946506:	62 b1 dd 40 fb c6    	vpsubq zmm0,zmm20,zmm22
  94650c:	62 01 3d 00 ef c0    	vpxord xmm24,xmm24,xmm24
  946512:	c5 fd 4a c0          	kaddb  k0,k0,k0
  946516:	c5 fd 4a c1          	kaddb  k0,k0,k1
  94651a:	c5 fd 47 c1          	kxorb  k0,k0,k1
  94651e:	62 e2 fe 48 38 f0    	vpmovm2q zmm22,k0
  946524:	62 b1 fd 48 d4 c6    	vpaddq zmm0,zmm0,zmm22
  94652a:	62 a1 4d 00 ef f6    	vpxord xmm22,xmm22,xmm22
  946530:	62 c1 fd 48 df fd    	vpandnq zmm23,zmm0,zmm13
  946536:	62 b2 45 40 27 c7    	vptestmd k0,zmm23,zmm23
  94653c:	c5 f8 98 c0          	kortestw k0,k0
  946540:	0f 84 3a 02 00 00    	je     946780 <tokenize_c_raw_no_separators+0x19b0>
  946546:	62 41 c5 40 db c9    	vpandq zmm25,zmm23,zmm9
  94654c:	62 41 c5 40 db d3    	vpandq zmm26,zmm23,zmm11
  946552:	62 01 bd 40 eb d9    	vporq  zmm27,zmm24,zmm25
  946558:	62 b1 ad 40 eb c6    	vporq  zmm0,zmm26,zmm22
  94655e:	62 61 a5 40 eb e0    	vporq  zmm28,zmm27,zmm0
  946564:	62 92 1d 40 27 c4    	vptestmd k0,zmm28,zmm28
  94656a:	c5 f8 98 c0          	kortestw k0,k0
  94656e:	0f 84 dc 00 00 00    	je     946650 <tokenize_c_raw_no_separators+0x1880>
  946574:	62 93 8d 40 1e c3 01 	vpcmpltuq k0,zmm30,zmm27
  94657b:	62 92 8d 40 29 cb    	vpcmpeqq k1,zmm30,zmm27
  946581:	62 01 b5 40 eb ca    	vporq  zmm25,zmm25,zmm26
  946587:	62 01 8d 40 fb db    	vpsubq zmm27,zmm30,zmm27
  94658d:	c5 fd 4a c0          	kaddb  k0,k0,k0
  946591:	62 03 b5 40 03 d7 07 	valignq zmm26,zmm25,zmm31,0x7
  946598:	62 f1 b5 40 eb ed    	vporq  zmm5,zmm25,zmm5
  94659e:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9465a2:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9465a6:	62 f2 8d 40 29 c8    	vpcmpeqq k1,zmm30,zmm0
  9465ac:	62 03 b5 40 71 d2 01 	vpshldq zmm26,zmm25,zmm26,0x1
  9465b3:	62 62 fe 48 38 e0    	vpmovm2q zmm28,k0
  9465b9:	62 f3 8d 40 1e c0 01 	vpcmpltuq k0,zmm30,zmm0
  9465c0:	62 01 a5 40 d4 dc    	vpaddq zmm27,zmm27,zmm28
  9465c6:	62 f1 8d 40 fb c0    	vpsubq zmm0,zmm30,zmm0
  9465cc:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9465d0:	62 41 a5 40 db d9    	vpandq zmm27,zmm27,zmm9
  9465d6:	62 03 cd 40 25 c2 fe 	vpternlogq zmm24,zmm22,zmm26,0xfe
  9465dd:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9465e1:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9465e5:	62 62 fe 48 38 e0    	vpmovm2q zmm28,k0
  9465eb:	62 91 fd 48 d4 c4    	vpaddq zmm0,zmm0,zmm28
  9465f1:	62 d3 a5 40 25 c2 ec 	vpternlogq zmm0,zmm27,zmm10,0xec
  9465f8:	62 01 fd 48 eb de    	vporq  zmm27,zmm0,zmm30
  9465fe:	62 93 a5 40 1e c0 01 	vpcmpltuq k0,zmm27,zmm24
  946605:	62 92 a5 40 29 c8    	vpcmpeqq k1,zmm27,zmm24
  94660b:	62 81 a5 40 fb f0    	vpsubq zmm22,zmm27,zmm24
  946611:	c5 fd 4a c0          	kaddb  k0,k0,k0
  946615:	c5 fd 4a c1          	kaddb  k0,k0,k1
  946619:	c5 fd 47 c1          	kxorb  k0,k0,k1
  94661d:	62 62 fe 48 38 c0    	vpmovm2q zmm24,k0
  946623:	62 81 cd 40 d4 f0    	vpaddq zmm22,zmm22,zmm24
  946629:	62 93 cd 40 25 c6 10 	vpternlogq zmm0,zmm22,zmm30,0x10
  946630:	62 93 cd 40 25 e6 f2 	vpternlogq zmm4,zmm22,zmm30,0xf2
  946637:	62 83 fd 48 03 f7 07 	valignq zmm22,zmm0,zmm31,0x7
  94663e:	62 f1 fd 48 eb db    	vporq  zmm3,zmm0,zmm3
  946644:	62 a3 fd 48 71 f6 01 	vpshldq zmm22,zmm0,zmm22,0x1
  94664b:	eb 09                	jmp    946656 <tokenize_c_raw_no_separators+0x1886>
  94664d:	0f 1f 00             	nop    DWORD PTR [rax]
  946650:	62 a1 4d 00 ef f6    	vpxord xmm22,xmm22,xmm22
  946656:	62 61 c5 40 db cf    	vpandq zmm25,zmm23,zmm7
  94665c:	62 c3 c5 40 25 ec f8 	vpternlogq zmm21,zmm23,zmm12,0xf8
  946663:	62 92 35 40 27 c1    	vptestmd k0,zmm25,zmm25
  946669:	c5 f8 98 c0          	kortestw k0,k0
  94666d:	0f 84 86 fe ff ff    	je     9464f9 <tokenize_c_raw_no_separators+0x1729>
  946673:	62 93 b5 40 03 c7 07 	valignq zmm0,zmm25,zmm31,0x7
  94667a:	62 f3 b5 40 71 c0 03 	vpshldq zmm0,zmm25,zmm0,0x3
  946681:	62 e1 cd 48 df f8    	vpandnq zmm23,zmm6,zmm0
  946687:	62 b3 cd 48 1e c7 01 	vpcmpltuq k0,zmm6,zmm23
  94668e:	62 b2 cd 48 29 cf    	vpcmpeqq k1,zmm6,zmm23
  946694:	62 a1 cd 48 fb ff    	vpsubq zmm23,zmm6,zmm23
  94669a:	c5 fd 4a c0          	kaddb  k0,k0,k0
  94669e:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9466a2:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9466a6:	62 62 fe 48 38 c0    	vpmovm2q zmm24,k0
  9466ac:	62 81 c5 40 d4 f8    	vpaddq zmm23,zmm23,zmm24
  9466b2:	62 e3 cd 48 25 f8 8c 	vpternlogq zmm23,zmm6,zmm0,0x8c
  9466b9:	62 93 c5 40 1e c1 01 	vpcmpltuq k0,zmm23,zmm25
  9466c0:	62 92 c5 40 29 c9    	vpcmpeqq k1,zmm23,zmm25
  9466c6:	62 91 c5 40 fb c1    	vpsubq zmm0,zmm23,zmm25
  9466cc:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9466d0:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9466d4:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9466d8:	62 62 fe 48 38 c0    	vpmovm2q zmm24,k0
  9466de:	62 01 fd 48 d4 c0    	vpaddq zmm24,zmm0,zmm24
  9466e4:	62 93 c5 40 03 c7 07 	valignq zmm0,zmm23,zmm31,0x7
  9466eb:	62 03 c5 40 25 c1 fe 	vpternlogq zmm24,zmm23,zmm25,0xfe
  9466f2:	62 92 3d 40 27 c6    	vptestmd k0,zmm24,zmm30
  9466f8:	62 63 c5 40 71 c8 01 	vpshldq zmm25,zmm23,zmm0,0x1
  9466ff:	c5 f8 98 c0          	kortestw k0,k0
  946703:	0f 84 a7 fd ff ff    	je     9464b0 <tokenize_c_raw_no_separators+0x16e0>
  946709:	62 91 8d 40 df c1    	vpandnq zmm0,zmm30,zmm25
  94670f:	b0 01                	mov    al,0x1
  946711:	62 f3 8d 40 1e c0 01 	vpcmpltuq k0,zmm30,zmm0
  946718:	62 f2 8d 40 29 c8    	vpcmpeqq k1,zmm30,zmm0
  94671e:	62 f1 8d 40 fb c0    	vpsubq zmm0,zmm30,zmm0
  946724:	c5 fd 4a c0          	kaddb  k0,k0,k0
  946728:	c5 fd 4a c1          	kaddb  k0,k0,k1
  94672c:	c5 fd 47 c1          	kxorb  k0,k0,k1
  946730:	62 62 fe 48 38 d0    	vpmovm2q zmm26,k0
  946736:	62 91 fd 48 d4 c2    	vpaddq zmm0,zmm0,zmm26
  94673c:	62 91 fd 48 ef c6    	vpxorq zmm0,zmm0,zmm30
  946742:	62 93 b5 40 25 c0 fe 	vpternlogq zmm0,zmm25,zmm24,0xfe
  946749:	62 f1 fd 48 df ed    	vpandnq zmm5,zmm0,zmm5
  94674f:	62 f1 fd 48 df db    	vpandnq zmm3,zmm0,zmm3
  946755:	62 f1 fd 48 df e4    	vpandnq zmm4,zmm0,zmm4
  94675b:	62 a1 fd 48 df ed    	vpandnq zmm21,zmm0,zmm21
  946761:	62 a1 fd 48 df c0    	vpandnq zmm16,zmm0,zmm16
  946767:	62 a1 fd 48 df f6    	vpandnq zmm22,zmm0,zmm22
  94676d:	e9 3e fd ff ff       	jmp    9464b0 <tokenize_c_raw_no_separators+0x16e0>
  946772:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  946779:	1f 84 00 00 00 00 00 
  946780:	a8 01                	test   al,0x1
  946782:	0f 85 3c 1e 00 00    	jne    9485c4 <tokenize_c_raw_no_separators+0x37f4>
  946788:	41 8d 40 ff          	lea    eax,[r8-0x1]
  94678c:	31 c9                	xor    ecx,ecx
  94678e:	62 f1 fd 40 eb d2    	vporq  zmm2,zmm16,zmm2
  946794:	62 51 8d 48 eb c0    	vporq  zmm8,zmm14,zmm8
  94679a:	62 e1 fd 48 6f 44 24 	vmovdqa64 zmm16,ZMMWORD PTR [rsp+0x4c0]
  9467a1:	13 
  9467a2:	62 71 fd 48 6f 74 24 	vmovdqa64 zmm14,ZMMWORD PTR [rsp+0x240]
  9467a9:	09 
  9467aa:	62 71 fd 48 6f 7c 24 	vmovdqa64 zmm15,ZMMWORD PTR [rsp+0x280]
  9467b1:	0a 
  9467b2:	62 71 dd 48 eb d3    	vporq  zmm10,zmm4,zmm3
  9467b8:	83 f8 02             	cmp    eax,0x2
  9467bb:	0f 92 c1             	setb   cl
  9467be:	31 c0                	xor    eax,eax
  9467c0:	41 83 f8 03          	cmp    r8d,0x3
  9467c4:	0f 94 c0             	sete   al
  9467c7:	c5 f9 6e c1          	vmovd  xmm0,ecx
  9467cb:	c5 f9 6e f0          	vmovd  xmm6,eax
  9467cf:	62 f1 d5 48 eb c0    	vporq  zmm0,zmm5,zmm0
  9467d5:	62 f1 d5 40 eb f6    	vporq  zmm6,zmm21,zmm6
  9467db:	62 f3 8d 40 1e c6 01 	vpcmpltuq k0,zmm30,zmm6
  9467e2:	62 f2 8d 40 29 ce    	vpcmpeqq k1,zmm30,zmm6
  9467e8:	62 f1 8d 40 fb f6    	vpsubq zmm6,zmm30,zmm6
  9467ee:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9467f2:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9467f6:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9467fa:	62 f2 ad 48 29 c8    	vpcmpeqq k1,zmm10,zmm0
  946800:	62 72 fe 48 38 c8    	vpmovm2q zmm9,k0
  946806:	62 f3 ad 48 1e c0 01 	vpcmpltuq k0,zmm10,zmm0
  94680d:	62 f1 ad 48 fb c0    	vpsubq zmm0,zmm10,zmm0
  946813:	62 d1 cd 48 d4 f1    	vpaddq zmm6,zmm6,zmm9
  946819:	c5 fd 4a c0          	kaddb  k0,k0,k0
  94681d:	62 f1 8d 40 df f6    	vpandnq zmm6,zmm30,zmm6
  946823:	c5 fd 4a c1          	kaddb  k0,k0,k1
  946827:	c5 fd 47 c1          	kxorb  k0,k0,k1
  94682b:	62 72 fe 48 38 c8    	vpmovm2q zmm9,k0
  946831:	62 d1 fd 48 d4 c1    	vpaddq zmm0,zmm0,zmm9
  946837:	62 71 fd 48 eb cb    	vporq  zmm9,zmm0,zmm3
  94683d:	eb 16                	jmp    946855 <tokenize_c_raw_no_separators+0x1a85>
  94683f:	90                   	nop
  946840:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  946844:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  946848:	c5 d9 ef e4          	vpxor  xmm4,xmm4,xmm4
  94684c:	c4 41 31 ef c9       	vpxor  xmm9,xmm9,xmm9
  946851:	c5 c9 ef f6          	vpxor  xmm6,xmm6,xmm6
  946855:	62 d3 7d 48 39 d2 03 	vextracti32x4 xmm10,zmm2,0x3
  94685c:	62 73 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm8,0x3
  946863:	c4 63 f9 16 d0 01    	vpextrq rax,xmm10,0x1
  946869:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  94686f:	c4 62 f0 f2 d8       	andn   r11,rcx,rax
  946874:	48 3b 7c 24 28       	cmp    rdi,QWORD PTR [rsp+0x28]
  946879:	7c 09                	jl     946884 <tokenize_c_raw_no_separators+0x1ab4>
  94687b:	4d 85 db             	test   r11,r11
  94687e:	0f 88 85 31 00 00    	js     949a09 <tokenize_c_raw_no_separators+0x4c39>
  946884:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x480]
  94688b:	12 
  94688c:	ba 04 00 00 00       	mov    edx,0x4
  946891:	c4 e3 f9 16 84 24 80 	vpextrq QWORD PTR [rsp+0x280],xmm0,0x1
  946898:	02 00 00 01 
  94689c:	62 f3 7d 48 39 d8 03 	vextracti32x4 xmm0,zmm3,0x3
  9468a3:	c4 e3 f9 16 c0 01    	vpextrq rax,xmm0,0x1
  9468a9:	62 73 7d 48 39 c8 03 	vextracti32x4 xmm0,zmm9,0x3
  9468b0:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  9468b6:	4c 09 d8             	or     rax,r11
  9468b9:	62 f3 7d 48 39 f0 03 	vextracti32x4 xmm0,zmm6,0x3
  9468c0:	c4 e2 f8 f2 c9       	andn   rcx,rax,rcx
  9468c5:	c4 e3 f9 16 c0 01    	vpextrq rax,xmm0,0x1
  9468cb:	62 f3 7d 48 39 f8 03 	vextracti32x4 xmm0,zmm7,0x3
  9468d2:	48 c1 e8 3f          	shr    rax,0x3f
  9468d6:	c5 a9 db c0          	vpand  xmm0,xmm10,xmm0
  9468da:	4d 85 db             	test   r11,r11
  9468dd:	8d 04 40             	lea    eax,[rax+rax*2]
  9468e0:	c4 e3 f9 16 c6 01    	vpextrq rsi,xmm0,0x1
  9468e6:	0f 48 c2             	cmovs  eax,edx
  9468e9:	48 89 f2             	mov    rdx,rsi
  9468ec:	48 c1 ea 3e          	shr    rdx,0x3e
  9468f0:	48 c1 ee 3f          	shr    rsi,0x3f
  9468f4:	48 83 fa 01          	cmp    rdx,0x1
  9468f8:	83 de ff             	sbb    esi,0xffffffff
  9468fb:	48 89 b4 24 80 07 00 	mov    QWORD PTR [rsp+0x780],rsi
  946902:	00 
  946903:	48 85 c9             	test   rcx,rcx
  946906:	0f 88 ab 0a 00 00    	js     9473b7 <tokenize_c_raw_no_separators+0x25e7>
  94690c:	89 44 24 60          	mov    DWORD PTR [rsp+0x60],eax
  946910:	31 f6                	xor    esi,esi
  946912:	62 f3 b5 48 25 f2 fe 	vpternlogq zmm6,zmm9,zmm2,0xfe
  946919:	62 71 fd 48 6f 53 20 	vmovdqa64 zmm10,ZMMWORD PTR [rbx+0x800]
  946920:	48 8b 84 24 f8 01 00 	mov    rax,QWORD PTR [rsp+0x1f8]
  946927:	00 
  946928:	62 73 ad 48 25 fe 54 	vpternlogq zmm15,zmm10,zmm6,0x54
  94692f:	62 53 ed 48 25 fe f8 	vpternlogq zmm15,zmm2,zmm14,0xf8
  946936:	62 d2 05 48 27 c7    	vptestmd k0,zmm15,zmm15
  94693c:	c5 f8 98 c0          	kortestw k0,k0
  946940:	0f 85 c3 30 00 00    	jne    949a09 <tokenize_c_raw_no_separators+0x4c39>
  946946:	62 61 fd 48 6f 5b 0e 	vmovdqa64 zmm27,ZMMWORD PTR [rbx+0x380]
  94694d:	62 f1 fd 48 6f 3b    	vmovdqa64 zmm7,ZMMWORD PTR [rbx]
  946953:	62 e1 fd 48 6f 53 02 	vmovdqa64 zmm18,ZMMWORD PTR [rbx+0x80]
  94695a:	62 71 fd 48 6f 5b 04 	vmovdqa64 zmm11,ZMMWORD PTR [rbx+0x100]
  946961:	62 71 fd 48 6f 6b 06 	vmovdqa64 zmm13,ZMMWORD PTR [rbx+0x180]
  946968:	62 71 fd 48 6f 73 0a 	vmovdqa64 zmm14,ZMMWORD PTR [rbx+0x280]
  94696f:	62 71 fd 48 6f 63 0c 	vmovdqa64 zmm12,ZMMWORD PTR [rbx+0x300]
  946976:	62 71 fd 48 6f 7b 12 	vmovdqa64 zmm15,ZMMWORD PTR [rbx+0x480]
  94697d:	62 71 fd 48 6f 4b 14 	vmovdqa64 zmm9,ZMMWORD PTR [rbx+0x500]
  946984:	62 61 fd 48 6f 43 18 	vmovdqa64 zmm24,ZMMWORD PTR [rbx+0x600]
  94698b:	62 e1 fd 48 6f 73 1a 	vmovdqa64 zmm22,ZMMWORD PTR [rbx+0x680]
  946992:	62 e1 fd 48 6f 7b 1c 	vmovdqa64 zmm23,ZMMWORD PTR [rbx+0x700]
  946999:	62 a3 7d 48 39 c1 02 	vextracti32x4 xmm17,zmm16,0x2
  9469a0:	62 03 cd 48 25 eb 02 	vpternlogq zmm29,zmm6,zmm27,0x2
  9469a7:	62 92 15 40 27 c5    	vptestmd k0,zmm29,zmm29
  9469ad:	c5 f8 98 c0          	kortestw k0,k0
  9469b1:	0f 85 fa 0a 00 00    	jne    9474b1 <tokenize_c_raw_no_separators+0x26e1>
  9469b7:	62 e3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm16,0x3
  9469be:	c4 e1 f9 7e c7       	vmovq  rdi,xmm0
  9469c3:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  9469c8:	62 f2 5d 48 27 c4    	vptestmd k0,zmm4,zmm4
  9469ce:	89 f2                	mov    edx,esi
  9469d0:	48 89 bc 24 c0 05 00 	mov    QWORD PTR [rsp+0x5c0],rdi
  9469d7:	00 
  9469d8:	62 f3 fd 48 03 c3 01 	valignq zmm0,zmm0,zmm3,0x1
  9469df:	c5 f8 98 c0          	kortestw k0,k0
  9469e3:	0f 94 c1             	sete   cl
  9469e6:	80 f2 01             	xor    dl,0x1
  9469e9:	62 e3 fd 48 71 c3 3f 	vpshldq zmm16,zmm0,zmm3,0x3f
  9469f0:	62 e3 9d 48 25 c5 80 	vpternlogq zmm16,zmm12,zmm5,0x80
  9469f7:	84 d1                	test   cl,dl
  9469f9:	0f 84 1f 0d 00 00    	je     94771e <tokenize_c_raw_no_separators+0x294e>
  9469ff:	62 e1 fd 48 6f 25 f7 	vmovdqa64 zmm20,ZMMWORD PTR [rip+0xffffffffffac08f7]        # 407300 <__abi_tag+0x6744>
  946a06:	08 ac ff 
  946a09:	62 71 fd 48 7f 7c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x540],zmm15
  946a10:	15 
  946a11:	62 11 fd 48 6f c3    	vmovdqa64 zmm8,zmm27
  946a17:	62 11 fd 48 6f fd    	vmovdqa64 zmm15,zmm29
  946a1d:	62 61 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x100],zmm30
  946a24:	04 
  946a25:	40 f6 c6 01          	test   sil,0x1
  946a29:	75 06                	jne    946a31 <tokenize_c_raw_no_separators+0x1c61>
  946a2b:	62 a1 5d 00 ef e4    	vpxord xmm20,xmm20,xmm20
  946a31:	48 8b 8b 40 06 00 00 	mov    rcx,QWORD PTR [rbx+0x640]
  946a38:	62 e1 fe 08 7e 6c 24 	vmovq  xmm21,QWORD PTR [rsp+0xb8]
  946a3f:	17 
  946a40:	62 f1 fd 48 6f c6    	vmovdqa64 zmm0,zmm6
  946a46:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
  946a4c:	62 61 fd 08 6e c9    	vmovq  xmm25,rcx
  946a52:	62 61 7d 08 6e d1    	vmovd  xmm26,ecx
  946a58:	62 03 b5 40 03 c8 01 	valignq zmm25,zmm25,zmm24,0x1
  946a5f:	62 03 b5 40 71 c0 3f 	vpshldq zmm24,zmm25,zmm24,0x3f
  946a66:	62 91 35 00 72 d2 01 	vpsrld xmm25,xmm26,0x1
  946a6d:	62 b3 f5 48 25 c5 fe 	vpternlogq zmm0,zmm1,zmm21,0xfe
  946a74:	62 03 b5 40 03 c8 01 	valignq zmm25,zmm25,zmm24,0x1
  946a7b:	62 03 b5 40 71 c8 3e 	vpshldq zmm25,zmm25,zmm24,0x3e
  946a82:	62 01 b5 40 db c0    	vpandq zmm24,zmm25,zmm24
  946a88:	62 61 fe 08 7e 8b 40 	vmovq  xmm25,QWORD PTR [rbx+0x740]
  946a8f:	07 00 00 
  946a92:	62 01 fd 48 df e8    	vpandnq zmm29,zmm0,zmm24
  946a98:	62 f1 bd 40 eb c0    	vporq  zmm0,zmm24,zmm0
  946a9e:	62 61 fe 08 7e 83 c0 	vmovq  xmm24,QWORD PTR [rbx+0x6c0]
  946aa5:	06 00 00 
  946aa8:	62 23 95 40 03 db 07 	valignq zmm27,zmm29,zmm19,0x7
  946aaf:	62 03 95 40 71 e3 02 	vpshldq zmm28,zmm29,zmm27,0x2
  946ab6:	62 23 b5 40 03 cf 01 	valignq zmm25,zmm25,zmm23,0x1
  946abd:	62 23 bd 40 03 c6 01 	valignq zmm24,zmm24,zmm22,0x1
  946ac4:	62 a3 b5 40 71 ff 3e 	vpshldq zmm23,zmm25,zmm23,0x3e
  946acb:	62 03 95 40 71 cb 01 	vpshldq zmm25,zmm29,zmm27,0x1
  946ad2:	62 03 95 40 71 db 03 	vpshldq zmm27,zmm29,zmm27,0x3
  946ad9:	62 23 bd 40 71 fe 3f 	vpshldq zmm31,zmm24,zmm22,0x3f
  946ae0:	62 21 fd 48 df f7    	vpandnq zmm30,zmm0,zmm23
  946ae6:	62 23 fd 48 25 ff 10 	vpternlogq zmm31,zmm0,zmm23,0x10
  946aed:	62 b3 8d 40 03 c3 07 	valignq zmm0,zmm30,zmm19,0x7
  946af4:	62 23 85 40 03 c3 07 	valignq zmm24,zmm31,zmm19,0x7
  946afb:	62 81 85 40 eb f6    	vporq  zmm22,zmm31,zmm30
  946b01:	62 63 8d 40 71 d0 02 	vpshldq zmm26,zmm30,zmm0,0x2
  946b08:	62 e1 bd 40 eb f8    	vporq  zmm23,zmm24,zmm0
  946b0e:	62 91 cd 40 eb c5    	vporq  zmm0,zmm22,zmm29
  946b14:	62 a3 cd 40 71 ff 01 	vpshldq zmm23,zmm22,zmm23,0x1
  946b1b:	62 03 c5 40 25 e1 fe 	vpternlogq zmm28,zmm23,zmm25,0xfe
  946b22:	62 03 ad 40 25 e3 fe 	vpternlogq zmm28,zmm26,zmm27,0xfe
  946b29:	62 f2 1d 40 27 c0    	vptestmd k0,zmm28,zmm0
  946b2f:	c5 f8 98 c0          	kortestw k0,k0
  946b33:	0f 85 3a 0f 00 00    	jne    947a73 <tokenize_c_raw_no_separators+0x2ca3>
  946b39:	62 81 fd 48 6f fd    	vmovdqa64 zmm23,zmm29
  946b3f:	62 01 fd 48 6f ce    	vmovdqa64 zmm25,zmm30
  946b45:	62 81 fd 48 6f f7    	vmovdqa64 zmm22,zmm31
  946b4b:	62 61 fd 48 6f 35 2b 	vmovdqa64 zmm30,ZMMWORD PTR [rip+0xffffffffffac062b]        # 407180 <__abi_tag+0x65c4>
  946b52:	06 ac ff 
  946b55:	62 e3 7d 48 39 f0 03 	vextracti32x4 xmm0,zmm22,0x3
  946b5c:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  946b62:	48 85 c9             	test   rcx,rcx
  946b65:	78 29                	js     946b90 <tokenize_c_raw_no_separators+0x1dc0>
  946b67:	62 63 7d 48 39 c8 03 	vextracti32x4 xmm0,zmm25,0x3
  946b6e:	c4 e3 f9 16 c2 01    	vpextrq rdx,xmm0,0x1
  946b74:	48 c1 ea 3e          	shr    rdx,0x3e
  946b78:	74 26                	je     946ba0 <tokenize_c_raw_no_separators+0x1dd0>
  946b7a:	31 c9                	xor    ecx,ecx
  946b7c:	83 fa 01             	cmp    edx,0x1
  946b7f:	0f 95 c1             	setne  cl
  946b82:	ff c1                	inc    ecx
  946b84:	eb 4a                	jmp    946bd0 <tokenize_c_raw_no_separators+0x1e00>
  946b86:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  946b8d:	00 00 00 
  946b90:	b9 01 00 00 00       	mov    ecx,0x1
  946b95:	eb 39                	jmp    946bd0 <tokenize_c_raw_no_separators+0x1e00>
  946b97:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  946b9e:	00 00 
  946ba0:	62 e3 7d 48 39 f8 03 	vextracti32x4 xmm0,zmm23,0x3
  946ba7:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  946bad:	48 c1 e9 3d          	shr    rcx,0x3d
  946bb1:	0f 84 87 06 00 00    	je     94723e <tokenize_c_raw_no_separators+0x246e>
  946bb7:	f3 48 0f bd d1       	lzcnt  rdx,rcx
  946bbc:	b9 40 00 00 00       	mov    ecx,0x40
  946bc1:	29 d1                	sub    ecx,edx
  946bc3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  946bca:	84 00 00 00 00 00 
  946bd0:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  946bd7:	89 ca                	mov    edx,ecx
  946bd9:	fe c9                	dec    cl
  946bdb:	c4 e2 e8 f5 d6       	bzhi   rdx,rsi,rdx
  946be0:	48 89 94 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rdx
  946be7:	00 
  946be8:	ba 01 00 00 00       	mov    edx,0x1
  946bed:	c4 e2 f1 f7 ca       	shlx   rcx,rdx,rcx
  946bf2:	62 d1 b5 40 db c1    	vpandq zmm0,zmm25,zmm9
  946bf8:	62 a3 fd 48 03 db 07 	valignq zmm19,zmm0,zmm19,0x7
  946bff:	62 23 fd 48 71 eb 01 	vpshldq zmm29,zmm0,zmm19,0x1
  946c06:	62 a3 fd 48 71 db 02 	vpshldq zmm19,zmm0,zmm19,0x2
  946c0d:	62 81 e5 40 eb dd    	vporq  zmm19,zmm19,zmm29
  946c13:	62 a3 cd 48 25 dd fe 	vpternlogq zmm19,zmm6,zmm21,0xfe
  946c1a:	62 f3 e5 40 25 c8 10 	vpternlogq zmm1,zmm19,zmm0,0x10
  946c21:	c5 fa 7e 84 24 40 04 	vmovq  xmm0,QWORD PTR [rsp+0x440]
  946c28:	00 00 
  946c2a:	62 e1 fd 48 6f d9    	vmovdqa64 zmm19,zmm1
  946c30:	62 e2 8d 40 7e d8    	vpermt2q zmm19,zmm30,zmm0
  946c36:	62 b3 f5 48 71 c3 01 	vpshldq zmm0,zmm1,zmm19,0x1
  946c3d:	62 61 fd 48 df e9    	vpandnq zmm29,zmm0,zmm1
  946c43:	62 83 b5 48 25 d5 02 	vpternlogq zmm18,zmm9,zmm29,0x2
  946c4a:	62 b2 6d 40 27 c2    	vptestmd k0,zmm18,zmm18
  946c50:	c5 f8 98 c0          	kortestw k0,k0
  946c54:	0f 85 af 2d 00 00    	jne    949a09 <tokenize_c_raw_no_separators+0x4c39>
  946c5a:	62 73 7d 48 39 e0 03 	vextracti32x4 xmm0,zmm12,0x3
  946c61:	48 89 8c 24 40 02 00 	mov    QWORD PTR [rsp+0x240],rcx
  946c68:	00 
  946c69:	62 e1 fd 48 6f df    	vmovdqa64 zmm19,zmm7
  946c6f:	62 e3 f5 48 25 de 10 	vpternlogq zmm19,zmm1,zmm6,0x10
  946c76:	4d 89 c8             	mov    r8,r9
  946c79:	62 c1 fd 08 7e c9    	vmovq  r9,xmm17
  946c7f:	44 89 f6             	mov    esi,r14d
  946c82:	49 89 fe             	mov    r14,rdi
  946c85:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  946c8b:	c5 fa 7e 84 24 40 03 	vmovq  xmm0,QWORD PTR [rsp+0x340]
  946c92:	00 00 
  946c94:	62 a1 fd 48 6f d3    	vmovdqa64 zmm18,zmm19
  946c9a:	49 d1 e9             	shr    r9,1
  946c9d:	41 21 f9             	and    r9d,edi
  946ca0:	48 8b bc 24 00 02 00 	mov    rdi,QWORD PTR [rsp+0x200]
  946ca7:	00 
  946ca8:	48 89 8c 24 80 05 00 	mov    QWORD PTR [rsp+0x580],rcx
  946caf:	00 
  946cb0:	48 c1 e9 3e          	shr    rcx,0x3e
  946cb4:	c4 e2 70 f2 8b c0 05 	andn   ecx,ecx,DWORD PTR [rbx+0x5c0]
  946cbb:	00 00 
  946cbd:	44 0b 8b 40 05 00 00 	or     r9d,DWORD PTR [rbx+0x540]
  946cc4:	c4 e1 f9 7e eb       	vmovq  rbx,xmm5
  946cc9:	62 e2 8d 40 7e d0    	vpermt2q zmm18,zmm30,zmm0
  946ccf:	62 b3 e5 40 71 c2 01 	vpshldq zmm0,zmm19,zmm18,0x1
  946cd6:	62 e1 fd 48 6f 54 24 	vmovdqa64 zmm18,ZMMWORD PTR [rsp+0x4c0]
  946cdd:	13 
  946cde:	62 21 fd 48 df fb    	vpandnq zmm31,zmm0,zmm19
  946ce4:	62 a3 ed 40 03 d3 01 	valignq zmm18,zmm18,zmm19,0x1
  946ceb:	62 a3 ed 40 71 d3 3f 	vpshldq zmm18,zmm18,zmm19,0x3f
  946cf2:	62 a1 ed 40 df d3    	vpandnq zmm18,zmm18,zmm19
  946cf8:	62 e1 fd 08 7e d2    	vmovq  rdx,xmm18
  946cfe:	c4 e2 c0 f2 d2       	andn   rdx,rdi,rdx
  946d03:	62 63 ed 00 22 f2 00 	vpinsrq xmm30,xmm18,rdx,0x0
  946d0a:	c4 e2 f8 f2 d3       	andn   rdx,rax,rbx
  946d0f:	62 e3 7d 08 16 cb 02 	vpextrd ebx,xmm17,0x2
  946d16:	62 a3 7d 48 39 d9 03 	vextracti32x4 xmm17,zmm19,0x3
  946d1d:	44 09 f3             	or     ebx,r14d
  946d20:	62 c3 fd 08 16 ce 01 	vpextrq r14,xmm17,0x1
  946d27:	62 03 6d 40 38 f6 00 	vinserti32x4 zmm30,zmm18,xmm30,0x0
  946d2e:	62 e3 d5 08 22 d2 00 	vpinsrq xmm18,xmm5,rdx,0x0
  946d35:	83 e3 07             	and    ebx,0x7
  946d38:	62 a3 55 48 38 d2 00 	vinserti32x4 zmm18,zmm5,xmm18,0x0
  946d3f:	0f 94 c2             	sete   dl
  946d42:	4d 85 f6             	test   r14,r14
  946d45:	40 0f 99 c7          	setns  dil
  946d49:	40 08 d7             	or     dil,dl
  946d4c:	40 80 ff 01          	cmp    dil,0x1
  946d50:	0f 85 f6 0e 00 00    	jne    947c4c <tokenize_c_raw_no_separators+0x2e7c>
  946d56:	62 f2 fd 48 27 c5    	vptestmq k0,zmm0,zmm5
  946d5c:	c5 fb 93 d0          	kmovd  edx,k0
  946d60:	84 d2                	test   dl,dl
  946d62:	0f 85 e4 0e 00 00    	jne    947c4c <tokenize_c_raw_no_separators+0x2e7c>
  946d68:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  946d6c:	62 a1 75 00 ef c9    	vpxord xmm17,xmm17,xmm17
  946d72:	31 db                	xor    ebx,ebx
  946d74:	48 c7 84 24 00 02 00 	mov    QWORD PTR [rsp+0x200],0x0
  946d7b:	00 00 00 00 00 
  946d80:	62 53 c5 48 25 dd fe 	vpternlogq zmm11,zmm7,zmm13,0xfe
  946d87:	62 f1 ed 48 df 54 24 	vpandnq zmm2,zmm2,ZMMWORD PTR [rsp+0x100]
  946d8e:	04 
  946d8f:	62 a1 b5 40 eb ff    	vporq  zmm23,zmm25,zmm23
  946d95:	62 93 d5 40 25 f4 fe 	vpternlogq zmm6,zmm21,zmm28,0xfe
  946d9c:	62 53 a5 48 25 e6 fe 	vpternlogq zmm12,zmm11,zmm14,0xfe
  946da3:	62 21 c5 40 eb ce    	vporq  zmm25,zmm23,zmm22
  946da9:	62 53 9d 48 25 d0 fe 	vpternlogq zmm10,zmm12,zmm8,0xfe
  946db0:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x4c0]
  946db7:	13 
  946db8:	62 93 f5 48 25 f1 fe 	vpternlogq zmm6,zmm1,zmm25,0xfe
  946dbf:	62 03 95 40 25 f9 fe 	vpternlogq zmm31,zmm29,zmm25,0xfe
  946dc6:	62 d3 85 48 25 f2 0d 	vpternlogq zmm6,zmm15,zmm10,0xd
  946dcd:	62 63 ed 40 25 fe fe 	vpternlogq zmm31,zmm18,zmm6,0xfe
  946dd4:	62 61 fd 08 7e fa    	vmovq  rdx,xmm31
  946dda:	c4 e2 f8 f2 d2       	andn   rdx,rax,rdx
  946ddf:	4c 89 c0             	mov    rax,r8
  946de2:	62 f3 85 00 22 c2 00 	vpinsrq xmm0,xmm31,rdx,0x0
  946de9:	62 f2 6d 48 27 c2    	vptestmd k0,zmm2,zmm2
  946def:	62 73 05 40 38 d0 00 	vinserti32x4 zmm10,zmm31,xmm0,0x0
  946df6:	c5 f8 98 c0          	kortestw k0,k0
  946dfa:	74 4e                	je     946e4a <tokenize_c_raw_no_separators+0x207a>
  946dfc:	4c 89 e2             	mov    rdx,r12
  946dff:	48 2b 94 24 98 00 00 	sub    rdx,QWORD PTR [rsp+0x98]
  946e06:	00 
  946e07:	48 8d bc 24 51 2c 00 	lea    rdi,[rsp+0x2c51]
  946e0e:	00 
  946e0f:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  946e13:	c5 fe 7f 47 0f       	vmovdqu YMMWORD PTR [rdi+0xf],ymm0
  946e18:	c5 fe 7f 07          	vmovdqu YMMWORD PTR [rdi],ymm0
  946e1c:	62 f1 fd 48 7f 94 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2bc0],zmm2
  946e23:	c0 2b 00 00 
  946e27:	62 71 fd 48 7f 94 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2c00],zmm10
  946e2e:	00 2c 00 00 
  946e32:	48 89 84 24 40 2c 00 	mov    QWORD PTR [rsp+0x2c40],rax
  946e39:	00 
  946e3a:	48 89 94 24 48 2c 00 	mov    QWORD PTR [rsp+0x2c48],rdx
  946e41:	00 
  946e42:	c6 84 24 50 2c 00 00 	mov    BYTE PTR [rsp+0x2c50],0x1
  946e49:	01 
  946e4a:	c5 79 7e c2          	vmovd  edx,xmm8
  946e4e:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  946e52:	62 f3 fd 48 03 c4 01 	valignq zmm0,zmm0,zmm4,0x1
  946e59:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  946e5f:	62 71 fd 48 6f 2d 97 	vmovdqa64 zmm13,ZMMWORD PTR [rip+0xffffffffffabfd97]        # 406c00 <__abi_tag+0x6044>
  946e66:	fd ab ff 
  946e69:	62 a3 ed 40 25 c8 f8 	vpternlogq zmm17,zmm18,zmm16,0xf8
  946e70:	62 51 95 40 db c9    	vpandq zmm9,zmm29,zmm9
  946e76:	62 71 fd 48 7f 54 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1140],zmm10
  946e7d:	45 
  946e7e:	62 52 fd 48 55 da    	vpopcntq zmm11,zmm10
  946e84:	41 09 d1             	or     r9d,edx
  946e87:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  946e8c:	41 09 c9             	or     r9d,ecx
  946e8f:	62 f3 fd 48 71 c4 3f 	vpshldq zmm0,zmm0,zmm4,0x3f
  946e96:	c4 c1 79 6e e1       	vmovd  xmm4,r9d
  946e9b:	62 f3 dd 48 03 e1 01 	valignq zmm4,zmm4,zmm1,0x1
  946ea2:	62 23 fd 48 25 dc fe 	vpternlogq zmm27,zmm0,zmm20,0xfe
  946ea9:	62 93 cd 40 71 c0 01 	vpshldq zmm0,zmm22,zmm24,0x1
  946eb0:	62 f3 dd 48 71 e1 3f 	vpshldq zmm4,zmm4,zmm1,0x3f
  946eb7:	62 93 a5 40 25 c2 fe 	vpternlogq zmm0,zmm27,zmm26,0xfe
  946ebe:	62 f1 dd 48 df e1    	vpandnq zmm4,zmm4,zmm1
  946ec4:	62 63 fd 48 25 f4 fe 	vpternlogq zmm30,zmm0,zmm4,0xfe
  946ecb:	62 93 ed 48 03 e7 07 	valignq zmm4,zmm2,zmm31,0x7
  946ed2:	62 f3 8d 40 25 f3 fe 	vpternlogq zmm6,zmm30,zmm3,0xfe
  946ed9:	62 f1 ad 48 eb da    	vporq  zmm3,zmm10,zmm2
  946edf:	c4 e1 f9 7e f1       	vmovq  rcx,xmm6
  946ee4:	48 0b 8c 24 e8 01 00 	or     rcx,QWORD PTR [rsp+0x1e8]
  946eeb:	00 
  946eec:	62 f3 ed 48 71 e4 01 	vpshldq zmm4,zmm2,zmm4,0x1
  946ef3:	c4 e3 c9 22 c1 00    	vpinsrq xmm0,xmm6,rcx,0x0
  946ef9:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
  946efe:	62 f3 4d 48 38 c0 00 	vinserti32x4 zmm0,zmm6,xmm0,0x0
  946f05:	c5 fa 7e b4 24 f0 01 	vmovq  xmm6,QWORD PTR [rsp+0x1f0]
  946f0c:	00 00 
  946f0e:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1180],zmm0
  946f15:	46 
  946f16:	62 72 fd 48 55 e0    	vpopcntq zmm12,zmm0
  946f1c:	62 f1 dd 48 eb e6    	vporq  zmm4,zmm4,zmm6
  946f22:	62 f3 e5 48 1e c4 01 	vpcmpltuq k0,zmm3,zmm4
  946f29:	62 f2 e5 48 29 cc    	vpcmpeqq k1,zmm3,zmm4
  946f2f:	62 f1 e5 48 fb e4    	vpsubq zmm4,zmm3,zmm4
  946f35:	c5 fd 4a c0          	kaddb  k0,k0,k0
  946f39:	c5 fd 4a c1          	kaddb  k0,k0,k1
  946f3d:	c5 fd 47 c1          	kxorb  k0,k0,k1
  946f41:	62 f2 fe 48 38 f0    	vpmovm2q zmm6,k0
  946f47:	62 f1 dd 48 d4 e6    	vpaddq zmm4,zmm4,zmm6
  946f4d:	62 d1 dd 48 df f2    	vpandnq zmm6,zmm4,zmm10
  946f53:	62 f1 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x11c0],zmm6
  946f5a:	47 
  946f5b:	62 61 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1200],zmm25
  946f62:	48 
  946f63:	62 e1 fd 48 7f 7c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1240],zmm23
  946f6a:	49 
  946f6b:	62 71 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1280],zmm9
  946f72:	4a 
  946f73:	62 f1 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x12c0],zmm5
  946f7a:	4b 
  946f7b:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1300],zmm17
  946f82:	4c 
  946f83:	62 c3 d5 48 25 c9 fe 	vpternlogq zmm17,zmm5,zmm9,0xfe
  946f8a:	62 71 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1340],zmm11
  946f91:	4d 
  946f92:	62 71 fd 48 7f 64 24 	vmovdqa64 ZMMWORD PTR [rsp+0x1380],zmm12
  946f99:	4e 
  946f9a:	48 89 94 24 c0 13 00 	mov    QWORD PTR [rsp+0x13c0],rdx
  946fa1:	00 
  946fa2:	48 89 84 24 c8 13 00 	mov    QWORD PTR [rsp+0x13c8],rax
  946fa9:	00 
  946faa:	62 b2 f5 40 27 c1    	vptestmq k0,zmm17,zmm17
  946fb0:	c5 79 93 c0          	kmovb  r8d,k0
  946fb4:	44 89 84 24 d0 13 00 	mov    DWORD PTR [rsp+0x13d0],r8d
  946fbb:	00 
  946fbc:	48 39 4c 24 68       	cmp    QWORD PTR [rsp+0x68],rcx
  946fc1:	0f 8d bb 29 00 00    	jge    949982 <tokenize_c_raw_no_separators+0x4bb2>
  946fc7:	b9 08 01 00 00       	mov    ecx,0x108
  946fcc:	49 89 c1             	mov    r9,rax
  946fcf:	62 f3 7d 48 39 d0 03 	vextracti32x4 xmm0,zmm2,0x3
  946fd6:	49 c1 fb 3f          	sar    r11,0x3f
  946fda:	62 72 7d 48 5a 05 5c 	vbroadcasti32x4 zmm8,XMMWORD PTR [rip+0xffffffffffae3d5c]        # 42ad40 <c_testsuite_feature.marker+0x83c>
  946fe1:	3d ae ff 
  946fe4:	62 71 fd 48 6f 4c 24 	vmovdqa64 zmm9,ZMMWORD PTR [rsp+0xa80]
  946feb:	2a 
  946fec:	62 71 fd 48 6f 15 4a 	vmovdqa64 zmm10,ZMMWORD PTR [rip+0xffffffffffabfb4a]        # 406b40 <__abi_tag+0x5f84>
  946ff3:	fb ab ff 
  946ff6:	62 71 fd 48 6f 1d 80 	vmovdqa64 zmm11,ZMMWORD PTR [rip+0xffffffffffabfb80]        # 406b80 <__abi_tag+0x5fc4>
  946ffd:	fb ab ff 
  947000:	62 71 fd 48 6f 25 b6 	vmovdqa64 zmm12,ZMMWORD PTR [rip+0xffffffffffabfbb6]        # 406bc0 <__abi_tag+0x6004>
  947007:	fb ab ff 
  94700a:	62 72 7d 48 5a 35 3c 	vbroadcasti32x4 zmm14,XMMWORD PTR [rip+0xffffffffffae3d3c]        # 42ad50 <c_testsuite_feature.marker+0x84c>
  947011:	3d ae ff 
  947014:	62 72 7d 48 5a 3d 42 	vbroadcasti32x4 zmm15,XMMWORD PTR [rip+0xffffffffffae3d42]        # 42ad60 <c_testsuite_feature.marker+0x85c>
  94701b:	3d ae ff 
  94701e:	62 e2 7d 48 5a 05 48 	vbroadcasti32x4 zmm16,XMMWORD PTR [rip+0xffffffffffae3d48]        # 42ad70 <c_testsuite_feature.marker+0x86c>
  947025:	3d ae ff 
  947028:	62 e2 7d 48 5a 0d 4e 	vbroadcasti32x4 zmm17,XMMWORD PTR [rip+0xffffffffffae3d4e]        # 42ad80 <c_testsuite_feature.marker+0x87c>
  94702f:	3d ae ff 
  947032:	62 e2 7d 48 5a 15 54 	vbroadcasti32x4 zmm18,XMMWORD PTR [rip+0xffffffffffae3d54]        # 42ad90 <c_testsuite_feature.marker+0x88c>
  947039:	3d ae ff 
  94703c:	62 e2 7d 48 5a 1d 5a 	vbroadcasti32x4 zmm19,XMMWORD PTR [rip+0xffffffffffae3d5a]        # 42ada0 <c_testsuite_feature.marker+0x89c>
  947043:	3d ae ff 
  947046:	62 e1 fd 48 6f 25 70 	vmovdqa64 zmm20,ZMMWORD PTR [rip+0xffffffffffabfd70]        # 406dc0 <__abi_tag+0x6204>
  94704d:	fd ab ff 
  947050:	62 e2 7d 48 5a 2d 56 	vbroadcasti32x4 zmm21,XMMWORD PTR [rip+0xffffffffffae3d56]        # 42adb0 <c_testsuite_feature.marker+0x8ac>
  947057:	3d ae ff 
  94705a:	62 e2 7d 48 5a 35 5c 	vbroadcasti32x4 zmm22,XMMWORD PTR [rip+0xffffffffffae3d5c]        # 42adc0 <c_testsuite_feature.marker+0x8bc>
  947061:	3d ae ff 
  947064:	62 e2 7d 48 5a 3d 62 	vbroadcasti32x4 zmm23,XMMWORD PTR [rip+0xffffffffffae3d62]        # 42add0 <c_testsuite_feature.marker+0x8cc>
  94706b:	3d ae ff 
  94706e:	62 62 7d 48 5a 05 68 	vbroadcasti32x4 zmm24,XMMWORD PTR [rip+0xffffffffffae3d68]        # 42ade0 <c_testsuite_feature.marker+0x8dc>
  947075:	3d ae ff 
  947078:	62 61 fd 48 6f 4c 24 	vmovdqa64 zmm25,ZMMWORD PTR [rsp+0x500]
  94707f:	14 
  947080:	62 61 fd 48 6f 54 24 	vmovdqa64 zmm26,ZMMWORD PTR [rsp+0x640]
  947087:	19 
  947088:	62 61 fd 48 6f 25 ee 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffac00ee]        # 407180 <__abi_tag+0x65c4>
  94708f:	00 ac ff 
  947092:	4c 89 b4 24 40 03 00 	mov    QWORD PTR [rsp+0x340],r14
  947099:	00 
  94709a:	4c 89 8c 24 c0 04 00 	mov    QWORD PTR [rsp+0x4c0],r9
  9470a1:	00 
  9470a2:	48 89 9c 24 f8 01 00 	mov    QWORD PTR [rsp+0x1f8],rbx
  9470a9:	00 
  9470aa:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  9470b1:	c4 e2 70 f7 c6       	bextr  eax,esi,ecx
  9470b6:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  9470bc:	62 f3 7d 48 39 e0 03 	vextracti32x4 xmm0,zmm4,0x3
  9470c3:	48 8b b4 24 a8 00 00 	mov    rsi,QWORD PTR [rsp+0xa8]
  9470ca:	00 
  9470cb:	48 89 84 24 c0 05 00 	mov    QWORD PTR [rsp+0x5c0],rax
  9470d2:	00 
  9470d3:	48 8b 84 24 80 07 00 	mov    rax,QWORD PTR [rsp+0x780]
  9470da:	00 
  9470db:	48 89 74 24 58       	mov    QWORD PTR [rsp+0x58],rsi
  9470e0:	44 21 d8             	and    eax,r11d
  9470e3:	49 89 d3             	mov    r11,rdx
  9470e6:	c4 e3 f9 16 c2 01    	vpextrq rdx,xmm0,0x1
  9470ec:	62 f3 7d 48 39 d8 03 	vextracti32x4 xmm0,zmm3,0x3
  9470f3:	c4 e3 f9 16 c7 01    	vpextrq rdi,xmm0,0x1
  9470f9:	48 89 84 24 80 07 00 	mov    QWORD PTR [rsp+0x780],rax
  947100:	00 
  947101:	62 f3 7d 48 39 c8 03 	vextracti32x4 xmm0,zmm1,0x3
  947108:	62 f3 7d 48 39 f9 03 	vextracti32x4 xmm1,zmm7,0x3
  94710f:	62 f2 7d 48 5a 3d 17 	vbroadcasti32x4 zmm7,XMMWORD PTR [rip+0xffffffffffae3c17]        # 42ad30 <c_testsuite_feature.marker+0x82c>
  947116:	3c ae ff 
  947119:	c4 e2 c0 f2 c2       	andn   rax,rdi,rdx
  94711e:	48 8b 54 24 38       	mov    rdx,QWORD PTR [rsp+0x38]
  947123:	48 8b bc 24 f8 03 00 	mov    rdi,QWORD PTR [rsp+0x3f8]
  94712a:	00 
  94712b:	c4 e3 f9 16 84 24 40 	vpextrq QWORD PTR [rsp+0x440],xmm0,0x1
  947132:	04 00 00 01 
  947136:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x540]
  94713d:	15 
  94713e:	48 09 c8             	or     rax,rcx
  947141:	48 8b 8c 24 b0 00 00 	mov    rcx,QWORD PTR [rsp+0xb0]
  947148:	00 
  947149:	48 c1 e8 3f          	shr    rax,0x3f
  94714d:	48 89 84 24 f0 01 00 	mov    QWORD PTR [rsp+0x1f0],rax
  947154:	00 
  947155:	48 8b 84 24 40 02 00 	mov    rax,QWORD PTR [rsp+0x240]
  94715c:	00 
  94715d:	48 83 f7 01          	xor    rdi,0x1
  947161:	48 81 c2 00 02 00 00 	add    rdx,0x200
  947168:	49 89 ce             	mov    r14,rcx
  94716b:	49 83 fe 02          	cmp    r14,0x2
  94716f:	48 8d 49 01          	lea    rcx,[rcx+0x1]
  947173:	41 be 00 00 00 00    	mov    r14d,0x0
  947179:	48 89 fe             	mov    rsi,rdi
  94717c:	4c 0f 45 f1          	cmovne r14,rcx
  947180:	48 81 84 24 d0 01 00 	add    QWORD PTR [rsp+0x1d0],0xfffffffffffffe00
  947187:	00 00 fe ff ff 
  94718c:	48 81 84 24 d8 01 00 	add    QWORD PTR [rsp+0x1d8],0xfffffffffffffe00
  947193:	00 00 fe ff ff 
  947198:	48 81 84 24 c8 01 00 	add    QWORD PTR [rsp+0x1c8],0xfffffffffffffe00
  94719f:	00 00 fe ff ff 
  9471a4:	48 81 84 24 c0 01 00 	add    QWORD PTR [rsp+0x1c0],0x200
  9471ab:	00 00 02 00 00 
  9471b0:	48 81 84 24 b8 01 00 	add    QWORD PTR [rsp+0x1b8],0x200
  9471b7:	00 00 02 00 00 
  9471bc:	48 81 84 24 b0 01 00 	add    QWORD PTR [rsp+0x1b0],0x200
  9471c3:	00 00 02 00 00 
  9471c8:	48 81 84 24 a8 01 00 	add    QWORD PTR [rsp+0x1a8],0x200
  9471cf:	00 00 02 00 00 
  9471d4:	48 81 84 24 a0 01 00 	add    QWORD PTR [rsp+0x1a0],0x200
  9471db:	00 00 02 00 00 
  9471e0:	48 81 84 24 98 01 00 	add    QWORD PTR [rsp+0x198],0x200
  9471e7:	00 00 02 00 00 
  9471ec:	48 81 84 24 90 01 00 	add    QWORD PTR [rsp+0x190],0x200
  9471f3:	00 00 02 00 00 
  9471f8:	48 81 84 24 88 01 00 	add    QWORD PTR [rsp+0x188],0x200
  9471ff:	00 00 02 00 00 
  947204:	49 81 c5 00 02 00 00 	add    r13,0x200
  94720b:	b1 01                	mov    cl,0x1
  94720d:	62 f3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm0,0x3
  947214:	48 89 84 24 e8 01 00 	mov    QWORD PTR [rsp+0x1e8],rax
  94721b:	00 
  94721c:	8b 44 24 60          	mov    eax,DWORD PTR [rsp+0x60]
  947220:	4c 89 b4 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],r14
  947227:	00 
  947228:	48 89 44 24 60       	mov    QWORD PTR [rsp+0x60],rax
  94722d:	c5 f1 6d c0          	vpunpckhqdq xmm0,xmm1,xmm0
  947231:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x540],zmm0
  947238:	15 
  947239:	e9 92 e2 ff ff       	jmp    9454d0 <tokenize_c_raw_no_separators+0x700>
  94723e:	48 c7 84 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],0x0
  947245:	00 00 00 00 00 
  94724a:	31 c9                	xor    ecx,ecx
  94724c:	e9 a1 f9 ff ff       	jmp    946bf2 <tokenize_c_raw_no_separators+0x1e22>
  947251:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  947256:	49 c7 c0 ff ff ff ff 	mov    r8,0xffffffffffffffff
  94725d:	48 c7 c1 ff ff ff ff 	mov    rcx,0xffffffffffffffff
  947264:	4c 29 cf             	sub    rdi,r9
  947267:	48 85 ff             	test   rdi,rdi
  94726a:	0f 8e ad 17 00 00    	jle    948a1d <tokenize_c_raw_no_separators+0x3c4d>
  947270:	48 83 ff 3f          	cmp    rdi,0x3f
  947274:	0f 86 9b 17 00 00    	jbe    948a15 <tokenize_c_raw_no_separators+0x3c45>
  94727a:	31 c9                	xor    ecx,ecx
  94727c:	e9 9c 17 00 00       	jmp    948a1d <tokenize_c_raw_no_separators+0x3c4d>
  947281:	62 e3 7d 28 39 c0 01 	vextracti32x4 xmm0,ymm16,0x1
  947288:	62 f1 fd 48 7f 64 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2c0],zmm4
  94728f:	0b 
  947290:	62 f1 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x400],zmm3
  947297:	10 
  947298:	c4 e3 79 16 c1 02    	vpextrd ecx,xmm0,0x2
  94729e:	44 21 f1             	and    ecx,r14d
  9472a1:	c5 f9 6e c1          	vmovd  xmm0,ecx
  9472a5:	62 f3 fd 48 03 c1 01 	valignq zmm0,zmm0,zmm1,0x1
  9472ac:	62 f3 fd 48 71 c1 3f 	vpshldq zmm0,zmm0,zmm1,0x3f
  9472b3:	62 61 fd 48 db ea    	vpandq zmm29,zmm0,zmm2
  9472b9:	48 85 c0             	test   rax,rax
  9472bc:	0f 85 9a 19 00 00    	jne    948c5c <tokenize_c_raw_no_separators+0x3e8c>
  9472c2:	62 92 95 40 27 c5    	vptestmq k0,zmm29,zmm29
  9472c8:	c4 41 09 ef f6       	vpxor  xmm14,xmm14,xmm14
  9472cd:	c5 fb 93 c0          	kmovd  eax,k0
  9472d1:	84 c0                	test   al,al
  9472d3:	0f 85 83 19 00 00    	jne    948c5c <tokenize_c_raw_no_separators+0x3e8c>
  9472d9:	c4 41 01 ef ff       	vpxor  xmm15,xmm15,xmm15
  9472de:	62 e3 7d 28 39 c0 01 	vextracti32x4 xmm0,ymm16,0x1
  9472e5:	62 f3 fd 48 03 c7 01 	valignq zmm0,zmm0,zmm7,0x1
  9472ec:	62 f3 fd 48 71 c7 3f 	vpshldq zmm0,zmm0,zmm7,0x3f
  9472f3:	62 f1 fd 48 db ca    	vpandq zmm1,zmm0,zmm2
  9472f9:	62 f2 75 48 27 c1    	vptestmd k0,zmm1,zmm1
  9472ff:	c5 f8 98 c0          	kortestw k0,k0
  947303:	0f 85 43 20 00 00    	jne    94934c <tokenize_c_raw_no_separators+0x457c>
  947309:	c5 fa 7e 8c 24 a0 00 	vmovq  xmm1,QWORD PTR [rsp+0xa0]
  947310:	00 00 
  947312:	62 f2 fd 48 59 25 dc 	vpbroadcastq zmm4,QWORD PTR [rip+0xffffffffffc853dc]        # 5cc6f8 <x86_effects_unknown+0x288>
  947319:	53 c8 ff 
  94731c:	62 f1 95 40 ef c2    	vpxorq zmm0,zmm29,zmm2
  947322:	48 8b 7c 24 68       	mov    rdi,QWORD PTR [rsp+0x68]
  947327:	4c 8b 44 24 60       	mov    r8,QWORD PTR [rsp+0x60]
  94732c:	62 f1 f5 48 df d0    	vpandnq zmm2,zmm1,zmm0
  947332:	62 93 ed 48 03 df 07 	valignq zmm3,zmm2,zmm31,0x7
  947339:	62 f3 ed 48 71 db 01 	vpshldq zmm3,zmm2,zmm3,0x1
  947340:	62 f1 e5 48 eb dc    	vporq  zmm3,zmm3,zmm4
  947346:	62 f3 e5 48 1e c2 01 	vpcmpltuq k0,zmm3,zmm2
  94734d:	62 f2 e5 48 29 ca    	vpcmpeqq k1,zmm3,zmm2
  947353:	62 f1 e5 48 fb d2    	vpsubq zmm2,zmm3,zmm2
  947359:	c5 fd 4a c0          	kaddb  k0,k0,k0
  94735d:	c5 fd 4a c1          	kaddb  k0,k0,k1
  947361:	c5 fd 47 c1          	kxorb  k0,k0,k1
  947365:	62 f2 fe 48 38 d8    	vpmovm2q zmm3,k0
  94736b:	62 f1 ed 48 d4 d3    	vpaddq zmm2,zmm2,zmm3
  947371:	62 f1 ed 48 ef d4    	vpxorq zmm2,zmm2,zmm4
  947377:	62 f3 7d 48 39 c4 03 	vextracti32x4 xmm4,zmm0,0x3
  94737e:	62 f3 7d 48 39 d3 03 	vextracti32x4 xmm3,zmm2,0x3
  947385:	62 f3 fd 48 25 d1 e1 	vpternlogq zmm2,zmm0,zmm1,0xe1
  94738c:	c5 e1 db dc          	vpand  xmm3,xmm3,xmm4
  947390:	62 f1 fd 48 6f 64 24 	vmovdqa64 zmm4,ZMMWORD PTR [rsp+0x2c0]
  947397:	0b 
  947398:	c4 e3 f9 16 d8 01    	vpextrq rax,xmm3,0x1
  94739e:	62 f1 fd 48 6f 5c 24 	vmovdqa64 zmm3,ZMMWORD PTR [rsp+0x400]
  9473a5:	10 
  9473a6:	48 c1 e8 3f          	shr    rax,0x3f
  9473aa:	48 89 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rax
  9473b1:	00 
  9473b2:	e9 e6 ed ff ff       	jmp    94619d <tokenize_c_raw_no_separators+0x13cd>
  9473b7:	62 f3 7d 48 39 e8 03 	vextracti32x4 xmm0,zmm5,0x3
  9473be:	b8 ff 01 00 00       	mov    eax,0x1ff
  9473c3:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  9473c9:	48 85 c9             	test   rcx,rcx
  9473cc:	0f 85 83 00 00 00    	jne    947455 <tokenize_c_raw_no_separators+0x2685>
  9473d2:	c4 e1 f9 7e c1       	vmovq  rcx,xmm0
  9473d7:	b8 bf 01 00 00       	mov    eax,0x1bf
  9473dc:	48 85 c9             	test   rcx,rcx
  9473df:	75 74                	jne    947455 <tokenize_c_raw_no_separators+0x2685>
  9473e1:	62 f3 7d 48 39 e8 02 	vextracti32x4 xmm0,zmm5,0x2
  9473e8:	b8 7f 01 00 00       	mov    eax,0x17f
  9473ed:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  9473f3:	48 85 c9             	test   rcx,rcx
  9473f6:	75 5d                	jne    947455 <tokenize_c_raw_no_separators+0x2685>
  9473f8:	c4 e1 f9 7e c1       	vmovq  rcx,xmm0
  9473fd:	b8 3f 01 00 00       	mov    eax,0x13f
  947402:	48 85 c9             	test   rcx,rcx
  947405:	75 4e                	jne    947455 <tokenize_c_raw_no_separators+0x2685>
  947407:	c4 e3 7d 39 e8 01    	vextracti128 xmm0,ymm5,0x1
  94740d:	b8 ff 00 00 00       	mov    eax,0xff
  947412:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  947418:	48 85 c9             	test   rcx,rcx
  94741b:	75 38                	jne    947455 <tokenize_c_raw_no_separators+0x2685>
  94741d:	c4 e3 7d 39 e8 01    	vextracti128 xmm0,ymm5,0x1
  947423:	b8 bf 00 00 00       	mov    eax,0xbf
  947428:	c4 e1 f9 7e c1       	vmovq  rcx,xmm0
  94742d:	48 85 c9             	test   rcx,rcx
  947430:	75 23                	jne    947455 <tokenize_c_raw_no_separators+0x2685>
  947432:	c4 e3 f9 16 e9 01    	vpextrq rcx,xmm5,0x1
  947438:	b8 7f 00 00 00       	mov    eax,0x7f
  94743d:	48 85 c9             	test   rcx,rcx
  947440:	75 13                	jne    947455 <tokenize_c_raw_no_separators+0x2685>
  947442:	c4 e1 f9 7e e9       	vmovq  rcx,xmm5
  947447:	b8 3f 00 00 00       	mov    eax,0x3f
  94744c:	48 85 c9             	test   rcx,rcx
  94744f:	0f 84 e1 1f 00 00    	je     949436 <tokenize_c_raw_no_separators+0x4666>
  947455:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0xc0]
  94745c:	03 
  94745d:	f3 48 0f bd c9       	lzcnt  rcx,rcx
  947462:	29 c8                	sub    eax,ecx
  947464:	89 c1                	mov    ecx,eax
  947466:	c1 e8 06             	shr    eax,0x6
  947469:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0xb40],zmm0
  947470:	2d 
  947471:	48 8b 84 c4 40 0b 00 	mov    rax,QWORD PTR [rsp+rax*8+0xb40]
  947478:	00 
  947479:	48 0f a3 c8          	bt     rax,rcx
  94747d:	0f 93 c0             	setae  al
  947480:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
  947485:	62 63 7d 48 39 e8 03 	vextracti32x4 xmm0,zmm29,0x3
  94748c:	c4 e3 f9 16 c1 01    	vpextrq rcx,xmm0,0x1
  947492:	48 85 c9             	test   rcx,rcx
  947495:	0f 88 73 15 00 00    	js     948a0e <tokenize_c_raw_no_separators+0x3c3e>
  94749b:	48 83 bc 24 80 02 00 	cmp    QWORD PTR [rsp+0x280],0x0
  9474a2:	00 00 
  9474a4:	0f 88 5b 17 00 00    	js     948c05 <tokenize_c_raw_no_separators+0x3e35>
  9474aa:	31 c9                	xor    ecx,ecx
  9474ac:	e9 71 17 00 00       	jmp    948c22 <tokenize_c_raw_no_separators+0x3e52>
  9474b1:	48 8b 4c 24 58       	mov    rcx,QWORD PTR [rsp+0x58]
  9474b6:	62 62 7d 48 5a 15 50 	vbroadcasti32x4 zmm26,XMMWORD PTR [rip+0xffffffffffae3950]        # 42ae10 <c_testsuite_feature.marker+0x90c>
  9474bd:	39 ae ff 
  9474c0:	62 62 7d 48 5a 0d 56 	vbroadcasti32x4 zmm25,XMMWORD PTR [rip+0xffffffffffae3956]        # 42ae20 <c_testsuite_feature.marker+0x91c>
  9474c7:	39 ae ff 
  9474ca:	62 62 7d 48 5a 3d 5c 	vbroadcasti32x4 zmm31,XMMWORD PTR [rip+0xffffffffffae395c]        # 42ae30 <c_testsuite_feature.marker+0x92c>
  9474d1:	39 ae ff 
  9474d4:	44 89 b4 24 80 05 00 	mov    DWORD PTR [rsp+0x580],r14d
  9474db:	00 
  9474dc:	4d 89 ce             	mov    r14,r9
  9474df:	62 f1 fd 48 6f 01    	vmovdqa64 zmm0,ZMMWORD PTR [rcx]
  9474e5:	62 e1 fd 48 6f 41 01 	vmovdqa64 zmm16,ZMMWORD PTR [rcx+0x40]
  9474ec:	62 e1 fd 48 6f 59 02 	vmovdqa64 zmm19,ZMMWORD PTR [rcx+0x80]
  9474f3:	62 e1 fd 48 6f 61 03 	vmovdqa64 zmm20,ZMMWORD PTR [rcx+0xc0]
  9474fa:	62 71 fd 48 6f 41 04 	vmovdqa64 zmm8,ZMMWORD PTR [rcx+0x100]
  947501:	62 61 fd 48 6f 61 05 	vmovdqa64 zmm28,ZMMWORD PTR [rcx+0x140]
  947508:	62 81 fd 48 db ea    	vpandq zmm21,zmm0,zmm26
  94750e:	62 91 7d 48 74 cf    	vpcmpeqb k1,zmm0,zmm31
  947514:	62 91 fd 40 db c2    	vpandq zmm0,zmm16,zmm26
  94751a:	62 91 55 40 74 c1    	vpcmpeqb k0,zmm21,zmm25
  947520:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  947525:	62 91 7d 40 74 cf    	vpcmpeqb k1,zmm16,zmm31
  94752b:	62 81 bd 48 db c2    	vpandq zmm16,zmm8,zmm26
  947531:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947536:	62 91 7d 48 74 c1    	vpcmpeqb k0,zmm0,zmm25
  94753c:	62 91 e5 40 db c2    	vpandq zmm0,zmm19,zmm26
  947542:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  947547:	48 89 94 24 40 05 00 	mov    QWORD PTR [rsp+0x540],rdx
  94754e:	00 
  94754f:	62 91 65 40 74 cf    	vpcmpeqb k1,zmm19,zmm31
  947555:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  94755a:	62 91 7d 48 74 c1    	vpcmpeqb k0,zmm0,zmm25
  947560:	62 91 dd 40 db c2    	vpandq zmm0,zmm20,zmm26
  947566:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  94756b:	48 89 94 24 c0 05 00 	mov    QWORD PTR [rsp+0x5c0],rdx
  947572:	00 
  947573:	62 91 5d 40 74 cf    	vpcmpeqb k1,zmm20,zmm31
  947579:	62 e1 fe 08 7e a4 24 	vmovq  xmm20,QWORD PTR [rsp+0x540]
  947580:	40 05 00 00 
  947584:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947589:	62 91 7d 48 74 c1    	vpcmpeqb k0,zmm0,zmm25
  94758f:	62 f1 fd 48 6f 41 07 	vmovdqa64 zmm0,ZMMWORD PTR [rcx+0x1c0]
  947596:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  94759b:	62 91 3d 48 74 cf    	vpcmpeqb k1,zmm8,zmm31
  9475a1:	62 71 fd 48 6f 41 06 	vmovdqa64 zmm8,ZMMWORD PTR [rcx+0x180]
  9475a8:	48 89 94 24 00 01 00 	mov    QWORD PTR [rsp+0x100],rdx
  9475af:	00 
  9475b0:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  9475b5:	62 91 7d 40 74 c1    	vpcmpeqb k0,zmm16,zmm25
  9475bb:	62 81 9d 40 db c2    	vpandq zmm16,zmm28,zmm26
  9475c1:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  9475c6:	62 91 1d 40 74 cf    	vpcmpeqb k1,zmm28,zmm31
  9475cc:	48 89 94 24 40 02 00 	mov    QWORD PTR [rsp+0x240],rdx
  9475d3:	00 
  9475d4:	c4 61 fb 93 c8       	kmovq  r9,k0
  9475d9:	62 91 7d 40 74 c1    	vpcmpeqb k0,zmm16,zmm25
  9475df:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  9475e4:	62 c1 fd 08 6e d9    	vmovq  xmm19,r9
  9475ea:	4d 89 f1             	mov    r9,r14
  9475ed:	44 8b b4 24 80 05 00 	mov    r14d,DWORD PTR [rsp+0x580]
  9475f4:	00 
  9475f5:	c4 61 fb 93 c0       	kmovq  r8,k0
  9475fa:	62 81 bd 48 db c2    	vpandq zmm16,zmm8,zmm26
  947600:	62 91 3d 48 74 cf    	vpcmpeqb k1,zmm8,zmm31
  947606:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x4c0]
  94760d:	13 
  94760e:	62 91 7d 40 74 c1    	vpcmpeqb k0,zmm16,zmm25
  947614:	62 81 fd 48 db c2    	vpandq zmm16,zmm0,zmm26
  94761a:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  94761f:	62 91 7d 48 74 cf    	vpcmpeqb k1,zmm0,zmm31
  947625:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  94762a:	62 91 7d 40 74 c1    	vpcmpeqb k0,zmm16,zmm25
  947630:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  947635:	62 e1 fd 08 6e c2    	vmovq  xmm16,rdx
  94763b:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  947640:	c4 e1 f9 6e c7       	vmovq  xmm0,rdi
  947645:	62 f1 fd 00 6c c0    	vpunpcklqdq xmm0,xmm16,xmm0
  94764b:	62 c1 fd 08 6e c0    	vmovq  xmm16,r8
  947651:	62 a1 e5 00 6c c0    	vpunpcklqdq xmm16,xmm19,xmm16
  947657:	62 e1 fe 08 7e 5c 24 	vmovq  xmm19,QWORD PTR [rsp+0x100]
  94765e:	20 
  94765f:	62 f3 7d 20 38 c0 01 	vinserti32x4 ymm0,ymm16,xmm0,0x1
  947666:	62 e1 fe 08 7e 44 24 	vmovq  xmm16,QWORD PTR [rsp+0x240]
  94766d:	48 
  94766e:	62 a1 e5 00 6c c0    	vpunpcklqdq xmm16,xmm19,xmm16
  947674:	62 e1 fe 08 7e 9c 24 	vmovq  xmm19,QWORD PTR [rsp+0x5c0]
  94767b:	c0 05 00 00 
  94767f:	62 a1 dd 00 6c db    	vpunpcklqdq xmm19,xmm20,xmm19
  947685:	62 e1 fd 48 6f 61 08 	vmovdqa64 zmm20,ZMMWORD PTR [rcx+0x200]
  94768c:	62 a3 65 20 38 c0 01 	vinserti32x4 ymm16,ymm19,xmm16,0x1
  947693:	62 f3 fd 40 3a c0 01 	vinserti64x4 zmm0,zmm16,ymm0,0x1
  94769a:	62 c3 fd 48 00 c0 ff 	vpermq zmm16,zmm8,0xff
  9476a1:	62 a3 7d 48 39 c0 02 	vextracti32x4 xmm16,zmm16,0x2
  9476a8:	62 f1 8d 48 eb c0    	vporq  zmm0,zmm14,zmm0
  9476ae:	62 a1 f5 00 eb c0    	vporq  xmm16,xmm17,xmm16
  9476b4:	62 d3 a5 40 25 c4 fe 	vpternlogq zmm0,zmm27,zmm12,0xfe
  9476bb:	62 e3 7d 08 16 c2 02 	vpextrd edx,xmm16,0x2
  9476c2:	62 81 dd 40 db da    	vpandq zmm19,zmm20,zmm26
  9476c8:	62 91 5d 40 74 cf    	vpcmpeqb k1,zmm20,zmm31
  9476ce:	62 91 65 40 74 c1    	vpcmpeqb k0,zmm19,zmm25
  9476d4:	62 33 7d 48 39 c3 03 	vextracti32x4 xmm19,zmm8,0x3
  9476db:	c4 e1 f4 45 c0       	korq   k0,k1,k0
  9476e0:	62 c1 fd 08 7e d8    	vmovq  r8,xmm19
  9476e6:	44 89 c7             	mov    edi,r8d
  9476e9:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  9476ee:	09 d7                	or     edi,edx
  9476f0:	09 cf                	or     edi,ecx
  9476f2:	62 e1 7d 08 6e c7    	vmovd  xmm16,edi
  9476f8:	4c 89 c7             	mov    rdi,r8
  9476fb:	62 e3 fd 40 03 c0 01 	valignq zmm16,zmm16,zmm0,0x1
  947702:	62 f3 fd 40 71 c0 3f 	vpshldq zmm0,zmm16,zmm0,0x3f
  947709:	62 92 7d 48 27 c5    	vptestmd k0,zmm0,zmm29
  94770f:	c5 f8 98 c0          	kortestw k0,k0
  947713:	0f 84 aa f2 ff ff    	je     9469c3 <tokenize_c_raw_no_separators+0x1bf3>
  947719:	e9 eb 22 00 00       	jmp    949a09 <tokenize_c_raw_no_separators+0x4c39>
  94771e:	40 0f b6 ce          	movzx  ecx,sil
  947722:	62 f3 7d 48 39 e8 03 	vextracti32x4 xmm0,zmm5,0x3
  947729:	62 b3 7d 48 39 eb 02 	vextracti32x4 xmm19,zmm5,0x2
  947730:	c4 c3 7d 39 e8 01    	vextracti128 xmm8,ymm5,0x1
  947736:	45 31 c0             	xor    r8d,r8d
  947739:	4c 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],r9
  94773e:	c4 e3 f9 16 ac 24 80 	vpextrq QWORD PTR [rsp+0x80],xmm5,0x1
  947745:	00 00 00 01 
  947749:	c5 f9 d6 6c 24 70    	vmovq  QWORD PTR [rsp+0x70],xmm5
  94774f:	c7 84 24 c0 00 00 00 	mov    DWORD PTR [rsp+0xc0],0x0
  947756:	00 00 00 00 
  94775a:	83 e1 01             	and    ecx,0x1
  94775d:	c4 e3 f9 16 84 24 40 	vpextrq QWORD PTR [rsp+0x540],xmm0,0x1
  947764:	05 00 00 01 
  947768:	c5 f9 d6 84 24 00 01 	vmovq  QWORD PTR [rsp+0x100],xmm0
  94776f:	00 00 
  947771:	62 e3 fd 08 16 5c 24 	vpextrq QWORD PTR [rsp+0x240],xmm19,0x1
  947778:	48 01 
  94777a:	62 e1 fd 08 d6 5c 24 	vmovq  QWORD PTR [rsp+0x300],xmm19
  947781:	60 
  947782:	c4 63 f9 16 84 24 c0 	vpextrq QWORD PTR [rsp+0x2c0],xmm8,0x1
  947789:	02 00 00 01 
  94778d:	c5 79 d6 84 24 00 04 	vmovq  QWORD PTR [rsp+0x400],xmm8
  947794:	00 00 
  947796:	48 89 8c 24 80 03 00 	mov    QWORD PTR [rsp+0x380],rcx
  94779d:	00 
  94779e:	eb 15                	jmp    9477b5 <tokenize_c_raw_no_separators+0x29e5>
  9477a0:	48 8b bc 24 c0 05 00 	mov    rdi,QWORD PTR [rsp+0x5c0]
  9477a7:	00 
  9477a8:	41 ff c0             	inc    r8d
  9477ab:	41 83 f8 09          	cmp    r8d,0x9
  9477af:	0f 84 68 04 00 00    	je     947c1d <tokenize_c_raw_no_separators+0x2e4d>
  9477b5:	62 f1 fd 48 7f 64 24 	vmovdqa64 ZMMWORD PTR [rsp+0xb00],zmm4
  9477bc:	2c 
  9477bd:	4c 8b 8c 24 80 03 00 	mov    r9,QWORD PTR [rsp+0x380]
  9477c4:	00 
  9477c5:	41 83 f8 08          	cmp    r8d,0x8
  9477c9:	74 0e                	je     9477d9 <tokenize_c_raw_no_separators+0x2a09>
  9477cb:	44 89 c1             	mov    ecx,r8d
  9477ce:	83 e1 07             	and    ecx,0x7
  9477d1:	4c 8b 8c cc 00 0b 00 	mov    r9,QWORD PTR [rsp+rcx*8+0xb00]
  9477d8:	00 
  9477d9:	4d 85 c9             	test   r9,r9
  9477dc:	74 c2                	je     9477a0 <tokenize_c_raw_no_separators+0x29d0>
  9477de:	44 89 c1             	mov    ecx,r8d
  9477e1:	c1 e1 06             	shl    ecx,0x6
  9477e4:	48 89 8c 24 80 05 00 	mov    QWORD PTR [rsp+0x580],rcx
  9477eb:	00 
  9477ec:	eb 3c                	jmp    94782a <tokenize_c_raw_no_separators+0x2a5a>
  9477ee:	66 90                	xchg   ax,ax
  9477f0:	89 ca                	mov    edx,ecx
  9477f2:	c1 e9 06             	shr    ecx,0x6
  9477f5:	62 e1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0xac0],zmm16
  9477fc:	2b 
  9477fd:	62 f2 fd 48 7c c1    	vpbroadcastq zmm0,rcx
  947803:	62 f2 fd 48 29 0d f3 	vpcmpeqq k1,zmm0,ZMMWORD PTR [rip+0xffffffffffabf9f3]        # 407200 <__abi_tag+0x6644>
  94780a:	f9 ab ff 
  94780d:	48 8b bc cc c0 0a 00 	mov    rdi,QWORD PTR [rsp+rcx*8+0xac0]
  947814:	00 
  947815:	48 0f ab d7          	bts    rdi,rdx
  947819:	62 e2 fd 49 7c c7    	vpbroadcastq zmm16{k1},rdi
  94781f:	c4 c2 b0 f3 c9       	blsr   r9,r9
  947824:	0f 84 76 ff ff ff    	je     9477a0 <tokenize_c_raw_no_separators+0x29d0>
  94782a:	31 ff                	xor    edi,edi
  94782c:	f3 49 0f bc f9       	tzcnt  rdi,r9
  947831:	48 03 bc 24 80 05 00 	add    rdi,QWORD PTR [rsp+0x580]
  947838:	00 
  947839:	48 81 ff c1 01 00 00 	cmp    rdi,0x1c1
  947840:	72 3e                	jb     947880 <tokenize_c_raw_no_separators+0x2ab0>
  947842:	48 8b 94 24 40 05 00 	mov    rdx,QWORD PTR [rsp+0x540]
  947849:	00 
  94784a:	41 83 f8 07          	cmp    r8d,0x7
  94784e:	77 1b                	ja     94786b <tokenize_c_raw_no_separators+0x2a9b>
  947850:	48 8d 8f 40 fe ff ff 	lea    rcx,[rdi-0x1c0]
  947857:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  94785e:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  947863:	48 23 94 24 40 05 00 	and    rdx,QWORD PTR [rsp+0x540]
  94786a:	00 
  94786b:	b9 ff 01 00 00       	mov    ecx,0x1ff
  947870:	48 85 d2             	test   rdx,rdx
  947873:	0f 85 c7 01 00 00    	jne    947a40 <tokenize_c_raw_no_separators+0x2c70>
  947879:	eb 0d                	jmp    947888 <tokenize_c_raw_no_separators+0x2ab8>
  94787b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
  947880:	81 ff 81 01 00 00    	cmp    edi,0x181
  947886:	72 48                	jb     9478d0 <tokenize_c_raw_no_separators+0x2b00>
  947888:	48 8b 94 24 00 01 00 	mov    rdx,QWORD PTR [rsp+0x100]
  94788f:	00 
  947890:	41 83 f8 06          	cmp    r8d,0x6
  947894:	77 1b                	ja     9478b1 <tokenize_c_raw_no_separators+0x2ae1>
  947896:	48 8d 8f 80 fe ff ff 	lea    rcx,[rdi-0x180]
  94789d:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  9478a4:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  9478a9:	48 23 94 24 00 01 00 	and    rdx,QWORD PTR [rsp+0x100]
  9478b0:	00 
  9478b1:	b9 bf 01 00 00       	mov    ecx,0x1bf
  9478b6:	48 85 d2             	test   rdx,rdx
  9478b9:	0f 85 81 01 00 00    	jne    947a40 <tokenize_c_raw_no_separators+0x2c70>
  9478bf:	eb 17                	jmp    9478d8 <tokenize_c_raw_no_separators+0x2b08>
  9478c1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  9478c8:	0f 1f 84 00 00 00 00 
  9478cf:	00 
  9478d0:	81 ff 41 01 00 00    	cmp    edi,0x141
  9478d6:	72 39                	jb     947911 <tokenize_c_raw_no_separators+0x2b41>
  9478d8:	48 8b 94 24 40 02 00 	mov    rdx,QWORD PTR [rsp+0x240]
  9478df:	00 
  9478e0:	41 83 f8 05          	cmp    r8d,0x5
  9478e4:	77 1b                	ja     947901 <tokenize_c_raw_no_separators+0x2b31>
  9478e6:	48 8d 8f c0 fe ff ff 	lea    rcx,[rdi-0x140]
  9478ed:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  9478f4:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  9478f9:	48 23 94 24 40 02 00 	and    rdx,QWORD PTR [rsp+0x240]
  947900:	00 
  947901:	b9 7f 01 00 00       	mov    ecx,0x17f
  947906:	48 85 d2             	test   rdx,rdx
  947909:	0f 85 31 01 00 00    	jne    947a40 <tokenize_c_raw_no_separators+0x2c70>
  94790f:	eb 08                	jmp    947919 <tokenize_c_raw_no_separators+0x2b49>
  947911:	81 ff 01 01 00 00    	cmp    edi,0x101
  947917:	72 39                	jb     947952 <tokenize_c_raw_no_separators+0x2b82>
  947919:	48 8b 94 24 00 03 00 	mov    rdx,QWORD PTR [rsp+0x300]
  947920:	00 
  947921:	41 83 f8 04          	cmp    r8d,0x4
  947925:	77 1b                	ja     947942 <tokenize_c_raw_no_separators+0x2b72>
  947927:	48 8d 8f 00 ff ff ff 	lea    rcx,[rdi-0x100]
  94792e:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  947935:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  94793a:	48 23 94 24 00 03 00 	and    rdx,QWORD PTR [rsp+0x300]
  947941:	00 
  947942:	b9 3f 01 00 00       	mov    ecx,0x13f
  947947:	48 85 d2             	test   rdx,rdx
  94794a:	0f 85 f0 00 00 00    	jne    947a40 <tokenize_c_raw_no_separators+0x2c70>
  947950:	eb 08                	jmp    94795a <tokenize_c_raw_no_separators+0x2b8a>
  947952:	81 ff c1 00 00 00    	cmp    edi,0xc1
  947958:	72 39                	jb     947993 <tokenize_c_raw_no_separators+0x2bc3>
  94795a:	48 8b 94 24 c0 02 00 	mov    rdx,QWORD PTR [rsp+0x2c0]
  947961:	00 
  947962:	41 83 f8 03          	cmp    r8d,0x3
  947966:	77 1b                	ja     947983 <tokenize_c_raw_no_separators+0x2bb3>
  947968:	48 8d 8f 40 ff ff ff 	lea    rcx,[rdi-0xc0]
  94796f:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  947976:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  94797b:	48 23 94 24 c0 02 00 	and    rdx,QWORD PTR [rsp+0x2c0]
  947982:	00 
  947983:	b9 ff 00 00 00       	mov    ecx,0xff
  947988:	48 85 d2             	test   rdx,rdx
  94798b:	0f 85 af 00 00 00    	jne    947a40 <tokenize_c_raw_no_separators+0x2c70>
  947991:	eb 08                	jmp    94799b <tokenize_c_raw_no_separators+0x2bcb>
  947993:	81 ff 81 00 00 00    	cmp    edi,0x81
  947999:	72 32                	jb     9479cd <tokenize_c_raw_no_separators+0x2bfd>
  94799b:	48 8b 94 24 00 04 00 	mov    rdx,QWORD PTR [rsp+0x400]
  9479a2:	00 
  9479a3:	41 83 f8 02          	cmp    r8d,0x2
  9479a7:	77 18                	ja     9479c1 <tokenize_c_raw_no_separators+0x2bf1>
  9479a9:	48 8d 4f 80          	lea    rcx,[rdi-0x80]
  9479ad:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  9479b4:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  9479b9:	48 23 94 24 00 04 00 	and    rdx,QWORD PTR [rsp+0x400]
  9479c0:	00 
  9479c1:	b9 bf 00 00 00       	mov    ecx,0xbf
  9479c6:	48 85 d2             	test   rdx,rdx
  9479c9:	75 75                	jne    947a40 <tokenize_c_raw_no_separators+0x2c70>
  9479cb:	eb 05                	jmp    9479d2 <tokenize_c_raw_no_separators+0x2c02>
  9479cd:	83 ff 41             	cmp    edi,0x41
  9479d0:	72 32                	jb     947a04 <tokenize_c_raw_no_separators+0x2c34>
  9479d2:	48 8b 94 24 80 00 00 	mov    rdx,QWORD PTR [rsp+0x80]
  9479d9:	00 
  9479da:	41 83 f8 01          	cmp    r8d,0x1
  9479de:	77 18                	ja     9479f8 <tokenize_c_raw_no_separators+0x2c28>
  9479e0:	48 8d 4f c0          	lea    rcx,[rdi-0x40]
  9479e4:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  9479eb:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  9479f0:	48 23 94 24 80 00 00 	and    rdx,QWORD PTR [rsp+0x80]
  9479f7:	00 
  9479f8:	b9 7f 00 00 00       	mov    ecx,0x7f
  9479fd:	48 85 d2             	test   rdx,rdx
  947a00:	75 3e                	jne    947a40 <tokenize_c_raw_no_separators+0x2c70>
  947a02:	eb 05                	jmp    947a09 <tokenize_c_raw_no_separators+0x2c39>
  947a04:	48 85 ff             	test   rdi,rdi
  947a07:	74 51                	je     947a5a <tokenize_c_raw_no_separators+0x2c8a>
  947a09:	48 8b 54 24 70       	mov    rdx,QWORD PTR [rsp+0x70]
  947a0e:	45 85 c0             	test   r8d,r8d
  947a11:	74 0c                	je     947a1f <tokenize_c_raw_no_separators+0x2c4f>
  947a13:	b9 3f 00 00 00       	mov    ecx,0x3f
  947a18:	48 85 d2             	test   rdx,rdx
  947a1b:	75 23                	jne    947a40 <tokenize_c_raw_no_separators+0x2c70>
  947a1d:	eb 3b                	jmp    947a5a <tokenize_c_raw_no_separators+0x2c8a>
  947a1f:	48 c7 c1 ff ff ff ff 	mov    rcx,0xffffffffffffffff
  947a26:	c4 e2 c0 f5 d1       	bzhi   rdx,rcx,rdi
  947a2b:	48 23 54 24 70       	and    rdx,QWORD PTR [rsp+0x70]
  947a30:	b9 3f 00 00 00       	mov    ecx,0x3f
  947a35:	48 85 d2             	test   rdx,rdx
  947a38:	74 20                	je     947a5a <tokenize_c_raw_no_separators+0x2c8a>
  947a3a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  947a40:	f3 48 0f bd d2       	lzcnt  rdx,rdx
  947a45:	29 d1                	sub    ecx,edx
  947a47:	83 f9 3f             	cmp    ecx,0x3f
  947a4a:	0f 87 a0 fd ff ff    	ja     9477f0 <tokenize_c_raw_no_separators+0x2a20>
  947a50:	48 0f a3 c8          	bt     rax,rcx
  947a54:	0f 83 96 fd ff ff    	jae    9477f0 <tokenize_c_raw_no_separators+0x2a20>
  947a5a:	b1 01                	mov    cl,0x1
  947a5c:	89 8c 24 c0 00 00 00 	mov    DWORD PTR [rsp+0xc0],ecx
  947a63:	c4 c2 b0 f3 c9       	blsr   r9,r9
  947a68:	0f 85 bc fd ff ff    	jne    94782a <tokenize_c_raw_no_separators+0x2a5a>
  947a6e:	e9 2d fd ff ff       	jmp    9477a0 <tokenize_c_raw_no_separators+0x29d0>
  947a73:	62 a1 45 00 ef ff    	vpxord xmm23,xmm23,xmm23
  947a79:	62 01 35 00 ef c9    	vpxord xmm25,xmm25,xmm25
  947a7f:	62 a1 4d 00 ef f6    	vpxord xmm22,xmm22,xmm22
  947a85:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  947a8c:	00 00 00 00 
  947a90:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
  947a96:	62 b3 85 40 03 c3 07 	valignq zmm0,zmm31,zmm19,0x7
  947a9d:	62 23 8d 40 03 c3 07 	valignq zmm24,zmm30,zmm19,0x7
  947aa4:	62 23 95 40 03 e3 07 	valignq zmm28,zmm29,zmm19,0x7
  947aab:	62 01 8d 40 eb d7    	vporq  zmm26,zmm30,zmm31
  947ab1:	62 f1 bd 40 eb c0    	vporq  zmm0,zmm24,zmm0
  947ab7:	62 03 8d 40 71 c0 02 	vpshldq zmm24,zmm30,zmm24,0x2
  947abe:	62 03 95 40 71 dc 01 	vpshldq zmm27,zmm29,zmm28,0x1
  947ac5:	62 f3 ad 40 71 c0 01 	vpshldq zmm0,zmm26,zmm0,0x1
  947acc:	62 03 fd 48 25 d8 fe 	vpternlogq zmm27,zmm0,zmm24,0xfe
  947ad3:	62 93 95 40 71 c4 02 	vpshldq zmm0,zmm29,zmm28,0x2
  947ada:	62 03 95 40 71 e4 03 	vpshldq zmm28,zmm29,zmm28,0x3
  947ae1:	62 63 a5 40 25 e0 fe 	vpternlogq zmm28,zmm27,zmm0,0xfe
  947ae8:	62 91 9d 40 df c7    	vpandnq zmm0,zmm28,zmm31
  947aee:	62 01 9d 40 df d6    	vpandnq zmm26,zmm28,zmm30
  947af4:	62 01 9d 40 df c5    	vpandnq zmm24,zmm28,zmm29
  947afa:	62 23 fd 48 03 db 07 	valignq zmm27,zmm0,zmm19,0x7
  947b01:	62 23 ad 40 03 e3 07 	valignq zmm28,zmm26,zmm19,0x7
  947b08:	62 81 fd 48 eb da    	vporq  zmm19,zmm0,zmm26
  947b0e:	62 a1 fd 48 eb f6    	vporq  zmm22,zmm0,zmm22
  947b14:	62 01 ad 40 eb c9    	vporq  zmm25,zmm26,zmm25
  947b1a:	62 a1 bd 40 eb ff    	vporq  zmm23,zmm24,zmm23
  947b20:	62 e1 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x580],zmm19
  947b27:	16 
  947b28:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x580]
  947b2f:	16 
  947b30:	62 01 a5 40 eb dc    	vporq  zmm27,zmm27,zmm28
  947b36:	62 03 ad 40 71 e4 02 	vpshldq zmm28,zmm26,zmm28,0x2
  947b3d:	62 03 e5 40 71 db 01 	vpshldq zmm27,zmm19,zmm27,0x1
  947b44:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
  947b4a:	62 a3 bd 40 03 db 07 	valignq zmm19,zmm24,zmm19,0x7
  947b51:	62 61 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x580],zmm27
  947b58:	16 
  947b59:	62 23 bd 40 71 db 01 	vpshldq zmm27,zmm24,zmm19,0x1
  947b60:	62 01 9d 40 eb db    	vporq  zmm27,zmm28,zmm27
  947b66:	62 23 bd 40 71 e3 02 	vpshldq zmm28,zmm24,zmm19,0x2
  947b6d:	62 a3 bd 40 71 db 03 	vpshldq zmm19,zmm24,zmm19,0x3
  947b74:	62 83 a5 40 25 dc fe 	vpternlogq zmm19,zmm27,zmm28,0xfe
  947b7b:	62 e3 ad 40 25 5c 24 	vpternlogq zmm19,zmm26,ZMMWORD PTR [rsp+0x580],0xfe
  947b82:	16 fe 
  947b84:	62 e3 bd 40 25 d8 fe 	vpternlogq zmm19,zmm24,zmm0,0xfe
  947b8b:	62 01 e5 40 df ed    	vpandnq zmm29,zmm19,zmm29
  947b91:	62 01 e5 40 df ff    	vpandnq zmm31,zmm19,zmm31
  947b97:	62 01 e5 40 df f6    	vpandnq zmm30,zmm19,zmm30
  947b9d:	62 91 fd 48 6f c5    	vmovdqa64 zmm0,zmm29
  947ba3:	62 93 85 40 25 c6 fe 	vpternlogq zmm0,zmm31,zmm30,0xfe
  947baa:	62 f2 7d 48 27 c0    	vptestmd k0,zmm0,zmm0
  947bb0:	c5 f8 98 c0          	kortestw k0,k0
  947bb4:	0f 85 d6 fe ff ff    	jne    947a90 <tokenize_c_raw_no_separators+0x2cc0>
  947bba:	62 01 25 00 ef db    	vpxord xmm27,xmm27,xmm27
  947bc0:	62 03 cd 40 03 c3 07 	valignq zmm24,zmm22,zmm27,0x7
  947bc7:	62 93 b5 40 03 c3 07 	valignq zmm0,zmm25,zmm27,0x7
  947bce:	62 03 c5 40 03 eb 07 	valignq zmm29,zmm23,zmm27,0x7
  947bd5:	62 81 cd 40 eb d9    	vporq  zmm19,zmm22,zmm25
  947bdb:	62 61 bd 40 eb d0    	vporq  zmm26,zmm24,zmm0
  947be1:	62 03 c5 40 71 dd 01 	vpshldq zmm27,zmm23,zmm29,0x1
  947be8:	62 03 c5 40 71 e5 02 	vpshldq zmm28,zmm23,zmm29,0x2
  947bef:	62 83 e5 40 71 da 01 	vpshldq zmm19,zmm19,zmm26,0x1
  947bf6:	62 63 b5 40 71 d0 02 	vpshldq zmm26,zmm25,zmm0,0x2
  947bfd:	62 03 e5 40 25 e3 fe 	vpternlogq zmm28,zmm19,zmm27,0xfe
  947c04:	62 03 c5 40 71 dd 03 	vpshldq zmm27,zmm23,zmm29,0x3
  947c0b:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
  947c11:	62 03 a5 40 25 e2 fe 	vpternlogq zmm28,zmm27,zmm26,0xfe
  947c18:	e9 2e ef ff ff       	jmp    946b4b <tokenize_c_raw_no_separators+0x1d7b>
  947c1d:	f6 84 24 c0 00 00 00 	test   BYTE PTR [rsp+0xc0],0x1
  947c24:	01 
  947c25:	74 1b                	je     947c42 <tokenize_c_raw_no_separators+0x2e72>
  947c27:	4c 89 f9             	mov    rcx,r15
  947c2a:	48 2b 8c 24 e8 03 00 	sub    rcx,QWORD PTR [rsp+0x3e8]
  947c31:	00 
  947c32:	48 8b 94 24 98 00 00 	mov    rdx,QWORD PTR [rsp+0x98]
  947c39:	00 
  947c3a:	48 c1 f9 02          	sar    rcx,0x2
  947c3e:	80 24 0a 80          	and    BYTE PTR [rdx+rcx*1],0x80
  947c42:	4c 8b 4c 24 48       	mov    r9,QWORD PTR [rsp+0x48]
  947c47:	e9 b3 ed ff ff       	jmp    9469ff <tokenize_c_raw_no_separators+0x1c2f>
  947c4c:	48 8b 7c 24 58       	mov    rdi,QWORD PTR [rsp+0x58]
  947c51:	62 71 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x600],zmm14
  947c58:	18 
  947c59:	62 f1 7c 48 28 47 02 	vmovaps zmm0,ZMMWORD PTR [rdi+0x80]
  947c60:	62 e1 fd 48 6f 0f    	vmovdqa64 zmm17,ZMMWORD PTR [rdi]
  947c66:	62 e1 fd 48 6f 5f 01 	vmovdqa64 zmm19,ZMMWORD PTR [rdi+0x40]
  947c6d:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0xc0],zmm0
  947c74:	03 
  947c75:	62 f1 7c 48 28 47 03 	vmovaps zmm0,ZMMWORD PTR [rdi+0xc0]
  947c7c:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2c0],zmm17
  947c83:	0b 
  947c84:	62 e1 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x8c0],zmm19
  947c8b:	23 
  947c8c:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x200],zmm0
  947c93:	08 
  947c94:	62 f1 7c 48 28 47 04 	vmovaps zmm0,ZMMWORD PTR [rdi+0x100]
  947c9b:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x440],zmm0
  947ca2:	11 
  947ca3:	62 f1 7c 48 28 47 05 	vmovaps zmm0,ZMMWORD PTR [rdi+0x140]
  947caa:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x340],zmm0
  947cb1:	0d 
  947cb2:	62 f1 7c 48 28 47 06 	vmovaps zmm0,ZMMWORD PTR [rdi+0x180]
  947cb9:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x300],zmm0
  947cc0:	0c 
  947cc1:	62 f1 7c 48 28 47 07 	vmovaps zmm0,ZMMWORD PTR [rdi+0x1c0]
  947cc8:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x400],zmm0
  947ccf:	10 
  947cd0:	62 f2 7d 48 5a 05 66 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffae3166]        # 42ae40 <c_testsuite_feature.marker+0x93c>
  947cd7:	31 ae ff 
  947cda:	62 f1 75 40 74 c0    	vpcmpeqb k0,zmm17,zmm0
  947ce0:	62 e2 7d 48 5a 0d 66 	vbroadcasti32x4 zmm17,XMMWORD PTR [rip+0xffffffffffae3166]        # 42ae50 <c_testsuite_feature.marker+0x94c>
  947ce7:	31 ae ff 
  947cea:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947cef:	62 f1 65 40 74 c0    	vpcmpeqb k0,zmm19,zmm0
  947cf5:	48 89 94 24 70 01 00 	mov    QWORD PTR [rsp+0x170],rdx
  947cfc:	00 
  947cfd:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947d02:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0xc0]
  947d09:	03 
  947d0a:	48 89 54 24 70       	mov    QWORD PTR [rsp+0x70],rdx
  947d0f:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947d14:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x200]
  947d1b:	08 
  947d1c:	48 89 94 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rdx
  947d23:	00 
  947d24:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947d29:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x440]
  947d30:	11 
  947d31:	48 89 94 24 80 03 00 	mov    QWORD PTR [rsp+0x380],rdx
  947d38:	00 
  947d39:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947d3e:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x340]
  947d45:	0d 
  947d46:	48 89 94 24 00 09 00 	mov    QWORD PTR [rsp+0x900],rdx
  947d4d:	00 
  947d4e:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947d53:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x300]
  947d5a:	0c 
  947d5b:	48 89 94 24 40 07 00 	mov    QWORD PTR [rsp+0x740],rdx
  947d62:	00 
  947d63:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947d68:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x400]
  947d6f:	10 
  947d70:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x2c0]
  947d77:	0b 
  947d78:	48 89 94 24 00 07 00 	mov    QWORD PTR [rsp+0x700],rdx
  947d7f:	00 
  947d80:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947d85:	62 b1 7d 48 74 c1    	vpcmpeqb k0,zmm0,zmm17
  947d8b:	62 e2 7d 48 5a 0d 8b 	vbroadcasti32x4 zmm17,XMMWORD PTR [rip+0xffffffffffae308b]        # 42ae20 <c_testsuite_feature.marker+0x91c>
  947d92:	30 ae ff 
  947d95:	62 b1 7d 48 74 c9    	vpcmpeqb k1,zmm0,zmm17
  947d9b:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0xc0]
  947da2:	03 
  947da3:	62 b1 65 40 74 d1    	vpcmpeqb k2,zmm19,zmm17
  947da9:	c4 e1 fc 45 c1       	korq   k0,k0,k1
  947dae:	62 f1 65 40 74 0d c8 	vpcmpeqb k1,zmm19,ZMMWORD PTR [rip+0xffffffffffabf5c8]        # 407380 <__abi_tag+0x67c4>
  947db5:	f5 ab ff 
  947db8:	62 e2 7d 48 5a 1d 8e 	vbroadcasti32x4 zmm19,XMMWORD PTR [rip+0xffffffffffae308e]        # 42ae50 <c_testsuite_feature.marker+0x94c>
  947dbf:	30 ae ff 
  947dc2:	c4 e1 f8 91 84 24 00 	kmovq  QWORD PTR [rsp+0x800],k0
  947dc9:	08 00 00 
  947dcc:	62 b1 7d 48 74 d9    	vpcmpeqb k3,zmm0,zmm17
  947dd2:	c4 e1 f4 45 ca       	korq   k1,k1,k2
  947dd7:	62 b1 7d 48 74 d3    	vpcmpeqb k2,zmm0,zmm19
  947ddd:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x200]
  947de4:	08 
  947de5:	c4 e1 ec 45 d3       	korq   k2,k2,k3
  947dea:	62 b1 7d 48 74 db    	vpcmpeqb k3,zmm0,zmm19
  947df0:	62 b1 7d 48 74 e1    	vpcmpeqb k4,zmm0,zmm17
  947df6:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x440]
  947dfd:	11 
  947dfe:	c4 e1 e4 45 dc       	korq   k3,k3,k4
  947e03:	62 b1 7d 48 74 e3    	vpcmpeqb k4,zmm0,zmm19
  947e09:	62 b1 7d 48 74 e9    	vpcmpeqb k5,zmm0,zmm17
  947e0f:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x340]
  947e16:	0d 
  947e17:	c4 e1 dc 45 e5       	korq   k4,k4,k5
  947e1c:	62 b1 7d 48 74 eb    	vpcmpeqb k5,zmm0,zmm19
  947e22:	62 b1 7d 48 74 f1    	vpcmpeqb k6,zmm0,zmm17
  947e28:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x300]
  947e2f:	0c 
  947e30:	c4 e1 d4 45 ee       	korq   k5,k5,k6
  947e35:	62 b1 7d 48 74 f3    	vpcmpeqb k6,zmm0,zmm19
  947e3b:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x400]
  947e42:	10 
  947e43:	62 b1 7d 48 74 f9    	vpcmpeqb k7,zmm0,zmm17
  947e49:	c4 e1 f9 6e c2       	vmovq  xmm0,rdx
  947e4e:	c5 f9 7f 84 24 80 08 	vmovdqa XMMWORD PTR [rsp+0x880],xmm0
  947e55:	00 00 
  947e57:	c5 fb 10 84 24 00 07 	vmovsd xmm0,QWORD PTR [rsp+0x700]
  947e5e:	00 00 
  947e60:	c4 e1 cc 45 f7       	korq   k6,k6,k7
  947e65:	62 f1 65 40 74 3d 11 	vpcmpeqb k7,zmm19,ZMMWORD PTR [rip+0xffffffffffabf511]        # 407380 <__abi_tag+0x67c4>
  947e6c:	f5 ab ff 
  947e6f:	62 b1 65 40 74 c1    	vpcmpeqb k0,zmm19,zmm17
  947e75:	62 e1 ff 08 10 4c 24 	vmovsd xmm17,QWORD PTR [rsp+0x380]
  947e7c:	70 
  947e7d:	c5 f8 29 84 24 40 08 	vmovaps XMMWORD PTR [rsp+0x840],xmm0
  947e84:	00 00 
  947e86:	c5 fb 10 84 24 40 07 	vmovsd xmm0,QWORD PTR [rsp+0x740]
  947e8d:	00 00 
  947e8f:	c4 e1 c4 45 c0       	korq   k0,k7,k0
  947e94:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947e99:	c4 e1 f8 90 84 24 00 	kmovq  k0,QWORD PTR [rsp+0x800]
  947ea0:	08 00 00 
  947ea3:	62 e1 7c 08 29 4c 24 	vmovaps XMMWORD PTR [rsp+0x380],xmm17
  947eaa:	38 
  947eab:	62 e1 ff 08 10 4c 24 	vmovsd xmm17,QWORD PTR [rsp+0x80]
  947eb2:	10 
  947eb3:	c5 f8 29 84 24 c0 07 	vmovaps XMMWORD PTR [rsp+0x7c0],xmm0
  947eba:	00 00 
  947ebc:	c5 fb 10 84 24 00 09 	vmovsd xmm0,QWORD PTR [rsp+0x900]
  947ec3:	00 00 
  947ec5:	c5 f9 14 84 24 c0 07 	vunpcklpd xmm0,xmm0,XMMWORD PTR [rsp+0x7c0]
  947ecc:	00 00 
  947ece:	62 e1 7c 08 29 4c 24 	vmovaps XMMWORD PTR [rsp+0x80],xmm17
  947ed5:	08 
  947ed6:	62 e1 ff 08 10 4c 24 	vmovsd xmm17,QWORD PTR [rsp+0x70]
  947edd:	0e 
  947ede:	c5 fc 29 84 24 c0 07 	vmovaps YMMWORD PTR [rsp+0x7c0],ymm0
  947ee5:	00 00 
  947ee7:	62 e1 7c 08 29 4c 24 	vmovaps XMMWORD PTR [rsp+0x70],xmm17
  947eee:	07 
  947eef:	62 e1 ff 08 10 4c 24 	vmovsd xmm17,QWORD PTR [rsp+0x170]
  947ef6:	2e 
  947ef7:	62 e1 7c 08 29 8c 24 	vmovaps XMMWORD PTR [rsp+0x900],xmm17
  947efe:	00 09 00 00 
  947f02:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  947f08:	c4 e1 fb 93 d6       	kmovq  rdx,k6
  947f0d:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x170],xmm17
  947f14:	17 
  947f15:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  947f1b:	c4 e1 fb 93 d5       	kmovq  rdx,k5
  947f20:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x740],xmm17
  947f27:	74 
  947f28:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  947f2e:	c4 e1 fb 93 d4       	kmovq  rdx,k4
  947f33:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x700],xmm17
  947f3a:	70 
  947f3b:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  947f41:	c4 e1 fb 93 d3       	kmovq  rdx,k3
  947f46:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x3d0],xmm17
  947f4d:	3d 
  947f4e:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  947f54:	c4 e1 fb 93 d2       	kmovq  rdx,k2
  947f59:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0xa00],xmm17
  947f60:	00 0a 00 00 
  947f64:	62 e1 7c 48 28 4f 08 	vmovaps zmm17,ZMMWORD PTR [rdi+0x200]
  947f6b:	c4 e1 f9 6e c2       	vmovq  xmm0,rdx
  947f70:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  947f75:	62 e1 7c 48 29 4c 24 	vmovaps ZMMWORD PTR [rsp+0x940],zmm17
  947f7c:	25 
  947f7d:	62 e1 7c 08 28 8c 24 	vmovaps xmm17,XMMWORD PTR [rsp+0x840]
  947f84:	40 08 00 00 
  947f88:	62 e1 f5 00 14 8c 24 	vunpcklpd xmm17,xmm17,XMMWORD PTR [rsp+0x880]
  947f8f:	80 08 00 00 
  947f93:	c5 f9 7f 84 24 80 08 	vmovdqa XMMWORD PTR [rsp+0x880],xmm0
  947f9a:	00 00 
  947f9c:	62 f2 7d 48 5a 05 ba 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffae2eba]        # 42ae60 <c_testsuite_feature.marker+0x95c>
  947fa3:	2e ae ff 
  947fa6:	62 e1 7c 08 29 8c 24 	vmovaps XMMWORD PTR [rsp+0x9c0],xmm17
  947fad:	c0 09 00 00 
  947fb1:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  947fb7:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  947fbc:	62 f1 65 40 74 c8    	vpcmpeqb k1,zmm19,zmm0
  947fc2:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x2c0]
  947fc9:	0b 
  947fca:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x840],xmm17
  947fd1:	40 08 00 00 
  947fd5:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  947fdb:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  947fe0:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x300]
  947fe7:	0c 
  947fe8:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x800],xmm17
  947fef:	00 08 00 00 
  947ff3:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  947ff9:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x3c0],xmm17
  948000:	3c 
  948001:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  948006:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x340]
  94800d:	0d 
  94800e:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  948014:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x980],xmm17
  94801b:	80 09 00 00 
  94801f:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  948024:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x440]
  94802b:	11 
  94802c:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  948032:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x6f0],xmm17
  948039:	6f 
  94803a:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  94803f:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x200]
  948046:	08 
  948047:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  94804d:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x6e0],xmm17
  948054:	6e 
  948055:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  94805a:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0xc0]
  948061:	03 
  948062:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  948068:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x6d0],xmm17
  94806f:	6d 
  948070:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x8c0]
  948077:	23 
  948078:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  94807d:	62 f1 75 40 74 c8    	vpcmpeqb k1,zmm17,zmm0
  948083:	c4 e1 f9 6e c2       	vmovq  xmm0,rdx
  948088:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  94808d:	c5 f9 7f 84 24 c0 06 	vmovdqa XMMWORD PTR [rsp+0x6c0],xmm0
  948094:	00 00 
  948096:	c4 e1 f9 6e c2       	vmovq  xmm0,rdx
  94809b:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  9480a0:	c5 f9 7f 84 24 b0 06 	vmovdqa XMMWORD PTR [rsp+0x6b0],xmm0
  9480a7:	00 00 
  9480a9:	62 f2 7d 48 5a 05 bd 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffae2dbd]        # 42ae70 <c_testsuite_feature.marker+0x96c>
  9480b0:	2d ae ff 
  9480b3:	62 e1 fd 08 6e da    	vmovq  xmm19,rdx
  9480b9:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x400]
  9480c0:	10 
  9480c1:	62 f1 7d 48 74 44 24 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rsp+0x2c0]
  9480c8:	0b 
  9480c9:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x2c0],xmm19
  9480d0:	2c 
  9480d1:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  9480d6:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x300]
  9480dd:	0c 
  9480de:	62 e1 fd 08 6e da    	vmovq  xmm19,rdx
  9480e4:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x300],xmm19
  9480eb:	30 
  9480ec:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  9480f1:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x340]
  9480f8:	0d 
  9480f9:	62 e1 fd 08 6e da    	vmovq  xmm19,rdx
  9480ff:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x340],xmm19
  948106:	34 
  948107:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  94810c:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x440]
  948113:	11 
  948114:	62 e1 fd 08 6e da    	vmovq  xmm19,rdx
  94811a:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x400],xmm19
  948121:	40 
  948122:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  948127:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0x200]
  94812e:	08 
  94812f:	62 e1 fd 08 6e da    	vmovq  xmm19,rdx
  948135:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x200],xmm19
  94813c:	20 
  94813d:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  948142:	62 f1 7d 48 74 4c 24 	vpcmpeqb k1,zmm0,ZMMWORD PTR [rsp+0xc0]
  948149:	03 
  94814a:	62 e1 fd 08 6e da    	vmovq  xmm19,rdx
  948150:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x6a0],xmm19
  948157:	6a 
  948158:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  94815d:	62 f1 75 40 74 c8    	vpcmpeqb k1,zmm17,zmm0
  948163:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  948169:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  94816e:	62 e1 fd 08 7f 8c 24 	vmovdqa64 XMMWORD PTR [rsp+0x8c0],xmm17
  948175:	c0 08 00 00 
  948179:	62 e1 fd 08 6e ca    	vmovq  xmm17,rdx
  94817f:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  948184:	62 e1 fd 08 7f 4c 24 	vmovdqa64 XMMWORD PTR [rsp+0x690],xmm17
  94818b:	69 
  94818c:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x940]
  948193:	25 
  948194:	62 e1 fd 08 6e da    	vmovq  xmm19,rdx
  94819a:	62 f1 75 40 74 0d 9c 	vpcmpeqb k1,zmm17,ZMMWORD PTR [rip+0xffffffffffabf19c]        # 407340 <__abi_tag+0x6784>
  9481a1:	f1 ab ff 
  9481a4:	62 e1 fd 08 7f 5c 24 	vmovdqa64 XMMWORD PTR [rsp+0x680],xmm19
  9481ab:	68 
  9481ac:	62 e1 7c 08 28 9c 24 	vmovaps xmm19,XMMWORD PTR [rsp+0x900]
  9481b3:	00 09 00 00 
  9481b7:	62 e1 e5 00 14 5c 24 	vunpcklpd xmm19,xmm19,XMMWORD PTR [rsp+0x70]
  9481be:	07 
  9481bf:	62 f1 75 40 74 c0    	vpcmpeqb k0,zmm17,zmm0
  9481c5:	c4 e1 fb 93 d1       	kmovq  rdx,k1
  9481ca:	c4 e1 f9 6e c2       	vmovq  xmm0,rdx
  9481cf:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  9481d4:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x940],zmm0
  9481db:	25 
  9481dc:	c4 e1 f9 6e c2       	vmovq  xmm0,rdx
  9481e1:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0xa40],zmm0
  9481e8:	29 
  9481e9:	c5 fc 28 84 24 c0 07 	vmovaps ymm0,YMMWORD PTR [rsp+0x7c0]
  9481f0:	00 00 
  9481f2:	62 e3 7d 28 18 8c 24 	vinsertf32x4 ymm17,ymm0,XMMWORD PTR [rsp+0x9c0],0x1
  9481f9:	c0 09 00 00 01 
  9481fe:	c5 f8 28 84 24 80 00 	vmovaps xmm0,XMMWORD PTR [rsp+0x80]
  948205:	00 00 
  948207:	c5 f9 14 84 24 80 03 	vunpcklpd xmm0,xmm0,XMMWORD PTR [rsp+0x380]
  94820e:	00 00 
  948210:	62 f3 65 20 18 c0 01 	vinsertf32x4 ymm0,ymm19,xmm0,0x1
  948217:	62 b3 fd 48 1a c1 01 	vinsertf64x4 zmm0,zmm0,ymm17,0x1
  94821e:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x440],zmm0
  948225:	11 
  948226:	c5 f8 28 84 24 40 07 	vmovaps xmm0,XMMWORD PTR [rsp+0x740]
  94822d:	00 00 
  94822f:	62 e1 fd 08 14 4c 24 	vunpcklpd xmm17,xmm0,XMMWORD PTR [rsp+0x170]
  948236:	17 
  948237:	c5 f8 28 84 24 d0 03 	vmovaps xmm0,XMMWORD PTR [rsp+0x3d0]
  94823e:	00 00 
  948240:	62 e1 fd 08 14 5c 24 	vunpcklpd xmm19,xmm0,XMMWORD PTR [rsp+0x700]
  948247:	70 
  948248:	62 b3 65 20 18 c1 01 	vinsertf32x4 ymm0,ymm19,xmm17,0x1
  94824f:	62 e1 7c 08 28 9c 24 	vmovaps xmm19,XMMWORD PTR [rsp+0x880]
  948256:	80 08 00 00 
  94825a:	62 e1 7c 08 28 8c 24 	vmovaps xmm17,XMMWORD PTR [rsp+0x800]
  948261:	00 08 00 00 
  948265:	62 e1 e5 00 14 9c 24 	vunpcklpd xmm19,xmm19,XMMWORD PTR [rsp+0xa00]
  94826c:	00 0a 00 00 
  948270:	62 e1 f5 00 14 8c 24 	vunpcklpd xmm17,xmm17,XMMWORD PTR [rsp+0x840]
  948277:	40 08 00 00 
  94827b:	c5 fc 29 84 24 c0 00 	vmovaps YMMWORD PTR [rsp+0xc0],ymm0
  948282:	00 00 
  948284:	62 a3 75 20 18 cb 01 	vinsertf32x4 ymm17,ymm17,xmm19,0x1
  94828b:	62 f3 f5 40 1a 44 24 	vinsertf64x4 zmm0,zmm17,YMMWORD PTR [rsp+0xc0],0x1
  948292:	06 01 
  948294:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x380],zmm0
  94829b:	0e 
  94829c:	c5 f8 28 84 24 80 09 	vmovaps xmm0,XMMWORD PTR [rsp+0x980]
  9482a3:	00 00 
  9482a5:	62 e1 fd 08 14 4c 24 	vunpcklpd xmm17,xmm0,XMMWORD PTR [rsp+0x3c0]
  9482ac:	3c 
  9482ad:	c5 f8 28 84 24 e0 06 	vmovaps xmm0,XMMWORD PTR [rsp+0x6e0]
  9482b4:	00 00 
  9482b6:	62 e1 fd 08 14 5c 24 	vunpcklpd xmm19,xmm0,XMMWORD PTR [rsp+0x6f0]
  9482bd:	6f 
  9482be:	62 b3 65 20 18 c1 01 	vinsertf32x4 ymm0,ymm19,xmm17,0x1
  9482c5:	c5 fc 29 84 24 c0 00 	vmovaps YMMWORD PTR [rsp+0xc0],ymm0
  9482cc:	00 00 
  9482ce:	c5 f8 28 84 24 c0 06 	vmovaps xmm0,XMMWORD PTR [rsp+0x6c0]
  9482d5:	00 00 
  9482d7:	62 e1 fd 08 14 5c 24 	vunpcklpd xmm19,xmm0,XMMWORD PTR [rsp+0x6d0]
  9482de:	6d 
  9482df:	c5 f8 28 84 24 c0 02 	vmovaps xmm0,XMMWORD PTR [rsp+0x2c0]
  9482e6:	00 00 
  9482e8:	62 e1 fd 08 14 4c 24 	vunpcklpd xmm17,xmm0,XMMWORD PTR [rsp+0x6b0]
  9482ef:	6b 
  9482f0:	c5 f8 28 84 24 40 03 	vmovaps xmm0,XMMWORD PTR [rsp+0x340]
  9482f7:	00 00 
  9482f9:	c5 f9 14 84 24 00 03 	vunpcklpd xmm0,xmm0,XMMWORD PTR [rsp+0x300]
  948300:	00 00 
  948302:	62 a3 75 20 18 cb 01 	vinsertf32x4 ymm17,ymm17,xmm19,0x1
  948309:	62 e3 f5 40 1a 4c 24 	vinsertf64x4 zmm17,zmm17,YMMWORD PTR [rsp+0xc0],0x1
  948310:	06 01 
  948312:	c5 f8 29 84 24 40 03 	vmovaps XMMWORD PTR [rsp+0x340],xmm0
  948319:	00 00 
  94831b:	c5 f8 28 84 24 00 02 	vmovaps xmm0,XMMWORD PTR [rsp+0x200]
  948322:	00 00 
  948324:	62 e1 fd 08 14 5c 24 	vunpcklpd xmm19,xmm0,XMMWORD PTR [rsp+0x400]
  94832b:	40 
  94832c:	62 f3 65 20 18 44 24 	vinsertf32x4 ymm0,ymm19,XMMWORD PTR [rsp+0x340],0x1
  948333:	34 01 
  948335:	62 e1 7c 08 28 5c 24 	vmovaps xmm19,XMMWORD PTR [rsp+0x680]
  94833c:	68 
  94833d:	62 e1 e5 00 14 5c 24 	vunpcklpd xmm19,xmm19,XMMWORD PTR [rsp+0x690]
  948344:	69 
  948345:	62 e1 7c 48 29 4c 24 	vmovaps ZMMWORD PTR [rsp+0xc0],zmm17
  94834c:	03 
  94834d:	62 e1 74 40 56 4c 24 	vorps  zmm17,zmm17,ZMMWORD PTR [rsp+0x380]
  948354:	0e 
  948355:	c5 fc 29 84 24 00 02 	vmovaps YMMWORD PTR [rsp+0x200],ymm0
  94835c:	00 00 
  94835e:	c5 f8 28 84 24 c0 08 	vmovaps xmm0,XMMWORD PTR [rsp+0x8c0]
  948365:	00 00 
  948367:	c5 f9 14 84 24 a0 06 	vunpcklpd xmm0,xmm0,XMMWORD PTR [rsp+0x6a0]
  94836e:	00 00 
  948370:	c5 f8 29 84 24 40 03 	vmovaps XMMWORD PTR [rsp+0x340],xmm0
  948377:	00 00 
  948379:	62 e3 65 20 18 5c 24 	vinsertf32x4 ymm19,ymm19,XMMWORD PTR [rsp+0x340],0x1
  948380:	34 01 
  948382:	62 e1 7c 48 29 4c 24 	vmovaps ZMMWORD PTR [rsp+0x340],zmm17
  948389:	0d 
  94838a:	62 c1 fd 48 6f ce    	vmovdqa64 zmm17,zmm14
  948390:	62 f3 e5 40 1a 44 24 	vinsertf64x4 zmm0,zmm19,YMMWORD PTR [rsp+0x200],0x1
  948397:	10 01 
  948399:	62 e1 fd 48 6f 1d 9d 	vmovdqa64 zmm19,ZMMWORD PTR [rip+0xffffffffffabf09d]        # 407440 <__abi_tag+0x6884>
  9483a0:	f0 ab ff 
  9483a3:	62 e2 e5 40 7e 4c 24 	vpermt2q zmm17,zmm19,ZMMWORD PTR [rsp+0x4c0]
  9483aa:	13 
  9483ab:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0x200],zmm0
  9483b2:	08 
  9483b3:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x440]
  9483ba:	11 
  9483bb:	62 d3 f5 40 71 c6 3f 	vpshldq zmm0,zmm17,zmm14,0x3f
  9483c2:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x300],zmm17
  9483c9:	0c 
  9483ca:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x400],zmm0
  9483d1:	10 
  9483d2:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x940]
  9483d9:	25 
  9483da:	62 b3 fd 48 03 c3 01 	valignq zmm0,zmm0,zmm19,0x1
  9483e1:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x2c0],zmm0
  9483e8:	0b 
  9483e9:	62 b3 fd 48 71 c3 3f 	vpshldq zmm0,zmm0,zmm19,0x3f
  9483f0:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x380],zmm0
  9483f7:	0e 
  9483f8:	62 f3 f5 40 71 44 24 	vpshldq zmm0,zmm17,ZMMWORD PTR [rsp+0x600],0x3e
  9483ff:	18 3e 
  948401:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x380]
  948408:	0e 
  948409:	62 f3 f5 40 25 44 24 	vpternlogq zmm0,zmm17,ZMMWORD PTR [rsp+0x340],0x80
  948410:	0d 80 
  948412:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x200]
  948419:	08 
  94841a:	62 f3 e5 40 25 44 24 	vpternlogq zmm0,zmm19,ZMMWORD PTR [rsp+0x400],0xf8
  948421:	10 f8 
  948423:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0xa40]
  94842a:	29 
  94842b:	62 a3 e5 40 03 d9 01 	valignq zmm19,zmm19,zmm17,0x1
  948432:	62 a3 e5 40 71 c9 3f 	vpshldq zmm17,zmm19,zmm17,0x3f
  948439:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x2c0]
  948440:	0b 
  948441:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x200],zmm17
  948448:	08 
  948449:	62 e3 e5 40 71 4c 24 	vpshldq zmm17,zmm19,ZMMWORD PTR [rsp+0x440],0x3e
  948450:	11 3e 
  948452:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x440],zmm17
  948459:	11 
  94845a:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x300]
  948461:	0c 
  948462:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x440]
  948469:	11 
  94846a:	62 e3 f5 40 71 4c 24 	vpshldq zmm17,zmm17,ZMMWORD PTR [rsp+0x600],0x3d
  948471:	18 3d 
  948473:	62 e3 e5 40 25 4c 24 	vpternlogq zmm17,zmm19,ZMMWORD PTR [rsp+0xc0],0x80
  94847a:	03 80 
  94847c:	62 e3 fd 48 25 4c 24 	vpternlogq zmm17,zmm0,ZMMWORD PTR [rsp+0x200],0xec
  948483:	08 ec 
  948485:	62 92 75 40 27 c7    	vptestmd k0,zmm17,zmm31
  94848b:	c5 f8 98 c0          	kortestw k0,k0
  94848f:	0f 85 ba 15 00 00    	jne    949a4f <tokenize_c_raw_no_separators+0x4c7f>
  948495:	62 e1 fd 48 6f 5c 24 	vmovdqa64 zmm19,ZMMWORD PTR [rsp+0x340]
  94849c:	0d 
  94849d:	c5 f9 6e c3          	vmovd  xmm0,ebx
  9484a1:	48 8b bc 24 c0 05 00 	mov    rdi,QWORD PTR [rsp+0x5c0]
  9484a8:	00 
  9484a9:	62 f3 fd 48 03 c5 01 	valignq zmm0,zmm0,zmm5,0x1
  9484b0:	62 e3 fd 48 71 cd 3f 	vpshldq zmm17,zmm0,zmm5,0x3f
  9484b7:	62 f3 fd 48 71 c5 3e 	vpshldq zmm0,zmm0,zmm5,0x3e
  9484be:	62 f1 85 40 db c0    	vpandq zmm0,zmm31,zmm0
  9484c4:	48 89 fa             	mov    rdx,rdi
  9484c7:	48 d1 ea             	shr    rdx,1
  9484ca:	48 21 fa             	and    rdx,rdi
  9484cd:	bf 3e 01 00 00       	mov    edi,0x13e
  9484d2:	62 a3 85 40 25 d9 80 	vpternlogq zmm19,zmm31,zmm17,0x80
  9484d9:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x200]
  9484e0:	08 
  9484e1:	62 e3 fd 48 25 4c 24 	vpternlogq zmm17,zmm0,ZMMWORD PTR [rsp+0xc0],0x80
  9484e8:	03 80 
  9484ea:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  9484ee:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x200],zmm17
  9484f5:	08 
  9484f6:	62 b1 f5 40 eb eb    	vporq  zmm5,zmm17,zmm19
  9484fc:	62 f3 f5 40 03 c0 07 	valignq zmm0,zmm17,zmm0,0x7
  948503:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x200]
  94850a:	08 
  94850b:	62 e3 f5 40 71 c8 01 	vpshldq zmm17,zmm17,zmm0,0x1
  948512:	62 23 f5 40 25 f3 10 	vpternlogq zmm30,zmm17,zmm19,0x10
  948519:	62 a1 75 00 ef c9    	vpxord xmm17,xmm17,xmm17
  94851f:	62 a3 e5 40 03 c9 07 	valignq zmm17,zmm19,zmm17,0x7
  948526:	62 a3 e5 40 71 c9 01 	vpshldq zmm17,zmm19,zmm17,0x1
  94852d:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x440],zmm17
  948534:	11 
  948535:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x200]
  94853c:	08 
  94853d:	62 f3 f5 40 71 c0 02 	vpshldq zmm0,zmm17,zmm0,0x2
  948544:	62 e3 fd 48 25 54 24 	vpternlogq zmm18,zmm0,ZMMWORD PTR [rsp+0x440],0x10
  94854b:	11 10 
  94854d:	c4 e1 f9 6e c2       	vmovq  xmm0,rdx
  948552:	62 b3 fd 48 03 c0 01 	valignq zmm0,zmm0,zmm16,0x1
  948559:	62 a3 fd 48 71 c8 3f 	vpshldq zmm17,zmm0,zmm16,0x3f
  948560:	62 b3 fd 48 71 c0 3e 	vpshldq zmm0,zmm0,zmm16,0x3e
  948567:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x5c0],zmm17
  94856e:	17 
  94856f:	62 e1 fd 48 db 4c 24 	vpandq zmm17,zmm0,ZMMWORD PTR [rsp+0x200]
  948576:	08 
  948577:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x200]
  94857e:	08 
  94857f:	62 e3 e5 40 25 4c 24 	vpternlogq zmm17,zmm19,ZMMWORD PTR [rsp+0x5c0],0xf8
  948586:	17 f8 
  948588:	62 a3 7d 48 39 db 03 	vextracti32x4 xmm19,zmm19,0x3
  94858f:	62 e3 fd 08 16 da 01 	vpextrq rdx,xmm19,0x1
  948596:	48 c1 ea 3f          	shr    rdx,0x3f
  94859a:	62 f3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm0,0x3
  9485a1:	c4 e3 f9 16 c3 01    	vpextrq rbx,xmm0,0x1
  9485a7:	c4 e2 c0 f7 fb       	bextr  rdi,rbx,rdi
  9485ac:	48 c1 eb 3f          	shr    rbx,0x3f
  9485b0:	48 09 d7             	or     rdi,rdx
  9485b3:	48 89 9c 24 00 02 00 	mov    QWORD PTR [rsp+0x200],rbx
  9485ba:	00 
  9485bb:	48 8d 1c 5f          	lea    rbx,[rdi+rbx*2]
  9485bf:	e9 bc e7 ff ff       	jmp    946d80 <tokenize_c_raw_no_separators+0x1fb0>
  9485c4:	62 e1 8d 40 eb f6    	vporq  zmm22,zmm30,zmm6
  9485ca:	31 c0                	xor    eax,eax
  9485cc:	62 61 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x380],zmm29
  9485d3:	0e 
  9485d4:	eb 2b                	jmp    948601 <tokenize_c_raw_no_separators+0x3831>
  9485d6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  9485dd:	00 00 00 
  9485e0:	62 b1 fd 40 ef c7    	vpxorq zmm0,zmm16,zmm23
  9485e6:	62 92 7d 48 27 c6    	vptestmd k0,zmm0,zmm30
  9485ec:	c5 f8 98 c0          	kortestw k0,k0
  9485f0:	0f 84 ba 03 00 00    	je     9489b0 <tokenize_c_raw_no_separators+0x3be0>
  9485f6:	ff c0                	inc    eax
  9485f8:	83 f8 04             	cmp    eax,0x4
  9485fb:	0f 84 08 14 00 00    	je     949a09 <tokenize_c_raw_no_separators+0x4c39>
  948601:	62 91 fd 40 db c6    	vpandq zmm0,zmm16,zmm30
  948607:	62 a1 fd 48 6f f8    	vmovdqa64 zmm23,zmm16
  94860d:	62 71 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x780],zmm14
  948614:	1e 
  948615:	c4 41 09 ef f6       	vpxor  xmm14,xmm14,xmm14
  94861a:	62 a1 7d 00 ef c0    	vpxord xmm16,xmm16,xmm16
  948620:	62 a1 55 00 ef ed    	vpxord xmm21,xmm21,xmm21
  948626:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  94862a:	62 21 fd 48 6f ca    	vmovdqa64 zmm25,zmm18
  948630:	62 21 fd 48 6f d9    	vmovdqa64 zmm27,zmm17
  948636:	62 93 fd 48 03 df 07 	valignq zmm3,zmm0,zmm31,0x7
  94863d:	62 f3 fd 48 71 c3 01 	vpshldq zmm0,zmm0,zmm3,0x1
  948644:	62 f3 cd 40 1e c0 01 	vpcmpltuq k0,zmm22,zmm0
  94864b:	62 f2 cd 40 29 c8    	vpcmpeqq k1,zmm22,zmm0
  948651:	62 f1 cd 40 fb d8    	vpsubq zmm3,zmm22,zmm0
  948657:	c5 fd 4a c0          	kaddb  k0,k0,k0
  94865b:	c5 fd 4a c1          	kaddb  k0,k0,k1
  94865f:	c5 fd 47 c1          	kxorb  k0,k0,k1
  948663:	62 f2 fe 48 38 e0    	vpmovm2q zmm4,k0
  948669:	62 f1 e5 48 d4 dc    	vpaddq zmm3,zmm3,zmm4
  94866f:	62 f1 e5 48 df de    	vpandnq zmm3,zmm3,zmm6
  948675:	62 93 e5 48 03 e7 07 	valignq zmm4,zmm3,zmm31,0x7
  94867c:	62 f3 e5 48 71 dc 01 	vpshldq zmm3,zmm3,zmm4,0x1
  948683:	c5 d9 ef e4          	vpxor  xmm4,xmm4,xmm4
  948687:	62 d3 fd 48 25 df f2 	vpternlogq zmm3,zmm0,zmm15,0xf2
  94868e:	62 f3 dd 40 1e c3 01 	vpcmpltuq k0,zmm20,zmm3
  948695:	62 f2 dd 40 29 cb    	vpcmpeqq k1,zmm20,zmm3
  94869b:	62 f1 dd 40 fb c3    	vpsubq zmm0,zmm20,zmm3
  9486a1:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9486a5:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9486a9:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9486ad:	62 f2 fe 48 38 d8    	vpmovm2q zmm3,k0
  9486b3:	62 f1 fd 48 d4 c3    	vpaddq zmm0,zmm0,zmm3
  9486b9:	c5 e1 ef db          	vpxor  xmm3,xmm3,xmm3
  9486bd:	62 41 fd 48 df d5    	vpandnq zmm26,zmm0,zmm13
  9486c3:	e9 9e 00 00 00       	jmp    948766 <tokenize_c_raw_no_separators+0x3996>
  9486c8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  9486cf:	00 
  9486d0:	62 91 b5 40 eb c4    	vporq  zmm0,zmm25,zmm28
  9486d6:	62 51 ad 40 eb f6    	vporq  zmm14,zmm26,zmm14
  9486dc:	62 81 fd 40 eb c3    	vporq  zmm16,zmm16,zmm27
  9486e2:	62 01 fd 48 eb ce    	vporq  zmm25,zmm0,zmm30
  9486e8:	62 b3 b5 40 1e c3 01 	vpcmpltuq k0,zmm25,zmm19
  9486ef:	62 b2 b5 40 29 cb    	vpcmpeqq k1,zmm25,zmm19
  9486f5:	62 21 b5 40 fb cb    	vpsubq zmm25,zmm25,zmm19
  9486fb:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9486ff:	c5 fd 4a c1          	kaddb  k0,k0,k1
  948703:	c5 fd 47 c1          	kxorb  k0,k0,k1
  948707:	62 62 fe 48 38 d0    	vpmovm2q zmm26,k0
  94870d:	62 01 b5 40 d4 ca    	vpaddq zmm25,zmm25,zmm26
  948713:	62 61 b5 40 df c8    	vpandnq zmm25,zmm25,zmm0
  948719:	62 93 dd 40 1e c1 01 	vpcmpltuq k0,zmm20,zmm25
  948720:	62 92 dd 40 29 c9    	vpcmpeqq k1,zmm20,zmm25
  948726:	62 91 dd 40 fb c1    	vpsubq zmm0,zmm20,zmm25
  94872c:	62 01 25 00 ef db    	vpxord xmm27,xmm27,xmm27
  948732:	c5 fd 4a c0          	kaddb  k0,k0,k0
  948736:	c5 fd 4a c1          	kaddb  k0,k0,k1
  94873a:	c5 fd 47 c1          	kxorb  k0,k0,k1
  94873e:	62 62 fe 48 38 c8    	vpmovm2q zmm25,k0
  948744:	62 91 fd 48 d4 c1    	vpaddq zmm0,zmm0,zmm25
  94874a:	62 01 35 00 ef c9    	vpxord xmm25,xmm25,xmm25
  948750:	62 41 fd 48 df d5    	vpandnq zmm26,zmm0,zmm13
  948756:	62 92 2d 40 27 c2    	vptestmd k0,zmm26,zmm26
  94875c:	c5 f8 98 c0          	kortestw k0,k0
  948760:	0f 84 7a fe ff ff    	je     9485e0 <tokenize_c_raw_no_separators+0x3810>
  948766:	62 41 ad 40 db eb    	vpandq zmm29,zmm26,zmm11
  94876c:	62 41 ad 40 db e1    	vpandq zmm28,zmm26,zmm9
  948772:	62 01 fd 48 6f c6    	vmovdqa64 zmm24,zmm30
  948778:	62 01 a5 40 eb f4    	vporq  zmm30,zmm27,zmm28
  94877e:	62 91 95 40 eb c1    	vporq  zmm0,zmm29,zmm25
  948784:	62 61 8d 40 eb f8    	vporq  zmm31,zmm30,zmm0
  94878a:	62 92 05 40 27 c7    	vptestmd k0,zmm31,zmm31
  948790:	c5 f8 98 c0          	kortestw k0,k0
  948794:	0f 84 e6 00 00 00    	je     948880 <tokenize_c_raw_no_separators+0x3ab0>
  94879a:	62 93 bd 40 1e c6 01 	vpcmpltuq k0,zmm24,zmm30
  9487a1:	62 92 bd 40 29 ce    	vpcmpeqq k1,zmm24,zmm30
  9487a7:	62 01 9d 40 eb e5    	vporq  zmm28,zmm28,zmm29
  9487ad:	62 01 bd 40 fb f6    	vpsubq zmm30,zmm24,zmm30
  9487b3:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9487b7:	62 f1 9d 40 eb ed    	vporq  zmm5,zmm28,zmm5
  9487bd:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9487c1:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9487c5:	62 f2 bd 40 29 c8    	vpcmpeqq k1,zmm24,zmm0
  9487cb:	62 62 fe 48 38 f8    	vpmovm2q zmm31,k0
  9487d1:	62 f3 bd 40 1e c0 01 	vpcmpltuq k0,zmm24,zmm0
  9487d8:	62 f1 bd 40 fb c0    	vpsubq zmm0,zmm24,zmm0
  9487de:	62 01 8d 40 d4 f7    	vpaddq zmm30,zmm30,zmm31
  9487e4:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9487e8:	62 41 8d 40 db f1    	vpandq zmm30,zmm30,zmm9
  9487ee:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9487f2:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9487f6:	62 62 fe 48 38 f8    	vpmovm2q zmm31,k0
  9487fc:	62 91 fd 48 d4 c7    	vpaddq zmm0,zmm0,zmm31
  948802:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  948808:	62 03 9d 40 03 ef 07 	valignq zmm29,zmm28,zmm31,0x7
  94880f:	62 d3 8d 40 25 c2 ec 	vpternlogq zmm0,zmm30,zmm10,0xec
  948816:	62 03 9d 40 71 ed 01 	vpshldq zmm29,zmm28,zmm29,0x1
  94881d:	62 01 fd 48 eb f0    	vporq  zmm30,zmm0,zmm24
  948823:	62 03 b5 40 25 dd fe 	vpternlogq zmm27,zmm25,zmm29,0xfe
  94882a:	62 93 8d 40 1e c3 01 	vpcmpltuq k0,zmm30,zmm27
  948831:	62 92 8d 40 29 cb    	vpcmpeqq k1,zmm30,zmm27
  948837:	62 01 8d 40 fb cb    	vpsubq zmm25,zmm30,zmm27
  94883d:	62 01 fd 48 6f f0    	vmovdqa64 zmm30,zmm24
  948843:	c5 fd 4a c0          	kaddb  k0,k0,k0
  948847:	c5 fd 4a c1          	kaddb  k0,k0,k1
  94884b:	c5 fd 47 c1          	kxorb  k0,k0,k1
  94884f:	62 62 fe 48 38 d8    	vpmovm2q zmm27,k0
  948855:	62 01 b5 40 d4 cb    	vpaddq zmm25,zmm25,zmm27
  94885b:	62 93 b5 40 25 c0 10 	vpternlogq zmm0,zmm25,zmm24,0x10
  948862:	62 93 b5 40 25 e0 f2 	vpternlogq zmm4,zmm25,zmm24,0xf2
  948869:	62 03 fd 48 03 cf 07 	valignq zmm25,zmm0,zmm31,0x7
  948870:	62 f1 fd 48 eb db    	vporq  zmm3,zmm0,zmm3
  948876:	62 03 fd 48 71 c9 01 	vpshldq zmm25,zmm0,zmm25,0x1
  94887d:	eb 13                	jmp    948892 <tokenize_c_raw_no_separators+0x3ac2>
  94887f:	90                   	nop
  948880:	62 01 35 00 ef c9    	vpxord xmm25,xmm25,xmm25
  948886:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  94888c:	62 01 fd 48 6f f0    	vmovdqa64 zmm30,zmm24
  948892:	62 61 ad 40 db e7    	vpandq zmm28,zmm26,zmm7
  948898:	62 c3 ad 40 25 ec f8 	vpternlogq zmm21,zmm26,zmm12,0xf8
  94889f:	62 92 1d 40 27 c4    	vptestmd k0,zmm28,zmm28
  9488a5:	c5 f8 98 c0          	kortestw k0,k0
  9488a9:	0f 84 6a fe ff ff    	je     948719 <tokenize_c_raw_no_separators+0x3949>
  9488af:	62 93 9d 40 03 c7 07 	valignq zmm0,zmm28,zmm31,0x7
  9488b6:	62 f3 9d 40 71 c0 03 	vpshldq zmm0,zmm28,zmm0,0x3
  9488bd:	62 61 cd 48 df d0    	vpandnq zmm26,zmm6,zmm0
  9488c3:	62 93 cd 48 1e c2 01 	vpcmpltuq k0,zmm6,zmm26
  9488ca:	62 92 cd 48 29 ca    	vpcmpeqq k1,zmm6,zmm26
  9488d0:	62 01 cd 48 fb d2    	vpsubq zmm26,zmm6,zmm26
  9488d6:	c5 fd 4a c0          	kaddb  k0,k0,k0
  9488da:	c5 fd 4a c1          	kaddb  k0,k0,k1
  9488de:	c5 fd 47 c1          	kxorb  k0,k0,k1
  9488e2:	62 62 fe 48 38 d8    	vpmovm2q zmm27,k0
  9488e8:	62 01 ad 40 d4 d3    	vpaddq zmm26,zmm26,zmm27
  9488ee:	62 63 cd 48 25 d0 8c 	vpternlogq zmm26,zmm6,zmm0,0x8c
  9488f5:	62 93 ad 40 1e c4 01 	vpcmpltuq k0,zmm26,zmm28
  9488fc:	62 92 ad 40 29 cc    	vpcmpeqq k1,zmm26,zmm28
  948902:	62 91 ad 40 fb c4    	vpsubq zmm0,zmm26,zmm28
  948908:	c5 fd 4a c0          	kaddb  k0,k0,k0
  94890c:	c5 fd 4a c1          	kaddb  k0,k0,k1
  948910:	c5 fd 47 c1          	kxorb  k0,k0,k1
  948914:	62 62 fe 48 38 d8    	vpmovm2q zmm27,k0
  94891a:	62 01 fd 48 d4 db    	vpaddq zmm27,zmm0,zmm27
  948920:	62 93 ad 40 03 c7 07 	valignq zmm0,zmm26,zmm31,0x7
  948927:	62 03 ad 40 25 dc fe 	vpternlogq zmm27,zmm26,zmm28,0xfe
  94892e:	62 92 25 40 27 c6    	vptestmd k0,zmm27,zmm30
  948934:	62 63 ad 40 71 e0 01 	vpshldq zmm28,zmm26,zmm0,0x1
  94893b:	c5 f8 98 c0          	kortestw k0,k0
  94893f:	0f 84 8b fd ff ff    	je     9486d0 <tokenize_c_raw_no_separators+0x3900>
  948945:	62 91 8d 40 df c4    	vpandnq zmm0,zmm30,zmm28
  94894b:	62 f3 8d 40 1e c0 01 	vpcmpltuq k0,zmm30,zmm0
  948952:	62 f2 8d 40 29 c8    	vpcmpeqq k1,zmm30,zmm0
  948958:	62 f1 8d 40 fb c0    	vpsubq zmm0,zmm30,zmm0
  94895e:	c5 fd 4a c0          	kaddb  k0,k0,k0
  948962:	c5 fd 4a c1          	kaddb  k0,k0,k1
  948966:	c5 fd 47 c1          	kxorb  k0,k0,k1
  94896a:	62 62 fe 48 38 e8    	vpmovm2q zmm29,k0
  948970:	62 91 fd 48 d4 c5    	vpaddq zmm0,zmm0,zmm29
  948976:	62 91 fd 48 ef c6    	vpxorq zmm0,zmm0,zmm30
  94897c:	62 93 9d 40 25 c3 fe 	vpternlogq zmm0,zmm28,zmm27,0xfe
  948983:	62 f1 fd 48 df ed    	vpandnq zmm5,zmm0,zmm5
  948989:	62 f1 fd 48 df db    	vpandnq zmm3,zmm0,zmm3
  94898f:	62 f1 fd 48 df e4    	vpandnq zmm4,zmm0,zmm4
  948995:	62 a1 fd 48 df ed    	vpandnq zmm21,zmm0,zmm21
  94899b:	62 a1 fd 48 df c0    	vpandnq zmm16,zmm0,zmm16
  9489a1:	62 01 fd 48 df c9    	vpandnq zmm25,zmm0,zmm25
  9489a7:	e9 24 fd ff ff       	jmp    9486d0 <tokenize_c_raw_no_separators+0x3900>
  9489ac:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
  9489b0:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x780]
  9489b7:	1e 
  9489b8:	62 13 7d 48 39 f0 03 	vextracti32x4 xmm24,zmm14,0x3
  9489bf:	62 a3 7d 48 39 ff 03 	vextracti32x4 xmm23,zmm23,0x3
  9489c6:	62 83 7d 48 39 c1 03 	vextracti32x4 xmm25,zmm16,0x3
  9489cd:	62 a1 b5 00 6d ff    	vpunpckhqdq xmm23,xmm25,xmm23
  9489d3:	62 f3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm0,0x3
  9489da:	62 f1 bd 00 6d c0    	vpunpckhqdq xmm0,xmm24,xmm0
  9489e0:	62 b1 fd 08 df c7    	vpandnq xmm0,xmm0,xmm23
  9489e6:	62 e1 7d 08 70 f8 ee 	vpshufd xmm23,xmm0,0xee
  9489ed:	62 b1 fd 08 ef c7    	vpxorq xmm0,xmm0,xmm23
  9489f3:	c4 e1 f9 7e c1       	vmovq  rcx,xmm0
  9489f8:	48 85 c9             	test   rcx,rcx
  9489fb:	0f 88 f5 fb ff ff    	js     9485f6 <tokenize_c_raw_no_separators+0x3826>
  948a01:	62 61 fd 48 6f 6c 24 	vmovdqa64 zmm29,ZMMWORD PTR [rsp+0x380]
  948a08:	0e 
  948a09:	e9 7a dd ff ff       	jmp    946788 <tokenize_c_raw_no_separators+0x19b8>
  948a0e:	b1 01                	mov    cl,0x1
  948a10:	e9 0d 02 00 00       	jmp    948c22 <tokenize_c_raw_no_separators+0x3e52>
  948a15:	c4 e2 c0 f5 c9       	bzhi   rcx,rcx,rdi
  948a1a:	48 f7 d1             	not    rcx
  948a1d:	48 89 8c 24 c0 04 00 	mov    QWORD PTR [rsp+0x4c0],rcx
  948a24:	00 
  948a25:	48 8d 4f c0          	lea    rcx,[rdi-0x40]
  948a29:	48 85 c9             	test   rcx,rcx
  948a2c:	7e 1a                	jle    948a48 <tokenize_c_raw_no_separators+0x3c78>
  948a2e:	48 83 f9 3f          	cmp    rcx,0x3f
  948a32:	76 05                	jbe    948a39 <tokenize_c_raw_no_separators+0x3c69>
  948a34:	45 31 c0             	xor    r8d,r8d
  948a37:	eb 0f                	jmp    948a48 <tokenize_c_raw_no_separators+0x3c78>
  948a39:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  948a40:	c4 62 f0 f5 c2       	bzhi   r8,rdx,rcx
  948a45:	49 f7 d0             	not    r8
  948a48:	4c 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],r9
  948a4d:	48 8d 4f 80          	lea    rcx,[rdi-0x80]
  948a51:	49 c7 c1 ff ff ff ff 	mov    r9,0xffffffffffffffff
  948a58:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  948a5f:	48 85 c9             	test   rcx,rcx
  948a62:	7e 12                	jle    948a76 <tokenize_c_raw_no_separators+0x3ca6>
  948a64:	48 83 f9 3f          	cmp    rcx,0x3f
  948a68:	76 04                	jbe    948a6e <tokenize_c_raw_no_separators+0x3c9e>
  948a6a:	31 d2                	xor    edx,edx
  948a6c:	eb 08                	jmp    948a76 <tokenize_c_raw_no_separators+0x3ca6>
  948a6e:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  948a73:	48 f7 d2             	not    rdx
  948a76:	48 8d 8f 40 ff ff ff 	lea    rcx,[rdi-0xc0]
  948a7d:	48 89 94 24 00 05 00 	mov    QWORD PTR [rsp+0x500],rdx
  948a84:	00 
  948a85:	48 85 c9             	test   rcx,rcx
  948a88:	7e 1a                	jle    948aa4 <tokenize_c_raw_no_separators+0x3cd4>
  948a8a:	48 83 f9 3f          	cmp    rcx,0x3f
  948a8e:	76 05                	jbe    948a95 <tokenize_c_raw_no_separators+0x3cc5>
  948a90:	45 31 c9             	xor    r9d,r9d
  948a93:	eb 0f                	jmp    948aa4 <tokenize_c_raw_no_separators+0x3cd4>
  948a95:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  948a9c:	c4 62 f0 f5 ca       	bzhi   r9,rdx,rcx
  948aa1:	49 f7 d1             	not    r9
  948aa4:	48 8d 8f 00 ff ff ff 	lea    rcx,[rdi-0x100]
  948aab:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
  948ab2:	49 c7 c3 ff ff ff ff 	mov    r11,0xffffffffffffffff
  948ab9:	48 85 c9             	test   rcx,rcx
  948abc:	7e 1a                	jle    948ad8 <tokenize_c_raw_no_separators+0x3d08>
  948abe:	48 83 f9 3f          	cmp    rcx,0x3f
  948ac2:	76 05                	jbe    948ac9 <tokenize_c_raw_no_separators+0x3cf9>
  948ac4:	45 31 db             	xor    r11d,r11d
  948ac7:	eb 0f                	jmp    948ad8 <tokenize_c_raw_no_separators+0x3d08>
  948ac9:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  948ad0:	c4 62 f0 f5 de       	bzhi   r11,rsi,rcx
  948ad5:	49 f7 d3             	not    r11
  948ad8:	48 8d 8f c0 fe ff ff 	lea    rcx,[rdi-0x140]
  948adf:	48 85 c9             	test   rcx,rcx
  948ae2:	7e 12                	jle    948af6 <tokenize_c_raw_no_separators+0x3d26>
  948ae4:	48 83 f9 3f          	cmp    rcx,0x3f
  948ae8:	76 04                	jbe    948aee <tokenize_c_raw_no_separators+0x3d1e>
  948aea:	31 d2                	xor    edx,edx
  948aec:	eb 08                	jmp    948af6 <tokenize_c_raw_no_separators+0x3d26>
  948aee:	c4 e2 f0 f5 d2       	bzhi   rdx,rdx,rcx
  948af3:	48 f7 d2             	not    rdx
  948af6:	4c 89 8c 24 00 01 00 	mov    QWORD PTR [rsp+0x100],r9
  948afd:	00 
  948afe:	4d 89 c1             	mov    r9,r8
  948b01:	4c 8d 87 80 fe ff ff 	lea    r8,[rdi-0x180]
  948b08:	48 c7 c1 ff ff ff ff 	mov    rcx,0xffffffffffffffff
  948b0f:	48 c7 c6 ff ff ff ff 	mov    rsi,0xffffffffffffffff
  948b16:	4d 85 c0             	test   r8,r8
  948b19:	7e 12                	jle    948b2d <tokenize_c_raw_no_separators+0x3d5d>
  948b1b:	49 83 f8 3f          	cmp    r8,0x3f
  948b1f:	76 04                	jbe    948b25 <tokenize_c_raw_no_separators+0x3d55>
  948b21:	31 f6                	xor    esi,esi
  948b23:	eb 08                	jmp    948b2d <tokenize_c_raw_no_separators+0x3d5d>
  948b25:	c4 e2 b8 f5 f6       	bzhi   rsi,rsi,r8
  948b2a:	48 f7 d6             	not    rsi
  948b2d:	4c 8b 44 24 60       	mov    r8,QWORD PTR [rsp+0x60]
  948b32:	48 81 c7 40 fe ff ff 	add    rdi,0xfffffffffffffe40
  948b39:	48 85 ff             	test   rdi,rdi
  948b3c:	7e 12                	jle    948b50 <tokenize_c_raw_no_separators+0x3d80>
  948b3e:	48 83 ff 3f          	cmp    rdi,0x3f
  948b42:	76 04                	jbe    948b48 <tokenize_c_raw_no_separators+0x3d78>
  948b44:	31 c9                	xor    ecx,ecx
  948b46:	eb 08                	jmp    948b50 <tokenize_c_raw_no_separators+0x3d80>
  948b48:	c4 e2 c0 f5 c9       	bzhi   rcx,rcx,rdi
  948b4d:	48 f7 d1             	not    rcx
  948b50:	48 8b bc 24 f0 03 00 	mov    rdi,QWORD PTR [rsp+0x3f0]
  948b57:	00 
  948b58:	48 2b 7c 24 48       	sub    rdi,QWORD PTR [rsp+0x48]
  948b5d:	48 85 ff             	test   rdi,rdi
  948b60:	7e 19                	jle    948b7b <tokenize_c_raw_no_separators+0x3dab>
  948b62:	48 83 ff 3f          	cmp    rdi,0x3f
  948b66:	77 16                	ja     948b7e <tokenize_c_raw_no_separators+0x3dae>
  948b68:	49 c7 c0 ff ff ff ff 	mov    r8,0xffffffffffffffff
  948b6f:	c4 42 c0 f5 f0       	bzhi   r14,r8,rdi
  948b74:	4c 8b 44 24 60       	mov    r8,QWORD PTR [rsp+0x60]
  948b79:	eb 03                	jmp    948b7e <tokenize_c_raw_no_separators+0x3dae>
  948b7b:	45 31 f6             	xor    r14d,r14d
  948b7e:	c5 fa 7e 84 24 c0 04 	vmovq  xmm0,QWORD PTR [rsp+0x4c0]
  948b85:	00 00 
  948b87:	40 b7 04             	mov    dil,0x4
  948b8a:	c5 fb 92 cf          	kmovd  k1,edi
  948b8e:	48 8b bc 24 00 05 00 	mov    rdi,QWORD PTR [rsp+0x500]
  948b95:	00 
  948b96:	c4 c3 f9 22 c9 01    	vpinsrq xmm1,xmm0,r9,0x1
  948b9c:	4c 8b 4c 24 48       	mov    r9,QWORD PTR [rsp+0x48]
  948ba1:	62 f3 7d 48 38 c1 00 	vinserti32x4 zmm0,zmm0,xmm1,0x0
  948ba8:	62 f2 fd 49 7c c7    	vpbroadcastq zmm0{k1},rdi
  948bae:	40 b7 08             	mov    dil,0x8
  948bb1:	c5 fb 92 cf          	kmovd  k1,edi
  948bb5:	48 8b bc 24 00 01 00 	mov    rdi,QWORD PTR [rsp+0x100]
  948bbc:	00 
  948bbd:	62 f2 fd 49 7c c7    	vpbroadcastq zmm0{k1},rdi
  948bc3:	40 b7 10             	mov    dil,0x10
  948bc6:	c5 fb 92 cf          	kmovd  k1,edi
  948bca:	40 b7 20             	mov    dil,0x20
  948bcd:	62 d2 fd 49 7c c3    	vpbroadcastq zmm0{k1},r11
  948bd3:	c5 fb 92 cf          	kmovd  k1,edi
  948bd7:	48 8b 7c 24 68       	mov    rdi,QWORD PTR [rsp+0x68]
  948bdc:	62 f2 fd 49 7c c2    	vpbroadcastq zmm0{k1},rdx
  948be2:	b2 40                	mov    dl,0x40
  948be4:	c5 fb 92 ca          	kmovd  k1,edx
  948be8:	b2 80                	mov    dl,0x80
  948bea:	62 f2 fd 49 7c c6    	vpbroadcastq zmm0{k1},rsi
  948bf0:	c5 fb 92 ca          	kmovd  k1,edx
  948bf4:	62 f2 fd 49 7c c1    	vpbroadcastq zmm0{k1},rcx
  948bfa:	62 91 fd 48 df ce    	vpandnq zmm1,zmm0,zmm30
  948c00:	e9 f6 d4 ff ff       	jmp    9460fb <tokenize_c_raw_no_separators+0x132b>
  948c05:	62 f2 7d 48 5a 05 e1 	vbroadcasti32x4 zmm0,XMMWORD PTR [rip+0xffffffffffae21e1]        # 42adf0 <c_testsuite_feature.marker+0x8ec>
  948c0c:	21 ae ff 
  948c0f:	62 f1 7d 48 74 42 08 	vpcmpeqb k0,zmm0,ZMMWORD PTR [rdx+0x200]
  948c16:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  948c1b:	23 8c 24 00 03 00 00 	and    ecx,DWORD PTR [rsp+0x300]
  948c22:	0f b6 d0             	movzx  edx,al
  948c25:	bf 02 00 00 00       	mov    edi,0x2
  948c2a:	62 e3 7d 28 39 c0 01 	vextracti32x4 xmm0,ymm16,0x1
  948c31:	29 d7                	sub    edi,edx
  948c33:	c4 e3 f9 16 c2 01    	vpextrq rdx,xmm0,0x1
  948c39:	f6 c2 01             	test   dl,0x1
  948c3c:	40 0f 94 c6          	sete   sil
  948c40:	40 08 ce             	or     sil,cl
  948c43:	b9 00 00 00 00       	mov    ecx,0x0
  948c48:	40 f6 c6 01          	test   sil,0x1
  948c4c:	0f 44 f9             	cmove  edi,ecx
  948c4f:	40 80 f6 01          	xor    sil,0x1
  948c53:	89 7c 24 60          	mov    DWORD PTR [rsp+0x60],edi
  948c57:	e9 b6 dc ff ff       	jmp    946912 <tokenize_c_raw_no_separators+0x1b42>
  948c5c:	4c 8b 74 24 58       	mov    r14,QWORD PTR [rsp+0x58]
  948c61:	62 f2 7d 48 5a 35 b5 	vbroadcasti32x4 zmm6,XMMWORD PTR [rip+0xffffffffffae20b5]        # 42ad20 <c_testsuite_feature.marker+0x81c>
  948c68:	20 ae ff 
  948c6b:	4c 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],r9
  948c70:	62 f1 fd 48 7f 54 24 	vmovdqa64 ZMMWORD PTR [rsp+0x800],zmm2
  948c77:	20 
  948c78:	62 f1 fd 48 7f 7c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x740],zmm7
  948c7f:	1d 
  948c80:	62 61 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x7c0],zmm24
  948c87:	1f 
  948c88:	62 e1 fd 48 7f 7c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x9c0],zmm23
  948c8f:	27 
  948c90:	62 e1 fd 48 7f 64 24 	vmovdqa64 ZMMWORD PTR [rsp+0x840],zmm20
  948c97:	21 
  948c98:	62 e1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x880],zmm17
  948c9f:	22 
  948ca0:	62 71 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x8c0],zmm13
  948ca7:	23 
  948ca8:	62 71 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0xa00],zmm11
  948caf:	28 
  948cb0:	62 61 fd 48 7f 74 24 	vmovdqa64 ZMMWORD PTR [rsp+0x100],zmm30
  948cb7:	04 
  948cb8:	c5 d1 ef ed          	vpxor  xmm5,xmm5,xmm5
  948cbc:	4c 89 94 24 d0 03 00 	mov    QWORD PTR [rsp+0x3d0],r10
  948cc3:	00 
  948cc4:	62 61 fd 48 7f 6c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x380],zmm29
  948ccb:	0e 
  948ccc:	62 d1 4d 48 74 06    	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14]
  948cd2:	c4 e1 fb 93 c0       	kmovq  rax,k0
  948cd7:	62 d1 4d 48 74 46 01 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x40]
  948cde:	c4 e1 f9 6e e0       	vmovq  xmm4,rax
  948ce3:	c4 e1 fb 93 c8       	kmovq  rcx,k0
  948ce8:	62 d1 4d 48 74 46 02 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x80]
  948cef:	c4 e1 fb 93 d0       	kmovq  rdx,k0
  948cf4:	62 d1 4d 48 74 46 03 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0xc0]
  948cfb:	c4 e1 fb 93 f0       	kmovq  rsi,k0
  948d00:	62 d1 4d 48 74 46 04 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x100]
  948d07:	c4 e1 fb 93 f8       	kmovq  rdi,k0
  948d0c:	62 d1 4d 48 74 46 05 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x140]
  948d13:	c4 e1 f9 6e df       	vmovq  xmm3,rdi
  948d18:	c4 61 fb 93 c0       	kmovq  r8,k0
  948d1d:	62 d1 4d 48 74 46 06 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x180]
  948d24:	c4 61 fb 93 c8       	kmovq  r9,k0
  948d29:	62 d1 4d 48 74 46 07 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x1c0]
  948d30:	c4 c1 f9 6e d1       	vmovq  xmm2,r9
  948d35:	c4 61 fb 93 d8       	kmovq  r11,k0
  948d3a:	62 d1 4d 48 74 46 08 	vpcmpeqb k0,zmm6,ZMMWORD PTR [r14+0x200]
  948d41:	c4 c1 f9 6e c3       	vmovq  xmm0,r11
  948d46:	4c 89 9c 24 c0 03 00 	mov    QWORD PTR [rsp+0x3c0],r11
  948d4d:	00 
  948d4e:	c5 e9 6c c0          	vpunpcklqdq xmm0,xmm2,xmm0
  948d52:	c4 c1 f9 6e d0       	vmovq  xmm2,r8
  948d57:	c5 e1 6c d2          	vpunpcklqdq xmm2,xmm3,xmm2
  948d5b:	c4 e1 f9 6e da       	vmovq  xmm3,rdx
  948d60:	c4 e3 6d 38 c0 01    	vinserti128 ymm0,ymm2,xmm0,0x1
  948d66:	c4 e1 f9 6e d6       	vmovq  xmm2,rsi
  948d6b:	c5 e1 6c d2          	vpunpcklqdq xmm2,xmm3,xmm2
  948d6f:	c4 e1 f9 6e d9       	vmovq  xmm3,rcx
  948d74:	c5 d9 6c db          	vpunpcklqdq xmm3,xmm4,xmm3
  948d78:	c4 e3 65 38 d2 01    	vinserti128 ymm2,ymm3,xmm2,0x1
  948d7e:	62 91 fd 48 6f dd    	vmovdqa64 zmm3,zmm29
  948d84:	62 f2 9d 40 7e 5c 24 	vpermt2q zmm3,zmm28,ZMMWORD PTR [rsp+0x480]
  948d8b:	12 
  948d8c:	62 f3 ed 48 3a d0 01 	vinserti64x4 zmm2,zmm2,ymm0,0x1
  948d93:	c4 e1 fb 93 c0       	kmovq  rax,k0
  948d98:	62 f1 ed 48 df c1    	vpandnq zmm0,zmm2,zmm1
  948d9e:	c4 e1 f9 6e c8       	vmovq  xmm1,rax
  948da3:	62 f3 f5 48 03 ca 01 	valignq zmm1,zmm1,zmm2,0x1
  948daa:	62 f3 f5 48 71 ca 3f 	vpshldq zmm1,zmm1,zmm2,0x3f
  948db1:	62 f3 95 40 71 db 01 	vpshldq zmm3,zmm29,zmm3,0x1
  948db8:	62 f1 e5 48 db c9    	vpandq zmm1,zmm3,zmm1
  948dbe:	62 f1 fd 48 7f 5c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x700],zmm3
  948dc5:	1c 
  948dc6:	62 f2 75 48 27 c0    	vptestmd k0,zmm1,zmm0
  948dcc:	c5 f8 98 c0          	kortestw k0,k0
  948dd0:	0f 85 8b 0c 00 00    	jne    949a61 <tokenize_c_raw_no_separators+0x4c91>
  948dd6:	62 f1 fd 48 6f 64 24 	vmovdqa64 zmm4,ZMMWORD PTR [rsp+0x700]
  948ddd:	1c 
  948dde:	62 f1 fd 48 6f 1d d8 	vmovdqa64 zmm3,ZMMWORD PTR [rip+0xffffffffffabe3d8]        # 4071c0 <__abi_tag+0x6604>
  948de5:	e3 ab ff 
  948de8:	62 f1 ed 48 db cc    	vpandq zmm1,zmm2,zmm4
  948dee:	62 f1 fd 48 6f d1    	vmovdqa64 zmm2,zmm1
  948df4:	62 f2 e5 48 7e 54 24 	vpermt2q zmm2,zmm3,ZMMWORD PTR [rsp+0x480]
  948dfb:	12 
  948dfc:	48 c7 84 24 80 04 00 	mov    QWORD PTR [rsp+0x480],0x0
  948e03:	00 00 00 00 00 
  948e08:	62 f3 f5 48 71 ca 01 	vpshldq zmm1,zmm1,zmm2,0x1
  948e0f:	62 f1 f5 48 db c0    	vpandq zmm0,zmm1,zmm0
  948e15:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x740]
  948e1c:	1d 
  948e1d:	62 f3 dd 48 25 44 24 	vpternlogq zmm0,zmm4,ZMMWORD PTR [rsp+0x380],0xfe
  948e24:	0e fe 
  948e26:	62 f3 f5 48 03 d5 07 	valignq zmm2,zmm1,zmm5,0x7
  948e2d:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x980],zmm0
  948e34:	26 
  948e35:	62 f3 f5 48 71 c2 01 	vpshldq zmm0,zmm1,zmm2,0x1
  948e3c:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x900],zmm0
  948e43:	24 
  948e44:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  948e48:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x280],zmm0
  948e4f:	0a 
  948e50:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0x240],zmm0
  948e57:	09 
  948e58:	eb 1d                	jmp    948e77 <tokenize_c_raw_no_separators+0x40a7>
  948e5a:	48 8b 84 24 80 04 00 	mov    rax,QWORD PTR [rsp+0x480]
  948e61:	00 
  948e62:	48 ff c0             	inc    rax
  948e65:	48 89 84 24 80 04 00 	mov    QWORD PTR [rsp+0x480],rax
  948e6c:	00 
  948e6d:	48 83 f8 08          	cmp    rax,0x8
  948e71:	0f 84 12 0a 00 00    	je     949889 <tokenize_c_raw_no_separators+0x4ab9>
  948e77:	62 f1 7c 48 28 44 24 	vmovaps zmm0,ZMMWORD PTR [rsp+0x380]
  948e7e:	0e 
  948e7f:	48 8b 84 24 80 04 00 	mov    rax,QWORD PTR [rsp+0x480]
  948e86:	00 
  948e87:	8d 04 c5 00 00 00 00 	lea    eax,[rax*8+0x0]
  948e8e:	83 e0 38             	and    eax,0x38
  948e91:	62 f1 7c 48 29 44 24 	vmovaps ZMMWORD PTR [rsp+0xc00],zmm0
  948e98:	30 
  948e99:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x900]
  948ea0:	24 
  948ea1:	62 f1 fd 48 7f 44 24 	vmovdqa64 ZMMWORD PTR [rsp+0xc40],zmm0
  948ea8:	31 
  948ea9:	48 8b 8c 04 40 0c 00 	mov    rcx,QWORD PTR [rsp+rax*1+0xc40]
  948eb0:	00 
  948eb1:	c4 62 f0 f2 94 04 00 	andn   r10,rcx,QWORD PTR [rsp+rax*1+0xc00]
  948eb8:	0c 00 00 
  948ebb:	74 9d                	je     948e5a <tokenize_c_raw_no_separators+0x408a>
  948ebd:	4c 8b 84 24 80 04 00 	mov    r8,QWORD PTR [rsp+0x480]
  948ec4:	00 
  948ec5:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  948eca:	48 8b 4c 24 38       	mov    rcx,QWORD PTR [rsp+0x38]
  948ecf:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  948ed4:	4c 8b 4c 24 28       	mov    r9,QWORD PTR [rsp+0x28]
  948ed9:	49 c1 e0 06          	shl    r8,0x6
  948edd:	48 01 c8             	add    rax,rcx
  948ee0:	49 01 c0             	add    r8,rax
  948ee3:	4c 89 44 24 70       	mov    QWORD PTR [rsp+0x70],r8
  948ee8:	eb 5d                	jmp    948f47 <tokenize_c_raw_no_separators+0x4177>
  948eea:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x240]
  948ef1:	09 
  948ef2:	62 f2 fd 48 7c c1    	vpbroadcastq zmm0,rcx
  948ef8:	62 f2 fd 48 29 0d fe 	vpcmpeqq k1,zmm0,ZMMWORD PTR [rip+0xffffffffffabe2fe]        # 407200 <__abi_tag+0x6644>
  948eff:	e2 ab ff 
  948f02:	31 c0                	xor    eax,eax
  948f04:	c4 c2 f8 f3 da       	blsi   rax,r10
  948f09:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0xb80],zmm1
  948f10:	2e 
  948f11:	48 8b 94 24 80 04 00 	mov    rdx,QWORD PTR [rsp+0x480]
  948f18:	00 
  948f19:	83 e2 07             	and    edx,0x7
  948f1c:	48 0b 84 d4 80 0b 00 	or     rax,QWORD PTR [rsp+rdx*8+0xb80]
  948f23:	00 
  948f24:	62 f2 fd 49 7c c8    	vpbroadcastq zmm1{k1},rax
  948f2a:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x240],zmm1
  948f31:	09 
  948f32:	4c 8b 4c 24 28       	mov    r9,QWORD PTR [rsp+0x28]
  948f37:	4c 8b 44 24 70       	mov    r8,QWORD PTR [rsp+0x70]
  948f3c:	c4 c2 a8 f3 ca       	blsr   r10,r10
  948f41:	0f 84 13 ff ff ff    	je     948e5a <tokenize_c_raw_no_separators+0x408a>
  948f47:	31 c9                	xor    ecx,ecx
  948f49:	f3 49 0f bc ca       	tzcnt  rcx,r10
  948f4e:	41 b6 0a             	mov    r14b,0xa
  948f51:	49 8d 44 08 ff       	lea    rax,[r8+rcx*1-0x1]
  948f56:	48 39 f0             	cmp    rax,rsi
  948f59:	0f 9c c2             	setl   dl
  948f5c:	4c 39 c8             	cmp    rax,r9
  948f5f:	40 0f 9d c7          	setge  dil
  948f63:	40 08 d7             	or     dil,dl
  948f66:	75 0a                	jne    948f72 <tokenize_c_raw_no_separators+0x41a2>
  948f68:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
  948f6d:	44 0f b6 34 02       	movzx  r14d,BYTE PTR [rdx+rax*1]
  948f72:	4c 01 c1             	add    rcx,r8
  948f75:	ba 02 00 00 00       	mov    edx,0x2
  948f7a:	48 8d 41 01          	lea    rax,[rcx+0x1]
  948f7e:	48 39 f0             	cmp    rax,rsi
  948f81:	40 0f 9c c7          	setl   dil
  948f85:	4c 39 c8             	cmp    rax,r9
  948f88:	41 0f 9d c0          	setge  r8b
  948f8c:	41 08 f8             	or     r8b,dil
  948f8f:	75 3c                	jne    948fcd <tokenize_c_raw_no_separators+0x41fd>
  948f91:	48 8b 7c 24 50       	mov    rdi,QWORD PTR [rsp+0x50]
  948f96:	80 3c 07 0d          	cmp    BYTE PTR [rdi+rax*1],0xd
  948f9a:	75 31                	jne    948fcd <tokenize_c_raw_no_separators+0x41fd>
  948f9c:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  948fa3:	0a 
  948fa4:	48 8d 41 02          	lea    rax,[rcx+0x2]
  948fa8:	48 39 f0             	cmp    rax,rsi
  948fab:	40 0f 9c c7          	setl   dil
  948faf:	4c 39 c8             	cmp    rax,r9
  948fb2:	41 0f 9d c0          	setge  r8b
  948fb6:	41 08 f8             	or     r8b,dil
  948fb9:	75 0b                	jne    948fc6 <tokenize_c_raw_no_separators+0x41f6>
  948fbb:	48 8b 7c 24 50       	mov    rdi,QWORD PTR [rsp+0x50]
  948fc0:	80 3c 07 0a          	cmp    BYTE PTR [rdi+rax*1],0xa
  948fc4:	75 0f                	jne    948fd5 <tokenize_c_raw_no_separators+0x4205>
  948fc6:	ba 03 00 00 00       	mov    edx,0x3
  948fcb:	eb 08                	jmp    948fd5 <tokenize_c_raw_no_separators+0x4205>
  948fcd:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  948fd4:	0a 
  948fd5:	48 01 ca             	add    rdx,rcx
  948fd8:	b0 0a                	mov    al,0xa
  948fda:	48 39 f2             	cmp    rdx,rsi
  948fdd:	40 0f 9c c7          	setl   dil
  948fe1:	4c 39 ca             	cmp    rdx,r9
  948fe4:	41 0f 9d c0          	setge  r8b
  948fe8:	41 08 f8             	or     r8b,dil
  948feb:	75 09                	jne    948ff6 <tokenize_c_raw_no_separators+0x4226>
  948fed:	48 8b 44 24 50       	mov    rax,QWORD PTR [rsp+0x50]
  948ff2:	0f b6 04 10          	movzx  eax,BYTE PTR [rax+rdx*1]
  948ff6:	45 0f b6 de          	movzx  r11d,r14b
  948ffa:	4c 89 9c 24 80 00 00 	mov    QWORD PTR [rsp+0x80],r11
  949001:	00 
  949002:	41 80 fb 5c          	cmp    r11b,0x5c
  949006:	0f 84 58 01 00 00    	je     949164 <tokenize_c_raw_no_separators+0x4394>
  94900c:	41 83 fb 27          	cmp    r11d,0x27
  949010:	0f 84 4e 01 00 00    	je     949164 <tokenize_c_raw_no_separators+0x4394>
  949016:	48 83 c1 fe          	add    rcx,0xfffffffffffffffe
  94901a:	41 b0 0a             	mov    r8b,0xa
  94901d:	48 39 f1             	cmp    rcx,rsi
  949020:	0f 9c c2             	setl   dl
  949023:	4c 39 c9             	cmp    rcx,r9
  949026:	40 0f 9d c7          	setge  dil
  94902a:	40 08 d7             	or     dil,dl
  94902d:	75 0a                	jne    949039 <tokenize_c_raw_no_separators+0x4269>
  94902f:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
  949034:	44 0f b6 04 0a       	movzx  r8d,BYTE PTR [rdx+rcx*1]
  949039:	40 b7 01             	mov    dil,0x1
  94903c:	41 b1 01             	mov    r9b,0x1
  94903f:	45 84 f6             	test   r14b,r14b
  949042:	78 0c                	js     949050 <tokenize_c_raw_no_separators+0x4280>
  949044:	48 8d 0d f5 9f ac ff 	lea    rcx,[rip+0xffffffffffac9ff5]        # 413040 <c_char_properties>
  94904b:	45 0f b6 0c 0b       	movzx  r9d,BYTE PTR [r11+rcx*1]
  949050:	8b 8c 24 80 04 00 00 	mov    ecx,DWORD PTR [rsp+0x480]
  949057:	0f b6 d0             	movzx  edx,al
  94905a:	84 c0                	test   al,al
  94905c:	78 13                	js     949071 <tokenize_c_raw_no_separators+0x42a1>
  94905e:	3c 5c                	cmp    al,0x5c
  949060:	0f 84 39 02 00 00    	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  949066:	48 8d 3d d3 9f ac ff 	lea    rdi,[rip+0xffffffffffac9fd3]        # 413040 <c_char_properties>
  94906d:	0f b6 3c 3a          	movzx  edi,BYTE PTR [rdx+rdi*1]
  949071:	41 f6 c1 01          	test   r9b,0x1
  949075:	74 69                	je     9490e0 <tokenize_c_raw_no_separators+0x4310>
  949077:	45 8d 4e bb          	lea    r9d,[r14-0x45]
  94907b:	41 80 f9 2c          	cmp    r9b,0x2c
  94907f:	41 0f 92 c0          	setb   r8b
  949083:	40 f6 c7 01          	test   dil,0x1
  949087:	0f 85 12 02 00 00    	jne    94929f <tokenize_c_raw_no_separators+0x44cf>
  94908d:	3c 2e                	cmp    al,0x2e
  94908f:	77 14                	ja     9490a5 <tokenize_c_raw_no_separators+0x42d5>
  949091:	48 bf 00 00 00 00 84 	movabs rdi,0x408400000000
  949098:	40 00 00 
  94909b:	48 0f a3 d7          	bt     rdi,rdx
  94909f:	0f 82 fa 01 00 00    	jb     94929f <tokenize_c_raw_no_separators+0x44cf>
  9490a5:	48 be 01 08 00 00 01 	movabs rsi,0x80100000801
  9490ac:	08 00 00 
  9490af:	c4 e2 b3 f7 f6       	shrx   rsi,rsi,r9
  9490b4:	41 20 f0             	and    r8b,sil
  9490b7:	0f 84 66 02 00 00    	je     949323 <tokenize_c_raw_no_separators+0x4553>
  9490bd:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  9490c4:	0a 
  9490c5:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  9490ca:	3c 2b                	cmp    al,0x2b
  9490cc:	0f 84 cd 01 00 00    	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  9490d2:	83 fa 2d             	cmp    edx,0x2d
  9490d5:	0f 84 c4 01 00 00    	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  9490db:	e9 f8 01 00 00       	jmp    9492d8 <tokenize_c_raw_no_separators+0x4508>
  9490e0:	41 80 fe 2b          	cmp    r14b,0x2b
  9490e4:	74 25                	je     94910b <tokenize_c_raw_no_separators+0x433b>
  9490e6:	83 bc 24 80 00 00 00 	cmp    DWORD PTR [rsp+0x80],0x2e
  9490ed:	2e 
  9490ee:	0f 84 ba 00 00 00    	je     9491ae <tokenize_c_raw_no_separators+0x43de>
  9490f4:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  9490fb:	0a 
  9490fc:	83 bc 24 80 00 00 00 	cmp    DWORD PTR [rsp+0x80],0x2d
  949103:	2d 
  949104:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  949109:	75 39                	jne    949144 <tokenize_c_raw_no_separators+0x4374>
  94910b:	45 0f b6 c0          	movzx  r8d,r8b
  94910f:	41 83 c0 bb          	add    r8d,0xffffffbb
  949113:	41 83 f8 2b          	cmp    r8d,0x2b
  949117:	77 2b                	ja     949144 <tokenize_c_raw_no_separators+0x4374>
  949119:	49 b9 01 08 00 00 01 	movabs r9,0x80100000801
  949120:	08 00 00 
  949123:	4d 0f a3 c1          	bt     r9,r8
  949127:	73 1b                	jae    949144 <tokenize_c_raw_no_separators+0x4374>
  949129:	40 f6 c7 01          	test   dil,0x1
  94912d:	0f 85 6c 01 00 00    	jne    94929f <tokenize_c_raw_no_separators+0x44cf>
  949133:	3c 27                	cmp    al,0x27
  949135:	0f 84 64 01 00 00    	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  94913b:	83 fa 2e             	cmp    edx,0x2e
  94913e:	0f 84 5b 01 00 00    	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  949144:	4c 89 94 24 00 06 00 	mov    QWORD PTR [rsp+0x600],r10
  94914b:	00 
  94914c:	4d 89 f3             	mov    r11,r14
  94914f:	84 c0                	test   al,al
  949151:	0f 88 84 00 00 00    	js     9491db <tokenize_c_raw_no_separators+0x440b>
  949157:	48 8d 35 62 9f ac ff 	lea    rsi,[rip+0xffffffffffac9f62]        # 4130c0 <c_operator_classes>
  94915e:	0f b6 34 32          	movzx  esi,BYTE PTR [rdx+rsi*1]
  949162:	eb 79                	jmp    9491dd <tokenize_c_raw_no_separators+0x440d>
  949164:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  949169:	48 8b 4c 24 38       	mov    rcx,QWORD PTR [rsp+0x38]
  94916e:	4c 8b 45 18          	mov    r8,QWORD PTR [rbp+0x18]
  949172:	4c 8b 4d 20          	mov    r9,QWORD PTR [rbp+0x20]
  949176:	48 8d bc 24 c0 2b 00 	lea    rdi,[rsp+0x2bc0]
  94917d:	00 
  94917e:	4c 89 b4 24 70 01 00 	mov    QWORD PTR [rsp+0x170],r14
  949185:	00 
  949186:	4d 89 d6             	mov    r14,r10
  949189:	48 8d 14 01          	lea    rdx,[rcx+rax*1]
  94918d:	48 8b 4d 10          	mov    rcx,QWORD PTR [rbp+0x10]
  949191:	c5 f8 77             	vzeroupper
  949194:	e8 07 39 21 01       	call   1b5caa0 <needs_scalar>
  949199:	4d 89 f2             	mov    r10,r14
  94919c:	4c 8b b4 24 70 01 00 	mov    r14,QWORD PTR [rsp+0x170]
  9491a3:	00 
  9491a4:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  9491a9:	e9 4e 01 00 00       	jmp    9492fc <tokenize_c_raw_no_separators+0x452c>
  9491ae:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  9491b5:	0a 
  9491b6:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  9491bb:	40 f6 c7 01          	test   dil,0x1
  9491bf:	0f 85 da 00 00 00    	jne    94929f <tokenize_c_raw_no_separators+0x44cf>
  9491c5:	3c 27                	cmp    al,0x27
  9491c7:	0f 84 d2 00 00 00    	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  9491cd:	83 fa 2e             	cmp    edx,0x2e
  9491d0:	0f 84 c9 00 00 00    	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  9491d6:	e9 57 fd ff ff       	jmp    948f32 <tokenize_c_raw_no_separators+0x4162>
  9491db:	31 f6                	xor    esi,esi
  9491dd:	48 8b bc 24 80 00 00 	mov    rdi,QWORD PTR [rsp+0x80]
  9491e4:	00 
  9491e5:	83 e7 7f             	and    edi,0x7f
  9491e8:	4c 8d 05 d1 9e ac ff 	lea    r8,[rip+0xffffffffffac9ed1]        # 4130c0 <c_operator_classes>
  9491ef:	41 89 f1             	mov    r9d,esi
  9491f2:	41 83 e1 0f          	and    r9d,0xf
  9491f6:	4c 8d 15 c3 31 ae ff 	lea    r10,[rip+0xffffffffffae31c3]        # 42c3c0 <c_second_char_channels>
  9491fd:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  949204:	0a 
  949205:	4d 89 de             	mov    r14,r11
  949208:	42 0f b6 3c 07       	movzx  edi,BYTE PTR [rdi+r8*1]
  94920d:	47 0f b6 0c 11       	movzx  r9d,BYTE PTR [r9+r10*1]
  949212:	4c 8d 15 e7 31 ae ff 	lea    r10,[rip+0xffffffffffae31e7]        # 42c400 <c_first_char_channels>
  949219:	41 89 f8             	mov    r8d,edi
  94921c:	41 83 e0 0f          	and    r8d,0xf
  949220:	47 22 0c 10          	and    r9b,BYTE PTR [r8+r10*1]
  949224:	4c 8b 94 24 00 06 00 	mov    r10,QWORD PTR [rsp+0x600]
  94922b:	00 
  94922c:	45 0f b6 c1          	movzx  r8d,r9b
  949230:	41 80 e1 f1          	and    r9b,0xf1
  949234:	39 fe                	cmp    esi,edi
  949236:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  94923b:	41 0f b6 f9          	movzx  edi,r9b
  94923f:	41 0f 44 f8          	cmove  edi,r8d
  949243:	45 84 f6             	test   r14b,r14b
  949246:	78 05                	js     94924d <tokenize_c_raw_no_separators+0x447d>
  949248:	40 84 ff             	test   dil,dil
  94924b:	75 52                	jne    94929f <tokenize_c_raw_no_separators+0x44cf>
  94924d:	41 80 fe 2f          	cmp    r14b,0x2f
  949251:	75 26                	jne    949279 <tokenize_c_raw_no_separators+0x44a9>
  949253:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  94925a:	0a 
  94925b:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  949260:	4c 8b 94 24 00 06 00 	mov    r10,QWORD PTR [rsp+0x600]
  949267:	00 
  949268:	4d 89 de             	mov    r14,r11
  94926b:	3c 2a                	cmp    al,0x2a
  94926d:	74 30                	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  94926f:	83 fa 2f             	cmp    edx,0x2f
  949272:	74 2b                	je     94929f <tokenize_c_raw_no_separators+0x44cf>
  949274:	e9 b9 fc ff ff       	jmp    948f32 <tokenize_c_raw_no_separators+0x4162>
  949279:	41 80 fb 3a          	cmp    r11b,0x3a
  94927d:	0f 85 af 00 00 00    	jne    949332 <tokenize_c_raw_no_separators+0x4562>
  949283:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  94928a:	0a 
  94928b:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  949290:	4c 8b 94 24 00 06 00 	mov    r10,QWORD PTR [rsp+0x600]
  949297:	00 
  949298:	4d 89 de             	mov    r14,r11
  94929b:	3c 25                	cmp    al,0x25
  94929d:	75 39                	jne    9492d8 <tokenize_c_raw_no_separators+0x4508>
  94929f:	62 f2 fd 48 7c c1    	vpbroadcastq zmm0,rcx
  9492a5:	62 f2 fd 48 29 0d 51 	vpcmpeqq k1,zmm0,ZMMWORD PTR [rip+0xffffffffffabdf51]        # 407200 <__abi_tag+0x6644>
  9492ac:	df ab ff 
  9492af:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0xbc0],zmm1
  9492b6:	2f 
  9492b7:	31 ff                	xor    edi,edi
  9492b9:	c4 c2 c0 f3 da       	blsi   rdi,r10
  9492be:	4c 8b 84 24 80 04 00 	mov    r8,QWORD PTR [rsp+0x480]
  9492c5:	00 
  9492c6:	41 83 e0 07          	and    r8d,0x7
  9492ca:	4a 0b bc c4 c0 0b 00 	or     rdi,QWORD PTR [rsp+r8*8+0xbc0]
  9492d1:	00 
  9492d2:	62 f2 fd 49 7c cf    	vpbroadcastq zmm1{k1},rdi
  9492d8:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x280],zmm1
  9492df:	0a 
  9492e0:	41 80 fe 2a          	cmp    r14b,0x2a
  9492e4:	75 16                	jne    9492fc <tokenize_c_raw_no_separators+0x452c>
  9492e6:	3c 5c                	cmp    al,0x5c
  9492e8:	0f 84 fc fb ff ff    	je     948eea <tokenize_c_raw_no_separators+0x411a>
  9492ee:	83 fa 2f             	cmp    edx,0x2f
  9492f1:	0f 84 f3 fb ff ff    	je     948eea <tokenize_c_raw_no_separators+0x411a>
  9492f7:	e9 36 fc ff ff       	jmp    948f32 <tokenize_c_raw_no_separators+0x4162>
  9492fc:	4c 8b 4c 24 28       	mov    r9,QWORD PTR [rsp+0x28]
  949301:	4c 8b 44 24 70       	mov    r8,QWORD PTR [rsp+0x70]
  949306:	41 80 fe 27          	cmp    r14b,0x27
  94930a:	0f 84 1d 07 00 00    	je     949a2d <tokenize_c_raw_no_separators+0x4c5d>
  949310:	83 bc 24 80 00 00 00 	cmp    DWORD PTR [rsp+0x80],0x5c
  949317:	5c 
  949318:	0f 85 1e fc ff ff    	jne    948f3c <tokenize_c_raw_no_separators+0x416c>
  94931e:	e9 0a 07 00 00       	jmp    949a2d <tokenize_c_raw_no_separators+0x4c5d>
  949323:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  94932a:	0a 
  94932b:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  949330:	eb a6                	jmp    9492d8 <tokenize_c_raw_no_separators+0x4508>
  949332:	62 f1 fd 48 6f 4c 24 	vmovdqa64 zmm1,ZMMWORD PTR [rsp+0x280]
  949339:	0a 
  94933a:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  94933f:	4c 8b 94 24 00 06 00 	mov    r10,QWORD PTR [rsp+0x600]
  949346:	00 
  949347:	4d 89 de             	mov    r14,r11
  94934a:	eb 8c                	jmp    9492d8 <tokenize_c_raw_no_separators+0x4508>
  94934c:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  949351:	c4 e1 f9 7e ca       	vmovq  rdx,xmm1
  949356:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  94935d:	00 00 00 
  949360:	62 01 fd 48 6f c8    	vmovdqa64 zmm25,zmm24
  949366:	62 a1 fd 48 6f f7    	vmovdqa64 zmm22,zmm23
  94936c:	62 e1 fd 48 6f ea    	vmovdqa64 zmm21,zmm2
  949372:	62 a1 fd 48 6f dc    	vmovdqa64 zmm19,zmm20
  949378:	62 a1 fd 48 6f d1    	vmovdqa64 zmm18,zmm17
  94937e:	62 51 fd 48 6f e5    	vmovdqa64 zmm12,zmm13
  949384:	62 51 fd 48 6f d3    	vmovdqa64 zmm10,zmm11
  94938a:	62 51 fd 48 6f cf    	vmovdqa64 zmm9,zmm15
  949390:	62 d1 fd 48 6f fe    	vmovdqa64 zmm7,zmm14
  949396:	62 f1 fd 48 6f f5    	vmovdqa64 zmm6,zmm5
  94939c:	62 91 fd 48 6f e5    	vmovdqa64 zmm4,zmm29
  9493a2:	62 91 fd 48 6f de    	vmovdqa64 zmm3,zmm30
  9493a8:	4c 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],r9
  9493ad:	4c 89 d1             	mov    rcx,r10
  9493b0:	48 85 d2             	test   rdx,rdx
  9493b3:	74 63                	je     949418 <tokenize_c_raw_no_separators+0x4648>
  9493b5:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  9493ba:	4c 8b 44 24 38       	mov    r8,QWORD PTR [rsp+0x38]
  9493bf:	4c 01 c7             	add    rdi,r8
  9493c2:	48 ff c7             	inc    rdi
  9493c5:	eb 17                	jmp    9493de <tokenize_c_raw_no_separators+0x460e>
  9493c7:	41 b8 00 24 00 00    	mov    r8d,0x2400
  9493cd:	4d 0f a3 d0          	bt     r8,r10
  9493d1:	0f 82 8f 06 00 00    	jb     949a66 <tokenize_c_raw_no_separators+0x4c96>
  9493d7:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  9493dc:	74 3a                	je     949418 <tokenize_c_raw_no_separators+0x4648>
  9493de:	45 31 c0             	xor    r8d,r8d
  9493e1:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  9493e6:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  9493ea:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  9493ef:	7d e6                	jge    9493d7 <tokenize_c_raw_no_separators+0x4607>
  9493f1:	4c 03 84 24 c0 01 00 	add    r8,QWORD PTR [rsp+0x1c0]
  9493f8:	00 
  9493f9:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  9493fd:	49 83 fa 20          	cmp    r10,0x20
  949401:	77 d4                	ja     9493d7 <tokenize_c_raw_no_separators+0x4607>
  949403:	4d 0f a3 d3          	bt     r11,r10
  949407:	73 be                	jae    9493c7 <tokenize_c_raw_no_separators+0x45f7>
  949409:	49 ff c1             	inc    r9
  94940c:	49 ff c0             	inc    r8
  94940f:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  949414:	7c e3                	jl     9493f9 <tokenize_c_raw_no_separators+0x4629>
  949416:	eb bf                	jmp    9493d7 <tokenize_c_raw_no_separators+0x4607>
  949418:	c4 e3 f9 16 ca 01    	vpextrq rdx,xmm1,0x1
  94941e:	48 85 d2             	test   rdx,rdx
  949421:	74 70                	je     949493 <tokenize_c_raw_no_separators+0x46c3>
  949423:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  949428:	4c 8b 44 24 38       	mov    r8,QWORD PTR [rsp+0x38]
  94942d:	4c 01 c7             	add    rdi,r8
  949430:	48 83 c7 41          	add    rdi,0x41
  949434:	eb 23                	jmp    949459 <tokenize_c_raw_no_separators+0x4689>
  949436:	41 83 f8 02          	cmp    r8d,0x2
  94943a:	0f 95 c0             	setne  al
  94943d:	e9 3e e0 ff ff       	jmp    947480 <tokenize_c_raw_no_separators+0x26b0>
  949442:	41 b8 00 24 00 00    	mov    r8d,0x2400
  949448:	4d 0f a3 d0          	bt     r8,r10
  94944c:	0f 82 14 06 00 00    	jb     949a66 <tokenize_c_raw_no_separators+0x4c96>
  949452:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  949457:	74 3a                	je     949493 <tokenize_c_raw_no_separators+0x46c3>
  949459:	45 31 c0             	xor    r8d,r8d
  94945c:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  949461:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  949465:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  94946a:	7d e6                	jge    949452 <tokenize_c_raw_no_separators+0x4682>
  94946c:	4c 03 84 24 b8 01 00 	add    r8,QWORD PTR [rsp+0x1b8]
  949473:	00 
  949474:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  949478:	49 83 fa 20          	cmp    r10,0x20
  94947c:	77 d4                	ja     949452 <tokenize_c_raw_no_separators+0x4682>
  94947e:	4d 0f a3 d3          	bt     r11,r10
  949482:	73 be                	jae    949442 <tokenize_c_raw_no_separators+0x4672>
  949484:	49 ff c1             	inc    r9
  949487:	49 ff c0             	inc    r8
  94948a:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  94948f:	7c e3                	jl     949474 <tokenize_c_raw_no_separators+0x46a4>
  949491:	eb bf                	jmp    949452 <tokenize_c_raw_no_separators+0x4682>
  949493:	c4 e3 7d 39 c8 01    	vextracti128 xmm0,ymm1,0x1
  949499:	c4 e1 f9 7e c2       	vmovq  rdx,xmm0
  94949e:	48 85 d2             	test   rdx,rdx
  9494a1:	74 67                	je     94950a <tokenize_c_raw_no_separators+0x473a>
  9494a3:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  9494a8:	4c 8b 44 24 38       	mov    r8,QWORD PTR [rsp+0x38]
  9494ad:	4c 01 c7             	add    rdi,r8
  9494b0:	48 81 c7 81 00 00 00 	add    rdi,0x81
  9494b7:	eb 17                	jmp    9494d0 <tokenize_c_raw_no_separators+0x4700>
  9494b9:	41 b8 00 24 00 00    	mov    r8d,0x2400
  9494bf:	4d 0f a3 d0          	bt     r8,r10
  9494c3:	0f 82 9d 05 00 00    	jb     949a66 <tokenize_c_raw_no_separators+0x4c96>
  9494c9:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  9494ce:	74 3a                	je     94950a <tokenize_c_raw_no_separators+0x473a>
  9494d0:	45 31 c0             	xor    r8d,r8d
  9494d3:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  9494d8:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  9494dc:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  9494e1:	7d e6                	jge    9494c9 <tokenize_c_raw_no_separators+0x46f9>
  9494e3:	4c 03 84 24 b0 01 00 	add    r8,QWORD PTR [rsp+0x1b0]
  9494ea:	00 
  9494eb:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  9494ef:	49 83 fa 20          	cmp    r10,0x20
  9494f3:	77 d4                	ja     9494c9 <tokenize_c_raw_no_separators+0x46f9>
  9494f5:	4d 0f a3 d3          	bt     r11,r10
  9494f9:	73 be                	jae    9494b9 <tokenize_c_raw_no_separators+0x46e9>
  9494fb:	49 ff c1             	inc    r9
  9494fe:	49 ff c0             	inc    r8
  949501:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  949506:	7c e3                	jl     9494eb <tokenize_c_raw_no_separators+0x471b>
  949508:	eb bf                	jmp    9494c9 <tokenize_c_raw_no_separators+0x46f9>
  94950a:	c4 e3 7d 39 c8 01    	vextracti128 xmm0,ymm1,0x1
  949510:	c4 e3 f9 16 c2 01    	vpextrq rdx,xmm0,0x1
  949516:	48 85 d2             	test   rdx,rdx
  949519:	74 67                	je     949582 <tokenize_c_raw_no_separators+0x47b2>
  94951b:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  949520:	4c 8b 44 24 38       	mov    r8,QWORD PTR [rsp+0x38]
  949525:	4c 01 c7             	add    rdi,r8
  949528:	48 81 c7 c1 00 00 00 	add    rdi,0xc1
  94952f:	eb 17                	jmp    949548 <tokenize_c_raw_no_separators+0x4778>
  949531:	41 b8 00 24 00 00    	mov    r8d,0x2400
  949537:	4d 0f a3 d0          	bt     r8,r10
  94953b:	0f 82 25 05 00 00    	jb     949a66 <tokenize_c_raw_no_separators+0x4c96>
  949541:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  949546:	74 3a                	je     949582 <tokenize_c_raw_no_separators+0x47b2>
  949548:	45 31 c0             	xor    r8d,r8d
  94954b:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  949550:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  949554:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  949559:	7d e6                	jge    949541 <tokenize_c_raw_no_separators+0x4771>
  94955b:	4c 03 84 24 a8 01 00 	add    r8,QWORD PTR [rsp+0x1a8]
  949562:	00 
  949563:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  949567:	49 83 fa 20          	cmp    r10,0x20
  94956b:	77 d4                	ja     949541 <tokenize_c_raw_no_separators+0x4771>
  94956d:	4d 0f a3 d3          	bt     r11,r10
  949571:	73 be                	jae    949531 <tokenize_c_raw_no_separators+0x4761>
  949573:	49 ff c1             	inc    r9
  949576:	49 ff c0             	inc    r8
  949579:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  94957e:	7c e3                	jl     949563 <tokenize_c_raw_no_separators+0x4793>
  949580:	eb bf                	jmp    949541 <tokenize_c_raw_no_separators+0x4771>
  949582:	62 f3 7d 48 39 ca 02 	vextracti32x4 xmm2,zmm1,0x2
  949589:	c4 e1 f9 7e d2       	vmovq  rdx,xmm2
  94958e:	48 85 d2             	test   rdx,rdx
  949591:	74 71                	je     949604 <tokenize_c_raw_no_separators+0x4834>
  949593:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  949598:	4c 8b 44 24 38       	mov    r8,QWORD PTR [rsp+0x38]
  94959d:	4c 01 c7             	add    rdi,r8
  9495a0:	48 81 c7 01 01 00 00 	add    rdi,0x101
  9495a7:	eb 17                	jmp    9495c0 <tokenize_c_raw_no_separators+0x47f0>
  9495a9:	41 b8 00 24 00 00    	mov    r8d,0x2400
  9495af:	4d 0f a3 d0          	bt     r8,r10
  9495b3:	0f 82 ad 04 00 00    	jb     949a66 <tokenize_c_raw_no_separators+0x4c96>
  9495b9:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  9495be:	74 44                	je     949604 <tokenize_c_raw_no_separators+0x4834>
  9495c0:	45 31 c0             	xor    r8d,r8d
  9495c3:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  9495c8:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  9495cf:	00 00 00 
  9495d2:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  9495d6:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  9495db:	7d dc                	jge    9495b9 <tokenize_c_raw_no_separators+0x47e9>
  9495dd:	4c 03 84 24 a0 01 00 	add    r8,QWORD PTR [rsp+0x1a0]
  9495e4:	00 
  9495e5:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  9495e9:	49 83 fa 20          	cmp    r10,0x20
  9495ed:	77 ca                	ja     9495b9 <tokenize_c_raw_no_separators+0x47e9>
  9495ef:	4d 0f a3 d3          	bt     r11,r10
  9495f3:	73 b4                	jae    9495a9 <tokenize_c_raw_no_separators+0x47d9>
  9495f5:	49 ff c1             	inc    r9
  9495f8:	49 ff c0             	inc    r8
  9495fb:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  949600:	7c e3                	jl     9495e5 <tokenize_c_raw_no_separators+0x4815>
  949602:	eb b5                	jmp    9495b9 <tokenize_c_raw_no_separators+0x47e9>
  949604:	c4 e3 f9 16 d2 01    	vpextrq rdx,xmm2,0x1
  94960a:	48 85 d2             	test   rdx,rdx
  94960d:	74 71                	je     949680 <tokenize_c_raw_no_separators+0x48b0>
  94960f:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  949614:	4c 8b 44 24 38       	mov    r8,QWORD PTR [rsp+0x38]
  949619:	4c 01 c7             	add    rdi,r8
  94961c:	48 81 c7 41 01 00 00 	add    rdi,0x141
  949623:	eb 17                	jmp    94963c <tokenize_c_raw_no_separators+0x486c>
  949625:	41 b8 00 24 00 00    	mov    r8d,0x2400
  94962b:	4d 0f a3 d0          	bt     r8,r10
  94962f:	0f 82 31 04 00 00    	jb     949a66 <tokenize_c_raw_no_separators+0x4c96>
  949635:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  94963a:	74 44                	je     949680 <tokenize_c_raw_no_separators+0x48b0>
  94963c:	45 31 c0             	xor    r8d,r8d
  94963f:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  949644:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  94964b:	00 00 00 
  94964e:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  949652:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  949657:	7d dc                	jge    949635 <tokenize_c_raw_no_separators+0x4865>
  949659:	4c 03 84 24 98 01 00 	add    r8,QWORD PTR [rsp+0x198]
  949660:	00 
  949661:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  949665:	49 83 fa 20          	cmp    r10,0x20
  949669:	77 ca                	ja     949635 <tokenize_c_raw_no_separators+0x4865>
  94966b:	4d 0f a3 d3          	bt     r11,r10
  94966f:	73 b4                	jae    949625 <tokenize_c_raw_no_separators+0x4855>
  949671:	49 ff c1             	inc    r9
  949674:	49 ff c0             	inc    r8
  949677:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  94967c:	7c e3                	jl     949661 <tokenize_c_raw_no_separators+0x4891>
  94967e:	eb b5                	jmp    949635 <tokenize_c_raw_no_separators+0x4865>
  949680:	62 f3 7d 48 39 c9 03 	vextracti32x4 xmm1,zmm1,0x3
  949687:	c4 e1 f9 7e ca       	vmovq  rdx,xmm1
  94968c:	48 85 d2             	test   rdx,rdx
  94968f:	74 71                	je     949702 <tokenize_c_raw_no_separators+0x4932>
  949691:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  949696:	4c 8b 44 24 38       	mov    r8,QWORD PTR [rsp+0x38]
  94969b:	4c 01 c7             	add    rdi,r8
  94969e:	48 81 c7 81 01 00 00 	add    rdi,0x181
  9496a5:	eb 17                	jmp    9496be <tokenize_c_raw_no_separators+0x48ee>
  9496a7:	41 b8 00 24 00 00    	mov    r8d,0x2400
  9496ad:	4d 0f a3 d0          	bt     r8,r10
  9496b1:	0f 82 af 03 00 00    	jb     949a66 <tokenize_c_raw_no_separators+0x4c96>
  9496b7:	c4 e2 e8 f3 ca       	blsr   rdx,rdx
  9496bc:	74 44                	je     949702 <tokenize_c_raw_no_separators+0x4932>
  9496be:	45 31 c0             	xor    r8d,r8d
  9496c1:	f3 4c 0f bc c2       	tzcnt  r8,rdx
  9496c6:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  9496cd:	00 00 00 
  9496d0:	4d 8d 0c 38          	lea    r9,[r8+rdi*1]
  9496d4:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  9496d9:	7d dc                	jge    9496b7 <tokenize_c_raw_no_separators+0x48e7>
  9496db:	4c 03 84 24 90 01 00 	add    r8,QWORD PTR [rsp+0x190]
  9496e2:	00 
  9496e3:	45 0f b6 10          	movzx  r10d,BYTE PTR [r8]
  9496e7:	49 83 fa 20          	cmp    r10,0x20
  9496eb:	77 ca                	ja     9496b7 <tokenize_c_raw_no_separators+0x48e7>
  9496ed:	4d 0f a3 d3          	bt     r11,r10
  9496f1:	73 b4                	jae    9496a7 <tokenize_c_raw_no_separators+0x48d7>
  9496f3:	49 ff c1             	inc    r9
  9496f6:	49 ff c0             	inc    r8
  9496f9:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  9496fe:	7c e3                	jl     9496e3 <tokenize_c_raw_no_separators+0x4913>
  949700:	eb b5                	jmp    9496b7 <tokenize_c_raw_no_separators+0x48e7>
  949702:	62 61 fd 48 6f 25 74 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffabda74]        # 407180 <__abi_tag+0x65c4>
  949709:	da ab ff 
  94970c:	62 e1 fd 48 6f 44 24 	vmovdqa64 zmm16,ZMMWORD PTR [rsp+0x4c0]
  949713:	13 
  949714:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x540]
  94971b:	15 
  94971c:	48 8b 54 24 40       	mov    rdx,QWORD PTR [rsp+0x40]
  949721:	4c 8b 44 24 38       	mov    r8,QWORD PTR [rsp+0x38]
  949726:	c4 e3 f9 16 cf 01    	vpextrq rdi,xmm1,0x1
  94972c:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  949733:	49 89 ca             	mov    r10,rcx
  949736:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  94973c:	62 61 fd 48 6f f3    	vmovdqa64 zmm30,zmm3
  949742:	62 61 fd 48 6f ec    	vmovdqa64 zmm29,zmm4
  949748:	62 f1 fd 48 6f ee    	vmovdqa64 zmm5,zmm6
  94974e:	62 71 fd 48 6f f7    	vmovdqa64 zmm14,zmm7
  949754:	62 51 fd 48 6f f9    	vmovdqa64 zmm15,zmm9
  94975a:	62 51 fd 48 6f da    	vmovdqa64 zmm11,zmm10
  949760:	62 51 fd 48 6f ec    	vmovdqa64 zmm13,zmm12
  949766:	62 a1 fd 48 6f ca    	vmovdqa64 zmm17,zmm18
  94976c:	62 a1 fd 48 6f e3    	vmovdqa64 zmm20,zmm19
  949772:	62 b1 fd 48 6f d5    	vmovdqa64 zmm2,zmm21
  949778:	62 a1 fd 48 6f fe    	vmovdqa64 zmm23,zmm22
  94977e:	62 01 fd 48 6f c1    	vmovdqa64 zmm24,zmm25
  949784:	4d 8d 0c 10          	lea    r9,[r8+rdx*1]
  949788:	48 85 ff             	test   rdi,rdi
  94978b:	0f 84 78 db ff ff    	je     947309 <tokenize_c_raw_no_separators+0x2539>
  949791:	4d 8d 81 c1 01 00 00 	lea    r8,[r9+0x1c1]
  949798:	e9 9a 00 00 00       	jmp    949837 <tokenize_c_raw_no_separators+0x4a67>
  94979d:	ba 00 24 00 00       	mov    edx,0x2400
  9497a2:	4c 0f a3 d2          	bt     rdx,r10
  9497a6:	0f 82 ba 02 00 00    	jb     949a66 <tokenize_c_raw_no_separators+0x4c96>
  9497ac:	62 61 fd 48 6f 25 ca 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffabd9ca]        # 407180 <__abi_tag+0x65c4>
  9497b3:	d9 ab ff 
  9497b6:	62 e1 fd 48 6f 44 24 	vmovdqa64 zmm16,ZMMWORD PTR [rsp+0x4c0]
  9497bd:	13 
  9497be:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x540]
  9497c5:	15 
  9497c6:	48 8b 54 24 40       	mov    rdx,QWORD PTR [rsp+0x40]
  9497cb:	4c 8b 4c 24 38       	mov    r9,QWORD PTR [rsp+0x38]
  9497d0:	c4 e2 c0 f3 cf       	blsr   rdi,rdi
  9497d5:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  9497dc:	49 89 ca             	mov    r10,rcx
  9497df:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  9497e5:	62 61 fd 48 6f f3    	vmovdqa64 zmm30,zmm3
  9497eb:	62 61 fd 48 6f ec    	vmovdqa64 zmm29,zmm4
  9497f1:	62 f1 fd 48 6f ee    	vmovdqa64 zmm5,zmm6
  9497f7:	62 71 fd 48 6f f7    	vmovdqa64 zmm14,zmm7
  9497fd:	62 51 fd 48 6f f9    	vmovdqa64 zmm15,zmm9
  949803:	62 51 fd 48 6f da    	vmovdqa64 zmm11,zmm10
  949809:	62 51 fd 48 6f ec    	vmovdqa64 zmm13,zmm12
  94980f:	62 a1 fd 48 6f ca    	vmovdqa64 zmm17,zmm18
  949815:	62 a1 fd 48 6f e3    	vmovdqa64 zmm20,zmm19
  94981b:	62 b1 fd 48 6f d5    	vmovdqa64 zmm2,zmm21
  949821:	62 a1 fd 48 6f fe    	vmovdqa64 zmm23,zmm22
  949827:	62 01 fd 48 6f c1    	vmovdqa64 zmm24,zmm25
  94982d:	4d 8d 0c 11          	lea    r9,[r9+rdx*1]
  949831:	0f 84 d2 da ff ff    	je     947309 <tokenize_c_raw_no_separators+0x2539>
  949837:	31 d2                	xor    edx,edx
  949839:	f3 48 0f bc d7       	tzcnt  rdx,rdi
  94983e:	49 bb 00 1a 00 00 01 	movabs r11,0x100001a00
  949845:	00 00 00 
  949848:	4e 8d 0c 02          	lea    r9,[rdx+r8*1]
  94984c:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  949851:	0f 8d 55 ff ff ff    	jge    9497ac <tokenize_c_raw_no_separators+0x49dc>
  949857:	48 03 94 24 88 01 00 	add    rdx,QWORD PTR [rsp+0x188]
  94985e:	00 
  94985f:	44 0f b6 12          	movzx  r10d,BYTE PTR [rdx]
  949863:	49 83 fa 20          	cmp    r10,0x20
  949867:	0f 87 3f ff ff ff    	ja     9497ac <tokenize_c_raw_no_separators+0x49dc>
  94986d:	4d 0f a3 d3          	bt     r11,r10
  949871:	0f 83 26 ff ff ff    	jae    94979d <tokenize_c_raw_no_separators+0x49cd>
  949877:	49 ff c1             	inc    r9
  94987a:	48 ff c2             	inc    rdx
  94987d:	4c 3b 4c 24 28       	cmp    r9,QWORD PTR [rsp+0x28]
  949882:	7c db                	jl     94985f <tokenize_c_raw_no_separators+0x4a8f>
  949884:	e9 23 ff ff ff       	jmp    9497ac <tokenize_c_raw_no_separators+0x49dc>
  949889:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x700]
  949890:	1c 
  949891:	62 61 fd 48 6f 6c 24 	vmovdqa64 zmm29,ZMMWORD PTR [rsp+0x380]
  949898:	0e 
  949899:	62 61 fd 48 6f 74 24 	vmovdqa64 zmm30,ZMMWORD PTR [rsp+0x100]
  9498a0:	04 
  9498a1:	62 61 fd 48 6f 25 d5 	vmovdqa64 zmm28,ZMMWORD PTR [rip+0xffffffffffabd8d5]        # 407180 <__abi_tag+0x65c4>
  9498a8:	d8 ab ff 
  9498ab:	62 e1 fd 48 6f 44 24 	vmovdqa64 zmm16,ZMMWORD PTR [rsp+0x4c0]
  9498b2:	13 
  9498b3:	62 f1 fd 48 6f 6c 24 	vmovdqa64 zmm5,ZMMWORD PTR [rsp+0xc0]
  9498ba:	03 
  9498bb:	62 71 fd 48 6f 44 24 	vmovdqa64 zmm8,ZMMWORD PTR [rsp+0x540]
  9498c2:	15 
  9498c3:	62 71 fd 48 6f 74 24 	vmovdqa64 zmm14,ZMMWORD PTR [rsp+0x240]
  9498ca:	09 
  9498cb:	62 71 fd 48 6f 7c 24 	vmovdqa64 zmm15,ZMMWORD PTR [rsp+0x280]
  9498d2:	0a 
  9498d3:	62 71 fd 48 6f 5c 24 	vmovdqa64 zmm11,ZMMWORD PTR [rsp+0xa00]
  9498da:	28 
  9498db:	62 71 fd 48 6f 6c 24 	vmovdqa64 zmm13,ZMMWORD PTR [rsp+0x8c0]
  9498e2:	23 
  9498e3:	62 e1 fd 48 6f 4c 24 	vmovdqa64 zmm17,ZMMWORD PTR [rsp+0x880]
  9498ea:	22 
  9498eb:	62 e1 fd 48 6f 64 24 	vmovdqa64 zmm20,ZMMWORD PTR [rsp+0x840]
  9498f2:	21 
  9498f3:	62 f1 fd 48 6f 54 24 	vmovdqa64 zmm2,ZMMWORD PTR [rsp+0x800]
  9498fa:	20 
  9498fb:	62 e1 fd 48 6f 7c 24 	vmovdqa64 zmm23,ZMMWORD PTR [rsp+0x9c0]
  949902:	27 
  949903:	62 61 fd 48 6f 44 24 	vmovdqa64 zmm24,ZMMWORD PTR [rsp+0x7c0]
  94990a:	1f 
  94990b:	62 f1 fd 48 6f 7c 24 	vmovdqa64 zmm7,ZMMWORD PTR [rsp+0x740]
  949912:	1d 
  949913:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  949918:	48 8b 4c 24 38       	mov    rcx,QWORD PTR [rsp+0x38]
  94991d:	4c 8b 94 24 d0 03 00 	mov    r10,QWORD PTR [rsp+0x3d0]
  949924:	00 
  949925:	62 03 25 40 25 db ff 	vpternlogd zmm27,zmm27,zmm27,0xff
  94992c:	62 01 05 00 ef ff    	vpxord xmm31,xmm31,xmm31
  949932:	4c 8d 0c 01          	lea    r9,[rcx+rax*1]
  949936:	62 f3 7d 48 39 c0 03 	vextracti32x4 xmm0,zmm0,0x3
  94993d:	62 63 7d 48 39 e9 03 	vextracti32x4 xmm1,zmm29,0x3
  949944:	c5 f1 6d c0          	vpunpckhqdq xmm0,xmm1,xmm0
  949948:	c4 e2 79 59 0d af 2d 	vpbroadcastq xmm1,QWORD PTR [rip+0xffffffffffc82daf]        # 5cc700 <x86_effects_unknown+0x290>
  94994f:	c8 ff 
  949951:	c4 e3 f1 22 8c 24 c0 	vpinsrq xmm1,xmm1,QWORD PTR [rsp+0x3c0],0x1
  949958:	03 00 00 01 
  94995c:	62 f3 fd 08 25 0d 89 	vpternlogq xmm1,xmm0,XMMWORD PTR [rip+0xffffffffffae1389],0x80        # 42acf0 <c_testsuite_feature.marker+0x7ec>
  949963:	13 ae ff 80 
  949967:	62 f1 fd 48 6f 44 24 	vmovdqa64 zmm0,ZMMWORD PTR [rsp+0x980]
  94996e:	26 
  94996f:	62 01 fd 48 df f6    	vpandnq zmm30,zmm0,zmm30
  949975:	62 f1 fd 48 7f 4c 24 	vmovdqa64 ZMMWORD PTR [rsp+0x480],zmm1
  94997c:	12 
  94997d:	e9 5c d9 ff ff       	jmp    9472de <tokenize_c_raw_no_separators+0x250e>
  949982:	4c 89 a4 24 90 0c 00 	mov    QWORD PTR [rsp+0xc90],r12
  949989:	00 
  94998a:	4c 89 94 24 98 0c 00 	mov    QWORD PTR [rsp+0xc98],r10
  949991:	00 
  949992:	4c 89 bc 24 a0 0c 00 	mov    QWORD PTR [rsp+0xca0],r15
  949999:	00 
  94999a:	4c 89 7c 24 10       	mov    QWORD PTR [rsp+0x10],r15
  94999f:	48 8d bc 24 a8 0c 00 	lea    rdi,[rsp+0xca8]
  9499a6:	00 
  9499a7:	48 8d b4 24 40 11 00 	lea    rsi,[rsp+0x1140]
  9499ae:	00 
  9499af:	c5 fa 6f 84 24 90 0c 	vmovdqu xmm0,XMMWORD PTR [rsp+0xc90]
  9499b6:	00 00 
  9499b8:	c5 fa 7f 04 24       	vmovdqu XMMWORD PTR [rsp],xmm0
  9499bd:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
  9499c2:	48 8b 4c 24 30       	mov    rcx,QWORD PTR [rsp+0x30]
  9499c7:	4c 8b 44 24 28       	mov    r8,QWORD PTR [rsp+0x28]
  9499cc:	c5 f8 77             	vzeroupper
  9499cf:	e8 5c 78 01 00       	call   961230 <write_chunk_outlined>
  9499d4:	48 8b 84 24 a8 0c 00 	mov    rax,QWORD PTR [rsp+0xca8]
  9499db:	00 
  9499dc:	48 2b 84 24 98 00 00 	sub    rax,QWORD PTR [rsp+0x98]
  9499e3:	00 
  9499e4:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  9499eb:	00 00 
  9499ed:	48 3b 8c 24 80 2c 00 	cmp    rcx,QWORD PTR [rsp+0x2c80]
  9499f4:	00 
  9499f5:	75 50                	jne    949a47 <tokenize_c_raw_no_separators+0x4c77>
  9499f7:	48 8d 65 d8          	lea    rsp,[rbp-0x28]
  9499fb:	5b                   	pop    rbx
  9499fc:	41 5c                	pop    r12
  9499fe:	41 5d                	pop    r13
  949a00:	41 5e                	pop    r14
  949a02:	41 5f                	pop    r15
  949a04:	5d                   	pop    rbp
  949a05:	c5 f8 77             	vzeroupper
  949a08:	c3                   	ret
  949a09:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  949a0e:	48 8d bc 24 c0 2b 00 	lea    rdi,[rsp+0x2bc0]
  949a15:	00 
  949a16:	4c 89 ca             	mov    rdx,r9
  949a19:	48 8b 4d 10          	mov    rcx,QWORD PTR [rbp+0x10]
  949a1d:	4c 8b 45 18          	mov    r8,QWORD PTR [rbp+0x18]
  949a21:	4c 8b 4d 20          	mov    r9,QWORD PTR [rbp+0x20]
  949a25:	c5 f8 77             	vzeroupper
  949a28:	e8 73 30 21 01       	call   1b5caa0 <needs_scalar>
  949a2d:	48 c7 c0 fe ff ff ff 	mov    rax,0xfffffffffffffffe
  949a34:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  949a3b:	00 00 
  949a3d:	48 3b 8c 24 80 2c 00 	cmp    rcx,QWORD PTR [rsp+0x2c80]
  949a44:	00 
  949a45:	74 b0                	je     9499f7 <tokenize_c_raw_no_separators+0x4c27>
  949a47:	c5 f8 77             	vzeroupper
  949a4a:	e8 61 0b eb ff       	call   7fa5b0 <__stack_chk_fail@plt>
  949a4f:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  949a54:	48 8d bc 24 c0 2b 00 	lea    rdi,[rsp+0x2bc0]
  949a5b:	00 
  949a5c:	4c 89 c2             	mov    rdx,r8
  949a5f:	eb b8                	jmp    949a19 <tokenize_c_raw_no_separators+0x4c49>
  949a61:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
  949a66:	48 8d bc 24 c0 2b 00 	lea    rdi,[rsp+0x2bc0]
  949a6d:	00 
  949a6e:	48 8b 54 24 48       	mov    rdx,QWORD PTR [rsp+0x48]
  949a73:	eb a4                	jmp    949a19 <tokenize_c_raw_no_separators+0x4c49>
