
../campaign/native-images/head449/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001082cf0 <check_input_resolve_range>:
 1082cf0:	push   %rbp
 1082cf1:	push   %r15
 1082cf3:	push   %r14
 1082cf5:	push   %r13
 1082cf7:	push   %r12
 1082cf9:	push   %rbx
 1082cfa:	sub    $0x238,%rsp
 1082d01:	mov    %fs:0x28,%rax
 1082d0a:	mov    %rax,0x230(%rsp)
 1082d12:	mov    %edx,0xbc(%rsp)
 1082d19:	mov    %esi,0xb8(%rsp)
 1082d20:	cmp    %edx,%esi
 1082d22:	jbe    1082d50 <check_input_resolve_range+0x60>
 1082d24:	mov    %fs:0x28,%rax
 1082d2d:	cmp    0x230(%rsp),%rax
 1082d35:	jne    1089122 <check_input_resolve_range+0x6432>
 1082d3b:	add    $0x238,%rsp
 1082d42:	pop    %rbx
 1082d43:	pop    %r12
 1082d45:	pop    %r13
 1082d47:	pop    %r14
 1082d49:	pop    %r15
 1082d4b:	pop    %rbp
 1082d4c:	vzeroupper
 1082d4f:	ret
 1082d50:	vpbroadcastq -0xad670a(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1082d5a:	vpbroadcastd -0xad6f23(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1082d63:	vpbroadcastq -0xad670d(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1082d6d:	vpbroadcastd -0xad6f37(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1082d77:	vpbroadcastq -0xad6729(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1082d81:	lea    0x40(%rdi),%rax
 1082d85:	mov    0x8(%rdi),%r12
 1082d89:	mov    %rdi,%rbx
 1082d8c:	mov    %rdi,0x8(%rsp)
 1082d91:	mov    %rax,0x118(%rsp)
 1082d99:	mov    0xb8(%rsp),%eax
 1082da0:	mov    %r12,0x48(%rsp)
 1082da5:	mov    %eax,%r13d
 1082da8:	jmp    1082de6 <check_input_resolve_range+0xf6>
 1082daa:	movb   $0x1,0x3c5(%rax)
 1082db1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082dc0:	mov    0x138(%rbx),%rax
 1082dc7:	cmpb   $0x0,(%rax,%rbp,1)
 1082dcb:	je     10832ba <check_input_resolve_range+0x5ca>
 1082dd1:	mov    (%rsp),%r13
 1082dd5:	inc    %r13d
 1082dd8:	cmp    0xbc(%rsp),%r13d
 1082de0:	ja     1082d24 <check_input_resolve_range+0x34>
 1082de6:	mov    (%rbx),%rax
 1082de9:	cmpl   $0x0,0x230(%rax)
 1082df0:	jne    1082d24 <check_input_resolve_range+0x34>
 1082df6:	cmpb   $0x0,0x3c5(%rax)
 1082dfd:	jne    1082d24 <check_input_resolve_range+0x34>
 1082e03:	cmp    0x3c0(%rbx),%r13d
 1082e0a:	je     1088fd3 <check_input_resolve_range+0x62e3>
 1082e10:	mov    %r13d,0x42c(%rbx)
 1082e17:	mov    0x18(%rbx),%rax
 1082e1b:	mov    0x108(%rax),%rax
 1082e22:	test   %rax,%rax
 1082e25:	je     1082e38 <check_input_resolve_range+0x148>
 1082e27:	cmp    %r13d,0x30(%rax)
 1082e2b:	je     1082e38 <check_input_resolve_range+0x148>
 1082e2d:	mov    %r13d,0x30(%rax)
 1082e31:	movl   $0x0,0x34(%rax)
 1082e38:	cmpb   $0x1,0x458(%rbx)
 1082e3f:	mov    %r13d,%eax
 1082e42:	mov    %rax,0x28(%rsp)
 1082e47:	mov    %r13,(%rsp)
 1082e4b:	jne    1082e69 <check_input_resolve_range+0x179>
 1082e4d:	cmp    0xb8(%rsp),%r13d
 1082e55:	je     1083390 <check_input_resolve_range+0x6a0>
 1082e5b:	cmp    0xbc(%rsp),%r13d
 1082e63:	je     1083390 <check_input_resolve_range+0x6a0>
 1082e69:	mov    0x158(%rbx),%rax
 1082e70:	mov    0x28(%rsp),%rcx
 1082e75:	mov    (%rax,%rcx,4),%eax
 1082e78:	cmp    $0xffffffff,%eax
 1082e7b:	jne    1082ea8 <check_input_resolve_range+0x1b8>
 1082e7d:	jmp    1083390 <check_input_resolve_range+0x6a0>
 1082e82:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082e90:	mov    0x160(%rbx),%rax
 1082e97:	mov    (%rsp),%r13
 1082e9b:	mov    (%rax,%r15,4),%eax
 1082e9f:	cmp    $0xffffffff,%eax
 1082ea2:	je     1083390 <check_input_resolve_range+0x6a0>
 1082ea8:	mov    (%rbx),%rcx
 1082eab:	mov    %eax,%r15d
 1082eae:	mov    0x2b0(%rcx),%rdx
 1082eb5:	mov    0x280(%rcx),%rsi
 1082ebc:	mov    0x2b8(%rcx),%rcx
 1082ec3:	mov    (%rdx,%r15,4),%edx
 1082ec7:	cmpb   $0x0,(%rsi,%r15,1)
 1082ecc:	mov    (%rcx,%r15,4),%ecx
 1082ed0:	lea    -0x1(%rdx),%ebp
 1082ed3:	cmovne %eax,%ebp
 1082ed6:	cmp    %ecx,%edx
 1082ed8:	jae    1083340 <check_input_resolve_range+0x650>
 1082ede:	mov    0x8(%rbx),%r12
 1082ee2:	cmp    0x30(%r12),%ecx
 1082ee7:	ja     1083340 <check_input_resolve_range+0x650>
 1082eed:	mov    0xa0(%rbx),%rax
 1082ef4:	mov    0x18(%rbx),%rdi
 1082ef8:	mov    (%rax,%r15,4),%r11d
 1082efc:	mov    (%rdi),%rax
 1082eff:	mov    %r11d,%r13d
 1082f02:	shr    $0x3,%r13d
 1082f06:	cmpb   $0x9,(%rax,%r13,1)
 1082f0b:	jne    1082e90 <check_input_resolve_range+0x1a0>
 1082f0d:	mov    0x50(%r12),%rsi
 1082f12:	mov    0x20(%rdi),%rdi
 1082f16:	movzbl (%rsi,%rdx,1),%esi
 1082f1a:	mov    (%rdi,%r13,4),%r14d
 1082f1e:	add    $0xc9,%sil
 1082f22:	mov    %r14d,%r8d
 1082f25:	cmp    $0x2,%sil
 1082f29:	mov    %rdx,%rsi
 1082f2c:	adc    $0x0,%rsi
 1082f30:	shr    $0x3,%r8d
 1082f34:	cmpb   $0xf,(%rax,%r8,1)
 1082f39:	jne    1082f3f <check_input_resolve_range+0x24f>
 1082f3b:	mov    (%rdi,%r8,4),%r14d
 1082f3f:	cmp    %ecx,%esi
 1082f41:	jae    10830f0 <check_input_resolve_range+0x400>
 1082f47:	mov    0x10(%r12),%rax
 1082f4c:	cmpb   $0x5,(%rax,%rsi,1)
 1082f50:	jne    10830f0 <check_input_resolve_range+0x400>
 1082f56:	mov    %rbx,%rdi
 1082f59:	mov    %rdx,0x30(%rsp)
 1082f5e:	mov    %ecx,%ebx
 1082f60:	mov    %r11,0x60(%rsp)
 1082f65:	vzeroupper
 1082f68:	call   10a1740 <check_input_string>
 1082f6d:	vpbroadcastq -0xad691f(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1082f77:	vpbroadcastd -0xad7141(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1082f81:	vpbroadcastq -0xad692b(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1082f8b:	vpbroadcastd -0xad7154(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1082f94:	vpbroadcastq -0xad694e(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1082f9e:	mov    %ebx,%ecx
 1082fa0:	mov    0x60(%rsp),%r11
 1082fa5:	mov    0x8(%rsp),%rbx
 1082faa:	mov    0x30(%rsp),%rdx
 1082faf:	test   %rax,%rax
 1082fb2:	je     10830f0 <check_input_resolve_range+0x400>
 1082fb8:	mov    0x18(%rbx),%rdi
 1082fbc:	mov    0x8(%rax),%r9d
 1082fc0:	and    $0xfffffff8,%r14d
 1082fc4:	mov    (%rdi),%rsi
 1082fc7:	mov    %r9d,%r10d
 1082fca:	shr    $0x3,%r10d
 1082fce:	mov    0x20(%rdi),%r8
 1082fd2:	and    $0x7,%r9d
 1082fd6:	movzbl (%rsi,%r10,1),%esi
 1082fdb:	add    $0xf8,%sil
 1082fdf:	cmp    $0x3,%sil
 1082fe3:	mov    $0x0,%esi
 1082fe8:	cmovae %esi,%r9d
 1082fec:	or     (%r8,%r10,4),%r9d
 1082ff0:	cmp    $0x29,%r14d
 1082ff4:	setae  %sil
 1082ff8:	cmp    $0x18,%r9d
 1082ffc:	setne  %r8b
 1083000:	cmp    %r9d,%r14d
 1083003:	je     1083024 <check_input_resolve_range+0x334>
 1083005:	movabs $0xfefeffffff,%r9
 108300f:	shrx   %r14,%r9,%r9
 1083014:	or     %r9b,%sil
 1083017:	or     %r8b,%sil
 108301a:	test   $0x1,%sil
 108301e:	jne    10830f4 <check_input_resolve_range+0x404>
 1083024:	mov    (%rdi),%rcx
 1083027:	mov    0x20(%rdi),%rdx
 108302b:	movzbl (%rcx,%r13,1),%esi
 1083030:	mov    (%rdx,%r13,4),%ebx
 1083034:	mov    $0x0,%edx
 1083039:	add    $0xf8,%sil
 108303d:	cmp    $0x3,%sil
 1083041:	cmovae %edx,%r11d
 1083045:	mov    %ebx,%edx
 1083047:	shr    $0x3,%edx
 108304a:	je     10840a6 <check_input_resolve_range+0x13b6>
 1083050:	cmp    0x48(%rdi),%edx
 1083053:	jae    10840a6 <check_input_resolve_range+0x13b6>
 1083059:	cmpb   $0x0,(%rcx,%rdx,1)
 108305d:	je     10840a6 <check_input_resolve_range+0x13b6>
 1083063:	mov    0x8(%rax),%eax
 1083066:	mov    0x30(%rdi),%rcx
 108306a:	mov    $0x8,%esi
 108306f:	mov    %r11,%r14
 1083072:	xor    %edx,%edx
 1083074:	xor    %r9d,%r9d
 1083077:	and    $0xfffffff8,%eax
 108307a:	mov    (%rcx,%rax,1),%r8
 108307e:	mov    %ebx,%ecx
 1083080:	and    $0xfffffff8,%ecx
 1083083:	vzeroupper
 1083086:	call   10a1f30 <type_find_or_add>
 108308b:	vpbroadcastq -0xad6a3d(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1083095:	vpbroadcastd -0xad725f(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 108309f:	vpbroadcastq -0xad6a49(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 10830a9:	vpbroadcastd -0xad7272(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10830b2:	vpbroadcastq -0xad6a6c(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 10830bc:	mov    0x8(%rsp),%r8
 10830c1:	test   %eax,%eax
 10830c3:	je     10840d7 <check_input_resolve_range+0x13e7>
 10830c9:	or     %ebx,%r14d
 10830cc:	and    $0x7,%r14d
 10830d0:	lea    (%r14,%rax,8),%ecx
 10830d4:	test   %ecx,%ecx
 10830d6:	jne    1083276 <check_input_resolve_range+0x586>
 10830dc:	jmp    10840d7 <check_input_resolve_range+0x13e7>
 10830e1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10830f0:	mov    0x18(%rbx),%rdi
 10830f4:	vmovdqu 0x180(%rbx),%xmm0
 10830fc:	mov    0x28(%rbx),%r14
 1083100:	mov    0xa0(%rbx),%rax
 1083107:	vpxor  %xmm1,%xmm1,%xmm1
 108310b:	vmovdqu %ymm1,0x200(%rsp)
 1083114:	vmovdqu %ymm1,0x210(%rsp)
 108311d:	mov    %r11d,0x200(%rsp)
 1083125:	movl   $0xffffffff,0x220(%rsp)
 1083130:	test   %r14,%r14
 1083133:	je     10832e5 <check_input_resolve_range+0x5f5>
 1083139:	mov    0x8(%r14),%rbx
 108313d:	test   %r13d,%r13d
 1083140:	je     10832e1 <check_input_resolve_range+0x5f1>
 1083146:	test   %rdi,%rdi
 1083149:	je     10832e1 <check_input_resolve_range+0x5f1>
 108314f:	cmp    0x48(%rdi),%r13d
 1083153:	jae    10832e1 <check_input_resolve_range+0x5f1>
 1083159:	mov    (%rdi),%rsi
 108315c:	cmpb   $0x0,(%rsi,%r13,1)
 1083161:	je     10832e1 <check_input_resolve_range+0x5f1>
 1083167:	xor    %esi,%esi
 1083169:	cmp    0x30(%r12),%ecx
 108316e:	seta   %sil
 1083172:	mov    %esi,0x21c(%rsp)
 1083179:	ja     10832e1 <check_input_resolve_range+0x5f1>
 108317f:	lea    0x140(%rsp),%rsi
 1083187:	mov    %rdi,0x130(%rsp)
 108318f:	mov    %r12,0x138(%rsp)
 1083197:	vpxor  %xmm1,%xmm1,%xmm1
 108319b:	lea    0x130(%rsp),%rdi
 10831a3:	vmovdqu64 %zmm1,(%rsi)
 10831a9:	vmovdqu %xmm0,0x180(%rsp)
 10831b2:	mov    %rax,0x190(%rsp)
 10831ba:	lea    0x200(%rsp),%rax
 10831c2:	vmovdqu64 %zmm1,0x58(%rsi)
 10831cc:	movq   $0x0,0x98(%rsi)
 10831d7:	movq   $0x1000001,0x1e0(%rsp)
 10831e3:	movq   $0x0,0x1e8(%rsp)
 10831ef:	mov    %r14,0x1f0(%rsp)
 10831f7:	mov    %r11d,%esi
 10831fa:	mov    %rax,0x1f8(%rsp)
 1083202:	vzeroupper
 1083205:	call   10a34e0 <check_init_walk>
 108320a:	cmp    0x8(%r14),%rbx
 108320e:	ja     1089100 <check_input_resolve_range+0x6410>
 1083214:	mov    0x8(%rsp),%r8
 1083219:	mov    %rbx,0x8(%r14)
 108321d:	vpbroadcastq -0xad6bd7(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1083227:	vpbroadcastd -0xad73f0(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1083230:	vpbroadcastq -0xad6bda(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 108323a:	vpbroadcastd -0xad7404(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1083244:	vpbroadcastq -0xad6bf6(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 108324e:	cmpl   $0x5,0x21c(%rsp)
 1083256:	mov    0x200(%rsp),%ecx
 108325d:	mov    0x220(%rsp),%edx
 1083264:	mov    (%r8),%rdi
 1083267:	sete   %sil
 108326b:	or     %sil,0x3c5(%rdi)
 1083272:	test   %al,%al
 1083274:	je     10832ef <check_input_resolve_range+0x5ff>
 1083276:	mov    0xa0(%r8),%rax
 108327d:	mov    %ebp,%edx
 108327f:	mov    %r8,%rbx
 1083282:	mov    %ecx,(%rax,%r15,4)
 1083286:	mov    0xa8(%r8),%rax
 108328d:	mov    %ecx,(%rax,%rdx,4)
 1083290:	mov    0x128(%r8),%rax
 1083297:	cmpb   $0x0,(%rax,%r15,1)
 108329c:	je     1082e90 <check_input_resolve_range+0x1a0>
 10832a2:	mov    0x18(%r12),%rax
 10832a7:	mov    0x328(%rbx),%rdx
 10832ae:	mov    (%rax,%r15,4),%eax
 10832b2:	mov    %ecx,(%rdx,%rax,4)
 10832b5:	jmp    1082e90 <check_input_resolve_range+0x1a0>
 10832ba:	cmpl   $0x5,0x3c(%rsp)
 10832bf:	mov    0x48(%rsp),%r12
 10832c4:	mov    (%rsp),%r13
 10832c8:	jne    108388d <check_input_resolve_range+0xb9d>
 10832ce:	mov    %rbx,%rdi
 10832d1:	mov    %r13d,%esi
 10832d4:	vzeroupper
 10832d7:	call   10a1740 <check_input_string>
 10832dc:	jmp    10838a8 <check_input_resolve_range+0xbb8>
 10832e1:	mov    %rbx,0x8(%r14)
 10832e5:	mov    0x8(%rsp),%r8
 10832ea:	mov    $0xffffffff,%edx
 10832ef:	mov    (%r8),%rax
 10832f2:	mov    %r8,%rbx
 10832f5:	mov    0x230(%rax),%ecx
 10832fb:	cmp    0x234(%rax),%ecx
 1083301:	jae    1083335 <check_input_resolve_range+0x645>
 1083303:	movzbl 0x3c5(%rax),%esi
 108330a:	mov    0x228(%rax),%rdi
 1083311:	lea    0x1(%rcx),%r8d
 1083315:	mov    %r8d,0x230(%rax)
 108331c:	lea    (%rcx,%rcx,2),%rax
 1083320:	lea    0x1(%rsi,%rsi,2),%esi
 1083324:	mov    %edx,(%rdi,%rax,4)
 1083327:	mov    %esi,0x4(%rdi,%rax,4)
 108332b:	movl   $0x0,0x8(%rdi,%rax,4)
 1083333:	jmp    108333c <check_input_resolve_range+0x64c>
 1083335:	movb   $0x1,0x3c5(%rax)
 108333c:	mov    (%rsp),%r13
 1083340:	mov    (%rbx),%rax
 1083343:	cmpl   $0x0,0x230(%rax)
 108334a:	jne    1083390 <check_input_resolve_range+0x6a0>
 108334c:	cmpl   $0x0,0x234(%rax)
 1083353:	je     10838de <check_input_resolve_range+0xbee>
 1083359:	movzbl 0x3c5(%rax),%ecx
 1083360:	mov    0x228(%rax),%rdx
 1083367:	movl   $0x1,0x230(%rax)
 1083371:	lea    0x1(%rcx,%rcx,2),%ecx
 1083375:	mov    %ebp,(%rdx)
 1083377:	mov    %ecx,0x4(%rdx)
 108337a:	movl   $0x0,0x8(%rdx)
 1083381:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1083390:	mov    (%rbx),%rax
 1083393:	mov    0x48(%rsp),%r12
 1083398:	cmpl   $0x0,0x230(%rax)
 108339f:	jne    1082d24 <check_input_resolve_range+0x34>
 10833a5:	cmpb   $0x0,0x3c5(%rax)
 10833ac:	jne    1082d24 <check_input_resolve_range+0x34>
 10833b2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10833c0:	mov    0x3b0(%rbx),%ecx
 10833c6:	test   %ecx,%ecx
 10833c8:	je     1083500 <check_input_resolve_range+0x810>
 10833ce:	mov    0x3a0(%rbx),%rax
 10833d5:	dec    %ecx
 10833d7:	cmp    %r13d,(%rax,%rcx,4)
 10833db:	jae    1083500 <check_input_resolve_range+0x810>
 10833e1:	mov    %ecx,0x3b0(%rbx)
 10833e7:	mov    $0x1,%dl
 10833e9:	mov    0x40(%rbx),%eax
 10833ec:	cmp    0x9c(%rbx),%eax
 10833f2:	je     1083402 <check_input_resolve_range+0x712>
 10833f4:	mov    0x68(%rbx),%rdx
 10833f8:	lea    -0x1(%rax),%esi
 10833fb:	cmp    (%rdx,%rsi,4),%r13d
 10833ff:	setae  %dl
 1083402:	cmpb   $0x1,0x98(%rbx)
 1083409:	jne    108341a <check_input_resolve_range+0x72a>
 108340b:	mov    0x398(%rbx),%rsi
 1083412:	mov    (%rsi,%rcx,4),%ecx
 1083415:	cmp    0x50(%rbx),%ecx
 1083418:	jbe    1083440 <check_input_resolve_range+0x750>
 108341a:	movb   $0x0,0x98(%rbx)
 1083421:	cmpb   $0x0,0x98(%rbx)
 1083428:	jne    10833c0 <check_input_resolve_range+0x6d0>
 108342a:	mov    (%rbx),%rax
 108342d:	movb   $0x1,0x3c5(%rax)
 1083434:	jmp    10833c0 <check_input_resolve_range+0x6d0>
 1083436:	cs nopw 0x0(%rax,%rax,1)
 1083440:	cmp    0x3c(%rbx),%eax
 1083443:	setb   %sil
 1083447:	and    %dl,%sil
 108344a:	mov    %sil,0x98(%rbx)
 1083451:	cmp    $0x1,%sil
 1083455:	jne    1083421 <check_input_resolve_range+0x731>
 1083457:	lea    0x1(%rax),%edx
 108345a:	mov    %edx,0x40(%rbx)
 108345d:	mov    0x88(%rbx),%rdx
 1083464:	movb   $0x2,(%rdx,%rax,1)
 1083468:	mov    0x60(%rbx),%rdx
 108346c:	mov    %ecx,(%rdx,%rax,4)
 108346f:	mov    0x68(%rbx),%rdx
 1083473:	mov    %r13d,(%rdx,%rax,4)
 1083477:	mov    0x58(%rbx),%rdx
 108347b:	movl   $0x0,(%rdx,%rax,4)
 1083482:	mov    0x70(%rbx),%rdx
 1083486:	movl   $0xffffffff,(%rdx,%rax,4)
 108348d:	mov    0x78(%rbx),%rdx
 1083491:	movl   $0x0,(%rdx,%rax,4)
 1083498:	mov    0x80(%rbx),%rdx
 108349f:	movl   $0x0,(%rdx,%rax,4)
 10834a6:	mov    0x90(%rbx),%rdx
 10834ad:	movb   $0x0,(%rdx,%rax,1)
 10834b1:	mov    0x50(%rbx),%edx
 10834b4:	cmp    %ecx,%edx
 10834b6:	jbe    1083421 <check_input_resolve_range+0x731>
 10834bc:	nopl   0x0(%rax)
 10834c0:	dec    %edx
 10834c2:	mov    %edx,0x50(%rbx)
 10834c5:	mov    0x48(%rbx),%rsi
 10834c9:	mov    0x70(%rbx),%rdi
 10834cd:	mov    (%rsi,%rdx,4),%edx
 10834d0:	mov    %eax,(%rdi,%rdx,4)
 10834d3:	mov    0x78(%rbx),%rsi
 10834d7:	mov    0x58(%rbx),%r8
 10834db:	mov    0x30(%rbx),%rdi
 10834df:	mov    (%rsi,%rdx,4),%esi
 10834e2:	mov    (%r8,%rdx,4),%edx
 10834e6:	mov    %esi,(%rdi,%rdx,4)
 10834e9:	mov    0x50(%rbx),%edx
 10834ec:	cmp    %ecx,%edx
 10834ee:	ja     10834c0 <check_input_resolve_range+0x7d0>
 10834f0:	jmp    1083421 <check_input_resolve_range+0x731>
 10834f5:	data16 cs nopw 0x0(%rax,%rax,1)
 1083500:	cmp    0x3b8(%rbx),%r13d
 1083507:	jbe    108351d <check_input_resolve_range+0x82d>
 1083509:	movl   $0x0,0x3b4(%rbx)
 1083513:	movl   $0xffffffff,0x3bc(%rbx)
 108351d:	cmp    0xbc(%rsp),%r13d
 1083525:	je     1082d24 <check_input_resolve_range+0x34>
 108352b:	mov    (%rbx),%rax
 108352e:	mov    0x28(%rsp),%rbp
 1083533:	mov    0x1f0(%rax),%rax
 108353a:	test   %rax,%rax
 108353d:	je     1083690 <check_input_resolve_range+0x9a0>
 1083543:	cmpb   $0x0,(%rax,%rbp,1)
 1083547:	je     1083690 <check_input_resolve_range+0x9a0>
 108354d:	mov    0x2d0(%rbx),%rax
 1083554:	mov    (%rax,%rbp,4),%ebp
 1083557:	cmp    $0xffffffff,%ebp
 108355a:	je     1083581 <check_input_resolve_range+0x891>
 108355c:	nopl   0x0(%rax)
 1083560:	mov    %rbx,%rdi
 1083563:	mov    %ebp,%esi
 1083565:	mov    %r13d,%edx
 1083568:	vzeroupper
 108356b:	call   1090a70 <check_input_bind>
 1083570:	mov    0x2d8(%rbx),%rax
 1083577:	mov    %ebp,%ecx
 1083579:	mov    (%rax,%rcx,4),%ebp
 108357c:	cmp    $0xffffffff,%ebp
 108357f:	jne    1083560 <check_input_resolve_range+0x870>
 1083581:	vpbroadcastq -0xad6f3b(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 108358b:	vpbroadcastd -0xad7754(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1083594:	vpbroadcastq -0xad6f3e(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 108359e:	vpbroadcastd -0xad7768(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10835a8:	vpbroadcastq -0xad6f5a(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10835b2:	mov    0x448(%rbx),%rax
 10835b9:	mov    0x28(%rsp),%r14
 10835be:	test   %rax,%rax
 10835c1:	je     108387f <check_input_resolve_range+0xb8f>
 10835c7:	mov    0x1e0(%rax),%ecx
 10835cd:	cmp    0x1e4(%rax),%ecx
 10835d3:	jae    108386a <check_input_resolve_range+0xb7a>
 10835d9:	mov    $0x11,%r11b
 10835dc:	mov    (%rbx),%rsi
 10835df:	vpmovsxbd -0xad77a4(%rip),%xmm2        # 5abe44 <link_program_emit_worker.forms+0x3d4>
 10835e8:	mov    0x18(%rbx),%r8
 10835ec:	mov    0x8(%rbx),%rdi
 10835f0:	vmovdqa -0xb06cf8(%rip),%ymm3        # 57c900 <static_test_starved.starved+0xd60>
 10835f8:	mov    0x1d0(%rax),%rdx
 10835ff:	mov    0x240(%rbx),%r9d
 1083606:	mov    0x1c8(%rbx),%r10d
 108360d:	lea    (%rcx,%rcx,2),%rcx
 1083611:	kmovd  %r11d,%k1
 1083616:	mov    0x118(%rsp),%r11
 108361e:	shl    $0x4,%rcx
 1083622:	mov    0x60(%rdi),%rdi
 1083626:	vmovdqu32 (%r11),%ymm0{%k1}{z}
 108362c:	mov    $0x4111,%r11w
 1083631:	kmovd  %r11d,%k1
 1083636:	vmovdqu32 0x328(%rsi),%zmm1{%k1}{z}
 1083640:	mov    (%rdi,%r14,4),%edi
 1083644:	vpermd %zmm1,%zmm2,%zmm1
 108364a:	vmovd  0x48(%r8),%xmm2
 1083650:	vpinsrd $0x1,0xa0(%r8),%xmm2,%xmm2
 108365a:	mov    %r13d,(%rdx,%rcx,1)
 108365e:	mov    %edi,0x4(%rdx,%rcx,1)
 1083662:	vinserti128 $0x1,%xmm1,%ymm2,%ymm1
 1083668:	vpermt2d %ymm0,%ymm3,%ymm1
 108366e:	vmovdqu %ymm1,0x8(%rdx,%rcx,1)
 1083674:	mov    %r9d,0x28(%rdx,%rcx,1)
 1083679:	mov    %r10d,0x2c(%rdx,%rcx,1)
 108367e:	incl   0x1e0(%rax)
 1083684:	mov    0x2ac60(%rax),%rcx
 108368b:	jmp    1083878 <check_input_resolve_range+0xb88>
 1083690:	mov    0x188(%rbx),%rax
 1083697:	cmpb   $0x2,(%rax,%rbp,1)
 108369b:	jne    1083c04 <check_input_resolve_range+0xf14>
 10836a1:	mov    0x180(%rbx),%rax
 10836a8:	mov    0x198(%rbx),%rcx
 10836af:	vpxor  %xmm0,%xmm0,%xmm0
 10836b3:	mov    %rbx,%rdi
 10836b6:	xor    %r8d,%r8d
 10836b9:	lea    0x130(%rsp),%r9
 10836c1:	mov    (%rcx,%rbp,4),%r14d
 10836c5:	mov    (%rax,%rbp,8),%r15
 10836c9:	lea    0x1(%r13),%ebp
 10836cd:	vmovdqu64 %zmm0,0x150(%rsp)
 10836d8:	vmovdqu64 %zmm0,0x130(%rsp)
 10836e3:	xor    %ecx,%ecx
 10836e5:	mov    %ebp,%esi
 10836e7:	mov    %r14d,%edx
 10836ea:	push   $0x0
 10836ec:	lea    0x208(%rsp),%rax
 10836f4:	push   %rax
 10836f5:	vzeroupper
 10836f8:	call   10c24f0 <check_input_constant_read>
 10836fd:	add    $0x10,%rsp
 1083701:	test   %al,%al
 1083703:	je     1088f7e <check_input_resolve_range+0x628e>
 1083709:	cmpl   $0x0,0x184(%rsp)
 1083711:	jne    1088f7e <check_input_resolve_range+0x628e>
 1083717:	cmpl   $0x1,0x13c(%rsp)
 108371f:	jne    1088f7e <check_input_resolve_range+0x628e>
 1083725:	testb  $0x10,0x138(%rsp)
 108372d:	jne    1088f7e <check_input_resolve_range+0x628e>
 1083733:	mov    0x18(%rbx),%rax
 1083737:	mov    0x130(%rsp),%edx
 108373e:	mov    (%rax),%rcx
 1083741:	mov    %edx,%esi
 1083743:	shr    $0x3,%esi
 1083746:	movzbl (%rcx,%rsi,1),%edi
 108374a:	cmp    $0xf,%dil
 108374e:	jne    1083760 <check_input_resolve_range+0xa70>
 1083750:	mov    0x20(%rax),%rdx
 1083754:	mov    (%rdx,%rsi,4),%edx
 1083757:	mov    %edx,%esi
 1083759:	shr    $0x3,%esi
 108375c:	movzbl (%rcx,%rsi,1),%edi
 1083760:	cmp    $0x12,%dil
 1083764:	jne    1083777 <check_input_resolve_range+0xa87>
 1083766:	mov    0x10(%rax),%rdi
 108376a:	testb  $0x4,(%rdi,%rsi,1)
 108376e:	je     1083777 <check_input_resolve_range+0xa87>
 1083770:	mov    0x20(%rax),%rdx
 1083774:	mov    (%rdx,%rsi,4),%edx
 1083777:	shr    $0x3,%edx
 108377a:	movzbl (%rcx,%rdx,1),%ecx
 108377e:	cmp    $0x2,%ecx
 1083781:	je     10837a3 <check_input_resolve_range+0xab3>
 1083783:	cmp    $0x5,%ecx
 1083786:	jne    1088f7e <check_input_resolve_range+0x628e>
 108378c:	mov    0x10(%rax),%rsi
 1083790:	mov    0x30(%rax),%rax
 1083794:	movzbl (%rsi,%rdx,1),%r9d
 1083799:	mov    (%rax,%rdx,8),%rcx
 108379d:	xor    $0x1,%r9b
 10837a1:	jmp    10837b9 <check_input_resolve_range+0xac9>
 10837a3:	lea    (%rdx,%rdx,2),%rax
 10837a7:	lea    -0xbdab3e(%rip),%rdx        # 4a8c70 <type_integer_info>
 10837ae:	movzbl 0x2(%rdx,%rax,2),%ecx
 10837b3:	movzbl 0x3(%rdx,%rax,2),%r9d
 10837b9:	lea    -0x1(%rcx),%rax
 10837bd:	cmp    $0x7f,%rax
 10837c1:	ja     1088f7e <check_input_resolve_range+0x628e>
 10837c7:	mov    $0xffffffffffffffff,%rax
 10837ce:	xor    %edx,%edx
 10837d0:	test   $0x40,%cl
 10837d3:	mov    0x148(%rsp),%rdi
 10837db:	shlx   %rcx,%rax,%rsi
 10837e0:	mov    %rsi,%r8
 10837e3:	cmovne %rdx,%r8
 10837e7:	cmove  %rax,%rsi
 10837eb:	cmp    $0x80,%rcx
 10837f2:	not    %rsi
 10837f5:	not    %r8
 10837f8:	cmove  %rax,%r8
 10837fc:	cmove  %rax,%rsi
 1083800:	mov    0x140(%rsp),%rax
 1083808:	and    %rsi,%rdi
 108380b:	and    %r8,%rax
 108380e:	test   $0x1,%r9b
 1083812:	je     1083901 <check_input_resolve_range+0xc11>
 1083818:	dec    %cl
 108381a:	mov    %rax,%r9
 108381d:	mov    $0x0,%edx
 1083822:	shrd   %cl,%rdi,%r9
 1083826:	shrx   %rcx,%rdi,%r10
 108382b:	test   $0x40,%cl
 108382e:	mov    $0x0,%ecx
 1083833:	cmovne %r10,%r9
 1083837:	cmovne %rcx,%r10
 108383b:	mov    %rax,%rcx
 108383e:	neg    %rcx
 1083841:	sbb    %rdi,%rdx
 1083844:	or     %r9,%r10
 1083847:	je     10838ff <check_input_resolve_range+0xc0f>
 108384d:	and    %rdx,%rsi
 1083850:	and    %rcx,%r8
 1083853:	mov    $0x1,%dl
 1083855:	movabs $0x8000000000000000,%rcx
 108385f:	mov    %r8,%rax
 1083862:	mov    %rsi,%rdi
 1083865:	jmp    108390b <check_input_resolve_range+0xc1b>
 108386a:	lea    -0x9c2a66(%rip),%rcx        # 6c0e0b <pp_string_value.meaning+0x3860a>
 1083871:	movb   $0x1,0x2ac58(%rax)
 1083878:	mov    %rcx,0x2ac60(%rax)
 108387f:	mov    0x60(%r12),%rax
 1083884:	mov    (%rax,%r14,4),%r13d
 1083888:	jmp    1082dd5 <check_input_resolve_range+0xe5>
 108388d:	cmp    0x30(%r12),%r13d
 1083892:	jae    10838a8 <check_input_resolve_range+0xbb8>
 1083894:	mov    0x18(%r12),%rax
 1083899:	mov    (%rax,%rbp,4),%eax
 108389c:	add    $0xffffffbe,%eax
 108389f:	cmp    $0x2,%eax
 10838a2:	jbe    10832ce <check_input_resolve_range+0x5de>
 10838a8:	vpbroadcastq -0xad7262(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 10838b2:	vpbroadcastd -0xad7a7b(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10838bb:	vpbroadcastq -0xad7265(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 10838c5:	vpbroadcastd -0xad7a8f(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10838cf:	vpbroadcastq -0xad7281(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10838d9:	jmp    1082dd5 <check_input_resolve_range+0xe5>
 10838de:	movb   $0x1,0x3c5(%rax)
 10838e5:	mov    (%rbx),%rax
 10838e8:	mov    0x48(%rsp),%r12
 10838ed:	cmpl   $0x0,0x230(%rax)
 10838f4:	je     10833a5 <check_input_resolve_range+0x6b5>
 10838fa:	jmp    1082d24 <check_input_resolve_range+0x34>
 10838ff:	xor    %edx,%edx
 1083901:	movabs $0x7fffffffffffffff,%rcx
 108390b:	cmp    %rax,%rcx
 108390e:	mov    $0x0,%ecx
 1083913:	sbb    %rdi,%rcx
 1083916:	jb     1088f7e <check_input_resolve_range+0x628e>
 108391c:	mov    %rax,%r12
 108391f:	neg    %r12
 1083922:	test   %dl,%dl
 1083924:	lea    0x130(%rsp),%rcx
 108392c:	mov    $0x1,%r8d
 1083932:	mov    %rbx,%rdi
 1083935:	mov    %ebp,%esi
 1083937:	mov    %r14d,%edx
 108393a:	cmove  %rax,%r12
 108393e:	call   10c22e0 <check_input_constant_warning>
 1083943:	test   %r12,%r12
 1083946:	js     1088f7e <check_input_resolve_range+0x628e>
 108394c:	cmp    %r15d,%r14d
 108394f:	jne    1083966 <check_input_resolve_range+0xc76>
 1083951:	mov    0x28(%rsp),%r14
 1083956:	mov    0x8(%rsp),%rdx
 108395b:	mov    %r12,%rbx
 108395e:	mov    %ebp,%r13d
 1083961:	jmp    1083b9d <check_input_resolve_range+0xead>
 1083966:	mov    0x8(%rsp),%rbx
 108396b:	lea    0x1(%r14),%r13d
 108396f:	vpxor  %xmm0,%xmm0,%xmm0
 1083973:	vmovdqu64 %zmm0,0x150(%rsp)
 108397e:	vmovdqu64 %zmm0,0x130(%rsp)
 1083989:	mov    %r15d,%edx
 108398c:	xor    %ecx,%ecx
 108398e:	xor    %r8d,%r8d
 1083991:	lea    0x130(%rsp),%r9
 1083999:	mov    %r13d,%esi
 108399c:	mov    %rbx,%rdi
 108399f:	push   $0x0
 10839a1:	lea    0x208(%rsp),%rax
 10839a9:	push   %rax
 10839aa:	vzeroupper
 10839ad:	call   10c24f0 <check_input_constant_read>
 10839b2:	add    $0x10,%rsp
 10839b6:	test   %al,%al
 10839b8:	je     1088f7e <check_input_resolve_range+0x628e>
 10839be:	cmpl   $0x0,0x184(%rsp)
 10839c6:	jne    1088f7e <check_input_resolve_range+0x628e>
 10839cc:	cmpl   $0x1,0x13c(%rsp)
 10839d4:	jne    1088f7e <check_input_resolve_range+0x628e>
 10839da:	testb  $0x10,0x138(%rsp)
 10839e2:	jne    1088f7e <check_input_resolve_range+0x628e>
 10839e8:	mov    0x18(%rbx),%rax
 10839ec:	mov    0x130(%rsp),%edx
 10839f3:	mov    (%rax),%rcx
 10839f6:	mov    %edx,%esi
 10839f8:	shr    $0x3,%esi
 10839fb:	movzbl (%rcx,%rsi,1),%edi
 10839ff:	cmp    $0xf,%dil
 1083a03:	jne    1083a15 <check_input_resolve_range+0xd25>
 1083a05:	mov    0x20(%rax),%rdx
 1083a09:	mov    (%rdx,%rsi,4),%edx
 1083a0c:	mov    %edx,%esi
 1083a0e:	shr    $0x3,%esi
 1083a11:	movzbl (%rcx,%rsi,1),%edi
 1083a15:	cmp    $0x12,%dil
 1083a19:	jne    1083a2c <check_input_resolve_range+0xd3c>
 1083a1b:	mov    0x10(%rax),%rdi
 1083a1f:	testb  $0x4,(%rdi,%rsi,1)
 1083a23:	je     1083a2c <check_input_resolve_range+0xd3c>
 1083a25:	mov    0x20(%rax),%rdx
 1083a29:	mov    (%rdx,%rsi,4),%edx
 1083a2c:	shr    $0x3,%edx
 1083a2f:	movzbl (%rcx,%rdx,1),%ecx
 1083a33:	cmp    $0x2,%ecx
 1083a36:	je     1083a58 <check_input_resolve_range+0xd68>
 1083a38:	cmp    $0x5,%ecx
 1083a3b:	jne    1088f7e <check_input_resolve_range+0x628e>
 1083a41:	mov    0x10(%rax),%rsi
 1083a45:	mov    0x30(%rax),%rax
 1083a49:	movzbl (%rsi,%rdx,1),%r9d
 1083a4e:	mov    (%rax,%rdx,8),%rcx
 1083a52:	xor    $0x1,%r9b
 1083a56:	jmp    1083a6e <check_input_resolve_range+0xd7e>
 1083a58:	lea    (%rdx,%rdx,2),%rax
 1083a5c:	lea    -0xbdadf3(%rip),%rdx        # 4a8c70 <type_integer_info>
 1083a63:	movzbl 0x2(%rdx,%rax,2),%ecx
 1083a68:	movzbl 0x3(%rdx,%rax,2),%r9d
 1083a6e:	lea    -0x1(%rcx),%rax
 1083a72:	cmp    $0x7f,%rax
 1083a76:	ja     1088f7e <check_input_resolve_range+0x628e>
 1083a7c:	mov    $0xffffffffffffffff,%rax
 1083a83:	mov    $0xffffffffffffffff,%rdi
 1083a8a:	xor    %esi,%esi
 1083a8c:	mov    $0x0,%r8d
 1083a92:	shld   %cl,%rax,%rax
 1083a96:	shlx   %rcx,%rdi,%rdx
 1083a9b:	test   $0x40,%cl
 1083a9e:	cmove  %rdx,%r8
 1083aa2:	cmovne %rdx,%rax
 1083aa6:	cmp    $0x80,%rcx
 1083aad:	not    %r8
 1083ab0:	mov    0x140(%rsp),%rdx
 1083ab8:	not    %rax
 1083abb:	cmove  %rdi,%r8
 1083abf:	cmove  %rdi,%rax
 1083ac3:	mov    0x148(%rsp),%rdi
 1083acb:	and    %r8,%rdx
 1083ace:	and    %rax,%rdi
 1083ad1:	test   $0x1,%r9b
 1083ad5:	je     1083b25 <check_input_resolve_range+0xe35>
 1083ad7:	dec    %cl
 1083ad9:	mov    %rdx,%r9
 1083adc:	mov    $0x0,%esi
 1083ae1:	shrd   %cl,%rdi,%r9
 1083ae5:	shrx   %rcx,%rdi,%r10
 1083aea:	test   $0x40,%cl
 1083aed:	mov    $0x0,%ecx
 1083af2:	cmovne %r10,%r9
 1083af6:	cmovne %rcx,%r10
 1083afa:	mov    %rdx,%rcx
 1083afd:	neg    %rcx
 1083b00:	sbb    %rdi,%rsi
 1083b03:	or     %r9,%r10
 1083b06:	je     1083b23 <check_input_resolve_range+0xe33>
 1083b08:	and    %rsi,%rax
 1083b0b:	and    %rcx,%r8
 1083b0e:	mov    $0x1,%sil
 1083b11:	movabs $0x8000000000000000,%rcx
 1083b1b:	mov    %r8,%rdx
 1083b1e:	mov    %rax,%rdi
 1083b21:	jmp    1083b2f <check_input_resolve_range+0xe3f>
 1083b23:	xor    %esi,%esi
 1083b25:	movabs $0x7fffffffffffffff,%rcx
 1083b2f:	cmp    %rdx,%rcx
 1083b32:	mov    $0x0,%eax
 1083b37:	sbb    %rdi,%rax
 1083b3a:	jb     1088f7e <check_input_resolve_range+0x628e>
 1083b40:	mov    %rbx,%rdi
 1083b43:	mov    %rdx,%rbx
 1083b46:	neg    %rbx
 1083b49:	test   %sil,%sil
 1083b4c:	lea    0x130(%rsp),%rcx
 1083b54:	mov    $0x1,%r8d
 1083b5a:	mov    %r13d,%esi
 1083b5d:	cmove  %rdx,%rbx
 1083b61:	mov    %r15d,%edx
 1083b64:	call   10c22e0 <check_input_constant_warning>
 1083b69:	cmp    %r12,%rbx
 1083b6c:	jl     1088f7e <check_input_resolve_range+0x628e>
 1083b72:	mov    0x8(%rsp),%rdx
 1083b77:	mov    0x28(%rsp),%rcx
 1083b7c:	mov    0x180(%rdx),%rax
 1083b83:	mov    %r12,(%rax,%rcx,8)
 1083b87:	mov    0x188(%rdx),%rax
 1083b8e:	movb   $0x1,(%rax,%rcx,1)
 1083b92:	mov    0x190(%rdx),%rax
 1083b99:	mov    %ebp,(%rax,%r14,4)
 1083b9d:	mov    0x180(%rdx),%rcx
 1083ba4:	vpbroadcastq -0xad755e(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1083bae:	vpbroadcastd -0xad7d77(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1083bb7:	vpbroadcastq -0xad7561(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1083bc1:	vpbroadcastd -0xad7d8b(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1083bcb:	vpbroadcastq -0xad757d(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1083bd5:	mov    %r15d,%eax
 1083bd8:	mov    0x48(%rsp),%r12
 1083bdd:	mov    0x28(%rsp),%rbp
 1083be2:	mov    %rbx,(%rcx,%r14,8)
 1083be6:	mov    %rdx,%rbx
 1083be9:	mov    0x188(%rdx),%rcx
 1083bf0:	movb   $0x1,(%rcx,%r14,1)
 1083bf5:	mov    0x190(%rdx),%rcx
 1083bfc:	mov    %r13d,(%rcx,%rax,4)
 1083c00:	mov    (%rsp),%r13
 1083c04:	mov    0xb8(%rbx),%rax
 1083c0b:	mov    (%rax,%rbp,8),%r14
 1083c0f:	test   %r14,%r14
 1083c12:	je     1084110 <check_input_resolve_range+0x1420>
 1083c18:	cmpb   $0x0,0x41(%r14)
 1083c1d:	jne    1084110 <check_input_resolve_range+0x1420>
 1083c23:	vpxor  %xmm0,%xmm0,%xmm0
 1083c27:	vmovdqu64 %zmm0,0x150(%rsp)
 1083c32:	vmovdqu64 %zmm0,0x130(%rsp)
 1083c3d:	movl   $0xffffffff,0x12c(%rsp)
 1083c48:	movb   $0x0,0x2ce(%rbx)
 1083c4f:	lea    0x12c(%rsp),%rax
 1083c57:	mov    %rbx,%rdi
 1083c5a:	xor    %ecx,%ecx
 1083c5c:	mov    $0x1,%r8d
 1083c62:	lea    0x130(%rsp),%r9
 1083c6a:	mov    0x4(%r14),%esi
 1083c6e:	mov    0x8(%r14),%edx
 1083c72:	add    $0x2,%esi
 1083c75:	push   %rax
 1083c76:	lea    0x208(%rsp),%rax
 1083c7e:	push   %rax
 1083c7f:	vzeroupper
 1083c82:	call   10c24f0 <check_input_constant_read>
 1083c87:	add    $0x10,%rsp
 1083c8b:	mov    0x4(%r14),%edx
 1083c8f:	mov    0x8(%r14),%ecx
 1083c93:	add    $0x2,%edx
 1083c96:	cmp    %ecx,%edx
 1083c98:	jae    1083d19 <check_input_resolve_range+0x1029>
 1083c9a:	mov    (%rbx),%rsi
 1083c9d:	cmpq   $0x0,0x2c8(%rsi)
 1083ca5:	je     1083d19 <check_input_resolve_range+0x1029>
 1083ca7:	mov    0x8(%rbx),%rsi
 1083cab:	cmp    0x30(%rsi),%ecx
 1083cae:	ja     1083d19 <check_input_resolve_range+0x1029>
 1083cb0:	mov    %ecx,%r8d
 1083cb3:	sub    %edx,%r8d
 1083cb6:	mov    %edx,%edi
 1083cb8:	mov    %rdi,%rsi
 1083cbb:	and    $0x3,%r8d
 1083cbf:	je     1083d10 <check_input_resolve_range+0x1020>
 1083cc1:	mov    %rdi,%rsi
 1083cc4:	jmp    1083cd8 <check_input_resolve_range+0xfe8>
 1083cc6:	cs nopw 0x0(%rax,%rax,1)
 1083cd0:	inc    %rsi
 1083cd3:	dec    %r8
 1083cd6:	je     1083d10 <check_input_resolve_range+0x1020>
 1083cd8:	mov    0x280(%rbx),%r9
 1083cdf:	test   %r9,%r9
 1083ce2:	je     1083ceb <check_input_resolve_range+0xffb>
 1083ce4:	testb  $0x2,(%r9,%rsi,1)
 1083ce9:	jne    1083cd0 <check_input_resolve_range+0xfe0>
 1083ceb:	mov    (%rbx),%r9
 1083cee:	mov    0x2c8(%r9),%r9
 1083cf5:	andb   $0x87,(%r9,%rsi,1)
 1083cfa:	mov    (%rbx),%r9
 1083cfd:	mov    0x2d0(%r9),%r9
 1083d04:	test   %r9,%r9
 1083d07:	je     1083cd0 <check_input_resolve_range+0xfe0>
 1083d09:	andb   $0x87,(%r9,%rsi,1)
 1083d0e:	jmp    1083cd0 <check_input_resolve_range+0xfe0>
 1083d10:	sub    %rcx,%rdi
 1083d13:	cmp    $0xfffffffffffffffc,%rdi
 1083d17:	jbe    1083d69 <check_input_resolve_range+0x1079>
 1083d19:	cmp    %ecx,%edx
 1083d1b:	jae    1083e82 <check_input_resolve_range+0x1192>
 1083d21:	cmpq   $0x0,0x288(%rbx)
 1083d29:	je     1083e82 <check_input_resolve_range+0x1192>
 1083d2f:	mov    0x8(%rbx),%rsi
 1083d33:	cmp    0x30(%rsi),%ecx
 1083d36:	ja     1083e82 <check_input_resolve_range+0x1192>
 1083d3c:	mov    %ecx,%edi
 1083d3e:	sub    %edx,%edi
 1083d40:	mov    %edx,%esi
 1083d42:	mov    %rsi,%rdx
 1083d45:	and    $0x3,%edi
 1083d48:	je     1083e79 <check_input_resolve_range+0x1189>
 1083d4e:	mov    %rsi,%rdx
 1083d51:	jmp    1083e64 <check_input_resolve_range+0x1174>
 1083d56:	cs nopw 0x0(%rax,%rax,1)
 1083d60:	add    $0x4,%rsi
 1083d64:	cmp    %rsi,%rcx
 1083d67:	je     1083d19 <check_input_resolve_range+0x1029>
 1083d69:	mov    0x280(%rbx),%rdi
 1083d70:	test   %rdi,%rdi
 1083d73:	je     1083d7b <check_input_resolve_range+0x108b>
 1083d75:	testb  $0x2,(%rdi,%rsi,1)
 1083d79:	jne    1083d9c <check_input_resolve_range+0x10ac>
 1083d7b:	mov    (%rbx),%rdi
 1083d7e:	mov    0x2c8(%rdi),%rdi
 1083d85:	andb   $0x87,(%rdi,%rsi,1)
 1083d89:	mov    (%rbx),%rdi
 1083d8c:	mov    0x2d0(%rdi),%rdi
 1083d93:	test   %rdi,%rdi
 1083d96:	je     1083d9c <check_input_resolve_range+0x10ac>
 1083d98:	andb   $0x87,(%rdi,%rsi,1)
 1083d9c:	mov    0x280(%rbx),%rdi
 1083da3:	test   %rdi,%rdi
 1083da6:	je     1083daf <check_input_resolve_range+0x10bf>
 1083da8:	testb  $0x2,0x1(%rdi,%rsi,1)
 1083dad:	jne    1083dd2 <check_input_resolve_range+0x10e2>
 1083daf:	mov    (%rbx),%rdi
 1083db2:	mov    0x2c8(%rdi),%rdi
 1083db9:	andb   $0x87,0x1(%rdi,%rsi,1)
 1083dbe:	mov    (%rbx),%rdi
 1083dc1:	mov    0x2d0(%rdi),%rdi
 1083dc8:	test   %rdi,%rdi
 1083dcb:	je     1083dd2 <check_input_resolve_range+0x10e2>
 1083dcd:	andb   $0x87,0x1(%rdi,%rsi,1)
 1083dd2:	mov    0x280(%rbx),%rdi
 1083dd9:	test   %rdi,%rdi
 1083ddc:	je     1083de5 <check_input_resolve_range+0x10f5>
 1083dde:	testb  $0x2,0x2(%rdi,%rsi,1)
 1083de3:	jne    1083e08 <check_input_resolve_range+0x1118>
 1083de5:	mov    (%rbx),%rdi
 1083de8:	mov    0x2c8(%rdi),%rdi
 1083def:	andb   $0x87,0x2(%rdi,%rsi,1)
 1083df4:	mov    (%rbx),%rdi
 1083df7:	mov    0x2d0(%rdi),%rdi
 1083dfe:	test   %rdi,%rdi
 1083e01:	je     1083e08 <check_input_resolve_range+0x1118>
 1083e03:	andb   $0x87,0x2(%rdi,%rsi,1)
 1083e08:	mov    0x280(%rbx),%rdi
 1083e0f:	test   %rdi,%rdi
 1083e12:	je     1083e1f <check_input_resolve_range+0x112f>
 1083e14:	testb  $0x2,0x3(%rdi,%rsi,1)
 1083e19:	jne    1083d60 <check_input_resolve_range+0x1070>
 1083e1f:	mov    (%rbx),%rdi
 1083e22:	mov    0x2c8(%rdi),%rdi
 1083e29:	andb   $0x87,0x3(%rdi,%rsi,1)
 1083e2e:	mov    (%rbx),%rdi
 1083e31:	mov    0x2d0(%rdi),%rdi
 1083e38:	test   %rdi,%rdi
 1083e3b:	je     1083d60 <check_input_resolve_range+0x1070>
 1083e41:	andb   $0x87,0x3(%rdi,%rsi,1)
 1083e46:	jmp    1083d60 <check_input_resolve_range+0x1070>
 1083e4b:	nopl   0x0(%rax,%rax,1)
 1083e50:	mov    0x288(%rbx),%r8
 1083e57:	orb    $0x78,(%r8,%rdx,1)
 1083e5c:	inc    %rdx
 1083e5f:	dec    %rdi
 1083e62:	je     1083e79 <check_input_resolve_range+0x1189>
 1083e64:	mov    0x280(%rbx),%r8
 1083e6b:	test   %r8,%r8
 1083e6e:	je     1083e50 <check_input_resolve_range+0x1160>
 1083e70:	testb  $0x2,(%r8,%rdx,1)
 1083e75:	je     1083e50 <check_input_resolve_range+0x1160>
 1083e77:	jmp    1083e5c <check_input_resolve_range+0x116c>
 1083e79:	sub    %rcx,%rsi
 1083e7c:	cmp    $0xfffffffffffffffc,%rsi
 1083e80:	jbe    1083ec5 <check_input_resolve_range+0x11d5>
 1083e82:	xor    %ecx,%ecx
 1083e84:	test   %al,%al
 1083e86:	je     1083e8f <check_input_resolve_range+0x119f>
 1083e88:	mov    0x130(%rsp),%ecx
 1083e8f:	mov    %ecx,0x28(%r14)
 1083e93:	je     1083f39 <check_input_resolve_range+0x1249>
 1083e99:	movzbl 0x2ce(%rbx),%eax
 1083ea0:	mov    %al,0x39(%r14)
 1083ea4:	jmp    1083f8f <check_input_resolve_range+0x129f>
 1083ea9:	nopl   0x0(%rax)
 1083eb0:	mov    0x288(%rbx),%rsi
 1083eb7:	orb    $0x78,0x3(%rsi,%rdx,1)
 1083ebc:	add    $0x4,%rdx
 1083ec0:	cmp    %rdx,%rcx
 1083ec3:	je     1083e82 <check_input_resolve_range+0x1192>
 1083ec5:	mov    0x280(%rbx),%rsi
 1083ecc:	test   %rsi,%rsi
 1083ecf:	je     1083ed7 <check_input_resolve_range+0x11e7>
 1083ed1:	testb  $0x2,(%rsi,%rdx,1)
 1083ed5:	jne    1083ee2 <check_input_resolve_range+0x11f2>
 1083ed7:	mov    0x288(%rbx),%rsi
 1083ede:	orb    $0x78,(%rsi,%rdx,1)
 1083ee2:	mov    0x280(%rbx),%rsi
 1083ee9:	test   %rsi,%rsi
 1083eec:	je     1083ef5 <check_input_resolve_range+0x1205>
 1083eee:	testb  $0x2,0x1(%rsi,%rdx,1)
 1083ef3:	jne    1083f01 <check_input_resolve_range+0x1211>
 1083ef5:	mov    0x288(%rbx),%rsi
 1083efc:	orb    $0x78,0x1(%rsi,%rdx,1)
 1083f01:	mov    0x280(%rbx),%rsi
 1083f08:	test   %rsi,%rsi
 1083f0b:	je     1083f14 <check_input_resolve_range+0x1224>
 1083f0d:	testb  $0x2,0x2(%rsi,%rdx,1)
 1083f12:	jne    1083f20 <check_input_resolve_range+0x1230>
 1083f14:	mov    0x288(%rbx),%rsi
 1083f1b:	orb    $0x78,0x2(%rsi,%rdx,1)
 1083f20:	mov    0x280(%rbx),%rsi
 1083f27:	test   %rsi,%rsi
 1083f2a:	je     1083eb0 <check_input_resolve_range+0x11c0>
 1083f2c:	testb  $0x2,0x3(%rsi,%rdx,1)
 1083f31:	je     1083eb0 <check_input_resolve_range+0x11c0>
 1083f37:	jmp    1083ebc <check_input_resolve_range+0x11cc>
 1083f39:	movb   $0x0,0x39(%r14)
 1083f3e:	mov    0x12c(%rsp),%eax
 1083f45:	cmp    0x30(%r12),%eax
 1083f4a:	jae    1083f8f <check_input_resolve_range+0x129f>
 1083f4c:	mov    (%rbx),%rcx
 1083f4f:	cmpb   $0x0,0x3c5(%rcx)
 1083f56:	jne    1083f8f <check_input_resolve_range+0x129f>
 1083f58:	mov    0x230(%rcx),%edx
 1083f5e:	cmp    0x234(%rcx),%edx
 1083f64:	jae    1083f88 <check_input_resolve_range+0x1298>
 1083f66:	mov    0x228(%rcx),%rsi
 1083f6d:	lea    0x1(%rdx),%edi
 1083f70:	mov    %edi,0x230(%rcx)
 1083f76:	lea    (%rdx,%rdx,2),%rcx
 1083f7a:	mov    %eax,(%rsi,%rcx,4)
 1083f7d:	movq   $0x1,0x4(%rsi,%rcx,4)
 1083f86:	jmp    1083f8f <check_input_resolve_range+0x129f>
 1083f88:	movb   $0x1,0x3c5(%rcx)
 1083f8f:	mov    0x18(%r12),%rax
 1083f94:	mov    0x4(%r14),%ecx
 1083f98:	mov    (%rax,%rcx,4),%eax
 1083f9b:	add    $0xffffffc6,%eax
 1083f9e:	cmp    $0x2b,%eax
 1083fa1:	ja     1083fdb <check_input_resolve_range+0x12eb>
 1083fa3:	movabs $0xc0000000001,%rcx
 1083fad:	bt     %rax,%rcx
 1083fb1:	jae    1083fdb <check_input_resolve_range+0x12eb>
 1083fb3:	mov    0x28(%r14),%ecx
 1083fb7:	mov    %ecx,%eax
 1083fb9:	and    $0xfffffff8,%eax
 1083fbc:	shr    $0x3,%ecx
 1083fbf:	mov    %eax,0x28(%r14)
 1083fc3:	mov    0x18(%rbx),%rdx
 1083fc7:	mov    (%rdx),%rsi
 1083fca:	cmpb   $0xe,(%rsi,%rcx,1)
 1083fce:	jne    1083fd7 <check_input_resolve_range+0x12e7>
 1083fd0:	mov    0x20(%rdx),%rax
 1083fd4:	mov    (%rax,%rcx,4),%eax
 1083fd7:	mov    %eax,0x28(%r14)
 1083fdb:	movb   $0x1,0x41(%r14)
 1083fe0:	decl   0xc4(%rbx)
 1083fe6:	cmpl   $0x0,0x28(%r14)
 1083feb:	je     108402e <check_input_resolve_range+0x133e>
 1083fed:	mov    (%r14),%esi
 1083ff0:	mov    %rbx,%rdi
 1083ff3:	call   1092ed0 <check_input_declaration>
 1083ff8:	vpbroadcastq -0xad79b2(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1084002:	vpbroadcastd -0xad81cb(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 108400b:	vpbroadcastq -0xad79b5(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1084015:	vpbroadcastd -0xad81df(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 108401f:	vpbroadcastq -0xad79d1(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1084029:	jmp    1084110 <check_input_resolve_range+0x1420>
 108402e:	mov    (%rbx),%rax
 1084031:	vpbroadcastq -0xad79eb(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 108403b:	vpbroadcastd -0xad8204(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1084044:	vpbroadcastq -0xad79ee(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 108404e:	vpbroadcastd -0xad8218(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1084058:	vpbroadcastq -0xad7a0a(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1084062:	cmpl   $0x0,0x230(%rax)
 1084069:	jne    1084110 <check_input_resolve_range+0x1420>
 108406f:	cmpb   $0x0,0x3c5(%rax)
 1084076:	jne    1084110 <check_input_resolve_range+0x1420>
 108407c:	cmpl   $0x0,0x234(%rax)
 1084083:	je     10840fe <check_input_resolve_range+0x140e>
 1084085:	mov    0x4(%r14),%ecx
 1084089:	mov    0x228(%rax),%rdx
 1084090:	movl   $0x1,0x230(%rax)
 108409a:	mov    %ecx,(%rdx)
 108409c:	movq   $0x1,0x4(%rdx)
 10840a4:	jmp    1084110 <check_input_resolve_range+0x1420>
 10840a6:	mov    0x108(%rdi),%rax
 10840ad:	mov    0x8(%rsp),%r8
 10840b2:	movl   $0x2,0x100(%rdi)
 10840bc:	test   %rax,%rax
 10840bf:	je     10840d7 <check_input_resolve_range+0x13e7>
 10840c1:	movb   $0x1,0x3c(%rax)
 10840c5:	mov    0x30(%rax),%rcx
 10840c9:	mov    %rcx,0x40(%rax)
 10840cd:	movl   $0x2,0x48(%rax)
 10840d4:	incl   0x34(%rax)
 10840d7:	mov    0x18(%r8),%rax
 10840db:	mov    (%rsp),%r13
 10840df:	mov    %r8,%rbx
 10840e2:	cmpl   $0x1,0x100(%rax)
 10840e9:	jne    1083340 <check_input_resolve_range+0x650>
 10840ef:	mov    (%rbx),%rax
 10840f2:	movb   $0x1,0x3c5(%rax)
 10840f9:	jmp    1083340 <check_input_resolve_range+0x650>
 10840fe:	movb   $0x1,0x3c5(%rax)
 1084105:	data16 cs nopw 0x0(%rax,%rax,1)
 1084110:	mov    0x10(%r12),%rcx
 1084115:	mov    0x50(%r12),%rax
 108411a:	movzbl (%rax,%rbp,1),%esi
 108411e:	movzbl (%rcx,%rbp,1),%edx
 1084122:	mov    %edx,0x3c(%rsp)
 1084126:	mov    %rsi,0x50(%rsp)
 108412b:	cmp    $0x2,%sil
 108412f:	jne    1084170 <check_input_resolve_range+0x1480>
 1084131:	mov    0x60(%r12),%rdx
 1084136:	mov    (%rdx,%rbp,4),%esi
 1084139:	cmp    0x30(%r12),%esi
 108413e:	jae    1084170 <check_input_resolve_range+0x1480>
 1084140:	movzbl (%rax,%rsi,1),%edx
 1084144:	mov    $0x1,%al
 1084146:	cmp    $0x21,%dl
 1084149:	je     1084172 <check_input_resolve_range+0x1482>
 108414b:	movzbl (%rcx,%rsi,1),%ecx
 108414f:	cmp    $0x4f,%cl
 1084152:	je     1084172 <check_input_resolve_range+0x1482>
 1084154:	xor    $0x9,%dl
 1084157:	xor    $0xf,%cl
 108415a:	or     %dl,%cl
 108415c:	sete   %al
 108415f:	jmp    1084172 <check_input_resolve_range+0x1482>
 1084161:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1084170:	xor    %eax,%eax
 1084172:	mov    0x50(%rsp),%rsi
 1084177:	mov    0x3c(%rsp),%edx
 108417b:	cmp    $0x21,%sil
 108417f:	sete   %cl
 1084182:	or     %al,%cl
 1084184:	cmp    $0x4f,%edx
 1084187:	sete   %al
 108418a:	cmp    $0x49,%edx
 108418d:	sete   %dl
 1084190:	or     %al,%dl
 1084192:	or     %cl,%dl
 1084194:	cmp    $0x3a,%sil
 1084198:	sete   %al
 108419b:	or     %dl,%al
 108419d:	mov    0x138(%rbx),%rdx
 10841a4:	or     %al,(%rdx,%rbp,1)
 10841a7:	cmp    $0x22,%sil
 10841ab:	jne    10842f0 <check_input_resolve_range+0x1600>
 10841b1:	mov    0x138(%rbx),%rax
 10841b8:	cmpb   $0x0,(%rax,%rbp,1)
 10841bc:	jne    10842f0 <check_input_resolve_range+0x1600>
 10841c2:	lea    0x1(%r13),%eax
 10841c6:	cmp    0x30(%r12),%eax
 10841cb:	jae    10842f0 <check_input_resolve_range+0x1600>
 10841d1:	mov    0x50(%r12),%rdx
 10841d6:	mov    %eax,%ecx
 10841d8:	cmpb   $0x33,(%rdx,%rcx,1)
 10841dc:	jne    10842f0 <check_input_resolve_range+0x1600>
 10841e2:	mov    0x8(%rbx),%rdx
 10841e6:	mov    0x30(%rdx),%r9d
 10841ea:	cmp    %r9d,0x3bc(%rbx)
 10841f1:	jae    108428b <check_input_resolve_range+0x159b>
 10841f7:	mov    0x60(%rdx),%rsi
 10841fb:	mov    (%rsi,%rbp,4),%eax
 10841fe:	cmp    %r9d,%eax
 1084201:	jae    108428b <check_input_resolve_range+0x159b>
 1084207:	mov    (%rsi,%rcx,4),%ecx
 108420a:	lea    0x1(%rcx),%esi
 108420d:	cmp    %eax,%esi
 108420f:	jne    108428b <check_input_resolve_range+0x159b>
 1084215:	mov    0x50(%rdx),%rsi
 1084219:	cmpb   $0x4c,(%rsi,%rcx,1)
 108421d:	jne    108428b <check_input_resolve_range+0x159b>
 108421f:	mov    0x370(%rbx),%r11
 1084226:	mov    (%r11,%rcx,4),%r10d
 108422a:	cmp    $0xffffffff,%r10d
 108422e:	je     108629e <check_input_resolve_range+0x35ae>
 1084234:	mov    0x378(%rbx),%r8
 108423b:	mov    $0xffffffff,%edi
 1084240:	mov    %r10d,%ebx
 1084243:	cmpb   $0x33,(%rsi,%rbx,1)
 1084247:	cmovne %r10d,%edi
 108424b:	mov    (%r8,%rbx,4),%r10d
 108424f:	cmp    $0xffffffff,%r10d
 1084253:	jne    1084240 <check_input_resolve_range+0x1550>
 1084255:	mov    $0xffffffff,%r10d
 108425b:	cmp    %r9d,%edi
 108425e:	jae    1088de0 <check_input_resolve_range+0x60f0>
 1084264:	mov    %edi,%r9d
 1084267:	cmpb   $0x1e,(%rsi,%r9,1)
 108426c:	jne    1088de0 <check_input_resolve_range+0x60f0>
 1084272:	mov    (%r11,%r9,4),%ebx
 1084276:	cmp    $0xffffffff,%ebx
 1084279:	je     1088de0 <check_input_resolve_range+0x60f0>
 108427f:	mov    0x10(%rdx),%r9
 1084283:	mov    $0x1,%bpl
 1084286:	jmp    10861c0 <check_input_resolve_range+0x34d0>
 108428b:	mov    (%rbx),%rax
 108428e:	mov    0x230(%rax),%ecx
 1084294:	cmp    0x234(%rax),%ecx
 108429a:	jae    10842df <check_input_resolve_range+0x15ef>
 108429c:	movzbl 0x3c5(%rax),%edx
 10842a3:	mov    0x228(%rax),%rsi
 10842aa:	lea    0x1(%rcx),%edi
 10842ad:	mov    %edi,0x230(%rax)
 10842b3:	lea    (%rcx,%rcx,2),%rax
 10842b7:	lea    0x1(%rdx,%rdx,2),%edx
 10842bb:	mov    %r13d,(%rsi,%rax,4)
 10842bf:	mov    %edx,0x4(%rsi,%rax,4)
 10842c3:	movl   $0x0,0x8(%rsi,%rax,4)
 10842cb:	mov    0x138(%rbx),%rax
 10842d2:	movzbl (%rax,%rbp,1),%eax
 10842d6:	test   %al,%al
 10842d8:	je     1084303 <check_input_resolve_range+0x1613>
 10842da:	jmp    1086aeb <check_input_resolve_range+0x3dfb>
 10842df:	movb   $0x1,0x3c5(%rax)
 10842e6:	cs nopw 0x0(%rax,%rax,1)
 10842f0:	mov    0x138(%rbx),%rax
 10842f7:	movzbl (%rax,%rbp,1),%eax
 10842fb:	test   %al,%al
 10842fd:	jne    1086aeb <check_input_resolve_range+0x3dfb>
 1084303:	cmpb   $0x3d,0x3c(%rsp)
 1084308:	jne    1086aeb <check_input_resolve_range+0x3dfb>
 108430e:	mov    0x8(%rbx),%rbp
 1084312:	lea    0x1(%r13),%edx
 1084316:	mov    $0xffffffff,%r11d
 108431c:	xor    %eax,%eax
 108431e:	mov    0x30(%rbp),%ecx
 1084321:	cmp    %ecx,%edx
 1084323:	jae    108433f <check_input_resolve_range+0x164f>
 1084325:	mov    0x10(%rbp),%rdi
 1084329:	mov    %edx,%esi
 108432b:	nopl   0x0(%rax,%rax,1)
 1084330:	cmpb   $0x8,(%rdi,%rsi,1)
 1084334:	je     1084343 <check_input_resolve_range+0x1653>
 1084336:	inc    %rsi
 1084339:	cmp    %esi,%ecx
 108433b:	jne    1084330 <check_input_resolve_range+0x1640>
 108433d:	jmp    1084370 <check_input_resolve_range+0x1680>
 108433f:	mov    %edx,%ecx
 1084341:	jmp    1084370 <check_input_resolve_range+0x1680>
 1084343:	mov    0x50(%rbp),%r8
 1084347:	mov    0x60(%rbp),%r9
 108434b:	mov    (%r9,%rsi,4),%r11d
 108434f:	cmpb   $0x2e,(%r8,%rsi,1)
 1084354:	jne    108436e <check_input_resolve_range+0x167e>
 1084356:	cmp    %ecx,%r11d
 1084359:	jae    108436e <check_input_resolve_range+0x167e>
 108435b:	lea    0x1(%r11),%r8
 108435f:	cmp    %ecx,%r8d
 1084362:	jae    108436e <check_input_resolve_range+0x167e>
 1084364:	xor    %eax,%eax
 1084366:	cmpb   $0x30,(%rdi,%r8,1)
 108436b:	sete   %al
 108436e:	mov    %esi,%ecx
 1084370:	mov    (%rbx),%r14
 1084373:	xor    %esi,%esi
 1084375:	mov    %r11,0x30(%rsp)
 108437a:	mov    0x348(%r14),%r15d
 1084381:	movzbl 0x3c5(%r14),%edi
 1084389:	cmp    0x34c(%r14),%r15d
 1084390:	setae  %sil
 1084394:	or     %edi,%esi
 1084396:	mov    %sil,0x3c5(%r14)
 108439d:	xor    $0x1,%esi
 10843a0:	test   %esi,%eax
 10843a2:	je     108443a <check_input_resolve_range+0x174a>
 10843a8:	mov    0x28(%rbx),%rax
 10843ac:	mov    0x340(%r14),%rsi
 10843b3:	lea    (%r15,%r15,4),%rdi
 10843b7:	lea    0x1(%r11),%r8d
 10843bb:	vpxor  %xmm0,%xmm0,%xmm0
 10843bf:	shl    $0x4,%rdi
 10843c3:	mov    0x8(%rax),%rax
 10843c7:	lea    (%rsi,%rdi,1),%r12
 10843cb:	mov    %rax,0xe8(%rsp)
 10843d3:	lea    0x1(%rcx),%eax
 10843d6:	mov    %eax,0x130(%rsp)
 10843dd:	mov    0x3bc(%rbx),%r9d
 10843e4:	vmovdqu %ymm0,0x18(%rsi,%rdi,1)
 10843ea:	vmovdqu %ymm0,(%rsi,%rdi,1)
 10843ef:	mov    %r13d,0x38(%rsi,%rdi,1)
 10843f4:	mov    %r11d,0x3c(%rsi,%rdi,1)
 10843f9:	mov    %r8d,0x40(%rsi,%rdi,1)
 10843fe:	mov    %r9d,0x44(%rsi,%rdi,1)
 1084403:	movq   $0x0,0x48(%rsi,%rdi,1)
 108440c:	cmp    %ecx,%edx
 108440e:	jae    1084630 <check_input_resolve_range+0x1940>
 1084414:	mov    %r13d,%esi
 1084417:	sub    %ecx,%esi
 1084419:	mov    %ecx,%edi
 108441b:	sub    %r13d,%edi
 108441e:	mov    %edx,%edx
 1084420:	not    %esi
 1084422:	add    $0xfffffffe,%edi
 1084425:	and    $0x3,%esi
 1084428:	cmp    $0x3,%edi
 108442b:	jae    1084480 <check_input_resolve_range+0x1790>
 108442d:	xor    %edi,%edi
 108442f:	xor    %r8d,%r8d
 1084432:	xor    %r10d,%r10d
 1084435:	jmp    10845f0 <check_input_resolve_range+0x1900>
 108443a:	mov    0x28(%rbx),%rax
 108443e:	inc    %ecx
 1084440:	inc    %r15d
 1084443:	movq   $0x0,0x90(%rsp)
 108444f:	movq   $0x0,0x58(%rsp)
 1084458:	xor    %r12d,%r12d
 108445b:	movq   $0x0,0x70(%rsp)
 1084464:	xor    %edx,%edx
 1084466:	mov    0x8(%rax),%rax
 108446a:	mov    %ecx,0x130(%rsp)
 1084471:	mov    %rax,0xe8(%rsp)
 1084479:	xor    %eax,%eax
 108447b:	jmp    10849d0 <check_input_resolve_range+0x1ce0>
 1084480:	mov    %r13d,%edi
 1084483:	not    %edi
 1084485:	xor    %r9d,%r9d
 1084488:	xor    %r8d,%r8d
 108448b:	xor    %r10d,%r10d
 108448e:	add    %edi,%ecx
 1084490:	xor    %edi,%edi
 1084492:	and    $0xfffffffc,%ecx
 1084495:	data16 cs nopw 0x0(%rax,%rax,1)
 10844a0:	mov    0x10(%rbp),%r11
 10844a4:	add    %rdx,%r11
 10844a7:	cmpb   $0x37,(%r9,%r11,1)
 10844ac:	sete   %r11b
 10844b0:	or     %r11b,%r10b
 10844b3:	mov    %r10b,0x49(%r12)
 10844b8:	mov    0x10(%rbp),%r11
 10844bc:	add    %rdx,%r11
 10844bf:	cmpb   $0x3a,(%r9,%r11,1)
 10844c4:	sete   %r11b
 10844c8:	or     %r11b,%r8b
 10844cb:	mov    %r8b,0x4a(%r12)
 10844d0:	mov    0x10(%rbp),%r11
 10844d4:	add    %rdx,%r11
 10844d7:	cmpb   $0x4f,(%r9,%r11,1)
 10844dc:	sete   %r11b
 10844e0:	or     %r11b,%dil
 10844e3:	mov    %dil,0x4b(%r12)
 10844e8:	mov    0x10(%rbp),%r11
 10844ec:	add    %rdx,%r11
 10844ef:	cmpb   $0x37,0x1(%r9,%r11,1)
 10844f5:	sete   %r11b
 10844f9:	or     %r10b,%r11b
 10844fc:	mov    %r11b,0x49(%r12)
 1084501:	mov    0x10(%rbp),%r10
 1084505:	add    %rdx,%r10
 1084508:	cmpb   $0x3a,0x1(%r9,%r10,1)
 108450e:	sete   %r10b
 1084512:	or     %r8b,%r10b
 1084515:	mov    %r10b,0x4a(%r12)
 108451a:	mov    0x10(%rbp),%r8
 108451e:	add    %rdx,%r8
 1084521:	cmpb   $0x4f,0x1(%r9,%r8,1)
 1084527:	sete   %r8b
 108452b:	or     %dil,%r8b
 108452e:	mov    %r8b,0x4b(%r12)
 1084533:	mov    0x10(%rbp),%rdi
 1084537:	add    %rdx,%rdi
 108453a:	cmpb   $0x37,0x2(%r9,%rdi,1)
 1084540:	sete   %dil
 1084544:	or     %r11b,%dil
 1084547:	mov    %dil,0x49(%r12)
 108454c:	mov    0x10(%rbp),%r11
 1084550:	add    %rdx,%r11
 1084553:	cmpb   $0x3a,0x2(%r9,%r11,1)
 1084559:	sete   %r11b
 108455d:	or     %r10b,%r11b
 1084560:	mov    %r11b,0x4a(%r12)
 1084565:	mov    0x10(%rbp),%r10
 1084569:	add    %rdx,%r10
 108456c:	cmpb   $0x4f,0x2(%r9,%r10,1)
 1084572:	sete   %bl
 1084575:	or     %r8b,%bl
 1084578:	mov    %bl,0x4b(%r12)
 108457d:	mov    0x10(%rbp),%r8
 1084581:	add    %rdx,%r8
 1084584:	cmpb   $0x37,0x3(%r9,%r8,1)
 108458a:	sete   %r10b
 108458e:	or     %dil,%r10b
 1084591:	mov    %r10b,0x49(%r12)
 1084596:	mov    0x10(%rbp),%rdi
 108459a:	add    %rdx,%rdi
 108459d:	cmpb   $0x3a,0x3(%r9,%rdi,1)
 10845a3:	sete   %r8b
 10845a7:	or     %r11b,%r8b
 10845aa:	mov    %r8b,0x4a(%r12)
 10845af:	mov    0x10(%rbp),%rdi
 10845b3:	add    %rdx,%rdi
 10845b6:	cmpb   $0x4f,0x3(%r9,%rdi,1)
 10845bc:	sete   %dil
 10845c0:	add    $0x4,%r9
 10845c4:	or     %bl,%dil
 10845c7:	mov    %dil,0x4b(%r12)
 10845cc:	cmp    %r9d,%ecx
 10845cf:	jne    10844a0 <check_input_resolve_range+0x17b0>
 10845d5:	mov    0x8(%rsp),%rbx
 10845da:	mov    0x30(%rsp),%r11
 10845df:	test   %esi,%esi
 10845e1:	je     1084630 <check_input_resolve_range+0x1940>
 10845e3:	add    %r9,%rdx
 10845e6:	cs nopw 0x0(%rax,%rax,1)
 10845f0:	mov    0x10(%rbp),%rcx
 10845f4:	cmpb   $0x37,(%rcx,%rdx,1)
 10845f8:	sete   %cl
 10845fb:	or     %cl,%r10b
 10845fe:	mov    %r10b,0x49(%r12)
 1084603:	mov    0x10(%rbp),%rcx
 1084607:	cmpb   $0x3a,(%rcx,%rdx,1)
 108460b:	sete   %cl
 108460e:	or     %cl,%r8b
 1084611:	mov    %r8b,0x4a(%r12)
 1084616:	mov    0x10(%rbp),%rcx
 108461a:	cmpb   $0x4f,(%rcx,%rdx,1)
 108461e:	sete   %cl
 1084621:	inc    %rdx
 1084624:	or     %cl,%dil
 1084627:	dec    %esi
 1084629:	mov    %dil,0x4b(%r12)
 108462e:	jne    10845f0 <check_input_resolve_range+0x1900>
 1084630:	inc    %r15d
 1084633:	cmp    %eax,%r13d
 1084636:	jae    1084773 <check_input_resolve_range+0x1a83>
 108463c:	mov    0x28(%rsp),%rcx
 1084641:	mov    %eax,%edx
 1084643:	sub    %ecx,%edx
 1084645:	and    $0x7,%edx
 1084648:	je     1084671 <check_input_resolve_range+0x1981>
 108464a:	mov    0x28(%rsp),%rcx
 108464f:	nop
 1084650:	mov    0x138(%rbx),%rsi
 1084657:	movb   $0x1,(%rsi,%rcx,1)
 108465b:	mov    (%rbx),%rsi
 108465e:	mov    0x350(%rsi),%rsi
 1084665:	mov    %r15d,(%rsi,%rcx,4)
 1084669:	inc    %rcx
 108466c:	dec    %rdx
 108466f:	jne    1084650 <check_input_resolve_range+0x1960>
 1084671:	mov    0x28(%rsp),%rdx
 1084676:	mov    %eax,%eax
 1084678:	sub    %rax,%rdx
 108467b:	cmp    $0xfffffffffffffff8,%rdx
 108467f:	ja     1084773 <check_input_resolve_range+0x1a83>
 1084685:	data16 cs nopw 0x0(%rax,%rax,1)
 1084690:	mov    0x138(%rbx),%rdx
 1084697:	movb   $0x1,(%rdx,%rcx,1)
 108469b:	mov    (%rbx),%rdx
 108469e:	mov    0x350(%rdx),%rdx
 10846a5:	mov    %r15d,(%rdx,%rcx,4)
 10846a9:	mov    0x138(%rbx),%rdx
 10846b0:	movb   $0x1,0x1(%rdx,%rcx,1)
 10846b5:	mov    (%rbx),%rdx
 10846b8:	mov    0x350(%rdx),%rdx
 10846bf:	mov    %r15d,0x4(%rdx,%rcx,4)
 10846c4:	mov    0x138(%rbx),%rdx
 10846cb:	movb   $0x1,0x2(%rdx,%rcx,1)
 10846d0:	mov    (%rbx),%rdx
 10846d3:	mov    0x350(%rdx),%rdx
 10846da:	mov    %r15d,0x8(%rdx,%rcx,4)
 10846df:	mov    0x138(%rbx),%rdx
 10846e6:	movb   $0x1,0x3(%rdx,%rcx,1)
 10846eb:	mov    (%rbx),%rdx
 10846ee:	mov    0x350(%rdx),%rdx
 10846f5:	mov    %r15d,0xc(%rdx,%rcx,4)
 10846fa:	mov    0x138(%rbx),%rdx
 1084701:	movb   $0x1,0x4(%rdx,%rcx,1)
 1084706:	mov    (%rbx),%rdx
 1084709:	mov    0x350(%rdx),%rdx
 1084710:	mov    %r15d,0x10(%rdx,%rcx,4)
 1084715:	mov    0x138(%rbx),%rdx
 108471c:	movb   $0x1,0x5(%rdx,%rcx,1)
 1084721:	mov    (%rbx),%rdx
 1084724:	mov    0x350(%rdx),%rdx
 108472b:	mov    %r15d,0x14(%rdx,%rcx,4)
 1084730:	mov    0x138(%rbx),%rdx
 1084737:	movb   $0x1,0x6(%rdx,%rcx,1)
 108473c:	mov    (%rbx),%rdx
 108473f:	mov    0x350(%rdx),%rdx
 1084746:	mov    %r15d,0x18(%rdx,%rcx,4)
 108474b:	mov    0x138(%rbx),%rdx
 1084752:	movb   $0x1,0x7(%rdx,%rcx,1)
 1084757:	mov    (%rbx),%rdx
 108475a:	mov    0x350(%rdx),%rdx
 1084761:	mov    %r15d,0x1c(%rdx,%rcx,4)
 1084766:	add    $0x8,%rcx
 108476a:	cmp    %rcx,%rax
 108476d:	jne    1084690 <check_input_resolve_range+0x19a0>
 1084773:	cmp    $0xfffffffd,%r11d
 1084777:	ja     10847bd <check_input_resolve_range+0x1acd>
 1084779:	mov    0x138(%rbx),%rdx
 1084780:	mov    %r11d,%eax
 1084783:	lea    0x2(%r11),%ecx
 1084787:	lea    0x1(%rax),%rsi
 108478b:	movb   $0x1,(%rdx,%rax,1)
 108478f:	mov    (%rbx),%rdx
 1084792:	mov    0x350(%rdx),%rdx
 1084799:	mov    %r15d,(%rdx,%rax,4)
 108479d:	cmp    %rcx,%rsi
 10847a0:	je     10847bd <check_input_resolve_range+0x1acd>
 10847a2:	mov    0x138(%rbx),%rcx
 10847a9:	movb   $0x1,0x1(%rcx,%rax,1)
 10847ae:	mov    (%rbx),%rcx
 10847b1:	mov    0x350(%rcx),%rcx
 10847b8:	mov    %r15d,0x4(%rcx,%rax,4)
 10847bd:	lea    0x130(%rsp),%rsi
 10847c5:	mov    %rbx,%rdi
 10847c8:	mov    %r11d,%edx
 10847cb:	mov    %r15d,%ecx
 10847ce:	mov    %r12,%r8
 10847d1:	vzeroupper
 10847d4:	call   10ea1a0 <check_input_asm_text>
 10847d9:	mov    0x30(%rsp),%r11
 10847de:	mov    0x130(%rsp),%ecx
 10847e5:	mov    %r11d,%edx
 10847e8:	sub    %ecx,%edx
 10847ea:	setne  %sil
 10847ee:	and    %al,%sil
 10847f1:	cmp    $0x1,%sil
 10847f5:	jne    1084874 <check_input_resolve_range+0x1b84>
 10847f7:	mov    0x28(%rbx),%rax
 10847fb:	vpbroadcastq -0xad81b5(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1084805:	vpbroadcastd -0xad89ce(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 108480e:	vpbroadcastq -0xad81b8(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1084818:	vpbroadcastd -0xad89e2(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1084822:	vpbroadcastq -0xad81d4(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 108482c:	mov    %rdx,%r8
 108482f:	shl    $0x4,%r8
 1084833:	mov    (%rax),%rsi
 1084836:	mov    0x8(%rax),%rdi
 108483a:	lea    0x7(%rdi,%rsi,1),%r10
 108483f:	add    %rsi,%rdi
 1084842:	and    $0xfffffffffffffff8,%r10
 1084846:	mov    %r10,%r9
 1084849:	sub    %rsi,%r9
 108484c:	mov    %r10,0x70(%rsp)
 1084851:	cmp    %rdi,%r10
 1084854:	jae    10848ca <check_input_resolve_range+0x1bda>
 1084856:	movq   $0x0,0x58(%rsp)
 108485f:	mov    0x30(%rsp),%r11
 1084864:	cmp    %rdi,0x70(%rsp)
 1084869:	jb     108494e <check_input_resolve_range+0x1c5e>
 108486f:	jmp    108491c <check_input_resolve_range+0x1c2c>
 1084874:	vpbroadcastq -0xad822e(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 108487e:	vpbroadcastd -0xad8a47(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1084887:	vpbroadcastq -0xad8231(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1084891:	vpbroadcastd -0xad8a5b(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 108489b:	vpbroadcastq -0xad824d(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10848a5:	movq   $0x0,0x90(%rsp)
 10848b1:	movq   $0x0,0x58(%rsp)
 10848ba:	movq   $0x0,0x70(%rsp)
 10848c3:	xor    %edx,%edx
 10848c5:	jmp    10849d0 <check_input_resolve_range+0x1ce0>
 10848ca:	mov    0x10(%rax),%r10
 10848ce:	sub    %r9,%r10
 10848d1:	jb     1084856 <check_input_resolve_range+0x1b66>
 10848d3:	lea    (%r8,%r8,2),%r11
 10848d7:	cmp    %r10,%r11
 10848da:	ja     1084856 <check_input_resolve_range+0x1b66>
 10848e0:	add    %r11,%r9
 10848e3:	mov    0x70(%rsp),%rsi
 10848e8:	mov    %r9,0x8(%rax)
 10848ec:	mov    0x28(%rbx),%rax
 10848f0:	mov    %rsi,0x58(%rsp)
 10848f5:	mov    (%rax),%rsi
 10848f8:	mov    0x8(%rax),%rdi
 10848fc:	lea    0x7(%rdi,%rsi,1),%r9
 1084901:	add    %rsi,%rdi
 1084904:	and    $0xfffffffffffffff8,%r9
 1084908:	mov    %r9,0x70(%rsp)
 108490d:	sub    %rsi,%r9
 1084910:	mov    0x30(%rsp),%r11
 1084915:	cmp    %rdi,0x70(%rsp)
 108491a:	jb     108494e <check_input_resolve_range+0x1c5e>
 108491c:	mov    0x10(%rax),%r10
 1084920:	sub    %r9,%r10
 1084923:	jb     108494e <check_input_resolve_range+0x1c5e>
 1084925:	cmp    %r10,%r8
 1084928:	ja     108494e <check_input_resolve_range+0x1c5e>
 108492a:	add    %r8,%r9
 108492d:	mov    %r9,0x8(%rax)
 1084931:	mov    0x28(%rbx),%rax
 1084935:	mov    (%rax),%rsi
 1084938:	mov    0x8(%rax),%rdi
 108493c:	add    %rsi,%rdi
 108493f:	lea    0x3(%rdi),%r8
 1084943:	and    $0xfffffffffffffffc,%r8
 1084947:	cmp    %rdi,%r8
 108494a:	jb     108499f <check_input_resolve_range+0x1caf>
 108494c:	jmp    1084964 <check_input_resolve_range+0x1c74>
 108494e:	movq   $0x0,0x70(%rsp)
 1084957:	lea    0x3(%rdi),%r8
 108495b:	and    $0xfffffffffffffffc,%r8
 108495f:	cmp    %rdi,%r8
 1084962:	jb     108499f <check_input_resolve_range+0x1caf>
 1084964:	mov    %r8,%rdi
 1084967:	sub    %rsi,%rdi
 108496a:	mov    0x10(%rax),%rsi
 108496e:	sub    %rdi,%rsi
 1084971:	jb     108499f <check_input_resolve_range+0x1caf>
 1084973:	shl    $0x2,%rdx
 1084977:	mov    $0x0,%r9d
 108497d:	lea    (%rdx,%rdx,2),%rdx
 1084981:	mov    %r9,0x90(%rsp)
 1084989:	cmp    %rsi,%rdx
 108498c:	ja     10849ab <check_input_resolve_range+0x1cbb>
 108498e:	add    %rdx,%rdi
 1084991:	mov    %r8,0x90(%rsp)
 1084999:	mov    %rdi,0x8(%rax)
 108499d:	jmp    10849ab <check_input_resolve_range+0x1cbb>
 108499f:	movq   $0x0,0x90(%rsp)
 10849ab:	cmpq   $0x0,0x58(%rsp)
 10849b1:	mov    $0x1,%edx
 10849b6:	mov    $0x1,%al
 10849b8:	je     10849d0 <check_input_resolve_range+0x1ce0>
 10849ba:	cmpq   $0x0,0x70(%rsp)
 10849c0:	je     10849d0 <check_input_resolve_range+0x1ce0>
 10849c2:	xor    %edx,%edx
 10849c4:	cmpq   $0x0,0x90(%rsp)
 10849cd:	sete   %dl
 10849d0:	movzbl 0x3c5(%r14),%esi
 10849d8:	mov    %r12,0x10(%rsp)
 10849dd:	mov    %r14,0xf0(%rsp)
 10849e5:	or     %edx,%esi
 10849e7:	sete   %dl
 10849ea:	mov    %sil,0x3c5(%r14)
 10849f1:	and    %al,%dl
 10849f3:	cmp    %r11d,%ecx
 10849f6:	setb   %r9b
 10849fa:	and    %dl,%r9b
 10849fd:	cmp    $0x1,%r9b
 1084a01:	jne    1085502 <check_input_resolve_range+0x2812>
 1084a07:	mov    0x10(%rbp),%rdx
 1084a0b:	mov    %ecx,%eax
 1084a0d:	mov    %r13d,0x24(%rsp)
 1084a12:	cmpb   $0x2f,(%rdx,%rax,1)
 1084a16:	jne    1086a70 <check_input_resolve_range+0x3d80>
 1084a1c:	xor    %esi,%esi
 1084a1e:	mov    %r13d,0x24(%rsp)
 1084a23:	mov    %r9b,0x18(%rsp)
 1084a28:	lea    0x1(%rcx),%r13d
 1084a2c:	mov    %esi,%edx
 1084a2e:	mov    %rax,%rsi
 1084a31:	mov    %r13d,%edi
 1084a34:	sub    %eax,%edi
 1084a36:	and    $0x7,%edi
 1084a39:	je     1084a62 <check_input_resolve_range+0x1d72>
 1084a3b:	mov    %rax,%rsi
 1084a3e:	xchg   %ax,%ax
 1084a40:	mov    0x138(%rbx),%r8
 1084a47:	movb   $0x1,(%r8,%rsi,1)
 1084a4c:	mov    (%rbx),%r8
 1084a4f:	mov    0x350(%r8),%r8
 1084a56:	mov    %r15d,(%r8,%rsi,4)
 1084a5a:	inc    %rsi
 1084a5d:	dec    %rdi
 1084a60:	jne    1084a40 <check_input_resolve_range+0x1d50>
 1084a62:	mov    %ecx,%ecx
 1084a64:	sub    %rax,%rcx
 1084a67:	cmp    $0x7,%rcx
 1084a6b:	jb     1084b63 <check_input_resolve_range+0x1e73>
 1084a71:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1084a80:	mov    0x138(%rbx),%rax
 1084a87:	movb   $0x1,(%rax,%rsi,1)
 1084a8b:	mov    (%rbx),%rax
 1084a8e:	mov    0x350(%rax),%rax
 1084a95:	mov    %r15d,(%rax,%rsi,4)
 1084a99:	mov    0x138(%rbx),%rax
 1084aa0:	movb   $0x1,0x1(%rax,%rsi,1)
 1084aa5:	mov    (%rbx),%rax
 1084aa8:	mov    0x350(%rax),%rax
 1084aaf:	mov    %r15d,0x4(%rax,%rsi,4)
 1084ab4:	mov    0x138(%rbx),%rax
 1084abb:	movb   $0x1,0x2(%rax,%rsi,1)
 1084ac0:	mov    (%rbx),%rax
 1084ac3:	mov    0x350(%rax),%rax
 1084aca:	mov    %r15d,0x8(%rax,%rsi,4)
 1084acf:	mov    0x138(%rbx),%rax
 1084ad6:	movb   $0x1,0x3(%rax,%rsi,1)
 1084adb:	mov    (%rbx),%rax
 1084ade:	mov    0x350(%rax),%rax
 1084ae5:	mov    %r15d,0xc(%rax,%rsi,4)
 1084aea:	mov    0x138(%rbx),%rax
 1084af1:	movb   $0x1,0x4(%rax,%rsi,1)
 1084af6:	mov    (%rbx),%rax
 1084af9:	mov    0x350(%rax),%rax
 1084b00:	mov    %r15d,0x10(%rax,%rsi,4)
 1084b05:	mov    0x138(%rbx),%rax
 1084b0c:	movb   $0x1,0x5(%rax,%rsi,1)
 1084b11:	mov    (%rbx),%rax
 1084b14:	mov    0x350(%rax),%rax
 1084b1b:	mov    %r15d,0x14(%rax,%rsi,4)
 1084b20:	mov    0x138(%rbx),%rax
 1084b27:	movb   $0x1,0x6(%rax,%rsi,1)
 1084b2c:	mov    (%rbx),%rax
 1084b2f:	mov    0x350(%rax),%rax
 1084b36:	mov    %r15d,0x18(%rax,%rsi,4)
 1084b3b:	mov    0x138(%rbx),%rax
 1084b42:	movb   $0x1,0x7(%rax,%rsi,1)
 1084b47:	mov    (%rbx),%rax
 1084b4a:	mov    0x350(%rax),%rax
 1084b51:	mov    %r15d,0x1c(%rax,%rsi,4)
 1084b56:	add    $0x8,%rsi
 1084b5a:	cmp    %rsi,%r13
 1084b5d:	jne    1084a80 <check_input_resolve_range+0x1d90>
 1084b63:	lea    0x1(%rdx),%esi
 1084b66:	xor    %eax,%eax
 1084b68:	mov    %r13d,0x130(%rsp)
 1084b70:	cmp    $0x2,%esi
 1084b73:	sete   %cl
 1084b76:	cmp    %r11d,%r13d
 1084b79:	jae    1086a43 <check_input_resolve_range+0x3d53>
 1084b7f:	mov    %esi,0x40(%rsp)
 1084b83:	cmp    $0x1,%edx
 1084b86:	ja     1084f60 <check_input_resolve_range+0x2270>
 1084b8c:	mov    0x10(%rsp),%r12
 1084b91:	xor    $0x1,%edx
 1084b94:	mov    %cl,%al
 1084b96:	mov    $0x1,%cl
 1084b98:	vmovd  %edx,%xmm0
 1084b9c:	vpinsrd $0x1,%eax,%xmm0,%xmm0
 1084ba2:	vmovdqa %xmm0,0x60(%rsp)
 1084ba8:	jmp    1084bde <check_input_resolve_range+0x1eee>
 1084baa:	nopw   0x0(%rax,%rax,1)
 1084bb0:	mov    0x1c(%r14),%r13d
 1084bb4:	inc    %r13d
 1084bb7:	mov    %r13d,0x130(%rsp)
 1084bbf:	xor    %ecx,%ecx
 1084bc1:	vmovq  0x28(%r12),%xmm0
 1084bc8:	vpaddd 0x60(%rsp),%xmm0,%xmm0
 1084bce:	vmovq  %xmm0,0x28(%r12)
 1084bd5:	cmp    %r11d,%r13d
 1084bd8:	jae    1086277 <check_input_resolve_range+0x3587>
 1084bde:	mov    0x10(%rbp),%rdx
 1084be2:	mov    %r13d,%eax
 1084be5:	movzbl (%rdx,%rax,1),%edx
 1084be9:	cmp    $0x2f,%dl
 1084bec:	je     1084f7c <check_input_resolve_range+0x228c>
 1084bf2:	test   $0x1,%cl
 1084bf5:	jne    1084c24 <check_input_resolve_range+0x1f34>
 1084bf7:	cmp    $0x33,%dl
 1084bfa:	jne    10868b9 <check_input_resolve_range+0x3bc9>
 1084c00:	mov    0x138(%rbx),%rcx
 1084c07:	inc    %r13d
 1084c0a:	movb   $0x1,(%rcx,%rax,1)
 1084c0e:	mov    (%rbx),%rcx
 1084c11:	mov    0x350(%rcx),%rcx
 1084c18:	mov    %r15d,(%rcx,%rax,4)
 1084c1c:	mov    %r13d,0x130(%rsp)
 1084c24:	mov    0x2c(%r12),%eax
 1084c29:	mov    0x58(%rsp),%rcx
 1084c2e:	vpxor  %xmm0,%xmm0,%xmm0
 1084c32:	add    0x28(%r12),%eax
 1084c37:	lea    (%rax,%rax,2),%rax
 1084c3b:	shl    $0x4,%rax
 1084c3f:	vmovdqu %xmm0,(%rcx,%rax,1)
 1084c44:	movl   $0x0,0x10(%rcx,%rax,1)
 1084c4c:	mov    %r13d,0x14(%rcx,%rax,1)
 1084c51:	movq   $0x0,0x18(%rcx,%rax,1)
 1084c5a:	movq   $0xffffffffffffffff,0x20(%rcx,%rax,1)
 1084c63:	movq   $0x0,0x28(%rcx,%rax,1)
 1084c6c:	lea    (%rcx,%rax,1),%r14
 1084c70:	mov    (%rsp),%r13
 1084c74:	mov    0x130(%rsp),%ecx
 1084c7b:	cmp    %r11d,%ecx
 1084c7e:	jae    1084d40 <check_input_resolve_range+0x2050>
 1084c84:	mov    0x10(%rbp),%rax
 1084c88:	cmpb   $0x6,(%rax,%rcx,1)
 1084c8c:	jne    1084d40 <check_input_resolve_range+0x2050>
 1084c92:	lea    0x2(%rcx),%edx
 1084c95:	cmp    %r11d,%edx
 1084c98:	jae    1084d9b <check_input_resolve_range+0x20ab>
 1084c9e:	cmpb   $0x2,0x1(%rcx,%rax,1)
 1084ca3:	jne    1084d9b <check_input_resolve_range+0x20ab>
 1084ca9:	mov    %edx,%edx
 1084cab:	cmpb   $0x7,(%rax,%rdx,1)
 1084caf:	jne    1084d9b <check_input_resolve_range+0x20ab>
 1084cb5:	mov    0x18(%rbp),%rax
 1084cb9:	mov    0x4(%rax,%rcx,4),%eax
 1084cbd:	mov    %eax,0x10(%r14)
 1084cc1:	mov    0x130(%rsp),%eax
 1084cc8:	mov    %eax,%ecx
 1084cca:	sub    $0xfffffffd,%ecx
 1084ccd:	jae    1084d32 <check_input_resolve_range+0x2042>
 1084ccf:	mov    0x138(%rbx),%rsi
 1084cd6:	lea    0x1(%rax),%rdi
 1084cda:	mov    %ecx,%edx
 1084cdc:	movb   $0x1,(%rsi,%rax,1)
 1084ce0:	mov    (%rbx),%rsi
 1084ce3:	mov    0x350(%rsi),%rsi
 1084cea:	mov    %r15d,(%rsi,%rax,4)
 1084cee:	cmp    %rdx,%rdi
 1084cf1:	je     1084d32 <check_input_resolve_range+0x2042>
 1084cf3:	mov    0x138(%rbx),%rsi
 1084cfa:	lea    0x2(%rax),%rdi
 1084cfe:	movb   $0x1,0x1(%rsi,%rax,1)
 1084d03:	mov    (%rbx),%rsi
 1084d06:	mov    0x350(%rsi),%rsi
 1084d0d:	mov    %r15d,0x4(%rsi,%rax,4)
 1084d12:	cmp    %rdx,%rdi
 1084d15:	je     1084d32 <check_input_resolve_range+0x2042>
 1084d17:	mov    0x138(%rbx),%rdx
 1084d1e:	movb   $0x1,0x2(%rdx,%rax,1)
 1084d23:	mov    (%rbx),%rdx
 1084d26:	mov    0x350(%rdx),%rdx
 1084d2d:	mov    %r15d,0x8(%rdx,%rax,4)
 1084d32:	mov    %ecx,0x130(%rsp)
 1084d39:	nopl   0x0(%rax)
 1084d40:	lea    0x130(%rsp),%rsi
 1084d48:	mov    %rbx,%rdi
 1084d4b:	mov    %r11d,%edx
 1084d4e:	mov    %r15d,%ecx
 1084d51:	mov    %r14,%r8
 1084d54:	vzeroupper
 1084d57:	call   10ea1a0 <check_input_asm_text>
 1084d5c:	vpbroadcastq -0xad870e(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1084d66:	vpbroadcastd -0xad8f30(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1084d70:	vpbroadcastq -0xad871a(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1084d7a:	vpbroadcastd -0xad8f43(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1084d83:	vpbroadcastq -0xad873d(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1084d8d:	mov    0x30(%rsp),%r11
 1084d92:	mov    0x130(%rsp),%ecx
 1084d99:	jmp    1084d9d <check_input_resolve_range+0x20ad>
 1084d9b:	xor    %eax,%eax
 1084d9d:	mov    %ecx,0x18(%r14)
 1084da1:	mov    $0xffffffff,%ecx
 1084da6:	mov    0x130(%rsp),%edx
 1084dad:	cmp    %r11d,%edx
 1084db0:	jae    1084db9 <check_input_resolve_range+0x20c9>
 1084db2:	mov    0x60(%rbp),%rcx
 1084db6:	mov    (%rcx,%rdx,4),%ecx
 1084db9:	mov    %ecx,0x1c(%r14)
 1084dbd:	test   %al,%al
 1084dbf:	je     1086a70 <check_input_resolve_range+0x3d80>
 1084dc5:	mov    0x130(%rsp),%eax
 1084dcc:	cmp    %r11d,%eax
 1084dcf:	jae    1086a70 <check_input_resolve_range+0x3d80>
 1084dd5:	mov    0x10(%rbp),%rdx
 1084dd9:	cmpb   $0x8,(%rdx,%rax,1)
 1084ddd:	jne    1086a70 <check_input_resolve_range+0x3d80>
 1084de3:	cmp    %r11d,%ecx
 1084de6:	jae    1086a70 <check_input_resolve_range+0x3d80>
 1084dec:	lea    0x1(%rax),%edx
 1084def:	cmp    %edx,%ecx
 1084df1:	jbe    1086a70 <check_input_resolve_range+0x3d80>
 1084df7:	mov    0x138(%rbx),%rcx
 1084dfe:	movb   $0x1,(%rcx,%rax,1)
 1084e02:	mov    (%rbx),%rcx
 1084e05:	mov    0x350(%rcx),%rcx
 1084e0c:	mov    %r15d,(%rcx,%rax,4)
 1084e10:	mov    $0xffffffff,%ecx
 1084e15:	mov    0x1c(%r14),%eax
 1084e19:	cmp    %rcx,%rax
 1084e1c:	je     1084f58 <check_input_resolve_range+0x2268>
 1084e22:	lea    0x1(%rax),%rcx
 1084e26:	mov    %ecx,%edx
 1084e28:	sub    %eax,%edx
 1084e2a:	test   $0x7,%dl
 1084e2d:	je     1084e61 <check_input_resolve_range+0x2171>
 1084e2f:	mov    $0x1,%edx
 1084e34:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1084e40:	mov    0x138(%rbx),%rsi
 1084e47:	movb   $0x1,(%rsi,%rax,1)
 1084e4b:	mov    (%rbx),%rsi
 1084e4e:	mov    0x350(%rsi),%rsi
 1084e55:	mov    %r15d,(%rsi,%rax,4)
 1084e59:	inc    %rax
 1084e5c:	dec    %rdx
 1084e5f:	jne    1084e40 <check_input_resolve_range+0x2150>
 1084e61:	mov    $0x1,%dl
 1084e63:	test   %dl,%dl
 1084e65:	jne    1084bb0 <check_input_resolve_range+0x1ec0>
 1084e6b:	nopl   0x0(%rax,%rax,1)
 1084e70:	mov    0x138(%rbx),%rdx
 1084e77:	movb   $0x1,(%rdx,%rax,1)
 1084e7b:	mov    (%rbx),%rdx
 1084e7e:	mov    0x350(%rdx),%rdx
 1084e85:	mov    %r15d,(%rdx,%rax,4)
 1084e89:	mov    0x138(%rbx),%rdx
 1084e90:	movb   $0x1,0x1(%rdx,%rax,1)
 1084e95:	mov    (%rbx),%rdx
 1084e98:	mov    0x350(%rdx),%rdx
 1084e9f:	mov    %r15d,0x4(%rdx,%rax,4)
 1084ea4:	mov    0x138(%rbx),%rdx
 1084eab:	movb   $0x1,0x2(%rdx,%rax,1)
 1084eb0:	mov    (%rbx),%rdx
 1084eb3:	mov    0x350(%rdx),%rdx
 1084eba:	mov    %r15d,0x8(%rdx,%rax,4)
 1084ebf:	mov    0x138(%rbx),%rdx
 1084ec6:	movb   $0x1,0x3(%rdx,%rax,1)
 1084ecb:	mov    (%rbx),%rdx
 1084ece:	mov    0x350(%rdx),%rdx
 1084ed5:	mov    %r15d,0xc(%rdx,%rax,4)
 1084eda:	mov    0x138(%rbx),%rdx
 1084ee1:	movb   $0x1,0x4(%rdx,%rax,1)
 1084ee6:	mov    (%rbx),%rdx
 1084ee9:	mov    0x350(%rdx),%rdx
 1084ef0:	mov    %r15d,0x10(%rdx,%rax,4)
 1084ef5:	mov    0x138(%rbx),%rdx
 1084efc:	movb   $0x1,0x5(%rdx,%rax,1)
 1084f01:	mov    (%rbx),%rdx
 1084f04:	mov    0x350(%rdx),%rdx
 1084f0b:	mov    %r15d,0x14(%rdx,%rax,4)
 1084f10:	mov    0x138(%rbx),%rdx
 1084f17:	movb   $0x1,0x6(%rdx,%rax,1)
 1084f1c:	mov    (%rbx),%rdx
 1084f1f:	mov    0x350(%rdx),%rdx
 1084f26:	mov    %r15d,0x18(%rdx,%rax,4)
 1084f2b:	mov    0x138(%rbx),%rdx
 1084f32:	movb   $0x1,0x7(%rdx,%rax,1)
 1084f37:	mov    (%rbx),%rdx
 1084f3a:	mov    0x350(%rdx),%rdx
 1084f41:	mov    %r15d,0x1c(%rdx,%rax,4)
 1084f46:	add    $0x8,%rax
 1084f4a:	cmp    %rax,%rcx
 1084f4d:	jne    1084e70 <check_input_resolve_range+0x2180>
 1084f53:	jmp    1084bb0 <check_input_resolve_range+0x1ec0>
 1084f58:	xor    %r13d,%r13d
 1084f5b:	jmp    1084bb7 <check_input_resolve_range+0x1ec7>
 1084f60:	mov    0x10(%rsp),%r12
 1084f65:	cmp    $0x3,%esi
 1084f68:	jne    1084fa3 <check_input_resolve_range+0x22b3>
 1084f6a:	mov    0x10(%rbp),%rax
 1084f6e:	cmpb   $0x2f,(%rax,%r13,1)
 1084f73:	jne    10851a8 <check_input_resolve_range+0x24b8>
 1084f79:	mov    %r13,%rax
 1084f7c:	mov    %r13d,%ecx
 1084f7f:	mov    (%rsp),%r13
 1084f83:	movzbl 0x4b(%r12),%edx
 1084f89:	mov    0x40(%rsp),%esi
 1084f8d:	movzbl 0x18(%rsp),%r9d
 1084f93:	add    $0x3,%edx
 1084f96:	cmp    %edx,%esi
 1084f98:	jb     1084a28 <check_input_resolve_range+0x1d38>
 1084f9e:	jmp    1086a70 <check_input_resolve_range+0x3d80>
 1084fa3:	mov    $0x1,%cl
 1084fa5:	jmp    1084fc3 <check_input_resolve_range+0x22d3>
 1084fa7:	nopw   0x0(%rax,%rax,1)
 1084fb0:	mov    %r13d,0x130(%rsp)
 1084fb8:	xor    %ecx,%ecx
 1084fba:	cmp    %r11d,%r13d
 1084fbd:	jae    1086277 <check_input_resolve_range+0x3587>
 1084fc3:	mov    0x10(%rbp),%rdx
 1084fc7:	mov    %r13d,%eax
 1084fca:	movzbl (%rdx,%rax,1),%edx
 1084fce:	cmp    $0x2f,%dl
 1084fd1:	je     1084f7c <check_input_resolve_range+0x228c>
 1084fd3:	test   $0x1,%cl
 1084fd6:	jne    1085005 <check_input_resolve_range+0x2315>
 1084fd8:	cmp    $0x33,%dl
 1084fdb:	jne    10868b9 <check_input_resolve_range+0x3bc9>
 1084fe1:	mov    0x138(%rbx),%rcx
 1084fe8:	inc    %r13d
 1084feb:	movb   $0x1,(%rcx,%rax,1)
 1084fef:	mov    (%rbx),%rcx
 1084ff2:	mov    0x350(%rcx),%rcx
 1084ff9:	mov    %r15d,(%rcx,%rax,4)
 1084ffd:	mov    %r13d,0x130(%rsp)
 1085005:	cmp    %r11d,%r13d
 1085008:	jae    10868b9 <check_input_resolve_range+0x3bc9>
 108500e:	mov    0x10(%rbp),%rcx
 1085012:	mov    %r13d,%eax
 1085015:	cmpb   $0x2,(%rcx,%rax,1)
 1085019:	jne    10868b9 <check_input_resolve_range+0x3bc9>
 108501f:	mov    0x34(%r12),%ecx
 1085024:	mov    0x90(%rsp),%rsi
 108502c:	lea    0x1(%rcx),%edx
 108502f:	lea    (%rcx,%rcx,2),%rcx
 1085033:	mov    %edx,0x34(%r12)
 1085038:	mov    0x18(%rbp),%rdx
 108503c:	mov    (%rdx,%rax,4),%eax
 108503f:	mov    %eax,(%rsi,%rcx,4)
 1085042:	mov    %r13d,0x4(%rsi,%rcx,4)
 1085047:	movl   $0xffffffff,0x8(%rsi,%rcx,4)
 108504f:	mov    0x130(%rsp),%edx
 1085056:	mov    %edx,%r13d
 1085059:	inc    %r13d
 108505c:	je     1084fb0 <check_input_resolve_range+0x22c0>
 1085062:	mov    %r13d,%ecx
 1085065:	sub    %edx,%ecx
 1085067:	mov    %rdx,%rax
 108506a:	test   $0x7,%cl
 108506d:	je     10850a1 <check_input_resolve_range+0x23b1>
 108506f:	mov    $0x1,%ecx
 1085074:	mov    %rdx,%rax
 1085077:	nopw   0x0(%rax,%rax,1)
 1085080:	mov    0x138(%rbx),%rsi
 1085087:	movb   $0x1,(%rsi,%rax,1)
 108508b:	mov    (%rbx),%rsi
 108508e:	mov    0x350(%rsi),%rsi
 1085095:	mov    %r15d,(%rsi,%rax,4)
 1085099:	inc    %rax
 108509c:	dec    %rcx
 108509f:	jne    1085080 <check_input_resolve_range+0x2390>
 10850a1:	mov    %r13d,%ecx
 10850a4:	sub    %rcx,%rdx
 10850a7:	cmp    $0xfffffffffffffff8,%rdx
 10850ab:	ja     1084fb0 <check_input_resolve_range+0x22c0>
 10850b1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10850c0:	mov    0x138(%rbx),%rdx
 10850c7:	movb   $0x1,(%rdx,%rax,1)
 10850cb:	mov    (%rbx),%rdx
 10850ce:	mov    0x350(%rdx),%rdx
 10850d5:	mov    %r15d,(%rdx,%rax,4)
 10850d9:	mov    0x138(%rbx),%rdx
 10850e0:	movb   $0x1,0x1(%rdx,%rax,1)
 10850e5:	mov    (%rbx),%rdx
 10850e8:	mov    0x350(%rdx),%rdx
 10850ef:	mov    %r15d,0x4(%rdx,%rax,4)
 10850f4:	mov    0x138(%rbx),%rdx
 10850fb:	movb   $0x1,0x2(%rdx,%rax,1)
 1085100:	mov    (%rbx),%rdx
 1085103:	mov    0x350(%rdx),%rdx
 108510a:	mov    %r15d,0x8(%rdx,%rax,4)
 108510f:	mov    0x138(%rbx),%rdx
 1085116:	movb   $0x1,0x3(%rdx,%rax,1)
 108511b:	mov    (%rbx),%rdx
 108511e:	mov    0x350(%rdx),%rdx
 1085125:	mov    %r15d,0xc(%rdx,%rax,4)
 108512a:	mov    0x138(%rbx),%rdx
 1085131:	movb   $0x1,0x4(%rdx,%rax,1)
 1085136:	mov    (%rbx),%rdx
 1085139:	mov    0x350(%rdx),%rdx
 1085140:	mov    %r15d,0x10(%rdx,%rax,4)
 1085145:	mov    0x138(%rbx),%rdx
 108514c:	movb   $0x1,0x5(%rdx,%rax,1)
 1085151:	mov    (%rbx),%rdx
 1085154:	mov    0x350(%rdx),%rdx
 108515b:	mov    %r15d,0x14(%rdx,%rax,4)
 1085160:	mov    0x138(%rbx),%rdx
 1085167:	movb   $0x1,0x6(%rdx,%rax,1)
 108516c:	mov    (%rbx),%rdx
 108516f:	mov    0x350(%rdx),%rdx
 1085176:	mov    %r15d,0x18(%rdx,%rax,4)
 108517b:	mov    0x138(%rbx),%rdx
 1085182:	movb   $0x1,0x7(%rdx,%rax,1)
 1085187:	mov    (%rbx),%rdx
 108518a:	mov    0x350(%rdx),%rdx
 1085191:	mov    %r15d,0x1c(%rdx,%rax,4)
 1085196:	add    $0x8,%rax
 108519a:	cmp    %rax,%rcx
 108519d:	jne    10850c0 <check_input_resolve_range+0x23d0>
 10851a3:	jmp    1084fb0 <check_input_resolve_range+0x22c0>
 10851a8:	mov    0x30(%r12),%r14d
 10851ad:	lea    0x130(%rsp),%rsi
 10851b5:	mov    %rbx,%rdi
 10851b8:	mov    %r11d,%edx
 10851bb:	mov    %r15d,%ecx
 10851be:	shl    $0x4,%r14
 10851c2:	add    0x70(%rsp),%r14
 10851c7:	mov    %r14,%r8
 10851ca:	vzeroupper
 10851cd:	call   10ea1a0 <check_input_asm_text>
 10851d2:	test   %al,%al
 10851d4:	je     1086a5e <check_input_resolve_range+0x3d6e>
 10851da:	cmpl   $0x6,0x8(%r14)
 10851df:	jne    10851fd <check_input_resolve_range+0x250d>
 10851e1:	mov    (%r14),%rax
 10851e4:	mov    $0x6f6d656d,%edx
 10851e9:	mov    (%rax),%ecx
 10851eb:	movzwl 0x4(%rax),%eax
 10851ef:	xor    %edx,%ecx
 10851f1:	xor    $0x7972,%eax
 10851f6:	or     %ecx,%eax
 10851f8:	sete   %al
 10851fb:	jmp    10851ff <check_input_resolve_range+0x250f>
 10851fd:	xor    %eax,%eax
 10851ff:	or     %al,0x4c(%r12)
 1085204:	cmpl   $0x2,0x8(%r14)
 1085209:	jne    1085218 <check_input_resolve_range+0x2528>
 108520b:	mov    (%r14),%rax
 108520e:	cmpw   $0x6363,(%rax)
 1085213:	sete   %al
 1085216:	jmp    108521a <check_input_resolve_range+0x252a>
 1085218:	xor    %eax,%eax
 108521a:	or     %al,0x4d(%r12)
 108521f:	xor    %esi,%esi
 1085221:	mov    (%r14),%r12
 1085224:	mov    0x8(%r14),%edx
 1085228:	mov    %r12,%rdi
 108522b:	call   788240 <memchr@plt>
 1085230:	test   %rax,%rax
 1085233:	jne    1086a56 <check_input_resolve_range+0x3d66>
 1085239:	mov    0x8(%r14),%r14
 108523d:	mov    %r14d,%edx
 1085240:	cmp    $0x6,%r14d
 1085244:	je     1085258 <check_input_resolve_range+0x2568>
 1085246:	cmp    $0x2,%r14d
 108524a:	jne    108526b <check_input_resolve_range+0x257b>
 108524c:	mov    %r12,%rdi
 108524f:	lea    -0x9d03eb(%rip),%rsi        # 6b4e6b <pp_string_value.meaning+0x2c66a>
 1085256:	jmp    1085262 <check_input_resolve_range+0x2572>
 1085258:	lea    -0x9b68f6(%rip),%rsi        # 6ce969 <pp_string_value.meaning+0x46168>
 108525f:	mov    %r12,%rdi
 1085262:	call   7883c0 <bcmp@plt>
 1085267:	test   %eax,%eax
 1085269:	je     10852be <check_input_resolve_range+0x25ce>
 108526b:	mov    %r12,%rdi
 108526e:	mov    %r14,%rsi
 1085271:	call   10ea5c0 <check_asm_register>
 1085276:	mov    0x10(%rsp),%rcx
 108527b:	vpbroadcastq -0xad8c35(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1085285:	vpbroadcastd -0xad944e(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 108528e:	vpbroadcastq -0xad8c38(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1085298:	vpbroadcastd -0xad9462(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10852a2:	vpbroadcastq -0xad8c54(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10852ac:	movzbl 0x18(%rsp),%r9d
 10852b2:	incl   0x30(%rcx)
 10852b5:	test   %al,%al
 10852b7:	jne    10852fd <check_input_resolve_range+0x260d>
 10852b9:	jmp    1086a5e <check_input_resolve_range+0x3d6e>
 10852be:	mov    0x10(%rsp),%rax
 10852c3:	vpbroadcastq -0xad8c7d(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 10852cd:	vpbroadcastd -0xad9496(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10852d6:	vpbroadcastq -0xad8c80(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 10852e0:	vpbroadcastd -0xad94aa(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10852ea:	vpbroadcastq -0xad8c9c(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10852f4:	movzbl 0x18(%rsp),%r9d
 10852fa:	incl   0x30(%rax)
 10852fd:	mov    0x130(%rsp),%ecx
 1085304:	mov    0x30(%rsp),%r11
 1085309:	cmp    %r11d,%ecx
 108530c:	jae    1088f70 <check_input_resolve_range+0x6280>
 1085312:	mov    %r13d,0x24(%rsp)
 1085317:	mov    (%rsp),%r13
 108531b:	jmp    1085384 <check_input_resolve_range+0x2694>
 108531d:	mov    %r12,%rdi
 1085320:	mov    %r14,%rsi
 1085323:	call   10ea5c0 <check_asm_register>
 1085328:	mov    0x10(%rsp),%rcx
 108532d:	vpbroadcastq -0xad8ce7(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1085337:	vpbroadcastd -0xad9500(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085340:	vpbroadcastq -0xad8cea(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 108534a:	vpbroadcastd -0xad9514(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085354:	vpbroadcastq -0xad8d06(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 108535e:	movzbl 0x18(%rsp),%r9d
 1085364:	incl   0x30(%rcx)
 1085367:	test   %al,%al
 1085369:	je     1086a70 <check_input_resolve_range+0x3d80>
 108536f:	mov    0x130(%rsp),%ecx
 1085376:	mov    0x30(%rsp),%r11
 108537b:	cmp    %r11d,%ecx
 108537e:	jae    108550f <check_input_resolve_range+0x281f>
 1085384:	mov    0x10(%rbp),%rdx
 1085388:	mov    %ecx,%eax
 108538a:	movzbl (%rdx,%rax,1),%edx
 108538e:	cmp    $0x33,%edx
 1085391:	jne    10854ef <check_input_resolve_range+0x27ff>
 1085397:	mov    0x138(%rbx),%rdx
 108539e:	mov    0x10(%rsp),%r12
 10853a3:	lea    0x130(%rsp),%rsi
 10853ab:	mov    %rbx,%rdi
 10853ae:	movb   $0x1,(%rdx,%rax,1)
 10853b2:	mov    (%rbx),%rdx
 10853b5:	mov    0x350(%rdx),%rdx
 10853bc:	mov    %r15d,(%rdx,%rax,4)
 10853c0:	mov    %ecx,%eax
 10853c2:	inc    %eax
 10853c4:	mov    %r11d,%edx
 10853c7:	mov    %r15d,%ecx
 10853ca:	mov    %eax,0x130(%rsp)
 10853d1:	mov    %eax,0x24(%rsp)
 10853d5:	mov    0x30(%r12),%r14d
 10853da:	shl    $0x4,%r14
 10853de:	add    0x70(%rsp),%r14
 10853e3:	mov    %r14,%r8
 10853e6:	vzeroupper
 10853e9:	call   10ea1a0 <check_input_asm_text>
 10853ee:	test   %al,%al
 10853f0:	je     1086a70 <check_input_resolve_range+0x3d80>
 10853f6:	cmpl   $0x6,0x8(%r14)
 10853fb:	jne    1085427 <check_input_resolve_range+0x2737>
 10853fd:	mov    (%r14),%rax
 1085400:	mov    $0x6f6d656d,%edx
 1085405:	mov    (%rax),%ecx
 1085407:	movzwl 0x4(%rax),%eax
 108540b:	xor    %edx,%ecx
 108540d:	xor    $0x7972,%eax
 1085412:	or     %ecx,%eax
 1085414:	sete   %al
 1085417:	or     %al,0x4c(%r12)
 108541c:	cmpl   $0x2,0x8(%r14)
 1085421:	je     1085435 <check_input_resolve_range+0x2745>
 1085423:	xor    %eax,%eax
 1085425:	jmp    1085440 <check_input_resolve_range+0x2750>
 1085427:	xor    %eax,%eax
 1085429:	or     %al,0x4c(%r12)
 108542e:	cmpl   $0x2,0x8(%r14)
 1085433:	jne    1085423 <check_input_resolve_range+0x2733>
 1085435:	mov    (%r14),%rax
 1085438:	cmpw   $0x6363,(%rax)
 108543d:	sete   %al
 1085440:	or     %al,0x4d(%r12)
 1085445:	xor    %esi,%esi
 1085447:	mov    (%r14),%r12
 108544a:	mov    0x8(%r14),%edx
 108544e:	mov    %r12,%rdi
 1085451:	call   788240 <memchr@plt>
 1085456:	test   %rax,%rax
 1085459:	jne    1086a4f <check_input_resolve_range+0x3d5f>
 108545f:	mov    0x8(%r14),%r14
 1085463:	mov    %r14d,%edx
 1085466:	cmp    $0x6,%r14d
 108546a:	je     1085482 <check_input_resolve_range+0x2792>
 108546c:	cmp    $0x2,%r14d
 1085470:	jne    108531d <check_input_resolve_range+0x262d>
 1085476:	mov    %r12,%rdi
 1085479:	lea    -0x9d0615(%rip),%rsi        # 6b4e6b <pp_string_value.meaning+0x2c66a>
 1085480:	jmp    108548c <check_input_resolve_range+0x279c>
 1085482:	lea    -0x9b6b20(%rip),%rsi        # 6ce969 <pp_string_value.meaning+0x46168>
 1085489:	mov    %r12,%rdi
 108548c:	call   7883c0 <bcmp@plt>
 1085491:	test   %eax,%eax
 1085493:	jne    108531d <check_input_resolve_range+0x262d>
 1085499:	mov    0x10(%rsp),%rax
 108549e:	vpbroadcastq -0xad8e58(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 10854a8:	vpbroadcastd -0xad9671(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10854b1:	vpbroadcastq -0xad8e5b(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 10854bb:	vpbroadcastd -0xad9685(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10854c5:	vpbroadcastq -0xad8e77(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10854cf:	movzbl 0x18(%rsp),%r9d
 10854d5:	incl   0x30(%rax)
 10854d8:	mov    0x130(%rsp),%ecx
 10854df:	mov    0x30(%rsp),%r11
 10854e4:	cmp    %r11d,%ecx
 10854e7:	jb     1085384 <check_input_resolve_range+0x2694>
 10854ed:	jmp    108550f <check_input_resolve_range+0x281f>
 10854ef:	mov    0x10(%rsp),%r12
 10854f4:	cmp    $0x2f,%edx
 10854f7:	jne    1086a70 <check_input_resolve_range+0x3d80>
 10854fd:	jmp    1084f83 <check_input_resolve_range+0x2293>
 1085502:	mov    %r13d,0x24(%rsp)
 1085507:	test   %dl,%dl
 1085509:	je     1086a70 <check_input_resolve_range+0x3d80>
 108550f:	mov    0x10(%rsp),%r12
 1085514:	xor    $0x1,%r9b
 1085518:	mov    %r9b,0x48(%r12)
 108551d:	mov    0x28(%r12),%esi
 1085522:	test   %esi,%esi
 1085524:	je     108552e <check_input_resolve_range+0x283e>
 1085526:	movzbl 0x4b(%r12),%eax
 108552c:	jmp    1085533 <check_input_resolve_range+0x2843>
 108552e:	mov    $0x1,%eax
 1085533:	movzbl 0x49(%r12),%edx
 1085539:	mov    0x58(%rsp),%r15
 108553e:	or     %eax,%edx
 1085540:	mov    %dl,0x49(%r12)
 1085545:	cmp    %r11d,%ecx
 1085548:	jne    108556e <check_input_resolve_range+0x287e>
 108554a:	cmpb   $0x1,0x4b(%r12)
 1085550:	jne    108555a <check_input_resolve_range+0x286a>
 1085552:	cmpl   $0x0,0x34(%r12)
 1085558:	je     108556e <check_input_resolve_range+0x287e>
 108555a:	cmpl   $0xffffffff,0x44(%r12)
 1085560:	movzbl %r9b,%eax
 1085564:	mov    $0x1,%ecx
 1085569:	cmovne %ecx,%eax
 108556c:	jmp    1085570 <check_input_resolve_range+0x2880>
 108556e:	xor    %eax,%eax
 1085570:	add    0x2c(%r12),%esi
 1085575:	mov    0x70(%rsp),%rcx
 108557a:	mov    0x90(%rsp),%rdx
 1085582:	mov    %r15,0x10(%r12)
 1085587:	mov    %rcx,0x18(%r12)
 108558c:	mov    %rdx,0x20(%r12)
 1085591:	mov    %esi,0xb4(%rsp)
 1085598:	test   %al,%al
 108559a:	je     10860a8 <check_input_resolve_range+0x33b8>
 10855a0:	test   %esi,%esi
 10855a2:	je     10860a8 <check_input_resolve_range+0x33b8>
 10855a8:	mov    0xb4(%rsp),%eax
 10855af:	lea    0x10(%r15),%rcx
 10855b3:	xor    %r13d,%r13d
 10855b6:	xor    %r8d,%r8d
 10855b9:	mov    %r15,0x58(%rsp)
 10855be:	mov    %rcx,0xe0(%rsp)
 10855c6:	mov    %rax,0x100(%rsp)
 10855ce:	xchg   %ax,%ax
 10855d0:	mov    %r13,%rax
 10855d3:	shl    $0x4,%rax
 10855d7:	mov    0x10(%rbx),%rdx
 10855db:	mov    0x10(%r12),%rcx
 10855e0:	mov    0x28(%r12),%r9d
 10855e5:	lea    (%rax,%rax,2),%rdi
 10855e9:	mov    0xc(%r15,%rdi,1),%eax
 10855ee:	mov    (%rcx,%rdi,1),%r10
 10855f2:	mov    0x8(%rcx,%rdi,1),%r11d
 10855f7:	lea    (%rcx,%rdi,1),%rbx
 10855fb:	mov    %eax,0x24(%rsp)
 10855ff:	mov    0x270(%rdx),%rax
 1085606:	mov    %rax,0xc8(%rsp)
 108560e:	test   %r11,%r11
 1085611:	je     10856e0 <check_input_resolve_range+0x29f0>
 1085617:	mov    %rdi,%r12
 108561a:	mov    %r8d,0x80(%rsp)
 1085622:	xor    %ebp,%ebp
 1085624:	mov    %r10,0x40(%rsp)
 1085629:	mov    %r10,%rdi
 108562c:	xor    %esi,%esi
 108562e:	mov    %r11,%rdx
 1085631:	mov    %r11,%r15
 1085634:	mov    %r9,%r14
 1085637:	vzeroupper
 108563a:	call   788240 <memchr@plt>
 108563f:	test   %rax,%rax
 1085642:	mov    $0x2,%edx
 1085647:	mov    %r14,%r9
 108564a:	lea    0x24(%rbx),%rsi
 108564e:	movl   $0xffffffff,0x24(%rbx)
 1085655:	sete   %cl
 1085658:	cmp    %r14,%r13
 108565b:	lea    0x28(%rbx),%r14
 108565f:	sbb    $0x0,%edx
 1085662:	mov    %edx,0x28(%rbx)
 1085665:	cmp    %r9,%r13
 1085668:	jae    1085720 <check_input_resolve_range+0x2a30>
 108566e:	vpbroadcastq -0xad9028(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1085678:	vpbroadcastd -0xad9841(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085681:	vpbroadcastq -0xad902b(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 108568b:	vpbroadcastd -0xad9855(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085695:	vpbroadcastq -0xad9047(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 108569f:	mov    0x8(%rsp),%rbx
 10856a4:	mov    0x80(%rsp),%r8d
 10856ac:	mov    %r12,%rdi
 10856af:	mov    %r15,%r11
 10856b2:	mov    %r14,%rdx
 10856b5:	test   %rax,%rax
 10856b8:	je     1085795 <check_input_resolve_range+0x2aa5>
 10856be:	mov    0x40(%rsp),%r10
 10856c3:	mov    0x10(%rsp),%r12
 10856c8:	mov    0x58(%rsp),%r15
 10856cd:	xor    %ecx,%ecx
 10856cf:	mov    $0x1,%r14d
 10856d5:	jmp    10857d0 <check_input_resolve_range+0x2ae0>
 10856da:	nopw   0x0(%rax,%rax,1)
 10856e0:	cmp    %r9,%r13
 10856e3:	mov    $0x2,%eax
 10856e8:	movl   $0xffffffff,0x24(%rbx)
 10856ef:	sbb    $0x0,%eax
 10856f2:	xor    %ecx,%ecx
 10856f4:	mov    %eax,0x28(%rbx)
 10856f7:	cmp    %r9,%r13
 10856fa:	jae    108578b <check_input_resolve_range+0x2a9b>
 1085700:	lea    0x24(%rbx),%rsi
 1085704:	add    $0x28,%rbx
 1085708:	mov    $0x1,%r14d
 108570e:	mov    %rbx,%rdx
 1085711:	mov    0x8(%rsp),%rbx
 1085716:	jmp    10857d0 <check_input_resolve_range+0x2ae0>
 108571b:	nopl   0x0(%rax,%rax,1)
 1085720:	vpbroadcastq -0xad90da(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 108572a:	vpbroadcastd -0xad98f3(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085733:	vpbroadcastq -0xad90dd(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 108573d:	vpbroadcastd -0xad9907(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085747:	vpbroadcastq -0xad90f9(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1085751:	mov    %r12,%rdi
 1085754:	mov    %r15,%r11
 1085757:	mov    0x8(%rsp),%rbx
 108575c:	mov    0x80(%rsp),%r8d
 1085764:	mov    0x40(%rsp),%r10
 1085769:	mov    0x10(%rsp),%r12
 108576e:	mov    0x58(%rsp),%r15
 1085773:	mov    %r14,%rdx
 1085776:	mov    $0x2,%r14d
 108577c:	cmp    %r11d,%ebp
 108577f:	setb   %al
 1085782:	test   %al,%cl
 1085784:	jne    10857e6 <check_input_resolve_range+0x2af6>
 1085786:	jmp    1085fa0 <check_input_resolve_range+0x32b0>
 108578b:	mov    0x8(%rsp),%rbx
 1085790:	jmp    1085fa0 <check_input_resolve_range+0x32b0>
 1085795:	mov    0x40(%rsp),%r10
 108579a:	mov    0x10(%rsp),%r12
 108579f:	mov    0x58(%rsp),%r15
 10857a4:	movzbl (%r10),%eax
 10857a8:	cmp    $0x3d,%eax
 10857ab:	je     10857b6 <check_input_resolve_range+0x2ac6>
 10857ad:	cmp    $0x2b,%eax
 10857b0:	jne    10856cd <check_input_resolve_range+0x29dd>
 10857b6:	xor    %ecx,%ecx
 10857b8:	cmp    $0x2b,%al
 10857ba:	sete   %cl
 10857bd:	lea    0x1(%rcx,%rcx,1),%r14d
 10857c2:	mov    $0x1,%cl
 10857c4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 10857d0:	mov    $0x1,%ebp
 10857d5:	mov    %r14d,(%rdx)
 10857d8:	cmp    %r11d,%ebp
 10857db:	setb   %al
 10857de:	test   %al,%cl
 10857e0:	je     1085fa0 <check_input_resolve_range+0x32b0>
 10857e6:	xor    %eax,%eax
 10857e8:	cmp    %r9,%r13
 10857eb:	mov    %rsi,0xf8(%rsp)
 10857f3:	mov    $0x1,%esi
 10857f8:	mov    %r14d,0x60(%rsp)
 10857fd:	movl   $0xffffffff,0xa0(%rsp)
 1085808:	mov    %rdx,0x18(%rsp)
 108580d:	setae  %al
 1085810:	xor    %r12d,%r12d
 1085813:	mov    %eax,0x30(%rsp)
 1085817:	shl    $0x4,%eax
 108581a:	or     $0xc,%eax
 108581d:	mov    %eax,0x10c(%rsp)
 1085824:	mov    %r11d,%eax
 1085827:	neg    %eax
 1085829:	mov    %rax,0x110(%rsp)
 1085831:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1085840:	mov    %ebp,%eax
 1085842:	movzbl (%r10,%rax,1),%r14d
 1085847:	lea    0x1(%rbp),%r15d
 108584b:	cmp    $0x2c,%r14d
 108584f:	jne    1085860 <check_input_resolve_range+0x2b70>
 1085851:	mov    %r12d,%ecx
 1085854:	or     0x30(%rsp),%cl
 1085858:	inc    %esi
 108585a:	xor    %r12d,%r12d
 108585d:	jmp    10858b0 <check_input_resolve_range+0x2bc0>
 108585f:	nop
 1085860:	lea    -0x25(%r14),%eax
 1085864:	cmp    $0x1,%al
 1085866:	ja     1085890 <check_input_resolve_range+0x2ba0>
 1085868:	cmp    %r9,%r13
 108586b:	mov    0x60(%rsp),%ebp
 108586f:	setb   %cl
 1085872:	xor    %eax,%eax
 1085874:	cmp    $0x26,%r14d
 1085878:	setne  %al
 108587b:	or     %al,%cl
 108587d:	shl    $0x6,%eax
 1085880:	add    $0x40,%eax
 1085883:	or     %eax,%ebp
 1085885:	mov    %ebp,0x60(%rsp)
 1085889:	mov    %ebp,(%rdx)
 108588b:	jmp    10858b0 <check_input_resolve_range+0x2bc0>
 108588d:	nopl   (%rax)
 1085890:	cmp    $0x3f,%r14d
 1085894:	ja     10858ca <check_input_resolve_range+0x2bda>
 1085896:	movabs $0x8000040b00000200,%rdx
 10858a0:	mov    %r14d,%eax
 10858a3:	mov    $0x1,%cl
 10858a5:	bt     %rax,%rdx
 10858a9:	mov    0x18(%rsp),%rdx
 10858ae:	jae    10858ca <check_input_resolve_range+0x2bda>
 10858b0:	test   $0x1,%cl
 10858b3:	je     1085fc0 <check_input_resolve_range+0x32d0>
 10858b9:	mov    %r15d,%ebp
 10858bc:	cmp    %r11d,%r15d
 10858bf:	jb     1085840 <check_input_resolve_range+0x2b50>
 10858c5:	jmp    1085fc0 <check_input_resolve_range+0x32d0>
 10858ca:	cmp    %r9,%r13
 10858cd:	jae    1085a64 <check_input_resolve_range+0x2d74>
 10858d3:	lea    -0x3c(%r14),%eax
 10858d7:	cmp    $0x3f,%eax
 10858da:	ja     1085e11 <check_input_resolve_range+0x3121>
 10858e0:	lea    -0xbe7d67(%rip),%rcx        # 49db80 <cbuiltin_test_generated.edges+0x3d40>
 10858e7:	movslq (%rcx,%rax,4),%rax
 10858eb:	add    %rcx,%rax
 10858ee:	jmp    *%rax
 10858f0:	lea    0x3(%rbp),%eax
 10858f3:	mov    %eax,0xd0(%rsp)
 10858fa:	cmp    %r11d,%eax
 10858fd:	jae    1085e11 <check_input_resolve_range+0x3121>
 1085903:	mov    %r15d,%eax
 1085906:	cmpb   $0x63,(%r10,%rax,1)
 108590b:	jne    1085e11 <check_input_resolve_range+0x3121>
 1085911:	add    $0x2,%ebp
 1085914:	cmpb   $0x63,(%r10,%rbp,1)
 1085919:	jne    1085e11 <check_input_resolve_range+0x3121>
 108591f:	mov    0xd0(%rsp),%r15d
 1085927:	mov    %rdi,0x88(%rsp)
 108592f:	mov    %r8d,0x80(%rsp)
 1085937:	mov    %r9,0xa8(%rsp)
 108593f:	mov    %r11,0x98(%rsp)
 1085947:	mov    %esi,0x7c(%rsp)
 108594b:	mov    %r15,0xd8(%rsp)
 1085953:	cmpb   $0x2c,(%r10,%r15,1)
 1085958:	je     1085965 <check_input_resolve_range+0x2c75>
 108595a:	inc    %r15
 108595d:	cmp    %r15,%r11
 1085960:	jne    1085953 <check_input_resolve_range+0x2c63>
 1085962:	mov    %r11d,%r15d
 1085965:	mov    %r15d,%eax
 1085968:	sub    0xd0(%rsp),%eax
 108596f:	add    %r10,0xd8(%rsp)
 1085977:	lea    0xc15f82(%rip),%rbx        # 1c9b900 <check_asm_constraint.conditions>
 108597e:	xor    %ebp,%ebp
 1085980:	mov    %r10,0x40(%rsp)
 1085985:	mov    %rax,0xc0(%rsp)
 108598d:	cmp    0xd0(%rsp),%r15d
 1085995:	mov    (%rbx),%r14
 1085998:	mov    %r14,%rdi
 108599b:	sete   %r12b
 108599f:	vzeroupper
 10859a2:	call   787f00 <strlen@plt>
 10859a7:	cmp    0xc0(%rsp),%rax
 10859af:	setne  %al
 10859b2:	sete   %cl
 10859b5:	or     %r12b,%al
 10859b8:	jne    10859d7 <check_input_resolve_range+0x2ce7>
 10859ba:	mov    0xd8(%rsp),%rdi
 10859c2:	mov    0xc0(%rsp),%rdx
 10859ca:	mov    %r14,%rsi
 10859cd:	call   7883c0 <bcmp@plt>
 10859d2:	test   %eax,%eax
 10859d4:	sete   %cl
 10859d7:	test   %cl,%cl
 10859d9:	jne    10859e9 <check_input_resolve_range+0x2cf9>
 10859db:	add    $0x8,%rbx
 10859df:	cmp    $0x1a,%rbp
 10859e3:	lea    0x1(%rbp),%rbp
 10859e7:	jbe    108598d <check_input_resolve_range+0x2c9d>
 10859e9:	vpbroadcastq -0xad93a3(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 10859f3:	vpbroadcastd -0xad9bbc(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10859fc:	vpbroadcastq -0xad93a6(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1085a06:	vpbroadcastd -0xad9bd0(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085a10:	vpbroadcastq -0xad93c2(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1085a1a:	mov    0x60(%rsp),%eax
 1085a1e:	mov    0x18(%rsp),%rdx
 1085a23:	mov    0x8(%rsp),%rbx
 1085a28:	mov    0x88(%rsp),%rdi
 1085a30:	mov    0x80(%rsp),%r8d
 1085a38:	mov    0xa8(%rsp),%r9
 1085a40:	mov    0x40(%rsp),%r10
 1085a45:	mov    0x98(%rsp),%r11
 1085a4d:	mov    0x7c(%rsp),%esi
 1085a51:	mov    $0x1,%r12b
 1085a54:	or     $0x108,%eax
 1085a59:	mov    %eax,0x60(%rsp)
 1085a5d:	mov    %eax,(%rdx)
 1085a5f:	jmp    10858b0 <check_input_resolve_range+0x2bc0>
 1085a64:	cmp    $0x5b,%r14d
 1085a68:	lea    -0x30(%r14),%ecx
 1085a6c:	setne  %al
 1085a6f:	cmp    $0xa,%cl
 1085a72:	setae  %cl
 1085a75:	test   %cl,%al
 1085a77:	jne    1085ad8 <check_input_resolve_range+0x2de8>
 1085a79:	mov    %esi,0x7c(%rsp)
 1085a7d:	cmp    $0x5b,%r14d
 1085a81:	jne    1085b10 <check_input_resolve_range+0x2e20>
 1085a87:	mov    $0xffffffff,%r14d
 1085a8d:	xor    %eax,%eax
 1085a8f:	cmp    %r11d,%r15d
 1085a92:	jae    1085d9e <check_input_resolve_range+0x30ae>
 1085a98:	mov    0x110(%rsp),%rcx
 1085aa0:	mov    %r15d,%r15d
 1085aa3:	lea    (%r10,%r15,1),%rbp
 1085aa7:	xor    %r12d,%r12d
 1085aaa:	add    %r15,%rcx
 1085aad:	nopl   (%rax)
 1085ab0:	cmpb   $0x5d,0x0(%rbp,%r12,1)
 1085ab6:	je     1085c6a <check_input_resolve_range+0x2f7a>
 1085abc:	inc    %r12
 1085abf:	mov    %ecx,%edx
 1085ac1:	add    %r12d,%edx
 1085ac4:	jne    1085ab0 <check_input_resolve_range+0x2dc0>
 1085ac6:	mov    0x10(%rsp),%rsi
 1085acb:	mov    0x18(%rsp),%rdx
 1085ad0:	mov    %r11d,%r15d
 1085ad3:	jmp    1085da3 <check_input_resolve_range+0x30b3>
 1085ad8:	lea    -0x3c(%r14),%eax
 1085adc:	cmp    $0x3f,%eax
 1085adf:	ja     1085e11 <check_input_resolve_range+0x3121>
 1085ae5:	movabs $0xa000004000005,%rcx
 1085aef:	bt     %rax,%rcx
 1085af3:	jae    1085b94 <check_input_resolve_range+0x2ea4>
 1085af9:	mov    0x60(%rsp),%eax
 1085afd:	mov    $0x1,%r12b
 1085b00:	mov    $0x1,%cl
 1085b02:	or     $0x4,%eax
 1085b05:	mov    %eax,0x60(%rsp)
 1085b09:	mov    %eax,(%rdx)
 1085b0b:	jmp    10858b0 <check_input_resolve_range+0x2bc0>
 1085b10:	mov    0x10(%rsp),%rsi
 1085b15:	mov    0xa0(%rsp),%ebp
 1085b1c:	add    $0xffffffd0,%r14d
 1085b20:	mov    $0x1,%eax
 1085b25:	cmp    %r11d,%r15d
 1085b28:	jae    1085b6a <check_input_resolve_range+0x2e7a>
 1085b2a:	mov    %r15d,%r15d
 1085b2d:	nopl   (%rax)
 1085b30:	movzbl (%r10,%r15,1),%ecx
 1085b35:	lea    -0x30(%rcx),%edx
 1085b38:	cmp    $0x9,%dl
 1085b3b:	ja     1085b57 <check_input_resolve_range+0x2e67>
 1085b3d:	cmp    0x28(%rsi),%r14d
 1085b41:	jae    1085b57 <check_input_resolve_range+0x2e67>
 1085b43:	lea    (%r14,%r14,4),%edx
 1085b47:	inc    %r15
 1085b4a:	lea    -0x30(%rcx,%rdx,2),%r14d
 1085b4f:	cmp    %r15,%r11
 1085b52:	jne    1085b30 <check_input_resolve_range+0x2e40>
 1085b54:	mov    %r11d,%r15d
 1085b57:	mov    0x18(%rsp),%rdx
 1085b5c:	xor    %ecx,%ecx
 1085b5e:	cmp    0x28(%rsi),%r14d
 1085b62:	jae    1085db9 <check_input_resolve_range+0x30c9>
 1085b68:	jmp    1085b76 <check_input_resolve_range+0x2e86>
 1085b6a:	xor    %ecx,%ecx
 1085b6c:	cmp    0x28(%rsi),%r14d
 1085b70:	jae    1085db9 <check_input_resolve_range+0x30c9>
 1085b76:	cmp    $0xffffffff,%ebp
 1085b79:	je     1085c58 <check_input_resolve_range+0x2f68>
 1085b7f:	xor    %ecx,%ecx
 1085b81:	cmp    %r14d,%ebp
 1085b84:	sete   %cl
 1085b87:	test   %eax,%ecx
 1085b89:	jne    1085dc1 <check_input_resolve_range+0x30d1>
 1085b8f:	jmp    1085fad <check_input_resolve_range+0x32bd>
 1085b94:	cmp    $0x1d,%rax
 1085b98:	jne    1085e07 <check_input_resolve_range+0x3117>
 1085b9e:	cmp    %r11d,%r15d
 1085ba1:	jae    1085c3b <check_input_resolve_range+0x2f4b>
 1085ba7:	mov    %r15d,%eax
 1085baa:	mov    %esi,0x7c(%rsp)
 1085bae:	movzbl (%r10,%rax,1),%esi
 1085bb3:	mov    %rdi,0x88(%rsp)
 1085bbb:	mov    $0x7,%edx
 1085bc0:	lea    -0xa507e3(%rip),%rdi        # 6353e4 <foreign_touch.flags+0x3310e>
 1085bc7:	mov    %r8d,%ebp
 1085bca:	mov    %r9,%r12
 1085bcd:	mov    %r10,%r14
 1085bd0:	mov    %r11,0x98(%rsp)
 1085bd8:	vzeroupper
 1085bdb:	call   788240 <memchr@plt>
 1085be0:	vpbroadcastq -0xad9592(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1085bea:	vpbroadcastd -0xad9db4(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085bf4:	vpbroadcastq -0xad959e(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1085bfe:	vpbroadcastd -0xad9dc7(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085c07:	vpbroadcastq -0xad95c1(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1085c11:	mov    0x18(%rsp),%rdx
 1085c16:	mov    0x7c(%rsp),%esi
 1085c1a:	mov    0x98(%rsp),%r11
 1085c22:	mov    0x88(%rsp),%rdi
 1085c2a:	test   %rax,%rax
 1085c2d:	mov    %r14,%r10
 1085c30:	mov    %r12,%r9
 1085c33:	mov    %ebp,%r8d
 1085c36:	setne  %cl
 1085c39:	jmp    1085c3d <check_input_resolve_range+0x2f4d>
 1085c3b:	xor    %ecx,%ecx
 1085c3d:	movzbl %cl,%eax
 1085c40:	add    %eax,%r15d
 1085c43:	mov    0x60(%rsp),%eax
 1085c47:	or     $0x8,%eax
 1085c4a:	mov    $0x1,%r12b
 1085c4d:	mov    %eax,0x60(%rsp)
 1085c51:	mov    %eax,(%rdx)
 1085c53:	jmp    10858b0 <check_input_resolve_range+0x2bc0>
 1085c58:	mov    $0x1,%ecx
 1085c5d:	test   %eax,%ecx
 1085c5f:	jne    1085dc1 <check_input_resolve_range+0x30d1>
 1085c65:	jmp    1085fad <check_input_resolve_range+0x32bd>
 1085c6a:	mov    0x10(%rsp),%rsi
 1085c6f:	add    %r12,%r15
 1085c72:	mov    0x18(%rsp),%rdx
 1085c77:	mov    0x2c(%rsi),%eax
 1085c7a:	add    0x28(%rsi),%eax
 1085c7d:	je     1085f90 <check_input_resolve_range+0x32a0>
 1085c83:	mov    0x10(%rsi),%rcx
 1085c87:	mov    %eax,%eax
 1085c89:	mov    %rbp,0xd0(%rsp)
 1085c91:	mov    %rax,%rsi
 1085c94:	xor    %ebp,%ebp
 1085c96:	mov    %rdi,0x88(%rsp)
 1085c9e:	mov    %r9,0xa8(%rsp)
 1085ca6:	mov    %r10,0x40(%rsp)
 1085cab:	mov    %r11,0x98(%rsp)
 1085cb3:	mov    %rax,0xd8(%rsp)
 1085cbb:	add    $0x10,%rcx
 1085cbf:	nop
 1085cc0:	mov    (%rcx),%eax
 1085cc2:	mov    $0xffffffff,%r14d
 1085cc8:	mov    %rcx,0xc0(%rsp)
 1085cd0:	test   %rax,%rax
 1085cd3:	je     1085d7b <check_input_resolve_range+0x308b>
 1085cd9:	mov    0xc8(%rsp),%rcx
 1085ce1:	mov    0x10(%rcx),%rcx
 1085ce5:	cmp    %r12d,0x4(%rcx,%rax,8)
 1085cea:	jne    1085d7b <check_input_resolve_range+0x308b>
 1085cf0:	mov    (%rcx,%rax,8),%edi
 1085cf3:	mov    0xc8(%rsp),%rax
 1085cfb:	mov    0xd0(%rsp),%rsi
 1085d03:	mov    %r12,%rdx
 1085d06:	mov    %r8d,%r14d
 1085d09:	add    0x40(%rax),%rdi
 1085d0d:	vzeroupper
 1085d10:	call   7883c0 <bcmp@plt>
 1085d15:	vpbroadcastq -0xad96c7(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1085d1f:	vpbroadcastd -0xad9ee9(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085d29:	vpbroadcastq -0xad96d3(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1085d33:	vpbroadcastd -0xad9efc(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085d3c:	vpbroadcastq -0xad96f6(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1085d46:	mov    0xd8(%rsp),%rsi
 1085d4e:	mov    0x18(%rsp),%rdx
 1085d53:	mov    0x98(%rsp),%r11
 1085d5b:	mov    0x40(%rsp),%r10
 1085d60:	mov    0xa8(%rsp),%r9
 1085d68:	mov    0x88(%rsp),%rdi
 1085d70:	neg    %eax
 1085d72:	mov    %r14d,%r8d
 1085d75:	sbb    %r14d,%r14d
 1085d78:	or     %ebp,%r14d
 1085d7b:	mov    0xc0(%rsp),%rcx
 1085d83:	cmp    $0xffffffff,%r14d
 1085d87:	jne    1085d99 <check_input_resolve_range+0x30a9>
 1085d89:	inc    %rbp
 1085d8c:	add    $0x30,%rcx
 1085d90:	cmp    %rsi,%rbp
 1085d93:	jb     1085cc0 <check_input_resolve_range+0x2fd0>
 1085d99:	mov    $0x1,%eax
 1085d9e:	mov    0x10(%rsp),%rsi
 1085da3:	mov    0xa0(%rsp),%ebp
 1085daa:	add    %eax,%r15d
 1085dad:	xor    %ecx,%ecx
 1085daf:	cmp    0x28(%rsi),%r14d
 1085db3:	jb     1085b76 <check_input_resolve_range+0x2e86>
 1085db9:	test   %eax,%ecx
 1085dbb:	je     1085fad <check_input_resolve_range+0x32bd>
 1085dc1:	mov    0xf8(%rsp),%rax
 1085dc9:	mov    %r14d,%ecx
 1085dcc:	lea    (%rcx,%rcx,2),%rcx
 1085dd0:	mov    $0x1,%r12b
 1085dd3:	mov    %r14d,0xa0(%rsp)
 1085ddb:	shl    $0x4,%rcx
 1085ddf:	mov    %r14d,(%rax)
 1085de2:	mov    0x10(%rsi),%rax
 1085de6:	mov    0x7c(%rsp),%esi
 1085dea:	mov    0x28(%rax,%rcx,1),%eax
 1085dee:	mov    0x60(%rsp),%ecx
 1085df2:	and    $0xc,%eax
 1085df5:	or     %eax,%ecx
 1085df7:	or     $0x20,%ecx
 1085dfa:	mov    %ecx,0x60(%rsp)
 1085dfe:	mov    %ecx,(%rdx)
 1085e00:	mov    $0x1,%cl
 1085e02:	jmp    10858b0 <check_input_resolve_range+0x2bc0>
 1085e07:	cmp    $0x3f,%rax
 1085e0b:	je     1085fb4 <check_input_resolve_range+0x32c4>
 1085e11:	mov    %rdi,0x88(%rsp)
 1085e19:	mov    $0x14,%edx
 1085e1e:	lea    -0xa3aaa0(%rip),%rdi        # 64b385 <fuzz_comment_end+0xa9df>
 1085e25:	mov    %esi,%ebp
 1085e27:	mov    %r14d,%esi
 1085e2a:	mov    %r11,0x98(%rsp)
 1085e32:	mov    %r10,0x40(%rsp)
 1085e37:	mov    %r9,0xa8(%rsp)
 1085e3f:	mov    %r8d,0x80(%rsp)
 1085e47:	vzeroupper
 1085e4a:	call   788240 <memchr@plt>
 1085e4f:	test   %rax,%rax
 1085e52:	je     1085e70 <check_input_resolve_range+0x3180>
 1085e54:	mov    0x60(%rsp),%eax
 1085e58:	cmp    $0x66,%r14d
 1085e5c:	mov    0x18(%rsp),%rdx
 1085e61:	mov    $0x1,%r12b
 1085e64:	setne  %cl
 1085e67:	or     0x30(%rsp),%cl
 1085e6b:	or     $0x8,%eax
 1085e6e:	jmp    1085e9c <check_input_resolve_range+0x31ac>
 1085e70:	mov    $0x11,%edx
 1085e75:	lea    -0xa67a17(%rip),%rdi        # 61e465 <foreign_touch.flags+0x1c18f>
 1085e7c:	mov    %r14d,%esi
 1085e7f:	call   788240 <memchr@plt>
 1085e84:	test   %rax,%rax
 1085e87:	je     1085eff <check_input_resolve_range+0x320f>
 1085e89:	mov    0x60(%rsp),%eax
 1085e8d:	mov    0x18(%rsp),%rdx
 1085e92:	mov    $0x1,%r12b
 1085e95:	mov    0x30(%rsp),%ecx
 1085e99:	or     $0x10,%eax
 1085e9c:	mov    %eax,0x60(%rsp)
 1085ea0:	mov    %eax,(%rdx)
 1085ea2:	vpbroadcastq -0xad985c(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1085eac:	vpbroadcastd -0xada075(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085eb5:	vpbroadcastq -0xad985f(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1085ebf:	vpbroadcastd -0xada089(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085ec9:	vpbroadcastq -0xad987b(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1085ed3:	mov    0x88(%rsp),%rdi
 1085edb:	mov    0x80(%rsp),%r8d
 1085ee3:	mov    0xa8(%rsp),%r9
 1085eeb:	mov    0x40(%rsp),%r10
 1085ef0:	mov    0x98(%rsp),%r11
 1085ef8:	mov    %ebp,%esi
 1085efa:	jmp    10858b0 <check_input_resolve_range+0x2bc0>
 1085eff:	lea    -0x58(%r14),%eax
 1085f03:	xor    %ecx,%ecx
 1085f05:	mov    %ebp,%esi
 1085f07:	cmp    $0x18,%eax
 1085f0a:	ja     108605e <check_input_resolve_range+0x336e>
 1085f10:	vpbroadcastq -0xad98ca(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1085f1a:	vpbroadcastd -0xada0e3(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085f23:	vpbroadcastq -0xad98cd(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1085f2d:	vpbroadcastd -0xada0f7(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1085f37:	vpbroadcastq -0xad98e9(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1085f41:	mov    0x88(%rsp),%rdi
 1085f49:	mov    0x80(%rsp),%r8d
 1085f51:	mov    0xa8(%rsp),%r9
 1085f59:	mov    0x40(%rsp),%r10
 1085f5e:	mov    0x98(%rsp),%r11
 1085f66:	mov    $0x1008001,%edx
 1085f6b:	bt     %eax,%edx
 1085f6e:	jae    1085fc0 <check_input_resolve_range+0x32d0>
 1085f70:	cmp    $0x70,%r14d
 1085f74:	mov    0x60(%rsp),%eax
 1085f78:	mov    0x18(%rsp),%rdx
 1085f7d:	setne  %cl
 1085f80:	or     0x30(%rsp),%cl
 1085f84:	or     0x10c(%rsp),%eax
 1085f8b:	jmp    1085c4a <check_input_resolve_range+0x2f5a>
 1085f90:	mov    $0x1,%eax
 1085f95:	jmp    1085da3 <check_input_resolve_range+0x30b3>
 1085f9a:	nopw   0x0(%rax,%rax,1)
 1085fa0:	cmp    %r9,%r13
 1085fa3:	mov    $0x1,%esi
 1085fa8:	setae  %al
 1085fab:	jmp    1085fd1 <check_input_resolve_range+0x32e1>
 1085fad:	mov    0x7c(%rsp),%esi
 1085fb1:	mov    $0x1,%r12b
 1085fb4:	xor    %ecx,%ecx
 1085fb6:	cs nopw 0x0(%rax,%rax,1)
 1085fc0:	mov    0x30(%rsp),%eax
 1085fc4:	mov    0x58(%rsp),%r15
 1085fc9:	or     %r12b,%al
 1085fcc:	mov    0x10(%rsp),%r12
 1085fd1:	mov    %eax,0x30(%rsp)
 1085fd5:	test   %r13,%r13
 1085fd8:	mov    %esi,%r9d
 1085fdb:	sete   %dl
 1085fde:	cmp    %r8d,%esi
 1085fe1:	sete   %sil
 1085fe5:	xor    %eax,%eax
 1085fe7:	test   $0x1,%cl
 1085fea:	je     10860a4 <check_input_resolve_range+0x33b4>
 1085ff0:	testb  $0x1,0x30(%rsp)
 1085ff5:	je     10860a4 <check_input_resolve_range+0x33b4>
 1085ffb:	or     %sil,%dl
 1085ffe:	je     10860a4 <check_input_resolve_range+0x33b4>
 1086004:	mov    $0x1,%al
 1086006:	test   %r13,%r13
 1086009:	je     1086044 <check_input_resolve_range+0x3354>
 108600b:	add    %r15,%rdi
 108600e:	mov    0x10(%rdi),%ecx
 1086011:	test   %ecx,%ecx
 1086013:	je     1086044 <check_input_resolve_range+0x3354>
 1086015:	mov    0xe0(%rsp),%rdx
 108601d:	mov    $0x1,%esi
 1086022:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1086030:	cmp    %ecx,(%rdx)
 1086032:	setne  %al
 1086035:	je     1086044 <check_input_resolve_range+0x3354>
 1086037:	add    $0x30,%rdx
 108603b:	cmp    %r13,%rsi
 108603e:	lea    0x1(%rsi),%rsi
 1086042:	jb     1086030 <check_input_resolve_range+0x3340>
 1086044:	test   %al,%al
 1086046:	je     10860a4 <check_input_resolve_range+0x33b4>
 1086048:	inc    %r13
 108604b:	mov    %r9d,%r8d
 108604e:	cmp    0x100(%rsp),%r13
 1086056:	jb     10855d0 <check_input_resolve_range+0x28e0>
 108605c:	jmp    10860a4 <check_input_resolve_range+0x33b4>
 108605e:	vpbroadcastq -0xad9a18(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1086068:	vpbroadcastd -0xada231(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1086071:	vpbroadcastq -0xad9a1b(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 108607b:	vpbroadcastd -0xada245(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1086085:	vpbroadcastq -0xad9a37(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 108608f:	mov    0x88(%rsp),%rdi
 1086097:	mov    0x80(%rsp),%r8d
 108609f:	jmp    1085fc0 <check_input_resolve_range+0x32d0>
 10860a4:	mov    (%rsp),%r13
 10860a8:	test   %al,%al
 10860aa:	je     1086a70 <check_input_resolve_range+0x3d80>
 10860b0:	mov    0x10(%rsp),%rax
 10860b5:	mov    0xb4(%rsp),%r15d
 10860bd:	mov    0x90(%rsp),%r10
 10860c5:	mov    0x34(%rax),%r11d
 10860c9:	mov    %r15d,%r12d
 10860cc:	test   %r11,%r11
 10860cf:	je     108617d <check_input_resolve_range+0x348d>
 10860d5:	mov    0x58(%rsp),%rax
 10860da:	xor    %ecx,%ecx
 10860dc:	add    $0x10,%rax
 10860e0:	lea    (%rcx,%rcx,2),%rdx
 10860e4:	lea    (%r10,%rdx,4),%rdx
 10860e8:	test   %r15d,%r15d
 10860eb:	je     1086130 <check_input_resolve_range+0x3440>
 10860ed:	mov    (%rdx),%esi
 10860ef:	mov    $0x1,%r8d
 10860f5:	mov    %rax,%rdi
 10860f8:	nopl   0x0(%rax,%rax,1)
 1086100:	mov    (%rdi),%r9d
 1086103:	cmp    %r9d,%esi
 1086106:	je     1086115 <check_input_resolve_range+0x3425>
 1086108:	add    $0x30,%rdi
 108610c:	cmp    %r12,%r8
 108610f:	lea    0x1(%r8),%r8
 1086113:	jb     1086100 <check_input_resolve_range+0x3410>
 1086115:	cmp    %r9d,%esi
 1086118:	setne  %sil
 108611c:	test   %rcx,%rcx
 108611f:	jne    1086138 <check_input_resolve_range+0x3448>
 1086121:	jmp    108616c <check_input_resolve_range+0x347c>
 1086123:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1086130:	mov    $0x1,%sil
 1086133:	test   %rcx,%rcx
 1086136:	je     108616c <check_input_resolve_range+0x347c>
 1086138:	test   %sil,%sil
 108613b:	je     108616c <check_input_resolve_range+0x347c>
 108613d:	mov    (%rdx),%esi
 108613f:	mov    $0x1,%r8d
 1086145:	mov    %r10,%rdi
 1086148:	nopl   0x0(%rax,%rax,1)
 1086150:	mov    (%rdi),%r9d
 1086153:	cmp    %esi,%r9d
 1086156:	je     1086165 <check_input_resolve_range+0x3475>
 1086158:	add    $0xc,%rdi
 108615c:	cmp    %rcx,%r8
 108615f:	lea    0x1(%r8),%r8
 1086163:	jb     1086150 <check_input_resolve_range+0x3460>
 1086165:	cmp    %esi,%r9d
 1086168:	setne  %sil
 108616c:	test   %sil,%sil
 108616f:	je     10861a4 <check_input_resolve_range+0x34b4>
 1086171:	inc    %rcx
 1086174:	cmp    %r11,%rcx
 1086177:	jne    10860e0 <check_input_resolve_range+0x33f0>
 108617d:	mov    0x10(%rsp),%rax
 1086182:	mov    0x28(%rax),%esi
 1086185:	test   %rsi,%rsi
 1086188:	je     1086289 <check_input_resolve_range+0x3599>
 108618e:	mov    0x10(%rax),%rax
 1086192:	cmp    $0x8,%esi
 1086195:	jae    1086290 <check_input_resolve_range+0x35a0>
 108619b:	xor    %ecx,%ecx
 108619d:	xor    %edi,%edi
 108619f:	jmp    10864c3 <check_input_resolve_range+0x37d3>
 10861a4:	mov    0x4(%rdx),%eax
 10861a7:	mov    %eax,0x24(%rsp)
 10861ab:	jmp    1086a70 <check_input_resolve_range+0x3d80>
 10861b0:	mov    %r11d,%ebp
 10861b3:	mov    (%r8,%r10,4),%ebx
 10861b7:	cmp    $0xffffffff,%ebx
 10861ba:	je     1088dcd <check_input_resolve_range+0x60dd>
 10861c0:	mov    %ebx,%r10d
 10861c3:	movzbl (%rsi,%r10,1),%ebx
 10861c8:	mov    %ebp,%r11d
 10861cb:	xor    %ebp,%ebp
 10861cd:	cmp    $0x7,%bl
 10861d0:	je     10861b3 <check_input_resolve_range+0x34c3>
 10861d2:	cmp    $0x1a,%bl
 10861d5:	je     10861b3 <check_input_resolve_range+0x34c3>
 10861d7:	movzbl (%r9,%r10,1),%ebx
 10861dc:	cmp    $0x43,%bl
 10861df:	je     10861b3 <check_input_resolve_range+0x34c3>
 10861e1:	cmp    $0x4f,%bl
 10861e4:	je     10861b3 <check_input_resolve_range+0x34c3>
 10861e6:	lea    -0x37(%rbx),%r14d
 10861ea:	cmp    $0xfd,%r14b
 10861ee:	ja     10861b3 <check_input_resolve_range+0x34c3>
 10861f0:	cmp    %edi,%r10d
 10861f3:	jae    108623b <check_input_resolve_range+0x354b>
 10861f5:	mov    0x18(%rdx),%r14
 10861f9:	movzbl %bl,%ebx
 10861fc:	vmovd  %ebx,%xmm0
 1086200:	mov    (%r14,%r10,4),%ebp
 1086204:	vpinsrd $0x1,%ebp,%xmm0,%xmm0
 108620a:	cmp    $0x6b,%ebp
 108620d:	vpshufd $0x50,%xmm0,%xmm0
 1086212:	vpand  -0xaf6d2a(%rip),%xmm0,%xmm0        # 58f4f0 <abi_test_hex.digits+0xb60>
 108621a:	sete   %bpl
 108621e:	vpcmpeqd -0xaf6d28(%rip),%xmm0,%k0        # 58f500 <abi_test_hex.digits+0xb70>
 1086228:	kortestb %k0,%k0
 108622c:	setne  %r14b
 1086230:	or     %bpl,%r14b
 1086233:	cmp    $0x6,%bl
 1086236:	sete   %bl
 1086239:	jmp    1086240 <check_input_resolve_range+0x3550>
 108623b:	xor    %ebx,%ebx
 108623d:	xor    %r14d,%r14d
 1086240:	mov    %r14d,%ebp
 1086243:	xor    $0x1,%bpl
 1086247:	and    %r11b,%bpl
 108624a:	test   %r14b,%r14b
 108624d:	jne    10861b3 <check_input_resolve_range+0x34c3>
 1086253:	test   %bl,%bl
 1086255:	je     10861b3 <check_input_resolve_range+0x34c3>
 108625b:	lea    0x1(%r10),%rbx
 108625f:	cmp    %edi,%ebx
 1086261:	jae    10861b0 <check_input_resolve_range+0x34c0>
 1086267:	cmpb   $0x6,(%r9,%rbx,1)
 108626c:	setne  %bl
 108626f:	and    %bl,%r11b
 1086272:	jmp    10861b0 <check_input_resolve_range+0x34c0>
 1086277:	mov    %r13d,%ecx
 108627a:	mov    (%rsp),%r13
 108627e:	movzbl 0x18(%rsp),%r9d
 1086284:	jmp    108550f <check_input_resolve_range+0x281f>
 1086289:	xor    %edi,%edi
 108628b:	jmp    10864f0 <check_input_resolve_range+0x3800>
 1086290:	cmp    $0x40,%esi
 1086293:	jae    10862a9 <check_input_resolve_range+0x35b9>
 1086295:	xor    %ecx,%ecx
 1086297:	xor    %edi,%edi
 1086299:	jmp    1086450 <check_input_resolve_range+0x3760>
 108629e:	mov    $0xffffffff,%r10d
 10862a4:	jmp    1088de0 <check_input_resolve_range+0x60f0>
 10862a9:	vmovdqa64 -0xbe8773(%rip),%zmm1        # 49db40 <cbuiltin_test_generated.edges+0x3d00>
 10862b3:	vmovdqa64 -0xbe87bd(%rip),%zmm2        # 49db00 <cbuiltin_test_generated.edges+0x3cc0>
 10862bd:	mov    %esi,%ecx
 10862bf:	and    $0xffffffc0,%ecx
 10862c2:	vpxor  %xmm0,%xmm0,%xmm0
 10862c6:	vpxor  %xmm3,%xmm3,%xmm3
 10862ca:	vpxor  %xmm4,%xmm4,%xmm4
 10862ce:	vpxor  %xmm5,%xmm5,%xmm5
 10862d2:	mov    %rcx,%rdx
 10862d5:	data16 cs nopw 0x0(%rax,%rax,1)
 10862e0:	vpmullq %zmm12,%zmm2,%zmm7
 10862e6:	vpmullq %zmm12,%zmm1,%zmm6
 10862ec:	kxnorb %k0,%k0,%k1
 10862f0:	vpxor  %xmm8,%xmm8,%xmm8
 10862f5:	vpxor  %xmm9,%xmm9,%xmm9
 10862fa:	vpxor  %xmm10,%xmm10,%xmm10
 10862ff:	vpxor  %xmm11,%xmm11,%xmm11
 1086304:	vpaddq %zmm16,%zmm1,%zmm1
 108630a:	vpaddq %zmm16,%zmm2,%zmm2
 1086310:	add    $0xffffffffffffffc0,%rdx
 1086314:	vpgatherqd 0x28(%rax,%zmm7,1),%ymm8{%k1}
 108631c:	kxnorb %k0,%k0,%k1
 1086320:	vpgatherqd 0x28(%rax,%zmm6,1),%ymm9{%k1}
 1086328:	kxnorb %k0,%k0,%k1
 108632c:	vinserti64x4 $0x1,%ymm8,%zmm9,%zmm8
 1086333:	vpxor  %xmm9,%xmm9,%xmm9
 1086338:	vpgatherqd 0x328(%rax,%zmm7,1),%ymm9{%k1}
 1086343:	kxnorb %k0,%k0,%k1
 1086347:	vpgatherqd 0x328(%rax,%zmm6,1),%ymm10{%k1}
 1086352:	kxnorb %k0,%k0,%k1
 1086356:	vinserti64x4 $0x1,%ymm9,%zmm10,%zmm9
 108635d:	vpxor  %xmm10,%xmm10,%xmm10
 1086362:	vpgatherqd 0x628(%rax,%zmm7,1),%ymm10{%k1}
 108636d:	kxnorb %k0,%k0,%k1
 1086371:	vpgatherqd 0x628(%rax,%zmm6,1),%ymm11{%k1}
 108637c:	kxnorb %k0,%k0,%k1
 1086380:	vinserti64x4 $0x1,%ymm10,%zmm11,%zmm10
 1086387:	vpxor  %xmm11,%xmm11,%xmm11
 108638c:	vpgatherqd 0x928(%rax,%zmm7,1),%ymm11{%k1}
 1086397:	kxnorb %k0,%k0,%k1
 108639b:	vpxor  %xmm7,%xmm7,%xmm7
 108639f:	vpgatherqd 0x928(%rax,%zmm6,1),%ymm7{%k1}
 10863aa:	vinserti64x4 $0x1,%ymm11,%zmm7,%zmm6
 10863b1:	vpsrld $0x1,%zmm8,%zmm11
 10863b8:	vpsrld $0x1,%zmm9,%zmm8
 10863bf:	vpsrld $0x1,%zmm10,%zmm9
 10863c6:	vpsrld $0x1,%zmm6,%zmm6
 10863cd:	vpandd %zmm15,%zmm8,%zmm10
 10863d3:	vpandd %zmm15,%zmm11,%zmm7
 10863d9:	vpandd %zmm15,%zmm9,%zmm8
 10863df:	vpandd %zmm15,%zmm6,%zmm6
 10863e5:	vpaddd %zmm0,%zmm7,%zmm0
 10863eb:	vpaddd %zmm3,%zmm10,%zmm3
 10863f1:	vpaddd %zmm4,%zmm8,%zmm4
 10863f7:	vpaddd %zmm5,%zmm6,%zmm5
 10863fd:	jne    10862e0 <check_input_resolve_range+0x35f0>
 1086403:	vpaddd %zmm0,%zmm3,%zmm0
 1086409:	vpaddd %zmm0,%zmm4,%zmm0
 108640f:	vpaddd %zmm0,%zmm5,%zmm0
 1086415:	vextracti64x4 $0x1,%zmm0,%ymm1
 108641c:	vpaddd %zmm1,%zmm0,%zmm0
 1086422:	vextracti128 $0x1,%ymm0,%xmm1
 1086428:	vpaddd %xmm1,%xmm0,%xmm0
 108642c:	vpshufd $0xee,%xmm0,%xmm1
 1086431:	vpaddd %xmm1,%xmm0,%xmm0
 1086435:	vpshufd $0x55,%xmm0,%xmm1
 108643a:	vpaddd %xmm1,%xmm0,%xmm0
 108643e:	vmovd  %xmm0,%edi
 1086442:	cmp    %esi,%ecx
 1086444:	je     10864f0 <check_input_resolve_range+0x3800>
 108644a:	test   $0x38,%sil
 108644e:	je     10864c3 <check_input_resolve_range+0x37d3>
 1086450:	mov    %rcx,%rdx
 1086453:	vpbroadcastq %rdx,%zmm1
 1086459:	vporq  -0xbe8923(%rip),%zmm1,%zmm1        # 49db40 <cbuiltin_test_generated.edges+0x3d00>
 1086463:	mov    %esi,%ecx
 1086465:	and    $0xfffffff8,%ecx
 1086468:	vmovd  %edi,%xmm0
 108646c:	sub    %rcx,%rdx
 108646f:	nop
 1086470:	vpmullq %zmm12,%zmm1,%zmm2
 1086476:	kxnorb %k0,%k0,%k1
 108647a:	vpxor  %xmm3,%xmm3,%xmm3
 108647e:	vpaddq %zmm14,%zmm1,%zmm1
 1086484:	add    $0x8,%rdx
 1086488:	vpgatherqd 0x28(%rax,%zmm2,1),%ymm3{%k1}
 1086490:	vpsrld $0x1,%ymm3,%ymm2
 1086495:	vpand  %ymm2,%ymm13,%ymm2
 1086499:	vpaddd %ymm0,%ymm2,%ymm0
 108649d:	jne    1086470 <check_input_resolve_range+0x3780>
 108649f:	vextracti128 $0x1,%ymm0,%xmm1
 10864a5:	vpaddd %xmm1,%xmm0,%xmm0
 10864a9:	vpshufd $0xee,%xmm0,%xmm1
 10864ae:	vpaddd %xmm1,%xmm0,%xmm0
 10864b2:	vpshufd $0x55,%xmm0,%xmm1
 10864b7:	vpaddd %xmm1,%xmm0,%xmm0
 10864bb:	vmovd  %xmm0,%edi
 10864bf:	cmp    %esi,%ecx
 10864c1:	je     10864f0 <check_input_resolve_range+0x3800>
 10864c3:	mov    %rsi,%rdx
 10864c6:	sub    %rcx,%rdx
 10864c9:	lea    (%rcx,%rcx,2),%rcx
 10864cd:	shl    $0x4,%rcx
 10864d1:	lea    0x28(%rax,%rcx,1),%rax
 10864d6:	cs nopw 0x0(%rax,%rax,1)
 10864e0:	btl    $0x1,(%rax)
 10864e4:	adc    $0x0,%edi
 10864e7:	add    $0x30,%rax
 10864eb:	dec    %rdx
 10864ee:	jne    10864e0 <check_input_resolve_range+0x37f0>
 10864f0:	mov    0x10(%rsp),%rcx
 10864f5:	mov    0x8(%rcx),%r8d
 10864f9:	mov    0xc(%rcx),%eax
 10864fc:	test   %r8d,%r8d
 10864ff:	mov    %eax,0x24(%rsp)
 1086503:	sete   %al
 1086506:	or     0x48(%rcx),%al
 1086509:	je     10865e1 <check_input_resolve_range+0x38f1>
 108650f:	test   %r15d,%r15d
 1086512:	je     1086534 <check_input_resolve_range+0x3844>
 1086514:	mov    0x20(%rbx),%rax
 1086518:	mov    (%rax),%rsi
 108651b:	mov    0x8(%rax),%rdx
 108651f:	lea    0x7(%rdx,%rsi,1),%rcx
 1086524:	add    %rsi,%rdx
 1086527:	and    $0xfffffffffffffff8,%rcx
 108652b:	cmp    %rdx,%rcx
 108652e:	jae    10868c2 <check_input_resolve_range+0x3bd2>
 1086534:	mov    (%rsp),%r13
 1086538:	xor    %esi,%esi
 108653a:	mov    0x10(%rsp),%rax
 108653f:	mov    %rsi,0x10(%rax)
 1086543:	mov    0x30(%rax),%eax
 1086546:	test   %rax,%rax
 1086549:	je     108656b <check_input_resolve_range+0x387b>
 108654b:	mov    0x20(%rbx),%rcx
 108654f:	mov    (%rcx),%rdi
 1086552:	mov    0x8(%rcx),%rsi
 1086556:	lea    0x7(%rsi,%rdi,1),%rdx
 108655b:	add    %rdi,%rsi
 108655e:	and    $0xfffffffffffffff8,%rdx
 1086562:	cmp    %rsi,%rdx
 1086565:	jae    1086901 <check_input_resolve_range+0x3c11>
 108656b:	xor    %edi,%edi
 108656d:	mov    0x10(%rsp),%rax
 1086572:	mov    %rdi,0x18(%rax)
 1086576:	mov    0x34(%rax),%eax
 1086579:	test   %rax,%rax
 108657c:	je     108659e <check_input_resolve_range+0x38ae>
 108657e:	mov    0x20(%rbx),%rcx
 1086582:	mov    (%rcx),%rdi
 1086585:	mov    0x8(%rcx),%rsi
 1086589:	lea    0x3(%rsi,%rdi,1),%rdx
 108658e:	add    %rdi,%rsi
 1086591:	and    $0xfffffffffffffffc,%rdx
 1086595:	cmp    %rsi,%rdx
 1086598:	jae    1086935 <check_input_resolve_range+0x3c45>
 108659e:	xor    %eax,%eax
 10865a0:	mov    0x10(%rsp),%rcx
 10865a5:	mov    %rax,0x20(%rcx)
 10865a9:	test   %r15d,%r15d
 10865ac:	je     10865b9 <check_input_resolve_range+0x38c9>
 10865ae:	cmpq   $0x0,0x10(%rcx)
 10865b3:	je     108696d <check_input_resolve_range+0x3c7d>
 10865b9:	cmpl   $0x0,0x30(%rcx)
 10865bd:	je     10865ca <check_input_resolve_range+0x38da>
 10865bf:	cmpq   $0x0,0x18(%rcx)
 10865c4:	je     1086985 <check_input_resolve_range+0x3c95>
 10865ca:	cmpl   $0x0,0x34(%rcx)
 10865ce:	je     1086981 <check_input_resolve_range+0x3c91>
 10865d4:	xor    %ecx,%ecx
 10865d6:	test   %rax,%rax
 10865d9:	sete   %cl
 10865dc:	jmp    108698a <check_input_resolve_range+0x3c9a>
 10865e1:	mov    0x10(%rbx),%rax
 10865e5:	xor    %r13d,%r13d
 10865e8:	mov    %r11,0x60(%rsp)
 10865ed:	mov    %r8,0xc8(%rsp)
 10865f5:	mov    0x270(%rax),%rax
 10865fc:	mov    %rax,0x18(%rsp)
 1086601:	mov    0x10(%rsp),%rax
 1086606:	add    0x2c(%rax),%esi
 1086609:	mov    (%rax),%r9
 108660c:	add    %esi,%edi
 108660e:	mov    %esi,%eax
 1086610:	mov    %rax,0x30(%rsp)
 1086615:	mov    $0x1,%eax
 108661a:	lea    0x1(%r9),%rcx
 108661e:	mov    %rsi,0xe0(%rsp)
 1086626:	mov    %r9,0x40(%rsp)
 108662b:	mov    %rdi,0xf8(%rsp)
 1086633:	add    %r11d,%edi
 1086636:	sub    %r8d,%eax
 1086639:	mov    %rcx,0xc0(%rsp)
 1086641:	mov    %rax,0xa0(%rsp)
 1086649:	mov    %edi,0x100(%rsp)
 1086650:	jmp    108666e <check_input_resolve_range+0x397e>
 1086652:	cmp    0xe0(%rsp),%ecx
 1086659:	jae    10868b9 <check_input_resolve_range+0x3bc9>
 108665f:	dec    %r13d
 1086662:	inc    %r13d
 1086665:	cmp    %r8d,%r13d
 1086668:	jae    108650f <check_input_resolve_range+0x381f>
 108666e:	mov    %r13d,%ebp
 1086671:	cmpb   $0x25,(%r9,%rbp,1)
 1086676:	jne    1086662 <check_input_resolve_range+0x3972>
 1086678:	inc    %rbp
 108667b:	cmp    %r8d,%ebp
 108667e:	jae    10868b9 <check_input_resolve_range+0x3bc9>
 1086684:	movzbl (%r9,%rbp,1),%r14d
 1086689:	test   %r14d,%r14d
 108668c:	je     10866b7 <check_input_resolve_range+0x39c7>
 108668e:	mov    $0x5,%edx
 1086693:	lea    -0x9def84(%rip),%rdi        # 6a7716 <pp_string_value.meaning+0x1ef15>
 108669a:	mov    %r14d,%esi
 108669d:	vzeroupper
 10866a0:	call   788240 <memchr@plt>
 10866a5:	test   %rax,%rax
 10866a8:	je     10866bb <check_input_resolve_range+0x39cb>
 10866aa:	mov    0x60(%rsp),%r11
 10866af:	mov    %ebp,%r13d
 10866b2:	jmp    10868a7 <check_input_resolve_range+0x3bb7>
 10866b7:	xor    %eax,%eax
 10866b9:	jmp    10866de <check_input_resolve_range+0x39ee>
 10866bb:	cmp    $0x6c,%r14d
 10866bf:	mov    0x60(%rsp),%r11
 10866c4:	sete   %al
 10866c7:	and    $0xdf,%r14b
 10866cb:	add    $0x2,%r13d
 10866cf:	add    $0xbf,%r14b
 10866d3:	cmp    $0x1a,%r14b
 10866d7:	cmovae %ebp,%r13d
 10866db:	mov    %r13d,%ebp
 10866de:	mov    0xc8(%rsp),%r8
 10866e6:	mov    0x40(%rsp),%r9
 10866eb:	cmp    %r8d,%ebp
 10866ee:	jae    10868b9 <check_input_resolve_range+0x3bc9>
 10866f4:	mov    %ebp,%r13d
 10866f7:	cmpb   $0x5b,(%r9,%r13,1)
 10866fc:	jne    1086746 <check_input_resolve_range+0x3a56>
 10866fe:	inc    %ebp
 1086700:	cmp    %r8d,%ebp
 1086703:	jae    10868b9 <check_input_resolve_range+0x3bc9>
 1086709:	mov    0xa0(%rsp),%rcx
 1086711:	mov    0xc0(%rsp),%rdx
 1086719:	mov    0x18(%rsp),%r8
 108671e:	xor    %r14d,%r14d
 1086721:	add    %r13,%rcx
 1086724:	add    %r13,%rdx
 1086727:	nopw   0x0(%rax,%rax,1)
 1086730:	cmpb   $0x5d,(%rdx,%r14,1)
 1086735:	je     108679f <check_input_resolve_range+0x3aaf>
 1086737:	inc    %r14
 108673a:	mov    %ecx,%esi
 108673c:	add    %r14d,%esi
 108673f:	jne    1086730 <check_input_resolve_range+0x3a40>
 1086741:	jmp    10868b9 <check_input_resolve_range+0x3bc9>
 1086746:	mov    0x100(%rsp),%edi
 108674d:	xor    %ecx,%ecx
 108674f:	nop
 1086750:	movzbl (%r9,%r13,1),%edx
 1086755:	lea    -0x3a(%rdx),%esi
 1086758:	cmp    $0xf6,%sil
 108675c:	jb     1086774 <check_input_resolve_range+0x3a84>
 108675e:	cmp    %edi,%ecx
 1086760:	ja     1086774 <check_input_resolve_range+0x3a84>
 1086762:	lea    (%rcx,%rcx,4),%ecx
 1086765:	inc    %r13
 1086768:	lea    -0x30(%rdx,%rcx,2),%ecx
 108676c:	cmp    %r13,%r8
 108676f:	jne    1086750 <check_input_resolve_range+0x3a60>
 1086771:	mov    %r8d,%r13d
 1086774:	cmp    %ebp,%r13d
 1086777:	jbe    10868b9 <check_input_resolve_range+0x3bc9>
 108677d:	test   %al,%al
 108677f:	je     1086652 <check_input_resolve_range+0x3962>
 1086785:	cmp    0xf8(%rsp),%ecx
 108678c:	jb     10868b9 <check_input_resolve_range+0x3bc9>
 1086792:	cmp    %edi,%ecx
 1086794:	jb     108665f <check_input_resolve_range+0x396f>
 108679a:	jmp    10868b9 <check_input_resolve_range+0x3bc9>
 108679f:	mov    %ebp,%ecx
 10867a1:	add    0x40(%rsp),%rcx
 10867a6:	mov    %rcx,0x80(%rsp)
 10867ae:	test   %al,%al
 10867b0:	je     1086821 <check_input_resolve_range+0x3b31>
 10867b2:	test   %r11d,%r11d
 10867b5:	je     10868b9 <check_input_resolve_range+0x3bc9>
 10867bb:	mov    0x10(%rsp),%rax
 10867c0:	xor    %r15d,%r15d
 10867c3:	mov    0x20(%rax),%rbp
 10867c7:	mov    0x0(%rbp),%ecx
 10867ca:	mov    $0xffffffff,%eax
 10867cf:	test   %rcx,%rcx
 10867d2:	je     108680a <check_input_resolve_range+0x3b1a>
 10867d4:	mov    0x10(%r8),%rdx
 10867d8:	cmp    %r14d,0x4(%rdx,%rcx,8)
 10867dd:	jne    108680a <check_input_resolve_range+0x3b1a>
 10867df:	mov    (%rdx,%rcx,8),%edi
 10867e2:	mov    0x80(%rsp),%rsi
 10867ea:	mov    %r14,%rdx
 10867ed:	add    0x40(%r8),%rdi
 10867f1:	vzeroupper
 10867f4:	call   7883c0 <bcmp@plt>
 10867f9:	mov    0x18(%rsp),%r8
 10867fe:	mov    0x60(%rsp),%r11
 1086803:	neg    %eax
 1086805:	sbb    %eax,%eax
 1086807:	or     %r15d,%eax
 108680a:	cmp    $0xffffffff,%eax
 108680d:	jne    1086895 <check_input_resolve_range+0x3ba5>
 1086813:	inc    %r15
 1086816:	add    $0xc,%rbp
 108681a:	cmp    %r11,%r15
 108681d:	jb     10867c7 <check_input_resolve_range+0x3ad7>
 108681f:	jmp    1086895 <check_input_resolve_range+0x3ba5>
 1086821:	cmpl   $0x0,0xe0(%rsp)
 1086829:	je     10868b9 <check_input_resolve_range+0x3bc9>
 108682f:	mov    0x10(%rsp),%rax
 1086834:	xor    %r15d,%r15d
 1086837:	mov    0x10(%rax),%rbp
 108683b:	add    $0x10,%rbp
 108683f:	mov    0x0(%rbp),%ecx
 1086842:	mov    $0xffffffff,%eax
 1086847:	test   %rcx,%rcx
 108684a:	je     1086882 <check_input_resolve_range+0x3b92>
 108684c:	mov    0x10(%r8),%rdx
 1086850:	cmp    %r14d,0x4(%rdx,%rcx,8)
 1086855:	jne    1086882 <check_input_resolve_range+0x3b92>
 1086857:	mov    (%rdx,%rcx,8),%edi
 108685a:	mov    0x80(%rsp),%rsi
 1086862:	mov    %r14,%rdx
 1086865:	add    0x40(%r8),%rdi
 1086869:	vzeroupper
 108686c:	call   7883c0 <bcmp@plt>
 1086871:	mov    0x18(%rsp),%r8
 1086876:	mov    0x60(%rsp),%r11
 108687b:	neg    %eax
 108687d:	sbb    %eax,%eax
 108687f:	or     %r15d,%eax
 1086882:	cmp    $0xffffffff,%eax
 1086885:	jne    1086895 <check_input_resolve_range+0x3ba5>
 1086887:	inc    %r15
 108688a:	add    $0x30,%rbp
 108688e:	cmp    0x30(%rsp),%r15
 1086893:	jb     108683f <check_input_resolve_range+0x3b4f>
 1086895:	cmp    $0xffffffff,%eax
 1086898:	je     10868b9 <check_input_resolve_range+0x3bc9>
 108689a:	mov    0xb4(%rsp),%r15d
 10868a2:	lea    0x1(%r13,%r14,1),%r13
 10868a7:	mov    0xc8(%rsp),%r8
 10868af:	mov    0x40(%rsp),%r9
 10868b4:	jmp    1086662 <check_input_resolve_range+0x3972>
 10868b9:	mov    (%rsp),%r13
 10868bd:	jmp    1086a70 <check_input_resolve_range+0x3d80>
 10868c2:	mov    0x10(%rax),%rdi
 10868c6:	mov    %rcx,%rdx
 10868c9:	sub    %rsi,%rdx
 10868cc:	sub    %rdx,%rdi
 10868cf:	jb     1086534 <check_input_resolve_range+0x3844>
 10868d5:	mov    (%rsp),%r13
 10868d9:	mov    %r12,%rsi
 10868dc:	shl    $0x4,%rsi
 10868e0:	lea    (%rsi,%rsi,2),%r8
 10868e4:	mov    $0x0,%esi
 10868e9:	cmp    %rdi,%r8
 10868ec:	ja     108653a <check_input_resolve_range+0x384a>
 10868f2:	add    %r8,%rdx
 10868f5:	mov    %rcx,%rsi
 10868f8:	mov    %rdx,0x8(%rax)
 10868fc:	jmp    108653a <check_input_resolve_range+0x384a>
 1086901:	mov    0x10(%rcx),%r8
 1086905:	mov    %rdx,%rsi
 1086908:	sub    %rdi,%rsi
 108690b:	sub    %rsi,%r8
 108690e:	jb     108656b <check_input_resolve_range+0x387b>
 1086914:	shl    $0x4,%rax
 1086918:	mov    $0x0,%edi
 108691d:	cmp    %r8,%rax
 1086920:	ja     108656d <check_input_resolve_range+0x387d>
 1086926:	add    %rax,%rsi
 1086929:	mov    %rdx,%rdi
 108692c:	mov    %rsi,0x8(%rcx)
 1086930:	jmp    108656d <check_input_resolve_range+0x387d>
 1086935:	mov    %rdx,%rsi
 1086938:	sub    %rdi,%rsi
 108693b:	mov    0x10(%rcx),%rdi
 108693f:	sub    %rsi,%rdi
 1086942:	jb     108659e <check_input_resolve_range+0x38ae>
 1086948:	shl    $0x2,%rax
 108694c:	lea    (%rax,%rax,2),%r8
 1086950:	mov    $0x0,%eax
 1086955:	cmp    %rdi,%r8
 1086958:	ja     10865a0 <check_input_resolve_range+0x38b0>
 108695e:	add    %r8,%rsi
 1086961:	mov    %rdx,%rax
 1086964:	mov    %rsi,0x8(%rcx)
 1086968:	jmp    10865a0 <check_input_resolve_range+0x38b0>
 108696d:	mov    0xf0(%rsp),%rax
 1086975:	movb   $0x1,0x3c5(%rax)
 108697c:	jmp    1086a70 <check_input_resolve_range+0x3d80>
 1086981:	xor    %ecx,%ecx
 1086983:	jmp    108698a <check_input_resolve_range+0x3c9a>
 1086985:	mov    $0x1,%ecx
 108698a:	mov    0xf0(%rsp),%rdx
 1086992:	movzbl 0x3c5(%rdx),%eax
 1086999:	or     %ecx,%eax
 108699b:	mov    %al,0x3c5(%rdx)
 10869a1:	jne    1086a70 <check_input_resolve_range+0x3d80>
 10869a7:	mov    0x10(%rsp),%r14
 10869ac:	test   %r15d,%r15d
 10869af:	je     10869ca <check_input_resolve_range+0x3cda>
 10869b1:	mov    0x10(%r14),%rdi
 10869b5:	mov    0x58(%rsp),%rsi
 10869ba:	shl    $0x4,%r12
 10869be:	lea    (%r12,%r12,2),%rdx
 10869c2:	vzeroupper
 10869c5:	call   788550 <memcpy@plt>
 10869ca:	mov    0x30(%r14),%edx
 10869ce:	mov    0x48(%rsp),%r12
 10869d3:	mov    0x28(%rsp),%rbp
 10869d8:	mov    0x90(%rsp),%r15
 10869e0:	test   %rdx,%rdx
 10869e3:	je     10869fa <check_input_resolve_range+0x3d0a>
 10869e5:	mov    0x18(%r14),%rdi
 10869e9:	mov    0x70(%rsp),%rsi
 10869ee:	shl    $0x4,%rdx
 10869f2:	vzeroupper
 10869f5:	call   788550 <memcpy@plt>
 10869fa:	mov    0x34(%r14),%eax
 10869fe:	test   %rax,%rax
 1086a01:	je     1086a1a <check_input_resolve_range+0x3d2a>
 1086a03:	mov    0x20(%r14),%rdi
 1086a07:	shl    $0x2,%rax
 1086a0b:	mov    %r15,%rsi
 1086a0e:	lea    (%rax,%rax,2),%rdx
 1086a12:	vzeroupper
 1086a15:	call   788550 <memcpy@plt>
 1086a1a:	mov    0xf0(%rsp),%rax
 1086a22:	incl   0x348(%rax)
 1086a28:	mov    0xe8(%rsp),%rcx
 1086a30:	mov    0x28(%rbx),%rax
 1086a34:	cmp    0x8(%rax),%rcx
 1086a38:	jbe    1086adc <check_input_resolve_range+0x3dec>
 1086a3e:	jmp    1089100 <check_input_resolve_range+0x6410>
 1086a43:	mov    %r13d,%ecx
 1086a46:	mov    (%rsp),%r13
 1086a4a:	jmp    108550f <check_input_resolve_range+0x281f>
 1086a4f:	mov    0x24(%rsp),%eax
 1086a53:	mov    %eax,%r13d
 1086a56:	mov    0x10(%rsp),%rax
 1086a5b:	incl   0x30(%rax)
 1086a5e:	mov    %r13d,0x24(%rsp)
 1086a63:	mov    (%rsp),%r13
 1086a67:	nopw   0x0(%rax,%rax,1)
 1086a70:	mov    (%rbx),%rax
 1086a73:	mov    0x230(%rax),%ecx
 1086a79:	cmp    0x234(%rax),%ecx
 1086a7f:	jae    1086ab5 <check_input_resolve_range+0x3dc5>
 1086a81:	movzbl 0x3c5(%rax),%edx
 1086a88:	lea    0x1(%rcx),%edi
 1086a8b:	mov    0x228(%rax),%rsi
 1086a92:	mov    %edi,0x230(%rax)
 1086a98:	lea    (%rcx,%rcx,2),%rax
 1086a9c:	mov    0x24(%rsp),%ecx
 1086aa0:	lea    0x1(%rdx,%rdx,2),%edx
 1086aa4:	mov    %ecx,(%rsi,%rax,4)
 1086aa7:	mov    %edx,0x4(%rsi,%rax,4)
 1086aab:	movl   $0x0,0x8(%rsi,%rax,4)
 1086ab3:	jmp    1086abc <check_input_resolve_range+0x3dcc>
 1086ab5:	movb   $0x1,0x3c5(%rax)
 1086abc:	mov    0x48(%rsp),%r12
 1086ac1:	mov    0x28(%rsp),%rbp
 1086ac6:	mov    0xe8(%rsp),%rcx
 1086ace:	mov    0x28(%rbx),%rax
 1086ad2:	cmp    0x8(%rax),%rcx
 1086ad6:	ja     1089100 <check_input_resolve_range+0x6410>
 1086adc:	mov    %rcx,0x8(%rax)
 1086ae0:	mov    0x138(%rbx),%rax
 1086ae7:	movzbl (%rax,%rbp,1),%eax
 1086aeb:	test   %al,%al
 1086aed:	je     1086b60 <check_input_resolve_range+0x3e70>
 1086aef:	mov    0x138(%rbx),%rsi
 1086af6:	cmpb   $0x0,(%rsi,%rbp,1)
 1086afa:	je     1086c0c <check_input_resolve_range+0x3f1c>
 1086b00:	mov    0x138(%rbx),%rax
 1086b07:	cmpb   $0x0,(%rax,%rbp,1)
 1086b0b:	jne    1087550 <check_input_resolve_range+0x4860>
 1086b11:	mov    0x18(%r12),%rax
 1086b16:	mov    (%rax,%rbp,4),%eax
 1086b19:	add    $0xffffffb3,%eax
 1086b1c:	cmp    $0x1,%eax
 1086b1f:	ja     1087550 <check_input_resolve_range+0x4860>
 1086b25:	mov    0x30(%r12),%ebp
 1086b2a:	lea    0x1(%r13),%r15d
 1086b2e:	cmp    %ebp,%r15d
 1086b31:	jae    1087114 <check_input_resolve_range+0x4424>
 1086b37:	mov    0x60(%r12),%rax
 1086b3c:	mov    %r15d,%ecx
 1086b3f:	mov    (%rax,%rcx,4),%ecx
 1086b42:	cmp    %ebp,%ecx
 1086b44:	jae    1086e1a <check_input_resolve_range+0x412a>
 1086b4a:	lea    0x2(%r13),%edx
 1086b4e:	cmp    %ecx,%edx
 1086b50:	jae    1087112 <check_input_resolve_range+0x4422>
 1086b56:	mov    0x10(%r12),%rsi
 1086b5b:	jmp    1086c99 <check_input_resolve_range+0x3fa9>
 1086b60:	mov    0x18(%r12),%rax
 1086b65:	cmpl   $0x4f,(%rax,%rbp,4)
 1086b69:	jne    1086b8f <check_input_resolve_range+0x3e9f>
 1086b6b:	mov    $0x102,%edx
 1086b70:	mov    %rbx,%rdi
 1086b73:	mov    %r13d,%esi
 1086b76:	vzeroupper
 1086b79:	call   1095a40 <check_input_vararg_prepare>
 1086b7e:	mov    0x138(%rbx),%rax
 1086b85:	cmpb   $0x0,(%rax,%rbp,1)
 1086b89:	jne    1086aef <check_input_resolve_range+0x3dff>
 1086b8f:	mov    0x18(%r12),%rax
 1086b94:	mov    (%rax,%rbp,4),%eax
 1086b97:	cmp    $0x7e,%eax
 1086b9a:	je     1086ba5 <check_input_resolve_range+0x3eb5>
 1086b9c:	cmp    $0x50,%eax
 1086b9f:	jne    1086aef <check_input_resolve_range+0x3dff>
 1086ba5:	mov    0x8(%rbx),%rcx
 1086ba9:	xor    %r8d,%r8d
 1086bac:	cmp    $0x7e,%eax
 1086baf:	lea    0x1(%r13),%ebx
 1086bb3:	sete   %r9b
 1086bb7:	mov    0x30(%rcx),%edi
 1086bba:	cmp    %edi,%ebx
 1086bbc:	jae    1086d81 <check_input_resolve_range+0x4091>
 1086bc2:	mov    0x60(%rcx),%r10
 1086bc6:	mov    %ebx,%r11d
 1086bc9:	xor    %esi,%esi
 1086bcb:	mov    (%r10,%r11,4),%edx
 1086bcf:	cmp    %edx,%ebx
 1086bd1:	jae    1087197 <check_input_resolve_range+0x44a7>
 1086bd7:	mov    0x8(%rsp),%rbx
 1086bdc:	cmp    %edi,%edx
 1086bde:	jae    1087190 <check_input_resolve_range+0x44a0>
 1086be4:	mov    0x50(%rcx),%rsi
 1086be8:	cmpb   $0x2f,(%rsi,%r11,1)
 1086bed:	jne    10871a3 <check_input_resolve_range+0x44b3>
 1086bf3:	lea    0x2(%r13),%r11d
 1086bf7:	mov    $0x1,%sil
 1086bfa:	cmp    %edx,%r11d
 1086bfd:	jae    10871ac <check_input_resolve_range+0x44bc>
 1086c03:	mov    0x10(%rcx),%rdi
 1086c07:	jmp    1086d4b <check_input_resolve_range+0x405b>
 1086c0c:	mov    0x18(%r12),%rax
 1086c11:	mov    (%rax,%rbp,4),%eax
 1086c14:	cmp    $0x4c,%eax
 1086c17:	je     1086c22 <check_input_resolve_range+0x3f32>
 1086c19:	cmp    $0x28,%eax
 1086c1c:	jne    1086b00 <check_input_resolve_range+0x3e10>
 1086c22:	mov    0x8(%rbx),%rax
 1086c26:	lea    0x1(%r13),%r10d
 1086c2a:	mov    0x30(%rax),%ecx
 1086c2d:	cmp    %ecx,%r10d
 1086c30:	jae    1086d23 <check_input_resolve_range+0x4033>
 1086c36:	mov    0x60(%rax),%r8
 1086c3a:	mov    %r10d,%r9d
 1086c3d:	xor    %edi,%edi
 1086c3f:	mov    (%r8,%r9,4),%edx
 1086c43:	cmp    %edx,%r10d
 1086c46:	jae    1086e16 <check_input_resolve_range+0x4126>
 1086c4c:	cmp    %ecx,%edx
 1086c4e:	jae    1086e16 <check_input_resolve_range+0x4126>
 1086c54:	mov    0x50(%rax),%rcx
 1086c58:	cmpb   $0x2f,(%rcx,%r9,1)
 1086c5d:	jne    1086e2d <check_input_resolve_range+0x413d>
 1086c63:	lea    0x2(%r13),%r9d
 1086c67:	mov    $0x1,%dil
 1086c6a:	cmp    %edx,%r9d
 1086c6d:	jae    1086d19 <check_input_resolve_range+0x4029>
 1086c73:	mov    0x10(%rax),%rcx
 1086c77:	jmp    1086cef <check_input_resolve_range+0x3fff>
 1086c79:	cmp    $0xa,%r8d
 1086c7d:	jne    1086cb4 <check_input_resolve_range+0x3fc4>
 1086c7f:	mov    (%rax,%rdi,4),%edi
 1086c82:	lea    0x1(%rdi),%ebp
 1086c85:	cmp    %ecx,%edi
 1086c87:	cmovae %ecx,%ebp
 1086c8a:	cmp    %edx,%edi
 1086c8c:	cmovbe %ecx,%ebp
 1086c8f:	mov    %ebp,%edx
 1086c91:	cmp    %ecx,%ebp
 1086c93:	jae    1087114 <check_input_resolve_range+0x4424>
 1086c99:	mov    %edx,%edi
 1086c9b:	movzbl (%rsi,%rdi,1),%r8d
 1086ca0:	cmp    $0x9,%r8d
 1086ca4:	jg     1086c79 <check_input_resolve_range+0x3f89>
 1086ca6:	cmp    $0x6,%r8d
 1086caa:	je     1086c7f <check_input_resolve_range+0x3f8f>
 1086cac:	cmp    $0x8,%r8d
 1086cb0:	je     1086c7f <check_input_resolve_range+0x3f8f>
 1086cb2:	jmp    1086cbe <check_input_resolve_range+0x3fce>
 1086cb4:	cmp    $0x33,%r8d
 1086cb8:	je     10872e5 <check_input_resolve_range+0x45f5>
 1086cbe:	inc    %edx
 1086cc0:	mov    %edx,%ebp
 1086cc2:	cmp    %ecx,%ebp
 1086cc4:	jb     1086c99 <check_input_resolve_range+0x3fa9>
 1086cc6:	jmp    1087114 <check_input_resolve_range+0x4424>
 1086ccb:	cmp    $0xa,%r11d
 1086ccf:	jne    1086d0b <check_input_resolve_range+0x401b>
 1086cd1:	mov    (%r8,%r10,4),%r10d
 1086cd5:	lea    0x1(%r10),%r11d
 1086cd9:	cmp    %edx,%r10d
 1086cdc:	cmovae %edx,%r11d
 1086ce0:	cmp    %r9d,%r10d
 1086ce3:	cmovbe %edx,%r11d
 1086ce7:	mov    %r11d,%r9d
 1086cea:	cmp    %edx,%r9d
 1086ced:	jae    1086d19 <check_input_resolve_range+0x4029>
 1086cef:	mov    %r9d,%r10d
 1086cf2:	movzbl (%rcx,%r10,1),%r11d
 1086cf7:	cmp    $0x9,%r11d
 1086cfb:	jg     1086ccb <check_input_resolve_range+0x3fdb>
 1086cfd:	cmp    $0x6,%r11d
 1086d01:	je     1086cd1 <check_input_resolve_range+0x3fe1>
 1086d03:	cmp    $0x8,%r11d
 1086d07:	je     1086cd1 <check_input_resolve_range+0x3fe1>
 1086d09:	jmp    1086d11 <check_input_resolve_range+0x4021>
 1086d0b:	cmp    $0x33,%r11d
 1086d0f:	je     1086d19 <check_input_resolve_range+0x4029>
 1086d11:	inc    %r9d
 1086d14:	cmp    %edx,%r9d
 1086d17:	jb     1086cef <check_input_resolve_range+0x3fff>
 1086d19:	mov    %edx,%ecx
 1086d1b:	mov    %r9d,%edx
 1086d1e:	jmp    1086e31 <check_input_resolve_range+0x4141>
 1086d23:	xor    %edi,%edi
 1086d25:	mov    %ecx,%edx
 1086d27:	jmp    1086e31 <check_input_resolve_range+0x4141>
 1086d2c:	cmp    $0xa,%ebp
 1086d2f:	jne    1086d63 <check_input_resolve_range+0x4073>
 1086d31:	mov    (%r10,%rbx,4),%ebx
 1086d35:	lea    0x1(%rbx),%ebp
 1086d38:	cmp    %edx,%ebx
 1086d3a:	cmovae %edx,%ebp
 1086d3d:	cmp    %r11d,%ebx
 1086d40:	cmovbe %edx,%ebp
 1086d43:	mov    %ebp,%r11d
 1086d46:	cmp    %edx,%r11d
 1086d49:	jae    1086d70 <check_input_resolve_range+0x4080>
 1086d4b:	mov    %r11d,%ebx
 1086d4e:	movzbl (%rdi,%rbx,1),%ebp
 1086d52:	cmp    $0x9,%ebp
 1086d55:	jg     1086d2c <check_input_resolve_range+0x403c>
 1086d57:	cmp    $0x6,%ebp
 1086d5a:	je     1086d31 <check_input_resolve_range+0x4041>
 1086d5c:	cmp    $0x8,%ebp
 1086d5f:	je     1086d31 <check_input_resolve_range+0x4041>
 1086d61:	jmp    1086d68 <check_input_resolve_range+0x4078>
 1086d63:	cmp    $0x33,%ebp
 1086d66:	je     1086d70 <check_input_resolve_range+0x4080>
 1086d68:	inc    %r11d
 1086d6b:	cmp    %edx,%r11d
 1086d6e:	jb     1086d4b <check_input_resolve_range+0x405b>
 1086d70:	mov    0x8(%rsp),%rbx
 1086d75:	mov    0x28(%rsp),%rbp
 1086d7a:	mov    %edx,%edi
 1086d7c:	mov    %r11d,%edx
 1086d7f:	jmp    1086d8a <check_input_resolve_range+0x409a>
 1086d81:	mov    0x8(%rsp),%rbx
 1086d86:	xor    %esi,%esi
 1086d88:	mov    %edi,%edx
 1086d8a:	lea    0x2(%r13),%r11d
 1086d8e:	cmp    %edx,%r11d
 1086d91:	jae    108721d <check_input_resolve_range+0x452d>
 1086d97:	lea    0x1(%rdx),%r10d
 1086d9b:	cmp    %edi,%r10d
 1086d9e:	jae    108721d <check_input_resolve_range+0x452d>
 1086da4:	mov    %r9b,%r8b
 1086da7:	mov    0x10(%rcx),%r9
 1086dab:	mov    %r10d,%ebx
 1086dae:	lea    0x313(,%r8,4),%r8d
 1086db6:	jmp    1086de7 <check_input_resolve_range+0x40f7>
 1086db8:	nopl   0x0(%rax,%rax,1)
 1086dc0:	cmp    $0xa,%ebp
 1086dc3:	jne    1086e00 <check_input_resolve_range+0x4110>
 1086dc5:	mov    0x60(%rcx),%r15
 1086dc9:	mov    (%r15,%r14,4),%r14d
 1086dcd:	lea    0x1(%r14),%ebp
 1086dd1:	cmp    %edi,%r14d
 1086dd4:	cmovae %edi,%ebp
 1086dd7:	cmp    %ebx,%r14d
 1086dda:	cmovbe %edi,%ebp
 1086ddd:	mov    %ebp,%ebx
 1086ddf:	cmp    %edi,%ebp
 1086de1:	jae    10871b8 <check_input_resolve_range+0x44c8>
 1086de7:	mov    %ebx,%r14d
 1086dea:	movzbl (%r9,%r14,1),%ebp
 1086def:	cmp    $0x9,%ebp
 1086df2:	jg     1086dc0 <check_input_resolve_range+0x40d0>
 1086df4:	cmp    $0x6,%ebp
 1086df7:	je     1086dc5 <check_input_resolve_range+0x40d5>
 1086df9:	cmp    $0x8,%ebp
 1086dfc:	je     1086dc5 <check_input_resolve_range+0x40d5>
 1086dfe:	jmp    1086e09 <check_input_resolve_range+0x4119>
 1086e00:	cmp    $0x33,%ebp
 1086e03:	je     10871b6 <check_input_resolve_range+0x44c6>
 1086e09:	inc    %ebx
 1086e0b:	mov    %ebx,%ebp
 1086e0d:	cmp    %edi,%ebp
 1086e0f:	jb     1086de7 <check_input_resolve_range+0x40f7>
 1086e11:	jmp    10871b8 <check_input_resolve_range+0x44c8>
 1086e16:	mov    %edx,%ecx
 1086e18:	jmp    1086e31 <check_input_resolve_range+0x4141>
 1086e1a:	mov    %ecx,%ebp
 1086e1c:	lea    0x2(%r13),%ecx
 1086e20:	cmp    %ebp,%ecx
 1086e22:	jb     1087120 <check_input_resolve_range+0x4430>
 1086e28:	jmp    10872f3 <check_input_resolve_range+0x4603>
 1086e2d:	xor    %edi,%edi
 1086e2f:	mov    %edx,%ecx
 1086e31:	mov    0x18(%rax),%r8
 1086e35:	lea    0x2(%r13),%r9d
 1086e39:	cmp    %edx,%r9d
 1086e3c:	setb   %r10b
 1086e40:	cmp    %ecx,%edx
 1086e42:	setb   %r9b
 1086e46:	and    %dil,%r9b
 1086e49:	mov    (%r8,%rbp,4),%r8d
 1086e4d:	and    %r10b,%r9b
 1086e50:	cmp    $0x1,%r9b
 1086e54:	jne    1087080 <check_input_resolve_range+0x4390>
 1086e5a:	cmp    $0x28,%r8d
 1086e5e:	jne    1087080 <check_input_resolve_range+0x4390>
 1086e64:	inc    %edx
 1086e66:	cmp    %ecx,%edx
 1086e68:	jae    1088d73 <check_input_resolve_range+0x6083>
 1086e6e:	xchg   %ax,%ax
 1086e70:	mov    0x10(%rax),%rdi
 1086e74:	mov    %edx,%r8d
 1086e77:	jmp    1086ea5 <check_input_resolve_range+0x41b5>
 1086e79:	nopl   0x0(%rax)
 1086e80:	cmp    $0xa,%r9d
 1086e84:	jne    1086ec1 <check_input_resolve_range+0x41d1>
 1086e86:	mov    0x60(%rax),%r9
 1086e8a:	mov    (%r9,%rsi,4),%r9d
 1086e8e:	lea    0x1(%r9),%esi
 1086e92:	cmp    %ecx,%r9d
 1086e95:	cmovae %ecx,%esi
 1086e98:	cmp    %r8d,%r9d
 1086e9b:	cmovbe %ecx,%esi
 1086e9e:	mov    %esi,%r8d
 1086ea1:	cmp    %ecx,%esi
 1086ea3:	jae    1086ed9 <check_input_resolve_range+0x41e9>
 1086ea5:	mov    %r8d,%esi
 1086ea8:	movzbl (%rdi,%rsi,1),%r9d
 1086ead:	cmp    $0x9,%r9d
 1086eb1:	jg     1086e80 <check_input_resolve_range+0x4190>
 1086eb3:	cmp    $0x6,%r9d
 1086eb7:	je     1086e86 <check_input_resolve_range+0x4196>
 1086eb9:	cmp    $0x8,%r9d
 1086ebd:	je     1086e86 <check_input_resolve_range+0x4196>
 1086ebf:	jmp    1086ec7 <check_input_resolve_range+0x41d7>
 1086ec1:	cmp    $0x2f,%r9d
 1086ec5:	je     1086ed6 <check_input_resolve_range+0x41e6>
 1086ec7:	inc    %r8d
 1086eca:	mov    %r8d,%esi
 1086ecd:	mov    %esi,%r8d
 1086ed0:	cmp    %ecx,%esi
 1086ed2:	jb     1086ea5 <check_input_resolve_range+0x41b5>
 1086ed4:	jmp    1086ed9 <check_input_resolve_range+0x41e9>
 1086ed6:	mov    %r8d,%esi
 1086ed9:	cmp    %ecx,%esi
 1086edb:	jae    1088d7c <check_input_resolve_range+0x608c>
 1086ee1:	lea    0x1(%rsi),%r9d
 1086ee5:	cmp    %ecx,%r9d
 1086ee8:	jae    1088d7c <check_input_resolve_range+0x608c>
 1086eee:	mov    %r9d,%r10d
 1086ef1:	jmp    1086f28 <check_input_resolve_range+0x4238>
 1086ef3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1086f00:	cmp    $0xa,%r11d
 1086f04:	jne    1086f44 <check_input_resolve_range+0x4254>
 1086f06:	mov    0x60(%rax),%r11
 1086f0a:	mov    (%r11,%r8,4),%r11d
 1086f0e:	lea    0x1(%r11),%r8d
 1086f12:	cmp    %ecx,%r11d
 1086f15:	cmovae %ecx,%r8d
 1086f19:	cmp    %r10d,%r11d
 1086f1c:	cmovbe %ecx,%r8d
 1086f20:	mov    %r8d,%r10d
 1086f23:	cmp    %ecx,%r8d
 1086f26:	jae    1086f5a <check_input_resolve_range+0x426a>
 1086f28:	mov    %r10d,%r8d
 1086f2b:	movzbl (%rdi,%r8,1),%r11d
 1086f30:	cmp    $0x9,%r11d
 1086f34:	jg     1086f00 <check_input_resolve_range+0x4210>
 1086f36:	cmp    $0x6,%r11d
 1086f3a:	je     1086f06 <check_input_resolve_range+0x4216>
 1086f3c:	cmp    $0x8,%r11d
 1086f40:	je     1086f06 <check_input_resolve_range+0x4216>
 1086f42:	jmp    1086f4a <check_input_resolve_range+0x425a>
 1086f44:	cmp    $0x33,%r11d
 1086f48:	je     1086f57 <check_input_resolve_range+0x4267>
 1086f4a:	inc    %r10d
 1086f4d:	mov    %r10d,%r8d
 1086f50:	cmp    %ecx,%r8d
 1086f53:	jb     1086f28 <check_input_resolve_range+0x4238>
 1086f55:	jmp    1086f5a <check_input_resolve_range+0x426a>
 1086f57:	mov    %r10d,%r8d
 1086f5a:	cmp    %esi,%edx
 1086f5c:	jae    1088d7c <check_input_resolve_range+0x608c>
 1086f62:	cmp    %r8d,%r9d
 1086f65:	jae    1088d7c <check_input_resolve_range+0x608c>
 1086f6b:	mov    %edx,%r10d
 1086f6e:	movzbl (%rdi,%r10,1),%edi
 1086f73:	mov    0x1a8(%rbx),%r11
 1086f7a:	mov    $0x0,%r9d
 1086f80:	cmp    $0x4b,%dil
 1086f84:	cmovne %esi,%r9d
 1086f88:	mov    %r9d,(%r11,%r10,4)
 1086f8c:	mov    %esi,%r11d
 1086f8f:	sub    %edx,%r11d
 1086f92:	mov    %r10,%r9
 1086f95:	and    $0x7,%r11d
 1086f99:	je     1086fbe <check_input_resolve_range+0x42ce>
 1086f9b:	mov    %r10,%r9
 1086f9e:	xchg   %ax,%ax
 1086fa0:	mov    0x8(%rsp),%rbx
 1086fa5:	mov    0x138(%rbx),%rbx
 1086fac:	movb   $0x1,(%rbx,%r9,1)
 1086fb1:	mov    0x8(%rsp),%rbx
 1086fb6:	inc    %r9
 1086fb9:	dec    %r11
 1086fbc:	jne    1086fa0 <check_input_resolve_range+0x42b0>
 1086fbe:	mov    %esi,%r11d
 1086fc1:	sub    %r11,%r10
 1086fc4:	cmp    $0xfffffffffffffff8,%r10
 1086fc8:	ja     1087040 <check_input_resolve_range+0x4350>
 1086fca:	nopw   0x0(%rax,%rax,1)
 1086fd0:	mov    0x138(%rbx),%r10
 1086fd7:	movb   $0x1,(%r10,%r9,1)
 1086fdc:	mov    0x138(%rbx),%r10
 1086fe3:	movb   $0x1,0x1(%r10,%r9,1)
 1086fe9:	mov    0x138(%rbx),%r10
 1086ff0:	movb   $0x1,0x2(%r10,%r9,1)
 1086ff6:	mov    0x138(%rbx),%r10
 1086ffd:	movb   $0x1,0x3(%r10,%r9,1)
 1087003:	mov    0x138(%rbx),%r10
 108700a:	movb   $0x1,0x4(%r10,%r9,1)
 1087010:	mov    0x138(%rbx),%r10
 1087017:	movb   $0x1,0x5(%r10,%r9,1)
 108701d:	mov    0x138(%rbx),%r10
 1087024:	movb   $0x1,0x6(%r10,%r9,1)
 108702a:	mov    0x138(%rbx),%r10
 1087031:	movb   $0x1,0x7(%r10,%r9,1)
 1087037:	add    $0x8,%r9
 108703b:	cmp    %r9,%r11
 108703e:	jne    1086fd0 <check_input_resolve_range+0x42e0>
 1087040:	cmp    $0x4b,%dil
 1087044:	setne  %dil
 1087048:	inc    %edx
 108704a:	cmp    %esi,%edx
 108704c:	sete   %sil
 1087050:	inc    %r8d
 1087053:	or     %dil,%sil
 1087056:	cmp    %ecx,%r8d
 1087059:	jae    1087067 <check_input_resolve_range+0x4377>
 108705b:	mov    %r8d,%edx
 108705e:	test   %sil,%sil
 1087061:	jne    1086e70 <check_input_resolve_range+0x4180>
 1087067:	test   %sil,%sil
 108706a:	je     1088d7c <check_input_resolve_range+0x608c>
 1087070:	mov    0x138(%rbx),%rsi
 1087077:	movb   $0x1,(%rsi,%rbp,1)
 108707b:	jmp    1086b00 <check_input_resolve_range+0x3e10>
 1087080:	cmp    $0x4c,%r8d
 1087084:	sete   %dil
 1087088:	and    %dil,%r9b
 108708b:	cmp    $0x1,%r9b
 108708f:	jne    1088d7c <check_input_resolve_range+0x608c>
 1087095:	inc    %edx
 1087097:	cmp    %ecx,%edx
 1087099:	jae    1088d7c <check_input_resolve_range+0x608c>
 108709f:	mov    0x10(%rax),%rdi
 10870a3:	mov    %edx,%r9d
 10870a6:	jmp    10870dc <check_input_resolve_range+0x43ec>
 10870a8:	nopl   0x0(%rax,%rax,1)
 10870b0:	cmp    $0xa,%r10d
 10870b4:	jne    10870f8 <check_input_resolve_range+0x4408>
 10870b6:	mov    0x60(%rax),%r10
 10870ba:	mov    (%r10,%r8,4),%r10d
 10870be:	lea    0x1(%r10),%r8d
 10870c2:	cmp    %ecx,%r10d
 10870c5:	cmovae %ecx,%r8d
 10870c9:	cmp    %r9d,%r10d
 10870cc:	cmovbe %ecx,%r8d
 10870d0:	mov    %r8d,%r9d
 10870d3:	cmp    %ecx,%r8d
 10870d6:	jae    1087271 <check_input_resolve_range+0x4581>
 10870dc:	mov    %r9d,%r8d
 10870df:	movzbl (%rdi,%r8,1),%r10d
 10870e4:	cmp    $0x9,%r10d
 10870e8:	jg     10870b0 <check_input_resolve_range+0x43c0>
 10870ea:	cmp    $0x6,%r10d
 10870ee:	je     10870b6 <check_input_resolve_range+0x43c6>
 10870f0:	cmp    $0x8,%r10d
 10870f4:	je     10870b6 <check_input_resolve_range+0x43c6>
 10870f6:	jmp    1087102 <check_input_resolve_range+0x4412>
 10870f8:	cmp    $0x33,%r10d
 10870fc:	je     108726e <check_input_resolve_range+0x457e>
 1087102:	inc    %r9d
 1087105:	mov    %r9d,%r8d
 1087108:	cmp    %ecx,%r8d
 108710b:	jb     10870dc <check_input_resolve_range+0x43ec>
 108710d:	jmp    1087271 <check_input_resolve_range+0x4581>
 1087112:	mov    %edx,%ebp
 1087114:	lea    0x2(%r13),%ecx
 1087118:	cmp    %ebp,%ecx
 108711a:	jae    10872f3 <check_input_resolve_range+0x4603>
 1087120:	mov    0x50(%r12),%rax
 1087125:	mov    %ecx,%r14d
 1087128:	nopl   0x0(%rax,%rax,1)
 1087130:	cmpb   $0x7,(%rax,%r14,1)
 1087135:	jne    1087144 <check_input_resolve_range+0x4454>
 1087137:	inc    %r14
 108713a:	cmp    %r14d,%ebp
 108713d:	jne    1087130 <check_input_resolve_range+0x4440>
 108713f:	jmp    10872f3 <check_input_resolve_range+0x4603>
 1087144:	mov    0x10(%r12),%rbx
 1087149:	movzbl (%rbx,%r14,1),%eax
 108714e:	add    $0xcb,%al
 1087150:	cmp    $0x1,%al
 1087152:	ja     10872f3 <check_input_resolve_range+0x4603>
 1087158:	mov    %r12,%rdi
 108715b:	mov    %r14d,%esi
 108715e:	mov    %ebp,%edx
 1087160:	vzeroupper
 1087163:	call   1095d90 <check_input_tag_body>
 1087168:	cmp    %ebp,%eax
 108716a:	jae    10872f3 <check_input_resolve_range+0x4603>
 1087170:	mov    %eax,%eax
 1087172:	cmpb   $0xa,(%rbx,%rax,1)
 1087176:	jne    10872f3 <check_input_resolve_range+0x4603>
 108717c:	mov    0x8(%rsp),%rdi
 1087181:	mov    %r14d,%esi
 1087184:	mov    %ebp,%edx
 1087186:	call   1096080 <check_input_tag_definition>
 108718b:	jmp    10872f3 <check_input_resolve_range+0x4603>
 1087190:	mov    %edx,%edi
 1087192:	jmp    1086d8a <check_input_resolve_range+0x409a>
 1087197:	mov    0x8(%rsp),%rbx
 108719c:	mov    %edx,%edi
 108719e:	jmp    1086d8a <check_input_resolve_range+0x409a>
 10871a3:	xor    %esi,%esi
 10871a5:	mov    %edx,%edi
 10871a7:	jmp    1086d8a <check_input_resolve_range+0x409a>
 10871ac:	mov    %edx,%edi
 10871ae:	mov    %r11d,%edx
 10871b1:	jmp    1086d8a <check_input_resolve_range+0x409a>
 10871b6:	mov    %ebx,%ebp
 10871b8:	cmp    %edi,%ebp
 10871ba:	mov    0x8(%rsp),%rbx
 10871bf:	mov    0x28(%rsp),%rbp
 10871c4:	setne  %cl
 10871c7:	xor    $0x1,%sil
 10871cb:	or     %cl,%sil
 10871ce:	jne    108721d <check_input_resolve_range+0x452d>
 10871d0:	mov    0x208(%rbx),%r9
 10871d7:	mov    %edi,%ecx
 10871d9:	cmp    $0x7e,%eax
 10871dc:	mov    $0x1,%esi
 10871e1:	cmove  %r11d,%r10d
 10871e5:	cmovne %edi,%edx
 10871e8:	sub    %r10d,%edx
 10871eb:	mov    %r8w,(%r9,%rcx,2)
 10871f0:	mov    0x210(%rbx),%rax
 10871f7:	mov    %edi,(%rax,%r10,4)
 10871fb:	mov    0x138(%rbx),%rax
 1087202:	movb   $0x1,(%rax,%rbp,1)
 1087206:	mov    0x138(%rbx),%rdi
 108720d:	add    %r10,%rdi
 1087210:	vzeroupper
 1087213:	call   788430 <memset@plt>
 1087218:	jmp    1086aef <check_input_resolve_range+0x3dff>
 108721d:	mov    (%rbx),%rax
 1087220:	mov    0x230(%rax),%ecx
 1087226:	cmp    0x234(%rax),%ecx
 108722c:	jae    1087262 <check_input_resolve_range+0x4572>
 108722e:	movzbl 0x3c5(%rax),%edx
 1087235:	mov    0x228(%rax),%rsi
 108723c:	lea    0x1(%rcx),%edi
 108723f:	mov    %edi,0x230(%rax)
 1087245:	lea    (%rcx,%rcx,2),%rax
 1087249:	lea    0x1(%rdx,%rdx,2),%edx
 108724d:	mov    %r13d,(%rsi,%rax,4)
 1087251:	mov    %edx,0x4(%rsi,%rax,4)
 1087255:	movl   $0x0,0x8(%rsi,%rax,4)
 108725d:	jmp    1086aef <check_input_resolve_range+0x3dff>
 1087262:	movb   $0x1,0x3c5(%rax)
 1087269:	jmp    1086aef <check_input_resolve_range+0x3dff>
 108726e:	mov    %r9d,%r8d
 1087271:	cmp    %r8d,%edx
 1087274:	jae    1088d7c <check_input_resolve_range+0x608c>
 108727a:	inc    %r8d
 108727d:	cmp    %ecx,%r8d
 1087280:	jb     10872b0 <check_input_resolve_range+0x45c0>
 1087282:	jmp    1088d7c <check_input_resolve_range+0x608c>
 1087287:	cmp    $0xa,%r9d
 108728b:	jne    10872cc <check_input_resolve_range+0x45dc>
 108728d:	mov    0x60(%rax),%r9
 1087291:	mov    (%r9,%rdx,4),%r9d
 1087295:	lea    0x1(%r9),%edx
 1087299:	cmp    %ecx,%r9d
 108729c:	cmovae %ecx,%edx
 108729f:	cmp    %r8d,%r9d
 10872a2:	cmovbe %ecx,%edx
 10872a5:	mov    %edx,%r8d
 10872a8:	cmp    %ecx,%edx
 10872aa:	jae    1088d6f <check_input_resolve_range+0x607f>
 10872b0:	mov    %r8d,%edx
 10872b3:	movzbl (%rdi,%rdx,1),%r9d
 10872b8:	cmp    $0x9,%r9d
 10872bc:	jg     1087287 <check_input_resolve_range+0x4597>
 10872be:	cmp    $0x6,%r9d
 10872c2:	je     108728d <check_input_resolve_range+0x459d>
 10872c4:	cmp    $0x8,%r9d
 10872c8:	je     108728d <check_input_resolve_range+0x459d>
 10872ca:	jmp    10872d6 <check_input_resolve_range+0x45e6>
 10872cc:	cmp    $0x33,%r9d
 10872d0:	je     1088d6c <check_input_resolve_range+0x607c>
 10872d6:	inc    %r8d
 10872d9:	mov    %r8d,%edx
 10872dc:	cmp    %ecx,%edx
 10872de:	jb     10872b0 <check_input_resolve_range+0x45c0>
 10872e0:	jmp    1088d6f <check_input_resolve_range+0x607f>
 10872e5:	mov    %edx,%ebp
 10872e7:	lea    0x2(%r13),%ecx
 10872eb:	cmp    %ebp,%ecx
 10872ed:	jb     1087120 <check_input_resolve_range+0x4430>
 10872f3:	mov    0x8(%rsp),%rbx
 10872f8:	mov    0x28(%rsp),%rbp
 10872fd:	mov    (%rbx),%rax
 1087300:	cmpl   $0x0,0x230(%rax)
 1087307:	jne    1087550 <check_input_resolve_range+0x4860>
 108730d:	cmpb   $0x0,0x3c5(%rax)
 1087314:	jne    1087550 <check_input_resolve_range+0x4860>
 108731a:	mov    0x8(%rbx),%rax
 108731e:	mov    %r15d,%ecx
 1087321:	mov    0x30(%rax),%edx
 1087324:	mov    %edx,%r14d
 1087327:	cmp    %edx,%r15d
 108732a:	jae    1087334 <check_input_resolve_range+0x4644>
 108732c:	mov    0x60(%rax),%rsi
 1087330:	mov    (%rsi,%rcx,4),%r14d
 1087334:	mov    0x18(%rax),%rsi
 1087338:	vpxor  %xmm0,%xmm0,%xmm0
 108733c:	mov    (%rsi,%rbp,4),%esi
 108733f:	vmovdqu64 %zmm0,0x150(%rsp)
 108734a:	vmovdqu64 %zmm0,0x130(%rsp)
 1087355:	add    $0xffffffb3,%esi
 1087358:	cmp    $0x1,%esi
 108735b:	ja     10874f9 <check_input_resolve_range+0x4809>
 1087361:	cmp    %r14d,%r15d
 1087364:	jae    10874f9 <check_input_resolve_range+0x4809>
 108736a:	cmp    %edx,%r14d
 108736d:	jae    10874f9 <check_input_resolve_range+0x4809>
 1087373:	mov    0x50(%rax),%rax
 1087377:	cmpb   $0x2f,(%rax,%rcx,1)
 108737b:	jne    10874f9 <check_input_resolve_range+0x4809>
 1087381:	lea    0x1(%r14),%edx
 1087385:	mov    %rbx,%rdi
 1087388:	mov    %r13d,%esi
 108738b:	xor    %ecx,%ecx
 108738d:	xor    %r8d,%r8d
 1087390:	lea    0x130(%rsp),%r9
 1087398:	push   $0x0
 108739a:	lea    0x208(%rsp),%rax
 10873a2:	push   %rax
 10873a3:	vzeroupper
 10873a6:	call   10c24f0 <check_input_constant_read>
 10873ab:	add    $0x10,%rsp
 10873af:	test   %al,%al
 10873b1:	je     10874f9 <check_input_resolve_range+0x4809>
 10873b7:	cmpl   $0x0,0x184(%rsp)
 10873bf:	jne    10874f9 <check_input_resolve_range+0x4809>
 10873c5:	cmpl   $0x1,0x13c(%rsp)
 10873cd:	jne    10874f9 <check_input_resolve_range+0x4809>
 10873d3:	testb  $0x10,0x138(%rsp)
 10873db:	jne    10874f9 <check_input_resolve_range+0x4809>
 10873e1:	mov    0x1c8(%rbx),%eax
 10873e7:	lea    0x1(%rax),%ecx
 10873ea:	lea    (%rax,%rax,2),%rax
 10873ee:	mov    %ecx,0x1c8(%rbx)
 10873f4:	vmovdqu64 0x130(%rsp),%zmm0
 10873ff:	vmovdqu64 0x150(%rsp),%zmm1
 108740a:	mov    0x1b8(%rbx),%rdx
 1087411:	shl    $0x5,%rax
 1087415:	vmovdqu64 %zmm1,0x20(%rdx,%rax,1)
 1087420:	vmovdqu64 %zmm0,(%rdx,%rax,1)
 1087427:	mov    %r14d,%edx
 108742a:	mov    0x1c0(%rbx),%rax
 1087431:	mov    %ecx,(%rax,%rdx,4)
 1087434:	mov    %r14d,%ecx
 1087437:	sub    %r13d,%ecx
 108743a:	jb     1087550 <check_input_resolve_range+0x4860>
 1087440:	lea    0x1(%rcx),%edx
 1087443:	mov    %rbp,%rax
 1087446:	and    $0x7,%edx
 1087449:	je     1087460 <check_input_resolve_range+0x4770>
 108744b:	mov    %rbp,%rax
 108744e:	mov    0x138(%rbx),%rsi
 1087455:	movb   $0x1,(%rsi,%rax,1)
 1087459:	inc    %rax
 108745c:	dec    %edx
 108745e:	jne    108744e <check_input_resolve_range+0x475e>
 1087460:	cmp    $0x7,%ecx
 1087463:	jb     1087550 <check_input_resolve_range+0x4860>
 1087469:	not    %r14d
 108746c:	xor    %ecx,%ecx
 108746e:	add    %rax,%r14
 1087471:	mov    0x138(%rbx),%rdx
 1087478:	add    %rax,%rdx
 108747b:	movb   $0x1,(%rcx,%rdx,1)
 108747f:	mov    0x138(%rbx),%rdx
 1087486:	add    %rax,%rdx
 1087489:	movb   $0x1,0x1(%rcx,%rdx,1)
 108748e:	mov    0x138(%rbx),%rdx
 1087495:	add    %rax,%rdx
 1087498:	movb   $0x1,0x2(%rcx,%rdx,1)
 108749d:	mov    0x138(%rbx),%rdx
 10874a4:	add    %rax,%rdx
 10874a7:	movb   $0x1,0x3(%rcx,%rdx,1)
 10874ac:	mov    0x138(%rbx),%rdx
 10874b3:	add    %rax,%rdx
 10874b6:	movb   $0x1,0x4(%rcx,%rdx,1)
 10874bb:	mov    0x138(%rbx),%rdx
 10874c2:	add    %rax,%rdx
 10874c5:	movb   $0x1,0x5(%rcx,%rdx,1)
 10874ca:	mov    0x138(%rbx),%rdx
 10874d1:	add    %rax,%rdx
 10874d4:	movb   $0x1,0x6(%rcx,%rdx,1)
 10874d9:	mov    0x138(%rbx),%rdx
 10874e0:	add    %rax,%rdx
 10874e3:	movb   $0x1,0x7(%rcx,%rdx,1)
 10874e8:	add    $0x8,%rcx
 10874ec:	mov    %r14d,%edx
 10874ef:	add    %ecx,%edx
 10874f1:	jne    1087471 <check_input_resolve_range+0x4781>
 10874f7:	jmp    1087550 <check_input_resolve_range+0x4860>
 10874f9:	mov    (%rbx),%rax
 10874fc:	mov    0x230(%rax),%ecx
 1087502:	cmp    0x234(%rax),%ecx
 1087508:	jae    108753b <check_input_resolve_range+0x484b>
 108750a:	movzbl 0x3c5(%rax),%edx
 1087511:	mov    0x228(%rax),%rsi
 1087518:	lea    0x1(%rcx),%edi
 108751b:	mov    %edi,0x230(%rax)
 1087521:	lea    (%rcx,%rcx,2),%rax
 1087525:	lea    0x1(%rdx,%rdx,2),%edx
 1087529:	mov    %r13d,(%rsi,%rax,4)
 108752d:	mov    %edx,0x4(%rsi,%rax,4)
 1087531:	movl   $0x0,0x8(%rsi,%rax,4)
 1087539:	jmp    1087550 <check_input_resolve_range+0x4860>
 108753b:	movb   $0x1,0x3c5(%rax)
 1087542:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1087550:	mov    0x1a8(%rbx),%rax
 1087557:	mov    (%rax,%rbp,4),%r14d
 108755b:	test   %r14,%r14
 108755e:	je     1087680 <check_input_resolve_range+0x4990>
 1087564:	cmp    %r13d,%r14d
 1087567:	jbe    1087640 <check_input_resolve_range+0x4950>
 108756d:	mov    $0x1,%ecx
 1087572:	vpxor  %xmm0,%xmm0,%xmm0
 1087576:	vmovdqu64 %zmm0,0x150(%rsp)
 1087581:	vmovdqu64 %zmm0,0x130(%rsp)
 108758c:	movl   $0x0,0x200(%rsp)
 1087597:	mov    %rbx,%rdi
 108759a:	mov    %r13d,%esi
 108759d:	mov    %r14d,%edx
 10875a0:	xor    %r8d,%r8d
 10875a3:	lea    0x130(%rsp),%r9
 10875ab:	push   $0x0
 10875ad:	lea    0x208(%rsp),%rax
 10875b5:	push   %rax
 10875b6:	vzeroupper
 10875b9:	call   10c24f0 <check_input_constant_read>
 10875be:	add    $0x10,%rsp
 10875c2:	mov    0x18(%rbx),%rsi
 10875c6:	mov    0x200(%rsp),%ecx
 10875cd:	test   %al,%al
 10875cf:	mov    $0x0,%r8d
 10875d5:	mov    (%rsi),%rdx
 10875d8:	cmovne %ecx,%r8d
 10875dc:	mov    %r8d,%eax
 10875df:	shr    $0x3,%eax
 10875e2:	cmpb   $0xf,(%rdx,%rax,1)
 10875e6:	jne    10875fd <check_input_resolve_range+0x490d>
 10875e8:	test   %r8d,%r8d
 10875eb:	je     1087640 <check_input_resolve_range+0x4950>
 10875ed:	mov    0x20(%rsi),%rdi
 10875f1:	mov    (%rdi,%rax,4),%edi
 10875f4:	mov    %edi,%r9d
 10875f7:	shr    $0x3,%r9d
 10875fb:	jmp    1087607 <check_input_resolve_range+0x4917>
 10875fd:	mov    %ecx,%edi
 10875ff:	mov    %rax,%r9
 1087602:	test   %r8d,%r8d
 1087605:	je     1087640 <check_input_resolve_range+0x4950>
 1087607:	mov    0x10(%rsi),%rsi
 108760b:	testb  $0x4,(%rsi,%r9,1)
 1087610:	je     1087640 <check_input_resolve_range+0x4950>
 1087612:	shr    $0x3,%edi
 1087615:	movzbl (%rdx,%rdi,1),%edx
 1087619:	cmp    $0x1,%edx
 108761c:	je     1087640 <check_input_resolve_range+0x4950>
 108761e:	cmp    $0xb,%edx
 1087621:	je     1087640 <check_input_resolve_range+0x4950>
 1087623:	testb  $0x8,(%rsi,%rax,1)
 1087627:	jne    1087640 <check_input_resolve_range+0x4950>
 1087629:	mov    0x1b0(%rbx),%rax
 1087630:	mov    %ecx,(%rax,%r14,4)
 1087634:	cmp    0xb8(%rsp),%r13d
 108763c:	je     108769d <check_input_resolve_range+0x49ad>
 108763e:	jmp    10876a6 <check_input_resolve_range+0x49b6>
 1087640:	mov    (%rbx),%rax
 1087643:	mov    0x230(%rax),%ecx
 1087649:	cmp    0x234(%rax),%ecx
 108764f:	jae    108768c <check_input_resolve_range+0x499c>
 1087651:	movzbl 0x3c5(%rax),%edx
 1087658:	mov    0x228(%rax),%rsi
 108765f:	lea    0x1(%rcx),%edi
 1087662:	mov    %edi,0x230(%rax)
 1087668:	lea    (%rcx,%rcx,2),%rax
 108766c:	lea    0x1(%rdx,%rdx,2),%edx
 1087670:	mov    %r13d,(%rsi,%rax,4)
 1087674:	mov    %edx,0x4(%rsi,%rax,4)
 1087678:	movl   $0x0,0x8(%rsi,%rax,4)
 1087680:	cmp    0xb8(%rsp),%r13d
 1087688:	je     108769d <check_input_resolve_range+0x49ad>
 108768a:	jmp    10876a6 <check_input_resolve_range+0x49b6>
 108768c:	movb   $0x1,0x3c5(%rax)
 1087693:	cmp    0xb8(%rsp),%r13d
 108769b:	jne    10876a6 <check_input_resolve_range+0x49b6>
 108769d:	cmpb   $0x0,0x458(%rbx)
 10876a4:	jne    10876e1 <check_input_resolve_range+0x49f1>
 10876a6:	mov    0x2d0(%rbx),%rax
 10876ad:	mov    0x28(%rsp),%rcx
 10876b2:	mov    (%rax,%rcx,4),%ebp
 10876b5:	cmp    $0xffffffff,%ebp
 10876b8:	je     10876e1 <check_input_resolve_range+0x49f1>
 10876ba:	nopw   0x0(%rax,%rax,1)
 10876c0:	mov    %rbx,%rdi
 10876c3:	mov    %ebp,%esi
 10876c5:	mov    %r13d,%edx
 10876c8:	vzeroupper
 10876cb:	call   1090a70 <check_input_bind>
 10876d0:	mov    0x2d8(%rbx),%rax
 10876d7:	mov    %ebp,%ecx
 10876d9:	mov    (%rax,%rcx,4),%ebp
 10876dc:	cmp    $0xffffffff,%ebp
 10876df:	jne    10876c0 <check_input_resolve_range+0x49d0>
 10876e1:	mov    0x238(%rbx),%rax
 10876e8:	mov    0x28(%rsp),%rbp
 10876ed:	mov    %rbx,%rdi
 10876f0:	mov    (%rax,%rbp,4),%eax
 10876f3:	test   %eax,%eax
 10876f5:	je     10877f0 <check_input_resolve_range+0x4b00>
 10876fb:	mov    0x228(%rdi),%rbx
 1087702:	dec    %eax
 1087704:	imul   $0x2c,%rax,%rax
 1087708:	cmpl   $0x2,0x20(%rbx,%rax,1)
 108770d:	jne    10877f0 <check_input_resolve_range+0x4b00>
 1087713:	add    %rax,%rbx
 1087716:	vpxor  %xmm0,%xmm0,%xmm0
 108771a:	xor    %ebp,%ebp
 108771c:	mov    %r13d,%esi
 108771f:	mov    $0x1,%ecx
 1087724:	xor    %r8d,%r8d
 1087727:	lea    0x130(%rsp),%r9
 108772f:	mov    0x1c(%rbx),%edx
 1087732:	vmovdqu64 %zmm0,0x150(%rsp)
 108773d:	vmovdqu64 %zmm0,0x130(%rsp)
 1087748:	movl   $0x0,0x200(%rsp)
 1087753:	push   $0x0
 1087755:	lea    0x208(%rsp),%rax
 108775d:	push   %rax
 108775e:	vzeroupper
 1087761:	call   10c24f0 <check_input_constant_read>
 1087766:	add    $0x10,%rsp
 108776a:	test   %al,%al
 108776c:	je     1087775 <check_input_resolve_range+0x4a85>
 108776e:	mov    0x200(%rsp),%ebp
 1087775:	mov    0x8(%rsp),%rdi
 108777a:	mov    %ebp,0x28(%rbx)
 108777d:	mov    0x1c(%rbx),%ecx
 1087780:	mov    0xa8(%rdi),%rax
 1087787:	mov    %ebp,(%rax,%rcx,4)
 108778a:	mov    0x28(%rsp),%rbp
 108778f:	cmpl   $0x0,0x28(%rbx)
 1087793:	jne    10877f0 <check_input_resolve_range+0x4b00>
 1087795:	mov    (%rdi),%rax
 1087798:	mov    0x230(%rax),%ecx
 108779e:	cmp    0x234(%rax),%ecx
 10877a4:	jae    10877d7 <check_input_resolve_range+0x4ae7>
 10877a6:	movzbl 0x3c5(%rax),%edx
 10877ad:	mov    0x228(%rax),%rsi
 10877b4:	lea    0x1(%rcx),%edi
 10877b7:	mov    %edi,0x230(%rax)
 10877bd:	lea    (%rcx,%rcx,2),%rax
 10877c1:	lea    0x1(%rdx,%rdx,2),%edx
 10877c5:	mov    %r13d,(%rsi,%rax,4)
 10877c9:	mov    %edx,0x4(%rsi,%rax,4)
 10877cd:	movl   $0x0,0x8(%rsi,%rax,4)
 10877d5:	jmp    10877de <check_input_resolve_range+0x4aee>
 10877d7:	movb   $0x1,0x3c5(%rax)
 10877de:	mov    0x8(%rsp),%rdi
 10877e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10877f0:	mov    0x210(%rdi),%rax
 10877f7:	mov    %rdi,%rbx
 10877fa:	mov    (%rax,%rbp,4),%r14d
 10877fe:	test   %r14,%r14
 1087801:	je     10878fb <check_input_resolve_range+0x4c0b>
 1087807:	mov    0x208(%rbx),%rax
 108780e:	cmpw   $0x317,(%rax,%r14,2)
 1087815:	jne    108787e <check_input_resolve_range+0x4b8e>
 1087817:	mov    %r13d,%edx
 108781a:	cmp    %r14d,%r13d
 108781d:	jae    1087881 <check_input_resolve_range+0x4b91>
 108781f:	mov    0x8(%rbx),%rax
 1087823:	mov    %r13d,%esi
 1087826:	mov    0x10(%rax),%rcx
 108782a:	jmp    1087853 <check_input_resolve_range+0x4b63>
 108782c:	nopl   0x0(%rax)
 1087830:	cmp    $0xa,%edi
 1087833:	jne    108786a <check_input_resolve_range+0x4b7a>
 1087835:	mov    0x60(%rax),%rdi
 1087839:	mov    (%rdi,%rdx,4),%edi
 108783c:	lea    0x1(%rdi),%edx
 108783f:	cmp    %r14d,%edi
 1087842:	cmovae %r14d,%edx
 1087846:	cmp    %esi,%edi
 1087848:	cmovbe %r14d,%edx
 108784c:	mov    %edx,%esi
 108784e:	cmp    %r14d,%edx
 1087851:	jae    1087881 <check_input_resolve_range+0x4b91>
 1087853:	mov    %esi,%edx
 1087855:	movzbl (%rcx,%rdx,1),%edi
 1087859:	cmp    $0x9,%edi
 108785c:	jg     1087830 <check_input_resolve_range+0x4b40>
 108785e:	cmp    $0x6,%edi
 1087861:	je     1087835 <check_input_resolve_range+0x4b45>
 1087863:	cmp    $0x8,%edi
 1087866:	je     1087835 <check_input_resolve_range+0x4b45>
 1087868:	jmp    1087873 <check_input_resolve_range+0x4b83>
 108786a:	cmp    $0x33,%edi
 108786d:	je     1088265 <check_input_resolve_range+0x5575>
 1087873:	inc    %esi
 1087875:	mov    %esi,%edx
 1087877:	cmp    %r14d,%edx
 108787a:	jb     1087853 <check_input_resolve_range+0x4b63>
 108787c:	jmp    1087881 <check_input_resolve_range+0x4b91>
 108787e:	mov    %r14d,%edx
 1087881:	vpxor  %xmm0,%xmm0,%xmm0
 1087885:	vmovdqu64 %zmm0,0x150(%rsp)
 1087890:	mov    %rbx,%rdi
 1087893:	xor    %ebx,%ebx
 1087895:	vmovdqu64 %zmm0,0x130(%rsp)
 10878a0:	movl   $0x0,0x200(%rsp)
 10878ab:	mov    %r13d,%esi
 10878ae:	mov    $0x1,%ecx
 10878b3:	xor    %r8d,%r8d
 10878b6:	lea    0x130(%rsp),%r9
 10878be:	push   $0x0
 10878c0:	lea    0x208(%rsp),%rax
 10878c8:	push   %rax
 10878c9:	vzeroupper
 10878cc:	call   10c24f0 <check_input_constant_read>
 10878d1:	add    $0x10,%rsp
 10878d5:	test   %al,%al
 10878d7:	je     10878e0 <check_input_resolve_range+0x4bf0>
 10878d9:	mov    0x200(%rsp),%ebx
 10878e0:	mov    0x8(%rsp),%rcx
 10878e5:	test   %ebx,%ebx
 10878e7:	mov    0xa8(%rcx),%rax
 10878ee:	mov    %ebx,(%rax,%r14,4)
 10878f2:	mov    %rcx,%rbx
 10878f5:	je     1087c28 <check_input_resolve_range+0x4f38>
 10878fb:	mov    0x138(%rbx),%rax
 1087902:	cmpb   $0x0,(%rax,%rbp,1)
 1087906:	je     1087c93 <check_input_resolve_range+0x4fa3>
 108790c:	mov    0x140(%rbx),%rax
 1087913:	cmpb   $0x0,(%rax,%rbp,1)
 1087917:	je     1087954 <check_input_resolve_range+0x4c64>
 1087919:	mov    0x150(%rbx),%rax
 1087920:	mov    $0xffffffff,%ecx
 1087925:	mov    (%rax,%rbp,4),%eax
 1087928:	cmp    %rcx,%rax
 108792b:	je     1087954 <check_input_resolve_range+0x4c64>
 108792d:	mov    (%rbx),%rcx
 1087930:	mov    0x3c0(%rbx),%edx
 1087936:	mov    0x2b8(%rcx),%rsi
 108793d:	cmp    %edx,(%rsi,%rax,4)
 1087940:	ja     1089059 <check_input_resolve_range+0x6369>
 1087946:	mov    %rbx,%rdi
 1087949:	mov    %r13d,%esi
 108794c:	vzeroupper
 108794f:	call   109a790 <check_input_initializer_prepare>
 1087954:	mov    0x138(%rbx),%rax
 108795b:	mov    0x48(%rsp),%r12
 1087960:	movzbl (%rax,%rbp,1),%eax
 1087964:	test   %al,%al
 1087966:	je     1087984 <check_input_resolve_range+0x4c94>
 1087968:	mov    0x290(%rbx),%rcx
 108796f:	cmpl   $0x0,(%rcx,%rbp,4)
 1087973:	jne    10879b0 <check_input_resolve_range+0x4cc0>
 1087975:	movzbl 0x50(%rsp),%r14d
 108797b:	test   %al,%al
 108797d:	jne    10879d3 <check_input_resolve_range+0x4ce3>
 108797f:	jmp    1087a1e <check_input_resolve_range+0x4d2e>
 1087984:	cmpb   $0x7,0x50(%rsp)
 1087989:	je     10879b0 <check_input_resolve_range+0x4cc0>
 108798b:	cmpl   $0x3f,0x3c(%rsp)
 1087990:	ja     1088208 <check_input_resolve_range+0x5518>
 1087996:	mov    0x3c(%rsp),%ecx
 108799a:	movabs $0x8160000000000000,%rdx
 10879a4:	bt     %rcx,%rdx
 10879a8:	jae    1088208 <check_input_resolve_range+0x5518>
 10879ae:	xchg   %ax,%ax
 10879b0:	mov    %rbx,%rdi
 10879b3:	mov    %r13d,%esi
 10879b6:	vzeroupper
 10879b9:	call   1092ed0 <check_input_declaration>
 10879be:	mov    0x138(%rbx),%rax
 10879c5:	movzbl (%rax,%rbp,1),%eax
 10879c9:	movzbl 0x50(%rsp),%r14d
 10879cf:	test   %al,%al
 10879d1:	je     1087a1e <check_input_resolve_range+0x4d2e>
 10879d3:	vpbroadcastq -0xadb38d(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 10879dd:	vpbroadcastd -0xadbba6(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10879e6:	vpbroadcastq -0xadb390(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 10879f0:	vpbroadcastd -0xadbbba(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10879fa:	vpbroadcastq -0xadb3ac(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1087a04:	cmpb   $0x31,0x50(%rsp)
 1087a09:	je     1088291 <check_input_resolve_range+0x55a1>
 1087a0f:	cmp    $0x1a,%r14d
 1087a13:	je     1087f25 <check_input_resolve_range+0x5235>
 1087a19:	jmp    10882f0 <check_input_resolve_range+0x5600>
 1087a1e:	vpbroadcastq -0xadb3d8(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1087a28:	vpbroadcastd -0xadbbf1(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1087a31:	vpbroadcastq -0xadb3db(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1087a3b:	vpbroadcastd -0xadbc05(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1087a45:	vpbroadcastq -0xadb3f7(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1087a4f:	cmpb   $0x34,0x50(%rsp)
 1087a54:	ja     10882f0 <check_input_resolve_range+0x5600>
 1087a5a:	movabs $0x1b000000000000,%rax
 1087a64:	bt     %r14,%rax
 1087a68:	jae    1087f1b <check_input_resolve_range+0x522b>
 1087a6e:	mov    0x60(%r12),%rax
 1087a73:	mov    0x50(%rbx),%ecx
 1087a76:	mov    0x398(%rbx),%rdx
 1087a7d:	mov    0x3b0(%rbx),%esi
 1087a83:	mov    (%rax,%rbp,4),%eax
 1087a86:	mov    %ecx,(%rdx,%rsi,4)
 1087a89:	mov    0x3a8(%rbx),%rcx
 1087a90:	mov    0x3b0(%rbx),%edx
 1087a96:	mov    %r13d,(%rcx,%rdx,4)
 1087a9a:	mov    0x30(%r12),%ecx
 1087a9f:	cmp    %ecx,%eax
 1087aa1:	jae    1087aad <check_input_resolve_range+0x4dbd>
 1087aa3:	mov    0x368(%rbx),%rcx
 1087aaa:	mov    (%rcx,%rax,4),%ecx
 1087aad:	mov    0x3a0(%rbx),%rax
 1087ab4:	mov    0x3b0(%rbx),%edx
 1087aba:	cmpb   $0x31,0x50(%rsp)
 1087abf:	mov    %ecx,(%rax,%rdx,4)
 1087ac2:	mov    0x3b0(%rbx),%eax
 1087ac8:	lea    0x1(%rax),%ecx
 1087acb:	mov    %ecx,0x3b0(%rbx)
 1087ad1:	je     1088291 <check_input_resolve_range+0x55a1>
 1087ad7:	cmp    $0x34,%r14d
 1087adb:	jne    10882f0 <check_input_resolve_range+0x5600>
 1087ae1:	mov    0xa8(%rbx),%rdx
 1087ae8:	mov    (%rbx),%rcx
 1087aeb:	mov    (%rdx,%rbp,4),%edx
 1087aee:	mov    %edx,0x3b4(%rbx)
 1087af4:	mov    0x3a0(%rbx),%rdx
 1087afb:	mov    (%rdx,%rax,4),%eax
 1087afe:	mov    %eax,0x3b8(%rbx)
 1087b04:	mov    %r13d,0x3bc(%rbx)
 1087b0b:	mov    0x2d8(%rcx),%rax
 1087b12:	cmpl   $0xffffffff,(%rax,%rbp,4)
 1087b16:	je     1088047 <check_input_resolve_range+0x5357>
 1087b1c:	mov    0x308(%rbx),%rax
 1087b23:	mov    (%rax,%rbp,4),%edx
 1087b26:	jmp    1087b4b <check_input_resolve_range+0x4e5b>
 1087b28:	nopl   0x0(%rax,%rax,1)
 1087b30:	movb   $0x0,0x98(%rbx)
 1087b37:	mov    (%rbx),%rax
 1087b3a:	movb   $0x1,0x3c5(%rax)
 1087b41:	mov    0x310(%rbx),%rax
 1087b48:	mov    (%rax,%rcx,4),%edx
 1087b4b:	cmp    $0xffffffff,%edx
 1087b4e:	je     1088047 <check_input_resolve_range+0x5357>
 1087b54:	mov    0x40(%rbx),%eax
 1087b57:	mov    $0x1,%sil
 1087b5a:	cmp    0x9c(%rbx),%eax
 1087b60:	je     1087b71 <check_input_resolve_range+0x4e81>
 1087b62:	mov    0x68(%rbx),%rcx
 1087b66:	lea    -0x1(%rax),%esi
 1087b69:	cmp    (%rcx,%rsi,4),%r13d
 1087b6d:	setae  %sil
 1087b71:	cmpb   $0x1,0x98(%rbx)
 1087b78:	mov    %edx,%ecx
 1087b7a:	jne    1087b30 <check_input_resolve_range+0x4e40>
 1087b7c:	mov    0x18(%r12),%rdi
 1087b81:	cmp    0x3c(%rbx),%eax
 1087b84:	mov    (%rdi,%rcx,4),%r8d
 1087b88:	setb   %dil
 1087b8c:	test   %r8d,%r8d
 1087b8f:	je     1087b30 <check_input_resolve_range+0x4e40>
 1087b91:	and    %sil,%dil
 1087b94:	je     1087b30 <check_input_resolve_range+0x4e40>
 1087b96:	mov    0x38(%rbx),%esi
 1087b99:	mov    0x3b0(%rbx),%r9d
 1087ba0:	cmp    %esi,%r8d
 1087ba3:	setb   0x98(%rbx)
 1087baa:	jae    1087b37 <check_input_resolve_range+0x4e47>
 1087bac:	lea    0x1(%rax),%edi
 1087baf:	add    %r8d,%esi
 1087bb2:	mov    %edi,0x40(%rbx)
 1087bb5:	mov    0x58(%rbx),%r8
 1087bb9:	mov    %esi,(%r8,%rax,4)
 1087bbd:	mov    0x60(%rbx),%r8
 1087bc1:	mov    %edx,(%r8,%rax,4)
 1087bc5:	mov    0x68(%rbx),%rdx
 1087bc9:	mov    %r13d,(%rdx,%rax,4)
 1087bcd:	mov    0x70(%rbx),%rdx
 1087bd1:	movl   $0xffffffff,(%rdx,%rax,4)
 1087bd8:	mov    0x80(%rbx),%rdx
 1087bdf:	mov    %r9d,(%rdx,%rax,4)
 1087be3:	mov    0x88(%rbx),%rdx
 1087bea:	movb   $0x0,(%rdx,%rax,1)
 1087bee:	mov    0x90(%rbx),%rdx
 1087bf5:	movb   $0x4,(%rdx,%rax,1)
 1087bf9:	mov    0x30(%rbx),%rdx
 1087bfd:	mov    0x78(%rbx),%r8
 1087c01:	mov    (%rdx,%rsi,4),%edx
 1087c04:	mov    %edx,(%r8,%rax,4)
 1087c08:	mov    0x50(%rbx),%r8d
 1087c0c:	mov    0x48(%rbx),%rdx
 1087c10:	lea    0x1(%r8),%r9d
 1087c14:	mov    %r9d,0x50(%rbx)
 1087c18:	mov    %eax,(%rdx,%r8,4)
 1087c1c:	mov    0x30(%rbx),%rax
 1087c20:	mov    %edi,(%rax,%rsi,4)
 1087c23:	jmp    1087b41 <check_input_resolve_range+0x4e51>
 1087c28:	mov    (%rbx),%rax
 1087c2b:	mov    0x230(%rax),%ecx
 1087c31:	cmp    0x234(%rax),%ecx
 1087c37:	jae    1087c7b <check_input_resolve_range+0x4f8b>
 1087c39:	movzbl 0x3c5(%rax),%edx
 1087c40:	mov    0x228(%rax),%rsi
 1087c47:	lea    0x1(%rcx),%edi
 1087c4a:	mov    %edi,0x230(%rax)
 1087c50:	lea    (%rcx,%rcx,2),%rax
 1087c54:	lea    0x1(%rdx,%rdx,2),%edx
 1087c58:	mov    %r13d,(%rsi,%rax,4)
 1087c5c:	mov    %edx,0x4(%rsi,%rax,4)
 1087c60:	movl   $0x0,0x8(%rsi,%rax,4)
 1087c68:	mov    0x138(%rbx),%rax
 1087c6f:	cmpb   $0x0,(%rax,%rbp,1)
 1087c73:	jne    108790c <check_input_resolve_range+0x4c1c>
 1087c79:	jmp    1087c93 <check_input_resolve_range+0x4fa3>
 1087c7b:	movb   $0x1,0x3c5(%rax)
 1087c82:	mov    0x138(%rbx),%rax
 1087c89:	cmpb   $0x0,(%rax,%rbp,1)
 1087c8d:	jne    108790c <check_input_resolve_range+0x4c1c>
 1087c93:	mov    0x48(%rsp),%rdx
 1087c98:	mov    0x30(%rdx),%eax
 1087c9b:	cmp    %eax,%r13d
 1087c9e:	jae    1087cf0 <check_input_resolve_range+0x5000>
 1087ca0:	mov    0x10(%rdx),%rcx
 1087ca4:	mov    0x18(%rdx),%rdx
 1087ca8:	movzbl (%rcx,%rbp,1),%esi
 1087cac:	mov    (%rdx,%rbp,4),%edx
 1087caf:	vmovd  %esi,%xmm0
 1087cb3:	cmp    $0x6,%esi
 1087cb6:	vpinsrd $0x1,%edx,%xmm0,%xmm0
 1087cbc:	sete   %cl
 1087cbf:	cmp    $0x6b,%edx
 1087cc2:	vpshufd $0x50,%xmm0,%xmm0
 1087cc7:	vpand  -0xaf87df(%rip),%xmm0,%xmm0        # 58f4f0 <abi_test_hex.digits+0xb60>
 1087ccf:	sete   %sil
 1087cd3:	vpcmpeqd -0xaf87dd(%rip),%xmm0,%k0        # 58f500 <abi_test_hex.digits+0xb70>
 1087cdd:	kortestb %k0,%k0
 1087ce1:	setne  %dl
 1087ce4:	or     %sil,%dl
 1087ce7:	test   %dl,%dl
 1087ce9:	jne    1087cfc <check_input_resolve_range+0x500c>
 1087ceb:	jmp    1087eed <check_input_resolve_range+0x51fd>
 1087cf0:	xor    %ecx,%ecx
 1087cf2:	xor    %edx,%edx
 1087cf4:	test   %dl,%dl
 1087cf6:	je     1087eed <check_input_resolve_range+0x51fd>
 1087cfc:	mov    0x8(%rbx),%r14
 1087d00:	movabs $0x7000000000000040,%r8
 1087d0a:	mov    %r13d,%r15d
 1087d0d:	mov    0x30(%r14),%edx
 1087d11:	jmp    1087d23 <check_input_resolve_range+0x5033>
 1087d13:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1087d20:	mov    %edx,%r15d
 1087d23:	cmp    %edx,%r15d
 1087d26:	jae    1087df0 <check_input_resolve_range+0x5100>
 1087d2c:	mov    0x10(%r14),%rax
 1087d30:	mov    0x18(%r14),%rsi
 1087d34:	mov    %r15d,%ecx
 1087d37:	movzbl (%rax,%rcx,1),%edi
 1087d3b:	mov    (%rsi,%rcx,4),%ecx
 1087d3e:	vmovd  %edi,%xmm0
 1087d42:	cmp    $0x6,%edi
 1087d45:	vpinsrd $0x1,%ecx,%xmm0,%xmm0
 1087d4b:	sete   %al
 1087d4e:	cmp    $0x6b,%ecx
 1087d51:	vpshufd $0x50,%xmm0,%xmm0
 1087d56:	vpand  -0xaf886e(%rip),%xmm0,%xmm0        # 58f4f0 <abi_test_hex.digits+0xb60>
 1087d5e:	sete   %sil
 1087d62:	vpcmpeqd -0xaf886c(%rip),%xmm0,%k0        # 58f500 <abi_test_hex.digits+0xb70>
 1087d6c:	kortestb %k0,%k0
 1087d70:	setne  %cl
 1087d73:	or     %sil,%cl
 1087d76:	test   %cl,%cl
 1087d78:	jne    1087df8 <check_input_resolve_range+0x5108>
 1087d7a:	test   %al,%al
 1087d7c:	je     1087e21 <check_input_resolve_range+0x5131>
 1087d82:	lea    0x1(%r15),%eax
 1087d86:	cmp    %edx,%eax
 1087d88:	jae    1087e21 <check_input_resolve_range+0x5131>
 1087d8e:	mov    0x10(%r14),%rcx
 1087d92:	mov    %eax,%esi
 1087d94:	cmpb   $0x6,(%rcx,%rsi,1)
 1087d98:	jne    1087e21 <check_input_resolve_range+0x5131>
 1087d9e:	mov    %r15d,%esi
 1087da1:	movzbl (%rcx,%rsi,1),%esi
 1087da5:	cmp    $0x6,%rsi
 1087da9:	je     1087dae <check_input_resolve_range+0x50be>
 1087dab:	mov    %eax,%r15d
 1087dae:	mov    %r15d,%ecx
 1087db1:	mov    %eax,%r15d
 1087db4:	cmp    $0x3e,%rsi
 1087db8:	ja     1087d23 <check_input_resolve_range+0x5033>
 1087dbe:	bt     %rsi,%r8
 1087dc2:	mov    %eax,%r15d
 1087dc5:	jae    1087d23 <check_input_resolve_range+0x5033>
 1087dcb:	mov    %edx,%eax
 1087dcd:	cmp    %edx,%ecx
 1087dcf:	jae    1087dda <check_input_resolve_range+0x50ea>
 1087dd1:	mov    0x60(%r14),%rax
 1087dd5:	mov    %ecx,%esi
 1087dd7:	mov    (%rax,%rsi,4),%eax
 1087dda:	cmp    %edx,%eax
 1087ddc:	jb     1087e10 <check_input_resolve_range+0x5120>
 1087dde:	mov    %edx,%r15d
 1087de1:	cmp    %ecx,%eax
 1087de3:	ja     1087d23 <check_input_resolve_range+0x5033>
 1087de9:	jmp    1087d20 <check_input_resolve_range+0x5030>
 1087dee:	xchg   %ax,%ax
 1087df0:	xor    %eax,%eax
 1087df2:	xor    %ecx,%ecx
 1087df4:	test   %cl,%cl
 1087df6:	je     1087d7a <check_input_resolve_range+0x508a>
 1087df8:	mov    0x10(%r14),%rcx
 1087dfc:	lea    0x1(%r15),%eax
 1087e00:	mov    %r15d,%esi
 1087e03:	movzbl (%rcx,%rsi,1),%esi
 1087e07:	cmp    $0x6,%rsi
 1087e0b:	jne    1087dab <check_input_resolve_range+0x50bb>
 1087e0d:	jmp    1087dae <check_input_resolve_range+0x50be>
 1087e0f:	nop
 1087e10:	lea    0x1(%rax),%r15d
 1087e14:	cmp    %ecx,%eax
 1087e16:	ja     1087d23 <check_input_resolve_range+0x5033>
 1087e1c:	jmp    1087d20 <check_input_resolve_range+0x5030>
 1087e21:	cmp    %edx,%r15d
 1087e24:	jae    108790c <check_input_resolve_range+0x4c1c>
 1087e2a:	mov    0x10(%r14),%rax
 1087e2e:	mov    %r15d,%r12d
 1087e31:	cmpb   $0x30,(%rax,%r12,1)
 1087e36:	jne    108790c <check_input_resolve_range+0x4c1c>
 1087e3c:	lea    0x200(%rsp),%rsi
 1087e44:	lea    0x130(%rsp),%rcx
 1087e4c:	mov    %rbx,%rdi
 1087e4f:	mov    %r13d,0x200(%rsp)
 1087e57:	movq   $0x0,0x130(%rsp)
 1087e63:	vzeroupper
 1087e66:	call   10ea940 <check_input_read_attributes>
 1087e6b:	test   %al,%al
 1087e6d:	je     10881bf <check_input_resolve_range+0x54cf>
 1087e73:	cmp    %r15d,0x200(%rsp)
 1087e7b:	mov    0x130(%rsp),%rax
 1087e83:	sete   %cl
 1087e86:	test   %rax,%rax
 1087e89:	setne  %dl
 1087e8c:	and    %cl,%dl
 1087e8e:	cmp    $0x1,%dl
 1087e91:	jne    10881bf <check_input_resolve_range+0x54cf>
 1087e97:	mov    0x3bc(%rbx),%ecx
 1087e9d:	cmp    0x30(%r14),%ecx
 1087ea1:	jae    10881bf <check_input_resolve_range+0x54cf>
 1087ea7:	mov    0x8(%rax),%ecx
 1087eaa:	test   %rcx,%rcx
 1087ead:	je     1087ed3 <check_input_resolve_range+0x51e3>
 1087eaf:	mov    (%rax),%rdx
 1087eb2:	mov    %rcx,%rsi
 1087eb5:	shl    $0x4,%rsi
 1087eb9:	xor    %edi,%edi
 1087ebb:	lea    (%rsi,%rsi,4),%rsi
 1087ebf:	cmpl   $0x45,0x1c(%rdx,%rdi,1)
 1087ec4:	jne    10881bf <check_input_resolve_range+0x54cf>
 1087eca:	add    $0x50,%rdi
 1087ece:	cmp    %rdi,%rsi
 1087ed1:	jne    1087ebf <check_input_resolve_range+0x51cf>
 1087ed3:	mov    (%rbx),%rdx
 1087ed6:	test   %rcx,%rcx
 1087ed9:	cmove  %rcx,%rax
 1087edd:	mov    0x288(%rdx),%rcx
 1087ee4:	mov    %rax,(%rcx,%r12,8)
 1087ee8:	jmp    108790c <check_input_resolve_range+0x4c1c>
 1087eed:	test   %cl,%cl
 1087eef:	je     108790c <check_input_resolve_range+0x4c1c>
 1087ef5:	lea    0x1(%r13),%ecx
 1087ef9:	cmp    %eax,%ecx
 1087efb:	jae    108790c <check_input_resolve_range+0x4c1c>
 1087f01:	mov    0x48(%rsp),%rax
 1087f06:	mov    %ecx,%ecx
 1087f08:	mov    0x10(%rax),%rax
 1087f0c:	cmpb   $0x6,(%rax,%rcx,1)
 1087f10:	jne    108790c <check_input_resolve_range+0x4c1c>
 1087f16:	jmp    1087cfc <check_input_resolve_range+0x500c>
 1087f1b:	cmp    $0x1a,%r14
 1087f1f:	jne    10882f0 <check_input_resolve_range+0x5600>
 1087f25:	mov    0x3c(%rsp),%eax
 1087f29:	cmp    $0x52,%eax
 1087f2c:	jne    1087f43 <check_input_resolve_range+0x5253>
 1087f2e:	mov    0x3b4(%rbx),%eax
 1087f34:	mov    0xf8(%rbx),%rcx
 1087f3b:	mov    %eax,(%rcx,%rbp,4)
 1087f3e:	jmp    10882f0 <check_input_resolve_range+0x5600>
 1087f43:	and    $0xfe,%al
 1087f45:	cmp    $0x50,%al
 1087f47:	jne    10882f0 <check_input_resolve_range+0x5600>
 1087f4d:	mov    0x60(%r12),%rax
 1087f52:	mov    0x30(%r12),%ecx
 1087f57:	mov    (%rax,%rbp,4),%r9d
 1087f5b:	cmp    %ecx,%r9d
 1087f5e:	jae    1087ffe <check_input_resolve_range+0x530e>
 1087f64:	mov    0x50(%r12),%rdx
 1087f69:	mov    0x370(%rbx),%rsi
 1087f70:	mov    %r9d,%edi
 1087f73:	movzbl (%rdx,%rdi,1),%r10d
 1087f78:	mov    (%rsi,%rdi,4),%r8d
 1087f7c:	cmp    %r9d,%r13d
 1087f7f:	ja     1087f87 <check_input_resolve_range+0x5297>
 1087f81:	cmp    $0x20,%r10b
 1087f85:	jne    1087fe0 <check_input_resolve_range+0x52f0>
 1087f87:	movzbl %r10b,%r9d
 1087f8b:	cmp    $0x49,%r9d
 1087f8f:	je     1087fa6 <check_input_resolve_range+0x52b6>
 1087f91:	cmp    $0x20,%r9d
 1087f95:	je     108827f <check_input_resolve_range+0x558f>
 1087f9b:	cmp    $0x4a,%r9d
 1087f9f:	jne    1087fe0 <check_input_resolve_range+0x52f0>
 1087fa1:	jmp    108827f <check_input_resolve_range+0x558f>
 1087fa6:	cmp    %ecx,%r8d
 1087fa9:	jae    1087fe0 <check_input_resolve_range+0x52f0>
 1087fab:	mov    0x10(%r12),%r9
 1087fb0:	movzbl (%r9,%r8,1),%r8d
 1087fb5:	cmp    $0x4c,%r8b
 1087fb9:	je     108827f <check_input_resolve_range+0x558f>
 1087fbf:	mov    0x3c(%rsp),%r9d
 1087fc4:	xor    $0x51,%r9b
 1087fc8:	xor    $0x49,%r8b
 1087fcc:	or     %r9b,%r8b
 1087fcf:	sete   %r8b
 1087fd3:	jmp    1087fe3 <check_input_resolve_range+0x52f3>
 1087fd5:	data16 cs nopw 0x0(%rax,%rax,1)
 1087fe0:	xor    %r8d,%r8d
 1087fe3:	test   %r8b,%r8b
 1087fe6:	jne    1087ff5 <check_input_resolve_range+0x5305>
 1087fe8:	mov    (%rax,%rdi,4),%r9d
 1087fec:	cmp    %ecx,%r9d
 1087fef:	jb     1087f70 <check_input_resolve_range+0x5280>
 1087ff5:	test   %r8b,%r8b
 1087ff8:	jne    108827f <check_input_resolve_range+0x558f>
 1087ffe:	mov    (%rbx),%rax
 1088001:	mov    0x230(%rax),%ecx
 1088007:	cmp    0x234(%rax),%ecx
 108800d:	jae    1088278 <check_input_resolve_range+0x5588>
 1088013:	movzbl 0x3c5(%rax),%edx
 108801a:	mov    0x228(%rax),%rsi
 1088021:	lea    0x1(%rcx),%edi
 1088024:	mov    %edi,0x230(%rax)
 108802a:	lea    (%rcx,%rcx,2),%rax
 108802e:	lea    0x1(%rdx,%rdx,2),%edx
 1088032:	mov    %r13d,(%rsi,%rax,4)
 1088036:	mov    %edx,0x4(%rsi,%rax,4)
 108803a:	movl   $0x0,0x8(%rsi,%rax,4)
 1088042:	jmp    108827f <check_input_resolve_range+0x558f>
 1088047:	mov    0x2e0(%rbx),%rax
 108804e:	mov    (%rax,%rbp,4),%esi
 1088051:	cmp    $0xffffffff,%esi
 1088054:	jne    108809a <check_input_resolve_range+0x53aa>
 1088056:	jmp    10879d3 <check_input_resolve_range+0x4ce3>
 108805b:	nopl   0x0(%rax,%rax,1)
 1088060:	movb   $0x1,0x3c5(%rax)
 1088067:	mov    0x8(%rsp),%r15
 108806c:	mov    (%r15),%rax
 108806f:	mov    %r15,%rdi
 1088072:	mov    %r13d,%edx
 1088075:	mov    0x2e0(%rax),%rax
 108807c:	mov    %r13d,(%rax,%rbx,4)
 1088080:	vzeroupper
 1088083:	call   1090a70 <check_input_bind>
 1088088:	mov    0x2e8(%r15),%rax
 108808f:	mov    (%rax,%rbx,4),%esi
 1088092:	mov    %r15,%rbx
 1088095:	cmp    $0xffffffff,%esi
 1088098:	je     10880f2 <check_input_resolve_range+0x5402>
 108809a:	mov    0x300(%rbx),%rax
 10880a1:	mov    %rbx,%r15
 10880a4:	mov    %esi,%ebx
 10880a6:	testb  $0x2,(%rax,%rbx,1)
 10880aa:	je     108806c <check_input_resolve_range+0x537c>
 10880ac:	mov    (%r15),%rax
 10880af:	mov    0x230(%rax),%ecx
 10880b5:	cmp    0x234(%rax),%ecx
 10880bb:	jae    1088060 <check_input_resolve_range+0x5370>
 10880bd:	movzbl 0x3c5(%rax),%edx
 10880c4:	mov    0x228(%rax),%rdi
 10880cb:	lea    0x1(%rcx),%r8d
 10880cf:	mov    %r8d,0x230(%rax)
 10880d6:	lea    (%rcx,%rcx,2),%rax
 10880da:	lea    0x1(%rdx,%rdx,2),%edx
 10880de:	mov    %esi,(%rdi,%rax,4)
 10880e1:	mov    %edx,0x4(%rdi,%rax,4)
 10880e5:	movl   $0x0,0x8(%rdi,%rax,4)
 10880ed:	jmp    1088067 <check_input_resolve_range+0x5377>
 10880f2:	mov    0x2e0(%rbx),%rax
 10880f9:	mov    (%rax,%rbp,4),%edx
 10880fc:	cmp    $0xffffffff,%edx
 10880ff:	je     10879d3 <check_input_resolve_range+0x4ce3>
 1088105:	mov    0x2e8(%rbx),%rsi
 108810c:	mov    $0xffffffff,%ecx
 1088111:	xor    %eax,%eax
 1088113:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088120:	cmp    %ecx,%edx
 1088122:	cmovb  %edx,%ecx
 1088125:	cmp    %eax,%edx
 1088127:	cmova  %edx,%eax
 108812a:	mov    %edx,%edx
 108812c:	mov    (%rsi,%rdx,4),%edx
 108812f:	cmp    $0xffffffff,%edx
 1088132:	jne    1088120 <check_input_resolve_range+0x5430>
 1088134:	mov    (%rbx),%rdi
 1088137:	cmpl   $0x0,0x338(%rdi)
 108813e:	je     10879d3 <check_input_resolve_range+0x4ce3>
 1088144:	xor    %edx,%edx
 1088146:	xor    %esi,%esi
 1088148:	jmp    1088167 <check_input_resolve_range+0x5477>
 108814a:	nopw   0x0(%rax,%rax,1)
 1088150:	mov    0x338(%rdi),%r8d
 1088157:	inc    %rsi
 108815a:	add    $0x24,%rdx
 108815e:	cmp    %r8,%rsi
 1088161:	jae    10879d3 <check_input_resolve_range+0x4ce3>
 1088167:	mov    0x330(%rdi),%r8
 108816e:	mov    (%r8,%rdx,1),%r9d
 1088172:	cmp    %ecx,%r9d
 1088175:	jb     1088150 <check_input_resolve_range+0x5460>
 1088177:	cmp    %eax,%r9d
 108817a:	ja     1088150 <check_input_resolve_range+0x5460>
 108817c:	mov    0x2e0(%rdi),%r10
 1088183:	cmp    %r13d,(%r10,%r9,4)
 1088187:	jne    1088150 <check_input_resolve_range+0x5460>
 1088189:	mov    %r13d,0x14(%r8,%rdx,1)
 108818e:	mov    %r13d,0x18(%r8,%rdx,1)
 1088193:	mov    0x3b8(%rbx),%edi
 1088199:	mov    %edi,0x1c(%r8,%rdx,1)
 108819e:	mov    0x18(%rbx),%rdi
 10881a2:	mov    0x4(%r8,%rdx,1),%r9d
 10881a7:	mov    0x30(%rdi),%rdi
 10881ab:	and    $0xfffffff8,%r9d
 10881af:	cmpq   $0x0,(%rdi,%r9,1)
 10881b4:	setne  0x20(%r8,%rdx,1)
 10881ba:	mov    (%rbx),%rdi
 10881bd:	jmp    1088150 <check_input_resolve_range+0x5460>
 10881bf:	mov    (%rbx),%rax
 10881c2:	mov    0x230(%rax),%ecx
 10881c8:	cmp    0x234(%rax),%ecx
 10881ce:	jae    108826c <check_input_resolve_range+0x557c>
 10881d4:	movzbl 0x3c5(%rax),%edx
 10881db:	mov    0x228(%rax),%rsi
 10881e2:	lea    0x1(%rcx),%edi
 10881e5:	mov    %edi,0x230(%rax)
 10881eb:	lea    (%rcx,%rcx,2),%rax
 10881ef:	lea    0x1(%rdx,%rdx,2),%edx
 10881f3:	mov    %r13d,(%rsi,%rax,4)
 10881f7:	mov    %edx,0x4(%rsi,%rax,4)
 10881fb:	movl   $0x0,0x8(%rsi,%rax,4)
 1088203:	jmp    108790c <check_input_resolve_range+0x4c1c>
 1088208:	mov    0x30(%r12),%ecx
 108820d:	cmp    %ecx,%r13d
 1088210:	jae    1088bfc <check_input_resolve_range+0x5f0c>
 1088216:	mov    0x10(%r12),%rdx
 108821b:	mov    0x18(%r12),%rsi
 1088220:	movzbl (%rdx,%rbp,1),%edi
 1088224:	mov    (%rsi,%rbp,4),%esi
 1088227:	vmovd  %edi,%xmm0
 108822b:	cmp    $0x6,%edi
 108822e:	vpinsrd $0x1,%esi,%xmm0,%xmm0
 1088234:	sete   %dl
 1088237:	cmp    $0x6b,%esi
 108823a:	vpshufd $0x50,%xmm0,%xmm0
 108823f:	vpand  -0xaf8d57(%rip),%xmm0,%xmm0        # 58f4f0 <abi_test_hex.digits+0xb60>
 1088247:	sete   %dil
 108824b:	vpcmpeqd -0xaf8d55(%rip),%xmm0,%k0        # 58f500 <abi_test_hex.digits+0xb70>
 1088255:	kortestb %k0,%k0
 1088259:	setne  %sil
 108825d:	or     %dil,%sil
 1088260:	jmp    1088c00 <check_input_resolve_range+0x5f10>
 1088265:	mov    %esi,%edx
 1088267:	jmp    1087881 <check_input_resolve_range+0x4b91>
 108826c:	movb   $0x1,0x3c5(%rax)
 1088273:	jmp    108790c <check_input_resolve_range+0x4c1c>
 1088278:	movb   $0x1,0x3c5(%rax)
 108827f:	mov    0x138(%rbx),%rax
 1088286:	cmpb   $0x31,0x50(%rsp)
 108828b:	movb   $0x1,(%rax,%rbp,1)
 108828f:	jne    10882f0 <check_input_resolve_range+0x5600>
 1088291:	mov    0x60(%r12),%rax
 1088296:	mov    0x370(%rbx),%rcx
 108829d:	mov    (%rax,%rbp,4),%eax
 10882a0:	mov    (%rcx,%rax,4),%edx
 10882a3:	cmp    $0xffffffff,%edx
 10882a6:	je     10882f0 <check_input_resolve_range+0x5600>
 10882a8:	xor    %ecx,%ecx
 10882aa:	jmp    10882c1 <check_input_resolve_range+0x55d1>
 10882ac:	nopl   0x0(%rax)
 10882b0:	mov    %edx,%edx
 10882b2:	mov    0x378(%rbx),%rsi
 10882b9:	mov    (%rsi,%rdx,4),%edx
 10882bc:	cmp    $0xffffffff,%edx
 10882bf:	je     10882f0 <check_input_resolve_range+0x5600>
 10882c1:	cmp    %r13d,%edx
 10882c4:	jbe    10882b0 <check_input_resolve_range+0x55c0>
 10882c6:	cmp    %eax,%edx
 10882c8:	jae    10882b0 <check_input_resolve_range+0x55c0>
 10882ca:	mov    0x10(%r12),%rsi
 10882cf:	mov    %edx,%edx
 10882d1:	cmpb   $0x30,(%rsi,%rdx,1)
 10882d5:	jne    10882b2 <check_input_resolve_range+0x55c2>
 10882d7:	mov    0x270(%rbx),%rsi
 10882de:	inc    %ecx
 10882e0:	cmp    $0x2,%ecx
 10882e3:	sete   (%rsi,%rdx,1)
 10882e7:	jmp    10882b2 <check_input_resolve_range+0x55c2>
 10882e9:	nopl   0x0(%rax)
 10882f0:	mov    0x138(%rbx),%rax
 10882f7:	cmpb   $0x0,(%rax,%rbp,1)
 10882fb:	je     1088305 <check_input_resolve_range+0x5615>
 10882fd:	xor    %r12d,%r12d
 1088300:	jmp    10885b0 <check_input_resolve_range+0x58c0>
 1088305:	mov    0x50(%rsp),%rax
 108830a:	mov    $0x1,%r12b
 108830d:	add    $0xffffffdb,%eax
 1088310:	cmp    $0x2,%al
 1088312:	ja     10885b0 <check_input_resolve_range+0x58c0>
 1088318:	mov    0x48(%rsp),%rcx
 108831d:	mov    0x60(%rcx),%rax
 1088321:	mov    (%rax,%rbp,4),%r14d
 1088325:	lea    0x1(%r13),%ebp
 1088329:	cmp    %r14d,%ebp
 108832c:	jae    10885b0 <check_input_resolve_range+0x58c0>
 1088332:	cmp    0x30(%rcx),%r14d
 1088336:	jae    10885b0 <check_input_resolve_range+0x58c0>
 108833c:	mov    0x50(%rcx),%rbx
 1088340:	mov    %ebp,%r15d
 1088343:	cmpb   $0x7,(%rbx,%r15,1)
 1088348:	je     1088376 <check_input_resolve_range+0x5686>
 108834a:	mov    0x48(%rsp),%rax
 108834f:	mov    0x10(%rax),%rax
 1088353:	movzbl (%rax,%r15,1),%eax
 1088358:	cmp    $0x3f,%rax
 108835c:	ja     1088d1c <check_input_resolve_range+0x602c>
 1088362:	movabs $0x8160000000000000,%rcx
 108836c:	bt     %rax,%rcx
 1088370:	jae    1088d1c <check_input_resolve_range+0x602c>
 1088376:	mov    0x48(%rsp),%r12
 108837b:	mov    %ebp,0x130(%rsp)
 1088382:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088390:	cmpb   $0x7,(%rbx,%r15,1)
 1088395:	jne    10883a1 <check_input_resolve_range+0x56b1>
 1088397:	inc    %r15
 108839a:	cmp    %r15d,%r14d
 108839d:	jne    1088390 <check_input_resolve_range+0x56a0>
 108839f:	jmp    10883df <check_input_resolve_range+0x56ef>
 10883a1:	mov    0x10(%r12),%rbx
 10883a6:	movzbl (%rbx,%r15,1),%eax
 10883ab:	add    $0xcb,%al
 10883ad:	cmp    $0x1,%al
 10883af:	ja     10883df <check_input_resolve_range+0x56ef>
 10883b1:	mov    %r12,%rdi
 10883b4:	mov    %r15d,%esi
 10883b7:	mov    %r14d,%edx
 10883ba:	vzeroupper
 10883bd:	call   1095d90 <check_input_tag_body>
 10883c2:	cmp    %r14d,%eax
 10883c5:	jae    10883df <check_input_resolve_range+0x56ef>
 10883c7:	mov    %eax,%eax
 10883c9:	cmpb   $0xa,(%rbx,%rax,1)
 10883cd:	jne    10883df <check_input_resolve_range+0x56ef>
 10883cf:	mov    0x8(%rsp),%rdi
 10883d4:	mov    %r15d,%esi
 10883d7:	mov    %r14d,%edx
 10883da:	call   1096080 <check_input_tag_definition>
 10883df:	mov    0x8(%rsp),%rbx
 10883e4:	lea    0x130(%rsp),%r15
 10883ec:	lea    0x12b(%rsp),%rcx
 10883f4:	lea    0x200(%rsp),%r8
 10883fc:	lea    0x12a(%rsp),%r9
 1088404:	mov    %r14d,%edx
 1088407:	mov    %r15,%rsi
 108840a:	mov    %rbx,%rdi
 108840d:	vzeroupper
 1088410:	call   109ab00 <check_input_specifiers>
 1088415:	lea    0x12c(%rsp),%r8
 108841d:	lea    0x124(%rsp),%r9
 1088425:	mov    %rbx,%rdi
 1088428:	mov    %eax,%esi
 108842a:	mov    %r15,%rdx
 108842d:	mov    %r14d,%ecx
 1088430:	call   109be70 <check_input_declarator>
 1088435:	test   %eax,%eax
 1088437:	je     108846b <check_input_resolve_range+0x577b>
 1088439:	cmp    %r14d,0x130(%rsp)
 1088441:	jne    108846b <check_input_resolve_range+0x577b>
 1088443:	cmpl   $0xffffffff,0x12c(%rsp)
 108844b:	jne    108846b <check_input_resolve_range+0x577b>
 108844d:	cmpb   $0x0,0x12b(%rsp)
 1088455:	jne    108846b <check_input_resolve_range+0x577b>
 1088457:	cmpl   $0x0,0x200(%rsp)
 108845f:	jne    108846b <check_input_resolve_range+0x577b>
 1088461:	cmpb   $0x0,0x12a(%rsp)
 1088469:	je     10884b6 <check_input_resolve_range+0x57c6>
 108846b:	mov    (%rbx),%rcx
 108846e:	mov    0x230(%rcx),%edx
 1088474:	cmp    0x234(%rcx),%edx
 108847a:	jae    10884af <check_input_resolve_range+0x57bf>
 108847c:	movzbl 0x3c5(%rcx),%esi
 1088483:	mov    0x228(%rcx),%rdi
 108848a:	lea    0x1(%rdx),%r8d
 108848e:	mov    %r8d,0x230(%rcx)
 1088495:	lea    (%rdx,%rdx,2),%rcx
 1088499:	lea    0x1(%rsi,%rsi,2),%esi
 108849d:	mov    %r13d,(%rdi,%rcx,4)
 10884a1:	mov    %esi,0x4(%rdi,%rcx,4)
 10884a5:	movl   $0x0,0x8(%rdi,%rcx,4)
 10884ad:	jmp    10884b6 <check_input_resolve_range+0x57c6>
 10884af:	movb   $0x1,0x3c5(%rcx)
 10884b6:	vpbroadcastq -0xadbe70(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 10884c0:	vpbroadcastd -0xadc689(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10884c9:	vpbroadcastq -0xadbe73(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 10884d3:	vpbroadcastd -0xadc69d(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10884dd:	vpbroadcastq -0xadbe8f(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10884e7:	mov    0xa8(%rbx),%rcx
 10884ee:	cmpb   $0x26,0x50(%rsp)
 10884f3:	mov    %eax,(%rcx,%r14,4)
 10884f7:	jne    1088592 <check_input_resolve_range+0x58a2>
 10884fd:	test   %eax,%eax
 10884ff:	je     1088592 <check_input_resolve_range+0x58a2>
 1088505:	mov    0x30(%r12),%esi
 108850a:	lea    0x1(%r14),%ecx
 108850e:	cmp    %esi,%ecx
 1088510:	jae    1088549 <check_input_resolve_range+0x5859>
 1088512:	mov    0x60(%r12),%rdx
 1088517:	mov    %ecx,%edi
 1088519:	mov    (%rdx,%rdi,4),%edx
 108851c:	cmp    %esi,%edx
 108851e:	jae    1088549 <check_input_resolve_range+0x5859>
 1088520:	mov    0x50(%r12),%rsi
 1088525:	cmpb   $0x38,(%rsi,%rdi,1)
 1088529:	jne    1088549 <check_input_resolve_range+0x5859>
 108852b:	mov    0x18(%rbx),%rsi
 108852f:	mov    %eax,%edi
 1088531:	shr    $0x3,%edi
 1088534:	mov    (%rsi),%rsi
 1088537:	movzbl (%rsi,%rdi,1),%esi
 108853b:	cmp    $0x1,%esi
 108853e:	je     1088549 <check_input_resolve_range+0x5859>
 1088540:	cmp    $0xb,%esi
 1088543:	jne    1088e69 <check_input_resolve_range+0x6179>
 1088549:	mov    (%rbx),%rax
 108854c:	mov    0x230(%rax),%ecx
 1088552:	cmp    0x234(%rax),%ecx
 1088558:	jae    108858b <check_input_resolve_range+0x589b>
 108855a:	movzbl 0x3c5(%rax),%edx
 1088561:	mov    0x228(%rax),%rsi
 1088568:	lea    0x1(%rcx),%edi
 108856b:	mov    %edi,0x230(%rax)
 1088571:	lea    (%rcx,%rcx,2),%rax
 1088575:	lea    0x1(%rdx,%rdx,2),%edx
 1088579:	mov    %r13d,(%rsi,%rax,4)
 108857d:	mov    %edx,0x4(%rsi,%rax,4)
 1088581:	movl   $0x0,0x8(%rsi,%rax,4)
 1088589:	jmp    1088592 <check_input_resolve_range+0x58a2>
 108858b:	movb   $0x1,0x3c5(%rax)
 1088592:	mov    0x138(%rbx),%rax
 1088599:	mov    0x28(%rsp),%rcx
 108859e:	cmpb   $0x0,(%rax,%rcx,1)
 10885a2:	sete   %r12b
 10885a6:	cs nopw 0x0(%rax,%rax,1)
 10885b0:	cmpb   $0x6,0x50(%rsp)
 10885b5:	mov    0x8(%rsp),%rbx
 10885ba:	mov    0x28(%rsp),%rbp
 10885bf:	je     1082dc0 <check_input_resolve_range+0xd0>
 10885c5:	cmpb   $0x8,0x50(%rsp)
 10885ca:	je     1082dc0 <check_input_resolve_range+0xd0>
 10885d0:	cmpb   $0x3,0x50(%rsp)
 10885d5:	je     1082dc0 <check_input_resolve_range+0xd0>
 10885db:	test   %r12b,%r12b
 10885de:	je     1082dc0 <check_input_resolve_range+0xd0>
 10885e4:	cmpb   $0x2,0x3c(%rsp)
 10885e9:	jne    1082dc0 <check_input_resolve_range+0xd0>
 10885ef:	mov    0x48(%rsp),%rax
 10885f4:	mov    (%rbx),%rcx
 10885f7:	mov    0x18(%rax),%rax
 10885fb:	mov    (%rax,%rbp,4),%r15d
 10885ff:	mov    0x220(%rcx),%rax
 1088606:	test   %rax,%rax
 1088609:	je     108863c <check_input_resolve_range+0x594c>
 108860b:	xor    %ecx,%ecx
 108860d:	test   %r15d,%r15d
 1088610:	je     1088639 <check_input_resolve_range+0x5949>
 1088612:	cmpb   $0x0,0x98(%rbx)
 1088619:	je     1088639 <check_input_resolve_range+0x5949>
 108861b:	cmp    0x38(%rbx),%r15d
 108861f:	jae    1088639 <check_input_resolve_range+0x5949>
 1088621:	mov    0x30(%rbx),%rdx
 1088625:	mov    (%rdx,%r15,4),%edx
 1088629:	test   %edx,%edx
 108862b:	je     1088639 <check_input_resolve_range+0x5949>
 108862d:	mov    0x60(%rbx),%rcx
 1088631:	dec    %edx
 1088633:	mov    (%rcx,%rdx,4),%ecx
 1088636:	mov    (%rax,%rcx,4),%ecx
 1088639:	mov    %ecx,(%rax,%rbp,4)
 108863c:	mov    0x8(%rbx),%rax
 1088640:	mov    0x1d0(%rbx),%rcx
 1088647:	mov    0x18(%rax),%rax
 108864b:	mov    (%rax,%rbp,4),%r12d
 108864f:	movzwl (%rcx,%r12,2),%r13d
 1088654:	cmp    $0xffff,%r13w
 1088659:	je     108866b <check_input_resolve_range+0x597b>
 108865b:	cmpb   $0x2,0x50(%rsp)
 1088660:	je     1088755 <check_input_resolve_range+0x5a65>
 1088666:	jmp    108878a <check_input_resolve_range+0x5a9a>
 108866b:	mov    0x10(%rbx),%rax
 108866f:	mov    %rcx,0x60(%rsp)
 1088674:	mov    %r15,0x30(%rsp)
 1088679:	xor    %r13d,%r13d
 108867c:	mov    0x270(%rax),%rax
 1088683:	mov    0x40(%rax),%r14
 1088687:	test   %r14,%r14
 108868a:	je     108873f <check_input_resolve_range+0x5a4f>
 1088690:	mov    0x10(%rax),%rax
 1088694:	mov    0x4(%rax,%r12,8),%r15d
 1088699:	lea    -0x1(%r15),%ecx
 108869d:	cmp    $0x2e,%ecx
 10886a0:	ja     108873f <check_input_resolve_range+0x5a4f>
 10886a6:	mov    (%rax,%r12,8),%eax
 10886aa:	lea    0xbb8f4f(%rip),%rbx        # 1c41600 <cbuiltin_catalog+0x10>
 10886b1:	xor    %ebp,%ebp
 10886b3:	add    %rax,%r14
 10886b6:	cs nopw 0x0(%rax,%rax,1)
 10886c0:	xor    %r13d,%r13d
 10886c3:	cmp    (%rbx),%r15d
 10886c6:	jne    1088720 <check_input_resolve_range+0x5a30>
 10886c8:	mov    -0x8(%rbx),%rsi
 10886cc:	mov    %r14,%rdi
 10886cf:	mov    %r15,%rdx
 10886d2:	vzeroupper
 10886d5:	call   7883c0 <bcmp@plt>
 10886da:	vpbroadcastq -0xadc08c(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10886e4:	vpbroadcastd -0xadc8ae(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10886ee:	vpbroadcastq -0xadc098(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 10886f8:	vpbroadcastd -0xadc8c1(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088701:	vpbroadcastq -0xadc0bb(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 108870b:	test   %eax,%eax
 108870d:	jne    1088720 <check_input_resolve_range+0x5a30>
 108870f:	mov    -0x10(%rbx),%r13d
 1088713:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088720:	cmp    $0x97,%rbp
 1088727:	ja     1088735 <check_input_resolve_range+0x5a45>
 1088729:	inc    %rbp
 108872c:	add    $0x18,%rbx
 1088730:	test   %r13d,%r13d
 1088733:	je     10886c0 <check_input_resolve_range+0x59d0>
 1088735:	mov    0x8(%rsp),%rbx
 108873a:	mov    0x28(%rsp),%rbp
 108873f:	mov    0x60(%rsp),%rax
 1088744:	mov    0x30(%rsp),%r15
 1088749:	mov    %r13w,(%rax,%r12,2)
 108874e:	cmpb   $0x2,0x50(%rsp)
 1088753:	jne    108878a <check_input_resolve_range+0x5a9a>
 1088755:	test   %r13w,%r13w
 1088759:	je     108878a <check_input_resolve_range+0x5a9a>
 108875b:	test   %r15d,%r15d
 108875e:	je     108899c <check_input_resolve_range+0x5cac>
 1088764:	cmpb   $0x0,0x98(%rbx)
 108876b:	je     108899c <check_input_resolve_range+0x5cac>
 1088771:	cmp    0x38(%rbx),%r15d
 1088775:	jae    108899c <check_input_resolve_range+0x5cac>
 108877b:	mov    0x30(%rbx),%rax
 108877f:	cmpl   $0x0,(%rax,%r15,4)
 1088784:	je     108899c <check_input_resolve_range+0x5cac>
 108878a:	mov    (%rbx),%rax
 108878d:	mov    0x238(%rax),%rax
 1088794:	cmpl   $0xffffffff,(%rax,%rbp,4)
 1088798:	jne    1082dc0 <check_input_resolve_range+0xd0>
 108879e:	mov    (%rsp),%r14
 10887a2:	mov    %rbx,%rdi
 10887a5:	mov    %r14d,%esi
 10887a8:	vzeroupper
 10887ab:	call   10a0d00 <check_input_intrinsic_prepare>
 10887b0:	test   %eax,%eax
 10887b2:	je     1088a8d <check_input_resolve_range+0x5d9d>
 10887b8:	vpbroadcastq -0xadc172(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 10887c2:	vpbroadcastd -0xadc98b(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10887cb:	vpbroadcastq -0xadc175(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 10887d5:	vpbroadcastd -0xadc99f(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 10887df:	vpbroadcastq -0xadc191(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 10887e9:	cmp    $0x1,%eax
 10887ec:	jne    1082dc0 <check_input_resolve_range+0xd0>
 10887f2:	mov    0x48(%rsp),%rax
 10887f7:	mov    (%rbx),%rcx
 10887fa:	mov    0x138(%rbx),%rdx
 1088801:	mov    0x60(%rax),%rax
 1088805:	mov    0x1f8(%rcx),%rsi
 108880c:	mov    0x208(%rcx),%r15
 1088813:	mov    0x218(%rcx),%rcx
 108881a:	mov    (%rax,%rbp,4),%eax
 108881d:	mov    (%rcx,%rax,4),%r8d
 1088821:	shl    $0x5,%r8
 1088825:	mov    -0x20(%r15,%r8,1),%ecx
 108882a:	movb   $0x1,(%rdx,%rbp,1)
 108882e:	mov    0xa8(%rbx),%rdi
 1088835:	imul   $0x130,%rcx,%rcx
 108883c:	mov    0xc(%rsi,%rcx,1),%edx
 1088840:	mov    %edx,(%rdi,%rax,4)
 1088843:	mov    (%rsi,%rcx,1),%rax
 1088847:	mov    0x118(%rsi,%rcx,1),%rdi
 108884f:	test   %rax,%rax
 1088852:	je     1088cad <check_input_resolve_range+0x5fbd>
 1088858:	mov    %rdi,0x50(%rsp)
 108885d:	mov    (%rax),%rcx
 1088860:	mov    0x40(%rax),%edi
 1088863:	mov    $0xb9,%eax
 1088868:	xor    %r13d,%r13d
 108886b:	mov    %r8,0x18(%rsp)
 1088870:	mov    %rcx,0x60(%rsp)
 1088875:	jmp    108888b <check_input_resolve_range+0x5b9b>
 1088877:	nopw   0x0(%rax,%rax,1)
 1088880:	mov    %r14d,%eax
 1088883:	mov    %r12d,%edi
 1088886:	cmp    %eax,%r13d
 1088889:	jae    10888e8 <check_input_resolve_range+0x5bf8>
 108888b:	mov    %eax,%ebx
 108888d:	sub    %r13d,%ebx
 1088890:	mov    %eax,0x30(%rsp)
 1088894:	lea    0xc13145(%rip),%rcx        # 1c9b9e0 <check_builtin_x86_rules>
 108889b:	xor    %ebp,%ebp
 108889d:	mov    %edi,%r12d
 10888a0:	shr    $1,%ebx
 10888a2:	lea    (%rbx,%r13,1),%r14d
 10888a6:	lea    (%r14,%r14,4),%rax
 10888aa:	mov    0x8(%rcx,%rax,8),%edx
 10888ae:	mov    (%rcx,%rax,8),%rsi
 10888b2:	cmp    %edx,%edi
 10888b4:	cmovb  %edi,%edx
 10888b7:	mov    0x60(%rsp),%rdi
 10888bc:	seta   %bpl
 10888c0:	vzeroupper
 10888c3:	call   788400 <memcmp@plt>
 10888c8:	xor    %ecx,%ecx
 10888ca:	test   %eax,%eax
 10888cc:	setg   %cl
 10888cf:	cmovne %ecx,%ebp
 10888d2:	test   %bpl,%bpl
 10888d5:	je     1088880 <check_input_resolve_range+0x5b90>
 10888d7:	mov    0x30(%rsp),%eax
 10888db:	lea    0x1(%rbx,%r13,1),%r13d
 10888e0:	mov    %r12d,%edi
 10888e3:	cmp    %eax,%r13d
 10888e6:	jb     108888b <check_input_resolve_range+0x5b9b>
 10888e8:	cmp    $0xb8,%r13d
 10888ef:	ja     1088c68 <check_input_resolve_range+0x5f78>
 10888f5:	mov    %r13d,%r12d
 10888f8:	lea    (%r12,%r12,4),%rax
 10888fc:	lea    0xc130dd(%rip),%rcx        # 1c9b9e0 <check_builtin_x86_rules>
 1088903:	inc    %r12
 1088906:	xor    %ebx,%ebx
 1088908:	lea    0x10(%rcx,%rax,8),%r13
 108890d:	mov    -0x8(%r13),%r14d
 1088911:	mov    -0x10(%r13),%rsi
 1088915:	mov    %edi,%ebp
 1088917:	cmp    %r14d,%edi
 108891a:	mov    %r14d,%edx
 108891d:	cmovb  %edi,%edx
 1088920:	mov    0x60(%rsp),%rdi
 1088925:	call   7883c0 <bcmp@plt>
 108892a:	test   %eax,%eax
 108892c:	jne    108894f <check_input_resolve_range+0x5c5f>
 108892e:	cmp    %r14d,%ebp
 1088931:	jne    108894f <check_input_resolve_range+0x5c5f>
 1088933:	movzbl 0x0(%r13),%eax
 1088938:	add    $0x28,%r13
 108893c:	mov    %ebp,%edi
 108893e:	bts    %rax,%rbx
 1088942:	mov    %r12d,%eax
 1088945:	inc    %r12
 1088948:	cmp    $0xb9,%eax
 108894d:	jne    108890d <check_input_resolve_range+0x5c1d>
 108894f:	mov    0x50(%rsp),%rdi
 1088954:	vpbroadcastq -0xadc30e(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 108895e:	vpbroadcastd -0xadcb27(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088967:	vpbroadcastq -0xadc311(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1088971:	vpbroadcastd -0xadcb3b(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 108897b:	vpbroadcastq -0xadc32d(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1088985:	mov    0x18(%rsp),%r8
 108898a:	mov    0x28(%rsp),%rbp
 108898f:	or     %rbx,%rdi
 1088992:	mov    0x8(%rsp),%rbx
 1088997:	jmp    1088cad <check_input_resolve_range+0x5fbd>
 108899c:	mov    0x48(%rsp),%rcx
 10889a1:	mov    0x60(%rcx),%rax
 10889a5:	mov    (%rax,%rbp,4),%eax
 10889a8:	cmp    0x30(%rcx),%eax
 10889ab:	jae    1088a42 <check_input_resolve_range+0x5d52>
 10889b1:	mov    0x50(%rcx),%rcx
 10889b5:	cmpb   $0x3c,(%rcx,%rax,1)
 10889b9:	jne    1088a42 <check_input_resolve_range+0x5d52>
 10889bf:	mov    (%rsp),%rdx
 10889c3:	inc    %edx
 10889c5:	cmp    %eax,%edx
 10889c7:	jae    1088a42 <check_input_resolve_range+0x5d52>
 10889c9:	mov    %edx,%edx
 10889cb:	cmpb   $0x23,(%rcx,%rdx,1)
 10889cf:	jne    1088a42 <check_input_resolve_range+0x5d52>
 10889d1:	mov    0x208(%rbx),%rcx
 10889d8:	mov    %r13w,(%rcx,%rax,2)
 10889dd:	mov    0x138(%rbx),%rax
 10889e4:	movb   $0x1,(%rax,%rbp,1)
 10889e8:	lea    -0x100(%r13),%eax
 10889ef:	cmp    $0x4,%ax
 10889f3:	ja     1082dc0 <check_input_resolve_range+0xd0>
 10889f9:	movzwl %r13w,%edx
 10889fd:	mov    (%rsp),%rsi
 1088a01:	mov    %rbx,%rdi
 1088a04:	vzeroupper
 1088a07:	call   1095a40 <check_input_vararg_prepare>
 1088a0c:	vpbroadcastq -0xadc3be(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1088a16:	vpbroadcastd -0xadcbe0(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088a20:	vpbroadcastq -0xadc3ca(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1088a2a:	vpbroadcastd -0xadcbf3(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088a33:	vpbroadcastq -0xadc3ed(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1088a3d:	jmp    1082dc0 <check_input_resolve_range+0xd0>
 1088a42:	mov    (%rbx),%rax
 1088a45:	mov    0x230(%rax),%ecx
 1088a4b:	cmp    0x234(%rax),%ecx
 1088a51:	jae    1082daa <check_input_resolve_range+0xba>
 1088a57:	movzbl 0x3c5(%rax),%edx
 1088a5e:	shl    $0x2,%edx
 1088a61:	lea    0x1(%rcx),%edi
 1088a64:	mov    0x228(%rax),%rsi
 1088a6b:	mov    %edi,0x230(%rax)
 1088a71:	lea    (%rcx,%rcx,2),%rax
 1088a75:	mov    (%rsp),%rcx
 1088a79:	mov    %ecx,(%rsi,%rax,4)
 1088a7c:	mov    %edx,0x4(%rsi,%rax,4)
 1088a80:	movl   $0x0,0x8(%rsi,%rax,4)
 1088a88:	jmp    1082dc0 <check_input_resolve_range+0xd0>
 1088a8d:	mov    0x40(%rbx),%eax
 1088a90:	mov    $0x1,%cl
 1088a92:	cmp    0x9c(%rbx),%eax
 1088a98:	je     1088aa8 <check_input_resolve_range+0x5db8>
 1088a9a:	mov    0x68(%rbx),%rcx
 1088a9e:	lea    -0x1(%rax),%edx
 1088aa1:	cmp    (%rcx,%rdx,4),%r14d
 1088aa5:	setae  %cl
 1088aa8:	vpbroadcastq -0xadc462(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1088ab2:	vpbroadcastd -0xadcc7b(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088abb:	vpbroadcastq -0xadc465(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1088ac5:	vpbroadcastd -0xadcc8f(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088acf:	vpbroadcastq -0xadc481(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1088ad9:	cmpb   $0x1,0x98(%rbx)
 1088ae0:	jne    1088b5c <check_input_resolve_range+0x5e6c>
 1088ae2:	cmp    0x3c(%rbx),%eax
 1088ae5:	setb   %dl
 1088ae8:	test   %r15d,%r15d
 1088aeb:	je     1088b5c <check_input_resolve_range+0x5e6c>
 1088aed:	and    %cl,%dl
 1088aef:	je     1088b5c <check_input_resolve_range+0x5e6c>
 1088af1:	cmp    0x38(%rbx),%r15d
 1088af5:	setb   0x98(%rbx)
 1088afc:	jae    1088b63 <check_input_resolve_range+0x5e73>
 1088afe:	lea    0x1(%rax),%ecx
 1088b01:	mov    %ecx,0x40(%rbx)
 1088b04:	mov    0x58(%rbx),%rcx
 1088b08:	mov    %r15d,(%rcx,%rax,4)
 1088b0c:	mov    0x60(%rbx),%rcx
 1088b10:	mov    %r14d,(%rcx,%rax,4)
 1088b14:	mov    0x68(%rbx),%rcx
 1088b18:	mov    %r14d,(%rcx,%rax,4)
 1088b1c:	mov    0x70(%rbx),%rcx
 1088b20:	movl   $0xffffffff,(%rcx,%rax,4)
 1088b27:	mov    0x80(%rbx),%rcx
 1088b2e:	movl   $0x0,(%rcx,%rax,4)
 1088b35:	mov    0x88(%rbx),%rcx
 1088b3c:	movb   $0x1,(%rcx,%rax,1)
 1088b40:	mov    0x90(%rbx),%rcx
 1088b47:	movb   $0x1,(%rcx,%rax,1)
 1088b4b:	mov    0x30(%rbx),%rcx
 1088b4f:	mov    0x78(%rbx),%rdx
 1088b53:	mov    (%rcx,%r15,4),%ecx
 1088b57:	mov    %ecx,(%rdx,%rax,4)
 1088b5a:	jmp    1088b6d <check_input_resolve_range+0x5e7d>
 1088b5c:	movb   $0x0,0x98(%rbx)
 1088b63:	mov    (%rbx),%rax
 1088b66:	movb   $0x1,0x3c5(%rax)
 1088b6d:	mov    0xc4(%rbx),%eax
 1088b73:	test   %eax,%eax
 1088b75:	jne    1088b87 <check_input_resolve_range+0x5e97>
 1088b77:	mov    (%rsp),%rcx
 1088b7b:	cmp    0x170(%rbx),%ecx
 1088b81:	jae    1082dc0 <check_input_resolve_range+0xd0>
 1088b87:	test   %r15d,%r15d
 1088b8a:	je     1088bcf <check_input_resolve_range+0x5edf>
 1088b8c:	cmpb   $0x0,0x98(%rbx)
 1088b93:	je     1088bcf <check_input_resolve_range+0x5edf>
 1088b95:	cmp    0x38(%rbx),%r15d
 1088b99:	jae    1088bcf <check_input_resolve_range+0x5edf>
 1088b9b:	mov    0x30(%rbx),%rcx
 1088b9f:	mov    (%rcx,%r15,4),%ecx
 1088ba3:	test   %ecx,%ecx
 1088ba5:	je     1088bcf <check_input_resolve_range+0x5edf>
 1088ba7:	mov    (%rbx),%rax
 1088baa:	mov    0x60(%rbx),%rdx
 1088bae:	dec    %ecx
 1088bb0:	mov    (%rdx,%rcx,4),%ecx
 1088bb3:	mov    0x238(%rax),%rax
 1088bba:	mov    %ecx,(%rax,%rbp,4)
 1088bbd:	mov    0xa0(%rbx),%rax
 1088bc4:	mov    (%rax,%rcx,4),%ecx
 1088bc7:	mov    %ecx,(%rax,%rbp,4)
 1088bca:	jmp    1082dc0 <check_input_resolve_range+0xd0>
 1088bcf:	test   %eax,%eax
 1088bd1:	je     1082dc0 <check_input_resolve_range+0xd0>
 1088bd7:	mov    (%rbx),%rax
 1088bda:	mov    0x230(%rax),%ecx
 1088be0:	cmp    0x234(%rax),%ecx
 1088be6:	jae    1082daa <check_input_resolve_range+0xba>
 1088bec:	movzbl 0x3c5(%rax),%edx
 1088bf3:	lea    0x2(%rdx,%rdx,1),%edx
 1088bf7:	jmp    1088a61 <check_input_resolve_range+0x5d71>
 1088bfc:	xor    %edx,%edx
 1088bfe:	xor    %esi,%esi
 1088c00:	test   %sil,%sil
 1088c03:	jne    10879b0 <check_input_resolve_range+0x4cc0>
 1088c09:	test   %dl,%dl
 1088c0b:	je     1088c26 <check_input_resolve_range+0x5f36>
 1088c0d:	lea    0x1(%r13),%edx
 1088c11:	cmp    %ecx,%edx
 1088c13:	jae    1088c26 <check_input_resolve_range+0x5f36>
 1088c15:	mov    0x10(%r12),%rsi
 1088c1a:	mov    %edx,%edx
 1088c1c:	cmpb   $0x6,(%rsi,%rdx,1)
 1088c20:	je     10879b0 <check_input_resolve_range+0x4cc0>
 1088c26:	cmpl   $0x44,0x3c(%rsp)
 1088c2b:	jne    1087968 <check_input_resolve_range+0x4c78>
 1088c31:	lea    0x1(%r13),%edx
 1088c35:	cmp    %ecx,%edx
 1088c37:	jae    1087968 <check_input_resolve_range+0x4c78>
 1088c3d:	mov    0x50(%r12),%rsi
 1088c42:	mov    %edx,%ecx
 1088c44:	cmpb   $0x7,(%rsi,%rcx,1)
 1088c48:	je     10879b0 <check_input_resolve_range+0x4cc0>
 1088c4e:	mov    0x10(%r12),%rdx
 1088c53:	movzbl (%rdx,%rcx,1),%ecx
 1088c57:	add    $0xcb,%cl
 1088c5a:	cmp    $0x2,%cl
 1088c5d:	jae    1087968 <check_input_resolve_range+0x4c78>
 1088c63:	jmp    10879b0 <check_input_resolve_range+0x4cc0>
 1088c68:	vpbroadcastq -0xadc622(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1088c72:	vpbroadcastd -0xadce3b(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088c7b:	vpbroadcastq -0xadc625(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1088c85:	vpbroadcastd -0xadce4f(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088c8f:	vpbroadcastq -0xadc641(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1088c99:	mov    0x8(%rsp),%rbx
 1088c9e:	mov    0x28(%rsp),%rbp
 1088ca3:	mov    0x50(%rsp),%rdi
 1088ca8:	mov    0x18(%rsp),%r8
 1088cad:	add    %r8,%r15
 1088cb0:	mov    -0xc(%r15),%ecx
 1088cb4:	test   %ecx,%ecx
 1088cb6:	je     1082dc0 <check_input_resolve_range+0xd0>
 1088cbc:	xor    %eax,%eax
 1088cbe:	xchg   %ax,%ax
 1088cc0:	bt     %rax,%rdi
 1088cc4:	jae    1088cff <check_input_resolve_range+0x600f>
 1088cc6:	mov    -0x8(%r15),%rsi
 1088cca:	mov    (%rsi,%rax,8),%edx
 1088ccd:	cmp    0x4(%rsi,%rax,8),%edx
 1088cd1:	jae    1088cff <check_input_resolve_range+0x600f>
 1088cd3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088ce0:	mov    0x280(%rbx),%rcx
 1088ce7:	orb    $0x1,(%rcx,%rdx,1)
 1088ceb:	inc    %rdx
 1088cee:	mov    -0x8(%r15),%rcx
 1088cf2:	mov    0x4(%rcx,%rax,8),%ecx
 1088cf6:	cmp    %rcx,%rdx
 1088cf9:	jb     1088ce0 <check_input_resolve_range+0x5ff0>
 1088cfb:	mov    -0xc(%r15),%ecx
 1088cff:	lea    0x1(%rax),%rdx
 1088d03:	mov    %ecx,%esi
 1088d05:	cmp    %rsi,%rdx
 1088d08:	jae    1082dc0 <check_input_resolve_range+0xd0>
 1088d0e:	cmp    $0x3f,%rax
 1088d12:	mov    %rdx,%rax
 1088d15:	jb     1088cc0 <check_input_resolve_range+0x5fd0>
 1088d17:	jmp    1082dc0 <check_input_resolve_range+0xd0>
 1088d1c:	mov    0x48(%rsp),%rdi
 1088d21:	mov    %ebp,%esi
 1088d23:	mov    %r14d,%edx
 1088d26:	vzeroupper
 1088d29:	call   109a710 <check_input_attribute_starts>
 1088d2e:	vpbroadcastq -0xadc6e0(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1088d38:	vpbroadcastd -0xadcf02(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088d42:	vpbroadcastq -0xadc6ec(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1088d4c:	vpbroadcastd -0xadcf15(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088d55:	vpbroadcastq -0xadc70f(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1088d5f:	test   %al,%al
 1088d61:	jne    1088376 <check_input_resolve_range+0x5686>
 1088d67:	jmp    10885b0 <check_input_resolve_range+0x58c0>
 1088d6c:	mov    %r8d,%edx
 1088d6f:	cmp    %ecx,%edx
 1088d71:	jne    1088d7c <check_input_resolve_range+0x608c>
 1088d73:	movb   $0x1,(%rsi,%rbp,1)
 1088d77:	jmp    1086b00 <check_input_resolve_range+0x3e10>
 1088d7c:	mov    (%rbx),%rax
 1088d7f:	mov    0x230(%rax),%ecx
 1088d85:	cmp    0x234(%rax),%ecx
 1088d8b:	jae    1088dc1 <check_input_resolve_range+0x60d1>
 1088d8d:	movzbl 0x3c5(%rax),%edx
 1088d94:	mov    0x228(%rax),%rsi
 1088d9b:	lea    0x1(%rcx),%edi
 1088d9e:	mov    %edi,0x230(%rax)
 1088da4:	lea    (%rcx,%rcx,2),%rax
 1088da8:	lea    0x1(%rdx,%rdx,2),%edx
 1088dac:	mov    %r13d,(%rsi,%rax,4)
 1088db0:	mov    %edx,0x4(%rsi,%rax,4)
 1088db4:	movl   $0x0,0x8(%rsi,%rax,4)
 1088dbc:	jmp    1086b00 <check_input_resolve_range+0x3e10>
 1088dc1:	movb   $0x1,0x3c5(%rax)
 1088dc8:	jmp    1086b00 <check_input_resolve_range+0x3e10>
 1088dcd:	and    $0x1,%bpl
 1088dd1:	cmp    $0x1,%bpl
 1088dd5:	mov    0x28(%rsp),%rbp
 1088dda:	sbb    %r10d,%r10d
 1088ddd:	or     %edi,%r10d
 1088de0:	mov    0x8(%rsp),%rbx
 1088de5:	mov    (%rbx),%rdx
 1088de8:	mov    0x328(%rdx),%esi
 1088dee:	lea    0x1(%rsi),%edi
 1088df1:	lea    (%rsi,%rsi,2),%rsi
 1088df5:	mov    %edi,0x328(%rdx)
 1088dfb:	mov    (%rbx),%rdx
 1088dfe:	mov    0x3bc(%rbx),%r8d
 1088e05:	mov    0x318(%rdx),%rdx
 1088e0c:	mov    %r13d,(%rdx,%rsi,8)
 1088e10:	mov    %eax,0x4(%rdx,%rsi,8)
 1088e14:	mov    %ecx,0x8(%rdx,%rsi,8)
 1088e18:	mov    %r8d,0xc(%rdx,%rsi,8)
 1088e1d:	movl   $0xffffffff,0x10(%rdx,%rsi,8)
 1088e25:	mov    %r10d,0x14(%rdx,%rsi,8)
 1088e2a:	mov    (%rbx),%rdx
 1088e2d:	mov    0x320(%rdx),%rdx
 1088e34:	mov    %edi,(%rdx,%rbp,4)
 1088e37:	mov    (%rbx),%rdx
 1088e3a:	mov    0x320(%rdx),%rdx
 1088e41:	mov    %edi,(%rdx,%rax,4)
 1088e44:	mov    (%rbx),%rax
 1088e47:	mov    0x320(%rax),%rax
 1088e4e:	mov    %edi,(%rax,%rcx,4)
 1088e51:	mov    0x138(%rbx),%rax
 1088e58:	movzbl (%rax,%rbp,1),%eax
 1088e5c:	test   %al,%al
 1088e5e:	je     1084303 <check_input_resolve_range+0x1613>
 1088e64:	jmp    1086aeb <check_input_resolve_range+0x3dfb>
 1088e69:	mov    (%rbx),%rsi
 1088e6c:	mov    0x28(%rsp),%r8
 1088e71:	mov    0x238(%rsi),%rsi
 1088e78:	mov    %r13d,(%rsi,%r8,4)
 1088e7c:	mov    0xa0(%rbx),%rsi
 1088e83:	mov    %eax,(%rsi,%r8,4)
 1088e87:	mov    0x100(%rbx),%rsi
 1088e8e:	movb   $0x1,(%rsi,%r8,1)
 1088e93:	mov    0x130(%rbx),%rsi
 1088e9a:	mov    %ebp,(%rsi,%r8,4)
 1088e9e:	cmpl   $0x0,0x3b4(%rbx)
 1088ea5:	mov    0x118(%rbx),%rsi
 1088eac:	sete   (%rsi,%r8,1)
 1088eb1:	mov    0x108(%rbx),%rsi
 1088eb8:	movb   $0x1,(%rsi,%r8,1)
 1088ebd:	mov    (%rbx),%rsi
 1088ec0:	mov    0x280(%rsi),%rsi
 1088ec7:	movb   $0x1,(%rsi,%r8,1)
 1088ecc:	mov    (%rbx),%rdi
 1088ecf:	mov    0x3bc(%rbx),%esi
 1088ed5:	mov    0x2e0(%rdi),%rdi
 1088edc:	mov    %esi,(%rdi,%r8,4)
 1088ee0:	mov    %rbx,%rdi
 1088ee3:	mov    (%rbx),%rsi
 1088ee6:	mov    0x2b0(%rsi),%rsi
 1088eed:	mov    %ecx,(%rsi,%r8,4)
 1088ef1:	lea    0x1(%rdx),%ecx
 1088ef4:	mov    (%rbx),%rsi
 1088ef7:	mov    0x2b8(%rsi),%rsi
 1088efe:	mov    %ecx,(%rsi,%r8,4)
 1088f02:	mov    %r13d,%esi
 1088f05:	mov    0x150(%rbx),%rcx
 1088f0c:	mov    %r13d,(%rcx,%r8,4)
 1088f10:	mov    0x150(%rbx),%rcx
 1088f17:	mov    %r13d,(%rcx,%rdx,4)
 1088f1b:	mov    0xa8(%rbx),%rcx
 1088f22:	mov    %eax,(%rcx,%r8,4)
 1088f26:	vzeroupper
 1088f29:	call   109a790 <check_input_initializer_prepare>
 1088f2e:	vpbroadcastq -0xadc8e0(%rip),%zmm16        # 5ac658 <check_mutation_families+0x1b8>
 1088f38:	vpbroadcastd -0xadd102(%rip),%zmm15        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088f42:	vpbroadcastq -0xadc8ec(%rip),%zmm14        # 5ac660 <check_mutation_families+0x1c0>
 1088f4c:	vpbroadcastd -0xadd115(%rip),%ymm13        # 5abe40 <link_program_emit_worker.forms+0x3d0>
 1088f55:	vpbroadcastq -0xadc90f(%rip),%zmm12        # 5ac650 <check_mutation_families+0x1b0>
 1088f5f:	mov    0x138(%rbx),%rax
 1088f66:	movb   $0x1,(%rax,%r14,1)
 1088f6b:	jmp    1088592 <check_input_resolve_range+0x58a2>
 1088f70:	mov    %r13d,0x24(%rsp)
 1088f75:	mov    (%rsp),%r13
 1088f79:	jmp    108550f <check_input_resolve_range+0x281f>
 1088f7e:	mov    0x8(%rsp),%rax
 1088f83:	mov    (%rax),%rax
 1088f86:	mov    0x230(%rax),%ecx
 1088f8c:	cmp    0x234(%rax),%ecx
 1088f92:	jae    1088fc7 <check_input_resolve_range+0x62d7>
 1088f94:	movzbl 0x3c5(%rax),%edx
 1088f9b:	mov    0x228(%rax),%rsi
 1088fa2:	lea    0x1(%rcx),%edi
 1088fa5:	mov    %edi,0x230(%rax)
 1088fab:	lea    (%rcx,%rcx,2),%rax
 1088faf:	lea    0x1(%rdx,%rdx,2),%edx
 1088fb3:	mov    %ebp,(%rsi,%rax,4)
 1088fb6:	mov    %edx,0x4(%rsi,%rax,4)
 1088fba:	movl   $0x0,0x8(%rsi,%rax,4)
 1088fc2:	jmp    1082d24 <check_input_resolve_range+0x34>
 1088fc7:	movb   $0x1,0x3c5(%rax)
 1088fce:	jmp    1082d24 <check_input_resolve_range+0x34>
 1088fd3:	cmpl   $0x0,0x234(%rax)
 1088fda:	je     108901e <check_input_resolve_range+0x632e>
 1088fdc:	mov    0x3c8(%rbx),%ecx
 1088fe2:	mov    0x3cc(%rbx),%edx
 1088fe8:	mov    0x228(%rax),%rsi
 1088fef:	movl   $0x1,0x230(%rax)
 1088ff9:	cmp    $0xffffffff,%ecx
 1088ffc:	cmovne %ecx,%r13d
 1089000:	mov    %r13d,(%rsi)
 1089003:	mov    %edx,0x4(%rsi)
 1089006:	movl   $0x0,0x8(%rsi)
 108900d:	mov    (%rbx),%rax
 1089010:	cmpl   $0x0,0x230(%rax)
 1089017:	jne    1089035 <check_input_resolve_range+0x6345>
 1089019:	jmp    1082d24 <check_input_resolve_range+0x34>
 108901e:	movb   $0x1,0x3c5(%rax)
 1089025:	mov    (%rbx),%rax
 1089028:	cmpl   $0x0,0x230(%rax)
 108902f:	je     1082d24 <check_input_resolve_range+0x34>
 1089035:	cmpl   $0xffffffff,0x3c8(%rbx)
 108903c:	jne    1082d24 <check_input_resolve_range+0x34>
 1089042:	mov    0x3c4(%rbx),%ecx
 1089048:	mov    0x228(%rax),%rax
 108904f:	inc    %ecx
 1089051:	mov    %ecx,0x8(%rax)
 1089054:	jmp    1082d24 <check_input_resolve_range+0x34>
 1089059:	mov    0x3d0(%rbx),%eax
 108905f:	cmp    %eax,%r13d
 1089062:	cmovb  %r13d,%eax
 1089066:	mov    %eax,0x3d0(%rbx)
 108906c:	mov    0x230(%rcx),%eax
 1089072:	cmp    0x234(%rcx),%eax
 1089078:	jae    10890c1 <check_input_resolve_range+0x63d1>
 108907a:	mov    0x3c8(%rbx),%esi
 1089080:	cmp    $0xffffffff,%esi
 1089083:	cmovne %esi,%edx
 1089086:	cmpb   $0x0,0x3c5(%rcx)
 108908d:	mov    $0x4,%esi
 1089092:	jne    108909a <check_input_resolve_range+0x63aa>
 1089094:	mov    0x3cc(%rbx),%esi
 108909a:	mov    0x228(%rcx),%rdi
 10890a1:	lea    0x1(%rax),%r8d
 10890a5:	mov    %r8d,0x230(%rcx)
 10890ac:	lea    (%rax,%rax,2),%rcx
 10890b0:	mov    %edx,(%rdi,%rcx,4)
 10890b3:	mov    %esi,0x4(%rdi,%rcx,4)
 10890b7:	movl   $0x0,0x8(%rdi,%rcx,4)
 10890bf:	jmp    10890c8 <check_input_resolve_range+0x63d8>
 10890c1:	movb   $0x1,0x3c5(%rcx)
 10890c8:	mov    (%rbx),%rcx
 10890cb:	cmp    %eax,0x230(%rcx)
 10890d1:	je     1082d24 <check_input_resolve_range+0x34>
 10890d7:	cmpl   $0xffffffff,0x3c8(%rbx)
 10890de:	jne    1082d24 <check_input_resolve_range+0x34>
 10890e4:	mov    0x3c4(%rbx),%edx
 10890ea:	mov    0x228(%rcx),%rcx
 10890f1:	lea    (%rax,%rax,2),%rax
 10890f5:	inc    %edx
 10890f7:	mov    %edx,0x8(%rcx,%rax,4)
 10890fb:	jmp    1082d24 <check_input_resolve_range+0x34>
 1089100:	lea    -0x990df9(%rip),%rdi        # 6f830e <pp_string_value.meaning+0x6fb0d>
 1089107:	lea    -0x9d7b47(%rip),%rsi        # 6b15c7 <pp_string_value.meaning+0x28dc6>
 108910e:	lea    -0x9d7b33(%rip),%rcx        # 6b15e2 <pp_string_value.meaning+0x28de1>
 1089115:	mov    $0xbd,%edx
 108911a:	vzeroupper
 108911d:	call   787c60 <__assert_fail@plt>
 1089122:	vzeroupper
 1089125:	call   787bf0 <__stack_chk_fail@plt>
