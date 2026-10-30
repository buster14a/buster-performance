
work/pr914-acceptance/bin/head/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000964f50 <check_input_intrinsic_lookup>:
  964f50:	55                   	push   rbp
  964f51:	41 57                	push   r15
  964f53:	41 56                	push   r14
  964f55:	41 55                	push   r13
  964f57:	41 54                	push   r12
  964f59:	53                   	push   rbx
  964f5a:	48 81 ec 48 01 00 00 	sub    rsp,0x148
  964f61:	4c 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],r9
  964f66:	4c 89 44 24 10       	mov    QWORD PTR [rsp+0x10],r8
  964f6b:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
  964f70:	48 89 74 24 40       	mov    QWORD PTR [rsp+0x40],rsi
  964f75:	89 cb                	mov    ebx,ecx
  964f77:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  964f7e:	00 00 
  964f80:	48 89 84 24 40 01 00 	mov    QWORD PTR [rsp+0x140],rax
  964f87:	00 
  964f88:	89 4c 24 34          	mov    DWORD PTR [rsp+0x34],ecx
  964f8c:	40 f6 c7 01          	test   dil,0x1
  964f90:	0f 84 ee 00 00 00    	je     965084 <check_input_intrinsic_lookup+0x134>
  964f96:	85 db                	test   ebx,ebx
  964f98:	0f 84 38 08 00 00    	je     9657d6 <check_input_intrinsic_lookup+0x886>
  964f9e:	89 d8                	mov    eax,ebx
  964fa0:	48 89 44 24 60       	mov    QWORD PTR [rsp+0x60],rax
  964fa5:	31 c0                	xor    eax,eax
  964fa7:	eb 28                	jmp    964fd1 <check_input_intrinsic_lookup+0x81>
  964fa9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  964fb0:	31 db                	xor    ebx,ebx
  964fb2:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
  964fb7:	48 89 9c c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],rbx
  964fbe:	00 
  964fbf:	8b 5c 24 34          	mov    ebx,DWORD PTR [rsp+0x34]
  964fc3:	48 ff c0             	inc    rax
  964fc6:	48 3b 44 24 60       	cmp    rax,QWORD PTR [rsp+0x60]
  964fcb:	0f 84 e4 07 00 00    	je     9657b5 <check_input_intrinsic_lookup+0x865>
  964fd1:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
  964fd6:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
  964fdb:	48 c1 e0 04          	shl    rax,0x4
  964fdf:	48 8b 14 01          	mov    rdx,QWORD PTR [rcx+rax*1]
  964fe3:	8b 74 01 08          	mov    esi,DWORD PTR [rcx+rax*1+0x8]
  964fe7:	48 85 d2             	test   rdx,rdx
  964fea:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
  964fef:	0f 94 c0             	sete   al
  964ff2:	85 f6                	test   esi,esi
  964ff4:	0f 94 c1             	sete   cl
  964ff7:	08 c1                	or     cl,al
  964ff9:	75 b5                	jne    964fb0 <check_input_intrinsic_lookup+0x60>
  964ffb:	bd bf 0e 00 00       	mov    ebp,0xebf
  965000:	31 db                	xor    ebx,ebx
  965002:	45 31 f6             	xor    r14d,r14d
  965005:	89 74 24 38          	mov    DWORD PTR [rsp+0x38],esi
  965009:	eb 2f                	jmp    96503a <check_input_intrinsic_lookup+0xea>
  96500b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
  965010:	44 39 e6             	cmp    esi,r12d
  965013:	0f 97 c0             	seta   al
  965016:	1c 00                	sbb    al,0x0
  965018:	0f be c0             	movsx  eax,al
  96501b:	85 c0                	test   eax,eax
  96501d:	41 8d 4d 01          	lea    ecx,[r13+0x1]
  965021:	41 0f 48 ed          	cmovs  ebp,r13d
  965025:	49 0f 44 df          	cmove  rbx,r15
  965029:	41 0f 44 ee          	cmove  ebp,r14d
  96502d:	44 0f 4f f1          	cmovg  r14d,ecx
  965031:	41 39 ee             	cmp    r14d,ebp
  965034:	0f 83 78 ff ff ff    	jae    964fb2 <check_input_intrinsic_lookup+0x62>
  96503a:	41 89 ed             	mov    r13d,ebp
  96503d:	45 29 f5             	sub    r13d,r14d
  965040:	48 8d 0d f9 9c 87 01 	lea    rcx,[rip+0x1879cf9]        # 21ded40 <builtin_intrinsic_infos>
  965047:	41 d1 ed             	shr    r13d,1
  96504a:	45 01 f5             	add    r13d,r14d
  96504d:	4b 8d 44 6d 00       	lea    rax,[r13+r13*2+0x0]
  965052:	48 c1 e0 05          	shl    rax,0x5
  965056:	44 8b 64 08 40       	mov    r12d,DWORD PTR [rax+rcx*1+0x40]
  96505b:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  96505f:	45 85 e4             	test   r12d,r12d
  965062:	74 ac                	je     965010 <check_input_intrinsic_lookup+0xc0>
  965064:	44 39 e6             	cmp    esi,r12d
  965067:	44 89 e2             	mov    edx,r12d
  96506a:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
  96506f:	0f 42 d6             	cmovb  edx,esi
  965072:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  965075:	e8 86 5a fa ff       	call   90ab00 <memcmp@plt>
  96507a:	8b 74 24 38          	mov    esi,DWORD PTR [rsp+0x38]
  96507e:	85 c0                	test   eax,eax
  965080:	75 99                	jne    96501b <check_input_intrinsic_lookup+0xcb>
  965082:	eb 8c                	jmp    965010 <check_input_intrinsic_lookup+0xc0>
  965084:	85 db                	test   ebx,ebx
  965086:	0f 84 4a 07 00 00    	je     9657d6 <check_input_intrinsic_lookup+0x886>
  96508c:	c5 fd 6f 15 cc fa c8 	vmovdqa ymm2,YMMWORD PTR [rip+0xffffffffffc8facc]        # 5f4b60 <static_test_starved.starved+0xdc0>
  965093:	ff 
  965094:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  965099:	4c 8d 35 b0 37 b6 ff 	lea    r14,[rip+0xffffffffffb637b0]        # 4c8850 <builtin_intrinsic_filter_bits>
  9650a0:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  9650a4:	48 8d 48 18          	lea    rcx,[rax+0x18]
  9650a8:	48 83 c0 08          	add    rax,0x8
  9650ac:	48 89 4c 24 50       	mov    QWORD PTR [rsp+0x50],rcx
  9650b1:	31 c9                	xor    ecx,ecx
  9650b3:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
  9650b8:	eb 1f                	jmp    9650d9 <check_input_intrinsic_lookup+0x189>
  9650ba:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  9650c0:	c5 fd 6f 15 98 fa c8 	vmovdqa ymm2,YMMWORD PTR [rip+0xffffffffffc8fa98]        # 5f4b60 <static_test_starved.starved+0xdc0>
  9650c7:	ff 
  9650c8:	44 01 fe             	add    esi,r15d
  9650cb:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  9650cf:	89 f1                	mov    ecx,esi
  9650d1:	39 de                	cmp    esi,ebx
  9650d3:	0f 83 dc 06 00 00    	jae    9657b5 <check_input_intrinsic_lookup+0x865>
  9650d9:	89 d8                	mov    eax,ebx
  9650db:	29 c8                	sub    eax,ecx
  9650dd:	be 08 00 00 00       	mov    esi,0x8
  9650e2:	41 89 cf             	mov    r15d,ecx
  9650e5:	4c 89 fd             	mov    rbp,r15
  9650e8:	c5 fe 7f 84 24 20 01 	vmovdqu YMMWORD PTR [rsp+0x120],ymm0
  9650ef:	00 00 
  9650f1:	83 f8 08             	cmp    eax,0x8
  9650f4:	0f 42 f0             	cmovb  esi,eax
  9650f7:	48 c1 e5 04          	shl    rbp,0x4
  9650fb:	48 89 f2             	mov    rdx,rsi
  9650fe:	48 ff ca             	dec    rdx
  965101:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
  965106:	0f 84 54 01 00 00    	je     965260 <check_input_intrinsic_lookup+0x310>
  96510c:	48 8b 4c 24 50       	mov    rcx,QWORD PTR [rsp+0x50]
  965111:	48 89 f7             	mov    rdi,rsi
  965114:	83 e7 0e             	and    edi,0xe
  965117:	31 f6                	xor    esi,esi
  965119:	4c 8d 04 29          	lea    r8,[rcx+rbp*1]
  96511d:	31 c9                	xor    ecx,ecx
  96511f:	eb 3c                	jmp    96515d <check_input_intrinsic_lookup+0x20d>
  965121:	45 8b 1a             	mov    r11d,DWORD PTR [r10]
  965124:	47 8b 54 0a fc       	mov    r10d,DWORD PTR [r10+r9*1-0x4]
  965129:	45 69 c9 b9 79 37 9e 	imul   r9d,r9d,0x9e3779b9
  965130:	c4 43 7b f0 d2 13    	rorx   r10d,r10d,0x13
  965136:	45 31 d9             	xor    r9d,r11d
  965139:	45 31 d1             	xor    r9d,r10d
  96513c:	44 8d 56 01          	lea    r10d,[rsi+0x1]
  965140:	44 0f ab d1          	bts    ecx,r10d
  965144:	44 89 8c b4 24 01 00 	mov    DWORD PTR [rsp+rsi*4+0x124],r9d
  96514b:	00 
  96514c:	48 83 c6 02          	add    rsi,0x2
  965150:	49 83 c0 20          	add    r8,0x20
  965154:	48 39 f7             	cmp    rdi,rsi
  965157:	0f 84 f3 00 00 00    	je     965250 <check_input_intrinsic_lookup+0x300>
  96515d:	4d 8b 50 e8          	mov    r10,QWORD PTR [r8-0x18]
  965161:	4d 85 d2             	test   r10,r10
  965164:	74 77                	je     9651dd <check_input_intrinsic_lookup+0x28d>
  965166:	45 8b 48 f0          	mov    r9d,DWORD PTR [r8-0x10]
  96516a:	4d 85 c9             	test   r9,r9
  96516d:	74 6e                	je     9651dd <check_input_intrinsic_lookup+0x28d>
  96516f:	41 83 f9 03          	cmp    r9d,0x3
  965173:	76 0a                	jbe    96517f <check_input_intrinsic_lookup+0x22f>
  965175:	45 8b 1a             	mov    r11d,DWORD PTR [r10]
  965178:	47 8b 54 0a fc       	mov    r10d,DWORD PTR [r10+r9*1-0x4]
  96517d:	eb 40                	jmp    9651bf <check_input_intrinsic_lookup+0x26f>
  96517f:	4d 8d 59 ff          	lea    r11,[r9-0x1]
  965183:	62 d2 fd 28 7c c3    	vpbroadcastq ymm0,r11
  965189:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  965190:	62 d1 7f 89 6f 02    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r10]
  965196:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  96519b:	62 f2 7d 89 47 05 3b 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffca433b]        # 6094e0 <abi_test_hex.digits+0x670>
  9651a2:	43 ca ff 
  9651a5:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  9651aa:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  9651ae:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  9651b3:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  9651b7:	c4 c1 79 7e c2       	vmovd  r10d,xmm0
  9651bc:	45 89 d3             	mov    r11d,r10d
  9651bf:	45 69 c9 b9 79 37 9e 	imul   r9d,r9d,0x9e3779b9
  9651c6:	0f ab f1             	bts    ecx,esi
  9651c9:	c4 43 7b f0 d2 13    	rorx   r10d,r10d,0x13
  9651cf:	45 31 d9             	xor    r9d,r11d
  9651d2:	45 31 d1             	xor    r9d,r10d
  9651d5:	44 89 8c b4 20 01 00 	mov    DWORD PTR [rsp+rsi*4+0x120],r9d
  9651dc:	00 
  9651dd:	4d 8b 50 f8          	mov    r10,QWORD PTR [r8-0x8]
  9651e1:	4d 85 d2             	test   r10,r10
  9651e4:	0f 84 62 ff ff ff    	je     96514c <check_input_intrinsic_lookup+0x1fc>
  9651ea:	45 8b 08             	mov    r9d,DWORD PTR [r8]
  9651ed:	4d 85 c9             	test   r9,r9
  9651f0:	0f 84 56 ff ff ff    	je     96514c <check_input_intrinsic_lookup+0x1fc>
  9651f6:	41 83 f9 03          	cmp    r9d,0x3
  9651fa:	0f 87 21 ff ff ff    	ja     965121 <check_input_intrinsic_lookup+0x1d1>
  965200:	4d 8d 59 ff          	lea    r11,[r9-0x1]
  965204:	62 d2 fd 28 7c c3    	vpbroadcastq ymm0,r11
  96520a:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  965211:	62 d1 7f 89 6f 02    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r10]
  965217:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  96521c:	62 f2 7d 89 47 05 ba 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffca42ba]        # 6094e0 <abi_test_hex.digits+0x670>
  965223:	42 ca ff 
  965226:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  96522b:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  96522f:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  965234:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  965238:	c4 c1 79 7e c2       	vmovd  r10d,xmm0
  96523d:	45 89 d3             	mov    r11d,r10d
  965240:	e9 e4 fe ff ff       	jmp    965129 <check_input_intrinsic_lookup+0x1d9>
  965245:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  96524c:	00 00 00 00 
  965250:	4c 8b 44 24 08       	mov    r8,QWORD PTR [rsp+0x8]
  965255:	41 f6 c0 01          	test   r8b,0x1
  965259:	75 09                	jne    965264 <check_input_intrinsic_lookup+0x314>
  96525b:	e9 97 00 00 00       	jmp    9652f7 <check_input_intrinsic_lookup+0x3a7>
  965260:	31 f6                	xor    esi,esi
  965262:	31 c9                	xor    ecx,ecx
  965264:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  965269:	49 89 f1             	mov    r9,rsi
  96526c:	49 c1 e1 04          	shl    r9,0x4
  965270:	48 01 ef             	add    rdi,rbp
  965273:	4e 8b 04 0f          	mov    r8,QWORD PTR [rdi+r9*1]
  965277:	4d 85 c0             	test   r8,r8
  96527a:	74 76                	je     9652f2 <check_input_intrinsic_lookup+0x3a2>
  96527c:	4c 01 cf             	add    rdi,r9
  96527f:	8b 7f 08             	mov    edi,DWORD PTR [rdi+0x8]
  965282:	48 85 ff             	test   rdi,rdi
  965285:	74 6b                	je     9652f2 <check_input_intrinsic_lookup+0x3a2>
  965287:	83 ff 03             	cmp    edi,0x3
  96528a:	76 0a                	jbe    965296 <check_input_intrinsic_lookup+0x346>
  96528c:	45 8b 08             	mov    r9d,DWORD PTR [r8]
  96528f:	45 8b 44 38 fc       	mov    r8d,DWORD PTR [r8+rdi*1-0x4]
  965294:	eb 40                	jmp    9652d6 <check_input_intrinsic_lookup+0x386>
  965296:	4c 8d 4f ff          	lea    r9,[rdi-0x1]
  96529a:	62 d2 fd 28 7c c1    	vpbroadcastq ymm0,r9
  9652a0:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  9652a7:	62 d1 7f 89 6f 00    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r8]
  9652ad:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  9652b2:	62 f2 7d 89 47 05 24 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffca4224]        # 6094e0 <abi_test_hex.digits+0x670>
  9652b9:	42 ca ff 
  9652bc:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  9652c1:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  9652c5:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  9652ca:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  9652ce:	c4 c1 79 7e c0       	vmovd  r8d,xmm0
  9652d3:	45 89 c1             	mov    r9d,r8d
  9652d6:	69 ff b9 79 37 9e    	imul   edi,edi,0x9e3779b9
  9652dc:	0f ab f1             	bts    ecx,esi
  9652df:	c4 43 7b f0 c0 13    	rorx   r8d,r8d,0x13
  9652e5:	44 31 cf             	xor    edi,r9d
  9652e8:	44 31 c7             	xor    edi,r8d
  9652eb:	89 bc b4 20 01 00 00 	mov    DWORD PTR [rsp+rsi*4+0x120],edi
  9652f2:	4c 8b 44 24 08       	mov    r8,QWORD PTR [rsp+0x8]
  9652f7:	c5 fe 6f 84 24 20 01 	vmovdqu ymm0,YMMWORD PTR [rsp+0x120]
  9652fe:	00 00 
  965300:	44 89 c6             	mov    esi,r8d
  965303:	83 e6 03             	and    esi,0x3
  965306:	c5 f5 72 d0 10       	vpsrld ymm1,ymm0,0x10
  96530b:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
  96530f:	62 f2 7d 38 40 05 9b 	vpmulld ymm0,ymm0,DWORD BCST [rip+0xffffffffffcbed9b]        # 6240b4 <link_program_emit_worker.forms+0x4bc>
  965316:	ed cb ff 
  965319:	c5 f5 72 d0 0f       	vpsrld ymm1,ymm0,0xf
  96531e:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
  965322:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  965326:	c4 e3 7d 0e c1 aa    	vpblendw ymm0,ymm0,ymm1,0xaa
  96532c:	c5 fe 7f 84 24 00 01 	vmovdqu YMMWORD PTR [rsp+0x100],ymm0
  965333:	00 00 
  965335:	48 83 fa 03          	cmp    rdx,0x3
  965339:	73 15                	jae    965350 <check_input_intrinsic_lookup+0x400>
  96533b:	31 ff                	xor    edi,edi
  96533d:	31 d2                	xor    edx,edx
  96533f:	e9 e1 00 00 00       	jmp    965425 <check_input_intrinsic_lookup+0x4d5>
  965344:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  96534b:	00 00 00 00 00 
  965350:	41 83 e0 0c          	and    r8d,0xc
  965354:	31 ff                	xor    edi,edi
  965356:	31 d2                	xor    edx,edx
  965358:	eb 13                	jmp    96536d <check_input_intrinsic_lookup+0x41d>
  96535a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  965360:	48 83 c7 04          	add    rdi,0x4
  965364:	49 39 f8             	cmp    r8,rdi
  965367:	0f 84 b3 00 00 00    	je     965420 <check_input_intrinsic_lookup+0x4d0>
  96536d:	0f a3 f9             	bt     ecx,edi
  965370:	73 21                	jae    965393 <check_input_intrinsic_lookup+0x443>
  965372:	44 8b 8c bc 00 01 00 	mov    r9d,DWORD PTR [rsp+rdi*4+0x100]
  965379:	00 
  96537a:	45 89 ca             	mov    r10d,r9d
  96537d:	41 c1 ea 06          	shr    r10d,0x6
  965381:	c4 02 b3 f7 0c d6    	shrx   r9,QWORD PTR [r14+r10*8],r9
  965387:	41 83 e1 01          	and    r9d,0x1
  96538b:	c4 42 41 f7 c9       	shlx   r9d,r9d,edi
  965390:	44 09 ca             	or     edx,r9d
  965393:	4c 8d 4f 01          	lea    r9,[rdi+0x1]
  965397:	44 0f a3 c9          	bt     ecx,r9d
  96539b:	73 21                	jae    9653be <check_input_intrinsic_lookup+0x46e>
  96539d:	44 8b 94 bc 04 01 00 	mov    r10d,DWORD PTR [rsp+rdi*4+0x104]
  9653a4:	00 
  9653a5:	45 89 d3             	mov    r11d,r10d
  9653a8:	41 c1 eb 06          	shr    r11d,0x6
  9653ac:	c4 02 ab f7 14 de    	shrx   r10,QWORD PTR [r14+r11*8],r10
  9653b2:	41 83 e2 01          	and    r10d,0x1
  9653b6:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
  9653bb:	44 09 ca             	or     edx,r9d
  9653be:	4c 8d 4f 02          	lea    r9,[rdi+0x2]
  9653c2:	44 0f a3 c9          	bt     ecx,r9d
  9653c6:	73 21                	jae    9653e9 <check_input_intrinsic_lookup+0x499>
  9653c8:	44 8b 94 bc 08 01 00 	mov    r10d,DWORD PTR [rsp+rdi*4+0x108]
  9653cf:	00 
  9653d0:	45 89 d3             	mov    r11d,r10d
  9653d3:	41 c1 eb 06          	shr    r11d,0x6
  9653d7:	c4 02 ab f7 14 de    	shrx   r10,QWORD PTR [r14+r11*8],r10
  9653dd:	41 83 e2 01          	and    r10d,0x1
  9653e1:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
  9653e6:	44 09 ca             	or     edx,r9d
  9653e9:	4c 8d 4f 03          	lea    r9,[rdi+0x3]
  9653ed:	44 0f a3 c9          	bt     ecx,r9d
  9653f1:	0f 83 69 ff ff ff    	jae    965360 <check_input_intrinsic_lookup+0x410>
  9653f7:	44 8b 94 bc 0c 01 00 	mov    r10d,DWORD PTR [rsp+rdi*4+0x10c]
  9653fe:	00 
  9653ff:	45 89 d3             	mov    r11d,r10d
  965402:	41 c1 eb 06          	shr    r11d,0x6
  965406:	c4 02 ab f7 14 de    	shrx   r10,QWORD PTR [r14+r11*8],r10
  96540c:	41 83 e2 01          	and    r10d,0x1
  965410:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
  965415:	44 09 ca             	or     edx,r9d
  965418:	e9 43 ff ff ff       	jmp    965360 <check_input_intrinsic_lookup+0x410>
  96541d:	0f 1f 00             	nop    DWORD PTR [rax]
  965420:	48 85 f6             	test   rsi,rsi
  965423:	74 4b                	je     965470 <check_input_intrinsic_lookup+0x520>
  965425:	c1 e6 02             	shl    esi,0x2
  965428:	eb 0f                	jmp    965439 <check_input_intrinsic_lookup+0x4e9>
  96542a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  965430:	48 ff c7             	inc    rdi
  965433:	48 83 c6 fc          	add    rsi,0xfffffffffffffffc
  965437:	74 37                	je     965470 <check_input_intrinsic_lookup+0x520>
  965439:	0f a3 f9             	bt     ecx,edi
  96543c:	73 f2                	jae    965430 <check_input_intrinsic_lookup+0x4e0>
  96543e:	44 8b 84 bc 00 01 00 	mov    r8d,DWORD PTR [rsp+rdi*4+0x100]
  965445:	00 
  965446:	45 89 c1             	mov    r9d,r8d
  965449:	41 c1 e9 06          	shr    r9d,0x6
  96544d:	c4 02 bb f7 04 ce    	shrx   r8,QWORD PTR [r14+r9*8],r8
  965453:	41 83 e0 01          	and    r8d,0x1
  965457:	c4 42 41 f7 c0       	shlx   r8d,r8d,edi
  96545c:	44 09 c2             	or     edx,r8d
  96545f:	eb cf                	jmp    965430 <check_input_intrinsic_lookup+0x4e0>
  965461:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  965468:	0f 1f 84 00 00 00 00 
  96546f:	00 
  965470:	48 8b 74 24 08       	mov    rsi,QWORD PTR [rsp+0x8]
  965475:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  965479:	44 39 fb             	cmp    ebx,r15d
  96547c:	0f 84 7e 01 00 00    	je     965600 <check_input_intrinsic_lookup+0x6b0>
  965482:	89 d1                	mov    ecx,edx
  965484:	83 e1 01             	and    ecx,0x1
  965487:	4a c7 84 fc c0 00 00 	mov    QWORD PTR [rsp+r15*8+0xc0],0x0
  96548e:	00 00 00 00 00 
  965493:	f7 d9                	neg    ecx
  965495:	81 e1 bf 0e 00 00    	and    ecx,0xebf
  96549b:	c5 f9 6e c9          	vmovd  xmm1,ecx
  96549f:	83 f8 01             	cmp    eax,0x1
  9654a2:	0f 84 58 01 00 00    	je     965600 <check_input_intrinsic_lookup+0x6b0>
  9654a8:	89 d7                	mov    edi,edx
  9654aa:	c1 e7 1e             	shl    edi,0x1e
  9654ad:	41 8d 4f 01          	lea    ecx,[r15+0x1]
  9654b1:	c1 ff 1f             	sar    edi,0x1f
  9654b4:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  9654bb:	00 00 00 00 00 
  9654c0:	81 e7 bf 0e 00 00    	and    edi,0xebf
  9654c6:	c4 e3 71 22 c7 01    	vpinsrd xmm0,xmm1,edi,0x1
  9654cc:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  9654d2:	83 f8 02             	cmp    eax,0x2
  9654d5:	0f 84 25 01 00 00    	je     965600 <check_input_intrinsic_lookup+0x6b0>
  9654db:	89 d7                	mov    edi,edx
  9654dd:	c1 e7 1d             	shl    edi,0x1d
  9654e0:	41 8d 4f 02          	lea    ecx,[r15+0x2]
  9654e4:	c1 ff 1f             	sar    edi,0x1f
  9654e7:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  9654ee:	00 00 00 00 00 
  9654f3:	81 e7 bf 0e 00 00    	and    edi,0xebf
  9654f9:	c4 e3 71 22 c7 02    	vpinsrd xmm0,xmm1,edi,0x2
  9654ff:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  965505:	83 f8 03             	cmp    eax,0x3
  965508:	0f 84 f2 00 00 00    	je     965600 <check_input_intrinsic_lookup+0x6b0>
  96550e:	89 d7                	mov    edi,edx
  965510:	c1 e7 1c             	shl    edi,0x1c
  965513:	41 8d 4f 03          	lea    ecx,[r15+0x3]
  965517:	c1 ff 1f             	sar    edi,0x1f
  96551a:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  965521:	00 00 00 00 00 
  965526:	81 e7 bf 0e 00 00    	and    edi,0xebf
  96552c:	c4 e3 71 22 c7 03    	vpinsrd xmm0,xmm1,edi,0x3
  965532:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  965538:	83 f8 04             	cmp    eax,0x4
  96553b:	0f 84 bf 00 00 00    	je     965600 <check_input_intrinsic_lookup+0x6b0>
  965541:	89 d7                	mov    edi,edx
  965543:	c1 e7 1b             	shl    edi,0x1b
  965546:	41 8d 4f 04          	lea    ecx,[r15+0x4]
  96554a:	c1 ff 1f             	sar    edi,0x1f
  96554d:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  965554:	00 00 00 00 00 
  965559:	81 e7 bf 0e 00 00    	and    edi,0xebf
  96555f:	62 f2 7d 28 7c c7    	vpbroadcastd ymm0,edi
  965565:	c4 e3 75 02 c8 10    	vpblendd ymm1,ymm1,ymm0,0x10
  96556b:	83 f8 05             	cmp    eax,0x5
  96556e:	0f 84 8c 00 00 00    	je     965600 <check_input_intrinsic_lookup+0x6b0>
  965574:	89 d7                	mov    edi,edx
  965576:	c1 e7 1a             	shl    edi,0x1a
  965579:	41 8d 4f 05          	lea    ecx,[r15+0x5]
  96557d:	c1 ff 1f             	sar    edi,0x1f
  965580:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  965587:	00 00 00 00 00 
  96558c:	81 e7 bf 0e 00 00    	and    edi,0xebf
  965592:	62 f2 7d 28 7c c7    	vpbroadcastd ymm0,edi
  965598:	c4 e3 75 02 c8 20    	vpblendd ymm1,ymm1,ymm0,0x20
  96559e:	83 f8 06             	cmp    eax,0x6
  9655a1:	74 5d                	je     965600 <check_input_intrinsic_lookup+0x6b0>
  9655a3:	89 d7                	mov    edi,edx
  9655a5:	c1 e7 19             	shl    edi,0x19
  9655a8:	41 8d 4f 06          	lea    ecx,[r15+0x6]
  9655ac:	c1 ff 1f             	sar    edi,0x1f
  9655af:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  9655b6:	00 00 00 00 00 
  9655bb:	81 e7 bf 0e 00 00    	and    edi,0xebf
  9655c1:	62 f2 7d 28 7c c7    	vpbroadcastd ymm0,edi
  9655c7:	c4 e3 75 02 c8 40    	vpblendd ymm1,ymm1,ymm0,0x40
  9655cd:	83 f8 07             	cmp    eax,0x7
  9655d0:	74 2e                	je     965600 <check_input_intrinsic_lookup+0x6b0>
  9655d2:	0f be ca             	movsx  ecx,dl
  9655d5:	41 8d 47 07          	lea    eax,[r15+0x7]
  9655d9:	c1 e9 07             	shr    ecx,0x7
  9655dc:	48 c7 84 c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],0x0
  9655e3:	00 00 00 00 00 
  9655e8:	81 e1 bf 0e 00 00    	and    ecx,0xebf
  9655ee:	62 f2 7d 28 7c c1    	vpbroadcastd ymm0,ecx
  9655f4:	c4 e3 75 02 c8 80    	vpblendd ymm1,ymm1,ymm0,0x80
  9655fa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  965600:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  965604:	c5 f5 66 c2          	vpcmpgtd ymm0,ymm1,ymm2
  965608:	c4 e2 7d 0e c0       	vtestps ymm0,ymm0
  96560d:	0f 84 ad fa ff ff    	je     9650c0 <check_input_intrinsic_lookup+0x170>
  965613:	48 03 6c 24 48       	add    rbp,QWORD PTR [rsp+0x48]
  965618:	62 f1 75 28 66 ca    	vpcmpgtd k1,ymm1,ymm2
  96561e:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  965622:	4c 89 7c 24 38       	mov    QWORD PTR [rsp+0x38],r15
  965627:	c5 f8 91 4c 24 28    	kmovw  WORD PTR [rsp+0x28],k1
  96562d:	48 89 6c 24 58       	mov    QWORD PTR [rsp+0x58],rbp
  965632:	e9 8f 00 00 00       	jmp    9656c6 <check_input_intrinsic_lookup+0x776>
  965637:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  96563e:	00 00 
  965640:	c5 fe 6f 84 24 00 01 	vmovdqu ymm0,YMMWORD PTR [rsp+0x100]
  965647:	00 00 
  965649:	8b 5c 24 34          	mov    ebx,DWORD PTR [rsp+0x34]
  96564d:	4c 8b 7c 24 38       	mov    r15,QWORD PTR [rsp+0x38]
  965652:	48 8b 6c 24 58       	mov    rbp,QWORD PTR [rsp+0x58]
  965657:	4c 8d 35 f2 31 b6 ff 	lea    r14,[rip+0xffffffffffb631f2]        # 4c8850 <builtin_intrinsic_filter_bits>
  96565e:	c5 fe 6f 9c 24 a0 00 	vmovdqu ymm3,YMMWORD PTR [rsp+0xa0]
  965665:	00 00 
  965667:	c5 fe 6f a4 24 80 00 	vmovdqu ymm4,YMMWORD PTR [rsp+0x80]
  96566e:	00 00 
  965670:	c5 f8 90 54 24 28    	kmovw  k2,WORD PTR [rsp+0x28]
  965676:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  96567a:	c5 f5 76 c9          	vpcmpeqd ymm1,ymm1,ymm1
  96567e:	62 f1 7d 2a 66 ca    	vpcmpgtd k1{k2},ymm0,ymm2
  965684:	62 f1 7d aa 72 e0 1f 	vpsrad ymm0{k2}{z},ymm0,0x1f
  96568b:	62 f1 5d 29 fa d9    	vpsubd ymm3{k1},ymm4,ymm1
  965691:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  965697:	c4 e3 65 4c c4 00    	vpblendvb ymm0,ymm3,ymm4,ymm0
  96569d:	62 f1 7d 29 6f c1    	vmovdqa32 ymm0{k1},ymm1
  9656a3:	c5 fd 66 cb          	vpcmpgtd ymm1,ymm0,ymm3
  9656a7:	62 f1 7d 28 66 cb    	vpcmpgtd k1,ymm0,ymm3
  9656ad:	c4 e2 7d 0e c9       	vtestps ymm1,ymm1
  9656b2:	c5 fd 6f c8          	vmovdqa ymm1,ymm0
  9656b6:	c5 fd 6f c3          	vmovdqa ymm0,ymm3
  9656ba:	c5 f8 91 4c 24 28    	kmovw  WORD PTR [rsp+0x28],k1
  9656c0:	0f 84 fa f9 ff ff    	je     9650c0 <check_input_intrinsic_lookup+0x170>
  9656c6:	c5 fd 6f d8          	vmovdqa ymm3,ymm0
  9656ca:	c5 f5 fa c0          	vpsubd ymm0,ymm1,ymm0
  9656ce:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  9656d4:	c5 fe 7f 9c 24 a0 00 	vmovdqu YMMWORD PTR [rsp+0xa0],ymm3
  9656db:	00 00 
  9656dd:	c5 fe 7f 94 24 00 01 	vmovdqu YMMWORD PTR [rsp+0x100],ymm2
  9656e4:	00 00 
  9656e6:	c5 fd 72 d0 01       	vpsrld ymm0,ymm0,0x1
  9656eb:	c5 fd fe c3          	vpaddd ymm0,ymm0,ymm3
  9656ef:	c5 fe 7f 84 24 80 00 	vmovdqu YMMWORD PTR [rsp+0x80],ymm0
  9656f6:	00 00 
  9656f8:	c5 fe 7f 84 24 20 01 	vmovdqu YMMWORD PTR [rsp+0x120],ymm0
  9656ff:	00 00 
  965701:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  965705:	44 39 fb             	cmp    ebx,r15d
  965708:	0f 84 50 ff ff ff    	je     96565e <check_input_intrinsic_lookup+0x70e>
  96570e:	c5 f8 90 4c 24 28    	kmovw  k1,WORD PTR [rsp+0x28]
  965714:	45 31 ed             	xor    r13d,r13d
  965717:	c5 79 93 e1          	kmovb  r12d,k1
  96571b:	eb 1b                	jmp    965738 <check_input_intrinsic_lookup+0x7e8>
  96571d:	0f 1f 00             	nop    DWORD PTR [rax]
  965720:	42 89 84 ac 00 01 00 	mov    DWORD PTR [rsp+r13*4+0x100],eax
  965727:	00 
  965728:	49 ff c5             	inc    r13
  96572b:	48 83 c5 10          	add    rbp,0x10
  96572f:	4c 39 ee             	cmp    rsi,r13
  965732:	0f 84 08 ff ff ff    	je     965640 <check_input_intrinsic_lookup+0x6f0>
  965738:	45 0f a3 ec          	bt     r12d,r13d
  96573c:	73 ea                	jae    965728 <check_input_intrinsic_lookup+0x7d8>
  96573e:	4a 63 84 ac 20 01 00 	movsxd rax,DWORD PTR [rsp+r13*4+0x120]
  965745:	00 
  965746:	48 8d 0d f3 95 87 01 	lea    rcx,[rip+0x18795f3]        # 21ded40 <builtin_intrinsic_infos>
  96574d:	44 8b 7d 00          	mov    r15d,DWORD PTR [rbp+0x0]
  965751:	48 8d 04 40          	lea    rax,[rax+rax*2]
  965755:	48 c1 e0 05          	shl    rax,0x5
  965759:	8b 5c 08 40          	mov    ebx,DWORD PTR [rax+rcx*1+0x40]
  96575d:	4c 8d 34 01          	lea    r14,[rcx+rax*1]
  965761:	41 39 df             	cmp    r15d,ebx
  965764:	89 d8                	mov    eax,ebx
  965766:	41 0f 42 c7          	cmovb  eax,r15d
  96576a:	85 c0                	test   eax,eax
  96576c:	74 1a                	je     965788 <check_input_intrinsic_lookup+0x838>
  96576e:	48 8b 7d f8          	mov    rdi,QWORD PTR [rbp-0x8]
  965772:	49 8b 36             	mov    rsi,QWORD PTR [r14]
  965775:	89 c2                	mov    edx,eax
  965777:	c5 f8 77             	vzeroupper
  96577a:	e8 81 53 fa ff       	call   90ab00 <memcmp@plt>
  96577f:	48 8b 74 24 08       	mov    rsi,QWORD PTR [rsp+0x8]
  965784:	85 c0                	test   eax,eax
  965786:	75 98                	jne    965720 <check_input_intrinsic_lookup+0x7d0>
  965788:	41 39 df             	cmp    r15d,ebx
  96578b:	0f 97 c0             	seta   al
  96578e:	1c 00                	sbb    al,0x0
  965790:	0f be c0             	movsx  eax,al
  965793:	42 89 84 ac 00 01 00 	mov    DWORD PTR [rsp+r13*4+0x100],eax
  96579a:	00 
  96579b:	41 39 df             	cmp    r15d,ebx
  96579e:	75 88                	jne    965728 <check_input_intrinsic_lookup+0x7d8>
  9657a0:	48 8b 44 24 38       	mov    rax,QWORD PTR [rsp+0x38]
  9657a5:	44 01 e8             	add    eax,r13d
  9657a8:	4c 89 b4 c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],r14
  9657af:	00 
  9657b0:	e9 73 ff ff ff       	jmp    965728 <check_input_intrinsic_lookup+0x7d8>
  9657b5:	b0 01                	mov    al,0x1
  9657b7:	85 db                	test   ebx,ebx
  9657b9:	74 1d                	je     9657d8 <check_input_intrinsic_lookup+0x888>
  9657bb:	48 83 7c 24 10 00    	cmp    QWORD PTR [rsp+0x10],0x0
  9657c1:	89 da                	mov    edx,ebx
  9657c3:	74 3f                	je     965804 <check_input_intrinsic_lookup+0x8b4>
  9657c5:	89 d1                	mov    ecx,edx
  9657c7:	83 e1 03             	and    ecx,0x3
  9657ca:	83 fb 04             	cmp    ebx,0x4
  9657cd:	73 5a                	jae    965829 <check_input_intrinsic_lookup+0x8d9>
  9657cf:	31 f6                	xor    esi,esi
  9657d1:	e9 7c 01 00 00       	jmp    965952 <check_input_intrinsic_lookup+0xa02>
  9657d6:	b0 01                	mov    al,0x1
  9657d8:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  9657df:	00 00 
  9657e1:	48 3b 8c 24 40 01 00 	cmp    rcx,QWORD PTR [rsp+0x140]
  9657e8:	00 
  9657e9:	0f 85 cd 01 00 00    	jne    9659bc <check_input_intrinsic_lookup+0xa6c>
  9657ef:	48 81 c4 48 01 00 00 	add    rsp,0x148
  9657f6:	5b                   	pop    rbx
  9657f7:	41 5c                	pop    r12
  9657f9:	41 5d                	pop    r13
  9657fb:	41 5e                	pop    r14
  9657fd:	41 5f                	pop    r15
  9657ff:	5d                   	pop    rbp
  965800:	c5 f8 77             	vzeroupper
  965803:	c3                   	ret
  965804:	b9 01 00 00 00       	mov    ecx,0x1
  965809:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  965810:	48 83 bc cc b8 00 00 	cmp    QWORD PTR [rsp+rcx*8+0xb8],0x0
  965817:	00 00 
  965819:	0f 94 c0             	sete   al
  96581c:	75 ba                	jne    9657d8 <check_input_intrinsic_lookup+0x888>
  96581e:	48 39 d1             	cmp    rcx,rdx
  965821:	48 8d 49 01          	lea    rcx,[rcx+0x1]
  965825:	72 e9                	jb     965810 <check_input_intrinsic_lookup+0x8c0>
  965827:	eb af                	jmp    9657d8 <check_input_intrinsic_lookup+0x888>
  965829:	83 e2 fc             	and    edx,0xfffffffc
  96582c:	48 8d 3d 0d 95 87 01 	lea    rdi,[rip+0x187950d]        # 21ded40 <builtin_intrinsic_infos>
  965833:	31 f6                	xor    esi,esi
  965835:	eb 16                	jmp    96584d <check_input_intrinsic_lookup+0x8fd>
  965837:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  96583e:	00 00 
  965840:	48 83 c6 04          	add    rsi,0x4
  965844:	48 39 f2             	cmp    rdx,rsi
  965847:	0f 84 fc 00 00 00    	je     965949 <check_input_intrinsic_lookup+0x9f9>
  96584d:	4c 8b 84 f4 c0 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xc0]
  965854:	00 
  965855:	4d 85 c0             	test   r8,r8
  965858:	74 2f                	je     965889 <check_input_intrinsic_lookup+0x939>
  96585a:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  96585f:	49 29 f8             	sub    r8,rdi
  965862:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  965867:	49 c1 e8 05          	shr    r8,0x5
  96586b:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  965872:	45 8b 0c b1          	mov    r9d,DWORD PTR [r9+rsi*4]
  965876:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  96587d:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  965881:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
  965886:	41 ff 01             	inc    DWORD PTR [r9]
  965889:	4c 8b 84 f4 c8 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xc8]
  965890:	00 
  965891:	4d 85 c0             	test   r8,r8
  965894:	74 30                	je     9658c6 <check_input_intrinsic_lookup+0x976>
  965896:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  96589b:	49 29 f8             	sub    r8,rdi
  96589e:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  9658a3:	49 c1 e8 05          	shr    r8,0x5
  9658a7:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  9658ae:	45 8b 4c b1 04       	mov    r9d,DWORD PTR [r9+rsi*4+0x4]
  9658b3:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  9658ba:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  9658be:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
  9658c3:	41 ff 01             	inc    DWORD PTR [r9]
  9658c6:	4c 8b 84 f4 d0 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xd0]
  9658cd:	00 
  9658ce:	4d 85 c0             	test   r8,r8
  9658d1:	74 30                	je     965903 <check_input_intrinsic_lookup+0x9b3>
  9658d3:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  9658d8:	49 29 f8             	sub    r8,rdi
  9658db:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  9658e0:	49 c1 e8 05          	shr    r8,0x5
  9658e4:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  9658eb:	45 8b 4c b1 08       	mov    r9d,DWORD PTR [r9+rsi*4+0x8]
  9658f0:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  9658f7:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  9658fb:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
  965900:	41 ff 01             	inc    DWORD PTR [r9]
  965903:	4c 8b 84 f4 d8 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xd8]
  96590a:	00 
  96590b:	4d 85 c0             	test   r8,r8
  96590e:	0f 84 2c ff ff ff    	je     965840 <check_input_intrinsic_lookup+0x8f0>
  965914:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  965919:	49 29 f8             	sub    r8,rdi
  96591c:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  965921:	49 c1 e8 05          	shr    r8,0x5
  965925:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  96592c:	45 8b 4c b1 0c       	mov    r9d,DWORD PTR [r9+rsi*4+0xc]
  965931:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  965938:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  96593c:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
  965941:	41 ff 01             	inc    DWORD PTR [r9]
  965944:	e9 f7 fe ff ff       	jmp    965840 <check_input_intrinsic_lookup+0x8f0>
  965949:	48 85 c9             	test   rcx,rcx
  96594c:	0f 84 86 fe ff ff    	je     9657d8 <check_input_intrinsic_lookup+0x888>
  965952:	48 8b 54 24 18       	mov    rdx,QWORD PTR [rsp+0x18]
  965957:	4c 8b 5c 24 10       	mov    r11,QWORD PTR [rsp+0x10]
  96595c:	4c 8d 05 dd 93 87 01 	lea    r8,[rip+0x18793dd]        # 21ded40 <builtin_intrinsic_infos>
  965963:	31 ff                	xor    edi,edi
  965965:	48 8d 14 b2          	lea    rdx,[rdx+rsi*4]
  965969:	48 8d b4 f4 c0 00 00 	lea    rsi,[rsp+rsi*8+0xc0]
  965970:	00 
  965971:	eb 19                	jmp    96598c <check_input_intrinsic_lookup+0xa3c>
  965973:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  96597a:	84 00 00 00 00 00 
  965980:	48 ff c7             	inc    rdi
  965983:	48 39 f9             	cmp    rcx,rdi
  965986:	0f 84 4c fe ff ff    	je     9657d8 <check_input_intrinsic_lookup+0x888>
  96598c:	4c 8b 0c fe          	mov    r9,QWORD PTR [rsi+rdi*8]
  965990:	4d 85 c9             	test   r9,r9
  965993:	74 eb                	je     965980 <check_input_intrinsic_lookup+0xa30>
  965995:	4d 29 c1             	sub    r9,r8
  965998:	44 8b 14 ba          	mov    r10d,DWORD PTR [rdx+rdi*4]
  96599c:	49 c1 e9 05          	shr    r9,0x5
  9659a0:	45 69 c9 ab aa aa aa 	imul   r9d,r9d,0xaaaaaaab
  9659a7:	41 81 c9 00 00 00 80 	or     r9d,0x80000000
  9659ae:	47 89 0c 93          	mov    DWORD PTR [r11+r10*4],r9d
  9659b2:	4c 8b 54 24 20       	mov    r10,QWORD PTR [rsp+0x20]
  9659b7:	41 ff 02             	inc    DWORD PTR [r10]
  9659ba:	eb c4                	jmp    965980 <check_input_intrinsic_lookup+0xa30>
  9659bc:	c5 f8 77             	vzeroupper
  9659bf:	e8 2c 48 fa ff       	call   90a1f0 <__stack_chk_fail@plt>
