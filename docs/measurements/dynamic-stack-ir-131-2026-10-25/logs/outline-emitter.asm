
outline/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000acb7e0 <ir_typed_emit_function>:
  acb7e0:	push   %rbp
  acb7e1:	push   %r15
  acb7e3:	push   %r14
  acb7e5:	push   %r13
  acb7e7:	push   %r12
  acb7e9:	push   %rbx
  acb7ea:	sub    $0xd8,%rsp
  acb7f1:	mov    0x10(%rcx),%eax
  acb7f4:	mov    %rdi,0xb8(%rsp)
  acb7fc:	mov    %rcx,0x40(%rsp)
  acb801:	mov    0x2c(%rcx),%ecx
  acb804:	mov    0x30(%rsi),%edi
  acb807:	mov    0x128(%rsp),%r14
  acb80f:	mov    %r9,0x90(%rsp)
  acb817:	mov    %r8,0xc8(%rsp)
  acb81f:	mov    %rsi,0x10(%rsp)
  acb824:	mov    %edx,0x54(%rsp)
  acb828:	mov    %rax,0xa8(%rsp)
  acb830:	mov    0x34(%rsi),%eax
  acb833:	mov    %rcx,0xb0(%rsp)
  acb83b:	mov    %rdi,0xa0(%rsp)
  acb843:	mov    %rax,0x80(%rsp)
  acb84b:	lea    (%rcx,%rdi,1),%eax
  acb84e:	test   %r14,%r14
  acb851:	je     acb9bf <ir_typed_emit_function+0x1df>
  acb857:	mov    0x40(%r14),%rcx
  acb85b:	movl   $0x0,(%rcx)
  acb861:	mov    %dl,0xbc(%r14)
  acb868:	test   %eax,%eax
  acb86a:	je     acb9d5 <ir_typed_emit_function+0x1f5>
  acb870:	mov    $0x1,%ecx
  acb875:	lea    -0x4ec13c(%rip),%rdx        # 5df740 <tier0_class_bytes.bytes>
  acb87c:	lea    -0x4ec153(%rip),%rbx        # 5df730 <ir_typed_types>
  acb883:	mov    %eax,%ebp
  acb885:	xor    %eax,%eax
  acb887:	jmp    acb8db <ir_typed_emit_function+0xfb>
  acb889:	mov    0x90(%rsi),%r10
  acb890:	movzbl (%r10,%rax,1),%r10d
  acb895:	shlx   %r10d,%ecx,%r11d
  acb89a:	mov    0x10(%rsp),%rsi
  acb89f:	movzbl %r8b,%r8d
  acb8a3:	movzbl (%r8,%rbx,1),%r8d
  acb8a8:	mov    0x28(%rsi),%r10
  acb8ac:	movzbl (%r10,%rax,1),%r10d
  acb8b1:	and    $0x1,%r10b
  acb8b5:	mov    0x10(%rsp),%rsi
  acb8ba:	inc    %rax
  acb8bd:	mov    %r9,(%rdi)
  acb8c0:	mov    %r11d,0x8(%rdi)
  acb8c4:	mov    %r8b,0xc(%rdi)
  acb8c8:	mov    %r10b,0xd(%rdi)
  acb8cc:	movw   $0x0,0xe(%rdi)
  acb8d2:	cmp    %rbp,%rax
  acb8d5:	je     acb9d7 <ir_typed_emit_function+0x1f7>
  acb8db:	mov    (%r14),%rdi
  acb8de:	mov    $0x8,%r8b
  acb8e1:	movb   $0x28,(%rdi,%rax,1)
  acb8e5:	mov    0x8(%r14),%rdi
  acb8e9:	movb   $0xa,(%rdi,%rax,1)
  acb8ed:	mov    0x20(%r14),%rdi
  acb8f1:	mov    %eax,(%rdi,%rax,4)
  acb8f4:	mov    0x28(%r14),%rdi
  acb8f8:	movl   $0xffffffff,(%rdi,%rax,4)
  acb8ff:	mov    0x30(%r14),%rdi
  acb903:	movl   $0xffffffff,(%rdi,%rax,4)
  acb90a:	mov    0x18(%r14),%rdi
  acb90e:	movb   $0x0,(%rdi,%rax,1)
  acb912:	mov    0x30(%rsi),%r10d
  acb916:	cmp    %r10,%rax
  acb919:	jae    acb950 <ir_typed_emit_function+0x170>
  acb91b:	mov    0x20(%rsi),%r8
  acb91f:	mov    0x88(%rsi),%rdi
  acb926:	movzbl (%r8,%rax,1),%r8d
  acb92b:	test   %rdi,%rdi
  acb92e:	je     acb950 <ir_typed_emit_function+0x170>
  acb930:	mov    (%rdi,%rax,4),%r9d
  acb934:	mov    %rax,%rdi
  acb937:	shl    $0x4,%rdi
  acb93b:	add    0x70(%r14),%rdi
  acb93f:	test   %r9,%r9
  acb942:	jne    acb889 <ir_typed_emit_function+0xa9>
  acb948:	jmp    acb95b <ir_typed_emit_function+0x17b>
  acb94a:	nopw   0x0(%rax,%rax,1)
  acb950:	mov    %rax,%rdi
  acb953:	shl    $0x4,%rdi
  acb957:	add    0x70(%r14),%rdi
  acb95b:	movzbl %r8b,%r11d
  acb95f:	and    $0xf,%r11d
  acb963:	movzbl (%r11,%rdx,1),%r9d
  acb968:	cmp    $0x4,%r9d
  acb96c:	je     acb9a0 <ir_typed_emit_function+0x1c0>
  acb96e:	mov    $0x3,%r15d
  acb974:	cmp    $0x8,%r9d
  acb978:	je     acb989 <ir_typed_emit_function+0x1a9>
  acb97a:	add    $0xfd,%r11b
  acb97e:	xor    %r15d,%r15d
  acb981:	cmp    $0x2,%r11b
  acb985:	setb   %r15b
  acb989:	shlx   %r15d,%ecx,%r11d
  acb98e:	cmp    %r10,%rax
  acb991:	jb     acb89a <ir_typed_emit_function+0xba>
  acb997:	jmp    acb9b4 <ir_typed_emit_function+0x1d4>
  acb999:	nopl   0x0(%rax)
  acb9a0:	mov    $0x2,%r15d
  acb9a6:	shlx   %r15d,%ecx,%r11d
  acb9ab:	cmp    %r10,%rax
  acb9ae:	jb     acb89a <ir_typed_emit_function+0xba>
  acb9b4:	mov    $0x4,%r10b
  acb9b7:	xor    %r8d,%r8d
  acb9ba:	jmp    acb8b5 <ir_typed_emit_function+0xd5>
  acb9bf:	test   %eax,%eax
  acb9c1:	je     acbaed <ir_typed_emit_function+0x30d>
  acb9c7:	mov    %eax,%ebp
  acb9c9:	mov    0x34(%rsi),%eax
  acb9cc:	test   %eax,%eax
  acb9ce:	jne    acb9e2 <ir_typed_emit_function+0x202>
  acb9d0:	jmp    acbaff <ir_typed_emit_function+0x31f>
  acb9d5:	xor    %ebp,%ebp
  acb9d7:	mov    0x34(%rsi),%eax
  acb9da:	test   %eax,%eax
  acb9dc:	je     acbaff <ir_typed_emit_function+0x31f>
  acb9e2:	lea    -0x4ec2a9(%rip),%rcx        # 5df740 <tier0_class_bytes.bytes>
  acb9e9:	lea    -0x4ec2c0(%rip),%rdx        # 5df730 <ir_typed_types>
  acb9f0:	xor    %eax,%eax
  acb9f2:	jmp    acba13 <ir_typed_emit_function+0x233>
  acb9f4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  acba00:	mov    0x34(%rsi),%edi
  acba03:	add    $0x2,%rbp
  acba07:	inc    %rax
  acba0a:	cmp    %rdi,%rax
  acba0d:	jae    acbaff <ir_typed_emit_function+0x31f>
  acba13:	mov    0x20(%rsi),%rdi
  acba17:	movzbl (%rdi,%rax,1),%r10d
  acba1c:	test   %r14,%r14
  acba1f:	je     acba6d <ir_typed_emit_function+0x28d>
  acba21:	movzbl (%r10,%rdx,1),%edi
  acba26:	mov    0xb0(%r14),%r8
  acba2d:	mov    %ebp,%r9d
  acba30:	mov    %dil,(%r8,%rax,1)
  acba34:	mov    (%r14),%r8
  acba37:	movb   $0x3,(%r8,%r9,1)
  acba3c:	mov    0x8(%r14),%r8
  acba40:	mov    %dil,(%r8,%r9,1)
  acba44:	mov    0x20(%r14),%rdi
  acba48:	mov    %eax,(%rdi,%r9,4)
  acba4c:	mov    0x28(%r14),%rdi
  acba50:	movl   $0xffffffff,(%rdi,%r9,4)
  acba58:	mov    0x30(%r14),%rdi
  acba5c:	movl   $0xffffffff,(%rdi,%r9,4)
  acba64:	mov    0x18(%r14),%rdi
  acba68:	movb   $0x0,(%rdi,%r9,1)
  acba6d:	and    $0xf,%r10d
  acba71:	movzbl (%r10,%rcx,1),%r8d
  acba76:	cmp    $0x4,%r8d
  acba7a:	je     acbaa0 <ir_typed_emit_function+0x2c0>
  acba7c:	mov    $0x3,%dil
  acba7f:	cmp    $0x8,%r8d
  acba83:	je     acba91 <ir_typed_emit_function+0x2b1>
  acba85:	add    $0xfd,%r10b
  acba89:	cmp    $0x2,%r10b
  acba8d:	setb   %dil
  acba91:	test   %r14,%r14
  acba94:	jne    acbaac <ir_typed_emit_function+0x2cc>
  acba96:	jmp    acba00 <ir_typed_emit_function+0x220>
  acba9b:	nopl   0x0(%rax,%rax,1)
  acbaa0:	mov    $0x2,%dil
  acbaa3:	test   %r14,%r14
  acbaa6:	je     acba00 <ir_typed_emit_function+0x220>
  acbaac:	mov    (%r14),%r8
  acbaaf:	lea    0x1(%rbp),%r9
  acbab3:	mov    %r9d,%r9d
  acbab6:	movb   $0x2c,(%r8,%r9,1)
  acbabb:	mov    0x8(%r14),%r8
  acbabf:	movb   $0x0,(%r8,%r9,1)
  acbac4:	mov    0x20(%r14),%r8
  acbac8:	mov    %eax,(%r8,%r9,4)
  acbacc:	mov    0x28(%r14),%r8
  acbad0:	mov    %ebp,(%r8,%r9,4)
  acbad4:	mov    0x30(%r14),%r8
  acbad8:	movl   $0xffffffff,(%r8,%r9,4)
  acbae0:	mov    0x18(%r14),%r8
  acbae4:	mov    %dil,(%r8,%r9,1)
  acbae8:	jmp    acba00 <ir_typed_emit_function+0x220>
  acbaed:	mov    0x80(%rsp),%rax
  acbaf5:	xor    %ebp,%ebp
  acbaf7:	test   %eax,%eax
  acbaf9:	jne    acb9e2 <ir_typed_emit_function+0x202>
  acbaff:	test   %r14,%r14
  acbb02:	je     acbb3e <ir_typed_emit_function+0x35e>
  acbb04:	mov    (%r14),%rax
  acbb07:	mov    %ebp,%ecx
  acbb09:	movb   $0x30,(%rax,%rcx,1)
  acbb0d:	mov    0x8(%r14),%rax
  acbb11:	movb   $0x0,(%rax,%rcx,1)
  acbb15:	mov    0x20(%r14),%rax
  acbb19:	movl   $0x1,(%rax,%rcx,4)
  acbb20:	mov    0x28(%r14),%rax
  acbb24:	movl   $0xffffffff,(%rax,%rcx,4)
  acbb2b:	mov    0x30(%r14),%rax
  acbb2f:	movl   $0xffffffff,(%rax,%rcx,4)
  acbb36:	mov    0x18(%r14),%rax
  acbb3a:	movb   $0x0,(%rax,%rcx,1)
  acbb3e:	mov    0x40(%rsp),%rax
  acbb43:	inc    %rbp
  acbb46:	cmpl   $0x0,0x10(%rax)
  acbb4a:	je     acdb12 <ir_typed_emit_function+0x2332>
  acbb50:	mov    0x118(%rsp),%rax
  acbb58:	xor    %ecx,%ecx
  acbb5a:	xor    %r12d,%r12d
  acbb5d:	xor    %r9d,%r9d
  acbb60:	movq   $0x0,0x28(%rsp)
  acbb69:	movq   $0x0,0x60(%rsp)
  acbb72:	movq   $0x0,0x18(%rsp)
  acbb7b:	add    $0xc,%rax
  acbb7f:	mov    %rax,0xc0(%rsp)
  acbb87:	jmp    acbbea <ir_typed_emit_function+0x40a>
  acbb89:	mov    $0xffffffff,%eax
  acbb8e:	test   %r14,%r14
  acbb91:	je     acbbc9 <ir_typed_emit_function+0x3e9>
  acbb93:	mov    (%r14),%rcx
  acbb96:	mov    %ebp,%edx
  acbb98:	movb   $0x33,(%rcx,%rdx,1)
  acbb9c:	mov    0x8(%r14),%rcx
  acbba0:	movb   $0x0,(%rcx,%rdx,1)
  acbba4:	mov    0x20(%r14),%rcx
  acbba8:	mov    %eax,(%rcx,%rdx,4)
  acbbab:	mov    0x28(%r14),%rax
  acbbaf:	movl   $0xffffffff,(%rax,%rdx,4)
  acbbb6:	mov    0x30(%r14),%rax
  acbbba:	movl   $0xffffffff,(%rax,%rdx,4)
  acbbc1:	mov    0x18(%r14),%rax
  acbbc5:	movb   $0x0,(%rax,%rdx,1)
  acbbc9:	inc    %rbp
  acbbcc:	mov    0x40(%rsp),%rax
  acbbd1:	mov    0xd0(%rsp),%rcx
  acbbd9:	mov    0x48(%rsp),%r9
  acbbde:	mov    0x10(%rax),%eax
  acbbe1:	cmp    %rax,%rcx
  acbbe4:	jae    acda95 <ir_typed_emit_function+0x22b5>
  acbbea:	mov    %rcx,%rdi
  acbbed:	mov    %r9,0x48(%rsp)
  acbbf2:	mov    %r12,%rbx
  acbbf5:	test   %r14,%r14
  acbbf8:	je     acbc10 <ir_typed_emit_function+0x430>
  acbbfa:	mov    0x40(%r14),%rax
  acbbfe:	lea    0x1(%rdi),%rsi
  acbc02:	mov    %ebp,0x4(%rax,%rdi,4)
  acbc06:	jmp    acbc14 <ir_typed_emit_function+0x434>
  acbc08:	nopl   0x0(%rax,%rax,1)
  acbc10:	lea    0x1(%rdi),%rsi
  acbc14:	mov    0x40(%rsp),%rdx
  acbc19:	mov    %rsi,0xd0(%rsp)
  acbc21:	mov    %rdi,0x68(%rsp)
  acbc26:	mov    (%rdx),%rax
  acbc29:	mov    0x18(%rdx),%rcx
  acbc2d:	mov    (%rcx,%rdi,4),%r15d
  acbc31:	mov    (%rax,%rdi,4),%r13d
  acbc35:	mov    (%rax,%rsi,4),%eax
  acbc38:	mov    0xc8(%rsp),%rsi
  acbc40:	mov    0x20(%rdx),%rcx
  acbc44:	test   %r15,%r15
  acbc47:	mov    (%rsi),%rsi
  acbc4a:	mov    %rax,0x98(%rsp)
  acbc52:	mov    %r15,%rdx
  acbc55:	setne  %r12b
  acbc59:	add    (%rcx,%rdi,8),%rsi
  acbc5d:	mov    0x120(%rsp),%rdi
  acbc65:	call   7c43a0 <memcpy@plt>
  acbc6a:	mov    0x10(%rsp),%r11
  acbc6f:	mov    %r13,0x70(%rsp)
  acbc74:	cmp    0x18(%r11),%r13d
  acbc78:	setb   %al
  acbc7b:	and    %r12b,%al
  acbc7e:	cmp    $0x1,%al
  acbc80:	jne    acbca0 <ir_typed_emit_function+0x4c0>
  acbc82:	mov    %rbx,%r12
  acbc85:	cmp    $0x1,%r15d
  acbc89:	jne    acbcb0 <ir_typed_emit_function+0x4d0>
  acbc8b:	mov    0x118(%rsp),%rbx
  acbc93:	xor    %eax,%eax
  acbc95:	jmp    acbe6d <ir_typed_emit_function+0x68d>
  acbc9a:	nopw   0x0(%rax,%rax,1)
  acbca0:	mov    %rbx,%r12
  acbca3:	mov    0x118(%rsp),%rbx
  acbcab:	jmp    acbef6 <ir_typed_emit_function+0x716>
  acbcb0:	mov    0x118(%rsp),%rbx
  acbcb8:	mov    %r15d,%ecx
  acbcbb:	and    $0xfffffffe,%ecx
  acbcbe:	xor    %eax,%eax
  acbcc0:	jmp    acbd35 <ir_typed_emit_function+0x555>
  acbcc2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  acbcd0:	mov    0x70(%rsp),%r13
  acbcd5:	mov    $0x3,%r8b
  acbcd8:	test   %r14,%r14
  acbcdb:	je     acbd22 <ir_typed_emit_function+0x542>
  acbcdd:	mov    (%r14),%r10
  acbce0:	lea    0x1(%rbp,%rax,1),%r9
  acbce5:	lea    0x1(%rax,%rdi,1),%rdi
  acbcea:	mov    %r9d,%r9d
  acbced:	movb   $0x2b,(%r10,%r9,1)
  acbcf2:	mov    0x8(%r14),%r10
  acbcf6:	mov    %sil,(%r10,%r9,1)
  acbcfa:	mov    0x20(%r14),%rsi
  acbcfe:	mov    %edi,(%rsi,%r9,4)
  acbd02:	mov    0x28(%r14),%rsi
  acbd06:	movl   $0xffffffff,(%rsi,%r9,4)
  acbd0e:	mov    0x30(%r14),%rsi
  acbd12:	movl   $0xffffffff,(%rsi,%r9,4)
  acbd1a:	mov    0x18(%r14),%rsi
  acbd1e:	mov    %r8b,(%rsi,%r9,1)
  acbd22:	inc    %edx
  acbd24:	mov    %edx,0x4(%rbx,%rax,4)
  acbd28:	add    $0x2,%rax
  acbd2c:	cmp    %rax,%rcx
  acbd2f:	je     acbe60 <ir_typed_emit_function+0x680>
  acbd35:	mov    0x120(%rsp),%rdx
  acbd3d:	lea    -0x4ec604(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  acbd44:	movzbl (%rdx,%rax,1),%edi
  acbd48:	mov    %edi,%edx
  acbd4a:	and    $0xf,%edx
  acbd4d:	movzbl (%rdx,%rsi,1),%r8d
  acbd52:	cmp    $0x4,%r8d
  acbd56:	je     acbe20 <ir_typed_emit_function+0x640>
  acbd5c:	mov    $0x3,%sil
  acbd5f:	cmp    $0x8,%r8d
  acbd63:	je     acbd6f <ir_typed_emit_function+0x58f>
  acbd65:	add    $0xfd,%dl
  acbd68:	cmp    $0x2,%dl
  acbd6b:	setb   %sil
  acbd6f:	lea    0x0(%rbp,%rax,1),%rdx
  acbd74:	lea    -0x4ec64b(%rip),%r13        # 5df730 <ir_typed_types>
  acbd7b:	test   %r14,%r14
  acbd7e:	je     acbdc7 <ir_typed_emit_function+0x5e7>
  acbd80:	mov    (%r14),%r9
  acbd83:	mov    0x30(%r11),%r8d
  acbd87:	movzbl (%rdi,%r13,1),%edi
  acbd8c:	mov    %edx,%r10d
  acbd8f:	movb   $0x2b,(%r9,%r10,1)
  acbd94:	add    %rax,%r8
  acbd97:	mov    0x8(%r14),%r9
  acbd9b:	mov    %dil,(%r9,%r10,1)
  acbd9f:	mov    0x20(%r14),%rdi
  acbda3:	mov    %r8d,(%rdi,%r10,4)
  acbda7:	mov    0x28(%r14),%rdi
  acbdab:	movl   $0xffffffff,(%rdi,%r10,4)
  acbdb3:	mov    0x30(%r14),%rdi
  acbdb7:	movl   $0xffffffff,(%rdi,%r10,4)
  acbdbf:	mov    0x18(%r14),%rdi
  acbdc3:	mov    %sil,(%rdi,%r10,1)
  acbdc7:	mov    0x120(%rsp),%rsi
  acbdcf:	mov    %edx,(%rbx,%rax,4)
  acbdd2:	lea    -0x4ec699(%rip),%r9        # 5df740 <tier0_class_bytes.bytes>
  acbdd9:	mov    0x30(%r11),%edi
  acbddd:	movzbl 0x1(%rsi,%rax,1),%r8d
  acbde3:	movzbl (%r8,%r13,1),%esi
  acbde8:	and    $0xf,%r8d
  acbdec:	movzbl (%r8,%r9,1),%r9d
  acbdf1:	cmp    $0x8,%r9d
  acbdf5:	je     acbcd0 <ir_typed_emit_function+0x4f0>
  acbdfb:	mov    0x70(%rsp),%r13
  acbe00:	cmp    $0x4,%r9d
  acbe04:	jne    acbe40 <ir_typed_emit_function+0x660>
  acbe06:	mov    $0x2,%r8b
  acbe09:	test   %r14,%r14
  acbe0c:	jne    acbcdd <ir_typed_emit_function+0x4fd>
  acbe12:	jmp    acbd22 <ir_typed_emit_function+0x542>
  acbe17:	nopw   0x0(%rax,%rax,1)
  acbe20:	mov    $0x2,%sil
  acbe23:	lea    0x0(%rbp,%rax,1),%rdx
  acbe28:	lea    -0x4ec6ff(%rip),%r13        # 5df730 <ir_typed_types>
  acbe2f:	test   %r14,%r14
  acbe32:	jne    acbd80 <ir_typed_emit_function+0x5a0>
  acbe38:	jmp    acbdc7 <ir_typed_emit_function+0x5e7>
  acbe3a:	nopw   0x0(%rax,%rax,1)
  acbe40:	add    $0xfd,%r8b
  acbe44:	cmp    $0x2,%r8b
  acbe48:	setb   %r8b
  acbe4c:	test   %r14,%r14
  acbe4f:	jne    acbcdd <ir_typed_emit_function+0x4fd>
  acbe55:	jmp    acbd22 <ir_typed_emit_function+0x542>
  acbe5a:	nopw   0x0(%rax,%rax,1)
  acbe60:	add    %rax,%rbp
  acbe63:	test   $0x1,%r15b
  acbe67:	je     acbef6 <ir_typed_emit_function+0x716>
  acbe6d:	mov    0x120(%rsp),%rcx
  acbe75:	lea    -0x4ec73c(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  acbe7c:	movzbl (%rcx,%rax,1),%ecx
  acbe80:	mov    %ecx,%edx
  acbe82:	and    $0xf,%edx
  acbe85:	movzbl (%rdx,%rsi,1),%esi
  acbe89:	cmp    $0x8,%esi
  acbe8c:	je     acd825 <ir_typed_emit_function+0x2045>
  acbe92:	cmp    $0x4,%esi
  acbe95:	jne    acd835 <ir_typed_emit_function+0x2055>
  acbe9b:	mov    $0x2,%dl
  acbe9d:	test   %r14,%r14
  acbea0:	je     acbeee <ir_typed_emit_function+0x70e>
  acbea2:	mov    (%r14),%rdi
  acbea5:	lea    -0x4ec77c(%rip),%rsi        # 5df730 <ir_typed_types>
  acbeac:	mov    %ebp,%r8d
  acbeaf:	movzbl (%rcx,%rsi,1),%ecx
  acbeb3:	mov    0x30(%r11),%esi
  acbeb7:	movb   $0x2b,(%rdi,%r8,1)
  acbebc:	mov    0x8(%r14),%rdi
  acbec0:	add    %eax,%esi
  acbec2:	mov    %cl,(%rdi,%r8,1)
  acbec6:	mov    0x20(%r14),%rcx
  acbeca:	mov    %esi,(%rcx,%r8,4)
  acbece:	mov    0x28(%r14),%rcx
  acbed2:	movl   $0xffffffff,(%rcx,%r8,4)
  acbeda:	mov    0x30(%r14),%rcx
  acbede:	movl   $0xffffffff,(%rcx,%r8,4)
  acbee6:	mov    0x18(%r14),%rcx
  acbeea:	mov    %dl,(%rcx,%r8,1)
  acbeee:	mov    %ebp,%ecx
  acbef0:	inc    %rbp
  acbef3:	mov    %ecx,(%rbx,%rax,4)
  acbef6:	cmp    0x98(%rsp),%r13d
  acbefe:	jae    acd790 <ir_typed_emit_function+0x1fb0>
  acbf04:	mov    0x68(%rsp),%rax
  acbf09:	movl   $0x0,0x24(%rsp)
  acbf11:	add    $0x2,%eax
  acbf14:	mov    %eax,0x7c(%rsp)
  acbf18:	jmp    acbf34 <ir_typed_emit_function+0x754>
  acbf1a:	dec    %r10d
  acbf1d:	nopl   (%rax)
  acbf20:	mov    %r10d,%r15d
  acbf23:	inc    %r13
  acbf26:	cmp    0x98(%rsp),%r13
  acbf2e:	je     acd780 <ir_typed_emit_function+0x1fa0>
  acbf34:	mov    (%r11),%rax
  acbf37:	mov    0x8(%r11),%rcx
  acbf3b:	mov    0x110(%rsp),%rdi
  acbf43:	mov    %r15d,%r10d
  acbf46:	movzbl (%rax,%r13,1),%esi
  acbf4b:	movzbl (%rcx,%r13,1),%eax
  acbf50:	movzbl (%rdi,%r13,1),%edx
  acbf55:	movzbl %al,%r8d
  acbf59:	lea    -0x1(%rsi),%edi
  acbf5c:	cmp    $0x2b,%edi
  acbf5f:	ja     acc513 <ir_typed_emit_function+0xd33>
  acbf65:	mov    0x10(%r11),%rcx
  acbf69:	lea    -0x5d978c(%rip),%r9        # 4f27e4 <check_builtin_atomic_rmw_test_clang.native_source+0x6e24>
  acbf70:	movslq (%r9,%rdi,4),%rdi
  acbf74:	mov    (%rcx,%r13,8),%rcx
  acbf78:	add    %r9,%rdi
  acbf7b:	jmp    *%rdi
  acbf7d:	mov    %esi,%eax
  acbf7f:	and    $0xfe,%al
  acbf81:	cmp    $0x1e,%al
  acbf83:	jne    acbfc2 <ir_typed_emit_function+0x7e2>
  acbf85:	lea    -0x1(%r10),%r15d
  acbf89:	and    $0xf,%r8d
  acbf8d:	lea    -0x4ec854(%rip),%rdx        # 5df740 <tier0_class_bytes.bytes>
  acbf94:	mov    (%rbx,%r15,4),%eax
  acbf98:	movzbl (%r8,%rdx,1),%edi
  acbf9d:	cmp    $0x4,%edi
  acbfa0:	je     acc900 <ir_typed_emit_function+0x1120>
  acbfa6:	mov    $0x3,%dl
  acbfa8:	cmp    $0x8,%edi
  acbfab:	je     acc00d <ir_typed_emit_function+0x82d>
  acbfad:	add    $0xfd,%r8b
  acbfb1:	cmp    $0x2,%r8b
  acbfb5:	setb   %dl
  acbfb8:	test   %r14,%r14
  acbfbb:	jne    acc012 <ir_typed_emit_function+0x832>
  acbfbd:	jmp    acc04a <ir_typed_emit_function+0x86a>
  acbfc2:	test   %r14,%r14
  acbfc5:	je     acbffd <ir_typed_emit_function+0x81d>
  acbfc7:	mov    (%r14),%rax
  acbfca:	mov    %ebp,%edx
  acbfcc:	movb   $0x29,(%rax,%rdx,1)
  acbfd0:	mov    0x8(%r14),%rax
  acbfd4:	movb   $0xa,(%rax,%rdx,1)
  acbfd8:	mov    0x20(%r14),%rax
  acbfdc:	mov    %ecx,(%rax,%rdx,4)
  acbfdf:	mov    0x28(%r14),%rax
  acbfe3:	movl   $0xffffffff,(%rax,%rdx,4)
  acbfea:	mov    0x30(%r14),%rax
  acbfee:	movl   $0xffffffff,(%rax,%rdx,4)
  acbff5:	mov    0x18(%r14),%rax
  acbff9:	movb   $0x0,(%rax,%rdx,1)
  acbffd:	lea    -0x1(%r10),%r15d
  acc001:	mov    %rbp,%rcx
  acc004:	inc    %rbp
  acc007:	xor    %edx,%edx
  acc009:	mov    (%rbx,%r15,4),%eax
  acc00d:	test   %r14,%r14
  acc010:	je     acc04a <ir_typed_emit_function+0x86a>
  acc012:	mov    (%r14),%rdi
  acc015:	mov    %ebp,%r8d
  acc018:	movb   $0x2c,(%rdi,%r8,1)
  acc01d:	mov    0x8(%r14),%rdi
  acc021:	movb   $0x0,(%rdi,%r8,1)
  acc026:	mov    0x20(%r14),%rdi
  acc02a:	mov    %ecx,(%rdi,%r8,4)
  acc02e:	mov    0x28(%r14),%rcx
  acc032:	mov    %eax,(%rcx,%r8,4)
  acc036:	mov    0x30(%r14),%rax
  acc03a:	movl   $0xffffffff,(%rax,%r8,4)
  acc042:	mov    0x18(%r14),%rax
  acc046:	mov    %dl,(%rax,%r8,1)
  acc04a:	inc    %rbp
  acc04d:	cmp    $0x21,%esi
  acc050:	je     acbf23 <ir_typed_emit_function+0x743>
  acc056:	cmp    $0x1f,%esi
  acc059:	je     acbf23 <ir_typed_emit_function+0x743>
  acc05f:	jmp    acbf20 <ir_typed_emit_function+0x740>
  acc064:	test   %r14,%r14
  acc067:	je     acc8be <ir_typed_emit_function+0x10de>
  acc06d:	mov    (%r14),%r8
  acc070:	mov    %ebp,%r9d
  acc073:	mov    %ebp,%edi
  acc075:	inc    %rbp
  acc078:	movb   $0x29,(%r8,%r9,1)
  acc07d:	mov    0x8(%r14),%r8
  acc081:	movb   $0xa,(%r8,%r9,1)
  acc086:	mov    0x20(%r14),%r8
  acc08a:	mov    %ecx,(%r8,%r9,4)
  acc08e:	mov    %ebp,%r8d
  acc091:	mov    0x28(%r14),%rcx
  acc095:	movl   $0xffffffff,(%rcx,%r9,4)
  acc09d:	mov    0x30(%r14),%rcx
  acc0a1:	movl   $0xffffffff,(%rcx,%r9,4)
  acc0a9:	mov    0x18(%r14),%rcx
  acc0ad:	movb   $0x0,(%rcx,%r9,1)
  acc0b2:	xor    %ecx,%ecx
  acc0b4:	cmp    $0x4,%esi
  acc0b7:	mov    (%r14),%rsi
  acc0ba:	sete   %cl
  acc0bd:	lea    0x26(%rcx,%rcx,4),%ecx
  acc0c1:	mov    %cl,(%rsi,%r8,1)
  acc0c5:	mov    0x8(%r14),%rcx
  acc0c9:	mov    %dl,(%rcx,%r8,1)
  acc0cd:	mov    0x20(%r14),%rcx
  acc0d1:	mov    %edi,(%rcx,%r8,4)
  acc0d5:	mov    0x28(%r14),%rcx
  acc0d9:	movl   $0xffffffff,(%rcx,%r8,4)
  acc0e1:	mov    0x30(%r14),%rcx
  acc0e5:	movl   $0xffffffff,(%rcx,%r8,4)
  acc0ed:	mov    0x18(%r14),%rcx
  acc0f1:	movb   $0x0,(%rcx,%r8,1)
  acc0f6:	jmp    acd16a <ir_typed_emit_function+0x198a>
  acc0fb:	lea    -0x1(%r10),%r15d
  acc0ff:	add    $0xfffffffe,%r10d
  acc103:	mov    (%rbx,%r15,4),%ecx
  acc107:	test   %r14,%r14
  acc10a:	je     acc8c6 <ir_typed_emit_function+0x10e6>
  acc110:	mov    (%r14),%rdi
  acc113:	mov    (%rbx,%r10,4),%edx
  acc117:	mov    %ebp,%r9d
  acc11a:	mov    %ebp,%r8d
  acc11d:	inc    %rbp
  acc120:	movb   $0x25,(%rdi,%r9,1)
  acc125:	mov    0x8(%r14),%rdi
  acc129:	movb   $0xa,(%rdi,%r9,1)
  acc12e:	mov    0x20(%r14),%rdi
  acc132:	mov    %edx,(%rdi,%r9,4)
  acc136:	mov    %ebp,%edi
  acc138:	mov    0x28(%r14),%rdx
  acc13c:	movl   $0xffffffff,(%rdx,%r9,4)
  acc144:	mov    0x30(%r14),%rdx
  acc148:	movl   $0xffffffff,(%rdx,%r9,4)
  acc150:	mov    0x18(%r14),%rdx
  acc154:	movb   $0x0,(%rdx,%r9,1)
  acc159:	mov    (%r14),%rdx
  acc15c:	movb   $0x2c,(%rdx,%rdi,1)
  acc160:	mov    0x8(%r14),%rdx
  acc164:	movb   $0x0,(%rdx,%rdi,1)
  acc168:	mov    0x20(%r14),%rdx
  acc16c:	mov    %r8d,(%rdx,%rdi,4)
  acc170:	mov    0x28(%r14),%rdx
  acc174:	mov    %ecx,(%rdx,%rdi,4)
  acc177:	mov    0x30(%r14),%rdx
  acc17b:	movl   $0xffffffff,(%rdx,%rdi,4)
  acc182:	mov    0x18(%r14),%rdx
  acc186:	movb   $0x0,(%rdx,%rdi,1)
  acc18a:	inc    %rbp
  acc18d:	cmp    $0x1c,%esi
  acc190:	jne    acbf20 <ir_typed_emit_function+0x740>
  acc196:	jmp    acd529 <ir_typed_emit_function+0x1d49>
  acc19b:	lea    -0x1(%r10),%eax
  acc19f:	test   %r14,%r14
  acc1a2:	je     acc1ef <ir_typed_emit_function+0xa0f>
  acc1a4:	mov    0x90(%rsp),%rsi
  acc1ac:	mov    (%r14),%rdi
  acc1af:	mov    (%rbx,%rax,4),%ecx
  acc1b2:	mov    %ebp,%r8d
  acc1b5:	movzbl (%rsi,%r13,1),%esi
  acc1ba:	mov    %sil,(%rdi,%r8,1)
  acc1be:	mov    0x8(%r14),%rsi
  acc1c2:	mov    %dl,(%rsi,%r8,1)
  acc1c6:	mov    0x20(%r14),%rdx
  acc1ca:	mov    %ecx,(%rdx,%r8,4)
  acc1ce:	mov    0x28(%r14),%rcx
  acc1d2:	movl   $0xffffffff,(%rcx,%r8,4)
  acc1da:	mov    0x30(%r14),%rcx
  acc1de:	movl   $0xffffffff,(%rcx,%r8,4)
  acc1e6:	mov    0x18(%r14),%rcx
  acc1ea:	movb   $0x0,(%rcx,%r8,1)
  acc1ef:	mov    %ebp,%ecx
  acc1f1:	inc    %rbp
  acc1f4:	mov    %ecx,(%rbx,%rax,4)
  acc1f7:	jmp    acbf20 <ir_typed_emit_function+0x740>
  acc1fc:	dec    %r10d
  acc1ff:	mov    %r12,(%rsp)
  acc203:	test   %r14,%r14
  acc206:	je     acc8da <ir_typed_emit_function+0x10fa>
  acc20c:	mov    0x28(%rsp),%r8
  acc211:	mov    0x60(%r14),%rax
  acc215:	vxorps %xmm0,%xmm0,%xmm0
  acc219:	lea    0x1(%rbp),%r12
  acc21d:	mov    %r12d,%r9d
  acc220:	mov    %r8d,%edi
  acc223:	shl    $0x4,%rdi
  acc227:	vmovups %xmm0,(%rax,%rdi,1)
  acc22c:	mov    %ebp,%edi
  acc22e:	mov    (%r14),%rax
  acc231:	movb   $0x1,(%rax,%rdi,1)
  acc235:	mov    0x8(%r14),%rax
  acc239:	mov    %dl,(%rax,%rdi,1)
  acc23c:	mov    0x20(%r14),%rax
  acc240:	mov    %r8d,(%rax,%rdi,4)
  acc244:	mov    %r10d,%r8d
  acc247:	mov    0x28(%r14),%rax
  acc24b:	movl   $0xffffffff,(%rax,%rdi,4)
  acc252:	mov    0x30(%r14),%rax
  acc256:	movl   $0xffffffff,(%rax,%rdi,4)
  acc25d:	mov    0x18(%r14),%rax
  acc261:	movb   $0x0,(%rax,%rdi,1)
  acc265:	mov    (%r14),%rdi
  acc268:	mov    (%rbx,%r8,4),%edx
  acc26c:	movb   $0x19,(%rdi,%r9,1)
  acc271:	mov    0x8(%r14),%rdi
  acc275:	movb   $0x1,(%rdi,%r9,1)
  acc27a:	mov    0x20(%r14),%rdi
  acc27e:	mov    %edx,(%rdi,%r9,4)
  acc282:	mov    0x28(%r14),%rdx
  acc286:	mov    %ebp,(%rdx,%r9,4)
  acc28a:	mov    0x30(%r14),%rdx
  acc28e:	movl   $0x1,(%rdx,%r9,4)
  acc296:	mov    0x18(%r14),%rdx
  acc29a:	movb   $0x0,(%rdx,%r9,1)
  acc29f:	lea    0x1(%r12),%r9
  acc2a4:	test   %r10d,%r10d
  acc2a7:	jne    acc8ef <ir_typed_emit_function+0x110f>
  acc2ad:	jmp    accb24 <ir_typed_emit_function+0x1344>
  acc2b2:	test   %r10d,%r10d
  acc2b5:	je     accd90 <ir_typed_emit_function+0x15b0>
  acc2bb:	mov    0x30(%r11),%eax
  acc2bf:	cmp    $0x1,%r10d
  acc2c3:	jne    accb93 <ir_typed_emit_function+0x13b3>
  acc2c9:	xor    %edx,%edx
  acc2cb:	jmp    accd1c <ir_typed_emit_function+0x153c>
  acc2d0:	test   %al,%al
  acc2d2:	je     acce99 <ir_typed_emit_function+0x16b9>
  acc2d8:	dec    %r10d
  acc2db:	mov    (%rbx,%r10,4),%eax
  acc2df:	mov    %r10d,%r15d
  acc2e2:	test   %r14,%r14
  acc2e5:	je     acc31d <ir_typed_emit_function+0xb3d>
  acc2e7:	mov    (%r14),%rcx
  acc2ea:	mov    %ebp,%edx
  acc2ec:	movb   $0x33,(%rcx,%rdx,1)
  acc2f0:	mov    0x8(%r14),%rcx
  acc2f4:	movb   $0x0,(%rcx,%rdx,1)
  acc2f8:	mov    0x20(%r14),%rcx
  acc2fc:	mov    %eax,(%rcx,%rdx,4)
  acc2ff:	mov    0x28(%r14),%rax
  acc303:	movl   $0xffffffff,(%rax,%rdx,4)
  acc30a:	mov    0x30(%r14),%rax
  acc30e:	movl   $0xffffffff,(%rax,%rdx,4)
  acc315:	mov    0x18(%r14),%rax
  acc319:	movb   $0x0,(%rax,%rdx,1)
  acc31d:	mov    $0x1,%al
  acc31f:	inc    %rbp
  acc322:	mov    %eax,0x24(%rsp)
  acc326:	jmp    acbf23 <ir_typed_emit_function+0x743>
  acc32b:	lea    -0x2(%r10),%r15d
  acc32f:	test   %r14,%r14
  acc332:	je     acceaf <ir_typed_emit_function+0x16cf>
  acc338:	mov    (%r14),%rsi
  acc33b:	dec    %r10d
  acc33e:	mov    %r15d,%eax
  acc341:	mov    (%rbx,%rax,4),%eax
  acc344:	mov    %ebp,%edi
  acc346:	mov    (%rbx,%r10,4),%edx
  acc34a:	movb   $0x25,(%rsi,%rdi,1)
  acc34e:	mov    0x8(%r14),%rsi
  acc352:	movb   $0xa,(%rsi,%rdi,1)
  acc356:	mov    0x20(%r14),%rsi
  acc35a:	mov    %eax,(%rsi,%rdi,4)
  acc35d:	mov    0x28(%r14),%rax
  acc361:	movl   $0xffffffff,(%rax,%rdi,4)
  acc368:	mov    0x30(%r14),%rax
  acc36c:	movl   $0xffffffff,(%rax,%rdi,4)
  acc373:	mov    0x18(%r14),%rax
  acc377:	movb   $0x0,(%rax,%rdi,1)
  acc37b:	lea    0x1(%rbp),%rax
  acc37f:	mov    (%r14),%rsi
  acc382:	mov    %eax,%edi
  acc384:	movb   $0x25,(%rsi,%rdi,1)
  acc388:	mov    0x8(%r14),%rsi
  acc38c:	movb   $0xa,(%rsi,%rdi,1)
  acc390:	mov    0x20(%r14),%rsi
  acc394:	mov    %edx,(%rsi,%rdi,4)
  acc397:	mov    0x28(%r14),%rdx
  acc39b:	movl   $0xffffffff,(%rdx,%rdi,4)
  acc3a2:	mov    0x30(%r14),%rdx
  acc3a6:	movl   $0xffffffff,(%rdx,%rdi,4)
  acc3ad:	mov    0x18(%r14),%rdx
  acc3b1:	movb   $0x0,(%rdx,%rdi,1)
  acc3b5:	lea    0x1(%rax),%rdx
  acc3b9:	test   %rcx,%rcx
  acc3bc:	jne    accec0 <ir_typed_emit_function+0x16e0>
  acc3c2:	jmp    acd117 <ir_typed_emit_function+0x1937>
  acc3c7:	mov    0x58(%r11),%rsi
  acc3cb:	mov    %r12,(%rsp)
  acc3cf:	mov    %ecx,%edi
  acc3d1:	lea    -0x4ecca8(%rip),%r15        # 5df730 <ir_typed_types>
  acc3d8:	sub    (%rsi,%rcx,4),%r10d
  acc3dc:	mov    (%rsi,%rdi,4),%ecx
  acc3df:	mov    0x60(%rsp),%rsi
  acc3e4:	lea    (%rbx,%r10,4),%r12
  acc3e8:	mov    0x48(%rsp),%rbx
  acc3ed:	test   %r14,%r14
  acc3f0:	je     acd3fa <ir_typed_emit_function+0x1c1a>
  acc3f6:	mov    0x60(%r11),%r9
  acc3fa:	mov    %r10,0x30(%rsp)
  acc3ff:	mov    %edx,%r10d
  acc402:	mov    0x90(%r14),%r8
  acc409:	mov    (%rsp),%rdx
  acc40d:	mov    %esi,%esi
  acc40f:	lea    (%rsi,%rsi,4),%rsi
  acc413:	mov    %r10b,0xf(%rsp)
  acc418:	cmpb   $0x0,(%r9,%rdi,1)
  acc41d:	mov    %ebx,(%r8,%rsi,4)
  acc421:	mov    %ecx,0x4(%r8,%rsi,4)
  acc426:	mov    %rcx,%r9
  acc429:	mov    %edx,0x8(%r8,%rsi,4)
  acc42e:	mov    %r9d,0xc(%r8,%rsi,4)
  acc433:	mov    %r10b,0x10(%r8,%rsi,4)
  acc438:	mov    %r9,0x58(%rsp)
  acc43d:	setne  0x11(%r8,%rsi,4)
  acc443:	movw   $0x0,0x12(%r8,%rsi,4)
  acc44b:	test   %r9d,%r9d
  acc44e:	je     acd3ae <ir_typed_emit_function+0x1bce>
  acc454:	mov    0x58(%rsp),%rcx
  acc459:	mov    %r12,0x88(%rsp)
  acc461:	mov    %ecx,%r8d
  acc464:	and    $0x3,%r8d
  acc468:	cmp    $0x4,%ecx
  acc46b:	jae    acd21a <ir_typed_emit_function+0x1a3a>
  acc471:	mov    0x88(%rsp),%r12
  acc479:	mov    (%rsp),%rdx
  acc47d:	xor    %r9d,%r9d
  acc480:	jmp    acd370 <ir_typed_emit_function+0x1b90>
  acc485:	lea    -0x1(%r10),%ecx
  acc489:	test   %r14,%r14
  acc48c:	je     acd11f <ir_typed_emit_function+0x193f>
  acc492:	mov    (%r14),%rdi
  acc495:	mov    (%rbx,%rcx,4),%esi
  acc498:	mov    %ebp,%r9d
  acc49b:	mov    %ebp,%r8d
  acc49e:	inc    %rbp
  acc4a1:	movb   $0x25,(%rdi,%r9,1)
  acc4a6:	mov    0x8(%r14),%rdi
  acc4aa:	movb   $0xa,(%rdi,%r9,1)
  acc4af:	mov    0x20(%r14),%rdi
  acc4b3:	mov    %esi,(%rdi,%r9,4)
  acc4b7:	mov    %ebp,%edi
  acc4b9:	mov    0x28(%r14),%rsi
  acc4bd:	movl   $0xffffffff,(%rsi,%r9,4)
  acc4c5:	mov    0x30(%r14),%rsi
  acc4c9:	movl   $0xffffffff,(%rsi,%r9,4)
  acc4d1:	mov    0x18(%r14),%rsi
  acc4d5:	movb   $0x0,(%rsi,%r9,1)
  acc4da:	mov    (%r14),%rsi
  acc4dd:	movb   $0x2b,(%rsi,%rdi,1)
  acc4e1:	mov    0x8(%r14),%rsi
  acc4e5:	mov    %dl,(%rsi,%rdi,1)
  acc4e8:	mov    0x20(%r14),%rdx
  acc4ec:	mov    %r8d,(%rdx,%rdi,4)
  acc4f0:	mov    0x28(%r14),%rdx
  acc4f4:	movl   $0xffffffff,(%rdx,%rdi,4)
  acc4fb:	mov    0x30(%r14),%rdx
  acc4ff:	movl   $0xffffffff,(%rdx,%rdi,4)
  acc506:	mov    0x18(%r14),%rdx
  acc50a:	movb   $0x0,(%rdx,%rdi,1)
  acc50e:	jmp    acd59a <ir_typed_emit_function+0x1dba>
  acc513:	lea    -0x1(%r10),%r15d
  acc517:	add    $0xfffffffe,%r10d
  acc51b:	lea    -0x16(%rsi),%r9d
  acc51f:	mov    (%rbx,%r15,4),%edi
  acc523:	mov    (%rbx,%r10,4),%ecx
  acc527:	cmp    $0x5,%r9b
  acc52b:	ja     accdea <ir_typed_emit_function+0x160a>
  acc531:	test   %r14,%r14
  acc534:	je     acd43d <ir_typed_emit_function+0x1c5d>
  acc53a:	mov    0x120(%rsp),%rdx
  acc542:	mov    %edi,0x38(%rsp)
  acc546:	mov    %ecx,%edi
  acc548:	mov    %r12,%rcx
  acc54b:	mov    %r10,%r12
  acc54e:	movzbl (%rdx,%r10,1),%edx
  acc553:	mov    $0x0,%r10d
  acc559:	mov    %edx,%r8d
  acc55c:	and    $0xf9,%r8b
  acc560:	cmp    $0x1,%r8b
  acc564:	setne  %r8b
  acc568:	add    $0xf7,%dl
  acc56b:	cmp    $0x18,%sil
  acc56f:	setae  %r9b
  acc573:	cmp    $0x2,%dl
  acc576:	setae  %dl
  acc579:	adc    $0x19,%r10b
  acc57d:	and    %r8b,%dl
  acc580:	mov    %ebp,%r8d
  acc583:	and    %r9b,%dl
  acc586:	mov    %ebp,%r9d
  acc589:	inc    %rbp
  acc58c:	movzbl %dl,%edx
  acc58f:	lea    -0x16(%rsi,%rdx,4),%edx
  acc593:	mov    (%r14),%rsi
  acc596:	mov    %r10b,(%rsi,%r9,1)
  acc59a:	mov    %r12,%r10
  acc59d:	mov    %rcx,%r12
  acc5a0:	mov    0x8(%r14),%rsi
  acc5a4:	movb   $0x1,(%rsi,%r9,1)
  acc5a9:	mov    0x20(%r14),%rsi
  acc5ad:	mov    %edi,(%rsi,%r9,4)
  acc5b1:	mov    0x38(%rsp),%esi
  acc5b5:	mov    0x28(%r14),%rcx
  acc5b9:	mov    %esi,(%rcx,%r9,4)
  acc5bd:	mov    0x30(%r14),%rcx
  acc5c1:	mov    %edx,(%rcx,%r9,4)
  acc5c5:	mov    %ebp,%edx
  acc5c7:	mov    0x18(%r14),%rcx
  acc5cb:	movb   $0x0,(%rcx,%r9,1)
  acc5d0:	mov    (%r14),%rcx
  acc5d3:	movb   $0x1d,(%rcx,%rdx,1)
  acc5d7:	mov    0x8(%r14),%rcx
  acc5db:	movb   $0x4,(%rcx,%rdx,1)
  acc5df:	mov    0x20(%r14),%rcx
  acc5e3:	mov    %r8d,(%rcx,%rdx,4)
  acc5e7:	mov    0x28(%r14),%rcx
  acc5eb:	movl   $0xffffffff,(%rcx,%rdx,4)
  acc5f2:	mov    0x30(%r14),%rcx
  acc5f6:	movl   $0xffffffff,(%rcx,%rdx,4)
  acc5fd:	mov    0x18(%r14),%rcx
  acc601:	movb   $0x0,(%rcx,%rdx,1)
  acc605:	jmp    acd75c <ir_typed_emit_function+0x1f7c>
  acc60a:	mov    0x120(%rsp),%rsi
  acc612:	lea    -0x1(%r10),%ecx
  acc616:	mov    (%rbx,%rcx,4),%edx
  acc619:	movzbl (%rsi,%rcx,1),%r9d
  acc61e:	lea    -0x4ecef5(%rip),%rsi        # 5df730 <ir_typed_types>
  acc625:	movzbl (%r9,%rsi,1),%edi
  acc62a:	movzbl (%r8,%rsi,1),%esi
  acc62f:	cmp    %sil,%dil
  acc632:	je     acd59f <ir_typed_emit_function+0x1dbf>
  acc638:	mov    %r12,(%rsp)
  acc63c:	mov    %r10,%r12
  acc63f:	movzbl %sil,%r8d
  acc643:	lea    -0x1(%rdi),%r10d
  acc647:	cmp    $0x5,%r10b
  acc64b:	ja     acd1e1 <ir_typed_emit_function+0x1a01>
  acc651:	lea    -0x1(%rsi),%r10d
  acc655:	cmp    $0x5,%r10b
  acc659:	ja     acd541 <ir_typed_emit_function+0x1d61>
  acc65f:	lea    -0x5d1156(%rip),%r10        # 4fb510 <ir_type_bits>
  acc666:	movzwl (%r10,%rdi,2),%edi
  acc66b:	lea    -0x5d1162(%rip),%r10        # 4fb510 <ir_type_bits>
  acc672:	mov    %di,0x38(%rsp)
  acc677:	mov    $0x1c,%dil
  acc67a:	movzwl 0x38(%rsp),%r15d
  acc680:	cmp    (%r10,%r8,2),%r15w
  acc685:	mov    %r12,%r10
  acc688:	ja     acd556 <ir_typed_emit_function+0x1d76>
  acc68e:	and    $0xf9,%r9b
  acc692:	cmp    $0x1,%r9b
  acc696:	sete   %dil
  acc69a:	add    $0x1d,%dil
  acc69e:	jmp    acd556 <ir_typed_emit_function+0x1d76>
  acc6a3:	test   %r14,%r14
  acc6a6:	je     acd16a <ir_typed_emit_function+0x198a>
  acc6ac:	mov    (%r14),%rdx
  acc6af:	mov    %ebp,%esi
  acc6b1:	movb   $0x26,(%rdx,%rsi,1)
  acc6b5:	mov    0x8(%r14),%rdx
  acc6b9:	movb   $0x5,(%rdx,%rsi,1)
  acc6bd:	mov    0x20(%r14),%rdx
  acc6c1:	mov    %ecx,(%rdx,%rsi,4)
  acc6c4:	mov    0x28(%r14),%rcx
  acc6c8:	movl   $0xffffffff,(%rcx,%rsi,4)
  acc6cf:	mov    0x30(%r14),%rcx
  acc6d3:	movl   $0xffffffff,(%rcx,%rsi,4)
  acc6da:	mov    0x18(%r14),%rcx
  acc6de:	movb   $0x0,(%rcx,%rsi,1)
  acc6e2:	jmp    acd16a <ir_typed_emit_function+0x198a>
  acc6e7:	test   %r14,%r14
  acc6ea:	je     acc759 <ir_typed_emit_function+0xf79>
  acc6ec:	movzbl %dl,%esi
  acc6ef:	mov    $0x9f,%edi
  acc6f4:	bt     %rsi,%rdi
  acc6f8:	jae    acc70a <ir_typed_emit_function+0xf2a>
  acc6fa:	lea    -0x5d11f1(%rip),%rdi        # 4fb510 <ir_type_bits>
  acc701:	movzbl (%rdi,%rsi,2),%esi
  acc705:	bzhi   %rsi,%rcx,%rcx
  acc70a:	mov    0x28(%rsp),%rdi
  acc70f:	mov    %edi,%esi
  acc711:	shl    $0x4,%rsi
  acc715:	add    0x60(%r14),%rsi
  acc719:	mov    %rcx,(%rsi)
  acc71c:	movq   $0x0,0x8(%rsi)
  acc724:	mov    %ebp,%esi
  acc726:	mov    (%r14),%rcx
  acc729:	movb   $0x1,(%rcx,%rsi,1)
  acc72d:	mov    0x8(%r14),%rcx
  acc731:	mov    %dl,(%rcx,%rsi,1)
  acc734:	mov    0x20(%r14),%rcx
  acc738:	mov    %edi,(%rcx,%rsi,4)
  acc73b:	mov    0x28(%r14),%rcx
  acc73f:	movl   $0xffffffff,(%rcx,%rsi,4)
  acc746:	mov    0x30(%r14),%rcx
  acc74a:	movl   $0xffffffff,(%rcx,%rsi,4)
  acc751:	mov    0x18(%r14),%rcx
  acc755:	movb   $0x0,(%rcx,%rsi,1)
  acc759:	incq   0x28(%rsp)
  acc75e:	jmp    acd16a <ir_typed_emit_function+0x198a>
  acc763:	and    $0xf,%r8d
  acc767:	lea    -0x4ed02e(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  acc76e:	movzbl (%r8,%rsi,1),%edi
  acc773:	cmp    $0x4,%edi
  acc776:	je     acd127 <ir_typed_emit_function+0x1947>
  acc77c:	mov    $0x3,%sil
  acc77f:	cmp    $0x8,%edi
  acc782:	je     acc790 <ir_typed_emit_function+0xfb0>
  acc784:	add    $0xfd,%r8b
  acc788:	cmp    $0x2,%r8b
  acc78c:	setb   %sil
  acc790:	test   %r14,%r14
  acc793:	jne    acd12f <ir_typed_emit_function+0x194f>
  acc799:	jmp    acd16a <ir_typed_emit_function+0x198a>
  acc79e:	lea    -0x1(%r10),%ecx
  acc7a2:	mov    (%rbx,%rcx,4),%ecx
  acc7a5:	jmp    acd16f <ir_typed_emit_function+0x198f>
  acc7aa:	lea    -0x1(%r10),%r15d
  acc7ae:	add    $0xfffffffe,%r10d
  acc7b2:	mov    (%rbx,%r15,4),%edx
  acc7b6:	test   %r14,%r14
  acc7b9:	je     acc7fc <ir_typed_emit_function+0x101c>
  acc7bb:	mov    (%r14),%rdi
  acc7be:	mov    (%rbx,%r10,4),%esi
  acc7c2:	mov    %ebp,%r8d
  acc7c5:	movb   $0x25,(%rdi,%r8,1)
  acc7ca:	mov    0x8(%r14),%rdi
  acc7ce:	movb   $0xa,(%rdi,%r8,1)
  acc7d3:	mov    0x20(%r14),%rdi
  acc7d7:	mov    %esi,(%rdi,%r8,4)
  acc7db:	mov    0x28(%r14),%rsi
  acc7df:	movl   $0xffffffff,(%rsi,%r8,4)
  acc7e7:	mov    0x30(%r14),%rsi
  acc7eb:	movl   $0xffffffff,(%rsi,%r8,4)
  acc7f3:	mov    0x18(%r14),%rsi
  acc7f7:	movb   $0x0,(%rsi,%r8,1)
  acc7fc:	popcnt %rcx,%rdi
  acc801:	lea    0x1(%rbp),%rsi
  acc805:	cmp    $0x1,%edi
  acc808:	sete   %dil
  acc80c:	test   $0xf,%cl
  acc80f:	setne  %r8b
  acc813:	test   %r8b,%dil
  acc816:	jne    acd461 <ir_typed_emit_function+0x1c81>
  acc81c:	test   %r14,%r14
  acc81f:	je     acd445 <ir_typed_emit_function+0x1c65>
  acc825:	mov    0x28(%rsp),%r9
  acc82a:	mov    0x60(%r14),%rdi
  acc82e:	mov    %r9d,%r8d
  acc831:	shl    $0x4,%r8
  acc835:	mov    %rcx,(%rdi,%r8,1)
  acc839:	movq   $0x0,0x8(%rdi,%r8,1)
  acc842:	mov    %esi,%edi
  acc844:	mov    (%r14),%rcx
  acc847:	movb   $0x1,(%rcx,%rdi,1)
  acc84b:	mov    0x8(%r14),%rcx
  acc84f:	movb   $0x5,(%rcx,%rdi,1)
  acc853:	mov    0x20(%r14),%rcx
  acc857:	mov    %r9d,(%rcx,%rdi,4)
  acc85b:	mov    0x28(%r14),%rcx
  acc85f:	movl   $0xffffffff,(%rcx,%rdi,4)
  acc866:	mov    0x30(%r14),%rcx
  acc86a:	movl   $0xffffffff,(%rcx,%rdi,4)
  acc871:	mov    0x18(%r14),%rcx
  acc875:	movb   $0x0,(%rcx,%rdi,1)
  acc879:	lea    0x2(%rbp),%rcx
  acc87d:	mov    (%r14),%rdi
  acc880:	mov    %ecx,%r8d
  acc883:	movb   $0x7,(%rdi,%r8,1)
  acc888:	mov    0x8(%r14),%rdi
  acc88c:	movb   $0x5,(%rdi,%r8,1)
  acc891:	mov    0x20(%r14),%rdi
  acc895:	mov    %edx,(%rdi,%r8,4)
  acc899:	mov    0x28(%r14),%rdx
  acc89d:	mov    %esi,(%rdx,%r8,4)
  acc8a1:	mov    0x30(%r14),%rdx
  acc8a5:	movl   $0xffffffff,(%rdx,%r8,4)
  acc8ad:	mov    0x18(%r14),%rdx
  acc8b1:	movb   $0x0,(%rdx,%r8,1)
  acc8b6:	mov    %rcx,%rdx
  acc8b9:	jmp    acd44e <ir_typed_emit_function+0x1c6e>
  acc8be:	inc    %rbp
  acc8c1:	jmp    acd16a <ir_typed_emit_function+0x198a>
  acc8c6:	inc    %rbp
  acc8c9:	inc    %rbp
  acc8cc:	cmp    $0x1c,%esi
  acc8cf:	jne    acbf20 <ir_typed_emit_function+0x740>
  acc8d5:	jmp    acd529 <ir_typed_emit_function+0x1d49>
  acc8da:	lea    0x1(%rbp),%r12
  acc8de:	mov    %r10d,%r8d
  acc8e1:	lea    0x1(%r12),%r9
  acc8e6:	test   %r10d,%r10d
  acc8e9:	je     accb24 <ir_typed_emit_function+0x1344>
  acc8ef:	mov    0x30(%r11),%edx
  acc8f3:	cmp    $0x1,%r8d
  acc8f7:	jne    acc910 <ir_typed_emit_function+0x1130>
  acc8f9:	xor    %edi,%edi
  acc8fb:	jmp    accaa3 <ir_typed_emit_function+0x12c3>
  acc900:	mov    $0x2,%dl
  acc902:	test   %r14,%r14
  acc905:	jne    acc012 <ir_typed_emit_function+0x832>
  acc90b:	jmp    acc04a <ir_typed_emit_function+0x86a>
  acc910:	mov    %r8d,%r9d
  acc913:	and    $0xfffffffe,%r9d
  acc917:	xor    %edi,%edi
  acc919:	mov    %r10,0x30(%rsp)
  acc91e:	jmp    acc97e <ir_typed_emit_function+0x119e>
  acc920:	mov    $0x3,%r11b
  acc923:	test   %r14,%r14
  acc926:	je     acc971 <ir_typed_emit_function+0x1191>
  acc928:	mov    (%r14),%r15
  acc92b:	lea    0x3(%rbp,%rdi,1),%rax
  acc930:	lea    0x1(%rdx,%rdi,1),%rbx
  acc935:	mov    %eax,%eax
  acc937:	movb   $0x2c,(%r15,%rax,1)
  acc93c:	mov    0x8(%r14),%r15
  acc940:	movb   $0x0,(%r15,%rax,1)
  acc945:	mov    0x20(%r14),%r15
  acc949:	mov    %ebx,(%r15,%rax,4)
  acc94d:	mov    0x28(%r14),%rbx
  acc951:	mov    %r10d,(%rbx,%rax,4)
  acc955:	mov    0x118(%rsp),%rbx
  acc95d:	mov    0x30(%r14),%r10
  acc961:	movl   $0xffffffff,(%r10,%rax,4)
  acc969:	mov    0x18(%r14),%r10
  acc96d:	mov    %r11b,(%r10,%rax,1)
  acc971:	add    $0x2,%rdi
  acc975:	cmp    %rdi,%r9
  acc978:	je     acca8a <ir_typed_emit_function+0x12aa>
  acc97e:	mov    0x120(%rsp),%rax
  acc986:	movzbl (%rax,%rdi,1),%r11d
  acc98b:	lea    -0x4ed252(%rip),%rax        # 5df740 <tier0_class_bytes.bytes>
  acc992:	and    $0xf,%r11d
  acc996:	movzbl (%r11,%rax,1),%r15d
  acc99b:	cmp    $0x4,%r15d
  acc99f:	je     acca60 <ir_typed_emit_function+0x1280>
  acc9a5:	mov    $0x3,%r10b
  acc9a8:	cmp    $0x8,%r15d
  acc9ac:	je     acc9ba <ir_typed_emit_function+0x11da>
  acc9ae:	add    $0xfd,%r11b
  acc9b2:	cmp    $0x2,%r11b
  acc9b6:	setb   %r10b
  acc9ba:	test   %r14,%r14
  acc9bd:	je     acca14 <ir_typed_emit_function+0x1234>
  acc9bf:	mov    0x118(%rsp),%rax
  acc9c7:	lea    0x2(%rbp,%rdi,1),%r11
  acc9cc:	lea    (%rdx,%rdi,1),%rbx
  acc9d0:	mov    %r11d,%r11d
  acc9d3:	mov    (%rax,%rdi,4),%r15d
  acc9d7:	mov    (%r14),%rax
  acc9da:	movb   $0x2c,(%rax,%r11,1)
  acc9df:	mov    0x8(%r14),%rax
  acc9e3:	movb   $0x0,(%rax,%r11,1)
  acc9e8:	mov    0x20(%r14),%rax
  acc9ec:	mov    %ebx,(%rax,%r11,4)
  acc9f0:	mov    0x118(%rsp),%rbx
  acc9f8:	mov    0x28(%r14),%rax
  acc9fc:	mov    %r15d,(%rax,%r11,4)
  acca00:	mov    0x30(%r14),%rax
  acca04:	movl   $0xffffffff,(%rax,%r11,4)
  acca0c:	mov    0x18(%r14),%rax
  acca10:	mov    %r10b,(%rax,%r11,1)
  acca14:	mov    0x120(%rsp),%rax
  acca1c:	mov    0x4(%rbx,%rdi,4),%r10d
  acca21:	movzbl 0x1(%rax,%rdi,1),%r11d
  acca27:	lea    -0x4ed2ee(%rip),%rax        # 5df740 <tier0_class_bytes.bytes>
  acca2e:	and    $0xf,%r11d
  acca32:	movzbl (%r11,%rax,1),%r15d
  acca37:	cmp    $0x8,%r15d
  acca3b:	je     acc920 <ir_typed_emit_function+0x1140>
  acca41:	cmp    $0x4,%r15d
  acca45:	jne    acca70 <ir_typed_emit_function+0x1290>
  acca47:	mov    $0x2,%r11b
  acca4a:	test   %r14,%r14
  acca4d:	jne    acc928 <ir_typed_emit_function+0x1148>
  acca53:	jmp    acc971 <ir_typed_emit_function+0x1191>
  acca58:	nopl   0x0(%rax,%rax,1)
  acca60:	mov    $0x2,%r10b
  acca63:	test   %r14,%r14
  acca66:	jne    acc9bf <ir_typed_emit_function+0x11df>
  acca6c:	jmp    acca14 <ir_typed_emit_function+0x1234>
  acca6e:	xchg   %ax,%ax
  acca70:	add    $0xfd,%r11b
  acca74:	cmp    $0x2,%r11b
  acca78:	setb   %r11b
  acca7c:	test   %r14,%r14
  acca7f:	jne    acc928 <ir_typed_emit_function+0x1148>
  acca85:	jmp    acc971 <ir_typed_emit_function+0x1191>
  acca8a:	mov    0x10(%rsp),%r11
  acca8f:	mov    0x30(%rsp),%r10
  acca94:	lea    0x2(%rbp,%rdi,1),%r9
  acca99:	test   $0x1,%r8b
  acca9d:	je     accb24 <ir_typed_emit_function+0x1344>
  accaa3:	mov    0x120(%rsp),%rax
  accaab:	mov    %r10,%r15
  accaae:	movzbl (%rax,%rdi,1),%r8d
  accab3:	lea    -0x4ed37a(%rip),%rax        # 5df740 <tier0_class_bytes.bytes>
  accaba:	and    $0xf,%r8d
  accabe:	movzbl (%r8,%rax,1),%r10d
  accac3:	cmp    $0x8,%r10d
  accac7:	je     acd18b <ir_typed_emit_function+0x19ab>
  accacd:	cmp    $0x4,%r10d
  accad1:	jne    acd1ad <ir_typed_emit_function+0x19cd>
  accad7:	mov    $0x2,%r8b
  accada:	test   %r14,%r14
  accadd:	je     accb1e <ir_typed_emit_function+0x133e>
  accadf:	mov    (%r14),%rbp
  accae2:	lea    (%rdi,%rdx,1),%eax
  accae5:	mov    (%rbx,%rdi,4),%edx
  accae8:	mov    %r9d,%r10d
  accaeb:	movb   $0x2c,0x0(%rbp,%r10,1)
  accaf1:	mov    0x8(%r14),%rdi
  accaf5:	movb   $0x0,(%rdi,%r10,1)
  accafa:	mov    0x20(%r14),%rdi
  accafe:	mov    %eax,(%rdi,%r10,4)
  accb02:	mov    0x28(%r14),%rax
  accb06:	mov    %edx,(%rax,%r10,4)
  accb0a:	mov    0x30(%r14),%rax
  accb0e:	movl   $0xffffffff,(%rax,%r10,4)
  accb16:	mov    0x18(%r14),%rax
  accb1a:	mov    %r8b,(%rax,%r10,1)
  accb1e:	inc    %r9
  accb21:	mov    %r15,%r10
  accb24:	test   %r14,%r14
  accb27:	je     accb76 <ir_typed_emit_function+0x1396>
  accb29:	mov    0x40(%rsp),%rax
  accb2e:	mov    (%r14),%rdi
  accb31:	mov    0x7c(%rsp),%edx
  accb35:	mov    0x8(%rax),%rax
  accb39:	mov    (%rax,%rcx,4),%eax
  accb3c:	inc    %eax
  accb3e:	cmp    $0x25,%esi
  accb41:	mov    %r9d,%esi
  accb44:	movb   $0x31,(%rdi,%rsi,1)
  accb48:	mov    %eax,%ecx
  accb4a:	cmove  %edx,%ecx
  accb4d:	cmovne %edx,%eax
  accb50:	mov    0x8(%r14),%rdx
  accb54:	movb   $0x0,(%rdx,%rsi,1)
  accb58:	mov    0x20(%r14),%rdx
  accb5c:	mov    %r12d,(%rdx,%rsi,4)
  accb60:	mov    0x28(%r14),%rdx
  accb64:	mov    %eax,(%rdx,%rsi,4)
  accb67:	mov    0x30(%r14),%rax
  accb6b:	mov    %ecx,(%rax,%rsi,4)
  accb6e:	mov    0x18(%r14),%rax
  accb72:	movb   $0x0,(%rax,%rsi,1)
  accb76:	incq   0x28(%rsp)
  accb7b:	mov    (%rsp),%r12
  accb7f:	inc    %r9
  accb82:	mov    $0x1,%al
  accb84:	mov    %r10d,%r15d
  accb87:	mov    %eax,0x24(%rsp)
  accb8b:	mov    %r9,%rbp
  accb8e:	jmp    acbf23 <ir_typed_emit_function+0x743>
  accb93:	mov    %r10d,%esi
  accb96:	mov    %esi,%edi
  accb98:	and    $0xfffffffe,%edi
  accb9b:	mov    %r12,(%rsp)
  accb9f:	mov    %r10,%r12
  accba2:	mov    %eax,%r8d
  accba5:	xor    %edx,%edx
  accba7:	jmp    accc15 <ir_typed_emit_function+0x1435>
  accba9:	nopl   0x0(%rax)
  accbb0:	mov    $0x3,%r10b
  accbb3:	test   %r14,%r14
  accbb6:	je     accc00 <ir_typed_emit_function+0x1420>
  accbb8:	mov    (%r14),%r15
  accbbb:	lea    0x1(%rbp),%r11
  accbbf:	lea    0x1(%r8),%ebx
  accbc3:	mov    %r11d,%r11d
  accbc6:	movb   $0x2c,(%r15,%r11,1)
  accbcb:	mov    0x8(%r14),%r15
  accbcf:	movb   $0x0,(%r15,%r11,1)
  accbd4:	mov    0x20(%r14),%r15
  accbd8:	mov    %ebx,(%r15,%r11,4)
  accbdc:	mov    0x28(%r14),%rbx
  accbe0:	mov    %r9d,(%rbx,%r11,4)
  accbe4:	mov    0x118(%rsp),%rbx
  accbec:	mov    0x30(%r14),%r9
  accbf0:	movl   $0xffffffff,(%r9,%r11,4)
  accbf8:	mov    0x18(%r14),%r9
  accbfc:	mov    %r10b,(%r9,%r11,1)
  accc00:	add    $0x2,%rbp
  accc04:	add    $0x2,%rdx
  accc08:	add    $0x2,%r8d
  accc0c:	cmp    %rdx,%rdi
  accc0f:	je     accd0a <ir_typed_emit_function+0x152a>
  accc15:	mov    0x120(%rsp),%r9
  accc1d:	movzbl (%r9,%rdx,1),%r10d
  accc22:	lea    -0x4ed4e9(%rip),%r9        # 5df740 <tier0_class_bytes.bytes>
  accc29:	and    $0xf,%r10d
  accc2d:	movzbl (%r10,%r9,1),%r11d
  accc32:	cmp    $0x4,%r11d
  accc36:	je     accce0 <ir_typed_emit_function+0x1500>
  accc3c:	mov    $0x3,%r9b
  accc3f:	cmp    $0x8,%r11d
  accc43:	je     accc51 <ir_typed_emit_function+0x1471>
  accc45:	add    $0xfd,%r10b
  accc49:	cmp    $0x2,%r10b
  accc4d:	setb   %r9b
  accc51:	test   %r14,%r14
  accc54:	je     accc99 <ir_typed_emit_function+0x14b9>
  accc56:	mov    (%r14),%r11
  accc59:	mov    (%rbx,%rdx,4),%r10d
  accc5d:	mov    %ebp,%ebx
  accc5f:	movb   $0x2c,(%r11,%rbx,1)
  accc64:	mov    0x8(%r14),%r11
  accc68:	movb   $0x0,(%r11,%rbx,1)
  accc6d:	mov    0x20(%r14),%r11
  accc71:	mov    %r8d,(%r11,%rbx,4)
  accc75:	mov    0x28(%r14),%r11
  accc79:	mov    %r10d,(%r11,%rbx,4)
  accc7d:	mov    0x30(%r14),%r10
  accc81:	movl   $0xffffffff,(%r10,%rbx,4)
  accc89:	mov    0x18(%r14),%r10
  accc8d:	mov    %r9b,(%r10,%rbx,1)
  accc91:	mov    0x118(%rsp),%rbx
  accc99:	mov    0x120(%rsp),%r10
  accca1:	lea    -0x4ed568(%rip),%r11        # 5df740 <tier0_class_bytes.bytes>
  accca8:	mov    0x4(%rbx,%rdx,4),%r9d
  acccad:	movzbl 0x1(%r10,%rdx,1),%r10d
  acccb3:	and    $0xf,%r10d
  acccb7:	movzbl (%r10,%r11,1),%r11d
  acccbc:	cmp    $0x8,%r11d
  acccc0:	je     accbb0 <ir_typed_emit_function+0x13d0>
  acccc6:	cmp    $0x4,%r11d
  acccca:	jne    acccf0 <ir_typed_emit_function+0x1510>
  accccc:	mov    $0x2,%r10b
  accccf:	test   %r14,%r14
  acccd2:	jne    accbb8 <ir_typed_emit_function+0x13d8>
  acccd8:	jmp    accc00 <ir_typed_emit_function+0x1420>
  acccdd:	nopl   (%rax)
  accce0:	mov    $0x2,%r9b
  accce3:	test   %r14,%r14
  accce6:	jne    accc56 <ir_typed_emit_function+0x1476>
  acccec:	jmp    accc99 <ir_typed_emit_function+0x14b9>
  acccee:	xchg   %ax,%ax
  acccf0:	add    $0xfd,%r10b
  acccf4:	cmp    $0x2,%r10b
  acccf8:	setb   %r10b
  acccfc:	test   %r14,%r14
  acccff:	jne    accbb8 <ir_typed_emit_function+0x13d8>
  accd05:	jmp    accc00 <ir_typed_emit_function+0x1420>
  accd0a:	mov    %r12,%r10
  accd0d:	mov    0x10(%rsp),%r11
  accd12:	mov    (%rsp),%r12
  accd16:	test   $0x1,%sil
  accd1a:	je     accd90 <ir_typed_emit_function+0x15b0>
  accd1c:	mov    0x120(%rsp),%rsi
  accd24:	lea    -0x4ed5eb(%rip),%rdi        # 5df740 <tier0_class_bytes.bytes>
  accd2b:	movzbl (%rsi,%rdx,1),%esi
  accd2f:	and    $0xf,%esi
  accd32:	movzbl (%rsi,%rdi,1),%edi
  accd36:	cmp    $0x8,%edi
  accd39:	je     acd19c <ir_typed_emit_function+0x19bc>
  accd3f:	cmp    $0x4,%edi
  accd42:	jne    acd1c7 <ir_typed_emit_function+0x19e7>
  accd48:	mov    $0x2,%sil
  accd4b:	test   %r14,%r14
  accd4e:	je     accd8d <ir_typed_emit_function+0x15ad>
  accd50:	mov    (%r14),%rdi
  accd53:	add    %edx,%eax
  accd55:	mov    (%rbx,%rdx,4),%edx
  accd58:	mov    %ebp,%r8d
  accd5b:	movb   $0x2c,(%rdi,%r8,1)
  accd60:	mov    0x8(%r14),%rdi
  accd64:	movb   $0x0,(%rdi,%r8,1)
  accd69:	mov    0x20(%r14),%rdi
  accd6d:	mov    %eax,(%rdi,%r8,4)
  accd71:	mov    0x28(%r14),%rax
  accd75:	mov    %edx,(%rax,%r8,4)
  accd79:	mov    0x30(%r14),%rax
  accd7d:	movl   $0xffffffff,(%rax,%r8,4)
  accd85:	mov    0x18(%r14),%rax
  accd89:	mov    %sil,(%rax,%r8,1)
  accd8d:	inc    %rbp
  accd90:	test   %r14,%r14
  accd93:	je     accdd9 <ir_typed_emit_function+0x15f9>
  accd95:	mov    0x40(%rsp),%rax
  accd9a:	mov    (%r14),%rsi
  accd9d:	mov    %ebp,%edx
  accd9f:	mov    0x8(%rax),%rax
  accda3:	mov    (%rax,%rcx,4),%eax
  accda6:	movb   $0x30,(%rsi,%rdx,1)
  accdaa:	mov    0x8(%r14),%rcx
  accdae:	inc    %eax
  accdb0:	movb   $0x0,(%rcx,%rdx,1)
  accdb4:	mov    0x20(%r14),%rcx
  accdb8:	mov    %eax,(%rcx,%rdx,4)
  accdbb:	mov    0x28(%r14),%rax
  accdbf:	movl   $0xffffffff,(%rax,%rdx,4)
  accdc6:	mov    0x30(%r14),%rax
  accdca:	movl   $0xffffffff,(%rax,%rdx,4)
  accdd1:	mov    0x18(%r14),%rax
  accdd5:	movb   $0x0,(%rax,%rdx,1)
  accdd9:	mov    $0x1,%al
  accddb:	inc    %rbp
  accdde:	mov    %r10d,%r15d
  accde1:	mov    %eax,0x24(%rsp)
  accde5:	jmp    acbf23 <ir_typed_emit_function+0x743>
  accdea:	add    $0xed,%sil
  accdee:	cmp    $0x1,%sil
  accdf2:	ja     acd713 <ir_typed_emit_function+0x1f33>
  accdf8:	mov    0x120(%rsp),%rsi
  acce00:	mov    %r10,0x30(%rsp)
  acce05:	mov    %r12,(%rsp)
  acce09:	movzbl (%rsi,%r15,1),%r10d
  acce0e:	lea    -0x4ed6e5(%rip),%rsi        # 5df730 <ir_typed_types>
  acce15:	movzbl (%r10,%rsi,1),%r9d
  acce1a:	movzbl (%r8,%rsi,1),%esi
  acce1f:	cmp    %sil,%r9b
  acce22:	je     acd70a <ir_typed_emit_function+0x1f2a>
  acce28:	movzbl %sil,%r8d
  acce2c:	lea    -0x1(%r9),%r11d
  acce30:	cmp    $0x5,%r11b
  acce34:	ja     acd5b5 <ir_typed_emit_function+0x1dd5>
  acce3a:	lea    -0x1(%rsi),%r11d
  acce3e:	cmp    $0x5,%r11b
  acce42:	ja     acd6ae <ir_typed_emit_function+0x1ece>
  acce48:	lea    -0x5d193f(%rip),%r11        # 4fb510 <ir_type_bits>
  acce4f:	mov    %r8,0x58(%rsp)
  acce54:	movzwl (%r11,%r9,2),%r8d
  acce59:	mov    0x58(%rsp),%r12
  acce5e:	lea    -0x5d1955(%rip),%r11        # 4fb510 <ir_type_bits>
  acce65:	mov    $0x1c,%r9b
  acce68:	mov    %r8w,0x38(%rsp)
  acce6e:	movzwl 0x38(%rsp),%r8d
  acce74:	cmp    (%r11,%r12,2),%r8w
  acce79:	mov    0x10(%rsp),%r11
  acce7e:	ja     acd6c5 <ir_typed_emit_function+0x1ee5>
  acce84:	and    $0xf9,%r10b
  acce88:	cmp    $0x1,%r10b
  acce8c:	sete   %r9b
  acce90:	add    $0x1d,%r9b
  acce94:	jmp    acd6c5 <ir_typed_emit_function+0x1ee5>
  acce99:	mov    $0xffffffff,%eax
  acce9e:	mov    %r10d,%r15d
  accea1:	test   %r14,%r14
  accea4:	jne    acc2e7 <ir_typed_emit_function+0xb07>
  acceaa:	jmp    acc31d <ir_typed_emit_function+0xb3d>
  acceaf:	lea    0x1(%rbp),%rax
  acceb3:	lea    0x1(%rax),%rdx
  acceb7:	test   %rcx,%rcx
  acceba:	je     acd117 <ir_typed_emit_function+0x1937>
  accec0:	xor    %esi,%esi
  accec2:	jmp    accfa5 <ir_typed_emit_function+0x17c5>
  accec7:	nopw   0x0(%rax,%rax,1)
  acced0:	mov    0x18(%rsp),%r10
  acced5:	mov    0x80(%r14),%rbx
  accedc:	mov    %r10d,%r8d
  accedf:	mov    %r8d,%r11d
  accee2:	shl    $0x4,%r11
  accee6:	inc    %r10
  accee9:	mov    %rsi,(%rbx,%r11,1)
  acceed:	movb   $0x1,0x8(%rbx,%r11,1)
  accef3:	movl   $0x0,0x9(%rbx,%r11,1)
  accefc:	movl   $0x0,0xc(%rbx,%r11,1)
  accf05:	mov    %r10,0x18(%rsp)
  accf0a:	mov    %r9d,%r11d
  accf0d:	mov    (%r14),%r10
  accf10:	movb   $0x2a,(%r10,%r11,1)
  accf15:	mov    0x8(%r14),%r10
  accf19:	movb   $0xa,(%r10,%r11,1)
  accf1e:	mov    0x20(%r14),%r10
  accf22:	mov    %ebp,(%r10,%r11,4)
  accf26:	mov    0x28(%r14),%r10
  accf2a:	movl   $0xffffffff,(%r10,%r11,4)
  accf32:	mov    0x30(%r14),%r10
  accf36:	mov    %r8d,(%r10,%r11,4)
  accf3a:	mov    0x18(%r14),%r8
  accf3e:	movb   $0x0,(%r8,%r11,1)
  accf43:	mov    %r9d,%r8d
  accf46:	mov    %rdx,%r9
  accf49:	add    $0x2,%r9
  accf4d:	mov    (%r14),%r10
  accf50:	mov    %r9d,%r11d
  accf53:	mov    0x118(%rsp),%rbx
  accf5b:	movb   $0x2c,(%r10,%r11,1)
  accf60:	mov    0x8(%r14),%r10
  accf64:	movb   $0x0,(%r10,%r11,1)
  accf69:	mov    0x20(%r14),%r10
  accf6d:	mov    %r8d,(%r10,%r11,4)
  accf71:	mov    0x28(%r14),%r8
  accf75:	mov    %edx,(%r8,%r11,4)
  accf79:	mov    0x30(%r14),%rdx
  accf7d:	movl   $0xffffffff,(%rdx,%r11,4)
  accf85:	mov    0x18(%r14),%rdx
  accf89:	movb   $0x0,(%rdx,%r11,1)
  accf8e:	mov    %r9,%rdx
  accf91:	mov    0x10(%rsp),%r11
  accf96:	inc    %rdx
  accf99:	add    %rdi,%rsi
  accf9c:	cmp    %rcx,%rsi
  accf9f:	jae    acd117 <ir_typed_emit_function+0x1937>
  accfa5:	mov    %rcx,%r8
  accfa8:	sub    %rsi,%r8
  accfab:	cmp    $0x7,%r8
  accfaf:	jbe    acd050 <ir_typed_emit_function+0x1870>
  accfb5:	mov    $0x5,%r8b
  accfb8:	mov    $0x8,%edi
  accfbd:	test   %rsi,%rsi
  accfc0:	je     acd08d <ir_typed_emit_function+0x18ad>
  accfc6:	test   %r14,%r14
  accfc9:	je     acd0f0 <ir_typed_emit_function+0x1910>
  accfcf:	mov    0x18(%rsp),%rbx
  accfd4:	mov    0x80(%r14),%r9
  accfdb:	mov    %edx,%r11d
  accfde:	mov    %ebx,%r10d
  accfe1:	shl    $0x4,%r10
  accfe5:	mov    %rsi,(%r9,%r10,1)
  accfe9:	movb   $0x1,0x8(%r9,%r10,1)
  accfef:	movl   $0x0,0x9(%r9,%r10,1)
  accff8:	movl   $0x0,0xc(%r9,%r10,1)
  acd001:	mov    %edx,%r10d
  acd004:	inc    %rdx
  acd007:	mov    (%r14),%r9
  acd00a:	movb   $0x2a,(%r9,%r11,1)
  acd00f:	mov    0x8(%r14),%r9
  acd013:	movb   $0xa,(%r9,%r11,1)
  acd018:	mov    0x20(%r14),%r9
  acd01c:	mov    %eax,(%r9,%r11,4)
  acd020:	mov    0x28(%r14),%r9
  acd024:	movl   $0xffffffff,(%r9,%r11,4)
  acd02c:	mov    0x30(%r14),%r9
  acd030:	mov    %ebx,(%r9,%r11,4)
  acd034:	lea    0x1(%rbx),%r9
  acd038:	mov    0x18(%r14),%rbx
  acd03c:	mov    %r9,0x18(%rsp)
  acd041:	movb   $0x0,(%rbx,%r11,1)
  acd046:	jmp    acd095 <ir_typed_emit_function+0x18b5>
  acd048:	nopl   0x0(%rax,%rax,1)
  acd050:	cmp    $0x3,%r8
  acd054:	jbe    acd070 <ir_typed_emit_function+0x1890>
  acd056:	mov    $0x4,%r8b
  acd059:	mov    $0x4,%edi
  acd05e:	test   %rsi,%rsi
  acd061:	jne    accfc6 <ir_typed_emit_function+0x17e6>
  acd067:	jmp    acd08d <ir_typed_emit_function+0x18ad>
  acd069:	nopl   0x0(%rax)
  acd070:	xor    %edi,%edi
  acd072:	cmp    $0x2,%r8
  acd076:	setae  %dil
  acd07a:	mov    %edi,%r8d
  acd07d:	inc    %rdi
  acd080:	or     $0x2,%r8b
  acd084:	test   %rsi,%rsi
  acd087:	jne    accfc6 <ir_typed_emit_function+0x17e6>
  acd08d:	test   %r14,%r14
  acd090:	je     acd107 <ir_typed_emit_function+0x1927>
  acd092:	mov    %eax,%r10d
  acd095:	mov    (%r14),%r11
  acd098:	mov    %edx,%ebx
  acd09a:	lea    0x1(%rdx),%r9
  acd09e:	movb   $0x2b,(%r11,%rbx,1)
  acd0a3:	mov    0x8(%r14),%r11
  acd0a7:	mov    %r8b,(%r11,%rbx,1)
  acd0ab:	mov    0x20(%r14),%r8
  acd0af:	mov    %r10d,(%r8,%rbx,4)
  acd0b3:	mov    0x28(%r14),%r8
  acd0b7:	movl   $0xffffffff,(%r8,%rbx,4)
  acd0bf:	mov    0x30(%r14),%r8
  acd0c3:	movl   $0xffffffff,(%r8,%rbx,4)
  acd0cb:	mov    0x18(%r14),%r8
  acd0cf:	movb   $0x0,(%r8,%rbx,1)
  acd0d4:	test   %rsi,%rsi
  acd0d7:	jne    acced0 <ir_typed_emit_function+0x16f0>
  acd0dd:	mov    %ebp,%r8d
  acd0e0:	jmp    accf4d <ir_typed_emit_function+0x176d>
  acd0e5:	data16 cs nopw 0x0(%rax,%rax,1)
  acd0f0:	addq   $0x2,0x18(%rsp)
  acd0f6:	mov    0x118(%rsp),%rbx
  acd0fe:	add    $0x3,%rdx
  acd102:	jmp    accf91 <ir_typed_emit_function+0x17b1>
  acd107:	mov    0x118(%rsp),%rbx
  acd10f:	inc    %rdx
  acd112:	jmp    accf91 <ir_typed_emit_function+0x17b1>
  acd117:	mov    %rdx,%rbp
  acd11a:	jmp    acbf23 <ir_typed_emit_function+0x743>
  acd11f:	inc    %rbp
  acd122:	jmp    acd59a <ir_typed_emit_function+0x1dba>
  acd127:	mov    $0x2,%sil
  acd12a:	test   %r14,%r14
  acd12d:	je     acd16a <ir_typed_emit_function+0x198a>
  acd12f:	mov    (%r14),%rdi
  acd132:	mov    %ebp,%r8d
  acd135:	movb   $0x2b,(%rdi,%r8,1)
  acd13a:	mov    0x8(%r14),%rdi
  acd13e:	mov    %dl,(%rdi,%r8,1)
  acd142:	mov    0x20(%r14),%rdx
  acd146:	mov    %ecx,(%rdx,%r8,4)
  acd14a:	mov    0x28(%r14),%rcx
  acd14e:	movl   $0xffffffff,(%rcx,%r8,4)
  acd156:	mov    0x30(%r14),%rcx
  acd15a:	movl   $0xffffffff,(%rcx,%r8,4)
  acd162:	mov    0x18(%r14),%rcx
  acd166:	mov    %sil,(%rcx,%r8,1)
  acd16a:	mov    %ebp,%ecx
  acd16c:	inc    %rbp
  acd16f:	mov    0x120(%rsp),%rsi
  acd177:	mov    %r10d,%edx
  acd17a:	inc    %r10d
  acd17d:	mov    %ecx,(%rbx,%rdx,4)
  acd180:	mov    %r10d,%r15d
  acd183:	mov    %al,(%rsi,%rdx,1)
  acd186:	jmp    acbf23 <ir_typed_emit_function+0x743>
  acd18b:	mov    $0x3,%r8b
  acd18e:	test   %r14,%r14
  acd191:	jne    accadf <ir_typed_emit_function+0x12ff>
  acd197:	jmp    accb1e <ir_typed_emit_function+0x133e>
  acd19c:	mov    $0x3,%sil
  acd19f:	test   %r14,%r14
  acd1a2:	jne    accd50 <ir_typed_emit_function+0x1570>
  acd1a8:	jmp    accd8d <ir_typed_emit_function+0x15ad>
  acd1ad:	add    $0xfd,%r8b
  acd1b1:	cmp    $0x2,%r8b
  acd1b5:	setb   %r8b
  acd1b9:	test   %r14,%r14
  acd1bc:	jne    accadf <ir_typed_emit_function+0x12ff>
  acd1c2:	jmp    accb1e <ir_typed_emit_function+0x133e>
  acd1c7:	add    $0xfd,%sil
  acd1cb:	cmp    $0x2,%sil
  acd1cf:	setb   %sil
  acd1d3:	test   %r14,%r14
  acd1d6:	jne    accd50 <ir_typed_emit_function+0x1570>
  acd1dc:	jmp    accd8d <ir_typed_emit_function+0x15ad>
  acd1e1:	lea    -0x7(%rdi),%r9d
  acd1e5:	cmp    $0x2,%r9b
  acd1e9:	ja     acd532 <ir_typed_emit_function+0x1d52>
  acd1ef:	lea    -0x7(%rsi),%r9d
  acd1f3:	cmp    $0x2,%r9b
  acd1f7:	ja     acd532 <ir_typed_emit_function+0x1d52>
  acd1fd:	lea    -0x5d1cf4(%rip),%r9        # 4fb510 <ir_type_bits>
  acd204:	movzwl (%r9,%r8,2),%r8d
  acd209:	cmp    (%r9,%rdi,2),%r8w
  acd20e:	mov    $0x20,%dil
  acd211:	sbb    $0x0,%dil
  acd215:	jmp    acd553 <ir_typed_emit_function+0x1d73>
  acd21a:	mov    0xc0(%rsp),%r10
  acd222:	mov    0x30(%rsp),%rsi
  acd227:	mov    (%rsp),%rdx
  acd22b:	and    $0xfffffffc,%ecx
  acd22e:	xor    %r9d,%r9d
  acd231:	mov    %rcx,0x38(%rsp)
  acd236:	lea    (%r10,%rsi,4),%r12
  acd23a:	nopw   0x0(%rax,%rax,1)
  acd240:	mov    0x48(%rsp),%r10
  acd245:	mov    -0xc(%r12,%r9,4),%esi
  acd24a:	mov    0x50(%r14),%rcx
  acd24e:	lea    (%r10,%r9,1),%r15
  acd252:	mov    %r15d,%ebx
  acd255:	mov    %esi,(%rcx,%rbx,4)
  acd258:	mov    0x50(%r11),%rcx
  acd25c:	mov    0x78(%r11),%rsi
  acd260:	mov    0xa0(%r14),%rbx
  acd267:	mov    (%rcx,%rdi,4),%ecx
  acd26a:	add    %r9d,%ecx
  acd26d:	movzbl (%rsi,%rcx,1),%ecx
  acd271:	lea    -0x4edb48(%rip),%rsi        # 5df730 <ir_typed_types>
  acd278:	movzbl (%rcx,%rsi,1),%ecx
  acd27c:	lea    (%rdx,%r9,1),%rsi
  acd280:	mov    %esi,%r10d
  acd283:	mov    %cl,(%rbx,%r10,1)
  acd287:	lea    0x1(%r15),%ebx
  acd28b:	mov    -0x8(%r12,%r9,4),%ecx
  acd290:	mov    0x50(%r14),%r10
  acd294:	mov    %ecx,(%r10,%rbx,4)
  acd298:	lea    0x1(%rsi),%ebx
  acd29b:	mov    0x50(%r11),%rcx
  acd29f:	mov    0x78(%r11),%r10
  acd2a3:	mov    (%rcx,%rdi,4),%ecx
  acd2a6:	lea    0x1(%r9,%rcx,1),%ecx
  acd2ab:	movzbl (%r10,%rcx,1),%ecx
  acd2b0:	lea    -0x4edb87(%rip),%r10        # 5df730 <ir_typed_types>
  acd2b7:	movzbl (%rcx,%r10,1),%ecx
  acd2bc:	mov    0xa0(%r14),%r10
  acd2c3:	mov    %cl,(%r10,%rbx,1)
  acd2c7:	lea    0x2(%r15),%ebx
  acd2cb:	add    $0x3,%r15d
  acd2cf:	mov    -0x4(%r12,%r9,4),%ecx
  acd2d4:	mov    0x50(%r14),%r10
  acd2d8:	mov    %ecx,(%r10,%rbx,4)
  acd2dc:	lea    0x2(%rsi),%ebx
  acd2df:	add    $0x3,%esi
  acd2e2:	mov    0x50(%r11),%rcx
  acd2e6:	mov    0x78(%r11),%r10
  acd2ea:	mov    (%rcx,%rdi,4),%ecx
  acd2ed:	lea    0x2(%r9,%rcx,1),%ecx
  acd2f2:	movzbl (%r10,%rcx,1),%ecx
  acd2f7:	lea    -0x4edbce(%rip),%r10        # 5df730 <ir_typed_types>
  acd2fe:	movzbl (%rcx,%r10,1),%ecx
  acd303:	mov    0xa0(%r14),%r10
  acd30a:	mov    %cl,(%r10,%rbx,1)
  acd30e:	mov    0x48(%rsp),%rbx
  acd313:	mov    (%r12,%r9,4),%ecx
  acd317:	mov    0x50(%r14),%r10
  acd31b:	mov    %ecx,(%r10,%r15,4)
  acd31f:	lea    -0x4edbf6(%rip),%r15        # 5df730 <ir_typed_types>
  acd326:	mov    0x50(%r11),%rcx
  acd32a:	mov    0x78(%r11),%r10
  acd32e:	mov    (%rcx,%rdi,4),%ecx
  acd331:	lea    0x3(%r9,%rcx,1),%ecx
  acd336:	add    $0x4,%r9
  acd33a:	movzbl (%r10,%rcx,1),%ecx
  acd33f:	mov    0xa0(%r14),%r10
  acd346:	movzbl (%rcx,%r15,1),%ecx
  acd34b:	mov    %cl,(%r10,%rsi,1)
  acd34f:	cmp    %r9,0x38(%rsp)
  acd354:	jne    acd240 <ir_typed_emit_function+0x1a60>
  acd35a:	mov    0x88(%rsp),%r12
  acd362:	test   %r8,%r8
  acd365:	je     acd3ae <ir_typed_emit_function+0x1bce>
  acd367:	nopw   0x0(%rax,%rax,1)
  acd370:	mov    (%r12,%r9,4),%ecx
  acd374:	mov    0x50(%r14),%rsi
  acd378:	lea    (%rbx,%r9,1),%r10d
  acd37c:	mov    %ecx,(%rsi,%r10,4)
  acd380:	lea    (%rdx,%r9,1),%r10d
  acd384:	mov    0x50(%r11),%rcx
  acd388:	mov    0x78(%r11),%rsi
  acd38c:	mov    (%rcx,%rdi,4),%ecx
  acd38f:	add    %r9d,%ecx
  acd392:	inc    %r9
  acd395:	dec    %r8
  acd398:	movzbl (%rsi,%rcx,1),%ecx
  acd39c:	mov    0xa0(%r14),%rsi
  acd3a3:	movzbl (%rcx,%r15,1),%ecx
  acd3a8:	mov    %cl,(%rsi,%r10,1)
  acd3ac:	jne    acd370 <ir_typed_emit_function+0x1b90>
  acd3ae:	mov    0x48(%r11),%rcx
  acd3b2:	mov    (%r14),%rsi
  acd3b5:	movzbl 0xf(%rsp),%edx
  acd3ba:	mov    0x30(%rsp),%r10
  acd3bf:	mov    (%rcx,%rdi,4),%ecx
  acd3c2:	mov    %ebp,%edi
  acd3c4:	movb   $0x2d,(%rsi,%rdi,1)
  acd3c8:	mov    0x8(%r14),%rsi
  acd3cc:	mov    %dl,(%rsi,%rdi,1)
  acd3cf:	mov    0x60(%rsp),%rsi
  acd3d4:	mov    0x20(%r14),%rdx
  acd3d8:	mov    %ecx,(%rdx,%rdi,4)
  acd3db:	mov    0x28(%r14),%rcx
  acd3df:	mov    %esi,(%rcx,%rdi,4)
  acd3e2:	mov    0x30(%r14),%rcx
  acd3e6:	movl   $0xffffffff,(%rcx,%rdi,4)
  acd3ed:	mov    0x18(%r14),%rcx
  acd3f1:	movb   $0x0,(%rcx,%rdi,1)
  acd3f5:	mov    0x58(%rsp),%rcx
  acd3fa:	add    %rcx,(%rsp)
  acd3fe:	add    %rcx,%rbx
  acd401:	inc    %rsi
  acd404:	lea    0x1(%rbp),%rcx
  acd408:	mov    %rsi,0x60(%rsp)
  acd40d:	mov    %rbx,0x48(%rsp)
  acd412:	test   %al,%al
  acd414:	je     acd429 <ir_typed_emit_function+0x1c49>
  acd416:	mov    0x120(%rsp),%rdx
  acd41e:	mov    %ebp,(%r12)
  acd422:	mov    %al,(%rdx,%r10,1)
  acd426:	inc    %r10d
  acd429:	mov    0x118(%rsp),%rbx
  acd431:	mov    (%rsp),%r12
  acd435:	mov    %rcx,%rbp
  acd438:	jmp    acbf20 <ir_typed_emit_function+0x740>
  acd43d:	inc    %rbp
  acd440:	jmp    acd75c <ir_typed_emit_function+0x1f7c>
  acd445:	mov    0x28(%rsp),%r9
  acd44a:	lea    0x2(%rbp),%rdx
  acd44e:	mov    %rdx,%rsi
  acd451:	inc    %r9
  acd454:	inc    %rsi
  acd457:	mov    $0x1,%ecx
  acd45c:	mov    %r9,0x28(%rsp)
  acd461:	test   %r14,%r14
  acd464:	je     acd511 <ir_typed_emit_function+0x1d31>
  acd46a:	mov    0x18(%rsp),%r9
  acd46f:	mov    0x80(%r14),%rdi
  acd476:	mov    %r9d,%r8d
  acd479:	shl    $0x4,%r8
  acd47d:	movq   $0x0,(%rdi,%r8,1)
  acd485:	mov    %cl,0x8(%rdi,%r8,1)
  acd48a:	movl   $0x0,0x9(%rdi,%r8,1)
  acd493:	movl   $0x0,0xc(%rdi,%r8,1)
  acd49c:	mov    %esi,%r8d
  acd49f:	mov    %esi,%edi
  acd4a1:	inc    %rsi
  acd4a4:	mov    (%r14),%rcx
  acd4a7:	movb   $0x2a,(%rcx,%r8,1)
  acd4ac:	mov    0x8(%r14),%rcx
  acd4b0:	movb   $0xa,(%rcx,%r8,1)
  acd4b5:	mov    0x20(%r14),%rcx
  acd4b9:	mov    %ebp,(%rcx,%r8,4)
  acd4bd:	mov    %rsi,%rbp
  acd4c0:	mov    0x28(%r14),%rcx
  acd4c4:	mov    %edx,(%rcx,%r8,4)
  acd4c8:	mov    %esi,%edx
  acd4ca:	mov    0x30(%r14),%rcx
  acd4ce:	mov    %r9d,(%rcx,%r8,4)
  acd4d2:	mov    0x18(%r14),%rcx
  acd4d6:	movb   $0x0,(%rcx,%r8,1)
  acd4db:	mov    (%r14),%rcx
  acd4de:	movb   $0x26,(%rcx,%rdx,1)
  acd4e2:	mov    0x8(%r14),%rcx
  acd4e6:	movb   $0x5,(%rcx,%rdx,1)
  acd4ea:	mov    0x20(%r14),%rcx
  acd4ee:	mov    %edi,(%rcx,%rdx,4)
  acd4f1:	mov    0x28(%r14),%rcx
  acd4f5:	movl   $0xffffffff,(%rcx,%rdx,4)
  acd4fc:	mov    0x30(%r14),%rcx
  acd500:	movl   $0xffffffff,(%rcx,%rdx,4)
  acd507:	mov    0x18(%r14),%rcx
  acd50b:	movb   $0x0,(%rcx,%rdx,1)
  acd50f:	jmp    acd51c <ir_typed_emit_function+0x1d3c>
  acd511:	mov    0x18(%rsp),%r9
  acd516:	inc    %rsi
  acd519:	mov    %rsi,%rbp
  acd51c:	inc    %r9
  acd51f:	mov    %ebp,%ecx
  acd521:	inc    %rbp
  acd524:	mov    %r9,0x18(%rsp)
  acd529:	mov    %ecx,(%rbx,%r10,4)
  acd52d:	jmp    acd763 <ir_typed_emit_function+0x1f83>
  acd532:	mov    %eax,%edi
  acd534:	and    $0xf9,%dil
  acd538:	cmp    $0x1,%dil
  acd53c:	mov    $0x24,%dil
  acd53f:	jmp    acd54c <ir_typed_emit_function+0x1d6c>
  acd541:	and    $0xf9,%r9b
  acd545:	mov    $0x22,%dil
  acd548:	cmp    $0x1,%r9b
  acd54c:	sete   %r8b
  acd550:	sub    %r8b,%dil
  acd553:	mov    %r12,%r10
  acd556:	mov    (%rsp),%r12
  acd55a:	test   %r14,%r14
  acd55d:	je     acd59a <ir_typed_emit_function+0x1dba>
  acd55f:	mov    (%r14),%r8
  acd562:	mov    %ebp,%r9d
  acd565:	mov    %dil,(%r8,%r9,1)
  acd569:	mov    0x8(%r14),%rdi
  acd56d:	mov    %sil,(%rdi,%r9,1)
  acd571:	mov    0x20(%r14),%rsi
  acd575:	mov    %edx,(%rsi,%r9,4)
  acd579:	mov    0x28(%r14),%rdx
  acd57d:	movl   $0xffffffff,(%rdx,%r9,4)
  acd585:	mov    0x30(%r14),%rdx
  acd589:	movl   $0xffffffff,(%rdx,%r9,4)
  acd591:	mov    0x18(%r14),%rdx
  acd595:	movb   $0x0,(%rdx,%r9,1)
  acd59a:	mov    %ebp,%edx
  acd59c:	inc    %rbp
  acd59f:	mov    0x120(%rsp),%rsi
  acd5a7:	mov    %edx,(%rbx,%rcx,4)
  acd5aa:	mov    %r10d,%r15d
  acd5ad:	mov    %al,(%rsi,%rcx,1)
  acd5b0:	jmp    acbf23 <ir_typed_emit_function+0x743>
  acd5b5:	lea    -0x7(%r9),%r10d
  acd5b9:	cmp    $0x2,%r10b
  acd5bd:	ja     acd69e <ir_typed_emit_function+0x1ebe>
  acd5c3:	lea    -0x7(%rsi),%r10d
  acd5c7:	cmp    $0x2,%r10b
  acd5cb:	ja     acd69e <ir_typed_emit_function+0x1ebe>
  acd5d1:	lea    -0x5d20c8(%rip),%r10        # 4fb510 <ir_type_bits>
  acd5d8:	movzwl (%r10,%r8,2),%r8d
  acd5dd:	cmp    (%r10,%r9,2),%r8w
  acd5e2:	mov    $0x20,%r9b
  acd5e5:	sbb    $0x0,%r9b
  acd5e9:	jmp    acd6c0 <ir_typed_emit_function+0x1ee0>
  acd5ee:	mov    0x118(%rsp),%rax
  acd5f6:	lea    -0x1(%r10),%ebx
  acd5fa:	mov    $0x2a,%edx
  acd5ff:	mov    %r14,%rdi
  acd602:	mov    %rbp,%rsi
  acd605:	mov    %r10,%r15
  acd608:	mov    (%rax,%rbx,4),%ecx
  acd60b:	call   1af6e0f <ir_typed_stack>
  acd610:	mov    0x118(%rsp),%rcx
  acd618:	mov    0x10(%rsp),%r11
  acd61d:	add    $0x2,%rbp
  acd621:	mov    %eax,(%rcx,%rbx,4)
  acd624:	mov    0x120(%rsp),%rcx
  acd62c:	movb   $0x8,(%rcx,%rbx,1)
  acd630:	mov    0x118(%rsp),%rbx
  acd638:	jmp    acbf23 <ir_typed_emit_function+0x743>
  acd63d:	mov    $0x2b,%edx
  acd642:	mov    $0xffffffff,%ecx
  acd647:	mov    %r14,%rdi
  acd64a:	mov    %rbp,%rsi
  acd64d:	mov    %r10,%r15
  acd650:	call   1af6e0f <ir_typed_stack>
  acd655:	mov    0x120(%rsp),%rdx
  acd65d:	mov    0x10(%rsp),%r11
  acd662:	mov    %r15d,%ecx
  acd665:	inc    %r15d
  acd668:	mov    %eax,(%rbx,%rcx,4)
  acd66b:	inc    %rbp
  acd66e:	movb   $0x8,(%rdx,%rcx,1)
  acd672:	jmp    acbf23 <ir_typed_emit_function+0x743>
  acd677:	dec    %r10d
  acd67a:	mov    $0x2c,%edx
  acd67f:	mov    %r14,%rdi
  acd682:	mov    %rbp,%rsi
  acd685:	mov    (%rbx,%r10,4),%ecx
  acd689:	mov    %r10,%r15
  acd68c:	call   1af6e0f <ir_typed_stack>
  acd691:	mov    0x10(%rsp),%r11
  acd696:	inc    %rbp
  acd699:	jmp    acbf23 <ir_typed_emit_function+0x743>
  acd69e:	mov    %eax,%r8d
  acd6a1:	mov    $0x24,%r9b
  acd6a4:	and    $0xf9,%r8b
  acd6a8:	cmp    $0x1,%r8b
  acd6ac:	jmp    acd6b9 <ir_typed_emit_function+0x1ed9>
  acd6ae:	and    $0xf9,%r10b
  acd6b2:	mov    $0x22,%r9b
  acd6b5:	cmp    $0x1,%r10b
  acd6b9:	sete   %r8b
  acd6bd:	sub    %r8b,%r9b
  acd6c0:	mov    0x10(%rsp),%r11
  acd6c5:	test   %r14,%r14
  acd6c8:	je     acd705 <ir_typed_emit_function+0x1f25>
  acd6ca:	mov    (%r14),%r8
  acd6cd:	mov    %ebp,%r10d
  acd6d0:	mov    %r9b,(%r8,%r10,1)
  acd6d4:	mov    0x8(%r14),%r8
  acd6d8:	mov    %sil,(%r8,%r10,1)
  acd6dc:	mov    0x20(%r14),%rsi
  acd6e0:	mov    %edi,(%rsi,%r10,4)
  acd6e4:	mov    0x28(%r14),%rsi
  acd6e8:	movl   $0xffffffff,(%rsi,%r10,4)
  acd6f0:	mov    0x30(%r14),%rsi
  acd6f4:	movl   $0xffffffff,(%rsi,%r10,4)
  acd6fc:	mov    0x18(%r14),%rsi
  acd700:	movb   $0x0,(%rsi,%r10,1)
  acd705:	mov    %ebp,%edi
  acd707:	inc    %rbp
  acd70a:	mov    0x30(%rsp),%r10
  acd70f:	mov    (%rsp),%r12
  acd713:	test   %r14,%r14
  acd716:	je     acd75c <ir_typed_emit_function+0x1f7c>
  acd718:	mov    0x90(%rsp),%rsi
  acd720:	mov    (%r14),%r8
  acd723:	mov    %ebp,%r9d
  acd726:	movzbl (%rsi,%r13,1),%esi
  acd72b:	mov    %sil,(%r8,%r9,1)
  acd72f:	mov    0x8(%r14),%rsi
  acd733:	mov    %dl,(%rsi,%r9,1)
  acd737:	mov    0x20(%r14),%rdx
  acd73b:	mov    %ecx,(%rdx,%r9,4)
  acd73f:	mov    0x28(%r14),%rcx
  acd743:	mov    %edi,(%rcx,%r9,4)
  acd747:	mov    0x30(%r14),%rcx
  acd74b:	movl   $0xffffffff,(%rcx,%r9,4)
  acd753:	mov    0x18(%r14),%rcx
  acd757:	movb   $0x0,(%rcx,%r9,1)
  acd75c:	mov    %ebp,(%rbx,%r10,4)
  acd760:	inc    %rbp
  acd763:	mov    0x120(%rsp),%rcx
  acd76b:	mov    %al,(%rcx,%r10,1)
  acd76f:	jmp    acbf23 <ir_typed_emit_function+0x743>
  acd774:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  acd780:	testb  $0x1,0x24(%rsp)
  acd785:	mov    0x70(%rsp),%r13
  acd78a:	jne    acbbcc <ir_typed_emit_function+0x3ec>
  acd790:	cmp    0x18(%r11),%r13d
  acd794:	jne    acd800 <ir_typed_emit_function+0x2020>
  acd796:	cmpl   $0x0,0x54(%rsp)
  acd79b:	je     acbb89 <ir_typed_emit_function+0x3a9>
  acd7a1:	test   %r14,%r14
  acd7a4:	je     acd7e3 <ir_typed_emit_function+0x2003>
  acd7a6:	mov    (%r14),%rax
  acd7a9:	mov    %ebp,%ecx
  acd7ab:	mov    0x54(%rsp),%edx
  acd7af:	movb   $0x2,(%rax,%rcx,1)
  acd7b3:	mov    0x8(%r14),%rax
  acd7b7:	mov    %dl,(%rax,%rcx,1)
  acd7ba:	mov    0x20(%r14),%rax
  acd7be:	movl   $0xffffffff,(%rax,%rcx,4)
  acd7c5:	mov    0x28(%r14),%rax
  acd7c9:	movl   $0xffffffff,(%rax,%rcx,4)
  acd7d0:	mov    0x30(%r14),%rax
  acd7d4:	movl   $0xffffffff,(%rax,%rcx,4)
  acd7db:	mov    0x18(%r14),%rax
  acd7df:	movb   $0x0,(%rax,%rcx,1)
  acd7e3:	mov    %ebp,%eax
  acd7e5:	inc    %rbp
  acd7e8:	test   %r14,%r14
  acd7eb:	jne    acbb93 <ir_typed_emit_function+0x3b3>
  acd7f1:	jmp    acbbc9 <ir_typed_emit_function+0x3e9>
  acd7f6:	cs nopw 0x0(%rax,%rax,1)
  acd800:	test   %r15d,%r15d
  acd803:	je     acd81b <ir_typed_emit_function+0x203b>
  acd805:	mov    0x30(%r11),%eax
  acd809:	cmp    $0x1,%r15d
  acd80d:	jne    acd84c <ir_typed_emit_function+0x206c>
  acd80f:	mov    0x68(%rsp),%r15
  acd814:	xor    %ecx,%ecx
  acd816:	jmp    acd9bf <ir_typed_emit_function+0x21df>
  acd81b:	mov    0x68(%rsp),%r15
  acd820:	jmp    acda2b <ir_typed_emit_function+0x224b>
  acd825:	mov    $0x3,%dl
  acd827:	test   %r14,%r14
  acd82a:	jne    acbea2 <ir_typed_emit_function+0x6c2>
  acd830:	jmp    acbeee <ir_typed_emit_function+0x70e>
  acd835:	add    $0xfd,%dl
  acd838:	cmp    $0x2,%dl
  acd83b:	setb   %dl
  acd83e:	test   %r14,%r14
  acd841:	jne    acbea2 <ir_typed_emit_function+0x6c2>
  acd847:	jmp    acbeee <ir_typed_emit_function+0x70e>
  acd84c:	mov    %r15d,%edx
  acd84f:	mov    0x68(%rsp),%r15
  acd854:	mov    %edx,%esi
  acd856:	and    $0xfffffffe,%esi
  acd859:	mov    %eax,%edi
  acd85b:	xor    %ecx,%ecx
  acd85d:	jmp    acd8c4 <ir_typed_emit_function+0x20e4>
  acd85f:	nop
  acd860:	mov    $0x3,%r9b
  acd863:	test   %r14,%r14
  acd866:	je     acd8b0 <ir_typed_emit_function+0x20d0>
  acd868:	mov    (%r14),%rbx
  acd86b:	lea    0x1(%rbp),%r10
  acd86f:	lea    0x1(%rdi),%r11d
  acd873:	mov    %r10d,%r10d
  acd876:	movb   $0x2c,(%rbx,%r10,1)
  acd87b:	mov    0x8(%r14),%rbx
  acd87f:	movb   $0x0,(%rbx,%r10,1)
  acd884:	mov    0x20(%r14),%rbx
  acd888:	mov    %r11d,(%rbx,%r10,4)
  acd88c:	mov    0x118(%rsp),%rbx
  acd894:	mov    0x28(%r14),%r11
  acd898:	mov    %r8d,(%r11,%r10,4)
  acd89c:	mov    0x30(%r14),%r8
  acd8a0:	movl   $0xffffffff,(%r8,%r10,4)
  acd8a8:	mov    0x18(%r14),%r8
  acd8ac:	mov    %r9b,(%r8,%r10,1)
  acd8b0:	add    $0x2,%rbp
  acd8b4:	add    $0x2,%rcx
  acd8b8:	add    $0x2,%edi
  acd8bb:	cmp    %rcx,%rsi
  acd8be:	je     acd9ba <ir_typed_emit_function+0x21da>
  acd8c4:	mov    0x120(%rsp),%r8
  acd8cc:	movzbl (%r8,%rcx,1),%r9d
  acd8d1:	lea    -0x4ee198(%rip),%r8        # 5df740 <tier0_class_bytes.bytes>
  acd8d8:	and    $0xf,%r9d
  acd8dc:	movzbl (%r9,%r8,1),%r10d
  acd8e1:	cmp    $0x4,%r10d
  acd8e5:	je     acd990 <ir_typed_emit_function+0x21b0>
  acd8eb:	mov    $0x3,%r8b
  acd8ee:	cmp    $0x8,%r10d
  acd8f2:	je     acd900 <ir_typed_emit_function+0x2120>
  acd8f4:	add    $0xfd,%r9b
  acd8f8:	cmp    $0x2,%r9b
  acd8fc:	setb   %r8b
  acd900:	test   %r14,%r14
  acd903:	je     acd941 <ir_typed_emit_function+0x2161>
  acd905:	mov    (%r14),%r10
  acd908:	mov    (%rbx,%rcx,4),%r9d
  acd90c:	mov    %ebp,%r11d
  acd90f:	movb   $0x2c,(%r10,%r11,1)
  acd914:	mov    0x8(%r14),%r10
  acd918:	movb   $0x0,(%r10,%r11,1)
  acd91d:	mov    0x20(%r14),%r10
  acd921:	mov    %edi,(%r10,%r11,4)
  acd925:	mov    0x28(%r14),%r10
  acd929:	mov    %r9d,(%r10,%r11,4)
  acd92d:	mov    0x30(%r14),%r9
  acd931:	movl   $0xffffffff,(%r9,%r11,4)
  acd939:	mov    0x18(%r14),%r9
  acd93d:	mov    %r8b,(%r9,%r11,1)
  acd941:	mov    0x120(%rsp),%r9
  acd949:	lea    -0x4ee210(%rip),%r10        # 5df740 <tier0_class_bytes.bytes>
  acd950:	mov    0x4(%rbx,%rcx,4),%r8d
  acd955:	movzbl 0x1(%r9,%rcx,1),%r9d
  acd95b:	and    $0xf,%r9d
  acd95f:	movzbl (%r9,%r10,1),%r10d
  acd964:	cmp    $0x8,%r10d
  acd968:	je     acd860 <ir_typed_emit_function+0x2080>
  acd96e:	cmp    $0x4,%r10d
  acd972:	jne    acd9a0 <ir_typed_emit_function+0x21c0>
  acd974:	mov    $0x2,%r9b
  acd977:	test   %r14,%r14
  acd97a:	jne    acd868 <ir_typed_emit_function+0x2088>
  acd980:	jmp    acd8b0 <ir_typed_emit_function+0x20d0>
  acd985:	data16 cs nopw 0x0(%rax,%rax,1)
  acd990:	mov    $0x2,%r8b
  acd993:	test   %r14,%r14
  acd996:	jne    acd905 <ir_typed_emit_function+0x2125>
  acd99c:	jmp    acd941 <ir_typed_emit_function+0x2161>
  acd99e:	xchg   %ax,%ax
  acd9a0:	add    $0xfd,%r9b
  acd9a4:	cmp    $0x2,%r9b
  acd9a8:	setb   %r9b
  acd9ac:	test   %r14,%r14
  acd9af:	jne    acd868 <ir_typed_emit_function+0x2088>
  acd9b5:	jmp    acd8b0 <ir_typed_emit_function+0x20d0>
  acd9ba:	test   $0x1,%dl
  acd9bd:	je     acda2b <ir_typed_emit_function+0x224b>
  acd9bf:	mov    0x120(%rsp),%rdx
  acd9c7:	lea    -0x4ee28e(%rip),%rsi        # 5df740 <tier0_class_bytes.bytes>
  acd9ce:	movzbl (%rdx,%rcx,1),%edx
  acd9d2:	and    $0xf,%edx
  acd9d5:	movzbl (%rdx,%rsi,1),%esi
  acd9d9:	cmp    $0x8,%esi
  acd9dc:	je     acda74 <ir_typed_emit_function+0x2294>
  acd9e2:	cmp    $0x4,%esi
  acd9e5:	jne    acda81 <ir_typed_emit_function+0x22a1>
  acd9eb:	mov    $0x2,%dl
  acd9ed:	test   %r14,%r14
  acd9f0:	je     acda28 <ir_typed_emit_function+0x2248>
  acd9f2:	mov    (%r14),%rsi
  acd9f5:	add    %ecx,%eax
  acd9f7:	mov    (%rbx,%rcx,4),%ecx
  acd9fa:	mov    %ebp,%edi
  acd9fc:	movb   $0x2c,(%rsi,%rdi,1)
  acda00:	mov    0x8(%r14),%rsi
  acda04:	movb   $0x0,(%rsi,%rdi,1)
  acda08:	mov    0x20(%r14),%rsi
  acda0c:	mov    %eax,(%rsi,%rdi,4)
  acda0f:	mov    0x28(%r14),%rax
  acda13:	mov    %ecx,(%rax,%rdi,4)
  acda16:	mov    0x30(%r14),%rax
  acda1a:	movl   $0xffffffff,(%rax,%rdi,4)
  acda21:	mov    0x18(%r14),%rax
  acda25:	mov    %dl,(%rax,%rdi,1)
  acda28:	inc    %rbp
  acda2b:	test   %r14,%r14
  acda2e:	je     acbbc9 <ir_typed_emit_function+0x3e9>
  acda34:	mov    (%r14),%rax
  acda37:	mov    %ebp,%ecx
  acda39:	add    $0x2,%r15d
  acda3d:	movb   $0x30,(%rax,%rcx,1)
  acda41:	mov    0x8(%r14),%rax
  acda45:	movb   $0x0,(%rax,%rcx,1)
  acda49:	mov    0x20(%r14),%rax
  acda4d:	mov    %r15d,(%rax,%rcx,4)
  acda51:	mov    0x28(%r14),%rax
  acda55:	movl   $0xffffffff,(%rax,%rcx,4)
  acda5c:	mov    0x30(%r14),%rax
  acda60:	movl   $0xffffffff,(%rax,%rcx,4)
  acda67:	mov    0x18(%r14),%rax
  acda6b:	movb   $0x0,(%rax,%rcx,1)
  acda6f:	jmp    acbbc9 <ir_typed_emit_function+0x3e9>
  acda74:	mov    $0x3,%dl
  acda76:	test   %r14,%r14
  acda79:	jne    acd9f2 <ir_typed_emit_function+0x2212>
  acda7f:	jmp    acda28 <ir_typed_emit_function+0x2248>
  acda81:	add    $0xfd,%dl
  acda84:	cmp    $0x2,%dl
  acda87:	setb   %dl
  acda8a:	test   %r14,%r14
  acda8d:	jne    acd9f2 <ir_typed_emit_function+0x2212>
  acda93:	jmp    acda28 <ir_typed_emit_function+0x2248>
  acda95:	mov    0x60(%rsp),%rsi
  acda9a:	mov    0x28(%rsp),%rdi
  acda9f:	mov    0x18(%rsp),%r8
  acdaa4:	inc    %eax
  acdaa6:	test   %r14,%r14
  acdaa9:	je     acdab2 <ir_typed_emit_function+0x22d2>
  acdaab:	mov    0x40(%r14),%rcx
  acdaaf:	mov    %ebp,(%rcx,%rax,4)
  acdab2:	mov    0xa8(%rsp),%rdx
  acdaba:	mov    0xb8(%rsp),%rax
  acdac2:	mov    0xb0(%rsp),%rcx
  acdaca:	add    0xa0(%rsp),%rcx
  acdad2:	inc    %rdx
  acdad5:	mov    %rbp,(%rax)
  acdad8:	mov    %rdx,0x8(%rax)
  acdadc:	mov    0x80(%rsp),%rdx
  acdae4:	mov    %r9,0x10(%rax)
  acdae8:	mov    %rdi,0x18(%rax)
  acdaec:	mov    %rcx,0x20(%rax)
  acdaf0:	mov    %r8,0x28(%rax)
  acdaf4:	mov    %rsi,0x30(%rax)
  acdaf8:	mov    %r12,0x38(%rax)
  acdafc:	mov    %rdx,0x40(%rax)
  acdb00:	add    $0xd8,%rsp
  acdb07:	pop    %rbx
  acdb08:	pop    %r12
  acdb0a:	pop    %r13
  acdb0c:	pop    %r14
  acdb0e:	pop    %r15
  acdb10:	pop    %rbp
  acdb11:	ret
  acdb12:	mov    $0x1,%eax
  acdb17:	xor    %r8d,%r8d
  acdb1a:	xor    %esi,%esi
  acdb1c:	xor    %edi,%edi
  acdb1e:	xor    %r9d,%r9d
  acdb21:	xor    %r12d,%r12d
  acdb24:	test   %r14,%r14
  acdb27:	jne    acdaab <ir_typed_emit_function+0x22cb>
  acdb29:	jmp    acdab2 <ir_typed_emit_function+0x22d2>
