
base/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000a0aa20 <pp_compile_macro>:
  a0aa20:	push   %rbp
  a0aa21:	push   %r15
  a0aa23:	push   %r14
  a0aa25:	push   %r13
  a0aa27:	push   %r12
  a0aa29:	push   %rbx
  a0aa2a:	sub    $0x48,%rsp
  a0aa2e:	mov    0xde8(%rdi),%rax
  a0aa35:	mov    %esi,%ecx
  a0aa37:	shl    $0x6,%rcx
  a0aa3b:	mov    %rdi,%r13
  a0aa3e:	mov    0x10(%rax,%rcx,1),%edx
  a0aa42:	lea    (%rax,%rcx,1),%r10
  a0aa46:	movzbl 0x4(%rax,%rcx,1),%eax
  a0aa4b:	imul   $0xe8,%rdx,%rbp
  a0aa52:	mov    %al,0xf(%rsp)
  a0aa56:	test   $0x1,%al
  a0aa58:	jne    a0aa5e <pp_compile_macro+0x3e>
  a0aa5a:	xor    %ebx,%ebx
  a0aa5c:	jmp    a0aa67 <pp_compile_macro+0x47>
  a0aa5e:	cmpw   $0x0,0x8(%r10)
  a0aa64:	setne  %bl
  a0aa67:	mov    0x1c(%r10),%eax
  a0aa6b:	mov    0x18(%r10),%edx
  a0aa6f:	add    0xb80(%r13),%rbp
  a0aa76:	mov    0xe10(%r13),%ecx
  a0aa7d:	add    0xe00(%r13),%eax
  a0aa84:	sub    %edx,%eax
  a0aa86:	cmp    $0x4000001,%eax
  a0aa8b:	jae    a0ab14 <pp_compile_macro+0xf4>
  a0aa91:	movzwl 0x8(%r10),%eax
  a0aa96:	mov    %ecx,0x30(%r10)
  a0aa9a:	add    %ecx,%eax
  a0aa9c:	cmp    $0x4000001,%eax
  a0aaa1:	setb   %al
  a0aaa4:	mov    %eax,%ecx
  a0aaa6:	and    %bl,%cl
  a0aaa8:	cmp    $0x1,%cl
  a0aaab:	jne    a0ab1a <pp_compile_macro+0xfa>
  a0aaad:	mov    0x20(%r10),%ecx
  a0aab1:	cmp    %edx,%ecx
  a0aab3:	jae    a0ab1a <pp_compile_macro+0xfa>
  a0aab5:	xor    %edx,%edx
  a0aab7:	jmp    a0aae7 <pp_compile_macro+0xc7>
  a0aab9:	nopl   0x0(%rax)
  a0aac0:	mov    0x60(%rbp),%rsi
  a0aac4:	mov    (%rsi,%rcx,4),%esi
  a0aac7:	mov    0x30(%r10),%r8d
  a0aacb:	mov    0xe08(%r13),%rdi
  a0aad2:	add    %edx,%r8d
  a0aad5:	inc    %edx
  a0aad7:	mov    %esi,(%rdi,%r8,4)
  a0aadb:	mov    0x18(%r10),%esi
  a0aadf:	inc    %rcx
  a0aae2:	cmp    %rsi,%rcx
  a0aae5:	jae    a0ab1a <pp_compile_macro+0xfa>
  a0aae7:	mov    0x50(%rbp),%rsi
  a0aaeb:	movzbl (%rsi,%rcx,1),%edi
  a0aaef:	and    $0x7f,%edi
  a0aaf2:	cmp    $0x1,%edi
  a0aaf5:	je     a0aac0 <pp_compile_macro+0xa0>
  a0aaf7:	cmp    $0x14,%edi
  a0aafa:	jne    a0aadb <pp_compile_macro+0xbb>
  a0aafc:	lea    -0x1(%rcx),%edi
  a0aaff:	movzbl (%rsi,%rdi,1),%edi
  a0ab03:	mov    $0xaa,%esi
  a0ab08:	and    $0x7f,%dil
  a0ab0c:	cmp    $0x1,%dil
  a0ab10:	jne    a0aac7 <pp_compile_macro+0xa7>
  a0ab12:	jmp    a0aadb <pp_compile_macro+0xbb>
  a0ab14:	mov    %ecx,0x30(%r10)
  a0ab18:	xor    %eax,%eax
  a0ab1a:	movzwl 0x8(%r10),%ecx
  a0ab1f:	mov    %r13,0x30(%rsp)
  a0ab24:	mov    %r10,0x10(%rsp)
  a0ab29:	add    %ecx,0xe10(%r13)
  a0ab30:	mov    0xe00(%r13),%ecx
  a0ab37:	mov    %ecx,0x28(%r10)
  a0ab3b:	movq   $0x0,0x38(%r10)
  a0ab43:	test   %al,%al
  a0ab45:	je     a0b27a <pp_compile_macro+0x85a>
  a0ab4b:	mov    0x18(%r10),%r15d
  a0ab4f:	mov    0x1c(%r10),%r8d
  a0ab53:	cmp    %r8d,%r15d
  a0ab56:	jae    a0b003 <pp_compile_macro+0x5e3>
  a0ab5c:	mov    $0xffffffff,%eax
  a0ab61:	xor    %r11d,%r11d
  a0ab64:	xor    %edx,%edx
  a0ab66:	cs nopw 0x0(%rax,%rax,1)
  a0ab70:	mov    %r11,0x18(%rsp)
  a0ab75:	jmp    a0abb9 <pp_compile_macro+0x199>
  a0ab77:	nopw   0x0(%rax,%rax,1)
  a0ab80:	mov    0xdf8(%r13),%rcx
  a0ab87:	mov    %eax,%esi
  a0ab89:	not    %eax
  a0ab8b:	inc    %r15d
  a0ab8e:	or     %dl,0x1(%rcx,%rsi,8)
  a0ab92:	xor    %edx,%edx
  a0ab94:	add    0xe00(%r13),%eax
  a0ab9b:	mov    0xdf8(%r13),%rcx
  a0aba2:	mov    %ax,0x2(%rcx,%rsi,8)
  a0aba7:	mov    $0xffffffff,%eax
  a0abac:	mov    0x1c(%r10),%r8d
  a0abb0:	cmp    %r8d,%r15d
  a0abb3:	jae    a0b003 <pp_compile_macro+0x5e3>
  a0abb9:	mov    0x50(%rbp),%rsi
  a0abbd:	mov    0x18(%r10),%edi
  a0abc1:	cmp    %edi,%r15d
  a0abc4:	je     a0ac00 <pp_compile_macro+0x1e0>
  a0abc6:	mov    0x68(%rbp),%rcx
  a0abca:	mov    %r15d,%r9d
  a0abcd:	shr    $0x6,%r9d
  a0abd1:	mov    (%rcx,%r9,8),%rcx
  a0abd5:	bt     %r15,%rcx
  a0abd9:	jae    a0ac00 <pp_compile_macro+0x1e0>
  a0abdb:	lea    -0x1(%r15),%ecx
  a0abdf:	movzbl (%rsi,%rcx,1),%ecx
  a0abe3:	and    $0x7f,%cl
  a0abe6:	cmp    $0x3d,%cl
  a0abe9:	setne  %cl
  a0abec:	mov    %ecx,0x8(%rsp)
  a0abf0:	jmp    a0ac08 <pp_compile_macro+0x1e8>
  a0abf2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0ac00:	movl   $0x0,0x8(%rsp)
  a0ac08:	mov    %r15d,%r10d
  a0ac0b:	movzbl (%rsi,%r10,1),%r11d
  a0ac10:	and    $0x7f,%r11b
  a0ac14:	cmp    $0x1,%r11b
  a0ac18:	sete   %cl
  a0ac1b:	and    %bl,%cl
  a0ac1d:	cmp    $0x1,%cl
  a0ac20:	jne    a0ac40 <pp_compile_macro+0x220>
  a0ac22:	mov    0x60(%rbp),%rcx
  a0ac26:	cmpl   $0xab,(%rcx,%r10,4)
  a0ac2e:	sete   %r12b
  a0ac32:	jmp    a0ac43 <pp_compile_macro+0x223>
  a0ac34:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0ac40:	xor    %r12d,%r12d
  a0ac43:	cmp    $0x1,%r11b
  a0ac47:	sete   %cl
  a0ac4a:	and    %bl,%cl
  a0ac4c:	cmp    $0x1,%cl
  a0ac4f:	jne    a0acb0 <pp_compile_macro+0x290>
  a0ac51:	test   %r12b,%r12b
  a0ac54:	jne    a0acb0 <pp_compile_macro+0x290>
  a0ac56:	mov    0x10(%rsp),%rcx
  a0ac5b:	movzwl 0x8(%rcx),%r14d
  a0ac60:	test   %r14,%r14
  a0ac63:	je     a0acb0 <pp_compile_macro+0x290>
  a0ac65:	mov    0x10(%rsp),%r9
  a0ac6a:	mov    0x60(%rbp),%rcx
  a0ac6e:	mov    0x30(%r9),%r13d
  a0ac72:	mov    0x30(%rsp),%r9
  a0ac77:	mov    (%rcx,%r10,4),%ecx
  a0ac7b:	shl    $0x2,%r13
  a0ac7f:	add    0xe08(%r9),%r13
  a0ac86:	xor    %r9d,%r9d
  a0ac89:	nopl   0x0(%rax)
  a0ac90:	cmp    %ecx,0x0(%r13,%r9,4)
  a0ac95:	je     a0adb0 <pp_compile_macro+0x390>
  a0ac9b:	inc    %r9
  a0ac9e:	cmp    %r9,%r14
  a0aca1:	jne    a0ac90 <pp_compile_macro+0x270>
  a0aca3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0acb0:	mov    $0x1,%r14b
  a0acb3:	cmp    $0x3d,%r11b
  a0acb7:	je     a0ae16 <pp_compile_macro+0x3f6>
  a0acbd:	mov    0x30(%rsp),%r13
  a0acc2:	test   %r12b,%r12b
  a0acc5:	jne    a0ae21 <pp_compile_macro+0x401>
  a0accb:	cmp    $0x3c,%r11b
  a0accf:	sete   %cl
  a0acd2:	and    %bl,%cl
  a0acd4:	cmp    $0x1,%cl
  a0acd7:	je     a0ae8c <pp_compile_macro+0x46c>
  a0acdd:	cmp    $0xffffffff,%eax
  a0ace0:	je     a0acec <pp_compile_macro+0x2cc>
  a0ace2:	cmp    $0xf,%r11b
  a0ace6:	je     a0aec3 <pp_compile_macro+0x4a3>
  a0acec:	mov    0x10(%rsp),%r10
  a0acf1:	xor    %r8d,%r8d
  a0acf4:	cmp    $0xffffffff,%eax
  a0acf7:	je     a0aed3 <pp_compile_macro+0x4b3>
  a0acfd:	cmp    $0x10,%r11b
  a0ad01:	jne    a0aed3 <pp_compile_macro+0x4b3>
  a0ad07:	mov    0x18(%rsp),%r11
  a0ad0c:	dec    %edx
  a0ad0e:	jne    a0aede <pp_compile_macro+0x4be>
  a0ad14:	xor    %edx,%edx
  a0ad16:	cmp    %r15d,%r11d
  a0ad19:	ja     a0ad66 <pp_compile_macro+0x346>
  a0ad1b:	mov    %r11d,%r8d
  a0ad1e:	jmp    a0ad28 <pp_compile_macro+0x308>
  a0ad20:	inc    %r8d
  a0ad23:	cmp    %r15d,%r8d
  a0ad26:	ja     a0ad60 <pp_compile_macro+0x340>
  a0ad28:	cmp    %r8d,%edi
  a0ad2b:	je     a0ad20 <pp_compile_macro+0x300>
  a0ad2d:	mov    0x68(%rbp),%rcx
  a0ad31:	mov    %r8d,%r9d
  a0ad34:	shr    $0x6,%r9d
  a0ad38:	mov    (%rcx,%r9,8),%rcx
  a0ad3c:	bt     %r8,%rcx
  a0ad40:	jae    a0ad20 <pp_compile_macro+0x300>
  a0ad42:	lea    -0x1(%r8),%ecx
  a0ad46:	movzbl (%rsi,%rcx,1),%ecx
  a0ad4a:	and    $0x7f,%cl
  a0ad4d:	cmp    $0x3d,%cl
  a0ad50:	setne  %cl
  a0ad53:	or     %cl,%dl
  a0ad55:	jmp    a0ad20 <pp_compile_macro+0x300>
  a0ad57:	nopw   0x0(%rax,%rax,1)
  a0ad60:	and    $0x1,%dl
  a0ad63:	shl    $0x6,%dl
  a0ad66:	cmp    %edi,%r15d
  a0ad69:	je     a0ab80 <pp_compile_macro+0x160>
  a0ad6f:	mov    0x68(%rbp),%rcx
  a0ad73:	mov    %r15d,%edi
  a0ad76:	shr    $0x6,%edi
  a0ad79:	mov    (%rcx,%rdi,8),%rcx
  a0ad7d:	bt     %r15,%rcx
  a0ad81:	jae    a0ab80 <pp_compile_macro+0x160>
  a0ad87:	lea    -0x1(%r15),%ecx
  a0ad8b:	movzbl (%rsi,%rcx,1),%ecx
  a0ad8f:	and    $0x7f,%cl
  a0ad92:	cmp    $0x3d,%cl
  a0ad95:	setne  %cl
  a0ad98:	shl    $0x5,%cl
  a0ad9b:	or     %dl,%cl
  a0ad9d:	mov    %ecx,%edx
  a0ad9f:	jmp    a0ab80 <pp_compile_macro+0x160>
  a0ada4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0adb0:	mov    $0x1,%r8b
  a0adb3:	mov    %r15d,%r12d
  a0adb6:	mov    $0x1,%r14b
  a0adb9:	mov    0x30(%rsp),%r13
  a0adbe:	mov    0x10(%rsp),%r10
  a0adc3:	mov    0x18(%rsp),%r11
  a0adc8:	mov    0x8(%rsp),%edi
  a0adcc:	test   %r14b,%r14b
  a0adcf:	je     a0b27a <pp_compile_macro+0x85a>
  a0add5:	mov    0xdf8(%r13),%rcx
  a0addc:	mov    0xe00(%r13),%esi
  a0ade3:	inc    %r12d
  a0ade6:	mov    %r8b,(%rcx,%rsi,8)
  a0adea:	mov    %dil,0x1(%rcx,%rsi,8)
  a0adef:	mov    %r9w,0x2(%rcx,%rsi,8)
  a0adf5:	mov    %r15d,0x4(%rcx,%rsi,8)
  a0adfa:	incl   0xe00(%r13)
  a0ae01:	mov    %r12d,%r15d
  a0ae04:	mov    0x1c(%r10),%r8d
  a0ae08:	cmp    %r8d,%r12d
  a0ae0b:	jb     a0ab70 <pp_compile_macro+0x150>
  a0ae11:	jmp    a0afda <pp_compile_macro+0x5ba>
  a0ae16:	mov    $0x3,%r8b
  a0ae19:	xor    %r9d,%r9d
  a0ae1c:	mov    %r15d,%r12d
  a0ae1f:	jmp    a0adb9 <pp_compile_macro+0x399>
  a0ae21:	lea    0x1(%r15),%r12d
  a0ae25:	cmp    $0xffffffff,%eax
  a0ae28:	jne    a0ae3f <pp_compile_macro+0x41f>
  a0ae2a:	cmp    %r8d,%r12d
  a0ae2d:	jae    a0ae3f <pp_compile_macro+0x41f>
  a0ae2f:	mov    %r12d,%eax
  a0ae32:	movzbl (%rsi,%rax,1),%eax
  a0ae36:	mov    $0x1,%r14b
  a0ae39:	and    $0x7f,%al
  a0ae3b:	cmp    $0xf,%al
  a0ae3d:	je     a0ae68 <pp_compile_macro+0x448>
  a0ae3f:	mov    0x58(%rbp),%rax
  a0ae43:	mov    $0x1,%esi
  a0ae48:	lea    -0x3d97c6(%rip),%rcx        # 631689 <tier0_test_vector_type_class.classes+0x6412>
  a0ae4f:	xor    %r14d,%r14d
  a0ae52:	mov    %r13,%rdi
  a0ae55:	mov    (%rax,%r10,4),%edx
  a0ae59:	mov    0x10(%rsp),%rax
  a0ae5e:	add    0x14(%rax),%edx
  a0ae61:	xor    %eax,%eax
  a0ae63:	call   98a970 <pp_diagnose>
  a0ae68:	mov    0xe00(%r13),%eax
  a0ae6f:	mov    0x10(%rsp),%r10
  a0ae74:	mov    0x8(%rsp),%edi
  a0ae78:	lea    0x2(%r15),%r11d
  a0ae7c:	mov    $0x1,%edx
  a0ae81:	mov    $0x4,%r8b
  a0ae84:	xor    %r9d,%r9d
  a0ae87:	jmp    a0adcc <pp_compile_macro+0x3ac>
  a0ae8c:	lea    0x1(%r15),%r10d
  a0ae90:	cmp    %r8d,%r10d
  a0ae93:	jae    a0b24a <pp_compile_macro+0x82a>
  a0ae99:	mov    %r10d,%r9d
  a0ae9c:	movzbl (%rsi,%r9,1),%ecx
  a0aea1:	and    $0x7f,%cl
  a0aea4:	cmp    $0x1,%cl
  a0aea7:	jne    a0aef0 <pp_compile_macro+0x4d0>
  a0aea9:	mov    0x60(%rbp),%r11
  a0aead:	cmpl   $0xab,(%r11,%r9,4)
  a0aeb5:	sete   %r11b
  a0aeb9:	cmp    $0x1,%cl
  a0aebc:	je     a0aef8 <pp_compile_macro+0x4d8>
  a0aebe:	jmp    a0af43 <pp_compile_macro+0x523>
  a0aec3:	inc    %edx
  a0aec5:	xor    %r8d,%r8d
  a0aec8:	xor    %r9d,%r9d
  a0aecb:	mov    %r15d,%r12d
  a0aece:	jmp    a0adbe <pp_compile_macro+0x39e>
  a0aed3:	xor    %r9d,%r9d
  a0aed6:	mov    %r15d,%r12d
  a0aed9:	jmp    a0adc3 <pp_compile_macro+0x3a3>
  a0aede:	mov    0x8(%rsp),%edi
  a0aee2:	xor    %r8d,%r8d
  a0aee5:	xor    %r9d,%r9d
  a0aee8:	mov    %r15d,%r12d
  a0aeeb:	jmp    a0adcc <pp_compile_macro+0x3ac>
  a0aef0:	xor    %r11d,%r11d
  a0aef3:	cmp    $0x1,%cl
  a0aef6:	jne    a0af43 <pp_compile_macro+0x523>
  a0aef8:	test   %r11b,%r11b
  a0aefb:	jne    a0af43 <pp_compile_macro+0x523>
  a0aefd:	mov    0x10(%rsp),%rcx
  a0af02:	movzwl 0x8(%rcx),%r12d
  a0af07:	test   %r12,%r12
  a0af0a:	je     a0af43 <pp_compile_macro+0x523>
  a0af0c:	mov    0x60(%rbp),%rcx
  a0af10:	mov    (%rcx,%r9,4),%ecx
  a0af14:	mov    0x10(%rsp),%r9
  a0af19:	mov    0x30(%r9),%r13d
  a0af1d:	mov    0x30(%rsp),%r9
  a0af22:	shl    $0x2,%r13
  a0af26:	add    0xe08(%r9),%r13
  a0af2d:	xor    %r9d,%r9d
  a0af30:	cmp    %ecx,0x0(%r13,%r9,4)
  a0af35:	je     a0afcf <pp_compile_macro+0x5af>
  a0af3b:	inc    %r9
  a0af3e:	cmp    %r9,%r12
  a0af41:	jne    a0af30 <pp_compile_macro+0x510>
  a0af43:	mov    0x30(%rsp),%r13
  a0af48:	cmp    $0xffffffff,%eax
  a0af4b:	sete   %al
  a0af4e:	and    %al,%r11b
  a0af51:	cmp    $0x1,%r11b
  a0af55:	jne    a0b24a <pp_compile_macro+0x82a>
  a0af5b:	lea    0x2(%r15),%r12d
  a0af5f:	cmp    %r8d,%r12d
  a0af62:	jae    a0b24a <pp_compile_macro+0x82a>
  a0af68:	mov    %r12d,%eax
  a0af6b:	movzbl (%rsi,%rax,1),%eax
  a0af6f:	and    $0x7f,%al
  a0af71:	cmp    $0xf,%al
  a0af73:	jne    a0b24a <pp_compile_macro+0x82a>
  a0af79:	cmp    %edi,%r10d
  a0af7c:	jne    a0af89 <pp_compile_macro+0x569>
  a0af7e:	mov    0x10(%rsp),%r10
  a0af83:	mov    0x8(%rsp),%edi
  a0af87:	jmp    a0afb4 <pp_compile_macro+0x594>
  a0af89:	mov    0x68(%rbp),%rax
  a0af8d:	mov    %r10d,%ecx
  a0af90:	shr    $0x6,%r10d
  a0af94:	mov    0x8(%rsp),%edi
  a0af98:	mov    (%rax,%r10,8),%rax
  a0af9c:	mov    0x10(%rsp),%r10
  a0afa1:	movzbl %dil,%edx
  a0afa5:	or     $0x10,%dil
  a0afa9:	movzbl %dil,%edi
  a0afad:	bt     %rcx,%rax
  a0afb1:	cmovae %edx,%edi
  a0afb4:	mov    0xe00(%r13),%eax
  a0afbb:	lea    0x3(%r15),%r11d
  a0afbf:	mov    $0x1,%edx
  a0afc4:	mov    $0x5,%r8b
  a0afc7:	xor    %r9d,%r9d
  a0afca:	jmp    a0adcc <pp_compile_macro+0x3ac>
  a0afcf:	mov    $0x2,%r8b
  a0afd2:	mov    %r10d,%r12d
  a0afd5:	jmp    a0adb9 <pp_compile_macro+0x399>
  a0afda:	cmp    $0xffffffff,%eax
  a0afdd:	je     a0b003 <pp_compile_macro+0x5e3>
  a0afdf:	mov    0x24(%r10),%edx
  a0afe3:	lea    -0x2b6244(%rip),%rcx        # 754da6 <pp_decode_file_name.meaning+0x1e20e>
  a0afea:	mov    $0x1,%esi
  a0afef:	mov    %r13,%rdi
  a0aff2:	xor    %eax,%eax
  a0aff4:	call   98a970 <pp_diagnose>
  a0aff9:	mov    0x10(%rsp),%r10
  a0affe:	jmp    a0b27a <pp_compile_macro+0x85a>
  a0b003:	mov    0xdf8(%r13),%rdx
  a0b00a:	mov    0x28(%r10),%esi
  a0b00e:	mov    0xe00(%r13),%r11d
  a0b015:	lea    0xdf8(%r13),%rax
  a0b01c:	mov    %rax,0x20(%rsp)
  a0b021:	lea    (%rdx,%rsi,8),%rbx
  a0b025:	sub    %esi,%r11d
  a0b028:	jne    a0b03a <pp_compile_macro+0x61a>
  a0b02a:	mov    $0x1,%al
  a0b02c:	movl   $0x0,0x18(%rsp)
  a0b034:	mov    %eax,0x3c(%rsp)
  a0b038:	jmp    a0b0b6 <pp_compile_macro+0x696>
  a0b03a:	mov    %r11d,%eax
  a0b03d:	mov    %rax,%rdi
  a0b040:	and    $0x3,%rdi
  a0b044:	mov    %rax,%rcx
  a0b047:	je     a0b0a2 <pp_compile_macro+0x682>
  a0b049:	mov    $0xffff,%r8d
  a0b04f:	mov    %rax,%rcx
  a0b052:	jmp    a0b071 <pp_compile_macro+0x651>
  a0b054:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0b060:	xor    %r9d,%r9d
  a0b063:	mov    %r9w,-0x6(%rbx,%rcx,8)
  a0b069:	dec    %rcx
  a0b06c:	dec    %rdi
  a0b06f:	je     a0b0a2 <pp_compile_macro+0x682>
  a0b071:	cmpb   $0x0,-0x8(%rbx,%rcx,8)
  a0b076:	jne    a0b069 <pp_compile_macro+0x649>
  a0b078:	cmp    %rax,%rcx
  a0b07b:	jae    a0b060 <pp_compile_macro+0x640>
  a0b07d:	cmpb   $0x0,(%rbx,%rcx,8)
  a0b081:	jne    a0b060 <pp_compile_macro+0x640>
  a0b083:	mov    -0x4(%rbx,%rcx,8),%r9d
  a0b088:	inc    %r9d
  a0b08b:	cmp    %r9d,0x4(%rbx,%rcx,8)
  a0b090:	jne    a0b060 <pp_compile_macro+0x640>
  a0b092:	movzwl 0x2(%rbx,%rcx,8),%r9d
  a0b098:	inc    %r9w
  a0b09c:	cmove  %r8d,%r9d
  a0b0a0:	jmp    a0b063 <pp_compile_macro+0x643>
  a0b0a2:	cmp    $0x4,%r11d
  a0b0a6:	jae    a0b0c7 <pp_compile_macro+0x6a7>
  a0b0a8:	mov    $0x1,%al
  a0b0aa:	movl   $0x0,0x3c(%rsp)
  a0b0b2:	mov    %eax,0x18(%rsp)
  a0b0b6:	mov    $0x1,%al
  a0b0b8:	mov    %eax,0x38(%rsp)
  a0b0bc:	mov    $0x1,%al
  a0b0be:	mov    %eax,0x8(%rsp)
  a0b0c2:	jmp    a0b2bf <pp_compile_macro+0x89f>
  a0b0c7:	lea    0x4(%rdx,%rsi,8),%rdx
  a0b0cc:	add    $0xfffffffffffffffe,%rcx
  a0b0d0:	mov    $0xffff,%esi
  a0b0d5:	jmp    a0b0f1 <pp_compile_macro+0x6d1>
  a0b0d7:	nopw   0x0(%rax,%rax,1)
  a0b0e0:	xor    %edi,%edi
  a0b0e2:	mov    %di,-0x12(%rdx,%rcx,8)
  a0b0e7:	add    $0xfffffffffffffffc,%rcx
  a0b0eb:	cmp    $0xfffffffffffffffe,%rcx
  a0b0ef:	je     a0b0a8 <pp_compile_macro+0x688>
  a0b0f1:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0b0f6:	je     a0b120 <pp_compile_macro+0x700>
  a0b0f8:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0b0fd:	je     a0b16e <pp_compile_macro+0x74e>
  a0b0ff:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0b104:	je     a0b1c2 <pp_compile_macro+0x7a2>
  a0b10a:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0b10f:	jne    a0b0e7 <pp_compile_macro+0x6c7>
  a0b111:	jmp    a0b212 <pp_compile_macro+0x7f2>
  a0b116:	cs nopw 0x0(%rax,%rax,1)
  a0b120:	lea    0x2(%rcx),%rdi
  a0b124:	cmp    %rax,%rdi
  a0b127:	jae    a0b160 <pp_compile_macro+0x740>
  a0b129:	cmpb   $0x0,0xc(%rdx,%rcx,8)
  a0b12e:	jne    a0b160 <pp_compile_macro+0x740>
  a0b130:	mov    0x8(%rdx,%rcx,8),%edi
  a0b134:	inc    %edi
  a0b136:	cmp    %edi,0x10(%rdx,%rcx,8)
  a0b13a:	jne    a0b160 <pp_compile_macro+0x740>
  a0b13c:	movzwl 0xe(%rdx,%rcx,8),%edi
  a0b141:	inc    %di
  a0b144:	cmove  %esi,%edi
  a0b147:	mov    %di,0x6(%rdx,%rcx,8)
  a0b14c:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0b151:	jne    a0b0ff <pp_compile_macro+0x6df>
  a0b153:	jmp    a0b16e <pp_compile_macro+0x74e>
  a0b155:	data16 cs nopw 0x0(%rax,%rax,1)
  a0b160:	xor    %edi,%edi
  a0b162:	mov    %di,0x6(%rdx,%rcx,8)
  a0b167:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0b16c:	jne    a0b0ff <pp_compile_macro+0x6df>
  a0b16e:	lea    0x1(%rcx),%rdi
  a0b172:	cmp    %rax,%rdi
  a0b175:	jae    a0b1b0 <pp_compile_macro+0x790>
  a0b177:	cmpb   $0x0,0x4(%rdx,%rcx,8)
  a0b17c:	jne    a0b1b0 <pp_compile_macro+0x790>
  a0b17e:	mov    (%rdx,%rcx,8),%edi
  a0b181:	inc    %edi
  a0b183:	cmp    %edi,0x8(%rdx,%rcx,8)
  a0b187:	jne    a0b1b0 <pp_compile_macro+0x790>
  a0b189:	movzwl 0x6(%rdx,%rcx,8),%edi
  a0b18e:	inc    %di
  a0b191:	cmove  %esi,%edi
  a0b194:	mov    %di,-0x2(%rdx,%rcx,8)
  a0b199:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0b19e:	jne    a0b10a <pp_compile_macro+0x6ea>
  a0b1a4:	jmp    a0b1c2 <pp_compile_macro+0x7a2>
  a0b1a6:	cs nopw 0x0(%rax,%rax,1)
  a0b1b0:	xor    %edi,%edi
  a0b1b2:	mov    %di,-0x2(%rdx,%rcx,8)
  a0b1b7:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0b1bc:	jne    a0b10a <pp_compile_macro+0x6ea>
  a0b1c2:	cmp    %rax,%rcx
  a0b1c5:	jae    a0b200 <pp_compile_macro+0x7e0>
  a0b1c7:	cmpb   $0x0,-0x4(%rdx,%rcx,8)
  a0b1cc:	jne    a0b200 <pp_compile_macro+0x7e0>
  a0b1ce:	mov    -0x8(%rdx,%rcx,8),%edi
  a0b1d2:	inc    %edi
  a0b1d4:	cmp    %edi,(%rdx,%rcx,8)
  a0b1d7:	jne    a0b200 <pp_compile_macro+0x7e0>
  a0b1d9:	movzwl -0x2(%rdx,%rcx,8),%edi
  a0b1de:	inc    %di
  a0b1e1:	cmove  %esi,%edi
  a0b1e4:	mov    %di,-0xa(%rdx,%rcx,8)
  a0b1e9:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0b1ee:	jne    a0b0e7 <pp_compile_macro+0x6c7>
  a0b1f4:	jmp    a0b212 <pp_compile_macro+0x7f2>
  a0b1f6:	cs nopw 0x0(%rax,%rax,1)
  a0b200:	xor    %edi,%edi
  a0b202:	mov    %di,-0xa(%rdx,%rcx,8)
  a0b207:	cmpb   $0x0,-0x14(%rdx,%rcx,8)
  a0b20c:	jne    a0b0e7 <pp_compile_macro+0x6c7>
  a0b212:	lea    -0x1(%rcx),%rdi
  a0b216:	cmp    %rax,%rdi
  a0b219:	jae    a0b0e0 <pp_compile_macro+0x6c0>
  a0b21f:	cmpb   $0x0,-0xc(%rdx,%rcx,8)
  a0b224:	jne    a0b0e0 <pp_compile_macro+0x6c0>
  a0b22a:	mov    -0x10(%rdx,%rcx,8),%edi
  a0b22e:	inc    %edi
  a0b230:	cmp    %edi,-0x8(%rdx,%rcx,8)
  a0b234:	jne    a0b0e0 <pp_compile_macro+0x6c0>
  a0b23a:	movzwl -0xa(%rdx,%rcx,8),%edi
  a0b23f:	inc    %di
  a0b242:	cmove  %esi,%edi
  a0b245:	jmp    a0b0e2 <pp_compile_macro+0x6c2>
  a0b24a:	mov    0x58(%rbp),%rax
  a0b24e:	mov    0x10(%rsp),%rbx
  a0b253:	cmp    %r8d,%r10d
  a0b256:	lea    -0x40fa21(%rip),%rcx        # 5fb83c <parse_test_openers+0x2f5c7>
  a0b25d:	mov    $0x1,%esi
  a0b262:	mov    %r13,%rdi
  a0b265:	adc    $0x0,%r15d
  a0b269:	mov    (%rax,%r15,4),%edx
  a0b26d:	xor    %eax,%eax
  a0b26f:	add    0x14(%rbx),%edx
  a0b272:	call   98a970 <pp_diagnose>
  a0b277:	mov    %rbx,%r10
  a0b27a:	mov    0x28(%r10),%ebx
  a0b27e:	mov    0xe00(%r13),%r11d
  a0b285:	lea    0xdf8(%r13),%rax
  a0b28c:	movl   $0x0,0x38(%rsp)
  a0b294:	movl   $0x0,0x8(%rsp)
  a0b29c:	mov    %rax,0x20(%rsp)
  a0b2a1:	mov    %ebx,%eax
  a0b2a3:	shl    $0x3,%rbx
  a0b2a7:	add    0xdf8(%r13),%rbx
  a0b2ae:	sub    %eax,%r11d
  a0b2b1:	setne  %al
  a0b2b4:	mov    %eax,0x18(%rsp)
  a0b2b8:	sete   %al
  a0b2bb:	mov    %eax,0x3c(%rsp)
  a0b2bf:	mov    $0xfffffffffffff560,%rcx
  a0b2c6:	mov    %r11,0x40(%rsp)
  a0b2cb:	mov    %fs:0x20(%rcx),%r14
  a0b2d0:	test   %r14,%r14
  a0b2d3:	je     a0b2df <pp_compile_macro+0x8bf>
  a0b2d5:	mov    %fs:0x28(%rcx),%r12
  a0b2da:	jmp    a0b397 <pp_compile_macro+0x977>
  a0b2df:	movabs $0x1000200000,%r15
  a0b2e9:	mov    $0x3,%edx
  a0b2ee:	mov    $0x4022,%ecx
  a0b2f3:	mov    $0xffffffff,%r8d
  a0b2f9:	xor    %r12d,%r12d
  a0b2fc:	xor    %edi,%edi
  a0b2fe:	xor    %r9d,%r9d
  a0b301:	mov    %r15,%rsi
  a0b304:	call   7cdcc0 <mmap@plt>
  a0b309:	cmp    $0xffffffffffffffff,%rax
  a0b30d:	je     a0b36b <pp_compile_macro+0x94b>
  a0b30f:	lea    0x20ffff(%rax),%r14
  a0b316:	mov    $0xf,%edx
  a0b31b:	mov    %rax,%rdi
  a0b31e:	and    $0xffffffffffe00000,%r14
  a0b325:	mov    %r14,%r12
  a0b328:	sub    %rax,%r12
  a0b32b:	lea    -0x10000(%r12),%rcx
  a0b333:	mov    %r12,%rsi
  a0b336:	mov    %rcx,0x28(%rsp)
  a0b33b:	call   7cdc70 <madvise@plt>
  a0b340:	mov    %r15,%rsi
  a0b343:	sub    %r12,%rsi
  a0b346:	mov    $0xe,%edx
  a0b34b:	mov    %r14,%rdi
  a0b34e:	call   7cdc70 <madvise@plt>
  a0b353:	mov    0x28(%rsp),%rax
  a0b358:	add    $0xffffffffffe00000,%r15
  a0b35f:	add    $0xffffffffffff0000,%r14
  a0b366:	mov    %r15,%r12
  a0b369:	jmp    a0b370 <pp_compile_macro+0x950>
  a0b36b:	xor    %r14d,%r14d
  a0b36e:	xor    %eax,%eax
  a0b370:	mov    $0xfffffffffffff560,%rcx
  a0b377:	mov    0x10(%rsp),%r10
  a0b37c:	mov    %r14,%fs:0x20(%rcx)
  a0b381:	movq   $0x0,%fs:0x28(%rcx)
  a0b38a:	mov    %r12,%fs:0x30(%rcx)
  a0b38f:	xor    %r12d,%r12d
  a0b392:	mov    %rax,%fs:0x38(%rcx)
  a0b397:	lea    0x7(%r12,%r14,1),%r15
  a0b39c:	lea    (%r12,%r14,1),%rax
  a0b3a0:	and    $0xfffffffffffffff8,%r15
  a0b3a4:	cmp    %rax,%r15
  a0b3a7:	jae    a0b3b0 <pp_compile_macro+0x990>
  a0b3a9:	xor    %eax,%eax
  a0b3ab:	xor    %r8d,%r8d
  a0b3ae:	jmp    a0b403 <pp_compile_macro+0x9e3>
  a0b3b0:	mov    %fs:0x30(%rcx),%rdi
  a0b3b5:	mov    %r15,%rsi
  a0b3b8:	sub    %r14,%rsi
  a0b3bb:	xor    %r8d,%r8d
  a0b3be:	mov    $0x0,%eax
  a0b3c3:	sub    %rsi,%rdi
  a0b3c6:	jb     a0b403 <pp_compile_macro+0x9e3>
  a0b3c8:	movzwl 0x8(%r10),%edx
  a0b3cd:	add    $0x3f,%edx
  a0b3d0:	shr    $0x3,%edx
  a0b3d3:	and    $0xfffffff8,%edx
  a0b3d6:	cmp    %rdi,%rdx
  a0b3d9:	ja     a0b403 <pp_compile_macro+0x9e3>
  a0b3db:	add    %rdx,%rsi
  a0b3de:	mov    %rsi,%fs:0x28(%rcx)
  a0b3e3:	test   %r15,%r15
  a0b3e6:	je     a0b3a9 <pp_compile_macro+0x989>
  a0b3e8:	mov    %r15,%rdi
  a0b3eb:	xor    %esi,%esi
  a0b3ed:	call   7cdab0 <memset@plt>
  a0b3f2:	mov    $0xfffffffffffff560,%rcx
  a0b3f9:	mov    0x10(%rsp),%r10
  a0b3fe:	mov    $0x1,%al
  a0b400:	mov    %r15,%r8
  a0b403:	mov    0x8(%rsp),%edx
  a0b407:	and    0x18(%rsp),%dl
  a0b40b:	cmp    $0x1,%dl
  a0b40e:	jne    a0b448 <pp_compile_macro+0xa28>
  a0b410:	movzbl (%rbx),%esi
  a0b413:	mov    %r8,0x28(%rsp)
  a0b418:	lea    -0x4(%rsi),%edx
  a0b41b:	cmp    $0x2,%edx
  a0b41e:	jae    a0b450 <pp_compile_macro+0xa30>
  a0b420:	xor    %r15d,%r15d
  a0b423:	testb  $0x2,0xf(%rsp)
  a0b428:	je     a0b49c <pp_compile_macro+0xa7c>
  a0b42a:	movzwl 0x8(%r10),%eax
  a0b42f:	mov    $0x3f,%edx
  a0b434:	dec    %eax
  a0b436:	cmp    $0x3f,%eax
  a0b439:	cmovb  %eax,%edx
  a0b43c:	mov    $0x1,%eax
  a0b441:	shlx   %rdx,%rax,%rax
  a0b446:	jmp    a0b49e <pp_compile_macro+0xa7e>
  a0b448:	xor    %r15d,%r15d
  a0b44b:	jmp    a0b645 <pp_compile_macro+0xc25>
  a0b450:	mov    $0xffffffff,%edx
  a0b455:	xor    %r15d,%r15d
  a0b458:	cmp    $0x1,%esi
  a0b45b:	jne    a0b4aa <pp_compile_macro+0xa8a>
  a0b45d:	cmpl   $0x2,0x40(%rsp)
  a0b462:	jae    a0ba4f <pp_compile_macro+0x102f>
  a0b468:	movzwl 0x2(%rbx),%esi
  a0b46c:	mov    $0x3f,%r8d
  a0b472:	mov    $0x1,%r9d
  a0b478:	movzwl %si,%edi
  a0b47b:	cmp    $0x3f,%edi
  a0b47e:	cmovb  %edi,%r8d
  a0b482:	shlx   %r8,%r9,%r9
  a0b487:	mov    $0x1,%r8b
  a0b48a:	or     %r9,0x38(%r10)
  a0b48e:	and    %al,%r8b
  a0b491:	cmp    $0x1,%r8b
  a0b495:	jne    a0b4aa <pp_compile_macro+0xa8a>
  a0b497:	jmp    a0ba93 <pp_compile_macro+0x1073>
  a0b49c:	xor    %eax,%eax
  a0b49e:	or     %rax,0x38(%r10)
  a0b4a2:	xor    %eax,%eax
  a0b4a4:	movzwl 0x2(%rbx),%edx
  a0b4a8:	inc    %edx
  a0b4aa:	mov    0x40(%rsp),%rsi
  a0b4af:	cmp    $0x2,%esi
  a0b4b2:	jb     a0b645 <pp_compile_macro+0xc25>
  a0b4b8:	mov    $0x2,%r10d
  a0b4be:	mov    $0x3f,%r8d
  a0b4c4:	mov    $0x1,%r9d
  a0b4ca:	mov    %esi,%esi
  a0b4cc:	jmp    a0b503 <pp_compile_macro+0xae3>
  a0b4ce:	xchg   %ax,%ax
  a0b4d0:	mov    0x10(%rsp),%rdx
  a0b4d5:	movzwl 0x8(%rdx),%eax
  a0b4d9:	dec    %eax
  a0b4db:	cmp    $0x3f,%eax
  a0b4de:	cmovae %r8d,%eax
  a0b4e2:	shlx   %rax,%r9,%rax
  a0b4e7:	or     %rax,0x38(%rdx)
  a0b4eb:	xor    %eax,%eax
  a0b4ed:	movzwl -0x6(%rbx,%r10,8),%edx
  a0b4f3:	add    %r10d,%edx
  a0b4f6:	cmp    %rsi,%r10
  a0b4f9:	lea    0x1(%r10),%r10
  a0b4fd:	jae    a0b645 <pp_compile_macro+0xc25>
  a0b503:	movzbl -0x8(%rbx,%r10,8),%r11d
  a0b509:	lea    -0x4(%r11),%r14d
  a0b50d:	cmp    $0x2,%r14d
  a0b511:	jae    a0b530 <pp_compile_macro+0xb10>
  a0b513:	testb  $0x2,0xf(%rsp)
  a0b518:	jne    a0b4d0 <pp_compile_macro+0xab0>
  a0b51a:	mov    0x10(%rsp),%rdx
  a0b51f:	xor    %eax,%eax
  a0b521:	jmp    a0b4e7 <pp_compile_macro+0xac7>
  a0b523:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0b530:	cmp    $0x1,%r11d
  a0b534:	jne    a0b4f6 <pp_compile_macro+0xad6>
  a0b536:	cmpb   $0x3,-0x10(%rbx,%r10,8)
  a0b53c:	je     a0b4f6 <pp_compile_macro+0xad6>
  a0b53e:	mov    %r15,%rcx
  a0b541:	cmp    %rsi,%r10
  a0b544:	jae    a0b57f <pp_compile_macro+0xb5f>
  a0b546:	mov    %edx,%r11d
  a0b549:	cmp    %r11,%r10
  a0b54c:	je     a0b57f <pp_compile_macro+0xb5f>
  a0b54e:	movzwl -0x6(%rbx,%r10,8),%r11d
  a0b554:	mov    $0x3f,%r13d
  a0b55a:	mov    $0x0,%edi
  a0b55f:	movzwl %r11w,%r14d
  a0b563:	cmp    $0x3f,%r14d
  a0b567:	cmovb  %r14d,%r13d
  a0b56b:	cmpb   $0x3,(%rbx,%r10,8)
  a0b570:	shlx   %r13,%r9,%r13
  a0b575:	setne  %r15b
  a0b579:	cmove  %rdi,%r13
  a0b57d:	jmp    a0b59f <pp_compile_macro+0xb7f>
  a0b57f:	movzwl -0x6(%rbx,%r10,8),%r11d
  a0b585:	mov    $0x3f,%r15d
  a0b58b:	movzwl %r11w,%r14d
  a0b58f:	cmp    $0x3f,%r14d
  a0b593:	cmovb  %r14d,%r15d
  a0b597:	shlx   %r15,%r9,%r13
  a0b59c:	mov    $0x1,%r15b
  a0b59f:	mov    0x10(%rsp),%rdi
  a0b5a4:	and    %al,%r15b
  a0b5a7:	or     %r13,0x38(%rdi)
  a0b5ab:	cmp    $0x1,%r15b
  a0b5af:	jne    a0b5c9 <pp_compile_macro+0xba9>
  a0b5b1:	mov    0x28(%rsp),%rdi
  a0b5b6:	mov    %r14d,%r15d
  a0b5b9:	shr    $0x6,%r15d
  a0b5bd:	mov    $0x1,%al
  a0b5bf:	mov    (%rdi,%r15,8),%r13
  a0b5c3:	bt     %r14,%r13
  a0b5c7:	jae    a0b5dd <pp_compile_macro+0xbbd>
  a0b5c9:	mov    %rcx,%r15
  a0b5cc:	mov    0x30(%rsp),%r13
  a0b5d1:	mov    $0xfffffffffffff560,%rcx
  a0b5d8:	jmp    a0b4f6 <pp_compile_macro+0xad6>
  a0b5dd:	shlx   %r14,%r9,%r14
  a0b5e2:	or     %r14,%r13
  a0b5e5:	mov    %r13,(%rdi,%r15,8)
  a0b5e9:	mov    0x30(%rsp),%r13
  a0b5ee:	mov    %rcx,%r15
  a0b5f1:	mov    0xe00(%r13),%r14d
  a0b5f8:	add    %r15d,%r14d
  a0b5fb:	cmp    $0x3ffffff,%r14d
  a0b602:	ja     a0b637 <pp_compile_macro+0xc17>
  a0b604:	mov    0x20(%rsp),%rdi
  a0b609:	mov    %r14d,%r14d
  a0b60c:	mov    (%rdi),%r15
  a0b60f:	movw   $0x1,(%r15,%r14,8)
  a0b616:	mov    %r11w,0x2(%r15,%r14,8)
  a0b61c:	movl   $0x0,0x4(%r15,%r14,8)
  a0b625:	mov    %rcx,%r15
  a0b628:	mov    $0xfffffffffffff560,%rcx
  a0b62f:	inc    %r15d
  a0b632:	jmp    a0b4f6 <pp_compile_macro+0xad6>
  a0b637:	mov    $0xfffffffffffff560,%rcx
  a0b63e:	xor    %eax,%eax
  a0b640:	jmp    a0b4f6 <pp_compile_macro+0xad6>
  a0b645:	cmp    %fs:0x28(%rcx),%r12
  a0b64a:	ja     a0bf5b <pp_compile_macro+0x153b>
  a0b650:	and    0x38(%rsp),%al
  a0b654:	mov    %r12,%fs:0x28(%rcx)
  a0b659:	mov    0x40(%rsp),%r12
  a0b65e:	xor    %ecx,%ecx
  a0b660:	mov    %eax,%esi
  a0b662:	and    0x18(%rsp),%sil
  a0b667:	mov    %eax,%edx
  a0b669:	cmp    $0x1,%sil
  a0b66d:	jne    a0b6c7 <pp_compile_macro+0xca7>
  a0b66f:	mov    $0x1,%edi
  a0b674:	mov    %r12d,%esi
  a0b677:	xor    %ecx,%ecx
  a0b679:	nopl   0x0(%rax)
  a0b680:	movzbl -0x8(%rbx,%rdi,8),%r8d
  a0b686:	mov    $0x0,%r9d
  a0b68c:	cmp    $0x2,%r8b
  a0b690:	setb   %dl
  a0b693:	test   %r8b,%r8b
  a0b696:	jne    a0b6b5 <pp_compile_macro+0xc95>
  a0b698:	mov    0x50(%rbp),%r9
  a0b69c:	mov    -0x4(%rbx,%rdi,8),%r10d
  a0b6a1:	movzbl (%r9,%r10,1),%r10d
  a0b6a6:	xor    %r9d,%r9d
  a0b6a9:	and    $0x7f,%r10b
  a0b6ad:	cmp    $0x1,%r10b
  a0b6b1:	sete   %r9b
  a0b6b5:	add    %r9d,%ecx
  a0b6b8:	cmp    $0x1,%r8b
  a0b6bc:	ja     a0b6c7 <pp_compile_macro+0xca7>
  a0b6be:	cmp    %rsi,%rdi
  a0b6c1:	lea    0x1(%rdi),%rdi
  a0b6c5:	jb     a0b680 <pp_compile_macro+0xc60>
  a0b6c7:	movq   $0x0,0x20(%rsp)
  a0b6d0:	test   %dl,%dl
  a0b6d2:	je     a0b72c <pp_compile_macro+0xd0c>
  a0b6d4:	mov    $0x0,%edx
  a0b6d9:	cmp    $0x10000,%ecx
  a0b6df:	jae    a0b72e <pp_compile_macro+0xd0e>
  a0b6e1:	mov    0xe00(%r13),%edx
  a0b6e8:	mov    %r15d,%esi
  a0b6eb:	mov    %ecx,%edi
  a0b6ed:	add    %rsi,%rdi
  a0b6f0:	add    %rdx,%rdi
  a0b6f3:	cmp    $0x4000001,%rdi
  a0b6fa:	setb   %dl
  a0b6fd:	mov    %edx,%esi
  a0b6ff:	and    0x18(%rsp),%sil
  a0b704:	cmp    $0x1,%sil
  a0b708:	jne    a0b72e <pp_compile_macro+0xd0e>
  a0b70a:	mov    %r12d,%r9d
  a0b70d:	mov    %r9d,%edi
  a0b710:	and    $0x3,%edi
  a0b713:	lea    -0x1(%r12),%esi
  a0b718:	cmp    $0x3,%esi
  a0b71b:	jae    a0b7d8 <pp_compile_macro+0xdb8>
  a0b721:	xor    %r10d,%r10d
  a0b724:	xor    %r8d,%r8d
  a0b727:	jmp    a0b9f0 <pp_compile_macro+0xfd0>
  a0b72c:	xor    %edx,%edx
  a0b72e:	test   %dl,%dl
  a0b730:	jne    a0b7b9 <pp_compile_macro+0xd99>
  a0b736:	mov    $0x0,%r8d
  a0b73c:	mov    $0x0,%edi
  a0b741:	mov    $0x0,%r10d
  a0b747:	test   %al,%al
  a0b749:	je     a0bb1a <pp_compile_macro+0x10fa>
  a0b74f:	mov    0x10(%rsp),%rsi
  a0b754:	cmp    $0x11,%r12d
  a0b758:	mov    $0x0,%edi
  a0b75d:	movq   $0x0,0x20(%rsp)
  a0b766:	setb   %r10b
  a0b76a:	and    0x4(%rsi),%r10b
  a0b76e:	mov    0x18(%rsp),%esi
  a0b772:	and    %r10b,%sil
  a0b775:	cmp    $0x1,%sil
  a0b779:	jne    a0bb1a <pp_compile_macro+0x10fa>
  a0b77f:	movzbl (%rbx),%r11d
  a0b783:	xor    %edi,%edi
  a0b785:	mov    %edx,0x18(%rsp)
  a0b789:	cmp    $0x2,%r11b
  a0b78d:	sete   %dil
  a0b791:	cmp    $0x3,%r11b
  a0b795:	jne    a0b92f <pp_compile_macro+0xf0f>
  a0b79b:	mov    $0x1,%edx
  a0b7a0:	movl   $0x0,0x28(%rsp)
  a0b7a8:	xor    %r10d,%r10d
  a0b7ab:	mov    %rdx,0x20(%rsp)
  a0b7b0:	mov    0x18(%rsp),%edx
  a0b7b4:	jmp    a0bb10 <pp_compile_macro+0x10f0>
  a0b7b9:	xor    %r8d,%r8d
  a0b7bc:	xor    %edi,%edi
  a0b7be:	xor    %r10d,%r10d
  a0b7c1:	xor    %r9d,%r9d
  a0b7c4:	or     %dl,%r10b
  a0b7c7:	mov    $0x0,%r11d
  a0b7cd:	jne    a0bb2c <pp_compile_macro+0x110c>
  a0b7d3:	jmp    a0bc27 <pp_compile_macro+0x1207>
  a0b7d8:	and    $0xfffffffc,%r9d
  a0b7dc:	xor    %r10d,%r10d
  a0b7df:	xor    %r8d,%r8d
  a0b7e2:	jmp    a0b7fd <pp_compile_macro+0xddd>
  a0b7e4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0b7f0:	add    $0x4,%r10
  a0b7f4:	cmp    %r10,%r9
  a0b7f7:	je     a0b9e7 <pp_compile_macro+0xfc7>
  a0b7fd:	cmpb   $0x0,(%rbx,%r10,8)
  a0b802:	jne    a0b840 <pp_compile_macro+0xe20>
  a0b804:	mov    0x50(%rbp),%r11
  a0b808:	mov    0x4(%rbx,%r10,8),%esi
  a0b80d:	movzbl (%r11,%rsi,1),%r11d
  a0b812:	and    $0x7f,%r11b
  a0b816:	cmp    $0x1,%r11b
  a0b81a:	jne    a0b840 <pp_compile_macro+0xe20>
  a0b81c:	lea    (%r8,%r15,1),%r14d
  a0b820:	mov    0xdf8(%r13),%r11
  a0b827:	add    0xe00(%r13),%r14d
  a0b82e:	inc    %r8d
  a0b831:	movl   $0x0,(%r11,%r14,8)
  a0b839:	mov    %esi,0x4(%r11,%r14,8)
  a0b83e:	xchg   %ax,%ax
  a0b840:	cmpb   $0x0,0x8(%rbx,%r10,8)
  a0b846:	jne    a0b890 <pp_compile_macro+0xe70>
  a0b848:	mov    0x50(%rbp),%r11
  a0b84c:	mov    0xc(%rbx,%r10,8),%esi
  a0b851:	movzbl (%r11,%rsi,1),%r11d
  a0b856:	and    $0x7f,%r11b
  a0b85a:	cmp    $0x1,%r11b
  a0b85e:	jne    a0b890 <pp_compile_macro+0xe70>
  a0b860:	lea    (%r8,%r15,1),%r14d
  a0b864:	mov    0xdf8(%r13),%r11
  a0b86b:	add    0xe00(%r13),%r14d
  a0b872:	inc    %r8d
  a0b875:	movl   $0x0,(%r11,%r14,8)
  a0b87d:	mov    %esi,0x4(%r11,%r14,8)
  a0b882:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0b890:	cmpb   $0x0,0x10(%rbx,%r10,8)
  a0b896:	jne    a0b8e0 <pp_compile_macro+0xec0>
  a0b898:	mov    0x50(%rbp),%r11
  a0b89c:	mov    0x14(%rbx,%r10,8),%esi
  a0b8a1:	movzbl (%r11,%rsi,1),%r11d
  a0b8a6:	and    $0x7f,%r11b
  a0b8aa:	cmp    $0x1,%r11b
  a0b8ae:	jne    a0b8e0 <pp_compile_macro+0xec0>
  a0b8b0:	lea    (%r8,%r15,1),%r14d
  a0b8b4:	mov    0xdf8(%r13),%r11
  a0b8bb:	add    0xe00(%r13),%r14d
  a0b8c2:	inc    %r8d
  a0b8c5:	movl   $0x0,(%r11,%r14,8)
  a0b8cd:	mov    %esi,0x4(%r11,%r14,8)
  a0b8d2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a0b8e0:	cmpb   $0x0,0x18(%rbx,%r10,8)
  a0b8e6:	jne    a0b7f0 <pp_compile_macro+0xdd0>
  a0b8ec:	mov    0x50(%rbp),%r11
  a0b8f0:	mov    0x1c(%rbx,%r10,8),%esi
  a0b8f5:	movzbl (%r11,%rsi,1),%r11d
  a0b8fa:	and    $0x7f,%r11b
  a0b8fe:	cmp    $0x1,%r11b
  a0b902:	jne    a0b7f0 <pp_compile_macro+0xdd0>
  a0b908:	lea    (%r8,%r15,1),%r14d
  a0b90c:	mov    0xdf8(%r13),%r11
  a0b913:	add    0xe00(%r13),%r14d
  a0b91a:	inc    %r8d
  a0b91d:	movl   $0x0,(%r11,%r14,8)
  a0b925:	mov    %esi,0x4(%r11,%r14,8)
  a0b92a:	jmp    a0b7f0 <pp_compile_macro+0xdd0>
  a0b92f:	setbe  %r10b
  a0b933:	movq   $0x0,0x20(%rsp)
  a0b93c:	cmp    $0x3,%r11b
  a0b940:	ja     a0bb08 <pp_compile_macro+0x10e8>
  a0b946:	cmp    $0x2,%r12d
  a0b94a:	jb     a0bb08 <pp_compile_macro+0x10e8>
  a0b950:	movzbl 0x8(%rbx),%r9d
  a0b955:	movq   $0x0,0x20(%rsp)
  a0b95e:	cmp    $0x4,%r9b
  a0b962:	setb   %r10b
  a0b966:	cmp    $0x3,%r9b
  a0b96a:	jne    a0be1c <pp_compile_macro+0x13fc>
  a0b970:	mov    $0x2,%edx
  a0b975:	xor    %r8d,%r8d
  a0b978:	mov    %rdx,0x20(%rsp)
  a0b97d:	cmp    $0x3,%r12d
  a0b981:	jb     a0be15 <pp_compile_macro+0x13f5>
  a0b987:	movzbl 0x10(%rbx),%esi
  a0b98b:	mov    0x18(%rsp),%edx
  a0b98f:	cmp    $0x2,%r11b
  a0b993:	setb   %r8b
  a0b997:	cmp    $0x2,%sil
  a0b99b:	setb   %r10b
  a0b99f:	and    %r8b,%r10b
  a0b9a2:	mov    $0x1,%r8d
  a0b9a8:	cmp    $0x1,%r10b
  a0b9ac:	jne    a0be19 <pp_compile_macro+0x13f9>
  a0b9b2:	testb  $0x2,0xf(%rsp)
  a0b9b7:	mov    $0x1,%r10b
  a0b9ba:	je     a0be1c <pp_compile_macro+0x13fc>
  a0b9c0:	cmp    $0x1,%sil
  a0b9c4:	jne    a0be1c <pp_compile_macro+0x13fc>
  a0b9ca:	mov    0x10(%rsp),%r10
  a0b9cf:	movzwl 0x12(%rbx),%esi
  a0b9d3:	movzwl 0x8(%r10),%r10d
  a0b9d8:	dec    %r10d
  a0b9db:	cmp    %esi,%r10d
  a0b9de:	setne  %r10b
  a0b9e2:	jmp    a0be1c <pp_compile_macro+0x13fc>
  a0b9e7:	test   %rdi,%rdi
  a0b9ea:	je     a0b72e <pp_compile_macro+0xd0e>
  a0b9f0:	lea    0x4(%rbx,%r10,8),%r9
  a0b9f5:	xor    %r10d,%r10d
  a0b9f8:	jmp    a0ba0c <pp_compile_macro+0xfec>
  a0b9fa:	nopw   0x0(%rax,%rax,1)
  a0ba00:	inc    %r10
  a0ba03:	cmp    %r10,%rdi
  a0ba06:	je     a0b72e <pp_compile_macro+0xd0e>
  a0ba0c:	cmpb   $0x0,-0x4(%r9,%r10,8)
  a0ba12:	jne    a0ba00 <pp_compile_macro+0xfe0>
  a0ba14:	mov    0x50(%rbp),%r11
  a0ba18:	mov    (%r9,%r10,8),%esi
  a0ba1c:	movzbl (%r11,%rsi,1),%r11d
  a0ba21:	and    $0x7f,%r11b
  a0ba25:	cmp    $0x1,%r11b
  a0ba29:	jne    a0ba00 <pp_compile_macro+0xfe0>
  a0ba2b:	lea    (%r8,%r15,1),%r14d
  a0ba2f:	mov    0xdf8(%r13),%r11
  a0ba36:	add    0xe00(%r13),%r14d
  a0ba3d:	inc    %r8d
  a0ba40:	movl   $0x0,(%r11,%r14,8)
  a0ba48:	mov    %esi,0x4(%r11,%r14,8)
  a0ba4d:	jmp    a0ba00 <pp_compile_macro+0xfe0>
  a0ba4f:	movzwl 0x2(%rbx),%esi
  a0ba53:	mov    $0x3f,%r10d
  a0ba59:	mov    $0x1,%r11d
  a0ba5f:	movzwl %si,%edi
  a0ba62:	cmp    $0x3f,%edi
  a0ba65:	cmovb  %edi,%r10d
  a0ba69:	xor    %r9d,%r9d
  a0ba6c:	cmpb   $0x3,0x8(%rbx)
  a0ba70:	shlx   %r10,%r11,%r10
  a0ba75:	cmovne %r10,%r9
  a0ba79:	mov    0x10(%rsp),%r10
  a0ba7e:	setne  %r8b
  a0ba82:	or     %r9,0x38(%r10)
  a0ba86:	and    %al,%r8b
  a0ba89:	cmp    $0x1,%r8b
  a0ba8d:	jne    a0b4aa <pp_compile_macro+0xa8a>
  a0ba93:	mov    0x28(%rsp),%r11
  a0ba98:	mov    %edi,%r8d
  a0ba9b:	shr    $0x6,%r8d
  a0ba9f:	mov    $0x1,%al
  a0baa1:	mov    (%r11,%r8,8),%r9
  a0baa5:	bt     %rdi,%r9
  a0baa9:	jb     a0b4aa <pp_compile_macro+0xa8a>
  a0baaf:	mov    $0x1,%r10d
  a0bab5:	xor    %r15d,%r15d
  a0bab8:	shlx   %rdi,%r10,%rdi
  a0babd:	or     %rdi,%r9
  a0bac0:	mov    %r9,(%r11,%r8,8)
  a0bac4:	mov    0xe00(%r13),%edi
  a0bacb:	cmp    $0x3ffffff,%rdi
  a0bad2:	ja     a0bf54 <pp_compile_macro+0x1534>
  a0bad8:	mov    0x20(%rsp),%rcx
  a0badd:	mov    $0x1,%r15d
  a0bae3:	mov    (%rcx),%r8
  a0bae6:	mov    $0xfffffffffffff560,%rcx
  a0baed:	movw   $0x1,(%r8,%rdi,8)
  a0baf4:	mov    %si,0x2(%r8,%rdi,8)
  a0bafa:	movl   $0x0,0x4(%r8,%rdi,8)
  a0bb03:	jmp    a0b4aa <pp_compile_macro+0xa8a>
  a0bb08:	movl   $0x0,0x28(%rsp)
  a0bb10:	mov    0x40(%rsp),%r12
  a0bb15:	mov    0x28(%rsp),%r8d
  a0bb1a:	xor    %r9d,%r9d
  a0bb1d:	or     %dl,%r10b
  a0bb20:	mov    $0x0,%r11d
  a0bb26:	je     a0bc27 <pp_compile_macro+0x1207>
  a0bb2c:	mov    0xe18(%r13),%r10
  a0bb33:	test   %r10,%r10
  a0bb36:	je     a0bc27 <pp_compile_macro+0x1207>
  a0bb3c:	cmp    $0x10,%r12d
  a0bb40:	ja     a0bc27 <pp_compile_macro+0x1207>
  a0bb46:	mov    0x10(%rsp),%rsi
  a0bb4b:	cmpw   $0x10,0x8(%rsi)
  a0bb50:	ja     a0bc27 <pp_compile_macro+0x1207>
  a0bb56:	mov    0xe20(%r13),%esi
  a0bb5d:	cmp    $0xfffff,%rsi
  a0bb64:	ja     a0bc27 <pp_compile_macro+0x1207>
  a0bb6a:	mov    %r8d,%r13d
  a0bb6d:	mov    0x20(%rsp),%r8
  a0bb72:	mov    %r15,0x18(%rsp)
  a0bb77:	imul   $0x110,%rsi,%r14
  a0bb7e:	vxorps %xmm0,%xmm0,%xmm0
  a0bb82:	vmovups %zmm0,0xc0(%r10,%r14,1)
  a0bb8a:	vmovups %zmm0,0x80(%r10,%r14,1)
  a0bb92:	vmovups %zmm0,0x40(%r10,%r14,1)
  a0bb9a:	vmovups %zmm0,(%r10,%r14,1)
  a0bba1:	movw   $0x0,0x100(%r10,%r14,1)
  a0bbac:	mov    %r8d,%r15d
  a0bbaf:	lea    (%r8,%r8,1),%r11d
  a0bbb3:	shr    $1,%r15d
  a0bbb6:	mov    %r8w,0x102(%r10,%r14,1)
  a0bbbf:	mov    %r13w,0x104(%r10,%r14,1)
  a0bbc8:	andn   %r11d,%r15d,%esi
  a0bbcd:	cmpb   $0x0,0x3c(%rsp)
  a0bbd2:	mov    %si,0x106(%r10,%r14,1)
  a0bbdb:	mov    %di,0x108(%r10,%r14,1)
  a0bbe4:	mov    %r12b,0x10a(%r10,%r14,1)
  a0bbec:	movl   $0x0,0x10b(%r10,%r14,1)
  a0bbf8:	movb   $0x0,0x10f(%r10,%r14,1)
  a0bc01:	je     a0bc9e <pp_compile_macro+0x127e>
  a0bc07:	mov    0x30(%rsp),%r13
  a0bc0c:	mov    0x40(%rsp),%r12
  a0bc11:	mov    0x18(%rsp),%r15
  a0bc16:	mov    0xe20(%r13),%r11d
  a0bc1d:	inc    %r11d
  a0bc20:	mov    %r11d,0xe20(%r13)
  a0bc27:	mov    0x10(%rsp),%r8
  a0bc2c:	mov    %eax,%esi
  a0bc2e:	mov    %edx,%edi
  a0bc30:	shl    $0x5,%sil
  a0bc34:	shl    $0x7,%dil
  a0bc38:	or     %sil,%dil
  a0bc3b:	mov    %r11d,0x34(%r8)
  a0bc3f:	or     %dil,0x4(%r8)
  a0bc43:	test   %al,%al
  a0bc45:	mov    0x38(%rsp),%eax
  a0bc49:	cmove  %r9d,%r15d
  a0bc4d:	test   %dl,%dl
  a0bc4f:	cmove  %r9d,%ecx
  a0bc53:	mov    %r15w,0xa(%r8)
  a0bc58:	mov    %cx,0xc(%r8)
  a0bc5d:	add    %r15d,%ecx
  a0bc60:	add    %ecx,0xe00(%r13)
  a0bc67:	shl    $0x2,%al
  a0bc6a:	or     %al,0x4(%r8)
  a0bc6e:	cmpb   $0x0,0x8(%rsp)
  a0bc73:	cmove  %r9d,%r12d
  a0bc77:	mov    %r12d,0x2c(%r8)
  a0bc7b:	jne    a0bc88 <pp_compile_macro+0x1268>
  a0bc7d:	mov    0x28(%r8),%eax
  a0bc81:	mov    %eax,0xe00(%r13)
  a0bc88:	mov    0x8(%rsp),%eax
  a0bc8c:	add    $0x48,%rsp
  a0bc90:	pop    %rbx
  a0bc91:	pop    %r12
  a0bc93:	pop    %r13
  a0bc95:	pop    %r14
  a0bc97:	pop    %r15
  a0bc99:	pop    %rbp
  a0bc9a:	vzeroupper
  a0bc9d:	ret
  a0bc9e:	add    %r14,%r10
  a0bca1:	mov    0x40(%rsp),%r14
  a0bca6:	or     %r8d,%r11d
  a0bca9:	xor    %edi,%edi
  a0bcab:	or     %r15d,%r11d
  a0bcae:	jmp    a0bcbe <pp_compile_macro+0x129e>
  a0bcb0:	movzwl 0x2(%rbx,%rsi,8),%edi
  a0bcb5:	lea    0x1(%rsi,%rdi,1),%edi
  a0bcb9:	cmp    %r14d,%edi
  a0bcbc:	jae    a0bcf9 <pp_compile_macro+0x12d9>
  a0bcbe:	mov    %dil,0x10b(%r10)
  a0bcc5:	mov    %edi,%esi
  a0bcc7:	xor    %r8d,%r8d
  a0bcca:	cmpb   $0x3,(%rbx,%rsi,8)
  a0bcce:	sete   %r8b
  a0bcd2:	sub    %r8d,%edi
  a0bcd5:	mov    %dil,0x10c(%r10)
  a0bcdc:	movzbl (%rbx,%rsi,8),%r8d
  a0bce1:	test   %r8b,%r8b
  a0bce4:	je     a0bcb0 <pp_compile_macro+0x1290>
  a0bce6:	xor    %edi,%edi
  a0bce8:	cmp    $0x3,%r8b
  a0bcec:	sete   %dil
  a0bcf0:	lea    0x1(%rsi,%rdi,1),%edi
  a0bcf4:	cmp    %r14d,%edi
  a0bcf7:	jb     a0bcbe <pp_compile_macro+0x129e>
  a0bcf9:	mov    $0x1,%r8d
  a0bcff:	mov    %r14d,%esi
  a0bd02:	xor    %edi,%edi
  a0bd04:	jmp    a0bd24 <pp_compile_macro+0x1304>
  a0bd06:	cs nopw 0x0(%rax,%rax,1)
  a0bd10:	or     %r12w,0xfc(%r10)
  a0bd18:	inc    %rdi
  a0bd1b:	cmp    %rdi,%rsi
  a0bd1e:	je     a0bc07 <pp_compile_macro+0x11e7>
  a0bd24:	mov    0x4(%rbx,%rdi,8),%r15d
  a0bd29:	mov    0x50(%rbp),%r14
  a0bd2d:	movzbl (%r14,%r15,1),%r14d
  a0bd32:	mov    %r15d,%r13d
  a0bd35:	shr    $0x6,%r13d
  a0bd39:	and    $0x7f,%r14b
  a0bd3d:	mov    %r14b,0xc0(%r10,%rdi,1)
  a0bd45:	mov    0x68(%rbp),%r12
  a0bd49:	mov    (%r12,%r13,8),%r12
  a0bd4d:	bt     %r15,%r12
  a0bd51:	setb   %r12b
  a0bd55:	or     $0x8,%r12b
  a0bd59:	mov    %r12b,0xd0(%r10,%rdi,1)
  a0bd61:	cmp    $0x1,%r14b
  a0bd65:	jne    a0bd80 <pp_compile_macro+0x1360>
  a0bd67:	mov    0x60(%rbp),%r12
  a0bd6b:	mov    0x10(%rsp),%r13
  a0bd70:	mov    (%r12,%r15,4),%r12d
  a0bd74:	jmp    a0bd91 <pp_compile_macro+0x1371>
  a0bd76:	cs nopw 0x0(%rax,%rax,1)
  a0bd80:	mov    0x60(%rbp),%r12
  a0bd84:	mov    0x10(%rsp),%r13
  a0bd89:	mov    (%r12,%r15,4),%r12d
  a0bd8d:	add    0x14(%r13),%r12d
  a0bd91:	mov    %r12d,(%r10,%rdi,4)
  a0bd95:	mov    0x58(%rbp),%r12
  a0bd99:	mov    (%r12,%r15,4),%r15d
  a0bd9d:	mov    $0x0,%r12d
  a0bda3:	add    0x14(%r13),%r15d
  a0bda7:	mov    %r15d,0x40(%r10,%rdi,4)
  a0bdac:	xor    %r15d,%r15d
  a0bdaf:	movzbl (%rbx,%rdi,8),%r13d
  a0bdb4:	dec    %r13b
  a0bdb7:	cmp    $0x1,%r13b
  a0bdbb:	ja     a0bdc3 <pp_compile_macro+0x13a3>
  a0bdbd:	movzbl 0x2(%rbx,%rdi,8),%r12d
  a0bdc3:	mov    %r12b,0xe0(%r10,%rdi,1)
  a0bdcb:	shlx   %edi,%r8d,%r12d
  a0bdd0:	cmpb   $0x1,(%rbx,%rdi,8)
  a0bdd4:	mov    %r12d,%r13d
  a0bdd7:	je     a0bddc <pp_compile_macro+0x13bc>
  a0bdd9:	xor    %r13d,%r13d
  a0bddc:	or     %r13w,0xf8(%r10)
  a0bde4:	xor    $0x1,%r14b
  a0bde8:	mov    %r12d,%r13d
  a0bdeb:	testb  $0x1,0x1(%rbx,%rdi,8)
  a0bdf0:	cmove  %r15d,%r13d
  a0bdf4:	or     %r13w,0xfa(%r10)
  a0bdfc:	test   %r11d,%r12d
  a0bdff:	cmovne %r15d,%r12d
  a0be03:	or     (%rbx,%rdi,8),%r14b
  a0be07:	je     a0bd10 <pp_compile_macro+0x12f0>
  a0be0d:	xor    %r12d,%r12d
  a0be10:	jmp    a0bd10 <pp_compile_macro+0x12f0>
  a0be15:	mov    0x18(%rsp),%edx
  a0be19:	xor    %r10d,%r10d
  a0be1c:	xor    %esi,%esi
  a0be1e:	cmp    $0x2,%r9b
  a0be22:	mov    %r8d,0x28(%rsp)
  a0be27:	sete   %sil
  a0be2b:	lea    (%rdi,%rsi,2),%edi
  a0be2e:	test   %r10b,%r10b
  a0be31:	je     a0bb10 <pp_compile_macro+0x10f0>
  a0be37:	cmp    $0x3,%r12d
  a0be3b:	jb     a0bb10 <pp_compile_macro+0x10f0>
  a0be41:	mov    %r12d,%r9d
  a0be44:	mov    $0x2,%r11d
  a0be4a:	mov    $0x3,%r12d
  a0be50:	movzbl -0x8(%rbx,%r12,8),%r14d
  a0be56:	mov    %r15,%r8
  a0be59:	cmp    $0x3,%r14b
  a0be5d:	jne    a0beb0 <pp_compile_macro+0x1490>
  a0be5f:	cmp    %r9,%r12
  a0be62:	jae    a0bed0 <pp_compile_macro+0x14b0>
  a0be64:	cmpb   $0x2,-0x10(%rbx,%r12,8)
  a0be6a:	movzbl (%rbx,%r12,8),%esi
  a0be6f:	setb   %r10b
  a0be73:	cmp    $0x2,%sil
  a0be77:	setb   %r15b
  a0be7b:	and    %r10b,%r15b
  a0be7e:	cmp    $0x1,%r15b
  a0be82:	jne    a0beda <pp_compile_macro+0x14ba>
  a0be84:	testb  $0x2,0xf(%rsp)
  a0be89:	mov    $0x1,%r10b
  a0be8c:	je     a0bedd <pp_compile_macro+0x14bd>
  a0be8e:	cmp    $0x1,%sil
  a0be92:	jne    a0bedd <pp_compile_macro+0x14bd>
  a0be94:	mov    0x10(%rsp),%r10
  a0be99:	movzwl 0x2(%rbx,%r12,8),%esi
  a0be9f:	movzwl 0x8(%r10),%r10d
  a0bea4:	dec    %r10d
  a0bea7:	cmp    %esi,%r10d
  a0beaa:	setne  %r10b
  a0beae:	jmp    a0bedd <pp_compile_macro+0x14bd>
  a0beb0:	lea    -0x1(%r12),%esi
  a0beb5:	mov    $0x1,%r15d
  a0bebb:	setbe  %r10b
  a0bebf:	inc    %r11
  a0bec2:	shlx   %esi,%r15d,%r15d
  a0bec7:	jmp    a0bf21 <pp_compile_macro+0x1501>
  a0bec9:	nopl   0x0(%rax)
  a0bed0:	lea    -0x1(%r12),%esi
  a0bed5:	xor    %r10d,%r10d
  a0bed8:	jmp    a0bf03 <pp_compile_macro+0x14e3>
  a0beda:	xor    %r10d,%r10d
  a0bedd:	mov    0x20(%rsp),%rdx
  a0bee2:	lea    -0x3(%r12),%esi
  a0bee7:	movzbl %sil,%esi
  a0beeb:	bt     %esi,%edx
  a0beee:	jb     a0bf00 <pp_compile_macro+0x14e0>
  a0bef0:	mov    0x28(%rsp),%edx
  a0bef4:	lea    -0x2(%r12),%esi
  a0bef9:	bts    %esi,%edx
  a0befc:	mov    %edx,0x28(%rsp)
  a0bf00:	mov    %r11d,%esi
  a0bf03:	mov    $0x1,%edx
  a0bf08:	inc    %r11
  a0bf0b:	shlx   %esi,%edx,%r15d
  a0bf10:	mov    0x20(%rsp),%rdx
  a0bf15:	bts    %esi,%edx
  a0bf18:	mov    %rdx,0x20(%rsp)
  a0bf1d:	mov    0x18(%rsp),%edx
  a0bf21:	cmp    $0x2,%r14b
  a0bf25:	mov    $0x0,%esi
  a0bf2a:	cmovne %esi,%r15d
  a0bf2e:	or     %r15d,%edi
  a0bf31:	test   %r10b,%r10b
  a0bf34:	je     a0bf4c <pp_compile_macro+0x152c>
  a0bf36:	mov    %r8,%r15
  a0bf39:	cmp    %r9,%r12
  a0bf3c:	lea    0x1(%r12),%r12
  a0bf41:	jb     a0be50 <pp_compile_macro+0x1430>
  a0bf47:	jmp    a0bb10 <pp_compile_macro+0x10f0>
  a0bf4c:	mov    %r8,%r15
  a0bf4f:	jmp    a0bb10 <pp_compile_macro+0x10f0>
  a0bf54:	xor    %eax,%eax
  a0bf56:	jmp    a0b4aa <pp_compile_macro+0xa8a>
  a0bf5b:	lea    -0x2d93e7(%rip),%rdi        # 732b7b <pp_string_value.meaning+0x7f5df>
  a0bf62:	lea    -0x329bbd(%rip),%rsi        # 6e23ac <pp_string_value.meaning+0x2ee10>
  a0bf69:	lea    -0x329ba9(%rip),%rcx        # 6e23c7 <pp_string_value.meaning+0x2ee2b>
  a0bf70:	mov    $0xce,%edx
  a0bf75:	call   7cd2d0 <__assert_fail@plt>
