
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

000000000184bcf0 <builtin_intrinsic_filter_candidates>:
 184bcf0:	55                   	push   rbp
 184bcf1:	41 56                	push   r14
 184bcf3:	53                   	push   rbx
 184bcf4:	48 83 ec 50          	sub    rsp,0x50
 184bcf8:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
 184bcff:	00 00 
 184bd01:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
 184bd05:	89 f1                	mov    ecx,esi
 184bd07:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
 184bd0c:	c5 fe 7f 44 24 20    	vmovdqu YMMWORD PTR [rsp+0x20],ymm0
 184bd12:	c5 fe 7f 04 24       	vmovdqu YMMWORD PTR [rsp],ymm0
 184bd17:	85 f6                	test   esi,esi
 184bd19:	74 0f                	je     184bd2a <builtin_intrinsic_filter_candidates+0x3a>
 184bd1b:	83 fe 01             	cmp    esi,0x1
 184bd1e:	75 1f                	jne    184bd3f <builtin_intrinsic_filter_candidates+0x4f>
 184bd20:	31 c0                	xor    eax,eax
 184bd22:	45 31 c0             	xor    r8d,r8d
 184bd25:	e9 51 01 00 00       	jmp    184be7b <builtin_intrinsic_filter_candidates+0x18b>
 184bd2a:	b8 00 00 00 00       	mov    eax,0x0
 184bd2f:	45 31 c0             	xor    r8d,r8d
 184bd32:	84 d2                	test   dl,dl
 184bd34:	0f 84 d9 01 00 00    	je     184bf13 <builtin_intrinsic_filter_candidates+0x223>
 184bd3a:	e9 cf 06 00 00       	jmp    184c40e <builtin_intrinsic_filter_candidates+0x71e>
 184bd3f:	c5 fd 6f 05 39 73 da 	vmovdqa ymm0,YMMWORD PTR [rip+0xfffffffffeda7339]        # 5f3080 <check_x86_lower_condition.sets+0x820>
 184bd46:	fe 
 184bd47:	c4 e2 79 21 0d dc ce 	vpmovsxbd xmm1,DWORD PTR [rip+0xfffffffffeddcedc]        # 628c2c <executable_lay_out.first_sections+0x3e0>
 184bd4e:	dd fe 
 184bd50:	41 89 c9             	mov    r9d,ecx
 184bd53:	41 83 e1 fe          	and    r9d,0xfffffffe
 184bd57:	4c 8d 57 18          	lea    r10,[rdi+0x18]
 184bd5b:	31 c0                	xor    eax,eax
 184bd5d:	45 31 c0             	xor    r8d,r8d
 184bd60:	eb 37                	jmp    184bd99 <builtin_intrinsic_filter_candidates+0xa9>
 184bd62:	8b 2b                	mov    ebp,DWORD PTR [rbx]
 184bd64:	42 8b 5c 1b fc       	mov    ebx,DWORD PTR [rbx+r11*1-0x4]
 184bd69:	45 69 db b9 79 37 9e 	imul   r11d,r11d,0x9e3779b9
 184bd70:	c4 e3 7b f0 db 13    	rorx   ebx,ebx,0x13
 184bd76:	41 31 eb             	xor    r11d,ebp
 184bd79:	41 31 db             	xor    r11d,ebx
 184bd7c:	8d 58 01             	lea    ebx,[rax+0x1]
 184bd7f:	41 0f ab d8          	bts    r8d,ebx
 184bd83:	44 89 5c 84 24       	mov    DWORD PTR [rsp+rax*4+0x24],r11d
 184bd88:	48 83 c0 02          	add    rax,0x2
 184bd8c:	49 83 c2 20          	add    r10,0x20
 184bd90:	49 39 c1             	cmp    r9,rax
 184bd93:	0f 84 d9 00 00 00    	je     184be72 <builtin_intrinsic_filter_candidates+0x182>
 184bd99:	49 8b 5a e8          	mov    rbx,QWORD PTR [r10-0x18]
 184bd9d:	48 85 db             	test   rbx,rbx
 184bda0:	74 6e                	je     184be10 <builtin_intrinsic_filter_candidates+0x120>
 184bda2:	45 8b 5a f0          	mov    r11d,DWORD PTR [r10-0x10]
 184bda6:	4d 85 db             	test   r11,r11
 184bda9:	74 65                	je     184be10 <builtin_intrinsic_filter_candidates+0x120>
 184bdab:	41 83 fb 03          	cmp    r11d,0x3
 184bdaf:	76 09                	jbe    184bdba <builtin_intrinsic_filter_candidates+0xca>
 184bdb1:	8b 2b                	mov    ebp,DWORD PTR [rbx]
 184bdb3:	42 8b 5c 1b fc       	mov    ebx,DWORD PTR [rbx+r11*1-0x4]
 184bdb8:	eb 3a                	jmp    184bdf4 <builtin_intrinsic_filter_candidates+0x104>
 184bdba:	4d 8d 73 ff          	lea    r14,[r11-0x1]
 184bdbe:	62 d2 fd 28 7c d6    	vpbroadcastq ymm2,r14
 184bdc4:	62 f3 ed 28 1e c8 05 	vpcmpnltuq k1,ymm2,ymm0
 184bdcb:	62 f1 7f 89 6f 13    	vmovdqu8 xmm2{k1}{z},XMMWORD PTR [rbx]
 184bdd1:	c4 e2 79 31 d2       	vpmovzxbd xmm2,xmm2
 184bdd6:	62 f2 6d 89 47 d1    	vpsllvd xmm2{k1}{z},xmm2,xmm1
 184bddc:	c5 f9 70 da ee       	vpshufd xmm3,xmm2,0xee
 184bde1:	c5 e9 eb d3          	vpor   xmm2,xmm2,xmm3
 184bde5:	c5 f9 70 da 55       	vpshufd xmm3,xmm2,0x55
 184bdea:	c5 e9 eb d3          	vpor   xmm2,xmm2,xmm3
 184bdee:	c5 f9 7e d3          	vmovd  ebx,xmm2
 184bdf2:	89 dd                	mov    ebp,ebx
 184bdf4:	45 69 db b9 79 37 9e 	imul   r11d,r11d,0x9e3779b9
 184bdfb:	41 0f ab c0          	bts    r8d,eax
 184bdff:	c4 e3 7b f0 db 13    	rorx   ebx,ebx,0x13
 184be05:	41 31 eb             	xor    r11d,ebp
 184be08:	41 31 db             	xor    r11d,ebx
 184be0b:	44 89 5c 84 20       	mov    DWORD PTR [rsp+rax*4+0x20],r11d
 184be10:	49 8b 5a f8          	mov    rbx,QWORD PTR [r10-0x8]
 184be14:	48 85 db             	test   rbx,rbx
 184be17:	0f 84 6b ff ff ff    	je     184bd88 <builtin_intrinsic_filter_candidates+0x98>
 184be1d:	45 8b 1a             	mov    r11d,DWORD PTR [r10]
 184be20:	4d 85 db             	test   r11,r11
 184be23:	0f 84 5f ff ff ff    	je     184bd88 <builtin_intrinsic_filter_candidates+0x98>
 184be29:	41 83 fb 03          	cmp    r11d,0x3
 184be2d:	0f 87 2f ff ff ff    	ja     184bd62 <builtin_intrinsic_filter_candidates+0x72>
 184be33:	4d 8d 73 ff          	lea    r14,[r11-0x1]
 184be37:	62 d2 fd 28 7c d6    	vpbroadcastq ymm2,r14
 184be3d:	62 f3 ed 28 1e c8 05 	vpcmpnltuq k1,ymm2,ymm0
 184be44:	62 f1 7f 89 6f 13    	vmovdqu8 xmm2{k1}{z},XMMWORD PTR [rbx]
 184be4a:	c4 e2 79 31 d2       	vpmovzxbd xmm2,xmm2
 184be4f:	62 f2 6d 89 47 d1    	vpsllvd xmm2{k1}{z},xmm2,xmm1
 184be55:	c5 f9 70 da ee       	vpshufd xmm3,xmm2,0xee
 184be5a:	c5 e9 eb d3          	vpor   xmm2,xmm2,xmm3
 184be5e:	c5 f9 70 da 55       	vpshufd xmm3,xmm2,0x55
 184be63:	c5 e9 eb d3          	vpor   xmm2,xmm2,xmm3
 184be67:	c5 f9 7e d3          	vmovd  ebx,xmm2
 184be6b:	89 dd                	mov    ebp,ebx
 184be6d:	e9 f7 fe ff ff       	jmp    184bd69 <builtin_intrinsic_filter_candidates+0x79>
 184be72:	f6 c1 01             	test   cl,0x1
 184be75:	0f 84 88 00 00 00    	je     184bf03 <builtin_intrinsic_filter_candidates+0x213>
 184be7b:	49 89 c2             	mov    r10,rax
 184be7e:	49 c1 e2 04          	shl    r10,0x4
 184be82:	4e 8b 0c 17          	mov    r9,QWORD PTR [rdi+r10*1]
 184be86:	4d 85 c9             	test   r9,r9
 184be89:	74 78                	je     184bf03 <builtin_intrinsic_filter_candidates+0x213>
 184be8b:	4c 01 d7             	add    rdi,r10
 184be8e:	8b 7f 08             	mov    edi,DWORD PTR [rdi+0x8]
 184be91:	48 85 ff             	test   rdi,rdi
 184be94:	74 6d                	je     184bf03 <builtin_intrinsic_filter_candidates+0x213>
 184be96:	83 ff 03             	cmp    edi,0x3
 184be99:	76 0a                	jbe    184bea5 <builtin_intrinsic_filter_candidates+0x1b5>
 184be9b:	45 8b 11             	mov    r10d,DWORD PTR [r9]
 184be9e:	45 8b 4c 39 fc       	mov    r9d,DWORD PTR [r9+rdi*1-0x4]
 184bea3:	eb 44                	jmp    184bee9 <builtin_intrinsic_filter_candidates+0x1f9>
 184bea5:	4c 8d 57 ff          	lea    r10,[rdi-0x1]
 184bea9:	62 d2 fd 28 7c c2    	vpbroadcastq ymm0,r10
 184beaf:	62 f3 fd 28 1e 0d c6 	vpcmpnltuq k1,ymm0,YMMWORD PTR [rip+0xfffffffffeda71c6]        # 5f3080 <check_x86_lower_condition.sets+0x820>
 184beb6:	71 da fe 05 
 184beba:	62 d1 7f 89 6f 01    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r9]
 184bec0:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
 184bec5:	62 f2 7d 89 47 05 41 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xfffffffffedbec41]        # 60ab10 <tier0_program_class_type.types+0x5c0>
 184becc:	ec db fe 
 184becf:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
 184bed4:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
 184bed8:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
 184bedd:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
 184bee1:	c4 c1 79 7e c1       	vmovd  r9d,xmm0
 184bee6:	45 89 ca             	mov    r10d,r9d
 184bee9:	69 ff b9 79 37 9e    	imul   edi,edi,0x9e3779b9
 184beef:	41 0f ab c0          	bts    r8d,eax
 184bef3:	c4 43 7b f0 c9 13    	rorx   r9d,r9d,0x13
 184bef9:	44 31 d7             	xor    edi,r10d
 184befc:	44 31 cf             	xor    edi,r9d
 184beff:	89 7c 84 20          	mov    DWORD PTR [rsp+rax*4+0x20],edi
 184bf03:	84 d2                	test   dl,dl
 184bf05:	74 0c                	je     184bf13 <builtin_intrinsic_filter_candidates+0x223>
 184bf07:	83 fe 08             	cmp    esi,0x8
 184bf0a:	73 47                	jae    184bf53 <builtin_intrinsic_filter_candidates+0x263>
 184bf0c:	31 c0                	xor    eax,eax
 184bf0e:	e9 cd 01 00 00       	jmp    184c0e0 <builtin_intrinsic_filter_candidates+0x3f0>
 184bf13:	c5 fe 6f 44 24 20    	vmovdqu ymm0,YMMWORD PTR [rsp+0x20]
 184bf19:	c5 f5 72 d0 10       	vpsrld ymm1,ymm0,0x10
 184bf1e:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
 184bf22:	62 f2 7d 38 40 05 e0 	vpmulld ymm0,ymm0,DWORD BCST [rip+0xfffffffffeddcce0]        # 628c0c <executable_lay_out.first_sections+0x3c0>
 184bf29:	cc dd fe 
 184bf2c:	c5 f5 72 d0 0f       	vpsrld ymm1,ymm0,0xf
 184bf31:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
 184bf35:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
 184bf39:	c4 e3 7d 0e c1 aa    	vpblendw ymm0,ymm0,ymm1,0xaa
 184bf3f:	c5 fe 7f 04 24       	vmovdqu YMMWORD PTR [rsp],ymm0
 184bf44:	85 f6                	test   esi,esi
 184bf46:	0f 85 ba 01 00 00    	jne    184c106 <builtin_intrinsic_filter_candidates+0x416>
 184bf4c:	31 c0                	xor    eax,eax
 184bf4e:	e9 bb 04 00 00       	jmp    184c40e <builtin_intrinsic_filter_candidates+0x71e>
 184bf53:	83 fe 40             	cmp    esi,0x40
 184bf56:	73 07                	jae    184bf5f <builtin_intrinsic_filter_candidates+0x26f>
 184bf58:	31 c0                	xor    eax,eax
 184bf5a:	e9 1d 01 00 00       	jmp    184c07c <builtin_intrinsic_filter_candidates+0x38c>
 184bf5f:	62 f2 7d 48 58 05 a3 	vpbroadcastd zmm0,DWORD PTR [rip+0xfffffffffeddcca3]        # 628c0c <executable_lay_out.first_sections+0x3c0>
 184bf66:	cc dd fe 
 184bf69:	62 f2 7d 48 58 0d 9d 	vpbroadcastd zmm1,DWORD PTR [rip+0xfffffffffeddcc9d]        # 628c10 <executable_lay_out.first_sections+0x3c4>
 184bf70:	cc dd fe 
 184bf73:	89 ca                	mov    edx,ecx
 184bf75:	c1 ea 06             	shr    edx,0x6
 184bf78:	89 c8                	mov    eax,ecx
 184bf7a:	83 e0 c0             	and    eax,0xffffffc0
 184bf7d:	31 ff                	xor    edi,edi
 184bf7f:	48 c1 e2 08          	shl    rdx,0x8
 184bf83:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
 184bf8a:	84 00 00 00 00 00 
 184bf90:	62 f1 fe 48 6f 94 3c 	vmovdqu64 zmm2,ZMMWORD PTR [rsp+rdi*1+0x20]
 184bf97:	20 00 00 00 
 184bf9b:	62 f1 fe 48 6f 9c 3c 	vmovdqu64 zmm3,ZMMWORD PTR [rsp+rdi*1+0x60]
 184bfa2:	60 00 00 00 
 184bfa6:	62 f1 fe 48 6f a4 3c 	vmovdqu64 zmm4,ZMMWORD PTR [rsp+rdi*1+0xa0]
 184bfad:	a0 00 00 00 
 184bfb1:	62 f1 fe 48 6f ac 3c 	vmovdqu64 zmm5,ZMMWORD PTR [rsp+rdi*1+0xe0]
 184bfb8:	e0 00 00 00 
 184bfbc:	62 f1 4d 48 72 d2 10 	vpsrld zmm6,zmm2,0x10
 184bfc3:	62 f1 45 48 72 d3 10 	vpsrld zmm7,zmm3,0x10
 184bfca:	62 f1 3d 48 72 d4 10 	vpsrld zmm8,zmm4,0x10
 184bfd1:	62 f1 35 48 72 d5 10 	vpsrld zmm9,zmm5,0x10
 184bfd8:	62 f1 4d 48 ef d2    	vpxord zmm2,zmm6,zmm2
 184bfde:	62 f1 45 48 ef db    	vpxord zmm3,zmm7,zmm3
 184bfe4:	62 f1 3d 48 ef e4    	vpxord zmm4,zmm8,zmm4
 184bfea:	62 f1 35 48 ef ed    	vpxord zmm5,zmm9,zmm5
 184bff0:	62 f2 6d 48 40 d0    	vpmulld zmm2,zmm2,zmm0
 184bff6:	62 f2 65 48 40 d8    	vpmulld zmm3,zmm3,zmm0
 184bffc:	62 f2 5d 48 40 e0    	vpmulld zmm4,zmm4,zmm0
 184c002:	62 f2 55 48 40 e8    	vpmulld zmm5,zmm5,zmm0
 184c008:	62 f1 4d 48 72 d2 0f 	vpsrld zmm6,zmm2,0xf
 184c00f:	62 f1 45 48 72 d3 0f 	vpsrld zmm7,zmm3,0xf
 184c016:	62 f1 3d 48 72 d4 0f 	vpsrld zmm8,zmm4,0xf
 184c01d:	62 f1 35 48 72 d5 0f 	vpsrld zmm9,zmm5,0xf
 184c024:	62 f3 f5 48 25 f2 48 	vpternlogq zmm6,zmm1,zmm2,0x48
 184c02b:	62 f3 f5 48 25 fb 48 	vpternlogq zmm7,zmm1,zmm3,0x48
 184c032:	62 73 f5 48 25 c4 48 	vpternlogq zmm8,zmm1,zmm4,0x48
 184c039:	62 73 f5 48 25 cd 48 	vpternlogq zmm9,zmm1,zmm5,0x48
 184c040:	62 f1 fe 48 7f 34 3c 	vmovdqu64 ZMMWORD PTR [rsp+rdi*1],zmm6
 184c047:	62 f1 fe 48 7f 7c 3c 	vmovdqu64 ZMMWORD PTR [rsp+rdi*1+0x40],zmm7
 184c04e:	01 
 184c04f:	62 71 fe 48 7f 44 3c 	vmovdqu64 ZMMWORD PTR [rsp+rdi*1+0x80],zmm8
 184c056:	02 
 184c057:	62 71 fe 48 7f 4c 3c 	vmovdqu64 ZMMWORD PTR [rsp+rdi*1+0xc0],zmm9
 184c05e:	03 
 184c05f:	48 81 c7 00 01 00 00 	add    rdi,0x100
 184c066:	48 39 fa             	cmp    rdx,rdi
 184c069:	0f 85 21 ff ff ff    	jne    184bf90 <builtin_intrinsic_filter_candidates+0x2a0>
 184c06f:	39 c8                	cmp    eax,ecx
 184c071:	0f 84 8f 00 00 00    	je     184c106 <builtin_intrinsic_filter_candidates+0x416>
 184c077:	f6 c1 38             	test   cl,0x38
 184c07a:	74 64                	je     184c0e0 <builtin_intrinsic_filter_candidates+0x3f0>
 184c07c:	c4 e2 7d 58 05 87 cb 	vpbroadcastd ymm0,DWORD PTR [rip+0xfffffffffeddcb87]        # 628c0c <executable_lay_out.first_sections+0x3c0>
 184c083:	dd fe 
 184c085:	48 89 c2             	mov    rdx,rax
 184c088:	89 c8                	mov    eax,ecx
 184c08a:	83 e0 f8             	and    eax,0xfffffff8
 184c08d:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
 184c091:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
 184c098:	0f 1f 84 00 00 00 00 
 184c09f:	00 
 184c0a0:	c5 fe 6f 54 94 20    	vmovdqu ymm2,YMMWORD PTR [rsp+rdx*4+0x20]
 184c0a6:	c5 e5 72 d2 10       	vpsrld ymm3,ymm2,0x10
 184c0ab:	c5 e5 ef d2          	vpxor  ymm2,ymm3,ymm2
 184c0af:	c4 e2 6d 40 d0       	vpmulld ymm2,ymm2,ymm0
 184c0b4:	c5 e5 72 d2 0f       	vpsrld ymm3,ymm2,0xf
 184c0b9:	c5 e5 ef d2          	vpxor  ymm2,ymm3,ymm2
 184c0bd:	c4 e3 6d 0e d1 aa    	vpblendw ymm2,ymm2,ymm1,0xaa
 184c0c3:	c5 fe 7f 14 94       	vmovdqu YMMWORD PTR [rsp+rdx*4],ymm2
 184c0c8:	48 83 c2 08          	add    rdx,0x8
 184c0cc:	48 39 d0             	cmp    rax,rdx
 184c0cf:	75 cf                	jne    184c0a0 <builtin_intrinsic_filter_candidates+0x3b0>
 184c0d1:	39 c8                	cmp    eax,ecx
 184c0d3:	74 31                	je     184c106 <builtin_intrinsic_filter_candidates+0x416>
 184c0d5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
 184c0dc:	00 00 00 00 
 184c0e0:	8b 54 84 20          	mov    edx,DWORD PTR [rsp+rax*4+0x20]
 184c0e4:	89 d7                	mov    edi,edx
 184c0e6:	c1 ef 10             	shr    edi,0x10
 184c0e9:	31 d7                	xor    edi,edx
 184c0eb:	69 d7 2d 35 eb 7f    	imul   edx,edi,0x7feb352d
 184c0f1:	89 d7                	mov    edi,edx
 184c0f3:	c1 ef 0f             	shr    edi,0xf
 184c0f6:	31 d7                	xor    edi,edx
 184c0f8:	0f b7 d7             	movzx  edx,di
 184c0fb:	89 14 84             	mov    DWORD PTR [rsp+rax*4],edx
 184c0fe:	48 ff c0             	inc    rax
 184c101:	48 39 c1             	cmp    rcx,rax
 184c104:	75 da                	jne    184c0e0 <builtin_intrinsic_filter_candidates+0x3f0>
 184c106:	83 fe 08             	cmp    esi,0x8
 184c109:	73 09                	jae    184c114 <builtin_intrinsic_filter_candidates+0x424>
 184c10b:	31 d2                	xor    edx,edx
 184c10d:	31 c0                	xor    eax,eax
 184c10f:	e9 16 03 00 00       	jmp    184c42a <builtin_intrinsic_filter_candidates+0x73a>
 184c114:	62 d2 7d 28 7c c0    	vpbroadcastd ymm0,r8d
 184c11a:	83 fe 20             	cmp    esi,0x20
 184c11d:	73 09                	jae    184c128 <builtin_intrinsic_filter_candidates+0x438>
 184c11f:	31 d2                	xor    edx,edx
 184c121:	31 c0                	xor    eax,eax
 184c123:	e9 24 02 00 00       	jmp    184c34c <builtin_intrinsic_filter_candidates+0x65c>
 184c128:	c5 fd 6f 15 70 6f da 	vmovdqa ymm2,YMMWORD PTR [rip+0xfffffffffeda6f70]        # 5f30a0 <check_x86_lower_condition.sets+0x840>
 184c12f:	fe 
 184c130:	c4 e2 7d 58 1d db ca 	vpbroadcastd ymm3,DWORD PTR [rip+0xfffffffffeddcadb]        # 628c14 <executable_lay_out.first_sections+0x3c8>
 184c137:	dd fe 
 184c139:	c4 e2 7d 58 25 d6 ca 	vpbroadcastd ymm4,DWORD PTR [rip+0xfffffffffeddcad6]        # 628c18 <executable_lay_out.first_sections+0x3cc>
 184c140:	dd fe 
 184c142:	c4 e2 7d 58 2d d1 ca 	vpbroadcastd ymm5,DWORD PTR [rip+0xfffffffffeddcad1]        # 628c1c <executable_lay_out.first_sections+0x3d0>
 184c149:	dd fe 
 184c14b:	c4 e2 7d 58 35 cc ca 	vpbroadcastd ymm6,DWORD PTR [rip+0xfffffffffeddcacc]        # 628c20 <executable_lay_out.first_sections+0x3d4>
 184c152:	dd fe 
 184c154:	c4 e2 7d 58 3d c7 ca 	vpbroadcastd ymm7,DWORD PTR [rip+0xfffffffffeddcac7]        # 628c24 <executable_lay_out.first_sections+0x3d8>
 184c15b:	dd fe 
 184c15d:	c4 62 7d 58 05 c2 ca 	vpbroadcastd ymm8,DWORD PTR [rip+0xfffffffffeddcac2]        # 628c28 <executable_lay_out.first_sections+0x3dc>
 184c164:	dd fe 
 184c166:	89 c8                	mov    eax,ecx
 184c168:	c1 e8 05             	shr    eax,0x5
 184c16b:	89 ca                	mov    edx,ecx
 184c16d:	83 e2 e0             	and    edx,0xffffffe0
 184c170:	48 8d 74 24 60       	lea    rsi,[rsp+0x60]
 184c175:	4c 8d 0d 74 bc ca fe 	lea    r9,[rip+0xfffffffffecabc74]        # 4f7df0 <builtin_intrinsic_filter_bits>
 184c17c:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
 184c180:	31 ff                	xor    edi,edi
 184c182:	c4 41 31 ef c9       	vpxor  xmm9,xmm9,xmm9
 184c187:	c4 41 21 ef db       	vpxor  xmm11,xmm11,xmm11
 184c18c:	c4 41 29 ef d2       	vpxor  xmm10,xmm10,xmm10
 184c191:	48 c1 e0 07          	shl    rax,0x7
 184c195:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
 184c19c:	00 00 00 00 
 184c1a0:	c4 62 7d 45 fa       	vpsrlvd ymm15,ymm0,ymm2
 184c1a5:	c5 6d fe e3          	vpaddd ymm12,ymm2,ymm3
 184c1a9:	c5 6d fe ec          	vpaddd ymm13,ymm2,ymm4
 184c1ad:	c5 6d fe f5          	vpaddd ymm14,ymm2,ymm5
 184c1b1:	62 a1 45 00 ef ff    	vpxord xmm23,xmm23,xmm23
 184c1b7:	62 f2 05 28 27 ce    	vptestmd k1,ymm15,ymm6
 184c1bd:	c4 42 7d 45 fc       	vpsrlvd ymm15,ymm0,ymm12
 184c1c2:	62 f2 05 28 27 d6    	vptestmd k2,ymm15,ymm6
 184c1c8:	c4 42 7d 45 fd       	vpsrlvd ymm15,ymm0,ymm13
 184c1cd:	62 f2 05 28 27 de    	vptestmd k3,ymm15,ymm6
 184c1d3:	c4 42 7d 45 fe       	vpsrlvd ymm15,ymm0,ymm14
 184c1d8:	62 f2 05 28 27 e6    	vptestmd k4,ymm15,ymm6
 184c1de:	62 71 7e a9 6f 7c 3e 	vmovdqu32 ymm15{k1}{z},YMMWORD PTR [rsi+rdi*1-0x60]
 184c1e5:	fd 
 184c1e6:	c4 e1 f8 90 e9       	kmovq  k5,k1
 184c1eb:	62 e1 7e aa 6f 44 3e 	vmovdqu32 ymm16{k2}{z},YMMWORD PTR [rsi+rdi*1-0x40]
 184c1f2:	fe 
 184c1f3:	62 e1 7e ab 6f 4c 3e 	vmovdqu32 ymm17{k3}{z},YMMWORD PTR [rsi+rdi*1-0x20]
 184c1fa:	ff 
 184c1fb:	62 e1 7e ac 6f 14 3e 	vmovdqu32 ymm18{k4}{z},YMMWORD PTR [rsi+rdi*1]
 184c202:	48 83 ef 80          	sub    rdi,0xffffffffffffff80
 184c206:	62 d1 65 20 72 d7 06 	vpsrld ymm19,ymm15,0x6
 184c20d:	c5 05 db ff          	vpand  ymm15,ymm15,ymm7
 184c211:	62 c2 fd 45 90 3c d9 	vpgatherdq zmm23{k5},QWORD PTR [r9+ymm19*8]
 184c218:	62 b1 5d 20 72 d0 06 	vpsrld ymm20,ymm16,0x6
 184c21f:	c4 e1 f8 90 ea       	kmovq  k5,k2
 184c224:	62 a1 65 00 ef db    	vpxord xmm19,xmm19,xmm19
 184c22a:	62 e1 7d 20 db c7    	vpandd ymm16,ymm16,ymm7
 184c230:	62 52 7d 48 35 ff    	vpmovzxdq zmm15,ymm15
 184c236:	62 c2 fd 45 90 1c e1 	vpgatherdq zmm19{k5},QWORD PTR [r9+ymm20*8]
 184c23d:	62 b1 55 20 72 d1 06 	vpsrld ymm21,ymm17,0x6
 184c244:	c4 e1 f8 90 eb       	kmovq  k5,k3
 184c249:	62 a1 5d 00 ef e4    	vpxord xmm20,xmm20,xmm20
 184c24f:	62 e1 75 20 db cf    	vpandd ymm17,ymm17,ymm7
 184c255:	62 a2 7d 48 35 c0    	vpmovzxdq zmm16,ymm16
 184c25b:	62 c2 fd 45 90 24 e9 	vpgatherdq zmm20{k5},QWORD PTR [r9+ymm21*8]
 184c262:	62 b1 4d 20 72 d2 06 	vpsrld ymm22,ymm18,0x6
 184c269:	c4 e1 f8 90 ec       	kmovq  k5,k4
 184c26e:	62 a1 55 00 ef ed    	vpxord xmm21,xmm21,xmm21
 184c274:	62 e1 6d 20 db d7    	vpandd ymm18,ymm18,ymm7
 184c27a:	62 a2 7d 48 35 c9    	vpmovzxdq zmm17,ymm17
 184c280:	62 c2 fd 45 90 2c f1 	vpgatherdq zmm21{k5},QWORD PTR [r9+ymm22*8]
 184c287:	62 a2 7d 48 35 d2    	vpmovzxdq zmm18,ymm18
 184c28d:	62 52 c5 40 45 ff    	vpsrlvq zmm15,zmm23,zmm15
 184c293:	62 a2 e5 40 45 c0    	vpsrlvq zmm16,zmm19,zmm16
 184c299:	62 52 7e 48 35 ff    	vpmovqd ymm15,zmm15
 184c29f:	62 a2 dd 40 45 c9    	vpsrlvq zmm17,zmm20,zmm17
 184c2a5:	62 a2 7e 48 35 c0    	vpmovqd ymm16,zmm16
 184c2ab:	62 a2 d5 40 45 d2    	vpsrlvq zmm18,zmm21,zmm18
 184c2b1:	62 a2 7e 48 35 c9    	vpmovqd ymm17,zmm17
 184c2b7:	62 a2 7e 48 35 d2    	vpmovqd ymm18,zmm18
 184c2bd:	c5 05 db fe          	vpand  ymm15,ymm15,ymm6
 184c2c1:	62 e1 7d 20 db c6    	vpandd ymm16,ymm16,ymm6
 184c2c7:	c4 62 05 47 fa       	vpsllvd ymm15,ymm15,ymm2
 184c2cc:	c5 bd fe d2          	vpaddd ymm2,ymm8,ymm2
 184c2d0:	62 e1 75 20 db ce    	vpandd ymm17,ymm17,ymm6
 184c2d6:	62 52 7d 20 47 e4    	vpsllvd ymm12,ymm16,ymm12
 184c2dc:	62 51 35 29 eb cf    	vpord  ymm9{k1},ymm9,ymm15
 184c2e2:	62 e1 6d 20 db d6    	vpandd ymm18,ymm18,ymm6
 184c2e8:	62 52 75 20 47 ed    	vpsllvd ymm13,ymm17,ymm13
 184c2ee:	62 51 25 2a eb dc    	vpord  ymm11{k2},ymm11,ymm12
 184c2f4:	62 52 6d 20 47 f6    	vpsllvd ymm14,ymm18,ymm14
 184c2fa:	62 51 2d 2b eb d5    	vpord  ymm10{k3},ymm10,ymm13
 184c300:	62 d1 75 2c eb ce    	vpord  ymm1{k4},ymm1,ymm14
 184c306:	48 39 f8             	cmp    rax,rdi
 184c309:	0f 85 91 fe ff ff    	jne    184c1a0 <builtin_intrinsic_filter_candidates+0x4b0>
 184c30f:	c4 c1 25 eb d1       	vpor   ymm2,ymm11,ymm9
 184c314:	62 f3 2d 28 25 ca fe 	vpternlogd ymm1,ymm10,ymm2,0xfe
 184c31b:	c4 e3 7d 39 ca 01    	vextracti128 xmm2,ymm1,0x1
 184c321:	c5 f1 eb ca          	vpor   xmm1,xmm1,xmm2
 184c325:	c5 f9 70 d1 ee       	vpshufd xmm2,xmm1,0xee
 184c32a:	c5 f1 eb ca          	vpor   xmm1,xmm1,xmm2
 184c32e:	c5 f9 70 d1 55       	vpshufd xmm2,xmm1,0x55
 184c333:	c5 f1 eb ca          	vpor   xmm1,xmm1,xmm2
 184c337:	c5 f9 7e c8          	vmovd  eax,xmm1
 184c33b:	39 ca                	cmp    edx,ecx
 184c33d:	0f 84 cb 00 00 00    	je     184c40e <builtin_intrinsic_filter_candidates+0x71e>
 184c343:	f6 c1 18             	test   cl,0x18
 184c346:	0f 84 de 00 00 00    	je     184c42a <builtin_intrinsic_filter_candidates+0x73a>
 184c34c:	48 89 d6             	mov    rsi,rdx
 184c34f:	62 f2 7d 28 7c d6    	vpbroadcastd ymm2,esi
 184c355:	c5 ed eb 15 43 6d da 	vpor   ymm2,ymm2,YMMWORD PTR [rip+0xfffffffffeda6d43]        # 5f30a0 <check_x86_lower_condition.sets+0x840>
 184c35c:	fe 
 184c35d:	c4 e2 7d 58 1d ba c8 	vpbroadcastd ymm3,DWORD PTR [rip+0xfffffffffeddc8ba]        # 628c20 <executable_lay_out.first_sections+0x3d4>
 184c364:	dd fe 
 184c366:	c4 e2 7d 58 25 b5 c8 	vpbroadcastd ymm4,DWORD PTR [rip+0xfffffffffeddc8b5]        # 628c24 <executable_lay_out.first_sections+0x3d8>
 184c36d:	dd fe 
 184c36f:	c4 e2 7d 58 2d 9c c8 	vpbroadcastd ymm5,DWORD PTR [rip+0xfffffffffeddc89c]        # 628c14 <executable_lay_out.first_sections+0x3c8>
 184c376:	dd fe 
 184c378:	89 ca                	mov    edx,ecx
 184c37a:	c5 f9 6e c8          	vmovd  xmm1,eax
 184c37e:	83 e2 f8             	and    edx,0xfffffff8
 184c381:	48 8d 05 68 ba ca fe 	lea    rax,[rip+0xfffffffffecaba68]        # 4f7df0 <builtin_intrinsic_filter_bits>
 184c388:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
 184c38f:	00 
 184c390:	c4 e2 7d 45 f2       	vpsrlvd ymm6,ymm0,ymm2
 184c395:	c4 41 39 ef c0       	vpxor  xmm8,xmm8,xmm8
 184c39a:	62 f2 4d 28 27 cb    	vptestmd k1,ymm6,ymm3
 184c3a0:	62 f1 7e a9 6f 34 b4 	vmovdqu32 ymm6{k1}{z},YMMWORD PTR [rsp+rsi*4]
 184c3a7:	c4 e1 f8 90 d1       	kmovq  k2,k1
 184c3ac:	48 83 c6 08          	add    rsi,0x8
 184c3b0:	c5 c5 72 d6 06       	vpsrld ymm7,ymm6,0x6
 184c3b5:	c5 cd db f4          	vpand  ymm6,ymm6,ymm4
 184c3b9:	62 72 fd 4a 90 04 f8 	vpgatherdq zmm8{k2},QWORD PTR [rax+ymm7*8]
 184c3c0:	62 f2 7d 48 35 f6    	vpmovzxdq zmm6,ymm6
 184c3c6:	62 f2 bd 48 45 f6    	vpsrlvq zmm6,zmm8,zmm6
 184c3cc:	62 f2 7e 48 35 f6    	vpmovqd ymm6,zmm6
 184c3d2:	c5 cd db f3          	vpand  ymm6,ymm6,ymm3
 184c3d6:	c4 e2 4d 47 f2       	vpsllvd ymm6,ymm6,ymm2
 184c3db:	c5 ed fe d5          	vpaddd ymm2,ymm2,ymm5
 184c3df:	62 f1 75 29 eb ce    	vpord  ymm1{k1},ymm1,ymm6
 184c3e5:	48 39 f2             	cmp    rdx,rsi
 184c3e8:	75 a6                	jne    184c390 <builtin_intrinsic_filter_candidates+0x6a0>
 184c3ea:	c4 e3 7d 39 c8 01    	vextracti128 xmm0,ymm1,0x1
 184c3f0:	c5 f1 eb c0          	vpor   xmm0,xmm1,xmm0
 184c3f4:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
 184c3f9:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
 184c3fd:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
 184c402:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
 184c406:	c5 f9 7e c0          	vmovd  eax,xmm0
 184c40a:	39 ca                	cmp    edx,ecx
 184c40c:	75 1c                	jne    184c42a <builtin_intrinsic_filter_candidates+0x73a>
 184c40e:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
 184c415:	00 00 
 184c417:	48 3b 4c 24 48       	cmp    rcx,QWORD PTR [rsp+0x48]
 184c41c:	75 4c                	jne    184c46a <builtin_intrinsic_filter_candidates+0x77a>
 184c41e:	48 83 c4 50          	add    rsp,0x50
 184c422:	5b                   	pop    rbx
 184c423:	41 5e                	pop    r14
 184c425:	5d                   	pop    rbp
 184c426:	c5 f8 77             	vzeroupper
 184c429:	c3                   	ret
 184c42a:	48 8d 35 bf b9 ca fe 	lea    rsi,[rip+0xfffffffffecab9bf]        # 4f7df0 <builtin_intrinsic_filter_bits>
 184c431:	eb 15                	jmp    184c448 <builtin_intrinsic_filter_candidates+0x758>
 184c433:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
 184c43a:	84 00 00 00 00 00 
 184c440:	48 ff c2             	inc    rdx
 184c443:	48 39 d1             	cmp    rcx,rdx
 184c446:	74 c6                	je     184c40e <builtin_intrinsic_filter_candidates+0x71e>
 184c448:	41 0f a3 d0          	bt     r8d,edx
 184c44c:	73 f2                	jae    184c440 <builtin_intrinsic_filter_candidates+0x750>
 184c44e:	8b 3c 94             	mov    edi,DWORD PTR [rsp+rdx*4]
 184c451:	41 89 f9             	mov    r9d,edi
 184c454:	41 c1 e9 06          	shr    r9d,0x6
 184c458:	c4 a2 c3 f7 3c ce    	shrx   rdi,QWORD PTR [rsi+r9*8],rdi
 184c45e:	83 e7 01             	and    edi,0x1
 184c461:	c4 e2 69 f7 ff       	shlx   edi,edi,edx
 184c466:	09 f8                	or     eax,edi
 184c468:	eb d6                	jmp    184c440 <builtin_intrinsic_filter_candidates+0x750>
 184c46a:	c5 f8 77             	vzeroupper
 184c46d:	e8 ce 10 0b ff       	call   8fd540 <__stack_chk_fail@plt>
