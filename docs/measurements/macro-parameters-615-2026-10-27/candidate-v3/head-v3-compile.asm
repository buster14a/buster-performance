
head-v3/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000a0c920 <pp_compile_macro>:
  a0c920:	push   %rbp
  a0c921:	push   %r15
  a0c923:	push   %r14
  a0c925:	push   %r13
  a0c927:	push   %r12
  a0c929:	push   %rbx
  a0c92a:	sub    $0x88,%rsp
  a0c931:	mov    %fs:0x28,%rax
  a0c93a:	mov    %esi,%ecx
  a0c93c:	shl    $0x6,%rcx
  a0c940:	mov    %rdi,%rbx
  a0c943:	mov    %rax,0x80(%rsp)
  a0c94b:	mov    %rdi,0x18(%rsp)
  a0c950:	mov    0xde8(%rdi),%rax
  a0c957:	mov    0x10(%rax,%rcx,1),%edx
  a0c95b:	movzwl 0x8(%rax,%rcx,1),%r9d
  a0c961:	mov    0x1c(%rax,%rcx,1),%esi
  a0c965:	lea    (%rax,%rcx,1),%r14
  a0c969:	movzbl 0x4(%rax,%rcx,1),%r10d
  a0c96f:	mov    %r14,0x20(%rsp)
  a0c974:	imul   $0xe8,%rdx,%rbp
  a0c97b:	add    0xb80(%rdi),%rbp
  a0c982:	test   %r9d,%r9d
  a0c985:	mov    %r9d,%edx
  a0c988:	mov    %rdx,0x58(%rsp)
  a0c98d:	mov    0x18(%rax,%rcx,1),%edx
  a0c991:	mov    0xe10(%rdi),%ecx
  a0c997:	mov    %r9,0x38(%rsp)
  a0c99c:	mov    %r10b,0x3(%rsp)
  a0c9a1:	setne  %r11b
  a0c9a5:	add    0xe00(%rdi),%esi
  a0c9ab:	sub    %edx,%esi
  a0c9ad:	cmp    $0x4000001,%esi
  a0c9b3:	jae    a0ca44 <pp_compile_macro+0x124>
  a0c9b9:	lea    (%rcx,%r9,1),%eax
  a0c9bd:	and    %r10b,%r11b
  a0c9c0:	mov    %ecx,0x30(%r14)
  a0c9c4:	cmp    $0x4000001,%eax
  a0c9c9:	setb   %sil
  a0c9cd:	and    %r11b,%sil
  a0c9d0:	cmp    $0x1,%sil
  a0c9d4:	jne    a0ca5d <pp_compile_macro+0x13d>
  a0c9da:	mov    0x20(%r14),%ecx
  a0c9de:	cmp    %edx,%ecx
  a0c9e0:	jae    a0ca5d <pp_compile_macro+0x13d>
  a0c9e2:	xor    %edx,%edx
  a0c9e4:	jmp    a0ca17 <pp_compile_macro+0xf7>
  a0c9e6:	cs nopw 0x0(%rax,%rax,1)
  a0c9f0:	mov    0x60(%rbp),%rsi
  a0c9f4:	mov    (%rsi,%rcx,4),%esi
  a0c9f7:	mov    0x30(%r14),%r8d
  a0c9fb:	mov    0xe08(%rbx),%rdi
  a0ca02:	add    %edx,%r8d
  a0ca05:	inc    %edx
  a0ca07:	mov    %esi,(%rdi,%r8,4)
  a0ca0b:	mov    0x18(%r14),%esi
  a0ca0f:	inc    %rcx
  a0ca12:	cmp    %rsi,%rcx
  a0ca15:	jae    a0ca5d <pp_compile_macro+0x13d>
  a0ca17:	mov    0x50(%rbp),%rsi
  a0ca1b:	movzbl (%rsi,%rcx,1),%edi
  a0ca1f:	and    $0x7f,%edi
  a0ca22:	cmp    $0x1,%edi
  a0ca25:	je     a0c9f0 <pp_compile_macro+0xd0>
  a0ca27:	cmp    $0x14,%edi
  a0ca2a:	jne    a0ca0b <pp_compile_macro+0xeb>
  a0ca2c:	lea    -0x1(%rcx),%edi
  a0ca2f:	movzbl (%rsi,%rdi,1),%edi
  a0ca33:	mov    $0xaa,%esi
  a0ca38:	and    $0x7f,%dil
  a0ca3c:	cmp    $0x1,%dil
  a0ca40:	jne    a0c9f7 <pp_compile_macro+0xd7>
  a0ca42:	jmp    a0ca0b <pp_compile_macro+0xeb>
  a0ca44:	mov    %ecx,0x30(%r14)
  a0ca48:	add    %r9d,0xe10(%rbx)
  a0ca4f:	movq   $0x0,0x70(%rsp)
  a0ca58:	jmp    a0d265 <pp_compile_macro+0x945>
  a0ca5d:	add    %r9d,0xe10(%rbx)
  a0ca64:	cmp    $0x4000001,%eax
  a0ca69:	jae    a0d240 <pp_compile_macro+0x920>
  a0ca6f:	mov    0x30(%r14),%r13d
  a0ca73:	shl    $0x2,%r13
  a0ca77:	add    0xe08(%rbx),%r13
  a0ca7e:	cmpw   $0x11,0x58(%rsp)
  a0ca84:	movq   $0x0,0x70(%rsp)
  a0ca8d:	jb     a0caf9 <pp_compile_macro+0x1d9>
  a0ca8f:	movzbl 0x278(%rbx),%esi
  a0ca96:	lea    0x70(%rsp),%rdi
  a0ca9b:	mov    %r11b,0x8(%rsp)
  a0caa0:	call   9f1890 <pp_parameter_index_allocate>
  a0caa5:	test   %al,%al
  a0caa7:	je     a0d24b <pp_compile_macro+0x92b>
  a0caad:	mov    0x70(%rsp),%r14
  a0cab2:	lea    0x7c(%rsp),%r12
  a0cab7:	xor    %r15d,%r15d
  a0caba:	nopw   0x0(%rax,%rax,1)
  a0cac0:	mov    0x0(%r13,%r15,4),%esi
  a0cac5:	mov    %r14,%rdi
  a0cac8:	mov    %r15d,%edx
  a0cacb:	mov    %r12,%rcx
  a0cace:	call   9f1a40 <pp_parameter_insert>
  a0cad3:	test   %al,%al
  a0cad5:	je     a0cae1 <pp_compile_macro+0x1c1>
  a0cad7:	inc    %r15
  a0cada:	cmp    0x58(%rsp),%r15
  a0cadf:	jb     a0cac0 <pp_compile_macro+0x1a0>
  a0cae1:	mov    0x18(%rsp),%rbx
  a0cae6:	mov    0x20(%rsp),%r14
  a0caeb:	movzbl 0x8(%rsp),%r11d
  a0caf1:	test   %al,%al
  a0caf3:	je     a0d24b <pp_compile_macro+0x92b>
  a0caf9:	cmpw   $0x5,0x38(%rsp)
  a0caff:	mov    0xe00(%rbx),%ecx
  a0cb05:	lea    0x28(%r14),%r15
  a0cb09:	setae  %al
  a0cb0c:	and    0x278(%rbx),%al
  a0cb12:	mov    %ecx,0x28(%r14)
  a0cb16:	movq   $0x0,0x38(%r14)
  a0cb1e:	mov    0x18(%r14),%ecx
  a0cb22:	mov    0x1c(%r14),%edi
  a0cb26:	mov    %al,0x50(%rsp)
  a0cb2a:	lea    0x38(%r14),%rax
  a0cb2e:	mov    %rax,0x48(%rsp)
  a0cb33:	cmp    %edi,%ecx
  a0cb35:	jae    a0d4d8 <pp_compile_macro+0xbb8>
  a0cb3b:	mov    0x70(%rsp),%rax
  a0cb40:	mov    $0xffff,%edx
  a0cb45:	mov    %r15,0x60(%rsp)
  a0cb4a:	movl   $0xffffffff,0x4(%rsp)
  a0cb52:	movq   $0x0,0x30(%rsp)
  a0cb5b:	movl   $0x0,0x14(%rsp)
  a0cb63:	mov    %rax,0x28(%rsp)
  a0cb68:	mov    0x38(%rsp),%rax
  a0cb6d:	bzhi   %eax,%edx,%eax
  a0cb72:	mov    %eax,0x6c(%rsp)
  a0cb76:	jmp    a0cbce <pp_compile_macro+0x2ae>
  a0cb78:	nopl   0x0(%rax,%rax,1)
  a0cb80:	mov    $0x3,%al
  a0cb82:	xor    %r8d,%r8d
  a0cb85:	mov    0x18(%rsp),%rbx
  a0cb8a:	mov    %ecx,%esi
  a0cb8c:	mov    0x20(%rsp),%r14
  a0cb91:	mov    0x8(%rsp),%r10d
  a0cb96:	mov    %r12d,%r11d
  a0cb99:	mov    0xdf8(%rbx),%rdx
  a0cba0:	mov    0xe00(%rbx),%edi
  a0cba6:	mov    %al,(%rdx,%rdi,8)
  a0cba9:	mov    %r10b,0x1(%rdx,%rdi,8)
  a0cbae:	mov    %r8w,0x2(%rdx,%rdi,8)
  a0cbb4:	mov    %ecx,0x4(%rdx,%rdi,8)
  a0cbb8:	incl   0xe00(%rbx)
  a0cbbe:	mov    %esi,%ecx
  a0cbc0:	mov    0x1c(%r14),%edi
  a0cbc4:	inc    %ecx
  a0cbc6:	cmp    %edi,%ecx
  a0cbc8:	jae    a0d211 <pp_compile_macro+0x8f1>
  a0cbce:	mov    0x50(%rbp),%r15
  a0cbd2:	mov    0x18(%r14),%r14d
  a0cbd6:	cmp    %r14d,%ecx
  a0cbd9:	jne    a0cbf0 <pp_compile_macro+0x2d0>
  a0cbdb:	mov    0x28(%rsp),%rbx
  a0cbe0:	jmp    a0cc20 <pp_compile_macro+0x300>
  a0cbe2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0cbf0:	mov    0x68(%rbp),%rax
  a0cbf4:	mov    %ecx,%edx
  a0cbf6:	shr    $0x6,%edx
  a0cbf9:	mov    0x28(%rsp),%rbx
  a0cbfe:	mov    (%rax,%rdx,8),%rax
  a0cc02:	bt     %rcx,%rax
  a0cc06:	jae    a0cc20 <pp_compile_macro+0x300>
  a0cc08:	lea    -0x1(%rcx),%eax
  a0cc0b:	movzbl (%r15,%rax,1),%eax
  a0cc10:	and    $0x7f,%al
  a0cc12:	cmp    $0x3d,%al
  a0cc14:	setne  %al
  a0cc17:	mov    %eax,0x8(%rsp)
  a0cc1b:	jmp    a0cc28 <pp_compile_macro+0x308>
  a0cc1d:	nopl   (%rax)
  a0cc20:	movl   $0x0,0x8(%rsp)
  a0cc28:	mov    %ecx,%r10d
  a0cc2b:	movzbl (%r15,%r10,1),%esi
  a0cc30:	and    $0x7f,%sil
  a0cc34:	cmp    $0x1,%sil
  a0cc38:	sete   %al
  a0cc3b:	and    %r11b,%al
  a0cc3e:	cmp    $0x1,%al
  a0cc40:	jne    a0cc60 <pp_compile_macro+0x340>
  a0cc42:	mov    0x60(%rbp),%rax
  a0cc46:	cmpl   $0xab,(%rax,%r10,4)
  a0cc4e:	sete   %al
  a0cc51:	jmp    a0cc62 <pp_compile_macro+0x342>
  a0cc53:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0cc60:	xor    %eax,%eax
  a0cc62:	cmp    $0x1,%sil
  a0cc66:	mov    %r11d,%r12d
  a0cc69:	sete   %dl
  a0cc6c:	and    %r11b,%dl
  a0cc6f:	cmp    $0x1,%dl
  a0cc72:	jne    a0ce00 <pp_compile_macro+0x4e0>
  a0cc78:	test   %al,%al
  a0cc7a:	jne    a0ce00 <pp_compile_macro+0x4e0>
  a0cc80:	mov    0x60(%rbp),%rdx
  a0cc84:	mov    (%rdx,%r10,4),%r11d
  a0cc88:	test   %rbx,%rbx
  a0cc8b:	je     a0cd0a <pp_compile_macro+0x3ea>
  a0cc8d:	mov    0x80(%rbx),%r9
  a0cc94:	test   %r9,%r9
  a0cc97:	je     a0cd4f <pp_compile_macro+0x42f>
  a0cc9d:	mov    0x88(%rbx),%edx
  a0cca3:	movabs $0x9e3779b97f4a7c15,%r8
  a0ccad:	mov    %r15,0x40(%rsp)
  a0ccb2:	mov    %r14d,%r15d
  a0ccb5:	mov    %r11,%r14
  a0ccb8:	imul   %r8,%r14
  a0ccbc:	shr    $0x20,%r14
  a0ccc0:	dec    %edx
  a0ccc2:	and    %edx,%r14d
  a0ccc5:	mov    (%r9,%r14,8),%r8
  a0ccc9:	test   %r8,%r8
  a0cccc:	je     a0cceb <pp_compile_macro+0x3cb>
  a0ccce:	xchg   %ax,%ax
  a0ccd0:	mov    %r8,%rbx
  a0ccd3:	shr    $0x20,%rbx
  a0ccd7:	cmp    %ebx,%r11d
  a0ccda:	je     a0cceb <pp_compile_macro+0x3cb>
  a0ccdc:	inc    %r14d
  a0ccdf:	and    %edx,%r14d
  a0cce2:	mov    (%r9,%r14,8),%r8
  a0cce6:	test   %r8,%r8
  a0cce9:	jne    a0ccd0 <pp_compile_macro+0x3b0>
  a0cceb:	mov    %r15d,%r14d
  a0ccee:	mov    0x28(%rsp),%rbx
  a0ccf3:	mov    0x40(%rsp),%r15
  a0ccf8:	dec    %r8d
  a0ccfb:	cmp    $0xffffffff,%r8d
  a0ccff:	jne    a0cdd0 <pp_compile_macro+0x4b0>
  a0cd05:	jmp    a0ce0a <pp_compile_macro+0x4ea>
  a0cd0a:	cmpb   $0x0,0x50(%rsp)
  a0cd0f:	je     a0cda2 <pp_compile_macro+0x482>
  a0cd15:	mov    0x6c(%rsp),%edx
  a0cd19:	vpbroadcastd %r11d,%zmm1
  a0cd1f:	kmovd  %edx,%k1
  a0cd23:	vmovdqu32 0x0(%r13),%zmm0{%k1}{z}
  a0cd2a:	vpcmpeqd %zmm1,%zmm0,%k0
  a0cd30:	ktestw %k1,%k0
  a0cd34:	je     a0ce0a <pp_compile_macro+0x4ea>
  a0cd3a:	kandw  %k1,%k0,%k0
  a0cd3e:	kmovd  %k0,%eax
  a0cd42:	xor    %r8d,%r8d
  a0cd45:	tzcnt  %eax,%r8d
  a0cd4a:	jmp    a0cdd0 <pp_compile_macro+0x4b0>
  a0cd4f:	mov    0x8c(%rbx),%edx
  a0cd55:	cmpb   $0x0,0x90(%rbx)
  a0cd5c:	je     a0cdd7 <pp_compile_macro+0x4b7>
  a0cd5e:	mov    $0xffff,%r8d
  a0cd64:	vpbroadcastd %r11d,%zmm1
  a0cd6a:	bzhi   %edx,%r8d,%edx
  a0cd6f:	kmovd  %edx,%k1
  a0cd73:	vmovdqu32 (%rbx),%zmm0{%k1}{z}
  a0cd79:	vpcmpeqd %zmm1,%zmm0,%k0
  a0cd7f:	ktestw %k1,%k0
  a0cd83:	je     a0ce0a <pp_compile_macro+0x4ea>
  a0cd89:	kandw  %k1,%k0,%k0
  a0cd8d:	kmovd  %k0,%edx
  a0cd91:	tzcnt  %edx,%edx
  a0cd95:	mov    0x40(%rbx,%rdx,4),%r8d
  a0cd9a:	cmp    $0xffffffff,%r8d
  a0cd9e:	jne    a0cdd0 <pp_compile_macro+0x4b0>
  a0cda0:	jmp    a0ce0a <pp_compile_macro+0x4ea>
  a0cda2:	mov    $0xffffffff,%r8d
  a0cda8:	mov    $0x1,%edx
  a0cdad:	nopl   (%rax)
  a0cdb0:	mov    -0x4(%r13,%rdx,4),%r9d
  a0cdb5:	inc    %r8d
  a0cdb8:	cmp    %r11d,%r9d
  a0cdbb:	je     a0cdc8 <pp_compile_macro+0x4a8>
  a0cdbd:	cmp    0x58(%rsp),%rdx
  a0cdc2:	lea    0x1(%rdx),%rdx
  a0cdc6:	jb     a0cdb0 <pp_compile_macro+0x490>
  a0cdc8:	cmp    %r11d,%r9d
  a0cdcb:	jne    a0ce0a <pp_compile_macro+0x4ea>
  a0cdcd:	nopl   (%rax)
  a0cdd0:	mov    $0x1,%al
  a0cdd2:	jmp    a0cb85 <pp_compile_macro+0x265>
  a0cdd7:	test   %rdx,%rdx
  a0cdda:	je     a0ce00 <pp_compile_macro+0x4e0>
  a0cddc:	xor    %r9d,%r9d
  a0cddf:	nop
  a0cde0:	mov    $0xffffffff,%r8d
  a0cde6:	cmp    %r11d,(%rbx,%r9,4)
  a0cdea:	jne    a0cdf1 <pp_compile_macro+0x4d1>
  a0cdec:	mov    0x40(%rbx,%r9,4),%r8d
  a0cdf1:	cmp    $0xffffffff,%r8d
  a0cdf5:	jne    a0cdd0 <pp_compile_macro+0x4b0>
  a0cdf7:	inc    %r9
  a0cdfa:	cmp    %r9,%rdx
  a0cdfd:	jne    a0cde0 <pp_compile_macro+0x4c0>
  a0cdff:	nop
  a0ce00:	cmp    $0x3d,%sil
  a0ce04:	je     a0cb80 <pp_compile_macro+0x260>
  a0ce0a:	test   %al,%al
  a0ce0c:	je     a0ce60 <pp_compile_macro+0x540>
  a0ce0e:	cmpl   $0xffffffff,0x4(%rsp)
  a0ce13:	jne    a0d657 <pp_compile_macro+0xd37>
  a0ce19:	lea    0x1(%rcx),%esi
  a0ce1c:	cmp    %edi,%esi
  a0ce1e:	jae    a0d657 <pp_compile_macro+0xd37>
  a0ce24:	mov    %esi,%eax
  a0ce26:	movzbl (%r15,%rax,1),%eax
  a0ce2b:	and    $0x7f,%al
  a0ce2d:	cmp    $0xf,%al
  a0ce2f:	jne    a0d657 <pp_compile_macro+0xd37>
  a0ce35:	mov    0x18(%rsp),%rbx
  a0ce3a:	movl   $0x1,0x14(%rsp)
  a0ce42:	xor    %r8d,%r8d
  a0ce45:	mov    0xe00(%rbx),%eax
  a0ce4b:	mov    %eax,0x4(%rsp)
  a0ce4f:	lea    0x2(%rcx),%eax
  a0ce52:	mov    %rax,0x30(%rsp)
  a0ce57:	mov    $0x4,%al
  a0ce59:	jmp    a0cb8c <pp_compile_macro+0x26c>
  a0ce5e:	xchg   %ax,%ax
  a0ce60:	cmp    $0x3c,%sil
  a0ce64:	mov    %r12d,%r11d
  a0ce67:	sete   %al
  a0ce6a:	and    %r12b,%al
  a0ce6d:	cmp    $0x1,%al
  a0ce6f:	jne    a0cea6 <pp_compile_macro+0x586>
  a0ce71:	lea    0x1(%rcx),%esi
  a0ce74:	cmp    %edi,%esi
  a0ce76:	jae    a0d7ca <pp_compile_macro+0xeaa>
  a0ce7c:	mov    %esi,%edx
  a0ce7e:	movzbl (%r15,%rdx,1),%r8d
  a0ce83:	and    $0x7f,%r8b
  a0ce87:	cmp    $0x1,%r8b
  a0ce8b:	jne    a0ceec <pp_compile_macro+0x5cc>
  a0ce8d:	mov    0x60(%rbp),%rax
  a0ce91:	cmpl   $0xab,(%rax,%rdx,4)
  a0ce98:	sete   %al
  a0ce9b:	cmp    $0x1,%r8b
  a0ce9f:	je     a0cef8 <pp_compile_macro+0x5d8>
  a0cea1:	jmp    a0d0ea <pp_compile_macro+0x7ca>
  a0cea6:	cmpl   $0xffffffff,0x4(%rsp)
  a0ceab:	je     a0ceb9 <pp_compile_macro+0x599>
  a0cead:	cmp    $0xf,%sil
  a0ceb1:	jne    a0ceb9 <pp_compile_macro+0x599>
  a0ceb3:	incl   0x14(%rsp)
  a0ceb7:	jmp    a0cee0 <pp_compile_macro+0x5c0>
  a0ceb9:	xor    %eax,%eax
  a0cebb:	cmpl   $0xffffffff,0x4(%rsp)
  a0cec0:	mov    $0x0,%r8d
  a0cec6:	je     a0cf80 <pp_compile_macro+0x660>
  a0cecc:	cmp    $0x10,%sil
  a0ced0:	jne    a0cf80 <pp_compile_macro+0x660>
  a0ced6:	decl   0x14(%rsp)
  a0ceda:	je     a0d02a <pp_compile_macro+0x70a>
  a0cee0:	xor    %r8d,%r8d
  a0cee3:	mov    %ecx,%esi
  a0cee5:	xor    %eax,%eax
  a0cee7:	jmp    a0d0af <pp_compile_macro+0x78f>
  a0ceec:	xor    %eax,%eax
  a0ceee:	cmp    $0x1,%r8b
  a0cef2:	jne    a0d0ea <pp_compile_macro+0x7ca>
  a0cef8:	test   %al,%al
  a0cefa:	jne    a0d0ea <pp_compile_macro+0x7ca>
  a0cf00:	mov    0x60(%rbp),%r8
  a0cf04:	mov    (%r8,%rdx,4),%r10d
  a0cf08:	test   %rbx,%rbx
  a0cf0b:	je     a0cf87 <pp_compile_macro+0x667>
  a0cf0d:	mov    0x80(%rbx),%r9
  a0cf14:	test   %r9,%r9
  a0cf17:	je     a0cfcc <pp_compile_macro+0x6ac>
  a0cf1d:	mov    0x88(%rbx),%edx
  a0cf23:	movabs $0x9e3779b97f4a7c15,%r8
  a0cf2d:	mov    %r10,%r11
  a0cf30:	imul   %r8,%r11
  a0cf34:	shr    $0x20,%r11
  a0cf38:	dec    %edx
  a0cf3a:	and    %edx,%r11d
  a0cf3d:	mov    (%r9,%r11,8),%r8
  a0cf41:	test   %r8,%r8
  a0cf44:	je     a0cf6b <pp_compile_macro+0x64b>
  a0cf46:	cs nopw 0x0(%rax,%rax,1)
  a0cf50:	mov    %r8,%rbx
  a0cf53:	shr    $0x20,%rbx
  a0cf57:	cmp    %ebx,%r10d
  a0cf5a:	je     a0cf6b <pp_compile_macro+0x64b>
  a0cf5c:	inc    %r11d
  a0cf5f:	and    %edx,%r11d
  a0cf62:	mov    (%r9,%r11,8),%r8
  a0cf66:	test   %r8,%r8
  a0cf69:	jne    a0cf50 <pp_compile_macro+0x630>
  a0cf6b:	dec    %r8d
  a0cf6e:	mov    %r12d,%r11d
  a0cf71:	cmp    $0xffffffff,%r8d
  a0cf75:	jne    a0d0ad <pp_compile_macro+0x78d>
  a0cf7b:	jmp    a0d0ea <pp_compile_macro+0x7ca>
  a0cf80:	mov    %ecx,%esi
  a0cf82:	jmp    a0d0af <pp_compile_macro+0x78f>
  a0cf87:	cmpb   $0x0,0x50(%rsp)
  a0cf8c:	je     a0d07b <pp_compile_macro+0x75b>
  a0cf92:	mov    0x6c(%rsp),%edx
  a0cf96:	vpbroadcastd %r10d,%zmm1
  a0cf9c:	kmovd  %edx,%k1
  a0cfa0:	vmovdqu32 0x0(%r13),%zmm0{%k1}{z}
  a0cfa7:	vpcmpeqd %zmm1,%zmm0,%k0
  a0cfad:	ktestw %k1,%k0
  a0cfb1:	je     a0d0ea <pp_compile_macro+0x7ca>
  a0cfb7:	kandw  %k1,%k0,%k0
  a0cfbb:	kmovd  %k0,%eax
  a0cfbf:	xor    %r8d,%r8d
  a0cfc2:	tzcnt  %eax,%r8d
  a0cfc7:	jmp    a0d0ad <pp_compile_macro+0x78d>
  a0cfcc:	mov    0x8c(%rbx),%edx
  a0cfd2:	cmpb   $0x0,0x90(%rbx)
  a0cfd9:	je     a0d0c3 <pp_compile_macro+0x7a3>
  a0cfdf:	mov    $0xffff,%r8d
  a0cfe5:	vpbroadcastd %r10d,%zmm1
  a0cfeb:	bzhi   %edx,%r8d,%edx
  a0cff0:	kmovd  %edx,%k1
  a0cff4:	vmovdqu32 (%rbx),%zmm0{%k1}{z}
  a0cffa:	vpcmpeqd %zmm1,%zmm0,%k0
  a0d000:	ktestw %k1,%k0
  a0d004:	je     a0d0ea <pp_compile_macro+0x7ca>
  a0d00a:	kandw  %k1,%k0,%k0
  a0d00e:	kmovd  %k0,%edx
  a0d012:	tzcnt  %edx,%edx
  a0d016:	mov    0x40(%rbx,%rdx,4),%r8d
  a0d01b:	cmp    $0xffffffff,%r8d
  a0d01f:	jne    a0d0ad <pp_compile_macro+0x78d>
  a0d025:	jmp    a0d0ea <pp_compile_macro+0x7ca>
  a0d02a:	mov    0x30(%rsp),%rdx
  a0d02f:	xor    %eax,%eax
  a0d031:	cmp    %ecx,%edx
  a0d033:	ja     a0d188 <pp_compile_macro+0x868>
  a0d039:	jmp    a0d04a <pp_compile_macro+0x72a>
  a0d03b:	nopl   0x0(%rax,%rax,1)
  a0d040:	inc    %edx
  a0d042:	cmp    %ecx,%edx
  a0d044:	ja     a0d183 <pp_compile_macro+0x863>
  a0d04a:	cmp    %edx,%r14d
  a0d04d:	je     a0d040 <pp_compile_macro+0x720>
  a0d04f:	mov    0x68(%rbp),%rsi
  a0d053:	mov    %edx,%edi
  a0d055:	shr    $0x6,%edi
  a0d058:	mov    (%rsi,%rdi,8),%rsi
  a0d05c:	bt     %rdx,%rsi
  a0d060:	jae    a0d040 <pp_compile_macro+0x720>
  a0d062:	lea    -0x1(%rdx),%esi
  a0d065:	movzbl (%r15,%rsi,1),%esi
  a0d06a:	and    $0x7f,%sil
  a0d06e:	cmp    $0x3d,%sil
  a0d072:	setne  %sil
  a0d076:	or     %sil,%al
  a0d079:	jmp    a0d040 <pp_compile_macro+0x720>
  a0d07b:	mov    $0xffffffff,%r8d
  a0d081:	mov    $0x1,%edx
  a0d086:	cs nopw 0x0(%rax,%rax,1)
  a0d090:	mov    -0x4(%r13,%rdx,4),%r9d
  a0d095:	inc    %r8d
  a0d098:	cmp    %r10d,%r9d
  a0d09b:	je     a0d0a8 <pp_compile_macro+0x788>
  a0d09d:	cmp    0x58(%rsp),%rdx
  a0d0a2:	lea    0x1(%rdx),%rdx
  a0d0a6:	jb     a0d090 <pp_compile_macro+0x770>
  a0d0a8:	cmp    %r10d,%r9d
  a0d0ab:	jne    a0d0ea <pp_compile_macro+0x7ca>
  a0d0ad:	mov    $0x2,%al
  a0d0af:	mov    0x18(%rsp),%rbx
  a0d0b4:	mov    0x20(%rsp),%r14
  a0d0b9:	mov    0x8(%rsp),%r10d
  a0d0be:	jmp    a0cb99 <pp_compile_macro+0x279>
  a0d0c3:	test   %rdx,%rdx
  a0d0c6:	je     a0d0ea <pp_compile_macro+0x7ca>
  a0d0c8:	xor    %r9d,%r9d
  a0d0cb:	mov    $0xffffffff,%r8d
  a0d0d1:	cmp    %r10d,(%rbx,%r9,4)
  a0d0d5:	jne    a0d0dc <pp_compile_macro+0x7bc>
  a0d0d7:	mov    0x40(%rbx,%r9,4),%r8d
  a0d0dc:	cmp    $0xffffffff,%r8d
  a0d0e0:	jne    a0d0ad <pp_compile_macro+0x78d>
  a0d0e2:	inc    %r9
  a0d0e5:	cmp    %r9,%rdx
  a0d0e8:	jne    a0d0cb <pp_compile_macro+0x7ab>
  a0d0ea:	cmpl   $0xffffffff,0x4(%rsp)
  a0d0ef:	sete   %dl
  a0d0f2:	and    %dl,%al
  a0d0f4:	cmp    $0x1,%al
  a0d0f6:	jne    a0d7ca <pp_compile_macro+0xeaa>
  a0d0fc:	lea    0x2(%rcx),%r9d
  a0d100:	cmp    %edi,%r9d
  a0d103:	jae    a0d7ca <pp_compile_macro+0xeaa>
  a0d109:	mov    %r9d,%eax
  a0d10c:	movzbl (%r15,%rax,1),%eax
  a0d111:	and    $0x7f,%al
  a0d113:	cmp    $0xf,%al
  a0d115:	jne    a0d7ca <pp_compile_macro+0xeaa>
  a0d11b:	cmp    %r14d,%esi
  a0d11e:	jne    a0d12c <pp_compile_macro+0x80c>
  a0d120:	mov    0x18(%rsp),%rbx
  a0d125:	mov    0x8(%rsp),%r10d
  a0d12a:	jmp    a0d157 <pp_compile_macro+0x837>
  a0d12c:	mov    0x68(%rbp),%rax
  a0d130:	mov    %esi,%edx
  a0d132:	shr    $0x6,%esi
  a0d135:	mov    0x8(%rsp),%r10d
  a0d13a:	mov    0x18(%rsp),%rbx
  a0d13f:	mov    (%rax,%rsi,8),%rax
  a0d143:	movzbl %r10b,%esi
  a0d147:	or     $0x10,%r10b
  a0d14b:	movzbl %r10b,%r10d
  a0d14f:	bt     %rdx,%rax
  a0d153:	cmovae %esi,%r10d
  a0d157:	mov    0xe00(%rbx),%eax
  a0d15d:	mov    0x20(%rsp),%r14
  a0d162:	movl   $0x1,0x14(%rsp)
  a0d16a:	xor    %r8d,%r8d
  a0d16d:	mov    %r9d,%esi
  a0d170:	mov    %eax,0x4(%rsp)
  a0d174:	lea    0x3(%rcx),%eax
  a0d177:	mov    %rax,0x30(%rsp)
  a0d17c:	mov    $0x5,%al
  a0d17e:	jmp    a0cb99 <pp_compile_macro+0x279>
  a0d183:	and    $0x1,%al
  a0d185:	shl    $0x6,%al
  a0d188:	cmp    %r14d,%ecx
  a0d18b:	jne    a0d199 <pp_compile_macro+0x879>
  a0d18d:	mov    0x18(%rsp),%rbx
  a0d192:	mov    0x20(%rsp),%r14
  a0d197:	jmp    a0d1ce <pp_compile_macro+0x8ae>
  a0d199:	mov    0x68(%rbp),%rdx
  a0d19d:	mov    %ecx,%esi
  a0d19f:	shr    $0x6,%esi
  a0d1a2:	mov    0x18(%rsp),%rbx
  a0d1a7:	mov    0x20(%rsp),%r14
  a0d1ac:	mov    (%rdx,%rsi,8),%rdx
  a0d1b0:	bt     %rcx,%rdx
  a0d1b4:	jae    a0d1ce <pp_compile_macro+0x8ae>
  a0d1b6:	lea    -0x1(%rcx),%edx
  a0d1b9:	movzbl (%r15,%rdx,1),%edx
  a0d1be:	and    $0x7f,%dl
  a0d1c1:	cmp    $0x3d,%dl
  a0d1c4:	setne  %dl
  a0d1c7:	shl    $0x5,%dl
  a0d1ca:	or     %al,%dl
  a0d1cc:	mov    %edx,%eax
  a0d1ce:	mov    0x4(%rsp),%edi
  a0d1d2:	mov    0xdf8(%rbx),%rdx
  a0d1d9:	movl   $0xffffffff,0x4(%rsp)
  a0d1e1:	movl   $0x0,0x14(%rsp)
  a0d1e9:	mov    %edi,%esi
  a0d1eb:	or     %al,0x1(%rdx,%rsi,8)
  a0d1ef:	not    %edi
  a0d1f1:	add    0xe00(%rbx),%edi
  a0d1f7:	mov    0xdf8(%rbx),%rax
  a0d1fe:	mov    %di,0x2(%rax,%rsi,8)
  a0d203:	mov    0x1c(%r14),%edi
  a0d207:	inc    %ecx
  a0d209:	cmp    %edi,%ecx
  a0d20b:	jb     a0cbce <pp_compile_macro+0x2ae>
  a0d211:	cmpl   $0xffffffff,0x4(%rsp)
  a0d216:	mov    0x60(%rsp),%r15
  a0d21b:	je     a0d4d8 <pp_compile_macro+0xbb8>
  a0d221:	mov    0x24(%r14),%edx
  a0d225:	lea    -0x2b7cc0(%rip),%rcx        # 75556c <pp_decode_file_name.meaning+0x1e24d>
  a0d22c:	mov    $0x1,%esi
  a0d231:	mov    %rbx,%rdi
  a0d234:	xor    %eax,%eax
  a0d236:	vzeroupper
  a0d239:	call   98b970 <pp_diagnose>
  a0d23e:	jmp    a0d284 <pp_compile_macro+0x964>
  a0d240:	movq   $0x0,0x70(%rsp)
  a0d249:	jmp    a0d265 <pp_compile_macro+0x945>
  a0d24b:	mov    0x24(%r14),%edx
  a0d24f:	lea    -0x3f94a4(%rip),%rcx        # 613db2 <parse_test_openers+0x47872>
  a0d256:	mov    $0x2,%esi
  a0d25b:	mov    %rbx,%rdi
  a0d25e:	xor    %eax,%eax
  a0d260:	call   98b970 <pp_diagnose>
  a0d265:	mov    0xe00(%rbx),%eax
  a0d26b:	lea    0x38(%r14),%rcx
  a0d26f:	lea    0x28(%r14),%r15
  a0d273:	mov    %rcx,0x48(%rsp)
  a0d278:	mov    %eax,0x28(%r14)
  a0d27c:	movq   $0x0,0x38(%r14)
  a0d284:	mov    (%r15),%r13d
  a0d287:	mov    0xe00(%rbx),%r10d
  a0d28e:	lea    0xdf8(%rbx),%rax
  a0d295:	movl   $0x0,0x40(%rsp)
  a0d29d:	movl   $0x0,0x4(%rsp)
  a0d2a5:	mov    %rax,0x50(%rsp)
  a0d2aa:	mov    %r13d,%eax
  a0d2ad:	shl    $0x3,%r13
  a0d2b1:	add    0xdf8(%rbx),%r13
  a0d2b8:	sub    %eax,%r10d
  a0d2bb:	setne  %r8b
  a0d2bf:	sete   %al
  a0d2c2:	mov    %eax,0x30(%rsp)
  a0d2c6:	mov    $0xfffffffffffff560,%rcx
  a0d2cd:	mov    %r10,0x28(%rsp)
  a0d2d2:	mov    %r15,0x60(%rsp)
  a0d2d7:	mov    %r8d,0x14(%rsp)
  a0d2dc:	mov    %fs:0x20(%rcx),%r14
  a0d2e1:	test   %r14,%r14
  a0d2e4:	je     a0d2f0 <pp_compile_macro+0x9d0>
  a0d2e6:	mov    %fs:0x28(%rcx),%r12
  a0d2eb:	jmp    a0d3a1 <pp_compile_macro+0xa81>
  a0d2f0:	movabs $0x1000200000,%r15
  a0d2fa:	mov    $0x3,%edx
  a0d2ff:	mov    $0x4022,%ecx
  a0d304:	mov    $0xffffffff,%r8d
  a0d30a:	xor    %r12d,%r12d
  a0d30d:	xor    %edi,%edi
  a0d30f:	xor    %r9d,%r9d
  a0d312:	mov    %r15,%rsi
  a0d315:	vzeroupper
  a0d318:	call   7ce770 <mmap@plt>
  a0d31d:	cmp    $0xffffffffffffffff,%rax
  a0d321:	je     a0d375 <pp_compile_macro+0xa55>
  a0d323:	lea    0x20ffff(%rax),%r14
  a0d32a:	mov    $0xf,%edx
  a0d32f:	mov    %rax,%rdi
  a0d332:	and    $0xffffffffffe00000,%r14
  a0d339:	mov    %r14,%r12
  a0d33c:	sub    %rax,%r12
  a0d33f:	mov    %r12,%rsi
  a0d342:	lea    -0x10000(%r12),%rbx
  a0d34a:	call   7ce720 <madvise@plt>
  a0d34f:	mov    %r15,%rsi
  a0d352:	sub    %r12,%rsi
  a0d355:	mov    $0xe,%edx
  a0d35a:	mov    %r14,%rdi
  a0d35d:	call   7ce720 <madvise@plt>
  a0d362:	add    $0xffffffffffe00000,%r15
  a0d369:	add    $0xffffffffffff0000,%r14
  a0d370:	mov    %r15,%r12
  a0d373:	jmp    a0d37a <pp_compile_macro+0xa5a>
  a0d375:	xor    %r14d,%r14d
  a0d378:	xor    %ebx,%ebx
  a0d37a:	mov    $0xfffffffffffff560,%rcx
  a0d381:	mov    0x14(%rsp),%r8d
  a0d386:	mov    %r14,%fs:0x20(%rcx)
  a0d38b:	movq   $0x0,%fs:0x28(%rcx)
  a0d394:	mov    %r12,%fs:0x30(%rcx)
  a0d399:	xor    %r12d,%r12d
  a0d39c:	mov    %rbx,%fs:0x38(%rcx)
  a0d3a1:	lea    0x7(%r12,%r14,1),%r15
  a0d3a6:	lea    (%r12,%r14,1),%rax
  a0d3aa:	movq   $0x0,0x8(%rsp)
  a0d3b3:	and    $0xfffffffffffffff8,%r15
  a0d3b7:	cmp    %rax,%r15
  a0d3ba:	jae    a0d3c2 <pp_compile_macro+0xaa2>
  a0d3bc:	xor    %eax,%eax
  a0d3be:	xor    %ecx,%ecx
  a0d3c0:	jmp    a0d417 <pp_compile_macro+0xaf7>
  a0d3c2:	mov    %fs:0x30(%rcx),%rdi
  a0d3c7:	mov    %r15,%rsi
  a0d3ca:	sub    %r14,%rsi
  a0d3cd:	xor    %ecx,%ecx
  a0d3cf:	mov    $0x0,%eax
  a0d3d4:	sub    %rsi,%rdi
  a0d3d7:	jb     a0d417 <pp_compile_macro+0xaf7>
  a0d3d9:	mov    0x58(%rsp),%rdx
  a0d3de:	add    $0x3f,%edx
  a0d3e1:	shr    $0x3,%edx
  a0d3e4:	and    $0xfffffff8,%edx
  a0d3e7:	cmp    %rdi,%rdx
  a0d3ea:	ja     a0d417 <pp_compile_macro+0xaf7>
  a0d3ec:	mov    $0xfffffffffffff560,%rax
  a0d3f3:	add    %rdx,%rsi
  a0d3f6:	mov    %rsi,%fs:0x28(%rax)
  a0d3fb:	test   %r15,%r15
  a0d3fe:	je     a0d3bc <pp_compile_macro+0xa9c>
  a0d400:	mov    %r15,%rdi
  a0d403:	xor    %esi,%esi
  a0d405:	vzeroupper
  a0d408:	call   7ce560 <memset@plt>
  a0d40d:	mov    0x14(%rsp),%r8d
  a0d412:	mov    $0x1,%al
  a0d414:	mov    %r15,%rcx
  a0d417:	mov    0x4(%rsp),%edx
  a0d41b:	and    %r8b,%dl
  a0d41e:	cmp    $0x1,%dl
  a0d421:	jne    a0d969 <pp_compile_macro+0x1049>
  a0d427:	mov    0x38(%rsp),%rdx
  a0d42c:	movzbl 0x0(%r13),%edi
  a0d431:	mov    $0x3f,%esi
  a0d436:	dec    %edx
  a0d438:	lea    -0x4(%rdi),%r8d
  a0d43c:	cmp    $0x3f,%edx
  a0d43f:	cmovb  %edx,%esi
  a0d442:	mov    $0x1,%edx
  a0d447:	shlx   %rsi,%rdx,%rdx
  a0d44c:	cmp    $0x2,%r8d
  a0d450:	jae    a0d47f <pp_compile_macro+0xb5f>
  a0d452:	testb  $0x2,0x3(%rsp)
  a0d457:	mov    0x48(%rsp),%r15
  a0d45c:	mov    $0x0,%eax
  a0d461:	movq   $0x0,0x8(%rsp)
  a0d46a:	cmovne %rdx,%rax
  a0d46e:	or     %rax,(%r15)
  a0d471:	xor    %eax,%eax
  a0d473:	movzwl 0x2(%r13),%esi
  a0d478:	inc    %esi
  a0d47a:	jmp    a0d808 <pp_compile_macro+0xee8>
  a0d47f:	mov    0x48(%rsp),%r15
  a0d484:	mov    $0xffffffff,%esi
  a0d489:	movq   $0x0,0x8(%rsp)
  a0d492:	cmp    $0x1,%edi
  a0d495:	jne    a0d808 <pp_compile_macro+0xee8>
  a0d49b:	cmpl   $0x2,0x28(%rsp)
  a0d4a0:	jae    a0d510 <pp_compile_macro+0xbf0>
  a0d4a2:	movzwl 0x2(%r13),%edi
  a0d4a7:	mov    $0x3f,%r9d
  a0d4ad:	mov    $0x1,%r10d
  a0d4b3:	movzwl %di,%r8d
  a0d4b7:	cmp    $0x3f,%r8d
  a0d4bb:	cmovb  %r8d,%r9d
  a0d4bf:	shlx   %r9,%r10,%r10
  a0d4c4:	mov    $0x1,%r9b
  a0d4c7:	or     %r10,(%r15)
  a0d4ca:	and    %al,%r9b
  a0d4cd:	cmp    $0x1,%r9b
  a0d4d1:	je     a0d551 <pp_compile_macro+0xc31>
  a0d4d3:	jmp    a0d808 <pp_compile_macro+0xee8>
  a0d4d8:	mov    0xdf8(%rbx),%rdx
  a0d4df:	mov    (%r15),%esi
  a0d4e2:	mov    0xe00(%rbx),%r10d
  a0d4e9:	lea    0xdf8(%rbx),%rax
  a0d4f0:	mov    %rax,0x50(%rsp)
  a0d4f5:	lea    (%rdx,%rsi,8),%r13
  a0d4f9:	sub    %esi,%r10d
  a0d4fc:	jne    a0d5c9 <pp_compile_macro+0xca9>
  a0d502:	mov    $0x1,%al
  a0d504:	xor    %r8d,%r8d
  a0d507:	mov    %eax,0x30(%rsp)
  a0d50b:	jmp    a0d646 <pp_compile_macro+0xd26>
  a0d510:	movzwl 0x2(%r13),%edi
  a0d515:	mov    $0x3f,%r11d
  a0d51b:	mov    $0x1,%ebx
  a0d520:	movzwl %di,%r8d
  a0d524:	cmp    $0x3f,%r8d
  a0d528:	cmovb  %r8d,%r11d
  a0d52c:	xor    %r10d,%r10d
  a0d52f:	cmpb   $0x3,0x8(%r13)
  a0d534:	shlx   %r11,%rbx,%r11
  a0d539:	setne  %r9b
  a0d53d:	cmovne %r11,%r10
  a0d541:	or     %r10,(%r15)
  a0d544:	and    %al,%r9b
  a0d547:	cmp    $0x1,%r9b
  a0d54b:	jne    a0d808 <pp_compile_macro+0xee8>
  a0d551:	mov    %r8d,%r9d
  a0d554:	shr    $0x6,%r9d
  a0d558:	mov    $0x1,%al
  a0d55a:	mov    (%rcx,%r9,8),%r10
  a0d55e:	bt     %r8,%r10
  a0d562:	jb     a0d808 <pp_compile_macro+0xee8>
  a0d568:	mov    $0x1,%r11d
  a0d56e:	movq   $0x0,0x8(%rsp)
  a0d577:	shlx   %r8,%r11,%r8
  a0d57c:	or     %r8,%r10
  a0d57f:	mov    %r10,(%rcx,%r9,8)
  a0d583:	mov    0x18(%rsp),%r9
  a0d588:	mov    0xe00(%r9),%r8d
  a0d58f:	cmp    $0x3ffffff,%r8
  a0d596:	ja     a0d806 <pp_compile_macro+0xee6>
  a0d59c:	mov    0x50(%rsp),%r9
  a0d5a1:	mov    (%r9),%r9
  a0d5a4:	movw   $0x1,(%r9,%r8,8)
  a0d5ab:	mov    %di,0x2(%r9,%r8,8)
  a0d5b1:	mov    $0x1,%edi
  a0d5b6:	movl   $0x0,0x4(%r9,%r8,8)
  a0d5bf:	mov    %rdi,0x8(%rsp)
  a0d5c4:	jmp    a0d808 <pp_compile_macro+0xee8>
  a0d5c9:	mov    %r10d,%eax
  a0d5cc:	mov    %rax,%rdi
  a0d5cf:	and    $0x3,%rdi
  a0d5d3:	mov    %rax,%rcx
  a0d5d6:	je     a0d635 <pp_compile_macro+0xd15>
  a0d5d8:	mov    $0xffff,%r8d
  a0d5de:	mov    %rax,%rcx
  a0d5e1:	jmp    a0d601 <pp_compile_macro+0xce1>
  a0d5e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d5f0:	xor    %r9d,%r9d
  a0d5f3:	mov    %r9w,-0x6(%r13,%rcx,8)
  a0d5f9:	dec    %rcx
  a0d5fc:	dec    %rdi
  a0d5ff:	je     a0d635 <pp_compile_macro+0xd15>
  a0d601:	cmpb   $0x0,-0x8(%r13,%rcx,8)
  a0d607:	jne    a0d5f9 <pp_compile_macro+0xcd9>
  a0d609:	cmp    %rax,%rcx
  a0d60c:	jae    a0d5f0 <pp_compile_macro+0xcd0>
  a0d60e:	cmpb   $0x0,0x0(%r13,%rcx,8)
  a0d614:	jne    a0d5f0 <pp_compile_macro+0xcd0>
  a0d616:	mov    -0x4(%r13,%rcx,8),%r9d
  a0d61b:	inc    %r9d
  a0d61e:	cmp    %r9d,0x4(%r13,%rcx,8)
  a0d623:	jne    a0d5f0 <pp_compile_macro+0xcd0>
  a0d625:	movzwl 0x2(%r13,%rcx,8),%r9d
  a0d62b:	inc    %r9w
  a0d62f:	cmove  %r8d,%r9d
  a0d633:	jmp    a0d5f3 <pp_compile_macro+0xcd3>
  a0d635:	cmp    $0x4,%r10d
  a0d639:	jae    a0d673 <pp_compile_macro+0xd53>
  a0d63b:	mov    $0x1,%r8b
  a0d63e:	movl   $0x0,0x30(%rsp)
  a0d646:	mov    $0x1,%al
  a0d648:	mov    %eax,0x40(%rsp)
  a0d64c:	mov    $0x1,%al
  a0d64e:	mov    %eax,0x4(%rsp)
  a0d652:	jmp    a0d2c6 <pp_compile_macro+0x9a6>
  a0d657:	mov    0x58(%rbp),%rax
  a0d65b:	mov    0x20(%rsp),%rcx
  a0d660:	mov    (%rax,%r10,4),%edx
  a0d664:	add    0x14(%rcx),%edx
  a0d667:	lea    -0x3dbbf9(%rip),%rcx        # 631a75 <tier0_test_vector_type_class.classes+0x6412>
  a0d66e:	jmp    a0d7e5 <pp_compile_macro+0xec5>
  a0d673:	lea    0x4(%rdx,%rsi,8),%rdx
  a0d678:	add    $0xfffffffffffffffe,%rcx
  a0d67c:	mov    $0xffff,%esi
  a0d681:	jmp    a0d6a4 <pp_compile_macro+0xd84>
  a0d683:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d690:	xor    %edi,%edi
  a0d692:	mov    %di,-0x12(%rdx,%rcx,8)
  a0d697:	add    $0xfffffffffffffffc,%rcx
  a0d69b:	mov    $0x1,%r8b
  a0d69e:	cmp    $0xfffffffffffffffe,%rcx
  a0d6a2:	je     a0d63e <pp_compile_macro+0xd1e>
  a0d6a4:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0d6a9:	je     a0d6d0 <pp_compile_macro+0xdb0>
  a0d6ab:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d6b0:	je     a0d70e <pp_compile_macro+0xdee>
  a0d6b2:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d6b7:	je     a0d752 <pp_compile_macro+0xe32>
  a0d6bd:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d6c2:	jne    a0d697 <pp_compile_macro+0xd77>
  a0d6c4:	jmp    a0d792 <pp_compile_macro+0xe72>
  a0d6c9:	nopl   0x0(%rax)
  a0d6d0:	lea    0x2(%rcx),%rdi
  a0d6d4:	cmp    %rax,%rdi
  a0d6d7:	jae    a0d700 <pp_compile_macro+0xde0>
  a0d6d9:	cmpb   $0x0,0xc(%rdx,%rcx,8)
  a0d6de:	jne    a0d700 <pp_compile_macro+0xde0>
  a0d6e0:	mov    0x8(%rdx,%rcx,8),%edi
  a0d6e4:	inc    %edi
  a0d6e6:	cmp    %edi,0x10(%rdx,%rcx,8)
  a0d6ea:	jne    a0d700 <pp_compile_macro+0xde0>
  a0d6ec:	movzwl 0xe(%rdx,%rcx,8),%edi
  a0d6f1:	inc    %di
  a0d6f4:	cmove  %esi,%edi
  a0d6f7:	jmp    a0d702 <pp_compile_macro+0xde2>
  a0d6f9:	nopl   0x0(%rax)
  a0d700:	xor    %edi,%edi
  a0d702:	mov    %di,0x6(%rdx,%rcx,8)
  a0d707:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d70c:	jne    a0d6b2 <pp_compile_macro+0xd92>
  a0d70e:	lea    0x1(%rcx),%rdi
  a0d712:	cmp    %rax,%rdi
  a0d715:	jae    a0d740 <pp_compile_macro+0xe20>
  a0d717:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0d71c:	jne    a0d740 <pp_compile_macro+0xe20>
  a0d71e:	mov    (%rdx,%rcx,8),%edi
  a0d721:	inc    %edi
  a0d723:	cmp    %edi,0x8(%rdx,%rcx,8)
  a0d727:	jne    a0d740 <pp_compile_macro+0xe20>
  a0d729:	movzwl 0x6(%rdx,%rcx,8),%edi
  a0d72e:	inc    %di
  a0d731:	cmove  %esi,%edi
  a0d734:	jmp    a0d742 <pp_compile_macro+0xe22>
  a0d736:	cs nopw 0x0(%rax,%rax,1)
  a0d740:	xor    %edi,%edi
  a0d742:	mov    %di,-0x2(%rdx,%rcx,8)
  a0d747:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d74c:	jne    a0d6bd <pp_compile_macro+0xd9d>
  a0d752:	cmp    %rax,%rcx
  a0d755:	jae    a0d780 <pp_compile_macro+0xe60>
  a0d757:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0d75c:	jne    a0d780 <pp_compile_macro+0xe60>
  a0d75e:	mov    -0x8(%rdx,%rcx,8),%edi
  a0d762:	inc    %edi
  a0d764:	cmp    %edi,(%rdx,%rcx,8)
  a0d767:	jne    a0d780 <pp_compile_macro+0xe60>
  a0d769:	movzwl -0x2(%rdx,%rcx,8),%edi
  a0d76e:	inc    %di
  a0d771:	cmove  %esi,%edi
  a0d774:	jmp    a0d782 <pp_compile_macro+0xe62>
  a0d776:	cs nopw 0x0(%rax,%rax,1)
  a0d780:	xor    %edi,%edi
  a0d782:	mov    %di,-0xa(%rdx,%rcx,8)
  a0d787:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0d78c:	jne    a0d697 <pp_compile_macro+0xd77>
  a0d792:	lea    -0x1(%rcx),%rdi
  a0d796:	cmp    %rax,%rdi
  a0d799:	jae    a0d690 <pp_compile_macro+0xd70>
  a0d79f:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0d7a4:	jne    a0d690 <pp_compile_macro+0xd70>
  a0d7aa:	mov    -0x10(%rdx,%rcx,8),%edi
  a0d7ae:	inc    %edi
  a0d7b0:	cmp    %edi,-0x8(%rdx,%rcx,8)
  a0d7b4:	jne    a0d690 <pp_compile_macro+0xd70>
  a0d7ba:	movzwl -0xa(%rdx,%rcx,8),%edi
  a0d7bf:	inc    %di
  a0d7c2:	cmove  %esi,%edi
  a0d7c5:	jmp    a0d692 <pp_compile_macro+0xd72>
  a0d7ca:	mov    0x58(%rbp),%rax
  a0d7ce:	cmp    %edi,%esi
  a0d7d0:	adc    $0x0,%ecx
  a0d7d3:	mov    (%rax,%rcx,4),%edx
  a0d7d6:	mov    0x20(%rsp),%rcx
  a0d7db:	add    0x14(%rcx),%edx
  a0d7de:	lea    -0x411cbd(%rip),%rcx        # 5fbb28 <parse_test_openers+0x2f5e8>
  a0d7e5:	mov    0x18(%rsp),%rbx
  a0d7ea:	mov    $0x1,%esi
  a0d7ef:	xor    %eax,%eax
  a0d7f1:	mov    %rbx,%rdi
  a0d7f4:	vzeroupper
  a0d7f7:	call   98b970 <pp_diagnose>
  a0d7fc:	mov    0x60(%rsp),%r15
  a0d801:	jmp    a0d284 <pp_compile_macro+0x964>
  a0d806:	xor    %eax,%eax
  a0d808:	mov    0x28(%rsp),%rdi
  a0d80d:	cmp    $0x2,%edi
  a0d810:	jb     a0d969 <pp_compile_macro+0x1049>
  a0d816:	xor    %r8d,%r8d
  a0d819:	testb  $0x2,0x3(%rsp)
  a0d81e:	mov    $0x2,%r10d
  a0d824:	mov    $0x1,%r9d
  a0d82a:	mov    %edi,%edi
  a0d82c:	cmove  %r8,%rdx
  a0d830:	jmp    a0d85b <pp_compile_macro+0xf3b>
  a0d832:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0d840:	or     %rdx,(%r15)
  a0d843:	xor    %eax,%eax
  a0d845:	movzwl -0x6(%r13,%r10,8),%esi
  a0d84b:	add    %r10d,%esi
  a0d84e:	cmp    %rdi,%r10
  a0d851:	lea    0x1(%r10),%r10
  a0d855:	jae    a0d969 <pp_compile_macro+0x1049>
  a0d85b:	movzbl -0x8(%r13,%r10,8),%r11d
  a0d861:	lea    -0x4(%r11),%ebx
  a0d865:	cmp    $0x2,%ebx
  a0d868:	jb     a0d840 <pp_compile_macro+0xf20>
  a0d86a:	cmp    $0x1,%r11d
  a0d86e:	jne    a0d84e <pp_compile_macro+0xf2e>
  a0d870:	cmpb   $0x3,-0x10(%r13,%r10,8)
  a0d876:	je     a0d84e <pp_compile_macro+0xf2e>
  a0d878:	cmp    %rdi,%r10
  a0d87b:	jae    a0d8b7 <pp_compile_macro+0xf97>
  a0d87d:	mov    %esi,%r11d
  a0d880:	cmp    %r11,%r10
  a0d883:	je     a0d8b7 <pp_compile_macro+0xf97>
  a0d885:	movzwl -0x6(%r13,%r10,8),%r11d
  a0d88b:	mov    $0x3f,%r15d
  a0d891:	movzwl %r11w,%r14d
  a0d895:	cmp    $0x3f,%r14d
  a0d899:	cmovb  %r14d,%r15d
  a0d89d:	cmpb   $0x3,0x0(%r13,%r10,8)
  a0d8a3:	shlx   %r15,%r9,%r8
  a0d8a8:	mov    $0x0,%r15d
  a0d8ae:	setne  %bl
  a0d8b1:	cmove  %r15,%r8
  a0d8b5:	jmp    a0d8d5 <pp_compile_macro+0xfb5>
  a0d8b7:	movzwl -0x6(%r13,%r10,8),%r11d
  a0d8bd:	mov    $0x3f,%ebx
  a0d8c2:	movzwl %r11w,%r14d
  a0d8c6:	cmp    $0x3f,%r14d
  a0d8ca:	cmovb  %r14d,%ebx
  a0d8ce:	shlx   %rbx,%r9,%r8
  a0d8d3:	mov    $0x1,%bl
  a0d8d5:	mov    0x48(%rsp),%r15
  a0d8da:	and    %al,%bl
  a0d8dc:	or     %r8,(%r15)
  a0d8df:	cmp    $0x1,%bl
  a0d8e2:	jne    a0d84e <pp_compile_macro+0xf2e>
  a0d8e8:	mov    %r14d,%ebx
  a0d8eb:	shr    $0x6,%ebx
  a0d8ee:	mov    $0x1,%al
  a0d8f0:	mov    (%rcx,%rbx,8),%r15
  a0d8f4:	bt     %r14,%r15
  a0d8f8:	jae    a0d904 <pp_compile_macro+0xfe4>
  a0d8fa:	mov    0x48(%rsp),%r15
  a0d8ff:	jmp    a0d84e <pp_compile_macro+0xf2e>
  a0d904:	shlx   %r14,%r9,%r14
  a0d909:	mov    0x8(%rsp),%r8
  a0d90e:	or     %r14,%r15
  a0d911:	mov    %r15,(%rcx,%rbx,8)
  a0d915:	mov    0x18(%rsp),%rbx
  a0d91a:	mov    0xe00(%rbx),%ebx
  a0d920:	add    %r8d,%ebx
  a0d923:	cmp    $0x3ffffff,%ebx
  a0d929:	ja     a0d95d <pp_compile_macro+0x103d>
  a0d92b:	mov    0x50(%rsp),%r14
  a0d930:	mov    0x48(%rsp),%r15
  a0d935:	inc    %r8d
  a0d938:	mov    %ebx,%ebx
  a0d93a:	mov    %r8,0x8(%rsp)
  a0d93f:	mov    (%r14),%r14
  a0d942:	movw   $0x1,(%r14,%rbx,8)
  a0d949:	mov    %r11w,0x2(%r14,%rbx,8)
  a0d94f:	movl   $0x0,0x4(%r14,%rbx,8)
  a0d958:	jmp    a0d84e <pp_compile_macro+0xf2e>
  a0d95d:	mov    0x48(%rsp),%r15
  a0d962:	xor    %eax,%eax
  a0d964:	jmp    a0d84e <pp_compile_macro+0xf2e>
  a0d969:	mov    $0xfffffffffffff560,%rcx
  a0d970:	cmp    %fs:0x28(%rcx),%r12
  a0d975:	ja     a0e1d3 <pp_compile_macro+0x18b3>
  a0d97b:	and    0x40(%rsp),%al
  a0d97f:	mov    %r12,%fs:0x28(%rcx)
  a0d984:	mov    0x18(%rsp),%r15
  a0d989:	mov    0x20(%rsp),%r12
  a0d98e:	xor    %ecx,%ecx
  a0d990:	mov    %eax,%esi
  a0d992:	and    0x14(%rsp),%sil
  a0d997:	mov    %eax,%edx
  a0d999:	cmp    $0x1,%sil
  a0d99d:	jne    a0d9f7 <pp_compile_macro+0x10d7>
  a0d99f:	mov    0x28(%rsp),%esi
  a0d9a3:	mov    $0x1,%edi
  a0d9a8:	xor    %ecx,%ecx
  a0d9aa:	nopw   0x0(%rax,%rax,1)
  a0d9b0:	movzbl -0x8(%r13,%rdi,8),%r8d
  a0d9b6:	mov    $0x0,%r9d
  a0d9bc:	cmp    $0x2,%r8b
  a0d9c0:	setb   %dl
  a0d9c3:	test   %r8b,%r8b
  a0d9c6:	jne    a0d9e5 <pp_compile_macro+0x10c5>
  a0d9c8:	mov    0x50(%rbp),%r9
  a0d9cc:	mov    -0x4(%r13,%rdi,8),%r10d
  a0d9d1:	movzbl (%r9,%r10,1),%r10d
  a0d9d6:	xor    %r9d,%r9d
  a0d9d9:	and    $0x7f,%r10b
  a0d9dd:	cmp    $0x1,%r10b
  a0d9e1:	sete   %r9b
  a0d9e5:	add    %r9d,%ecx
  a0d9e8:	cmp    $0x1,%r8b
  a0d9ec:	ja     a0d9f7 <pp_compile_macro+0x10d7>
  a0d9ee:	cmp    %rsi,%rdi
  a0d9f1:	lea    0x1(%rdi),%rdi
  a0d9f5:	jb     a0d9b0 <pp_compile_macro+0x1090>
  a0d9f7:	xor    %esi,%esi
  a0d9f9:	test   %dl,%dl
  a0d9fb:	je     a0da5e <pp_compile_macro+0x113e>
  a0d9fd:	mov    0x14(%rsp),%r9d
  a0da02:	mov    $0x0,%edx
  a0da07:	cmp    $0x10000,%ecx
  a0da0d:	jae    a0da65 <pp_compile_macro+0x1145>
  a0da0f:	mov    0x8(%rsp),%edi
  a0da13:	mov    0xe00(%r15),%edx
  a0da1a:	mov    %ecx,%r8d
  a0da1d:	add    %rdi,%r8
  a0da20:	add    %rdx,%r8
  a0da23:	cmp    $0x4000001,%r8
  a0da2a:	setb   %dl
  a0da2d:	mov    %edx,%edi
  a0da2f:	and    %r9b,%dil
  a0da32:	cmp    $0x1,%dil
  a0da36:	jne    a0da65 <pp_compile_macro+0x1145>
  a0da38:	mov    0x28(%rsp),%r8
  a0da3d:	mov    %r8d,%r9d
  a0da40:	mov    %r9d,%edi
  a0da43:	and    $0x3,%edi
  a0da46:	dec    %r8d
  a0da49:	cmp    $0x3,%r8d
  a0da4d:	jae    a0daec <pp_compile_macro+0x11cc>
  a0da53:	xor    %r10d,%r10d
  a0da56:	xor    %r8d,%r8d
  a0da59:	jmp    a0dd01 <pp_compile_macro+0x13e1>
  a0da5e:	xor    %edx,%edx
  a0da60:	mov    0x14(%rsp),%r9d
  a0da65:	test   %dl,%dl
  a0da67:	jne    a0dacd <pp_compile_macro+0x11ad>
  a0da69:	mov    $0x0,%r8d
  a0da6f:	mov    $0x0,%edi
  a0da74:	mov    $0x0,%r10d
  a0da7a:	test   %al,%al
  a0da7c:	je     a0dd6e <pp_compile_macro+0x144e>
  a0da82:	cmpl   $0x11,0x28(%rsp)
  a0da87:	mov    $0x0,%edi
  a0da8c:	setb   %r10b
  a0da90:	and    0x4(%r12),%r10b
  a0da95:	xor    %esi,%esi
  a0da97:	and    %r10b,%r9b
  a0da9a:	cmp    $0x1,%r9b
  a0da9e:	jne    a0dd6e <pp_compile_macro+0x144e>
  a0daa4:	movzbl 0x0(%r13),%r11d
  a0daa9:	xor    %edi,%edi
  a0daab:	cmp    $0x2,%r11b
  a0daaf:	sete   %dil
  a0dab3:	cmp    $0x3,%r11b
  a0dab7:	jne    a0dc51 <pp_compile_macro+0x1331>
  a0dabd:	mov    $0x1,%esi
  a0dac2:	xor    %r8d,%r8d
  a0dac5:	xor    %r10d,%r10d
  a0dac8:	jmp    a0dd64 <pp_compile_macro+0x1444>
  a0dacd:	xor    %r8d,%r8d
  a0dad0:	xor    %edi,%edi
  a0dad2:	xor    %r10d,%r10d
  a0dad5:	xor    %r9d,%r9d
  a0dad8:	or     %dl,%r10b
  a0dadb:	mov    $0x0,%r11d
  a0dae1:	jne    a0dd80 <pp_compile_macro+0x1460>
  a0dae7:	jmp    a0de6b <pp_compile_macro+0x154b>
  a0daec:	and    $0xfffffffc,%r9d
  a0daf0:	xor    %r10d,%r10d
  a0daf3:	xor    %r8d,%r8d
  a0daf6:	jmp    a0db0d <pp_compile_macro+0x11ed>
  a0daf8:	nopl   0x0(%rax,%rax,1)
  a0db00:	add    $0x4,%r10
  a0db04:	cmp    %r10,%r9
  a0db07:	je     a0dcf8 <pp_compile_macro+0x13d8>
  a0db0d:	cmpb   $0x0,0x0(%r13,%r10,8)
  a0db13:	jne    a0db60 <pp_compile_macro+0x1240>
  a0db15:	mov    0x50(%rbp),%rbx
  a0db19:	mov    0x4(%r13,%r10,8),%r11d
  a0db1e:	movzbl (%rbx,%r11,1),%ebx
  a0db23:	and    $0x7f,%bl
  a0db26:	cmp    $0x1,%bl
  a0db29:	jne    a0db60 <pp_compile_macro+0x1240>
  a0db2b:	mov    0x8(%rsp),%r14
  a0db30:	mov    0xdf8(%r15),%rbx
  a0db37:	add    %r8d,%r14d
  a0db3a:	add    0xe00(%r15),%r14d
  a0db41:	inc    %r8d
  a0db44:	movl   $0x0,(%rbx,%r14,8)
  a0db4c:	mov    %r11d,0x4(%rbx,%r14,8)
  a0db51:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0db60:	cmpb   $0x0,0x8(%r13,%r10,8)
  a0db66:	jne    a0dbb0 <pp_compile_macro+0x1290>
  a0db68:	mov    0x50(%rbp),%rbx
  a0db6c:	mov    0xc(%r13,%r10,8),%r11d
  a0db71:	movzbl (%rbx,%r11,1),%ebx
  a0db76:	and    $0x7f,%bl
  a0db79:	cmp    $0x1,%bl
  a0db7c:	jne    a0dbb0 <pp_compile_macro+0x1290>
  a0db7e:	mov    0x8(%rsp),%r14
  a0db83:	mov    0xdf8(%r15),%rbx
  a0db8a:	add    %r8d,%r14d
  a0db8d:	add    0xe00(%r15),%r14d
  a0db94:	inc    %r8d
  a0db97:	movl   $0x0,(%rbx,%r14,8)
  a0db9f:	mov    %r11d,0x4(%rbx,%r14,8)
  a0dba4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0dbb0:	cmpb   $0x0,0x10(%r13,%r10,8)
  a0dbb6:	jne    a0dc00 <pp_compile_macro+0x12e0>
  a0dbb8:	mov    0x50(%rbp),%rbx
  a0dbbc:	mov    0x14(%r13,%r10,8),%r11d
  a0dbc1:	movzbl (%rbx,%r11,1),%ebx
  a0dbc6:	and    $0x7f,%bl
  a0dbc9:	cmp    $0x1,%bl
  a0dbcc:	jne    a0dc00 <pp_compile_macro+0x12e0>
  a0dbce:	mov    0x8(%rsp),%r14
  a0dbd3:	mov    0xdf8(%r15),%rbx
  a0dbda:	add    %r8d,%r14d
  a0dbdd:	add    0xe00(%r15),%r14d
  a0dbe4:	inc    %r8d
  a0dbe7:	movl   $0x0,(%rbx,%r14,8)
  a0dbef:	mov    %r11d,0x4(%rbx,%r14,8)
  a0dbf4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0dc00:	cmpb   $0x0,0x18(%r13,%r10,8)
  a0dc06:	jne    a0db00 <pp_compile_macro+0x11e0>
  a0dc0c:	mov    0x50(%rbp),%rbx
  a0dc10:	mov    0x1c(%r13,%r10,8),%r11d
  a0dc15:	movzbl (%rbx,%r11,1),%ebx
  a0dc1a:	and    $0x7f,%bl
  a0dc1d:	cmp    $0x1,%bl
  a0dc20:	jne    a0db00 <pp_compile_macro+0x11e0>
  a0dc26:	mov    0x8(%rsp),%r14
  a0dc2b:	mov    0xdf8(%r15),%rbx
  a0dc32:	add    %r8d,%r14d
  a0dc35:	add    0xe00(%r15),%r14d
  a0dc3c:	inc    %r8d
  a0dc3f:	movl   $0x0,(%rbx,%r14,8)
  a0dc47:	mov    %r11d,0x4(%rbx,%r14,8)
  a0dc4c:	jmp    a0db00 <pp_compile_macro+0x11e0>
  a0dc51:	setbe  %r10b
  a0dc55:	xor    %esi,%esi
  a0dc57:	cmp    $0x3,%r11b
  a0dc5b:	ja     a0dd61 <pp_compile_macro+0x1441>
  a0dc61:	mov    0x28(%rsp),%rbx
  a0dc66:	cmp    $0x2,%ebx
  a0dc69:	jb     a0dd61 <pp_compile_macro+0x1441>
  a0dc6f:	mov    0x38(%rsp),%rsi
  a0dc74:	movzbl 0x8(%r13),%r9d
  a0dc79:	dec    %esi
  a0dc7b:	cmp    $0x4,%r9b
  a0dc7f:	setb   %r10b
  a0dc83:	mov    %rsi,0x38(%rsp)
  a0dc88:	xor    %esi,%esi
  a0dc8a:	cmp    $0x3,%r9b
  a0dc8e:	jne    a0e0bd <pp_compile_macro+0x179d>
  a0dc94:	mov    $0x2,%esi
  a0dc99:	xor    %r8d,%r8d
  a0dc9c:	cmp    $0x3,%ebx
  a0dc9f:	jb     a0e0ba <pp_compile_macro+0x179a>
  a0dca5:	cmp    $0x2,%r11b
  a0dca9:	movzbl 0x10(%r13),%r11d
  a0dcae:	setb   %r8b
  a0dcb2:	cmp    $0x2,%r11b
  a0dcb6:	setb   %r10b
  a0dcba:	and    %r8b,%r10b
  a0dcbd:	mov    $0x1,%r8d
  a0dcc3:	cmp    $0x1,%r10b
  a0dcc7:	jne    a0e0ba <pp_compile_macro+0x179a>
  a0dccd:	testb  $0x2,0x3(%rsp)
  a0dcd2:	mov    $0x1,%r10b
  a0dcd5:	je     a0e0bd <pp_compile_macro+0x179d>
  a0dcdb:	cmp    $0x1,%r11b
  a0dcdf:	jne    a0e0bd <pp_compile_macro+0x179d>
  a0dce5:	movzwl 0x12(%r13),%r10d
  a0dcea:	cmp    %r10d,0x38(%rsp)
  a0dcef:	setne  %r10b
  a0dcf3:	jmp    a0e0bd <pp_compile_macro+0x179d>
  a0dcf8:	test   %rdi,%rdi
  a0dcfb:	je     a0da60 <pp_compile_macro+0x1140>
  a0dd01:	lea    0x4(%r13,%r10,8),%r9
  a0dd06:	xor    %r10d,%r10d
  a0dd09:	jmp    a0dd1c <pp_compile_macro+0x13fc>
  a0dd0b:	nopl   0x0(%rax,%rax,1)
  a0dd10:	inc    %r10
  a0dd13:	cmp    %r10,%rdi
  a0dd16:	je     a0da60 <pp_compile_macro+0x1140>
  a0dd1c:	cmpb   $0x0,-0x4(%r9,%r10,8)
  a0dd22:	jne    a0dd10 <pp_compile_macro+0x13f0>
  a0dd24:	mov    0x50(%rbp),%rbx
  a0dd28:	mov    (%r9,%r10,8),%r11d
  a0dd2c:	movzbl (%rbx,%r11,1),%ebx
  a0dd31:	and    $0x7f,%bl
  a0dd34:	cmp    $0x1,%bl
  a0dd37:	jne    a0dd10 <pp_compile_macro+0x13f0>
  a0dd39:	mov    0x8(%rsp),%r14
  a0dd3e:	mov    0xdf8(%r15),%rbx
  a0dd45:	add    %r8d,%r14d
  a0dd48:	add    0xe00(%r15),%r14d
  a0dd4f:	inc    %r8d
  a0dd52:	movl   $0x0,(%rbx,%r14,8)
  a0dd5a:	mov    %r11d,0x4(%rbx,%r14,8)
  a0dd5f:	jmp    a0dd10 <pp_compile_macro+0x13f0>
  a0dd61:	xor    %r8d,%r8d
  a0dd64:	mov    0x18(%rsp),%r15
  a0dd69:	mov    0x20(%rsp),%r12
  a0dd6e:	xor    %r9d,%r9d
  a0dd71:	or     %dl,%r10b
  a0dd74:	mov    $0x0,%r11d
  a0dd7a:	je     a0de6b <pp_compile_macro+0x154b>
  a0dd80:	mov    0xe18(%r15),%r10
  a0dd87:	test   %r10,%r10
  a0dd8a:	je     a0de6b <pp_compile_macro+0x154b>
  a0dd90:	cmpl   $0x10,0x28(%rsp)
  a0dd95:	ja     a0de6b <pp_compile_macro+0x154b>
  a0dd9b:	cmpw   $0x10,0x58(%rsp)
  a0dda1:	ja     a0de6b <pp_compile_macro+0x154b>
  a0dda7:	mov    0xe20(%r15),%ebx
  a0ddae:	cmp    $0xfffff,%rbx
  a0ddb5:	ja     a0de6b <pp_compile_macro+0x154b>
  a0ddbb:	imul   $0x110,%rbx,%rbx
  a0ddc2:	mov    %esi,%r14d
  a0ddc5:	lea    (%rsi,%rsi,1),%r11d
  a0ddc9:	shr    $1,%r14d
  a0ddcc:	vpxor  %xmm0,%xmm0,%xmm0
  a0ddd0:	andn   %r11d,%r14d,%r15d
  a0ddd5:	cmpb   $0x0,0x30(%rsp)
  a0ddda:	vmovdqu64 %zmm0,0xc0(%r10,%rbx,1)
  a0dde2:	vmovdqu64 %zmm0,0x80(%r10,%rbx,1)
  a0ddea:	vmovdqu64 %zmm0,0x40(%r10,%rbx,1)
  a0ddf2:	vmovdqu64 %zmm0,(%r10,%rbx,1)
  a0ddf9:	movw   $0x0,0x100(%r10,%rbx,1)
  a0de04:	mov    %si,0x102(%r10,%rbx,1)
  a0de0d:	mov    %r8w,0x104(%r10,%rbx,1)
  a0de16:	mov    %r15w,0x106(%r10,%rbx,1)
  a0de1f:	mov    %di,0x108(%r10,%rbx,1)
  a0de28:	mov    0x28(%rsp),%rdi
  a0de2d:	mov    %dil,0x10a(%r10,%rbx,1)
  a0de35:	movl   $0x0,0x10b(%r10,%rbx,1)
  a0de41:	movb   $0x0,0x10f(%r10,%rbx,1)
  a0de4a:	je     a0df34 <pp_compile_macro+0x1614>
  a0de50:	mov    0x18(%rsp),%r15
  a0de55:	mov    0x20(%rsp),%r12
  a0de5a:	mov    0xe20(%r15),%r11d
  a0de61:	inc    %r11d
  a0de64:	mov    %r11d,0xe20(%r15)
  a0de6b:	mov    %eax,%esi
  a0de6d:	mov    %edx,%edi
  a0de6f:	mov    %r11d,0x34(%r12)
  a0de74:	shl    $0x5,%sil
  a0de78:	shl    $0x7,%dil
  a0de7c:	or     %sil,%dil
  a0de7f:	or     %dil,0x4(%r12)
  a0de84:	test   %al,%al
  a0de86:	mov    0x8(%rsp),%rax
  a0de8b:	cmove  %r9d,%eax
  a0de8f:	test   %dl,%dl
  a0de91:	cmove  %r9d,%ecx
  a0de95:	mov    %ax,0xa(%r12)
  a0de9b:	mov    %cx,0xc(%r12)
  a0dea1:	add    %eax,%ecx
  a0dea3:	mov    0x40(%rsp),%eax
  a0dea7:	add    %ecx,0xe00(%r15)
  a0deae:	shl    $0x2,%al
  a0deb1:	or     %al,0x4(%r12)
  a0deb6:	cmpb   $0x0,0x4(%rsp)
  a0debb:	mov    0x28(%rsp),%rax
  a0dec0:	cmove  %r9d,%eax
  a0dec4:	mov    %eax,0x2c(%r12)
  a0dec9:	jne    a0ded9 <pp_compile_macro+0x15b9>
  a0decb:	mov    0x60(%rsp),%rax
  a0ded0:	mov    (%rax),%eax
  a0ded2:	mov    %eax,0xe00(%r15)
  a0ded9:	mov    0x70(%rsp),%rax
  a0dede:	test   %rax,%rax
  a0dee1:	je     a0df04 <pp_compile_macro+0x15e4>
  a0dee3:	mov    0x98(%rax),%rcx
  a0deea:	test   %rcx,%rcx
  a0deed:	je     a0df04 <pp_compile_macro+0x15e4>
  a0deef:	mov    0xa0(%rax),%rax
  a0def6:	cmp    0x8(%rcx),%rax
  a0defa:	ja     a0e1d3 <pp_compile_macro+0x18b3>
  a0df00:	mov    %rax,0x8(%rcx)
  a0df04:	mov    %fs:0x28,%rax
  a0df0d:	cmp    0x80(%rsp),%rax
  a0df15:	jne    a0e1f5 <pp_compile_macro+0x18d5>
  a0df1b:	mov    0x4(%rsp),%eax
  a0df1f:	add    $0x88,%rsp
  a0df26:	pop    %rbx
  a0df27:	pop    %r12
  a0df29:	pop    %r13
  a0df2b:	pop    %r14
  a0df2d:	pop    %r15
  a0df2f:	pop    %rbp
  a0df30:	vzeroupper
  a0df33:	ret
  a0df34:	add    %rbx,%r10
  a0df37:	mov    0x28(%rsp),%rbx
  a0df3c:	or     %esi,%r11d
  a0df3f:	xor    %edi,%edi
  a0df41:	or     %r14d,%r11d
  a0df44:	jmp    a0df5e <pp_compile_macro+0x163e>
  a0df46:	cs nopw 0x0(%rax,%rax,1)
  a0df50:	movzwl 0x2(%r13,%rsi,8),%edi
  a0df56:	lea    0x1(%rsi,%rdi,1),%edi
  a0df5a:	cmp    %ebx,%edi
  a0df5c:	jae    a0df9b <pp_compile_macro+0x167b>
  a0df5e:	mov    %dil,0x10b(%r10)
  a0df65:	mov    %edi,%esi
  a0df67:	xor    %r8d,%r8d
  a0df6a:	cmpb   $0x3,0x0(%r13,%rsi,8)
  a0df70:	sete   %r8b
  a0df74:	sub    %r8d,%edi
  a0df77:	mov    %dil,0x10c(%r10)
  a0df7e:	movzbl 0x0(%r13,%rsi,8),%r8d
  a0df84:	test   %r8b,%r8b
  a0df87:	je     a0df50 <pp_compile_macro+0x1630>
  a0df89:	xor    %edi,%edi
  a0df8b:	cmp    $0x3,%r8b
  a0df8f:	sete   %dil
  a0df93:	lea    0x1(%rsi,%rdi,1),%edi
  a0df97:	cmp    %ebx,%edi
  a0df99:	jb     a0df5e <pp_compile_macro+0x163e>
  a0df9b:	mov    $0x1,%r8d
  a0dfa1:	mov    %ebx,%esi
  a0dfa3:	xor    %edi,%edi
  a0dfa5:	jmp    a0dfc4 <pp_compile_macro+0x16a4>
  a0dfa7:	nopw   0x0(%rax,%rax,1)
  a0dfb0:	or     %bx,0xfc(%r10)
  a0dfb8:	inc    %rdi
  a0dfbb:	cmp    %rdi,%rsi
  a0dfbe:	je     a0de50 <pp_compile_macro+0x1530>
  a0dfc4:	mov    0x4(%r13,%rdi,8),%r15d
  a0dfc9:	mov    0x50(%rbp),%rbx
  a0dfcd:	movzbl (%rbx,%r15,1),%r14d
  a0dfd2:	mov    %r15d,%r12d
  a0dfd5:	shr    $0x6,%r12d
  a0dfd9:	and    $0x7f,%r14b
  a0dfdd:	mov    %r14b,0xc0(%r10,%rdi,1)
  a0dfe5:	mov    0x68(%rbp),%rbx
  a0dfe9:	mov    (%rbx,%r12,8),%rbx
  a0dfed:	bt     %r15,%rbx
  a0dff1:	setb   %bl
  a0dff4:	or     $0x8,%bl
  a0dff7:	mov    %bl,0xd0(%r10,%rdi,1)
  a0dfff:	cmp    $0x1,%r14b
  a0e003:	jne    a0e020 <pp_compile_macro+0x1700>
  a0e005:	mov    0x60(%rbp),%rbx
  a0e009:	mov    0x20(%rsp),%r12
  a0e00e:	mov    (%rbx,%r15,4),%ebx
  a0e012:	jmp    a0e032 <pp_compile_macro+0x1712>
  a0e014:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0e020:	mov    0x60(%rbp),%rbx
  a0e024:	mov    0x20(%rsp),%r12
  a0e029:	mov    (%rbx,%r15,4),%ebx
  a0e02d:	add    0x14(%r12),%ebx
  a0e032:	mov    %ebx,(%r10,%rdi,4)
  a0e036:	mov    0x58(%rbp),%rbx
  a0e03a:	mov    (%rbx,%r15,4),%ebx
  a0e03e:	xor    %r15d,%r15d
  a0e041:	add    0x14(%r12),%ebx
  a0e046:	mov    %ebx,0x40(%r10,%rdi,4)
  a0e04b:	mov    $0x0,%ebx
  a0e050:	movzbl 0x0(%r13,%rdi,8),%r12d
  a0e056:	dec    %r12b
  a0e059:	cmp    $0x1,%r12b
  a0e05d:	ja     a0e065 <pp_compile_macro+0x1745>
  a0e05f:	movzbl 0x2(%r13,%rdi,8),%ebx
  a0e065:	mov    %bl,0xe0(%r10,%rdi,1)
  a0e06d:	shlx   %edi,%r8d,%ebx
  a0e072:	cmpb   $0x1,0x0(%r13,%rdi,8)
  a0e078:	mov    %ebx,%r12d
  a0e07b:	je     a0e080 <pp_compile_macro+0x1760>
  a0e07d:	xor    %r12d,%r12d
  a0e080:	or     %r12w,0xf8(%r10)
  a0e088:	xor    $0x1,%r14b
  a0e08c:	mov    %ebx,%r12d
  a0e08f:	testb  $0x1,0x1(%r13,%rdi,8)
  a0e095:	cmove  %r15d,%r12d
  a0e099:	or     %r12w,0xfa(%r10)
  a0e0a1:	test   %r11d,%ebx
  a0e0a4:	cmovne %r15d,%ebx
  a0e0a8:	or     0x0(%r13,%rdi,8),%r14b
  a0e0ad:	je     a0dfb0 <pp_compile_macro+0x1690>
  a0e0b3:	xor    %ebx,%ebx
  a0e0b5:	jmp    a0dfb0 <pp_compile_macro+0x1690>
  a0e0ba:	xor    %r10d,%r10d
  a0e0bd:	xor    %r11d,%r11d
  a0e0c0:	cmp    $0x2,%r9b
  a0e0c4:	sete   %r11b
  a0e0c8:	lea    (%rdi,%r11,2),%edi
  a0e0cc:	test   %r10b,%r10b
  a0e0cf:	je     a0dd64 <pp_compile_macro+0x1444>
  a0e0d5:	cmp    $0x3,%ebx
  a0e0d8:	jb     a0dd64 <pp_compile_macro+0x1444>
  a0e0de:	mov    $0x2,%r11d
  a0e0e4:	mov    $0x3,%r12d
  a0e0ea:	mov    %ebx,%r9d
  a0e0ed:	nopl   (%rax)
  a0e0f0:	movzbl -0x8(%r13,%r12,8),%r14d
  a0e0f6:	cmp    $0x3,%r14b
  a0e0fa:	jne    a0e150 <pp_compile_macro+0x1830>
  a0e0fc:	cmp    %r9,%r12
  a0e0ff:	jae    a0e170 <pp_compile_macro+0x1850>
  a0e101:	cmpb   $0x2,-0x10(%r13,%r12,8)
  a0e107:	movzbl 0x0(%r13,%r12,8),%ebx
  a0e10d:	setb   %r10b
  a0e111:	cmp    $0x2,%bl
  a0e114:	setb   %r15b
  a0e118:	and    %r10b,%r15b
  a0e11b:	cmp    $0x1,%r15b
  a0e11f:	jne    a0e17a <pp_compile_macro+0x185a>
  a0e121:	testb  $0x2,0x3(%rsp)
  a0e126:	mov    $0x1,%r10b
  a0e129:	je     a0e17d <pp_compile_macro+0x185d>
  a0e12b:	cmp    $0x1,%bl
  a0e12e:	jne    a0e17d <pp_compile_macro+0x185d>
  a0e130:	movzwl 0x2(%r13,%r12,8),%r10d
  a0e136:	cmp    %r10d,0x38(%rsp)
  a0e13b:	setne  %r10b
  a0e13f:	jmp    a0e17d <pp_compile_macro+0x185d>
  a0e141:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0e150:	lea    -0x1(%r12),%ebx
  a0e155:	mov    $0x1,%r15d
  a0e15b:	setbe  %r10b
  a0e15f:	inc    %r11
  a0e162:	shlx   %ebx,%r15d,%ebx
  a0e167:	jmp    a0e1a7 <pp_compile_macro+0x1887>
  a0e169:	nopl   0x0(%rax)
  a0e170:	lea    -0x1(%r12),%r15d
  a0e175:	xor    %r10d,%r10d
  a0e178:	jmp    a0e196 <pp_compile_macro+0x1876>
  a0e17a:	xor    %r10d,%r10d
  a0e17d:	lea    -0x3(%r12),%ebx
  a0e182:	movzbl %bl,%ebx
  a0e185:	bt     %ebx,%esi
  a0e188:	jb     a0e193 <pp_compile_macro+0x1873>
  a0e18a:	lea    -0x2(%r12),%ebx
  a0e18f:	bts    %ebx,%r8d
  a0e193:	mov    %r11d,%r15d
  a0e196:	mov    $0x1,%ebx
  a0e19b:	bts    %r15d,%esi
  a0e19f:	inc    %r11
  a0e1a2:	shlx   %r15d,%ebx,%ebx
  a0e1a7:	cmp    $0x2,%r14b
  a0e1ab:	mov    $0x0,%r15d
  a0e1b1:	cmovne %r15d,%ebx
  a0e1b5:	or     %ebx,%edi
  a0e1b7:	test   %r10b,%r10b
  a0e1ba:	je     a0dd64 <pp_compile_macro+0x1444>
  a0e1c0:	cmp    %r9,%r12
  a0e1c3:	lea    0x1(%r12),%r12
  a0e1c8:	jb     a0e0f0 <pp_compile_macro+0x17d0>
  a0e1ce:	jmp    a0dd64 <pp_compile_macro+0x1444>
  a0e1d3:	lea    -0x2daed8(%rip),%rdi        # 733302 <pp_string_value.meaning+0x7f660>
  a0e1da:	lea    -0x32b6fa(%rip),%rsi        # 6e2ae7 <pp_string_value.meaning+0x2ee45>
  a0e1e1:	lea    -0x32b6e6(%rip),%rcx        # 6e2b02 <pp_string_value.meaning+0x2ee60>
  a0e1e8:	mov    $0xce,%edx
  a0e1ed:	vzeroupper
  a0e1f0:	call   7cdd80 <__assert_fail@plt>
  a0e1f5:	vzeroupper
  a0e1f8:	call   7cdd10 <__stack_chk_fail@plt>
