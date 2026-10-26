
deliver/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000acb7a0 <ir_typed_emit_function>:
  acb7a0:	push   %rbp
  acb7a1:	push   %r15
  acb7a3:	push   %r14
  acb7a5:	push   %r13
  acb7a7:	push   %r12
  acb7a9:	push   %rbx
  acb7aa:	sub    $0xe8,%rsp
  acb7b1:	mov    0x10(%rcx),%eax
  acb7b4:	mov    %rdi,0xb8(%rsp)
  acb7bc:	mov    %rcx,0x50(%rsp)
  acb7c1:	mov    0x2c(%rcx),%ecx
  acb7c4:	mov    0x30(%rsi),%edi
  acb7c7:	mov    0x138(%rsp),%r14
  acb7cf:	mov    %r9,0x90(%rsp)
  acb7d7:	mov    %r8,0xd0(%rsp)
  acb7df:	mov    %rsi,0x10(%rsp)
  acb7e4:	mov    %edx,0x5c(%rsp)
  acb7e8:	mov    %rax,0xa8(%rsp)
  acb7f0:	mov    0x34(%rsi),%eax
  acb7f3:	mov    %rcx,0xb0(%rsp)
  acb7fb:	mov    %rdi,0xa0(%rsp)
  acb803:	mov    %rax,0x78(%rsp)
  acb808:	lea    (%rcx,%rdi,1),%eax
  acb80b:	test   %r14,%r14
  acb80e:	je     acb983 <ir_typed_emit_function+0x1e3>
  acb814:	mov    0x40(%r14),%rcx
  acb818:	movl   $0x0,(%rcx)
  acb81e:	mov    %dl,0xbc(%r14)
  acb825:	test   %eax,%eax
  acb827:	je     acb99a <ir_typed_emit_function+0x1fa>
  acb82d:	mov    $0x1,%ecx
  acb832:	lea    -0x4ec0f9(%rip),%rdx        # 5df740 <tier0_class_bytes.bytes>
  acb839:	lea    -0x4ec110(%rip),%r12        # 5df730 <ir_typed_types>
  acb840:	mov    %eax,%r15d
  acb843:	xor    %eax,%eax
  acb845:	jmp    acb87c <ir_typed_emit_function+0xdc>
  acb847:	nopw   0x0(%rax,%rax,1)
  acb850:	mov    0x10(%rsp),%rsi
  acb855:	xor    %r8d,%r8d
  acb858:	mov    $0x4,%r10b
  acb85b:	inc    %rax
  acb85e:	mov    %r9,(%rdi)
  acb861:	mov    %r11d,0x8(%rdi)
  acb865:	mov    %r8b,0xc(%rdi)
  acb869:	mov    %r10b,0xd(%rdi)
  acb86d:	movw   $0x0,0xe(%rdi)
  acb873:	cmp    %r15,%rax
  acb876:	je     acb99d <ir_typed_emit_function+0x1fd>
  acb87c:	mov    (%r14),%rdi
  acb87f:	mov    $0x8,%r8b
  acb882:	movb   $0x28,(%rdi,%rax,1)
  acb886:	mov    0x8(%r14),%rdi
  acb88a:	movb   $0xa,(%rdi,%rax,1)
  acb88e:	mov    0x20(%r14),%rdi
  acb892:	mov    %eax,(%rdi,%rax,4)
  acb895:	mov    0x28(%r14),%rdi
  acb899:	movl   $0xffffffff,(%rdi,%rax,4)
  acb8a0:	mov    0x30(%r14),%rdi
  acb8a4:	movl   $0xffffffff,(%rdi,%rax,4)
  acb8ab:	mov    0x18(%r14),%rdi
  acb8af:	movb   $0x0,(%rdi,%rax,1)
  acb8b3:	mov    0x30(%rsi),%r10d
  acb8b7:	cmp    %r10,%rax
  acb8ba:	jae    acb900 <ir_typed_emit_function+0x160>
  acb8bc:	mov    0x20(%rsi),%r8
  acb8c0:	mov    0x88(%rsi),%rdi
  acb8c7:	movzbl (%r8,%rax,1),%r8d
  acb8cc:	test   %rdi,%rdi
  acb8cf:	je     acb900 <ir_typed_emit_function+0x160>
  acb8d1:	mov    (%rdi,%rax,4),%r9d
  acb8d5:	mov    %rax,%rdi
  acb8d8:	shl    $0x4,%rdi
  acb8dc:	add    0x70(%r14),%rdi
  acb8e0:	test   %r9,%r9
  acb8e3:	je     acb90b <ir_typed_emit_function+0x16b>
  acb8e5:	mov    0x90(%rsi),%r10
  acb8ec:	movzbl (%r10,%rax,1),%r10d
  acb8f1:	shlx   %r10d,%ecx,%r11d
  acb8f6:	jmp    acb968 <ir_typed_emit_function+0x1c8>
  acb8f8:	nopl   0x0(%rax,%rax,1)
  acb900:	mov    %rax,%rdi
  acb903:	shl    $0x4,%rdi
  acb907:	add    0x70(%r14),%rdi
  acb90b:	movzbl %r8b,%r11d
  acb90f:	and    $0xf,%r11d
  acb913:	movzbl (%r11,%rdx,1),%r9d
  acb918:	cmp    $0x4,%r9d
  acb91c:	je     acb950 <ir_typed_emit_function+0x1b0>
  acb91e:	mov    $0x3,%ebx
  acb923:	cmp    $0x8,%r9d
  acb927:	je     acb936 <ir_typed_emit_function+0x196>
  acb929:	add    $0xfd,%r11b
  acb92d:	xor    %ebx,%ebx
  acb92f:	cmp    $0x2,%r11b
  acb933:	setb   %bl
  acb936:	shlx   %ebx,%ecx,%r11d
  acb93b:	cmp    %r10,%rax
  acb93e:	jae    acb850 <ir_typed_emit_function+0xb0>
  acb944:	jmp    acb963 <ir_typed_emit_function+0x1c3>
  acb946:	cs nopw 0x0(%rax,%rax,1)
  acb950:	mov    $0x2,%ebx
  acb955:	shlx   %ebx,%ecx,%r11d
  acb95a:	cmp    %r10,%rax
  acb95d:	jae    acb850 <ir_typed_emit_function+0xb0>
  acb963:	mov    0x10(%rsp),%rsi
  acb968:	mov    0x28(%rsi),%r10
  acb96c:	movzbl %r8b,%r8d
  acb970:	movzbl (%r8,%r12,1),%r8d
  acb975:	movzbl (%r10,%rax,1),%r10d
  acb97a:	and    $0x1,%r10b
  acb97e:	jmp    acb85b <ir_typed_emit_function+0xbb>
  acb983:	test   %eax,%eax
  acb985:	je     acbaad <ir_typed_emit_function+0x30d>
  acb98b:	mov    %eax,%r15d
  acb98e:	mov    0x34(%rsi),%eax
  acb991:	test   %eax,%eax
  acb993:	jne    acb9a8 <ir_typed_emit_function+0x208>
  acb995:	jmp    acbabd <ir_typed_emit_function+0x31d>
  acb99a:	xor    %r15d,%r15d
  acb99d:	mov    0x34(%rsi),%eax
  acb9a0:	test   %eax,%eax
  acb9a2:	je     acbabd <ir_typed_emit_function+0x31d>
  acb9a8:	lea    -0x4ec26f(%rip),%rcx        # 5df740 <tier0_class_bytes.bytes>
  acb9af:	lea    -0x4ec286(%rip),%rdx        # 5df730 <ir_typed_types>
  acb9b6:	xor    %eax,%eax
  acb9b8:	jmp    acb9d3 <ir_typed_emit_function+0x233>
  acb9ba:	nopw   0x0(%rax,%rax,1)
  acb9c0:	mov    0x34(%rsi),%edi
  acb9c3:	add    $0x2,%r15
  acb9c7:	inc    %rax
  acb9ca:	cmp    %rdi,%rax
  acb9cd:	jae    acbabd <ir_typed_emit_function+0x31d>
  acb9d3:	mov    0x20(%rsi),%rdi
  acb9d7:	movzbl (%rdi,%rax,1),%r10d
  acb9dc:	test   %r14,%r14
  acb9df:	je     acba2d <ir_typed_emit_function+0x28d>
  acb9e1:	movzbl (%r10,%rdx,1),%edi
  acb9e6:	mov    0xb0(%r14),%r8
  acb9ed:	mov    %r15d,%r9d
  acb9f0:	mov    %dil,(%r8,%rax,1)
  acb9f4:	mov    (%r14),%r8
  acb9f7:	movb   $0x3,(%r8,%r9,1)
  acb9fc:	mov    0x8(%r14),%r8
  acba00:	mov    %dil,(%r8,%r9,1)
  acba04:	mov    0x20(%r14),%rdi
  acba08:	mov    %eax,(%rdi,%r9,4)
  acba0c:	mov    0x28(%r14),%rdi
  acba10:	movl   $0xffffffff,(%rdi,%r9,4)
  acba18:	mov    0x30(%r14),%rdi
  acba1c:	movl   $0xffffffff,(%rdi,%r9,4)
  acba24:	mov    0x18(%r14),%rdi
  acba28:	movb   $0x0,(%rdi,%r9,1)
  acba2d:	and    $0xf,%r10d
  acba31:	movzbl (%r10,%rcx,1),%r8d
  acba36:	cmp    $0x4,%r8d
  acba3a:	je     acba60 <ir_typed_emit_function+0x2c0>
  acba3c:	mov    $0x3,%dil
  acba3f:	cmp    $0x8,%r8d
  acba43:	je     acba51 <ir_typed_emit_function+0x2b1>
  acba45:	add    $0xfd,%r10b
  acba49:	cmp    $0x2,%r10b
  acba4d:	setb   %dil
  acba51:	test   %r14,%r14
  acba54:	jne    acba6c <ir_typed_emit_function+0x2cc>
  acba56:	jmp    acb9c0 <ir_typed_emit_function+0x220>
  acba5b:	nopl   0x0(%rax,%rax,1)
  acba60:	mov    $0x2,%dil
  acba63:	test   %r14,%r14
  acba66:	je     acb9c0 <ir_typed_emit_function+0x220>
  acba6c:	mov    (%r14),%r8
  acba6f:	lea    0x1(%r15),%r9
  acba73:	mov    %r9d,%r9d
  acba76:	movb   $0x2c,(%r8,%r9,1)
  acba7b:	mov    0x8(%r14),%r8
  acba7f:	movb   $0x0,(%r8,%r9,1)
  acba84:	mov    0x20(%r14),%r8
  acba88:	mov    %eax,(%r8,%r9,4)
  acba8c:	mov    0x28(%r14),%r8
  acba90:	mov    %r15d,(%r8,%r9,4)
  acba94:	mov    0x30(%r14),%r8
  acba98:	movl   $0xffffffff,(%r8,%r9,4)
  acbaa0:	mov    0x18(%r14),%r8
  acbaa4:	mov    %dil,(%r8,%r9,1)
  acbaa8:	jmp    acb9c0 <ir_typed_emit_function+0x220>
  acbaad:	mov    0x78(%rsp),%rax
  acbab2:	xor    %r15d,%r15d
  acbab5:	test   %eax,%eax
  acbab7:	jne    acb9a8 <ir_typed_emit_function+0x208>
  acbabd:	test   %r14,%r14
  acbac0:	je     acbafd <ir_typed_emit_function+0x35d>
  acbac2:	mov    (%r14),%rax
  acbac5:	mov    %r15d,%ecx
  acbac8:	movb   $0x30,(%rax,%rcx,1)
  acbacc:	mov    0x8(%r14),%rax
  acbad0:	movb   $0x0,(%rax,%rcx,1)
  acbad4:	mov    0x20(%r14),%rax
  acbad8:	movl   $0x1,(%rax,%rcx,4)
  acbadf:	mov    0x28(%r14),%rax
  acbae3:	movl   $0xffffffff,(%rax,%rcx,4)
  acbaea:	mov    0x30(%r14),%rax
  acbaee:	movl   $0xffffffff,(%rax,%rcx,4)
  acbaf5:	mov    0x18(%r14),%rax
  acbaf9:	movb   $0x0,(%rax,%rcx,1)
  acbafd:	mov    0x50(%rsp),%rax
  acbb02:	inc    %r15
  acbb05:	cmpl   $0x0,0x10(%rax)
  acbb09:	je     acdbdb <ir_typed_emit_function+0x243b>
  acbb0f:	mov    0x128(%rsp),%rax
  acbb17:	mov    0x130(%rsp),%r13
  acbb1f:	xor    %ecx,%ecx
  acbb21:	xor    %esi,%esi
  acbb23:	xor    %r9d,%r9d
  acbb26:	movq   $0x0,0x20(%rsp)
  acbb2f:	xor    %edi,%edi
  acbb31:	xor    %r8d,%r8d
  acbb34:	add    $0xc,%rax
  acbb38:	mov    %rax,0xc0(%rsp)
  acbb40:	jmp    acbbb3 <ir_typed_emit_function+0x413>
  acbb42:	mov    $0xffffffff,%eax
  acbb47:	test   %r14,%r14
  acbb4a:	je     acbb83 <ir_typed_emit_function+0x3e3>
  acbb4c:	mov    (%r14),%rcx
  acbb4f:	mov    %r15d,%edx
  acbb52:	movb   $0x33,(%rcx,%rdx,1)
  acbb56:	mov    0x8(%r14),%rcx
  acbb5a:	movb   $0x0,(%rcx,%rdx,1)
  acbb5e:	mov    0x20(%r14),%rcx
  acbb62:	mov    %eax,(%rcx,%rdx,4)
  acbb65:	mov    0x28(%r14),%rax
  acbb69:	movl   $0xffffffff,(%rax,%rdx,4)
  acbb70:	mov    0x30(%r14),%rax
  acbb74:	movl   $0xffffffff,(%rax,%rdx,4)
  acbb7b:	mov    0x18(%r14),%rax
  acbb7f:	movb   $0x0,(%rax,%rdx,1)
  acbb83:	inc    %r15
  acbb86:	mov    0x50(%rsp),%rax
  acbb8b:	mov    0xd8(%rsp),%rcx
  acbb93:	mov    0x48(%rsp),%rsi
  acbb98:	mov    0x68(%rsp),%rdi
  acbb9d:	mov    0x30(%rsp),%r8
  acbba2:	mov    0x40(%rsp),%r9
  acbba7:	mov    0x10(%rax),%eax
  acbbaa:	cmp    %rax,%rcx
  acbbad:	jae    acdb6a <ir_typed_emit_function+0x23ca>
  acbbb3:	mov    %rcx,%r10
  acbbb6:	mov    %rsi,0x48(%rsp)
  acbbbb:	mov    %rdi,0x68(%rsp)
  acbbc0:	mov    %r8,0x30(%rsp)
  acbbc5:	mov    %r9,0x40(%rsp)
  acbbca:	test   %r14,%r14
  acbbcd:	je     acbbe0 <ir_typed_emit_function+0x440>
  acbbcf:	mov    0x40(%r14),%rax
  acbbd3:	lea    0x1(%r10),%rsi
  acbbd7:	mov    %r15d,0x4(%rax,%r10,4)
  acbbdc:	jmp    acbbe4 <ir_typed_emit_function+0x444>
  acbbde:	xchg   %ax,%ax
  acbbe0:	lea    0x1(%r10),%rsi
  acbbe4:	mov    0x50(%rsp),%rdx
  acbbe9:	mov    %rsi,0xd8(%rsp)
  acbbf1:	mov    %r10,0x60(%rsp)
  acbbf6:	mov    %r13,%rdi
  acbbf9:	mov    (%rdx),%rax
  acbbfc:	mov    0x18(%rdx),%rcx
  acbc00:	mov    (%rcx,%r10,4),%ebp
  acbc04:	mov    (%rax,%r10,4),%r12d
  acbc08:	mov    (%rax,%rsi,4),%eax
  acbc0b:	mov    0xd0(%rsp),%rsi
  acbc13:	mov    0x20(%rdx),%rcx
  acbc17:	test   %rbp,%rbp
  acbc1a:	mov    (%rsi),%rsi
  acbc1d:	mov    %rax,0x98(%rsp)
  acbc25:	mov    %rbp,%rdx
  acbc28:	setne  %bl
  acbc2b:	add    (%rcx,%r10,8),%rsi
  acbc2f:	call   7c4390 <memcpy@plt>
  acbc34:	mov    0x10(%rsp),%rax
  acbc39:	mov    %r12,%r9
  acbc3c:	cmp    0x18(%rax),%r9d
  acbc40:	setb   %al
  acbc43:	and    %bl,%al
  acbc45:	cmp    $0x1,%al
  acbc47:	jne    acbc60 <ir_typed_emit_function+0x4c0>
  acbc49:	mov    0x10(%rsp),%rbx
  acbc4e:	cmp    $0x1,%ebp
  acbc51:	jne    acbc80 <ir_typed_emit_function+0x4e0>
  acbc53:	xor    %eax,%eax
  acbc55:	jmp    acbe23 <ir_typed_emit_function+0x683>
  acbc5a:	nopw   0x0(%rax,%rax,1)
  acbc60:	mov    0x10(%rsp),%rbx
  acbc65:	mov    0x128(%rsp),%rdx
  acbc6d:	jmp    acbeae <ir_typed_emit_function+0x70e>
  acbc72:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  acbc80:	mov    %ebp,%ecx
  acbc82:	and    $0xfffffffe,%ecx
  acbc85:	mov    %r9,%r12
  acbc88:	xor    %eax,%eax
  acbc8a:	jmp    acbcf8 <ir_typed_emit_function+0x558>
  acbc8c:	nopl   0x0(%rax)
  acbc90:	mov    $0x3,%r8b
  acbc93:	test   %r14,%r14
  acbc96:	je     acbcdd <ir_typed_emit_function+0x53d>
  acbc98:	mov    (%r14),%r10
  acbc9b:	lea    0x1(%r15,%rax,1),%r9
  acbca0:	lea    0x1(%rax,%rdi,1),%rdi
  acbca5:	mov    %r9d,%r9d
  acbca8:	movb   $0x2b,(%r10,%r9,1)
  acbcad:	mov    0x8(%r14),%r10
  acbcb1:	mov    %sil,(%r10,%r9,1)
  acbcb5:	mov    0x20(%r14),%rsi
  acbcb9:	mov    %edi,(%rsi,%r9,4)
  acbcbd:	mov    0x28(%r14),%rsi
  acbcc1:	movl   $0xffffffff,(%rsi,%r9,4)
  acbcc9:	mov    0x30(%r14),%rsi
  acbccd:	movl   $0xffffffff,(%rsi,%r9,4)
  acbcd5:	mov    0x18(%r14),%rsi
  acbcd9:	mov    %r8b,(%rsi,%r9,1)
  acbcdd:	mov    0x128(%rsp),%rsi
  acbce5:	inc    %edx
  acbce7:	mov    %edx,0x4(%rsi,%rax,4)
  acbceb:	add    $0x2,%rax
  acbcef:	cmp    %rax,%rcx
  acbcf2:	je     acbe10 <ir_typed_emit_function+0x670>
  acbcf8:	movzbl 0x0(%r13,%rax,1),%edi
  acbcfe:	lea    -0x4ec5c5(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  acbd05:	mov    %edi,%edx
  acbd07:	and    $0xf,%edx
  acbd0a:	movzbl (%rdx,%rsi,1),%r8d
  acbd0f:	cmp    $0x4,%r8d
  acbd13:	je     acbdd0 <ir_typed_emit_function+0x630>
  acbd19:	mov    $0x3,%sil
  acbd1c:	cmp    $0x8,%r8d
  acbd20:	je     acbd2c <ir_typed_emit_function+0x58c>
  acbd22:	add    $0xfd,%dl
  acbd25:	cmp    $0x2,%dl
  acbd28:	setb   %sil
  acbd2c:	lea    (%r15,%rax,1),%rdx
  acbd30:	lea    -0x4ec607(%rip),%r11        # 5df730 <ir_typed_types>
  acbd37:	test   %r14,%r14
  acbd3a:	je     acbd83 <ir_typed_emit_function+0x5e3>
  acbd3c:	mov    (%r14),%r9
  acbd3f:	mov    0x30(%rbx),%r8d
  acbd43:	movzbl (%rdi,%r11,1),%edi
  acbd48:	mov    %edx,%r10d
  acbd4b:	movb   $0x2b,(%r9,%r10,1)
  acbd50:	add    %rax,%r8
  acbd53:	mov    0x8(%r14),%r9
  acbd57:	mov    %dil,(%r9,%r10,1)
  acbd5b:	mov    0x20(%r14),%rdi
  acbd5f:	mov    %r8d,(%rdi,%r10,4)
  acbd63:	mov    0x28(%r14),%rdi
  acbd67:	movl   $0xffffffff,(%rdi,%r10,4)
  acbd6f:	mov    0x30(%r14),%rdi
  acbd73:	movl   $0xffffffff,(%rdi,%r10,4)
  acbd7b:	mov    0x18(%r14),%rdi
  acbd7f:	mov    %sil,(%rdi,%r10,1)
  acbd83:	mov    0x128(%rsp),%rsi
  acbd8b:	lea    -0x4ec652(%rip),%r9        # 5df740 <tier0_class_bytes.bytes>
  acbd92:	mov    %edx,(%rsi,%rax,4)
  acbd95:	movzbl 0x1(%r13,%rax,1),%r8d
  acbd9b:	mov    0x30(%rbx),%edi
  acbd9e:	movzbl (%r8,%r11,1),%esi
  acbda3:	and    $0xf,%r8d
  acbda7:	movzbl (%r8,%r9,1),%r9d
  acbdac:	cmp    $0x8,%r9d
  acbdb0:	je     acbc90 <ir_typed_emit_function+0x4f0>
  acbdb6:	cmp    $0x4,%r9d
  acbdba:	jne    acbdf0 <ir_typed_emit_function+0x650>
  acbdbc:	mov    $0x2,%r8b
  acbdbf:	test   %r14,%r14
  acbdc2:	jne    acbc98 <ir_typed_emit_function+0x4f8>
  acbdc8:	jmp    acbcdd <ir_typed_emit_function+0x53d>
  acbdcd:	nopl   (%rax)
  acbdd0:	mov    $0x2,%sil
  acbdd3:	lea    (%r15,%rax,1),%rdx
  acbdd7:	lea    -0x4ec6ae(%rip),%r11        # 5df730 <ir_typed_types>
  acbdde:	test   %r14,%r14
  acbde1:	jne    acbd3c <ir_typed_emit_function+0x59c>
  acbde7:	jmp    acbd83 <ir_typed_emit_function+0x5e3>
  acbde9:	nopl   0x0(%rax)
  acbdf0:	add    $0xfd,%r8b
  acbdf4:	cmp    $0x2,%r8b
  acbdf8:	setb   %r8b
  acbdfc:	test   %r14,%r14
  acbdff:	jne    acbc98 <ir_typed_emit_function+0x4f8>
  acbe05:	jmp    acbcdd <ir_typed_emit_function+0x53d>
  acbe0a:	nopw   0x0(%rax,%rax,1)
  acbe10:	add    %rax,%r15
  acbe13:	mov    %rsi,%rdx
  acbe16:	mov    %r12,%r9
  acbe19:	test   $0x1,%bpl
  acbe1d:	je     acbeae <ir_typed_emit_function+0x70e>
  acbe23:	movzbl 0x0(%r13,%rax,1),%ecx
  acbe29:	lea    -0x4ec6f0(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  acbe30:	mov    %ecx,%edx
  acbe32:	and    $0xf,%edx
  acbe35:	movzbl (%rdx,%rsi,1),%esi
  acbe39:	cmp    $0x8,%esi
  acbe3c:	je     acd8f2 <ir_typed_emit_function+0x2152>
  acbe42:	cmp    $0x4,%esi
  acbe45:	jne    acd902 <ir_typed_emit_function+0x2162>
  acbe4b:	mov    $0x2,%dl
  acbe4d:	test   %r14,%r14
  acbe50:	je     acbe9d <ir_typed_emit_function+0x6fd>
  acbe52:	mov    (%r14),%rdi
  acbe55:	lea    -0x4ec72c(%rip),%rsi        # 5df730 <ir_typed_types>
  acbe5c:	mov    %r15d,%r8d
  acbe5f:	movzbl (%rcx,%rsi,1),%ecx
  acbe63:	mov    0x30(%rbx),%esi
  acbe66:	movb   $0x2b,(%rdi,%r8,1)
  acbe6b:	mov    0x8(%r14),%rdi
  acbe6f:	add    %eax,%esi
  acbe71:	mov    %cl,(%rdi,%r8,1)
  acbe75:	mov    0x20(%r14),%rcx
  acbe79:	mov    %esi,(%rcx,%r8,4)
  acbe7d:	mov    0x28(%r14),%rcx
  acbe81:	movl   $0xffffffff,(%rcx,%r8,4)
  acbe89:	mov    0x30(%r14),%rcx
  acbe8d:	movl   $0xffffffff,(%rcx,%r8,4)
  acbe95:	mov    0x18(%r14),%rcx
  acbe99:	mov    %dl,(%rcx,%r8,1)
  acbe9d:	mov    0x128(%rsp),%rdx
  acbea5:	mov    %r15d,%ecx
  acbea8:	inc    %r15
  acbeab:	mov    %ecx,(%rdx,%rax,4)
  acbeae:	cmp    0x98(%rsp),%r9d
  acbeb6:	jae    acd863 <ir_typed_emit_function+0x20c3>
  acbebc:	mov    0x60(%rsp),%rax
  acbec1:	mov    %r9,%rcx
  acbec4:	movl   $0x0,0x38(%rsp)
  acbecc:	mov    %r9,0xc8(%rsp)
  acbed4:	add    $0x2,%eax
  acbed7:	mov    %eax,0x74(%rsp)
  acbedb:	jmp    acbf01 <ir_typed_emit_function+0x761>
  acbedd:	mov    %eax,(%rdx,%rdi,4)
  acbee0:	mov    %r12b,0x0(%r13,%rdi,1)
  acbee5:	data16 cs nopw 0x0(%rax,%rax,1)
  acbef0:	inc    %rcx
  acbef3:	cmp    0x98(%rsp),%rcx
  acbefb:	je     acd850 <ir_typed_emit_function+0x20b0>
  acbf01:	mov    (%rbx),%rax
  acbf04:	mov    0x8(%rbx),%rsi
  acbf08:	mov    0x120(%rsp),%rdi
  acbf10:	mov    %ebp,%r11d
  acbf13:	movzbl (%rax,%rcx,1),%r10d
  acbf18:	movzbl (%rsi,%rcx,1),%r12d
  acbf1d:	movzbl (%rdi,%rcx,1),%r9d
  acbf22:	movzbl %r12b,%esi
  acbf26:	lea    -0x1(%r10),%eax
  acbf2a:	cmp    $0x2b,%eax
  acbf2d:	ja     acc2e9 <ir_typed_emit_function+0xb49>
  acbf33:	mov    0x10(%rbx),%r8
  acbf37:	lea    -0x5d975a(%rip),%rdi        # 4f27e4 <check_builtin_atomic_rmw_test_clang.native_source+0x6e24>
  acbf3e:	movslq (%rdi,%rax,4),%rax
  acbf42:	mov    (%r8,%rcx,8),%r8
  acbf46:	add    %rdi,%rax
  acbf49:	jmp    *%rax
  acbf4b:	mov    %r10d,%eax
  acbf4e:	and    $0xfe,%al
  acbf50:	cmp    $0x1e,%al
  acbf52:	jne    acc0e8 <ir_typed_emit_function+0x948>
  acbf58:	lea    -0x1(%r11),%ebp
  acbf5c:	and    $0xf,%esi
  acbf5f:	lea    -0x4ec826(%rip),%rdi        # 5df740 <tier0_class_bytes.bytes>
  acbf66:	mov    (%rdx,%rbp,4),%eax
  acbf69:	movzbl (%rsi,%rdi,1),%r9d
  acbf6e:	cmp    $0x4,%r9d
  acbf72:	je     acca4d <ir_typed_emit_function+0x12ad>
  acbf78:	mov    $0x3,%dil
  acbf7b:	cmp    $0x8,%r9d
  acbf7f:	je     acc134 <ir_typed_emit_function+0x994>
  acbf85:	add    $0xfd,%sil
  acbf89:	cmp    $0x2,%sil
  acbf8d:	setb   %dil
  acbf91:	test   %r14,%r14
  acbf94:	jne    acc139 <ir_typed_emit_function+0x999>
  acbf9a:	jmp    acc171 <ir_typed_emit_function+0x9d1>
  acbf9f:	lea    -0x1(%r11),%ebp
  acbfa3:	add    $0xfffffffe,%r11d
  acbfa7:	mov    (%rdx,%rbp,4),%eax
  acbfaa:	test   %r14,%r14
  acbfad:	je     acca0f <ir_typed_emit_function+0x126f>
  acbfb3:	mov    (%r14),%r8
  acbfb6:	mov    %r11,%rdi
  acbfb9:	mov    (%rdx,%r11,4),%esi
  acbfbd:	mov    %r15d,%r11d
  acbfc0:	mov    %r15d,%r9d
  acbfc3:	inc    %r15
  acbfc6:	movb   $0x25,(%r8,%r11,1)
  acbfcb:	mov    0x8(%r14),%r8
  acbfcf:	movb   $0xa,(%r8,%r11,1)
  acbfd4:	mov    0x20(%r14),%r8
  acbfd8:	mov    %esi,(%r8,%r11,4)
  acbfdc:	mov    %r15d,%r8d
  acbfdf:	mov    0x28(%r14),%rsi
  acbfe3:	movl   $0xffffffff,(%rsi,%r11,4)
  acbfeb:	mov    0x30(%r14),%rsi
  acbfef:	movl   $0xffffffff,(%rsi,%r11,4)
  acbff7:	mov    0x18(%r14),%rsi
  acbffb:	movb   $0x0,(%rsi,%r11,1)
  acc000:	mov    (%r14),%rsi
  acc003:	movb   $0x2c,(%rsi,%r8,1)
  acc008:	mov    0x8(%r14),%rsi
  acc00c:	movb   $0x0,(%rsi,%r8,1)
  acc011:	mov    0x20(%r14),%rsi
  acc015:	mov    %r9d,(%rsi,%r8,4)
  acc019:	mov    0x28(%r14),%rsi
  acc01d:	mov    %eax,(%rsi,%r8,4)
  acc021:	mov    0x30(%r14),%rsi
  acc025:	movl   $0xffffffff,(%rsi,%r8,4)
  acc02d:	mov    0x18(%r14),%rsi
  acc031:	movb   $0x0,(%rsi,%r8,1)
  acc036:	inc    %r15
  acc039:	cmp    $0x1c,%r10d
  acc03d:	je     acbedd <ir_typed_emit_function+0x73d>
  acc043:	jmp    acca22 <ir_typed_emit_function+0x1282>
  acc048:	test   %r14,%r14
  acc04b:	je     acca29 <ir_typed_emit_function+0x1289>
  acc051:	mov    (%r14),%rsi
  acc054:	mov    %r11,%rdi
  acc057:	mov    %r15d,%r11d
  acc05a:	mov    %r15d,%eax
  acc05d:	inc    %r15
  acc060:	movb   $0x29,(%rsi,%r11,1)
  acc065:	mov    0x8(%r14),%rsi
  acc069:	movb   $0xa,(%rsi,%r11,1)
  acc06e:	mov    0x20(%r14),%rsi
  acc072:	mov    %r8d,(%rsi,%r11,4)
  acc076:	mov    0x28(%r14),%rsi
  acc07a:	movl   $0xffffffff,(%rsi,%r11,4)
  acc082:	mov    0x30(%r14),%rsi
  acc086:	movl   $0xffffffff,(%rsi,%r11,4)
  acc08e:	mov    0x18(%r14),%rsi
  acc092:	movb   $0x0,(%rsi,%r11,1)
  acc097:	xor    %esi,%esi
  acc099:	cmp    $0x4,%r10d
  acc09d:	mov    %r15d,%r10d
  acc0a0:	mov    %rdi,%r11
  acc0a3:	mov    (%r14),%r8
  acc0a6:	sete   %sil
  acc0aa:	lea    0x26(%rsi,%rsi,4),%esi
  acc0ae:	mov    %sil,(%r8,%r10,1)
  acc0b2:	mov    0x8(%r14),%rsi
  acc0b6:	mov    %r9b,(%rsi,%r10,1)
  acc0ba:	mov    0x20(%r14),%rsi
  acc0be:	mov    %eax,(%rsi,%r10,4)
  acc0c2:	mov    0x28(%r14),%rax
  acc0c6:	movl   $0xffffffff,(%rax,%r10,4)
  acc0ce:	mov    0x30(%r14),%rax
  acc0d2:	movl   $0xffffffff,(%rax,%r10,4)
  acc0da:	mov    0x18(%r14),%rax
  acc0de:	movb   $0x0,(%rax,%r10,1)
  acc0e3:	jmp    acd28a <ir_typed_emit_function+0x1aea>
  acc0e8:	test   %r14,%r14
  acc0eb:	je     acc125 <ir_typed_emit_function+0x985>
  acc0ed:	mov    (%r14),%rax
  acc0f0:	mov    %r15d,%esi
  acc0f3:	movb   $0x29,(%rax,%rsi,1)
  acc0f7:	mov    0x8(%r14),%rax
  acc0fb:	movb   $0xa,(%rax,%rsi,1)
  acc0ff:	mov    0x20(%r14),%rax
  acc103:	mov    %r8d,(%rax,%rsi,4)
  acc107:	mov    0x28(%r14),%rax
  acc10b:	movl   $0xffffffff,(%rax,%rsi,4)
  acc112:	mov    0x30(%r14),%rax
  acc116:	movl   $0xffffffff,(%rax,%rsi,4)
  acc11d:	mov    0x18(%r14),%rax
  acc121:	movb   $0x0,(%rax,%rsi,1)
  acc125:	lea    -0x1(%r11),%ebp
  acc129:	mov    %r15,%r8
  acc12c:	inc    %r15
  acc12f:	xor    %edi,%edi
  acc131:	mov    (%rdx,%rbp,4),%eax
  acc134:	test   %r14,%r14
  acc137:	je     acc171 <ir_typed_emit_function+0x9d1>
  acc139:	mov    (%r14),%rsi
  acc13c:	mov    %r15d,%r9d
  acc13f:	movb   $0x2c,(%rsi,%r9,1)
  acc144:	mov    0x8(%r14),%rsi
  acc148:	movb   $0x0,(%rsi,%r9,1)
  acc14d:	mov    0x20(%r14),%rsi
  acc151:	mov    %r8d,(%rsi,%r9,4)
  acc155:	mov    0x28(%r14),%rsi
  acc159:	mov    %eax,(%rsi,%r9,4)
  acc15d:	mov    0x30(%r14),%rax
  acc161:	movl   $0xffffffff,(%rax,%r9,4)
  acc169:	mov    0x18(%r14),%rax
  acc16d:	mov    %dil,(%rax,%r9,1)
  acc171:	inc    %r15
  acc174:	cmp    $0x21,%r10d
  acc178:	je     acbef0 <ir_typed_emit_function+0x750>
  acc17e:	cmp    $0x1f,%r10d
  acc182:	je     acbef0 <ir_typed_emit_function+0x750>
  acc188:	mov    %r11d,%ebp
  acc18b:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acc190:	lea    -0x1(%r11),%eax
  acc194:	test   %r14,%r14
  acc197:	je     acc1e3 <ir_typed_emit_function+0xa43>
  acc199:	mov    0x90(%rsp),%rdi
  acc1a1:	mov    (%r14),%r8
  acc1a4:	mov    (%rdx,%rax,4),%esi
  acc1a7:	mov    %r15d,%r10d
  acc1aa:	movzbl (%rdi,%rcx,1),%edi
  acc1ae:	mov    %dil,(%r8,%r10,1)
  acc1b2:	mov    0x8(%r14),%rdi
  acc1b6:	mov    %r9b,(%rdi,%r10,1)
  acc1ba:	mov    0x20(%r14),%rdi
  acc1be:	mov    %esi,(%rdi,%r10,4)
  acc1c2:	mov    0x28(%r14),%rsi
  acc1c6:	movl   $0xffffffff,(%rsi,%r10,4)
  acc1ce:	mov    0x30(%r14),%rsi
  acc1d2:	movl   $0xffffffff,(%rsi,%r10,4)
  acc1da:	mov    0x18(%r14),%rsi
  acc1de:	movb   $0x0,(%rsi,%r10,1)
  acc1e3:	mov    %r15d,%esi
  acc1e6:	inc    %r15
  acc1e9:	mov    %esi,(%rdx,%rax,4)
  acc1ec:	mov    %r11d,%ebp
  acc1ef:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acc1f4:	dec    %r11d
  acc1f7:	mov    %r11d,%edi
  acc1fa:	mov    %r11,0x28(%rsp)
  acc1ff:	test   %r14,%r14
  acc202:	je     acca31 <ir_typed_emit_function+0x1291>
  acc208:	mov    0x20(%rsp),%rdx
  acc20d:	mov    0x60(%r14),%rax
  acc211:	vxorps %xmm0,%xmm0,%xmm0
  acc215:	lea    0x1(%r15),%r12
  acc219:	mov    %r12d,%r11d
  acc21c:	mov    %edx,%esi
  acc21e:	shl    $0x4,%rsi
  acc222:	vmovups %xmm0,(%rax,%rsi,1)
  acc227:	mov    %r15d,%esi
  acc22a:	mov    (%r14),%rax
  acc22d:	movb   $0x1,(%rax,%rsi,1)
  acc231:	mov    0x8(%r14),%rax
  acc235:	mov    %r9b,(%rax,%rsi,1)
  acc239:	mov    0x20(%r14),%rax
  acc23d:	mov    %edx,(%rax,%rsi,4)
  acc240:	mov    0x128(%rsp),%rdx
  acc248:	mov    0x28(%r14),%rax
  acc24c:	movl   $0xffffffff,(%rax,%rsi,4)
  acc253:	mov    0x30(%r14),%rax
  acc257:	movl   $0xffffffff,(%rax,%rsi,4)
  acc25e:	mov    0x18(%r14),%rax
  acc262:	movb   $0x0,(%rax,%rsi,1)
  acc266:	mov    (%r14),%r9
  acc269:	mov    (%rdx,%rdi,4),%eax
  acc26c:	movb   $0x19,(%r9,%r11,1)
  acc271:	mov    0x8(%r14),%r9
  acc275:	movb   $0x1,(%r9,%r11,1)
  acc27a:	mov    0x20(%r14),%r9
  acc27e:	mov    %eax,(%r9,%r11,4)
  acc282:	mov    0x28(%r14),%rax
  acc286:	mov    %r15d,(%rax,%r11,4)
  acc28a:	mov    0x30(%r14),%rax
  acc28e:	movl   $0x1,(%rax,%r11,4)
  acc296:	mov    0x18(%r14),%rax
  acc29a:	movb   $0x0,(%rax,%r11,1)
  acc29f:	mov    0x28(%rsp),%r11
  acc2a4:	lea    0x1(%r12),%rax
  acc2a9:	test   %r11d,%r11d
  acc2ac:	je     acca43 <ir_typed_emit_function+0x12a3>
  acc2b2:	mov    0x30(%rbx),%r9d
  acc2b6:	cmp    $0x1,%edi
  acc2b9:	jne    acca5e <ir_typed_emit_function+0x12be>
  acc2bf:	mov    0x20(%rsp),%rdx
  acc2c4:	xor    %r11d,%r11d
  acc2c7:	jmp    accbd8 <ir_typed_emit_function+0x1438>
  acc2cc:	test   %r11d,%r11d
  acc2cf:	je     accec5 <ir_typed_emit_function+0x1725>
  acc2d5:	mov    0x30(%rbx),%esi
  acc2d8:	cmp    $0x1,%r11d
  acc2dc:	jne    acccdb <ir_typed_emit_function+0x153b>
  acc2e2:	xor    %edi,%edi
  acc2e4:	jmp    acce55 <ir_typed_emit_function+0x16b5>
  acc2e9:	mov    %r11,%rax
  acc2ec:	lea    -0x1(%r11),%ebp
  acc2f0:	add    $0xfffffffe,%eax
  acc2f3:	mov    (%rdx,%rbp,4),%r11d
  acc2f7:	mov    (%rdx,%rax,4),%edi
  acc2fa:	mov    %rax,%r8
  acc2fd:	lea    -0x16(%r10),%eax
  acc301:	cmp    $0x5,%al
  acc303:	ja     accf21 <ir_typed_emit_function+0x1781>
  acc309:	test   %r14,%r14
  acc30c:	je     acd5a1 <ir_typed_emit_function+0x1e01>
  acc312:	movzbl 0x0(%r13,%r8,1),%eax
  acc318:	mov    $0x0,%ebx
  acc31d:	mov    %eax,%esi
  acc31f:	and    $0xf9,%sil
  acc323:	cmp    $0x1,%sil
  acc327:	setne  %sil
  acc32b:	add    $0xf7,%al
  acc32d:	cmp    $0x18,%r10b
  acc331:	setae  %r9b
  acc335:	cmp    $0x2,%al
  acc337:	setae  %al
  acc33a:	adc    $0x19,%bl
  acc33d:	and    %sil,%al
  acc340:	mov    (%r14),%rsi
  acc343:	and    %r9b,%al
  acc346:	mov    %r15d,%r9d
  acc349:	movzbl %al,%eax
  acc34c:	lea    -0x16(%r10,%rax,4),%eax
  acc351:	mov    %r15d,%r10d
  acc354:	inc    %r15
  acc357:	mov    %bl,(%rsi,%r10,1)
  acc35b:	mov    0x10(%rsp),%rbx
  acc360:	mov    0x8(%r14),%rsi
  acc364:	movb   $0x1,(%rsi,%r10,1)
  acc369:	mov    0x20(%r14),%rsi
  acc36d:	mov    %edi,(%rsi,%r10,4)
  acc371:	mov    0x28(%r14),%rsi
  acc375:	mov    %r11d,(%rsi,%r10,4)
  acc379:	mov    0x30(%r14),%rsi
  acc37d:	mov    %eax,(%rsi,%r10,4)
  acc381:	mov    %r15d,%esi
  acc384:	mov    0x18(%r14),%rax
  acc388:	movb   $0x0,(%rax,%r10,1)
  acc38d:	mov    (%r14),%rax
  acc390:	movb   $0x1d,(%rax,%rsi,1)
  acc394:	mov    0x8(%r14),%rax
  acc398:	movb   $0x4,(%rax,%rsi,1)
  acc39c:	mov    0x20(%r14),%rax
  acc3a0:	mov    %r9d,(%rax,%rsi,4)
  acc3a4:	mov    0x28(%r14),%rax
  acc3a8:	movl   $0xffffffff,(%rax,%rsi,4)
  acc3af:	mov    0x30(%r14),%rax
  acc3b3:	movl   $0xffffffff,(%rax,%rsi,4)
  acc3ba:	mov    0x18(%r14),%rax
  acc3be:	movb   $0x0,(%rax,%rsi,1)
  acc3c2:	jmp    acd818 <ir_typed_emit_function+0x2078>
  acc3c7:	lea    -0x2(%r11),%ebp
  acc3cb:	test   %r14,%r14
  acc3ce:	je     accfbc <ir_typed_emit_function+0x181c>
  acc3d4:	mov    (%r14),%r9
  acc3d7:	dec    %r11d
  acc3da:	mov    %rdx,%rsi
  acc3dd:	mov    %r15d,%edi
  acc3e0:	mov    (%rdx,%r11,4),%eax
  acc3e4:	mov    %ebp,%edx
  acc3e6:	mov    (%rsi,%rdx,4),%edx
  acc3e9:	movb   $0x25,(%r9,%rdi,1)
  acc3ee:	mov    0x8(%r14),%rsi
  acc3f2:	movb   $0xa,(%rsi,%rdi,1)
  acc3f6:	mov    0x20(%r14),%rsi
  acc3fa:	mov    %edx,(%rsi,%rdi,4)
  acc3fd:	mov    0x28(%r14),%rdx
  acc401:	movl   $0xffffffff,(%rdx,%rdi,4)
  acc408:	mov    0x30(%r14),%rdx
  acc40c:	movl   $0xffffffff,(%rdx,%rdi,4)
  acc413:	mov    0x18(%r14),%rdx
  acc417:	movb   $0x0,(%rdx,%rdi,1)
  acc41b:	lea    0x1(%r15),%rdx
  acc41f:	mov    (%r14),%rsi
  acc422:	mov    %edx,%edi
  acc424:	movb   $0x25,(%rsi,%rdi,1)
  acc428:	mov    0x8(%r14),%rsi
  acc42c:	movb   $0xa,(%rsi,%rdi,1)
  acc430:	mov    0x20(%r14),%rsi
  acc434:	mov    %eax,(%rsi,%rdi,4)
  acc437:	mov    0x28(%r14),%rax
  acc43b:	movl   $0xffffffff,(%rax,%rdi,4)
  acc442:	mov    0x30(%r14),%rax
  acc446:	movl   $0xffffffff,(%rax,%rdi,4)
  acc44d:	mov    0x18(%r14),%rax
  acc451:	movb   $0x0,(%rax,%rdi,1)
  acc455:	lea    0x1(%rdx),%rdi
  acc459:	test   %r8,%r8
  acc45c:	jne    accfcd <ir_typed_emit_function+0x182d>
  acc462:	jmp    acd1f7 <ir_typed_emit_function+0x1a57>
  acc467:	mov    0x58(%rbx),%rax
  acc46b:	sub    (%rax,%r8,4),%r11d
  acc46f:	lea    (%rdx,%r11,4),%r13
  acc473:	mov    %r11,0x28(%rsp)
  acc478:	mov    %r8d,%r11d
  acc47b:	mov    (%rax,%r11,4),%edi
  acc47f:	mov    0x68(%rsp),%rdx
  acc484:	test   %r14,%r14
  acc487:	je     acd541 <ir_typed_emit_function+0x1da1>
  acc48d:	mov    %edx,%eax
  acc48f:	mov    0x60(%rbx),%r10
  acc493:	mov    0x90(%r14),%rsi
  acc49a:	mov    0x40(%rsp),%rdx
  acc49f:	lea    (%rax,%rax,4),%rax
  acc4a3:	mov    %r9b,0xf(%rsp)
  acc4a8:	mov    %rdi,0x88(%rsp)
  acc4b0:	cmpb   $0x0,(%r10,%r11,1)
  acc4b5:	mov    %edx,(%rsi,%rax,4)
  acc4b8:	mov    0x48(%rsp),%rdx
  acc4bd:	mov    %edi,0x4(%rsi,%rax,4)
  acc4c1:	mov    %edx,0x8(%rsi,%rax,4)
  acc4c5:	mov    %edi,0xc(%rsi,%rax,4)
  acc4c9:	mov    %r9b,0x10(%rsi,%rax,4)
  acc4ce:	setne  0x11(%rsi,%rax,4)
  acc4d3:	movw   $0x0,0x12(%rsi,%rax,4)
  acc4da:	test   %edi,%edi
  acc4dc:	je     acd4ef <ir_typed_emit_function+0x1d4f>
  acc4e2:	mov    0x88(%rsp),%rax
  acc4ea:	mov    %r13,0x80(%rsp)
  acc4f2:	mov    %eax,%ebp
  acc4f4:	and    $0x3,%ebp
  acc4f7:	cmp    $0x4,%eax
  acc4fa:	jae    acd339 <ir_typed_emit_function+0x1b99>
  acc500:	mov    0x48(%rsp),%rdx
  acc505:	mov    0x40(%rsp),%r9
  acc50a:	mov    0x80(%rsp),%r13
  acc512:	xor    %eax,%eax
  acc514:	lea    -0x4ecdeb(%rip),%rdi        # 5df730 <ir_typed_types>
  acc51b:	jmp    acd4b0 <ir_typed_emit_function+0x1d10>
  acc520:	lea    -0x1(%r11),%eax
  acc524:	test   %r14,%r14
  acc527:	je     acd207 <ir_typed_emit_function+0x1a67>
  acc52d:	mov    (%r14),%r8
  acc530:	mov    %r11,%rdi
  acc533:	mov    (%rdx,%rax,4),%esi
  acc536:	mov    %r15d,%r11d
  acc539:	mov    %r15d,%r10d
  acc53c:	inc    %r15
  acc53f:	movb   $0x25,(%r8,%r11,1)
  acc544:	mov    0x8(%r14),%r8
  acc548:	movb   $0xa,(%r8,%r11,1)
  acc54d:	mov    0x20(%r14),%r8
  acc551:	mov    %esi,(%r8,%r11,4)
  acc555:	mov    %r15d,%r8d
  acc558:	mov    0x28(%r14),%rsi
  acc55c:	movl   $0xffffffff,(%rsi,%r11,4)
  acc564:	mov    0x30(%r14),%rsi
  acc568:	movl   $0xffffffff,(%rsi,%r11,4)
  acc570:	mov    0x18(%r14),%rsi
  acc574:	movb   $0x0,(%rsi,%r11,1)
  acc579:	mov    %rdi,%r11
  acc57c:	mov    (%r14),%rsi
  acc57f:	movb   $0x2b,(%rsi,%r8,1)
  acc584:	mov    0x8(%r14),%rsi
  acc588:	mov    %r9b,(%rsi,%r8,1)
  acc58c:	mov    0x20(%r14),%rsi
  acc590:	mov    %r10d,(%rsi,%r8,4)
  acc594:	mov    0x28(%r14),%rsi
  acc598:	movl   $0xffffffff,(%rsi,%r8,4)
  acc5a0:	mov    0x30(%r14),%rsi
  acc5a4:	movl   $0xffffffff,(%rsi,%r8,4)
  acc5ac:	mov    0x18(%r14),%rsi
  acc5b0:	movb   $0x0,(%rsi,%r8,1)
  acc5b5:	jmp    acd20a <ir_typed_emit_function+0x1a6a>
  acc5ba:	lea    -0x1(%r11),%eax
  acc5be:	lea    -0x4ece95(%rip),%rdi        # 5df730 <ir_typed_types>
  acc5c5:	movzbl 0x0(%r13,%rax,1),%r10d
  acc5cb:	mov    (%rdx,%rax,4),%r8d
  acc5cf:	movzbl (%rsi,%rdi,1),%esi
  acc5d3:	movzbl (%r10,%rdi,1),%r9d
  acc5d8:	cmp    %sil,%r9b
  acc5db:	je     acd71e <ir_typed_emit_function+0x1f7e>
  acc5e1:	mov    %r12d,%ebp
  acc5e4:	mov    %r11,%r12
  acc5e7:	movzbl %sil,%r11d
  acc5eb:	lea    -0x1(%r9),%ebx
  acc5ef:	cmp    $0x5,%bl
  acc5f2:	ja     acd300 <ir_typed_emit_function+0x1b60>
  acc5f8:	lea    -0x1(%rsi),%ebx
  acc5fb:	cmp    $0x5,%bl
  acc5fe:	ja     acd6b8 <ir_typed_emit_function+0x1f18>
  acc604:	lea    -0x5d10fb(%rip),%rdi        # 4fb510 <ir_type_bits>
  acc60b:	movzwl (%rdi,%r9,2),%ebx
  acc610:	mov    $0x1c,%r9b
  acc613:	cmp    (%rdi,%r11,2),%bx
  acc618:	mov    0x10(%rsp),%rbx
  acc61d:	mov    %r12,%r11
  acc620:	ja     acd6d2 <ir_typed_emit_function+0x1f32>
  acc626:	and    $0xf9,%r10b
  acc62a:	cmp    $0x1,%r10b
  acc62e:	sete   %r9b
  acc632:	add    $0x1d,%r9b
  acc636:	jmp    acd6d2 <ir_typed_emit_function+0x1f32>
  acc63b:	lea    -0x1(%r11),%eax
  acc63f:	mov    (%rdx,%rax,4),%eax
  acc642:	jmp    acd290 <ir_typed_emit_function+0x1af0>
  acc647:	lea    -0x1(%r11),%ebp
  acc64b:	add    $0xfffffffe,%r11d
  acc64f:	mov    (%rdx,%rbp,4),%eax
  acc652:	test   %r14,%r14
  acc655:	je     acc698 <ir_typed_emit_function+0xef8>
  acc657:	mov    (%r14),%r9
  acc65a:	mov    (%rdx,%r11,4),%esi
  acc65e:	mov    %r15d,%r10d
  acc661:	movb   $0x25,(%r9,%r10,1)
  acc666:	mov    0x8(%r14),%r9
  acc66a:	movb   $0xa,(%r9,%r10,1)
  acc66f:	mov    0x20(%r14),%r9
  acc673:	mov    %esi,(%r9,%r10,4)
  acc677:	mov    0x28(%r14),%rsi
  acc67b:	movl   $0xffffffff,(%rsi,%r10,4)
  acc683:	mov    0x30(%r14),%rsi
  acc687:	movl   $0xffffffff,(%rsi,%r10,4)
  acc68f:	mov    0x18(%r14),%rsi
  acc693:	movb   $0x0,(%rsi,%r10,1)
  acc698:	popcnt %r8,%rsi
  acc69d:	lea    0x1(%r15),%r9
  acc6a1:	cmp    $0x1,%esi
  acc6a4:	sete   %sil
  acc6a8:	test   $0xf,%r8b
  acc6ac:	setne  %r10b
  acc6b0:	test   %r10b,%sil
  acc6b3:	jne    acd5c6 <ir_typed_emit_function+0x1e26>
  acc6b9:	test   %r14,%r14
  acc6bc:	je     acd5a9 <ir_typed_emit_function+0x1e09>
  acc6c2:	mov    0x20(%rsp),%rdx
  acc6c7:	mov    0x60(%r14),%rsi
  acc6cb:	mov    %edx,%r10d
  acc6ce:	shl    $0x4,%r10
  acc6d2:	mov    %r8,(%rsi,%r10,1)
  acc6d6:	movq   $0x0,0x8(%rsi,%r10,1)
  acc6df:	mov    %r9d,%r8d
  acc6e2:	mov    (%r14),%rsi
  acc6e5:	movb   $0x1,(%rsi,%r8,1)
  acc6ea:	mov    0x8(%r14),%rsi
  acc6ee:	movb   $0x5,(%rsi,%r8,1)
  acc6f3:	mov    0x20(%r14),%rsi
  acc6f7:	mov    %edx,(%rsi,%r8,4)
  acc6fb:	mov    0x28(%r14),%rsi
  acc6ff:	movl   $0xffffffff,(%rsi,%r8,4)
  acc707:	mov    0x30(%r14),%rsi
  acc70b:	movl   $0xffffffff,(%rsi,%r8,4)
  acc713:	mov    0x18(%r14),%rsi
  acc717:	movb   $0x0,(%rsi,%r8,1)
  acc71c:	lea    0x2(%r15),%rsi
  acc720:	mov    (%r14),%r8
  acc723:	mov    %esi,%r10d
  acc726:	movb   $0x7,(%r8,%r10,1)
  acc72b:	mov    0x8(%r14),%r8
  acc72f:	movb   $0x5,(%r8,%r10,1)
  acc734:	mov    0x20(%r14),%r8
  acc738:	mov    %eax,(%r8,%r10,4)
  acc73c:	mov    0x28(%r14),%rax
  acc740:	mov    %r9d,(%rax,%r10,4)
  acc744:	mov    0x30(%r14),%rax
  acc748:	movl   $0xffffffff,(%rax,%r10,4)
  acc750:	mov    0x18(%r14),%rax
  acc754:	movb   $0x0,(%rax,%r10,1)
  acc759:	mov    %rsi,%rax
  acc75c:	jmp    acd5b2 <ir_typed_emit_function+0x1e12>
  acc761:	and    $0xf,%esi
  acc764:	lea    -0x4ed02b(%rip),%rax        # 5df740 <tier0_class_bytes.bytes>
  acc76b:	movzbl (%rsi,%rax,1),%r10d
  acc770:	cmp    $0x4,%r10d
  acc774:	je     acd248 <ir_typed_emit_function+0x1aa8>
  acc77a:	mov    $0x3,%al
  acc77c:	cmp    $0x8,%r10d
  acc780:	je     acc78d <ir_typed_emit_function+0xfed>
  acc782:	add    $0xfd,%sil
  acc786:	cmp    $0x2,%sil
  acc78a:	setb   %al
  acc78d:	test   %r14,%r14
  acc790:	jne    acd24f <ir_typed_emit_function+0x1aaf>
  acc796:	jmp    acd28a <ir_typed_emit_function+0x1aea>
  acc79b:	test   %r14,%r14
  acc79e:	je     acc818 <ir_typed_emit_function+0x1078>
  acc7a0:	movzbl %r9b,%eax
  acc7a4:	mov    $0x9f,%edx
  acc7a9:	bt     %rax,%rdx
  acc7ad:	jae    acc7bf <ir_typed_emit_function+0x101f>
  acc7af:	lea    -0x5d12a6(%rip),%rdx        # 4fb510 <ir_type_bits>
  acc7b6:	movzbl (%rdx,%rax,2),%eax
  acc7ba:	bzhi   %rax,%r8,%r8
  acc7bf:	mov    0x20(%rsp),%rdx
  acc7c4:	mov    %r15d,%esi
  acc7c7:	mov    %edx,%eax
  acc7c9:	shl    $0x4,%rax
  acc7cd:	add    0x60(%r14),%rax
  acc7d1:	mov    %r8,(%rax)
  acc7d4:	movq   $0x0,0x8(%rax)
  acc7dc:	mov    (%r14),%rax
  acc7df:	movb   $0x1,(%rax,%rsi,1)
  acc7e3:	mov    0x8(%r14),%rax
  acc7e7:	mov    %r9b,(%rax,%rsi,1)
  acc7eb:	mov    0x20(%r14),%rax
  acc7ef:	mov    %edx,(%rax,%rsi,4)
  acc7f2:	mov    0x128(%rsp),%rdx
  acc7fa:	mov    0x28(%r14),%rax
  acc7fe:	movl   $0xffffffff,(%rax,%rsi,4)
  acc805:	mov    0x30(%r14),%rax
  acc809:	movl   $0xffffffff,(%rax,%rsi,4)
  acc810:	mov    0x18(%r14),%rax
  acc814:	movb   $0x0,(%rax,%rsi,1)
  acc818:	incq   0x20(%rsp)
  acc81d:	jmp    acd28a <ir_typed_emit_function+0x1aea>
  acc822:	test   %r14,%r14
  acc825:	je     acd28a <ir_typed_emit_function+0x1aea>
  acc82b:	mov    (%r14),%rax
  acc82e:	mov    %r15d,%esi
  acc831:	movb   $0x26,(%rax,%rsi,1)
  acc835:	mov    0x8(%r14),%rax
  acc839:	movb   $0x5,(%rax,%rsi,1)
  acc83d:	mov    0x20(%r14),%rax
  acc841:	mov    %r8d,(%rax,%rsi,4)
  acc845:	mov    0x28(%r14),%rax
  acc849:	movl   $0xffffffff,(%rax,%rsi,4)
  acc850:	mov    0x30(%r14),%rax
  acc854:	movl   $0xffffffff,(%rax,%rsi,4)
  acc85b:	mov    0x18(%r14),%rax
  acc85f:	movb   $0x0,(%rax,%rsi,1)
  acc863:	jmp    acd28a <ir_typed_emit_function+0x1aea>
  acc868:	dec    %r11d
  acc86b:	mov    %r11d,%ebp
  acc86e:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acc873:	dec    %r11d
  acc876:	test   %r14,%r14
  acc879:	je     acc8b8 <ir_typed_emit_function+0x1118>
  acc87b:	mov    (%r14),%rsi
  acc87e:	mov    %r11d,%eax
  acc881:	mov    (%rdx,%rax,4),%eax
  acc884:	mov    %r15d,%edi
  acc887:	movb   $0x37,(%rsi,%rdi,1)
  acc88b:	mov    0x8(%r14),%rsi
  acc88f:	movb   $0x0,(%rsi,%rdi,1)
  acc893:	mov    0x20(%r14),%rsi
  acc897:	mov    %eax,(%rsi,%rdi,4)
  acc89a:	mov    0x28(%r14),%rax
  acc89e:	movl   $0xffffffff,(%rax,%rdi,4)
  acc8a5:	mov    0x30(%r14),%rax
  acc8a9:	movl   $0xffffffff,(%rax,%rdi,4)
  acc8b0:	mov    0x18(%r14),%rax
  acc8b4:	movb   $0x0,(%rax,%rdi,1)
  acc8b8:	inc    %r15
  acc8bb:	mov    %r11d,%ebp
  acc8be:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acc8c3:	test   %r14,%r14
  acc8c6:	je     acc903 <ir_typed_emit_function+0x1163>
  acc8c8:	mov    (%r14),%rax
  acc8cb:	mov    %r15d,%esi
  acc8ce:	movb   $0x36,(%rax,%rsi,1)
  acc8d2:	mov    0x8(%r14),%rax
  acc8d6:	movb   $0x5,(%rax,%rsi,1)
  acc8da:	mov    0x20(%r14),%rax
  acc8de:	movl   $0xffffffff,(%rax,%rsi,4)
  acc8e5:	mov    0x28(%r14),%rax
  acc8e9:	movl   $0xffffffff,(%rax,%rsi,4)
  acc8f0:	mov    0x30(%r14),%rax
  acc8f4:	movl   $0xffffffff,(%rax,%rsi,4)
  acc8fb:	mov    0x18(%r14),%rax
  acc8ff:	movb   $0x0,(%rax,%rsi,1)
  acc903:	mov    %r15d,%eax
  acc906:	mov    %r11d,%esi
  acc909:	mov    %eax,(%rdx,%rsi,4)
  acc90c:	inc    %r15
  acc90f:	movb   $0x8,0x0(%r13,%rsi,1)
  acc915:	jmp    acd29b <ir_typed_emit_function+0x1afb>
  acc91a:	test   %r12b,%r12b
  acc91d:	je     acd218 <ir_typed_emit_function+0x1a78>
  acc923:	dec    %r11d
  acc926:	mov    (%rdx,%r11,4),%eax
  acc92a:	mov    %r11d,%ebp
  acc92d:	test   %r14,%r14
  acc930:	je     acc971 <ir_typed_emit_function+0x11d1>
  acc932:	mov    (%r14),%rdx
  acc935:	mov    %r15d,%esi
  acc938:	movb   $0x33,(%rdx,%rsi,1)
  acc93c:	mov    0x8(%r14),%rdx
  acc940:	movb   $0x0,(%rdx,%rsi,1)
  acc944:	mov    0x20(%r14),%rdx
  acc948:	mov    %eax,(%rdx,%rsi,4)
  acc94b:	mov    0x128(%rsp),%rdx
  acc953:	mov    0x28(%r14),%rax
  acc957:	movl   $0xffffffff,(%rax,%rsi,4)
  acc95e:	mov    0x30(%r14),%rax
  acc962:	movl   $0xffffffff,(%rax,%rsi,4)
  acc969:	mov    0x18(%r14),%rax
  acc96d:	movb   $0x0,(%rax,%rsi,1)
  acc971:	mov    $0x1,%al
  acc973:	inc    %r15
  acc976:	mov    %eax,0x38(%rsp)
  acc97a:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acc97f:	lea    -0x1(%r11),%eax
  acc983:	test   %r14,%r14
  acc986:	je     acd22e <ir_typed_emit_function+0x1a8e>
  acc98c:	mov    (%r14),%rdi
  acc98f:	mov    (%rdx,%rax,4),%esi
  acc992:	mov    %r15d,%r9d
  acc995:	mov    %r15d,%r8d
  acc998:	inc    %r15
  acc99b:	movb   $0x35,(%rdi,%r9,1)
  acc9a0:	mov    0x8(%r14),%rdi
  acc9a4:	movb   $0xa,(%rdi,%r9,1)
  acc9a9:	mov    0x20(%r14),%rdi
  acc9ad:	mov    %esi,(%rdi,%r9,4)
  acc9b1:	mov    %r15d,%edi
  acc9b4:	mov    0x28(%r14),%rsi
  acc9b8:	movl   $0xffffffff,(%rsi,%r9,4)
  acc9c0:	mov    0x30(%r14),%rsi
  acc9c4:	movl   $0xffffffff,(%rsi,%r9,4)
  acc9cc:	mov    0x18(%r14),%rsi
  acc9d0:	movb   $0x0,(%rsi,%r9,1)
  acc9d5:	mov    (%r14),%rsi
  acc9d8:	movb   $0x26,(%rsi,%rdi,1)
  acc9dc:	mov    0x8(%r14),%rsi
  acc9e0:	movb   $0x5,(%rsi,%rdi,1)
  acc9e4:	mov    0x20(%r14),%rsi
  acc9e8:	mov    %r8d,(%rsi,%rdi,4)
  acc9ec:	mov    0x28(%r14),%rsi
  acc9f0:	movl   $0xffffffff,(%rsi,%rdi,4)
  acc9f7:	mov    0x30(%r14),%rsi
  acc9fb:	movl   $0xffffffff,(%rsi,%rdi,4)
  acca02:	mov    0x18(%r14),%rsi
  acca06:	movb   $0x0,(%rsi,%rdi,1)
  acca0a:	jmp    acd231 <ir_typed_emit_function+0x1a91>
  acca0f:	mov    %r11,%rdi
  acca12:	inc    %r15
  acca15:	inc    %r15
  acca18:	cmp    $0x1c,%r10d
  acca1c:	je     acbedd <ir_typed_emit_function+0x73d>
  acca22:	mov    %edi,%ebp
  acca24:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acca29:	inc    %r15
  acca2c:	jmp    acd28a <ir_typed_emit_function+0x1aea>
  acca31:	lea    0x1(%r15),%r12
  acca35:	lea    0x1(%r12),%rax
  acca3a:	test   %r11d,%r11d
  acca3d:	jne    acc2b2 <ir_typed_emit_function+0xb12>
  acca43:	mov    0x20(%rsp),%rdx
  acca48:	jmp    accc59 <ir_typed_emit_function+0x14b9>
  acca4d:	mov    $0x2,%dil
  acca50:	test   %r14,%r14
  acca53:	jne    acc139 <ir_typed_emit_function+0x999>
  acca59:	jmp    acc171 <ir_typed_emit_function+0x9d1>
  acca5e:	mov    %edi,%eax
  acca60:	and    $0xfffffffe,%eax
  acca63:	xor    %r11d,%r11d
  acca66:	mov    %r12,0x38(%rsp)
  acca6b:	jmp    accad0 <ir_typed_emit_function+0x1330>
  acca6d:	nopl   (%rax)
  acca70:	mov    $0x3,%bpl
  acca73:	test   %r14,%r14
  acca76:	je     accac3 <ir_typed_emit_function+0x1323>
  acca78:	mov    (%r14),%r13
  acca7b:	lea    0x3(%r15,%r11,1),%rsi
  acca80:	lea    0x1(%r9,%r11,1),%r12
  acca85:	mov    %esi,%esi
  acca87:	movb   $0x2c,0x0(%r13,%rsi,1)
  acca8d:	mov    0x8(%r14),%r13
  acca91:	movb   $0x0,0x0(%r13,%rsi,1)
  acca97:	mov    0x20(%r14),%r13
  acca9b:	mov    %r12d,0x0(%r13,%rsi,4)
  accaa0:	mov    0x130(%rsp),%r13
  accaa8:	mov    0x28(%r14),%r12
  accaac:	mov    %ebx,(%r12,%rsi,4)
  accab0:	mov    0x30(%r14),%rbx
  accab4:	movl   $0xffffffff,(%rbx,%rsi,4)
  accabb:	mov    0x18(%r14),%rbx
  accabf:	mov    %bpl,(%rbx,%rsi,1)
  accac3:	add    $0x2,%r11
  accac7:	cmp    %r11,%rax
  accaca:	je     accbba <ir_typed_emit_function+0x141a>
  accad0:	movzbl 0x0(%r13,%r11,1),%r12d
  accad6:	lea    -0x4ed39d(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  accadd:	and    $0xf,%r12d
  accae1:	movzbl (%r12,%rsi,1),%ebp
  accae6:	cmp    $0x4,%ebp
  accae9:	je     accb90 <ir_typed_emit_function+0x13f0>
  accaef:	mov    $0x3,%bl
  accaf1:	cmp    $0x8,%ebp
  accaf4:	je     accb01 <ir_typed_emit_function+0x1361>
  accaf6:	add    $0xfd,%r12b
  accafa:	cmp    $0x2,%r12b
  accafe:	setb   %bl
  accb01:	test   %r14,%r14
  accb04:	je     accb53 <ir_typed_emit_function+0x13b3>
  accb06:	mov    (%r14),%rsi
  accb09:	lea    0x2(%r15,%r11,1),%r12
  accb0e:	mov    (%rdx,%r11,4),%ebp
  accb12:	lea    (%r9,%r11,1),%r13
  accb16:	mov    %r12d,%r12d
  accb19:	movb   $0x2c,(%rsi,%r12,1)
  accb1e:	mov    0x8(%r14),%rsi
  accb22:	movb   $0x0,(%rsi,%r12,1)
  accb27:	mov    0x20(%r14),%rsi
  accb2b:	mov    %r13d,(%rsi,%r12,4)
  accb2f:	mov    0x130(%rsp),%r13
  accb37:	mov    0x28(%r14),%rsi
  accb3b:	mov    %ebp,(%rsi,%r12,4)
  accb3f:	mov    0x30(%r14),%rsi
  accb43:	movl   $0xffffffff,(%rsi,%r12,4)
  accb4b:	mov    0x18(%r14),%rsi
  accb4f:	mov    %bl,(%rsi,%r12,1)
  accb53:	movzbl 0x1(%r13,%r11,1),%r12d
  accb59:	lea    -0x4ed420(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  accb60:	mov    0x4(%rdx,%r11,4),%ebx
  accb65:	and    $0xf,%r12d
  accb69:	movzbl (%r12,%rsi,1),%ebp
  accb6e:	cmp    $0x8,%ebp
  accb71:	je     acca70 <ir_typed_emit_function+0x12d0>
  accb77:	cmp    $0x4,%ebp
  accb7a:	jne    accba0 <ir_typed_emit_function+0x1400>
  accb7c:	mov    $0x2,%bpl
  accb7f:	test   %r14,%r14
  accb82:	jne    acca78 <ir_typed_emit_function+0x12d8>
  accb88:	jmp    accac3 <ir_typed_emit_function+0x1323>
  accb8d:	nopl   (%rax)
  accb90:	mov    $0x2,%bl
  accb92:	test   %r14,%r14
  accb95:	jne    accb06 <ir_typed_emit_function+0x1366>
  accb9b:	jmp    accb53 <ir_typed_emit_function+0x13b3>
  accb9d:	nopl   (%rax)
  accba0:	add    $0xfd,%r12b
  accba4:	cmp    $0x2,%r12b
  accba8:	setb   %bpl
  accbac:	test   %r14,%r14
  accbaf:	jne    acca78 <ir_typed_emit_function+0x12d8>
  accbb5:	jmp    accac3 <ir_typed_emit_function+0x1323>
  accbba:	mov    0x10(%rsp),%rbx
  accbbf:	mov    0x20(%rsp),%rdx
  accbc4:	mov    0x38(%rsp),%r12
  accbc9:	lea    0x2(%r15,%r11,1),%rax
  accbce:	test   $0x1,%dil
  accbd2:	je     accc59 <ir_typed_emit_function+0x14b9>
  accbd8:	movzbl 0x0(%r13,%r11,1),%edi
  accbde:	lea    -0x4ed4a5(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  accbe5:	and    $0xf,%edi
  accbe8:	movzbl (%rdi,%rsi,1),%ebx
  accbec:	cmp    $0x8,%ebx
  accbef:	je     acd2a6 <ir_typed_emit_function+0x1b06>
  accbf5:	cmp    $0x4,%ebx
  accbf8:	jne    acd2cc <ir_typed_emit_function+0x1b2c>
  accbfe:	mov    $0x2,%dil
  accc01:	mov    0x10(%rsp),%rbx
  accc06:	test   %r14,%r14
  accc09:	je     accc56 <ir_typed_emit_function+0x14b6>
  accc0b:	lea    (%r11,%r9,1),%esi
  accc0f:	mov    0x128(%rsp),%r9
  accc17:	mov    (%r14),%r15
  accc1a:	mov    %eax,%ebx
  accc1c:	mov    (%r9,%r11,4),%r9d
  accc20:	movb   $0x2c,(%r15,%rbx,1)
  accc25:	mov    0x8(%r14),%r11
  accc29:	movb   $0x0,(%r11,%rbx,1)
  accc2e:	mov    0x20(%r14),%r11
  accc32:	mov    %esi,(%r11,%rbx,4)
  accc36:	mov    0x28(%r14),%rsi
  accc3a:	mov    %r9d,(%rsi,%rbx,4)
  accc3e:	mov    0x30(%r14),%rsi
  accc42:	movl   $0xffffffff,(%rsi,%rbx,4)
  accc49:	mov    0x18(%r14),%rsi
  accc4d:	mov    %dil,(%rsi,%rbx,1)
  accc51:	mov    0x10(%rsp),%rbx
  accc56:	inc    %rax
  accc59:	test   %r14,%r14
  accc5c:	je     acccb5 <ir_typed_emit_function+0x1515>
  accc5e:	mov    0x50(%rsp),%rsi
  accc63:	mov    %eax,%r9d
  accc66:	mov    0x8(%rsi),%rsi
  accc6a:	mov    (%rsi,%r8,4),%esi
  accc6e:	mov    0x74(%rsp),%r8d
  accc73:	inc    %esi
  accc75:	cmp    $0x25,%r10d
  accc79:	mov    (%r14),%r10
  accc7c:	mov    %esi,%edi
  accc7e:	cmove  %r8d,%edi
  accc82:	cmovne %r8d,%esi
  accc86:	movb   $0x31,(%r10,%r9,1)
  accc8b:	mov    0x8(%r14),%r8
  accc8f:	movb   $0x0,(%r8,%r9,1)
  accc94:	mov    0x20(%r14),%r8
  accc98:	mov    %r12d,(%r8,%r9,4)
  accc9c:	mov    0x28(%r14),%r8
  accca0:	mov    %esi,(%r8,%r9,4)
  accca4:	mov    0x30(%r14),%rsi
  accca8:	mov    %edi,(%rsi,%r9,4)
  acccac:	mov    0x18(%r14),%rsi
  acccb0:	movb   $0x0,(%rsi,%r9,1)
  acccb5:	inc    %rdx
  acccb8:	inc    %rax
  acccbb:	mov    0x28(%rsp),%rbp
  acccc0:	mov    %rdx,0x20(%rsp)
  acccc5:	mov    $0x1,%dl
  acccc7:	mov    %rax,%r15
  acccca:	mov    %edx,0x38(%rsp)
  acccce:	mov    0x128(%rsp),%rdx
  acccd6:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acccdb:	mov    %r11d,%eax
  acccde:	mov    %eax,%r9d
  accce1:	and    $0xfffffffe,%r9d
  accce5:	mov    %r11,0x28(%rsp)
  acccea:	mov    %esi,%r10d
  accced:	xor    %edi,%edi
  acccef:	jmp    accd68 <ir_typed_emit_function+0x15c8>
  acccf1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  accd00:	mov    $0x3,%bl
  accd02:	test   %r14,%r14
  accd05:	je     accd53 <ir_typed_emit_function+0x15b3>
  accd07:	mov    (%r14),%r13
  accd0a:	lea    0x1(%r15),%r12
  accd0e:	lea    0x1(%r10),%ebp
  accd12:	mov    %r12d,%r12d
  accd15:	movb   $0x2c,0x0(%r13,%r12,1)
  accd1b:	mov    0x8(%r14),%r13
  accd1f:	movb   $0x0,0x0(%r13,%r12,1)
  accd25:	mov    0x20(%r14),%r13
  accd29:	mov    %ebp,0x0(%r13,%r12,4)
  accd2e:	mov    0x28(%r14),%r13
  accd32:	mov    %r11d,0x0(%r13,%r12,4)
  accd37:	mov    0x130(%rsp),%r13
  accd3f:	mov    0x30(%r14),%r11
  accd43:	movl   $0xffffffff,(%r11,%r12,4)
  accd4b:	mov    0x18(%r14),%r11
  accd4f:	mov    %bl,(%r11,%r12,1)
  accd53:	add    $0x2,%r15
  accd57:	add    $0x2,%rdi
  accd5b:	add    $0x2,%r10d
  accd5f:	cmp    %rdi,%r9
  accd62:	je     acce47 <ir_typed_emit_function+0x16a7>
  accd68:	movzbl 0x0(%r13,%rdi,1),%ebx
  accd6e:	lea    -0x4ed635(%rip),%r11        # 5df740 <tier0_class_bytes.bytes>
  accd75:	and    $0xf,%ebx
  accd78:	movzbl (%rbx,%r11,1),%ebp
  accd7d:	cmp    $0x4,%ebp
  accd80:	je     acce20 <ir_typed_emit_function+0x1680>
  accd86:	mov    $0x3,%r11b
  accd89:	cmp    $0x8,%ebp
  accd8c:	je     accd98 <ir_typed_emit_function+0x15f8>
  accd8e:	add    $0xfd,%bl
  accd91:	cmp    $0x2,%bl
  accd94:	setb   %r11b
  accd98:	test   %r14,%r14
  accd9b:	je     accde0 <ir_typed_emit_function+0x1640>
  accd9d:	mov    (%r14),%r12
  accda0:	mov    (%rdx,%rdi,4),%ebx
  accda3:	mov    %r15d,%r13d
  accda6:	movb   $0x2c,(%r12,%r13,1)
  accdab:	mov    0x8(%r14),%r12
  accdaf:	movb   $0x0,(%r12,%r13,1)
  accdb4:	mov    0x20(%r14),%r12
  accdb8:	mov    %r10d,(%r12,%r13,4)
  accdbc:	mov    0x28(%r14),%r12
  accdc0:	mov    %ebx,(%r12,%r13,4)
  accdc4:	mov    0x30(%r14),%rbx
  accdc8:	movl   $0xffffffff,(%rbx,%r13,4)
  accdd0:	mov    0x18(%r14),%rbx
  accdd4:	mov    %r11b,(%rbx,%r13,1)
  accdd8:	mov    0x130(%rsp),%r13
  accde0:	movzbl 0x1(%r13,%rdi,1),%ebx
  accde6:	lea    -0x4ed6ad(%rip),%r12        # 5df740 <tier0_class_bytes.bytes>
  accded:	mov    0x4(%rdx,%rdi,4),%r11d
  accdf2:	and    $0xf,%ebx
  accdf5:	movzbl (%rbx,%r12,1),%ebp
  accdfa:	cmp    $0x8,%ebp
  accdfd:	je     accd00 <ir_typed_emit_function+0x1560>
  acce03:	cmp    $0x4,%ebp
  acce06:	jne    acce30 <ir_typed_emit_function+0x1690>
  acce08:	mov    $0x2,%bl
  acce0a:	test   %r14,%r14
  acce0d:	jne    accd07 <ir_typed_emit_function+0x1567>
  acce13:	jmp    accd53 <ir_typed_emit_function+0x15b3>
  acce18:	nopl   0x0(%rax,%rax,1)
  acce20:	mov    $0x2,%r11b
  acce23:	test   %r14,%r14
  acce26:	jne    accd9d <ir_typed_emit_function+0x15fd>
  acce2c:	jmp    accde0 <ir_typed_emit_function+0x1640>
  acce2e:	xchg   %ax,%ax
  acce30:	add    $0xfd,%bl
  acce33:	cmp    $0x2,%bl
  acce36:	setb   %bl
  acce39:	test   %r14,%r14
  acce3c:	jne    accd07 <ir_typed_emit_function+0x1567>
  acce42:	jmp    accd53 <ir_typed_emit_function+0x15b3>
  acce47:	mov    0x10(%rsp),%rbx
  acce4c:	mov    0x28(%rsp),%r11
  acce51:	test   $0x1,%al
  acce53:	je     accec5 <ir_typed_emit_function+0x1725>
  acce55:	movzbl 0x0(%r13,%rdi,1),%eax
  acce5b:	lea    -0x4ed722(%rip),%r9        # 5df740 <tier0_class_bytes.bytes>
  acce62:	and    $0xf,%eax
  acce65:	movzbl (%rax,%r9,1),%r9d
  acce6a:	cmp    $0x8,%r9d
  acce6e:	je     acd2bc <ir_typed_emit_function+0x1b1c>
  acce74:	cmp    $0x4,%r9d
  acce78:	jne    acd2eb <ir_typed_emit_function+0x1b4b>
  acce7e:	mov    $0x2,%al
  acce80:	test   %r14,%r14
  acce83:	je     accec2 <ir_typed_emit_function+0x1722>
  acce85:	mov    (%r14),%r9
  acce88:	add    %edi,%esi
  acce8a:	mov    (%rdx,%rdi,4),%edi
  acce8d:	mov    %r15d,%r10d
  acce90:	movb   $0x2c,(%r9,%r10,1)
  acce95:	mov    0x8(%r14),%r9
  acce99:	movb   $0x0,(%r9,%r10,1)
  acce9e:	mov    0x20(%r14),%r9
  accea2:	mov    %esi,(%r9,%r10,4)
  accea6:	mov    0x28(%r14),%rsi
  acceaa:	mov    %edi,(%rsi,%r10,4)
  acceae:	mov    0x30(%r14),%rsi
  acceb2:	movl   $0xffffffff,(%rsi,%r10,4)
  acceba:	mov    0x18(%r14),%rsi
  accebe:	mov    %al,(%rsi,%r10,1)
  accec2:	inc    %r15
  accec5:	test   %r14,%r14
  accec8:	je     accf10 <ir_typed_emit_function+0x1770>
  acceca:	mov    0x50(%rsp),%rax
  accecf:	mov    (%r14),%rsi
  acced2:	mov    %r15d,%edi
  acced5:	mov    0x8(%rax),%rax
  acced9:	mov    (%rax,%r8,4),%eax
  accedd:	movb   $0x30,(%rsi,%rdi,1)
  accee1:	mov    0x8(%r14),%rsi
  accee5:	inc    %eax
  accee7:	movb   $0x0,(%rsi,%rdi,1)
  acceeb:	mov    0x20(%r14),%rsi
  acceef:	mov    %eax,(%rsi,%rdi,4)
  accef2:	mov    0x28(%r14),%rax
  accef6:	movl   $0xffffffff,(%rax,%rdi,4)
  accefd:	mov    0x30(%r14),%rax
  accf01:	movl   $0xffffffff,(%rax,%rdi,4)
  accf08:	mov    0x18(%r14),%rax
  accf0c:	movb   $0x0,(%rax,%rdi,1)
  accf10:	mov    $0x1,%al
  accf12:	inc    %r15
  accf15:	mov    %r11d,%ebp
  accf18:	mov    %eax,0x38(%rsp)
  accf1c:	jmp    acbef0 <ir_typed_emit_function+0x750>
  accf21:	add    $0xed,%r10b
  accf25:	lea    -0x4ed7fc(%rip),%rax        # 5df730 <ir_typed_types>
  accf2c:	cmp    $0x1,%r10b
  accf30:	ja     acd7d0 <ir_typed_emit_function+0x2030>
  accf36:	movzbl 0x0(%r13,%rbp,1),%ebx
  accf3c:	movzbl (%rbx,%rax,1),%r10d
  accf41:	movzbl (%rsi,%rax,1),%eax
  accf45:	cmp    %al,%r10b
  accf48:	je     acd7cb <ir_typed_emit_function+0x202b>
  accf4e:	mov    %r9b,0xf(%rsp)
  accf53:	mov    %r12d,%r9d
  accf56:	movzbl %al,%esi
  accf59:	lea    -0x1(%r10),%r12d
  accf5d:	cmp    $0x5,%r12b
  accf61:	ja     acd72f <ir_typed_emit_function+0x1f8f>
  accf67:	lea    -0x1(%rax),%r12d
  accf6b:	cmp    $0x5,%r12b
  accf6f:	ja     acd829 <ir_typed_emit_function+0x2089>
  accf75:	mov    %edi,0x28(%rsp)
  accf79:	lea    -0x5d1a70(%rip),%rdi        # 4fb510 <ir_type_bits>
  accf80:	movzwl (%rdi,%r10,2),%r12d
  accf85:	mov    $0x1c,%r10b
  accf88:	cmp    (%rdi,%rsi,2),%r12w
  accf8d:	mov    0x28(%rsp),%edi
  accf91:	mov    %r9d,%r12d
  accf94:	ja     acd783 <ir_typed_emit_function+0x1fe3>
  accf9a:	and    $0xf9,%bl
  accf9d:	cmp    $0x1,%bl
  accfa0:	sete   %r10b
  accfa4:	add    $0x1d,%r10b
  accfa8:	movzbl 0xf(%rsp),%r9d
  accfae:	test   %r14,%r14
  accfb1:	jne    acd78e <ir_typed_emit_function+0x1fee>
  accfb7:	jmp    acd7c5 <ir_typed_emit_function+0x2025>
  accfbc:	lea    0x1(%r15),%rdx
  accfc0:	lea    0x1(%rdx),%rdi
  accfc4:	test   %r8,%r8
  accfc7:	je     acd1f7 <ir_typed_emit_function+0x1a57>
  accfcd:	xor    %r9d,%r9d
  accfd0:	jmp    acd02f <ir_typed_emit_function+0x188f>
  accfd2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  accfe0:	mov    %r15d,%eax
  accfe3:	mov    (%r14),%r11
  accfe6:	mov    %esi,%ebx
  accfe8:	movb   $0x2c,(%r11,%rbx,1)
  accfed:	mov    0x8(%r14),%r11
  accff1:	movb   $0x0,(%r11,%rbx,1)
  accff6:	mov    0x20(%r14),%r11
  accffa:	mov    %eax,(%r11,%rbx,4)
  accffe:	mov    0x28(%r14),%rax
  acd002:	mov    %edi,(%rax,%rbx,4)
  acd005:	mov    %rsi,%rdi
  acd008:	mov    0x30(%r14),%rax
  acd00c:	movl   $0xffffffff,(%rax,%rbx,4)
  acd013:	mov    0x18(%r14),%rax
  acd017:	movb   $0x0,(%rax,%rbx,1)
  acd01b:	mov    0x10(%rsp),%rbx
  acd020:	inc    %rdi
  acd023:	add    %r10,%r9
  acd026:	cmp    %r8,%r9
  acd029:	jae    acd1f7 <ir_typed_emit_function+0x1a57>
  acd02f:	mov    %r8,%rax
  acd032:	sub    %r9,%rax
  acd035:	cmp    $0x7,%rax
  acd039:	jbe    acd0d0 <ir_typed_emit_function+0x1930>
  acd03f:	mov    $0x5,%al
  acd041:	mov    $0x8,%r10d
  acd047:	test   %r9,%r9
  acd04a:	je     acd10c <ir_typed_emit_function+0x196c>
  acd050:	test   %r14,%r14
  acd053:	je     acd1e0 <ir_typed_emit_function+0x1a40>
  acd059:	mov    0x30(%rsp),%r12
  acd05e:	mov    0x80(%r14),%rsi
  acd065:	mov    %edi,%ebx
  acd067:	mov    %r12d,%r11d
  acd06a:	shl    $0x4,%r11
  acd06e:	mov    %r9,(%rsi,%r11,1)
  acd072:	movb   $0x1,0x8(%rsi,%r11,1)
  acd078:	movl   $0x0,0x9(%rsi,%r11,1)
  acd081:	movl   $0x0,0xc(%rsi,%r11,1)
  acd08a:	mov    %edi,%r11d
  acd08d:	inc    %rdi
  acd090:	mov    (%r14),%rsi
  acd093:	movb   $0x2a,(%rsi,%rbx,1)
  acd097:	mov    0x8(%r14),%rsi
  acd09b:	movb   $0xa,(%rsi,%rbx,1)
  acd09f:	mov    0x20(%r14),%rsi
  acd0a3:	mov    %edx,(%rsi,%rbx,4)
  acd0a6:	mov    0x28(%r14),%rsi
  acd0aa:	movl   $0xffffffff,(%rsi,%rbx,4)
  acd0b1:	mov    0x30(%r14),%rsi
  acd0b5:	mov    %r12d,(%rsi,%rbx,4)
  acd0b9:	lea    0x1(%r12),%rsi
  acd0be:	mov    0x18(%r14),%r12
  acd0c2:	mov    %rsi,0x30(%rsp)
  acd0c7:	movb   $0x0,(%r12,%rbx,1)
  acd0cc:	jmp    acd118 <ir_typed_emit_function+0x1978>
  acd0ce:	xchg   %ax,%ax
  acd0d0:	cmp    $0x3,%rax
  acd0d4:	jbe    acd0f0 <ir_typed_emit_function+0x1950>
  acd0d6:	mov    $0x4,%al
  acd0d8:	mov    $0x4,%r10d
  acd0de:	test   %r9,%r9
  acd0e1:	jne    acd050 <ir_typed_emit_function+0x18b0>
  acd0e7:	jmp    acd10c <ir_typed_emit_function+0x196c>
  acd0e9:	nopl   0x0(%rax)
  acd0f0:	xor    %r10d,%r10d
  acd0f3:	cmp    $0x2,%rax
  acd0f7:	setae  %r10b
  acd0fb:	mov    %r10d,%eax
  acd0fe:	inc    %r10
  acd101:	or     $0x2,%al
  acd103:	test   %r9,%r9
  acd106:	jne    acd050 <ir_typed_emit_function+0x18b0>
  acd10c:	test   %r14,%r14
  acd10f:	je     acd1ef <ir_typed_emit_function+0x1a4f>
  acd115:	mov    %edx,%r11d
  acd118:	mov    (%r14),%rbx
  acd11b:	mov    %edi,%r12d
  acd11e:	lea    0x1(%rdi),%rsi
  acd122:	movb   $0x2b,(%rbx,%r12,1)
  acd127:	mov    0x8(%r14),%rbx
  acd12b:	mov    %al,(%rbx,%r12,1)
  acd12f:	mov    0x20(%r14),%rax
  acd133:	mov    %r11d,(%rax,%r12,4)
  acd137:	mov    0x28(%r14),%rax
  acd13b:	movl   $0xffffffff,(%rax,%r12,4)
  acd143:	mov    0x30(%r14),%rax
  acd147:	movl   $0xffffffff,(%rax,%r12,4)
  acd14f:	mov    0x18(%r14),%rax
  acd153:	movb   $0x0,(%rax,%r12,1)
  acd158:	test   %r9,%r9
  acd15b:	je     accfe0 <ir_typed_emit_function+0x1840>
  acd161:	mov    0x30(%rsp),%r11
  acd166:	mov    0x80(%r14),%r12
  acd16d:	mov    %r11d,%eax
  acd170:	mov    %eax,%ebx
  acd172:	shl    $0x4,%rbx
  acd176:	inc    %r11
  acd179:	mov    %r9,(%r12,%rbx,1)
  acd17d:	movb   $0x1,0x8(%r12,%rbx,1)
  acd183:	movl   $0x0,0x9(%r12,%rbx,1)
  acd18c:	movl   $0x0,0xc(%r12,%rbx,1)
  acd195:	mov    %r11,0x30(%rsp)
  acd19a:	mov    %esi,%ebx
  acd19c:	mov    (%r14),%r11
  acd19f:	movb   $0x2a,(%r11,%rbx,1)
  acd1a4:	mov    0x8(%r14),%r11
  acd1a8:	movb   $0xa,(%r11,%rbx,1)
  acd1ad:	mov    0x20(%r14),%r11
  acd1b1:	mov    %r15d,(%r11,%rbx,4)
  acd1b5:	mov    0x28(%r14),%r11
  acd1b9:	movl   $0xffffffff,(%r11,%rbx,4)
  acd1c1:	mov    0x30(%r14),%r11
  acd1c5:	mov    %eax,(%r11,%rbx,4)
  acd1c9:	mov    0x18(%r14),%rax
  acd1cd:	movb   $0x0,(%rax,%rbx,1)
  acd1d1:	mov    %esi,%eax
  acd1d3:	mov    %rdi,%rsi
  acd1d6:	add    $0x2,%rsi
  acd1da:	jmp    accfe3 <ir_typed_emit_function+0x1843>
  acd1df:	nop
  acd1e0:	addq   $0x2,0x30(%rsp)
  acd1e6:	add    $0x3,%rdi
  acd1ea:	jmp    acd01b <ir_typed_emit_function+0x187b>
  acd1ef:	inc    %rdi
  acd1f2:	jmp    acd01b <ir_typed_emit_function+0x187b>
  acd1f7:	mov    0x128(%rsp),%rdx
  acd1ff:	mov    %rdi,%r15
  acd202:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acd207:	inc    %r15
  acd20a:	mov    %r15d,%esi
  acd20d:	inc    %r15
  acd210:	mov    %esi,(%rdx,%rax,4)
  acd213:	jmp    acd722 <ir_typed_emit_function+0x1f82>
  acd218:	mov    $0xffffffff,%eax
  acd21d:	mov    %r11d,%ebp
  acd220:	test   %r14,%r14
  acd223:	jne    acc932 <ir_typed_emit_function+0x1192>
  acd229:	jmp    acc971 <ir_typed_emit_function+0x11d1>
  acd22e:	inc    %r15
  acd231:	mov    %r15d,%esi
  acd234:	mov    %esi,(%rdx,%rax,4)
  acd237:	inc    %r15
  acd23a:	movb   $0x8,0x0(%r13,%rax,1)
  acd240:	mov    %r11d,%ebp
  acd243:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acd248:	mov    $0x2,%al
  acd24a:	test   %r14,%r14
  acd24d:	je     acd28a <ir_typed_emit_function+0x1aea>
  acd24f:	mov    (%r14),%rsi
  acd252:	mov    %r15d,%r10d
  acd255:	movb   $0x2b,(%rsi,%r10,1)
  acd25a:	mov    0x8(%r14),%rsi
  acd25e:	mov    %r9b,(%rsi,%r10,1)
  acd262:	mov    0x20(%r14),%rsi
  acd266:	mov    %r8d,(%rsi,%r10,4)
  acd26a:	mov    0x28(%r14),%rsi
  acd26e:	movl   $0xffffffff,(%rsi,%r10,4)
  acd276:	mov    0x30(%r14),%rsi
  acd27a:	movl   $0xffffffff,(%rsi,%r10,4)
  acd282:	mov    0x18(%r14),%rsi
  acd286:	mov    %al,(%rsi,%r10,1)
  acd28a:	mov    %r15d,%eax
  acd28d:	inc    %r15
  acd290:	mov    %r11d,%esi
  acd293:	mov    %eax,(%rdx,%rsi,4)
  acd296:	mov    %r12b,0x0(%r13,%rsi,1)
  acd29b:	inc    %r11d
  acd29e:	mov    %r11d,%ebp
  acd2a1:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acd2a6:	mov    $0x3,%dil
  acd2a9:	mov    0x10(%rsp),%rbx
  acd2ae:	test   %r14,%r14
  acd2b1:	jne    accc0b <ir_typed_emit_function+0x146b>
  acd2b7:	jmp    accc56 <ir_typed_emit_function+0x14b6>
  acd2bc:	mov    $0x3,%al
  acd2be:	test   %r14,%r14
  acd2c1:	jne    acce85 <ir_typed_emit_function+0x16e5>
  acd2c7:	jmp    accec2 <ir_typed_emit_function+0x1722>
  acd2cc:	add    $0xfd,%dil
  acd2d0:	cmp    $0x2,%dil
  acd2d4:	setb   %dil
  acd2d8:	mov    0x10(%rsp),%rbx
  acd2dd:	test   %r14,%r14
  acd2e0:	jne    accc0b <ir_typed_emit_function+0x146b>
  acd2e6:	jmp    accc56 <ir_typed_emit_function+0x14b6>
  acd2eb:	add    $0xfd,%al
  acd2ed:	cmp    $0x2,%al
  acd2ef:	setb   %al
  acd2f2:	test   %r14,%r14
  acd2f5:	jne    acce85 <ir_typed_emit_function+0x16e5>
  acd2fb:	jmp    accec2 <ir_typed_emit_function+0x1722>
  acd300:	lea    -0x7(%r9),%r10d
  acd304:	cmp    $0x2,%r10b
  acd308:	ja     acd6a8 <ir_typed_emit_function+0x1f08>
  acd30e:	lea    -0x7(%rsi),%r10d
  acd312:	cmp    $0x2,%r10b
  acd316:	ja     acd6a8 <ir_typed_emit_function+0x1f08>
  acd31c:	lea    -0x5d1e13(%rip),%rdi        # 4fb510 <ir_type_bits>
  acd323:	movzwl (%rdi,%r11,2),%r10d
  acd328:	cmp    (%rdi,%r9,2),%r10w
  acd32d:	mov    $0x20,%r9b
  acd330:	sbb    $0x0,%r9b
  acd334:	jmp    acd6ca <ir_typed_emit_function+0x1f2a>
  acd339:	and    $0xfffffffc,%eax
  acd33c:	mov    0x28(%rsp),%rdx
  acd341:	mov    %r12b,0x1f(%rsp)
  acd346:	mov    0x40(%rsp),%r9
  acd34b:	lea    -0x4edc22(%rip),%rdi        # 5df730 <ir_typed_types>
  acd352:	mov    %rax,0xe0(%rsp)
  acd35a:	mov    0xc0(%rsp),%rax
  acd362:	lea    (%rax,%rdx,4),%r12
  acd366:	mov    0x48(%rsp),%rdx
  acd36b:	xor    %eax,%eax
  acd36d:	nopl   (%rax)
  acd370:	mov    -0xc(%r12,%rax,4),%r10d
  acd375:	mov    0x50(%r14),%r8
  acd379:	mov    0x10(%rsp),%rsi
  acd37e:	lea    (%r9,%rax,1),%rbx
  acd382:	mov    %ebx,%r13d
  acd385:	mov    %r10d,(%r8,%r13,4)
  acd389:	mov    0x50(%rsi),%r8
  acd38d:	mov    0x10(%rsp),%rsi
  acd392:	mov    0xa0(%r14),%r13
  acd399:	mov    (%r8,%r11,4),%r8d
  acd39d:	mov    0x78(%rsi),%r10
  acd3a1:	add    %eax,%r8d
  acd3a4:	movzbl (%r10,%r8,1),%r8d
  acd3a9:	lea    (%rdx,%rax,1),%r10
  acd3ad:	mov    %r10d,%esi
  acd3b0:	movzbl (%r8,%rdi,1),%r8d
  acd3b5:	mov    %r8b,0x0(%r13,%rsi,1)
  acd3ba:	lea    0x1(%rbx),%r13d
  acd3be:	mov    -0x8(%r12,%rax,4),%esi
  acd3c3:	mov    0x50(%r14),%r8
  acd3c7:	mov    %esi,(%r8,%r13,4)
  acd3cb:	mov    0x10(%rsp),%r13
  acd3d0:	mov    0x10(%rsp),%r8
  acd3d5:	mov    0x50(%r13),%rsi
  acd3d9:	mov    0x78(%r8),%r8
  acd3dd:	lea    0x1(%r10),%r13d
  acd3e1:	mov    (%rsi,%r11,4),%esi
  acd3e5:	lea    0x1(%rax,%rsi,1),%esi
  acd3e9:	movzbl (%r8,%rsi,1),%esi
  acd3ee:	mov    0xa0(%r14),%r8
  acd3f5:	movzbl (%rsi,%rdi,1),%esi
  acd3f9:	mov    %sil,(%r8,%r13,1)
  acd3fd:	lea    0x2(%rbx),%r13d
  acd401:	add    $0x3,%ebx
  acd404:	mov    -0x4(%r12,%rax,4),%esi
  acd409:	mov    0x50(%r14),%r8
  acd40d:	mov    %esi,(%r8,%r13,4)
  acd411:	mov    0x10(%rsp),%r8
  acd416:	lea    0x2(%r10),%r13d
  acd41a:	add    $0x3,%r10d
  acd41e:	mov    0x50(%r8),%rsi
  acd422:	mov    0x10(%rsp),%r8
  acd427:	mov    (%rsi,%r11,4),%esi
  acd42b:	mov    0x78(%r8),%r8
  acd42f:	lea    0x2(%rax,%rsi,1),%esi
  acd433:	movzbl (%r8,%rsi,1),%esi
  acd438:	mov    0xa0(%r14),%r8
  acd43f:	movzbl (%rsi,%rdi,1),%esi
  acd443:	mov    %sil,(%r8,%r13,1)
  acd447:	mov    (%r12,%rax,4),%esi
  acd44b:	mov    0x50(%r14),%r8
  acd44f:	mov    %esi,(%r8,%rbx,4)
  acd453:	mov    0x10(%rsp),%rbx
  acd458:	mov    0x50(%rbx),%rsi
  acd45c:	mov    0x78(%rbx),%r8
  acd460:	mov    (%rsi,%r11,4),%esi
  acd464:	lea    0x3(%rax,%rsi,1),%esi
  acd468:	add    $0x4,%rax
  acd46c:	movzbl (%r8,%rsi,1),%esi
  acd471:	mov    0xa0(%r14),%r8
  acd478:	movzbl (%rsi,%rdi,1),%esi
  acd47c:	mov    %sil,(%r8,%r10,1)
  acd480:	cmp    %rax,0xe0(%rsp)
  acd488:	jne    acd370 <ir_typed_emit_function+0x1bd0>
  acd48e:	movzbl 0x1f(%rsp),%r12d
  acd494:	mov    0x80(%rsp),%r13
  acd49c:	test   %rbp,%rbp
  acd49f:	je     acd4ef <ir_typed_emit_function+0x1d4f>
  acd4a1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  acd4b0:	mov    0x0(%r13,%rax,4),%esi
  acd4b5:	mov    0x50(%r14),%r8
  acd4b9:	lea    (%r9,%rax,1),%r10d
  acd4bd:	mov    %esi,(%r8,%r10,4)
  acd4c1:	lea    (%rdx,%rax,1),%r10d
  acd4c5:	mov    0x50(%rbx),%rsi
  acd4c9:	mov    0x78(%rbx),%r8
  acd4cd:	mov    (%rsi,%r11,4),%esi
  acd4d1:	add    %eax,%esi
  acd4d3:	inc    %rax
  acd4d6:	dec    %rbp
  acd4d9:	movzbl (%r8,%rsi,1),%esi
  acd4de:	mov    0xa0(%r14),%r8
  acd4e5:	movzbl (%rsi,%rdi,1),%esi
  acd4e9:	mov    %sil,(%r8,%r10,1)
  acd4ed:	jne    acd4b0 <ir_typed_emit_function+0x1d10>
  acd4ef:	mov    0x48(%rbx),%rax
  acd4f3:	mov    (%r14),%rsi
  acd4f6:	mov    %r15d,%r8d
  acd4f9:	movzbl 0xf(%rsp),%edx
  acd4fe:	mov    0x88(%rsp),%rdi
  acd506:	mov    (%rax,%r11,4),%eax
  acd50a:	movb   $0x2d,(%rsi,%r8,1)
  acd50f:	mov    0x8(%r14),%rsi
  acd513:	mov    %dl,(%rsi,%r8,1)
  acd517:	mov    0x68(%rsp),%rdx
  acd51c:	mov    0x20(%r14),%rsi
  acd520:	mov    %eax,(%rsi,%r8,4)
  acd524:	mov    0x28(%r14),%rax
  acd528:	mov    %edx,(%rax,%r8,4)
  acd52c:	mov    0x30(%r14),%rax
  acd530:	movl   $0xffffffff,(%rax,%r8,4)
  acd538:	mov    0x18(%r14),%rax
  acd53c:	movb   $0x0,(%rax,%r8,1)
  acd541:	add    %rdi,0x40(%rsp)
  acd546:	add    %rdi,0x48(%rsp)
  acd54b:	inc    %rdx
  acd54e:	lea    0x1(%r15),%rax
  acd552:	mov    %rdx,0x68(%rsp)
  acd557:	test   %r12b,%r12b
  acd55a:	je     acd584 <ir_typed_emit_function+0x1de4>
  acd55c:	mov    %r15d,0x0(%r13)
  acd560:	mov    0x28(%rsp),%rbp
  acd565:	mov    0x130(%rsp),%r13
  acd56d:	mov    0x128(%rsp),%rdx
  acd575:	mov    %rax,%r15
  acd578:	mov    %r12b,0x0(%r13,%rbp,1)
  acd57d:	inc    %ebp
  acd57f:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acd584:	mov    0x128(%rsp),%rdx
  acd58c:	mov    0x130(%rsp),%r13
  acd594:	mov    0x28(%rsp),%rbp
  acd599:	mov    %rax,%r15
  acd59c:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acd5a1:	inc    %r15
  acd5a4:	jmp    acd818 <ir_typed_emit_function+0x2078>
  acd5a9:	mov    0x20(%rsp),%rdx
  acd5ae:	lea    0x2(%r15),%rax
  acd5b2:	mov    %rax,%r9
  acd5b5:	inc    %rdx
  acd5b8:	inc    %r9
  acd5bb:	mov    $0x1,%r8d
  acd5c1:	mov    %rdx,0x20(%rsp)
  acd5c6:	test   %r14,%r14
  acd5c9:	je     acd679 <ir_typed_emit_function+0x1ed9>
  acd5cf:	mov    0x30(%rsp),%rdx
  acd5d4:	mov    0x80(%r14),%rsi
  acd5db:	mov    %edx,%r10d
  acd5de:	shl    $0x4,%r10
  acd5e2:	movq   $0x0,(%rsi,%r10,1)
  acd5ea:	mov    %r8b,0x8(%rsi,%r10,1)
  acd5ef:	movl   $0x0,0x9(%rsi,%r10,1)
  acd5f8:	movl   $0x0,0xc(%rsi,%r10,1)
  acd601:	mov    %r9d,%r10d
  acd604:	mov    %r9d,%r8d
  acd607:	inc    %r9
  acd60a:	mov    (%r14),%rsi
  acd60d:	movb   $0x2a,(%rsi,%r10,1)
  acd612:	mov    0x8(%r14),%rsi
  acd616:	movb   $0xa,(%rsi,%r10,1)
  acd61b:	mov    0x20(%r14),%rsi
  acd61f:	mov    %r15d,(%rsi,%r10,4)
  acd623:	mov    %r9,%r15
  acd626:	mov    0x28(%r14),%rsi
  acd62a:	mov    %eax,(%rsi,%r10,4)
  acd62e:	mov    %r9d,%esi
  acd631:	mov    0x30(%r14),%rax
  acd635:	mov    %edx,(%rax,%r10,4)
  acd639:	mov    0x18(%r14),%rax
  acd63d:	movb   $0x0,(%rax,%r10,1)
  acd642:	mov    (%r14),%rax
  acd645:	movb   $0x26,(%rax,%rsi,1)
  acd649:	mov    0x8(%r14),%rax
  acd64d:	movb   $0x5,(%rax,%rsi,1)
  acd651:	mov    0x20(%r14),%rax
  acd655:	mov    %r8d,(%rax,%rsi,4)
  acd659:	mov    0x28(%r14),%rax
  acd65d:	movl   $0xffffffff,(%rax,%rsi,4)
  acd664:	mov    0x30(%r14),%rax
  acd668:	movl   $0xffffffff,(%rax,%rsi,4)
  acd66f:	mov    0x18(%r14),%rax
  acd673:	movb   $0x0,(%rax,%rsi,1)
  acd677:	jmp    acd684 <ir_typed_emit_function+0x1ee4>
  acd679:	mov    0x30(%rsp),%rdx
  acd67e:	inc    %r9
  acd681:	mov    %r9,%r15
  acd684:	inc    %rdx
  acd687:	mov    %r15d,%eax
  acd68a:	inc    %r15
  acd68d:	mov    %rdx,0x30(%rsp)
  acd692:	mov    0x128(%rsp),%rdx
  acd69a:	mov    %eax,(%rdx,%r11,4)
  acd69e:	mov    %r12b,0x0(%r13,%r11,1)
  acd6a3:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acd6a8:	mov    %ebp,%r9d
  acd6ab:	and    $0xf9,%r9b
  acd6af:	cmp    $0x1,%r9b
  acd6b3:	mov    $0x24,%r9b
  acd6b6:	jmp    acd6c3 <ir_typed_emit_function+0x1f23>
  acd6b8:	and    $0xf9,%r10b
  acd6bc:	mov    $0x22,%r9b
  acd6bf:	cmp    $0x1,%r10b
  acd6c3:	sete   %r10b
  acd6c7:	sub    %r10b,%r9b
  acd6ca:	mov    0x10(%rsp),%rbx
  acd6cf:	mov    %r12,%r11
  acd6d2:	test   %r14,%r14
  acd6d5:	je     acd715 <ir_typed_emit_function+0x1f75>
  acd6d7:	mov    (%r14),%r10
  acd6da:	mov    %r15d,%r11d
  acd6dd:	mov    %r9b,(%r10,%r11,1)
  acd6e1:	mov    0x8(%r14),%r9
  acd6e5:	mov    %sil,(%r9,%r11,1)
  acd6e9:	mov    0x20(%r14),%rsi
  acd6ed:	mov    %r8d,(%rsi,%r11,4)
  acd6f1:	mov    0x28(%r14),%rsi
  acd6f5:	movl   $0xffffffff,(%rsi,%r11,4)
  acd6fd:	mov    0x30(%r14),%rsi
  acd701:	movl   $0xffffffff,(%rsi,%r11,4)
  acd709:	mov    0x18(%r14),%rsi
  acd70d:	movb   $0x0,(%rsi,%r11,1)
  acd712:	mov    %r12,%r11
  acd715:	mov    %r15d,%r8d
  acd718:	inc    %r15
  acd71b:	mov    %ebp,%r12d
  acd71e:	mov    %r8d,(%rdx,%rax,4)
  acd722:	mov    %r12b,0x0(%r13,%rax,1)
  acd727:	mov    %r11d,%ebp
  acd72a:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acd72f:	lea    -0x7(%r10),%ebx
  acd733:	cmp    $0x2,%bl
  acd736:	ja     acd76b <ir_typed_emit_function+0x1fcb>
  acd738:	lea    -0x7(%rax),%ebx
  acd73b:	cmp    $0x2,%bl
  acd73e:	ja     acd76b <ir_typed_emit_function+0x1fcb>
  acd740:	mov    %edi,%ebx
  acd742:	lea    -0x5d2239(%rip),%rdi        # 4fb510 <ir_type_bits>
  acd749:	mov    %r9d,%r12d
  acd74c:	movzwl (%rdi,%rsi,2),%esi
  acd750:	cmp    (%rdi,%r10,2),%si
  acd755:	mov    $0x20,%r10b
  acd758:	mov    %ebx,%edi
  acd75a:	sbb    $0x0,%r10b
  acd75e:	movzbl 0xf(%rsp),%r9d
  acd764:	test   %r14,%r14
  acd767:	jne    acd78e <ir_typed_emit_function+0x1fee>
  acd769:	jmp    acd7c5 <ir_typed_emit_function+0x2025>
  acd76b:	mov    %r9d,%esi
  acd76e:	mov    $0x24,%r10b
  acd771:	mov    %r9d,%r12d
  acd774:	and    $0xf9,%sil
  acd778:	cmp    $0x1,%sil
  acd77c:	sete   %sil
  acd780:	sub    %sil,%r10b
  acd783:	movzbl 0xf(%rsp),%r9d
  acd789:	test   %r14,%r14
  acd78c:	je     acd7c5 <ir_typed_emit_function+0x2025>
  acd78e:	mov    (%r14),%rsi
  acd791:	mov    %r15d,%ebx
  acd794:	mov    %r10b,(%rsi,%rbx,1)
  acd798:	mov    0x8(%r14),%rsi
  acd79c:	mov    %al,(%rsi,%rbx,1)
  acd79f:	mov    0x20(%r14),%rax
  acd7a3:	mov    %r11d,(%rax,%rbx,4)
  acd7a7:	mov    0x28(%r14),%rax
  acd7ab:	movl   $0xffffffff,(%rax,%rbx,4)
  acd7b2:	mov    0x30(%r14),%rax
  acd7b6:	movl   $0xffffffff,(%rax,%rbx,4)
  acd7bd:	mov    0x18(%r14),%rax
  acd7c1:	movb   $0x0,(%rax,%rbx,1)
  acd7c5:	mov    %r15d,%r11d
  acd7c8:	inc    %r15
  acd7cb:	mov    0x10(%rsp),%rbx
  acd7d0:	test   %r14,%r14
  acd7d3:	je     acd818 <ir_typed_emit_function+0x2078>
  acd7d5:	mov    0x90(%rsp),%rax
  acd7dd:	mov    (%r14),%rsi
  acd7e0:	mov    %r15d,%r10d
  acd7e3:	movzbl (%rax,%rcx,1),%eax
  acd7e7:	mov    %al,(%rsi,%r10,1)
  acd7eb:	mov    0x8(%r14),%rax
  acd7ef:	mov    %r9b,(%rax,%r10,1)
  acd7f3:	mov    0x20(%r14),%rax
  acd7f7:	mov    %edi,(%rax,%r10,4)
  acd7fb:	mov    0x28(%r14),%rax
  acd7ff:	mov    %r11d,(%rax,%r10,4)
  acd803:	mov    0x30(%r14),%rax
  acd807:	movl   $0xffffffff,(%rax,%r10,4)
  acd80f:	mov    0x18(%r14),%rax
  acd813:	movb   $0x0,(%rax,%r10,1)
  acd818:	mov    %r15d,(%rdx,%r8,4)
  acd81c:	inc    %r15
  acd81f:	mov    %r12b,0x0(%r13,%r8,1)
  acd824:	jmp    acbef0 <ir_typed_emit_function+0x750>
  acd829:	and    $0xf9,%bl
  acd82c:	mov    $0x22,%r10b
  acd82f:	mov    %r9d,%r12d
  acd832:	cmp    $0x1,%bl
  acd835:	sete   %sil
  acd839:	sub    %sil,%r10b
  acd83c:	movzbl 0xf(%rsp),%r9d
  acd842:	test   %r14,%r14
  acd845:	jne    acd78e <ir_typed_emit_function+0x1fee>
  acd84b:	jmp    acd7c5 <ir_typed_emit_function+0x2025>
  acd850:	testb  $0x1,0x38(%rsp)
  acd855:	mov    0xc8(%rsp),%r9
  acd85d:	jne    acbb86 <ir_typed_emit_function+0x3e6>
  acd863:	cmp    0x18(%rbx),%r9d
  acd867:	jne    acd8d0 <ir_typed_emit_function+0x2130>
  acd869:	cmpl   $0x0,0x5c(%rsp)
  acd86e:	je     acbb42 <ir_typed_emit_function+0x3a2>
  acd874:	test   %r14,%r14
  acd877:	je     acd8b7 <ir_typed_emit_function+0x2117>
  acd879:	mov    (%r14),%rax
  acd87c:	mov    %r15d,%ecx
  acd87f:	mov    0x5c(%rsp),%edx
  acd883:	movb   $0x2,(%rax,%rcx,1)
  acd887:	mov    0x8(%r14),%rax
  acd88b:	mov    %dl,(%rax,%rcx,1)
  acd88e:	mov    0x20(%r14),%rax
  acd892:	movl   $0xffffffff,(%rax,%rcx,4)
  acd899:	mov    0x28(%r14),%rax
  acd89d:	movl   $0xffffffff,(%rax,%rcx,4)
  acd8a4:	mov    0x30(%r14),%rax
  acd8a8:	movl   $0xffffffff,(%rax,%rcx,4)
  acd8af:	mov    0x18(%r14),%rax
  acd8b3:	movb   $0x0,(%rax,%rcx,1)
  acd8b7:	mov    %r15d,%eax
  acd8ba:	inc    %r15
  acd8bd:	test   %r14,%r14
  acd8c0:	jne    acbb4c <ir_typed_emit_function+0x3ac>
  acd8c6:	jmp    acbb83 <ir_typed_emit_function+0x3e3>
  acd8cb:	nopl   0x0(%rax,%rax,1)
  acd8d0:	test   %ebp,%ebp
  acd8d2:	je     acd8e8 <ir_typed_emit_function+0x2148>
  acd8d4:	mov    0x30(%rbx),%eax
  acd8d7:	cmp    $0x1,%ebp
  acd8da:	jne    acd919 <ir_typed_emit_function+0x2179>
  acd8dc:	mov    0x60(%rsp),%r12
  acd8e1:	xor    %ecx,%ecx
  acd8e3:	jmp    acda8f <ir_typed_emit_function+0x22ef>
  acd8e8:	mov    0x60(%rsp),%r12
  acd8ed:	jmp    acdaff <ir_typed_emit_function+0x235f>
  acd8f2:	mov    $0x3,%dl
  acd8f4:	test   %r14,%r14
  acd8f7:	jne    acbe52 <ir_typed_emit_function+0x6b2>
  acd8fd:	jmp    acbe9d <ir_typed_emit_function+0x6fd>
  acd902:	add    $0xfd,%dl
  acd905:	cmp    $0x2,%dl
  acd908:	setb   %dl
  acd90b:	test   %r14,%r14
  acd90e:	jne    acbe52 <ir_typed_emit_function+0x6b2>
  acd914:	jmp    acbe9d <ir_typed_emit_function+0x6fd>
  acd919:	mov    0x60(%rsp),%r12
  acd91e:	mov    %ebp,%edx
  acd920:	mov    %edx,%esi
  acd922:	and    $0xfffffffe,%esi
  acd925:	mov    %eax,%edi
  acd927:	xor    %ecx,%ecx
  acd929:	jmp    acd98c <ir_typed_emit_function+0x21ec>
  acd92b:	nopl   0x0(%rax,%rax,1)
  acd930:	mov    $0x3,%r9b
  acd933:	test   %r14,%r14
  acd936:	je     acd978 <ir_typed_emit_function+0x21d8>
  acd938:	mov    (%r14),%rbx
  acd93b:	lea    0x1(%r15),%r10
  acd93f:	lea    0x1(%rdi),%r11d
  acd943:	mov    %r10d,%r10d
  acd946:	movb   $0x2c,(%rbx,%r10,1)
  acd94b:	mov    0x8(%r14),%rbx
  acd94f:	movb   $0x0,(%rbx,%r10,1)
  acd954:	mov    0x20(%r14),%rbx
  acd958:	mov    %r11d,(%rbx,%r10,4)
  acd95c:	mov    0x28(%r14),%r11
  acd960:	mov    %r8d,(%r11,%r10,4)
  acd964:	mov    0x30(%r14),%r8
  acd968:	movl   $0xffffffff,(%r8,%r10,4)
  acd970:	mov    0x18(%r14),%r8
  acd974:	mov    %r9b,(%r8,%r10,1)
  acd978:	add    $0x2,%r15
  acd97c:	add    $0x2,%rcx
  acd980:	add    $0x2,%edi
  acd983:	cmp    %rcx,%rsi
  acd986:	je     acda8a <ir_typed_emit_function+0x22ea>
  acd98c:	movzbl 0x0(%r13,%rcx,1),%r9d
  acd992:	lea    -0x4ee259(%rip),%r8        # 5df740 <tier0_class_bytes.bytes>
  acd999:	and    $0xf,%r9d
  acd99d:	movzbl (%r9,%r8,1),%r10d
  acd9a2:	cmp    $0x4,%r10d
  acd9a6:	je     acda50 <ir_typed_emit_function+0x22b0>
  acd9ac:	mov    $0x3,%r8b
  acd9af:	cmp    $0x8,%r10d
  acd9b3:	je     acd9c1 <ir_typed_emit_function+0x2221>
  acd9b5:	add    $0xfd,%r9b
  acd9b9:	cmp    $0x2,%r9b
  acd9bd:	setb   %r8b
  acd9c1:	mov    0x128(%rsp),%rbx
  acd9c9:	test   %r14,%r14
  acd9cc:	je     acda0a <ir_typed_emit_function+0x226a>
  acd9ce:	mov    (%r14),%r10
  acd9d1:	mov    (%rbx,%rcx,4),%r9d
  acd9d5:	mov    %r15d,%r11d
  acd9d8:	movb   $0x2c,(%r10,%r11,1)
  acd9dd:	mov    0x8(%r14),%r10
  acd9e1:	movb   $0x0,(%r10,%r11,1)
  acd9e6:	mov    0x20(%r14),%r10
  acd9ea:	mov    %edi,(%r10,%r11,4)
  acd9ee:	mov    0x28(%r14),%r10
  acd9f2:	mov    %r9d,(%r10,%r11,4)
  acd9f6:	mov    0x30(%r14),%r9
  acd9fa:	movl   $0xffffffff,(%r9,%r11,4)
  acda02:	mov    0x18(%r14),%r9
  acda06:	mov    %r8b,(%r9,%r11,1)
  acda0a:	movzbl 0x1(%r13,%rcx,1),%r9d
  acda10:	lea    -0x4ee2d7(%rip),%r10        # 5df740 <tier0_class_bytes.bytes>
  acda17:	mov    0x4(%rbx,%rcx,4),%r8d
  acda1c:	and    $0xf,%r9d
  acda20:	movzbl (%r9,%r10,1),%r10d
  acda25:	cmp    $0x8,%r10d
  acda29:	je     acd930 <ir_typed_emit_function+0x2190>
  acda2f:	cmp    $0x4,%r10d
  acda33:	jne    acda70 <ir_typed_emit_function+0x22d0>
  acda35:	mov    $0x2,%r9b
  acda38:	test   %r14,%r14
  acda3b:	jne    acd938 <ir_typed_emit_function+0x2198>
  acda41:	jmp    acd978 <ir_typed_emit_function+0x21d8>
  acda46:	cs nopw 0x0(%rax,%rax,1)
  acda50:	mov    $0x2,%r8b
  acda53:	mov    0x128(%rsp),%rbx
  acda5b:	test   %r14,%r14
  acda5e:	jne    acd9ce <ir_typed_emit_function+0x222e>
  acda64:	jmp    acda0a <ir_typed_emit_function+0x226a>
  acda66:	cs nopw 0x0(%rax,%rax,1)
  acda70:	add    $0xfd,%r9b
  acda74:	cmp    $0x2,%r9b
  acda78:	setb   %r9b
  acda7c:	test   %r14,%r14
  acda7f:	jne    acd938 <ir_typed_emit_function+0x2198>
  acda85:	jmp    acd978 <ir_typed_emit_function+0x21d8>
  acda8a:	test   $0x1,%dl
  acda8d:	je     acdaff <ir_typed_emit_function+0x235f>
  acda8f:	movzbl 0x0(%r13,%rcx,1),%edx
  acda95:	lea    -0x4ee35c(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  acda9c:	and    $0xf,%edx
  acda9f:	movzbl (%rdx,%rsi,1),%esi
  acdaa3:	cmp    $0x8,%esi
  acdaa6:	je     acdb49 <ir_typed_emit_function+0x23a9>
  acdaac:	cmp    $0x4,%esi
  acdaaf:	jne    acdb56 <ir_typed_emit_function+0x23b6>
  acdab5:	mov    $0x2,%dl
  acdab7:	test   %r14,%r14
  acdaba:	je     acdafc <ir_typed_emit_function+0x235c>
  acdabc:	mov    0x128(%rsp),%rsi
  acdac4:	mov    (%r14),%r8
  acdac7:	add    %ecx,%eax
  acdac9:	mov    %r15d,%edi
  acdacc:	mov    (%rsi,%rcx,4),%ecx
  acdacf:	movb   $0x2c,(%r8,%rdi,1)
  acdad4:	mov    0x8(%r14),%rsi
  acdad8:	movb   $0x0,(%rsi,%rdi,1)
  acdadc:	mov    0x20(%r14),%rsi
  acdae0:	mov    %eax,(%rsi,%rdi,4)
  acdae3:	mov    0x28(%r14),%rax
  acdae7:	mov    %ecx,(%rax,%rdi,4)
  acdaea:	mov    0x30(%r14),%rax
  acdaee:	movl   $0xffffffff,(%rax,%rdi,4)
  acdaf5:	mov    0x18(%r14),%rax
  acdaf9:	mov    %dl,(%rax,%rdi,1)
  acdafc:	inc    %r15
  acdaff:	test   %r14,%r14
  acdb02:	je     acbb83 <ir_typed_emit_function+0x3e3>
  acdb08:	mov    (%r14),%rax
  acdb0b:	mov    %r15d,%ecx
  acdb0e:	add    $0x2,%r12d
  acdb12:	movb   $0x30,(%rax,%rcx,1)
  acdb16:	mov    0x8(%r14),%rax
  acdb1a:	movb   $0x0,(%rax,%rcx,1)
  acdb1e:	mov    0x20(%r14),%rax
  acdb22:	mov    %r12d,(%rax,%rcx,4)
  acdb26:	mov    0x28(%r14),%rax
  acdb2a:	movl   $0xffffffff,(%rax,%rcx,4)
  acdb31:	mov    0x30(%r14),%rax
  acdb35:	movl   $0xffffffff,(%rax,%rcx,4)
  acdb3c:	mov    0x18(%r14),%rax
  acdb40:	movb   $0x0,(%rax,%rcx,1)
  acdb44:	jmp    acbb83 <ir_typed_emit_function+0x3e3>
  acdb49:	mov    $0x3,%dl
  acdb4b:	test   %r14,%r14
  acdb4e:	jne    acdabc <ir_typed_emit_function+0x231c>
  acdb54:	jmp    acdafc <ir_typed_emit_function+0x235c>
  acdb56:	add    $0xfd,%dl
  acdb59:	cmp    $0x2,%dl
  acdb5c:	setb   %dl
  acdb5f:	test   %r14,%r14
  acdb62:	jne    acdabc <ir_typed_emit_function+0x231c>
  acdb68:	jmp    acdafc <ir_typed_emit_function+0x235c>
  acdb6a:	inc    %eax
  acdb6c:	test   %r14,%r14
  acdb6f:	je     acdb79 <ir_typed_emit_function+0x23d9>
  acdb71:	mov    0x40(%r14),%rcx
  acdb75:	mov    %r15d,(%rcx,%rax,4)
  acdb79:	mov    0xa8(%rsp),%rdx
  acdb81:	mov    0xb8(%rsp),%rax
  acdb89:	mov    0xb0(%rsp),%rcx
  acdb91:	add    0xa0(%rsp),%rcx
  acdb99:	inc    %rdx
  acdb9c:	mov    %r15,(%rax)
  acdb9f:	mov    %rdx,0x8(%rax)
  acdba3:	mov    %r9,0x10(%rax)
  acdba7:	mov    0x20(%rsp),%r9
  acdbac:	mov    0x78(%rsp),%rdx
  acdbb1:	mov    %r9,0x18(%rax)
  acdbb5:	mov    %rcx,0x20(%rax)
  acdbb9:	mov    %r8,0x28(%rax)
  acdbbd:	mov    %rdi,0x30(%rax)
  acdbc1:	mov    %rsi,0x38(%rax)
  acdbc5:	mov    %rdx,0x40(%rax)
  acdbc9:	add    $0xe8,%rsp
  acdbd0:	pop    %rbx
  acdbd1:	pop    %r12
  acdbd3:	pop    %r13
  acdbd5:	pop    %r14
  acdbd7:	pop    %r15
  acdbd9:	pop    %rbp
  acdbda:	ret
  acdbdb:	mov    $0x1,%eax
  acdbe0:	xor    %r8d,%r8d
  acdbe3:	xor    %edi,%edi
  acdbe5:	movq   $0x0,0x20(%rsp)
  acdbee:	xor    %r9d,%r9d
  acdbf1:	xor    %esi,%esi
  acdbf3:	test   %r14,%r14
  acdbf6:	jne    acdb71 <ir_typed_emit_function+0x23d1>
  acdbfc:	jmp    acdb79 <ir_typed_emit_function+0x23d9>
