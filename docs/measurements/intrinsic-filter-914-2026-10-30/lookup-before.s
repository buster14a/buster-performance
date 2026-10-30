
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
  958f01:	4c 89 4c 24 18       	mov    QWORD PTR [rsp+0x18],r9
  958f06:	4c 89 44 24 08       	mov    QWORD PTR [rsp+0x8],r8
  958f0b:	48 89 54 24 10       	mov    QWORD PTR [rsp+0x10],rdx
  958f10:	48 89 74 24 40       	mov    QWORD PTR [rsp+0x40],rsi
  958f15:	41 89 cb             	mov    r11d,ecx
  958f18:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  958f1f:	00 00 
  958f21:	48 89 84 24 40 01 00 	mov    QWORD PTR [rsp+0x140],rax
  958f28:	00 
  958f29:	89 4c 24 34          	mov    DWORD PTR [rsp+0x34],ecx
  958f2d:	40 f6 c7 01          	test   dil,0x1
  958f31:	0f 84 ed 00 00 00    	je     959024 <check_input_intrinsic_lookup+0x134>
  958f37:	45 85 db             	test   r11d,r11d
  958f3a:	0f 84 d7 07 00 00    	je     959717 <check_input_intrinsic_lookup+0x827>
  958f40:	44 89 d8             	mov    eax,r11d
  958f43:	48 89 44 24 60       	mov    QWORD PTR [rsp+0x60],rax
  958f48:	31 c0                	xor    eax,eax
  958f4a:	eb 26                	jmp    958f72 <check_input_intrinsic_lookup+0x82>
  958f4c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
  958f50:	31 db                	xor    ebx,ebx
  958f52:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  958f57:	44 8b 5c 24 34       	mov    r11d,DWORD PTR [rsp+0x34]
  958f5c:	48 89 9c c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],rbx
  958f63:	00 
  958f64:	48 ff c0             	inc    rax
  958f67:	48 3b 44 24 60       	cmp    rax,QWORD PTR [rsp+0x60]
  958f6c:	0f 84 81 07 00 00    	je     9596f3 <check_input_intrinsic_lookup+0x803>
  958f72:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
  958f77:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
  958f7c:	48 c1 e0 04          	shl    rax,0x4
  958f80:	48 8b 14 01          	mov    rdx,QWORD PTR [rcx+rax*1]
  958f84:	8b 74 01 08          	mov    esi,DWORD PTR [rcx+rax*1+0x8]
  958f88:	48 85 d2             	test   rdx,rdx
  958f8b:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
  958f90:	0f 94 c0             	sete   al
  958f93:	85 f6                	test   esi,esi
  958f95:	0f 94 c1             	sete   cl
  958f98:	08 c1                	or     cl,al
  958f9a:	75 b4                	jne    958f50 <check_input_intrinsic_lookup+0x60>
  958f9c:	bd bf 0e 00 00       	mov    ebp,0xebf
  958fa1:	31 db                	xor    ebx,ebx
  958fa3:	45 31 f6             	xor    r14d,r14d
  958fa6:	89 74 24 38          	mov    DWORD PTR [rsp+0x38],esi
  958faa:	eb 2e                	jmp    958fda <check_input_intrinsic_lookup+0xea>
  958fac:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
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
  958fe0:	48 8d 0d 09 95 86 01 	lea    rcx,[rip+0x1869509]        # 21c24f0 <builtin_intrinsic_infos>
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
  95900a:	48 8b 7c 24 28       	mov    rdi,QWORD PTR [rsp+0x28]
  95900f:	0f 42 d6             	cmovb  edx,esi
  959012:	49 8b 37             	mov    rsi,QWORD PTR [r15]
  959015:	e8 36 4e fa ff       	call   8fde50 <memcmp@plt>
  95901a:	8b 74 24 38          	mov    esi,DWORD PTR [rsp+0x38]
  95901e:	85 c0                	test   eax,eax
  959020:	75 99                	jne    958fbb <check_input_intrinsic_lookup+0xcb>
  959022:	eb 8c                	jmp    958fb0 <check_input_intrinsic_lookup+0xc0>
  959024:	45 85 db             	test   r11d,r11d
  959027:	0f 84 ea 06 00 00    	je     959717 <check_input_intrinsic_lookup+0x827>
  95902d:	c5 fd 6f 15 eb 88 c9 	vmovdqa ymm2,YMMWORD PTR [rip+0xffffffffffc988eb]        # 5f1920 <static_test_starved.starved+0xdc0>
  959034:	ff 
  959035:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
  95903a:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  95903e:	48 8d 48 18          	lea    rcx,[rax+0x18]
  959042:	48 83 c0 08          	add    rax,0x8
  959046:	48 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],rcx
  95904b:	31 c9                	xor    ecx,ecx
  95904d:	48 89 44 24 50       	mov    QWORD PTR [rsp+0x50],rax
  959052:	eb 27                	jmp    95907b <check_input_intrinsic_lookup+0x18b>
  959054:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  95905b:	00 00 00 00 00 
  959060:	c5 fd 6f 15 b8 88 c9 	vmovdqa ymm2,YMMWORD PTR [rip+0xffffffffffc988b8]        # 5f1920 <static_test_starved.starved+0xdc0>
  959067:	ff 
  959068:	41 01 da             	add    r10d,ebx
  95906b:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  95906f:	44 89 d1             	mov    ecx,r10d
  959072:	45 39 da             	cmp    r10d,r11d
  959075:	0f 83 78 06 00 00    	jae    9596f3 <check_input_intrinsic_lookup+0x803>
  95907b:	44 89 d8             	mov    eax,r11d
  95907e:	29 c8                	sub    eax,ecx
  959080:	41 ba 08 00 00 00    	mov    r10d,0x8
  959086:	89 cb                	mov    ebx,ecx
  959088:	49 89 dc             	mov    r12,rbx
  95908b:	c5 fe 7f 84 24 20 01 	vmovdqu YMMWORD PTR [rsp+0x120],ymm0
  959092:	00 00 
  959094:	83 f8 08             	cmp    eax,0x8
  959097:	44 0f 42 d0          	cmovb  r10d,eax
  95909b:	49 c1 e4 04          	shl    r12,0x4
  95909f:	4c 89 54 24 28       	mov    QWORD PTR [rsp+0x28],r10
  9590a4:	83 f8 01             	cmp    eax,0x1
  9590a7:	75 17                	jne    9590c0 <check_input_intrinsic_lookup+0x1d0>
  9590a9:	31 d2                	xor    edx,edx
  9590ab:	31 c9                	xor    ecx,ecx
  9590ad:	e9 68 01 00 00       	jmp    95921a <check_input_intrinsic_lookup+0x32a>
  9590b2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  9590b9:	1f 84 00 00 00 00 00 
  9590c0:	48 8b 4c 24 48       	mov    rcx,QWORD PTR [rsp+0x48]
  9590c5:	44 89 d6             	mov    esi,r10d
  9590c8:	83 e6 0e             	and    esi,0xe
  9590cb:	31 d2                	xor    edx,edx
  9590cd:	4a 8d 3c 21          	lea    rdi,[rcx+r12*1]
  9590d1:	31 c9                	xor    ecx,ecx
  9590d3:	eb 41                	jmp    959116 <check_input_intrinsic_lookup+0x226>
  9590d5:	45 8b 11             	mov    r10d,DWORD PTR [r9]
  9590d8:	47 8b 4c 01 fc       	mov    r9d,DWORD PTR [r9+r8*1-0x4]
  9590dd:	45 69 c0 b9 79 37 9e 	imul   r8d,r8d,0x9e3779b9
  9590e4:	c4 43 7b f0 c9 13    	rorx   r9d,r9d,0x13
  9590ea:	45 31 d0             	xor    r8d,r10d
  9590ed:	4c 8b 54 24 28       	mov    r10,QWORD PTR [rsp+0x28]
  9590f2:	45 31 c8             	xor    r8d,r9d
  9590f5:	44 8d 4a 01          	lea    r9d,[rdx+0x1]
  9590f9:	44 0f ab c9          	bts    ecx,r9d
  9590fd:	44 89 84 94 24 01 00 	mov    DWORD PTR [rsp+rdx*4+0x124],r8d
  959104:	00 
  959105:	48 83 c2 02          	add    rdx,0x2
  959109:	48 83 c7 20          	add    rdi,0x20
  95910d:	48 39 d6             	cmp    rsi,rdx
  959110:	0f 84 fa 00 00 00    	je     959210 <check_input_intrinsic_lookup+0x320>
  959116:	4c 8b 4f e8          	mov    r9,QWORD PTR [rdi-0x18]
  95911a:	4d 85 c9             	test   r9,r9
  95911d:	74 7c                	je     95919b <check_input_intrinsic_lookup+0x2ab>
  95911f:	44 8b 47 f0          	mov    r8d,DWORD PTR [rdi-0x10]
  959123:	4d 85 c0             	test   r8,r8
  959126:	74 73                	je     95919b <check_input_intrinsic_lookup+0x2ab>
  959128:	41 83 f8 03          	cmp    r8d,0x3
  95912c:	76 0a                	jbe    959138 <check_input_intrinsic_lookup+0x248>
  95912e:	45 8b 11             	mov    r10d,DWORD PTR [r9]
  959131:	47 8b 4c 01 fc       	mov    r9d,DWORD PTR [r9+r8*1-0x4]
  959136:	eb 40                	jmp    959178 <check_input_intrinsic_lookup+0x288>
  959138:	4d 8d 50 ff          	lea    r10,[r8-0x1]
  95913c:	62 d2 fd 28 7c c2    	vpbroadcastq ymm0,r10
  959142:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  959149:	62 d1 7f 89 6f 01    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r9]
  95914f:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  959154:	62 f2 7d 89 47 05 a2 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffcad0a2]        # 606200 <abi_test_hex.digits+0x670>
  95915b:	d0 ca ff 
  95915e:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  959163:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  959167:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  95916c:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  959170:	c4 c1 79 7e c1       	vmovd  r9d,xmm0
  959175:	45 89 ca             	mov    r10d,r9d
  959178:	45 69 c0 b9 79 37 9e 	imul   r8d,r8d,0x9e3779b9
  95917f:	c4 43 7b f0 c9 13    	rorx   r9d,r9d,0x13
  959185:	0f ab d1             	bts    ecx,edx
  959188:	45 31 d0             	xor    r8d,r10d
  95918b:	4c 8b 54 24 28       	mov    r10,QWORD PTR [rsp+0x28]
  959190:	45 31 c8             	xor    r8d,r9d
  959193:	44 89 84 94 20 01 00 	mov    DWORD PTR [rsp+rdx*4+0x120],r8d
  95919a:	00 
  95919b:	4c 8b 4f f8          	mov    r9,QWORD PTR [rdi-0x8]
  95919f:	4d 85 c9             	test   r9,r9
  9591a2:	0f 84 5d ff ff ff    	je     959105 <check_input_intrinsic_lookup+0x215>
  9591a8:	44 8b 07             	mov    r8d,DWORD PTR [rdi]
  9591ab:	4d 85 c0             	test   r8,r8
  9591ae:	0f 84 51 ff ff ff    	je     959105 <check_input_intrinsic_lookup+0x215>
  9591b4:	41 83 f8 03          	cmp    r8d,0x3
  9591b8:	0f 87 17 ff ff ff    	ja     9590d5 <check_input_intrinsic_lookup+0x1e5>
  9591be:	4d 8d 50 ff          	lea    r10,[r8-0x1]
  9591c2:	62 d2 fd 28 7c c2    	vpbroadcastq ymm0,r10
  9591c8:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  9591cf:	62 d1 7f 89 6f 01    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [r9]
  9591d5:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  9591da:	62 f2 7d 89 47 05 1c 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffcad01c]        # 606200 <abi_test_hex.digits+0x670>
  9591e1:	d0 ca ff 
  9591e4:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  9591e9:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  9591ed:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  9591f2:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  9591f6:	c4 c1 79 7e c1       	vmovd  r9d,xmm0
  9591fb:	45 89 ca             	mov    r10d,r9d
  9591fe:	e9 da fe ff ff       	jmp    9590dd <check_input_intrinsic_lookup+0x1ed>
  959203:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  95920a:	84 00 00 00 00 00 
  959210:	41 f6 c2 01          	test   r10b,0x1
  959214:	0f 84 8b 00 00 00    	je     9592a5 <check_input_intrinsic_lookup+0x3b5>
  95921a:	48 8b 74 24 40       	mov    rsi,QWORD PTR [rsp+0x40]
  95921f:	49 89 d0             	mov    r8,rdx
  959222:	49 c1 e0 04          	shl    r8,0x4
  959226:	4c 01 e6             	add    rsi,r12
  959229:	4a 8b 3c 06          	mov    rdi,QWORD PTR [rsi+r8*1]
  95922d:	48 85 ff             	test   rdi,rdi
  959230:	74 73                	je     9592a5 <check_input_intrinsic_lookup+0x3b5>
  959232:	4c 01 c6             	add    rsi,r8
  959235:	8b 76 08             	mov    esi,DWORD PTR [rsi+0x8]
  959238:	48 85 f6             	test   rsi,rsi
  95923b:	74 68                	je     9592a5 <check_input_intrinsic_lookup+0x3b5>
  95923d:	83 fe 03             	cmp    esi,0x3
  959240:	76 09                	jbe    95924b <check_input_intrinsic_lookup+0x35b>
  959242:	44 8b 07             	mov    r8d,DWORD PTR [rdi]
  959245:	8b 7c 37 fc          	mov    edi,DWORD PTR [rdi+rsi*1-0x4]
  959249:	eb 3f                	jmp    95928a <check_input_intrinsic_lookup+0x39a>
  95924b:	4c 8d 46 ff          	lea    r8,[rsi-0x1]
  95924f:	62 d2 fd 28 7c c0    	vpbroadcastq ymm0,r8
  959255:	62 f3 fd 28 1e ca 05 	vpcmpnltuq k1,ymm0,ymm2
  95925c:	62 f1 7f 89 6f 07    	vmovdqu8 xmm0{k1}{z},XMMWORD PTR [rdi]
  959262:	c4 e2 79 31 c0       	vpmovzxbd xmm0,xmm0
  959267:	62 f2 7d 89 47 05 8f 	vpsllvd xmm0{k1}{z},xmm0,XMMWORD PTR [rip+0xffffffffffcacf8f]        # 606200 <abi_test_hex.digits+0x670>
  95926e:	cf ca ff 
  959271:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  959276:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  95927a:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  95927f:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  959283:	c5 f9 7e c7          	vmovd  edi,xmm0
  959287:	41 89 f8             	mov    r8d,edi
  95928a:	69 f6 b9 79 37 9e    	imul   esi,esi,0x9e3779b9
  959290:	0f ab d1             	bts    ecx,edx
  959293:	c4 e3 7b f0 ff 13    	rorx   edi,edi,0x13
  959299:	44 31 c6             	xor    esi,r8d
  95929c:	31 fe                	xor    esi,edi
  95929e:	89 b4 94 20 01 00 00 	mov    DWORD PTR [rsp+rdx*4+0x120],esi
  9592a5:	c5 fe 6f 84 24 20 01 	vmovdqu ymm0,YMMWORD PTR [rsp+0x120]
  9592ac:	00 00 
  9592ae:	c5 f5 72 d0 10       	vpsrld ymm1,ymm0,0x10
  9592b3:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
  9592b7:	62 f2 7d 38 40 05 b3 	vpmulld ymm0,ymm0,DWORD BCST [rip+0xffffffffffcc7ab3]        # 620d74 <link_program_emit_worker.forms+0x4bc>
  9592be:	7a cc ff 
  9592c1:	c5 f5 72 d0 0f       	vpsrld ymm1,ymm0,0xf
  9592c6:	c5 f5 ef c0          	vpxor  ymm0,ymm1,ymm0
  9592ca:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  9592ce:	c4 e3 7d 0e c1 aa    	vpblendw ymm0,ymm0,ymm1,0xaa
  9592d4:	c5 fe 7f 84 24 00 01 	vmovdqu YMMWORD PTR [rsp+0x100],ymm0
  9592db:	00 00 
  9592dd:	83 f8 08             	cmp    eax,0x8
  9592e0:	73 0e                	jae    9592f0 <check_input_intrinsic_lookup+0x400>
  9592e2:	31 f6                	xor    esi,esi
  9592e4:	31 d2                	xor    edx,edx
  9592e6:	e9 61 02 00 00       	jmp    95954c <check_input_intrinsic_lookup+0x65c>
  9592eb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
  9592f0:	c5 fe 6f 84 24 00 01 	vmovdqu ymm0,YMMWORD PTR [rsp+0x100]
  9592f7:	00 00 
  9592f9:	c5 fb 92 c9          	kmovd  k1,ecx
  9592fd:	48 8d 15 0c e5 b6 ff 	lea    rdx,[rip+0xffffffffffb6e50c]        # 4c7810 <builtin_intrinsic_filter_bits>
  959304:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  959308:	44 89 d6             	mov    esi,r10d
  95930b:	83 e6 08             	and    esi,0x8
  95930e:	c4 e1 f8 90 d1       	kmovq  k2,k1
  959313:	c5 f5 72 d0 06       	vpsrld ymm1,ymm0,0x6
  959318:	62 f1 7d 38 db 05 56 	vpandd ymm0,ymm0,DWORD BCST [rip+0xffffffffffcc7a56]        # 620d78 <link_program_emit_worker.forms+0x4c0>
  95931f:	7a cc ff 
  959322:	62 f2 fd 4a 90 14 ca 	vpgatherdq zmm2{k2},QWORD PTR [rdx+ymm1*8]
  959329:	62 f2 7d 48 35 c0    	vpmovzxdq zmm0,ymm0
  95932f:	62 f2 ed 48 45 c0    	vpsrlvq zmm0,zmm2,zmm0
  959335:	62 f2 7e 48 35 c0    	vpmovqd ymm0,zmm0
  95933b:	62 f1 7d 38 db 05 37 	vpandd ymm0,ymm0,DWORD BCST [rip+0xffffffffffcc7a37]        # 620d7c <link_program_emit_worker.forms+0x4c4>
  959342:	7a cc ff 
  959345:	62 f2 7d a9 47 05 f1 	vpsllvd ymm0{k1}{z},ymm0,YMMWORD PTR [rip+0xffffffffffc985f1]        # 5f1940 <static_test_starved.starved+0xde0>
  95934c:	85 c9 ff 
  95934f:	c4 e3 7d 39 c1 01    	vextracti128 xmm1,ymm0,0x1
  959355:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  959359:	c5 f9 70 c8 ee       	vpshufd xmm1,xmm0,0xee
  95935e:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  959362:	c5 f9 70 c8 55       	vpshufd xmm1,xmm0,0x55
  959367:	c5 f9 eb c1          	vpor   xmm0,xmm0,xmm1
  95936b:	c5 f9 7e c2          	vmovd  edx,xmm0
  95936f:	4c 39 d6             	cmp    rsi,r10
  959372:	0f 85 d4 01 00 00    	jne    95954c <check_input_intrinsic_lookup+0x65c>
  959378:	c5 f1 ef c9          	vpxor  xmm1,xmm1,xmm1
  95937c:	41 39 db             	cmp    r11d,ebx
  95937f:	0f 84 7b 01 00 00    	je     959500 <check_input_intrinsic_lookup+0x610>
  959385:	89 d1                	mov    ecx,edx
  959387:	83 e1 01             	and    ecx,0x1
  95938a:	48 c7 84 dc c0 00 00 	mov    QWORD PTR [rsp+rbx*8+0xc0],0x0
  959391:	00 00 00 00 00 
  959396:	f7 d9                	neg    ecx
  959398:	81 e1 bf 0e 00 00    	and    ecx,0xebf
  95939e:	c5 f9 6e c9          	vmovd  xmm1,ecx
  9593a2:	83 f8 01             	cmp    eax,0x1
  9593a5:	0f 84 55 01 00 00    	je     959500 <check_input_intrinsic_lookup+0x610>
  9593ab:	89 d6                	mov    esi,edx
  9593ad:	c1 e6 1e             	shl    esi,0x1e
  9593b0:	8d 4b 01             	lea    ecx,[rbx+0x1]
  9593b3:	c1 fe 1f             	sar    esi,0x1f
  9593b6:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  9593bd:	00 00 00 00 00 
  9593c2:	81 e6 bf 0e 00 00    	and    esi,0xebf
  9593c8:	c4 e3 71 22 c6 01    	vpinsrd xmm0,xmm1,esi,0x1
  9593ce:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  9593d4:	83 f8 02             	cmp    eax,0x2
  9593d7:	0f 84 23 01 00 00    	je     959500 <check_input_intrinsic_lookup+0x610>
  9593dd:	89 d6                	mov    esi,edx
  9593df:	c1 e6 1d             	shl    esi,0x1d
  9593e2:	8d 4b 02             	lea    ecx,[rbx+0x2]
  9593e5:	c1 fe 1f             	sar    esi,0x1f
  9593e8:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  9593ef:	00 00 00 00 00 
  9593f4:	81 e6 bf 0e 00 00    	and    esi,0xebf
  9593fa:	c4 e3 71 22 c6 02    	vpinsrd xmm0,xmm1,esi,0x2
  959400:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  959406:	83 f8 03             	cmp    eax,0x3
  959409:	0f 84 f1 00 00 00    	je     959500 <check_input_intrinsic_lookup+0x610>
  95940f:	89 d6                	mov    esi,edx
  959411:	c1 e6 1c             	shl    esi,0x1c
  959414:	8d 4b 03             	lea    ecx,[rbx+0x3]
  959417:	c1 fe 1f             	sar    esi,0x1f
  95941a:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  959421:	00 00 00 00 00 
  959426:	81 e6 bf 0e 00 00    	and    esi,0xebf
  95942c:	c4 e3 71 22 c6 03    	vpinsrd xmm0,xmm1,esi,0x3
  959432:	c4 e3 75 02 c8 0f    	vpblendd ymm1,ymm1,ymm0,0xf
  959438:	83 f8 04             	cmp    eax,0x4
  95943b:	0f 84 bf 00 00 00    	je     959500 <check_input_intrinsic_lookup+0x610>
  959441:	89 d6                	mov    esi,edx
  959443:	c1 e6 1b             	shl    esi,0x1b
  959446:	8d 4b 04             	lea    ecx,[rbx+0x4]
  959449:	c1 fe 1f             	sar    esi,0x1f
  95944c:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  959453:	00 00 00 00 00 
  959458:	81 e6 bf 0e 00 00    	and    esi,0xebf
  95945e:	62 f2 7d 28 7c c6    	vpbroadcastd ymm0,esi
  959464:	c4 e3 75 02 c8 10    	vpblendd ymm1,ymm1,ymm0,0x10
  95946a:	83 f8 05             	cmp    eax,0x5
  95946d:	0f 84 8d 00 00 00    	je     959500 <check_input_intrinsic_lookup+0x610>
  959473:	89 d6                	mov    esi,edx
  959475:	c1 e6 1a             	shl    esi,0x1a
  959478:	8d 4b 05             	lea    ecx,[rbx+0x5]
  95947b:	c1 fe 1f             	sar    esi,0x1f
  95947e:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  959485:	00 00 00 00 00 
  95948a:	81 e6 bf 0e 00 00    	and    esi,0xebf
  959490:	62 f2 7d 28 7c c6    	vpbroadcastd ymm0,esi
  959496:	c4 e3 75 02 c8 20    	vpblendd ymm1,ymm1,ymm0,0x20
  95949c:	83 f8 06             	cmp    eax,0x6
  95949f:	74 5f                	je     959500 <check_input_intrinsic_lookup+0x610>
  9594a1:	89 d6                	mov    esi,edx
  9594a3:	c1 e6 19             	shl    esi,0x19
  9594a6:	8d 4b 06             	lea    ecx,[rbx+0x6]
  9594a9:	c1 fe 1f             	sar    esi,0x1f
  9594ac:	48 c7 84 cc c0 00 00 	mov    QWORD PTR [rsp+rcx*8+0xc0],0x0
  9594b3:	00 00 00 00 00 
  9594b8:	81 e6 bf 0e 00 00    	and    esi,0xebf
  9594be:	62 f2 7d 28 7c c6    	vpbroadcastd ymm0,esi
  9594c4:	c4 e3 75 02 c8 40    	vpblendd ymm1,ymm1,ymm0,0x40
  9594ca:	83 f8 07             	cmp    eax,0x7
  9594cd:	74 31                	je     959500 <check_input_intrinsic_lookup+0x610>
  9594cf:	0f be ca             	movsx  ecx,dl
  9594d2:	8d 43 07             	lea    eax,[rbx+0x7]
  9594d5:	c1 e9 07             	shr    ecx,0x7
  9594d8:	48 c7 84 c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],0x0
  9594df:	00 00 00 00 00 
  9594e4:	81 e1 bf 0e 00 00    	and    ecx,0xebf
  9594ea:	62 f2 7d 28 7c c1    	vpbroadcastd ymm0,ecx
  9594f0:	c4 e3 75 02 c8 80    	vpblendd ymm1,ymm1,ymm0,0x80
  9594f6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  9594fd:	00 00 00 
  959500:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  959504:	c5 f5 66 c2          	vpcmpgtd ymm0,ymm1,ymm2
  959508:	c4 e2 7d 0e c0       	vtestps ymm0,ymm0
  95950d:	0f 84 4d fb ff ff    	je     959060 <check_input_intrinsic_lookup+0x170>
  959513:	4c 03 64 24 50       	add    r12,QWORD PTR [rsp+0x50]
  959518:	62 f1 75 28 66 ca    	vpcmpgtd k1,ymm1,ymm2
  95951e:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  959522:	48 89 5c 24 38       	mov    QWORD PTR [rsp+0x38],rbx
  959527:	c5 f8 91 4c 24 20    	kmovw  WORD PTR [rsp+0x20],k1
  95952d:	4c 89 64 24 58       	mov    QWORD PTR [rsp+0x58],r12
  959532:	e9 c9 00 00 00       	jmp    959600 <check_input_intrinsic_lookup+0x710>
  959537:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  95953e:	00 00 
  959540:	48 ff c6             	inc    rsi
  959543:	49 39 f2             	cmp    r10,rsi
  959546:	0f 84 2c fe ff ff    	je     959378 <check_input_intrinsic_lookup+0x488>
  95954c:	0f a3 f1             	bt     ecx,esi
  95954f:	73 ef                	jae    959540 <check_input_intrinsic_lookup+0x650>
  959551:	8b bc b4 00 01 00 00 	mov    edi,DWORD PTR [rsp+rsi*4+0x100]
  959558:	4c 8d 0d b1 e2 b6 ff 	lea    r9,[rip+0xffffffffffb6e2b1]        # 4c7810 <builtin_intrinsic_filter_bits>
  95955f:	41 89 f8             	mov    r8d,edi
  959562:	41 c1 e8 06          	shr    r8d,0x6
  959566:	c4 82 c3 f7 3c c1    	shrx   rdi,QWORD PTR [r9+r8*8],rdi
  95956c:	83 e7 01             	and    edi,0x1
  95956f:	c4 e2 49 f7 ff       	shlx   edi,edi,esi
  959574:	09 fa                	or     edx,edi
  959576:	eb c8                	jmp    959540 <check_input_intrinsic_lookup+0x650>
  959578:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
  95957f:	00 
  959580:	c5 fe 6f 84 24 00 01 	vmovdqu ymm0,YMMWORD PTR [rsp+0x100]
  959587:	00 00 
  959589:	44 8b 5c 24 34       	mov    r11d,DWORD PTR [rsp+0x34]
  95958e:	48 8b 5c 24 38       	mov    rbx,QWORD PTR [rsp+0x38]
  959593:	4c 8b 64 24 58       	mov    r12,QWORD PTR [rsp+0x58]
  959598:	c5 fe 6f 9c 24 a0 00 	vmovdqu ymm3,YMMWORD PTR [rsp+0xa0]
  95959f:	00 00 
  9595a1:	c5 fe 6f a4 24 80 00 	vmovdqu ymm4,YMMWORD PTR [rsp+0x80]
  9595a8:	00 00 
  9595aa:	c5 f8 90 54 24 20    	kmovw  k2,WORD PTR [rsp+0x20]
  9595b0:	c5 e9 ef d2          	vpxor  xmm2,xmm2,xmm2
  9595b4:	c5 f5 76 c9          	vpcmpeqd ymm1,ymm1,ymm1
  9595b8:	62 f1 7d 2a 66 ca    	vpcmpgtd k1{k2},ymm0,ymm2
  9595be:	62 f1 7d aa 72 e0 1f 	vpsrad ymm0{k2}{z},ymm0,0x1f
  9595c5:	62 f1 5d 29 fa d9    	vpsubd ymm3{k1},ymm4,ymm1
  9595cb:	c5 fe 6f 4c 24 60    	vmovdqu ymm1,YMMWORD PTR [rsp+0x60]
  9595d1:	c4 e3 65 4c c4 00    	vpblendvb ymm0,ymm3,ymm4,ymm0
  9595d7:	62 f1 7d 29 6f c1    	vmovdqa32 ymm0{k1},ymm1
  9595dd:	c5 fd 66 cb          	vpcmpgtd ymm1,ymm0,ymm3
  9595e1:	62 f1 7d 28 66 cb    	vpcmpgtd k1,ymm0,ymm3
  9595e7:	c4 e2 7d 0e c9       	vtestps ymm1,ymm1
  9595ec:	c5 fd 6f c8          	vmovdqa ymm1,ymm0
  9595f0:	c5 fd 6f c3          	vmovdqa ymm0,ymm3
  9595f4:	c5 f8 91 4c 24 20    	kmovw  WORD PTR [rsp+0x20],k1
  9595fa:	0f 84 60 fa ff ff    	je     959060 <check_input_intrinsic_lookup+0x170>
  959600:	c5 fd 6f d8          	vmovdqa ymm3,ymm0
  959604:	c5 f5 fa c0          	vpsubd ymm0,ymm1,ymm0
  959608:	c5 fe 7f 4c 24 60    	vmovdqu YMMWORD PTR [rsp+0x60],ymm1
  95960e:	c5 fe 7f 9c 24 a0 00 	vmovdqu YMMWORD PTR [rsp+0xa0],ymm3
  959615:	00 00 
  959617:	c5 fe 7f 94 24 00 01 	vmovdqu YMMWORD PTR [rsp+0x100],ymm2
  95961e:	00 00 
  959620:	c5 fd 72 d0 01       	vpsrld ymm0,ymm0,0x1
  959625:	c5 fd fe c3          	vpaddd ymm0,ymm0,ymm3
  959629:	c5 fe 7f 84 24 80 00 	vmovdqu YMMWORD PTR [rsp+0x80],ymm0
  959630:	00 00 
  959632:	c5 fe 7f 84 24 20 01 	vmovdqu YMMWORD PTR [rsp+0x120],ymm0
  959639:	00 00 
  95963b:	c5 f9 ef c0          	vpxor  xmm0,xmm0,xmm0
  95963f:	41 39 db             	cmp    r11d,ebx
  959642:	0f 84 50 ff ff ff    	je     959598 <check_input_intrinsic_lookup+0x6a8>
  959648:	c5 f8 90 4c 24 20    	kmovw  k1,WORD PTR [rsp+0x20]
  95964e:	31 ed                	xor    ebp,ebp
  959650:	c5 79 93 e9          	kmovb  r13d,k1
  959654:	eb 21                	jmp    959677 <check_input_intrinsic_lookup+0x787>
  959656:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  95965d:	00 00 00 
  959660:	89 84 ac 00 01 00 00 	mov    DWORD PTR [rsp+rbp*4+0x100],eax
  959667:	48 ff c5             	inc    rbp
  95966a:	49 83 c4 10          	add    r12,0x10
  95966e:	49 39 ea             	cmp    r10,rbp
  959671:	0f 84 09 ff ff ff    	je     959580 <check_input_intrinsic_lookup+0x690>
  959677:	41 0f a3 ed          	bt     r13d,ebp
  95967b:	73 ea                	jae    959667 <check_input_intrinsic_lookup+0x777>
  95967d:	48 63 84 ac 20 01 00 	movsxd rax,DWORD PTR [rsp+rbp*4+0x120]
  959684:	00 
  959685:	48 8d 0d 64 8e 86 01 	lea    rcx,[rip+0x1868e64]        # 21c24f0 <builtin_intrinsic_infos>
  95968c:	45 8b 3c 24          	mov    r15d,DWORD PTR [r12]
  959690:	48 8d 04 40          	lea    rax,[rax+rax*2]
  959694:	48 c1 e0 05          	shl    rax,0x5
  959698:	8b 5c 08 40          	mov    ebx,DWORD PTR [rax+rcx*1+0x40]
  95969c:	4c 8d 34 01          	lea    r14,[rcx+rax*1]
  9596a0:	41 39 df             	cmp    r15d,ebx
  9596a3:	89 d8                	mov    eax,ebx
  9596a5:	41 0f 42 c7          	cmovb  eax,r15d
  9596a9:	85 c0                	test   eax,eax
  9596ab:	74 1b                	je     9596c8 <check_input_intrinsic_lookup+0x7d8>
  9596ad:	49 8b 7c 24 f8       	mov    rdi,QWORD PTR [r12-0x8]
  9596b2:	49 8b 36             	mov    rsi,QWORD PTR [r14]
  9596b5:	89 c2                	mov    edx,eax
  9596b7:	c5 f8 77             	vzeroupper
  9596ba:	e8 91 47 fa ff       	call   8fde50 <memcmp@plt>
  9596bf:	4c 8b 54 24 28       	mov    r10,QWORD PTR [rsp+0x28]
  9596c4:	85 c0                	test   eax,eax
  9596c6:	75 98                	jne    959660 <check_input_intrinsic_lookup+0x770>
  9596c8:	41 39 df             	cmp    r15d,ebx
  9596cb:	0f 97 c0             	seta   al
  9596ce:	1c 00                	sbb    al,0x0
  9596d0:	0f be c0             	movsx  eax,al
  9596d3:	89 84 ac 00 01 00 00 	mov    DWORD PTR [rsp+rbp*4+0x100],eax
  9596da:	41 39 df             	cmp    r15d,ebx
  9596dd:	75 88                	jne    959667 <check_input_intrinsic_lookup+0x777>
  9596df:	48 8b 44 24 38       	mov    rax,QWORD PTR [rsp+0x38]
  9596e4:	01 e8                	add    eax,ebp
  9596e6:	4c 89 b4 c4 c0 00 00 	mov    QWORD PTR [rsp+rax*8+0xc0],r14
  9596ed:	00 
  9596ee:	e9 74 ff ff ff       	jmp    959667 <check_input_intrinsic_lookup+0x777>
  9596f3:	b0 01                	mov    al,0x1
  9596f5:	45 85 db             	test   r11d,r11d
  9596f8:	74 1f                	je     959719 <check_input_intrinsic_lookup+0x829>
  9596fa:	48 83 7c 24 08 00    	cmp    QWORD PTR [rsp+0x8],0x0
  959700:	44 89 da             	mov    edx,r11d
  959703:	74 40                	je     959745 <check_input_intrinsic_lookup+0x855>
  959705:	89 d1                	mov    ecx,edx
  959707:	83 e1 03             	and    ecx,0x3
  95970a:	41 83 fb 04          	cmp    r11d,0x4
  95970e:	73 59                	jae    959769 <check_input_intrinsic_lookup+0x879>
  959710:	31 f6                	xor    esi,esi
  959712:	e9 7b 01 00 00       	jmp    959892 <check_input_intrinsic_lookup+0x9a2>
  959717:	b0 01                	mov    al,0x1
  959719:	64 48 8b 0c 25 28 00 	mov    rcx,QWORD PTR fs:0x28
  959720:	00 00 
  959722:	48 3b 8c 24 40 01 00 	cmp    rcx,QWORD PTR [rsp+0x140]
  959729:	00 
  95972a:	0f 85 cc 01 00 00    	jne    9598fc <check_input_intrinsic_lookup+0xa0c>
  959730:	48 81 c4 48 01 00 00 	add    rsp,0x148
  959737:	5b                   	pop    rbx
  959738:	41 5c                	pop    r12
  95973a:	41 5d                	pop    r13
  95973c:	41 5e                	pop    r14
  95973e:	41 5f                	pop    r15
  959740:	5d                   	pop    rbp
  959741:	c5 f8 77             	vzeroupper
  959744:	c3                   	ret
  959745:	b9 01 00 00 00       	mov    ecx,0x1
  95974a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
  959750:	48 83 bc cc b8 00 00 	cmp    QWORD PTR [rsp+rcx*8+0xb8],0x0
  959757:	00 00 
  959759:	0f 94 c0             	sete   al
  95975c:	75 bb                	jne    959719 <check_input_intrinsic_lookup+0x829>
  95975e:	48 39 d1             	cmp    rcx,rdx
  959761:	48 8d 49 01          	lea    rcx,[rcx+0x1]
  959765:	72 e9                	jb     959750 <check_input_intrinsic_lookup+0x860>
  959767:	eb b0                	jmp    959719 <check_input_intrinsic_lookup+0x829>
  959769:	83 e2 fc             	and    edx,0xfffffffc
  95976c:	48 8d 3d 7d 8d 86 01 	lea    rdi,[rip+0x1868d7d]        # 21c24f0 <builtin_intrinsic_infos>
  959773:	31 f6                	xor    esi,esi
  959775:	eb 16                	jmp    95978d <check_input_intrinsic_lookup+0x89d>
  959777:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  95977e:	00 00 
  959780:	48 83 c6 04          	add    rsi,0x4
  959784:	48 39 f2             	cmp    rdx,rsi
  959787:	0f 84 fc 00 00 00    	je     959889 <check_input_intrinsic_lookup+0x999>
  95978d:	4c 8b 84 f4 c0 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xc0]
  959794:	00 
  959795:	4d 85 c0             	test   r8,r8
  959798:	74 2f                	je     9597c9 <check_input_intrinsic_lookup+0x8d9>
  95979a:	4c 8b 4c 24 10       	mov    r9,QWORD PTR [rsp+0x10]
  95979f:	49 29 f8             	sub    r8,rdi
  9597a2:	4c 8b 54 24 08       	mov    r10,QWORD PTR [rsp+0x8]
  9597a7:	49 c1 e8 05          	shr    r8,0x5
  9597ab:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  9597b2:	45 8b 0c b1          	mov    r9d,DWORD PTR [r9+rsi*4]
  9597b6:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  9597bd:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  9597c1:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  9597c6:	41 ff 01             	inc    DWORD PTR [r9]
  9597c9:	4c 8b 84 f4 c8 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xc8]
  9597d0:	00 
  9597d1:	4d 85 c0             	test   r8,r8
  9597d4:	74 30                	je     959806 <check_input_intrinsic_lookup+0x916>
  9597d6:	4c 8b 4c 24 10       	mov    r9,QWORD PTR [rsp+0x10]
  9597db:	49 29 f8             	sub    r8,rdi
  9597de:	4c 8b 54 24 08       	mov    r10,QWORD PTR [rsp+0x8]
  9597e3:	49 c1 e8 05          	shr    r8,0x5
  9597e7:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  9597ee:	45 8b 4c b1 04       	mov    r9d,DWORD PTR [r9+rsi*4+0x4]
  9597f3:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  9597fa:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  9597fe:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  959803:	41 ff 01             	inc    DWORD PTR [r9]
  959806:	4c 8b 84 f4 d0 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xd0]
  95980d:	00 
  95980e:	4d 85 c0             	test   r8,r8
  959811:	74 30                	je     959843 <check_input_intrinsic_lookup+0x953>
  959813:	4c 8b 4c 24 10       	mov    r9,QWORD PTR [rsp+0x10]
  959818:	49 29 f8             	sub    r8,rdi
  95981b:	4c 8b 54 24 08       	mov    r10,QWORD PTR [rsp+0x8]
  959820:	49 c1 e8 05          	shr    r8,0x5
  959824:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  95982b:	45 8b 4c b1 08       	mov    r9d,DWORD PTR [r9+rsi*4+0x8]
  959830:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  959837:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  95983b:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  959840:	41 ff 01             	inc    DWORD PTR [r9]
  959843:	4c 8b 84 f4 d8 00 00 	mov    r8,QWORD PTR [rsp+rsi*8+0xd8]
  95984a:	00 
  95984b:	4d 85 c0             	test   r8,r8
  95984e:	0f 84 2c ff ff ff    	je     959780 <check_input_intrinsic_lookup+0x890>
  959854:	4c 8b 4c 24 10       	mov    r9,QWORD PTR [rsp+0x10]
  959859:	49 29 f8             	sub    r8,rdi
  95985c:	4c 8b 54 24 08       	mov    r10,QWORD PTR [rsp+0x8]
  959861:	49 c1 e8 05          	shr    r8,0x5
  959865:	45 69 c0 ab aa aa aa 	imul   r8d,r8d,0xaaaaaaab
  95986c:	45 8b 4c b1 0c       	mov    r9d,DWORD PTR [r9+rsi*4+0xc]
  959871:	41 81 c8 00 00 00 80 	or     r8d,0x80000000
  959878:	47 89 04 8a          	mov    DWORD PTR [r10+r9*4],r8d
  95987c:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
  959881:	41 ff 01             	inc    DWORD PTR [r9]
  959884:	e9 f7 fe ff ff       	jmp    959780 <check_input_intrinsic_lookup+0x890>
  959889:	48 85 c9             	test   rcx,rcx
  95988c:	0f 84 87 fe ff ff    	je     959719 <check_input_intrinsic_lookup+0x829>
  959892:	48 8b 54 24 10       	mov    rdx,QWORD PTR [rsp+0x10]
  959897:	4c 8b 5c 24 08       	mov    r11,QWORD PTR [rsp+0x8]
  95989c:	4c 8d 05 4d 8c 86 01 	lea    r8,[rip+0x1868c4d]        # 21c24f0 <builtin_intrinsic_infos>
  9598a3:	31 ff                	xor    edi,edi
  9598a5:	48 8d 14 b2          	lea    rdx,[rdx+rsi*4]
  9598a9:	48 8d b4 f4 c0 00 00 	lea    rsi,[rsp+rsi*8+0xc0]
  9598b0:	00 
  9598b1:	eb 19                	jmp    9598cc <check_input_intrinsic_lookup+0x9dc>
  9598b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  9598ba:	84 00 00 00 00 00 
  9598c0:	48 ff c7             	inc    rdi
  9598c3:	48 39 f9             	cmp    rcx,rdi
  9598c6:	0f 84 4d fe ff ff    	je     959719 <check_input_intrinsic_lookup+0x829>
  9598cc:	4c 8b 0c fe          	mov    r9,QWORD PTR [rsi+rdi*8]
  9598d0:	4d 85 c9             	test   r9,r9
  9598d3:	74 eb                	je     9598c0 <check_input_intrinsic_lookup+0x9d0>
  9598d5:	4d 29 c1             	sub    r9,r8
  9598d8:	44 8b 14 ba          	mov    r10d,DWORD PTR [rdx+rdi*4]
  9598dc:	49 c1 e9 05          	shr    r9,0x5
  9598e0:	45 69 c9 ab aa aa aa 	imul   r9d,r9d,0xaaaaaaab
  9598e7:	41 81 c9 00 00 00 80 	or     r9d,0x80000000
  9598ee:	47 89 0c 93          	mov    DWORD PTR [r11+r10*4],r9d
  9598f2:	4c 8b 54 24 18       	mov    r10,QWORD PTR [rsp+0x18]
  9598f7:	41 ff 02             	inc    DWORD PTR [r10]
  9598fa:	eb c4                	jmp    9598c0 <check_input_intrinsic_lookup+0x9d0>
  9598fc:	c5 f8 77             	vzeroupper
  9598ff:	e8 3c 3c fa ff       	call   8fd540 <__stack_chk_fail@plt>
