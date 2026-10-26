
../campaign/native-images/base/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001009c10 <check_program>:
 1009c10:	push   %rbp
 1009c11:	push   %r15
 1009c13:	push   %r14
 1009c15:	push   %r13
 1009c17:	push   %r12
 1009c19:	push   %rbx
 1009c1a:	sub    $0x2c8,%rsp
 1009c21:	mov    %fs:0x28,%rax
 1009c2a:	mov    %rdx,%rbp
 1009c2d:	mov    %rdi,%r12
 1009c30:	vxorps %xmm0,%xmm0,%xmm0
 1009c34:	mov    0x328(%rsp),%r11
 1009c3c:	xor    %r14d,%r14d
 1009c3f:	mov    %rax,0x2c0(%rsp)
 1009c47:	mov    %rsi,0x40(%rsp)
 1009c4c:	mov    %r9,0x38(%rsp)
 1009c51:	mov    0x310(%rsp),%rdx
 1009c59:	mov    0x300(%rsp),%r13
 1009c61:	mov    0x308(%rsp),%r10
 1009c69:	movzwl 0x325(%rsp),%edi
 1009c71:	mov    %rbp,(%r12)
 1009c75:	mov    %rcx,0x8(%r12)
 1009c7a:	mov    %r8,0x10(%r12)
 1009c7f:	mov    %rsi,0x18(%r12)
 1009c84:	mov    %rdx,0x20(%r12)
 1009c89:	mov    %r13,0x28(%r12)
 1009c8e:	mov    %r10,0x30(%r12)
 1009c93:	vmovups %zmm0,0x38(%r12)
 1009c9e:	vmovups %zmm0,0x74(%r12)
 1009ca9:	movq   $0xffffffffffffffff,0xb4(%r12)
 1009cb5:	movl   $0x0,0xbc(%r12)
 1009cc1:	movq   $0x0,0xc0(%r12)
 1009ccd:	mov    %di,0xc8(%r12)
 1009cd6:	movl   $0x0,0xca(%r12)
 1009ce2:	movw   $0x0,0xce(%r12)
 1009ced:	mov    %r11,%rdi
 1009cf0:	mov    0x8c(%rbp),%edx
 1009cf6:	mov    0x35c(%rbp),%eax
 1009cfc:	mov    %rdx,0x90(%rsp)
 1009d04:	cmp    %r11,%r9
 1009d07:	je     1009d55 <check_program+0x145>
 1009d09:	cmp    $0x1ffffffc,%eax
 1009d0e:	ja     1009d55 <check_program+0x145>
 1009d10:	mov    0x40(%rsp),%rsi
 1009d15:	cmp    0x30(%rsi),%eax
 1009d18:	jne    1009d55 <check_program+0x145>
 1009d1a:	cmpl   $0x0,0xd8(%rcx)
 1009d21:	jne    1009d52 <check_program+0x142>
 1009d23:	mov    0x90(%rsp),%rdx
 1009d2b:	cmp    %edx,0xa0(%rcx)
 1009d31:	jne    1009d52 <check_program+0x142>
 1009d33:	cmpl   $0x0,0xa4(%rcx)
 1009d3a:	jne    1009d52 <check_program+0x142>
 1009d3c:	cmpb   $0x0,0x3bd(%rbp)
 1009d43:	jne    1009d52 <check_program+0x142>
 1009d45:	cmpl   $0x0,0x230(%rbp)
 1009d4c:	je     100fe6d <check_program+0x625d>
 1009d52:	xor    %r14d,%r14d
 1009d55:	mov    0x38(%rsp),%rcx
 1009d5a:	lea    0x10(,%rax,8),%r9d
 1009d62:	mov    %r8,0x188(%rsp)
 1009d6a:	mov    %r12,0x8(%rsp)
 1009d6f:	mov    %rax,0x50(%rsp)
 1009d74:	mov    %r13,0x10(%rsp)
 1009d79:	mov    %r14d,0x80(%rsp)
 1009d81:	vmovd  %r9d,%xmm0
 1009d86:	mov    0x8(%rcx),%rcx
 1009d8a:	mov    %rcx,0x178(%rsp)
 1009d92:	mov    0x8(%rdi),%rcx
 1009d96:	mov    %rcx,0x170(%rsp)
 1009d9e:	lea    0x1(%rax),%ecx
 1009da1:	mov    %ecx,0xe4(%rsp)
 1009da8:	mov    %ecx,0xac(%r12)
 1009db0:	mov    %r14d,%ecx
 1009db3:	xor    $0x1,%cl
 1009db6:	movzbl %cl,%ecx
 1009db9:	mov    %ecx,0xbc(%r12)
 1009dc1:	test   %cl,%cl
 1009dc3:	jne    1009eb2 <check_program+0x2a2>
 1009dc9:	mov    (%rdi),%rcx
 1009dcc:	mov    %rdi,%r11
 1009dcf:	mov    0x8(%rdi),%rdi
 1009dd3:	mov    %eax,%eax
 1009dd5:	lea    0x4(,%rax,4),%r8
 1009ddd:	mov    %rax,0x70(%rsp)
 1009de2:	lea    0x3(%rdi,%rcx,1),%rbx
 1009de7:	lea    (%rdi,%rcx,1),%r10
 1009deb:	and    $0xfffffffffffffffc,%rbx
 1009def:	cmp    %r10,%rbx
 1009df2:	jae    1009fc8 <check_program+0x3b8>
 1009df8:	xor    %r14d,%r14d
 1009dfb:	xor    %ebx,%ebx
 1009dfd:	movq   $0x0,0xa8(%rsp)
 1009e09:	xor    %r15d,%r15d
 1009e0c:	mov    0x90(%rsp),%r10
 1009e14:	movq   $0x0,0x28(%rsp)
 1009e1d:	xor    %r13d,%r13d
 1009e20:	mov    %r15,%rsi
 1009e23:	mov    %rbx,%rdx
 1009e26:	mov    %r14,%rax
 1009e29:	lea    0x4(,%r10,4),%r10
 1009e31:	xor    %r15d,%r15d
 1009e34:	xor    %r14d,%r14d
 1009e37:	cmpq   $0x0,0x10(%rsp)
 1009e3d:	mov    %r14,0x98(%rsp)
 1009e45:	mov    %r15,0xf0(%rsp)
 1009e4d:	je     1009e65 <check_program+0x255>
 1009e4f:	lea    0x3(%rdi,%rcx,1),%r11
 1009e54:	lea    (%rdi,%rcx,1),%rbx
 1009e58:	and    $0xfffffffffffffffc,%r11
 1009e5c:	cmp    %rbx,%r11
 1009e5f:	jae    100a78d <check_program+0xb7d>
 1009e65:	movq   $0x0,0x48(%rsp)
 1009e6e:	lea    0x3(%rdi,%rcx,1),%rbx
 1009e73:	lea    (%rdi,%rcx,1),%r11
 1009e77:	and    $0xfffffffffffffffc,%rbx
 1009e7b:	mov    %rbx,%r14
 1009e7e:	sub    %rcx,%r14
 1009e81:	cmp    %r11,%rbx
 1009e84:	jae    100a009 <check_program+0x3f9>
 1009e8a:	mov    $0x0,%r15d
 1009e90:	movq   $0x0,0x130(%rsp)
 1009e9c:	mov    %r15,0x150(%rsp)
 1009ea4:	cmp    %r11,%rbx
 1009ea7:	jae    100a050 <check_program+0x440>
 1009ead:	jmp    100a0b3 <check_program+0x4a3>
 1009eb2:	movq   $0x0,0x110(%rsp)
 1009ebe:	movq   $0x0,0x60(%rsp)
 1009ec7:	movq   $0x0,0x88(%rsp)
 1009ed3:	xor    %r13d,%r13d
 1009ed6:	xor    %r15d,%r15d
 1009ed9:	movq   $0x0,0x20(%rsp)
 1009ee2:	movq   $0x0,0x148(%rsp)
 1009eee:	movq   $0x0,0x100(%rsp)
 1009efa:	movq   $0x0,0x108(%rsp)
 1009f06:	movq   $0x0,0xc8(%rsp)
 1009f12:	movq   $0x0,0x120(%rsp)
 1009f1e:	movq   $0x0,0x150(%rsp)
 1009f2a:	movq   $0x0,0x48(%rsp)
 1009f33:	xor    %r11d,%r11d
 1009f36:	xor    %r10d,%r10d
 1009f39:	xor    %edi,%edi
 1009f3b:	xor    %ecx,%ecx
 1009f3d:	xor    %esi,%esi
 1009f3f:	xor    %r9d,%r9d
 1009f42:	xor    %r14d,%r14d
 1009f45:	xor    %r8d,%r8d
 1009f48:	movq   $0x0,0x130(%rsp)
 1009f54:	movq   $0x0,0xf8(%rsp)
 1009f60:	movq   $0x0,0xe8(%rsp)
 1009f6c:	movq   $0x0,0x138(%rsp)
 1009f78:	movq   $0x0,0x128(%rsp)
 1009f84:	movq   $0x0,0x160(%rsp)
 1009f90:	movq   $0x0,0x140(%rsp)
 1009f9c:	movq   $0x0,0x18(%rsp)
 1009fa5:	xor    %eax,%eax
 1009fa7:	xor    %edx,%edx
 1009fa9:	movq   $0x0,0x168(%rsp)
 1009fb5:	xor    %ebx,%ebx
 1009fb7:	movq   $0x0,0x158(%rsp)
 1009fc3:	jmp    100a9e2 <check_program+0xdd2>
 1009fc8:	mov    0x10(%r11),%r11
 1009fcc:	mov    %rbx,%r10
 1009fcf:	sub    %rcx,%r10
 1009fd2:	xor    %eax,%eax
 1009fd4:	sub    %r10,%r11
 1009fd7:	jb     100a7e7 <check_program+0xbd7>
 1009fdd:	cmp    %r11,%r8
 1009fe0:	ja     100a7e7 <check_program+0xbd7>
 1009fe6:	mov    0x328(%rsp),%r11
 1009fee:	mov    %rbx,%rax
 1009ff1:	add    %r8,%rbx
 1009ff4:	mov    %r10,%rdi
 1009ff7:	add    %r8,%rdi
 1009ffa:	mov    %rbx,%r10
 1009ffd:	sub    %rcx,%r10
 100a000:	mov    %rdi,0x8(%r11)
 100a004:	jmp    100a7ef <check_program+0xbdf>
 100a009:	mov    0x328(%rsp),%r15
 100a011:	mov    0x10(%r15),%r15
 100a015:	sub    %r14,%r15
 100a018:	jb     1009e8a <check_program+0x27a>
 100a01e:	cmp    %r15,%r8
 100a021:	ja     1009e8a <check_program+0x27a>
 100a027:	mov    0x328(%rsp),%rdi
 100a02f:	mov    %rbx,%r11
 100a032:	add    %r8,%r14
 100a035:	add    %r8,%r11
 100a038:	mov    %rbx,0x130(%rsp)
 100a040:	mov    %r11,%rbx
 100a043:	mov    %r14,0x8(%rdi)
 100a047:	mov    %r14,%rdi
 100a04a:	mov    %r11,%r14
 100a04d:	sub    %rcx,%r14
 100a050:	mov    0x328(%rsp),%r15
 100a058:	movq   $0x0,0x150(%rsp)
 100a064:	mov    0x10(%r15),%r15
 100a068:	sub    %r14,%r15
 100a06b:	jb     100a0b3 <check_program+0x4a3>
 100a06d:	mov    0x330(%rbp),%r12d
 100a074:	lea    0x4(,%r12,4),%r12
 100a07c:	cmp    %r15,%r12
 100a07f:	ja     100a0ae <check_program+0x49e>
 100a081:	mov    0x328(%rsp),%r11
 100a089:	mov    %r14,%rdi
 100a08c:	add    %r12,%rdi
 100a08f:	mov    %rbx,0x150(%rsp)
 100a097:	lea    0x3(%rcx,%rdi,1),%rbx
 100a09c:	and    $0xfffffffffffffffc,%rbx
 100a0a0:	mov    %rbx,%r14
 100a0a3:	sub    %rcx,%r14
 100a0a6:	mov    %rdi,0x8(%r11)
 100a0aa:	lea    (%rdi,%rcx,1),%r11
 100a0ae:	mov    0x8(%rsp),%r12
 100a0b3:	cmp    %r11,%rbx
 100a0b6:	jae    100a0c6 <check_program+0x4b6>
 100a0b8:	movq   $0x0,0xf8(%rsp)
 100a0c4:	jmp    100a115 <check_program+0x505>
 100a0c6:	mov    0x328(%rsp),%r15
 100a0ce:	movq   $0x0,0xf8(%rsp)
 100a0da:	mov    0x10(%r15),%r15
 100a0de:	sub    %r14,%r15
 100a0e1:	jb     100a115 <check_program+0x505>
 100a0e3:	cmp    %r15,%r8
 100a0e6:	ja     100a115 <check_program+0x505>
 100a0e8:	mov    0x328(%rsp),%r11
 100a0f0:	mov    %r14,%rdi
 100a0f3:	add    %r8,%rdi
 100a0f6:	mov    %rbx,0xf8(%rsp)
 100a0fe:	lea    0x3(%rcx,%rdi,1),%rbx
 100a103:	and    $0xfffffffffffffffc,%rbx
 100a107:	mov    %rbx,%r14
 100a10a:	sub    %rcx,%r14
 100a10d:	mov    %rdi,0x8(%r11)
 100a111:	lea    (%rdi,%rcx,1),%r11
 100a115:	cmp    %r11,%rbx
 100a118:	jae    100a128 <check_program+0x518>
 100a11a:	movq   $0x0,0x120(%rsp)
 100a126:	jmp    100a177 <check_program+0x567>
 100a128:	mov    0x328(%rsp),%r15
 100a130:	movq   $0x0,0x120(%rsp)
 100a13c:	mov    0x10(%r15),%r15
 100a140:	sub    %r14,%r15
 100a143:	jb     100a177 <check_program+0x567>
 100a145:	cmp    %r15,%r8
 100a148:	ja     100a177 <check_program+0x567>
 100a14a:	mov    0x328(%rsp),%r11
 100a152:	mov    %r14,%rdi
 100a155:	add    %r8,%rdi
 100a158:	mov    %rbx,0x120(%rsp)
 100a160:	lea    0x3(%rcx,%rdi,1),%rbx
 100a165:	and    $0xfffffffffffffffc,%rbx
 100a169:	mov    %rbx,%r14
 100a16c:	sub    %rcx,%r14
 100a16f:	mov    %rdi,0x8(%r11)
 100a173:	lea    (%rdi,%rcx,1),%r11
 100a177:	cmp    %r11,%rbx
 100a17a:	jae    100a18a <check_program+0x57a>
 100a17c:	movq   $0x0,0xe8(%rsp)
 100a188:	jmp    100a1d9 <check_program+0x5c9>
 100a18a:	mov    0x328(%rsp),%r15
 100a192:	movq   $0x0,0xe8(%rsp)
 100a19e:	mov    0x10(%r15),%r15
 100a1a2:	sub    %r14,%r15
 100a1a5:	jb     100a1d9 <check_program+0x5c9>
 100a1a7:	cmp    %r15,%r8
 100a1aa:	ja     100a1d9 <check_program+0x5c9>
 100a1ac:	mov    0x328(%rsp),%r11
 100a1b4:	mov    %r14,%rdi
 100a1b7:	add    %r8,%rdi
 100a1ba:	mov    %rbx,0xe8(%rsp)
 100a1c2:	lea    0x3(%rcx,%rdi,1),%rbx
 100a1c7:	and    $0xfffffffffffffffc,%rbx
 100a1cb:	mov    %rbx,%r14
 100a1ce:	sub    %rcx,%r14
 100a1d1:	mov    %rdi,0x8(%r11)
 100a1d5:	lea    (%rdi,%rcx,1),%r11
 100a1d9:	cmp    %r11,%rbx
 100a1dc:	jae    100a1ec <check_program+0x5dc>
 100a1de:	movq   $0x0,0xc8(%rsp)
 100a1ea:	jmp    100a23b <check_program+0x62b>
 100a1ec:	mov    0x328(%rsp),%r15
 100a1f4:	movq   $0x0,0xc8(%rsp)
 100a200:	mov    0x10(%r15),%r15
 100a204:	sub    %r14,%r15
 100a207:	jb     100a23b <check_program+0x62b>
 100a209:	cmp    %r15,%r8
 100a20c:	ja     100a23b <check_program+0x62b>
 100a20e:	mov    0x328(%rsp),%r11
 100a216:	mov    %r14,%rdi
 100a219:	add    %r8,%rdi
 100a21c:	mov    %rbx,0xc8(%rsp)
 100a224:	lea    0x3(%rcx,%rdi,1),%rbx
 100a229:	and    $0xfffffffffffffffc,%rbx
 100a22d:	mov    %rbx,%r14
 100a230:	sub    %rcx,%r14
 100a233:	mov    %rdi,0x8(%r11)
 100a237:	lea    (%rdi,%rcx,1),%r11
 100a23b:	cmp    %r11,%rbx
 100a23e:	jae    100a24e <check_program+0x63e>
 100a240:	movq   $0x0,0x138(%rsp)
 100a24c:	jmp    100a29d <check_program+0x68d>
 100a24e:	mov    0x328(%rsp),%r15
 100a256:	movq   $0x0,0x138(%rsp)
 100a262:	mov    0x10(%r15),%r15
 100a266:	sub    %r14,%r15
 100a269:	jb     100a29d <check_program+0x68d>
 100a26b:	cmp    %r15,%r8
 100a26e:	ja     100a29d <check_program+0x68d>
 100a270:	mov    0x328(%rsp),%r11
 100a278:	mov    %r14,%rdi
 100a27b:	add    %r8,%rdi
 100a27e:	mov    %rbx,0x138(%rsp)
 100a286:	lea    0x3(%rcx,%rdi,1),%rbx
 100a28b:	and    $0xfffffffffffffffc,%rbx
 100a28f:	mov    %rbx,%r14
 100a292:	sub    %rcx,%r14
 100a295:	mov    %rdi,0x8(%r11)
 100a299:	lea    (%rdi,%rcx,1),%r11
 100a29d:	cmp    %r11,%rbx
 100a2a0:	jae    100a2b0 <check_program+0x6a0>
 100a2a2:	movq   $0x0,0x108(%rsp)
 100a2ae:	jmp    100a2ff <check_program+0x6ef>
 100a2b0:	mov    0x328(%rsp),%r15
 100a2b8:	movq   $0x0,0x108(%rsp)
 100a2c4:	mov    0x10(%r15),%r15
 100a2c8:	sub    %r14,%r15
 100a2cb:	jb     100a2ff <check_program+0x6ef>
 100a2cd:	cmp    %r15,%r8
 100a2d0:	ja     100a2ff <check_program+0x6ef>
 100a2d2:	mov    0x328(%rsp),%r11
 100a2da:	mov    %r14,%rdi
 100a2dd:	add    %r8,%rdi
 100a2e0:	mov    %rbx,0x108(%rsp)
 100a2e8:	lea    0x3(%rcx,%rdi,1),%rbx
 100a2ed:	and    $0xfffffffffffffffc,%rbx
 100a2f1:	mov    %rbx,%r14
 100a2f4:	sub    %rcx,%r14
 100a2f7:	mov    %rdi,0x8(%r11)
 100a2fb:	lea    (%rdi,%rcx,1),%r11
 100a2ff:	cmp    %r11,%rbx
 100a302:	jae    100a312 <check_program+0x702>
 100a304:	movq   $0x0,0x128(%rsp)
 100a310:	jmp    100a361 <check_program+0x751>
 100a312:	mov    0x328(%rsp),%r15
 100a31a:	movq   $0x0,0x128(%rsp)
 100a326:	mov    0x10(%r15),%r15
 100a32a:	sub    %r14,%r15
 100a32d:	jb     100a361 <check_program+0x751>
 100a32f:	cmp    %r15,%r8
 100a332:	ja     100a361 <check_program+0x751>
 100a334:	mov    0x328(%rsp),%r11
 100a33c:	mov    %r14,%rdi
 100a33f:	add    %r8,%rdi
 100a342:	mov    %rbx,0x128(%rsp)
 100a34a:	lea    0x3(%rcx,%rdi,1),%rbx
 100a34f:	and    $0xfffffffffffffffc,%rbx
 100a353:	mov    %rbx,%r14
 100a356:	sub    %rcx,%r14
 100a359:	mov    %rdi,0x8(%r11)
 100a35d:	lea    (%rdi,%rcx,1),%r11
 100a361:	cmp    %r11,%rbx
 100a364:	jae    100a374 <check_program+0x764>
 100a366:	movq   $0x0,0x100(%rsp)
 100a372:	jmp    100a3c3 <check_program+0x7b3>
 100a374:	mov    0x328(%rsp),%r15
 100a37c:	movq   $0x0,0x100(%rsp)
 100a388:	mov    0x10(%r15),%r15
 100a38c:	sub    %r14,%r15
 100a38f:	jb     100a3c3 <check_program+0x7b3>
 100a391:	cmp    %r15,%r8
 100a394:	ja     100a3c3 <check_program+0x7b3>
 100a396:	mov    0x328(%rsp),%r11
 100a39e:	mov    %r14,%rdi
 100a3a1:	add    %r8,%rdi
 100a3a4:	mov    %rbx,0x100(%rsp)
 100a3ac:	lea    0x3(%rcx,%rdi,1),%rbx
 100a3b1:	and    $0xfffffffffffffffc,%rbx
 100a3b5:	mov    %rbx,%r14
 100a3b8:	sub    %rcx,%r14
 100a3bb:	mov    %rdi,0x8(%r11)
 100a3bf:	lea    (%rdi,%rcx,1),%r11
 100a3c3:	cmp    %r11,%rbx
 100a3c6:	jae    100a3d6 <check_program+0x7c6>
 100a3c8:	movq   $0x0,0x160(%rsp)
 100a3d4:	jmp    100a425 <check_program+0x815>
 100a3d6:	mov    0x328(%rsp),%r15
 100a3de:	movq   $0x0,0x160(%rsp)
 100a3ea:	mov    0x10(%r15),%r15
 100a3ee:	sub    %r14,%r15
 100a3f1:	jb     100a425 <check_program+0x815>
 100a3f3:	cmp    %r15,%r8
 100a3f6:	ja     100a425 <check_program+0x815>
 100a3f8:	mov    0x328(%rsp),%r11
 100a400:	mov    %r14,%rdi
 100a403:	add    %r8,%rdi
 100a406:	mov    %rbx,0x160(%rsp)
 100a40e:	lea    0x3(%rcx,%rdi,1),%rbx
 100a413:	and    $0xfffffffffffffffc,%rbx
 100a417:	mov    %rbx,%r14
 100a41a:	sub    %rcx,%r14
 100a41d:	mov    %rdi,0x8(%r11)
 100a421:	lea    (%rdi,%rcx,1),%r11
 100a425:	cmp    %r11,%rbx
 100a428:	jae    100a438 <check_program+0x828>
 100a42a:	movq   $0x0,0x148(%rsp)
 100a436:	jmp    100a487 <check_program+0x877>
 100a438:	mov    0x328(%rsp),%r15
 100a440:	movq   $0x0,0x148(%rsp)
 100a44c:	mov    0x10(%r15),%r15
 100a450:	sub    %r14,%r15
 100a453:	jb     100a487 <check_program+0x877>
 100a455:	cmp    %r15,%r8
 100a458:	ja     100a487 <check_program+0x877>
 100a45a:	mov    0x328(%rsp),%r11
 100a462:	mov    %r14,%rdi
 100a465:	add    %r8,%rdi
 100a468:	mov    %rbx,0x148(%rsp)
 100a470:	lea    0x3(%rcx,%rdi,1),%rbx
 100a475:	and    $0xfffffffffffffffc,%rbx
 100a479:	mov    %rbx,%r14
 100a47c:	sub    %rcx,%r14
 100a47f:	mov    %rdi,0x8(%r11)
 100a483:	lea    (%rdi,%rcx,1),%r11
 100a487:	cmp    %r11,%rbx
 100a48a:	jae    100a49a <check_program+0x88a>
 100a48c:	movq   $0x0,0x140(%rsp)
 100a498:	jmp    100a4e9 <check_program+0x8d9>
 100a49a:	mov    0x328(%rsp),%r15
 100a4a2:	movq   $0x0,0x140(%rsp)
 100a4ae:	mov    0x10(%r15),%r15
 100a4b2:	sub    %r14,%r15
 100a4b5:	jb     100a4e9 <check_program+0x8d9>
 100a4b7:	cmp    %r15,%r8
 100a4ba:	ja     100a4e9 <check_program+0x8d9>
 100a4bc:	mov    0x328(%rsp),%r11
 100a4c4:	mov    %r14,%rdi
 100a4c7:	add    %r8,%rdi
 100a4ca:	mov    %rbx,0x140(%rsp)
 100a4d2:	lea    0x3(%rcx,%rdi,1),%rbx
 100a4d7:	and    $0xfffffffffffffffc,%rbx
 100a4db:	mov    %rbx,%r14
 100a4de:	sub    %rcx,%r14
 100a4e1:	mov    %rdi,0x8(%r11)
 100a4e5:	lea    (%rdi,%rcx,1),%r11
 100a4e9:	cmp    %r11,%rbx
 100a4ec:	jae    100a4f9 <check_program+0x8e9>
 100a4ee:	movq   $0x0,0x20(%rsp)
 100a4f7:	jmp    100a542 <check_program+0x932>
 100a4f9:	mov    0x328(%rsp),%r15
 100a501:	movq   $0x0,0x20(%rsp)
 100a50a:	mov    0x10(%r15),%r15
 100a50e:	sub    %r14,%r15
 100a511:	jb     100a542 <check_program+0x932>
 100a513:	cmp    %r15,%r8
 100a516:	ja     100a542 <check_program+0x932>
 100a518:	mov    0x328(%rsp),%r11
 100a520:	mov    %r14,%rdi
 100a523:	add    %r8,%rdi
 100a526:	mov    %rbx,0x20(%rsp)
 100a52b:	lea    0x3(%rcx,%rdi,1),%rbx
 100a530:	and    $0xfffffffffffffffc,%rbx
 100a534:	mov    %rbx,%r14
 100a537:	sub    %rcx,%r14
 100a53a:	mov    %rdi,0x8(%r11)
 100a53e:	lea    (%rdi,%rcx,1),%r11
 100a542:	cmp    %r11,%rbx
 100a545:	jae    100a552 <check_program+0x942>
 100a547:	movq   $0x0,0x18(%rsp)
 100a550:	jmp    100a5af <check_program+0x99f>
 100a552:	mov    0x328(%rsp),%r15
 100a55a:	movq   $0x0,0x18(%rsp)
 100a563:	mov    0x10(%r15),%r15
 100a567:	sub    %r14,%r15
 100a56a:	jb     100a5af <check_program+0x99f>
 100a56c:	mov    0x320(%rbp),%r12d
 100a573:	lea    0x4(,%r12,4),%r12
 100a57b:	cmp    %r15,%r12
 100a57e:	ja     100a5aa <check_program+0x99a>
 100a580:	mov    0x328(%rsp),%r11
 100a588:	mov    %r14,%rdi
 100a58b:	add    %r12,%rdi
 100a58e:	mov    %rbx,0x18(%rsp)
 100a593:	lea    0x3(%rcx,%rdi,1),%rbx
 100a598:	and    $0xfffffffffffffffc,%rbx
 100a59c:	mov    %rbx,%r14
 100a59f:	sub    %rcx,%r14
 100a5a2:	mov    %rdi,0x8(%r11)
 100a5a6:	lea    (%rdi,%rcx,1),%r11
 100a5aa:	mov    0x8(%rsp),%r12
 100a5af:	mov    %r9d,%r9d
 100a5b2:	cmp    %r11,%rbx
 100a5b5:	jae    100a5c5 <check_program+0x9b5>
 100a5b7:	movq   $0x0,0xd0(%rsp)
 100a5c3:	jmp    100a621 <check_program+0xa11>
 100a5c5:	mov    0x328(%rsp),%r15
 100a5cd:	movq   $0x0,0xd0(%rsp)
 100a5d9:	mov    0x10(%r15),%r15
 100a5dd:	sub    %r14,%r15
 100a5e0:	jb     100a621 <check_program+0xa11>
 100a5e2:	lea    0x0(,%r9,4),%r12
 100a5ea:	cmp    %r15,%r12
 100a5ed:	ja     100a61c <check_program+0xa0c>
 100a5ef:	mov    0x328(%rsp),%r11
 100a5f7:	mov    %r14,%rdi
 100a5fa:	add    %r12,%rdi
 100a5fd:	mov    %rbx,0xd0(%rsp)
 100a605:	lea    0x3(%rcx,%rdi,1),%rbx
 100a60a:	and    $0xfffffffffffffffc,%rbx
 100a60e:	mov    %rbx,%r14
 100a611:	sub    %rcx,%r14
 100a614:	mov    %rdi,0x8(%r11)
 100a618:	lea    (%rdi,%rcx,1),%r11
 100a61c:	mov    0x8(%rsp),%r12
 100a621:	mov    %rax,0x58(%rsp)
 100a626:	cmp    %r11,%rbx
 100a629:	jae    100a62f <check_program+0xa1f>
 100a62b:	xor    %eax,%eax
 100a62d:	jmp    100a66f <check_program+0xa5f>
 100a62f:	mov    0x328(%rsp),%r15
 100a637:	xor    %eax,%eax
 100a639:	mov    0x10(%r15),%r15
 100a63d:	sub    %r14,%r15
 100a640:	jb     100a66f <check_program+0xa5f>
 100a642:	cmp    %r15,%r10
 100a645:	ja     100a66f <check_program+0xa5f>
 100a647:	mov    0x328(%rsp),%r11
 100a64f:	mov    %r14,%rdi
 100a652:	add    %r10,%rdi
 100a655:	mov    %rbx,%rax
 100a658:	lea    0x3(%rcx,%rdi,1),%rbx
 100a65d:	and    $0xfffffffffffffffc,%rbx
 100a661:	mov    %rbx,%r14
 100a664:	sub    %rcx,%r14
 100a667:	mov    %rdi,0x8(%r11)
 100a66b:	lea    (%rdi,%rcx,1),%r11
 100a66f:	mov    %r13,0xd8(%rsp)
 100a677:	mov    %rsi,0xb0(%rsp)
 100a67f:	mov    %rdx,0xa0(%rsp)
 100a687:	cmp    %r11,%rbx
 100a68a:	jae    100a691 <check_program+0xa81>
 100a68c:	xor    %r13d,%r13d
 100a68f:	jmp    100a6d2 <check_program+0xac2>
 100a691:	mov    0x328(%rsp),%r15
 100a699:	xor    %r13d,%r13d
 100a69c:	mov    0x10(%r15),%r15
 100a6a0:	sub    %r14,%r15
 100a6a3:	jb     100a6d2 <check_program+0xac2>
 100a6a5:	cmp    %r15,%r10
 100a6a8:	ja     100a6d2 <check_program+0xac2>
 100a6aa:	mov    %r14,%rdi
 100a6ad:	add    %r10,%rdi
 100a6b0:	mov    0x328(%rsp),%rdx
 100a6b8:	mov    %rbx,%r13
 100a6bb:	lea    0x3(%rcx,%rdi,1),%rbx
 100a6c0:	lea    (%rdi,%rcx,1),%r11
 100a6c4:	and    $0xfffffffffffffffc,%rbx
 100a6c8:	mov    %rbx,%r14
 100a6cb:	sub    %rcx,%r14
 100a6ce:	mov    %rdi,0x8(%rdx)
 100a6d2:	cmp    %r11,%rbx
 100a6d5:	jae    100a6db <check_program+0xacb>
 100a6d7:	xor    %edx,%edx
 100a6d9:	jmp    100a70c <check_program+0xafc>
 100a6db:	mov    0x328(%rsp),%r10
 100a6e3:	xor    %edx,%edx
 100a6e5:	mov    0x10(%r10),%r10
 100a6e9:	sub    %r14,%r10
 100a6ec:	jb     100a70c <check_program+0xafc>
 100a6ee:	cmp    %r10,%r8
 100a6f1:	ja     100a70c <check_program+0xafc>
 100a6f3:	mov    0x328(%rsp),%rdi
 100a6fb:	add    %r8,%r14
 100a6fe:	mov    %rbx,%rdx
 100a701:	lea    (%r14,%rcx,1),%r11
 100a705:	mov    %r14,0x8(%rdi)
 100a709:	mov    %r14,%rdi
 100a70c:	mov    0x328(%rsp),%r8
 100a714:	lea    0x7(%r11),%r10
 100a718:	and    $0xfffffffffffffff8,%r10
 100a71c:	mov    0x10(%r8),%r8
 100a720:	cmp    %r11,%r10
 100a723:	jae    100a742 <check_program+0xb32>
 100a725:	movq   $0x0,0x88(%rsp)
 100a731:	movq   $0x0,0x168(%rsp)
 100a73d:	jmp    100a88b <check_program+0xc7b>
 100a742:	mov    0x90(%rsp),%r11
 100a74a:	mov    %r10,%rbx
 100a74d:	sub    %rcx,%rbx
 100a750:	sub    %rbx,%r8
 100a753:	lea    0x8(,%r11,8),%r11
 100a75b:	jb     100a842 <check_program+0xc32>
 100a761:	cmp    %r8,%r11
 100a764:	ja     100a842 <check_program+0xc32>
 100a76a:	mov    0x328(%rsp),%r8
 100a772:	mov    %r10,%rsi
 100a775:	add    %r11,%r10
 100a778:	mov    %rbx,%rdi
 100a77b:	add    %r11,%rdi
 100a77e:	mov    %r10,%rbx
 100a781:	sub    %rcx,%rbx
 100a784:	mov    %rdi,0x8(%r8)
 100a788:	jmp    100a84c <check_program+0xc3c>
 100a78d:	mov    0x328(%rsp),%r14
 100a795:	mov    %r11,%rbx
 100a798:	sub    %rcx,%rbx
 100a79b:	movq   $0x0,0x48(%rsp)
 100a7a4:	mov    0x10(%r14),%r14
 100a7a8:	sub    %rbx,%r14
 100a7ab:	jb     1009e6e <check_program+0x25e>
 100a7b1:	mov    0x10(%rsp),%r15
 100a7b6:	mov    0x18(%r15),%r15d
 100a7ba:	lea    0x4(,%r15,4),%r15
 100a7c2:	cmp    %r14,%r15
 100a7c5:	ja     1009e6e <check_program+0x25e>
 100a7cb:	mov    0x328(%rsp),%rdi
 100a7d3:	add    %r15,%rbx
 100a7d6:	mov    %r11,0x48(%rsp)
 100a7db:	mov    %rbx,0x8(%rdi)
 100a7df:	mov    %rbx,%rdi
 100a7e2:	jmp    1009e6e <check_program+0x25e>
 100a7e7:	mov    0x328(%rsp),%r11
 100a7ef:	mov    0x10(%r11),%r11
 100a7f3:	xor    %edx,%edx
 100a7f5:	mov    %rax,0xa8(%rsp)
 100a7fd:	sub    %r10,%r11
 100a800:	jb     100d15f <check_program+0x354f>
 100a806:	cmp    %r11,%r8
 100a809:	ja     100d15f <check_program+0x354f>
 100a80f:	mov    0x328(%rsp),%rdi
 100a817:	add    %r8,%r10
 100a81a:	lea    0x3(%rcx,%r10,1),%r15
 100a81f:	lea    (%r10,%rcx,1),%rax
 100a823:	and    $0xfffffffffffffffc,%r15
 100a827:	mov    %r10,0x8(%rdi)
 100a82b:	cmp    %rax,%r15
 100a82e:	jae    100d89d <check_program+0x3c8d>
 100a834:	xor    %r14d,%r14d
 100a837:	xor    %r15d,%r15d
 100a83a:	mov    %r10,%rdi
 100a83d:	jmp    1009e0c <check_program+0x1fc>
 100a842:	mov    0x328(%rsp),%r8
 100a84a:	xor    %esi,%esi
 100a84c:	mov    0x10(%r8),%r8
 100a850:	movq   $0x0,0x168(%rsp)
 100a85c:	mov    %rsi,0x88(%rsp)
 100a864:	mov    %r8,%r14
 100a867:	sub    %rbx,%r14
 100a86a:	jb     100a88b <check_program+0xc7b>
 100a86c:	cmp    %r14,%r11
 100a86f:	ja     100a88b <check_program+0xc7b>
 100a871:	mov    0x328(%rsp),%rdi
 100a879:	add    %r11,%rbx
 100a87c:	mov    %r10,0x168(%rsp)
 100a884:	mov    %rbx,0x8(%rdi)
 100a888:	mov    %rbx,%rdi
 100a88b:	mov    0x70(%rsp),%r14
 100a890:	mov    %r8,%r10
 100a893:	sub    %rdi,%r10
 100a896:	setb   %r11b
 100a89a:	cmp    %r14,%r10
 100a89d:	setbe  %bl
 100a8a0:	or     %r11b,%bl
 100a8a3:	je     100a8b7 <check_program+0xca7>
 100a8a5:	xor    %ebx,%ebx
 100a8a7:	movq   $0x0,0x68(%rsp)
 100a8b0:	cmp    %r8,%rdi
 100a8b3:	jbe    100a8e5 <check_program+0xcd5>
 100a8b5:	jmp    100a906 <check_program+0xcf6>
 100a8b7:	mov    0x328(%rsp),%rsi
 100a8bf:	lea    0x1(%r14,%rdi,1),%r11
 100a8c4:	mov    %r8,%r10
 100a8c7:	add    %rcx,%rdi
 100a8ca:	mov    %rdi,%rbx
 100a8cd:	sub    %r11,%r10
 100a8d0:	mov    %r11,%rdi
 100a8d3:	mov    %r11,0x8(%rsi)
 100a8d7:	movq   $0x0,0x68(%rsp)
 100a8e0:	cmp    %r8,%rdi
 100a8e3:	ja     100a906 <check_program+0xcf6>
 100a8e5:	cmp    %r14,%r10
 100a8e8:	jbe    100a906 <check_program+0xcf6>
 100a8ea:	mov    0x328(%rsp),%r10
 100a8f2:	mov    %rdi,%rsi
 100a8f5:	lea    0x1(%r14,%rdi,1),%rdi
 100a8fa:	add    %rcx,%rsi
 100a8fd:	mov    %rsi,0x68(%rsp)
 100a902:	mov    %rdi,0x8(%r10)
 100a906:	lea    0x3(%rdi,%rcx,1),%rsi
 100a90b:	add    %rcx,%rdi
 100a90e:	mov    %rbx,0x60(%rsp)
 100a913:	and    $0xfffffffffffffffc,%rsi
 100a917:	cmp    %rdi,%rsi
 100a91a:	jae    100a936 <check_program+0xd26>
 100a91c:	movq   $0x0,0x110(%rsp)
 100a928:	movq   $0x0,0x158(%rsp)
 100a934:	jmp    100a99b <check_program+0xd8b>
 100a936:	mov    %rsi,%rdi
 100a939:	sub    %rcx,%rdi
 100a93c:	xor    %r14d,%r14d
 100a93f:	mov    %r8,%r11
 100a942:	sub    %rdi,%r11
 100a945:	jb     100a96e <check_program+0xd5e>
 100a947:	mov    %r9,%r10
 100a94a:	shl    $0x4,%r10
 100a94e:	cmp    %r11,%r10
 100a951:	ja     100a96e <check_program+0xd5e>
 100a953:	mov    0x328(%rsp),%r11
 100a95b:	mov    %rsi,%r14
 100a95e:	add    %r10,%rdi
 100a961:	add    %r10,%rsi
 100a964:	mov    %rdi,0x8(%r11)
 100a968:	mov    %rsi,%rdi
 100a96b:	sub    %rcx,%rdi
 100a96e:	sub    %rdi,%r8
 100a971:	mov    %r14,0x110(%rsp)
 100a979:	jb     100a928 <check_program+0xd18>
 100a97b:	shl    $0x5,%r9
 100a97f:	cmp    %r8,%r9
 100a982:	ja     100a928 <check_program+0xd18>
 100a984:	mov    0x328(%rsp),%rcx
 100a98c:	add    %r9,%rdi
 100a98f:	mov    %rsi,0x158(%rsp)
 100a997:	mov    %rdi,0x8(%rcx)
 100a99b:	mov    0xa8(%rsp),%rcx
 100a9a3:	mov    0xa0(%rsp),%rsi
 100a9ab:	mov    0xb0(%rsp),%rdi
 100a9b3:	mov    0x58(%rsp),%r9
 100a9b8:	mov    0xd8(%rsp),%r10
 100a9c0:	mov    0x28(%rsp),%r11
 100a9c5:	mov    0xf0(%rsp),%r14
 100a9cd:	mov    0x98(%rsp),%r8
 100a9d5:	mov    0xd0(%rsp),%r15
 100a9dd:	mov    0x68(%rsp),%rbx
 100a9e2:	test   %rcx,%rcx
 100a9e5:	mov    %rcx,0xa8(%rsp)
 100a9ed:	mov    %rsi,0xa0(%rsp)
 100a9f5:	mov    %rdi,0xb0(%rsp)
 100a9fd:	mov    %rdx,0xb8(%rsp)
 100aa05:	vpslldq $0xc,%xmm0,%xmm0
 100aa0a:	mov    %r8,0x98(%rsp)
 100aa12:	mov    %r9,0x58(%rsp)
 100aa17:	mov    %r10,0xd8(%rsp)
 100aa1f:	mov    %r14,0xf0(%rsp)
 100aa27:	mov    %r11,0x28(%rsp)
 100aa2c:	mov    %r15,0xd0(%rsp)
 100aa34:	mov    %rax,0x70(%rsp)
 100aa39:	mov    %rbp,0x30(%rsp)
 100aa3e:	mov    %rbx,0x68(%rsp)
 100aa43:	setne  %cl
 100aa46:	test   %rsi,%rsi
 100aa49:	setne  %sil
 100aa4d:	and    %cl,%sil
 100aa50:	test   %rdi,%rdi
 100aa53:	setne  %cl
 100aa56:	test   %r9,%r9
 100aa59:	setne  %dil
 100aa5d:	and    %cl,%dil
 100aa60:	and    %sil,%dil
 100aa63:	test   %r10,%r10
 100aa66:	setne  %cl
 100aa69:	test   %r14,%r14
 100aa6c:	setne  %sil
 100aa70:	and    %cl,%sil
 100aa73:	test   %r11,%r11
 100aa76:	setne  %cl
 100aa79:	and    %sil,%cl
 100aa7c:	and    %dil,%cl
 100aa7f:	test   %r15,%r15
 100aa82:	setne  %sil
 100aa86:	test   %rax,%rax
 100aa89:	setne  %dil
 100aa8d:	and    %sil,%dil
 100aa90:	test   %r13,%r13
 100aa93:	setne  %sil
 100aa97:	and    %dil,%sil
 100aa9a:	test   %rdx,%rdx
 100aa9d:	mov    0x88(%rsp),%rdx
 100aaa5:	setne  %dil
 100aaa9:	and    %sil,%dil
 100aaac:	and    %cl,%dil
 100aaaf:	cmpq   $0x0,0x60(%rsp)
 100aab5:	setne  %cl
 100aab8:	test   %rbx,%rbx
 100aabb:	setne  %sil
 100aabf:	and    %cl,%sil
 100aac2:	cmpq   $0x0,0x110(%rsp)
 100aacb:	setne  %cl
 100aace:	and    %sil,%cl
 100aad1:	cmpq   $0x0,0x158(%rsp)
 100aada:	setne  %sil
 100aade:	and    %cl,%sil
 100aae1:	test   %r8,%r8
 100aae4:	setne  %cl
 100aae7:	and    %sil,%cl
 100aaea:	and    %dil,%cl
 100aaed:	and    0x80(%rsp),%cl
 100aaf4:	mov    %r13,0x80(%rsp)
 100aafc:	cmp    $0x1,%cl
 100aaff:	jne    100ac47 <check_program+0x1037>
 100ab05:	cmpq   $0x0,0x10(%rsp)
 100ab0b:	setne  %al
 100ab0e:	cmpq   $0x0,0x48(%rsp)
 100ab14:	sete   %cl
 100ab17:	test   %cl,%al
 100ab19:	jne    100ac47 <check_program+0x1037>
 100ab1f:	cmpq   $0x0,0x108(%rsp)
 100ab28:	je     100ac47 <check_program+0x1037>
 100ab2e:	cmpq   $0x0,0x128(%rsp)
 100ab37:	je     100ac47 <check_program+0x1037>
 100ab3d:	cmpq   $0x0,0x100(%rsp)
 100ab46:	je     100ac47 <check_program+0x1037>
 100ab4c:	cmpq   $0x0,0x160(%rsp)
 100ab55:	je     100ac47 <check_program+0x1037>
 100ab5b:	test   %rdx,%rdx
 100ab5e:	je     100ac47 <check_program+0x1037>
 100ab64:	cmpq   $0x0,0x168(%rsp)
 100ab6d:	je     100ac47 <check_program+0x1037>
 100ab73:	cmpq   $0x0,0x148(%rsp)
 100ab7c:	je     100ac47 <check_program+0x1037>
 100ab82:	cmpq   $0x0,0x140(%rsp)
 100ab8b:	je     100ac47 <check_program+0x1037>
 100ab91:	cmpq   $0x0,0x20(%rsp)
 100ab97:	je     100ac47 <check_program+0x1037>
 100ab9d:	cmpq   $0x0,0x18(%rsp)
 100aba3:	je     100ac47 <check_program+0x1037>
 100aba9:	cmpq   $0x0,0x130(%rsp)
 100abb2:	je     100ac47 <check_program+0x1037>
 100abb8:	cmpq   $0x0,0x150(%rsp)
 100abc1:	je     100ac47 <check_program+0x1037>
 100abc7:	cmpq   $0x0,0x138(%rsp)
 100abd0:	je     100ac47 <check_program+0x1037>
 100abd2:	cmpq   $0x0,0xf8(%rsp)
 100abdb:	je     100ac47 <check_program+0x1037>
 100abdd:	cmpq   $0x0,0x120(%rsp)
 100abe6:	je     100ac47 <check_program+0x1037>
 100abe8:	cmpq   $0x0,0xe8(%rsp)
 100abf1:	je     100ac47 <check_program+0x1037>
 100abf3:	cmpq   $0x0,0xc8(%rsp)
 100abfc:	je     100ac47 <check_program+0x1037>
 100abfe:	mov    (%r12),%rbx
 100ac02:	mov    0x50(%rsp),%r15
 100ac07:	xor    %eax,%eax
 100ac09:	vmovapd %xmm0,0x190(%rsp)
 100ac12:	mov    0x35c(%rbx),%r9d
 100ac19:	mov    %r9,0x10(%rsp)
 100ac1e:	test   %r9,%r9
 100ac21:	je     100d4c2 <check_program+0x38b2>
 100ac27:	mov    0x40(%rsp),%rcx
 100ac2c:	mov    %r9d,%edx
 100ac2f:	and    $0x7,%edx
 100ac32:	mov    0x50(%rcx),%rcx
 100ac36:	cmp    $0x8,%r9d
 100ac3a:	jae    100d4d2 <check_program+0x38c2>
 100ac40:	xor    %esi,%esi
 100ac42:	jmp    100d879 <check_program+0x3c69>
 100ac47:	cmpl   $0x0,0xbc(%r12)
 100ac50:	mov    0x50(%rsp),%r15
 100ac55:	jne    100ac63 <check_program+0x1053>
 100ac57:	movl   $0x3,0xbc(%r12)
 100ac63:	movq   $0x0,0x40(%r12)
 100ac6c:	movq   $0x0,0x50(%r12)
 100ac75:	mov    0x28(%rsp),%rbx
 100ac7a:	mov    0x320(%rbp),%eax
 100ac80:	mov    %eax,0x9c(%r12)
 100ac88:	movq   $0x0,0x78(%r12)
 100ac91:	movq   $0x0,0x88(%r12)
 100ac9d:	movq   $0x0,0x68(%r12)
 100aca6:	mov    0xd0(%rsp),%rdx
 100acae:	movl   $0x0,0xa8(%r12)
 100acba:	movq   $0x0,0x70(%r12)
 100acc3:	cmpl   $0x0,0xbc(%r12)
 100accc:	jne    100acda <check_program+0x10ca>
 100acce:	movl   $0x3,0xbc(%r12)
 100acda:	xor    %ecx,%ecx
 100acdc:	mov    0x40(%rsp),%rax
 100ace1:	mov    0xa8(%rsp),%rdi
 100ace9:	mov    0xa0(%rsp),%rsi
 100acf1:	mov    %r12,0x1a8(%rsp)
 100acf9:	test   %r15d,%r15d
 100acfc:	mov    %rax,0x1b0(%rsp)
 100ad04:	mov    %rdi,0x1b8(%rsp)
 100ad0c:	mov    %rsi,0x1c0(%rsp)
 100ad14:	mov    0xb0(%rsp),%rdi
 100ad1c:	mov    0x58(%rsp),%rsi
 100ad21:	mov    %ecx,0xb0(%rsp)
 100ad28:	mov    %rdi,0x1c8(%rsp)
 100ad30:	mov    %rsi,0x1d0(%rsp)
 100ad38:	mov    0xd8(%rsp),%rdi
 100ad40:	mov    0xf0(%rsp),%rsi
 100ad48:	mov    %rdi,0x1d8(%rsp)
 100ad50:	mov    %rsi,0x1e0(%rsp)
 100ad58:	mov    0x48(%rsp),%rsi
 100ad5d:	mov    0x98(%rsp),%rdi
 100ad65:	mov    %rbx,0x1e8(%rsp)
 100ad6d:	movl   $0x0,0x48(%rsp)
 100ad75:	mov    %rdi,0x1f0(%rsp)
 100ad7d:	mov    %rsi,0x1f8(%rsp)
 100ad85:	mov    0x130(%rsp),%rdi
 100ad8d:	mov    0x150(%rsp),%rsi
 100ad95:	mov    %rdi,0x200(%rsp)
 100ad9d:	mov    %rsi,0x208(%rsp)
 100ada5:	mov    0xf8(%rsp),%rdi
 100adad:	mov    0x120(%rsp),%rsi
 100adb5:	mov    %rdi,0x210(%rsp)
 100adbd:	mov    %rsi,0x218(%rsp)
 100adc5:	mov    0xe8(%rsp),%rdi
 100adcd:	mov    0xc8(%rsp),%rsi
 100add5:	mov    %rdi,0x220(%rsp)
 100addd:	mov    %rsi,0x228(%rsp)
 100ade5:	mov    0x138(%rsp),%rdi
 100aded:	mov    0x108(%rsp),%rsi
 100adf5:	mov    %rdi,0x230(%rsp)
 100adfd:	mov    %rsi,0x238(%rsp)
 100ae05:	mov    0x128(%rsp),%rdi
 100ae0d:	mov    0x100(%rsp),%rsi
 100ae15:	mov    %rdi,0x240(%rsp)
 100ae1d:	mov    %rsi,0x248(%rsp)
 100ae25:	mov    0x160(%rsp),%rdi
 100ae2d:	mov    0x148(%rsp),%rsi
 100ae35:	mov    %rdi,0x250(%rsp)
 100ae3d:	mov    %rsi,0x258(%rsp)
 100ae45:	mov    0x140(%rsp),%rdi
 100ae4d:	mov    0x20(%rsp),%rsi
 100ae52:	mov    %rdi,0x260(%rsp)
 100ae5a:	mov    %rsi,0x268(%rsp)
 100ae62:	mov    0x18(%rsp),%rdi
 100ae67:	mov    0x68(%rsp),%rsi
 100ae6c:	mov    %rdi,0x270(%rsp)
 100ae74:	mov    %rsi,0x278(%rsp)
 100ae7c:	mov    0x110(%rsp),%rdi
 100ae84:	mov    0x158(%rsp),%rsi
 100ae8c:	mov    %rdi,0x280(%rsp)
 100ae94:	mov    %rsi,0x288(%rsp)
 100ae9c:	mov    %rdx,0x290(%rsp)
 100aea4:	sete   %dl
 100aea7:	xor    $0x1,%cl
 100aeaa:	vmovupd %xmm0,0x298(%rsp)
 100aeb3:	vxorpd %xmm0,%xmm0,%xmm0
 100aeb7:	vmovupd %xmm0,0x2a8(%rsp)
 100aec0:	or     %dl,%cl
 100aec2:	jne    100d10d <check_program+0x34fd>
 100aec8:	mov    %r15d,%r14d
 100aecb:	xor    %ebx,%ebx
 100aecd:	movl   $0x0,0x48(%rsp)
 100aed5:	mov    %r14,0xa0(%rsp)
 100aedd:	jmp    100aefc <check_program+0x12ec>
 100aedf:	mov    0x58(%rsp),%rbx
 100aee4:	xor    %ecx,%ecx
 100aee6:	add    0x48(%rsp),%ecx
 100aeea:	mov    %ecx,0x48(%rsp)
 100aeee:	xchg   %ax,%ax
 100aef0:	inc    %rbx
 100aef3:	cmp    %r14,%rbx
 100aef6:	jae    100d10d <check_program+0x34fd>
 100aefc:	cmpl   $0x0,0xbc(%r12)
 100af05:	jne    100d10d <check_program+0x34fd>
 100af0b:	mov    0x2d8(%rbp),%rax
 100af12:	mov    (%rax,%rbx,4),%ecx
 100af15:	mov    $0xffffffff,%eax
 100af1a:	cmp    %rax,%rcx
 100af1d:	je     100aef0 <check_program+0x12e0>
 100af1f:	mov    0x1f0(%rbp),%rax
 100af26:	test   %rax,%rax
 100af29:	je     100af31 <check_program+0x1321>
 100af2b:	cmpb   $0x0,(%rax,%rbx,1)
 100af2f:	jne    100aef0 <check_program+0x12e0>
 100af31:	mov    %rcx,0x98(%rsp)
 100af39:	mov    0x1a8(%rsp),%rax
 100af41:	mov    0x1b0(%rsp),%rcx
 100af49:	mov    0x298(%rsp),%edx
 100af50:	lea    0x0(,%rbx,4),%rdi
 100af58:	mov    $0xff,%esi
 100af5d:	mov    (%rax),%r15
 100af60:	mov    0x60(%rcx),%rax
 100af64:	mov    %rdx,0x68(%rsp)
 100af69:	mov    (%rax,%rbx,4),%r14d
 100af6d:	movq   $0x0,0x29c(%rsp)
 100af79:	mov    %edx,0x2a8(%rsp)
 100af80:	mov    %ebx,0x2ac(%rsp)
 100af87:	mov    %r14d,0x2b0(%rsp)
 100af8f:	mov    %r14,%rax
 100af92:	sub    %rbx,%rax
 100af95:	add    0x250(%rsp),%rdi
 100af9d:	lea    0x4(,%rax,4),%rdx
 100afa5:	vzeroupper
 100afa8:	call   788120 <memset@plt>
 100afad:	lea    0x1(%rbx),%rax
 100afb1:	mov    %rax,0xa8(%rsp)
 100afb9:	cmp    %r14,%rax
 100afbc:	jae    100b082 <check_program+0x1472>
 100afc2:	mov    %ebx,%ecx
 100afc4:	lea    0x1(%rbx),%rdx
 100afc8:	sub    %r14d,%ecx
 100afcb:	mov    %rdx,%rax
 100afce:	test   $0x1,%cl
 100afd1:	jne    100b074 <check_program+0x1464>
 100afd7:	mov    0x1b0(%rsp),%rax
 100afdf:	mov    0x50(%rax),%rax
 100afe3:	movzbl (%rax,%rdx,1),%ecx
 100afe7:	cmp    $0x53,%ecx
 100afea:	je     100aff1 <check_program+0x13e1>
 100afec:	cmp    $0x21,%ecx
 100afef:	jne    100b070 <check_program+0x1460>
 100aff1:	mov    0x2a0(%rsp),%eax
 100aff8:	cmp    0x2a4(%rsp),%eax
 100afff:	jae    100b019 <check_program+0x1409>
 100b001:	mov    0x290(%rsp),%rdx
 100b009:	movl   $0xffffffff,(%rdx,%rax,4)
 100b010:	incl   0x2a0(%rsp)
 100b017:	jmp    100b03f <check_program+0x142f>
 100b019:	mov    0x1a8(%rsp),%rdx
 100b021:	cmpl   $0x0,0xbc(%rdx)
 100b028:	jne    100b03f <check_program+0x142f>
 100b02a:	movl   $0x3,0xbc(%rdx)
 100b034:	movq   $0x0,0xb4(%rdx)
 100b03f:	mov    0x250(%rsp),%rdx
 100b047:	mov    %eax,0x4(%rdx,%rbx,4)
 100b04b:	cmp    $0x53,%cl
 100b04e:	jne    100b070 <check_program+0x1460>
 100b050:	mov    0x248(%rsp),%rdx
 100b058:	mov    0x1a8(%rsp),%rcx
 100b060:	mov    0x4(%rdx,%rbx,4),%edx
 100b064:	mov    0x48(%rcx),%rcx
 100b068:	shl    $0x6,%rdx
 100b06c:	mov    %eax,0x2c(%rcx,%rdx,1)
 100b070:	lea    0x2(%rbx),%rax
 100b074:	mov    %r14d,%ecx
 100b077:	sub    %ebx,%ecx
 100b079:	cmp    $0x2,%ecx
 100b07c:	jne    100ccb7 <check_program+0x30a7>
 100b082:	mov    0x1c0(%rsp),%rax
 100b08a:	mov    (%rax,%r14,4),%eax
 100b08e:	jmp    100b0cf <check_program+0x14bf>
 100b090:	mov    0x288(%rsp),%rsi
 100b098:	lea    0x1(%rdx),%edi
 100b09b:	shl    $0x5,%rdx
 100b09f:	vxorpd %xmm0,%xmm0,%xmm0
 100b0a3:	mov    %edi,0x29c(%rsp)
 100b0aa:	vmovupd %xmm0,(%rsi,%rdx,1)
 100b0af:	movl   $0x0,0x10(%rsi,%rdx,1)
 100b0b7:	mov    %eax,0x14(%rsi,%rdx,1)
 100b0bb:	movq   $0xffffffffffffffff,0x18(%rsi,%rdx,1)
 100b0c4:	mov    0x1d0(%rsp),%rax
 100b0cc:	mov    (%rax,%rcx,4),%eax
 100b0cf:	cmp    $0xffffffff,%eax
 100b0d2:	je     100b120 <check_program+0x1510>
 100b0d4:	mov    %eax,%ecx
 100b0d6:	cmp    %rcx,%rbx
 100b0d9:	jae    100b0c4 <check_program+0x14b4>
 100b0db:	mov    0x29c(%rsp),%edx
 100b0e2:	cmp    0x2a4(%rsp),%edx
 100b0e9:	jb     100b090 <check_program+0x1480>
 100b0eb:	mov    0x1a8(%rsp),%rdx
 100b0f3:	cmpl   $0x0,0xbc(%rdx)
 100b0fa:	jne    100b0c4 <check_program+0x14b4>
 100b0fc:	movl   $0x3,0xbc(%rdx)
 100b106:	mov    %eax,0xb4(%rdx)
 100b10c:	mov    %eax,0xb8(%rdx)
 100b112:	jmp    100b0c4 <check_program+0x14b4>
 100b114:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b120:	mov    0x200(%rsp),%rax
 100b128:	cmpl   $0xffffffff,(%rax,%rbx,4)
 100b12c:	je     100b1a0 <check_program+0x1590>
 100b12e:	mov    0x29c(%rsp),%eax
 100b135:	cmp    0x2a4(%rsp),%eax
 100b13c:	jae    100b174 <check_program+0x1564>
 100b13e:	mov    0x288(%rsp),%rcx
 100b146:	lea    0x1(%rax),%edx
 100b149:	shl    $0x5,%rax
 100b14d:	vxorpd %xmm0,%xmm0,%xmm0
 100b151:	mov    %edx,0x29c(%rsp)
 100b158:	movl   $0x1,(%rcx,%rax,1)
 100b15f:	vmovupd %xmm0,0x4(%rcx,%rax,1)
 100b165:	mov    %ebx,0x14(%rcx,%rax,1)
 100b169:	movq   $0x0,0x18(%rcx,%rax,1)
 100b172:	jmp    100b1a0 <check_program+0x1590>
 100b174:	mov    0x1a8(%rsp),%rax
 100b17c:	cmpl   $0x0,0xbc(%rax)
 100b183:	jne    100b1a0 <check_program+0x1590>
 100b185:	movl   $0x3,0xbc(%rax)
 100b18f:	mov    %ebx,0xb4(%rax)
 100b195:	mov    %ebx,0xb8(%rax)
 100b19b:	nopl   0x0(%rax,%rax,1)
 100b1a0:	lea    0x1a8(%rsp),%rdi
 100b1a8:	call   1107890 <check_control_drain>
 100b1ad:	mov    0x29c(%rsp),%eax
 100b1b4:	cmp    0x2a4(%rsp),%eax
 100b1bb:	jae    100b1fb <check_program+0x15eb>
 100b1bd:	vmovdqa -0xa8eb45(%rip),%ymm1        # 57c680 <static_test_starved.starved+0xc60>
 100b1c5:	vmovdqa -0xa8eb2d(%rip),%ymm2        # 57c6a0 <static_test_starved.starved+0xc80>
 100b1cd:	mov    0x288(%rsp),%rcx
 100b1d5:	lea    0x1(%rax),%edx
 100b1d8:	shl    $0x5,%rax
 100b1dc:	mov    %edx,0x29c(%rsp)
 100b1e3:	vpinsrd $0x2,%r14d,%xmm1,%xmm0
 100b1e9:	vpblendd $0xf,%ymm0,%ymm1,%ymm0
 100b1ef:	vpermd %ymm0,%ymm2,%ymm0
 100b1f4:	vmovdqu %ymm0,(%rcx,%rax,1)
 100b1f9:	jmp    100b230 <check_program+0x1620>
 100b1fb:	mov    0x1a8(%rsp),%rax
 100b203:	cmpl   $0x0,0xbc(%rax)
 100b20a:	jne    100b230 <check_program+0x1620>
 100b20c:	movl   $0x3,0xbc(%rax)
 100b216:	mov    %r14d,0xb4(%rax)
 100b21d:	mov    %r14d,0xb8(%rax)
 100b224:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b230:	lea    0x1a8(%rsp),%rdi
 100b238:	vzeroupper
 100b23b:	call   1107890 <check_control_drain>
 100b240:	mov    0x298(%rsp),%ecx
 100b247:	mov    0x2a8(%rsp),%eax
 100b24e:	mov    %rbx,0x58(%rsp)
 100b253:	mov    %ecx,%edx
 100b255:	sub    %eax,%edx
 100b257:	mov    %edx,0x2b4(%rsp)
 100b25e:	mov    0x268(%rsp),%rdx
 100b266:	mov    (%rdx,%rbx,4),%edx
 100b269:	cmp    $0xffffffff,%edx
 100b26c:	je     100b60f <check_program+0x19ff>
 100b272:	mov    0x1a8(%rsp),%rcx
 100b27a:	mov    %r15,0xc0(%rsp)
 100b282:	jmp    100b2d5 <check_program+0x16c5>
 100b284:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b290:	mov    0x1a8(%rsp),%rcx
 100b298:	mov    0x80(%rsp),%r13
 100b2a0:	mov    0x58(%rsp),%rbx
 100b2a5:	cmpl   $0x0,0xbc(%rcx)
 100b2ac:	je     100b570 <check_program+0x1960>
 100b2b2:	mov    0x8(%rsp),%r12
 100b2b7:	mov    0x30(%rsp),%rbp
 100b2bc:	mov    0x20(%rsp),%rdx
 100b2c1:	mov    0x270(%rsp),%rax
 100b2c9:	mov    (%rax,%rdx,4),%edx
 100b2cc:	cmp    $0xffffffff,%edx
 100b2cf:	je     100b601 <check_program+0x19f1>
 100b2d5:	cmpl   $0x0,0xbc(%rcx)
 100b2dc:	mov    0x2a8(%rsp),%eax
 100b2e3:	jne    100b608 <check_program+0x19f8>
 100b2e9:	mov    0x298(%rsp),%r8d
 100b2f1:	mov    0x50(%rcx),%rbp
 100b2f5:	mov    %edx,%edx
 100b2f7:	lea    (%rdx,%rdx,2),%rdi
 100b2fb:	mov    %rdx,0x20(%rsp)
 100b300:	lea    (%rdx,%rdx,4),%rdx
 100b304:	mov    0x310(%r15),%rsi
 100b30b:	mov    %rdx,0x28(%rsp)
 100b310:	mov    %rdi,0x18(%rsp)
 100b315:	sub    %eax,%r8d
 100b318:	mov    %r8d,0x0(%rbp,%rdx,4)
 100b31d:	mov    0x1a8(%rsp),%rax
 100b325:	mov    0x94(%rax),%eax
 100b32b:	mov    %eax,0x8(%rbp,%rdx,4)
 100b32f:	mov    0x2c0(%r15),%rax
 100b336:	mov    0x4(%rsi,%rdi,8),%ecx
 100b33a:	mov    (%rax,%rcx,4),%r9d
 100b33e:	mov    $0xffffffff,%ecx
 100b343:	mov    %r9d,0xc(%rbp,%rdx,4)
 100b348:	mov    0x10(%rsi,%rdi,8),%eax
 100b34c:	mov    %eax,0x10(%rbp,%rdx,4)
 100b350:	mov    %eax,0x10(%rsp)
 100b354:	mov    $0xffffffff,%eax
 100b359:	mov    0x1b0(%rsp),%r11
 100b361:	mov    (%rsi,%rdi,8),%edx
 100b364:	mov    0x35c(%r15),%r10d
 100b36b:	mov    0x60(%r11),%r12
 100b36f:	mov    (%r12,%rdx,4),%r8d
 100b373:	cmp    %r14d,%r8d
 100b376:	je     100b3f6 <check_program+0x17e6>
 100b378:	cmp    %r10d,%r8d
 100b37b:	jae    100b3f6 <check_program+0x17e6>
 100b37d:	mov    0x258(%rsp),%r15
 100b385:	mov    0x260(%rsp),%rbx
 100b38d:	mov    $0x1,%r13d
 100b393:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b3a0:	mov    %r8d,%edi
 100b3a3:	cmp    %r8d,%edx
 100b3a6:	ja     100b3b3 <check_program+0x17a3>
 100b3a8:	mov    0x50(%r11),%r8
 100b3ac:	cmpb   $0x20,(%r8,%rdi,1)
 100b3b1:	jne    100b3bd <check_program+0x17ad>
 100b3b3:	cmp    $0xffffffff,%ecx
 100b3b6:	je     100b3d0 <check_program+0x17c0>
 100b3b8:	cmp    $0xffffffff,%eax
 100b3bb:	je     100b3d9 <check_program+0x17c9>
 100b3bd:	mov    (%r12,%rdi,4),%r8d
 100b3c1:	cmp    %r14d,%r8d
 100b3c4:	jne    100b3e5 <check_program+0x17d5>
 100b3c6:	jmp    100b3f6 <check_program+0x17e6>
 100b3c8:	nopl   0x0(%rax,%rax,1)
 100b3d0:	mov    (%r15,%rdi,4),%ecx
 100b3d4:	cmp    $0xffffffff,%eax
 100b3d7:	jne    100b3bd <check_program+0x17ad>
 100b3d9:	mov    (%rbx,%rdi,4),%eax
 100b3dc:	mov    (%r12,%rdi,4),%r8d
 100b3e0:	cmp    %r14d,%r8d
 100b3e3:	je     100b3f6 <check_program+0x17e6>
 100b3e5:	cmp    %r10d,%r8d
 100b3e8:	jae    100b3f6 <check_program+0x17e6>
 100b3ea:	lea    0x1(%r13),%edi
 100b3ee:	cmp    %r13d,%r10d
 100b3f1:	mov    %edi,%r13d
 100b3f4:	jne    100b3a0 <check_program+0x1790>
 100b3f6:	mov    0x18(%rsp),%rdi
 100b3fb:	mov    0xc0(%rsp),%r15
 100b403:	lea    (%rsi,%rdi,8),%r12
 100b407:	mov    0x8(%r12),%esi
 100b40c:	cmp    %r10d,%esi
 100b40f:	jae    100b290 <check_program+0x1680>
 100b415:	mov    0x8c(%r15),%edi
 100b41c:	cmp    %edi,%r9d
 100b41f:	jae    100b290 <check_program+0x1680>
 100b425:	cmp    %edi,0x10(%rsp)
 100b429:	jae    100b290 <check_program+0x1680>
 100b42f:	mov    0x1c0(%rsp),%rdx
 100b437:	mov    0x80(%rsp),%r13
 100b43f:	mov    (%rdx,%rsi,4),%esi
 100b442:	cmp    $0xffffffff,%esi
 100b445:	jne    100b514 <check_program+0x1904>
 100b44b:	lea    0x1a8(%rsp),%rdi
 100b453:	call   1107890 <check_control_drain>
 100b458:	mov    0x4(%r12),%eax
 100b45d:	mov    0x29c(%rsp),%ecx
 100b464:	cmp    0x2a4(%rsp),%ecx
 100b46b:	jae    100b58b <check_program+0x197b>
 100b471:	vmovdqa -0xa8edf9(%rip),%ymm1        # 57c680 <static_test_starved.starved+0xc60>
 100b479:	vmovdqa -0xa8ede1(%rip),%ymm2        # 57c6a0 <static_test_starved.starved+0xc80>
 100b481:	mov    0x288(%rsp),%rdx
 100b489:	lea    0x1(%rcx),%esi
 100b48c:	shl    $0x5,%rcx
 100b490:	mov    0x8(%rsp),%r12
 100b495:	mov    %esi,0x29c(%rsp)
 100b49c:	vpinsrd $0x2,%eax,%xmm1,%xmm0
 100b4a2:	vpblendd $0xf,%ymm0,%ymm1,%ymm0
 100b4a8:	vpermd %ymm0,%ymm2,%ymm0
 100b4ad:	vmovdqu %ymm0,(%rdx,%rcx,1)
 100b4b2:	mov    0x28(%rsp),%rdx
 100b4b7:	jmp    100b5c0 <check_program+0x19b0>
 100b4bc:	mov    0x288(%rsp),%r8
 100b4c4:	lea    0x1(%rdi),%r9d
 100b4c8:	shl    $0x5,%rdi
 100b4cc:	vxorpd %xmm0,%xmm0,%xmm0
 100b4d0:	mov    %r9d,0x29c(%rsp)
 100b4d8:	vmovupd %xmm0,(%r8,%rdi,1)
 100b4de:	movl   $0x0,0x10(%r8,%rdi,1)
 100b4e7:	mov    %esi,0x14(%r8,%rdi,1)
 100b4ec:	mov    %ecx,0x18(%r8,%rdi,1)
 100b4f1:	mov    %eax,0x1c(%r8,%rdi,1)
 100b4f6:	cs nopw 0x0(%rax,%rax,1)
 100b500:	mov    0x1d0(%rsp),%rsi
 100b508:	mov    (%rsi,%rdx,4),%esi
 100b50b:	cmp    $0xffffffff,%esi
 100b50e:	je     100b44b <check_program+0x183b>
 100b514:	mov    %esi,%edx
 100b516:	cmp    0x14(%r12),%esi
 100b51b:	je     100b500 <check_program+0x18f0>
 100b51d:	mov    0x1b0(%rsp),%rdi
 100b525:	mov    0x50(%rdi),%rdi
 100b529:	cmpb   $0x33,(%rdi,%rdx,1)
 100b52d:	je     100b500 <check_program+0x18f0>
 100b52f:	mov    0x29c(%rsp),%edi
 100b536:	cmp    0x2a4(%rsp),%edi
 100b53d:	jb     100b4bc <check_program+0x18ac>
 100b543:	mov    0x1a8(%rsp),%rdi
 100b54b:	cmpl   $0x0,0xbc(%rdi)
 100b552:	jne    100b500 <check_program+0x18f0>
 100b554:	movl   $0x3,0xbc(%rdi)
 100b55e:	mov    %esi,0xb4(%rdi)
 100b564:	mov    %esi,0xb8(%rdi)
 100b56a:	jmp    100b500 <check_program+0x18f0>
 100b56c:	nopl   0x0(%rax)
 100b570:	movl   $0x1,0xbc(%rcx)
 100b57a:	mov    %edx,0xb4(%rcx)
 100b580:	mov    %edx,0xb8(%rcx)
 100b586:	jmp    100b2b2 <check_program+0x16a2>
 100b58b:	mov    0x1a8(%rsp),%rcx
 100b593:	mov    0x8(%rsp),%r12
 100b598:	mov    0x28(%rsp),%rdx
 100b59d:	cmpl   $0x0,0xbc(%rcx)
 100b5a4:	jne    100b5c0 <check_program+0x19b0>
 100b5a6:	movl   $0x3,0xbc(%rcx)
 100b5b0:	mov    %eax,0xb4(%rcx)
 100b5b6:	mov    %eax,0xb8(%rcx)
 100b5bc:	nopl   0x0(%rax)
 100b5c0:	lea    0x1a8(%rsp),%rdi
 100b5c8:	lea    0x0(%rbp,%rdx,4),%rbx
 100b5cd:	vzeroupper
 100b5d0:	call   1107890 <check_control_drain>
 100b5d5:	mov    0x2a8(%rsp),%ecx
 100b5dc:	mov    0x298(%rsp),%eax
 100b5e3:	mov    0x30(%rsp),%rbp
 100b5e8:	add    (%rbx),%ecx
 100b5ea:	sub    %ecx,%eax
 100b5ec:	mov    %eax,0x4(%rbx)
 100b5ef:	mov    0x58(%rsp),%rbx
 100b5f4:	mov    0x1a8(%rsp),%rcx
 100b5fc:	jmp    100b2bc <check_program+0x16ac>
 100b601:	mov    0x2a8(%rsp),%eax
 100b608:	mov    0x298(%rsp),%ecx
 100b60f:	cmp    %ecx,%eax
 100b611:	jae    100b7c0 <check_program+0x1bb0>
 100b617:	mov    0x1a8(%rsp),%rdx
 100b61f:	cmpl   $0x0,0xbc(%rdx)
 100b626:	jne    100b7c0 <check_program+0x1bb0>
 100b62c:	lea    0xbc(%rdx),%rsi
 100b633:	mov    %eax,%eax
 100b635:	data16 cs nopw 0x0(%rax,%rax,1)
 100b640:	mov    0x280(%rsp),%rdi
 100b648:	mov    %rax,%r8
 100b64b:	shl    $0x4,%r8
 100b64f:	lea    (%rdi,%r8,1),%rcx
 100b653:	mov    0xc(%rdi,%r8,1),%edi
 100b658:	cmp    $0xd,%edi
 100b65b:	jb     100b690 <check_program+0x1a80>
 100b65d:	mov    0x8(%rcx),%edi
 100b660:	cmp    0x2a0(%rsp),%edi
 100b667:	jae    100b780 <check_program+0x1b70>
 100b66d:	mov    0x290(%rsp),%r8
 100b675:	mov    (%r8,%rdi,4),%edi
 100b679:	cmp    $0xffffffff,%edi
 100b67c:	je     100b780 <check_program+0x1b70>
 100b682:	mov    %edi,0x8(%rcx)
 100b685:	jmp    100b795 <check_program+0x1b85>
 100b68a:	nopw   0x0(%rax,%rax,1)
 100b690:	cmp    $0x3,%edi
 100b693:	jne    100b795 <check_program+0x1b85>
 100b699:	mov    0x8(%rcx),%esi
 100b69c:	mov    0x338(%r15),%rdx
 100b6a3:	lea    (%rsi,%rsi,4),%rsi
 100b6a7:	shl    $0x4,%rsi
 100b6ab:	cmpl   $0x0,0x34(%rdx,%rsi,1)
 100b6b0:	je     100b795 <check_program+0x1b85>
 100b6b6:	add    %rsi,%rdx
 100b6b9:	mov    $0x8,%esi
 100b6be:	xor    %edi,%edi
 100b6c0:	jmp    100b6f6 <check_program+0x1ae6>
 100b6c2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b6d0:	mov    0x1a8(%rsp),%r9
 100b6d8:	cmpl   $0x0,0xbc(%r9)
 100b6e0:	je     100b750 <check_program+0x1b40>
 100b6e2:	mov    0x34(%rdx),%r8d
 100b6e6:	inc    %rdi
 100b6e9:	add    $0xc,%rsi
 100b6ed:	cmp    %r8,%rdi
 100b6f0:	jae    100b795 <check_program+0x1b85>
 100b6f6:	mov    0x20(%rdx),%r8
 100b6fa:	mov    (%r8,%rsi,1),%r9d
 100b6fe:	cmp    0x35c(%r15),%r9d
 100b705:	jae    100b6d0 <check_program+0x1ac0>
 100b707:	mov    0x250(%rsp),%r10
 100b70f:	mov    (%r10,%r9,4),%r9d
 100b713:	cmp    0x2a0(%rsp),%r9d
 100b71b:	jae    100b6d0 <check_program+0x1ac0>
 100b71d:	mov    0x290(%rsp),%r10
 100b725:	mov    (%r10,%r9,4),%r9d
 100b729:	cmp    $0xffffffff,%r9d
 100b72d:	je     100b6d0 <check_program+0x1ac0>
 100b72f:	mov    0x1a8(%rsp),%r8
 100b737:	mov    0x8(%rcx),%r11d
 100b73b:	mov    0x68(%r8),%r10
 100b73f:	mov    0x70(%r8),%r8
 100b743:	mov    (%r10,%r11,4),%r10d
 100b747:	add    %edi,%r10d
 100b74a:	mov    %r9d,(%r8,%r10,4)
 100b74e:	jmp    100b6e2 <check_program+0x1ad2>
 100b750:	mov    -0x4(%r8,%rsi,1),%r8d
 100b755:	movl   $0x1,0xbc(%r9)
 100b760:	mov    %r8d,0xb4(%r9)
 100b767:	mov    %r8d,0xb8(%r9)
 100b76e:	jmp    100b6e2 <check_program+0x1ad2>
 100b773:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100b780:	mov    0x4(%rcx),%ecx
 100b783:	movl   $0x1,(%rsi)
 100b789:	mov    %ecx,0xb4(%rdx)
 100b78f:	mov    %ecx,0xb8(%rdx)
 100b795:	mov    0x298(%rsp),%ecx
 100b79c:	inc    %rax
 100b79f:	cmp    %rcx,%rax
 100b7a2:	jae    100b7c0 <check_program+0x1bb0>
 100b7a4:	mov    0x1a8(%rsp),%rdx
 100b7ac:	cmpl   $0x0,0xbc(%rdx)
 100b7b3:	lea    0xbc(%rdx),%rsi
 100b7ba:	je     100b640 <check_program+0x1a30>
 100b7c0:	mov    0xa8(%rsp),%rsi
 100b7c8:	cmp    %r14,%rsi
 100b7cb:	jae    100b869 <check_program+0x1c59>
 100b7d1:	mov    0x1a8(%rsp),%rax
 100b7d9:	jmp    100b801 <check_program+0x1bf1>
 100b7db:	nopl   0x0(%rax,%rax,1)
 100b7e0:	movl   $0x1,0xbc(%rax)
 100b7ea:	mov    %r8,%rsi
 100b7ed:	mov    %esi,0xb4(%rax)
 100b7f3:	mov    %esi,0xb8(%rax)
 100b7f9:	inc    %rsi
 100b7fc:	cmp    %esi,%r14d
 100b7ff:	je     100b862 <check_program+0x1c52>
 100b801:	cmpl   $0x0,0xbc(%rax)
 100b808:	jne    100b862 <check_program+0x1c52>
 100b80a:	mov    0x1b0(%rsp),%rcx
 100b812:	mov    0x50(%rcx),%rcx
 100b816:	cmpb   $0x53,(%rcx,%rsi,1)
 100b81a:	jne    100b7f9 <check_program+0x1be9>
 100b81c:	mov    0x248(%rsp),%rdx
 100b824:	mov    0x48(%rax),%rcx
 100b828:	mov    %rsi,%r8
 100b82b:	mov    (%rdx,%rsi,4),%edx
 100b82e:	shl    $0x6,%rdx
 100b832:	mov    0x2c(%rcx,%rdx,1),%esi
 100b836:	cmp    0x2a0(%rsp),%esi
 100b83d:	jae    100b7e0 <check_program+0x1bd0>
 100b83f:	mov    0x290(%rsp),%rdi
 100b847:	mov    (%rdi,%rsi,4),%esi
 100b84a:	cmp    $0xffffffff,%esi
 100b84d:	je     100b7e0 <check_program+0x1bd0>
 100b84f:	add    %rdx,%rcx
 100b852:	mov    %esi,0x2c(%rcx)
 100b855:	mov    %r8,%rsi
 100b858:	mov    0x1a8(%rsp),%rax
 100b860:	jmp    100b7f9 <check_program+0x1be9>
 100b862:	mov    0x298(%rsp),%ecx
 100b869:	mov    0x94(%r12),%edx
 100b871:	mov    0x40(%r12),%rax
 100b876:	mov    0x98(%rsp),%r10
 100b87e:	mov    0x68(%rsp),%r8
 100b883:	mov    0x70(%rsp),%r14
 100b888:	lea    0x1(%rdx),%esi
 100b88b:	sub    %r8d,%ecx
 100b88e:	mov    %esi,0x94(%r12)
 100b896:	lea    (%rdx,%rdx,8),%rsi
 100b89a:	mov    0x260(%rbp),%rdx
 100b8a1:	lea    (%rax,%rsi,4),%r9
 100b8a5:	mov    (%rdx,%r10,4),%edi
 100b8a9:	mov    0x2b4(%rsp),%edx
 100b8b0:	mov    %r10d,(%rax,%rsi,4)
 100b8b4:	mov    %ebx,0x4(%rax,%rsi,4)
 100b8b8:	mov    %edi,0x8(%rax,%rsi,4)
 100b8bc:	mov    0x48(%rsp),%edi
 100b8c0:	mov    %r8d,0xc(%rax,%rsi,4)
 100b8c5:	mov    %ecx,0x10(%rax,%rsi,4)
 100b8c9:	mov    %edx,0x14(%rax,%rsi,4)
 100b8cd:	lea    0x300(%rsp),%rcx
 100b8d5:	mov    %edi,0x18(%rax,%rsi,4)
 100b8d9:	movq   $0x0,0x1c(%rax,%rsi,4)
 100b8e2:	mov    0x10(%rcx),%rax
 100b8e6:	test   %rax,%rax
 100b8e9:	je     100b91c <check_program+0x1d0c>
 100b8eb:	mov    0x40(%rsp),%rcx
 100b8f0:	mov    0x10(%rax),%rsi
 100b8f4:	mov    0x18(%rcx),%rcx
 100b8f8:	mov    (%rcx,%r10,4),%ecx
 100b8fc:	cmpl   $0x4,0x4(%rsi,%rcx,8)
 100b901:	jne    100b916 <check_program+0x1d06>
 100b903:	mov    0x40(%rax),%rax
 100b907:	mov    (%rsi,%rcx,8),%ecx
 100b90a:	cmpl   $0x6e69616d,(%rax,%rcx,1)
 100b911:	sete   %al
 100b914:	jmp    100b918 <check_program+0x1d08>
 100b916:	xor    %eax,%eax
 100b918:	mov    %al,0x20(%r9)
 100b91c:	mov    0x68(%rsp),%rsi
 100b921:	mov    (%r12),%r15
 100b925:	mov    0x94(%r12),%ecx
 100b92d:	mov    %r9,0x28(%rsp)
 100b932:	movl   $0x0,0x2bc(%rsp)
 100b93d:	shl    $0x4,%rsi
 100b941:	add    0x110(%rsp),%rsi
 100b949:	sub    $0x8,%rsp
 100b94d:	mov    %r12,%rdi
 100b950:	mov    %rsi,0x70(%rsp)
 100b955:	mov    %ecx,0x28(%rsp)
 100b959:	mov    %r13,%r8
 100b95c:	mov    %r14,%r9
 100b95f:	push   $0x0
 100b961:	push   0x70(%rsp)
 100b965:	push   0xa0(%rsp)
 100b96c:	push   0xd8(%rsp)
 100b973:	lea    0x2e4(%rsp),%rax
 100b97b:	push   %rax
 100b97c:	call   110a3f0 <check_program_reference_roots>
 100b981:	add    $0x30,%rsp
 100b985:	mov    0x2bc(%rsp),%ebx
 100b98c:	mov    %rax,0x10(%rsp)
 100b991:	test   %ebx,%ebx
 100b993:	je     100cc10 <check_program+0x3000>
 100b999:	mov    0x20(%rsp),%r11d
 100b99e:	jmp    100b9b4 <check_program+0x1da4>
 100b9a0:	mov    %ebx,0x2bc(%rsp)
 100b9a7:	mov    0x70(%rsp),%r14
 100b9ac:	test   %ebx,%ebx
 100b9ae:	je     100cc10 <check_program+0x3000>
 100b9b4:	dec    %ebx
 100b9b6:	mov    %ebx,0x2bc(%rsp)
 100b9bd:	mov    (%r14,%rbx,4),%ebp
 100b9c1:	mov    (%r15),%rax
 100b9c4:	mov    (%rax,%rbp,4),%r14d
 100b9c8:	test   %r14d,%r14d
 100b9cb:	je     100ba40 <check_program+0x1e30>
 100b9cd:	lea    -0x20(%r14),%eax
 100b9d1:	cmp    $0xfffffffd,%eax
 100b9d4:	ja     100b9a7 <check_program+0x1d97>
 100b9d6:	cmp    $0x37,%r14d
 100b9da:	jne    100bb66 <check_program+0x1f56>
 100b9e0:	mov    (%r12),%rax
 100b9e4:	mov    0x8(%r15),%rdx
 100b9e8:	mov    0x318(%rax),%rcx
 100b9ef:	mov    (%rdx,%rbp,4),%eax
 100b9f2:	mov    (%rcx,%rax,4),%ecx
 100b9f5:	test   %rcx,%rcx
 100b9f8:	je     100ba08 <check_program+0x1df8>
 100b9fa:	cmp    0x9c(%r12),%ecx
 100ba02:	jbe    100bd7d <check_program+0x216d>
 100ba08:	cmpl   $0x0,0xbc(%r12)
 100ba11:	jne    100bddb <check_program+0x21cb>
 100ba17:	movl   $0x1,0xbc(%r12)
 100ba23:	mov    %eax,0xb4(%r12)
 100ba2b:	mov    %eax,0xb8(%r12)
 100ba33:	jmp    100bddb <check_program+0x21cb>
 100ba38:	nopl   0x0(%rax,%rax,1)
 100ba40:	mov    0x28(%r15),%rax
 100ba44:	lea    0x0(%rbp,%rbp,2),%rdx
 100ba49:	shl    $0x5,%rdx
 100ba4d:	mov    0x40(%rax,%rdx,1),%ecx
 100ba51:	test   %rcx,%rcx
 100ba54:	setne  %sil
 100ba58:	cmpl   $0x0,0x44(%rax,%rdx,1)
 100ba5d:	sete   %dil
 100ba61:	and    %sil,%dil
 100ba64:	cmp    $0x1,%dil
 100ba68:	jne    100bad3 <check_program+0x1ec3>
 100ba6a:	mov    0x70(%rsp),%r14
 100ba6f:	cmp    0xac(%r12),%ecx
 100ba77:	jae    100bae1 <check_program+0x1ed1>
 100ba79:	mov    0x8(%rax,%rdx,1),%eax
 100ba7d:	test   %al,%al
 100ba7f:	js     100ba95 <check_program+0x1e85>
 100ba81:	mov    (%r12),%rax
 100ba85:	lea    -0x1(%rcx),%edx
 100ba88:	mov    0x268(%rax),%rax
 100ba8f:	cmpb   $0x0,(%rax,%rdx,1)
 100ba93:	je     100bae1 <check_program+0x1ed1>
 100ba95:	mov    0xb8(%rsp),%rax
 100ba9d:	cmp    %r11d,(%rax,%rcx,4)
 100baa1:	je     100bae1 <check_program+0x1ed1>
 100baa3:	mov    %r11d,(%rax,%rcx,4)
 100baa7:	mov    0x60(%rsp),%rax
 100baac:	mov    0x10(%rsp),%rsi
 100bab1:	mov    0x88(%rsp),%rdi
 100bab9:	movb   $0x1,(%rax,%rcx,1)
 100babd:	mov    %rcx,%rax
 100bac0:	mov    %esi,%edx
 100bac2:	shl    $0x20,%rax
 100bac6:	inc    %esi
 100bac8:	mov    %rsi,0x10(%rsp)
 100bacd:	mov    %rax,(%rdi,%rdx,8)
 100bad1:	jmp    100bae1 <check_program+0x1ed1>
 100bad3:	mov    0x70(%rsp),%r14
 100bad8:	test   %rcx,%rcx
 100badb:	je     100b9ac <check_program+0x1d9c>
 100bae1:	cmp    0xac(%r12),%ecx
 100bae9:	jae    100b9ac <check_program+0x1d9c>
 100baef:	mov    (%r12),%rax
 100baf3:	dec    %ecx
 100baf5:	mov    0x280(%rax),%rdx
 100bafc:	cmpb   $0x0,(%rdx,%rcx,1)
 100bb00:	je     100b9ac <check_program+0x1d9c>
 100bb06:	mov    0x268(%rax),%rdx
 100bb0d:	cmpb   $0x0,(%rdx,%rcx,1)
 100bb11:	jne    100b9ac <check_program+0x1d9c>
 100bb17:	mov    0x28(%r12),%rdx
 100bb1c:	test   %rdx,%rdx
 100bb1f:	je     100bb36 <check_program+0x1f26>
 100bb21:	mov    0x10(%rdx),%rsi
 100bb25:	mov    (%rsi,%rcx,4),%esi
 100bb28:	test   %rsi,%rsi
 100bb2b:	je     100bb36 <check_program+0x1f26>
 100bb2d:	cmp    0x18(%rdx),%esi
 100bb30:	jbe    100c8b7 <check_program+0x2ca7>
 100bb36:	cmpl   $0x0,0xbc(%r12)
 100bb3f:	jne    100b9ac <check_program+0x1d9c>
 100bb45:	movl   $0x1,0xbc(%r12)
 100bb51:	mov    %ecx,0xb4(%r12)
 100bb59:	mov    %ecx,0xb8(%r12)
 100bb61:	jmp    100b9ac <check_program+0x1d9c>
 100bb66:	mov    0x18(%r15),%rcx
 100bb6a:	mov    0x10(%r15),%rax
 100bb6e:	mov    (%rcx,%rbp,4),%r9d
 100bb72:	mov    0x20(%r15),%rcx
 100bb76:	mov    (%rax,%rbp,4),%r13d
 100bb7a:	mov    (%rcx,%rbp,4),%r10d
 100bb7e:	cmp    $0x38,%r14d
 100bb82:	je     100bca6 <check_program+0x2096>
 100bb88:	cmp    $0x22,%r14d
 100bb8c:	jne    100bd03 <check_program+0x20f3>
 100bb92:	mov    0x8(%r12),%rcx
 100bb97:	mov    %r9d,%ebx
 100bb9a:	xor    %edx,%edx
 100bb9c:	mov    0x90(%rcx),%rax
 100bba3:	mov    0xcc(%rcx),%ecx
 100bba9:	test   %ecx,%ecx
 100bbab:	je     100bbe6 <check_program+0x1fd6>
 100bbad:	mov    %ecx,%esi
 100bbaf:	jmp    100bbc7 <check_program+0x1fb7>
 100bbb1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100bbc0:	mov    %r8d,%esi
 100bbc3:	cmp    %esi,%edx
 100bbc5:	jae    100bbe6 <check_program+0x1fd6>
 100bbc7:	mov    %esi,%edi
 100bbc9:	sub    %edx,%edi
 100bbcb:	shr    $1,%edi
 100bbcd:	lea    (%rdi,%rdx,1),%r8d
 100bbd1:	mov    %r8,%r9
 100bbd4:	shl    $0x5,%r9
 100bbd8:	cmp    %ebp,(%rax,%r9,1)
 100bbdc:	jae    100bbc0 <check_program+0x1fb0>
 100bbde:	lea    0x1(%rdi,%rdx,1),%edx
 100bbe2:	cmp    %esi,%edx
 100bbe4:	jb     100bbc7 <check_program+0x1fb7>
 100bbe6:	cmp    %ecx,%edx
 100bbe8:	jae    100c7fc <check_program+0x2bec>
 100bbee:	mov    %edx,%edx
 100bbf0:	shl    $0x5,%rdx
 100bbf4:	mov    %ebx,%r9d
 100bbf7:	cmp    %ebp,(%rax,%rdx,1)
 100bbfa:	jne    100bdf3 <check_program+0x21e3>
 100bc00:	mov    0x14(%rax,%rdx,1),%ecx
 100bc04:	test   %rcx,%rcx
 100bc07:	sete   %sil
 100bc0b:	cmpl   $0x0,0x4(%rax,%rdx,1)
 100bc10:	setne  %dil
 100bc14:	or     %sil,%dil
 100bc17:	jne    100c87a <check_program+0x2c6a>
 100bc1d:	cmp    0xac(%r12),%ecx
 100bc25:	jae    100c87a <check_program+0x2c6a>
 100bc2b:	add    %rdx,%rax
 100bc2e:	mov    0x10(%r12),%rdx
 100bc33:	mov    0x18(%rax),%esi
 100bc36:	mov    (%rdx),%rax
 100bc39:	shr    $0x3,%esi
 100bc3c:	movzbl (%rax,%rsi,1),%edi
 100bc40:	cmp    $0xf,%dil
 100bc44:	jne    100bc54 <check_program+0x2044>
 100bc46:	mov    0x20(%rdx),%rdx
 100bc4a:	mov    (%rdx,%rsi,4),%edx
 100bc4d:	shr    $0x3,%edx
 100bc50:	movzbl (%rax,%rdx,1),%edi
 100bc54:	cmp    $0xb,%dil
 100bc58:	jne    100c87a <check_program+0x2c6a>
 100bc5e:	mov    0xb8(%rsp),%rax
 100bc66:	mov    $0xffffffff,%r13d
 100bc6c:	cmp    %r11d,(%rax,%rcx,4)
 100bc70:	je     100bdf3 <check_program+0x21e3>
 100bc76:	mov    0x60(%rsp),%rdx
 100bc7b:	mov    %r11d,(%rax,%rcx,4)
 100bc7f:	mov    0x88(%rsp),%rsi
 100bc87:	movb   $0x1,(%rdx,%rcx,1)
 100bc8b:	mov    0x10(%rsp),%rdx
 100bc90:	shl    $0x20,%rcx
 100bc94:	mov    %edx,%eax
 100bc96:	inc    %edx
 100bc98:	mov    %rcx,(%rsi,%rax,8)
 100bc9c:	mov    %rdx,0x10(%rsp)
 100bca1:	jmp    100bdf3 <check_program+0x21e3>
 100bca6:	mov    0x98(%r15),%rax
 100bcad:	mov    0x8(%r12),%rcx
 100bcb2:	mov    (%rax,%rbp,4),%eax
 100bcb5:	cmp    0xac(%rcx),%eax
 100bcbb:	jae    100c880 <check_program+0x2c70>
 100bcc1:	mov    0x50(%rcx),%rcx
 100bcc5:	lea    (%rax,%rax,4),%rax
 100bcc9:	cmp    %ebp,(%rcx,%rax,4)
 100bccc:	jne    100c880 <check_program+0x2c70>
 100bcd2:	lea    (%rcx,%rax,4),%rax
 100bcd6:	mov    0x8(%rax),%eax
 100bcd9:	mov    %eax,%ecx
 100bcdb:	and    $0x1,%ecx
 100bcde:	mov    %eax,%edx
 100bce0:	cmp    $0x1,%ecx
 100bce3:	sbb    %ecx,%ecx
 100bce5:	and    $0x2,%edx
 100bce8:	or     %ecx,%r13d
 100bceb:	cmp    $0x1,%edx
 100bcee:	sbb    %edx,%edx
 100bcf0:	and    $0x4,%eax
 100bcf3:	or     %edx,%r9d
 100bcf6:	cmp    $0x1,%eax
 100bcf9:	sbb    %eax,%eax
 100bcfb:	or     %eax,%r10d
 100bcfe:	jmp    100bdf3 <check_program+0x21e3>
 100bd03:	lea    -0x15(%r14),%eax
 100bd07:	movb   $0x0,0x2bb(%rsp)
 100bd0f:	cmp    $0x2,%eax
 100bd12:	ja     100be02 <check_program+0x21f2>
 100bd18:	cmpb   $0x0,0xc8(%r12)
 100bd21:	jne    100be02 <check_program+0x21f2>
 100bd27:	lea    0x2bb(%rsp),%rcx
 100bd2f:	mov    %r12,%rdi
 100bd32:	mov    %r9d,%r12d
 100bd35:	mov    %r10d,0x18(%rsp)
 100bd3a:	mov    %ebp,%esi
 100bd3c:	mov    %r13d,%edx
 100bd3f:	call   1109f30 <check_program_runtime_truth>
 100bd44:	test   %al,%al
 100bd46:	je     100c9ea <check_program+0x2dda>
 100bd4c:	mov    0x20(%rsp),%r11d
 100bd51:	mov    0x18(%rsp),%r10d
 100bd56:	mov    %r12d,%r9d
 100bd59:	cmp    $0x17,%r14d
 100bd5d:	jne    100cbc4 <check_program+0x2fb4>
 100bd63:	cmpb   $0x0,0x2bb(%rsp)
 100bd6b:	mov    $0xffffffff,%eax
 100bd70:	cmove  %eax,%r9d
 100bd74:	cmovne %eax,%r10d
 100bd78:	jmp    100cbef <check_program+0x2fdf>
 100bd7d:	mov    0x50(%r12),%rax
 100bd82:	lea    (%rcx,%rcx,4),%rcx
 100bd86:	mov    -0x14(%rax,%rcx,4),%esi
 100bd8a:	mov    -0x10(%rax,%rcx,4),%edx
 100bd8e:	shl    $0x4,%rsi
 100bd92:	add    0x68(%rsp),%rsi
 100bd97:	sub    $0x8,%rsp
 100bd9b:	mov    0x78(%rsp),%r9
 100bda0:	mov    %r12,%rdi
 100bda3:	mov    %r11d,%ecx
 100bda6:	mov    %r13,%r8
 100bda9:	push   0x18(%rsp)
 100bdad:	push   0x70(%rsp)
 100bdb1:	push   0xa0(%rsp)
 100bdb8:	push   0xd8(%rsp)
 100bdbf:	lea    0x2e4(%rsp),%rax
 100bdc7:	push   %rax
 100bdc8:	call   110a3f0 <check_program_reference_roots>
 100bdcd:	mov    0x50(%rsp),%r11d
 100bdd2:	add    $0x30,%rsp
 100bdd6:	mov    %rax,0x10(%rsp)
 100bddb:	mov    0x18(%r15),%rcx
 100bddf:	mov    0x10(%r15),%rax
 100bde3:	mov    (%rcx,%rbp,4),%r9d
 100bde7:	mov    0x20(%r15),%rcx
 100bdeb:	mov    (%rax,%rbp,4),%r13d
 100bdef:	mov    (%rcx,%rbp,4),%r10d
 100bdf3:	mov    0x2bc(%rsp),%ebx
 100bdfa:	movb   $0x0,0x2bb(%rsp)
 100be02:	mov    %r10d,0x18(%rsp)
 100be07:	cmp    $0xffffffff,%r13d
 100be0b:	je     100bec6 <check_program+0x22b6>
 100be11:	mov    %r12,%rax
 100be14:	mov    0x8(%rax),%rax
 100be18:	mov    %r9d,%r12d
 100be1b:	mov    0xd0(%rax),%edx
 100be21:	test   %edx,%edx
 100be23:	je     100be6d <check_program+0x225d>
 100be25:	mov    0x98(%rax),%rsi
 100be2c:	xor    %ecx,%ecx
 100be2e:	mov    %edx,%edi
 100be30:	jmp    100be47 <check_program+0x2237>
 100be32:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100be40:	mov    %r9d,%edi
 100be43:	cmp    %edi,%ecx
 100be45:	jae    100be67 <check_program+0x2257>
 100be47:	mov    %edi,%r8d
 100be4a:	sub    %ecx,%r8d
 100be4d:	shr    $1,%r8d
 100be50:	lea    (%r8,%rcx,1),%r9d
 100be54:	lea    (%r9,%r9,8),%r10
 100be58:	cmp    %ebp,(%rsi,%r10,4)
 100be5c:	jae    100be40 <check_program+0x2230>
 100be5e:	lea    0x1(%r8,%rcx,1),%ecx
 100be63:	cmp    %edi,%ecx
 100be65:	jb     100be47 <check_program+0x2237>
 100be67:	cmp    %edx,%ecx
 100be69:	jb     100be73 <check_program+0x2263>
 100be6b:	jmp    100be97 <check_program+0x2287>
 100be6d:	xor    %ecx,%ecx
 100be6f:	cmp    %edx,%ecx
 100be71:	jae    100be97 <check_program+0x2287>
 100be73:	mov    0x98(%rax),%rax
 100be7a:	test   %rax,%rax
 100be7d:	je     100be97 <check_program+0x2287>
 100be7f:	mov    %ecx,%ecx
 100be81:	lea    (%rcx,%rcx,8),%rcx
 100be85:	lea    (%rax,%rcx,4),%rax
 100be89:	cmp    %ebp,(%rax)
 100be8b:	jne    100be97 <check_program+0x2287>
 100be8d:	cmpl   $0x0,0x4(%rax)
 100be91:	je     100c82c <check_program+0x2c1c>
 100be97:	mov    0x80(%rsp),%rcx
 100be9f:	mov    0x18(%rsp),%r10d
 100bea4:	mov    %r13d,%eax
 100bea7:	mov    %r12d,%r9d
 100beaa:	cmp    %r11d,(%rcx,%rax,4)
 100beae:	je     100bec1 <check_program+0x22b1>
 100beb0:	mov    0x70(%rsp),%rdx
 100beb5:	mov    %r11d,(%rcx,%rax,4)
 100beb9:	mov    %ebx,%eax
 100bebb:	inc    %ebx
 100bebd:	mov    %r13d,(%rdx,%rax,4)
 100bec1:	mov    0x8(%rsp),%r12
 100bec6:	cmp    $0xffffffff,%r9d
 100beca:	je     100bf40 <check_program+0x2330>
 100becc:	mov    %r12,%rax
 100becf:	mov    0x8(%rax),%rax
 100bed3:	mov    0x80(%rsp),%r13
 100bedb:	mov    %r9d,%r12d
 100bede:	mov    0xd0(%rax),%ecx
 100bee4:	test   %ecx,%ecx
 100bee6:	je     100bf4d <check_program+0x233d>
 100bee8:	mov    0x98(%rax),%rsi
 100beef:	xor    %edx,%edx
 100bef1:	mov    %ecx,%edi
 100bef3:	jmp    100bf0a <check_program+0x22fa>
 100bef5:	data16 cs nopw 0x0(%rax,%rax,1)
 100bf00:	inc    %r8d
 100bf03:	mov    %r8d,%edx
 100bf06:	cmp    %edi,%edx
 100bf08:	jae    100bf3a <check_program+0x232a>
 100bf0a:	mov    %edi,%r8d
 100bf0d:	sub    %edx,%r8d
 100bf10:	shr    $1,%r8d
 100bf13:	add    %edx,%r8d
 100bf16:	lea    (%r8,%r8,8),%r9
 100bf1a:	mov    (%rsi,%r9,4),%r10d
 100bf1e:	cmp    %ebp,%r10d
 100bf21:	jb     100bf00 <check_program+0x22f0>
 100bf23:	cmp    %ebp,%r10d
 100bf26:	jne    100bf33 <check_program+0x2323>
 100bf28:	lea    (%rsi,%r9,4),%r9
 100bf2c:	cmpl   $0x0,0x4(%r9)
 100bf31:	je     100bf00 <check_program+0x22f0>
 100bf33:	mov    %r8d,%edi
 100bf36:	cmp    %edi,%edx
 100bf38:	jb     100bf0a <check_program+0x22fa>
 100bf3a:	cmp    %ecx,%edx
 100bf3c:	jae    100bfb7 <check_program+0x23a7>
 100bf3e:	jmp    100bf53 <check_program+0x2343>
 100bf40:	mov    0x80(%rsp),%r13
 100bf48:	jmp    100bfdd <check_program+0x23cd>
 100bf4d:	xor    %edx,%edx
 100bf4f:	cmp    %ecx,%edx
 100bf51:	jae    100bfb7 <check_program+0x23a7>
 100bf53:	mov    0x98(%rax),%rax
 100bf5a:	test   %rax,%rax
 100bf5d:	je     100bfb7 <check_program+0x23a7>
 100bf5f:	mov    %edx,%ecx
 100bf61:	lea    (%rcx,%rcx,8),%rcx
 100bf65:	lea    (%rax,%rcx,4),%rax
 100bf69:	cmp    %ebp,(%rax)
 100bf6b:	jne    100bfb7 <check_program+0x23a7>
 100bf6d:	cmpl   $0x1,0x4(%rax)
 100bf71:	jne    100bfb7 <check_program+0x23a7>
 100bf73:	cmpl   $0x0,0x8(%rax)
 100bf77:	mov    0x18(%rsp),%r10d
 100bf7c:	mov    0x8(%rsp),%r12
 100bf81:	je     100c9fc <check_program+0x2dec>
 100bf87:	cmpl   $0x0,0xbc(%r12)
 100bf90:	jne    100bfdd <check_program+0x23cd>
 100bf92:	mov    0x8(%r15),%rax
 100bf96:	mov    (%rax,%rbp,4),%eax
 100bf99:	movl   $0x1,0xbc(%r12)
 100bfa5:	mov    %eax,0xb4(%r12)
 100bfad:	mov    %eax,0xb8(%r12)
 100bfb5:	jmp    100bfdd <check_program+0x23cd>
 100bfb7:	mov    0x18(%rsp),%r10d
 100bfbc:	mov    %r12d,%eax
 100bfbf:	cmp    %r11d,0x0(%r13,%rax,4)
 100bfc4:	je     100bfd8 <check_program+0x23c8>
 100bfc6:	mov    0x70(%rsp),%rcx
 100bfcb:	mov    %r11d,0x0(%r13,%rax,4)
 100bfd0:	mov    %ebx,%eax
 100bfd2:	inc    %ebx
 100bfd4:	mov    %r12d,(%rcx,%rax,4)
 100bfd8:	mov    0x8(%rsp),%r12
 100bfdd:	cmp    $0xffffffff,%r10d
 100bfe1:	je     100c0ce <check_program+0x24be>
 100bfe7:	mov    0x8(%r12),%rax
 100bfec:	mov    0xd0(%rax),%ecx
 100bff2:	test   %ecx,%ecx
 100bff4:	je     100c050 <check_program+0x2440>
 100bff6:	mov    0x98(%rax),%rsi
 100bffd:	xor    %edx,%edx
 100bfff:	mov    %ecx,%edi
 100c001:	jmp    100c01a <check_program+0x240a>
 100c003:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c010:	inc    %r8d
 100c013:	mov    %r8d,%edx
 100c016:	cmp    %edi,%edx
 100c018:	jae    100c04a <check_program+0x243a>
 100c01a:	mov    %edi,%r8d
 100c01d:	sub    %edx,%r8d
 100c020:	shr    $1,%r8d
 100c023:	add    %edx,%r8d
 100c026:	lea    (%r8,%r8,8),%r9
 100c02a:	mov    (%rsi,%r9,4),%r10d
 100c02e:	cmp    %ebp,%r10d
 100c031:	jb     100c010 <check_program+0x2400>
 100c033:	cmp    %ebp,%r10d
 100c036:	jne    100c043 <check_program+0x2433>
 100c038:	lea    (%rsi,%r9,4),%r9
 100c03c:	cmpl   $0x1,0x4(%r9)
 100c041:	jbe    100c010 <check_program+0x2400>
 100c043:	mov    %r8d,%edi
 100c046:	cmp    %edi,%edx
 100c048:	jb     100c01a <check_program+0x240a>
 100c04a:	cmp    %ecx,%edx
 100c04c:	jae    100c0b0 <check_program+0x24a0>
 100c04e:	jmp    100c056 <check_program+0x2446>
 100c050:	xor    %edx,%edx
 100c052:	cmp    %ecx,%edx
 100c054:	jae    100c0b0 <check_program+0x24a0>
 100c056:	mov    0x98(%rax),%rax
 100c05d:	test   %rax,%rax
 100c060:	je     100c0b0 <check_program+0x24a0>
 100c062:	mov    %edx,%ecx
 100c064:	lea    (%rcx,%rcx,8),%rcx
 100c068:	lea    (%rax,%rcx,4),%rax
 100c06c:	cmp    %ebp,(%rax)
 100c06e:	jne    100c0b0 <check_program+0x24a0>
 100c070:	cmpl   $0x2,0x4(%rax)
 100c074:	jne    100c0b0 <check_program+0x24a0>
 100c076:	cmpl   $0x0,0x8(%rax)
 100c07a:	je     100ca90 <check_program+0x2e80>
 100c080:	cmpl   $0x0,0xbc(%r12)
 100c089:	jne    100c0ce <check_program+0x24be>
 100c08b:	mov    0x8(%r15),%rax
 100c08f:	mov    (%rax,%rbp,4),%eax
 100c092:	movl   $0x1,0xbc(%r12)
 100c09e:	mov    %eax,0xb4(%r12)
 100c0a6:	mov    %eax,0xb8(%r12)
 100c0ae:	jmp    100c0ce <check_program+0x24be>
 100c0b0:	mov    0x18(%rsp),%edx
 100c0b4:	mov    %edx,%eax
 100c0b6:	cmp    %r11d,0x0(%r13,%rax,4)
 100c0bb:	je     100c0ce <check_program+0x24be>
 100c0bd:	mov    0x70(%rsp),%rcx
 100c0c2:	mov    %r11d,0x0(%r13,%rax,4)
 100c0c7:	mov    %ebx,%eax
 100c0c9:	inc    %ebx
 100c0cb:	mov    %edx,(%rcx,%rax,4)
 100c0ce:	mov    %r14d,%eax
 100c0d1:	and    $0xfffffffc,%eax
 100c0d4:	mov    %ebx,0x2bc(%rsp)
 100c0db:	cmp    $0x3c,%eax
 100c0de:	je     100c101 <check_program+0x24f1>
 100c0e0:	lea    -0x22(%r14),%eax
 100c0e4:	cmp    $0x22,%eax
 100c0e7:	ja     100b9a7 <check_program+0x1d97>
 100c0ed:	movabs $0x700000001,%rcx
 100c0f7:	bt     %rax,%rcx
 100c0fb:	jae    100b9a7 <check_program+0x1d97>
 100c101:	mov    (%r12),%rcx
 100c105:	mov    $0xffffffff,%esi
 100c10a:	mov    (%rcx),%rax
 100c10d:	mov    (%rax,%rbp,4),%edx
 100c110:	lea    -0x3c(%rdx),%edi
 100c113:	cmp    $0x8,%edi
 100c116:	ja     100c1c1 <check_program+0x25b1>
 100c11c:	lea    -0xb71cb3(%rip),%r8        # 49a470 <cbuiltin_test_generated.edges+0x630>
 100c123:	mov    0x8(%r12),%rax
 100c128:	movslq (%r8,%rdi,4),%rdi
 100c12c:	add    %r8,%rdi
 100c12f:	jmp    *%rdi
 100c131:	mov    0x58(%rax),%rdi
 100c135:	mov    0xb0(%rax),%r8d
 100c13c:	mov    $0x0,%r9d
 100c142:	movl   $0x0,0x18(%rsp)
 100c14a:	test   %r8d,%r8d
 100c14d:	je     100c18d <check_program+0x257d>
 100c14f:	xor    %r9d,%r9d
 100c152:	mov    %r8d,%r10d
 100c155:	jmp    100c168 <check_program+0x2558>
 100c157:	nopw   0x0(%rax,%rax,1)
 100c160:	mov    %eax,%r10d
 100c163:	cmp    %r10d,%r9d
 100c166:	jae    100c18d <check_program+0x257d>
 100c168:	mov    %r10d,%r11d
 100c16b:	sub    %r9d,%r11d
 100c16e:	shr    $1,%r11d
 100c171:	lea    (%r11,%r9,1),%eax
 100c175:	lea    (%rax,%rax,2),%r12
 100c179:	shl    $0x6,%r12
 100c17d:	cmp    %ebp,(%rdi,%r12,1)
 100c181:	jae    100c160 <check_program+0x2550>
 100c183:	lea    0x1(%r11,%r9,1),%r9d
 100c188:	cmp    %r10d,%r9d
 100c18b:	jb     100c168 <check_program+0x2558>
 100c18d:	cmp    %r8d,%r9d
 100c190:	jae    100c4a9 <check_program+0x2899>
 100c196:	mov    0x8(%rsp),%r12
 100c19b:	mov    0x20(%rsp),%r11d
 100c1a0:	mov    %r9d,%eax
 100c1a3:	lea    (%rax,%rax,2),%rax
 100c1a7:	shl    $0x6,%rax
 100c1ab:	cmp    %ebp,(%rdi,%rax,1)
 100c1ae:	jne    100c4b3 <check_program+0x28a3>
 100c1b4:	mov    0x74(%rdi,%rax,1),%eax
 100c1b8:	mov    %eax,0x18(%rsp)
 100c1bc:	jmp    100c4f0 <check_program+0x28e0>
 100c1c1:	movl   $0xffffffff,0x18(%rsp)
 100c1c9:	cmp    $0x22,%edx
 100c1cc:	jne    100c4b8 <check_program+0x28a8>
 100c1d2:	jmp    100c4f0 <check_program+0x28e0>
 100c1d7:	mov    0x80(%rax),%rdi
 100c1de:	mov    0xc4(%rax),%r9d
 100c1e5:	xor    %r8d,%r8d
 100c1e8:	test   %r9d,%r9d
 100c1eb:	je     100c22c <check_program+0x261c>
 100c1ed:	mov    %r9d,%eax
 100c1f0:	jmp    100c208 <check_program+0x25f8>
 100c1f2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c200:	mov    %r11d,%eax
 100c203:	cmp    %eax,%r8d
 100c206:	jae    100c22c <check_program+0x261c>
 100c208:	mov    %eax,%r10d
 100c20b:	sub    %r8d,%r10d
 100c20e:	shr    $1,%r10d
 100c211:	lea    (%r10,%r8,1),%r11d
 100c215:	imul   $0x150,%r11,%r12
 100c21c:	cmp    %ebp,(%rdi,%r12,1)
 100c220:	jae    100c200 <check_program+0x25f0>
 100c222:	lea    0x1(%r10,%r8,1),%r8d
 100c227:	cmp    %eax,%r8d
 100c22a:	jb     100c208 <check_program+0x25f8>
 100c22c:	mov    0x8(%rsp),%r12
 100c231:	mov    0x20(%rsp),%r11d
 100c236:	movl   $0xffffffff,0x18(%rsp)
 100c23e:	cmp    %r9d,%r8d
 100c241:	jae    100c4b3 <check_program+0x28a3>
 100c247:	mov    %r8d,%eax
 100c24a:	imul   $0x150,%rax,%rax
 100c251:	movl   $0xffffffff,0x18(%rsp)
 100c259:	cmp    %ebp,(%rdi,%rax,1)
 100c25c:	mov    $0xffffffff,%eax
 100c261:	cmovne %eax,%r8d
 100c265:	mov    %r8d,%esi
 100c268:	cmp    $0x22,%edx
 100c26b:	jne    100c4b8 <check_program+0x28a8>
 100c271:	jmp    100c4f0 <check_program+0x28e0>
 100c276:	mov    0x60(%rax),%rdi
 100c27a:	mov    0xb4(%rax),%r8d
 100c281:	mov    $0x0,%r9d
 100c287:	movl   $0x0,0x18(%rsp)
 100c28f:	test   %r8d,%r8d
 100c292:	je     100c2cc <check_program+0x26bc>
 100c294:	xor    %r9d,%r9d
 100c297:	mov    %r8d,%r10d
 100c29a:	jmp    100c2a8 <check_program+0x2698>
 100c29c:	nopl   0x0(%rax)
 100c2a0:	mov    %eax,%r10d
 100c2a3:	cmp    %r10d,%r9d
 100c2a6:	jae    100c2cc <check_program+0x26bc>
 100c2a8:	mov    %r10d,%r11d
 100c2ab:	sub    %r9d,%r11d
 100c2ae:	shr    $1,%r11d
 100c2b1:	lea    (%r11,%r9,1),%eax
 100c2b5:	mov    %rax,%r12
 100c2b8:	shl    $0x8,%r12
 100c2bc:	cmp    %ebp,(%rdi,%r12,1)
 100c2c0:	jae    100c2a0 <check_program+0x2690>
 100c2c2:	lea    0x1(%r11,%r9,1),%r9d
 100c2c7:	cmp    %r10d,%r9d
 100c2ca:	jb     100c2a8 <check_program+0x2698>
 100c2cc:	cmp    %r8d,%r9d
 100c2cf:	jae    100c4a9 <check_program+0x2899>
 100c2d5:	mov    0x8(%rsp),%r12
 100c2da:	mov    0x20(%rsp),%r11d
 100c2df:	mov    %r9d,%r8d
 100c2e2:	shl    $0x8,%r8
 100c2e6:	cmp    %ebp,(%rdi,%r8,1)
 100c2ea:	jne    100c4b3 <check_program+0x28a3>
 100c2f0:	mov    0xdc(%rdi,%r8,1),%eax
 100c2f8:	mov    %eax,0x18(%rsp)
 100c2fc:	jmp    100c4f0 <check_program+0x28e0>
 100c301:	mov    0x88(%rax),%rdi
 100c308:	mov    0xc8(%rax),%r8d
 100c30f:	mov    $0x0,%r9d
 100c315:	movl   $0x0,0x18(%rsp)
 100c31d:	test   %r8d,%r8d
 100c320:	je     100c35c <check_program+0x274c>
 100c322:	xor    %r9d,%r9d
 100c325:	mov    %r8d,%r10d
 100c328:	jmp    100c338 <check_program+0x2728>
 100c32a:	nopw   0x0(%rax,%rax,1)
 100c330:	mov    %eax,%r10d
 100c333:	cmp    %r10d,%r9d
 100c336:	jae    100c35c <check_program+0x274c>
 100c338:	mov    %r10d,%r11d
 100c33b:	sub    %r9d,%r11d
 100c33e:	shr    $1,%r11d
 100c341:	lea    (%r11,%r9,1),%eax
 100c345:	mov    %rax,%r12
 100c348:	shl    $0x6,%r12
 100c34c:	cmp    %ebp,(%rdi,%r12,1)
 100c350:	jae    100c330 <check_program+0x2720>
 100c352:	lea    0x1(%r11,%r9,1),%r9d
 100c357:	cmp    %r10d,%r9d
 100c35a:	jb     100c338 <check_program+0x2728>
 100c35c:	cmp    %r8d,%r9d
 100c35f:	jae    100c4a9 <check_program+0x2899>
 100c365:	mov    0x8(%rsp),%r12
 100c36a:	mov    0x20(%rsp),%r11d
 100c36f:	mov    %r9d,%r8d
 100c372:	shl    $0x6,%r8
 100c376:	cmp    %ebp,(%rdi,%r8,1)
 100c37a:	jne    100c4b3 <check_program+0x28a3>
 100c380:	mov    0x18(%rdi,%r8,1),%eax
 100c385:	mov    %eax,0x18(%rsp)
 100c389:	jmp    100c4f0 <check_program+0x28e0>
 100c38e:	mov    0x68(%rax),%rdi
 100c392:	mov    0xb8(%rax),%r8d
 100c399:	mov    $0x0,%r9d
 100c39f:	movl   $0x0,0x18(%rsp)
 100c3a7:	test   %r8d,%r8d
 100c3aa:	je     100c3ec <check_program+0x27dc>
 100c3ac:	xor    %r9d,%r9d
 100c3af:	mov    %r8d,%r10d
 100c3b2:	jmp    100c3c8 <check_program+0x27b8>
 100c3b4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c3c0:	mov    %eax,%r10d
 100c3c3:	cmp    %r10d,%r9d
 100c3c6:	jae    100c3ec <check_program+0x27dc>
 100c3c8:	mov    %r10d,%r11d
 100c3cb:	sub    %r9d,%r11d
 100c3ce:	shr    $1,%r11d
 100c3d1:	lea    (%r11,%r9,1),%eax
 100c3d5:	imul   $0xb0,%rax,%r12
 100c3dc:	cmp    %ebp,(%rdi,%r12,1)
 100c3e0:	jae    100c3c0 <check_program+0x27b0>
 100c3e2:	lea    0x1(%r11,%r9,1),%r9d
 100c3e7:	cmp    %r10d,%r9d
 100c3ea:	jb     100c3c8 <check_program+0x27b8>
 100c3ec:	cmp    %r8d,%r9d
 100c3ef:	jae    100c4a9 <check_program+0x2899>
 100c3f5:	mov    0x8(%rsp),%r12
 100c3fa:	mov    0x20(%rsp),%r11d
 100c3ff:	mov    %r9d,%eax
 100c402:	imul   $0xb0,%rax,%rax
 100c409:	cmp    %ebp,(%rdi,%rax,1)
 100c40c:	jne    100c4b3 <check_program+0x28a3>
 100c412:	mov    0x70(%rdi,%rax,1),%eax
 100c416:	mov    %eax,0x18(%rsp)
 100c41a:	jmp    100c4f0 <check_program+0x28e0>
 100c41f:	mov    0x70(%rax),%rdi
 100c423:	mov    0xbc(%rax),%r8d
 100c42a:	mov    $0x0,%r9d
 100c430:	movl   $0x0,0x18(%rsp)
 100c438:	test   %r8d,%r8d
 100c43b:	je     100c47d <check_program+0x286d>
 100c43d:	xor    %r9d,%r9d
 100c440:	mov    %r8d,%r10d
 100c443:	jmp    100c458 <check_program+0x2848>
 100c445:	data16 cs nopw 0x0(%rax,%rax,1)
 100c450:	mov    %eax,%r10d
 100c453:	cmp    %r10d,%r9d
 100c456:	jae    100c47d <check_program+0x286d>
 100c458:	mov    %r10d,%r11d
 100c45b:	sub    %r9d,%r11d
 100c45e:	shr    $1,%r11d
 100c461:	lea    (%r11,%r9,1),%eax
 100c465:	lea    (%rax,%rax,8),%r12
 100c469:	shl    $0x5,%r12
 100c46d:	cmp    %ebp,(%rdi,%r12,1)
 100c471:	jae    100c450 <check_program+0x2840>
 100c473:	lea    0x1(%r11,%r9,1),%r9d
 100c478:	cmp    %r10d,%r9d
 100c47b:	jb     100c458 <check_program+0x2848>
 100c47d:	cmp    %r8d,%r9d
 100c480:	jae    100c4a9 <check_program+0x2899>
 100c482:	mov    0x8(%rsp),%r12
 100c487:	mov    0x20(%rsp),%r11d
 100c48c:	mov    %r9d,%eax
 100c48f:	lea    (%rax,%rax,8),%rax
 100c493:	shl    $0x5,%rax
 100c497:	cmp    %ebp,(%rdi,%rax,1)
 100c49a:	jne    100c4b3 <check_program+0x28a3>
 100c49c:	mov    0xf0(%rdi,%rax,1),%eax
 100c4a3:	mov    %eax,0x18(%rsp)
 100c4a7:	jmp    100c4f0 <check_program+0x28e0>
 100c4a9:	mov    0x8(%rsp),%r12
 100c4ae:	mov    0x20(%rsp),%r11d
 100c4b3:	cmp    $0x22,%edx
 100c4b6:	je     100c4f0 <check_program+0x28e0>
 100c4b8:	cmp    $0xffffffff,%esi
 100c4bb:	jne    100c4f0 <check_program+0x28e0>
 100c4bd:	cmpl   $0x0,0xbc(%r12)
 100c4c6:	jne    100c4f0 <check_program+0x28e0>
 100c4c8:	mov    0x8(%rcx),%rax
 100c4cc:	mov    (%rax,%rbp,4),%eax
 100c4cf:	movl   $0x1,0xbc(%r12)
 100c4db:	mov    %eax,0xb4(%r12)
 100c4e3:	mov    %eax,0xb8(%r12)
 100c4eb:	nopl   0x0(%rax,%rax,1)
 100c4f0:	mov    0xa0(%r15),%rax
 100c4f7:	cmpl   $0x0,(%rax,%rbp,4)
 100c4fb:	je     100b9a0 <check_program+0x1d90>
 100c501:	xor    %ecx,%ecx
 100c503:	jmp    100c522 <check_program+0x2912>
 100c505:	data16 cs nopw 0x0(%rax,%rax,1)
 100c510:	mov    0xa0(%r15),%rax
 100c517:	inc    %ecx
 100c519:	cmp    (%rax,%rbp,4),%ecx
 100c51c:	jae    100b9a0 <check_program+0x1d90>
 100c522:	mov    0x98(%r15),%rax
 100c529:	mov    0xa8(%r15),%rdx
 100c530:	mov    (%rax,%rbp,4),%eax
 100c533:	add    %ecx,%eax
 100c535:	mov    (%rdx,%rax,4),%edx
 100c538:	cmp    $0x22,%r14d
 100c53c:	je     100c560 <check_program+0x2950>
 100c53e:	cmp    $0x43,%r14d
 100c542:	je     100c560 <check_program+0x2950>
 100c544:	cmp    $0x1f,%ecx
 100c547:	ja     100c510 <check_program+0x2900>
 100c549:	mov    0x18(%rsp),%eax
 100c54d:	bt     %ecx,%eax
 100c550:	jae    100c510 <check_program+0x2900>
 100c552:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c560:	mov    0x8(%r12),%rdi
 100c565:	lea    0x3(%rcx),%esi
 100c568:	mov    0xd0(%rdi),%r8d
 100c56f:	test   %r8d,%r8d
 100c572:	je     100c5e0 <check_program+0x29d0>
 100c574:	mov    0x98(%rdi),%r10
 100c57b:	xor    %r9d,%r9d
 100c57e:	mov    %r8d,%r11d
 100c581:	jmp    100c59b <check_program+0x298b>
 100c583:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100c590:	inc    %r13d
 100c593:	mov    %r13d,%r9d
 100c596:	cmp    %r11d,%r9d
 100c599:	jae    100c5cb <check_program+0x29bb>
 100c59b:	mov    %r11d,%r13d
 100c59e:	sub    %r9d,%r13d
 100c5a1:	shr    $1,%r13d
 100c5a4:	add    %r9d,%r13d
 100c5a7:	lea    0x0(%r13,%r13,8),%rax
 100c5ac:	mov    (%r10,%rax,4),%r12d
 100c5b0:	cmp    %ebp,%r12d
 100c5b3:	jb     100c590 <check_program+0x2980>
 100c5b5:	cmp    %ebp,%r12d
 100c5b8:	jne    100c5c3 <check_program+0x29b3>
 100c5ba:	lea    (%r10,%rax,4),%rax
 100c5be:	cmp    %esi,0x4(%rax)
 100c5c1:	jb     100c590 <check_program+0x2980>
 100c5c3:	mov    %r13d,%r11d
 100c5c6:	cmp    %r11d,%r9d
 100c5c9:	jb     100c59b <check_program+0x298b>
 100c5cb:	cmp    %r8d,%r9d
 100c5ce:	jae    100c660 <check_program+0x2a50>
 100c5d4:	jmp    100c5e8 <check_program+0x29d8>
 100c5d6:	cs nopw 0x0(%rax,%rax,1)
 100c5e0:	xor    %r9d,%r9d
 100c5e3:	cmp    %r8d,%r9d
 100c5e6:	jae    100c660 <check_program+0x2a50>
 100c5e8:	mov    0x98(%rdi),%rax
 100c5ef:	test   %rax,%rax
 100c5f2:	je     100c660 <check_program+0x2a50>
 100c5f4:	mov    %r9d,%edi
 100c5f7:	lea    (%rdi,%rdi,8),%rdi
 100c5fb:	lea    (%rax,%rdi,4),%rdi
 100c5ff:	cmp    %ebp,(%rdi)
 100c601:	jne    100c660 <check_program+0x2a50>
 100c603:	cmp    %esi,0x4(%rdi)
 100c606:	jne    100c660 <check_program+0x2a50>
 100c608:	cmpl   $0x0,0x8(%rdi)
 100c60c:	mov    0x8(%rsp),%r12
 100c611:	mov    0x80(%rsp),%r13
 100c619:	mov    0x20(%rsp),%r11d
 100c61e:	je     100c693 <check_program+0x2a83>
 100c620:	cmpl   $0x0,0xbc(%r12)
 100c629:	jne    100c510 <check_program+0x2900>
 100c62f:	mov    0x8(%r15),%rax
 100c633:	mov    (%rax,%rbp,4),%eax
 100c636:	movl   $0x1,0xbc(%r12)
 100c642:	mov    %eax,0xb4(%r12)
 100c64a:	mov    %eax,0xb8(%r12)
 100c652:	jmp    100c510 <check_program+0x2900>
 100c657:	nopw   0x0(%rax,%rax,1)
 100c660:	mov    0x80(%rsp),%r13
 100c668:	mov    0x20(%rsp),%r11d
 100c66d:	mov    0x8(%rsp),%r12
 100c672:	cmp    %r11d,0x0(%r13,%rdx,4)
 100c677:	je     100c510 <check_program+0x2900>
 100c67d:	mov    0x70(%rsp),%rsi
 100c682:	mov    %ebx,%eax
 100c684:	inc    %ebx
 100c686:	mov    %r11d,0x0(%r13,%rdx,4)
 100c68b:	mov    %edx,(%rsi,%rax,4)
 100c68e:	jmp    100c510 <check_program+0x2900>
 100c693:	mov    0x18(%rdi),%edx
 100c696:	test   %rdx,%rdx
 100c699:	je     100c620 <check_program+0x2a10>
 100c69b:	cmp    0xac(%r12),%edx
 100c6a3:	jae    100c620 <check_program+0x2a10>
 100c6a9:	mov    0x10(%r12),%r8
 100c6ae:	mov    0x1c(%rdi),%r9d
 100c6b2:	mov    (%r8),%rsi
 100c6b5:	shr    $0x3,%r9d
 100c6b9:	movzbl (%rsi,%r9,1),%eax
 100c6be:	cmp    $0xf,%al
 100c6c0:	jne    100c6d1 <check_program+0x2ac1>
 100c6c2:	mov    0x20(%r8),%rax
 100c6c6:	mov    (%rax,%r9,4),%eax
 100c6ca:	shr    $0x3,%eax
 100c6cd:	movzbl (%rsi,%rax,1),%eax
 100c6d1:	cmp    $0xb,%al
 100c6d3:	jne    100c620 <check_program+0x2a10>
 100c6d9:	mov    0xb8(%rsp),%rax
 100c6e1:	cmp    %r11d,(%rax,%rdx,4)
 100c6e5:	je     100c510 <check_program+0x2900>
 100c6eb:	mov    %r11d,(%rax,%rdx,4)
 100c6ef:	mov    0x60(%rsp),%rdx
 100c6f4:	mov    0x10(%rsp),%rsi
 100c6f9:	mov    0x18(%rdi),%eax
 100c6fc:	movb   $0x1,(%rdx,%rax,1)
 100c700:	mov    %esi,%edx
 100c702:	inc    %esi
 100c704:	mov    0x18(%rdi),%eax
 100c707:	mov    %rsi,0x10(%rsp)
 100c70c:	mov    0x88(%rsp),%rsi
 100c714:	shl    $0x20,%rax
 100c718:	mov    %rax,(%rsi,%rdx,8)
 100c71c:	jmp    100c510 <check_program+0x2900>
 100c721:	mov    0x78(%rax),%r8
 100c725:	mov    0xc0(%rax),%r9d
 100c72c:	mov    $0x0,%edi
 100c731:	xor    %eax,%eax
 100c733:	test   %r9d,%r9d
 100c736:	je     100c76a <check_program+0x2b5a>
 100c738:	xor    %edi,%edi
 100c73a:	mov    %r9d,%esi
 100c73d:	jmp    100c747 <check_program+0x2b37>
 100c73f:	nop
 100c740:	mov    %r11d,%esi
 100c743:	cmp    %esi,%edi
 100c745:	jae    100c76a <check_program+0x2b5a>
 100c747:	mov    %esi,%r10d
 100c74a:	sub    %edi,%r10d
 100c74d:	shr    $1,%r10d
 100c750:	lea    (%r10,%rdi,1),%r11d
 100c754:	imul   $0x160,%r11,%r12
 100c75b:	cmp    %ebp,(%r8,%r12,1)
 100c75f:	jae    100c740 <check_program+0x2b30>
 100c761:	lea    0x1(%r10,%rdi,1),%edi
 100c766:	cmp    %esi,%edi
 100c768:	jb     100c747 <check_program+0x2b37>
 100c76a:	mov    $0xffffffff,%esi
 100c76f:	cmp    %r9d,%edi
 100c772:	jae    100c804 <check_program+0x2bf4>
 100c778:	mov    0x8(%rsp),%r12
 100c77d:	mov    0x20(%rsp),%r11d
 100c782:	mov    %edi,%r9d
 100c785:	imul   $0x160,%r9,%r9
 100c78c:	cmp    %ebp,(%r8,%r9,1)
 100c790:	jne    100c80e <check_program+0x2bfe>
 100c792:	mov    0x13c(%r8,%r9,1),%eax
 100c79a:	cmp    $0x3,%eax
 100c79d:	ja     100c7ae <check_program+0x2b9e>
 100c79f:	mov    0xa0(%rcx),%r8
 100c7a6:	mov    %edi,%esi
 100c7a8:	cmp    (%r8,%rbp,4),%eax
 100c7ac:	jbe    100c80e <check_program+0x2bfe>
 100c7ae:	cmpl   $0x0,0xbc(%r12)
 100c7b7:	jne    100c7dc <check_program+0x2bcc>
 100c7b9:	mov    0x8(%rcx),%rcx
 100c7bd:	mov    (%rcx,%rbp,4),%ecx
 100c7c0:	movl   $0x1,0xbc(%r12)
 100c7cc:	mov    %ecx,0xb4(%r12)
 100c7d4:	mov    %ecx,0xb8(%r12)
 100c7dc:	mov    $0xffffffff,%ecx
 100c7e1:	cmp    $0x4,%eax
 100c7e4:	shlx   %eax,%ecx,%ecx
 100c7e9:	mov    $0x0,%eax
 100c7ee:	not    %ecx
 100c7f0:	cmovae %eax,%ecx
 100c7f3:	mov    %ecx,0x18(%rsp)
 100c7f7:	jmp    100c4f0 <check_program+0x28e0>
 100c7fc:	mov    %ebx,%r9d
 100c7ff:	jmp    100bdf3 <check_program+0x21e3>
 100c804:	mov    0x8(%rsp),%r12
 100c809:	mov    0x20(%rsp),%r11d
 100c80e:	mov    $0xffffffff,%edi
 100c813:	shlx   %eax,%edi,%eax
 100c818:	not    %eax
 100c81a:	mov    %eax,0x18(%rsp)
 100c81e:	cmp    $0x22,%edx
 100c821:	jne    100c4b8 <check_program+0x28a8>
 100c827:	jmp    100c4f0 <check_program+0x28e0>
 100c82c:	mov    %r12d,%r9d
 100c82f:	cmpl   $0x0,0x8(%rax)
 100c833:	mov    0x18(%rsp),%r10d
 100c838:	mov    0x8(%rsp),%r12
 100c83d:	je     100cb30 <check_program+0x2f20>
 100c843:	cmpl   $0x0,0xbc(%r12)
 100c84c:	jne    100bec6 <check_program+0x22b6>
 100c852:	mov    0x8(%r15),%rax
 100c856:	mov    (%rax,%rbp,4),%eax
 100c859:	movl   $0x1,0xbc(%r12)
 100c865:	mov    %eax,0xb4(%r12)
 100c86d:	mov    %eax,0xb8(%r12)
 100c875:	jmp    100bec6 <check_program+0x22b6>
 100c87a:	mov    $0xffffffff,%r13d
 100c880:	cmpl   $0x0,0xbc(%r12)
 100c889:	jne    100bdf3 <check_program+0x21e3>
 100c88f:	mov    0x8(%r15),%rax
 100c893:	mov    (%rax,%rbp,4),%eax
 100c896:	movl   $0x1,0xbc(%r12)
 100c8a2:	mov    %eax,0xb4(%r12)
 100c8aa:	mov    %eax,0xb8(%r12)
 100c8b2:	jmp    100bdf3 <check_program+0x21e3>
 100c8b7:	mov    (%rdx),%rcx
 100c8ba:	lea    (%rsi,%rsi,2),%rdx
 100c8be:	shl    $0x4,%rdx
 100c8c2:	cmpl   $0x0,-0x18(%rcx,%rdx,1)
 100c8c7:	je     100b9ac <check_program+0x1d9c>
 100c8cd:	add    %rdx,%rcx
 100c8d0:	xor    %edx,%edx
 100c8d2:	xor    %esi,%esi
 100c8d4:	jmp    100c906 <check_program+0x2cf6>
 100c8d6:	cmpl   $0x0,0xbc(%r12)
 100c8df:	je     100c9c5 <check_program+0x2db5>
 100c8e5:	data16 cs nopw 0x0(%rax,%rax,1)
 100c8f0:	mov    -0x18(%rcx),%edi
 100c8f3:	inc    %rsi
 100c8f6:	add    $0xb0,%rdx
 100c8fd:	cmp    %rdi,%rsi
 100c900:	jae    100cb24 <check_program+0x2f14>
 100c906:	mov    -0x20(%rcx),%rdi
 100c90a:	cmpl   $0x0,(%rdi,%rdx,1)
 100c90e:	jne    100c8f0 <check_program+0x2ce0>
 100c910:	mov    0x8(%rdi,%rdx,1),%r8d
 100c915:	cmp    0x8c(%rax),%r8d
 100c91c:	jae    100c8f0 <check_program+0x2ce0>
 100c91e:	mov    0x8(%r12),%r9
 100c923:	lea    (%r8,%r8,2),%r10
 100c927:	shl    $0x5,%r10
 100c92b:	mov    0x8(%r9),%r9
 100c92f:	cmpl   $0x0,0x44(%r9,%r10,1)
 100c935:	je     100c9a8 <check_program+0x2d98>
 100c937:	cmpl   $0x0,0x84(%rdi,%rdx,1)
 100c93f:	jne    100c8d6 <check_program+0x2cc6>
 100c941:	cmpl   $0x3,0x4c(%rdi,%rdx,1)
 100c946:	jne    100c8d6 <check_program+0x2cc6>
 100c948:	mov    0x80(%rdi,%rdx,1),%r8d
 100c950:	test   %r8d,%r8d
 100c953:	je     100c8d6 <check_program+0x2cc6>
 100c955:	cmp    0xac(%r12),%r8d
 100c95d:	jae    100c8d6 <check_program+0x2cc6>
 100c963:	mov    0xb8(%rsp),%rdi
 100c96b:	cmp    %r11d,(%rdi,%r8,4)
 100c96f:	je     100c8f0 <check_program+0x2ce0>
 100c975:	mov    0x60(%rsp),%r9
 100c97a:	mov    %r11d,(%rdi,%r8,4)
 100c97e:	mov    0x88(%rsp),%r10
 100c986:	movb   $0x1,(%r9,%r8,1)
 100c98b:	mov    0x10(%rsp),%r9
 100c990:	shl    $0x20,%r8
 100c994:	mov    %r9d,%edi
 100c997:	inc    %r9d
 100c99a:	mov    %r8,(%r10,%rdi,8)
 100c99e:	mov    %r9,0x10(%rsp)
 100c9a3:	jmp    100c8f0 <check_program+0x2ce0>
 100c9a8:	cmp    %r11d,0x0(%r13,%r8,4)
 100c9ad:	je     100c8f0 <check_program+0x2ce0>
 100c9b3:	mov    %ebx,%edi
 100c9b5:	inc    %ebx
 100c9b7:	mov    %r11d,0x0(%r13,%r8,4)
 100c9bc:	mov    %r8d,(%r14,%rdi,4)
 100c9c0:	jmp    100c8f0 <check_program+0x2ce0>
 100c9c5:	mov    0xc(%rdi,%rdx,1),%edi
 100c9c9:	movl   $0x1,0xbc(%r12)
 100c9d5:	mov    %edi,0xb4(%r12)
 100c9dd:	mov    %edi,0xb8(%r12)
 100c9e5:	jmp    100c8f0 <check_program+0x2ce0>
 100c9ea:	mov    0x20(%rsp),%r11d
 100c9ef:	mov    0x18(%rsp),%r10d
 100c9f4:	mov    %r12d,%r9d
 100c9f7:	jmp    100cbef <check_program+0x2fdf>
 100c9fc:	mov    0x18(%rax),%ecx
 100c9ff:	test   %rcx,%rcx
 100ca02:	je     100bf87 <check_program+0x2377>
 100ca08:	cmp    0xac(%r12),%ecx
 100ca10:	jae    100bf87 <check_program+0x2377>
 100ca16:	mov    0x10(%r12),%rsi
 100ca1b:	mov    0x1c(%rax),%edi
 100ca1e:	mov    (%rsi),%rdx
 100ca21:	shr    $0x3,%edi
 100ca24:	movzbl (%rdx,%rdi,1),%r8d
 100ca29:	cmp    $0xf,%r8b
 100ca2d:	jne    100ca3e <check_program+0x2e2e>
 100ca2f:	mov    0x20(%rsi),%rsi
 100ca33:	mov    (%rsi,%rdi,4),%esi
 100ca36:	shr    $0x3,%esi
 100ca39:	movzbl (%rdx,%rsi,1),%r8d
 100ca3e:	cmp    $0xb,%r8b
 100ca42:	jne    100bf87 <check_program+0x2377>
 100ca48:	mov    0xb8(%rsp),%rdx
 100ca50:	cmp    %r11d,(%rdx,%rcx,4)
 100ca54:	je     100bfdd <check_program+0x23cd>
 100ca5a:	mov    %r11d,(%rdx,%rcx,4)
 100ca5e:	mov    0x60(%rsp),%rdx
 100ca63:	mov    0x88(%rsp),%rsi
 100ca6b:	mov    0x18(%rax),%ecx
 100ca6e:	movb   $0x1,(%rdx,%rcx,1)
 100ca72:	mov    0x10(%rsp),%rdx
 100ca77:	mov    0x18(%rax),%eax
 100ca7a:	mov    %edx,%ecx
 100ca7c:	inc    %edx
 100ca7e:	shl    $0x20,%rax
 100ca82:	mov    %rdx,0x10(%rsp)
 100ca87:	mov    %rax,(%rsi,%rcx,8)
 100ca8b:	jmp    100bfdd <check_program+0x23cd>
 100ca90:	mov    0x18(%rax),%ecx
 100ca93:	test   %rcx,%rcx
 100ca96:	je     100c080 <check_program+0x2470>
 100ca9c:	cmp    0xac(%r12),%ecx
 100caa4:	jae    100c080 <check_program+0x2470>
 100caaa:	mov    0x10(%r12),%rsi
 100caaf:	mov    0x1c(%rax),%edi
 100cab2:	mov    (%rsi),%rdx
 100cab5:	shr    $0x3,%edi
 100cab8:	movzbl (%rdx,%rdi,1),%r8d
 100cabd:	cmp    $0xf,%r8b
 100cac1:	jne    100cad2 <check_program+0x2ec2>
 100cac3:	mov    0x20(%rsi),%rsi
 100cac7:	mov    (%rsi,%rdi,4),%esi
 100caca:	shr    $0x3,%esi
 100cacd:	movzbl (%rdx,%rsi,1),%r8d
 100cad2:	cmp    $0xb,%r8b
 100cad6:	jne    100c080 <check_program+0x2470>
 100cadc:	mov    0xb8(%rsp),%rdx
 100cae4:	cmp    %r11d,(%rdx,%rcx,4)
 100cae8:	je     100c0ce <check_program+0x24be>
 100caee:	mov    %r11d,(%rdx,%rcx,4)
 100caf2:	mov    0x60(%rsp),%rdx
 100caf7:	mov    0x88(%rsp),%rsi
 100caff:	mov    0x18(%rax),%ecx
 100cb02:	movb   $0x1,(%rdx,%rcx,1)
 100cb06:	mov    0x10(%rsp),%rdx
 100cb0b:	mov    0x18(%rax),%eax
 100cb0e:	mov    %edx,%ecx
 100cb10:	inc    %edx
 100cb12:	shl    $0x20,%rax
 100cb16:	mov    %rdx,0x10(%rsp)
 100cb1b:	mov    %rax,(%rsi,%rcx,8)
 100cb1f:	jmp    100c0ce <check_program+0x24be>
 100cb24:	mov    %ebx,0x2bc(%rsp)
 100cb2b:	jmp    100b9ac <check_program+0x1d9c>
 100cb30:	mov    0x18(%rax),%ecx
 100cb33:	test   %rcx,%rcx
 100cb36:	je     100c843 <check_program+0x2c33>
 100cb3c:	cmp    0xac(%r12),%ecx
 100cb44:	jae    100c843 <check_program+0x2c33>
 100cb4a:	mov    0x10(%r12),%rsi
 100cb4f:	mov    0x1c(%rax),%edi
 100cb52:	mov    (%rsi),%rdx
 100cb55:	shr    $0x3,%edi
 100cb58:	movzbl (%rdx,%rdi,1),%r8d
 100cb5d:	cmp    $0xf,%r8b
 100cb61:	jne    100cb72 <check_program+0x2f62>
 100cb63:	mov    0x20(%rsi),%rsi
 100cb67:	mov    (%rsi,%rdi,4),%esi
 100cb6a:	shr    $0x3,%esi
 100cb6d:	movzbl (%rdx,%rsi,1),%r8d
 100cb72:	cmp    $0xb,%r8b
 100cb76:	jne    100c843 <check_program+0x2c33>
 100cb7c:	mov    0xb8(%rsp),%rdx
 100cb84:	cmp    %r11d,(%rdx,%rcx,4)
 100cb88:	je     100bec6 <check_program+0x22b6>
 100cb8e:	mov    %r11d,(%rdx,%rcx,4)
 100cb92:	mov    0x60(%rsp),%rdx
 100cb97:	mov    0x88(%rsp),%rsi
 100cb9f:	mov    0x18(%rax),%ecx
 100cba2:	movb   $0x1,(%rdx,%rcx,1)
 100cba6:	mov    0x10(%rsp),%rdx
 100cbab:	mov    0x18(%rax),%eax
 100cbae:	mov    %edx,%ecx
 100cbb0:	inc    %edx
 100cbb2:	shl    $0x20,%rax
 100cbb6:	mov    %rdx,0x10(%rsp)
 100cbbb:	mov    %rax,(%rsi,%rcx,8)
 100cbbf:	jmp    100bec6 <check_program+0x22b6>
 100cbc4:	movzbl 0x2bb(%rsp),%eax
 100cbcc:	and    $0x1,%al
 100cbce:	mov    %eax,%ecx
 100cbd0:	neg    %cl
 100cbd2:	sbb    %ecx,%ecx
 100cbd4:	or     %r9d,%ecx
 100cbd7:	cmp    $0x16,%r14d
 100cbdb:	cmovne %r9d,%ecx
 100cbdf:	cmp    $0x1,%al
 100cbe1:	sbb    %r9d,%r9d
 100cbe4:	or     %ecx,%r9d
 100cbe7:	cmp    $0x15,%r14d
 100cbeb:	cmovne %ecx,%r9d
 100cbef:	mov    0x8(%rsp),%r12
 100cbf4:	mov    %r10d,0x18(%rsp)
 100cbf9:	cmp    $0xffffffff,%r13d
 100cbfd:	jne    100be11 <check_program+0x2201>
 100cc03:	jmp    100bec6 <check_program+0x22b6>
 100cc08:	nopl   0x0(%rax,%rax,1)
 100cc10:	mov    0x10(%rsp),%rcx
 100cc15:	mov    0x48(%rsp),%edx
 100cc19:	mov    0x28(%rsp),%rax
 100cc1e:	add    %ecx,%edx
 100cc20:	mov    %ecx,0x1c(%rax)
 100cc23:	jae    100cc6c <check_program+0x305c>
 100cc25:	cmpl   $0x0,0xbc(%r12)
 100cc2e:	mov    0x50(%rsp),%r15
 100cc33:	mov    0x30(%rsp),%rbp
 100cc38:	mov    0xa0(%rsp),%r14
 100cc40:	mov    0x58(%rsp),%rbx
 100cc45:	jne    100aef0 <check_program+0x12e0>
 100cc4b:	movl   $0x3,0xbc(%r12)
 100cc57:	mov    %ebx,0xb4(%r12)
 100cc5f:	mov    %ebx,0xb8(%r12)
 100cc67:	jmp    100aef0 <check_program+0x12e0>
 100cc6c:	mov    0x50(%rsp),%r15
 100cc71:	mov    0x30(%rsp),%rbp
 100cc76:	mov    0x88(%rsp),%rdi
 100cc7e:	mov    0xa0(%rsp),%r14
 100cc86:	mov    $0x0,%r8d
 100cc8c:	xor    %ebx,%ebx
 100cc8e:	cmp    $0x2,%ecx
 100cc91:	jb     100cfc6 <check_program+0x33b6>
 100cc97:	mov    0x10(%rsp),%rdx
 100cc9c:	mov    (%rdi),%rax
 100cc9f:	mov    %edx,%ecx
 100cca1:	cmp    $0x9,%edx
 100cca4:	jae    100ce64 <check_program+0x3254>
 100ccaa:	mov    $0x1,%edx
 100ccaf:	xor    %r8d,%r8d
 100ccb2:	jmp    100cfb0 <check_program+0x33a0>
 100ccb7:	lea    0x0(,%rax,4),%rdx
 100ccbf:	mov    %r14d,%ecx
 100ccc2:	sub    %eax,%ecx
 100ccc4:	xor    %esi,%esi
 100ccc6:	jmp    100ccdc <check_program+0x30cc>
 100ccc8:	nopl   0x0(%rax,%rax,1)
 100ccd0:	add    $0x2,%rsi
 100ccd4:	cmp    %esi,%ecx
 100ccd6:	je     100b082 <check_program+0x1472>
 100ccdc:	mov    0x1b0(%rsp),%rdi
 100cce4:	mov    0x50(%rdi),%rdi
 100cce8:	add    %rax,%rdi
 100cceb:	movzbl (%rsi,%rdi,1),%r8d
 100ccf0:	cmp    $0x53,%r8d
 100ccf4:	je     100cd00 <check_program+0x30f0>
 100ccf6:	cmp    $0x21,%r8d
 100ccfa:	jne    100cd99 <check_program+0x3189>
 100cd00:	mov    0x2a0(%rsp),%edi
 100cd07:	cmp    0x2a4(%rsp),%edi
 100cd0e:	jae    100cd30 <check_program+0x3120>
 100cd10:	mov    0x290(%rsp),%r9
 100cd18:	movl   $0xffffffff,(%r9,%rdi,4)
 100cd20:	incl   0x2a0(%rsp)
 100cd27:	jmp    100cd60 <check_program+0x3150>
 100cd29:	nopl   0x0(%rax)
 100cd30:	mov    0x1a8(%rsp),%r9
 100cd38:	cmpl   $0x0,0xbc(%r9)
 100cd40:	jne    100cd60 <check_program+0x3150>
 100cd42:	movl   $0x3,0xbc(%r9)
 100cd4d:	movq   $0x0,0xb4(%r9)
 100cd58:	nopl   0x0(%rax,%rax,1)
 100cd60:	mov    0x250(%rsp),%r9
 100cd68:	add    %rdx,%r9
 100cd6b:	mov    %edi,(%r9,%rsi,4)
 100cd6f:	cmp    $0x53,%r8b
 100cd73:	jne    100cd99 <check_program+0x3189>
 100cd75:	mov    0x248(%rsp),%r9
 100cd7d:	mov    0x1a8(%rsp),%r8
 100cd85:	add    %rdx,%r9
 100cd88:	mov    0x48(%r8),%r8
 100cd8c:	mov    (%r9,%rsi,4),%r9d
 100cd90:	shl    $0x6,%r9
 100cd94:	mov    %edi,0x2c(%r8,%r9,1)
 100cd99:	mov    0x1b0(%rsp),%rdi
 100cda1:	mov    0x50(%rdi),%rdi
 100cda5:	add    %rax,%rdi
 100cda8:	movzbl 0x1(%rsi,%rdi,1),%r8d
 100cdae:	cmp    $0x53,%r8d
 100cdb2:	je     100cdbe <check_program+0x31ae>
 100cdb4:	cmp    $0x21,%r8d
 100cdb8:	jne    100ccd0 <check_program+0x30c0>
 100cdbe:	mov    0x2a0(%rsp),%edi
 100cdc5:	cmp    0x2a4(%rsp),%edi
 100cdcc:	jae    100cdf0 <check_program+0x31e0>
 100cdce:	mov    0x290(%rsp),%r9
 100cdd6:	movl   $0xffffffff,(%r9,%rdi,4)
 100cdde:	incl   0x2a0(%rsp)
 100cde5:	jmp    100ce20 <check_program+0x3210>
 100cde7:	nopw   0x0(%rax,%rax,1)
 100cdf0:	mov    0x1a8(%rsp),%r9
 100cdf8:	cmpl   $0x0,0xbc(%r9)
 100ce00:	jne    100ce20 <check_program+0x3210>
 100ce02:	movl   $0x3,0xbc(%r9)
 100ce0d:	movq   $0x0,0xb4(%r9)
 100ce18:	nopl   0x0(%rax,%rax,1)
 100ce20:	mov    0x250(%rsp),%r9
 100ce28:	add    %rdx,%r9
 100ce2b:	mov    %edi,0x4(%r9,%rsi,4)
 100ce30:	cmp    $0x53,%r8b
 100ce34:	jne    100ccd0 <check_program+0x30c0>
 100ce3a:	mov    0x248(%rsp),%r9
 100ce42:	mov    0x1a8(%rsp),%r8
 100ce4a:	add    %rdx,%r9
 100ce4d:	mov    0x48(%r8),%r8
 100ce51:	mov    0x4(%r9,%rsi,4),%r9d
 100ce56:	shl    $0x6,%r9
 100ce5a:	mov    %edi,0x2c(%r8,%r9,1)
 100ce5f:	jmp    100ccd0 <check_program+0x30c0>
 100ce64:	lea    -0x1(%rcx),%rsi
 100ce68:	vpbroadcastq %rax,%zmm0
 100ce6e:	cmp    $0x21,%edx
 100ce71:	jae    100ce7e <check_program+0x326e>
 100ce73:	xor    %r10d,%r10d
 100ce76:	xor    %r8d,%r8d
 100ce79:	jmp    100cf50 <check_program+0x3340>
 100ce7e:	mov    %rsi,%r10
 100ce81:	and    $0xffffffffffffffe0,%r10
 100ce85:	vpxor  %xmm1,%xmm1,%xmm1
 100ce89:	xor    %r8d,%r8d
 100ce8c:	vpxor  %xmm2,%xmm2,%xmm2
 100ce90:	vpxor  %xmm4,%xmm4,%xmm4
 100ce94:	vpxor  %xmm3,%xmm3,%xmm3
 100ce98:	lea    0x1(%r10),%rdx
 100ce9c:	nopl   0x0(%rax)
 100cea0:	vpxorq 0x48(%rdi,%r8,8),%zmm0,%zmm6
 100ceab:	vpxorq 0x8(%rdi,%r8,8),%zmm0,%zmm5
 100ceb6:	vpxorq 0x88(%rdi,%r8,8),%zmm0,%zmm7
 100cec1:	vpxorq 0xc8(%rdi,%r8,8),%zmm0,%zmm8
 100cecc:	add    $0x20,%r8
 100ced0:	vpsrlq $0x20,%zmm6,%zmm6
 100ced7:	vpsrlq $0x20,%zmm5,%zmm5
 100cede:	vpsrlq $0x20,%zmm7,%zmm7
 100cee5:	vpsrlq $0x20,%zmm8,%zmm8
 100ceec:	vpmovqd %zmm6,%ymm6
 100cef2:	vpmovqd %zmm5,%ymm5
 100cef8:	vpmovqd %zmm7,%ymm7
 100cefe:	vpor   %ymm6,%ymm4,%ymm4
 100cf02:	vpmovqd %zmm8,%ymm6
 100cf08:	vpor   %ymm5,%ymm2,%ymm2
 100cf0c:	vpor   %ymm7,%ymm3,%ymm3
 100cf10:	vpor   %ymm6,%ymm1,%ymm1
 100cf14:	cmp    %r8,%r10
 100cf17:	jne    100cea0 <check_program+0x3290>
 100cf19:	vpor   %ymm2,%ymm4,%ymm2
 100cf1d:	vpternlogd $0xfe,%ymm2,%ymm3,%ymm1
 100cf24:	vextracti128 $0x1,%ymm1,%xmm2
 100cf2a:	vpor   %xmm2,%xmm1,%xmm1
 100cf2e:	vpshufd $0xee,%xmm1,%xmm2
 100cf33:	vpor   %xmm2,%xmm1,%xmm1
 100cf37:	vpshufd $0x55,%xmm1,%xmm2
 100cf3c:	vpor   %xmm2,%xmm1,%xmm1
 100cf40:	vmovd  %xmm1,%r8d
 100cf45:	cmp    %r10,%rsi
 100cf48:	je     100cfc6 <check_program+0x33b6>
 100cf4a:	test   $0x18,%sil
 100cf4e:	je     100cfb0 <check_program+0x33a0>
 100cf50:	mov    %rsi,%r9
 100cf53:	and    $0xfffffffffffffff8,%r9
 100cf57:	vmovd  %r8d,%xmm1
 100cf5c:	lea    0x1(%r9),%rdx
 100cf60:	vpxorq 0x8(%rdi,%r10,8),%zmm0,%zmm2
 100cf6b:	add    $0x8,%r10
 100cf6f:	vpsrlq $0x20,%zmm2,%zmm2
 100cf76:	vpmovqd %zmm2,%ymm2
 100cf7c:	vpor   %ymm2,%ymm1,%ymm1
 100cf80:	cmp    %r10,%r9
 100cf83:	jne    100cf60 <check_program+0x3350>
 100cf85:	vextracti128 $0x1,%ymm1,%xmm0
 100cf8b:	vpor   %xmm0,%xmm1,%xmm0
 100cf8f:	vpshufd $0xee,%xmm0,%xmm1
 100cf94:	vpor   %xmm1,%xmm0,%xmm0
 100cf98:	vpshufd $0x55,%xmm0,%xmm1
 100cf9d:	vpor   %xmm1,%xmm0,%xmm0
 100cfa1:	vmovd  %xmm0,%r8d
 100cfa6:	cmp    %r9,%rsi
 100cfa9:	je     100cfc6 <check_program+0x33b6>
 100cfab:	nopl   0x0(%rax,%rax,1)
 100cfb0:	mov    (%rdi,%rdx,8),%rsi
 100cfb4:	inc    %rdx
 100cfb7:	xor    %rax,%rsi
 100cfba:	shr    $0x20,%rsi
 100cfbe:	or     %esi,%r8d
 100cfc1:	cmp    %rdx,%rcx
 100cfc4:	jne    100cfb0 <check_program+0x33a0>
 100cfc6:	lea    0x300(%rsp),%rax
 100cfce:	mov    0x168(%rsp),%rsi
 100cfd6:	mov    0x10(%rsp),%rdx
 100cfdb:	movzbl 0x24(%rax),%ecx
 100cfdf:	xor    $0x1,%ecx
 100cfe2:	vzeroupper
 100cfe5:	call   106c180 <c_bindings_sort>
 100cfea:	mov    0x28(%rsp),%rcx
 100cfef:	mov    0x1c(%rcx),%ecx
 100cff2:	test   %rcx,%rcx
 100cff5:	je     100d028 <check_program+0x3418>
 100cff7:	mov    0x38(%rsp),%r8
 100cffc:	mov    (%r8),%rdx
 100cfff:	mov    0x8(%r8),%rdi
 100d003:	lea    0x3(%rdi,%rdx,1),%rsi
 100d008:	add    %rdx,%rdi
 100d00b:	and    $0xfffffffffffffffc,%rsi
 100d00f:	cmp    %rdi,%rsi
 100d012:	jae    100d077 <check_program+0x3467>
 100d014:	mov    0x58(%rsp),%rbx
 100d019:	xor    %edx,%edx
 100d01b:	test   %ecx,%ecx
 100d01d:	jne    100d0b7 <check_program+0x34a7>
 100d023:	jmp    100d0fa <check_program+0x34ea>
 100d028:	xor    %edx,%edx
 100d02a:	cmpq   $0x0,0x58(%r12)
 100d030:	jne    100d03f <check_program+0x342f>
 100d032:	mov    0x28(%rsp),%rcx
 100d037:	mov    %rdx,0x58(%r12)
 100d03c:	mov    0x1c(%rcx),%ebx
 100d03f:	test   %ebx,%ebx
 100d041:	je     100aedf <check_program+0x12cf>
 100d047:	mov    0x58(%rsp),%rbx
 100d04c:	mov    0x28(%rsp),%rdi
 100d051:	xor    %esi,%esi
 100d053:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100d060:	mov    0x4(%rax,%rsi,8),%ecx
 100d064:	mov    %ecx,(%rdx,%rsi,4)
 100d067:	inc    %rsi
 100d06a:	mov    0x1c(%rdi),%ecx
 100d06d:	cmp    %rcx,%rsi
 100d070:	jb     100d060 <check_program+0x3450>
 100d072:	jmp    100aee6 <check_program+0x12d6>
 100d077:	mov    0x10(%r8),%r9
 100d07b:	mov    0x58(%rsp),%rbx
 100d080:	mov    %rsi,%rdi
 100d083:	sub    %rdx,%rdi
 100d086:	sub    %rdi,%r9
 100d089:	jb     100d0f4 <check_program+0x34e4>
 100d08b:	mov    %rcx,%r8
 100d08e:	shl    $0x2,%r8
 100d092:	mov    $0x0,%edx
 100d097:	cmp    %r9,%r8
 100d09a:	ja     100d0b3 <check_program+0x34a3>
 100d09c:	mov    0x38(%rsp),%rcx
 100d0a1:	mov    0x28(%rsp),%rdx
 100d0a6:	add    %r8,%rdi
 100d0a9:	mov    %rdi,0x8(%rcx)
 100d0ad:	mov    0x1c(%rdx),%ecx
 100d0b0:	mov    %rsi,%rdx
 100d0b3:	test   %ecx,%ecx
 100d0b5:	je     100d0fa <check_program+0x34ea>
 100d0b7:	test   %rdx,%rdx
 100d0ba:	jne    100d0fa <check_program+0x34ea>
 100d0bc:	cmpl   $0x0,0xbc(%r12)
 100d0c5:	jne    100aee6 <check_program+0x12d6>
 100d0cb:	mov    0x28(%rsp),%rax
 100d0d0:	movl   $0x3,0xbc(%r12)
 100d0dc:	mov    %ebx,0xb4(%r12)
 100d0e4:	mov    %ebx,0xb8(%r12)
 100d0ec:	mov    0x1c(%rax),%ecx
 100d0ef:	jmp    100aee6 <check_program+0x12d6>
 100d0f4:	xor    %edx,%edx
 100d0f6:	test   %ecx,%ecx
 100d0f8:	jne    100d0b7 <check_program+0x34a7>
 100d0fa:	mov    %ecx,%ebx
 100d0fc:	cmpq   $0x0,0x58(%r12)
 100d102:	jne    100d03f <check_program+0x342f>
 100d108:	jmp    100d032 <check_program+0x3422>
 100d10d:	cmpb   $0x0,0xb0(%rsp)
 100d115:	lea    0xc0(%r12),%r14
 100d11d:	je     100d310 <check_program+0x3700>
 100d123:	mov    0xbc(%r12),%eax
 100d12b:	test   %eax,%eax
 100d12d:	sete   %cl
 100d130:	cmpl   $0x0,0x90(%rsp)
 100d138:	setne  %dl
 100d13b:	and    %cl,%dl
 100d13d:	cmp    $0x1,%dl
 100d140:	jne    100d308 <check_program+0x36f8>
 100d146:	mov    0x90(%rsp),%rsi
 100d14e:	mov    %esi,%ecx
 100d150:	and    $0x3,%ecx
 100d153:	cmp    $0x4,%esi
 100d156:	jae    100d16d <check_program+0x355d>
 100d158:	xor    %edx,%edx
 100d15a:	jmp    100d2b0 <check_program+0x36a0>
 100d15f:	mov    %rdi,%r11
 100d162:	mov    %rbx,%r15
 100d165:	mov    %r10,%rdi
 100d168:	jmp    100d8a9 <check_program+0x3c99>
 100d16d:	and    $0xfffffffc,%esi
 100d170:	mov    $0x6783,%edi
 100d175:	xor    %edx,%edx
 100d177:	jmp    100d198 <check_program+0x3588>
 100d179:	nopl   0x0(%rax)
 100d180:	xor    %r8d,%r8d
 100d183:	add    %r8d,0xa4(%r12)
 100d18b:	add    $0x4,%rdx
 100d18f:	cmp    %rdx,%rsi
 100d192:	je     100d2ab <check_program+0x369b>
 100d198:	cmpl   $0x0,0x0(%r13,%rdx,4)
 100d19e:	mov    $0x0,%r8d
 100d1a4:	je     100d1d5 <check_program+0x35c5>
 100d1a6:	mov    0x0(%rbp),%r8
 100d1aa:	mov    (%r8,%rdx,4),%r9d
 100d1ae:	lea    -0x35(%r9),%r8d
 100d1b2:	cmp    $0xf,%r8d
 100d1b6:	shrx   %r8d,%edi,%r11d
 100d1bb:	mov    $0x1,%r8d
 100d1c1:	setb   %r10b
 100d1c5:	test   %r11b,%r10b
 100d1c8:	jne    100d1d5 <check_program+0x35c5>
 100d1ca:	xor    %r8d,%r8d
 100d1cd:	cmp    $0x44,%r9d
 100d1d1:	sete   %r8b
 100d1d5:	add    %r8d,0xa4(%r12)
 100d1dd:	xor    %r8d,%r8d
 100d1e0:	mov    $0x0,%r9d
 100d1e6:	cmpl   $0x0,0x4(%r13,%rdx,4)
 100d1ec:	je     100d21e <check_program+0x360e>
 100d1ee:	mov    0x0(%rbp),%r9
 100d1f2:	mov    0x4(%r9,%rdx,4),%r10d
 100d1f7:	lea    -0x35(%r10),%r9d
 100d1fb:	cmp    $0xf,%r9d
 100d1ff:	shrx   %r9d,%edi,%ebx
 100d204:	mov    $0x1,%r9d
 100d20a:	setb   %r11b
 100d20e:	test   %bl,%r11b
 100d211:	jne    100d21e <check_program+0x360e>
 100d213:	xor    %r9d,%r9d
 100d216:	cmp    $0x44,%r10d
 100d21a:	sete   %r9b
 100d21e:	add    %r9d,0xa4(%r12)
 100d226:	cmpl   $0x0,0x8(%r13,%rdx,4)
 100d22c:	je     100d25e <check_program+0x364e>
 100d22e:	mov    0x0(%rbp),%r8
 100d232:	mov    0x8(%r8,%rdx,4),%r9d
 100d237:	lea    -0x35(%r9),%r8d
 100d23b:	cmp    $0xf,%r8d
 100d23f:	shrx   %r8d,%edi,%r11d
 100d244:	mov    $0x1,%r8d
 100d24a:	setb   %r10b
 100d24e:	test   %r11b,%r10b
 100d251:	jne    100d25e <check_program+0x364e>
 100d253:	xor    %r8d,%r8d
 100d256:	cmp    $0x44,%r9d
 100d25a:	sete   %r8b
 100d25e:	add    %r8d,0xa4(%r12)
 100d266:	cmpl   $0x0,0xc(%r13,%rdx,4)
 100d26c:	je     100d180 <check_program+0x3570>
 100d272:	mov    0x0(%rbp),%r8
 100d276:	mov    0xc(%r8,%rdx,4),%r9d
 100d27b:	lea    -0x35(%r9),%r8d
 100d27f:	cmp    $0xf,%r8d
 100d283:	shrx   %r8d,%edi,%r11d
 100d288:	mov    $0x1,%r8d
 100d28e:	setb   %r10b
 100d292:	test   %r11b,%r10b
 100d295:	jne    100d183 <check_program+0x3573>
 100d29b:	xor    %r8d,%r8d
 100d29e:	cmp    $0x44,%r9d
 100d2a2:	sete   %r8b
 100d2a6:	jmp    100d183 <check_program+0x3573>
 100d2ab:	test   %rcx,%rcx
 100d2ae:	je     100d308 <check_program+0x36f8>
 100d2b0:	mov    $0x6783,%esi
 100d2b5:	jmp    100d2d2 <check_program+0x36c2>
 100d2b7:	nopw   0x0(%rax,%rax,1)
 100d2c0:	xor    %edi,%edi
 100d2c2:	add    %edi,0xa4(%r12)
 100d2ca:	inc    %rdx
 100d2cd:	dec    %rcx
 100d2d0:	je     100d308 <check_program+0x36f8>
 100d2d2:	cmpl   $0x0,0x0(%r13,%rdx,4)
 100d2d8:	je     100d2c0 <check_program+0x36b0>
 100d2da:	mov    0x0(%rbp),%rdi
 100d2de:	mov    (%rdi,%rdx,4),%r8d
 100d2e2:	lea    -0x35(%r8),%edi
 100d2e6:	cmp    $0xf,%edi
 100d2e9:	shrx   %edi,%esi,%r10d
 100d2ee:	mov    $0x1,%edi
 100d2f3:	setb   %r9b
 100d2f7:	test   %r10b,%r9b
 100d2fa:	jne    100d2c2 <check_program+0x36b2>
 100d2fc:	xor    %edi,%edi
 100d2fe:	cmp    $0x44,%r8d
 100d302:	sete   %dil
 100d306:	jmp    100d2c2 <check_program+0x36b2>
 100d308:	test   %eax,%eax
 100d30a:	je     100d466 <check_program+0x3856>
 100d310:	movq   $0x0,0x60(%r12)
 100d319:	movq   $0x0,0x38(%r12)
 100d322:	mov    0xbc(%r12),%edx
 100d32a:	mov    0xb4(%r12),%ecx
 100d332:	mov    $0x3,%eax
 100d337:	test   %edx,%edx
 100d339:	cmovne %edx,%eax
 100d33c:	cmp    $0x1,%eax
 100d33f:	jne    100d3b6 <check_program+0x37a6>
 100d341:	mov    0x40(%rsp),%rdx
 100d346:	cmp    0x30(%rdx),%ecx
 100d349:	jae    100d3b6 <check_program+0x37a6>
 100d34b:	mov    0x50(%rdx),%rdi
 100d34f:	movzbl (%rdi,%rcx,1),%esi
 100d353:	cmp    $0x53,%esi
 100d356:	je     100d35d <check_program+0x374d>
 100d358:	cmp    $0x49,%esi
 100d35b:	jne    100d3b6 <check_program+0x37a6>
 100d35d:	test   %ecx,%ecx
 100d35f:	je     100d8f9 <check_program+0x3ce9>
 100d365:	mov    0x40(%rsp),%rdx
 100d36a:	mov    0x60(%rdx),%rdx
 100d36e:	cmp    $0x49,%esi
 100d371:	je     100e6c7 <check_program+0x4ab7>
 100d377:	cmp    $0x53,%esi
 100d37a:	jne    100d3b6 <check_program+0x37a6>
 100d37c:	xor    %r8d,%r8d
 100d37f:	nop
 100d380:	mov    %ecx,%esi
 100d382:	cmp    %ecx,(%rdx,%r8,4)
 100d386:	jne    100d3a8 <check_program+0x3798>
 100d388:	cmpb   $0x3a,(%rdi,%r8,1)
 100d38d:	mov    %ecx,%esi
 100d38f:	jne    100d3a8 <check_program+0x3798>
 100d391:	mov    0x40(%rsp),%rsi
 100d396:	mov    0x10(%rsi),%r9
 100d39a:	xor    %esi,%esi
 100d39c:	cmpb   $0x4b,(%r9,%r8,1)
 100d3a1:	setne  %sil
 100d3a5:	add    %r8d,%esi
 100d3a8:	inc    %r8
 100d3ab:	cmp    %rcx,%r8
 100d3ae:	jae    100d3b8 <check_program+0x37a8>
 100d3b0:	cmp    %ecx,%esi
 100d3b2:	je     100d380 <check_program+0x3770>
 100d3b4:	jmp    100d3b8 <check_program+0x37a8>
 100d3b6:	mov    %ecx,%esi
 100d3b8:	mov    0x38(%rsp),%rdx
 100d3bd:	mov    0x178(%rsp),%rdi
 100d3c5:	cmp    0x8(%rdx),%rdi
 100d3c9:	ja     100fe4b <check_program+0x623b>
 100d3cf:	mov    0xb8(%r12),%ecx
 100d3d7:	mov    %rdi,0x8(%rdx)
 100d3db:	vxorpd %xmm0,%xmm0,%xmm0
 100d3df:	vmovupd %zmm0,0x74(%r12)
 100d3ea:	vmovupd %zmm0,0x40(%r12)
 100d3f2:	vmovupd %zmm0,(%r12)
 100d3f9:	mov    %esi,0xb4(%r12)
 100d401:	vxorpd %xmm0,%xmm0,%xmm0
 100d405:	mov    %ecx,0xb8(%r12)
 100d40d:	mov    %eax,0xbc(%r12)
 100d415:	vmovupd %xmm0,(%r14)
 100d41a:	xor    %eax,%eax
 100d41c:	mov    0x328(%rsp),%rcx
 100d424:	mov    0x170(%rsp),%rdx
 100d42c:	cmp    0x8(%rcx),%rdx
 100d430:	ja     100fe4b <check_program+0x623b>
 100d436:	mov    %rdx,0x8(%rcx)
 100d43a:	mov    %fs:0x28,%rcx
 100d443:	cmp    0x2c0(%rsp),%rcx
 100d44b:	jne    100fec4 <check_program+0x62b4>
 100d451:	add    $0x2c8,%rsp
 100d458:	pop    %rbx
 100d459:	pop    %r12
 100d45b:	pop    %r13
 100d45d:	pop    %r14
 100d45f:	pop    %r15
 100d461:	pop    %rbp
 100d462:	vzeroupper
 100d465:	ret
 100d466:	mov    0xa4(%r12),%ecx
 100d46e:	test   %rcx,%rcx
 100d471:	je     100d894 <check_program+0x3c84>
 100d477:	mov    0x38(%rsp),%r8
 100d47c:	mov    (%r8),%rsi
 100d47f:	mov    0x8(%r8),%rdx
 100d483:	lea    0x3(%rdx,%rsi,1),%rax
 100d488:	add    %rsi,%rdx
 100d48b:	and    $0xfffffffffffffffc,%rax
 100d48f:	cmp    %rdx,%rax
 100d492:	jb     100d4b9 <check_program+0x38a9>
 100d494:	mov    %rax,%rdx
 100d497:	sub    %rsi,%rdx
 100d49a:	mov    0x10(%r8),%rsi
 100d49e:	shl    $0x2,%rcx
 100d4a2:	sub    %rdx,%rsi
 100d4a5:	setb   %dil
 100d4a9:	cmp    %rsi,%rcx
 100d4ac:	seta   %sil
 100d4b0:	or     %dil,%sil
 100d4b3:	je     100e6fe <check_program+0x4aee>
 100d4b9:	xor    %ecx,%ecx
 100d4bb:	xor    %eax,%eax
 100d4bd:	jmp    100e711 <check_program+0x4b01>
 100d4c2:	xor    %edx,%edx
 100d4c4:	movq   $0x0,0x48(%r12)
 100d4cd:	jmp    100d94f <check_program+0x3d3f>
 100d4d2:	mov    %r9d,%edi
 100d4d5:	and    $0xfffffff8,%edi
 100d4d8:	xor    %esi,%esi
 100d4da:	xor    %eax,%eax
 100d4dc:	jmp    100d522 <check_program+0x3912>
 100d4de:	xchg   %ax,%ax
 100d4e0:	xor    %ebp,%ebp
 100d4e2:	cmpb   $0x0,0x7(%r12,%rsi,1)
 100d4e8:	sete   %bpl
 100d4ec:	mov    0x8(%rsp),%r12
 100d4f1:	add    %eax,%r8d
 100d4f4:	add    $0x8,%rsi
 100d4f8:	add    %r8d,%r10d
 100d4fb:	add    %r10d,%r9d
 100d4fe:	add    %r9d,%r14d
 100d501:	add    %r14d,%r11d
 100d504:	add    %r11d,%r13d
 100d507:	add    %r13d,%r15d
 100d50a:	mov    %r15d,%eax
 100d50d:	add    %ebp,%eax
 100d50f:	mov    0x50(%rsp),%r15
 100d514:	mov    0x30(%rsp),%rbp
 100d519:	cmp    %rsi,%rdi
 100d51c:	je     100d7e8 <check_program+0x3bd8>
 100d522:	cmpb   $0x53,(%rcx,%rsi,1)
 100d526:	mov    $0x0,%r8d
 100d52c:	jne    100d630 <check_program+0x3a20>
 100d532:	mov    0x1f0(%rbx),%r9
 100d539:	test   %r9,%r9
 100d53c:	je     100d727 <check_program+0x3b17>
 100d542:	xor    %r8d,%r8d
 100d545:	cmpb   $0x0,(%r9,%rsi,1)
 100d54a:	sete   %r8b
 100d54e:	xor    %r9d,%r9d
 100d551:	cmpb   $0x53,0x1(%rcx,%rsi,1)
 100d556:	mov    $0x0,%r10d
 100d55c:	je     100d644 <check_program+0x3a34>
 100d562:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100d570:	cmpb   $0x53,0x2(%rcx,%rsi,1)
 100d575:	jne    100d670 <check_program+0x3a60>
 100d57b:	mov    0x1f0(%rbx),%r11
 100d582:	test   %r11,%r11
 100d585:	je     100d746 <check_program+0x3b36>
 100d58b:	xor    %r9d,%r9d
 100d58e:	cmpb   $0x0,0x2(%r11,%rsi,1)
 100d594:	sete   %r9b
 100d598:	xor    %r11d,%r11d
 100d59b:	cmpb   $0x53,0x3(%rcx,%rsi,1)
 100d5a0:	mov    $0x0,%r14d
 100d5a6:	je     100d684 <check_program+0x3a74>
 100d5ac:	nopl   0x0(%rax)
 100d5b0:	cmpb   $0x53,0x4(%rcx,%rsi,1)
 100d5b5:	jne    100d6b0 <check_program+0x3aa0>
 100d5bb:	mov    0x1f0(%rbx),%r15
 100d5c2:	test   %r15,%r15
 100d5c5:	je     100d765 <check_program+0x3b55>
 100d5cb:	xor    %r11d,%r11d
 100d5ce:	cmpb   $0x0,0x4(%r15,%rsi,1)
 100d5d4:	sete   %r11b
 100d5d8:	xor    %r15d,%r15d
 100d5db:	cmpb   $0x53,0x5(%rcx,%rsi,1)
 100d5e0:	mov    $0x0,%r13d
 100d5e6:	je     100d6c4 <check_program+0x3ab4>
 100d5ec:	nopl   0x0(%rax)
 100d5f0:	cmpb   $0x53,0x6(%rcx,%rsi,1)
 100d5f5:	jne    100d700 <check_program+0x3af0>
 100d5fb:	mov    0x1f0(%rbx),%r12
 100d602:	test   %r12,%r12
 100d605:	je     100d784 <check_program+0x3b74>
 100d60b:	xor    %r15d,%r15d
 100d60e:	cmpb   $0x0,0x6(%r12,%rsi,1)
 100d614:	sete   %r15b
 100d618:	mov    0x8(%rsp),%r12
 100d61d:	xor    %ebp,%ebp
 100d61f:	cmpb   $0x53,0x7(%rcx,%rsi,1)
 100d624:	jne    100d4f1 <check_program+0x38e1>
 100d62a:	jmp    100d70d <check_program+0x3afd>
 100d62f:	nop
 100d630:	xor    %r9d,%r9d
 100d633:	cmpb   $0x53,0x1(%rcx,%rsi,1)
 100d638:	mov    $0x0,%r10d
 100d63e:	jne    100d570 <check_program+0x3960>
 100d644:	mov    0x1f0(%rbx),%r11
 100d64b:	test   %r11,%r11
 100d64e:	je     100d7a1 <check_program+0x3b91>
 100d654:	xor    %r10d,%r10d
 100d657:	cmpb   $0x0,0x1(%r11,%rsi,1)
 100d65d:	sete   %r10b
 100d661:	cmpb   $0x53,0x2(%rcx,%rsi,1)
 100d666:	je     100d57b <check_program+0x396b>
 100d66c:	nopl   0x0(%rax)
 100d670:	xor    %r11d,%r11d
 100d673:	cmpb   $0x53,0x3(%rcx,%rsi,1)
 100d678:	mov    $0x0,%r14d
 100d67e:	jne    100d5b0 <check_program+0x39a0>
 100d684:	mov    0x1f0(%rbx),%r15
 100d68b:	test   %r15,%r15
 100d68e:	je     100d7b7 <check_program+0x3ba7>
 100d694:	xor    %r14d,%r14d
 100d697:	cmpb   $0x0,0x3(%r15,%rsi,1)
 100d69d:	sete   %r14b
 100d6a1:	cmpb   $0x53,0x4(%rcx,%rsi,1)
 100d6a6:	je     100d5bb <check_program+0x39ab>
 100d6ac:	nopl   0x0(%rax)
 100d6b0:	xor    %r15d,%r15d
 100d6b3:	cmpb   $0x53,0x5(%rcx,%rsi,1)
 100d6b8:	mov    $0x0,%r13d
 100d6be:	jne    100d5f0 <check_program+0x39e0>
 100d6c4:	mov    0x1f0(%rbx),%r12
 100d6cb:	test   %r12,%r12
 100d6ce:	je     100d7cd <check_program+0x3bbd>
 100d6d4:	xor    %r13d,%r13d
 100d6d7:	cmpb   $0x0,0x5(%r12,%rsi,1)
 100d6dd:	sete   %r13b
 100d6e1:	mov    0x8(%rsp),%r12
 100d6e6:	cmpb   $0x53,0x6(%rcx,%rsi,1)
 100d6eb:	je     100d5fb <check_program+0x39eb>
 100d6f1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100d700:	xor    %ebp,%ebp
 100d702:	cmpb   $0x53,0x7(%rcx,%rsi,1)
 100d707:	jne    100d4f1 <check_program+0x38e1>
 100d70d:	mov    0x1f0(%rbx),%r12
 100d714:	test   %r12,%r12
 100d717:	jne    100d4e0 <check_program+0x38d0>
 100d71d:	mov    $0x1,%ebp
 100d722:	jmp    100d4ec <check_program+0x38dc>
 100d727:	mov    $0x1,%r8d
 100d72d:	xor    %r9d,%r9d
 100d730:	cmpb   $0x53,0x1(%rcx,%rsi,1)
 100d735:	mov    $0x0,%r10d
 100d73b:	jne    100d570 <check_program+0x3960>
 100d741:	jmp    100d644 <check_program+0x3a34>
 100d746:	mov    $0x1,%r9d
 100d74c:	xor    %r11d,%r11d
 100d74f:	cmpb   $0x53,0x3(%rcx,%rsi,1)
 100d754:	mov    $0x0,%r14d
 100d75a:	jne    100d5b0 <check_program+0x39a0>
 100d760:	jmp    100d684 <check_program+0x3a74>
 100d765:	mov    $0x1,%r11d
 100d76b:	xor    %r15d,%r15d
 100d76e:	cmpb   $0x53,0x5(%rcx,%rsi,1)
 100d773:	mov    $0x0,%r13d
 100d779:	jne    100d5f0 <check_program+0x39e0>
 100d77f:	jmp    100d6c4 <check_program+0x3ab4>
 100d784:	mov    $0x1,%r15d
 100d78a:	mov    0x8(%rsp),%r12
 100d78f:	xor    %ebp,%ebp
 100d791:	cmpb   $0x53,0x7(%rcx,%rsi,1)
 100d796:	jne    100d4f1 <check_program+0x38e1>
 100d79c:	jmp    100d70d <check_program+0x3afd>
 100d7a1:	mov    $0x1,%r10d
 100d7a7:	cmpb   $0x53,0x2(%rcx,%rsi,1)
 100d7ac:	jne    100d670 <check_program+0x3a60>
 100d7b2:	jmp    100d57b <check_program+0x396b>
 100d7b7:	mov    $0x1,%r14d
 100d7bd:	cmpb   $0x53,0x4(%rcx,%rsi,1)
 100d7c2:	jne    100d6b0 <check_program+0x3aa0>
 100d7c8:	jmp    100d5bb <check_program+0x39ab>
 100d7cd:	mov    $0x1,%r13d
 100d7d3:	mov    0x8(%rsp),%r12
 100d7d8:	cmpb   $0x53,0x6(%rcx,%rsi,1)
 100d7dd:	jne    100d700 <check_program+0x3af0>
 100d7e3:	jmp    100d5fb <check_program+0x39eb>
 100d7e8:	mov    0x10(%rsp),%r9
 100d7ed:	test   %rdx,%rdx
 100d7f0:	jne    100d879 <check_program+0x3c69>
 100d7f6:	mov    %r9,%rdx
 100d7f9:	test   %eax,%eax
 100d7fb:	je     100d900 <check_program+0x3cf0>
 100d801:	mov    0x38(%rsp),%rcx
 100d806:	mov    (%rcx),%rsi
 100d809:	mov    0x8(%rcx),%rdx
 100d80d:	lea    0xf(%rdx,%rsi,1),%rcx
 100d812:	add    %rsi,%rdx
 100d815:	and    $0xfffffffffffffff0,%rcx
 100d819:	cmp    %rdx,%rcx
 100d81c:	jae    100d90b <check_program+0x3cfb>
 100d822:	movq   $0x0,0x48(%r12)
 100d82b:	cmpl   $0x0,0xbc(%r12)
 100d834:	mov    %r9,%rdx
 100d837:	jne    100d94f <check_program+0x3d3f>
 100d83d:	movl   $0x3,0xbc(%r12)
 100d849:	mov    %r9,%rdx
 100d84c:	movq   $0x0,0xb4(%r12)
 100d858:	jmp    100d94f <check_program+0x3d3f>
 100d85d:	nopl   (%rax)
 100d860:	xor    %edi,%edi
 100d862:	cmpb   $0x0,(%r8,%rsi,1)
 100d867:	sete   %dil
 100d86b:	add    %edi,%eax
 100d86d:	inc    %rsi
 100d870:	dec    %rdx
 100d873:	je     100d7f6 <check_program+0x3be6>
 100d879:	xor    %edi,%edi
 100d87b:	cmpb   $0x53,(%rcx,%rsi,1)
 100d87f:	jne    100d86b <check_program+0x3c5b>
 100d881:	mov    0x1f0(%rbx),%r8
 100d888:	test   %r8,%r8
 100d88b:	jne    100d860 <check_program+0x3c50>
 100d88d:	mov    $0x1,%edi
 100d892:	jmp    100d86b <check_program+0x3c5b>
 100d894:	xor    %eax,%eax
 100d896:	mov    $0x1,%cl
 100d898:	jmp    100e711 <check_program+0x4b01>
 100d89d:	mov    %r15,%rdi
 100d8a0:	sub    %rcx,%rdi
 100d8a3:	mov    %rbx,%rdx
 100d8a6:	mov    %r10,%r11
 100d8a9:	mov    0x328(%rsp),%r10
 100d8b1:	xor    %esi,%esi
 100d8b3:	mov    0x10(%r10),%r10
 100d8b7:	sub    %rdi,%r10
 100d8ba:	jb     100d8f1 <check_program+0x3ce1>
 100d8bc:	cmp    %r10,%r8
 100d8bf:	ja     100d8f1 <check_program+0x3ce1>
 100d8c1:	mov    0x328(%rsp),%r10
 100d8c9:	add    %r8,%rdi
 100d8cc:	lea    0x3(%rcx,%rdi,1),%r14
 100d8d1:	lea    (%rdi,%rcx,1),%rax
 100d8d5:	and    $0xfffffffffffffffc,%r14
 100d8d9:	mov    %rdi,0x8(%r10)
 100d8dd:	cmp    %rax,%r14
 100d8e0:	jae    100e5e1 <check_program+0x49d1>
 100d8e6:	xor    %r14d,%r14d
 100d8e9:	mov    %rdx,%rbx
 100d8ec:	jmp    1009e0c <check_program+0x1fc>
 100d8f1:	mov    %r15,%r14
 100d8f4:	jmp    100e5ed <check_program+0x49dd>
 100d8f9:	xor    %esi,%esi
 100d8fb:	jmp    100d3b8 <check_program+0x37a8>
 100d900:	movq   $0x0,0x48(%r12)
 100d909:	jmp    100d94f <check_program+0x3d3f>
 100d90b:	mov    %rcx,%rdx
 100d90e:	sub    %rsi,%rdx
 100d911:	mov    0x38(%rsp),%rsi
 100d916:	mov    0x10(%rsi),%rsi
 100d91a:	sub    %rdx,%rsi
 100d91d:	jb     100d822 <check_program+0x3c12>
 100d923:	mov    %eax,%eax
 100d925:	shl    $0x6,%rax
 100d929:	cmp    %rsi,%rax
 100d92c:	ja     100d822 <check_program+0x3c12>
 100d932:	mov    0x38(%rsp),%rsi
 100d937:	add    %rax,%rdx
 100d93a:	mov    %rdx,0x8(%rsi)
 100d93e:	mov    %rcx,0x48(%r12)
 100d943:	mov    %r9,%rdx
 100d946:	test   %rcx,%rcx
 100d949:	je     100d82b <check_program+0x3c1b>
 100d94f:	mov    0x108(%rsp),%rdi
 100d957:	lea    0x4(,%rdx,4),%r13
 100d95f:	mov    $0xff,%esi
 100d964:	mov    %rdx,0xc0(%rsp)
 100d96c:	mov    %r13,%rdx
 100d96f:	vzeroupper
 100d972:	call   788120 <memset@plt>
 100d977:	mov    0x100(%rsp),%rdi
 100d97f:	mov    $0xff,%esi
 100d984:	mov    %r13,%rdx
 100d987:	call   788120 <memset@plt>
 100d98c:	mov    0xc0(%rsp),%r11
 100d994:	mov    0x10(%rsp),%r9
 100d999:	test   %r9,%r9
 100d99c:	je     100ddcb <check_program+0x41bb>
 100d9a2:	xor    %r14d,%r14d
 100d9a5:	vxorpd %xmm0,%xmm0,%xmm0
 100d9a9:	jmp    100d9dc <check_program+0x3dcc>
 100d9ab:	movl   $0x1,0xbc(%r12)
 100d9b7:	mov    %r13d,0xb4(%r12)
 100d9bf:	mov    %r13d,0xb8(%r12)
 100d9c7:	nopw   0x0(%rax,%rax,1)
 100d9d0:	inc    %r14
 100d9d3:	cmp    %r14,%r11
 100d9d6:	je     100ddcb <check_program+0x41bb>
 100d9dc:	mov    0xbc(%r12),%eax
 100d9e4:	cmp    $0x3,%eax
 100d9e7:	je     100ddf0 <check_program+0x41e0>
 100d9ed:	mov    0x1f0(%rbx),%rcx
 100d9f4:	test   %rcx,%rcx
 100d9f7:	je     100da00 <check_program+0x3df0>
 100d9f9:	cmpb   $0x0,(%rcx,%r14,1)
 100d9fe:	jne    100d9d0 <check_program+0x3dc0>
 100da00:	mov    0x40(%rsp),%rsi
 100da05:	mov    0x10(%rsi),%rdx
 100da09:	mov    0x50(%rsi),%rcx
 100da0d:	cmpb   $0x49,(%rdx,%r14,1)
 100da12:	jne    100db40 <check_program+0x3f30>
 100da18:	mov    0x60(%rsi),%rdx
 100da1c:	mov    (%rdx,%r14,4),%edx
 100da20:	cmp    %r9d,%edx
 100da23:	jae    100db40 <check_program+0x3f30>
 100da29:	cmpb   $0x49,(%rcx,%rdx,1)
 100da2d:	jne    100db40 <check_program+0x3f30>
 100da33:	mov    0x2c0(%rbx),%rsi
 100da3a:	mov    0x8(%r12),%r8
 100da3f:	mov    (%rsi,%rdx,4),%edi
 100da42:	cmp    0xa0(%r8),%edi
 100da49:	jae    100daf6 <check_program+0x3ee6>
 100da4f:	mov    0x8(%r8),%r8
 100da53:	mov    0x10(%r12),%rsi
 100da58:	lea    (%rdi,%rdi,2),%rdi
 100da5c:	shl    $0x5,%rdi
 100da60:	mov    (%r8,%rdi,1),%edi
 100da64:	mov    (%rsi),%r8
 100da67:	mov    %edi,%r9d
 100da6a:	shr    $0x3,%r9d
 100da6e:	movzbl (%r8,%r9,1),%r10d
 100da73:	cmp    $0xf,%r10b
 100da77:	jne    100da8d <check_program+0x3e7d>
 100da79:	mov    0x20(%rsi),%rdi
 100da7d:	mov    (%rdi,%r9,4),%edi
 100da81:	mov    %edi,%r9d
 100da84:	shr    $0x3,%r9d
 100da88:	movzbl (%r8,%r9,1),%r10d
 100da8d:	cmp    $0x12,%r10b
 100da91:	jne    100daa6 <check_program+0x3e96>
 100da93:	mov    0x10(%rsi),%r10
 100da97:	testb  $0x4,(%r10,%r9,1)
 100da9c:	je     100daa6 <check_program+0x3e96>
 100da9e:	mov    0x20(%rsi),%rdi
 100daa2:	mov    (%rdi,%r9,4),%edi
 100daa6:	shr    $0x3,%edi
 100daa9:	movzbl (%r8,%rdi,1),%r8d
 100daae:	cmp    $0x2,%r8d
 100dab2:	je     100dad5 <check_program+0x3ec5>
 100dab4:	mov    0x10(%rsp),%r9
 100dab9:	cmp    $0x5,%r8d
 100dabd:	jne    100daf6 <check_program+0x3ee6>
 100dabf:	mov    0x30(%rsi),%rsi
 100dac3:	mov    (%rsi,%rdi,8),%rsi
 100dac7:	dec    %rsi
 100daca:	cmp    $0x80,%rsi
 100dad1:	jae    100daf6 <check_program+0x3ee6>
 100dad3:	jmp    100db40 <check_program+0x3f30>
 100dad5:	lea    (%rdi,%rdi,2),%rsi
 100dad9:	lea    -0xb64ff0(%rip),%rdi        # 4a8af0 <type_integer_info>
 100dae0:	mov    0x10(%rsp),%r9
 100dae5:	movzbl 0x2(%rdi,%rsi,2),%esi
 100daea:	dec    %rsi
 100daed:	cmp    $0x80,%rsi
 100daf4:	jb     100db40 <check_program+0x3f30>
 100daf6:	test   %eax,%eax
 100daf8:	je     100db0e <check_program+0x3efe>
 100dafa:	cmp    $0x1,%eax
 100dafd:	jne    100db40 <check_program+0x3f30>
 100daff:	mov    $0x1,%eax
 100db04:	cmp    0xb8(%r12),%edx
 100db0c:	ja     100db40 <check_program+0x3f30>
 100db0e:	mov    0x40(%rsp),%rax
 100db13:	movl   $0x1,0xbc(%r12)
 100db1f:	mov    %edx,0xb4(%r12)
 100db27:	mov    %edx,0xb8(%r12)
 100db2f:	mov    0x50(%rax),%rcx
 100db33:	mov    $0x1,%eax
 100db38:	nopl   0x0(%rax,%rax,1)
 100db40:	cmpb   $0x53,(%rcx,%r14,1)
 100db45:	jne    100d9d0 <check_program+0x3dc0>
 100db4b:	mov    0x2f8(%rbx),%rcx
 100db52:	mov    (%rcx,%r14,4),%r13d
 100db56:	cmp    %r9d,%r13d
 100db59:	jae    100dbb8 <check_program+0x3fa8>
 100db5b:	mov    0x2c0(%rbx),%rsi
 100db62:	mov    0x8(%r12),%rdi
 100db67:	mov    (%rsi,%r13,4),%edx
 100db6b:	cmp    0xa0(%rdi),%edx
 100db71:	jae    100dbbb <check_program+0x3fab>
 100db73:	mov    0x8(%rdi),%rdi
 100db77:	mov    0x10(%r12),%rcx
 100db7c:	lea    (%rdx,%rdx,2),%rdx
 100db80:	shl    $0x5,%rdx
 100db84:	mov    (%rdi,%rdx,1),%edx
 100db87:	mov    (%rcx),%rdi
 100db8a:	mov    %edx,%r9d
 100db8d:	shr    $0x3,%r9d
 100db91:	movzbl (%rdi,%r9,1),%r10d
 100db96:	cmp    $0xf,%r10b
 100db9a:	jne    100dbdf <check_program+0x3fcf>
 100db9c:	mov    0x20(%rcx),%r8
 100dba0:	mov    (%r8,%r9,4),%r8d
 100dba4:	mov    %r8d,%r9d
 100dba7:	shr    $0x3,%r9d
 100dbab:	movzbl (%rdi,%r9,1),%r10d
 100dbb0:	cmp    $0x12,%r10b
 100dbb4:	je     100dbe8 <check_program+0x3fd8>
 100dbb6:	jmp    100dbfb <check_program+0x3feb>
 100dbb8:	mov    %r14d,%r13d
 100dbbb:	test   %eax,%eax
 100dbbd:	je     100d9ab <check_program+0x3d9b>
 100dbc3:	cmp    $0x1,%eax
 100dbc6:	jne    100d9d0 <check_program+0x3dc0>
 100dbcc:	cmp    0xb8(%r12),%r13d
 100dbd4:	jbe    100d9ab <check_program+0x3d9b>
 100dbda:	jmp    100d9d0 <check_program+0x3dc0>
 100dbdf:	mov    %edx,%r8d
 100dbe2:	cmp    $0x12,%r10b
 100dbe6:	jne    100dbfb <check_program+0x3feb>
 100dbe8:	mov    0x10(%rcx),%r10
 100dbec:	testb  $0x4,(%r10,%r9,1)
 100dbf1:	je     100dbfb <check_program+0x3feb>
 100dbf3:	mov    0x20(%rcx),%r8
 100dbf7:	mov    (%r8,%r9,4),%r8d
 100dbfb:	shr    $0x3,%r8d
 100dbff:	mov    (%rsi,%r14,4),%esi
 100dc03:	movzbl (%rdi,%r8,1),%edi
 100dc08:	cmp    $0x2,%edi
 100dc0b:	je     100dc2d <check_program+0x401d>
 100dc0d:	mov    0x10(%rsp),%r9
 100dc12:	cmp    $0x5,%edi
 100dc15:	jne    100dbbb <check_program+0x3fab>
 100dc17:	mov    0x30(%rcx),%rcx
 100dc1b:	mov    (%rcx,%r8,8),%rcx
 100dc1f:	dec    %rcx
 100dc22:	cmp    $0x80,%rcx
 100dc29:	jae    100dbbb <check_program+0x3fab>
 100dc2b:	jmp    100dc52 <check_program+0x4042>
 100dc2d:	lea    (%r8,%r8,2),%rcx
 100dc31:	lea    -0xb65148(%rip),%rdi        # 4a8af0 <type_integer_info>
 100dc38:	mov    0x10(%rsp),%r9
 100dc3d:	movzbl 0x2(%rdi,%rcx,2),%ecx
 100dc42:	dec    %rcx
 100dc45:	cmp    $0x80,%rcx
 100dc4c:	jae    100dbbb <check_program+0x3fab>
 100dc52:	mov    0x308(%rbx),%rax
 100dc59:	mov    0x98(%r12),%r15d
 100dc61:	mov    0x48(%r12),%rbp
 100dc66:	mov    (%rax,%r14,4),%eax
 100dc6a:	mov    %r15,0x78(%rsp)
 100dc6f:	shl    $0x6,%r15
 100dc73:	cmp    $0xffffffff,%esi
 100dc76:	sete   0x30(%rbp,%r15,1)
 100dc7c:	vmovupd %ymm0,0x0(%rbp,%r15,1)
 100dc83:	mov    %edx,0x20(%rbp,%r15,1)
 100dc88:	mov    %r14d,0x24(%rbp,%r15,1)
 100dc8d:	mov    %r13d,0x28(%rbp,%r15,1)
 100dc92:	movl   $0xffffffff,0x2c(%rbp,%r15,1)
 100dc9b:	cmp    $0xffffffff,%eax
 100dc9e:	setne  0x31(%rbp,%r15,1)
 100dca4:	movq   $0x0,0x32(%rbp,%r15,1)
 100dcad:	movq   $0x0,0x38(%rbp,%r15,1)
 100dcb6:	mov    0x308(%rbx),%rax
 100dcbd:	mov    (%rax,%r14,4),%eax
 100dcc1:	cmp    $0xffffffff,%eax
 100dcc4:	cmove  %esi,%eax
 100dcc7:	cmp    $0xffffffff,%esi
 100dcca:	je     100dd37 <check_program+0x4127>
 100dccc:	lea    0x0(%rbp,%r15,1),%rcx
 100dcd1:	mov    %r12,%rdi
 100dcd4:	mov    %eax,0x118(%rsp)
 100dcdb:	mov    %rcx,0x180(%rsp)
 100dce3:	vzeroupper
 100dce6:	call   1105440 <check_program_case_value>
 100dceb:	mov    0xc0(%rsp),%r11
 100dcf3:	mov    0x10(%rsp),%r9
 100dcf8:	mov    0x118(%rsp),%esi
 100dcff:	vxorpd %xmm0,%xmm0,%xmm0
 100dd03:	test   %al,%al
 100dd05:	je     100dd7a <check_program+0x416a>
 100dd07:	mov    0x180(%rsp),%rax
 100dd0f:	lea    0x10(%rbp,%r15,1),%rcx
 100dd14:	mov    %r12,%rdi
 100dd17:	mov    0x20(%rax),%edx
 100dd1a:	vzeroupper
 100dd1d:	call   1105440 <check_program_case_value>
 100dd22:	mov    0xc0(%rsp),%r11
 100dd2a:	mov    0x10(%rsp),%r9
 100dd2f:	vxorpd %xmm0,%xmm0,%xmm0
 100dd33:	test   %al,%al
 100dd35:	je     100dd7a <check_program+0x416a>
 100dd37:	mov    0x100(%rsp),%rax
 100dd3f:	mov    0x78(%rsp),%rsi
 100dd44:	mov    0x108(%rsp),%rcx
 100dd4c:	incl   0x98(%r12)
 100dd54:	mov    0x128(%rsp),%rdx
 100dd5c:	mov    0x50(%rsp),%r15
 100dd61:	mov    0x30(%rsp),%rbp
 100dd66:	mov    %esi,(%rax,%r14,4)
 100dd6a:	mov    (%rcx,%r13,4),%eax
 100dd6e:	mov    %eax,(%rdx,%rsi,4)
 100dd71:	mov    %esi,(%rcx,%r13,4)
 100dd75:	jmp    100d9d0 <check_program+0x3dc0>
 100dd7a:	mov    0xbc(%r12),%eax
 100dd82:	mov    0x50(%rsp),%r15
 100dd87:	mov    0x30(%rsp),%rbp
 100dd8c:	test   %eax,%eax
 100dd8e:	je     100ddaa <check_program+0x419a>
 100dd90:	cmp    $0x1,%eax
 100dd93:	jne    100d9d0 <check_program+0x3dc0>
 100dd99:	mov    0xb8(%r12),%eax
 100dda1:	cmp    %rax,%r14
 100dda4:	ja     100d9d0 <check_program+0x3dc0>
 100ddaa:	movl   $0x1,0xbc(%r12)
 100ddb6:	mov    %r14d,0xb4(%r12)
 100ddbe:	mov    %r14d,0xb8(%r12)
 100ddc6:	jmp    100d9d0 <check_program+0x3dc0>
 100ddcb:	cmpl   $0x3,0xbc(%r12)
 100ddd4:	je     100ddf0 <check_program+0x41e0>
 100ddd6:	mov    0x40(%rsp),%rsi
 100dddb:	mov    0x328(%rsp),%rcx
 100dde3:	mov    %r12,%rdi
 100dde6:	xor    %edx,%edx
 100dde8:	vzeroupper
 100ddeb:	call   1105670 <check_program_case_conflicts>
 100ddf0:	mov    0xa8(%rsp),%rdi
 100ddf8:	mov    %r15d,%eax
 100ddfb:	lea    0x4(,%rax,4),%rbx
 100de03:	mov    $0xff,%esi
 100de08:	lea    0x1(%rax),%r12
 100de0c:	mov    %rax,0x78(%rsp)
 100de11:	mov    %rbx,%rdx
 100de14:	vzeroupper
 100de17:	call   788120 <memset@plt>
 100de1c:	mov    0xa0(%rsp),%rdi
 100de24:	mov    $0xff,%esi
 100de29:	mov    %rbx,%rdx
 100de2c:	call   788120 <memset@plt>
 100de31:	mov    0xb0(%rsp),%rdi
 100de39:	mov    $0xff,%esi
 100de3e:	mov    %rbx,%rdx
 100de41:	call   788120 <memset@plt>
 100de46:	mov    0x58(%rsp),%rdi
 100de4b:	mov    $0xff,%esi
 100de50:	mov    %rbx,%rdx
 100de53:	call   788120 <memset@plt>
 100de58:	mov    0xd8(%rsp),%rdi
 100de60:	mov    $0xff,%esi
 100de65:	mov    %rbx,%rdx
 100de68:	call   788120 <memset@plt>
 100de6d:	mov    0x90(%rsp),%rax
 100de75:	mov    0x28(%rsp),%rdi
 100de7a:	mov    $0xff,%esi
 100de7f:	lea    0x4(,%rax,4),%r13
 100de87:	mov    %r13,%rdx
 100de8a:	call   788120 <memset@plt>
 100de8f:	mov    0x98(%rsp),%rdi
 100de97:	mov    $0xff,%esi
 100de9c:	mov    %rbx,%rdx
 100de9f:	call   788120 <memset@plt>
 100dea4:	mov    0x130(%rsp),%rdi
 100deac:	mov    $0xff,%esi
 100deb1:	mov    %rbx,%rdx
 100deb4:	call   788120 <memset@plt>
 100deb9:	mov    0xf8(%rsp),%rdi
 100dec1:	mov    $0xff,%esi
 100dec6:	mov    %rbx,%rdx
 100dec9:	call   788120 <memset@plt>
 100dece:	mov    0xe8(%rsp),%rdi
 100ded6:	xor    %esi,%esi
 100ded8:	mov    %rbx,%rdx
 100dedb:	call   788120 <memset@plt>
 100dee0:	mov    0xc8(%rsp),%rdi
 100dee8:	xor    %esi,%esi
 100deea:	mov    %rbx,%rdx
 100deed:	call   788120 <memset@plt>
 100def2:	mov    0x138(%rsp),%r14
 100defa:	mov    $0xff,%esi
 100deff:	mov    %rbx,0x118(%rsp)
 100df07:	mov    %rbx,%rdx
 100df0a:	mov    %r14,%rdi
 100df0d:	call   788120 <memset@plt>
 100df12:	mov    0x340(%rbp),%eax
 100df18:	test   %eax,%eax
 100df1a:	je     100df60 <check_program+0x4350>
 100df1c:	mov    $0x44,%ecx
 100df21:	xor    %edx,%edx
 100df23:	jmp    100df3e <check_program+0x432e>
 100df25:	data16 cs nopw 0x0(%rax,%rax,1)
 100df30:	inc    %rdx
 100df33:	add    $0x50,%rcx
 100df37:	mov    %eax,%esi
 100df39:	cmp    %rsi,%rdx
 100df3c:	jae    100df60 <check_program+0x4350>
 100df3e:	mov    0x338(%rbp),%rsi
 100df45:	cmpl   $0xffffffff,(%rsi,%rcx,1)
 100df49:	je     100df30 <check_program+0x4320>
 100df4b:	mov    -0x4(%rsi,%rcx,1),%esi
 100df4f:	cmp    %r15d,%esi
 100df52:	jae    100df30 <check_program+0x4320>
 100df54:	mov    %edx,(%r14,%rsi,4)
 100df58:	mov    0x340(%rbp),%eax
 100df5e:	jmp    100df30 <check_program+0x4320>
 100df60:	mov    0x60(%rsp),%rdi
 100df65:	movl   $0x0,0x10(%rsp)
 100df6d:	xor    %esi,%esi
 100df6f:	mov    %r12,%rdx
 100df72:	call   788120 <memset@plt>
 100df77:	mov    0x68(%rsp),%rdi
 100df7c:	xor    %esi,%esi
 100df7e:	mov    %r12,%rdx
 100df81:	call   788120 <memset@plt>
 100df86:	mov    0x78(%rsp),%rax
 100df8b:	mov    0xb8(%rsp),%rdi
 100df93:	xor    %esi,%esi
 100df95:	lea    0x4(,%rax,4),%rbx
 100df9d:	mov    %rbx,%rdx
 100dfa0:	call   788120 <memset@plt>
 100dfa5:	mov    0x80(%rsp),%rdi
 100dfad:	xor    %esi,%esi
 100dfaf:	mov    %r13,%rdx
 100dfb2:	call   788120 <memset@plt>
 100dfb7:	mov    0x148(%rsp),%rdi
 100dfbf:	mov    $0xff,%esi
 100dfc4:	mov    %rbx,%rdx
 100dfc7:	call   788120 <memset@plt>
 100dfcc:	mov    0x140(%rsp),%rdi
 100dfd4:	mov    $0xff,%esi
 100dfd9:	mov    %rbx,%rdx
 100dfdc:	call   788120 <memset@plt>
 100dfe1:	mov    0x20(%rsp),%rdi
 100dfe6:	mov    $0xff,%esi
 100dfeb:	mov    %rbx,%rdx
 100dfee:	call   788120 <memset@plt>
 100dff3:	vmovapd 0x190(%rsp),%xmm0
 100dffc:	mov    0x320(%rbp),%ecx
 100e002:	test   %rcx,%rcx
 100e005:	je     100e08e <check_program+0x447e>
 100e00b:	mov    0x8(%rsp),%r10
 100e010:	mov    0x50(%rsp),%r11
 100e015:	mov    %ecx,%edx
 100e017:	and    $0x3,%edx
 100e01a:	mov    %rcx,%rax
 100e01d:	je     100e089 <check_program+0x4479>
 100e01f:	mov    0x20(%rsp),%r14
 100e024:	mov    0x18(%rsp),%rbx
 100e029:	mov    %rcx,%rax
 100e02c:	jmp    100e046 <check_program+0x4436>
 100e02e:	xchg   %ax,%ax
 100e030:	mov    (%r14,%r8,4),%r9d
 100e034:	lea    -0x1(%rax),%edi
 100e037:	mov    %r9d,(%rbx,%rsi,4)
 100e03b:	mov    %edi,(%r14,%r8,4)
 100e03f:	dec    %rax
 100e042:	dec    %edx
 100e044:	je     100e089 <check_program+0x4479>
 100e046:	mov    0x310(%rbp),%rdi
 100e04d:	lea    -0x1(%rax),%esi
 100e050:	lea    (%rsi,%rsi,2),%r9
 100e054:	mov    0xc(%rdi,%r9,8),%r8d
 100e059:	cmp    %r11d,%r8d
 100e05c:	jb     100e030 <check_program+0x4420>
 100e05e:	cmpl   $0x0,0xbc(%r10)
 100e066:	jne    100e03f <check_program+0x442f>
 100e068:	lea    (%rdi,%r9,8),%rsi
 100e06c:	mov    (%rsi),%esi
 100e06e:	movl   $0x1,0xbc(%r10)
 100e079:	mov    %esi,0xb4(%r10)
 100e080:	mov    %esi,0xb8(%r10)
 100e087:	jmp    100e03f <check_program+0x442f>
 100e089:	cmp    $0x4,%ecx
 100e08c:	jae    100e0da <check_program+0x44ca>
 100e08e:	mov    0x50(%rsp),%r11
 100e093:	mov    0x40(%rsp),%r10
 100e098:	mov    0x90(%rsp),%r14
 100e0a0:	mov    0xa8(%rsp),%r15
 100e0a8:	mov    0xa0(%rsp),%r12
 100e0b0:	mov    0xb0(%rsp),%r13
 100e0b8:	test   %r11d,%r11d
 100e0bb:	je     100eaf0 <check_program+0x4ee0>
 100e0c1:	cmp    $0x1,%r11d
 100e0c5:	jne    100e35e <check_program+0x474e>
 100e0cb:	xor    %eax,%eax
 100e0cd:	movl   $0x0,0x10(%rsp)
 100e0d5:	jmp    100e5ad <check_program+0x499d>
 100e0da:	mov    $0xfffffffc,%ecx
 100e0df:	mov    $0xfffffffffffffffc,%r8
 100e0e6:	mov    $0xfffffffffffffffd,%r9
 100e0ed:	mov    $0xfffffffffffffffe,%r10
 100e0f4:	mov    $0xffffffffffffffff,%r11
 100e0fb:	xor    %r14d,%r14d
 100e0fe:	lea    0x1(%rcx),%rdx
 100e102:	lea    0x2(%rcx),%rsi
 100e106:	lea    0x3(%rcx),%rdi
 100e10a:	mov    %rdx,0xc0(%rsp)
 100e112:	jmp    100e171 <check_program+0x4561>
 100e114:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e120:	mov    0x20(%rsp),%rbx
 100e125:	mov    0x18(%rsp),%rdx
 100e12a:	lea    (%rax,%rcx,1),%r15
 100e12e:	mov    (%rbx,%rbp,4),%r12d
 100e132:	mov    %r12d,(%rdx,%r13,4)
 100e136:	mov    %r15d,(%rbx,%rbp,4)
 100e13a:	addq   $0xfffffffffffffffc,0xc0(%rsp)
 100e143:	mov    0x30(%rsp),%rbp
 100e148:	add    $0xfffffffffffffffc,%r8
 100e14c:	add    $0x4,%r14
 100e150:	add    $0xfffffffffffffffc,%rcx
 100e154:	add    $0xfffffffffffffffc,%r9
 100e158:	add    $0xfffffffffffffffc,%r10
 100e15c:	add    $0xfffffffffffffffc,%rsi
 100e160:	add    $0xfffffffffffffffc,%r11
 100e164:	add    $0xfffffffffffffffc,%rdi
 100e168:	cmp    %r14d,%eax
 100e16b:	je     100e08e <check_program+0x447e>
 100e171:	mov    0x310(%rbp),%rbp
 100e178:	lea    (%rax,%r11,1),%r13d
 100e17c:	lea    0x0(%r13,%r13,2),%r15
 100e181:	mov    0xc(%rbp,%r15,8),%r12d
 100e186:	cmp    0x50(%rsp),%r12d
 100e18b:	jae    100e1b0 <check_program+0x45a0>
 100e18d:	mov    0x20(%rsp),%rbx
 100e192:	mov    0x18(%rsp),%rdx
 100e197:	lea    (%rax,%rdi,1),%ebp
 100e19a:	mov    (%rbx,%r12,4),%r15d
 100e19e:	mov    %r15d,(%rdx,%r13,4)
 100e1a2:	mov    %ebp,(%rbx,%r12,4)
 100e1a6:	jmp    100e1f0 <check_program+0x45e0>
 100e1a8:	nopl   0x0(%rax,%rax,1)
 100e1b0:	mov    0x8(%rsp),%r12
 100e1b5:	cmpl   $0x0,0xbc(%r12)
 100e1be:	jne    100e1f0 <check_program+0x45e0>
 100e1c0:	lea    0x0(%rbp,%r15,8),%r15
 100e1c5:	mov    0x8(%rsp),%rdx
 100e1ca:	mov    (%r15),%ebp
 100e1cd:	movl   $0x1,0xbc(%rdx)
 100e1d7:	mov    %ebp,0xb4(%rdx)
 100e1dd:	mov    %ebp,0xb8(%rdx)
 100e1e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e1f0:	mov    0x30(%rsp),%r15
 100e1f5:	lea    (%rax,%r10,1),%r13d
 100e1f9:	mov    0x310(%r15),%r12
 100e200:	lea    0x0(%r13,%r13,2),%r15
 100e205:	mov    0xc(%r12,%r15,8),%ebp
 100e20a:	cmp    0x50(%rsp),%ebp
 100e20e:	jae    100e230 <check_program+0x4620>
 100e210:	mov    0x20(%rsp),%rbx
 100e215:	mov    0x18(%rsp),%rdx
 100e21a:	lea    (%rax,%rsi,1),%r15d
 100e21e:	mov    (%rbx,%rbp,4),%r12d
 100e222:	mov    %r12d,(%rdx,%r13,4)
 100e226:	mov    %r15d,(%rbx,%rbp,4)
 100e22a:	jmp    100e270 <check_program+0x4660>
 100e22c:	nopl   0x0(%rax)
 100e230:	mov    0x8(%rsp),%r13
 100e235:	cmpl   $0x0,0xbc(%r13)
 100e23d:	jne    100e270 <check_program+0x4660>
 100e23f:	lea    (%r12,%r15,8),%r15
 100e243:	mov    0x8(%rsp),%rdx
 100e248:	mov    (%r15),%ebp
 100e24b:	movl   $0x1,0xbc(%rdx)
 100e255:	mov    %ebp,0xb4(%rdx)
 100e25b:	mov    %ebp,0xb8(%rdx)
 100e261:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e270:	mov    0x30(%rsp),%r15
 100e275:	lea    (%rax,%r9,1),%r13d
 100e279:	mov    0x310(%r15),%r12
 100e280:	lea    0x0(%r13,%r13,2),%r15
 100e285:	mov    0xc(%r12,%r15,8),%ebp
 100e28a:	cmp    0x50(%rsp),%ebp
 100e28e:	jae    100e2c0 <check_program+0x46b0>
 100e290:	mov    0xc0(%rsp),%rdx
 100e298:	mov    0x20(%rsp),%rbx
 100e29d:	lea    (%rax,%rdx,1),%r15d
 100e2a1:	mov    (%rbx,%rbp,4),%r12d
 100e2a5:	mov    0x18(%rsp),%rdx
 100e2aa:	mov    %r12d,(%rdx,%r13,4)
 100e2ae:	mov    %r15d,(%rbx,%rbp,4)
 100e2b2:	jmp    100e300 <check_program+0x46f0>
 100e2b4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e2c0:	mov    0x8(%rsp),%r13
 100e2c5:	cmpl   $0x0,0xbc(%r13)
 100e2cd:	jne    100e300 <check_program+0x46f0>
 100e2cf:	lea    (%r12,%r15,8),%r15
 100e2d3:	mov    0x8(%rsp),%rdx
 100e2d8:	mov    (%r15),%ebp
 100e2db:	movl   $0x1,0xbc(%rdx)
 100e2e5:	mov    %ebp,0xb4(%rdx)
 100e2eb:	mov    %ebp,0xb8(%rdx)
 100e2f1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e300:	mov    0x30(%rsp),%r15
 100e305:	lea    (%rax,%r8,1),%r13d
 100e309:	mov    0x310(%r15),%r12
 100e310:	lea    0x0(%r13,%r13,2),%r15
 100e315:	mov    0xc(%r12,%r15,8),%ebp
 100e31a:	cmp    0x50(%rsp),%ebp
 100e31e:	jb     100e120 <check_program+0x4510>
 100e324:	mov    0x8(%rsp),%r13
 100e329:	cmpl   $0x0,0xbc(%r13)
 100e331:	jne    100e13a <check_program+0x452a>
 100e337:	lea    (%r12,%r15,8),%r15
 100e33b:	mov    0x8(%rsp),%rdx
 100e340:	mov    (%r15),%ebp
 100e343:	movl   $0x1,0xbc(%rdx)
 100e34d:	mov    %ebp,0xb4(%rdx)
 100e353:	mov    %ebp,0xb8(%rdx)
 100e359:	jmp    100e13a <check_program+0x452a>
 100e35e:	mov    0x28(%rsp),%rbx
 100e363:	mov    0x78(%rsp),%rcx
 100e368:	and    $0xfffffffe,%ecx
 100e36b:	mov    $0xffffffff,%edx
 100e370:	xor    %eax,%eax
 100e372:	movl   $0x0,0x10(%rsp)
 100e37a:	jmp    100e39d <check_program+0x478d>
 100e37c:	nopl   0x0(%rax)
 100e380:	mov    0x10(%rsp),%r8d
 100e385:	add    $0x2,%rax
 100e389:	add    %esi,%r8d
 100e38c:	add    %edi,%r8d
 100e38f:	mov    %r8d,0x10(%rsp)
 100e394:	cmp    %rax,%rcx
 100e397:	je     100e5a2 <check_program+0x4992>
 100e39d:	mov    0x60(%r10),%rsi
 100e3a1:	mov    (%rsi,%rax,4),%esi
 100e3a4:	cmp    %r11d,%esi
 100e3a7:	jae    100e3ca <check_program+0x47ba>
 100e3a9:	mov    (%r12,%rsi,4),%edi
 100e3ad:	mov    0x58(%rsp),%r8
 100e3b2:	mov    %edi,(%r8,%rax,4)
 100e3b6:	cmp    %rdx,%rdi
 100e3b9:	je     100e3c2 <check_program+0x47b2>
 100e3bb:	mov    %eax,0x0(%r13,%rdi,4)
 100e3c0:	jmp    100e3c6 <check_program+0x47b6>
 100e3c2:	mov    %eax,(%r15,%rsi,4)
 100e3c6:	mov    %eax,(%r12,%rsi,4)
 100e3ca:	mov    0x2d8(%rbp),%rsi
 100e3d1:	cmpl   $0xffffffff,(%rsi,%rax,4)
 100e3d5:	je     100e400 <check_program+0x47f0>
 100e3d7:	mov    0x1f0(%rbp),%rdi
 100e3de:	test   %rdi,%rdi
 100e3e1:	je     100e410 <check_program+0x4800>
 100e3e3:	xor    %esi,%esi
 100e3e5:	cmpb   $0x0,(%rdi,%rax,1)
 100e3e9:	sete   %sil
 100e3ed:	mov    0x50(%r10),%rdi
 100e3f1:	cmpb   $0x9,(%rdi,%rax,1)
 100e3f5:	je     100e41f <check_program+0x480f>
 100e3f7:	jmp    100e450 <check_program+0x4840>
 100e3f9:	nopl   0x0(%rax)
 100e400:	xor    %esi,%esi
 100e402:	mov    0x50(%r10),%rdi
 100e406:	cmpb   $0x9,(%rdi,%rax,1)
 100e40a:	je     100e41f <check_program+0x480f>
 100e40c:	jmp    100e450 <check_program+0x4840>
 100e40e:	xchg   %ax,%ax
 100e410:	mov    $0x1,%esi
 100e415:	mov    0x50(%r10),%rdi
 100e419:	cmpb   $0x9,(%rdi,%rax,1)
 100e41d:	jne    100e450 <check_program+0x4840>
 100e41f:	mov    0x10(%r10),%rdi
 100e423:	cmpb   $0xf,(%rdi,%rax,1)
 100e427:	jne    100e450 <check_program+0x4840>
 100e429:	mov    0x300(%rbp),%rdi
 100e430:	mov    (%rdi,%rax,4),%edi
 100e433:	cmp    %r11d,%edi
 100e436:	jae    100e450 <check_program+0x4840>
 100e438:	mov    0x68(%rsp),%r8
 100e43d:	movb   $0x1,(%r8,%rdi,1)
 100e442:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e450:	mov    0x2a8(%rbp),%rdi
 100e457:	mov    (%rdi,%rax,4),%edi
 100e45a:	cmp    %r14d,%edi
 100e45d:	jae    100e4c0 <check_program+0x48b0>
 100e45f:	mov    0x28(%rsp),%r8
 100e464:	mov    %eax,(%r8,%rdi,4)
 100e468:	mov    0x60(%r10),%rdi
 100e46c:	mov    0x4(%rdi,%rax,4),%edi
 100e470:	cmp    %r11d,%edi
 100e473:	jb     100e4cd <check_program+0x48bd>
 100e475:	mov    0x2d8(%rbp),%rdi
 100e47c:	cmpl   $0xffffffff,0x4(%rdi,%rax,4)
 100e481:	je     100e540 <check_program+0x4930>
 100e487:	mov    0x1f0(%rbp),%r8
 100e48e:	test   %r8,%r8
 100e491:	je     100e500 <check_program+0x48f0>
 100e493:	xor    %edi,%edi
 100e495:	cmpb   $0x0,0x1(%r8,%rax,1)
 100e49b:	sete   %dil
 100e49f:	mov    0x50(%r10),%r8
 100e4a3:	cmpb   $0x9,0x1(%r8,%rax,1)
 100e4a9:	je     100e54e <check_program+0x493e>
 100e4af:	jmp    100e580 <check_program+0x4970>
 100e4b4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 100e4c0:	mov    0x60(%r10),%rdi
 100e4c4:	mov    0x4(%rdi,%rax,4),%edi
 100e4c8:	cmp    %r11d,%edi
 100e4cb:	jae    100e475 <check_program+0x4865>
 100e4cd:	mov    (%r12,%rdi,4),%r9d
 100e4d1:	mov    0x58(%rsp),%r8
 100e4d6:	mov    %r9d,0x4(%r8,%rax,4)
 100e4db:	cmp    %rdx,%r9
 100e4de:	je     100e513 <check_program+0x4903>
 100e4e0:	lea    0x1(%rax),%r8d
 100e4e4:	mov    %r8d,0x0(%r13,%r9,4)
 100e4e9:	mov    %r8d,(%r12,%rdi,4)
 100e4ed:	mov    0x2d8(%rbp),%rdi
 100e4f4:	cmpl   $0xffffffff,0x4(%rdi,%rax,4)
 100e4f9:	jne    100e487 <check_program+0x4877>
 100e4fb:	jmp    100e540 <check_program+0x4930>
 100e4fd:	nopl   (%rax)
 100e500:	mov    $0x1,%edi
 100e505:	mov    0x50(%r10),%r8
 100e509:	cmpb   $0x9,0x1(%r8,%rax,1)
 100e50f:	je     100e54e <check_program+0x493e>
 100e511:	jmp    100e580 <check_program+0x4970>
 100e513:	lea    0x1(%rax),%r8
 100e517:	lea    0x1(%rax),%r9d
 100e51b:	mov    %r9d,(%r15,%rdi,4)
 100e51f:	mov    %r8d,(%r12,%rdi,4)
 100e523:	mov    0x2d8(%rbp),%rdi
 100e52a:	cmpl   $0xffffffff,0x4(%rdi,%rax,4)
 100e52f:	jne    100e487 <check_program+0x4877>
 100e535:	data16 cs nopw 0x0(%rax,%rax,1)
 100e540:	xor    %edi,%edi
 100e542:	mov    0x50(%r10),%r8
 100e546:	cmpb   $0x9,0x1(%r8,%rax,1)
 100e54c:	jne    100e580 <check_program+0x4970>
 100e54e:	mov    0x10(%r10),%r8
 100e552:	cmpb   $0xf,0x1(%r8,%rax,1)
 100e558:	jne    100e580 <check_program+0x4970>
 100e55a:	mov    0x300(%rbp),%r8
 100e561:	mov    0x4(%r8,%rax,4),%r8d
 100e566:	cmp    %r11d,%r8d
 100e569:	jae    100e580 <check_program+0x4970>
 100e56b:	mov    0x68(%rsp),%r9
 100e570:	movb   $0x1,(%r9,%r8,1)
 100e575:	data16 cs nopw 0x0(%rax,%rax,1)
 100e580:	mov    0x2a8(%rbp),%r8
 100e587:	mov    0x4(%r8,%rax,4),%r8d
 100e58c:	cmp    %r14d,%r8d
 100e58f:	jae    100e380 <check_program+0x4770>
 100e595:	lea    0x1(%rax),%r9d
 100e599:	mov    %r9d,(%rbx,%r8,4)
 100e59d:	jmp    100e380 <check_program+0x4770>
 100e5a2:	testb  $0x1,0x78(%rsp)
 100e5a7:	je     100eaf0 <check_program+0x4ee0>
 100e5ad:	mov    0x60(%r10),%rcx
 100e5b1:	mov    (%rcx,%rax,4),%ecx
 100e5b4:	cmp    %r11d,%ecx
 100e5b7:	jae    100ea68 <check_program+0x4e58>
 100e5bd:	mov    (%r12,%rcx,4),%edx
 100e5c1:	mov    0x58(%rsp),%rdi
 100e5c6:	mov    $0xffffffff,%esi
 100e5cb:	mov    %edx,(%rdi,%rax,4)
 100e5ce:	cmp    %rsi,%rdx
 100e5d1:	je     100ea60 <check_program+0x4e50>
 100e5d7:	mov    %eax,0x0(%r13,%rdx,4)
 100e5dc:	jmp    100ea64 <check_program+0x4e54>
 100e5e1:	mov    %rdi,%r11
 100e5e4:	mov    %r14,%rdi
 100e5e7:	sub    %rcx,%rdi
 100e5ea:	mov    %r15,%rsi
 100e5ed:	mov    0x328(%rsp),%r10
 100e5f5:	xor    %eax,%eax
 100e5f7:	mov    0x10(%r10),%r10
 100e5fb:	sub    %rdi,%r10
 100e5fe:	jb     100e631 <check_program+0x4a21>
 100e600:	cmp    %r10,%r8
 100e603:	ja     100e631 <check_program+0x4a21>
 100e605:	mov    0x328(%rsp),%r10
 100e60d:	add    %r8,%rdi
 100e610:	lea    0x3(%rcx,%rdi,1),%r15
 100e615:	lea    (%rdi,%rcx,1),%rax
 100e619:	and    $0xfffffffffffffffc,%r15
 100e61d:	mov    %rdi,0x8(%r10)
 100e621:	cmp    %rax,%r15
 100e624:	jae    100e647 <check_program+0x4a37>
 100e626:	mov    %rdx,%rbx
 100e629:	mov    %rsi,%r15
 100e62c:	jmp    1009e0c <check_program+0x1fc>
 100e631:	mov    %r14,%r15
 100e634:	mov    0x328(%rsp),%r10
 100e63c:	mov    0x10(%r10),%r10
 100e640:	sub    %rdi,%r10
 100e643:	jae    100e664 <check_program+0x4a54>
 100e645:	jmp    100e6af <check_program+0x4a9f>
 100e647:	mov    %rdi,%r11
 100e64a:	mov    %r15,%rdi
 100e64d:	sub    %rcx,%rdi
 100e650:	mov    %r14,%rax
 100e653:	mov    0x328(%rsp),%r10
 100e65b:	mov    0x10(%r10),%r10
 100e65f:	sub    %rdi,%r10
 100e662:	jb     100e6af <check_program+0x4a9f>
 100e664:	cmp    %r10,%r8
 100e667:	ja     100e6af <check_program+0x4a9f>
 100e669:	mov    0x328(%rsp),%r10
 100e671:	add    %r8,%rdi
 100e674:	lea    0x3(%rcx,%rdi,1),%rbx
 100e679:	lea    (%rdi,%rcx,1),%r11
 100e67d:	and    $0xfffffffffffffffc,%rbx
 100e681:	mov    %rdi,0x8(%r10)
 100e685:	mov    0x90(%rsp),%r10
 100e68d:	lea    0x4(,%r10,4),%r10
 100e695:	cmp    %r11,%rbx
 100e698:	jae    100e9fc <check_program+0x4dec>
 100e69e:	mov    %r15,%r13
 100e6a1:	movq   $0x0,0x28(%rsp)
 100e6aa:	jmp    1009e31 <check_program+0x221>
 100e6af:	mov    0x90(%rsp),%r10
 100e6b7:	xor    %r13d,%r13d
 100e6ba:	lea    0x4(,%r10,4),%r10
 100e6c2:	jmp    100ea0b <check_program+0x4dfb>
 100e6c7:	xor    %edi,%edi
 100e6c9:	nopl   0x0(%rax)
 100e6d0:	mov    %ecx,%esi
 100e6d2:	cmp    %ecx,(%rdx,%rdi,4)
 100e6d5:	jne    100e6e9 <check_program+0x4ad9>
 100e6d7:	mov    0x40(%rsp),%rsi
 100e6dc:	mov    0x10(%rsi),%rsi
 100e6e0:	cmpb   $0x49,(%rsi,%rdi,1)
 100e6e4:	mov    %ecx,%esi
 100e6e6:	cmove  %edi,%esi
 100e6e9:	inc    %rdi
 100e6ec:	cmp    %rcx,%rdi
 100e6ef:	jae    100d3b8 <check_program+0x37a8>
 100e6f5:	cmp    %ecx,%esi
 100e6f7:	je     100e6d0 <check_program+0x4ac0>
 100e6f9:	jmp    100d3b8 <check_program+0x37a8>
 100e6fe:	add    %rcx,%rdx
 100e701:	mov    %rdx,0x8(%r8)
 100e705:	cmpl   $0x0,0xa4(%r12)
 100e70e:	sete   %cl
 100e711:	mov    0x90(%rsp),%r11
 100e719:	mov    %rax,0x60(%r12)
 100e71e:	test   %r11d,%r11d
 100e721:	setne  %dl
 100e724:	test   %rax,%rax
 100e727:	setne  %al
 100e72a:	or     %cl,%al
 100e72c:	and    %al,%dl
 100e72e:	cmp    $0x1,%dl
 100e731:	jne    100e8d5 <check_program+0x4cc5>
 100e737:	mov    %r11d,%ecx
 100e73a:	and    $0x3,%ecx
 100e73d:	cmp    $0x4,%r11d
 100e741:	jae    100e74c <check_program+0x4b3c>
 100e743:	xor    %edx,%edx
 100e745:	xor    %esi,%esi
 100e747:	jmp    100e882 <check_program+0x4c72>
 100e74c:	and    $0xfffffffc,%r11d
 100e750:	mov    $0xe003,%edi
 100e755:	xor    %edx,%edx
 100e757:	xor    %esi,%esi
 100e759:	jmp    100e77f <check_program+0x4b6f>
 100e75b:	nopl   0x0(%rax,%rax,1)
 100e760:	mov    0x60(%r12),%r8
 100e765:	mov    %esi,%r9d
 100e768:	inc    %esi
 100e76a:	lea    0x3(%rdx),%r10d
 100e76e:	mov    %r10d,(%r8,%r9,4)
 100e772:	add    $0x4,%rdx
 100e776:	cmp    %rdx,%r11
 100e779:	je     100e87d <check_program+0x4c6d>
 100e77f:	cmpl   $0x0,0x0(%r13,%rdx,4)
 100e785:	je     100e7ba <check_program+0x4baa>
 100e787:	mov    0x0(%rbp),%r8
 100e78b:	mov    (%r8,%rdx,4),%r8d
 100e78f:	mov    %r8d,%r9d
 100e792:	and    $0xfffffffc,%r9d
 100e796:	cmp    $0x3c,%r9d
 100e79a:	je     100e7ac <check_program+0x4b9c>
 100e79c:	add    $0xffffffcb,%r8d
 100e7a0:	cmp    $0xf,%r8d
 100e7a4:	ja     100e7ba <check_program+0x4baa>
 100e7a6:	bt     %r8d,%edi
 100e7aa:	jae    100e7ba <check_program+0x4baa>
 100e7ac:	mov    0x60(%r12),%r8
 100e7b1:	mov    %esi,%r9d
 100e7b4:	inc    %esi
 100e7b6:	mov    %edx,(%r8,%r9,4)
 100e7ba:	cmpl   $0x0,0x4(%r13,%rdx,4)
 100e7c0:	je     100e7fa <check_program+0x4bea>
 100e7c2:	mov    0x0(%rbp),%r8
 100e7c6:	mov    0x4(%r8,%rdx,4),%r8d
 100e7cb:	mov    %r8d,%r9d
 100e7ce:	and    $0xfffffffc,%r9d
 100e7d2:	cmp    $0x3c,%r9d
 100e7d6:	je     100e7e8 <check_program+0x4bd8>
 100e7d8:	add    $0xffffffcb,%r8d
 100e7dc:	cmp    $0xf,%r8d
 100e7e0:	ja     100e7fa <check_program+0x4bea>
 100e7e2:	bt     %r8d,%edi
 100e7e6:	jae    100e7fa <check_program+0x4bea>
 100e7e8:	mov    0x60(%r12),%r8
 100e7ed:	mov    %esi,%r9d
 100e7f0:	inc    %esi
 100e7f2:	lea    0x1(%rdx),%r10d
 100e7f6:	mov    %r10d,(%r8,%r9,4)
 100e7fa:	cmpl   $0x0,0x8(%r13,%rdx,4)
 100e800:	je     100e83a <check_program+0x4c2a>
 100e802:	mov    0x0(%rbp),%r8
 100e806:	mov    0x8(%r8,%rdx,4),%r8d
 100e80b:	mov    %r8d,%r9d
 100e80e:	and    $0xfffffffc,%r9d
 100e812:	cmp    $0x3c,%r9d
 100e816:	je     100e828 <check_program+0x4c18>
 100e818:	add    $0xffffffcb,%r8d
 100e81c:	cmp    $0xf,%r8d
 100e820:	ja     100e83a <check_program+0x4c2a>
 100e822:	bt     %r8d,%edi
 100e826:	jae    100e83a <check_program+0x4c2a>
 100e828:	mov    0x60(%r12),%r8
 100e82d:	mov    %esi,%r9d
 100e830:	inc    %esi
 100e832:	lea    0x2(%rdx),%r10d
 100e836:	mov    %r10d,(%r8,%r9,4)
 100e83a:	cmpl   $0x0,0xc(%r13,%rdx,4)
 100e840:	je     100e772 <check_program+0x4b62>
 100e846:	mov    0x0(%rbp),%r8
 100e84a:	mov    0xc(%r8,%rdx,4),%r8d
 100e84f:	mov    %r8d,%r9d
 100e852:	and    $0xfffffffc,%r9d
 100e856:	cmp    $0x3c,%r9d
 100e85a:	je     100e760 <check_program+0x4b50>
 100e860:	add    $0xffffffcb,%r8d
 100e864:	cmp    $0xf,%r8d
 100e868:	ja     100e772 <check_program+0x4b62>
 100e86e:	bt     %r8d,%edi
 100e872:	jb     100e760 <check_program+0x4b50>
 100e878:	jmp    100e772 <check_program+0x4b62>
 100e87d:	test   %rcx,%rcx
 100e880:	je     100e8d5 <check_program+0x4cc5>
 100e882:	mov    $0xe003,%edi
 100e887:	jmp    100e8a6 <check_program+0x4c96>
 100e889:	nopl   0x0(%rax)
 100e890:	mov    0x60(%r12),%r8
 100e895:	mov    %esi,%r9d
 100e898:	inc    %esi
 100e89a:	mov    %edx,(%r8,%r9,4)
 100e89e:	inc    %rdx
 100e8a1:	dec    %rcx
 100e8a4:	je     100e8d5 <check_program+0x4cc5>
 100e8a6:	cmpl   $0x0,0x0(%r13,%rdx,4)
 100e8ac:	je     100e89e <check_program+0x4c8e>
 100e8ae:	mov    0x0(%rbp),%r8
 100e8b2:	mov    (%r8,%rdx,4),%r8d
 100e8b6:	mov    %r8d,%r9d
 100e8b9:	and    $0xfffffffc,%r9d
 100e8bd:	cmp    $0x3c,%r9d
 100e8c1:	je     100e890 <check_program+0x4c80>
 100e8c3:	add    $0xffffffcb,%r8d
 100e8c7:	cmp    $0xf,%r8d
 100e8cb:	ja     100e89e <check_program+0x4c8e>
 100e8cd:	bt     %r8d,%edi
 100e8d1:	jb     100e890 <check_program+0x4c80>
 100e8d3:	jmp    100e89e <check_program+0x4c8e>
 100e8d5:	mov    0x298(%rsp),%edx
 100e8dc:	lea    0x38(%r12),%rcx
 100e8e1:	test   %rdx,%rdx
 100e8e4:	setne  %sil
 100e8e8:	test   %sil,%al
 100e8eb:	je     100e90e <check_program+0x4cfe>
 100e8ed:	mov    0x38(%rsp),%rsi
 100e8f2:	mov    (%rsi),%r8
 100e8f5:	mov    0x8(%rsi),%rsi
 100e8f9:	lea    0x3(%rsi,%r8,1),%rdi
 100e8fe:	add    %r8,%rsi
 100e901:	and    $0xfffffffffffffffc,%rdi
 100e905:	cmp    %rsi,%rdi
 100e908:	jae    100e9b0 <check_program+0x4da0>
 100e90e:	mov    0x110(%rsp),%rsi
 100e916:	movq   $0x0,(%rcx)
 100e91d:	test   $0x1,%al
 100e91f:	je     100d322 <check_program+0x3712>
 100e925:	xor    %edi,%edi
 100e927:	test   %edx,%edx
 100e929:	je     100e934 <check_program+0x4d24>
 100e92b:	test   %rdi,%rdi
 100e92e:	je     100d322 <check_program+0x3712>
 100e934:	mov    0x48(%rsp),%eax
 100e938:	mov    %edx,0x90(%r12)
 100e940:	mov    %eax,0xa0(%r12)
 100e948:	test   %edx,%edx
 100e94a:	je     100e958 <check_program+0x4d48>
 100e94c:	shl    $0x4,%rdx
 100e950:	vzeroupper
 100e953:	call   788240 <memcpy@plt>
 100e958:	mov    0x78(%r12),%rdi
 100e95d:	mov    %r15,%r13
 100e960:	mov    %r13d,%r15d
 100e963:	lea    0x4(,%r15,4),%rbx
 100e96b:	xor    %esi,%esi
 100e96d:	mov    %rbx,%rdx
 100e970:	vzeroupper
 100e973:	call   788120 <memset@plt>
 100e978:	mov    0x88(%r12),%rdi
 100e980:	mov    $0xff,%esi
 100e985:	mov    %rbx,%rdx
 100e988:	call   788120 <memset@plt>
 100e98d:	lea    0x300(%rsp),%rsi
 100e995:	test   %r13d,%r13d
 100e998:	je     100f03a <check_program+0x542a>
 100e99e:	cmpl   $0x1,0x50(%rsp)
 100e9a3:	jne    100eec0 <check_program+0x52b0>
 100e9a9:	xor    %eax,%eax
 100e9ab:	jmp    100efd3 <check_program+0x53c3>
 100e9b0:	mov    0x38(%rsp),%r9
 100e9b5:	mov    %rdi,%rsi
 100e9b8:	sub    %r8,%rsi
 100e9bb:	mov    0x10(%r9),%r9
 100e9bf:	sub    %rsi,%r9
 100e9c2:	jb     100e90e <check_program+0x4cfe>
 100e9c8:	mov    %rdx,%r8
 100e9cb:	shl    $0x4,%r8
 100e9cf:	cmp    %r9,%r8
 100e9d2:	ja     100e90e <check_program+0x4cfe>
 100e9d8:	mov    0x38(%rsp),%r9
 100e9dd:	add    %r8,%rsi
 100e9e0:	mov    %rsi,0x8(%r9)
 100e9e4:	mov    0x110(%rsp),%rsi
 100e9ec:	mov    %rdi,(%rcx)
 100e9ef:	test   $0x1,%al
 100e9f1:	je     100d322 <check_program+0x3712>
 100e9f7:	jmp    100e927 <check_program+0x4d17>
 100e9fc:	mov    %rdi,%r11
 100e9ff:	mov    %rbx,%rdi
 100ea02:	mov    %r15,%r13
 100ea05:	sub    %rcx,%rdi
 100ea08:	mov    %rbx,%r15
 100ea0b:	mov    0x328(%rsp),%rbx
 100ea13:	mov    0x10(%rbx),%r14
 100ea17:	xor    %ebx,%ebx
 100ea19:	sub    %rdi,%r14
 100ea1c:	jb     100ea56 <check_program+0x4e46>
 100ea1e:	cmp    %r14,%r10
 100ea21:	ja     100ea56 <check_program+0x4e46>
 100ea23:	mov    0x328(%rsp),%r11
 100ea2b:	add    %r10,%rdi
 100ea2e:	lea    0x3(%rcx,%rdi,1),%rbx
 100ea33:	lea    (%rdi,%rcx,1),%r14
 100ea37:	and    $0xfffffffffffffffc,%rbx
 100ea3b:	mov    %rdi,0x8(%r11)
 100ea3f:	cmp    %r14,%rbx
 100ea42:	jae    100eddd <check_program+0x51cd>
 100ea48:	movq   $0x0,0x28(%rsp)
 100ea51:	jmp    1009e34 <check_program+0x224>
 100ea56:	mov    %r15,0x28(%rsp)
 100ea5b:	jmp    100edee <check_program+0x51de>
 100ea60:	mov    %eax,(%r15,%rcx,4)
 100ea64:	mov    %eax,(%r12,%rcx,4)
 100ea68:	mov    0x2d8(%rbp),%rcx
 100ea6f:	cmpl   $0xffffffff,(%rcx,%rax,4)
 100ea73:	je     100ea96 <check_program+0x4e86>
 100ea75:	mov    0x1f0(%rbp),%rdx
 100ea7c:	test   %rdx,%rdx
 100ea7f:	je     100eaa4 <check_program+0x4e94>
 100ea81:	xor    %ecx,%ecx
 100ea83:	cmpb   $0x0,(%rdx,%rax,1)
 100ea87:	sete   %cl
 100ea8a:	mov    0x50(%r10),%rdx
 100ea8e:	cmpb   $0x9,(%rdx,%rax,1)
 100ea92:	je     100eab3 <check_program+0x4ea3>
 100ea94:	jmp    100ead5 <check_program+0x4ec5>
 100ea96:	xor    %ecx,%ecx
 100ea98:	mov    0x50(%r10),%rdx
 100ea9c:	cmpb   $0x9,(%rdx,%rax,1)
 100eaa0:	je     100eab3 <check_program+0x4ea3>
 100eaa2:	jmp    100ead5 <check_program+0x4ec5>
 100eaa4:	mov    $0x1,%ecx
 100eaa9:	mov    0x50(%r10),%rdx
 100eaad:	cmpb   $0x9,(%rdx,%rax,1)
 100eab1:	jne    100ead5 <check_program+0x4ec5>
 100eab3:	mov    0x10(%r10),%rdx
 100eab7:	cmpb   $0xf,(%rdx,%rax,1)
 100eabb:	jne    100ead5 <check_program+0x4ec5>
 100eabd:	mov    0x300(%rbp),%rdx
 100eac4:	mov    (%rdx,%rax,4),%edx
 100eac7:	cmp    %r11d,%edx
 100eaca:	jae    100ead5 <check_program+0x4ec5>
 100eacc:	mov    0x68(%rsp),%rsi
 100ead1:	movb   $0x1,(%rsi,%rdx,1)
 100ead5:	mov    0x2a8(%rbp),%rdx
 100eadc:	add    %ecx,0x10(%rsp)
 100eae0:	mov    (%rdx,%rax,4),%ecx
 100eae3:	cmp    %r14d,%ecx
 100eae6:	jae    100eaf0 <check_program+0x4ee0>
 100eae8:	mov    0x28(%rsp),%rdx
 100eaed:	mov    %eax,(%rdx,%rcx,4)
 100eaf0:	test   %r14,%r14
 100eaf3:	je     100ece1 <check_program+0x50d1>
 100eaf9:	mov    0x90(%rsp),%r8
 100eb01:	mov    %r8d,%ecx
 100eb04:	and    $0x7,%ecx
 100eb07:	mov    %r8,%rax
 100eb0a:	je     100eb45 <check_program+0x4f35>
 100eb0c:	mov    0xd8(%rsp),%rbx
 100eb14:	mov    0xf0(%rsp),%r9
 100eb1c:	nopl   0x0(%rax)
 100eb20:	mov    0x8(%rbp),%rdx
 100eb24:	dec    %rax
 100eb27:	dec    %ecx
 100eb29:	mov    %eax,%esi
 100eb2b:	mov    (%rdx,%rsi,4),%edx
 100eb2e:	mov    (%rbx,%rdx,4),%edi
 100eb31:	mov    %edi,(%r9,%rsi,4)
 100eb35:	mov    %eax,(%rbx,%rdx,4)
 100eb38:	jne    100eb20 <check_program+0x4f10>
 100eb3a:	cmp    $0x8,%r8d
 100eb3e:	jae    100eb5f <check_program+0x4f4f>
 100eb40:	jmp    100ece1 <check_program+0x50d1>
 100eb45:	mov    0xd8(%rsp),%rbx
 100eb4d:	mov    0xf0(%rsp),%r9
 100eb55:	cmp    $0x8,%r8d
 100eb59:	jb     100ece1 <check_program+0x50d1>
 100eb5f:	mov    $0xfffffffc,%ecx
 100eb64:	mov    %r9,%rdx
 100eb67:	xor    %r14d,%r14d
 100eb6a:	xor    %r13d,%r13d
 100eb6d:	lea    -0x4(%rcx),%r12
 100eb71:	lea    -0x3(%rcx),%rsi
 100eb75:	lea    -0x2(%rcx),%rdi
 100eb79:	lea    -0x1(%rcx),%r8
 100eb7d:	lea    0x1(%rcx),%r9
 100eb81:	lea    0x2(%rcx),%r10
 100eb85:	lea    0x3(%rcx),%r11
 100eb89:	nopl   0x0(%rax)
 100eb90:	mov    0x8(%rbp),%r15
 100eb94:	mov    %r12,0xc0(%rsp)
 100eb9c:	lea    -0x1(%rax,%r13,1),%r12d
 100eba1:	add    $0x8,%r14
 100eba5:	mov    (%r15,%r12,4),%r15d
 100eba9:	mov    (%rbx,%r15,4),%ebp
 100ebad:	mov    %ebp,(%rdx,%r12,4)
 100ebb1:	lea    (%rax,%r11,1),%ebp
 100ebb5:	lea    -0x2(%rax,%r13,1),%r12d
 100ebba:	add    $0xfffffffffffffff8,%r11
 100ebbe:	mov    %ebp,(%rbx,%r15,4)
 100ebc2:	mov    0x30(%rsp),%r15
 100ebc7:	mov    0x8(%r15),%r15
 100ebcb:	mov    (%r15,%r12,4),%r15d
 100ebcf:	mov    (%rbx,%r15,4),%ebp
 100ebd3:	mov    %ebp,(%rdx,%r12,4)
 100ebd7:	mov    0x30(%rsp),%r12
 100ebdc:	lea    (%r10,%rax,1),%ebp
 100ebe0:	add    $0xfffffffffffffff8,%r10
 100ebe4:	mov    %ebp,(%rbx,%r15,4)
 100ebe8:	lea    -0x3(%rax,%r13,1),%r15d
 100ebed:	mov    0x8(%r12),%r12
 100ebf2:	mov    (%r12,%r15,4),%r12d
 100ebf6:	mov    (%rbx,%r12,4),%ebp
 100ebfa:	mov    %ebp,(%rdx,%r15,4)
 100ebfe:	mov    0x30(%rsp),%r15
 100ec03:	lea    (%r9,%rax,1),%ebp
 100ec07:	add    $0xfffffffffffffff8,%r9
 100ec0b:	mov    %ebp,(%rbx,%r12,4)
 100ec0f:	lea    -0x4(%rax,%r13,1),%r12d
 100ec14:	mov    0x8(%r15),%r15
 100ec18:	mov    (%r15,%r12,4),%r15d
 100ec1c:	mov    (%rbx,%r15,4),%ebp
 100ec20:	mov    %ebp,(%rdx,%r12,4)
 100ec24:	lea    (%rcx,%rax,1),%ebp
 100ec27:	lea    -0x5(%rax,%r13,1),%r12d
 100ec2c:	add    $0xfffffffffffffff8,%rcx
 100ec30:	mov    %ebp,(%rbx,%r15,4)
 100ec34:	mov    0x30(%rsp),%r15
 100ec39:	mov    0x8(%r15),%r15
 100ec3d:	mov    (%r15,%r12,4),%r15d
 100ec41:	mov    (%rbx,%r15,4),%ebp
 100ec45:	mov    %ebp,(%rdx,%r12,4)
 100ec49:	mov    0x30(%rsp),%r12
 100ec4e:	lea    (%r8,%rax,1),%ebp
 100ec52:	add    $0xfffffffffffffff8,%r8
 100ec56:	mov    %ebp,(%rbx,%r15,4)
 100ec5a:	lea    -0x6(%rax,%r13,1),%r15d
 100ec5f:	mov    0x8(%r12),%r12
 100ec64:	mov    (%r12,%r15,4),%r12d
 100ec68:	mov    (%rbx,%r12,4),%ebp
 100ec6c:	mov    %ebp,(%rdx,%r15,4)
 100ec70:	lea    (%rdi,%rax,1),%ebp
 100ec73:	add    $0xfffffffffffffff8,%rdi
 100ec77:	mov    %ebp,(%rbx,%r12,4)
 100ec7b:	mov    0x30(%rsp),%r12
 100ec80:	mov    0x8(%r12),%r15
 100ec85:	lea    -0x7(%rax,%r13,1),%r12d
 100ec8a:	mov    (%r15,%r12,4),%r15d
 100ec8e:	mov    (%rbx,%r15,4),%ebp
 100ec92:	mov    %ebp,(%rdx,%r12,4)
 100ec96:	lea    (%rsi,%rax,1),%ebp
 100ec99:	lea    -0x8(%rax,%r13,1),%r12d
 100ec9e:	add    $0xfffffffffffffff8,%r13
 100eca2:	add    $0xfffffffffffffff8,%rsi
 100eca6:	mov    %ebp,(%rbx,%r15,4)
 100ecaa:	mov    0x30(%rsp),%r15
 100ecaf:	mov    0x8(%r15),%r15
 100ecb3:	mov    (%r15,%r12,4),%r15d
 100ecb7:	mov    (%rbx,%r15,4),%ebp
 100ecbb:	mov    %ebp,(%rdx,%r12,4)
 100ecbf:	mov    0xc0(%rsp),%r12
 100ecc7:	lea    (%r12,%rax,1),%ebp
 100eccb:	add    $0xfffffffffffffff8,%r12
 100eccf:	mov    %ebp,(%rbx,%r15,4)
 100ecd3:	mov    0x30(%rsp),%rbp
 100ecd8:	cmp    %r14d,%eax
 100ecdb:	jne    100eb90 <check_program+0x4f80>
 100ece1:	lea    0x300(%rsp),%rsi
 100ece9:	mov    0x8(%rsp),%r12
 100ecee:	mov    0x50(%rsp),%r15
 100ecf3:	mov    0x80(%rsp),%r13
 100ecfb:	mov    0x188(%rsp),%rbx
 100ed03:	mov    0x78(%rsp),%r14
 100ed08:	mov    (%rsi),%rax
 100ed0b:	test   %rax,%rax
 100ed0e:	je     100f335 <check_program+0x5725>
 100ed14:	mov    0x18(%rax),%edx
 100ed17:	test   %rdx,%rdx
 100ed1a:	je     100f335 <check_program+0x5725>
 100ed20:	test   %r15d,%r15d
 100ed23:	mov    %rdx,%rcx
 100ed26:	setne  %al
 100ed29:	test   $0x1,%dl
 100ed2c:	je     100f330 <check_program+0x5720>
 100ed32:	mov    (%rsi),%rsi
 100ed35:	lea    -0x1(%rdx),%rcx
 100ed39:	mov    0x8(%rsi),%rsi
 100ed3d:	mov    -0x4(%rsi,%rdx,4),%esi
 100ed41:	cmp    %r15d,%esi
 100ed44:	jae    100f301 <check_program+0x56f1>
 100ed4a:	mov    0x2b0(%rbp),%r8
 100ed51:	mov    0x280(%rbp),%rdi
 100ed58:	mov    (%r8,%rsi,4),%r8d
 100ed5c:	movzbl (%rdi,%rsi,1),%edi
 100ed60:	dec    %r8d
 100ed63:	cmp    %r15d,%r8d
 100ed66:	setb   %r9b
 100ed6a:	test   %dil,%dil
 100ed6d:	jne    100f2bd <check_program+0x56ad>
 100ed73:	cmp    %r15d,%r8d
 100ed76:	jae    100f2bd <check_program+0x56ad>
 100ed7c:	mov    0x40(%rsp),%r9
 100ed81:	mov    %r8d,%r10d
 100ed84:	mov    %eax,%ebp
 100ed86:	mov    0x50(%r9),%r11
 100ed8a:	mov    $0x1,%r9b
 100ed8d:	cmpb   $0x1e,(%r11,%r10,1)
 100ed92:	je     100f2bf <check_program+0x56af>
 100ed98:	mov    0x40(%rsp),%r8
 100ed9d:	mov    $0x1,%r14d
 100eda3:	mov    0x60(%r8),%r8
 100eda7:	mov    (%r8,%r10,4),%r10d
 100edab:	cmp    %r15d,%r14d
 100edae:	setb   %bpl
 100edb2:	cmp    %r15d,%r10d
 100edb5:	setb   %r9b
 100edb9:	jae    100edd0 <check_program+0x51c0>
 100edbb:	cmp    %r15d,%r14d
 100edbe:	jae    100edd0 <check_program+0x51c0>
 100edc0:	inc    %r14d
 100edc3:	cmpb   $0x1e,(%r11,%r10,1)
 100edc8:	jne    100eda7 <check_program+0x5197>
 100edca:	mov    $0x1,%r9b
 100edcd:	mov    $0x1,%bpl
 100edd0:	mov    %r10d,%r8d
 100edd3:	mov    0x78(%rsp),%r14
 100edd8:	jmp    100f2bf <check_program+0x56af>
 100eddd:	mov    %rdi,%r11
 100ede0:	mov    %rbx,%rdi
 100ede3:	sub    %rcx,%rdi
 100ede6:	mov    %rbx,0x28(%rsp)
 100edeb:	mov    %r15,%rbx
 100edee:	mov    0x328(%rsp),%r14
 100edf6:	xor    %r15d,%r15d
 100edf9:	mov    0x10(%r14),%r14
 100edfd:	sub    %rdi,%r14
 100ee00:	jb     100ee30 <check_program+0x5220>
 100ee02:	cmp    %r14,%r10
 100ee05:	ja     100ee30 <check_program+0x5220>
 100ee07:	mov    0x328(%rsp),%r11
 100ee0f:	add    %r10,%rdi
 100ee12:	lea    0x3(%rcx,%rdi,1),%r14
 100ee17:	lea    (%rdi,%rcx,1),%r15
 100ee1b:	and    $0xfffffffffffffffc,%r14
 100ee1f:	mov    %rdi,0x8(%r11)
 100ee23:	cmp    %r15,%r14
 100ee26:	jae    100ee49 <check_program+0x5239>
 100ee28:	mov    %rbx,%r15
 100ee2b:	jmp    1009e34 <check_program+0x224>
 100ee30:	mov    0x28(%rsp),%r14
 100ee35:	mov    0x328(%rsp),%r12
 100ee3d:	mov    0x10(%r12),%r12
 100ee42:	sub    %rdi,%r12
 100ee45:	jae    100ee69 <check_program+0x5259>
 100ee47:	jmp    100eeab <check_program+0x529b>
 100ee49:	mov    0x28(%rsp),%r15
 100ee4e:	mov    %rdi,%r11
 100ee51:	mov    %r14,%rdi
 100ee54:	sub    %rcx,%rdi
 100ee57:	mov    0x328(%rsp),%r12
 100ee5f:	mov    0x10(%r12),%r12
 100ee64:	sub    %rdi,%r12
 100ee67:	jb     100eeab <check_program+0x529b>
 100ee69:	cmp    %r12,%r8
 100ee6c:	ja     100eeab <check_program+0x529b>
 100ee6e:	mov    0x328(%rsp),%r11
 100ee76:	mov    0x8(%rsp),%r12
 100ee7b:	add    %r8,%rdi
 100ee7e:	mov    %r15,0x28(%rsp)
 100ee83:	mov    %rbx,%r15
 100ee86:	mov    %rdi,0x8(%r11)
 100ee8a:	cmpq   $0x0,0x10(%rsp)
 100ee90:	mov    %r14,0x98(%rsp)
 100ee98:	mov    %r15,0xf0(%rsp)
 100eea0:	jne    1009e4f <check_program+0x23f>
 100eea6:	jmp    1009e65 <check_program+0x255>
 100eeab:	mov    0x8(%rsp),%r12
 100eeb0:	mov    %r15,0x28(%rsp)
 100eeb5:	mov    %rbx,%r15
 100eeb8:	mov    %r11,%rdi
 100eebb:	jmp    1009e34 <check_program+0x224>
 100eec0:	mov    %r15d,%ecx
 100eec3:	and    $0xfffffffe,%ecx
 100eec6:	xor    %edx,%edx
 100eec8:	jmp    100eedf <check_program+0x52cf>
 100eeca:	mov    0x60(%rsp),%r8
 100eecf:	or     %dil,(%r8,%rsi,1)
 100eed3:	inc    %rdx
 100eed6:	cmp    %rcx,%rdx
 100eed9:	je     100efc1 <check_program+0x53b1>
 100eedf:	mov    0x238(%rbp),%rsi
 100eee6:	mov    %rdx,%rax
 100eee9:	mov    (%rsi,%rax,4),%edx
 100eeec:	cmp    %rdx,%rax
 100eeef:	jne    100ef44 <check_program+0x5334>
 100eef1:	mov    0x268(%rbp),%rdx
 100eef8:	cmpb   $0x0,(%rdx,%rax,1)
 100eefc:	je     100ef44 <check_program+0x5334>
 100eefe:	mov    0x260(%rbp),%rdx
 100ef05:	mov    (%rdx,%rax,4),%edx
 100ef08:	lea    -0x1(%rdx),%esi
 100ef0b:	cmp    0x50(%rsp),%esi
 100ef0f:	jae    100ef44 <check_program+0x5334>
 100ef11:	mov    0x88(%r12),%rsi
 100ef19:	mov    %eax,(%rsi,%rdx,4)
 100ef1c:	mov    $0x1,%sil
 100ef1f:	mov    0x298(%rbp),%rdi
 100ef26:	cmpb   $0x0,(%rdi,%rax,1)
 100ef2a:	jne    100ef3b <check_program+0x532b>
 100ef2c:	mov    0x2a0(%rbp),%rsi
 100ef33:	cmpb   $0x0,(%rsi,%rax,1)
 100ef37:	setne  %sil
 100ef3b:	mov    0x60(%rsp),%rdi
 100ef40:	or     %sil,(%rdi,%rdx,1)
 100ef44:	mov    0x238(%rbp),%rdx
 100ef4b:	mov    0x4(%rdx,%rax,4),%esi
 100ef4f:	lea    0x1(%rax),%rdx
 100ef53:	cmp    %rsi,%rdx
 100ef56:	jne    100eed3 <check_program+0x52c3>
 100ef5c:	mov    0x268(%rbp),%rsi
 100ef63:	cmpb   $0x0,0x1(%rsi,%rax,1)
 100ef68:	je     100eed3 <check_program+0x52c3>
 100ef6e:	mov    0x260(%rbp),%rsi
 100ef75:	mov    0x4(%rsi,%rax,4),%esi
 100ef79:	lea    -0x1(%rsi),%edi
 100ef7c:	cmp    0x50(%rsp),%edi
 100ef80:	jae    100eed3 <check_program+0x52c3>
 100ef86:	mov    0x88(%r12),%rdi
 100ef8e:	lea    0x1(%rax),%r8d
 100ef92:	mov    %r8d,(%rdi,%rsi,4)
 100ef96:	mov    $0x1,%dil
 100ef99:	mov    0x298(%rbp),%r8
 100efa0:	cmpb   $0x0,0x1(%r8,%rax,1)
 100efa6:	jne    100eeca <check_program+0x52ba>
 100efac:	mov    0x2a0(%rbp),%rdi
 100efb3:	cmpb   $0x0,0x1(%rdi,%rax,1)
 100efb8:	setne  %dil
 100efbc:	jmp    100eeca <check_program+0x52ba>
 100efc1:	lea    0x300(%rsp),%rsi
 100efc9:	test   $0x1,%r15b
 100efcd:	je     100f03a <check_program+0x542a>
 100efcf:	add    $0x2,%rax
 100efd3:	mov    0x238(%rbp),%rcx
 100efda:	mov    (%rcx,%rax,4),%ecx
 100efdd:	cmp    %rcx,%rax
 100efe0:	jne    100f03a <check_program+0x542a>
 100efe2:	mov    0x268(%rbp),%rcx
 100efe9:	cmpb   $0x0,(%rcx,%rax,1)
 100efed:	je     100f03a <check_program+0x542a>
 100efef:	mov    0x260(%rbp),%rcx
 100eff6:	mov    (%rcx,%rax,4),%ecx
 100eff9:	lea    -0x1(%rcx),%edx
 100effc:	cmp    0x50(%rsp),%edx
 100f000:	jae    100f03a <check_program+0x542a>
 100f002:	mov    0x88(%r12),%rdx
 100f00a:	mov    %eax,(%rdx,%rcx,4)
 100f00d:	mov    $0x1,%dl
 100f00f:	mov    0x298(%rbp),%rsi
 100f016:	cmpb   $0x0,(%rsi,%rax,1)
 100f01a:	jne    100f02a <check_program+0x541a>
 100f01c:	mov    0x2a0(%rbp),%rdx
 100f023:	cmpb   $0x0,(%rdx,%rax,1)
 100f027:	setne  %dl
 100f02a:	mov    0x60(%rsp),%rax
 100f02f:	lea    0x300(%rsp),%rsi
 100f037:	or     %dl,(%rax,%rcx,1)
 100f03a:	mov    0x20(%rsi),%eax
 100f03d:	mov    0x50(%rsp),%r9
 100f042:	mov    0x60(%rsp),%r8
 100f047:	test   %eax,%eax
 100f049:	je     100f0b3 <check_program+0x54a3>
 100f04b:	xor    %ecx,%ecx
 100f04d:	jmp    100f065 <check_program+0x5455>
 100f04f:	nop
 100f050:	movb   $0x1,(%r8,%rdx,1)
 100f055:	mov    %rdi,%rsi
 100f058:	mov    0x20(%rdi),%eax
 100f05b:	inc    %rcx
 100f05e:	mov    %eax,%edx
 100f060:	cmp    %rdx,%rcx
 100f063:	jae    100f0b3 <check_program+0x54a3>
 100f065:	mov    0x18(%rsi),%rdx
 100f069:	mov    %rsi,%rdi
 100f06c:	mov    (%rdx,%rcx,4),%edx
 100f06f:	lea    -0x1(%rdx),%esi
 100f072:	cmp    %r9d,%esi
 100f075:	jb     100f050 <check_program+0x5440>
 100f077:	test   %rdx,%rdx
 100f07a:	je     100f0a9 <check_program+0x5499>
 100f07c:	cmpl   $0x0,0xbc(%r12)
 100f085:	lea    0x300(%rsp),%rsi
 100f08d:	jne    100f05b <check_program+0x544b>
 100f08f:	movl   $0x1,0xbc(%r12)
 100f09b:	movq   $0x0,0xb4(%r12)
 100f0a7:	jmp    100f05b <check_program+0x544b>
 100f0a9:	lea    0x300(%rsp),%rsi
 100f0b1:	jmp    100f05b <check_program+0x544b>
 100f0b3:	test   %r9d,%r9d
 100f0b6:	je     100f25c <check_program+0x564c>
 100f0bc:	mov    0xe4(%rsp),%eax
 100f0c3:	mov    $0x2,%esi
 100f0c8:	mov    $0x1,%ecx
 100f0cd:	cmp    $0x3,%eax
 100f0d0:	cmovae %eax,%esi
 100f0d3:	lea    -0x1(%rsi),%rdx
 100f0d7:	add    $0xfffffffe,%esi
 100f0da:	mov    %edx,%eax
 100f0dc:	and    $0x7,%eax
 100f0df:	cmp    $0x7,%esi
 100f0e2:	jb     100f226 <check_program+0x5616>
 100f0e8:	and    $0xfffffffffffffff8,%rdx
 100f0ec:	xor    %ecx,%ecx
 100f0ee:	jmp    100f0fd <check_program+0x54ed>
 100f0f0:	add    $0x8,%rcx
 100f0f4:	cmp    %rcx,%rdx
 100f0f7:	je     100f21e <check_program+0x560e>
 100f0fd:	cmpb   $0x0,0x1(%r8,%rcx,1)
 100f103:	je     100f120 <check_program+0x5510>
 100f105:	mov    0xb0(%r12),%esi
 100f10d:	inc    %esi
 100f10f:	mov    %esi,0xb0(%r12)
 100f117:	mov    0x78(%r12),%rdi
 100f11c:	mov    %esi,0x4(%rdi,%rcx,4)
 100f120:	cmpb   $0x0,0x2(%r8,%rcx,1)
 100f126:	je     100f143 <check_program+0x5533>
 100f128:	mov    0xb0(%r12),%esi
 100f130:	inc    %esi
 100f132:	mov    %esi,0xb0(%r12)
 100f13a:	mov    0x78(%r12),%rdi
 100f13f:	mov    %esi,0x8(%rdi,%rcx,4)
 100f143:	cmpb   $0x0,0x3(%r8,%rcx,1)
 100f149:	je     100f166 <check_program+0x5556>
 100f14b:	mov    0xb0(%r12),%esi
 100f153:	inc    %esi
 100f155:	mov    %esi,0xb0(%r12)
 100f15d:	mov    0x78(%r12),%rdi
 100f162:	mov    %esi,0xc(%rdi,%rcx,4)
 100f166:	cmpb   $0x0,0x4(%r8,%rcx,1)
 100f16c:	je     100f189 <check_program+0x5579>
 100f16e:	mov    0xb0(%r12),%esi
 100f176:	inc    %esi
 100f178:	mov    %esi,0xb0(%r12)
 100f180:	mov    0x78(%r12),%rdi
 100f185:	mov    %esi,0x10(%rdi,%rcx,4)
 100f189:	cmpb   $0x0,0x5(%r8,%rcx,1)
 100f18f:	je     100f1ac <check_program+0x559c>
 100f191:	mov    0xb0(%r12),%esi
 100f199:	inc    %esi
 100f19b:	mov    %esi,0xb0(%r12)
 100f1a3:	mov    0x78(%r12),%rdi
 100f1a8:	mov    %esi,0x14(%rdi,%rcx,4)
 100f1ac:	cmpb   $0x0,0x6(%r8,%rcx,1)
 100f1b2:	je     100f1cf <check_program+0x55bf>
 100f1b4:	mov    0xb0(%r12),%esi
 100f1bc:	inc    %esi
 100f1be:	mov    %esi,0xb0(%r12)
 100f1c6:	mov    0x78(%r12),%rdi
 100f1cb:	mov    %esi,0x18(%rdi,%rcx,4)
 100f1cf:	cmpb   $0x0,0x7(%r8,%rcx,1)
 100f1d5:	je     100f1f2 <check_program+0x55e2>
 100f1d7:	mov    0xb0(%r12),%esi
 100f1df:	inc    %esi
 100f1e1:	mov    %esi,0xb0(%r12)
 100f1e9:	mov    0x78(%r12),%rdi
 100f1ee:	mov    %esi,0x1c(%rdi,%rcx,4)
 100f1f2:	cmpb   $0x0,0x8(%r8,%rcx,1)
 100f1f8:	je     100f0f0 <check_program+0x54e0>
 100f1fe:	mov    0xb0(%r12),%esi
 100f206:	inc    %esi
 100f208:	mov    %esi,0xb0(%r12)
 100f210:	mov    0x78(%r12),%rdi
 100f215:	mov    %esi,0x20(%rdi,%rcx,4)
 100f219:	jmp    100f0f0 <check_program+0x54e0>
 100f21e:	test   %rax,%rax
 100f221:	je     100f25c <check_program+0x564c>
 100f223:	inc    %rcx
 100f226:	shl    $0x2,%eax
 100f229:	jmp    100f239 <check_program+0x5629>
 100f22b:	nopl   0x0(%rax,%rax,1)
 100f230:	inc    %rcx
 100f233:	add    $0xfffffffffffffffc,%rax
 100f237:	je     100f25c <check_program+0x564c>
 100f239:	cmpb   $0x0,(%r8,%rcx,1)
 100f23e:	je     100f230 <check_program+0x5620>
 100f240:	mov    0xb0(%r12),%edx
 100f248:	inc    %edx
 100f24a:	mov    %edx,0xb0(%r12)
 100f252:	mov    0x78(%r12),%rsi
 100f257:	mov    %edx,(%rsi,%rcx,4)
 100f25a:	jmp    100f230 <check_program+0x5620>
 100f25c:	mov    0xb0(%r12),%ecx
 100f264:	test   %rcx,%rcx
 100f267:	je     100f2b4 <check_program+0x56a4>
 100f269:	mov    0x38(%rsp),%r8
 100f26e:	mov    (%r8),%rsi
 100f271:	mov    0x8(%r8),%rdx
 100f275:	lea    0x3(%rdx,%rsi,1),%rax
 100f27a:	add    %rsi,%rdx
 100f27d:	and    $0xfffffffffffffffc,%rax
 100f281:	cmp    %rdx,%rax
 100f284:	jb     100f2ab <check_program+0x569b>
 100f286:	mov    %rax,%rdx
 100f289:	sub    %rsi,%rdx
 100f28c:	mov    0x10(%r8),%rsi
 100f290:	shl    $0x2,%rcx
 100f294:	sub    %rdx,%rsi
 100f297:	setb   %dil
 100f29b:	cmp    %rsi,%rcx
 100f29e:	seta   %sil
 100f2a2:	or     %dil,%sil
 100f2a5:	je     100fc4d <check_program+0x603d>
 100f2ab:	xor    %ecx,%ecx
 100f2ad:	xor    %eax,%eax
 100f2af:	jmp    100fc60 <check_program+0x6050>
 100f2b4:	xor    %eax,%eax
 100f2b6:	mov    $0x1,%cl
 100f2b8:	jmp    100fc60 <check_program+0x6050>
 100f2bd:	mov    %eax,%ebp
 100f2bf:	test   %dil,%dil
 100f2c2:	je     100f2d8 <check_program+0x56c8>
 100f2c4:	mov    0x48(%rsp),%rsi
 100f2c9:	mov    0x30(%rsp),%rbp
 100f2ce:	movl   $0xffffffff,-0x4(%rsi,%rdx,4)
 100f2d6:	jmp    100f328 <check_program+0x5718>
 100f2d8:	test   %bpl,%r9b
 100f2db:	mov    0x30(%rsp),%rbp
 100f2e0:	je     100f301 <check_program+0x56f1>
 100f2e2:	mov    0x98(%rsp),%r10
 100f2ea:	mov    %r8d,%esi
 100f2ed:	mov    0x48(%rsp),%r9
 100f2f2:	mov    (%r10,%rsi,4),%edi
 100f2f6:	mov    %edi,-0x4(%r9,%rdx,4)
 100f2fb:	mov    %ecx,(%r10,%rsi,4)
 100f2ff:	jmp    100f328 <check_program+0x5718>
 100f301:	cmpl   $0x0,0xbc(%r12)
 100f30a:	jne    100f328 <check_program+0x5718>
 100f30c:	movl   $0x1,0xbc(%r12)
 100f318:	mov    %esi,0xb4(%r12)
 100f320:	mov    %esi,0xb8(%r12)
 100f328:	lea    0x300(%rsp),%rsi
 100f330:	cmp    $0x1,%edx
 100f333:	jne    100f370 <check_program+0x5760>
 100f335:	test   %r15d,%r15d
 100f338:	je     100f7a1 <check_program+0x5b91>
 100f33e:	mov    %r15d,%eax
 100f341:	neg    %eax
 100f343:	jmp    100f619 <check_program+0x5a09>
 100f348:	mov    %eax,%ebp
 100f34a:	test   %dil,%dil
 100f34d:	je     100f577 <check_program+0x5967>
 100f353:	mov    0x48(%rsp),%rsi
 100f358:	mov    0x30(%rsp),%rbp
 100f35d:	movl   $0xffffffff,(%rsi,%rdx,4)
 100f364:	lea    0x300(%rsp),%rsi
 100f36c:	test   %ecx,%ecx
 100f36e:	je     100f335 <check_program+0x5725>
 100f370:	mov    (%rsi),%rsi
 100f373:	lea    -0x1(%rcx),%rdx
 100f377:	mov    0x8(%rsi),%rdi
 100f37b:	mov    %edx,%esi
 100f37d:	mov    (%rdi,%rsi,4),%edi
 100f380:	cmp    %r15d,%edi
 100f383:	jae    100f470 <check_program+0x5860>
 100f389:	mov    0x2b0(%rbp),%r9
 100f390:	mov    0x280(%rbp),%r8
 100f397:	mov    (%r9,%rdi,4),%r9d
 100f39b:	movzbl (%r8,%rdi,1),%r8d
 100f3a0:	dec    %r9d
 100f3a3:	cmp    %r15d,%r9d
 100f3a6:	setb   %r10b
 100f3aa:	test   %r8b,%r8b
 100f3ad:	jne    100f499 <check_program+0x5889>
 100f3b3:	cmp    %r15d,%r9d
 100f3b6:	jae    100f433 <check_program+0x5823>
 100f3b8:	mov    0x40(%rsp),%r10
 100f3bd:	mov    %r9d,%r11d
 100f3c0:	mov    %eax,%ebp
 100f3c2:	mov    0x50(%r10),%r14
 100f3c6:	mov    $0x1,%r10b
 100f3c9:	cmpb   $0x1e,(%r14,%r11,1)
 100f3ce:	je     100f49b <check_program+0x588b>
 100f3d4:	mov    0x40(%rsp),%r9
 100f3d9:	mov    $0x1,%r13d
 100f3df:	mov    0x60(%r9),%r9
 100f3e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100f3f0:	mov    (%r9,%r11,4),%r11d
 100f3f4:	cmp    %r15d,%r13d
 100f3f7:	setb   %bpl
 100f3fb:	cmp    %r15d,%r11d
 100f3fe:	setb   %r10b
 100f402:	jae    100f5e0 <check_program+0x59d0>
 100f408:	cmp    %r15d,%r13d
 100f40b:	jae    100f5e0 <check_program+0x59d0>
 100f411:	inc    %r13d
 100f414:	cmpb   $0x1e,(%r14,%r11,1)
 100f419:	jne    100f3f0 <check_program+0x57e0>
 100f41b:	mov    $0x1,%r10b
 100f41e:	mov    %r11d,%r9d
 100f421:	mov    $0x1,%bpl
 100f424:	mov    0x80(%rsp),%r13
 100f42c:	test   %r8b,%r8b
 100f42f:	jne    100f4a0 <check_program+0x5890>
 100f431:	jmp    100f43a <check_program+0x582a>
 100f433:	mov    %eax,%ebp
 100f435:	test   %r8b,%r8b
 100f438:	jne    100f4a0 <check_program+0x5890>
 100f43a:	and    %bpl,%r10b
 100f43d:	mov    0x30(%rsp),%rbp
 100f442:	mov    0x78(%rsp),%r14
 100f447:	cmp    $0x1,%r10b
 100f44b:	jne    100f470 <check_program+0x5860>
 100f44d:	mov    0x98(%rsp),%r11
 100f455:	mov    %r9d,%edi
 100f458:	mov    0x48(%rsp),%r10
 100f45d:	mov    (%r11,%rdi,4),%r8d
 100f461:	mov    %r8d,(%r10,%rsi,4)
 100f465:	mov    %edx,(%r11,%rdi,4)
 100f469:	jmp    100f4b6 <check_program+0x58a6>
 100f46b:	nopl   0x0(%rax,%rax,1)
 100f470:	cmpl   $0x0,0xbc(%r12)
 100f479:	jne    100f4b6 <check_program+0x58a6>
 100f47b:	movl   $0x1,0xbc(%r12)
 100f487:	mov    %edi,0xb4(%r12)
 100f48f:	mov    %edi,0xb8(%r12)
 100f497:	jmp    100f4b6 <check_program+0x58a6>
 100f499:	mov    %eax,%ebp
 100f49b:	test   %r8b,%r8b
 100f49e:	je     100f43a <check_program+0x582a>
 100f4a0:	mov    0x48(%rsp),%rdx
 100f4a5:	mov    0x30(%rsp),%rbp
 100f4aa:	mov    0x78(%rsp),%r14
 100f4af:	movl   $0xffffffff,(%rdx,%rsi,4)
 100f4b6:	lea    0x300(%rsp),%rdx
 100f4be:	add    $0xfffffffffffffffe,%rcx
 100f4c2:	mov    (%rdx),%rdx
 100f4c5:	mov    0x8(%rdx),%rsi
 100f4c9:	mov    %ecx,%edx
 100f4cb:	mov    (%rsi,%rdx,4),%esi
 100f4ce:	cmp    %r15d,%esi
 100f4d1:	jae    100f5b0 <check_program+0x59a0>
 100f4d7:	mov    0x2b0(%rbp),%r8
 100f4de:	mov    0x280(%rbp),%rdi
 100f4e5:	mov    (%r8,%rsi,4),%r8d
 100f4e9:	movzbl (%rdi,%rsi,1),%edi
 100f4ed:	dec    %r8d
 100f4f0:	cmp    %r15d,%r8d
 100f4f3:	setb   %r9b
 100f4f7:	test   %dil,%dil
 100f4fa:	jne    100f56c <check_program+0x595c>
 100f4fc:	cmp    %r15d,%r8d
 100f4ff:	jae    100f348 <check_program+0x5738>
 100f505:	mov    0x40(%rsp),%r9
 100f50a:	mov    %r8d,%r10d
 100f50d:	mov    %eax,%ebp
 100f50f:	mov    0x50(%r9),%r11
 100f513:	mov    $0x1,%r9b
 100f516:	cmpb   $0x1e,(%r11,%r10,1)
 100f51b:	je     100f56e <check_program+0x595e>
 100f51d:	mov    0x40(%rsp),%r8
 100f522:	mov    $0x1,%r14d
 100f528:	mov    0x60(%r8),%r8
 100f52c:	nopl   0x0(%rax)
 100f530:	mov    (%r8,%r10,4),%r10d
 100f534:	cmp    %r15d,%r14d
 100f537:	setb   %bpl
 100f53b:	cmp    %r15d,%r10d
 100f53e:	setb   %r9b
 100f542:	jae    100f559 <check_program+0x5949>
 100f544:	cmp    %r15d,%r14d
 100f547:	jae    100f559 <check_program+0x5949>
 100f549:	inc    %r14d
 100f54c:	cmpb   $0x1e,(%r11,%r10,1)
 100f551:	jne    100f530 <check_program+0x5920>
 100f553:	mov    $0x1,%r9b
 100f556:	mov    $0x1,%bpl
 100f559:	mov    %r10d,%r8d
 100f55c:	mov    0x78(%rsp),%r14
 100f561:	test   %dil,%dil
 100f564:	jne    100f353 <check_program+0x5743>
 100f56a:	jmp    100f577 <check_program+0x5967>
 100f56c:	mov    %eax,%ebp
 100f56e:	test   %dil,%dil
 100f571:	jne    100f353 <check_program+0x5743>
 100f577:	test   %bpl,%r9b
 100f57a:	mov    0x30(%rsp),%rbp
 100f57f:	je     100f5b0 <check_program+0x59a0>
 100f581:	mov    0x98(%rsp),%r10
 100f589:	mov    %r8d,%esi
 100f58c:	mov    0x48(%rsp),%r9
 100f591:	mov    (%r10,%rsi,4),%edi
 100f595:	mov    %edi,(%r9,%rdx,4)
 100f599:	mov    %ecx,(%r10,%rsi,4)
 100f59d:	jmp    100f364 <check_program+0x5754>
 100f5a2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100f5b0:	cmpl   $0x0,0xbc(%r12)
 100f5b9:	jne    100f364 <check_program+0x5754>
 100f5bf:	movl   $0x1,0xbc(%r12)
 100f5cb:	mov    %esi,0xb4(%r12)
 100f5d3:	mov    %esi,0xb8(%r12)
 100f5db:	jmp    100f364 <check_program+0x5754>
 100f5e0:	mov    %r11d,%r9d
 100f5e3:	mov    0x80(%rsp),%r13
 100f5eb:	test   %r8b,%r8b
 100f5ee:	jne    100f4a0 <check_program+0x5890>
 100f5f4:	jmp    100f43a <check_program+0x582a>
 100f5f9:	cmpl   $0x0,0xbc(%r12)
 100f602:	je     100f780 <check_program+0x5b70>
 100f608:	nopl   0x0(%rax,%rax,1)
 100f610:	test   %r14d,%r14d
 100f613:	je     100f7a1 <check_program+0x5b91>
 100f619:	mov    0x238(%rbp),%rsi
 100f620:	mov    %r14,%rcx
 100f623:	dec    %r14
 100f626:	mov    %r14d,%edx
 100f629:	cmp    %r14d,(%rsi,%rdx,4)
 100f62d:	jne    100f610 <check_program+0x5a00>
 100f62f:	mov    0x2e0(%rbp),%rsi
 100f636:	cmp    %r15d,(%rsi,%rdx,4)
 100f63a:	jae    100f610 <check_program+0x5a00>
 100f63c:	mov    0x248(%rbp),%rsi
 100f643:	cmpb   $0x1,(%rsi,%rdx,1)
 100f647:	jne    100f610 <check_program+0x5a00>
 100f649:	mov    0x268(%rbp),%rsi
 100f650:	cmpb   $0x0,(%rsi,%rdx,1)
 100f654:	jne    100f610 <check_program+0x5a00>
 100f656:	mov    0x240(%rbp),%rsi
 100f65d:	mov    (%rsi,%rdx,4),%edi
 100f660:	mov    (%rbx),%rsi
 100f663:	mov    %edi,%r8d
 100f666:	shr    $0x3,%r8d
 100f66a:	cmpb   $0xf,(%rsi,%r8,1)
 100f66f:	jne    100f686 <check_program+0x5a76>
 100f671:	mov    0x20(%rbx),%rdi
 100f675:	mov    (%rdi,%r8,4),%edi
 100f679:	jmp    100f686 <check_program+0x5a76>
 100f67b:	nopl   0x0(%rax,%rax,1)
 100f680:	cmp    $0xa,%r8b
 100f684:	je     100f6b8 <check_program+0x5aa8>
 100f686:	shr    $0x3,%edi
 100f689:	movzbl (%rsi,%rdi,1),%r8d
 100f68e:	lea    -0x8(%r8),%r9d
 100f692:	cmp    $0x2,%r9b
 100f696:	ja     100f610 <check_program+0x5a00>
 100f69c:	mov    0x20(%rbx),%r9
 100f6a0:	mov    (%r9,%rdi,4),%edi
 100f6a4:	mov    %edi,%r10d
 100f6a7:	shr    $0x3,%r10d
 100f6ab:	cmpb   $0xf,(%rsi,%r10,1)
 100f6b0:	jne    100f680 <check_program+0x5a70>
 100f6b2:	mov    (%r9,%r10,4),%edi
 100f6b6:	jmp    100f680 <check_program+0x5a70>
 100f6b8:	cmp    %r14d,%r15d
 100f6bb:	jbe    100f5f9 <check_program+0x59e9>
 100f6c1:	mov    0x40(%rsp),%rsi
 100f6c6:	mov    $0x1,%edi
 100f6cb:	mov    0x50(%rsi),%r8
 100f6cf:	mov    %r14d,%esi
 100f6d2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 100f6e0:	mov    %esi,%r9d
 100f6e3:	cmpb   $0x1e,(%r8,%r9,1)
 100f6e8:	je     100f717 <check_program+0x5b07>
 100f6ea:	mov    0x40(%rsp),%rsi
 100f6ef:	mov    0x60(%rsi),%rsi
 100f6f3:	mov    (%rsi,%r9,4),%esi
 100f6f7:	cmp    %r15d,%esi
 100f6fa:	jae    100f5f9 <check_program+0x59e9>
 100f700:	mov    %edi,%r9d
 100f703:	lea    0x1(%rax,%r9,1),%r9d
 100f708:	inc    %edi
 100f70a:	cmp    $0x1,%r9d
 100f70e:	jne    100f6e0 <check_program+0x5ad0>
 100f710:	mov    0xe4(%rsp),%edi
 100f717:	cmp    %r15d,%edi
 100f71a:	jae    100f5f9 <check_program+0x59e9>
 100f720:	mov    0x40(%rsp),%rdi
 100f725:	mov    %esi,%esi
 100f727:	mov    0x60(%rdi),%rdi
 100f72b:	cmp    %r15d,(%rdi,%rsi,4)
 100f72f:	jae    100f5f9 <check_program+0x59e9>
 100f735:	mov    0xf8(%rsp),%r8
 100f73d:	mov    0x120(%rsp),%r9
 100f745:	mov    (%r8,%rsi,4),%edi
 100f749:	mov    %edi,(%r9,%rdx,4)
 100f74d:	mov    0x40(%rsp),%r9
 100f752:	mov    %r14d,(%r8,%rsi,4)
 100f756:	mov    0xe8(%rsp),%r8
 100f75e:	mov    0xc8(%rsp),%rdi
 100f766:	mov    0x60(%r9),%rdx
 100f76a:	mov    (%rdx,%rsi,4),%edx
 100f76d:	mov    %ecx,(%r8,%rdx,4)
 100f771:	mov    0x60(%r9),%rdx
 100f775:	mov    (%rdx,%rsi,4),%edx
 100f778:	mov    %ecx,(%rdi,%rdx,4)
 100f77b:	jmp    100f610 <check_program+0x5a00>
 100f780:	movl   $0x1,0xbc(%r12)
 100f78c:	mov    %r14d,0xb4(%r12)
 100f794:	mov    %r14d,0xb8(%r12)
 100f79c:	jmp    100f610 <check_program+0x5a00>
 100f7a1:	mov    0x330(%rbp),%eax
 100f7a7:	mov    0x28(%rsp),%rbx
 100f7ac:	test   %rax,%rax
 100f7af:	je     100f914 <check_program+0x5d04>
 100f7b5:	mov    0x40(%rsp),%r11
 100f7ba:	jmp    100f7d8 <check_program+0x5bc8>
 100f7bc:	nopl   0x0(%rax)
 100f7c0:	cmpl   $0x0,0xbc(%r12)
 100f7c9:	je     100f839 <check_program+0x5c29>
 100f7cb:	nopl   0x0(%rax,%rax,1)
 100f7d0:	test   %eax,%eax
 100f7d2:	je     100f914 <check_program+0x5d04>
 100f7d8:	mov    0x328(%rbp),%rcx
 100f7df:	dec    %rax
 100f7e2:	mov    %eax,%edx
 100f7e4:	lea    (%rdx,%rdx,8),%rsi
 100f7e8:	cmpb   $0x1,0x20(%rcx,%rsi,4)
 100f7ed:	jne    100f7d0 <check_program+0x5bc0>
 100f7ef:	lea    (%rcx,%rsi,4),%rcx
 100f7f3:	mov    (%rcx),%esi
 100f7f5:	cmp    $0xffffffff,%esi
 100f7f8:	je     100f7d0 <check_program+0x5bc0>
 100f7fa:	mov    0x14(%rcx),%r8d
 100f7fe:	cmp    %r8d,0x18(%rcx)
 100f802:	cmove  %r8d,%esi
 100f806:	cmp    %r15d,%esi
 100f809:	jae    100f7c0 <check_program+0x5bb0>
 100f80b:	xor    %edi,%edi
 100f80d:	nopl   (%rax)
 100f810:	cmp    %r8d,%esi
 100f813:	je     100f85d <check_program+0x5c4d>
 100f815:	cmp    %edi,%r15d
 100f818:	je     100f86a <check_program+0x5c5a>
 100f81a:	mov    0x50(%r11),%r10
 100f81e:	mov    %esi,%r9d
 100f821:	cmpb   $0x1e,(%r10,%r9,1)
 100f826:	je     100f87c <check_program+0x5c6c>
 100f828:	mov    0x60(%r11),%rsi
 100f82c:	inc    %edi
 100f82e:	mov    (%rsi,%r9,4),%esi
 100f832:	cmp    %r15d,%esi
 100f835:	jb     100f810 <check_program+0x5c00>
 100f837:	jmp    100f7c0 <check_program+0x5bb0>
 100f839:	mov    0x8(%rcx),%ecx
 100f83c:	movl   $0x1,0xbc(%r12)
 100f848:	mov    %ecx,0xb4(%r12)
 100f850:	mov    %ecx,0xb8(%r12)
 100f858:	jmp    100f7d0 <check_program+0x5bc0>
 100f85d:	mov    %r8d,%esi
 100f860:	cmp    %r15d,%edi
 100f863:	jb     100f887 <check_program+0x5c77>
 100f865:	jmp    100f7c0 <check_program+0x5bb0>
 100f86a:	mov    0xe4(%rsp),%edi
 100f871:	cmp    %r15d,%edi
 100f874:	jae    100f7c0 <check_program+0x5bb0>
 100f87a:	jmp    100f887 <check_program+0x5c77>
 100f87c:	inc    %edi
 100f87e:	cmp    %r15d,%edi
 100f881:	jae    100f7c0 <check_program+0x5bb0>
 100f887:	mov    0x10(%rcx),%edi
 100f88a:	cmp    0x90(%rsp),%edi
 100f891:	jae    100f7c0 <check_program+0x5bb0>
 100f897:	mov    0x0(%rbp),%r8
 100f89b:	cmpl   $0x39,(%r8,%rdi,4)
 100f8a0:	jne    100f7c0 <check_program+0x5bb0>
 100f8a6:	mov    0x130(%rsp),%r8
 100f8ae:	mov    %esi,%esi
 100f8b0:	mov    0x150(%rsp),%r9
 100f8b8:	mov    (%r8,%rsi,4),%edi
 100f8bc:	mov    %edi,(%r9,%rdx,4)
 100f8c0:	mov    0x40(%rsp),%rdi
 100f8c5:	mov    %eax,(%r8,%rsi,4)
 100f8c9:	mov    0x60(%rdi),%rdx
 100f8cd:	mov    (%rdx,%rsi,4),%edx
 100f8d0:	cmp    %r15d,%edx
 100f8d3:	jae    100f7d0 <check_program+0x5bc0>
 100f8d9:	mov    (%rcx),%esi
 100f8db:	mov    0xe8(%rsp),%rdi
 100f8e3:	inc    %esi
 100f8e5:	cmp    %esi,(%rdi,%rdx,4)
 100f8e8:	jne    100f7d0 <check_program+0x5bc0>
 100f8ee:	mov    0xc(%rcx),%ecx
 100f8f1:	mov    0xc8(%rsp),%rsi
 100f8f9:	cmp    (%rsi,%rdx,4),%ecx
 100f8fc:	jb     100f7d0 <check_program+0x5bc0>
 100f902:	mov    0xc8(%rsp),%rsi
 100f90a:	inc    %ecx
 100f90c:	mov    %ecx,(%rsi,%rdx,4)
 100f90f:	jmp    100f7d0 <check_program+0x5bc0>
 100f914:	cmpl   $0x0,0x10(%rsp)
 100f919:	je     100f938 <check_program+0x5d28>
 100f91b:	mov    0x38(%rsp),%rsi
 100f920:	mov    (%rsi),%rcx
 100f923:	mov    0x8(%rsi),%rdx
 100f927:	lea    0x3(%rdx,%rcx,1),%rax
 100f92c:	add    %rcx,%rdx
 100f92f:	and    $0xfffffffffffffffc,%rax
 100f933:	cmp    %rdx,%rax
 100f936:	jae    100f999 <check_program+0x5d89>
 100f938:	xor    %ecx,%ecx
 100f93a:	mov    %rcx,0x40(%r12)
 100f93f:	mov    0x320(%rbp),%ecx
 100f945:	test   %rcx,%rcx
 100f948:	je     100f990 <check_program+0x5d80>
 100f94a:	mov    0x38(%rsp),%r8
 100f94f:	mov    (%r8),%rsi
 100f952:	mov    0x8(%r8),%rdx
 100f956:	lea    0x3(%rdx,%rsi,1),%rax
 100f95b:	add    %rsi,%rdx
 100f95e:	and    $0xfffffffffffffffc,%rax
 100f962:	cmp    %rdx,%rax
 100f965:	jb     100f98c <check_program+0x5d7c>
 100f967:	mov    %rax,%rdx
 100f96a:	sub    %rsi,%rdx
 100f96d:	mov    0x10(%r8),%rsi
 100f971:	shl    $0x2,%rcx
 100f975:	lea    (%rcx,%rcx,4),%rcx
 100f979:	sub    %rdx,%rsi
 100f97c:	setb   %dil
 100f980:	cmp    %rsi,%rcx
 100f983:	seta   %sil
 100f987:	or     %dil,%sil
 100f98a:	je     100f9d3 <check_program+0x5dc3>
 100f98c:	xor    %eax,%eax
 100f98e:	jmp    100f9da <check_program+0x5dca>
 100f990:	mov    0x38(%rsp),%rsi
 100f995:	xor    %eax,%eax
 100f997:	jmp    100f9dd <check_program+0x5dcd>
 100f999:	mov    0x10(%rsi),%rsi
 100f99d:	mov    %rax,%rdx
 100f9a0:	sub    %rcx,%rdx
 100f9a3:	xor    %ecx,%ecx
 100f9a5:	sub    %rdx,%rsi
 100f9a8:	jb     100f93a <check_program+0x5d2a>
 100f9aa:	mov    0x10(%rsp),%edi
 100f9ae:	shl    $0x2,%rdi
 100f9b2:	lea    (%rdi,%rdi,8),%rdi
 100f9b6:	cmp    %rsi,%rdi
 100f9b9:	ja     100f93a <check_program+0x5d2a>
 100f9bf:	mov    0x38(%rsp),%rcx
 100f9c4:	add    %rdi,%rdx
 100f9c7:	mov    %rdx,0x8(%rcx)
 100f9cb:	mov    %rax,%rcx
 100f9ce:	jmp    100f93a <check_program+0x5d2a>
 100f9d3:	add    %rcx,%rdx
 100f9d6:	mov    %rdx,0x8(%r8)
 100f9da:	mov    %r8,%rsi
 100f9dd:	mov    %rax,0x50(%r12)
 100f9e2:	mov    0x118(%rsp),%rdi
 100f9ea:	mov    0x320(%rbp),%eax
 100f9f0:	mov    %eax,0x9c(%r12)
 100f9f8:	mov    (%rsi),%rcx
 100f9fb:	mov    0x8(%rsi),%rdx
 100f9ff:	lea    0x3(%rdx,%rcx,1),%rax
 100fa04:	add    %rcx,%rdx
 100fa07:	and    $0xfffffffffffffffc,%rax
 100fa0b:	cmp    %rdx,%rax
 100fa0e:	jae    100fa14 <check_program+0x5e04>
 100fa10:	xor    %ecx,%ecx
 100fa12:	jmp    100fa39 <check_program+0x5e29>
 100fa14:	mov    0x10(%rsi),%rsi
 100fa18:	mov    %rax,%rdx
 100fa1b:	sub    %rcx,%rdx
 100fa1e:	xor    %ecx,%ecx
 100fa20:	sub    %rdx,%rsi
 100fa23:	jb     100fa39 <check_program+0x5e29>
 100fa25:	cmp    %rsi,%rdi
 100fa28:	ja     100fa39 <check_program+0x5e29>
 100fa2a:	mov    0x38(%rsp),%rcx
 100fa2f:	add    %rdi,%rdx
 100fa32:	mov    %rdx,0x8(%rcx)
 100fa36:	mov    %rax,%rcx
 100fa39:	mov    0x38(%rsp),%rsi
 100fa3e:	mov    %rcx,0x78(%r12)
 100fa43:	mov    (%rsi),%rcx
 100fa46:	mov    0x8(%rsi),%rdx
 100fa4a:	lea    0x3(%rdx,%rcx,1),%rax
 100fa4f:	add    %rcx,%rdx
 100fa52:	and    $0xfffffffffffffffc,%rax
 100fa56:	cmp    %rdx,%rax
 100fa59:	jae    100fa5f <check_program+0x5e4f>
 100fa5b:	xor    %ecx,%ecx
 100fa5d:	jmp    100fa84 <check_program+0x5e74>
 100fa5f:	mov    0x10(%rsi),%rsi
 100fa63:	mov    %rax,%rdx
 100fa66:	sub    %rcx,%rdx
 100fa69:	xor    %ecx,%ecx
 100fa6b:	sub    %rdx,%rsi
 100fa6e:	jb     100fa84 <check_program+0x5e74>
 100fa70:	cmp    %rsi,%rdi
 100fa73:	ja     100fa84 <check_program+0x5e74>
 100fa75:	mov    0x38(%rsp),%rcx
 100fa7a:	add    %rdi,%rdx
 100fa7d:	mov    %rdx,0x8(%rcx)
 100fa81:	mov    %rax,%rcx
 100fa84:	mov    %rcx,0x88(%r12)
 100fa8c:	mov    0x340(%rbp),%edx
 100fa92:	test   %rdx,%rdx
 100fa95:	je     100fab8 <check_program+0x5ea8>
 100fa97:	mov    0x38(%rsp),%rdi
 100fa9c:	mov    (%rdi),%rcx
 100fa9f:	mov    0x8(%rdi),%rsi
 100faa3:	lea    0x3(%rsi,%rcx,1),%rax
 100faa8:	add    %rcx,%rsi
 100faab:	and    $0xfffffffffffffffc,%rax
 100faaf:	cmp    %rsi,%rax
 100fab2:	jae    100fbd9 <check_program+0x5fc9>
 100fab8:	xor    %ecx,%ecx
 100faba:	mov    %rcx,0x68(%r12)
 100fabf:	xor    %eax,%eax
 100fac1:	mov    0x340(%rbp),%ecx
 100fac7:	test   %rcx,%rcx
 100faca:	je     100fb23 <check_program+0x5f13>
 100facc:	xor    %edx,%edx
 100face:	xor    %esi,%esi
 100fad0:	mov    0x68(%r12),%rcx
 100fad5:	test   %rcx,%rcx
 100fad8:	je     100aca6 <check_program+0x1096>
 100fade:	mov    %rax,%rdi
 100fae1:	shr    $0x20,%rdi
 100fae5:	jne    100aca6 <check_program+0x1096>
 100faeb:	mov    %eax,(%rcx,%rsi,4)
 100faee:	inc    %rsi
 100faf1:	mov    0x338(%rbp),%rcx
 100faf8:	mov    0x34(%rcx,%rdx,1),%ecx
 100fafc:	add    $0x50,%rdx
 100fb00:	add    %rcx,%rax
 100fb03:	mov    0x340(%rbp),%ecx
 100fb09:	cmp    %rcx,%rsi
 100fb0c:	jb     100fad0 <check_program+0x5ec0>
 100fb0e:	test   %rcx,%rcx
 100fb11:	sete   %dl
 100fb14:	mov    %rax,%rsi
 100fb17:	shr    $0x20,%rsi
 100fb1b:	jne    100aca6 <check_program+0x1096>
 100fb21:	jmp    100fb32 <check_program+0x5f22>
 100fb23:	mov    $0x1,%dl
 100fb25:	mov    %rax,%rsi
 100fb28:	shr    $0x20,%rsi
 100fb2c:	jne    100aca6 <check_program+0x1096>
 100fb32:	test   %dl,%dl
 100fb34:	jne    100fb3e <check_program+0x5f2e>
 100fb36:	mov    0x68(%r12),%rdx
 100fb3b:	mov    %eax,(%rdx,%rcx,4)
 100fb3e:	mov    %eax,0xa8(%r12)
 100fb46:	test   %rax,%rax
 100fb49:	je     100fb6c <check_program+0x5f5c>
 100fb4b:	mov    0x38(%rsp),%rdi
 100fb50:	mov    (%rdi),%rcx
 100fb53:	mov    0x8(%rdi),%rsi
 100fb57:	lea    0x3(%rsi,%rcx,1),%rdx
 100fb5c:	add    %rcx,%rsi
 100fb5f:	and    $0xfffffffffffffffc,%rdx
 100fb63:	cmp    %rsi,%rdx
 100fb66:	jae    100fc13 <check_program+0x6003>
 100fb6c:	xor    %ecx,%ecx
 100fb6e:	cmpl   $0x0,0x10(%rsp)
 100fb73:	mov    0xd0(%rsp),%rdx
 100fb7b:	mov    %rcx,0x70(%r12)
 100fb80:	je     100fb8e <check_program+0x5f7e>
 100fb82:	cmpq   $0x0,0x40(%r12)
 100fb88:	je     100acc3 <check_program+0x10b3>
 100fb8e:	cmpl   $0x0,0x320(%rbp)
 100fb95:	je     100fba3 <check_program+0x5f93>
 100fb97:	cmpq   $0x0,0x50(%r12)
 100fb9d:	je     100acc3 <check_program+0x10b3>
 100fba3:	cmpq   $0x0,0x78(%r12)
 100fba9:	je     100acc3 <check_program+0x10b3>
 100fbaf:	test   %rax,%rax
 100fbb2:	sete   %al
 100fbb5:	test   %rcx,%rcx
 100fbb8:	setne  %cl
 100fbbb:	cmpq   $0x0,0x88(%r12)
 100fbc4:	je     100acc3 <check_program+0x10b3>
 100fbca:	or     %cl,%al
 100fbcc:	mov    $0x1,%cl
 100fbce:	jne    100acdc <check_program+0x10cc>
 100fbd4:	jmp    100acc3 <check_program+0x10b3>
 100fbd9:	mov    0x10(%rdi),%rdi
 100fbdd:	mov    %rax,%rsi
 100fbe0:	sub    %rcx,%rsi
 100fbe3:	xor    %ecx,%ecx
 100fbe5:	sub    %rsi,%rdi
 100fbe8:	jb     100faba <check_program+0x5eaa>
 100fbee:	lea    0x4(,%rdx,4),%rdx
 100fbf6:	cmp    %rdi,%rdx
 100fbf9:	ja     100faba <check_program+0x5eaa>
 100fbff:	mov    0x38(%rsp),%rcx
 100fc04:	add    %rdx,%rsi
 100fc07:	mov    %rsi,0x8(%rcx)
 100fc0b:	mov    %rax,%rcx
 100fc0e:	jmp    100faba <check_program+0x5eaa>
 100fc13:	mov    0x10(%rdi),%r8
 100fc17:	mov    %rdx,%rsi
 100fc1a:	sub    %rcx,%rsi
 100fc1d:	xor    %ecx,%ecx
 100fc1f:	sub    %rsi,%r8
 100fc22:	jb     100fb6e <check_program+0x5f5e>
 100fc28:	lea    0x0(,%rax,4),%rdi
 100fc30:	cmp    %r8,%rdi
 100fc33:	ja     100fb6e <check_program+0x5f5e>
 100fc39:	mov    0x38(%rsp),%rcx
 100fc3e:	add    %rdi,%rsi
 100fc41:	mov    %rsi,0x8(%rcx)
 100fc45:	mov    %rdx,%rcx
 100fc48:	jmp    100fb6e <check_program+0x5f5e>
 100fc4d:	add    %rcx,%rdx
 100fc50:	mov    %rdx,0x8(%r8)
 100fc54:	cmpl   $0x0,0xb0(%r12)
 100fc5d:	sete   %cl
 100fc60:	test   %r9d,%r9d
 100fc63:	mov    %rax,0x80(%r12)
 100fc6b:	sete   %dl
 100fc6e:	test   %rax,%rax
 100fc71:	setne  %al
 100fc74:	or     %cl,%al
 100fc76:	mov    %eax,%ecx
 100fc78:	not    %cl
 100fc7a:	or     %dl,%cl
 100fc7c:	test   $0x1,%cl
 100fc7f:	jne    100fe04 <check_program+0x61f4>
 100fc85:	mov    0xe4(%rsp),%ecx
 100fc8c:	mov    $0x2,%edi
 100fc91:	mov    $0x1,%edx
 100fc96:	cmp    $0x3,%ecx
 100fc99:	cmovae %ecx,%edi
 100fc9c:	lea    -0x1(%rdi),%rsi
 100fca0:	add    $0xfffffffe,%edi
 100fca3:	mov    %esi,%ecx
 100fca5:	and    $0x7,%ecx
 100fca8:	cmp    $0x7,%edi
 100fcab:	jb     100fdd6 <check_program+0x61c6>
 100fcb1:	and    $0xfffffffffffffff8,%rsi
 100fcb5:	xor    %edx,%edx
 100fcb7:	jmp    100fccd <check_program+0x60bd>
 100fcb9:	nopl   0x0(%rax)
 100fcc0:	add    $0x8,%rdx
 100fcc4:	cmp    %rdx,%rsi
 100fcc7:	je     100fdce <check_program+0x61be>
 100fccd:	mov    0x78(%r12),%rdi
 100fcd2:	mov    0x4(%rdi,%rdx,4),%edi
 100fcd6:	test   %edi,%edi
 100fcd8:	je     100fcec <check_program+0x60dc>
 100fcda:	mov    0x80(%r12),%r8
 100fce2:	dec    %edi
 100fce4:	lea    0x1(%rdx),%r9d
 100fce8:	mov    %r9d,(%r8,%rdi,4)
 100fcec:	mov    0x78(%r12),%rdi
 100fcf1:	mov    0x8(%rdi,%rdx,4),%edi
 100fcf5:	test   %edi,%edi
 100fcf7:	je     100fd0b <check_program+0x60fb>
 100fcf9:	mov    0x80(%r12),%r8
 100fd01:	dec    %edi
 100fd03:	lea    0x2(%rdx),%r9d
 100fd07:	mov    %r9d,(%r8,%rdi,4)
 100fd0b:	mov    0x78(%r12),%rdi
 100fd10:	mov    0xc(%rdi,%rdx,4),%edi
 100fd14:	test   %edi,%edi
 100fd16:	je     100fd2a <check_program+0x611a>
 100fd18:	mov    0x80(%r12),%r8
 100fd20:	dec    %edi
 100fd22:	lea    0x3(%rdx),%r9d
 100fd26:	mov    %r9d,(%r8,%rdi,4)
 100fd2a:	mov    0x78(%r12),%rdi
 100fd2f:	mov    0x10(%rdi,%rdx,4),%edi
 100fd33:	test   %edi,%edi
 100fd35:	je     100fd49 <check_program+0x6139>
 100fd37:	mov    0x80(%r12),%r8
 100fd3f:	dec    %edi
 100fd41:	lea    0x4(%rdx),%r9d
 100fd45:	mov    %r9d,(%r8,%rdi,4)
 100fd49:	mov    0x78(%r12),%rdi
 100fd4e:	mov    0x14(%rdi,%rdx,4),%edi
 100fd52:	test   %edi,%edi
 100fd54:	je     100fd68 <check_program+0x6158>
 100fd56:	mov    0x80(%r12),%r8
 100fd5e:	dec    %edi
 100fd60:	lea    0x5(%rdx),%r9d
 100fd64:	mov    %r9d,(%r8,%rdi,4)
 100fd68:	mov    0x78(%r12),%rdi
 100fd6d:	mov    0x18(%rdi,%rdx,4),%edi
 100fd71:	test   %edi,%edi
 100fd73:	je     100fd87 <check_program+0x6177>
 100fd75:	mov    0x80(%r12),%r8
 100fd7d:	dec    %edi
 100fd7f:	lea    0x6(%rdx),%r9d
 100fd83:	mov    %r9d,(%r8,%rdi,4)
 100fd87:	mov    0x78(%r12),%rdi
 100fd8c:	mov    0x1c(%rdi,%rdx,4),%edi
 100fd90:	test   %edi,%edi
 100fd92:	je     100fda6 <check_program+0x6196>
 100fd94:	mov    0x80(%r12),%r8
 100fd9c:	dec    %edi
 100fd9e:	lea    0x7(%rdx),%r9d
 100fda2:	mov    %r9d,(%r8,%rdi,4)
 100fda6:	mov    0x78(%r12),%rdi
 100fdab:	mov    0x20(%rdi,%rdx,4),%edi
 100fdaf:	test   %edi,%edi
 100fdb1:	je     100fcc0 <check_program+0x60b0>
 100fdb7:	mov    0x80(%r12),%r8
 100fdbf:	dec    %edi
 100fdc1:	lea    0x8(%rdx),%r9d
 100fdc5:	mov    %r9d,(%r8,%rdi,4)
 100fdc9:	jmp    100fcc0 <check_program+0x60b0>
 100fdce:	test   %rcx,%rcx
 100fdd1:	je     100fe04 <check_program+0x61f4>
 100fdd3:	inc    %rdx
 100fdd6:	shl    $0x2,%ecx
 100fdd9:	jmp    100fde9 <check_program+0x61d9>
 100fddb:	nopl   0x0(%rax,%rax,1)
 100fde0:	inc    %rdx
 100fde3:	add    $0xfffffffffffffffc,%rcx
 100fde7:	je     100fe04 <check_program+0x61f4>
 100fde9:	mov    0x78(%r12),%rsi
 100fdee:	mov    (%rsi,%rdx,4),%esi
 100fdf1:	test   %esi,%esi
 100fdf3:	je     100fde0 <check_program+0x61d0>
 100fdf5:	mov    0x80(%r12),%rdi
 100fdfd:	dec    %esi
 100fdff:	mov    %edx,(%rdi,%rsi,4)
 100fe02:	jmp    100fde0 <check_program+0x61d0>
 100fe04:	test   $0x1,%al
 100fe06:	je     100d322 <check_program+0x3712>
 100fe0c:	cmpl   $0x0,0xbc(%r12)
 100fe15:	jne    100d322 <check_program+0x3712>
 100fe1b:	mov    0x38(%rsp),%rax
 100fe20:	mov    0x8(%rax),%rax
 100fe24:	sub    0x178(%rsp),%rax
 100fe2c:	mov    %rax,(%r14)
 100fe2f:	mov    $0x1,%al
 100fe31:	mov    0x328(%rsp),%rcx
 100fe39:	mov    0x170(%rsp),%rdx
 100fe41:	cmp    0x8(%rcx),%rdx
 100fe45:	jbe    100d436 <check_program+0x3826>
 100fe4b:	lea    -0x917e22(%rip),%rdi        # 6f8030 <pp_string_value.meaning+0x6faaf>
 100fe52:	lea    -0x95eb70(%rip),%rsi        # 6b12e9 <pp_string_value.meaning+0x28d68>
 100fe59:	lea    -0x95eb5c(%rip),%rcx        # 6b1304 <pp_string_value.meaning+0x28d83>
 100fe60:	mov    $0xbd,%edx
 100fe65:	vzeroupper
 100fe68:	call   787950 <__assert_fail@plt>
 100fe6d:	lea    0x300(%rsp),%rdx
 100fe75:	test   %r13,%r13
 100fe78:	je     100fe8f <check_program+0x627f>
 100fe7a:	cmpl   $0x0,0x2c(%r13)
 100fe7f:	jne    1009d52 <check_program+0x142>
 100fe85:	cmp    %eax,0x1c(%r13)
 100fe89:	jne    1009d52 <check_program+0x142>
 100fe8f:	cmpl   $0x0,0x340(%rbp)
 100fe96:	je     100feac <check_program+0x629c>
 100fe98:	test   %r10,%r10
 100fe9b:	je     1009d52 <check_program+0x142>
 100fea1:	cmpl   $0x0,0x10(%r10)
 100fea6:	jne    1009d52 <check_program+0x142>
 100feac:	cmpl   $0x0,0x20(%rdx)
 100feb0:	sete   %cl
 100feb3:	cmpq   $0x0,0x18(%rdx)
 100feb8:	setne  %r14b
 100febc:	or     %cl,%r14b
 100febf:	jmp    1009d55 <check_program+0x145>
 100fec4:	vzeroupper
 100fec7:	call   7878e0 <__stack_chk_fail@plt>
