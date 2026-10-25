


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000ad1ac0 <ir_typed_emit_function>:
  ad1ac0:	push   %rbp
  ad1ac1:	push   %r15
  ad1ac3:	push   %r14
  ad1ac5:	push   %r13
  ad1ac7:	push   %r12
  ad1ac9:	push   %rbx
  ad1aca:	sub    $0xd8,%rsp
  ad1ad1:	mov    0x10(%rcx),%eax
  ad1ad4:	mov    %rdi,0xb8(%rsp)
  ad1adc:	mov    %rcx,0x40(%rsp)
  ad1ae1:	mov    0x2c(%rcx),%ecx
  ad1ae4:	mov    0x30(%rsi),%edi
  ad1ae7:	mov    0x128(%rsp),%r14
  ad1aef:	mov    %r9,0x90(%rsp)
  ad1af7:	mov    %r8,0xc8(%rsp)
  ad1aff:	mov    %rsi,0x8(%rsp)
  ad1b04:	mov    %edx,0x54(%rsp)
  ad1b08:	mov    %rax,0xa8(%rsp)
  ad1b10:	mov    0x34(%rsi),%eax
  ad1b13:	mov    %rcx,0xb0(%rsp)
  ad1b1b:	mov    %rdi,0xa0(%rsp)
  ad1b23:	mov    %rax,0x78(%rsp)
  ad1b28:	lea    (%rcx,%rdi,1),%eax
  ad1b2b:	test   %r14,%r14
  ad1b2e:	je     ad1ca3 <ir_typed_emit_function+0x1e3>
  ad1b34:	mov    0x40(%r14),%rcx
  ad1b38:	movl   $0x0,(%rcx)
  ad1b3e:	mov    %dl,0xbc(%r14)
  ad1b45:	test   %eax,%eax
  ad1b47:	je     ad1cba <ir_typed_emit_function+0x1fa>
  ad1b4d:	mov    $0x1,%ecx
  ad1b52:	lea    -0x4f2f69(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad1b59:	lea    -0x4f2f80(%rip),%r12        # 5debe0 <ir_typed_types>
  ad1b60:	mov    %eax,%r15d
  ad1b63:	xor    %eax,%eax
  ad1b65:	jmp    ad1b9c <ir_typed_emit_function+0xdc>
  ad1b67:	nopw   0x0(%rax,%rax,1)
  ad1b70:	mov    0x8(%rsp),%rsi
  ad1b75:	xor    %r8d,%r8d
  ad1b78:	mov    $0x4,%r10b
  ad1b7b:	inc    %rax
  ad1b7e:	mov    %r9,(%rdi)
  ad1b81:	mov    %r11d,0x8(%rdi)
  ad1b85:	mov    %r8b,0xc(%rdi)
  ad1b89:	mov    %r10b,0xd(%rdi)
  ad1b8d:	movw   $0x0,0xe(%rdi)
  ad1b93:	cmp    %r15,%rax
  ad1b96:	je     ad1cbd <ir_typed_emit_function+0x1fd>
  ad1b9c:	mov    (%r14),%rdi
  ad1b9f:	mov    $0x8,%r8b
  ad1ba2:	movb   $0x28,(%rdi,%rax,1)
  ad1ba6:	mov    0x8(%r14),%rdi
  ad1baa:	movb   $0xa,(%rdi,%rax,1)
  ad1bae:	mov    0x20(%r14),%rdi
  ad1bb2:	mov    %eax,(%rdi,%rax,4)
  ad1bb5:	mov    0x28(%r14),%rdi
  ad1bb9:	movl   $0xffffffff,(%rdi,%rax,4)
  ad1bc0:	mov    0x30(%r14),%rdi
  ad1bc4:	movl   $0xffffffff,(%rdi,%rax,4)
  ad1bcb:	mov    0x18(%r14),%rdi
  ad1bcf:	movb   $0x0,(%rdi,%rax,1)
  ad1bd3:	mov    0x30(%rsi),%r10d
  ad1bd7:	cmp    %r10,%rax
  ad1bda:	jae    ad1c20 <ir_typed_emit_function+0x160>
  ad1bdc:	mov    0x20(%rsi),%r8
  ad1be0:	mov    0x88(%rsi),%rdi
  ad1be7:	movzbl (%r8,%rax,1),%r8d
  ad1bec:	test   %rdi,%rdi
  ad1bef:	je     ad1c20 <ir_typed_emit_function+0x160>
  ad1bf1:	mov    (%rdi,%rax,4),%r9d
  ad1bf5:	mov    %rax,%rdi
  ad1bf8:	shl    $0x4,%rdi
  ad1bfc:	add    0x70(%r14),%rdi
  ad1c00:	test   %r9,%r9
  ad1c03:	je     ad1c2b <ir_typed_emit_function+0x16b>
  ad1c05:	mov    0x90(%rsi),%r10
  ad1c0c:	movzbl (%r10,%rax,1),%r10d
  ad1c11:	shlx   %r10d,%ecx,%r11d
  ad1c16:	jmp    ad1c88 <ir_typed_emit_function+0x1c8>
  ad1c18:	nopl   0x0(%rax,%rax,1)
  ad1c20:	mov    %rax,%rdi
  ad1c23:	shl    $0x4,%rdi
  ad1c27:	add    0x70(%r14),%rdi
  ad1c2b:	movzbl %r8b,%r11d
  ad1c2f:	and    $0xf,%r11d
  ad1c33:	movzbl (%r11,%rdx,1),%r9d
  ad1c38:	cmp    $0x4,%r9d
  ad1c3c:	je     ad1c70 <ir_typed_emit_function+0x1b0>
  ad1c3e:	mov    $0x3,%ebx
  ad1c43:	cmp    $0x8,%r9d
  ad1c47:	je     ad1c56 <ir_typed_emit_function+0x196>
  ad1c49:	add    $0xfd,%r11b
  ad1c4d:	xor    %ebx,%ebx
  ad1c4f:	cmp    $0x2,%r11b
  ad1c53:	setb   %bl
  ad1c56:	shlx   %ebx,%ecx,%r11d
  ad1c5b:	cmp    %r10,%rax
  ad1c5e:	jae    ad1b70 <ir_typed_emit_function+0xb0>
  ad1c64:	jmp    ad1c83 <ir_typed_emit_function+0x1c3>
  ad1c66:	cs nopw 0x0(%rax,%rax,1)
  ad1c70:	mov    $0x2,%ebx
  ad1c75:	shlx   %ebx,%ecx,%r11d
  ad1c7a:	cmp    %r10,%rax
  ad1c7d:	jae    ad1b70 <ir_typed_emit_function+0xb0>
  ad1c83:	mov    0x8(%rsp),%rsi
  ad1c88:	mov    0x28(%rsi),%r10
  ad1c8c:	movzbl %r8b,%r8d
  ad1c90:	movzbl (%r8,%r12,1),%r8d
  ad1c95:	movzbl (%r10,%rax,1),%r10d
  ad1c9a:	and    $0x1,%r10b
  ad1c9e:	jmp    ad1b7b <ir_typed_emit_function+0xbb>
  ad1ca3:	test   %eax,%eax
  ad1ca5:	je     ad1dcd <ir_typed_emit_function+0x30d>
  ad1cab:	mov    %eax,%r15d
  ad1cae:	mov    0x34(%rsi),%eax
  ad1cb1:	test   %eax,%eax
  ad1cb3:	jne    ad1cc8 <ir_typed_emit_function+0x208>
  ad1cb5:	jmp    ad1ddd <ir_typed_emit_function+0x31d>
  ad1cba:	xor    %r15d,%r15d
  ad1cbd:	mov    0x34(%rsi),%eax
  ad1cc0:	test   %eax,%eax
  ad1cc2:	je     ad1ddd <ir_typed_emit_function+0x31d>
  ad1cc8:	lea    -0x4f30df(%rip),%rcx        # 5debf0 <tier0_class_bytes.bytes>
  ad1ccf:	lea    -0x4f30f6(%rip),%rdx        # 5debe0 <ir_typed_types>
  ad1cd6:	xor    %eax,%eax
  ad1cd8:	jmp    ad1cf3 <ir_typed_emit_function+0x233>
  ad1cda:	nopw   0x0(%rax,%rax,1)
  ad1ce0:	mov    0x34(%rsi),%edi
  ad1ce3:	add    $0x2,%r15
  ad1ce7:	inc    %rax
  ad1cea:	cmp    %rdi,%rax
  ad1ced:	jae    ad1ddd <ir_typed_emit_function+0x31d>
  ad1cf3:	mov    0x20(%rsi),%rdi
  ad1cf7:	movzbl (%rdi,%rax,1),%r10d
  ad1cfc:	test   %r14,%r14
  ad1cff:	je     ad1d4d <ir_typed_emit_function+0x28d>
  ad1d01:	movzbl (%r10,%rdx,1),%edi
  ad1d06:	mov    0xb0(%r14),%r8
  ad1d0d:	mov    %r15d,%r9d
  ad1d10:	mov    %dil,(%r8,%rax,1)
  ad1d14:	mov    (%r14),%r8
  ad1d17:	movb   $0x3,(%r8,%r9,1)
  ad1d1c:	mov    0x8(%r14),%r8
  ad1d20:	mov    %dil,(%r8,%r9,1)
  ad1d24:	mov    0x20(%r14),%rdi
  ad1d28:	mov    %eax,(%rdi,%r9,4)
  ad1d2c:	mov    0x28(%r14),%rdi
  ad1d30:	movl   $0xffffffff,(%rdi,%r9,4)
  ad1d38:	mov    0x30(%r14),%rdi
  ad1d3c:	movl   $0xffffffff,(%rdi,%r9,4)
  ad1d44:	mov    0x18(%r14),%rdi
  ad1d48:	movb   $0x0,(%rdi,%r9,1)
  ad1d4d:	and    $0xf,%r10d
  ad1d51:	movzbl (%r10,%rcx,1),%r8d
  ad1d56:	cmp    $0x4,%r8d
  ad1d5a:	je     ad1d80 <ir_typed_emit_function+0x2c0>
  ad1d5c:	mov    $0x3,%dil
  ad1d5f:	cmp    $0x8,%r8d
  ad1d63:	je     ad1d71 <ir_typed_emit_function+0x2b1>
  ad1d65:	add    $0xfd,%r10b
  ad1d69:	cmp    $0x2,%r10b
  ad1d6d:	setb   %dil
  ad1d71:	test   %r14,%r14
  ad1d74:	jne    ad1d8c <ir_typed_emit_function+0x2cc>
  ad1d76:	jmp    ad1ce0 <ir_typed_emit_function+0x220>
  ad1d7b:	nopl   0x0(%rax,%rax,1)
  ad1d80:	mov    $0x2,%dil
  ad1d83:	test   %r14,%r14
  ad1d86:	je     ad1ce0 <ir_typed_emit_function+0x220>
  ad1d8c:	mov    (%r14),%r8
  ad1d8f:	lea    0x1(%r15),%r9
  ad1d93:	mov    %r9d,%r9d
  ad1d96:	movb   $0x2c,(%r8,%r9,1)
  ad1d9b:	mov    0x8(%r14),%r8
  ad1d9f:	movb   $0x0,(%r8,%r9,1)
  ad1da4:	mov    0x20(%r14),%r8
  ad1da8:	mov    %eax,(%r8,%r9,4)
  ad1dac:	mov    0x28(%r14),%r8
  ad1db0:	mov    %r15d,(%r8,%r9,4)
  ad1db4:	mov    0x30(%r14),%r8
  ad1db8:	movl   $0xffffffff,(%r8,%r9,4)
  ad1dc0:	mov    0x18(%r14),%r8
  ad1dc4:	mov    %dil,(%r8,%r9,1)
  ad1dc8:	jmp    ad1ce0 <ir_typed_emit_function+0x220>
  ad1dcd:	mov    0x78(%rsp),%rax
  ad1dd2:	xor    %r15d,%r15d
  ad1dd5:	test   %eax,%eax
  ad1dd7:	jne    ad1cc8 <ir_typed_emit_function+0x208>
  ad1ddd:	test   %r14,%r14
  ad1de0:	je     ad1e1d <ir_typed_emit_function+0x35d>
  ad1de2:	mov    (%r14),%rax
  ad1de5:	mov    %r15d,%ecx
  ad1de8:	movb   $0x30,(%rax,%rcx,1)
  ad1dec:	mov    0x8(%r14),%rax
  ad1df0:	movb   $0x0,(%rax,%rcx,1)
  ad1df4:	mov    0x20(%r14),%rax
  ad1df8:	movl   $0x1,(%rax,%rcx,4)
  ad1dff:	mov    0x28(%r14),%rax
  ad1e03:	movl   $0xffffffff,(%rax,%rcx,4)
  ad1e0a:	mov    0x30(%r14),%rax
  ad1e0e:	movl   $0xffffffff,(%rax,%rcx,4)
  ad1e15:	mov    0x18(%r14),%rax
  ad1e19:	movb   $0x0,(%rax,%rcx,1)
  ad1e1d:	mov    0x40(%rsp),%rax
  ad1e22:	inc    %r15
  ad1e25:	cmpl   $0x0,0x10(%rax)
  ad1e29:	je     ad3d64 <ir_typed_emit_function+0x22a4>
  ad1e2f:	mov    0x118(%rsp),%r12
  ad1e37:	mov    0x120(%rsp),%r13
  ad1e3f:	xor    %ecx,%ecx
  ad1e41:	xor    %esi,%esi
  ad1e43:	xor    %r9d,%r9d
  ad1e46:	movq   $0x0,0x10(%rsp)
  ad1e4f:	xor    %edi,%edi
  ad1e51:	xor    %r8d,%r8d
  ad1e54:	lea    0xc(%r12),%rax
  ad1e59:	mov    %rax,0xc0(%rsp)
  ad1e61:	jmp    ad1ed4 <ir_typed_emit_function+0x414>
  ad1e63:	mov    $0xffffffff,%eax
  ad1e68:	test   %r14,%r14
  ad1e6b:	je     ad1ea4 <ir_typed_emit_function+0x3e4>
  ad1e6d:	mov    (%r14),%rcx
  ad1e70:	mov    %r15d,%edx
  ad1e73:	movb   $0x33,(%rcx,%rdx,1)
  ad1e77:	mov    0x8(%r14),%rcx
  ad1e7b:	movb   $0x0,(%rcx,%rdx,1)
  ad1e7f:	mov    0x20(%r14),%rcx
  ad1e83:	mov    %eax,(%rcx,%rdx,4)
  ad1e86:	mov    0x28(%r14),%rax
  ad1e8a:	movl   $0xffffffff,(%rax,%rdx,4)
  ad1e91:	mov    0x30(%r14),%rax
  ad1e95:	movl   $0xffffffff,(%rax,%rdx,4)
  ad1e9c:	mov    0x18(%r14),%rax
  ad1ea0:	movb   $0x0,(%rax,%rdx,1)
  ad1ea4:	inc    %r15
  ad1ea7:	mov    0x40(%rsp),%rax
  ad1eac:	mov    0xd0(%rsp),%rcx
  ad1eb4:	mov    0x38(%rsp),%rsi
  ad1eb9:	mov    0x60(%rsp),%rdi
  ad1ebe:	mov    0x20(%rsp),%r8
  ad1ec3:	mov    0x30(%rsp),%r9
  ad1ec8:	mov    0x10(%rax),%eax
  ad1ecb:	cmp    %rax,%rcx
  ad1ece:	jae    ad3cf3 <ir_typed_emit_function+0x2233>
  ad1ed4:	mov    %rcx,%r10
  ad1ed7:	mov    %rsi,0x38(%rsp)
  ad1edc:	mov    %rdi,0x60(%rsp)
  ad1ee1:	mov    %r8,0x20(%rsp)
  ad1ee6:	mov    %r9,0x30(%rsp)
  ad1eeb:	test   %r14,%r14
  ad1eee:	je     ad1f00 <ir_typed_emit_function+0x440>
  ad1ef0:	mov    0x40(%r14),%rax
  ad1ef4:	lea    0x1(%r10),%rsi
  ad1ef8:	mov    %r15d,0x4(%rax,%r10,4)
  ad1efd:	jmp    ad1f04 <ir_typed_emit_function+0x444>
  ad1eff:	nop
  ad1f00:	lea    0x1(%r10),%rsi
  ad1f04:	mov    0x40(%rsp),%rdx
  ad1f09:	mov    %rsi,0xd0(%rsp)
  ad1f11:	mov    %r10,0x58(%rsp)
  ad1f16:	mov    %r13,%rdi
  ad1f19:	mov    (%rdx),%rax
  ad1f1c:	mov    0x18(%rdx),%rcx
  ad1f20:	mov    (%rcx,%r10,4),%ebp
  ad1f24:	mov    (%rax,%r10,4),%r12d
  ad1f28:	mov    (%rax,%rsi,4),%eax
  ad1f2b:	mov    0xc8(%rsp),%rsi
  ad1f33:	mov    0x20(%rdx),%rcx
  ad1f37:	test   %rbp,%rbp
  ad1f3a:	mov    (%rsi),%rsi
  ad1f3d:	mov    %rax,0x98(%rsp)
  ad1f45:	mov    %rbp,%rdx
  ad1f48:	setne  %bl
  ad1f4b:	add    (%rcx,%r10,8),%rsi
  ad1f4f:	call   7c41e0 <memcpy@plt>
  ad1f54:	mov    0x8(%rsp),%rax
  ad1f59:	mov    %r12,%r9
  ad1f5c:	cmp    0x18(%rax),%r9d
  ad1f60:	setb   %al
  ad1f63:	and    %bl,%al
  ad1f65:	cmp    $0x1,%al
  ad1f67:	jne    ad1f90 <ir_typed_emit_function+0x4d0>
  ad1f69:	mov    0x8(%rsp),%rbx
  ad1f6e:	mov    0x118(%rsp),%r12
  ad1f76:	cmp    $0x1,%ebp
  ad1f79:	jne    ad1fb0 <ir_typed_emit_function+0x4f0>
  ad1f7b:	xor    %eax,%eax
  ad1f7d:	jmp    ad2142 <ir_typed_emit_function+0x682>
  ad1f82:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  ad1f90:	mov    0x8(%rsp),%rbx
  ad1f95:	mov    0x118(%rsp),%r12
  ad1f9d:	jmp    ad21c6 <ir_typed_emit_function+0x706>
  ad1fa2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  ad1fb0:	mov    %ebp,%ecx
  ad1fb2:	and    $0xfffffffe,%ecx
  ad1fb5:	xor    %eax,%eax
  ad1fb7:	mov    %r9,0x68(%rsp)
  ad1fbc:	jmp    ad2021 <ir_typed_emit_function+0x561>
  ad1fbe:	xchg   %ax,%ax
  ad1fc0:	mov    $0x3,%r8b
  ad1fc3:	test   %r14,%r14
  ad1fc6:	je     ad200d <ir_typed_emit_function+0x54d>
  ad1fc8:	mov    (%r14),%r10
  ad1fcb:	lea    0x1(%r15,%rax,1),%r9
  ad1fd0:	lea    0x1(%rax,%rdi,1),%rdi
  ad1fd5:	mov    %r9d,%r9d
  ad1fd8:	movb   $0x2b,(%r10,%r9,1)
  ad1fdd:	mov    0x8(%r14),%r10
  ad1fe1:	mov    %sil,(%r10,%r9,1)
  ad1fe5:	mov    0x20(%r14),%rsi
  ad1fe9:	mov    %edi,(%rsi,%r9,4)
  ad1fed:	mov    0x28(%r14),%rsi
  ad1ff1:	movl   $0xffffffff,(%rsi,%r9,4)
  ad1ff9:	mov    0x30(%r14),%rsi
  ad1ffd:	movl   $0xffffffff,(%rsi,%r9,4)
  ad2005:	mov    0x18(%r14),%rsi
  ad2009:	mov    %r8b,(%rsi,%r9,1)
  ad200d:	inc    %edx
  ad200f:	mov    %edx,0x4(%r12,%rax,4)
  ad2014:	add    $0x2,%rax
  ad2018:	cmp    %rax,%rcx
  ad201b:	je     ad2130 <ir_typed_emit_function+0x670>
  ad2021:	movzbl 0x0(%r13,%rax,1),%edi
  ad2027:	lea    -0x4f343e(%rip),%rsi        # 5debf0 <tier0_class_bytes.bytes>
  ad202e:	mov    %edi,%edx
  ad2030:	and    $0xf,%edx
  ad2033:	movzbl (%rdx,%rsi,1),%r8d
  ad2038:	cmp    $0x4,%r8d
  ad203c:	je     ad20f0 <ir_typed_emit_function+0x630>
  ad2042:	mov    $0x3,%sil
  ad2045:	cmp    $0x8,%r8d
  ad2049:	je     ad2055 <ir_typed_emit_function+0x595>
  ad204b:	add    $0xfd,%dl
  ad204e:	cmp    $0x2,%dl
  ad2051:	setb   %sil
  ad2055:	lea    (%r15,%rax,1),%rdx
  ad2059:	lea    -0x4f3480(%rip),%r11        # 5debe0 <ir_typed_types>
  ad2060:	test   %r14,%r14
  ad2063:	je     ad20ac <ir_typed_emit_function+0x5ec>
  ad2065:	mov    (%r14),%r9
  ad2068:	mov    0x30(%rbx),%r8d
  ad206c:	movzbl (%rdi,%r11,1),%edi
  ad2071:	mov    %edx,%r10d
  ad2074:	movb   $0x2b,(%r9,%r10,1)
  ad2079:	add    %rax,%r8
  ad207c:	mov    0x8(%r14),%r9
  ad2080:	mov    %dil,(%r9,%r10,1)
  ad2084:	mov    0x20(%r14),%rdi
  ad2088:	mov    %r8d,(%rdi,%r10,4)
  ad208c:	mov    0x28(%r14),%rdi
  ad2090:	movl   $0xffffffff,(%rdi,%r10,4)
  ad2098:	mov    0x30(%r14),%rdi
  ad209c:	movl   $0xffffffff,(%rdi,%r10,4)
  ad20a4:	mov    0x18(%r14),%rdi
  ad20a8:	mov    %sil,(%rdi,%r10,1)
  ad20ac:	mov    %edx,(%r12,%rax,4)
  ad20b0:	lea    -0x4f34c7(%rip),%r9        # 5debf0 <tier0_class_bytes.bytes>
  ad20b7:	movzbl 0x1(%r13,%rax,1),%r8d
  ad20bd:	mov    0x30(%rbx),%edi
  ad20c0:	movzbl (%r8,%r11,1),%esi
  ad20c5:	and    $0xf,%r8d
  ad20c9:	movzbl (%r8,%r9,1),%r9d
  ad20ce:	cmp    $0x8,%r9d
  ad20d2:	je     ad1fc0 <ir_typed_emit_function+0x500>
  ad20d8:	cmp    $0x4,%r9d
  ad20dc:	jne    ad2110 <ir_typed_emit_function+0x650>
  ad20de:	mov    $0x2,%r8b
  ad20e1:	test   %r14,%r14
  ad20e4:	jne    ad1fc8 <ir_typed_emit_function+0x508>
  ad20ea:	jmp    ad200d <ir_typed_emit_function+0x54d>
  ad20ef:	nop
  ad20f0:	mov    $0x2,%sil
  ad20f3:	lea    (%r15,%rax,1),%rdx
  ad20f7:	lea    -0x4f351e(%rip),%r11        # 5debe0 <ir_typed_types>
  ad20fe:	test   %r14,%r14
  ad2101:	jne    ad2065 <ir_typed_emit_function+0x5a5>
  ad2107:	jmp    ad20ac <ir_typed_emit_function+0x5ec>
  ad2109:	nopl   0x0(%rax)
  ad2110:	add    $0xfd,%r8b
  ad2114:	cmp    $0x2,%r8b
  ad2118:	setb   %r8b
  ad211c:	test   %r14,%r14
  ad211f:	jne    ad1fc8 <ir_typed_emit_function+0x508>
  ad2125:	jmp    ad200d <ir_typed_emit_function+0x54d>
  ad212a:	nopw   0x0(%rax,%rax,1)
  ad2130:	mov    0x68(%rsp),%r9
  ad2135:	add    %rax,%r15
  ad2138:	test   $0x1,%bpl
  ad213c:	je     ad21c6 <ir_typed_emit_function+0x706>
  ad2142:	movzbl 0x0(%r13,%rax,1),%ecx
  ad2148:	lea    -0x4f355f(%rip),%rsi        # 5debf0 <tier0_class_bytes.bytes>
  ad214f:	mov    %ecx,%edx
  ad2151:	and    $0xf,%edx
  ad2154:	movzbl (%rdx,%rsi,1),%esi
  ad2158:	cmp    $0x8,%esi
  ad215b:	je     ad3aa2 <ir_typed_emit_function+0x1fe2>
  ad2161:	cmp    $0x4,%esi
  ad2164:	jne    ad3ab2 <ir_typed_emit_function+0x1ff2>
  ad216a:	mov    $0x2,%dl
  ad216c:	test   %r14,%r14
  ad216f:	je     ad21bc <ir_typed_emit_function+0x6fc>
  ad2171:	mov    (%r14),%rdi
  ad2174:	lea    -0x4f359b(%rip),%rsi        # 5debe0 <ir_typed_types>
  ad217b:	mov    %r15d,%r8d
  ad217e:	movzbl (%rcx,%rsi,1),%ecx
  ad2182:	mov    0x30(%rbx),%esi
  ad2185:	movb   $0x2b,(%rdi,%r8,1)
  ad218a:	mov    0x8(%r14),%rdi
  ad218e:	add    %eax,%esi
  ad2190:	mov    %cl,(%rdi,%r8,1)
  ad2194:	mov    0x20(%r14),%rcx
  ad2198:	mov    %esi,(%rcx,%r8,4)
  ad219c:	mov    0x28(%r14),%rcx
  ad21a0:	movl   $0xffffffff,(%rcx,%r8,4)
  ad21a8:	mov    0x30(%r14),%rcx
  ad21ac:	movl   $0xffffffff,(%rcx,%r8,4)
  ad21b4:	mov    0x18(%r14),%rcx
  ad21b8:	mov    %dl,(%rcx,%r8,1)
  ad21bc:	mov    %r15d,%ecx
  ad21bf:	inc    %r15
  ad21c2:	mov    %ecx,(%r12,%rax,4)
  ad21c6:	cmp    0x98(%rsp),%r9d
  ad21ce:	jae    ad39f0 <ir_typed_emit_function+0x1f30>
  ad21d4:	mov    0x58(%rsp),%rax
  ad21d9:	lea    -0x4f35f0(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad21e0:	mov    %r9,%rcx
  ad21e3:	movl   $0x0,0x28(%rsp)
  ad21eb:	mov    %r9,0x68(%rsp)
  ad21f0:	add    $0x2,%eax
  ad21f3:	mov    %eax,0x74(%rsp)
  ad21f7:	jmp    ad2211 <ir_typed_emit_function+0x751>
  ad21f9:	dec    %ebp
  ad21fb:	nopl   0x0(%rax,%rax,1)
  ad2200:	inc    %rcx
  ad2203:	cmp    0x98(%rsp),%rcx
  ad220b:	je     ad3a00 <ir_typed_emit_function+0x1f40>
  ad2211:	mov    (%rbx),%rax
  ad2214:	mov    0x8(%rbx),%rsi
  ad2218:	mov    0x110(%rsp),%rdi
  ad2220:	movzbl (%rax,%rcx,1),%r10d
  ad2225:	movzbl (%rsi,%rcx,1),%r9d
  ad222a:	movzbl (%rdi,%rcx,1),%r11d
  ad222f:	movzbl %r9b,%esi
  ad2233:	lea    -0x1(%r10),%eax
  ad2237:	cmp    $0x28,%eax
  ad223a:	ja     ad2abd <ir_typed_emit_function+0xffd>
  ad2240:	mov    0x10(%rbx),%r8
  ad2244:	lea    -0x5dfa73(%rip),%rdi        # 4f27d8 <check_builtin_atomic_rmw_test_clang.native_source+0x6e18>
  ad224b:	movslq (%rdi,%rax,4),%rax
  ad224f:	mov    (%r8,%rcx,8),%r8
  ad2253:	add    %rdi,%rax
  ad2256:	jmp    *%rax
  ad2258:	mov    %r10d,%eax
  ad225b:	and    $0xfe,%al
  ad225d:	cmp    $0x1e,%al
  ad225f:	jne    ad2552 <ir_typed_emit_function+0xa92>
  ad2265:	mov    %rbp,%r11
  ad2268:	dec    %ebp
  ad226a:	and    $0xf,%esi
  ad226d:	mov    (%r12,%rbp,4),%eax
  ad2271:	movzbl (%rsi,%rdx,1),%r9d
  ad2276:	cmp    $0x4,%r9d
  ad227a:	je     ad2bf4 <ir_typed_emit_function+0x1134>
  ad2280:	mov    $0x3,%dil
  ad2283:	cmp    $0x8,%r9d
  ad2287:	je     ad25a0 <ir_typed_emit_function+0xae0>
  ad228d:	add    $0xfd,%sil
  ad2291:	cmp    $0x2,%sil
  ad2295:	setb   %dil
  ad2299:	test   %r14,%r14
  ad229c:	jne    ad25a5 <ir_typed_emit_function+0xae5>
  ad22a2:	jmp    ad25dd <ir_typed_emit_function+0xb1d>
  ad22a7:	dec    %ebp
  ad22a9:	test   %r14,%r14
  ad22ac:	je     ad2bac <ir_typed_emit_function+0x10ec>
  ad22b2:	mov    0x10(%rsp),%rdi
  ad22b7:	mov    0x60(%r14),%rax
  ad22bb:	vxorps %xmm0,%xmm0,%xmm0
  ad22bf:	mov    %edi,%esi
  ad22c1:	shl    $0x4,%rsi
  ad22c5:	vmovups %xmm0,(%rax,%rsi,1)
  ad22ca:	mov    %r15d,%esi
  ad22cd:	mov    (%r14),%rax
  ad22d0:	movb   $0x1,(%rax,%rsi,1)
  ad22d4:	mov    0x8(%r14),%rax
  ad22d8:	mov    %r11b,(%rax,%rsi,1)
  ad22dc:	mov    0x20(%r14),%rax
  ad22e0:	mov    %edi,(%rax,%rsi,4)
  ad22e3:	mov    0x28(%r14),%rax
  ad22e7:	movl   $0xffffffff,(%rax,%rsi,4)
  ad22ee:	mov    0x30(%r14),%rax
  ad22f2:	movl   $0xffffffff,(%rax,%rsi,4)
  ad22f9:	mov    0x18(%r14),%rax
  ad22fd:	movb   $0x0,(%rax,%rsi,1)
  ad2301:	lea    0x1(%r15),%rsi
  ad2305:	mov    %ebp,%eax
  ad2307:	mov    %rax,0x28(%rsp)
  ad230c:	mov    (%r14),%rdi
  ad230f:	mov    (%r12,%rax,4),%eax
  ad2313:	mov    %esi,%r9d
  ad2316:	movb   $0x19,(%rdi,%r9,1)
  ad231b:	mov    0x8(%r14),%rdi
  ad231f:	movb   $0x1,(%rdi,%r9,1)
  ad2324:	mov    0x20(%r14),%rdi
  ad2328:	mov    %eax,(%rdi,%r9,4)
  ad232c:	mov    0x28(%r14),%rax
  ad2330:	mov    %r15d,(%rax,%r9,4)
  ad2334:	mov    0x30(%r14),%rax
  ad2338:	movl   $0x1,(%rax,%r9,4)
  ad2340:	mov    0x18(%r14),%rax
  ad2344:	movb   $0x0,(%rax,%r9,1)
  ad2349:	lea    0x1(%rsi),%rax
  ad234d:	mov    %rsi,0x48(%rsp)
  ad2352:	test   %ebp,%ebp
  ad2354:	je     ad2bc8 <ir_typed_emit_function+0x1108>
  ad235a:	mov    0x30(%rbx),%edi
  ad235d:	mov    0x28(%rsp),%rsi
  ad2362:	cmp    $0x1,%esi
  ad2365:	jne    ad2c05 <ir_typed_emit_function+0x1145>
  ad236b:	mov    0x10(%rsp),%r15
  ad2370:	xor    %r9d,%r9d
  ad2373:	jmp    ad2d9d <ir_typed_emit_function+0x12dd>
  ad2378:	test   %ebp,%ebp
  ad237a:	je     ad305f <ir_typed_emit_function+0x159f>
  ad2380:	mov    0x30(%rbx),%esi
  ad2383:	cmp    $0x1,%ebp
  ad2386:	jne    ad2e8b <ir_typed_emit_function+0x13cb>
  ad238c:	xor    %edi,%edi
  ad238e:	jmp    ad2ff5 <ir_typed_emit_function+0x1535>
  ad2393:	test   %r14,%r14
  ad2396:	je     ad2bd2 <ir_typed_emit_function+0x1112>
  ad239c:	mov    (%r14),%rsi
  ad239f:	mov    %r11d,%edi
  ad23a2:	mov    %r15d,%r11d
  ad23a5:	mov    %r15d,%eax
  ad23a8:	inc    %r15
  ad23ab:	movb   $0x29,(%rsi,%r11,1)
  ad23b0:	mov    0x8(%r14),%rsi
  ad23b4:	movb   $0xa,(%rsi,%r11,1)
  ad23b9:	mov    0x20(%r14),%rsi
  ad23bd:	mov    %r8d,(%rsi,%r11,4)
  ad23c1:	mov    0x28(%r14),%rsi
  ad23c5:	movl   $0xffffffff,(%rsi,%r11,4)
  ad23cd:	mov    0x30(%r14),%rsi
  ad23d1:	movl   $0xffffffff,(%rsi,%r11,4)
  ad23d9:	mov    0x18(%r14),%rsi
  ad23dd:	movb   $0x0,(%rsi,%r11,1)
  ad23e2:	xor    %esi,%esi
  ad23e4:	cmp    $0x4,%r10d
  ad23e8:	mov    %r15d,%r10d
  ad23eb:	mov    (%r14),%r8
  ad23ee:	sete   %sil
  ad23f2:	lea    0x26(%rsi,%rsi,4),%esi
  ad23f6:	mov    %sil,(%r8,%r10,1)
  ad23fa:	mov    0x8(%r14),%rsi
  ad23fe:	mov    %dil,(%rsi,%r10,1)
  ad2402:	mov    0x20(%r14),%rsi
  ad2406:	mov    %eax,(%rsi,%r10,4)
  ad240a:	mov    0x28(%r14),%rax
  ad240e:	movl   $0xffffffff,(%rax,%r10,4)
  ad2416:	mov    0x30(%r14),%rax
  ad241a:	movl   $0xffffffff,(%rax,%r10,4)
  ad2422:	mov    0x18(%r14),%rax
  ad2426:	movb   $0x0,(%rax,%r10,1)
  ad242b:	jmp    ad345f <ir_typed_emit_function+0x199f>
  ad2430:	mov    %rbp,%rsi
  ad2433:	dec    %ebp
  ad2435:	add    $0xfffffffe,%esi
  ad2438:	mov    (%r12,%rbp,4),%eax
  ad243c:	test   %r14,%r14
  ad243f:	je     ad2bda <ir_typed_emit_function+0x111a>
  ad2445:	mov    (%r14),%r8
  ad2448:	mov    %rsi,%rdi
  ad244b:	mov    (%r12,%rsi,4),%esi
  ad244f:	mov    %r15d,%r11d
  ad2452:	mov    %r9d,%edx
  ad2455:	mov    %r15d,%r9d
  ad2458:	inc    %r15
  ad245b:	movb   $0x25,(%r8,%r11,1)
  ad2460:	mov    0x8(%r14),%r8
  ad2464:	movb   $0xa,(%r8,%r11,1)
  ad2469:	mov    0x20(%r14),%r8
  ad246d:	mov    %esi,(%r8,%r11,4)
  ad2471:	mov    %r15d,%r8d
  ad2474:	mov    0x28(%r14),%rsi
  ad2478:	movl   $0xffffffff,(%rsi,%r11,4)
  ad2480:	mov    0x30(%r14),%rsi
  ad2484:	movl   $0xffffffff,(%rsi,%r11,4)
  ad248c:	mov    0x18(%r14),%rsi
  ad2490:	movb   $0x0,(%rsi,%r11,1)
  ad2495:	mov    (%r14),%rsi
  ad2498:	movb   $0x2c,(%rsi,%r8,1)
  ad249d:	mov    0x8(%r14),%rsi
  ad24a1:	movb   $0x0,(%rsi,%r8,1)
  ad24a6:	mov    0x20(%r14),%rsi
  ad24aa:	mov    %r9d,(%rsi,%r8,4)
  ad24ae:	mov    %edx,%r9d
  ad24b1:	lea    -0x4f38c8(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad24b8:	mov    0x28(%r14),%rsi
  ad24bc:	mov    %eax,(%rsi,%r8,4)
  ad24c0:	mov    0x30(%r14),%rsi
  ad24c4:	movl   $0xffffffff,(%rsi,%r8,4)
  ad24cc:	mov    0x18(%r14),%rsi
  ad24d0:	movb   $0x0,(%rsi,%r8,1)
  ad24d5:	inc    %r15
  ad24d8:	cmp    $0x1c,%r10d
  ad24dc:	jne    ad2bed <ir_typed_emit_function+0x112d>
  ad24e2:	mov    %eax,(%r12,%rdi,4)
  ad24e6:	mov    %r9b,0x0(%r13,%rdi,1)
  ad24eb:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad24f0:	lea    -0x1(%rbp),%eax
  ad24f3:	test   %r14,%r14
  ad24f6:	je     ad2543 <ir_typed_emit_function+0xa83>
  ad24f8:	mov    0x90(%rsp),%rdi
  ad2500:	mov    (%r14),%r8
  ad2503:	mov    (%r12,%rax,4),%esi
  ad2507:	mov    %r15d,%r10d
  ad250a:	movzbl (%rdi,%rcx,1),%edi
  ad250e:	mov    %dil,(%r8,%r10,1)
  ad2512:	mov    0x8(%r14),%rdi
  ad2516:	mov    %r11b,(%rdi,%r10,1)
  ad251a:	mov    0x20(%r14),%rdi
  ad251e:	mov    %esi,(%rdi,%r10,4)
  ad2522:	mov    0x28(%r14),%rsi
  ad2526:	movl   $0xffffffff,(%rsi,%r10,4)
  ad252e:	mov    0x30(%r14),%rsi
  ad2532:	movl   $0xffffffff,(%rsi,%r10,4)
  ad253a:	mov    0x18(%r14),%rsi
  ad253e:	movb   $0x0,(%rsi,%r10,1)
  ad2543:	mov    %r15d,%esi
  ad2546:	inc    %r15
  ad2549:	mov    %esi,(%r12,%rax,4)
  ad254d:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad2552:	test   %r14,%r14
  ad2555:	je     ad258f <ir_typed_emit_function+0xacf>
  ad2557:	mov    (%r14),%rax
  ad255a:	mov    %r15d,%esi
  ad255d:	movb   $0x29,(%rax,%rsi,1)
  ad2561:	mov    0x8(%r14),%rax
  ad2565:	movb   $0xa,(%rax,%rsi,1)
  ad2569:	mov    0x20(%r14),%rax
  ad256d:	mov    %r8d,(%rax,%rsi,4)
  ad2571:	mov    0x28(%r14),%rax
  ad2575:	movl   $0xffffffff,(%rax,%rsi,4)
  ad257c:	mov    0x30(%r14),%rax
  ad2580:	movl   $0xffffffff,(%rax,%rsi,4)
  ad2587:	mov    0x18(%r14),%rax
  ad258b:	movb   $0x0,(%rax,%rsi,1)
  ad258f:	mov    %rbp,%r11
  ad2592:	dec    %ebp
  ad2594:	mov    %r15,%r8
  ad2597:	inc    %r15
  ad259a:	xor    %edi,%edi
  ad259c:	mov    (%r12,%rbp,4),%eax
  ad25a0:	test   %r14,%r14
  ad25a3:	je     ad25dd <ir_typed_emit_function+0xb1d>
  ad25a5:	mov    (%r14),%rsi
  ad25a8:	mov    %r15d,%r9d
  ad25ab:	movb   $0x2c,(%rsi,%r9,1)
  ad25b0:	mov    0x8(%r14),%rsi
  ad25b4:	movb   $0x0,(%rsi,%r9,1)
  ad25b9:	mov    0x20(%r14),%rsi
  ad25bd:	mov    %r8d,(%rsi,%r9,4)
  ad25c1:	mov    0x28(%r14),%rsi
  ad25c5:	mov    %eax,(%rsi,%r9,4)
  ad25c9:	mov    0x30(%r14),%rax
  ad25cd:	movl   $0xffffffff,(%rax,%r9,4)
  ad25d5:	mov    0x18(%r14),%rax
  ad25d9:	mov    %dil,(%rax,%r9,1)
  ad25dd:	inc    %r15
  ad25e0:	cmp    $0x21,%r10d
  ad25e4:	je     ad2200 <ir_typed_emit_function+0x740>
  ad25ea:	cmp    $0x1f,%r10d
  ad25ee:	je     ad2200 <ir_typed_emit_function+0x740>
  ad25f4:	mov    %r11d,%ebp
  ad25f7:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad25fc:	test   %r9b,%r9b
  ad25ff:	je     ad3199 <ir_typed_emit_function+0x16d9>
  ad2605:	dec    %ebp
  ad2607:	mov    (%r12,%rbp,4),%eax
  ad260b:	test   %r14,%r14
  ad260e:	je     ad264e <ir_typed_emit_function+0xb8e>
  ad2610:	mov    (%r14),%rdx
  ad2613:	mov    %r15d,%esi
  ad2616:	movb   $0x33,(%rdx,%rsi,1)
  ad261a:	mov    0x8(%r14),%rdx
  ad261e:	movb   $0x0,(%rdx,%rsi,1)
  ad2622:	mov    0x20(%r14),%rdx
  ad2626:	mov    %eax,(%rdx,%rsi,4)
  ad2629:	lea    -0x4f3a40(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad2630:	mov    0x28(%r14),%rax
  ad2634:	movl   $0xffffffff,(%rax,%rsi,4)
  ad263b:	mov    0x30(%r14),%rax
  ad263f:	movl   $0xffffffff,(%rax,%rsi,4)
  ad2646:	mov    0x18(%r14),%rax
  ad264a:	movb   $0x0,(%rax,%rsi,1)
  ad264e:	mov    $0x1,%al
  ad2650:	inc    %r15
  ad2653:	mov    %eax,0x28(%rsp)
  ad2657:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad265c:	mov    %rbp,%rdi
  ad265f:	dec    %ebp
  ad2661:	add    $0xfffffffe,%edi
  ad2664:	mov    %r9b,0x6(%rsp)
  ad2669:	mov    (%r12,%rbp,4),%eax
  ad266d:	test   %r14,%r14
  ad2670:	je     ad26b3 <ir_typed_emit_function+0xbf3>
  ad2672:	mov    (%r14),%r9
  ad2675:	mov    (%r12,%rdi,4),%esi
  ad2679:	mov    %r15d,%r10d
  ad267c:	movb   $0x25,(%r9,%r10,1)
  ad2681:	mov    0x8(%r14),%r9
  ad2685:	movb   $0xa,(%r9,%r10,1)
  ad268a:	mov    0x20(%r14),%r9
  ad268e:	mov    %esi,(%r9,%r10,4)
  ad2692:	mov    0x28(%r14),%rsi
  ad2696:	movl   $0xffffffff,(%rsi,%r10,4)
  ad269e:	mov    0x30(%r14),%rsi
  ad26a2:	movl   $0xffffffff,(%rsi,%r10,4)
  ad26aa:	mov    0x18(%r14),%rsi
  ad26ae:	movb   $0x0,(%rsi,%r10,1)
  ad26b3:	popcnt %r8,%rsi
  ad26b8:	lea    0x1(%r15),%r9
  ad26bc:	cmp    $0x1,%esi
  ad26bf:	sete   %sil
  ad26c3:	test   $0xf,%r8b
  ad26c7:	setne  %r10b
  ad26cb:	test   %r10b,%sil
  ad26ce:	jne    ad3776 <ir_typed_emit_function+0x1cb6>
  ad26d4:	test   %r14,%r14
  ad26d7:	je     ad3759 <ir_typed_emit_function+0x1c99>
  ad26dd:	mov    0x10(%rsp),%r11
  ad26e2:	mov    0x60(%r14),%rsi
  ad26e6:	mov    %r11d,%r10d
  ad26e9:	shl    $0x4,%r10
  ad26ed:	mov    %r8,(%rsi,%r10,1)
  ad26f1:	movq   $0x0,0x8(%rsi,%r10,1)
  ad26fa:	mov    %r9d,%r8d
  ad26fd:	mov    (%r14),%rsi
  ad2700:	movb   $0x1,(%rsi,%r8,1)
  ad2705:	mov    0x8(%r14),%rsi
  ad2709:	movb   $0x5,(%rsi,%r8,1)
  ad270e:	mov    0x20(%r14),%rsi
  ad2712:	mov    %r11d,(%rsi,%r8,4)
  ad2716:	mov    0x28(%r14),%rsi
  ad271a:	movl   $0xffffffff,(%rsi,%r8,4)
  ad2722:	mov    0x30(%r14),%rsi
  ad2726:	movl   $0xffffffff,(%rsi,%r8,4)
  ad272e:	mov    0x18(%r14),%rsi
  ad2732:	movb   $0x0,(%rsi,%r8,1)
  ad2737:	lea    0x2(%r15),%rsi
  ad273b:	mov    (%r14),%r8
  ad273e:	mov    %esi,%r10d
  ad2741:	movb   $0x7,(%r8,%r10,1)
  ad2746:	mov    0x8(%r14),%r8
  ad274a:	movb   $0x5,(%r8,%r10,1)
  ad274f:	mov    0x20(%r14),%r8
  ad2753:	mov    %eax,(%r8,%r10,4)
  ad2757:	mov    0x28(%r14),%rax
  ad275b:	mov    %r9d,(%rax,%r10,4)
  ad275f:	mov    0x30(%r14),%rax
  ad2763:	movl   $0xffffffff,(%rax,%r10,4)
  ad276b:	mov    0x18(%r14),%rax
  ad276f:	movb   $0x0,(%rax,%r10,1)
  ad2774:	mov    %rsi,%rax
  ad2777:	jmp    ad3762 <ir_typed_emit_function+0x1ca2>
  ad277c:	test   %r14,%r14
  ad277f:	je     ad345f <ir_typed_emit_function+0x199f>
  ad2785:	mov    (%r14),%rax
  ad2788:	mov    %r15d,%esi
  ad278b:	movb   $0x26,(%rax,%rsi,1)
  ad278f:	mov    0x8(%r14),%rax
  ad2793:	movb   $0x5,(%rax,%rsi,1)
  ad2797:	mov    0x20(%r14),%rax
  ad279b:	mov    %r8d,(%rax,%rsi,4)
  ad279f:	mov    0x28(%r14),%rax
  ad27a3:	movl   $0xffffffff,(%rax,%rsi,4)
  ad27aa:	mov    0x30(%r14),%rax
  ad27ae:	movl   $0xffffffff,(%rax,%rsi,4)
  ad27b5:	mov    0x18(%r14),%rax
  ad27b9:	movb   $0x0,(%rax,%rsi,1)
  ad27bd:	jmp    ad345f <ir_typed_emit_function+0x199f>
  ad27c2:	lea    -0x1(%rbp),%eax
  ad27c5:	mov    (%r12,%rax,4),%eax
  ad27c9:	jmp    ad3465 <ir_typed_emit_function+0x19a5>
  ad27ce:	test   %r14,%r14
  ad27d1:	je     ad284b <ir_typed_emit_function+0xd8b>
  ad27d3:	movzbl %r11b,%eax
  ad27d7:	mov    $0x9f,%esi
  ad27dc:	mov    %r9d,%edi
  ad27df:	bt     %rax,%rsi
  ad27e3:	jae    ad27f5 <ir_typed_emit_function+0xd35>
  ad27e5:	lea    -0x5d745c(%rip),%rsi        # 4fb390 <ir_type_bits>
  ad27ec:	movzbl (%rsi,%rax,2),%eax
  ad27f0:	bzhi   %rax,%r8,%r8
  ad27f5:	mov    0x10(%rsp),%r9
  ad27fa:	mov    %r15d,%esi
  ad27fd:	mov    %r9d,%eax
  ad2800:	shl    $0x4,%rax
  ad2804:	add    0x60(%r14),%rax
  ad2808:	mov    %r8,(%rax)
  ad280b:	movq   $0x0,0x8(%rax)
  ad2813:	mov    (%r14),%rax
  ad2816:	movb   $0x1,(%rax,%rsi,1)
  ad281a:	mov    0x8(%r14),%rax
  ad281e:	mov    %r11b,(%rax,%rsi,1)
  ad2822:	mov    0x20(%r14),%rax
  ad2826:	mov    %r9d,(%rax,%rsi,4)
  ad282a:	mov    %edi,%r9d
  ad282d:	mov    0x28(%r14),%rax
  ad2831:	movl   $0xffffffff,(%rax,%rsi,4)
  ad2838:	mov    0x30(%r14),%rax
  ad283c:	movl   $0xffffffff,(%rax,%rsi,4)
  ad2843:	mov    0x18(%r14),%rax
  ad2847:	movb   $0x0,(%rax,%rsi,1)
  ad284b:	incq   0x10(%rsp)
  ad2850:	jmp    ad345f <ir_typed_emit_function+0x199f>
  ad2855:	mov    %rbp,%rax
  ad2858:	add    $0xfffffffe,%ebp
  ad285b:	test   %r14,%r14
  ad285e:	je     ad31ac <ir_typed_emit_function+0x16ec>
  ad2864:	mov    (%r14),%rsi
  ad2867:	dec    %eax
  ad2869:	mov    %ebp,%edx
  ad286b:	mov    (%r12,%rdx,4),%edx
  ad286f:	mov    %r15d,%edi
  ad2872:	mov    (%r12,%rax,4),%eax
  ad2876:	movb   $0x25,(%rsi,%rdi,1)
  ad287a:	mov    0x8(%r14),%rsi
  ad287e:	movb   $0xa,(%rsi,%rdi,1)
  ad2882:	mov    0x20(%r14),%rsi
  ad2886:	mov    %edx,(%rsi,%rdi,4)
  ad2889:	mov    0x28(%r14),%rdx
  ad288d:	movl   $0xffffffff,(%rdx,%rdi,4)
  ad2894:	mov    0x30(%r14),%rdx
  ad2898:	movl   $0xffffffff,(%rdx,%rdi,4)
  ad289f:	mov    0x18(%r14),%rdx
  ad28a3:	movb   $0x0,(%rdx,%rdi,1)
  ad28a7:	lea    0x1(%r15),%rdx
  ad28ab:	mov    (%r14),%rsi
  ad28ae:	mov    %edx,%edi
  ad28b0:	movb   $0x25,(%rsi,%rdi,1)
  ad28b4:	mov    0x8(%r14),%rsi
  ad28b8:	movb   $0xa,(%rsi,%rdi,1)
  ad28bc:	mov    0x20(%r14),%rsi
  ad28c0:	mov    %eax,(%rsi,%rdi,4)
  ad28c3:	mov    0x28(%r14),%rax
  ad28c7:	movl   $0xffffffff,(%rax,%rdi,4)
  ad28ce:	mov    0x30(%r14),%rax
  ad28d2:	movl   $0xffffffff,(%rax,%rdi,4)
  ad28d9:	mov    0x18(%r14),%rax
  ad28dd:	movb   $0x0,(%rax,%rdi,1)
  ad28e1:	lea    0x1(%rdx),%rdi
  ad28e5:	test   %r8,%r8
  ad28e8:	jne    ad31bd <ir_typed_emit_function+0x16fd>
  ad28ee:	jmp    ad33f7 <ir_typed_emit_function+0x1937>
  ad28f3:	and    $0xf,%esi
  ad28f6:	movzbl (%rsi,%rdx,1),%r10d
  ad28fb:	cmp    $0x4,%r10d
  ad28ff:	je     ad341d <ir_typed_emit_function+0x195d>
  ad2905:	mov    $0x3,%al
  ad2907:	cmp    $0x8,%r10d
  ad290b:	je     ad2918 <ir_typed_emit_function+0xe58>
  ad290d:	add    $0xfd,%sil
  ad2911:	cmp    $0x2,%sil
  ad2915:	setb   %al
  ad2918:	test   %r14,%r14
  ad291b:	jne    ad3424 <ir_typed_emit_function+0x1964>
  ad2921:	jmp    ad345f <ir_typed_emit_function+0x199f>
  ad2926:	lea    -0x1(%rbp),%eax
  ad2929:	test   %r14,%r14
  ad292c:	je     ad3406 <ir_typed_emit_function+0x1946>
  ad2932:	mov    (%r14),%r8
  ad2935:	mov    %r11d,%edi
  ad2938:	mov    (%r12,%rax,4),%esi
  ad293c:	mov    %r15d,%r11d
  ad293f:	mov    %r15d,%r10d
  ad2942:	inc    %r15
  ad2945:	movb   $0x25,(%r8,%r11,1)
  ad294a:	mov    0x8(%r14),%r8
  ad294e:	movb   $0xa,(%r8,%r11,1)
  ad2953:	mov    0x20(%r14),%r8
  ad2957:	mov    %esi,(%r8,%r11,4)
  ad295b:	mov    %r15d,%r8d
  ad295e:	mov    0x28(%r14),%rsi
  ad2962:	movl   $0xffffffff,(%rsi,%r11,4)
  ad296a:	mov    0x30(%r14),%rsi
  ad296e:	movl   $0xffffffff,(%rsi,%r11,4)
  ad2976:	mov    0x18(%r14),%rsi
  ad297a:	movb   $0x0,(%rsi,%r11,1)
  ad297f:	mov    (%r14),%rsi
  ad2982:	movb   $0x2b,(%rsi,%r8,1)
  ad2987:	mov    0x8(%r14),%rsi
  ad298b:	mov    %dil,(%rsi,%r8,1)
  ad298f:	mov    0x20(%r14),%rsi
  ad2993:	mov    %r10d,(%rsi,%r8,4)
  ad2997:	mov    0x28(%r14),%rsi
  ad299b:	movl   $0xffffffff,(%rsi,%r8,4)
  ad29a3:	mov    0x30(%r14),%rsi
  ad29a7:	movl   $0xffffffff,(%rsi,%r8,4)
  ad29af:	mov    0x18(%r14),%rsi
  ad29b3:	movb   $0x0,(%rsi,%r8,1)
  ad29b8:	jmp    ad3409 <ir_typed_emit_function+0x1949>
  ad29bd:	lea    -0x1(%rbp),%eax
  ad29c0:	lea    -0x4f3de7(%rip),%rdx        # 5debe0 <ir_typed_types>
  ad29c7:	mov    %r9b,0x6(%rsp)
  ad29cc:	movzbl 0x0(%r13,%rax,1),%r10d
  ad29d2:	mov    (%r12,%rax,4),%r8d
  ad29d6:	movzbl (%rsi,%rdx,1),%esi
  ad29da:	movzbl (%r10,%rdx,1),%r9d
  ad29df:	cmp    %sil,%r9b
  ad29e2:	jne    ad30b8 <ir_typed_emit_function+0x15f8>
  ad29e8:	lea    -0x4f3dff(%rip),%rsi        # 5debf0 <tier0_class_bytes.bytes>
  ad29ef:	jmp    ad38d0 <ir_typed_emit_function+0x1e10>
  ad29f4:	mov    0x58(%rbx),%rax
  ad29f8:	mov    %r11b,0x7(%rsp)
  ad29fd:	mov    %r8d,%r11d
  ad2a00:	mov    0x60(%rsp),%rsi
  ad2a05:	sub    (%rax,%r8,4),%ebp
  ad2a09:	mov    (%rax,%r11,4),%edi
  ad2a0d:	lea    (%r12,%rbp,4),%r13
  ad2a11:	test   %r14,%r14
  ad2a14:	je     ad3713 <ir_typed_emit_function+0x1c53>
  ad2a1a:	mov    0x60(%rbx),%r10
  ad2a1e:	mov    %esi,%eax
  ad2a20:	mov    %r9b,0x6(%rsp)
  ad2a25:	mov    %rdi,%r9
  ad2a28:	mov    0x90(%r14),%rsi
  ad2a2f:	mov    0x30(%rsp),%rdi
  ad2a34:	mov    0x38(%rsp),%r8
  ad2a39:	movzbl 0x7(%rsp),%edx
  ad2a3e:	lea    (%rax,%rax,4),%rax
  ad2a42:	mov    %rbp,0x18(%rsp)
  ad2a47:	mov    %r9,0x88(%rsp)
  ad2a4f:	cmpb   $0x0,(%r10,%r11,1)
  ad2a54:	mov    %edi,(%rsi,%rax,4)
  ad2a57:	mov    %r9d,0x4(%rsi,%rax,4)
  ad2a5c:	mov    %r8d,0x8(%rsi,%rax,4)
  ad2a61:	mov    %r9d,0xc(%rsi,%rax,4)
  ad2a66:	mov    %dl,0x10(%rsi,%rax,4)
  ad2a6a:	setne  0x11(%rsi,%rax,4)
  ad2a6f:	movw   $0x0,0x12(%rsi,%rax,4)
  ad2a76:	test   %r9d,%r9d
  ad2a79:	je     ad36af <ir_typed_emit_function+0x1bef>
  ad2a7f:	mov    0x88(%rsp),%rax
  ad2a87:	mov    %r13,0x80(%rsp)
  ad2a8f:	mov    %eax,%ebp
  ad2a91:	and    $0x3,%ebp
  ad2a94:	cmp    $0x4,%eax
  ad2a97:	jae    ad3511 <ir_typed_emit_function+0x1a51>
  ad2a9d:	mov    0x38(%rsp),%r9
  ad2aa2:	mov    0x30(%rsp),%rdi
  ad2aa7:	mov    0x80(%rsp),%r13
  ad2aaf:	xor    %eax,%eax
  ad2ab1:	lea    -0x4f3ed8(%rip),%rdx        # 5debe0 <ir_typed_types>
  ad2ab8:	jmp    ad3670 <ir_typed_emit_function+0x1bb0>
  ad2abd:	mov    %rbp,%rax
  ad2ac0:	add    $0xfffffffe,%eax
  ad2ac3:	dec    %ebp
  ad2ac5:	mov    %r11b,0x7(%rsp)
  ad2aca:	mov    (%r12,%rbp,4),%r11d
  ad2ace:	mov    (%r12,%rax,4),%edi
  ad2ad2:	mov    %rax,0x18(%rsp)
  ad2ad7:	lea    -0x16(%r10),%eax
  ad2adb:	cmp    $0x5,%al
  ad2add:	ja     ad3110 <ir_typed_emit_function+0x1650>
  ad2ae3:	test   %r14,%r14
  ad2ae6:	je     ad3855 <ir_typed_emit_function+0x1d95>
  ad2aec:	mov    0x18(%rsp),%rax
  ad2af1:	mov    %r9d,%r8d
  ad2af4:	mov    $0x0,%ebx
  ad2af9:	movzbl 0x0(%r13,%rax,1),%eax
  ad2aff:	mov    %eax,%esi
  ad2b01:	and    $0xf9,%sil
  ad2b05:	cmp    $0x1,%sil
  ad2b09:	setne  %sil
  ad2b0d:	add    $0xf7,%al
  ad2b0f:	cmp    $0x18,%r10b
  ad2b13:	setae  %r9b
  ad2b17:	cmp    $0x2,%al
  ad2b19:	setae  %al
  ad2b1c:	adc    $0x19,%bl
  ad2b1f:	and    %sil,%al
  ad2b22:	mov    (%r14),%rsi
  ad2b25:	and    %r9b,%al
  ad2b28:	mov    %r15d,%r9d
  ad2b2b:	movzbl %al,%eax
  ad2b2e:	lea    -0x16(%r10,%rax,4),%eax
  ad2b33:	mov    %r15d,%r10d
  ad2b36:	inc    %r15
  ad2b39:	mov    %bl,(%rsi,%r10,1)
  ad2b3d:	mov    0x8(%rsp),%rbx
  ad2b42:	mov    0x8(%r14),%rsi
  ad2b46:	movb   $0x1,(%rsi,%r10,1)
  ad2b4b:	mov    0x20(%r14),%rsi
  ad2b4f:	mov    %edi,(%rsi,%r10,4)
  ad2b53:	mov    0x28(%r14),%rsi
  ad2b57:	mov    %r11d,(%rsi,%r10,4)
  ad2b5b:	mov    0x30(%r14),%rsi
  ad2b5f:	mov    %eax,(%rsi,%r10,4)
  ad2b63:	mov    %r15d,%esi
  ad2b66:	mov    0x18(%r14),%rax
  ad2b6a:	movb   $0x0,(%rax,%r10,1)
  ad2b6f:	mov    (%r14),%rax
  ad2b72:	movb   $0x1d,(%rax,%rsi,1)
  ad2b76:	mov    0x8(%r14),%rax
  ad2b7a:	movb   $0x4,(%rax,%rsi,1)
  ad2b7e:	mov    0x20(%r14),%rax
  ad2b82:	mov    %r9d,(%rax,%rsi,4)
  ad2b86:	mov    %r8d,%r9d
  ad2b89:	mov    0x28(%r14),%rax
  ad2b8d:	movl   $0xffffffff,(%rax,%rsi,4)
  ad2b94:	mov    0x30(%r14),%rax
  ad2b98:	movl   $0xffffffff,(%rax,%rsi,4)
  ad2b9f:	mov    0x18(%r14),%rax
  ad2ba3:	movb   $0x0,(%rax,%rsi,1)
  ad2ba7:	jmp    ad39d0 <ir_typed_emit_function+0x1f10>
  ad2bac:	mov    %ebp,%eax
  ad2bae:	lea    0x1(%r15),%rsi
  ad2bb2:	mov    %rax,0x28(%rsp)
  ad2bb7:	lea    0x1(%rsi),%rax
  ad2bbb:	mov    %rsi,0x48(%rsp)
  ad2bc0:	test   %ebp,%ebp
  ad2bc2:	jne    ad235a <ir_typed_emit_function+0x89a>
  ad2bc8:	mov    0x10(%rsp),%r15
  ad2bcd:	jmp    ad2e10 <ir_typed_emit_function+0x1350>
  ad2bd2:	inc    %r15
  ad2bd5:	jmp    ad345f <ir_typed_emit_function+0x199f>
  ad2bda:	mov    %rsi,%rdi
  ad2bdd:	inc    %r15
  ad2be0:	inc    %r15
  ad2be3:	cmp    $0x1c,%r10d
  ad2be7:	je     ad24e2 <ir_typed_emit_function+0xa22>
  ad2bed:	mov    %edi,%ebp
  ad2bef:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad2bf4:	mov    $0x2,%dil
  ad2bf7:	test   %r14,%r14
  ad2bfa:	jne    ad25a5 <ir_typed_emit_function+0xae5>
  ad2c00:	jmp    ad25dd <ir_typed_emit_function+0xb1d>
  ad2c05:	mov    %esi,%eax
  ad2c07:	and    $0xfffffffe,%eax
  ad2c0a:	xor    %r9d,%r9d
  ad2c0d:	mov    %rbp,0x18(%rsp)
  ad2c12:	jmp    ad2c80 <ir_typed_emit_function+0x11c0>
  ad2c14:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  ad2c20:	mov    $0x3,%bpl
  ad2c23:	test   %r14,%r14
  ad2c26:	je     ad2c73 <ir_typed_emit_function+0x11b3>
  ad2c28:	mov    (%r14),%r13
  ad2c2b:	lea    0x3(%r15,%r9,1),%rsi
  ad2c30:	lea    0x1(%rdi,%r9,1),%r12
  ad2c35:	mov    %esi,%esi
  ad2c37:	movb   $0x2c,0x0(%r13,%rsi,1)
  ad2c3d:	mov    0x8(%r14),%r13
  ad2c41:	movb   $0x0,0x0(%r13,%rsi,1)
  ad2c47:	mov    0x20(%r14),%r13
  ad2c4b:	mov    %r12d,0x0(%r13,%rsi,4)
  ad2c50:	mov    0x120(%rsp),%r13
  ad2c58:	mov    0x28(%r14),%r12
  ad2c5c:	mov    %ebx,(%r12,%rsi,4)
  ad2c60:	mov    0x30(%r14),%rbx
  ad2c64:	movl   $0xffffffff,(%rbx,%rsi,4)
  ad2c6b:	mov    0x18(%r14),%rbx
  ad2c6f:	mov    %bpl,(%rbx,%rsi,1)
  ad2c73:	add    $0x2,%r9
  ad2c77:	cmp    %r9,%rax
  ad2c7a:	je     ad2d7a <ir_typed_emit_function+0x12ba>
  ad2c80:	movzbl 0x0(%r13,%r9,1),%r12d
  ad2c86:	and    $0xf,%r12d
  ad2c8a:	movzbl (%r12,%rdx,1),%ebp
  ad2c8f:	cmp    $0x4,%ebp
  ad2c92:	je     ad2d40 <ir_typed_emit_function+0x1280>
  ad2c98:	mov    $0x3,%bl
  ad2c9a:	cmp    $0x8,%ebp
  ad2c9d:	je     ad2caa <ir_typed_emit_function+0x11ea>
  ad2c9f:	add    $0xfd,%r12b
  ad2ca3:	cmp    $0x2,%r12b
  ad2ca7:	setb   %bl
  ad2caa:	mov    0x118(%rsp),%r11
  ad2cb2:	test   %r14,%r14
  ad2cb5:	je     ad2d04 <ir_typed_emit_function+0x1244>
  ad2cb7:	mov    (%r14),%rsi
  ad2cba:	lea    0x2(%r15,%r9,1),%r12
  ad2cbf:	mov    (%r11,%r9,4),%ebp
  ad2cc3:	lea    (%rdi,%r9,1),%r13
  ad2cc7:	mov    %r12d,%r12d
  ad2cca:	movb   $0x2c,(%rsi,%r12,1)
  ad2ccf:	mov    0x8(%r14),%rsi
  ad2cd3:	movb   $0x0,(%rsi,%r12,1)
  ad2cd8:	mov    0x20(%r14),%rsi
  ad2cdc:	mov    %r13d,(%rsi,%r12,4)
  ad2ce0:	mov    0x120(%rsp),%r13
  ad2ce8:	mov    0x28(%r14),%rsi
  ad2cec:	mov    %ebp,(%rsi,%r12,4)
  ad2cf0:	mov    0x30(%r14),%rsi
  ad2cf4:	movl   $0xffffffff,(%rsi,%r12,4)
  ad2cfc:	mov    0x18(%r14),%rsi
  ad2d00:	mov    %bl,(%rsi,%r12,1)
  ad2d04:	movzbl 0x1(%r13,%r9,1),%r12d
  ad2d0a:	mov    0x4(%r11,%r9,4),%ebx
  ad2d0f:	and    $0xf,%r12d
  ad2d13:	movzbl (%r12,%rdx,1),%ebp
  ad2d18:	cmp    $0x8,%ebp
  ad2d1b:	je     ad2c20 <ir_typed_emit_function+0x1160>
  ad2d21:	cmp    $0x4,%ebp
  ad2d24:	jne    ad2d60 <ir_typed_emit_function+0x12a0>
  ad2d26:	mov    $0x2,%bpl
  ad2d29:	test   %r14,%r14
  ad2d2c:	jne    ad2c28 <ir_typed_emit_function+0x1168>
  ad2d32:	jmp    ad2c73 <ir_typed_emit_function+0x11b3>
  ad2d37:	nopw   0x0(%rax,%rax,1)
  ad2d40:	mov    $0x2,%bl
  ad2d42:	mov    0x118(%rsp),%r11
  ad2d4a:	test   %r14,%r14
  ad2d4d:	jne    ad2cb7 <ir_typed_emit_function+0x11f7>
  ad2d53:	jmp    ad2d04 <ir_typed_emit_function+0x1244>
  ad2d55:	data16 cs nopw 0x0(%rax,%rax,1)
  ad2d60:	add    $0xfd,%r12b
  ad2d64:	cmp    $0x2,%r12b
  ad2d68:	setb   %bpl
  ad2d6c:	test   %r14,%r14
  ad2d6f:	jne    ad2c28 <ir_typed_emit_function+0x1168>
  ad2d75:	jmp    ad2c73 <ir_typed_emit_function+0x11b3>
  ad2d7a:	lea    0x2(%r15,%r9,1),%rax
  ad2d7f:	testb  $0x1,0x28(%rsp)
  ad2d84:	mov    0x8(%rsp),%rbx
  ad2d89:	mov    0x10(%rsp),%r15
  ad2d8e:	mov    0x118(%rsp),%r12
  ad2d96:	mov    0x18(%rsp),%rbp
  ad2d9b:	je     ad2e10 <ir_typed_emit_function+0x1350>
  ad2d9d:	movzbl 0x0(%r13,%r9,1),%r11d
  ad2da3:	and    $0xf,%r11d
  ad2da7:	movzbl (%r11,%rdx,1),%ebx
  ad2dac:	cmp    $0x8,%ebx
  ad2daf:	je     ad3477 <ir_typed_emit_function+0x19b7>
  ad2db5:	cmp    $0x4,%ebx
  ad2db8:	jne    ad349d <ir_typed_emit_function+0x19dd>
  ad2dbe:	mov    $0x2,%r11b
  ad2dc1:	mov    0x8(%rsp),%rbx
  ad2dc6:	test   %r14,%r14
  ad2dc9:	je     ad2e0d <ir_typed_emit_function+0x134d>
  ad2dcb:	lea    (%r9,%rdi,1),%esi
  ad2dcf:	mov    (%r12,%r9,4),%edi
  ad2dd3:	mov    (%r14),%r9
  ad2dd6:	mov    %eax,%ebx
  ad2dd8:	movb   $0x2c,(%r9,%rbx,1)
  ad2ddd:	mov    0x8(%r14),%r9
  ad2de1:	movb   $0x0,(%r9,%rbx,1)
  ad2de6:	mov    0x20(%r14),%r9
  ad2dea:	mov    %esi,(%r9,%rbx,4)
  ad2dee:	mov    0x28(%r14),%rsi
  ad2df2:	mov    %edi,(%rsi,%rbx,4)
  ad2df5:	mov    0x30(%r14),%rsi
  ad2df9:	movl   $0xffffffff,(%rsi,%rbx,4)
  ad2e00:	mov    0x18(%r14),%rsi
  ad2e04:	mov    %r11b,(%rsi,%rbx,1)
  ad2e08:	mov    0x8(%rsp),%rbx
  ad2e0d:	inc    %rax
  ad2e10:	test   %r14,%r14
  ad2e13:	je     ad2e71 <ir_typed_emit_function+0x13b1>
  ad2e15:	mov    0x40(%rsp),%rsi
  ad2e1a:	mov    %eax,%r9d
  ad2e1d:	mov    0x8(%rsi),%rsi
  ad2e21:	mov    (%rsi,%r8,4),%esi
  ad2e25:	mov    0x74(%rsp),%r8d
  ad2e2a:	inc    %esi
  ad2e2c:	cmp    $0x25,%r10d
  ad2e30:	mov    (%r14),%r10
  ad2e33:	mov    %esi,%edi
  ad2e35:	cmove  %r8d,%edi
  ad2e39:	cmovne %r8d,%esi
  ad2e3d:	movb   $0x31,(%r10,%r9,1)
  ad2e42:	mov    0x48(%rsp),%r10
  ad2e47:	mov    0x8(%r14),%r8
  ad2e4b:	movb   $0x0,(%r8,%r9,1)
  ad2e50:	mov    0x20(%r14),%r8
  ad2e54:	mov    %r10d,(%r8,%r9,4)
  ad2e58:	mov    0x28(%r14),%r8
  ad2e5c:	mov    %esi,(%r8,%r9,4)
  ad2e60:	mov    0x30(%r14),%rsi
  ad2e64:	mov    %edi,(%rsi,%r9,4)
  ad2e68:	mov    0x18(%r14),%rsi
  ad2e6c:	movb   $0x0,(%rsi,%r9,1)
  ad2e71:	inc    %r15
  ad2e74:	mov    $0x1,%sil
  ad2e77:	inc    %rax
  ad2e7a:	mov    %r15,0x10(%rsp)
  ad2e7f:	mov    %esi,0x28(%rsp)
  ad2e83:	mov    %rax,%r15
  ad2e86:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad2e8b:	mov    %ebp,%eax
  ad2e8d:	mov    %eax,%r9d
  ad2e90:	and    $0xfffffffe,%r9d
  ad2e94:	mov    %rbp,0x18(%rsp)
  ad2e99:	mov    %esi,%r10d
  ad2e9c:	xor    %edi,%edi
  ad2e9e:	jmp    ad2f10 <ir_typed_emit_function+0x1450>
  ad2ea0:	mov    $0x3,%bl
  ad2ea2:	test   %r14,%r14
  ad2ea5:	je     ad2efb <ir_typed_emit_function+0x143b>
  ad2ea7:	mov    (%r14),%r13
  ad2eaa:	lea    0x1(%r15),%r12
  ad2eae:	lea    0x1(%r10),%ebp
  ad2eb2:	mov    %r12d,%r12d
  ad2eb5:	movb   $0x2c,0x0(%r13,%r12,1)
  ad2ebb:	mov    0x8(%r14),%r13
  ad2ebf:	movb   $0x0,0x0(%r13,%r12,1)
  ad2ec5:	mov    0x20(%r14),%r13
  ad2ec9:	mov    %ebp,0x0(%r13,%r12,4)
  ad2ece:	mov    0x28(%r14),%r13
  ad2ed2:	mov    %r11d,0x0(%r13,%r12,4)
  ad2ed7:	mov    0x120(%rsp),%r13
  ad2edf:	mov    0x30(%r14),%r11
  ad2ee3:	movl   $0xffffffff,(%r11,%r12,4)
  ad2eeb:	mov    0x18(%r14),%r11
  ad2eef:	mov    %bl,(%r11,%r12,1)
  ad2ef3:	mov    0x118(%rsp),%r12
  ad2efb:	add    $0x2,%r15
  ad2eff:	add    $0x2,%rdi
  ad2f03:	add    $0x2,%r10d
  ad2f07:	cmp    %rdi,%r9
  ad2f0a:	je     ad2fe7 <ir_typed_emit_function+0x1527>
  ad2f10:	movzbl 0x0(%r13,%rdi,1),%ebx
  ad2f16:	and    $0xf,%ebx
  ad2f19:	movzbl (%rbx,%rdx,1),%ebp
  ad2f1d:	cmp    $0x4,%ebp
  ad2f20:	je     ad2fc0 <ir_typed_emit_function+0x1500>
  ad2f26:	mov    $0x3,%r11b
  ad2f29:	cmp    $0x8,%ebp
  ad2f2c:	je     ad2f38 <ir_typed_emit_function+0x1478>
  ad2f2e:	add    $0xfd,%bl
  ad2f31:	cmp    $0x2,%bl
  ad2f34:	setb   %r11b
  ad2f38:	test   %r14,%r14
  ad2f3b:	je     ad2f8a <ir_typed_emit_function+0x14ca>
  ad2f3d:	mov    (%r14),%rbp
  ad2f40:	mov    (%r12,%rdi,4),%ebx
  ad2f44:	mov    %r15d,%r13d
  ad2f47:	movb   $0x2c,0x0(%rbp,%r13,1)
  ad2f4d:	mov    0x8(%r14),%r12
  ad2f51:	movb   $0x0,(%r12,%r13,1)
  ad2f56:	mov    0x20(%r14),%r12
  ad2f5a:	mov    %r10d,(%r12,%r13,4)
  ad2f5e:	mov    0x28(%r14),%r12
  ad2f62:	mov    %ebx,(%r12,%r13,4)
  ad2f66:	mov    0x118(%rsp),%r12
  ad2f6e:	mov    0x30(%r14),%rbx
  ad2f72:	movl   $0xffffffff,(%rbx,%r13,4)
  ad2f7a:	mov    0x18(%r14),%rbx
  ad2f7e:	mov    %r11b,(%rbx,%r13,1)
  ad2f82:	mov    0x120(%rsp),%r13
  ad2f8a:	movzbl 0x1(%r13,%rdi,1),%ebx
  ad2f90:	mov    0x4(%r12,%rdi,4),%r11d
  ad2f95:	and    $0xf,%ebx
  ad2f98:	movzbl (%rbx,%rdx,1),%ebp
  ad2f9c:	cmp    $0x8,%ebp
  ad2f9f:	je     ad2ea0 <ir_typed_emit_function+0x13e0>
  ad2fa5:	cmp    $0x4,%ebp
  ad2fa8:	jne    ad2fd0 <ir_typed_emit_function+0x1510>
  ad2faa:	mov    $0x2,%bl
  ad2fac:	test   %r14,%r14
  ad2faf:	jne    ad2ea7 <ir_typed_emit_function+0x13e7>
  ad2fb5:	jmp    ad2efb <ir_typed_emit_function+0x143b>
  ad2fba:	nopw   0x0(%rax,%rax,1)
  ad2fc0:	mov    $0x2,%r11b
  ad2fc3:	test   %r14,%r14
  ad2fc6:	jne    ad2f3d <ir_typed_emit_function+0x147d>
  ad2fcc:	jmp    ad2f8a <ir_typed_emit_function+0x14ca>
  ad2fce:	xchg   %ax,%ax
  ad2fd0:	add    $0xfd,%bl
  ad2fd3:	cmp    $0x2,%bl
  ad2fd6:	setb   %bl
  ad2fd9:	test   %r14,%r14
  ad2fdc:	jne    ad2ea7 <ir_typed_emit_function+0x13e7>
  ad2fe2:	jmp    ad2efb <ir_typed_emit_function+0x143b>
  ad2fe7:	mov    0x8(%rsp),%rbx
  ad2fec:	mov    0x18(%rsp),%rbp
  ad2ff1:	test   $0x1,%al
  ad2ff3:	je     ad305f <ir_typed_emit_function+0x159f>
  ad2ff5:	movzbl 0x0(%r13,%rdi,1),%eax
  ad2ffb:	and    $0xf,%eax
  ad2ffe:	movzbl (%rax,%rdx,1),%r9d
  ad3003:	cmp    $0x8,%r9d
  ad3007:	je     ad348d <ir_typed_emit_function+0x19cd>
  ad300d:	cmp    $0x4,%r9d
  ad3011:	jne    ad34bc <ir_typed_emit_function+0x19fc>
  ad3017:	mov    $0x2,%al
  ad3019:	test   %r14,%r14
  ad301c:	je     ad305c <ir_typed_emit_function+0x159c>
  ad301e:	mov    (%r14),%r9
  ad3021:	add    %edi,%esi
  ad3023:	mov    (%r12,%rdi,4),%edi
  ad3027:	mov    %r15d,%r10d
  ad302a:	movb   $0x2c,(%r9,%r10,1)
  ad302f:	mov    0x8(%r14),%r9
  ad3033:	movb   $0x0,(%r9,%r10,1)
  ad3038:	mov    0x20(%r14),%r9
  ad303c:	mov    %esi,(%r9,%r10,4)
  ad3040:	mov    0x28(%r14),%rsi
  ad3044:	mov    %edi,(%rsi,%r10,4)
  ad3048:	mov    0x30(%r14),%rsi
  ad304c:	movl   $0xffffffff,(%rsi,%r10,4)
  ad3054:	mov    0x18(%r14),%rsi
  ad3058:	mov    %al,(%rsi,%r10,1)
  ad305c:	inc    %r15
  ad305f:	test   %r14,%r14
  ad3062:	je     ad30aa <ir_typed_emit_function+0x15ea>
  ad3064:	mov    0x40(%rsp),%rax
  ad3069:	mov    (%r14),%rsi
  ad306c:	mov    %r15d,%edi
  ad306f:	mov    0x8(%rax),%rax
  ad3073:	mov    (%rax,%r8,4),%eax
  ad3077:	movb   $0x30,(%rsi,%rdi,1)
  ad307b:	mov    0x8(%r14),%rsi
  ad307f:	inc    %eax
  ad3081:	movb   $0x0,(%rsi,%rdi,1)
  ad3085:	mov    0x20(%r14),%rsi
  ad3089:	mov    %eax,(%rsi,%rdi,4)
  ad308c:	mov    0x28(%r14),%rax
  ad3090:	movl   $0xffffffff,(%rax,%rdi,4)
  ad3097:	mov    0x30(%r14),%rax
  ad309b:	movl   $0xffffffff,(%rax,%rdi,4)
  ad30a2:	mov    0x18(%r14),%rax
  ad30a6:	movb   $0x0,(%rax,%rdi,1)
  ad30aa:	mov    $0x1,%al
  ad30ac:	inc    %r15
  ad30af:	mov    %eax,0x28(%rsp)
  ad30b3:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad30b8:	movzbl %sil,%r11d
  ad30bc:	lea    -0x1(%r9),%ebx
  ad30c0:	cmp    $0x5,%bl
  ad30c3:	ja     ad34d1 <ir_typed_emit_function+0x1a11>
  ad30c9:	lea    -0x1(%rsi),%ebx
  ad30cc:	lea    -0x4f44e3(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad30d3:	cmp    $0x5,%bl
  ad30d6:	ja     ad3870 <ir_typed_emit_function+0x1db0>
  ad30dc:	lea    -0x5d7d53(%rip),%rdi        # 4fb390 <ir_type_bits>
  ad30e3:	movzwl (%rdi,%r9,2),%ebx
  ad30e8:	mov    $0x1c,%r9b
  ad30eb:	cmp    (%rdi,%r11,2),%bx
  ad30f0:	mov    0x8(%rsp),%rbx
  ad30f5:	ja     ad3887 <ir_typed_emit_function+0x1dc7>
  ad30fb:	and    $0xf9,%r10b
  ad30ff:	cmp    $0x1,%r10b
  ad3103:	sete   %r9b
  ad3107:	add    $0x1d,%r9b
  ad310b:	jmp    ad3887 <ir_typed_emit_function+0x1dc7>
  ad3110:	add    $0xed,%r10b
  ad3114:	lea    -0x4f453b(%rip),%rax        # 5debe0 <ir_typed_types>
  ad311b:	cmp    $0x1,%r10b
  ad311f:	ja     ad3983 <ir_typed_emit_function+0x1ec3>
  ad3125:	movzbl 0x0(%r13,%rbp,1),%ebx
  ad312b:	movzbl (%rbx,%rax,1),%r10d
  ad3130:	movzbl (%rsi,%rax,1),%eax
  ad3134:	cmp    %al,%r10b
  ad3137:	je     ad397e <ir_typed_emit_function+0x1ebe>
  ad313d:	movzbl %al,%esi
  ad3140:	lea    -0x1(%r10),%r12d
  ad3144:	cmp    $0x5,%r12b
  ad3148:	ja     ad38e6 <ir_typed_emit_function+0x1e26>
  ad314e:	lea    -0x1(%rax),%r12d
  ad3152:	cmp    $0x5,%r12b
  ad3156:	ja     ad3924 <ir_typed_emit_function+0x1e64>
  ad315c:	mov    %edi,0x48(%rsp)
  ad3160:	lea    -0x5d7dd7(%rip),%rdi        # 4fb390 <ir_type_bits>
  ad3167:	movzwl (%rdi,%r10,2),%r12d
  ad316c:	mov    $0x1c,%r10b
  ad316f:	cmp    (%rdi,%rsi,2),%r12w
  ad3174:	mov    0x48(%rsp),%edi
  ad3178:	mov    0x118(%rsp),%r12
  ad3180:	ja     ad393c <ir_typed_emit_function+0x1e7c>
  ad3186:	and    $0xf9,%bl
  ad3189:	cmp    $0x1,%bl
  ad318c:	sete   %r10b
  ad3190:	add    $0x1d,%r10b
  ad3194:	jmp    ad393c <ir_typed_emit_function+0x1e7c>
  ad3199:	mov    $0xffffffff,%eax
  ad319e:	test   %r14,%r14
  ad31a1:	jne    ad2610 <ir_typed_emit_function+0xb50>
  ad31a7:	jmp    ad264e <ir_typed_emit_function+0xb8e>
  ad31ac:	lea    0x1(%r15),%rdx
  ad31b0:	lea    0x1(%rdx),%rdi
  ad31b4:	test   %r8,%r8
  ad31b7:	je     ad33f7 <ir_typed_emit_function+0x1937>
  ad31bd:	xor    %r9d,%r9d
  ad31c0:	jmp    ad329d <ir_typed_emit_function+0x17dd>
  ad31c5:	data16 cs nopw 0x0(%rax,%rax,1)
  ad31d0:	mov    0x20(%rsp),%r11
  ad31d5:	mov    0x80(%r14),%r12
  ad31dc:	mov    %r11d,%eax
  ad31df:	mov    %eax,%ebx
  ad31e1:	shl    $0x4,%rbx
  ad31e5:	inc    %r11
  ad31e8:	mov    %r9,(%r12,%rbx,1)
  ad31ec:	movb   $0x1,0x8(%r12,%rbx,1)
  ad31f2:	movl   $0x0,0x9(%r12,%rbx,1)
  ad31fb:	movl   $0x0,0xc(%r12,%rbx,1)
  ad3204:	mov    %r11,0x20(%rsp)
  ad3209:	mov    %esi,%ebx
  ad320b:	mov    (%r14),%r11
  ad320e:	movb   $0x2a,(%r11,%rbx,1)
  ad3213:	mov    0x8(%r14),%r11
  ad3217:	movb   $0xa,(%r11,%rbx,1)
  ad321c:	mov    0x20(%r14),%r11
  ad3220:	mov    %r15d,(%r11,%rbx,4)
  ad3224:	mov    0x28(%r14),%r11
  ad3228:	movl   $0xffffffff,(%r11,%rbx,4)
  ad3230:	mov    0x30(%r14),%r11
  ad3234:	mov    %eax,(%r11,%rbx,4)
  ad3238:	mov    0x18(%r14),%rax
  ad323c:	movb   $0x0,(%rax,%rbx,1)
  ad3240:	mov    %esi,%eax
  ad3242:	mov    %rdi,%rsi
  ad3245:	add    $0x2,%rsi
  ad3249:	mov    (%r14),%r11
  ad324c:	mov    %esi,%ebx
  ad324e:	mov    0x118(%rsp),%r12
  ad3256:	movb   $0x2c,(%r11,%rbx,1)
  ad325b:	mov    0x8(%r14),%r11
  ad325f:	movb   $0x0,(%r11,%rbx,1)
  ad3264:	mov    0x20(%r14),%r11
  ad3268:	mov    %eax,(%r11,%rbx,4)
  ad326c:	mov    0x28(%r14),%rax
  ad3270:	mov    %edi,(%rax,%rbx,4)
  ad3273:	mov    %rsi,%rdi
  ad3276:	mov    0x30(%r14),%rax
  ad327a:	movl   $0xffffffff,(%rax,%rbx,4)
  ad3281:	mov    0x18(%r14),%rax
  ad3285:	movb   $0x0,(%rax,%rbx,1)
  ad3289:	mov    0x8(%rsp),%rbx
  ad328e:	inc    %rdi
  ad3291:	add    %r10,%r9
  ad3294:	cmp    %r8,%r9
  ad3297:	jae    ad33f7 <ir_typed_emit_function+0x1937>
  ad329d:	mov    %r8,%rax
  ad32a0:	sub    %r9,%rax
  ad32a3:	cmp    $0x7,%rax
  ad32a7:	jbe    ad3340 <ir_typed_emit_function+0x1880>
  ad32ad:	mov    $0x5,%al
  ad32af:	mov    $0x8,%r10d
  ad32b5:	test   %r9,%r9
  ad32b8:	je     ad337c <ir_typed_emit_function+0x18bc>
  ad32be:	test   %r14,%r14
  ad32c1:	je     ad33e0 <ir_typed_emit_function+0x1920>
  ad32c7:	mov    0x20(%rsp),%r12
  ad32cc:	mov    0x80(%r14),%rsi
  ad32d3:	mov    %edi,%ebx
  ad32d5:	mov    %r12d,%r11d
  ad32d8:	shl    $0x4,%r11
  ad32dc:	mov    %r9,(%rsi,%r11,1)
  ad32e0:	movb   $0x1,0x8(%rsi,%r11,1)
  ad32e6:	movl   $0x0,0x9(%rsi,%r11,1)
  ad32ef:	movl   $0x0,0xc(%rsi,%r11,1)
  ad32f8:	mov    %edi,%r11d
  ad32fb:	inc    %rdi
  ad32fe:	mov    (%r14),%rsi
  ad3301:	movb   $0x2a,(%rsi,%rbx,1)
  ad3305:	mov    0x8(%r14),%rsi
  ad3309:	movb   $0xa,(%rsi,%rbx,1)
  ad330d:	mov    0x20(%r14),%rsi
  ad3311:	mov    %edx,(%rsi,%rbx,4)
  ad3314:	mov    0x28(%r14),%rsi
  ad3318:	movl   $0xffffffff,(%rsi,%rbx,4)
  ad331f:	mov    0x30(%r14),%rsi
  ad3323:	mov    %r12d,(%rsi,%rbx,4)
  ad3327:	lea    0x1(%r12),%rsi
  ad332c:	mov    0x18(%r14),%r12
  ad3330:	mov    %rsi,0x20(%rsp)
  ad3335:	movb   $0x0,(%r12,%rbx,1)
  ad333a:	jmp    ad3384 <ir_typed_emit_function+0x18c4>
  ad333c:	nopl   0x0(%rax)
  ad3340:	cmp    $0x3,%rax
  ad3344:	jbe    ad3360 <ir_typed_emit_function+0x18a0>
  ad3346:	mov    $0x4,%al
  ad3348:	mov    $0x4,%r10d
  ad334e:	test   %r9,%r9
  ad3351:	jne    ad32be <ir_typed_emit_function+0x17fe>
  ad3357:	jmp    ad337c <ir_typed_emit_function+0x18bc>
  ad3359:	nopl   0x0(%rax)
  ad3360:	xor    %r10d,%r10d
  ad3363:	cmp    $0x2,%rax
  ad3367:	setae  %r10b
  ad336b:	mov    %r10d,%eax
  ad336e:	inc    %r10
  ad3371:	or     $0x2,%al
  ad3373:	test   %r9,%r9
  ad3376:	jne    ad32be <ir_typed_emit_function+0x17fe>
  ad337c:	test   %r14,%r14
  ad337f:	je     ad33ef <ir_typed_emit_function+0x192f>
  ad3381:	mov    %edx,%r11d
  ad3384:	mov    (%r14),%rbx
  ad3387:	mov    %edi,%r12d
  ad338a:	lea    0x1(%rdi),%rsi
  ad338e:	movb   $0x2b,(%rbx,%r12,1)
  ad3393:	mov    0x8(%r14),%rbx
  ad3397:	mov    %al,(%rbx,%r12,1)
  ad339b:	mov    0x20(%r14),%rax
  ad339f:	mov    %r11d,(%rax,%r12,4)
  ad33a3:	mov    0x28(%r14),%rax
  ad33a7:	movl   $0xffffffff,(%rax,%r12,4)
  ad33af:	mov    0x30(%r14),%rax
  ad33b3:	movl   $0xffffffff,(%rax,%r12,4)
  ad33bb:	mov    0x18(%r14),%rax
  ad33bf:	movb   $0x0,(%rax,%r12,1)
  ad33c4:	test   %r9,%r9
  ad33c7:	jne    ad31d0 <ir_typed_emit_function+0x1710>
  ad33cd:	mov    %r15d,%eax
  ad33d0:	jmp    ad3249 <ir_typed_emit_function+0x1789>
  ad33d5:	data16 cs nopw 0x0(%rax,%rax,1)
  ad33e0:	addq   $0x2,0x20(%rsp)
  ad33e6:	add    $0x3,%rdi
  ad33ea:	jmp    ad3289 <ir_typed_emit_function+0x17c9>
  ad33ef:	inc    %rdi
  ad33f2:	jmp    ad3289 <ir_typed_emit_function+0x17c9>
  ad33f7:	mov    %rdi,%r15
  ad33fa:	lea    -0x4f4811(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad3401:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad3406:	inc    %r15
  ad3409:	mov    %r15d,%esi
  ad340c:	mov    %esi,(%r12,%rax,4)
  ad3410:	inc    %r15
  ad3413:	mov    %r9b,0x0(%r13,%rax,1)
  ad3418:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad341d:	mov    $0x2,%al
  ad341f:	test   %r14,%r14
  ad3422:	je     ad345f <ir_typed_emit_function+0x199f>
  ad3424:	mov    (%r14),%rsi
  ad3427:	mov    %r15d,%r10d
  ad342a:	movb   $0x2b,(%rsi,%r10,1)
  ad342f:	mov    0x8(%r14),%rsi
  ad3433:	mov    %r11b,(%rsi,%r10,1)
  ad3437:	mov    0x20(%r14),%rsi
  ad343b:	mov    %r8d,(%rsi,%r10,4)
  ad343f:	mov    0x28(%r14),%rsi
  ad3443:	movl   $0xffffffff,(%rsi,%r10,4)
  ad344b:	mov    0x30(%r14),%rsi
  ad344f:	movl   $0xffffffff,(%rsi,%r10,4)
  ad3457:	mov    0x18(%r14),%rsi
  ad345b:	mov    %al,(%rsi,%r10,1)
  ad345f:	mov    %r15d,%eax
  ad3462:	inc    %r15
  ad3465:	mov    %ebp,%esi
  ad3467:	inc    %ebp
  ad3469:	mov    %eax,(%r12,%rsi,4)
  ad346d:	mov    %r9b,0x0(%r13,%rsi,1)
  ad3472:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad3477:	mov    $0x3,%r11b
  ad347a:	mov    0x8(%rsp),%rbx
  ad347f:	test   %r14,%r14
  ad3482:	jne    ad2dcb <ir_typed_emit_function+0x130b>
  ad3488:	jmp    ad2e0d <ir_typed_emit_function+0x134d>
  ad348d:	mov    $0x3,%al
  ad348f:	test   %r14,%r14
  ad3492:	jne    ad301e <ir_typed_emit_function+0x155e>
  ad3498:	jmp    ad305c <ir_typed_emit_function+0x159c>
  ad349d:	add    $0xfd,%r11b
  ad34a1:	cmp    $0x2,%r11b
  ad34a5:	setb   %r11b
  ad34a9:	mov    0x8(%rsp),%rbx
  ad34ae:	test   %r14,%r14
  ad34b1:	jne    ad2dcb <ir_typed_emit_function+0x130b>
  ad34b7:	jmp    ad2e0d <ir_typed_emit_function+0x134d>
  ad34bc:	add    $0xfd,%al
  ad34be:	cmp    $0x2,%al
  ad34c0:	setb   %al
  ad34c3:	test   %r14,%r14
  ad34c6:	jne    ad301e <ir_typed_emit_function+0x155e>
  ad34cc:	jmp    ad305c <ir_typed_emit_function+0x159c>
  ad34d1:	lea    -0x7(%r9),%r10d
  ad34d5:	lea    -0x4f48ec(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad34dc:	cmp    $0x2,%r10b
  ad34e0:	ja     ad385d <ir_typed_emit_function+0x1d9d>
  ad34e6:	lea    -0x7(%rsi),%r10d
  ad34ea:	cmp    $0x2,%r10b
  ad34ee:	ja     ad385d <ir_typed_emit_function+0x1d9d>
  ad34f4:	lea    -0x5d816b(%rip),%rdi        # 4fb390 <ir_type_bits>
  ad34fb:	movzwl (%rdi,%r11,2),%r10d
  ad3500:	cmp    (%rdi,%r9,2),%r10w
  ad3505:	mov    $0x20,%r9b
  ad3508:	sbb    $0x0,%r9b
  ad350c:	jmp    ad3882 <ir_typed_emit_function+0x1dc2>
  ad3511:	and    $0xfffffffc,%eax
  ad3514:	mov    0x18(%rsp),%rdx
  ad3519:	mov    0x38(%rsp),%r9
  ad351e:	mov    0x30(%rsp),%rdi
  ad3523:	mov    %rax,0x48(%rsp)
  ad3528:	mov    0xc0(%rsp),%rax
  ad3530:	lea    (%rax,%rdx,4),%r12
  ad3534:	lea    -0x4f495b(%rip),%rdx        # 5debe0 <ir_typed_types>
  ad353b:	xor    %eax,%eax
  ad353d:	nopl   (%rax)
  ad3540:	mov    -0xc(%r12,%rax,4),%r10d
  ad3545:	mov    0x50(%r14),%r8
  ad3549:	mov    0x8(%rsp),%rsi
  ad354e:	lea    (%rdi,%rax,1),%rbx
  ad3552:	mov    %ebx,%r13d
  ad3555:	mov    %r10d,(%r8,%r13,4)
  ad3559:	mov    0x50(%rsi),%r8
  ad355d:	mov    0x8(%rsp),%rsi
  ad3562:	mov    0xa0(%r14),%r13
  ad3569:	mov    (%r8,%r11,4),%r8d
  ad356d:	mov    0x78(%rsi),%r10
  ad3571:	add    %eax,%r8d
  ad3574:	movzbl (%r10,%r8,1),%r8d
  ad3579:	lea    (%r9,%rax,1),%r10
  ad357d:	mov    %r10d,%esi
  ad3580:	movzbl (%r8,%rdx,1),%r8d
  ad3585:	mov    %r8b,0x0(%r13,%rsi,1)
  ad358a:	lea    0x1(%rbx),%r13d
  ad358e:	mov    -0x8(%r12,%rax,4),%esi
  ad3593:	mov    0x50(%r14),%r8
  ad3597:	mov    %esi,(%r8,%r13,4)
  ad359b:	mov    0x8(%rsp),%r13
  ad35a0:	mov    0x8(%rsp),%r8
  ad35a5:	mov    0x50(%r13),%rsi
  ad35a9:	mov    0x78(%r8),%r8
  ad35ad:	lea    0x1(%r10),%r13d
  ad35b1:	mov    (%rsi,%r11,4),%esi
  ad35b5:	lea    0x1(%rax,%rsi,1),%esi
  ad35b9:	movzbl (%r8,%rsi,1),%esi
  ad35be:	mov    0xa0(%r14),%r8
  ad35c5:	movzbl (%rsi,%rdx,1),%esi
  ad35c9:	mov    %sil,(%r8,%r13,1)
  ad35cd:	lea    0x2(%rbx),%r13d
  ad35d1:	add    $0x3,%ebx
  ad35d4:	mov    -0x4(%r12,%rax,4),%esi
  ad35d9:	mov    0x50(%r14),%r8
  ad35dd:	mov    %esi,(%r8,%r13,4)
  ad35e1:	mov    0x8(%rsp),%r8
  ad35e6:	lea    0x2(%r10),%r13d
  ad35ea:	add    $0x3,%r10d
  ad35ee:	mov    0x50(%r8),%rsi
  ad35f2:	mov    0x8(%rsp),%r8
  ad35f7:	mov    (%rsi,%r11,4),%esi
  ad35fb:	mov    0x78(%r8),%r8
  ad35ff:	lea    0x2(%rax,%rsi,1),%esi
  ad3603:	movzbl (%r8,%rsi,1),%esi
  ad3608:	mov    0xa0(%r14),%r8
  ad360f:	movzbl (%rsi,%rdx,1),%esi
  ad3613:	mov    %sil,(%r8,%r13,1)
  ad3617:	mov    (%r12,%rax,4),%esi
  ad361b:	mov    0x50(%r14),%r8
  ad361f:	mov    %esi,(%r8,%rbx,4)
  ad3623:	mov    0x8(%rsp),%rbx
  ad3628:	mov    0x50(%rbx),%rsi
  ad362c:	mov    0x78(%rbx),%r8
  ad3630:	mov    (%rsi,%r11,4),%esi
  ad3634:	lea    0x3(%rax,%rsi,1),%esi
  ad3638:	add    $0x4,%rax
  ad363c:	movzbl (%r8,%rsi,1),%esi
  ad3641:	mov    0xa0(%r14),%r8
  ad3648:	movzbl (%rsi,%rdx,1),%esi
  ad364c:	mov    %sil,(%r8,%r10,1)
  ad3650:	cmp    %rax,0x48(%rsp)
  ad3655:	jne    ad3540 <ir_typed_emit_function+0x1a80>
  ad365b:	mov    0x118(%rsp),%r12
  ad3663:	mov    0x80(%rsp),%r13
  ad366b:	test   %rbp,%rbp
  ad366e:	je     ad36af <ir_typed_emit_function+0x1bef>
  ad3670:	mov    0x0(%r13,%rax,4),%esi
  ad3675:	mov    0x50(%r14),%r8
  ad3679:	lea    (%rdi,%rax,1),%r10d
  ad367d:	mov    %esi,(%r8,%r10,4)
  ad3681:	lea    (%r9,%rax,1),%r10d
  ad3685:	mov    0x50(%rbx),%rsi
  ad3689:	mov    0x78(%rbx),%r8
  ad368d:	mov    (%rsi,%r11,4),%esi
  ad3691:	add    %eax,%esi
  ad3693:	inc    %rax
  ad3696:	dec    %rbp
  ad3699:	movzbl (%r8,%rsi,1),%esi
  ad369e:	mov    0xa0(%r14),%r8
  ad36a5:	movzbl (%rsi,%rdx,1),%esi
  ad36a9:	mov    %sil,(%r8,%r10,1)
  ad36ad:	jne    ad3670 <ir_typed_emit_function+0x1bb0>
  ad36af:	mov    0x48(%rbx),%rax
  ad36b3:	mov    (%r14),%rsi
  ad36b6:	mov    %r15d,%r8d
  ad36b9:	movzbl 0x7(%rsp),%edx
  ad36be:	mov    0x18(%rsp),%rbp
  ad36c3:	movzbl 0x6(%rsp),%r9d
  ad36c9:	mov    0x88(%rsp),%rdi
  ad36d1:	mov    (%rax,%r11,4),%eax
  ad36d5:	movb   $0x2d,(%rsi,%r8,1)
  ad36da:	mov    0x8(%r14),%rsi
  ad36de:	mov    %dl,(%rsi,%r8,1)
  ad36e2:	lea    -0x4f4af9(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad36e9:	mov    0x20(%r14),%rsi
  ad36ed:	mov    %eax,(%rsi,%r8,4)
  ad36f1:	mov    0x60(%rsp),%rsi
  ad36f6:	mov    0x28(%r14),%rax
  ad36fa:	mov    %esi,(%rax,%r8,4)
  ad36fe:	mov    0x30(%r14),%rax
  ad3702:	movl   $0xffffffff,(%rax,%r8,4)
  ad370a:	mov    0x18(%r14),%rax
  ad370e:	movb   $0x0,(%rax,%r8,1)
  ad3713:	add    %rdi,0x30(%rsp)
  ad3718:	add    %rdi,0x38(%rsp)
  ad371d:	inc    %rsi
  ad3720:	lea    0x1(%r15),%rax
  ad3724:	mov    %rsi,0x60(%rsp)
  ad3729:	test   %r9b,%r9b
  ad372c:	je     ad3749 <ir_typed_emit_function+0x1c89>
  ad372e:	mov    %r15d,0x0(%r13)
  ad3732:	mov    0x120(%rsp),%r13
  ad373a:	mov    %rax,%r15
  ad373d:	mov    %r9b,0x0(%r13,%rbp,1)
  ad3742:	inc    %ebp
  ad3744:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad3749:	mov    0x120(%rsp),%r13
  ad3751:	mov    %rax,%r15
  ad3754:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad3759:	mov    0x10(%rsp),%r11
  ad375e:	lea    0x2(%r15),%rax
  ad3762:	mov    %rax,%r9
  ad3765:	inc    %r11
  ad3768:	inc    %r9
  ad376b:	mov    $0x1,%r8d
  ad3771:	mov    %r11,0x10(%rsp)
  ad3776:	test   %r14,%r14
  ad3779:	je     ad3829 <ir_typed_emit_function+0x1d69>
  ad377f:	mov    0x20(%rsp),%r11
  ad3784:	mov    0x80(%r14),%rsi
  ad378b:	mov    %r11d,%r10d
  ad378e:	shl    $0x4,%r10
  ad3792:	movq   $0x0,(%rsi,%r10,1)
  ad379a:	mov    %r8b,0x8(%rsi,%r10,1)
  ad379f:	movl   $0x0,0x9(%rsi,%r10,1)
  ad37a8:	movl   $0x0,0xc(%rsi,%r10,1)
  ad37b1:	mov    %r9d,%r10d
  ad37b4:	mov    %r9d,%r8d
  ad37b7:	inc    %r9
  ad37ba:	mov    (%r14),%rsi
  ad37bd:	movb   $0x2a,(%rsi,%r10,1)
  ad37c2:	mov    0x8(%r14),%rsi
  ad37c6:	movb   $0xa,(%rsi,%r10,1)
  ad37cb:	mov    0x20(%r14),%rsi
  ad37cf:	mov    %r15d,(%rsi,%r10,4)
  ad37d3:	mov    %r9,%r15
  ad37d6:	mov    0x28(%r14),%rsi
  ad37da:	mov    %eax,(%rsi,%r10,4)
  ad37de:	mov    %r9d,%esi
  ad37e1:	mov    0x30(%r14),%rax
  ad37e5:	mov    %r11d,(%rax,%r10,4)
  ad37e9:	mov    0x18(%r14),%rax
  ad37ed:	movb   $0x0,(%rax,%r10,1)
  ad37f2:	mov    (%r14),%rax
  ad37f5:	movb   $0x26,(%rax,%rsi,1)
  ad37f9:	mov    0x8(%r14),%rax
  ad37fd:	movb   $0x5,(%rax,%rsi,1)
  ad3801:	mov    0x20(%r14),%rax
  ad3805:	mov    %r8d,(%rax,%rsi,4)
  ad3809:	mov    0x28(%r14),%rax
  ad380d:	movl   $0xffffffff,(%rax,%rsi,4)
  ad3814:	mov    0x30(%r14),%rax
  ad3818:	movl   $0xffffffff,(%rax,%rsi,4)
  ad381f:	mov    0x18(%r14),%rax
  ad3823:	movb   $0x0,(%rax,%rsi,1)
  ad3827:	jmp    ad3834 <ir_typed_emit_function+0x1d74>
  ad3829:	mov    0x20(%rsp),%r11
  ad382e:	inc    %r9
  ad3831:	mov    %r9,%r15
  ad3834:	movzbl 0x6(%rsp),%esi
  ad3839:	inc    %r11
  ad383c:	mov    %r15d,%eax
  ad383f:	mov    %eax,(%r12,%rdi,4)
  ad3843:	inc    %r15
  ad3846:	mov    %r11,0x20(%rsp)
  ad384b:	mov    %sil,0x0(%r13,%rdi,1)
  ad3850:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad3855:	inc    %r15
  ad3858:	jmp    ad39d0 <ir_typed_emit_function+0x1f10>
  ad385d:	movzbl 0x6(%rsp),%r9d
  ad3863:	and    $0xf9,%r9b
  ad3867:	cmp    $0x1,%r9b
  ad386b:	mov    $0x24,%r9b
  ad386e:	jmp    ad387b <ir_typed_emit_function+0x1dbb>
  ad3870:	and    $0xf9,%r10b
  ad3874:	mov    $0x22,%r9b
  ad3877:	cmp    $0x1,%r10b
  ad387b:	sete   %r10b
  ad387f:	sub    %r10b,%r9b
  ad3882:	mov    0x8(%rsp),%rbx
  ad3887:	test   %r14,%r14
  ad388a:	je     ad38c7 <ir_typed_emit_function+0x1e07>
  ad388c:	mov    (%r14),%r10
  ad388f:	mov    %r15d,%r11d
  ad3892:	mov    %r9b,(%r10,%r11,1)
  ad3896:	mov    0x8(%r14),%r9
  ad389a:	mov    %sil,(%r9,%r11,1)
  ad389e:	mov    0x20(%r14),%rsi
  ad38a2:	mov    %r8d,(%rsi,%r11,4)
  ad38a6:	mov    0x28(%r14),%rsi
  ad38aa:	movl   $0xffffffff,(%rsi,%r11,4)
  ad38b2:	mov    0x30(%r14),%rsi
  ad38b6:	movl   $0xffffffff,(%rsi,%r11,4)
  ad38be:	mov    0x18(%r14),%rsi
  ad38c2:	movb   $0x0,(%rsi,%r11,1)
  ad38c7:	mov    %r15d,%r8d
  ad38ca:	inc    %r15
  ad38cd:	mov    %rdx,%rsi
  ad38d0:	movzbl 0x6(%rsp),%edx
  ad38d5:	mov    %r8d,(%r12,%rax,4)
  ad38d9:	mov    %dl,0x0(%r13,%rax,1)
  ad38de:	mov    %rsi,%rdx
  ad38e1:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad38e6:	lea    -0x7(%r10),%ebx
  ad38ea:	cmp    $0x2,%bl
  ad38ed:	ja     ad3914 <ir_typed_emit_function+0x1e54>
  ad38ef:	lea    -0x7(%rax),%ebx
  ad38f2:	cmp    $0x2,%bl
  ad38f5:	ja     ad3914 <ir_typed_emit_function+0x1e54>
  ad38f7:	mov    %edi,%ebx
  ad38f9:	lea    -0x5d8570(%rip),%rdi        # 4fb390 <ir_type_bits>
  ad3900:	movzwl (%rdi,%rsi,2),%esi
  ad3904:	cmp    (%rdi,%r10,2),%si
  ad3909:	mov    $0x20,%r10b
  ad390c:	mov    %ebx,%edi
  ad390e:	sbb    $0x0,%r10b
  ad3912:	jmp    ad3934 <ir_typed_emit_function+0x1e74>
  ad3914:	mov    %r9d,%esi
  ad3917:	mov    $0x24,%r10b
  ad391a:	and    $0xf9,%sil
  ad391e:	cmp    $0x1,%sil
  ad3922:	jmp    ad392d <ir_typed_emit_function+0x1e6d>
  ad3924:	and    $0xf9,%bl
  ad3927:	mov    $0x22,%r10b
  ad392a:	cmp    $0x1,%bl
  ad392d:	sete   %sil
  ad3931:	sub    %sil,%r10b
  ad3934:	mov    0x118(%rsp),%r12
  ad393c:	test   %r14,%r14
  ad393f:	je     ad3978 <ir_typed_emit_function+0x1eb8>
  ad3941:	mov    (%r14),%rsi
  ad3944:	mov    %r15d,%ebx
  ad3947:	mov    %r10b,(%rsi,%rbx,1)
  ad394b:	mov    0x8(%r14),%rsi
  ad394f:	mov    %al,(%rsi,%rbx,1)
  ad3952:	mov    0x20(%r14),%rax
  ad3956:	mov    %r11d,(%rax,%rbx,4)
  ad395a:	mov    0x28(%r14),%rax
  ad395e:	movl   $0xffffffff,(%rax,%rbx,4)
  ad3965:	mov    0x30(%r14),%rax
  ad3969:	movl   $0xffffffff,(%rax,%rbx,4)
  ad3970:	mov    0x18(%r14),%rax
  ad3974:	movb   $0x0,(%rax,%rbx,1)
  ad3978:	mov    %r15d,%r11d
  ad397b:	inc    %r15
  ad397e:	mov    0x8(%rsp),%rbx
  ad3983:	test   %r14,%r14
  ad3986:	je     ad39d0 <ir_typed_emit_function+0x1f10>
  ad3988:	mov    0x90(%rsp),%rax
  ad3990:	mov    (%r14),%rsi
  ad3993:	mov    %r15d,%r10d
  ad3996:	movzbl (%rax,%rcx,1),%eax
  ad399a:	mov    %al,(%rsi,%r10,1)
  ad399e:	movzbl 0x7(%rsp),%esi
  ad39a3:	mov    0x8(%r14),%rax
  ad39a7:	mov    %sil,(%rax,%r10,1)
  ad39ab:	mov    0x20(%r14),%rax
  ad39af:	mov    %edi,(%rax,%r10,4)
  ad39b3:	mov    0x28(%r14),%rax
  ad39b7:	mov    %r11d,(%rax,%r10,4)
  ad39bb:	mov    0x30(%r14),%rax
  ad39bf:	movl   $0xffffffff,(%rax,%r10,4)
  ad39c7:	mov    0x18(%r14),%rax
  ad39cb:	movb   $0x0,(%rax,%r10,1)
  ad39d0:	mov    0x18(%rsp),%r8
  ad39d5:	mov    %r15d,(%r12,%r8,4)
  ad39d9:	inc    %r15
  ad39dc:	mov    %r9b,0x0(%r13,%r8,1)
  ad39e1:	jmp    ad2200 <ir_typed_emit_function+0x740>
  ad39e6:	cs nopw 0x0(%rax,%rax,1)
  ad39f0:	lea    -0x4f4e07(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad39f7:	jmp    ad3a10 <ir_typed_emit_function+0x1f50>
  ad39f9:	nopl   0x0(%rax)
  ad3a00:	testb  $0x1,0x28(%rsp)
  ad3a05:	mov    0x68(%rsp),%r9
  ad3a0a:	jne    ad1ea7 <ir_typed_emit_function+0x3e7>
  ad3a10:	cmp    0x18(%rbx),%r9d
  ad3a14:	jne    ad3a80 <ir_typed_emit_function+0x1fc0>
  ad3a16:	cmpl   $0x0,0x54(%rsp)
  ad3a1b:	je     ad1e63 <ir_typed_emit_function+0x3a3>
  ad3a21:	test   %r14,%r14
  ad3a24:	je     ad3a64 <ir_typed_emit_function+0x1fa4>
  ad3a26:	mov    (%r14),%rax
  ad3a29:	mov    %r15d,%ecx
  ad3a2c:	mov    0x54(%rsp),%edx
  ad3a30:	movb   $0x2,(%rax,%rcx,1)
  ad3a34:	mov    0x8(%r14),%rax
  ad3a38:	mov    %dl,(%rax,%rcx,1)
  ad3a3b:	mov    0x20(%r14),%rax
  ad3a3f:	movl   $0xffffffff,(%rax,%rcx,4)
  ad3a46:	mov    0x28(%r14),%rax
  ad3a4a:	movl   $0xffffffff,(%rax,%rcx,4)
  ad3a51:	mov    0x30(%r14),%rax
  ad3a55:	movl   $0xffffffff,(%rax,%rcx,4)
  ad3a5c:	mov    0x18(%r14),%rax
  ad3a60:	movb   $0x0,(%rax,%rcx,1)
  ad3a64:	mov    %r15d,%eax
  ad3a67:	inc    %r15
  ad3a6a:	test   %r14,%r14
  ad3a6d:	jne    ad1e6d <ir_typed_emit_function+0x3ad>
  ad3a73:	jmp    ad1ea4 <ir_typed_emit_function+0x3e4>
  ad3a78:	nopl   0x0(%rax,%rax,1)
  ad3a80:	test   %ebp,%ebp
  ad3a82:	je     ad3a98 <ir_typed_emit_function+0x1fd8>
  ad3a84:	mov    0x30(%rbx),%eax
  ad3a87:	cmp    $0x1,%ebp
  ad3a8a:	jne    ad3ac9 <ir_typed_emit_function+0x2009>
  ad3a8c:	mov    0x58(%rsp),%rbp
  ad3a91:	xor    %ecx,%ecx
  ad3a93:	jmp    ad3c26 <ir_typed_emit_function+0x2166>
  ad3a98:	mov    0x58(%rsp),%rbp
  ad3a9d:	jmp    ad3c8a <ir_typed_emit_function+0x21ca>
  ad3aa2:	mov    $0x3,%dl
  ad3aa4:	test   %r14,%r14
  ad3aa7:	jne    ad2171 <ir_typed_emit_function+0x6b1>
  ad3aad:	jmp    ad21bc <ir_typed_emit_function+0x6fc>
  ad3ab2:	add    $0xfd,%dl
  ad3ab5:	cmp    $0x2,%dl
  ad3ab8:	setb   %dl
  ad3abb:	test   %r14,%r14
  ad3abe:	jne    ad2171 <ir_typed_emit_function+0x6b1>
  ad3ac4:	jmp    ad21bc <ir_typed_emit_function+0x6fc>
  ad3ac9:	mov    %ebp,%edx
  ad3acb:	mov    0x58(%rsp),%rbp
  ad3ad0:	mov    %edx,%esi
  ad3ad2:	and    $0xfffffffe,%esi
  ad3ad5:	mov    %eax,%edi
  ad3ad7:	xor    %ecx,%ecx
  ad3ad9:	jmp    ad3b3c <ir_typed_emit_function+0x207c>
  ad3adb:	nopl   0x0(%rax,%rax,1)
  ad3ae0:	mov    $0x3,%r9b
  ad3ae3:	test   %r14,%r14
  ad3ae6:	je     ad3b28 <ir_typed_emit_function+0x2068>
  ad3ae8:	mov    (%r14),%rbx
  ad3aeb:	lea    0x1(%r15),%r10
  ad3aef:	lea    0x1(%rdi),%r11d
  ad3af3:	mov    %r10d,%r10d
  ad3af6:	movb   $0x2c,(%rbx,%r10,1)
  ad3afb:	mov    0x8(%r14),%rbx
  ad3aff:	movb   $0x0,(%rbx,%r10,1)
  ad3b04:	mov    0x20(%r14),%rbx
  ad3b08:	mov    %r11d,(%rbx,%r10,4)
  ad3b0c:	mov    0x28(%r14),%r11
  ad3b10:	mov    %r8d,(%r11,%r10,4)
  ad3b14:	mov    0x30(%r14),%r8
  ad3b18:	movl   $0xffffffff,(%r8,%r10,4)
  ad3b20:	mov    0x18(%r14),%r8
  ad3b24:	mov    %r9b,(%r8,%r10,1)
  ad3b28:	add    $0x2,%r15
  ad3b2c:	add    $0x2,%rcx
  ad3b30:	add    $0x2,%edi
  ad3b33:	cmp    %rcx,%rsi
  ad3b36:	je     ad3c1a <ir_typed_emit_function+0x215a>
  ad3b3c:	movzbl 0x0(%r13,%rcx,1),%r9d
  ad3b42:	lea    -0x4f4f59(%rip),%r8        # 5debf0 <tier0_class_bytes.bytes>
  ad3b49:	and    $0xf,%r9d
  ad3b4d:	movzbl (%r9,%r8,1),%r10d
  ad3b52:	cmp    $0x4,%r10d
  ad3b56:	je     ad3bf0 <ir_typed_emit_function+0x2130>
  ad3b5c:	mov    $0x3,%r8b
  ad3b5f:	cmp    $0x8,%r10d
  ad3b63:	je     ad3b71 <ir_typed_emit_function+0x20b1>
  ad3b65:	add    $0xfd,%r9b
  ad3b69:	cmp    $0x2,%r9b
  ad3b6d:	setb   %r8b
  ad3b71:	test   %r14,%r14
  ad3b74:	je     ad3bb2 <ir_typed_emit_function+0x20f2>
  ad3b76:	mov    (%r14),%r10
  ad3b79:	mov    (%r12,%rcx,4),%r9d
  ad3b7d:	mov    %r15d,%r11d
  ad3b80:	movb   $0x2c,(%r10,%r11,1)
  ad3b85:	mov    0x8(%r14),%r10
  ad3b89:	movb   $0x0,(%r10,%r11,1)
  ad3b8e:	mov    0x20(%r14),%r10
  ad3b92:	mov    %edi,(%r10,%r11,4)
  ad3b96:	mov    0x28(%r14),%r10
  ad3b9a:	mov    %r9d,(%r10,%r11,4)
  ad3b9e:	mov    0x30(%r14),%r9
  ad3ba2:	movl   $0xffffffff,(%r9,%r11,4)
  ad3baa:	mov    0x18(%r14),%r9
  ad3bae:	mov    %r8b,(%r9,%r11,1)
  ad3bb2:	movzbl 0x1(%r13,%rcx,1),%r9d
  ad3bb8:	lea    -0x4f4fcf(%rip),%r10        # 5debf0 <tier0_class_bytes.bytes>
  ad3bbf:	mov    0x4(%r12,%rcx,4),%r8d
  ad3bc4:	and    $0xf,%r9d
  ad3bc8:	movzbl (%r9,%r10,1),%r10d
  ad3bcd:	cmp    $0x8,%r10d
  ad3bd1:	je     ad3ae0 <ir_typed_emit_function+0x2020>
  ad3bd7:	cmp    $0x4,%r10d
  ad3bdb:	jne    ad3c00 <ir_typed_emit_function+0x2140>
  ad3bdd:	mov    $0x2,%r9b
  ad3be0:	test   %r14,%r14
  ad3be3:	jne    ad3ae8 <ir_typed_emit_function+0x2028>
  ad3be9:	jmp    ad3b28 <ir_typed_emit_function+0x2068>
  ad3bee:	xchg   %ax,%ax
  ad3bf0:	mov    $0x2,%r8b
  ad3bf3:	test   %r14,%r14
  ad3bf6:	jne    ad3b76 <ir_typed_emit_function+0x20b6>
  ad3bfc:	jmp    ad3bb2 <ir_typed_emit_function+0x20f2>
  ad3bfe:	xchg   %ax,%ax
  ad3c00:	add    $0xfd,%r9b
  ad3c04:	cmp    $0x2,%r9b
  ad3c08:	setb   %r9b
  ad3c0c:	test   %r14,%r14
  ad3c0f:	jne    ad3ae8 <ir_typed_emit_function+0x2028>
  ad3c15:	jmp    ad3b28 <ir_typed_emit_function+0x2068>
  ad3c1a:	test   $0x1,%dl
  ad3c1d:	lea    -0x4f5034(%rip),%rdx        # 5debf0 <tier0_class_bytes.bytes>
  ad3c24:	je     ad3c8a <ir_typed_emit_function+0x21ca>
  ad3c26:	mov    %rdx,%rsi
  ad3c29:	movzbl 0x0(%r13,%rcx,1),%edx
  ad3c2f:	and    $0xf,%edx
  ad3c32:	movzbl (%rdx,%rsi,1),%esi
  ad3c36:	cmp    $0x8,%esi
  ad3c39:	je     ad3cd2 <ir_typed_emit_function+0x2212>
  ad3c3f:	cmp    $0x4,%esi
  ad3c42:	jne    ad3cdf <ir_typed_emit_function+0x221f>
  ad3c48:	mov    $0x2,%dl
  ad3c4a:	test   %r14,%r14
  ad3c4d:	je     ad3c87 <ir_typed_emit_function+0x21c7>
  ad3c4f:	mov    (%r14),%rsi
  ad3c52:	add    %ecx,%eax
  ad3c54:	mov    (%r12,%rcx,4),%ecx
  ad3c58:	mov    %r15d,%edi
  ad3c5b:	movb   $0x2c,(%rsi,%rdi,1)
  ad3c5f:	mov    0x8(%r14),%rsi
  ad3c63:	movb   $0x0,(%rsi,%rdi,1)
  ad3c67:	mov    0x20(%r14),%rsi
  ad3c6b:	mov    %eax,(%rsi,%rdi,4)
  ad3c6e:	mov    0x28(%r14),%rax
  ad3c72:	mov    %ecx,(%rax,%rdi,4)
  ad3c75:	mov    0x30(%r14),%rax
  ad3c79:	movl   $0xffffffff,(%rax,%rdi,4)
  ad3c80:	mov    0x18(%r14),%rax
  ad3c84:	mov    %dl,(%rax,%rdi,1)
  ad3c87:	inc    %r15
  ad3c8a:	test   %r14,%r14
  ad3c8d:	je     ad1ea4 <ir_typed_emit_function+0x3e4>
  ad3c93:	mov    (%r14),%rax
  ad3c96:	mov    %r15d,%ecx
  ad3c99:	add    $0x2,%ebp
  ad3c9c:	movb   $0x30,(%rax,%rcx,1)
  ad3ca0:	mov    0x8(%r14),%rax
  ad3ca4:	movb   $0x0,(%rax,%rcx,1)
  ad3ca8:	mov    0x20(%r14),%rax
  ad3cac:	mov    %ebp,(%rax,%rcx,4)
  ad3caf:	mov    0x28(%r14),%rax
  ad3cb3:	movl   $0xffffffff,(%rax,%rcx,4)
  ad3cba:	mov    0x30(%r14),%rax
  ad3cbe:	movl   $0xffffffff,(%rax,%rcx,4)
  ad3cc5:	mov    0x18(%r14),%rax
  ad3cc9:	movb   $0x0,(%rax,%rcx,1)
  ad3ccd:	jmp    ad1ea4 <ir_typed_emit_function+0x3e4>
  ad3cd2:	mov    $0x3,%dl
  ad3cd4:	test   %r14,%r14
  ad3cd7:	jne    ad3c4f <ir_typed_emit_function+0x218f>
  ad3cdd:	jmp    ad3c87 <ir_typed_emit_function+0x21c7>
  ad3cdf:	add    $0xfd,%dl
  ad3ce2:	cmp    $0x2,%dl
  ad3ce5:	setb   %dl
  ad3ce8:	test   %r14,%r14
  ad3ceb:	jne    ad3c4f <ir_typed_emit_function+0x218f>
  ad3cf1:	jmp    ad3c87 <ir_typed_emit_function+0x21c7>
  ad3cf3:	inc    %eax
  ad3cf5:	test   %r14,%r14
  ad3cf8:	je     ad3d02 <ir_typed_emit_function+0x2242>
  ad3cfa:	mov    0x40(%r14),%rcx
  ad3cfe:	mov    %r15d,(%rcx,%rax,4)
  ad3d02:	mov    0xa8(%rsp),%rdx
  ad3d0a:	mov    0xb8(%rsp),%rax
  ad3d12:	mov    0xb0(%rsp),%rcx
  ad3d1a:	add    0xa0(%rsp),%rcx
  ad3d22:	inc    %rdx
  ad3d25:	mov    %r15,(%rax)
  ad3d28:	mov    %rdx,0x8(%rax)
  ad3d2c:	mov    %r9,0x10(%rax)
  ad3d30:	mov    0x10(%rsp),%r9
  ad3d35:	mov    0x78(%rsp),%rdx
  ad3d3a:	mov    %r9,0x18(%rax)
  ad3d3e:	mov    %rcx,0x20(%rax)
  ad3d42:	mov    %r8,0x28(%rax)
  ad3d46:	mov    %rdi,0x30(%rax)
  ad3d4a:	mov    %rsi,0x38(%rax)
  ad3d4e:	mov    %rdx,0x40(%rax)
  ad3d52:	add    $0xd8,%rsp
  ad3d59:	pop    %rbx
  ad3d5a:	pop    %r12
  ad3d5c:	pop    %r13
  ad3d5e:	pop    %r14
  ad3d60:	pop    %r15
  ad3d62:	pop    %rbp
  ad3d63:	ret
  ad3d64:	mov    $0x1,%eax
  ad3d69:	xor    %r8d,%r8d
  ad3d6c:	xor    %edi,%edi
  ad3d6e:	movq   $0x0,0x10(%rsp)
  ad3d77:	xor    %r9d,%r9d
  ad3d7a:	xor    %esi,%esi
  ad3d7c:	test   %r14,%r14
  ad3d7f:	jne    ad3cfa <ir_typed_emit_function+0x223a>
  ad3d85:	jmp    ad3d02 <ir_typed_emit_function+0x2242>
