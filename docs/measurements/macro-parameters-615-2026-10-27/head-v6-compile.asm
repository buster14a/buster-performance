
head-v6/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000a0c840 <pp_compile_macro>:
  a0c840:	push   %rbp
  a0c841:	push   %r15
  a0c843:	push   %r14
  a0c845:	push   %r13
  a0c847:	push   %r12
  a0c849:	push   %rbx
  a0c84a:	sub    $0x88,%rsp
  a0c851:	mov    0xde8(%rdi),%rax
  a0c858:	mov    %esi,%ecx
  a0c85a:	shl    $0x6,%rcx
  a0c85e:	mov    %rdi,%rbx
  a0c861:	mov    %rdi,0x28(%rsp)
  a0c866:	mov    0x10(%rax,%rcx,1),%edx
  a0c86a:	movzwl 0x8(%rax,%rcx,1),%r14d
  a0c870:	mov    0x1c(%rax,%rcx,1),%esi
  a0c874:	lea    (%rax,%rcx,1),%r9
  a0c878:	movzbl 0x4(%rax,%rcx,1),%r15d
  a0c87e:	mov    %r9,0x38(%rsp)
  a0c883:	imul   $0xe8,%rdx,%rbp
  a0c88a:	add    0xb80(%rdi),%rbp
  a0c891:	test   %r14d,%r14d
  a0c894:	mov    %r14d,%edx
  a0c897:	mov    %rdx,0x70(%rsp)
  a0c89c:	mov    0x18(%rax,%rcx,1),%edx
  a0c8a0:	mov    0xe10(%rdi),%ecx
  a0c8a6:	mov    %r14,0x60(%rsp)
  a0c8ab:	mov    %r15b,0xb(%rsp)
  a0c8b0:	setne  %r11b
  a0c8b4:	add    0xe00(%rdi),%esi
  a0c8ba:	sub    %edx,%esi
  a0c8bc:	cmp    $0x4000001,%esi
  a0c8c2:	jae    a0c954 <pp_compile_macro+0x114>
  a0c8c8:	lea    (%rcx,%r14,1),%eax
  a0c8cc:	and    %r15b,%r11b
  a0c8cf:	mov    %ecx,0x30(%r9)
  a0c8d3:	cmp    $0x4000001,%eax
  a0c8d8:	setb   %sil
  a0c8dc:	and    %r11b,%sil
  a0c8df:	cmp    $0x1,%sil
  a0c8e3:	jne    a0c961 <pp_compile_macro+0x121>
  a0c8e5:	mov    0x20(%r9),%ecx
  a0c8e9:	cmp    %edx,%ecx
  a0c8eb:	jae    a0c961 <pp_compile_macro+0x121>
  a0c8ed:	xor    %edx,%edx
  a0c8ef:	jmp    a0c927 <pp_compile_macro+0xe7>
  a0c8f1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0c900:	mov    0x60(%rbp),%rsi
  a0c904:	mov    (%rsi,%rcx,4),%esi
  a0c907:	mov    0x30(%r9),%r8d
  a0c90b:	mov    0xe08(%rbx),%rdi
  a0c912:	add    %edx,%r8d
  a0c915:	inc    %edx
  a0c917:	mov    %esi,(%rdi,%r8,4)
  a0c91b:	mov    0x18(%r9),%esi
  a0c91f:	inc    %rcx
  a0c922:	cmp    %rsi,%rcx
  a0c925:	jae    a0c961 <pp_compile_macro+0x121>
  a0c927:	mov    0x50(%rbp),%rsi
  a0c92b:	movzbl (%rsi,%rcx,1),%edi
  a0c92f:	and    $0x7f,%edi
  a0c932:	cmp    $0x1,%edi
  a0c935:	je     a0c900 <pp_compile_macro+0xc0>
  a0c937:	cmp    $0x14,%edi
  a0c93a:	jne    a0c91b <pp_compile_macro+0xdb>
  a0c93c:	lea    -0x1(%rcx),%edi
  a0c93f:	movzbl (%rsi,%rdi,1),%edi
  a0c943:	mov    $0xaa,%esi
  a0c948:	and    $0x7f,%dil
  a0c94c:	cmp    $0x1,%dil
  a0c950:	jne    a0c907 <pp_compile_macro+0xc7>
  a0c952:	jmp    a0c91b <pp_compile_macro+0xdb>
  a0c954:	mov    %ecx,0x30(%r9)
  a0c958:	add    %r14d,0xe10(%rbx)
  a0c95f:	jmp    a0c9dd <pp_compile_macro+0x19d>
  a0c961:	add    %r14d,0xe10(%rbx)
  a0c968:	cmp    $0x4000000,%eax
  a0c96d:	ja     a0c9dd <pp_compile_macro+0x19d>
  a0c96f:	mov    0x30(%r9),%edi
  a0c973:	mov    %r11b,0x20(%rsp)
  a0c978:	shl    $0x2,%rdi
  a0c97c:	add    0xe08(%rbx),%rdi
  a0c983:	mov    %rdi,0x30(%rsp)
  a0c988:	cmp    $0x11,%r14w
  a0c98d:	jb     a0cc72 <pp_compile_macro+0x432>
  a0c993:	movzbl 0x278(%rbx),%edx
  a0c99a:	mov    %r14d,%esi
  a0c99d:	call   a130c0 <pp_parameter_index_build>
  a0c9a2:	mov    0x30(%rsp),%rdi
  a0c9a7:	movzbl 0x20(%rsp),%r11d
  a0c9ad:	mov    0x38(%rsp),%r9
  a0c9b2:	mov    %rax,%r10
  a0c9b5:	test   %rax,%rax
  a0c9b8:	jne    a0cc75 <pp_compile_macro+0x435>
  a0c9be:	mov    0x24(%r9),%edx
  a0c9c2:	lea    -0x3f8c97(%rip),%rcx        # 613d32 <parse_test_openers+0x47872>
  a0c9c9:	mov    $0x2,%esi
  a0c9ce:	mov    %rbx,%rdi
  a0c9d1:	xor    %eax,%eax
  a0c9d3:	call   98b970 <pp_diagnose>
  a0c9d8:	mov    0x38(%rsp),%r9
  a0c9dd:	mov    0xe00(%rbx),%eax
  a0c9e3:	lea    0x38(%r9),%rdx
  a0c9e7:	lea    0x28(%r9),%rcx
  a0c9eb:	xor    %r10d,%r10d
  a0c9ee:	mov    %rdx,0x68(%rsp)
  a0c9f3:	mov    %eax,0x28(%r9)
  a0c9f7:	movq   $0x0,0x38(%r9)
  a0c9ff:	mov    (%rcx),%r15d
  a0ca02:	mov    %rcx,0x58(%rsp)
  a0ca07:	mov    0xe00(%rbx),%ecx
  a0ca0d:	lea    0xdf8(%rbx),%rax
  a0ca14:	movl   $0x0,0x30(%rsp)
  a0ca1c:	movl   $0x0,0xc(%rsp)
  a0ca24:	mov    %rax,0x50(%rsp)
  a0ca29:	mov    %r15d,%eax
  a0ca2c:	shl    $0x3,%r15
  a0ca30:	add    0xdf8(%rbx),%r15
  a0ca37:	sub    %eax,%ecx
  a0ca39:	setne  %r8b
  a0ca3d:	sete   %al
  a0ca40:	mov    %rcx,0x20(%rsp)
  a0ca45:	mov    %eax,0x18(%rsp)
  a0ca49:	mov    $0xfffffffffffff560,%rcx
  a0ca50:	mov    %r10,0x40(%rsp)
  a0ca55:	mov    %r8d,0x1c(%rsp)
  a0ca5a:	mov    %fs:0x20(%rcx),%r12
  a0ca5f:	test   %r12,%r12
  a0ca62:	je     a0ca6e <pp_compile_macro+0x22e>
  a0ca64:	mov    %fs:0x28(%rcx),%r14
  a0ca69:	jmp    a0cb1e <pp_compile_macro+0x2de>
  a0ca6e:	movabs $0x1000200000,%r13
  a0ca78:	mov    $0x3,%edx
  a0ca7d:	mov    $0x4022,%ecx
  a0ca82:	mov    $0xffffffff,%r8d
  a0ca88:	xor    %r14d,%r14d
  a0ca8b:	xor    %edi,%edi
  a0ca8d:	xor    %r9d,%r9d
  a0ca90:	mov    %r13,%rsi
  a0ca93:	vzeroupper
  a0ca96:	call   7ce920 <mmap@plt>
  a0ca9b:	cmp    $0xffffffffffffffff,%rax
  a0ca9f:	je     a0caf2 <pp_compile_macro+0x2b2>
  a0caa1:	lea    0x20ffff(%rax),%r12
  a0caa8:	mov    $0xf,%edx
  a0caad:	mov    %rax,%rdi
  a0cab0:	and    $0xffffffffffe00000,%r12
  a0cab7:	mov    %r12,%r14
  a0caba:	sub    %rax,%r14
  a0cabd:	mov    %r14,%rsi
  a0cac0:	lea    -0x10000(%r14),%rbx
  a0cac7:	call   7ce8d0 <madvise@plt>
  a0cacc:	mov    %r13,%rsi
  a0cacf:	sub    %r14,%rsi
  a0cad2:	mov    $0xe,%edx
  a0cad7:	mov    %r12,%rdi
  a0cada:	call   7ce8d0 <madvise@plt>
  a0cadf:	add    $0xffffffffffe00000,%r13
  a0cae6:	add    $0xffffffffffff0000,%r12
  a0caed:	mov    %r13,%r14
  a0caf0:	jmp    a0caf7 <pp_compile_macro+0x2b7>
  a0caf2:	xor    %r12d,%r12d
  a0caf5:	xor    %ebx,%ebx
  a0caf7:	mov    $0xfffffffffffff560,%rcx
  a0cafe:	mov    0x1c(%rsp),%r8d
  a0cb03:	mov    %r12,%fs:0x20(%rcx)
  a0cb08:	movq   $0x0,%fs:0x28(%rcx)
  a0cb11:	mov    %r14,%fs:0x30(%rcx)
  a0cb16:	xor    %r14d,%r14d
  a0cb19:	mov    %rbx,%fs:0x38(%rcx)
  a0cb1e:	lea    0x7(%r14,%r12,1),%r13
  a0cb23:	lea    (%r14,%r12,1),%rax
  a0cb27:	and    $0xfffffffffffffff8,%r13
  a0cb2b:	cmp    %rax,%r13
  a0cb2e:	jae    a0cb54 <pp_compile_macro+0x314>
  a0cb30:	mov    0x20(%rsp),%r12
  a0cb35:	movq   $0x0,0x10(%rsp)
  a0cb3e:	xor    %eax,%eax
  a0cb40:	xor    %ecx,%ecx
  a0cb42:	mov    0xc(%rsp),%edx
  a0cb46:	and    %r8b,%dl
  a0cb49:	cmp    $0x1,%dl
  a0cb4c:	jne    a0d21c <pp_compile_macro+0x9dc>
  a0cb52:	jmp    a0cbcb <pp_compile_macro+0x38b>
  a0cb54:	mov    %fs:0x30(%rcx),%rdi
  a0cb59:	mov    %r13,%rsi
  a0cb5c:	sub    %r12,%rsi
  a0cb5f:	xor    %ecx,%ecx
  a0cb61:	mov    $0x0,%eax
  a0cb66:	movq   $0x0,0x10(%rsp)
  a0cb6f:	sub    %rsi,%rdi
  a0cb72:	jb     a0d207 <pp_compile_macro+0x9c7>
  a0cb78:	mov    0x70(%rsp),%rdx
  a0cb7d:	mov    0x20(%rsp),%r12
  a0cb82:	add    $0x3f,%edx
  a0cb85:	shr    $0x3,%edx
  a0cb88:	and    $0xfffffff8,%edx
  a0cb8b:	cmp    %rdi,%rdx
  a0cb8e:	ja     a0cbbb <pp_compile_macro+0x37b>
  a0cb90:	mov    $0xfffffffffffff560,%rax
  a0cb97:	add    %rdx,%rsi
  a0cb9a:	mov    %rsi,%fs:0x28(%rax)
  a0cb9f:	test   %r13,%r13
  a0cba2:	je     a0cb3e <pp_compile_macro+0x2fe>
  a0cba4:	mov    %r13,%rdi
  a0cba7:	xor    %esi,%esi
  a0cba9:	vzeroupper
  a0cbac:	call   7ce710 <memset@plt>
  a0cbb1:	mov    0x1c(%rsp),%r8d
  a0cbb6:	mov    $0x1,%al
  a0cbb8:	mov    %r13,%rcx
  a0cbbb:	mov    0xc(%rsp),%edx
  a0cbbf:	and    %r8b,%dl
  a0cbc2:	cmp    $0x1,%dl
  a0cbc5:	jne    a0d21c <pp_compile_macro+0x9dc>
  a0cbcb:	mov    0x60(%rsp),%rdx
  a0cbd0:	movzbl (%r15),%edi
  a0cbd4:	mov    0x28(%rsp),%r13
  a0cbd9:	mov    $0x3f,%esi
  a0cbde:	dec    %edx
  a0cbe0:	lea    -0x4(%rdi),%r8d
  a0cbe4:	cmp    $0x3f,%edx
  a0cbe7:	cmovb  %edx,%esi
  a0cbea:	mov    $0x1,%edx
  a0cbef:	shlx   %rsi,%rdx,%rdx
  a0cbf4:	cmp    $0x2,%r8d
  a0cbf8:	jae    a0cc27 <pp_compile_macro+0x3e7>
  a0cbfa:	testb  $0x2,0xb(%rsp)
  a0cbff:	mov    0x68(%rsp),%rsi
  a0cc04:	mov    $0x0,%eax
  a0cc09:	movq   $0x0,0x10(%rsp)
  a0cc12:	cmovne %rdx,%rax
  a0cc16:	or     %rax,(%rsi)
  a0cc19:	xor    %eax,%eax
  a0cc1b:	movzwl 0x2(%r15),%esi
  a0cc20:	inc    %esi
  a0cc22:	jmp    a0d53c <pp_compile_macro+0xcfc>
  a0cc27:	mov    $0xffffffff,%esi
  a0cc2c:	movq   $0x0,0x10(%rsp)
  a0cc35:	cmp    $0x1,%edi
  a0cc38:	jne    a0d53c <pp_compile_macro+0xcfc>
  a0cc3e:	cmp    $0x2,%r12d
  a0cc42:	jae    a0d267 <pp_compile_macro+0xa27>
  a0cc48:	movzwl 0x2(%r15),%edi
  a0cc4d:	mov    $0x3f,%r9d
  a0cc53:	mov    $0x1,%r10d
  a0cc59:	movzwl %di,%r8d
  a0cc5d:	cmp    $0x3f,%r8d
  a0cc61:	cmovb  %r8d,%r9d
  a0cc65:	shlx   %r9,%r10,%r10
  a0cc6a:	mov    $0x1,%r9b
  a0cc6d:	jmp    a0d298 <pp_compile_macro+0xa58>
  a0cc72:	xor    %r10d,%r10d
  a0cc75:	cmpw   $0x5,0x70(%rsp)
  a0cc7b:	mov    0xe00(%rbx),%edx
  a0cc81:	lea    0x28(%r9),%rcx
  a0cc85:	mov    %rcx,0x58(%rsp)
  a0cc8a:	setae  %al
  a0cc8d:	and    0x278(%rbx),%al
  a0cc93:	mov    %edx,0x28(%r9)
  a0cc97:	movq   $0x0,0x38(%r9)
  a0cc9f:	mov    0x18(%r9),%r13d
  a0cca3:	mov    0x1c(%r9),%r15d
  a0cca7:	mov    %al,0x50(%rsp)
  a0ccab:	lea    0x38(%r9),%rax
  a0ccaf:	mov    %rax,0x68(%rsp)
  a0ccb4:	cmp    %r15d,%r13d
  a0ccb7:	jae    a0d226 <pp_compile_macro+0x9e6>
  a0ccbd:	mov    0x60(%rsp),%rcx
  a0ccc2:	mov    %r11d,%eax
  a0ccc5:	movl   $0xffffffff,0xc(%rsp)
  a0cccd:	movl   $0x0,0x4c(%rsp)
  a0ccd5:	movl   $0x0,0x18(%rsp)
  a0ccdd:	mov    %r10,0x40(%rsp)
  a0cce2:	xor    $0x1,%al
  a0cce4:	mov    %al,0x1c(%rsp)
  a0cce8:	mov    $0xffff,%eax
  a0cced:	bzhi   %ecx,%eax,%eax
  a0ccf2:	mov    %eax,0x7c(%rsp)
  a0ccf6:	cs nopw 0x0(%rax,%rax,1)
  a0cd00:	mov    0x50(%rbp),%r8
  a0cd04:	mov    0x18(%r9),%ebx
  a0cd08:	cmp    %ebx,%r13d
  a0cd0b:	je     a0cd40 <pp_compile_macro+0x500>
  a0cd0d:	mov    0x68(%rbp),%rax
  a0cd11:	mov    %r13d,%ecx
  a0cd14:	shr    $0x6,%ecx
  a0cd17:	mov    (%rax,%rcx,8),%rax
  a0cd1b:	bt     %r13,%rax
  a0cd1f:	jae    a0cd40 <pp_compile_macro+0x500>
  a0cd21:	lea    -0x1(%r13),%eax
  a0cd25:	movzbl (%r8,%rax,1),%eax
  a0cd2a:	and    $0x7f,%al
  a0cd2c:	cmp    $0x3d,%al
  a0cd2e:	setne  %al
  a0cd31:	mov    %eax,0x10(%rsp)
  a0cd35:	jmp    a0cd48 <pp_compile_macro+0x508>
  a0cd37:	nopw   0x0(%rax,%rax,1)
  a0cd40:	movl   $0x0,0x10(%rsp)
  a0cd48:	mov    %r13d,%r14d
  a0cd4b:	movzbl (%r8,%r14,1),%edx
  a0cd50:	and    $0x7f,%dl
  a0cd53:	cmp    $0x1,%dl
  a0cd56:	sete   %al
  a0cd59:	test   %al,%r11b
  a0cd5c:	je     a0cde0 <pp_compile_macro+0x5a0>
  a0cd62:	mov    0x60(%rbp),%rax
  a0cd66:	movzbl 0x1c(%rsp),%ecx
  a0cd6b:	mov    (%rax,%r14,4),%eax
  a0cd6f:	cmp    $0xab,%eax
  a0cd74:	sete   %bl
  a0cd77:	or     %bl,%cl
  a0cd79:	cmp    $0x1,%cl
  a0cd7c:	jne    a0cded <pp_compile_macro+0x5ad>
  a0cd7e:	cmp    $0xab,%eax
  a0cd83:	jne    a0cf04 <pp_compile_macro+0x6c4>
  a0cd89:	cmpl   $0xffffffff,0xc(%rsp)
  a0cd8e:	jne    a0d3a6 <pp_compile_macro+0xb66>
  a0cd94:	mov    %r14,%r12
  a0cd97:	inc    %r12
  a0cd9a:	cmp    %r15d,%r12d
  a0cd9d:	jae    a0d3a6 <pp_compile_macro+0xb66>
  a0cda3:	movzbl (%r8,%r12,1),%eax
  a0cda8:	and    $0x7f,%al
  a0cdaa:	cmp    $0xf,%al
  a0cdac:	jne    a0d3a6 <pp_compile_macro+0xb66>
  a0cdb2:	mov    0x28(%rsp),%rax
  a0cdb7:	mov    $0x4,%cl
  a0cdb9:	movl   $0x1,0x18(%rsp)
  a0cdc1:	mov    0xe00(%rax),%eax
  a0cdc7:	mov    %eax,0xc(%rsp)
  a0cdcb:	lea    0x2(%r13),%eax
  a0cdcf:	mov    %eax,0x4c(%rsp)
  a0cdd3:	xor    %eax,%eax
  a0cdd5:	jmp    a0cf15 <pp_compile_macro+0x6d5>
  a0cdda:	nopw   0x0(%rax,%rax,1)
  a0cde0:	cmp    $0x1,%dl
  a0cde3:	sete   %al
  a0cde6:	test   %r11b,%al
  a0cde9:	je     a0ce30 <pp_compile_macro+0x5f0>
  a0cdeb:	xor    %ebx,%ebx
  a0cded:	mov    0x60(%rbp),%rax
  a0cdf1:	mov    (%rax,%r14,4),%esi
  a0cdf5:	test   %r10,%r10
  a0cdf8:	je     a0ce3e <pp_compile_macro+0x5fe>
  a0cdfa:	mov    %r10,%rdi
  a0cdfd:	mov    %r8,%r12
  a0ce00:	vzeroupper
  a0ce03:	call   9f1d70 <pp_parameter_index>
  a0ce08:	mov    0x30(%rsp),%rdi
  a0ce0d:	movzbl 0x20(%rsp),%r11d
  a0ce13:	mov    0x40(%rsp),%r10
  a0ce18:	mov    0x38(%rsp),%r9
  a0ce1d:	cmp    $0xffffffff,%eax
  a0ce20:	jne    a0cf10 <pp_compile_macro+0x6d0>
  a0ce26:	jmp    a0cef9 <pp_compile_macro+0x6b9>
  a0ce2b:	nopl   0x0(%rax,%rax,1)
  a0ce30:	cmp    $0x3d,%dl
  a0ce33:	jne    a0ce7a <pp_compile_macro+0x63a>
  a0ce35:	mov    $0x3,%cl
  a0ce37:	xor    %eax,%eax
  a0ce39:	jmp    a0cf12 <pp_compile_macro+0x6d2>
  a0ce3e:	cmpb   $0x0,0x50(%rsp)
  a0ce43:	je     a0cec4 <pp_compile_macro+0x684>
  a0ce45:	mov    0x7c(%rsp),%eax
  a0ce49:	vpbroadcastd %esi,%zmm1
  a0ce4f:	kmovd  %eax,%k1
  a0ce53:	vmovdqu32 (%rdi),%zmm0{%k1}{z}
  a0ce59:	vpcmpeqd %zmm1,%zmm0,%k0
  a0ce5f:	ktestw %k1,%k0
  a0ce63:	je     a0cf75 <pp_compile_macro+0x735>
  a0ce69:	kandw  %k1,%k0,%k0
  a0ce6d:	kmovd  %k0,%eax
  a0ce71:	tzcnt  %eax,%eax
  a0ce75:	jmp    a0cf10 <pp_compile_macro+0x6d0>
  a0ce7a:	cmp    $0x3c,%dl
  a0ce7d:	sete   %al
  a0ce80:	and    %r11b,%al
  a0ce83:	cmp    $0x1,%al
  a0ce85:	jne    a0cf5e <pp_compile_macro+0x71e>
  a0ce8b:	lea    0x1(%r14),%r12
  a0ce8f:	cmp    %r15d,%r12d
  a0ce92:	jae    a0dec3 <pp_compile_macro+0x1683>
  a0ce98:	movzbl (%r8,%r12,1),%eax
  a0ce9d:	and    $0x7f,%al
  a0ce9f:	cmp    $0x1,%al
  a0cea1:	jne    a0cfac <pp_compile_macro+0x76c>
  a0cea7:	mov    0x60(%rbp),%rcx
  a0ceab:	cmpl   $0xab,0x4(%rcx,%r14,4)
  a0ceb4:	sete   %cl
  a0ceb7:	cmp    $0x1,%al
  a0ceb9:	je     a0cfb6 <pp_compile_macro+0x776>
  a0cebf:	jmp    a0d0d1 <pp_compile_macro+0x891>
  a0cec4:	mov    $0xffffffff,%eax
  a0cec9:	mov    $0x1,%ecx
  a0cece:	mov    %r8,%r12
  a0ced1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0cee0:	mov    -0x4(%rdi,%rcx,4),%edx
  a0cee4:	inc    %eax
  a0cee6:	cmp    %esi,%edx
  a0cee8:	je     a0cef5 <pp_compile_macro+0x6b5>
  a0ceea:	cmp    0x70(%rsp),%rcx
  a0ceef:	lea    0x1(%rcx),%rcx
  a0cef3:	jb     a0cee0 <pp_compile_macro+0x6a0>
  a0cef5:	cmp    %esi,%edx
  a0cef7:	je     a0cf10 <pp_compile_macro+0x6d0>
  a0cef9:	mov    %r12,%r8
  a0cefc:	test   %bl,%bl
  a0cefe:	jne    a0cd89 <pp_compile_macro+0x549>
  a0cf04:	xor    %eax,%eax
  a0cf06:	mov    %r13d,%r12d
  a0cf09:	xor    %ecx,%ecx
  a0cf0b:	jmp    a0cf15 <pp_compile_macro+0x6d5>
  a0cf0d:	nopl   (%rax)
  a0cf10:	mov    $0x1,%cl
  a0cf12:	mov    %r13d,%r12d
  a0cf15:	mov    0x10(%rsp),%r15d
  a0cf1a:	mov    0x28(%rsp),%r8
  a0cf1f:	mov    0xdf8(%r8),%rdx
  a0cf26:	mov    0xe00(%r8),%esi
  a0cf2d:	mov    %cl,(%rdx,%rsi,8)
  a0cf30:	mov    %r15b,0x1(%rdx,%rsi,8)
  a0cf35:	mov    %ax,0x2(%rdx,%rsi,8)
  a0cf3a:	mov    %r13d,0x4(%rdx,%rsi,8)
  a0cf3f:	incl   0xe00(%r8)
  a0cf46:	mov    %r12d,%r13d
  a0cf49:	mov    0x1c(%r9),%r15d
  a0cf4d:	inc    %r13d
  a0cf50:	cmp    %r15d,%r13d
  a0cf53:	jb     a0cd00 <pp_compile_macro+0x4c0>
  a0cf59:	jmp    a0d1eb <pp_compile_macro+0x9ab>
  a0cf5e:	cmpl   $0xffffffff,0xc(%rsp)
  a0cf63:	mov    0x10(%rsp),%r15d
  a0cf68:	je     a0cf7f <pp_compile_macro+0x73f>
  a0cf6a:	cmp    $0xf,%dl
  a0cf6d:	jne    a0cf7f <pp_compile_macro+0x73f>
  a0cf6f:	incl   0x18(%rsp)
  a0cf73:	jmp    a0cfa0 <pp_compile_macro+0x760>
  a0cf75:	test   %bl,%bl
  a0cf77:	jne    a0cd89 <pp_compile_macro+0x549>
  a0cf7d:	jmp    a0cf04 <pp_compile_macro+0x6c4>
  a0cf7f:	xor    %ecx,%ecx
  a0cf81:	cmpl   $0xffffffff,0xc(%rsp)
  a0cf86:	mov    $0x0,%eax
  a0cf8b:	je     a0d012 <pp_compile_macro+0x7d2>
  a0cf91:	cmp    $0x10,%dl
  a0cf94:	jne    a0d012 <pp_compile_macro+0x7d2>
  a0cf96:	decl   0x18(%rsp)
  a0cf9a:	je     a0d056 <pp_compile_macro+0x816>
  a0cfa0:	xor    %eax,%eax
  a0cfa2:	mov    %r13d,%r12d
  a0cfa5:	xor    %ecx,%ecx
  a0cfa7:	jmp    a0cf1a <pp_compile_macro+0x6da>
  a0cfac:	xor    %ecx,%ecx
  a0cfae:	cmp    $0x1,%al
  a0cfb0:	jne    a0d0d1 <pp_compile_macro+0x891>
  a0cfb6:	test   %cl,%cl
  a0cfb8:	jne    a0d0d1 <pp_compile_macro+0x891>
  a0cfbe:	mov    0x60(%rbp),%rax
  a0cfc2:	mov    0x4(%rax,%r14,4),%esi
  a0cfc7:	test   %r10,%r10
  a0cfca:	je     a0d01a <pp_compile_macro+0x7da>
  a0cfcc:	mov    %r10,%rdi
  a0cfcf:	mov    %r8,0x80(%rsp)
  a0cfd7:	mov    %ecx,0x48(%rsp)
  a0cfdb:	vzeroupper
  a0cfde:	call   9f1d70 <pp_parameter_index>
  a0cfe3:	mov    0x48(%rsp),%ecx
  a0cfe7:	mov    0x80(%rsp),%r8
  a0cfef:	mov    0x30(%rsp),%rdi
  a0cff4:	movzbl 0x20(%rsp),%r11d
  a0cffa:	mov    0x40(%rsp),%r10
  a0cfff:	mov    0x38(%rsp),%r9
  a0d004:	cmp    $0xffffffff,%eax
  a0d007:	jne    a0d15e <pp_compile_macro+0x91e>
  a0d00d:	jmp    a0d0d1 <pp_compile_macro+0x891>
  a0d012:	mov    %r13d,%r12d
  a0d015:	jmp    a0cf1a <pp_compile_macro+0x6da>
  a0d01a:	cmpb   $0x0,0x50(%rsp)
  a0d01f:	je     a0d09e <pp_compile_macro+0x85e>
  a0d021:	mov    0x7c(%rsp),%eax
  a0d025:	vpbroadcastd %esi,%zmm1
  a0d02b:	kmovd  %eax,%k1
  a0d02f:	vmovdqu32 (%rdi),%zmm0{%k1}{z}
  a0d035:	vpcmpeqd %zmm1,%zmm0,%k0
  a0d03b:	ktestw %k1,%k0
  a0d03f:	je     a0d0d1 <pp_compile_macro+0x891>
  a0d045:	kandw  %k1,%k0,%k0
  a0d049:	kmovd  %k0,%eax
  a0d04d:	tzcnt  %eax,%eax
  a0d051:	jmp    a0d15e <pp_compile_macro+0x91e>
  a0d056:	mov    0x4c(%rsp),%ecx
  a0d05a:	xor    %eax,%eax
  a0d05c:	cmp    %r13d,%ecx
  a0d05f:	ja     a0d16a <pp_compile_macro+0x92a>
  a0d065:	jmp    a0d072 <pp_compile_macro+0x832>
  a0d067:	inc    %ecx
  a0d069:	cmp    %r13d,%ecx
  a0d06c:	ja     a0d165 <pp_compile_macro+0x925>
  a0d072:	cmp    %ecx,%ebx
  a0d074:	je     a0d067 <pp_compile_macro+0x827>
  a0d076:	mov    0x68(%rbp),%rdx
  a0d07a:	mov    %ecx,%esi
  a0d07c:	shr    $0x6,%esi
  a0d07f:	mov    (%rdx,%rsi,8),%rdx
  a0d083:	bt     %rcx,%rdx
  a0d087:	jae    a0d067 <pp_compile_macro+0x827>
  a0d089:	lea    -0x1(%rcx),%edx
  a0d08c:	movzbl (%r8,%rdx,1),%edx
  a0d091:	and    $0x7f,%dl
  a0d094:	cmp    $0x3d,%dl
  a0d097:	setne  %dl
  a0d09a:	or     %dl,%al
  a0d09c:	jmp    a0d067 <pp_compile_macro+0x827>
  a0d09e:	mov    %ecx,0x48(%rsp)
  a0d0a2:	mov    $0xffffffff,%eax
  a0d0a7:	mov    $0x1,%ecx
  a0d0ac:	nopl   0x0(%rax)
  a0d0b0:	mov    -0x4(%rdi,%rcx,4),%edx
  a0d0b4:	inc    %eax
  a0d0b6:	cmp    %esi,%edx
  a0d0b8:	je     a0d0c5 <pp_compile_macro+0x885>
  a0d0ba:	cmp    0x70(%rsp),%rcx
  a0d0bf:	lea    0x1(%rcx),%rcx
  a0d0c3:	jb     a0d0b0 <pp_compile_macro+0x870>
  a0d0c5:	mov    0x48(%rsp),%ecx
  a0d0c9:	cmp    %esi,%edx
  a0d0cb:	je     a0d15e <pp_compile_macro+0x91e>
  a0d0d1:	cmpl   $0xffffffff,0xc(%rsp)
  a0d0d6:	sete   %al
  a0d0d9:	and    %al,%cl
  a0d0db:	cmp    $0x1,%cl
  a0d0de:	jne    a0dec3 <pp_compile_macro+0x1683>
  a0d0e4:	add    $0x2,%r14
  a0d0e8:	cmp    %r15d,%r14d
  a0d0eb:	jae    a0dec3 <pp_compile_macro+0x1683>
  a0d0f1:	movzbl (%r8,%r14,1),%eax
  a0d0f6:	and    $0x7f,%al
  a0d0f8:	cmp    $0xf,%al
  a0d0fa:	jne    a0dec3 <pp_compile_macro+0x1683>
  a0d100:	cmp    %ebx,%r12d
  a0d103:	jne    a0d10c <pp_compile_macro+0x8cc>
  a0d105:	mov    0x10(%rsp),%r15d
  a0d10a:	jmp    a0d133 <pp_compile_macro+0x8f3>
  a0d10c:	mov    0x68(%rbp),%rax
  a0d110:	mov    %r12d,%ecx
  a0d113:	shr    $0x6,%ecx
  a0d116:	mov    0x10(%rsp),%r15d
  a0d11b:	mov    (%rax,%rcx,8),%rax
  a0d11f:	movzbl %r15b,%ecx
  a0d123:	or     $0x10,%r15b
  a0d127:	movzbl %r15b,%r15d
  a0d12b:	bt     %r12,%rax
  a0d12f:	cmovae %ecx,%r15d
  a0d133:	mov    0x28(%rsp),%rax
  a0d138:	mov    $0x5,%cl
  a0d13a:	movl   $0x1,0x18(%rsp)
  a0d142:	mov    %r14d,%r12d
  a0d145:	mov    0xe00(%rax),%eax
  a0d14b:	mov    %eax,0xc(%rsp)
  a0d14f:	lea    0x3(%r13),%eax
  a0d153:	mov    %eax,0x4c(%rsp)
  a0d157:	xor    %eax,%eax
  a0d159:	jmp    a0cf1a <pp_compile_macro+0x6da>
  a0d15e:	mov    $0x2,%cl
  a0d160:	jmp    a0cf15 <pp_compile_macro+0x6d5>
  a0d165:	and    $0x1,%al
  a0d167:	shl    $0x6,%al
  a0d16a:	cmp    %ebx,%r13d
  a0d16d:	je     a0d19c <pp_compile_macro+0x95c>
  a0d16f:	mov    0x68(%rbp),%rcx
  a0d173:	mov    %r13d,%edx
  a0d176:	shr    $0x6,%edx
  a0d179:	mov    (%rcx,%rdx,8),%rcx
  a0d17d:	bt     %r13,%rcx
  a0d181:	jae    a0d19c <pp_compile_macro+0x95c>
  a0d183:	lea    -0x1(%r13),%ecx
  a0d187:	movzbl (%r8,%rcx,1),%ecx
  a0d18c:	and    $0x7f,%cl
  a0d18f:	cmp    $0x3d,%cl
  a0d192:	setne  %cl
  a0d195:	shl    $0x5,%cl
  a0d198:	or     %al,%cl
  a0d19a:	mov    %ecx,%eax
  a0d19c:	mov    0x28(%rsp),%rsi
  a0d1a1:	mov    0xc(%rsp),%r8d
  a0d1a6:	movl   $0xffffffff,0xc(%rsp)
  a0d1ae:	movl   $0x0,0x18(%rsp)
  a0d1b6:	mov    0xdf8(%rsi),%rcx
  a0d1bd:	mov    %r8d,%edx
  a0d1c0:	not    %r8d
  a0d1c3:	or     %al,0x1(%rcx,%rdx,8)
  a0d1c7:	add    0xe00(%rsi),%r8d
  a0d1ce:	mov    0xdf8(%rsi),%rax
  a0d1d5:	mov    %r8w,0x2(%rax,%rdx,8)
  a0d1db:	mov    0x1c(%r9),%r15d
  a0d1df:	inc    %r13d
  a0d1e2:	cmp    %r15d,%r13d
  a0d1e5:	jb     a0cd00 <pp_compile_macro+0x4c0>
  a0d1eb:	cmpl   $0xffffffff,0xc(%rsp)
  a0d1f0:	mov    0x28(%rsp),%rbx
  a0d1f5:	je     a0d226 <pp_compile_macro+0x9e6>
  a0d1f7:	mov    0x24(%r9),%edx
  a0d1fb:	lea    -0x2b7d16(%rip),%rcx        # 7554ec <pp_decode_file_name.meaning+0x1e24d>
  a0d202:	jmp    a0dee2 <pp_compile_macro+0x16a2>
  a0d207:	mov    0x20(%rsp),%r12
  a0d20c:	mov    0xc(%rsp),%edx
  a0d210:	and    %r8b,%dl
  a0d213:	cmp    $0x1,%dl
  a0d216:	je     a0cbcb <pp_compile_macro+0x38b>
  a0d21c:	mov    0x28(%rsp),%r13
  a0d221:	jmp    a0d6a4 <pp_compile_macro+0xe64>
  a0d226:	mov    0x58(%rsp),%rcx
  a0d22b:	mov    0xdf8(%rbx),%rdx
  a0d232:	mov    0xe00(%rbx),%r11d
  a0d239:	lea    0xdf8(%rbx),%rax
  a0d240:	mov    %rax,0x50(%rsp)
  a0d245:	mov    (%rcx),%esi
  a0d247:	lea    (%rdx,%rsi,8),%r15
  a0d24b:	sub    %esi,%r11d
  a0d24e:	mov    %r11,0x20(%rsp)
  a0d253:	jne    a0d320 <pp_compile_macro+0xae0>
  a0d259:	mov    $0x1,%al
  a0d25b:	xor    %r8d,%r8d
  a0d25e:	mov    %eax,0x18(%rsp)
  a0d262:	jmp    a0d395 <pp_compile_macro+0xb55>
  a0d267:	movzwl 0x2(%r15),%edi
  a0d26c:	mov    $0x3f,%r11d
  a0d272:	mov    $0x1,%ebx
  a0d277:	movzwl %di,%r8d
  a0d27b:	cmp    $0x3f,%r8d
  a0d27f:	cmovb  %r8d,%r11d
  a0d283:	xor    %r10d,%r10d
  a0d286:	cmpb   $0x3,0x8(%r15)
  a0d28b:	shlx   %r11,%rbx,%r11
  a0d290:	setne  %r9b
  a0d294:	cmovne %r11,%r10
  a0d298:	mov    0x68(%rsp),%r11
  a0d29d:	and    %al,%r9b
  a0d2a0:	or     %r10,(%r11)
  a0d2a3:	cmp    $0x1,%r9b
  a0d2a7:	jne    a0d53c <pp_compile_macro+0xcfc>
  a0d2ad:	mov    %r8d,%r9d
  a0d2b0:	shr    $0x6,%r9d
  a0d2b4:	mov    $0x1,%al
  a0d2b6:	mov    (%rcx,%r9,8),%r10
  a0d2ba:	bt     %r8,%r10
  a0d2be:	jb     a0d53c <pp_compile_macro+0xcfc>
  a0d2c4:	mov    $0x1,%r11d
  a0d2ca:	movq   $0x0,0x10(%rsp)
  a0d2d3:	shlx   %r8,%r11,%r8
  a0d2d8:	or     %r8,%r10
  a0d2db:	mov    %r10,(%rcx,%r9,8)
  a0d2df:	mov    0xe00(%r13),%r8d
  a0d2e6:	cmp    $0x3ffffff,%r8
  a0d2ed:	ja     a0d53a <pp_compile_macro+0xcfa>
  a0d2f3:	mov    0x50(%rsp),%r9
  a0d2f8:	mov    (%r9),%r9
  a0d2fb:	movw   $0x1,(%r9,%r8,8)
  a0d302:	mov    %di,0x2(%r9,%r8,8)
  a0d308:	mov    $0x1,%edi
  a0d30d:	movl   $0x0,0x4(%r9,%r8,8)
  a0d316:	mov    %rdi,0x10(%rsp)
  a0d31b:	jmp    a0d53c <pp_compile_macro+0xcfc>
  a0d320:	mov    %r11d,%eax
  a0d323:	mov    %rax,%rdi
  a0d326:	and    $0x3,%rdi
  a0d32a:	mov    %rax,%rcx
  a0d32d:	je     a0d384 <pp_compile_macro+0xb44>
  a0d32f:	mov    $0xffff,%r8d
  a0d335:	mov    %rax,%rcx
  a0d338:	jmp    a0d351 <pp_compile_macro+0xb11>
  a0d33a:	nopw   0x0(%rax,%rax,1)
  a0d340:	xor    %r9d,%r9d
  a0d343:	mov    %r9w,-0x6(%r15,%rcx,8)
  a0d349:	dec    %rcx
  a0d34c:	dec    %rdi
  a0d34f:	je     a0d384 <pp_compile_macro+0xb44>
  a0d351:	cmpb   $0x0,-0x8(%r15,%rcx,8)
  a0d357:	jne    a0d349 <pp_compile_macro+0xb09>
  a0d359:	cmp    %rax,%rcx
  a0d35c:	jae    a0d340 <pp_compile_macro+0xb00>
  a0d35e:	cmpb   $0x0,(%r15,%rcx,8)
  a0d363:	jne    a0d340 <pp_compile_macro+0xb00>
  a0d365:	mov    -0x4(%r15,%rcx,8),%r9d
  a0d36a:	inc    %r9d
  a0d36d:	cmp    %r9d,0x4(%r15,%rcx,8)
  a0d372:	jne    a0d340 <pp_compile_macro+0xb00>
  a0d374:	movzwl 0x2(%r15,%rcx,8),%r9d
  a0d37a:	inc    %r9w
  a0d37e:	cmove  %r8d,%r9d
  a0d382:	jmp    a0d343 <pp_compile_macro+0xb03>
  a0d384:	cmp    $0x4,%r11d
  a0d388:	jae    a0d3ba <pp_compile_macro+0xb7a>
  a0d38a:	mov    $0x1,%r8b
  a0d38d:	movl   $0x0,0x18(%rsp)
  a0d395:	mov    $0x1,%al
  a0d397:	mov    %eax,0x30(%rsp)
  a0d39b:	mov    $0x1,%al
  a0d39d:	mov    %eax,0xc(%rsp)
  a0d3a1:	jmp    a0ca49 <pp_compile_macro+0x209>
  a0d3a6:	mov    0x58(%rbp),%rax
  a0d3aa:	lea    -0x3db9bc(%rip),%rcx        # 6319f5 <tier0_test_vector_type_class.classes+0x6412>
  a0d3b1:	mov    (%rax,%r14,4),%edx
  a0d3b5:	jmp    a0ded9 <pp_compile_macro+0x1699>
  a0d3ba:	lea    0x4(%rdx,%rsi,8),%rdx
  a0d3bf:	add    $0xfffffffffffffffe,%rcx
  a0d3c3:	mov    $0xffff,%esi
  a0d3c8:	jmp    a0d3e4 <pp_compile_macro+0xba4>
  a0d3ca:	nopw   0x0(%rax,%rax,1)
  a0d3d0:	xor    %edi,%edi
  a0d3d2:	mov    %di,-0x12(%rdx,%rcx,8)
  a0d3d7:	add    $0xfffffffffffffffc,%rcx
  a0d3db:	mov    $0x1,%r8b
  a0d3de:	cmp    $0xfffffffffffffffe,%rcx
  a0d3e2:	je     a0d38d <pp_compile_macro+0xb4d>
  a0d3e4:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0d3e9:	je     a0d410 <pp_compile_macro+0xbd0>
  a0d3eb:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d3f0:	je     a0d45e <pp_compile_macro+0xc1e>
  a0d3f2:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d3f7:	je     a0d4b2 <pp_compile_macro+0xc72>
  a0d3fd:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d402:	jne    a0d3d7 <pp_compile_macro+0xb97>
  a0d404:	jmp    a0d502 <pp_compile_macro+0xcc2>
  a0d409:	nopl   0x0(%rax)
  a0d410:	lea    0x2(%rcx),%rdi
  a0d414:	cmp    %rax,%rdi
  a0d417:	jae    a0d450 <pp_compile_macro+0xc10>
  a0d419:	cmpb   $0x0,0xc(%rdx,%rcx,8)
  a0d41e:	jne    a0d450 <pp_compile_macro+0xc10>
  a0d420:	mov    0x8(%rdx,%rcx,8),%edi
  a0d424:	inc    %edi
  a0d426:	cmp    %edi,0x10(%rdx,%rcx,8)
  a0d42a:	jne    a0d450 <pp_compile_macro+0xc10>
  a0d42c:	movzwl 0xe(%rdx,%rcx,8),%edi
  a0d431:	inc    %di
  a0d434:	cmove  %esi,%edi
  a0d437:	mov    %di,0x6(%rdx,%rcx,8)
  a0d43c:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d441:	jne    a0d3f2 <pp_compile_macro+0xbb2>
  a0d443:	jmp    a0d45e <pp_compile_macro+0xc1e>
  a0d445:	data16 cs nopw 0x0(%rax,%rax,1)
  a0d450:	xor    %edi,%edi
  a0d452:	mov    %di,0x6(%rdx,%rcx,8)
  a0d457:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d45c:	jne    a0d3f2 <pp_compile_macro+0xbb2>
  a0d45e:	lea    0x1(%rcx),%rdi
  a0d462:	cmp    %rax,%rdi
  a0d465:	jae    a0d4a0 <pp_compile_macro+0xc60>
  a0d467:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0d46c:	jne    a0d4a0 <pp_compile_macro+0xc60>
  a0d46e:	mov    (%rdx,%rcx,8),%edi
  a0d471:	inc    %edi
  a0d473:	cmp    %edi,0x8(%rdx,%rcx,8)
  a0d477:	jne    a0d4a0 <pp_compile_macro+0xc60>
  a0d479:	movzwl 0x6(%rdx,%rcx,8),%edi
  a0d47e:	inc    %di
  a0d481:	cmove  %esi,%edi
  a0d484:	mov    %di,-0x2(%rdx,%rcx,8)
  a0d489:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d48e:	jne    a0d3fd <pp_compile_macro+0xbbd>
  a0d494:	jmp    a0d4b2 <pp_compile_macro+0xc72>
  a0d496:	cs nopw 0x0(%rax,%rax,1)
  a0d4a0:	xor    %edi,%edi
  a0d4a2:	mov    %di,-0x2(%rdx,%rcx,8)
  a0d4a7:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d4ac:	jne    a0d3fd <pp_compile_macro+0xbbd>
  a0d4b2:	cmp    %rax,%rcx
  a0d4b5:	jae    a0d4f0 <pp_compile_macro+0xcb0>
  a0d4b7:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d4bc:	jne    a0d4f0 <pp_compile_macro+0xcb0>
  a0d4be:	mov    -0x8(%rdx,%rcx,8),%edi
  a0d4c2:	inc    %edi
  a0d4c4:	cmp    %edi,(%rdx,%rcx,8)
  a0d4c7:	jne    a0d4f0 <pp_compile_macro+0xcb0>
  a0d4c9:	movzwl -0x2(%rdx,%rcx,8),%edi
  a0d4ce:	inc    %di
  a0d4d1:	cmove  %esi,%edi
  a0d4d4:	mov    %di,-0xa(%rdx,%rcx,8)
  a0d4d9:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d4de:	jne    a0d3d7 <pp_compile_macro+0xb97>
  a0d4e4:	jmp    a0d502 <pp_compile_macro+0xcc2>
  a0d4e6:	cs nopw 0x0(%rax,%rax,1)
  a0d4f0:	xor    %edi,%edi
  a0d4f2:	mov    %di,-0xa(%rdx,%rcx,8)
  a0d4f7:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d4fc:	jne    a0d3d7 <pp_compile_macro+0xb97>
  a0d502:	lea    -0x1(%rcx),%rdi
  a0d506:	cmp    %rax,%rdi
  a0d509:	jae    a0d3d0 <pp_compile_macro+0xb90>
  a0d50f:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d514:	jne    a0d3d0 <pp_compile_macro+0xb90>
  a0d51a:	mov    -0x10(%rdx,%rcx,8),%edi
  a0d51e:	inc    %edi
  a0d520:	cmp    %edi,-0x8(%rdx,%rcx,8)
  a0d524:	jne    a0d3d0 <pp_compile_macro+0xb90>
  a0d52a:	movzwl -0xa(%rdx,%rcx,8),%edi
  a0d52f:	inc    %di
  a0d532:	cmove  %esi,%edi
  a0d535:	jmp    a0d3d2 <pp_compile_macro+0xb92>
  a0d53a:	xor    %eax,%eax
  a0d53c:	cmp    $0x2,%r12d
  a0d540:	jb     a0d6a4 <pp_compile_macro+0xe64>
  a0d546:	xor    %r8d,%r8d
  a0d549:	testb  $0x2,0xb(%rsp)
  a0d54e:	mov    $0x2,%r10d
  a0d554:	mov    $0x1,%r9d
  a0d55a:	mov    %r12d,%edi
  a0d55d:	cmove  %r8,%rdx
  a0d561:	jmp    a0d590 <pp_compile_macro+0xd50>
  a0d563:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d570:	mov    0x68(%rsp),%rax
  a0d575:	or     %rdx,(%rax)
  a0d578:	xor    %eax,%eax
  a0d57a:	movzwl -0x6(%r15,%r10,8),%esi
  a0d580:	add    %r10d,%esi
  a0d583:	cmp    %rdi,%r10
  a0d586:	lea    0x1(%r10),%r10
  a0d58a:	jae    a0d6a4 <pp_compile_macro+0xe64>
  a0d590:	movzbl -0x8(%r15,%r10,8),%r11d
  a0d596:	lea    -0x4(%r11),%ebx
  a0d59a:	cmp    $0x2,%ebx
  a0d59d:	jb     a0d570 <pp_compile_macro+0xd30>
  a0d59f:	cmp    $0x1,%r11d
  a0d5a3:	jne    a0d583 <pp_compile_macro+0xd43>
  a0d5a5:	cmpb   $0x3,-0x10(%r15,%r10,8)
  a0d5ab:	je     a0d583 <pp_compile_macro+0xd43>
  a0d5ad:	cmp    %rdi,%r10
  a0d5b0:	jae    a0d5eb <pp_compile_macro+0xdab>
  a0d5b2:	mov    %esi,%r11d
  a0d5b5:	cmp    %r11,%r10
  a0d5b8:	je     a0d5eb <pp_compile_macro+0xdab>
  a0d5ba:	movzwl -0x6(%r15,%r10,8),%r11d
  a0d5c0:	mov    $0x3f,%r13d
  a0d5c6:	mov    $0x0,%r8d
  a0d5cc:	movzwl %r11w,%ebx
  a0d5d0:	cmp    $0x3f,%ebx
  a0d5d3:	cmovb  %ebx,%r13d
  a0d5d7:	cmpb   $0x3,(%r15,%r10,8)
  a0d5dc:	shlx   %r13,%r9,%r13
  a0d5e1:	setne  %r12b
  a0d5e5:	cmove  %r8,%r13
  a0d5e9:	jmp    a0d60a <pp_compile_macro+0xdca>
  a0d5eb:	movzwl -0x6(%r15,%r10,8),%r11d
  a0d5f1:	mov    $0x3f,%r12d
  a0d5f7:	movzwl %r11w,%ebx
  a0d5fb:	cmp    $0x3f,%ebx
  a0d5fe:	cmovb  %ebx,%r12d
  a0d602:	shlx   %r12,%r9,%r13
  a0d607:	mov    $0x1,%r12b
  a0d60a:	mov    0x68(%rsp),%r8
  a0d60f:	and    %al,%r12b
  a0d612:	or     %r13,(%r8)
  a0d615:	cmp    $0x1,%r12b
  a0d619:	jne    a0d62e <pp_compile_macro+0xdee>
  a0d61b:	mov    %ebx,%r12d
  a0d61e:	shr    $0x6,%r12d
  a0d622:	mov    $0x1,%al
  a0d624:	mov    (%rcx,%r12,8),%r13
  a0d628:	bt     %rbx,%r13
  a0d62c:	jae    a0d63d <pp_compile_macro+0xdfd>
  a0d62e:	mov    0x28(%rsp),%r13
  a0d633:	mov    0x20(%rsp),%r12
  a0d638:	jmp    a0d583 <pp_compile_macro+0xd43>
  a0d63d:	shlx   %rbx,%r9,%rbx
  a0d642:	mov    0x10(%rsp),%r8
  a0d647:	or     %rbx,%r13
  a0d64a:	mov    %r13,(%rcx,%r12,8)
  a0d64e:	mov    0x28(%rsp),%r13
  a0d653:	mov    0xe00(%r13),%ebx
  a0d65a:	add    %r8d,%ebx
  a0d65d:	cmp    $0x3ffffff,%ebx
  a0d663:	ja     a0d698 <pp_compile_macro+0xe58>
  a0d665:	mov    0x50(%rsp),%r12
  a0d66a:	mov    %ebx,%ebx
  a0d66c:	inc    %r8d
  a0d66f:	mov    %r8,0x10(%rsp)
  a0d674:	mov    (%r12),%r12
  a0d678:	movw   $0x1,(%r12,%rbx,8)
  a0d67f:	mov    %r11w,0x2(%r12,%rbx,8)
  a0d685:	movl   $0x0,0x4(%r12,%rbx,8)
  a0d68e:	mov    0x20(%rsp),%r12
  a0d693:	jmp    a0d583 <pp_compile_macro+0xd43>
  a0d698:	mov    0x20(%rsp),%r12
  a0d69d:	xor    %eax,%eax
  a0d69f:	jmp    a0d583 <pp_compile_macro+0xd43>
  a0d6a4:	mov    $0xfffffffffffff560,%rcx
  a0d6ab:	cmp    %fs:0x28(%rcx),%r14
  a0d6b0:	ja     a0df03 <pp_compile_macro+0x16c3>
  a0d6b6:	and    0x30(%rsp),%al
  a0d6ba:	mov    %r14,%fs:0x28(%rcx)
  a0d6bf:	xor    %ecx,%ecx
  a0d6c1:	mov    %eax,%esi
  a0d6c3:	and    0x1c(%rsp),%sil
  a0d6c8:	mov    %eax,%edx
  a0d6ca:	cmp    $0x1,%sil
  a0d6ce:	jne    a0d727 <pp_compile_macro+0xee7>
  a0d6d0:	mov    $0x1,%edi
  a0d6d5:	mov    %r12d,%esi
  a0d6d8:	xor    %ecx,%ecx
  a0d6da:	nopw   0x0(%rax,%rax,1)
  a0d6e0:	movzbl -0x8(%r15,%rdi,8),%r8d
  a0d6e6:	mov    $0x0,%r9d
  a0d6ec:	cmp    $0x2,%r8b
  a0d6f0:	setb   %dl
  a0d6f3:	test   %r8b,%r8b
  a0d6f6:	jne    a0d715 <pp_compile_macro+0xed5>
  a0d6f8:	mov    0x50(%rbp),%r9
  a0d6fc:	mov    -0x4(%r15,%rdi,8),%r10d
  a0d701:	movzbl (%r9,%r10,1),%r10d
  a0d706:	xor    %r9d,%r9d
  a0d709:	and    $0x7f,%r10b
  a0d70d:	cmp    $0x1,%r10b
  a0d711:	sete   %r9b
  a0d715:	add    %r9d,%ecx
  a0d718:	cmp    $0x1,%r8b
  a0d71c:	ja     a0d727 <pp_compile_macro+0xee7>
  a0d71e:	cmp    %rsi,%rdi
  a0d721:	lea    0x1(%rdi),%rdi
  a0d725:	jb     a0d6e0 <pp_compile_macro+0xea0>
  a0d727:	xor    %esi,%esi
  a0d729:	test   %dl,%dl
  a0d72b:	je     a0d78b <pp_compile_macro+0xf4b>
  a0d72d:	mov    0x1c(%rsp),%r9d
  a0d732:	mov    $0x0,%edx
  a0d737:	cmp    $0x10000,%ecx
  a0d73d:	jae    a0d792 <pp_compile_macro+0xf52>
  a0d73f:	mov    0x10(%rsp),%edi
  a0d743:	mov    0xe00(%r13),%edx
  a0d74a:	mov    %ecx,%r8d
  a0d74d:	add    %rdi,%r8
  a0d750:	add    %rdx,%r8
  a0d753:	cmp    $0x4000001,%r8
  a0d75a:	setb   %dl
  a0d75d:	mov    %edx,%edi
  a0d75f:	and    %r9b,%dil
  a0d762:	cmp    $0x1,%dil
  a0d766:	jne    a0d792 <pp_compile_macro+0xf52>
  a0d768:	mov    %r12d,%r9d
  a0d76b:	mov    %r9d,%edi
  a0d76e:	and    $0x3,%edi
  a0d771:	lea    -0x1(%r12),%r8d
  a0d776:	cmp    $0x3,%r8d
  a0d77a:	jae    a0d81b <pp_compile_macro+0xfdb>
  a0d780:	xor    %r10d,%r10d
  a0d783:	xor    %r8d,%r8d
  a0d786:	jmp    a0da1e <pp_compile_macro+0x11de>
  a0d78b:	xor    %edx,%edx
  a0d78d:	mov    0x1c(%rsp),%r9d
  a0d792:	test   %dl,%dl
  a0d794:	jne    a0d7fc <pp_compile_macro+0xfbc>
  a0d796:	mov    $0x0,%r8d
  a0d79c:	mov    $0x0,%edi
  a0d7a1:	mov    $0x0,%r10d
  a0d7a7:	test   %al,%al
  a0d7a9:	je     a0da8e <pp_compile_macro+0x124e>
  a0d7af:	mov    0x38(%rsp),%rsi
  a0d7b4:	cmp    $0x11,%r12d
  a0d7b8:	mov    $0x0,%edi
  a0d7bd:	setb   %r10b
  a0d7c1:	and    0x4(%rsi),%r10b
  a0d7c5:	xor    %esi,%esi
  a0d7c7:	and    %r10b,%r9b
  a0d7ca:	cmp    $0x1,%r9b
  a0d7ce:	jne    a0da8e <pp_compile_macro+0x124e>
  a0d7d4:	movzbl (%r15),%r11d
  a0d7d8:	xor    %edi,%edi
  a0d7da:	cmp    $0x2,%r11b
  a0d7de:	sete   %dil
  a0d7e2:	cmp    $0x3,%r11b
  a0d7e6:	jne    a0d971 <pp_compile_macro+0x1131>
  a0d7ec:	mov    $0x1,%esi
  a0d7f1:	xor    %r8d,%r8d
  a0d7f4:	xor    %r10d,%r10d
  a0d7f7:	jmp    a0da84 <pp_compile_macro+0x1244>
  a0d7fc:	xor    %r8d,%r8d
  a0d7ff:	xor    %edi,%edi
  a0d801:	xor    %r10d,%r10d
  a0d804:	xor    %r9d,%r9d
  a0d807:	or     %dl,%r10b
  a0d80a:	mov    $0x0,%r11d
  a0d810:	jne    a0daa0 <pp_compile_macro+0x1260>
  a0d816:	jmp    a0db88 <pp_compile_macro+0x1348>
  a0d81b:	and    $0xfffffffc,%r9d
  a0d81f:	xor    %r10d,%r10d
  a0d822:	xor    %r8d,%r8d
  a0d825:	jmp    a0d83d <pp_compile_macro+0xffd>
  a0d827:	nopw   0x0(%rax,%rax,1)
  a0d830:	add    $0x4,%r10
  a0d834:	cmp    %r10,%r9
  a0d837:	je     a0da15 <pp_compile_macro+0x11d5>
  a0d83d:	cmpb   $0x0,(%r15,%r10,8)
  a0d842:	jne    a0d880 <pp_compile_macro+0x1040>
  a0d844:	mov    0x50(%rbp),%rbx
  a0d848:	mov    0x4(%r15,%r10,8),%r11d
  a0d84d:	movzbl (%rbx,%r11,1),%ebx
  a0d852:	and    $0x7f,%bl
  a0d855:	cmp    $0x1,%bl
  a0d858:	jne    a0d880 <pp_compile_macro+0x1040>
  a0d85a:	mov    0x10(%rsp),%r14
  a0d85f:	mov    0xdf8(%r13),%rbx
  a0d866:	add    %r8d,%r14d
  a0d869:	add    0xe00(%r13),%r14d
  a0d870:	inc    %r8d
  a0d873:	movl   $0x0,(%rbx,%r14,8)
  a0d87b:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d880:	cmpb   $0x0,0x8(%r15,%r10,8)
  a0d886:	jne    a0d8d0 <pp_compile_macro+0x1090>
  a0d888:	mov    0x50(%rbp),%rbx
  a0d88c:	mov    0xc(%r15,%r10,8),%r11d
  a0d891:	movzbl (%rbx,%r11,1),%ebx
  a0d896:	and    $0x7f,%bl
  a0d899:	cmp    $0x1,%bl
  a0d89c:	jne    a0d8d0 <pp_compile_macro+0x1090>
  a0d89e:	mov    0x10(%rsp),%r14
  a0d8a3:	mov    0xdf8(%r13),%rbx
  a0d8aa:	add    %r8d,%r14d
  a0d8ad:	add    0xe00(%r13),%r14d
  a0d8b4:	inc    %r8d
  a0d8b7:	movl   $0x0,(%rbx,%r14,8)
  a0d8bf:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d8c4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d8d0:	cmpb   $0x0,0x10(%r15,%r10,8)
  a0d8d6:	jne    a0d920 <pp_compile_macro+0x10e0>
  a0d8d8:	mov    0x50(%rbp),%rbx
  a0d8dc:	mov    0x14(%r15,%r10,8),%r11d
  a0d8e1:	movzbl (%rbx,%r11,1),%ebx
  a0d8e6:	and    $0x7f,%bl
  a0d8e9:	cmp    $0x1,%bl
  a0d8ec:	jne    a0d920 <pp_compile_macro+0x10e0>
  a0d8ee:	mov    0x10(%rsp),%r14
  a0d8f3:	mov    0xdf8(%r13),%rbx
  a0d8fa:	add    %r8d,%r14d
  a0d8fd:	add    0xe00(%r13),%r14d
  a0d904:	inc    %r8d
  a0d907:	movl   $0x0,(%rbx,%r14,8)
  a0d90f:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d914:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d920:	cmpb   $0x0,0x18(%r15,%r10,8)
  a0d926:	jne    a0d830 <pp_compile_macro+0xff0>
  a0d92c:	mov    0x50(%rbp),%rbx
  a0d930:	mov    0x1c(%r15,%r10,8),%r11d
  a0d935:	movzbl (%rbx,%r11,1),%ebx
  a0d93a:	and    $0x7f,%bl
  a0d93d:	cmp    $0x1,%bl
  a0d940:	jne    a0d830 <pp_compile_macro+0xff0>
  a0d946:	mov    0x10(%rsp),%r14
  a0d94b:	mov    0xdf8(%r13),%rbx
  a0d952:	add    %r8d,%r14d
  a0d955:	add    0xe00(%r13),%r14d
  a0d95c:	inc    %r8d
  a0d95f:	movl   $0x0,(%rbx,%r14,8)
  a0d967:	mov    %r11d,0x4(%rbx,%r14,8)
  a0d96c:	jmp    a0d830 <pp_compile_macro+0xff0>
  a0d971:	setbe  %r10b
  a0d975:	xor    %esi,%esi
  a0d977:	cmp    $0x3,%r11b
  a0d97b:	ja     a0da81 <pp_compile_macro+0x1241>
  a0d981:	cmp    $0x2,%r12d
  a0d985:	jb     a0da81 <pp_compile_macro+0x1241>
  a0d98b:	mov    0x60(%rsp),%rsi
  a0d990:	movzbl 0x8(%r15),%r9d
  a0d995:	dec    %esi
  a0d997:	cmp    $0x4,%r9b
  a0d99b:	setb   %r10b
  a0d99f:	mov    %rsi,0x60(%rsp)
  a0d9a4:	xor    %esi,%esi
  a0d9a6:	cmp    $0x3,%r9b
  a0d9aa:	jne    a0ddb9 <pp_compile_macro+0x1579>
  a0d9b0:	mov    $0x2,%esi
  a0d9b5:	xor    %r8d,%r8d
  a0d9b8:	cmp    $0x3,%r12d
  a0d9bc:	jb     a0ddb6 <pp_compile_macro+0x1576>
  a0d9c2:	cmp    $0x2,%r11b
  a0d9c6:	movzbl 0x10(%r15),%r11d
  a0d9cb:	setb   %r8b
  a0d9cf:	cmp    $0x2,%r11b
  a0d9d3:	setb   %r10b
  a0d9d7:	and    %r8b,%r10b
  a0d9da:	mov    $0x1,%r8d
  a0d9e0:	cmp    $0x1,%r10b
  a0d9e4:	jne    a0ddb6 <pp_compile_macro+0x1576>
  a0d9ea:	testb  $0x2,0xb(%rsp)
  a0d9ef:	mov    $0x1,%r10b
  a0d9f2:	je     a0ddb9 <pp_compile_macro+0x1579>
  a0d9f8:	cmp    $0x1,%r11b
  a0d9fc:	jne    a0ddb9 <pp_compile_macro+0x1579>
  a0da02:	movzwl 0x12(%r15),%r10d
  a0da07:	cmp    %r10d,0x60(%rsp)
  a0da0c:	setne  %r10b
  a0da10:	jmp    a0ddb9 <pp_compile_macro+0x1579>
  a0da15:	test   %rdi,%rdi
  a0da18:	je     a0d78d <pp_compile_macro+0xf4d>
  a0da1e:	lea    0x4(%r15,%r10,8),%r9
  a0da23:	xor    %r10d,%r10d
  a0da26:	jmp    a0da3c <pp_compile_macro+0x11fc>
  a0da28:	nopl   0x0(%rax,%rax,1)
  a0da30:	inc    %r10
  a0da33:	cmp    %r10,%rdi
  a0da36:	je     a0d78d <pp_compile_macro+0xf4d>
  a0da3c:	cmpb   $0x0,-0x4(%r9,%r10,8)
  a0da42:	jne    a0da30 <pp_compile_macro+0x11f0>
  a0da44:	mov    0x50(%rbp),%rbx
  a0da48:	mov    (%r9,%r10,8),%r11d
  a0da4c:	movzbl (%rbx,%r11,1),%ebx
  a0da51:	and    $0x7f,%bl
  a0da54:	cmp    $0x1,%bl
  a0da57:	jne    a0da30 <pp_compile_macro+0x11f0>
  a0da59:	mov    0x10(%rsp),%r14
  a0da5e:	mov    0xdf8(%r13),%rbx
  a0da65:	add    %r8d,%r14d
  a0da68:	add    0xe00(%r13),%r14d
  a0da6f:	inc    %r8d
  a0da72:	movl   $0x0,(%rbx,%r14,8)
  a0da7a:	mov    %r11d,0x4(%rbx,%r14,8)
  a0da7f:	jmp    a0da30 <pp_compile_macro+0x11f0>
  a0da81:	xor    %r8d,%r8d
  a0da84:	mov    0x28(%rsp),%r13
  a0da89:	mov    0x20(%rsp),%r12
  a0da8e:	xor    %r9d,%r9d
  a0da91:	or     %dl,%r10b
  a0da94:	mov    $0x0,%r11d
  a0da9a:	je     a0db88 <pp_compile_macro+0x1348>
  a0daa0:	mov    0xe18(%r13),%r10
  a0daa7:	test   %r10,%r10
  a0daaa:	je     a0db88 <pp_compile_macro+0x1348>
  a0dab0:	cmp    $0x10,%r12d
  a0dab4:	ja     a0db88 <pp_compile_macro+0x1348>
  a0daba:	cmpw   $0x10,0x70(%rsp)
  a0dac0:	ja     a0db88 <pp_compile_macro+0x1348>
  a0dac6:	mov    0xe20(%r13),%ebx
  a0dacd:	cmp    $0xfffff,%rbx
  a0dad4:	ja     a0db88 <pp_compile_macro+0x1348>
  a0dada:	mov    %esi,%r14d
  a0dadd:	lea    (%rsi,%rsi,1),%r11d
  a0dae1:	shr    $1,%r14d
  a0dae4:	imul   $0x110,%rbx,%rbx
  a0daeb:	mov    %r12,%r13
  a0daee:	vpxor  %xmm0,%xmm0,%xmm0
  a0daf2:	andn   %r11d,%r14d,%r12d
  a0daf7:	cmpb   $0x0,0x18(%rsp)
  a0dafc:	vmovdqu64 %zmm0,0xc0(%r10,%rbx,1)
  a0db04:	vmovdqu64 %zmm0,0x80(%r10,%rbx,1)
  a0db0c:	vmovdqu64 %zmm0,0x40(%r10,%rbx,1)
  a0db14:	vmovdqu64 %zmm0,(%r10,%rbx,1)
  a0db1b:	movw   $0x0,0x100(%r10,%rbx,1)
  a0db26:	mov    %si,0x102(%r10,%rbx,1)
  a0db2f:	mov    %r8w,0x104(%r10,%rbx,1)
  a0db38:	mov    %r12w,0x106(%r10,%rbx,1)
  a0db41:	mov    %di,0x108(%r10,%rbx,1)
  a0db4a:	mov    %r13b,0x10a(%r10,%rbx,1)
  a0db52:	movl   $0x0,0x10b(%r10,%rbx,1)
  a0db5e:	movb   $0x0,0x10f(%r10,%rbx,1)
  a0db67:	je     a0dc34 <pp_compile_macro+0x13f4>
  a0db6d:	mov    0x28(%rsp),%r13
  a0db72:	mov    0x20(%rsp),%r12
  a0db77:	mov    0xe20(%r13),%r11d
  a0db7e:	inc    %r11d
  a0db81:	mov    %r11d,0xe20(%r13)
  a0db88:	mov    0x38(%rsp),%r8
  a0db8d:	mov    %eax,%esi
  a0db8f:	mov    %edx,%edi
  a0db91:	shl    $0x5,%sil
  a0db95:	shl    $0x7,%dil
  a0db99:	or     %sil,%dil
  a0db9c:	mov    %r11d,0x34(%r8)
  a0dba0:	or     %dil,0x4(%r8)
  a0dba4:	test   %al,%al
  a0dba6:	mov    0x10(%rsp),%rax
  a0dbab:	cmove  %r9d,%eax
  a0dbaf:	test   %dl,%dl
  a0dbb1:	cmove  %r9d,%ecx
  a0dbb5:	mov    %ax,0xa(%r8)
  a0dbba:	mov    %cx,0xc(%r8)
  a0dbbf:	add    %eax,%ecx
  a0dbc1:	mov    0x30(%rsp),%eax
  a0dbc5:	add    %ecx,0xe00(%r13)
  a0dbcc:	shl    $0x2,%al
  a0dbcf:	or     %al,0x4(%r8)
  a0dbd3:	cmpb   $0x0,0xc(%rsp)
  a0dbd8:	cmove  %r9d,%r12d
  a0dbdc:	mov    %r12d,0x2c(%r8)
  a0dbe0:	jne    a0dbf0 <pp_compile_macro+0x13b0>
  a0dbe2:	mov    0x58(%rsp),%rax
  a0dbe7:	mov    (%rax),%eax
  a0dbe9:	mov    %eax,0xe00(%r13)
  a0dbf0:	mov    0x40(%rsp),%rcx
  a0dbf5:	test   %rcx,%rcx
  a0dbf8:	je     a0dc1b <pp_compile_macro+0x13db>
  a0dbfa:	mov    0x98(%rcx),%rax
  a0dc01:	test   %rax,%rax
  a0dc04:	je     a0dc1b <pp_compile_macro+0x13db>
  a0dc06:	mov    0xa0(%rcx),%rcx
  a0dc0d:	cmp    0x8(%rax),%rcx
  a0dc11:	ja     a0df03 <pp_compile_macro+0x16c3>
  a0dc17:	mov    %rcx,0x8(%rax)
  a0dc1b:	mov    0xc(%rsp),%eax
  a0dc1f:	add    $0x88,%rsp
  a0dc26:	pop    %rbx
  a0dc27:	pop    %r12
  a0dc29:	pop    %r13
  a0dc2b:	pop    %r14
  a0dc2d:	pop    %r15
  a0dc2f:	pop    %rbp
  a0dc30:	vzeroupper
  a0dc33:	ret
  a0dc34:	add    %rbx,%r10
  a0dc37:	mov    0x20(%rsp),%rbx
  a0dc3c:	or     %esi,%r11d
  a0dc3f:	xor    %edi,%edi
  a0dc41:	or     %r14d,%r11d
  a0dc44:	jmp    a0dc5e <pp_compile_macro+0x141e>
  a0dc46:	cs nopw 0x0(%rax,%rax,1)
  a0dc50:	movzwl 0x2(%r15,%rsi,8),%edi
  a0dc56:	lea    0x1(%rsi,%rdi,1),%edi
  a0dc5a:	cmp    %ebx,%edi
  a0dc5c:	jae    a0dc99 <pp_compile_macro+0x1459>
  a0dc5e:	mov    %dil,0x10b(%r10)
  a0dc65:	mov    %edi,%esi
  a0dc67:	xor    %r8d,%r8d
  a0dc6a:	cmpb   $0x3,(%r15,%rsi,8)
  a0dc6f:	sete   %r8b
  a0dc73:	sub    %r8d,%edi
  a0dc76:	mov    %dil,0x10c(%r10)
  a0dc7d:	movzbl (%r15,%rsi,8),%r8d
  a0dc82:	test   %r8b,%r8b
  a0dc85:	je     a0dc50 <pp_compile_macro+0x1410>
  a0dc87:	xor    %edi,%edi
  a0dc89:	cmp    $0x3,%r8b
  a0dc8d:	sete   %dil
  a0dc91:	lea    0x1(%rsi,%rdi,1),%edi
  a0dc95:	cmp    %ebx,%edi
  a0dc97:	jb     a0dc5e <pp_compile_macro+0x141e>
  a0dc99:	mov    $0x1,%r8d
  a0dc9f:	mov    %ebx,%esi
  a0dca1:	xor    %edi,%edi
  a0dca3:	jmp    a0dcc4 <pp_compile_macro+0x1484>
  a0dca5:	data16 cs nopw 0x0(%rax,%rax,1)
  a0dcb0:	or     %r12w,0xfc(%r10)
  a0dcb8:	inc    %rdi
  a0dcbb:	cmp    %rdi,%rsi
  a0dcbe:	je     a0db6d <pp_compile_macro+0x132d>
  a0dcc4:	mov    0x4(%r15,%rdi,8),%r14d
  a0dcc9:	mov    0x50(%rbp),%rbx
  a0dccd:	movzbl (%rbx,%r14,1),%ebx
  a0dcd2:	mov    %r14d,%r13d
  a0dcd5:	shr    $0x6,%r13d
  a0dcd9:	and    $0x7f,%bl
  a0dcdc:	mov    %bl,0xc0(%r10,%rdi,1)
  a0dce4:	mov    0x68(%rbp),%r12
  a0dce8:	mov    (%r12,%r13,8),%r12
  a0dcec:	bt     %r14,%r12
  a0dcf0:	setb   %r12b
  a0dcf4:	or     $0x8,%r12b
  a0dcf8:	mov    %r12b,0xd0(%r10,%rdi,1)
  a0dd00:	cmp    $0x1,%bl
  a0dd03:	jne    a0dd20 <pp_compile_macro+0x14e0>
  a0dd05:	mov    0x60(%rbp),%r12
  a0dd09:	mov    0x38(%rsp),%r13
  a0dd0e:	mov    (%r12,%r14,4),%r12d
  a0dd12:	jmp    a0dd31 <pp_compile_macro+0x14f1>
  a0dd14:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0dd20:	mov    0x60(%rbp),%r12
  a0dd24:	mov    0x38(%rsp),%r13
  a0dd29:	mov    (%r12,%r14,4),%r12d
  a0dd2d:	add    0x14(%r13),%r12d
  a0dd31:	mov    %r12d,(%r10,%rdi,4)
  a0dd35:	mov    0x58(%rbp),%r12
  a0dd39:	mov    (%r12,%r14,4),%r14d
  a0dd3d:	mov    $0x0,%r12d
  a0dd43:	add    0x14(%r13),%r14d
  a0dd47:	mov    %r14d,0x40(%r10,%rdi,4)
  a0dd4c:	xor    %r14d,%r14d
  a0dd4f:	movzbl (%r15,%rdi,8),%r13d
  a0dd54:	dec    %r13b
  a0dd57:	cmp    $0x1,%r13b
  a0dd5b:	ja     a0dd63 <pp_compile_macro+0x1523>
  a0dd5d:	movzbl 0x2(%r15,%rdi,8),%r12d
  a0dd63:	mov    %r12b,0xe0(%r10,%rdi,1)
  a0dd6b:	shlx   %edi,%r8d,%r12d
  a0dd70:	cmpb   $0x1,(%r15,%rdi,8)
  a0dd75:	mov    %r12d,%r13d
  a0dd78:	je     a0dd7d <pp_compile_macro+0x153d>
  a0dd7a:	xor    %r13d,%r13d
  a0dd7d:	or     %r13w,0xf8(%r10)
  a0dd85:	xor    $0x1,%bl
  a0dd88:	mov    %r12d,%r13d
  a0dd8b:	testb  $0x1,0x1(%r15,%rdi,8)
  a0dd91:	cmove  %r14d,%r13d
  a0dd95:	or     %r13w,0xfa(%r10)
  a0dd9d:	test   %r11d,%r12d
  a0dda0:	cmovne %r14d,%r12d
  a0dda4:	or     (%r15,%rdi,8),%bl
  a0dda8:	je     a0dcb0 <pp_compile_macro+0x1470>
  a0ddae:	xor    %r12d,%r12d
  a0ddb1:	jmp    a0dcb0 <pp_compile_macro+0x1470>
  a0ddb6:	xor    %r10d,%r10d
  a0ddb9:	xor    %r11d,%r11d
  a0ddbc:	cmp    $0x2,%r9b
  a0ddc0:	sete   %r11b
  a0ddc4:	lea    (%rdi,%r11,2),%edi
  a0ddc8:	test   %r10b,%r10b
  a0ddcb:	je     a0da84 <pp_compile_macro+0x1244>
  a0ddd1:	cmp    $0x3,%r12d
  a0ddd5:	jb     a0da84 <pp_compile_macro+0x1244>
  a0dddb:	mov    %r12d,%r9d
  a0ddde:	mov    $0x2,%r11d
  a0dde4:	mov    $0x3,%r12d
  a0ddea:	nopw   0x0(%rax,%rax,1)
  a0ddf0:	movzbl -0x8(%r15,%r12,8),%r13d
  a0ddf6:	cmp    $0x3,%r13b
  a0ddfa:	jne    a0de40 <pp_compile_macro+0x1600>
  a0ddfc:	cmp    %r9,%r12
  a0ddff:	jae    a0de60 <pp_compile_macro+0x1620>
  a0de01:	cmpb   $0x2,-0x10(%r15,%r12,8)
  a0de07:	movzbl (%r15,%r12,8),%ebx
  a0de0c:	setb   %r10b
  a0de10:	cmp    $0x2,%bl
  a0de13:	setb   %r14b
  a0de17:	and    %r10b,%r14b
  a0de1a:	cmp    $0x1,%r14b
  a0de1e:	jne    a0de6a <pp_compile_macro+0x162a>
  a0de20:	testb  $0x2,0xb(%rsp)
  a0de25:	mov    $0x1,%r10b
  a0de28:	je     a0de6d <pp_compile_macro+0x162d>
  a0de2a:	cmp    $0x1,%bl
  a0de2d:	jne    a0de6d <pp_compile_macro+0x162d>
  a0de2f:	movzwl 0x2(%r15,%r12,8),%r10d
  a0de35:	cmp    %r10d,0x60(%rsp)
  a0de3a:	setne  %r10b
  a0de3e:	jmp    a0de6d <pp_compile_macro+0x162d>
  a0de40:	lea    -0x1(%r12),%ebx
  a0de45:	mov    $0x1,%r14d
  a0de4b:	setbe  %r10b
  a0de4f:	inc    %r11
  a0de52:	shlx   %ebx,%r14d,%ebx
  a0de57:	jmp    a0de97 <pp_compile_macro+0x1657>
  a0de59:	nopl   0x0(%rax)
  a0de60:	lea    -0x1(%r12),%r14d
  a0de65:	xor    %r10d,%r10d
  a0de68:	jmp    a0de86 <pp_compile_macro+0x1646>
  a0de6a:	xor    %r10d,%r10d
  a0de6d:	lea    -0x3(%r12),%ebx
  a0de72:	movzbl %bl,%ebx
  a0de75:	bt     %ebx,%esi
  a0de78:	jb     a0de83 <pp_compile_macro+0x1643>
  a0de7a:	lea    -0x2(%r12),%ebx
  a0de7f:	bts    %ebx,%r8d
  a0de83:	mov    %r11d,%r14d
  a0de86:	mov    $0x1,%ebx
  a0de8b:	bts    %r14d,%esi
  a0de8f:	inc    %r11
  a0de92:	shlx   %r14d,%ebx,%ebx
  a0de97:	cmp    $0x2,%r13b
  a0de9b:	mov    $0x0,%r14d
  a0dea1:	cmovne %r14d,%ebx
  a0dea5:	or     %ebx,%edi
  a0dea7:	test   %r10b,%r10b
  a0deaa:	je     a0da84 <pp_compile_macro+0x1244>
  a0deb0:	cmp    %r9,%r12
  a0deb3:	lea    0x1(%r12),%r12
  a0deb8:	jb     a0ddf0 <pp_compile_macro+0x15b0>
  a0debe:	jmp    a0da84 <pp_compile_macro+0x1244>
  a0dec3:	mov    0x58(%rbp),%rax
  a0dec7:	cmp    %r15d,%r12d
  a0deca:	lea    -0x412429(%rip),%rcx        # 5fbaa8 <parse_test_openers+0x2f5e8>
  a0ded1:	adc    $0x0,%r13d
  a0ded5:	mov    (%rax,%r13,4),%edx
  a0ded9:	add    0x14(%r9),%edx
  a0dedd:	mov    0x28(%rsp),%rbx
  a0dee2:	mov    $0x1,%esi
  a0dee7:	mov    %rbx,%rdi
  a0deea:	xor    %eax,%eax
  a0deec:	vzeroupper
  a0deef:	call   98b970 <pp_diagnose>
  a0def4:	mov    0x40(%rsp),%r10
  a0def9:	mov    0x58(%rsp),%rcx
  a0defe:	jmp    a0c9ff <pp_compile_macro+0x1bf>
  a0df03:	lea    -0x2dac88(%rip),%rdi        # 733282 <pp_string_value.meaning+0x7f660>
  a0df0a:	lea    -0x32b4aa(%rip),%rsi        # 6e2a67 <pp_string_value.meaning+0x2ee45>
  a0df11:	lea    -0x32b496(%rip),%rcx        # 6e2a82 <pp_string_value.meaning+0x2ee60>
  a0df18:	mov    $0xce,%edx
  a0df1d:	vzeroupper
  a0df20:	call   7cdf30 <__assert_fail@plt>
