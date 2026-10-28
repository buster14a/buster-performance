
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000887650 <check_input_literal_table_prepare>:
  887650:	push   %rbp
  887651:	push   %r15
  887653:	push   %r14
  887655:	push   %r13
  887657:	push   %r12
  887659:	push   %rbx
  88765a:	sub    $0xd8,%rsp
  887661:	mov    %rdi,0x18(%rsp)
  887666:	mov    %esi,%ecx
  887668:	xor    %r10d,%r10d
  88766b:	mov    $0x0,%r14d
  887671:	mov    %rdi,%r8
  887674:	mov    %fs:0x28,%rax
  88767d:	mov    %rax,0xd0(%rsp)
  887685:	mov    %rcx,0x88(%rsp)
  88768d:	mov    (%rdi),%r13
  887690:	mov    0x158(%rdi),%rax
  887697:	mov    0xa8(%rdi),%rdx
  88769e:	mov    0x18(%rdi),%r12
  8876a2:	mov    0x8(%rdi),%r9
  8876a6:	mov    (%rax,%rcx,4),%ebp
  8876a9:	mov    0x2c8(%r13),%rcx
  8876b0:	mov    0x2c0(%r13),%rsi
  8876b7:	mov    (%r12),%rax
  8876bb:	mov    %r9,0x28(%rsp)
  8876c0:	mov    %r13,0x68(%rsp)
  8876c5:	mov    (%rcx,%rbp,4),%r15d
  8876c9:	mov    (%rdx,%rbp,4),%ecx
  8876cc:	mov    (%rsi,%rbp,4),%ebx
  8876cf:	mov    %ecx,%esi
  8876d1:	shr    $0x3,%esi
  8876d4:	mov    %ecx,0x24(%rsp)
  8876d8:	cmpb   $0x0,0x30(%rdi)
  8876dc:	mov    %r15,0x30(%rsp)
  8876e1:	movzbl (%rax,%rsi,1),%ecx
  8876e5:	mov    %rsi,0x50(%rsp)
  8876ea:	mov    %cl,0xf(%rsp)
  8876ee:	mov    $0x0,%ecx
  8876f3:	jne    88770b <check_input_literal_table_prepare+0xbb>
  8876f5:	xor    %r10d,%r10d
  8876f8:	cmpl   $0xffffffff,0x43c(%r8)
  887700:	mov    $0x0,%ecx
  887705:	je     8878dc <check_input_literal_table_prepare+0x28c>
  88770b:	mov    0x20(%r8),%rax
  88770f:	mov    %r10d,%edx
  887712:	mov    %r8,%rdi
  887715:	lea    0x20(%r8),%r11
  887719:	mov    %rdx,0x70(%rsp)
  88771e:	xor    %r12d,%r12d
  887721:	xor    %esi,%esi
  887723:	mov    0x8(%rax),%rax
  887727:	mov    %rax,0x40(%rsp)
  88772c:	mov    %ecx,%eax
  88772e:	shr    $0x3,%eax
  887731:	mov    %rax,0x58(%rsp)
  887736:	imul   %rdx,%rax
  88773a:	mov    %rax,0x38(%rsp)
  88773f:	mov    0x68(%rsp),%r8
  887744:	test   %rsi,%rsi
  887747:	mov    %r11,0x80(%rsp)
  88774f:	mov    %rbp,0x78(%rsp)
  887754:	mov    %rsi,0x10(%rsp)
  887759:	mov    %rbx,0x60(%rsp)
  88775e:	sete   %dl
  887761:	setne  %al
  887764:	and    %r12b,%dl
  887767:	and    %r12b,%al
  88776a:	or     %dl,0x3fd(%r8)
  887771:	cmp    $0x1,%al
  887773:	jne    887862 <check_input_literal_table_prepare+0x212>
  887779:	lea    0x2(%rbx),%edx
  88777c:	cmp    %r15d,%edx
  88777f:	jae    887862 <check_input_literal_table_prepare+0x212>
  887785:	mov    0x60(%rsp),%rax
  88778a:	mov    %edx,%ebp
  88778c:	movzbl %r14b,%esi
  887790:	inc    %rbp
  887793:	xor    %edx,%edx
  887795:	xor    %r12d,%r12d
  887798:	mov    %r10d,%r13d
  88779b:	mov    %rcx,%r14
  88779e:	mov    %esi,0x4c(%rsp)
  8877a2:	lea    0x1(%rax),%ebx
  8877a5:	data16 cs nopw 0x0(%rax,%rax,1)
  8877b0:	mov    0x18(%r9),%r8
  8877b4:	mov    %ebx,%esi
  8877b6:	mov    $0x1,%al
  8877b8:	cmpb   $0x3,(%r8,%rsi,1)
  8877bd:	jne    887812 <check_input_literal_table_prepare+0x1c2>
  8877bf:	mov    %edx,%esi
  8877c1:	inc    %edx
  8877c3:	mov    %ebx,0x90(%rsp,%rsi,4)
  8877ca:	cmp    $0x10,%edx
  8877cd:	je     887823 <check_input_literal_table_prepare+0x1d3>
  8877cf:	lea    (%rdx,%r12,1),%r15d
  8877d3:	cmp    %r10d,%r15d
  8877d6:	jne    88780d <check_input_literal_table_prepare+0x1bd>
  8877d8:	mov    %r12d,%r9d
  8877db:	imul   0x58(%rsp),%r9
  8877e1:	mov    0x4c(%rsp),%r8d
  8877e6:	lea    0x90(%rsp),%rsi
  8877ee:	add    0x10(%rsp),%r9
  8877f3:	call   8880b0 <check_literal_table_batch>
  8877f8:	mov    0x28(%rsp),%r9
  8877fd:	mov    0x18(%rsp),%rdi
  887802:	mov    %r14,%rcx
  887805:	mov    %r13d,%r10d
  887808:	xor    %edx,%edx
  88780a:	mov    %r15d,%r12d
  88780d:	mov    0x30(%rsp),%r15
  887812:	test   %al,%al
  887814:	je     887862 <check_input_literal_table_prepare+0x212>
  887816:	inc    %ebx
  887818:	cmp    %r15,%rbp
  88781b:	lea    0x1(%rbp),%rbp
  88781f:	jb     8877b0 <check_input_literal_table_prepare+0x160>
  887821:	jmp    887862 <check_input_literal_table_prepare+0x212>
  887823:	mov    %r12d,%r9d
  887826:	imul   0x58(%rsp),%r9
  88782c:	mov    0x4c(%rsp),%r8d
  887831:	lea    0x90(%rsp),%rsi
  887839:	mov    $0x10,%edx
  88783e:	add    0x10(%rsp),%r9
  887843:	call   8880b0 <check_literal_table_batch>
  887848:	mov    0x28(%rsp),%r9
  88784d:	mov    0x18(%rsp),%rdi
  887852:	mov    %r14,%rcx
  887855:	mov    %r13d,%r10d
  887858:	add    $0x10,%r12d
  88785c:	xor    %edx,%edx
  88785e:	test   %al,%al
  887860:	jne    887816 <check_input_literal_table_prepare+0x1c6>
  887862:	test   %al,%al
  887864:	je     887897 <check_input_literal_table_prepare+0x247>
  887866:	mov    0x80(%rsp),%r13
  88786e:	mov    0x68(%rsp),%r12
  887873:	mov    0x0(%r13),%rcx
  887877:	mov    (%rcx),%rsi
  88787a:	mov    0x8(%rcx),%rdx
  88787e:	lea    0xf(%rdx,%rsi,1),%r14
  887883:	add    %rsi,%rdx
  887886:	and    $0xfffffffffffffff0,%r14
  88788a:	cmp    %rdx,%r14
  88788d:	jae    8878ac <check_input_literal_table_prepare+0x25c>
  88788f:	xor    %r14d,%r14d
  887892:	jmp    887a07 <check_input_literal_table_prepare+0x3b7>
  887897:	mov    0x68(%rsp),%r12
  88789c:	mov    0x80(%rsp),%r13
  8878a4:	xor    %r14d,%r14d
  8878a7:	jmp    887a07 <check_input_literal_table_prepare+0x3b7>
  8878ac:	mov    %r14,%rdx
  8878af:	sub    %rsi,%rdx
  8878b2:	mov    0x10(%rcx),%rsi
  8878b6:	mov    %rdi,%r8
  8878b9:	sub    %rdx,%rsi
  8878bc:	setb   %dil
  8878c0:	cmp    $0xf0,%rsi
  8878c7:	setb   %sil
  8878cb:	or     %dil,%sil
  8878ce:	je     8879f9 <check_input_literal_table_prepare+0x3a9>
  8878d4:	xor    %r14d,%r14d
  8878d7:	jmp    887a04 <check_input_literal_table_prepare+0x3b4>
  8878dc:	mov    0x290(%r13),%rcx
  8878e3:	xor    %r10d,%r10d
  8878e6:	cmpb   $0x0,(%rcx,%rbp,1)
  8878ea:	jne    887d25 <check_input_literal_table_prepare+0x6d5>
  8878f0:	movzbl 0xf(%rsp),%ecx
  8878f5:	and    $0xfe,%cl
  8878f8:	cmp    $0x8,%cl
  8878fb:	jne    887d25 <check_input_literal_table_prepare+0x6d5>
  887901:	mov    $0x0,%ecx
  887906:	cmp    %ebx,%r15d
  887909:	jbe    88770b <check_input_literal_table_prepare+0xbb>
  88790f:	xor    %r10d,%r10d
  887912:	cmp    0x38(%r9),%r15d
  887916:	ja     887d25 <check_input_literal_table_prepare+0x6d5>
  88791c:	mov    %r15d,%edx
  88791f:	sub    %ebx,%edx
  887921:	mov    $0x0,%ecx
  887926:	cmp    $0x100,%edx
  88792c:	jb     88770b <check_input_literal_table_prepare+0xbb>
  887932:	mov    0x18(%r9),%rdi
  887936:	xor    %r10d,%r10d
  887939:	mov    $0x0,%ecx
  88793e:	cmpb   $0xa,(%rdi,%rbx,1)
  887942:	jne    88770b <check_input_literal_table_prepare+0xbb>
  887948:	mov    0x68(%r9),%rcx
  88794c:	lea    -0x1(%r15),%r11d
  887950:	xor    %r10d,%r10d
  887953:	mov    (%rcx,%rbx,4),%edx
  887956:	mov    $0x0,%ecx
  88795b:	cmp    %r11d,%edx
  88795e:	jne    88770b <check_input_literal_table_prepare+0xbb>
  887964:	xor    %r10d,%r10d
  887967:	cmpb   $0xb,(%rdi,%rdx,1)
  88796b:	mov    $0x0,%ecx
  887970:	jne    88770b <check_input_literal_table_prepare+0xbb>
  887976:	mov    0x20(%r12),%rcx
  88797b:	xor    %r10d,%r10d
  88797e:	mov    (%rcx,%rsi,4),%r11d
  887982:	mov    $0x0,%ecx
  887987:	mov    %r11d,%esi
  88798a:	or     0x24(%rsp),%esi
  88798e:	test   $0x2,%sil
  887992:	jne    88770b <check_input_literal_table_prepare+0xbb>
  887998:	mov    %r11d,%esi
  88799b:	and    $0xfffffff8,%esi
  88799e:	xor    %r10d,%r10d
  8879a1:	cmp    $0x10,%esi
  8879a4:	je     887d25 <check_input_literal_table_prepare+0x6d5>
  8879aa:	mov    %r11d,%esi
  8879ad:	shr    $0x3,%esi
  8879b0:	mov    $0x0,%ecx
  8879b5:	cmpb   $0x2,(%rax,%rsi,1)
  8879b9:	jne    88770b <check_input_literal_table_prepare+0xbb>
  8879bf:	shr    $0x3,%r11d
  8879c3:	xor    %r10d,%r10d
  8879c6:	movzbl (%rax,%r11,1),%eax
  8879cb:	cmp    $0x2,%eax
  8879ce:	je     887d2f <check_input_literal_table_prepare+0x6df>
  8879d4:	cmp    $0x5,%eax
  8879d7:	jne    887d25 <check_input_literal_table_prepare+0x6d5>
  8879dd:	mov    0x10(%r12),%rax
  8879e2:	mov    0x30(%r12),%rsi
  8879e7:	testb  $0x1,(%rax,%r11,1)
  8879ec:	mov    (%rsi,%r11,8),%rcx
  8879f0:	sete   %r14b
  8879f4:	jmp    887d5d <check_input_literal_table_prepare+0x70d>
  8879f9:	add    $0xf0,%rdx
  887a00:	mov    %rdx,0x8(%rcx)
  887a04:	mov    %r8,%rdi
  887a07:	test   %r14,%r14
  887a0a:	sete   %dl
  887a0d:	setne  %cl
  887a10:	and    %al,%dl
  887a12:	and    %al,%cl
  887a14:	or     %dl,0x3fd(%r12)
  887a1c:	cmp    $0x1,%cl
  887a1f:	jne    887acc <check_input_literal_table_prepare+0x47c>
  887a25:	cmpb   $0x9,0xf(%rsp)
  887a2a:	jne    887acc <check_input_literal_table_prepare+0x47c>
  887a30:	mov    %rdi,%rsi
  887a33:	mov    0x18(%rdi),%rdi
  887a37:	mov    0x50(%rsp),%r8
  887a3c:	xor    %ebx,%ebx
  887a3e:	mov    (%rdi),%rax
  887a41:	mov    0x20(%rdi),%rcx
  887a45:	movzbl (%rax,%r8,1),%edx
  887a4a:	mov    (%rcx,%r8,4),%ebp
  887a4e:	add    $0xf8,%dl
  887a51:	mov    %ebp,%ecx
  887a53:	cmp    $0x3,%dl
  887a56:	cmovb  0x24(%rsp),%ebx
  887a5b:	shr    $0x3,%ecx
  887a5e:	je     887bf6 <check_input_literal_table_prepare+0x5a6>
  887a64:	cmp    0x48(%rdi),%ecx
  887a67:	jae    887bf6 <check_input_literal_table_prepare+0x5a6>
  887a6d:	cmpb   $0x0,(%rax,%rcx,1)
  887a71:	je     887bf6 <check_input_literal_table_prepare+0x5a6>
  887a77:	mov    0x70(%rsp),%r8
  887a7c:	mov    %ebp,%ecx
  887a7e:	and    $0xfffffff8,%ecx
  887a81:	mov    $0x8,%esi
  887a86:	xor    %edx,%edx
  887a88:	xor    %r9d,%r9d
  887a8b:	call   126e9d0 <type_find_or_add>
  887a90:	mov    0x18(%rsp),%rdi
  887a95:	test   %eax,%eax
  887a97:	je     887c25 <check_input_literal_table_prepare+0x5d5>
  887a9d:	or     %ebp,%ebx
  887a9f:	and    $0x7,%ebx
  887aa2:	lea    (%rbx,%rax,8),%ecx
  887aa5:	test   %ecx,%ecx
  887aa7:	je     887c25 <check_input_literal_table_prepare+0x5d5>
  887aad:	mov    0x60(%rsp),%r8
  887ab2:	mov    0x28(%rsp),%r9
  887ab7:	mov    0x78(%rsp),%r10
  887abc:	and    $0x1fffffff,%eax
  887ac1:	mov    %ecx,0x24(%rsp)
  887ac5:	mov    %rax,0x50(%rsp)
  887aca:	jmp    887ade <check_input_literal_table_prepare+0x48e>
  887acc:	mov    0x60(%rsp),%r8
  887ad1:	mov    0x78(%rsp),%r10
  887ad6:	test   %cl,%cl
  887ad8:	je     887c3c <check_input_literal_table_prepare+0x5ec>
  887ade:	mov    0x24(%rsp),%r11d
  887ae3:	mov    $0x1,%ecx
  887ae8:	mov    0x38(%rsp),%rdx
  887aed:	vpcmpeqd %xmm2,%xmm2,%xmm2
  887af1:	movq   $0x0,(%r14)
  887af8:	mov    %r10d,0x8(%r14)
  887afc:	vxorps %xmm0,%xmm0,%xmm0
  887b00:	vmovups %zmm0,0x8c(%r14)
  887b0a:	vmovups %zmm0,0xc(%r14)
  887b14:	vmovups %zmm0,0x4c(%r14)
  887b1e:	vmovups %zmm0,0xb0(%r14)
  887b28:	mov    0x50(%rsp),%rbx
  887b2d:	lea    0x10(%r14),%rax
  887b31:	vmovd  %ecx,%xmm1
  887b35:	mov    0x10(%rsp),%rcx
  887b3a:	vpinsrd $0x1,%r11d,%xmm1,%xmm1
  887b40:	vpblendd $0x4,%xmm2,%xmm1,%xmm1
  887b46:	vpinsrd $0x3,%r8d,%xmm1,%xmm1
  887b4c:	vmovdqa %xmm1,0x10(%r14)
  887b52:	vpxor  %xmm1,%xmm1,%xmm1
  887b56:	vmovdqa %xmm1,0x20(%r14)
  887b5c:	movq   $0x0,0x30(%r14)
  887b64:	mov    %rcx,0x38(%r14)
  887b68:	mov    %rdx,0x40(%r14)
  887b6c:	vmovups %zmm0,0x80(%r14)
  887b73:	vmovups %zmm0,0x48(%r14)
  887b7d:	mov    0x18(%rdi),%rdx
  887b81:	mov    (%rdx),%rsi
  887b84:	mov    0x38(%rdx),%rcx
  887b88:	cmpb   $0xf,(%rsi,%rbx,1)
  887b8c:	mov    %rbx,%rsi
  887b8f:	jne    887b9b <check_input_literal_table_prepare+0x54b>
  887b91:	mov    0x20(%rdx),%rdx
  887b95:	mov    (%rdx,%rsi,4),%esi
  887b98:	shr    $0x3,%esi
  887b9b:	vpmovsxbd -0x2c3344(%rip),%xmm0        # 5c4860 <check_test_initializer_nesting.timed+0x250>
  887ba4:	mov    (%rcx,%rsi,8),%rcx
  887ba8:	mov    %r11d,0xc0(%r14)
  887baf:	movl   $0x0,0xc4(%r14)
  887bba:	mov    %rcx,0xc8(%r14)
  887bc1:	mov    %rax,0xd0(%r14)
  887bc8:	mov    $0xffffffff,%eax
  887bcd:	vmovups %xmm0,0xd8(%r14)
  887bd6:	mov    %rax,0xe8(%r14)
  887bdd:	mov    0x390(%r12),%rax
  887be5:	test   %rax,%rax
  887be8:	je     887c7e <check_input_literal_table_prepare+0x62e>
  887bee:	mov    %r14,(%rax)
  887bf1:	jmp    887c86 <check_input_literal_table_prepare+0x636>
  887bf6:	mov    0x108(%rdi),%rax
  887bfd:	movl   $0x2,0x100(%rdi)
  887c07:	mov    %rsi,%rdi
  887c0a:	test   %rax,%rax
  887c0d:	je     887c25 <check_input_literal_table_prepare+0x5d5>
  887c0f:	movb   $0x1,0x3c(%rax)
  887c13:	mov    0x30(%rax),%rcx
  887c17:	mov    %rcx,0x40(%rax)
  887c1b:	movl   $0x2,0x48(%rax)
  887c22:	incl   0x34(%rax)
  887c25:	mov    0x18(%rdi),%rax
  887c29:	cmpl   $0x1,0x100(%rax)
  887c30:	jne    887c3c <check_input_literal_table_prepare+0x5ec>
  887c32:	mov    (%rdi),%rax
  887c35:	movb   $0x1,0x3fd(%rax)
  887c3c:	mov    0x0(%r13),%rax
  887c40:	mov    0x40(%rsp),%rcx
  887c45:	cmp    0x8(%rax),%rcx
  887c49:	ja     887eb3 <check_input_literal_table_prepare+0x863>
  887c4f:	mov    %rcx,0x8(%rax)
  887c53:	xor    %eax,%eax
  887c55:	mov    %fs:0x28,%rcx
  887c5e:	cmp    0xd0(%rsp),%rcx
  887c66:	jne    887d20 <check_input_literal_table_prepare+0x6d0>
  887c6c:	add    $0xd8,%rsp
  887c73:	pop    %rbx
  887c74:	pop    %r12
  887c76:	pop    %r13
  887c78:	pop    %r14
  887c7a:	pop    %r15
  887c7c:	pop    %rbp
  887c7d:	ret
  887c7e:	mov    %r14,0x388(%r12)
  887c86:	mov    %r14,0x390(%r12)
  887c8e:	incl   0x398(%r12)
  887c96:	mov    0x88(%rsp),%r14
  887c9e:	mov    0xa8(%rdi),%rax
  887ca5:	mov    %r11d,(%rax,%r10,4)
  887ca9:	mov    0xb0(%rdi),%rax
  887cb0:	mov    %r11d,(%rax,%r14,4)
  887cb4:	mov    0x130(%rdi),%rax
  887cbb:	cmpb   $0x0,(%rax,%r10,1)
  887cc0:	je     887cd5 <check_input_literal_table_prepare+0x685>
  887cc2:	mov    0x20(%r9),%rcx
  887cc6:	mov    0x3a0(%rdi),%rax
  887ccd:	mov    (%rcx,%r10,4),%ecx
  887cd1:	mov    %r11d,(%rax,%rcx,4)
  887cd5:	mov    %r8d,%eax
  887cd8:	add    0x140(%rdi),%r8
  887cdf:	sub    %eax,%r15d
  887ce2:	mov    $0x1,%esi
  887ce7:	mov    %rdi,%rax
  887cea:	mov    %rax,%rbx
  887ced:	mov    %r15,%rdx
  887cf0:	mov    %r8,%rdi
  887cf3:	vzeroupper
  887cf6:	call   7e6af0 <memset@plt>
  887cfb:	mov    0x140(%rbx),%rax
  887d02:	movb   $0x1,(%rax,%r14,1)
  887d07:	mov    $0x1,%al
  887d09:	mov    %fs:0x28,%rcx
  887d12:	cmp    0xd0(%rsp),%rcx
  887d1a:	je     887c6c <check_input_literal_table_prepare+0x61c>
  887d20:	call   7e6210 <__stack_chk_fail@plt>
  887d25:	xor    %ecx,%ecx
  887d27:	xor    %r14d,%r14d
  887d2a:	jmp    88770b <check_input_literal_table_prepare+0xbb>
  887d2f:	lea    (%r11,%r11,2),%rax
  887d33:	lea    -0x3d6f0a(%rip),%rsi        # 4b0e30 <type_integer_info>
  887d3a:	movzbl 0x2(%rsi,%rax,2),%ecx
  887d3f:	cmp    $0x3,%r11
  887d43:	jne    887d54 <check_input_literal_table_prepare+0x704>
  887d45:	movzbl 0x118(%r12),%r14d
  887d4e:	xor    $0x1,%r14b
  887d52:	jmp    887d5d <check_input_literal_table_prepare+0x70d>
  887d54:	lea    (%rsi,%rax,2),%rax
  887d58:	movzbl 0x3(%rax),%r14d
  887d5d:	lea    -0x1(%rcx),%rax
  887d61:	cmp    $0x7f,%rax
  887d65:	ja     887de0 <check_input_literal_table_prepare+0x790>
  887d67:	popcnt %ecx,%eax
  887d6b:	cmp    $0x1,%eax
  887d6e:	jne    88770b <check_input_literal_table_prepare+0xbb>
  887d74:	tzcnt  %ecx,%eax
  887d78:	mov    %rcx,0x10(%rsp)
  887d7d:	add    $0xfffffffd,%eax
  887d80:	cmp    $0x3,%eax
  887d83:	ja     887de7 <check_input_literal_table_prepare+0x797>
  887d85:	movzbl (%r9),%ecx
  887d89:	lea    0x1(%rbx),%esi
  887d8c:	call   887ee0 <check_literal_table_shape>
  887d91:	mov    %eax,%r10d
  887d94:	cmp    $0x80,%eax
  887d99:	jb     887df1 <check_input_literal_table_prepare+0x7a1>
  887d9b:	cmpb   $0x9,0xf(%rsp)
  887da0:	mov    %r10d,%esi
  887da3:	mov    %r10d,%r8d
  887da6:	mov    %rsi,0x70(%rsp)
  887dab:	jne    887e05 <check_input_literal_table_prepare+0x7b5>
  887dad:	mov    0x18(%rsp),%rax
  887db2:	mov    0x10(%rsp),%rdi
  887db7:	lea    0x20(%rax),%r11
  887dbb:	mov    0x20(%rax),%rax
  887dbf:	shr    $0x3,%rdi
  887dc3:	mov    %rdi,0x58(%rsp)
  887dc8:	imul   %rsi,%rdi
  887dcc:	mov    %rdi,0x38(%rsp)
  887dd1:	mov    0x8(%rax),%rcx
  887dd5:	lea    0x8(%rax),%rdx
  887dd9:	mov    %rcx,0x40(%rsp)
  887dde:	jmp    887e4d <check_input_literal_table_prepare+0x7fd>
  887de0:	xor    %ecx,%ecx
  887de2:	jmp    88770b <check_input_literal_table_prepare+0xbb>
  887de7:	mov    0x10(%rsp),%rcx
  887dec:	jmp    88770b <check_input_literal_table_prepare+0xbb>
  887df1:	mov    0x18(%rsp),%r8
  887df6:	mov    0x28(%rsp),%r9
  887dfb:	mov    0x10(%rsp),%rcx
  887e00:	jmp    88770b <check_input_literal_table_prepare+0xbb>
  887e05:	mov    0x18(%rsp),%rax
  887e0a:	mov    0x10(%rsp),%rdx
  887e0f:	mov    0x30(%r12),%rcx
  887e14:	lea    0x20(%rax),%r11
  887e18:	mov    0x20(%rax),%rax
  887e1c:	shr    $0x3,%rdx
  887e20:	mov    %rdx,0x58(%rsp)
  887e25:	imul   %rsi,%rdx
  887e29:	mov    %rdx,0x38(%rsp)
  887e2e:	mov    0x8(%rax),%rdx
  887e32:	mov    %rdx,0x40(%rsp)
  887e37:	mov    0x50(%rsp),%rdx
  887e3c:	cmp    %rsi,(%rcx,%rdx,8)
  887e40:	jae    887e49 <check_input_literal_table_prepare+0x7f9>
  887e42:	xor    %r12d,%r12d
  887e45:	xor    %esi,%esi
  887e47:	jmp    887e79 <check_input_literal_table_prepare+0x829>
  887e49:	lea    0x8(%rax),%rdx
  887e4d:	mov    0x10(%rax),%rsi
  887e51:	mov    $0x1,%r12b
  887e54:	sub    0x40(%rsp),%rsi
  887e59:	jb     887e95 <check_input_literal_table_prepare+0x845>
  887e5b:	cmp    %rsi,0x38(%rsp)
  887e60:	ja     887e95 <check_input_literal_table_prepare+0x845>
  887e62:	mov    (%rax),%rsi
  887e65:	mov    0x40(%rsp),%rdi
  887e6a:	mov    0x38(%rsp),%rcx
  887e6f:	add    %rdi,%rsi
  887e72:	lea    (%rdi,%rcx,1),%rax
  887e76:	mov    %rax,(%rdx)
  887e79:	mov    0x18(%rsp),%rdi
  887e7e:	mov    0x30(%rsp),%r15
  887e83:	mov    0x28(%rsp),%r9
  887e88:	mov    0x10(%rsp),%rcx
  887e8d:	mov    %r8d,%r10d
  887e90:	jmp    88773f <check_input_literal_table_prepare+0xef>
  887e95:	mov    0x18(%rsp),%rdi
  887e9a:	mov    0x30(%rsp),%r15
  887e9f:	mov    0x28(%rsp),%r9
  887ea4:	mov    0x10(%rsp),%rcx
  887ea9:	mov    %r8d,%r10d
  887eac:	xor    %esi,%esi
  887eae:	jmp    88773f <check_input_literal_table_prepare+0xef>
  887eb3:	lea    -0x142dcf(%rip),%rdi        # 7450eb <pp_string_value.meaning+0x82834>
  887eba:	lea    -0x1956ab(%rip),%rsi        # 6f2816 <pp_string_value.meaning+0x2ff5f>
  887ec1:	lea    -0x195697(%rip),%rcx        # 6f2831 <pp_string_value.meaning+0x2ff7a>
  887ec8:	mov    $0xce,%edx
  887ecd:	call   7e6290 <__assert_fail@plt>
