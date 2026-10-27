
head-v4/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000a0c7b0 <pp_compile_macro>:
  a0c7b0:	push   %rbp
  a0c7b1:	push   %r15
  a0c7b3:	push   %r14
  a0c7b5:	push   %r13
  a0c7b7:	push   %r12
  a0c7b9:	push   %rbx
  a0c7ba:	sub    $0x88,%rsp
  a0c7c1:	mov    0xde8(%rdi),%rax
  a0c7c8:	mov    %esi,%ecx
  a0c7ca:	shl    $0x6,%rcx
  a0c7ce:	mov    %rdi,%rbx
  a0c7d1:	mov    %rdi,0x28(%rsp)
  a0c7d6:	mov    0x10(%rax,%rcx,1),%edx
  a0c7da:	movzwl 0x8(%rax,%rcx,1),%r14d
  a0c7e0:	mov    0x1c(%rax,%rcx,1),%esi
  a0c7e4:	lea    (%rax,%rcx,1),%r9
  a0c7e8:	movzbl 0x4(%rax,%rcx,1),%r15d
  a0c7ee:	mov    %r9,0x38(%rsp)
  a0c7f3:	imul   $0xe8,%rdx,%rbp
  a0c7fa:	add    0xb80(%rdi),%rbp
  a0c801:	test   %r14d,%r14d
  a0c804:	mov    %r14d,%edx
  a0c807:	mov    %rdx,0x70(%rsp)
  a0c80c:	mov    0x18(%rax,%rcx,1),%edx
  a0c810:	mov    0xe10(%rdi),%ecx
  a0c816:	mov    %r14,0x60(%rsp)
  a0c81b:	mov    %r15b,0xb(%rsp)
  a0c820:	setne  %r11b
  a0c824:	add    0xe00(%rdi),%esi
  a0c82a:	sub    %edx,%esi
  a0c82c:	cmp    $0x4000001,%esi
  a0c832:	jae    a0c8c4 <pp_compile_macro+0x114>
  a0c838:	lea    (%rcx,%r14,1),%eax
  a0c83c:	and    %r15b,%r11b
  a0c83f:	mov    %ecx,0x30(%r9)
  a0c843:	cmp    $0x4000001,%eax
  a0c848:	setb   %sil
  a0c84c:	and    %r11b,%sil
  a0c84f:	cmp    $0x1,%sil
  a0c853:	jne    a0c8d1 <pp_compile_macro+0x121>
  a0c855:	mov    0x20(%r9),%ecx
  a0c859:	cmp    %edx,%ecx
  a0c85b:	jae    a0c8d1 <pp_compile_macro+0x121>
  a0c85d:	xor    %edx,%edx
  a0c85f:	jmp    a0c897 <pp_compile_macro+0xe7>
  a0c861:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0c870:	mov    0x60(%rbp),%rsi
  a0c874:	mov    (%rsi,%rcx,4),%esi
  a0c877:	mov    0x30(%r9),%r8d
  a0c87b:	mov    0xe08(%rbx),%rdi
  a0c882:	add    %edx,%r8d
  a0c885:	inc    %edx
  a0c887:	mov    %esi,(%rdi,%r8,4)
  a0c88b:	mov    0x18(%r9),%esi
  a0c88f:	inc    %rcx
  a0c892:	cmp    %rsi,%rcx
  a0c895:	jae    a0c8d1 <pp_compile_macro+0x121>
  a0c897:	mov    0x50(%rbp),%rsi
  a0c89b:	movzbl (%rsi,%rcx,1),%edi
  a0c89f:	and    $0x7f,%edi
  a0c8a2:	cmp    $0x1,%edi
  a0c8a5:	je     a0c870 <pp_compile_macro+0xc0>
  a0c8a7:	cmp    $0x14,%edi
  a0c8aa:	jne    a0c88b <pp_compile_macro+0xdb>
  a0c8ac:	lea    -0x1(%rcx),%edi
  a0c8af:	movzbl (%rsi,%rdi,1),%edi
  a0c8b3:	mov    $0xaa,%esi
  a0c8b8:	and    $0x7f,%dil
  a0c8bc:	cmp    $0x1,%dil
  a0c8c0:	jne    a0c877 <pp_compile_macro+0xc7>
  a0c8c2:	jmp    a0c88b <pp_compile_macro+0xdb>
  a0c8c4:	mov    %ecx,0x30(%r9)
  a0c8c8:	add    %r14d,0xe10(%rbx)
  a0c8cf:	jmp    a0c94d <pp_compile_macro+0x19d>
  a0c8d1:	add    %r14d,0xe10(%rbx)
  a0c8d8:	cmp    $0x4000000,%eax
  a0c8dd:	ja     a0c94d <pp_compile_macro+0x19d>
  a0c8df:	mov    0x30(%r9),%edi
  a0c8e3:	mov    %r11b,0x20(%rsp)
  a0c8e8:	shl    $0x2,%rdi
  a0c8ec:	add    0xe08(%rbx),%rdi
  a0c8f3:	mov    %rdi,0x30(%rsp)
  a0c8f8:	cmp    $0x11,%r14w
  a0c8fd:	jb     a0cbe2 <pp_compile_macro+0x432>
  a0c903:	movzbl 0x278(%rbx),%edx
  a0c90a:	mov    %r14d,%esi
  a0c90d:	call   a13030 <pp_parameter_index_build>
  a0c912:	mov    0x30(%rsp),%rdi
  a0c917:	movzbl 0x20(%rsp),%r11d
  a0c91d:	mov    0x38(%rsp),%r9
  a0c922:	mov    %rax,%r10
  a0c925:	test   %rax,%rax
  a0c928:	jne    a0cbe5 <pp_compile_macro+0x435>
  a0c92e:	mov    0x24(%r9),%edx
  a0c932:	lea    -0x3f8b87(%rip),%rcx        # 613db2 <parse_test_openers+0x47872>
  a0c939:	mov    $0x2,%esi
  a0c93e:	mov    %rbx,%rdi
  a0c941:	xor    %eax,%eax
  a0c943:	call   98b970 <pp_diagnose>
  a0c948:	mov    0x38(%rsp),%r9
  a0c94d:	mov    0xe00(%rbx),%eax
  a0c953:	lea    0x38(%r9),%rdx
  a0c957:	lea    0x28(%r9),%rcx
  a0c95b:	xor    %r10d,%r10d
  a0c95e:	mov    %rdx,0x68(%rsp)
  a0c963:	mov    %eax,0x28(%r9)
  a0c967:	movq   $0x0,0x38(%r9)
  a0c96f:	mov    (%rcx),%r15d
  a0c972:	mov    %rcx,0x58(%rsp)
  a0c977:	mov    0xe00(%rbx),%ecx
  a0c97d:	lea    0xdf8(%rbx),%rax
  a0c984:	movl   $0x0,0x30(%rsp)
  a0c98c:	movl   $0x0,0xc(%rsp)
  a0c994:	mov    %rax,0x50(%rsp)
  a0c999:	mov    %r15d,%eax
  a0c99c:	shl    $0x3,%r15
  a0c9a0:	add    0xdf8(%rbx),%r15
  a0c9a7:	sub    %eax,%ecx
  a0c9a9:	setne  %r8b
  a0c9ad:	sete   %al
  a0c9b0:	mov    %rcx,0x20(%rsp)
  a0c9b5:	mov    %eax,0x18(%rsp)
  a0c9b9:	mov    $0xfffffffffffff560,%rcx
  a0c9c0:	mov    %r10,0x40(%rsp)
  a0c9c5:	mov    %r8d,0x1c(%rsp)
  a0c9ca:	mov    %fs:0x20(%rcx),%r12
  a0c9cf:	test   %r12,%r12
  a0c9d2:	je     a0c9de <pp_compile_macro+0x22e>
  a0c9d4:	mov    %fs:0x28(%rcx),%r14
  a0c9d9:	jmp    a0ca8e <pp_compile_macro+0x2de>
  a0c9de:	movabs $0x1000200000,%r13
  a0c9e8:	mov    $0x3,%edx
  a0c9ed:	mov    $0x4022,%ecx
  a0c9f2:	mov    $0xffffffff,%r8d
  a0c9f8:	xor    %r14d,%r14d
  a0c9fb:	xor    %edi,%edi
  a0c9fd:	xor    %r9d,%r9d
  a0ca00:	mov    %r13,%rsi
  a0ca03:	vzeroupper
  a0ca06:	call   7ce8c0 <mmap@plt>
  a0ca0b:	cmp    $0xffffffffffffffff,%rax
  a0ca0f:	je     a0ca62 <pp_compile_macro+0x2b2>
  a0ca11:	lea    0x20ffff(%rax),%r12
  a0ca18:	mov    $0xf,%edx
  a0ca1d:	mov    %rax,%rdi
  a0ca20:	and    $0xffffffffffe00000,%r12
  a0ca27:	mov    %r12,%r14
  a0ca2a:	sub    %rax,%r14
  a0ca2d:	mov    %r14,%rsi
  a0ca30:	lea    -0x10000(%r14),%rbx
  a0ca37:	call   7ce870 <madvise@plt>
  a0ca3c:	mov    %r13,%rsi
  a0ca3f:	sub    %r14,%rsi
  a0ca42:	mov    $0xe,%edx
  a0ca47:	mov    %r12,%rdi
  a0ca4a:	call   7ce870 <madvise@plt>
  a0ca4f:	add    $0xffffffffffe00000,%r13
  a0ca56:	add    $0xffffffffffff0000,%r12
  a0ca5d:	mov    %r13,%r14
  a0ca60:	jmp    a0ca67 <pp_compile_macro+0x2b7>
  a0ca62:	xor    %r12d,%r12d
  a0ca65:	xor    %ebx,%ebx
  a0ca67:	mov    $0xfffffffffffff560,%rcx
  a0ca6e:	mov    0x1c(%rsp),%r8d
  a0ca73:	mov    %r12,%fs:0x20(%rcx)
  a0ca78:	movq   $0x0,%fs:0x28(%rcx)
  a0ca81:	mov    %r14,%fs:0x30(%rcx)
  a0ca86:	xor    %r14d,%r14d
  a0ca89:	mov    %rbx,%fs:0x38(%rcx)
  a0ca8e:	lea    0x7(%r14,%r12,1),%r13
  a0ca93:	lea    (%r14,%r12,1),%rax
  a0ca97:	and    $0xfffffffffffffff8,%r13
  a0ca9b:	cmp    %rax,%r13
  a0ca9e:	jae    a0cac4 <pp_compile_macro+0x314>
  a0caa0:	mov    0x20(%rsp),%r12
  a0caa5:	movq   $0x0,0x10(%rsp)
  a0caae:	xor    %eax,%eax
  a0cab0:	xor    %ecx,%ecx
  a0cab2:	mov    0xc(%rsp),%edx
  a0cab6:	and    %r8b,%dl
  a0cab9:	cmp    $0x1,%dl
  a0cabc:	jne    a0d18c <pp_compile_macro+0x9dc>
  a0cac2:	jmp    a0cb3b <pp_compile_macro+0x38b>
  a0cac4:	mov    %fs:0x30(%rcx),%rdi
  a0cac9:	mov    %r13,%rsi
  a0cacc:	sub    %r12,%rsi
  a0cacf:	xor    %ecx,%ecx
  a0cad1:	mov    $0x0,%eax
  a0cad6:	movq   $0x0,0x10(%rsp)
  a0cadf:	sub    %rsi,%rdi
  a0cae2:	jb     a0d177 <pp_compile_macro+0x9c7>
  a0cae8:	mov    0x70(%rsp),%rdx
  a0caed:	mov    0x20(%rsp),%r12
  a0caf2:	add    $0x3f,%edx
  a0caf5:	shr    $0x3,%edx
  a0caf8:	and    $0xfffffff8,%edx
  a0cafb:	cmp    %rdi,%rdx
  a0cafe:	ja     a0cb2b <pp_compile_macro+0x37b>
  a0cb00:	mov    $0xfffffffffffff560,%rax
  a0cb07:	add    %rdx,%rsi
  a0cb0a:	mov    %rsi,%fs:0x28(%rax)
  a0cb0f:	test   %r13,%r13
  a0cb12:	je     a0caae <pp_compile_macro+0x2fe>
  a0cb14:	mov    %r13,%rdi
  a0cb17:	xor    %esi,%esi
  a0cb19:	vzeroupper
  a0cb1c:	call   7ce6b0 <memset@plt>
  a0cb21:	mov    0x1c(%rsp),%r8d
  a0cb26:	mov    $0x1,%al
  a0cb28:	mov    %r13,%rcx
  a0cb2b:	mov    0xc(%rsp),%edx
  a0cb2f:	and    %r8b,%dl
  a0cb32:	cmp    $0x1,%dl
  a0cb35:	jne    a0d18c <pp_compile_macro+0x9dc>
  a0cb3b:	mov    0x60(%rsp),%rdx
  a0cb40:	movzbl (%r15),%edi
  a0cb44:	mov    0x28(%rsp),%r13
  a0cb49:	mov    $0x3f,%esi
  a0cb4e:	dec    %edx
  a0cb50:	lea    -0x4(%rdi),%r8d
  a0cb54:	cmp    $0x3f,%edx
  a0cb57:	cmovb  %edx,%esi
  a0cb5a:	mov    $0x1,%edx
  a0cb5f:	shlx   %rsi,%rdx,%rdx
  a0cb64:	cmp    $0x2,%r8d
  a0cb68:	jae    a0cb97 <pp_compile_macro+0x3e7>
  a0cb6a:	testb  $0x2,0xb(%rsp)
  a0cb6f:	mov    0x68(%rsp),%rsi
  a0cb74:	mov    $0x0,%eax
  a0cb79:	movq   $0x0,0x10(%rsp)
  a0cb82:	cmovne %rdx,%rax
  a0cb86:	or     %rax,(%rsi)
  a0cb89:	xor    %eax,%eax
  a0cb8b:	movzwl 0x2(%r15),%esi
  a0cb90:	inc    %esi
  a0cb92:	jmp    a0d4ac <pp_compile_macro+0xcfc>
  a0cb97:	mov    $0xffffffff,%esi
  a0cb9c:	movq   $0x0,0x10(%rsp)
  a0cba5:	cmp    $0x1,%edi
  a0cba8:	jne    a0d4ac <pp_compile_macro+0xcfc>
  a0cbae:	cmp    $0x2,%r12d
  a0cbb2:	jae    a0d1d7 <pp_compile_macro+0xa27>
  a0cbb8:	movzwl 0x2(%r15),%edi
  a0cbbd:	mov    $0x3f,%r9d
  a0cbc3:	mov    $0x1,%r10d
  a0cbc9:	movzwl %di,%r8d
  a0cbcd:	cmp    $0x3f,%r8d
  a0cbd1:	cmovb  %r8d,%r9d
  a0cbd5:	shlx   %r9,%r10,%r10
  a0cbda:	mov    $0x1,%r9b
  a0cbdd:	jmp    a0d208 <pp_compile_macro+0xa58>
  a0cbe2:	xor    %r10d,%r10d
  a0cbe5:	cmpw   $0x5,0x70(%rsp)
  a0cbeb:	mov    0xe00(%rbx),%edx
  a0cbf1:	lea    0x28(%r9),%rcx
  a0cbf5:	mov    %rcx,0x58(%rsp)
  a0cbfa:	setae  %al
  a0cbfd:	and    0x278(%rbx),%al
  a0cc03:	mov    %edx,0x28(%r9)
  a0cc07:	movq   $0x0,0x38(%r9)
  a0cc0f:	mov    0x18(%r9),%r13d
  a0cc13:	mov    0x1c(%r9),%r15d
  a0cc17:	mov    %al,0x50(%rsp)
  a0cc1b:	lea    0x38(%r9),%rax
  a0cc1f:	mov    %rax,0x68(%rsp)
  a0cc24:	cmp    %r15d,%r13d
  a0cc27:	jae    a0d196 <pp_compile_macro+0x9e6>
  a0cc2d:	mov    0x60(%rsp),%rcx
  a0cc32:	mov    %r11d,%eax
  a0cc35:	movl   $0xffffffff,0xc(%rsp)
  a0cc3d:	movl   $0x0,0x4c(%rsp)
  a0cc45:	movl   $0x0,0x18(%rsp)
  a0cc4d:	mov    %r10,0x40(%rsp)
  a0cc52:	xor    $0x1,%al
  a0cc54:	mov    %al,0x1c(%rsp)
  a0cc58:	mov    $0xffff,%eax
  a0cc5d:	bzhi   %ecx,%eax,%eax
  a0cc62:	mov    %eax,0x7c(%rsp)
  a0cc66:	cs nopw 0x0(%rax,%rax,1)
  a0cc70:	mov    0x50(%rbp),%r8
  a0cc74:	mov    0x18(%r9),%ebx
  a0cc78:	cmp    %ebx,%r13d
  a0cc7b:	je     a0ccb0 <pp_compile_macro+0x500>
  a0cc7d:	mov    0x68(%rbp),%rax
  a0cc81:	mov    %r13d,%ecx
  a0cc84:	shr    $0x6,%ecx
  a0cc87:	mov    (%rax,%rcx,8),%rax
  a0cc8b:	bt     %r13,%rax
  a0cc8f:	jae    a0ccb0 <pp_compile_macro+0x500>
  a0cc91:	lea    -0x1(%r13),%eax
  a0cc95:	movzbl (%r8,%rax,1),%eax
  a0cc9a:	and    $0x7f,%al
  a0cc9c:	cmp    $0x3d,%al
  a0cc9e:	setne  %al
  a0cca1:	mov    %eax,0x10(%rsp)
  a0cca5:	jmp    a0ccb8 <pp_compile_macro+0x508>
  a0cca7:	nopw   0x0(%rax,%rax,1)
  a0ccb0:	movl   $0x0,0x10(%rsp)
  a0ccb8:	mov    %r13d,%r14d
  a0ccbb:	movzbl (%r8,%r14,1),%edx
  a0ccc0:	and    $0x7f,%dl
  a0ccc3:	cmp    $0x1,%dl
  a0ccc6:	sete   %al
  a0ccc9:	test   %al,%r11b
  a0cccc:	je     a0cd50 <pp_compile_macro+0x5a0>
  a0ccd2:	mov    0x60(%rbp),%rax
  a0ccd6:	movzbl 0x1c(%rsp),%ecx
  a0ccdb:	mov    (%rax,%r14,4),%eax
  a0ccdf:	cmp    $0xab,%eax
  a0cce4:	sete   %bl
  a0cce7:	or     %bl,%cl
  a0cce9:	cmp    $0x1,%cl
  a0ccec:	jne    a0cd5d <pp_compile_macro+0x5ad>
  a0ccee:	cmp    $0xab,%eax
  a0ccf3:	jne    a0ce74 <pp_compile_macro+0x6c4>
  a0ccf9:	cmpl   $0xffffffff,0xc(%rsp)
  a0ccfe:	jne    a0d316 <pp_compile_macro+0xb66>
  a0cd04:	mov    %r14,%r12
  a0cd07:	inc    %r12
  a0cd0a:	cmp    %r15d,%r12d
  a0cd0d:	jae    a0d316 <pp_compile_macro+0xb66>
  a0cd13:	movzbl (%r8,%r12,1),%eax
  a0cd18:	and    $0x7f,%al
  a0cd1a:	cmp    $0xf,%al
  a0cd1c:	jne    a0d316 <pp_compile_macro+0xb66>
  a0cd22:	mov    0x28(%rsp),%rax
  a0cd27:	mov    $0x4,%cl
  a0cd29:	movl   $0x1,0x18(%rsp)
  a0cd31:	mov    0xe00(%rax),%eax
  a0cd37:	mov    %eax,0xc(%rsp)
  a0cd3b:	lea    0x2(%r13),%eax
  a0cd3f:	mov    %eax,0x4c(%rsp)
  a0cd43:	xor    %eax,%eax
  a0cd45:	jmp    a0ce85 <pp_compile_macro+0x6d5>
  a0cd4a:	nopw   0x0(%rax,%rax,1)
  a0cd50:	cmp    $0x1,%dl
  a0cd53:	sete   %al
  a0cd56:	test   %r11b,%al
  a0cd59:	je     a0cda0 <pp_compile_macro+0x5f0>
  a0cd5b:	xor    %ebx,%ebx
  a0cd5d:	mov    0x60(%rbp),%rax
  a0cd61:	mov    (%rax,%r14,4),%esi
  a0cd65:	test   %r10,%r10
  a0cd68:	je     a0cdae <pp_compile_macro+0x5fe>
  a0cd6a:	mov    %r10,%rdi
  a0cd6d:	mov    %r8,%r12
  a0cd70:	vzeroupper
  a0cd73:	call   9f1ce0 <pp_parameter_index>
  a0cd78:	mov    0x30(%rsp),%rdi
  a0cd7d:	movzbl 0x20(%rsp),%r11d
  a0cd83:	mov    0x40(%rsp),%r10
  a0cd88:	mov    0x38(%rsp),%r9
  a0cd8d:	cmp    $0xffffffff,%eax
  a0cd90:	jne    a0ce80 <pp_compile_macro+0x6d0>
  a0cd96:	jmp    a0ce69 <pp_compile_macro+0x6b9>
  a0cd9b:	nopl   0x0(%rax,%rax,1)
  a0cda0:	cmp    $0x3d,%dl
  a0cda3:	jne    a0cdea <pp_compile_macro+0x63a>
  a0cda5:	mov    $0x3,%cl
  a0cda7:	xor    %eax,%eax
  a0cda9:	jmp    a0ce82 <pp_compile_macro+0x6d2>
  a0cdae:	cmpb   $0x0,0x50(%rsp)
  a0cdb3:	je     a0ce34 <pp_compile_macro+0x684>
  a0cdb5:	mov    0x7c(%rsp),%eax
  a0cdb9:	vpbroadcastd %esi,%zmm1
  a0cdbf:	kmovd  %eax,%k1
  a0cdc3:	vmovdqu32 (%rdi),%zmm0{%k1}{z}
  a0cdc9:	vpcmpeqd %zmm1,%zmm0,%k0
  a0cdcf:	ktestw %k1,%k0
  a0cdd3:	je     a0cee5 <pp_compile_macro+0x735>
  a0cdd9:	kandw  %k1,%k0,%k0
  a0cddd:	kmovd  %k0,%eax
  a0cde1:	tzcnt  %eax,%eax
  a0cde5:	jmp    a0ce80 <pp_compile_macro+0x6d0>
  a0cdea:	cmp    $0x3c,%dl
  a0cded:	sete   %al
  a0cdf0:	and    %r11b,%al
  a0cdf3:	cmp    $0x1,%al
  a0cdf5:	jne    a0cece <pp_compile_macro+0x71e>
  a0cdfb:	lea    0x1(%r14),%r12
  a0cdff:	cmp    %r15d,%r12d
  a0ce02:	jae    a0de33 <pp_compile_macro+0x1683>
  a0ce08:	movzbl (%r8,%r12,1),%eax
  a0ce0d:	and    $0x7f,%al
  a0ce0f:	cmp    $0x1,%al
  a0ce11:	jne    a0cf1c <pp_compile_macro+0x76c>
  a0ce17:	mov    0x60(%rbp),%rcx
  a0ce1b:	cmpl   $0xab,0x4(%rcx,%r14,4)
  a0ce24:	sete   %cl
  a0ce27:	cmp    $0x1,%al
  a0ce29:	je     a0cf26 <pp_compile_macro+0x776>
  a0ce2f:	jmp    a0d041 <pp_compile_macro+0x891>
  a0ce34:	mov    $0xffffffff,%eax
  a0ce39:	mov    $0x1,%ecx
  a0ce3e:	mov    %r8,%r12
  a0ce41:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0ce50:	mov    -0x4(%rdi,%rcx,4),%edx
  a0ce54:	inc    %eax
  a0ce56:	cmp    %esi,%edx
  a0ce58:	je     a0ce65 <pp_compile_macro+0x6b5>
  a0ce5a:	cmp    0x70(%rsp),%rcx
  a0ce5f:	lea    0x1(%rcx),%rcx
  a0ce63:	jb     a0ce50 <pp_compile_macro+0x6a0>
  a0ce65:	cmp    %esi,%edx
  a0ce67:	je     a0ce80 <pp_compile_macro+0x6d0>
  a0ce69:	mov    %r12,%r8
  a0ce6c:	test   %bl,%bl
  a0ce6e:	jne    a0ccf9 <pp_compile_macro+0x549>
  a0ce74:	xor    %eax,%eax
  a0ce76:	mov    %r13d,%r12d
  a0ce79:	xor    %ecx,%ecx
  a0ce7b:	jmp    a0ce85 <pp_compile_macro+0x6d5>
  a0ce7d:	nopl   (%rax)
  a0ce80:	mov    $0x1,%cl
  a0ce82:	mov    %r13d,%r12d
  a0ce85:	mov    0x10(%rsp),%r15d
  a0ce8a:	mov    0x28(%rsp),%r8
  a0ce8f:	mov    0xdf8(%r8),%rdx
  a0ce96:	mov    0xe00(%r8),%esi
  a0ce9d:	mov    %cl,(%rdx,%rsi,8)
  a0cea0:	mov    %r15b,0x1(%rdx,%rsi,8)
  a0cea5:	mov    %ax,0x2(%rdx,%rsi,8)
  a0ceaa:	mov    %r13d,0x4(%rdx,%rsi,8)
  a0ceaf:	incl   0xe00(%r8)
  a0ceb6:	mov    %r12d,%r13d
  a0ceb9:	mov    0x1c(%r9),%r15d
  a0cebd:	inc    %r13d
  a0cec0:	cmp    %r15d,%r13d
  a0cec3:	jb     a0cc70 <pp_compile_macro+0x4c0>
  a0cec9:	jmp    a0d15b <pp_compile_macro+0x9ab>
  a0cece:	cmpl   $0xffffffff,0xc(%rsp)
  a0ced3:	mov    0x10(%rsp),%r15d
  a0ced8:	je     a0ceef <pp_compile_macro+0x73f>
  a0ceda:	cmp    $0xf,%dl
  a0cedd:	jne    a0ceef <pp_compile_macro+0x73f>
  a0cedf:	incl   0x18(%rsp)
  a0cee3:	jmp    a0cf10 <pp_compile_macro+0x760>
  a0cee5:	test   %bl,%bl
  a0cee7:	jne    a0ccf9 <pp_compile_macro+0x549>
  a0ceed:	jmp    a0ce74 <pp_compile_macro+0x6c4>
  a0ceef:	xor    %ecx,%ecx
  a0cef1:	cmpl   $0xffffffff,0xc(%rsp)
  a0cef6:	mov    $0x0,%eax
  a0cefb:	je     a0cf82 <pp_compile_macro+0x7d2>
  a0cf01:	cmp    $0x10,%dl
  a0cf04:	jne    a0cf82 <pp_compile_macro+0x7d2>
  a0cf06:	decl   0x18(%rsp)
  a0cf0a:	je     a0cfc6 <pp_compile_macro+0x816>
  a0cf10:	xor    %eax,%eax
  a0cf12:	mov    %r13d,%r12d
  a0cf15:	xor    %ecx,%ecx
  a0cf17:	jmp    a0ce8a <pp_compile_macro+0x6da>
  a0cf1c:	xor    %ecx,%ecx
  a0cf1e:	cmp    $0x1,%al
  a0cf20:	jne    a0d041 <pp_compile_macro+0x891>
  a0cf26:	test   %cl,%cl
  a0cf28:	jne    a0d041 <pp_compile_macro+0x891>
  a0cf2e:	mov    0x60(%rbp),%rax
  a0cf32:	mov    0x4(%rax,%r14,4),%esi
  a0cf37:	test   %r10,%r10
  a0cf3a:	je     a0cf8a <pp_compile_macro+0x7da>
  a0cf3c:	mov    %r10,%rdi
  a0cf3f:	mov    %r8,0x80(%rsp)
  a0cf47:	mov    %ecx,0x48(%rsp)
  a0cf4b:	vzeroupper
  a0cf4e:	call   9f1ce0 <pp_parameter_index>
  a0cf53:	mov    0x48(%rsp),%ecx
  a0cf57:	mov    0x80(%rsp),%r8
  a0cf5f:	mov    0x30(%rsp),%rdi
  a0cf64:	movzbl 0x20(%rsp),%r11d
  a0cf6a:	mov    0x40(%rsp),%r10
  a0cf6f:	mov    0x38(%rsp),%r9
  a0cf74:	cmp    $0xffffffff,%eax
  a0cf77:	jne    a0d0ce <pp_compile_macro+0x91e>
  a0cf7d:	jmp    a0d041 <pp_compile_macro+0x891>
  a0cf82:	mov    %r13d,%r12d
  a0cf85:	jmp    a0ce8a <pp_compile_macro+0x6da>
  a0cf8a:	cmpb   $0x0,0x50(%rsp)
  a0cf8f:	je     a0d00e <pp_compile_macro+0x85e>
  a0cf91:	mov    0x7c(%rsp),%eax
  a0cf95:	vpbroadcastd %esi,%zmm1
  a0cf9b:	kmovd  %eax,%k1
  a0cf9f:	vmovdqu32 (%rdi),%zmm0{%k1}{z}
  a0cfa5:	vpcmpeqd %zmm1,%zmm0,%k0
  a0cfab:	ktestw %k1,%k0
  a0cfaf:	je     a0d041 <pp_compile_macro+0x891>
  a0cfb5:	kandw  %k1,%k0,%k0
  a0cfb9:	kmovd  %k0,%eax
  a0cfbd:	tzcnt  %eax,%eax
  a0cfc1:	jmp    a0d0ce <pp_compile_macro+0x91e>
  a0cfc6:	mov    0x4c(%rsp),%ecx
  a0cfca:	xor    %eax,%eax
  a0cfcc:	cmp    %r13d,%ecx
  a0cfcf:	ja     a0d0da <pp_compile_macro+0x92a>
  a0cfd5:	jmp    a0cfe2 <pp_compile_macro+0x832>
  a0cfd7:	inc    %ecx
  a0cfd9:	cmp    %r13d,%ecx
  a0cfdc:	ja     a0d0d5 <pp_compile_macro+0x925>
  a0cfe2:	cmp    %ecx,%ebx
  a0cfe4:	je     a0cfd7 <pp_compile_macro+0x827>
  a0cfe6:	mov    0x68(%rbp),%rdx
  a0cfea:	mov    %ecx,%esi
  a0cfec:	shr    $0x6,%esi
  a0cfef:	mov    (%rdx,%rsi,8),%rdx
  a0cff3:	bt     %rcx,%rdx
  a0cff7:	jae    a0cfd7 <pp_compile_macro+0x827>
  a0cff9:	lea    -0x1(%rcx),%edx
  a0cffc:	movzbl (%r8,%rdx,1),%edx
  a0d001:	and    $0x7f,%dl
  a0d004:	cmp    $0x3d,%dl
  a0d007:	setne  %dl
  a0d00a:	or     %dl,%al
  a0d00c:	jmp    a0cfd7 <pp_compile_macro+0x827>
  a0d00e:	mov    %ecx,0x48(%rsp)
  a0d012:	mov    $0xffffffff,%eax
  a0d017:	mov    $0x1,%ecx
  a0d01c:	nopl   0x0(%rax)
  a0d020:	mov    -0x4(%rdi,%rcx,4),%edx
  a0d024:	inc    %eax
  a0d026:	cmp    %esi,%edx
  a0d028:	je     a0d035 <pp_compile_macro+0x885>
  a0d02a:	cmp    0x70(%rsp),%rcx
  a0d02f:	lea    0x1(%rcx),%rcx
  a0d033:	jb     a0d020 <pp_compile_macro+0x870>
  a0d035:	mov    0x48(%rsp),%ecx
  a0d039:	cmp    %esi,%edx
  a0d03b:	je     a0d0ce <pp_compile_macro+0x91e>
  a0d041:	cmpl   $0xffffffff,0xc(%rsp)
  a0d046:	sete   %al
  a0d049:	and    %al,%cl
  a0d04b:	cmp    $0x1,%cl
  a0d04e:	jne    a0de33 <pp_compile_macro+0x1683>
  a0d054:	add    $0x2,%r14
  a0d058:	cmp    %r15d,%r14d
  a0d05b:	jae    a0de33 <pp_compile_macro+0x1683>
  a0d061:	movzbl (%r8,%r14,1),%eax
  a0d066:	and    $0x7f,%al
  a0d068:	cmp    $0xf,%al
  a0d06a:	jne    a0de33 <pp_compile_macro+0x1683>
  a0d070:	cmp    %ebx,%r12d
  a0d073:	jne    a0d07c <pp_compile_macro+0x8cc>
  a0d075:	mov    0x10(%rsp),%r15d
  a0d07a:	jmp    a0d0a3 <pp_compile_macro+0x8f3>
  a0d07c:	mov    0x68(%rbp),%rax
  a0d080:	mov    %r12d,%ecx
  a0d083:	shr    $0x6,%ecx
  a0d086:	mov    0x10(%rsp),%r15d
  a0d08b:	mov    (%rax,%rcx,8),%rax
  a0d08f:	movzbl %r15b,%ecx
  a0d093:	or     $0x10,%r15b
  a0d097:	movzbl %r15b,%r15d
  a0d09b:	bt     %r12,%rax
  a0d09f:	cmovae %ecx,%r15d
  a0d0a3:	mov    0x28(%rsp),%rax
  a0d0a8:	mov    $0x5,%cl
  a0d0aa:	movl   $0x1,0x18(%rsp)
  a0d0b2:	mov    %r14d,%r12d
  a0d0b5:	mov    0xe00(%rax),%eax
  a0d0bb:	mov    %eax,0xc(%rsp)
  a0d0bf:	lea    0x3(%r13),%eax
  a0d0c3:	mov    %eax,0x4c(%rsp)
  a0d0c7:	xor    %eax,%eax
  a0d0c9:	jmp    a0ce8a <pp_compile_macro+0x6da>
  a0d0ce:	mov    $0x2,%cl
  a0d0d0:	jmp    a0ce85 <pp_compile_macro+0x6d5>
  a0d0d5:	and    $0x1,%al
  a0d0d7:	shl    $0x6,%al
  a0d0da:	cmp    %ebx,%r13d
  a0d0dd:	je     a0d10c <pp_compile_macro+0x95c>
  a0d0df:	mov    0x68(%rbp),%rcx
  a0d0e3:	mov    %r13d,%edx
  a0d0e6:	shr    $0x6,%edx
  a0d0e9:	mov    (%rcx,%rdx,8),%rcx
  a0d0ed:	bt     %r13,%rcx
  a0d0f1:	jae    a0d10c <pp_compile_macro+0x95c>
  a0d0f3:	lea    -0x1(%r13),%ecx
  a0d0f7:	movzbl (%r8,%rcx,1),%ecx
  a0d0fc:	and    $0x7f,%cl
  a0d0ff:	cmp    $0x3d,%cl
  a0d102:	setne  %cl
  a0d105:	shl    $0x5,%cl
  a0d108:	or     %al,%cl
  a0d10a:	mov    %ecx,%eax
  a0d10c:	mov    0x28(%rsp),%rsi
  a0d111:	mov    0xc(%rsp),%r8d
  a0d116:	movl   $0xffffffff,0xc(%rsp)
  a0d11e:	movl   $0x0,0x18(%rsp)
  a0d126:	mov    0xdf8(%rsi),%rcx
  a0d12d:	mov    %r8d,%edx
  a0d130:	not    %r8d
  a0d133:	or     %al,0x1(%rcx,%rdx,8)
  a0d137:	add    0xe00(%rsi),%r8d
  a0d13e:	mov    0xdf8(%rsi),%rax
  a0d145:	mov    %r8w,0x2(%rax,%rdx,8)
  a0d14b:	mov    0x1c(%r9),%r15d
  a0d14f:	inc    %r13d
  a0d152:	cmp    %r15d,%r13d
  a0d155:	jb     a0cc70 <pp_compile_macro+0x4c0>
  a0d15b:	cmpl   $0xffffffff,0xc(%rsp)
  a0d160:	mov    0x28(%rsp),%rbx
  a0d165:	je     a0d196 <pp_compile_macro+0x9e6>
  a0d167:	mov    0x24(%r9),%edx
  a0d16b:	lea    -0x2b7c06(%rip),%rcx        # 75556c <pp_decode_file_name.meaning+0x1e24d>
  a0d172:	jmp    a0de52 <pp_compile_macro+0x16a2>
  a0d177:	mov    0x20(%rsp),%r12
  a0d17c:	mov    0xc(%rsp),%edx
  a0d180:	and    %r8b,%dl
  a0d183:	cmp    $0x1,%dl
  a0d186:	je     a0cb3b <pp_compile_macro+0x38b>
  a0d18c:	mov    0x28(%rsp),%r13
  a0d191:	jmp    a0d614 <pp_compile_macro+0xe64>
  a0d196:	mov    0x58(%rsp),%rcx
  a0d19b:	mov    0xdf8(%rbx),%rdx
  a0d1a2:	mov    0xe00(%rbx),%r11d
  a0d1a9:	lea    0xdf8(%rbx),%rax
  a0d1b0:	mov    %rax,0x50(%rsp)
  a0d1b5:	mov    (%rcx),%esi
  a0d1b7:	lea    (%rdx,%rsi,8),%r15
  a0d1bb:	sub    %esi,%r11d
  a0d1be:	mov    %r11,0x20(%rsp)
  a0d1c3:	jne    a0d290 <pp_compile_macro+0xae0>
  a0d1c9:	mov    $0x1,%al
  a0d1cb:	xor    %r8d,%r8d
  a0d1ce:	mov    %eax,0x18(%rsp)
  a0d1d2:	jmp    a0d305 <pp_compile_macro+0xb55>
  a0d1d7:	movzwl 0x2(%r15),%edi
  a0d1dc:	mov    $0x3f,%r11d
  a0d1e2:	mov    $0x1,%ebx
  a0d1e7:	movzwl %di,%r8d
  a0d1eb:	cmp    $0x3f,%r8d
  a0d1ef:	cmovb  %r8d,%r11d
  a0d1f3:	xor    %r10d,%r10d
  a0d1f6:	cmpb   $0x3,0x8(%r15)
  a0d1fb:	shlx   %r11,%rbx,%r11
  a0d200:	setne  %r9b
  a0d204:	cmovne %r11,%r10
  a0d208:	mov    0x68(%rsp),%r11
  a0d20d:	and    %al,%r9b
  a0d210:	or     %r10,(%r11)
  a0d213:	cmp    $0x1,%r9b
  a0d217:	jne    a0d4ac <pp_compile_macro+0xcfc>
  a0d21d:	mov    %r8d,%r9d
  a0d220:	shr    $0x6,%r9d
  a0d224:	mov    $0x1,%al
  a0d226:	mov    (%rcx,%r9,8),%r10
  a0d22a:	bt     %r8,%r10
  a0d22e:	jb     a0d4ac <pp_compile_macro+0xcfc>
  a0d234:	mov    $0x1,%r11d
  a0d23a:	movq   $0x0,0x10(%rsp)
  a0d243:	shlx   %r8,%r11,%r8
  a0d248:	or     %r8,%r10
  a0d24b:	mov    %r10,(%rcx,%r9,8)
  a0d24f:	mov    0xe00(%r13),%r8d
  a0d256:	cmp    $0x3ffffff,%r8
  a0d25d:	ja     a0d4aa <pp_compile_macro+0xcfa>
  a0d263:	mov    0x50(%rsp),%r9
  a0d268:	mov    (%r9),%r9
  a0d26b:	movw   $0x1,(%r9,%r8,8)
  a0d272:	mov    %di,0x2(%r9,%r8,8)
  a0d278:	mov    $0x1,%edi
  a0d27d:	movl   $0x0,0x4(%r9,%r8,8)
  a0d286:	mov    %rdi,0x10(%rsp)
  a0d28b:	jmp    a0d4ac <pp_compile_macro+0xcfc>
  a0d290:	mov    %r11d,%eax
  a0d293:	mov    %rax,%rdi
  a0d296:	and    $0x3,%rdi
  a0d29a:	mov    %rax,%rcx
  a0d29d:	je     a0d2f4 <pp_compile_macro+0xb44>
  a0d29f:	mov    $0xffff,%r8d
  a0d2a5:	mov    %rax,%rcx
  a0d2a8:	jmp    a0d2c1 <pp_compile_macro+0xb11>
  a0d2aa:	nopw   0x0(%rax,%rax,1)
  a0d2b0:	xor    %r9d,%r9d
  a0d2b3:	mov    %r9w,-0x6(%r15,%rcx,8)
  a0d2b9:	dec    %rcx
  a0d2bc:	dec    %rdi
  a0d2bf:	je     a0d2f4 <pp_compile_macro+0xb44>
  a0d2c1:	cmpb   $0x0,-0x8(%r15,%rcx,8)
  a0d2c7:	jne    a0d2b9 <pp_compile_macro+0xb09>
  a0d2c9:	cmp    %rax,%rcx
  a0d2cc:	jae    a0d2b0 <pp_compile_macro+0xb00>
  a0d2ce:	cmpb   $0x0,(%r15,%rcx,8)
  a0d2d3:	jne    a0d2b0 <pp_compile_macro+0xb00>
  a0d2d5:	mov    -0x4(%r15,%rcx,8),%r9d
  a0d2da:	inc    %r9d
  a0d2dd:	cmp    %r9d,0x4(%r15,%rcx,8)
  a0d2e2:	jne    a0d2b0 <pp_compile_macro+0xb00>
  a0d2e4:	movzwl 0x2(%r15,%rcx,8),%r9d
  a0d2ea:	inc    %r9w
  a0d2ee:	cmove  %r8d,%r9d
  a0d2f2:	jmp    a0d2b3 <pp_compile_macro+0xb03>
  a0d2f4:	cmp    $0x4,%r11d
  a0d2f8:	jae    a0d32a <pp_compile_macro+0xb7a>
  a0d2fa:	mov    $0x1,%r8b
  a0d2fd:	movl   $0x0,0x18(%rsp)
  a0d305:	mov    $0x1,%al
  a0d307:	mov    %eax,0x30(%rsp)
  a0d30b:	mov    $0x1,%al
  a0d30d:	mov    %eax,0xc(%rsp)
  a0d311:	jmp    a0c9b9 <pp_compile_macro+0x209>
  a0d316:	mov    0x58(%rbp),%rax
  a0d31a:	lea    -0x3db8ac(%rip),%rcx        # 631a75 <tier0_test_vector_type_class.classes+0x6412>
  a0d321:	mov    (%rax,%r14,4),%edx
  a0d325:	jmp    a0de49 <pp_compile_macro+0x1699>
  a0d32a:	lea    0x4(%rdx,%rsi,8),%rdx
  a0d32f:	add    $0xfffffffffffffffe,%rcx
  a0d333:	mov    $0xffff,%esi
  a0d338:	jmp    a0d354 <pp_compile_macro+0xba4>
  a0d33a:	nopw   0x0(%rax,%rax,1)
  a0d340:	xor    %edi,%edi
  a0d342:	mov    %di,-0x12(%rdx,%rcx,8)
  a0d347:	add    $0xfffffffffffffffc,%rcx
  a0d34b:	mov    $0x1,%r8b
  a0d34e:	cmp    $0xfffffffffffffffe,%rcx
  a0d352:	je     a0d2fd <pp_compile_macro+0xb4d>
  a0d354:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0d359:	je     a0d380 <pp_compile_macro+0xbd0>
  a0d35b:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d360:	je     a0d3ce <pp_compile_macro+0xc1e>
  a0d362:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d367:	je     a0d422 <pp_compile_macro+0xc72>
  a0d36d:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d372:	jne    a0d347 <pp_compile_macro+0xb97>
  a0d374:	jmp    a0d472 <pp_compile_macro+0xcc2>
  a0d379:	nopl   0x0(%rax)
  a0d380:	lea    0x2(%rcx),%rdi
  a0d384:	cmp    %rax,%rdi
  a0d387:	jae    a0d3c0 <pp_compile_macro+0xc10>
  a0d389:	cmpb   $0x0,0xc(%rdx,%rcx,8)
  a0d38e:	jne    a0d3c0 <pp_compile_macro+0xc10>
  a0d390:	mov    0x8(%rdx,%rcx,8),%edi
  a0d394:	inc    %edi
  a0d396:	cmp    %edi,0x10(%rdx,%rcx,8)
  a0d39a:	jne    a0d3c0 <pp_compile_macro+0xc10>
  a0d39c:	movzwl 0xe(%rdx,%rcx,8),%edi
  a0d3a1:	inc    %di
  a0d3a4:	cmove  %esi,%edi
  a0d3a7:	mov    %di,0x6(%rdx,%rcx,8)
  a0d3ac:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d3b1:	jne    a0d362 <pp_compile_macro+0xbb2>
  a0d3b3:	jmp    a0d3ce <pp_compile_macro+0xc1e>
  a0d3b5:	data16 cs nopw 0x0(%rax,%rax,1)
  a0d3c0:	xor    %edi,%edi
  a0d3c2:	mov    %di,0x6(%rdx,%rcx,8)
  a0d3c7:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d3cc:	jne    a0d362 <pp_compile_macro+0xbb2>
  a0d3ce:	lea    0x1(%rcx),%rdi
  a0d3d2:	cmp    %rax,%rdi
  a0d3d5:	jae    a0d410 <pp_compile_macro+0xc60>
  a0d3d7:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0d3dc:	jne    a0d410 <pp_compile_macro+0xc60>
  a0d3de:	mov    (%rdx,%rcx,8),%edi
  a0d3e1:	inc    %edi
  a0d3e3:	cmp    %edi,0x8(%rdx,%rcx,8)
  a0d3e7:	jne    a0d410 <pp_compile_macro+0xc60>
  a0d3e9:	movzwl 0x6(%rdx,%rcx,8),%edi
  a0d3ee:	inc    %di
  a0d3f1:	cmove  %esi,%edi
  a0d3f4:	mov    %di,-0x2(%rdx,%rcx,8)
  a0d3f9:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d3fe:	jne    a0d36d <pp_compile_macro+0xbbd>
  a0d404:	jmp    a0d422 <pp_compile_macro+0xc72>
  a0d406:	cs nopw 0x0(%rax,%rax,1)
  a0d410:	xor    %edi,%edi
  a0d412:	mov    %di,-0x2(%rdx,%rcx,8)
  a0d417:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d41c:	jne    a0d36d <pp_compile_macro+0xbbd>
  a0d422:	cmp    %rax,%rcx
  a0d425:	jae    a0d460 <pp_compile_macro+0xcb0>
  a0d427:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d42c:	jne    a0d460 <pp_compile_macro+0xcb0>
  a0d42e:	mov    -0x8(%rdx,%rcx,8),%edi
  a0d432:	inc    %edi
  a0d434:	cmp    %edi,(%rdx,%rcx,8)
  a0d437:	jne    a0d460 <pp_compile_macro+0xcb0>
  a0d439:	movzwl -0x2(%rdx,%rcx,8),%edi
  a0d43e:	inc    %di
  a0d441:	cmove  %esi,%edi
  a0d444:	mov    %di,-0xa(%rdx,%rcx,8)
  a0d449:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d44e:	jne    a0d347 <pp_compile_macro+0xb97>
  a0d454:	jmp    a0d472 <pp_compile_macro+0xcc2>
  a0d456:	cs nopw 0x0(%rax,%rax,1)
  a0d460:	xor    %edi,%edi
  a0d462:	mov    %di,-0xa(%rdx,%rcx,8)
  a0d467:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d46c:	jne    a0d347 <pp_compile_macro+0xb97>
  a0d472:	lea    -0x1(%rcx),%rdi
  a0d476:	cmp    %rax,%rdi
  a0d479:	jae    a0d340 <pp_compile_macro+0xb90>
  a0d47f:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d484:	jne    a0d340 <pp_compile_macro+0xb90>
  a0d48a:	mov    -0x10(%rdx,%rcx,8),%edi
  a0d48e:	inc    %edi
  a0d490:	cmp    %edi,-0x8(%rdx,%rcx,8)
  a0d494:	jne    a0d340 <pp_compile_macro+0xb90>
  a0d49a:	movzwl -0xa(%rdx,%rcx,8),%edi
  a0d49f:	inc    %di
  a0d4a2:	cmove  %esi,%edi
  a0d4a5:	jmp    a0d342 <pp_compile_macro+0xb92>
  a0d4aa:	xor    %eax,%eax
  a0d4ac:	cmp    $0x2,%r12d
  a0d4b0:	jb     a0d614 <pp_compile_macro+0xe64>
  a0d4b6:	xor    %r8d,%r8d
  a0d4b9:	testb  $0x2,0xb(%rsp)
  a0d4be:	mov    $0x2,%r10d
  a0d4c4:	mov    $0x1,%r9d
  a0d4ca:	mov    %r12d,%edi
  a0d4cd:	cmove  %r8,%rdx
  a0d4d1:	jmp    a0d500 <pp_compile_macro+0xd50>
  a0d4d3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d4e0:	mov    0x68(%rsp),%rax
  a0d4e5:	or     %rdx,(%rax)
  a0d4e8:	xor    %eax,%eax
  a0d4ea:	movzwl -0x6(%r15,%r10,8),%esi
  a0d4f0:	add    %r10d,%esi
  a0d4f3:	cmp    %rdi,%r10
  a0d4f6:	lea    0x1(%r10),%r10
  a0d4fa:	jae    a0d614 <pp_compile_macro+0xe64>
  a0d500:	movzbl -0x8(%r15,%r10,8),%r11d
  a0d506:	lea    -0x4(%r11),%ebx
  a0d50a:	cmp    $0x2,%ebx
  a0d50d:	jb     a0d4e0 <pp_compile_macro+0xd30>
  a0d50f:	cmp    $0x1,%r11d
  a0d513:	jne    a0d4f3 <pp_compile_macro+0xd43>
  a0d515:	cmpb   $0x3,-0x10(%r15,%r10,8)
  a0d51b:	je     a0d4f3 <pp_compile_macro+0xd43>
  a0d51d:	cmp    %rdi,%r10
  a0d520:	jae    a0d55b <pp_compile_macro+0xdab>
  a0d522:	mov    %esi,%r11d
  a0d525:	cmp    %r11,%r10
  a0d528:	je     a0d55b <pp_compile_macro+0xdab>
  a0d52a:	movzwl -0x6(%r15,%r10,8),%r11d
  a0d530:	mov    $0x3f,%r13d
  a0d536:	mov    $0x0,%r8d
  a0d53c:	movzwl %r11w,%ebx
  a0d540:	cmp    $0x3f,%ebx
  a0d543:	cmovb  %ebx,%r13d
  a0d547:	cmpb   $0x3,(%r15,%r10,8)
  a0d54c:	shlx   %r13,%r9,%r13
  a0d551:	setne  %r12b
  a0d555:	cmove  %r8,%r13
  a0d559:	jmp    a0d57a <pp_compile_macro+0xdca>
  a0d55b:	movzwl -0x6(%r15,%r10,8),%r11d
  a0d561:	mov    $0x3f,%r12d
  a0d567:	movzwl %r11w,%ebx
  a0d56b:	cmp    $0x3f,%ebx
  a0d56e:	cmovb  %ebx,%r12d
  a0d572:	shlx   %r12,%r9,%r13
  a0d577:	mov    $0x1,%r12b
  a0d57a:	mov    0x68(%rsp),%r8
  a0d57f:	and    %al,%r12b
  a0d582:	or     %r13,(%r8)
  a0d585:	cmp    $0x1,%r12b
  a0d589:	jne    a0d59e <pp_compile_macro+0xdee>
  a0d58b:	mov    %ebx,%r12d
  a0d58e:	shr    $0x6,%r12d
  a0d592:	mov    $0x1,%al
  a0d594:	mov    (%rcx,%r12,8),%r13
  a0d598:	bt     %rbx,%r13
  a0d59c:	jae    a0d5ad <pp_compile_macro+0xdfd>
  a0d59e:	mov    0x28(%rsp),%r13
  a0d5a3:	mov    0x20(%rsp),%r12
  a0d5a8:	jmp    a0d4f3 <pp_compile_macro+0xd43>
  a0d5ad:	shlx   %rbx,%r9,%rbx
  a0d5b2:	mov    0x10(%rsp),%r8
  a0d5b7:	or     %rbx,%r13
  a0d5ba:	mov    %r13,(%rcx,%r12,8)
  a0d5be:	mov    0x28(%rsp),%r13
  a0d5c3:	mov    0xe00(%r13),%ebx
  a0d5ca:	add    %r8d,%ebx
  a0d5cd:	cmp    $0x3ffffff,%ebx
  a0d5d3:	ja     a0d608 <pp_compile_macro+0xe58>
  a0d5d5:	mov    0x50(%rsp),%r12
  a0d5da:	mov    %ebx,%ebx
  a0d5dc:	inc    %r8d
  a0d5df:	mov    %r8,0x10(%rsp)
  a0d5e4:	mov    (%r12),%r12
  a0d5e8:	movw   $0x1,(%r12,%rbx,8)
  a0d5ef:	mov    %r11w,0x2(%r12,%rbx,8)
  a0d5f5:	movl   $0x0,0x4(%r12,%rbx,8)
  a0d5fe:	mov    0x20(%rsp),%r12
  a0d603:	jmp    a0d4f3 <pp_compile_macro+0xd43>
  a0d608:	mov    0x20(%rsp),%r12
  a0d60d:	xor    %eax,%eax
  a0d60f:	jmp    a0d4f3 <pp_compile_macro+0xd43>
  a0d614:	mov    $0xfffffffffffff560,%rcx
  a0d61b:	cmp    %fs:0x28(%rcx),%r14
  a0d620:	ja     a0de73 <pp_compile_macro+0x16c3>
  a0d626:	and    0x30(%rsp),%al
  a0d62a:	mov    %r14,%fs:0x28(%rcx)
  a0d62f:	xor    %ecx,%ecx
  a0d631:	mov    %eax,%esi
  a0d633:	and    0x1c(%rsp),%sil
  a0d638:	mov    %eax,%edx
  a0d63a:	cmp    $0x1,%sil
  a0d63e:	jne    a0d697 <pp_compile_macro+0xee7>
  a0d640:	mov    $0x1,%edi
  a0d645:	mov    %r12d,%esi
  a0d648:	xor    %ecx,%ecx
  a0d64a:	nopw   0x0(%rax,%rax,1)
  a0d650:	movzbl -0x8(%r15,%rdi,8),%r8d
  a0d656:	mov    $0x0,%r9d
  a0d65c:	cmp    $0x2,%r8b
  a0d660:	setb   %dl
  a0d663:	test   %r8b,%r8b
  a0d666:	jne    a0d685 <pp_compile_macro+0xed5>
  a0d668:	mov    0x50(%rbp),%r9
  a0d66c:	mov    -0x4(%r15,%rdi,8),%r10d
  a0d671:	movzbl (%r9,%r10,1),%r10d
  a0d676:	xor    %r9d,%r9d
  a0d679:	and    $0x7f,%r10b
  a0d67d:	cmp    $0x1,%r10b
  a0d681:	sete   %r9b
  a0d685:	add    %r9d,%ecx
  a0d688:	cmp    $0x1,%r8b
  a0d68c:	ja     a0d697 <pp_compile_macro+0xee7>
  a0d68e:	cmp    %rsi,%rdi
  a0d691:	lea    0x1(%rdi),%rdi
  a0d695:	jb     a0d650 <pp_compile_macro+0xea0>
  a0d697:	xor    %esi,%esi
  a0d699:	test   %dl,%dl
  a0d69b:	je     a0d6fb <pp_compile_macro+0xf4b>
  a0d69d:	mov    0x1c(%rsp),%r9d
  a0d6a2:	mov    $0x0,%edx
  a0d6a7:	cmp    $0x10000,%ecx
  a0d6ad:	jae    a0d702 <pp_compile_macro+0xf52>
  a0d6af:	mov    0x10(%rsp),%edi
  a0d6b3:	mov    0xe00(%r13),%edx
  a0d6ba:	mov    %ecx,%r8d
  a0d6bd:	add    %rdi,%r8
  a0d6c0:	add    %rdx,%r8
  a0d6c3:	cmp    $0x4000001,%r8
  a0d6ca:	setb   %dl
  a0d6cd:	mov    %edx,%edi
  a0d6cf:	and    %r9b,%dil
  a0d6d2:	cmp    $0x1,%dil
  a0d6d6:	jne    a0d702 <pp_compile_macro+0xf52>
  a0d6d8:	mov    %r12d,%r9d
  a0d6db:	mov    %r9d,%edi
  a0d6de:	and    $0x3,%edi
  a0d6e1:	lea    -0x1(%r12),%r8d
  a0d6e6:	cmp    $0x3,%r8d
  a0d6ea:	jae    a0d78b <pp_compile_macro+0xfdb>
  a0d6f0:	xor    %r10d,%r10d
  a0d6f3:	xor    %r8d,%r8d
  a0d6f6:	jmp    a0d98e <pp_compile_macro+0x11de>
  a0d6fb:	xor    %edx,%edx
  a0d6fd:	mov    0x1c(%rsp),%r9d
  a0d702:	test   %dl,%dl
  a0d704:	jne    a0d76c <pp_compile_macro+0xfbc>
  a0d706:	mov    $0x0,%r8d
  a0d70c:	mov    $0x0,%edi
  a0d711:	mov    $0x0,%r10d
  a0d717:	test   %al,%al
  a0d719:	je     a0d9fe <pp_compile_macro+0x124e>
  a0d71f:	mov    0x38(%rsp),%rsi
  a0d724:	cmp    $0x11,%r12d
  a0d728:	mov    $0x0,%edi
  a0d72d:	setb   %r10b
  a0d731:	and    0x4(%rsi),%r10b
  a0d735:	xor    %esi,%esi
  a0d737:	and    %r10b,%r9b
  a0d73a:	cmp    $0x1,%r9b
  a0d73e:	jne    a0d9fe <pp_compile_macro+0x124e>
  a0d744:	movzbl (%r15),%r11d
  a0d748:	xor    %edi,%edi
  a0d74a:	cmp    $0x2,%r11b
  a0d74e:	sete   %dil
  a0d752:	cmp    $0x3,%r11b
  a0d756:	jne    a0d8e1 <pp_compile_macro+0x1131>
  a0d75c:	mov    $0x1,%esi
  a0d761:	xor    %r8d,%r8d
  a0d764:	xor    %r10d,%r10d
  a0d767:	jmp    a0d9f4 <pp_compile_macro+0x1244>
  a0d76c:	xor    %r8d,%r8d
  a0d76f:	xor    %edi,%edi
  a0d771:	xor    %r10d,%r10d
  a0d774:	xor    %r9d,%r9d
  a0d777:	or     %dl,%r10b
  a0d77a:	mov    $0x0,%r11d
  a0d780:	jne    a0da10 <pp_compile_macro+0x1260>
  a0d786:	jmp    a0daf8 <pp_compile_macro+0x1348>
  a0d78b:	and    $0xfffffffc,%r9d
  a0d78f:	xor    %r10d,%r10d
  a0d792:	xor    %r8d,%r8d
  a0d795:	jmp    a0d7ad <pp_compile_macro+0xffd>
  a0d797:	nopw   0x0(%rax,%rax,1)
  a0d7a0:	add    $0x4,%r10
  a0d7a4:	cmp    %r10,%r9
  a0d7a7:	je     a0d985 <pp_compile_macro+0x11d5>
  a0d7ad:	cmpb   $0x0,(%r15,%r10,8)
  a0d7b2:	jne    a0d7f0 <pp_compile_macro+0x1040>
  a0d7b4:	mov    0x50(%rbp),%rbx
  a0d7b8:	mov    0x4(%r15,%r10,8),%r11d
  a0d7bd:	movzbl (%rbx,%r11,1),%ebx
  a0d7c2:	and    $0x7f,%bl
  a0d7c5:	cmp    $0x1,%bl
  a0d7c8:	jne    a0d7f0 <pp_compile_macro+0x1040>
  a0d7ca:	mov    0x10(%rsp),%r14
  a0d7cf:	mov    0xdf8(%r13),%rbx
  a0d7d6:	add    %r8d,%r14d
  a0d7d9:	add    0xe00(%r13),%r14d
  a0d7e0:	inc    %r8d
  a0d7e3:	movl   $0x0,(%rbx,%r14,8)
  a0d7eb:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d7f0:	cmpb   $0x0,0x8(%r15,%r10,8)
  a0d7f6:	jne    a0d840 <pp_compile_macro+0x1090>
  a0d7f8:	mov    0x50(%rbp),%rbx
  a0d7fc:	mov    0xc(%r15,%r10,8),%r11d
  a0d801:	movzbl (%rbx,%r11,1),%ebx
  a0d806:	and    $0x7f,%bl
  a0d809:	cmp    $0x1,%bl
  a0d80c:	jne    a0d840 <pp_compile_macro+0x1090>
  a0d80e:	mov    0x10(%rsp),%r14
  a0d813:	mov    0xdf8(%r13),%rbx
  a0d81a:	add    %r8d,%r14d
  a0d81d:	add    0xe00(%r13),%r14d
  a0d824:	inc    %r8d
  a0d827:	movl   $0x0,(%rbx,%r14,8)
  a0d82f:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d834:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d840:	cmpb   $0x0,0x10(%r15,%r10,8)
  a0d846:	jne    a0d890 <pp_compile_macro+0x10e0>
  a0d848:	mov    0x50(%rbp),%rbx
  a0d84c:	mov    0x14(%r15,%r10,8),%r11d
  a0d851:	movzbl (%rbx,%r11,1),%ebx
  a0d856:	and    $0x7f,%bl
  a0d859:	cmp    $0x1,%bl
  a0d85c:	jne    a0d890 <pp_compile_macro+0x10e0>
  a0d85e:	mov    0x10(%rsp),%r14
  a0d863:	mov    0xdf8(%r13),%rbx
  a0d86a:	add    %r8d,%r14d
  a0d86d:	add    0xe00(%r13),%r14d
  a0d874:	inc    %r8d
  a0d877:	movl   $0x0,(%rbx,%r14,8)
  a0d87f:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d884:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d890:	cmpb   $0x0,0x18(%r15,%r10,8)
  a0d896:	jne    a0d7a0 <pp_compile_macro+0xff0>
  a0d89c:	mov    0x50(%rbp),%rbx
  a0d8a0:	mov    0x1c(%r15,%r10,8),%r11d
  a0d8a5:	movzbl (%rbx,%r11,1),%ebx
  a0d8aa:	and    $0x7f,%bl
  a0d8ad:	cmp    $0x1,%bl
  a0d8b0:	jne    a0d7a0 <pp_compile_macro+0xff0>
  a0d8b6:	mov    0x10(%rsp),%r14
  a0d8bb:	mov    0xdf8(%r13),%rbx
  a0d8c2:	add    %r8d,%r14d
  a0d8c5:	add    0xe00(%r13),%r14d
  a0d8cc:	inc    %r8d
  a0d8cf:	movl   $0x0,(%rbx,%r14,8)
  a0d8d7:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d8dc:	jmp    a0d7a0 <pp_compile_macro+0xff0>
  a0d8e1:	setbe  %r10b
  a0d8e5:	xor    %esi,%esi
  a0d8e7:	cmp    $0x3,%r11b
  a0d8eb:	ja     a0d9f1 <pp_compile_macro+0x1241>
  a0d8f1:	cmp    $0x2,%r12d
  a0d8f5:	jb     a0d9f1 <pp_compile_macro+0x1241>
  a0d8fb:	mov    0x60(%rsp),%rsi
  a0d900:	movzbl 0x8(%r15),%r9d
  a0d905:	dec    %esi
  a0d907:	cmp    $0x4,%r9b
  a0d90b:	setb   %r10b
  a0d90f:	mov    %rsi,0x60(%rsp)
  a0d914:	xor    %esi,%esi
  a0d916:	cmp    $0x3,%r9b
  a0d91a:	jne    a0dd29 <pp_compile_macro+0x1579>
  a0d920:	mov    $0x2,%esi
  a0d925:	xor    %r8d,%r8d
  a0d928:	cmp    $0x3,%r12d
  a0d92c:	jb     a0dd26 <pp_compile_macro+0x1576>
  a0d932:	cmp    $0x2,%r11b
  a0d936:	movzbl 0x10(%r15),%r11d
  a0d93b:	setb   %r8b
  a0d93f:	cmp    $0x2,%r11b
  a0d943:	setb   %r10b
  a0d947:	and    %r8b,%r10b
  a0d94a:	mov    $0x1,%r8d
  a0d950:	cmp    $0x1,%r10b
  a0d954:	jne    a0dd26 <pp_compile_macro+0x1576>
  a0d95a:	testb  $0x2,0xb(%rsp)
  a0d95f:	mov    $0x1,%r10b
  a0d962:	je     a0dd29 <pp_compile_macro+0x1579>
  a0d968:	cmp    $0x1,%r11b
  a0d96c:	jne    a0dd29 <pp_compile_macro+0x1579>
  a0d972:	movzwl 0x12(%r15),%r10d
  a0d977:	cmp    %r10d,0x60(%rsp)
  a0d97c:	setne  %r10b
  a0d980:	jmp    a0dd29 <pp_compile_macro+0x1579>
  a0d985:	test   %rdi,%rdi
  a0d988:	je     a0d6fd <pp_compile_macro+0xf4d>
  a0d98e:	lea    0x4(%r15,%r10,8),%r9
  a0d993:	xor    %r10d,%r10d
  a0d996:	jmp    a0d9ac <pp_compile_macro+0x11fc>
  a0d998:	nopl   0x0(%rax,%rax,1)
  a0d9a0:	inc    %r10
  a0d9a3:	cmp    %r10,%rdi
  a0d9a6:	je     a0d6fd <pp_compile_macro+0xf4d>
  a0d9ac:	cmpb   $0x0,-0x4(%r9,%r10,8)
  a0d9b2:	jne    a0d9a0 <pp_compile_macro+0x11f0>
  a0d9b4:	mov    0x50(%rbp),%rbx
  a0d9b8:	mov    (%r9,%r10,8),%r11d
  a0d9bc:	movzbl (%rbx,%r11,1),%ebx
  a0d9c1:	and    $0x7f,%bl
  a0d9c4:	cmp    $0x1,%bl
  a0d9c7:	jne    a0d9a0 <pp_compile_macro+0x11f0>
  a0d9c9:	mov    0x10(%rsp),%r14
  a0d9ce:	mov    0xdf8(%r13),%rbx
  a0d9d5:	add    %r8d,%r14d
  a0d9d8:	add    0xe00(%r13),%r14d
  a0d9df:	inc    %r8d
  a0d9e2:	movl   $0x0,(%rbx,%r14,8)
  a0d9ea:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d9ef:	jmp    a0d9a0 <pp_compile_macro+0x11f0>
  a0d9f1:	xor    %r8d,%r8d
  a0d9f4:	mov    0x28(%rsp),%r13
  a0d9f9:	mov    0x20(%rsp),%r12
  a0d9fe:	xor    %r9d,%r9d
  a0da01:	or     %dl,%r10b
  a0da04:	mov    $0x0,%r11d
  a0da0a:	je     a0daf8 <pp_compile_macro+0x1348>
  a0da10:	mov    0xe18(%r13),%r10
  a0da17:	test   %r10,%r10
  a0da1a:	je     a0daf8 <pp_compile_macro+0x1348>
  a0da20:	cmp    $0x10,%r12d
  a0da24:	ja     a0daf8 <pp_compile_macro+0x1348>
  a0da2a:	cmpw   $0x10,0x70(%rsp)
  a0da30:	ja     a0daf8 <pp_compile_macro+0x1348>
  a0da36:	mov    0xe20(%r13),%ebx
  a0da3d:	cmp    $0xfffff,%rbx
  a0da44:	ja     a0daf8 <pp_compile_macro+0x1348>
  a0da4a:	mov    %esi,%r14d
  a0da4d:	lea    (%rsi,%rsi,1),%r11d
  a0da51:	shr    $1,%r14d
  a0da54:	imul   $0x110,%rbx,%rbx
  a0da5b:	mov    %r12,%r13
  a0da5e:	vpxor  %xmm0,%xmm0,%xmm0
  a0da62:	andn   %r11d,%r14d,%r12d
  a0da67:	cmpb   $0x0,0x18(%rsp)
  a0da6c:	vmovdqu64 %zmm0,0xc0(%r10,%rbx,1)
  a0da74:	vmovdqu64 %zmm0,0x80(%r10,%rbx,1)
  a0da7c:	vmovdqu64 %zmm0,0x40(%r10,%rbx,1)
  a0da84:	vmovdqu64 %zmm0,(%r10,%rbx,1)
  a0da8b:	movw   $0x0,0x100(%r10,%rbx,1)
  a0da96:	mov    %si,0x102(%r10,%rbx,1)
  a0da9f:	mov    %r8w,0x104(%r10,%rbx,1)
  a0daa8:	mov    %r12w,0x106(%r10,%rbx,1)
  a0dab1:	mov    %di,0x108(%r10,%rbx,1)
  a0daba:	mov    %r13b,0x10a(%r10,%rbx,1)
  a0dac2:	movl   $0x0,0x10b(%r10,%rbx,1)
  a0dace:	movb   $0x0,0x10f(%r10,%rbx,1)
  a0dad7:	je     a0dba4 <pp_compile_macro+0x13f4>
  a0dadd:	mov    0x28(%rsp),%r13
  a0dae2:	mov    0x20(%rsp),%r12
  a0dae7:	mov    0xe20(%r13),%r11d
  a0daee:	inc    %r11d
  a0daf1:	mov    %r11d,0xe20(%r13)
  a0daf8:	mov    0x38(%rsp),%r8
  a0dafd:	mov    %eax,%esi
  a0daff:	mov    %edx,%edi
  a0db01:	shl    $0x5,%sil
  a0db05:	shl    $0x7,%dil
  a0db09:	or     %sil,%dil
  a0db0c:	mov    %r11d,0x34(%r8)
  a0db10:	or     %dil,0x4(%r8)
  a0db14:	test   %al,%al
  a0db16:	mov    0x10(%rsp),%rax
  a0db1b:	cmove  %r9d,%eax
  a0db1f:	test   %dl,%dl
  a0db21:	cmove  %r9d,%ecx
  a0db25:	mov    %ax,0xa(%r8)
  a0db2a:	mov    %cx,0xc(%r8)
  a0db2f:	add    %eax,%ecx
  a0db31:	mov    0x30(%rsp),%eax
  a0db35:	add    %ecx,0xe00(%r13)
  a0db3c:	shl    $0x2,%al
  a0db3f:	or     %al,0x4(%r8)
  a0db43:	cmpb   $0x0,0xc(%rsp)
  a0db48:	cmove  %r9d,%r12d
  a0db4c:	mov    %r12d,0x2c(%r8)
  a0db50:	jne    a0db60 <pp_compile_macro+0x13b0>
  a0db52:	mov    0x58(%rsp),%rax
  a0db57:	mov    (%rax),%eax
  a0db59:	mov    %eax,0xe00(%r13)
  a0db60:	mov    0x40(%rsp),%rcx
  a0db65:	test   %rcx,%rcx
  a0db68:	je     a0db8b <pp_compile_macro+0x13db>
  a0db6a:	mov    0x98(%rcx),%rax
  a0db71:	test   %rax,%rax
  a0db74:	je     a0db8b <pp_compile_macro+0x13db>
  a0db76:	mov    0xa0(%rcx),%rcx
  a0db7d:	cmp    0x8(%rax),%rcx
  a0db81:	ja     a0de73 <pp_compile_macro+0x16c3>
  a0db87:	mov    %rcx,0x8(%rax)
  a0db8b:	mov    0xc(%rsp),%eax
  a0db8f:	add    $0x88,%rsp
  a0db96:	pop    %rbx
  a0db97:	pop    %r12
  a0db99:	pop    %r13
  a0db9b:	pop    %r14
  a0db9d:	pop    %r15
  a0db9f:	pop    %rbp
  a0dba0:	vzeroupper
  a0dba3:	ret
  a0dba4:	add    %rbx,%r10
  a0dba7:	mov    0x20(%rsp),%rbx
  a0dbac:	or     %esi,%r11d
  a0dbaf:	xor    %edi,%edi
  a0dbb1:	or     %r14d,%r11d
  a0dbb4:	jmp    a0dbce <pp_compile_macro+0x141e>
  a0dbb6:	cs nopw 0x0(%rax,%rax,1)
  a0dbc0:	movzwl 0x2(%r15,%rsi,8),%edi
  a0dbc6:	lea    0x1(%rsi,%rdi,1),%edi
  a0dbca:	cmp    %ebx,%edi
  a0dbcc:	jae    a0dc09 <pp_compile_macro+0x1459>
  a0dbce:	mov    %dil,0x10b(%r10)
  a0dbd5:	mov    %edi,%esi
  a0dbd7:	xor    %r8d,%r8d
  a0dbda:	cmpb   $0x3,(%r15,%rsi,8)
  a0dbdf:	sete   %r8b
  a0dbe3:	sub    %r8d,%edi
  a0dbe6:	mov    %dil,0x10c(%r10)
  a0dbed:	movzbl (%r15,%rsi,8),%r8d
  a0dbf2:	test   %r8b,%r8b
  a0dbf5:	je     a0dbc0 <pp_compile_macro+0x1410>
  a0dbf7:	xor    %edi,%edi
  a0dbf9:	cmp    $0x3,%r8b
  a0dbfd:	sete   %dil
  a0dc01:	lea    0x1(%rsi,%rdi,1),%edi
  a0dc05:	cmp    %ebx,%edi
  a0dc07:	jb     a0dbce <pp_compile_macro+0x141e>
  a0dc09:	mov    $0x1,%r8d
  a0dc0f:	mov    %ebx,%esi
  a0dc11:	xor    %edi,%edi
  a0dc13:	jmp    a0dc34 <pp_compile_macro+0x1484>
  a0dc15:	data16 cs nopw 0x0(%rax,%rax,1)
  a0dc20:	or     %r12w,0xfc(%r10)
  a0dc28:	inc    %rdi
  a0dc2b:	cmp    %rdi,%rsi
  a0dc2e:	je     a0dadd <pp_compile_macro+0x132d>
  a0dc34:	mov    0x4(%r15,%rdi,8),%r14d
  a0dc39:	mov    0x50(%rbp),%rbx
  a0dc3d:	movzbl (%rbx,%r14,1),%ebx
  a0dc42:	mov    %r14d,%r13d
  a0dc45:	shr    $0x6,%r13d
  a0dc49:	and    $0x7f,%bl
  a0dc4c:	mov    %bl,0xc0(%r10,%rdi,1)
  a0dc54:	mov    0x68(%rbp),%r12
  a0dc58:	mov    (%r12,%r13,8),%r12
  a0dc5c:	bt     %r14,%r12
  a0dc60:	setb   %r12b
  a0dc64:	or     $0x8,%r12b
  a0dc68:	mov    %r12b,0xd0(%r10,%rdi,1)
  a0dc70:	cmp    $0x1,%bl
  a0dc73:	jne    a0dc90 <pp_compile_macro+0x14e0>
  a0dc75:	mov    0x60(%rbp),%r12
  a0dc79:	mov    0x38(%rsp),%r13
  a0dc7e:	mov    (%r12,%r14,4),%r12d
  a0dc82:	jmp    a0dca1 <pp_compile_macro+0x14f1>
  a0dc84:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0dc90:	mov    0x60(%rbp),%r12
  a0dc94:	mov    0x38(%rsp),%r13
  a0dc99:	mov    (%r12,%r14,4),%r12d
  a0dc9d:	add    0x14(%r13),%r12d
  a0dca1:	mov    %r12d,(%r10,%rdi,4)
  a0dca5:	mov    0x58(%rbp),%r12
  a0dca9:	mov    (%r12,%r14,4),%r14d
  a0dcad:	mov    $0x0,%r12d
  a0dcb3:	add    0x14(%r13),%r14d
  a0dcb7:	mov    %r14d,0x40(%r10,%rdi,4)
  a0dcbc:	xor    %r14d,%r14d
  a0dcbf:	movzbl (%r15,%rdi,8),%r13d
  a0dcc4:	dec    %r13b
  a0dcc7:	cmp    $0x1,%r13b
  a0dccb:	ja     a0dcd3 <pp_compile_macro+0x1523>
  a0dccd:	movzbl 0x2(%r15,%rdi,8),%r12d
  a0dcd3:	mov    %r12b,0xe0(%r10,%rdi,1)
  a0dcdb:	shlx   %edi,%r8d,%r12d
  a0dce0:	cmpb   $0x1,(%r15,%rdi,8)
  a0dce5:	mov    %r12d,%r13d
  a0dce8:	je     a0dced <pp_compile_macro+0x153d>
  a0dcea:	xor    %r13d,%r13d
  a0dced:	or     %r13w,0xf8(%r10)
  a0dcf5:	xor    $0x1,%bl
  a0dcf8:	mov    %r12d,%r13d
  a0dcfb:	testb  $0x1,0x1(%r15,%rdi,8)
  a0dd01:	cmove  %r14d,%r13d
  a0dd05:	or     %r13w,0xfa(%r10)
  a0dd0d:	test   %r11d,%r12d
  a0dd10:	cmovne %r14d,%r12d
  a0dd14:	or     (%r15,%rdi,8),%bl
  a0dd18:	je     a0dc20 <pp_compile_macro+0x1470>
  a0dd1e:	xor    %r12d,%r12d
  a0dd21:	jmp    a0dc20 <pp_compile_macro+0x1470>
  a0dd26:	xor    %r10d,%r10d
  a0dd29:	xor    %r11d,%r11d
  a0dd2c:	cmp    $0x2,%r9b
  a0dd30:	sete   %r11b
  a0dd34:	lea    (%rdi,%r11,2),%edi
  a0dd38:	test   %r10b,%r10b
  a0dd3b:	je     a0d9f4 <pp_compile_macro+0x1244>
  a0dd41:	cmp    $0x3,%r12d
  a0dd45:	jb     a0d9f4 <pp_compile_macro+0x1244>
  a0dd4b:	mov    %r12d,%r9d
  a0dd4e:	mov    $0x2,%r11d
  a0dd54:	mov    $0x3,%r12d
  a0dd5a:	nopw   0x0(%rax,%rax,1)
  a0dd60:	movzbl -0x8(%r15,%r12,8),%r13d
  a0dd66:	cmp    $0x3,%r13b
  a0dd6a:	jne    a0ddb0 <pp_compile_macro+0x1600>
  a0dd6c:	cmp    %r9,%r12
  a0dd6f:	jae    a0ddd0 <pp_compile_macro+0x1620>
  a0dd71:	cmpb   $0x2,-0x10(%r15,%r12,8)
  a0dd77:	movzbl (%r15,%r12,8),%ebx
  a0dd7c:	setb   %r10b
  a0dd80:	cmp    $0x2,%bl
  a0dd83:	setb   %r14b
  a0dd87:	and    %r10b,%r14b
  a0dd8a:	cmp    $0x1,%r14b
  a0dd8e:	jne    a0ddda <pp_compile_macro+0x162a>
  a0dd90:	testb  $0x2,0xb(%rsp)
  a0dd95:	mov    $0x1,%r10b
  a0dd98:	je     a0dddd <pp_compile_macro+0x162d>
  a0dd9a:	cmp    $0x1,%bl
  a0dd9d:	jne    a0dddd <pp_compile_macro+0x162d>
  a0dd9f:	movzwl 0x2(%r15,%r12,8),%r10d
  a0dda5:	cmp    %r10d,0x60(%rsp)
  a0ddaa:	setne  %r10b
  a0ddae:	jmp    a0dddd <pp_compile_macro+0x162d>
  a0ddb0:	lea    -0x1(%r12),%ebx
  a0ddb5:	mov    $0x1,%r14d
  a0ddbb:	setbe  %r10b
  a0ddbf:	inc    %r11
  a0ddc2:	shlx   %ebx,%r14d,%ebx
  a0ddc7:	jmp    a0de07 <pp_compile_macro+0x1657>
  a0ddc9:	nopl   0x0(%rax)
  a0ddd0:	lea    -0x1(%r12),%r14d
  a0ddd5:	xor    %r10d,%r10d
  a0ddd8:	jmp    a0ddf6 <pp_compile_macro+0x1646>
  a0ddda:	xor    %r10d,%r10d
  a0dddd:	lea    -0x3(%r12),%ebx
  a0dde2:	movzbl %bl,%ebx
  a0dde5:	bt     %ebx,%esi
  a0dde8:	jb     a0ddf3 <pp_compile_macro+0x1643>
  a0ddea:	lea    -0x2(%r12),%ebx
  a0ddef:	bts    %ebx,%r8d
  a0ddf3:	mov    %r11d,%r14d
  a0ddf6:	mov    $0x1,%ebx
  a0ddfb:	bts    %r14d,%esi
  a0ddff:	inc    %r11
  a0de02:	shlx   %r14d,%ebx,%ebx
  a0de07:	cmp    $0x2,%r13b
  a0de0b:	mov    $0x0,%r14d
  a0de11:	cmovne %r14d,%ebx
  a0de15:	or     %ebx,%edi
  a0de17:	test   %r10b,%r10b
  a0de1a:	je     a0d9f4 <pp_compile_macro+0x1244>
  a0de20:	cmp    %r9,%r12
  a0de23:	lea    0x1(%r12),%r12
  a0de28:	jb     a0dd60 <pp_compile_macro+0x15b0>
  a0de2e:	jmp    a0d9f4 <pp_compile_macro+0x1244>
  a0de33:	mov    0x58(%rbp),%rax
  a0de37:	cmp    %r15d,%r12d
  a0de3a:	lea    -0x412319(%rip),%rcx        # 5fbb28 <parse_test_openers+0x2f5e8>
  a0de41:	adc    $0x0,%r13d
  a0de45:	mov    (%rax,%r13,4),%edx
  a0de49:	add    0x14(%r9),%edx
  a0de4d:	mov    0x28(%rsp),%rbx
  a0de52:	mov    $0x1,%esi
  a0de57:	mov    %rbx,%rdi
  a0de5a:	xor    %eax,%eax
  a0de5c:	vzeroupper
  a0de5f:	call   98b970 <pp_diagnose>
  a0de64:	mov    0x40(%rsp),%r10
  a0de69:	mov    0x58(%rsp),%rcx
  a0de6e:	jmp    a0c96f <pp_compile_macro+0x1bf>
  a0de73:	lea    -0x2dab78(%rip),%rdi        # 733302 <pp_string_value.meaning+0x7f660>
  a0de7a:	lea    -0x32b39a(%rip),%rsi        # 6e2ae7 <pp_string_value.meaning+0x2ee45>
  a0de81:	lea    -0x32b386(%rip),%rcx        # 6e2b02 <pp_string_value.meaning+0x2ee60>
  a0de88:	mov    $0xce,%edx
  a0de8d:	vzeroupper
  a0de90:	call   7cded0 <__assert_fail@plt>
