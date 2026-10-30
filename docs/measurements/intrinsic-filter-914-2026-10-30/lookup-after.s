
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000958ef0 <check_input_intrinsic_lookup>:
  958ef0:	55                   	push   rbp
  958ef1:	41 57                	push   r15
  958ef3:	41 56                	push   r14
  958ef5:	41 55                	push   r13
  958ef7:	41 54                	push   r12
  958ef9:	53                   	push   rbx
  958efa:	48 81 ec 48 01 00 00 	sub    rsp,0x148
  958f01:	4c 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],r9
  958f06:	4c 89 44 24 10       	mov    QWORD PTR [rsp+0x10],r8
  958f0b:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
  958f10:	48 89 74 24 40       	mov    QWORD PTR [rsp+0x40],rsi
  958f15:	89 cb                	mov    ebx,ecx
  958f17:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  958f1e:	00 00 
  958f20:	48 89 84 24 40 01 00 	mov    QWORD PTR [rsp+0x140],rax
  958f27:	00 
  958f28:	89 4c 24 34          	mov    DWORD PTR [rsp+0x34],ecx
  958f2c:	40 f6 c7 01          	test   dil,0x1
  958f30:	0f 84 ee 00 00 00    	je     959024 <check_input_intrinsic_lookup+0x134>
  958f36:	85 db                	test   ebx,ebx
  958f38:	0f 84 38 08 00 00    	je     959776 <check_input_intrinsic_lookup+0x886>
  958f3e:	89 d8                	mov    eax,ebx
  958f40:	48 89 44 24 60       	mov    QWORD PTR [rsp+0x60],rax
  958f45:	31 c0                	xor    eax,eax
  958f47:	eb 28                	jmp    958f71 <check_input_intrinsic_lookup+0x81>
  958f49:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  958f50:	31 db                	xor    ebx,ebx
  958f52:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
  958f57:	48 89 9c c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],rbx
  958f5e:	00 
  958f5f:	8b 5c 24 34          	mov    ebx,DWORD PTR [rsp+0x34]
  958f63:	48 ff c0             	inc    rax
  958f66:	48 3b 44 24 60       	cmp    rax,QWORD PTR [rsp+0x60]
  958f6b:	0f 84 e4 07 00 00    	je     959755 <check_input_intrinsic_lookup+0x865>
  958f71:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
  958f76:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
  958f7b:	48 c1 e0 04          	shl    rax,0x4
  958f7f:	48 8b 14 01          	mov    rdx,QWORD PTR [rcx+rax*1]
  958f83:	8b 74 01 08          	mov    esi,DWORD PTR [rcx+rax*1+0x8]
  958f87:	48 85 d2             	test   rdx,rdx
  958f8a:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
  958f8f:	0f 94 c0             	sete   al
  958f92:	85 f6                	test   esi,esi
  958f94:	0f 94 c1             	sete   cl
  958f97:	08 c1                	or     cl,al
  958f99:	75 b5                	jne    958f50 <check_input_intrinsic_lookup+0x60>
  958f9b:	bd bf 0e 00 00       	mov    ebp,0xebf
  958fa0:	31 db                	xor    ebx,ebx
  958fa2:	45 31 f6             	xor    r14d,r14d
  958fa5:	89 74 24 38          	mov    DWORD PTR [rsp+0x38],esi
  958fa9:	eb 2f                	jmp    958fda <check_input_intrinsic_lookup+0xea>
  958fab:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
  958fb0:	44 39 e6             	cmp    esi,r12d
  958fb3:	0f 97 c0             	seta   al
  958fb6:	1c 00                	sbb    al,0x0
  958fb8:	0f be c0             	movsx  eax,al
  958fbb:	85 c0                	test   eax,eax
  958fbd:	41 8d 4d 01          	lea    ecx,[r13+0x1]
  958fc1:	41 0f 48 ed          	cmovs  ebp,r13d
  958fc5:	49 0f 44 df          	cmove  rbx,r15
  958fc9:	41 0f 44 ee          	cmove  ebp,r14d
  958fcd:	44 0f 4f f1          	cmovg  r14d,ecx
  958fd1:	41 39 ee             	cmp    r14d,ebp
  958fd4:	0f 83 78 ff ff ff    	jae    958f52 <check_input_intrinsic_lookup+0x62>
  958fda:	41 89 ed             	mov    r13d,ebp
  958fdd:	45 29 f5             	sub    r13d,r14d
  958fe0:	48 8d 0d 69 9b 86 01 	lea    rcx,[rip+0x1869b69]        # 21c2b50 <builtin_intrinsic_infos>
  958fe7:	41 d1 ed             	shr    r13d,1
  958fea:	45 01 f5             	add    r13d,r14d
  958fed:	4b 8d 44 6d 00       	lea    rax,[r13+r13*2+0x0]
  958ff2:	48 c1 e0 05          	shl    rax,0x5
  958ff6:	44 8b 64 08 40       	mov    r12d,DWORD PTR [rax+rcx*1+0x40]
  958ffb:	4c 8d 3c 01          	lea    r15,[rcx+rax*1]
  958fff:	45 85 e4             	test   r12d,r12d
  959002:	74 ac                	je     958fb0 <check_input_intrinsic_lookup+0xc0>
  959004:	44 39 e6             	cmp    esi,r12d
  959007:	44 89 e2             	mov    edx,r12d
  95900a:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
  95900f:	0f 42 d6             	cmovb  edx,esi
  959012:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  959015:	e8 86 4d fa ff       	call   8fdda0 <memcmp@plt>
  95901a:	8b 74 24 38          	mov    esi,DWORD PTR [rsp+0x38]
  95901e:	85 c0                	test   eax,eax
  959020:	75 99                	jne    958fbb <check_input_intrinsic_lookup+0xcb>
  959022:	eb 8c                	jmp    958fb0 <check_input_intrinsic_lookup+0xc0>
  959024:	85 db                	test   ebx,ebx
  959026:	0f 84 4a 07 00 00    	je     959776 <check_input_intrinsic_lookup+0x886>
  95902c:	c5 fd 6f 15 ec 88 c9 	vmovdqa ymm2,YMMWORD PTR [rip+0xffffffffffc988ec]        # 5f1920 <static_test_starved.starved+0xdc0>
  959033:	ff 
  959034:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  959039:	4c 8d 35 d0 e7 b6 ff 	lea    r14,[rip+0xffffffffffb6e7d0]        # 4c7810 <builtin_intrinsic_filter_bits>
  959040:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  959044:	48 8d 48 18          	lea    rcx,[rax+0x18]
  959048:	48 83 c0 08          	add    rax,0x8
  95904c:	48 89 4c 24 50       	mov    QWORD PTR [rsp+0x50],rcx
  959051:	31 c9                	xor    ecx,ecx
  959053:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
  959058:	eb 1f                	jmp    959079 <check_input_intrinsic_lookup+0x189>
  95905a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  959060:	c5 fd 6f 15 b8 88 c9 	vmovdqa ymm2,YMMWORD PTR [rip+0xffffffffffc988b8]        # 5f1920 <static_test_starved.starved+0xdc0>
  959067:	ff 
  959068:	44 01 fe             	add    esi,r15d
  95906b:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  95906f:	89 f1                	mov    ecx,esi
  959071:	39 de                	cmp    esi,ebx
  959073:	0f 83 dc 06 00 00    	jae    959755 <check_input_intrinsic_lookup+0x865>
  959079:	89 d8                	mov    eax,ebx
  95907b:	29 c8                	sub    eax,ecx
  95907d:	be 08 00 00 00       	mov    esi,0x8
  959082:	41 89 cf             	mov    r15d,ecx
  959085:	4c 89 fd             	mov    rbp,r15
  959088:	c5 fe 7f 84 24 20 01 	vmovdqu YMMWORD PTR [rsp+0x120],ymm0
  95908f:	00 00 
  959091:	83 f8 08             	cmp    eax,0x8
  959094:	0f 42 f0             	cmovb  esi,eax
  959097:	48 c1 e5 04          	shl    rbp,0x4
  95909b:	48 89 f2             	mov    rdx,rsi
  95909e:	48 ff ca             	dec    rdx
  9590a1:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
  9590a6:	0f 84 54 01 00 00    	je     959200 <check_input_intrinsic_lookup+0x310>
  9590ac:	48 8b 4c 24 50       	mov    rcx,QWORD PTR [rsp+0x50]
  9590b1:	48 89 f7             	mov    rdi,rsi
  9590b4:	83 e7 0e             	and    edi,0xe
  9590b7:	31 f6                	xor    esi,esi
  9590b9:	4c 8d 04 29          	lea    r8,[rcx+rbp*1]
  9590bd:	31 c9                	xor    ecx,ecx
  9590bf:	eb 3c                	jmp    9590fd <check_input_intrinsic_lookup+0x20d>
  9590c1:	45 8b 1a             	mov    r11d,DWORD PTR [r10]
  9590c4:	47 8b 54 0a fc       	mov    r10d,DWORD PTR [r10+r9*1-0x4]
  9590c9:	45 69 c9 b9 79 37 9e 	imul   r9d,r9d,0x9e3779b9
  9590d0:	c4 43 7b f0 d2 13    	rorx   r10d,r10d,0x13
  9590d6:	45 31 d9             	xor    r9d,r11d
  9590d9:	45 31 d1             	xor    r9d,r10d
  9590dc:	44 8d 56 01          	lea    r10d,[rsi+0x1]
  9590e0:	44 0f ab d1          	bts    ecx,r10d
  9590e4:	44 89 8c b4 24 01 00 	mov    DWORD PTR [rsp+rsi*4+0x124],r9d
  9590eb:	00 
  9590ec:	48 83 c6 02          	add    rsi,0x2
  9590f0:	49 83 c0 20          	add    r8,0x20
  9590f4:	48 39 f7             	cmp    rdi,rsi
  9590f7:	0f 84 f3 00 00 00    	je     9591f0 <check_input_intrinsic_lookup+0x300>
  9590fd:	4d 8b 50 e8          	mov    r10,QWORD PTR [r8-0x18]
  959101:	4d 85 d2             	test   r10,r10
  959104:	74 77                	je     95917d <check_input_intrinsic_lookup+0x28d>
  959106:	45 8b 48 f0          	mov    r9d,DWORD PTR [r8-0x10]
  95910a:	4d 85 c9             	test   r9,r9
  95910d:	74 6e                	je     95917d <check_input_intrinsic_lookup+0x28d>
  95910f:	41 83 f9 03          	cmp    r9d,0x3
  959113:	76 0a                	jbe    95911f <check_input_intrinsic_lookup+0x22f>
  959115:	45 8b 1a             	mov    r11d,DWORD PTR [r10]
  959118:	47 8b 54 0a fc       	mov    r10d,DWORD PTR [r10+r9*1-0x4]
  95911d:	eb 40                	jmp    95915f <check_input_intrinsic_lookup+0x26f>
  95911f:	4d 8d 59 ff          	lea    r11,[r9-0x1]
  959123:	62 d2 fd 28 7c c3    	vpbroadcastq ymm0,r11
  959129:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  959130:	62 d1 7f 89 6f 02    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r10]
  959136:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  95913b:	62 f2 7d 89 47 05 3b 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffcad03b]        # 606180 <abi_test_hex.digits+0x670>
  959142:	d0 ca ff 
  959145:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  95914a:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  95914e:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  959153:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  959157:	c4 c1 79 7e c2       	vmovd  r10d,xmm0
  95915c:	45 89 d3             	mov    r11d,r10d
  95915f:	45 69 c9 b9 79 37 9e 	imul   r9d,r9d,0x9e3779b9
  959166:	0f ab f1             	bts    ecx,esi
  959169:	c4 43 7b f0 d2 13    	rorx   r10d,r10d,0x13
  95916f:	45 31 d9             	xor    r9d,r11d
  959172:	45 31 d1             	xor    r9d,r10d
  959175:	44 89 8c b4 20 01 00 	mov    DWORD PTR [rsp+rsi*4+0x120],r9d
  95917c:	00 
  95917d:	4d 8b 50 f8          	mov    r10,QWORD PTR [r8-0x8]
  959181:	4d 85 d2             	test   r10,r10
  959184:	0f 84 62 ff ff ff    	je     9590ec <check_input_intrinsic_lookup+0x1fc>
  95918a:	45 8b 08             	mov    r9d,DWORD PTR [r8]
  95918d:	4d 85 c9             	test   r9,r9
  959190:	0f 84 56 ff ff ff    	je     9590ec <check_input_intrinsic_lookup+0x1fc>
  959196:	41 83 f9 03          	cmp    r9d,0x3
  95919a:	0f 87 21 ff ff ff    	ja     9590c1 <check_input_intrinsic_lookup+0x1d1>
  9591a0:	4d 8d 59 ff          	lea    r11,[r9-0x1]
  9591a4:	62 d2 fd 28 7c c3    	vpbroadcastq ymm0,r11
  9591aa:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  9591b1:	62 d1 7f 89 6f 02    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r10]
  9591b7:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  9591bc:	62 f2 7d 89 47 05 ba 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffcacfba]        # 606180 <abi_test_hex.digits+0x670>
  9591c3:	cf ca ff 
  9591c6:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  9591cb:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  9591cf:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  9591d4:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  9591d8:	c4 c1 79 7e c2       	vmovd  r10d,xmm0
  9591dd:	45 89 d3             	mov    r11d,r10d
  9591e0:	e9 e4 fe ff ff       	jmp    9590c9 <check_input_intrinsic_lookup+0x1d9>
  9591e5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  9591ec:	00 00 00 00 
  9591f0:	4c 8b 44 24 08       	mov    r8,QWORD PTR [rsp+0x8]
  9591f5:	41 f6 c0 01          	test   r8b,0x1
  9591f9:	75 09                	jne    959204 <check_input_intrinsic_lookup+0x314>
  9591fb:	e9 97 00 00 00       	jmp    959297 <check_input_intrinsic_lookup+0x3a7>
  959200:	31 f6                	xor    esi,esi
  959202:	31 c9                	xor    ecx,ecx
  959204:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
  959209:	49 89 f1             	mov    r9,rsi
  95920c:	49 c1 e1 04          	shl    r9,0x4
  959210:	48 01 ef             	add    rdi,rbp
  959213:	4e 8b 04 0f          	mov    r8,QWORD PTR [rdi+r9*1]
  959217:	4d 85 c0             	test   r8,r8
  95921a:	74 76                	je     959292 <check_input_intrinsic_lookup+0x3a2>
  95921c:	4c 01 cf             	add    rdi,r9
  95921f:	8b 7f 08             	mov    edi,DWORD PTR [rdi+0x8]
  959222:	48 85 ff             	test   rdi,rdi
  959225:	74 6b                	je     959292 <check_input_intrinsic_lookup+0x3a2>
  959227:	83 ff 03             	cmp    edi,0x3
  95922a:	76 0a                	jbe    959236 <check_input_intrinsic_lookup+0x346>
  95922c:	45 8b 08             	mov    r9d,DWORD PTR [r8]
  95922f:	45 8b 44 38 fc       	mov    r8d,DWORD PTR [r8+rdi*1-0x4]
  959234:	eb 40                	jmp    959276 <check_input_intrinsic_lookup+0x386>
  959236:	4c 8d 4f ff          	lea    r9,[rdi-0x1]
  95923a:	62 d2 fd 28 7c c1    	vpbroadcastq ymm0,r9
  959240:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  959247:	62 d1 7f 89 6f 00    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r8]
  95924d:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  959252:	62 f2 7d 89 47 05 24 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffcacf24]        # 606180 <abi_test_hex.digits+0x670>
  959259:	cf ca ff 
  95925c:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  959261:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  959265:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  95926a:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  95926e:	c4 c1 79 7e c0       	vmovd  r8d,xmm0
  959273:	45 89 c1             	mov    r9d,r8d
  959276:	69 ff b9 79 37 9e    	imul   edi,edi,0x9e3779b9
  95927c:	0f ab f1             	bts    ecx,esi
  95927f:	c4 43 7b f0 c0 13    	rorx   r8d,r8d,0x13
  959285:	44 31 cf             	xor    edi,r9d
  959288:	44 31 c7             	xor    edi,r8d
  95928b:	89 bc b4 20 01 00 00 	mov    DWORD PTR [rsp+rsi*4+0x120],edi
  959292:	4c 8b 44 24 08       	mov    r8,QWORD PTR [rsp+0x8]
  959297:	c5 fe 6f 84 24 20 01 	vmovdqu ymm0,YMMWORD PTR [rsp+0x120]
  95929e:	00 00 
  9592a0:	44 89 c6             	mov    esi,r8d
  9592a3:	83 e6 03             	and    esi,0x3
  9592a6:	c5 f5 72 d0 10       	vpsrld ymm1,ymm0,0x10
  9592ab:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
  9592af:	62 f2 7d 38 40 05 3b 	vpmulld ymm0,ymm0,DWORD BCST [rip+0xffffffffffcc7a3b]        # 620cf4 <link_program_emit_worker.forms+0x4bc>
  9592b6:	7a cc ff 
  9592b9:	c5 f5 72 d0 0f       	vpsrld ymm1,ymm0,0xf
  9592be:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
  9592c2:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  9592c6:	c4 e3 7d 0e c1 aa    	vpblendw ymm0,ymm0,ymm1,0xaa
  9592cc:	c5 fe 7f 84 24 00 01 	vmovdqu YMMWORD PTR [rsp+0x100],ymm0
  9592d3:	00 00 
  9592d5:	48 83 fa 03          	cmp    rdx,0x3
  9592d9:	73 15                	jae    9592f0 <check_input_intrinsic_lookup+0x400>
  9592db:	31 ff                	xor    edi,edi
  9592dd:	31 d2                	xor    edx,edx
  9592df:	e9 e1 00 00 00       	jmp    9593c5 <check_input_intrinsic_lookup+0x4d5>
  9592e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  9592eb:	00 00 00 00 00 
  9592f0:	41 83 e0 0c          	and    r8d,0xc
  9592f4:	31 ff                	xor    edi,edi
  9592f6:	31 d2                	xor    edx,edx
  9592f8:	eb 13                	jmp    95930d <check_input_intrinsic_lookup+0x41d>
  9592fa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  959300:	48 83 c7 04          	add    rdi,0x4
  959304:	49 39 f8             	cmp    r8,rdi
  959307:	0f 84 b3 00 00 00    	je     9593c0 <check_input_intrinsic_lookup+0x4d0>
  95930d:	0f a3 f9             	bt     ecx,edi
  959310:	73 21                	jae    959333 <check_input_intrinsic_lookup+0x443>
  959312:	44 8b 8c bc 00 01 00 	mov    r9d,DWORD PTR [rsp+rdi*4+0x100]
  959319:	00 
  95931a:	45 89 ca             	mov    r10d,r9d
  95931d:	41 c1 ea 06          	shr    r10d,0x6
  959321:	c4 02 b3 f7 0c d6    	shrx   r9,QWORD PTR [r14+r10*8],r9
  959327:	41 83 e1 01          	and    r9d,0x1
  95932b:	c4 42 41 f7 c9       	shlx   r9d,r9d,edi
  959330:	44 09 ca             	or     edx,r9d
  959333:	4c 8d 4f 01          	lea    r9,[rdi+0x1]
  959337:	44 0f a3 c9          	bt     ecx,r9d
  95933b:	73 21                	jae    95935e <check_input_intrinsic_lookup+0x46e>
  95933d:	44 8b 94 bc 04 01 00 	mov    r10d,DWORD PTR [rsp+rdi*4+0x104]
  959344:	00 
  959345:	45 89 d3             	mov    r11d,r10d
  959348:	41 c1 eb 06          	shr    r11d,0x6
  95934c:	c4 02 ab f7 14 de    	shrx   r10,QWORD PTR [r14+r11*8],r10
  959352:	41 83 e2 01          	and    r10d,0x1
  959356:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
  95935b:	44 09 ca             	or     edx,r9d
  95935e:	4c 8d 4f 02          	lea    r9,[rdi+0x2]
  959362:	44 0f a3 c9          	bt     ecx,r9d
  959366:	73 21                	jae    959389 <check_input_intrinsic_lookup+0x499>
  959368:	44 8b 94 bc 08 01 00 	mov    r10d,DWORD PTR [rsp+rdi*4+0x108]
  95936f:	00 
  959370:	45 89 d3             	mov    r11d,r10d
  959373:	41 c1 eb 06          	shr    r11d,0x6
  959377:	c4 02 ab f7 14 de    	shrx   r10,QWORD PTR [r14+r11*8],r10
  95937d:	41 83 e2 01          	and    r10d,0x1
  959381:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
  959386:	44 09 ca             	or     edx,r9d
  959389:	4c 8d 4f 03          	lea    r9,[rdi+0x3]
  95938d:	44 0f a3 c9          	bt     ecx,r9d
  959391:	0f 83 69 ff ff ff    	jae    959300 <check_input_intrinsic_lookup+0x410>
  959397:	44 8b 94 bc 0c 01 00 	mov    r10d,DWORD PTR [rsp+rdi*4+0x10c]
  95939e:	00 
  95939f:	45 89 d3             	mov    r11d,r10d
  9593a2:	41 c1 eb 06          	shr    r11d,0x6
  9593a6:	c4 02 ab f7 14 de    	shrx   r10,QWORD PTR [r14+r11*8],r10
  9593ac:	41 83 e2 01          	and    r10d,0x1
  9593b0:	c4 42 31 f7 ca       	shlx   r9d,r10d,r9d
  9593b5:	44 09 ca             	or     edx,r9d
  9593b8:	e9 43 ff ff ff       	jmp    959300 <check_input_intrinsic_lookup+0x410>
  9593bd:	0f 1f 00             	nop    DWORD PTR [rax]
  9593c0:	48 85 f6             	test   rsi,rsi
  9593c3:	74 4b                	je     959410 <check_input_intrinsic_lookup+0x520>
  9593c5:	c1 e6 02             	shl    esi,0x2
  9593c8:	eb 0f                	jmp    9593d9 <check_input_intrinsic_lookup+0x4e9>
  9593ca:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  9593d0:	48 ff c7             	inc    rdi
  9593d3:	48 83 c6 fc          	add    rsi,0xfffffffffffffffc
  9593d7:	74 37                	je     959410 <check_input_intrinsic_lookup+0x520>
  9593d9:	0f a3 f9             	bt     ecx,edi
  9593dc:	73 f2                	jae    9593d0 <check_input_intrinsic_lookup+0x4e0>
  9593de:	44 8b 84 bc 00 01 00 	mov    r8d,DWORD PTR [rsp+rdi*4+0x100]
  9593e5:	00 
  9593e6:	45 89 c1             	mov    r9d,r8d
  9593e9:	41 c1 e9 06          	shr    r9d,0x6
  9593ed:	c4 02 bb f7 04 ce    	shrx   r8,QWORD PTR [r14+r9*8],r8
  9593f3:	41 83 e0 01          	and    r8d,0x1
  9593f7:	c4 42 41 f7 c0       	shlx   r8d,r8d,edi
  9593fc:	44 09 c2             	or     edx,r8d
  9593ff:	eb cf                	jmp    9593d0 <check_input_intrinsic_lookup+0x4e0>
  959401:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  959408:	0f 1f 84 00 00 00 00 
  95940f:	00 
  959410:	48 8b 74 24 08       	mov    rsi,QWORD PTR [rsp+0x8]
  959415:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  959419:	44 39 fb             	cmp    ebx,r15d
  95941c:	0f 84 7e 01 00 00    	je     9595a0 <check_input_intrinsic_lookup+0x6b0>
  959422:	89 d1                	mov    ecx,edx
  959424:	83 e1 01             	and    ecx,0x1
  959427:	4a c7 84 fc c0 00 00 	mov    QWORD PTR [rsp+r15*8+0xc0],0x0
  95942e:	00 00 00 00 00 
  959433:	f7 d9                	neg    ecx
  959435:	81 e1 bf 0e 00 00    	and    ecx,0xebf
  95943b:	c5 f9 6e c9          	vmovd  xmm1,ecx
  95943f:	83 f8 01             	cmp    eax,0x1
  959442:	0f 84 58 01 00 00    	je     9595a0 <check_input_intrinsic_lookup+0x6b0>
  959448:	89 d7                	mov    edi,edx
  95944a:	c1 e7 1e             	shl    edi,0x1e
  95944d:	41 8d 4f 01          	lea    ecx,[r15+0x1]
  959451:	c1 ff 1f             	sar    edi,0x1f
  959454:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  95945b:	00 00 00 00 00 
  959460:	81 e7 bf 0e 00 00    	and    edi,0xebf
  959466:	c4 e3 71 22 c7 01    	vpinsrd xmm0,xmm1,edi,0x1
  95946c:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  959472:	83 f8 02             	cmp    eax,0x2
  959475:	0f 84 25 01 00 00    	je     9595a0 <check_input_intrinsic_lookup+0x6b0>
  95947b:	89 d7                	mov    edi,edx
  95947d:	c1 e7 1d             	shl    edi,0x1d
  959480:	41 8d 4f 02          	lea    ecx,[r15+0x2]
  959484:	c1 ff 1f             	sar    edi,0x1f
  959487:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  95948e:	00 00 00 00 00 
  959493:	81 e7 bf 0e 00 00    	and    edi,0xebf
  959499:	c4 e3 71 22 c7 02    	vpinsrd xmm0,xmm1,edi,0x2
  95949f:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  9594a5:	83 f8 03             	cmp    eax,0x3
  9594a8:	0f 84 f2 00 00 00    	je     9595a0 <check_input_intrinsic_lookup+0x6b0>
  9594ae:	89 d7                	mov    edi,edx
  9594b0:	c1 e7 1c             	shl    edi,0x1c
  9594b3:	41 8d 4f 03          	lea    ecx,[r15+0x3]
  9594b7:	c1 ff 1f             	sar    edi,0x1f
  9594ba:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  9594c1:	00 00 00 00 00 
  9594c6:	81 e7 bf 0e 00 00    	and    edi,0xebf
  9594cc:	c4 e3 71 22 c7 03    	vpinsrd xmm0,xmm1,edi,0x3
  9594d2:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  9594d8:	83 f8 04             	cmp    eax,0x4
  9594db:	0f 84 bf 00 00 00    	je     9595a0 <check_input_intrinsic_lookup+0x6b0>
  9594e1:	89 d7                	mov    edi,edx
  9594e3:	c1 e7 1b             	shl    edi,0x1b
  9594e6:	41 8d 4f 04          	lea    ecx,[r15+0x4]
  9594ea:	c1 ff 1f             	sar    edi,0x1f
  9594ed:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  9594f4:	00 00 00 00 00 
  9594f9:	81 e7 bf 0e 00 00    	and    edi,0xebf
  9594ff:	62 f2 7d 28 7c c7    	vpbroadcastd ymm0,edi
  959505:	c4 e3 75 02 c8 10    	vpblendd ymm1,ymm1,ymm0,0x10
  95950b:	83 f8 05             	cmp    eax,0x5
  95950e:	0f 84 8c 00 00 00    	je     9595a0 <check_input_intrinsic_lookup+0x6b0>
  959514:	89 d7                	mov    edi,edx
  959516:	c1 e7 1a             	shl    edi,0x1a
  959519:	41 8d 4f 05          	lea    ecx,[r15+0x5]
  95951d:	c1 ff 1f             	sar    edi,0x1f
  959520:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  959527:	00 00 00 00 00 
  95952c:	81 e7 bf 0e 00 00    	and    edi,0xebf
  959532:	62 f2 7d 28 7c c7    	vpbroadcastd ymm0,edi
  959538:	c4 e3 75 02 c8 20    	vpblendd ymm1,ymm1,ymm0,0x20
  95953e:	83 f8 06             	cmp    eax,0x6
  959541:	74 5d                	je     9595a0 <check_input_intrinsic_lookup+0x6b0>
  959543:	89 d7                	mov    edi,edx
  959545:	c1 e7 19             	shl    edi,0x19
  959548:	41 8d 4f 06          	lea    ecx,[r15+0x6]
  95954c:	c1 ff 1f             	sar    edi,0x1f
  95954f:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  959556:	00 00 00 00 00 
  95955b:	81 e7 bf 0e 00 00    	and    edi,0xebf
  959561:	62 f2 7d 28 7c c7    	vpbroadcastd ymm0,edi
  959567:	c4 e3 75 02 c8 40    	vpblendd ymm1,ymm1,ymm0,0x40
  95956d:	83 f8 07             	cmp    eax,0x7
  959570:	74 2e                	je     9595a0 <check_input_intrinsic_lookup+0x6b0>
  959572:	0f be ca             	movsx  ecx,dl
  959575:	41 8d 47 07          	lea    eax,[r15+0x7]
  959579:	c1 e9 07             	shr    ecx,0x7
  95957c:	48 c7 84 c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],0x0
  959583:	00 00 00 00 00 
  959588:	81 e1 bf 0e 00 00    	and    ecx,0xebf
  95958e:	62 f2 7d 28 7c c1    	vpbroadcastd ymm0,ecx
  959594:	c4 e3 75 02 c8 80    	vpblendd ymm1,ymm1,ymm0,0x80
  95959a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  9595a0:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  9595a4:	c5 f5 66 c2          	vpcmpgtd ymm0,ymm1,ymm2
  9595a8:	c4 e2 7d 0e c0       	vtestps ymm0,ymm0
  9595ad:	0f 84 ad fa ff ff    	je     959060 <check_input_intrinsic_lookup+0x170>
  9595b3:	48 03 6c 24 48       	add    rbp,QWORD PTR [rsp+0x48]
  9595b8:	62 f1 75 28 66 ca    	vpcmpgtd k1,ymm1,ymm2
  9595be:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  9595c2:	4c 89 7c 24 38       	mov    QWORD PTR [rsp+0x38],r15
  9595c7:	c5 f8 91 4c 24 28    	kmovw  WORD PTR [rsp+0x28],k1
  9595cd:	48 89 6c 24 58       	mov    QWORD PTR [rsp+0x58],rbp
  9595d2:	e9 8f 00 00 00       	jmp    959666 <check_input_intrinsic_lookup+0x776>
  9595d7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  9595de:	00 00 
  9595e0:	c5 fe 6f 84 24 00 01 	vmovdqu ymm0,YMMWORD PTR [rsp+0x100]
  9595e7:	00 00 
  9595e9:	8b 5c 24 34          	mov    ebx,DWORD PTR [rsp+0x34]
  9595ed:	4c 8b 7c 24 38       	mov    r15,QWORD PTR [rsp+0x38]
  9595f2:	48 8b 6c 24 58       	mov    rbp,QWORD PTR [rsp+0x58]
  9595f7:	4c 8d 35 12 e2 b6 ff 	lea    r14,[rip+0xffffffffffb6e212]        # 4c7810 <builtin_intrinsic_filter_bits>
  9595fe:	c5 fe 6f 9c 24 a0 00 	vmovdqu ymm3,YMMWORD PTR [rsp+0xa0]
  959605:	00 00 
  959607:	c5 fe 6f a4 24 80 00 	vmovdqu ymm4,YMMWORD PTR [rsp+0x80]
  95960e:	00 00 
  959610:	c5 f8 90 54 24 28    	kmovw  k2,WORD PTR [rsp+0x28]
  959616:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  95961a:	c5 f5 76 c9          	vpcmpeqd ymm1,ymm1,ymm1
  95961e:	62 f1 7d 2a 66 ca    	vpcmpgtd k1{k2},ymm0,ymm2
  959624:	62 f1 7d aa 72 e0 1f 	vpsrad ymm0{k2}{z},ymm0,0x1f
  95962b:	62 f1 5d 29 fa d9    	vpsubd ymm3{k1},ymm4,ymm1
  959631:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  959637:	c4 e3 65 4c c4 00    	vpblendvb ymm0,ymm3,ymm4,ymm0
  95963d:	62 f1 7d 29 6f c1    	vmovdqa32 ymm0{k1},ymm1
  959643:	c5 fd 66 cb          	vpcmpgtd ymm1,ymm0,ymm3
  959647:	62 f1 7d 28 66 cb    	vpcmpgtd k1,ymm0,ymm3
  95964d:	c4 e2 7d 0e c9       	vtestps ymm1,ymm1
  959652:	c5 fd 6f c8          	vmovdqa ymm1,ymm0
  959656:	c5 fd 6f c3          	vmovdqa ymm0,ymm3
  95965a:	c5 f8 91 4c 24 28    	kmovw  WORD PTR [rsp+0x28],k1
  959660:	0f 84 fa f9 ff ff    	je     959060 <check_input_intrinsic_lookup+0x170>
  959666:	c5 fd 6f d8          	vmovdqa ymm3,ymm0
  95966a:	c5 f5 fa c0          	vpsubd ymm0,ymm1,ymm0
  95966e:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  959674:	c5 fe 7f 9c 24 a0 00 	vmovdqu YMMWORD PTR [rsp+0xa0],ymm3
  95967b:	00 00 
  95967d:	c5 fe 7f 94 24 00 01 	vmovdqu YMMWORD PTR [rsp+0x100],ymm2
  959684:	00 00 
  959686:	c5 fd 72 d0 01       	vpsrld ymm0,ymm0,0x1
  95968b:	c5 fd fe c3          	vpaddd ymm0,ymm0,ymm3
  95968f:	c5 fe 7f 84 24 80 00 	vmovdqu YMMWORD PTR [rsp+0x80],ymm0
  959696:	00 00 
  959698:	c5 fe 7f 84 24 20 01 	vmovdqu YMMWORD PTR [rsp+0x120],ymm0
  95969f:	00 00 
  9596a1:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  9596a5:	44 39 fb             	cmp    ebx,r15d
  9596a8:	0f 84 50 ff ff ff    	je     9595fe <check_input_intrinsic_lookup+0x70e>
  9596ae:	c5 f8 90 4c 24 28    	kmovw  k1,WORD PTR [rsp+0x28]
  9596b4:	45 31 ed             	xor    r13d,r13d
  9596b7:	c5 79 93 e1          	kmovb  r12d,k1
  9596bb:	eb 1b                	jmp    9596d8 <check_input_intrinsic_lookup+0x7e8>
  9596bd:	0f 1f 00             	nop    DWORD PTR [rax]
  9596c0:	42 89 84 ac 00 01 00 	mov    DWORD PTR [rsp+r13*4+0x100],eax
  9596c7:	00 
  9596c8:	49 ff c5             	inc    r13
  9596cb:	48 83 c5 10          	add    rbp,0x10
  9596cf:	4c 39 ee             	cmp    rsi,r13
  9596d2:	0f 84 08 ff ff ff    	je     9595e0 <check_input_intrinsic_lookup+0x6f0>
  9596d8:	45 0f a3 ec          	bt     r12d,r13d
  9596dc:	73 ea                	jae    9596c8 <check_input_intrinsic_lookup+0x7d8>
  9596de:	4a 63 84 ac 20 01 00 	movsxd rax,DWORD PTR [rsp+r13*4+0x120]
  9596e5:	00 
  9596e6:	48 8d 0d 63 94 86 01 	lea    rcx,[rip+0x1869463]        # 21c2b50 <builtin_intrinsic_infos>
  9596ed:	44 8b 7d 00          	mov    r15d,DWORD PTR [rbp+0x0]
  9596f1:	48 8d 04 40          	lea    rax,[rax+rax*2]
  9596f5:	48 c1 e0 05          	shl    rax,0x5
  9596f9:	8b 5c 08 40          	mov    ebx,DWORD PTR [rax+rcx*1+0x40]
  9596fd:	4c 8d 34 01          	lea    r14,[rcx+rax*1]
  959701:	41 39 df             	cmp    r15d,ebx
  959704:	89 d8                	mov    eax,ebx
  959706:	41 0f 42 c7          	cmovb  eax,r15d
  95970a:	85 c0                	test   eax,eax
  95970c:	74 1a                	je     959728 <check_input_intrinsic_lookup+0x838>
  95970e:	48 8b 7d f8          	mov    rdi,QWORD PTR [rbp-0x8]
  959712:	49 8b 36             	mov    rsi,QWORD PTR [r14]
  959715:	89 c2                	mov    edx,eax
  959717:	c5 f8 77             	vzeroupper
  95971a:	e8 81 46 fa ff       	call   8fdda0 <memcmp@plt>
  95971f:	48 8b 74 24 08       	mov    rsi,QWORD PTR [rsp+0x8]
  959724:	85 c0                	test   eax,eax
  959726:	75 98                	jne    9596c0 <check_input_intrinsic_lookup+0x7d0>
  959728:	41 39 df             	cmp    r15d,ebx
  95972b:	0f 97 c0             	seta   al
  95972e:	1c 00                	sbb    al,0x0
  959730:	0f be c0             	movsx  eax,al
  959733:	42 89 84 ac 00 01 00 	mov    DWORD PTR [rsp+r13*4+0x100],eax
  95973a:	00 
  95973b:	41 39 df             	cmp    r15d,ebx
  95973e:	75 88                	jne    9596c8 <check_input_intrinsic_lookup+0x7d8>
  959740:	48 8b 44 24 38       	mov    rax,QWORD PTR [rsp+0x38]
  959745:	44 01 e8             	add    eax,r13d
  959748:	4c 89 b4 c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],r14
  95974f:	00 
  959750:	e9 73 ff ff ff       	jmp    9596c8 <check_input_intrinsic_lookup+0x7d8>
  959755:	b0 01                	mov    al,0x1
  959757:	85 db                	test   ebx,ebx
  959759:	74 1d                	je     959778 <check_input_intrinsic_lookup+0x888>
  95975b:	48 83 7c 24 10 00    	cmp    QWORD PTR [rsp+0x10],0x0
  959761:	89 da                	mov    edx,ebx
  959763:	74 3f                	je     9597a4 <check_input_intrinsic_lookup+0x8b4>
  959765:	89 d1                	mov    ecx,edx
  959767:	83 e1 03             	and    ecx,0x3
  95976a:	83 fb 04             	cmp    ebx,0x4
  95976d:	73 5a                	jae    9597c9 <check_input_intrinsic_lookup+0x8d9>
  95976f:	31 f6                	xor    esi,esi
  959771:	e9 7c 01 00 00       	jmp    9598f2 <check_input_intrinsic_lookup+0xa02>
  959776:	b0 01                	mov    al,0x1
  959778:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  95977f:	00 00 
  959781:	48 3b 8c 24 40 01 00 	cmp    rcx,QWORD PTR [rsp+0x140]
  959788:	00 
  959789:	0f 85 cd 01 00 00    	jne    95995c <check_input_intrinsic_lookup+0xa6c>
  95978f:	48 81 c4 48 01 00 00 	add    rsp,0x148
  959796:	5b                   	pop    rbx
  959797:	41 5c                	pop    r12
  959799:	41 5d                	pop    r13
  95979b:	41 5e                	pop    r14
  95979d:	41 5f                	pop    r15
  95979f:	5d                   	pop    rbp
  9597a0:	c5 f8 77             	vzeroupper
  9597a3:	c3                   	ret
  9597a4:	b9 01 00 00 00       	mov    ecx,0x1
  9597a9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
  9597b0:	48 83 bc cc b8 00 00 	cmp    QWORD PTR [rsp+rcx*8+0xb8],0x0
  9597b7:	00 00 
  9597b9:	0f 94 c0             	sete   al
  9597bc:	75 ba                	jne    959778 <check_input_intrinsic_lookup+0x888>
  9597be:	48 39 d1             	cmp    rcx,rdx
  9597c1:	48 8d 49 01          	lea    rcx,[rcx+0x1]
  9597c5:	72 e9                	jb     9597b0 <check_input_intrinsic_lookup+0x8c0>
  9597c7:	eb af                	jmp    959778 <check_input_intrinsic_lookup+0x888>
  9597c9:	83 e2 fc             	and    edx,0xfffffffc
  9597cc:	48 8d 3d 7d 93 86 01 	lea    rdi,[rip+0x186937d]        # 21c2b50 <builtin_intrinsic_infos>
  9597d3:	31 f6                	xor    esi,esi
  9597d5:	eb 16                	jmp    9597ed <check_input_intrinsic_lookup+0x8fd>
  9597d7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  9597de:	00 00 
  9597e0:	48 83 c6 04          	add    rsi,0x4
  9597e4:	48 39 f2             	cmp    rdx,rsi
  9597e7:	0f 84 fc 00 00 00    	je     9598e9 <check_input_intrinsic_lookup+0x9f9>
  9597ed:	4c 8b 84 f4 c0 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xc0]
  9597f4:	00 
  9597f5:	4d 85 c0             	test   r8,r8
  9597f8:	74 2f                	je     959829 <check_input_intrinsic_lookup+0x939>
  9597fa:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  9597ff:	49 29 f8             	sub    r8,rdi
  959802:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  959807:	49 c1 e8 05          	shr    r8,0x5
  95980b:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  959812:	45 8b 0c b1          	mov    r9d,DWORD PTR [r9+rsi*4]
  959816:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  95981d:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  959821:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
  959826:	41 ff 01             	inc    DWORD PTR [r9]
  959829:	4c 8b 84 f4 c8 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xc8]
  959830:	00 
  959831:	4d 85 c0             	test   r8,r8
  959834:	74 30                	je     959866 <check_input_intrinsic_lookup+0x976>
  959836:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  95983b:	49 29 f8             	sub    r8,rdi
  95983e:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  959843:	49 c1 e8 05          	shr    r8,0x5
  959847:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  95984e:	45 8b 4c b1 04       	mov    r9d,DWORD PTR [r9+rsi*4+0x4]
  959853:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  95985a:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  95985e:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
  959863:	41 ff 01             	inc    DWORD PTR [r9]
  959866:	4c 8b 84 f4 d0 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xd0]
  95986d:	00 
  95986e:	4d 85 c0             	test   r8,r8
  959871:	74 30                	je     9598a3 <check_input_intrinsic_lookup+0x9b3>
  959873:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  959878:	49 29 f8             	sub    r8,rdi
  95987b:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  959880:	49 c1 e8 05          	shr    r8,0x5
  959884:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  95988b:	45 8b 4c b1 08       	mov    r9d,DWORD PTR [r9+rsi*4+0x8]
  959890:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  959897:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  95989b:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
  9598a0:	41 ff 01             	inc    DWORD PTR [r9]
  9598a3:	4c 8b 84 f4 d8 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xd8]
  9598aa:	00 
  9598ab:	4d 85 c0             	test   r8,r8
  9598ae:	0f 84 2c ff ff ff    	je     9597e0 <check_input_intrinsic_lookup+0x8f0>
  9598b4:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  9598b9:	49 29 f8             	sub    r8,rdi
  9598bc:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  9598c1:	49 c1 e8 05          	shr    r8,0x5
  9598c5:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  9598cc:	45 8b 4c b1 0c       	mov    r9d,DWORD PTR [r9+rsi*4+0xc]
  9598d1:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  9598d8:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  9598dc:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
  9598e1:	41 ff 01             	inc    DWORD PTR [r9]
  9598e4:	e9 f7 fe ff ff       	jmp    9597e0 <check_input_intrinsic_lookup+0x8f0>
  9598e9:	48 85 c9             	test   rcx,rcx
  9598ec:	0f 84 86 fe ff ff    	je     959778 <check_input_intrinsic_lookup+0x888>
  9598f2:	48 8b 54 24 18       	mov    rdx,QWORD PTR [rsp+0x18]
  9598f7:	4c 8b 5c 24 10       	mov    r11,QWORD PTR [rsp+0x10]
  9598fc:	4c 8d 05 4d 92 86 01 	lea    r8,[rip+0x186924d]        # 21c2b50 <builtin_intrinsic_infos>
  959903:	31 ff                	xor    edi,edi
  959905:	48 8d 14 b2          	lea    rdx,[rdx+rsi*4]
  959909:	48 8d b4 f4 c0 00 00 	lea    rsi,[rsp+rsi*8+0xc0]
  959910:	00 
  959911:	eb 19                	jmp    95992c <check_input_intrinsic_lookup+0xa3c>
  959913:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  95991a:	84 00 00 00 00 00 
  959920:	48 ff c7             	inc    rdi
  959923:	48 39 f9             	cmp    rcx,rdi
  959926:	0f 84 4c fe ff ff    	je     959778 <check_input_intrinsic_lookup+0x888>
  95992c:	4c 8b 0c fe          	mov    r9,QWORD PTR [rsi+rdi*8]
  959930:	4d 85 c9             	test   r9,r9
  959933:	74 eb                	je     959920 <check_input_intrinsic_lookup+0xa30>
  959935:	4d 29 c1             	sub    r9,r8
  959938:	44 8b 14 ba          	mov    r10d,DWORD PTR [rdx+rdi*4]
  95993c:	49 c1 e9 05          	shr    r9,0x5
  959940:	45 69 c9 ab aa aa aa 	imul   r9d,r9d,0xaaaaaaab
  959947:	41 81 c9 00 00 00 80 	or     r9d,0x80000000
  95994e:	47 89 0c 93          	mov    DWORD PTR [r11+r10*4],r9d
  959952:	4c 8b 54 24 20       	mov    r10,QWORD PTR [rsp+0x20]
  959957:	41 ff 02             	inc    DWORD PTR [r10]
  95995a:	eb c4                	jmp    959920 <check_input_intrinsic_lookup+0xa30>
  95995c:	c5 f8 77             	vzeroupper
  95995f:	e8 2c 3b fa ff       	call   8fd490 <__stack_chk_fail@plt>
