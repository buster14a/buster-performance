
../campaign/native-images/base/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001088c20 <check_input_expressions>:
 1088c20:	push   %rbp
 1088c21:	push   %r15
 1088c23:	push   %r14
 1088c25:	push   %r13
 1088c27:	push   %r12
 1088c29:	push   %rbx
 1088c2a:	sub    $0x178,%rsp
 1088c31:	mov    %fs:0x28,%rax
 1088c3a:	mov    %rax,0x170(%rsp)
 1088c42:	mov    0x8(%rdi),%r9
 1088c46:	cmpl   $0x0,0x30(%r9)
 1088c4b:	je     108e615 <check_input_expressions+0x59f5>
 1088c51:	vpmovsxbq -0xbeb05a(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 1088c5a:	mov    (%rdi),%rax
 1088c5d:	mov    $0xffffffff,%r11d
 1088c63:	mov    %rdi,%r12
 1088c66:	vxorps %xmm2,%xmm2,%xmm2
 1088c6a:	xor    %edx,%edx
 1088c6c:	mov    %r9,0x18(%rsp)
 1088c71:	mov    %rax,0x70(%rsp)
 1088c76:	lea    0x30(%r9),%rax
 1088c7a:	mov    %rax,0x78(%rsp)
 1088c7f:	jmp    1088cab <check_input_expressions+0x8b>
 1088c81:	movb   $0x1,0x3bd(%r13)
 1088c89:	nopl   0x0(%rax)
 1088c90:	mov    0x78(%rsp),%rax
 1088c95:	mov    0xc8(%rsp),%rdx
 1088c9d:	mov    (%rax),%eax
 1088c9f:	inc    %rdx
 1088ca2:	cmp    %rax,%rdx
 1088ca5:	jae    108e615 <check_input_expressions+0x59f5>
 1088cab:	mov    (%r12),%rax
 1088caf:	cmpb   $0x1,0x3bd(%rax)
 1088cb6:	je     108e615 <check_input_expressions+0x59f5>
 1088cbc:	mov    0x68(%r9),%rcx
 1088cc0:	mov    0x8(%r12),%rsi
 1088cc5:	mov    %rdx,0xc8(%rsp)
 1088ccd:	mov    (%rcx,%rdx,4),%edx
 1088cd0:	mov    0x50(%rsi),%rcx
 1088cd4:	cmpb   $0x49,(%rcx,%rdx,1)
 1088cd8:	mov    %edx,%ecx
 1088cda:	je     1088ce7 <check_input_expressions+0xc7>
 1088cdc:	mov    0x368(%r12),%rcx
 1088ce4:	mov    (%rcx,%rdx,4),%ecx
 1088ce7:	mov    %rdx,0x10(%rsp)
 1088cec:	inc    %ecx
 1088cee:	cmp    0x3d0(%r12),%ecx
 1088cf6:	ja     1088c90 <check_input_expressions+0x70>
 1088cf8:	mov    0x1f0(%rax),%rax
 1088cff:	test   %rax,%rax
 1088d02:	je     1088d0f <check_input_expressions+0xef>
 1088d04:	mov    0x10(%rsp),%rcx
 1088d09:	cmpb   $0x0,(%rax,%rcx,1)
 1088d0d:	jne    1088c90 <check_input_expressions+0x70>
 1088d0f:	mov    0x10(%r9),%rax
 1088d13:	mov    0x10(%rsp),%r14
 1088d18:	mov    0x50(%r9),%rcx
 1088d1c:	movzbl (%rax,%r14,1),%edi
 1088d21:	mov    0x370(%r12),%rax
 1088d29:	movzbl (%rcx,%r14,1),%r15d
 1088d2e:	mov    (%rax,%r14,4),%eax
 1088d32:	cmp    $0xffffffff,%eax
 1088d35:	je     1088e07 <check_input_expressions+0x1e7>
 1088d3b:	mov    $0xffffffff,%r8d
 1088d41:	mov    $0xffffffff,%ebx
 1088d46:	xor    %ebp,%ebp
 1088d48:	jmp    1088d62 <check_input_expressions+0x142>
 1088d4a:	nopw   0x0(%rax,%rax,1)
 1088d50:	mov    %eax,%eax
 1088d52:	mov    0x378(%r12),%rcx
 1088d5a:	mov    (%rcx,%rax,4),%eax
 1088d5d:	cmp    $0xffffffff,%eax
 1088d60:	je     1088dd1 <check_input_expressions+0x1b1>
 1088d62:	cmp    %r14d,%eax
 1088d65:	jae    1088d76 <check_input_expressions+0x156>
 1088d67:	mov    0xb8(%r12),%rcx
 1088d6f:	cmpq   $0x0,(%rcx,%r14,8)
 1088d74:	jne    1088d50 <check_input_expressions+0x130>
 1088d76:	mov    0x380(%r12),%rcx
 1088d7e:	mov    %eax,%eax
 1088d80:	mov    (%rcx,%rax,4),%ecx
 1088d83:	cmp    $0xffffffff,%ecx
 1088d86:	je     1088d52 <check_input_expressions+0x132>
 1088d88:	mov    %ecx,%edx
 1088d8a:	cmp    $0xffffffff,%ebx
 1088d8d:	je     1088d9f <check_input_expressions+0x17f>
 1088d8f:	mov    0x390(%r12),%rdx
 1088d97:	mov    %ebx,%esi
 1088d99:	mov    %ecx,(%rdx,%rsi,4)
 1088d9c:	mov    %r8d,%edx
 1088d9f:	mov    0x388(%r12),%r8
 1088da7:	mov    0x390(%r12),%rsi
 1088daf:	mov    (%r8,%rax,4),%ebx
 1088db3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088dc0:	mov    %ecx,%ecx
 1088dc2:	mov    (%rsi,%rcx,4),%ecx
 1088dc5:	inc    %ebp
 1088dc7:	cmp    $0xffffffff,%ecx
 1088dca:	jne    1088dc0 <check_input_expressions+0x1a0>
 1088dcc:	mov    %edx,%r8d
 1088dcf:	jmp    1088d52 <check_input_expressions+0x132>
 1088dd1:	mov    $0xffffffff,%esi
 1088dd6:	cmp    $0xffffffff,%r8d
 1088dda:	je     1088e31 <check_input_expressions+0x211>
 1088ddc:	mov    0x390(%r12),%rcx
 1088de4:	mov    %r8d,%eax
 1088de7:	mov    $0x1,%dl
 1088de9:	mov    (%rcx,%rax,4),%eax
 1088dec:	cmp    %r11,%rax
 1088def:	je     1088e39 <check_input_expressions+0x219>
 1088df1:	mov    (%rcx,%rax,4),%r10d
 1088df5:	mov    %eax,%esi
 1088df7:	mov    %r15,0x48(%rsp)
 1088dfc:	cmp    $0x3b,%r15b
 1088e00:	je     1088e4e <check_input_expressions+0x22e>
 1088e02:	jmp    1088f60 <check_input_expressions+0x340>
 1088e07:	xor    %edx,%edx
 1088e09:	mov    $0xffffffff,%r8d
 1088e0f:	mov    $0xffffffff,%ebx
 1088e14:	xor    %ebp,%ebp
 1088e16:	mov    $0xffffffff,%esi
 1088e1b:	mov    $0xffffffff,%r10d
 1088e21:	mov    %r15,0x48(%rsp)
 1088e26:	cmp    $0x3b,%r15b
 1088e2a:	je     1088e4e <check_input_expressions+0x22e>
 1088e2c:	jmp    1088f60 <check_input_expressions+0x340>
 1088e31:	xor    %edx,%edx
 1088e33:	mov    $0xffffffff,%r8d
 1088e39:	mov    $0xffffffff,%r10d
 1088e3f:	mov    %r15,0x48(%rsp)
 1088e44:	cmp    $0x3b,%r15b
 1088e48:	jne    1088f60 <check_input_expressions+0x340>
 1088e4e:	mov    (%r12),%r13
 1088e52:	mov    0x318(%r13),%rax
 1088e59:	mov    (%rax,%r14,4),%eax
 1088e5d:	test   %eax,%eax
 1088e5f:	je     1088f60 <check_input_expressions+0x340>
 1088e65:	mov    0x310(%r13),%rcx
 1088e6c:	dec    %eax
 1088e6e:	mov    %ebx,0xa4(%rsp)
 1088e75:	lea    (%rax,%rax,2),%rax
 1088e79:	cmpl   $0xffffffff,0x10(%rcx,%rax,8)
 1088e7e:	lea    (%rcx,%rax,8),%rbx
 1088e82:	je     1089178 <check_input_expressions+0x558>
 1088e88:	mov    0x28(%r12),%rcx
 1088e8d:	lea    0x120(%rsp),%rsi
 1088e95:	mov    (%rbx),%edx
 1088e97:	vpxor  %xmm0,%xmm0,%xmm0
 1088e9b:	mov    %r8d,0xc(%rsp)
 1088ea0:	mov    0x8(%rcx),%rax
 1088ea4:	mov    %rax,0x80(%rsp)
 1088eac:	mov    0x4(%rbx),%eax
 1088eaf:	vmovdqu64 %zmm0,(%rsi)
 1088eb5:	mov    %r12,0x110(%rsp)
 1088ebd:	mov    %rbx,0x118(%rsp)
 1088ec5:	mov    0x138(%r13),%esi
 1088ecc:	mov    %esi,0x148(%rsp)
 1088ed3:	cmp    %eax,%edx
 1088ed5:	jae    108909b <check_input_expressions+0x47b>
 1088edb:	cmp    0x35c(%r13),%eax
 1088ee2:	jae    108909b <check_input_expressions+0x47b>
 1088ee8:	sub    %rdx,%rax
 1088eeb:	lea    0x8(,%rax,8),%rdx
 1088ef3:	shr    $0x20,%rdx
 1088ef7:	jne    108909b <check_input_expressions+0x47b>
 1088efd:	cmpq   $0x0,0x278(%r12)
 1088f06:	je     108909b <check_input_expressions+0x47b>
 1088f0c:	mov    0x128(%r13),%edx
 1088f13:	cmp    0x12c(%r13),%edx
 1088f1a:	jae    108909b <check_input_expressions+0x47b>
 1088f20:	lea    0x9(,%rax,8),%rdx
 1088f28:	mov    %edx,0x154(%rsp)
 1088f2f:	mov    (%rcx),%r8
 1088f32:	mov    0x8(%rcx),%rdi
 1088f36:	lea    0x3(%rdi,%r8,1),%rsi
 1088f3b:	add    %r8,%rdi
 1088f3e:	and    $0xfffffffffffffffc,%rsi
 1088f42:	cmp    %rdi,%rsi
 1088f45:	jae    108b1a2 <check_input_expressions+0x2582>
 1088f4b:	xor    %esi,%esi
 1088f4d:	jmp    108b1d1 <check_input_expressions+0x25b1>
 1088f52:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088f60:	mov    0x1c0(%r12),%rax
 1088f68:	cmpl   $0x0,(%rax,%r14,4)
 1088f6d:	je     1089017 <check_input_expressions+0x3f7>
 1088f73:	mov    $0xffffffff,%ecx
 1088f78:	mov    $0xffffffff,%r8d
 1088f7e:	mov    $0xffffffff,%r9d
 1088f84:	mov    %r12,%rdi
 1088f87:	xor    %esi,%esi
 1088f89:	mov    %r14d,%edx
 1088f8c:	vzeroupper
 1088f8f:	call   10facf0 <check_input_add>
 1088f94:	vpmovsxbq -0xbeb39d(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 1088f9d:	mov    0x18(%rsp),%r9
 1088fa2:	mov    $0xffffffff,%r11d
 1088fa8:	vxorps %xmm2,%xmm2,%xmm2
 1088fac:	cmp    $0xffffffff,%eax
 1088faf:	je     1088c90 <check_input_expressions+0x70>
 1088fb5:	mov    0x1c0(%r12),%rdx
 1088fbd:	mov    0x10(%rsp),%rsi
 1088fc2:	mov    %eax,%r15d
 1088fc5:	mov    0x70(%rsp),%rax
 1088fca:	mov    %r15d,%ecx
 1088fcd:	lea    (%rcx,%rcx,2),%rcx
 1088fd1:	shl    $0x5,%rcx
 1088fd5:	mov    (%rdx,%rsi,4),%edx
 1088fd8:	mov    0x1b8(%r12),%rsi
 1088fe0:	mov    0x28(%rax),%rax
 1088fe4:	dec    %edx
 1088fe6:	lea    (%rdx,%rdx,2),%rdx
 1088fea:	shl    $0x5,%rdx
 1088fee:	vmovdqu64 (%rsi,%rdx,1),%zmm0
 1088ff5:	vmovups 0x20(%rsi,%rdx,1),%zmm1
 1089000:	vmovups %zmm1,0x20(%rax,%rcx,1)
 108900b:	vmovdqu64 %zmm0,(%rax,%rcx,1)
 1089012:	jmp    108dc87 <check_input_expressions+0x5067>
 1089017:	mov    0x1a0(%r12),%rax
 108901f:	mov    %ebx,0xa4(%rsp)
 1089026:	mov    (%rax,%r14,4),%eax
 108902a:	cmp    %r11,%rax
 108902d:	je     1089212 <check_input_expressions+0x5f2>
 1089033:	mov    (%r12),%rcx
 1089037:	mov    0x2c0(%rcx),%rcx
 108903e:	mov    (%rcx,%rax,4),%ecx
 1089041:	cmp    $0xffffffff,%ecx
 1089044:	je     108dc2f <check_input_expressions+0x500f>
 108904a:	mov    %r8d,%ebx
 108904d:	mov    $0x34,%esi
 1089052:	mov    $0xffffffff,%r8d
 1089058:	mov    $0xffffffff,%r9d
 108905e:	mov    %r12,%rdi
 1089061:	mov    %r14d,%edx
 1089064:	vzeroupper
 1089067:	call   10facf0 <check_input_add>
 108906c:	vpmovsxbq -0xbeb475(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 1089075:	mov    0x18(%rsp),%r9
 108907a:	mov    %ebx,%r8d
 108907d:	mov    $0xffffffff,%r11d
 1089083:	vxorps %xmm2,%xmm2,%xmm2
 1089087:	mov    %eax,%r15d
 108908a:	xor    %esi,%esi
 108908c:	cmp    $0xffffffff,%r15d
 1089090:	jne    108dc87 <check_input_expressions+0x5067>
 1089096:	jmp    108de5d <check_input_expressions+0x523d>
 108909b:	lea    0x120(%rsp),%rax
 10890a3:	vpxor  %xmm0,%xmm0,%xmm0
 10890a7:	mov    $0x1,%sil
 10890aa:	xor    %edx,%edx
 10890ac:	xor    %edi,%edi
 10890ae:	vmovdqu %ymm0,(%rax)
 10890b2:	mov    %rdi,0x140(%rsp)
 10890ba:	mov    0x120(%rsp),%rax
 10890c2:	test   %rax,%rax
 10890c5:	sete   %cl
 10890c8:	cmpq   $0x0,0x128(%rsp)
 10890d1:	sete   %r8b
 10890d5:	or     %cl,%r8b
 10890d8:	cmpq   $0x0,0x130(%rsp)
 10890e1:	sete   %cl
 10890e4:	test   %rdx,%rdx
 10890e7:	sete   %dl
 10890ea:	or     %cl,%dl
 10890ec:	or     %r8b,%dl
 10890ef:	test   %rdi,%rdi
 10890f2:	sete   %cl
 10890f5:	or     %sil,%cl
 10890f8:	mov    (%r12),%rsi
 10890fc:	or     %dl,%cl
 10890fe:	or     %cl,0x3bd(%rsi)
 1089104:	mov    0x14c(%rsp),%edx
 108910b:	test   %cl,%cl
 108910d:	je     1089117 <check_input_expressions+0x4f7>
 108910f:	mov    %edx,%r14d
 1089112:	jmp    108986a <check_input_expressions+0xc4a>
 1089117:	mov    0x118(%rsp),%rcx
 108911f:	mov    0x8(%r12),%r15
 1089124:	mov    (%rcx),%esi
 1089126:	mov    0x8(%rcx),%ecx
 1089129:	mov    %esi,0x30(%rsp)
 108912d:	cmp    $0xffffffff,%ecx
 1089130:	je     1089356 <check_input_expressions+0x736>
 1089136:	cmp    0x154(%rsp),%edx
 108913d:	jae    108934b <check_input_expressions+0x72b>
 1089143:	vpmovsxbq -0xbeb54a(%rip),%xmm0        # 49dc02 <cbuiltin_test_generated.edges+0x3dc2>
 108914c:	mov    %edx,%esi
 108914e:	inc    %esi
 1089150:	shl    $0x5,%rdx
 1089154:	mov    %esi,0x14c(%rsp)
 108915b:	vpinsrd $0x1,%ecx,%xmm0,%xmm0
 1089161:	vmovdqu %xmm0,(%rax,%rdx,1)
 1089166:	vmovups %xmm2,0x10(%rax,%rdx,1)
 108916c:	mov    0x14c(%rsp),%edx
 1089173:	jmp    1089356 <check_input_expressions+0x736>
 1089178:	mov    %r14d,%edx
 108917b:	mov    %rbx,%r14
 108917e:	mov    %r8d,%ebx
 1089181:	mov    $0xffffffff,%ecx
 1089186:	mov    $0xffffffff,%r8d
 108918c:	mov    $0xffffffff,%r9d
 1089192:	mov    %r12,%rdi
 1089195:	xor    %esi,%esi
 1089197:	vzeroupper
 108919a:	call   10facf0 <check_input_add>
 108919f:	vpmovsxbq -0xbeb5a8(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 10891a8:	mov    0x18(%rsp),%r9
 10891ad:	mov    $0xffffffff,%r11d
 10891b3:	vxorps %xmm2,%xmm2,%xmm2
 10891b7:	mov    %eax,0x10(%r14)
 10891bb:	cmp    $0xffffffff,%eax
 10891be:	je     1088c90 <check_input_expressions+0x70>
 10891c4:	mov    0x70(%rsp),%rcx
 10891c9:	mov    %eax,%eax
 10891cb:	lea    (%rax,%rax,2),%rax
 10891cf:	vpxor  %xmm0,%xmm0,%xmm0
 10891d3:	mov    %ebx,%r8d
 10891d6:	mov    %r14,%rbx
 10891d9:	shl    $0x5,%rax
 10891dd:	mov    0x28(%rcx),%rcx
 10891e1:	movl   $0x8,(%rcx,%rax,1)
 10891e8:	vmovdqu64 %zmm0,0x4(%rcx,%rax,1)
 10891f3:	vmovdqu64 %zmm0,0x20(%rcx,%rax,1)
 10891fe:	cmpl   $0xffffffff,0x10(%r14)
 1089203:	je     1088c90 <check_input_expressions+0x70>
 1089209:	mov    (%r12),%r13
 108920d:	jmp    1088e88 <check_input_expressions+0x268>
 1089212:	mov    0x230(%r12),%rax
 108921a:	mov    $0x1,%r13b
 108921d:	mov    %edx,0x40(%rsp)
 1089221:	cmpl   $0x0,(%rax,%r14,4)
 1089226:	je     108935e <check_input_expressions+0x73e>
 108922c:	mov    $0x38,%eax
 1089231:	movl   $0x0,0x38(%rsp)
 1089239:	mov    $0xffffffff,%ecx
 108923e:	cmp    $0x45,%eax
 1089241:	je     108ba10 <check_input_expressions+0x2df0>
 1089247:	test   %r13b,%r13b
 108924a:	je     108ba10 <check_input_expressions+0x2df0>
 1089250:	mov    %rax,0x30(%rsp)
 1089255:	mov    %r13d,0x60(%rsp)
 108925a:	mov    %esi,0x20(%rsp)
 108925e:	cmp    $0x1f,%eax
 1089261:	jne    108b0ea <check_input_expressions+0x24ca>
 1089267:	mov    0xa8(%r12),%rax
 108926f:	mov    %edx,%ecx
 1089271:	mov    %r8d,%r13d
 1089274:	cmpl   $0x0,(%rax,%r14,4)
 1089279:	setne  %al
 108927c:	xor    $0x1,%cl
 108927f:	or     %al,%cl
 1089281:	jne    108b3d0 <check_input_expressions+0x27b0>
 1089287:	mov    0x70(%rsp),%rax
 108928c:	mov    %r13d,%ecx
 108928f:	mov    0x8(%rax),%rax
 1089293:	mov    (%rax,%rcx,4),%eax
 1089296:	mov    0x78(%rsp),%rcx
 108929b:	mov    (%rcx),%ecx
 108929d:	cmp    %ecx,%eax
 108929f:	jae    108b3d0 <check_input_expressions+0x27b0>
 10892a5:	mov    (%r12),%rdx
 10892a9:	mov    0x238(%rdx),%rsi
 10892b0:	mov    (%rsi,%rax,4),%eax
 10892b3:	cmp    %ecx,%eax
 10892b5:	jae    108b3d0 <check_input_expressions+0x27b0>
 10892bb:	mov    0x288(%rdx),%rcx
 10892c2:	mov    (%rcx,%rax,8),%rcx
 10892c6:	test   %rcx,%rcx
 10892c9:	je     108b3d0 <check_input_expressions+0x27b0>
 10892cf:	movzbl 0x1c(%rcx),%r8d
 10892d4:	test   %r8d,%r8d
 10892d7:	je     108b3d0 <check_input_expressions+0x27b0>
 10892dd:	mov    0xa0(%r12),%rcx
 10892e5:	mov    0x18(%r12),%rdi
 10892ea:	dec    %r8d
 10892ed:	mov    $0xf,%esi
 10892f2:	mov    %r10d,0x28(%rsp)
 10892f7:	mov    (%rcx,%rax,4),%ecx
 10892fa:	mov    0x18(%rdi),%rax
 10892fe:	mov    %ecx,%edx
 1089300:	shr    $0x3,%edx
 1089303:	movzbl (%rax,%rdx,1),%eax
 1089307:	cmp    %eax,%r8d
 108930a:	cmovbe %eax,%r8d
 108930e:	xor    %edx,%edx
 1089310:	vzeroupper
 1089313:	call   10a1840 <type_derive>
 1089318:	test   %eax,%eax
 108931a:	jne    1089335 <check_input_expressions+0x715>
 108931c:	mov    0x18(%r12),%rcx
 1089321:	cmpl   $0x1,0x100(%rcx)
 1089328:	jne    1089335 <check_input_expressions+0x715>
 108932a:	mov    (%r12),%rcx
 108932e:	movb   $0x1,0x3bd(%rcx)
 1089335:	mov    0xa8(%r12),%rcx
 108933d:	mov    0x28(%rsp),%r10d
 1089342:	mov    %eax,(%rcx,%r14,4)
 1089346:	jmp    108b3d0 <check_input_expressions+0x27b0>
 108934b:	mov    (%r12),%rax
 108934f:	movb   $0x1,0x3bd(%rax)
 1089356:	xor    %r14d,%r14d
 1089359:	jmp    1089449 <check_input_expressions+0x829>
 108935e:	mov    0x190(%r12),%rax
 1089366:	mov    (%rax,%r14,4),%ebx
 108936a:	test   %ebx,%ebx
 108936c:	je     108b107 <check_input_expressions+0x24e7>
 1089372:	mov    $0xffffffff,%ecx
 1089377:	mov    $0xffffffff,%r8d
 108937d:	mov    $0xffffffff,%r9d
 1089383:	mov    %r12,%rdi
 1089386:	xor    %esi,%esi
 1089388:	mov    %r14d,%edx
 108938b:	vzeroupper
 108938e:	call   10facf0 <check_input_add>
 1089393:	vpmovsxbq -0xbeb79c(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108939c:	mov    0x18(%rsp),%r9
 10893a1:	mov    $0xffffffff,%r11d
 10893a7:	vxorps %xmm2,%xmm2,%xmm2
 10893ab:	cmp    $0xffffffff,%eax
 10893ae:	je     1088c90 <check_input_expressions+0x70>
 10893b4:	mov    0x70(%rsp),%rcx
 10893b9:	mov    0x180(%r12),%rdx
 10893c1:	vpmovsxbd -0xadd7e2(%rip),%xmm0        # 5abbe8 <link_program_emit_worker.forms+0x3d8>
 10893ca:	dec    %ebx
 10893cc:	mov    %eax,%r15d
 10893cf:	mov    0x28(%rcx),%rax
 10893d3:	mov    (%rdx,%rbx,8),%rdx
 10893d7:	mov    %r15d,%ecx
 10893da:	lea    (%rcx,%rcx,2),%rcx
 10893de:	shl    $0x5,%rcx
 10893e2:	vmovdqa %xmm0,(%rax,%rcx,1)
 10893e7:	mov    %rdx,0x10(%rax,%rcx,1)
 10893ec:	movq   $0x0,0x18(%rax,%rcx,1)
 10893f5:	fldz
 10893f7:	fld    %st(0)
 10893f9:	fstpt  0x20(%rax,%rcx,1)
 10893fd:	fstpt  0x30(%rax,%rcx,1)
 1089401:	vpxor  %xmm0,%xmm0,%xmm0
 1089405:	vmovdqu %ymm0,0x40(%rax,%rcx,1)
 108940b:	jmp    108dc87 <check_input_expressions+0x5067>
 1089410:	movb   $0x1,0x158(%rsp)
 1089418:	lea    0x110(%rsp),%rdi
 1089420:	mov    $0xffffffff,%ecx
 1089425:	mov    $0xffffffff,%r8d
 108942b:	mov    %edx,%esi
 108942d:	vzeroupper
 1089430:	call   10fb540 <check_region_input_children>
 1089435:	vpmovsxbq -0xbeb83e(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108943e:	vxorps %xmm2,%xmm2,%xmm2
 1089442:	mov    0x14c(%rsp),%edx
 1089449:	test   %edx,%edx
 108944b:	je     10897b3 <check_input_expressions+0xb93>
 1089451:	mov    (%r12),%rsi
 1089455:	cmpb   $0x0,0x3bd(%rsi)
 108945c:	jne    10897b0 <check_input_expressions+0xb90>
 1089462:	mov    0x120(%rsp),%rdi
 108946a:	mov    %edx,%eax
 108946c:	dec    %eax
 108946e:	mov    %rax,%rcx
 1089471:	mov    %eax,0x14c(%rsp)
 1089478:	shl    $0x5,%rcx
 108947c:	mov    0x50(%r15),%r8
 1089480:	mov    0x4(%rdi,%rcx,1),%edx
 1089484:	movzbl (%r8,%rdx,1),%edi
 1089489:	lea    -0x1f(%rdi),%r8d
 108948d:	cmp    $0x2d,%r8d
 1089491:	ja     10895d0 <check_input_expressions+0x9b0>
 1089497:	movabs $0x200000000003,%r9
 10894a1:	bt     %r8,%r9
 10894a5:	jae    10895d0 <check_input_expressions+0x9b0>
 10894ab:	mov    0x110(%rsp),%rsi
 10894b3:	mov    0x370(%rsi),%rdi
 10894ba:	mov    (%rdi,%rdx,4),%edx
 10894bd:	cmp    $0xffffffff,%edx
 10894c0:	jne    1089514 <check_input_expressions+0x8f4>
 10894c2:	jmp    1089442 <check_input_expressions+0x822>
 10894c7:	nopw   0x0(%rax,%rax,1)
 10894d0:	mov    0x120(%rsp),%r9
 10894d8:	lea    0x1(%r8),%r10d
 10894dc:	shl    $0x5,%r8
 10894e0:	mov    %r10d,0x14c(%rsp)
 10894e8:	movl   $0x0,(%r9,%r8,1)
 10894f0:	mov    %edx,0x4(%r9,%r8,1)
 10894f5:	movq   $0xffffffffffffffff,0x8(%r9,%r8,1)
 10894fe:	vmovups %xmm2,0x10(%r9,%r8,1)
 1089505:	mov    0x378(%rsi),%rdx
 108950c:	mov    (%rdx,%rdi,4),%edx
 108950f:	cmp    $0xffffffff,%edx
 1089512:	je     1089560 <check_input_expressions+0x940>
 1089514:	mov    0x8(%rsi),%rdi
 1089518:	mov    0x50(%rdi),%r8
 108951c:	mov    %edx,%edi
 108951e:	movzbl (%r8,%rdi,1),%r8d
 1089523:	add    $0xcd,%r8b
 1089527:	cmp    $0x2,%r8b
 108952b:	jb     1089505 <check_input_expressions+0x8e5>
 108952d:	mov    0x14c(%rsp),%r8d
 1089535:	cmp    0x154(%rsp),%r8d
 108953d:	jb     10894d0 <check_input_expressions+0x8b0>
 108953f:	mov    0x110(%rsp),%rdx
 1089547:	mov    (%rdx),%rdx
 108954a:	movb   $0x1,0x3bd(%rdx)
 1089551:	jmp    1089505 <check_input_expressions+0x8e5>
 1089553:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1089560:	mov    0x14c(%rsp),%edx
 1089567:	cmp    %edx,%eax
 1089569:	jae    1089449 <check_input_expressions+0x829>
 108956f:	mov    %rdx,%rsi
 1089572:	shl    $0x5,%rsi
 1089576:	dec    %rdx
 1089579:	add    $0xffffffffffffffe0,%rsi
 108957d:	nopl   (%rax)
 1089580:	cmp    %rdx,%rax
 1089583:	jae    1089442 <check_input_expressions+0x822>
 1089589:	mov    0x120(%rsp),%rdi
 1089591:	inc    %rax
 1089594:	vmovups (%rdi,%rcx,1),%ymm0
 1089599:	vmovups %ymm0,0xf0(%rsp)
 10895a2:	vmovups (%rdi,%rsi,1),%ymm0
 10895a7:	vmovups %ymm0,(%rdi,%rcx,1)
 10895ac:	add    $0x20,%rcx
 10895b0:	vmovdqu 0xf0(%rsp),%ymm0
 10895b9:	vmovdqu %ymm0,(%rdi,%rsi,1)
 10895be:	add    $0xffffffffffffffe0,%rsi
 10895c2:	cmp    %rdx,%rax
 10895c5:	lea    -0x1(%rdx),%rdx
 10895c9:	jb     1089580 <check_input_expressions+0x960>
 10895cb:	jmp    1089442 <check_input_expressions+0x822>
 10895d0:	lea    -0x49(%rdi),%eax
 10895d3:	cmp    $0x1,%al
 10895d5:	ja     1089636 <check_input_expressions+0xa16>
 10895d7:	cmp    $0x49,%edi
 10895da:	jne    1089418 <check_input_expressions+0x7f8>
 10895e0:	mov    0x110(%rsp),%rax
 10895e8:	mov    0x370(%rax),%rcx
 10895ef:	mov    (%rcx,%rdx,4),%edi
 10895f2:	cmp    $0xffffffff,%edi
 10895f5:	je     1089418 <check_input_expressions+0x7f8>
 10895fb:	mov    0x378(%rax),%rsi
 1089602:	mov    $0xffffffff,%ecx
 1089607:	jmp    108961d <check_input_expressions+0x9fd>
 1089609:	nopl   0x0(%rax)
 1089610:	mov    (%rsi,%r8,4),%edi
 1089614:	cmp    $0xffffffff,%edi
 1089617:	je     10896d4 <check_input_expressions+0xab4>
 108961d:	mov    %edi,%r8d
 1089620:	cmp    %edx,%edi
 1089622:	jae    1089610 <check_input_expressions+0x9f0>
 1089624:	mov    0x8(%rax),%r9
 1089628:	mov    0x50(%r9),%r9
 108962c:	cmpb   $0x6,(%r9,%r8,1)
 1089631:	cmove  %edi,%ecx
 1089634:	jmp    1089610 <check_input_expressions+0x9f0>
 1089636:	cmp    $0x53,%edi
 1089639:	je     1089707 <check_input_expressions+0xae7>
 108963f:	cmp    $0x21,%edi
 1089642:	je     1089418 <check_input_expressions+0x7f8>
 1089648:	cmp    $0x1e,%edi
 108964b:	jne    1089442 <check_input_expressions+0x822>
 1089651:	mov    0x370(%r12),%rax
 1089659:	mov    (%rax,%rdx,4),%eax
 108965c:	jmp    108967d <check_input_expressions+0xa5d>
 108965e:	xchg   %ax,%ax
 1089660:	mov    0x110(%rsp),%rax
 1089668:	mov    (%rax),%rax
 108966b:	movb   $0x1,0x3bd(%rax)
 1089672:	mov    0x378(%r12),%rax
 108967a:	mov    (%rax,%rcx,4),%eax
 108967d:	cmp    $0xffffffff,%eax
 1089680:	je     1089442 <check_input_expressions+0x822>
 1089686:	mov    0x50(%r15),%rdx
 108968a:	mov    %eax,%ecx
 108968c:	cmpb   $0x20,(%rdx,%rcx,1)
 1089690:	jne    1089672 <check_input_expressions+0xa52>
 1089692:	mov    0x14c(%rsp),%edx
 1089699:	cmp    0x154(%rsp),%edx
 10896a0:	jae    1089660 <check_input_expressions+0xa40>
 10896a2:	mov    0x120(%rsp),%rsi
 10896aa:	lea    0x1(%rdx),%edi
 10896ad:	shl    $0x5,%rdx
 10896b1:	mov    %edi,0x14c(%rsp)
 10896b8:	movl   $0x0,(%rsi,%rdx,1)
 10896bf:	mov    %eax,0x4(%rsi,%rdx,1)
 10896c3:	movq   $0xffffffffffffffff,0x8(%rsi,%rdx,1)
 10896cc:	vmovups %xmm2,0x10(%rsi,%rdx,1)
 10896d2:	jmp    1089672 <check_input_expressions+0xa52>
 10896d4:	cmp    $0xffffffff,%ecx
 10896d7:	je     1089418 <check_input_expressions+0x7f8>
 10896dd:	mov    0x10(%r15),%rax
 10896e1:	mov    %ecx,%ecx
 10896e3:	cmpb   $0x49,(%rax,%rcx,1)
 10896e7:	jne    1089418 <check_input_expressions+0x7f8>
 10896ed:	mov    %edx,%ecx
 10896ef:	mov    0x138(%rsp),%rax
 10896f7:	sub    0x30(%rsp),%ecx
 10896fb:	movl   $0xffffffff,(%rax,%rcx,4)
 1089702:	jmp    1089418 <check_input_expressions+0x7f8>
 1089707:	mov    0x2f8(%rsi),%rax
 108970e:	mov    (%rax,%rdx,4),%ecx
 1089711:	mov    %ecx,%eax
 1089713:	sub    0x30(%rsp),%eax
 1089717:	jbe    1089410 <check_input_expressions+0x7f0>
 108971d:	mov    0x118(%rsp),%rdi
 1089725:	cmp    0x4(%rdi),%ecx
 1089728:	jae    1089410 <check_input_expressions+0x7f0>
 108972e:	mov    0x308(%rsi),%rcx
 1089735:	cmpl   $0xffffffff,(%rcx,%rdx,4)
 1089739:	jne    1089410 <check_input_expressions+0x7f0>
 108973f:	mov    0x150(%rsp),%ecx
 1089746:	cmp    0x154(%rsp),%ecx
 108974d:	jae    1089767 <check_input_expressions+0xb47>
 108974f:	mov    0x128(%rsp),%rsi
 1089757:	movl   $0xffffffff,(%rsi,%rcx,4)
 108975e:	incl   0x150(%rsp)
 1089765:	jmp    1089779 <check_input_expressions+0xb59>
 1089767:	mov    0x110(%rsp),%rsi
 108976f:	mov    (%rsi),%rsi
 1089772:	movb   $0x1,0x3bd(%rsi)
 1089779:	mov    %edx,%edi
 108977b:	mov    0x130(%rsp),%rsi
 1089783:	sub    0x30(%rsp),%edi
 1089787:	mov    %ecx,(%rsi,%rdi,4)
 108978a:	mov    0x138(%rsp),%rcx
 1089792:	mov    0x140(%rsp),%rsi
 108979a:	mov    (%rcx,%rax,4),%ecx
 108979d:	mov    %ecx,(%rsi,%rdi,4)
 10897a0:	mov    0x138(%rsp),%rcx
 10897a8:	mov    %edx,(%rcx,%rax,4)
 10897ab:	jmp    1089418 <check_input_expressions+0x7f8>
 10897b0:	mov    %edx,%r14d
 10897b3:	cmp    0x154(%rsp),%r14d
 10897bb:	jae    10897f6 <check_input_expressions+0xbd6>
 10897bd:	vmovdqa -0xb0d025(%rip),%ymm0        # 57c7a0 <static_test_starved.starved+0xd80>
 10897c5:	mov    0x120(%rsp),%rax
 10897cd:	lea    0x1(%r14),%ecx
 10897d1:	mov    %ecx,0x14c(%rsp)
 10897d8:	mov    %r14d,%ecx
 10897db:	shl    $0x5,%rcx
 10897df:	vmovdqu %ymm0,(%rax,%rcx,1)
 10897e4:	mov    0x14c(%rsp),%r14d
 10897ec:	mov    0x8(%rbx),%eax
 10897ef:	cmp    $0xffffffff,%eax
 10897f2:	jne    1089810 <check_input_expressions+0xbf0>
 10897f4:	jmp    108986a <check_input_expressions+0xc4a>
 10897f6:	mov    0x110(%rsp),%rax
 10897fe:	mov    (%rax),%rax
 1089801:	movb   $0x1,0x3bd(%rax)
 1089808:	mov    0x8(%rbx),%eax
 108980b:	cmp    $0xffffffff,%eax
 108980e:	je     108986a <check_input_expressions+0xc4a>
 1089810:	cmp    0x154(%rsp),%r14d
 1089818:	jae    1089858 <check_input_expressions+0xc38>
 108981a:	vpmovsxbq -0xbebc21(%rip),%xmm0        # 49dc02 <cbuiltin_test_generated.edges+0x3dc2>
 1089823:	mov    0x120(%rsp),%rcx
 108982b:	lea    0x1(%r14),%edx
 108982f:	mov    %edx,0x14c(%rsp)
 1089836:	mov    %r14d,%edx
 1089839:	shl    $0x5,%rdx
 108983d:	vpinsrd $0x1,%eax,%xmm0,%xmm0
 1089843:	vmovdqu %xmm0,(%rcx,%rdx,1)
 1089848:	vmovups %xmm2,0x10(%rcx,%rdx,1)
 108984e:	mov    0x14c(%rsp),%r14d
 1089856:	jmp    108986a <check_input_expressions+0xc4a>
 1089858:	mov    0x110(%rsp),%rax
 1089860:	mov    (%rax),%rax
 1089863:	movb   $0x1,0x3bd(%rax)
 108986a:	movzbl 0x158(%rsp),%eax
 1089872:	test   %r14d,%r14d
 1089875:	mov    %rbx,0x30(%rsp)
 108987a:	sete   %cl
 108987d:	or     %al,%cl
 108987f:	test   $0x1,%cl
 1089882:	je     10898e0 <check_input_expressions+0xcc0>
 1089884:	test   $0x1,%al
 1089886:	je     108af3b <check_input_expressions+0x231b>
 108988c:	mov    (%r12),%rax
 1089890:	cmpb   $0x0,0x3bd(%rax)
 1089897:	jne    108af3b <check_input_expressions+0x231b>
 108989d:	mov    0x148(%rsp),%eax
 10898a4:	mov    %eax,0x138(%r13)
 10898ab:	cmp    0x13c(%r13),%eax
 10898b2:	jae    108af30 <check_input_expressions+0x2310>
 10898b8:	vpmovsxbd -0xaddcd5(%rip),%xmm0        # 5abbec <link_program_emit_worker.forms+0x3dc>
 10898c1:	mov    0x130(%r13),%rcx
 10898c8:	lea    0x1(%rax),%edx
 10898cb:	shl    $0x4,%rax
 10898cf:	mov    %edx,0x138(%r13)
 10898d6:	vmovdqu %xmm0,(%rcx,%rax,1)
 10898db:	jmp    108af3b <check_input_expressions+0x231b>
 10898e0:	mov    (%r12),%rcx
 10898e4:	cmpb   $0x0,0x3bd(%rcx)
 10898eb:	jne    108af3b <check_input_expressions+0x231b>
 10898f1:	mov    0x120(%rsp),%rax
 10898f9:	lea    -0x1(%r14),%edx
 10898fd:	mov    %rdx,%rsi
 1089900:	mov    %edx,0x14c(%rsp)
 1089907:	shl    $0x5,%rsi
 108990b:	mov    (%rax,%rsi,1),%edi
 108990e:	cmp    $0x3,%rdi
 1089912:	ja     108aef0 <check_input_expressions+0x22d0>
 1089918:	lea    -0xbebd1b(%rip),%r9        # 49dc04 <cbuiltin_test_generated.edges+0x3dc4>
 108991f:	mov    0x4(%rax,%rsi,1),%r8d
 1089924:	movslq (%r9,%rdi,4),%rdi
 1089928:	add    %r9,%rdi
 108992b:	jmp    *%rdi
 108992d:	mov    0x110(%rsp),%r10
 1089935:	mov    %r8,0x50(%rsp)
 108993a:	mov    0x8(%r10),%rcx
 108993e:	mov    0x50(%rcx),%r11
 1089942:	mov    %rcx,0x40(%rsp)
 1089947:	movzbl (%r11,%r8,1),%ebx
 108994c:	lea    -0x1e(%rbx),%edi
 108994f:	cmp    $0x35,%edi
 1089952:	ja     108aef0 <check_input_expressions+0x22d0>
 1089958:	lea    -0xbebd4b(%rip),%rcx        # 49dc14 <cbuiltin_test_generated.edges+0x3dd4>
 108995f:	mov    0x8(%rax,%rsi,1),%r8
 1089964:	mov    (%r10),%r15
 1089967:	mov    %r10,0x38(%rsp)
 108996c:	movslq (%rcx,%rdi,4),%rdi
 1089970:	vmovq  %r8,%xmm0
 1089975:	shr    $0x20,%r8
 1089979:	add    %rcx,%rdi
 108997c:	jmp    *%rdi
 108997e:	mov    0x370(%r10),%rax
 1089985:	mov    0x50(%rsp),%rcx
 108998a:	mov    (%rax,%rcx,4),%eax
 108998d:	cmp    $0xffffffff,%eax
 1089990:	jne    10899e6 <check_input_expressions+0xdc6>
 1089992:	jmp    108aef0 <check_input_expressions+0x22d0>
 1089997:	nopw   0x0(%rax,%rax,1)
 10899a0:	mov    0x120(%rsp),%r8
 10899a8:	lea    0x1(%rdi),%r9d
 10899ac:	shl    $0x5,%rdi
 10899b0:	mov    %r9d,0x14c(%rsp)
 10899b8:	movl   $0x0,(%r8,%rdi,1)
 10899c0:	mov    %eax,0x4(%r8,%rdi,1)
 10899c5:	vmovq  %xmm0,0x8(%r8,%rdi,1)
 10899cc:	vmovups %xmm2,0x10(%r8,%rdi,1)
 10899d3:	mov    0x378(%r10),%rax
 10899da:	mov    (%rax,%rsi,4),%eax
 10899dd:	cmp    $0xffffffff,%eax
 10899e0:	je     1089c93 <check_input_expressions+0x1073>
 10899e6:	mov    0x8(%r10),%rsi
 10899ea:	mov    0x50(%rsi),%rdi
 10899ee:	mov    %eax,%esi
 10899f0:	movzbl (%rdi,%rsi,1),%edi
 10899f4:	add    $0xcd,%dil
 10899f8:	cmp    $0x2,%dil
 10899fc:	jb     10899d3 <check_input_expressions+0xdb3>
 10899fe:	mov    0x14c(%rsp),%edi
 1089a05:	cmp    0x154(%rsp),%edi
 1089a0c:	jb     10899a0 <check_input_expressions+0xd80>
 1089a0e:	mov    0x110(%rsp),%rax
 1089a16:	mov    (%rax),%rax
 1089a19:	movb   $0x1,0x3bd(%rax)
 1089a20:	jmp    10899d3 <check_input_expressions+0xdb3>
 1089a22:	mov    0x138(%r13),%edx
 1089a29:	cmp    0x13c(%r13),%edx
 1089a30:	jae    1089b86 <check_input_expressions+0xf66>
 1089a36:	vmovdqu 0x10(%rax,%rsi,1),%xmm0
 1089a3c:	mov    0x130(%r13),%rax
 1089a43:	lea    0x1(%rdx),%ecx
 1089a46:	shl    $0x4,%rdx
 1089a4a:	mov    %ecx,0x138(%r13)
 1089a51:	vmovdqu %xmm0,(%rax,%rdx,1)
 1089a56:	jmp    108aef0 <check_input_expressions+0x22d0>
 1089a5b:	mov    0x138(%r13),%eax
 1089a62:	mov    0x128(%rsp),%rcx
 1089a6a:	sub    0x148(%rsp),%eax
 1089a71:	mov    %eax,(%rcx,%r8,4)
 1089a75:	jmp    108aef0 <check_input_expressions+0x22d0>
 1089a7a:	mov    0x30(%rsp),%rax
 1089a7f:	cmp    0x14(%rax),%r8d
 1089a83:	je     108aef0 <check_input_expressions+0x22d0>
 1089a89:	mov    0x278(%r12),%rax
 1089a91:	mov    (%rax,%r8,4),%eax
 1089a95:	cmp    $0xffffffff,%eax
 1089a98:	je     108aef0 <check_input_expressions+0x22d0>
 1089a9e:	mov    $0xffffffff,%r10d
 1089aa4:	jmp    1089ad8 <check_input_expressions+0xeb8>
 1089aa6:	cs nopw 0x0(%rax,%rax,1)
 1089ab0:	mov    0x110(%rsp),%rcx
 1089ab8:	mov    (%rcx),%rcx
 1089abb:	movb   $0x1,0x3bd(%rcx)
 1089ac2:	mov    0x390(%r12),%rcx
 1089aca:	mov    %eax,%eax
 1089acc:	mov    (%rcx,%rax,4),%eax
 1089acf:	cmp    $0xffffffff,%eax
 1089ad2:	je     1089b92 <check_input_expressions+0xf72>
 1089ad8:	mov    0x0(%r13),%r8
 1089adc:	mov    %eax,%ecx
 1089ade:	jmp    1089ae7 <check_input_expressions+0xec7>
 1089ae0:	mov    0x10(%r13),%rdi
 1089ae4:	mov    (%rdi,%rcx,4),%ecx
 1089ae7:	mov    %ecx,%ecx
 1089ae9:	mov    (%r8,%rcx,4),%edi
 1089aed:	cmp    $0x24,%edi
 1089af0:	je     1089ae0 <check_input_expressions+0xec0>
 1089af2:	cmp    $0x18,%edi
 1089af5:	je     1089ae0 <check_input_expressions+0xec0>
 1089af7:	cmp    $0x23,%edi
 1089afa:	jne    1089b30 <check_input_expressions+0xf10>
 1089afc:	mov    0x8(%r13),%r9
 1089b00:	mov    0x150(%r12),%r8
 1089b08:	mov    (%r9,%rcx,4),%r9d
 1089b0c:	mov    (%r8,%r9,4),%r8d
 1089b10:	cmp    %r10,%r8
 1089b13:	je     1089b30 <check_input_expressions+0xf10>
 1089b15:	mov    0x118(%r12),%r9
 1089b1d:	cmpb   $0x0,(%r9,%r8,1)
 1089b22:	jne    1089ac2 <check_input_expressions+0xea2>
 1089b24:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1089b30:	mov    0x14c(%rsp),%r8d
 1089b38:	cmp    0x154(%rsp),%r8d
 1089b40:	jae    1089ab0 <check_input_expressions+0xe90>
 1089b46:	mov    0x120(%rsp),%r11
 1089b4e:	cmp    $0x23,%edi
 1089b51:	lea    0x1(%r8),%r9d
 1089b55:	cmovne %eax,%ecx
 1089b58:	shl    $0x5,%r8
 1089b5c:	mov    %r9d,0x14c(%rsp)
 1089b64:	movl   $0x2,(%r11,%r8,1)
 1089b6c:	vmovups %xmm2,0x4(%r11,%r8,1)
 1089b73:	mov    %ecx,0x14(%r11,%r8,1)
 1089b78:	movq   $0xffffffffffffffff,0x18(%r11,%r8,1)
 1089b81:	jmp    1089ac2 <check_input_expressions+0xea2>
 1089b86:	movb   $0x1,0x3bd(%rcx)
 1089b8d:	jmp    108aef0 <check_input_expressions+0x22d0>
 1089b92:	mov    0x14c(%rsp),%eax
 1089b99:	cmp    %eax,%edx
 1089b9b:	jae    108aef0 <check_input_expressions+0x22d0>
 1089ba1:	mov    %rax,%rcx
 1089ba4:	shl    $0x5,%rcx
 1089ba8:	add    $0xffffffffffffffe0,%rcx
 1089bac:	nopl   0x0(%rax)
 1089bb0:	dec    %rax
 1089bb3:	cmp    %rax,%rdx
 1089bb6:	jae    108aef0 <check_input_expressions+0x22d0>
 1089bbc:	mov    0x120(%rsp),%rdi
 1089bc4:	inc    %rdx
 1089bc7:	vmovups (%rdi,%rsi,1),%ymm0
 1089bcc:	vmovups %ymm0,0xf0(%rsp)
 1089bd5:	vmovups (%rdi,%rcx,1),%ymm0
 1089bda:	vmovups %ymm0,(%rdi,%rsi,1)
 1089bdf:	add    $0x20,%rsi
 1089be3:	vmovdqu 0xf0(%rsp),%ymm0
 1089bec:	vmovdqu %ymm0,(%rdi,%rcx,1)
 1089bf1:	add    $0xffffffffffffffe0,%rcx
 1089bf5:	cmp    %rax,%rdx
 1089bf8:	jb     1089bb0 <check_input_expressions+0xf90>
 1089bfa:	jmp    108aef0 <check_input_expressions+0x22d0>
 1089bff:	mov    0x50(%rsp),%rdx
 1089c04:	vmovd  %xmm0,%ecx
 1089c08:	lea    0x110(%rsp),%rdi
 1089c10:	mov    %edx,%esi
 1089c12:	vzeroupper
 1089c15:	call   10fb540 <check_region_input_children>
 1089c1a:	vpmovsxbq -0xbec023(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 1089c23:	vxorps %xmm2,%xmm2,%xmm2
 1089c27:	cmp    $0x53,%bl
 1089c2a:	jne    108aef0 <check_input_expressions+0x22d0>
 1089c30:	mov    0x14c(%rsp),%eax
 1089c37:	cmp    0x154(%rsp),%eax
 1089c3e:	jae    108aed5 <check_input_expressions+0x22b5>
 1089c44:	mov    0x118(%rsp),%rdx
 1089c4c:	mov    0x50(%rsp),%rdi
 1089c51:	mov    0x130(%rsp),%rcx
 1089c59:	mov    0x120(%rsp),%rsi
 1089c61:	sub    (%rdx),%edi
 1089c63:	lea    0x1(%rax),%edx
 1089c66:	shl    $0x5,%rax
 1089c6a:	mov    (%rcx,%rdi,4),%ecx
 1089c6d:	mov    %edx,0x14c(%rsp)
 1089c74:	movl   $0x3,(%rsi,%rax,1)
 1089c7b:	mov    %ecx,0x4(%rsi,%rax,1)
 1089c7f:	vmovups %xmm2,0x8(%rsi,%rax,1)
 1089c85:	movq   $0x0,0x18(%rsi,%rax,1)
 1089c8e:	jmp    108aef0 <check_input_expressions+0x22d0>
 1089c93:	mov    0x14c(%rsp),%eax
 1089c9a:	cmp    %eax,%edx
 1089c9c:	jae    108aef0 <check_input_expressions+0x22d0>
 1089ca2:	mov    %rax,%rsi
 1089ca5:	shl    $0x5,%rsi
 1089ca9:	mov    %rdx,%rcx
 1089cac:	shl    $0x5,%rcx
 1089cb0:	dec    %rax
 1089cb3:	add    $0xffffffffffffffe0,%rsi
 1089cb7:	nopw   0x0(%rax,%rax,1)
 1089cc0:	cmp    %rax,%rdx
 1089cc3:	jae    108aef0 <check_input_expressions+0x22d0>
 1089cc9:	mov    0x120(%rsp),%rdi
 1089cd1:	inc    %rdx
 1089cd4:	vmovups (%rdi,%rcx,1),%ymm0
 1089cd9:	vmovups %ymm0,0xf0(%rsp)
 1089ce2:	vmovups (%rdi,%rsi,1),%ymm0
 1089ce7:	vmovups %ymm0,(%rdi,%rcx,1)
 1089cec:	add    $0x20,%rcx
 1089cf0:	vmovdqu 0xf0(%rsp),%ymm0
 1089cf9:	vmovdqu %ymm0,(%rdi,%rsi,1)
 1089cfe:	add    $0xffffffffffffffe0,%rsi
 1089d02:	cmp    %rax,%rdx
 1089d05:	lea    -0x1(%rax),%rax
 1089d09:	jb     1089cc0 <check_input_expressions+0x10a0>
 1089d0b:	jmp    108aef0 <check_input_expressions+0x22d0>
 1089d10:	mov    0x370(%r10),%rax
 1089d17:	mov    0x50(%rsp),%rbx
 1089d1c:	mov    (%rax,%rbx,4),%esi
 1089d1f:	cmp    $0xffffffff,%esi
 1089d22:	je     1089f88 <check_input_expressions+0x1368>
 1089d28:	mov    0x378(%r10),%rcx
 1089d2f:	mov    $0xffffffff,%edx
 1089d34:	mov    $0xffffffff,%r10d
 1089d3a:	mov    %esi,%edi
 1089d3c:	jmp    1089d4c <check_input_expressions+0x112c>
 1089d3e:	xchg   %ax,%ax
 1089d40:	mov    (%rcx,%rax,4),%edi
 1089d43:	cmp    $0xffffffff,%edi
 1089d46:	je     1089f5e <check_input_expressions+0x133e>
 1089d4c:	mov    %edi,%eax
 1089d4e:	cmp    %ebx,%edi
 1089d50:	jbe    1089d40 <check_input_expressions+0x1120>
 1089d52:	cmpb   $0x1f,(%r11,%rax,1)
 1089d57:	cmove  %eax,%r10d
 1089d5b:	cmovne %eax,%edx
 1089d5e:	jmp    1089d40 <check_input_expressions+0x1120>
 1089d60:	mov    0x370(%r10),%rax
 1089d67:	mov    0x50(%rsp),%r11
 1089d6c:	mov    (%rax,%r11,4),%edi
 1089d70:	cmp    $0xffffffff,%edi
 1089d73:	je     108a055 <check_input_expressions+0x1435>
 1089d79:	mov    0x378(%r10),%rax
 1089d80:	mov    0x40(%rsp),%rbx
 1089d85:	mov    $0xffffffff,%edx
 1089d8a:	mov    $0xffffffff,%esi
 1089d8f:	mov    $0xffffffff,%r8d
 1089d95:	jmp    1089db2 <check_input_expressions+0x1192>
 1089d97:	nopw   0x0(%rax,%rax,1)
 1089da0:	cmp    $0xffffffff,%edx
 1089da3:	cmovne %edi,%esi
 1089da6:	cmove  %edi,%edx
 1089da9:	mov    (%rax,%r9,4),%edi
 1089dad:	cmp    $0xffffffff,%edi
 1089db0:	je     1089de3 <check_input_expressions+0x11c3>
 1089db2:	cmp    %r11d,%edi
 1089db5:	jae    1089dd0 <check_input_expressions+0x11b0>
 1089db7:	mov    0x10(%rbx),%r10
 1089dbb:	mov    %edi,%r9d
 1089dbe:	cmpb   $0x30,(%r10,%r9,1)
 1089dc3:	jne    1089dd3 <check_input_expressions+0x11b3>
 1089dc5:	jmp    1089da0 <check_input_expressions+0x1180>
 1089dc7:	nopw   0x0(%rax,%rax,1)
 1089dd0:	mov    %edi,%r9d
 1089dd3:	cmp    %r11d,%edi
 1089dd6:	cmova  %edi,%r8d
 1089dda:	mov    (%rax,%r9,4),%edi
 1089dde:	cmp    $0xffffffff,%edi
 1089de1:	jne    1089db2 <check_input_expressions+0x1192>
 1089de3:	cmp    $0xffffffff,%edx
 1089de6:	je     108a055 <check_input_expressions+0x1435>
 1089dec:	cmp    $0xffffffff,%esi
 1089def:	je     108a055 <check_input_expressions+0x1435>
 1089df5:	cmp    $0xffffffff,%r8d
 1089df9:	je     108a055 <check_input_expressions+0x1435>
 1089dff:	mov    0x150(%rsp),%edi
 1089e06:	mov    0x154(%rsp),%r11d
 1089e0e:	cmp    %r11d,%edi
 1089e11:	jae    108a10a <check_input_expressions+0x14ea>
 1089e17:	mov    0x128(%rsp),%rax
 1089e1f:	movl   $0xffffffff,(%rax,%rdi,4)
 1089e26:	mov    0x150(%rsp),%r9d
 1089e2e:	mov    0x154(%rsp),%r11d
 1089e36:	inc    %r9d
 1089e39:	mov    %r9d,0x150(%rsp)
 1089e41:	jmp    108a115 <check_input_expressions+0x14f5>
 1089e46:	mov    0x370(%r10),%rdi
 1089e4d:	mov    0x50(%rsp),%rcx
 1089e52:	mov    %r12,0x20(%rsp)
 1089e57:	lea    (%rax,%rsi,1),%r9
 1089e5b:	mov    (%rdi,%rcx,4),%r12d
 1089e5f:	cmp    $0xffffffff,%r12d
 1089e63:	je     108a062 <check_input_expressions+0x1442>
 1089e69:	mov    %r8,0x60(%rsp)
 1089e6e:	mov    0x378(%r10),%r8
 1089e75:	mov    %r15,0x98(%rsp)
 1089e7d:	mov    $0xffffffff,%r10d
 1089e83:	mov    $0xffffffff,%edi
 1089e88:	mov    $0xffffffff,%r15d
 1089e8e:	xor    %ebx,%ebx
 1089e90:	mov    %r9,0x28(%rsp)
 1089e95:	data16 cs nopw 0x0(%rax,%rax,1)
 1089ea0:	mov    %r12d,%ecx
 1089ea3:	movzbl (%r11,%rcx,1),%r9d
 1089ea8:	cmp    $0x1a,%r9b
 1089eac:	cmove  %r12d,%r15d
 1089eb0:	cmp    $0x20,%r9b
 1089eb4:	cmove  %r12d,%edi
 1089eb8:	cmp    $0x49,%r9b
 1089ebc:	cmove  %r12d,%r10d
 1089ec0:	cmp    $0x47,%r9b
 1089ec4:	sete   %r9b
 1089ec8:	or     %r9b,%bl
 1089ecb:	mov    %bl,0x158(%rsp)
 1089ed2:	mov    (%r8,%rcx,4),%r12d
 1089ed6:	cmp    $0xffffffff,%r12d
 1089eda:	jne    1089ea0 <check_input_expressions+0x1280>
 1089edc:	cmp    $0xffffffff,%r15d
 1089ee0:	je     108a0a5 <check_input_expressions+0x1485>
 1089ee6:	mov    0x40(%rsp),%rax
 1089eeb:	mov    %r15d,%ecx
 1089eee:	mov    0x20(%rsp),%r12
 1089ef3:	vmovd  %xmm0,%esi
 1089ef7:	mov    0x10(%rax),%rax
 1089efb:	movzbl (%rax,%rcx,1),%eax
 1089eff:	mov    0x60(%rsp),%rcx
 1089f04:	cmp    $0x51,%al
 1089f06:	jne    1089f0d <check_input_expressions+0x12ed>
 1089f08:	cmp    $0xffffffff,%esi
 1089f0b:	jne    1089f1e <check_input_expressions+0x12fe>
 1089f0d:	cmp    $0x50,%al
 1089f0f:	jne    108a055 <check_input_expressions+0x1435>
 1089f15:	cmp    $0xffffffff,%ecx
 1089f18:	je     108a055 <check_input_expressions+0x1435>
 1089f1e:	cmp    0x154(%rsp),%edx
 1089f25:	jae    108a400 <check_input_expressions+0x17e0>
 1089f2b:	mov    0x28(%rsp),%rdx
 1089f30:	cmp    $0x51,%al
 1089f32:	movabs $0xffffffff00000003,%rax
 1089f3c:	mov    %r14d,0x14c(%rsp)
 1089f44:	cmove  %esi,%ecx
 1089f47:	vmovups %xmm3,(%rdx)
 1089f4b:	mov    %rax,0x10(%rdx)
 1089f4f:	movl   $0xffffffff,0x18(%rdx)
 1089f56:	mov    %ecx,0x1c(%rdx)
 1089f59:	jmp    108aef0 <check_input_expressions+0x22d0>
 1089f5e:	mov    $0xffffffff,%eax
 1089f63:	jmp    1089f78 <check_input_expressions+0x1358>
 1089f65:	data16 cs nopw 0x0(%rax,%rax,1)
 1089f70:	mov    (%rcx,%rdi,4),%esi
 1089f73:	cmp    $0xffffffff,%esi
 1089f76:	je     1089f98 <check_input_expressions+0x1378>
 1089f78:	mov    %esi,%edi
 1089f7a:	cmp    %ebx,%esi
 1089f7c:	jae    1089f70 <check_input_expressions+0x1350>
 1089f7e:	cmpb   $0x6,(%r11,%rdi,1)
 1089f83:	cmove  %edi,%eax
 1089f86:	jmp    1089f70 <check_input_expressions+0x1350>
 1089f88:	mov    $0xffffffff,%edx
 1089f8d:	mov    $0xffffffff,%r10d
 1089f93:	mov    $0xffffffff,%eax
 1089f98:	mov    0x2c0(%r15),%rcx
 1089f9f:	mov    0x150(%rsp),%esi
 1089fa6:	mov    (%rcx,%rbx,4),%ecx
 1089fa9:	cmp    0x154(%rsp),%esi
 1089fb0:	jae    1089fd3 <check_input_expressions+0x13b3>
 1089fb2:	mov    0x128(%rsp),%rdi
 1089fba:	movl   $0xffffffff,(%rdi,%rsi,4)
 1089fc1:	mov    0x150(%rsp),%edi
 1089fc8:	inc    %edi
 1089fca:	mov    %edi,0x150(%rsp)
 1089fd1:	jmp    1089fdd <check_input_expressions+0x13bd>
 1089fd3:	mov    %esi,%edi
 1089fd5:	movb   $0x1,0x3bd(%r15)
 1089fdd:	cmp    $0xffffffff,%eax
 1089fe0:	je     108a055 <check_input_expressions+0x1435>
 1089fe2:	cmp    $0xffffffff,%ecx
 1089fe5:	je     108a055 <check_input_expressions+0x1435>
 1089fe7:	cmp    $0xffffffff,%edx
 1089fea:	je     108a055 <check_input_expressions+0x1435>
 1089fec:	mov    0x40(%rsp),%r9
 1089ff1:	mov    %eax,%eax
 1089ff3:	mov    0x10(%r9),%r9
 1089ff7:	movzbl (%r9,%rax,1),%eax
 1089ffc:	cmp    $0x4c,%eax
 1089fff:	je     108a55a <check_input_expressions+0x193a>
 108a005:	cmp    $0x49,%eax
 108a008:	je     108a40a <check_input_expressions+0x17ea>
 108a00e:	cmp    $0x47,%eax
 108a011:	jne    108a055 <check_input_expressions+0x1435>
 108a013:	mov    0x154(%rsp),%r8d
 108a01b:	cmp    $0xffffffff,%r10d
 108a01f:	je     108aa4e <check_input_expressions+0x1e2e>
 108a025:	cmp    %r8d,%edi
 108a028:	jae    108aa73 <check_input_expressions+0x1e53>
 108a02e:	mov    0x128(%rsp),%rax
 108a036:	mov    %edi,%r8d
 108a039:	movl   $0xffffffff,(%rax,%r8,4)
 108a041:	incl   0x150(%rsp)
 108a048:	mov    0x154(%rsp),%r8d
 108a050:	jmp    108aa85 <check_input_expressions+0x1e65>
 108a055:	movb   $0x1,0x158(%rsp)
 108a05d:	jmp    108aef0 <check_input_expressions+0x22d0>
 108a062:	mov    0x154(%rsp),%r8d
 108a06a:	mov    0x20(%rsp),%r12
 108a06f:	cmp    %r8d,%edx
 108a072:	jae    108a09d <check_input_expressions+0x147d>
 108a074:	lea    0x8(%rax,%rsi,1),%rax
 108a079:	mov    %r14d,0x14c(%rsp)
 108a081:	movl   $0x1,(%r9)
 108a088:	mov    %ecx,0x4(%r9)
 108a08c:	vmovups %xmm2,(%rax)
 108a090:	movq   $0x0,0x10(%rax)
 108a098:	jmp    108aef0 <check_input_expressions+0x22d0>
 108a09d:	mov    (%r10),%rax
 108a0a0:	jmp    108aee0 <check_input_expressions+0x22c0>
 108a0a5:	mov    0x154(%rsp),%r8d
 108a0ad:	mov    0x20(%rsp),%r12
 108a0b2:	cmp    $0xffffffff,%edi
 108a0b5:	je     108a7be <check_input_expressions+0x1b9e>
 108a0bb:	mov    0x50(%rsp),%rcx
 108a0c0:	lea    (%rax,%rsi,1),%r9
 108a0c4:	cmp    $0xffffffff,%r10d
 108a0c8:	je     108a7b4 <check_input_expressions+0x1b94>
 108a0ce:	mov    0x150(%rsp),%edx
 108a0d5:	cmp    %r8d,%edx
 108a0d8:	jae    108a7d1 <check_input_expressions+0x1bb1>
 108a0de:	mov    0x128(%rsp),%rax
 108a0e6:	movl   $0xffffffff,(%rax,%rdx,4)
 108a0ed:	mov    0x150(%rsp),%ecx
 108a0f4:	mov    0x154(%rsp),%r8d
 108a0fc:	inc    %ecx
 108a0fe:	mov    %ecx,0x150(%rsp)
 108a105:	jmp    108a7e2 <check_input_expressions+0x1bc2>
 108a10a:	mov    %edi,%r9d
 108a10d:	movb   $0x1,0x3bd(%r15)
 108a115:	cmp    %r11d,%r9d
 108a118:	jae    108a147 <check_input_expressions+0x1527>
 108a11a:	mov    0x128(%rsp),%rax
 108a122:	mov    %r9d,%r10d
 108a125:	movl   $0xffffffff,(%rax,%r10,4)
 108a12d:	mov    0x150(%rsp),%eax
 108a134:	mov    0x154(%rsp),%r11d
 108a13c:	inc    %eax
 108a13e:	mov    %eax,0x150(%rsp)
 108a145:	jmp    108a15c <check_input_expressions+0x153c>
 108a147:	mov    0x110(%rsp),%rax
 108a14f:	mov    (%rax),%rax
 108a152:	movb   $0x1,0x3bd(%rax)
 108a159:	mov    %r9d,%eax
 108a15c:	cmp    %r11d,%eax
 108a15f:	jae    108a185 <check_input_expressions+0x1565>
 108a161:	mov    0x128(%rsp),%r10
 108a169:	mov    %eax,%r11d
 108a16c:	movl   $0xffffffff,(%r10,%r11,4)
 108a174:	incl   0x150(%rsp)
 108a17b:	mov    0x154(%rsp),%r11d
 108a183:	jmp    108a198 <check_input_expressions+0x1578>
 108a185:	mov    0x110(%rsp),%r10
 108a18d:	mov    (%r10),%r10
 108a190:	movb   $0x1,0x3bd(%r10)
 108a198:	mov    0x14c(%rsp),%r10d
 108a1a0:	cmp    %r11d,%r10d
 108a1a3:	jae    108a1ec <check_input_expressions+0x15cc>
 108a1a5:	mov    0x120(%rsp),%r11
 108a1ad:	mov    %r10d,%ebx
 108a1b0:	inc    %ebx
 108a1b2:	shl    $0x5,%r10
 108a1b6:	mov    %ebx,0x14c(%rsp)
 108a1bd:	movl   $0x3,(%r11,%r10,1)
 108a1c5:	mov    %eax,0x4(%r11,%r10,1)
 108a1ca:	vmovups %xmm2,0x8(%r11,%r10,1)
 108a1d1:	movq   $0x0,0x18(%r11,%r10,1)
 108a1da:	mov    0x14c(%rsp),%r10d
 108a1e2:	mov    0x154(%rsp),%r11d
 108a1ea:	jmp    108a1fe <check_input_expressions+0x15de>
 108a1ec:	mov    0x110(%rsp),%rbx
 108a1f4:	mov    (%rbx),%rbx
 108a1f7:	movb   $0x1,0x3bd(%rbx)
 108a1fe:	cmp    %r11d,%r10d
 108a201:	jae    108a252 <check_input_expressions+0x1632>
 108a203:	mov    0x120(%rsp),%r11
 108a20b:	lea    0x1(%r10),%ebx
 108a20f:	mov    %r10d,%r10d
 108a212:	shl    $0x5,%r10
 108a216:	movabs $0xffffffff00000003,%rcx
 108a220:	mov    %ebx,0x14c(%rsp)
 108a227:	vmovups %xmm3,(%r11,%r10,1)
 108a22d:	mov    %rcx,0x10(%r11,%r10,1)
 108a232:	movl   $0xffffffff,0x18(%r11,%r10,1)
 108a23b:	mov    %edi,0x1c(%r11,%r10,1)
 108a240:	mov    0x14c(%rsp),%r10d
 108a248:	mov    0x154(%rsp),%r11d
 108a250:	jmp    108a264 <check_input_expressions+0x1644>
 108a252:	mov    0x110(%rsp),%rbx
 108a25a:	mov    (%rbx),%rbx
 108a25d:	movb   $0x1,0x3bd(%rbx)
 108a264:	cmp    %r11d,%r10d
 108a267:	jae    108a2b7 <check_input_expressions+0x1697>
 108a269:	mov    0x120(%rsp),%r11
 108a271:	mov    0x50(%rsp),%rcx
 108a276:	lea    0x1(%r10),%ebx
 108a27a:	mov    %r10d,%r10d
 108a27d:	shl    $0x5,%r10
 108a281:	mov    %ebx,0x14c(%rsp)
 108a288:	movl   $0x1,(%r11,%r10,1)
 108a290:	mov    %ecx,0x4(%r11,%r10,1)
 108a295:	vmovups %xmm2,0x8(%r11,%r10,1)
 108a29c:	movq   $0x0,0x18(%r11,%r10,1)
 108a2a5:	mov    0x14c(%rsp),%r10d
 108a2ad:	mov    0x154(%rsp),%r11d
 108a2b5:	jmp    108a2c9 <check_input_expressions+0x16a9>
 108a2b7:	mov    0x110(%rsp),%rbx
 108a2bf:	mov    (%rbx),%rbx
 108a2c2:	movb   $0x1,0x3bd(%rbx)
 108a2c9:	cmp    %r11d,%r10d
 108a2cc:	jae    108a317 <check_input_expressions+0x16f7>
 108a2ce:	mov    0x120(%rsp),%r11
 108a2d6:	lea    0x1(%r10),%ebx
 108a2da:	mov    %r10d,%r10d
 108a2dd:	shl    $0x5,%r10
 108a2e1:	mov    %ebx,0x14c(%rsp)
 108a2e8:	movl   $0x3,(%r11,%r10,1)
 108a2f0:	mov    %r9d,0x4(%r11,%r10,1)
 108a2f5:	vmovups %xmm2,0x8(%r11,%r10,1)
 108a2fc:	movq   $0x0,0x18(%r11,%r10,1)
 108a305:	mov    0x14c(%rsp),%r10d
 108a30d:	mov    0x154(%rsp),%r11d
 108a315:	jmp    108a329 <check_input_expressions+0x1709>
 108a317:	mov    0x110(%rsp),%rbx
 108a31f:	mov    (%rbx),%rbx
 108a322:	movb   $0x1,0x3bd(%rbx)
 108a329:	cmp    %r11d,%r10d
 108a32c:	jae    108a378 <check_input_expressions+0x1758>
 108a32e:	mov    0x120(%rsp),%r11
 108a336:	lea    0x1(%r10),%ebx
 108a33a:	mov    %r10d,%r10d
 108a33d:	shl    $0x5,%r10
 108a341:	mov    %ebx,0x14c(%rsp)
 108a348:	movl   $0x0,(%r11,%r10,1)
 108a350:	mov    %r8d,0x4(%r11,%r10,1)
 108a355:	mov    %eax,0x8(%r11,%r10,1)
 108a35a:	mov    %r9d,0xc(%r11,%r10,1)
 108a35f:	vmovups %xmm2,0x10(%r11,%r10,1)
 108a366:	mov    0x14c(%rsp),%r10d
 108a36e:	mov    0x154(%rsp),%r11d
 108a376:	jmp    108a38b <check_input_expressions+0x176b>
 108a378:	mov    0x110(%rsp),%r8
 108a380:	mov    (%r8),%r8
 108a383:	movb   $0x1,0x3bd(%r8)
 108a38b:	mov    0x38(%rsp),%rcx
 108a390:	mov    %esi,%esi
 108a392:	mov    0x278(%rcx),%rcx
 108a399:	mov    (%rcx,%rsi,4),%ecx
 108a39c:	cmp    $0xffffffff,%ecx
 108a39f:	je     108a5a4 <check_input_expressions+0x1984>
 108a3a5:	cmp    %r11d,%r10d
 108a3a8:	jae    108a592 <check_input_expressions+0x1972>
 108a3ae:	mov    0x120(%rsp),%rsi
 108a3b6:	lea    0x1(%r10),%r8d
 108a3ba:	mov    %r8d,0x14c(%rsp)
 108a3c2:	mov    %r10d,%r8d
 108a3c5:	shl    $0x5,%r8
 108a3c9:	vmovups %xmm3,(%rsi,%r8,1)
 108a3cf:	movl   $0x1,0x10(%rsi,%r8,1)
 108a3d8:	mov    %ecx,0x14(%rsi,%r8,1)
 108a3dd:	movl   $0xffffffff,0x18(%rsi,%r8,1)
 108a3e6:	mov    %eax,0x1c(%rsi,%r8,1)
 108a3eb:	mov    0x14c(%rsp),%r10d
 108a3f3:	mov    0x154(%rsp),%r11d
 108a3fb:	jmp    108a5a4 <check_input_expressions+0x1984>
 108a400:	mov    0x38(%rsp),%rax
 108a405:	jmp    108aedd <check_input_expressions+0x22bd>
 108a40a:	mov    0x118(%rsp),%rax
 108a412:	mov    0x138(%rsp),%r9
 108a41a:	mov    (%rax),%edi
 108a41c:	mov    %esi,%eax
 108a41e:	sub    %edi,%ebx
 108a420:	mov    (%r9,%rbx,4),%r9d
 108a424:	mov    %rbx,0x50(%rsp)
 108a429:	cmp    $0xffffffff,%r9d
 108a42d:	je     108a46d <check_input_expressions+0x184d>
 108a42f:	mov    0x2c0(%r15),%r10
 108a436:	mov    0x130(%rsp),%r11
 108a43e:	mov    0x140(%rsp),%rbx
 108a446:	mov    %esi,%eax
 108a448:	jmp    108a45a <check_input_expressions+0x183a>
 108a44a:	nopw   0x0(%rax,%rax,1)
 108a450:	mov    (%rbx,%r9,4),%r9d
 108a454:	cmp    $0xffffffff,%r9d
 108a458:	je     108a46d <check_input_expressions+0x184d>
 108a45a:	mov    %r9d,%r14d
 108a45d:	sub    %edi,%r9d
 108a460:	cmpl   $0xffffffff,(%r10,%r14,4)
 108a465:	jne    108a450 <check_input_expressions+0x1830>
 108a467:	mov    (%r11,%r9,4),%eax
 108a46b:	jmp    108a450 <check_input_expressions+0x1830>
 108a46d:	mov    0x14c(%rsp),%r9d
 108a475:	cmp    0x154(%rsp),%r9d
 108a47d:	jae    108a62a <check_input_expressions+0x1a0a>
 108a483:	mov    0x120(%rsp),%r10
 108a48b:	lea    0x1(%r9),%r11d
 108a48f:	shl    $0x5,%r9
 108a493:	mov    %r11d,0x14c(%rsp)
 108a49b:	movl   $0x3,(%r10,%r9,1)
 108a4a3:	mov    %esi,0x4(%r10,%r9,1)
 108a4a8:	vmovups %xmm2,0x8(%r10,%r9,1)
 108a4af:	movq   $0x0,0x18(%r10,%r9,1)
 108a4b8:	mov    0x14c(%rsp),%r9d
 108a4c0:	cmp    0x154(%rsp),%r9d
 108a4c8:	jae    108acb2 <check_input_expressions+0x2092>
 108a4ce:	mov    0x120(%rsp),%r10
 108a4d6:	lea    0x1(%r9),%r11d
 108a4da:	shl    $0x5,%r9
 108a4de:	mov    %r11d,0x14c(%rsp)
 108a4e6:	movl   $0x0,(%r10,%r9,1)
 108a4ee:	mov    %edx,0x4(%r10,%r9,1)
 108a4f3:	mov    %esi,0x8(%r10,%r9,1)
 108a4f8:	mov    %r8d,0xc(%r10,%r9,1)
 108a4fd:	vmovups %xmm2,0x10(%r10,%r9,1)
 108a504:	mov    0x14c(%rsp),%edx
 108a50b:	cmp    0x154(%rsp),%edx
 108a512:	jae    108af23 <check_input_expressions+0x2303>
 108a518:	mov    0x120(%rsp),%rsi
 108a520:	lea    0x1(%rdx),%r8d
 108a524:	shl    $0x5,%rdx
 108a528:	mov    %r8d,0x14c(%rsp)
 108a530:	movabs $0xffffffff00000003,%r8
 108a53a:	vmovups %xmm3,(%rsi,%rdx,1)
 108a53f:	mov    %r8,0x10(%rsi,%rdx,1)
 108a544:	movl   $0xffffffff,0x18(%rsi,%rdx,1)
 108a54c:	mov    %eax,0x1c(%rsi,%rdx,1)
 108a550:	mov    0x50(%rsp),%rdx
 108a555:	jmp    108acd3 <check_input_expressions+0x20b3>
 108a55a:	mov    0x154(%rsp),%r8d
 108a562:	cmp    %r8d,%edi
 108a565:	jae    108a641 <check_input_expressions+0x1a21>
 108a56b:	mov    0x128(%rsp),%rax
 108a573:	mov    %edi,%r8d
 108a576:	movl   $0xffffffff,(%rax,%r8,4)
 108a57e:	incl   0x150(%rsp)
 108a585:	mov    0x154(%rsp),%r8d
 108a58d:	jmp    108a653 <check_input_expressions+0x1a33>
 108a592:	mov    0x110(%rsp),%rax
 108a59a:	mov    (%rax),%rax
 108a59d:	movb   $0x1,0x3bd(%rax)
 108a5a4:	cmp    %r11d,%r10d
 108a5a7:	jae    108ac9b <check_input_expressions+0x207b>
 108a5ad:	mov    0x120(%rsp),%rax
 108a5b5:	lea    0x1(%r10),%ecx
 108a5b9:	mov    %ecx,0x14c(%rsp)
 108a5c0:	mov    %r10d,%ecx
 108a5c3:	shl    $0x5,%rcx
 108a5c7:	movl   $0x3,(%rax,%rcx,1)
 108a5ce:	mov    %edi,0x4(%rax,%rcx,1)
 108a5d2:	vmovups %xmm2,0x8(%rax,%rcx,1)
 108a5d8:	movq   $0x0,0x18(%rax,%rcx,1)
 108a5e1:	mov    0x14c(%rsp),%eax
 108a5e8:	cmp    0x154(%rsp),%eax
 108a5ef:	jae    108aed5 <check_input_expressions+0x22b5>
 108a5f5:	mov    0x120(%rsp),%rcx
 108a5fd:	lea    0x1(%rax),%esi
 108a600:	shl    $0x5,%rax
 108a604:	mov    %esi,0x14c(%rsp)
 108a60b:	movl   $0x1,(%rcx,%rax,1)
 108a612:	mov    %edx,0x4(%rcx,%rax,1)
 108a616:	vmovups %xmm2,0x8(%rcx,%rax,1)
 108a61c:	movq   $0x0,0x18(%rcx,%rax,1)
 108a625:	jmp    108aef0 <check_input_expressions+0x22d0>
 108a62a:	mov    0x110(%rsp),%rax
 108a632:	mov    (%rax),%rdx
 108a635:	movb   $0x1,0x3bd(%rdx)
 108a63c:	jmp    108acba <check_input_expressions+0x209a>
 108a641:	mov    0x110(%rsp),%rax
 108a649:	mov    (%rax),%rax
 108a64c:	movb   $0x1,0x3bd(%rax)
 108a653:	mov    0x14c(%rsp),%eax
 108a65a:	cmp    %r8d,%eax
 108a65d:	jae    108aa26 <check_input_expressions+0x1e06>
 108a663:	mov    0x120(%rsp),%r8
 108a66b:	lea    0x1(%rax),%r9d
 108a66f:	shl    $0x5,%rax
 108a673:	mov    %r9d,0x14c(%rsp)
 108a67b:	movl   $0x3,(%r8,%rax,1)
 108a683:	mov    %esi,0x4(%r8,%rax,1)
 108a688:	vmovups %xmm2,0x8(%r8,%rax,1)
 108a68f:	movq   $0x0,0x18(%r8,%rax,1)
 108a698:	mov    0x14c(%rsp),%eax
 108a69f:	cmp    0x154(%rsp),%eax
 108a6a6:	jae    108aa52 <check_input_expressions+0x1e32>
 108a6ac:	mov    0x120(%rsp),%r8
 108a6b4:	lea    0x1(%rax),%r9d
 108a6b8:	shl    $0x5,%rax
 108a6bc:	mov    %r9d,0x14c(%rsp)
 108a6c4:	movabs $0xffffffff00000003,%r9
 108a6ce:	vmovups %xmm3,(%r8,%rax,1)
 108a6d4:	mov    %r9,0x10(%r8,%rax,1)
 108a6d9:	movl   $0xffffffff,0x18(%r8,%rax,1)
 108a6e2:	mov    %edi,0x1c(%r8,%rax,1)
 108a6e7:	mov    0x14c(%rsp),%eax
 108a6ee:	cmp    0x154(%rsp),%eax
 108a6f5:	jae    108af16 <check_input_expressions+0x22f6>
 108a6fb:	mov    0x120(%rsp),%r8
 108a703:	lea    0x1(%rax),%r9d
 108a707:	shl    $0x5,%rax
 108a70b:	mov    %r9d,0x14c(%rsp)
 108a713:	movl   $0x0,(%r8,%rax,1)
 108a71b:	mov    %edx,0x4(%r8,%rax,1)
 108a720:	mov    %esi,0x8(%r8,%rax,1)
 108a725:	mov    %edi,0xc(%r8,%rax,1)
 108a72a:	vmovups %xmm2,0x10(%r8,%rax,1)
 108a731:	mov    0x14c(%rsp),%eax
 108a738:	cmp    0x154(%rsp),%eax
 108a73f:	jae    108ac9b <check_input_expressions+0x207b>
 108a745:	mov    0x120(%rsp),%rdx
 108a74d:	lea    0x1(%rax),%r8d
 108a751:	shl    $0x5,%rax
 108a755:	mov    %r8d,0x14c(%rsp)
 108a75d:	vmovups %xmm3,(%rdx,%rax,1)
 108a762:	movl   $0x1,0x10(%rdx,%rax,1)
 108a76a:	mov    %ecx,0x14(%rdx,%rax,1)
 108a76e:	movl   $0xffffffff,0x18(%rdx,%rax,1)
 108a776:	mov    %esi,0x1c(%rdx,%rax,1)
 108a77a:	mov    0x14c(%rsp),%eax
 108a781:	cmp    0x154(%rsp),%eax
 108a788:	jae    108aed5 <check_input_expressions+0x22b5>
 108a78e:	mov    0x120(%rsp),%rcx
 108a796:	lea    0x1(%rax),%edx
 108a799:	shl    $0x5,%rax
 108a79d:	mov    %edx,0x14c(%rsp)
 108a7a4:	movl   $0x3,(%rcx,%rax,1)
 108a7ab:	mov    %edi,0x4(%rcx,%rax,1)
 108a7af:	jmp    108a616 <check_input_expressions+0x19f6>
 108a7b4:	mov    0x38(%rsp),%r10
 108a7b9:	jmp    108a06f <check_input_expressions+0x144f>
 108a7be:	mov    0x50(%rsp),%rcx
 108a7c3:	mov    0x38(%rsp),%r10
 108a7c8:	lea    (%rax,%rsi,1),%r9
 108a7cc:	jmp    108a06f <check_input_expressions+0x144f>
 108a7d1:	mov    0x38(%rsp),%rax
 108a7d6:	mov    %edx,%ecx
 108a7d8:	mov    (%rax),%rax
 108a7db:	movb   $0x1,0x3bd(%rax)
 108a7e2:	cmp    %r8d,%ecx
 108a7e5:	jae    108a812 <check_input_expressions+0x1bf2>
 108a7e7:	mov    0x128(%rsp),%rax
 108a7ef:	mov    %ecx,%esi
 108a7f1:	movl   $0xffffffff,(%rax,%rsi,4)
 108a7f8:	mov    0x150(%rsp),%eax
 108a7ff:	mov    0x154(%rsp),%r8d
 108a807:	inc    %eax
 108a809:	mov    %eax,0x150(%rsp)
 108a810:	jmp    108a826 <check_input_expressions+0x1c06>
 108a812:	mov    0x110(%rsp),%rax
 108a81a:	mov    (%rax),%rax
 108a81d:	movb   $0x1,0x3bd(%rax)
 108a824:	mov    %ecx,%eax
 108a826:	cmp    %r8d,%eax
 108a829:	jae    108a84f <check_input_expressions+0x1c2f>
 108a82b:	mov    0x128(%rsp),%rsi
 108a833:	mov    %eax,%r8d
 108a836:	movl   $0xffffffff,(%rsi,%r8,4)
 108a83e:	incl   0x150(%rsp)
 108a845:	mov    0x154(%rsp),%r8d
 108a84d:	jmp    108a861 <check_input_expressions+0x1c41>
 108a84f:	mov    0x110(%rsp),%rsi
 108a857:	mov    (%rsi),%rsi
 108a85a:	movb   $0x1,0x3bd(%rsi)
 108a861:	mov    0x14c(%rsp),%esi
 108a868:	cmp    %r8d,%esi
 108a86b:	jae    108aa30 <check_input_expressions+0x1e10>
 108a871:	mov    0x120(%rsp),%r8
 108a879:	lea    0x1(%rsi),%r9d
 108a87d:	shl    $0x5,%rsi
 108a881:	mov    %r9d,0x14c(%rsp)
 108a889:	movl   $0x3,(%r8,%rsi,1)
 108a891:	mov    %eax,0x4(%r8,%rsi,1)
 108a896:	vmovups %xmm2,0x8(%r8,%rsi,1)
 108a89d:	movq   $0x0,0x18(%r8,%rsi,1)
 108a8a6:	mov    0x14c(%rsp),%esi
 108a8ad:	cmp    0x154(%rsp),%esi
 108a8b4:	jae    108aa26 <check_input_expressions+0x1e06>
 108a8ba:	mov    0x120(%rsp),%r8
 108a8c2:	lea    0x1(%rsi),%r9d
 108a8c6:	shl    $0x5,%rsi
 108a8ca:	mov    %r9d,0x14c(%rsp)
 108a8d2:	movabs $0xffffffff00000003,%r9
 108a8dc:	vmovups %xmm3,(%r8,%rsi,1)
 108a8e2:	mov    %r9,0x10(%r8,%rsi,1)
 108a8e7:	movl   $0xffffffff,0x18(%r8,%rsi,1)
 108a8f0:	mov    %edx,0x1c(%r8,%rsi,1)
 108a8f5:	mov    0x14c(%rsp),%esi
 108a8fc:	cmp    0x154(%rsp),%esi
 108a903:	jae    108aa52 <check_input_expressions+0x1e32>
 108a909:	mov    0x98(%rsp),%r8
 108a911:	mov    %r10d,%r9d
 108a914:	mov    0x120(%rsp),%r11
 108a91c:	lea    0x1(%rsi),%r10d
 108a920:	shl    $0x5,%rsi
 108a924:	mov    0x2c0(%r8),%r8
 108a92b:	mov    (%r8,%r9,4),%r8d
 108a92f:	mov    %r10d,0x14c(%rsp)
 108a937:	vmovups %xmm3,(%r11,%rsi,1)
 108a93d:	movl   $0x1,0x10(%r11,%rsi,1)
 108a946:	mov    %r8d,0x14(%r11,%rsi,1)
 108a94b:	movl   $0xffffffff,0x18(%r11,%rsi,1)
 108a954:	mov    %eax,0x1c(%r11,%rsi,1)
 108a959:	mov    0x14c(%rsp),%esi
 108a960:	cmp    0x154(%rsp),%esi
 108a967:	jae    108af16 <check_input_expressions+0x22f6>
 108a96d:	mov    0x120(%rsp),%r8
 108a975:	lea    0x1(%rsi),%r9d
 108a979:	shl    $0x5,%rsi
 108a97d:	mov    %r9d,0x14c(%rsp)
 108a985:	movl   $0x3,(%r8,%rsi,1)
 108a98d:	mov    %ecx,0x4(%r8,%rsi,1)
 108a992:	vmovups %xmm2,0x8(%r8,%rsi,1)
 108a999:	movq   $0x0,0x18(%r8,%rsi,1)
 108a9a2:	mov    0x14c(%rsp),%esi
 108a9a9:	cmp    0x154(%rsp),%esi
 108a9b0:	jae    108ac9b <check_input_expressions+0x207b>
 108a9b6:	mov    0x120(%rsp),%r8
 108a9be:	lea    0x1(%rsi),%r9d
 108a9c2:	shl    $0x5,%rsi
 108a9c6:	mov    %r9d,0x14c(%rsp)
 108a9ce:	movl   $0x0,(%r8,%rsi,1)
 108a9d6:	mov    %edi,0x4(%r8,%rsi,1)
 108a9db:	mov    %eax,0x8(%r8,%rsi,1)
 108a9e0:	mov    %ecx,0xc(%r8,%rsi,1)
 108a9e5:	vmovups %xmm2,0x10(%r8,%rsi,1)
 108a9ec:	mov    0x14c(%rsp),%eax
 108a9f3:	cmp    0x154(%rsp),%eax
 108a9fa:	jae    108aed5 <check_input_expressions+0x22b5>
 108aa00:	mov    0x120(%rsp),%rcx
 108aa08:	lea    0x1(%rax),%esi
 108aa0b:	shl    $0x5,%rax
 108aa0f:	mov    %esi,0x14c(%rsp)
 108aa16:	movl   $0x3,(%rcx,%rax,1)
 108aa1d:	mov    %edx,0x4(%rcx,%rax,1)
 108aa21:	jmp    108a616 <check_input_expressions+0x19f6>
 108aa26:	mov    0x110(%rsp),%rax
 108aa2e:	jmp    108aa42 <check_input_expressions+0x1e22>
 108aa30:	mov    0x110(%rsp),%rax
 108aa38:	mov    (%rax),%rcx
 108aa3b:	movb   $0x1,0x3bd(%rcx)
 108aa42:	mov    (%rax),%rcx
 108aa45:	movb   $0x1,0x3bd(%rcx)
 108aa4c:	jmp    108aa5a <check_input_expressions+0x1e3a>
 108aa4e:	mov    %esi,%edi
 108aa50:	jmp    108aa85 <check_input_expressions+0x1e65>
 108aa52:	mov    0x110(%rsp),%rax
 108aa5a:	mov    (%rax),%rcx
 108aa5d:	movb   $0x1,0x3bd(%rcx)
 108aa64:	mov    (%rax),%rcx
 108aa67:	movb   $0x1,0x3bd(%rcx)
 108aa6e:	jmp    108aca3 <check_input_expressions+0x2083>
 108aa73:	mov    0x110(%rsp),%rax
 108aa7b:	mov    (%rax),%rax
 108aa7e:	movb   $0x1,0x3bd(%rax)
 108aa85:	mov    0x14c(%rsp),%eax
 108aa8c:	cmp    %r8d,%eax
 108aa8f:	jae    108aad9 <check_input_expressions+0x1eb9>
 108aa91:	mov    0x120(%rsp),%r8
 108aa99:	mov    %eax,%r9d
 108aa9c:	inc    %r9d
 108aa9f:	shl    $0x5,%rax
 108aaa3:	mov    %r9d,0x14c(%rsp)
 108aaab:	movl   $0x3,(%r8,%rax,1)
 108aab3:	mov    %esi,0x4(%r8,%rax,1)
 108aab8:	vmovups %xmm2,0x8(%r8,%rax,1)
 108aabf:	movq   $0x0,0x18(%r8,%rax,1)
 108aac8:	mov    0x14c(%rsp),%eax
 108aacf:	mov    0x154(%rsp),%r8d
 108aad7:	jmp    108aaec <check_input_expressions+0x1ecc>
 108aad9:	mov    0x110(%rsp),%r9
 108aae1:	mov    (%r9),%r9
 108aae4:	movb   $0x1,0x3bd(%r9)
 108aaec:	cmp    $0xffffffff,%r10d
 108aaf0:	je     108ac19 <check_input_expressions+0x1ff9>
 108aaf6:	cmp    %r8d,%eax
 108aaf9:	jae    108ab41 <check_input_expressions+0x1f21>
 108aafb:	mov    0x120(%rsp),%r8
 108ab03:	lea    0x1(%rax),%r9d
 108ab07:	mov    %eax,%eax
 108ab09:	shl    $0x5,%rax
 108ab0d:	mov    %r9d,0x14c(%rsp)
 108ab15:	movl   $0x0,(%r8,%rax,1)
 108ab1d:	mov    %r10d,0x4(%r8,%rax,1)
 108ab22:	vmovq  %xmm0,0x8(%r8,%rax,1)
 108ab29:	vmovups %xmm2,0x10(%r8,%rax,1)
 108ab30:	mov    0x14c(%rsp),%eax
 108ab37:	mov    0x154(%rsp),%r8d
 108ab3f:	jmp    108ab54 <check_input_expressions+0x1f34>
 108ab41:	mov    0x110(%rsp),%r9
 108ab49:	mov    (%r9),%r9
 108ab4c:	movb   $0x1,0x3bd(%r9)
 108ab54:	cmp    %r8d,%eax
 108ab57:	jae    108aba1 <check_input_expressions+0x1f81>
 108ab59:	mov    0x120(%rsp),%r8
 108ab61:	lea    0x1(%rax),%r9d
 108ab65:	mov    %eax,%eax
 108ab67:	shl    $0x5,%rax
 108ab6b:	mov    %r9d,0x14c(%rsp)
 108ab73:	movl   $0x3,(%r8,%rax,1)
 108ab7b:	mov    %edi,0x4(%r8,%rax,1)
 108ab80:	vmovups %xmm2,0x8(%r8,%rax,1)
 108ab87:	movq   $0x0,0x18(%r8,%rax,1)
 108ab90:	mov    0x14c(%rsp),%eax
 108ab97:	mov    0x154(%rsp),%r8d
 108ab9f:	jmp    108abb4 <check_input_expressions+0x1f94>
 108aba1:	mov    0x110(%rsp),%r9
 108aba9:	mov    (%r9),%r9
 108abac:	movb   $0x1,0x3bd(%r9)
 108abb4:	cmp    %r8d,%eax
 108abb7:	jae    108ac07 <check_input_expressions+0x1fe7>
 108abb9:	mov    0x120(%rsp),%r8
 108abc1:	lea    0x1(%rax),%r9d
 108abc5:	mov    %eax,%eax
 108abc7:	shl    $0x5,%rax
 108abcb:	mov    %r9d,0x14c(%rsp)
 108abd3:	movabs $0xffffffff00000003,%r9
 108abdd:	vmovups %xmm3,(%r8,%rax,1)
 108abe3:	mov    %r9,0x10(%r8,%rax,1)
 108abe8:	movl   $0xffffffff,0x18(%r8,%rax,1)
 108abf1:	mov    %esi,0x1c(%r8,%rax,1)
 108abf6:	mov    0x14c(%rsp),%eax
 108abfd:	mov    0x154(%rsp),%r8d
 108ac05:	jmp    108ac19 <check_input_expressions+0x1ff9>
 108ac07:	mov    0x110(%rsp),%rsi
 108ac0f:	mov    (%rsi),%rsi
 108ac12:	movb   $0x1,0x3bd(%rsi)
 108ac19:	cmp    %r8d,%eax
 108ac1c:	jae    108ac9b <check_input_expressions+0x207b>
 108ac1e:	mov    0x120(%rsp),%rsi
 108ac26:	lea    0x1(%rax),%r8d
 108ac2a:	mov    %eax,%eax
 108ac2c:	shl    $0x5,%rax
 108ac30:	mov    %r8d,0x14c(%rsp)
 108ac38:	movl   $0x0,(%rsi,%rax,1)
 108ac3f:	mov    %edx,0x4(%rsi,%rax,1)
 108ac43:	vmovq  %xmm0,0x8(%rsi,%rax,1)
 108ac49:	vmovups %xmm2,0x10(%rsi,%rax,1)
 108ac4f:	mov    0x14c(%rsp),%eax
 108ac56:	cmp    0x154(%rsp),%eax
 108ac5d:	jae    108aed5 <check_input_expressions+0x22b5>
 108ac63:	mov    0x120(%rsp),%rdx
 108ac6b:	lea    0x1(%rax),%esi
 108ac6e:	shl    $0x5,%rax
 108ac72:	mov    %esi,0x14c(%rsp)
 108ac79:	vmovups %xmm3,(%rdx,%rax,1)
 108ac7e:	movl   $0x1,0x10(%rdx,%rax,1)
 108ac86:	mov    %ecx,0x14(%rdx,%rax,1)
 108ac8a:	movl   $0xffffffff,0x18(%rdx,%rax,1)
 108ac92:	mov    %edi,0x1c(%rdx,%rax,1)
 108ac96:	jmp    108aef0 <check_input_expressions+0x22d0>
 108ac9b:	mov    0x110(%rsp),%rax
 108aca3:	mov    (%rax),%rcx
 108aca6:	movb   $0x1,0x3bd(%rcx)
 108acad:	jmp    108aedd <check_input_expressions+0x22bd>
 108acb2:	mov    0x110(%rsp),%rax
 108acba:	mov    (%rax),%rdx
 108acbd:	movb   $0x1,0x3bd(%rdx)
 108acc4:	mov    (%rax),%rax
 108acc7:	mov    0x50(%rsp),%rdx
 108accc:	movb   $0x1,0x3bd(%rax)
 108acd3:	mov    0x138(%rsp),%rax
 108acdb:	jmp    108ad0d <check_input_expressions+0x20ed>
 108acdd:	mov    0x110(%rsp),%rax
 108ace5:	mov    (%rax),%rsi
 108ace8:	movb   $0x1,0x3bd(%rsi)
 108acef:	mov    (%rax),%rsi
 108acf2:	movb   $0x1,0x3bd(%rsi)
 108acf9:	mov    (%rax),%rax
 108acfc:	movb   $0x1,0x3bd(%rax)
 108ad03:	mov    0x140(%rsp),%rax
 108ad0b:	sub    %edi,%edx
 108ad0d:	mov    (%rax,%rdx,4),%edx
 108ad10:	cmp    $0xffffffff,%edx
 108ad13:	je     108ae93 <check_input_expressions+0x2273>
 108ad19:	mov    0x2c0(%r15),%rax
 108ad20:	mov    %edx,%esi
 108ad22:	mov    (%rax,%rsi,4),%eax
 108ad25:	cmp    $0xffffffff,%eax
 108ad28:	je     108ad03 <check_input_expressions+0x20e3>
 108ad2a:	mov    0x150(%rsp),%esi
 108ad31:	mov    0x154(%rsp),%r9d
 108ad39:	cmp    %r9d,%esi
 108ad3c:	jae    108ad70 <check_input_expressions+0x2150>
 108ad3e:	mov    0x128(%rsp),%r8
 108ad46:	movl   $0xffffffff,(%r8,%rsi,4)
 108ad4e:	incl   0x150(%rsp)
 108ad55:	mov    0x154(%rsp),%r9d
 108ad5d:	mov    0x14c(%rsp),%r8d
 108ad65:	cmp    %r9d,%r8d
 108ad68:	jae    108acdd <check_input_expressions+0x20bd>
 108ad6e:	jmp    108ad94 <check_input_expressions+0x2174>
 108ad70:	mov    0x110(%rsp),%r8
 108ad78:	mov    (%r8),%r8
 108ad7b:	movb   $0x1,0x3bd(%r8)
 108ad83:	mov    0x14c(%rsp),%r8d
 108ad8b:	cmp    %r9d,%r8d
 108ad8e:	jae    108acdd <check_input_expressions+0x20bd>
 108ad94:	mov    0x120(%rsp),%r9
 108ad9c:	lea    0x1(%r8),%r10d
 108ada0:	shl    $0x5,%r8
 108ada4:	mov    %r10d,0x14c(%rsp)
 108adac:	movl   $0x3,(%r9,%r8,1)
 108adb4:	mov    %esi,0x4(%r9,%r8,1)
 108adb9:	vmovups %xmm2,0x8(%r9,%r8,1)
 108adc0:	movq   $0x0,0x18(%r9,%r8,1)
 108adc9:	mov    0x14c(%rsp),%r8d
 108add1:	cmp    0x154(%rsp),%r8d
 108add9:	jae    108ae79 <check_input_expressions+0x2259>
 108addf:	mov    0x130(%rsp),%r10
 108ade7:	mov    %edx,%r11d
 108adea:	sub    %edi,%r11d
 108aded:	mov    0x120(%rsp),%r9
 108adf5:	mov    (%r10,%r11,4),%r10d
 108adf9:	lea    0x1(%r8),%r11d
 108adfd:	shl    $0x5,%r8
 108ae01:	mov    %r11d,0x14c(%rsp)
 108ae09:	movabs $0xffffffff00000003,%r11
 108ae13:	vmovups %xmm3,(%r9,%r8,1)
 108ae19:	mov    %r11,0x10(%r9,%r8,1)
 108ae1e:	movl   $0xffffffff,0x18(%r9,%r8,1)
 108ae27:	mov    %r10d,0x1c(%r9,%r8,1)
 108ae2c:	mov    0x14c(%rsp),%r8d
 108ae34:	cmp    0x154(%rsp),%r8d
 108ae3c:	jae    108ae86 <check_input_expressions+0x2266>
 108ae3e:	mov    0x120(%rsp),%r9
 108ae46:	lea    0x1(%r8),%r10d
 108ae4a:	shl    $0x5,%r8
 108ae4e:	mov    %r10d,0x14c(%rsp)
 108ae56:	vmovups %xmm3,(%r9,%r8,1)
 108ae5c:	movl   $0x2,0x10(%r9,%r8,1)
 108ae65:	mov    %ecx,0x14(%r9,%r8,1)
 108ae6a:	mov    %eax,0x18(%r9,%r8,1)
 108ae6f:	mov    %esi,0x1c(%r9,%r8,1)
 108ae74:	jmp    108ad03 <check_input_expressions+0x20e3>
 108ae79:	mov    0x110(%rsp),%rax
 108ae81:	jmp    108acef <check_input_expressions+0x20cf>
 108ae86:	mov    0x110(%rsp),%rax
 108ae8e:	jmp    108acf9 <check_input_expressions+0x20d9>
 108ae93:	mov    0x14c(%rsp),%eax
 108ae9a:	cmp    0x154(%rsp),%eax
 108aea1:	jae    108aed5 <check_input_expressions+0x22b5>
 108aea3:	mov    0x120(%rsp),%rdx
 108aeab:	lea    0x1(%rax),%esi
 108aeae:	shl    $0x5,%rax
 108aeb2:	mov    %esi,0x14c(%rsp)
 108aeb9:	movl   $0x2,(%rdx,%rax,1)
 108aec0:	vmovups %xmm2,0x4(%rdx,%rax,1)
 108aec6:	mov    %ecx,0x14(%rdx,%rax,1)
 108aeca:	movq   $0xffffffffffffffff,0x18(%rdx,%rax,1)
 108aed3:	jmp    108aef0 <check_input_expressions+0x22d0>
 108aed5:	mov    0x110(%rsp),%rax
 108aedd:	mov    (%rax),%rax
 108aee0:	movb   $0x1,0x3bd(%rax)
 108aee7:	nopw   0x0(%rax,%rax,1)
 108aef0:	mov    0x14c(%rsp),%r14d
 108aef8:	movzbl 0x158(%rsp),%eax
 108af00:	test   %r14d,%r14d
 108af03:	je     1089884 <check_input_expressions+0xc64>
 108af09:	test   %al,%al
 108af0b:	je     10898e0 <check_input_expressions+0xcc0>
 108af11:	jmp    1089884 <check_input_expressions+0xc64>
 108af16:	mov    0x110(%rsp),%rax
 108af1e:	jmp    108aa64 <check_input_expressions+0x1e44>
 108af23:	mov    0x110(%rsp),%rax
 108af2b:	jmp    108acc4 <check_input_expressions+0x20a4>
 108af30:	mov    (%r12),%rax
 108af34:	movb   $0x1,0x3bd(%rax)
 108af3b:	mov    (%r12),%rcx
 108af3f:	mov    $0xffffffff,%r14d
 108af45:	mov    $0xffffffff,%r9d
 108af4b:	cmpb   $0x0,0x3bd(%rcx)
 108af52:	je     108af5e <check_input_expressions+0x233e>
 108af54:	mov    0x30(%rsp),%r10
 108af59:	jmp    108b030 <check_input_expressions+0x2410>
 108af5e:	mov    0x148(%rsp),%eax
 108af65:	mov    0x30(%rsp),%r10
 108af6a:	add    $0x3bd,%rcx
 108af71:	mov    %rax,%rdx
 108af74:	shl    $0x4,%rdx
 108af78:	dec    %rax
 108af7b:	or     $0xc,%rdx
 108af7f:	jmp    108afaf <check_input_expressions+0x238f>
 108af81:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108af90:	movb   $0x1,(%rcx)
 108af93:	mov    (%r12),%rsi
 108af97:	add    $0x10,%rdx
 108af9b:	cmpb   $0x0,0x3bd(%rsi)
 108afa2:	lea    0x3bd(%rsi),%rcx
 108afa9:	jne    108b030 <check_input_expressions+0x2410>
 108afaf:	mov    0x138(%r13),%esi
 108afb6:	inc    %rax
 108afb9:	cmp    %rsi,%rax
 108afbc:	jae    108afec <check_input_expressions+0x23cc>
 108afbe:	mov    0x130(%r13),%rsi
 108afc5:	mov    (%rsi,%rdx,1),%edi
 108afc8:	cmp    %r9,%rdi
 108afcb:	je     108af93 <check_input_expressions+0x2373>
 108afcd:	cmp    0x150(%rsp),%edi
 108afd4:	jae    108af90 <check_input_expressions+0x2370>
 108afd6:	mov    0x128(%rsp),%r8
 108afde:	mov    (%r8,%rdi,4),%edi
 108afe2:	cmp    $0xffffffff,%edi
 108afe5:	je     108af90 <check_input_expressions+0x2370>
 108afe7:	mov    %edi,(%rsi,%rdx,1)
 108afea:	jmp    108af93 <check_input_expressions+0x2373>
 108afec:	mov    0x128(%r13),%r14d
 108aff3:	lea    0x1(%r14),%eax
 108aff7:	mov    %r14,%rcx
 108affa:	shl    $0x4,%rcx
 108affe:	mov    %eax,0x128(%r13)
 108b005:	mov    0x148(%rsp),%edx
 108b00c:	mov    0x120(%r13),%rax
 108b013:	movzbl 0x158(%rsp),%edi
 108b01b:	sub    %edx,%esi
 108b01d:	movl   $0xffffffff,(%rax,%rcx,1)
 108b024:	mov    %edx,0x4(%rax,%rcx,1)
 108b028:	mov    %esi,0x8(%rax,%rcx,1)
 108b02c:	mov    %edi,0xc(%rax,%rcx,1)
 108b030:	mov    0x28(%r12),%rax
 108b035:	mov    0x80(%rsp),%rcx
 108b03d:	cmp    0x8(%rax),%rcx
 108b041:	ja     108e645 <check_input_expressions+0x5a25>
 108b047:	mov    %rcx,0x8(%rax)
 108b04b:	mov    $0x37,%esi
 108b050:	mov    $0xffffffff,%r8d
 108b056:	mov    $0xffffffff,%r9d
 108b05c:	mov    0x10(%rsp),%rdx
 108b061:	mov    %r12,%rdi
 108b064:	mov    0x10(%r10),%ecx
 108b068:	vzeroupper
 108b06b:	call   10facf0 <check_input_add>
 108b070:	mov    %eax,%r15d
 108b073:	xor    %esi,%esi
 108b075:	cmp    $0xffffffff,%r14d
 108b079:	je     108b0be <check_input_expressions+0x249e>
 108b07b:	vpmovsxbq -0xbed484(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108b084:	mov    0x18(%rsp),%r9
 108b089:	mov    0xc(%rsp),%r8d
 108b08e:	mov    $0xffffffff,%r11d
 108b094:	vxorps %xmm2,%xmm2,%xmm2
 108b098:	cmp    $0xffffffff,%r15d
 108b09c:	je     108dc7d <check_input_expressions+0x505d>
 108b0a2:	mov    0x70(%rsp),%rax
 108b0a7:	mov    %r14d,%ecx
 108b0aa:	shl    $0x4,%rcx
 108b0ae:	mov    0x120(%rax),%rax
 108b0b5:	mov    %r15d,(%rax,%rcx,1)
 108b0b9:	jmp    108dc87 <check_input_expressions+0x5067>
 108b0be:	vpmovsxbq -0xbed4c7(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108b0c7:	mov    0x18(%rsp),%r9
 108b0cc:	mov    0xc(%rsp),%r8d
 108b0d1:	vxorps %xmm2,%xmm2,%xmm2
 108b0d5:	mov    $0xffffffff,%r11d
 108b0db:	cmp    $0xffffffff,%r15d
 108b0df:	jne    108dc87 <check_input_expressions+0x5067>
 108b0e5:	jmp    108de5d <check_input_expressions+0x523d>
 108b0ea:	mov    %rax,%rdx
 108b0ed:	and    $0xfffffffc,%eax
 108b0f0:	cmp    $0x3c,%eax
 108b0f3:	jne    108b268 <check_input_expressions+0x2648>
 108b0f9:	mov    $0x1,%al
 108b0fb:	mov    %eax,0x8c(%rsp)
 108b102:	jmp    108b27f <check_input_expressions+0x265f>
 108b107:	mov    0x250(%r12),%rax
 108b10f:	mov    %r14,%rcx
 108b112:	mov    (%r12),%r13
 108b116:	mov    (%rax,%r14,4),%r14d
 108b11a:	test   %r14d,%r14d
 108b11d:	je     108b28c <check_input_expressions+0x266c>
 108b123:	cmp    0x330(%r13),%r14d
 108b12a:	ja     1088c90 <check_input_expressions+0x70>
 108b130:	mov    0x328(%r13),%rcx
 108b137:	mov    0x18(%r12),%rdx
 108b13c:	lea    -0x1(%r14),%eax
 108b140:	lea    (%rax,%rax,8),%rax
 108b144:	mov    0x4(%rcx,%rax,4),%esi
 108b148:	mov    0x30(%rdx),%rdx
 108b14c:	and    $0xfffffff8,%esi
 108b14f:	cmpq   $0x0,(%rdx,%rsi,1)
 108b154:	je     1088c90 <check_input_expressions+0x70>
 108b15a:	lea    (%rcx,%rax,4),%rbp
 108b15e:	mov    0x8(%rbp),%ecx
 108b161:	mov    0xc(%rbp),%edx
 108b164:	cmp    %edx,%ecx
 108b166:	jae    108c3ee <check_input_expressions+0x37ce>
 108b16c:	mov    0x8(%r12),%rbx
 108b171:	mov    %rdx,%r9
 108b174:	sub    %rcx,%r9
 108b177:	mov    %rcx,%rax
 108b17a:	sub    %rdx,%rax
 108b17d:	mov    %r9d,%edi
 108b180:	and    $0x7,%edi
 108b183:	mov    0x60(%rbx),%rsi
 108b187:	cmp    $0xfffffffffffffff8,%rax
 108b18b:	jbe    108c1b9 <check_input_expressions+0x3599>
 108b191:	xor    %r10d,%r10d
 108b194:	mov    $0xffffffff,%r15d
 108b19a:	mov    %rcx,%r8
 108b19d:	jmp    108c329 <check_input_expressions+0x3709>
 108b1a2:	mov    %rsi,%rdi
 108b1a5:	sub    %r8,%rdi
 108b1a8:	mov    0x10(%rcx),%r8
 108b1ac:	sub    %rdi,%r8
 108b1af:	jb     1088f4b <check_input_expressions+0x32b>
 108b1b5:	mov    %rdx,%r9
 108b1b8:	shl    $0x5,%r9
 108b1bc:	cmp    %r8,%r9
 108b1bf:	ja     1088f4b <check_input_expressions+0x32b>
 108b1c5:	add    %r9,%rdi
 108b1c8:	mov    %rdi,0x8(%rcx)
 108b1cc:	mov    0x28(%r12),%rcx
 108b1d1:	mov    %rsi,0x120(%rsp)
 108b1d9:	mov    (%rcx),%r8
 108b1dc:	mov    0x8(%rcx),%rdi
 108b1e0:	lea    0x3(%rdi,%r8,1),%rsi
 108b1e5:	add    %r8,%rdi
 108b1e8:	and    $0xfffffffffffffffc,%rsi
 108b1ec:	cmp    %rdi,%rsi
 108b1ef:	jae    108b1f5 <check_input_expressions+0x25d5>
 108b1f1:	xor    %esi,%esi
 108b1f3:	jmp    108b219 <check_input_expressions+0x25f9>
 108b1f5:	mov    %rsi,%rdi
 108b1f8:	sub    %r8,%rdi
 108b1fb:	mov    0x10(%rcx),%r8
 108b1ff:	sub    %rdi,%r8
 108b202:	jb     108b1f1 <check_input_expressions+0x25d1>
 108b204:	shl    $0x2,%rdx
 108b208:	cmp    %r8,%rdx
 108b20b:	ja     108b1f1 <check_input_expressions+0x25d1>
 108b20d:	add    %rdx,%rdi
 108b210:	mov    %rdi,0x8(%rcx)
 108b214:	mov    0x28(%r12),%rcx
 108b219:	inc    %rax
 108b21c:	mov    %rsi,0x128(%rsp)
 108b224:	mov    %rax,%rdx
 108b227:	shr    $0x3e,%rdx
 108b22b:	je     108b241 <check_input_expressions+0x2621>
 108b22d:	lea    0x120(%rsp),%rax
 108b235:	xor    %edx,%edx
 108b237:	vmovups %xmm2,0x10(%rax)
 108b23c:	jmp    108b375 <check_input_expressions+0x2755>
 108b241:	mov    (%rcx),%rdi
 108b244:	mov    0x8(%rcx),%rsi
 108b248:	shl    $0x2,%rax
 108b24c:	lea    0x3(%rsi,%rdi,1),%rdx
 108b251:	add    %rdi,%rsi
 108b254:	and    $0xfffffffffffffffc,%rdx
 108b258:	cmp    %rsi,%rdx
 108b25b:	jae    108b2e9 <check_input_expressions+0x26c9>
 108b261:	xor    %edx,%edx
 108b263:	jmp    108b311 <check_input_expressions+0x26f1>
 108b268:	lea    -0x42(%rdx),%eax
 108b26b:	cmp    $0x3,%eax
 108b26e:	jae    108b3ba <check_input_expressions+0x279a>
 108b274:	movl   $0x0,0x8c(%rsp)
 108b27f:	mov    0x10(%rsp),%r14
 108b284:	mov    $0x1,%r13b
 108b287:	jmp    108b3fb <check_input_expressions+0x27db>
 108b28c:	mov    0x348(%r13),%rax
 108b293:	cmpl   $0x0,(%rax,%rcx,4)
 108b297:	je     108bc0b <check_input_expressions+0x2feb>
 108b29d:	mov    %r15d,%eax
 108b2a0:	and    $0xfe,%al
 108b2a2:	cmp    $0x3c,%al
 108b2a4:	jne    1088c90 <check_input_expressions+0x70>
 108b2aa:	mov    0x2c0(%r13),%rcx
 108b2b1:	mov    0x10(%rsp),%rdx
 108b2b6:	mov    $0xffffffff,%r15d
 108b2bc:	cmp    $0x1,%ebp
 108b2bf:	mov    $0xffffffff,%eax
 108b2c4:	cmove  %r8d,%eax
 108b2c8:	mov    %eax,(%rcx,%rdx,4)
 108b2cb:	je     1088c90 <check_input_expressions+0x70>
 108b2d1:	xor    %esi,%esi
 108b2d3:	mov    (%r12),%rax
 108b2d7:	cmpl   $0x0,0x230(%rax)
 108b2de:	jne    108dc7d <check_input_expressions+0x505d>
 108b2e4:	jmp    108dc44 <check_input_expressions+0x5024>
 108b2e9:	mov    %rdx,%rsi
 108b2ec:	sub    %rdi,%rsi
 108b2ef:	mov    0x10(%rcx),%rdi
 108b2f3:	sub    %rsi,%rdi
 108b2f6:	jb     108b261 <check_input_expressions+0x2641>
 108b2fc:	cmp    %rdi,%rax
 108b2ff:	ja     108b261 <check_input_expressions+0x2641>
 108b305:	add    %rax,%rsi
 108b308:	mov    %rsi,0x8(%rcx)
 108b30c:	mov    0x28(%r12),%rcx
 108b311:	mov    %rdx,0x130(%rsp)
 108b319:	mov    (%rcx),%rdi
 108b31c:	mov    0x8(%rcx),%rsi
 108b320:	lea    0x3(%rsi,%rdi,1),%rdx
 108b325:	add    %rdi,%rsi
 108b328:	and    $0xfffffffffffffffc,%rdx
 108b32c:	cmp    %rsi,%rdx
 108b32f:	jae    108b335 <check_input_expressions+0x2715>
 108b331:	xor    %edx,%edx
 108b333:	jmp    108b355 <check_input_expressions+0x2735>
 108b335:	mov    %rdx,%rsi
 108b338:	sub    %rdi,%rsi
 108b33b:	mov    0x10(%rcx),%rdi
 108b33f:	sub    %rsi,%rdi
 108b342:	jb     108b331 <check_input_expressions+0x2711>
 108b344:	cmp    %rdi,%rax
 108b347:	ja     108b331 <check_input_expressions+0x2711>
 108b349:	add    %rax,%rsi
 108b34c:	mov    %rsi,0x8(%rcx)
 108b350:	mov    0x28(%r12),%rcx
 108b355:	mov    %rdx,0x138(%rsp)
 108b35d:	mov    (%rcx),%rsi
 108b360:	mov    0x8(%rcx),%rdi
 108b364:	lea    0x3(%rdi,%rsi,1),%r8
 108b369:	add    %rsi,%rdi
 108b36c:	and    $0xfffffffffffffffc,%r8
 108b370:	cmp    %rdi,%r8
 108b373:	jae    108b37e <check_input_expressions+0x275e>
 108b375:	xor    %esi,%esi
 108b377:	xor    %edi,%edi
 108b379:	jmp    10890b2 <check_input_expressions+0x492>
 108b37e:	mov    0x10(%rcx),%r10
 108b382:	mov    %r8,%r9
 108b385:	sub    %rsi,%r9
 108b388:	xor    %edi,%edi
 108b38a:	mov    $0x0,%esi
 108b38f:	sub    %r9,%r10
 108b392:	jb     10890b2 <check_input_expressions+0x492>
 108b398:	cmp    %r10,%rax
 108b39b:	ja     10890b2 <check_input_expressions+0x492>
 108b3a1:	add    %rax,%r9
 108b3a4:	xor    %esi,%esi
 108b3a6:	mov    %r8,%rdi
 108b3a9:	mov    %r9,0x8(%rcx)
 108b3ad:	mov    0x138(%rsp),%rdx
 108b3b5:	jmp    10890b2 <check_input_expressions+0x492>
 108b3ba:	mov    0x10(%rsp),%r14
 108b3bf:	mov    %edx,%eax
 108b3c1:	and    $0xfffffffe,%eax
 108b3c4:	mov    %r8d,%r13d
 108b3c7:	cmp    $0x1e,%eax
 108b3ca:	jne    108bc46 <check_input_expressions+0x3026>
 108b3d0:	mov    0xa8(%r12),%rax
 108b3d8:	mov    %ebp,%ecx
 108b3da:	xor    $0x1,%ecx
 108b3dd:	mov    %r13d,%r8d
 108b3e0:	movl   $0x0,0x8c(%rsp)
 108b3eb:	or     (%rax,%r14,4),%ecx
 108b3ef:	mov    $0xffffffff,%ecx
 108b3f4:	cmove  %r13d,%ecx
 108b3f8:	xor    %r13d,%r13d
 108b3fb:	mov    0x208(%r12),%rax
 108b403:	mov    %r8d,0xc(%rsp)
 108b408:	movzwl (%rax,%r14,2),%eax
 108b40d:	add    $0xfffffead,%eax
 108b412:	cmp    $0x5,%ax
 108b416:	ja     108b50d <check_input_expressions+0x28ed>
 108b41c:	mov    $0x24,%esi
 108b421:	mov    $0xffffffff,%r8d
 108b427:	mov    $0xffffffff,%r9d
 108b42d:	mov    %r14d,%edx
 108b430:	mov    %r12,%rdi
 108b433:	mov    %r10d,%r14d
 108b436:	vzeroupper
 108b439:	call   10facf0 <check_input_add>
 108b43e:	mov    $0xffffffff,%ecx
 108b443:	mov    %r14d,%r10d
 108b446:	cmp    $0xffffffff,%eax
 108b449:	je     108b50d <check_input_expressions+0x28ed>
 108b44f:	mov    0x208(%r12),%rcx
 108b457:	mov    0x10(%rsp),%rdx
 108b45c:	mov    $0xaaaaaaab,%esi
 108b461:	movzwl (%rcx,%rdx,2),%ecx
 108b465:	add    $0xfffffead,%ecx
 108b46b:	mov    %rcx,%rdx
 108b46e:	imul   %rsi,%rdx
 108b472:	shr    $0x21,%rdx
 108b476:	lea    (%rdx,%rdx,2),%esi
 108b479:	mov    0x18(%r12),%rdx
 108b47e:	sub    %esi,%ecx
 108b480:	xor    %esi,%esi
 108b482:	cmp    $0x2,%ecx
 108b485:	sete   %sil
 108b489:	cmp    $0x1,%ecx
 108b48c:	lea    0xa0(,%rsi,8),%ecx
 108b493:	mov    $0x98,%esi
 108b498:	cmove  %esi,%ecx
 108b49b:	mov    %ecx,%esi
 108b49d:	shr    $0x3,%esi
 108b4a0:	cmp    0x48(%rdx),%esi
 108b4a3:	jae    108b4b6 <check_input_expressions+0x2896>
 108b4a5:	mov    (%rdx),%rdi
 108b4a8:	cmpb   $0x0,(%rdi,%rsi,1)
 108b4ac:	je     108b4b6 <check_input_expressions+0x2896>
 108b4ae:	or     $0x100,%ecx
 108b4b4:	jmp    108b4fd <check_input_expressions+0x28dd>
 108b4b6:	mov    0x108(%rdx),%rcx
 108b4bd:	movl   $0x2,0x100(%rdx)
 108b4c7:	test   %rcx,%rcx
 108b4ca:	je     108b4e2 <check_input_expressions+0x28c2>
 108b4cc:	movb   $0x1,0x3c(%rcx)
 108b4d0:	mov    0x30(%rcx),%rdx
 108b4d4:	mov    %rdx,0x40(%rcx)
 108b4d8:	movl   $0x2,0x48(%rcx)
 108b4df:	incl   0x34(%rcx)
 108b4e2:	mov    0x18(%r12),%rdx
 108b4e7:	xor    %ecx,%ecx
 108b4e9:	cmpl   $0x1,0x100(%rdx)
 108b4f0:	jne    108b4fd <check_input_expressions+0x28dd>
 108b4f2:	mov    (%r12),%rdx
 108b4f6:	movb   $0x1,0x3bd(%rdx)
 108b4fd:	mov    0x70(%rsp),%rdx
 108b502:	mov    %eax,%esi
 108b504:	mov    0x30(%rdx),%rdx
 108b508:	mov    %ecx,(%rdx,%rsi,4)
 108b50b:	mov    %eax,%ecx
 108b50d:	mov    0x20(%rsp),%edx
 108b511:	mov    0x30(%rsp),%rax
 108b516:	mov    $0x1,%sil
 108b519:	mov    %ecx,0xb4(%rsp)
 108b520:	cmp    $0x9,%r15b
 108b524:	jne    108b83a <check_input_expressions+0x2c1a>
 108b52a:	mov    0x30(%rsp),%rax
 108b52f:	mov    %ebp,%ecx
 108b531:	xor    $0x17,%eax
 108b534:	xor    $0x2,%ecx
 108b537:	or     %eax,%ecx
 108b539:	mov    0x30(%rsp),%rax
 108b53e:	sete   %r15b
 108b542:	cmp    $0x43,%eax
 108b545:	sete   %cl
 108b548:	mov    %rcx,0x98(%rsp)
 108b550:	jne    108b877 <check_input_expressions+0x2c57>
 108b556:	mov    (%r12),%r14
 108b55a:	mov    0x10(%rsp),%rdx
 108b55f:	mov    0x280(%r12),%rdi
 108b567:	mov    %sil,0x5f(%rsp)
 108b56c:	xor    %esi,%esi
 108b56e:	mov    %r10d,0x28(%rsp)
 108b573:	mov    0x218(%r14),%rcx
 108b57a:	mov    0x208(%r14),%r13
 108b581:	mov    0x1f8(%r14),%rax
 108b588:	mov    (%rcx,%rdx,4),%ebx
 108b58b:	shl    $0x5,%rbx
 108b58f:	mov    -0x20(%r13,%rbx,1),%ecx
 108b594:	mov    -0x14(%r13,%rbx,1),%edx
 108b599:	imul   $0x130,%rcx,%rcx
 108b5a0:	cmpb   $0x0,(%rdi,%rdx,1)
 108b5a4:	mov    (%rax,%rcx,1),%rdi
 108b5a8:	mov    0x118(%rax,%rcx,1),%rax
 108b5b0:	setne  %sil
 108b5b4:	mov    %rax,0x50(%rsp)
 108b5b9:	vzeroupper
 108b5bc:	call   10a0fe0 <check_graph_x86_ice_mask>
 108b5c1:	cmpl   $0x0,-0xc(%r13,%rbx,1)
 108b5c7:	mov    0xb8(%r14),%edi
 108b5ce:	mov    0x40(%rsp),%ecx
 108b5d2:	mov    %rax,%rdx
 108b5d5:	sete   %sil
 108b5d9:	xor    $0x1,%cl
 108b5dc:	mov    %edi,0x88(%rsp)
 108b5e3:	or     %sil,%cl
 108b5e6:	jne    108b890 <check_input_expressions+0x2c70>
 108b5ec:	mov    %r13,%r8
 108b5ef:	or     0x50(%rsp),%rdx
 108b5f4:	mov    0xc(%rsp),%r13d
 108b5f9:	mov    0x28(%rsp),%r10d
 108b5fe:	add    %rbx,%r8
 108b601:	mov    %r15b,0x6f(%rsp)
 108b606:	mov    %r14,%rdi
 108b609:	xor    %r15d,%r15d
 108b60c:	movq   $0x0,0x90(%rsp)
 108b618:	mov    %r14,0xb8(%rsp)
 108b620:	mov    %r8,0xa8(%rsp)
 108b628:	mov    %rdx,0xc0(%rsp)
 108b630:	mov    0x390(%r12),%rax
 108b638:	mov    %r13d,%r14d
 108b63b:	vpxor  %xmm0,%xmm0,%xmm0
 108b63f:	mov    (%rax,%r14,4),%r9d
 108b643:	vmovdqu64 %zmm0,0x130(%rsp)
 108b64e:	vmovdqu64 %zmm0,0x110(%rsp)
 108b659:	mov    -0x8(%r8),%rax
 108b65d:	mov    (%rax,%r15,8),%esi
 108b661:	cmp    $0x3f,%r15
 108b665:	ja     108b7bf <check_input_expressions+0x2b9f>
 108b66b:	mov    0x4(%rax,%r15,8),%edx
 108b670:	mov    %r9d,0x50(%rsp)
 108b675:	mov    %r12,%rdi
 108b678:	mov    %esi,0x80(%rsp)
 108b67f:	xor    %ecx,%ecx
 108b681:	mov    $0x1,%r8d
 108b687:	lea    0x110(%rsp),%r9
 108b68f:	push   $0x0
 108b691:	lea    0xf8(%rsp),%rax
 108b699:	push   %rax
 108b69a:	vzeroupper
 108b69d:	call   10c1fc0 <check_input_constant_read>
 108b6a2:	add    $0x10,%rsp
 108b6a6:	test   %al,%al
 108b6a8:	je     108b79e <check_input_expressions+0x2b7e>
 108b6ae:	cmpl   $0x0,0x164(%rsp)
 108b6b6:	mov    0x28(%rsp),%r10d
 108b6bb:	mov    0xb8(%rsp),%rdi
 108b6c3:	mov    0xa8(%rsp),%r8
 108b6cb:	mov    0x50(%rsp),%r9d
 108b6d0:	mov    0x80(%rsp),%esi
 108b6d7:	jne    108b7bf <check_input_expressions+0x2b9f>
 108b6dd:	cmpl   $0x1,0x11c(%rsp)
 108b6e5:	jne    108b7bf <check_input_expressions+0x2b9f>
 108b6eb:	mov    0x118(%rsp),%eax
 108b6f2:	mov    %eax,%ecx
 108b6f4:	and    $0x10,%ecx
 108b6f7:	shr    $0x4,%ecx
 108b6fa:	test   $0x401,%eax
 108b6ff:	sete   %al
 108b702:	or     %cl,%al
 108b704:	jne    108b7bf <check_input_expressions+0x2b9f>
 108b70a:	mov    0x90(%rsp),%rax
 108b712:	mov    0xc0(%rsp),%rcx
 108b71a:	bts    %r15,%rax
 108b71e:	bt     %r15,%rcx
 108b722:	mov    %rax,0x90(%rsp)
 108b72a:	jae    108b7bf <check_input_expressions+0x2b9f>
 108b730:	mov    0x8(%rdi),%rax
 108b734:	mov    $0xffffffff,%ecx
 108b739:	mov    $0xffffffff,%r8d
 108b73f:	mov    $0xffffffff,%r9d
 108b745:	xor    %esi,%esi
 108b747:	mov    (%rax,%r14,4),%edx
 108b74b:	mov    %rdi,%r14
 108b74e:	mov    %r12,%rdi
 108b751:	call   10facf0 <check_input_add>
 108b756:	cmp    $0xffffffff,%eax
 108b759:	je     108b794 <check_input_expressions+0x2b74>
 108b75b:	vmovdqu64 0x110(%rsp),%zmm0
 108b766:	vmovups 0x130(%rsp),%zmm1
 108b771:	mov    0x28(%r14),%rcx
 108b775:	mov    %eax,%edx
 108b777:	lea    (%rdx,%rdx,2),%rdx
 108b77b:	mov    %eax,%r13d
 108b77e:	shl    $0x5,%rdx
 108b782:	vmovups %zmm1,0x20(%rcx,%rdx,1)
 108b78d:	vmovdqu64 %zmm0,(%rcx,%rdx,1)
 108b794:	mov    0x28(%rsp),%r10d
 108b799:	mov    %r14,%rdi
 108b79c:	jmp    108b7ab <check_input_expressions+0x2b8b>
 108b79e:	mov    0x28(%rsp),%r10d
 108b7a3:	mov    0xb8(%rsp),%rdi
 108b7ab:	mov    0xa8(%rsp),%r8
 108b7b3:	mov    0x50(%rsp),%r9d
 108b7b8:	mov    0x80(%rsp),%esi
 108b7bf:	mov    0xb8(%rdi),%eax
 108b7c5:	cmp    0xbc(%rdi),%eax
 108b7cb:	jae    108b800 <check_input_expressions+0x2be0>
 108b7cd:	mov    0xb0(%rdi),%rcx
 108b7d4:	mov    %esi,(%rcx,%rax,4)
 108b7d7:	mov    0xb8(%rdi),%ecx
 108b7dd:	mov    0xa8(%rdi),%rax
 108b7e4:	lea    0x1(%rcx),%edx
 108b7e7:	mov    %edx,0xb8(%rdi)
 108b7ed:	mov    %r13d,(%rax,%rcx,4)
 108b7f1:	jmp    108b80b <check_input_expressions+0x2beb>
 108b7f3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108b800:	mov    (%r12),%rax
 108b804:	movb   $0x1,0x3bd(%rax)
 108b80b:	mov    -0xc(%r8),%eax
 108b80f:	inc    %r15
 108b812:	cmp    %rax,%r15
 108b815:	jae    108b824 <check_input_expressions+0x2c04>
 108b817:	mov    %r9d,%r13d
 108b81a:	cmp    $0xffffffff,%r9d
 108b81e:	jne    108b630 <check_input_expressions+0x2a10>
 108b824:	mov    0x20(%rsp),%edx
 108b828:	mov    0x30(%rsp),%rax
 108b82d:	movzbl 0x5f(%rsp),%esi
 108b832:	movzbl 0x6f(%rsp),%r15d
 108b838:	jmp    108b8af <check_input_expressions+0x2c8f>
 108b83a:	mov    $0xffffffff,%r8d
 108b840:	add    $0xffffffe0,%eax
 108b843:	movq   $0x0,0x98(%rsp)
 108b84f:	cmp    $0x6,%eax
 108b852:	jae    108ba36 <check_input_expressions+0x2e16>
 108b858:	movq   $0x0,0x90(%rsp)
 108b864:	movl   $0x0,0x88(%rsp)
 108b86f:	mov    $0xffffffff,%r9d
 108b875:	jmp    108b8df <check_input_expressions+0x2cbf>
 108b877:	movq   $0x0,0x90(%rsp)
 108b883:	movl   $0x0,0x88(%rsp)
 108b88e:	jmp    108b8af <check_input_expressions+0x2c8f>
 108b890:	mov    0x20(%rsp),%edx
 108b894:	mov    0x30(%rsp),%rax
 108b899:	mov    0x28(%rsp),%r10d
 108b89e:	movzbl 0x5f(%rsp),%esi
 108b8a3:	movq   $0x0,0x90(%rsp)
 108b8af:	cmp    $0x17,%eax
 108b8b2:	mov    $0xffffffff,%r9d
 108b8b8:	mov    %edx,%r8d
 108b8bb:	cmove  %r10d,%r9d
 108b8bf:	cmp    $0x36,%eax
 108b8c2:	mov    $0xffffffff,%eax
 108b8c7:	cmove  %r10d,%r9d
 108b8cb:	test   %r15b,%r15b
 108b8ce:	cmovne 0xc(%rsp),%r8d
 108b8d4:	cmovne %edx,%r9d
 108b8d8:	test   %sil,%sil
 108b8db:	cmovne %eax,%r8d
 108b8df:	mov    0x30(%rsp),%rsi
 108b8e4:	mov    0x10(%rsp),%r14
 108b8e9:	mov    0xb4(%rsp),%ecx
 108b8f0:	mov    %r12,%rdi
 108b8f3:	mov    %r14d,%edx
 108b8f6:	vzeroupper
 108b8f9:	call   10facf0 <check_input_add>
 108b8fe:	cmp    $0xffffffff,%eax
 108b901:	je     108b9e9 <check_input_expressions+0x2dc9>
 108b907:	mov    %eax,%r15d
 108b90a:	mov    0xa8(%r12),%rax
 108b912:	mov    0x70(%rsp),%rbx
 108b917:	mov    %r15d,%edx
 108b91a:	vpmovsxbq -0xbedd23(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108b923:	mov    0x18(%rsp),%r9
 108b928:	mov    $0xffffffff,%r11d
 108b92e:	vxorps %xmm2,%xmm2,%xmm2
 108b932:	mov    (%rax,%r14,4),%eax
 108b936:	mov    0x30(%rbx),%rcx
 108b93a:	mov    %eax,(%rcx,%rdx,4)
 108b93d:	mov    0x208(%r12),%rax
 108b945:	movzwl (%rax,%r14,2),%eax
 108b94a:	test   %eax,%eax
 108b94c:	je     108b955 <check_input_expressions+0x2d35>
 108b94e:	mov    0x38(%rbx),%rcx
 108b952:	mov    %eax,(%rcx,%rdx,4)
 108b955:	mov    0x30(%rsp),%rax
 108b95a:	mov    0xc(%rsp),%r8d
 108b95f:	mov    0x60(%rsp),%r13d
 108b964:	mov    0x20(%rsp),%esi
 108b968:	mov    0x40(%rsp),%r10d
 108b96d:	mov    %rdx,0x50(%rsp)
 108b972:	cmp    $0x38,%eax
 108b975:	jne    108bb2f <check_input_expressions+0x2f0f>
 108b97b:	mov    0x8c(%rbx),%ecx
 108b981:	mov    $0xffffffff,%eax
 108b986:	cmp    %ecx,%esi
 108b988:	jae    108ba76 <check_input_expressions+0x2e56>
 108b98e:	mov    (%rbx),%rdx
 108b991:	jmp    108b9af <check_input_expressions+0x2d8f>
 108b993:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108b9a0:	mov    0x10(%rbx),%rdi
 108b9a4:	mov    (%rdi,%rsi,4),%esi
 108b9a7:	cmp    %ecx,%esi
 108b9a9:	jae    108ba72 <check_input_expressions+0x2e52>
 108b9af:	mov    %esi,%esi
 108b9b1:	mov    (%rdx,%rsi,4),%edi
 108b9b4:	cmp    $0x34,%edi
 108b9b7:	je     108b9a0 <check_input_expressions+0x2d80>
 108b9b9:	cmp    $0x18,%edi
 108b9bc:	je     108b9a0 <check_input_expressions+0x2d80>
 108b9be:	mov    0x8(%rbx),%rcx
 108b9c2:	mov    0x78(%rsp),%rdx
 108b9c7:	mov    (%rcx,%rsi,4),%ecx
 108b9ca:	mov    0x20(%rsp),%esi
 108b9ce:	cmp    (%rdx),%ecx
 108b9d0:	jae    108ba76 <check_input_expressions+0x2e56>
 108b9d6:	mov    (%r12),%rax
 108b9da:	mov    0x238(%rax),%rax
 108b9e1:	mov    (%rax,%rcx,4),%eax
 108b9e4:	jmp    108ba76 <check_input_expressions+0x2e56>
 108b9e9:	vpmovsxbq -0xbeddf2(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108b9f2:	mov    0x18(%rsp),%r9
 108b9f7:	mov    0xc(%rsp),%r8d
 108b9fc:	mov    0x60(%rsp),%r13d
 108ba01:	vxorps %xmm2,%xmm2,%xmm2
 108ba05:	mov    $0xffffffff,%r11d
 108ba0b:	mov    $0xffffffff,%ecx
 108ba10:	mov    0x38(%rsp),%esi
 108ba14:	mov    %ecx,%r15d
 108ba17:	test   %r13b,%r13b
 108ba1a:	jne    108dc7d <check_input_expressions+0x505d>
 108ba20:	mov    (%r12),%rax
 108ba24:	cmpl   $0x0,0x230(%rax)
 108ba2b:	jne    108dc7d <check_input_expressions+0x505d>
 108ba31:	jmp    108dc44 <check_input_expressions+0x5024>
 108ba36:	mov    0x30(%rsp),%rsi
 108ba3b:	mov    $0x0,%eax
 108ba40:	mov    $0xffffffff,%r9d
 108ba46:	movl   $0x0,0x88(%rsp)
 108ba51:	mov    %rax,0x90(%rsp)
 108ba59:	cmp    $0x18,%esi
 108ba5c:	je     108b8e4 <check_input_expressions+0x2cc4>
 108ba62:	cmp    $0xa,%r15b
 108ba66:	sete   %sil
 108ba6a:	or     %r13b,%sil
 108ba6d:	jmp    108b52a <check_input_expressions+0x290a>
 108ba72:	mov    0x20(%rsp),%esi
 108ba76:	mov    0xc8(%rbx),%ecx
 108ba7c:	cmp    0xcc(%rbx),%ecx
 108ba82:	jae    108bb1f <check_input_expressions+0x2eff>
 108ba88:	mov    0x230(%r12),%rdx
 108ba90:	mov    0x98(%rbx),%rsi
 108ba97:	mov    0x50(%rsp),%rdi
 108ba9c:	mov    (%rdx,%r14,4),%edx
 108baa0:	dec    %edx
 108baa2:	imul   $0x2c,%rdx,%rdx
 108baa6:	add    0x228(%r12),%rdx
 108baae:	mov    %ecx,(%rsi,%rdi,4)
 108bab1:	mov    0xa0(%rbx),%rsi
 108bab8:	mov    0x20(%rdx),%ecx
 108babb:	mov    %ecx,(%rsi,%rdi,4)
 108babe:	mov    0xc8(%rbx),%esi
 108bac4:	mov    0xc0(%rbx),%rcx
 108bacb:	lea    0x1(%rsi),%edi
 108bace:	lea    (%rsi,%rsi,8),%rsi
 108bad2:	mov    %edi,0xc8(%rbx)
 108bad8:	vmovups (%rdx),%xmm0
 108badc:	vmovups 0xc(%rdx),%xmm1
 108bae1:	vmovups %xmm1,0xdc(%rsp)
 108baea:	vmovaps %xmm0,0xd0(%rsp)
 108baf3:	mov    %r15d,(%rcx,%rsi,4)
 108baf7:	mov    %eax,0x4(%rcx,%rsi,4)
 108bafb:	vmovaps 0xd0(%rsp),%xmm0
 108bb04:	vmovups %xmm0,0x8(%rcx,%rsi,4)
 108bb0a:	vmovdqu 0xdc(%rsp),%xmm0
 108bb13:	vmovdqu %xmm0,0x14(%rcx,%rsi,4)
 108bb19:	mov    0x20(%rsp),%esi
 108bb1d:	jmp    108bb2a <check_input_expressions+0x2f0a>
 108bb1f:	mov    (%r12),%rax
 108bb23:	movb   $0x1,0x3bd(%rax)
 108bb2a:	mov    0x30(%rsp),%rax
 108bb2f:	and    $0xfffffffe,%eax
 108bb32:	cmp    $0x20,%eax
 108bb35:	jne    108bcfc <check_input_expressions+0x30dc>
 108bb3b:	mov    0x18(%r9),%rcx
 108bb3f:	lea    0x1(%r14),%eax
 108bb43:	cmpl   $0x20,0x30(%rsp)
 108bb48:	mov    0x38(%rbx),%rdx
 108bb4c:	mov    0x50(%rsp),%rdi
 108bb51:	mov    (%rcx,%rax,4),%ecx
 108bb54:	mov    %ecx,(%rdx,%rdi,4)
 108bb57:	jne    108bcfc <check_input_expressions+0x30dc>
 108bb5d:	mov    0x8(%r12),%rcx
 108bb62:	mov    (%r12),%r14
 108bb66:	lea    0x110(%rsp),%r8
 108bb6e:	mov    0x18(%rcx),%rcx
 108bb72:	mov    (%rcx,%rax,4),%eax
 108bb75:	mov    0x10(%r12),%rcx
 108bb7a:	mov    0x270(%rcx),%rcx
 108bb81:	mov    0x10(%rcx),%rdx
 108bb85:	mov    (%rdx,%rax,8),%r13d
 108bb89:	mov    0x4(%rdx,%rax,8),%ebx
 108bb8d:	xor    %edx,%edx
 108bb8f:	add    0x40(%rcx),%r13
 108bb93:	xor    %ecx,%ecx
 108bb95:	mov    %ebx,%esi
 108bb97:	mov    %r13,%rdi
 108bb9a:	call   10fb700 <check_vector_member_decode>
 108bb9f:	test   %al,%al
 108bba1:	jne    108bc67 <check_input_expressions+0x3047>
 108bba7:	mov    0x20(%r12),%rax
 108bbac:	mov    0x8(%rax),%rdx
 108bbb0:	mov    0x10(%rax),%rcx
 108bbb4:	sub    %rdx,%rcx
 108bbb7:	jb     108bc5f <check_input_expressions+0x303f>
 108bbbd:	cmp    %rbx,%rcx
 108bbc0:	jb     108bc5f <check_input_expressions+0x303f>
 108bbc6:	lea    (%rdx,%rbx,1),%rcx
 108bbca:	mov    %rcx,0x8(%rax)
 108bbce:	mov    %rdx,%rcx
 108bbd1:	mov    (%rax),%rax
 108bbd4:	mov    (%r12),%rsi
 108bbd8:	add    %rax,%rcx
 108bbdb:	sete   %cl
 108bbde:	or     %cl,0x3bd(%rsi)
 108bbe4:	add    %rax,%rdx
 108bbe7:	je     108bc67 <check_input_expressions+0x3047>
 108bbe9:	lea    0x110(%rsp),%r8
 108bbf1:	mov    %r13,%rdi
 108bbf4:	mov    %ebx,%esi
 108bbf6:	mov    %ebx,%ecx
 108bbf8:	call   10fb700 <check_vector_member_decode>
 108bbfd:	mov    (%r12),%rcx
 108bc01:	xor    $0x1,%al
 108bc03:	or     %al,0x3bd(%rcx)
 108bc09:	jmp    108bc67 <check_input_expressions+0x3047>
 108bc0b:	mov    0x138(%r12),%rax
 108bc13:	cmpb   $0x0,(%rax,%rcx,1)
 108bc17:	je     108bdb4 <check_input_expressions+0x3194>
 108bc1d:	movzbl %r15b,%eax
 108bc21:	add    $0xfffffff9,%eax
 108bc24:	cmp    $0x3e,%eax
 108bc27:	ja     1088c90 <check_input_expressions+0x70>
 108bc2d:	movabs $0x5c00000000240001,%rcx
 108bc37:	bt     %rax,%rcx
 108bc3b:	jb     108de6a <check_input_expressions+0x524a>
 108bc41:	jmp    1088c90 <check_input_expressions+0x70>
 108bc46:	mov    %r13d,%r8d
 108bc49:	movl   $0x0,0x8c(%rsp)
 108bc54:	xor    %r13d,%r13d
 108bc57:	mov    %r8d,%ecx
 108bc5a:	jmp    108b3fb <check_input_expressions+0x27db>
 108bc5f:	movb   $0x1,0x3bd(%r14)
 108bc67:	mov    (%r12),%rax
 108bc6b:	vpmovsxbq -0xbee074(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108bc74:	mov    0x18(%rsp),%r9
 108bc79:	mov    0xc(%rsp),%r8d
 108bc7e:	mov    0x60(%rsp),%r13d
 108bc83:	mov    0x20(%rsp),%esi
 108bc87:	mov    0x40(%rsp),%r10d
 108bc8c:	mov    $0xffffffff,%r11d
 108bc92:	vxorps %xmm2,%xmm2,%xmm2
 108bc96:	cmpb   $0x0,0x3bd(%rax)
 108bc9d:	jne    108bcf2 <check_input_expressions+0x30d2>
 108bc9f:	cmpb   $0x0,0x11c(%rsp)
 108bca7:	je     108bcf2 <check_input_expressions+0x30d2>
 108bca9:	mov    0xe8(%r14),%ecx
 108bcb0:	cmp    0xec(%r14),%ecx
 108bcb7:	jae    108bceb <check_input_expressions+0x30cb>
 108bcb9:	mov    0xe0(%r14),%rax
 108bcc0:	lea    0x1(%rcx),%edx
 108bcc3:	lea    (%rcx,%rcx,2),%rcx
 108bcc7:	mov    %edx,0xe8(%r14)
 108bcce:	mov    %r15d,(%rax,%rcx,8)
 108bcd2:	movl   $0x0,0x4(%rax,%rcx,8)
 108bcda:	vmovdqu 0x110(%rsp),%xmm0
 108bce3:	vmovdqu %xmm0,0x8(%rax,%rcx,8)
 108bce9:	jmp    108bcf2 <check_input_expressions+0x30d2>
 108bceb:	movb   $0x1,0x3bd(%rax)
 108bcf2:	mov    0x70(%rsp),%rbx
 108bcf7:	mov    0x10(%rsp),%r14
 108bcfc:	cmpb   $0x0,0x8c(%rsp)
 108bd04:	jne    108bd30 <check_input_expressions+0x3110>
 108bd06:	mov    0x30(%rsp),%rax
 108bd0b:	add    $0xffffffde,%eax
 108bd0e:	cmp    $0x22,%eax
 108bd11:	ja     108c6ef <check_input_expressions+0x3acf>
 108bd17:	mov    0x60(%rsp),%r13d
 108bd1c:	movabs $0x700000001,%rcx
 108bd26:	bt     %rax,%rcx
 108bd2a:	jae    108c6ef <check_input_expressions+0x3acf>
 108bd30:	cmpl   $0x22,0x30(%rsp)
 108bd35:	jne    108bf0b <check_input_expressions+0x32eb>
 108bd3b:	mov    (%r12),%rax
 108bd3f:	mov    0x220(%rax),%rcx
 108bd46:	test   %rcx,%rcx
 108bd49:	sete   %dl
 108bd4c:	xor    $0x1,%r10b
 108bd50:	or     %dl,%r10b
 108bd53:	jne    108bf0b <check_input_expressions+0x32eb>
 108bd59:	mov    0x8(%rbx),%rdx
 108bd5d:	mov    %r8d,%esi
 108bd60:	mov    (%rdx,%rsi,4),%edx
 108bd63:	mov    0x78(%rsp),%rsi
 108bd68:	cmp    (%rsi),%edx
 108bd6a:	mov    0x20(%rsp),%esi
 108bd6e:	jae    108bf0b <check_input_expressions+0x32eb>
 108bd74:	mov    (%rcx,%rdx,4),%ecx
 108bd77:	test   %ecx,%ecx
 108bd79:	je     108bf0b <check_input_expressions+0x32eb>
 108bd7f:	mov    0x118(%rbx),%edx
 108bd85:	cmp    0x11c(%rbx),%edx
 108bd8b:	jae    108bf04 <check_input_expressions+0x32e4>
 108bd91:	mov    0x110(%rbx),%rax
 108bd98:	lea    0x1(%rdx),%esi
 108bd9b:	dec    %ecx
 108bd9d:	mov    %esi,0x118(%rbx)
 108bda3:	mov    0x20(%rsp),%esi
 108bda7:	mov    %r15d,(%rax,%rdx,8)
 108bdab:	mov    %ecx,0x4(%rax,%rdx,8)
 108bdaf:	jmp    108bf0b <check_input_expressions+0x32eb>
 108bdb4:	cmp    $0x2,%r15b
 108bdb8:	jne    108c78f <check_input_expressions+0x3b6f>
 108bdbe:	cmp    $0x2,%dil
 108bdc2:	jne    108c78f <check_input_expressions+0x3b6f>
 108bdc8:	mov    0xa0(%r12),%rax
 108bdd0:	cmpl   $0x0,(%rax,%rcx,4)
 108bdd4:	je     1088c90 <check_input_expressions+0x70>
 108bdda:	mov    $0xffffffff,%ecx
 108bddf:	mov    $0xffffffff,%r8d
 108bde5:	mov    $0xffffffff,%r9d
 108bdeb:	mov    0x10(%rsp),%rdx
 108bdf0:	mov    %r12,%rdi
 108bdf3:	xor    %esi,%esi
 108bdf5:	vzeroupper
 108bdf8:	call   10facf0 <check_input_add>
 108bdfd:	vpmovsxbq -0xbee206(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108be06:	mov    0x18(%rsp),%r9
 108be0b:	mov    $0xffffffff,%r11d
 108be11:	vxorps %xmm2,%xmm2,%xmm2
 108be15:	cmp    $0xffffffff,%eax
 108be18:	je     1088c90 <check_input_expressions+0x70>
 108be1e:	mov    (%r12),%rsi
 108be22:	mov    %eax,%r15d
 108be25:	mov    0xa0(%r12),%rax
 108be2d:	mov    0x10(%rsp),%rdx
 108be32:	mov    0x238(%rsi),%rcx
 108be39:	mov    (%rax,%rdx,4),%eax
 108be3c:	mov    (%rcx,%rdx,4),%ecx
 108be3f:	mov    0x100(%r12),%rdx
 108be47:	movzbl (%rdx,%rcx,1),%r8d
 108be4c:	xor    %edx,%edx
 108be4e:	cmp    $0x3,%r8b
 108be52:	je     108be6f <check_input_expressions+0x324f>
 108be54:	mov    0x18(%r12),%rdx
 108be59:	mov    %eax,%r9d
 108be5c:	shr    $0x3,%r9d
 108be60:	mov    (%rdx),%rdi
 108be63:	xor    %edx,%edx
 108be65:	cmpb   $0xb,(%rdi,%r9,1)
 108be6a:	sete   %dl
 108be6d:	inc    %edx
 108be6f:	mov    0x118(%r12),%r9
 108be77:	xor    %edi,%edi
 108be79:	cmp    $0x3,%r8b
 108be7d:	sete   %dil
 108be81:	cmpb   $0x0,(%r9,%rcx,1)
 108be86:	je     108bea2 <check_input_expressions+0x3282>
 108be88:	mov    0x278(%rsi),%r9
 108be8f:	xor    %r10d,%r10d
 108be92:	cmpb   $0x0,(%r9,%rcx,1)
 108be97:	sete   %r10b
 108be9b:	shl    $0x7,%r10d
 108be9f:	or     %r10d,%edi
 108bea2:	mov    0x120(%r12),%r10
 108beaa:	xor    %r9d,%r9d
 108bead:	mov    $0x0,%r11d
 108beb3:	mov    $0x0,%r14d
 108beb9:	cmpb   $0x0,(%r10,%rcx,1)
 108bebe:	setne  %bpl
 108bec2:	xor    %r10d,%r10d
 108bec5:	cmp    $0x3,%r8b
 108bec9:	setne  %r8b
 108becd:	jne    108bee7 <check_input_expressions+0x32c7>
 108becf:	mov    0x340(%r12),%rbx
 108bed7:	mov    %rcx,%r14
 108beda:	shl    $0x4,%r14
 108bede:	mov    (%rbx,%r14,1),%r11
 108bee2:	mov    0x8(%rbx,%r14,1),%r14
 108bee7:	mov    0x220(%rsi),%rsi
 108beee:	test   %rsi,%rsi
 108bef1:	je     108cbbd <check_input_expressions+0x3f9d>
 108bef7:	mov    0x10(%rsp),%rbx
 108befc:	mov    (%rsi,%rbx,4),%esi
 108beff:	jmp    108cbbf <check_input_expressions+0x3f9f>
 108bf04:	movb   $0x1,0x3bd(%rax)
 108bf0b:	cmpb   $0x0,0x98(%rsp)
 108bf13:	mov    0x88(%rsp),%edi
 108bf1a:	jne    108bf22 <check_input_expressions+0x3302>
 108bf1c:	mov    0xb8(%rbx),%edi
 108bf22:	mov    0x98(%rbx),%rcx
 108bf29:	mov    0x50(%rsp),%rdx
 108bf2e:	xor    %eax,%eax
 108bf30:	cmpl   $0x22,0x30(%rsp)
 108bf35:	mov    %edi,(%rcx,%rdx,4)
 108bf38:	sete   %al
 108bf3b:	cmovne %r8d,%esi
 108bf3f:	mov    %ebp,%ecx
 108bf41:	mov    0xa0(%rbx),%rdi
 108bf48:	sub    %eax,%ecx
 108bf4a:	cmp    $0xffffffff,%esi
 108bf4d:	mov    %ecx,(%rdi,%rdx,4)
 108bf50:	sete   %cl
 108bf53:	or     0x98(%rsp),%cl
 108bf5a:	je     108bf91 <check_input_expressions+0x3371>
 108bf5c:	jmp    108c010 <check_input_expressions+0x33f0>
 108bf61:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108bf70:	mov    (%r12),%rax
 108bf74:	movb   $0x1,0x3bd(%rax)
 108bf7b:	mov    %esi,%eax
 108bf7d:	mov    0x390(%r12),%rcx
 108bf85:	mov    (%rcx,%rax,4),%esi
 108bf88:	cmp    $0xffffffff,%esi
 108bf8b:	je     108c010 <check_input_expressions+0x33f0>
 108bf91:	mov    0xb8(%rbx),%ecx
 108bf97:	cmp    0xbc(%rbx),%ecx
 108bf9d:	jae    108bf70 <check_input_expressions+0x3350>
 108bf9f:	mov    0x8(%rbx),%rdx
 108bfa3:	mov    %esi,%eax
 108bfa5:	mov    %r8d,%r10d
 108bfa8:	mov    %esi,%r13d
 108bfab:	mov    (%rdx,%rax,4),%edi
 108bfae:	mov    0x8(%r12),%rdx
 108bfb3:	mov    0x30(%rdx),%edx
 108bfb6:	cs nopw 0x0(%rax,%rax,1)
 108bfc0:	mov    %edi,%esi
 108bfc2:	cmp    %edx,%edi
 108bfc4:	jae    108bfd9 <check_input_expressions+0x33b9>
 108bfc6:	mov    0x370(%r12),%rdi
 108bfce:	mov    %esi,%r8d
 108bfd1:	mov    (%rdi,%r8,4),%edi
 108bfd5:	cmp    %esi,%edi
 108bfd7:	jb     108bfc0 <check_input_expressions+0x33a0>
 108bfd9:	mov    0xb0(%rbx),%rdx
 108bfe0:	mov    %r10d,%r8d
 108bfe3:	mov    %esi,(%rdx,%rcx,4)
 108bfe6:	mov    0xb8(%rbx),%edx
 108bfec:	mov    0xa8(%rbx),%rcx
 108bff3:	lea    0x1(%rdx),%esi
 108bff6:	mov    %esi,0xb8(%rbx)
 108bffc:	mov    %r13d,(%rcx,%rdx,4)
 108c000:	mov    0x390(%r12),%rcx
 108c008:	mov    (%rcx,%rax,4),%esi
 108c00b:	cmp    $0xffffffff,%esi
 108c00e:	jne    108bf91 <check_input_expressions+0x3371>
 108c010:	cmpb   $0x0,0x98(%rsp)
 108c018:	je     108c0ce <check_input_expressions+0x34ae>
 108c01e:	mov    (%r12),%rcx
 108c022:	mov    0xf8(%rbx),%eax
 108c028:	cmp    0xfc(%rbx),%eax
 108c02e:	jae    108c0c7 <check_input_expressions+0x34a7>
 108c034:	mov    0x1f8(%rcx),%rdx
 108c03b:	mov    0x208(%rcx),%rsi
 108c042:	mov    0x218(%rcx),%rcx
 108c049:	lea    0x1(%rax),%edi
 108c04c:	lea    (%rax,%rax,4),%rax
 108c050:	mov    (%rcx,%r14,4),%ecx
 108c054:	shl    $0x5,%rcx
 108c058:	mov    -0x20(%rsi,%rcx,1),%ecx
 108c05c:	mov    0xf0(%rbx),%rsi
 108c063:	mov    %edi,0xf8(%rbx)
 108c069:	mov    0x280(%r12),%r10
 108c071:	imul   $0x130,%rcx,%rcx
 108c078:	cmpb   $0x0,(%r10,%r14,1)
 108c07d:	mov    (%rdx,%rcx,1),%rdi
 108c081:	mov    0x118(%rdx,%rcx,1),%rcx
 108c089:	mov    0x90(%rsp),%rdx
 108c091:	mov    %r15d,(%rsi,%rax,8)
 108c095:	movl   $0x0,0x4(%rsi,%rax,8)
 108c09d:	mov    %rdi,0x8(%rsi,%rax,8)
 108c0a2:	mov    %rcx,0x10(%rsi,%rax,8)
 108c0a7:	mov    %rdx,0x18(%rsi,%rax,8)
 108c0ac:	movl   $0x0,0x20(%rsi,%rax,8)
 108c0b4:	setne  0x24(%rsi,%rax,8)
 108c0b9:	movb   $0x0,0x25(%rsi,%rax,8)
 108c0be:	movw   $0x0,0x26(%rsi,%rax,8)
 108c0c5:	jmp    108c0ce <check_input_expressions+0x34ae>
 108c0c7:	movb   $0x1,0x3bd(%rcx)
 108c0ce:	mov    0x30(%rsp),%rax
 108c0d3:	mov    0x60(%rsp),%r13d
 108c0d8:	add    $0xffffffc3,%eax
 108c0db:	cmp    $0x3,%eax
 108c0de:	jae    108c181 <check_input_expressions+0x3561>
 108c0e4:	mov    0xd8(%rbx),%eax
 108c0ea:	cmp    0xdc(%rbx),%eax
 108c0f0:	jae    108c1a9 <check_input_expressions+0x3589>
 108c0f6:	mov    0x370(%r12),%rcx
 108c0fe:	mov    %r14d,%esi
 108c101:	mov    (%rcx,%r14,4),%ecx
 108c105:	lea    0x2(%rcx),%r10d
 108c109:	cmp    %r14d,%ecx
 108c10c:	cmovb  %r10d,%esi
 108c110:	mov    %esi,%edx
 108c112:	cmp    %r14d,%esi
 108c115:	jae    108c43e <check_input_expressions+0x381e>
 108c11b:	mov    0x10(%r9),%rcx
 108c11f:	mov    %esi,%edi
 108c121:	jmp    108c14e <check_input_expressions+0x352e>
 108c123:	cmp    $0xa,%r8d
 108c127:	jne    108c169 <check_input_expressions+0x3549>
 108c129:	mov    0x60(%r9),%r8
 108c12d:	mov    (%r8,%rdx,4),%r8d
 108c131:	lea    0x1(%r8),%edx
 108c135:	cmp    %r14d,%r8d
 108c138:	cmovae %r14d,%edx
 108c13c:	cmp    %edi,%r8d
 108c13f:	cmovbe %r14d,%edx
 108c143:	mov    %edx,%edi
 108c145:	cmp    %r14d,%edx
 108c148:	jae    108c43e <check_input_expressions+0x381e>
 108c14e:	mov    %edi,%edx
 108c150:	movzbl (%rcx,%rdx,1),%r8d
 108c155:	cmp    $0x9,%r8d
 108c159:	jg     108c123 <check_input_expressions+0x3503>
 108c15b:	cmp    $0x6,%r8d
 108c15f:	je     108c129 <check_input_expressions+0x3509>
 108c161:	cmp    $0x8,%r8d
 108c165:	je     108c129 <check_input_expressions+0x3509>
 108c167:	jmp    108c173 <check_input_expressions+0x3553>
 108c169:	cmp    $0x33,%r8d
 108c16d:	je     108c43c <check_input_expressions+0x381c>
 108c173:	inc    %edi
 108c175:	mov    %edi,%edx
 108c177:	cmp    %r14d,%edx
 108c17a:	jb     108c14e <check_input_expressions+0x352e>
 108c17c:	jmp    108c43e <check_input_expressions+0x381e>
 108c181:	mov    0x30(%rsp),%rax
 108c186:	cmp    $0x42,%eax
 108c189:	jne    108c6f4 <check_input_expressions+0x3ad4>
 108c18f:	mov    0x208(%r12),%rax
 108c197:	cmpw   $0x312,(%rax,%r14,2)
 108c19e:	je     108c0e4 <check_input_expressions+0x34c4>
 108c1a4:	jmp    108c6ef <check_input_expressions+0x3acf>
 108c1a9:	mov    (%r12),%rax
 108c1ad:	movb   $0x1,0x3bd(%rax)
 108c1b4:	jmp    108c6ef <check_input_expressions+0x3acf>
 108c1b9:	lea    0x1c(%rsi,%rcx,4),%r11
 108c1be:	and    $0xfffffffffffffff8,%r9
 108c1c2:	mov    $0xffffffff,%r15d
 108c1c8:	mov    %rbx,0x30(%rsp)
 108c1cd:	mov    %r12,0x20(%rsp)
 108c1d2:	xor    %r10d,%r10d
 108c1d5:	xor    %r8d,%r8d
 108c1d8:	mov    -0x1c(%r11,%r8,4),%eax
 108c1dd:	mov    -0x18(%r11,%r8,4),%ebx
 108c1e2:	cmp    %ecx,%eax
 108c1e4:	setb   %r12b
 108c1e8:	cmp    %edx,%eax
 108c1ea:	setae  %al
 108c1ed:	or     %r12b,%al
 108c1f0:	lea    (%r8,%rcx,1),%r12d
 108c1f4:	movzbl %al,%eax
 108c1f7:	add    %eax,%r10d
 108c1fa:	test   %al,%al
 108c1fc:	cmovne %r12d,%r15d
 108c200:	cmp    %ecx,%ebx
 108c202:	lea    0x1(%rcx,%r8,1),%r12d
 108c207:	setb   %al
 108c20a:	cmp    %edx,%ebx
 108c20c:	setae  %bl
 108c20f:	or     %al,%bl
 108c211:	movzbl %bl,%eax
 108c214:	mov    -0x14(%r11,%r8,4),%ebx
 108c219:	test   %al,%al
 108c21b:	cmove  %r15d,%r12d
 108c21f:	cmp    %ecx,%ebx
 108c221:	setb   %r15b
 108c225:	cmp    %edx,%ebx
 108c227:	setae  %bl
 108c22a:	or     %r15b,%bl
 108c22d:	movzbl %bl,%ebx
 108c230:	add    %ebx,%eax
 108c232:	add    %r10d,%eax
 108c235:	test   %bl,%bl
 108c237:	mov    -0x10(%r11,%r8,4),%ebx
 108c23c:	lea    0x2(%rcx,%r8,1),%r10d
 108c241:	cmove  %r12d,%r10d
 108c245:	lea    0x3(%rcx,%r8,1),%r12d
 108c24a:	cmp    %ecx,%ebx
 108c24c:	setb   %r15b
 108c250:	cmp    %edx,%ebx
 108c252:	setae  %bl
 108c255:	or     %r15b,%bl
 108c258:	movzbl %bl,%r15d
 108c25c:	test   %r15b,%r15b
 108c25f:	cmove  %r10d,%r12d
 108c263:	mov    -0xc(%r11,%r8,4),%r10d
 108c268:	cmp    %ecx,%r10d
 108c26b:	setb   %bl
 108c26e:	cmp    %edx,%r10d
 108c271:	setae  %r10b
 108c275:	or     %bl,%r10b
 108c278:	lea    0x4(%rcx,%r8,1),%ebx
 108c27d:	movzbl %r10b,%r10d
 108c281:	add    %r10d,%r15d
 108c284:	test   %r10b,%r10b
 108c287:	mov    -0x8(%r11,%r8,4),%r10d
 108c28c:	cmove  %r12d,%ebx
 108c290:	cmp    %ecx,%r10d
 108c293:	setb   %r12b
 108c297:	cmp    %edx,%r10d
 108c29a:	setae  %r10b
 108c29e:	or     %r12b,%r10b
 108c2a1:	movzbl %r10b,%r10d
 108c2a5:	add    %r10d,%r15d
 108c2a8:	add    %eax,%r15d
 108c2ab:	test   %r10b,%r10b
 108c2ae:	mov    -0x4(%r11,%r8,4),%r10d
 108c2b3:	lea    0x5(%rcx,%r8,1),%eax
 108c2b8:	cmove  %ebx,%eax
 108c2bb:	cmp    %ecx,%r10d
 108c2be:	setb   %bl
 108c2c1:	cmp    %edx,%r10d
 108c2c4:	setae  %r10b
 108c2c8:	or     %bl,%r10b
 108c2cb:	lea    0x6(%rcx,%r8,1),%ebx
 108c2d0:	movzbl %r10b,%r10d
 108c2d4:	test   %r10b,%r10b
 108c2d7:	cmove  %eax,%ebx
 108c2da:	mov    (%r11,%r8,4),%eax
 108c2de:	cmp    %ecx,%eax
 108c2e0:	setb   %r12b
 108c2e4:	cmp    %edx,%eax
 108c2e6:	setae  %al
 108c2e9:	or     %r12b,%al
 108c2ec:	movzbl %al,%eax
 108c2ef:	add    %eax,%r10d
 108c2f2:	add    %r15d,%r10d
 108c2f5:	lea    0x7(%rcx,%r8,1),%r15d
 108c2fa:	test   %al,%al
 108c2fc:	cmove  %ebx,%r15d
 108c300:	add    $0x8,%r8
 108c304:	cmp    %r8,%r9
 108c307:	jne    108c1d8 <check_input_expressions+0x35b8>
 108c30d:	test   %rdi,%rdi
 108c310:	je     108c86d <check_input_expressions+0x3c4d>
 108c316:	mov    0x20(%rsp),%r12
 108c31b:	mov    0x30(%rsp),%rbx
 108c320:	add    %rcx,%r8
 108c323:	mov    $0xffffffff,%r11d
 108c329:	mov    (%rsi,%r8,4),%eax
 108c32d:	cmp    %ecx,%eax
 108c32f:	setb   %r9b
 108c333:	cmp    %edx,%eax
 108c335:	setae  %al
 108c338:	or     %r9b,%al
 108c33b:	movzbl %al,%eax
 108c33e:	add    %eax,%r10d
 108c341:	test   %al,%al
 108c343:	cmovne %r8d,%r15d
 108c347:	inc    %r8
 108c34a:	dec    %rdi
 108c34d:	jne    108c329 <check_input_expressions+0x3709>
 108c34f:	mov    0x18(%rsp),%r9
 108c354:	cmp    $0x1,%r10d
 108c358:	mov    $0xffffffff,%eax
 108c35d:	cmovne %eax,%r15d
 108c361:	cmp    0x30(%rbx),%r15d
 108c365:	jae    108c3ee <check_input_expressions+0x37ce>
 108c36b:	mov    0x2c0(%r13),%rax
 108c372:	mov    %r15d,%ecx
 108c375:	mov    (%rax,%rcx,4),%ecx
 108c378:	cmp    $0xffffffff,%ecx
 108c37b:	je     108c3ee <check_input_expressions+0x37ce>
 108c37d:	mov    $0x39,%esi
 108c382:	mov    $0xffffffff,%r8d
 108c388:	mov    $0xffffffff,%r9d
 108c38e:	mov    0x10(%rsp),%rdx
 108c393:	mov    %r12,%rdi
 108c396:	vzeroupper
 108c399:	call   10facf0 <check_input_add>
 108c39e:	vpmovsxbq -0xbee7a7(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108c3a7:	mov    0x18(%rsp),%r9
 108c3ac:	mov    $0xffffffff,%r11d
 108c3b2:	vxorps %xmm2,%xmm2,%xmm2
 108c3b6:	cmp    $0xffffffff,%eax
 108c3b9:	je     1088c90 <check_input_expressions+0x70>
 108c3bf:	mov    (%r12),%rcx
 108c3c3:	mov    %eax,%r15d
 108c3c6:	mov    0x38(%rcx),%rax
 108c3ca:	mov    %r15d,%ecx
 108c3cd:	mov    %r14d,(%rax,%rcx,4)
 108c3d1:	mov    %r15d,0x10(%rbp)
 108c3d5:	cmpl   $0xffffffff,0x0(%rbp)
 108c3d9:	jne    1088c90 <check_input_expressions+0x70>
 108c3df:	cmpb   $0x0,0x20(%rbp)
 108c3e3:	je     1088c90 <check_input_expressions+0x70>
 108c3e9:	jmp    108dc87 <check_input_expressions+0x5067>
 108c3ee:	mov    0x230(%r13),%eax
 108c3f5:	cmp    0x234(%r13),%eax
 108c3fc:	jae    1088c81 <check_input_expressions+0x61>
 108c402:	movzbl 0x3bd(%r13),%ecx
 108c40a:	lea    0x1(%rax),%esi
 108c40d:	mov    0x228(%r13),%rdx
 108c414:	lea    (%rax,%rax,2),%rax
 108c418:	mov    %esi,0x230(%r13)
 108c41f:	mov    0x10(%rsp),%rsi
 108c424:	lea    0x1(%rcx,%rcx,2),%ecx
 108c428:	mov    %esi,(%rdx,%rax,4)
 108c42b:	mov    %ecx,0x4(%rdx,%rax,4)
 108c42f:	movl   $0x0,0x8(%rdx,%rax,4)
 108c437:	jmp    1088c90 <check_input_expressions+0x70>
 108c43c:	mov    %edi,%edx
 108c43e:	mov    0xd0(%rbx),%r8
 108c445:	lea    0x1(%rax),%edi
 108c448:	imul   $0x78,%rax,%rax
 108c44c:	cmpl   $0x42,0x30(%rsp)
 108c451:	vpxor  %xmm0,%xmm0,%xmm0
 108c455:	mov    %edi,0xd8(%rbx)
 108c45b:	lea    (%r8,%rax,1),%rcx
 108c45f:	mov    %r15d,(%r8,%rax,1)
 108c463:	vmovdqu64 %zmm0,0x4(%r8,%rax,1)
 108c46e:	vmovdqu64 %zmm0,0x38(%r8,%rax,1)
 108c479:	mov    %rcx,0x80(%rsp)
 108c481:	jne    108c66c <check_input_expressions+0x3a4c>
 108c487:	mov    0xc(%rsp),%r8d
 108c48c:	mov    0x60(%rsp),%r13d
 108c491:	mov    %r10d,0x40(%rsp)
 108c496:	mov    %ebp,%r10d
 108c499:	sub    $0x2,%r10d
 108c49d:	mov    $0x0,%eax
 108c4a2:	cmovb  %eax,%r10d
 108c4a6:	jbe    108c699 <check_input_expressions+0x3a79>
 108c4ac:	mov    0x20(%r12),%rax
 108c4b1:	mov    0x8(%rax),%rdi
 108c4b5:	mov    0x10(%rax),%rcx
 108c4b9:	sub    %rdi,%rcx
 108c4bc:	jb     108c728 <check_input_expressions+0x3b08>
 108c4c2:	mov    %r10d,%edx
 108c4c5:	cmp    %rdx,%rcx
 108c4c8:	jb     108c728 <check_input_expressions+0x3b08>
 108c4ce:	lea    (%rdi,%rdx,1),%rcx
 108c4d2:	mov    %rcx,0x8(%rax)
 108c4d6:	mov    %rdi,%rcx
 108c4d9:	mov    (%rax),%rax
 108c4dc:	mov    (%r12),%rsi
 108c4e0:	add    %rax,%rcx
 108c4e3:	sete   %cl
 108c4e6:	or     %cl,0x3bd(%rsi)
 108c4ec:	add    %rax,%rdi
 108c4ef:	je     108c733 <check_input_expressions+0x3b13>
 108c4f5:	xor    %esi,%esi
 108c4f7:	mov    %r10d,0x28(%rsp)
 108c4fc:	mov    %rdi,0x20(%rsp)
 108c501:	vzeroupper
 108c504:	call   788120 <memset@plt>
 108c509:	mov    0x40(%rsp),%esi
 108c50d:	cmp    %r14d,%esi
 108c510:	jae    108c630 <check_input_expressions+0x3a10>
 108c516:	mov    %ebp,%ebx
 108c518:	xor    %r14d,%r14d
 108c51b:	mov    0x8(%r12),%rax
 108c520:	mov    %esi,%edx
 108c522:	mov    0x10(%rax),%rcx
 108c526:	jmp    108c554 <check_input_expressions+0x3934>
 108c528:	cmp    $0xa,%edi
 108c52b:	jne    108c56d <check_input_expressions+0x394d>
 108c52d:	mov    0x60(%rax),%rdi
 108c531:	mov    (%rdi,%r8,4),%r8d
 108c535:	mov    0x10(%rsp),%rdi
 108c53a:	lea    0x1(%r8),%r13d
 108c53e:	cmp    %edi,%r8d
 108c541:	cmovae %edi,%r13d
 108c545:	cmp    %edx,%r8d
 108c548:	cmovbe %edi,%r13d
 108c54c:	mov    %r13d,%edx
 108c54f:	cmp    %edi,%r13d
 108c552:	jae    108c586 <check_input_expressions+0x3966>
 108c554:	mov    %edx,%r8d
 108c557:	movzbl (%rcx,%r8,1),%edi
 108c55c:	cmp    $0x9,%edi
 108c55f:	jg     108c528 <check_input_expressions+0x3908>
 108c561:	cmp    $0x6,%edi
 108c564:	je     108c52d <check_input_expressions+0x390d>
 108c566:	cmp    $0x8,%edi
 108c569:	je     108c52d <check_input_expressions+0x390d>
 108c56b:	jmp    108c572 <check_input_expressions+0x3952>
 108c56d:	cmp    $0x33,%edi
 108c570:	je     108c583 <check_input_expressions+0x3963>
 108c572:	mov    0x10(%rsp),%rdi
 108c577:	inc    %edx
 108c579:	mov    %edx,%r13d
 108c57c:	cmp    %edi,%r13d
 108c57f:	jb     108c554 <check_input_expressions+0x3934>
 108c581:	jmp    108c586 <check_input_expressions+0x3966>
 108c583:	mov    %edx,%r13d
 108c586:	cmp    $0x2,%r14
 108c58a:	jb     108c617 <check_input_expressions+0x39f7>
 108c590:	vpxor  %xmm0,%xmm0,%xmm0
 108c594:	vmovdqu64 %zmm0,0x130(%rsp)
 108c59f:	vmovdqu64 %zmm0,0x110(%rsp)
 108c5aa:	mov    %r12,%rdi
 108c5ad:	mov    %r13d,%edx
 108c5b0:	xor    %ecx,%ecx
 108c5b2:	mov    $0x1,%r8d
 108c5b8:	lea    0x110(%rsp),%r9
 108c5c0:	push   $0x0
 108c5c2:	lea    0xf8(%rsp),%rax
 108c5ca:	push   %rax
 108c5cb:	vzeroupper
 108c5ce:	call   10c1fc0 <check_input_constant_read>
 108c5d3:	add    $0x10,%rsp
 108c5d7:	test   %al,%al
 108c5d9:	je     108c617 <check_input_expressions+0x39f7>
 108c5db:	cmpl   $0x1,0x11c(%rsp)
 108c5e3:	jne    108c617 <check_input_expressions+0x39f7>
 108c5e5:	cmpl   $0x0,0x164(%rsp)
 108c5ed:	jne    108c617 <check_input_expressions+0x39f7>
 108c5ef:	mov    0x118(%rsp),%eax
 108c5f6:	test   $0x10,%al
 108c5f8:	jne    108c617 <check_input_expressions+0x39f7>
 108c5fa:	mov    0x20(%rsp),%rdx
 108c5ff:	mov    %eax,%ecx
 108c601:	shr    $0x9,%eax
 108c604:	mov    $0x1,%esi
 108c609:	and    $0x2,%eax
 108c60c:	test   $0x1,%cl
 108c60f:	cmovne %esi,%eax
 108c612:	mov    %al,-0x2(%rdx,%r14,1)
 108c617:	inc    %r13d
 108c61a:	cmp    0x10(%rsp),%r13d
 108c61f:	jae    108c630 <check_input_expressions+0x3a10>
 108c621:	inc    %r14
 108c624:	mov    %r13d,%esi
 108c627:	cmp    %rbx,%r14
 108c62a:	jb     108c51b <check_input_expressions+0x38fb>
 108c630:	vpmovsxbq -0xbeea39(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108c639:	mov    0x80(%rsp),%rax
 108c641:	mov    0x20(%rsp),%rcx
 108c646:	mov    0x28(%rsp),%edx
 108c64a:	mov    0x18(%rsp),%r9
 108c64f:	mov    0x70(%rsp),%rbx
 108c654:	mov    0x10(%rsp),%r14
 108c659:	vxorps %xmm2,%xmm2,%xmm2
 108c65d:	mov    $0xffffffff,%r11d
 108c663:	mov    %rcx,0x20(%rax)
 108c667:	mov    %edx,0x28(%rax)
 108c66a:	jmp    108c68f <check_input_expressions+0x3a6f>
 108c66c:	mov    %r12,%rdi
 108c66f:	vzeroupper
 108c672:	call   10d4760 <check_input_builtin_evidence>
 108c677:	vpmovsxbq -0xbeea80(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108c680:	mov    0x18(%rsp),%r9
 108c685:	mov    $0xffffffff,%r11d
 108c68b:	vxorps %xmm2,%xmm2,%xmm2
 108c68f:	mov    0xc(%rsp),%r8d
 108c694:	mov    0x60(%rsp),%r13d
 108c699:	mov    0x208(%r12),%rax
 108c6a1:	cmpw   $0x130,(%rax,%r14,2)
 108c6a8:	jne    108c6ef <check_input_expressions+0x3acf>
 108c6aa:	mov    0x30(%rsp),%rax
 108c6af:	cmp    $0x1,%ebp
 108c6b2:	jne    108c6f4 <check_input_expressions+0x3ad4>
 108c6b4:	mov    %r12,%rdi
 108c6b7:	mov    %r8d,%esi
 108c6ba:	vzeroupper
 108c6bd:	call   10faea0 <check_input_builtin_syntax_effects>
 108c6c2:	mov    0x80(%rsp),%rcx
 108c6ca:	vpmovsxbq -0xbeead3(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108c6d3:	mov    0xc(%rsp),%r8d
 108c6d8:	mov    0x18(%rsp),%r9
 108c6dd:	mov    $0xffffffff,%r11d
 108c6e3:	vxorps %xmm2,%xmm2,%xmm2
 108c6e7:	mov    $0x1,%ebp
 108c6ec:	mov    %al,0x18(%rcx)
 108c6ef:	mov    0x30(%rsp),%rax
 108c6f4:	cmp    $0x23,%eax
 108c6f7:	je     108c742 <check_input_expressions+0x3b22>
 108c6f9:	mov    0x148(%r12),%rax
 108c701:	cmpb   $0x0,(%rax,%r14,1)
 108c706:	je     108c742 <check_input_expressions+0x3b22>
 108c708:	mov    0x40(%rbx),%rax
 108c70c:	mov    0x50(%rsp),%rcx
 108c711:	mov    0x38(%rsp),%esi
 108c715:	orb    $0x4,(%rax,%rcx,1)
 108c719:	cmp    $0xffffffff,%r15d
 108c71d:	jne    108dc87 <check_input_expressions+0x5067>
 108c723:	jmp    108de5d <check_input_expressions+0x523d>
 108c728:	mov    (%r12),%rax
 108c72c:	movb   $0x1,0x3bd(%rax)
 108c733:	mov    0x30(%rsp),%rax
 108c738:	mov    0x60(%rsp),%r13d
 108c73d:	cmp    $0x23,%eax
 108c740:	jne    108c6f9 <check_input_expressions+0x3ad9>
 108c742:	cmpl   $0x23,0x30(%rsp)
 108c747:	jne    108c777 <check_input_expressions+0x3b57>
 108c749:	mov    (%r12),%rax
 108c74d:	mov    0x150(%r12),%rcx
 108c755:	mov    0x38(%rsp),%esi
 108c759:	mov    0x2a8(%rax),%rax
 108c760:	mov    (%rcx,%r14,4),%ecx
 108c764:	mov    %r15d,(%rax,%rcx,4)
 108c768:	cmp    $0xffffffff,%r15d
 108c76c:	jne    108dc87 <check_input_expressions+0x5067>
 108c772:	jmp    108de5d <check_input_expressions+0x523d>
 108c777:	mov    %r15d,%ecx
 108c77a:	mov    0x38(%rsp),%esi
 108c77e:	mov    %ecx,%r15d
 108c781:	test   %r13b,%r13b
 108c784:	je     108ba20 <check_input_expressions+0x2e00>
 108c78a:	jmp    108dc7d <check_input_expressions+0x505d>
 108c78f:	cmp    $0x2,%r15b
 108c793:	jne    108c882 <check_input_expressions+0x3c62>
 108c799:	lea    -0x3(%rdi),%eax
 108c79c:	cmp    $0x1,%al
 108c79e:	ja     108c882 <check_input_expressions+0x3c62>
 108c7a4:	mov    0x78(%rsp),%rax
 108c7a9:	mov    (%rax),%r14d
 108c7ac:	cmp    %r14d,%ecx
 108c7af:	jae    108c7c4 <check_input_expressions+0x3ba4>
 108c7b1:	mov    0x18(%r9),%rax
 108c7b5:	mov    (%rax,%rcx,4),%eax
 108c7b8:	add    $0xffffffbe,%eax
 108c7bb:	cmp    $0x3,%eax
 108c7be:	jb     108c8aa <check_input_expressions+0x3c8a>
 108c7c4:	lea    0x110(%rsp),%rdi
 108c7cc:	mov    %rcx,%rbx
 108c7cf:	mov    %r8d,%r14d
 108c7d2:	mov    %r12,%rsi
 108c7d5:	mov    %ebx,%edx
 108c7d7:	vzeroupper
 108c7da:	call   10d15e0 <check_input_literal>
 108c7df:	cmpb   $0x0,0x132(%rsp)
 108c7e7:	je     108cb20 <check_input_expressions+0x3f00>
 108c7ed:	mov    $0xffffffff,%ecx
 108c7f2:	mov    $0xffffffff,%r8d
 108c7f8:	mov    $0xffffffff,%r9d
 108c7fe:	mov    $0xffffffff,%r15d
 108c804:	mov    %r12,%rdi
 108c807:	xor    %esi,%esi
 108c809:	mov    %ebx,%edx
 108c80b:	call   10facf0 <check_input_add>
 108c810:	vpmovsxbq -0xbeec19(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108c819:	mov    0x18(%rsp),%r9
 108c81e:	mov    $0xffffffff,%r11d
 108c824:	vxorps %xmm2,%xmm2,%xmm2
 108c828:	cmp    $0xffffffff,%eax
 108c82b:	je     108ce6d <check_input_expressions+0x424d>
 108c831:	mov    0x110(%rsp),%ecx
 108c838:	mov    0x118(%rsp),%rdx
 108c840:	fldt   0x120(%rsp)
 108c847:	testb  $0x1,0x131(%rsp)
 108c84f:	mov    0x70(%rsp),%r10
 108c854:	je     108cdf6 <check_input_expressions+0x41d6>
 108c85a:	mov    $0x4,%edi
 108c85f:	mov    %rdx,%r8
 108c862:	xor    %esi,%esi
 108c864:	xor    %edx,%edx
 108c866:	fldz
 108c868:	jmp    108ce29 <check_input_expressions+0x4209>
 108c86d:	mov    0x20(%rsp),%r12
 108c872:	mov    0x30(%rsp),%rbx
 108c877:	mov    $0xffffffff,%r11d
 108c87d:	jmp    108c34f <check_input_expressions+0x372f>
 108c882:	cmp    $0x5,%edi
 108c885:	jne    108c89d <check_input_expressions+0x3c7d>
 108c887:	mov    $0x1,%cl
 108c889:	cmp    $0x2,%r15b
 108c88d:	jne    108c94f <check_input_expressions+0x3d2f>
 108c893:	mov    0x78(%rsp),%rax
 108c898:	mov    (%rax),%r14d
 108c89b:	jmp    108c8d3 <check_input_expressions+0x3cb3>
 108c89d:	mov    0x78(%rsp),%rax
 108c8a2:	mov    0x10(%rsp),%rcx
 108c8a7:	mov    (%rax),%r14d
 108c8aa:	cmp    %r14d,%ecx
 108c8ad:	jae    108c94d <check_input_expressions+0x3d2d>
 108c8b3:	xor    %ecx,%ecx
 108c8b5:	cmp    $0x2,%r15b
 108c8b9:	jne    108c94f <check_input_expressions+0x3d2f>
 108c8bf:	mov    0x18(%r9),%rax
 108c8c3:	mov    0x10(%rsp),%rdx
 108c8c8:	mov    (%rax,%rdx,4),%eax
 108c8cb:	add    $0xffffffbe,%eax
 108c8ce:	cmp    $0x3,%eax
 108c8d1:	jae    108c94f <check_input_expressions+0x3d2f>
 108c8d3:	mov    0x60(%r9),%rcx
 108c8d7:	mov    0x10(%rsp),%rax
 108c8dc:	mov    (%rcx,%rax,4),%eax
 108c8df:	mov    $0x1,%bpl
 108c8e2:	cmp    %r14d,%eax
 108c8e5:	jae    108cd23 <check_input_expressions+0x4103>
 108c8eb:	mov    0x50(%r9),%rdx
 108c8ef:	movzbl (%rdx,%rax,1),%edx
 108c8f3:	cmp    $0x48,%edx
 108c8f6:	je     108c8fd <check_input_expressions+0x3cdd>
 108c8f8:	cmp    $0x1e,%edx
 108c8fb:	jne    108c8dc <check_input_expressions+0x3cbc>
 108c8fd:	mov    0x370(%r12),%rcx
 108c905:	mov    (%rcx,%rax,4),%ebx
 108c908:	cmp    %eax,%ebx
 108c90a:	jae    108c921 <check_input_expressions+0x3d01>
 108c90c:	lea    0x2(%rbx),%esi
 108c90f:	mov    $0x33,%ecx
 108c914:	mov    %r9,%rdi
 108c917:	mov    %eax,%edx
 108c919:	vzeroupper
 108c91c:	call   1088bb0 <check_constant_punctuation>
 108c921:	mov    0x10(%rsp),%rsi
 108c926:	cmp    %r14d,%ebx
 108c929:	jae    108cd28 <check_input_expressions+0x4108>
 108c92f:	mov    0x18(%rsp),%rcx
 108c934:	mov    0x10(%rcx),%rcx
 108c938:	cmpb   $0x43,(%rcx,%rbx,1)
 108c93c:	setne  %cl
 108c93f:	cmp    %eax,%esi
 108c941:	setbe  %bpl
 108c945:	or     %cl,%bpl
 108c948:	jmp    108cd28 <check_input_expressions+0x4108>
 108c94d:	xor    %ecx,%ecx
 108c94f:	mov    0x50(%r9),%rax
 108c953:	mov    0x10(%rsp),%r14
 108c958:	cmpb   $0x9,(%rax,%r14,1)
 108c95d:	jne    108ca48 <check_input_expressions+0x3e28>
 108c963:	mov    0x10(%r9),%rdx
 108c967:	cmpb   $0xf,(%rdx,%r14,1)
 108c96c:	jne    108ca48 <check_input_expressions+0x3e28>
 108c972:	mov    0x300(%r13),%rax
 108c979:	mov    0x18(%r12),%rdi
 108c97e:	mov    $0x8,%esi
 108c983:	mov    %r8d,%ebx
 108c986:	mov    (%rax,%r14,4),%r14d
 108c98a:	vzeroupper
 108c98d:	call   10b2810 <type_pointer>
 108c992:	test   %eax,%eax
 108c994:	je     108ce81 <check_input_expressions+0x4261>
 108c99a:	mov    %eax,%r13d
 108c99d:	mov    0x78(%rsp),%rax
 108c9a2:	cmp    (%rax),%r14d
 108c9a5:	setb   %al
 108c9a8:	test   %ebp,%ebp
 108c9aa:	sete   %cl
 108c9ad:	and    %al,%cl
 108c9af:	cmp    $0x1,%cl
 108c9b2:	jne    108cea7 <check_input_expressions+0x4287>
 108c9b8:	mov    $0xffffffff,%ecx
 108c9bd:	mov    $0xffffffff,%r8d
 108c9c3:	mov    $0xffffffff,%r9d
 108c9c9:	mov    0x10(%rsp),%rdx
 108c9ce:	mov    %r12,%rdi
 108c9d1:	xor    %esi,%esi
 108c9d3:	call   10facf0 <check_input_add>
 108c9d8:	vpmovsxbq -0xbeede1(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108c9e1:	mov    0x18(%rsp),%r9
 108c9e6:	mov    $0xffffffff,%r11d
 108c9ec:	vxorps %xmm2,%xmm2,%xmm2
 108c9f0:	cmp    $0xffffffff,%eax
 108c9f3:	je     1088c90 <check_input_expressions+0x70>
 108c9f9:	mov    0x70(%rsp),%rcx
 108c9fe:	mov    %eax,%r15d
 108ca01:	inc    %r14d
 108ca04:	movabs $0x8000000000,%rdx
 108ca0e:	vpxor  %xmm0,%xmm0,%xmm0
 108ca12:	mov    0x28(%rcx),%rax
 108ca16:	mov    %r15d,%ecx
 108ca19:	lea    (%rcx,%rcx,2),%rcx
 108ca1d:	shl    $0x5,%rcx
 108ca21:	mov    %r13d,(%rax,%rcx,1)
 108ca25:	mov    %rdx,0x4(%rax,%rcx,1)
 108ca2a:	movl   $0x3,0xc(%rax,%rcx,1)
 108ca32:	vmovdqu %ymm0,0x10(%rax,%rcx,1)
 108ca38:	vmovdqu %ymm0,0x20(%rax,%rcx,1)
 108ca3e:	mov    %r14d,0x40(%rax,%rcx,1)
 108ca43:	jmp    108cde5 <check_input_expressions+0x41c5>
 108ca48:	mov    %r8d,0xc(%rsp)
 108ca4d:	mov    %esi,0x20(%rsp)
 108ca51:	mov    %r10d,0x28(%rsp)
 108ca56:	cmp    $0x1a,%r15b
 108ca5a:	jne    108cb6b <check_input_expressions+0x3f4b>
 108ca60:	cmp    $0x11,%dil
 108ca64:	jne    108cb6b <check_input_expressions+0x3f4b>
 108ca6a:	mov    0x60(%r9),%rax
 108ca6e:	mov    (%rax,%r14,4),%esi
 108ca72:	cmp    0x30(%r9),%esi
 108ca76:	jae    108daee <check_input_expressions+0x4ece>
 108ca7c:	mov    %r9,%rdi
 108ca7f:	vzeroupper
 108ca82:	call   10f9e80 <check_input_indirect_goto>
 108ca87:	mov    0x18(%rsp),%r9
 108ca8c:	test   %al,%al
 108ca8e:	je     108daee <check_input_expressions+0x4ece>
 108ca94:	mov    0x18(%r12),%rdi
 108ca99:	xor    %esi,%esi
 108ca9b:	mov    (%rdi),%rax
 108ca9e:	cmpb   $0xb,0x1(%rax)
 108caa2:	sete   %sil
 108caa6:	xor    $0x9,%esi
 108caa9:	call   10b2810 <type_pointer>
 108caae:	test   %eax,%eax
 108cab0:	jne    108cacb <check_input_expressions+0x3eab>
 108cab2:	mov    0x18(%r12),%rcx
 108cab7:	cmpl   $0x1,0x100(%rcx)
 108cabe:	jne    108cacb <check_input_expressions+0x3eab>
 108cac0:	mov    (%r12),%rcx
 108cac4:	movb   $0x1,0x3bd(%rcx)
 108cacb:	mov    0xa8(%r12),%rdx
 108cad3:	mov    0x10(%rsp),%r14
 108cad8:	cmp    $0x1,%ebp
 108cadb:	sete   %cl
 108cade:	mov    %eax,(%rdx,%r14,4)
 108cae2:	mov    0xa8(%r12),%rax
 108caea:	cmpl   $0x0,(%rax,%r14,4)
 108caef:	mov    $0x24,%eax
 108caf4:	setne  %r13b
 108caf8:	and    %cl,%r13b
 108cafb:	mov    0x18(%rsp),%r9
 108cb00:	movl   $0x0,0x38(%rsp)
 108cb08:	vpmovsxbq -0xbeef11(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108cb11:	mov    $0xffffffff,%r11d
 108cb17:	vxorps %xmm2,%xmm2,%xmm2
 108cb1b:	jmp    108cd14 <check_input_expressions+0x40f4>
 108cb20:	mov    (%r12),%rax
 108cb24:	mov    0x230(%rax),%ecx
 108cb2a:	cmp    0x234(%rax),%ecx
 108cb30:	jae    108cc32 <check_input_expressions+0x4012>
 108cb36:	movzbl 0x3bd(%rax),%r8d
 108cb3e:	mov    0x228(%rax),%rsi
 108cb45:	lea    0x1(%rcx),%edi
 108cb48:	mov    %edi,0x230(%rax)
 108cb4e:	lea    (%rcx,%rcx,2),%rax
 108cb52:	add    $0x3,%r8d
 108cb56:	mov    %ebx,(%rsi,%rax,4)
 108cb59:	mov    %r8d,0x4(%rsi,%rax,4)
 108cb5e:	movl   $0x0,0x8(%rsi,%rax,4)
 108cb66:	jmp    108cc39 <check_input_expressions+0x4019>
 108cb6b:	cmp    $0x9,%r15b
 108cb6f:	jne    108cc5c <check_input_expressions+0x403c>
 108cb75:	cmp    $0x1,%ebp
 108cb78:	mov    $0xffffffff,%r15d
 108cb7e:	mov    %r12,%rbx
 108cb81:	movl   $0x0,0x38(%rsp)
 108cb89:	sete   %al
 108cb8c:	add    $0xfffffff2,%edi
 108cb8f:	cmp    $0x37,%edi
 108cb92:	ja     108d2d3 <check_input_expressions+0x46b3>
 108cb98:	lea    -0xbeec5f(%rip),%rdx        # 49df40 <cbuiltin_test_generated.edges+0x4100>
 108cb9f:	movslq (%rdx,%rdi,4),%rcx
 108cba3:	add    %rdx,%rcx
 108cba6:	jmp    *%rcx
 108cba8:	mov    %eax,%r13d
 108cbab:	movl   $0x0,0x38(%rsp)
 108cbb3:	mov    $0x19,%eax
 108cbb8:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108cbbd:	xor    %esi,%esi
 108cbbf:	mov    0x70(%rsp),%r13
 108cbc4:	mov    %r15d,%ebx
 108cbc7:	lea    (%rbx,%rbx,2),%rbx
 108cbcb:	mov    %r8b,%r10b
 108cbce:	mov    0x130(%r12),%r8
 108cbd6:	mov    %bpl,%r9b
 108cbd9:	shl    $0x3,%r9d
 108cbdd:	shl    $0x5,%rbx
 108cbe1:	or     %edi,%r9d
 108cbe4:	lea    0x1(%r10,%r10,1),%edi
 108cbe9:	add    0x28(%r13),%rbx
 108cbed:	mov    (%r8,%rcx,4),%ecx
 108cbf1:	mov    %eax,(%rbx)
 108cbf3:	mov    %edx,0x4(%rbx)
 108cbf6:	mov    %r9d,0x8(%rbx)
 108cbfa:	mov    %edi,0xc(%rbx)
 108cbfd:	mov    %r11,0x10(%rbx)
 108cc01:	mov    %r14,0x18(%rbx)
 108cc05:	fldz
 108cc07:	fld    %st(0)
 108cc09:	fstpt  0x20(%rbx)
 108cc0c:	fstpt  0x30(%rbx)
 108cc0f:	mov    %ecx,0x40(%rbx)
 108cc12:	mov    %esi,0x44(%rbx)
 108cc15:	vmovups %xmm2,0x48(%rbx)
 108cc1a:	movq   $0x0,0x58(%rbx)
 108cc22:	mov    $0xffffffff,%r11d
 108cc28:	mov    0x18(%rsp),%r9
 108cc2d:	jmp    108dc87 <check_input_expressions+0x5067>
 108cc32:	movb   $0x1,0x3bd(%rax)
 108cc39:	vpmovsxbq -0xbef042(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108cc42:	mov    0x18(%rsp),%r9
 108cc47:	mov    $0xffffffff,%r15d
 108cc4d:	vxorps %xmm2,%xmm2,%xmm2
 108cc51:	mov    $0xffffffff,%r11d
 108cc57:	jmp    108ce6d <check_input_expressions+0x424d>
 108cc5c:	lea    -0xc(%r15),%edx
 108cc60:	mov    $0xffffffff,%r8d
 108cc66:	cmp    $0xb,%dl
 108cc69:	setb   %dl
 108cc6c:	cmp    $0x19,%r15b
 108cc70:	sete   %sil
 108cc74:	or     %dl,%sil
 108cc77:	jne    108cca0 <check_input_expressions+0x4080>
 108cc79:	mov    %r12,%rbx
 108cc7c:	cmp    $0x1c,%r15b
 108cc80:	jne    108ceb1 <check_input_expressions+0x4291>
 108cc86:	mov    0x268(%rbx),%rax
 108cc8d:	mov    0x10(%rsp),%r14
 108cc92:	mov    %rbx,%r12
 108cc95:	cmpb   $0x0,(%rax,%r14,1)
 108cc9a:	je     108d166 <check_input_expressions+0x4546>
 108cca0:	vzeroupper
 108cca3:	call   10d2770 <check_input_binary>
 108cca8:	mov    0x140(%r12),%rdx
 108ccb0:	cmp    $0x2,%ebp
 108ccb3:	mov    %r12,%rbx
 108ccb6:	sete   %sil
 108ccba:	cmp    $0x45,%eax
 108ccbd:	setne  %cl
 108ccc0:	movzbl (%rdx,%r14,1),%edx
 108ccc5:	test   %dl,%dl
 108ccc7:	je     108cf28 <check_input_expressions+0x4308>
 108cccd:	cmp    $0x1,%dl
 108ccd0:	mov    $0x45,%ecx
 108ccd5:	mov    $0x23,%eax
 108ccda:	cmove  %eax,%ecx
 108ccdd:	cmp    $0x2,%dl
 108cce0:	sete   %al
 108cce3:	cmp    $0x1,%ebp
 108cce6:	sete   %r13b
 108ccea:	mov    %eax,0x38(%rsp)
 108ccee:	or     %al,%r13b
 108ccf1:	mov    %rcx,%rax
 108ccf4:	mov    0x18(%rsp),%r9
 108ccf9:	mov    %rbx,%r12
 108ccfc:	vpmovsxbq -0xbef105(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108cd05:	mov    0x10(%rsp),%r14
 108cd0a:	vxorps %xmm2,%xmm2,%xmm2
 108cd0e:	mov    $0xffffffff,%r11d
 108cd14:	mov    0x48(%rsp),%r15
 108cd19:	mov    0xc(%rsp),%r8d
 108cd1e:	jmp    108db4c <check_input_expressions+0x4f2c>
 108cd23:	mov    0x10(%rsp),%rsi
 108cd28:	mov    %r12,%rdi
 108cd2b:	vzeroupper
 108cd2e:	call   10a1210 <check_input_string>
 108cd33:	vpmovsxbq -0xbef13c(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108cd3c:	mov    0x18(%rsp),%r9
 108cd41:	mov    $0xffffffff,%r11d
 108cd47:	vxorps %xmm2,%xmm2,%xmm2
 108cd4b:	test   %bpl,%bpl
 108cd4e:	je     1088c90 <check_input_expressions+0x70>
 108cd54:	mov    %rax,%r13
 108cd57:	test   %rax,%rax
 108cd5a:	je     1088c90 <check_input_expressions+0x70>
 108cd60:	mov    $0xffffffff,%ecx
 108cd65:	mov    $0xffffffff,%r8d
 108cd6b:	mov    $0xffffffff,%r9d
 108cd71:	mov    0x10(%rsp),%rdx
 108cd76:	mov    %r12,%rdi
 108cd79:	xor    %esi,%esi
 108cd7b:	call   10facf0 <check_input_add>
 108cd80:	vpmovsxbq -0xbef189(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108cd89:	mov    0x18(%rsp),%r9
 108cd8e:	mov    $0xffffffff,%r11d
 108cd94:	vxorps %xmm2,%xmm2,%xmm2
 108cd98:	cmp    $0xffffffff,%eax
 108cd9b:	je     1088c90 <check_input_expressions+0x70>
 108cda1:	vpmovzxbd -0xae11ba(%rip),%xmm0        # 5abbf0 <link_program_emit_worker.forms+0x3e0>
 108cdaa:	mov    %eax,%r15d
 108cdad:	mov    0x70(%rsp),%rax
 108cdb2:	mov    0x0(%r13),%edx
 108cdb6:	mov    %r15d,%ecx
 108cdb9:	lea    (%rcx,%rcx,2),%rcx
 108cdbd:	shl    $0x5,%rcx
 108cdc1:	vpinsrd $0x0,0x8(%r13),%xmm0,%xmm0
 108cdc8:	mov    0x28(%rax),%rax
 108cdcc:	vmovdqa %xmm0,(%rax,%rcx,1)
 108cdd1:	vpxor  %xmm0,%xmm0,%xmm0
 108cdd5:	vmovdqu %ymm0,0x10(%rax,%rcx,1)
 108cddb:	vmovdqu %ymm0,0x20(%rax,%rcx,1)
 108cde1:	mov    %edx,0x40(%rax,%rcx,1)
 108cde5:	vmovups %xmm2,0x44(%rax,%rcx,1)
 108cdeb:	vmovups %xmm2,0x50(%rax,%rcx,1)
 108cdf1:	jmp    108dc87 <check_input_expressions+0x5067>
 108cdf6:	xor    %esi,%esi
 108cdf8:	xor    %edi,%edi
 108cdfa:	cmp    $0xb8,%ecx
 108ce00:	mov    $0x2,%r8d
 108ce06:	sete   %dil
 108ce0a:	setne  %sil
 108ce0e:	testb  $0x1,0x130(%rsp)
 108ce16:	fldz
 108ce18:	fxch   %st(1)
 108ce1a:	lea    0x1(%rdi,%rdi,1),%edi
 108ce1e:	cmovne %r8d,%esi
 108ce22:	cmovne %r8d,%edi
 108ce26:	xor    %r8d,%r8d
 108ce29:	mov    %eax,%r9d
 108ce2c:	lea    (%r9,%r9,2),%r9
 108ce30:	vpxor  %xmm0,%xmm0,%xmm0
 108ce34:	mov    %eax,%r15d
 108ce37:	shl    $0x5,%r9
 108ce3b:	add    0x28(%r10),%r9
 108ce3f:	mov    %ecx,(%r9)
 108ce42:	movl   $0x0,0x4(%r9)
 108ce4a:	mov    %esi,0x8(%r9)
 108ce4e:	mov    %edi,0xc(%r9)
 108ce52:	mov    %rdx,0x10(%r9)
 108ce56:	mov    %r8,0x18(%r9)
 108ce5a:	fstpt  0x20(%r9)
 108ce5e:	fstpt  0x30(%r9)
 108ce62:	vmovdqu %ymm0,0x40(%r9)
 108ce68:	mov    0x18(%rsp),%r9
 108ce6d:	xor    %esi,%esi
 108ce6f:	mov    %r14d,%r8d
 108ce72:	cmp    $0xffffffff,%r15d
 108ce76:	jne    108dc87 <check_input_expressions+0x5067>
 108ce7c:	jmp    108de5d <check_input_expressions+0x523d>
 108ce81:	mov    0x18(%r12),%rax
 108ce86:	mov    $0xffffffff,%r15d
 108ce8c:	mov    %r12,%rcx
 108ce8f:	cmpl   $0x1,0x100(%rax)
 108ce96:	jne    108cef2 <check_input_expressions+0x42d2>
 108ce98:	mov    (%rcx),%rax
 108ce9b:	mov    %rcx,%r12
 108ce9e:	movb   $0x1,0x3bd(%rax)
 108cea5:	jmp    108cead <check_input_expressions+0x428d>
 108cea7:	mov    $0xffffffff,%r15d
 108cead:	xor    %esi,%esi
 108ceaf:	jmp    108cef7 <check_input_expressions+0x42d7>
 108ceb1:	cmpb   $0x3b,0x48(%rsp)
 108ceb6:	jne    108d142 <check_input_expressions+0x4522>
 108cebc:	cmp    $0x1,%ebp
 108cebf:	jne    108d30b <check_input_expressions+0x46eb>
 108cec5:	mov    $0x1,%ebp
 108ceca:	vpmovsxbq -0xbef2d3(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108ced3:	mov    0x18(%rsp),%r9
 108ced8:	mov    0xc(%rsp),%r8d
 108cedd:	mov    (%rbx),%r13
 108cee0:	mov    %rbx,%r12
 108cee3:	vxorps %xmm2,%xmm2,%xmm2
 108cee7:	mov    $0xffffffff,%r11d
 108ceed:	jmp    108de6a <check_input_expressions+0x524a>
 108cef2:	xor    %esi,%esi
 108cef4:	mov    %rcx,%r12
 108cef7:	vpmovsxbq -0xbef300(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108cf00:	mov    0x18(%rsp),%r9
 108cf05:	vxorps %xmm2,%xmm2,%xmm2
 108cf09:	mov    $0xffffffff,%r11d
 108cf0f:	mov    %ebx,%r8d
 108cf12:	mov    (%r12),%rax
 108cf16:	cmpl   $0x0,0x230(%rax)
 108cf1d:	jne    108dc7d <check_input_expressions+0x505d>
 108cf23:	jmp    108dc44 <check_input_expressions+0x5024>
 108cf28:	mov    %rax,%rdi
 108cf2b:	and    %cl,%sil
 108cf2e:	movl   $0x0,0x38(%rsp)
 108cf36:	cmp    $0x1e,%edi
 108cf39:	jne    108d100 <check_input_expressions+0x44e0>
 108cf3f:	test   %sil,%sil
 108cf42:	je     108d100 <check_input_expressions+0x44e0>
 108cf48:	mov    0xa8(%rbx),%rax
 108cf4f:	mov    0x10(%rsp),%rcx
 108cf54:	mov    (%rax,%rcx,4),%eax
 108cf57:	mov    %eax,0x30(%rsp)
 108cf5b:	test   %eax,%eax
 108cf5d:	jne    108cfda <check_input_expressions+0x43ba>
 108cf5f:	vpxor  %xmm0,%xmm0,%xmm0
 108cf63:	vmovdqu64 %zmm0,0x130(%rsp)
 108cf6e:	vmovdqu64 %zmm0,0x110(%rsp)
 108cf79:	mov    0x10(%rsp),%rcx
 108cf7e:	mov    %rbx,%rdi
 108cf81:	movl   $0x0,0x38(%rsp)
 108cf89:	mov    $0x1,%r8d
 108cf8f:	lea    0x110(%rsp),%r9
 108cf97:	mov    0x368(%rbx),%rax
 108cf9e:	lea    0x1(%rcx),%esi
 108cfa1:	mov    (%rax,%rcx,4),%edx
 108cfa4:	xor    %ecx,%ecx
 108cfa6:	inc    %edx
 108cfa8:	push   $0x0
 108cfaa:	lea    0xf8(%rsp),%rax
 108cfb2:	push   %rax
 108cfb3:	vzeroupper
 108cfb6:	call   10c1fc0 <check_input_constant_read>
 108cfbb:	add    $0x10,%rsp
 108cfbf:	mov    0x110(%rsp),%ecx
 108cfc6:	test   %ecx,%ecx
 108cfc8:	mov    %ecx,0x30(%rsp)
 108cfcc:	setne  %cl
 108cfcf:	and    %al,%cl
 108cfd1:	cmp    $0x1,%cl
 108cfd4:	jne    108d363 <check_input_expressions+0x4743>
 108cfda:	mov    0x18(%rbx),%rcx
 108cfde:	movl   $0x0,0x38(%rsp)
 108cfe6:	mov    0x48(%rcx),%eax
 108cfe9:	test   %eax,%eax
 108cfeb:	je     108d188 <check_input_expressions+0x4568>
 108cff1:	mov    (%rcx),%rsi
 108cff4:	mov    0x30(%rsp),%edi
 108cff8:	xor    %edx,%edx
 108cffa:	mov    %edi,%r8d
 108cffd:	shr    $0x3,%r8d
 108d001:	movzbl (%rsi,%r8,1),%r9d
 108d006:	cmp    $0xf,%r9b
 108d00a:	jne    108d020 <check_input_expressions+0x4400>
 108d00c:	mov    0x20(%rcx),%r9
 108d010:	mov    (%r9,%r8,4),%r8d
 108d014:	or     %r8d,%edi
 108d017:	shr    $0x3,%r8d
 108d01b:	movzbl (%rsi,%r8,1),%r9d
 108d020:	lea    -0x8(%r9),%r10d
 108d024:	cmp    $0x2,%r10b
 108d028:	ja     108d054 <check_input_expressions+0x4434>
 108d02a:	mov    0x20(%rcx),%r10
 108d02e:	cmp    $0xa,%r9b
 108d032:	sete   %r9b
 108d036:	and    $0x7,%edi
 108d039:	or     %r9b,%dl
 108d03c:	or     (%r10,%r8,4),%edi
 108d040:	je     108d054 <check_input_expressions+0x4434>
 108d042:	mov    0x38(%rsp),%r8d
 108d047:	inc    %r8d
 108d04a:	mov    %r8d,0x38(%rsp)
 108d04f:	cmp    %r8d,%eax
 108d052:	jne    108cffa <check_input_expressions+0x43da>
 108d054:	movl   $0x0,0x38(%rsp)
 108d05c:	test   $0x1,%dl
 108d05f:	je     108d188 <check_input_expressions+0x4568>
 108d065:	mov    0xa8(%rbx),%rdx
 108d06c:	mov    0x10(%rsp),%rsi
 108d071:	xor    %edi,%edi
 108d073:	mov    %rbx,0x20(%rsp)
 108d078:	cmp    (%rdx,%rsi,4),%edi
 108d07b:	mov    (%rbx),%rsi
 108d07e:	mov    0x30(%rsp),%edi
 108d082:	sbb    %edx,%edx
 108d084:	or     0xc(%rsp),%edx
 108d088:	mov    %rsi,0x60(%rsp)
 108d08d:	mov    %edx,0x28(%rsp)
 108d091:	mov    0x28(%rbx),%rdx
 108d095:	mov    0x8(%rdx),%rsi
 108d099:	mov    %rsi,0x80(%rsp)
 108d0a1:	mov    (%rcx),%rsi
 108d0a4:	jmp    108d0de <check_input_expressions+0x44be>
 108d0a6:	mov    0x20(%rcx),%r8
 108d0aa:	mov    (%r8,%rdi,4),%edi
 108d0ae:	shr    $0x3,%edi
 108d0b1:	movzbl (%rsi,%rdi,1),%r9d
 108d0b6:	add    $0xf8,%r9b
 108d0ba:	cmp    $0x3,%r9b
 108d0be:	jae    108d39e <check_input_expressions+0x477e>
 108d0c4:	mov    0x38(%rsp),%r9d
 108d0c9:	mov    (%r8,%rdi,4),%edi
 108d0cd:	inc    %r9d
 108d0d0:	mov    %r9d,0x38(%rsp)
 108d0d5:	cmp    %r9d,%eax
 108d0d8:	je     108d39a <check_input_expressions+0x477a>
 108d0de:	shr    $0x3,%edi
 108d0e1:	movzbl (%rsi,%rdi,1),%r8d
 108d0e6:	cmp    $0xf,%r8b
 108d0ea:	je     108d0a6 <check_input_expressions+0x4486>
 108d0ec:	add    $0xf8,%r8b
 108d0f0:	cmp    $0x2,%r8b
 108d0f4:	ja     108d39e <check_input_expressions+0x477e>
 108d0fa:	mov    0x20(%rcx),%r8
 108d0fe:	jmp    108d0c4 <check_input_expressions+0x44a4>
 108d100:	vpmovsxbq -0xbef509(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108d109:	mov    %esi,%r13d
 108d10c:	mov    0x18(%rsp),%r9
 108d111:	mov    0x10(%rsp),%r14
 108d116:	mov    0x48(%rsp),%r15
 108d11b:	mov    0xc(%rsp),%r8d
 108d120:	mov    0x20(%rsp),%esi
 108d124:	mov    0x40(%rsp),%edx
 108d128:	mov    0x28(%rsp),%r10d
 108d12d:	mov    %rbx,%r12
 108d130:	vxorps %xmm2,%xmm2,%xmm2
 108d134:	mov    $0xffffffff,%r11d
 108d13a:	mov    %rdi,%rax
 108d13d:	jmp    1089239 <check_input_expressions+0x619>
 108d142:	movzbl 0x48(%rsp),%edx
 108d147:	lea    -0xa(%rdx),%esi
 108d14a:	cmp    $0x48,%esi
 108d14d:	ja     108d976 <check_input_expressions+0x4d56>
 108d153:	lea    -0xbef46e(%rip),%r9        # 49dcec <cbuiltin_test_generated.edges+0x3eac>
 108d15a:	movslq (%r9,%rsi,4),%rsi
 108d15e:	add    %r9,%rsi
 108d161:	jmp    *%rsi
 108d163:	mov    %rbx,%r12
 108d166:	vpmovsxbq -0xbef56f(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108d16f:	mov    0x18(%rsp),%r9
 108d174:	mov    0xc(%rsp),%r8d
 108d179:	vxorps %xmm2,%xmm2,%xmm2
 108d17d:	mov    $0xffffffff,%r11d
 108d183:	jmp    108de6a <check_input_expressions+0x524a>
 108d188:	vpmovsxbq -0xbef591(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108d191:	mov    0x18(%rsp),%r9
 108d196:	mov    0x10(%rsp),%r14
 108d19b:	mov    0x48(%rsp),%r15
 108d1a0:	mov    0xc(%rsp),%r8d
 108d1a5:	mov    0x20(%rsp),%esi
 108d1a9:	mov    0x40(%rsp),%edx
 108d1ad:	mov    0x28(%rsp),%r10d
 108d1b2:	mov    %rbx,%r12
 108d1b5:	vxorps %xmm2,%xmm2,%xmm2
 108d1b9:	mov    $0xffffffff,%r11d
 108d1bf:	mov    $0x1,%r13b
 108d1c2:	mov    $0x1e,%eax
 108d1c7:	jmp    1089239 <check_input_expressions+0x619>
 108d1cc:	mov    0x18(%rsp),%r9
 108d1d1:	mov    0x10(%rsp),%r14
 108d1d6:	xor    %edx,%edx
 108d1d8:	movl   $0x0,0x38(%rsp)
 108d1e0:	mov    %eax,%r13d
 108d1e3:	mov    %rbx,%r12
 108d1e6:	mov    0x18(%r9),%rcx
 108d1ea:	mov    (%rcx,%r14,4),%ecx
 108d1ee:	and    $0xfffffffe,%ecx
 108d1f1:	cmp    $0x56,%ecx
 108d1f4:	sete   %dl
 108d1f7:	or     $0x40,%edx
 108d1fa:	mov    %rdx,%rax
 108d1fd:	jmp    108cb08 <check_input_expressions+0x3ee8>
 108d202:	mov    %eax,%r13d
 108d205:	movl   $0x0,0x38(%rsp)
 108d20d:	mov    $0x1a,%eax
 108d212:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d217:	mov    %eax,%r13d
 108d21a:	mov    $0x1,%eax
 108d21f:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d224:	mov    %eax,%r13d
 108d227:	movl   $0x0,0x38(%rsp)
 108d22f:	mov    $0x26,%eax
 108d234:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d239:	mov    %eax,%r13d
 108d23c:	movl   $0x0,0x38(%rsp)
 108d244:	mov    $0x2,%eax
 108d249:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d24e:	mov    %eax,%r13d
 108d251:	movl   $0x0,0x38(%rsp)
 108d259:	mov    $0x27,%eax
 108d25e:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d263:	mov    %eax,%r13d
 108d266:	movl   $0x0,0x38(%rsp)
 108d26e:	mov    $0x4,%eax
 108d273:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d278:	mov    %eax,%r13d
 108d27b:	movl   $0x0,0x38(%rsp)
 108d283:	mov    $0x3,%eax
 108d288:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d28d:	mov    0x18(%rsp),%rax
 108d292:	mov    0x10(%rsp),%rcx
 108d297:	xor    %edi,%edi
 108d299:	mov    0x18(%rax),%rax
 108d29d:	cmpl   $0x17,(%rax,%rcx,4)
 108d2a1:	sete   %dil
 108d2a5:	xor    $0x1f,%edi
 108d2a8:	cmp    $0x1,%ebp
 108d2ab:	jne    108d34a <check_input_expressions+0x472a>
 108d2b1:	mov    $0x1,%sil
 108d2b4:	mov    $0x1,%ebp
 108d2b9:	jmp    108cf2e <check_input_expressions+0x430e>
 108d2be:	mov    %eax,%r13d
 108d2c1:	movl   $0x0,0x38(%rsp)
 108d2c9:	mov    $0x34,%eax
 108d2ce:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d2d3:	vpmovsxbq -0xbef6dc(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108d2dc:	mov    0x18(%rsp),%r9
 108d2e1:	mov    0xc(%rsp),%r8d
 108d2e6:	mov    %rbx,%r12
 108d2e9:	vxorps %xmm2,%xmm2,%xmm2
 108d2ed:	mov    $0xffffffff,%r11d
 108d2f3:	xor    %esi,%esi
 108d2f5:	mov    (%r12),%rax
 108d2f9:	cmpl   $0x0,0x230(%rax)
 108d300:	jne    108dc7d <check_input_expressions+0x505d>
 108d306:	jmp    108dc44 <check_input_expressions+0x5024>
 108d30b:	mov    $0x1,%sil
 108d30e:	mov    $0xffffffff,%r15d
 108d314:	vpmovsxbq -0xbef71d(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108d31d:	mov    0x18(%rsp),%r9
 108d322:	mov    0xc(%rsp),%r8d
 108d327:	mov    %rbx,%r12
 108d32a:	vxorps %xmm2,%xmm2,%xmm2
 108d32e:	mov    $0xffffffff,%r11d
 108d334:	mov    (%r12),%rax
 108d338:	cmpl   $0x0,0x230(%rax)
 108d33f:	jne    108dc7d <check_input_expressions+0x505d>
 108d345:	jmp    108dc44 <check_input_expressions+0x5024>
 108d34a:	mov    0xa8(%rbx),%rax
 108d351:	mov    0x10(%rsp),%rcx
 108d356:	cmpl   $0x0,(%rax,%rcx,4)
 108d35a:	setne  %sil
 108d35e:	jmp    108cf2e <check_input_expressions+0x430e>
 108d363:	mov    $0x1e,%eax
 108d368:	vpmovsxbq -0xbef771(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108d371:	mov    0x18(%rsp),%r9
 108d376:	mov    0x10(%rsp),%r14
 108d37b:	mov    0x48(%rsp),%r15
 108d380:	mov    0xc(%rsp),%r8d
 108d385:	mov    %rbx,%r12
 108d388:	vxorps %xmm2,%xmm2,%xmm2
 108d38c:	mov    $0xffffffff,%r11d
 108d392:	mov    $0x1,%r13b
 108d395:	jmp    108db4c <check_input_expressions+0x4f2c>
 108d39a:	mov    %eax,0x38(%rsp)
 108d39e:	mov    (%rdx),%rcx
 108d3a1:	mov    0x80(%rsp),%rsi
 108d3a9:	lea    0x7(%rsi,%rcx,1),%rdi
 108d3ae:	lea    (%rsi,%rcx,1),%rax
 108d3b2:	and    $0xfffffffffffffff8,%rdi
 108d3b6:	mov    %rdi,0x50(%rsp)
 108d3bb:	cmp    %rax,%rdi
 108d3be:	jae    108d6bb <check_input_expressions+0x4a9b>
 108d3c4:	mov    0x60(%rsp),%rax
 108d3c9:	mov    0x20(%rsp),%rcx
 108d3ce:	movb   $0x1,0x3bd(%rax)
 108d3d5:	mov    0x18(%rcx),%rcx
 108d3d9:	movq   $0x0,0x50(%rsp)
 108d3e2:	mov    (%rcx),%rsi
 108d3e5:	mov    0x30(%rsp),%eax
 108d3e9:	mov    $0x1,%r14d
 108d3ef:	xor    %ebx,%ebx
 108d3f1:	mov    $0x1,%r8b
 108d3f4:	shr    $0x3,%eax
 108d3f7:	mov    0x38(%rcx),%rdx
 108d3fb:	cmpb   $0xf,(%rsi,%rax,1)
 108d3ff:	jne    108d40b <check_input_expressions+0x47eb>
 108d401:	mov    0x20(%rcx),%rcx
 108d405:	mov    (%rcx,%rax,4),%eax
 108d408:	shr    $0x3,%eax
 108d40b:	mov    (%rdx,%rax,8),%rcx
 108d40f:	mov    %rcx,%rax
 108d412:	mul    %r14
 108d415:	seto   %al
 108d418:	or     %al,%r8b
 108d41b:	jne    108df51 <check_input_expressions+0x5331>
 108d421:	mov    0x20(%rsp),%rax
 108d426:	imul   %rcx,%r14
 108d42a:	mov    $0x1,%r13b
 108d42d:	mov    $0xffffffff,%r12d
 108d433:	mov    (%rax),%r15
 108d436:	mov    0x20(%rsp),%rdi
 108d43b:	mov    $0xffffffff,%ecx
 108d440:	mov    $0xffffffff,%r8d
 108d446:	mov    $0xffffffff,%r9d
 108d44c:	mov    0x10(%rsp),%rdx
 108d451:	xor    %esi,%esi
 108d453:	vzeroupper
 108d456:	call   10facf0 <check_input_add>
 108d45b:	cmp    $0xffffffff,%eax
 108d45e:	je     108df51 <check_input_expressions+0x5331>
 108d464:	vpmovsxbd -0xae1885(%rip),%xmm0        # 5abbe8 <link_program_emit_worker.forms+0x3d8>
 108d46d:	mov    0x28(%r15),%rcx
 108d471:	mov    %eax,%edx
 108d473:	lea    (%rdx,%rdx,2),%rdx
 108d477:	shl    $0x5,%rdx
 108d47b:	vmovdqa %xmm0,(%rcx,%rdx,1)
 108d480:	mov    %r14,0x10(%rcx,%rdx,1)
 108d485:	movq   $0x0,0x18(%rcx,%rdx,1)
 108d48e:	fldz
 108d490:	fld    %st(0)
 108d492:	fstpt  0x20(%rcx,%rdx,1)
 108d496:	fstpt  0x30(%rcx,%rdx,1)
 108d49a:	vpxor  %xmm0,%xmm0,%xmm0
 108d49e:	vmovdqu %ymm0,0x40(%rcx,%rdx,1)
 108d4a4:	test   %r13b,%r13b
 108d4a7:	jne    108d4cc <check_input_expressions+0x48ac>
 108d4a9:	mov    0x20(%rsp),%rdi
 108d4ae:	mov    $0x7,%esi
 108d4b3:	mov    $0xffffffff,%r9d
 108d4b9:	mov    0x10(%rsp),%rdx
 108d4be:	mov    %r12d,%ecx
 108d4c1:	mov    %eax,%r8d
 108d4c4:	vzeroupper
 108d4c7:	call   10facf0 <check_input_add>
 108d4cc:	mov    %eax,%r12d
 108d4cf:	cmp    $0xffffffff,%r12d
 108d4d3:	setne  %al
 108d4d6:	test   %ebx,%ebx
 108d4d8:	setne  %cl
 108d4db:	and    %al,%cl
 108d4dd:	cmp    $0x1,%cl
 108d4e0:	jne    108d673 <check_input_expressions+0x4a53>
 108d4e6:	mov    %ebx,%r14d
 108d4e9:	shl    $0x4,%r14
 108d4ed:	add    $0xfffffffffffffff0,%r14
 108d4f1:	mov    0x50(%rsp),%rax
 108d4f6:	mov    (%rax,%r14,1),%rcx
 108d4fa:	mov    0x8(%rax,%r14,1),%r15d
 108d4ff:	movzbl 0xc(%rax,%r14,1),%r13d
 108d505:	mov    %rcx,0x40(%rsp)
 108d50a:	test   $0x1,%r13b
 108d50e:	je     108d52d <check_input_expressions+0x490d>
 108d510:	mov    0x20(%rsp),%rax
 108d515:	lea    -0x1(%r15),%ecx
 108d519:	lea    (%rcx,%rcx,8),%rcx
 108d51d:	mov    (%rax),%rax
 108d520:	mov    0x328(%rax),%rax
 108d527:	mov    0x10(%rax,%rcx,4),%ecx
 108d52b:	jmp    108d557 <check_input_expressions+0x4937>
 108d52d:	mov    0x20(%rsp),%rdi
 108d532:	mov    $0x3a,%esi
 108d537:	mov    $0xffffffff,%ecx
 108d53c:	mov    $0xffffffff,%r8d
 108d542:	mov    $0xffffffff,%r9d
 108d548:	mov    0x10(%rsp),%rdx
 108d54d:	vzeroupper
 108d550:	call   10facf0 <check_input_add>
 108d555:	mov    %eax,%ecx
 108d557:	cmp    $0xffffffff,%ecx
 108d55a:	je     108df51 <check_input_expressions+0x5331>
 108d560:	mov    0x60(%rsp),%rax
 108d565:	mov    0x20(%rsp),%rdi
 108d56a:	mov    $0x7,%esi
 108d56f:	mov    $0xffffffff,%r9d
 108d575:	mov    %ecx,%edx
 108d577:	mov    %r12d,%r8d
 108d57a:	mov    0x38(%rax),%rax
 108d57e:	mov    %r15d,(%rax,%rdx,4)
 108d582:	mov    0x10(%rsp),%rdx
 108d587:	vzeroupper
 108d58a:	call   10facf0 <check_input_add>
 108d58f:	cmp    $0xffffffff,%eax
 108d592:	je     108df51 <check_input_expressions+0x5331>
 108d598:	mov    %eax,%r12d
 108d59b:	test   $0x1,%r13b
 108d59f:	jne    108d5b4 <check_input_expressions+0x4994>
 108d5a1:	mov    0x20(%rsp),%rax
 108d5a6:	dec    %r15d
 108d5a9:	mov    0x260(%rax),%rax
 108d5b0:	mov    %r12d,(%rax,%r15,4)
 108d5b4:	cmpq   $0x1,0x40(%rsp)
 108d5ba:	je     108d659 <check_input_expressions+0x4a39>
 108d5c0:	mov    0x20(%rsp),%rdi
 108d5c5:	mov    $0xffffffff,%ecx
 108d5ca:	mov    $0xffffffff,%r8d
 108d5d0:	mov    $0xffffffff,%r9d
 108d5d6:	mov    0x10(%rsp),%rdx
 108d5db:	xor    %esi,%esi
 108d5dd:	mov    (%rdi),%rbx
 108d5e0:	call   10facf0 <check_input_add>
 108d5e5:	cmp    $0xffffffff,%eax
 108d5e8:	je     108df51 <check_input_expressions+0x5331>
 108d5ee:	vpmovsxbd -0xae1a0f(%rip),%xmm0        # 5abbe8 <link_program_emit_worker.forms+0x3d8>
 108d5f7:	mov    0x28(%rbx),%rcx
 108d5fb:	mov    0x40(%rsp),%rsi
 108d600:	mov    %eax,%edx
 108d602:	lea    (%rdx,%rdx,2),%rdx
 108d606:	mov    $0xffffffff,%r9d
 108d60c:	mov    %eax,%r8d
 108d60f:	shl    $0x5,%rdx
 108d613:	vmovdqa %xmm0,(%rcx,%rdx,1)
 108d618:	mov    %rsi,0x10(%rcx,%rdx,1)
 108d61d:	movq   $0x0,0x18(%rcx,%rdx,1)
 108d626:	fldz
 108d628:	fld    %st(0)
 108d62a:	fstpt  0x20(%rcx,%rdx,1)
 108d62e:	fstpt  0x30(%rcx,%rdx,1)
 108d632:	mov    $0x7,%esi
 108d637:	vpxor  %xmm0,%xmm0,%xmm0
 108d63b:	vmovdqu %ymm0,0x40(%rcx,%rdx,1)
 108d641:	mov    %r12d,%ecx
 108d644:	mov    0x20(%rsp),%rdi
 108d649:	mov    0x10(%rsp),%rdx
 108d64e:	vzeroupper
 108d651:	call   10facf0 <check_input_add>
 108d656:	mov    %eax,%r12d
 108d659:	cmp    $0xffffffff,%r12d
 108d65d:	setne  %al
 108d660:	test   %r14,%r14
 108d663:	je     108d673 <check_input_expressions+0x4a53>
 108d665:	add    $0xfffffffffffffff0,%r14
 108d669:	cmp    $0xffffffff,%r12d
 108d66d:	jne    108d4f1 <check_input_expressions+0x48d1>
 108d673:	cmpl   $0xffffffff,0x28(%rsp)
 108d678:	je     108df0a <check_input_expressions+0x52ea>
 108d67e:	test   %al,%al
 108d680:	je     108df0a <check_input_expressions+0x52ea>
 108d686:	mov    0x20(%rsp),%rdi
 108d68b:	mov    0x28(%rsp),%ecx
 108d68f:	mov    $0x1c,%esi
 108d694:	mov    $0xffffffff,%r9d
 108d69a:	mov    0x10(%rsp),%rdx
 108d69f:	mov    %r12d,%r8d
 108d6a2:	vzeroupper
 108d6a5:	call   10facf0 <check_input_add>
 108d6aa:	mov    %eax,%r12d
 108d6ad:	cmp    $0xffffffff,%eax
 108d6b0:	jne    108df0e <check_input_expressions+0x52ee>
 108d6b6:	jmp    108df51 <check_input_expressions+0x5331>
 108d6bb:	mov    0x50(%rsp),%rax
 108d6c0:	sub    %rcx,%rax
 108d6c3:	mov    0x10(%rdx),%rcx
 108d6c7:	sub    %rax,%rcx
 108d6ca:	jb     108d3c4 <check_input_expressions+0x47a4>
 108d6d0:	mov    0x38(%rsp),%esi
 108d6d4:	shl    $0x4,%rsi
 108d6d8:	cmp    %rcx,%rsi
 108d6db:	ja     108d3c4 <check_input_expressions+0x47a4>
 108d6e1:	mov    0x20(%rsp),%rdi
 108d6e6:	add    %rsi,%rax
 108d6e9:	mov    0x50(%rsp),%rsi
 108d6ee:	mov    %rax,0x8(%rdx)
 108d6f2:	mov    (%rdi),%rcx
 108d6f5:	test   %rsi,%rsi
 108d6f8:	sete   %al
 108d6fb:	or     %al,0x3bd(%rcx)
 108d701:	mov    0x18(%rdi),%rcx
 108d705:	test   %rsi,%rsi
 108d708:	je     108d3d9 <check_input_expressions+0x47b9>
 108d70e:	mov    0x48(%rcx),%edx
 108d711:	test   %edx,%edx
 108d713:	je     108d3e2 <check_input_expressions+0x47c2>
 108d719:	mov    (%rcx),%rsi
 108d71c:	mov    0x30(%rsp),%edi
 108d720:	xor    %eax,%eax
 108d722:	mov    %edi,%r8d
 108d725:	shr    $0x3,%r8d
 108d729:	movzbl (%rsi,%r8,1),%r9d
 108d72e:	cmp    $0xf,%r9b
 108d732:	jne    108d748 <check_input_expressions+0x4b28>
 108d734:	mov    0x20(%rcx),%r9
 108d738:	mov    (%r9,%r8,4),%r8d
 108d73c:	or     %r8d,%edi
 108d73f:	shr    $0x3,%r8d
 108d743:	movzbl (%rsi,%r8,1),%r9d
 108d748:	lea    -0x8(%r9),%r10d
 108d74c:	cmp    $0x2,%r10b
 108d750:	ja     108d76e <check_input_expressions+0x4b4e>
 108d752:	mov    0x20(%rcx),%r10
 108d756:	cmp    $0xa,%r9b
 108d75a:	sete   %r9b
 108d75e:	and    $0x7,%edi
 108d761:	or     %r9b,%al
 108d764:	or     (%r10,%r8,4),%edi
 108d768:	je     108d76e <check_input_expressions+0x4b4e>
 108d76a:	dec    %edx
 108d76c:	jne    108d722 <check_input_expressions+0x4b02>
 108d76e:	test   $0x1,%al
 108d770:	je     108d3e2 <check_input_expressions+0x47c2>
 108d776:	mov    0x30(%rsp),%eax
 108d77a:	xor    %ebx,%ebx
 108d77c:	xor    %edi,%edi
 108d77e:	mov    (%rcx),%rsi
 108d781:	inc    %edi
 108d783:	mov    $0x1,%r14d
 108d789:	mov    %eax,%r8d
 108d78c:	shr    $0x3,%r8d
 108d790:	movzbl (%rsi,%r8,1),%edx
 108d795:	mov    %edx,%r9d
 108d798:	cmp    $0xf,%dl
 108d79b:	jne    108d7ae <check_input_expressions+0x4b8e>
 108d79d:	mov    0x20(%rcx),%r9
 108d7a1:	mov    (%r9,%r8,4),%r9d
 108d7a5:	shr    $0x3,%r9d
 108d7a9:	movzbl (%rsi,%r9,1),%r9d
 108d7ae:	add    $0xf8,%r9b
 108d7b2:	cmp    $0x2,%r9b
 108d7b6:	ja     108e19b <check_input_expressions+0x557b>
 108d7bc:	lea    -0x1(%rdi),%r9d
 108d7c0:	cmp    0x48(%rcx),%r9d
 108d7c4:	jae    108e19b <check_input_expressions+0x557b>
 108d7ca:	cmp    $0xf,%dl
 108d7cd:	jne    108d7e0 <check_input_expressions+0x4bc0>
 108d7cf:	mov    0x20(%rcx),%rax
 108d7d3:	mov    (%rax,%r8,4),%r8d
 108d7d7:	shr    $0x3,%r8d
 108d7db:	movzbl (%rsi,%r8,1),%edx
 108d7e0:	mov    0x30(%rcx),%rax
 108d7e4:	mov    (%rax,%r8,8),%rax
 108d7e8:	cmp    $0xa,%dl
 108d7eb:	je     108d80e <check_input_expressions+0x4bee>
 108d7ed:	mov    %rax,%r9
 108d7f0:	inc    %edi
 108d7f2:	imul   %r14,%r9
 108d7f6:	mul    %r14
 108d7f9:	mov    0x20(%rcx),%rdx
 108d7fd:	mov    %r9,%r14
 108d800:	mov    (%rdx,%r8,4),%eax
 108d804:	mov    $0x1,%r8b
 108d807:	jno    108d789 <check_input_expressions+0x4b69>
 108d809:	jmp    108e1d1 <check_input_expressions+0x55b1>
 108d80e:	test   %rax,%rax
 108d811:	je     108e570 <check_input_expressions+0x5950>
 108d817:	mov    0x20(%rsp),%rdx
 108d81c:	mov    0x8(%rdx),%rdx
 108d820:	mov    0x30(%rdx),%edx
 108d823:	cmp    %rdx,%rax
 108d826:	ja     108e570 <check_input_expressions+0x5950>
 108d82c:	mov    0x20(%rsp),%rdx
 108d831:	mov    0x248(%rdx),%rdx
 108d838:	mov    -0x4(%rdx,%rax,4),%eax
 108d83c:	test   %eax,%eax
 108d83e:	je     108e570 <check_input_expressions+0x5950>
 108d844:	mov    0x20(%rsp),%rdx
 108d849:	mov    (%rdx),%r15
 108d84c:	cmp    0x330(%r15),%eax
 108d853:	ja     108e570 <check_input_expressions+0x5950>
 108d859:	mov    0x328(%r15),%rdx
 108d860:	lea    -0x1(%rax),%ecx
 108d863:	lea    (%rcx,%rcx,8),%rsi
 108d867:	cmpl   $0xffffffff,(%rdx,%rsi,4)
 108d86b:	jne    108d897 <check_input_expressions+0x4c77>
 108d86d:	lea    (%rdx,%rsi,4),%rdx
 108d871:	mov    0x10(%rsp),%rsi
 108d876:	cmp    %esi,0x8(%rdx)
 108d879:	jbe    108d897 <check_input_expressions+0x4c77>
 108d87b:	mov    0xc(%rdx),%esi
 108d87e:	mov    0x20(%rsp),%rdx
 108d883:	mov    0x10(%rsp),%r10
 108d888:	mov    0x368(%rdx),%r9
 108d88f:	mov    $0x1,%dl
 108d891:	cmp    (%r9,%r10,4),%esi
 108d895:	jbe    108d8b1 <check_input_expressions+0x4c91>
 108d897:	mov    0x20(%rsp),%rdx
 108d89c:	mov    0x260(%rdx),%rdx
 108d8a3:	mov    (%rdx,%rcx,4),%ecx
 108d8a6:	cmp    $0xffffffff,%ecx
 108d8a9:	jne    108e600 <check_input_expressions+0x59e0>
 108d8af:	xor    %edx,%edx
 108d8b1:	mov    0x50(%rsp),%rsi
 108d8b6:	mov    %ebx,%ecx
 108d8b8:	shl    $0x4,%rcx
 108d8bc:	inc    %ebx
 108d8be:	mov    %r14,(%rsi,%rcx,1)
 108d8c2:	mov    %eax,0x8(%rsi,%rcx,1)
 108d8c6:	mov    %dl,0xc(%rsi,%rcx,1)
 108d8ca:	movw   $0x0,0xd(%rsi,%rcx,1)
 108d8d1:	movb   $0x0,0xf(%rsi,%rcx,1)
 108d8d6:	mov    0x20(%rsp),%rcx
 108d8db:	mov    0x18(%rcx),%rcx
 108d8df:	mov    0x20(%rcx),%rax
 108d8e3:	mov    (%rax,%r8,4),%eax
 108d8e7:	jmp    108d77e <check_input_expressions+0x4b5e>
 108d8ec:	cmp    $0x1,%ebp
 108d8ef:	jne    108dac5 <check_input_expressions+0x4ea5>
 108d8f5:	mov    0xa8(%rbx),%rax
 108d8fc:	mov    0x10(%rsp),%r14
 108d901:	mov    $0x1,%ebp
 108d906:	mov    %rbx,%r12
 108d909:	cmpl   $0x0,(%rax,%r14,4)
 108d90e:	mov    $0x18,%eax
 108d913:	setne  %r13b
 108d917:	jmp    108cafb <check_input_expressions+0x3edb>
 108d91c:	cmp    $0x1,%ebp
 108d91f:	movl   $0x0,0x38(%rsp)
 108d927:	sete   %al
 108d92a:	xor    %ecx,%ecx
 108d92c:	cmp    $0x14,%edi
 108d92f:	sete   %cl
 108d932:	cmp    $0x18,%edi
 108d935:	sete   %r13b
 108d939:	or     %cl,%r13b
 108d93c:	and    %al,%r13b
 108d93f:	mov    %rcx,%rax
 108d942:	xor    $0x29,%eax
 108d945:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108d94a:	cmp    $0x1,%ebp
 108d94d:	jne    108da83 <check_input_expressions+0x4e63>
 108d953:	mov    0x10(%rsp),%rcx
 108d958:	mov    0x78(%rsp),%rdx
 108d95d:	inc    %ecx
 108d95f:	cmp    (%rdx),%ecx
 108d961:	jae    108da83 <check_input_expressions+0x4e63>
 108d967:	mov    %ecx,%ecx
 108d969:	cmpb   $0x3,(%rax,%rcx,1)
 108d96d:	sete   %r13b
 108d971:	jmp    108da86 <check_input_expressions+0x4e66>
 108d976:	mov    0x48(%rsp),%rsi
 108d97b:	and    $0xfe,%sil
 108d97f:	cmp    $0x3c,%sil
 108d983:	jne    108dad2 <check_input_expressions+0x4eb2>
 108d989:	mov    0x208(%rbx),%rax
 108d990:	mov    0x10(%rsp),%rcx
 108d995:	movzwl (%rax,%rcx,2),%r15d
 108d99a:	mov    0x218(%r13),%rax
 108d9a1:	test   %rax,%rax
 108d9a4:	je     108e143 <check_input_expressions+0x5523>
 108d9aa:	mov    0x10(%rsp),%rcx
 108d9af:	mov    %r15d,%edi
 108d9b2:	mov    (%rax,%rcx,4),%r14d
 108d9b6:	vzeroupper
 108d9b9:	call   1088ae0 <check_graph_builtin_op>
 108d9be:	test   %r14d,%r14d
 108d9c1:	je     108e14e <check_input_expressions+0x552e>
 108d9c7:	movl   $0x0,0x38(%rsp)
 108d9cf:	mov    $0x43,%eax
 108d9d4:	jmp    108d368 <check_input_expressions+0x4748>
 108d9d9:	mov    0xa8(%rbx),%rax
 108d9e0:	mov    0x10(%rsp),%rcx
 108d9e5:	cmp    $0x1,%ebp
 108d9e8:	sete   %dil
 108d9ec:	mov    (%rax,%rcx,4),%ecx
 108d9ef:	test   %ecx,%ecx
 108d9f1:	je     108da9e <check_input_expressions+0x4e7e>
 108d9f7:	mov    0x18(%rsp),%rdx
 108d9fc:	mov    0x10(%rsp),%rsi
 108da01:	mov    0x78(%rsp),%r8
 108da06:	mov    0x60(%rdx),%rdx
 108da0a:	mov    (%rdx,%rsi,4),%edx
 108da0d:	cmp    (%r8),%edx
 108da10:	jae    108da9e <check_input_expressions+0x4e7e>
 108da16:	vpmovsxbq -0xbefe1f(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108da1f:	mov    0x18(%rsp),%r9
 108da24:	mov    0xc(%rsp),%r8d
 108da29:	mov    %ecx,(%rax,%rdx,4)
 108da2c:	mov    %rbx,%r12
 108da2f:	vxorps %xmm2,%xmm2,%xmm2
 108da33:	mov    $0xffffffff,%r11d
 108da39:	cmp    $0x1,%ebp
 108da3c:	mov    $0x1,%ebp
 108da41:	jne    1088c90 <check_input_expressions+0x70>
 108da47:	jmp    108de66 <check_input_expressions+0x5246>
 108da4c:	cmp    $0x2,%ebp
 108da4f:	mov    $0x1d,%eax
 108da54:	movl   $0x0,0x38(%rsp)
 108da5c:	sete   %r13b
 108da60:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108da65:	mov    %ebp,%eax
 108da67:	and    $0xfffffffe,%eax
 108da6a:	cmp    $0x2,%eax
 108da6d:	mov    $0x17,%eax
 108da72:	sete   %r13b
 108da76:	movl   $0x0,0x38(%rsp)
 108da7e:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108da83:	xor    %r13d,%r13d
 108da86:	xor    %eax,%eax
 108da88:	cmp    $0x17,%edi
 108da8b:	movl   $0x0,0x38(%rsp)
 108da93:	sete   %al
 108da96:	or     $0x20,%eax
 108da99:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108da9e:	vpmovsxbq -0xbefea7(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108daa7:	mov    0x18(%rsp),%r9
 108daac:	mov    0xc(%rsp),%r8d
 108dab1:	mov    $0xffffffff,%r11d
 108dab7:	mov    %rbx,%r12
 108daba:	vxorps %xmm2,%xmm2,%xmm2
 108dabe:	mov    %edi,%esi
 108dac0:	jmp    108de5d <check_input_expressions+0x523d>
 108dac5:	mov    $0xffffffff,%r15d
 108dacb:	xor    %esi,%esi
 108dacd:	jmp    108d314 <check_input_expressions+0x46f4>
 108dad2:	mov    0x48(%rsp),%r15
 108dad7:	mov    0x18(%rsp),%r9
 108dadc:	mov    0x10(%rsp),%r14
 108dae1:	mov    %rbx,%r12
 108dae4:	cmp    $0x1a,%r15b
 108dae8:	jne    108e001 <check_input_expressions+0x53e1>
 108daee:	mov    0xf8(%r12),%rax
 108daf6:	mov    (%rax,%r14,4),%eax
 108dafa:	test   %rax,%rax
 108dafd:	setne  %cl
 108db00:	cmp    $0x2,%ebp
 108db03:	setb   %dl
 108db06:	and    %cl,%dl
 108db08:	mov    %edx,0x60(%rsp)
 108db0c:	cmp    $0x1,%ebp
 108db0f:	jne    108db5e <check_input_expressions+0x4f3e>
 108db11:	vpmovsxbq -0xbeff1a(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108db1a:	mov    0xa8(%r12),%rcx
 108db22:	mov    0xc(%rsp),%r8d
 108db27:	mov    0x60(%rsp),%r13d
 108db2c:	mov    $0x1,%ebp
 108db31:	movl   $0x0,0x38(%rsp)
 108db39:	vxorps %xmm2,%xmm2,%xmm2
 108db3d:	mov    $0xffffffff,%r11d
 108db43:	mov    %eax,(%rcx,%r14,4)
 108db47:	mov    $0x24,%eax
 108db4c:	mov    0x20(%rsp),%esi
 108db50:	mov    0x40(%rsp),%edx
 108db54:	mov    0x28(%rsp),%r10d
 108db59:	jmp    1089239 <check_input_expressions+0x619>
 108db5e:	mov    0x18(%r12),%rdx
 108db63:	shr    $0x3,%eax
 108db66:	mov    %r12,%rbx
 108db69:	mov    (%rdx),%rcx
 108db6c:	movzbl (%rcx,%rax,1),%esi
 108db70:	cmp    $0xf,%sil
 108db74:	jne    108db84 <check_input_expressions+0x4f64>
 108db76:	mov    0x20(%rdx),%rdx
 108db7a:	mov    (%rdx,%rax,4),%eax
 108db7d:	shr    $0x3,%eax
 108db80:	movzbl (%rcx,%rax,1),%esi
 108db84:	cmp    $0x1,%sil
 108db88:	je     108dc04 <check_input_expressions+0x4fe4>
 108db8a:	mov    0x70(%rsp),%rax
 108db8f:	mov    0x58(%rax),%rax
 108db93:	test   %rax,%rax
 108db96:	je     108dbb2 <check_input_expressions+0x4f92>
 108db98:	mov    0x70(%rsp),%rcx
 108db9d:	mov    0x10(%rsp),%rdx
 108dba2:	cmp    0x60(%rcx),%edx
 108dba5:	jae    108dbb2 <check_input_expressions+0x4f92>
 108dba7:	mov    0x10(%rsp),%rcx
 108dbac:	cmpb   $0x0,(%rax,%rcx,1)
 108dbb0:	jne    108dc04 <check_input_expressions+0x4fe4>
 108dbb2:	mov    0x230(%r13),%eax
 108dbb9:	cmp    0x234(%r13),%eax
 108dbc0:	jae    108dbfc <check_input_expressions+0x4fdc>
 108dbc2:	movzbl 0x3bd(%r13),%ecx
 108dbca:	lea    0x1(%rax),%esi
 108dbcd:	mov    0x228(%r13),%rdx
 108dbd4:	lea    (%rax,%rax,2),%rax
 108dbd8:	mov    %esi,0x230(%r13)
 108dbdf:	mov    0x10(%rsp),%rsi
 108dbe4:	xor    $0x1,%ecx
 108dbe7:	lea    0x4(%rcx,%rcx,1),%ecx
 108dbeb:	mov    %esi,(%rdx,%rax,4)
 108dbee:	mov    %ecx,0x4(%rdx,%rax,4)
 108dbf2:	movl   $0x0,0x8(%rdx,%rax,4)
 108dbfa:	jmp    108dc04 <check_input_expressions+0x4fe4>
 108dbfc:	movb   $0x1,0x3bd(%r13)
 108dc04:	vpmovsxbq -0xbf000d(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108dc0d:	cmpb   $0x0,0x60(%rsp)
 108dc12:	mov    0x18(%rsp),%r9
 108dc17:	mov    0xc(%rsp),%r8d
 108dc1c:	mov    $0xffffffff,%r11d
 108dc22:	mov    %rbx,%r12
 108dc25:	vxorps %xmm2,%xmm2,%xmm2
 108dc29:	jne    1088c90 <check_input_expressions+0x70>
 108dc2f:	mov    $0xffffffff,%r15d
 108dc35:	xor    %esi,%esi
 108dc37:	mov    (%r12),%rax
 108dc3b:	cmpl   $0x0,0x230(%rax)
 108dc42:	jne    108dc7d <check_input_expressions+0x505d>
 108dc44:	cmpl   $0x0,0x234(%rax)
 108dc4b:	je     108de4c <check_input_expressions+0x522c>
 108dc51:	movzbl 0x3bd(%rax),%ecx
 108dc58:	mov    0x228(%rax),%rdx
 108dc5f:	movl   $0x1,0x230(%rax)
 108dc69:	mov    0x10(%rsp),%rax
 108dc6e:	shl    $0x2,%ecx
 108dc71:	mov    %eax,(%rdx)
 108dc73:	mov    %ecx,0x4(%rdx)
 108dc76:	movl   $0x0,0x8(%rdx)
 108dc7d:	cmp    $0xffffffff,%r15d
 108dc81:	je     108de5d <check_input_expressions+0x523d>
 108dc87:	mov    (%r12),%rax
 108dc8b:	mov    0x70(%rsp),%rbx
 108dc90:	mov    0x10(%rsp),%r14
 108dc95:	mov    0x220(%rax),%rcx
 108dc9c:	mov    %r15d,%eax
 108dc9f:	test   %rcx,%rcx
 108dca2:	je     108dcfa <check_input_expressions+0x50da>
 108dca4:	mov    0x10(%rbx),%rdx
 108dca8:	mov    0x78(%rsp),%rsi
 108dcad:	mov    (%rdx,%rax,4),%edx
 108dcb0:	cmp    %r11,%rdx
 108dcb3:	je     108dcc0 <check_input_expressions+0x50a0>
 108dcb5:	shl    $0x2,%rdx
 108dcb9:	add    0x8(%rbx),%rdx
 108dcbd:	mov    %rdx,%rsi
 108dcc0:	mov    (%rbx),%rdx
 108dcc3:	mov    (%rsi),%esi
 108dcc5:	mov    (%rdx,%rax,4),%edi
 108dcc8:	xor    %edx,%edx
 108dcca:	cmp    $0x34,%edi
 108dccd:	je     108dcea <check_input_expressions+0x50ca>
 108dccf:	cmp    $0x19,%edi
 108dcd2:	je     108dcea <check_input_expressions+0x50ca>
 108dcd4:	test   %edi,%edi
 108dcd6:	jne    108dcf6 <check_input_expressions+0x50d6>
 108dcd8:	mov    0x28(%rbx),%rdx
 108dcdc:	lea    (%rax,%rax,2),%rsi
 108dce0:	shl    $0x5,%rsi
 108dce4:	mov    0x44(%rdx,%rsi,1),%edx
 108dce8:	jmp    108dcf6 <check_input_expressions+0x50d6>
 108dcea:	mov    0x78(%rsp),%rdi
 108dcef:	cmp    (%rdi),%esi
 108dcf1:	jae    108dcf6 <check_input_expressions+0x50d6>
 108dcf3:	mov    (%rcx,%rsi,4),%edx
 108dcf6:	mov    %edx,(%rcx,%r14,4)
 108dcfa:	mov    0x280(%r12),%rcx
 108dd02:	cmpb   $0x0,(%rcx,%r14,1)
 108dd07:	je     108dec0 <check_input_expressions+0x52a0>
 108dd0d:	mov    (%rbx),%rcx
 108dd10:	cmpl   $0x3c,(%rcx,%rax,4)
 108dd14:	jne    108dec0 <check_input_expressions+0x52a0>
 108dd1a:	mov    0x38(%rbx),%rcx
 108dd1e:	cmpl   $0x120,(%rcx,%rax,4)
 108dd25:	jne    108dec0 <check_input_expressions+0x52a0>
 108dd2b:	mov    0x370(%r12),%rax
 108dd33:	vpxor  %xmm0,%xmm0,%xmm0
 108dd37:	mov    (%rax,%r14,4),%esi
 108dd3b:	vmovdqu64 %zmm0,0x130(%rsp)
 108dd46:	vmovdqu64 %zmm0,0x110(%rsp)
 108dd51:	cmp    %r14d,%esi
 108dd54:	jae    108dec0 <check_input_expressions+0x52a0>
 108dd5a:	lea    0x1(%r14),%edx
 108dd5e:	mov    %r12,%rdi
 108dd61:	xor    %ecx,%ecx
 108dd63:	mov    $0x1,%r8d
 108dd69:	lea    0x110(%rsp),%r9
 108dd71:	push   $0x0
 108dd73:	lea    0xf8(%rsp),%rax
 108dd7b:	push   %rax
 108dd7c:	vzeroupper
 108dd7f:	call   10c1fc0 <check_input_constant_read>
 108dd84:	add    $0x10,%rsp
 108dd88:	test   %al,%al
 108dd8a:	je     108dea8 <check_input_expressions+0x5288>
 108dd90:	vpmovsxbq -0xbf0199(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108dd99:	cmpl   $0x0,0x11c(%rsp)
 108dda1:	mov    0x18(%rsp),%r9
 108dda6:	mov    $0xffffffff,%r11d
 108ddac:	vxorps %xmm2,%xmm2,%xmm2
 108ddb0:	je     108dec0 <check_input_expressions+0x52a0>
 108ddb6:	cmpl   $0x0,0x164(%rsp)
 108ddbe:	jne    108dec0 <check_input_expressions+0x52a0>
 108ddc4:	testb  $0x10,0x118(%rsp)
 108ddcc:	jne    108dec0 <check_input_expressions+0x52a0>
 108ddd2:	mov    $0xffffffff,%ecx
 108ddd7:	mov    $0xffffffff,%r8d
 108dddd:	mov    $0xffffffff,%r9d
 108dde3:	mov    %r12,%rdi
 108dde6:	xor    %esi,%esi
 108dde8:	mov    %r14d,%edx
 108ddeb:	call   10facf0 <check_input_add>
 108ddf0:	vpmovsxbq -0xbf01f9(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108ddf9:	mov    0x18(%rsp),%r9
 108ddfe:	mov    $0xffffffff,%r11d
 108de04:	vxorps %xmm2,%xmm2,%xmm2
 108de08:	cmp    $0xffffffff,%eax
 108de0b:	je     108dec0 <check_input_expressions+0x52a0>
 108de11:	vmovdqu64 0x110(%rsp),%zmm0
 108de1c:	vmovups 0x130(%rsp),%zmm1
 108de27:	mov    0x28(%rbx),%rcx
 108de2b:	mov    %eax,%edx
 108de2d:	lea    (%rdx,%rdx,2),%rdx
 108de31:	mov    %eax,%r15d
 108de34:	shl    $0x5,%rdx
 108de38:	vmovups %zmm1,0x20(%rcx,%rdx,1)
 108de43:	vmovdqu64 %zmm0,(%rcx,%rdx,1)
 108de4a:	jmp    108dec0 <check_input_expressions+0x52a0>
 108de4c:	movb   $0x1,0x3bd(%rax)
 108de53:	cmp    $0xffffffff,%r15d
 108de57:	jne    108dc87 <check_input_expressions+0x5067>
 108de5d:	test   %sil,%sil
 108de60:	je     1088c90 <check_input_expressions+0x70>
 108de66:	mov    (%r12),%r13
 108de6a:	mov    0x2c0(%r13),%rcx
 108de71:	mov    0x10(%rsp),%rdx
 108de76:	cmp    $0x1,%ebp
 108de79:	mov    $0xffffffff,%eax
 108de7e:	cmove  %r8d,%eax
 108de82:	mov    %eax,(%rcx,%rdx,4)
 108de85:	mov    0xa4(%rsp),%ecx
 108de8c:	mov    0x380(%r12),%rax
 108de94:	mov    %r8d,(%rax,%rdx,4)
 108de98:	mov    0x388(%r12),%rax
 108dea0:	mov    %ecx,(%rax,%rdx,4)
 108dea3:	jmp    1088c90 <check_input_expressions+0x70>
 108dea8:	vpmovsxbq -0xbf02b1(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108deb1:	mov    0x18(%rsp),%r9
 108deb6:	vxorps %xmm2,%xmm2,%xmm2
 108deba:	mov    $0xffffffff,%r11d
 108dec0:	mov    (%r12),%rax
 108dec4:	cmpb   $0x1a,0x48(%rsp)
 108dec9:	mov    0x2c0(%rax),%rax
 108ded0:	mov    %r15d,(%rax,%r14,4)
 108ded4:	je     1088c90 <check_input_expressions+0x70>
 108deda:	movzbl 0x48(%rsp),%eax
 108dedf:	cmp    $0x49,%eax
 108dee2:	je     1088c90 <check_input_expressions+0x70>
 108dee8:	mov    0x380(%r12),%rax
 108def0:	mov    0x10(%rsp),%rcx
 108def5:	mov    %r15d,(%rax,%rcx,4)
 108def9:	mov    0x388(%r12),%rax
 108df01:	mov    %r15d,(%rax,%rcx,4)
 108df05:	jmp    1088c90 <check_input_expressions+0x70>
 108df0a:	test   %al,%al
 108df0c:	je     108df51 <check_input_expressions+0x5331>
 108df0e:	mov    0x20(%rsp),%rdi
 108df13:	mov    $0x3b,%esi
 108df18:	mov    $0xffffffff,%r8d
 108df1e:	mov    $0xffffffff,%r9d
 108df24:	mov    0x10(%rsp),%rdx
 108df29:	mov    %r12d,%ecx
 108df2c:	vzeroupper
 108df2f:	call   10facf0 <check_input_add>
 108df34:	cmp    $0xffffffff,%eax
 108df37:	je     108df51 <check_input_expressions+0x5331>
 108df39:	mov    0x60(%rsp),%rcx
 108df3e:	mov    %eax,%r15d
 108df41:	mov    0x30(%rsp),%edx
 108df45:	mov    0x30(%rcx),%rax
 108df49:	mov    %r15d,%ecx
 108df4c:	mov    %edx,(%rax,%rcx,4)
 108df4f:	jmp    108dfa9 <check_input_expressions+0x5389>
 108df51:	mov    0x20(%rsp),%rax
 108df56:	mov    (%rax),%rax
 108df59:	mov    0x230(%rax),%ecx
 108df5f:	cmp    0x234(%rax),%ecx
 108df65:	jae    108df9c <check_input_expressions+0x537c>
 108df67:	movzbl 0x3bd(%rax),%edx
 108df6e:	lea    0x1(%rcx),%edi
 108df71:	mov    0x228(%rax),%rsi
 108df78:	mov    %edi,0x230(%rax)
 108df7e:	lea    (%rcx,%rcx,2),%rax
 108df82:	mov    0x10(%rsp),%rcx
 108df87:	lea    0x1(%rdx,%rdx,2),%edx
 108df8b:	mov    %ecx,(%rsi,%rax,4)
 108df8e:	mov    %edx,0x4(%rsi,%rax,4)
 108df92:	movl   $0x0,0x8(%rsi,%rax,4)
 108df9a:	jmp    108dfa3 <check_input_expressions+0x5383>
 108df9c:	movb   $0x1,0x3bd(%rax)
 108dfa3:	mov    $0xffffffff,%r15d
 108dfa9:	mov    0x20(%rsp),%rax
 108dfae:	mov    0x80(%rsp),%rcx
 108dfb6:	mov    0x28(%rax),%rax
 108dfba:	cmp    0x8(%rax),%rcx
 108dfbe:	ja     108e645 <check_input_expressions+0x5a25>
 108dfc4:	vpmovsxbq -0xbf03cd(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108dfcd:	mov    0x80(%rsp),%rcx
 108dfd5:	mov    0x20(%rsp),%r12
 108dfda:	mov    0x18(%rsp),%r9
 108dfdf:	mov    0xc(%rsp),%r8d
 108dfe4:	mov    $0xffffffff,%r11d
 108dfea:	vxorps %xmm2,%xmm2,%xmm2
 108dfee:	mov    %rcx,0x8(%rax)
 108dff2:	cmp    $0xffffffff,%r15d
 108dff6:	jne    108dc87 <check_input_expressions+0x5067>
 108dffc:	jmp    108dc2f <check_input_expressions+0x500f>
 108e001:	mov    $0xffffffff,%r15d
 108e007:	add    $0xfffffff8,%edx
 108e00a:	cmp    $0x4b,%edx
 108e00d:	ja     108e219 <check_input_expressions+0x55f9>
 108e013:	lea    -0xbf020a(%rip),%rsi        # 49de10 <cbuiltin_test_generated.edges+0x3fd0>
 108e01a:	movslq (%rsi,%rdx,4),%rdx
 108e01e:	add    %rsi,%rdx
 108e021:	jmp    *%rdx
 108e023:	mov    0x270(%rbx),%rax
 108e02a:	mov    0x10(%rsp),%rdx
 108e02f:	mov    0x18(%rsp),%rsi
 108e034:	cmpb   $0x0,(%rax,%rdx,1)
 108e038:	sete   %al
 108e03b:	cmp    $0x2,%ebp
 108e03e:	setb   %cl
 108e041:	or     %al,%cl
 108e043:	mov    0x60(%rsi),%rax
 108e047:	mov    %ecx,0x60(%rsp)
 108e04b:	mov    (%rax,%rdx,4),%eax
 108e04e:	cmp    0x30(%rsi),%eax
 108e051:	jae    108e094 <check_input_expressions+0x5474>
 108e053:	mov    0x318(%r13),%rcx
 108e05a:	mov    (%rcx,%rax,4),%ecx
 108e05d:	test   %ecx,%ecx
 108e05f:	je     108e094 <check_input_expressions+0x5474>
 108e061:	mov    0x310(%r13),%rax
 108e068:	mov    0x10(%rsp),%rdx
 108e06d:	dec    %ecx
 108e06f:	lea    (%rcx,%rcx,2),%rcx
 108e073:	cmp    %edx,0x14(%rax,%rcx,8)
 108e077:	jne    108e094 <check_input_expressions+0x5474>
 108e079:	cmp    $0x1,%ebp
 108e07c:	mov    $0xffffffff,%edx
 108e081:	lea    (%rax,%rcx,8),%rax
 108e085:	cmove  0xc(%rsp),%edx
 108e08a:	sete   %cl
 108e08d:	mov    %ecx,0x60(%rsp)
 108e091:	mov    %edx,0x10(%rax)
 108e094:	cmpl   $0xffffffff,0xc(%rsp)
 108e099:	je     108e465 <check_input_expressions+0x5845>
 108e09f:	mov    0xc(%rsp),%r15d
 108e0a4:	mov    $0xffffffff,%r14d
 108e0aa:	jmp    108e0ca <check_input_expressions+0x54aa>
 108e0ac:	mov    %r14d,%eax
 108e0af:	mov    0x390(%rbx),%rcx
 108e0b6:	mov    %r15d,%edx
 108e0b9:	mov    %eax,%r14d
 108e0bc:	mov    (%rcx,%rdx,4),%r15d
 108e0c0:	cmp    $0xffffffff,%r15d
 108e0c4:	je     108dc04 <check_input_expressions+0x4fe4>
 108e0ca:	mov    0x270(%rbx),%rax
 108e0d1:	mov    0x10(%rsp),%rdx
 108e0d6:	mov    $0x25,%esi
 108e0db:	mov    $0xffffffff,%r8d
 108e0e1:	mov    $0xffffffff,%r9d
 108e0e7:	mov    %rbx,%rdi
 108e0ea:	mov    %r15d,%ecx
 108e0ed:	cmpb   $0x0,(%rax,%rdx,1)
 108e0f1:	mov    $0x18,%eax
 108e0f6:	cmove  %eax,%esi
 108e0f9:	vzeroupper
 108e0fc:	call   10facf0 <check_input_add>
 108e101:	cmp    $0xffffffff,%eax
 108e104:	je     108e0ac <check_input_expressions+0x548c>
 108e106:	mov    0x70(%rsp),%rcx
 108e10b:	mov    %eax,%edx
 108e10d:	mov    0x30(%rcx),%rcx
 108e111:	movl   $0x8,(%rcx,%rdx,4)
 108e118:	mov    0x278(%rbx),%rcx
 108e11f:	test   %rcx,%rcx
 108e122:	je     108e0ac <check_input_expressions+0x548c>
 108e124:	cmp    $0xffffffff,%r14d
 108e128:	je     108e136 <check_input_expressions+0x5516>
 108e12a:	mov    0x390(%rbx),%rcx
 108e131:	mov    %r14d,%edx
 108e134:	jmp    108e13b <check_input_expressions+0x551b>
 108e136:	mov    0x10(%rsp),%rdx
 108e13b:	mov    %eax,(%rcx,%rdx,4)
 108e13e:	jmp    108e0af <check_input_expressions+0x548f>
 108e143:	mov    %r15d,%edi
 108e146:	vzeroupper
 108e149:	call   1088ae0 <check_graph_builtin_op>
 108e14e:	lea    -0x153(%r15),%ecx
 108e155:	cmp    $0x6,%cx
 108e159:	jae    108e17d <check_input_expressions+0x555d>
 108e15b:	cmp    $0x1,%ebp
 108e15e:	mov    $0x40,%eax
 108e163:	movl   $0x0,0x38(%rsp)
 108e16b:	sete   %r13b
 108e16f:	cmp    $0x156,%r15w
 108e175:	sbb    $0xffffffff,%eax
 108e178:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108e17d:	cmp    $0x36,%eax
 108e180:	jne    108e1a3 <check_input_expressions+0x5583>
 108e182:	cmp    $0x3,%ebp
 108e185:	mov    $0x36,%eax
 108e18a:	movl   $0x0,0x38(%rsp)
 108e192:	sete   %r13b
 108e196:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108e19b:	xor    %r8d,%r8d
 108e19e:	jmp    108d3f4 <check_input_expressions+0x47d4>
 108e1a3:	lea    -0x13(%r15),%esi
 108e1a7:	test   %r15d,%r15d
 108e1aa:	je     108e1d9 <check_input_expressions+0x55b9>
 108e1ac:	cmp    $0x45,%eax
 108e1af:	jne    108e20c <check_input_expressions+0x55ec>
 108e1b1:	xor    %ecx,%ecx
 108e1b3:	cmp    $0x3,%si
 108e1b7:	setb   %cl
 108e1ba:	cmp    $0x16,%r15w
 108e1bf:	lea    0x1(%rcx,%rcx,1),%ecx
 108e1c3:	setb   %dl
 108e1c6:	cmp    %ecx,%ebp
 108e1c8:	sete   %r13b
 108e1cc:	and    %dl,%r13b
 108e1cf:	jmp    108e1e8 <check_input_expressions+0x55c8>
 108e1d1:	xor    %r14d,%r14d
 108e1d4:	jmp    108d3f4 <check_input_expressions+0x47d4>
 108e1d9:	test   %ebp,%ebp
 108e1db:	setne  %r13b
 108e1df:	cmp    $0x45,%eax
 108e1e2:	jne    108da76 <check_input_expressions+0x4e56>
 108e1e8:	cmp    $0x3,%si
 108e1ec:	mov    $0x0,%ecx
 108e1f1:	mov    $0x22,%eax
 108e1f6:	movl   $0x0,0x38(%rsp)
 108e1fe:	adc    $0x35,%ecx
 108e201:	test   %r15d,%r15d
 108e204:	cmove  %eax,%ecx
 108e207:	jmp    108ccf1 <check_input_expressions+0x40d1>
 108e20c:	movl   $0x0,0x38(%rsp)
 108e214:	jmp    108d368 <check_input_expressions+0x4748>
 108e219:	test   %cl,%cl
 108e21b:	je     108e472 <check_input_expressions+0x5852>
 108e221:	mov    0x18(%rsp),%rdx
 108e226:	mov    0x10(%rsp),%rsi
 108e22b:	mov    0x60(%rdx),%rcx
 108e22f:	mov    0x30(%rdx),%edx
 108e232:	mov    (%rcx,%rsi,4),%esi
 108e235:	cmp    %edx,%esi
 108e237:	jae    108dacb <check_input_expressions+0x4eab>
 108e23d:	movzbl (%rax,%rsi,1),%edi
 108e241:	cmp    $0x1e,%edi
 108e244:	je     108dacb <check_input_expressions+0x4eab>
 108e24a:	vpmovsxbq -0xbf0653(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108e253:	mov    0x18(%rsp),%r9
 108e258:	mov    $0xffffffff,%r11d
 108e25e:	mov    %rbx,%r12
 108e261:	vxorps %xmm2,%xmm2,%xmm2
 108e265:	cmp    $0x48,%edi
 108e268:	jne    108e232 <check_input_expressions+0x5612>
 108e26a:	jmp    1088c90 <check_input_expressions+0x70>
 108e26f:	cmp    $0x2,%ebp
 108e272:	jne    108dacb <check_input_expressions+0x4eab>
 108e278:	mov    0x18(%rsp),%rdx
 108e27d:	mov    0x10(%rsp),%rsi
 108e282:	mov    0x60(%rdx),%rcx
 108e286:	mov    (%rcx,%rsi,4),%ecx
 108e289:	cmp    0x30(%rdx),%ecx
 108e28c:	jae    108e5f6 <check_input_expressions+0x59d6>
 108e292:	cmpb   $0x53,(%rax,%rcx,1)
 108e296:	mov    $0x2,%ebp
 108e29b:	je     108ceca <check_input_expressions+0x42aa>
 108e2a1:	jmp    108dacb <check_input_expressions+0x4eab>
 108e2a6:	mov    0x208(%rbx),%rax
 108e2ad:	mov    0x10(%rsp),%rcx
 108e2b2:	movzwl (%rax,%rcx,2),%edi
 108e2b6:	test   %edi,%edi
 108e2b8:	je     108e580 <check_input_expressions+0x5960>
 108e2be:	vzeroupper
 108e2c1:	call   1088ae0 <check_graph_builtin_op>
 108e2c6:	cmp    $0x45,%eax
 108e2c9:	movl   $0x0,0x38(%rsp)
 108e2d1:	setne  %r13b
 108e2d5:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108e2da:	mov    0x370(%rbx),%rax
 108e2e1:	mov    0x10(%rsp),%rcx
 108e2e6:	mov    0x78(%rsp),%rdx
 108e2eb:	cmp    $0x1,%ebp
 108e2ee:	sete   %r13b
 108e2f2:	mov    (%rax,%rcx,4),%eax
 108e2f5:	cmp    (%rdx),%eax
 108e2f7:	jae    108e4b1 <check_input_expressions+0x5891>
 108e2fd:	mov    0x18(%rsp),%r9
 108e302:	movl   $0x0,0x38(%rsp)
 108e30a:	mov    %rbx,%r12
 108e30d:	mov    0x10(%r9),%rcx
 108e311:	cmpb   $0x49,(%rcx,%rax,1)
 108e315:	mov    $0x25,%ecx
 108e31a:	mov    $0x1,%eax
 108e31f:	cmove  %eax,%ecx
 108e322:	mov    %rcx,%rax
 108e325:	jmp    108ccfc <check_input_expressions+0x40dc>
 108e32a:	mov    0x150(%rbx),%rax
 108e331:	mov    0x10(%rsp),%rcx
 108e336:	mov    (%rax,%rcx,4),%r14d
 108e33a:	cmp    %r8,%r14
 108e33d:	je     108dacb <check_input_expressions+0x4eab>
 108e343:	mov    0x280(%r13),%rax
 108e34a:	cmpb   $0x0,(%rax,%r14,1)
 108e34f:	je     108dacb <check_input_expressions+0x4eab>
 108e355:	mov    $0xffffffff,%ecx
 108e35a:	mov    $0xffffffff,%r8d
 108e360:	mov    $0xffffffff,%r9d
 108e366:	mov    0x10(%rsp),%rdx
 108e36b:	mov    %rbx,%r12
 108e36e:	mov    %rbx,%rdi
 108e371:	xor    %esi,%esi
 108e373:	vzeroupper
 108e376:	call   10facf0 <check_input_add>
 108e37b:	vpmovsxbq -0xbf0784(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108e384:	mov    0x18(%rsp),%r9
 108e389:	mov    $0xffffffff,%r11d
 108e38f:	vxorps %xmm2,%xmm2,%xmm2
 108e393:	cmp    $0xffffffff,%eax
 108e396:	je     1088c90 <check_input_expressions+0x70>
 108e39c:	mov    0x118(%r12),%rsi
 108e3a4:	mov    %eax,%r15d
 108e3a7:	mov    %r15d,%ecx
 108e3aa:	lea    (%rcx,%rcx,2),%rcx
 108e3ae:	mov    0xa0(%r12),%rdx
 108e3b6:	mov    $0x10,%edi
 108e3bb:	mov    0x70(%rsp),%rax
 108e3c0:	shl    $0x5,%rcx
 108e3c4:	cmpb   $0x0,(%rsi,%r14,1)
 108e3c9:	mov    $0x80,%esi
 108e3ce:	vmovd  (%rdx,%r14,4),%xmm0
 108e3d4:	mov    0x28(%rax),%rax
 108e3d8:	mov    $0x1,%edx
 108e3dd:	cmove  %edi,%esi
 108e3e0:	mov    0x130(%r12),%rdi
 108e3e8:	vpinsrd $0x1,%edx,%xmm0,%xmm0
 108e3ee:	mov    $0x3,%edx
 108e3f3:	vpinsrd $0x2,%esi,%xmm0,%xmm0
 108e3f9:	mov    (%rdi,%r14,4),%edi
 108e3fd:	vpinsrd $0x3,%edx,%xmm0,%xmm0
 108e403:	vmovdqa %xmm0,(%rax,%rcx,1)
 108e408:	vpxor  %xmm0,%xmm0,%xmm0
 108e40c:	vmovdqu %ymm0,0x10(%rax,%rcx,1)
 108e412:	vmovdqu %ymm0,0x20(%rax,%rcx,1)
 108e418:	mov    %edi,0x40(%rax,%rcx,1)
 108e41c:	jmp    108cde5 <check_input_expressions+0x41c5>
 108e421:	mov    0x370(%rbx),%rax
 108e428:	mov    0x10(%rsp),%rcx
 108e42d:	mov    0x78(%rsp),%rdx
 108e432:	mov    (%rax,%rcx,4),%ecx
 108e435:	cmp    (%rdx),%ecx
 108e437:	jae    108e4c3 <check_input_expressions+0x58a3>
 108e43d:	mov    0x18(%rsp),%rax
 108e442:	xor    %esi,%esi
 108e444:	mov    %ebp,%edi
 108e446:	sub    $0x1,%edi
 108e449:	setb   %sil
 108e44d:	mov    0x10(%rax),%rdx
 108e451:	xor    %eax,%eax
 108e453:	cmp    $0x2,%edi
 108e456:	setb   %al
 108e459:	cmpb   $0x4b,(%rdx,%rcx,1)
 108e45d:	sete   %cl
 108e460:	cmove  %esi,%eax
 108e463:	jmp    108e4ce <check_input_expressions+0x58ae>
 108e465:	movl   $0xffffffff,0xc(%rsp)
 108e46d:	jmp    108dc04 <check_input_expressions+0x4fe4>
 108e472:	vpmovsxbq -0xbf087b(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108e47b:	mov    0x18(%rsp),%r9
 108e480:	mov    0xc(%rsp),%r8d
 108e485:	add    $0xffffffcb,%edi
 108e488:	mov    $0xffffffff,%r11d
 108e48e:	mov    %rbx,%r12
 108e491:	vxorps %xmm2,%xmm2,%xmm2
 108e495:	cmp    $0x1c,%edi
 108e498:	ja     1088c90 <check_input_expressions+0x70>
 108e49e:	mov    $0x1c73b79b,%eax
 108e4a3:	bt     %edi,%eax
 108e4a6:	jb     108b2d1 <check_input_expressions+0x26b1>
 108e4ac:	jmp    1088c90 <check_input_expressions+0x70>
 108e4b1:	mov    $0x25,%eax
 108e4b6:	movl   $0x0,0x38(%rsp)
 108e4be:	jmp    108ccf4 <check_input_expressions+0x40d4>
 108e4c3:	lea    -0x1(%rbp),%eax
 108e4c6:	cmp    $0x2,%eax
 108e4c9:	setb   %al
 108e4cc:	xor    %ecx,%ecx
 108e4ce:	mov    0x2f8(%r13),%rdx
 108e4d5:	mov    0x10(%rsp),%rsi
 108e4da:	cmpl   $0xffffffff,(%rdx,%rsi,4)
 108e4de:	setne  %dl
 108e4e1:	and    %al,%dl
 108e4e3:	mov    %edx,0x60(%rsp)
 108e4e7:	test   %cl,%cl
 108e4e9:	jne    108dc04 <check_input_expressions+0x4fe4>
 108e4ef:	cmpb   $0x0,0x60(%rsp)
 108e4f4:	je     108dc04 <check_input_expressions+0x4fe4>
 108e4fa:	mov    0x2c0(%r13),%rax
 108e501:	mov    0x10(%rsp),%rdx
 108e506:	mov    0xc(%rsp),%esi
 108e50a:	cmp    $0x2,%ebp
 108e50d:	vpmovsxbq -0xbf0916(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108e516:	mov    0x18(%rsp),%r9
 108e51b:	mov    $0xffffffff,%r11d
 108e521:	mov    %rbx,%r12
 108e524:	vxorps %xmm2,%xmm2,%xmm2
 108e528:	mov    %esi,(%rax,%rdx,4)
 108e52b:	mov    $0xffffffff,%eax
 108e530:	cmove  0x20(%rsp),%eax
 108e535:	mov    (%rbx),%rcx
 108e538:	mov    0x308(%rcx),%rcx
 108e53f:	mov    %eax,(%rcx,%rdx,4)
 108e542:	mov    0x70(%rsp),%rcx
 108e547:	mov    0x40(%rcx),%rax
 108e54b:	mov    %esi,%ecx
 108e54d:	orb    $0x9,(%rax,%rcx,1)
 108e551:	cmp    $0x2,%ebp
 108e554:	jne    1088c90 <check_input_expressions+0x70>
 108e55a:	mov    0x70(%rsp),%rax
 108e55f:	mov    0x20(%rsp),%ecx
 108e563:	mov    0x40(%rax),%rax
 108e567:	orb    $0x9,(%rax,%rcx,1)
 108e56b:	jmp    1088c90 <check_input_expressions+0x70>
 108e570:	mov    0x20(%rcx),%rax
 108e574:	mov    (%rax,%r8,4),%eax
 108e578:	mov    $0x1,%r8b
 108e57b:	jmp    108d3f4 <check_input_expressions+0x47d4>
 108e580:	mov    0x370(%rbx),%rax
 108e587:	mov    0x10(%rsp),%rcx
 108e58c:	mov    0x78(%rsp),%rdx
 108e591:	mov    (%rax,%rcx,4),%eax
 108e594:	cmp    (%rdx),%eax
 108e596:	jae    108dacb <check_input_expressions+0x4eab>
 108e59c:	mov    0x18(%rsp),%rcx
 108e5a1:	mov    0x10(%rcx),%rcx
 108e5a5:	cmpb   $0x43,(%rcx,%rax,1)
 108e5a9:	sete   %al
 108e5ac:	cmp    $0x1,%ebp
 108e5af:	sete   %cl
 108e5b2:	and    %al,%cl
 108e5b4:	cmp    $0x1,%cl
 108e5b7:	jne    108dacb <check_input_expressions+0x4eab>
 108e5bd:	mov    0x70(%rsp),%rdx
 108e5c2:	mov    0xc(%rsp),%ecx
 108e5c6:	vpmovsxbq -0xbf09cf(%rip),%xmm3        # 49dc00 <cbuiltin_test_generated.edges+0x3dc0>
 108e5cf:	mov    0x18(%rsp),%r9
 108e5d4:	mov    %rbx,%r12
 108e5d7:	vxorps %xmm2,%xmm2,%xmm2
 108e5db:	mov    $0xffffffff,%r11d
 108e5e1:	mov    0x40(%rdx),%rax
 108e5e5:	orb    $0x3,(%rax,%rcx,1)
 108e5e9:	mov    0x40(%rdx),%rax
 108e5ed:	orb    $0x8,(%rax,%rcx,1)
 108e5f1:	jmp    1088c90 <check_input_expressions+0x70>
 108e5f6:	mov    $0x2,%ebp
 108e5fb:	jmp    108dacb <check_input_expressions+0x4eab>
 108e600:	mov    %ecx,%r12d
 108e603:	cmp    $0x1,%r14
 108e607:	je     108d4cf <check_input_expressions+0x48af>
 108e60d:	xor    %r13d,%r13d
 108e610:	jmp    108d436 <check_input_expressions+0x4816>
 108e615:	mov    %fs:0x28,%rax
 108e61e:	cmp    0x170(%rsp),%rax
 108e626:	jne    108e63d <check_input_expressions+0x5a1d>
 108e628:	add    $0x178,%rsp
 108e62f:	pop    %rbx
 108e630:	pop    %r12
 108e632:	pop    %r13
 108e634:	pop    %r14
 108e636:	pop    %r15
 108e638:	pop    %rbp
 108e639:	vzeroupper
 108e63c:	ret
 108e63d:	vzeroupper
 108e640:	call   7878e0 <__stack_chk_fail@plt>
 108e645:	lea    -0x99661c(%rip),%rdi        # 6f8030 <pp_string_value.meaning+0x6faaf>
 108e64c:	lea    -0x9dd36a(%rip),%rsi        # 6b12e9 <pp_string_value.meaning+0x28d68>
 108e653:	lea    -0x9dd356(%rip),%rcx        # 6b1304 <pp_string_value.meaning+0x28d83>
 108e65a:	mov    $0xbd,%edx
 108e65f:	vzeroupper
 108e662:	call   787950 <__assert_fail@plt>
