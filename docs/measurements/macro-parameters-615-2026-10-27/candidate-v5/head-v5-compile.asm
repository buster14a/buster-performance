
head-v5/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000a0c6c0 <pp_compile_macro>:
  a0c6c0:	push   %rbp
  a0c6c1:	push   %r15
  a0c6c3:	push   %r14
  a0c6c5:	push   %r13
  a0c6c7:	push   %r12
  a0c6c9:	push   %rbx
  a0c6ca:	sub    $0x88,%rsp
  a0c6d1:	mov    0xde8(%rdi),%rax
  a0c6d8:	mov    %esi,%ecx
  a0c6da:	shl    $0x6,%rcx
  a0c6de:	mov    %rdi,%rbx
  a0c6e1:	mov    %rdi,0x28(%rsp)
  a0c6e6:	mov    0x10(%rax,%rcx,1),%edx
  a0c6ea:	movzwl 0x8(%rax,%rcx,1),%r14d
  a0c6f0:	mov    0x1c(%rax,%rcx,1),%esi
  a0c6f4:	lea    (%rax,%rcx,1),%r9
  a0c6f8:	movzbl 0x4(%rax,%rcx,1),%r15d
  a0c6fe:	mov    %r9,0x38(%rsp)
  a0c703:	imul   $0xe8,%rdx,%rbp
  a0c70a:	add    0xb80(%rdi),%rbp
  a0c711:	test   %r14d,%r14d
  a0c714:	mov    %r14d,%edx
  a0c717:	mov    %rdx,0x70(%rsp)
  a0c71c:	mov    0x18(%rax,%rcx,1),%edx
  a0c720:	mov    0xe10(%rdi),%ecx
  a0c726:	mov    %r14,0x60(%rsp)
  a0c72b:	mov    %r15b,0xb(%rsp)
  a0c730:	setne  %r11b
  a0c734:	add    0xe00(%rdi),%esi
  a0c73a:	sub    %edx,%esi
  a0c73c:	cmp    $0x4000001,%esi
  a0c742:	jae    a0c7d4 <pp_compile_macro+0x114>
  a0c748:	lea    (%rcx,%r14,1),%eax
  a0c74c:	and    %r15b,%r11b
  a0c74f:	mov    %ecx,0x30(%r9)
  a0c753:	cmp    $0x4000001,%eax
  a0c758:	setb   %sil
  a0c75c:	and    %r11b,%sil
  a0c75f:	cmp    $0x1,%sil
  a0c763:	jne    a0c7e1 <pp_compile_macro+0x121>
  a0c765:	mov    0x20(%r9),%ecx
  a0c769:	cmp    %edx,%ecx
  a0c76b:	jae    a0c7e1 <pp_compile_macro+0x121>
  a0c76d:	xor    %edx,%edx
  a0c76f:	jmp    a0c7a7 <pp_compile_macro+0xe7>
  a0c771:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0c780:	mov    0x60(%rbp),%rsi
  a0c784:	mov    (%rsi,%rcx,4),%esi
  a0c787:	mov    0x30(%r9),%r8d
  a0c78b:	mov    0xe08(%rbx),%rdi
  a0c792:	add    %edx,%r8d
  a0c795:	inc    %edx
  a0c797:	mov    %esi,(%rdi,%r8,4)
  a0c79b:	mov    0x18(%r9),%esi
  a0c79f:	inc    %rcx
  a0c7a2:	cmp    %rsi,%rcx
  a0c7a5:	jae    a0c7e1 <pp_compile_macro+0x121>
  a0c7a7:	mov    0x50(%rbp),%rsi
  a0c7ab:	movzbl (%rsi,%rcx,1),%edi
  a0c7af:	and    $0x7f,%edi
  a0c7b2:	cmp    $0x1,%edi
  a0c7b5:	je     a0c780 <pp_compile_macro+0xc0>
  a0c7b7:	cmp    $0x14,%edi
  a0c7ba:	jne    a0c79b <pp_compile_macro+0xdb>
  a0c7bc:	lea    -0x1(%rcx),%edi
  a0c7bf:	movzbl (%rsi,%rdi,1),%edi
  a0c7c3:	mov    $0xaa,%esi
  a0c7c8:	and    $0x7f,%dil
  a0c7cc:	cmp    $0x1,%dil
  a0c7d0:	jne    a0c787 <pp_compile_macro+0xc7>
  a0c7d2:	jmp    a0c79b <pp_compile_macro+0xdb>
  a0c7d4:	mov    %ecx,0x30(%r9)
  a0c7d8:	add    %r14d,0xe10(%rbx)
  a0c7df:	jmp    a0c85d <pp_compile_macro+0x19d>
  a0c7e1:	add    %r14d,0xe10(%rbx)
  a0c7e8:	cmp    $0x4000000,%eax
  a0c7ed:	ja     a0c85d <pp_compile_macro+0x19d>
  a0c7ef:	mov    0x30(%r9),%edi
  a0c7f3:	mov    %r11b,0x20(%rsp)
  a0c7f8:	shl    $0x2,%rdi
  a0c7fc:	add    0xe08(%rbx),%rdi
  a0c803:	mov    %rdi,0x30(%rsp)
  a0c808:	cmp    $0x11,%r14w
  a0c80d:	jb     a0caf2 <pp_compile_macro+0x432>
  a0c813:	movzbl 0x278(%rbx),%edx
  a0c81a:	mov    %r14d,%esi
  a0c81d:	call   a12f40 <pp_parameter_index_build>
  a0c822:	mov    0x30(%rsp),%rdi
  a0c827:	movzbl 0x20(%rsp),%r11d
  a0c82d:	mov    0x38(%rsp),%r9
  a0c832:	mov    %rax,%r10
  a0c835:	test   %rax,%rax
  a0c838:	jne    a0caf5 <pp_compile_macro+0x435>
  a0c83e:	mov    0x24(%r9),%edx
  a0c842:	lea    -0x3f8a87(%rip),%rcx        # 613dc2 <parse_test_openers+0x47872>
  a0c849:	mov    $0x2,%esi
  a0c84e:	mov    %rbx,%rdi
  a0c851:	xor    %eax,%eax
  a0c853:	call   98b970 <pp_diagnose>
  a0c858:	mov    0x38(%rsp),%r9
  a0c85d:	mov    0xe00(%rbx),%eax
  a0c863:	lea    0x38(%r9),%rdx
  a0c867:	lea    0x28(%r9),%rcx
  a0c86b:	xor    %r10d,%r10d
  a0c86e:	mov    %rdx,0x68(%rsp)
  a0c873:	mov    %eax,0x28(%r9)
  a0c877:	movq   $0x0,0x38(%r9)
  a0c87f:	mov    (%rcx),%r15d
  a0c882:	mov    %rcx,0x58(%rsp)
  a0c887:	mov    0xe00(%rbx),%ecx
  a0c88d:	lea    0xdf8(%rbx),%rax
  a0c894:	movl   $0x0,0x30(%rsp)
  a0c89c:	movl   $0x0,0xc(%rsp)
  a0c8a4:	mov    %rax,0x50(%rsp)
  a0c8a9:	mov    %r15d,%eax
  a0c8ac:	shl    $0x3,%r15
  a0c8b0:	add    0xdf8(%rbx),%r15
  a0c8b7:	sub    %eax,%ecx
  a0c8b9:	setne  %r8b
  a0c8bd:	sete   %al
  a0c8c0:	mov    %rcx,0x20(%rsp)
  a0c8c5:	mov    %eax,0x18(%rsp)
  a0c8c9:	mov    $0xfffffffffffff560,%rcx
  a0c8d0:	mov    %r10,0x40(%rsp)
  a0c8d5:	mov    %r8d,0x1c(%rsp)
  a0c8da:	mov    %fs:0x20(%rcx),%r12
  a0c8df:	test   %r12,%r12
  a0c8e2:	je     a0c8ee <pp_compile_macro+0x22e>
  a0c8e4:	mov    %fs:0x28(%rcx),%r14
  a0c8e9:	jmp    a0c99e <pp_compile_macro+0x2de>
  a0c8ee:	movabs $0x1000200000,%r13
  a0c8f8:	mov    $0x3,%edx
  a0c8fd:	mov    $0x4022,%ecx
  a0c902:	mov    $0xffffffff,%r8d
  a0c908:	xor    %r14d,%r14d
  a0c90b:	xor    %edi,%edi
  a0c90d:	xor    %r9d,%r9d
  a0c910:	mov    %r13,%rsi
  a0c913:	vzeroupper
  a0c916:	call   7cea20 <mmap@plt>
  a0c91b:	cmp    $0xffffffffffffffff,%rax
  a0c91f:	je     a0c972 <pp_compile_macro+0x2b2>
  a0c921:	lea    0x20ffff(%rax),%r12
  a0c928:	mov    $0xf,%edx
  a0c92d:	mov    %rax,%rdi
  a0c930:	and    $0xffffffffffe00000,%r12
  a0c937:	mov    %r12,%r14
  a0c93a:	sub    %rax,%r14
  a0c93d:	mov    %r14,%rsi
  a0c940:	lea    -0x10000(%r14),%rbx
  a0c947:	call   7ce9d0 <madvise@plt>
  a0c94c:	mov    %r13,%rsi
  a0c94f:	sub    %r14,%rsi
  a0c952:	mov    $0xe,%edx
  a0c957:	mov    %r12,%rdi
  a0c95a:	call   7ce9d0 <madvise@plt>
  a0c95f:	add    $0xffffffffffe00000,%r13
  a0c966:	add    $0xffffffffffff0000,%r12
  a0c96d:	mov    %r13,%r14
  a0c970:	jmp    a0c977 <pp_compile_macro+0x2b7>
  a0c972:	xor    %r12d,%r12d
  a0c975:	xor    %ebx,%ebx
  a0c977:	mov    $0xfffffffffffff560,%rcx
  a0c97e:	mov    0x1c(%rsp),%r8d
  a0c983:	mov    %r12,%fs:0x20(%rcx)
  a0c988:	movq   $0x0,%fs:0x28(%rcx)
  a0c991:	mov    %r14,%fs:0x30(%rcx)
  a0c996:	xor    %r14d,%r14d
  a0c999:	mov    %rbx,%fs:0x38(%rcx)
  a0c99e:	lea    0x7(%r14,%r12,1),%r13
  a0c9a3:	lea    (%r14,%r12,1),%rax
  a0c9a7:	and    $0xfffffffffffffff8,%r13
  a0c9ab:	cmp    %rax,%r13
  a0c9ae:	jae    a0c9d4 <pp_compile_macro+0x314>
  a0c9b0:	mov    0x20(%rsp),%r12
  a0c9b5:	movq   $0x0,0x10(%rsp)
  a0c9be:	xor    %eax,%eax
  a0c9c0:	xor    %ecx,%ecx
  a0c9c2:	mov    0xc(%rsp),%edx
  a0c9c6:	and    %r8b,%dl
  a0c9c9:	cmp    $0x1,%dl
  a0c9cc:	jne    a0d09c <pp_compile_macro+0x9dc>
  a0c9d2:	jmp    a0ca4b <pp_compile_macro+0x38b>
  a0c9d4:	mov    %fs:0x30(%rcx),%rdi
  a0c9d9:	mov    %r13,%rsi
  a0c9dc:	sub    %r12,%rsi
  a0c9df:	xor    %ecx,%ecx
  a0c9e1:	mov    $0x0,%eax
  a0c9e6:	movq   $0x0,0x10(%rsp)
  a0c9ef:	sub    %rsi,%rdi
  a0c9f2:	jb     a0d087 <pp_compile_macro+0x9c7>
  a0c9f8:	mov    0x70(%rsp),%rdx
  a0c9fd:	mov    0x20(%rsp),%r12
  a0ca02:	add    $0x3f,%edx
  a0ca05:	shr    $0x3,%edx
  a0ca08:	and    $0xfffffff8,%edx
  a0ca0b:	cmp    %rdi,%rdx
  a0ca0e:	ja     a0ca3b <pp_compile_macro+0x37b>
  a0ca10:	mov    $0xfffffffffffff560,%rax
  a0ca17:	add    %rdx,%rsi
  a0ca1a:	mov    %rsi,%fs:0x28(%rax)
  a0ca1f:	test   %r13,%r13
  a0ca22:	je     a0c9be <pp_compile_macro+0x2fe>
  a0ca24:	mov    %r13,%rdi
  a0ca27:	xor    %esi,%esi
  a0ca29:	vzeroupper
  a0ca2c:	call   7ce810 <memset@plt>
  a0ca31:	mov    0x1c(%rsp),%r8d
  a0ca36:	mov    $0x1,%al
  a0ca38:	mov    %r13,%rcx
  a0ca3b:	mov    0xc(%rsp),%edx
  a0ca3f:	and    %r8b,%dl
  a0ca42:	cmp    $0x1,%dl
  a0ca45:	jne    a0d09c <pp_compile_macro+0x9dc>
  a0ca4b:	mov    0x60(%rsp),%rdx
  a0ca50:	movzbl (%r15),%edi
  a0ca54:	mov    0x28(%rsp),%r13
  a0ca59:	mov    $0x3f,%esi
  a0ca5e:	dec    %edx
  a0ca60:	lea    -0x4(%rdi),%r8d
  a0ca64:	cmp    $0x3f,%edx
  a0ca67:	cmovb  %edx,%esi
  a0ca6a:	mov    $0x1,%edx
  a0ca6f:	shlx   %rsi,%rdx,%rdx
  a0ca74:	cmp    $0x2,%r8d
  a0ca78:	jae    a0caa7 <pp_compile_macro+0x3e7>
  a0ca7a:	testb  $0x2,0xb(%rsp)
  a0ca7f:	mov    0x68(%rsp),%rsi
  a0ca84:	mov    $0x0,%eax
  a0ca89:	movq   $0x0,0x10(%rsp)
  a0ca92:	cmovne %rdx,%rax
  a0ca96:	or     %rax,(%rsi)
  a0ca99:	xor    %eax,%eax
  a0ca9b:	movzwl 0x2(%r15),%esi
  a0caa0:	inc    %esi
  a0caa2:	jmp    a0d3bc <pp_compile_macro+0xcfc>
  a0caa7:	mov    $0xffffffff,%esi
  a0caac:	movq   $0x0,0x10(%rsp)
  a0cab5:	cmp    $0x1,%edi
  a0cab8:	jne    a0d3bc <pp_compile_macro+0xcfc>
  a0cabe:	cmp    $0x2,%r12d
  a0cac2:	jae    a0d0e7 <pp_compile_macro+0xa27>
  a0cac8:	movzwl 0x2(%r15),%edi
  a0cacd:	mov    $0x3f,%r9d
  a0cad3:	mov    $0x1,%r10d
  a0cad9:	movzwl %di,%r8d
  a0cadd:	cmp    $0x3f,%r8d
  a0cae1:	cmovb  %r8d,%r9d
  a0cae5:	shlx   %r9,%r10,%r10
  a0caea:	mov    $0x1,%r9b
  a0caed:	jmp    a0d118 <pp_compile_macro+0xa58>
  a0caf2:	xor    %r10d,%r10d
  a0caf5:	cmpw   $0x5,0x70(%rsp)
  a0cafb:	mov    0xe00(%rbx),%edx
  a0cb01:	lea    0x28(%r9),%rcx
  a0cb05:	mov    %rcx,0x58(%rsp)
  a0cb0a:	setae  %al
  a0cb0d:	and    0x278(%rbx),%al
  a0cb13:	mov    %edx,0x28(%r9)
  a0cb17:	movq   $0x0,0x38(%r9)
  a0cb1f:	mov    0x18(%r9),%r13d
  a0cb23:	mov    0x1c(%r9),%r15d
  a0cb27:	mov    %al,0x50(%rsp)
  a0cb2b:	lea    0x38(%r9),%rax
  a0cb2f:	mov    %rax,0x68(%rsp)
  a0cb34:	cmp    %r15d,%r13d
  a0cb37:	jae    a0d0a6 <pp_compile_macro+0x9e6>
  a0cb3d:	mov    0x60(%rsp),%rcx
  a0cb42:	mov    %r11d,%eax
  a0cb45:	movl   $0xffffffff,0xc(%rsp)
  a0cb4d:	movl   $0x0,0x4c(%rsp)
  a0cb55:	movl   $0x0,0x18(%rsp)
  a0cb5d:	mov    %r10,0x40(%rsp)
  a0cb62:	xor    $0x1,%al
  a0cb64:	mov    %al,0x1c(%rsp)
  a0cb68:	mov    $0xffff,%eax
  a0cb6d:	bzhi   %ecx,%eax,%eax
  a0cb72:	mov    %eax,0x7c(%rsp)
  a0cb76:	cs nopw 0x0(%rax,%rax,1)
  a0cb80:	mov    0x50(%rbp),%r8
  a0cb84:	mov    0x18(%r9),%ebx
  a0cb88:	cmp    %ebx,%r13d
  a0cb8b:	je     a0cbc0 <pp_compile_macro+0x500>
  a0cb8d:	mov    0x68(%rbp),%rax
  a0cb91:	mov    %r13d,%ecx
  a0cb94:	shr    $0x6,%ecx
  a0cb97:	mov    (%rax,%rcx,8),%rax
  a0cb9b:	bt     %r13,%rax
  a0cb9f:	jae    a0cbc0 <pp_compile_macro+0x500>
  a0cba1:	lea    -0x1(%r13),%eax
  a0cba5:	movzbl (%r8,%rax,1),%eax
  a0cbaa:	and    $0x7f,%al
  a0cbac:	cmp    $0x3d,%al
  a0cbae:	setne  %al
  a0cbb1:	mov    %eax,0x10(%rsp)
  a0cbb5:	jmp    a0cbc8 <pp_compile_macro+0x508>
  a0cbb7:	nopw   0x0(%rax,%rax,1)
  a0cbc0:	movl   $0x0,0x10(%rsp)
  a0cbc8:	mov    %r13d,%r14d
  a0cbcb:	movzbl (%r8,%r14,1),%edx
  a0cbd0:	and    $0x7f,%dl
  a0cbd3:	cmp    $0x1,%dl
  a0cbd6:	sete   %al
  a0cbd9:	test   %al,%r11b
  a0cbdc:	je     a0cc60 <pp_compile_macro+0x5a0>
  a0cbe2:	mov    0x60(%rbp),%rax
  a0cbe6:	movzbl 0x1c(%rsp),%ecx
  a0cbeb:	mov    (%rax,%r14,4),%eax
  a0cbef:	cmp    $0xab,%eax
  a0cbf4:	sete   %bl
  a0cbf7:	or     %bl,%cl
  a0cbf9:	cmp    $0x1,%cl
  a0cbfc:	jne    a0cc6d <pp_compile_macro+0x5ad>
  a0cbfe:	cmp    $0xab,%eax
  a0cc03:	jne    a0cd84 <pp_compile_macro+0x6c4>
  a0cc09:	cmpl   $0xffffffff,0xc(%rsp)
  a0cc0e:	jne    a0d226 <pp_compile_macro+0xb66>
  a0cc14:	mov    %r14,%r12
  a0cc17:	inc    %r12
  a0cc1a:	cmp    %r15d,%r12d
  a0cc1d:	jae    a0d226 <pp_compile_macro+0xb66>
  a0cc23:	movzbl (%r8,%r12,1),%eax
  a0cc28:	and    $0x7f,%al
  a0cc2a:	cmp    $0xf,%al
  a0cc2c:	jne    a0d226 <pp_compile_macro+0xb66>
  a0cc32:	mov    0x28(%rsp),%rax
  a0cc37:	mov    $0x4,%cl
  a0cc39:	movl   $0x1,0x18(%rsp)
  a0cc41:	mov    0xe00(%rax),%eax
  a0cc47:	mov    %eax,0xc(%rsp)
  a0cc4b:	lea    0x2(%r13),%eax
  a0cc4f:	mov    %eax,0x4c(%rsp)
  a0cc53:	xor    %eax,%eax
  a0cc55:	jmp    a0cd95 <pp_compile_macro+0x6d5>
  a0cc5a:	nopw   0x0(%rax,%rax,1)
  a0cc60:	cmp    $0x1,%dl
  a0cc63:	sete   %al
  a0cc66:	test   %r11b,%al
  a0cc69:	je     a0ccb0 <pp_compile_macro+0x5f0>
  a0cc6b:	xor    %ebx,%ebx
  a0cc6d:	mov    0x60(%rbp),%rax
  a0cc71:	mov    (%rax,%r14,4),%esi
  a0cc75:	test   %r10,%r10
  a0cc78:	je     a0ccbe <pp_compile_macro+0x5fe>
  a0cc7a:	mov    %r10,%rdi
  a0cc7d:	mov    %r8,%r12
  a0cc80:	vzeroupper
  a0cc83:	call   9f1bf0 <pp_parameter_index>
  a0cc88:	mov    0x30(%rsp),%rdi
  a0cc8d:	movzbl 0x20(%rsp),%r11d
  a0cc93:	mov    0x40(%rsp),%r10
  a0cc98:	mov    0x38(%rsp),%r9
  a0cc9d:	cmp    $0xffffffff,%eax
  a0cca0:	jne    a0cd90 <pp_compile_macro+0x6d0>
  a0cca6:	jmp    a0cd79 <pp_compile_macro+0x6b9>
  a0ccab:	nopl   0x0(%rax,%rax,1)
  a0ccb0:	cmp    $0x3d,%dl
  a0ccb3:	jne    a0ccfa <pp_compile_macro+0x63a>
  a0ccb5:	mov    $0x3,%cl
  a0ccb7:	xor    %eax,%eax
  a0ccb9:	jmp    a0cd92 <pp_compile_macro+0x6d2>
  a0ccbe:	cmpb   $0x0,0x50(%rsp)
  a0ccc3:	je     a0cd44 <pp_compile_macro+0x684>
  a0ccc5:	mov    0x7c(%rsp),%eax
  a0ccc9:	vpbroadcastd %esi,%zmm1
  a0cccf:	kmovd  %eax,%k1
  a0ccd3:	vmovdqu32 (%rdi),%zmm0{%k1}{z}
  a0ccd9:	vpcmpeqd %zmm1,%zmm0,%k0
  a0ccdf:	ktestw %k1,%k0
  a0cce3:	je     a0cdf5 <pp_compile_macro+0x735>
  a0cce9:	kandw  %k1,%k0,%k0
  a0cced:	kmovd  %k0,%eax
  a0ccf1:	tzcnt  %eax,%eax
  a0ccf5:	jmp    a0cd90 <pp_compile_macro+0x6d0>
  a0ccfa:	cmp    $0x3c,%dl
  a0ccfd:	sete   %al
  a0cd00:	and    %r11b,%al
  a0cd03:	cmp    $0x1,%al
  a0cd05:	jne    a0cdde <pp_compile_macro+0x71e>
  a0cd0b:	lea    0x1(%r14),%r12
  a0cd0f:	cmp    %r15d,%r12d
  a0cd12:	jae    a0dd43 <pp_compile_macro+0x1683>
  a0cd18:	movzbl (%r8,%r12,1),%eax
  a0cd1d:	and    $0x7f,%al
  a0cd1f:	cmp    $0x1,%al
  a0cd21:	jne    a0ce2c <pp_compile_macro+0x76c>
  a0cd27:	mov    0x60(%rbp),%rcx
  a0cd2b:	cmpl   $0xab,0x4(%rcx,%r14,4)
  a0cd34:	sete   %cl
  a0cd37:	cmp    $0x1,%al
  a0cd39:	je     a0ce36 <pp_compile_macro+0x776>
  a0cd3f:	jmp    a0cf51 <pp_compile_macro+0x891>
  a0cd44:	mov    $0xffffffff,%eax
  a0cd49:	mov    $0x1,%ecx
  a0cd4e:	mov    %r8,%r12
  a0cd51:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0cd60:	mov    -0x4(%rdi,%rcx,4),%edx
  a0cd64:	inc    %eax
  a0cd66:	cmp    %esi,%edx
  a0cd68:	je     a0cd75 <pp_compile_macro+0x6b5>
  a0cd6a:	cmp    0x70(%rsp),%rcx
  a0cd6f:	lea    0x1(%rcx),%rcx
  a0cd73:	jb     a0cd60 <pp_compile_macro+0x6a0>
  a0cd75:	cmp    %esi,%edx
  a0cd77:	je     a0cd90 <pp_compile_macro+0x6d0>
  a0cd79:	mov    %r12,%r8
  a0cd7c:	test   %bl,%bl
  a0cd7e:	jne    a0cc09 <pp_compile_macro+0x549>
  a0cd84:	xor    %eax,%eax
  a0cd86:	mov    %r13d,%r12d
  a0cd89:	xor    %ecx,%ecx
  a0cd8b:	jmp    a0cd95 <pp_compile_macro+0x6d5>
  a0cd8d:	nopl   (%rax)
  a0cd90:	mov    $0x1,%cl
  a0cd92:	mov    %r13d,%r12d
  a0cd95:	mov    0x10(%rsp),%r15d
  a0cd9a:	mov    0x28(%rsp),%r8
  a0cd9f:	mov    0xdf8(%r8),%rdx
  a0cda6:	mov    0xe00(%r8),%esi
  a0cdad:	mov    %cl,(%rdx,%rsi,8)
  a0cdb0:	mov    %r15b,0x1(%rdx,%rsi,8)
  a0cdb5:	mov    %ax,0x2(%rdx,%rsi,8)
  a0cdba:	mov    %r13d,0x4(%rdx,%rsi,8)
  a0cdbf:	incl   0xe00(%r8)
  a0cdc6:	mov    %r12d,%r13d
  a0cdc9:	mov    0x1c(%r9),%r15d
  a0cdcd:	inc    %r13d
  a0cdd0:	cmp    %r15d,%r13d
  a0cdd3:	jb     a0cb80 <pp_compile_macro+0x4c0>
  a0cdd9:	jmp    a0d06b <pp_compile_macro+0x9ab>
  a0cdde:	cmpl   $0xffffffff,0xc(%rsp)
  a0cde3:	mov    0x10(%rsp),%r15d
  a0cde8:	je     a0cdff <pp_compile_macro+0x73f>
  a0cdea:	cmp    $0xf,%dl
  a0cded:	jne    a0cdff <pp_compile_macro+0x73f>
  a0cdef:	incl   0x18(%rsp)
  a0cdf3:	jmp    a0ce20 <pp_compile_macro+0x760>
  a0cdf5:	test   %bl,%bl
  a0cdf7:	jne    a0cc09 <pp_compile_macro+0x549>
  a0cdfd:	jmp    a0cd84 <pp_compile_macro+0x6c4>
  a0cdff:	xor    %ecx,%ecx
  a0ce01:	cmpl   $0xffffffff,0xc(%rsp)
  a0ce06:	mov    $0x0,%eax
  a0ce0b:	je     a0ce92 <pp_compile_macro+0x7d2>
  a0ce11:	cmp    $0x10,%dl
  a0ce14:	jne    a0ce92 <pp_compile_macro+0x7d2>
  a0ce16:	decl   0x18(%rsp)
  a0ce1a:	je     a0ced6 <pp_compile_macro+0x816>
  a0ce20:	xor    %eax,%eax
  a0ce22:	mov    %r13d,%r12d
  a0ce25:	xor    %ecx,%ecx
  a0ce27:	jmp    a0cd9a <pp_compile_macro+0x6da>
  a0ce2c:	xor    %ecx,%ecx
  a0ce2e:	cmp    $0x1,%al
  a0ce30:	jne    a0cf51 <pp_compile_macro+0x891>
  a0ce36:	test   %cl,%cl
  a0ce38:	jne    a0cf51 <pp_compile_macro+0x891>
  a0ce3e:	mov    0x60(%rbp),%rax
  a0ce42:	mov    0x4(%rax,%r14,4),%esi
  a0ce47:	test   %r10,%r10
  a0ce4a:	je     a0ce9a <pp_compile_macro+0x7da>
  a0ce4c:	mov    %r10,%rdi
  a0ce4f:	mov    %r8,0x80(%rsp)
  a0ce57:	mov    %ecx,0x48(%rsp)
  a0ce5b:	vzeroupper
  a0ce5e:	call   9f1bf0 <pp_parameter_index>
  a0ce63:	mov    0x48(%rsp),%ecx
  a0ce67:	mov    0x80(%rsp),%r8
  a0ce6f:	mov    0x30(%rsp),%rdi
  a0ce74:	movzbl 0x20(%rsp),%r11d
  a0ce7a:	mov    0x40(%rsp),%r10
  a0ce7f:	mov    0x38(%rsp),%r9
  a0ce84:	cmp    $0xffffffff,%eax
  a0ce87:	jne    a0cfde <pp_compile_macro+0x91e>
  a0ce8d:	jmp    a0cf51 <pp_compile_macro+0x891>
  a0ce92:	mov    %r13d,%r12d
  a0ce95:	jmp    a0cd9a <pp_compile_macro+0x6da>
  a0ce9a:	cmpb   $0x0,0x50(%rsp)
  a0ce9f:	je     a0cf1e <pp_compile_macro+0x85e>
  a0cea1:	mov    0x7c(%rsp),%eax
  a0cea5:	vpbroadcastd %esi,%zmm1
  a0ceab:	kmovd  %eax,%k1
  a0ceaf:	vmovdqu32 (%rdi),%zmm0{%k1}{z}
  a0ceb5:	vpcmpeqd %zmm1,%zmm0,%k0
  a0cebb:	ktestw %k1,%k0
  a0cebf:	je     a0cf51 <pp_compile_macro+0x891>
  a0cec5:	kandw  %k1,%k0,%k0
  a0cec9:	kmovd  %k0,%eax
  a0cecd:	tzcnt  %eax,%eax
  a0ced1:	jmp    a0cfde <pp_compile_macro+0x91e>
  a0ced6:	mov    0x4c(%rsp),%ecx
  a0ceda:	xor    %eax,%eax
  a0cedc:	cmp    %r13d,%ecx
  a0cedf:	ja     a0cfea <pp_compile_macro+0x92a>
  a0cee5:	jmp    a0cef2 <pp_compile_macro+0x832>
  a0cee7:	inc    %ecx
  a0cee9:	cmp    %r13d,%ecx
  a0ceec:	ja     a0cfe5 <pp_compile_macro+0x925>
  a0cef2:	cmp    %ecx,%ebx
  a0cef4:	je     a0cee7 <pp_compile_macro+0x827>
  a0cef6:	mov    0x68(%rbp),%rdx
  a0cefa:	mov    %ecx,%esi
  a0cefc:	shr    $0x6,%esi
  a0ceff:	mov    (%rdx,%rsi,8),%rdx
  a0cf03:	bt     %rcx,%rdx
  a0cf07:	jae    a0cee7 <pp_compile_macro+0x827>
  a0cf09:	lea    -0x1(%rcx),%edx
  a0cf0c:	movzbl (%r8,%rdx,1),%edx
  a0cf11:	and    $0x7f,%dl
  a0cf14:	cmp    $0x3d,%dl
  a0cf17:	setne  %dl
  a0cf1a:	or     %dl,%al
  a0cf1c:	jmp    a0cee7 <pp_compile_macro+0x827>
  a0cf1e:	mov    %ecx,0x48(%rsp)
  a0cf22:	mov    $0xffffffff,%eax
  a0cf27:	mov    $0x1,%ecx
  a0cf2c:	nopl   0x0(%rax)
  a0cf30:	mov    -0x4(%rdi,%rcx,4),%edx
  a0cf34:	inc    %eax
  a0cf36:	cmp    %esi,%edx
  a0cf38:	je     a0cf45 <pp_compile_macro+0x885>
  a0cf3a:	cmp    0x70(%rsp),%rcx
  a0cf3f:	lea    0x1(%rcx),%rcx
  a0cf43:	jb     a0cf30 <pp_compile_macro+0x870>
  a0cf45:	mov    0x48(%rsp),%ecx
  a0cf49:	cmp    %esi,%edx
  a0cf4b:	je     a0cfde <pp_compile_macro+0x91e>
  a0cf51:	cmpl   $0xffffffff,0xc(%rsp)
  a0cf56:	sete   %al
  a0cf59:	and    %al,%cl
  a0cf5b:	cmp    $0x1,%cl
  a0cf5e:	jne    a0dd43 <pp_compile_macro+0x1683>
  a0cf64:	add    $0x2,%r14
  a0cf68:	cmp    %r15d,%r14d
  a0cf6b:	jae    a0dd43 <pp_compile_macro+0x1683>
  a0cf71:	movzbl (%r8,%r14,1),%eax
  a0cf76:	and    $0x7f,%al
  a0cf78:	cmp    $0xf,%al
  a0cf7a:	jne    a0dd43 <pp_compile_macro+0x1683>
  a0cf80:	cmp    %ebx,%r12d
  a0cf83:	jne    a0cf8c <pp_compile_macro+0x8cc>
  a0cf85:	mov    0x10(%rsp),%r15d
  a0cf8a:	jmp    a0cfb3 <pp_compile_macro+0x8f3>
  a0cf8c:	mov    0x68(%rbp),%rax
  a0cf90:	mov    %r12d,%ecx
  a0cf93:	shr    $0x6,%ecx
  a0cf96:	mov    0x10(%rsp),%r15d
  a0cf9b:	mov    (%rax,%rcx,8),%rax
  a0cf9f:	movzbl %r15b,%ecx
  a0cfa3:	or     $0x10,%r15b
  a0cfa7:	movzbl %r15b,%r15d
  a0cfab:	bt     %r12,%rax
  a0cfaf:	cmovae %ecx,%r15d
  a0cfb3:	mov    0x28(%rsp),%rax
  a0cfb8:	mov    $0x5,%cl
  a0cfba:	movl   $0x1,0x18(%rsp)
  a0cfc2:	mov    %r14d,%r12d
  a0cfc5:	mov    0xe00(%rax),%eax
  a0cfcb:	mov    %eax,0xc(%rsp)
  a0cfcf:	lea    0x3(%r13),%eax
  a0cfd3:	mov    %eax,0x4c(%rsp)
  a0cfd7:	xor    %eax,%eax
  a0cfd9:	jmp    a0cd9a <pp_compile_macro+0x6da>
  a0cfde:	mov    $0x2,%cl
  a0cfe0:	jmp    a0cd95 <pp_compile_macro+0x6d5>
  a0cfe5:	and    $0x1,%al
  a0cfe7:	shl    $0x6,%al
  a0cfea:	cmp    %ebx,%r13d
  a0cfed:	je     a0d01c <pp_compile_macro+0x95c>
  a0cfef:	mov    0x68(%rbp),%rcx
  a0cff3:	mov    %r13d,%edx
  a0cff6:	shr    $0x6,%edx
  a0cff9:	mov    (%rcx,%rdx,8),%rcx
  a0cffd:	bt     %r13,%rcx
  a0d001:	jae    a0d01c <pp_compile_macro+0x95c>
  a0d003:	lea    -0x1(%r13),%ecx
  a0d007:	movzbl (%r8,%rcx,1),%ecx
  a0d00c:	and    $0x7f,%cl
  a0d00f:	cmp    $0x3d,%cl
  a0d012:	setne  %cl
  a0d015:	shl    $0x5,%cl
  a0d018:	or     %al,%cl
  a0d01a:	mov    %ecx,%eax
  a0d01c:	mov    0x28(%rsp),%rsi
  a0d021:	mov    0xc(%rsp),%r8d
  a0d026:	movl   $0xffffffff,0xc(%rsp)
  a0d02e:	movl   $0x0,0x18(%rsp)
  a0d036:	mov    0xdf8(%rsi),%rcx
  a0d03d:	mov    %r8d,%edx
  a0d040:	not    %r8d
  a0d043:	or     %al,0x1(%rcx,%rdx,8)
  a0d047:	add    0xe00(%rsi),%r8d
  a0d04e:	mov    0xdf8(%rsi),%rax
  a0d055:	mov    %r8w,0x2(%rax,%rdx,8)
  a0d05b:	mov    0x1c(%r9),%r15d
  a0d05f:	inc    %r13d
  a0d062:	cmp    %r15d,%r13d
  a0d065:	jb     a0cb80 <pp_compile_macro+0x4c0>
  a0d06b:	cmpl   $0xffffffff,0xc(%rsp)
  a0d070:	mov    0x28(%rsp),%rbx
  a0d075:	je     a0d0a6 <pp_compile_macro+0x9e6>
  a0d077:	mov    0x24(%r9),%edx
  a0d07b:	lea    -0x2b7b06(%rip),%rcx        # 75557c <pp_decode_file_name.meaning+0x1e24d>
  a0d082:	jmp    a0dd62 <pp_compile_macro+0x16a2>
  a0d087:	mov    0x20(%rsp),%r12
  a0d08c:	mov    0xc(%rsp),%edx
  a0d090:	and    %r8b,%dl
  a0d093:	cmp    $0x1,%dl
  a0d096:	je     a0ca4b <pp_compile_macro+0x38b>
  a0d09c:	mov    0x28(%rsp),%r13
  a0d0a1:	jmp    a0d524 <pp_compile_macro+0xe64>
  a0d0a6:	mov    0x58(%rsp),%rcx
  a0d0ab:	mov    0xdf8(%rbx),%rdx
  a0d0b2:	mov    0xe00(%rbx),%r11d
  a0d0b9:	lea    0xdf8(%rbx),%rax
  a0d0c0:	mov    %rax,0x50(%rsp)
  a0d0c5:	mov    (%rcx),%esi
  a0d0c7:	lea    (%rdx,%rsi,8),%r15
  a0d0cb:	sub    %esi,%r11d
  a0d0ce:	mov    %r11,0x20(%rsp)
  a0d0d3:	jne    a0d1a0 <pp_compile_macro+0xae0>
  a0d0d9:	mov    $0x1,%al
  a0d0db:	xor    %r8d,%r8d
  a0d0de:	mov    %eax,0x18(%rsp)
  a0d0e2:	jmp    a0d215 <pp_compile_macro+0xb55>
  a0d0e7:	movzwl 0x2(%r15),%edi
  a0d0ec:	mov    $0x3f,%r11d
  a0d0f2:	mov    $0x1,%ebx
  a0d0f7:	movzwl %di,%r8d
  a0d0fb:	cmp    $0x3f,%r8d
  a0d0ff:	cmovb  %r8d,%r11d
  a0d103:	xor    %r10d,%r10d
  a0d106:	cmpb   $0x3,0x8(%r15)
  a0d10b:	shlx   %r11,%rbx,%r11
  a0d110:	setne  %r9b
  a0d114:	cmovne %r11,%r10
  a0d118:	mov    0x68(%rsp),%r11
  a0d11d:	and    %al,%r9b
  a0d120:	or     %r10,(%r11)
  a0d123:	cmp    $0x1,%r9b
  a0d127:	jne    a0d3bc <pp_compile_macro+0xcfc>
  a0d12d:	mov    %r8d,%r9d
  a0d130:	shr    $0x6,%r9d
  a0d134:	mov    $0x1,%al
  a0d136:	mov    (%rcx,%r9,8),%r10
  a0d13a:	bt     %r8,%r10
  a0d13e:	jb     a0d3bc <pp_compile_macro+0xcfc>
  a0d144:	mov    $0x1,%r11d
  a0d14a:	movq   $0x0,0x10(%rsp)
  a0d153:	shlx   %r8,%r11,%r8
  a0d158:	or     %r8,%r10
  a0d15b:	mov    %r10,(%rcx,%r9,8)
  a0d15f:	mov    0xe00(%r13),%r8d
  a0d166:	cmp    $0x3ffffff,%r8
  a0d16d:	ja     a0d3ba <pp_compile_macro+0xcfa>
  a0d173:	mov    0x50(%rsp),%r9
  a0d178:	mov    (%r9),%r9
  a0d17b:	movw   $0x1,(%r9,%r8,8)
  a0d182:	mov    %di,0x2(%r9,%r8,8)
  a0d188:	mov    $0x1,%edi
  a0d18d:	movl   $0x0,0x4(%r9,%r8,8)
  a0d196:	mov    %rdi,0x10(%rsp)
  a0d19b:	jmp    a0d3bc <pp_compile_macro+0xcfc>
  a0d1a0:	mov    %r11d,%eax
  a0d1a3:	mov    %rax,%rdi
  a0d1a6:	and    $0x3,%rdi
  a0d1aa:	mov    %rax,%rcx
  a0d1ad:	je     a0d204 <pp_compile_macro+0xb44>
  a0d1af:	mov    $0xffff,%r8d
  a0d1b5:	mov    %rax,%rcx
  a0d1b8:	jmp    a0d1d1 <pp_compile_macro+0xb11>
  a0d1ba:	nopw   0x0(%rax,%rax,1)
  a0d1c0:	xor    %r9d,%r9d
  a0d1c3:	mov    %r9w,-0x6(%r15,%rcx,8)
  a0d1c9:	dec    %rcx
  a0d1cc:	dec    %rdi
  a0d1cf:	je     a0d204 <pp_compile_macro+0xb44>
  a0d1d1:	cmpb   $0x0,-0x8(%r15,%rcx,8)
  a0d1d7:	jne    a0d1c9 <pp_compile_macro+0xb09>
  a0d1d9:	cmp    %rax,%rcx
  a0d1dc:	jae    a0d1c0 <pp_compile_macro+0xb00>
  a0d1de:	cmpb   $0x0,(%r15,%rcx,8)
  a0d1e3:	jne    a0d1c0 <pp_compile_macro+0xb00>
  a0d1e5:	mov    -0x4(%r15,%rcx,8),%r9d
  a0d1ea:	inc    %r9d
  a0d1ed:	cmp    %r9d,0x4(%r15,%rcx,8)
  a0d1f2:	jne    a0d1c0 <pp_compile_macro+0xb00>
  a0d1f4:	movzwl 0x2(%r15,%rcx,8),%r9d
  a0d1fa:	inc    %r9w
  a0d1fe:	cmove  %r8d,%r9d
  a0d202:	jmp    a0d1c3 <pp_compile_macro+0xb03>
  a0d204:	cmp    $0x4,%r11d
  a0d208:	jae    a0d23a <pp_compile_macro+0xb7a>
  a0d20a:	mov    $0x1,%r8b
  a0d20d:	movl   $0x0,0x18(%rsp)
  a0d215:	mov    $0x1,%al
  a0d217:	mov    %eax,0x30(%rsp)
  a0d21b:	mov    $0x1,%al
  a0d21d:	mov    %eax,0xc(%rsp)
  a0d221:	jmp    a0c8c9 <pp_compile_macro+0x209>
  a0d226:	mov    0x58(%rbp),%rax
  a0d22a:	lea    -0x3db7ac(%rip),%rcx        # 631a85 <tier0_test_vector_type_class.classes+0x6412>
  a0d231:	mov    (%rax,%r14,4),%edx
  a0d235:	jmp    a0dd59 <pp_compile_macro+0x1699>
  a0d23a:	lea    0x4(%rdx,%rsi,8),%rdx
  a0d23f:	add    $0xfffffffffffffffe,%rcx
  a0d243:	mov    $0xffff,%esi
  a0d248:	jmp    a0d264 <pp_compile_macro+0xba4>
  a0d24a:	nopw   0x0(%rax,%rax,1)
  a0d250:	xor    %edi,%edi
  a0d252:	mov    %di,-0x12(%rdx,%rcx,8)
  a0d257:	add    $0xfffffffffffffffc,%rcx
  a0d25b:	mov    $0x1,%r8b
  a0d25e:	cmp    $0xfffffffffffffffe,%rcx
  a0d262:	je     a0d20d <pp_compile_macro+0xb4d>
  a0d264:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0d269:	je     a0d290 <pp_compile_macro+0xbd0>
  a0d26b:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d270:	je     a0d2de <pp_compile_macro+0xc1e>
  a0d272:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d277:	je     a0d332 <pp_compile_macro+0xc72>
  a0d27d:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d282:	jne    a0d257 <pp_compile_macro+0xb97>
  a0d284:	jmp    a0d382 <pp_compile_macro+0xcc2>
  a0d289:	nopl   0x0(%rax)
  a0d290:	lea    0x2(%rcx),%rdi
  a0d294:	cmp    %rax,%rdi
  a0d297:	jae    a0d2d0 <pp_compile_macro+0xc10>
  a0d299:	cmpb   $0x0,0xc(%rdx,%rcx,8)
  a0d29e:	jne    a0d2d0 <pp_compile_macro+0xc10>
  a0d2a0:	mov    0x8(%rdx,%rcx,8),%edi
  a0d2a4:	inc    %edi
  a0d2a6:	cmp    %edi,0x10(%rdx,%rcx,8)
  a0d2aa:	jne    a0d2d0 <pp_compile_macro+0xc10>
  a0d2ac:	movzwl 0xe(%rdx,%rcx,8),%edi
  a0d2b1:	inc    %di
  a0d2b4:	cmove  %esi,%edi
  a0d2b7:	mov    %di,0x6(%rdx,%rcx,8)
  a0d2bc:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d2c1:	jne    a0d272 <pp_compile_macro+0xbb2>
  a0d2c3:	jmp    a0d2de <pp_compile_macro+0xc1e>
  a0d2c5:	data16 cs nopw 0x0(%rax,%rax,1)
  a0d2d0:	xor    %edi,%edi
  a0d2d2:	mov    %di,0x6(%rdx,%rcx,8)
  a0d2d7:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d2dc:	jne    a0d272 <pp_compile_macro+0xbb2>
  a0d2de:	lea    0x1(%rcx),%rdi
  a0d2e2:	cmp    %rax,%rdi
  a0d2e5:	jae    a0d320 <pp_compile_macro+0xc60>
  a0d2e7:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0d2ec:	jne    a0d320 <pp_compile_macro+0xc60>
  a0d2ee:	mov    (%rdx,%rcx,8),%edi
  a0d2f1:	inc    %edi
  a0d2f3:	cmp    %edi,0x8(%rdx,%rcx,8)
  a0d2f7:	jne    a0d320 <pp_compile_macro+0xc60>
  a0d2f9:	movzwl 0x6(%rdx,%rcx,8),%edi
  a0d2fe:	inc    %di
  a0d301:	cmove  %esi,%edi
  a0d304:	mov    %di,-0x2(%rdx,%rcx,8)
  a0d309:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d30e:	jne    a0d27d <pp_compile_macro+0xbbd>
  a0d314:	jmp    a0d332 <pp_compile_macro+0xc72>
  a0d316:	cs nopw 0x0(%rax,%rax,1)
  a0d320:	xor    %edi,%edi
  a0d322:	mov    %di,-0x2(%rdx,%rcx,8)
  a0d327:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d32c:	jne    a0d27d <pp_compile_macro+0xbbd>
  a0d332:	cmp    %rax,%rcx
  a0d335:	jae    a0d370 <pp_compile_macro+0xcb0>
  a0d337:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d33c:	jne    a0d370 <pp_compile_macro+0xcb0>
  a0d33e:	mov    -0x8(%rdx,%rcx,8),%edi
  a0d342:	inc    %edi
  a0d344:	cmp    %edi,(%rdx,%rcx,8)
  a0d347:	jne    a0d370 <pp_compile_macro+0xcb0>
  a0d349:	movzwl -0x2(%rdx,%rcx,8),%edi
  a0d34e:	inc    %di
  a0d351:	cmove  %esi,%edi
  a0d354:	mov    %di,-0xa(%rdx,%rcx,8)
  a0d359:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d35e:	jne    a0d257 <pp_compile_macro+0xb97>
  a0d364:	jmp    a0d382 <pp_compile_macro+0xcc2>
  a0d366:	cs nopw 0x0(%rax,%rax,1)
  a0d370:	xor    %edi,%edi
  a0d372:	mov    %di,-0xa(%rdx,%rcx,8)
  a0d377:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d37c:	jne    a0d257 <pp_compile_macro+0xb97>
  a0d382:	lea    -0x1(%rcx),%rdi
  a0d386:	cmp    %rax,%rdi
  a0d389:	jae    a0d250 <pp_compile_macro+0xb90>
  a0d38f:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d394:	jne    a0d250 <pp_compile_macro+0xb90>
  a0d39a:	mov    -0x10(%rdx,%rcx,8),%edi
  a0d39e:	inc    %edi
  a0d3a0:	cmp    %edi,-0x8(%rdx,%rcx,8)
  a0d3a4:	jne    a0d250 <pp_compile_macro+0xb90>
  a0d3aa:	movzwl -0xa(%rdx,%rcx,8),%edi
  a0d3af:	inc    %di
  a0d3b2:	cmove  %esi,%edi
  a0d3b5:	jmp    a0d252 <pp_compile_macro+0xb92>
  a0d3ba:	xor    %eax,%eax
  a0d3bc:	cmp    $0x2,%r12d
  a0d3c0:	jb     a0d524 <pp_compile_macro+0xe64>
  a0d3c6:	xor    %r8d,%r8d
  a0d3c9:	testb  $0x2,0xb(%rsp)
  a0d3ce:	mov    $0x2,%r10d
  a0d3d4:	mov    $0x1,%r9d
  a0d3da:	mov    %r12d,%edi
  a0d3dd:	cmove  %r8,%rdx
  a0d3e1:	jmp    a0d410 <pp_compile_macro+0xd50>
  a0d3e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d3f0:	mov    0x68(%rsp),%rax
  a0d3f5:	or     %rdx,(%rax)
  a0d3f8:	xor    %eax,%eax
  a0d3fa:	movzwl -0x6(%r15,%r10,8),%esi
  a0d400:	add    %r10d,%esi
  a0d403:	cmp    %rdi,%r10
  a0d406:	lea    0x1(%r10),%r10
  a0d40a:	jae    a0d524 <pp_compile_macro+0xe64>
  a0d410:	movzbl -0x8(%r15,%r10,8),%r11d
  a0d416:	lea    -0x4(%r11),%ebx
  a0d41a:	cmp    $0x2,%ebx
  a0d41d:	jb     a0d3f0 <pp_compile_macro+0xd30>
  a0d41f:	cmp    $0x1,%r11d
  a0d423:	jne    a0d403 <pp_compile_macro+0xd43>
  a0d425:	cmpb   $0x3,-0x10(%r15,%r10,8)
  a0d42b:	je     a0d403 <pp_compile_macro+0xd43>
  a0d42d:	cmp    %rdi,%r10
  a0d430:	jae    a0d46b <pp_compile_macro+0xdab>
  a0d432:	mov    %esi,%r11d
  a0d435:	cmp    %r11,%r10
  a0d438:	je     a0d46b <pp_compile_macro+0xdab>
  a0d43a:	movzwl -0x6(%r15,%r10,8),%r11d
  a0d440:	mov    $0x3f,%r13d
  a0d446:	mov    $0x0,%r8d
  a0d44c:	movzwl %r11w,%ebx
  a0d450:	cmp    $0x3f,%ebx
  a0d453:	cmovb  %ebx,%r13d
  a0d457:	cmpb   $0x3,(%r15,%r10,8)
  a0d45c:	shlx   %r13,%r9,%r13
  a0d461:	setne  %r12b
  a0d465:	cmove  %r8,%r13
  a0d469:	jmp    a0d48a <pp_compile_macro+0xdca>
  a0d46b:	movzwl -0x6(%r15,%r10,8),%r11d
  a0d471:	mov    $0x3f,%r12d
  a0d477:	movzwl %r11w,%ebx
  a0d47b:	cmp    $0x3f,%ebx
  a0d47e:	cmovb  %ebx,%r12d
  a0d482:	shlx   %r12,%r9,%r13
  a0d487:	mov    $0x1,%r12b
  a0d48a:	mov    0x68(%rsp),%r8
  a0d48f:	and    %al,%r12b
  a0d492:	or     %r13,(%r8)
  a0d495:	cmp    $0x1,%r12b
  a0d499:	jne    a0d4ae <pp_compile_macro+0xdee>
  a0d49b:	mov    %ebx,%r12d
  a0d49e:	shr    $0x6,%r12d
  a0d4a2:	mov    $0x1,%al
  a0d4a4:	mov    (%rcx,%r12,8),%r13
  a0d4a8:	bt     %rbx,%r13
  a0d4ac:	jae    a0d4bd <pp_compile_macro+0xdfd>
  a0d4ae:	mov    0x28(%rsp),%r13
  a0d4b3:	mov    0x20(%rsp),%r12
  a0d4b8:	jmp    a0d403 <pp_compile_macro+0xd43>
  a0d4bd:	shlx   %rbx,%r9,%rbx
  a0d4c2:	mov    0x10(%rsp),%r8
  a0d4c7:	or     %rbx,%r13
  a0d4ca:	mov    %r13,(%rcx,%r12,8)
  a0d4ce:	mov    0x28(%rsp),%r13
  a0d4d3:	mov    0xe00(%r13),%ebx
  a0d4da:	add    %r8d,%ebx
  a0d4dd:	cmp    $0x3ffffff,%ebx
  a0d4e3:	ja     a0d518 <pp_compile_macro+0xe58>
  a0d4e5:	mov    0x50(%rsp),%r12
  a0d4ea:	mov    %ebx,%ebx
  a0d4ec:	inc    %r8d
  a0d4ef:	mov    %r8,0x10(%rsp)
  a0d4f4:	mov    (%r12),%r12
  a0d4f8:	movw   $0x1,(%r12,%rbx,8)
  a0d4ff:	mov    %r11w,0x2(%r12,%rbx,8)
  a0d505:	movl   $0x0,0x4(%r12,%rbx,8)
  a0d50e:	mov    0x20(%rsp),%r12
  a0d513:	jmp    a0d403 <pp_compile_macro+0xd43>
  a0d518:	mov    0x20(%rsp),%r12
  a0d51d:	xor    %eax,%eax
  a0d51f:	jmp    a0d403 <pp_compile_macro+0xd43>
  a0d524:	mov    $0xfffffffffffff560,%rcx
  a0d52b:	cmp    %fs:0x28(%rcx),%r14
  a0d530:	ja     a0dd83 <pp_compile_macro+0x16c3>
  a0d536:	and    0x30(%rsp),%al
  a0d53a:	mov    %r14,%fs:0x28(%rcx)
  a0d53f:	xor    %ecx,%ecx
  a0d541:	mov    %eax,%esi
  a0d543:	and    0x1c(%rsp),%sil
  a0d548:	mov    %eax,%edx
  a0d54a:	cmp    $0x1,%sil
  a0d54e:	jne    a0d5a7 <pp_compile_macro+0xee7>
  a0d550:	mov    $0x1,%edi
  a0d555:	mov    %r12d,%esi
  a0d558:	xor    %ecx,%ecx
  a0d55a:	nopw   0x0(%rax,%rax,1)
  a0d560:	movzbl -0x8(%r15,%rdi,8),%r8d
  a0d566:	mov    $0x0,%r9d
  a0d56c:	cmp    $0x2,%r8b
  a0d570:	setb   %dl
  a0d573:	test   %r8b,%r8b
  a0d576:	jne    a0d595 <pp_compile_macro+0xed5>
  a0d578:	mov    0x50(%rbp),%r9
  a0d57c:	mov    -0x4(%r15,%rdi,8),%r10d
  a0d581:	movzbl (%r9,%r10,1),%r10d
  a0d586:	xor    %r9d,%r9d
  a0d589:	and    $0x7f,%r10b
  a0d58d:	cmp    $0x1,%r10b
  a0d591:	sete   %r9b
  a0d595:	add    %r9d,%ecx
  a0d598:	cmp    $0x1,%r8b
  a0d59c:	ja     a0d5a7 <pp_compile_macro+0xee7>
  a0d59e:	cmp    %rsi,%rdi
  a0d5a1:	lea    0x1(%rdi),%rdi
  a0d5a5:	jb     a0d560 <pp_compile_macro+0xea0>
  a0d5a7:	xor    %esi,%esi
  a0d5a9:	test   %dl,%dl
  a0d5ab:	je     a0d60b <pp_compile_macro+0xf4b>
  a0d5ad:	mov    0x1c(%rsp),%r9d
  a0d5b2:	mov    $0x0,%edx
  a0d5b7:	cmp    $0x10000,%ecx
  a0d5bd:	jae    a0d612 <pp_compile_macro+0xf52>
  a0d5bf:	mov    0x10(%rsp),%edi
  a0d5c3:	mov    0xe00(%r13),%edx
  a0d5ca:	mov    %ecx,%r8d
  a0d5cd:	add    %rdi,%r8
  a0d5d0:	add    %rdx,%r8
  a0d5d3:	cmp    $0x4000001,%r8
  a0d5da:	setb   %dl
  a0d5dd:	mov    %edx,%edi
  a0d5df:	and    %r9b,%dil
  a0d5e2:	cmp    $0x1,%dil
  a0d5e6:	jne    a0d612 <pp_compile_macro+0xf52>
  a0d5e8:	mov    %r12d,%r9d
  a0d5eb:	mov    %r9d,%edi
  a0d5ee:	and    $0x3,%edi
  a0d5f1:	lea    -0x1(%r12),%r8d
  a0d5f6:	cmp    $0x3,%r8d
  a0d5fa:	jae    a0d69b <pp_compile_macro+0xfdb>
  a0d600:	xor    %r10d,%r10d
  a0d603:	xor    %r8d,%r8d
  a0d606:	jmp    a0d89e <pp_compile_macro+0x11de>
  a0d60b:	xor    %edx,%edx
  a0d60d:	mov    0x1c(%rsp),%r9d
  a0d612:	test   %dl,%dl
  a0d614:	jne    a0d67c <pp_compile_macro+0xfbc>
  a0d616:	mov    $0x0,%r8d
  a0d61c:	mov    $0x0,%edi
  a0d621:	mov    $0x0,%r10d
  a0d627:	test   %al,%al
  a0d629:	je     a0d90e <pp_compile_macro+0x124e>
  a0d62f:	mov    0x38(%rsp),%rsi
  a0d634:	cmp    $0x11,%r12d
  a0d638:	mov    $0x0,%edi
  a0d63d:	setb   %r10b
  a0d641:	and    0x4(%rsi),%r10b
  a0d645:	xor    %esi,%esi
  a0d647:	and    %r10b,%r9b
  a0d64a:	cmp    $0x1,%r9b
  a0d64e:	jne    a0d90e <pp_compile_macro+0x124e>
  a0d654:	movzbl (%r15),%r11d
  a0d658:	xor    %edi,%edi
  a0d65a:	cmp    $0x2,%r11b
  a0d65e:	sete   %dil
  a0d662:	cmp    $0x3,%r11b
  a0d666:	jne    a0d7f1 <pp_compile_macro+0x1131>
  a0d66c:	mov    $0x1,%esi
  a0d671:	xor    %r8d,%r8d
  a0d674:	xor    %r10d,%r10d
  a0d677:	jmp    a0d904 <pp_compile_macro+0x1244>
  a0d67c:	xor    %r8d,%r8d
  a0d67f:	xor    %edi,%edi
  a0d681:	xor    %r10d,%r10d
  a0d684:	xor    %r9d,%r9d
  a0d687:	or     %dl,%r10b
  a0d68a:	mov    $0x0,%r11d
  a0d690:	jne    a0d920 <pp_compile_macro+0x1260>
  a0d696:	jmp    a0da08 <pp_compile_macro+0x1348>
  a0d69b:	and    $0xfffffffc,%r9d
  a0d69f:	xor    %r10d,%r10d
  a0d6a2:	xor    %r8d,%r8d
  a0d6a5:	jmp    a0d6bd <pp_compile_macro+0xffd>
  a0d6a7:	nopw   0x0(%rax,%rax,1)
  a0d6b0:	add    $0x4,%r10
  a0d6b4:	cmp    %r10,%r9
  a0d6b7:	je     a0d895 <pp_compile_macro+0x11d5>
  a0d6bd:	cmpb   $0x0,(%r15,%r10,8)
  a0d6c2:	jne    a0d700 <pp_compile_macro+0x1040>
  a0d6c4:	mov    0x50(%rbp),%rbx
  a0d6c8:	mov    0x4(%r15,%r10,8),%r11d
  a0d6cd:	movzbl (%rbx,%r11,1),%ebx
  a0d6d2:	and    $0x7f,%bl
  a0d6d5:	cmp    $0x1,%bl
  a0d6d8:	jne    a0d700 <pp_compile_macro+0x1040>
  a0d6da:	mov    0x10(%rsp),%r14
  a0d6df:	mov    0xdf8(%r13),%rbx
  a0d6e6:	add    %r8d,%r14d
  a0d6e9:	add    0xe00(%r13),%r14d
  a0d6f0:	inc    %r8d
  a0d6f3:	movl   $0x0,(%rbx,%r14,8)
  a0d6fb:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d700:	cmpb   $0x0,0x8(%r15,%r10,8)
  a0d706:	jne    a0d750 <pp_compile_macro+0x1090>
  a0d708:	mov    0x50(%rbp),%rbx
  a0d70c:	mov    0xc(%r15,%r10,8),%r11d
  a0d711:	movzbl (%rbx,%r11,1),%ebx
  a0d716:	and    $0x7f,%bl
  a0d719:	cmp    $0x1,%bl
  a0d71c:	jne    a0d750 <pp_compile_macro+0x1090>
  a0d71e:	mov    0x10(%rsp),%r14
  a0d723:	mov    0xdf8(%r13),%rbx
  a0d72a:	add    %r8d,%r14d
  a0d72d:	add    0xe00(%r13),%r14d
  a0d734:	inc    %r8d
  a0d737:	movl   $0x0,(%rbx,%r14,8)
  a0d73f:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d744:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d750:	cmpb   $0x0,0x10(%r15,%r10,8)
  a0d756:	jne    a0d7a0 <pp_compile_macro+0x10e0>
  a0d758:	mov    0x50(%rbp),%rbx
  a0d75c:	mov    0x14(%r15,%r10,8),%r11d
  a0d761:	movzbl (%rbx,%r11,1),%ebx
  a0d766:	and    $0x7f,%bl
  a0d769:	cmp    $0x1,%bl
  a0d76c:	jne    a0d7a0 <pp_compile_macro+0x10e0>
  a0d76e:	mov    0x10(%rsp),%r14
  a0d773:	mov    0xdf8(%r13),%rbx
  a0d77a:	add    %r8d,%r14d
  a0d77d:	add    0xe00(%r13),%r14d
  a0d784:	inc    %r8d
  a0d787:	movl   $0x0,(%rbx,%r14,8)
  a0d78f:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d794:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d7a0:	cmpb   $0x0,0x18(%r15,%r10,8)
  a0d7a6:	jne    a0d6b0 <pp_compile_macro+0xff0>
  a0d7ac:	mov    0x50(%rbp),%rbx
  a0d7b0:	mov    0x1c(%r15,%r10,8),%r11d
  a0d7b5:	movzbl (%rbx,%r11,1),%ebx
  a0d7ba:	and    $0x7f,%bl
  a0d7bd:	cmp    $0x1,%bl
  a0d7c0:	jne    a0d6b0 <pp_compile_macro+0xff0>
  a0d7c6:	mov    0x10(%rsp),%r14
  a0d7cb:	mov    0xdf8(%r13),%rbx
  a0d7d2:	add    %r8d,%r14d
  a0d7d5:	add    0xe00(%r13),%r14d
  a0d7dc:	inc    %r8d
  a0d7df:	movl   $0x0,(%rbx,%r14,8)
  a0d7e7:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d7ec:	jmp    a0d6b0 <pp_compile_macro+0xff0>
  a0d7f1:	setbe  %r10b
  a0d7f5:	xor    %esi,%esi
  a0d7f7:	cmp    $0x3,%r11b
  a0d7fb:	ja     a0d901 <pp_compile_macro+0x1241>
  a0d801:	cmp    $0x2,%r12d
  a0d805:	jb     a0d901 <pp_compile_macro+0x1241>
  a0d80b:	mov    0x60(%rsp),%rsi
  a0d810:	movzbl 0x8(%r15),%r9d
  a0d815:	dec    %esi
  a0d817:	cmp    $0x4,%r9b
  a0d81b:	setb   %r10b
  a0d81f:	mov    %rsi,0x60(%rsp)
  a0d824:	xor    %esi,%esi
  a0d826:	cmp    $0x3,%r9b
  a0d82a:	jne    a0dc39 <pp_compile_macro+0x1579>
  a0d830:	mov    $0x2,%esi
  a0d835:	xor    %r8d,%r8d
  a0d838:	cmp    $0x3,%r12d
  a0d83c:	jb     a0dc36 <pp_compile_macro+0x1576>
  a0d842:	cmp    $0x2,%r11b
  a0d846:	movzbl 0x10(%r15),%r11d
  a0d84b:	setb   %r8b
  a0d84f:	cmp    $0x2,%r11b
  a0d853:	setb   %r10b
  a0d857:	and    %r8b,%r10b
  a0d85a:	mov    $0x1,%r8d
  a0d860:	cmp    $0x1,%r10b
  a0d864:	jne    a0dc36 <pp_compile_macro+0x1576>
  a0d86a:	testb  $0x2,0xb(%rsp)
  a0d86f:	mov    $0x1,%r10b
  a0d872:	je     a0dc39 <pp_compile_macro+0x1579>
  a0d878:	cmp    $0x1,%r11b
  a0d87c:	jne    a0dc39 <pp_compile_macro+0x1579>
  a0d882:	movzwl 0x12(%r15),%r10d
  a0d887:	cmp    %r10d,0x60(%rsp)
  a0d88c:	setne  %r10b
  a0d890:	jmp    a0dc39 <pp_compile_macro+0x1579>
  a0d895:	test   %rdi,%rdi
  a0d898:	je     a0d60d <pp_compile_macro+0xf4d>
  a0d89e:	lea    0x4(%r15,%r10,8),%r9
  a0d8a3:	xor    %r10d,%r10d
  a0d8a6:	jmp    a0d8bc <pp_compile_macro+0x11fc>
  a0d8a8:	nopl   0x0(%rax,%rax,1)
  a0d8b0:	inc    %r10
  a0d8b3:	cmp    %r10,%rdi
  a0d8b6:	je     a0d60d <pp_compile_macro+0xf4d>
  a0d8bc:	cmpb   $0x0,-0x4(%r9,%r10,8)
  a0d8c2:	jne    a0d8b0 <pp_compile_macro+0x11f0>
  a0d8c4:	mov    0x50(%rbp),%rbx
  a0d8c8:	mov    (%r9,%r10,8),%r11d
  a0d8cc:	movzbl (%rbx,%r11,1),%ebx
  a0d8d1:	and    $0x7f,%bl
  a0d8d4:	cmp    $0x1,%bl
  a0d8d7:	jne    a0d8b0 <pp_compile_macro+0x11f0>
  a0d8d9:	mov    0x10(%rsp),%r14
  a0d8de:	mov    0xdf8(%r13),%rbx
  a0d8e5:	add    %r8d,%r14d
  a0d8e8:	add    0xe00(%r13),%r14d
  a0d8ef:	inc    %r8d
  a0d8f2:	movl   $0x0,(%rbx,%r14,8)
  a0d8fa:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d8ff:	jmp    a0d8b0 <pp_compile_macro+0x11f0>
  a0d901:	xor    %r8d,%r8d
  a0d904:	mov    0x28(%rsp),%r13
  a0d909:	mov    0x20(%rsp),%r12
  a0d90e:	xor    %r9d,%r9d
  a0d911:	or     %dl,%r10b
  a0d914:	mov    $0x0,%r11d
  a0d91a:	je     a0da08 <pp_compile_macro+0x1348>
  a0d920:	mov    0xe18(%r13),%r10
  a0d927:	test   %r10,%r10
  a0d92a:	je     a0da08 <pp_compile_macro+0x1348>
  a0d930:	cmp    $0x10,%r12d
  a0d934:	ja     a0da08 <pp_compile_macro+0x1348>
  a0d93a:	cmpw   $0x10,0x70(%rsp)
  a0d940:	ja     a0da08 <pp_compile_macro+0x1348>
  a0d946:	mov    0xe20(%r13),%ebx
  a0d94d:	cmp    $0xfffff,%rbx
  a0d954:	ja     a0da08 <pp_compile_macro+0x1348>
  a0d95a:	mov    %esi,%r14d
  a0d95d:	lea    (%rsi,%rsi,1),%r11d
  a0d961:	shr    $1,%r14d
  a0d964:	imul   $0x110,%rbx,%rbx
  a0d96b:	mov    %r12,%r13
  a0d96e:	vpxor  %xmm0,%xmm0,%xmm0
  a0d972:	andn   %r11d,%r14d,%r12d
  a0d977:	cmpb   $0x0,0x18(%rsp)
  a0d97c:	vmovdqu64 %zmm0,0xc0(%r10,%rbx,1)
  a0d984:	vmovdqu64 %zmm0,0x80(%r10,%rbx,1)
  a0d98c:	vmovdqu64 %zmm0,0x40(%r10,%rbx,1)
  a0d994:	vmovdqu64 %zmm0,(%r10,%rbx,1)
  a0d99b:	movw   $0x0,0x100(%r10,%rbx,1)
  a0d9a6:	mov    %si,0x102(%r10,%rbx,1)
  a0d9af:	mov    %r8w,0x104(%r10,%rbx,1)
  a0d9b8:	mov    %r12w,0x106(%r10,%rbx,1)
  a0d9c1:	mov    %di,0x108(%r10,%rbx,1)
  a0d9ca:	mov    %r13b,0x10a(%r10,%rbx,1)
  a0d9d2:	movl   $0x0,0x10b(%r10,%rbx,1)
  a0d9de:	movb   $0x0,0x10f(%r10,%rbx,1)
  a0d9e7:	je     a0dab4 <pp_compile_macro+0x13f4>
  a0d9ed:	mov    0x28(%rsp),%r13
  a0d9f2:	mov    0x20(%rsp),%r12
  a0d9f7:	mov    0xe20(%r13),%r11d
  a0d9fe:	inc    %r11d
  a0da01:	mov    %r11d,0xe20(%r13)
  a0da08:	mov    0x38(%rsp),%r8
  a0da0d:	mov    %eax,%esi
  a0da0f:	mov    %edx,%edi
  a0da11:	shl    $0x5,%sil
  a0da15:	shl    $0x7,%dil
  a0da19:	or     %sil,%dil
  a0da1c:	mov    %r11d,0x34(%r8)
  a0da20:	or     %dil,0x4(%r8)
  a0da24:	test   %al,%al
  a0da26:	mov    0x10(%rsp),%rax
  a0da2b:	cmove  %r9d,%eax
  a0da2f:	test   %dl,%dl
  a0da31:	cmove  %r9d,%ecx
  a0da35:	mov    %ax,0xa(%r8)
  a0da3a:	mov    %cx,0xc(%r8)
  a0da3f:	add    %eax,%ecx
  a0da41:	mov    0x30(%rsp),%eax
  a0da45:	add    %ecx,0xe00(%r13)
  a0da4c:	shl    $0x2,%al
  a0da4f:	or     %al,0x4(%r8)
  a0da53:	cmpb   $0x0,0xc(%rsp)
  a0da58:	cmove  %r9d,%r12d
  a0da5c:	mov    %r12d,0x2c(%r8)
  a0da60:	jne    a0da70 <pp_compile_macro+0x13b0>
  a0da62:	mov    0x58(%rsp),%rax
  a0da67:	mov    (%rax),%eax
  a0da69:	mov    %eax,0xe00(%r13)
  a0da70:	mov    0x40(%rsp),%rcx
  a0da75:	test   %rcx,%rcx
  a0da78:	je     a0da9b <pp_compile_macro+0x13db>
  a0da7a:	mov    0x98(%rcx),%rax
  a0da81:	test   %rax,%rax
  a0da84:	je     a0da9b <pp_compile_macro+0x13db>
  a0da86:	mov    0xa0(%rcx),%rcx
  a0da8d:	cmp    0x8(%rax),%rcx
  a0da91:	ja     a0dd83 <pp_compile_macro+0x16c3>
  a0da97:	mov    %rcx,0x8(%rax)
  a0da9b:	mov    0xc(%rsp),%eax
  a0da9f:	add    $0x88,%rsp
  a0daa6:	pop    %rbx
  a0daa7:	pop    %r12
  a0daa9:	pop    %r13
  a0daab:	pop    %r14
  a0daad:	pop    %r15
  a0daaf:	pop    %rbp
  a0dab0:	vzeroupper
  a0dab3:	ret
  a0dab4:	add    %rbx,%r10
  a0dab7:	mov    0x20(%rsp),%rbx
  a0dabc:	or     %esi,%r11d
  a0dabf:	xor    %edi,%edi
  a0dac1:	or     %r14d,%r11d
  a0dac4:	jmp    a0dade <pp_compile_macro+0x141e>
  a0dac6:	cs nopw 0x0(%rax,%rax,1)
  a0dad0:	movzwl 0x2(%r15,%rsi,8),%edi
  a0dad6:	lea    0x1(%rsi,%rdi,1),%edi
  a0dada:	cmp    %ebx,%edi
  a0dadc:	jae    a0db19 <pp_compile_macro+0x1459>
  a0dade:	mov    %dil,0x10b(%r10)
  a0dae5:	mov    %edi,%esi
  a0dae7:	xor    %r8d,%r8d
  a0daea:	cmpb   $0x3,(%r15,%rsi,8)
  a0daef:	sete   %r8b
  a0daf3:	sub    %r8d,%edi
  a0daf6:	mov    %dil,0x10c(%r10)
  a0dafd:	movzbl (%r15,%rsi,8),%r8d
  a0db02:	test   %r8b,%r8b
  a0db05:	je     a0dad0 <pp_compile_macro+0x1410>
  a0db07:	xor    %edi,%edi
  a0db09:	cmp    $0x3,%r8b
  a0db0d:	sete   %dil
  a0db11:	lea    0x1(%rsi,%rdi,1),%edi
  a0db15:	cmp    %ebx,%edi
  a0db17:	jb     a0dade <pp_compile_macro+0x141e>
  a0db19:	mov    $0x1,%r8d
  a0db1f:	mov    %ebx,%esi
  a0db21:	xor    %edi,%edi
  a0db23:	jmp    a0db44 <pp_compile_macro+0x1484>
  a0db25:	data16 cs nopw 0x0(%rax,%rax,1)
  a0db30:	or     %r12w,0xfc(%r10)
  a0db38:	inc    %rdi
  a0db3b:	cmp    %rdi,%rsi
  a0db3e:	je     a0d9ed <pp_compile_macro+0x132d>
  a0db44:	mov    0x4(%r15,%rdi,8),%r14d
  a0db49:	mov    0x50(%rbp),%rbx
  a0db4d:	movzbl (%rbx,%r14,1),%ebx
  a0db52:	mov    %r14d,%r13d
  a0db55:	shr    $0x6,%r13d
  a0db59:	and    $0x7f,%bl
  a0db5c:	mov    %bl,0xc0(%r10,%rdi,1)
  a0db64:	mov    0x68(%rbp),%r12
  a0db68:	mov    (%r12,%r13,8),%r12
  a0db6c:	bt     %r14,%r12
  a0db70:	setb   %r12b
  a0db74:	or     $0x8,%r12b
  a0db78:	mov    %r12b,0xd0(%r10,%rdi,1)
  a0db80:	cmp    $0x1,%bl
  a0db83:	jne    a0dba0 <pp_compile_macro+0x14e0>
  a0db85:	mov    0x60(%rbp),%r12
  a0db89:	mov    0x38(%rsp),%r13
  a0db8e:	mov    (%r12,%r14,4),%r12d
  a0db92:	jmp    a0dbb1 <pp_compile_macro+0x14f1>
  a0db94:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0dba0:	mov    0x60(%rbp),%r12
  a0dba4:	mov    0x38(%rsp),%r13
  a0dba9:	mov    (%r12,%r14,4),%r12d
  a0dbad:	add    0x14(%r13),%r12d
  a0dbb1:	mov    %r12d,(%r10,%rdi,4)
  a0dbb5:	mov    0x58(%rbp),%r12
  a0dbb9:	mov    (%r12,%r14,4),%r14d
  a0dbbd:	mov    $0x0,%r12d
  a0dbc3:	add    0x14(%r13),%r14d
  a0dbc7:	mov    %r14d,0x40(%r10,%rdi,4)
  a0dbcc:	xor    %r14d,%r14d
  a0dbcf:	movzbl (%r15,%rdi,8),%r13d
  a0dbd4:	dec    %r13b
  a0dbd7:	cmp    $0x1,%r13b
  a0dbdb:	ja     a0dbe3 <pp_compile_macro+0x1523>
  a0dbdd:	movzbl 0x2(%r15,%rdi,8),%r12d
  a0dbe3:	mov    %r12b,0xe0(%r10,%rdi,1)
  a0dbeb:	shlx   %edi,%r8d,%r12d
  a0dbf0:	cmpb   $0x1,(%r15,%rdi,8)
  a0dbf5:	mov    %r12d,%r13d
  a0dbf8:	je     a0dbfd <pp_compile_macro+0x153d>
  a0dbfa:	xor    %r13d,%r13d
  a0dbfd:	or     %r13w,0xf8(%r10)
  a0dc05:	xor    $0x1,%bl
  a0dc08:	mov    %r12d,%r13d
  a0dc0b:	testb  $0x1,0x1(%r15,%rdi,8)
  a0dc11:	cmove  %r14d,%r13d
  a0dc15:	or     %r13w,0xfa(%r10)
  a0dc1d:	test   %r11d,%r12d
  a0dc20:	cmovne %r14d,%r12d
  a0dc24:	or     (%r15,%rdi,8),%bl
  a0dc28:	je     a0db30 <pp_compile_macro+0x1470>
  a0dc2e:	xor    %r12d,%r12d
  a0dc31:	jmp    a0db30 <pp_compile_macro+0x1470>
  a0dc36:	xor    %r10d,%r10d
  a0dc39:	xor    %r11d,%r11d
  a0dc3c:	cmp    $0x2,%r9b
  a0dc40:	sete   %r11b
  a0dc44:	lea    (%rdi,%r11,2),%edi
  a0dc48:	test   %r10b,%r10b
  a0dc4b:	je     a0d904 <pp_compile_macro+0x1244>
  a0dc51:	cmp    $0x3,%r12d
  a0dc55:	jb     a0d904 <pp_compile_macro+0x1244>
  a0dc5b:	mov    %r12d,%r9d
  a0dc5e:	mov    $0x2,%r11d
  a0dc64:	mov    $0x3,%r12d
  a0dc6a:	nopw   0x0(%rax,%rax,1)
  a0dc70:	movzbl -0x8(%r15,%r12,8),%r13d
  a0dc76:	cmp    $0x3,%r13b
  a0dc7a:	jne    a0dcc0 <pp_compile_macro+0x1600>
  a0dc7c:	cmp    %r9,%r12
  a0dc7f:	jae    a0dce0 <pp_compile_macro+0x1620>
  a0dc81:	cmpb   $0x2,-0x10(%r15,%r12,8)
  a0dc87:	movzbl (%r15,%r12,8),%ebx
  a0dc8c:	setb   %r10b
  a0dc90:	cmp    $0x2,%bl
  a0dc93:	setb   %r14b
  a0dc97:	and    %r10b,%r14b
  a0dc9a:	cmp    $0x1,%r14b
  a0dc9e:	jne    a0dcea <pp_compile_macro+0x162a>
  a0dca0:	testb  $0x2,0xb(%rsp)
  a0dca5:	mov    $0x1,%r10b
  a0dca8:	je     a0dced <pp_compile_macro+0x162d>
  a0dcaa:	cmp    $0x1,%bl
  a0dcad:	jne    a0dced <pp_compile_macro+0x162d>
  a0dcaf:	movzwl 0x2(%r15,%r12,8),%r10d
  a0dcb5:	cmp    %r10d,0x60(%rsp)
  a0dcba:	setne  %r10b
  a0dcbe:	jmp    a0dced <pp_compile_macro+0x162d>
  a0dcc0:	lea    -0x1(%r12),%ebx
  a0dcc5:	mov    $0x1,%r14d
  a0dccb:	setbe  %r10b
  a0dccf:	inc    %r11
  a0dcd2:	shlx   %ebx,%r14d,%ebx
  a0dcd7:	jmp    a0dd17 <pp_compile_macro+0x1657>
  a0dcd9:	nopl   0x0(%rax)
  a0dce0:	lea    -0x1(%r12),%r14d
  a0dce5:	xor    %r10d,%r10d
  a0dce8:	jmp    a0dd06 <pp_compile_macro+0x1646>
  a0dcea:	xor    %r10d,%r10d
  a0dced:	lea    -0x3(%r12),%ebx
  a0dcf2:	movzbl %bl,%ebx
  a0dcf5:	bt     %ebx,%esi
  a0dcf8:	jb     a0dd03 <pp_compile_macro+0x1643>
  a0dcfa:	lea    -0x2(%r12),%ebx
  a0dcff:	bts    %ebx,%r8d
  a0dd03:	mov    %r11d,%r14d
  a0dd06:	mov    $0x1,%ebx
  a0dd0b:	bts    %r14d,%esi
  a0dd0f:	inc    %r11
  a0dd12:	shlx   %r14d,%ebx,%ebx
  a0dd17:	cmp    $0x2,%r13b
  a0dd1b:	mov    $0x0,%r14d
  a0dd21:	cmovne %r14d,%ebx
  a0dd25:	or     %ebx,%edi
  a0dd27:	test   %r10b,%r10b
  a0dd2a:	je     a0d904 <pp_compile_macro+0x1244>
  a0dd30:	cmp    %r9,%r12
  a0dd33:	lea    0x1(%r12),%r12
  a0dd38:	jb     a0dc70 <pp_compile_macro+0x15b0>
  a0dd3e:	jmp    a0d904 <pp_compile_macro+0x1244>
  a0dd43:	mov    0x58(%rbp),%rax
  a0dd47:	cmp    %r15d,%r12d
  a0dd4a:	lea    -0x412219(%rip),%rcx        # 5fbb38 <parse_test_openers+0x2f5e8>
  a0dd51:	adc    $0x0,%r13d
  a0dd55:	mov    (%rax,%r13,4),%edx
  a0dd59:	add    0x14(%r9),%edx
  a0dd5d:	mov    0x28(%rsp),%rbx
  a0dd62:	mov    $0x1,%esi
  a0dd67:	mov    %rbx,%rdi
  a0dd6a:	xor    %eax,%eax
  a0dd6c:	vzeroupper
  a0dd6f:	call   98b970 <pp_diagnose>
  a0dd74:	mov    0x40(%rsp),%r10
  a0dd79:	mov    0x58(%rsp),%rcx
  a0dd7e:	jmp    a0c87f <pp_compile_macro+0x1bf>
  a0dd83:	lea    -0x2daa78(%rip),%rdi        # 733312 <pp_string_value.meaning+0x7f660>
  a0dd8a:	lea    -0x32b29a(%rip),%rsi        # 6e2af7 <pp_string_value.meaning+0x2ee45>
  a0dd91:	lea    -0x32b286(%rip),%rcx        # 6e2b12 <pp_string_value.meaning+0x2ee60>
  a0dd98:	mov    $0xce,%edx
  a0dd9d:	vzeroupper
  a0dda0:	call   7ce030 <__assert_fail@plt>
