
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008faa60 <check_data_sort_boundaries>:
  8faa60:	push   rbp
  8faa61:	push   r15
  8faa63:	push   r14
  8faa65:	push   r12
  8faa67:	push   rbx
  8faa68:	cmp    edx,0x10000
  8faa6e:	mov    eax,ecx
  8faa70:	mov    rbx,rsi
  8faa73:	mov    r14,rdi
  8faa76:	setae  sil
  8faa7a:	xor    al,0x1
  8faa7c:	and    al,sil
  8faa7f:	test   edx,edx
  8faa81:	je     8faa9e <check_data_sort_boundaries+0x3e>
  8faa83:	mov    r12d,edx
  8faa86:	test   cl,cl
  8faa88:	je     8faad2 <check_data_sort_boundaries+0x72>
  8faa8a:	cmp    edx,0x8
  8faa8d:	jae    8faae6 <check_data_sort_boundaries+0x86>
  8faa8f:	xor    ecx,ecx
  8faa91:	mov    esi,0xffffffff
  8faa96:	xor    r8d,r8d
  8faa99:	jmp    8fad00 <check_data_sort_boundaries+0x2a0>
  8faa9e:	movzx  ebp,al
  8faaa1:	mov    r8d,0xffffffff
  8faaa7:	mov    rdi,r14
  8faaaa:	mov    rsi,rbx
  8faaad:	xor    edx,edx
  8faaaf:	mov    ecx,ebp
  8faab1:	call   1258be0 <c_bindings_sort>
  8faab6:	cmp    rax,r14
  8faab9:	mov    rdi,rax
  8faabc:	mov    ecx,ebp
  8faabe:	mov    r8d,0xffffffff
  8faac4:	cmove  r14,rbx
  8faac8:	xor    edx,edx
  8faaca:	mov    rsi,r14
  8faacd:	jmp    8fb3ef <check_data_sort_boundaries+0x98f>
  8faad2:	cmp    edx,0x8
  8faad5:	jae    8faafa <check_data_sort_boundaries+0x9a>
  8faad7:	xor    ecx,ecx
  8faad9:	mov    r8d,0xffffffff
  8faadf:	xor    esi,esi
  8faae1:	jmp    8faf50 <check_data_sort_boundaries+0x4f0>
  8faae6:	cmp    edx,0x20
  8faae9:	jae    8fab12 <check_data_sort_boundaries+0xb2>
  8faaeb:	xor    ecx,ecx
  8faaed:	mov    esi,0xffffffff
  8faaf2:	xor    r8d,r8d
  8faaf5:	jmp    8fac60 <check_data_sort_boundaries+0x200>
  8faafa:	cmp    edx,0x20
  8faafd:	jae    8fad63 <check_data_sort_boundaries+0x303>
  8fab03:	xor    ecx,ecx
  8fab05:	mov    r8d,0xffffffff
  8fab0b:	xor    esi,esi
  8fab0d:	jmp    8faeb0 <check_data_sort_boundaries+0x450>
  8fab12:	mov    esi,r12d
  8fab15:	shr    esi,0x5
  8fab18:	mov    ecx,r12d
  8fab1b:	and    ecx,0xffffffe0
  8fab1e:	vpcmpeqd ymm1,ymm1,ymm1
  8fab22:	vpcmpeqd ymm5,ymm5,ymm5
  8fab26:	vpcmpeqd ymm7,ymm7,ymm7
  8fab2a:	vpcmpeqd ymm6,ymm6,ymm6
  8fab2e:	vpxor  xmm0,xmm0,xmm0
  8fab32:	xor    edi,edi
  8fab34:	vpxor  xmm2,xmm2,xmm2
  8fab38:	vpxor  xmm4,xmm4,xmm4
  8fab3c:	vpxor  xmm3,xmm3,xmm3
  8fab40:	shl    rsi,0x8
  8fab44:	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  8fab50:	vprolq zmm8,ZMMWORD PTR [r14+rdi*1],0x20
  8fab58:	vprolq zmm9,ZMMWORD PTR [r14+rdi*1+0x40],0x20
  8fab61:	vprolq zmm10,ZMMWORD PTR [r14+rdi*1+0x80],0x20
  8fab6a:	vprolq zmm11,ZMMWORD PTR [r14+rdi*1+0xc0],0x20
  8fab73:	vmovdqu64 ZMMWORD PTR [r14+rdi*1],zmm8
  8fab7a:	vmovdqu64 ZMMWORD PTR [r14+rdi*1+0x40],zmm9
  8fab82:	vmovdqu64 ZMMWORD PTR [r14+rdi*1+0x80],zmm10
  8fab8a:	vmovdqu64 ZMMWORD PTR [r14+rdi*1+0xc0],zmm11
  8fab92:	vpsrlq zmm8,zmm8,0x20
  8fab99:	vpsrlq zmm9,zmm9,0x20
  8faba0:	vpsrlq zmm10,zmm10,0x20
  8faba7:	vpsrlq zmm11,zmm11,0x20
  8fabae:	add    rdi,0x100
  8fabb5:	vpmovqd ymm8,zmm8
  8fabbb:	vpmovqd ymm9,zmm9
  8fabc1:	vpmovqd ymm10,zmm10
  8fabc7:	vpmovqd ymm11,zmm11
  8fabcd:	vpor   ymm2,ymm8,ymm2
  8fabd1:	vpor   ymm4,ymm9,ymm4
  8fabd5:	vpor   ymm3,ymm10,ymm3
  8fabd9:	vpor   ymm0,ymm11,ymm0
  8fabdd:	vpand  ymm5,ymm8,ymm5
  8fabe1:	vpand  ymm7,ymm9,ymm7
  8fabe5:	vpand  ymm6,ymm10,ymm6
  8fabe9:	vpand  ymm1,ymm11,ymm1
  8fabed:	cmp    rsi,rdi
  8fabf0:	jne    8fab50 <check_data_sort_boundaries+0xf0>
  8fabf6:	vpand  ymm5,ymm7,ymm5
  8fabfa:	vpternlogd ymm1,ymm6,ymm5,0x80
  8fac01:	vextracti128 xmm5,ymm1,0x1
  8fac07:	vpand  xmm1,xmm1,xmm5
  8fac0b:	vpshufd xmm5,xmm1,0xee
  8fac10:	vpand  xmm1,xmm1,xmm5
  8fac14:	vpshufd xmm5,xmm1,0x55
  8fac19:	vpand  xmm1,xmm1,xmm5
  8fac1d:	vmovd  esi,xmm1
  8fac21:	vpor   ymm1,ymm4,ymm2
  8fac25:	vpternlogd ymm0,ymm3,ymm1,0xfe
  8fac2c:	vextracti128 xmm1,ymm0,0x1
  8fac32:	vpor   xmm0,xmm0,xmm1
  8fac36:	vpshufd xmm1,xmm0,0xee
  8fac3b:	vpor   xmm0,xmm0,xmm1
  8fac3f:	vpshufd xmm1,xmm0,0x55
  8fac44:	vpor   xmm0,xmm0,xmm1
  8fac48:	vmovd  r8d,xmm0
  8fac4d:	cmp    ecx,r12d
  8fac50:	je     8fad1c <check_data_sort_boundaries+0x2bc>
  8fac56:	test   r12b,0x18
  8fac5a:	je     8fad00 <check_data_sort_boundaries+0x2a0>
  8fac60:	vmovd  xmm0,esi
  8fac64:	vpblendd ymm1,ymm0,YMMWORD PTR [rip+0xffffffffffc99852],0xfe        # 5944c0 <static_test_starved.starved+0x14e0>
  8fac6e:	mov    rdi,rcx
  8fac71:	mov    ecx,r12d
  8fac74:	and    ecx,0xfffffff8
  8fac77:	vmovd  xmm0,r8d
  8fac7c:	nop    DWORD PTR [rax+0x0]
  8fac80:	vprolq zmm2,ZMMWORD PTR [r14+rdi*8],0x20
  8fac88:	vmovdqu64 ZMMWORD PTR [r14+rdi*8],zmm2
  8fac8f:	vpsrlq zmm2,zmm2,0x20
  8fac96:	add    rdi,0x8
  8fac9a:	vpmovqd ymm2,zmm2
  8faca0:	vpor   ymm0,ymm0,ymm2
  8faca4:	vpand  ymm1,ymm1,ymm2
  8faca8:	cmp    rcx,rdi
  8facab:	jne    8fac80 <check_data_sort_boundaries+0x220>
  8facad:	vextracti128 xmm2,ymm1,0x1
  8facb3:	vpand  xmm1,xmm1,xmm2
  8facb7:	vpshufd xmm2,xmm1,0xee
  8facbc:	vpand  xmm1,xmm1,xmm2
  8facc0:	vpshufd xmm2,xmm1,0x55
  8facc5:	vpand  xmm1,xmm1,xmm2
  8facc9:	vmovd  esi,xmm1
  8faccd:	vextracti128 xmm1,ymm0,0x1
  8facd3:	vpor   xmm0,xmm0,xmm1
  8facd7:	vpshufd xmm1,xmm0,0xee
  8facdc:	vpor   xmm0,xmm0,xmm1
  8face0:	vpshufd xmm1,xmm0,0x55
  8face5:	vpor   xmm0,xmm0,xmm1
  8face9:	vmovd  r8d,xmm0
  8facee:	cmp    ecx,r12d
  8facf1:	je     8fad1c <check_data_sort_boundaries+0x2bc>
  8facf3:	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  8fad00:	rorx   rdi,QWORD PTR [r14+rcx*8],0x20
  8fad07:	mov    QWORD PTR [r14+rcx*8],rdi
  8fad0b:	shr    rdi,0x20
  8fad0f:	inc    rcx
  8fad12:	or     r8d,edi
  8fad15:	and    esi,edi
  8fad17:	cmp    r12,rcx
  8fad1a:	jne    8fad00 <check_data_sort_boundaries+0x2a0>
  8fad1c:	xor    r8d,esi
  8fad1f:	movzx  ebp,al
  8fad22:	mov    rdi,r14
  8fad25:	mov    rsi,rbx
  8fad28:	mov    r15d,edx
  8fad2b:	mov    ecx,ebp
  8fad2d:	vzeroupper
  8fad30:	call   1258be0 <c_bindings_sort>
  8fad35:	cmp    r15d,0x8
  8fad39:	jae    8fad4a <check_data_sort_boundaries+0x2ea>
  8fad3b:	xor    ecx,ecx
  8fad3d:	mov    esi,0xffffffff
  8fad42:	xor    r8d,r8d
  8fad45:	jmp    8fb1a0 <check_data_sort_boundaries+0x740>
  8fad4a:	cmp    r15d,0x20
  8fad4e:	jae    8fafbc <check_data_sort_boundaries+0x55c>
  8fad54:	xor    ecx,ecx
  8fad56:	mov    esi,0xffffffff
  8fad5b:	xor    r8d,r8d
  8fad5e:	jmp    8fb100 <check_data_sort_boundaries+0x6a0>
  8fad63:	mov    esi,r12d
  8fad66:	shr    esi,0x5
  8fad69:	mov    ecx,r12d
  8fad6c:	and    ecx,0xffffffe0
  8fad6f:	vpcmpeqd ymm1,ymm1,ymm1
  8fad73:	vpcmpeqd ymm5,ymm5,ymm5
  8fad77:	vpcmpeqd ymm7,ymm7,ymm7
  8fad7b:	vpcmpeqd ymm6,ymm6,ymm6
  8fad7f:	vpxor  xmm0,xmm0,xmm0
  8fad83:	xor    edi,edi
  8fad85:	vpxor  xmm2,xmm2,xmm2
  8fad89:	vpxor  xmm4,xmm4,xmm4
  8fad8d:	vpxor  xmm3,xmm3,xmm3
  8fad91:	shl    rsi,0x8
  8fad95:	data16 cs nop WORD PTR [rax+rax*1+0x0]
  8fada0:	vprolq zmm8,ZMMWORD PTR [r14+rdi*1],0x20
  8fada8:	vprolq zmm9,ZMMWORD PTR [r14+rdi*1+0x40],0x20
  8fadb1:	vprolq zmm10,ZMMWORD PTR [r14+rdi*1+0x80],0x20
  8fadba:	vprolq zmm11,ZMMWORD PTR [r14+rdi*1+0xc0],0x20
  8fadc3:	vmovdqu64 ZMMWORD PTR [r14+rdi*1],zmm8
  8fadca:	vmovdqu64 ZMMWORD PTR [r14+rdi*1+0x40],zmm9
  8fadd2:	vmovdqu64 ZMMWORD PTR [r14+rdi*1+0x80],zmm10
  8fadda:	vmovdqu64 ZMMWORD PTR [r14+rdi*1+0xc0],zmm11
  8fade2:	vpsrlq zmm8,zmm8,0x20
  8fade9:	vpsrlq zmm9,zmm9,0x20
  8fadf0:	vpsrlq zmm10,zmm10,0x20
  8fadf7:	vpsrlq zmm11,zmm11,0x20
  8fadfe:	add    rdi,0x100
  8fae05:	vpmovqd ymm8,zmm8
  8fae0b:	vpmovqd ymm9,zmm9
  8fae11:	vpmovqd ymm10,zmm10
  8fae17:	vpmovqd ymm11,zmm11
  8fae1d:	vpor   ymm2,ymm8,ymm2
  8fae21:	vpor   ymm4,ymm9,ymm4
  8fae25:	vpor   ymm3,ymm10,ymm3
  8fae29:	vpor   ymm0,ymm11,ymm0
  8fae2d:	vpand  ymm5,ymm8,ymm5
  8fae31:	vpand  ymm7,ymm9,ymm7
  8fae35:	vpand  ymm6,ymm10,ymm6
  8fae39:	vpand  ymm1,ymm11,ymm1
  8fae3d:	cmp    rsi,rdi
  8fae40:	jne    8fada0 <check_data_sort_boundaries+0x340>
  8fae46:	vpand  ymm5,ymm7,ymm5
  8fae4a:	vpternlogd ymm1,ymm6,ymm5,0x80
  8fae51:	vextracti128 xmm5,ymm1,0x1
  8fae57:	vpand  xmm1,xmm1,xmm5
  8fae5b:	vpshufd xmm5,xmm1,0xee
  8fae60:	vpand  xmm1,xmm1,xmm5
  8fae64:	vpshufd xmm5,xmm1,0x55
  8fae69:	vpand  xmm1,xmm1,xmm5
  8fae6d:	vmovd  r8d,xmm1
  8fae72:	vpor   ymm1,ymm4,ymm2
  8fae76:	vpternlogd ymm0,ymm3,ymm1,0xfe
  8fae7d:	vextracti128 xmm1,ymm0,0x1
  8fae83:	vpor   xmm0,xmm0,xmm1
  8fae87:	vpshufd xmm1,xmm0,0xee
  8fae8c:	vpor   xmm0,xmm0,xmm1
  8fae90:	vpshufd xmm1,xmm0,0x55
  8fae95:	vpor   xmm0,xmm0,xmm1
  8fae99:	vmovd  esi,xmm0
  8fae9d:	cmp    ecx,r12d
  8faea0:	je     8faf6c <check_data_sort_boundaries+0x50c>
  8faea6:	test   r12b,0x18
  8faeaa:	je     8faf50 <check_data_sort_boundaries+0x4f0>
  8faeb0:	vmovd  xmm0,r8d
  8faeb5:	vpblendd ymm1,ymm0,YMMWORD PTR [rip+0xffffffffffc99601],0xfe        # 5944c0 <static_test_starved.starved+0x14e0>
  8faebf:	mov    rdi,rcx
  8faec2:	mov    ecx,r12d
  8faec5:	and    ecx,0xfffffff8
  8faec8:	vmovd  xmm0,esi
  8faecc:	nop    DWORD PTR [rax+0x0]
  8faed0:	vprolq zmm2,ZMMWORD PTR [r14+rdi*8],0x20
  8faed8:	vmovdqu64 ZMMWORD PTR [r14+rdi*8],zmm2
  8faedf:	vpsrlq zmm2,zmm2,0x20
  8faee6:	add    rdi,0x8
  8faeea:	vpmovqd ymm2,zmm2
  8faef0:	vpor   ymm0,ymm0,ymm2
  8faef4:	vpand  ymm1,ymm1,ymm2
  8faef8:	cmp    rcx,rdi
  8faefb:	jne    8faed0 <check_data_sort_boundaries+0x470>
  8faefd:	vextracti128 xmm2,ymm1,0x1
  8faf03:	vpand  xmm1,xmm1,xmm2
  8faf07:	vpshufd xmm2,xmm1,0xee
  8faf0c:	vpand  xmm1,xmm1,xmm2
  8faf10:	vpshufd xmm2,xmm1,0x55
  8faf15:	vpand  xmm1,xmm1,xmm2
  8faf19:	vmovd  r8d,xmm1
  8faf1e:	vextracti128 xmm1,ymm0,0x1
  8faf24:	vpor   xmm0,xmm0,xmm1
  8faf28:	vpshufd xmm1,xmm0,0xee
  8faf2d:	vpor   xmm0,xmm0,xmm1
  8faf31:	vpshufd xmm1,xmm0,0x55
  8faf36:	vpor   xmm0,xmm0,xmm1
  8faf3a:	vmovd  esi,xmm0
  8faf3e:	cmp    ecx,r12d
  8faf41:	je     8faf6c <check_data_sort_boundaries+0x50c>
  8faf43:	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  8faf50:	rorx   rdi,QWORD PTR [r14+rcx*8],0x20
  8faf57:	mov    QWORD PTR [r14+rcx*8],rdi
  8faf5b:	shr    rdi,0x20
  8faf5f:	inc    rcx
  8faf62:	or     esi,edi
  8faf64:	and    r8d,edi
  8faf67:	cmp    r12,rcx
  8faf6a:	jne    8faf50 <check_data_sort_boundaries+0x4f0>
  8faf6c:	movzx  ebp,al
  8faf6f:	mov    rax,r14
  8faf72:	cmp    esi,r8d
  8faf75:	je     8faf90 <check_data_sort_boundaries+0x530>
  8faf77:	xor    r8d,esi
  8faf7a:	mov    rdi,r14
  8faf7d:	mov    rsi,rbx
  8faf80:	mov    ecx,ebp
  8faf82:	mov    r15d,edx
  8faf85:	vzeroupper
  8faf88:	call   1258be0 <c_bindings_sort>
  8faf8d:	mov    edx,r15d
  8faf90:	cmp    edx,0x8
  8faf93:	jae    8fafa4 <check_data_sort_boundaries+0x544>
  8faf95:	xor    ecx,ecx
  8faf97:	mov    r8d,0xffffffff
  8faf9d:	xor    esi,esi
  8faf9f:	jmp    8fb3b0 <check_data_sort_boundaries+0x950>
  8fafa4:	cmp    edx,0x20
  8fafa7:	jae    8fb1ca <check_data_sort_boundaries+0x76a>
  8fafad:	xor    ecx,ecx
  8fafaf:	mov    r8d,0xffffffff
  8fafb5:	xor    esi,esi
  8fafb7:	jmp    8fb310 <check_data_sort_boundaries+0x8b0>
  8fafbc:	mov    esi,r12d
  8fafbf:	shr    esi,0x5
  8fafc2:	mov    ecx,r12d
  8fafc5:	and    ecx,0xffffffe0
  8fafc8:	vpcmpeqd ymm1,ymm1,ymm1
  8fafcc:	vpcmpeqd ymm5,ymm5,ymm5
  8fafd0:	vpcmpeqd ymm7,ymm7,ymm7
  8fafd4:	vpcmpeqd ymm6,ymm6,ymm6
  8fafd8:	vpxor  xmm0,xmm0,xmm0
  8fafdc:	xor    edi,edi
  8fafde:	vpxor  xmm2,xmm2,xmm2
  8fafe2:	vpxor  xmm4,xmm4,xmm4
  8fafe6:	vpxor  xmm3,xmm3,xmm3
  8fafea:	shl    rsi,0x8
  8fafee:	xchg   ax,ax
  8faff0:	vprolq zmm8,ZMMWORD PTR [rax+rdi*1],0x20
  8faff8:	vprolq zmm9,ZMMWORD PTR [rax+rdi*1+0x40],0x20
  8fb001:	vprolq zmm10,ZMMWORD PTR [rax+rdi*1+0x80],0x20
  8fb00a:	vprolq zmm11,ZMMWORD PTR [rax+rdi*1+0xc0],0x20
  8fb013:	vmovdqu64 ZMMWORD PTR [rax+rdi*1],zmm8
  8fb01a:	vmovdqu64 ZMMWORD PTR [rax+rdi*1+0x40],zmm9
  8fb022:	vmovdqu64 ZMMWORD PTR [rax+rdi*1+0x80],zmm10
  8fb02a:	vmovdqu64 ZMMWORD PTR [rax+rdi*1+0xc0],zmm11
  8fb032:	vpsrlq zmm8,zmm8,0x20
  8fb039:	vpsrlq zmm9,zmm9,0x20
  8fb040:	vpsrlq zmm10,zmm10,0x20
  8fb047:	vpsrlq zmm11,zmm11,0x20
  8fb04e:	add    rdi,0x100
  8fb055:	vpmovqd ymm8,zmm8
  8fb05b:	vpmovqd ymm9,zmm9
  8fb061:	vpmovqd ymm10,zmm10
  8fb067:	vpmovqd ymm11,zmm11
  8fb06d:	vpor   ymm2,ymm8,ymm2
  8fb071:	vpor   ymm4,ymm9,ymm4
  8fb075:	vpor   ymm3,ymm10,ymm3
  8fb079:	vpor   ymm0,ymm11,ymm0
  8fb07d:	vpand  ymm5,ymm8,ymm5
  8fb081:	vpand  ymm7,ymm9,ymm7
  8fb085:	vpand  ymm6,ymm10,ymm6
  8fb089:	vpand  ymm1,ymm11,ymm1
  8fb08d:	cmp    rsi,rdi
  8fb090:	jne    8faff0 <check_data_sort_boundaries+0x590>
  8fb096:	vpand  ymm5,ymm7,ymm5
  8fb09a:	vpternlogd ymm1,ymm6,ymm5,0x80
  8fb0a1:	vextracti128 xmm5,ymm1,0x1
  8fb0a7:	vpand  xmm1,xmm1,xmm5
  8fb0ab:	vpshufd xmm5,xmm1,0xee
  8fb0b0:	vpand  xmm1,xmm1,xmm5
  8fb0b4:	vpshufd xmm5,xmm1,0x55
  8fb0b9:	vpand  xmm1,xmm1,xmm5
  8fb0bd:	vmovd  esi,xmm1
  8fb0c1:	vpor   ymm1,ymm4,ymm2
  8fb0c5:	vpternlogd ymm0,ymm3,ymm1,0xfe
  8fb0cc:	vextracti128 xmm1,ymm0,0x1
  8fb0d2:	vpor   xmm0,xmm0,xmm1
  8fb0d6:	vpshufd xmm1,xmm0,0xee
  8fb0db:	vpor   xmm0,xmm0,xmm1
  8fb0df:	vpshufd xmm1,xmm0,0x55
  8fb0e4:	vpor   xmm0,xmm0,xmm1
  8fb0e8:	vmovd  r8d,xmm0
  8fb0ed:	cmp    ecx,r12d
  8fb0f0:	je     8fb1bc <check_data_sort_boundaries+0x75c>
  8fb0f6:	test   r12b,0x18
  8fb0fa:	je     8fb1a0 <check_data_sort_boundaries+0x740>
  8fb100:	vmovd  xmm0,esi
  8fb104:	vpblendd ymm1,ymm0,YMMWORD PTR [rip+0xffffffffffc993b2],0xfe        # 5944c0 <static_test_starved.starved+0x14e0>
  8fb10e:	mov    rdi,rcx
  8fb111:	mov    ecx,r12d
  8fb114:	and    ecx,0xfffffff8
  8fb117:	vmovd  xmm0,r8d
  8fb11c:	nop    DWORD PTR [rax+0x0]
  8fb120:	vprolq zmm2,ZMMWORD PTR [rax+rdi*8],0x20
  8fb128:	vmovdqu64 ZMMWORD PTR [rax+rdi*8],zmm2
  8fb12f:	vpsrlq zmm2,zmm2,0x20
  8fb136:	add    rdi,0x8
  8fb13a:	vpmovqd ymm2,zmm2
  8fb140:	vpor   ymm0,ymm0,ymm2
  8fb144:	vpand  ymm1,ymm1,ymm2
  8fb148:	cmp    rcx,rdi
  8fb14b:	jne    8fb120 <check_data_sort_boundaries+0x6c0>
  8fb14d:	vextracti128 xmm2,ymm1,0x1
  8fb153:	vpand  xmm1,xmm1,xmm2
  8fb157:	vpshufd xmm2,xmm1,0xee
  8fb15c:	vpand  xmm1,xmm1,xmm2
  8fb160:	vpshufd xmm2,xmm1,0x55
  8fb165:	vpand  xmm1,xmm1,xmm2
  8fb169:	vmovd  esi,xmm1
  8fb16d:	vextracti128 xmm1,ymm0,0x1
  8fb173:	vpor   xmm0,xmm0,xmm1
  8fb177:	vpshufd xmm1,xmm0,0xee
  8fb17c:	vpor   xmm0,xmm0,xmm1
  8fb180:	vpshufd xmm1,xmm0,0x55
  8fb185:	vpor   xmm0,xmm0,xmm1
  8fb189:	vmovd  r8d,xmm0
  8fb18e:	cmp    ecx,r12d
  8fb191:	je     8fb1bc <check_data_sort_boundaries+0x75c>
  8fb193:	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  8fb1a0:	rorx   rdi,QWORD PTR [rax+rcx*8],0x20
  8fb1a7:	mov    QWORD PTR [rax+rcx*8],rdi
  8fb1ab:	shr    rdi,0x20
  8fb1af:	inc    rcx
  8fb1b2:	or     r8d,edi
  8fb1b5:	and    esi,edi
  8fb1b7:	cmp    r12,rcx
  8fb1ba:	jne    8fb1a0 <check_data_sort_boundaries+0x740>
  8fb1bc:	cmp    rax,r14
  8fb1bf:	mov    rdi,rax
  8fb1c2:	mov    edx,r15d
  8fb1c5:	jmp    8fb3e3 <check_data_sort_boundaries+0x983>
  8fb1ca:	mov    esi,r12d
  8fb1cd:	shr    esi,0x5
  8fb1d0:	mov    ecx,r12d
  8fb1d3:	and    ecx,0xffffffe0
  8fb1d6:	vpcmpeqd ymm1,ymm1,ymm1
  8fb1da:	vpcmpeqd ymm5,ymm5,ymm5
  8fb1de:	vpcmpeqd ymm7,ymm7,ymm7
  8fb1e2:	vpcmpeqd ymm6,ymm6,ymm6
  8fb1e6:	vpxor  xmm0,xmm0,xmm0
  8fb1ea:	xor    edi,edi
  8fb1ec:	vpxor  xmm2,xmm2,xmm2
  8fb1f0:	vpxor  xmm4,xmm4,xmm4
  8fb1f4:	vpxor  xmm3,xmm3,xmm3
  8fb1f8:	shl    rsi,0x8
  8fb1fc:	nop    DWORD PTR [rax+0x0]
  8fb200:	vprolq zmm8,ZMMWORD PTR [rax+rdi*1],0x20
  8fb208:	vprolq zmm9,ZMMWORD PTR [rax+rdi*1+0x40],0x20
  8fb211:	vprolq zmm10,ZMMWORD PTR [rax+rdi*1+0x80],0x20
  8fb21a:	vprolq zmm11,ZMMWORD PTR [rax+rdi*1+0xc0],0x20
  8fb223:	vmovdqu64 ZMMWORD PTR [rax+rdi*1],zmm8
  8fb22a:	vmovdqu64 ZMMWORD PTR [rax+rdi*1+0x40],zmm9
  8fb232:	vmovdqu64 ZMMWORD PTR [rax+rdi*1+0x80],zmm10
  8fb23a:	vmovdqu64 ZMMWORD PTR [rax+rdi*1+0xc0],zmm11
  8fb242:	vpsrlq zmm8,zmm8,0x20
  8fb249:	vpsrlq zmm9,zmm9,0x20
  8fb250:	vpsrlq zmm10,zmm10,0x20
  8fb257:	vpsrlq zmm11,zmm11,0x20
  8fb25e:	add    rdi,0x100
  8fb265:	vpmovqd ymm8,zmm8
  8fb26b:	vpmovqd ymm9,zmm9
  8fb271:	vpmovqd ymm10,zmm10
  8fb277:	vpmovqd ymm11,zmm11
  8fb27d:	vpor   ymm2,ymm8,ymm2
  8fb281:	vpor   ymm4,ymm9,ymm4
  8fb285:	vpor   ymm3,ymm10,ymm3
  8fb289:	vpor   ymm0,ymm11,ymm0
  8fb28d:	vpand  ymm5,ymm8,ymm5
  8fb291:	vpand  ymm7,ymm9,ymm7
  8fb295:	vpand  ymm6,ymm10,ymm6
  8fb299:	vpand  ymm1,ymm11,ymm1
  8fb29d:	cmp    rsi,rdi
  8fb2a0:	jne    8fb200 <check_data_sort_boundaries+0x7a0>
  8fb2a6:	vpand  ymm5,ymm7,ymm5
  8fb2aa:	vpternlogd ymm1,ymm6,ymm5,0x80
  8fb2b1:	vextracti128 xmm5,ymm1,0x1
  8fb2b7:	vpand  xmm1,xmm1,xmm5
  8fb2bb:	vpshufd xmm5,xmm1,0xee
  8fb2c0:	vpand  xmm1,xmm1,xmm5
  8fb2c4:	vpshufd xmm5,xmm1,0x55
  8fb2c9:	vpand  xmm1,xmm1,xmm5
  8fb2cd:	vmovd  r8d,xmm1
  8fb2d2:	vpor   ymm1,ymm4,ymm2
  8fb2d6:	vpternlogd ymm0,ymm3,ymm1,0xfe
  8fb2dd:	vextracti128 xmm1,ymm0,0x1
  8fb2e3:	vpor   xmm0,xmm0,xmm1
  8fb2e7:	vpshufd xmm1,xmm0,0xee
  8fb2ec:	vpor   xmm0,xmm0,xmm1
  8fb2f0:	vpshufd xmm1,xmm0,0x55
  8fb2f5:	vpor   xmm0,xmm0,xmm1
  8fb2f9:	vmovd  esi,xmm0
  8fb2fd:	cmp    ecx,r12d
  8fb300:	je     8fb3cc <check_data_sort_boundaries+0x96c>
  8fb306:	test   r12b,0x18
  8fb30a:	je     8fb3b0 <check_data_sort_boundaries+0x950>
  8fb310:	vmovd  xmm0,r8d
  8fb315:	vpblendd ymm1,ymm0,YMMWORD PTR [rip+0xffffffffffc991a1],0xfe        # 5944c0 <static_test_starved.starved+0x14e0>
  8fb31f:	mov    rdi,rcx
  8fb322:	mov    ecx,r12d
  8fb325:	and    ecx,0xfffffff8
  8fb328:	vmovd  xmm0,esi
  8fb32c:	nop    DWORD PTR [rax+0x0]
  8fb330:	vprolq zmm2,ZMMWORD PTR [rax+rdi*8],0x20
  8fb338:	vmovdqu64 ZMMWORD PTR [rax+rdi*8],zmm2
  8fb33f:	vpsrlq zmm2,zmm2,0x20
  8fb346:	add    rdi,0x8
  8fb34a:	vpmovqd ymm2,zmm2
  8fb350:	vpor   ymm0,ymm0,ymm2
  8fb354:	vpand  ymm1,ymm1,ymm2
  8fb358:	cmp    rcx,rdi
  8fb35b:	jne    8fb330 <check_data_sort_boundaries+0x8d0>
  8fb35d:	vextracti128 xmm2,ymm1,0x1
  8fb363:	vpand  xmm1,xmm1,xmm2
  8fb367:	vpshufd xmm2,xmm1,0xee
  8fb36c:	vpand  xmm1,xmm1,xmm2
  8fb370:	vpshufd xmm2,xmm1,0x55
  8fb375:	vpand  xmm1,xmm1,xmm2
  8fb379:	vmovd  r8d,xmm1
  8fb37e:	vextracti128 xmm1,ymm0,0x1
  8fb384:	vpor   xmm0,xmm0,xmm1
  8fb388:	vpshufd xmm1,xmm0,0xee
  8fb38d:	vpor   xmm0,xmm0,xmm1
  8fb391:	vpshufd xmm1,xmm0,0x55
  8fb396:	vpor   xmm0,xmm0,xmm1
  8fb39a:	vmovd  esi,xmm0
  8fb39e:	cmp    ecx,r12d
  8fb3a1:	je     8fb3cc <check_data_sort_boundaries+0x96c>
  8fb3a3:	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  8fb3b0:	rorx   rdi,QWORD PTR [rax+rcx*8],0x20
  8fb3b7:	mov    QWORD PTR [rax+rcx*8],rdi
  8fb3bb:	shr    rdi,0x20
  8fb3bf:	inc    rcx
  8fb3c2:	or     esi,edi
  8fb3c4:	and    r8d,edi
  8fb3c7:	cmp    r12,rcx
  8fb3ca:	jne    8fb3b0 <check_data_sort_boundaries+0x950>
  8fb3cc:	cmp    esi,r8d
  8fb3cf:	jne    8fb3dd <check_data_sort_boundaries+0x97d>
  8fb3d1:	pop    rbx
  8fb3d2:	pop    r12
  8fb3d4:	pop    r14
  8fb3d6:	pop    r15
  8fb3d8:	pop    rbp
  8fb3d9:	vzeroupper
  8fb3dc:	ret
  8fb3dd:	cmp    rax,r14
  8fb3e0:	mov    rdi,rax
  8fb3e3:	cmovne rbx,r14
  8fb3e7:	xor    r8d,esi
  8fb3ea:	mov    rsi,rbx
  8fb3ed:	mov    ecx,ebp
  8fb3ef:	pop    rbx
  8fb3f0:	pop    r12
  8fb3f2:	pop    r14
  8fb3f4:	pop    r15
  8fb3f6:	pop    rbp
  8fb3f7:	vzeroupper
  8fb3fa:	jmp    1258be0 <c_bindings_sort>
