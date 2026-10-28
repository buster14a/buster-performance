
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008f5510 <check_data_plan_object>:
  8f5510:	push   rbp
  8f5511:	push   r15
  8f5513:	push   r14
  8f5515:	push   r13
  8f5517:	push   r12
  8f5519:	push   rbx
  8f551a:	sub    rsp,0x5b8
  8f5521:	mov    rax,QWORD PTR fs:0x28
  8f552a:	mov    r10,QWORD PTR [rsp+0x5f8]
  8f5532:	mov    r12,QWORD PTR [rsp+0x600]
  8f553a:	vpxor  xmm0,xmm0,xmm0
  8f553e:	mov    QWORD PTR [rsp+0x5b0],rax
  8f5546:	mov    rax,QWORD PTR [r10+0x8]
  8f554a:	vmovdqu YMMWORD PTR [r12],ymm0
  8f5550:	mov    QWORD PTR [r12+0x20],0x0
  8f5559:	mov    QWORD PTR [rsp+0xc8],rax
  8f5561:	mov    eax,DWORD PTR [rdx]
  8f5563:	mov    r11d,eax
  8f5566:	shr    r11d,0x3
  8f556a:	je     8f55cf <check_data_plan_object+0xbf>
  8f556c:	mov    r15d,0x0
  8f5572:	mov    r10d,0x0
  8f5578:	xor    r13d,r13d
  8f557b:	cmp    r11d,DWORD PTR [rdi+0x48]
  8f557f:	jae    8f55d8 <check_data_plan_object+0xc8>
  8f5581:	mov    rbx,QWORD PTR [rdi]
  8f5584:	movzx  ebp,BYTE PTR [rbx+r11*1]
  8f5589:	test   bpl,bpl
  8f558c:	je     8f55cf <check_data_plan_object+0xbf>
  8f558e:	mov    r10,QWORD PTR [rdi+0x10]
  8f5592:	cmp    bpl,0xf
  8f5596:	jne    8f5897 <check_data_plan_object+0x387>
  8f559c:	mov    r14,QWORD PTR [rdi+0x20]
  8f55a0:	xor    r13d,r13d
  8f55a3:	mov    r14d,DWORD PTR [r14+r11*4]
  8f55a7:	shr    r14d,0x3
  8f55ab:	test   BYTE PTR [r10+r14*1],0x4
  8f55b0:	mov    r10d,0x0
  8f55b6:	je     8f55d8 <check_data_plan_object+0xc8>
  8f55b8:	mov    r10,QWORD PTR [rdi+0x20]
  8f55bc:	and    eax,0x7
  8f55bf:	mov    r14d,DWORD PTR [r10+r11*4]
  8f55c3:	or     eax,r14d
  8f55c6:	shr    r14d,0x3
  8f55ca:	jmp    8f58ae <check_data_plan_object+0x39e>
  8f55cf:	xor    r13d,r13d
  8f55d2:	xor    r15d,r15d
  8f55d5:	xor    r10d,r10d
  8f55d8:	mov    eax,r10d
  8f55db:	and    eax,0xfe
  8f55e0:	mov    QWORD PTR [rsp+0xa8],r13
  8f55e8:	cmp    eax,0x10
  8f55eb:	mov    eax,r10d
  8f55ee:	sete   r14b
  8f55f2:	and    eax,0xfb
  8f55f7:	cmp    eax,0x8
  8f55fa:	mov    eax,0x1
  8f55ff:	sete   bpl
  8f5603:	cmp    r10d,0xd
  8f5607:	sete   r13b
  8f560b:	test   r15b,r15b
  8f560e:	je     8f58d4 <check_data_plan_object+0x3c4>
  8f5614:	mov    rax,QWORD PTR [rdi+0x18]
  8f5618:	movzx  ebx,BYTE PTR [rdx+0x29]
  8f561c:	mov    r15,QWORD PTR [rdi]
  8f561f:	movzx  eax,BYTE PTR [rax+r11*1]
  8f5624:	cmp    al,bl
  8f5626:	cmova  ebx,eax
  8f5629:	mov    rax,QWORD PTR [rdi+0x38]
  8f562d:	cmp    BYTE PTR [r15+r11*1],0xf
  8f5632:	jne    8f5640 <check_data_plan_object+0x130>
  8f5634:	mov    r15,QWORD PTR [rdi+0x20]
  8f5638:	mov    r11d,DWORD PTR [r15+r11*4]
  8f563c:	shr    r11d,0x3
  8f5640:	mov    r15,QWORD PTR [rsp+0x5f0]
  8f5648:	mov    r15,QWORD PTR [r15+0x8]
  8f564c:	mov    QWORD PTR [rsp+0xc0],r15
  8f5654:	mov    r15,QWORD PTR [rax+r11*8]
  8f5658:	mov    r11b,0x1
  8f565b:	mov    QWORD PTR [r12+0x8],r15
  8f5660:	mov    rax,QWORD PTR [rdx+0x10]
  8f5664:	test   rax,rax
  8f5667:	je     8f567e <check_data_plan_object+0x16e>
  8f5669:	mov    rax,QWORD PTR [rax+0x8]
  8f566d:	test   rax,rax
  8f5670:	je     8f567e <check_data_plan_object+0x16e>
  8f5672:	cmp    rax,r15
  8f5675:	jae    8f58be <check_data_plan_object+0x3ae>
  8f567b:	xor    r11d,r11d
  8f567e:	mov    eax,0x3
  8f5683:	cmp    bl,0x20
  8f5686:	ja     8f58d4 <check_data_plan_object+0x3c4>
  8f568c:	movabs r12,0x1fffffffffffffff
  8f5696:	cmp    r15,r12
  8f5699:	mov    r12,QWORD PTR [rsp+0x600]
  8f56a1:	ja     8f58d4 <check_data_plan_object+0x3c4>
  8f56a7:	mov    eax,0x1
  8f56ac:	mov    BYTE PTR [r12+0x20],bl
  8f56b1:	test   r11b,r11b
  8f56b4:	je     8f58d4 <check_data_plan_object+0x3c4>
  8f56ba:	mov    r11d,DWORD PTR [rdx+0x4]
  8f56be:	mov    eax,0x5
  8f56c3:	test   r11d,r11d
  8f56c6:	sete   bl
  8f56c9:	cmp    r11d,r8d
  8f56cc:	setae  r15b
  8f56d0:	or     r15b,bl
  8f56d3:	jne    8f58d4 <check_data_plan_object+0x3c4>
  8f56d9:	mov    r11d,DWORD PTR [rcx+r11*4]
  8f56dd:	test   r11,r11
  8f56e0:	je     8f58d4 <check_data_plan_object+0x3c4>
  8f56e6:	cmp    r11d,DWORD PTR [r9+0xb8]
  8f56ed:	jae    8f58d4 <check_data_plan_object+0x3c4>
  8f56f3:	mov    DWORD PTR [r12+0x1c],r11d
  8f56f8:	mov    rbx,QWORD PTR [r9+0x88]
  8f56ff:	movzx  ebx,BYTE PTR [rbx+r11*1]
  8f5704:	and    ebx,0xf
  8f5707:	cmp    ebx,0x6
  8f570a:	je     8f5715 <check_data_plan_object+0x205>
  8f570c:	cmp    ebx,0x1
  8f570f:	jne    8f58d4 <check_data_plan_object+0x3c4>
  8f5715:	mov    rbx,QWORD PTR [r9+0x90]
  8f571c:	cmp    BYTE PTR [rbx+r11*1],0x1
  8f5721:	ja     8f58d4 <check_data_plan_object+0x3c4>
  8f5727:	mov    rbx,QWORD PTR [r9+0x70]
  8f572b:	cmp    DWORD PTR [rbx+r11*4],0x0
  8f5730:	jne    8f58d4 <check_data_plan_object+0x3c4>
  8f5736:	mov    r15,QWORD PTR [rdx+0x10]
  8f573a:	mov    QWORD PTR [rsp+0x168],0x0
  8f5746:	mov    DWORD PTR [rsp+0x164],0x0
  8f5751:	mov    QWORD PTR [rsp+0x30],rdi
  8f5756:	test   r15,r15
  8f5759:	setne  bl
  8f575c:	je     8f5900 <check_data_plan_object+0x3f0>
  8f5762:	mov    QWORD PTR [rsp+0x98],rsi
  8f576a:	mov    esi,DWORD PTR [rdx]
  8f576c:	mov    QWORD PTR [rsp+0x68],rdx
  8f5771:	mov    edx,DWORD PTR [r15]
  8f5774:	mov    DWORD PTR [rsp+0x64],r8d
  8f5779:	mov    QWORD PTR [rsp+0x50],rcx
  8f577e:	mov    QWORD PTR [rsp+0x48],r9
  8f5783:	xor    ecx,ecx
  8f5785:	xor    r8d,r8d
  8f5788:	xor    r9d,r9d
  8f578b:	and    esi,0xfffffff8
  8f578e:	and    edx,0xfffffff8
  8f5791:	vzeroupper
  8f5794:	call   125b540 <type_compatible_at>
  8f5799:	cmp    DWORD PTR [r15+0x1c],0x0
  8f579e:	mov    esi,eax
  8f57a0:	mov    eax,0x2
  8f57a5:	jne    8f58d4 <check_data_plan_object+0x3c4>
  8f57ab:	cmp    DWORD PTR [r15+0x18],0x0
  8f57b0:	mov    rcx,QWORD PTR [rsp+0x50]
  8f57b5:	je     8f64d8 <check_data_plan_object+0xfc8>
  8f57bb:	cmp    QWORD PTR [r15+0x10],0x0
  8f57c0:	mov    rdi,QWORD PTR [rsp+0x30]
  8f57c5:	je     8f58d4 <check_data_plan_object+0x3c4>
  8f57cb:	cmp    esi,0x1
  8f57ce:	jne    8f654e <check_data_plan_object+0x103e>
  8f57d4:	mov    rdx,QWORD PTR [rsp+0x5f8]
  8f57dc:	lea    rcx,[rsp+0x168]
  8f57e4:	lea    r8,[rsp+0x164]
  8f57ec:	mov    rsi,r15
  8f57ef:	mov    QWORD PTR [rsp+0x18],r15
  8f57f4:	call   896e80 <check_initializer_live>
  8f57f9:	mov    esi,DWORD PTR [rsp+0x164]
  8f5800:	mov    edi,eax
  8f5802:	xor    eax,eax
  8f5804:	cmp    edi,0x5
  8f5807:	mov    DWORD PTR [rsp+0x28],edi
  8f580b:	sete   al
  8f580e:	test   edi,edi
  8f5810:	lea    eax,[rax+rax*4+0x1]
  8f5814:	sete   cl
  8f5817:	mov    edx,eax
  8f5819:	cmove  edx,edi
  8f581c:	test   rsi,rsi
  8f581f:	mov    DWORD PTR [rsp+0x40],edx
  8f5823:	mov    QWORD PTR [rsp+0x20],rsi
  8f5828:	setne  dl
  8f582b:	and    dl,cl
  8f582d:	cmp    dl,0x1
  8f5830:	jne    8f65b4 <check_data_plan_object+0x10a4>
  8f5836:	mov    rax,QWORD PTR [rsp+0x5f8]
  8f583e:	mov    rsi,QWORD PTR [rax]
  8f5841:	mov    rcx,QWORD PTR [rax+0x8]
  8f5845:	lea    rax,[rcx+rsi*1+0x7]
  8f584a:	add    rcx,rsi
  8f584d:	and    rax,0xfffffffffffffff8
  8f5851:	cmp    rax,rcx
  8f5854:	jb     8f5890 <check_data_plan_object+0x380>
  8f5856:	mov    rdx,rax
  8f5859:	sub    rdx,rsi
  8f585c:	mov    rsi,QWORD PTR [rsp+0x5f8]
  8f5864:	mov    rcx,QWORD PTR [rsp+0x20]
  8f5869:	mov    rsi,QWORD PTR [rsi+0x10]
  8f586d:	lea    rcx,[rcx*8+0x0]
  8f5875:	lea    rcx,[rcx+rcx*2]
  8f5879:	sub    rsi,rdx
  8f587c:	setb   dil
  8f5880:	cmp    rcx,rsi
  8f5883:	seta   sil
  8f5887:	or     sil,dil
  8f588a:	je     8f75c6 <check_data_plan_object+0x20b6>
  8f5890:	xor    eax,eax
  8f5892:	jmp    8f75d5 <check_data_plan_object+0x20c5>
  8f5897:	xor    r13d,r13d
  8f589a:	test   BYTE PTR [r10+r11*1],0x4
  8f589f:	mov    r10d,0x0
  8f58a5:	mov    r14,r11
  8f58a8:	je     8f55d8 <check_data_plan_object+0xc8>
  8f58ae:	movzx  r10d,BYTE PTR [rbx+r14*1]
  8f58b3:	mov    r15b,0x1
  8f58b6:	mov    r13d,eax
  8f58b9:	jmp    8f55d8 <check_data_plan_object+0xc8>
  8f58be:	mov    r15,rax
  8f58c1:	mov    QWORD PTR [r12+0x8],rax
  8f58c6:	mov    eax,0x3
  8f58cb:	cmp    bl,0x20
  8f58ce:	jbe    8f568c <check_data_plan_object+0x17c>
  8f58d4:	mov    rcx,QWORD PTR fs:0x28
  8f58dd:	cmp    rcx,QWORD PTR [rsp+0x5b0]
  8f58e5:	jne    8f7e68 <check_data_plan_object+0x2958>
  8f58eb:	add    rsp,0x5b8
  8f58f2:	pop    rbx
  8f58f3:	pop    r12
  8f58f5:	pop    r13
  8f58f7:	pop    r14
  8f58f9:	pop    r15
  8f58fb:	pop    rbp
  8f58fc:	vzeroupper
  8f58ff:	ret
  8f5900:	cmp    BYTE PTR [rdx+0x28],0x1
  8f5904:	jne    8f59f6 <check_data_plan_object+0x4e6>
  8f590a:	mov    r8,QWORD PTR [rdx+0x20]
  8f590e:	mov    eax,0x1
  8f5913:	cmp    r8,QWORD PTR [r12+0x8]
  8f5918:	jne    8f64ad <check_data_plan_object+0xf9d>
  8f591e:	mov    rsi,QWORD PTR [r9+0x88]
  8f5925:	mov    edi,DWORD PTR [r12+0x1c]
  8f592a:	mov    ebp,ebx
  8f592c:	movzx  esi,BYTE PTR [rsi+rdi*1]
  8f5930:	and    sil,0xf
  8f5934:	test   r8,r8
  8f5937:	je     8f6575 <check_data_plan_object+0x1065>
  8f593d:	mov    QWORD PTR [rsp+0x78],0x0
  8f5946:	cmp    r10d,0x8
  8f594a:	jne    8f6594 <check_data_plan_object+0x1084>
  8f5950:	cmp    QWORD PTR [rdx+0x18],0x0
  8f5955:	je     8f6594 <check_data_plan_object+0x1084>
  8f595b:	mov    edi,0x0
  8f5960:	mov    QWORD PTR [rsp+0x70],rdi
  8f5965:	mov    edi,0x0
  8f596a:	mov    QWORD PTR [rsp+0x38],rdi
  8f596f:	mov    edi,0x0
  8f5974:	mov    QWORD PTR [rsp+0x58],rdi
  8f5979:	cmp    sil,0x1
  8f597d:	jne    8f66a8 <check_data_plan_object+0x1198>
  8f5983:	mov    rdi,QWORD PTR [rsp+0x5f0]
  8f598b:	mov    rsi,QWORD PTR [rsp+0x5f8]
  8f5993:	mov    r13,r15
  8f5996:	mov    r15,rdx
  8f5999:	mov    rdx,r8
  8f599c:	mov    rbx,rcx
  8f599f:	mov    r14,r9
  8f59a2:	vzeroupper
  8f59a5:	call   8f81d0 <check_data_payload>
  8f59aa:	mov    QWORD PTR [r12],rax
  8f59ae:	test   rax,rax
  8f59b1:	je     8f6673 <check_data_plan_object+0x1163>
  8f59b7:	mov    rsi,QWORD PTR [r15+0x18]
  8f59bb:	mov    rdx,QWORD PTR [r12+0x8]
  8f59c0:	mov    rdi,rax
  8f59c3:	call   7dfc50 <memcpy@plt>
  8f59c8:	mov    rdx,r15
  8f59cb:	mov    QWORD PTR [rsp+0x78],0x0
  8f59d4:	mov    QWORD PTR [rsp+0x70],0x0
  8f59dd:	mov    QWORD PTR [rsp+0x38],0x0
  8f59e6:	mov    QWORD PTR [rsp+0x58],0x0
  8f59ef:	xor    eax,eax
  8f59f1:	jmp    8f669f <check_data_plan_object+0x118f>
  8f59f6:	mov    QWORD PTR [rsp+0x78],0x0
  8f59ff:	mov    QWORD PTR [rsp+0x70],0x0
  8f5a08:	mov    QWORD PTR [rsp+0x38],0x0
  8f5a11:	mov    QWORD PTR [rsp+0x58],0x0
  8f5a1a:	xor    r15d,r15d
  8f5a1d:	xor    eax,eax
  8f5a1f:	test   r15,r15
  8f5a22:	jne    8f5a76 <check_data_plan_object+0x566>
  8f5a24:	or     bpl,r14b
  8f5a27:	or     bpl,r13b
  8f5a2a:	je     8f5a36 <check_data_plan_object+0x526>
  8f5a2c:	cmp    DWORD PTR [rdx+0x8],0xffffffff
  8f5a30:	je     8f6669 <check_data_plan_object+0x1159>
  8f5a36:	lea    rax,[rsp+0x1b0]
  8f5a3e:	mov    QWORD PTR [rsp+0x68],rdx
  8f5a43:	mov    r13,rcx
  8f5a46:	mov    ebp,r8d
  8f5a49:	mov    r14,r9
  8f5a4c:	mov    QWORD PTR [rsp],rax
  8f5a50:	vzeroupper
  8f5a53:	call   8f8230 <check_data_plan_scalar>
  8f5a58:	test   eax,eax
  8f5a5a:	je     8f65de <check_data_plan_object+0x10ce>
  8f5a60:	mov    rdi,QWORD PTR [rsp+0x30]
  8f5a65:	mov    rdx,QWORD PTR [rsp+0x68]
  8f5a6a:	xor    r15d,r15d
  8f5a6d:	mov    r9,r14
  8f5a70:	mov    rcx,r13
  8f5a73:	mov    r8d,ebp
  8f5a76:	mov    ebp,ebx
  8f5a78:	lea    rsi,[r15+0x18]
  8f5a7c:	test   eax,eax
  8f5a7e:	mov    QWORD PTR [rsp+0x98],rsi
  8f5a86:	sete   sil
  8f5a8a:	mov    r10d,esi
  8f5a8d:	and    r10b,bpl
  8f5a90:	cmp    r10b,0x1
  8f5a94:	jne    8f66ba <check_data_plan_object+0x11aa>
  8f5a9a:	mov    eax,DWORD PTR [rsp+0x70]
  8f5a9e:	mov    r13,QWORD PTR [rsp+0x78]
  8f5aa3:	mov    BYTE PTR [rsp+0x17],bpl
  8f5aa8:	xor    r14d,r14d
  8f5aab:	xor    esi,esi
  8f5aad:	mov    DWORD PTR [rsp+0xa4],0x0
  8f5ab8:	mov    QWORD PTR [rsp+0xb0],0x0
  8f5ac4:	mov    QWORD PTR [rsp+0x50],rcx
  8f5ac9:	mov    QWORD PTR [rsp+0x48],r9
  8f5ace:	mov    DWORD PTR [rsp+0x64],r8d
  8f5ad3:	mov    QWORD PTR [rsp+0x18],r15
  8f5ad8:	mov    QWORD PTR [rsp+0xb8],rax
  8f5ae0:	jmp    8f5b05 <check_data_plan_object+0x5f5>
  8f5ae2:	mov    rsi,QWORD PTR [rsp+0x90]
  8f5aea:	mov    r13,QWORD PTR [rsp+0x88]
  8f5af2:	inc    r14
  8f5af5:	add    r13,QWORD PTR [rsp+0xb8]
  8f5afd:	test   eax,eax
  8f5aff:	jne    8f58d4 <check_data_plan_object+0x3c4>
  8f5b05:	mov    rax,QWORD PTR [rsp+0x98]
  8f5b0d:	mov    eax,DWORD PTR [rax]
  8f5b0f:	cmp    r14,rax
  8f5b12:	jae    8f655f <check_data_plan_object+0x104f>
  8f5b18:	mov    rax,QWORD PTR [r15+0x10]
  8f5b1c:	imul   r10,r14,0xb0
  8f5b23:	mov    QWORD PTR [rsp+0x90],rsi
  8f5b2b:	mov    QWORD PTR [rsp+0x40],r14
  8f5b30:	mov    ebx,DWORD PTR [rax+r10*1+0x4]
  8f5b35:	lea    rbp,[rax+r10*1]
  8f5b39:	mov    QWORD PTR [rsp+0x28],rbp
  8f5b3e:	shr    ebx,0x3
  8f5b41:	je     8f5b8e <check_data_plan_object+0x67e>
  8f5b43:	cmp    ebx,DWORD PTR [rdi+0x48]
  8f5b46:	jae    8f5b8e <check_data_plan_object+0x67e>
  8f5b48:	mov    rsi,QWORD PTR [rdi]
  8f5b4b:	movzx  r15d,BYTE PTR [rsi+rbx*1]
  8f5b50:	mov    esi,DWORD PTR [rbp+0x0]
  8f5b53:	test   r15b,r15b
  8f5b56:	setne  r11b
  8f5b5a:	test   esi,esi
  8f5b5c:	jne    8f5d73 <check_data_plan_object+0x863>
  8f5b62:	lea    rbp,[rax+r10*1]
  8f5b66:	test   r15b,r15b
  8f5b69:	je     8f5b94 <check_data_plan_object+0x684>
  8f5b6b:	cmp    r15b,0xf
  8f5b6f:	jne    8f5b7b <check_data_plan_object+0x66b>
  8f5b71:	mov    rsi,QWORD PTR [rdi+0x20]
  8f5b75:	mov    ebx,DWORD PTR [rsi+rbx*4]
  8f5b78:	shr    ebx,0x3
  8f5b7b:	mov    rsi,QWORD PTR [rdi+0x38]
  8f5b7f:	mov    r11b,0x1
  8f5b82:	lea    rbp,[rax+r10*1]
  8f5b86:	lea    rbx,[rsi+rbx*8]
  8f5b8a:	xor    esi,esi
  8f5b8c:	jmp    8f5b98 <check_data_plan_object+0x688>
  8f5b8e:	mov    esi,DWORD PTR [rbp+0x0]
  8f5b91:	xor    r11d,r11d
  8f5b94:	lea    rbx,[rbp+0x30]
  8f5b98:	mov    r14,QWORD PTR [rax+r10*1+0x18]
  8f5b9d:	mov    ebp,DWORD PTR [rbp+0x20]
  8f5ba0:	mov    r10,QWORD PTR [rbx]
  8f5ba3:	mov    r15,QWORD PTR [rsp+0x18]
  8f5ba8:	mov    QWORD PTR [rsp+0x88],r13
  8f5bb0:	mov    eax,r14d
  8f5bb3:	and    eax,0x7
  8f5bb6:	lea    rax,[rax+rbp*1+0x7]
  8f5bbb:	shr    rax,0x3
  8f5bbf:	test   rbp,rbp
  8f5bc2:	cmove  rax,r10
  8f5bc6:	mov    QWORD PTR [rsp+0x20],rax
  8f5bcb:	mov    eax,0x1
  8f5bd0:	test   r11b,r11b
  8f5bd3:	je     8f5cd1 <check_data_plan_object+0x7c1>
  8f5bd9:	mov    r11,QWORD PTR [r12+0x8]
  8f5bde:	mov    rbx,r14
  8f5be1:	shr    rbx,0x3
  8f5be5:	xor    r13d,r13d
  8f5be8:	sub    r11,rbx
  8f5beb:	jb     8f5cd4 <check_data_plan_object+0x7c4>
  8f5bf1:	mov    QWORD PTR [rsp+0x80],rbx
  8f5bf9:	mov    rbx,QWORD PTR [rsp+0x20]
  8f5bfe:	cmp    rbx,r11
  8f5c01:	ja     8f5cbd <check_data_plan_object+0x7ad>
  8f5c07:	mov    r13d,r14d
  8f5c0a:	and    r13d,0x7
  8f5c0e:	test   ebp,ebp
  8f5c10:	sete   r11b
  8f5c14:	setne  bl
  8f5c17:	test   r13d,r13d
  8f5c1a:	sete   r15b
  8f5c1e:	or     r15b,bl
  8f5c21:	cmp    esi,0x1
  8f5c24:	setne  bl
  8f5c27:	or     bl,r11b
  8f5c2a:	and    bl,r15b
  8f5c2d:	cmp    bl,0x1
  8f5c30:	jne    8f5ccc <check_data_plan_object+0x7bc>
  8f5c36:	lea    r11d,[rsi-0x1]
  8f5c3a:	cmp    r11d,0x2
  8f5c3e:	jae    8f5d7c <check_data_plan_object+0x86c>
  8f5c44:	mov    r11,QWORD PTR [rsp+0x20]
  8f5c49:	cmp    esi,0x1
  8f5c4c:	jne    8f5e92 <check_data_plan_object+0x982>
  8f5c52:	test   r11,r11
  8f5c55:	je     8f5e92 <check_data_plan_object+0x982>
  8f5c5b:	mov    rbx,QWORD PTR [rsp+0x28]
  8f5c60:	mov    rsi,QWORD PTR [rbx+0x28]
  8f5c64:	test   rsi,rsi
  8f5c67:	je     8f5fa8 <check_data_plan_object+0xa98>
  8f5c6d:	cmp    BYTE PTR [rsp+0x38],0x0
  8f5c72:	mov    r14,rdx
  8f5c75:	jne    8f5fc3 <check_data_plan_object+0xab3>
  8f5c7b:	mov    al,0x3d
  8f5c7d:	bzhi   rax,r11,rax
  8f5c82:	cmp    rax,0x40
  8f5c86:	jb     8f600d <check_data_plan_object+0xafd>
  8f5c8c:	lea    rdx,[rax-0x40]
  8f5c90:	xor    ecx,ecx
  8f5c92:	vmovdqu64 zmm0,ZMMWORD PTR [rsi+rcx*1]
  8f5c99:	add    rcx,0x40
  8f5c9d:	sub    rdx,0x40
  8f5ca1:	vptestmq k0,zmm0,zmm0
  8f5ca7:	kmovd  edi,k0
  8f5cab:	jb     8f5cb2 <check_data_plan_object+0x7a2>
  8f5cad:	test   dil,dil
  8f5cb0:	je     8f5c92 <check_data_plan_object+0x782>
  8f5cb2:	test   dil,dil
  8f5cb5:	setne  dl
  8f5cb8:	jmp    8f6011 <check_data_plan_object+0xb01>
  8f5cbd:	mov    r11,rbx
  8f5cc0:	mov    r14,QWORD PTR [rsp+0x40]
  8f5cc5:	mov    rbx,QWORD PTR [rsp+0x28]
  8f5cca:	jmp    8f5ce3 <check_data_plan_object+0x7d3>
  8f5ccc:	mov    r15,QWORD PTR [rsp+0x18]
  8f5cd1:	xor    r13d,r13d
  8f5cd4:	mov    r14,QWORD PTR [rsp+0x40]
  8f5cd9:	mov    rbx,QWORD PTR [rsp+0x28]
  8f5cde:	mov    r11,QWORD PTR [rsp+0x20]
  8f5ce3:	test   r11,r11
  8f5ce6:	sete   sil
  8f5cea:	or     sil,BYTE PTR [rsp+0x38]
  8f5cef:	jne    8f5ae2 <check_data_plan_object+0x5d2>
  8f5cf5:	mov    esi,DWORD PTR [rbx+0x20]
  8f5cf8:	shl    r11,0x3
  8f5cfc:	test   rsi,rsi
  8f5cff:	cmovne r11,rsi
  8f5d03:	mov    rsi,QWORD PTR [rsp+0x58]
  8f5d08:	or     sil,r13b
  8f5d0b:	mov    QWORD PTR [rsp+0x58],rsi
  8f5d10:	mov    rsi,QWORD PTR [rbx+0x18]
  8f5d14:	test   r13b,r13b
  8f5d17:	je     8f5d34 <check_data_plan_object+0x824>
  8f5d19:	add    r11,rsi
  8f5d1c:	mov    r10b,0x1
  8f5d1f:	mov    DWORD PTR [rsp+0xa4],r10d
  8f5d27:	mov    QWORD PTR [rsp+0xb0],r11
  8f5d2f:	jmp    8f5aea <check_data_plan_object+0x5da>
  8f5d34:	cmp    rsi,QWORD PTR [rsp+0xb0]
  8f5d3c:	mov    rbx,QWORD PTR [rsp+0x90]
  8f5d44:	setae  r10b
  8f5d48:	add    r11,rsi
  8f5d4b:	mov    rsi,r11
  8f5d4e:	cmp    rsi,rbx
  8f5d51:	setbe  sil
  8f5d55:	or     sil,r10b
  8f5d58:	mov    r10d,DWORD PTR [rsp+0xa4]
  8f5d60:	and    r10b,sil
  8f5d63:	mov    rsi,rbx
  8f5d66:	mov    DWORD PTR [rsp+0xa4],r10d
  8f5d6e:	jmp    8f5aea <check_data_plan_object+0x5da>
  8f5d73:	lea    rbp,[rax+r10*1]
  8f5d77:	jmp    8f5b94 <check_data_plan_object+0x684>
  8f5d7c:	mov    r15,QWORD PTR [rsp+0x18]
  8f5d81:	test   esi,esi
  8f5d83:	jne    8f5cd1 <check_data_plan_object+0x7c1>
  8f5d89:	mov    rbx,QWORD PTR [rsp+0x28]
  8f5d8e:	mov    DWORD PTR [rsp+0x160],0x0
  8f5d99:	lea    rax,[rsp+0x100]
  8f5da1:	lea    rsi,[rsp+0x160]
  8f5da9:	mov    QWORD PTR [rsp+0x68],rdx
  8f5dae:	vmovdqu64 zmm0,ZMMWORD PTR [rbx+0x40]
  8f5db5:	vmovdqu64 zmm1,ZMMWORD PTR [rbx+0x60]
  8f5dbf:	vmovdqu64 ZMMWORD PTR [rsp+0x120],zmm1
  8f5dca:	vmovdqu64 ZMMWORD PTR [rsp+0x100],zmm0
  8f5dd2:	vpxor  xmm0,xmm0,xmm0
  8f5dd6:	vmovdqu64 ZMMWORD PTR [rsp+0x288],zmm0
  8f5de1:	vmovdqu64 ZMMWORD PTR [rsp+0x1b0],zmm0
  8f5dec:	vmovdqu64 ZMMWORD PTR [rsp+0x230],zmm0
  8f5df7:	vmovdqu64 ZMMWORD PTR [rsp+0x270],zmm0
  8f5e02:	vmovdqu64 ZMMWORD PTR [rsp+0x1f0],zmm0
  8f5e0d:	mov    QWORD PTR [rsp+0x1b8],rax
  8f5e15:	lea    rax,[rsp+0xd8]
  8f5e1d:	mov    QWORD PTR [rsp+0x1d0],rsi
  8f5e25:	vpxor  xmm0,xmm0,xmm0
  8f5e29:	mov    DWORD PTR [rsp+0x250],0x1
  8f5e34:	lea    rsi,[rsp+0x1b0]
  8f5e3c:	vmovdqu YMMWORD PTR [rax],ymm0
  8f5e40:	mov    QWORD PTR [rax+0x20],0x0
  8f5e48:	mov    eax,DWORD PTR [rbx+0x4]
  8f5e4b:	mov    DWORD PTR [rsp+0xd0],eax
  8f5e52:	mov    eax,DWORD PTR [rdx+0x4]
  8f5e55:	lea    rdx,[rsp+0xd0]
  8f5e5d:	mov    DWORD PTR [rsp+0xd4],eax
  8f5e64:	mov    eax,DWORD PTR [rbx+0xc]
  8f5e67:	mov    DWORD PTR [rsp+0xdc],eax
  8f5e6e:	lea    rax,[rsp+0x170]
  8f5e76:	mov    QWORD PTR [rsp],rax
  8f5e7a:	vzeroupper
  8f5e7d:	call   8f8230 <check_data_plan_scalar>
  8f5e82:	test   eax,eax
  8f5e84:	je     8f5f82 <check_data_plan_object+0xa72>
  8f5e8a:	xor    r13d,r13d
  8f5e8d:	jmp    8f63e2 <check_data_plan_object+0xed2>
  8f5e92:	test   r11,r11
  8f5e95:	setne  al
  8f5e98:	test   BYTE PTR [rsp+0x38],al
  8f5e9c:	je     8f5f5b <check_data_plan_object+0xa4b>
  8f5ea2:	mov    r14,rdx
  8f5ea5:	cmp    esi,0x2
  8f5ea8:	jne    8f5fb5 <check_data_plan_object+0xaa5>
  8f5eae:	mov    rax,QWORD PTR [rsp+0x600]
  8f5eb6:	mov    rcx,QWORD PTR [rsp+0x80]
  8f5ebe:	add    rcx,QWORD PTR [rax]
  8f5ec1:	mov    QWORD PTR [rsp+0x80],rcx
  8f5ec9:	test   ebp,ebp
  8f5ecb:	je     8f6072 <check_data_plan_object+0xb62>
  8f5ed1:	test   r13d,r13d
  8f5ed4:	je     8f5f0d <check_data_plan_object+0x9fd>
  8f5ed6:	mov    eax,0x8
  8f5edb:	mov    ecx,0xffffffff
  8f5ee0:	mov    rdx,QWORD PTR [rsp+0x80]
  8f5ee8:	sub    eax,r13d
  8f5eeb:	cmp    ebp,eax
  8f5eed:	cmovb  eax,ebp
  8f5ef0:	shlx   ecx,ecx,eax
  8f5ef5:	sub    ebp,eax
  8f5ef7:	not    ecx
  8f5ef9:	shlx   ecx,ecx,r13d
  8f5efe:	not    cl
  8f5f00:	and    BYTE PTR [rdx],cl
  8f5f02:	inc    rdx
  8f5f05:	mov    QWORD PTR [rsp+0x80],rdx
  8f5f0d:	mov    eax,ebp
  8f5f0f:	shr    eax,0x3
  8f5f12:	je     8f5f3a <check_data_plan_object+0xa2a>
  8f5f14:	mov    rbx,QWORD PTR [rsp+0x80]
  8f5f1c:	mov    r15d,eax
  8f5f1f:	xor    esi,esi
  8f5f21:	mov    rdx,r15
  8f5f24:	mov    rdi,rbx
  8f5f27:	vzeroupper
  8f5f2a:	call   7dfb20 <memset@plt>
  8f5f2f:	add    rbx,r15
  8f5f32:	mov    QWORD PTR [rsp+0x80],rbx
  8f5f3a:	and    ebp,0x7
  8f5f3d:	je     8f5f53 <check_data_plan_object+0xa43>
  8f5f3f:	mov    rcx,QWORD PTR [rsp+0x80]
  8f5f47:	mov    eax,0xff
  8f5f4c:	shlx   eax,eax,ebp
  8f5f51:	and    BYTE PTR [rcx],al
  8f5f53:	xor    r13d,r13d
  8f5f56:	jmp    8f608a <check_data_plan_object+0xb7a>
  8f5f5b:	xor    eax,eax
  8f5f5d:	cmp    BYTE PTR [rsp+0x38],0x0
  8f5f62:	mov    r15,QWORD PTR [rsp+0x18]
  8f5f67:	mov    r14,QWORD PTR [rsp+0x40]
  8f5f6c:	mov    rbx,QWORD PTR [rsp+0x28]
  8f5f71:	mov    r13d,0x0
  8f5f77:	je     8f5ce3 <check_data_plan_object+0x7d3>
  8f5f7d:	jmp    8f5ae2 <check_data_plan_object+0x5d2>
  8f5f82:	mov    edx,DWORD PTR [rbx+0x20]
  8f5f85:	test   edx,edx
  8f5f87:	je     8f6037 <check_data_plan_object+0xb27>
  8f5f8d:	cmp    DWORD PTR [rsp+0x194],0x0
  8f5f95:	mov    eax,0x1
  8f5f9a:	je     8f60b5 <check_data_plan_object+0xba5>
  8f5fa0:	xor    r13d,r13d
  8f5fa3:	jmp    8f63d0 <check_data_plan_object+0xec0>
  8f5fa8:	mov    r15,QWORD PTR [rsp+0x18]
  8f5fad:	xor    r13d,r13d
  8f5fb0:	jmp    8f6400 <check_data_plan_object+0xef0>
  8f5fb5:	mov    rax,QWORD PTR [rsp+0x28]
  8f5fba:	mov    r11,QWORD PTR [rsp+0x20]
  8f5fbf:	mov    rsi,QWORD PTR [rax+0x28]
  8f5fc3:	mov    r12,QWORD PTR [rsp+0x600]
  8f5fcb:	mov    rdi,QWORD PTR [rsp+0x80]
  8f5fd3:	mov    rdx,r11
  8f5fd6:	add    rdi,QWORD PTR [r12]
  8f5fda:	vzeroupper
  8f5fdd:	call   7dfc50 <memcpy@plt>
  8f5fe2:	mov    r11,QWORD PTR [rsp+0x20]
  8f5fe7:	mov    rdi,QWORD PTR [rsp+0x30]
  8f5fec:	mov    r9,QWORD PTR [rsp+0x48]
  8f5ff1:	mov    rcx,QWORD PTR [rsp+0x50]
  8f5ff6:	mov    r8d,DWORD PTR [rsp+0x64]
  8f5ffb:	mov    r15,QWORD PTR [rsp+0x18]
  8f6000:	xor    r13d,r13d
  8f6003:	xor    eax,eax
  8f6005:	mov    rdx,r14
  8f6008:	jmp    8f5cc0 <check_data_plan_object+0x7b0>
  8f600d:	xor    edx,edx
  8f600f:	xor    ecx,ecx
  8f6011:	test   dl,dl
  8f6013:	jne    8f602f <check_data_plan_object+0xb1f>
  8f6015:	cmp    rcx,rax
  8f6018:	jae    8f602f <check_data_plan_object+0xb1f>
  8f601a:	inc    rcx
  8f601d:	movzx  edx,BYTE PTR [rsi+rcx*1-0x1]
  8f6022:	test   dl,dl
  8f6024:	jne    8f602f <check_data_plan_object+0xb1f>
  8f6026:	cmp    rcx,rax
  8f6029:	lea    rcx,[rcx+0x1]
  8f602d:	jb     8f601d <check_data_plan_object+0xb0d>
  8f602f:	test   dl,dl
  8f6031:	setne  r13b
  8f6035:	jmp    8f608a <check_data_plan_object+0xb7a>
  8f6037:	cmp    BYTE PTR [rsp+0x38],0x0
  8f603c:	je     8f6285 <check_data_plan_object+0xd75>
  8f6042:	mov    rax,QWORD PTR [rsp+0x600]
  8f604a:	movzx  edx,BYTE PTR [rsp+0x1a0]
  8f6052:	lea    rsi,[rsp+0x170]
  8f605a:	mov    rdi,QWORD PTR [rax]
  8f605d:	add    rdi,QWORD PTR [rsp+0x80]
  8f6065:	call   8faa00 <check_data_copy_scalar>
  8f606a:	xor    r13d,r13d
  8f606d:	jmp    8f6391 <check_data_plan_object+0xe81>
  8f6072:	mov    rdi,QWORD PTR [rsp+0x80]
  8f607a:	xor    r13d,r13d
  8f607d:	xor    esi,esi
  8f607f:	mov    rdx,r10
  8f6082:	vzeroupper
  8f6085:	call   7dfb20 <memset@plt>
  8f608a:	mov    rdi,QWORD PTR [rsp+0x30]
  8f608f:	mov    r9,QWORD PTR [rsp+0x48]
  8f6094:	mov    rcx,QWORD PTR [rsp+0x50]
  8f6099:	mov    r8d,DWORD PTR [rsp+0x64]
  8f609e:	mov    r15,QWORD PTR [rsp+0x18]
  8f60a3:	mov    r12,QWORD PTR [rsp+0x600]
  8f60ab:	xor    eax,eax
  8f60ad:	mov    rdx,r14
  8f60b0:	jmp    8f5cd4 <check_data_plan_object+0x7c4>
  8f60b5:	mov    rcx,QWORD PTR [rsp+0x28]
  8f60ba:	mov    rsi,QWORD PTR [rsp+0x30]
  8f60bf:	mov    r9d,r13d
  8f60c2:	mov    ecx,DWORD PTR [rcx+0x4]
  8f60c5:	mov    rsi,QWORD PTR [rsi]
  8f60c8:	mov    edi,ecx
  8f60ca:	shr    edi,0x3
  8f60cd:	movzx  r8d,BYTE PTR [rsi+rdi*1]
  8f60d2:	cmp    r8b,0xf
  8f60d6:	jne    8f60ee <check_data_plan_object+0xbde>
  8f60d8:	mov    rcx,QWORD PTR [rsp+0x30]
  8f60dd:	mov    rcx,QWORD PTR [rcx+0x20]
  8f60e1:	mov    ecx,DWORD PTR [rcx+rdi*4]
  8f60e4:	mov    edi,ecx
  8f60e6:	shr    edi,0x3
  8f60e9:	movzx  r8d,BYTE PTR [rsi+rdi*1]
  8f60ee:	cmp    r8b,0x12
  8f60f2:	jne    8f6110 <check_data_plan_object+0xc00>
  8f60f4:	mov    r8,QWORD PTR [rsp+0x30]
  8f60f9:	mov    r8,QWORD PTR [r8+0x10]
  8f60fd:	test   BYTE PTR [r8+rdi*1],0x4
  8f6102:	je     8f6110 <check_data_plan_object+0xc00>
  8f6104:	mov    rcx,QWORD PTR [rsp+0x30]
  8f6109:	mov    rcx,QWORD PTR [rcx+0x20]
  8f610d:	mov    ecx,DWORD PTR [rcx+rdi*4]
  8f6110:	shr    ecx,0x3
  8f6113:	movzx  esi,BYTE PTR [rsi+rcx*1]
  8f6117:	cmp    esi,0x2
  8f611a:	je     8f6134 <check_data_plan_object+0xc24>
  8f611c:	cmp    esi,0x5
  8f611f:	jne    8f5fa0 <check_data_plan_object+0xa90>
  8f6125:	mov    rsi,QWORD PTR [rsp+0x30]
  8f612a:	mov    rsi,QWORD PTR [rsi+0x30]
  8f612e:	mov    rcx,QWORD PTR [rsi+rcx*8]
  8f6132:	jmp    8f6144 <check_data_plan_object+0xc34>
  8f6134:	lea    rcx,[rcx+rcx*2]
  8f6138:	lea    rsi,[rip+0xffffffffffbb9b71]        # 4afcb0 <type_integer_info>
  8f613f:	movzx  ecx,BYTE PTR [rsi+rcx*2+0x2]
  8f6144:	lea    rsi,[rcx-0x1]
  8f6148:	cmp    rsi,0x7f
  8f614c:	ja     8f5fa0 <check_data_plan_object+0xa90>
  8f6152:	xor    r13d,r13d
  8f6155:	cmp    edx,0x80
  8f615b:	ja     8f63d0 <check_data_plan_object+0xec0>
  8f6161:	mov    r15,QWORD PTR [rsp+0x18]
  8f6166:	mov    r12,QWORD PTR [rsp+0x600]
  8f616e:	mov    rbx,QWORD PTR [rsp+0x28]
  8f6173:	mov    r11,QWORD PTR [rsp+0x20]
  8f6178:	cmp    edx,ecx
  8f617a:	ja     8f63e7 <check_data_plan_object+0xed7>
  8f6180:	cmp    BYTE PTR [rsp+0x38],0x0
  8f6185:	je     8f6285 <check_data_plan_object+0xd75>
  8f618b:	mov    rax,QWORD PTR [rsp+0x600]
  8f6193:	mov    rsi,QWORD PTR [rsp+0x170]
  8f619b:	mov    rdi,QWORD PTR [rsp+0x178]
  8f61a3:	mov    rax,QWORD PTR [rax]
  8f61a6:	add    rax,QWORD PTR [rsp+0x80]
  8f61ae:	test   r9d,r9d
  8f61b1:	je     8f6202 <check_data_plan_object+0xcf2>
  8f61b3:	mov    ecx,0x8
  8f61b8:	mov    r8d,0xffffffff
  8f61be:	mov    r10d,r9d
  8f61c1:	sub    ecx,r9d
  8f61c4:	cmp    edx,ecx
  8f61c6:	cmovb  ecx,edx
  8f61c9:	shlx   r8d,r8d,ecx
  8f61ce:	sub    edx,ecx
  8f61d0:	not    r8d
  8f61d3:	shlx   r8d,r8d,r9d
  8f61d8:	movzx  r9d,BYTE PTR [rax]
  8f61dc:	not    r8d
  8f61df:	or     r8d,0x1
  8f61e3:	and    r8d,r9d
  8f61e6:	bzhi   r9d,esi,ecx
  8f61eb:	shrd   rsi,rdi,cl
  8f61ef:	shrx   rdi,rdi,rcx
  8f61f4:	shlx   r9d,r9d,r10d
  8f61f9:	or     r9d,r8d
  8f61fc:	mov    BYTE PTR [rax],r9b
  8f61ff:	inc    rax
  8f6202:	cmp    edx,0x8
  8f6205:	jb     8f625d <check_data_plan_object+0xd4d>
  8f6207:	lea    ecx,[rdx-0x8]
  8f620a:	mov    r8d,ecx
  8f620d:	shr    r8d,0x3
  8f6211:	inc    r8d
  8f6214:	and    r8d,0x7
  8f6218:	je     8f623c <check_data_plan_object+0xd2c>
  8f621a:	shl    r8d,0x3
  8f621e:	xor    r9d,r9d
  8f6221:	mov    BYTE PTR [rax],sil
  8f6224:	shrd   rsi,rdi,0x8
  8f6229:	inc    rax
  8f622c:	shr    rdi,0x8
  8f6230:	add    r9d,0x8
  8f6234:	cmp    r8d,r9d
  8f6237:	jne    8f6221 <check_data_plan_object+0xd11>
  8f6239:	sub    edx,r9d
  8f623c:	cmp    ecx,0x38
  8f623f:	jb     8f625d <check_data_plan_object+0xd4d>
  8f6241:	mov    QWORD PTR [rax],rsi
  8f6244:	mov    rcx,rdi
  8f6247:	mov    rsi,rdi
  8f624a:	add    rax,0x8
  8f624e:	add    edx,0xffffffc0
  8f6251:	mov    edi,0x0
  8f6256:	cmp    edx,0x7
  8f6259:	ja     8f6241 <check_data_plan_object+0xd31>
  8f625b:	mov    esi,ecx
  8f625d:	test   edx,edx
  8f625f:	je     8f64a5 <check_data_plan_object+0xf95>
  8f6265:	movzx  edi,BYTE PTR [rax]
  8f6268:	mov    ecx,0xffffffff
  8f626d:	xor    r13d,r13d
  8f6270:	shlx   ecx,ecx,edx
  8f6275:	and    edi,ecx
  8f6277:	bzhi   ecx,esi,edx
  8f627c:	or     ecx,edi
  8f627e:	mov    BYTE PTR [rax],cl
  8f6280:	jmp    8f6391 <check_data_plan_object+0xe81>
  8f6285:	mov    rbx,QWORD PTR [rsp+0x40]
  8f628a:	movzx  eax,BYTE PTR [rsp+0x1a0]
  8f6292:	imul   rbx,QWORD PTR [rsp+0xb8]
  8f629b:	add    rbx,QWORD PTR [rsp+0x78]
  8f62a0:	popcnt ecx,eax
  8f62a4:	cmp    ecx,0x1
  8f62a7:	jne    8f62d0 <check_data_plan_object+0xdc0>
  8f62a9:	xor    ecx,ecx
  8f62ab:	tzcnt  ecx,eax
  8f62af:	cmp    ecx,0x5
  8f62b2:	ja     8f62d0 <check_data_plan_object+0xdc0>
  8f62b4:	lea    rdx,[rip+0xffffffffffbb56c5]        # 4ab980 <cbuiltin_test_generated.edges+0xc970>
  8f62bb:	movsxd rax,DWORD PTR [rdx+rcx*4]
  8f62bf:	add    rax,rdx
  8f62c2:	jmp    rax
  8f62c4:	movzx  eax,BYTE PTR [rsp+0x170]
  8f62cc:	mov    BYTE PTR [rbx],al
  8f62ce:	jmp    8f62e2 <check_data_plan_object+0xdd2>
  8f62d0:	lea    rsi,[rsp+0x170]
  8f62d8:	mov    edx,eax
  8f62da:	mov    rdi,rbx
  8f62dd:	call   7dfc50 <memcpy@plt>
  8f62e2:	mov    rax,QWORD PTR [rsp+0x20]
  8f62e7:	lea    rcx,[rax*8+0x0]
  8f62ef:	mov    rax,QWORD PTR [rsp+0x28]
  8f62f4:	mov    eax,DWORD PTR [rax+0x20]
  8f62f7:	test   rax,rax
  8f62fa:	cmovne rcx,rax
  8f62fe:	mov    rax,rcx
  8f6301:	shr    rax,0x3
  8f6305:	cmp    rcx,0x200
  8f630c:	jb     8f6344 <check_data_plan_object+0xe34>
  8f630e:	mov    r8,QWORD PTR [rsp+0x88]
  8f6316:	lea    rdx,[rax-0x40]
  8f631a:	xor    esi,esi
  8f631c:	vmovdqu64 zmm0,ZMMWORD PTR [r8+rsi*1]
  8f6323:	add    rsi,0x40
  8f6327:	sub    rdx,0x40
  8f632b:	vptestmq k0,zmm0,zmm0
  8f6331:	kmovd  edi,k0
  8f6335:	jb     8f633c <check_data_plan_object+0xe2c>
  8f6337:	test   dil,dil
  8f633a:	je     8f631c <check_data_plan_object+0xe0c>
  8f633c:	test   dil,dil
  8f633f:	setne  dl
  8f6342:	jmp    8f6348 <check_data_plan_object+0xe38>
  8f6344:	xor    edx,edx
  8f6346:	xor    esi,esi
  8f6348:	test   dl,dl
  8f634a:	jne    8f636e <check_data_plan_object+0xe5e>
  8f634c:	mov    rdi,QWORD PTR [rsp+0x88]
  8f6354:	cmp    rsi,rax
  8f6357:	jae    8f636e <check_data_plan_object+0xe5e>
  8f6359:	inc    rsi
  8f635c:	movzx  edx,BYTE PTR [rdi+rsi*1-0x1]
  8f6361:	test   dl,dl
  8f6363:	jne    8f636e <check_data_plan_object+0xe5e>
  8f6365:	cmp    rsi,rax
  8f6368:	lea    rsi,[rsi+0x1]
  8f636c:	jb     8f635c <check_data_plan_object+0xe4c>
  8f636e:	test   rcx,rcx
  8f6371:	je     8f638b <check_data_plan_object+0xe7b>
  8f6373:	and    rcx,0x7
  8f6377:	je     8f638b <check_data_plan_object+0xe7b>
  8f6379:	mov    sil,0xff
  8f637c:	shl    sil,cl
  8f637f:	not    sil
  8f6382:	and    sil,BYTE PTR [rbx+rax*1]
  8f6386:	or     sil,dl
  8f6389:	mov    edx,esi
  8f638b:	test   dl,dl
  8f638d:	setne  r13b
  8f6391:	mov    rax,QWORD PTR [rsp+0x28]
  8f6396:	mov    ecx,DWORD PTR [rsp+0x194]
  8f639d:	cmp    DWORD PTR [rax+0x20],0x0
  8f63a1:	sete   al
  8f63a4:	test   ecx,ecx
  8f63a6:	setne  dl
  8f63a9:	and    dl,al
  8f63ab:	xor    eax,eax
  8f63ad:	cmp    dl,0x1
  8f63b0:	jne    8f63d0 <check_data_plan_object+0xec0>
  8f63b2:	mov    rdx,QWORD PTR [rsp+0x168]
  8f63ba:	mov    rsi,QWORD PTR [rsp+0x40]
  8f63bf:	cmp    BYTE PTR [rdx+rsi*1],0x0
  8f63c3:	je     8f63d0 <check_data_plan_object+0xec0>
  8f63c5:	shr    r14,0x23
  8f63c9:	je     8f640a <check_data_plan_object+0xefa>
  8f63cb:	mov    eax,0x3
  8f63d0:	mov    r15,QWORD PTR [rsp+0x18]
  8f63d5:	mov    r12,QWORD PTR [rsp+0x600]
  8f63dd:	mov    rbx,QWORD PTR [rsp+0x28]
  8f63e2:	mov    r11,QWORD PTR [rsp+0x20]
  8f63e7:	mov    rdi,QWORD PTR [rsp+0x30]
  8f63ec:	mov    rdx,QWORD PTR [rsp+0x68]
  8f63f1:	mov    r9,QWORD PTR [rsp+0x48]
  8f63f6:	mov    rcx,QWORD PTR [rsp+0x50]
  8f63fb:	mov    r8d,DWORD PTR [rsp+0x64]
  8f6400:	mov    r14,QWORD PTR [rsp+0x40]
  8f6405:	jmp    8f5ce3 <check_data_plan_object+0x7d3>
  8f640a:	mov    r12,QWORD PTR [rsp+0x600]
  8f6412:	vmovd  xmm1,DWORD PTR [rsp+0x80]
  8f641b:	mov    rdi,QWORD PTR [rsp+0x198]
  8f6423:	vmovd  xmm0,ecx
  8f6427:	mov    r15,QWORD PTR [rsp+0x18]
  8f642c:	mov    esi,DWORD PTR [r12+0x18]
  8f6431:	mov    rdx,QWORD PTR [r12+0x10]
  8f6436:	vpunpckldq xmm0,xmm1,xmm0
  8f643a:	vmovq  xmm0,xmm0
  8f643e:	lea    rsi,[rsi+rsi*2]
  8f6442:	vmovdqu XMMWORD PTR [rdx+rsi*8],xmm0
  8f6447:	mov    QWORD PTR [rdx+rsi*8+0x10],rdi
  8f644c:	inc    DWORD PTR [r12+0x18]
  8f6451:	jmp    8f63dd <check_data_plan_object+0xecd>
  8f6453:	vmovdqa xmm0,XMMWORD PTR [rsp+0x170]
  8f645c:	vmovdqu XMMWORD PTR [rbx],xmm0
  8f6460:	jmp    8f62e2 <check_data_plan_object+0xdd2>
  8f6465:	mov    eax,DWORD PTR [rsp+0x170]
  8f646c:	mov    DWORD PTR [rbx],eax
  8f646e:	jmp    8f62e2 <check_data_plan_object+0xdd2>
  8f6473:	mov    rax,QWORD PTR [rsp+0x170]
  8f647b:	mov    QWORD PTR [rbx],rax
  8f647e:	jmp    8f62e2 <check_data_plan_object+0xdd2>
  8f6483:	movzx  eax,WORD PTR [rsp+0x170]
  8f648b:	mov    WORD PTR [rbx],ax
  8f648e:	jmp    8f62e2 <check_data_plan_object+0xdd2>
  8f6493:	vmovdqu ymm0,YMMWORD PTR [rsp+0x170]
  8f649c:	vmovdqu YMMWORD PTR [rbx],ymm0
  8f64a0:	jmp    8f62e2 <check_data_plan_object+0xdd2>
  8f64a5:	xor    r13d,r13d
  8f64a8:	jmp    8f6391 <check_data_plan_object+0xe81>
  8f64ad:	mov    QWORD PTR [rsp+0x78],0x0
  8f64b6:	mov    QWORD PTR [rsp+0x70],0x0
  8f64bf:	mov    QWORD PTR [rsp+0x38],0x0
  8f64c8:	mov    QWORD PTR [rsp+0x58],0x0
  8f64d1:	mov    ebp,ebx
  8f64d3:	jmp    8f66a8 <check_data_plan_object+0x1198>
  8f64d8:	mov    rdi,QWORD PTR [rsp+0x30]
  8f64dd:	mov    rdx,QWORD PTR [rsp+0x68]
  8f64e2:	mov    r9,QWORD PTR [rsp+0x48]
  8f64e7:	mov    r8d,DWORD PTR [rsp+0x64]
  8f64ec:	cmp    esi,0x1
  8f64ef:	jne    8f654e <check_data_plan_object+0x103e>
  8f64f1:	cmp    BYTE PTR [rdx+0x28],0x0
  8f64f5:	mov    esi,0x0
  8f64fa:	mov    eax,0x1
  8f64ff:	mov    ebp,ebx
  8f6501:	mov    QWORD PTR [rsp+0x78],0x0
  8f650a:	mov    QWORD PTR [rsp+0x70],rsi
  8f650f:	mov    esi,0x0
  8f6514:	mov    QWORD PTR [rsp+0x38],rsi
  8f6519:	mov    esi,0x0
  8f651e:	mov    QWORD PTR [rsp+0x58],rsi
  8f6523:	jne    8f66a8 <check_data_plan_object+0x1198>
  8f6529:	mov    QWORD PTR [rsp+0x70],0x0
  8f6532:	mov    QWORD PTR [rsp+0x38],0x0
  8f653b:	mov    QWORD PTR [rsp+0x58],0x0
  8f6544:	mov    bpl,0x1
  8f6547:	xor    eax,eax
  8f6549:	jmp    8f5a78 <check_data_plan_object+0x568>
  8f654e:	xor    eax,eax
  8f6550:	cmp    esi,0x2
  8f6553:	sete   al
  8f6556:	lea    eax,[rax+rax*4+0x1]
  8f655a:	jmp    8f58d4 <check_data_plan_object+0x3c4>
  8f655f:	movzx  ebp,BYTE PTR [rsp+0x17]
  8f6564:	mov    edi,DWORD PTR [rsp+0xa4]
  8f656b:	mov    sil,0x1
  8f656e:	xor    eax,eax
  8f6570:	jmp    8f66bc <check_data_plan_object+0x11ac>
  8f6575:	cmp    r10d,0x8
  8f6579:	mov    QWORD PTR [rsp+0x78],0x0
  8f6582:	setne  al
  8f6585:	cmp    sil,0x1
  8f6589:	setne  sil
  8f658d:	or     sil,al
  8f6590:	movzx  eax,sil
  8f6594:	mov    QWORD PTR [rsp+0x70],0x0
  8f659d:	mov    QWORD PTR [rsp+0x38],0x0
  8f65a6:	mov    QWORD PTR [rsp+0x58],0x0
  8f65af:	jmp    8f66a8 <check_data_plan_object+0x1198>
  8f65b4:	mov    QWORD PTR [r12+0x10],0x0
  8f65bd:	test   edi,edi
  8f65bf:	jne    8f76ab <check_data_plan_object+0x219b>
  8f65c5:	mov    rcx,QWORD PTR [rsp+0x600]
  8f65cd:	lea    rax,[rcx+0x10]
  8f65d1:	mov    QWORD PTR [rsp+0x90],rax
  8f65d9:	jmp    8f75ed <check_data_plan_object+0x20dd>
  8f65de:	mov    rcx,QWORD PTR [rsp+0x5f0]
  8f65e6:	mov    rax,QWORD PTR [r12+0x8]
  8f65eb:	mov    rdi,QWORD PTR [rcx+0x8]
  8f65ef:	mov    rcx,QWORD PTR [rcx+0x10]
  8f65f3:	sub    rcx,rdi
  8f65f6:	setb   dl
  8f65f9:	cmp    rax,rcx
  8f65fc:	seta   cl
  8f65ff:	or     cl,dl
  8f6601:	jne    8f6628 <check_data_plan_object+0x1118>
  8f6603:	mov    rdx,QWORD PTR [rsp+0x5f0]
  8f660b:	lea    rcx,[rdi+rax*1]
  8f660f:	add    rdi,QWORD PTR [rdx]
  8f6612:	mov    QWORD PTR [rdx+0x8],rcx
  8f6616:	je     8f6628 <check_data_plan_object+0x1118>
  8f6618:	mov    rax,QWORD PTR [rsp+0x600]
  8f6620:	mov    QWORD PTR [rax],rdi
  8f6623:	jmp    8f753b <check_data_plan_object+0x202b>
  8f6628:	mov    rcx,QWORD PTR [rsp+0x5f8]
  8f6630:	mov    rdi,QWORD PTR [rcx+0x8]
  8f6634:	mov    rcx,QWORD PTR [rcx+0x10]
  8f6638:	sub    rcx,rdi
  8f663b:	setb   dl
  8f663e:	cmp    rax,rcx
  8f6641:	seta   cl
  8f6644:	or     cl,dl
  8f6646:	cmp    cl,0x1
  8f6649:	jne    8f7518 <check_data_plan_object+0x2008>
  8f664f:	mov    r12,QWORD PTR [rsp+0x600]
  8f6657:	mov    eax,0x6
  8f665c:	mov    QWORD PTR [r12],0x0
  8f6664:	jmp    8f5a60 <check_data_plan_object+0x550>
  8f6669:	xor    r15d,r15d
  8f666c:	xor    eax,eax
  8f666e:	jmp    8f5a76 <check_data_plan_object+0x566>
  8f6673:	mov    eax,0x6
  8f6678:	mov    rdx,r15
  8f667b:	mov    QWORD PTR [rsp+0x78],0x0
  8f6684:	mov    QWORD PTR [rsp+0x70],0x0
  8f668d:	mov    QWORD PTR [rsp+0x38],0x0
  8f6696:	mov    QWORD PTR [rsp+0x58],0x0
  8f669f:	mov    r9,r14
  8f66a2:	mov    rcx,rbx
  8f66a5:	mov    r15,r13
  8f66a8:	lea    rsi,[r15+0x18]
  8f66ac:	test   eax,eax
  8f66ae:	mov    QWORD PTR [rsp+0x98],rsi
  8f66b6:	sete   sil
  8f66ba:	xor    edi,edi
  8f66bc:	mov    r11,QWORD PTR [rsp+0x58]
  8f66c1:	mov    QWORD PTR [rsp+0x18],r15
  8f66c6:	test   sil,sil
  8f66c9:	je     8f6822 <check_data_plan_object+0x1312>
  8f66cf:	cmp    BYTE PTR [rsp+0x38],0x0
  8f66d4:	jne    8f6822 <check_data_plan_object+0x1312>
  8f66da:	test   bpl,bpl
  8f66dd:	je     8f6822 <check_data_plan_object+0x1312>
  8f66e3:	test   r11b,0x1
  8f66e7:	je     8f6822 <check_data_plan_object+0x1312>
  8f66ed:	test   dil,0x1
  8f66f1:	jne    8f6822 <check_data_plan_object+0x1312>
  8f66f7:	cmp    DWORD PTR [r12+0x18],0x0
  8f66fd:	je     8f6709 <check_data_plan_object+0x11f9>
  8f66ff:	xor    eax,eax
  8f6701:	mov    r11b,0x1
  8f6704:	jmp    8f6822 <check_data_plan_object+0x1312>
  8f6709:	mov    rsi,QWORD PTR [rsp+0x5f8]
  8f6711:	mov    rax,QWORD PTR [rsp+0x98]
  8f6719:	mov    r8d,DWORD PTR [rax]
  8f671c:	mov    r13,QWORD PTR [rsi+0x8]
  8f6720:	mov    eax,0x6
  8f6725:	test   r8d,r8d
  8f6728:	js     8f675f <check_data_plan_object+0x124f>
  8f672a:	mov    QWORD PTR [rsp+0x50],rcx
  8f672f:	mov    rcx,QWORD PTR [rsi]
  8f6732:	mov    QWORD PTR [rsp+0x48],r9
  8f6737:	mov    QWORD PTR [rsp+0x68],rdx
  8f673c:	mov    BYTE PTR [rsp+0x17],bpl
  8f6741:	mov    QWORD PTR [rsp+0x40],r13
  8f6746:	lea    r9,[r13+rcx*1+0x7]
  8f674b:	lea    rdx,[r13+rcx*1+0x0]
  8f6750:	and    r9,0xfffffffffffffff8
  8f6754:	cmp    r9,rdx
  8f6757:	jae    8f6767 <check_data_plan_object+0x1257>
  8f6759:	xor    edi,edi
  8f675b:	xor    esi,esi
  8f675d:	jmp    8f67d2 <check_data_plan_object+0x12c2>
  8f675f:	xor    r11d,r11d
  8f6762:	jmp    8f680c <check_data_plan_object+0x12fc>
  8f6767:	mov    rbx,QWORD PTR [rsi+0x10]
  8f676b:	mov    r11,r9
  8f676e:	sub    r11,rcx
  8f6771:	mov    r10,r8
  8f6774:	shl    r10,0x4
  8f6778:	xor    edi,edi
  8f677a:	mov    r14,rbx
  8f677d:	sub    r14,r11
  8f6780:	jb     8f67ae <check_data_plan_object+0x129e>
  8f6782:	cmp    r10,r14
  8f6785:	ja     8f67ae <check_data_plan_object+0x129e>
  8f6787:	mov    rdx,QWORD PTR [rsp+0x5f8]
  8f678f:	add    r11,r10
  8f6792:	mov    r14,rbx
  8f6795:	mov    rdi,r9
  8f6798:	mov    QWORD PTR [rdx+0x8],r11
  8f679c:	mov    rdx,r9
  8f679f:	add    rdx,r10
  8f67a2:	mov    r11,rdx
  8f67a5:	sub    r11,rcx
  8f67a8:	mov    r9,rdx
  8f67ab:	sub    r14,r11
  8f67ae:	xor    esi,esi
  8f67b0:	cmp    r11,rbx
  8f67b3:	ja     8f67d2 <check_data_plan_object+0x12c2>
  8f67b5:	cmp    r10,r14
  8f67b8:	ja     8f67d2 <check_data_plan_object+0x12c2>
  8f67ba:	mov    rdx,QWORD PTR [rsp+0x5f8]
  8f67c2:	add    r11,r10
  8f67c5:	mov    rsi,r9
  8f67c8:	mov    QWORD PTR [rdx+0x8],r11
  8f67cc:	add    r11,rcx
  8f67cf:	mov    rdx,r11
  8f67d2:	lea    r14,[rdx+0x3]
  8f67d6:	and    r14,0xfffffffffffffffc
  8f67da:	cmp    r14,rdx
  8f67dd:	jae    8f6cb2 <check_data_plan_object+0x17a2>
  8f67e3:	xor    r11d,r11d
  8f67e6:	mov    rdx,QWORD PTR [rsp+0x68]
  8f67eb:	mov    r9,QWORD PTR [rsp+0x48]
  8f67f0:	mov    rcx,QWORD PTR [rsp+0x50]
  8f67f5:	mov    r15,QWORD PTR [rsp+0x18]
  8f67fa:	mov    r12,QWORD PTR [rsp+0x600]
  8f6802:	movzx  ebp,BYTE PTR [rsp+0x17]
  8f6807:	mov    r13,QWORD PTR [rsp+0x40]
  8f680c:	mov    rsi,QWORD PTR [rsp+0x5f8]
  8f6814:	cmp    r13,QWORD PTR [rsi+0x8]
  8f6818:	ja     8f7eb4 <check_data_plan_object+0x29a4>
  8f681e:	mov    QWORD PTR [rsi+0x8],r13
  8f6822:	mov    rdi,QWORD PTR [rsp+0x38]
  8f6827:	test   eax,eax
  8f6829:	mov    QWORD PTR [rsp+0x58],r11
  8f682e:	sete   sil
  8f6832:	not    dil
  8f6835:	and    dil,bpl
  8f6838:	and    dil,sil
  8f683b:	cmp    dil,0x1
  8f683f:	jne    8f68a5 <check_data_plan_object+0x1395>
  8f6841:	test   r11b,0x1
  8f6845:	jne    8f6853 <check_data_plan_object+0x1343>
  8f6847:	cmp    DWORD PTR [r12+0x18],0x0
  8f684d:	je     8f6c90 <check_data_plan_object+0x1780>
  8f6853:	mov    rsi,QWORD PTR [rsp+0x5f0]
  8f685b:	mov    rax,QWORD PTR [r12+0x8]
  8f6860:	mov    rdi,QWORD PTR [rsi+0x8]
  8f6864:	mov    rsi,QWORD PTR [rsi+0x10]
  8f6868:	sub    rsi,rdi
  8f686b:	setb   r8b
  8f686f:	cmp    rax,rsi
  8f6872:	seta   sil
  8f6876:	or     sil,r8b
  8f6879:	jne    8f68b2 <check_data_plan_object+0x13a2>
  8f687b:	mov    r8,QWORD PTR [rsp+0x5f0]
  8f6883:	lea    rsi,[rdi+rax*1]
  8f6887:	add    rdi,QWORD PTR [r8]
  8f688a:	mov    QWORD PTR [r8+0x8],rsi
  8f688e:	je     8f68b2 <check_data_plan_object+0x13a2>
  8f6890:	mov    QWORD PTR [rsp+0x50],rcx
  8f6895:	mov    QWORD PTR [rsp+0x48],r9
  8f689a:	mov    QWORD PTR [rsp+0x68],rdx
  8f689f:	mov    QWORD PTR [r12],rdi
  8f68a3:	jmp    8f690e <check_data_plan_object+0x13fe>
  8f68a5:	test   eax,eax
  8f68a7:	jne    8f58d4 <check_data_plan_object+0x3c4>
  8f68ad:	jmp    8f6ed5 <check_data_plan_object+0x19c5>
  8f68b2:	mov    r10,QWORD PTR [rsp+0x5f8]
  8f68ba:	mov    rdi,QWORD PTR [r10+0x8]
  8f68be:	mov    rsi,QWORD PTR [r10+0x10]
  8f68c2:	sub    rsi,rdi
  8f68c5:	setb   r8b
  8f68c9:	cmp    rax,rsi
  8f68cc:	seta   sil
  8f68d0:	or     sil,r8b
  8f68d3:	cmp    sil,0x1
  8f68d7:	jne    8f68eb <check_data_plan_object+0x13db>
  8f68d9:	mov    QWORD PTR [r12],0x0
  8f68e1:	mov    eax,0x6
  8f68e6:	jmp    8f58d4 <check_data_plan_object+0x3c4>
  8f68eb:	add    rax,rdi
  8f68ee:	mov    QWORD PTR [rsp+0x50],rcx
  8f68f3:	mov    QWORD PTR [rsp+0x48],r9
  8f68f8:	mov    QWORD PTR [rsp+0x68],rdx
  8f68fd:	mov    QWORD PTR [r10+0x8],rax
  8f6901:	add    rdi,QWORD PTR [r10]
  8f6904:	mov    QWORD PTR [r12],rdi
  8f6908:	je     8f6e84 <check_data_plan_object+0x1974>
  8f690e:	mov    rdx,QWORD PTR [r12+0x8]
  8f6913:	xor    esi,esi
  8f6915:	vzeroupper
  8f6918:	call   7dfb20 <memset@plt>
  8f691d:	mov    rcx,QWORD PTR [rsp+0x98]
  8f6925:	mov    eax,DWORD PTR [rsp+0x70]
  8f6929:	mov    QWORD PTR [rsp+0x20],rax
  8f692e:	mov    ecx,DWORD PTR [rcx]
  8f6930:	mov    rax,QWORD PTR [rsp+0x30]
  8f6935:	test   rcx,rcx
  8f6938:	je     8f6c5b <check_data_plan_object+0x174b>
  8f693e:	xor    r8d,r8d
  8f6941:	jmp    8f696e <check_data_plan_object+0x145e>
  8f6943:	mov    edx,edx
  8f6945:	mov    rbx,r8
  8f6948:	vzeroupper
  8f694b:	call   7dfc50 <memcpy@plt>
  8f6950:	mov    rax,QWORD PTR [rsp+0x30]
  8f6955:	mov    r8,rbx
  8f6958:	mov    rcx,QWORD PTR [rsp+0x98]
  8f6960:	inc    r8
  8f6963:	mov    ecx,DWORD PTR [rcx]
  8f6965:	cmp    r8,rcx
  8f6968:	jae    8f6c5b <check_data_plan_object+0x174b>
  8f696e:	mov    rdx,QWORD PTR [r15+0x10]
  8f6972:	imul   rsi,r8,0xb0
  8f6979:	mov    r14,QWORD PTR [rdx+rsi*1+0x18]
  8f697e:	lea    rcx,[rdx+rsi*1]
  8f6982:	mov    esi,DWORD PTR [rdx+rsi*1]
  8f6985:	mov    rdi,r14
  8f6988:	shr    rdi,0x3
  8f698c:	test   esi,esi
  8f698e:	je     8f6a2a <check_data_plan_object+0x151a>
  8f6994:	mov    r13d,DWORD PTR [rcx+0x20]
  8f6998:	test   r13d,r13d
  8f699b:	je     8f6b60 <check_data_plan_object+0x1650>
  8f69a1:	mov    rbp,QWORD PTR [r12]
  8f69a5:	and    r14d,0x7
  8f69a9:	cmp    esi,0x2
  8f69ac:	jne    8f6a58 <check_data_plan_object+0x1548>
  8f69b2:	add    rbp,rdi
  8f69b5:	test   r14d,r14d
  8f69b8:	je     8f69e5 <check_data_plan_object+0x14d5>
  8f69ba:	mov    ecx,0x8
  8f69bf:	mov    edx,0xffffffff
  8f69c4:	sub    ecx,r14d
  8f69c7:	cmp    r13d,ecx
  8f69ca:	cmovb  ecx,r13d
  8f69ce:	shlx   edx,edx,ecx
  8f69d3:	sub    r13d,ecx
  8f69d6:	not    edx
  8f69d8:	shlx   edx,edx,r14d
  8f69dd:	not    dl
  8f69df:	and    BYTE PTR [rbp+0x0],dl
  8f69e2:	inc    rbp
  8f69e5:	mov    ecx,r13d
  8f69e8:	shr    ecx,0x3
  8f69eb:	je     8f6a0e <check_data_plan_object+0x14fe>
  8f69ed:	mov    r14d,ecx
  8f69f0:	mov    rbx,r8
  8f69f3:	mov    rdi,rbp
  8f69f6:	xor    esi,esi
  8f69f8:	mov    rdx,r14
  8f69fb:	vzeroupper
  8f69fe:	call   7dfb20 <memset@plt>
  8f6a03:	mov    rax,QWORD PTR [rsp+0x30]
  8f6a08:	add    rbp,r14
  8f6a0b:	mov    r8,rbx
  8f6a0e:	and    r13d,0x7
  8f6a12:	je     8f6958 <check_data_plan_object+0x1448>
  8f6a18:	mov    ecx,0xff
  8f6a1d:	shlx   ecx,ecx,r13d
  8f6a22:	and    BYTE PTR [rbp+0x0],cl
  8f6a25:	jmp    8f6958 <check_data_plan_object+0x1448>
  8f6a2a:	mov    edx,DWORD PTR [rcx+0x4]
  8f6a2d:	mov    rsi,QWORD PTR [rax]
  8f6a30:	shr    edx,0x3
  8f6a33:	cmp    BYTE PTR [rsi+rdx*1],0xf
  8f6a37:	jne    8f6a43 <check_data_plan_object+0x1533>
  8f6a39:	mov    rsi,QWORD PTR [rax+0x20]
  8f6a3d:	mov    edx,DWORD PTR [rsi+rdx*4]
  8f6a40:	shr    edx,0x3
  8f6a43:	mov    r13d,DWORD PTR [rcx+0x20]
  8f6a47:	test   r13d,r13d
  8f6a4a:	je     8f6bbc <check_data_plan_object+0x16ac>
  8f6a50:	mov    rbp,QWORD PTR [r12]
  8f6a54:	and    r14d,0x7
  8f6a58:	mov    r15,rdi
  8f6a5b:	mov    rsi,r8
  8f6a5e:	imul   rsi,QWORD PTR [rsp+0x20]
  8f6a64:	lea    edx,[r13+0x7]
  8f6a68:	lea    rdi,[rsp+0x1b0]
  8f6a70:	vpxor  xmm0,xmm0,xmm0
  8f6a74:	vmovdqa XMMWORD PTR [rsp+0x1b0],xmm0
  8f6a7d:	mov    rbx,r8
  8f6a80:	shr    edx,0x3
  8f6a83:	add    rsi,QWORD PTR [rsp+0x78]
  8f6a88:	vzeroupper
  8f6a8b:	call   7dfc50 <memcpy@plt>
  8f6a90:	mov    rdx,QWORD PTR [rsp+0x1b0]
  8f6a98:	mov    rsi,QWORD PTR [rsp+0x1b8]
  8f6aa0:	add    rbp,r15
  8f6aa3:	test   r14d,r14d
  8f6aa6:	je     8f6af2 <check_data_plan_object+0x15e2>
  8f6aa8:	mov    ecx,0x8
  8f6aad:	mov    eax,0xffffffff
  8f6ab2:	movzx  edi,BYTE PTR [rbp+0x0]
  8f6ab6:	sub    ecx,r14d
  8f6ab9:	cmp    r13d,ecx
  8f6abc:	cmovb  ecx,r13d
  8f6ac0:	shlx   eax,eax,ecx
  8f6ac5:	sub    r13d,ecx
  8f6ac8:	not    eax
  8f6aca:	shlx   eax,eax,r14d
  8f6acf:	not    eax
  8f6ad1:	or     eax,0x1
  8f6ad4:	and    eax,edi
  8f6ad6:	bzhi   edi,edx,ecx
  8f6adb:	shrd   rdx,rsi,cl
  8f6adf:	shrx   rsi,rsi,rcx
  8f6ae4:	shlx   edi,edi,r14d
  8f6ae9:	or     edi,eax
  8f6aeb:	mov    BYTE PTR [rbp+0x0],dil
  8f6aef:	inc    rbp
  8f6af2:	mov    r15,QWORD PTR [rsp+0x18]
  8f6af7:	mov    rax,QWORD PTR [rsp+0x30]
  8f6afc:	cmp    r13d,0x8
  8f6b00:	jb     8f6b91 <check_data_plan_object+0x1681>
  8f6b06:	lea    ecx,[r13-0x8]
  8f6b0a:	mov    edi,ecx
  8f6b0c:	shr    edi,0x3
  8f6b0f:	inc    edi
  8f6b11:	and    edi,0x7
  8f6b14:	je     8f6b37 <check_data_plan_object+0x1627>
  8f6b16:	shl    edi,0x3
  8f6b19:	xor    r8d,r8d
  8f6b1c:	mov    BYTE PTR [rbp+0x0],dl
  8f6b1f:	shrd   rdx,rsi,0x8
  8f6b24:	inc    rbp
  8f6b27:	shr    rsi,0x8
  8f6b2b:	add    r8d,0x8
  8f6b2f:	cmp    edi,r8d
  8f6b32:	jne    8f6b1c <check_data_plan_object+0x160c>
  8f6b34:	sub    r13d,r8d
  8f6b37:	mov    r8,rbx
  8f6b3a:	cmp    ecx,0x38
  8f6b3d:	jb     8f6b94 <check_data_plan_object+0x1684>
  8f6b3f:	mov    QWORD PTR [rbp+0x0],rdx
  8f6b43:	mov    rcx,rsi
  8f6b46:	mov    rdx,rsi
  8f6b49:	add    rbp,0x8
  8f6b4d:	add    r13d,0xffffffc0
  8f6b51:	mov    esi,0x0
  8f6b56:	cmp    r13d,0x7
  8f6b5a:	ja     8f6b3f <check_data_plan_object+0x162f>
  8f6b5c:	mov    edx,ecx
  8f6b5e:	jmp    8f6b94 <check_data_plan_object+0x1684>
  8f6b60:	mov    rdx,QWORD PTR [rcx+0x30]
  8f6b64:	test   rdx,rdx
  8f6b67:	je     8f6958 <check_data_plan_object+0x1448>
  8f6b6d:	cmp    esi,0x1
  8f6b70:	je     8f6c15 <check_data_plan_object+0x1705>
  8f6b76:	cmp    esi,0x2
  8f6b79:	jne    8f6bcd <check_data_plan_object+0x16bd>
  8f6b7b:	add    rdi,QWORD PTR [r12]
  8f6b7f:	xor    esi,esi
  8f6b81:	mov    rbx,r8
  8f6b84:	vzeroupper
  8f6b87:	call   7dfb20 <memset@plt>
  8f6b8c:	jmp    8f6950 <check_data_plan_object+0x1440>
  8f6b91:	mov    r8,rbx
  8f6b94:	test   r13d,r13d
  8f6b97:	je     8f6958 <check_data_plan_object+0x1448>
  8f6b9d:	movzx  esi,BYTE PTR [rbp+0x0]
  8f6ba1:	mov    ecx,0xffffffff
  8f6ba6:	shlx   ecx,ecx,r13d
  8f6bab:	and    esi,ecx
  8f6bad:	bzhi   ecx,edx,r13d
  8f6bb2:	or     ecx,esi
  8f6bb4:	mov    BYTE PTR [rbp+0x0],cl
  8f6bb7:	jmp    8f6958 <check_data_plan_object+0x1448>
  8f6bbc:	mov    rcx,QWORD PTR [rax+0x38]
  8f6bc0:	mov    rdx,QWORD PTR [rcx+rdx*8]
  8f6bc4:	test   rdx,rdx
  8f6bc7:	je     8f6958 <check_data_plan_object+0x1448>
  8f6bcd:	mov    rsi,r8
  8f6bd0:	imul   rsi,QWORD PTR [rsp+0x20]
  8f6bd6:	add    rdi,QWORD PTR [r12]
  8f6bda:	popcnt ecx,edx
  8f6bde:	add    rsi,QWORD PTR [rsp+0x78]
  8f6be3:	cmp    ecx,0x1
  8f6be6:	jne    8f6943 <check_data_plan_object+0x1433>
  8f6bec:	xor    ecx,ecx
  8f6bee:	tzcnt  ecx,edx
  8f6bf2:	cmp    ecx,0x5
  8f6bf5:	ja     8f6943 <check_data_plan_object+0x1433>
  8f6bfb:	lea    rdx,[rip+0xffffffffffbb4d96]        # 4ab998 <cbuiltin_test_generated.edges+0xc988>
  8f6c02:	movsxd rcx,DWORD PTR [rdx+rcx*4]
  8f6c06:	add    rcx,rdx
  8f6c09:	jmp    rcx
  8f6c0b:	movzx  ecx,BYTE PTR [rsi]
  8f6c0e:	mov    BYTE PTR [rdi],cl
  8f6c10:	jmp    8f6958 <check_data_plan_object+0x1448>
  8f6c15:	add    rdi,QWORD PTR [r12]
  8f6c19:	mov    rsi,QWORD PTR [rcx+0x28]
  8f6c1d:	jmp    8f6945 <check_data_plan_object+0x1435>
  8f6c22:	vmovdqu xmm0,XMMWORD PTR [rsi]
  8f6c26:	vmovdqu XMMWORD PTR [rdi],xmm0
  8f6c2a:	jmp    8f6958 <check_data_plan_object+0x1448>
  8f6c2f:	mov    ecx,DWORD PTR [rsi]
  8f6c31:	mov    DWORD PTR [rdi],ecx
  8f6c33:	jmp    8f6958 <check_data_plan_object+0x1448>
  8f6c38:	mov    rcx,QWORD PTR [rsi]
  8f6c3b:	mov    QWORD PTR [rdi],rcx
  8f6c3e:	jmp    8f6958 <check_data_plan_object+0x1448>
  8f6c43:	movzx  ecx,WORD PTR [rsi]
  8f6c46:	mov    WORD PTR [rdi],cx
  8f6c49:	jmp    8f6958 <check_data_plan_object+0x1448>
  8f6c4e:	vmovdqu ymm0,YMMWORD PTR [rsi]
  8f6c52:	vmovdqu YMMWORD PTR [rdi],ymm0
  8f6c56:	jmp    8f6958 <check_data_plan_object+0x1448>
  8f6c5b:	mov    rdi,QWORD PTR [rsp+0x78]
  8f6c60:	test   rdi,rdi
  8f6c63:	je     8f6c9e <check_data_plan_object+0x178e>
  8f6c65:	imul   rcx,QWORD PTR [rsp+0x20]
  8f6c6b:	mov    rsi,QWORD PTR [r12]
  8f6c6f:	add    rcx,rdi
  8f6c72:	cmp    rsi,rcx
  8f6c75:	je     8f6e8e <check_data_plan_object+0x197e>
  8f6c7b:	mov    rcx,QWORD PTR [rsp+0x5f8]
  8f6c83:	xor    eax,eax
  8f6c85:	sub    rdi,QWORD PTR [rcx]
  8f6c88:	mov    rbx,rdi
  8f6c8b:	jmp    8f6eb2 <check_data_plan_object+0x19a2>
  8f6c90:	mov    QWORD PTR [rsp+0x58],0x0
  8f6c99:	jmp    8f6ed5 <check_data_plan_object+0x19c5>
  8f6c9e:	mov    rdx,QWORD PTR [rsp+0x68]
  8f6ca3:	mov    r9,QWORD PTR [rsp+0x48]
  8f6ca8:	mov    rcx,QWORD PTR [rsp+0x50]
  8f6cad:	jmp    8f6ed5 <check_data_plan_object+0x19c5>
  8f6cb2:	mov    r10,r14
  8f6cb5:	sub    r10,rcx
  8f6cb8:	mov    rcx,QWORD PTR [rsp+0x5f8]
  8f6cc0:	xor    r11d,r11d
  8f6cc3:	mov    rcx,QWORD PTR [rcx+0x10]
  8f6cc7:	sub    rcx,r10
  8f6cca:	jb     8f67e6 <check_data_plan_object+0x12d6>
  8f6cd0:	add    r8,r8
  8f6cd3:	mov    rdx,QWORD PTR [rsp+0x68]
  8f6cd8:	mov    r9,QWORD PTR [rsp+0x48]
  8f6cdd:	mov    r15,QWORD PTR [rsp+0x18]
  8f6ce2:	mov    r12,QWORD PTR [rsp+0x600]
  8f6cea:	movzx  ebp,BYTE PTR [rsp+0x17]
  8f6cef:	mov    r13,QWORD PTR [rsp+0x40]
  8f6cf4:	shl    r8,0x2
  8f6cf8:	cmp    r8,rcx
  8f6cfb:	mov    rcx,QWORD PTR [rsp+0x50]
  8f6d00:	ja     8f680c <check_data_plan_object+0x12fc>
  8f6d06:	mov    rax,QWORD PTR [rsp+0x5f8]
  8f6d0e:	add    r10,r8
  8f6d11:	test   rdi,rdi
  8f6d14:	mov    r11d,0x0
  8f6d1a:	mov    QWORD PTR [rax+0x8],r10
  8f6d1e:	setne  al
  8f6d21:	test   rsi,rsi
  8f6d24:	setne  r8b
  8f6d28:	and    r8b,al
  8f6d2b:	test   r14,r14
  8f6d2e:	mov    eax,0x6
  8f6d33:	setne  r10b
  8f6d37:	xor    ebx,ebx
  8f6d39:	test   r8b,r10b
  8f6d3c:	mov    r10d,0x6
  8f6d42:	cmovne r10d,ebx
  8f6d46:	mov    DWORD PTR [rsp+0x90],r10d
  8f6d4e:	je     8f680c <check_data_plan_object+0x12fc>
  8f6d54:	mov    rax,QWORD PTR [rsp+0x98]
  8f6d5c:	cmp    DWORD PTR [rax],0x0
  8f6d5f:	je     8f78be <check_data_plan_object+0x23ae>
  8f6d65:	mov    rdx,QWORD PTR [rsp+0x30]
  8f6d6a:	mov    r15,QWORD PTR [rsp+0x18]
  8f6d6f:	mov    eax,0x30
  8f6d74:	xor    r12d,r12d
  8f6d77:	xor    ecx,ecx
  8f6d79:	mov    r8,QWORD PTR [r15+0x10]
  8f6d7d:	mov    r9d,DWORD PTR [r8+rax*1-0x2c]
  8f6d82:	shr    r9d,0x3
  8f6d86:	je     8f7e70 <check_data_plan_object+0x2960>
  8f6d8c:	cmp    r9d,DWORD PTR [rdx+0x48]
  8f6d90:	jae    8f7e70 <check_data_plan_object+0x2960>
  8f6d96:	mov    r10,QWORD PTR [rdx]
  8f6d99:	movzx  r10d,BYTE PTR [r10+r9*1]
  8f6d9e:	test   r10b,r10b
  8f6da1:	je     8f7e70 <check_data_plan_object+0x2960>
  8f6da7:	mov    r11d,DWORD PTR [r8+rax*1-0x30]
  8f6dac:	cmp    r11d,0x2
  8f6db0:	ja     8f7e70 <check_data_plan_object+0x2960>
  8f6db6:	test   r11d,r11d
  8f6db9:	je     8f6dc1 <check_data_plan_object+0x18b1>
  8f6dbb:	lea    r10,[r8+rax*1]
  8f6dbf:	jmp    8f6de0 <check_data_plan_object+0x18d0>
  8f6dc1:	cmp    r10b,0xf
  8f6dc5:	jne    8f6dd3 <check_data_plan_object+0x18c3>
  8f6dc7:	mov    r10,QWORD PTR [rdx+0x20]
  8f6dcb:	mov    r9d,DWORD PTR [r10+r9*4]
  8f6dcf:	shr    r9d,0x3
  8f6dd3:	mov    r10,QWORD PTR [rdx+0x38]
  8f6dd7:	mov    r15,QWORD PTR [rsp+0x18]
  8f6ddc:	lea    r10,[r10+r9*8]
  8f6de0:	mov    r9d,DWORD PTR [r8+rax*1-0x10]
  8f6de5:	test   r9,r9
  8f6de8:	jne    8f6e04 <check_data_plan_object+0x18f4>
  8f6dea:	mov    r9,QWORD PTR [r10]
  8f6ded:	movabs r10,0x1fffffffffffffff
  8f6df7:	cmp    r9,r10
  8f6dfa:	ja     8f7e70 <check_data_plan_object+0x2960>
  8f6e00:	shl    r9,0x3
  8f6e04:	mov    r10,QWORD PTR [r8+rax*1-0x18]
  8f6e09:	mov    r11,r10
  8f6e0c:	add    r11,r9
  8f6e0f:	jb     8f7e70 <check_data_plan_object+0x2960>
  8f6e15:	mov    ebx,r12d
  8f6e18:	mov    QWORD PTR [rdi+rbx*8],r10
  8f6e1c:	lea    r11d,[r12+0x1]
  8f6e21:	add    r12d,0x2
  8f6e25:	inc    rcx
  8f6e28:	add    r9,QWORD PTR [r8+rax*1-0x18]
  8f6e2d:	mov    r8,QWORD PTR [rsp+0x98]
  8f6e35:	add    rax,0xb0
  8f6e3b:	mov    QWORD PTR [rdi+r11*8],r9
  8f6e3f:	mov    r8d,DWORD PTR [r8]
  8f6e42:	cmp    rcx,r8
  8f6e45:	jb     8f6d79 <check_data_plan_object+0x1869>
  8f6e4b:	mov    QWORD PTR [rsp+0x20],0x0
  8f6e54:	mov    edx,r12d
  8f6e57:	xor    ecx,ecx
  8f6e59:	vzeroupper
  8f6e5c:	call   8faa60 <check_data_sort_boundaries>
  8f6e61:	test   r12d,r12d
  8f6e64:	je     8f7b2e <check_data_plan_object+0x261e>
  8f6e6a:	cmp    r12d,0x4
  8f6e6e:	jae    8f7a0f <check_data_plan_object+0x24ff>
  8f6e74:	xor    ecx,ecx
  8f6e76:	mov    QWORD PTR [rsp+0x20],0x0
  8f6e7f:	jmp    8f7aec <check_data_plan_object+0x25dc>
  8f6e84:	mov    eax,0x6
  8f6e89:	jmp    8f58d4 <check_data_plan_object+0x3c4>
  8f6e8e:	mov    rdx,QWORD PTR [r12+0x8]
  8f6e93:	mov    rbx,rdi
  8f6e96:	vzeroupper
  8f6e99:	call   7df470 <memmove@plt>
  8f6e9e:	mov    rcx,QWORD PTR [rsp+0x5f8]
  8f6ea6:	mov    QWORD PTR [r12],rbx
  8f6eaa:	mov    rax,QWORD PTR [r12+0x8]
  8f6eaf:	sub    rbx,QWORD PTR [rcx]
  8f6eb2:	add    rbx,rax
  8f6eb5:	mov    rdx,QWORD PTR [rsp+0x68]
  8f6eba:	mov    r9,QWORD PTR [rsp+0x48]
  8f6ebf:	mov    rax,rcx
  8f6ec2:	cmp    rbx,QWORD PTR [rcx+0x8]
  8f6ec6:	mov    rcx,QWORD PTR [rsp+0x50]
  8f6ecb:	ja     8f7eb4 <check_data_plan_object+0x29a4>
  8f6ed1:	mov    QWORD PTR [rax+0x8],rbx
  8f6ed5:	mov    r8d,DWORD PTR [r12+0x18]
  8f6eda:	cmp    r8,0x2
  8f6ede:	jb     8f72d5 <check_data_plan_object+0x1dc5>
  8f6ee4:	mov    rax,QWORD PTR [rsp+0x5f8]
  8f6eec:	mov    r10,QWORD PTR [rax]
  8f6eef:	mov    rax,QWORD PTR [rax+0x8]
  8f6ef3:	lea    rsi,[rax+r10*1+0x7]
  8f6ef8:	add    rax,r10
  8f6efb:	and    rsi,0xfffffffffffffff8
  8f6eff:	cmp    rsi,rax
  8f6f02:	jb     8f6f34 <check_data_plan_object+0x1a24>
  8f6f04:	mov    rdi,rsi
  8f6f07:	sub    rdi,r10
  8f6f0a:	mov    r10,QWORD PTR [rsp+0x5f8]
  8f6f12:	mov    rax,r8
  8f6f15:	shl    rax,0x3
  8f6f19:	lea    rax,[rax+rax*2]
  8f6f1d:	mov    r10,QWORD PTR [r10+0x10]
  8f6f21:	sub    r10,rdi
  8f6f24:	setb   r11b
  8f6f28:	cmp    rax,r10
  8f6f2b:	seta   r10b
  8f6f2f:	or     r10b,r11b
  8f6f32:	je     8f6f38 <check_data_plan_object+0x1a28>
  8f6f34:	xor    esi,esi
  8f6f36:	jmp    8f6f4c <check_data_plan_object+0x1a3c>
  8f6f38:	mov    r8,QWORD PTR [rsp+0x5f8]
  8f6f40:	add    rdi,rax
  8f6f43:	mov    QWORD PTR [r8+0x8],rdi
  8f6f47:	mov    r8d,DWORD PTR [r12+0x18]
  8f6f4c:	cmp    r8d,0x2
  8f6f50:	jb     8f6f60 <check_data_plan_object+0x1a50>
  8f6f52:	mov    eax,0x6
  8f6f57:	test   rsi,rsi
  8f6f5a:	je     8f58d4 <check_data_plan_object+0x3c4>
  8f6f60:	cmp    r8d,0x2
  8f6f64:	jb     8f72d5 <check_data_plan_object+0x1dc5>
  8f6f6a:	mov    r10,QWORD PTR [r12+0x10]
  8f6f6f:	xor    eax,eax
  8f6f71:	vpxor  xmm0,xmm0,xmm0
  8f6f75:	mov    r11d,r8d
  8f6f78:	mov    rdi,r10
  8f6f7b:	mov    r10d,r11d
  8f6f7e:	and    r10d,0x7
  8f6f82:	dec    r8d
  8f6f85:	vmovdqu64 ZMMWORD PTR [rsp+0x570],zmm0
  8f6f90:	vmovdqu64 ZMMWORD PTR [rsp+0x530],zmm0
  8f6f9b:	vmovdqu64 ZMMWORD PTR [rsp+0x4f0],zmm0
  8f6fa6:	vmovdqu64 ZMMWORD PTR [rsp+0x4b0],zmm0
  8f6fb1:	vmovdqu64 ZMMWORD PTR [rsp+0x470],zmm0
  8f6fbc:	vmovdqu64 ZMMWORD PTR [rsp+0x430],zmm0
  8f6fc7:	vmovdqu64 ZMMWORD PTR [rsp+0x3f0],zmm0
  8f6fd2:	vmovdqu64 ZMMWORD PTR [rsp+0x3b0],zmm0
  8f6fdd:	vmovdqu64 ZMMWORD PTR [rsp+0x370],zmm0
  8f6fe8:	vmovdqu64 ZMMWORD PTR [rsp+0x330],zmm0
  8f6ff3:	vmovdqu64 ZMMWORD PTR [rsp+0x2f0],zmm0
  8f6ffe:	vmovdqu64 ZMMWORD PTR [rsp+0x2b0],zmm0
  8f7009:	vmovdqu64 ZMMWORD PTR [rsp+0x270],zmm0
  8f7014:	vmovdqu64 ZMMWORD PTR [rsp+0x230],zmm0
  8f701f:	vmovdqu64 ZMMWORD PTR [rsp+0x1f0],zmm0
  8f702a:	vmovdqu64 ZMMWORD PTR [rsp+0x1b0],zmm0
  8f7035:	cmp    r8d,0x7
  8f7039:	jae    8f7043 <check_data_plan_object+0x1b33>
  8f703b:	xor    r8d,r8d
  8f703e:	jmp    8f70fb <check_data_plan_object+0x1beb>
  8f7043:	and    r11d,0xfffffff8
  8f7047:	mov    rbx,rdi
  8f704a:	xor    r8d,r8d
  8f704d:	shrx   ebp,DWORD PTR [rbx],eax
  8f7052:	add    r8,0x8
  8f7056:	movzx  r14d,bpl
  8f705a:	inc    DWORD PTR [rsp+r14*4+0x1b0]
  8f7062:	shrx   ebp,DWORD PTR [rbx+0x18],eax
  8f7068:	movzx  r14d,bpl
  8f706c:	inc    DWORD PTR [rsp+r14*4+0x1b0]
  8f7074:	shrx   ebp,DWORD PTR [rbx+0x30],eax
  8f707a:	movzx  r14d,bpl
  8f707e:	inc    DWORD PTR [rsp+r14*4+0x1b0]
  8f7086:	shrx   ebp,DWORD PTR [rbx+0x48],eax
  8f708c:	movzx  r14d,bpl
  8f7090:	inc    DWORD PTR [rsp+r14*4+0x1b0]
  8f7098:	shrx   ebp,DWORD PTR [rbx+0x60],eax
  8f709e:	movzx  r14d,bpl
  8f70a2:	inc    DWORD PTR [rsp+r14*4+0x1b0]
  8f70aa:	shrx   ebp,DWORD PTR [rbx+0x78],eax
  8f70b0:	movzx  r14d,bpl
  8f70b4:	inc    DWORD PTR [rsp+r14*4+0x1b0]
  8f70bc:	shrx   ebp,DWORD PTR [rbx+0x90],eax
  8f70c5:	movzx  r14d,bpl
  8f70c9:	inc    DWORD PTR [rsp+r14*4+0x1b0]
  8f70d1:	shrx   ebp,DWORD PTR [rbx+0xa8],eax
  8f70da:	add    rbx,0xc0
  8f70e1:	movzx  r14d,bpl
  8f70e5:	inc    DWORD PTR [rsp+r14*4+0x1b0]
  8f70ed:	cmp    r11,r8
  8f70f0:	jne    8f704d <check_data_plan_object+0x1b3d>
  8f70f6:	test   r10,r10
  8f70f9:	je     8f7127 <check_data_plan_object+0x1c17>
  8f70fb:	lea    r8,[r8+r8*2]
  8f70ff:	shl    r10d,0x3
  8f7103:	xor    r11d,r11d
  8f7106:	lea    r10,[r10+r10*2]
  8f710a:	lea    r8,[rdi+r8*8]
  8f710e:	shrx   ebx,DWORD PTR [r8+r11*1],eax
  8f7114:	add    r11,0x18
  8f7118:	movzx  ebx,bl
  8f711b:	inc    DWORD PTR [rsp+rbx*4+0x1b0]
  8f7122:	cmp    r10,r11
  8f7125:	jne    8f710e <check_data_plan_object+0x1bfe>
  8f7127:	xor    r10d,r10d
  8f712a:	xor    r8d,r8d
  8f712d:	mov    r11d,DWORD PTR [rsp+r8*4+0x1b0]
  8f7135:	mov    DWORD PTR [rsp+r8*4+0x1b0],r10d
  8f713d:	add    r11d,r10d
  8f7140:	mov    r10d,DWORD PTR [rsp+r8*4+0x1b4]
  8f7148:	mov    DWORD PTR [rsp+r8*4+0x1b4],r11d
  8f7150:	mov    ebx,DWORD PTR [rsp+r8*4+0x1b8]
  8f7158:	add    r10d,r11d
  8f715b:	mov    DWORD PTR [rsp+r8*4+0x1b8],r10d
  8f7163:	add    ebx,r10d
  8f7166:	mov    r10d,DWORD PTR [rsp+r8*4+0x1bc]
  8f716e:	mov    DWORD PTR [rsp+r8*4+0x1bc],ebx
  8f7176:	mov    ebp,DWORD PTR [rsp+r8*4+0x1c0]
  8f717e:	add    r10d,ebx
  8f7181:	mov    DWORD PTR [rsp+r8*4+0x1c0],r10d
  8f7189:	add    ebp,r10d
  8f718c:	mov    r10d,DWORD PTR [rsp+r8*4+0x1c4]
  8f7194:	mov    DWORD PTR [rsp+r8*4+0x1c4],ebp
  8f719c:	mov    ebx,DWORD PTR [rsp+r8*4+0x1c8]
  8f71a4:	add    r10d,ebp
  8f71a7:	mov    DWORD PTR [rsp+r8*4+0x1c8],r10d
  8f71af:	add    ebx,r10d
  8f71b2:	mov    r10d,DWORD PTR [rsp+r8*4+0x1cc]
  8f71ba:	mov    DWORD PTR [rsp+r8*4+0x1cc],ebx
  8f71c2:	mov    ebp,DWORD PTR [rsp+r8*4+0x1d0]
  8f71ca:	add    r10d,ebx
  8f71cd:	mov    DWORD PTR [rsp+r8*4+0x1d0],r10d
  8f71d5:	add    ebp,r10d
  8f71d8:	mov    r10d,DWORD PTR [rsp+r8*4+0x1d4]
  8f71e0:	mov    DWORD PTR [rsp+r8*4+0x1d4],ebp
  8f71e8:	mov    ebx,DWORD PTR [rsp+r8*4+0x1d8]
  8f71f0:	add    r10d,ebp
  8f71f3:	mov    DWORD PTR [rsp+r8*4+0x1d8],r10d
  8f71fb:	add    ebx,r10d
  8f71fe:	mov    r10d,DWORD PTR [rsp+r8*4+0x1dc]
  8f7206:	mov    DWORD PTR [rsp+r8*4+0x1dc],ebx
  8f720e:	mov    ebp,DWORD PTR [rsp+r8*4+0x1e0]
  8f7216:	add    r10d,ebx
  8f7219:	mov    DWORD PTR [rsp+r8*4+0x1e0],r10d
  8f7221:	add    ebp,r10d
  8f7224:	mov    r10d,DWORD PTR [rsp+r8*4+0x1e4]
  8f722c:	mov    DWORD PTR [rsp+r8*4+0x1e4],ebp
  8f7234:	mov    ebx,DWORD PTR [rsp+r8*4+0x1e8]
  8f723c:	add    r10d,ebp
  8f723f:	mov    DWORD PTR [rsp+r8*4+0x1e8],r10d
  8f7247:	add    ebx,r10d
  8f724a:	mov    r10d,DWORD PTR [rsp+r8*4+0x1ec]
  8f7252:	mov    DWORD PTR [rsp+r8*4+0x1ec],ebx
  8f725a:	add    r8,0x10
  8f725e:	add    r10d,ebx
  8f7261:	cmp    r8,0x100
  8f7268:	jne    8f712d <check_data_plan_object+0x1c1d>
  8f726e:	mov    r10,rdi
  8f7271:	xor    r11d,r11d
  8f7274:	shrx   r8d,DWORD PTR [r10],eax
  8f7279:	mov    r15,QWORD PTR [r10+0x10]
  8f727d:	inc    r11
  8f7280:	movzx  r8d,r8b
  8f7284:	mov    ebx,DWORD PTR [rsp+r8*4+0x1b0]
  8f728c:	lea    r14,[rbx+rbx*2]
  8f7290:	inc    ebx
  8f7292:	mov    QWORD PTR [rsi+r14*8+0x10],r15
  8f7297:	vmovdqu xmm1,XMMWORD PTR [r10]
  8f729c:	add    r10,0x18
  8f72a0:	vmovdqu XMMWORD PTR [rsi+r14*8],xmm1
  8f72a6:	mov    DWORD PTR [rsp+r8*4+0x1b0],ebx
  8f72ae:	mov    r8d,DWORD PTR [r12+0x18]
  8f72b3:	cmp    r11,r8
  8f72b6:	jb     8f7274 <check_data_plan_object+0x1d64>
  8f72b8:	mov    r15,QWORD PTR [rsp+0x18]
  8f72bd:	cmp    r8d,0x2
  8f72c1:	jb     8f72d5 <check_data_plan_object+0x1dc5>
  8f72c3:	mov    r10,rsi
  8f72c6:	mov    rsi,rdi
  8f72c9:	cmp    eax,0x18
  8f72cc:	lea    eax,[rax+0x8]
  8f72cf:	jb     8f6f75 <check_data_plan_object+0x1a65>
  8f72d5:	mov    eax,DWORD PTR [r12+0x18]
  8f72da:	test   eax,eax
  8f72dc:	je     8f7339 <check_data_plan_object+0x1e29>
  8f72de:	mov    esi,0x8
  8f72e3:	xor    edi,edi
  8f72e5:	mov    r8,QWORD PTR [r12+0x10]
  8f72ea:	mov    eax,DWORD PTR [r8+rsi*1-0x4]
  8f72ef:	mov    r10d,DWORD PTR [rcx+rax*4]
  8f72f3:	mov    eax,0x5
  8f72f8:	test   r10,r10
  8f72fb:	je     8f58d4 <check_data_plan_object+0x3c4>
  8f7301:	cmp    r10d,DWORD PTR [r9+0xb8]
  8f7308:	jae    8f58d4 <check_data_plan_object+0x3c4>
  8f730e:	mov    rax,QWORD PTR [r9+0x88]
  8f7315:	movzx  eax,BYTE PTR [rax+r10*1]
  8f731a:	and    al,0xf
  8f731c:	cmp    al,0x6
  8f731e:	je     8f7781 <check_data_plan_object+0x2271>
  8f7324:	mov    DWORD PTR [r8+rsi*1],r10d
  8f7328:	inc    rdi
  8f732b:	add    rsi,0x18
  8f732f:	mov    eax,DWORD PTR [r12+0x18]
  8f7334:	cmp    rdi,rax
  8f7337:	jb     8f72e5 <check_data_plan_object+0x1dd5>
  8f7339:	mov    rcx,QWORD PTR [r9+0x88]
  8f7340:	mov    esi,DWORD PTR [r12+0x1c]
  8f7345:	movzx  ecx,BYTE PTR [rcx+rsi*1]
  8f7349:	and    cl,0xf
  8f734c:	test   r15,r15
  8f734f:	je     8f7388 <check_data_plan_object+0x1e78>
  8f7351:	test   eax,eax
  8f7353:	setne  r14b
  8f7357:	or     r14b,BYTE PTR [rsp+0x58]
  8f735c:	cmp    cl,0x6
  8f735f:	je     8f737c <check_data_plan_object+0x1e6c>
  8f7361:	test   BYTE PTR [rsp+0xa8],0x1
  8f7369:	je     8f73d8 <check_data_plan_object+0x1ec8>
  8f736b:	test   eax,eax
  8f736d:	mov    ecx,0x1
  8f7372:	mov    eax,0xb
  8f7377:	cmove  eax,ecx
  8f737a:	jmp    8f73df <check_data_plan_object+0x1ecf>
  8f737c:	mov    ecx,r14d
  8f737f:	mov    al,0x8
  8f7381:	and    cl,0x1
  8f7384:	sub    al,cl
  8f7386:	jmp    8f73df <check_data_plan_object+0x1ecf>
  8f7388:	cmp    cl,0x6
  8f738b:	setne  sil
  8f738f:	test   eax,eax
  8f7391:	jne    8f7351 <check_data_plan_object+0x1e41>
  8f7393:	cmp    BYTE PTR [rdx+0x28],0x0
  8f7397:	jne    8f7351 <check_data_plan_object+0x1e41>
  8f7399:	and    sil,BYTE PTR [rsp+0xa8]
  8f73a1:	jne    8f7351 <check_data_plan_object+0x1e41>
  8f73a3:	mov    rsi,QWORD PTR [r12]
  8f73a7:	mov    r14,QWORD PTR [rsp+0x58]
  8f73ac:	test   rsi,rsi
  8f73af:	sete   dil
  8f73b3:	or     dil,r14b
  8f73b6:	test   dil,0x1
  8f73ba:	jne    8f735c <check_data_plan_object+0x1e4c>
  8f73bc:	mov    r8,QWORD PTR [r12+0x8]
  8f73c1:	cmp    r8,0x40
  8f73c5:	jae    8f7823 <check_data_plan_object+0x2313>
  8f73cb:	xor    edi,edi
  8f73cd:	xor    r14d,r14d
  8f73d0:	mov    r9,r8
  8f73d3:	jmp    8f7862 <check_data_plan_object+0x2352>
  8f73d8:	mov    eax,r14d
  8f73db:	and    al,0x1
  8f73dd:	xor    al,0xd
  8f73df:	mov    BYTE PTR [r12+0x21],al
  8f73e4:	cmp    BYTE PTR [rdx+0x28],0x1
  8f73e8:	jne    8f7433 <check_data_plan_object+0x1f23>
  8f73ea:	mov    rcx,QWORD PTR [rsp+0x30]
  8f73ef:	mov    rax,QWORD PTR [rsp+0xa8]
  8f73f7:	mov    rdx,QWORD PTR [rcx+0x20]
  8f73fb:	shr    eax,0x3
  8f73fe:	mov    rsi,QWORD PTR [rcx]
  8f7401:	mov    rcx,QWORD PTR [rcx+0x38]
  8f7405:	mov    eax,DWORD PTR [rdx+rax*4]
  8f7408:	shr    eax,0x3
  8f740b:	cmp    BYTE PTR [rsi+rax*1],0xf
  8f740f:	jne    8f7417 <check_data_plan_object+0x1f07>
  8f7411:	mov    eax,DWORD PTR [rdx+rax*4]
  8f7414:	shr    eax,0x3
  8f7417:	cmp    QWORD PTR [rcx+rax*8],0x1
  8f741c:	mov    r12,QWORD PTR [rsp+0x600]
  8f7424:	mov    r15,QWORD PTR [rsp+0x18]
  8f7429:	sete   al
  8f742c:	inc    al
  8f742e:	mov    BYTE PTR [r12+0x21],al
  8f7433:	mov    rcx,QWORD PTR [rsp+0xc0]
  8f743b:	cmp    al,0xd
  8f743d:	je     8f7447 <check_data_plan_object+0x1f37>
  8f743f:	movzx  eax,al
  8f7442:	cmp    eax,0x8
  8f7445:	jne    8f7467 <check_data_plan_object+0x1f57>
  8f7447:	mov    rax,QWORD PTR [rsp+0x5f0]
  8f744f:	cmp    rcx,QWORD PTR [rax+0x8]
  8f7453:	ja     8f7eb4 <check_data_plan_object+0x29a4>
  8f7459:	mov    QWORD PTR [rax+0x8],rcx
  8f745d:	mov    QWORD PTR [r12],0x0
  8f7465:	jmp    8f746e <check_data_plan_object+0x1f5e>
  8f7467:	cmp    QWORD PTR [r12],0x0
  8f746c:	je     8f74be <check_data_plan_object+0x1fae>
  8f746e:	cmp    QWORD PTR [r12+0x8],0x0
  8f7474:	jne    8f747e <check_data_plan_object+0x1f6e>
  8f7476:	mov    QWORD PTR [r12],0x0
  8f747e:	test   r15,r15
  8f7481:	sete   cl
  8f7484:	xor    eax,eax
  8f7486:	or     cl,r14b
  8f7489:	test   cl,0x1
  8f748c:	jne    8f58d4 <check_data_plan_object+0x3c4>
  8f7492:	mov    rcx,QWORD PTR [rsp+0x5f8]
  8f749a:	mov    rdx,QWORD PTR [rsp+0xc8]
  8f74a2:	mov    QWORD PTR [r12+0x10],0x0
  8f74ab:	cmp    rdx,QWORD PTR [rcx+0x8]
  8f74af:	ja     8f7eb4 <check_data_plan_object+0x29a4>
  8f74b5:	mov    QWORD PTR [rcx+0x8],rdx
  8f74b9:	jmp    8f58d4 <check_data_plan_object+0x3c4>
  8f74be:	mov    rax,QWORD PTR [r12+0x8]
  8f74c3:	test   rax,rax
  8f74c6:	je     8f746e <check_data_plan_object+0x1f5e>
  8f74c8:	mov    rcx,QWORD PTR [rsp+0x5f0]
  8f74d0:	mov    rdi,QWORD PTR [rcx+0x8]
  8f74d4:	mov    rcx,QWORD PTR [rcx+0x10]
  8f74d8:	sub    rcx,rdi
  8f74db:	setb   dl
  8f74de:	cmp    rax,rcx
  8f74e1:	seta   cl
  8f74e4:	or     cl,dl
  8f74e6:	jne    8f746e <check_data_plan_object+0x1f5e>
  8f74e8:	mov    rcx,QWORD PTR [rsp+0x5f0]
  8f74f0:	add    rax,rdi
  8f74f3:	add    rdi,QWORD PTR [rcx]
  8f74f6:	mov    QWORD PTR [rcx+0x8],rax
  8f74fa:	mov    QWORD PTR [r12],rdi
  8f74fe:	je     8f746e <check_data_plan_object+0x1f5e>
  8f7504:	mov    rdx,QWORD PTR [r12+0x8]
  8f7509:	xor    esi,esi
  8f750b:	vzeroupper
  8f750e:	call   7dfb20 <memset@plt>
  8f7513:	jmp    8f746e <check_data_plan_object+0x1f5e>
  8f7518:	mov    rcx,QWORD PTR [rsp+0x5f8]
  8f7520:	add    rax,rdi
  8f7523:	mov    QWORD PTR [rcx+0x8],rax
  8f7527:	mov    rax,QWORD PTR [rsp+0x600]
  8f752f:	add    rdi,QWORD PTR [rcx]
  8f7532:	mov    QWORD PTR [rax],rdi
  8f7535:	je     8f792c <check_data_plan_object+0x241c>
  8f753b:	mov    rdx,QWORD PTR [rax+0x8]
  8f753f:	lea    rsi,[rsp+0x1b0]
  8f7547:	call   7dfc50 <memcpy@plt>
  8f754c:	mov    ecx,DWORD PTR [rsp+0x1d4]
  8f7553:	xor    eax,eax
  8f7555:	test   ecx,ecx
  8f7557:	je     8f778b <check_data_plan_object+0x227b>
  8f755d:	mov    rdx,QWORD PTR [rsp+0x5f8]
  8f7565:	mov    rdi,QWORD PTR [rdx]
  8f7568:	mov    rsi,QWORD PTR [rdx+0x8]
  8f756c:	lea    rdx,[rsi+rdi*1+0x7]
  8f7571:	add    rsi,rdi
  8f7574:	and    rdx,0xfffffffffffffff8
  8f7578:	cmp    rdx,rsi
  8f757b:	jb     8f75ab <check_data_plan_object+0x209b>
  8f757d:	mov    rsi,rdx
  8f7580:	sub    rsi,rdi
  8f7583:	mov    rdi,QWORD PTR [rsp+0x5f8]
  8f758b:	mov    rdi,QWORD PTR [rdi+0x10]
  8f758f:	sub    rdi,rsi
  8f7592:	setb   r8b
  8f7596:	cmp    rdi,0x18
  8f759a:	setb   dil
  8f759e:	or     dil,r8b
  8f75a1:	cmp    dil,0x1
  8f75a5:	jne    8f78d8 <check_data_plan_object+0x23c8>
  8f75ab:	mov    r12,QWORD PTR [rsp+0x600]
  8f75b3:	mov    eax,0x6
  8f75b8:	mov    QWORD PTR [r12+0x10],0x0
  8f75c1:	jmp    8f5a60 <check_data_plan_object+0x550>
  8f75c6:	mov    rsi,QWORD PTR [rsp+0x5f8]
  8f75ce:	add    rdx,rcx
  8f75d1:	mov    QWORD PTR [rsi+0x8],rdx
  8f75d5:	mov    rcx,QWORD PTR [rsp+0x600]
  8f75dd:	lea    rdx,[rcx+0x10]
  8f75e1:	mov    QWORD PTR [rcx+0x10],rax
  8f75e5:	mov    QWORD PTR [rsp+0x90],rdx
  8f75ed:	mov    rax,QWORD PTR [rsp+0x5f0]
  8f75f5:	mov    rdx,QWORD PTR [rcx+0x8]
  8f75f9:	mov    rcx,QWORD PTR [rax+0x8]
  8f75fd:	mov    r15,QWORD PTR [rax+0x10]
  8f7601:	mov    QWORD PTR [rsp+0x88],rdx
  8f7609:	mov    rax,r15
  8f760c:	sub    rax,rcx
  8f760f:	cmp    rdx,rax
  8f7612:	ja     8f76a0 <check_data_plan_object+0x2190>
  8f7618:	mov    rdi,QWORD PTR [rsp+0x30]
  8f761d:	mov    rsi,QWORD PTR [rsp+0x18]
  8f7622:	mov    rdx,QWORD PTR [rsp+0x88]
  8f762a:	mov    r12,rcx
  8f762d:	call   8f7f10 <check_data_initializer_witness>
  8f7632:	test   al,al
  8f7634:	je     8f76a0 <check_data_plan_object+0x2190>
  8f7636:	cmp    r15,r12
  8f7639:	jb     8f7ed6 <check_data_plan_object+0x29c6>
  8f763f:	mov    rcx,QWORD PTR [rsp+0x88]
  8f7647:	mov    rax,QWORD PTR [rsp+0x5f0]
  8f764f:	add    rcx,r12
  8f7652:	add    r12,QWORD PTR [rax]
  8f7655:	mov    QWORD PTR [rax+0x8],rcx
  8f7659:	mov    rax,QWORD PTR [rsp+0x600]
  8f7661:	mov    QWORD PTR [rax],r12
  8f7664:	je     8f7ee5 <check_data_plan_object+0x29d5>
  8f766a:	mov    rdx,QWORD PTR [rax+0x8]
  8f766e:	mov    rdi,r12
  8f7671:	xor    esi,esi
  8f7673:	xor    r15d,r15d
  8f7676:	call   7dfb20 <memset@plt>
  8f767b:	mov    al,0x1
  8f767d:	mov    QWORD PTR [rsp+0x70],0x0
  8f7686:	mov    QWORD PTR [rsp+0x78],0x0
  8f768f:	mov    QWORD PTR [rsp+0x38],rax
  8f7694:	mov    al,0x1
  8f7696:	mov    QWORD PTR [rsp+0x58],rax
  8f769b:	jmp    8f795c <check_data_plan_object+0x244c>
  8f76a0:	cmp    DWORD PTR [rsp+0x28],0x0
  8f76a5:	je     8f76fd <check_data_plan_object+0x21ed>
  8f76a7:	mov    eax,DWORD PTR [rsp+0x40]
  8f76ab:	mov    bpl,0x1
  8f76ae:	mov    QWORD PTR [rsp+0x78],0x0
  8f76b7:	mov    QWORD PTR [rsp+0x70],0x0
  8f76c0:	mov    QWORD PTR [rsp+0x38],0x0
  8f76c9:	mov    QWORD PTR [rsp+0x58],0x0
  8f76d2:	mov    rdi,QWORD PTR [rsp+0x30]
  8f76d7:	mov    rdx,QWORD PTR [rsp+0x68]
  8f76dc:	mov    r9,QWORD PTR [rsp+0x48]
  8f76e1:	mov    rcx,QWORD PTR [rsp+0x50]
  8f76e6:	mov    r8d,DWORD PTR [rsp+0x64]
  8f76eb:	mov    r15,QWORD PTR [rsp+0x18]
  8f76f0:	mov    r12,QWORD PTR [rsp+0x600]
  8f76f8:	jmp    8f5a78 <check_data_plan_object+0x568>
  8f76fd:	mov    rax,QWORD PTR [rsp+0x18]
  8f7702:	mov    ecx,DWORD PTR [rax+0x18]
  8f7705:	test   rcx,rcx
  8f7708:	je     8f78ad <check_data_plan_object+0x239d>
  8f770e:	mov    rax,QWORD PTR [rsp+0x18]
  8f7713:	imul   rcx,rcx,0xb0
  8f771a:	mov    QWORD PTR [rsp+0x70],0x0
  8f7723:	xor    edx,edx
  8f7725:	mov    rax,QWORD PTR [rax+0x10]
  8f7729:	jmp    8f7758 <check_data_plan_object+0x2248>
  8f772b:	mov    rdi,QWORD PTR [rdi+0x38]
  8f772f:	mov    rsi,QWORD PTR [rdi+rsi*8]
  8f7733:	cmp    rsi,0x20
  8f7737:	ja     8f7781 <check_data_plan_object+0x2271>
  8f7739:	mov    rdi,QWORD PTR [rsp+0x70]
  8f773e:	mov    edi,edi
  8f7740:	cmp    rsi,rdi
  8f7743:	cmova  rdi,rsi
  8f7747:	mov    QWORD PTR [rsp+0x70],rdi
  8f774c:	add    rdx,0xb0
  8f7753:	cmp    rcx,rdx
  8f7756:	je     8f7798 <check_data_plan_object+0x2288>
  8f7758:	cmp    DWORD PTR [rax+rdx*1],0x0
  8f775c:	jne    8f774c <check_data_plan_object+0x223c>
  8f775e:	mov    rdi,QWORD PTR [rsp+0x30]
  8f7763:	mov    esi,DWORD PTR [rax+rdx*1+0x4]
  8f7767:	mov    r8,QWORD PTR [rdi]
  8f776a:	shr    esi,0x3
  8f776d:	cmp    BYTE PTR [r8+rsi*1],0xf
  8f7772:	jne    8f772b <check_data_plan_object+0x221b>
  8f7774:	mov    r8,QWORD PTR [rdi+0x20]
  8f7778:	mov    esi,DWORD PTR [r8+rsi*4]
  8f777c:	shr    esi,0x3
  8f777f:	jmp    8f772b <check_data_plan_object+0x221b>
  8f7781:	mov    eax,0x3
  8f7786:	jmp    8f58d4 <check_data_plan_object+0x3c4>
  8f778b:	mov    r12,QWORD PTR [rsp+0x600]
  8f7793:	jmp    8f5a60 <check_data_plan_object+0x550>
  8f7798:	cmp    DWORD PTR [rsp+0x70],0x0
  8f779d:	je     8f793e <check_data_plan_object+0x242e>
  8f77a3:	mov    rcx,QWORD PTR [rsp+0x5f8]
  8f77ab:	mov    edx,0x0
  8f77b0:	mov    r15b,0x1
  8f77b3:	mov    QWORD PTR [rsp+0x78],0x0
  8f77bc:	mov    QWORD PTR [rsp+0x58],rdx
  8f77c1:	mov    edx,0x0
  8f77c6:	mov    QWORD PTR [rsp+0x38],rdx
  8f77cb:	mov    rax,QWORD PTR [rcx+0x8]
  8f77cf:	mov    rcx,QWORD PTR [rcx+0x10]
  8f77d3:	sub    rcx,rax
  8f77d6:	jb     8f795c <check_data_plan_object+0x244c>
  8f77dc:	mov    rdx,QWORD PTR [rsp+0x18]
  8f77e1:	mov    esi,DWORD PTR [rdx+0x18]
  8f77e4:	mov    edx,DWORD PTR [rsp+0x70]
  8f77e8:	imul   rdx,rsi
  8f77ec:	cmp    rdx,rcx
  8f77ef:	ja     8f795c <check_data_plan_object+0x244c>
  8f77f5:	mov    rcx,QWORD PTR [rsp+0x5f8]
  8f77fd:	add    rdx,rax
  8f7800:	mov    QWORD PTR [rsp+0x38],0x0
  8f7809:	mov    QWORD PTR [rsp+0x58],0x0
  8f7812:	add    rax,QWORD PTR [rcx]
  8f7815:	mov    QWORD PTR [rcx+0x8],rdx
  8f7819:	mov    QWORD PTR [rsp+0x78],rax
  8f781e:	jmp    8f795c <check_data_plan_object+0x244c>
  8f7823:	mov    r9,0xffffffffffffffc0
  8f782a:	xor    edi,edi
  8f782c:	vmovdqu64 zmm0,ZMMWORD PTR [rsi+rdi*1]
  8f7833:	lea    r10,[r8+r9*1]
  8f7837:	vptestmq k0,zmm0,zmm0
  8f783d:	kortestb k0,k0
  8f7841:	setne  r14b
  8f7845:	add    rdi,0x40
  8f7849:	cmp    r10,0x40
  8f784d:	jb     8f785c <check_data_plan_object+0x234c>
  8f784f:	kmovd  r10d,k0
  8f7853:	add    r9,0xffffffffffffffc0
  8f7857:	test   r10b,r10b
  8f785a:	je     8f782c <check_data_plan_object+0x231c>
  8f785c:	mov    r9,r8
  8f785f:	sub    r9,rdi
  8f7862:	mov    r15,QWORD PTR [rsp+0x18]
  8f7867:	mov    r12,QWORD PTR [rsp+0x600]
  8f786f:	cmp    rdi,r8
  8f7872:	sete   r8b
  8f7876:	or     r8b,r14b
  8f7879:	jne    8f735c <check_data_plan_object+0x1e4c>
  8f787f:	mov    r8,0xffffffffffffffff
  8f7886:	shlx   r8,r8,r9
  8f788b:	not    r8
  8f788e:	kmovq  k1,r8
  8f7893:	vmovdqu8 zmm0{k1}{z},ZMMWORD PTR [rsi+rdi*1]
  8f789a:	vptestmd k0,zmm0,zmm0
  8f78a0:	kortestw k0,k0
  8f78a4:	setne  r14b
  8f78a8:	jmp    8f735c <check_data_plan_object+0x1e4c>
  8f78ad:	xor    r15d,r15d
  8f78b0:	mov    QWORD PTR [rsp+0x70],0x0
  8f78b9:	jmp    8f7941 <check_data_plan_object+0x2431>
  8f78be:	mov    QWORD PTR [rsp+0x20],0x0
  8f78c7:	xor    edx,edx
  8f78c9:	xor    ecx,ecx
  8f78cb:	vzeroupper
  8f78ce:	call   8faa60 <check_data_sort_boundaries>
  8f78d3:	jmp    8f7b2e <check_data_plan_object+0x261e>
  8f78d8:	mov    rdi,QWORD PTR [rsp+0x5f8]
  8f78e0:	add    rsi,0x18
  8f78e4:	mov    QWORD PTR [rdi+0x8],rsi
  8f78e8:	mov    rdi,QWORD PTR [rsp+0x600]
  8f78f0:	mov    QWORD PTR [rdi+0x10],rdx
  8f78f4:	test   rdx,rdx
  8f78f7:	je     8f792c <check_data_plan_object+0x241c>
  8f78f9:	vmovd  xmm0,ecx
  8f78fd:	vpshufb xmm0,xmm0,XMMWORD PTR [rip+0xffffffffffcb0e6a]        # 5a8770 <abi_test_hex.digits+0x1c70>
  8f7906:	mov    rsi,QWORD PTR [rsp+0x1d8]
  8f790e:	mov    r12,QWORD PTR [rsp+0x600]
  8f7916:	vmovdqu XMMWORD PTR [rdx],xmm0
  8f791a:	mov    QWORD PTR [rdx+0x10],rsi
  8f791e:	mov    DWORD PTR [r12+0x18],0x1
  8f7927:	jmp    8f5a60 <check_data_plan_object+0x550>
  8f792c:	mov    r12,QWORD PTR [rsp+0x600]
  8f7934:	mov    eax,0x6
  8f7939:	jmp    8f5a60 <check_data_plan_object+0x550>
  8f793e:	xor    r15d,r15d
  8f7941:	mov    QWORD PTR [rsp+0x38],0x0
  8f794a:	mov    QWORD PTR [rsp+0x58],0x0
  8f7953:	mov    QWORD PTR [rsp+0x78],0x0
  8f795c:	cmp    QWORD PTR [rsp+0x20],0x0
  8f7962:	je     8f7989 <check_data_plan_object+0x2479>
  8f7964:	cmp    QWORD PTR [rsp+0x78],0x0
  8f796a:	mov    rax,QWORD PTR [rsp+0x90]
  8f7972:	sete   cl
  8f7975:	cmp    QWORD PTR [rax],0x0
  8f7979:	mov    eax,0x6
  8f797e:	je     8f58d4 <check_data_plan_object+0x3c4>
  8f7984:	and    r15b,cl
  8f7987:	jmp    8f799a <check_data_plan_object+0x248a>
  8f7989:	cmp    QWORD PTR [rsp+0x78],0x0
  8f798f:	mov    eax,0x6
  8f7994:	sete   cl
  8f7997:	test   r15b,cl
  8f799a:	mov    rcx,QWORD PTR [rsp+0x68]
  8f799f:	jne    8f58d4 <check_data_plan_object+0x3c4>
  8f79a5:	cmp    BYTE PTR [rcx+0x28],0x0
  8f79a9:	mov    eax,0x1
  8f79ae:	je     8f79d1 <check_data_plan_object+0x24c1>
  8f79b0:	mov    rdx,QWORD PTR [rsp+0x68]
  8f79b5:	mov    r9,QWORD PTR [rsp+0x48]
  8f79ba:	mov    rcx,QWORD PTR [rsp+0x50]
  8f79bf:	mov    r15,QWORD PTR [rsp+0x18]
  8f79c4:	mov    r12,QWORD PTR [rsp+0x600]
  8f79cc:	jmp    8f64d1 <check_data_plan_object+0xfc1>
  8f79d1:	mov    rdi,QWORD PTR [rsp+0x30]
  8f79d6:	mov    rdx,QWORD PTR [rsp+0x68]
  8f79db:	mov    r9,QWORD PTR [rsp+0x48]
  8f79e0:	mov    rcx,QWORD PTR [rsp+0x50]
  8f79e5:	mov    r8d,DWORD PTR [rsp+0x64]
  8f79ea:	mov    rsi,QWORD PTR [rsp+0x98]
  8f79f2:	mov    r15,QWORD PTR [rsp+0x18]
  8f79f7:	mov    r12,QWORD PTR [rsp+0x600]
  8f79ff:	xor    eax,eax
  8f7a01:	test   r15,r15
  8f7a04:	jne    8f5a76 <check_data_plan_object+0x566>
  8f7a0a:	jmp    8f5a24 <check_data_plan_object+0x514>
  8f7a0f:	mov    edx,r12d
  8f7a12:	and    r12d,0xfffffffc
  8f7a16:	xor    ecx,ecx
  8f7a18:	mov    QWORD PTR [rsp+0x20],0x0
  8f7a21:	jmp    8f7a48 <check_data_plan_object+0x2538>
  8f7a23:	mov    rsi,QWORD PTR [rax+rcx*8+0x18]
  8f7a28:	mov    edi,r8d
  8f7a2b:	mov    QWORD PTR [rax+rdi*8],rsi
  8f7a2f:	mov    DWORD PTR [r14+rdi*4],r8d
  8f7a33:	inc    r8d
  8f7a36:	add    rcx,0x4
  8f7a3a:	mov    QWORD PTR [rsp+0x20],r8
  8f7a3f:	cmp    r12,rcx
  8f7a42:	je     8f7ae7 <check_data_plan_object+0x25d7>
  8f7a48:	mov    r8,QWORD PTR [rsp+0x20]
  8f7a4d:	test   r8d,r8d
  8f7a50:	je     8f7a62 <check_data_plan_object+0x2552>
  8f7a52:	mov    rsi,QWORD PTR [rax+rcx*8]
  8f7a56:	lea    edi,[r8-0x1]
  8f7a5a:	cmp    QWORD PTR [rax+rdi*8],rsi
  8f7a5e:	jne    8f7a66 <check_data_plan_object+0x2556>
  8f7a60:	jmp    8f7a74 <check_data_plan_object+0x2564>
  8f7a62:	mov    rsi,QWORD PTR [rax+rcx*8]
  8f7a66:	mov    edi,r8d
  8f7a69:	mov    QWORD PTR [rax+rdi*8],rsi
  8f7a6d:	mov    DWORD PTR [r14+rdi*4],r8d
  8f7a71:	inc    r8d
  8f7a74:	test   r8d,r8d
  8f7a77:	je     8f7a8a <check_data_plan_object+0x257a>
  8f7a79:	mov    rsi,QWORD PTR [rax+rcx*8+0x8]
  8f7a7e:	lea    edi,[r8-0x1]
  8f7a82:	cmp    QWORD PTR [rax+rdi*8],rsi
  8f7a86:	jne    8f7a8f <check_data_plan_object+0x257f>
  8f7a88:	jmp    8f7a9d <check_data_plan_object+0x258d>
  8f7a8a:	mov    rsi,QWORD PTR [rax+rcx*8+0x8]
  8f7a8f:	mov    edi,r8d
  8f7a92:	mov    QWORD PTR [rax+rdi*8],rsi
  8f7a96:	mov    DWORD PTR [r14+rdi*4],r8d
  8f7a9a:	inc    r8d
  8f7a9d:	test   r8d,r8d
  8f7aa0:	je     8f7ab3 <check_data_plan_object+0x25a3>
  8f7aa2:	mov    rsi,QWORD PTR [rax+rcx*8+0x10]
  8f7aa7:	lea    edi,[r8-0x1]
  8f7aab:	cmp    QWORD PTR [rax+rdi*8],rsi
  8f7aaf:	jne    8f7ab8 <check_data_plan_object+0x25a8>
  8f7ab1:	jmp    8f7ac6 <check_data_plan_object+0x25b6>
  8f7ab3:	mov    rsi,QWORD PTR [rax+rcx*8+0x10]
  8f7ab8:	mov    edi,r8d
  8f7abb:	mov    QWORD PTR [rax+rdi*8],rsi
  8f7abf:	mov    DWORD PTR [r14+rdi*4],r8d
  8f7ac3:	inc    r8d
  8f7ac6:	test   r8d,r8d
  8f7ac9:	je     8f7a23 <check_data_plan_object+0x2513>
  8f7acf:	mov    rsi,QWORD PTR [rax+rcx*8+0x18]
  8f7ad4:	lea    edi,[r8-0x1]
  8f7ad8:	cmp    QWORD PTR [rax+rdi*8],rsi
  8f7adc:	jne    8f7a28 <check_data_plan_object+0x2518>
  8f7ae2:	jmp    8f7a36 <check_data_plan_object+0x2526>
  8f7ae7:	test   dl,0x2
  8f7aea:	je     8f7b2e <check_data_plan_object+0x261e>
  8f7aec:	mov    r8,QWORD PTR [rsp+0x20]
  8f7af1:	lea    rcx,[rax+rcx*8]
  8f7af5:	xor    edx,edx
  8f7af7:	jmp    8f7b14 <check_data_plan_object+0x2604>
  8f7af9:	mov    rsi,QWORD PTR [rcx+rdx*8]
  8f7afd:	mov    edi,r8d
  8f7b00:	mov    QWORD PTR [rax+rdi*8],rsi
  8f7b04:	mov    DWORD PTR [r14+rdi*4],r8d
  8f7b08:	inc    r8d
  8f7b0b:	inc    rdx
  8f7b0e:	cmp    rdx,0x2
  8f7b12:	je     8f7b29 <check_data_plan_object+0x2619>
  8f7b14:	test   r8d,r8d
  8f7b17:	je     8f7af9 <check_data_plan_object+0x25e9>
  8f7b19:	mov    rsi,QWORD PTR [rcx+rdx*8]
  8f7b1d:	lea    edi,[r8-0x1]
  8f7b21:	cmp    QWORD PTR [rax+rdi*8],rsi
  8f7b25:	jne    8f7afd <check_data_plan_object+0x25ed>
  8f7b27:	jmp    8f7b0b <check_data_plan_object+0x25fb>
  8f7b29:	mov    QWORD PTR [rsp+0x20],r8
  8f7b2e:	mov    rcx,QWORD PTR [rsp+0x98]
  8f7b36:	mov    ecx,DWORD PTR [rcx]
  8f7b38:	test   rcx,rcx
  8f7b3b:	je     8f7e5c <check_data_plan_object+0x294c>
  8f7b41:	mov    rbx,rcx
  8f7b44:	mov    ecx,DWORD PTR [rsp+0x70]
  8f7b48:	mov    r9,QWORD PTR [rsp+0x30]
  8f7b4d:	mov    r15,QWORD PTR [rsp+0x18]
  8f7b52:	mov    r12,QWORD PTR [rsp+0x20]
  8f7b57:	xor    edi,edi
  8f7b59:	mov    QWORD PTR [rsp+0x88],rcx
  8f7b61:	mov    r8,QWORD PTR [r15+0x10]
  8f7b65:	dec    rbx
  8f7b68:	imul   rdx,rbx,0xb0
  8f7b6f:	mov    ecx,DWORD PTR [r8+rdx*1+0x4]
  8f7b74:	shr    ecx,0x3
  8f7b77:	je     8f7e92 <check_data_plan_object+0x2982>
  8f7b7d:	cmp    ecx,DWORD PTR [r9+0x48]
  8f7b81:	jae    8f7e92 <check_data_plan_object+0x2982>
  8f7b87:	mov    rsi,QWORD PTR [r9]
  8f7b8a:	movzx  esi,BYTE PTR [rsi+rcx*1]
  8f7b8e:	test   sil,sil
  8f7b91:	je     8f7e92 <check_data_plan_object+0x2982>
  8f7b97:	add    r8,rdx
  8f7b9a:	mov    edx,DWORD PTR [r8]
  8f7b9d:	cmp    edx,0x2
  8f7ba0:	ja     8f7e92 <check_data_plan_object+0x2982>
  8f7ba6:	test   edx,edx
  8f7ba8:	je     8f7bb0 <check_data_plan_object+0x26a0>
  8f7baa:	lea    rdx,[r8+0x30]
  8f7bae:	jmp    8f7bd2 <check_data_plan_object+0x26c2>
  8f7bb0:	cmp    sil,0xf
  8f7bb4:	jne    8f7bc0 <check_data_plan_object+0x26b0>
  8f7bb6:	mov    rdx,QWORD PTR [r9+0x20]
  8f7bba:	mov    ecx,DWORD PTR [rdx+rcx*4]
  8f7bbd:	shr    ecx,0x3
  8f7bc0:	mov    rdx,QWORD PTR [r9+0x38]
  8f7bc4:	mov    r15,QWORD PTR [rsp+0x18]
  8f7bc9:	mov    r12,QWORD PTR [rsp+0x20]
  8f7bce:	lea    rdx,[rdx+rcx*8]
  8f7bd2:	mov    ecx,DWORD PTR [r8+0x20]
  8f7bd6:	test   rcx,rcx
  8f7bd9:	jne    8f7bf5 <check_data_plan_object+0x26e5>
  8f7bdb:	mov    rcx,QWORD PTR [rdx]
  8f7bde:	movabs rdx,0x1fffffffffffffff
  8f7be8:	cmp    rcx,rdx
  8f7beb:	ja     8f7e92 <check_data_plan_object+0x2982>
  8f7bf1:	shl    rcx,0x3
  8f7bf5:	mov    rsi,QWORD PTR [r8+0x18]
  8f7bf9:	add    rcx,rsi
  8f7bfc:	jb     8f7e92 <check_data_plan_object+0x2982>
  8f7c02:	test   r12d,r12d
  8f7c05:	je     8f7c64 <check_data_plan_object+0x2754>
  8f7c07:	mov    r11,rdi
  8f7c0a:	xor    edx,edx
  8f7c0c:	mov    edi,r12d
  8f7c0f:	jmp    8f7c18 <check_data_plan_object+0x2708>
  8f7c11:	mov    edi,r10d
  8f7c14:	cmp    edx,edi
  8f7c16:	jae    8f7c34 <check_data_plan_object+0x2724>
  8f7c18:	mov    r9d,edi
  8f7c1b:	sub    r9d,edx
  8f7c1e:	shr    r9d,1
  8f7c21:	lea    r10d,[r9+rdx*1]
  8f7c25:	cmp    QWORD PTR [rax+r10*8],rsi
  8f7c29:	jae    8f7c11 <check_data_plan_object+0x2701>
  8f7c2b:	lea    edx,[r9+rdx*1+0x1]
  8f7c30:	cmp    edx,edi
  8f7c32:	jb     8f7c18 <check_data_plan_object+0x2708>
  8f7c34:	xor    r9d,r9d
  8f7c37:	mov    esi,r12d
  8f7c3a:	jmp    8f7c44 <check_data_plan_object+0x2734>
  8f7c3c:	mov    esi,r10d
  8f7c3f:	cmp    r9d,esi
  8f7c42:	jae    8f7c5f <check_data_plan_object+0x274f>
  8f7c44:	mov    edi,esi
  8f7c46:	sub    edi,r9d
  8f7c49:	shr    edi,1
  8f7c4b:	lea    r10d,[rdi+r9*1]
  8f7c4f:	cmp    QWORD PTR [rax+r10*8],rcx
  8f7c53:	jae    8f7c3c <check_data_plan_object+0x272c>
  8f7c55:	lea    r9d,[rdi+r9*1+0x1]
  8f7c5a:	cmp    r9d,esi
  8f7c5d:	jb     8f7c44 <check_data_plan_object+0x2734>
  8f7c5f:	mov    rdi,r11
  8f7c62:	jmp    8f7c69 <check_data_plan_object+0x2759>
  8f7c64:	xor    edx,edx
  8f7c66:	xor    r9d,r9d
  8f7c69:	mov    ecx,edx
  8f7c6b:	mov    r10d,ecx
  8f7c6e:	mov    ecx,ecx
  8f7c70:	mov    ecx,DWORD PTR [r14+rcx*4]
  8f7c74:	cmp    ecx,r10d
  8f7c77:	jne    8f7c6b <check_data_plan_object+0x275b>
  8f7c79:	mov    esi,edx
  8f7c7b:	mov    ecx,DWORD PTR [r14+rsi*4]
  8f7c7f:	cmp    ecx,edx
  8f7c81:	jne    8f7c87 <check_data_plan_object+0x2777>
  8f7c83:	xor    ecx,ecx
  8f7c85:	jmp    8f7ca0 <check_data_plan_object+0x2790>
  8f7c87:	lea    rdx,[r14+rsi*4]
  8f7c8b:	mov    DWORD PTR [rdx],r10d
  8f7c8e:	mov    esi,ecx
  8f7c90:	lea    rdx,[r14+rsi*4]
  8f7c94:	mov    esi,DWORD PTR [r14+rsi*4]
  8f7c98:	cmp    esi,ecx
  8f7c9a:	mov    ecx,esi
  8f7c9c:	jne    8f7c8b <check_data_plan_object+0x277b>
  8f7c9e:	mov    ecx,edi
  8f7ca0:	mov    QWORD PTR [rsp+0x28],rbx
  8f7ca5:	cmp    r10d,r9d
  8f7ca8:	jae    8f7e21 <check_data_plan_object+0x2911>
  8f7cae:	test   cl,0x1
  8f7cb1:	jne    8f7e21 <check_data_plan_object+0x2911>
  8f7cb7:	mov    r12,rbx
  8f7cba:	imul   r12,QWORD PTR [rsp+0x88]
  8f7cc3:	mov    edx,edi
  8f7cc5:	add    r12,QWORD PTR [rsp+0x78]
  8f7cca:	mov    ecx,DWORD PTR [r8]
  8f7ccd:	mov    r13d,r10d
  8f7cd0:	cmp    ecx,0x1
  8f7cd3:	je     8f7ce7 <check_data_plan_object+0x27d7>
  8f7cd5:	mov    rbp,r12
  8f7cd8:	cmp    ecx,0x2
  8f7cdb:	jne    8f7ceb <check_data_plan_object+0x27db>
  8f7cdd:	inc    r10d
  8f7ce0:	mov    ecx,edx
  8f7ce2:	jmp    8f7dd2 <check_data_plan_object+0x28c2>
  8f7ce7:	mov    rbp,QWORD PTR [r8+0x28]
  8f7ceb:	mov    rcx,QWORD PTR [r8+0x18]
  8f7cef:	mov    rsi,QWORD PTR [rax+r13*8]
  8f7cf3:	mov    r11,QWORD PTR [rax+r13*8+0x8]
  8f7cf8:	sub    r11,rcx
  8f7cfb:	sub    rsi,rcx
  8f7cfe:	mov    rdx,r11
  8f7d01:	sub    rdx,rsi
  8f7d04:	jbe    8f7d39 <check_data_plan_object+0x2829>
  8f7d06:	mov    rcx,rsi
  8f7d09:	and    rcx,0x7
  8f7d0d:	je     8f7d39 <check_data_plan_object+0x2829>
  8f7d0f:	mov    edi,0x8
  8f7d14:	sub    rdi,rcx
  8f7d17:	cmp    rdx,rdi
  8f7d1a:	cmovb  rdi,rdx
  8f7d1e:	mov    rdx,rsi
  8f7d21:	shr    rdx,0x3
  8f7d25:	movzx  edx,BYTE PTR [rbp+rdx*1+0x0]
  8f7d2a:	add    rsi,rdi
  8f7d2d:	shrx   ecx,edx,ecx
  8f7d32:	bzhi   edx,ecx,edi
  8f7d37:	jmp    8f7d3b <check_data_plan_object+0x282b>
  8f7d39:	xor    edx,edx
  8f7d3b:	mov    rdi,r11
  8f7d3e:	mov    rcx,rsi
  8f7d41:	shr    rdi,0x3
  8f7d45:	shr    rcx,0x3
  8f7d49:	test   dl,dl
  8f7d4b:	jne    8f7d82 <check_data_plan_object+0x2872>
  8f7d4d:	mov    rbx,rdi
  8f7d50:	sub    rbx,rcx
  8f7d53:	cmp    rbx,0x40
  8f7d57:	jb     8f7d82 <check_data_plan_object+0x2872>
  8f7d59:	add    rbx,0xffffffffffffffc0
  8f7d5d:	vmovdqu64 zmm0,ZMMWORD PTR [rbp+rcx*1+0x0]
  8f7d65:	add    rcx,0x40
  8f7d69:	sub    rbx,0x40
  8f7d6d:	vptestmq k0,zmm0,zmm0
  8f7d73:	kmovd  edx,k0
  8f7d77:	jb     8f7d7d <check_data_plan_object+0x286d>
  8f7d79:	test   dl,dl
  8f7d7b:	je     8f7d5d <check_data_plan_object+0x284d>
  8f7d7d:	test   dl,dl
  8f7d7f:	setne  dl
  8f7d82:	test   dl,dl
  8f7d84:	jne    8f7da0 <check_data_plan_object+0x2890>
  8f7d86:	cmp    rcx,rdi
  8f7d89:	jae    8f7da0 <check_data_plan_object+0x2890>
  8f7d8b:	inc    rcx
  8f7d8e:	movzx  edx,BYTE PTR [rbp+rcx*1-0x1]
  8f7d93:	test   dl,dl
  8f7d95:	jne    8f7da0 <check_data_plan_object+0x2890>
  8f7d97:	cmp    rcx,rdi
  8f7d9a:	lea    rcx,[rcx+0x1]
  8f7d9e:	jb     8f7d8e <check_data_plan_object+0x287e>
  8f7da0:	cmp    rsi,r11
  8f7da3:	jae    8f7dca <check_data_plan_object+0x28ba>
  8f7da5:	mov    rcx,r11
  8f7da8:	and    rcx,0x7
  8f7dac:	je     8f7dca <check_data_plan_object+0x28ba>
  8f7dae:	and    r11,0xfffffffffffffff8
  8f7db2:	cmp    rsi,r11
  8f7db5:	ja     8f7dca <check_data_plan_object+0x28ba>
  8f7db7:	mov    sil,0xff
  8f7dba:	shl    sil,cl
  8f7dbd:	not    sil
  8f7dc0:	and    sil,BYTE PTR [rbp+rdi*1+0x0]
  8f7dc5:	or     sil,dl
  8f7dc8:	mov    edx,esi
  8f7dca:	inc    r10d
  8f7dcd:	test   dl,dl
  8f7dcf:	setne  cl
  8f7dd2:	mov    edx,r10d
  8f7dd5:	mov    esi,r10d
  8f7dd8:	mov    r10d,esi
  8f7ddb:	mov    esi,esi
  8f7ddd:	mov    esi,DWORD PTR [r14+rsi*4]
  8f7de1:	cmp    esi,r10d
  8f7de4:	jne    8f7dd8 <check_data_plan_object+0x28c8>
  8f7de6:	mov    edi,edx
  8f7de8:	mov    esi,DWORD PTR [r14+rdi*4]
  8f7dec:	cmp    esi,edx
  8f7dee:	je     8f7e07 <check_data_plan_object+0x28f7>
  8f7df0:	lea    rdx,[r14+rdi*4]
  8f7df4:	mov    DWORD PTR [rdx],r10d
  8f7df7:	mov    edi,esi
  8f7df9:	lea    rdx,[r14+rdi*4]
  8f7dfd:	mov    edi,DWORD PTR [r14+rdi*4]
  8f7e01:	cmp    edi,esi
  8f7e03:	mov    esi,edi
  8f7e05:	jne    8f7df4 <check_data_plan_object+0x28e4>
  8f7e07:	mov    DWORD PTR [r14+r13*4],r10d
  8f7e0b:	cmp    r10d,r9d
  8f7e0e:	jae    8f7e1f <check_data_plan_object+0x290f>
  8f7e10:	mov    edi,ecx
  8f7e12:	xor    edx,edx
  8f7e14:	test   cl,0x1
  8f7e17:	je     8f7cca <check_data_plan_object+0x27ba>
  8f7e1d:	jmp    8f7e21 <check_data_plan_object+0x2911>
  8f7e1f:	mov    edi,ecx
  8f7e21:	mov    rbx,QWORD PTR [rsp+0x28]
  8f7e26:	test   rbx,rbx
  8f7e29:	je     8f7e3e <check_data_plan_object+0x292e>
  8f7e2b:	mov    r9,QWORD PTR [rsp+0x30]
  8f7e30:	mov    r12,QWORD PTR [rsp+0x20]
  8f7e35:	test   cl,0x1
  8f7e38:	je     8f7b61 <check_data_plan_object+0x2651>
  8f7e3e:	mov    eax,DWORD PTR [rsp+0x90]
  8f7e45:	mov    rdx,QWORD PTR [rsp+0x68]
  8f7e4a:	mov    r9,QWORD PTR [rsp+0x48]
  8f7e4f:	mov    rcx,QWORD PTR [rsp+0x50]
  8f7e54:	mov    r11,rdi
  8f7e57:	jmp    8f67fa <check_data_plan_object+0x12ea>
  8f7e5c:	mov    eax,DWORD PTR [rsp+0x90]
  8f7e63:	jmp    8f67e3 <check_data_plan_object+0x12d3>
  8f7e68:	vzeroupper
  8f7e6b:	call   7df240 <__stack_chk_fail@plt>
  8f7e70:	lea    rdi,[rip+0xffffffffffce0a32]        # 5d88a9 <parse_test_openers+0x6cfd>
  8f7e77:	lea    rsi,[rip+0xffffffffffd2fe3f]        # 627cbd <foreign_touch.flags+0x4ada>
  8f7e7e:	lea    rcx,[rip+0xffffffffffcfa15b]        # 5f1fe0 <parse_test_openers+0x20434>
  8f7e85:	mov    edx,0x218
  8f7e8a:	vzeroupper
  8f7e8d:	call   7df2c0 <__assert_fail@plt>
  8f7e92:	lea    rdi,[rip+0xffffffffffce0a10]        # 5d88a9 <parse_test_openers+0x6cfd>
  8f7e99:	lea    rsi,[rip+0xffffffffffd2fe1d]        # 627cbd <foreign_touch.flags+0x4ada>
  8f7ea0:	lea    rcx,[rip+0xffffffffffcfa139]        # 5f1fe0 <parse_test_openers+0x20434>
  8f7ea7:	mov    edx,0x230
  8f7eac:	vzeroupper
  8f7eaf:	call   7df2c0 <__assert_fail@plt>
  8f7eb4:	lea    rdi,[rip+0xffffffffffe46eac]        # 73ed67 <pp_string_value.meaning+0x81865>
  8f7ebb:	lea    rsi,[rip+0xffffffffffdf4f3c]        # 6ecdfe <pp_string_value.meaning+0x2f8fc>
  8f7ec2:	lea    rcx,[rip+0xffffffffffdf4f50]        # 6ece19 <pp_string_value.meaning+0x2f917>
  8f7ec9:	mov    edx,0xce
  8f7ece:	vzeroupper
  8f7ed1:	call   7df2c0 <__assert_fail@plt>
  8f7ed6:	mov    rax,QWORD PTR [rsp+0x600]
  8f7ede:	mov    QWORD PTR [rax],0x0
  8f7ee5:	lea    rdi,[rip+0xffffffffffe3a973]        # 73285f <pp_string_value.meaning+0x7535d>
  8f7eec:	lea    rsi,[rip+0xffffffffffd2fdca]        # 627cbd <foreign_touch.flags+0x4ada>
  8f7ef3:	lea    rcx,[rip+0xffffffffffcfa031]        # 5f1f2b <parse_test_openers+0x2037f>
  8f7efa:	mov    edx,0x2d2
  8f7eff:	call   7df2c0 <__assert_fail@plt>
