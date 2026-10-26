
../campaign/native-images/base/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

000000000106cd10 <check_input_run>:
 106cd10:	push   %rbp
 106cd11:	push   %r15
 106cd13:	push   %r14
 106cd15:	push   %r13
 106cd17:	push   %r12
 106cd19:	push   %rbx
 106cd1a:	sub    $0x808,%rsp
 106cd21:	vmovdqa64 -0xbcfa2b(%rip),%zmm1        # 49d300 <cbuiltin_test_generated.edges+0x34c0>
 106cd2b:	mov    %r9,0x38(%rsp)
 106cd30:	mov    %r8,0x10(%rsp)
 106cd35:	mov    %rcx,0xa8(%rsp)
 106cd3d:	vpxor  %xmm0,%xmm0,%xmm0
 106cd41:	vpmovsxbq -0xbcf78a(%rip),%xmm2        # 49d5c0 <cbuiltin_test_generated.edges+0x3780>
 106cd4a:	mov    %rsi,%r12
 106cd4d:	mov    %fs:0x28,%rax
 106cd56:	mov    %rax,0x800(%rsp)
 106cd5e:	vmovdqu64 %zmm0,0x380(%rdi)
 106cd65:	vmovdqu64 %zmm0,0x340(%rdi)
 106cd6c:	vmovdqu64 %zmm0,0x300(%rdi)
 106cd73:	vmovdqu64 %zmm0,0x2c0(%rdi)
 106cd7a:	vmovdqu64 %zmm0,0x280(%rdi)
 106cd81:	vmovdqu64 %zmm0,0x240(%rdi)
 106cd88:	vmovdqu64 %zmm0,0x200(%rdi)
 106cd8f:	vmovdqu64 %zmm0,0x1c0(%rdi)
 106cd96:	vmovdqu64 %zmm0,0x180(%rdi)
 106cd9d:	vmovdqu64 %zmm0,0x140(%rdi)
 106cda4:	vmovdqu64 %zmm0,0x100(%rdi)
 106cdab:	vmovdqu64 %zmm0,0xc0(%rdi)
 106cdb2:	vmovdqu64 %zmm0,0x80(%rdi)
 106cdb9:	vmovdqu64 %zmm0,0x40(%rdi)
 106cdc0:	vmovdqu64 %zmm0,(%rdi)
 106cdc6:	mov    %rdx,0x58(%rsp)
 106cdcb:	mov    %rdi,0x18(%rsp)
 106cdd0:	mov    0x30(%rsi),%r8d
 106cdd4:	vaesenc %zmm0,%zmm1,%zmm1
 106cdda:	vaesenc %zmm0,%zmm1,%zmm0
 106cde0:	mov    %r8d,0x35c(%rdi)
 106cde7:	mov    %r8d,%eax
 106cdea:	mov    %rax,0x78(%rsp)
 106cdef:	mov    %r8,0xf0(%rsp)
 106cdf7:	xor    %eax,%eax
 106cdf9:	mov    0x270(%rdx),%rdx
 106ce00:	vextracti64x4 $0x1,%zmm0,%ymm1
 106ce07:	vpxorq %zmm0,%zmm1,%zmm0
 106ce0d:	vextracti128 $0x1,%ymm0,%xmm1
 106ce13:	mov    0x8(%rdx),%rsi
 106ce17:	mov    (%rdx),%rdi
 106ce1a:	vpxor  %xmm0,%xmm1,%xmm0
 106ce1e:	vpxor  %xmm1,%xmm1,%xmm1
 106ce22:	vaesenc %xmm1,%xmm0,%xmm0
 106ce27:	vmovdqa -0xaddc2f(%rip),%xmm1        # 58f200 <abi_test_hex.digits+0xa30>
 106ce2f:	vmovq  %xmm0,%rcx
 106ce34:	vbroadcasti32x4 -0xaddc3e(%rip),%zmm0        # 58f200 <abi_test_hex.digits+0xa30>
 106ce3e:	and    %rsi,%rcx
 106ce41:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 106ce50:	mov    %rcx,%r8
 106ce53:	shl    $0x6,%r8
 106ce57:	vmovdqa64 (%rdi,%r8,1),%zmm3
 106ce5e:	vpcmpeqd %zmm0,%zmm3,%k0
 106ce64:	kmovd  %k0,%r9d
 106ce68:	and    $0x7777,%r9d
 106ce6f:	add    $0x1111,%r9d
 106ce76:	and    $0x8888,%r9w
 106ce7c:	je     106cef0 <check_input_run+0x1e0>
 106ce7e:	mov    0x10(%rdx),%r10
 106ce82:	add    %rdi,%r8
 106ce85:	movzwl %r9w,%r9d
 106ce89:	jmp    106ce9f <check_input_run+0x18f>
 106ce8b:	nopl   0x0(%rax,%rax,1)
 106ce90:	xor    %r11d,%r11d
 106ce93:	test   %r11b,%r11b
 106ce96:	jne    106cef3 <check_input_run+0x1e3>
 106ce98:	blsr   %r9d,%r9d
 106ce9d:	je     106cef3 <check_input_run+0x1e3>
 106ce9f:	xor    %r11d,%r11d
 106cea2:	tzcnt  %r9d,%r11d
 106cea7:	mov    (%r8,%r11,4),%ebx
 106ceab:	cmpl   $0x11,0x4(%r10,%rbx,8)
 106ceb1:	jne    106ce90 <check_input_run+0x180>
 106ceb3:	mov    0x40(%rdx),%r11
 106ceb7:	mov    (%r10,%rbx,8),%r14d
 106cebb:	vpxor  (%r11,%r14,1),%xmm1,%xmm5
 106cec1:	movzbl 0x10(%r11,%r14,1),%ebp
 106cec7:	vmovd  %ebp,%xmm4
 106cecb:	vpternlogq $0xf6,%xmm2,%xmm4,%xmm5
 106ced2:	vptest %xmm5,%xmm5
 106ced7:	sete   %r11b
 106cedb:	cmove  %ebx,%eax
 106cede:	test   %r11b,%r11b
 106cee1:	je     106ce98 <check_input_run+0x188>
 106cee3:	jmp    106cef3 <check_input_run+0x1e3>
 106cee5:	data16 cs nopw 0x0(%rax,%rax,1)
 106cef0:	xor    %r11d,%r11d
 106cef3:	vptestnmd %zmm3,%zmm3,%k0
 106cef9:	kmovd  %k0,%r8d
 106cefd:	test   $0x8888,%r8d
 106cf04:	jne    106cf15 <check_input_run+0x205>
 106cf06:	inc    %rcx
 106cf09:	and    %rsi,%rcx
 106cf0c:	test   %r11b,%r11b
 106cf0f:	je     106ce50 <check_input_run+0x140>
 106cf15:	vmovdqa64 -0xbcfb9f(%rip),%zmm1        # 49d380 <cbuiltin_test_generated.edges+0x3540>
 106cf1f:	vpxor  %xmm0,%xmm0,%xmm0
 106cf23:	vmovdqa -0xaddcfb(%rip),%xmm2        # 58f230 <abi_test_hex.digits+0xa60>
 106cf2b:	xor    %ecx,%ecx
 106cf2d:	vaesenc %zmm0,%zmm1,%zmm1
 106cf33:	vaesenc %zmm0,%zmm1,%zmm0
 106cf39:	vextracti64x4 $0x1,%zmm0,%ymm1
 106cf40:	vpxorq %zmm0,%zmm1,%zmm0
 106cf46:	vextracti128 $0x1,%ymm0,%xmm1
 106cf4c:	vpxor  %xmm0,%xmm1,%xmm0
 106cf50:	vpxor  %xmm1,%xmm1,%xmm1
 106cf54:	vaesenc %xmm1,%xmm0,%xmm0
 106cf59:	vmovdqa -0xaddd41(%rip),%xmm1        # 58f220 <abi_test_hex.digits+0xa50>
 106cf61:	vmovq  %xmm0,%r8
 106cf66:	vbroadcasti32x4 -0xaddd50(%rip),%zmm0        # 58f220 <abi_test_hex.digits+0xa50>
 106cf70:	and    %rsi,%r8
 106cf73:	mov    %r8,%r9
 106cf76:	shl    $0x6,%r9
 106cf7a:	vmovdqa64 (%rdi,%r9,1),%zmm3
 106cf81:	vpcmpeqd %zmm0,%zmm3,%k0
 106cf87:	kmovd  %k0,%r10d
 106cf8b:	and    $0x7777,%r10d
 106cf92:	add    $0x1111,%r10d
 106cf99:	and    $0x8888,%r10w
 106cf9f:	je     106d000 <check_input_run+0x2f0>
 106cfa1:	mov    0x10(%rdx),%r11
 106cfa5:	add    %rdi,%r9
 106cfa8:	movzwl %r10w,%r10d
 106cfac:	jmp    106cfbd <check_input_run+0x2ad>
 106cfae:	xchg   %ax,%ax
 106cfb0:	xor    %ebx,%ebx
 106cfb2:	test   %bl,%bl
 106cfb4:	jne    106d002 <check_input_run+0x2f2>
 106cfb6:	blsr   %r10d,%r10d
 106cfbb:	je     106d002 <check_input_run+0x2f2>
 106cfbd:	xor    %ebx,%ebx
 106cfbf:	tzcnt  %r10d,%ebx
 106cfc4:	mov    (%r9,%rbx,4),%r14d
 106cfc8:	cmpl   $0x15,0x4(%r11,%r14,8)
 106cfce:	jne    106cfb0 <check_input_run+0x2a0>
 106cfd0:	mov    0x40(%rdx),%rbx
 106cfd4:	mov    (%r11,%r14,8),%r15d
 106cfd8:	vpxor  (%rbx,%r15,1),%xmm1,%xmm4
 106cfde:	vpternlogq $0xf6,0x5(%rbx,%r15,1),%xmm2,%xmm4
 106cfea:	vptest %xmm4,%xmm4
 106cfef:	sete   %bl
 106cff2:	cmove  %r14d,%ecx
 106cff6:	test   %bl,%bl
 106cff8:	je     106cfb6 <check_input_run+0x2a6>
 106cffa:	jmp    106d002 <check_input_run+0x2f2>
 106cffc:	nopl   0x0(%rax)
 106d000:	xor    %ebx,%ebx
 106d002:	vptestnmd %zmm3,%zmm3,%k0
 106d008:	kmovd  %k0,%r9d
 106d00c:	test   $0x8888,%r9d
 106d013:	jne    106d020 <check_input_run+0x310>
 106d015:	inc    %r8
 106d018:	test   %bl,%bl
 106d01a:	je     106cf70 <check_input_run+0x260>
 106d020:	mov    0xf0(%rsp),%rsi
 106d028:	mov    %r12,0x20(%rsp)
 106d02d:	test   %esi,%esi
 106d02f:	je     106d05e <check_input_run+0x34e>
 106d031:	mov    0x18(%rsp),%rdx
 106d036:	mov    0x10(%r12),%r10
 106d03b:	xor    %r11d,%r11d
 106d03e:	mov    0x334(%rdx),%ebp
 106d044:	mov    0x344(%rdx),%r8d
 106d04b:	cmp    $0x1,%esi
 106d04e:	jne    106d08c <check_input_run+0x37c>
 106d050:	xor    %esi,%esi
 106d052:	xor    %edx,%edx
 106d054:	xor    %r14d,%r14d
 106d057:	xor    %ebx,%ebx
 106d059:	jmp    106d259 <check_input_run+0x549>
 106d05e:	mov    0x18(%rsp),%r15
 106d063:	xor    %r14d,%r14d
 106d066:	xor    %r13d,%r13d
 106d069:	movq   $0x0,0xe8(%rsp)
 106d075:	movl   $0x0,0x130(%rsp)
 106d080:	mov    0x334(%r15),%ebp
 106d087:	jmp    106d306 <check_input_run+0x5f6>
 106d08c:	mov    0x78(%rsp),%rdx
 106d091:	and    $0xfffffffe,%edx
 106d094:	xor    %esi,%esi
 106d096:	xor    %r14d,%r14d
 106d099:	xor    %ebx,%ebx
 106d09b:	mov    %rdx,0x90(%rsp)
 106d0a3:	xor    %edx,%edx
 106d0a5:	jmp    106d12a <check_input_run+0x41a>
 106d0aa:	nopw   0x0(%rax,%rax,1)
 106d0b0:	movzbl 0x28(%rsp),%ebx
 106d0b5:	mov    0x130(%rsp),%r14d
 106d0bd:	or     0x98(%rsp),%r13b
 106d0c5:	mov    %r9b,%dil
 106d0c8:	mov    %bl,%r11b
 106d0cb:	mov    %edx,%ebx
 106d0cd:	mov    0xe8(%rsp),%rdx
 106d0d5:	add    %r15d,%r14d
 106d0d8:	and    %r13b,%r12b
 106d0db:	add    %r10d,%r14d
 106d0de:	add    %r11d,%ebx
 106d0e1:	mov    %edx,%r10d
 106d0e4:	mov    %edi,%edx
 106d0e6:	add    %ebx,%edx
 106d0e8:	or     %r12b,%r10b
 106d0eb:	mov    0x20(%rsp),%r12
 106d0f0:	mov    0x18(%r12),%rdi
 106d0f5:	mov    0x4(%rdi,%rsi,4),%edi
 106d0f9:	test   %edi,%edi
 106d0fb:	setne  %r9b
 106d0ff:	cmp    %eax,%edi
 106d101:	sete   %r11b
 106d105:	cmp    %ecx,%edi
 106d107:	sete   %bl
 106d10a:	add    $0x2,%rsi
 106d10e:	or     %r11b,%bl
 106d111:	and    %r9b,%bl
 106d114:	or     %r10b,%bl
 106d117:	mov    0x50(%rsp),%r10
 106d11c:	cmp    %rsi,0x90(%rsp)
 106d124:	je     106d248 <check_input_run+0x538>
 106d12a:	mov    %ebp,%edi
 106d12c:	xor    %ebp,%ebp
 106d12e:	cmpb   $0x6,(%r10,%rsi,1)
 106d133:	mov    0x18(%rsp),%r10
 106d138:	mov    %r8d,%r9d
 106d13b:	mov    $0x0,%r15d
 106d141:	mov    %r14d,0x130(%rsp)
 106d149:	mov    %rbx,0xe8(%rsp)
 106d151:	sete   %bpl
 106d155:	xor    %r8d,%r8d
 106d158:	add    %edi,%ebp
 106d15a:	mov    %ebp,0x334(%r10)
 106d161:	mov    0x10(%r12),%rdi
 106d166:	cmpb   $0x3d,(%rdi,%rsi,1)
 106d16a:	sete   %r8b
 106d16e:	xor    %r11d,%r11d
 106d171:	add    %r9d,%r8d
 106d174:	mov    %r8d,0x344(%r10)
 106d17b:	mov    0x10(%r12),%rdi
 106d180:	mov    0x50(%r12),%r10
 106d185:	movzbl (%rdi,%rsi,1),%r9d
 106d18a:	cmp    $0x40,%r9b
 106d18e:	sete   0x28(%rsp)
 106d193:	test   %r10,%r10
 106d196:	je     106d1aa <check_input_run+0x49a>
 106d198:	cmpb   $0xb,(%r10,%rsi,1)
 106d19d:	jne    106d1aa <check_input_run+0x49a>
 106d19f:	xor    %r15d,%r15d
 106d1a2:	cmp    $0xc,%r9b
 106d1a6:	sete   %r15b
 106d1aa:	mov    0x18(%r12),%r9
 106d1af:	mov    %r12,%rbx
 106d1b2:	mov    0x18(%rsp),%r10
 106d1b7:	mov    (%r9,%rsi,4),%r9d
 106d1bb:	test   %r9d,%r9d
 106d1be:	setne  %r12b
 106d1c2:	cmp    %eax,%r9d
 106d1c5:	sete   %r13b
 106d1c9:	cmp    %ecx,%r9d
 106d1cc:	sete   0x98(%rsp)
 106d1d4:	xor    %r9d,%r9d
 106d1d7:	cmpb   $0x6,0x1(%rdi,%rsi,1)
 106d1dc:	sete   %r9b
 106d1e0:	add    %r9d,%ebp
 106d1e3:	xor    %r9d,%r9d
 106d1e6:	mov    %ebp,0x334(%r10)
 106d1ed:	mov    0x10(%rbx),%rdi
 106d1f1:	cmpb   $0x3d,0x1(%rdi,%rsi,1)
 106d1f6:	sete   %r9b
 106d1fa:	add    %r9d,%r8d
 106d1fd:	mov    %r8d,0x344(%r10)
 106d204:	mov    0x10(%rbx),%rdi
 106d208:	mov    0x50(%rbx),%rbx
 106d20c:	movzbl 0x1(%rdi,%rsi,1),%r14d
 106d212:	mov    %rdi,0x50(%rsp)
 106d217:	xor    %edi,%edi
 106d219:	cmp    $0x40,%r14b
 106d21d:	sete   %r9b
 106d221:	xor    %r10d,%r10d
 106d224:	test   %rbx,%rbx
 106d227:	je     106d0b0 <check_input_run+0x3a0>
 106d22d:	cmpb   $0xb,0x1(%rbx,%rsi,1)
 106d232:	jne    106d0b0 <check_input_run+0x3a0>
 106d238:	xor    %r10d,%r10d
 106d23b:	cmp    $0xc,%r14b
 106d23f:	sete   %r10b
 106d243:	jmp    106d0b0 <check_input_run+0x3a0>
 106d248:	testb  $0x1,0x78(%rsp)
 106d24d:	mov    $0x0,%r11d
 106d253:	je     106d2e5 <check_input_run+0x5d5>
 106d259:	mov    %ebp,%edi
 106d25b:	xor    %ebp,%ebp
 106d25d:	cmpb   $0x6,(%r10,%rsi,1)
 106d262:	mov    0x18(%rsp),%r10
 106d267:	sete   %bpl
 106d26b:	xor    %r9d,%r9d
 106d26e:	add    %edi,%ebp
 106d270:	mov    %ebp,0x334(%r10)
 106d277:	mov    0x10(%r12),%rdi
 106d27c:	cmpb   $0x3d,(%rdi,%rsi,1)
 106d280:	sete   %r9b
 106d284:	add    %r8d,%r9d
 106d287:	mov    %r9d,0x344(%r10)
 106d28e:	mov    0x10(%r12),%rdi
 106d293:	mov    0x50(%r12),%r9
 106d298:	movzbl (%rdi,%rsi,1),%r8d
 106d29d:	xor    %edi,%edi
 106d29f:	cmp    $0x40,%r8b
 106d2a3:	sete   %dil
 106d2a7:	test   %r9,%r9
 106d2aa:	je     106d2be <check_input_run+0x5ae>
 106d2ac:	cmpb   $0xb,(%r9,%rsi,1)
 106d2b1:	jne    106d2be <check_input_run+0x5ae>
 106d2b3:	xor    %r11d,%r11d
 106d2b6:	cmp    $0xc,%r8b
 106d2ba:	sete   %r11b
 106d2be:	add    %edi,%edx
 106d2c0:	mov    0x18(%r12),%rdi
 106d2c5:	add    %r14d,%r11d
 106d2c8:	mov    %r11d,%r14d
 106d2cb:	mov    (%rdi,%rsi,4),%esi
 106d2ce:	test   %esi,%esi
 106d2d0:	setne  %dil
 106d2d4:	cmp    %eax,%esi
 106d2d6:	sete   %al
 106d2d9:	cmp    %ecx,%esi
 106d2db:	sete   %cl
 106d2de:	or     %al,%cl
 106d2e0:	and    %dil,%cl
 106d2e3:	or     %cl,%bl
 106d2e5:	mov    0x18(%rsp),%r15
 106d2ea:	mov    0x78(%rsp),%r13
 106d2ef:	mov    %r14d,0x130(%rsp)
 106d2f7:	mov    %edx,%r14d
 106d2fa:	shl    $0x2,%r14
 106d2fe:	mov    %rbx,0xe8(%rsp)
 106d306:	mov    0x38(%rsp),%rbx
 106d30b:	lea    0x2d0(%rsp),%rdi
 106d313:	mov    $0x430,%edx
 106d318:	xor    %esi,%esi
 106d31a:	mov    0x8(%rbx),%rax
 106d31e:	mov    %rax,0x270(%rsp)
 106d326:	vzeroupper
 106d329:	call   788120 <memset@plt>
 106d32e:	mov    0x58(%rsp),%rax
 106d333:	mov    0xa8(%rsp),%rcx
 106d33b:	vpbroadcastb -0xbcfd82(%rip),%xmm1        # 49d5c2 <cbuiltin_test_generated.edges+0x3782>
 106d344:	mov    %r15,0x2a0(%rsp)
 106d34c:	mov    %r12,0x2a8(%rsp)
 106d354:	mov    0x848(%rsp),%edi
 106d35b:	mov    0x860(%rsp),%rdx
 106d363:	vpcmpeqd %xmm0,%xmm0,%xmm0
 106d367:	add    %r13,%r14
 106d36a:	mov    %r13,0x78(%rsp)
 106d36f:	mov    %rax,0x2b0(%rsp)
 106d377:	mov    0xf0(%rsp),%rax
 106d37f:	mov    %rcx,0x2b8(%rsp)
 106d387:	mov    0x10(%rsp),%rcx
 106d38c:	lea    0x1(%rax),%esi
 106d38f:	mov    %rcx,0x2c0(%rsp)
 106d397:	mov    %rbx,0x2c8(%rsp)
 106d39f:	movl   $0xffffffff,0x360(%rsp)
 106d3aa:	vmovdqu %xmm0,0x378(%rsp)
 106d3b3:	vmovdqu %xmm0,0x384(%rsp)
 106d3bc:	vpinsrd $0x1,%esi,%xmm1,%xmm1
 106d3c2:	mov    %rsi,0xd8(%rsp)
 106d3ca:	vmovdqu %xmm1,0x65c(%rsp)
 106d3d3:	mov    %eax,0x670(%rsp)
 106d3da:	mov    %edi,0x674(%rsp)
 106d3e1:	mov    %rdx,0x6e8(%rsp)
 106d3e9:	mov    %ebp,%eax
 106d3eb:	lea    (%r14,%rax,8),%rdx
 106d3ef:	lea    0x1(%r14,%rax,8),%rax
 106d3f4:	vmovdqu %xmm0,0x6d0(%rsp)
 106d3fd:	movl   $0xffffffff,0x6e0(%rsp)
 106d408:	mov    %rdx,0x88(%rsp)
 106d410:	mov    %rax,0x100(%rsp)
 106d418:	cmp    %rbx,%rcx
 106d41b:	je     106d4fd <check_input_run+0x7ed>
 106d421:	cmpl   $0x0,0xa0(%r12)
 106d42a:	jne    106d4fd <check_input_run+0x7ed>
 106d430:	cmpl   $0x0,0xa4(%r12)
 106d439:	jne    106d4fd <check_input_run+0x7ed>
 106d43f:	mov    0xf0(%rsp),%rdx
 106d447:	mov    0x18(%rsp),%r15
 106d44c:	test   %edx,%edx
 106d44e:	sete   %al
 106d451:	cmpq   $0x0,0x68(%r12)
 106d457:	setne  %cl
 106d45a:	or     %al,%cl
 106d45c:	cmp    $0x3fffffff,%edx
 106d462:	setb   %al
 106d465:	and    %cl,%al
 106d467:	mov    $0xffffffff,%ecx
 106d46c:	cmp    %rcx,0x88(%rsp)
 106d474:	setb   %cl
 106d477:	cmp    %edx,%edi
 106d479:	setbe  %dl
 106d47c:	and    %al,%dl
 106d47e:	and    %cl,%dl
 106d480:	cmp    $0x1,%dl
 106d483:	jne    106d4fd <check_input_run+0x7ed>
 106d485:	lea    0xbd2b54(%rip),%r14        # 1c3ffe0 <type_builtins+0x200>
 106d48c:	xor    %r12d,%r12d
 106d48f:	nop
 106d490:	mov    0x58(%rsp),%rax
 106d495:	mov    (%r14),%r15
 106d498:	mov    0x270(%rax),%rbx
 106d49f:	mov    %r15,%rdi
 106d4a2:	call   787bf0 <strlen@plt>
 106d4a7:	mov    %rbx,%rdi
 106d4aa:	mov    %r15,%rsi
 106d4ad:	mov    %eax,%edx
 106d4af:	call   101b400 <intern_find_or_add>
 106d4b4:	mov    %eax,0x6a4(%rsp,%r12,4)
 106d4bc:	test   %eax,%eax
 106d4be:	je     106d4cf <check_input_run+0x7bf>
 106d4c0:	add    $0x8,%r14
 106d4c4:	cmp    $0x9,%r12
 106d4c8:	lea    0x1(%r12),%r12
 106d4cd:	jb     106d490 <check_input_run+0x780>
 106d4cf:	mov    0x18(%rsp),%r15
 106d4d4:	mov    0x20(%rsp),%r12
 106d4d9:	mov    0xd8(%rsp),%rsi
 106d4e1:	test   %eax,%eax
 106d4e3:	je     106d4fd <check_input_run+0x7ed>
 106d4e5:	mov    0x58(%rsp),%rax
 106d4ea:	mov    0x270(%rax),%rax
 106d4f1:	mov    %rax,0x50(%rsp)
 106d4f6:	xor    %eax,%eax
 106d4f8:	jmp    106d8f2 <check_input_run+0xbe2>
 106d4fd:	mov    %r15,%rdi
 106d500:	mov    %esi,0x234(%r15)
 106d507:	lea    0x228(%rdi),%r9
 106d50e:	movq   $0x0,0x228(%rdi)
 106d519:	mov    0x10(%rsp),%rsi
 106d51e:	lea    0x238(%rdi),%rax
 106d525:	movq   $0x0,0x238(%rdi)
 106d530:	movq   $0x0,0x240(%rdi)
 106d53b:	movq   $0x0,0x248(%rdi)
 106d546:	movq   $0x0,0x260(%rdi)
 106d551:	mov    %rax,0x68(%rsp)
 106d556:	lea    0x268(%rdi),%rax
 106d55d:	movq   $0x0,0x268(%rdi)
 106d568:	lea    0x250(%rdi),%rcx
 106d56f:	movq   $0x0,0x250(%rdi)
 106d57a:	mov    %rcx,0xa0(%rsp)
 106d582:	lea    0x258(%rdi),%rcx
 106d589:	movq   $0x0,0x258(%rdi)
 106d594:	movq   $0x0,0x270(%rdi)
 106d59f:	mov    %rcx,0x110(%rsp)
 106d5a7:	lea    0x278(%rdi),%rcx
 106d5ae:	movq   $0x0,0x278(%rdi)
 106d5b9:	mov    %rcx,0x60(%rsp)
 106d5be:	lea    0x280(%rdi),%rcx
 106d5c5:	movq   $0x0,0x280(%rdi)
 106d5d0:	mov    %rcx,0xc0(%rsp)
 106d5d8:	lea    0x288(%rdi),%rcx
 106d5df:	movq   $0x0,0x288(%rdi)
 106d5ea:	movq   $0x0,0x290(%rdi)
 106d5f5:	movq   $0x0,0x298(%rdi)
 106d600:	mov    %rcx,0x48(%rsp)
 106d605:	lea    0x2a0(%rdi),%rcx
 106d60c:	movq   $0x0,0x2a0(%rdi)
 106d617:	mov    %rcx,0x118(%rsp)
 106d61f:	lea    0x2a8(%rdi),%rcx
 106d626:	movq   $0x0,0x2a8(%rdi)
 106d631:	mov    %rcx,0x150(%rsp)
 106d639:	lea    0x2b0(%rdi),%rcx
 106d640:	movq   $0x0,0x2b0(%rdi)
 106d64b:	mov    %rcx,0x260(%rsp)
 106d653:	lea    0x2b8(%rdi),%rcx
 106d65a:	movq   $0x0,0x2b8(%rdi)
 106d665:	mov    %rcx,0x258(%rsp)
 106d66d:	lea    0x2c0(%rdi),%rcx
 106d674:	movq   $0x0,0x2c0(%rdi)
 106d67f:	movq   $0x0,0x2c8(%rdi)
 106d68a:	movq   $0x0,0x2d0(%rdi)
 106d695:	mov    %rcx,0x148(%rsp)
 106d69d:	lea    0x2d8(%rdi),%rcx
 106d6a4:	movq   $0x0,0x2d8(%rdi)
 106d6af:	movq   $0x0,0x2e0(%rdi)
 106d6ba:	lea    0x2e0(%rdi),%rdx
 106d6c1:	movq   $0x0,0x2e8(%rdi)
 106d6cc:	lea    0x2f0(%rdi),%r8
 106d6d3:	movq   $0x0,0x2f0(%rdi)
 106d6de:	lea    0x2f8(%rdi),%r10
 106d6e5:	movq   $0x0,0x2f8(%rdi)
 106d6f0:	lea    0x300(%rdi),%r11
 106d6f7:	movq   $0x0,0x300(%rdi)
 106d702:	movq   $0x0,0x308(%rdi)
 106d70d:	lea    0x308(%rdi),%rbx
 106d714:	movq   $0x0,0x310(%rdi)
 106d71f:	mov    %rcx,0x80(%rsp)
 106d727:	lea    0x318(%rdi),%rcx
 106d72e:	mov    %rbx,0x108(%rsp)
 106d736:	mov    %r11,0xe0(%rsp)
 106d73e:	mov    %r10,0xb8(%rsp)
 106d746:	mov    %r8,0xf8(%rsp)
 106d74e:	mov    %rdx,0xb0(%rsp)
 106d756:	mov    %rax,0x40(%rsp)
 106d75b:	movq   $0x0,0x318(%rdi)
 106d766:	mov    %rcx,0x128(%rsp)
 106d76e:	lea    0x348(%rdi),%rax
 106d775:	movq   $0x0,0x348(%rdi)
 106d780:	xor    %ebx,%ebx
 106d782:	xor    %r15d,%r15d
 106d785:	mov    %rax,0x120(%rsp)
 106d78d:	mov    $0x350,%eax
 106d792:	mov    %r9,0x30(%rsp)
 106d797:	mov    %rbx,(%rdi,%rax,1)
 106d79b:	mov    0x240(%rdi),%rax
 106d7a2:	mov    0x100(%rsp),%rdx
 106d7aa:	mov    0xd8(%rsp),%rcx
 106d7b2:	mov    %rdi,%rbx
 106d7b5:	mov    %rax,0x340(%rsp)
 106d7bd:	mov    0x248(%rdi),%rax
 106d7c4:	mov    %rax,0x3a0(%rsp)
 106d7cc:	mov    0x260(%rdi),%rax
 106d7d3:	mov    %rax,0x3d0(%rsp)
 106d7db:	mov    0x268(%rdi),%rax
 106d7e2:	mov    %rax,0x3b8(%rsp)
 106d7ea:	mov    0x270(%rdi),%rax
 106d7f1:	mov    %rax,0x3c0(%rsp)
 106d7f9:	mov    0x290(%rdi),%rax
 106d800:	mov    %rax,0x3c8(%rsp)
 106d808:	mov    0x298(%rdi),%rax
 106d80f:	mov    %rax,0x3a8(%rsp)
 106d817:	mov    0x2e8(%rdi),%rax
 106d81e:	mov    %rax,0x580(%rsp)
 106d826:	mov    0x2f0(%rdi),%rax
 106d82d:	mov    %rax,0x588(%rsp)
 106d835:	vzeroupper
 106d838:	call   1080800 <check_graph_initialize>
 106d83d:	movzbl 0x8(%r12),%ecx
 106d843:	or     $0x2,%ecx
 106d846:	mov    %ecx,0x88(%rbx)
 106d84c:	test   %r15b,%r15b
 106d84f:	je     106db63 <check_input_run+0xe53>
 106d855:	test   %al,%al
 106d857:	je     106db63 <check_input_run+0xe53>
 106d85d:	mov    0x10(%rsp),%rcx
 106d862:	mov    0x8(%rcx),%rax
 106d866:	mov    0x10(%rcx),%rcx
 106d86a:	sub    %rax,%rcx
 106d86d:	jb     106db63 <check_input_run+0xe53>
 106d873:	cmp    %rcx,0x88(%rsp)
 106d87b:	jae    106db63 <check_input_run+0xe53>
 106d881:	mov    0x100(%rsp),%rcx
 106d889:	mov    0x10(%rsp),%rdi
 106d88e:	add    %rax,%rcx
 106d891:	mov    %rcx,0x8(%rdi)
 106d895:	mov    0x18(%rsp),%rcx
 106d89a:	add    (%rdi),%rax
 106d89d:	mov    %rax,0x50(%rcx)
 106d8a1:	mov    $0xb0,%ecx
 106d8a6:	je     106d8c4 <check_input_run+0xbb4>
 106d8a8:	mov    (%rdi),%rax
 106d8ab:	mov    0x8(%rdi),%rsi
 106d8af:	lea    0x3f(%rsi,%rax,1),%rdx
 106d8b4:	add    %rax,%rsi
 106d8b7:	and    $0xffffffffffffffc0,%rdx
 106d8bb:	cmp    %rsi,%rdx
 106d8be:	jae    106e1af <check_input_run+0x149f>
 106d8c4:	mov    0x18(%rsp),%rdi
 106d8c9:	jmp    106db75 <check_input_run+0xe65>
 106d8ce:	xchg   %ax,%ax
 106d8d0:	mov    0xc8(%rsp),%rax
 106d8d8:	mov    0x20(%rsp),%r12
 106d8dd:	mov    %r14d,0x67c(%rsp,%rax,4)
 106d8e5:	inc    %rax
 106d8e8:	cmp    $0x5,%rax
 106d8ec:	je     1070dfa <check_input_run+0x40ea>
 106d8f2:	lea    0xbd2737(%rip),%rcx        # 1c40030 <parse_predeclared_typedefs>
 106d8f9:	mov    %rax,0xc8(%rsp)
 106d901:	mov    (%rcx,%rax,8),%rbx
 106d905:	mov    %rbx,%rdi
 106d908:	vzeroupper
 106d90b:	call   787bf0 <strlen@plt>
 106d910:	kxnorq %k0,%k0,%k1
 106d915:	mov    %rax,%rdx
 106d918:	mov    %edx,%r14d
 106d91b:	cmp    $0x3f,%edx
 106d91e:	ja     106d931 <check_input_run+0xc21>
 106d920:	mov    $0xffffffffffffffff,%rax
 106d927:	bzhi   %r14,%rax,%rax
 106d92c:	kmovq  %rax,%k1
 106d931:	vmovdqu8 (%rbx),%zmm0{%k1}{z}
 106d937:	vmovd  %r14d,%xmm1
 106d93c:	vpxor  %xmm2,%xmm2,%xmm2
 106d940:	mov    %rdx,0x28(%rsp)
 106d945:	vpternlogq $0x96,-0xbd0550(%rip),%zmm0,%zmm1        # 49d400 <cbuiltin_test_generated.edges+0x35c0>
 106d950:	vaesenc %zmm2,%zmm1,%zmm0
 106d956:	vaesenc %zmm2,%zmm0,%zmm0
 106d95c:	vextracti64x4 $0x1,%zmm0,%ymm1
 106d963:	vpxorq %zmm0,%zmm1,%zmm0
 106d969:	vextracti128 $0x1,%ymm0,%xmm1
 106d96f:	vpxor  %xmm0,%xmm1,%xmm0
 106d973:	cmp    $0x41,%edx
 106d976:	jb     106d98b <check_input_run+0xc7b>
 106d978:	mov    %rbx,%rdi
 106d97b:	mov    %r14,%rsi
 106d97e:	vzeroupper
 106d981:	call   101bc00 <intern_chain_chunks>
 106d986:	mov    0x28(%rsp),%rdx
 106d98b:	vpxor  %xmm1,%xmm1,%xmm1
 106d98f:	vaesenc %xmm1,%xmm0,%xmm0
 106d994:	cmp    $0x10,%edx
 106d997:	mov    $0x10,%eax
 106d99c:	mov    $0xffff,%ecx
 106d9a1:	cmovb  %edx,%eax
 106d9a4:	bzhi   %eax,%ecx,%eax
 106d9a9:	kmovd  %eax,%k1
 106d9ad:	mov    0x50(%rsp),%rax
 106d9b2:	vmovq  %xmm0,%r12
 106d9b7:	vmovdqu8 (%rbx),%xmm0{%k1}{z}
 106d9bd:	mov    0x8(%rax),%rdi
 106d9c1:	mov    (%rax),%rsi
 106d9c4:	vshufi64x2 $0x0,%zmm0,%zmm0,%zmm0
 106d9cb:	and    %rdi,%r12
 106d9ce:	vmovdqu64 %zmm0,0x210(%rsp)
 106d9d9:	cmp    $0xc,%edx
 106d9dc:	jae    106da50 <check_input_run+0xd40>
 106d9de:	xor    %r14d,%r14d
 106d9e1:	jmp    106da0f <check_input_run+0xcff>
 106d9e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 106d9f0:	vptestnmd %zmm0,%zmm0,%k0
 106d9f6:	inc    %r12
 106d9f9:	kmovd  %k0,%ecx
 106d9fd:	and    %rdi,%r12
 106da00:	and    $0x8888,%ecx
 106da06:	or     %cx,%ax
 106da09:	jne    106d8d0 <check_input_run+0xbc0>
 106da0f:	mov    %r12,%rcx
 106da12:	shl    $0x6,%rcx
 106da16:	vmovdqa64 (%rsi,%rcx,1),%zmm0
 106da1d:	vpcmpeqd 0x210(%rsp),%zmm0,%k0
 106da28:	kmovd  %k0,%eax
 106da2c:	and    $0x7777,%eax
 106da31:	add    $0x1111,%eax
 106da36:	and    $0x8888,%ax
 106da3a:	je     106d9f0 <check_input_run+0xce0>
 106da3c:	add    %rsi,%rcx
 106da3f:	xor    %edx,%edx
 106da41:	tzcnt  %eax,%edx
 106da45:	mov    (%rcx,%rdx,4),%r14d
 106da49:	jmp    106d9f0 <check_input_run+0xce0>
 106da4b:	nopl   0x0(%rax,%rax,1)
 106da50:	mov    %r14,0x90(%rsp)
 106da58:	xor    %r14d,%r14d
 106da5b:	mov    %rbx,0x98(%rsp)
 106da63:	mov    %rsi,0xd0(%rsp)
 106da6b:	mov    %rdi,0x70(%rsp)
 106da70:	mov    %r12,%r13
 106da73:	shl    $0x6,%r13
 106da77:	vmovdqa64 (%rsi,%r13,1),%zmm0
 106da7e:	vpcmpeqd 0x210(%rsp),%zmm0,%k0
 106da89:	vmovdqu64 %zmm0,0x1b0(%rsp)
 106da94:	kmovd  %k0,%eax
 106da98:	and    $0x7777,%eax
 106da9d:	add    $0x1111,%eax
 106daa2:	and    $0x8888,%ax
 106daa6:	je     106db20 <check_input_run+0xe10>
 106daa8:	mov    0x50(%rsp),%rcx
 106daad:	add    %rsi,%r13
 106dab0:	movzwl %ax,%ebx
 106dab3:	mov    0x10(%rcx),%rbp
 106dab7:	jmp    106dacd <check_input_run+0xdbd>
 106dab9:	nopl   0x0(%rax)
 106dac0:	xor    %eax,%eax
 106dac2:	test   %al,%al
 106dac4:	jne    106db22 <check_input_run+0xe12>
 106dac6:	blsr   %ebx,%ebx
 106dacb:	je     106db22 <check_input_run+0xe12>
 106dacd:	xor    %eax,%eax
 106dacf:	tzcnt  %ebx,%eax
 106dad3:	mov    0x0(%r13,%rax,4),%r15d
 106dad8:	cmp    %edx,0x4(%rbp,%r15,8)
 106dadd:	jne    106dac0 <check_input_run+0xdb0>
 106dadf:	mov    0x50(%rsp),%rax
 106dae4:	mov    0x0(%rbp,%r15,8),%edi
 106dae9:	mov    0x98(%rsp),%rsi
 106daf1:	mov    0x90(%rsp),%rdx
 106daf9:	add    0x40(%rax),%rdi
 106dafd:	vzeroupper
 106db00:	call   7880b0 <bcmp@plt>
 106db05:	mov    0x28(%rsp),%rdx
 106db0a:	test   %eax,%eax
 106db0c:	sete   %al
 106db0f:	cmove  %r15d,%r14d
 106db13:	test   %al,%al
 106db15:	je     106dac6 <check_input_run+0xdb6>
 106db17:	jmp    106db22 <check_input_run+0xe12>
 106db19:	nopl   0x0(%rax)
 106db20:	xor    %eax,%eax
 106db22:	vmovdqu64 0x1b0(%rsp),%zmm0
 106db2d:	vptestnmd %zmm0,%zmm0,%k0
 106db33:	kmovd  %k0,%ecx
 106db37:	test   $0x8888,%ecx
 106db3d:	jne    106d8d0 <check_input_run+0xbc0>
 106db43:	mov    0x70(%rsp),%rdi
 106db48:	mov    0xd0(%rsp),%rsi
 106db50:	inc    %r12
 106db53:	and    %rdi,%r12
 106db56:	test   %al,%al
 106db58:	je     106da70 <check_input_run+0xd60>
 106db5e:	jmp    106d8d0 <check_input_run+0xbc0>
 106db63:	mov    0x18(%rsp),%rdi
 106db68:	mov    $0xb0,%ecx
 106db6d:	movq   $0x0,0x50(%rdi)
 106db75:	movq   $0x0,(%rdi,%rcx,1)
 106db7d:	movq   $0x0,0x348(%rsp)
 106db89:	movq   $0x0,0x350(%rsp)
 106db95:	movq   $0x0,0x358(%rsp)
 106dba1:	movq   $0x0,0x370(%rsp)
 106dbad:	movq   $0x0,0x398(%rsp)
 106dbb9:	movq   $0x0,0x3b0(%rsp)
 106dbc5:	movq   $0x0,0x3d8(%rsp)
 106dbd1:	movq   $0x0,0x3e0(%rsp)
 106dbdd:	movq   $0x0,0x3e8(%rsp)
 106dbe9:	movq   $0x0,0x3f0(%rsp)
 106dbf5:	movq   $0x0,0x3f8(%rsp)
 106dc01:	movq   $0x0,0x400(%rsp)
 106dc0d:	movq   $0x0,0x408(%rsp)
 106dc19:	movq   $0x0,0x418(%rsp)
 106dc25:	movq   $0x0,0x420(%rsp)
 106dc31:	movq   $0x0,0x428(%rsp)
 106dc3d:	movq   $0x0,0x430(%rsp)
 106dc49:	movq   $0x0,0x438(%rsp)
 106dc55:	movq   $0x0,0x440(%rsp)
 106dc61:	movq   $0x0,0x448(%rsp)
 106dc6d:	movq   $0x0,0x450(%rsp)
 106dc79:	movq   $0x0,0x460(%rsp)
 106dc85:	movq   $0x0,0x4a8(%rsp)
 106dc91:	movq   $0x0,0x4b0(%rsp)
 106dc9d:	movq   $0x0,0x4d0(%rsp)
 106dca9:	movq   $0x0,0x4d8(%rsp)
 106dcb5:	movq   $0x0,0x4e8(%rsp)
 106dcc1:	movq   $0x0,0x4f0(%rsp)
 106dccd:	movq   $0x0,0x4f8(%rsp)
 106dcd9:	movq   $0x0,0x508(%rsp)
 106dce5:	movq   $0x0,0x510(%rsp)
 106dcf1:	movq   $0x0,0x520(%rsp)
 106dcfd:	movq   $0x0,0x528(%rsp)
 106dd09:	movq   $0x0,0x530(%rsp)
 106dd15:	movq   $0x0,0x538(%rsp)
 106dd21:	movq   $0x0,0x540(%rsp)
 106dd2d:	movq   $0x0,0x548(%rsp)
 106dd39:	movq   $0x0,0x550(%rsp)
 106dd45:	movq   $0x0,0x570(%rsp)
 106dd51:	movq   $0x0,0x578(%rsp)
 106dd5d:	movq   $0x0,0x598(%rsp)
 106dd69:	movq   $0x0,0x5a0(%rsp)
 106dd75:	movq   $0x0,0x5a8(%rsp)
 106dd81:	movq   $0x0,0x5b0(%rsp)
 106dd8d:	movq   $0x0,0x5d0(%rsp)
 106dd99:	movq   $0x0,0x5d8(%rsp)
 106dda5:	movq   $0x0,0x5e0(%rsp)
 106ddb1:	movq   $0x0,0x5e8(%rsp)
 106ddbd:	movq   $0x0,0x608(%rsp)
 106ddc9:	movq   $0x0,0x610(%rsp)
 106ddd5:	movq   $0x0,0x618(%rsp)
 106dde1:	movq   $0x0,0x620(%rsp)
 106dded:	movq   $0x0,0x628(%rsp)
 106ddf9:	movq   $0x0,0x638(%rsp)
 106de05:	movq   $0x0,0x640(%rsp)
 106de11:	movq   $0x0,0x648(%rsp)
 106de1d:	xor    %esi,%esi
 106de1f:	xor    %ecx,%ecx
 106de21:	test   %rcx,%rcx
 106de24:	mov    %rcx,0x630(%rsp)
 106de2c:	setne  %al
 106de2f:	and    %sil,%al
 106de32:	cmpl   $0x0,0xf0(%rsp)
 106de3a:	je     106de5a <check_input_run+0x114a>
 106de3c:	mov    0x18(%r12),%rcx
 106de41:	mov    0x78(%rsp),%r8
 106de46:	cmp    $0x8,%r8d
 106de4a:	jae    106de71 <check_input_run+0x1161>
 106de4c:	mov    0x58(%rsp),%r15
 106de51:	xor    %edx,%edx
 106de53:	xor    %esi,%esi
 106de55:	jmp    106e000 <check_input_run+0x12f0>
 106de5a:	mov    0x58(%rsp),%r15
 106de5f:	mov    $0x60,%ebx
 106de64:	test   %al,%al
 106de66:	jne    106e02a <check_input_run+0x131a>
 106de6c:	jmp    106f47c <check_input_run+0x276c>
 106de71:	cmp    $0x40,%r8d
 106de75:	jae    106de85 <check_input_run+0x1175>
 106de77:	mov    0x58(%rsp),%r15
 106de7c:	xor    %edx,%edx
 106de7e:	xor    %esi,%esi
 106de80:	jmp    106df8a <check_input_run+0x127a>
 106de85:	vpbroadcastd -0xac22bb(%rip),%zmm1        # 5abbd4 <link_program_emit_worker.forms+0x3c4>
 106de8f:	vpbroadcastd -0xac22c1(%rip),%zmm2        # 5abbd8 <link_program_emit_worker.forms+0x3c8>
 106de99:	mov    %r8d,%esi
 106de9c:	shr    $0x6,%esi
 106de9f:	mov    %r8d,%edx
 106dea2:	and    $0xffffffc0,%edx
 106dea5:	vpxor  %xmm0,%xmm0,%xmm0
 106dea9:	xor    %edi,%edi
 106deab:	vpxor  %xmm3,%xmm3,%xmm3
 106deaf:	vpxor  %xmm4,%xmm4,%xmm4
 106deb3:	vpxor  %xmm5,%xmm5,%xmm5
 106deb7:	shl    $0x8,%rsi
 106debb:	nopl   0x0(%rax,%rax,1)
 106dec0:	vpaddd (%rcx,%rdi,1),%zmm1,%zmm6
 106dec7:	vpaddd 0x40(%rcx,%rdi,1),%zmm1,%zmm7
 106decf:	vpaddd 0x80(%rcx,%rdi,1),%zmm1,%zmm8
 106ded7:	vpaddd 0xc0(%rcx,%rdi,1),%zmm1,%zmm9
 106dedf:	add    $0x100,%rdi
 106dee6:	vpcmpltud %zmm2,%zmm6,%k0
 106deed:	vpcmpltud %zmm2,%zmm7,%k1
 106def4:	vpcmpltud %zmm2,%zmm8,%k2
 106defb:	vpcmpltud %zmm2,%zmm9,%k3
 106df02:	vpmovm2d %k0,%zmm6
 106df08:	vpsubd %zmm6,%zmm0,%zmm0
 106df0e:	vpmovm2d %k1,%zmm6
 106df14:	vpsubd %zmm6,%zmm3,%zmm3
 106df1a:	vpmovm2d %k2,%zmm6
 106df20:	vpsubd %zmm6,%zmm4,%zmm4
 106df26:	vpmovm2d %k3,%zmm6
 106df2c:	vpsubd %zmm6,%zmm5,%zmm5
 106df32:	cmp    %rdi,%rsi
 106df35:	jne    106dec0 <check_input_run+0x11b0>
 106df37:	vpaddd %zmm0,%zmm3,%zmm0
 106df3d:	vpaddd %zmm4,%zmm5,%zmm1
 106df43:	mov    0x58(%rsp),%r15
 106df48:	vpaddd %zmm0,%zmm1,%zmm0
 106df4e:	vextracti64x4 $0x1,%zmm0,%ymm1
 106df55:	vpaddd %zmm1,%zmm0,%zmm0
 106df5b:	vextracti128 $0x1,%ymm0,%xmm1
 106df61:	vpaddd %xmm1,%xmm0,%xmm0
 106df65:	vpshufd $0xee,%xmm0,%xmm1
 106df6a:	vpaddd %xmm1,%xmm0,%xmm0
 106df6e:	vpshufd $0x55,%xmm0,%xmm1
 106df73:	vpaddd %xmm1,%xmm0,%xmm0
 106df77:	vmovd  %xmm0,%esi
 106df7b:	cmp    %edx,%r8d
 106df7e:	je     106e014 <check_input_run+0x1304>
 106df84:	test   $0x38,%r8b
 106df88:	je     106e000 <check_input_run+0x12f0>
 106df8a:	vpbroadcastd -0xac23bf(%rip),%ymm1        # 5abbd4 <link_program_emit_worker.forms+0x3c4>
 106df93:	vpbroadcastd -0xac23c4(%rip),%ymm2        # 5abbd8 <link_program_emit_worker.forms+0x3c8>
 106df9c:	mov    %rdx,%rdi
 106df9f:	mov    %r8d,%edx
 106dfa2:	and    $0xfffffff8,%edx
 106dfa5:	vmovd  %esi,%xmm0
 106dfa9:	nopl   0x0(%rax)
 106dfb0:	vpaddd (%rcx,%rdi,4),%ymm1,%ymm3
 106dfb5:	add    $0x8,%rdi
 106dfb9:	vpcmpltud %ymm2,%ymm3,%k0
 106dfc0:	vpmovm2d %k0,%ymm3
 106dfc6:	vpsubd %ymm3,%ymm0,%ymm0
 106dfca:	cmp    %rdi,%rdx
 106dfcd:	jne    106dfb0 <check_input_run+0x12a0>
 106dfcf:	vextracti128 $0x1,%ymm0,%xmm1
 106dfd5:	vpaddd %xmm1,%xmm0,%xmm0
 106dfd9:	vpshufd $0xee,%xmm0,%xmm1
 106dfde:	vpaddd %xmm1,%xmm0,%xmm0
 106dfe2:	vpshufd $0x55,%xmm0,%xmm1
 106dfe7:	vpaddd %xmm1,%xmm0,%xmm0
 106dfeb:	vmovd  %xmm0,%esi
 106dfef:	cmp    %edx,%r8d
 106dff2:	je     106e014 <check_input_run+0x1304>
 106dff4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 106e000:	mov    (%rcx,%rdx,4),%edi
 106e003:	add    $0xffffffb3,%edi
 106e006:	cmp    $0x2,%edi
 106e009:	adc    $0x0,%esi
 106e00c:	inc    %rdx
 106e00f:	cmp    %rdx,%r8
 106e012:	jne    106e000 <check_input_run+0x12f0>
 106e014:	mov    %esi,%ecx
 106e016:	lea    (%rcx,%rcx,2),%rbx
 106e01a:	shl    $0x5,%rbx
 106e01e:	add    $0x60,%rbx
 106e022:	test   %al,%al
 106e024:	je     106f47c <check_input_run+0x276c>
 106e02a:	mov    0x18(%rsp),%rcx
 106e02f:	mov    0x334(%rcx),%eax
 106e035:	test   %rax,%rax
 106e038:	je     106e141 <check_input_run+0x1431>
 106e03e:	mov    0x10(%rsp),%r9
 106e043:	mov    (%r9),%rdi
 106e046:	mov    0x8(%r9),%rdx
 106e04a:	lea    0x3(%rdx,%rdi,1),%rcx
 106e04f:	add    %rdi,%rdx
 106e052:	and    $0xfffffffffffffffc,%rcx
 106e056:	cmp    %rdx,%rcx
 106e059:	jb     106e084 <check_input_run+0x1374>
 106e05b:	mov    %rcx,%rsi
 106e05e:	sub    %rdi,%rsi
 106e061:	mov    0x10(%r9),%rdi
 106e065:	lea    0x0(,%rax,4),%rdx
 106e06d:	lea    (%rdx,%rdx,8),%rdx
 106e071:	sub    %rsi,%rdi
 106e074:	setb   %r8b
 106e078:	cmp    %rdi,%rdx
 106e07b:	seta   %dil
 106e07f:	or     %r8b,%dil
 106e082:	je     106e088 <check_input_run+0x1378>
 106e084:	xor    %ecx,%ecx
 106e086:	jmp    106e09a <check_input_run+0x138a>
 106e088:	mov    0x18(%rsp),%rax
 106e08d:	add    %rdx,%rsi
 106e090:	mov    %rsi,0x8(%r9)
 106e094:	mov    0x334(%rax),%eax
 106e09a:	mov    0x18(%rsp),%rdx
 106e09f:	mov    0x38(%rsp),%rsi
 106e0a4:	mov    %rcx,0x328(%rdx)
 106e0ab:	mov    (%rsi),%rdx
 106e0ae:	mov    0x8(%rsi),%rcx
 106e0b2:	lea    0x3(%rcx,%rdx,1),%rdi
 106e0b7:	add    %rdx,%rcx
 106e0ba:	and    $0xfffffffffffffffc,%rdi
 106e0be:	cmp    %rcx,%rdi
 106e0c1:	jae    106e0d4 <check_input_run+0x13c4>
 106e0c3:	movq   $0x0,0x500(%rsp)
 106e0cf:	jmp    106f47c <check_input_run+0x276c>
 106e0d4:	mov    %rdi,%rcx
 106e0d7:	sub    %rdx,%rcx
 106e0da:	mov    0x38(%rsp),%rdx
 106e0df:	mov    0x10(%rdx),%rdx
 106e0e3:	sub    %rcx,%rdx
 106e0e6:	jb     106e0c3 <check_input_run+0x13b3>
 106e0e8:	shl    $0x2,%rax
 106e0ec:	cmp    %rdx,%rax
 106e0ef:	ja     106e0c3 <check_input_run+0x13b3>
 106e0f1:	mov    0x38(%rsp),%rdx
 106e0f6:	add    %rax,%rcx
 106e0f9:	mov    %rcx,0x8(%rdx)
 106e0fd:	mov    %rdi,0x500(%rsp)
 106e105:	test   %rdi,%rdi
 106e108:	je     106f47c <check_input_run+0x276c>
 106e10e:	mov    0x18(%rsp),%rax
 106e113:	cmpq   $0x0,0x328(%rax)
 106e11b:	je     106f47c <check_input_run+0x276c>
 106e121:	mov    0x18(%rsp),%r14
 106e126:	mov    $0xff,%esi
 106e12b:	mov    0x334(%r14),%edx
 106e132:	shl    $0x2,%rdx
 106e136:	vzeroupper
 106e139:	call   788120 <memset@plt>
 106e13e:	mov    %r14,%rcx
 106e141:	mov    0x344(%rcx),%ecx
 106e147:	test   %rcx,%rcx
 106e14a:	je     106f45b <check_input_run+0x274b>
 106e150:	mov    0x10(%rsp),%r8
 106e155:	mov    (%r8),%rsi
 106e158:	mov    0x8(%r8),%rdx
 106e15c:	lea    0x7(%rdx,%rsi,1),%rax
 106e161:	add    %rsi,%rdx
 106e164:	and    $0xfffffffffffffff8,%rax
 106e168:	cmp    %rdx,%rax
 106e16b:	jb     106e19a <check_input_run+0x148a>
 106e16d:	mov    %rax,%rdx
 106e170:	sub    %rsi,%rdx
 106e173:	mov    0x10(%r8),%rsi
 106e177:	shl    $0x4,%rcx
 106e17b:	lea    (%rcx,%rcx,4),%rcx
 106e17f:	sub    %rdx,%rsi
 106e182:	setb   %dil
 106e186:	cmp    %rsi,%rcx
 106e189:	seta   %sil
 106e18d:	or     %dil,%sil
 106e190:	cmp    $0x1,%sil
 106e194:	jne    106f443 <check_input_run+0x2733>
 106e19a:	mov    0x18(%rsp),%rax
 106e19f:	movq   $0x0,0x338(%rax)
 106e1aa:	jmp    106f47c <check_input_run+0x276c>
 106e1af:	mov    0x10(%rdi),%rdi
 106e1b3:	mov    %rdx,%rsi
 106e1b6:	sub    %rax,%rsi
 106e1b9:	sub    %rsi,%rdi
 106e1bc:	jb     106d8c4 <check_input_run+0xbb4>
 106e1c2:	mov    0x78(%rsp),%rax
 106e1c7:	lea    0x4(,%rax,4),%rax
 106e1cf:	cmp    %rdi,%rax
 106e1d2:	mov    0x18(%rsp),%rdi
 106e1d7:	ja     106db75 <check_input_run+0xe65>
 106e1dd:	mov    0x10(%rsp),%rcx
 106e1e2:	mov    0x130(%rsp),%r9d
 106e1ea:	add    %rax,%rsi
 106e1ed:	mov    %rsi,0x8(%rcx)
 106e1f1:	mov    %rdx,0xb0(%rdi)
 106e1f8:	test   %rdx,%rdx
 106e1fb:	je     106e26e <check_input_run+0x155e>
 106e1fd:	test   %r9d,%r9d
 106e200:	je     106e26e <check_input_run+0x155e>
 106e202:	mov    0x10(%rsp),%r8
 106e207:	mov    %r9d,0xec(%rdi)
 106e20e:	mov    $0xe0,%ecx
 106e213:	mov    (%r8),%rdi
 106e216:	mov    0x8(%r8),%rsi
 106e21a:	lea    0x7(%rsi,%rdi,1),%rdx
 106e21f:	add    %rdi,%rsi
 106e222:	and    $0xfffffffffffffff8,%rdx
 106e226:	cmp    %rsi,%rdx
 106e229:	jb     106d8c4 <check_input_run+0xbb4>
 106e22f:	mov    %rdx,%rsi
 106e232:	sub    %rdi,%rsi
 106e235:	mov    0x10(%r8),%rdi
 106e239:	sub    %rsi,%rdi
 106e23c:	jb     106d8c4 <check_input_run+0xbb4>
 106e242:	mov    %r9d,%r8d
 106e245:	shl    $0x3,%r8
 106e249:	lea    (%r8,%r8,2),%r8
 106e24d:	cmp    %rdi,%r8
 106e250:	mov    0x18(%rsp),%rdi
 106e255:	ja     106db75 <check_input_run+0xe65>
 106e25b:	mov    0x10(%rsp),%rcx
 106e260:	add    %r8,%rsi
 106e263:	mov    %rsi,0x8(%rcx)
 106e267:	mov    %rdx,0xe0(%rdi)
 106e26e:	test   %rdx,%rdx
 106e271:	je     106db7d <check_input_run+0xe6d>
 106e277:	mov    0x38(%rsp),%rdx
 106e27c:	mov    (%rdx),%rcx
 106e27f:	mov    0x8(%rdx),%rdx
 106e283:	lea    0x3f(%rdx,%rcx,1),%rsi
 106e288:	add    %rcx,%rdx
 106e28b:	and    $0xffffffffffffffc0,%rsi
 106e28f:	cmp    %rdx,%rsi
 106e292:	jb     106db7d <check_input_run+0xe6d>
 106e298:	mov    0x38(%rsp),%rdx
 106e29d:	mov    %rsi,%rdi
 106e2a0:	sub    %rcx,%rdi
 106e2a3:	mov    0x10(%rdx),%rdx
 106e2a7:	mov    %rdx,%r8
 106e2aa:	sub    %rdi,%r8
 106e2ad:	jb     106db7d <check_input_run+0xe6d>
 106e2b3:	cmp    %r8,%rax
 106e2b6:	ja     106db7d <check_input_run+0xe6d>
 106e2bc:	mov    0x38(%rsp),%r8
 106e2c1:	add    %rax,%rdi
 106e2c4:	mov    %rdi,0x8(%r8)
 106e2c8:	mov    %rsi,0x348(%rsp)
 106e2d0:	test   %rsi,%rsi
 106e2d3:	je     106db89 <check_input_run+0xe79>
 106e2d9:	lea    0x3c(%rsi,%rax,1),%rdi
 106e2de:	add    %rax,%rsi
 106e2e1:	and    $0xffffffffffffffc0,%rdi
 106e2e5:	cmp    %rsi,%rdi
 106e2e8:	jb     106db89 <check_input_run+0xe79>
 106e2ee:	mov    %rdi,%r8
 106e2f1:	sub    %rcx,%r8
 106e2f4:	mov    %rdx,%r9
 106e2f7:	sub    %r8,%r9
 106e2fa:	jb     106db89 <check_input_run+0xe79>
 106e300:	mov    0x78(%rsp),%rsi
 106e305:	lea    0x8(,%rsi,8),%rsi
 106e30d:	cmp    %r9,%rsi
 106e310:	ja     106db89 <check_input_run+0xe79>
 106e316:	mov    0x38(%rsp),%r9
 106e31b:	add    %rsi,%r8
 106e31e:	mov    %r8,0x8(%r9)
 106e322:	mov    %rdi,0x350(%rsp)
 106e32a:	test   %rdi,%rdi
 106e32d:	je     106db95 <check_input_run+0xe85>
 106e333:	lea    0x38(%rdi,%rsi,1),%r8
 106e338:	add    %rsi,%rdi
 106e33b:	and    $0xffffffffffffffc0,%r8
 106e33f:	cmp    %rdi,%r8
 106e342:	jb     106db95 <check_input_run+0xe85>
 106e348:	mov    %r8,%rdi
 106e34b:	sub    %rcx,%rdi
 106e34e:	mov    %rdx,%r9
 106e351:	sub    %rdi,%r9
 106e354:	jb     106db95 <check_input_run+0xe85>
 106e35a:	cmp    %r9,%rsi
 106e35d:	ja     106db95 <check_input_run+0xe85>
 106e363:	mov    0x38(%rsp),%r9
 106e368:	add    %rsi,%rdi
 106e36b:	mov    %rdi,0x8(%r9)
 106e36f:	mov    %r8,0x358(%rsp)
 106e377:	test   %r8,%r8
 106e37a:	je     106dba1 <check_input_run+0xe91>
 106e380:	lea    0x38(%r8,%rsi,1),%rdi
 106e385:	add    %rsi,%r8
 106e388:	and    $0xffffffffffffffc0,%rdi
 106e38c:	cmp    %r8,%rdi
 106e38f:	jb     106dba1 <check_input_run+0xe91>
 106e395:	mov    %rdi,%r8
 106e398:	sub    %rcx,%r8
 106e39b:	mov    %rdx,%r9
 106e39e:	sub    %r8,%r9
 106e3a1:	jb     106dba1 <check_input_run+0xe91>
 106e3a7:	cmp    %r9,%rax
 106e3aa:	ja     106dba1 <check_input_run+0xe91>
 106e3b0:	mov    0x38(%rsp),%r9
 106e3b5:	add    %rax,%r8
 106e3b8:	mov    %r8,0x8(%r9)
 106e3bc:	mov    %rdi,0x370(%rsp)
 106e3c4:	test   %rdi,%rdi
 106e3c7:	je     106dbad <check_input_run+0xe9d>
 106e3cd:	lea    0x3c(%rdi,%rax,1),%r8
 106e3d2:	add    %rax,%rdi
 106e3d5:	and    $0xffffffffffffffc0,%r8
 106e3d9:	cmp    %rdi,%r8
 106e3dc:	jb     106dbad <check_input_run+0xe9d>
 106e3e2:	mov    %r8,%rdi
 106e3e5:	sub    %rcx,%rdi
 106e3e8:	mov    %rdx,%r9
 106e3eb:	sub    %rdi,%r9
 106e3ee:	jb     106dbad <check_input_run+0xe9d>
 106e3f4:	cmp    %r9,%rax
 106e3f7:	ja     106dbad <check_input_run+0xe9d>
 106e3fd:	mov    0x38(%rsp),%r9
 106e402:	add    %rax,%rdi
 106e405:	mov    %rdi,0x8(%r9)
 106e409:	mov    %r8,0x398(%rsp)
 106e411:	test   %r8,%r8
 106e414:	je     106dbb9 <check_input_run+0xea9>
 106e41a:	lea    0x3c(%r8,%rax,1),%r9
 106e41f:	add    %rax,%r8
 106e422:	and    $0xffffffffffffffc0,%r9
 106e426:	cmp    %r8,%r9
 106e429:	jb     106dbb9 <check_input_run+0xea9>
 106e42f:	mov    %r9,%r8
 106e432:	sub    %rcx,%r8
 106e435:	mov    %rdx,%rdi
 106e438:	sub    %r8,%rdi
 106e43b:	setb   %r10b
 106e43f:	cmp    0x78(%rsp),%rdi
 106e444:	setbe  %dil
 106e448:	or     %r10b,%dil
 106e44b:	cmp    $0x1,%dil
 106e44f:	je     106dbb9 <check_input_run+0xea9>
 106e455:	mov    0x78(%rsp),%rdi
 106e45a:	mov    0x38(%rsp),%r10
 106e45f:	inc    %rdi
 106e462:	add    %rdi,%r8
 106e465:	mov    %r8,0x8(%r10)
 106e469:	mov    %r9,0x3b0(%rsp)
 106e471:	test   %r9,%r9
 106e474:	je     106dbc5 <check_input_run+0xeb5>
 106e47a:	lea    0x3f(%rdi,%r9,1),%r8
 106e47f:	lea    (%rdi,%r9,1),%r10
 106e483:	and    $0xffffffffffffffc0,%r8
 106e487:	cmp    %r10,%r8
 106e48a:	jb     106dbc5 <check_input_run+0xeb5>
 106e490:	mov    %r8,%r9
 106e493:	sub    %rcx,%r9
 106e496:	mov    %rdx,%r10
 106e499:	sub    %r9,%r10
 106e49c:	setb   %r11b
 106e4a0:	cmp    0x78(%rsp),%r10
 106e4a5:	setbe  %r10b
 106e4a9:	or     %r11b,%r10b
 106e4ac:	cmp    $0x1,%r10b
 106e4b0:	je     106dbc5 <check_input_run+0xeb5>
 106e4b6:	mov    0x38(%rsp),%r10
 106e4bb:	add    %rdi,%r9
 106e4be:	mov    %r9,0x8(%r10)
 106e4c2:	mov    %r8,0x3d8(%rsp)
 106e4ca:	test   %r8,%r8
 106e4cd:	je     106dbd1 <check_input_run+0xec1>
 106e4d3:	lea    (%rdi,%r8,1),%r9
 106e4d7:	lea    0x3f(%rdi,%r8,1),%r8
 106e4dc:	and    $0xffffffffffffffc0,%r8
 106e4e0:	cmp    %r9,%r8
 106e4e3:	jb     106dbd1 <check_input_run+0xec1>
 106e4e9:	mov    %r8,%r9
 106e4ec:	sub    %rcx,%r9
 106e4ef:	mov    %rdx,%r10
 106e4f2:	sub    %r9,%r10
 106e4f5:	setb   %r11b
 106e4f9:	cmp    0x78(%rsp),%r10
 106e4fe:	setbe  %r10b
 106e502:	or     %r11b,%r10b
 106e505:	cmp    $0x1,%r10b
 106e509:	je     106dbd1 <check_input_run+0xec1>
 106e50f:	mov    0x38(%rsp),%r10
 106e514:	add    %rdi,%r9
 106e517:	mov    %r9,0x8(%r10)
 106e51b:	mov    %r8,0x3e0(%rsp)
 106e523:	test   %r8,%r8
 106e526:	je     106dbdd <check_input_run+0xecd>
 106e52c:	lea    (%rdi,%r8,1),%r9
 106e530:	lea    0x3f(%rdi,%r8,1),%r8
 106e535:	and    $0xffffffffffffffc0,%r8
 106e539:	cmp    %r9,%r8
 106e53c:	jb     106dbdd <check_input_run+0xecd>
 106e542:	mov    %r8,%r9
 106e545:	sub    %rcx,%r9
 106e548:	mov    %rdx,%r10
 106e54b:	sub    %r9,%r10
 106e54e:	setb   %r11b
 106e552:	cmp    0x78(%rsp),%r10
 106e557:	setbe  %r10b
 106e55b:	or     %r11b,%r10b
 106e55e:	cmp    $0x1,%r10b
 106e562:	je     106dbdd <check_input_run+0xecd>
 106e568:	mov    0x38(%rsp),%r10
 106e56d:	add    %rdi,%r9
 106e570:	mov    %r9,0x8(%r10)
 106e574:	mov    %r8,0x3e8(%rsp)
 106e57c:	test   %r8,%r8
 106e57f:	je     106dbe9 <check_input_run+0xed9>
 106e585:	lea    0x3f(%rdi,%r8,1),%r9
 106e58a:	lea    (%rdi,%r8,1),%r10
 106e58e:	and    $0xffffffffffffffc0,%r9
 106e592:	cmp    %r10,%r9
 106e595:	jb     106dbe9 <check_input_run+0xed9>
 106e59b:	mov    %r9,%r8
 106e59e:	sub    %rcx,%r8
 106e5a1:	mov    %rdx,%r10
 106e5a4:	sub    %r8,%r10
 106e5a7:	jb     106dbe9 <check_input_run+0xed9>
 106e5ad:	cmp    %r10,%rax
 106e5b0:	ja     106dbe9 <check_input_run+0xed9>
 106e5b6:	mov    0x38(%rsp),%r10
 106e5bb:	add    %rax,%r8
 106e5be:	mov    %r8,0x8(%r10)
 106e5c2:	mov    %r9,0x3f0(%rsp)
 106e5ca:	test   %r9,%r9
 106e5cd:	je     106dbf5 <check_input_run+0xee5>
 106e5d3:	lea    0x3c(%r9,%rax,1),%r8
 106e5d8:	add    %rax,%r9
 106e5db:	and    $0xffffffffffffffc0,%r8
 106e5df:	cmp    %r9,%r8
 106e5e2:	jb     106dbf5 <check_input_run+0xee5>
 106e5e8:	mov    %r8,%r9
 106e5eb:	sub    %rcx,%r9
 106e5ee:	mov    %rdx,%r10
 106e5f1:	sub    %r9,%r10
 106e5f4:	jb     106dbf5 <check_input_run+0xee5>
 106e5fa:	cmp    %r10,%rax
 106e5fd:	ja     106dbf5 <check_input_run+0xee5>
 106e603:	mov    0x38(%rsp),%r10
 106e608:	add    %rax,%r9
 106e60b:	mov    %r9,0x8(%r10)
 106e60f:	mov    %r8,0x3f8(%rsp)
 106e617:	test   %r8,%r8
 106e61a:	je     106dc01 <check_input_run+0xef1>
 106e620:	lea    0x3c(%r8,%rax,1),%r9
 106e625:	add    %rax,%r8
 106e628:	and    $0xffffffffffffffc0,%r9
 106e62c:	cmp    %r8,%r9
 106e62f:	jb     106dc01 <check_input_run+0xef1>
 106e635:	mov    %r9,%r8
 106e638:	sub    %rcx,%r8
 106e63b:	mov    %rdx,%r10
 106e63e:	sub    %r8,%r10
 106e641:	jb     106dc01 <check_input_run+0xef1>
 106e647:	cmp    %r10,%rax
 106e64a:	ja     106dc01 <check_input_run+0xef1>
 106e650:	mov    0x38(%rsp),%r10
 106e655:	add    %rax,%r8
 106e658:	mov    %r8,0x8(%r10)
 106e65c:	mov    %r9,0x400(%rsp)
 106e664:	test   %r9,%r9
 106e667:	je     106dc0d <check_input_run+0xefd>
 106e66d:	lea    0x3c(%r9,%rax,1),%r8
 106e672:	add    %rax,%r9
 106e675:	and    $0xffffffffffffffc0,%r8
 106e679:	cmp    %r9,%r8
 106e67c:	jb     106dc0d <check_input_run+0xefd>
 106e682:	mov    %r8,%r9
 106e685:	sub    %rcx,%r9
 106e688:	mov    %rdx,%r10
 106e68b:	sub    %r9,%r10
 106e68e:	jb     106dc0d <check_input_run+0xefd>
 106e694:	cmp    %r10,%rax
 106e697:	ja     106dc0d <check_input_run+0xefd>
 106e69d:	mov    0x38(%rsp),%r10
 106e6a2:	add    %rax,%r9
 106e6a5:	mov    %r9,0x8(%r10)
 106e6a9:	mov    %r8,0x408(%rsp)
 106e6b1:	test   %r8,%r8
 106e6b4:	je     106dc19 <check_input_run+0xf09>
 106e6ba:	lea    0x3c(%r8,%rax,1),%r9
 106e6bf:	add    %rax,%r8
 106e6c2:	and    $0xffffffffffffffc0,%r9
 106e6c6:	cmp    %r8,%r9
 106e6c9:	jb     106dc19 <check_input_run+0xf09>
 106e6cf:	mov    %r9,%r8
 106e6d2:	sub    %rcx,%r8
 106e6d5:	mov    %rdx,%r10
 106e6d8:	sub    %r8,%r10
 106e6db:	jb     106dc19 <check_input_run+0xf09>
 106e6e1:	cmp    %r10,%rax
 106e6e4:	ja     106dc19 <check_input_run+0xf09>
 106e6ea:	mov    0x38(%rsp),%r10
 106e6ef:	add    %rax,%r8
 106e6f2:	mov    %r8,0x8(%r10)
 106e6f6:	mov    %r9,0x418(%rsp)
 106e6fe:	test   %r9,%r9
 106e701:	je     106dc25 <check_input_run+0xf15>
 106e707:	lea    0x3c(%r9,%rax,1),%r8
 106e70c:	add    %rax,%r9
 106e70f:	and    $0xffffffffffffffc0,%r8
 106e713:	cmp    %r9,%r8
 106e716:	jb     106dc25 <check_input_run+0xf15>
 106e71c:	mov    %r8,%r9
 106e71f:	sub    %rcx,%r9
 106e722:	mov    %rdx,%r10
 106e725:	sub    %r9,%r10
 106e728:	jb     106dc25 <check_input_run+0xf15>
 106e72e:	cmp    %r10,%rsi
 106e731:	ja     106dc25 <check_input_run+0xf15>
 106e737:	mov    0x38(%rsp),%r10
 106e73c:	add    %rsi,%r9
 106e73f:	mov    %r9,0x8(%r10)
 106e743:	mov    %r8,0x420(%rsp)
 106e74b:	test   %r8,%r8
 106e74e:	je     106dc31 <check_input_run+0xf21>
 106e754:	lea    0x38(%r8,%rsi,1),%r9
 106e759:	add    %rsi,%r8
 106e75c:	and    $0xffffffffffffffc0,%r9
 106e760:	cmp    %r8,%r9
 106e763:	jb     106dc31 <check_input_run+0xf21>
 106e769:	mov    %r9,%r8
 106e76c:	sub    %rcx,%r8
 106e76f:	mov    %rdx,%r10
 106e772:	sub    %r8,%r10
 106e775:	setb   %r11b
 106e779:	cmp    0x78(%rsp),%r10
 106e77e:	setbe  %r10b
 106e782:	or     %r11b,%r10b
 106e785:	cmp    $0x1,%r10b
 106e789:	je     106dc31 <check_input_run+0xf21>
 106e78f:	mov    0x38(%rsp),%r10
 106e794:	add    %rdi,%r8
 106e797:	mov    %r8,0x8(%r10)
 106e79b:	mov    %r9,0x428(%rsp)
 106e7a3:	test   %r9,%r9
 106e7a6:	je     106dc3d <check_input_run+0xf2d>
 106e7ac:	lea    (%rdi,%r9,1),%r8
 106e7b0:	lea    0x3f(%rdi,%r9,1),%r9
 106e7b5:	and    $0xffffffffffffffc0,%r9
 106e7b9:	cmp    %r8,%r9
 106e7bc:	jb     106dc3d <check_input_run+0xf2d>
 106e7c2:	mov    %r9,%r8
 106e7c5:	sub    %rcx,%r8
 106e7c8:	mov    %rdx,%r10
 106e7cb:	sub    %r8,%r10
 106e7ce:	jb     106dc3d <check_input_run+0xf2d>
 106e7d4:	cmp    %r10,%rax
 106e7d7:	ja     106dc3d <check_input_run+0xf2d>
 106e7dd:	mov    0x38(%rsp),%r10
 106e7e2:	add    %rax,%r8
 106e7e5:	mov    %r8,0x8(%r10)
 106e7e9:	mov    %r9,0x430(%rsp)
 106e7f1:	test   %r9,%r9
 106e7f4:	je     106dc49 <check_input_run+0xf39>
 106e7fa:	lea    0x3c(%r9,%rax,1),%r8
 106e7ff:	add    %rax,%r9
 106e802:	and    $0xffffffffffffffc0,%r8
 106e806:	cmp    %r9,%r8
 106e809:	jb     106dc49 <check_input_run+0xf39>
 106e80f:	mov    %r8,%r9
 106e812:	sub    %rcx,%r9
 106e815:	mov    %rdx,%r10
 106e818:	sub    %r9,%r10
 106e81b:	jb     106dc49 <check_input_run+0xf39>
 106e821:	cmp    %r10,%rax
 106e824:	ja     106dc49 <check_input_run+0xf39>
 106e82a:	mov    0x38(%rsp),%r10
 106e82f:	add    %rax,%r9
 106e832:	mov    %r9,0x8(%r10)
 106e836:	mov    %r8,0x438(%rsp)
 106e83e:	test   %r8,%r8
 106e841:	je     106dc55 <check_input_run+0xf45>
 106e847:	lea    0x3c(%r8,%rax,1),%r9
 106e84c:	add    %rax,%r8
 106e84f:	and    $0xffffffffffffffc0,%r9
 106e853:	cmp    %r8,%r9
 106e856:	jb     106dc55 <check_input_run+0xf45>
 106e85c:	mov    %r9,%r8
 106e85f:	sub    %rcx,%r8
 106e862:	mov    %rdx,%r10
 106e865:	sub    %r8,%r10
 106e868:	jb     106dc55 <check_input_run+0xf45>
 106e86e:	cmp    %r10,%rax
 106e871:	ja     106dc55 <check_input_run+0xf45>
 106e877:	mov    0x38(%rsp),%r10
 106e87c:	add    %rax,%r8
 106e87f:	mov    %r8,0x8(%r10)
 106e883:	mov    %r9,0x440(%rsp)
 106e88b:	test   %r9,%r9
 106e88e:	je     106dc61 <check_input_run+0xf51>
 106e894:	lea    0x3c(%r9,%rax,1),%r8
 106e899:	add    %rax,%r9
 106e89c:	and    $0xffffffffffffffc0,%r8
 106e8a0:	cmp    %r9,%r8
 106e8a3:	jb     106dc61 <check_input_run+0xf51>
 106e8a9:	mov    %r8,%r9
 106e8ac:	sub    %rcx,%r9
 106e8af:	mov    %rdx,%r10
 106e8b2:	sub    %r9,%r10
 106e8b5:	jb     106dc61 <check_input_run+0xf51>
 106e8bb:	cmp    %r10,%rax
 106e8be:	ja     106dc61 <check_input_run+0xf51>
 106e8c4:	mov    0x38(%rsp),%r10
 106e8c9:	add    %rax,%r9
 106e8cc:	mov    %r9,0x8(%r10)
 106e8d0:	mov    %r8,0x448(%rsp)
 106e8d8:	test   %r8,%r8
 106e8db:	je     106dc6d <check_input_run+0xf5d>
 106e8e1:	lea    0x3c(%r8,%rax,1),%r9
 106e8e6:	add    %rax,%r8
 106e8e9:	and    $0xffffffffffffffc0,%r9
 106e8ed:	cmp    %r8,%r9
 106e8f0:	jb     106dc6d <check_input_run+0xf5d>
 106e8f6:	mov    %r9,%r8
 106e8f9:	sub    %rcx,%r8
 106e8fc:	mov    %rdx,%r10
 106e8ff:	sub    %r8,%r10
 106e902:	jb     106dc6d <check_input_run+0xf5d>
 106e908:	cmp    %r10,%rax
 106e90b:	ja     106dc6d <check_input_run+0xf5d>
 106e911:	mov    0x38(%rsp),%r10
 106e916:	add    %rax,%r8
 106e919:	mov    %r8,0x8(%r10)
 106e91d:	mov    %r9,0x450(%rsp)
 106e925:	test   %r9,%r9
 106e928:	je     106dc79 <check_input_run+0xf69>
 106e92e:	lea    0x3c(%r9,%rax,1),%r8
 106e933:	add    %rax,%r9
 106e936:	and    $0xffffffffffffffc0,%r8
 106e93a:	cmp    %r9,%r8
 106e93d:	jb     106dc79 <check_input_run+0xf69>
 106e943:	mov    %r8,%r9
 106e946:	sub    %rcx,%r9
 106e949:	mov    %rdx,%r10
 106e94c:	sub    %r9,%r10
 106e94f:	jb     106dc79 <check_input_run+0xf69>
 106e955:	cmp    %r10,%rax
 106e958:	ja     106dc79 <check_input_run+0xf69>
 106e95e:	mov    0x38(%rsp),%r10
 106e963:	add    %rax,%r9
 106e966:	mov    %r9,0x8(%r10)
 106e96a:	mov    %r8,0x460(%rsp)
 106e972:	test   %r8,%r8
 106e975:	je     106dc85 <check_input_run+0xf75>
 106e97b:	lea    0x3c(%r8,%rax,1),%r9
 106e980:	add    %rax,%r8
 106e983:	and    $0xffffffffffffffc0,%r9
 106e987:	cmp    %r8,%r9
 106e98a:	jb     106dc85 <check_input_run+0xf75>
 106e990:	mov    %r9,%r10
 106e993:	sub    %rcx,%r10
 106e996:	mov    %rdx,%r11
 106e999:	sub    %r10,%r11
 106e99c:	jb     106dc85 <check_input_run+0xf75>
 106e9a2:	mov    0x78(%rsp),%r8
 106e9a7:	lea    0x2(%r8,%r8,1),%r8
 106e9ac:	cmp    %r11,%r8
 106e9af:	ja     106dc85 <check_input_run+0xf75>
 106e9b5:	mov    0x38(%rsp),%r11
 106e9ba:	add    %r8,%r10
 106e9bd:	mov    %r10,0x8(%r11)
 106e9c1:	mov    %r9,0x4a8(%rsp)
 106e9c9:	test   %r9,%r9
 106e9cc:	je     106dc91 <check_input_run+0xf81>
 106e9d2:	lea    (%r9,%r8,1),%r10
 106e9d6:	lea    0x3e(%r9,%r8,1),%r9
 106e9db:	and    $0xffffffffffffffc0,%r9
 106e9df:	cmp    %r10,%r9
 106e9e2:	jb     106dc91 <check_input_run+0xf81>
 106e9e8:	mov    %r9,%r8
 106e9eb:	sub    %rcx,%r8
 106e9ee:	mov    %rdx,%r10
 106e9f1:	sub    %r8,%r10
 106e9f4:	jb     106dc91 <check_input_run+0xf81>
 106e9fa:	cmp    %r10,%rax
 106e9fd:	ja     106dc91 <check_input_run+0xf81>
 106ea03:	mov    0x38(%rsp),%r10
 106ea08:	add    %rax,%r8
 106ea0b:	mov    %r8,0x8(%r10)
 106ea0f:	mov    %r9,0x4b0(%rsp)
 106ea17:	test   %r9,%r9
 106ea1a:	je     106dc9d <check_input_run+0xf8d>
 106ea20:	lea    0x3c(%r9,%rax,1),%r8
 106ea25:	add    %rax,%r9
 106ea28:	and    $0xffffffffffffffc0,%r8
 106ea2c:	cmp    %r9,%r8
 106ea2f:	jb     106dc9d <check_input_run+0xf8d>
 106ea35:	mov    %r8,%r9
 106ea38:	sub    %rcx,%r9
 106ea3b:	mov    %rdx,%r10
 106ea3e:	sub    %r9,%r10
 106ea41:	jb     106dc9d <check_input_run+0xf8d>
 106ea47:	cmp    %r10,%rax
 106ea4a:	ja     106dc9d <check_input_run+0xf8d>
 106ea50:	mov    0x38(%rsp),%r10
 106ea55:	add    %rax,%r9
 106ea58:	mov    %r9,0x8(%r10)
 106ea5c:	mov    %r8,0x4d0(%rsp)
 106ea64:	test   %r8,%r8
 106ea67:	je     106dca9 <check_input_run+0xf99>
 106ea6d:	lea    0x3c(%r8,%rax,1),%r9
 106ea72:	add    %rax,%r8
 106ea75:	and    $0xffffffffffffffc0,%r9
 106ea79:	cmp    %r8,%r9
 106ea7c:	jb     106dca9 <check_input_run+0xf99>
 106ea82:	mov    %r9,%r8
 106ea85:	sub    %rcx,%r8
 106ea88:	mov    %rdx,%r10
 106ea8b:	sub    %r8,%r10
 106ea8e:	jb     106dca9 <check_input_run+0xf99>
 106ea94:	cmp    %r10,%rax
 106ea97:	ja     106dca9 <check_input_run+0xf99>
 106ea9d:	mov    0x38(%rsp),%r10
 106eaa2:	add    %rax,%r8
 106eaa5:	mov    %r8,0x8(%r10)
 106eaa9:	mov    %r9,0x4d8(%rsp)
 106eab1:	test   %r9,%r9
 106eab4:	je     106dcb5 <check_input_run+0xfa5>
 106eaba:	lea    0x3c(%r9,%rax,1),%r8
 106eabf:	add    %rax,%r9
 106eac2:	and    $0xffffffffffffffc0,%r8
 106eac6:	cmp    %r9,%r8
 106eac9:	jb     106dcb5 <check_input_run+0xfa5>
 106eacf:	mov    %r8,%r9
 106ead2:	sub    %rcx,%r9
 106ead5:	mov    %rdx,%r10
 106ead8:	sub    %r9,%r10
 106eadb:	jb     106dcb5 <check_input_run+0xfa5>
 106eae1:	cmp    %r10,%rax
 106eae4:	ja     106dcb5 <check_input_run+0xfa5>
 106eaea:	mov    0x38(%rsp),%r10
 106eaef:	add    %rax,%r9
 106eaf2:	mov    %r9,0x8(%r10)
 106eaf6:	mov    %r8,0x4e8(%rsp)
 106eafe:	test   %r8,%r8
 106eb01:	je     106dcc1 <check_input_run+0xfb1>
 106eb07:	lea    0x3c(%r8,%rax,1),%r9
 106eb0c:	add    %rax,%r8
 106eb0f:	and    $0xffffffffffffffc0,%r9
 106eb13:	cmp    %r8,%r9
 106eb16:	jb     106dcc1 <check_input_run+0xfb1>
 106eb1c:	mov    %r9,%r8
 106eb1f:	sub    %rcx,%r8
 106eb22:	mov    %rdx,%r10
 106eb25:	sub    %r8,%r10
 106eb28:	jb     106dcc1 <check_input_run+0xfb1>
 106eb2e:	cmp    %r10,%rax
 106eb31:	ja     106dcc1 <check_input_run+0xfb1>
 106eb37:	mov    0x38(%rsp),%r10
 106eb3c:	add    %rax,%r8
 106eb3f:	mov    %r8,0x8(%r10)
 106eb43:	mov    %r9,0x4f0(%rsp)
 106eb4b:	test   %r9,%r9
 106eb4e:	je     106dccd <check_input_run+0xfbd>
 106eb54:	lea    0x3c(%r9,%rax,1),%r8
 106eb59:	add    %rax,%r9
 106eb5c:	and    $0xffffffffffffffc0,%r8
 106eb60:	cmp    %r9,%r8
 106eb63:	jb     106dccd <check_input_run+0xfbd>
 106eb69:	mov    %r8,%r9
 106eb6c:	sub    %rcx,%r9
 106eb6f:	mov    %rdx,%r10
 106eb72:	sub    %r9,%r10
 106eb75:	jb     106dccd <check_input_run+0xfbd>
 106eb7b:	cmp    %r10,%rax
 106eb7e:	ja     106dccd <check_input_run+0xfbd>
 106eb84:	mov    0x38(%rsp),%r10
 106eb89:	add    %rax,%r9
 106eb8c:	mov    %r9,0x8(%r10)
 106eb90:	mov    %r8,0x4f8(%rsp)
 106eb98:	test   %r8,%r8
 106eb9b:	je     106dcd9 <check_input_run+0xfc9>
 106eba1:	lea    0x3c(%r8,%rax,1),%r9
 106eba6:	add    %rax,%r8
 106eba9:	and    $0xffffffffffffffc0,%r9
 106ebad:	cmp    %r8,%r9
 106ebb0:	jb     106dcd9 <check_input_run+0xfc9>
 106ebb6:	mov    %r9,%r8
 106ebb9:	sub    %rcx,%r8
 106ebbc:	mov    %rdx,%r10
 106ebbf:	sub    %r8,%r10
 106ebc2:	setb   %r11b
 106ebc6:	cmp    0x78(%rsp),%r10
 106ebcb:	setbe  %r10b
 106ebcf:	or     %r11b,%r10b
 106ebd2:	cmp    $0x1,%r10b
 106ebd6:	je     106dcd9 <check_input_run+0xfc9>
 106ebdc:	mov    0x38(%rsp),%r10
 106ebe1:	add    %rdi,%r8
 106ebe4:	mov    %r8,0x8(%r10)
 106ebe8:	mov    %r9,0x508(%rsp)
 106ebf0:	test   %r9,%r9
 106ebf3:	je     106dce5 <check_input_run+0xfd5>
 106ebf9:	lea    0x3f(%rdi,%r9,1),%r8
 106ebfe:	lea    (%rdi,%r9,1),%r10
 106ec02:	and    $0xffffffffffffffc0,%r8
 106ec06:	cmp    %r10,%r8
 106ec09:	jb     106dce5 <check_input_run+0xfd5>
 106ec0f:	mov    %r8,%r9
 106ec12:	sub    %rcx,%r9
 106ec15:	mov    %rdx,%r10
 106ec18:	sub    %r9,%r10
 106ec1b:	setb   %r11b
 106ec1f:	cmp    0x78(%rsp),%r10
 106ec24:	setbe  %r10b
 106ec28:	or     %r11b,%r10b
 106ec2b:	cmp    $0x1,%r10b
 106ec2f:	je     106dce5 <check_input_run+0xfd5>
 106ec35:	mov    0x38(%rsp),%r10
 106ec3a:	add    %rdi,%r9
 106ec3d:	mov    %r9,0x8(%r10)
 106ec41:	mov    %r8,0x510(%rsp)
 106ec49:	test   %r8,%r8
 106ec4c:	je     106dcf1 <check_input_run+0xfe1>
 106ec52:	lea    (%rdi,%r8,1),%r9
 106ec56:	lea    0x3f(%rdi,%r8,1),%r8
 106ec5b:	and    $0xffffffffffffffc0,%r8
 106ec5f:	cmp    %r9,%r8
 106ec62:	jb     106dcf1 <check_input_run+0xfe1>
 106ec68:	mov    %r8,%r9
 106ec6b:	sub    %rcx,%r9
 106ec6e:	mov    %rdx,%r10
 106ec71:	sub    %r9,%r10
 106ec74:	setb   %r11b
 106ec78:	cmp    0x78(%rsp),%r10
 106ec7d:	setbe  %r10b
 106ec81:	or     %r11b,%r10b
 106ec84:	cmp    $0x1,%r10b
 106ec88:	je     106dcf1 <check_input_run+0xfe1>
 106ec8e:	mov    0x38(%rsp),%r10
 106ec93:	add    %rdi,%r9
 106ec96:	mov    %r9,0x8(%r10)
 106ec9a:	mov    %r8,0x520(%rsp)
 106eca2:	test   %r8,%r8
 106eca5:	je     106dcfd <check_input_run+0xfed>
 106ecab:	lea    (%rdi,%r8,1),%r9
 106ecaf:	lea    0x3f(%rdi,%r8,1),%r8
 106ecb4:	and    $0xffffffffffffffc0,%r8
 106ecb8:	cmp    %r9,%r8
 106ecbb:	jb     106dcfd <check_input_run+0xfed>
 106ecc1:	mov    %r8,%r9
 106ecc4:	sub    %rcx,%r9
 106ecc7:	mov    %rdx,%r10
 106ecca:	sub    %r9,%r10
 106eccd:	setb   %r11b
 106ecd1:	cmp    0x78(%rsp),%r10
 106ecd6:	setbe  %r10b
 106ecda:	or     %r11b,%r10b
 106ecdd:	cmp    $0x1,%r10b
 106ece1:	je     106dcfd <check_input_run+0xfed>
 106ece7:	mov    0x38(%rsp),%r10
 106ecec:	add    %rdi,%r9
 106ecef:	mov    %r9,0x8(%r10)
 106ecf3:	mov    %r8,0x528(%rsp)
 106ecfb:	test   %r8,%r8
 106ecfe:	je     106dd09 <check_input_run+0xff9>
 106ed04:	lea    0x3f(%rdi,%r8,1),%r9
 106ed09:	lea    (%rdi,%r8,1),%r10
 106ed0d:	and    $0xffffffffffffffc0,%r9
 106ed11:	cmp    %r10,%r9
 106ed14:	jb     106dd09 <check_input_run+0xff9>
 106ed1a:	mov    %r9,%r8
 106ed1d:	sub    %rcx,%r8
 106ed20:	mov    %rdx,%r10
 106ed23:	sub    %r8,%r10
 106ed26:	jb     106dd09 <check_input_run+0xff9>
 106ed2c:	cmp    %r10,%rax
 106ed2f:	ja     106dd09 <check_input_run+0xff9>
 106ed35:	mov    0x38(%rsp),%r10
 106ed3a:	add    %rax,%r8
 106ed3d:	mov    %r8,0x8(%r10)
 106ed41:	mov    %r9,0x530(%rsp)
 106ed49:	test   %r9,%r9
 106ed4c:	je     106dd15 <check_input_run+0x1005>
 106ed52:	lea    0x3c(%r9,%rax,1),%r8
 106ed57:	add    %rax,%r9
 106ed5a:	and    $0xffffffffffffffc0,%r8
 106ed5e:	cmp    %r9,%r8
 106ed61:	jb     106dd15 <check_input_run+0x1005>
 106ed67:	mov    %r8,%r9
 106ed6a:	sub    %rcx,%r9
 106ed6d:	mov    %rdx,%r10
 106ed70:	sub    %r9,%r10
 106ed73:	jb     106dd15 <check_input_run+0x1005>
 106ed79:	cmp    %r10,%rax
 106ed7c:	ja     106dd15 <check_input_run+0x1005>
 106ed82:	mov    0x38(%rsp),%r10
 106ed87:	add    %rax,%r9
 106ed8a:	mov    %r9,0x8(%r10)
 106ed8e:	mov    %r8,0x538(%rsp)
 106ed96:	test   %r8,%r8
 106ed99:	je     106dd21 <check_input_run+0x1011>
 106ed9f:	lea    0x3c(%r8,%rax,1),%r9
 106eda4:	add    %rax,%r8
 106eda7:	and    $0xffffffffffffffc0,%r9
 106edab:	cmp    %r8,%r9
 106edae:	jb     106dd21 <check_input_run+0x1011>
 106edb4:	mov    %r9,%r8
 106edb7:	sub    %rcx,%r8
 106edba:	mov    %rdx,%r10
 106edbd:	sub    %r8,%r10
 106edc0:	setb   %r11b
 106edc4:	cmp    0x78(%rsp),%r10
 106edc9:	setbe  %r10b
 106edcd:	or     %r11b,%r10b
 106edd0:	cmp    $0x1,%r10b
 106edd4:	je     106dd21 <check_input_run+0x1011>
 106edda:	mov    0x38(%rsp),%r10
 106eddf:	add    %rdi,%r8
 106ede2:	mov    %r8,0x8(%r10)
 106ede6:	mov    %r9,0x540(%rsp)
 106edee:	test   %r9,%r9
 106edf1:	je     106dd2d <check_input_run+0x101d>
 106edf7:	lea    0x3f(%rdi,%r9,1),%r8
 106edfc:	lea    (%rdi,%r9,1),%r10
 106ee00:	and    $0xffffffffffffffc0,%r8
 106ee04:	cmp    %r10,%r8
 106ee07:	jb     106dd2d <check_input_run+0x101d>
 106ee0d:	mov    %r8,%r9
 106ee10:	sub    %rcx,%r9
 106ee13:	mov    %rdx,%r10
 106ee16:	sub    %r9,%r10
 106ee19:	setb   %r11b
 106ee1d:	cmp    0x78(%rsp),%r10
 106ee22:	setbe  %r10b
 106ee26:	or     %r11b,%r10b
 106ee29:	cmp    $0x1,%r10b
 106ee2d:	je     106dd2d <check_input_run+0x101d>
 106ee33:	mov    0x38(%rsp),%r10
 106ee38:	add    %rdi,%r9
 106ee3b:	mov    %r9,0x8(%r10)
 106ee3f:	mov    %r8,0x548(%rsp)
 106ee47:	test   %r8,%r8
 106ee4a:	je     106dd39 <check_input_run+0x1029>
 106ee50:	lea    (%rdi,%r8,1),%r9
 106ee54:	lea    0x3f(%rdi,%r8,1),%r8
 106ee59:	and    $0xffffffffffffffc0,%r8
 106ee5d:	cmp    %r9,%r8
 106ee60:	jb     106dd39 <check_input_run+0x1029>
 106ee66:	mov    %r8,%r9
 106ee69:	sub    %rcx,%r9
 106ee6c:	mov    %rdx,%r10
 106ee6f:	sub    %r9,%r10
 106ee72:	jb     106dd39 <check_input_run+0x1029>
 106ee78:	cmp    %r10,%rsi
 106ee7b:	ja     106dd39 <check_input_run+0x1029>
 106ee81:	mov    0x38(%rsp),%r10
 106ee86:	add    %rsi,%r9
 106ee89:	mov    %r9,0x8(%r10)
 106ee8d:	mov    %r8,0x550(%rsp)
 106ee95:	test   %r8,%r8
 106ee98:	je     106dd45 <check_input_run+0x1035>
 106ee9e:	lea    (%r8,%rsi,1),%r9
 106eea2:	lea    0x38(%r8,%rsi,1),%r8
 106eea7:	and    $0xffffffffffffffc0,%r8
 106eeab:	cmp    %r9,%r8
 106eeae:	jb     106dd45 <check_input_run+0x1035>
 106eeb4:	mov    %r8,%rsi
 106eeb7:	sub    %rcx,%rsi
 106eeba:	mov    %rdx,%r9
 106eebd:	sub    %rsi,%r9
 106eec0:	jb     106dd45 <check_input_run+0x1035>
 106eec6:	cmp    %r9,%rax
 106eec9:	ja     106dd45 <check_input_run+0x1035>
 106eecf:	mov    0x38(%rsp),%r9
 106eed4:	add    %rax,%rsi
 106eed7:	mov    %rsi,0x8(%r9)
 106eedb:	mov    %r8,0x570(%rsp)
 106eee3:	test   %r8,%r8
 106eee6:	je     106dd51 <check_input_run+0x1041>
 106eeec:	lea    0x3c(%r8,%rax,1),%rsi
 106eef1:	add    %rax,%r8
 106eef4:	and    $0xffffffffffffffc0,%rsi
 106eef8:	cmp    %r8,%rsi
 106eefb:	jb     106dd51 <check_input_run+0x1041>
 106ef01:	mov    %rsi,%r8
 106ef04:	sub    %rcx,%r8
 106ef07:	mov    %rdx,%r9
 106ef0a:	sub    %r8,%r9
 106ef0d:	jb     106dd51 <check_input_run+0x1041>
 106ef13:	cmp    %r9,%rax
 106ef16:	ja     106dd51 <check_input_run+0x1041>
 106ef1c:	mov    0x38(%rsp),%r9
 106ef21:	add    %rax,%r8
 106ef24:	mov    %r8,0x8(%r9)
 106ef28:	mov    %rsi,0x578(%rsp)
 106ef30:	test   %rsi,%rsi
 106ef33:	je     106dd5d <check_input_run+0x104d>
 106ef39:	lea    0x3c(%rsi,%rax,1),%r8
 106ef3e:	add    %rax,%rsi
 106ef41:	and    $0xffffffffffffffc0,%r8
 106ef45:	cmp    %rsi,%r8
 106ef48:	jb     106dd5d <check_input_run+0x104d>
 106ef4e:	mov    %r8,%rsi
 106ef51:	sub    %rcx,%rsi
 106ef54:	mov    %rdx,%r9
 106ef57:	sub    %rsi,%r9
 106ef5a:	jb     106dd5d <check_input_run+0x104d>
 106ef60:	cmp    %r9,%rax
 106ef63:	ja     106dd5d <check_input_run+0x104d>
 106ef69:	mov    0x38(%rsp),%r9
 106ef6e:	add    %rax,%rsi
 106ef71:	mov    %rsi,0x8(%r9)
 106ef75:	mov    %r8,0x598(%rsp)
 106ef7d:	test   %r8,%r8
 106ef80:	je     106dd69 <check_input_run+0x1059>
 106ef86:	lea    0x3c(%r8,%rax,1),%rsi
 106ef8b:	add    %rax,%r8
 106ef8e:	and    $0xffffffffffffffc0,%rsi
 106ef92:	cmp    %r8,%rsi
 106ef95:	jb     106dd69 <check_input_run+0x1059>
 106ef9b:	mov    %rsi,%r8
 106ef9e:	sub    %rcx,%r8
 106efa1:	mov    %rdx,%r9
 106efa4:	sub    %r8,%r9
 106efa7:	setb   %r10b
 106efab:	cmp    0x78(%rsp),%r9
 106efb0:	setbe  %r9b
 106efb4:	or     %r10b,%r9b
 106efb7:	cmp    $0x1,%r9b
 106efbb:	je     106dd69 <check_input_run+0x1059>
 106efc1:	mov    0x38(%rsp),%r9
 106efc6:	add    %rdi,%r8
 106efc9:	mov    %r8,0x8(%r9)
 106efcd:	mov    %rsi,0x5a0(%rsp)
 106efd5:	test   %rsi,%rsi
 106efd8:	je     106dd75 <check_input_run+0x1065>
 106efde:	lea    (%rdi,%rsi,1),%r8
 106efe2:	lea    0x3f(%rdi,%rsi,1),%rdi
 106efe7:	and    $0xffffffffffffffc0,%rdi
 106efeb:	cmp    %r8,%rdi
 106efee:	jb     106dd75 <check_input_run+0x1065>
 106eff4:	mov    %rdi,%rsi
 106eff7:	sub    %rcx,%rsi
 106effa:	mov    %rdx,%r8
 106effd:	sub    %rsi,%r8
 106f000:	jb     106dd75 <check_input_run+0x1065>
 106f006:	cmp    %r8,%rax
 106f009:	ja     106dd75 <check_input_run+0x1065>
 106f00f:	mov    0x38(%rsp),%r8
 106f014:	add    %rax,%rsi
 106f017:	mov    %rsi,0x8(%r8)
 106f01b:	mov    %rdi,0x5a8(%rsp)
 106f023:	test   %rdi,%rdi
 106f026:	je     106dd81 <check_input_run+0x1071>
 106f02c:	lea    0x3c(%rdi,%rax,1),%rsi
 106f031:	add    %rax,%rdi
 106f034:	and    $0xffffffffffffffc0,%rsi
 106f038:	cmp    %rdi,%rsi
 106f03b:	jb     106dd81 <check_input_run+0x1071>
 106f041:	mov    %rsi,%rdi
 106f044:	sub    %rcx,%rdi
 106f047:	mov    %rdx,%r8
 106f04a:	sub    %rdi,%r8
 106f04d:	jb     106dd81 <check_input_run+0x1071>
 106f053:	cmp    %r8,%rax
 106f056:	ja     106dd81 <check_input_run+0x1071>
 106f05c:	mov    0x38(%rsp),%r8
 106f061:	add    %rax,%rdi
 106f064:	mov    %rdi,0x8(%r8)
 106f068:	mov    %rsi,0x5b0(%rsp)
 106f070:	test   %rsi,%rsi
 106f073:	je     106dd8d <check_input_run+0x107d>
 106f079:	lea    0x3c(%rsi,%rax,1),%rdi
 106f07e:	add    %rax,%rsi
 106f081:	and    $0xffffffffffffffc0,%rdi
 106f085:	cmp    %rsi,%rdi
 106f088:	jb     106dd8d <check_input_run+0x107d>
 106f08e:	mov    %rdi,%rsi
 106f091:	sub    %rcx,%rsi
 106f094:	mov    %rdx,%r8
 106f097:	sub    %rsi,%r8
 106f09a:	jb     106dd8d <check_input_run+0x107d>
 106f0a0:	cmp    %r8,%rax
 106f0a3:	ja     106dd8d <check_input_run+0x107d>
 106f0a9:	mov    0x38(%rsp),%r8
 106f0ae:	add    %rax,%rsi
 106f0b1:	mov    %rsi,0x8(%r8)
 106f0b5:	mov    %rdi,0x5d0(%rsp)
 106f0bd:	test   %rdi,%rdi
 106f0c0:	je     106dd99 <check_input_run+0x1089>
 106f0c6:	lea    0x3c(%rdi,%rax,1),%rsi
 106f0cb:	add    %rax,%rdi
 106f0ce:	and    $0xffffffffffffffc0,%rsi
 106f0d2:	cmp    %rdi,%rsi
 106f0d5:	jb     106dd99 <check_input_run+0x1089>
 106f0db:	mov    %rsi,%rdi
 106f0de:	sub    %rcx,%rdi
 106f0e1:	mov    %rdx,%r8
 106f0e4:	sub    %rdi,%r8
 106f0e7:	jb     106dd99 <check_input_run+0x1089>
 106f0ed:	cmp    %r8,%rax
 106f0f0:	ja     106dd99 <check_input_run+0x1089>
 106f0f6:	mov    0x38(%rsp),%r8
 106f0fb:	add    %rax,%rdi
 106f0fe:	mov    %rdi,0x8(%r8)
 106f102:	mov    %rsi,0x5d8(%rsp)
 106f10a:	test   %rsi,%rsi
 106f10d:	je     106dda5 <check_input_run+0x1095>
 106f113:	lea    0x3c(%rsi,%rax,1),%rdi
 106f118:	add    %rax,%rsi
 106f11b:	and    $0xffffffffffffffc0,%rdi
 106f11f:	cmp    %rsi,%rdi
 106f122:	jb     106dda5 <check_input_run+0x1095>
 106f128:	mov    %rdi,%r8
 106f12b:	sub    %rcx,%r8
 106f12e:	mov    %rdx,%r9
 106f131:	sub    %r8,%r9
 106f134:	jb     106dda5 <check_input_run+0x1095>
 106f13a:	mov    0x78(%rsp),%rsi
 106f13f:	shl    $0x4,%rsi
 106f143:	add    $0x10,%rsi
 106f147:	cmp    %r9,%rsi
 106f14a:	ja     106dda5 <check_input_run+0x1095>
 106f150:	mov    0x38(%rsp),%r9
 106f155:	add    %rsi,%r8
 106f158:	mov    %r8,0x8(%r9)
 106f15c:	mov    %rdi,0x5e0(%rsp)
 106f164:	test   %rdi,%rdi
 106f167:	je     106ddb1 <check_input_run+0x10a1>
 106f16d:	lea    (%rdi,%rsi,1),%r8
 106f171:	lea    0x30(%rdi,%rsi,1),%rdi
 106f176:	and    $0xffffffffffffffc0,%rdi
 106f17a:	cmp    %r8,%rdi
 106f17d:	jb     106ddb1 <check_input_run+0x10a1>
 106f183:	mov    %rdi,%rsi
 106f186:	sub    %rcx,%rsi
 106f189:	mov    %rdx,%r8
 106f18c:	sub    %rsi,%r8
 106f18f:	jb     106ddb1 <check_input_run+0x10a1>
 106f195:	cmp    %r8,%rax
 106f198:	ja     106ddb1 <check_input_run+0x10a1>
 106f19e:	mov    0x38(%rsp),%r8
 106f1a3:	add    %rax,%rsi
 106f1a6:	mov    %rsi,0x8(%r8)
 106f1aa:	mov    %rdi,0x5e8(%rsp)
 106f1b2:	test   %rdi,%rdi
 106f1b5:	je     106ddbd <check_input_run+0x10ad>
 106f1bb:	lea    0x3c(%rdi,%rax,1),%rsi
 106f1c0:	add    %rax,%rdi
 106f1c3:	and    $0xffffffffffffffc0,%rsi
 106f1c7:	cmp    %rdi,%rsi
 106f1ca:	jb     106ddbd <check_input_run+0x10ad>
 106f1d0:	mov    %rsi,%rdi
 106f1d3:	sub    %rcx,%rdi
 106f1d6:	mov    %rdx,%r8
 106f1d9:	sub    %rdi,%r8
 106f1dc:	jb     106ddbd <check_input_run+0x10ad>
 106f1e2:	cmp    %r8,%rax
 106f1e5:	ja     106ddbd <check_input_run+0x10ad>
 106f1eb:	mov    0x38(%rsp),%r8
 106f1f0:	add    %rax,%rdi
 106f1f3:	mov    %rdi,0x8(%r8)
 106f1f7:	mov    %rsi,0x608(%rsp)
 106f1ff:	test   %rsi,%rsi
 106f202:	je     106ddc9 <check_input_run+0x10b9>
 106f208:	lea    0x3c(%rsi,%rax,1),%rdi
 106f20d:	add    %rax,%rsi
 106f210:	and    $0xffffffffffffffc0,%rdi
 106f214:	cmp    %rsi,%rdi
 106f217:	jb     106ddc9 <check_input_run+0x10b9>
 106f21d:	mov    %rdi,%rsi
 106f220:	sub    %rcx,%rsi
 106f223:	mov    %rdx,%r8
 106f226:	sub    %rsi,%r8
 106f229:	jb     106ddc9 <check_input_run+0x10b9>
 106f22f:	cmp    %r8,%rax
 106f232:	ja     106ddc9 <check_input_run+0x10b9>
 106f238:	mov    0x38(%rsp),%r8
 106f23d:	add    %rax,%rsi
 106f240:	mov    %rsi,0x8(%r8)
 106f244:	mov    %rdi,0x610(%rsp)
 106f24c:	test   %rdi,%rdi
 106f24f:	je     106ddd5 <check_input_run+0x10c5>
 106f255:	lea    0x3c(%rdi,%rax,1),%rsi
 106f25a:	add    %rax,%rdi
 106f25d:	and    $0xffffffffffffffc0,%rsi
 106f261:	cmp    %rdi,%rsi
 106f264:	jb     106ddd5 <check_input_run+0x10c5>
 106f26a:	mov    %rsi,%rdi
 106f26d:	sub    %rcx,%rdi
 106f270:	mov    %rdx,%r8
 106f273:	sub    %rdi,%r8
 106f276:	jb     106ddd5 <check_input_run+0x10c5>
 106f27c:	cmp    %r8,%rax
 106f27f:	ja     106ddd5 <check_input_run+0x10c5>
 106f285:	mov    0x38(%rsp),%r8
 106f28a:	add    %rax,%rdi
 106f28d:	mov    %rdi,0x8(%r8)
 106f291:	mov    %rsi,0x618(%rsp)
 106f299:	test   %rsi,%rsi
 106f29c:	je     106dde1 <check_input_run+0x10d1>
 106f2a2:	lea    0x3c(%rsi,%rax,1),%rdi
 106f2a7:	add    %rax,%rsi
 106f2aa:	and    $0xffffffffffffffc0,%rdi
 106f2ae:	cmp    %rsi,%rdi
 106f2b1:	jb     106dde1 <check_input_run+0x10d1>
 106f2b7:	mov    %rdi,%rsi
 106f2ba:	sub    %rcx,%rsi
 106f2bd:	mov    %rdx,%r8
 106f2c0:	sub    %rsi,%r8
 106f2c3:	jb     106dde1 <check_input_run+0x10d1>
 106f2c9:	cmp    %r8,%rax
 106f2cc:	ja     106dde1 <check_input_run+0x10d1>
 106f2d2:	mov    0x38(%rsp),%r8
 106f2d7:	add    %rax,%rsi
 106f2da:	mov    %rsi,0x8(%r8)
 106f2de:	mov    %rdi,0x620(%rsp)
 106f2e6:	test   %rdi,%rdi
 106f2e9:	je     106dded <check_input_run+0x10dd>
 106f2ef:	lea    0x3c(%rdi,%rax,1),%rsi
 106f2f4:	add    %rax,%rdi
 106f2f7:	and    $0xffffffffffffffc0,%rsi
 106f2fb:	cmp    %rdi,%rsi
 106f2fe:	jb     106dded <check_input_run+0x10dd>
 106f304:	mov    %rsi,%rdi
 106f307:	sub    %rcx,%rdi
 106f30a:	mov    %rdx,%r8
 106f30d:	sub    %rdi,%r8
 106f310:	jb     106dded <check_input_run+0x10dd>
 106f316:	cmp    %r8,%rax
 106f319:	ja     106dded <check_input_run+0x10dd>
 106f31f:	mov    0x38(%rsp),%r8
 106f324:	add    %rax,%rdi
 106f327:	mov    %rdi,0x8(%r8)
 106f32b:	mov    %rsi,0x628(%rsp)
 106f333:	test   %rsi,%rsi
 106f336:	je     106ddf9 <check_input_run+0x10e9>
 106f33c:	lea    0x3c(%rsi,%rax,1),%rdi
 106f341:	add    %rax,%rsi
 106f344:	and    $0xffffffffffffffc0,%rdi
 106f348:	cmp    %rsi,%rdi
 106f34b:	jb     106ddf9 <check_input_run+0x10e9>
 106f351:	mov    %rdi,%rsi
 106f354:	sub    %rcx,%rsi
 106f357:	mov    %rdx,%r8
 106f35a:	sub    %rsi,%r8
 106f35d:	jb     106ddf9 <check_input_run+0x10e9>
 106f363:	cmp    %r8,%rax
 106f366:	ja     106ddf9 <check_input_run+0x10e9>
 106f36c:	mov    0x38(%rsp),%r8
 106f371:	add    %rax,%rsi
 106f374:	mov    %rsi,0x8(%r8)
 106f378:	mov    %rdi,0x638(%rsp)
 106f380:	test   %rdi,%rdi
 106f383:	je     106de05 <check_input_run+0x10f5>
 106f389:	lea    0x3c(%rdi,%rax,1),%rsi
 106f38e:	add    %rax,%rdi
 106f391:	and    $0xffffffffffffffc0,%rsi
 106f395:	cmp    %rdi,%rsi
 106f398:	jb     106de05 <check_input_run+0x10f5>
 106f39e:	mov    %rsi,%rdi
 106f3a1:	sub    %rcx,%rdi
 106f3a4:	mov    %rdx,%r8
 106f3a7:	sub    %rdi,%r8
 106f3aa:	jb     106de05 <check_input_run+0x10f5>
 106f3b0:	cmp    %r8,%rax
 106f3b3:	ja     106de05 <check_input_run+0x10f5>
 106f3b9:	mov    0x38(%rsp),%r8
 106f3be:	add    %rax,%rdi
 106f3c1:	mov    %rdi,0x8(%r8)
 106f3c5:	mov    %rsi,0x640(%rsp)
 106f3cd:	test   %rsi,%rsi
 106f3d0:	je     106de11 <check_input_run+0x1101>
 106f3d6:	lea    0x3c(%rsi,%rax,1),%rdi
 106f3db:	add    %rax,%rsi
 106f3de:	and    $0xffffffffffffffc0,%rdi
 106f3e2:	cmp    %rsi,%rdi
 106f3e5:	jb     106de11 <check_input_run+0x1101>
 106f3eb:	mov    %rdi,%rsi
 106f3ee:	sub    %rcx,%rsi
 106f3f1:	mov    %rdx,%r8
 106f3f4:	sub    %rsi,%r8
 106f3f7:	jb     106de11 <check_input_run+0x1101>
 106f3fd:	cmp    %r8,%rax
 106f400:	ja     106de11 <check_input_run+0x1101>
 106f406:	mov    0x38(%rsp),%r8
 106f40b:	add    %rax,%rsi
 106f40e:	mov    %rsi,0x8(%r8)
 106f412:	mov    %rdi,0x648(%rsp)
 106f41a:	test   %rdi,%rdi
 106f41d:	je     107c956 <check_input_run+0xfc46>
 106f423:	lea    (%rdi,%rax,1),%r8
 106f427:	lea    0x3c(%rdi,%rax,1),%rax
 106f42c:	mov    $0x1,%sil
 106f42f:	and    $0xffffffffffffffc0,%rax
 106f433:	cmp    %r8,%rax
 106f436:	jae    107c95c <check_input_run+0xfc4c>
 106f43c:	xor    %ecx,%ecx
 106f43e:	jmp    107c98d <check_input_run+0xfc7d>
 106f443:	add    %rcx,%rdx
 106f446:	mov    %rdx,0x8(%r8)
 106f44a:	mov    0x18(%rsp),%rdx
 106f44f:	mov    %rax,0x338(%rdx)
 106f456:	test   %rax,%rax
 106f459:	je     106f47c <check_input_run+0x276c>
 106f45b:	mov    0x38(%rsp),%rcx
 106f460:	mov    (%rcx),%rax
 106f463:	mov    0x8(%rcx),%rcx
 106f467:	lea    0xf(%rcx,%rax,1),%rdx
 106f46c:	add    %rax,%rcx
 106f46f:	and    $0xfffffffffffffff0,%rdx
 106f473:	cmp    %rcx,%rdx
 106f476:	jae    1070d01 <check_input_run+0x3ff1>
 106f47c:	movq   $0x0,0x458(%rsp)
 106f488:	movq   $0x0,0x590(%rsp)
 106f494:	movq   $0x0,0xc8(%rsp)
 106f4a0:	xor    %edi,%edi
 106f4a2:	mov    %rdi,0x470(%rsp)
 106f4aa:	mov    %rdi,0x88(%rsp)
 106f4b2:	mov    0x270(%r15),%rax
 106f4b9:	mov    %rax,0x50(%rsp)
 106f4be:	xor    %eax,%eax
 106f4c0:	jmp    106f4ef <check_input_run+0x27df>
 106f4c2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 106f4d0:	mov    0x70(%rsp),%rax
 106f4d5:	mov    0x20(%rsp),%r12
 106f4da:	mov    %r14d,0x280(%rsp,%rax,4)
 106f4e2:	inc    %rax
 106f4e5:	cmp    $0x5,%rax
 106f4e9:	je     106f766 <check_input_run+0x2a56>
 106f4ef:	lea    0xbd0b6a(%rip),%rcx        # 1c40060 <parse_predeclared_typedefs+0x30>
 106f4f6:	mov    %rax,0x70(%rsp)
 106f4fb:	mov    (%rcx,%rax,8),%rbx
 106f4ff:	mov    %rbx,%rdi
 106f502:	vzeroupper
 106f505:	call   787bf0 <strlen@plt>
 106f50a:	kxnorq %k0,%k0,%k1
 106f50f:	mov    %rax,%rdx
 106f512:	mov    %edx,%r14d
 106f515:	cmp    $0x3f,%edx
 106f518:	ja     106f52b <check_input_run+0x281b>
 106f51a:	mov    $0xffffffffffffffff,%rax
 106f521:	bzhi   %r14,%rax,%rax
 106f526:	kmovq  %rax,%k1
 106f52b:	vmovdqu8 (%rbx),%zmm0{%k1}{z}
 106f531:	vmovd  %r14d,%xmm1
 106f536:	vpxor  %xmm2,%xmm2,%xmm2
 106f53a:	mov    %rdx,0x28(%rsp)
 106f53f:	vpternlogq $0x96,-0xbd214a(%rip),%zmm0,%zmm1        # 49d400 <cbuiltin_test_generated.edges+0x35c0>
 106f54a:	vaesenc %zmm2,%zmm1,%zmm0
 106f550:	vaesenc %zmm2,%zmm0,%zmm0
 106f556:	vextracti64x4 $0x1,%zmm0,%ymm1
 106f55d:	vpxorq %zmm0,%zmm1,%zmm0
 106f563:	vextracti128 $0x1,%ymm0,%xmm1
 106f569:	vpxor  %xmm0,%xmm1,%xmm0
 106f56d:	cmp    $0x41,%edx
 106f570:	jb     106f585 <check_input_run+0x2875>
 106f572:	mov    %rbx,%rdi
 106f575:	mov    %r14,%rsi
 106f578:	vzeroupper
 106f57b:	call   101bc00 <intern_chain_chunks>
 106f580:	mov    0x28(%rsp),%rdx
 106f585:	vpxor  %xmm1,%xmm1,%xmm1
 106f589:	vaesenc %xmm1,%xmm0,%xmm0
 106f58e:	cmp    $0x10,%edx
 106f591:	mov    $0x10,%eax
 106f596:	mov    $0xffff,%ecx
 106f59b:	cmovb  %edx,%eax
 106f59e:	bzhi   %eax,%ecx,%eax
 106f5a3:	kmovd  %eax,%k1
 106f5a7:	mov    0x50(%rsp),%rax
 106f5ac:	vmovq  %xmm0,%r12
 106f5b1:	vmovdqu8 (%rbx),%xmm0{%k1}{z}
 106f5b7:	mov    0x8(%rax),%rdi
 106f5bb:	mov    (%rax),%rsi
 106f5be:	vshufi64x2 $0x0,%zmm0,%zmm0,%zmm0
 106f5c5:	and    %rdi,%r12
 106f5c8:	vmovdqu64 %zmm0,0x210(%rsp)
 106f5d3:	cmp    $0xc,%edx
 106f5d6:	jae    106f640 <check_input_run+0x2930>
 106f5d8:	xor    %r14d,%r14d
 106f5db:	jmp    106f5ff <check_input_run+0x28ef>
 106f5dd:	nopl   (%rax)
 106f5e0:	vptestnmd %zmm0,%zmm0,%k0
 106f5e6:	inc    %r12
 106f5e9:	kmovd  %k0,%ecx
 106f5ed:	and    %rdi,%r12
 106f5f0:	and    $0x8888,%ecx
 106f5f6:	or     %cx,%ax
 106f5f9:	jne    106f4d0 <check_input_run+0x27c0>
 106f5ff:	mov    %r12,%rcx
 106f602:	shl    $0x6,%rcx
 106f606:	vmovdqa64 (%rsi,%rcx,1),%zmm0
 106f60d:	vpcmpeqd 0x210(%rsp),%zmm0,%k0
 106f618:	kmovd  %k0,%eax
 106f61c:	and    $0x7777,%eax
 106f621:	add    $0x1111,%eax
 106f626:	and    $0x8888,%ax
 106f62a:	je     106f5e0 <check_input_run+0x28d0>
 106f62c:	add    %rsi,%rcx
 106f62f:	xor    %edx,%edx
 106f631:	tzcnt  %eax,%edx
 106f635:	mov    (%rcx,%rdx,4),%r14d
 106f639:	jmp    106f5e0 <check_input_run+0x28d0>
 106f63b:	nopl   0x0(%rax,%rax,1)
 106f640:	mov    %r14,0x90(%rsp)
 106f648:	xor    %r14d,%r14d
 106f64b:	mov    %rbx,0x98(%rsp)
 106f653:	mov    %rsi,0x130(%rsp)
 106f65b:	mov    %rdi,0xd0(%rsp)
 106f663:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 106f670:	mov    %r12,%r13
 106f673:	shl    $0x6,%r13
 106f677:	vmovdqa64 (%rsi,%r13,1),%zmm0
 106f67e:	vpcmpeqd 0x210(%rsp),%zmm0,%k0
 106f689:	vmovdqu64 %zmm0,0x1b0(%rsp)
 106f694:	kmovd  %k0,%eax
 106f698:	and    $0x7777,%eax
 106f69d:	add    $0x1111,%eax
 106f6a2:	and    $0x8888,%ax
 106f6a6:	je     106f720 <check_input_run+0x2a10>
 106f6a8:	mov    0x50(%rsp),%rcx
 106f6ad:	add    %rsi,%r13
 106f6b0:	movzwl %ax,%ebx
 106f6b3:	mov    0x10(%rcx),%rbp
 106f6b7:	jmp    106f6cd <check_input_run+0x29bd>
 106f6b9:	nopl   0x0(%rax)
 106f6c0:	xor    %eax,%eax
 106f6c2:	test   %al,%al
 106f6c4:	jne    106f722 <check_input_run+0x2a12>
 106f6c6:	blsr   %ebx,%ebx
 106f6cb:	je     106f722 <check_input_run+0x2a12>
 106f6cd:	xor    %eax,%eax
 106f6cf:	tzcnt  %ebx,%eax
 106f6d3:	mov    0x0(%r13,%rax,4),%r15d
 106f6d8:	cmp    %edx,0x4(%rbp,%r15,8)
 106f6dd:	jne    106f6c0 <check_input_run+0x29b0>
 106f6df:	mov    0x50(%rsp),%rax
 106f6e4:	mov    0x0(%rbp,%r15,8),%edi
 106f6e9:	mov    0x98(%rsp),%rsi
 106f6f1:	mov    0x90(%rsp),%rdx
 106f6f9:	add    0x40(%rax),%rdi
 106f6fd:	vzeroupper
 106f700:	call   7880b0 <bcmp@plt>
 106f705:	mov    0x28(%rsp),%rdx
 106f70a:	test   %eax,%eax
 106f70c:	sete   %al
 106f70f:	cmove  %r15d,%r14d
 106f713:	test   %al,%al
 106f715:	je     106f6c6 <check_input_run+0x29b6>
 106f717:	jmp    106f722 <check_input_run+0x2a12>
 106f719:	nopl   0x0(%rax)
 106f720:	xor    %eax,%eax
 106f722:	vmovdqu64 0x1b0(%rsp),%zmm0
 106f72d:	vptestnmd %zmm0,%zmm0,%k0
 106f733:	kmovd  %k0,%ecx
 106f737:	test   $0x8888,%ecx
 106f73d:	jne    106f4d0 <check_input_run+0x27c0>
 106f743:	mov    0xd0(%rsp),%rdi
 106f74b:	mov    0x130(%rsp),%rsi
 106f753:	inc    %r12
 106f756:	and    %rdi,%r12
 106f759:	test   %al,%al
 106f75b:	je     106f670 <check_input_run+0x2960>
 106f761:	jmp    106f4d0 <check_input_run+0x27c0>
 106f766:	cmpq   $0x0,0x88(%rsp)
 106f76f:	mov    0xc8(%rsp),%rcx
 106f777:	setne  %al
 106f77a:	and    %al,%cl
 106f77c:	cmpl   $0x0,0xf0(%rsp)
 106f784:	mov    %rcx,0xc8(%rsp)
 106f78c:	je     106f7c6 <check_input_run+0x2ab6>
 106f78e:	vmovdqa 0x280(%rsp),%xmm0
 106f797:	mov    0x78(%rsp),%r8
 106f79c:	mov    0x18(%r12),%rsi
 106f7a1:	mov    0x4e4(%rsp),%eax
 106f7a8:	mov    0x290(%rsp),%ecx
 106f7af:	mov    %r8d,%edx
 106f7b2:	lea    -0x1(%r8),%rdi
 106f7b6:	and    $0x3,%edx
 106f7b9:	cmp    $0x3,%rdi
 106f7bd:	jae    106f7d2 <check_input_run+0x2ac2>
 106f7bf:	xor    %edi,%edi
 106f7c1:	jmp    106f8e2 <check_input_run+0x2bd2>
 106f7c6:	mov    0x4e4(%rsp),%eax
 106f7cd:	jmp    106f933 <check_input_run+0x2c23>
 106f7d2:	and    $0xfffffffc,%r8d
 106f7d6:	xor    %edi,%edi
 106f7d8:	jmp    106f7ed <check_input_run+0x2add>
 106f7da:	nopw   0x0(%rax,%rax,1)
 106f7e0:	add    $0x4,%rdi
 106f7e4:	cmp    %rdi,%r8
 106f7e7:	je     106f8dd <check_input_run+0x2bcd>
 106f7ed:	mov    (%rsi,%rdi,4),%r9d
 106f7f1:	test   %r9d,%r9d
 106f7f4:	je     106f826 <check_input_run+0x2b16>
 106f7f6:	vpbroadcastd %r9d,%xmm1
 106f7fc:	xor    %r10d,%r10d
 106f7ff:	cmp    %ecx,%r9d
 106f802:	vpcmpeqd %xmm0,%xmm1,%k0
 106f808:	sete   %r10b
 106f80c:	kmovb  %k0,%r9d
 106f810:	add    %eax,%r10d
 106f813:	popcnt %r9d,%r9d
 106f818:	add    %r9d,%r10d
 106f81b:	mov    %r10d,%eax
 106f81e:	mov    %r10d,0x4e4(%rsp)
 106f826:	mov    0x4(%rsi,%rdi,4),%r9d
 106f82b:	test   %r9d,%r9d
 106f82e:	je     106f860 <check_input_run+0x2b50>
 106f830:	vpbroadcastd %r9d,%xmm1
 106f836:	xor    %r10d,%r10d
 106f839:	cmp    %ecx,%r9d
 106f83c:	vpcmpeqd %xmm0,%xmm1,%k0
 106f842:	sete   %r10b
 106f846:	kmovb  %k0,%r9d
 106f84a:	add    %eax,%r10d
 106f84d:	popcnt %r9d,%r9d
 106f852:	add    %r9d,%r10d
 106f855:	mov    %r10d,%eax
 106f858:	mov    %r10d,0x4e4(%rsp)
 106f860:	mov    0x8(%rsi,%rdi,4),%r9d
 106f865:	test   %r9d,%r9d
 106f868:	je     106f89a <check_input_run+0x2b8a>
 106f86a:	vpbroadcastd %r9d,%xmm1
 106f870:	xor    %r10d,%r10d
 106f873:	cmp    %ecx,%r9d
 106f876:	vpcmpeqd %xmm0,%xmm1,%k0
 106f87c:	sete   %r10b
 106f880:	kmovb  %k0,%r9d
 106f884:	add    %eax,%r10d
 106f887:	popcnt %r9d,%r9d
 106f88c:	add    %r9d,%r10d
 106f88f:	mov    %r10d,%eax
 106f892:	mov    %r10d,0x4e4(%rsp)
 106f89a:	mov    0xc(%rsi,%rdi,4),%r9d
 106f89f:	test   %r9d,%r9d
 106f8a2:	je     106f7e0 <check_input_run+0x2ad0>
 106f8a8:	vpbroadcastd %r9d,%xmm1
 106f8ae:	xor    %r10d,%r10d
 106f8b1:	cmp    %ecx,%r9d
 106f8b4:	vpcmpeqd %xmm0,%xmm1,%k0
 106f8ba:	sete   %r10b
 106f8be:	kmovb  %k0,%r9d
 106f8c2:	add    %eax,%r10d
 106f8c5:	popcnt %r9d,%r9d
 106f8ca:	add    %r9d,%r10d
 106f8cd:	mov    %r10d,%eax
 106f8d0:	mov    %r10d,0x4e4(%rsp)
 106f8d8:	jmp    106f7e0 <check_input_run+0x2ad0>
 106f8dd:	test   %rdx,%rdx
 106f8e0:	je     106f933 <check_input_run+0x2c23>
 106f8e2:	lea    (%rsi,%rdi,4),%rsi
 106f8e6:	xor    %edi,%edi
 106f8e8:	jmp    106f8f8 <check_input_run+0x2be8>
 106f8ea:	nopw   0x0(%rax,%rax,1)
 106f8f0:	inc    %rdi
 106f8f3:	cmp    %rdi,%rdx
 106f8f6:	je     106f933 <check_input_run+0x2c23>
 106f8f8:	mov    (%rsi,%rdi,4),%r8d
 106f8fc:	test   %r8d,%r8d
 106f8ff:	je     106f8f0 <check_input_run+0x2be0>
 106f901:	vpbroadcastd %r8d,%xmm1
 106f907:	xor    %r9d,%r9d
 106f90a:	cmp    %ecx,%r8d
 106f90d:	vpcmpeqd %xmm0,%xmm1,%k0
 106f913:	sete   %r9b
 106f917:	kmovb  %k0,%r8d
 106f91b:	add    %eax,%r9d
 106f91e:	popcnt %r8d,%r8d
 106f923:	add    %r8d,%r9d
 106f926:	mov    %r9d,%eax
 106f929:	mov    %r9d,0x4e4(%rsp)
 106f931:	jmp    106f8f0 <check_input_run+0x2be0>
 106f933:	mov    0xc8(%rsp),%rdx
 106f93b:	test   %eax,%eax
 106f93d:	setne  %cl
 106f940:	test   %cl,%dl
 106f942:	je     106f96e <check_input_run+0x2c5e>
 106f944:	mov    0x38(%rsp),%r8
 106f949:	mov    %eax,%ecx
 106f94b:	mov    (%r8),%rdx
 106f94e:	mov    0x8(%r8),%rdi
 106f952:	lea    0x3(%rdi,%rdx,1),%rsi
 106f957:	add    %rdx,%rdi
 106f95a:	and    $0xfffffffffffffffc,%rsi
 106f95e:	cmp    %rdi,%rsi
 106f961:	jae    106fbb5 <check_input_run+0x2ea5>
 106f967:	xor    %edx,%edx
 106f969:	jmp    106fbde <check_input_run+0x2ece>
 106f96e:	mov    %rdx,%rcx
 106f971:	test   %cl,%cl
 106f973:	je     106fc1d <check_input_run+0x2f0d>
 106f979:	mov    0x38(%rsp),%rcx
 106f97e:	mov    (%rcx),%rax
 106f981:	mov    0x8(%rcx),%rcx
 106f985:	lea    0x3f(%rcx,%rax,1),%rdx
 106f98a:	add    %rax,%rcx
 106f98d:	and    $0xffffffffffffffc0,%rdx
 106f991:	cmp    %rcx,%rdx
 106f994:	jb     106fc1d <check_input_run+0x2f0d>
 106f99a:	mov    0x38(%rsp),%rcx
 106f99f:	mov    %rdx,%rsi
 106f9a2:	sub    %rax,%rsi
 106f9a5:	mov    0x10(%rcx),%rcx
 106f9a9:	mov    %rcx,%r8
 106f9ac:	sub    %rsi,%r8
 106f9af:	jb     106fc1d <check_input_run+0x2f0d>
 106f9b5:	mov    0x50(%rsp),%rdi
 106f9ba:	mov    0x68(%rdi),%edi
 106f9bd:	shl    $0x2,%rdi
 106f9c1:	cmp    %r8,%rdi
 106f9c4:	ja     106fc1d <check_input_run+0x2f0d>
 106f9ca:	mov    0x38(%rsp),%r8
 106f9cf:	add    %rdi,%rsi
 106f9d2:	mov    %rsi,0x8(%r8)
 106f9d6:	mov    %rdx,0x5b8(%rsp)
 106f9de:	test   %rdx,%rdx
 106f9e1:	je     106fc29 <check_input_run+0x2f19>
 106f9e7:	lea    (%rdx,%rdi,1),%rsi
 106f9eb:	lea    0x3c(%rdx,%rdi,1),%rdx
 106f9f0:	and    $0xffffffffffffffc0,%rdx
 106f9f4:	cmp    %rsi,%rdx
 106f9f7:	jb     106fc29 <check_input_run+0x2f19>
 106f9fd:	mov    %rdx,%rsi
 106fa00:	sub    %rax,%rsi
 106fa03:	mov    %rcx,%r8
 106fa06:	sub    %rsi,%r8
 106fa09:	jb     106fc29 <check_input_run+0x2f19>
 106fa0f:	mov    0x58(%rsp),%rdi
 106fa14:	mov    0x270(%rdi),%rdi
 106fa1b:	mov    0x68(%rdi),%edi
 106fa1e:	shl    $0x2,%rdi
 106fa22:	cmp    %r8,%rdi
 106fa25:	ja     106fc29 <check_input_run+0x2f19>
 106fa2b:	mov    0x38(%rsp),%r8
 106fa30:	add    %rdi,%rsi
 106fa33:	mov    %rsi,0x8(%r8)
 106fa37:	mov    %rdx,0x5c0(%rsp)
 106fa3f:	test   %rdx,%rdx
 106fa42:	je     106fc35 <check_input_run+0x2f25>
 106fa48:	lea    (%rdx,%rdi,1),%rsi
 106fa4c:	lea    0x3c(%rdx,%rdi,1),%rdx
 106fa51:	and    $0xffffffffffffffc0,%rdx
 106fa55:	cmp    %rsi,%rdx
 106fa58:	jb     106fc35 <check_input_run+0x2f25>
 106fa5e:	mov    %rdx,%rdi
 106fa61:	sub    %rax,%rdi
 106fa64:	mov    %rcx,%r8
 106fa67:	sub    %rdi,%r8
 106fa6a:	jb     106fc35 <check_input_run+0x2f25>
 106fa70:	mov    0x58(%rsp),%rsi
 106fa75:	mov    0x270(%rsi),%rsi
 106fa7c:	mov    0x68(%rsi),%esi
 106fa7f:	shl    $0x2,%rsi
 106fa83:	cmp    %r8,%rsi
 106fa86:	ja     106fc35 <check_input_run+0x2f25>
 106fa8c:	mov    0x38(%rsp),%r8
 106fa91:	add    %rsi,%rdi
 106fa94:	mov    %rdi,0x8(%r8)
 106fa98:	mov    %rdx,0x5c8(%rsp)
 106faa0:	test   %rdx,%rdx
 106faa3:	je     106fc41 <check_input_run+0x2f31>
 106faa9:	mov    0xa8(%rsp),%rdi
 106fab1:	add    %rsi,%rdx
 106fab4:	mov    %rcx,%r8
 106fab7:	mov    %rdx,%rsi
 106faba:	sub    %rax,%rsi
 106fabd:	mov    0xa4(%rdi),%edi
 106fac3:	shl    $0x2,%rdi
 106fac7:	sub    %rsi,%r8
 106faca:	setb   %r9b
 106face:	cmp    %r8,%rdi
 106fad1:	seta   %r8b
 106fad5:	or     %r9b,%r8b
 106fad8:	cmp    $0x1,%r8b
 106fadc:	je     106fc41 <check_input_run+0x2f31>
 106fae2:	mov    0x38(%rsp),%r8
 106fae7:	add    %rdi,%rsi
 106faea:	mov    %rsi,0x8(%r8)
 106faee:	mov    %rdx,0x5f0(%rsp)
 106faf6:	test   %rdx,%rdx
 106faf9:	je     106fc4d <check_input_run+0x2f3d>
 106faff:	mov    0xa8(%rsp),%rsi
 106fb07:	add    %rdi,%rdx
 106fb0a:	mov    %rcx,%r8
 106fb0d:	mov    %rdx,%rdi
 106fb10:	sub    %rax,%rdi
 106fb13:	sub    %rdi,%r8
 106fb16:	setb   %r9b
 106fb1a:	mov    0xa4(%rsi),%esi
 106fb20:	cmp    %rsi,%r8
 106fb23:	setb   %r8b
 106fb27:	or     %r9b,%r8b
 106fb2a:	cmp    $0x1,%r8b
 106fb2e:	je     106fc4d <check_input_run+0x2f3d>
 106fb34:	mov    0x38(%rsp),%r8
 106fb39:	add    %rsi,%rdi
 106fb3c:	test   %rdx,%rdx
 106fb3f:	setne  %bl
 106fb42:	mov    %rdi,0x8(%r8)
 106fb46:	mov    0xe8(%rsp),%rdi
 106fb4e:	mov    %rdx,0x5f8(%rsp)
 106fb56:	and    %bl,%dil
 106fb59:	cmp    $0x1,%dil
 106fb5d:	jne    106fc5b <check_input_run+0x2f4b>
 106fb63:	lea    0x3(%rdx,%rsi,1),%rdi
 106fb68:	lea    (%rdx,%rsi,1),%r8
 106fb6c:	and    $0xfffffffffffffffc,%rdi
 106fb70:	cmp    %r8,%rdi
 106fb73:	jb     106fba4 <check_input_run+0x2e94>
 106fb75:	mov    0xa8(%rsp),%rdx
 106fb7d:	mov    %rdi,%rsi
 106fb80:	sub    %rax,%rsi
 106fb83:	mov    0xa4(%rdx),%edx
 106fb89:	shl    $0x2,%rdx
 106fb8d:	sub    %rsi,%rcx
 106fb90:	setb   %al
 106fb93:	cmp    %rcx,%rdx
 106fb96:	seta   %cl
 106fb99:	or     %al,%cl
 106fb9b:	cmp    $0x1,%cl
 106fb9e:	jne    1079970 <check_input_run+0xcc60>
 106fba4:	movq   $0x0,0x600(%rsp)
 106fbb0:	jmp    106fc59 <check_input_run+0x2f49>
 106fbb5:	mov    0x10(%r8),%r9
 106fbb9:	mov    %rsi,%rdi
 106fbbc:	sub    %rdx,%rdi
 106fbbf:	xor    %edx,%edx
 106fbc1:	sub    %rdi,%r9
 106fbc4:	jb     106fbde <check_input_run+0x2ece>
 106fbc6:	imul   $0x2c,%rcx,%r8
 106fbca:	cmp    %r9,%r8
 106fbcd:	ja     106fbde <check_input_run+0x2ece>
 106fbcf:	mov    0x38(%rsp),%rdx
 106fbd4:	add    %r8,%rdi
 106fbd7:	mov    %rdi,0x8(%rdx)
 106fbdb:	mov    %rsi,%rdx
 106fbde:	mov    0x10(%rsp),%rsi
 106fbe3:	mov    %rdx,0x4c8(%rsp)
 106fbeb:	mov    (%rsi),%r8
 106fbee:	mov    0x8(%rsi),%rdi
 106fbf2:	lea    0x3(%rdi,%r8,1),%rsi
 106fbf7:	add    %r8,%rdi
 106fbfa:	and    $0xfffffffffffffffc,%rsi
 106fbfe:	cmp    %rdi,%rsi
 106fc01:	jae    106fe3e <check_input_run+0x312e>
 106fc07:	mov    0x18(%rsp),%rcx
 106fc0c:	movq   $0x0,0xc0(%rcx)
 106fc17:	mov    %eax,0xcc(%rcx)
 106fc1d:	movq   $0x0,0x5b8(%rsp)
 106fc29:	movq   $0x0,0x5c0(%rsp)
 106fc35:	movq   $0x0,0x5c8(%rsp)
 106fc41:	movq   $0x0,0x5f0(%rsp)
 106fc4d:	movq   $0x0,0x5f8(%rsp)
 106fc59:	xor    %ebx,%ebx
 106fc5b:	mov    0x58(%rsp),%rax
 106fc60:	mov    0x38(%rsp),%rsi
 106fc65:	lea    0x2d0(%rsp),%rdi
 106fc6d:	mov    0x270(%rax),%rax
 106fc74:	mov    0x68(%rax),%edx
 106fc77:	mov    0xf0(%rsp),%rax
 106fc7f:	lea    0x1(,%rax,4),%ecx
 106fc86:	vzeroupper
 106fc89:	call   106b150 <c_bindings_initialize>
 106fc8e:	test   %bl,%bl
 106fc90:	je     106fe26 <check_input_run+0x3116>
 106fc96:	test   %al,%al
 106fc98:	je     106fe26 <check_input_run+0x3116>
 106fc9e:	mov    0x78(%rsp),%r14
 106fca3:	mov    0x340(%rsp),%rdi
 106fcab:	xor    %esi,%esi
 106fcad:	lea    0x4(,%r14,4),%rbx
 106fcb5:	lea    0x1(%r14),%rbp
 106fcb9:	mov    %rbx,%rdx
 106fcbc:	call   788120 <memset@plt>
 106fcc1:	mov    0x348(%rsp),%rdi
 106fcc9:	xor    %esi,%esi
 106fccb:	mov    %rbx,%rdx
 106fcce:	call   788120 <memset@plt>
 106fcd3:	mov    0x350(%rsp),%rdi
 106fcdb:	lea    0x8(,%r14,8),%r15
 106fce3:	xor    %esi,%esi
 106fce5:	mov    %r15,%rdx
 106fce8:	call   788120 <memset@plt>
 106fced:	mov    0x358(%rsp),%rdi
 106fcf5:	xor    %esi,%esi
 106fcf7:	mov    %r15,%rdx
 106fcfa:	call   788120 <memset@plt>
 106fcff:	mov    0x370(%rsp),%rdi
 106fd07:	mov    $0xff,%esi
 106fd0c:	mov    %rbx,%rdx
 106fd0f:	call   788120 <memset@plt>
 106fd14:	mov    0x398(%rsp),%rdi
 106fd1c:	xor    %esi,%esi
 106fd1e:	mov    %rbx,%rdx
 106fd21:	call   788120 <memset@plt>
 106fd26:	mov    0x3a0(%rsp),%rdi
 106fd2e:	xor    %esi,%esi
 106fd30:	mov    %rbp,%rdx
 106fd33:	call   788120 <memset@plt>
 106fd38:	mov    0x530(%rsp),%rdi
 106fd40:	xor    %esi,%esi
 106fd42:	mov    %rbx,%rdx
 106fd45:	call   788120 <memset@plt>
 106fd4a:	mov    0x538(%rsp),%rdi
 106fd52:	xor    %esi,%esi
 106fd54:	mov    %rbx,%rdx
 106fd57:	call   788120 <memset@plt>
 106fd5c:	mov    0x540(%rsp),%rdi
 106fd64:	xor    %esi,%esi
 106fd66:	mov    %rbp,%rdx
 106fd69:	call   788120 <memset@plt>
 106fd6e:	mov    0x548(%rsp),%rdi
 106fd76:	xor    %esi,%esi
 106fd78:	mov    %rbp,%rdx
 106fd7b:	call   788120 <memset@plt>
 106fd80:	mov    0x510(%rsp),%rdi
 106fd88:	xor    %esi,%esi
 106fd8a:	mov    %rbp,%rdx
 106fd8d:	call   788120 <memset@plt>
 106fd92:	mov    0x520(%rsp),%rdi
 106fd9a:	xor    %esi,%esi
 106fd9c:	mov    %rbp,%rdx
 106fd9f:	call   788120 <memset@plt>
 106fda4:	mov    0x528(%rsp),%rdi
 106fdac:	xor    %esi,%esi
 106fdae:	mov    %rbp,%rdx
 106fdb1:	call   788120 <memset@plt>
 106fdb6:	mov    0x18(%rsp),%r14
 106fdbb:	mov    0x100(%rsp),%rdx
 106fdc3:	xor    %esi,%esi
 106fdc5:	mov    0x50(%r14),%rdi
 106fdc9:	call   788120 <memset@plt>
 106fdce:	mov    0x2c8(%r14),%rdi
 106fdd5:	xor    %esi,%esi
 106fdd7:	mov    %rbp,%rdx
 106fdda:	call   788120 <memset@plt>
 106fddf:	mov    0x2d0(%r14),%rdi
 106fde6:	xor    %esi,%esi
 106fde8:	mov    %rbp,%rdx
 106fdeb:	call   788120 <memset@plt>
 106fdf0:	mov    0x1f0(%r14),%rsi
 106fdf7:	mov    0x3d8(%rsp),%rdi
 106fdff:	test   %rsi,%rsi
 106fe02:	sete   %al
 106fe05:	cmpq   $0x0,0x860(%rsp)
 106fe0e:	setne  %cl
 106fe11:	or     %al,%cl
 106fe13:	jne    106fead <check_input_run+0x319d>
 106fe19:	mov    %rbp,%rdx
 106fe1c:	call   788240 <memcpy@plt>
 106fe21:	jmp    106feb7 <check_input_run+0x31a7>
 106fe26:	mov    0x18(%rsp),%rax
 106fe2b:	movb   $0x1,0x3bd(%rax)
 106fe32:	xor    %eax,%eax
 106fe34:	mov    0x38(%rsp),%rcx
 106fe39:	jmp    1075ca6 <check_input_run+0x8f96>
 106fe3e:	mov    %rsi,%rdi
 106fe41:	sub    %r8,%rdi
 106fe44:	mov    0x10(%rsp),%r8
 106fe49:	mov    0x10(%r8),%r8
 106fe4d:	sub    %rdi,%r8
 106fe50:	jb     106fc07 <check_input_run+0x2ef7>
 106fe56:	shl    $0x2,%rcx
 106fe5a:	lea    (%rcx,%rcx,8),%rcx
 106fe5e:	cmp    %r8,%rcx
 106fe61:	ja     106fc07 <check_input_run+0x2ef7>
 106fe67:	mov    0x10(%rsp),%r8
 106fe6c:	add    %rcx,%rdi
 106fe6f:	mov    %rdi,0x8(%r8)
 106fe73:	mov    0x18(%rsp),%rdi
 106fe78:	mov    %rsi,0xc0(%rdi)
 106fe7f:	mov    %eax,0xcc(%rdi)
 106fe85:	test   %rdx,%rdx
 106fe88:	je     106fc1d <check_input_run+0x2f0d>
 106fe8e:	test   %rsi,%rsi
 106fe91:	je     106fc1d <check_input_run+0x2f0d>
 106fe97:	mov    0x58(%rsp),%rax
 106fe9c:	mov    0x270(%rax),%rax
 106fea3:	mov    %rax,0x50(%rsp)
 106fea8:	jmp    106f979 <check_input_run+0x2c69>
 106fead:	xor    %esi,%esi
 106feaf:	mov    %rbp,%rdx
 106feb2:	call   788120 <memset@plt>
 106feb7:	mov    0x3a8(%rsp),%rdi
 106febf:	xor    %r14d,%r14d
 106fec2:	xor    %esi,%esi
 106fec4:	mov    %rbp,%rdx
 106fec7:	call   788120 <memset@plt>
 106fecc:	mov    0x3b0(%rsp),%rdi
 106fed4:	xor    %esi,%esi
 106fed6:	mov    %rbp,%rdx
 106fed9:	call   788120 <memset@plt>
 106fede:	mov    0x118(%rsp),%rax
 106fee6:	xor    %esi,%esi
 106fee8:	mov    %rbp,%rdx
 106feeb:	mov    (%rax),%rdi
 106feee:	call   788120 <memset@plt>
 106fef3:	mov    0x3b8(%rsp),%rdi
 106fefb:	xor    %esi,%esi
 106fefd:	mov    %rbp,%rdx
 106ff00:	call   788120 <memset@plt>
 106ff05:	mov    0x3c0(%rsp),%rdi
 106ff0d:	xor    %esi,%esi
 106ff0f:	mov    %rbp,%rdx
 106ff12:	call   788120 <memset@plt>
 106ff17:	mov    0x60(%rsp),%rax
 106ff1c:	xor    %esi,%esi
 106ff1e:	mov    %rbp,%rdx
 106ff21:	mov    (%rax),%rdi
 106ff24:	call   788120 <memset@plt>
 106ff29:	mov    0xc0(%rsp),%rax
 106ff31:	xor    %esi,%esi
 106ff33:	mov    %rbp,%rdx
 106ff36:	mov    (%rax),%rdi
 106ff39:	call   788120 <memset@plt>
 106ff3e:	mov    0xa0(%rsp),%rax
 106ff46:	xor    %esi,%esi
 106ff48:	mov    %rbp,%rdx
 106ff4b:	mov    (%rax),%rdi
 106ff4e:	call   788120 <memset@plt>
 106ff53:	mov    0x110(%rsp),%rax
 106ff5b:	xor    %esi,%esi
 106ff5d:	mov    %rbp,%rdx
 106ff60:	mov    (%rax),%rdi
 106ff63:	call   788120 <memset@plt>
 106ff68:	mov    0x128(%rsp),%rax
 106ff70:	xor    %esi,%esi
 106ff72:	mov    %rbx,%rdx
 106ff75:	mov    (%rax),%rdi
 106ff78:	call   788120 <memset@plt>
 106ff7d:	mov    0x120(%rsp),%rax
 106ff85:	xor    %esi,%esi
 106ff87:	mov    %rbx,%rdx
 106ff8a:	mov    (%rax),%rdi
 106ff8d:	call   788120 <memset@plt>
 106ff92:	mov    0x48(%rsp),%rax
 106ff97:	xor    %esi,%esi
 106ff99:	mov    %r15,%rdx
 106ff9c:	mov    (%rax),%rdi
 106ff9f:	call   788120 <memset@plt>
 106ffa4:	mov    0x550(%rsp),%rdi
 106ffac:	xor    %esi,%esi
 106ffae:	mov    %r15,%rdx
 106ffb1:	call   788120 <memset@plt>
 106ffb6:	mov    0x3c8(%rsp),%rdi
 106ffbe:	xor    %esi,%esi
 106ffc0:	mov    %rbp,%rdx
 106ffc3:	call   788120 <memset@plt>
 106ffc8:	mov    0x3d0(%rsp),%rdi
 106ffd0:	xor    %esi,%esi
 106ffd2:	mov    %rbx,%rdx
 106ffd5:	call   788120 <memset@plt>
 106ffda:	mov    0x58(%rsp),%r13
 106ffdf:	mov    0x590(%rsp),%rdi
 106ffe7:	xor    %esi,%esi
 106ffe9:	mov    0x270(%r13),%rax
 106fff0:	mov    0x68(%rax),%edx
 106fff3:	shl    $0x2,%rdx
 106fff7:	call   788120 <memset@plt>
 106fffc:	mov    0x5a0(%rsp),%rdi
 1070004:	xor    %esi,%esi
 1070006:	mov    %rbp,%rdx
 1070009:	call   788120 <memset@plt>
 107000e:	mov    0x270(%r13),%rax
 1070015:	mov    0x5b8(%rsp),%rdi
 107001d:	xor    %esi,%esi
 107001f:	mov    0x68(%rax),%edx
 1070022:	shl    $0x2,%rdx
 1070026:	call   788120 <memset@plt>
 107002b:	mov    0x270(%r13),%rax
 1070032:	mov    0x5c0(%rsp),%rdi
 107003a:	xor    %esi,%esi
 107003c:	mov    0x68(%rax),%edx
 107003f:	shl    $0x2,%rdx
 1070043:	call   788120 <memset@plt>
 1070048:	mov    0x270(%r13),%rax
 107004f:	mov    0x5c8(%rsp),%rdi
 1070057:	xor    %esi,%esi
 1070059:	mov    0x68(%rax),%edx
 107005c:	shl    $0x2,%rdx
 1070060:	call   788120 <memset@plt>
 1070065:	mov    0x5d0(%rsp),%rdi
 107006d:	xor    %esi,%esi
 107006f:	mov    %rbx,%rdx
 1070072:	call   788120 <memset@plt>
 1070077:	mov    0xa8(%rsp),%r15
 107007f:	mov    0x5f0(%rsp),%rdi
 1070087:	mov    $0xff,%esi
 107008c:	mov    0xa4(%r15),%edx
 1070093:	shl    $0x2,%rdx
 1070097:	call   788120 <memset@plt>
 107009c:	mov    0x5f8(%rsp),%rdi
 10700a4:	mov    0xa4(%r15),%edx
 10700ab:	xor    %esi,%esi
 10700ad:	call   788120 <memset@plt>
 10700b2:	mov    0x3e0(%rsp),%rdi
 10700ba:	xor    %esi,%esi
 10700bc:	mov    %rbp,%rdx
 10700bf:	call   788120 <memset@plt>
 10700c4:	mov    0x3e8(%rsp),%rdi
 10700cc:	xor    %esi,%esi
 10700ce:	mov    %rbp,%rdx
 10700d1:	call   788120 <memset@plt>
 10700d6:	mov    0x428(%rsp),%rdi
 10700de:	xor    %esi,%esi
 10700e0:	mov    %rbp,%rdx
 10700e3:	call   788120 <memset@plt>
 10700e8:	mov    0x430(%rsp),%rdi
 10700f0:	xor    %esi,%esi
 10700f2:	mov    %rbx,%rdx
 10700f5:	call   788120 <memset@plt>
 10700fa:	mov    0x438(%rsp),%rdi
 1070102:	xor    %esi,%esi
 1070104:	mov    %rbx,%rdx
 1070107:	call   788120 <memset@plt>
 107010c:	mov    0x408(%rsp),%rdi
 1070114:	xor    %esi,%esi
 1070116:	mov    %rbx,%rdx
 1070119:	call   788120 <memset@plt>
 107011e:	mov    0x448(%rsp),%rdi
 1070126:	xor    %esi,%esi
 1070128:	mov    %rbx,%rdx
 107012b:	call   788120 <memset@plt>
 1070130:	mov    0x450(%rsp),%rdi
 1070138:	xor    %esi,%esi
 107013a:	mov    %rbx,%rdx
 107013d:	call   788120 <memset@plt>
 1070142:	mov    0x460(%rsp),%rdi
 107014a:	xor    %esi,%esi
 107014c:	mov    %rbx,%rdx
 107014f:	call   788120 <memset@plt>
 1070154:	mov    0x4a8(%rsp),%rdi
 107015c:	add    %rbp,%rbp
 107015f:	xor    %esi,%esi
 1070161:	mov    %rbp,%rdx
 1070164:	call   788120 <memset@plt>
 1070169:	mov    0x4b0(%rsp),%rdi
 1070171:	xor    %esi,%esi
 1070173:	mov    %rbx,%rdx
 1070176:	call   788120 <memset@plt>
 107017b:	mov    0x4d0(%rsp),%rdi
 1070183:	xor    %esi,%esi
 1070185:	mov    %rbx,%rdx
 1070188:	call   788120 <memset@plt>
 107018d:	mov    0x4d8(%rsp),%rdi
 1070195:	xor    %esi,%esi
 1070197:	mov    %rbx,%rdx
 107019a:	call   788120 <memset@plt>
 107019f:	mov    0x4e8(%rsp),%rdi
 10701a7:	xor    %esi,%esi
 10701a9:	mov    %rbx,%rdx
 10701ac:	call   788120 <memset@plt>
 10701b1:	mov    0x4f0(%rsp),%rdi
 10701b9:	xor    %esi,%esi
 10701bb:	mov    %rbx,%rdx
 10701be:	call   788120 <memset@plt>
 10701c3:	mov    0x4f8(%rsp),%rdi
 10701cb:	xor    %esi,%esi
 10701cd:	mov    %rbx,%rdx
 10701d0:	call   788120 <memset@plt>
 10701d5:	mov    0x270(%r13),%rax
 10701dc:	mov    0x470(%rsp),%rdi
 10701e4:	mov    $0xff,%esi
 10701e9:	mov    0x68(%rax),%edx
 10701ec:	add    %rdx,%rdx
 10701ef:	call   788120 <memset@plt>
 10701f4:	mov    0xd8(%rsp),%rsi
 10701fc:	mov    0x260(%rsp),%rcx
 1070204:	mov    0x258(%rsp),%rdx
 107020c:	mov    0x68(%rsp),%rdi
 1070211:	mov    0x150(%rsp),%r8
 1070219:	mov    0x148(%rsp),%r9
 1070221:	mov    0x80(%rsp),%r10
 1070229:	mov    0xb0(%rsp),%r11
 1070231:	mov    0xf8(%rsp),%rbx
 1070239:	mov    0xb8(%rsp),%r15
 1070241:	mov    0xe0(%rsp),%r13
 1070249:	mov    0x108(%rsp),%rbp
 1070251:	cmp    $0x1,%esi
 1070254:	adc    $0x0,%esi
 1070257:	nopw   0x0(%rax,%rax,1)
 1070260:	mov    (%rdi),%rax
 1070263:	movl   $0xffffffff,(%rax,%r14,4)
 107026b:	mov    (%r8),%rax
 107026e:	movl   $0xffffffff,(%rax,%r14,4)
 1070276:	mov    (%rcx),%rax
 1070279:	movl   $0xffffffff,(%rax,%r14,4)
 1070281:	mov    (%rdx),%rax
 1070284:	movl   $0xffffffff,(%rax,%r14,4)
 107028c:	mov    (%r9),%rax
 107028f:	movl   $0xffffffff,(%rax,%r14,4)
 1070297:	mov    (%r10),%rax
 107029a:	movl   $0xffffffff,(%rax,%r14,4)
 10702a2:	mov    (%r11),%rax
 10702a5:	movl   $0xffffffff,(%rax,%r14,4)
 10702ad:	mov    (%rbx),%rax
 10702b0:	movl   $0xffffffff,(%rax,%r14,4)
 10702b8:	mov    (%r15),%rax
 10702bb:	movl   $0xffffffff,(%rax,%r14,4)
 10702c3:	mov    0x0(%r13),%rax
 10702c7:	movl   $0xffffffff,(%rax,%r14,4)
 10702cf:	mov    0x0(%rbp),%rax
 10702d3:	movl   $0xffffffff,(%rax,%r14,4)
 10702db:	mov    0x418(%rsp),%rax
 10702e3:	movl   $0xffffffff,(%rax,%r14,4)
 10702eb:	mov    0x3f0(%rsp),%rax
 10702f3:	movl   $0xffffffff,(%rax,%r14,4)
 10702fb:	mov    0x3f8(%rsp),%rax
 1070303:	movl   $0xffffffff,(%rax,%r14,4)
 107030b:	mov    0x400(%rsp),%rax
 1070313:	movl   $0xffffffff,(%rax,%r14,4)
 107031b:	mov    0x440(%rsp),%rax
 1070323:	movl   $0xffffffff,(%rax,%r14,4)
 107032b:	mov    0x570(%rsp),%rax
 1070333:	movl   $0xffffffff,(%rax,%r14,4)
 107033b:	mov    0x580(%rsp),%rax
 1070343:	movl   $0xffffffff,(%rax,%r14,4)
 107034b:	mov    0x610(%rsp),%rax
 1070353:	movl   $0xffffffff,(%rax,%r14,4)
 107035b:	mov    0x618(%rsp),%rax
 1070363:	movl   $0xffffffff,(%rax,%r14,4)
 107036b:	mov    0x620(%rsp),%rax
 1070373:	movl   $0xffffffff,(%rax,%r14,4)
 107037b:	mov    0x628(%rsp),%rax
 1070383:	movl   $0xffffffff,(%rax,%r14,4)
 107038b:	mov    0x608(%rsp),%rax
 1070393:	mov    %r14d,(%rax,%r14,4)
 1070397:	inc    %r14
 107039a:	cmp    %r14,%rsi
 107039d:	jne    1070260 <check_input_run+0x3550>
 10703a3:	cmpl   $0x0,0xf0(%rsp)
 10703ab:	je     10707f1 <check_input_run+0x3ae1>
 10703b1:	mov    0xf0(%rsp),%rax
 10703b9:	mov    %eax,%edx
 10703bb:	lea    -0x1(%rax),%ecx
 10703be:	mov    0x78(%rsp),%rax
 10703c3:	and    $0x3,%edx
 10703c6:	je     1070415 <check_input_run+0x3705>
 10703c8:	mov    0x78(%rsp),%rax
 10703cd:	jmp    10703d7 <check_input_run+0x36c7>
 10703cf:	nop
 10703d0:	dec    %rax
 10703d3:	dec    %edx
 10703d5:	je     1070415 <check_input_run+0x3705>
 10703d7:	mov    0x60(%r12),%rdi
 10703dc:	lea    -0x1(%rax),%esi
 10703df:	mov    (%rdi,%rsi,4),%edi
 10703e2:	cmp    0xf0(%rsp),%edi
 10703e9:	jae    10703d0 <check_input_run+0x36c0>
 10703eb:	mov    0x610(%rsp),%r9
 10703f3:	mov    0x618(%rsp),%r10
 10703fb:	lea    -0x1(%rax),%r8d
 10703ff:	mov    (%r9,%rdi,4),%r9d
 1070403:	mov    %r9d,(%r10,%rsi,4)
 1070407:	mov    0x610(%rsp),%rsi
 107040f:	mov    %r8d,(%rsi,%rdi,4)
 1070413:	jmp    10703d0 <check_input_run+0x36c0>
 1070415:	cmp    $0x3,%ecx
 1070418:	jae    1070439 <check_input_run+0x3729>
 107041a:	mov    0x78(%rsp),%rsi
 107041f:	mov    %esi,%eax
 1070421:	lea    -0x1(%rsi),%rcx
 1070425:	and    $0x3,%eax
 1070428:	cmp    $0x3,%rcx
 107042c:	jae    10705b3 <check_input_run+0x38a3>
 1070432:	xor    %edx,%edx
 1070434:	jmp    10706f8 <check_input_run+0x39e8>
 1070439:	mov    $0xfffffffc,%ecx
 107043e:	mov    $0xfffffffffffffffc,%r8
 1070445:	mov    $0xfffffffffffffffd,%r9
 107044c:	mov    $0xfffffffffffffffe,%r10
 1070453:	mov    $0xffffffffffffffff,%r11
 107045a:	xor    %ebx,%ebx
 107045c:	lea    0x1(%rcx),%rdx
 1070460:	lea    0x2(%rcx),%rsi
 1070464:	lea    0x3(%rcx),%rdi
 1070468:	jmp    1070498 <check_input_run+0x3788>
 107046a:	nopw   0x0(%rax,%rax,1)
 1070470:	add    $0xfffffffffffffffc,%r8
 1070474:	add    $0x4,%rbx
 1070478:	add    $0xfffffffffffffffc,%rcx
 107047c:	add    $0xfffffffffffffffc,%r9
 1070480:	add    $0xfffffffffffffffc,%rdx
 1070484:	add    $0xfffffffffffffffc,%r10
 1070488:	add    $0xfffffffffffffffc,%rsi
 107048c:	add    $0xfffffffffffffffc,%r11
 1070490:	add    $0xfffffffffffffffc,%rdi
 1070494:	cmp    %ebx,%eax
 1070496:	je     107041a <check_input_run+0x370a>
 1070498:	mov    0x60(%r12),%r15
 107049d:	lea    (%rax,%r11,1),%r14d
 10704a1:	mov    (%r15,%r14,4),%r15d
 10704a5:	cmp    0xf0(%rsp),%r15d
 10704ad:	jae    10704dc <check_input_run+0x37cc>
 10704af:	mov    0x610(%rsp),%r12
 10704b7:	mov    0x618(%rsp),%r13
 10704bf:	lea    (%rax,%rdi,1),%ebp
 10704c2:	mov    (%r12,%r15,4),%r12d
 10704c6:	mov    %r12d,0x0(%r13,%r14,4)
 10704cb:	mov    0x20(%rsp),%r12
 10704d0:	mov    0x610(%rsp),%r14
 10704d8:	mov    %ebp,(%r14,%r15,4)
 10704dc:	mov    0x60(%r12),%r15
 10704e1:	lea    (%rax,%r10,1),%r14d
 10704e5:	mov    (%r15,%r14,4),%r15d
 10704e9:	cmp    0xf0(%rsp),%r15d
 10704f1:	jae    1070520 <check_input_run+0x3810>
 10704f3:	mov    0x610(%rsp),%r12
 10704fb:	mov    0x618(%rsp),%r13
 1070503:	lea    (%rax,%rsi,1),%ebp
 1070506:	mov    (%r12,%r15,4),%r12d
 107050a:	mov    %r12d,0x0(%r13,%r14,4)
 107050f:	mov    0x20(%rsp),%r12
 1070514:	mov    0x610(%rsp),%r14
 107051c:	mov    %ebp,(%r14,%r15,4)
 1070520:	mov    0x60(%r12),%r15
 1070525:	lea    (%rax,%r9,1),%r14d
 1070529:	mov    (%r15,%r14,4),%r15d
 107052d:	cmp    0xf0(%rsp),%r15d
 1070535:	jae    1070564 <check_input_run+0x3854>
 1070537:	mov    0x610(%rsp),%r12
 107053f:	mov    0x618(%rsp),%r13
 1070547:	lea    (%rax,%rdx,1),%ebp
 107054a:	mov    (%r12,%r15,4),%r12d
 107054e:	mov    %r12d,0x0(%r13,%r14,4)
 1070553:	mov    0x20(%rsp),%r12
 1070558:	mov    0x610(%rsp),%r14
 1070560:	mov    %ebp,(%r14,%r15,4)
 1070564:	mov    0x60(%r12),%r15
 1070569:	lea    (%rax,%r8,1),%r14d
 107056d:	mov    (%r15,%r14,4),%r15d
 1070571:	cmp    0xf0(%rsp),%r15d
 1070579:	jae    1070470 <check_input_run+0x3760>
 107057f:	mov    0x610(%rsp),%r13
 1070587:	mov    0x618(%rsp),%rbp
 107058f:	lea    (%rax,%rcx,1),%r12
 1070593:	mov    0x0(%r13,%r15,4),%r13d
 1070598:	mov    %r13d,0x0(%rbp,%r14,4)
 107059d:	mov    0x610(%rsp),%r14
 10705a5:	mov    %r12d,(%r14,%r15,4)
 10705a9:	mov    0x20(%rsp),%r12
 10705ae:	jmp    1070470 <check_input_run+0x3760>
 10705b3:	and    $0xfffffffc,%esi
 10705b6:	xor    %edi,%edi
 10705b8:	jmp    10705cc <check_input_run+0x38bc>
 10705ba:	nopw   0x0(%rax,%rax,1)
 10705c0:	inc    %rdi
 10705c3:	cmp    %rsi,%rdi
 10705c6:	je     10706e1 <check_input_run+0x39d1>
 10705cc:	mov    0x68(%r12),%r8
 10705d1:	mov    %rdi,%rdx
 10705d4:	mov    (%r8,%rdx,4),%edi
 10705d8:	mov    0x5e8(%rsp),%r8
 10705e0:	mov    %edx,(%r8,%rdi,4)
 10705e4:	mov    0x60(%r12),%r8
 10705e9:	mov    (%r8,%rdi,4),%r8d
 10705ed:	cmp    0xf0(%rsp),%r8d
 10705f5:	jae    107060d <check_input_run+0x38fd>
 10705f7:	mov    0x608(%rsp),%r9
 10705ff:	mov    (%r9,%rdi,4),%edi
 1070603:	cmp    %edi,(%r9,%r8,4)
 1070607:	jae    107060d <check_input_run+0x38fd>
 1070609:	mov    %edi,(%r9,%r8,4)
 107060d:	mov    0x68(%r12),%rdi
 1070612:	mov    0x5e8(%rsp),%r9
 107061a:	mov    0x4(%rdi,%rdx,4),%r8d
 107061f:	lea    0x1(%rdx),%rdi
 1070623:	mov    %edi,(%r9,%r8,4)
 1070627:	mov    0x60(%r12),%r9
 107062c:	mov    (%r9,%r8,4),%r9d
 1070630:	cmp    0xf0(%rsp),%r9d
 1070638:	jae    1070650 <check_input_run+0x3940>
 107063a:	mov    0x608(%rsp),%r10
 1070642:	mov    (%r10,%r8,4),%r8d
 1070646:	cmp    %r8d,(%r10,%r9,4)
 107064a:	jae    1070650 <check_input_run+0x3940>
 107064c:	mov    %r8d,(%r10,%r9,4)
 1070650:	mov    0x68(%r12),%r8
 1070655:	mov    0x5e8(%rsp),%r9
 107065d:	inc    %rdi
 1070660:	mov    0x8(%r8,%rdx,4),%r8d
 1070665:	mov    %edi,(%r9,%r8,4)
 1070669:	mov    0x60(%r12),%r9
 107066e:	mov    (%r9,%r8,4),%r9d
 1070672:	cmp    0xf0(%rsp),%r9d
 107067a:	jae    1070692 <check_input_run+0x3982>
 107067c:	mov    0x608(%rsp),%r10
 1070684:	mov    (%r10,%r8,4),%r8d
 1070688:	cmp    %r8d,(%r10,%r9,4)
 107068c:	jae    1070692 <check_input_run+0x3982>
 107068e:	mov    %r8d,(%r10,%r9,4)
 1070692:	mov    0x68(%r12),%r8
 1070697:	mov    0x5e8(%rsp),%r9
 107069f:	inc    %rdi
 10706a2:	mov    0xc(%r8,%rdx,4),%r8d
 10706a7:	mov    %edi,(%r9,%r8,4)
 10706ab:	mov    0x60(%r12),%r9
 10706b0:	mov    (%r9,%r8,4),%r9d
 10706b4:	cmp    0xf0(%rsp),%r9d
 10706bc:	jae    10705c0 <check_input_run+0x38b0>
 10706c2:	mov    0x608(%rsp),%r10
 10706ca:	mov    (%r10,%r8,4),%r8d
 10706ce:	cmp    %r8d,(%r10,%r9,4)
 10706d2:	jae    10705c0 <check_input_run+0x38b0>
 10706d8:	mov    %r8d,(%r10,%r9,4)
 10706dc:	jmp    10705c0 <check_input_run+0x38b0>
 10706e1:	test   %rax,%rax
 10706e4:	je     1070734 <check_input_run+0x3a24>
 10706e6:	add    $0x4,%rdx
 10706ea:	jmp    10706f8 <check_input_run+0x39e8>
 10706ec:	nopl   0x0(%rax)
 10706f0:	inc    %rdx
 10706f3:	dec    %rax
 10706f6:	je     1070734 <check_input_run+0x3a24>
 10706f8:	mov    0x68(%r12),%rsi
 10706fd:	mov    0x5e8(%rsp),%rdi
 1070705:	mov    (%rsi,%rdx,4),%esi
 1070708:	mov    %edx,(%rdi,%rsi,4)
 107070b:	mov    0x60(%r12),%rdi
 1070710:	mov    (%rdi,%rsi,4),%edi
 1070713:	cmp    0xf0(%rsp),%edi
 107071a:	jae    10706f0 <check_input_run+0x39e0>
 107071c:	mov    0x608(%rsp),%r8
 1070724:	mov    (%r8,%rsi,4),%esi
 1070728:	cmp    %esi,(%r8,%rdi,4)
 107072c:	jae    10706f0 <check_input_run+0x39e0>
 107072e:	mov    %esi,(%r8,%rdi,4)
 1070732:	jmp    10706f0 <check_input_run+0x39e0>
 1070734:	mov    0x78(%rsp),%rax
 1070739:	mov    %rax,%rdx
 107073c:	and    $0x3,%rdx
 1070740:	je     10707e7 <check_input_run+0x3ad7>
 1070746:	mov    0x78(%rsp),%rax
 107074b:	movabs $0x10380420000000,%rsi
 1070755:	jmp    1070781 <check_input_run+0x3a71>
 1070757:	nopw   0x0(%rax,%rax,1)
 1070760:	mov    0x508(%rsp),%r9
 1070768:	movzbl (%r9,%r8,1),%r10d
 107076d:	mov    0x508(%rsp),%r8
 1070775:	dec    %rax
 1070778:	dec    %rdx
 107077b:	mov    %r10b,(%r8,%rdi,1)
 107077f:	je     10707e7 <check_input_run+0x3ad7>
 1070781:	mov    0x68(%r12),%rdi
 1070786:	mov    0x50(%r12),%r9
 107078b:	mov    0x60(%r12),%r8
 1070790:	mov    -0x4(%rdi,%rax,4),%edi
 1070794:	movzbl (%r9,%rdi,1),%r11d
 1070799:	mov    (%r8,%rdi,4),%r8d
 107079d:	cmp    $0x1c,%r11d
 10707a1:	sete   %r10b
 10707a5:	cmp    0xf0(%rsp),%r8d
 10707ad:	setb   %bl
 10707b0:	test   %bl,%r10b
 10707b3:	jne    1070760 <check_input_run+0x3a50>
 10707b5:	add    $0xffffffe2,%r11d
 10707b9:	cmp    $0x34,%r11d
 10707bd:	ja     10707e2 <check_input_run+0x3ad2>
 10707bf:	mov    $0x1,%r10b
 10707c2:	bt     %r11,%rsi
 10707c6:	jb     107076d <check_input_run+0x3a5d>
 10707c8:	test   %r11,%r11
 10707cb:	jne    10707e2 <check_input_run+0x3ad2>
 10707cd:	cmp    0xf0(%rsp),%r8d
 10707d5:	jae    10707e2 <check_input_run+0x3ad2>
 10707d7:	cmpb   $0x4a,(%r9,%r8,1)
 10707dc:	sete   %r10b
 10707e0:	jmp    107076d <check_input_run+0x3a5d>
 10707e2:	xor    %r10d,%r10d
 10707e5:	jmp    107076d <check_input_run+0x3a5d>
 10707e7:	cmp    $0x3,%rcx
 10707eb:	jae    1070a9f <check_input_run+0x3d8f>
 10707f1:	mov    0x48(%r12),%eax
 10707f6:	test   %rax,%rax
 10707f9:	je     1071e23 <check_input_run+0x5113>
 10707ff:	mov    0x38(%rsp),%rsi
 1070804:	mov    0x8(%rsi),%rbx
 1070808:	mov    0x10(%rsi),%rcx
 107080c:	sub    %rbx,%rcx
 107080f:	setb   %dl
 1070812:	cmp    %rax,%rcx
 1070815:	setb   %cl
 1070818:	or     %dl,%cl
 107081a:	cmp    $0x1,%cl
 107081d:	je     1071e17 <check_input_run+0x5107>
 1070823:	add    %rbx,%rax
 1070826:	mov    0x18(%rsp),%rdx
 107082b:	mov    %rbx,%rcx
 107082e:	mov    %rax,0x8(%rsi)
 1070832:	mov    (%rsi),%rax
 1070835:	add    %rax,%rcx
 1070838:	sete   %cl
 107083b:	or     %cl,0x3bd(%rdx)
 1070841:	add    %rax,%rbx
 1070844:	je     1071e23 <check_input_run+0x5113>
 107084a:	mov    0x48(%r12),%edx
 107084f:	mov    %rbx,%rdi
 1070852:	xor    %esi,%esi
 1070854:	call   788120 <memset@plt>
 1070859:	lea    0x2a0(%rsp),%rdi
 1070861:	mov    %rbx,%rsi
 1070864:	call   1066800 <check_input_diagnostic_pragmas>
 1070869:	test   %al,%al
 107086b:	je     1071e17 <check_input_run+0x5107>
 1070871:	lea    0x2a0(%rsp),%rdi
 1070879:	mov    %rbx,%rsi
 107087c:	call   1080d00 <check_input_nonnull_pragmas>
 1070881:	test   %al,%al
 1070883:	je     1071e17 <check_input_run+0x5107>
 1070889:	mov    0x2c8(%rsp),%rcx
 1070891:	mov    0x2a8(%rsp),%rax
 1070899:	mov    0x8(%rcx),%r9
 107089d:	mov    0x48(%rax),%ecx
 10708a0:	mov    %rcx,0x50(%rsp)
 10708a5:	test   %rcx,%rcx
 10708a8:	je     10797c6 <check_input_run+0xcab6>
 10708ae:	mov    0x2c0(%rsp),%rcx
 10708b6:	mov    0x30(%rax),%r8d
 10708ba:	mov    0x38(%rax),%rdx
 10708be:	mov    0x40(%rax),%rdi
 10708c2:	mov    0x50(%rsp),%rax
 10708c7:	mov    %r9,0x28(%rsp)
 10708cc:	xor    %r15d,%r15d
 10708cf:	xor    %r9d,%r9d
 10708d2:	xor    %esi,%esi
 10708d4:	xor    %r10d,%r10d
 10708d7:	mov    %rcx,0x90(%rsp)
 10708df:	mov    0x8(%rcx),%rcx
 10708e3:	mov    %r8,0x98(%rsp)
 10708eb:	mov    %rcx,0x210(%rsp)
 10708f3:	mov    0x2b0(%rsp),%rcx
 10708fb:	nopl   0x0(%rax,%rax,1)
 1070900:	mov    (%rdx,%r9,4),%r14d
 1070904:	cmp    %r10d,%r14d
 1070907:	jb     107094d <check_input_run+0x3c3d>
 1070909:	mov    0x830(%rcx),%r13d
 1070910:	cmp    %r13d,%r14d
 1070913:	jae    107094d <check_input_run+0x3c3d>
 1070915:	mov    (%rdi,%r9,4),%r11d
 1070919:	cmp    %r15d,%r11d
 107091c:	jb     107094d <check_input_run+0x3c3d>
 107091e:	cmp    %r8d,%r11d
 1070921:	ja     107094d <check_input_run+0x3c3d>
 1070923:	mov    0x810(%rcx),%r12
 107092a:	cmpb   $0x3c,(%r12,%r14,1)
 107092f:	jne    1070948 <check_input_run+0x3c38>
 1070931:	mov    0x818(%rcx),%rbp
 1070938:	testb  $0x2,0x0(%rbp,%r14,1)
 107093e:	je     1070948 <check_input_run+0x3c38>
 1070940:	dec    %r13
 1070943:	cmp    %r14,%r13
 1070946:	jne    1070964 <check_input_run+0x3c54>
 1070948:	mov    0x20(%rsp),%r12
 107094d:	mov    %r15d,%r11d
 1070950:	xor    %ebp,%ebp
 1070952:	add    %ebp,%esi
 1070954:	inc    %r9
 1070957:	mov    %r11d,%r15d
 107095a:	cmp    %rax,%r9
 107095d:	jne    1070900 <check_input_run+0x3bf0>
 107095f:	jmp    1070ea7 <check_input_run+0x4197>
 1070964:	inc    %rbp
 1070967:	lea    0x1(%r12),%r8
 107096c:	xor    %eax,%eax
 107096e:	cmpb   $0xfc,(%r8,%r14,1)
 1070973:	je     10709a5 <check_input_run+0x3c95>
 1070975:	testb  $0x2,0x0(%rbp,%r14,1)
 107097b:	jne    107098e <check_input_run+0x3c7e>
 107097d:	dec    %rax
 1070980:	dec    %r13
 1070983:	inc    %rbp
 1070986:	inc    %r8
 1070989:	cmp    %r13,%r14
 107098c:	jne    107096e <check_input_run+0x3c5e>
 107098e:	mov    %r15d,%r11d
 1070991:	xor    %ebp,%ebp
 1070993:	mov    0x20(%rsp),%r12
 1070998:	mov    0x98(%rsp),%r8
 10709a0:	jmp    1070a83 <check_input_run+0x3d73>
 10709a5:	mov    0x98(%rsp),%r8
 10709ad:	mov    %r14,%r15
 10709b0:	sub    %rax,%r15
 10709b3:	lea    0x2(%r15),%r10
 10709b7:	cmp    %r15d,%r14d
 10709ba:	jae    1070a7c <check_input_run+0x3d6c>
 10709c0:	cmpb   $0x1,0x1(%r12,%r14,1)
 10709c6:	jne    1070a7c <check_input_run+0x3d6c>
 10709cc:	mov    0x270(%rcx),%rax
 10709d3:	mov    0x820(%rcx),%r13
 10709da:	mov    0x4(%r13,%r14,4),%r8d
 10709df:	mov    0x10(%rax),%rbp
 10709e3:	cmpl   $0x6,0x4(%rbp,%r8,8)
 10709e9:	jne    1070991 <check_input_run+0x3c81>
 10709eb:	mov    %r13,0x130(%rsp)
 10709f3:	mov    0x40(%rax),%r13
 10709f7:	mov    0x0(%rbp,%r8,8),%r8d
 10709fc:	mov    %rbp,0x1b0(%rsp)
 1070a04:	mov    $0x67617270,%ebp
 1070a09:	mov    0x0(%r13,%r8,1),%eax
 1070a0e:	movzwl 0x4(%r13,%r8,1),%r8d
 1070a14:	xor    %ebp,%eax
 1070a16:	xor    $0x616d,%r8d
 1070a1d:	or     %eax,%r8d
 1070a20:	jne    1070991 <check_input_run+0x3c81>
 1070a26:	mov    %r13,%rbp
 1070a29:	mov    0x1b0(%rsp),%r13
 1070a31:	mov    0x50(%rsp),%rax
 1070a36:	add    $0x2,%r14d
 1070a3a:	cmp    %r15d,%r14d
 1070a3d:	ja     1070a8d <check_input_run+0x3d7d>
 1070a3f:	mov    %r14d,%r8d
 1070a42:	cmpb   $0x1,(%r12,%r8,1)
 1070a47:	jne    1070a8d <check_input_run+0x3d7d>
 1070a49:	mov    0x130(%rsp),%rax
 1070a51:	mov    (%rax,%r8,4),%r8d
 1070a55:	cmpl   $0x4,0x4(%r13,%r8,8)
 1070a5b:	jne    1070991 <check_input_run+0x3c81>
 1070a61:	mov    0x0(%r13,%r8,8),%eax
 1070a66:	mov    %rbp,%r14
 1070a69:	xor    %ebp,%ebp
 1070a6b:	cmpl   $0x6b636170,(%r14,%rax,1)
 1070a73:	sete   %bpl
 1070a77:	jmp    1070993 <check_input_run+0x3c83>
 1070a7c:	mov    0x20(%rsp),%r12
 1070a81:	xor    %ebp,%ebp
 1070a83:	mov    0x50(%rsp),%rax
 1070a88:	jmp    1070952 <check_input_run+0x3c42>
 1070a8d:	mov    0x20(%rsp),%r12
 1070a92:	mov    0x98(%rsp),%r8
 1070a9a:	jmp    1070950 <check_input_run+0x3c40>
 1070a9f:	movabs $0x10380420000000,%rcx
 1070aa9:	jmp    1070ad3 <check_input_run+0x3dc3>
 1070aab:	nopl   0x0(%rax,%rax,1)
 1070ab0:	mov    0x508(%rsp),%rdi
 1070ab8:	movzbl (%rdi,%rsi,1),%r8d
 1070abd:	mov    0x508(%rsp),%rsi
 1070ac5:	add    $0xfffffffffffffffc,%rax
 1070ac9:	mov    %r8b,(%rsi,%rdx,1)
 1070acd:	je     10707f1 <check_input_run+0x3ae1>
 1070ad3:	mov    0x68(%r12),%rdx
 1070ad8:	mov    0x50(%r12),%rdi
 1070add:	mov    0x60(%r12),%rsi
 1070ae2:	mov    -0x4(%rdx,%rax,4),%edx
 1070ae6:	movzbl (%rdi,%rdx,1),%r8d
 1070aeb:	mov    (%rsi,%rdx,4),%esi
 1070aee:	cmp    $0x1c,%r8d
 1070af2:	sete   %r9b
 1070af6:	cmp    0xf0(%rsp),%esi
 1070afd:	setb   %r10b
 1070b01:	and    %r9b,%r10b
 1070b04:	cmp    $0x1,%r10b
 1070b08:	jne    1070b20 <check_input_run+0x3e10>
 1070b0a:	mov    0x508(%rsp),%rdi
 1070b12:	movzbl (%rdi,%rsi,1),%r9d
 1070b17:	jmp    1070b3b <check_input_run+0x3e2b>
 1070b19:	nopl   0x0(%rax)
 1070b20:	add    $0xffffffe2,%r8d
 1070b24:	cmp    $0x34,%r8d
 1070b28:	ja     1070ce9 <check_input_run+0x3fd9>
 1070b2e:	mov    $0x1,%r9b
 1070b31:	bt     %r8,%rcx
 1070b35:	jae    1070c90 <check_input_run+0x3f80>
 1070b3b:	mov    0x508(%rsp),%rsi
 1070b43:	mov    %r9b,(%rsi,%rdx,1)
 1070b47:	mov    0x68(%r12),%rdx
 1070b4c:	mov    0x50(%r12),%rdi
 1070b51:	mov    0x60(%r12),%rsi
 1070b56:	mov    -0x8(%rdx,%rax,4),%edx
 1070b5a:	movzbl (%rdi,%rdx,1),%r9d
 1070b5f:	mov    (%rsi,%rdx,4),%esi
 1070b62:	cmp    $0x1c,%r9d
 1070b66:	sete   %r8b
 1070b6a:	cmp    0xf0(%rsp),%esi
 1070b71:	setb   %r10b
 1070b75:	test   %r10b,%r8b
 1070b78:	je     1070b90 <check_input_run+0x3e80>
 1070b7a:	mov    0x508(%rsp),%rdi
 1070b82:	movzbl (%rdi,%rsi,1),%r8d
 1070b87:	jmp    1070bab <check_input_run+0x3e9b>
 1070b89:	nopl   0x0(%rax)
 1070b90:	add    $0xffffffe2,%r9d
 1070b94:	cmp    $0x34,%r9d
 1070b98:	ja     1070cf1 <check_input_run+0x3fe1>
 1070b9e:	mov    $0x1,%r8b
 1070ba1:	bt     %r9,%rcx
 1070ba5:	jae    1070cab <check_input_run+0x3f9b>
 1070bab:	mov    0x508(%rsp),%rsi
 1070bb3:	mov    %r8b,(%rsi,%rdx,1)
 1070bb7:	mov    0x68(%r12),%rdx
 1070bbc:	mov    0x50(%r12),%rdi
 1070bc1:	mov    0x60(%r12),%rsi
 1070bc6:	mov    -0xc(%rdx,%rax,4),%edx
 1070bca:	movzbl (%rdi,%rdx,1),%r9d
 1070bcf:	mov    (%rsi,%rdx,4),%esi
 1070bd2:	cmp    $0x1c,%r9d
 1070bd6:	sete   %r8b
 1070bda:	cmp    0xf0(%rsp),%esi
 1070be1:	setb   %r10b
 1070be5:	test   %r10b,%r8b
 1070be8:	je     1070c00 <check_input_run+0x3ef0>
 1070bea:	mov    0x508(%rsp),%rdi
 1070bf2:	movzbl (%rdi,%rsi,1),%r8d
 1070bf7:	jmp    1070c1b <check_input_run+0x3f0b>
 1070bf9:	nopl   0x0(%rax)
 1070c00:	add    $0xffffffe2,%r9d
 1070c04:	cmp    $0x34,%r9d
 1070c08:	ja     1070cf9 <check_input_run+0x3fe9>
 1070c0e:	mov    $0x1,%r8b
 1070c11:	bt     %r9,%rcx
 1070c15:	jae    1070cc6 <check_input_run+0x3fb6>
 1070c1b:	mov    0x508(%rsp),%rsi
 1070c23:	mov    %r8b,(%rsi,%rdx,1)
 1070c27:	mov    0x68(%r12),%rdx
 1070c2c:	mov    0x50(%r12),%rdi
 1070c31:	mov    0x60(%r12),%rsi
 1070c36:	mov    -0x10(%rdx,%rax,4),%edx
 1070c3a:	movzbl (%rdi,%rdx,1),%r9d
 1070c3f:	mov    (%rsi,%rdx,4),%esi
 1070c42:	cmp    $0x1c,%r9d
 1070c46:	sete   %r8b
 1070c4a:	cmp    0xf0(%rsp),%esi
 1070c51:	setb   %r10b
 1070c55:	test   %r10b,%r8b
 1070c58:	jne    1070ab0 <check_input_run+0x3da0>
 1070c5e:	add    $0xffffffe2,%r9d
 1070c62:	cmp    $0x34,%r9d
 1070c66:	ja     1070ce1 <check_input_run+0x3fd1>
 1070c68:	mov    $0x1,%r8b
 1070c6b:	bt     %r9,%rcx
 1070c6f:	jb     1070abd <check_input_run+0x3dad>
 1070c75:	test   %r9,%r9
 1070c78:	jne    1070ce1 <check_input_run+0x3fd1>
 1070c7a:	cmp    0xf0(%rsp),%esi
 1070c81:	jae    1070ce1 <check_input_run+0x3fd1>
 1070c83:	cmpb   $0x4a,(%rdi,%rsi,1)
 1070c87:	sete   %r8b
 1070c8b:	jmp    1070abd <check_input_run+0x3dad>
 1070c90:	test   %r8,%r8
 1070c93:	jne    1070ce9 <check_input_run+0x3fd9>
 1070c95:	cmp    0xf0(%rsp),%esi
 1070c9c:	jae    1070ce9 <check_input_run+0x3fd9>
 1070c9e:	cmpb   $0x4a,(%rdi,%rsi,1)
 1070ca2:	sete   %r9b
 1070ca6:	jmp    1070b3b <check_input_run+0x3e2b>
 1070cab:	test   %r9,%r9
 1070cae:	jne    1070cf1 <check_input_run+0x3fe1>
 1070cb0:	cmp    0xf0(%rsp),%esi
 1070cb7:	jae    1070cf1 <check_input_run+0x3fe1>
 1070cb9:	cmpb   $0x4a,(%rdi,%rsi,1)
 1070cbd:	sete   %r8b
 1070cc1:	jmp    1070bab <check_input_run+0x3e9b>
 1070cc6:	test   %r9,%r9
 1070cc9:	jne    1070cf9 <check_input_run+0x3fe9>
 1070ccb:	cmp    0xf0(%rsp),%esi
 1070cd2:	jae    1070cf9 <check_input_run+0x3fe9>
 1070cd4:	cmpb   $0x4a,(%rdi,%rsi,1)
 1070cd8:	sete   %r8b
 1070cdc:	jmp    1070c1b <check_input_run+0x3f0b>
 1070ce1:	xor    %r8d,%r8d
 1070ce4:	jmp    1070abd <check_input_run+0x3dad>
 1070ce9:	xor    %r9d,%r9d
 1070cec:	jmp    1070b3b <check_input_run+0x3e2b>
 1070cf1:	xor    %r8d,%r8d
 1070cf4:	jmp    1070bab <check_input_run+0x3e9b>
 1070cf9:	xor    %r8d,%r8d
 1070cfc:	jmp    1070c1b <check_input_run+0x3f0b>
 1070d01:	mov    0x38(%rsp),%rcx
 1070d06:	mov    %rdx,%rsi
 1070d09:	sub    %rax,%rsi
 1070d0c:	mov    0x10(%rcx),%rcx
 1070d10:	mov    %rcx,%rdi
 1070d13:	sub    %rsi,%rdi
 1070d16:	jb     106f47c <check_input_run+0x276c>
 1070d1c:	cmp    %rdi,%rbx
 1070d1f:	ja     106f47c <check_input_run+0x276c>
 1070d25:	mov    0x38(%rsp),%rdi
 1070d2a:	add    %rbx,%rsi
 1070d2d:	mov    %rsi,0x8(%rdi)
 1070d31:	mov    %rdx,0x458(%rsp)
 1070d39:	test   %rdx,%rdx
 1070d3c:	je     106f488 <check_input_run+0x2778>
 1070d42:	lea    (%rdx,%rbx,1),%rsi
 1070d46:	lea    0x3f(%rdx,%rbx,1),%rdx
 1070d4b:	and    $0xffffffffffffffc0,%rdx
 1070d4f:	cmp    %rsi,%rdx
 1070d52:	jb     106f488 <check_input_run+0x2778>
 1070d58:	mov    %rdx,%rsi
 1070d5b:	sub    %rax,%rsi
 1070d5e:	mov    %rcx,%r8
 1070d61:	sub    %rsi,%r8
 1070d64:	jb     106f488 <check_input_run+0x2778>
 1070d6a:	mov    0x270(%r15),%rdi
 1070d71:	mov    0x68(%rdi),%edi
 1070d74:	shl    $0x2,%rdi
 1070d78:	cmp    %r8,%rdi
 1070d7b:	ja     106f488 <check_input_run+0x2778>
 1070d81:	mov    0x38(%rsp),%r8
 1070d86:	add    %rdi,%rsi
 1070d89:	mov    %rsi,0x8(%r8)
 1070d8d:	mov    %rdx,0x590(%rsp)
 1070d95:	test   %rdx,%rdx
 1070d98:	je     106f494 <check_input_run+0x2784>
 1070d9e:	lea    (%rdx,%rdi,1),%rsi
 1070da2:	lea    0x3c(%rdx,%rdi,1),%rdx
 1070da7:	mov    $0x1,%dil
 1070daa:	mov    %rdi,0xc8(%rsp)
 1070db2:	and    $0xffffffffffffffc0,%rdx
 1070db6:	cmp    %rsi,%rdx
 1070db9:	jb     106f4a0 <check_input_run+0x2790>
 1070dbf:	mov    %rdx,%rsi
 1070dc2:	sub    %rax,%rsi
 1070dc5:	xor    %edi,%edi
 1070dc7:	sub    %rsi,%rcx
 1070dca:	jb     106f4a2 <check_input_run+0x2792>
 1070dd0:	mov    0x270(%r15),%rax
 1070dd7:	mov    0x68(%rax),%eax
 1070dda:	add    %rax,%rax
 1070ddd:	cmp    %rcx,%rax
 1070de0:	ja     106f4a2 <check_input_run+0x2792>
 1070de6:	mov    0x38(%rsp),%rcx
 1070deb:	add    %rax,%rsi
 1070dee:	mov    %rdx,%rdi
 1070df1:	mov    %rsi,0x8(%rcx)
 1070df5:	jmp    106f4a2 <check_input_run+0x2792>
 1070dfa:	mov    0x18(%rsp),%rdi
 1070dff:	mov    0xd8(%rsp),%rax
 1070e07:	mov    %eax,0x234(%rdi)
 1070e0d:	mov    0x10(%rsp),%rax
 1070e12:	mov    (%rax),%rdx
 1070e15:	mov    0x8(%rax),%rcx
 1070e19:	lea    0x3(%rcx,%rdx,1),%rax
 1070e1e:	add    %rdx,%rcx
 1070e21:	and    $0xfffffffffffffffc,%rax
 1070e25:	cmp    %rcx,%rax
 1070e28:	jb     106d507 <check_input_run+0x7f7>
 1070e2e:	mov    %rax,%rcx
 1070e31:	sub    %rdx,%rcx
 1070e34:	mov    0x10(%rsp),%rdx
 1070e39:	mov    0x10(%rdx),%rdx
 1070e3d:	sub    %rcx,%rdx
 1070e40:	jb     106d507 <check_input_run+0x7f7>
 1070e46:	mov    0xd8(%rsp),%esi
 1070e4d:	shl    $0x2,%rsi
 1070e51:	lea    (%rsi,%rsi,2),%rsi
 1070e55:	cmp    %rdx,%rsi
 1070e58:	ja     106d507 <check_input_run+0x7f7>
 1070e5e:	add    %rsi,%rcx
 1070e61:	mov    0x10(%rsp),%rsi
 1070e66:	lea    0x228(%rdi),%r9
 1070e6d:	mov    %rcx,0x8(%rsi)
 1070e71:	mov    %rax,0x228(%rdi)
 1070e78:	test   %rax,%rax
 1070e7b:	je     106d51e <check_input_run+0x80e>
 1070e81:	mov    (%rsi),%rax
 1070e84:	mov    0x8(%rsi),%rdx
 1070e88:	lea    0x3(%rdx,%rax,1),%rcx
 1070e8d:	add    %rax,%rdx
 1070e90:	and    $0xfffffffffffffffc,%rcx
 1070e94:	cmp    %rdx,%rcx
 1070e97:	jae    1071c0b <check_input_run+0x4efb>
 1070e9d:	mov    0x18(%rsp),%rdi
 1070ea2:	jmp    106d51e <check_input_run+0x80e>
 1070ea7:	mov    0x28(%rsp),%r9
 1070eac:	test   %esi,%esi
 1070eae:	je     10797c6 <check_input_run+0xcab6>
 1070eb4:	mov    %esi,%edx
 1070eb6:	lea    (%rdx,%rdx,1),%rax
 1070eba:	mov    $0x1,%ecx
 1070ebf:	nop
 1070ec0:	mov    %rcx,%rbp
 1070ec3:	add    %rcx,%rcx
 1070ec6:	cmp    %rax,%rbp
 1070ec9:	jbe    1070ec0 <check_input_run+0x41b0>
 1070ecb:	mov    0x90(%rsp),%r8
 1070ed3:	mov    0x210(%rsp),%rcx
 1070edb:	mov    (%r8),%rsi
 1070ede:	lea    0x7(%rcx,%rsi,1),%r10
 1070ee3:	lea    (%rcx,%rsi,1),%rax
 1070ee7:	mov    $0x1,%cl
 1070ee9:	and    $0xfffffffffffffff8,%r10
 1070eed:	cmp    %rax,%r10
 1070ef0:	jb     1070f49 <check_input_run+0x4239>
 1070ef2:	mov    %r10,%rax
 1070ef5:	sub    %rsi,%rax
 1070ef8:	mov    0x10(%r8),%rsi
 1070efc:	sub    %rax,%rsi
 1070eff:	setb   %dil
 1070f03:	cmp    $0x18,%rsi
 1070f07:	setb   %sil
 1070f0b:	or     %dil,%sil
 1070f0e:	jne    1070f49 <check_input_run+0x4239>
 1070f10:	add    $0x18,%rax
 1070f14:	mov    %rax,0x8(%r8)
 1070f18:	test   %r10,%r10
 1070f1b:	je     1070f49 <check_input_run+0x4239>
 1070f1d:	mov    0x2c0(%rsp),%rax
 1070f25:	mov    (%rax),%rdi
 1070f28:	mov    0x8(%rax),%rsi
 1070f2c:	lea    0x3(%rsi,%rdi,1),%r11
 1070f31:	add    %rdi,%rsi
 1070f34:	and    $0xfffffffffffffffc,%r11
 1070f38:	cmp    %rsi,%r11
 1070f3b:	jae    1071d23 <check_input_run+0x5013>
 1070f41:	xor    %r14d,%r14d
 1070f44:	xor    %r11d,%r11d
 1070f47:	jmp    1070f52 <check_input_run+0x4242>
 1070f49:	xor    %r14d,%r14d
 1070f4c:	xor    %r11d,%r11d
 1070f4f:	xor    %r10d,%r10d
 1070f52:	movq   $0x0,0x1b0(%rsp)
 1070f5e:	xor    %edi,%edi
 1070f60:	mov    0x2a0(%rsp),%rdx
 1070f68:	test   %rdi,%rdi
 1070f6b:	sete   %al
 1070f6e:	or     %cl,%al
 1070f70:	or     %al,0x3bd(%rdx)
 1070f76:	test   %al,%al
 1070f78:	jne    1071df7 <check_input_run+0x50e7>
 1070f7e:	lea    0x0(,%rbp,8),%rdx
 1070f86:	lea    0x8(%r10),%rax
 1070f8a:	xor    %esi,%esi
 1070f8c:	mov    %r14,0xc8(%rsp)
 1070f94:	mov    %r11,0xe8(%rsp)
 1070f9c:	mov    %r11,(%r10)
 1070f9f:	vpxor  %xmm0,%xmm0,%xmm0
 1070fa3:	mov    %r10,0x90(%rsp)
 1070fab:	vmovdqu %xmm0,0x8(%r10)
 1070fb1:	movq   $0x0,0xd0(%rsp)
 1070fbd:	mov    %rdi,0x70(%rsp)
 1070fc2:	mov    %rax,0x130(%rsp)
 1070fca:	call   788120 <memset@plt>
 1070fcf:	dec    %rbp
 1070fd2:	xor    %r13d,%r13d
 1070fd5:	xor    %r11d,%r11d
 1070fd8:	xor    %esi,%esi
 1070fda:	mov    0x2a8(%rsp),%rcx
 1070fe2:	mov    $0x1,%r8b
 1070fe5:	mov    0x38(%rcx),%rax
 1070fe9:	mov    (%rax,%r13,4),%r14d
 1070fed:	cmp    %r11d,%r14d
 1070ff0:	jae    1071010 <check_input_run+0x4300>
 1070ff2:	mov    %esi,%r15d
 1070ff5:	inc    %r13
 1070ff8:	cmp    0x50(%rsp),%r13
 1070ffd:	jae    1071b7b <check_input_run+0x4e6b>
 1071003:	mov    %r15d,%esi
 1071006:	test   %r8b,%r8b
 1071009:	jne    1070fda <check_input_run+0x42ca>
 107100b:	jmp    1071b7b <check_input_run+0x4e6b>
 1071010:	mov    0x2b0(%rsp),%rax
 1071018:	mov    0x830(%rax),%edi
 107101e:	cmp    %edi,%r14d
 1071021:	jae    1070ff2 <check_input_run+0x42e2>
 1071023:	mov    0x40(%rcx),%rdx
 1071027:	mov    (%rdx,%r13,4),%r15d
 107102b:	cmp    %esi,%r15d
 107102e:	jb     1070ff2 <check_input_run+0x42e2>
 1071030:	cmp    0x30(%rcx),%r15d
 1071034:	ja     1070ff2 <check_input_run+0x42e2>
 1071036:	mov    0x810(%rax),%rcx
 107103d:	cmpb   $0x3c,(%rcx,%r14,1)
 1071042:	jne    1070ff2 <check_input_run+0x42e2>
 1071044:	mov    0x818(%rax),%r9
 107104b:	testb  $0x2,(%r9,%r14,1)
 1071050:	je     1070ff2 <check_input_run+0x42e2>
 1071052:	dec    %rdi
 1071055:	cmp    %r14,%rdi
 1071058:	je     1070ff2 <check_input_run+0x42e2>
 107105a:	inc    %r9
 107105d:	lea    0x1(%rcx),%r10
 1071061:	xor    %edx,%edx
 1071063:	cmpb   $0xfc,(%r10,%r14,1)
 1071068:	je     1071087 <check_input_run+0x4377>
 107106a:	testb  $0x2,(%r9,%r14,1)
 107106f:	jne    1070ff2 <check_input_run+0x42e2>
 1071071:	dec    %rdx
 1071074:	dec    %rdi
 1071077:	inc    %r9
 107107a:	inc    %r10
 107107d:	cmp    %rdi,%r14
 1071080:	jne    1071063 <check_input_run+0x4353>
 1071082:	jmp    1070ff2 <check_input_run+0x42e2>
 1071087:	mov    %r14,%rdi
 107108a:	sub    %rdx,%rdi
 107108d:	lea    0x2(%rdi),%r11
 1071091:	cmp    %edi,%r14d
 1071094:	jae    1070ff5 <check_input_run+0x42e5>
 107109a:	cmpb   $0x1,0x1(%rcx,%r14,1)
 10710a0:	jne    1070ff5 <check_input_run+0x42e5>
 10710a6:	mov    0x820(%rax),%r10
 10710ad:	mov    0x270(%rax),%r9
 10710b4:	mov    %r11,0x100(%rsp)
 10710bc:	mov    $0x67617270,%esi
 10710c1:	mov    %r10,0xd8(%rsp)
 10710c9:	mov    0x4(%r10,%r14,4),%r11d
 10710ce:	mov    0x10(%r9),%r10
 10710d2:	cmpl   $0x6,0x4(%r10,%r11,8)
 10710d8:	jne    1071135 <check_input_run+0x4425>
 10710da:	mov    0x40(%r9),%r9
 10710de:	mov    (%r10,%r11,8),%r11d
 10710e2:	mov    (%r9,%r11,1),%r12d
 10710e6:	movzwl 0x4(%r9,%r11,1),%r11d
 10710ec:	xor    %esi,%r12d
 10710ef:	xor    $0x616d,%r11d
 10710f6:	or     %r12d,%r11d
 10710f9:	jne    1071130 <check_input_run+0x4420>
 10710fb:	lea    0x2(%r14),%r11d
 10710ff:	cmp    %edi,%r11d
 1071102:	ja     1071130 <check_input_run+0x4420>
 1071104:	mov    %r11d,%r11d
 1071107:	cmpb   $0x1,(%rcx,%r11,1)
 107110c:	jne    1071130 <check_input_run+0x4420>
 107110e:	mov    0xd8(%rsp),%rsi
 1071116:	mov    (%rsi,%r11,4),%r11d
 107111a:	cmpl   $0x4,0x4(%r10,%r11,8)
 1071120:	jne    1071130 <check_input_run+0x4420>
 1071122:	mov    (%r10,%r11,8),%r11d
 1071126:	cmpl   $0x6b636170,(%r9,%r11,1)
 107112e:	je     1071142 <check_input_run+0x4432>
 1071130:	mov    0x20(%rsp),%r12
 1071135:	mov    0x100(%rsp),%r11
 107113d:	jmp    1070ff5 <check_input_run+0x42e5>
 1071142:	mov    0xd0(%rsp),%esi
 1071149:	lea    0x3(%r14),%r8d
 107114d:	mov    %rsi,0x150(%rsp)
 1071155:	cmp    %edi,%r8d
 1071158:	jbe    10712c7 <check_input_run+0x45b7>
 107115e:	mov    0x90(%rsp),%r12
 1071166:	mov    0x150(%rsp),%rdi
 107116e:	mov    %r15d,%edx
 1071171:	sub    0xd0(%rsp),%edx
 1071178:	add    0x1b0(%rsp),%rdi
 1071180:	mov    0x14(%r12),%esi
 1071185:	call   788120 <memset@plt>
 107118a:	movzbl 0x14(%r12),%eax
 1071190:	mov    0x10(%r12),%ecx
 1071195:	mov    $0x1,%dl
 1071197:	movl   $0x0,0x88(%rsp)
 10711a2:	movl   $0x0,0x60(%rsp)
 10711aa:	movl   $0x0,0x68(%rsp)
 10711b2:	movq   $0x0,0xc0(%rsp)
 10711be:	mov    $0xffffffff,%esi
 10711c3:	mov    %edx,0x110(%rsp)
 10711ca:	mov    $0xffffffff,%edx
 10711cf:	mov    %rdx,0x48(%rsp)
 10711d4:	mov    $0x1,%dl
 10711d6:	mov    %edx,0xa0(%rsp)
 10711dd:	mov    $0xffffffff,%edx
 10711e2:	mov    %eax,%edi
 10711e4:	mov    0x90(%rsp),%r11
 10711ec:	mov    0x88(%rsp),%r12d
 10711f4:	mov    0x8(%r11),%r8d
 10711f8:	mov    0x10(%r11),%r9d
 10711fc:	lea    0x1(%r8),%r10d
 1071200:	imul   $0x34,%r8,%r8
 1071204:	mov    %r10d,0x8(%r11)
 1071208:	mov    0xe8(%rsp),%r10
 1071210:	mov    0x100(%rsp),%r11
 1071218:	mov    %r13d,(%r10,%r8,1)
 107121c:	mov    %r14d,0x4(%r10,%r8,1)
 1071221:	mov    0x48(%rsp),%r14
 1071226:	mov    %r11d,0x8(%r10,%r8,1)
 107122b:	mov    %r15d,0xc(%r10,%r8,1)
 1071230:	movl   $0xffffffff,0x10(%r10,%r8,1)
 1071239:	mov    %r14d,0x14(%r10,%r8,1)
 107123e:	mov    %r12d,0x18(%r10,%r8,1)
 1071243:	mov    %esi,0x1c(%r10,%r8,1)
 1071248:	mov    %edx,0x20(%r10,%r8,1)
 107124d:	mov    %ecx,0x24(%r10,%r8,1)
 1071252:	mov    0xc0(%rsp),%rcx
 107125a:	mov    %r9d,0x28(%r10,%r8,1)
 107125f:	mov    0x20(%rsp),%r12
 1071264:	mov    %cl,0x2c(%r10,%r8,1)
 1071269:	mov    0x68(%rsp),%ecx
 107126d:	mov    %cl,0x2d(%r10,%r8,1)
 1071272:	mov    %al,0x2e(%r10,%r8,1)
 1071277:	mov    0xa0(%rsp),%eax
 107127e:	mov    %dil,0x2f(%r10,%r8,1)
 1071283:	mov    %al,0x30(%r10,%r8,1)
 1071288:	mov    0x110(%rsp),%eax
 107128f:	mov    %al,0x31(%r10,%r8,1)
 1071294:	mov    0x60(%rsp),%eax
 1071298:	mov    %al,0x32(%r10,%r8,1)
 107129d:	movb   $0x0,0x33(%r10,%r8,1)
 10712a3:	mov    0x2a0(%rsp),%rax
 10712ab:	movzbl 0x3bd(%rax),%r8d
 10712b3:	mov    %r15d,%eax
 10712b6:	mov    %rax,0xd0(%rsp)
 10712be:	xor    $0x1,%r8b
 10712c2:	jmp    1070ff5 <check_input_run+0x42e5>
 10712c7:	mov    %r8d,%r8d
 10712ca:	xor    %r11d,%r11d
 10712cd:	cmpb   $0xf,(%rcx,%r8,1)
 10712d2:	sete   %r12b
 10712d6:	jne    107115e <check_input_run+0x444e>
 10712dc:	mov    %r12b,%r11b
 10712df:	add    %r11,%r8
 10712e2:	cmp    %edi,%r8d
 10712e5:	ja     107115e <check_input_run+0x444e>
 10712eb:	movzbl (%rcx,%r8,1),%r11d
 10712f0:	movl   $0x0,0x88(%rsp)
 10712fb:	cmp    $0xf,%r11d
 10712ff:	jg     1071312 <check_input_run+0x4602>
 1071301:	cmp    $0x1,%r11d
 1071305:	je     1071354 <check_input_run+0x4644>
 1071307:	cmp    $0x2,%r11d
 107130b:	je     1071325 <check_input_run+0x4615>
 107130d:	jmp    107115e <check_input_run+0x444e>
 1071312:	cmp    $0x10,%r11d
 1071316:	je     1071394 <check_input_run+0x4684>
 1071318:	cmp    $0xfd,%r11d
 107131f:	jne    107115e <check_input_run+0x444e>
 1071325:	mov    %r8d,%esi
 1071328:	mov    %rsi,0x48(%rsp)
 107132d:	mov    $0x1,%sil
 1071330:	inc    %r8d
 1071333:	mov    $0x1,%r9b
 1071336:	mov    %esi,0x60(%rsp)
 107133a:	mov    $0x2,%sil
 107133d:	mov    %rsi,0xc0(%rsp)
 1071345:	mov    $0x1,%sil
 1071348:	mov    %esi,0x110(%rsp)
 107134f:	jmp    1071535 <check_input_run+0x4825>
 1071354:	mov    0xd8(%rsp),%rsi
 107135c:	mov    (%rsi,%r8,4),%r11d
 1071360:	mov    0x4(%r10,%r11,8),%r12d
 1071365:	cmp    $0x3,%r12d
 1071369:	je     10713be <check_input_run+0x46ae>
 107136b:	cmp    $0x4,%r12d
 107136f:	jne    10713de <check_input_run+0x46ce>
 1071371:	mov    (%r10,%r11,8),%r10d
 1071375:	cmpl   $0x68737570,(%r9,%r10,1)
 107137d:	je     10713ec <check_input_run+0x46dc>
 107137f:	xor    %r11d,%r11d
 1071382:	cmpl   $0x776f6873,(%r9,%r10,1)
 107138a:	sete   %r11b
 107138e:	lea    (%r11,%r11,4),%esi
 1071392:	jmp    10713f4 <check_input_run+0x46e4>
 1071394:	mov    $0x1,%sil
 1071397:	movl   $0x0,0x60(%rsp)
 107139f:	xor    %r9d,%r9d
 10713a2:	mov    %rsi,0xc0(%rsp)
 10713aa:	mov    $0x1,%sil
 10713ad:	mov    %esi,0x110(%rsp)
 10713b4:	mov    $0xffffffff,%esi
 10713b9:	jmp    1071530 <check_input_run+0x4820>
 10713be:	mov    (%r10,%r11,8),%r10d
 10713c2:	movzwl (%r9,%r10,1),%r11d
 10713c7:	movzbl 0x2(%r9,%r10,1),%r9d
 10713cd:	xor    $0x6f70,%r11d
 10713d4:	xor    $0x70,%r9d
 10713d8:	or     %r11w,%r9w
 10713dc:	je     10713f1 <check_input_run+0x46e1>
 10713de:	movq   $0x0,0xc0(%rsp)
 10713ea:	jmp    10713fc <check_input_run+0x46ec>
 10713ec:	mov    $0x3,%sil
 10713ef:	jmp    10713f4 <check_input_run+0x46e4>
 10713f1:	mov    $0x4,%sil
 10713f4:	mov    %rsi,0xc0(%rsp)
 10713fc:	cmpb   $0x0,0xc0(%rsp)
 1071404:	mov    %r8d,%r9d
 1071407:	lea    0x1(%r9),%r10
 107140b:	movl   $0x0,0x60(%rsp)
 1071413:	setne  %sil
 1071417:	mov    %esi,0x110(%rsp)
 107141e:	cmp    %edi,%r8d
 1071421:	jae    107151a <check_input_run+0x480a>
 1071427:	mov    0xc0(%rsp),%rsi
 107142f:	lea    -0x3(%rsi),%r11d
 1071433:	cmp    $0x1,%r11b
 1071437:	ja     107151a <check_input_run+0x480a>
 107143d:	cmpb   $0x3b,(%rcx,%r10,1)
 1071442:	movl   $0x0,0x60(%rsp)
 107144a:	jne    107151a <check_input_run+0x480a>
 1071450:	lea    0x2(%r9),%r10
 1071454:	movl   $0x0,0x88(%rsp)
 107145f:	mov    %r10,0x48(%rsp)
 1071464:	cmp    %edi,%r10d
 1071467:	ja     10714c1 <check_input_run+0x47b1>
 1071469:	lea    0x2(%r9),%rsi
 107146d:	cmpb   $0x1,(%rcx,%rsi,1)
 1071471:	jne    10714c1 <check_input_run+0x47b1>
 1071473:	mov    0xd8(%rsp),%rsi
 107147b:	mov    %r9,%r10
 107147e:	add    $0x3,%r10
 1071482:	movl   $0x0,0x60(%rsp)
 107148a:	mov    0x8(%rsi,%r9,4),%esi
 107148f:	xor    %r9d,%r9d
 1071492:	mov    %esi,0x88(%rsp)
 1071499:	cmp    %edi,%r10d
 107149c:	ja     1071b39 <check_input_run+0x4e29>
 10714a2:	xor    %r9d,%r9d
 10714a5:	cmpb   $0x3b,(%rcx,%r10,1)
 10714aa:	movl   $0x0,0x60(%rsp)
 10714b2:	jne    1071b39 <check_input_run+0x4e29>
 10714b8:	lea    0x4(%r8),%esi
 10714bc:	mov    %rsi,0x48(%rsp)
 10714c1:	cmp    %edi,0x48(%rsp)
 10714c5:	ja     1071724 <check_input_run+0x4a14>
 10714cb:	mov    0x48(%rsp),%r8d
 10714d0:	movzbl (%rcx,%r8,1),%esi
 10714d5:	mov    %esi,0xa0(%rsp)
 10714dc:	cmp    $0x1,%esi
 10714df:	je     1071b43 <check_input_run+0x4e33>
 10714e5:	cmpl   $0xfd,0xa0(%rsp)
 10714f0:	je     1071500 <check_input_run+0x47f0>
 10714f2:	cmpl   $0x2,0xa0(%rsp)
 10714fa:	jne    1071724 <check_input_run+0x4a14>
 1071500:	mov    0x48(%rsp),%rsi
 1071505:	mov    0x110(%rsp),%r9d
 107150d:	lea    0x1(%rsi),%r8d
 1071511:	mov    $0x1,%sil
 1071514:	mov    %esi,0x60(%rsp)
 1071518:	jmp    1071535 <check_input_run+0x4825>
 107151a:	mov    $0xffffffff,%esi
 107151f:	movl   $0x0,0x88(%rsp)
 107152a:	xor    %r9d,%r9d
 107152d:	mov    %r10d,%r8d
 1071530:	mov    %rsi,0x48(%rsp)
 1071535:	mov    $0x1,%sil
 1071538:	movl   $0x0,0x118(%rsp)
 1071543:	movl   $0x0,0x68(%rsp)
 107154b:	mov    %esi,0xa0(%rsp)
 1071552:	cmp    %edi,%r8d
 1071555:	ja     107177a <check_input_run+0x4a6a>
 107155b:	mov    %r8d,%edi
 107155e:	neg    %edi
 1071560:	movl   $0x0,0x118(%rsp)
 107156b:	movl   $0x0,0x68(%rsp)
 1071573:	add    %r14,%rdi
 1071576:	cmp    %edx,%edi
 1071578:	jne    107177a <check_input_run+0x4a6a>
 107157e:	mov    %r8d,%edx
 1071581:	cmpb   $0x10,(%rcx,%rdx,1)
 1071585:	jne    107177a <check_input_run+0x4a6a>
 107158b:	mov    $0x1,%dl
 107158d:	mov    %edx,0x118(%rsp)
 1071594:	test   %r9b,%r9b
 1071597:	je     1071767 <check_input_run+0x4a57>
 107159d:	mov    0x48(%rsp),%edx
 10715a1:	movzbl (%rcx,%rdx,1),%r9d
 10715a6:	cmp    $0xfd,%r9b
 10715aa:	jne    10715be <check_input_run+0x48ae>
 10715ac:	mov    0xd8(%rsp),%rax
 10715b4:	xor    %ecx,%ecx
 10715b6:	mov    (%rax,%rdx,4),%eax
 10715b9:	jmp    10716c6 <check_input_run+0x49b6>
 10715be:	mov    0x828(%rax),%rax
 10715c5:	mov    0x2c8(%rsp),%rdi
 10715cd:	mov    (%rax,%rdx,4),%ecx
 10715d0:	mov    0xd8(%rsp),%rax
 10715d8:	mov    0x8(%rdi),%r12
 10715dc:	mov    (%rax,%rdx,4),%edx
 10715df:	mov    %edx,%eax
 10715e1:	sub    %ecx,%eax
 10715e3:	jb     107160a <check_input_run+0x48fa>
 10715e5:	mov    0x10(%rdi),%rsi
 10715e9:	sub    %r12,%rsi
 10715ec:	jb     107160a <check_input_run+0x48fa>
 10715ee:	mov    $0x0,%r8d
 10715f4:	cmp    %rax,%rsi
 10715f7:	jbe    107160d <check_input_run+0x48fd>
 10715f9:	mov    (%rdi),%r8
 10715fc:	lea    0x1(%r12,%rax,1),%rax
 1071601:	mov    %rax,0x8(%rdi)
 1071605:	add    %r12,%r8
 1071608:	jmp    107160d <check_input_run+0x48fd>
 107160a:	xor    %r8d,%r8d
 107160d:	mov    0x2a0(%rsp),%rdi
 1071615:	cmp    %ecx,%edx
 1071617:	setae  %al
 107161a:	test   %r8,%r8
 107161d:	sete   %sil
 1071621:	and    %al,%sil
 1071624:	or     %sil,0x3bd(%rdi)
 107162b:	test   %r8,%r8
 107162e:	je     1071752 <check_input_run+0x4a42>
 1071634:	mov    0x2b0(%rsp),%rdi
 107163c:	movzbl %r9b,%esi
 1071640:	lea    0x700(%rsp),%r9
 1071648:	movq   $0x0,0x700(%rsp)
 1071654:	call   1048470 <pp_spelling>
 1071659:	mov    0x700(%rsp),%rsi
 1071661:	mov    0x2c8(%rsp),%rcx
 1071669:	lea    0x780(%rsp),%rdi
 1071671:	mov    %eax,%edx
 1071673:	call   108f480 <check_literal_number>
 1071678:	movzbl 0x7a3(%rsp),%edx
 1071680:	mov    0x2a0(%rsp),%rdi
 1071688:	movzbl 0x7a1(%rsp),%ecx
 1071690:	mov    0x788(%rsp),%rax
 1071698:	movzbl 0x7a2(%rsp),%esi
 10716a0:	or     0x7a0(%rsp),%cl
 10716a7:	and    $0x1,%dl
 10716aa:	or     %dl,0x3bd(%rdi)
 10716b0:	mov    0x2c8(%rsp),%rdx
 10716b8:	mov    %r12,0x8(%rdx)
 10716bc:	test   $0x1,%sil
 10716c0:	je     1071ae0 <check_input_run+0x4dd0>
 10716c6:	mov    $0x2,%dl
 10716c8:	movl   $0x0,0x68(%rsp)
 10716d0:	mov    %edx,0xa0(%rsp)
 10716d7:	test   $0x1,%cl
 10716da:	jne    1071717 <check_input_run+0x4a07>
 10716dc:	cmp    $0x10,%rax
 10716e0:	ja     1071717 <check_input_run+0x4a07>
 10716e2:	popcnt %rax,%rcx
 10716e7:	cmp    $0x1,%ecx
 10716ea:	ja     1071717 <check_input_run+0x4a07>
 10716ec:	test   %rax,%rax
 10716ef:	je     1071767 <check_input_run+0x4a57>
 10716f1:	cmp    $0x1,%rax
 10716f5:	jne    1071b01 <check_input_run+0x4df1>
 10716fb:	mov    $0x1,%al
 10716fd:	movl   $0x0,0xa0(%rsp)
 1071708:	mov    %eax,0x68(%rsp)
 107170c:	mov    $0x1,%al
 107170e:	mov    %eax,0x118(%rsp)
 1071715:	jmp    107177a <check_input_run+0x4a6a>
 1071717:	movl   $0x0,0x118(%rsp)
 1071722:	jmp    107177a <check_input_run+0x4a6a>
 1071724:	mov    $0xffffffff,%eax
 1071729:	movl   $0x0,0x68(%rsp)
 1071731:	movl   $0x0,0x118(%rsp)
 107173c:	mov    %rax,0x48(%rsp)
 1071741:	mov    $0x1,%al
 1071743:	mov    %eax,0xa0(%rsp)
 107174a:	mov    $0x1,%al
 107174c:	mov    %eax,0x60(%rsp)
 1071750:	jmp    107177a <check_input_run+0x4a6a>
 1071752:	mov    0x2c8(%rsp),%rax
 107175a:	mov    %r12,0x8(%rax)
 107175e:	mov    $0x3,%al
 1071760:	mov    %eax,0x110(%rsp)
 1071767:	movl   $0x0,0x68(%rsp)
 107176f:	movl   $0x0,0xa0(%rsp)
 107177a:	mov    0x90(%rsp),%r12
 1071782:	mov    0x150(%rsp),%rdi
 107178a:	mov    %r15d,%edx
 107178d:	sub    0xd0(%rsp),%edx
 1071794:	add    0x1b0(%rsp),%rdi
 107179c:	mov    0x14(%r12),%esi
 10717a1:	call   788120 <memset@plt>
 10717a6:	mov    0x10(%r12),%ecx
 10717ab:	movzbl 0x14(%r12),%eax
 10717b1:	cmpb   $0x0,0x118(%rsp)
 10717b9:	mov    $0xffffffff,%edx
 10717be:	je     1071814 <check_input_run+0x4b04>
 10717c0:	cmpb   $0x1,0x110(%rsp)
 10717c8:	jne    1071814 <check_input_run+0x4b04>
 10717ca:	movzbl 0xc0(%rsp),%esi
 10717d2:	movl   $0x0,0xa0(%rsp)
 10717dd:	dec    %esi
 10717df:	cmp    $0x4,%esi
 10717e2:	ja     1071943 <check_input_run+0x4c33>
 10717e8:	lea    -0xbd4227(%rip),%rdi        # 49d5c8 <cbuiltin_test_generated.edges+0x3788>
 10717ef:	movslq (%rdi,%rsi,4),%rsi
 10717f3:	add    %rdi,%rsi
 10717f6:	jmp    *%rsi
 10717f8:	mov    0x90(%rsp),%rsi
 1071800:	movl   $0x0,0xa0(%rsp)
 107180b:	movb   $0x0,0x14(%rsi)
 107180f:	jmp    1071943 <check_input_run+0x4c33>
 1071814:	mov    %eax,%edi
 1071816:	mov    $0xffffffff,%esi
 107181b:	jmp    10711e4 <check_input_run+0x44d4>
 1071820:	mov    0x90(%rsp),%rsi
 1071828:	lea    0x1(%rcx),%edx
 107182b:	cmpl   $0x0,0x88(%rsp)
 1071833:	mov    0x8(%rsi),%edi
 1071836:	mov    %edx,0x10(%rsi)
 1071839:	mov    0xc8(%rsp),%rdx
 1071841:	mov    $0xffffffff,%esi
 1071846:	mov    %edi,(%rdx,%rcx,4)
 1071849:	mov    $0xffffffff,%edx
 107184e:	je     107197c <check_input_run+0x4c6c>
 1071854:	mov    0x88(%rsp),%edx
 107185b:	movabs $0x9e3779b97f4a7c15,%r8
 1071865:	imul   %r8,%rdx
 1071869:	mov    0x70(%rsp),%r10
 107186e:	mov    %rdx,%r8
 1071871:	and    %rbp,%r8
 1071874:	mov    (%r10,%r8,8),%r9d
 1071878:	test   %r9d,%r9d
 107187b:	je     107188b <check_input_run+0x4b7b>
 107187d:	lea    0x1(%r8),%rdx
 1071881:	cmp    0x88(%rsp),%r9d
 1071889:	jne    1071869 <check_input_run+0x4b59>
 107188b:	test   %r9d,%r9d
 107188e:	je     107194a <check_input_run+0x4c3a>
 1071894:	mov    0x70(%rsp),%rdx
 1071899:	mov    0x4(%rdx,%r8,8),%edx
 107189e:	jmp    1071972 <check_input_run+0x4c62>
 10718a3:	cmpl   $0x0,0x88(%rsp)
 10718ab:	setne  %sil
 10718af:	and    0x60(%rsp),%sil
 10718b4:	shl    $0x3,%sil
 10718b8:	mov    %esi,0xa0(%rsp)
 10718bf:	test   %ecx,%ecx
 10718c1:	je     1071931 <check_input_run+0x4c21>
 10718c3:	cmpl   $0x0,0x88(%rsp)
 10718cb:	je     10719f7 <check_input_run+0x4ce7>
 10718d1:	mov    0x88(%rsp),%r8d
 10718d9:	movabs $0x9e3779b97f4a7c15,%rsi
 10718e3:	imul   %rsi,%r8
 10718e7:	mov    0x70(%rsp),%rdi
 10718ec:	mov    %r8,%rsi
 10718ef:	and    %rbp,%rsi
 10718f2:	mov    (%rdi,%rsi,8),%edi
 10718f5:	test   %edi,%edi
 10718f7:	je     1071906 <check_input_run+0x4bf6>
 10718f9:	lea    0x1(%rsi),%r8
 10718fd:	cmp    0x88(%rsp),%edi
 1071904:	jne    10718e7 <check_input_run+0x4bd7>
 1071906:	mov    0x70(%rsp),%r8
 107190b:	lea    (%r8,%rsi,8),%rsi
 107190f:	test   %edi,%edi
 1071911:	jne    1071923 <check_input_run+0x4c13>
 1071913:	mov    0x88(%rsp),%edi
 107191a:	mov    %edi,(%rsi)
 107191c:	movl   $0xffffffff,0x4(%rsi)
 1071923:	add    $0x4,%rsi
 1071927:	jmp    1071a06 <check_input_run+0x4cf6>
 107192c:	mov    $0x10,%sil
 107192f:	jmp    107193c <check_input_run+0x4c2c>
 1071931:	mov    0xa0(%rsp),%esi
 1071938:	or     $0x4,%sil
 107193c:	mov    %esi,0xa0(%rsp)
 1071943:	mov    $0xffffffff,%esi
 1071948:	jmp    10719a2 <check_input_run+0x4c92>
 107194a:	mov    0x70(%rsp),%rdx
 107194f:	mov    0x88(%rsp),%edi
 1071956:	mov    %edi,(%rdx,%r8,8)
 107195a:	movl   $0xffffffff,0x4(%rdx,%r8,8)
 1071963:	mov    0x130(%rsp),%rdx
 107196b:	mov    (%rdx),%edi
 107196d:	mov    $0xffffffff,%edx
 1071972:	mov    0x70(%rsp),%r9
 1071977:	mov    %edi,0x4(%r9,%r8,8)
 107197c:	mov    0x90(%rsp),%r9
 1071984:	movl   $0x0,0xa0(%rsp)
 107198f:	mov    0xc(%r9),%edi
 1071993:	mov    0x10(%r9),%r8d
 1071997:	cmp    %edi,%r8d
 107199a:	cmova  %r8d,%edi
 107199e:	mov    %edi,0xc(%r9)
 10719a2:	testb  $0x1,0x60(%rsp)
 10719a7:	je     10719d3 <check_input_run+0x4cc3>
 10719a9:	mov    0x90(%rsp),%rdi
 10719b1:	mov    0x68(%rsp),%r8d
 10719b6:	mov    %r8b,0x14(%rdi)
 10719ba:	mov    $0x1,%dil
 10719bd:	mov    %edi,0x110(%rsp)
 10719c4:	mov    $0x1,%dil
 10719c7:	mov    %edi,0x60(%rsp)
 10719cb:	mov    %r8d,%edi
 10719ce:	jmp    10711e4 <check_input_run+0x44d4>
 10719d3:	mov    0x90(%rsp),%rdi
 10719db:	mov    $0x1,%r8b
 10719de:	movl   $0x0,0x60(%rsp)
 10719e6:	mov    %r8d,0x110(%rsp)
 10719ee:	movzbl 0x14(%rdi),%edi
 10719f2:	jmp    10711e4 <check_input_run+0x44d4>
 10719f7:	mov    0xc8(%rsp),%rdi
 10719ff:	lea    -0x1(%rcx),%esi
 1071a02:	lea    (%rdi,%rsi,4),%rsi
 1071a06:	mov    (%rsi),%esi
 1071a08:	mov    $0xffffffff,%edi
 1071a0d:	cmp    %rdi,%rsi
 1071a10:	je     1071943 <check_input_run+0x4c33>
 1071a16:	mov    0xe8(%rsp),%r9
 1071a1e:	imul   $0x34,%rsi,%r8
 1071a22:	mov    0x90(%rsp),%r10
 1071a2a:	mov    0x24(%r9,%r8,1),%edi
 1071a2f:	movzbl 0x2e(%r9,%r8,1),%r8d
 1071a35:	mov    %r8b,0x14(%r10)
 1071a39:	mov    0x10(%r10),%r9d
 1071a3d:	jmp    1071a55 <check_input_run+0x4d45>
 1071a3f:	mov    0x70(%rsp),%r8
 1071a44:	mov    %r9d,0x4(%r8,%r10,8)
 1071a49:	mov    0x90(%rsp),%r9
 1071a51:	mov    0x10(%r9),%r9d
 1071a55:	cmp    %edi,%r9d
 1071a58:	jbe    10719a2 <check_input_run+0x4c92>
 1071a5e:	mov    0x90(%rsp),%r8
 1071a66:	mov    0xc8(%rsp),%r10
 1071a6e:	dec    %r9d
 1071a71:	mov    0xe8(%rsp),%r11
 1071a79:	mov    %r9d,0x10(%r8)
 1071a7d:	mov    (%r10,%r9,4),%r8d
 1071a81:	imul   $0x34,%r8,%r10
 1071a85:	mov    0x18(%r11,%r10,1),%r8d
 1071a8a:	test   %r8,%r8
 1071a8d:	je     1071a55 <check_input_run+0x4d45>
 1071a8f:	add    0xe8(%rsp),%r10
 1071a97:	mov    %r8,%r12
 1071a9a:	mov    0x20(%r10),%r9d
 1071a9e:	movabs $0x9e3779b97f4a7c15,%r10
 1071aa8:	imul   %r10,%r12
 1071aac:	mov    0x70(%rsp),%r11
 1071ab1:	mov    %r12,%r10
 1071ab4:	and    %rbp,%r10
 1071ab7:	mov    (%r11,%r10,8),%r11d
 1071abb:	test   %r11d,%r11d
 1071abe:	je     1071ac9 <check_input_run+0x4db9>
 1071ac0:	lea    0x1(%r10),%r12
 1071ac4:	cmp    %r8d,%r11d
 1071ac7:	jne    1071aac <check_input_run+0x4d9c>
 1071ac9:	test   %r11d,%r11d
 1071acc:	jne    1071a3f <check_input_run+0x4d2f>
 1071ad2:	mov    0x70(%rsp),%r11
 1071ad7:	mov    %r8d,(%r11,%r10,8)
 1071adb:	jmp    1071a3f <check_input_run+0x4d2f>
 1071ae0:	mov    $0x3,%al
 1071ae2:	movl   $0x0,0x68(%rsp)
 1071aea:	movl   $0x0,0xa0(%rsp)
 1071af5:	mov    %eax,0x110(%rsp)
 1071afc:	jmp    107177a <check_input_run+0x4a6a>
 1071b01:	mov    $0x1,%cl
 1071b03:	mov    %ecx,0x118(%rsp)
 1071b0a:	mov    $0x1,%cl
 1071b0c:	mov    %ecx,0x68(%rsp)
 1071b10:	mov    %rax,%rcx
 1071b13:	mov    0x68(%rsp),%edx
 1071b17:	shr    $1,%rcx
 1071b1a:	movl   $0x0,0xa0(%rsp)
 1071b25:	inc    %dl
 1071b27:	mov    %edx,0x68(%rsp)
 1071b2b:	cmp    $0x3,%rax
 1071b2f:	mov    %rcx,%rax
 1071b32:	ja     1071b13 <check_input_run+0x4e03>
 1071b34:	jmp    107177a <check_input_run+0x4a6a>
 1071b39:	mov    $0xffffffff,%esi
 1071b3e:	jmp    107152d <check_input_run+0x481d>
 1071b43:	mov    0xa0(%rsp),%ecx
 1071b4a:	mov    $0xffffffff,%eax
 1071b4f:	movl   $0x0,0x68(%rsp)
 1071b57:	movl   $0x0,0x118(%rsp)
 1071b62:	movl   $0x0,0x110(%rsp)
 1071b6d:	mov    %rax,0x48(%rsp)
 1071b72:	mov    %ecx,0x60(%rsp)
 1071b76:	jmp    107177a <check_input_run+0x4a6a>
 1071b7b:	mov    0x28(%rsp),%r9
 1071b80:	mov    0x90(%rsp),%rcx
 1071b88:	test   %r8b,%r8b
 1071b8b:	mov    0x98(%rsp),%r8
 1071b93:	je     1071df7 <check_input_run+0x50e7>
 1071b99:	mov    0xd0(%rsp),%eax
 1071ba0:	mov    0x1b0(%rsp),%rdx
 1071ba8:	mov    0x14(%rcx),%esi
 1071bab:	sub    %rax,%r8
 1071bae:	lea    (%rdx,%rax,1),%rdi
 1071bb2:	inc    %r8
 1071bb5:	mov    %r8,%rdx
 1071bb8:	call   788120 <memset@plt>
 1071bbd:	mov    0x2c8(%rsp),%rcx
 1071bc5:	mov    0x2a8(%rsp),%r14
 1071bcd:	mov    $0x1,%al
 1071bcf:	mov    (%rcx),%rdi
 1071bd2:	mov    0x8(%rcx),%rsi
 1071bd6:	mov    0x30(%r14),%ebp
 1071bda:	lea    0x3(%rsi,%rdi,1),%r15
 1071bdf:	lea    0x4(,%rbp,4),%rdx
 1071be7:	lea    0x1(%rbp),%r8
 1071beb:	add    %rdi,%rsi
 1071bee:	and    $0xfffffffffffffffc,%r15
 1071bf2:	cmp    %rsi,%r15
 1071bf5:	jae    1071ca7 <check_input_run+0x4f97>
 1071bfb:	mov    0x28(%rsp),%r9
 1071c00:	xor    %r15d,%r15d
 1071c03:	xor    %r13d,%r13d
 1071c06:	jmp    1071dd9 <check_input_run+0x50c9>
 1071c0b:	mov    0x10(%rsi),%rsi
 1071c0f:	mov    %rcx,%rdx
 1071c12:	sub    %rax,%rdx
 1071c15:	sub    %rdx,%rsi
 1071c18:	jb     1071d19 <check_input_run+0x5009>
 1071c1e:	mov    0x78(%rsp),%rax
 1071c23:	lea    0x4(,%rax,4),%rax
 1071c2b:	cmp    %rsi,%rax
 1071c2e:	ja     1071d19 <check_input_run+0x5009>
 1071c34:	mov    0x18(%rsp),%rsi
 1071c39:	mov    0x10(%rsp),%r8
 1071c3e:	add    %rax,%rdx
 1071c41:	lea    0x238(%rsi),%rdi
 1071c48:	mov    %rdx,0x8(%r8)
 1071c4c:	mov    %rcx,0x238(%rsi)
 1071c53:	mov    %rdi,0x68(%rsp)
 1071c58:	test   %rcx,%rcx
 1071c5b:	je     1071c79 <check_input_run+0x4f69>
 1071c5d:	mov    (%r8),%rsi
 1071c60:	mov    0x8(%r8),%rdx
 1071c64:	lea    0x3(%rdx,%rsi,1),%rcx
 1071c69:	add    %rsi,%rdx
 1071c6c:	and    $0xfffffffffffffffc,%rcx
 1071c70:	cmp    %rdx,%rcx
 1071c73:	jae    10777be <check_input_run+0xaaae>
 1071c79:	mov    0x18(%rsp),%rdi
 1071c7e:	mov    %r8,%rsi
 1071c81:	movq   $0x0,0x240(%rdi)
 1071c8c:	movq   $0x0,0x248(%rdi)
 1071c97:	movq   $0x0,0x260(%rdi)
 1071ca2:	jmp    106d556 <check_input_run+0x846>
 1071ca7:	mov    %r15,%rsi
 1071caa:	sub    %rdi,%rsi
 1071cad:	mov    0x10(%rcx),%rdi
 1071cb1:	mov    0x28(%rsp),%r9
 1071cb6:	xor    %r13d,%r13d
 1071cb9:	sub    %rsi,%rdi
 1071cbc:	jb     1071dd6 <check_input_run+0x50c6>
 1071cc2:	cmp    %rdi,%rdx
 1071cc5:	ja     1071dd6 <check_input_run+0x50c6>
 1071ccb:	add    %rdx,%rsi
 1071cce:	mov    %rsi,0x8(%rcx)
 1071cd2:	test   %r15,%r15
 1071cd5:	je     1071c00 <check_input_run+0x4ef0>
 1071cdb:	mov    0x2c8(%rsp),%rcx
 1071ce3:	xor    %r13d,%r13d
 1071ce6:	mov    $0x0,%eax
 1071ceb:	mov    0x8(%rcx),%rsi
 1071cef:	mov    0x10(%rcx),%rdi
 1071cf3:	sub    %rsi,%rdi
 1071cf6:	jb     1071dd9 <check_input_run+0x50c9>
 1071cfc:	cmp    %rbp,%rdi
 1071cff:	jbe    1071dd9 <check_input_run+0x50c9>
 1071d05:	mov    (%rcx),%r13
 1071d08:	xor    %eax,%eax
 1071d0a:	add    %rsi,%r13
 1071d0d:	add    %r8,%rsi
 1071d10:	mov    %rsi,0x8(%rcx)
 1071d14:	jmp    1071dd9 <check_input_run+0x50c9>
 1071d19:	mov    0x18(%rsp),%rdi
 1071d1e:	jmp    106d519 <check_input_run+0x809>
 1071d23:	mov    %r11,%rsi
 1071d26:	sub    %rdi,%rsi
 1071d29:	mov    0x10(%rax),%rdi
 1071d2d:	xor    %r14d,%r14d
 1071d30:	sub    %rsi,%rdi
 1071d33:	jb     1077581 <check_input_run+0xa871>
 1071d39:	imul   $0x34,%rdx,%r8
 1071d3d:	cmp    %rdi,%r8
 1071d40:	ja     1077581 <check_input_run+0xa871>
 1071d46:	add    %r8,%rsi
 1071d49:	mov    %rsi,0x8(%rax)
 1071d4d:	test   %r11,%r11
 1071d50:	je     1070f41 <check_input_run+0x4231>
 1071d56:	mov    0x2c0(%rsp),%rax
 1071d5e:	xor    %r14d,%r14d
 1071d61:	mov    0x8(%rax),%r8
 1071d65:	mov    0x10(%rax),%rsi
 1071d69:	sub    %r8,%rsi
 1071d6c:	jb     1070f52 <check_input_run+0x4242>
 1071d72:	mov    %r8,%rdi
 1071d75:	mov    0x98(%rsp),%r8
 1071d7d:	cmp    %r8,%rsi
 1071d80:	jbe    1070f52 <check_input_run+0x4242>
 1071d86:	lea    0x1(%r8,%rdi,1),%rsi
 1071d8b:	add    (%rax),%rdi
 1071d8e:	mov    %rsi,0x8(%rax)
 1071d92:	mov    %rdi,0x1b0(%rsp)
 1071d9a:	je     10790d9 <check_input_run+0xc3c9>
 1071da0:	mov    0x2c8(%rsp),%rsi
 1071da8:	mov    (%rsi),%r8
 1071dab:	mov    0x8(%rsi),%rdi
 1071daf:	lea    0x3(%rdi,%r8,1),%rax
 1071db4:	add    %r8,%rdi
 1071db7:	and    $0xfffffffffffffffc,%rax
 1071dbb:	cmp    %rdi,%rax
 1071dbe:	jae    10798e4 <check_input_run+0xcbd4>
 1071dc4:	xor    %r14d,%r14d
 1071dc7:	mov    0x20(%rsp),%r12
 1071dcc:	mov    0x28(%rsp),%r9
 1071dd1:	jmp    1070f5e <check_input_run+0x424e>
 1071dd6:	xor    %r15d,%r15d
 1071dd9:	mov    0x2a0(%rsp),%rsi
 1071de1:	test   %r13,%r13
 1071de4:	sete   %cl
 1071de7:	or     %al,%cl
 1071de9:	or     %cl,0x3bd(%rsi)
 1071def:	test   %cl,%cl
 1071df1:	je     1075dca <check_input_run+0x90ba>
 1071df7:	mov    0x2c0(%rsp),%rax
 1071dff:	mov    0x210(%rsp),%rcx
 1071e07:	mov    %rcx,0x8(%rax)
 1071e0b:	mov    0x2c8(%rsp),%rax
 1071e13:	mov    %r9,0x8(%rax)
 1071e17:	mov    0x18(%rsp),%rax
 1071e1c:	movb   $0x1,0x3bd(%rax)
 1071e23:	lea    0x2a0(%rsp),%rdi
 1071e2b:	call   1081c10 <check_input_intrinsic_initialize>
 1071e30:	vmovdqa64 -0xbd49fa(%rip),%zmm1        # 49d440 <cbuiltin_test_generated.edges+0x3600>
 1071e3a:	vpxor  %xmm0,%xmm0,%xmm0
 1071e3e:	mov    0x2b0(%rsp),%rcx
 1071e46:	mov    0x2a8(%rsp),%rax
 1071e4e:	movabs $0x64616f6c7265766f,%r9
 1071e58:	mov    0x270(%rcx),%rsi
 1071e5f:	xor    %ecx,%ecx
 1071e61:	vaesenc %zmm0,%zmm1,%zmm1
 1071e67:	mov    0x8(%rsi),%r8
 1071e6b:	mov    (%rsi),%rdi
 1071e6e:	vaesenc %zmm0,%zmm1,%zmm0
 1071e74:	vextracti64x4 $0x1,%zmm0,%ymm1
 1071e7b:	vpxorq %zmm0,%zmm1,%zmm0
 1071e81:	vextracti128 $0x1,%ymm0,%xmm1
 1071e87:	vpxor  %xmm0,%xmm1,%xmm0
 1071e8b:	vpxor  %xmm1,%xmm1,%xmm1
 1071e8f:	vaesenc %xmm1,%xmm0,%xmm0
 1071e94:	vmovq  %xmm0,%rdx
 1071e99:	vbroadcasti32x4 -0xae2be3(%rip),%zmm0        # 58f2c0 <abi_test_hex.digits+0xaf0>
 1071ea3:	and    %r8,%rdx
 1071ea6:	cs nopw 0x0(%rax,%rax,1)
 1071eb0:	mov    %rdx,%r10
 1071eb3:	shl    $0x6,%r10
 1071eb7:	vmovdqa64 (%rdi,%r10,1),%zmm1
 1071ebe:	vpcmpeqd %zmm0,%zmm1,%k0
 1071ec4:	kmovd  %k0,%r11d
 1071ec8:	and    $0x7777,%r11d
 1071ecf:	add    $0x1111,%r11d
 1071ed6:	and    $0x8888,%r11w
 1071edc:	je     1071f50 <check_input_run+0x5240>
 1071ede:	mov    0x10(%rsi),%rbx
 1071ee2:	add    %rdi,%r10
 1071ee5:	movzwl %r11w,%r11d
 1071ee9:	jmp    1071efe <check_input_run+0x51ee>
 1071eeb:	nopl   0x0(%rax,%rax,1)
 1071ef0:	xor    %ebp,%ebp
 1071ef2:	test   %bpl,%bpl
 1071ef5:	jne    1071f52 <check_input_run+0x5242>
 1071ef7:	blsr   %r11d,%r11d
 1071efc:	je     1071f52 <check_input_run+0x5242>
 1071efe:	xor    %r14d,%r14d
 1071f01:	tzcnt  %r11d,%r14d
 1071f06:	mov    (%r10,%r14,4),%r14d
 1071f0a:	cmpl   $0xc,0x4(%rbx,%r14,8)
 1071f10:	jne    1071ef0 <check_input_run+0x51e0>
 1071f12:	mov    0x40(%rsi),%r15
 1071f16:	mov    (%rbx,%r14,8),%r12d
 1071f1a:	mov    (%r15,%r12,1),%r13
 1071f1e:	mov    0x8(%r15,%r12,1),%r15d
 1071f23:	mov    0x20(%rsp),%r12
 1071f28:	xor    %r9,%r13
 1071f2b:	xor    $0x656c6261,%r15
 1071f32:	or     %r13,%r15
 1071f35:	sete   %bpl
 1071f39:	cmove  %r14d,%ecx
 1071f3d:	test   %bpl,%bpl
 1071f40:	je     1071ef7 <check_input_run+0x51e7>
 1071f42:	jmp    1071f52 <check_input_run+0x5242>
 1071f44:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1071f50:	xor    %ebp,%ebp
 1071f52:	vptestnmd %zmm1,%zmm1,%k0
 1071f58:	kmovd  %k0,%r10d
 1071f5c:	test   $0x8888,%r10d
 1071f63:	jne    1071f74 <check_input_run+0x5264>
 1071f65:	inc    %rdx
 1071f68:	and    %r8,%rdx
 1071f6b:	test   %bpl,%bpl
 1071f6e:	je     1071eb0 <check_input_run+0x51a0>
 1071f74:	vmovdqa64 -0xbd4abe(%rip),%zmm1        # 49d4c0 <cbuiltin_test_generated.edges+0x3680>
 1071f7e:	vpxor  %xmm0,%xmm0,%xmm0
 1071f82:	xor    %edx,%edx
 1071f84:	vaesenc %zmm0,%zmm1,%zmm1
 1071f8a:	vaesenc %zmm0,%zmm1,%zmm0
 1071f90:	vextracti64x4 $0x1,%zmm0,%ymm1
 1071f97:	vpxorq %zmm0,%zmm1,%zmm0
 1071f9d:	vextracti128 $0x1,%ymm0,%xmm1
 1071fa3:	vpxor  %xmm0,%xmm1,%xmm0
 1071fa7:	vpxor  %xmm1,%xmm1,%xmm1
 1071fab:	vaesenc %xmm1,%xmm0,%xmm0
 1071fb0:	vmovdqa -0xae2d68(%rip),%xmm1        # 58f250 <abi_test_hex.digits+0xa80>
 1071fb8:	vmovq  %xmm0,%r9
 1071fbd:	vbroadcasti32x4 -0xae2d77(%rip),%zmm0        # 58f250 <abi_test_hex.digits+0xa80>
 1071fc7:	nopw   0x0(%rax,%rax,1)
 1071fd0:	and    %r8,%r9
 1071fd3:	mov    %r9,%r10
 1071fd6:	shl    $0x6,%r10
 1071fda:	vmovdqa64 (%rdi,%r10,1),%zmm2
 1071fe1:	vpcmpeqd %zmm0,%zmm2,%k0
 1071fe7:	kmovd  %k0,%r11d
 1071feb:	and    $0x7777,%r11d
 1071ff2:	add    $0x1111,%r11d
 1071ff9:	and    $0x8888,%r11w
 1071fff:	je     1072060 <check_input_run+0x5350>
 1072001:	mov    0x10(%rsi),%rbx
 1072005:	add    %rdi,%r10
 1072008:	movzwl %r11w,%r11d
 107200c:	jmp    107201e <check_input_run+0x530e>
 107200e:	xchg   %ax,%ax
 1072010:	xor    %ebp,%ebp
 1072012:	test   %bpl,%bpl
 1072015:	jne    1072062 <check_input_run+0x5352>
 1072017:	blsr   %r11d,%r11d
 107201c:	je     1072062 <check_input_run+0x5352>
 107201e:	xor    %r14d,%r14d
 1072021:	tzcnt  %r11d,%r14d
 1072026:	mov    (%r10,%r14,4),%r14d
 107202a:	cmpl   $0x10,0x4(%rbx,%r14,8)
 1072030:	jne    1072010 <check_input_run+0x5300>
 1072032:	mov    0x40(%rsi),%r15
 1072036:	mov    (%rbx,%r14,8),%r12d
 107203a:	vpxor  (%r15,%r12,1),%xmm1,%xmm3
 1072040:	mov    0x20(%rsp),%r12
 1072045:	vptest %xmm3,%xmm3
 107204a:	sete   %bpl
 107204e:	cmove  %r14d,%edx
 1072052:	test   %bpl,%bpl
 1072055:	je     1072017 <check_input_run+0x5307>
 1072057:	jmp    1072062 <check_input_run+0x5352>
 1072059:	nopl   0x0(%rax)
 1072060:	xor    %ebp,%ebp
 1072062:	vptestnmd %zmm2,%zmm2,%k0
 1072068:	kmovd  %k0,%r10d
 107206c:	test   $0x8888,%r10d
 1072073:	jne    1072081 <check_input_run+0x5371>
 1072075:	inc    %r9
 1072078:	test   %bpl,%bpl
 107207b:	je     1071fd0 <check_input_run+0x52c0>
 1072081:	mov    0x30(%rax),%esi
 1072084:	test   %rsi,%rsi
 1072087:	je     10720a5 <check_input_run+0x5395>
 1072089:	mov    0x18(%rax),%r8
 107208d:	mov    0x50(%rax),%r9
 1072091:	cmp    $0x8,%esi
 1072094:	jae    10720b4 <check_input_run+0x53a4>
 1072096:	xor    %r10d,%r10d
 1072099:	xor    %r11d,%r11d
 107209c:	xor    %ebx,%ebx
 107209e:	xor    %edi,%edi
 10720a0:	jmp    1072450 <check_input_run+0x5740>
 10720a5:	mov    0x2a0(%rsp),%r14
 10720ad:	xor    %ebp,%ebp
 10720af:	jmp    10726f6 <check_input_run+0x59e6>
 10720b4:	cmp    $0x40,%esi
 10720b7:	jae    10720c8 <check_input_run+0x53b8>
 10720b9:	xor    %r10d,%r10d
 10720bc:	xor    %r11d,%r11d
 10720bf:	xor    %ebx,%ebx
 10720c1:	xor    %edi,%edi
 10720c3:	jmp    1072350 <check_input_run+0x5640>
 10720c8:	vpbroadcastb -0xbd4b0e(%rip),%xmm7        # 49d5c3 <cbuiltin_test_generated.edges+0x3783>
 10720d1:	vpbroadcastb -0xbd4b16(%rip),%xmm8        # 49d5c4 <cbuiltin_test_generated.edges+0x3784>
 10720da:	vpbroadcastb -0xbd4b1e(%rip),%xmm9        # 49d5c5 <cbuiltin_test_generated.edges+0x3785>
 10720e3:	mov    %esi,%r10d
 10720e6:	and    $0xffffffc0,%r10d
 10720ea:	vpbroadcastd %ecx,%zmm5
 10720f0:	vpbroadcastd %edx,%zmm6
 10720f6:	kxorw  %k0,%k0,%k4
 10720fa:	kxorw  %k0,%k0,%k1
 10720fe:	kxorw  %k0,%k0,%k2
 1072102:	kxorw  %k0,%k0,%k3
 1072106:	vpxor  %xmm0,%xmm0,%xmm0
 107210a:	xor    %edi,%edi
 107210c:	vpxor  %xmm10,%xmm10,%xmm10
 1072111:	vpxor  %xmm11,%xmm11,%xmm11
 1072116:	vpxor  %xmm12,%xmm12,%xmm12
 107211b:	vpxor  %xmm1,%xmm1,%xmm1
 107211f:	vpxor  %xmm2,%xmm2,%xmm2
 1072123:	vpxor  %xmm3,%xmm3,%xmm3
 1072127:	vpxor  %xmm4,%xmm4,%xmm4
 107212b:	nopl   0x0(%rax,%rax,1)
 1072130:	vmovdqu64 (%r8,%rdi,4),%zmm13
 1072137:	vmovdqu64 0x40(%r8,%rdi,4),%zmm14
 107213f:	vmovdqu64 0x80(%r8,%rdi,4),%zmm15
 1072147:	vmovdqu64 0xc0(%r8,%rdi,4),%zmm16
 107214f:	kmovw  %k3,0x50(%rsp)
 1072155:	kmovq  %k2,%k3
 107215a:	kmovq  %k1,%k2
 107215f:	kmovq  %k4,%k1
 1072164:	vpcmpeqd %zmm5,%zmm13,%k4
 107216a:	vpcmpeqd %zmm6,%zmm13,%k0
 1072170:	vpcmpeqd %zmm5,%zmm14,%k5
 1072176:	vpcmpeqd %zmm5,%zmm15,%k6
 107217c:	vpcmpeqd %zmm5,%zmm16,%k7
 1072182:	korw   %k0,%k4,%k4
 1072186:	vpcmpeqd %zmm6,%zmm14,%k0
 107218c:	korw   %k0,%k5,%k5
 1072190:	vpcmpeqd %zmm6,%zmm15,%k0
 1072196:	korw   %k0,%k6,%k6
 107219a:	vpcmpeqd %zmm6,%zmm16,%k0
 10721a0:	korw   %k0,%k7,%k7
 10721a4:	vptestmd %zmm13,%zmm13,%k0{%k4}
 10721aa:	kmovq  %k1,%k4
 10721af:	kmovq  %k2,%k1
 10721b4:	vmovdqu (%r9,%rdi,1),%xmm13
 10721ba:	kmovq  %k3,%k2
 10721bf:	kmovw  0x50(%rsp),%k3
 10721c5:	korw   %k0,%k4,%k4
 10721c9:	vptestmd %zmm14,%zmm14,%k0{%k5}
 10721cf:	vmovdqu 0x10(%r9,%rdi,1),%xmm14
 10721d6:	korw   %k0,%k1,%k1
 10721da:	vptestmd %zmm15,%zmm15,%k0{%k6}
 10721e0:	vmovdqu 0x20(%r9,%rdi,1),%xmm15
 10721e7:	korw   %k0,%k2,%k2
 10721eb:	vptestmd %zmm16,%zmm16,%k0{%k7}
 10721f1:	vmovdqu64 0x30(%r9,%rdi,1),%xmm16
 10721f9:	add    $0x40,%rdi
 10721fd:	korw   %k0,%k3,%k3
 1072201:	vpcmpeqb %xmm7,%xmm13,%k0
 1072207:	vpand  %xmm8,%xmm13,%xmm13
 107220c:	vpmovm2d %k0,%zmm17
 1072212:	vpcmpeqb %xmm7,%xmm14,%k0
 1072218:	vpand  %xmm8,%xmm14,%xmm14
 107221d:	vpsubd %zmm17,%zmm0,%zmm0
 1072223:	vpmovm2d %k0,%zmm18
 1072229:	vpcmpeqb %xmm7,%xmm15,%k0
 107222f:	vpand  %xmm8,%xmm15,%xmm15
 1072234:	vpsubd %zmm18,%zmm10,%zmm10
 107223a:	vpmovm2d %k0,%zmm19
 1072240:	vpcmpeqb %xmm7,%xmm16,%k0
 1072246:	vpandq %xmm8,%xmm16,%xmm16
 107224c:	vpsubd %zmm19,%zmm11,%zmm11
 1072252:	vpmovm2d %k0,%zmm20
 1072258:	vpcmpeqb %xmm9,%xmm13,%k0
 107225e:	vpsubd %zmm20,%zmm12,%zmm12
 1072264:	vpmovm2d %k0,%zmm13
 107226a:	vpcmpeqb %xmm9,%xmm14,%k0
 1072270:	vpsubd %zmm13,%zmm1,%zmm1
 1072276:	vpmovm2d %k0,%zmm14
 107227c:	vpcmpeqb %xmm9,%xmm15,%k0
 1072282:	vpsubd %zmm14,%zmm2,%zmm2
 1072288:	vpmovm2d %k0,%zmm15
 107228e:	vpcmpeqb %xmm9,%xmm16,%k0
 1072294:	vpsubd %zmm15,%zmm3,%zmm3
 107229a:	vpmovm2d %k0,%zmm16
 10722a0:	vpsubd %zmm16,%zmm4,%zmm4
 10722a6:	cmp    %rdi,%r10
 10722a9:	jne    1072130 <check_input_run+0x5420>
 10722af:	vpaddd %zmm0,%zmm10,%zmm0
 10722b5:	vpaddd %zmm11,%zmm12,%zmm5
 10722bb:	vpaddd %zmm1,%zmm2,%zmm1
 10722c1:	vpaddd %zmm3,%zmm4,%zmm2
 10722c7:	korw   %k4,%k1,%k0
 10722cb:	vpaddd %zmm0,%zmm5,%zmm0
 10722d1:	korw   %k0,%k2,%k0
 10722d5:	vextracti64x4 $0x1,%zmm0,%ymm5
 10722dc:	kortestw %k0,%k3
 10722e0:	vpaddd %zmm5,%zmm0,%zmm0
 10722e6:	setne  %r11b
 10722ea:	vextracti128 $0x1,%ymm0,%xmm5
 10722f0:	vpaddd %xmm5,%xmm0,%xmm0
 10722f4:	vpshufd $0xee,%xmm0,%xmm5
 10722f9:	vpaddd %xmm5,%xmm0,%xmm0
 10722fd:	vpshufd $0x55,%xmm0,%xmm5
 1072302:	vpaddd %xmm5,%xmm0,%xmm0
 1072306:	vmovd  %xmm0,%ebx
 107230a:	vpaddd %zmm1,%zmm2,%zmm0
 1072310:	vextracti64x4 $0x1,%zmm0,%ymm1
 1072317:	vpaddd %zmm1,%zmm0,%zmm0
 107231d:	vextracti128 $0x1,%ymm0,%xmm1
 1072323:	vpaddd %xmm1,%xmm0,%xmm0
 1072327:	vpshufd $0xee,%xmm0,%xmm1
 107232c:	vpaddd %xmm1,%xmm0,%xmm0
 1072330:	vpshufd $0x55,%xmm0,%xmm1
 1072335:	vpaddd %xmm1,%xmm0,%xmm0
 1072339:	vmovd  %xmm0,%edi
 107233d:	cmp    %esi,%r10d
 1072340:	je     107249c <check_input_run+0x578c>
 1072346:	test   $0x38,%sil
 107234a:	je     1072450 <check_input_run+0x5740>
 1072350:	vpbroadcastb -0xbd4d96(%rip),%xmm4        # 49d5c3 <cbuiltin_test_generated.edges+0x3783>
 1072359:	vpbroadcastb -0xbd4d9e(%rip),%xmm5        # 49d5c4 <cbuiltin_test_generated.edges+0x3784>
 1072362:	vpbroadcastb -0xbd4da6(%rip),%xmm6        # 49d5c5 <cbuiltin_test_generated.edges+0x3785>
 107236b:	mov    %r10,%r14
 107236e:	mov    %esi,%r10d
 1072371:	and    $0xfffffff8,%r10d
 1072375:	test   %r11b,%r11b
 1072378:	vmovd  %ebx,%xmm1
 107237c:	vmovd  %edi,%xmm0
 1072380:	vpbroadcastd %ecx,%ymm2
 1072386:	vpbroadcastd %edx,%ymm3
 107238c:	setne  %r11b
 1072390:	kmovd  %r11d,%k0
 1072395:	data16 cs nopw 0x0(%rax,%rax,1)
 10723a0:	vmovdqu (%r8,%r14,4),%ymm7
 10723a6:	vpcmpeqd %ymm2,%ymm7,%k1
 10723ac:	vpcmpeqd %ymm3,%ymm7,%k2
 10723b2:	korb   %k2,%k1,%k1
 10723b6:	vptestmd %ymm7,%ymm7,%k1{%k1}
 10723bc:	vmovq  (%r9,%r14,1),%xmm7
 10723c2:	add    $0x8,%r14
 10723c6:	korb   %k1,%k0,%k0
 10723ca:	vpcmpeqb %xmm4,%xmm7,%k1
 10723d0:	vpand  %xmm5,%xmm7,%xmm7
 10723d4:	vpmovm2d %k1,%ymm8
 10723da:	vpcmpeqb %xmm6,%xmm7,%k1
 10723e0:	vpsubd %ymm8,%ymm1,%ymm1
 10723e5:	vpmovm2d %k1,%ymm7
 10723eb:	vpsubd %ymm7,%ymm0,%ymm0
 10723ef:	cmp    %r14,%r10
 10723f2:	jne    10723a0 <check_input_run+0x5690>
 10723f4:	vextracti128 $0x1,%ymm1,%xmm2
 10723fa:	kortestb %k0,%k0
 10723fe:	vpaddd %xmm2,%xmm1,%xmm1
 1072402:	setne  %r11b
 1072406:	vpshufd $0xee,%xmm1,%xmm2
 107240b:	vpaddd %xmm2,%xmm1,%xmm1
 107240f:	vpshufd $0x55,%xmm1,%xmm2
 1072414:	vpaddd %xmm2,%xmm1,%xmm1
 1072418:	vmovd  %xmm1,%ebx
 107241c:	vextracti128 $0x1,%ymm0,%xmm1
 1072422:	vpaddd %xmm1,%xmm0,%xmm0
 1072426:	vpshufd $0xee,%xmm0,%xmm1
 107242b:	vpaddd %xmm1,%xmm0,%xmm0
 107242f:	vpshufd $0x55,%xmm0,%xmm1
 1072434:	vpaddd %xmm1,%xmm0,%xmm0
 1072438:	vmovd  %xmm0,%edi
 107243c:	cmp    %esi,%r10d
 107243f:	je     107249c <check_input_run+0x578c>
 1072441:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1072450:	mov    (%r8,%r10,4),%ebp
 1072454:	test   %ebp,%ebp
 1072456:	setne  %r14b
 107245a:	cmp    %ecx,%ebp
 107245c:	sete   %r15b
 1072460:	cmp    %edx,%ebp
 1072462:	sete   %bpl
 1072466:	or     %r15b,%bpl
 1072469:	movzbl (%r9,%r10,1),%r15d
 107246e:	and    %r14b,%bpl
 1072471:	xor    %r14d,%r14d
 1072474:	or     %bpl,%r11b
 1072477:	cmp    $0x2,%r15b
 107247b:	sete   %r14b
 107247f:	and    $0xfe,%r15b
 1072483:	add    %r14d,%ebx
 1072486:	xor    %r14d,%r14d
 1072489:	cmp    $0x3c,%r15b
 107248d:	sete   %r14b
 1072491:	inc    %r10
 1072494:	add    %r14d,%edi
 1072497:	cmp    %r10,%rsi
 107249a:	jne    1072450 <check_input_run+0x5740>
 107249c:	mov    0x2a0(%rsp),%r14
 10724a4:	test   $0x1,%r11b
 10724a8:	je     10724db <check_input_run+0x57cb>
 10724aa:	mov    %ebx,0x488(%rsp)
 10724b1:	mov    %ebx,%ecx
 10724b3:	inc    %rcx
 10724b6:	mov    0x2c0(%rsp),%rdx
 10724be:	mov    (%rdx),%r8
 10724c1:	mov    0x8(%rdx),%r9
 10724c5:	lea    0x3(%r9,%r8,1),%rsi
 10724ca:	add    %r8,%r9
 10724cd:	and    $0xfffffffffffffffc,%rsi
 10724d1:	cmp    %r9,%rsi
 10724d4:	jae    10724e2 <check_input_run+0x57d2>
 10724d6:	xor    %r8d,%r8d
 10724d9:	jmp    1072512 <check_input_run+0x5802>
 10724db:	xor    %ebp,%ebp
 10724dd:	jmp    10726f6 <check_input_run+0x59e6>
 10724e2:	mov    0x10(%rdx),%r10
 10724e6:	mov    %rsi,%r9
 10724e9:	sub    %r8,%r9
 10724ec:	xor    %r8d,%r8d
 10724ef:	sub    %r9,%r10
 10724f2:	jb     1072512 <check_input_run+0x5802>
 10724f4:	mov    %rcx,%r11
 10724f7:	shl    $0x5,%r11
 10724fb:	cmp    %r10,%r11
 10724fe:	ja     1072512 <check_input_run+0x5802>
 1072500:	add    %r11,%r9
 1072503:	mov    %rsi,%r8
 1072506:	mov    %r9,0x8(%rdx)
 107250a:	mov    0x2c0(%rsp),%rdx
 1072512:	mov    %r8,0x480(%rsp)
 107251a:	mov    (%rdx),%r8
 107251d:	mov    0x8(%rdx),%r9
 1072521:	lea    0x3(%r9,%r8,1),%rsi
 1072526:	add    %r8,%r9
 1072529:	and    $0xfffffffffffffffc,%rsi
 107252d:	cmp    %r9,%rsi
 1072530:	jae    1072537 <check_input_run+0x5827>
 1072532:	xor    %r8d,%r8d
 1072535:	jmp    1072564 <check_input_run+0x5854>
 1072537:	mov    0x10(%rdx),%r10
 107253b:	mov    %rsi,%r9
 107253e:	sub    %r8,%r9
 1072541:	xor    %r8d,%r8d
 1072544:	sub    %r9,%r10
 1072547:	jb     1072564 <check_input_run+0x5854>
 1072549:	mov    0x30(%rax),%r11d
 107254d:	lea    0x4(,%r11,4),%r11
 1072555:	cmp    %r10,%r11
 1072558:	ja     1072564 <check_input_run+0x5854>
 107255a:	add    %r11,%r9
 107255d:	mov    %rsi,%r8
 1072560:	mov    %r9,0x8(%rdx)
 1072564:	mov    %r8,0x220(%r14)
 107256b:	mov    0x2c8(%rsp),%rdx
 1072573:	mov    (%rdx),%r8
 1072576:	mov    0x8(%rdx),%r9
 107257a:	lea    0x3(%r9,%r8,1),%rsi
 107257f:	add    %r8,%r9
 1072582:	and    $0xfffffffffffffffc,%rsi
 1072586:	cmp    %r9,%rsi
 1072589:	jae    1072590 <check_input_run+0x5880>
 107258b:	xor    %r8d,%r8d
 107258e:	jmp    10725d0 <check_input_run+0x58c0>
 1072590:	mov    0x10(%rdx),%r10
 1072594:	mov    %rsi,%r9
 1072597:	sub    %r8,%r9
 107259a:	xor    %r8d,%r8d
 107259d:	sub    %r9,%r10
 10725a0:	jb     10725d0 <check_input_run+0x58c0>
 10725a2:	mov    0x2b0(%rsp),%r11
 10725aa:	mov    0x270(%r11),%r11
 10725b1:	mov    0x68(%r11),%r11d
 10725b5:	shl    $0x2,%r11
 10725b9:	cmp    %r10,%r11
 10725bc:	ja     10725d0 <check_input_run+0x58c0>
 10725be:	add    %r11,%r9
 10725c1:	mov    %rsi,%r8
 10725c4:	mov    %r9,0x8(%rdx)
 10725c8:	mov    0x2c8(%rsp),%rdx
 10725d0:	mov    %r8,0x490(%rsp)
 10725d8:	mov    (%rdx),%r8
 10725db:	mov    0x8(%rdx),%r9
 10725df:	lea    0x3(%r9,%r8,1),%rsi
 10725e4:	add    %r8,%r9
 10725e7:	and    $0xfffffffffffffffc,%rsi
 10725eb:	cmp    %r9,%rsi
 10725ee:	jae    10725f5 <check_input_run+0x58e5>
 10725f0:	xor    %r8d,%r8d
 10725f3:	jmp    107261a <check_input_run+0x590a>
 10725f5:	mov    0x10(%rdx),%r10
 10725f9:	mov    %rsi,%r9
 10725fc:	sub    %r8,%r9
 10725ff:	xor    %r8d,%r8d
 1072602:	sub    %r9,%r10
 1072605:	jb     107261a <check_input_run+0x590a>
 1072607:	shl    $0x2,%rcx
 107260b:	cmp    %r10,%rcx
 107260e:	ja     107261a <check_input_run+0x590a>
 1072610:	add    %rcx,%r9
 1072613:	mov    %rsi,%r8
 1072616:	mov    %r9,0x8(%rdx)
 107261a:	mov    %r8,0x498(%rsp)
 1072622:	mov    0x2c0(%rsp),%rdx
 107262a:	mov    (%rdx),%rcx
 107262d:	mov    0x8(%rdx),%r8
 1072631:	lea    0x3(%r8,%rcx,1),%rsi
 1072636:	add    %rcx,%r8
 1072639:	and    $0xfffffffffffffffc,%rsi
 107263d:	cmp    %r8,%rsi
 1072640:	jae    1072646 <check_input_run+0x5936>
 1072642:	xor    %ecx,%ecx
 1072644:	jmp    1072671 <check_input_run+0x5961>
 1072646:	mov    0x10(%rdx),%r9
 107264a:	mov    %rsi,%r8
 107264d:	sub    %rcx,%r8
 1072650:	xor    %ecx,%ecx
 1072652:	sub    %r8,%r9
 1072655:	jb     1072671 <check_input_run+0x5961>
 1072657:	mov    %edi,%r10d
 107265a:	lea    0x8(,%r10,8),%r10
 1072662:	cmp    %r9,%r10
 1072665:	ja     1072671 <check_input_run+0x5961>
 1072667:	add    %r10,%r8
 107266a:	mov    %rsi,%rcx
 107266d:	mov    %r8,0x8(%rdx)
 1072671:	mov    %rcx,0x110(%r14)
 1072678:	mov    %edi,0x11c(%r14)
 107267f:	mov    $0x1,%bpl
 1072682:	mov    0x480(%rsp),%rdx
 107268a:	mov    %rdx,0x100(%r14)
 1072691:	test   %rdx,%rdx
 1072694:	je     10726f6 <check_input_run+0x59e6>
 1072696:	mov    0x220(%r14),%rdi
 107269d:	test   %rdi,%rdi
 10726a0:	je     10726f6 <check_input_run+0x59e6>
 10726a2:	mov    0x490(%rsp),%rbx
 10726aa:	test   %rbx,%rbx
 10726ad:	je     10726f6 <check_input_run+0x59e6>
 10726af:	test   %rcx,%rcx
 10726b2:	je     10726f6 <check_input_run+0x59e6>
 10726b4:	cmpq   $0x0,0x498(%rsp)
 10726bd:	je     10726f6 <check_input_run+0x59e6>
 10726bf:	mov    0x30(%rax),%eax
 10726c2:	xor    %ebp,%ebp
 10726c4:	xor    %esi,%esi
 10726c6:	lea    0x4(,%rax,4),%rdx
 10726ce:	vzeroupper
 10726d1:	call   788120 <memset@plt>
 10726d6:	mov    0x2b0(%rsp),%rax
 10726de:	mov    %rbx,%rdi
 10726e1:	xor    %esi,%esi
 10726e3:	mov    0x270(%rax),%rax
 10726ea:	mov    0x68(%rax),%edx
 10726ed:	shl    $0x2,%rdx
 10726f1:	call   788120 <memset@plt>
 10726f6:	mov    0x58(%rsp),%rax
 10726fb:	or     %bpl,0x3bd(%r14)
 1072702:	mov    0x38(%rsp),%rcx
 1072707:	movzbl 0x60(%rax),%eax
 107270b:	cmp    $0x1,%eax
 107270e:	je     1072742 <check_input_run+0x5a32>
 1072710:	test   %eax,%eax
 1072712:	jne    1072757 <check_input_run+0x5a47>
 1072714:	mov    0x58(%rsp),%rax
 1072719:	lea    0x28(%rax),%rdi
 107271d:	vzeroupper
 1072720:	call   1013a20 <predefines_eval_method>
 1072725:	mov    0x38(%rsp),%rcx
 107272a:	test   %eax,%eax
 107272c:	sete   %al
 107272f:	mov    0x58(%rsp),%rdx
 1072734:	cmpb   $0x0,0x1d4(%rdx)
 107273b:	je     1072767 <check_input_run+0x5a57>
 107273d:	jmp    10727e4 <check_input_run+0x5ad4>
 1072742:	mov    $0x1,%al
 1072744:	mov    0x58(%rsp),%rdx
 1072749:	cmpb   $0x0,0x1d4(%rdx)
 1072750:	je     1072767 <check_input_run+0x5a57>
 1072752:	jmp    10727e4 <check_input_run+0x5ad4>
 1072757:	xor    %eax,%eax
 1072759:	mov    0x58(%rsp),%rdx
 107275e:	cmpb   $0x0,0x1d4(%rdx)
 1072765:	jne    10727e4 <check_input_run+0x5ad4>
 1072767:	cmpb   $0x0,0x61(%rdx)
 107276b:	jne    10727e4 <check_input_run+0x5ad4>
 107276d:	cmpb   $0x0,0x62(%rdx)
 1072771:	jne    10727e4 <check_input_run+0x5ad4>
 1072773:	cmpb   $0x0,0x1cc(%rdx)
 107277a:	sete   %cl
 107277d:	test   %al,%cl
 107277f:	mov    0x38(%rsp),%rcx
 1072784:	je     10727e4 <check_input_run+0x5ad4>
 1072786:	mov    0x18(%rsp),%rax
 107278b:	cmpb   $0x0,0x3bd(%rax)
 1072792:	jne    107283a <check_input_run+0x5b2a>
 1072798:	mov    0x58(%rsp),%rax
 107279d:	mov    0x2a8(%rsp),%r10
 10727a5:	mov    0x30(%r10),%r9d
 10727a9:	mov    0xc18(%rax),%eax
 10727af:	test   %rax,%rax
 10727b2:	je     1074e45 <check_input_run+0x8135>
 10727b8:	mov    0x58(%rsp),%rcx
 10727bd:	xor    %edx,%edx
 10727bf:	mov    0xc10(%rcx),%rcx
 10727c6:	add    $0x28,%rcx
 10727ca:	cmpb   $0x0,(%rcx)
 10727cd:	jne    10749ca <check_input_run+0x7cba>
 10727d3:	inc    %rdx
 10727d6:	add    $0x38,%rcx
 10727da:	cmp    %rdx,%rax
 10727dd:	jne    10727ca <check_input_run+0x5aba>
 10727df:	jmp    1074e45 <check_input_run+0x8135>
 10727e4:	mov    0x230(%r14),%eax
 10727eb:	cmp    0x234(%r14),%eax
 10727f2:	jae    1072832 <check_input_run+0x5b22>
 10727f4:	movzbl 0x3bd(%r14),%ecx
 10727fc:	mov    0x228(%r14),%rdx
 1072803:	lea    0x1(%rax),%esi
 1072806:	lea    (%rax,%rax,2),%rax
 107280a:	mov    %esi,0x230(%r14)
 1072811:	xor    $0x1,%ecx
 1072814:	movl   $0x0,(%rdx,%rax,4)
 107281b:	lea    0x4(%rcx,%rcx,2),%ecx
 107281f:	mov    %ecx,0x4(%rdx,%rax,4)
 1072823:	mov    0x38(%rsp),%rcx
 1072828:	movl   $0x0,0x8(%rdx,%rax,4)
 1072830:	jmp    107283a <check_input_run+0x5b2a>
 1072832:	movb   $0x1,0x3bd(%r14)
 107283a:	mov    0x18(%rsp),%rax
 107283f:	movzbl 0x3bd(%rax),%eax
 1072846:	test   %al,%al
 1072848:	jne    1075ca0 <check_input_run+0x8f90>
 107284e:	cmpb   $0x0,0x338(%rsp)
 1072856:	je     1075ca0 <check_input_run+0x8f90>
 107285c:	mov    0x858(%rsp),%ecx
 1072863:	test   %ecx,%ecx
 1072865:	je     107288c <check_input_run+0x5b7c>
 1072867:	mov    %ecx,%eax
 1072869:	and    $0xfffffffe,%eax
 107286c:	cmp    $0x4,%eax
 107286f:	jne    10728a3 <check_input_run+0x5b93>
 1072871:	xor    %esi,%esi
 1072873:	cmp    $0x4,%ecx
 1072876:	lea    0x2a0(%rsp),%rdi
 107287e:	sete   %sil
 1072882:	vzeroupper
 1072885:	call   10f9ec0 <check_input_binding_parser>
 107288a:	jmp    10728b5 <check_input_run+0x5ba5>
 107288c:	mov    0x2a8(%rsp),%rax
 1072894:	movzbl (%rax),%ecx
 1072897:	inc    %ecx
 1072899:	mov    %ecx,%eax
 107289b:	and    $0xfffffffe,%eax
 107289e:	cmp    $0x4,%eax
 10728a1:	je     1072871 <check_input_run+0x5b61>
 10728a3:	lea    0x2a0(%rsp),%rdi
 10728ab:	mov    %ecx,%esi
 10728ad:	vzeroupper
 10728b0:	call   10fa1b0 <check_input_binding_events>
 10728b5:	mov    0x18(%rsp),%rax
 10728ba:	mov    0x30(%rsp),%r11
 10728bf:	mov    0x230(%rax),%eax
 10728c5:	test   %rax,%rax
 10728c8:	je     1072a0e <check_input_run+0x5cfe>
 10728ce:	mov    0x670(%rsp),%r8d
 10728d6:	mov    %eax,%ecx
 10728d8:	and    $0x7,%ecx
 10728db:	cmp    $0x8,%eax
 10728de:	jae    10728e7 <check_input_run+0x5bd7>
 10728e0:	xor    %edx,%edx
 10728e2:	jmp    10729de <check_input_run+0x5cce>
 10728e7:	mov    %eax,%edx
 10728e9:	shr    $0x3,%edx
 10728ec:	xor    %edi,%edi
 10728ee:	shl    $0x5,%rdx
 10728f2:	lea    (%rdx,%rdx,2),%rsi
 10728f6:	xor    %edx,%edx
 10728f8:	jmp    1072919 <check_input_run+0x5c09>
 10728fa:	nopw   0x0(%rax,%rax,1)
 1072900:	add    $0x8,%rdx
 1072904:	add    $0x60,%rdi
 1072908:	mov    %r8d,0x670(%rsp)
 1072910:	cmp    %rdi,%rsi
 1072913:	je     10729d9 <check_input_run+0x5cc9>
 1072919:	mov    (%r11),%r9
 107291c:	mov    (%r9,%rdi,1),%r9d
 1072920:	cmp    %r8d,%r9d
 1072923:	jb     1072928 <check_input_run+0x5c18>
 1072925:	mov    %r8d,%r9d
 1072928:	mov    %r9d,0x670(%rsp)
 1072930:	mov    (%r11),%r8
 1072933:	mov    0xc(%r8,%rdi,1),%r8d
 1072938:	cmp    %r9d,%r8d
 107293b:	jb     1072940 <check_input_run+0x5c30>
 107293d:	mov    %r9d,%r8d
 1072940:	mov    %r8d,0x670(%rsp)
 1072948:	mov    (%r11),%r9
 107294b:	mov    0x18(%r9,%rdi,1),%r9d
 1072950:	cmp    %r8d,%r9d
 1072953:	jb     1072958 <check_input_run+0x5c48>
 1072955:	mov    %r8d,%r9d
 1072958:	mov    %r9d,0x670(%rsp)
 1072960:	mov    (%r11),%r8
 1072963:	mov    0x24(%r8,%rdi,1),%r8d
 1072968:	cmp    %r9d,%r8d
 107296b:	jb     1072970 <check_input_run+0x5c60>
 107296d:	mov    %r9d,%r8d
 1072970:	mov    %r8d,0x670(%rsp)
 1072978:	mov    (%r11),%r9
 107297b:	mov    0x30(%r9,%rdi,1),%r9d
 1072980:	cmp    %r8d,%r9d
 1072983:	jb     1072988 <check_input_run+0x5c78>
 1072985:	mov    %r8d,%r9d
 1072988:	mov    %r9d,0x670(%rsp)
 1072990:	mov    (%r11),%r8
 1072993:	mov    0x3c(%r8,%rdi,1),%r8d
 1072998:	cmp    %r9d,%r8d
 107299b:	jb     10729a0 <check_input_run+0x5c90>
 107299d:	mov    %r9d,%r8d
 10729a0:	mov    %r8d,0x670(%rsp)
 10729a8:	mov    (%r11),%r9
 10729ab:	mov    0x48(%r9,%rdi,1),%r9d
 10729b0:	cmp    %r8d,%r9d
 10729b3:	jb     10729b8 <check_input_run+0x5ca8>
 10729b5:	mov    %r8d,%r9d
 10729b8:	mov    %r9d,0x670(%rsp)
 10729c0:	mov    (%r11),%r8
 10729c3:	mov    0x54(%r8,%rdi,1),%r8d
 10729c8:	cmp    %r9d,%r8d
 10729cb:	jb     1072900 <check_input_run+0x5bf0>
 10729d1:	mov    %r9d,%r8d
 10729d4:	jmp    1072900 <check_input_run+0x5bf0>
 10729d9:	test   %rcx,%rcx
 10729dc:	je     1072a0e <check_input_run+0x5cfe>
 10729de:	shl    $0x2,%rdx
 10729e2:	lea    (%rdx,%rdx,2),%rdx
 10729e6:	cs nopw 0x0(%rax,%rax,1)
 10729f0:	mov    (%r11),%rsi
 10729f3:	mov    (%rsi,%rdx,1),%esi
 10729f6:	cmp    %r8d,%esi
 10729f9:	cmovb  %esi,%r8d
 10729fd:	add    $0xc,%rdx
 1072a01:	dec    %rcx
 1072a04:	mov    %r8d,0x670(%rsp)
 1072a0c:	jne    10729f0 <check_input_run+0x5ce0>
 1072a0e:	mov    0x18(%rsp),%rcx
 1072a13:	cmpb   $0x0,0x3bd(%rcx)
 1072a1a:	jne    106fe32 <check_input_run+0x3122>
 1072a20:	mov    0x2a8(%rsp),%r9
 1072a28:	mov    0x30(%r9),%ecx
 1072a2c:	test   %ecx,%ecx
 1072a2e:	je     1073fa0 <check_input_run+0x7290>
 1072a34:	lea    0x700(%rsp),%r15
 1072a3c:	xor    %r13d,%r13d
 1072a3f:	vpxor  %xmm0,%xmm0,%xmm0
 1072a43:	jmp    1072a5e <check_input_run+0x5d4e>
 1072a45:	movb   $0x1,0x3bd(%rax)
 1072a4c:	mov    0x30(%r9),%ecx
 1072a50:	inc    %r13
 1072a53:	mov    %ecx,%eax
 1072a55:	cmp    %rax,%r13
 1072a58:	jae    1073f95 <check_input_run+0x7285>
 1072a5e:	mov    0x68(%r9),%rax
 1072a62:	mov    0x610(%rsp),%rdx
 1072a6a:	mov    $0x0,%ebx
 1072a6f:	mov    (%rax,%r13,4),%r14d
 1072a73:	mov    (%rdx,%r14,4),%edx
 1072a77:	cmp    %ecx,%edx
 1072a79:	jae    1072a82 <check_input_run+0x5d72>
 1072a7b:	mov    0x18(%r9),%rax
 1072a7f:	mov    (%rax,%rdx,4),%ebx
 1072a82:	mov    0x608(%rsp),%rax
 1072a8a:	mov    (%rax,%r14,4),%eax
 1072a8e:	cmp    0x670(%rsp),%eax
 1072a95:	jae    1072a50 <check_input_run+0x5d40>
 1072a97:	mov    0x3d8(%rsp),%rax
 1072a9f:	cmpb   $0x0,(%rax,%r14,1)
 1072aa4:	jne    1072a50 <check_input_run+0x5d40>
 1072aa6:	mov    0x50(%r9),%rax
 1072aaa:	cmpb   $0x48,(%rax,%r14,1)
 1072aaf:	jne    1072a50 <check_input_run+0x5d40>
 1072ab1:	cmp    $0x4c,%ebx
 1072ab4:	je     1072abb <check_input_run+0x5dab>
 1072ab6:	cmp    $0x28,%ebx
 1072ab9:	jne    1072a50 <check_input_run+0x5d40>
 1072abb:	lea    0x2(%rdx),%edi
 1072abe:	mov    %rdx,0x210(%rsp)
 1072ac6:	cmp    %r14d,%edi
 1072ac9:	jae    1072b30 <check_input_run+0x5e20>
 1072acb:	mov    0x10(%r9),%rax
 1072acf:	mov    %edi,%ecx
 1072ad1:	jmp    1072b07 <check_input_run+0x5df7>
 1072ad3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1072ae0:	cmp    $0xa,%esi
 1072ae3:	jne    1072b1e <check_input_run+0x5e0e>
 1072ae5:	mov    0x60(%r9),%rsi
 1072ae9:	mov    (%rsi,%rdx,4),%edx
 1072aec:	lea    0x1(%rdx),%ebp
 1072aef:	cmp    %r14d,%edx
 1072af2:	cmovae %r14d,%ebp
 1072af6:	cmp    %ecx,%edx
 1072af8:	cmovbe %r14d,%ebp
 1072afc:	mov    %ebp,%ecx
 1072afe:	cmp    %r14d,%ebp
 1072b01:	jae    1072b9a <check_input_run+0x5e8a>
 1072b07:	mov    %ecx,%edx
 1072b09:	movzbl (%rax,%rdx,1),%esi
 1072b0d:	cmp    $0x9,%esi
 1072b10:	jg     1072ae0 <check_input_run+0x5dd0>
 1072b12:	cmp    $0x6,%esi
 1072b15:	je     1072ae5 <check_input_run+0x5dd5>
 1072b17:	cmp    $0x8,%esi
 1072b1a:	je     1072ae5 <check_input_run+0x5dd5>
 1072b1c:	jmp    1072b23 <check_input_run+0x5e13>
 1072b1e:	cmp    $0x33,%esi
 1072b21:	je     1072b98 <check_input_run+0x5e88>
 1072b23:	inc    %ecx
 1072b25:	mov    %ecx,%ebp
 1072b27:	mov    %ebp,%ecx
 1072b29:	cmp    %r14d,%ebp
 1072b2c:	jb     1072b07 <check_input_run+0x5df7>
 1072b2e:	jmp    1072b9a <check_input_run+0x5e8a>
 1072b30:	vmovdqu64 %zmm0,0x7a0(%rsp)
 1072b3b:	vmovdqu64 %zmm0,0x780(%rsp)
 1072b43:	mov    0x2a0(%rsp),%rax
 1072b4b:	mov    0x230(%rax),%ecx
 1072b51:	cmp    0x234(%rax),%ecx
 1072b57:	jae    1072a45 <check_input_run+0x5d35>
 1072b5d:	movzbl 0x3bd(%rax),%edx
 1072b64:	lea    0x1(%rcx),%edi
 1072b67:	mov    0x228(%rax),%rsi
 1072b6e:	mov    %edi,0x230(%rax)
 1072b74:	lea    (%rcx,%rcx,2),%rax
 1072b78:	mov    0x210(%rsp),%rcx
 1072b80:	lea    0x1(%rdx,%rdx,2),%edx
 1072b84:	mov    %ecx,(%rsi,%rax,4)
 1072b87:	mov    %edx,0x4(%rsi,%rax,4)
 1072b8b:	movl   $0x0,0x8(%rsi,%rax,4)
 1072b93:	jmp    1072a4c <check_input_run+0x5d3c>
 1072b98:	mov    %ecx,%ebp
 1072b9a:	vmovdqu64 %zmm0,0x7a0(%rsp)
 1072ba5:	vmovdqu64 %zmm0,0x780(%rsp)
 1072bad:	cmp    %ebp,%edi
 1072baf:	jae    1072b43 <check_input_run+0x5e33>
 1072bb1:	cmp    %ebp,%r14d
 1072bb4:	jbe    1072b43 <check_input_run+0x5e33>
 1072bb6:	mov    %edi,%esi
 1072bb8:	mov    %r9,0x1b0(%rsp)
 1072bc0:	lea    0x2a0(%rsp),%rdi
 1072bc8:	mov    $0x1,%r8d
 1072bce:	lea    0x780(%rsp),%r9
 1072bd6:	mov    %r15,(%rsp)
 1072bda:	movq   $0x0,0x8(%rsp)
 1072be3:	mov    %esi,0x70(%rsp)
 1072be7:	mov    %ebp,%edx
 1072be9:	xor    %ecx,%ecx
 1072beb:	vzeroupper
 1072bee:	call   10c1fc0 <check_input_constant_read>
 1072bf3:	cmp    $0x28,%ebx
 1072bf6:	jne    1072c70 <check_input_run+0x5f60>
 1072bf8:	test   %al,%al
 1072bfa:	je     1072c70 <check_input_run+0x5f60>
 1072bfc:	mov    0x2c8(%rsp),%rax
 1072c04:	mov    0x780(%rsp),%esi
 1072c0b:	mov    0x2a8(%rsp),%rbx
 1072c13:	lea    0x2a0(%rsp),%rdi
 1072c1b:	mov    0x8(%rax),%rax
 1072c1f:	mov    %rax,0xd8(%rsp)
 1072c27:	call   10e7070 <check_constant_control_type>
 1072c2c:	mov    %eax,0x100(%rsp)
 1072c33:	mov    0x2c8(%rsp),%rax
 1072c3b:	mov    (%rax),%rsi
 1072c3e:	mov    0x8(%rax),%rdx
 1072c42:	lea    0x3(%rdx,%rsi,1),%rcx
 1072c47:	add    %rsi,%rdx
 1072c4a:	and    $0xfffffffffffffffc,%rcx
 1072c4e:	cmp    %rdx,%rcx
 1072c51:	jae    1072cfb <check_input_run+0x5feb>
 1072c57:	mov    0x30(%rsp),%r11
 1072c5c:	mov    0x1b0(%rsp),%r9
 1072c64:	xor    %r8d,%r8d
 1072c67:	vpxor  %xmm0,%xmm0,%xmm0
 1072c6b:	jmp    1072d3e <check_input_run+0x602e>
 1072c70:	mov    0x30(%rsp),%r11
 1072c75:	mov    0x1b0(%rsp),%r9
 1072c7d:	vpxor  %xmm0,%xmm0,%xmm0
 1072c81:	test   %al,%al
 1072c83:	je     1072b43 <check_input_run+0x5e33>
 1072c89:	lea    0x1(%rbp),%ebx
 1072c8c:	mov    %ebx,%r15d
 1072c8f:	cmp    %r14d,%ebx
 1072c92:	jae    10738f8 <check_input_run+0x6be8>
 1072c98:	mov    0x10(%r9),%rax
 1072c9c:	mov    %ebx,%ecx
 1072c9e:	jmp    1072cc9 <check_input_run+0x5fb9>
 1072ca0:	cmp    $0xa,%esi
 1072ca3:	jne    1072ce0 <check_input_run+0x5fd0>
 1072ca5:	mov    0x60(%r9),%rsi
 1072ca9:	mov    (%rsi,%rdx,4),%edx
 1072cac:	lea    0x1(%rdx),%r15d
 1072cb0:	cmp    %r14d,%edx
 1072cb3:	cmovae %r14d,%r15d
 1072cb7:	cmp    %ecx,%edx
 1072cb9:	cmovbe %r14d,%r15d
 1072cbd:	mov    %r15d,%ecx
 1072cc0:	cmp    %r14d,%r15d
 1072cc3:	jae    10738f8 <check_input_run+0x6be8>
 1072cc9:	mov    %ecx,%edx
 1072ccb:	movzbl (%rax,%rdx,1),%esi
 1072ccf:	cmp    $0x9,%esi
 1072cd2:	jg     1072ca0 <check_input_run+0x5f90>
 1072cd4:	cmp    $0x6,%esi
 1072cd7:	je     1072ca5 <check_input_run+0x5f95>
 1072cd9:	cmp    $0x8,%esi
 1072cdc:	je     1072ca5 <check_input_run+0x5f95>
 1072cde:	jmp    1072ce9 <check_input_run+0x5fd9>
 1072ce0:	cmp    $0x33,%esi
 1072ce3:	je     10738f5 <check_input_run+0x6be5>
 1072ce9:	inc    %ecx
 1072ceb:	mov    %ecx,%r15d
 1072cee:	mov    %r15d,%ecx
 1072cf1:	cmp    %r14d,%r15d
 1072cf4:	jb     1072cc9 <check_input_run+0x5fb9>
 1072cf6:	jmp    10738f8 <check_input_run+0x6be8>
 1072cfb:	mov    %rcx,%rdx
 1072cfe:	sub    %rsi,%rdx
 1072d01:	mov    0x10(%rax),%rsi
 1072d05:	mov    0x30(%rsp),%r11
 1072d0a:	mov    0x1b0(%rsp),%r9
 1072d12:	vpxor  %xmm0,%xmm0,%xmm0
 1072d16:	sub    %rdx,%rsi
 1072d19:	jb     1072d3b <check_input_run+0x602b>
 1072d1b:	mov    %r14d,%edi
 1072d1e:	sub    %ebp,%edi
 1072d20:	mov    $0x0,%r8d
 1072d26:	shl    $0x2,%rdi
 1072d2a:	cmp    %rsi,%rdi
 1072d2d:	ja     1072d3e <check_input_run+0x602e>
 1072d2f:	add    %rdi,%rdx
 1072d32:	mov    %rcx,%r8
 1072d35:	mov    %rdx,0x8(%rax)
 1072d39:	jmp    1072d3e <check_input_run+0x602e>
 1072d3b:	xor    %r8d,%r8d
 1072d3e:	mov    0x2a0(%rsp),%rcx
 1072d46:	test   %r8,%r8
 1072d49:	sete   %al
 1072d4c:	xor    %edx,%edx
 1072d4e:	or     %al,0x3bd(%rcx)
 1072d54:	lea    0x1(%rbp),%eax
 1072d57:	cmp    %r14d,%eax
 1072d5a:	jae    1073613 <check_input_run+0x6903>
 1072d60:	test   %r8,%r8
 1072d63:	je     1073613 <check_input_run+0x6903>
 1072d69:	cmpl   $0x0,0x100(%rsp)
 1072d71:	mov    %r8,0x98(%rsp)
 1072d79:	mov    %eax,0x88(%rsp)
 1072d80:	je     1073613 <check_input_run+0x6903>
 1072d86:	mov    0x88(%rsp),%r10d
 1072d8e:	lea    0x1(%r14),%eax
 1072d92:	movl   $0xffffffff,0xd0(%rsp)
 1072d9d:	movl   $0x0,0xc8(%rsp)
 1072da8:	movl   $0xffffffff,0xe8(%rsp)
 1072db3:	mov    %rbx,0x58(%rsp)
 1072db8:	mov    %eax,0x90(%rsp)
 1072dbf:	mov    0x10(%rbx),%rcx
 1072dc3:	mov    %r10d,%eax
 1072dc6:	jmp    1072df3 <check_input_run+0x60e3>
 1072dc8:	nopl   0x0(%rax,%rax,1)
 1072dd0:	cmp    $0xa,%esi
 1072dd3:	jne    1072e0a <check_input_run+0x60fa>
 1072dd5:	mov    0x60(%rbx),%rsi
 1072dd9:	mov    (%rsi,%rdx,4),%esi
 1072ddc:	lea    0x1(%rsi),%edx
 1072ddf:	cmp    %r14d,%esi
 1072de2:	cmovae %r14d,%edx
 1072de6:	cmp    %eax,%esi
 1072de8:	cmovbe %r14d,%edx
 1072dec:	mov    %edx,%eax
 1072dee:	cmp    %r14d,%edx
 1072df1:	jae    1072e1c <check_input_run+0x610c>
 1072df3:	mov    %eax,%edx
 1072df5:	movzbl (%rcx,%rdx,1),%esi
 1072df9:	cmp    $0x9,%esi
 1072dfc:	jg     1072dd0 <check_input_run+0x60c0>
 1072dfe:	cmp    $0x6,%esi
 1072e01:	je     1072dd5 <check_input_run+0x60c5>
 1072e03:	cmp    $0x8,%esi
 1072e06:	je     1072dd5 <check_input_run+0x60c5>
 1072e08:	jmp    1072e0f <check_input_run+0x60ff>
 1072e0a:	cmp    $0x2f,%esi
 1072e0d:	je     1072e1a <check_input_run+0x610a>
 1072e0f:	inc    %eax
 1072e11:	mov    %eax,%edx
 1072e13:	cmp    %r14d,%edx
 1072e16:	jb     1072df3 <check_input_run+0x60e3>
 1072e18:	jmp    1072e1c <check_input_run+0x610c>
 1072e1a:	mov    %eax,%edx
 1072e1c:	cmp    %r14d,%edx
 1072e1f:	jae    1073611 <check_input_run+0x6901>
 1072e25:	mov    %edx,%esi
 1072e27:	lea    0x1(%rsi),%edi
 1072e2a:	cmp    %r14d,%edi
 1072e2d:	jae    1073611 <check_input_run+0x6901>
 1072e33:	mov    %edi,%eax
 1072e35:	jmp    1072e67 <check_input_run+0x6157>
 1072e37:	nopw   0x0(%rax,%rax,1)
 1072e40:	cmp    $0xa,%r8d
 1072e44:	jne    1072e82 <check_input_run+0x6172>
 1072e46:	mov    0x60(%rbx),%r8
 1072e4a:	mov    (%r8,%rdx,4),%edx
 1072e4e:	lea    0x1(%rdx),%r12d
 1072e52:	cmp    %r14d,%edx
 1072e55:	cmovae %r14d,%r12d
 1072e59:	cmp    %eax,%edx
 1072e5b:	cmovbe %r14d,%r12d
 1072e5f:	mov    %r12d,%eax
 1072e62:	cmp    %r14d,%r12d
 1072e65:	jae    1072e97 <check_input_run+0x6187>
 1072e67:	mov    %eax,%edx
 1072e69:	movzbl (%rcx,%rdx,1),%r8d
 1072e6e:	cmp    $0x9,%r8d
 1072e72:	jg     1072e40 <check_input_run+0x6130>
 1072e74:	cmp    $0x6,%r8d
 1072e78:	je     1072e46 <check_input_run+0x6136>
 1072e7a:	cmp    $0x8,%r8d
 1072e7e:	je     1072e46 <check_input_run+0x6136>
 1072e80:	jmp    1072e88 <check_input_run+0x6178>
 1072e82:	cmp    $0x33,%r8d
 1072e86:	je     1072e94 <check_input_run+0x6184>
 1072e88:	inc    %eax
 1072e8a:	mov    %eax,%r12d
 1072e8d:	cmp    %r14d,%r12d
 1072e90:	jb     1072e67 <check_input_run+0x6157>
 1072e92:	jmp    1072e97 <check_input_run+0x6187>
 1072e94:	mov    %eax,%r12d
 1072e97:	xor    %edx,%edx
 1072e99:	cmp    %esi,%r10d
 1072e9c:	jae    1073613 <check_input_run+0x6903>
 1072ea2:	cmp    %r12d,%edi
 1072ea5:	jae    1073613 <check_input_run+0x6903>
 1072eab:	mov    0x60(%rbx),%rdx
 1072eaf:	mov    %edi,%edi
 1072eb1:	mov    %r12d,%r8d
 1072eb4:	mov    %rdi,%rax
 1072eb7:	sub    %r8,%rax
 1072eba:	sub    %rdi,%r8
 1072ebd:	mov    %r10d,0x130(%rsp)
 1072ec5:	mov    %r8,0x28(%rsp)
 1072eca:	and    $0x7,%r8d
 1072ece:	mov    %rdx,0x50(%rsp)
 1072ed3:	cmp    $0xfffffffffffffff8,%rax
 1072ed7:	jbe    1072ee7 <check_input_run+0x61d7>
 1072ed9:	xor    %r10d,%r10d
 1072edc:	mov    $0xffffffff,%r15d
 1072ee2:	jmp    1073060 <check_input_run+0x6350>
 1072ee7:	andq   $0xfffffffffffffff8,0x28(%rsp)
 1072eed:	lea    0x1c(%rdx,%rdi,4),%r11
 1072ef2:	mov    $0xffffffff,%r15d
 1072ef8:	xor    %r10d,%r10d
 1072efb:	xor    %ebx,%ebx
 1072efd:	nopl   (%rax)
 1072f00:	mov    -0x1c(%r11,%rbx,4),%eax
 1072f05:	mov    -0x18(%r11,%rbx,4),%edx
 1072f0a:	cmp    %esi,%eax
 1072f0c:	setbe  %r9b
 1072f10:	cmp    %r12d,%eax
 1072f13:	setae  %al
 1072f16:	or     %r9b,%al
 1072f19:	lea    0x1(%rsi,%rbx,1),%r9d
 1072f1e:	movzbl %al,%eax
 1072f21:	add    %eax,%r10d
 1072f24:	test   %al,%al
 1072f26:	cmovne %r9d,%r15d
 1072f2a:	cmp    %esi,%edx
 1072f2c:	lea    0x2(%rsi,%rbx,1),%r9d
 1072f31:	setbe  %al
 1072f34:	cmp    %r12d,%edx
 1072f37:	setae  %dl
 1072f3a:	or     %al,%dl
 1072f3c:	movzbl %dl,%eax
 1072f3f:	mov    -0x14(%r11,%rbx,4),%edx
 1072f44:	test   %al,%al
 1072f46:	cmove  %r15d,%r9d
 1072f4a:	cmp    %esi,%edx
 1072f4c:	setbe  %r15b
 1072f50:	cmp    %r12d,%edx
 1072f53:	setae  %dl
 1072f56:	or     %r15b,%dl
 1072f59:	movzbl %dl,%edx
 1072f5c:	add    %edx,%eax
 1072f5e:	add    %r10d,%eax
 1072f61:	test   %dl,%dl
 1072f63:	mov    -0x10(%r11,%rbx,4),%edx
 1072f68:	lea    0x3(%rsi,%rbx,1),%r10d
 1072f6d:	cmove  %r9d,%r10d
 1072f71:	cmp    %esi,%edx
 1072f73:	setbe  %r9b
 1072f77:	cmp    %r12d,%edx
 1072f7a:	setae  %dl
 1072f7d:	or     %r9b,%dl
 1072f80:	lea    0x4(%rsi,%rbx,1),%r9d
 1072f85:	movzbl %dl,%r15d
 1072f89:	mov    -0xc(%r11,%rbx,4),%edx
 1072f8e:	test   %r15b,%r15b
 1072f91:	cmove  %r10d,%r9d
 1072f95:	cmp    %esi,%edx
 1072f97:	setbe  %r10b
 1072f9b:	cmp    %r12d,%edx
 1072f9e:	setae  %dl
 1072fa1:	or     %r10b,%dl
 1072fa4:	lea    0x5(%rsi,%rbx,1),%r10d
 1072fa9:	movzbl %dl,%edx
 1072fac:	add    %edx,%r15d
 1072faf:	test   %dl,%dl
 1072fb1:	mov    -0x8(%r11,%rbx,4),%edx
 1072fb6:	cmove  %r9d,%r10d
 1072fba:	cmp    %esi,%edx
 1072fbc:	setbe  %r9b
 1072fc0:	cmp    %r12d,%edx
 1072fc3:	setae  %dl
 1072fc6:	or     %r9b,%dl
 1072fc9:	movzbl %dl,%edx
 1072fcc:	add    %edx,%r15d
 1072fcf:	add    %eax,%r15d
 1072fd2:	test   %dl,%dl
 1072fd4:	mov    -0x4(%r11,%rbx,4),%edx
 1072fd9:	lea    0x6(%rsi,%rbx,1),%eax
 1072fdd:	cmove  %r10d,%eax
 1072fe1:	cmp    %esi,%edx
 1072fe3:	setbe  %r9b
 1072fe7:	cmp    %r12d,%edx
 1072fea:	setae  %dl
 1072fed:	or     %r9b,%dl
 1072ff0:	lea    0x7(%rsi,%rbx,1),%r9d
 1072ff5:	movzbl %dl,%r10d
 1072ff9:	test   %r10b,%r10b
 1072ffc:	cmove  %eax,%r9d
 1073000:	mov    (%r11,%rbx,4),%eax
 1073004:	cmp    %esi,%eax
 1073006:	setbe  %dl
 1073009:	cmp    %r12d,%eax
 107300c:	setae  %al
 107300f:	or     %dl,%al
 1073011:	movzbl %al,%eax
 1073014:	add    %eax,%r10d
 1073017:	add    %r15d,%r10d
 107301a:	lea    0x8(%rsi,%rbx,1),%r15d
 107301f:	test   %al,%al
 1073021:	cmove  %r9d,%r15d
 1073025:	add    $0x8,%rbx
 1073029:	cmp    %rbx,0x28(%rsp)
 107302e:	jne    1072f00 <check_input_run+0x61f0>
 1073034:	test   %r8,%r8
 1073037:	je     1073212 <check_input_run+0x6502>
 107303d:	add    %rbx,%rdi
 1073040:	mov    0x30(%rsp),%r11
 1073045:	mov    0x1b0(%rsp),%r9
 107304d:	mov    0x58(%rsp),%rbx
 1073052:	mov    0x50(%rsp),%rdx
 1073057:	nopw   0x0(%rax,%rax,1)
 1073060:	mov    (%rdx,%rdi,4),%eax
 1073063:	cmp    %esi,%eax
 1073065:	setbe  %dl
 1073068:	cmp    %r12d,%eax
 107306b:	setae  %al
 107306e:	or     %dl,%al
 1073070:	mov    0x50(%rsp),%rdx
 1073075:	movzbl %al,%eax
 1073078:	add    %eax,%r10d
 107307b:	test   %al,%al
 107307d:	cmovne %edi,%r15d
 1073081:	inc    %rdi
 1073084:	dec    %r8
 1073087:	jne    1073060 <check_input_run+0x6350>
 1073089:	xor    %edx,%edx
 107308b:	cmp    $0x1,%r10d
 107308f:	jne    1073613 <check_input_run+0x6903>
 1073095:	mov    0x130(%rsp),%edi
 107309c:	cmp    $0xffffffff,%r15d
 10730a0:	je     1073613 <check_input_run+0x6903>
 10730a6:	mov    %edi,%eax
 10730a8:	cmpb   $0x4b,(%rcx,%rax,1)
 10730ac:	jne    10730cd <check_input_run+0x63bd>
 10730ae:	mov    0xd0(%rsp),%eax
 10730b5:	inc    %edi
 10730b7:	mov    %r15d,0xd0(%rsp)
 10730bf:	xor    %esi,%edi
 10730c1:	not    %eax
 10730c3:	or     %edi,%eax
 10730c5:	sete   %cl
 10730c8:	jmp    10731fd <check_input_run+0x64ed>
 10730cd:	mov    0x450(%rsp),%rax
 10730d5:	mov    0xc8(%rsp),%edx
 10730dc:	mov    (%rax,%rsi,4),%eax
 10730df:	test   %eax,%eax
 10730e1:	mov    %eax,0x50(%rsp)
 10730e5:	setne  %al
 10730e8:	test   %edx,%edx
 10730ea:	mov    %edx,%edx
 10730ec:	mov    %rdx,0x28(%rsp)
 10730f1:	setne  %cl
 10730f4:	and    %al,%cl
 10730f6:	cmp    $0x1,%cl
 10730f9:	jne    107315d <check_input_run+0x644d>
 10730fb:	mov    $0x1,%ebx
 1073100:	mov    0x2b8(%rsp),%rdi
 1073108:	mov    0x98(%rsp),%rax
 1073110:	mov    0x600(%rsp),%rcx
 1073118:	mov    0x50(%rsp),%esi
 107311c:	mov    0x90(%rsp),%r9d
 1073124:	mov    -0x4(%rax,%rbx,4),%edx
 1073128:	mov    0xa0(%rdi),%r8d
 107312f:	vzeroupper
 1073132:	call   10aca40 <type_compatible_at>
 1073137:	mov    0x2a0(%rsp),%rdx
 107313f:	cmp    $0x2,%eax
 1073142:	sete   %cl
 1073145:	or     %cl,0x3bd(%rdx)
 107314b:	test   %eax,%eax
 107314d:	sete   %al
 1073150:	jne    107315d <check_input_run+0x644d>
 1073152:	cmp    0x28(%rsp),%rbx
 1073157:	lea    0x1(%rbx),%rbx
 107315b:	jb     1073100 <check_input_run+0x63f0>
 107315d:	test   %al,%al
 107315f:	je     10739e0 <check_input_run+0x6cd0>
 1073165:	mov    0x98(%rsp),%rax
 107316d:	mov    0x50(%rsp),%esi
 1073171:	mov    0x28(%rsp),%rcx
 1073176:	incl   0xc8(%rsp)
 107317d:	mov    0x100(%rsp),%edx
 1073184:	mov    0x90(%rsp),%r9d
 107318c:	mov    %esi,(%rax,%rcx,4)
 107318f:	mov    0x2b8(%rsp),%rdi
 1073197:	mov    0x600(%rsp),%rcx
 107319f:	mov    0xa0(%rdi),%r8d
 10731a6:	vzeroupper
 10731a9:	call   10aca40 <type_compatible_at>
 10731ae:	mov    0x2a0(%rsp),%rsi
 10731b6:	mov    0xe8(%rsp),%edi
 10731bd:	xor    %edx,%edx
 10731bf:	cmp    $0x2,%eax
 10731c2:	mov    0x30(%rsp),%r11
 10731c7:	mov    0x1b0(%rsp),%r9
 10731cf:	mov    0x58(%rsp),%rbx
 10731d4:	vpxor  %xmm0,%xmm0,%xmm0
 10731d8:	sete   %cl
 10731db:	setne  %dl
 10731de:	or     %cl,0x3bd(%rsi)
 10731e4:	xor    %ecx,%ecx
 10731e6:	cmp    $0xffffffff,%edi
 10731e9:	sete   %cl
 10731ec:	cmp    $0x1,%eax
 10731ef:	cmove  %r15d,%edi
 10731f3:	cmovne %edx,%ecx
 10731f6:	mov    %edi,0xe8(%rsp)
 10731fd:	inc    %r12d
 1073200:	cmp    %r14d,%r12d
 1073203:	jae    1073235 <check_input_run+0x6525>
 1073205:	mov    %r12d,%r10d
 1073208:	test   %cl,%cl
 107320a:	jne    1072dbf <check_input_run+0x60af>
 1073210:	jmp    1073235 <check_input_run+0x6525>
 1073212:	mov    0x30(%rsp),%r11
 1073217:	mov    0x1b0(%rsp),%r9
 107321f:	mov    0x58(%rsp),%rbx
 1073224:	xor    %edx,%edx
 1073226:	cmp    $0x1,%r10d
 107322a:	je     1073095 <check_input_run+0x6385>
 1073230:	jmp    1073613 <check_input_run+0x6903>
 1073235:	mov    0xe8(%rsp),%eax
 107323c:	mov    0xd0(%rsp),%r8d
 1073244:	cmp    $0xffffffff,%eax
 1073247:	cmovne %eax,%r8d
 107324b:	cmp    $0xffffffff,%r8d
 107324f:	sete   %al
 1073252:	xor    $0x1,%cl
 1073255:	or     %al,%cl
 1073257:	jne    1073611 <check_input_run+0x6901>
 107325d:	mov    0x440(%rsp),%rax
 1073265:	mov    0x88(%rsp),%r10d
 107326d:	mov    %r8d,(%rax,%r14,4)
 1073271:	jmp    107327f <check_input_run+0x656f>
 1073273:	inc    %r10d
 1073276:	cmp    %r14d,%r10d
 1073279:	jae    10739f8 <check_input_run+0x6ce8>
 107327f:	mov    0x10(%rbx),%rcx
 1073283:	jmp    10732b5 <check_input_run+0x65a5>
 1073285:	data16 cs nopw 0x0(%rax,%rax,1)
 1073290:	cmp    $0xa,%edx
 1073293:	jne    10732cd <check_input_run+0x65bd>
 1073295:	mov    0x60(%rbx),%rdx
 1073299:	mov    (%rdx,%rax,4),%edx
 107329c:	lea    0x1(%rdx),%eax
 107329f:	cmp    %r14d,%edx
 10732a2:	cmovae %r14d,%eax
 10732a6:	cmp    %r10d,%edx
 10732a9:	cmovbe %r14d,%eax
 10732ad:	mov    %eax,%r10d
 10732b0:	cmp    %r14d,%eax
 10732b3:	jae    10732e2 <check_input_run+0x65d2>
 10732b5:	mov    %r10d,%eax
 10732b8:	movzbl (%rcx,%rax,1),%edx
 10732bc:	cmp    $0x9,%edx
 10732bf:	jg     1073290 <check_input_run+0x6580>
 10732c1:	cmp    $0x6,%edx
 10732c4:	je     1073295 <check_input_run+0x6585>
 10732c6:	cmp    $0x8,%edx
 10732c9:	je     1073295 <check_input_run+0x6585>
 10732cb:	jmp    10732d2 <check_input_run+0x65c2>
 10732cd:	cmp    $0x2f,%edx
 10732d0:	je     10732df <check_input_run+0x65cf>
 10732d2:	inc    %r10d
 10732d5:	mov    %r10d,%eax
 10732d8:	cmp    %r14d,%eax
 10732db:	jb     10732b5 <check_input_run+0x65a5>
 10732dd:	jmp    10732e2 <check_input_run+0x65d2>
 10732df:	mov    %r10d,%eax
 10732e2:	inc    %eax
 10732e4:	mov    %eax,%r10d
 10732e7:	cmp    %r14d,%eax
 10732ea:	jae    1073340 <check_input_run+0x6630>
 10732ec:	mov    %eax,%edx
 10732ee:	jmp    1073315 <check_input_run+0x6605>
 10732f0:	cmp    $0xa,%edi
 10732f3:	jne    107332c <check_input_run+0x661c>
 10732f5:	mov    0x60(%rbx),%rdi
 10732f9:	mov    (%rdi,%rsi,4),%esi
 10732fc:	lea    0x1(%rsi),%r10d
 1073300:	cmp    %r14d,%esi
 1073303:	cmovae %r14d,%r10d
 1073307:	cmp    %edx,%esi
 1073309:	cmovbe %r14d,%r10d
 107330d:	mov    %r10d,%edx
 1073310:	cmp    %r14d,%r10d
 1073313:	jae    1073340 <check_input_run+0x6630>
 1073315:	mov    %edx,%esi
 1073317:	movzbl (%rcx,%rsi,1),%edi
 107331b:	cmp    $0x9,%edi
 107331e:	jg     10732f0 <check_input_run+0x65e0>
 1073320:	cmp    $0x6,%edi
 1073323:	je     10732f5 <check_input_run+0x65e5>
 1073325:	cmp    $0x8,%edi
 1073328:	je     10732f5 <check_input_run+0x65e5>
 107332a:	jmp    1073331 <check_input_run+0x6621>
 107332c:	cmp    $0x33,%edi
 107332f:	je     107333d <check_input_run+0x662d>
 1073331:	inc    %edx
 1073333:	mov    %edx,%r10d
 1073336:	cmp    %r14d,%r10d
 1073339:	jb     1073315 <check_input_run+0x6605>
 107333b:	jmp    1073340 <check_input_run+0x6630>
 107333d:	mov    %edx,%r10d
 1073340:	cmp    %eax,%r8d
 1073343:	jb     107334e <check_input_run+0x663e>
 1073345:	cmp    %r10d,%r8d
 1073348:	jb     1073273 <check_input_run+0x6563>
 107334e:	cmp    %r10d,%eax
 1073351:	jae    10733df <check_input_run+0x66cf>
 1073357:	mov    0x2a0(%rsp),%rcx
 107335f:	cmpq   $0x0,0x2c8(%rcx)
 1073367:	je     10733df <check_input_run+0x66cf>
 1073369:	mov    0x2a8(%rsp),%rcx
 1073371:	cmp    0x30(%rcx),%r10d
 1073375:	ja     10733df <check_input_run+0x66cf>
 1073377:	mov    %r10d,%edx
 107337a:	sub    %eax,%edx
 107337c:	mov    %eax,%esi
 107337e:	mov    %rsi,%rcx
 1073381:	and    $0x3,%edx
 1073384:	je     10733d3 <check_input_run+0x66c3>
 1073386:	mov    %rsi,%rcx
 1073389:	jmp    1073393 <check_input_run+0x6683>
 107338b:	inc    %rcx
 107338e:	dec    %rdx
 1073391:	je     10733d3 <check_input_run+0x66c3>
 1073393:	mov    0x520(%rsp),%rdi
 107339b:	test   %rdi,%rdi
 107339e:	je     10733a6 <check_input_run+0x6696>
 10733a0:	testb  $0x2,(%rdi,%rcx,1)
 10733a4:	jne    107338b <check_input_run+0x667b>
 10733a6:	mov    0x2a0(%rsp),%rdi
 10733ae:	mov    0x2c8(%rdi),%rdi
 10733b5:	andb   $0xf7,(%rdi,%rcx,1)
 10733b9:	mov    0x2a0(%rsp),%rdi
 10733c1:	mov    0x2d0(%rdi),%rdi
 10733c8:	test   %rdi,%rdi
 10733cb:	je     107338b <check_input_run+0x667b>
 10733cd:	andb   $0xf7,(%rdi,%rcx,1)
 10733d1:	jmp    107338b <check_input_run+0x667b>
 10733d3:	mov    %r10d,%edx
 10733d6:	sub    %rdx,%rsi
 10733d9:	cmp    $0xfffffffffffffffc,%rsi
 10733dd:	jbe    107342d <check_input_run+0x671d>
 10733df:	cmp    %r10d,%eax
 10733e2:	jae    1073273 <check_input_run+0x6563>
 10733e8:	cmpq   $0x0,0x528(%rsp)
 10733f1:	je     1073273 <check_input_run+0x6563>
 10733f7:	mov    0x2a8(%rsp),%rcx
 10733ff:	cmp    0x30(%rcx),%r10d
 1073403:	ja     1073273 <check_input_run+0x6563>
 1073409:	mov    %r10d,%ecx
 107340c:	sub    %eax,%ecx
 107340e:	mov    %eax,%edx
 1073410:	mov    %rdx,%rax
 1073413:	and    $0x3,%ecx
 1073416:	je     1073564 <check_input_run+0x6854>
 107341c:	mov    %rdx,%rax
 107341f:	jmp    107354f <check_input_run+0x683f>
 1073424:	add    $0x4,%rcx
 1073428:	cmp    %rcx,%rdx
 107342b:	je     10733df <check_input_run+0x66cf>
 107342d:	mov    0x520(%rsp),%rsi
 1073435:	test   %rsi,%rsi
 1073438:	je     1073440 <check_input_run+0x6730>
 107343a:	testb  $0x2,(%rsi,%rcx,1)
 107343e:	jne    107346b <check_input_run+0x675b>
 1073440:	mov    0x2a0(%rsp),%rsi
 1073448:	mov    0x2c8(%rsi),%rsi
 107344f:	andb   $0xf7,(%rsi,%rcx,1)
 1073453:	mov    0x2a0(%rsp),%rsi
 107345b:	mov    0x2d0(%rsi),%rsi
 1073462:	test   %rsi,%rsi
 1073465:	je     107346b <check_input_run+0x675b>
 1073467:	andb   $0xf7,(%rsi,%rcx,1)
 107346b:	mov    0x520(%rsp),%rsi
 1073473:	test   %rsi,%rsi
 1073476:	je     107347f <check_input_run+0x676f>
 1073478:	testb  $0x2,0x1(%rsi,%rcx,1)
 107347d:	jne    10734ac <check_input_run+0x679c>
 107347f:	mov    0x2a0(%rsp),%rsi
 1073487:	mov    0x2c8(%rsi),%rsi
 107348e:	andb   $0xf7,0x1(%rsi,%rcx,1)
 1073493:	mov    0x2a0(%rsp),%rsi
 107349b:	mov    0x2d0(%rsi),%rsi
 10734a2:	test   %rsi,%rsi
 10734a5:	je     10734ac <check_input_run+0x679c>
 10734a7:	andb   $0xf7,0x1(%rsi,%rcx,1)
 10734ac:	mov    0x520(%rsp),%rsi
 10734b4:	test   %rsi,%rsi
 10734b7:	je     10734c0 <check_input_run+0x67b0>
 10734b9:	testb  $0x2,0x2(%rsi,%rcx,1)
 10734be:	jne    10734ed <check_input_run+0x67dd>
 10734c0:	mov    0x2a0(%rsp),%rsi
 10734c8:	mov    0x2c8(%rsi),%rsi
 10734cf:	andb   $0xf7,0x2(%rsi,%rcx,1)
 10734d4:	mov    0x2a0(%rsp),%rsi
 10734dc:	mov    0x2d0(%rsi),%rsi
 10734e3:	test   %rsi,%rsi
 10734e6:	je     10734ed <check_input_run+0x67dd>
 10734e8:	andb   $0xf7,0x2(%rsi,%rcx,1)
 10734ed:	mov    0x520(%rsp),%rsi
 10734f5:	test   %rsi,%rsi
 10734f8:	je     1073505 <check_input_run+0x67f5>
 10734fa:	testb  $0x2,0x3(%rsi,%rcx,1)
 10734ff:	jne    1073424 <check_input_run+0x6714>
 1073505:	mov    0x2a0(%rsp),%rsi
 107350d:	mov    0x2c8(%rsi),%rsi
 1073514:	andb   $0xf7,0x3(%rsi,%rcx,1)
 1073519:	mov    0x2a0(%rsp),%rsi
 1073521:	mov    0x2d0(%rsi),%rsi
 1073528:	test   %rsi,%rsi
 107352b:	je     1073424 <check_input_run+0x6714>
 1073531:	andb   $0xf7,0x3(%rsi,%rcx,1)
 1073536:	jmp    1073424 <check_input_run+0x6714>
 107353b:	mov    0x528(%rsp),%rsi
 1073543:	orb    $0x8,(%rsi,%rax,1)
 1073547:	inc    %rax
 107354a:	dec    %rcx
 107354d:	je     1073564 <check_input_run+0x6854>
 107354f:	mov    0x520(%rsp),%rsi
 1073557:	test   %rsi,%rsi
 107355a:	je     107353b <check_input_run+0x682b>
 107355c:	testb  $0x2,(%rsi,%rax,1)
 1073560:	je     107353b <check_input_run+0x682b>
 1073562:	jmp    1073547 <check_input_run+0x6837>
 1073564:	mov    %r10d,%ecx
 1073567:	sub    %rcx,%rdx
 107356a:	cmp    $0xfffffffffffffffc,%rdx
 107356e:	jbe    107358f <check_input_run+0x687f>
 1073570:	jmp    1073273 <check_input_run+0x6563>
 1073575:	mov    0x528(%rsp),%rdx
 107357d:	orb    $0x8,0x3(%rdx,%rax,1)
 1073582:	add    $0x4,%rax
 1073586:	cmp    %rax,%rcx
 1073589:	je     1073273 <check_input_run+0x6563>
 107358f:	mov    0x520(%rsp),%rdx
 1073597:	test   %rdx,%rdx
 107359a:	je     10735a2 <check_input_run+0x6892>
 107359c:	testb  $0x2,(%rdx,%rax,1)
 10735a0:	jne    10735ae <check_input_run+0x689e>
 10735a2:	mov    0x528(%rsp),%rdx
 10735aa:	orb    $0x8,(%rdx,%rax,1)
 10735ae:	mov    0x520(%rsp),%rdx
 10735b6:	test   %rdx,%rdx
 10735b9:	je     10735c2 <check_input_run+0x68b2>
 10735bb:	testb  $0x2,0x1(%rdx,%rax,1)
 10735c0:	jne    10735cf <check_input_run+0x68bf>
 10735c2:	mov    0x528(%rsp),%rdx
 10735ca:	orb    $0x8,0x1(%rdx,%rax,1)
 10735cf:	mov    0x520(%rsp),%rdx
 10735d7:	test   %rdx,%rdx
 10735da:	je     10735e3 <check_input_run+0x68d3>
 10735dc:	testb  $0x2,0x2(%rdx,%rax,1)
 10735e1:	jne    10735f0 <check_input_run+0x68e0>
 10735e3:	mov    0x528(%rsp),%rdx
 10735eb:	orb    $0x8,0x2(%rdx,%rax,1)
 10735f0:	mov    0x520(%rsp),%rdx
 10735f8:	test   %rdx,%rdx
 10735fb:	je     1073575 <check_input_run+0x6865>
 1073601:	testb  $0x2,0x3(%rdx,%rax,1)
 1073606:	je     1073575 <check_input_run+0x6865>
 107360c:	jmp    1073582 <check_input_run+0x6872>
 1073611:	xor    %edx,%edx
 1073613:	mov    0x2c8(%rsp),%rax
 107361b:	mov    0xd8(%rsp),%rcx
 1073623:	cmp    0x8(%rax),%rcx
 1073627:	ja     107a28f <check_input_run+0xd57f>
 107362d:	mov    %rcx,0x8(%rax)
 1073631:	mov    0x20(%rsp),%r12
 1073636:	mov    0x70(%rsp),%edi
 107363a:	lea    0x700(%rsp),%r15
 1073642:	mov    0x2a0(%rsp),%rax
 107364a:	cmpq   $0x0,0x2c8(%rax)
 1073652:	je     10736cb <check_input_run+0x69bb>
 1073654:	mov    0x2a8(%rsp),%rax
 107365c:	cmp    0x30(%rax),%ebp
 107365f:	ja     10736cb <check_input_run+0x69bb>
 1073661:	mov    %ebp,%ecx
 1073663:	sub    %edi,%ecx
 1073665:	mov    %edi,%esi
 1073667:	mov    %rsi,%rax
 107366a:	and    $0x3,%ecx
 107366d:	je     10736bc <check_input_run+0x69ac>
 107366f:	mov    %rsi,%rax
 1073672:	jmp    107367c <check_input_run+0x696c>
 1073674:	inc    %rax
 1073677:	dec    %rcx
 107367a:	je     10736bc <check_input_run+0x69ac>
 107367c:	mov    0x520(%rsp),%rdi
 1073684:	test   %rdi,%rdi
 1073687:	je     107368f <check_input_run+0x697f>
 1073689:	testb  $0x2,(%rdi,%rax,1)
 107368d:	jne    1073674 <check_input_run+0x6964>
 107368f:	mov    0x2a0(%rsp),%rdi
 1073697:	mov    0x2c8(%rdi),%rdi
 107369e:	andb   $0x87,(%rdi,%rax,1)
 10736a2:	mov    0x2a0(%rsp),%rdi
 10736aa:	mov    0x2d0(%rdi),%rdi
 10736b1:	test   %rdi,%rdi
 10736b4:	je     1073674 <check_input_run+0x6964>
 10736b6:	andb   $0x87,(%rdi,%rax,1)
 10736ba:	jmp    1073674 <check_input_run+0x6964>
 10736bc:	mov    0x70(%rsp),%edi
 10736c0:	mov    %ebp,%ecx
 10736c2:	sub    %rcx,%rsi
 10736c5:	cmp    $0xfffffffffffffffc,%rsi
 10736c9:	jbe    107370e <check_input_run+0x69fe>
 10736cb:	cmpq   $0x0,0x528(%rsp)
 10736d4:	je     1073850 <check_input_run+0x6b40>
 10736da:	mov    0x2a8(%rsp),%rax
 10736e2:	cmp    0x30(%rax),%ebp
 10736e5:	ja     1073850 <check_input_run+0x6b40>
 10736eb:	mov    %ebp,%ecx
 10736ed:	sub    %edi,%ecx
 10736ef:	mov    %edi,%esi
 10736f1:	mov    %rsi,%rax
 10736f4:	and    $0x3,%ecx
 10736f7:	je     1073845 <check_input_run+0x6b35>
 10736fd:	mov    %rsi,%rax
 1073700:	jmp    1073830 <check_input_run+0x6b20>
 1073705:	add    $0x4,%rax
 1073709:	cmp    %rax,%rcx
 107370c:	je     10736cb <check_input_run+0x69bb>
 107370e:	mov    0x520(%rsp),%rsi
 1073716:	test   %rsi,%rsi
 1073719:	je     1073721 <check_input_run+0x6a11>
 107371b:	testb  $0x2,(%rsi,%rax,1)
 107371f:	jne    107374c <check_input_run+0x6a3c>
 1073721:	mov    0x2a0(%rsp),%rsi
 1073729:	mov    0x2c8(%rsi),%rsi
 1073730:	andb   $0x87,(%rsi,%rax,1)
 1073734:	mov    0x2a0(%rsp),%rsi
 107373c:	mov    0x2d0(%rsi),%rsi
 1073743:	test   %rsi,%rsi
 1073746:	je     107374c <check_input_run+0x6a3c>
 1073748:	andb   $0x87,(%rsi,%rax,1)
 107374c:	mov    0x520(%rsp),%rsi
 1073754:	test   %rsi,%rsi
 1073757:	je     1073760 <check_input_run+0x6a50>
 1073759:	testb  $0x2,0x1(%rsi,%rax,1)
 107375e:	jne    107378d <check_input_run+0x6a7d>
 1073760:	mov    0x2a0(%rsp),%rsi
 1073768:	mov    0x2c8(%rsi),%rsi
 107376f:	andb   $0x87,0x1(%rsi,%rax,1)
 1073774:	mov    0x2a0(%rsp),%rsi
 107377c:	mov    0x2d0(%rsi),%rsi
 1073783:	test   %rsi,%rsi
 1073786:	je     107378d <check_input_run+0x6a7d>
 1073788:	andb   $0x87,0x1(%rsi,%rax,1)
 107378d:	mov    0x520(%rsp),%rsi
 1073795:	test   %rsi,%rsi
 1073798:	je     10737a1 <check_input_run+0x6a91>
 107379a:	testb  $0x2,0x2(%rsi,%rax,1)
 107379f:	jne    10737ce <check_input_run+0x6abe>
 10737a1:	mov    0x2a0(%rsp),%rsi
 10737a9:	mov    0x2c8(%rsi),%rsi
 10737b0:	andb   $0x87,0x2(%rsi,%rax,1)
 10737b5:	mov    0x2a0(%rsp),%rsi
 10737bd:	mov    0x2d0(%rsi),%rsi
 10737c4:	test   %rsi,%rsi
 10737c7:	je     10737ce <check_input_run+0x6abe>
 10737c9:	andb   $0x87,0x2(%rsi,%rax,1)
 10737ce:	mov    0x520(%rsp),%rsi
 10737d6:	test   %rsi,%rsi
 10737d9:	je     10737e6 <check_input_run+0x6ad6>
 10737db:	testb  $0x2,0x3(%rsi,%rax,1)
 10737e0:	jne    1073705 <check_input_run+0x69f5>
 10737e6:	mov    0x2a0(%rsp),%rsi
 10737ee:	mov    0x2c8(%rsi),%rsi
 10737f5:	andb   $0x87,0x3(%rsi,%rax,1)
 10737fa:	mov    0x2a0(%rsp),%rsi
 1073802:	mov    0x2d0(%rsi),%rsi
 1073809:	test   %rsi,%rsi
 107380c:	je     1073705 <check_input_run+0x69f5>
 1073812:	andb   $0x87,0x3(%rsi,%rax,1)
 1073817:	jmp    1073705 <check_input_run+0x69f5>
 107381c:	mov    0x528(%rsp),%rdi
 1073824:	orb    $0x78,(%rdi,%rax,1)
 1073828:	inc    %rax
 107382b:	dec    %rcx
 107382e:	je     1073845 <check_input_run+0x6b35>
 1073830:	mov    0x520(%rsp),%rdi
 1073838:	test   %rdi,%rdi
 107383b:	je     107381c <check_input_run+0x6b0c>
 107383d:	testb  $0x2,(%rdi,%rax,1)
 1073841:	je     107381c <check_input_run+0x6b0c>
 1073843:	jmp    1073828 <check_input_run+0x6b18>
 1073845:	mov    %ebp,%ecx
 1073847:	sub    %rcx,%rsi
 107384a:	cmp    $0xfffffffffffffffc,%rsi
 107384e:	jbe    1073873 <check_input_run+0x6b63>
 1073850:	test   %dl,%dl
 1073852:	jne    1072a4c <check_input_run+0x5d3c>
 1073858:	jmp    1072b43 <check_input_run+0x5e33>
 107385d:	mov    0x528(%rsp),%rsi
 1073865:	orb    $0x78,0x3(%rsi,%rax,1)
 107386a:	add    $0x4,%rax
 107386e:	cmp    %rax,%rcx
 1073871:	je     1073850 <check_input_run+0x6b40>
 1073873:	mov    0x520(%rsp),%rsi
 107387b:	test   %rsi,%rsi
 107387e:	je     1073886 <check_input_run+0x6b76>
 1073880:	testb  $0x2,(%rsi,%rax,1)
 1073884:	jne    1073892 <check_input_run+0x6b82>
 1073886:	mov    0x528(%rsp),%rsi
 107388e:	orb    $0x78,(%rsi,%rax,1)
 1073892:	mov    0x520(%rsp),%rsi
 107389a:	test   %rsi,%rsi
 107389d:	je     10738a6 <check_input_run+0x6b96>
 107389f:	testb  $0x2,0x1(%rsi,%rax,1)
 10738a4:	jne    10738b3 <check_input_run+0x6ba3>
 10738a6:	mov    0x528(%rsp),%rsi
 10738ae:	orb    $0x78,0x1(%rsi,%rax,1)
 10738b3:	mov    0x520(%rsp),%rsi
 10738bb:	test   %rsi,%rsi
 10738be:	je     10738c7 <check_input_run+0x6bb7>
 10738c0:	testb  $0x2,0x2(%rsi,%rax,1)
 10738c5:	jne    10738d4 <check_input_run+0x6bc4>
 10738c7:	mov    0x528(%rsp),%rsi
 10738cf:	orb    $0x78,0x2(%rsi,%rax,1)
 10738d4:	mov    0x520(%rsp),%rsi
 10738dc:	test   %rsi,%rsi
 10738df:	je     107385d <check_input_run+0x6b4d>
 10738e5:	testb  $0x2,0x3(%rsi,%rax,1)
 10738ea:	je     107385d <check_input_run+0x6b4d>
 10738f0:	jmp    107386a <check_input_run+0x6b5a>
 10738f5:	mov    %ecx,%r15d
 10738f8:	cmp    %r14d,%r15d
 10738fb:	jae    1073c5b <check_input_run+0x6f4b>
 1073901:	cmpl   $0x0,0x7d4(%rsp)
 1073909:	jne    1073c5b <check_input_run+0x6f4b>
 107390f:	cmpl   $0x1,0x78c(%rsp)
 1073917:	jne    1073c5b <check_input_run+0x6f4b>
 107391d:	mov    0x788(%rsp),%ecx
 1073924:	mov    %ecx,%eax
 1073926:	and    $0x10,%eax
 1073929:	mov    %ecx,0x98(%rsp)
 1073930:	shr    $0x4,%eax
 1073933:	test   $0x401,%ecx
 1073939:	sete   %cl
 107393c:	or     %al,%cl
 107393e:	jne    1073c5b <check_input_run+0x6f4b>
 1073944:	mov    0x2b8(%rsp),%rdi
 107394c:	lea    0x780(%rsp),%rsi
 1073954:	lea    0x700(%rsp),%rdx
 107395c:	vzeroupper
 107395f:	call   10ab900 <check_action_truth>
 1073964:	mov    0x1b0(%rsp),%r9
 107396c:	mov    0x30(%rsp),%r11
 1073971:	vpxor  %xmm0,%xmm0,%xmm0
 1073975:	test   %al,%al
 1073977:	je     1073c5b <check_input_run+0x6f4b>
 107397d:	movzbl 0x700(%rsp),%ecx
 1073985:	lea    0x1(%r15),%edi
 1073989:	mov    %r14d,%esi
 107398c:	mov    %edi,%edx
 107398e:	test   %cl,%cl
 1073990:	cmovne %ebx,%edx
 1073993:	cmovne %r15d,%esi
 1073997:	cmp    %esi,%edx
 1073999:	jae    1073c5b <check_input_run+0x6f4b>
 107399f:	mov    0x60(%r9),%r10
 10739a3:	mov    %esi,%r8d
 10739a6:	mov    %rdx,%rax
 10739a9:	sub    %r8,%rax
 10739ac:	sub    %rdx,%r8
 10739af:	mov    %cl,0x90(%rsp)
 10739b6:	mov    %edi,0x130(%rsp)
 10739bd:	mov    %r8,0x28(%rsp)
 10739c2:	and    $0x7,%r8d
 10739c6:	mov    %r10,0x50(%rsp)
 10739cb:	cmp    $0xfffffffffffffff8,%rax
 10739cf:	jbe    10739ff <check_input_run+0x6cef>
 10739d1:	xor    %ecx,%ecx
 10739d3:	mov    $0xffffffff,%eax
 10739d8:	mov    %rdx,%r9
 10739db:	jmp    1073b62 <check_input_run+0x6e52>
 10739e0:	mov    0x30(%rsp),%r11
 10739e5:	mov    0x1b0(%rsp),%r9
 10739ed:	xor    %edx,%edx
 10739ef:	vpxor  %xmm0,%xmm0,%xmm0
 10739f3:	jmp    1073613 <check_input_run+0x6903>
 10739f8:	mov    $0x1,%dl
 10739fa:	jmp    1073613 <check_input_run+0x6903>
 10739ff:	andq   $0xfffffffffffffff8,0x28(%rsp)
 1073a05:	lea    0x1c(%r10,%rdx,4),%r11
 1073a0a:	mov    $0xffffffff,%eax
 1073a0f:	xor    %ecx,%ecx
 1073a11:	xor    %r9d,%r9d
 1073a14:	mov    -0x1c(%r11,%r9,4),%r12d
 1073a19:	mov    -0x18(%r11,%r9,4),%edi
 1073a1e:	cmp    %edx,%r12d
 1073a21:	setb   %r10b
 1073a25:	cmp    %esi,%r12d
 1073a28:	setae  %r12b
 1073a2c:	or     %r10b,%r12b
 1073a2f:	movzbl %r12b,%r10d
 1073a33:	lea    (%rdx,%r9,1),%r12d
 1073a37:	add    %r10d,%ecx
 1073a3a:	test   %r10b,%r10b
 1073a3d:	cmovne %r12d,%eax
 1073a41:	cmp    %edx,%edi
 1073a43:	setb   %r10b
 1073a47:	cmp    %esi,%edi
 1073a49:	setae  %dil
 1073a4d:	or     %r10b,%dil
 1073a50:	lea    0x1(%rdx,%r9,1),%r10d
 1073a55:	movzbl %dil,%r12d
 1073a59:	test   %r12b,%r12b
 1073a5c:	cmove  %eax,%r10d
 1073a60:	mov    -0x14(%r11,%r9,4),%eax
 1073a65:	cmp    %edx,%eax
 1073a67:	setb   %dil
 1073a6b:	cmp    %esi,%eax
 1073a6d:	setae  %al
 1073a70:	or     %dil,%al
 1073a73:	movzbl %al,%eax
 1073a76:	add    %eax,%r12d
 1073a79:	add    %ecx,%r12d
 1073a7c:	test   %al,%al
 1073a7e:	mov    -0x10(%r11,%r9,4),%eax
 1073a83:	lea    0x2(%rdx,%r9,1),%ecx
 1073a88:	cmove  %r10d,%ecx
 1073a8c:	cmp    %edx,%eax
 1073a8e:	setb   %dil
 1073a92:	cmp    %esi,%eax
 1073a94:	setae  %al
 1073a97:	or     %dil,%al
 1073a9a:	lea    0x3(%rdx,%r9,1),%edi
 1073a9f:	movzbl %al,%eax
 1073aa2:	test   %al,%al
 1073aa4:	cmove  %ecx,%edi
 1073aa7:	mov    -0xc(%r11,%r9,4),%ecx
 1073aac:	cmp    %edx,%ecx
 1073aae:	setb   %r10b
 1073ab2:	cmp    %esi,%ecx
 1073ab4:	setae  %cl
 1073ab7:	or     %r10b,%cl
 1073aba:	lea    0x4(%rdx,%r9,1),%r10d
 1073abf:	movzbl %cl,%ecx
 1073ac2:	add    %ecx,%eax
 1073ac4:	test   %cl,%cl
 1073ac6:	mov    -0x8(%r11,%r9,4),%ecx
 1073acb:	cmove  %edi,%r10d
 1073acf:	cmp    %edx,%ecx
 1073ad1:	setb   %dil
 1073ad5:	cmp    %esi,%ecx
 1073ad7:	setae  %cl
 1073ada:	or     %dil,%cl
 1073add:	lea    0x5(%rdx,%r9,1),%edi
 1073ae2:	movzbl %cl,%ecx
 1073ae5:	add    %ecx,%eax
 1073ae7:	add    %r12d,%eax
 1073aea:	test   %cl,%cl
 1073aec:	mov    -0x4(%r11,%r9,4),%ecx
 1073af1:	cmove  %r10d,%edi
 1073af5:	cmp    %edx,%ecx
 1073af7:	setb   %r10b
 1073afb:	cmp    %esi,%ecx
 1073afd:	setae  %cl
 1073b00:	or     %r10b,%cl
 1073b03:	lea    0x6(%rdx,%r9,1),%r10d
 1073b08:	movzbl %cl,%ecx
 1073b0b:	test   %cl,%cl
 1073b0d:	cmove  %edi,%r10d
 1073b11:	mov    (%r11,%r9,4),%edi
 1073b15:	cmp    %edx,%edi
 1073b17:	setb   %r12b
 1073b1b:	cmp    %esi,%edi
 1073b1d:	setae  %dil
 1073b21:	or     %r12b,%dil
 1073b24:	movzbl %dil,%edi
 1073b28:	add    %edi,%ecx
 1073b2a:	add    %eax,%ecx
 1073b2c:	lea    0x7(%rdx,%r9,1),%eax
 1073b31:	test   %dil,%dil
 1073b34:	cmove  %r10d,%eax
 1073b38:	add    $0x8,%r9
 1073b3c:	cmp    %r9,0x28(%rsp)
 1073b41:	jne    1073a14 <check_input_run+0x6d04>
 1073b47:	test   %r8,%r8
 1073b4a:	je     1073c68 <check_input_run+0x6f58>
 1073b50:	mov    0x20(%rsp),%r12
 1073b55:	mov    0x30(%rsp),%r11
 1073b5a:	mov    0x50(%rsp),%r10
 1073b5f:	add    %rdx,%r9
 1073b62:	mov    (%r10,%r9,4),%edi
 1073b66:	cmp    %edx,%edi
 1073b68:	setb   %r10b
 1073b6c:	cmp    %esi,%edi
 1073b6e:	setae  %dil
 1073b72:	or     %r10b,%dil
 1073b75:	mov    0x50(%rsp),%r10
 1073b7a:	movzbl %dil,%edi
 1073b7e:	add    %edi,%ecx
 1073b80:	test   %dil,%dil
 1073b83:	cmovne %r9d,%eax
 1073b87:	inc    %r9
 1073b8a:	dec    %r8
 1073b8d:	jne    1073b62 <check_input_run+0x6e52>
 1073b8f:	mov    0x1b0(%rsp),%r9
 1073b97:	movzbl 0x90(%rsp),%esi
 1073b9f:	mov    0x130(%rsp),%edi
 1073ba6:	cmp    $0x1,%ecx
 1073ba9:	jne    1073c5b <check_input_run+0x6f4b>
 1073baf:	cmp    $0xffffffff,%eax
 1073bb2:	je     1073c5b <check_input_run+0x6f4b>
 1073bb8:	mov    0x440(%rsp),%rcx
 1073bc0:	mov    %eax,(%rcx,%r14,4)
 1073bc4:	mov    0x2a0(%rsp),%rax
 1073bcc:	mov    0x2a8(%rsp),%rcx
 1073bd4:	cmp    0x30(%rcx),%ebp
 1073bd7:	ja     1073c9c <check_input_run+0x6f8c>
 1073bdd:	mov    0x2c8(%rax),%rdx
 1073be4:	mov    0x98(%rsp),%r8d
 1073bec:	test   %rdx,%rdx
 1073bef:	sete   %cl
 1073bf2:	or     %cl,%r8b
 1073bf5:	test   $0x1,%r8b
 1073bf9:	jne    1073c9c <check_input_run+0x6f8c>
 1073bff:	mov    0x70(%rsp),%ecx
 1073c03:	movzbl (%rdx,%rcx,1),%esi
 1073c07:	mov    %esi,%eax
 1073c09:	or     $0x2,%al
 1073c0b:	mov    %al,(%rdx,%rcx,1)
 1073c0e:	mov    0x2a0(%rsp),%rax
 1073c16:	mov    0x2d0(%rax),%rdx
 1073c1d:	test   %rdx,%rdx
 1073c20:	je     1073c77 <check_input_run+0x6f67>
 1073c22:	and    $0x2,%sil
 1073c26:	mov    0x20(%rsp),%r12
 1073c2b:	mov    0x30(%rsp),%r11
 1073c30:	mov    0x1b0(%rsp),%r9
 1073c38:	movzbl 0x90(%rsp),%esi
 1073c40:	mov    0x130(%rsp),%edi
 1073c47:	vpxor  %xmm0,%xmm0,%xmm0
 1073c4b:	jne    1073c9c <check_input_run+0x6f8c>
 1073c4d:	orb    $0x2,(%rdx,%rcx,1)
 1073c51:	mov    0x2a0(%rsp),%rax
 1073c59:	jmp    1073c9c <check_input_run+0x6f8c>
 1073c5b:	lea    0x700(%rsp),%r15
 1073c63:	jmp    1072b43 <check_input_run+0x5e33>
 1073c68:	mov    0x20(%rsp),%r12
 1073c6d:	mov    0x30(%rsp),%r11
 1073c72:	jmp    1073b8f <check_input_run+0x6e7f>
 1073c77:	mov    0x20(%rsp),%r12
 1073c7c:	mov    0x30(%rsp),%r11
 1073c81:	mov    0x1b0(%rsp),%r9
 1073c89:	movzbl 0x90(%rsp),%esi
 1073c91:	mov    0x130(%rsp),%edi
 1073c98:	vpxor  %xmm0,%xmm0,%xmm0
 1073c9c:	test   %sil,%sil
 1073c9f:	cmovne %edi,%ebx
 1073ca2:	cmovne %r14d,%r15d
 1073ca6:	cmp    %r15d,%ebx
 1073ca9:	jae    1073d49 <check_input_run+0x7039>
 1073caf:	cmpq   $0x0,0x2c8(%rax)
 1073cb7:	je     1073d49 <check_input_run+0x7039>
 1073cbd:	mov    0x2a8(%rsp),%rax
 1073cc5:	cmp    0x30(%rax),%r15d
 1073cc9:	ja     1073d49 <check_input_run+0x7039>
 1073ccb:	mov    %r15d,%ecx
 1073cce:	sub    %ebx,%ecx
 1073cd0:	mov    %ebx,%edx
 1073cd2:	mov    %rdx,%rax
 1073cd5:	and    $0x3,%ecx
 1073cd8:	je     1073d27 <check_input_run+0x7017>
 1073cda:	mov    %rdx,%rax
 1073cdd:	jmp    1073ce7 <check_input_run+0x6fd7>
 1073cdf:	inc    %rax
 1073ce2:	dec    %rcx
 1073ce5:	je     1073d27 <check_input_run+0x7017>
 1073ce7:	mov    0x520(%rsp),%rsi
 1073cef:	test   %rsi,%rsi
 1073cf2:	je     1073cfa <check_input_run+0x6fea>
 1073cf4:	testb  $0x2,(%rsi,%rax,1)
 1073cf8:	jne    1073cdf <check_input_run+0x6fcf>
 1073cfa:	mov    0x2a0(%rsp),%rsi
 1073d02:	mov    0x2c8(%rsi),%rsi
 1073d09:	andb   $0xf7,(%rsi,%rax,1)
 1073d0d:	mov    0x2a0(%rsp),%rsi
 1073d15:	mov    0x2d0(%rsi),%rsi
 1073d1c:	test   %rsi,%rsi
 1073d1f:	je     1073cdf <check_input_run+0x6fcf>
 1073d21:	andb   $0xf7,(%rsi,%rax,1)
 1073d25:	jmp    1073cdf <check_input_run+0x6fcf>
 1073d27:	mov    0x20(%rsp),%r12
 1073d2c:	mov    0x30(%rsp),%r11
 1073d31:	mov    0x1b0(%rsp),%r9
 1073d39:	mov    %r15d,%ecx
 1073d3c:	sub    %rcx,%rdx
 1073d3f:	vpxor  %xmm0,%xmm0,%xmm0
 1073d43:	cmp    $0xfffffffffffffffc,%rdx
 1073d47:	jbe    1073d97 <check_input_run+0x7087>
 1073d49:	cmp    %r15d,%ebx
 1073d4c:	jae    1073ef0 <check_input_run+0x71e0>
 1073d52:	cmpq   $0x0,0x528(%rsp)
 1073d5b:	je     1073ef0 <check_input_run+0x71e0>
 1073d61:	mov    0x2a8(%rsp),%rax
 1073d69:	cmp    0x30(%rax),%r15d
 1073d6d:	ja     1073ef0 <check_input_run+0x71e0>
 1073d73:	mov    %r15d,%ecx
 1073d76:	sub    %ebx,%ecx
 1073d78:	mov    %ebx,%edx
 1073d7a:	mov    %rdx,%rax
 1073d7d:	and    $0x3,%ecx
 1073d80:	je     1073ece <check_input_run+0x71be>
 1073d86:	mov    %rdx,%rax
 1073d89:	jmp    1073eb9 <check_input_run+0x71a9>
 1073d8e:	add    $0x4,%rax
 1073d92:	cmp    %rax,%rcx
 1073d95:	je     1073d49 <check_input_run+0x7039>
 1073d97:	mov    0x520(%rsp),%rdx
 1073d9f:	test   %rdx,%rdx
 1073da2:	je     1073daa <check_input_run+0x709a>
 1073da4:	testb  $0x2,(%rdx,%rax,1)
 1073da8:	jne    1073dd5 <check_input_run+0x70c5>
 1073daa:	mov    0x2a0(%rsp),%rdx
 1073db2:	mov    0x2c8(%rdx),%rdx
 1073db9:	andb   $0xf7,(%rdx,%rax,1)
 1073dbd:	mov    0x2a0(%rsp),%rdx
 1073dc5:	mov    0x2d0(%rdx),%rdx
 1073dcc:	test   %rdx,%rdx
 1073dcf:	je     1073dd5 <check_input_run+0x70c5>
 1073dd1:	andb   $0xf7,(%rdx,%rax,1)
 1073dd5:	mov    0x520(%rsp),%rdx
 1073ddd:	test   %rdx,%rdx
 1073de0:	je     1073de9 <check_input_run+0x70d9>
 1073de2:	testb  $0x2,0x1(%rdx,%rax,1)
 1073de7:	jne    1073e16 <check_input_run+0x7106>
 1073de9:	mov    0x2a0(%rsp),%rdx
 1073df1:	mov    0x2c8(%rdx),%rdx
 1073df8:	andb   $0xf7,0x1(%rdx,%rax,1)
 1073dfd:	mov    0x2a0(%rsp),%rdx
 1073e05:	mov    0x2d0(%rdx),%rdx
 1073e0c:	test   %rdx,%rdx
 1073e0f:	je     1073e16 <check_input_run+0x7106>
 1073e11:	andb   $0xf7,0x1(%rdx,%rax,1)
 1073e16:	mov    0x520(%rsp),%rdx
 1073e1e:	test   %rdx,%rdx
 1073e21:	je     1073e2a <check_input_run+0x711a>
 1073e23:	testb  $0x2,0x2(%rdx,%rax,1)
 1073e28:	jne    1073e57 <check_input_run+0x7147>
 1073e2a:	mov    0x2a0(%rsp),%rdx
 1073e32:	mov    0x2c8(%rdx),%rdx
 1073e39:	andb   $0xf7,0x2(%rdx,%rax,1)
 1073e3e:	mov    0x2a0(%rsp),%rdx
 1073e46:	mov    0x2d0(%rdx),%rdx
 1073e4d:	test   %rdx,%rdx
 1073e50:	je     1073e57 <check_input_run+0x7147>
 1073e52:	andb   $0xf7,0x2(%rdx,%rax,1)
 1073e57:	mov    0x520(%rsp),%rdx
 1073e5f:	test   %rdx,%rdx
 1073e62:	je     1073e6f <check_input_run+0x715f>
 1073e64:	testb  $0x2,0x3(%rdx,%rax,1)
 1073e69:	jne    1073d8e <check_input_run+0x707e>
 1073e6f:	mov    0x2a0(%rsp),%rdx
 1073e77:	mov    0x2c8(%rdx),%rdx
 1073e7e:	andb   $0xf7,0x3(%rdx,%rax,1)
 1073e83:	mov    0x2a0(%rsp),%rdx
 1073e8b:	mov    0x2d0(%rdx),%rdx
 1073e92:	test   %rdx,%rdx
 1073e95:	je     1073d8e <check_input_run+0x707e>
 1073e9b:	andb   $0xf7,0x3(%rdx,%rax,1)
 1073ea0:	jmp    1073d8e <check_input_run+0x707e>
 1073ea5:	mov    0x528(%rsp),%rsi
 1073ead:	orb    $0x8,(%rsi,%rax,1)
 1073eb1:	inc    %rax
 1073eb4:	dec    %rcx
 1073eb7:	je     1073ece <check_input_run+0x71be>
 1073eb9:	mov    0x520(%rsp),%rsi
 1073ec1:	test   %rsi,%rsi
 1073ec4:	je     1073ea5 <check_input_run+0x7195>
 1073ec6:	testb  $0x2,(%rsi,%rax,1)
 1073eca:	je     1073ea5 <check_input_run+0x7195>
 1073ecc:	jmp    1073eb1 <check_input_run+0x71a1>
 1073ece:	mov    0x20(%rsp),%r12
 1073ed3:	mov    0x30(%rsp),%r11
 1073ed8:	mov    0x1b0(%rsp),%r9
 1073ee0:	mov    %r15d,%ecx
 1073ee3:	sub    %rcx,%rdx
 1073ee6:	vpxor  %xmm0,%xmm0,%xmm0
 1073eea:	cmp    $0xfffffffffffffffc,%rdx
 1073eee:	jbe    1073f13 <check_input_run+0x7203>
 1073ef0:	lea    0x700(%rsp),%r15
 1073ef8:	jmp    1072a4c <check_input_run+0x5d3c>
 1073efd:	mov    0x528(%rsp),%rdx
 1073f05:	orb    $0x8,0x3(%rdx,%rax,1)
 1073f0a:	add    $0x4,%rax
 1073f0e:	cmp    %rax,%rcx
 1073f11:	je     1073ef0 <check_input_run+0x71e0>
 1073f13:	mov    0x520(%rsp),%rdx
 1073f1b:	test   %rdx,%rdx
 1073f1e:	je     1073f26 <check_input_run+0x7216>
 1073f20:	testb  $0x2,(%rdx,%rax,1)
 1073f24:	jne    1073f32 <check_input_run+0x7222>
 1073f26:	mov    0x528(%rsp),%rdx
 1073f2e:	orb    $0x8,(%rdx,%rax,1)
 1073f32:	mov    0x520(%rsp),%rdx
 1073f3a:	test   %rdx,%rdx
 1073f3d:	je     1073f46 <check_input_run+0x7236>
 1073f3f:	testb  $0x2,0x1(%rdx,%rax,1)
 1073f44:	jne    1073f53 <check_input_run+0x7243>
 1073f46:	mov    0x528(%rsp),%rdx
 1073f4e:	orb    $0x8,0x1(%rdx,%rax,1)
 1073f53:	mov    0x520(%rsp),%rdx
 1073f5b:	test   %rdx,%rdx
 1073f5e:	je     1073f67 <check_input_run+0x7257>
 1073f60:	testb  $0x2,0x2(%rdx,%rax,1)
 1073f65:	jne    1073f74 <check_input_run+0x7264>
 1073f67:	mov    0x528(%rsp),%rdx
 1073f6f:	orb    $0x8,0x2(%rdx,%rax,1)
 1073f74:	mov    0x520(%rsp),%rdx
 1073f7c:	test   %rdx,%rdx
 1073f7f:	je     1073efd <check_input_run+0x71ed>
 1073f85:	testb  $0x2,0x3(%rdx,%rax,1)
 1073f8a:	je     1073efd <check_input_run+0x71ed>
 1073f90:	jmp    1073f0a <check_input_run+0x71fa>
 1073f95:	mov    0x18(%rsp),%rax
 1073f9a:	mov    0x230(%rax),%eax
 1073fa0:	cmpb   $0x0,0x840(%rsp)
 1073fa8:	je     10740a4 <check_input_run+0x7394>
 1073fae:	test   %eax,%eax
 1073fb0:	jne    10740ac <check_input_run+0x739c>
 1073fb6:	mov    0x2a8(%rsp),%rax
 1073fbe:	cmpl   $0x0,0x30(%rax)
 1073fc2:	je     10741db <check_input_run+0x74cb>
 1073fc8:	mov    0x2a0(%rsp),%rdx
 1073fd0:	xor    %ecx,%ecx
 1073fd2:	jmp    1073fef <check_input_run+0x72df>
 1073fd4:	movb   $0x1,0x3bd(%rdx)
 1073fdb:	nopl   0x0(%rax,%rax,1)
 1073fe0:	mov    0x30(%rax),%esi
 1073fe3:	inc    %rcx
 1073fe6:	cmp    %rsi,%rcx
 1073fe9:	jae    1074099 <check_input_run+0x7389>
 1073fef:	mov    0x2a0(%rdx),%rsi
 1073ff6:	cmpb   $0x0,(%rsi,%rcx,1)
 1073ffa:	je     1073fe0 <check_input_run+0x72d0>
 1073ffc:	mov    0x340(%rsp),%rsi
 1074004:	mov    0x2b8(%rsp),%r8
 107400c:	mov    (%rsi,%rcx,4),%edi
 107400f:	mov    (%r8),%r9
 1074012:	mov    0x10(%r8),%rsi
 1074016:	shr    $0x3,%edi
 1074019:	movzbl (%r9,%rdi,1),%r9d
 107401e:	cmp    $0xf,%r9b
 1074022:	jne    1074037 <check_input_run+0x7327>
 1074024:	mov    0x20(%r8),%r8
 1074028:	mov    (%r8,%rdi,4),%edi
 107402c:	shr    $0x3,%edi
 107402f:	testb  $0x4,(%rsi,%rdi,1)
 1074033:	jne    1073fe0 <check_input_run+0x72d0>
 1074035:	jmp    1074047 <check_input_run+0x7337>
 1074037:	cmp    $0x9,%r9b
 107403b:	je     1073fe0 <check_input_run+0x72d0>
 107403d:	movzbl (%rsi,%rdi,1),%esi
 1074041:	and    $0x4,%sil
 1074045:	jne    1073fe0 <check_input_run+0x72d0>
 1074047:	mov    0x230(%rdx),%esi
 107404d:	cmp    0x234(%rdx),%esi
 1074053:	jae    1073fd4 <check_input_run+0x72c4>
 1074059:	movzbl 0x3bd(%rdx),%edi
 1074060:	mov    0x228(%rdx),%r8
 1074067:	lea    0x1(%rsi),%r9d
 107406b:	mov    %r9d,0x230(%rdx)
 1074072:	lea    (%rsi,%rsi,2),%rdx
 1074076:	lea    0x1(%rdi,%rdi,2),%edi
 107407a:	mov    %ecx,(%r8,%rdx,4)
 107407e:	mov    %edi,0x4(%r8,%rdx,4)
 1074083:	movl   $0x0,0x8(%r8,%rdx,4)
 107408c:	mov    0x2a0(%rsp),%rdx
 1074094:	jmp    1073fe0 <check_input_run+0x72d0>
 1074099:	mov    0x18(%rsp),%rax
 107409e:	mov    0x230(%rax),%eax
 10740a4:	test   %eax,%eax
 10740a6:	je     10741db <check_input_run+0x74cb>
 10740ac:	mov    0x670(%rsp),%edi
 10740b3:	mov    %eax,%edx
 10740b5:	mov    %edx,%ecx
 10740b7:	and    $0x7,%ecx
 10740ba:	cmp    $0x8,%eax
 10740bd:	jae    10740c6 <check_input_run+0x73b6>
 10740bf:	xor    %eax,%eax
 10740c1:	jmp    10741b6 <check_input_run+0x74a6>
 10740c6:	shr    $0x3,%edx
 10740c9:	xor    %eax,%eax
 10740cb:	xor    %esi,%esi
 10740cd:	shl    $0x5,%rdx
 10740d1:	lea    (%rdx,%rdx,2),%rdx
 10740d5:	jmp    10740f8 <check_input_run+0x73e8>
 10740d7:	nopw   0x0(%rax,%rax,1)
 10740e0:	add    $0x8,%rax
 10740e4:	add    $0x60,%rsi
 10740e8:	mov    %edi,0x670(%rsp)
 10740ef:	cmp    %rsi,%rdx
 10740f2:	je     10741b1 <check_input_run+0x74a1>
 10740f8:	mov    (%r11),%r8
 10740fb:	mov    (%r8,%rsi,1),%r8d
 10740ff:	cmp    %edi,%r8d
 1074102:	jb     1074107 <check_input_run+0x73f7>
 1074104:	mov    %edi,%r8d
 1074107:	mov    %r8d,0x670(%rsp)
 107410f:	mov    (%r11),%rdi
 1074112:	mov    0xc(%rdi,%rsi,1),%edi
 1074116:	cmp    %r8d,%edi
 1074119:	jb     107411e <check_input_run+0x740e>
 107411b:	mov    %r8d,%edi
 107411e:	mov    %edi,0x670(%rsp)
 1074125:	mov    (%r11),%r8
 1074128:	mov    0x18(%r8,%rsi,1),%r8d
 107412d:	cmp    %edi,%r8d
 1074130:	jb     1074135 <check_input_run+0x7425>
 1074132:	mov    %edi,%r8d
 1074135:	mov    %r8d,0x670(%rsp)
 107413d:	mov    (%r11),%rdi
 1074140:	mov    0x24(%rdi,%rsi,1),%edi
 1074144:	cmp    %r8d,%edi
 1074147:	jb     107414c <check_input_run+0x743c>
 1074149:	mov    %r8d,%edi
 107414c:	mov    %edi,0x670(%rsp)
 1074153:	mov    (%r11),%r8
 1074156:	mov    0x30(%r8,%rsi,1),%r8d
 107415b:	cmp    %edi,%r8d
 107415e:	jb     1074163 <check_input_run+0x7453>
 1074160:	mov    %edi,%r8d
 1074163:	mov    %r8d,0x670(%rsp)
 107416b:	mov    (%r11),%rdi
 107416e:	mov    0x3c(%rdi,%rsi,1),%edi
 1074172:	cmp    %r8d,%edi
 1074175:	jb     107417a <check_input_run+0x746a>
 1074177:	mov    %r8d,%edi
 107417a:	mov    %edi,0x670(%rsp)
 1074181:	mov    (%r11),%r8
 1074184:	mov    0x48(%r8,%rsi,1),%r8d
 1074189:	cmp    %edi,%r8d
 107418c:	jb     1074191 <check_input_run+0x7481>
 107418e:	mov    %edi,%r8d
 1074191:	mov    %r8d,0x670(%rsp)
 1074199:	mov    (%r11),%rdi
 107419c:	mov    0x54(%rdi,%rsi,1),%edi
 10741a0:	cmp    %r8d,%edi
 10741a3:	jb     10740e0 <check_input_run+0x73d0>
 10741a9:	mov    %r8d,%edi
 10741ac:	jmp    10740e0 <check_input_run+0x73d0>
 10741b1:	test   %rcx,%rcx
 10741b4:	je     10741db <check_input_run+0x74cb>
 10741b6:	shl    $0x2,%rax
 10741ba:	lea    (%rax,%rax,2),%rax
 10741be:	xchg   %ax,%ax
 10741c0:	mov    (%r11),%rdx
 10741c3:	mov    (%rdx,%rax,1),%edx
 10741c6:	cmp    %edi,%edx
 10741c8:	cmovb  %edx,%edi
 10741cb:	add    $0xc,%rax
 10741cf:	dec    %rcx
 10741d2:	mov    %edi,0x670(%rsp)
 10741d9:	jne    10741c0 <check_input_run+0x74b0>
 10741db:	mov    0xa8(%rsp),%rax
 10741e3:	mov    0xa0(%rax),%ebx
 10741e9:	test   %rbx,%rbx
 10741ec:	je     107420f <check_input_run+0x74ff>
 10741ee:	mov    0x10(%rsp),%rax
 10741f3:	mov    (%rax),%rcx
 10741f6:	mov    0x8(%rax),%rax
 10741fa:	lea    0x3(%rax,%rcx,1),%r15
 10741ff:	add    %rcx,%rax
 1074202:	and    $0xfffffffffffffffc,%r15
 1074206:	cmp    %rax,%r15
 1074209:	jae    10742a1 <check_input_run+0x7591>
 107420f:	mov    0x18(%rsp),%rcx
 1074214:	test   %ebx,%ebx
 1074216:	setne  %al
 1074219:	or     %al,0x3bd(%rcx)
 107421f:	mov    0x600(%rsp),%rsi
 1074227:	mov    0x10(%rsp),%rdx
 107422c:	test   %ebx,%ebx
 107422e:	setne  %al
 1074231:	test   %rsi,%rsi
 1074234:	setne  %cl
 1074237:	and    %al,%cl
 1074239:	cmp    $0x1,%cl
 107423c:	jne    1074266 <check_input_run+0x7556>
 107423e:	mov    (%rdx),%rcx
 1074241:	mov    0x8(%rdx),%rax
 1074245:	lea    0x3(%rax,%rcx,1),%r15
 107424a:	add    %rcx,%rax
 107424d:	and    $0xfffffffffffffffc,%r15
 1074251:	cmp    %rax,%r15
 1074254:	jae    1074328 <check_input_run+0x7618>
 107425a:	mov    0x18(%rsp),%rax
 107425f:	movb   $0x1,0x3bd(%rax)
 1074266:	cmpl   $0x0,0xf0(%rsp)
 107426e:	mov    0x18(%rsp),%rax
 1074273:	je     1074291 <check_input_run+0x7581>
 1074275:	mov    0x78(%rsp),%rdx
 107427a:	mov    0x40(%rsp),%r14
 107427f:	xor    %eax,%eax
 1074281:	cmp    $0x1,%edx
 1074284:	jne    1074314 <check_input_run+0x7604>
 107428a:	xor    %ecx,%ecx
 107428c:	jmp    10745c4 <check_input_run+0x78b4>
 1074291:	mov    0xdc(%rax),%edi
 1074297:	mov    0x40(%rsp),%r14
 107429c:	jmp    10745f7 <check_input_run+0x78e7>
 10742a1:	mov    %r15,%rax
 10742a4:	sub    %rcx,%rax
 10742a7:	mov    0x10(%rsp),%rcx
 10742ac:	mov    0x10(%rcx),%rcx
 10742b0:	sub    %rax,%rcx
 10742b3:	jb     107420f <check_input_run+0x74ff>
 10742b9:	lea    0x0(,%rbx,4),%rdx
 10742c1:	cmp    %rcx,%rdx
 10742c4:	ja     107420f <check_input_run+0x74ff>
 10742ca:	mov    0x10(%rsp),%rcx
 10742cf:	mov    0x18(%rsp),%rsi
 10742d4:	add    %rdx,%rax
 10742d7:	test   %r15,%r15
 10742da:	mov    %rax,0x8(%rcx)
 10742de:	sete   %al
 10742e1:	or     %al,0x3bd(%rsi)
 10742e7:	test   %r15,%r15
 10742ea:	je     107421f <check_input_run+0x750f>
 10742f0:	mov    0x5f0(%rsp),%rsi
 10742f8:	mov    %r15,%rdi
 10742fb:	vzeroupper
 10742fe:	call   788240 <memcpy@plt>
 1074303:	mov    0x18(%rsp),%rax
 1074308:	mov    %r15,0x68(%rax)
 107430c:	mov    %ebx,0x78(%rax)
 107430f:	jmp    107421f <check_input_run+0x750f>
 1074314:	and    $0xfffffffe,%edx
 1074317:	movabs $0xc0000a0000,%rsi
 1074321:	xor    %ecx,%ecx
 1074323:	jmp    10743c0 <check_input_run+0x76b0>
 1074328:	mov    %r15,%rax
 107432b:	sub    %rcx,%rax
 107432e:	mov    0x10(%rdx),%rcx
 1074332:	sub    %rax,%rcx
 1074335:	jb     107425a <check_input_run+0x754a>
 107433b:	shl    $0x2,%rbx
 107433f:	cmp    %rcx,%rbx
 1074342:	ja     107425a <check_input_run+0x754a>
 1074348:	mov    0x18(%rsp),%rcx
 107434d:	add    %rbx,%rax
 1074350:	test   %r15,%r15
 1074353:	mov    %rax,0x8(%rdx)
 1074357:	sete   %al
 107435a:	or     %al,0x3bd(%rcx)
 1074360:	test   %r15,%r15
 1074363:	je     1074266 <check_input_run+0x7556>
 1074369:	mov    %r15,%rdi
 107436c:	mov    %rbx,%rdx
 107436f:	vzeroupper
 1074372:	call   788240 <memcpy@plt>
 1074377:	mov    0x10(%rsp),%rdx
 107437c:	mov    0x18(%rsp),%rax
 1074381:	mov    %r15,0x70(%rax)
 1074385:	jmp    1074266 <check_input_run+0x7556>
 107438a:	cmp    $0x1ce,%r8d
 1074391:	jne    1074541 <check_input_run+0x7831>
 1074397:	mov    $0x1,%edi
 107439c:	nopl   0x0(%rax)
 10743a0:	mov    0x18(%rsp),%r8
 10743a5:	add    $0x2,%rcx
 10743a9:	add    0xdc(%r8),%edi
 10743b0:	mov    %edi,0xdc(%r8)
 10743b7:	cmp    %rcx,%rdx
 10743ba:	je     10745b8 <check_input_run+0x78a8>
 10743c0:	mov    0x4a8(%rsp),%rdi
 10743c8:	mov    $0x0,%r8d
 10743ce:	movzwl (%rdi,%rcx,2),%edi
 10743d2:	lea    -0x120(%rdi),%r9d
 10743d9:	cmp    $0x5,%r9d
 10743dd:	jae    10744a0 <check_input_run+0x7790>
 10743e3:	mov    0x18(%rsp),%rdi
 10743e8:	add    %r8d,0xdc(%rdi)
 10743ef:	mov    0x4a8(%rsp),%rdi
 10743f7:	movzwl 0x2(%rdi,%rcx,2),%r8d
 10743fd:	xor    %edi,%edi
 10743ff:	lea    -0x120(%r8),%r9d
 1074406:	cmp    $0x5,%r9d
 107440a:	jb     10743a0 <check_input_run+0x7690>
 107440c:	cmp    $0x317,%r8d
 1074413:	je     10743a0 <check_input_run+0x7690>
 1074415:	lea    -0x160(%r8),%r9d
 107441c:	mov    %r8d,%r10d
 107441f:	cmp    $0x6,%r9w
 1074424:	setb   %r9b
 1074428:	and    $0xfffffffc,%r10d
 107442c:	cmp    $0x1f0,%r10w
 1074432:	sete   %r10b
 1074436:	or     %r9b,%r10b
 1074439:	jne    10743a0 <check_input_run+0x7690>
 107443f:	lea    -0x140(%r8),%r9d
 1074446:	lea    -0x200(%r8),%r10d
 107444d:	cmp    $0x13,%r9w
 1074452:	setb   %r9b
 1074456:	cmp    $0xe,%r10w
 107445b:	setb   %r10b
 107445f:	or     %r9b,%r10b
 1074462:	jne    1074397 <check_input_run+0x7687>
 1074468:	cmp    $0x16f,%r8d
 107446f:	jle    1074527 <check_input_run+0x7817>
 1074475:	lea    -0x170(%r8),%r9d
 107447c:	cmp    $0x27,%r9d
 1074480:	ja     107438a <check_input_run+0x767a>
 1074486:	bt     %r9,%rsi
 107448a:	jb     1074397 <check_input_run+0x7687>
 1074490:	test   %r9,%r9
 1074493:	je     10743a0 <check_input_run+0x7690>
 1074499:	jmp    107438a <check_input_run+0x767a>
 107449e:	xchg   %ax,%ax
 10744a0:	cmp    $0x317,%edi
 10744a6:	je     10743e3 <check_input_run+0x76d3>
 10744ac:	lea    -0x160(%rdi),%r8d
 10744b3:	mov    %edi,%r9d
 10744b6:	cmp    $0x6,%r8w
 10744bb:	setb   %r8b
 10744bf:	and    $0xfffffffc,%r9d
 10744c3:	cmp    $0x1f0,%r9w
 10744c9:	sete   %r9b
 10744cd:	or     %r8b,%r9b
 10744d0:	mov    $0x0,%r8d
 10744d6:	jne    10743e3 <check_input_run+0x76d3>
 10744dc:	lea    -0x140(%rdi),%r8d
 10744e3:	lea    -0x200(%rdi),%r9d
 10744ea:	cmp    $0x13,%r8w
 10744ef:	setb   %r8b
 10744f3:	cmp    $0xe,%r9w
 10744f8:	setb   %r9b
 10744fc:	or     %r8b,%r9b
 10744ff:	jne    107451c <check_input_run+0x780c>
 1074501:	cmp    $0x16f,%edi
 1074507:	jle    1074565 <check_input_run+0x7855>
 1074509:	lea    -0x170(%rdi),%r9d
 1074510:	cmp    $0x27,%r9d
 1074514:	ja     1074586 <check_input_run+0x7876>
 1074516:	bt     %r9,%rsi
 107451a:	jae    1074577 <check_input_run+0x7867>
 107451c:	mov    $0x1,%r8d
 1074522:	jmp    10743e3 <check_input_run+0x76d3>
 1074527:	cmp    $0x130,%r8d
 107452e:	je     1074397 <check_input_run+0x7687>
 1074534:	cmp    $0x133,%r8d
 107453b:	je     1074397 <check_input_run+0x7687>
 1074541:	lea    -0x300(%r8),%r9d
 1074548:	cmp    $0x16,%r9w
 107454d:	ja     10743a0 <check_input_run+0x7690>
 1074553:	xor    %edi,%edi
 1074555:	cmp    $0x312,%r8d
 107455c:	sete   %dil
 1074560:	jmp    10743a0 <check_input_run+0x7690>
 1074565:	cmp    $0x130,%edi
 107456b:	je     107451c <check_input_run+0x780c>
 107456d:	cmp    $0x133,%edi
 1074573:	je     107451c <check_input_run+0x780c>
 1074575:	jmp    107458e <check_input_run+0x787e>
 1074577:	mov    $0x0,%r8d
 107457d:	test   %r9,%r9
 1074580:	je     10743e3 <check_input_run+0x76d3>
 1074586:	cmp    $0x1ce,%edi
 107458c:	je     107451c <check_input_run+0x780c>
 107458e:	lea    -0x300(%rdi),%r9d
 1074595:	mov    $0x0,%r8d
 107459b:	cmp    $0x16,%r9w
 10745a0:	ja     10743e3 <check_input_run+0x76d3>
 10745a6:	xor    %r8d,%r8d
 10745a9:	cmp    $0x312,%edi
 10745af:	sete   %r8b
 10745b3:	jmp    10743e3 <check_input_run+0x76d3>
 10745b8:	testb  $0x1,0x78(%rsp)
 10745bd:	mov    0x10(%rsp),%rdx
 10745c2:	je     10745f7 <check_input_run+0x78e7>
 10745c4:	mov    0x4a8(%rsp),%rdx
 10745cc:	movzwl (%rdx,%rcx,2),%ecx
 10745d0:	lea    -0x120(%rcx),%edx
 10745d6:	cmp    $0x5,%edx
 10745d9:	jae    1074931 <check_input_run+0x7c21>
 10745df:	mov    0x10(%rsp),%rdx
 10745e4:	mov    0x18(%rsp),%rcx
 10745e9:	add    0xdc(%rcx),%eax
 10745ef:	mov    %eax,%edi
 10745f1:	mov    %eax,0xdc(%rcx)
 10745f7:	test   %edi,%edi
 10745f9:	je     1074662 <check_input_run+0x7952>
 10745fb:	mov    (%rdx),%rcx
 10745fe:	mov    %rdx,%rsi
 1074601:	mov    0x8(%rdx),%rdx
 1074605:	lea    0x7(%rdx,%rcx,1),%rax
 107460a:	add    %rcx,%rdx
 107460d:	and    $0xfffffffffffffff8,%rax
 1074611:	cmp    %rdx,%rax
 1074614:	jae    107461a <check_input_run+0x790a>
 1074616:	xor    %ecx,%ecx
 1074618:	jmp    1074645 <check_input_run+0x7935>
 107461a:	mov    0x10(%rsi),%rsi
 107461e:	mov    %rax,%rdx
 1074621:	sub    %rcx,%rdx
 1074624:	xor    %ecx,%ecx
 1074626:	sub    %rdx,%rsi
 1074629:	jb     1074645 <check_input_run+0x7935>
 107462b:	mov    %edi,%edi
 107462d:	imul   $0x78,%rdi,%rdi
 1074631:	cmp    %rsi,%rdi
 1074634:	ja     1074645 <check_input_run+0x7935>
 1074636:	mov    0x10(%rsp),%rcx
 107463b:	add    %rdi,%rdx
 107463e:	mov    %rdx,0x8(%rcx)
 1074642:	mov    %rax,%rcx
 1074645:	mov    0x18(%rsp),%rdx
 107464a:	test   %rcx,%rcx
 107464d:	sete   %al
 1074650:	mov    %rcx,0xd0(%rdx)
 1074657:	or     %al,0x3bd(%rdx)
 107465d:	mov    0x10(%rsp),%rdx
 1074662:	mov    0x18(%rsp),%rax
 1074667:	mov    0x210(%rax),%ecx
 107466d:	test   %rcx,%rcx
 1074670:	je     10746db <check_input_run+0x79cb>
 1074672:	mov    %ecx,0xfc(%rax)
 1074678:	mov    %rdx,%r8
 107467b:	mov    (%rdx),%rsi
 107467e:	mov    0x8(%rdx),%rdx
 1074682:	lea    0x7(%rdx,%rsi,1),%rax
 1074687:	add    %rsi,%rdx
 107468a:	and    $0xfffffffffffffff8,%rax
 107468e:	cmp    %rdx,%rax
 1074691:	jb     10746b8 <check_input_run+0x79a8>
 1074693:	mov    %rax,%rdx
 1074696:	sub    %rsi,%rdx
 1074699:	mov    0x10(%r8),%rsi
 107469d:	shl    $0x3,%rcx
 10746a1:	lea    (%rcx,%rcx,4),%rcx
 10746a5:	sub    %rdx,%rsi
 10746a8:	setb   %dil
 10746ac:	cmp    %rsi,%rcx
 10746af:	seta   %sil
 10746b3:	or     %dil,%sil
 10746b6:	je     10746bc <check_input_run+0x79ac>
 10746b8:	xor    %eax,%eax
 10746ba:	jmp    10746c3 <check_input_run+0x79b3>
 10746bc:	add    %rcx,%rdx
 10746bf:	mov    %rdx,0x8(%r8)
 10746c3:	mov    0x18(%rsp),%rcx
 10746c8:	test   %rax,%rax
 10746cb:	sete   %dl
 10746ce:	mov    %rax,0xf0(%rcx)
 10746d5:	or     %dl,0x3bd(%rcx)
 10746db:	mov    0xf0(%rsp),%rcx
 10746e3:	test   %ecx,%ecx
 10746e5:	je     1074888 <check_input_run+0x7b78>
 10746eb:	xor    %ebx,%ebx
 10746ed:	jmp    1074706 <check_input_run+0x79f6>
 10746ef:	nop
 10746f0:	mov    0xf0(%rsp),%rcx
 10746f8:	inc    %rbx
 10746fb:	cmp    0x78(%rsp),%rbx
 1074700:	je     1074888 <check_input_run+0x7b78>
 1074706:	mov    (%r14),%rax
 1074709:	cmpb   $0x0,(%rax,%rbx,1)
 107470d:	je     107474c <check_input_run+0x7a3c>
 107470f:	mov    0x260(%rsp),%rax
 1074717:	mov    0x258(%rsp),%rdx
 107471f:	mov    (%rax),%rax
 1074722:	mov    (%rax,%rbx,4),%edi
 1074725:	mov    (%rdx),%rax
 1074728:	mov    (%rax,%rbx,4),%edx
 107472b:	cmp    %edi,%edx
 107472d:	jbe    107474c <check_input_run+0x7a3c>
 107472f:	cmp    %ecx,%edx
 1074731:	ja     107474c <check_input_run+0x7a3c>
 1074733:	mov    %edi,%eax
 1074735:	add    0x520(%rsp),%rdi
 107473d:	sub    %eax,%edx
 107473f:	mov    $0x1,%esi
 1074744:	vzeroupper
 1074747:	call   788120 <memset@plt>
 107474c:	mov    0x10(%r12),%rax
 1074751:	movzbl (%rax,%rbx,1),%ecx
 1074755:	cmp    $0x43,%cl
 1074758:	jne    10747d0 <check_input_run+0x7ac0>
 107475a:	lea    0x1(%rbx),%rdx
 107475e:	cmp    0x78(%rsp),%rdx
 1074763:	jae    10746f0 <check_input_run+0x79e0>
 1074765:	mov    0x60(%r12),%rcx
 107476a:	mov    0x4(%rcx,%rbx,4),%esi
 107476e:	cmp    %rsi,%rdx
 1074771:	setb   %dl
 1074774:	cmp    0xf0(%rsp),%esi
 107477b:	setb   %dil
 107477f:	and    %dl,%dil
 1074782:	cmp    $0x1,%dil
 1074786:	jne    10746f0 <check_input_run+0x79e0>
 107478c:	lea    0x2(%rbx),%rdi
 1074790:	cmp    %rsi,%rdi
 1074793:	jb     1074854 <check_input_run+0x7b44>
 1074799:	mov    %edi,%edx
 107479b:	mov    0x520(%rsp),%rax
 10747a3:	sub    %ebx,%edx
 10747a5:	mov    $0x1,%esi
 10747aa:	add    $0xfffffffe,%edx
 10747ad:	lea    0x2(%rax,%rbx,1),%rdi
 10747b2:	vzeroupper
 10747b5:	call   788120 <memset@plt>
 10747ba:	mov    0x10(%r12),%rax
 10747bf:	movzbl (%rax,%rbx,1),%ecx
 10747c3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10747d0:	cmp    $0x4a,%cl
 10747d3:	jne    10746f0 <check_input_run+0x79e0>
 10747d9:	mov    0x60(%r12),%rax
 10747de:	mov    (%rax,%rbx,4),%eax
 10747e1:	cmp    %rax,%rbx
 10747e4:	setb   %cl
 10747e7:	cmp    0xf0(%rsp),%eax
 10747ee:	setb   %dl
 10747f1:	and    %cl,%dl
 10747f3:	cmp    $0x1,%dl
 10747f6:	jne    10746f0 <check_input_run+0x79e0>
 10747fc:	mov    0x520(%rsp),%rcx
 1074804:	mov    %ebx,%edx
 1074806:	not    %edx
 1074808:	mov    $0x1,%esi
 107480d:	add    %eax,%edx
 107480f:	lea    0x1(%rcx,%rbx,1),%rdi
 1074814:	vzeroupper
 1074817:	call   788120 <memset@plt>
 107481c:	jmp    10746f0 <check_input_run+0x79e0>
 1074821:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1074830:	cmp    $0xa,%r8d
 1074834:	jne    107486f <check_input_run+0x7b5f>
 1074836:	mov    (%rcx,%rdx,4),%r8d
 107483a:	lea    0x1(%r8),%edx
 107483e:	cmp    %esi,%r8d
 1074841:	cmovae %esi,%edx
 1074844:	cmp    %edi,%r8d
 1074847:	cmovbe %esi,%edx
 107484a:	mov    %edx,%edi
 107484c:	cmp    %esi,%edx
 107484e:	jae    107479b <check_input_run+0x7a8b>
 1074854:	mov    %edi,%edx
 1074856:	movzbl (%rax,%rdx,1),%r8d
 107485b:	cmp    $0x9,%r8d
 107485f:	jg     1074830 <check_input_run+0x7b20>
 1074861:	cmp    $0x6,%r8d
 1074865:	je     1074836 <check_input_run+0x7b26>
 1074867:	cmp    $0x8,%r8d
 107486b:	je     1074836 <check_input_run+0x7b26>
 107486d:	jmp    1074879 <check_input_run+0x7b69>
 107486f:	cmp    $0x33,%r8d
 1074873:	je     1074799 <check_input_run+0x7a89>
 1074879:	inc    %edi
 107487b:	mov    %edi,%edx
 107487d:	mov    %edx,%edi
 107487f:	cmp    %esi,%edx
 1074881:	jb     1074854 <check_input_run+0x7b44>
 1074883:	jmp    107479b <check_input_run+0x7a8b>
 1074888:	mov    0x2a0(%rsp),%rax
 1074890:	mov    0x320(%rax),%ecx
 1074896:	test   %rcx,%rcx
 1074899:	je     1074fee <check_input_run+0x82de>
 107489f:	mov    0x310(%rax),%rsi
 10748a6:	mov    (%rsi),%edi
 10748a8:	mov    0x4(%rsi),%r8d
 10748ac:	cmp    %r8d,%edi
 10748af:	jae    1075011 <check_input_run+0x8301>
 10748b5:	mov    0x35c(%rax),%r9d
 10748bc:	cmp    %r9d,%r8d
 10748bf:	jae    1075011 <check_input_run+0x8301>
 10748c5:	inc    %r8
 10748c8:	mov    %r8,%rdx
 10748cb:	sub    %rdi,%rdx
 10748ce:	mov    $0x1,%edi
 10748d3:	cmp    $0x1,%ecx
 10748d6:	je     1074e93 <check_input_run+0x8183>
 10748dc:	add    $0x1c,%rsi
 10748e0:	jmp    10748f2 <check_input_run+0x7be2>
 10748e2:	inc    %rdi
 10748e5:	add    $0x18,%rsi
 10748e9:	cmp    %rdi,%rcx
 10748ec:	je     1074e90 <check_input_run+0x8180>
 10748f2:	mov    -0x4(%rsi),%r11d
 10748f6:	mov    (%rsi),%r10d
 10748f9:	cmp    %r10d,%r11d
 10748fc:	jae    1074e93 <check_input_run+0x8183>
 1074902:	cmp    %r9d,%r10d
 1074905:	jae    1074e93 <check_input_run+0x8183>
 107490b:	cmp    %r11d,-0x1c(%rsi)
 107490f:	jae    1074e93 <check_input_run+0x8183>
 1074915:	cmp    %r10,%r8
 1074918:	ja     10748e2 <check_input_run+0x7bd2>
 107491a:	cmp    %r11,%r8
 107491d:	cmova  %r8,%r11
 1074921:	sub    %r11,%rdx
 1074924:	lea    0x1(%rdx,%r10,1),%rdx
 1074929:	inc    %r10
 107492c:	mov    %r10,%r8
 107492f:	jmp    10748e2 <check_input_run+0x7bd2>
 1074931:	cmp    $0x317,%ecx
 1074937:	je     10745df <check_input_run+0x78cf>
 107493d:	lea    -0x160(%rcx),%edx
 1074943:	mov    %ecx,%esi
 1074945:	cmp    $0x6,%dx
 1074949:	setb   %dl
 107494c:	and    $0xfffffffc,%esi
 107494f:	cmp    $0x1f0,%si
 1074954:	sete   %sil
 1074958:	or     %dl,%sil
 107495b:	jne    10745df <check_input_run+0x78cf>
 1074961:	lea    -0x140(%rcx),%edx
 1074967:	lea    -0x200(%rcx),%esi
 107496d:	cmp    $0x13,%dx
 1074971:	setb   %dl
 1074974:	cmp    $0xe,%si
 1074978:	setb   %sil
 107497c:	or     %dl,%sil
 107497f:	jne    1077509 <check_input_run+0xa7f9>
 1074985:	cmp    $0x16f,%ecx
 107498b:	jle    10774f5 <check_input_run+0xa7e5>
 1074991:	lea    -0x170(%rcx),%edx
 1074997:	cmp    $0x27,%edx
 107499a:	ja     10749b9 <check_input_run+0x7ca9>
 107499c:	movabs $0xc0000a0000,%rsi
 10749a6:	bt     %rdx,%rsi
 10749aa:	jb     1077509 <check_input_run+0xa7f9>
 10749b0:	test   %rdx,%rdx
 10749b3:	je     10745df <check_input_run+0x78cf>
 10749b9:	cmp    $0x1ce,%ecx
 10749bf:	je     1077509 <check_input_run+0xa7f9>
 10749c5:	jmp    1077942 <check_input_run+0xac32>
 10749ca:	cmp    %rax,%rdx
 10749cd:	jae    1074e45 <check_input_run+0x8135>
 10749d3:	mov    0x2c8(%rsp),%rcx
 10749db:	mov    0x58(%rsp),%rax
 10749e0:	mov    0x8(%rcx),%r8
 10749e4:	cmpq   $0x0,0x828(%rax)
 10749ec:	je     1074a0f <check_input_run+0x7cff>
 10749ee:	mov    0x10(%rsp),%rdi
 10749f3:	mov    (%rdi),%rsi
 10749f6:	mov    0x8(%rdi),%rdx
 10749fa:	lea    0x3f(%rdx,%rsi,1),%rax
 10749ff:	add    %rsi,%rdx
 1074a02:	and    $0xffffffffffffffc0,%rax
 1074a06:	cmp    %rdx,%rax
 1074a09:	jae    1075d5b <check_input_run+0x904b>
 1074a0f:	xor    %ebp,%ebp
 1074a11:	movq   $0x0,0x210(%rsp)
 1074a1d:	mov    0x58(%rsp),%rax
 1074a22:	cmpq   $0x0,0x828(%rax)
 1074a2a:	setne  %al
 1074a2d:	test   %rbp,%rbp
 1074a30:	sete   %cl
 1074a33:	and    %al,%cl
 1074a35:	or     %cl,0x3bd(%r14)
 1074a3c:	test   %rbp,%rbp
 1074a3f:	je     10763ae <check_input_run+0x969e>
 1074a45:	cmpb   $0x0,(%r10)
 1074a49:	mov    %r8,0x130(%rsp)
 1074a51:	mov    %r9,0x1b0(%rsp)
 1074a59:	mov    %r10,0xd0(%rsp)
 1074a61:	jne    1074a75 <check_input_run+0x7d65>
 1074a63:	mov    0x58(%rsp),%rax
 1074a68:	cmpb   $0x1,0xc40(%rax)
 1074a6f:	jne    1075e17 <check_input_run+0x9107>
 1074a75:	mov    0x58(%rsp),%rbx
 1074a7a:	mov    %rbx,%rdi
 1074a7d:	vzeroupper
 1074a80:	call   101c310 <pp_history_ensure>
 1074a85:	cmpl   $0x0,0x830(%rbx)
 1074a8c:	je     1076174 <check_input_run+0x9464>
 1074a92:	mov    $0xffffffff,%r8d
 1074a98:	mov    $0xffffffff,%esi
 1074a9d:	xor    %r10d,%r10d
 1074aa0:	movl   $0x0,0x50(%rsp)
 1074aa8:	xor    %ecx,%ecx
 1074aaa:	xor    %edx,%edx
 1074aac:	xor    %r13d,%r13d
 1074aaf:	xor    %eax,%eax
 1074ab1:	jmp    1074aef <check_input_run+0x7ddf>
 1074ab3:	movl   $0x0,0x50(%rsp)
 1074abb:	xor    %r10d,%r10d
 1074abe:	mov    $0xffffffff,%r9d
 1074ac4:	xor    %r11d,%r11d
 1074ac7:	mov    0x58(%rsp),%rax
 1074acc:	mov    %r11b,0x0(%rbp,%rcx,1)
 1074ad1:	inc    %rcx
 1074ad4:	mov    %r9d,%r8d
 1074ad7:	mov    0x20(%rsp),%r12
 1074adc:	mov    0x830(%rax),%eax
 1074ae2:	cmp    %rax,%rcx
 1074ae5:	mov    0x28(%rsp),%eax
 1074ae9:	jae    1076174 <check_input_run+0x9464>
 1074aef:	mov    %r10d,0x98(%rsp)
 1074af7:	mov    0x58(%rsp),%r10
 1074afc:	mov    0xce0(%r10),%edi
 1074b03:	cmp    %edi,%edx
 1074b05:	jae    1074b20 <check_input_run+0x7e10>
 1074b07:	mov    0xcd8(%r10),%r9
 1074b0e:	mov    %edx,%edx
 1074b10:	cmp    %ecx,(%r9,%rdx,8)
 1074b14:	ja     1074b20 <check_input_run+0x7e10>
 1074b16:	inc    %rdx
 1074b19:	cmp    %rdx,%rdi
 1074b1c:	jne    1074b10 <check_input_run+0x7e00>
 1074b1e:	mov    %edi,%edx
 1074b20:	test   %edx,%edx
 1074b22:	je     1074c64 <check_input_run+0x7f54>
 1074b28:	mov    0xcd8(%r10),%rdi
 1074b2f:	lea    -0x1(%rdx),%r9d
 1074b33:	mov    0x4(%rdi,%r9,8),%r9d
 1074b38:	test   %r9d,%r9d
 1074b3b:	je     1074c55 <check_input_run+0x7f45>
 1074b41:	cmp    %eax,%r9d
 1074b44:	je     1074c55 <check_input_run+0x7f45>
 1074b4a:	mov    0x828(%r10),%rax
 1074b51:	mov    %r9d,0x28(%rsp)
 1074b56:	test   %rax,%rax
 1074b59:	je     1074c78 <check_input_run+0x7f68>
 1074b5f:	mov    0xca0(%r10),%r11d
 1074b66:	mov    0xcb0(%r10),%r12d
 1074b6d:	mov    (%rax,%rcx,4),%edi
 1074b70:	xor    %r15d,%r15d
 1074b73:	mov    %r12d,%eax
 1074b76:	mov    %r11,0x90(%rsp)
 1074b7e:	add    %r11,%r12
 1074b81:	mov    0xcc0(%r10),%r11d
 1074b88:	mov    %r9d,%r10d
 1074b8b:	add    %r11,%r12
 1074b8e:	mov    %r10d,%r9d
 1074b91:	and    $0x3fffffff,%r9d
 1074b98:	mov    %r10d,%r13d
 1074b9b:	and    $0xc0000000,%r13d
 1074ba2:	dec    %r9d
 1074ba5:	cmp    $0x40000000,%r13d
 1074bac:	jne    1074bd1 <check_input_run+0x7ec1>
 1074bae:	cmp    %eax,%r9d
 1074bb1:	jae    1074c7f <check_input_run+0x7f6f>
 1074bb7:	mov    0x58(%rsp),%r10
 1074bbc:	mov    %r9d,%r9d
 1074bbf:	lea    (%r9,%r9,2),%r9
 1074bc3:	mov    0xca8(%r10),%r10
 1074bca:	lea    0x4(%r10,%r9,4),%r9
 1074bcf:	jmp    1074c3c <check_input_run+0x7f2c>
 1074bd1:	cmp    $0xbfffffff,%r10d
 1074bd8:	jg     1074c01 <check_input_run+0x7ef1>
 1074bda:	cmp    %r11d,%r9d
 1074bdd:	jae    1074c7f <check_input_run+0x7f6f>
 1074be3:	mov    0x58(%rsp),%r10
 1074be8:	mov    %r9d,%r9d
 1074beb:	lea    (%r9,%r9,2),%rbx
 1074bef:	mov    0xcb8(%r10),%r10
 1074bf6:	mov    0x8(%r10,%rbx,8),%edi
 1074bfb:	lea    (%r10,%rbx,8),%r9
 1074bff:	jmp    1074c3c <check_input_run+0x7f2c>
 1074c01:	xor    %ebx,%ebx
 1074c03:	test   %r13d,%r13d
 1074c06:	jne    1074c81 <check_input_run+0x7f71>
 1074c08:	mov    $0x0,%r10d
 1074c0e:	cmp    0x90(%rsp),%r9d
 1074c16:	jae    1074c84 <check_input_run+0x7f74>
 1074c18:	mov    0x58(%rsp),%r10
 1074c1d:	mov    %r9d,%r9d
 1074c20:	lea    (%r9,%r9,8),%rbx
 1074c24:	lea    (%rbx,%rbx,2),%rbx
 1074c28:	add    %r9,%rbx
 1074c2b:	mov    0xc98(%r10),%r10
 1074c32:	mov    0x8(%r10,%rbx,1),%edi
 1074c37:	lea    0x10(%r10,%rbx,1),%r9
 1074c3c:	mov    (%r9),%r10d
 1074c3f:	mov    $0x1,%bl
 1074c41:	test   %r10d,%r10d
 1074c44:	je     1074c84 <check_input_run+0x7f74>
 1074c46:	cmp    %r12,%r15
 1074c49:	lea    0x1(%r15),%r15
 1074c4d:	jb     1074b8e <check_input_run+0x7e7e>
 1074c53:	jmp    1074c84 <check_input_run+0x7f74>
 1074c55:	test   %r9d,%r9d
 1074c58:	je     1074c64 <check_input_run+0x7f54>
 1074c5a:	mov    %r9d,0x28(%rsp)
 1074c5f:	mov    %r13d,%edi
 1074c62:	jmp    1074c9c <check_input_run+0x7f8c>
 1074c64:	mov    0x828(%r10),%rax
 1074c6b:	movl   $0x0,0x28(%rsp)
 1074c73:	mov    (%rax,%rcx,4),%edi
 1074c76:	jmp    1074c9c <check_input_run+0x7f8c>
 1074c78:	xor    %r13d,%r13d
 1074c7b:	xor    %edi,%edi
 1074c7d:	jmp    1074c9c <check_input_run+0x7f8c>
 1074c7f:	xor    %ebx,%ebx
 1074c81:	xor    %r10d,%r10d
 1074c84:	test   %r10d,%r10d
 1074c87:	mov    0x58(%rsp),%r10
 1074c8c:	mov    $0x0,%eax
 1074c91:	cmovne %eax,%edi
 1074c94:	test   %bl,%bl
 1074c96:	cmove  %eax,%edi
 1074c99:	mov    %edi,%r13d
 1074c9c:	mov    0xc18(%r10),%r12d
 1074ca3:	cmp    %r12d,%r8d
 1074ca6:	jae    1074ccf <check_input_run+0x7fbf>
 1074ca8:	mov    0x58(%rsp),%rax
 1074cad:	mov    0xc10(%rax),%rax
 1074cb4:	test   %rax,%rax
 1074cb7:	je     1074ccf <check_input_run+0x7fbf>
 1074cb9:	mov    %r8d,%r9d
 1074cbc:	imul   $0x38,%r9,%r9
 1074cc0:	add    %r9,%rax
 1074cc3:	mov    %edi,%r9d
 1074cc6:	sub    (%rax),%r9d
 1074cc9:	jae    1074db2 <check_input_run+0x80a2>
 1074ccf:	mov    $0xffffffff,%esi
 1074cd4:	test   %edi,%edi
 1074cd6:	je     1074ab3 <check_input_run+0x7da3>
 1074cdc:	cmp    $0x2,%r12d
 1074ce0:	jb     1074d30 <check_input_run+0x8020>
 1074ce2:	mov    0x58(%rsp),%rax
 1074ce7:	xor    %r8d,%r8d
 1074cea:	mov    %r12d,%r10d
 1074ced:	mov    %r12d,%r9d
 1074cf0:	mov    0xc10(%rax),%rax
 1074cf7:	jmp    1074d0f <check_input_run+0x7fff>
 1074cf9:	nopl   0x0(%rax)
 1074d00:	mov    %r10d,%r8d
 1074d03:	mov    %r9d,%r10d
 1074d06:	sub    %r8d,%r10d
 1074d09:	cmp    $0x1,%r10d
 1074d0d:	jbe    1074d48 <check_input_run+0x8038>
 1074d0f:	shr    $1,%r10d
 1074d12:	add    %r8d,%r10d
 1074d15:	imul   $0x38,%r10,%r11
 1074d19:	cmp    %edi,(%rax,%r11,1)
 1074d1d:	jbe    1074d00 <check_input_run+0x7ff0>
 1074d1f:	mov    %r10d,%r9d
 1074d22:	mov    %r9d,%r10d
 1074d25:	sub    %r8d,%r10d
 1074d28:	cmp    $0x1,%r10d
 1074d2c:	ja     1074d0f <check_input_run+0x7fff>
 1074d2e:	jmp    1074d48 <check_input_run+0x8038>
 1074d30:	test   %r12d,%r12d
 1074d33:	je     1074ab3 <check_input_run+0x7da3>
 1074d39:	mov    0x58(%rsp),%rax
 1074d3e:	xor    %r8d,%r8d
 1074d41:	mov    0xc10(%rax),%rax
 1074d48:	mov    %r8d,%r9d
 1074d4b:	imul   $0x38,%r9,%rbx
 1074d4f:	mov    %edi,%r15d
 1074d52:	mov    $0x0,%r10d
 1074d58:	mov    $0xffffffff,%r9d
 1074d5e:	mov    $0x0,%r11d
 1074d64:	movl   $0x0,0x50(%rsp)
 1074d6c:	sub    (%rax,%rbx,1),%r15d
 1074d70:	jb     1074ac7 <check_input_run+0x7db7>
 1074d76:	add    %rax,%rbx
 1074d79:	mov    $0xffffffff,%esi
 1074d7e:	cmp    0x4(%rbx),%r15d
 1074d82:	cmovb  %r8d,%r9d
 1074d86:	xor    %r10d,%r10d
 1074d89:	cmp    %r12d,%r9d
 1074d8c:	jae    1074df7 <check_input_run+0x80e7>
 1074d8e:	mov    %r9d,%esi
 1074d91:	imul   $0x38,%rsi,%rsi
 1074d95:	movzbl 0x28(%rax,%rsi,1),%r9d
 1074d9b:	mov    (%rax,%rsi,1),%r10d
 1074d9f:	mov    0x20(%rax,%rsi,1),%esi
 1074da3:	mov    %r9d,0x98(%rsp)
 1074dab:	mov    %r10d,0x50(%rsp)
 1074db0:	jmp    1074dc6 <check_input_run+0x80b6>
 1074db2:	cmp    0x4(%rax),%r9d
 1074db6:	jae    1074ccf <check_input_run+0x7fbf>
 1074dbc:	cmp    0x50(%rsp),%edi
 1074dc0:	jb     1074ccf <check_input_run+0x7fbf>
 1074dc6:	mov    0x58(%rsp),%r9
 1074dcb:	mov    0xc28(%r9),%eax
 1074dd2:	cmp    %eax,%esi
 1074dd4:	jae    1074ded <check_input_run+0x80dd>
 1074dd6:	mov    0xc20(%r9),%r9
 1074ddd:	mov    %esi,%r10d
 1074de0:	lea    (%r10,%r10,4),%r10
 1074de4:	mov    0x4(%r9,%r10,8),%ebx
 1074de9:	cmp    %edi,%ebx
 1074deb:	jbe    1074e04 <check_input_run+0x80f4>
 1074ded:	mov    0x98(%rsp),%r10d
 1074df5:	jmp    1074e2d <check_input_run+0x811d>
 1074df7:	mov    %r9d,%r8d
 1074dfa:	movl   $0x0,0x50(%rsp)
 1074e02:	jmp    1074e2d <check_input_run+0x811d>
 1074e04:	lea    (%r9,%r10,8),%r15
 1074e08:	mov    0x1c(%r15),%esi
 1074e0c:	mov    %r15,%r11
 1074e0f:	mov    %ebx,0x50(%rsp)
 1074e13:	cmp    %eax,%esi
 1074e15:	jae    1074e28 <check_input_run+0x8118>
 1074e17:	lea    (%rsi,%rsi,4),%r10
 1074e1b:	mov    0x4(%r9,%r10,8),%ebx
 1074e20:	lea    (%r9,%r10,8),%r15
 1074e24:	cmp    %edi,%ebx
 1074e26:	jbe    1074e08 <check_input_run+0x80f8>
 1074e28:	movzbl 0x20(%r11),%r10d
 1074e2d:	cmp    %r12d,%r8d
 1074e30:	movzbl %r10b,%r11d
 1074e34:	mov    $0x0,%eax
 1074e39:	mov    %r8d,%r9d
 1074e3c:	cmovae %eax,%r11d
 1074e40:	jmp    1074ac7 <check_input_run+0x7db7>
 1074e45:	mov    0x58(%rsp),%rax
 1074e4a:	mov    0xc28(%rax),%ecx
 1074e50:	test   %rcx,%rcx
 1074e53:	je     1074e7f <check_input_run+0x816f>
 1074e55:	mov    0x58(%rsp),%rax
 1074e5a:	shl    $0x3,%rcx
 1074e5e:	xor    %edx,%edx
 1074e60:	lea    (%rcx,%rcx,4),%rcx
 1074e64:	mov    0xc20(%rax),%rax
 1074e6b:	cmpb   $0x0,0x20(%rax,%rdx,1)
 1074e70:	jne    10749d3 <check_input_run+0x7cc3>
 1074e76:	add    $0x28,%rdx
 1074e7a:	cmp    %rdx,%rcx
 1074e7d:	jne    1074e6b <check_input_run+0x815b>
 1074e7f:	mov    0x2c8(%rsp),%rax
 1074e87:	mov    0x8(%rax),%r8
 1074e8b:	jmp    10763ae <check_input_run+0x969e>
 1074e90:	mov    %rcx,%rdi
 1074e93:	cmp    %rcx,%rdi
 1074e96:	jb     1075011 <check_input_run+0x8301>
 1074e9c:	lea    (%rcx,%rdx,8),%rdx
 1074ea0:	mov    %rdx,%rsi
 1074ea3:	shr    $0x20,%rsi
 1074ea7:	jne    1075011 <check_input_run+0x8301>
 1074ead:	mov    %ecx,0x12c(%rax)
 1074eb3:	mov    %edx,0x13c(%rax)
 1074eb9:	mov    0x2c0(%rsp),%rsi
 1074ec1:	mov    (%rsi),%r8
 1074ec4:	mov    0x8(%rsi),%r9
 1074ec8:	lea    0x3(%r9,%r8,1),%rdi
 1074ecd:	add    %r8,%r9
 1074ed0:	and    $0xfffffffffffffffc,%rdi
 1074ed4:	cmp    %r9,%rdi
 1074ed7:	jae    1074ede <check_input_run+0x81ce>
 1074ed9:	xor    %r8d,%r8d
 1074edc:	jmp    1074f11 <check_input_run+0x8201>
 1074ede:	mov    0x10(%rsi),%r10
 1074ee2:	mov    %rdi,%r9
 1074ee5:	sub    %r8,%r9
 1074ee8:	xor    %r8d,%r8d
 1074eeb:	sub    %r9,%r10
 1074eee:	jb     1074f11 <check_input_run+0x8201>
 1074ef0:	shl    $0x4,%rcx
 1074ef4:	cmp    %r10,%rcx
 1074ef7:	ja     1074f11 <check_input_run+0x8201>
 1074ef9:	add    %rcx,%r9
 1074efc:	mov    %rdi,%r8
 1074eff:	mov    %r9,0x8(%rsi)
 1074f03:	mov    0x13c(%rax),%edx
 1074f09:	mov    0x2c0(%rsp),%rsi
 1074f11:	mov    %r8,0x120(%rax)
 1074f18:	mov    (%rsi),%rdi
 1074f1b:	mov    0x8(%rsi),%r8
 1074f1f:	lea    0x3(%r8,%rdi,1),%rcx
 1074f24:	add    %rdi,%r8
 1074f27:	and    $0xfffffffffffffffc,%rcx
 1074f2b:	cmp    %r8,%rcx
 1074f2e:	jae    1074f34 <check_input_run+0x8224>
 1074f30:	xor    %edi,%edi
 1074f32:	jmp    1074f58 <check_input_run+0x8248>
 1074f34:	mov    0x10(%rsi),%r9
 1074f38:	mov    %rcx,%r8
 1074f3b:	sub    %rdi,%r8
 1074f3e:	xor    %edi,%edi
 1074f40:	sub    %r8,%r9
 1074f43:	jb     1074f58 <check_input_run+0x8248>
 1074f45:	shl    $0x4,%rdx
 1074f49:	cmp    %r9,%rdx
 1074f4c:	ja     1074f58 <check_input_run+0x8248>
 1074f4e:	add    %rdx,%r8
 1074f51:	mov    %rcx,%rdi
 1074f54:	mov    %r8,0x8(%rsi)
 1074f58:	mov    %rdi,0x130(%rax)
 1074f5f:	mov    0x2c8(%rsp),%rcx
 1074f67:	mov    (%rcx),%rdi
 1074f6a:	mov    0x8(%rcx),%rsi
 1074f6e:	lea    0x3(%rsi,%rdi,1),%rdx
 1074f73:	add    %rdi,%rsi
 1074f76:	and    $0xfffffffffffffffc,%rdx
 1074f7a:	cmp    %rsi,%rdx
 1074f7d:	jae    1074f83 <check_input_run+0x8273>
 1074f7f:	xor    %edi,%edi
 1074f81:	jmp    1074fb2 <check_input_run+0x82a2>
 1074f83:	mov    0x10(%rcx),%r8
 1074f87:	mov    %rdx,%rsi
 1074f8a:	sub    %rdi,%rsi
 1074f8d:	xor    %edi,%edi
 1074f8f:	sub    %rsi,%r8
 1074f92:	jb     1074fb2 <check_input_run+0x82a2>
 1074f94:	mov    0x35c(%rax),%r9d
 1074f9b:	lea    0x4(,%r9,4),%r9
 1074fa3:	cmp    %r8,%r9
 1074fa6:	ja     1074fb2 <check_input_run+0x82a2>
 1074fa8:	add    %r9,%rsi
 1074fab:	mov    %rdx,%rdi
 1074fae:	mov    %rsi,0x8(%rcx)
 1074fb2:	mov    %rdi,0x518(%rsp)
 1074fba:	cmpq   $0x0,0x120(%rax)
 1074fc2:	je     1075011 <check_input_run+0x8301>
 1074fc4:	test   %rdi,%rdi
 1074fc7:	je     1075011 <check_input_run+0x8301>
 1074fc9:	cmpq   $0x0,0x130(%rax)
 1074fd1:	je     1075011 <check_input_run+0x8301>
 1074fd3:	mov    0x35c(%rax),%eax
 1074fd9:	mov    $0xff,%esi
 1074fde:	lea    0x4(,%rax,4),%rdx
 1074fe6:	vzeroupper
 1074fe9:	call   788120 <memset@plt>
 1074fee:	lea    0x2a0(%rsp),%rdi
 1074ff6:	vzeroupper
 1074ff9:	call   1088c20 <check_input_expressions>
 1074ffe:	mov    0x18(%rsp),%rax
 1075003:	cmpb   $0x0,0x3bd(%rax)
 107500a:	je     107502a <check_input_run+0x831a>
 107500c:	jmp    10753fc <check_input_run+0x86ec>
 1075011:	movb   $0x1,0x3bd(%rax)
 1075018:	mov    0x18(%rsp),%rax
 107501d:	cmpb   $0x0,0x3bd(%rax)
 1075024:	jne    10753fc <check_input_run+0x86ec>
 107502a:	mov    0x2a0(%rsp),%rbx
 1075032:	mov    0x2a8(%rsp),%r14
 107503a:	lea    0x2a0(%rsp),%rdi
 1075042:	vzeroupper
 1075045:	call   10fb970 <check_input_asm_labels>
 107504a:	mov    0x344(%rbx),%eax
 1075050:	test   %eax,%eax
 1075052:	je     1075162 <check_input_run+0x8452>
 1075058:	xor    %edx,%edx
 107505a:	jmp    1075072 <check_input_run+0x8362>
 107505c:	mov    0x344(%rbx),%eax
 1075062:	mov    0x50(%rsp),%rdx
 1075067:	inc    %rdx
 107506a:	test   %eax,%eax
 107506c:	je     1075162 <check_input_run+0x8452>
 1075072:	mov    0x670(%rsp),%ecx
 1075079:	cmp    %rcx,%rdx
 107507c:	jae    1075162 <check_input_run+0x8452>
 1075082:	cmpb   $0x1,0x3bd(%rbx)
 1075089:	je     1075162 <check_input_run+0x8452>
 107508f:	mov    0x270(%rbx),%rcx
 1075096:	cmpb   $0x0,(%rcx,%rdx,1)
 107509a:	je     1075067 <check_input_run+0x8357>
 107509c:	mov    0x288(%rbx),%rcx
 10750a3:	mov    (%rcx,%rdx,8),%r12
 10750a7:	test   %r12,%r12
 10750aa:	je     1075067 <check_input_run+0x8357>
 10750ac:	cmpl   $0x0,0x8(%r12)
 10750b2:	je     1075067 <check_input_run+0x8357>
 10750b4:	mov    %rdx,0x50(%rsp)
 10750b9:	xor    %r13d,%r13d
 10750bc:	xor    %ebp,%ebp
 10750be:	jmp    10750e5 <check_input_run+0x83d5>
 10750c0:	movb   $0x1,0x3bd(%rax)
 10750c7:	nopw   0x0(%rax,%rax,1)
 10750d0:	mov    0x8(%r12),%eax
 10750d5:	inc    %rbp
 10750d8:	add    $0x50,%r13
 10750dc:	cmp    %rax,%rbp
 10750df:	jae    107505c <check_input_run+0x834c>
 10750e5:	mov    (%r12),%r15
 10750e9:	cmpl   $0x12,0x1c(%r15,%r13,1)
 10750ef:	jne    10750d0 <check_input_run+0x83c0>
 10750f1:	mov    0x4(%r15,%r13,1),%eax
 10750f6:	cmp    0x670(%rsp),%eax
 10750fd:	ja     10750d0 <check_input_run+0x83c0>
 10750ff:	mov    0x38(%r15,%r13,1),%rdi
 1075104:	mov    0x40(%r15,%r13,1),%esi
 1075109:	call   10ea090 <check_asm_register>
 107510e:	test   %al,%al
 1075110:	jne    10750d0 <check_input_run+0x83c0>
 1075112:	mov    0x2a0(%rsp),%rax
 107511a:	mov    0x230(%rax),%ecx
 1075120:	cmp    0x234(%rax),%ecx
 1075126:	jae    10750c0 <check_input_run+0x83b0>
 1075128:	movzbl 0x3bd(%rax),%esi
 107512f:	mov    0x10(%r15,%r13,1),%edx
 1075134:	mov    0x228(%rax),%rdi
 107513b:	lea    0x1(%rcx),%r8d
 107513f:	mov    %r8d,0x230(%rax)
 1075146:	lea    (%rcx,%rcx,2),%rax
 107514a:	lea    0x1(%rsi,%rsi,2),%esi
 107514e:	mov    %edx,(%rdi,%rax,4)
 1075151:	mov    %esi,0x4(%rdi,%rax,4)
 1075155:	movl   $0x0,0x8(%rdi,%rax,4)
 107515d:	jmp    10750d0 <check_input_run+0x83c0>
 1075162:	cmpl   $0x0,0x340(%rbx)
 1075169:	mov    0x20(%rsp),%r12
 107516e:	je     10753fc <check_input_run+0x86ec>
 1075174:	xor    %eax,%eax
 1075176:	jmp    1075192 <check_input_run+0x8482>
 1075178:	nopl   0x0(%rax,%rax,1)
 1075180:	mov    0x340(%rbx),%ecx
 1075186:	inc    %rax
 1075189:	cmp    %rcx,%rax
 107518c:	jae    10753fc <check_input_run+0x86ec>
 1075192:	cmpb   $0x0,0x3bd(%rbx)
 1075199:	jne    10753fc <check_input_run+0x86ec>
 107519f:	mov    0x338(%rbx),%rdx
 10751a6:	lea    (%rax,%rax,4),%rsi
 10751aa:	shl    $0x4,%rsi
 10751ae:	mov    0x2c(%rdx,%rsi,1),%edi
 10751b2:	lea    (%rdx,%rsi,1),%rcx
 10751b6:	add    0x28(%rdx,%rsi,1),%edi
 10751ba:	jne    1075350 <check_input_run+0x8640>
 10751c0:	cmpl   $0x0,0x34(%rcx)
 10751c4:	je     1075180 <check_input_run+0x8470>
 10751c6:	xor    %edx,%edx
 10751c8:	jmp    10751e8 <check_input_run+0x84d8>
 10751ca:	nopw   0x0(%rax,%rax,1)
 10751d0:	movb   $0x1,0x3bd(%r8)
 10751d8:	mov    0x34(%rcx),%esi
 10751db:	mov    0x20(%rsp),%r12
 10751e0:	inc    %rdx
 10751e3:	cmp    %rsi,%rdx
 10751e6:	jae    1075180 <check_input_run+0x8470>
 10751e8:	lea    (%rdx,%rdx,2),%rsi
 10751ec:	mov    0x44(%rcx),%r8d
 10751f0:	shl    $0x2,%rsi
 10751f4:	add    0x20(%rcx),%rsi
 10751f8:	cmp    0x35c(%rbx),%r8d
 10751ff:	jae    1075270 <check_input_run+0x8560>
 1075201:	mov    0x60(%r14),%rdi
 1075205:	lea    0x1(%r8),%r9
 1075209:	mov    (%rdi,%r8,4),%r10d
 107520d:	mov    0x8(%rsi),%edi
 1075210:	cmp    %r10d,%r9d
 1075213:	jae    1075273 <check_input_run+0x8563>
 1075215:	not    %r8d
 1075218:	add    %r10d,%r8d
 107521b:	mov    %edi,%r10d
 107521e:	jmp    1075228 <check_input_run+0x8518>
 1075220:	inc    %r9
 1075223:	dec    %r8d
 1075226:	je     1075273 <check_input_run+0x8563>
 1075228:	cmp    $0xffffffff,%r10d
 107522c:	jne    1075273 <check_input_run+0x8563>
 107522e:	mov    0x50(%r14),%r11
 1075232:	mov    $0xffffffff,%r10d
 1075238:	cmpb   $0x21,(%r11,%r9,1)
 107523d:	jne    1075220 <check_input_run+0x8510>
 107523f:	mov    0x610(%rsp),%r11
 1075247:	mov    (%r11,%r9,4),%r11d
 107524b:	cmp    0x35c(%rbx),%r11d
 1075252:	jae    1075220 <check_input_run+0x8510>
 1075254:	mov    0x18(%r14),%r15
 1075258:	mov    (%r15,%r11,4),%r11d
 107525c:	cmp    (%rsi),%r11d
 107525f:	jne    1075220 <check_input_run+0x8510>
 1075261:	mov    %r9d,0x8(%rsi)
 1075265:	mov    %r9d,%edi
 1075268:	mov    %r9d,%r10d
 107526b:	jmp    1075220 <check_input_run+0x8510>
 107526d:	nopl   (%rax)
 1075270:	mov    0x8(%rsi),%edi
 1075273:	cmp    $0xffffffff,%edi
 1075276:	je     10752f0 <check_input_run+0x85e0>
 1075278:	mov    0x2a8(%rsp),%r9
 1075280:	mov    0x30(%r9),%r10d
 1075284:	cmp    %r10d,%edi
 1075287:	jae    10751d8 <check_input_run+0x84c8>
 107528d:	mov    0x2a0(%rsp),%r8
 1075295:	mov    0x38(%rcx),%r11d
 1075299:	mov    0x318(%r8),%r15
 10752a0:	jmp    10752c1 <check_input_run+0x85b1>
 10752a2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10752b0:	mov    0x60(%r9),%r12
 10752b4:	mov    (%r12,%rdi,4),%edi
 10752b8:	cmp    %r10d,%edi
 10752bb:	jae    10751d8 <check_input_run+0x84c8>
 10752c1:	mov    %edi,%edi
 10752c3:	mov    (%r15,%rdi,4),%r12d
 10752c7:	test   %r12d,%r12d
 10752ca:	je     10752b0 <check_input_run+0x85a0>
 10752cc:	mov    0x310(%r8),%r13
 10752d3:	dec    %r12d
 10752d6:	lea    (%r12,%r12,2),%r12
 10752da:	cmp    0x0(%r13,%r12,8),%r11d
 10752df:	jbe    10752f8 <check_input_run+0x85e8>
 10752e1:	lea    0x0(%r13,%r12,8),%r12
 10752e6:	cmp    0x4(%r12),%r11d
 10752eb:	jb     10752b0 <check_input_run+0x85a0>
 10752ed:	jmp    10752f8 <check_input_run+0x85e8>
 10752ef:	nop
 10752f0:	mov    0x2a0(%rsp),%r8
 10752f8:	mov    0x230(%r8),%edi
 10752ff:	cmp    0x234(%r8),%edi
 1075306:	jae    10751d0 <check_input_run+0x84c0>
 107530c:	movzbl 0x3bd(%r8),%r9d
 1075314:	mov    0x4(%rsi),%esi
 1075317:	mov    0x228(%r8),%r10
 107531e:	lea    0x1(%rdi),%r11d
 1075322:	lea    (%rdi,%rdi,2),%rdi
 1075326:	mov    %r11d,0x230(%r8)
 107532d:	lea    0x2(%r9,%r9,1),%r9d
 1075332:	mov    %esi,(%r10,%rdi,4)
 1075336:	mov    %r9d,0x4(%r10,%rdi,4)
 107533b:	movl   $0x0,0x8(%r10,%rdi,4)
 1075344:	jmp    10751d8 <check_input_run+0x84c8>
 1075349:	nopl   0x0(%rax)
 1075350:	mov    $0x20,%edx
 1075355:	xor    %esi,%esi
 1075357:	jmp    107537e <check_input_run+0x866e>
 1075359:	nopl   0x0(%rax)
 1075360:	movb   $0x1,0x3bd(%r8)
 1075368:	mov    0x2c(%rcx),%edi
 107536b:	inc    %rsi
 107536e:	add    $0x30,%rdx
 1075372:	add    0x28(%rcx),%edi
 1075375:	cmp    %rdi,%rsi
 1075378:	jae    10751c0 <check_input_run+0x84b0>
 107537e:	mov    0x10(%rcx),%rdi
 1075382:	mov    0x2c0(%rbx),%r9
 1075389:	mov    -0x4(%rdi,%rdx,1),%r8d
 107538e:	mov    (%r9,%r8,4),%r9d
 1075392:	mov    %r9d,(%rdi,%rdx,1)
 1075396:	cmp    $0xffffffff,%r9d
 107539a:	jne    1075368 <check_input_run+0x8658>
 107539c:	cmp    0x670(%rsp),%r8d
 10753a4:	jae    1075368 <check_input_run+0x8658>
 10753a6:	mov    0x2a0(%rsp),%r8
 10753ae:	mov    0x230(%r8),%r9d
 10753b5:	cmp    0x234(%r8),%r9d
 10753bc:	jae    1075360 <check_input_run+0x8650>
 10753be:	movzbl 0x3bd(%r8),%r10d
 10753c6:	mov    -0xc(%rdi,%rdx,1),%edi
 10753ca:	mov    0x228(%r8),%r11
 10753d1:	lea    0x1(%r9),%ebp
 10753d5:	mov    %ebp,0x230(%r8)
 10753dc:	lea    (%r9,%r9,2),%r8
 10753e0:	lea    0x1(%r10,%r10,2),%r10d
 10753e5:	mov    %edi,(%r11,%r8,4)
 10753e9:	mov    %r10d,0x4(%r11,%r8,4)
 10753ee:	movl   $0x0,0x8(%r11,%r8,4)
 10753f7:	jmp    1075368 <check_input_run+0x8658>
 10753fc:	mov    0x18(%rsp),%rax
 1075401:	cmpl   $0x0,0x230(%rax)
 1075408:	movzbl 0x3bd(%rax),%eax
 107540f:	je     107541b <check_input_run+0x870b>
 1075411:	mov    %eax,%ecx
 1075413:	xor    $0x1,%cl
 1075416:	jmp    1075c90 <check_input_run+0x8f80>
 107541b:	test   %al,%al
 107541d:	je     1075426 <check_input_run+0x8716>
 107541f:	mov    $0x1,%al
 1075421:	jmp    1075c8e <check_input_run+0x8f7e>
 1075426:	mov    0x2a0(%rsp),%rcx
 107542e:	mov    0x2a8(%rsp),%rax
 1075436:	cmpl   $0x0,0x330(%rcx)
 107543d:	je     10754cb <check_input_run+0x87bb>
 1075443:	xor    %edx,%edx
 1075445:	xor    %esi,%esi
 1075447:	jmp    1075462 <check_input_run+0x8752>
 1075449:	movb   $0x1,0x3bd(%rcx)
 1075450:	mov    0x330(%rcx),%edi
 1075456:	inc    %rsi
 1075459:	add    $0x24,%rdx
 107545d:	cmp    %rdi,%rsi
 1075460:	jae    10754cb <check_input_run+0x87bb>
 1075462:	mov    0x328(%rcx),%r8
 1075469:	cmpb   $0x1,0x20(%r8,%rdx,1)
 107546f:	jne    1075450 <check_input_run+0x8740>
 1075471:	cmpl   $0xffffffff,0x10(%r8,%rdx,1)
 1075477:	jne    1075450 <check_input_run+0x8740>
 1075479:	mov    0x230(%rcx),%edi
 107547f:	cmp    0x234(%rcx),%edi
 1075485:	jae    1075449 <check_input_run+0x8739>
 1075487:	movzbl 0x3bd(%rcx),%r9d
 107548f:	mov    0x8(%r8,%rdx,1),%r8d
 1075494:	mov    0x228(%rcx),%r10
 107549b:	lea    0x1(%rdi),%r11d
 107549f:	mov    %r11d,0x230(%rcx)
 10754a6:	lea    (%rdi,%rdi,2),%rcx
 10754aa:	lea    0x1(%r9,%r9,2),%r9d
 10754af:	mov    %r8d,(%r10,%rcx,4)
 10754b3:	mov    %r9d,0x4(%r10,%rcx,4)
 10754b8:	movl   $0x0,0x8(%r10,%rcx,4)
 10754c1:	mov    0x2a0(%rsp),%rcx
 10754c9:	jmp    1075450 <check_input_run+0x8740>
 10754cb:	cmpl   $0x0,0x30(%rax)
 10754cf:	je     1075671 <check_input_run+0x8961>
 10754d5:	xor    %edx,%edx
 10754d7:	xor    %ecx,%ecx
 10754d9:	jmp    1075506 <check_input_run+0x87f6>
 10754db:	nopl   0x0(%rax,%rax,1)
 10754e0:	mov    0x640(%rsp),%rsi
 10754e8:	lea    -0x1(%rdx),%edi
 10754eb:	mov    (%rsi,%rdi,4),%esi
 10754ee:	inc    %esi
 10754f0:	mov    0x638(%rsp),%rdi
 10754f8:	mov    %esi,(%rdi,%rcx,4)
 10754fb:	inc    %rcx
 10754fe:	mov    0x30(%rax),%edi
 1075501:	cmp    %rdi,%rcx
 1075504:	jae    1075561 <check_input_run+0x8851>
 1075506:	mov    0x4f8(%rsp),%rdi
 107550e:	mov    $0x0,%esi
 1075513:	test   %edx,%edx
 1075515:	je     1075542 <check_input_run+0x8832>
 1075517:	mov    %edx,%esi
 1075519:	mov    0x640(%rsp),%rdx
 1075521:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1075530:	mov    -0x4(%rdx,%rsi,4),%r8d
 1075535:	cmp    %ecx,(%rdi,%r8,4)
 1075539:	ja     1075542 <check_input_run+0x8832>
 107553b:	dec    %rsi
 107553e:	jne    1075530 <check_input_run+0x8820>
 1075540:	xor    %esi,%esi
 1075542:	cmpl   $0x0,(%rdi,%rcx,4)
 1075546:	je     1075557 <check_input_run+0x8847>
 1075548:	mov    0x640(%rsp),%rdx
 1075550:	mov    %esi,%edi
 1075552:	inc    %esi
 1075554:	mov    %ecx,(%rdx,%rdi,4)
 1075557:	mov    %esi,%edx
 1075559:	test   %esi,%esi
 107555b:	jne    10754e0 <check_input_run+0x87d0>
 107555d:	xor    %esi,%esi
 107555f:	jmp    10754f0 <check_input_run+0x87e0>
 1075561:	lea    0x10(%rax),%rcx
 1075565:	test   %edi,%edi
 1075567:	je     1075675 <check_input_run+0x8965>
 107556d:	xor    %edx,%edx
 107556f:	jmp    107558f <check_input_run+0x887f>
 1075571:	movb   $0x1,0x3bd(%rsi)
 1075578:	nopl   0x0(%rax,%rax,1)
 1075580:	mov    0x30(%rax),%edi
 1075583:	inc    %rdx
 1075586:	cmp    %rdi,%rdx
 1075589:	jae    1075675 <check_input_run+0x8965>
 107558f:	mov    (%rcx),%rsi
 1075592:	cmpb   $0x4f,(%rsi,%rdx,1)
 1075596:	jne    10755b5 <check_input_run+0x88a5>
 1075598:	mov    0x2a0(%rsp),%rsi
 10755a0:	mov    0x300(%rsi),%r8
 10755a7:	mov    (%r8,%rdx,4),%r9d
 10755ab:	mov    %edx,%r8d
 10755ae:	cmp    %edi,%r9d
 10755b1:	jae    1075580 <check_input_run+0x8870>
 10755b3:	jmp    10755f3 <check_input_run+0x88e3>
 10755b5:	mov    0x50(%rax),%rsi
 10755b9:	cmpb   $0x3a,(%rsi,%rdx,1)
 10755bd:	jne    1075580 <check_input_run+0x8870>
 10755bf:	mov    0x2a0(%rsp),%rsi
 10755c7:	mov    0x2f8(%rsi),%r8
 10755ce:	mov    (%r8,%rdx,4),%r8d
 10755d2:	cmp    %edi,%r8d
 10755d5:	jae    10755e5 <check_input_run+0x88d5>
 10755d7:	mov    0x610(%rsp),%r9
 10755df:	mov    (%r9,%r8,4),%r8d
 10755e3:	jmp    10755eb <check_input_run+0x88db>
 10755e5:	mov    $0xffffffff,%r8d
 10755eb:	mov    %edx,%r9d
 10755ee:	cmp    %edi,%r9d
 10755f1:	jae    1075580 <check_input_run+0x8870>
 10755f3:	mov    0x638(%rsp),%rdi
 10755fb:	mov    %r9d,%r9d
 10755fe:	mov    (%rdi,%r9,4),%edi
 1075602:	test   %edi,%edi
 1075604:	je     1075580 <check_input_run+0x8870>
 107560a:	dec    %edi
 107560c:	cmp    %edi,%r8d
 107560f:	jb     1075625 <check_input_run+0x8915>
 1075611:	mov    0x4f8(%rsp),%r9
 1075619:	mov    %edi,%edi
 107561b:	cmp    (%r9,%rdi,4),%r8d
 107561f:	jb     1075580 <check_input_run+0x8870>
 1075625:	mov    0x230(%rsi),%edi
 107562b:	cmp    0x234(%rsi),%edi
 1075631:	jae    1075571 <check_input_run+0x8861>
 1075637:	movzbl 0x3bd(%rsi),%r8d
 107563f:	mov    0x228(%rsi),%r9
 1075646:	lea    0x1(%rdi),%r10d
 107564a:	mov    %r10d,0x230(%rsi)
 1075651:	lea    (%rdi,%rdi,2),%rsi
 1075655:	lea    0x1(%r8,%r8,2),%r8d
 107565a:	mov    %edx,(%r9,%rsi,4)
 107565e:	mov    %r8d,0x4(%r9,%rsi,4)
 1075663:	movl   $0x0,0x8(%r9,%rsi,4)
 107566c:	jmp    1075580 <check_input_run+0x8870>
 1075671:	lea    0x10(%rax),%rcx
 1075675:	mov    0x678(%rsp),%edi
 107567c:	test   %edi,%edi
 107567e:	je     1075c75 <check_input_run+0x8f65>
 1075684:	xor    %esi,%esi
 1075686:	jmp    1075699 <check_input_run+0x8989>
 1075688:	mov    %esi,%r13d
 107568b:	inc    %r13d
 107568e:	mov    %r13d,%esi
 1075691:	test   %edi,%edi
 1075693:	je     1075c75 <check_input_run+0x8f65>
 1075699:	mov    0x30(%rax),%r10d
 107569d:	cmp    %r10d,%esi
 10756a0:	jae    1075c75 <check_input_run+0x8f65>
 10756a6:	mov    0x2a0(%rsp),%r11
 10756ae:	mov    %esi,%r8d
 10756b1:	mov    0x1f0(%r11),%rdx
 10756b8:	test   %rdx,%rdx
 10756bb:	je     10756c4 <check_input_run+0x89b4>
 10756bd:	cmpb   $0x0,(%rdx,%r8,1)
 10756c2:	jne    1075688 <check_input_run+0x8978>
 10756c4:	mov    0x50(%rax),%rbx
 10756c8:	lea    0x0(,%r8,4),%rdx
 10756d0:	add    0x60(%rax),%rdx
 10756d4:	cmpb   $0x34,(%rbx,%r8,1)
 10756d9:	jne    1075688 <check_input_run+0x8978>
 10756db:	mov    (%rdx),%r13d
 10756de:	cmp    %r10d,%r13d
 10756e1:	jae    1075688 <check_input_run+0x8978>
 10756e3:	lea    0x1(%r8),%r9
 10756e7:	cmp    %r13d,%r9d
 10756ea:	jae    107568b <check_input_run+0x897b>
 10756ec:	mov    %esi,%r14d
 10756ef:	sub    %r13d,%r14d
 10756f2:	mov    %esi,%edi
 10756f4:	not    %edi
 10756f6:	lea    -0x2(%r13),%ebp
 10756fa:	mov    %r8,0x28(%rsp)
 10756ff:	not    %r14d
 1075702:	mov    %ebp,%edx
 1075704:	add    %r13d,%edi
 1075707:	sub    %esi,%edx
 1075709:	and    $0x3,%r14d
 107570d:	mov    %edi,0x50(%rsp)
 1075711:	cmp    $0x3,%edx
 1075714:	jae    1075727 <check_input_run+0x8a17>
 1075716:	xor    %r8d,%r8d
 1075719:	mov    $0xffffffff,%r12d
 107571f:	mov    %r9,%r15
 1075722:	jmp    1075948 <check_input_run+0x8c38>
 1075727:	mov    %ebp,0x90(%rsp)
 107572e:	lea    0x3(%rbx,%r9,1),%rbp
 1075733:	and    $0xfffffffc,%edi
 1075736:	mov    $0xffffffff,%r12d
 107573c:	mov    %r13,0x98(%rsp)
 1075744:	xor    %r15d,%r15d
 1075747:	xor    %r8d,%r8d
 107574a:	nopw   0x0(%rax,%rax,1)
 1075750:	cmpb   $0x9,-0x3(%rbp,%r15,1)
 1075756:	jne    10757b0 <check_input_run+0x8aa0>
 1075758:	mov    (%rcx),%rdx
 107575b:	add    %r9,%rdx
 107575e:	cmpb   $0xf,(%r15,%rdx,1)
 1075763:	jne    10757b0 <check_input_run+0x8aa0>
 1075765:	mov    0x300(%r11),%rdx
 107576c:	lea    0x0(,%r9,4),%r13
 1075774:	add    %r13,%rdx
 1075777:	mov    (%rdx,%r15,4),%edx
 107577b:	cmp    %r10d,%edx
 107577e:	jae    10757b0 <check_input_run+0x8aa0>
 1075780:	mov    0x638(%rsp),%r13
 1075788:	mov    0x0(%r13,%rdx,4),%edx
 107578d:	test   %edx,%edx
 107578f:	je     10757b0 <check_input_run+0x8aa0>
 1075791:	mov    0x4f8(%rsp),%r13
 1075799:	dec    %edx
 107579b:	cmp    %r8d,%edx
 107579e:	cmova  %edx,%r8d
 10757a2:	mov    0x0(%r13,%rdx,4),%edx
 10757a7:	cmp    %r12d,%edx
 10757aa:	cmovb  %edx,%r12d
 10757ae:	xchg   %ax,%ax
 10757b0:	cmpb   $0x9,-0x2(%rbp,%r15,1)
 10757b6:	jne    1075810 <check_input_run+0x8b00>
 10757b8:	mov    (%rcx),%rdx
 10757bb:	add    %r9,%rdx
 10757be:	cmpb   $0xf,0x1(%r15,%rdx,1)
 10757c4:	jne    1075810 <check_input_run+0x8b00>
 10757c6:	mov    0x300(%r11),%rdx
 10757cd:	lea    0x0(,%r9,4),%r13
 10757d5:	add    %r13,%rdx
 10757d8:	mov    0x4(%rdx,%r15,4),%edx
 10757dd:	cmp    %r10d,%edx
 10757e0:	jae    1075810 <check_input_run+0x8b00>
 10757e2:	mov    0x638(%rsp),%r13
 10757ea:	mov    0x0(%r13,%rdx,4),%edx
 10757ef:	test   %edx,%edx
 10757f1:	je     1075810 <check_input_run+0x8b00>
 10757f3:	mov    0x4f8(%rsp),%r13
 10757fb:	dec    %edx
 10757fd:	cmp    %r8d,%edx
 1075800:	cmova  %edx,%r8d
 1075804:	mov    0x0(%r13,%rdx,4),%edx
 1075809:	cmp    %r12d,%edx
 107580c:	cmovb  %edx,%r12d
 1075810:	cmpb   $0x9,-0x1(%rbp,%r15,1)
 1075816:	jne    1075890 <check_input_run+0x8b80>
 1075818:	mov    (%rcx),%rdx
 107581b:	add    %r9,%rdx
 107581e:	cmpb   $0xf,0x2(%r15,%rdx,1)
 1075824:	jne    1075890 <check_input_run+0x8b80>
 1075826:	mov    0x300(%r11),%rdx
 107582d:	lea    0x0(,%r9,4),%r13
 1075835:	add    %r13,%rdx
 1075838:	mov    0x8(%rdx,%r15,4),%edx
 107583d:	cmp    %r10d,%edx
 1075840:	jae    1075890 <check_input_run+0x8b80>
 1075842:	mov    0x638(%rsp),%r13
 107584a:	mov    0x0(%r13,%rdx,4),%edx
 107584f:	test   %edx,%edx
 1075851:	je     1075890 <check_input_run+0x8b80>
 1075853:	dec    %edx
 1075855:	mov    %edx,%r13d
 1075858:	cmp    %r8d,%edx
 107585b:	ja     1075860 <check_input_run+0x8b50>
 107585d:	mov    %r8d,%r13d
 1075860:	mov    0x4f8(%rsp),%r8
 1075868:	mov    (%r8,%rdx,4),%edx
 107586c:	cmp    %r12d,%edx
 107586f:	jb     1075874 <check_input_run+0x8b64>
 1075871:	mov    %r12d,%edx
 1075874:	mov    %edx,%r12d
 1075877:	cmpb   $0x9,0x0(%rbp,%r15,1)
 107587d:	jne    1075910 <check_input_run+0x8c00>
 1075883:	jmp    107589b <check_input_run+0x8b8b>
 1075885:	data16 cs nopw 0x0(%rax,%rax,1)
 1075890:	mov    %r8d,%r13d
 1075893:	cmpb   $0x9,0x0(%rbp,%r15,1)
 1075899:	jne    1075910 <check_input_run+0x8c00>
 107589b:	mov    (%rcx),%rdx
 107589e:	add    %r9,%rdx
 10758a1:	cmpb   $0xf,0x3(%r15,%rdx,1)
 10758a7:	jne    1075910 <check_input_run+0x8c00>
 10758a9:	mov    0x300(%r11),%rdx
 10758b0:	lea    0x0(,%r9,4),%r8
 10758b8:	add    %r8,%rdx
 10758bb:	mov    0xc(%rdx,%r15,4),%edx
 10758c0:	cmp    %r10d,%edx
 10758c3:	jae    1075910 <check_input_run+0x8c00>
 10758c5:	mov    0x638(%rsp),%r8
 10758cd:	mov    (%r8,%rdx,4),%edx
 10758d1:	test   %edx,%edx
 10758d3:	je     1075910 <check_input_run+0x8c00>
 10758d5:	dec    %edx
 10758d7:	mov    %edx,%r8d
 10758da:	cmp    %r13d,%edx
 10758dd:	ja     10758e2 <check_input_run+0x8bd2>
 10758df:	mov    %r13d,%r8d
 10758e2:	mov    0x4f8(%rsp),%r13
 10758ea:	mov    0x0(%r13,%rdx,4),%edx
 10758ef:	cmp    %r12d,%edx
 10758f2:	jb     10758f7 <check_input_run+0x8be7>
 10758f4:	mov    %r12d,%edx
 10758f7:	mov    %edx,%r12d
 10758fa:	add    $0x4,%r15
 10758fe:	cmp    %r15d,%edi
 1075901:	jne    1075750 <check_input_run+0x8a40>
 1075907:	jmp    1075920 <check_input_run+0x8c10>
 1075909:	nopl   0x0(%rax)
 1075910:	mov    %r13d,%r8d
 1075913:	add    $0x4,%r15
 1075917:	cmp    %r15d,%edi
 107591a:	jne    1075750 <check_input_run+0x8a40>
 1075920:	test   %r14d,%r14d
 1075923:	je     1075995 <check_input_run+0x8c85>
 1075925:	mov    0x98(%rsp),%r13
 107592d:	mov    0x90(%rsp),%ebp
 1075934:	add    %r9,%r15
 1075937:	jmp    1075948 <check_input_run+0x8c38>
 1075939:	nopl   0x0(%rax)
 1075940:	inc    %r15
 1075943:	dec    %r14d
 1075946:	je     10759a4 <check_input_run+0x8c94>
 1075948:	cmpb   $0x9,(%rbx,%r15,1)
 107594d:	jne    1075940 <check_input_run+0x8c30>
 107594f:	mov    (%rcx),%rdx
 1075952:	cmpb   $0xf,(%rdx,%r15,1)
 1075957:	jne    1075940 <check_input_run+0x8c30>
 1075959:	mov    0x300(%r11),%rdx
 1075960:	mov    (%rdx,%r15,4),%edx
 1075964:	cmp    %r10d,%edx
 1075967:	jae    1075940 <check_input_run+0x8c30>
 1075969:	mov    0x638(%rsp),%rdi
 1075971:	mov    (%rdi,%rdx,4),%edx
 1075974:	test   %edx,%edx
 1075976:	je     1075940 <check_input_run+0x8c30>
 1075978:	mov    0x4f8(%rsp),%rdi
 1075980:	dec    %edx
 1075982:	cmp    %r8d,%edx
 1075985:	cmova  %edx,%r8d
 1075989:	mov    (%rdi,%rdx,4),%edx
 107598c:	cmp    %r12d,%edx
 107598f:	cmovb  %edx,%r12d
 1075993:	jmp    1075940 <check_input_run+0x8c30>
 1075995:	mov    0x98(%rsp),%r13
 107599d:	mov    0x90(%rsp),%ebp
 10759a4:	testb  $0x1,0x50(%rsp)
 10759a9:	mov    %r12d,%r10d
 10759ac:	mov    %r8d,%r11d
 10759af:	jne    10759be <check_input_run+0x8cae>
 10759b1:	mov    0x20(%rsp),%r12
 10759b6:	mov    %r9,%rdi
 10759b9:	jmp    1075a79 <check_input_run+0x8d69>
 10759be:	mov    (%rcx),%r8
 10759c1:	mov    0x20(%rsp),%r12
 10759c6:	lea    0x1(%r9),%rdi
 10759ca:	cmpb   $0x4f,(%r8,%r9,1)
 10759cf:	jne    1075a79 <check_input_run+0x8d69>
 10759d5:	mov    0x30(%rax),%edx
 10759d8:	cmp    %rdx,%rdi
 10759db:	jae    1075a79 <check_input_run+0x8d69>
 10759e1:	mov    0x60(%rax),%rdx
 10759e5:	mov    0x28(%rsp),%rbx
 10759ea:	cmp    0x8(%rdx,%rbx,4),%r9d
 10759ef:	jne    1075a79 <check_input_run+0x8d69>
 10759f5:	mov    0x50(%rax),%rdx
 10759f9:	cmpb   $0x1a,(%rdx,%rdi,1)
 10759fd:	jne    1075a79 <check_input_run+0x8d69>
 10759ff:	cmpb   $0x11,(%r8,%rdi,1)
 1075a04:	jne    1075a79 <check_input_run+0x8d69>
 1075a06:	mov    0x2a0(%rsp),%r8
 1075a0e:	mov    0x348(%r8),%rdx
 1075a15:	cmpl   $0x0,0x4(%rdx,%rbx,4)
 1075a1a:	jne    1075a79 <check_input_run+0x8d69>
 1075a1c:	cmp    %r11d,%r9d
 1075a1f:	jb     1075a26 <check_input_run+0x8d16>
 1075a21:	cmp    %r10d,%r9d
 1075a24:	jb     1075a79 <check_input_run+0x8d69>
 1075a26:	mov    0x230(%r8),%edx
 1075a2d:	mov    %ebp,%r15d
 1075a30:	cmp    0x234(%r8),%edx
 1075a37:	jae    1075a6e <check_input_run+0x8d5e>
 1075a39:	movzbl 0x3bd(%r8),%ebx
 1075a41:	mov    0x228(%r8),%r14
 1075a48:	lea    0x1(%rdx),%ebp
 1075a4b:	lea    (%rdx,%rdx,2),%rdx
 1075a4f:	mov    %ebp,0x230(%r8)
 1075a56:	lea    0x1(%rbx,%rbx,2),%ebx
 1075a5a:	mov    %r9d,(%r14,%rdx,4)
 1075a5e:	mov    %ebx,0x4(%r14,%rdx,4)
 1075a63:	movl   $0x0,0x8(%r14,%rdx,4)
 1075a6c:	jmp    1075a76 <check_input_run+0x8d66>
 1075a6e:	movb   $0x1,0x3bd(%r8)
 1075a76:	mov    %r15d,%ebp
 1075a79:	cmp    %esi,%ebp
 1075a7b:	jne    1075a89 <check_input_run+0x8d79>
 1075a7d:	mov    0x678(%rsp),%edi
 1075a84:	jmp    107568b <check_input_run+0x897b>
 1075a89:	lea    0x0(,%rdi,4),%r8
 1075a91:	mov    %r13d,%esi
 1075a94:	sub    %edi,%esi
 1075a96:	xor    %r9d,%r9d
 1075a99:	jmp    1075ae9 <check_input_run+0x8dd9>
 1075a9b:	movzbl 0x3bd(%r14),%ebx
 1075aa3:	mov    0x228(%r14),%r15
 1075aaa:	lea    0x1(%rdx),%ebp
 1075aad:	lea    (%rdx,%rdx,2),%rdx
 1075ab1:	mov    %ebp,0x230(%r14)
 1075ab8:	lea    0x1(%rdi,%r9,1),%ebp
 1075abd:	lea    0x1(%rbx,%rbx,2),%ebx
 1075ac1:	mov    %ebp,(%r15,%rdx,4)
 1075ac5:	mov    %ebx,0x4(%r15,%rdx,4)
 1075aca:	movl   $0x0,0x8(%r15,%rdx,4)
 1075ad3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1075ae0:	add    $0x2,%r9
 1075ae4:	cmp    %r9d,%esi
 1075ae7:	je     1075a7d <check_input_run+0x8d6d>
 1075ae9:	mov    (%rcx),%r15
 1075aec:	lea    (%rdi,%r9,1),%r14
 1075af0:	lea    0x1(%rdi,%r9,1),%rbx
 1075af5:	cmpb   $0x4f,(%r15,%r14,1)
 1075afa:	jne    1075bd0 <check_input_run+0x8ec0>
 1075b00:	mov    0x30(%rax),%edx
 1075b03:	cmp    %rdx,%rbx
 1075b06:	jae    1075bd0 <check_input_run+0x8ec0>
 1075b0c:	mov    0x60(%rax),%rdx
 1075b10:	add    %r8,%rdx
 1075b13:	mov    0x4(%rdx,%r9,4),%edx
 1075b18:	cmp    %rdx,%r14
 1075b1b:	jne    1075bd0 <check_input_run+0x8ec0>
 1075b21:	mov    0x50(%rax),%rdx
 1075b25:	add    %rdi,%rdx
 1075b28:	cmpb   $0x1a,0x1(%r9,%rdx,1)
 1075b2e:	jne    1075bd0 <check_input_run+0x8ec0>
 1075b34:	add    %rdi,%r15
 1075b37:	cmpb   $0x11,0x1(%r9,%r15,1)
 1075b3d:	jne    1075bd0 <check_input_run+0x8ec0>
 1075b43:	mov    0x2a0(%rsp),%r15
 1075b4b:	mov    0x348(%r15),%rdx
 1075b52:	add    %r8,%rdx
 1075b55:	cmpl   $0x0,(%rdx,%r9,4)
 1075b5a:	jne    1075bd0 <check_input_run+0x8ec0>
 1075b5c:	cmp    %r11,%r14
 1075b5f:	jb     1075b66 <check_input_run+0x8e56>
 1075b61:	cmp    %r10,%r14
 1075b64:	jb     1075bd0 <check_input_run+0x8ec0>
 1075b66:	mov    0x230(%r15),%edx
 1075b6d:	cmp    0x234(%r15),%edx
 1075b74:	jae    1075bc6 <check_input_run+0x8eb6>
 1075b76:	movzbl 0x3bd(%r15),%r12d
 1075b7e:	mov    %r13,0x98(%rsp)
 1075b86:	lea    0x1(%rdx),%r13d
 1075b8a:	lea    (%rdx,%rdx,2),%rdx
 1075b8e:	lea    0x1(%r12,%r12,2),%ebp
 1075b93:	mov    0x228(%r15),%r12
 1075b9a:	mov    %r13d,0x230(%r15)
 1075ba1:	lea    (%rdi,%r9,1),%r15d
 1075ba5:	mov    0x98(%rsp),%r13
 1075bad:	mov    %r15d,(%r12,%rdx,4)
 1075bb1:	mov    %ebp,0x4(%r12,%rdx,4)
 1075bb6:	movl   $0x0,0x8(%r12,%rdx,4)
 1075bbf:	mov    0x20(%rsp),%r12
 1075bc4:	jmp    1075bd0 <check_input_run+0x8ec0>
 1075bc6:	movb   $0x1,0x3bd(%r15)
 1075bce:	xchg   %ax,%ax
 1075bd0:	mov    (%rcx),%r15
 1075bd3:	cmpb   $0x4f,0x1(%r15,%r14,1)
 1075bd9:	jne    1075ae0 <check_input_run+0x8dd0>
 1075bdf:	mov    0x30(%rax),%r14d
 1075be3:	lea    0x2(%rdi,%r9,1),%rdx
 1075be8:	cmp    %r14,%rdx
 1075beb:	jae    1075ae0 <check_input_run+0x8dd0>
 1075bf1:	mov    0x60(%rax),%rdx
 1075bf5:	add    %r8,%rdx
 1075bf8:	mov    0x8(%rdx,%r9,4),%edx
 1075bfd:	cmp    %rdx,%rbx
 1075c00:	jne    1075ae0 <check_input_run+0x8dd0>
 1075c06:	mov    0x50(%rax),%rdx
 1075c0a:	add    %rdi,%rdx
 1075c0d:	cmpb   $0x1a,0x2(%r9,%rdx,1)
 1075c13:	jne    1075ae0 <check_input_run+0x8dd0>
 1075c19:	add    %rdi,%r15
 1075c1c:	cmpb   $0x11,0x2(%r9,%r15,1)
 1075c22:	jne    1075ae0 <check_input_run+0x8dd0>
 1075c28:	mov    0x2a0(%rsp),%r14
 1075c30:	mov    0x348(%r14),%rdx
 1075c37:	add    %r8,%rdx
 1075c3a:	cmpl   $0x0,0x4(%rdx,%r9,4)
 1075c40:	jne    1075ae0 <check_input_run+0x8dd0>
 1075c46:	cmp    %r11,%rbx
 1075c49:	jb     1075c54 <check_input_run+0x8f44>
 1075c4b:	cmp    %r10,%rbx
 1075c4e:	jb     1075ae0 <check_input_run+0x8dd0>
 1075c54:	mov    0x230(%r14),%edx
 1075c5b:	cmp    0x234(%r14),%edx
 1075c62:	jb     1075a9b <check_input_run+0x8d8b>
 1075c68:	movb   $0x1,0x3bd(%r14)
 1075c70:	jmp    1075ae0 <check_input_run+0x8dd0>
 1075c75:	mov    0x18(%rsp),%rax
 1075c7a:	cmpl   $0x0,0x230(%rax)
 1075c81:	movzbl 0x3bd(%rax),%eax
 1075c88:	jne    1075411 <check_input_run+0x8701>
 1075c8e:	xor    %ecx,%ecx
 1075c90:	mov    0x18(%rsp),%rdx
 1075c95:	mov    %cl,0x3bc(%rdx)
 1075c9b:	mov    0x38(%rsp),%rcx
 1075ca0:	test   %al,%al
 1075ca2:	je     1075ce8 <check_input_run+0x8fd8>
 1075ca4:	xor    %eax,%eax
 1075ca6:	mov    0x270(%rsp),%rdx
 1075cae:	cmp    0x8(%rcx),%rdx
 1075cb2:	ja     107a28f <check_input_run+0xd57f>
 1075cb8:	mov    %rdx,0x8(%rcx)
 1075cbc:	mov    %fs:0x28,%rcx
 1075cc5:	cmp    0x800(%rsp),%rcx
 1075ccd:	jne    107a2b1 <check_input_run+0xd5a1>
 1075cd3:	add    $0x808,%rsp
 1075cda:	pop    %rbx
 1075cdb:	pop    %r12
 1075cdd:	pop    %r13
 1075cdf:	pop    %r14
 1075ce1:	pop    %r15
 1075ce3:	pop    %rbp
 1075ce4:	vzeroupper
 1075ce7:	ret
 1075ce8:	mov    0x18(%rsp),%rdx
 1075ced:	xor    %eax,%eax
 1075cef:	cmpl   $0x0,0x230(%rdx)
 1075cf6:	jne    1075ca6 <check_input_run+0x8f96>
 1075cf8:	cmpb   $0x0,0x338(%rsp)
 1075d00:	je     1075ca6 <check_input_run+0x8f96>
 1075d02:	mov    0x18(%rsp),%rbx
 1075d07:	mov    0x38(%rsp),%rax
 1075d0c:	mov    0x5f0(%rsp),%r9
 1075d14:	mov    0xa8(%rsp),%r8
 1075d1c:	lea    0x2d0(%rsp),%rdx
 1075d24:	mov    %r12,%rsi
 1075d27:	mov    0x240(%rbx),%rcx
 1075d2e:	mov    %rax,0x8(%rsp)
 1075d33:	mov    0x10(%rsp),%rax
 1075d38:	lea    0x140(%rbx),%rdi
 1075d3f:	mov    %rax,(%rsp)
 1075d43:	vzeroupper
 1075d46:	call   108e670 <check_environment_publish>
 1075d4b:	mov    %eax,%ecx
 1075d4d:	xor    $0x1,%cl
 1075d50:	or     %cl,0x3bd(%rbx)
 1075d56:	jmp    106fe34 <check_input_run+0x3124>
 1075d5b:	mov    %rax,%rdx
 1075d5e:	sub    %rsi,%rdx
 1075d61:	mov    0x10(%rdi),%rsi
 1075d65:	xor    %ebp,%ebp
 1075d67:	sub    %rdx,%rsi
 1075d6a:	jb     1074a11 <check_input_run+0x7d01>
 1075d70:	mov    $0x0,%edi
 1075d75:	mov    %rdi,0x210(%rsp)
 1075d7d:	cmp    %r9,%rsi
 1075d80:	jbe    1074a1d <check_input_run+0x7d0d>
 1075d86:	mov    0x10(%rsp),%rdi
 1075d8b:	lea    0x1(%r9),%rsi
 1075d8f:	add    %rdx,%rsi
 1075d92:	mov    %rsi,0x8(%rdi)
 1075d96:	test   %rax,%rax
 1075d99:	je     1074a0f <check_input_run+0x7cff>
 1075d9f:	mov    (%rcx),%rdi
 1075da2:	mov    0x8(%rcx),%rdx
 1075da6:	lea    0x3f(%rdx,%rdi,1),%rbp
 1075dab:	add    %rdi,%rdx
 1075dae:	and    $0xffffffffffffffc0,%rbp
 1075db2:	cmp    %rdx,%rbp
 1075db5:	jae    1077843 <check_input_run+0xab33>
 1075dbb:	xor    %ebp,%ebp
 1075dbd:	mov    %rax,0x210(%rsp)
 1075dc5:	jmp    1074a1d <check_input_run+0x7d0d>
 1075dca:	mov    $0xff,%esi
 1075dcf:	mov    %r15,%rdi
 1075dd2:	mov    %r8,%r12
 1075dd5:	call   788120 <memset@plt>
 1075dda:	mov    %r13,%rdi
 1075ddd:	xor    %esi,%esi
 1075ddf:	mov    %r12,%rdx
 1075de2:	call   788120 <memset@plt>
 1075de7:	mov    %r13,0x98(%rsp)
 1075def:	test   %rbp,%rbp
 1075df2:	je     107923d <check_input_run+0xc52d>
 1075df8:	mov    %ebp,%ecx
 1075dfa:	lea    -0x1(%rbp),%rax
 1075dfe:	and    $0x3,%ecx
 1075e01:	cmp    $0x3,%rax
 1075e05:	jae    1077589 <check_input_run+0xa879>
 1075e0b:	mov    $0xffffffff,%esi
 1075e10:	xor    %edx,%edx
 1075e12:	jmp    1077788 <check_input_run+0xaa78>
 1075e17:	mov    0x58(%rsp),%rax
 1075e1c:	vbroadcasti32x4 -0xae6b56(%rip),%zmm0        # 58f2d0 <abi_test_hex.digits+0xb00>
 1075e26:	xor    %ecx,%ecx
 1075e28:	xor    %ebx,%ebx
 1075e2a:	mov    0xc38(%rax),%r10d
 1075e31:	add    $0x830,%rax
 1075e37:	mov    %rax,0x50(%rsp)
 1075e3c:	jmp    1075e5a <check_input_run+0x914a>
 1075e3e:	mov    0x58(%rsp),%rax
 1075e43:	mov    0x28(%rsp),%rbx
 1075e48:	mov    0xc38(%rax),%r10d
 1075e4f:	inc    %ebx
 1075e51:	cmp    %r10d,%ebx
 1075e54:	ja     1076174 <check_input_run+0x9464>
 1075e5a:	mov    $0x1,%r11b
 1075e5d:	test   %ebx,%ebx
 1075e5f:	je     1075e86 <check_input_run+0x9176>
 1075e61:	mov    0x58(%rsp),%rax
 1075e66:	mov    0xc30(%rax),%rdx
 1075e6d:	test   %rdx,%rdx
 1075e70:	je     1075e86 <check_input_run+0x9176>
 1075e72:	lea    -0x1(%rbx),%esi
 1075e75:	xor    %r11d,%r11d
 1075e78:	shl    $0x4,%rsi
 1075e7c:	mov    (%rdx,%rsi,1),%r8d
 1075e80:	lea    (%rdx,%rsi,1),%rax
 1075e84:	jmp    1075e8b <check_input_run+0x917b>
 1075e86:	xor    %eax,%eax
 1075e88:	xor    %r8d,%r8d
 1075e8b:	mov    0x50(%rsp),%r9
 1075e90:	cmp    %r10d,%ebx
 1075e93:	jae    1075ea8 <check_input_run+0x9198>
 1075e95:	mov    0x58(%rsp),%rdx
 1075e9a:	mov    %ebx,%r9d
 1075e9d:	shl    $0x4,%r9
 1075ea1:	add    0xc30(%rdx),%r9
 1075ea8:	test   %r11b,%r11b
 1075eab:	je     1075eb9 <check_input_run+0x91a9>
 1075ead:	vpxor  %xmm1,%xmm1,%xmm1
 1075eb1:	xor    %eax,%eax
 1075eb3:	vpxor  %xmm2,%xmm2,%xmm2
 1075eb7:	jmp    1075f05 <check_input_run+0x91f5>
 1075eb9:	mov    0x4(%rax),%edx
 1075ebc:	mov    0x58(%rsp),%rsi
 1075ec1:	vpxor  %xmm1,%xmm1,%xmm1
 1075ec5:	vpxor  %xmm2,%xmm2,%xmm2
 1075ec9:	cmp    0xc18(%rsi),%edx
 1075ecf:	jae    1075f01 <check_input_run+0x91f1>
 1075ed1:	mov    0x58(%rsp),%rdi
 1075ed6:	imul   $0x38,%rdx,%rdx
 1075eda:	mov    0x8(%rax),%esi
 1075edd:	mov    0xc10(%rdi),%r11
 1075ee4:	mov    %rbx,%rdi
 1075ee7:	vpbroadcastd %esi,%zmm2
 1075eed:	mov    (%r11,%rdx,1),%ebx
 1075ef1:	sub    %esi,%ebx
 1075ef3:	add    0x4(%r11,%rdx,1),%ebx
 1075ef8:	vpbroadcastd %ebx,%zmm1
 1075efe:	mov    %rdi,%rbx
 1075f01:	movzbl 0xc(%rax),%eax
 1075f05:	mov    (%r9),%r9d
 1075f08:	cmp    %r9d,%r8d
 1075f0b:	jae    1075e4f <check_input_run+0x913f>
 1075f11:	vpbroadcastb %eax,%zmm3
 1075f17:	mov    %rbx,0x28(%rsp)
 1075f1c:	jmp    1075f2d <check_input_run+0x921d>
 1075f1e:	xchg   %ax,%ax
 1075f20:	add    $0x40,%r8d
 1075f24:	cmp    %r9d,%r8d
 1075f27:	jae    1075e3e <check_input_run+0x912e>
 1075f2d:	mov    %r9d,%eax
 1075f30:	sub    %r8d,%eax
 1075f33:	mov    $0x40,%edx
 1075f38:	mov    %r8d,%r10d
 1075f3b:	cmp    $0x40,%eax
 1075f3e:	cmovae %edx,%eax
 1075f41:	mov    $0xffffffffffffffff,%rdx
 1075f48:	bzhi   %rax,%rdx,%rax
 1075f4d:	mov    0x58(%rsp),%rdx
 1075f52:	kmovq  %rax,%k1
 1075f57:	mov    %rax,%rsi
 1075f5a:	shr    $0x20,%rsi
 1075f5e:	mov    0x828(%rdx),%rbx
 1075f65:	mov    0x818(%rdx),%r11
 1075f6c:	mov    %eax,%edx
 1075f6e:	shr    $0x10,%edx
 1075f71:	kmovd  %edx,%k2
 1075f75:	vmovdqu32 0x40(%rbx,%r10,4),%zmm5{%k2}{z}
 1075f7d:	vmovdqu32 (%rbx,%r10,4),%zmm4{%k1}{z}
 1075f84:	kunpckwd %k1,%k2,%k2
 1075f88:	vpsubd %zmm2,%zmm5,%zmm5
 1075f8e:	vpsubd %zmm2,%zmm4,%zmm4
 1075f94:	vpcmpltud %zmm1,%zmm4,%k0
 1075f9b:	vpcmpltud %zmm1,%zmm5,%k3
 1075fa2:	kunpckwd %k0,%k3,%k0
 1075fa6:	kandd  %k2,%k0,%k0
 1075fab:	kmovd  %esi,%k2
 1075faf:	vmovdqu32 0x80(%rbx,%r10,4),%zmm4{%k2}{z}
 1075fb7:	kmovd  %k0,%edx
 1075fbb:	vpsubd %zmm2,%zmm4,%zmm4
 1075fc1:	vpcmpltud %zmm1,%zmm4,%k0{%k2}
 1075fc8:	kmovw  %k0,%esi
 1075fcc:	shl    $0x20,%rsi
 1075fd0:	or     %rdx,%rsi
 1075fd3:	mov    %rax,%rdx
 1075fd6:	shr    $0x30,%rdx
 1075fda:	kmovd  %edx,%k2
 1075fde:	vmovdqu32 0xc0(%rbx,%r10,4),%zmm4{%k2}{z}
 1075fe6:	vpsubd %zmm2,%zmm4,%zmm4
 1075fec:	vpcmpltud %zmm1,%zmm4,%k0{%k2}
 1075ff3:	vptestmb (%r11,%r10,1),%zmm0,%k2{%k1}
 1075ffa:	vmovdqu8 %zmm3,0x0(%rbp,%r10,1){%k1}
 1076002:	kmovd  %k0,%edx
 1076006:	movzwl %dx,%edx
 1076009:	shl    $0x30,%rdx
 107600d:	or     %rsi,%rdx
 1076010:	kmovq  %k2,%rsi
 1076015:	or     %rdx,%rsi
 1076018:	andn   %rax,%rsi,%r10
 107601d:	jne    1076048 <check_input_run+0x9338>
 107601f:	jmp    1075f20 <check_input_run+0x9210>
 1076024:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1076030:	xor    %r12d,%r12d
 1076033:	mov    %r12b,0x0(%rbp,%r11,1)
 1076038:	mov    0x20(%rsp),%r12
 107603d:	blsr   %r10,%r10
 1076042:	je     1075f20 <check_input_run+0x9210>
 1076048:	mov    0x58(%rsp),%rdx
 107604d:	xor    %r11d,%r11d
 1076050:	tzcnt  %r10,%r11
 1076055:	add    %r8d,%r11d
 1076058:	mov    0x828(%rdx),%rax
 107605f:	mov    (%rax,%r11,4),%eax
 1076063:	test   %eax,%eax
 1076065:	je     1076030 <check_input_run+0x9320>
 1076067:	mov    0xc18(%rdx),%r13d
 107606e:	cmp    $0x2,%r13d
 1076072:	jb     10760c0 <check_input_run+0x93b0>
 1076074:	mov    0xc10(%rdx),%r15
 107607b:	xor    %r12d,%r12d
 107607e:	mov    %r13d,%edx
 1076081:	mov    %r13d,%ebx
 1076084:	jmp    107609d <check_input_run+0x938d>
 1076086:	cs nopw 0x0(%rax,%rax,1)
 1076090:	mov    %edx,%r12d
 1076093:	mov    %ebx,%edx
 1076095:	sub    %r12d,%edx
 1076098:	cmp    $0x1,%edx
 107609b:	jbe    10760d8 <check_input_run+0x93c8>
 107609d:	shr    $1,%edx
 107609f:	add    %r12d,%edx
 10760a2:	imul   $0x38,%rdx,%rsi
 10760a6:	cmp    %eax,(%r15,%rsi,1)
 10760aa:	jbe    1076090 <check_input_run+0x9380>
 10760ac:	mov    %edx,%ebx
 10760ae:	mov    %ebx,%edx
 10760b0:	sub    %r12d,%edx
 10760b3:	cmp    $0x1,%edx
 10760b6:	ja     107609d <check_input_run+0x938d>
 10760b8:	jmp    10760d8 <check_input_run+0x93c8>
 10760ba:	nopw   0x0(%rax,%rax,1)
 10760c0:	xor    %r12d,%r12d
 10760c3:	test   %r13d,%r13d
 10760c6:	je     1076033 <check_input_run+0x9323>
 10760cc:	mov    0x58(%rsp),%rdx
 10760d1:	mov    0xc10(%rdx),%r15
 10760d8:	mov    %r12d,%edx
 10760db:	imul   $0x38,%rdx,%rdx
 10760df:	mov    %eax,%esi
 10760e1:	sub    (%r15,%rdx,1),%esi
 10760e5:	jb     1076030 <check_input_run+0x9320>
 10760eb:	add    %r15,%rdx
 10760ee:	cmp    0x4(%rdx),%esi
 10760f1:	mov    $0xffffffff,%edx
 10760f6:	cmovb  %r12d,%edx
 10760fa:	cmp    %r13d,%edx
 10760fd:	jae    107615f <check_input_run+0x944f>
 10760ff:	mov    %edx,%edx
 1076101:	imul   $0x38,%rdx,%rdx
 1076105:	movzbl 0x28(%r15,%rdx,1),%ebx
 107610b:	mov    0x20(%r15,%rdx,1),%esi
 1076110:	mov    0x58(%rsp),%rdx
 1076115:	mov    0xc28(%rdx),%r15d
 107611c:	cmp    %r15d,%esi
 107611f:	jae    1076164 <check_input_run+0x9454>
 1076121:	mov    0xc20(%rdx),%rdx
 1076128:	lea    (%rsi,%rsi,4),%rsi
 107612c:	cmp    %eax,0x4(%rdx,%rsi,8)
 1076130:	ja     1076164 <check_input_run+0x9454>
 1076132:	lea    (%rdx,%rsi,8),%rbx
 1076136:	cs nopw 0x0(%rax,%rax,1)
 1076140:	mov    %rbx,%rsi
 1076143:	mov    0x1c(%rbx),%ebx
 1076146:	cmp    %r15d,%ebx
 1076149:	jae    1076159 <check_input_run+0x9449>
 107614b:	lea    (%rbx,%rbx,4),%rdi
 107614f:	lea    (%rdx,%rdi,8),%rbx
 1076153:	cmp    %eax,0x4(%rdx,%rdi,8)
 1076157:	jbe    1076140 <check_input_run+0x9430>
 1076159:	movzbl 0x20(%rsi),%ebx
 107615d:	jmp    1076164 <check_input_run+0x9454>
 107615f:	xor    %ebx,%ebx
 1076161:	mov    %edx,%r12d
 1076164:	cmp    %r13d,%r12d
 1076167:	movzbl %bl,%r12d
 107616b:	cmovae %ecx,%r12d
 107616f:	jmp    1076033 <check_input_run+0x9323>
 1076174:	mov    0x1b0(%rsp),%r8
 107617c:	test   %r8d,%r8d
 107617f:	je     10761a4 <check_input_run+0x9494>
 1076181:	mov    0x210(%rsp),%r10
 1076189:	mov    %r8d,%eax
 107618c:	and    $0x7,%eax
 107618f:	cmp    $0x8,%r8d
 1076193:	jae    10761b3 <check_input_run+0x94a3>
 1076195:	mov    0xd0(%rsp),%r9
 107619d:	xor    %ecx,%ecx
 107619f:	jmp    1076359 <check_input_run+0x9649>
 10761a4:	mov    0x210(%rsp),%r10
 10761ac:	xor    %eax,%eax
 10761ae:	jmp    1076399 <check_input_run+0x9689>
 10761b3:	mov    0xd0(%rsp),%r9
 10761bb:	mov    %r8d,%edx
 10761be:	and    $0xfffffff8,%edx
 10761c1:	xor    %ecx,%ecx
 10761c3:	jmp    10761e7 <check_input_run+0x94d7>
 10761c5:	movzbl 0x0(%rbp,%rsi,1),%esi
 10761ca:	dec    %sil
 10761cd:	cmp    $0x2,%sil
 10761d1:	setb   %sil
 10761d5:	mov    %sil,0x7(%r10,%rcx,1)
 10761da:	add    $0x8,%rcx
 10761de:	cmp    %rcx,%rdx
 10761e1:	je     1076354 <check_input_run+0x9644>
 10761e7:	mov    0x20(%r9),%rsi
 10761eb:	mov    0x58(%rsp),%rdi
 10761f0:	mov    (%rsi,%rcx,4),%esi
 10761f3:	cmp    0x830(%rdi),%esi
 10761f9:	jae    107620d <check_input_run+0x94fd>
 10761fb:	movzbl 0x0(%rbp,%rsi,1),%esi
 1076200:	dec    %sil
 1076203:	cmp    $0x2,%sil
 1076207:	setb   %sil
 107620b:	jmp    107620f <check_input_run+0x94ff>
 107620d:	xor    %esi,%esi
 107620f:	mov    %sil,(%r10,%rcx,1)
 1076213:	mov    0x58(%rsp),%rdi
 1076218:	mov    0x20(%r9),%rsi
 107621c:	mov    0x4(%rsi,%rcx,4),%esi
 1076220:	cmp    0x830(%rdi),%esi
 1076226:	jae    107623a <check_input_run+0x952a>
 1076228:	movzbl 0x0(%rbp,%rsi,1),%esi
 107622d:	dec    %sil
 1076230:	cmp    $0x2,%sil
 1076234:	setb   %sil
 1076238:	jmp    107623c <check_input_run+0x952c>
 107623a:	xor    %esi,%esi
 107623c:	mov    %sil,0x1(%r10,%rcx,1)
 1076241:	mov    0x58(%rsp),%rdi
 1076246:	mov    0x20(%r9),%rsi
 107624a:	mov    0x8(%rsi,%rcx,4),%esi
 107624e:	cmp    0x830(%rdi),%esi
 1076254:	jae    1076268 <check_input_run+0x9558>
 1076256:	movzbl 0x0(%rbp,%rsi,1),%esi
 107625b:	dec    %sil
 107625e:	cmp    $0x2,%sil
 1076262:	setb   %sil
 1076266:	jmp    107626a <check_input_run+0x955a>
 1076268:	xor    %esi,%esi
 107626a:	mov    %sil,0x2(%r10,%rcx,1)
 107626f:	mov    0x58(%rsp),%rdi
 1076274:	mov    0x20(%r9),%rsi
 1076278:	mov    0xc(%rsi,%rcx,4),%esi
 107627c:	cmp    0x830(%rdi),%esi
 1076282:	jae    1076296 <check_input_run+0x9586>
 1076284:	movzbl 0x0(%rbp,%rsi,1),%esi
 1076289:	dec    %sil
 107628c:	cmp    $0x2,%sil
 1076290:	setb   %sil
 1076294:	jmp    1076298 <check_input_run+0x9588>
 1076296:	xor    %esi,%esi
 1076298:	mov    %sil,0x3(%r10,%rcx,1)
 107629d:	mov    0x58(%rsp),%rdi
 10762a2:	mov    0x20(%r9),%rsi
 10762a6:	mov    0x10(%rsi,%rcx,4),%esi
 10762aa:	cmp    0x830(%rdi),%esi
 10762b0:	jae    10762c4 <check_input_run+0x95b4>
 10762b2:	movzbl 0x0(%rbp,%rsi,1),%esi
 10762b7:	dec    %sil
 10762ba:	cmp    $0x2,%sil
 10762be:	setb   %sil
 10762c2:	jmp    10762c6 <check_input_run+0x95b6>
 10762c4:	xor    %esi,%esi
 10762c6:	mov    %sil,0x4(%r10,%rcx,1)
 10762cb:	mov    0x58(%rsp),%rdi
 10762d0:	mov    0x20(%r9),%rsi
 10762d4:	mov    0x14(%rsi,%rcx,4),%esi
 10762d8:	cmp    0x830(%rdi),%esi
 10762de:	jae    10762f2 <check_input_run+0x95e2>
 10762e0:	movzbl 0x0(%rbp,%rsi,1),%esi
 10762e5:	dec    %sil
 10762e8:	cmp    $0x2,%sil
 10762ec:	setb   %sil
 10762f0:	jmp    10762f4 <check_input_run+0x95e4>
 10762f2:	xor    %esi,%esi
 10762f4:	mov    %sil,0x5(%r10,%rcx,1)
 10762f9:	mov    0x58(%rsp),%rdi
 10762fe:	mov    0x20(%r9),%rsi
 1076302:	mov    0x18(%rsi,%rcx,4),%esi
 1076306:	cmp    0x830(%rdi),%esi
 107630c:	jae    1076320 <check_input_run+0x9610>
 107630e:	movzbl 0x0(%rbp,%rsi,1),%esi
 1076313:	dec    %sil
 1076316:	cmp    $0x2,%sil
 107631a:	setb   %sil
 107631e:	jmp    1076322 <check_input_run+0x9612>
 1076320:	xor    %esi,%esi
 1076322:	mov    %sil,0x6(%r10,%rcx,1)
 1076327:	mov    0x58(%rsp),%rdi
 107632c:	mov    0x20(%r9),%rsi
 1076330:	mov    0x1c(%rsi,%rcx,4),%esi
 1076334:	cmp    0x830(%rdi),%esi
 107633a:	jb     10761c5 <check_input_run+0x94b5>
 1076340:	xor    %esi,%esi
 1076342:	mov    %sil,0x7(%r10,%rcx,1)
 1076347:	add    $0x8,%rcx
 107634b:	cmp    %rcx,%rdx
 107634e:	jne    10761e7 <check_input_run+0x94d7>
 1076354:	test   %rax,%rax
 1076357:	je     1076396 <check_input_run+0x9686>
 1076359:	mov    0x58(%rsp),%rsi
 107635e:	jmp    1076379 <check_input_run+0x9669>
 1076360:	movzbl 0x0(%rbp,%rdx,1),%edx
 1076365:	dec    %dl
 1076367:	cmp    $0x2,%dl
 107636a:	setb   %dl
 107636d:	mov    %dl,(%r10,%rcx,1)
 1076371:	inc    %rcx
 1076374:	dec    %rax
 1076377:	je     1076396 <check_input_run+0x9686>
 1076379:	mov    0x20(%r9),%rdx
 107637d:	mov    (%rdx,%rcx,4),%edx
 1076380:	cmp    0x830(%rsi),%edx
 1076386:	jb     1076360 <check_input_run+0x9650>
 1076388:	xor    %edx,%edx
 107638a:	mov    %dl,(%r10,%rcx,1)
 107638e:	inc    %rcx
 1076391:	dec    %rax
 1076394:	jne    1076379 <check_input_run+0x9669>
 1076396:	mov    %r8,%rax
 1076399:	movb   $0x0,(%r10,%rax,1)
 107639e:	mov    %r10,0x58(%r14)
 10763a2:	mov    %r8d,0x60(%r14)
 10763a6:	mov    0x130(%rsp),%r8
 10763ae:	mov    0x2c8(%rsp),%rax
 10763b6:	cmp    0x8(%rax),%r8
 10763ba:	ja     107a28f <check_input_run+0xd57f>
 10763c0:	mov    %r8,0x8(%rax)
 10763c4:	mov    0x2a8(%rsp),%rbx
 10763cc:	mov    0x30(%rbx),%eax
 10763cf:	cmp    $0x3,%eax
 10763d2:	jb     107644a <check_input_run+0x973a>
 10763d4:	mov    $0xfffffffd,%ebp
 10763d9:	xor    %r14d,%r14d
 10763dc:	jmp    10763f4 <check_input_run+0x96e4>
 10763de:	xchg   %ax,%ax
 10763e0:	lea    0x1(%r14),%rdx
 10763e4:	dec    %ebp
 10763e6:	add    $0x3,%r14
 10763ea:	mov    %eax,%ecx
 10763ec:	cmp    %rcx,%r14
 10763ef:	mov    %rdx,%r14
 10763f2:	jae    107644a <check_input_run+0x973a>
 10763f4:	mov    0x10(%rbx),%rcx
 10763f8:	cmpb   $0x3c,(%rcx,%r14,1)
 10763fd:	jne    10763e0 <check_input_run+0x96d0>
 10763ff:	mov    0x50(%rbx),%rcx
 1076403:	cmpb   $0x2a,0x1(%rcx,%r14,1)
 1076409:	jne    10763e0 <check_input_run+0x96d0>
 107640b:	cmpb   $0x2d,0x2(%rcx,%r14,1)
 1076411:	jne    10763e0 <check_input_run+0x96d0>
 1076413:	mov    0x60(%rbx),%rcx
 1076417:	mov    0x8(%rcx,%r14,4),%edx
 107641c:	cmp    %eax,%edx
 107641e:	jae    10763e0 <check_input_run+0x96d0>
 1076420:	lea    0x2(%r14),%rcx
 1076424:	cmp    %rdx,%rcx
 1076427:	jae    10763e0 <check_input_run+0x96d0>
 1076429:	mov    0x3d8(%rsp),%rax
 1076431:	add    %ebp,%edx
 1076433:	mov    $0x1,%esi
 1076438:	lea    0x3(%rax,%r14,1),%rdi
 107643d:	vzeroupper
 1076440:	call   788120 <memset@plt>
 1076445:	mov    0x30(%rbx),%eax
 1076448:	jmp    10763e0 <check_input_run+0x96d0>
 107644a:	lea    0x2a0(%rsp),%rbx
 1076452:	mov    0xf0(%rsp),%rdx
 107645a:	xor    %esi,%esi
 107645c:	mov    %rbx,%rdi
 107645f:	vzeroupper
 1076462:	call   10826a0 <check_input_resolve_range>
 1076467:	mov    0x860(%rsp),%rdx
 107646f:	test   %rdx,%rdx
 1076472:	je     1077d51 <check_input_run+0xb041>
 1076478:	mov    0x2a0(%rsp),%rsi
 1076480:	movq   $0x0,0x118(%rdx)
 107648b:	lea    -0xa41327(%rip),%rcx        # 63516b <foreign_touch.flags+0x33115>
 1076492:	mov    %rdx,%r12
 1076495:	cmpb   $0x0,0x2aa58(%rdx)
 107649c:	mov    0x230(%rsi),%eax
 10764a2:	je     10764b3 <check_input_run+0x97a3>
 10764a4:	xor    %ebp,%ebp
 10764a6:	test   %eax,%eax
 10764a8:	jne    1076505 <check_input_run+0x97f5>
 10764aa:	lea    -0x9cf074(%rip),%rax        # 6a743d <pp_string_value.meaning+0x1eebc>
 10764b1:	jmp    10764f2 <check_input_run+0x97e2>
 10764b3:	test   %eax,%eax
 10764b5:	je     10764bb <check_input_run+0x97ab>
 10764b7:	xor    %ebp,%ebp
 10764b9:	jmp    1076505 <check_input_run+0x97f5>
 10764bb:	xor    %ebp,%ebp
 10764bd:	cmpb   $0x0,0x3bd(%rsi)
 10764c4:	lea    -0x9cf08e(%rip),%rax        # 6a743d <pp_string_value.meaning+0x1eebc>
 10764cb:	jne    10764f2 <check_input_run+0x97e2>
 10764cd:	cmpb   $0x0,0x338(%rsp)
 10764d5:	je     10764f2 <check_input_run+0x97e2>
 10764d7:	cmpb   $0x0,0x174(%r12)
 10764e0:	jne    10764f0 <check_input_run+0x97e0>
 10764e2:	cmpq   $0x0,0x220(%rsi)
 10764ea:	je     10786ed <check_input_run+0xb9dd>
 10764f0:	xor    %ebp,%ebp
 10764f2:	cmpq   $0x0,0x220(%rsi)
 10764fa:	lea    -0x9e5848(%rip),%rcx        # 690cb9 <pp_string_value.meaning+0x8738>
 1076501:	cmove  %rax,%rcx
 1076505:	mov    %rcx,0x2aa60(%r12)
 107650d:	mov    %rbx,0x1f0(%r12)
 1076515:	mov    %rsi,0x98(%rsp)
 107651d:	cmpb   $0x1,0x2aa90(%r12)
 1076526:	jne    1076575 <check_input_run+0x9865>
 1076528:	lea    0x780(%rsp),%rsi
 1076530:	mov    $0x1,%edi
 1076535:	vpxor  %xmm0,%xmm0,%xmm0
 1076539:	vmovdqa %xmm0,0x780(%rsp)
 1076542:	call   7878b0 <clock_gettime@plt>
 1076547:	imul   $0x3b9aca00,0x780(%rsp),%r14
 1076553:	add    0x788(%rsp),%r14
 107655b:	cmpb   $0x1,0x2aa90(%r12)
 1076564:	jne    1076578 <check_input_run+0x9868>
 1076566:	mov    %r14,%rcx
 1076569:	sub    0x2aab0(%r12),%rcx
 1076571:	mov    $0x1,%al
 1076573:	jmp    107657c <check_input_run+0x986c>
 1076575:	xor    %r14d,%r14d
 1076578:	xor    %eax,%eax
 107657a:	xor    %ecx,%ecx
 107657c:	mov    %rcx,0x2aab0(%r12)
 1076584:	test   %bpl,%bpl
 1076587:	je     10765bb <check_input_run+0x98ab>
 1076589:	mov    0x2c8(%rsp),%rcx
 1076591:	lea    0x1f8(%r12),%rdi
 1076599:	lea    0x2aa38(%r12),%rdx
 10765a1:	lea    0x2d0(%rsp),%rsi
 10765a9:	call   10f1f40 <c_environment_build>
 10765ae:	mov    %eax,%ebx
 10765b0:	movzbl 0x2aa90(%r12),%eax
 10765b9:	jmp    10765bd <check_input_run+0x98ad>
 10765bb:	xor    %ebx,%ebx
 10765bd:	test   %al,%al
 10765bf:	je     10765f6 <check_input_run+0x98e6>
 10765c1:	lea    0x780(%rsp),%rsi
 10765c9:	mov    $0x1,%edi
 10765ce:	vpxor  %xmm0,%xmm0,%xmm0
 10765d2:	vmovdqa %xmm0,0x780(%rsp)
 10765db:	call   7878b0 <clock_gettime@plt>
 10765e0:	imul   $0x3b9aca00,0x780(%rsp),%rax
 10765ec:	add    0x788(%rsp),%rax
 10765f4:	jmp    10765f8 <check_input_run+0x98e8>
 10765f6:	xor    %eax,%eax
 10765f8:	sub    %r14,%rax
 10765fb:	mov    %rax,0x2aab8(%r12)
 1076603:	test   %bl,%bl
 1076605:	je     1076718 <check_input_run+0x9a08>
 107660b:	mov    0x2aa38(%r12),%rdx
 1076613:	mov    0x2aa40(%r12),%rcx
 107661b:	lea    0x3(%rcx,%rdx,1),%rax
 1076620:	add    %rdx,%rcx
 1076623:	and    $0xfffffffffffffffc,%rax
 1076627:	cmp    %rcx,%rax
 107662a:	jb     1076718 <check_input_run+0x9a08>
 1076630:	mov    0x2aa48(%r12),%rsi
 1076638:	mov    %rax,%rdi
 107663b:	sub    %rdx,%rdi
 107663e:	mov    %rsi,%r9
 1076641:	sub    %rdi,%r9
 1076644:	jb     1076718 <check_input_run+0x9a08>
 107664a:	mov    0x130(%r12),%ecx
 1076652:	lea    0x4(,%rcx,4),%r8
 107665a:	cmp    %r9,%r8
 107665d:	ja     1076718 <check_input_run+0x9a08>
 1076663:	add    %r8,%rdi
 1076666:	mov    %rdi,0x2aa40(%r12)
 107666e:	mov    %rax,0x1b8(%r12)
 1076676:	test   %rax,%rax
 1076679:	je     1076724 <check_input_run+0x9a14>
 107667f:	add    %r8,%rax
 1076682:	mov    %rax,%rdi
 1076685:	sub    %rdx,%rdi
 1076688:	sub    %rdi,%rsi
 107668b:	jb     1076724 <check_input_run+0x9a14>
 1076691:	mov    0xb0(%r12),%edx
 1076699:	lea    0x4(,%rdx,4),%r8
 10766a1:	cmp    %rsi,%r8
 10766a4:	ja     1076724 <check_input_run+0x9a14>
 10766a6:	lea    0xb0(%r12),%rsi
 10766ae:	add    %rdi,%r8
 10766b1:	mov    %r8,0x2aa40(%r12)
 10766b9:	mov    %rsi,0xd0(%rsp)
 10766c1:	mov    %rax,0x1c8(%r12)
 10766c9:	test   %rax,%rax
 10766cc:	je     1077925 <check_input_run+0xac15>
 10766d2:	test   %edx,%edx
 10766d4:	je     10766ff <check_input_run+0x99ef>
 10766d6:	xor    %eax,%eax
 10766d8:	mov    0x1c8(%r12),%rcx
 10766e0:	movl   $0xffffffff,(%rcx,%rax,4)
 10766e7:	inc    %rax
 10766ea:	mov    0xb0(%r12),%ecx
 10766f2:	cmp    %rcx,%rax
 10766f5:	jb     10766d8 <check_input_run+0x99c8>
 10766f7:	mov    0x130(%r12),%ecx
 10766ff:	test   %ecx,%ecx
 1076701:	je     1077879 <check_input_run+0xab69>
 1076707:	mov    0x1c0(%r12),%edx
 107670f:	xor    %eax,%eax
 1076711:	xor    %ecx,%ecx
 1076713:	jmp    10768fc <check_input_run+0x9bec>
 1076718:	movq   $0x0,0x1b8(%r12)
 1076724:	lea    0xb0(%r12),%rax
 107672c:	movq   $0x0,0x1c8(%r12)
 1076738:	movq   $0x0,0x2a828(%r12)
 1076744:	movq   $0x0,0x2a830(%r12)
 1076750:	mov    %rax,0xd0(%rsp)
 1076758:	lea    0x1d8(%r12),%r15
 1076760:	movq   $0x0,0x1d8(%r12)
 107676c:	lea    0x1e0(%r12),%rax
 1076774:	xor    %ebp,%ebp
 1076776:	mov    %rax,0x28(%rsp)
 107677b:	xor    %eax,%eax
 107677d:	mov    %r12,0x278(%rsp)
 1076785:	mov    $0xffffffffffffffff,%rcx
 107678c:	cmpb   $0x0,0x2aaa0(%r12)
 1076795:	jne    10767c1 <check_input_run+0x9ab1>
 1076797:	mov    0x1e8(%r12),%ecx
 107679f:	xor    %edx,%edx
 10767a1:	add    %rcx,%rcx
 10767a4:	sub    %rcx,%rax
 10767a7:	movabs $0xaaaaaaaaaaaaaaab,%rcx
 10767b1:	cmovae %rax,%rdx
 10767b5:	mulx   %rcx,%rcx,%rcx
 10767ba:	shr    $0xd,%rcx
 10767be:	inc    %rcx
 10767c1:	mov    (%r12),%eax
 10767c5:	mov    0x1e0(%r12),%ebx
 10767cd:	cmp    %ebx,%eax
 10767cf:	cmovb  %eax,%ebx
 10767d2:	cmp    %rbx,%rcx
 10767d5:	cmovb  %rcx,%rbx
 10767d9:	cmpb   $0x1,0x2aa90(%r12)
 10767e2:	jne    107681c <check_input_run+0x9b0c>
 10767e4:	lea    0x780(%rsp),%rsi
 10767ec:	mov    $0x1,%edi
 10767f1:	vpxor  %xmm0,%xmm0,%xmm0
 10767f5:	vmovdqa %xmm0,0x780(%rsp)
 10767fe:	vzeroupper
 1076801:	call   7878b0 <clock_gettime@plt>
 1076806:	imul   $0x3b9aca00,0x780(%rsp),%r13
 1076812:	add    0x788(%rsp),%r13
 107681a:	jmp    107681f <check_input_run+0x9b0f>
 107681c:	xor    %r13d,%r13d
 107681f:	lea    0x2aa60(%r12),%r14
 1076827:	test   %bpl,%bpl
 107682a:	je     107685f <check_input_run+0x9b4f>
 107682c:	mov    0x28(%rsp),%rax
 1076831:	cmpl   $0x0,(%rax)
 1076834:	je     107685f <check_input_run+0x9b4f>
 1076836:	mov    0x2aa98(%r12),%rcx
 107683e:	lea    0x7c4ab(%rip),%rsi        # 10f2cf0 <check_deferred_lane>
 1076845:	lea    0x278(%rsp),%rdx
 107684d:	mov    %ebx,%edi
 107684f:	vzeroupper
 1076852:	call   10f2580 <lane_run>
 1076857:	test   %al,%al
 1076859:	je     1076930 <check_input_run+0x9c20>
 107685f:	mov    (%r14),%rax
 1076862:	mov    %rax,0x2aa60(%r12)
 107686a:	mov    %rbp,0x90(%rsp)
 1076872:	cmpb   $0x1,0x2aa90(%r12)
 107687b:	jne    1076958 <check_input_run+0x9c48>
 1076881:	lea    0x780(%rsp),%rsi
 1076889:	mov    $0x1,%edi
 107688e:	vpxor  %xmm0,%xmm0,%xmm0
 1076892:	vmovdqa %xmm0,0x780(%rsp)
 107689b:	vzeroupper
 107689e:	call   7878b0 <clock_gettime@plt>
 10768a3:	imul   $0x3b9aca00,0x780(%rsp),%rcx
 10768af:	mov    0x788(%rsp),%rax
 10768b7:	sub    %r13,%rax
 10768ba:	add    %rcx,%rax
 10768bd:	jmp    107695a <check_input_run+0x9c4a>
 10768c2:	mov    0x1b8(%r12),%rdi
 10768ca:	mov    %edx,%edx
 10768cc:	mov    %r8b,%sil
 10768cf:	add    $0x38,%rax
 10768d3:	mov    %ecx,(%rdi,%rdx,4)
 10768d6:	inc    %rcx
 10768d9:	add    0x1c0(%r12),%esi
 10768e1:	mov    %esi,0x1c0(%r12)
 10768e9:	mov    %esi,%edx
 10768eb:	mov    0x130(%r12),%edi
 10768f3:	cmp    %rdi,%rcx
 10768f6:	jae    1077879 <check_input_run+0xab69>
 10768fc:	mov    0x128(%r12),%rdi
 1076904:	xor    %esi,%esi
 1076906:	movzbl 0x8(%rdi,%rax,1),%r9d
 107690c:	lea    -0x4(%r9),%r8d
 1076910:	cmp    $0x3,%r8b
 1076914:	setb   %r8b
 1076918:	cmp    $0x6,%r9b
 107691c:	jne    10768c2 <check_input_run+0x9bb2>
 107691e:	mov    0x1c8(%r12),%r9
 1076926:	mov    0x2c(%rdi,%rax,1),%edi
 107692a:	mov    %edx,(%r9,%rdi,4)
 107692e:	jmp    10768c2 <check_input_run+0x9bb2>
 1076930:	lea    -0xa417ad(%rip),%rax        # 63518a <foreign_touch.flags+0x33134>
 1076937:	xor    %ebp,%ebp
 1076939:	mov    %rax,0x2aa60(%r12)
 1076941:	mov    %rbp,0x90(%rsp)
 1076949:	cmpb   $0x1,0x2aa90(%r12)
 1076952:	je     1076881 <check_input_run+0x9b71>
 1076958:	xor    %eax,%eax
 107695a:	mov    %rax,0x2aac0(%r12)
 1076962:	mov    %r15,0x1b0(%rsp)
 107696a:	mov    %r14,0x50(%rsp)
 107696f:	mov    0xcb8(%r12),%rbp
 1076977:	mov    (%r12),%edx
 107697b:	mov    %rbp,%rax
 107697e:	test   %edx,%edx
 1076980:	je     1077344 <check_input_run+0xa634>
 1076986:	mov    %r12,%rax
 1076989:	mov    0x2aa68(%r12),%r15
 1076991:	mov    0x2aa70(%r12),%r12
 1076999:	mov    0x2aa78(%rax),%rbx
 10769a0:	mov    0x2aa80(%rax),%r11
 10769a7:	mov    0x2aa88(%rax),%r10
 10769ae:	mov    0x2aad8(%rax),%r9
 10769b5:	mov    0x2aad0(%rax),%r8
 10769bc:	mov    0x2aae0(%rax),%rdi
 10769c3:	cmp    $0x40,%edx
 10769c6:	mov    $0x40,%ecx
 10769cb:	cmovb  %edx,%ecx
 10769ce:	cmp    $0x8,%edx
 10769d1:	jae    10769de <check_input_run+0x9cce>
 10769d3:	xor    %r14d,%r14d
 10769d6:	mov    %rbp,%rax
 10769d9:	jmp    107729e <check_input_run+0xa58e>
 10769de:	lea    0x228(%rax),%rsi
 10769e5:	vpbroadcastq %rsi,%zmm0
 10769eb:	cmp    $0x10,%edx
 10769ee:	jae    10769fb <check_input_run+0x9ceb>
 10769f0:	xor    %r14d,%r14d
 10769f3:	mov    %rbp,%rax
 10769f6:	jmp    1076f5e <check_input_run+0xa24e>
 10769fb:	vmovdqa64 -0xbd9485(%rip),%zmm19        # 49d580 <cbuiltin_test_generated.edges+0x3740>
 1076a05:	vpbroadcastq -0xaca65f(%rip),%zmm20        # 5ac3b0 <check_mutation_families+0x190>
 1076a0f:	vpbroadcastq -0xaca661(%rip),%zmm21        # 5ac3b8 <check_mutation_families+0x198>
 1076a19:	vpbroadcastq -0xaca663(%rip),%zmm22        # 5ac3c0 <check_mutation_families+0x1a0>
 1076a23:	mov    %ecx,%r14d
 1076a26:	vpbroadcastq %rbp,%zmm1
 1076a2c:	and    $0x70,%r14d
 1076a30:	vmovq  %rdi,%xmm15
 1076a35:	vmovq  %r8,%xmm13
 1076a3a:	vmovq  %r9,%xmm11
 1076a3f:	vmovq  %r10,%xmm9
 1076a44:	vmovq  %r11,%xmm7
 1076a49:	vmovq  %rbx,%xmm5
 1076a4e:	vmovq  %r12,%xmm3
 1076a53:	vmovq  %r15,%xmm2
 1076a58:	vpxord %xmm17,%xmm17,%xmm17
 1076a5e:	vpxord %xmm18,%xmm18,%xmm18
 1076a64:	vpxord %xmm16,%xmm16,%xmm16
 1076a6a:	vpxor  %xmm14,%xmm14,%xmm14
 1076a6f:	vpxor  %xmm12,%xmm12,%xmm12
 1076a74:	vpxor  %xmm10,%xmm10,%xmm10
 1076a79:	vpxor  %xmm8,%xmm8,%xmm8
 1076a7e:	vpxor  %xmm6,%xmm6,%xmm6
 1076a82:	mov    %r14,%rdi
 1076a85:	vmovdqa64 %zmm1,%zmm4
 1076a8b:	vpmullq %zmm20,%zmm19,%zmm23
 1076a91:	kxnorb %k0,%k0,%k1
 1076a95:	vpaddq %zmm22,%zmm19,%zmm19
 1076a9b:	add    $0xfffffffffffffff0,%rdi
 1076a9f:	vpaddq %zmm23,%zmm0,%zmm25
 1076aa5:	vmovq  %xmm25,%rdx
 1076aab:	vpextrq $0x1,%xmm25,%rax
 1076ab2:	vextracti32x4 $0x1,%ymm25,%xmm26
 1076ab9:	vpaddq %zmm21,%zmm25,%zmm24
 1076abf:	vmovd  0x9d8(%rdx),%xmm27
 1076ac9:	vpextrq $0x1,%xmm26,%rdx
 1076ad0:	vmovq  %xmm24,%r8
 1076ad6:	vpinsrb $0x1,0x9d8(%rax),%xmm27,%xmm27
 1076ae1:	vmovq  %xmm26,%rax
 1076ae7:	vextracti32x4 $0x2,%zmm25,%xmm26
 1076aee:	vextracti32x4 $0x3,%zmm25,%xmm25
 1076af5:	vpinsrb $0x2,0x9d8(%rax),%xmm27,%xmm27
 1076b00:	vpextrq $0x1,%xmm26,%rax
 1076b07:	vpinsrb $0x3,0x9d8(%rdx),%xmm27,%xmm27
 1076b12:	vmovq  %xmm26,%rdx
 1076b18:	vpinsrb $0x4,0x9d8(%rdx),%xmm27,%xmm26
 1076b23:	vpextrq $0x1,%xmm25,%rdx
 1076b2a:	vmovd  0x9d8(%r8),%xmm27
 1076b34:	vpinsrb $0x5,0x9d8(%rax),%xmm26,%xmm26
 1076b3f:	vmovq  %xmm25,%rax
 1076b45:	vpinsrb $0x6,0x9d8(%rax),%xmm26,%xmm25
 1076b50:	vextracti32x4 $0x1,%ymm24,%xmm26
 1076b57:	vmovq  %xmm26,%rax
 1076b5d:	vpinsrb $0x7,0x9d8(%rdx),%xmm25,%xmm25
 1076b68:	vpextrq $0x1,%xmm24,%rdx
 1076b6f:	vpinsrb $0x1,0x9d8(%rdx),%xmm27,%xmm27
 1076b7a:	vpextrq $0x1,%xmm26,%rdx
 1076b81:	vextracti32x4 $0x2,%zmm24,%xmm26
 1076b88:	vextracti32x4 $0x3,%zmm24,%xmm24
 1076b8f:	vpinsrb $0x2,0x9d8(%rax),%xmm27,%xmm27
 1076b9a:	vmovq  %xmm26,%rax
 1076ba0:	vpmovzxbq %xmm25,%zmm25
 1076ba6:	vpinsrb $0x3,0x9d8(%rdx),%xmm27,%xmm27
 1076bb1:	vpextrq $0x1,%xmm26,%rdx
 1076bb8:	vpaddq %zmm25,%zmm9,%zmm9
 1076bbe:	vpinsrb $0x4,0x9d8(%rax),%xmm27,%xmm26
 1076bc9:	vmovq  %xmm24,%rax
 1076bcf:	vpinsrb $0x5,0x9d8(%rdx),%xmm26,%xmm26
 1076bda:	vpextrq $0x1,%xmm24,%rdx
 1076be1:	vpinsrb $0x6,0x9d8(%rax),%xmm26,%xmm24
 1076bec:	vpxord %xmm26,%xmm26,%xmm26
 1076bf2:	vpgatherqq 0xa90(%rsi,%zmm23,1),%zmm26{%k1}
 1076bfd:	kxnorb %k0,%k0,%k1
 1076c01:	vpinsrb $0x7,0x9d8(%rdx),%xmm24,%xmm24
 1076c0c:	vpmaxuq %zmm1,%zmm26,%zmm1
 1076c12:	vpxord %xmm26,%xmm26,%xmm26
 1076c18:	vpgatherqq 0x5f50(%rsi,%zmm23,1),%zmm26{%k1}
 1076c23:	kxnorb %k0,%k0,%k1
 1076c27:	vpmovzxbq %xmm24,%zmm24
 1076c2d:	vpmaxuq %zmm4,%zmm26,%zmm4
 1076c33:	vpxord %xmm26,%xmm26,%xmm26
 1076c39:	vpgatherqq 0xa58(%rsi,%zmm23,1),%zmm26{%k1}
 1076c44:	kxnorb %k0,%k0,%k1
 1076c48:	vpaddq %zmm24,%zmm14,%zmm14
 1076c4e:	vpxord %xmm24,%xmm24,%xmm24
 1076c54:	vpaddq %zmm2,%zmm26,%zmm2
 1076c5a:	vpxord %xmm26,%xmm26,%xmm26
 1076c60:	vpgatherqq 0x5f18(%rsi,%zmm23,1),%zmm26{%k1}
 1076c6b:	kxnorb %k0,%k0,%k1
 1076c6f:	vpaddq %zmm6,%zmm26,%zmm6
 1076c75:	vpxord %xmm26,%xmm26,%xmm26
 1076c7b:	vpgatherqq 0xa60(%rsi,%zmm23,1),%zmm26{%k1}
 1076c86:	kxnorb %k0,%k0,%k1
 1076c8a:	vpaddq %zmm3,%zmm26,%zmm3
 1076c90:	vpxord %xmm26,%xmm26,%xmm26
 1076c96:	vpgatherqq 0x5f20(%rsi,%zmm23,1),%zmm26{%k1}
 1076ca1:	kxnorb %k0,%k0,%k1
 1076ca5:	vpaddq %zmm8,%zmm26,%zmm8
 1076cab:	vpxord %xmm26,%xmm26,%xmm26
 1076cb1:	vpgatherqq 0xa68(%rsi,%zmm23,1),%zmm26{%k1}
 1076cbc:	kxnorb %k0,%k0,%k1
 1076cc0:	vpaddq %zmm5,%zmm26,%zmm5
 1076cc6:	vpxord %xmm26,%xmm26,%xmm26
 1076ccc:	vpgatherqq 0x5f28(%rsi,%zmm23,1),%zmm26{%k1}
 1076cd7:	kxnorb %k0,%k0,%k1
 1076cdb:	vpaddq %zmm10,%zmm26,%zmm10
 1076ce1:	vpxord %xmm26,%xmm26,%xmm26
 1076ce7:	vpgatherqq 0xa70(%rsi,%zmm23,1),%zmm26{%k1}
 1076cf2:	kxnorb %k0,%k0,%k1
 1076cf6:	vpaddq %zmm7,%zmm26,%zmm7
 1076cfc:	vpxord %xmm26,%xmm26,%xmm26
 1076d02:	vpgatherqq 0x5f30(%rsi,%zmm23,1),%zmm26{%k1}
 1076d0d:	kxnorb %k0,%k0,%k1
 1076d11:	vpgatherqq 0xa78(%rsi,%zmm23,1),%zmm24{%k1}
 1076d1c:	kxnorb %k0,%k0,%k1
 1076d20:	vpaddq %zmm12,%zmm26,%zmm12
 1076d26:	vpaddq %zmm11,%zmm24,%zmm11
 1076d2c:	vpxord %xmm24,%xmm24,%xmm24
 1076d32:	vpgatherqq 0x5f38(%rsi,%zmm23,1),%zmm24{%k1}
 1076d3d:	kxnorb %k0,%k0,%k1
 1076d41:	vpaddq %zmm16,%zmm24,%zmm16
 1076d47:	vpxord %xmm24,%xmm24,%xmm24
 1076d4d:	vpgatherqq 0xa80(%rsi,%zmm23,1),%zmm24{%k1}
 1076d58:	kxnorb %k0,%k0,%k1
 1076d5c:	vpaddq %zmm13,%zmm24,%zmm13
 1076d62:	vpxord %xmm24,%xmm24,%xmm24
 1076d68:	vpgatherqq 0x5f40(%rsi,%zmm23,1),%zmm24{%k1}
 1076d73:	kxnorb %k0,%k0,%k1
 1076d77:	vpaddq %zmm18,%zmm24,%zmm18
 1076d7d:	vpxord %xmm24,%xmm24,%xmm24
 1076d83:	vpgatherqq 0xa88(%rsi,%zmm23,1),%zmm24{%k1}
 1076d8e:	kxnorb %k0,%k0,%k1
 1076d92:	vpaddq %zmm15,%zmm24,%zmm15
 1076d98:	vpxord %xmm24,%xmm24,%xmm24
 1076d9e:	vpgatherqq 0x5f48(%rsi,%zmm23,1),%zmm24{%k1}
 1076da9:	vpaddq %zmm17,%zmm24,%zmm17
 1076daf:	jne    1076a8b <check_input_run+0x9d7b>
 1076db5:	vpaddq %zmm15,%zmm17,%zmm15
 1076dbb:	vpaddq %zmm13,%zmm18,%zmm13
 1076dc1:	vpaddq %zmm11,%zmm16,%zmm11
 1076dc7:	vpaddq %zmm9,%zmm14,%zmm9
 1076dcd:	vpaddq %zmm7,%zmm12,%zmm7
 1076dd3:	vpaddq %zmm5,%zmm10,%zmm5
 1076dd9:	vpaddq %zmm3,%zmm8,%zmm3
 1076ddf:	vpaddq %zmm2,%zmm6,%zmm2
 1076de5:	vpmaxuq %zmm4,%zmm1,%zmm1
 1076deb:	vextracti64x4 $0x1,%zmm15,%ymm17
 1076df2:	vpaddq %zmm17,%zmm15,%zmm15
 1076df8:	vextracti32x4 $0x1,%ymm15,%xmm17
 1076dff:	vpaddq %xmm17,%xmm15,%xmm15
 1076e05:	vpshufd $0xee,%xmm15,%xmm17
 1076e0c:	vpaddq %xmm17,%xmm15,%xmm15
 1076e12:	vmovq  %xmm15,%rdi
 1076e17:	vextracti64x4 $0x1,%zmm13,%ymm15
 1076e1e:	vpaddq %zmm15,%zmm13,%zmm13
 1076e24:	vextracti128 $0x1,%ymm13,%xmm15
 1076e2a:	vpaddq %xmm15,%xmm13,%xmm13
 1076e2f:	vpshufd $0xee,%xmm13,%xmm15
 1076e35:	vpaddq %xmm15,%xmm13,%xmm13
 1076e3a:	vmovq  %xmm13,%r8
 1076e3f:	vextracti64x4 $0x1,%zmm11,%ymm13
 1076e46:	vpaddq %zmm13,%zmm11,%zmm11
 1076e4c:	vextracti128 $0x1,%ymm11,%xmm13
 1076e52:	vpaddq %xmm13,%xmm11,%xmm11
 1076e57:	vpshufd $0xee,%xmm11,%xmm13
 1076e5d:	vpaddq %xmm13,%xmm11,%xmm11
 1076e62:	vmovq  %xmm11,%r9
 1076e67:	vextracti64x4 $0x1,%zmm9,%ymm11
 1076e6e:	vpaddq %zmm11,%zmm9,%zmm9
 1076e74:	vextracti128 $0x1,%ymm9,%xmm11
 1076e7a:	vpaddq %xmm11,%xmm9,%xmm9
 1076e7f:	vpshufd $0xee,%xmm9,%xmm11
 1076e85:	vpaddq %xmm11,%xmm9,%xmm9
 1076e8a:	vmovq  %xmm9,%r10
 1076e8f:	vextracti64x4 $0x1,%zmm7,%ymm9
 1076e96:	vpaddq %zmm9,%zmm7,%zmm7
 1076e9c:	vextracti128 $0x1,%ymm7,%xmm9
 1076ea2:	vpaddq %xmm7,%xmm9,%xmm7
 1076ea6:	vpshufd $0xee,%xmm7,%xmm9
 1076eab:	vpaddq %xmm7,%xmm9,%xmm7
 1076eaf:	vmovq  %xmm7,%r11
 1076eb4:	vextracti64x4 $0x1,%zmm5,%ymm7
 1076ebb:	vpaddq %zmm7,%zmm5,%zmm5
 1076ec1:	vextracti128 $0x1,%ymm5,%xmm7
 1076ec7:	vpaddq %xmm7,%xmm5,%xmm5
 1076ecb:	vpshufd $0xee,%xmm5,%xmm7
 1076ed0:	vpaddq %xmm7,%xmm5,%xmm5
 1076ed4:	vmovq  %xmm5,%rbx
 1076ed9:	vextracti64x4 $0x1,%zmm3,%ymm5
 1076ee0:	vpaddq %zmm5,%zmm3,%zmm3
 1076ee6:	vextracti128 $0x1,%ymm3,%xmm5
 1076eec:	vpaddq %xmm5,%xmm3,%xmm3
 1076ef0:	vpshufd $0xee,%xmm3,%xmm5
 1076ef5:	vpaddq %xmm5,%xmm3,%xmm3
 1076ef9:	vmovq  %xmm3,%r12
 1076efe:	vextracti64x4 $0x1,%zmm2,%ymm3
 1076f05:	vpaddq %zmm3,%zmm2,%zmm2
 1076f0b:	vextracti128 $0x1,%ymm2,%xmm3
 1076f11:	vpaddq %xmm3,%xmm2,%xmm2
 1076f15:	vpshufd $0xee,%xmm2,%xmm3
 1076f1a:	vpaddq %xmm3,%xmm2,%xmm2
 1076f1e:	vmovq  %xmm2,%r15
 1076f23:	vextracti64x4 $0x1,%zmm1,%ymm2
 1076f2a:	vpmaxuq %ymm2,%ymm1,%ymm1
 1076f30:	vextracti128 $0x1,%ymm1,%xmm2
 1076f36:	vpmaxuq %xmm2,%xmm1,%xmm1
 1076f3c:	vpshufd $0xee,%xmm1,%xmm2
 1076f41:	vpmaxuq %xmm2,%xmm1,%xmm1
 1076f47:	vmovq  %xmm1,%rax
 1076f4c:	cmp    %ecx,%r14d
 1076f4f:	je     10772f4 <check_input_run+0xa5e4>
 1076f55:	test   $0x8,%cl
 1076f58:	je     107729e <check_input_run+0xa58e>
 1076f5e:	mov    %r14,%rdx
 1076f61:	vpbroadcastq %rdx,%zmm10
 1076f67:	vporq  -0xbd99f1(%rip),%zmm10,%zmm10        # 49d580 <cbuiltin_test_generated.edges+0x3740>
 1076f71:	vpbroadcastq -0xacabcb(%rip),%zmm11        # 5ac3b0 <check_mutation_families+0x190>
 1076f7b:	vpbroadcastq -0xacabbd(%rip),%zmm12        # 5ac3c8 <check_mutation_families+0x1a8>
 1076f85:	mov    %ecx,%r14d
 1076f88:	and    $0x78,%r14d
 1076f8c:	vmovq  %rdi,%xmm9
 1076f91:	vmovq  %r8,%xmm8
 1076f96:	vmovq  %r9,%xmm7
 1076f9b:	vmovq  %r10,%xmm6
 1076fa0:	vmovq  %r11,%xmm5
 1076fa5:	vmovq  %rbx,%xmm4
 1076faa:	vmovq  %r12,%xmm3
 1076faf:	vmovq  %r15,%xmm2
 1076fb4:	vpbroadcastq %rax,%zmm1
 1076fba:	sub    %r14,%rdx
 1076fbd:	vpmullq %zmm11,%zmm10,%zmm13
 1076fc3:	kxnorb %k0,%k0,%k1
 1076fc7:	vpxor  %xmm15,%xmm15,%xmm15
 1076fcc:	vpaddq %zmm12,%zmm10,%zmm10
 1076fd2:	add    $0x8,%rdx
 1076fd6:	vpaddq %zmm13,%zmm0,%zmm14
 1076fdc:	vpgatherqq 0xa90(%rsi,%zmm13,1),%zmm15{%k1}
 1076fe7:	kxnorb %k0,%k0,%k1
 1076feb:	vextracti32x4 $0x1,%ymm14,%xmm17
 1076ff2:	vextracti32x4 $0x2,%zmm14,%xmm16
 1076ff9:	vmovq  %xmm14,%rax
 1076ffe:	vpextrq $0x1,%xmm14,%rdi
 1077004:	vextracti32x4 $0x3,%zmm14,%xmm14
 107700b:	vmovq  %xmm14,%rbx
 1077010:	vpextrq $0x1,%xmm14,%r15
 1077016:	vmovd  0x9d8(%rax),%xmm14
 107701e:	vmovq  %xmm17,%r8
 1077024:	vpextrq $0x1,%xmm17,%r9
 107702b:	vmovq  %xmm16,%r10
 1077031:	vpextrq $0x1,%xmm16,%r11
 1077038:	vpmaxuq %zmm1,%zmm15,%zmm1
 107703e:	vpxor  %xmm15,%xmm15,%xmm15
 1077043:	vpgatherqq 0xa58(%rsi,%zmm13,1),%zmm15{%k1}
 107704e:	kxnorb %k0,%k0,%k1
 1077052:	vpinsrb $0x1,0x9d8(%rdi),%xmm14,%xmm14
 107705c:	vpinsrb $0x2,0x9d8(%r8),%xmm14,%xmm14
 1077066:	vpaddq %zmm2,%zmm15,%zmm2
 107706c:	vpxor  %xmm15,%xmm15,%xmm15
 1077071:	vpgatherqq 0xa60(%rsi,%zmm13,1),%zmm15{%k1}
 107707c:	kxnorb %k0,%k0,%k1
 1077080:	vpinsrb $0x3,0x9d8(%r9),%xmm14,%xmm14
 107708a:	vpaddq %zmm3,%zmm15,%zmm3
 1077090:	vpxor  %xmm15,%xmm15,%xmm15
 1077095:	vpgatherqq 0xa68(%rsi,%zmm13,1),%zmm15{%k1}
 10770a0:	kxnorb %k0,%k0,%k1
 10770a4:	vpinsrb $0x4,0x9d8(%r10),%xmm14,%xmm14
 10770ae:	vpaddq %zmm4,%zmm15,%zmm4
 10770b4:	vpxor  %xmm15,%xmm15,%xmm15
 10770b9:	vpgatherqq 0xa70(%rsi,%zmm13,1),%zmm15{%k1}
 10770c4:	kxnorb %k0,%k0,%k1
 10770c8:	vpinsrb $0x5,0x9d8(%r11),%xmm14,%xmm14
 10770d2:	vpaddq %zmm5,%zmm15,%zmm5
 10770d8:	vpinsrb $0x6,0x9d8(%rbx),%xmm14,%xmm14
 10770e2:	vpinsrb $0x7,0x9d8(%r15),%xmm14,%xmm14
 10770ec:	vpmovzxbq %xmm14,%zmm14
 10770f2:	vpaddq %zmm14,%zmm6,%zmm6
 10770f8:	vpxor  %xmm14,%xmm14,%xmm14
 10770fd:	vpgatherqq 0xa78(%rsi,%zmm13,1),%zmm14{%k1}
 1077108:	kxnorb %k0,%k0,%k1
 107710c:	vpaddq %zmm7,%zmm14,%zmm7
 1077112:	vpxor  %xmm14,%xmm14,%xmm14
 1077117:	vpgatherqq 0xa80(%rsi,%zmm13,1),%zmm14{%k1}
 1077122:	kxnorb %k0,%k0,%k1
 1077126:	vpaddq %zmm8,%zmm14,%zmm8
 107712c:	vpxor  %xmm14,%xmm14,%xmm14
 1077131:	vpgatherqq 0xa88(%rsi,%zmm13,1),%zmm14{%k1}
 107713c:	vpaddq %zmm9,%zmm14,%zmm9
 1077142:	jne    1076fbd <check_input_run+0xa2ad>
 1077148:	vextracti64x4 $0x1,%zmm9,%ymm0
 107714f:	vpaddq %zmm0,%zmm9,%zmm0
 1077155:	vextracti128 $0x1,%ymm0,%xmm9
 107715b:	vpaddq %xmm0,%xmm9,%xmm0
 107715f:	vpshufd $0xee,%xmm0,%xmm9
 1077164:	vpaddq %xmm0,%xmm9,%xmm0
 1077168:	vmovq  %xmm0,%rdi
 107716d:	vextracti64x4 $0x1,%zmm8,%ymm0
 1077174:	vpaddq %zmm0,%zmm8,%zmm0
 107717a:	vextracti128 $0x1,%ymm0,%xmm8
 1077180:	vpaddq %xmm0,%xmm8,%xmm0
 1077184:	vpshufd $0xee,%xmm0,%xmm8
 1077189:	vpaddq %xmm0,%xmm8,%xmm0
 107718d:	vmovq  %xmm0,%r8
 1077192:	vextracti64x4 $0x1,%zmm7,%ymm0
 1077199:	vpaddq %zmm0,%zmm7,%zmm0
 107719f:	vextracti128 $0x1,%ymm0,%xmm7
 10771a5:	vpaddq %xmm7,%xmm0,%xmm0
 10771a9:	vpshufd $0xee,%xmm0,%xmm7
 10771ae:	vpaddq %xmm7,%xmm0,%xmm0
 10771b2:	vmovq  %xmm0,%r9
 10771b7:	vextracti64x4 $0x1,%zmm6,%ymm0
 10771be:	vpaddq %zmm0,%zmm6,%zmm0
 10771c4:	vextracti128 $0x1,%ymm0,%xmm6
 10771ca:	vpaddq %xmm6,%xmm0,%xmm0
 10771ce:	vpshufd $0xee,%xmm0,%xmm6
 10771d3:	vpaddq %xmm6,%xmm0,%xmm0
 10771d7:	vmovq  %xmm0,%r10
 10771dc:	vextracti64x4 $0x1,%zmm5,%ymm0
 10771e3:	vpaddq %zmm0,%zmm5,%zmm0
 10771e9:	vextracti128 $0x1,%ymm0,%xmm5
 10771ef:	vpaddq %xmm5,%xmm0,%xmm0
 10771f3:	vpshufd $0xee,%xmm0,%xmm5
 10771f8:	vpaddq %xmm5,%xmm0,%xmm0
 10771fc:	vmovq  %xmm0,%r11
 1077201:	vextracti64x4 $0x1,%zmm4,%ymm0
 1077208:	vpaddq %zmm0,%zmm4,%zmm0
 107720e:	vextracti128 $0x1,%ymm0,%xmm4
 1077214:	vpaddq %xmm4,%xmm0,%xmm0
 1077218:	vpshufd $0xee,%xmm0,%xmm4
 107721d:	vpaddq %xmm4,%xmm0,%xmm0
 1077221:	vmovq  %xmm0,%rbx
 1077226:	vextracti64x4 $0x1,%zmm3,%ymm0
 107722d:	vpaddq %zmm0,%zmm3,%zmm0
 1077233:	vextracti128 $0x1,%ymm0,%xmm3
 1077239:	vpaddq %xmm3,%xmm0,%xmm0
 107723d:	vpshufd $0xee,%xmm0,%xmm3
 1077242:	vpaddq %xmm3,%xmm0,%xmm0
 1077246:	vmovq  %xmm0,%r12
 107724b:	vextracti64x4 $0x1,%zmm2,%ymm0
 1077252:	vpaddq %zmm0,%zmm2,%zmm0
 1077258:	vextracti128 $0x1,%ymm0,%xmm2
 107725e:	vpaddq %xmm2,%xmm0,%xmm0
 1077262:	vpshufd $0xee,%xmm0,%xmm2
 1077267:	vpaddq %xmm2,%xmm0,%xmm0
 107726b:	vmovq  %xmm0,%r15
 1077270:	vextracti64x4 $0x1,%zmm1,%ymm0
 1077277:	vpmaxuq %ymm0,%ymm1,%ymm0
 107727d:	vextracti128 $0x1,%ymm0,%xmm1
 1077283:	vpmaxuq %xmm1,%xmm0,%xmm0
 1077289:	vpshufd $0xee,%xmm0,%xmm1
 107728e:	vpmaxuq %xmm1,%xmm0,%xmm0
 1077294:	vmovq  %xmm0,%rax
 1077299:	cmp    %ecx,%r14d
 107729c:	je     10772f4 <check_input_run+0xa5e4>
 107729e:	mov    0x860(%rsp),%rsi
 10772a6:	imul   $0xa98,%r14,%rdx
 10772ad:	sub    %r14,%rcx
 10772b0:	lea    0xcb8(%rdx,%rsi,1),%rdx
 10772b8:	mov    (%rdx),%rsi
 10772bb:	cmp    %rax,%rsi
 10772be:	cmova  %rsi,%rax
 10772c2:	movzbl -0xb8(%rdx),%esi
 10772c9:	add    -0x38(%rdx),%r15
 10772cd:	add    -0x30(%rdx),%r12
 10772d1:	add    -0x28(%rdx),%rbx
 10772d5:	add    -0x20(%rdx),%r11
 10772d9:	add    -0x18(%rdx),%r9
 10772dd:	add    -0x10(%rdx),%r8
 10772e1:	add    -0x8(%rdx),%rdi
 10772e5:	add    $0xa98,%rdx
 10772ec:	add    %rsi,%r10
 10772ef:	dec    %rcx
 10772f2:	jne    10772b8 <check_input_run+0xa5a8>
 10772f4:	mov    0x860(%rsp),%rcx
 10772fc:	mov    0x50(%rsp),%r14
 1077301:	mov    %r15,0x2aa68(%rcx)
 1077308:	mov    0x1b0(%rsp),%r15
 1077310:	mov    %r12,0x2aa70(%rcx)
 1077317:	mov    %rcx,%r12
 107731a:	mov    %rbx,0x2aa78(%rcx)
 1077321:	mov    %r11,0x2aa80(%rcx)
 1077328:	mov    %r10,0x2aa88(%rcx)
 107732f:	mov    %r9,0x2aad8(%rcx)
 1077336:	mov    %r8,0x2aad0(%rcx)
 107733d:	mov    %rdi,0x2aae0(%rcx)
 1077344:	mov    %rbp,%rcx
 1077347:	sub    %r13,%rcx
 107734a:	sub    %rbp,%rax
 107734d:	test   %rbp,%rbp
 1077350:	cmove  %rbp,%rcx
 1077354:	cmove  %rbp,%rax
 1077358:	cmpb   $0x0,0x90(%rsp)
 1077360:	mov    %rcx,0x2aae8(%r12)
 1077368:	mov    %rax,0x2aaf0(%r12)
 1077370:	je     10773b6 <check_input_run+0xa6a6>
 1077372:	mov    0x28(%rsp),%rax
 1077377:	mov    $0x1,%bl
 1077379:	mov    (%rax),%eax
 107737b:	test   %rax,%rax
 107737e:	je     10773b8 <check_input_run+0xa6a8>
 1077380:	imul   $0x150,%rax,%rax
 1077387:	xor    %ecx,%ecx
 1077389:	mov    (%r15),%rdx
 107738c:	cmpb   $0x0,0x14c(%rdx,%rcx,1)
 1077394:	lea    0x130(%rdx,%rcx,1),%rsi
 107739c:	cmove  %r14,%rsi
 10773a0:	mov    (%rsi),%rdx
 10773a3:	mov    %rdx,(%r14)
 10773a6:	jne    10773b6 <check_input_run+0xa6a6>
 10773a8:	add    $0x150,%rcx
 10773af:	cmp    %rcx,%rax
 10773b2:	jne    1077389 <check_input_run+0xa679>
 10773b4:	jmp    10773b8 <check_input_run+0xa6a8>
 10773b6:	xor    %ebx,%ebx
 10773b8:	cmpb   $0x0,0x2aa90(%r12)
 10773c1:	je     10773fb <check_input_run+0xa6eb>
 10773c3:	lea    0x780(%rsp),%rsi
 10773cb:	mov    $0x1,%edi
 10773d0:	vpxor  %xmm0,%xmm0,%xmm0
 10773d4:	vmovdqa %xmm0,0x780(%rsp)
 10773dd:	vzeroupper
 10773e0:	call   7878b0 <clock_gettime@plt>
 10773e5:	imul   $0xffffffffc4653600,0x780(%rsp),%rax
 10773f1:	sub    0x788(%rsp),%rax
 10773f9:	jmp    10773fd <check_input_run+0xa6ed>
 10773fb:	xor    %eax,%eax
 10773fd:	mov    %ebx,0x90(%rsp)
 1077404:	mov    %rax,0x130(%rsp)
 107740c:	test   %bl,%bl
 107740e:	je     1077464 <check_input_run+0xa754>
 1077410:	mov    0x2a8(%rsp),%rax
 1077418:	mov    0x2aa40(%r12),%r13
 1077420:	mov    0x1e0(%r12),%r14d
 1077428:	mov    0x2a0(%rsp),%rbp
 1077430:	mov    0x30(%rax),%r9d
 1077434:	mov    0x2aa38(%r12),%rax
 107743c:	lea    0x1(%r14),%rbx
 1077440:	lea    0x7(%r13,%rax,1),%r8
 1077445:	lea    0x0(%r13,%rax,1),%rcx
 107744a:	and    $0xfffffffffffffff8,%r8
 107744e:	cmp    %rcx,%r8
 1077451:	jae    1077472 <check_input_run+0xa762>
 1077453:	mov    $0x1,%al
 1077455:	xor    %r10d,%r10d
 1077458:	mov    %eax,0x210(%rsp)
 107745f:	jmp    1077c15 <check_input_run+0xaf05>
 1077464:	mov    $0x1,%cl
 1077466:	mov    %ecx,0x210(%rsp)
 107746d:	jmp    1077c8e <check_input_run+0xaf7e>
 1077472:	mov    0x2aa48(%r12),%rdx
 107747a:	mov    $0x1,%cl
 107747c:	xor    %r10d,%r10d
 107747f:	mov    %ecx,0x210(%rsp)
 1077486:	mov    %r8,%rcx
 1077489:	sub    %rax,%rcx
 107748c:	mov    %rdx,%rsi
 107748f:	sub    %rcx,%rsi
 1077492:	jb     1077c15 <check_input_run+0xaf05>
 1077498:	mov    %rbx,%rdi
 107749b:	shl    $0x4,%rdi
 107749f:	lea    (%rdi,%rdi,2),%rdi
 10774a3:	cmp    %rsi,%rdi
 10774a6:	ja     1077c15 <check_input_run+0xaf05>
 10774ac:	add    %rdi,%rcx
 10774af:	mov    %rcx,0x2aa40(%r12)
 10774b7:	test   %r8,%r8
 10774ba:	je     1077513 <check_input_run+0xa803>
 10774bc:	mov    %r9,0xe8(%rsp)
 10774c4:	mov    0x58(%r12),%r9d
 10774c9:	add    %r8,%rdi
 10774cc:	mov    %r8,0x70(%rsp)
 10774d1:	mov    %rdx,%r11
 10774d4:	mov    %rdi,%r8
 10774d7:	sub    %rax,%r8
 10774da:	shl    $0x2,%r9
 10774de:	sub    %r8,%r11
 10774e1:	setb   %sil
 10774e5:	cmp    %r11,%r9
 10774e8:	seta   %r10b
 10774ec:	or     %sil,%r10b
 10774ef:	je     107751e <check_input_run+0xa80e>
 10774f1:	xor    %esi,%esi
 10774f3:	jmp    107753e <check_input_run+0xa82e>
 10774f5:	cmp    $0x130,%ecx
 10774fb:	je     1077509 <check_input_run+0xa7f9>
 10774fd:	cmp    $0x133,%ecx
 1077503:	jne    1077942 <check_input_run+0xac32>
 1077509:	mov    $0x1,%eax
 107750e:	jmp    10745df <check_input_run+0x78cf>
 1077513:	xor    %r10d,%r10d
 1077516:	mov    %rcx,%r13
 1077519:	jmp    1077c15 <check_input_run+0xaf05>
 107751e:	mov    %rdi,%rsi
 1077521:	add    %r9,%rdi
 1077524:	mov    %r8,%rcx
 1077527:	add    %r9,%rcx
 107752a:	mov    %rdx,%r11
 107752d:	mov    %rdi,%r8
 1077530:	sub    %rax,%r8
 1077533:	mov    %rcx,0x2aa40(%r12)
 107753b:	sub    %r8,%r11
 107753e:	mov    0xd0(%rsp),%r9
 1077546:	mov    (%r9),%r10d
 1077549:	xor    %r9d,%r9d
 107754c:	cmp    %rdx,%r8
 107754f:	ja     1077967 <check_input_run+0xac57>
 1077555:	lea    0x0(,%r10,4),%r15
 107755d:	cmp    %r11,%r15
 1077560:	mov    0x70(%rsp),%r11
 1077565:	ja     107796c <check_input_run+0xac5c>
 107756b:	add    %r8,%r15
 107756e:	mov    %rdi,%r9
 1077571:	mov    %r15,%rcx
 1077574:	mov    %r15,0x2aa40(%r12)
 107757c:	jmp    107796c <check_input_run+0xac5c>
 1077581:	xor    %r11d,%r11d
 1077584:	jmp    1070f52 <check_input_run+0x4242>
 1077589:	mov    %ebp,%edi
 107758b:	and    $0xfffffffc,%edi
 107758e:	mov    $0xffffffff,%esi
 1077593:	xor    %edx,%edx
 1077595:	jmp    10775b0 <check_input_run+0xa8a0>
 1077597:	mov    %esi,0xc(%r15,%rdx,4)
 107759c:	lea    0x3(%rdx),%esi
 107759f:	mov    %esi,(%r15,%r9,4)
 10775a3:	add    $0x4,%rdx
 10775a7:	cmp    %rdx,%rdi
 10775aa:	je     10776cb <check_input_run+0xa9bb>
 10775b0:	mov    0x50(%r14),%r9
 10775b4:	mov    0x60(%r14),%r8
 10775b8:	movzbl (%r9,%rdx,1),%r9d
 10775bd:	add    $0xde,%r9b
 10775c1:	cmp    $0x18,%r9b
 10775c5:	ja     10775dc <check_input_run+0xa8cc>
 10775c7:	mov    (%r8,%rdx,4),%r9d
 10775cb:	cmp    %ebp,%r9d
 10775ce:	jae    10775dc <check_input_run+0xa8cc>
 10775d0:	mov    %esi,(%r15,%rdx,4)
 10775d4:	mov    %edx,(%r15,%r9,4)
 10775d8:	mov    %edx,%esi
 10775da:	jmp    10775f0 <check_input_run+0xa8e0>
 10775dc:	cmp    %ebp,%esi
 10775de:	jae    10775f0 <check_input_run+0xa8e0>
 10775e0:	mov    %esi,%r9d
 10775e3:	mov    (%r8,%r9,4),%r8d
 10775e7:	cmp    %r8,%rdx
 10775ea:	jne    10775f0 <check_input_run+0xa8e0>
 10775ec:	mov    (%r15,%r9,4),%esi
 10775f0:	mov    0x50(%r14),%r9
 10775f4:	mov    0x60(%r14),%r8
 10775f8:	movzbl 0x1(%r9,%rdx,1),%r9d
 10775fe:	add    $0xde,%r9b
 1077602:	cmp    $0x18,%r9b
 1077606:	ja     1077620 <check_input_run+0xa910>
 1077608:	mov    0x4(%r8,%rdx,4),%r9d
 107760d:	cmp    %ebp,%r9d
 1077610:	jae    1077620 <check_input_run+0xa910>
 1077612:	mov    %esi,0x4(%r15,%rdx,4)
 1077617:	lea    0x1(%rdx),%esi
 107761a:	mov    %esi,(%r15,%r9,4)
 107761e:	jmp    1077638 <check_input_run+0xa928>
 1077620:	cmp    %ebp,%esi
 1077622:	jae    1077638 <check_input_run+0xa928>
 1077624:	mov    %esi,%r9d
 1077627:	mov    (%r8,%r9,4),%r8d
 107762b:	lea    0x1(%rdx),%r10
 107762f:	cmp    %r8,%r10
 1077632:	jne    1077638 <check_input_run+0xa928>
 1077634:	mov    (%r15,%r9,4),%esi
 1077638:	mov    0x50(%r14),%r9
 107763c:	mov    0x60(%r14),%r8
 1077640:	movzbl 0x2(%r9,%rdx,1),%r9d
 1077646:	add    $0xde,%r9b
 107764a:	cmp    $0x18,%r9b
 107764e:	ja     1077668 <check_input_run+0xa958>
 1077650:	mov    0x8(%r8,%rdx,4),%r9d
 1077655:	cmp    %ebp,%r9d
 1077658:	jae    1077668 <check_input_run+0xa958>
 107765a:	mov    %esi,0x8(%r15,%rdx,4)
 107765f:	lea    0x2(%rdx),%esi
 1077662:	mov    %esi,(%r15,%r9,4)
 1077666:	jmp    1077680 <check_input_run+0xa970>
 1077668:	cmp    %ebp,%esi
 107766a:	jae    1077680 <check_input_run+0xa970>
 107766c:	mov    %esi,%r9d
 107766f:	mov    (%r8,%r9,4),%r8d
 1077673:	lea    0x2(%rdx),%r10
 1077677:	cmp    %r8,%r10
 107767a:	jne    1077680 <check_input_run+0xa970>
 107767c:	mov    (%r15,%r9,4),%esi
 1077680:	mov    0x50(%r14),%r9
 1077684:	mov    0x60(%r14),%r8
 1077688:	movzbl 0x3(%r9,%rdx,1),%r9d
 107768e:	add    $0xde,%r9b
 1077692:	cmp    $0x18,%r9b
 1077696:	ja     10776a6 <check_input_run+0xa996>
 1077698:	mov    0xc(%r8,%rdx,4),%r9d
 107769d:	cmp    %ebp,%r9d
 10776a0:	jb     1077597 <check_input_run+0xa887>
 10776a6:	cmp    %ebp,%esi
 10776a8:	jae    10775a3 <check_input_run+0xa893>
 10776ae:	mov    %esi,%r9d
 10776b1:	mov    (%r8,%r9,4),%r8d
 10776b5:	lea    0x3(%rdx),%r10
 10776b9:	cmp    %r8,%r10
 10776bc:	jne    10775a3 <check_input_run+0xa893>
 10776c2:	mov    (%r15,%r9,4),%esi
 10776c6:	jmp    10775a3 <check_input_run+0xa893>
 10776cb:	test   %rcx,%rcx
 10776ce:	jne    1077788 <check_input_run+0xaa78>
 10776d4:	mov    %rbp,%rcx
 10776d7:	test   $0x1,%bpl
 10776db:	je     10790f3 <check_input_run+0xc3e3>
 10776e1:	mov    0x68(%r14),%rcx
 10776e5:	mov    0x50(%r14),%rdi
 10776e9:	mov    0x60(%r14),%rdx
 10776ed:	mov    -0x4(%rcx,%rbp,4),%ecx
 10776f1:	movzbl (%rdi,%rcx,1),%r8d
 10776f6:	mov    (%rdx,%rcx,4),%esi
 10776f9:	mov    $0x1,%dl
 10776fb:	lea    -0x41(%r8),%r9d
 10776ff:	cmp    $0xe,%r9d
 1077703:	ja     1077715 <check_input_run+0xaa05>
 1077705:	mov    $0x6005,%r10d
 107770b:	bt     %r9d,%r10d
 107770f:	jb     10790eb <check_input_run+0xc3db>
 1077715:	add    $0xfffffff9,%r8d
 1077719:	cmp    $0x2,%r8d
 107771d:	jb     10790eb <check_input_run+0xc3db>
 1077723:	cmp    %ebp,%esi
 1077725:	jae    10790e1 <check_input_run+0xc3d1>
 107772b:	mov    0x98(%rsp),%r8
 1077733:	cmpb   $0x0,(%r8,%rsi,1)
 1077738:	je     10790e1 <check_input_run+0xc3d1>
 107773e:	movzbl (%rdi,%rsi,1),%edi
 1077742:	mov    0x98(%rsp),%r13
 107774a:	add    $0xfffffff9,%edi
 107774d:	cmp    $0x44,%edi
 1077750:	ja     10790e9 <check_input_run+0xc3d9>
 1077756:	lea    -0xbda181(%rip),%r8        # 49d5dc <cbuiltin_test_generated.edges+0x379c>
 107775d:	movslq (%r8,%rdi,4),%rdi
 1077761:	add    %r8,%rdi
 1077764:	jmp    *%rdi
 1077766:	cmp    (%r15,%rsi,4),%ecx
 107776a:	setb   %dl
 107776d:	jmp    10790eb <check_input_run+0xc3db>
 1077772:	mov    %esi,(%r15,%rdx,4)
 1077776:	mov    %edx,%esi
 1077778:	mov    %edx,(%r15,%r8,4)
 107777c:	inc    %rdx
 107777f:	dec    %rcx
 1077782:	je     10776d4 <check_input_run+0xa9c4>
 1077788:	mov    0x50(%r14),%r8
 107778c:	mov    0x60(%r14),%rdi
 1077790:	movzbl (%r8,%rdx,1),%r8d
 1077795:	add    $0xde,%r8b
 1077799:	cmp    $0x18,%r8b
 107779d:	ja     10777a8 <check_input_run+0xaa98>
 107779f:	mov    (%rdi,%rdx,4),%r8d
 10777a3:	cmp    %ebp,%r8d
 10777a6:	jb     1077772 <check_input_run+0xaa62>
 10777a8:	cmp    %ebp,%esi
 10777aa:	jae    107777c <check_input_run+0xaa6c>
 10777ac:	mov    %esi,%r8d
 10777af:	mov    (%rdi,%r8,4),%edi
 10777b3:	cmp    %rdi,%rdx
 10777b6:	jne    107777c <check_input_run+0xaa6c>
 10777b8:	mov    (%r15,%r8,4),%esi
 10777bc:	jmp    107777c <check_input_run+0xaa6c>
 10777be:	mov    %rcx,%rdx
 10777c1:	sub    %rsi,%rdx
 10777c4:	mov    0x10(%r8),%rsi
 10777c8:	sub    %rdx,%rsi
 10777cb:	jb     107870c <check_input_run+0xb9fc>
 10777d1:	cmp    %rsi,%rax
 10777d4:	ja     107870c <check_input_run+0xb9fc>
 10777da:	mov    0x10(%rsp),%rsi
 10777df:	mov    0x18(%rsp),%rdi
 10777e4:	add    %rax,%rdx
 10777e7:	mov    %rdx,0x8(%rsi)
 10777eb:	mov    %rcx,0x240(%rdi)
 10777f2:	test   %rcx,%rcx
 10777f5:	je     1078fad <check_input_run+0xc29d>
 10777fb:	mov    0x8(%rsi),%rcx
 10777ff:	mov    0x10(%rsi),%rdx
 1077803:	sub    %rcx,%rdx
 1077806:	setb   %sil
 107780a:	cmp    0x78(%rsp),%rdx
 107780f:	setbe  %dl
 1077812:	or     %sil,%dl
 1077815:	cmp    $0x1,%dl
 1077818:	jne    1078fcd <check_input_run+0xc2bd>
 107781e:	mov    0x18(%rsp),%rdi
 1077823:	mov    0x10(%rsp),%rsi
 1077828:	movq   $0x0,0x248(%rdi)
 1077833:	movq   $0x0,0x260(%rdi)
 107783e:	jmp    106d556 <check_input_run+0x846>
 1077843:	mov    0x58(%rsp),%rdx
 1077848:	mov    %rbp,%rsi
 107784b:	sub    %rdi,%rsi
 107784e:	mov    0x10(%rcx),%rdi
 1077852:	mov    %r8,%r11
 1077855:	mov    0x830(%rdx),%edx
 107785b:	sub    %rsi,%rdi
 107785e:	setb   %r8b
 1077862:	cmp    %rdx,%rdi
 1077865:	setbe  %dil
 1077869:	or     %r8b,%dil
 107786c:	je     107873c <check_input_run+0xba2c>
 1077872:	xor    %ebp,%ebp
 1077874:	jmp    1078746 <check_input_run+0xba36>
 1077879:	mov    0x2aa38(%r12),%rdx
 1077881:	mov    0x2aa40(%r12),%rax
 1077889:	lea    0x7(%rax,%rdx,1),%rcx
 107788e:	add    %rdx,%rax
 1077891:	and    $0xfffffffffffffff8,%rcx
 1077895:	cmp    %rax,%rcx
 1077898:	jb     1077925 <check_input_run+0xac15>
 107789e:	mov    0x2aa48(%r12),%rsi
 10778a6:	mov    %rcx,%rdi
 10778a9:	sub    %rdx,%rdi
 10778ac:	mov    %rsi,%r9
 10778af:	sub    %rdi,%r9
 10778b2:	jb     1077925 <check_input_run+0xac15>
 10778b4:	mov    0x1e0(%r12),%eax
 10778bc:	lea    0x8(,%rax,8),%r8
 10778c4:	cmp    %r9,%r8
 10778c7:	ja     1077925 <check_input_run+0xac15>
 10778c9:	add    %r8,%rdi
 10778cc:	mov    %rdi,0x2aa40(%r12)
 10778d4:	mov    %rcx,0x2a828(%r12)
 10778dc:	test   %rcx,%rcx
 10778df:	je     107790c <check_input_run+0xabfc>
 10778e1:	add    %r8,%rcx
 10778e4:	mov    %rsi,%r8
 10778e7:	mov    %rcx,%rdi
 10778ea:	sub    %rdx,%rdi
 10778ed:	sub    %rdi,%r8
 10778f0:	setb   %r9b
 10778f4:	cmp    $0x20008,%r8
 10778fb:	setb   %r8b
 10778ff:	or     %r9b,%r8b
 1077902:	cmp    $0x1,%r8b
 1077906:	jne    10799b0 <check_input_run+0xcca0>
 107790c:	mov    0x860(%rsp),%r12
 1077914:	movq   $0x0,0x2a830(%r12)
 1077920:	jmp    1076758 <check_input_run+0x9a48>
 1077925:	movq   $0x0,0x2a828(%r12)
 1077931:	movq   $0x0,0x2a830(%r12)
 107793d:	jmp    1076758 <check_input_run+0x9a48>
 1077942:	lea    -0x300(%rcx),%edx
 1077948:	cmp    $0x16,%dx
 107794c:	mov    0x10(%rsp),%rdx
 1077951:	ja     10745e4 <check_input_run+0x78d4>
 1077957:	xor    %eax,%eax
 1077959:	cmp    $0x312,%ecx
 107795f:	sete   %al
 1077962:	jmp    10745e4 <check_input_run+0x78d4>
 1077967:	mov    0x70(%rsp),%r11
 107796c:	xor    %edi,%edi
 107796e:	lea    0x128(%r12),%r8
 1077976:	sub    %rcx,%rdx
 1077979:	jb     1077991 <check_input_run+0xac81>
 107797b:	cmp    %r10,%rdx
 107797e:	jb     1077991 <check_input_run+0xac81>
 1077980:	add    %rcx,%rax
 1077983:	add    %rcx,%r10
 1077986:	mov    %rax,%rdi
 1077989:	mov    %r10,0x2aa40(%r12)
 1077991:	movabs $0x100000040,%rax
 107799b:	mov    %r8,(%r11)
 107799e:	movq   $0x0,0x8(%r11)
 10779a6:	mov    %rax,0x10(%r11)
 10779aa:	mov    %rsi,0x18(%r11)
 10779ae:	mov    %r9,0x20(%r11)
 10779b2:	mov    %rdi,0x28(%r11)
 10779b6:	test   %rsi,%rsi
 10779b9:	je     1077c02 <check_input_run+0xaef2>
 10779bf:	test   %r9,%r9
 10779c2:	mov    %rbx,0xc8(%rsp)
 10779ca:	setne  %al
 10779cd:	test   %rdi,%rdi
 10779d0:	setne  %sil
 10779d4:	and    %al,%sil
 10779d7:	test   %r14,%r14
 10779da:	setne  0x58(%rsp)
 10779df:	je     1077b73 <check_input_run+0xae63>
 10779e5:	test   %sil,%sil
 10779e8:	je     1077b73 <check_input_run+0xae63>
 10779ee:	mov    0x70(%rsp),%rax
 10779f3:	mov    $0x1,%edx
 10779f8:	xor    %ecx,%ecx
 10779fa:	add    $0x58,%rax
 10779fe:	mov    0x2aa38(%r12),%r8
 1077a06:	mov    0x2aa40(%r12),%r9
 1077a0e:	mov    0x1d8(%r12),%rsi
 1077a16:	mov    0x2aa48(%r12),%r10
 1077a1e:	lea    0x3(%r9,%r8,1),%rdi
 1077a23:	lea    (%r9,%r8,1),%r11
 1077a27:	and    $0xfffffffffffffffc,%rdi
 1077a2b:	cmp    %r11,%rdi
 1077a2e:	jae    1077a3f <check_input_run+0xad2f>
 1077a30:	mov    0x54(%rsi,%rcx,1),%r12d
 1077a35:	xor    %r11d,%r11d
 1077a38:	xor    %edi,%edi
 1077a3a:	jmp    1077ad4 <check_input_run+0xadc4>
 1077a3f:	mov    %rdi,%r15
 1077a42:	sub    %r8,%r15
 1077a45:	mov    %r10,%r13
 1077a48:	sub    %r15,%r13
 1077a4b:	jb     1077a88 <check_input_run+0xad78>
 1077a4d:	mov    0x50(%rsi,%rcx,1),%r11d
 1077a52:	lea    0x4(,%r11,4),%r12
 1077a5a:	cmp    %r13,%r12
 1077a5d:	ja     1077a88 <check_input_run+0xad78>
 1077a5f:	mov    %r15,%r9
 1077a62:	mov    0x860(%rsp),%r15
 1077a6a:	mov    %rdi,%r11
 1077a6d:	add    %r12,%r9
 1077a70:	add    %r12,%rdi
 1077a73:	mov    %r10,%r13
 1077a76:	mov    %r9,0x2aa40(%r15)
 1077a7d:	mov    %rdi,%r15
 1077a80:	sub    %r8,%r15
 1077a83:	sub    %r15,%r13
 1077a86:	jmp    1077a8b <check_input_run+0xad7b>
 1077a88:	xor    %r11d,%r11d
 1077a8b:	mov    0x54(%rsi,%rcx,1),%r12d
 1077a90:	cmp    %r10,%r15
 1077a93:	ja     1077a38 <check_input_run+0xad28>
 1077a95:	mov    %r14,%rbx
 1077a98:	mov    %rbp,%r14
 1077a9b:	lea    0x4(,%r12,4),%rbp
 1077aa3:	cmp    %r13,%rbp
 1077aa6:	ja     1077ac4 <check_input_run+0xadb4>
 1077aa8:	mov    0x860(%rsp),%r9
 1077ab0:	add    %r15,%rbp
 1077ab3:	mov    %rbp,0x2aa40(%r9)
 1077aba:	mov    %rbp,%r9
 1077abd:	mov    0x54(%rsi,%rcx,1),%r12d
 1077ac2:	jmp    1077ac6 <check_input_run+0xadb6>
 1077ac4:	xor    %edi,%edi
 1077ac6:	mov    %r14,%rbp
 1077ac9:	mov    %rbx,%r14
 1077acc:	mov    0xc8(%rsp),%rbx
 1077ad4:	sub    %r9,%r10
 1077ad7:	jb     1077b00 <check_input_run+0xadf0>
 1077ad9:	mov    $0x0,%r15d
 1077adf:	cmp    %r12,%r10
 1077ae2:	jbe    1077b03 <check_input_run+0xadf3>
 1077ae4:	mov    0x860(%rsp),%r10
 1077aec:	add    %r9,%r8
 1077aef:	lea    0x1(%r12,%r9,1),%r9
 1077af4:	mov    %r8,%r15
 1077af7:	mov    %r9,0x2aa40(%r10)
 1077afe:	jmp    1077b03 <check_input_run+0xadf3>
 1077b00:	xor    %r15d,%r15d
 1077b03:	mov    0x860(%rsp),%r12
 1077b0b:	mov    0x70(%rsp),%r10
 1077b10:	add    %rcx,%rsi
 1077b13:	mov    0x58(%r12),%r8d
 1077b18:	mov    0xb0(%r12),%r9d
 1077b20:	mov    %rsi,-0x28(%rax)
 1077b24:	mov    %r10,-0x20(%rax)
 1077b28:	mov    %r8d,-0x18(%rax)
 1077b2c:	mov    %r9d,-0x14(%rax)
 1077b30:	mov    %r11,-0x10(%rax)
 1077b34:	mov    %rdi,-0x8(%rax)
 1077b38:	mov    %r15,(%rax)
 1077b3b:	test   %r11,%r11
 1077b3e:	je     1078f8e <check_input_run+0xc27e>
 1077b44:	test   %rdi,%rdi
 1077b47:	setne  %dil
 1077b4b:	test   %r15,%r15
 1077b4e:	setne  %sil
 1077b52:	and    %dil,%sil
 1077b55:	cmp    $0x1,%sil
 1077b59:	jne    1077b73 <check_input_run+0xae63>
 1077b5b:	add    $0x30,%rax
 1077b5f:	add    $0x150,%rcx
 1077b66:	cmp    %r14,%rdx
 1077b69:	lea    0x1(%rdx),%rdx
 1077b6d:	jb     10779fe <check_input_run+0xacee>
 1077b73:	mov    0x2aa40(%r12),%r13
 1077b7b:	test   %sil,%sil
 1077b7e:	je     1078f9b <check_input_run+0xc28b>
 1077b84:	mov    0xe8(%rsp),%r9
 1077b8c:	mov    0x70(%rsp),%r10
 1077b91:	mov    %r14d,%eax
 1077b94:	inc    %eax
 1077b96:	mov    %eax,0x100(%rsp)
 1077b9d:	je     1077bcb <check_input_run+0xaebb>
 1077b9f:	mov    0x8(%r12),%rax
 1077ba4:	cmpq   $0x0,0x108(%rax)
 1077bac:	mov    %rax,0xa8(%rsp)
 1077bb4:	jne    1077bcb <check_input_run+0xaebb>
 1077bb6:	mov    0xa8(%rsp),%rax
 1077bbe:	cmpl   $0x0,0x114(%rax)
 1077bc5:	je     1079c27 <check_input_run+0xcf17>
 1077bcb:	mov    %rbp,%r15
 1077bce:	xor    %edx,%edx
 1077bd0:	mov    0x860(%rsp),%r12
 1077bd8:	cmp    0x2aa40(%r12),%r13
 1077be0:	ja     107a28f <check_input_run+0xd57f>
 1077be6:	mov    %r13,0x2aa40(%r12)
 1077bee:	mov    %r15,%rbp
 1077bf1:	test   %dl,%dl
 1077bf3:	je     1077c1d <check_input_run+0xaf0d>
 1077bf5:	movzbl 0x2aaa1(%r12),%eax
 1077bfe:	xor    $0x1,%al
 1077c00:	jmp    1077c1f <check_input_run+0xaf0f>
 1077c02:	mov    0x2aa40(%r12),%r13
 1077c0a:	mov    0xe8(%rsp),%r9
 1077c12:	mov    %r11,%r10
 1077c15:	test   %r14,%r14
 1077c18:	setne  0x58(%rsp)
 1077c1d:	xor    %eax,%eax
 1077c1f:	mov    0x2aa38(%r12),%rdi
 1077c27:	shl    $0x2,%rbx
 1077c2b:	lea    0x3(%r13,%rdi,1),%rcx
 1077c30:	lea    0x0(%r13,%rdi,1),%rdx
 1077c35:	and    $0xfffffffffffffffc,%rcx
 1077c39:	cmp    %rdx,%rcx
 1077c3c:	jae    1077c42 <check_input_run+0xaf32>
 1077c3e:	xor    %esi,%esi
 1077c40:	jmp    1077c6d <check_input_run+0xaf5d>
 1077c42:	mov    0x2aa48(%r12),%r8
 1077c4a:	mov    %rcx,%rdx
 1077c4d:	sub    %rdi,%rdx
 1077c50:	xor    %esi,%esi
 1077c52:	sub    %rdx,%r8
 1077c55:	jb     1077c6d <check_input_run+0xaf5d>
 1077c57:	cmp    %r8,%rbx
 1077c5a:	ja     1077c6d <check_input_run+0xaf5d>
 1077c5c:	add    %rbx,%rdx
 1077c5f:	mov    %rcx,%rsi
 1077c62:	mov    %rdx,%r13
 1077c65:	mov    %rdx,0x2aa40(%r12)
 1077c6d:	test   %rsi,%rsi
 1077c70:	sete   %cl
 1077c73:	xor    $0x1,%al
 1077c75:	or     %cl,%al
 1077c77:	jne    1077c8e <check_input_run+0xaf7e>
 1077c79:	lea    0x3(%r13,%rdi,1),%rax
 1077c7e:	add    %rdi,%r13
 1077c81:	and    $0xfffffffffffffffc,%rax
 1077c85:	cmp    %r13,%rax
 1077c88:	jae    1077e1c <check_input_run+0xb10c>
 1077c8e:	mov    0x860(%rsp),%rax
 1077c96:	mov    0x20(%rsp),%r12
 1077c9b:	mov    0x98(%rsp),%rbx
 1077ca3:	mov    0x50(%rsp),%r14
 1077ca8:	cmpb   $0x1,0x2aa90(%rax)
 1077caf:	jne    1077cf4 <check_input_run+0xafe4>
 1077cb1:	lea    0x780(%rsp),%rsi
 1077cb9:	mov    $0x1,%edi
 1077cbe:	vpxor  %xmm0,%xmm0,%xmm0
 1077cc2:	vmovdqa %xmm0,0x780(%rsp)
 1077ccb:	vzeroupper
 1077cce:	call   7878b0 <clock_gettime@plt>
 1077cd3:	imul   $0x3b9aca00,0x780(%rsp),%rax
 1077cdf:	mov    0x130(%rsp),%rdx
 1077ce7:	add    0x788(%rsp),%rdx
 1077cef:	add    %rax,%rdx
 1077cf2:	jmp    1077cf6 <check_input_run+0xafe6>
 1077cf4:	xor    %edx,%edx
 1077cf6:	mov    0x860(%rsp),%rax
 1077cfe:	mov    0x90(%rsp),%ecx
 1077d05:	mov    0x210(%rsp),%esi
 1077d0c:	mov    %rdx,0x2aac8(%rax)
 1077d13:	test   %sil,%cl
 1077d16:	je     1077d21 <check_input_run+0xb011>
 1077d18:	lea    -0x96f8db(%rip),%rax        # 708444 <pp_decode_file_name.meaning+0xc734>
 1077d1f:	jmp    1077d24 <check_input_run+0xb014>
 1077d21:	mov    (%r14),%rax
 1077d24:	mov    0x860(%rsp),%rcx
 1077d2c:	mov    %rax,0x2aa60(%rcx)
 1077d33:	or     %sil,0x2aa58(%rcx)
 1077d3a:	or     %sil,0x3bd(%rbx)
 1077d41:	mov    0x2b8(%rsp),%rax
 1077d49:	mov    %rax,0xa8(%rsp)
 1077d51:	mov    0x18(%rsp),%rax
 1077d56:	mov    0x38(%rsp),%rcx
 1077d5b:	cmpl   $0x0,0x230(%rax)
 1077d62:	jne    107283a <check_input_run+0x5b2a>
 1077d68:	cmpb   $0x0,0x3bd(%rax)
 1077d6f:	jne    107283a <check_input_run+0x5b2a>
 1077d75:	mov    0x2a8(%rsp),%rbx
 1077d7d:	mov    0x2c8(%rsp),%rax
 1077d85:	mov    $0x1,%edx
 1077d8a:	mov    0x30(%rbx),%r13d
 1077d8e:	mov    0x8(%rax),%r8
 1077d92:	lea    0x0(%r13,%r13,1),%rcx
 1077d97:	mov    %rdx,%rbp
 1077d9a:	add    %rdx,%rdx
 1077d9d:	cmp    %rcx,%rbp
 1077da0:	jbe    1077d97 <check_input_run+0xb087>
 1077da2:	mov    %rbp,%rcx
 1077da5:	shr    $0x3e,%rcx
 1077da9:	jne    1077ded <check_input_run+0xb0dd>
 1077dab:	mov    (%rax),%rsi
 1077dae:	lea    0x3(%r8,%rsi,1),%r15
 1077db3:	lea    (%r8,%rsi,1),%rcx
 1077db7:	and    $0xfffffffffffffffc,%r15
 1077dbb:	cmp    %rcx,%r15
 1077dbe:	jb     1077ded <check_input_run+0xb0dd>
 1077dc0:	mov    %r15,%rcx
 1077dc3:	sub    %rsi,%rcx
 1077dc6:	mov    0x10(%rax),%rsi
 1077dca:	lea    0x0(,%rbp,4),%rdx
 1077dd2:	sub    %rcx,%rsi
 1077dd5:	setb   %dil
 1077dd9:	cmp    %rsi,%rdx
 1077ddc:	seta   %sil
 1077de0:	or     %dil,%sil
 1077de3:	cmp    $0x1,%sil
 1077de7:	jne    107833e <check_input_run+0xb62e>
 1077ded:	mov    0x2a0(%rsp),%rax
 1077df5:	movb   $0x1,0x3bd(%rax)
 1077dfc:	mov    0x2c8(%rsp),%rax
 1077e04:	cmp    0x8(%rax),%r8
 1077e08:	ja     107a28f <check_input_run+0xd57f>
 1077e0e:	mov    0x38(%rsp),%rcx
 1077e13:	mov    %r8,0x8(%rax)
 1077e17:	jmp    107283a <check_input_run+0x5b2a>
 1077e1c:	mov    0x2aa48(%r12),%r8
 1077e24:	mov    %rax,%r13
 1077e27:	sub    %rdi,%rax
 1077e2a:	mov    %r8,%rcx
 1077e2d:	sub    %rax,%rcx
 1077e30:	jb     1077c8e <check_input_run+0xaf7e>
 1077e36:	mov    %r9,0xe8(%rsp)
 1077e3e:	mov    0x358(%rbp),%r9d
 1077e45:	lea    0x4(,%r9,4),%r11
 1077e4d:	cmp    %rcx,%r11
 1077e50:	ja     1077c8e <check_input_run+0xaf7e>
 1077e56:	mov    0x340(%rbp),%ecx
 1077e5c:	mov    0x320(%rbp),%r15d
 1077e63:	mov    0x330(%rbp),%edx
 1077e69:	add    %r11,%rax
 1077e6c:	mov    %rcx,0x70(%rsp)
 1077e71:	mov    0x4e0(%rsp),%ecx
 1077e78:	mov    %rcx,0xc8(%rsp)
 1077e80:	mov    0x2e0(%rsp),%ecx
 1077e87:	mov    %rcx,0xa8(%rsp)
 1077e8f:	mov    0x468(%rsp),%ecx
 1077e96:	mov    %rax,0x2aa40(%r12)
 1077e9e:	mov    %rcx,0x100(%rsp)
 1077ea6:	test   %r13,%r13
 1077ea9:	je     1077c8e <check_input_run+0xaf7e>
 1077eaf:	add    %r13,%r11
 1077eb2:	mov    %rdx,0xd8(%rsp)
 1077eba:	mov    %r8,%rdx
 1077ebd:	mov    %r11,%rax
 1077ec0:	sub    %rdi,%rax
 1077ec3:	sub    %rax,%rdx
 1077ec6:	jb     1077c8e <check_input_run+0xaf7e>
 1077ecc:	lea    0x4(,%r15,4),%rcx
 1077ed4:	cmp    %rdx,%rcx
 1077ed7:	ja     1077c8e <check_input_run+0xaf7e>
 1077edd:	add    %rcx,%rax
 1077ee0:	mov    %rax,0x2aa40(%r12)
 1077ee8:	test   %r11,%r11
 1077eeb:	je     1077c8e <check_input_run+0xaf7e>
 1077ef1:	add    %r11,%rcx
 1077ef4:	mov    %r8,%rdx
 1077ef7:	mov    %r15,0xa0(%rsp)
 1077eff:	mov    %r10,0x48(%rsp)
 1077f04:	mov    %r9,0x68(%rsp)
 1077f09:	mov    %r14,0x60(%rsp)
 1077f0e:	mov    %rbp,0xc0(%rsp)
 1077f16:	mov    %r11,0x110(%rsp)
 1077f1e:	mov    %rcx,%rax
 1077f21:	sub    %rdi,%rax
 1077f24:	mov    %rcx,0x88(%rsp)
 1077f2c:	sub    %rax,%rdx
 1077f2f:	jb     1077c8e <check_input_run+0xaf7e>
 1077f35:	mov    0xd8(%rsp),%r9
 1077f3d:	lea    0x4(,%r9,4),%r9
 1077f45:	cmp    %rdx,%r9
 1077f48:	ja     1077c8e <check_input_run+0xaf7e>
 1077f4e:	add    %r9,%rax
 1077f51:	mov    0x860(%rsp),%rdx
 1077f59:	cmpq   $0x0,0x88(%rsp)
 1077f62:	mov    %rax,0x2aa40(%rdx)
 1077f69:	je     1077c8e <check_input_run+0xaf7e>
 1077f6f:	mov    %r9,%rax
 1077f72:	add    0x88(%rsp),%rax
 1077f7a:	mov    %r8,%rdx
 1077f7d:	mov    %rax,0x150(%rsp)
 1077f85:	sub    %rdi,%rax
 1077f88:	sub    %rax,%rdx
 1077f8b:	jb     1077c8e <check_input_run+0xaf7e>
 1077f91:	mov    0x70(%rsp),%r9
 1077f96:	lea    0x4(,%r9,4),%r9
 1077f9e:	cmp    %rdx,%r9
 1077fa1:	ja     1077c8e <check_input_run+0xaf7e>
 1077fa7:	add    %r9,%rax
 1077faa:	mov    0x860(%rsp),%rdx
 1077fb2:	cmpq   $0x0,0x150(%rsp)
 1077fbb:	mov    %r9,%rcx
 1077fbe:	mov    %rax,0x2aa40(%rdx)
 1077fc5:	je     1077c8e <check_input_run+0xaf7e>
 1077fcb:	add    0x150(%rsp),%rcx
 1077fd3:	mov    %rcx,%rax
 1077fd6:	and    $0xfffffffffffffffc,%rax
 1077fda:	mov    %rcx,0x118(%rsp)
 1077fe2:	cmp    %rcx,%rax
 1077fe5:	jne    1077c8e <check_input_run+0xaf7e>
 1077feb:	sub    %rdi,%rax
 1077fee:	mov    %r8,%rdx
 1077ff1:	sub    %rax,%rdx
 1077ff4:	jb     1077c8e <check_input_run+0xaf7e>
 1077ffa:	mov    0xc8(%rsp),%r9
 1078002:	lea    0x4(,%r9,4),%r9
 107800a:	cmp    %rdx,%r9
 107800d:	ja     1077c8e <check_input_run+0xaf7e>
 1078013:	add    %r9,%rax
 1078016:	mov    0x860(%rsp),%rdx
 107801e:	cmpq   $0x0,0x118(%rsp)
 1078027:	mov    %r9,%rcx
 107802a:	mov    %rax,0x2aa40(%rdx)
 1078031:	je     1077c8e <check_input_run+0xaf7e>
 1078037:	mov    %rcx,%rdx
 107803a:	add    0x118(%rsp),%rdx
 1078042:	mov    %r8,%r9
 1078045:	mov    %rdx,0x148(%rsp)
 107804d:	sub    %rdi,%rdx
 1078050:	sub    %rdx,%r9
 1078053:	jb     1077c8e <check_input_run+0xaf7e>
 1078059:	mov    0x100(%rsp),%rax
 1078061:	lea    0x4(,%rax,4),%rax
 1078069:	cmp    %r9,%rax
 107806c:	ja     1077c8e <check_input_run+0xaf7e>
 1078072:	add    %rax,%rdx
 1078075:	mov    0x860(%rsp),%r9
 107807d:	cmpq   $0x0,0x148(%rsp)
 1078086:	mov    %rdx,0x2aa40(%r9)
 107808d:	je     1077c8e <check_input_run+0xaf7e>
 1078093:	add    0x148(%rsp),%rax
 107809b:	mov    %r8,%r9
 107809e:	mov    %rax,%rdx
 10780a1:	sub    %rdi,%rdx
 10780a4:	sub    %rdx,%r9
 10780a7:	jb     1077c8e <check_input_run+0xaf7e>
 10780ad:	mov    0xa8(%rsp),%rcx
 10780b5:	lea    0x4(,%rcx,4),%r11
 10780bd:	cmp    %r9,%r11
 10780c0:	ja     1077c8e <check_input_run+0xaf7e>
 10780c6:	mov    0x860(%rsp),%r9
 10780ce:	add    %r11,%rdx
 10780d1:	mov    %r11,%r10
 10780d4:	mov    %rdx,0x2aa40(%r9)
 10780db:	test   %rax,%rax
 10780de:	je     1077c8e <check_input_run+0xaf7e>
 10780e4:	mov    %r10,%rdx
 10780e7:	add    %rax,%rdx
 10780ea:	mov    %r8,%r9
 10780ed:	mov    %rdx,0x80(%rsp)
 10780f5:	sub    %rdi,%rdx
 10780f8:	sub    %rdx,%r9
 10780fb:	jb     1077c8e <check_input_run+0xaf7e>
 1078101:	cmp    %r9,%rbx
 1078104:	ja     1077c8e <check_input_run+0xaf7e>
 107810a:	add    %rbx,%rdx
 107810d:	mov    0x860(%rsp),%r9
 1078115:	cmpq   $0x0,0x80(%rsp)
 107811e:	mov    %rdx,0x2aa40(%r9)
 1078125:	je     1077c8e <check_input_run+0xaf7e>
 107812b:	mov    0x80(%rsp),%rdx
 1078133:	lea    (%rdx,%rbx,1),%rcx
 1078137:	mov    %rcx,%rdx
 107813a:	and    $0xfffffffffffffffc,%rdx
 107813e:	mov    %rcx,0xb0(%rsp)
 1078146:	cmp    %rcx,%rdx
 1078149:	jne    1077c8e <check_input_run+0xaf7e>
 107814f:	sub    %rdi,%rdx
 1078152:	mov    %r8,%r9
 1078155:	sub    %rdx,%r9
 1078158:	jb     1077c8e <check_input_run+0xaf7e>
 107815e:	cmp    %r9,%rbx
 1078161:	ja     1077c8e <check_input_run+0xaf7e>
 1078167:	add    %rbx,%rdx
 107816a:	mov    0x860(%rsp),%r9
 1078172:	cmpq   $0x0,0xb0(%rsp)
 107817b:	mov    %rdx,0x2aa40(%r9)
 1078182:	je     1077c8e <check_input_run+0xaf7e>
 1078188:	mov    0xb0(%rsp),%rcx
 1078190:	mov    %r8,%r9
 1078193:	lea    (%rcx,%rbx,1),%rdx
 1078197:	mov    %rdx,0xf8(%rsp)
 107819f:	sub    %rdi,%rdx
 10781a2:	sub    %rdx,%r9
 10781a5:	jb     1077c8e <check_input_run+0xaf7e>
 10781ab:	cmp    %r9,%rbx
 10781ae:	ja     1077c8e <check_input_run+0xaf7e>
 10781b4:	add    %rbx,%rdx
 10781b7:	mov    0x860(%rsp),%r9
 10781bf:	cmpq   $0x0,0xf8(%rsp)
 10781c8:	mov    %rdx,0x2aa40(%r9)
 10781cf:	je     1077c8e <check_input_run+0xaf7e>
 10781d5:	mov    0xf8(%rsp),%rcx
 10781dd:	mov    %r8,%r9
 10781e0:	lea    (%rcx,%rbx,1),%rdx
 10781e4:	mov    %rdx,0x1a0(%rsp)
 10781ec:	sub    %rdi,%rdx
 10781ef:	sub    %rdx,%r9
 10781f2:	jb     1077c8e <check_input_run+0xaf7e>
 10781f8:	cmp    %r9,%rbx
 10781fb:	ja     1077c8e <check_input_run+0xaf7e>
 1078201:	add    %rbx,%rdx
 1078204:	mov    0x860(%rsp),%r9
 107820c:	cmpq   $0x0,0x1a0(%rsp)
 1078215:	mov    %rdx,0x2aa40(%r9)
 107821c:	je     1077c8e <check_input_run+0xaf7e>
 1078222:	mov    0x1a0(%rsp),%rcx
 107822a:	mov    %r8,%r9
 107822d:	lea    (%rcx,%rbx,1),%rdx
 1078231:	mov    %rdx,0x198(%rsp)
 1078239:	sub    %rdi,%rdx
 107823c:	sub    %rdx,%r9
 107823f:	jb     1077c8e <check_input_run+0xaf7e>
 1078245:	cmp    %r9,%rbx
 1078248:	ja     1077c8e <check_input_run+0xaf7e>
 107824e:	add    %rbx,%rdx
 1078251:	mov    0x860(%rsp),%r9
 1078259:	cmpq   $0x0,0x198(%rsp)
 1078262:	mov    %rdx,0x2aa40(%r9)
 1078269:	je     1077c8e <check_input_run+0xaf7e>
 107826f:	mov    0x198(%rsp),%rcx
 1078277:	mov    %r8,%r9
 107827a:	lea    (%rcx,%rbx,1),%rdx
 107827e:	mov    %rdx,0x180(%rsp)
 1078286:	sub    %rdi,%rdx
 1078289:	sub    %rdx,%r9
 107828c:	jb     1077c8e <check_input_run+0xaf7e>
 1078292:	cmp    %r9,%rbx
 1078295:	ja     1077c8e <check_input_run+0xaf7e>
 107829b:	add    %rbx,%rdx
 107829e:	mov    0x860(%rsp),%r9
 10782a6:	cmpq   $0x0,0x180(%rsp)
 10782af:	mov    %rdx,0x2aa40(%r9)
 10782b6:	je     1077c8e <check_input_run+0xaf7e>
 10782bc:	mov    0x180(%rsp),%rcx
 10782c4:	add    %rbx,%rcx
 10782c7:	mov    %rcx,%r9
 10782ca:	and    $0xfffffffffffffffc,%r9
 10782ce:	mov    %rcx,0x1a8(%rsp)
 10782d6:	cmp    %rcx,%r9
 10782d9:	jne    1077c8e <check_input_run+0xaf7e>
 10782df:	sub    %rdi,%r9
 10782e2:	sub    %r9,%r8
 10782e5:	jb     1077c8e <check_input_run+0xaf7e>
 10782eb:	cmp    %r8,%rbx
 10782ee:	ja     1077c8e <check_input_run+0xaf7e>
 10782f4:	add    %rbx,%r9
 10782f7:	mov    0x860(%rsp),%rdi
 10782ff:	cmpq   $0x0,0x1a8(%rsp)
 1078308:	mov    %r9,0x2aa40(%rdi)
 107830f:	je     1077c8e <check_input_run+0xaf7e>
 1078315:	cmpq   $0x0,0x60(%rsp)
 107831b:	je     107a99c <check_input_run+0xdc8c>
 1078321:	mov    0x60(%rsp),%r8
 1078326:	mov    %r8d,%edi
 1078329:	and    $0x7,%edi
 107832c:	cmp    $0x8,%r8d
 1078330:	jae    107a8b2 <check_input_run+0xdba2>
 1078336:	xor    %r8d,%r8d
 1078339:	jmp    107a968 <check_input_run+0xdc58>
 107833e:	add    %rdx,%rcx
 1078341:	test   %r15,%r15
 1078344:	mov    %rcx,0x8(%rax)
 1078348:	sete   %al
 107834b:	mov    0x2a0(%rsp),%rcx
 1078353:	or     %al,0x3bd(%rcx)
 1078359:	test   %r15,%r15
 107835c:	je     1077dfc <check_input_run+0xb0ec>
 1078362:	mov    %r8,0x98(%rsp)
 107836a:	xor    %r12d,%r12d
 107836d:	mov    %r15,%rdi
 1078370:	xor    %esi,%esi
 1078372:	vzeroupper
 1078375:	call   788120 <memset@plt>
 107837a:	test   %r13,%r13
 107837d:	je     1078aec <check_input_run+0xbddc>
 1078383:	dec    %rbp
 1078386:	mov    $0xffffffff,%r14d
 107838c:	mov    $0xffffffff,%esi
 1078391:	xor    %edx,%edx
 1078393:	mov    %rbx,0x28(%rsp)
 1078398:	mov    %r15,0x50(%rsp)
 107839d:	jmp    10783ad <check_input_run+0xb69d>
 107839f:	mov    %edx,%esi
 10783a1:	inc    %rdx
 10783a4:	cmp    %r13,%rdx
 10783a7:	je     1078756 <check_input_run+0xba46>
 10783ad:	mov    0x2a0(%rsp),%rdi
 10783b5:	mov    0x1f0(%rdi),%rax
 10783bc:	test   %rax,%rax
 10783bf:	je     10783c7 <check_input_run+0xb6b7>
 10783c1:	cmpb   $0x0,(%rax,%rdx,1)
 10783c5:	jne    10783a1 <check_input_run+0xb691>
 10783c7:	mov    0x10(%rbx),%r9
 10783cb:	mov    0x50(%rbx),%r11
 10783cf:	mov    %r12d,%ecx
 10783d2:	cmp    %rcx,%rdx
 10783d5:	cmova  %r14d,%esi
 10783d9:	movzbl (%r11,%rdx,1),%eax
 10783de:	movzbl (%r9,%rdx,1),%r8d
 10783e3:	cmp    $0x34,%eax
 10783e6:	je     10784df <check_input_run+0xb7cf>
 10783ec:	cmp    $0x21,%eax
 10783ef:	jne    107850b <check_input_run+0xb7fb>
 10783f5:	cmp    $0xffffffff,%esi
 10783f8:	je     1078525 <check_input_run+0xb815>
 10783fe:	mov    0x610(%rsp),%rax
 1078406:	mov    (%rax,%rdx,4),%eax
 1078409:	cmp    %r13d,%eax
 107840c:	jae    1078525 <check_input_run+0xb815>
 1078412:	cmpb   $0x2,(%r9,%rax,1)
 1078417:	jne    1078525 <check_input_run+0xb815>
 107841d:	mov    0x2e0(%rdi),%rcx
 1078424:	mov    %esi,%edi
 1078426:	mov    %esi,(%rcx,%rdx,4)
 1078429:	movabs $0x9e3779b97f4a7c15,%rcx
 1078433:	mov    0x18(%rbx),%r8
 1078437:	mov    (%r8,%rax,4),%r9d
 107843b:	mov    %r9,%rax
 107843e:	imul   %rcx,%rax
 1078442:	add    %rax,%rdi
 1078445:	and    %rbp,%rdi
 1078448:	mov    (%r15,%rdi,4),%r11d
 107844c:	test   %r11d,%r11d
 107844f:	je     10786e1 <check_input_run+0xb9d1>
 1078455:	mov    0x2a0(%rsp),%rax
 107845d:	mov    0x2e0(%rax),%r10
 1078464:	jmp    1078479 <check_input_run+0xb769>
 1078466:	inc    %rdi
 1078469:	and    %rbp,%rdi
 107846c:	mov    (%r15,%rdi,4),%r11d
 1078470:	test   %r11d,%r11d
 1078473:	je     10786e1 <check_input_run+0xb9d1>
 1078479:	dec    %r11d
 107847c:	cmp    %esi,(%r10,%r11,4)
 1078480:	jne    1078466 <check_input_run+0xb756>
 1078482:	mov    0x610(%rsp),%rcx
 107848a:	mov    (%rcx,%r11,4),%ecx
 107848e:	cmp    %r9d,(%r8,%rcx,4)
 1078492:	jne    1078466 <check_input_run+0xb756>
 1078494:	mov    0x230(%rax),%ecx
 107849a:	cmp    0x234(%rax),%ecx
 10784a0:	jae    10786ca <check_input_run+0xb9ba>
 10784a6:	movzbl 0x3bd(%rax),%r8d
 10784ae:	mov    0x228(%rax),%r9
 10784b5:	lea    0x1(%rcx),%r10d
 10784b9:	mov    %r10d,0x230(%rax)
 10784c0:	lea    (%rcx,%rcx,2),%rax
 10784c4:	xor    $0x5,%r8d
 10784c8:	mov    %edx,(%r9,%rax,4)
 10784cc:	mov    %r8d,0x4(%r9,%rax,4)
 10784d1:	movl   $0x0,0x8(%r9,%rax,4)
 10784da:	jmp    10786d1 <check_input_run+0xb9c1>
 10784df:	mov    0x60(%rbx),%rax
 10784e3:	mov    (%rax,%rdx,4),%r12d
 10784e7:	cmp    $0x4f,%r8b
 10784eb:	jne    107839f <check_input_run+0xb68f>
 10784f1:	mov    0x348(%rdi),%rax
 10784f8:	mov    %edx,%esi
 10784fa:	cmpl   $0x0,(%rax,%rdx,4)
 10784fe:	mov    %edx,%eax
 1078500:	jne    10783a1 <check_input_run+0xb691>
 1078506:	jmp    1078682 <check_input_run+0xb972>
 107850b:	cmp    $0x4f,%r8b
 107850f:	jne    107856f <check_input_run+0xb85f>
 1078511:	mov    0x348(%rdi),%rcx
 1078518:	cmpl   $0x0,(%rcx,%rdx,4)
 107851c:	jne    1078578 <check_input_run+0xb868>
 107851e:	mov    %esi,%eax
 1078520:	jmp    1078682 <check_input_run+0xb972>
 1078525:	mov    0x230(%rdi),%eax
 107852b:	cmp    0x234(%rdi),%eax
 1078531:	jae    107866a <check_input_run+0xb95a>
 1078537:	movzbl 0x3bd(%rdi),%ecx
 107853e:	mov    0x228(%rdi),%r8
 1078545:	lea    0x1(%rax),%r9d
 1078549:	lea    (%rax,%rax,2),%rax
 107854d:	mov    %r9d,0x230(%rdi)
 1078554:	lea    0x1(%rcx,%rcx,2),%ecx
 1078558:	mov    %edx,(%r8,%rax,4)
 107855c:	mov    %ecx,0x4(%r8,%rax,4)
 1078561:	movl   $0x0,0x8(%r8,%rax,4)
 107856a:	jmp    10783a1 <check_input_run+0xb691>
 107856f:	cmp    $0x9,%eax
 1078572:	je     1078676 <check_input_run+0xb966>
 1078578:	cmp    $0x3a,%eax
 107857b:	jne    10783a1 <check_input_run+0xb691>
 1078581:	mov    0x60(%rbx),%rax
 1078585:	mov    (%rax,%rdx,4),%ebx
 1078588:	cmp    %r13d,%ebx
 107858b:	jae    1078627 <check_input_run+0xb917>
 1078591:	mov    (%rax,%rbx,4),%r10d
 1078595:	cmp    %r13d,%r10d
 1078598:	jae    10785c7 <check_input_run+0xb8b7>
 107859a:	mov    0x610(%rsp),%r14
 10785a2:	jmp    10785ad <check_input_run+0xb89d>
 10785a4:	mov    (%rax,%rcx,4),%r10d
 10785a8:	cmp    %r13d,%r10d
 10785ab:	jae    10785c7 <check_input_run+0xb8b7>
 10785ad:	mov    %r10d,%ecx
 10785b0:	cmpb   $0x49,(%r11,%rcx,1)
 10785b5:	jne    10785a4 <check_input_run+0xb894>
 10785b7:	mov    (%r14,%rcx,4),%r8d
 10785bb:	cmp    %r13d,%r8d
 10785be:	jae    10785a4 <check_input_run+0xb894>
 10785c0:	cmpb   $0x49,(%r9,%r8,1)
 10785c5:	jne    10785a4 <check_input_run+0xb894>
 10785c7:	cmp    %r13d,%r10d
 10785ca:	jae    1078627 <check_input_run+0xb917>
 10785cc:	mov    0x2a8(%rsp),%rax
 10785d4:	mov    0x30(%rax),%r9d
 10785d8:	cmp    %r9d,%ebx
 10785db:	jae    107869c <check_input_run+0xb98c>
 10785e1:	mov    0x318(%rdi),%r11
 10785e8:	mov    %ebx,%ecx
 10785ea:	jmp    10785fd <check_input_run+0xb8ed>
 10785ec:	mov    0x60(%rax),%rcx
 10785f0:	mov    (%rcx,%r14,4),%ecx
 10785f4:	cmp    %r9d,%ecx
 10785f7:	jae    107869c <check_input_run+0xb98c>
 10785fd:	mov    %ecx,%r14d
 1078600:	mov    (%r11,%r14,4),%r8d
 1078604:	test   %r8d,%r8d
 1078607:	je     10785ec <check_input_run+0xb8dc>
 1078609:	mov    0x310(%rdi),%rcx
 1078610:	dec    %r8d
 1078613:	lea    (%r8,%r8,2),%r8
 1078617:	cmp    (%rcx,%r8,8),%r10d
 107861b:	jbe    1078627 <check_input_run+0xb917>
 107861d:	lea    (%rcx,%r8,8),%rcx
 1078621:	cmp    0x4(%rcx),%r10d
 1078625:	jb     10785ec <check_input_run+0xb8dc>
 1078627:	mov    0x230(%rdi),%eax
 107862d:	cmp    0x234(%rdi),%eax
 1078633:	jae    1078693 <check_input_run+0xb983>
 1078635:	movzbl 0x3bd(%rdi),%ecx
 107863c:	mov    0x228(%rdi),%r8
 1078643:	lea    0x1(%rax),%r9d
 1078647:	lea    (%rax,%rax,2),%rax
 107864b:	mov    %r9d,0x230(%rdi)
 1078652:	lea    0x1(%rcx,%rcx,2),%ecx
 1078656:	mov    %edx,(%r8,%rax,4)
 107865a:	mov    %ecx,0x4(%r8,%rax,4)
 107865f:	movl   $0x0,0x8(%r8,%rax,4)
 1078668:	jmp    10786ba <check_input_run+0xb9aa>
 107866a:	movb   $0x1,0x3bd(%rdi)
 1078671:	jmp    10783a1 <check_input_run+0xb691>
 1078676:	mov    %esi,%eax
 1078678:	cmp    $0xf,%r8b
 107867c:	jne    10783a1 <check_input_run+0xb691>
 1078682:	mov    0x2e0(%rdi),%rcx
 1078689:	mov    %eax,%esi
 107868b:	mov    %eax,(%rcx,%rdx,4)
 107868e:	jmp    10783a1 <check_input_run+0xb691>
 1078693:	movb   $0x1,0x3bd(%rdi)
 107869a:	jmp    10786ba <check_input_run+0xb9aa>
 107869c:	mov    0x2f8(%rdi),%rax
 10786a3:	mov    %r10d,(%rax,%rdx,4)
 10786a7:	mov    0x2a0(%rsp),%rax
 10786af:	mov    0x2f8(%rax),%rax
 10786b6:	mov    %r10d,(%rax,%rbx,4)
 10786ba:	mov    0x28(%rsp),%rbx
 10786bf:	mov    $0xffffffff,%r14d
 10786c5:	jmp    10783a1 <check_input_run+0xb691>
 10786ca:	movb   $0x1,0x3bd(%rax)
 10786d1:	mov    0x28(%rsp),%rbx
 10786d6:	mov    0x50(%rsp),%r15
 10786db:	mov    $0xffffffff,%r14d
 10786e1:	lea    0x1(%rdx),%eax
 10786e4:	mov    %eax,(%r15,%rdi,4)
 10786e8:	jmp    10783a1 <check_input_run+0xb691>
 10786ed:	mov    (%r12),%ecx
 10786f1:	xor    %eax,%eax
 10786f3:	dec    %ecx
 10786f5:	cmp    $0x40,%ecx
 10786f8:	lea    -0x9d12c2(%rip),%rcx        # 6a743d <pp_string_value.meaning+0x1eebc>
 10786ff:	setb   %bpl
 1078703:	cmovae %rcx,%rax
 1078707:	jmp    10764f2 <check_input_run+0x97e2>
 107870c:	mov    0x18(%rsp),%rdi
 1078711:	mov    0x10(%rsp),%rsi
 1078716:	movq   $0x0,0x240(%rdi)
 1078721:	movq   $0x0,0x248(%rdi)
 107872c:	movq   $0x0,0x260(%rdi)
 1078737:	jmp    106d556 <check_input_run+0x846>
 107873c:	inc    %rdx
 107873f:	add    %rsi,%rdx
 1078742:	mov    %rdx,0x8(%rcx)
 1078746:	mov    %rax,0x210(%rsp)
 107874e:	mov    %r11,%r8
 1078751:	jmp    1074a1d <check_input_run+0x7d0d>
 1078756:	mov    $0xffffffff,%r14d
 107875c:	xor    %esi,%esi
 107875e:	jmp    1078772 <check_input_run+0xba62>
 1078760:	inc    %rsi
 1078763:	mov    %rsi,%rdx
 1078766:	mov    %rdx,%rsi
 1078769:	cmp    %r13,%rdx
 107876c:	je     1078aec <check_input_run+0xbddc>
 1078772:	mov    0x2a0(%rsp),%r9
 107877a:	mov    0x1f0(%r9),%rax
 1078781:	test   %rax,%rax
 1078784:	je     107878c <check_input_run+0xba7c>
 1078786:	cmpb   $0x0,(%rax,%rsi,1)
 107878a:	jne    1078760 <check_input_run+0xba50>
 107878c:	mov    0x10(%rbx),%r12
 1078790:	lea    0x1(%rsi),%rdx
 1078794:	movzbl (%r12,%rsi,1),%edi
 1078799:	cmp    $0x4f,%dil
 107879d:	je     1078866 <check_input_run+0xbb56>
 10787a3:	mov    0x50(%rbx),%rax
 10787a7:	cmp    $0xf,%dil
 10787ab:	jne    10787b7 <check_input_run+0xbaa7>
 10787ad:	cmpb   $0x9,(%rax,%rsi,1)
 10787b1:	je     10788b7 <check_input_run+0xbba7>
 10787b7:	cmp    $0x30,%dil
 10787bb:	jne    1078766 <check_input_run+0xba56>
 10787bd:	mov    0x288(%r9),%rcx
 10787c4:	cmpq   $0x0,(%rcx,%rsi,8)
 10787c9:	je     1078766 <check_input_run+0xba56>
 10787cb:	mov    0x60(%rbx),%rcx
 10787cf:	mov    (%rcx,%rsi,4),%r8d
 10787d3:	cmp    %r13d,%r8d
 10787d6:	jae    107881c <check_input_run+0xbb0c>
 10787d8:	mov    0x610(%rsp),%rdi
 10787e0:	jmp    10787eb <check_input_run+0xbadb>
 10787e2:	mov    (%rcx,%r8,4),%r8d
 10787e6:	cmp    %r13d,%r8d
 10787e9:	jae    107881c <check_input_run+0xbb0c>
 10787eb:	mov    %r8d,%r8d
 10787ee:	cmpb   $0x49,(%rax,%r8,1)
 10787f3:	jne    10787e2 <check_input_run+0xbad2>
 10787f5:	mov    (%rdi,%r8,4),%r10d
 10787f9:	cmp    %r13d,%r10d
 10787fc:	jae    10787e2 <check_input_run+0xbad2>
 10787fe:	movzbl (%r12,%r10,1),%r10d
 1078803:	mov    (%rcx,%r8,4),%r8d
 1078807:	cmp    %r13d,%r8d
 107880a:	jae    1078812 <check_input_run+0xbb02>
 107880c:	cmp    $0x49,%r10b
 1078810:	jne    10787eb <check_input_run+0xbadb>
 1078812:	cmp    $0x49,%r10b
 1078816:	je     1078766 <check_input_run+0xba56>
 107881c:	mov    0x230(%r9),%eax
 1078823:	cmp    0x234(%r9),%eax
 107882a:	jae    1078a20 <check_input_run+0xbd10>
 1078830:	movzbl 0x3bd(%r9),%ecx
 1078838:	mov    0x228(%r9),%rdi
 107883f:	lea    0x1(%rax),%r8d
 1078843:	lea    (%rax,%rax,2),%rax
 1078847:	mov    %r8d,0x230(%r9)
 107884e:	lea    0x1(%rcx,%rcx,2),%ecx
 1078852:	mov    %esi,(%rdi,%rax,4)
 1078855:	mov    %ecx,0x4(%rdi,%rax,4)
 1078859:	movl   $0x0,0x8(%rdi,%rax,4)
 1078861:	jmp    1078766 <check_input_run+0xba56>
 1078866:	mov    0x30(%rbx),%eax
 1078869:	cmp    %rax,%rdx
 107886c:	jae    10788a6 <check_input_run+0xbb96>
 107886e:	mov    0x60(%rbx),%rax
 1078872:	mov    0x4(%rax,%rsi,4),%eax
 1078876:	cmp    %rax,%rsi
 1078879:	jne    10788a6 <check_input_run+0xbb96>
 107887b:	mov    0x50(%rbx),%rax
 107887f:	cmpb   $0x1a,(%rax,%rdx,1)
 1078883:	jne    10788a6 <check_input_run+0xbb96>
 1078885:	mov    0x348(%r9),%rax
 107888c:	cmpl   $0x0,(%rax,%rsi,4)
 1078890:	jne    10788a6 <check_input_run+0xbb96>
 1078892:	cmpb   $0x11,0x1(%r12,%rsi,1)
 1078898:	jne    10788a6 <check_input_run+0xbb96>
 107889a:	incl   0x678(%rsp)
 10788a1:	jmp    1078766 <check_input_run+0xba56>
 10788a6:	mov    0x348(%r9),%rax
 10788ad:	cmpl   $0x0,(%rax,%rsi,4)
 10788b1:	jne    1078766 <check_input_run+0xba56>
 10788b7:	mov    0x2e0(%r9),%rax
 10788be:	mov    0x610(%rsp),%rcx
 10788c6:	xor    %r11d,%r11d
 10788c9:	mov    (%rax,%rsi,4),%r10d
 10788cd:	mov    (%rcx,%rsi,4),%r8d
 10788d1:	cmp    %r14,%r10
 10788d4:	je     1078a4c <check_input_run+0xbd3c>
 10788da:	cmp    %r13d,%r8d
 10788dd:	jae    1078a4c <check_input_run+0xbd3c>
 10788e3:	cmpb   $0x2,(%r12,%r8,1)
 10788e8:	jne    1078994 <check_input_run+0xbc84>
 10788ee:	mov    0x18(%rbx),%rbx
 10788f2:	mov    %r8,%r11
 10788f5:	movabs $0x9e3779b97f4a7c15,%r8
 10788ff:	mov    %r11,0x90(%rsp)
 1078907:	mov    (%rbx,%r11,4),%r14d
 107890b:	mov    %r14,%r11
 107890e:	imul   %r8,%r11
 1078912:	add    %r10,%r11
 1078915:	and    %rbp,%r11
 1078918:	mov    (%r15,%r11,4),%r12d
 107891c:	test   %r12d,%r12d
 107891f:	je     107899c <check_input_run+0xbc8c>
 1078921:	mov    0x2a8(%rsp),%r8
 1078929:	jmp    107893a <check_input_run+0xbc2a>
 107892b:	inc    %r11
 107892e:	and    %rbp,%r11
 1078931:	mov    (%r15,%r11,4),%r12d
 1078935:	test   %r12d,%r12d
 1078938:	je     107899c <check_input_run+0xbc8c>
 107893a:	dec    %r12d
 107893d:	cmp    %r10d,(%rax,%r12,4)
 1078941:	jne    107892b <check_input_run+0xbc1b>
 1078943:	mov    (%rcx,%r12,4),%ebx
 1078947:	mov    0x18(%r8),%r15
 107894b:	cmp    %r14d,(%r15,%rbx,4)
 107894f:	mov    0x50(%rsp),%r15
 1078954:	jne    107892b <check_input_run+0xbc1b>
 1078956:	mov    0x300(%r9),%rax
 107895d:	mov    $0x1,%r11b
 1078960:	mov    %r12d,(%rax,%rsi,4)
 1078964:	cmp    $0x4f,%dil
 1078968:	jne    1078a34 <check_input_run+0xbd24>
 107896e:	mov    0x2a8(%rsp),%rcx
 1078976:	mov    0x30(%rcx),%r9d
 107897a:	cmp    %r9d,%r12d
 107897d:	jae    1078a34 <check_input_run+0xbd24>
 1078983:	mov    0x2a0(%rsp),%rbx
 107898b:	mov    0x318(%rbx),%r14
 1078992:	jmp    10789b6 <check_input_run+0xbca6>
 1078994:	xor    %r11d,%r11d
 1078997:	jmp    1078a4c <check_input_run+0xbd3c>
 107899c:	mov    0x28(%rsp),%rbx
 10789a1:	xor    %r11d,%r11d
 10789a4:	jmp    1078a3e <check_input_run+0xbd2e>
 10789a9:	mov    0x60(%rcx),%rax
 10789ad:	mov    (%rax,%r8,4),%r12d
 10789b1:	cmp    %r9d,%r12d
 10789b4:	jae    1078a34 <check_input_run+0xbd24>
 10789b6:	mov    %r12d,%r8d
 10789b9:	mov    (%r14,%r8,4),%eax
 10789bd:	test   %eax,%eax
 10789bf:	je     10789a9 <check_input_run+0xbc99>
 10789c1:	mov    0x310(%rbx),%r12
 10789c8:	dec    %eax
 10789ca:	lea    (%rax,%rax,2),%rax
 10789ce:	cmp    %esi,(%r12,%rax,8)
 10789d2:	jae    10789dd <check_input_run+0xbccd>
 10789d4:	lea    (%r12,%rax,8),%rax
 10789d8:	cmp    %esi,0x4(%rax)
 10789db:	ja     10789a9 <check_input_run+0xbc99>
 10789dd:	mov    0x230(%rbx),%ecx
 10789e3:	cmp    0x234(%rbx),%ecx
 10789e9:	jae    1078a2d <check_input_run+0xbd1d>
 10789eb:	movzbl 0x3bd(%rbx),%eax
 10789f2:	mov    0x228(%rbx),%r8
 10789f9:	lea    0x1(%rcx),%r9d
 10789fd:	lea    (%rcx,%rcx,2),%rcx
 1078a01:	mov    %r9d,0x230(%rbx)
 1078a08:	lea    0x1(%rax,%rax,2),%eax
 1078a0c:	mov    %esi,(%r8,%rcx,4)
 1078a10:	mov    %eax,0x4(%r8,%rcx,4)
 1078a15:	movl   $0x0,0x8(%r8,%rcx,4)
 1078a1e:	jmp    1078a34 <check_input_run+0xbd24>
 1078a20:	movb   $0x1,0x3bd(%r9)
 1078a28:	jmp    1078766 <check_input_run+0xba56>
 1078a2d:	movb   $0x1,0x3bd(%rbx)
 1078a34:	mov    0x28(%rsp),%rbx
 1078a39:	mov    0x50(%rsp),%r15
 1078a3e:	mov    0x90(%rsp),%r8
 1078a46:	mov    $0xffffffff,%r14d
 1078a4c:	cmp    %r13d,%r10d
 1078a4f:	jae    1078a70 <check_input_run+0xbd60>
 1078a51:	mov    0x50(%rbx),%rax
 1078a55:	cmpb   $0x34,(%rax,%r10,1)
 1078a5a:	jne    1078a70 <check_input_run+0xbd60>
 1078a5c:	mov    0x60(%rbx),%rax
 1078a60:	mov    (%rax,%r10,4),%eax
 1078a64:	cmp    0x674(%rsp),%eax
 1078a6b:	setae  %al
 1078a6e:	jmp    1078a72 <check_input_run+0xbd62>
 1078a70:	xor    %eax,%eax
 1078a72:	or     %al,%r11b
 1078a75:	test   $0x1,%r11b
 1078a79:	jne    1078766 <check_input_run+0xba56>
 1078a7f:	mov    0x2a0(%rsp),%rax
 1078a87:	mov    0x230(%rax),%ecx
 1078a8d:	cmp    0x234(%rax),%ecx
 1078a93:	jae    1078ae0 <check_input_run+0xbdd0>
 1078a95:	cmp    %r13d,%r8d
 1078a98:	mov    %r8,%r9
 1078a9b:	mov    %esi,%r8d
 1078a9e:	cmovb  %r9d,%r8d
 1078aa2:	cmp    $0x4f,%dil
 1078aa6:	mov    0x228(%rax),%rdi
 1078aad:	lea    0x1(%rcx),%r9d
 1078ab1:	cmove  %esi,%r8d
 1078ab5:	movzbl 0x3bd(%rax),%esi
 1078abc:	mov    %r9d,0x230(%rax)
 1078ac3:	lea    (%rcx,%rcx,2),%rax
 1078ac7:	mov    %r8d,(%rdi,%rax,4)
 1078acb:	lea    0x2(%rsi,%rsi,1),%esi
 1078acf:	mov    %esi,0x4(%rdi,%rax,4)
 1078ad3:	movl   $0x0,0x8(%rdi,%rax,4)
 1078adb:	jmp    1078766 <check_input_run+0xba56>
 1078ae0:	movb   $0x1,0x3bd(%rax)
 1078ae7:	jmp    1078766 <check_input_run+0xba56>
 1078aec:	cmpl   $0x0,0x678(%rsp)
 1078af4:	mov    0x20(%rsp),%r12
 1078af9:	mov    0x98(%rsp),%r8
 1078b01:	je     1077dfc <check_input_run+0xb0ec>
 1078b07:	mov    0x2a8(%rsp),%rax
 1078b0f:	mov    0x30(%rax),%ecx
 1078b12:	test   %ecx,%ecx
 1078b14:	je     1077dfc <check_input_run+0xb0ec>
 1078b1a:	xor    %r10d,%r10d
 1078b1d:	jmp    1078b36 <check_input_run+0xbe26>
 1078b1f:	mov    0x98(%rsp),%r8
 1078b27:	mov    %r13d,%r10d
 1078b2a:	inc    %r10d
 1078b2d:	cmp    %ecx,%r10d
 1078b30:	jae    1077dfc <check_input_run+0xb0ec>
 1078b36:	mov    0x2a0(%rsp),%r9
 1078b3e:	mov    %r10d,%edx
 1078b41:	mov    0x1f0(%r9),%rsi
 1078b48:	test   %rsi,%rsi
 1078b4b:	je     1078b53 <check_input_run+0xbe43>
 1078b4d:	cmpb   $0x0,(%rsi,%rdx,1)
 1078b51:	jne    1078b2a <check_input_run+0xbe1a>
 1078b53:	mov    0x50(%rax),%r15
 1078b57:	mov    0x60(%rax),%r11
 1078b5b:	cmpb   $0x34,(%r15,%rdx,1)
 1078b60:	lea    (%r11,%rdx,4),%rsi
 1078b64:	jne    1078b2a <check_input_run+0xbe1a>
 1078b66:	mov    (%rsi),%r13d
 1078b69:	cmp    %ecx,%r13d
 1078b6c:	jae    1078b2a <check_input_run+0xbe1a>
 1078b6e:	cmp    0x674(%rsp),%r13d
 1078b76:	jae    1078b2a <check_input_run+0xbe1a>
 1078b78:	lea    0x1(%r10),%esi
 1078b7c:	cmp    %r13d,%esi
 1078b7f:	jae    1078b27 <check_input_run+0xbe17>
 1078b81:	mov    $0xffffffff,%r8d
 1078b87:	mov    $0xffffffff,%edi
 1078b8c:	mov    %esi,%r12d
 1078b8f:	xor    %esi,%esi
 1078b91:	movl   $0x0,0x50(%rsp)
 1078b99:	mov    %r13,0x28(%rsp)
 1078b9e:	jmp    1078bbe <check_input_run+0xbeae>
 1078ba0:	mov    0x28(%rsp),%r13
 1078ba5:	cmp    $0xffffffff,%r8d
 1078ba9:	je     1078c2f <check_input_run+0xbf1f>
 1078baf:	mov    %r12d,%r10d
 1078bb2:	inc    %r12
 1078bb5:	cmp    %r12d,%r13d
 1078bb8:	je     1078c96 <check_input_run+0xbf86>
 1078bbe:	cmpb   $0x9,(%r15,%r12,1)
 1078bc3:	jne    1078ba5 <check_input_run+0xbe95>
 1078bc5:	mov    0x10(%rax),%r14
 1078bc9:	cmpb   $0xf,(%r14,%r12,1)
 1078bce:	jne    1078ba5 <check_input_run+0xbe95>
 1078bd0:	mov    0x300(%r9),%r14
 1078bd7:	mov    0x50(%rsp),%edx
 1078bdb:	mov    (%r14,%r12,4),%ebp
 1078bdf:	cmp    $0xffffffff,%ebp
 1078be2:	setne  %r14b
 1078be6:	or     %r14b,%dl
 1078be9:	mov    %edx,0x50(%rsp)
 1078bed:	cmp    %ecx,%ebp
 1078bef:	jae    1078ba5 <check_input_run+0xbe95>
 1078bf1:	mov    0x318(%r9),%r13
 1078bf8:	jmp    1078c02 <check_input_run+0xbef2>
 1078bfa:	mov    (%r11,%r14,4),%ebp
 1078bfe:	cmp    %ecx,%ebp
 1078c00:	jae    1078ba0 <check_input_run+0xbe90>
 1078c02:	mov    %ebp,%r14d
 1078c05:	mov    0x0(%r13,%r14,4),%ebp
 1078c0a:	test   %ebp,%ebp
 1078c0c:	je     1078bfa <check_input_run+0xbeea>
 1078c0e:	mov    0x310(%r9),%rbx
 1078c15:	dec    %ebp
 1078c17:	lea    0x0(%rbp,%rbp,2),%rbp
 1078c1c:	mov    (%rbx,%rbp,8),%edx
 1078c1f:	mov    0x4(%rbx,%rbp,8),%ebx
 1078c23:	cmp    %esi,%edx
 1078c25:	cmova  %edx,%esi
 1078c28:	cmp    %edi,%ebx
 1078c2a:	cmovb  %ebx,%edi
 1078c2d:	jmp    1078bfa <check_input_run+0xbeea>
 1078c2f:	mov    0x10(%rax),%r14
 1078c33:	cmpb   $0x4f,(%r14,%r12,1)
 1078c38:	jne    1078baf <check_input_run+0xbe9f>
 1078c3e:	add    $0x2,%r10d
 1078c42:	cmp    0x30(%rax),%r10d
 1078c46:	jae    1078baf <check_input_run+0xbe9f>
 1078c4c:	mov    %r10d,%r10d
 1078c4f:	mov    (%r11,%r10,4),%edx
 1078c53:	cmp    %rdx,%r12
 1078c56:	jne    1078baf <check_input_run+0xbe9f>
 1078c5c:	cmpb   $0x1a,(%r15,%r10,1)
 1078c61:	jne    1078baf <check_input_run+0xbe9f>
 1078c67:	cmpb   $0x11,(%r14,%r10,1)
 1078c6c:	jne    1078baf <check_input_run+0xbe9f>
 1078c72:	mov    0x348(%r9),%rdx
 1078c79:	cmpl   $0x0,(%rdx,%r12,4)
 1078c7e:	jne    1078baf <check_input_run+0xbe9f>
 1078c84:	mov    %r12d,%r10d
 1078c87:	mov    %r12d,%r8d
 1078c8a:	inc    %r12
 1078c8d:	cmp    %r12d,%r13d
 1078c90:	jne    1078bbe <check_input_run+0xbeae>
 1078c96:	mov    0x50(%rsp),%ebp
 1078c9a:	mov    0x20(%rsp),%r12
 1078c9f:	cmp    $0xffffffff,%r8d
 1078ca3:	sete   %r10b
 1078ca7:	or     %bpl,%r10b
 1078caa:	test   $0x1,%r10b
 1078cae:	jne    1078cfe <check_input_run+0xbfee>
 1078cb0:	mov    0x230(%r9),%r10d
 1078cb7:	cmp    0x234(%r9),%r10d
 1078cbe:	jae    1078cf6 <check_input_run+0xbfe6>
 1078cc0:	movzbl 0x3bd(%r9),%edx
 1078cc8:	mov    0x228(%r9),%r11
 1078ccf:	lea    0x1(%r10),%ebx
 1078cd3:	mov    %ebx,0x230(%r9)
 1078cda:	lea    (%r10,%r10,2),%r9
 1078cde:	lea    0x1(%rdx,%rdx,2),%edx
 1078ce2:	mov    %r8d,(%r11,%r9,4)
 1078ce6:	mov    %edx,0x4(%r11,%r9,4)
 1078ceb:	movl   $0x0,0x8(%r11,%r9,4)
 1078cf4:	jmp    1078cfe <check_input_run+0xbfee>
 1078cf6:	movb   $0x1,0x3bd(%r9)
 1078cfe:	cmp    %r13d,%r8d
 1078d01:	setb   %dl
 1078d04:	test   %dl,%bpl
 1078d07:	je     1078b1f <check_input_run+0xbe0f>
 1078d0d:	mov    %r13d,%edx
 1078d10:	sub    %r8d,%edx
 1078d13:	mov    %r8d,%r10d
 1078d16:	mov    %r10,%r9
 1078d19:	test   $0x1,%dl
 1078d1c:	je     1078dd5 <check_input_run+0xc0c5>
 1078d22:	mov    0x10(%rax),%r11
 1078d26:	lea    0x1(%r10),%r9
 1078d2a:	cmpb   $0x4f,(%r11,%r10,1)
 1078d2f:	jne    1078dd5 <check_input_run+0xc0c5>
 1078d35:	mov    0x30(%rax),%edx
 1078d38:	cmp    %rdx,%r9
 1078d3b:	jae    1078dcb <check_input_run+0xc0bb>
 1078d41:	mov    0x60(%rax),%rdx
 1078d45:	cmp    0x4(%rdx,%r10,4),%r8d
 1078d4a:	jne    1078dcb <check_input_run+0xc0bb>
 1078d4c:	mov    0x50(%rax),%rdx
 1078d50:	cmpb   $0x1a,(%rdx,%r9,1)
 1078d55:	jne    1078dcb <check_input_run+0xc0bb>
 1078d57:	cmpb   $0x11,(%r11,%r9,1)
 1078d5c:	jne    1078dcb <check_input_run+0xc0bb>
 1078d5e:	mov    0x2a0(%rsp),%r11
 1078d66:	mov    0x348(%r11),%rdx
 1078d6d:	cmpl   $0x0,(%rdx,%r10,4)
 1078d72:	jne    1078dcb <check_input_run+0xc0bb>
 1078d74:	cmp    %esi,%r8d
 1078d77:	jbe    1078d7e <check_input_run+0xc06e>
 1078d79:	cmp    %edi,%r8d
 1078d7c:	jb     1078dcb <check_input_run+0xc0bb>
 1078d7e:	mov    0x230(%r11),%ebx
 1078d85:	cmp    0x234(%r11),%ebx
 1078d8c:	jae    1078dc3 <check_input_run+0xc0b3>
 1078d8e:	movzbl 0x3bd(%r11),%edx
 1078d96:	mov    0x228(%r11),%r14
 1078d9d:	lea    0x1(%rbx),%ebp
 1078da0:	mov    %ebp,0x230(%r11)
 1078da7:	lea    (%rbx,%rbx,2),%r11
 1078dab:	lea    0x1(%rdx,%rdx,2),%edx
 1078daf:	mov    %r8d,(%r14,%r11,4)
 1078db3:	mov    %edx,0x4(%r14,%r11,4)
 1078db8:	movl   $0x0,0x8(%r14,%r11,4)
 1078dc1:	jmp    1078dcb <check_input_run+0xc0bb>
 1078dc3:	movb   $0x1,0x3bd(%r11)
 1078dcb:	mov    0x20(%rsp),%r12
 1078dd0:	mov    0x28(%rsp),%r13
 1078dd5:	lea    -0x1(%r13),%rdx
 1078dd9:	cmp    %r10,%rdx
 1078ddc:	je     1078b1f <check_input_run+0xbe0f>
 1078de2:	mov    %edi,%edi
 1078de4:	mov    %esi,%esi
 1078de6:	jmp    1078e35 <check_input_run+0xc125>
 1078de8:	movzbl 0x3bd(%r11),%edx
 1078df0:	mov    0x228(%r11),%rbx
 1078df7:	lea    0x1(%r8),%ebp
 1078dfb:	lea    (%r8,%r8,2),%r8
 1078dff:	inc    %r9d
 1078e02:	mov    %ebp,0x230(%r11)
 1078e09:	lea    0x1(%rdx,%rdx,2),%edx
 1078e0d:	mov    %r9d,(%rbx,%r8,4)
 1078e11:	mov    %edx,0x4(%rbx,%r8,4)
 1078e16:	movl   $0x0,0x8(%rbx,%r8,4)
 1078e1f:	mov    0x20(%rsp),%r12
 1078e24:	mov    0x28(%rsp),%r13
 1078e29:	mov    %r10,%r9
 1078e2c:	cmp    %r10,%r13
 1078e2f:	je     1078b1f <check_input_run+0xbe0f>
 1078e35:	mov    0x10(%rax),%r10
 1078e39:	lea    0x1(%r9),%r8
 1078e3d:	cmpb   $0x4f,(%r9,%r10,1)
 1078e42:	jne    1078ef6 <check_input_run+0xc1e6>
 1078e48:	mov    0x30(%rax),%edx
 1078e4b:	cmp    %rdx,%r8
 1078e4e:	jae    1078ef6 <check_input_run+0xc1e6>
 1078e54:	mov    0x60(%rax),%rdx
 1078e58:	mov    0x4(%rdx,%r9,4),%edx
 1078e5d:	cmp    %rdx,%r9
 1078e60:	jne    1078ef6 <check_input_run+0xc1e6>
 1078e66:	mov    0x50(%rax),%rdx
 1078e6a:	cmpb   $0x1a,0x1(%rdx,%r9,1)
 1078e70:	jne    1078ef6 <check_input_run+0xc1e6>
 1078e76:	cmpb   $0x11,0x1(%r10,%r9,1)
 1078e7c:	jne    1078ef6 <check_input_run+0xc1e6>
 1078e7e:	mov    0x2a0(%rsp),%r10
 1078e86:	mov    0x348(%r10),%rdx
 1078e8d:	cmpl   $0x0,(%rdx,%r9,4)
 1078e92:	jne    1078ef6 <check_input_run+0xc1e6>
 1078e94:	cmp    %rsi,%r9
 1078e97:	jbe    1078e9e <check_input_run+0xc18e>
 1078e99:	cmp    %rdi,%r9
 1078e9c:	jb     1078ef6 <check_input_run+0xc1e6>
 1078e9e:	mov    0x230(%r10),%r11d
 1078ea5:	cmp    0x234(%r10),%r11d
 1078eac:	jae    1078ee4 <check_input_run+0xc1d4>
 1078eae:	movzbl 0x3bd(%r10),%edx
 1078eb6:	mov    0x228(%r10),%rbx
 1078ebd:	lea    0x1(%r11),%ebp
 1078ec1:	mov    %ebp,0x230(%r10)
 1078ec8:	lea    (%r11,%r11,2),%r10
 1078ecc:	lea    0x1(%rdx,%rdx,2),%edx
 1078ed0:	mov    %r9d,(%rbx,%r10,4)
 1078ed4:	mov    %edx,0x4(%rbx,%r10,4)
 1078ed9:	movl   $0x0,0x8(%rbx,%r10,4)
 1078ee2:	jmp    1078eec <check_input_run+0xc1dc>
 1078ee4:	movb   $0x1,0x3bd(%r10)
 1078eec:	mov    0x20(%rsp),%r12
 1078ef1:	mov    0x28(%rsp),%r13
 1078ef6:	mov    0x10(%rax),%r11
 1078efa:	lea    0x2(%r9),%r10
 1078efe:	cmpb   $0x4f,0x1(%r9,%r11,1)
 1078f04:	jne    1078e29 <check_input_run+0xc119>
 1078f0a:	mov    0x30(%rax),%edx
 1078f0d:	cmp    %rdx,%r10
 1078f10:	jae    1078e29 <check_input_run+0xc119>
 1078f16:	mov    0x60(%rax),%rdx
 1078f1a:	mov    0x8(%rdx,%r9,4),%edx
 1078f1f:	cmp    %rdx,%r8
 1078f22:	jne    1078e29 <check_input_run+0xc119>
 1078f28:	mov    0x50(%rax),%rdx
 1078f2c:	cmpb   $0x1a,0x2(%rdx,%r9,1)
 1078f32:	jne    1078e29 <check_input_run+0xc119>
 1078f38:	cmpb   $0x11,0x2(%r11,%r9,1)
 1078f3e:	jne    1078e29 <check_input_run+0xc119>
 1078f44:	mov    0x2a0(%rsp),%r11
 1078f4c:	mov    0x348(%r11),%rdx
 1078f53:	cmpl   $0x0,0x4(%rdx,%r9,4)
 1078f59:	jne    1078e29 <check_input_run+0xc119>
 1078f5f:	cmp    %rsi,%r9
 1078f62:	jb     1078f6d <check_input_run+0xc25d>
 1078f64:	cmp    %rdi,%r8
 1078f67:	jb     1078e29 <check_input_run+0xc119>
 1078f6d:	mov    0x230(%r11),%r8d
 1078f74:	cmp    0x234(%r11),%r8d
 1078f7b:	jb     1078de8 <check_input_run+0xc0d8>
 1078f81:	movb   $0x1,0x3bd(%r11)
 1078f89:	jmp    1078e1f <check_input_run+0xc10f>
 1078f8e:	mov    0x2aa40(%r12),%r13
 1078f96:	movb   $0x1,0x58(%rsp)
 1078f9b:	mov    0x70(%rsp),%r10
 1078fa0:	mov    0xe8(%rsp),%r9
 1078fa8:	jmp    1077c1d <check_input_run+0xaf0d>
 1078fad:	mov    0x18(%rsp),%rdi
 1078fb2:	movq   $0x0,0x248(%rdi)
 1078fbd:	movq   $0x0,0x260(%rdi)
 1078fc8:	jmp    106d556 <check_input_run+0x846>
 1078fcd:	mov    0x78(%rsp),%rdx
 1078fd2:	mov    0x10(%rsp),%rsi
 1078fd7:	mov    %r9,0x30(%rsp)
 1078fdc:	lea    0x1(%rdx,%rcx,1),%rdx
 1078fe1:	mov    %rdx,0x8(%rsi)
 1078fe5:	mov    0x18(%rsp),%rdx
 1078fea:	add    (%rsi),%rcx
 1078fed:	mov    %rcx,0x248(%rdx)
 1078ff4:	je     10790b5 <check_input_run+0xc3a5>
 1078ffa:	mov    0x10(%rsp),%rcx
 1078fff:	mov    (%rcx),%rsi
 1079002:	mov    0x8(%rcx),%rdx
 1079006:	lea    0x3(%rdx,%rsi,1),%rcx
 107900b:	add    %rsi,%rdx
 107900e:	and    $0xfffffffffffffffc,%rcx
 1079012:	cmp    %rdx,%rcx
 1079015:	jb     10790b5 <check_input_run+0xc3a5>
 107901b:	mov    %rcx,%rdx
 107901e:	sub    %rsi,%rdx
 1079021:	mov    0x10(%rsp),%rsi
 1079026:	mov    0x10(%rsi),%rsi
 107902a:	sub    %rdx,%rsi
 107902d:	jb     10790b5 <check_input_run+0xc3a5>
 1079033:	cmp    %rsi,%rax
 1079036:	ja     10790b5 <check_input_run+0xc3a5>
 1079038:	mov    0x10(%rsp),%rsi
 107903d:	add    %rax,%rdx
 1079040:	mov    %rdx,0x8(%rsi)
 1079044:	mov    0x18(%rsp),%rsi
 1079049:	mov    %rcx,0x260(%rsi)
 1079050:	test   %rcx,%rcx
 1079053:	je     107909c <check_input_run+0xc38c>
 1079055:	mov    0x10(%rsp),%rcx
 107905a:	mov    (%rcx),%rdx
 107905d:	mov    0x8(%rcx),%rsi
 1079061:	lea    0x7(%rsi,%rdx,1),%rcx
 1079066:	add    %rdx,%rsi
 1079069:	and    $0xfffffffffffffff8,%rcx
 107906d:	cmp    %rsi,%rcx
 1079070:	jb     107909c <check_input_run+0xc38c>
 1079072:	mov    %rcx,%rsi
 1079075:	sub    %rdx,%rsi
 1079078:	mov    0x10(%rsp),%rdx
 107907d:	mov    0x10(%rdx),%rdx
 1079081:	sub    %rsi,%rdx
 1079084:	setb   %dil
 1079088:	cmp    0x78(%rsp),%rdx
 107908d:	setbe  %dl
 1079090:	or     %dil,%dl
 1079093:	cmp    $0x1,%dl
 1079096:	jne    107a1de <check_input_run+0xd4ce>
 107909c:	mov    0x18(%rsp),%rdi
 10790a1:	mov    0x10(%rsp),%rsi
 10790a6:	mov    0x20(%rsp),%r12
 10790ab:	mov    0x30(%rsp),%r9
 10790b0:	jmp    106d556 <check_input_run+0x846>
 10790b5:	mov    0x18(%rsp),%rdi
 10790ba:	mov    0x10(%rsp),%rsi
 10790bf:	mov    0x20(%rsp),%r12
 10790c4:	mov    0x30(%rsp),%r9
 10790c9:	movq   $0x0,0x260(%rdi)
 10790d4:	jmp    106d556 <check_input_run+0x846>
 10790d9:	xor    %r14d,%r14d
 10790dc:	jmp    1070f52 <check_input_run+0x4242>
 10790e1:	mov    0x98(%rsp),%r13
 10790e9:	xor    %edx,%edx
 10790eb:	mov    %dl,0x0(%r13,%rcx,1)
 10790f0:	mov    %rax,%rcx
 10790f3:	test   %rax,%rax
 10790f6:	je     107923d <check_input_run+0xc52d>
 10790fc:	lea    -0xbdba13(%rip),%rax        # 49d6f0 <cbuiltin_test_generated.edges+0x38b0>
 1079103:	lea    -0xbdb906(%rip),%rdx        # 49d804 <cbuiltin_test_generated.edges+0x39c4>
 107910a:	mov    $0x6005,%esi
 107910f:	jmp    107912a <check_input_run+0xc41a>
 1079111:	bt     %r12d,%esi
 1079115:	jae    10791c7 <check_input_run+0xc4b7>
 107911b:	add    $0xfffffffffffffffe,%rcx
 107911f:	mov    %r8b,0x0(%r13,%rdi,1)
 1079124:	je     107923d <check_input_run+0xc52d>
 107912a:	mov    0x68(%r14),%rdi
 107912e:	mov    0x50(%r14),%r10
 1079132:	mov    0x60(%r14),%r8
 1079136:	mov    -0x4(%rdi,%rcx,4),%edi
 107913a:	movzbl (%r10,%rdi,1),%r11d
 107913f:	mov    (%r8,%rdi,4),%r9d
 1079143:	mov    $0x1,%r8b
 1079146:	lea    -0x41(%r11),%r12d
 107914a:	cmp    $0xe,%r12d
 107914e:	ja     1079156 <check_input_run+0xc446>
 1079150:	bt     %r12d,%esi
 1079154:	jb     1079198 <check_input_run+0xc488>
 1079156:	add    $0xfffffff9,%r11d
 107915a:	cmp    $0x2,%r11d
 107915e:	jb     1079198 <check_input_run+0xc488>
 1079160:	cmp    %ebp,%r9d
 1079163:	jae    1079195 <check_input_run+0xc485>
 1079165:	cmpb   $0x0,0x0(%r13,%r9,1)
 107916b:	je     1079195 <check_input_run+0xc485>
 107916d:	movzbl (%r10,%r9,1),%r10d
 1079172:	add    $0xfffffff9,%r10d
 1079176:	cmp    $0x44,%r10d
 107917a:	ja     1079195 <check_input_run+0xc485>
 107917c:	movslq (%rax,%r10,4),%r10
 1079180:	add    %rax,%r10
 1079183:	jmp    *%r10
 1079186:	cmp    (%r15,%r9,4),%edi
 107918a:	setb   %r8b
 107918e:	jmp    1079198 <check_input_run+0xc488>
 1079190:	cmp    %r9d,%edi
 1079193:	jb     1079198 <check_input_run+0xc488>
 1079195:	xor    %r8d,%r8d
 1079198:	mov    %r8b,0x0(%r13,%rdi,1)
 107919d:	mov    0x68(%r14),%rdi
 10791a1:	mov    0x50(%r14),%r10
 10791a5:	mov    0x60(%r14),%r8
 10791a9:	mov    -0x8(%rdi,%rcx,4),%edi
 10791ad:	movzbl (%r10,%rdi,1),%r11d
 10791b2:	mov    (%r8,%rdi,4),%r9d
 10791b6:	mov    $0x1,%r8b
 10791b9:	lea    -0x41(%r11),%r12d
 10791bd:	cmp    $0xe,%r12d
 10791c1:	jbe    1079111 <check_input_run+0xc401>
 10791c7:	add    $0xfffffff9,%r11d
 10791cb:	cmp    $0x2,%r11d
 10791cf:	jb     107911b <check_input_run+0xc40b>
 10791d5:	cmp    %ebp,%r9d
 10791d8:	jae    1079211 <check_input_run+0xc501>
 10791da:	cmpb   $0x0,0x0(%r13,%r9,1)
 10791e0:	je     1079211 <check_input_run+0xc501>
 10791e2:	movzbl (%r10,%r9,1),%r10d
 10791e7:	add    $0xfffffff9,%r10d
 10791eb:	cmp    $0x44,%r10d
 10791ef:	ja     1079211 <check_input_run+0xc501>
 10791f1:	movslq (%rdx,%r10,4),%r10
 10791f5:	add    %rdx,%r10
 10791f8:	jmp    *%r10
 10791fb:	cmp    (%r15,%r9,4),%edi
 10791ff:	setb   %r8b
 1079203:	jmp    107911b <check_input_run+0xc40b>
 1079208:	cmp    %r9d,%edi
 107920b:	jb     107911b <check_input_run+0xc40b>
 1079211:	xor    %r8d,%r8d
 1079214:	jmp    107911b <check_input_run+0xc40b>
 1079219:	mov    0x10(%r14),%r8
 107921d:	cmpb   $0x11,(%r8,%r9,1)
 1079222:	sete   %r8b
 1079226:	jmp    1079198 <check_input_run+0xc488>
 107922b:	mov    0x10(%r14),%r8
 107922f:	cmpb   $0x11,(%r8,%r9,1)
 1079234:	sete   %r8b
 1079238:	jmp    107911b <check_input_run+0xc40b>
 107923d:	mov    0x130(%rsp),%rax
 1079245:	mov    0x90(%rsp),%r10
 107924d:	mov    (%rax),%eax
 107924f:	mov    %eax,0x50(%rsp)
 1079253:	test   %eax,%eax
 1079255:	je     1079774 <check_input_run+0xca64>
 107925b:	mov    $0xffffffff,%r8d
 1079261:	xor    %r12d,%r12d
 1079264:	xor    %edi,%edi
 1079266:	jmp    1079299 <check_input_run+0xc589>
 1079268:	mov    %eax,0x10(%r9)
 107926c:	mov    $0x3,%sil
 107926f:	mov    0x130(%rsp),%rax
 1079277:	mov    %sil,0x31(%r9)
 107927b:	mov    (%rax),%eax
 107927d:	mov    %eax,0x50(%rsp)
 1079281:	mov    0x50(%rsp),%eax
 1079285:	mov    0x90(%rsp),%r10
 107928d:	inc    %rdi
 1079290:	cmp    %rax,%rdi
 1079293:	jae    1079774 <check_input_run+0xca64>
 1079299:	mov    (%r10),%r9
 107929c:	imul   $0x34,%rdi,%r13
 10792a0:	mov    0xc(%r9,%r13,1),%r10d
 10792a5:	cmp    %r10d,%r12d
 10792a8:	jae    10794b9 <check_input_run+0xc7a9>
 10792ae:	mov    0x50(%r14),%rcx
 10792b2:	mov    %r10d,%esi
 10792b5:	sub    %r12d,%esi
 10792b8:	mov    %r12d,%edx
 10792bb:	mov    %rdx,%rax
 10792be:	and    $0x7,%esi
 10792c1:	jne    10792ea <check_input_run+0xc5da>
 10792c3:	sub    %r10,%rdx
 10792c6:	mov    %r10d,%r12d
 10792c9:	cmp    $0xfffffffffffffff8,%rdx
 10792cd:	ja     10794b9 <check_input_run+0xc7a9>
 10792d3:	mov    %r10,%r12
 10792d6:	neg    %r12
 10792d9:	add    $0x7,%rax
 10792dd:	jmp    107932a <check_input_run+0xc61a>
 10792df:	mov    %eax,%r8d
 10792e2:	inc    %rax
 10792e5:	dec    %rsi
 10792e8:	je     10792c3 <check_input_run+0xc5b3>
 10792ea:	movzbl (%rcx,%rax,1),%r12d
 10792ef:	add    $0xc5,%r12b
 10792f3:	cmp    $0xe7,%r12b
 10792f7:	jae    10792df <check_input_run+0xc5cf>
 10792f9:	cmp    %ebp,%r8d
 10792fc:	jae    10792e2 <check_input_run+0xc5d2>
 10792fe:	mov    0x60(%r14),%r11
 1079302:	mov    %r8d,%r12d
 1079305:	mov    (%r11,%r12,4),%r11d
 1079309:	cmp    %r11,%rax
 107930c:	jne    10792e2 <check_input_run+0xc5d2>
 107930e:	mov    (%r15,%r12,4),%r8d
 1079312:	jmp    10792e2 <check_input_run+0xc5d2>
 1079314:	mov    %eax,%r8d
 1079317:	lea    0x8(%r12,%rax,1),%rdx
 107931c:	add    $0x8,%rax
 1079320:	cmp    $0x7,%rdx
 1079324:	je     10794b6 <check_input_run+0xc7a6>
 107932a:	movzbl -0x7(%rcx,%rax,1),%esi
 107932f:	lea    -0x7(%rax),%rdx
 1079333:	add    $0xc5,%sil
 1079337:	cmp    $0xe7,%sil
 107933b:	jae    1079358 <check_input_run+0xc648>
 107933d:	cmp    %ebp,%r8d
 1079340:	jae    107935b <check_input_run+0xc64b>
 1079342:	mov    0x60(%r14),%r11
 1079346:	mov    %r8d,%esi
 1079349:	mov    (%r11,%rsi,4),%r11d
 107934d:	cmp    %r11,%rdx
 1079350:	jne    107935b <check_input_run+0xc64b>
 1079352:	mov    (%r15,%rsi,4),%r8d
 1079356:	jmp    107935b <check_input_run+0xc64b>
 1079358:	mov    %edx,%r8d
 107935b:	movzbl -0x6(%rcx,%rax,1),%esi
 1079360:	lea    -0x6(%rax),%rdx
 1079364:	add    $0xc5,%sil
 1079368:	cmp    $0xe7,%sil
 107936c:	jae    1079389 <check_input_run+0xc679>
 107936e:	cmp    %ebp,%r8d
 1079371:	jae    107938c <check_input_run+0xc67c>
 1079373:	mov    0x60(%r14),%r11
 1079377:	mov    %r8d,%esi
 107937a:	mov    (%r11,%rsi,4),%r11d
 107937e:	cmp    %r11,%rdx
 1079381:	jne    107938c <check_input_run+0xc67c>
 1079383:	mov    (%r15,%rsi,4),%r8d
 1079387:	jmp    107938c <check_input_run+0xc67c>
 1079389:	mov    %edx,%r8d
 107938c:	movzbl -0x5(%rcx,%rax,1),%esi
 1079391:	lea    -0x5(%rax),%rdx
 1079395:	add    $0xc5,%sil
 1079399:	cmp    $0xe7,%sil
 107939d:	jae    10793ba <check_input_run+0xc6aa>
 107939f:	cmp    %ebp,%r8d
 10793a2:	jae    10793bd <check_input_run+0xc6ad>
 10793a4:	mov    0x60(%r14),%r11
 10793a8:	mov    %r8d,%esi
 10793ab:	mov    (%r11,%rsi,4),%r11d
 10793af:	cmp    %r11,%rdx
 10793b2:	jne    10793bd <check_input_run+0xc6ad>
 10793b4:	mov    (%r15,%rsi,4),%r8d
 10793b8:	jmp    10793bd <check_input_run+0xc6ad>
 10793ba:	mov    %edx,%r8d
 10793bd:	movzbl -0x4(%rcx,%rax,1),%esi
 10793c2:	lea    -0x4(%rax),%rdx
 10793c6:	add    $0xc5,%sil
 10793ca:	cmp    $0xe7,%sil
 10793ce:	jae    10793eb <check_input_run+0xc6db>
 10793d0:	cmp    %ebp,%r8d
 10793d3:	jae    10793ee <check_input_run+0xc6de>
 10793d5:	mov    0x60(%r14),%r11
 10793d9:	mov    %r8d,%esi
 10793dc:	mov    (%r11,%rsi,4),%r11d
 10793e0:	cmp    %r11,%rdx
 10793e3:	jne    10793ee <check_input_run+0xc6de>
 10793e5:	mov    (%r15,%rsi,4),%r8d
 10793e9:	jmp    10793ee <check_input_run+0xc6de>
 10793eb:	mov    %edx,%r8d
 10793ee:	movzbl -0x3(%rcx,%rax,1),%esi
 10793f3:	lea    -0x3(%rax),%rdx
 10793f7:	add    $0xc5,%sil
 10793fb:	cmp    $0xe7,%sil
 10793ff:	jae    107941c <check_input_run+0xc70c>
 1079401:	cmp    %ebp,%r8d
 1079404:	jae    107941f <check_input_run+0xc70f>
 1079406:	mov    0x60(%r14),%r11
 107940a:	mov    %r8d,%esi
 107940d:	mov    (%r11,%rsi,4),%r11d
 1079411:	cmp    %r11,%rdx
 1079414:	jne    107941f <check_input_run+0xc70f>
 1079416:	mov    (%r15,%rsi,4),%r8d
 107941a:	jmp    107941f <check_input_run+0xc70f>
 107941c:	mov    %edx,%r8d
 107941f:	movzbl -0x2(%rcx,%rax,1),%esi
 1079424:	lea    -0x2(%rax),%rdx
 1079428:	add    $0xc5,%sil
 107942c:	cmp    $0xe7,%sil
 1079430:	jae    107944d <check_input_run+0xc73d>
 1079432:	cmp    %ebp,%r8d
 1079435:	jae    1079450 <check_input_run+0xc740>
 1079437:	mov    0x60(%r14),%r11
 107943b:	mov    %r8d,%esi
 107943e:	mov    (%r11,%rsi,4),%r11d
 1079442:	cmp    %r11,%rdx
 1079445:	jne    1079450 <check_input_run+0xc740>
 1079447:	mov    (%r15,%rsi,4),%r8d
 107944b:	jmp    1079450 <check_input_run+0xc740>
 107944d:	mov    %edx,%r8d
 1079450:	movzbl -0x1(%rcx,%rax,1),%esi
 1079455:	lea    -0x1(%rax),%rdx
 1079459:	add    $0xc5,%sil
 107945d:	cmp    $0xe7,%sil
 1079461:	jae    107947e <check_input_run+0xc76e>
 1079463:	cmp    %ebp,%r8d
 1079466:	jae    1079481 <check_input_run+0xc771>
 1079468:	mov    0x60(%r14),%r11
 107946c:	mov    %r8d,%esi
 107946f:	mov    (%r11,%rsi,4),%r11d
 1079473:	cmp    %r11,%rdx
 1079476:	jne    1079481 <check_input_run+0xc771>
 1079478:	mov    (%r15,%rsi,4),%r8d
 107947c:	jmp    1079481 <check_input_run+0xc771>
 107947e:	mov    %edx,%r8d
 1079481:	movzbl (%rcx,%rax,1),%edx
 1079485:	add    $0xc5,%dl
 1079488:	cmp    $0xe7,%dl
 107948b:	jae    1079314 <check_input_run+0xc604>
 1079491:	cmp    %ebp,%r8d
 1079494:	jae    1079317 <check_input_run+0xc607>
 107949a:	mov    0x60(%r14),%rsi
 107949e:	mov    %r8d,%edx
 10794a1:	mov    (%rsi,%rdx,4),%esi
 10794a4:	cmp    %rsi,%rax
 10794a7:	jne    1079317 <check_input_run+0xc607>
 10794ad:	mov    (%r15,%rdx,4),%r8d
 10794b1:	jmp    1079317 <check_input_run+0xc607>
 10794b6:	mov    %r10d,%r12d
 10794b9:	add    %r13,%r9
 10794bc:	cmpb   $0x1,0x31(%r9)
 10794c1:	jne    1079281 <check_input_run+0xc571>
 10794c7:	mov    0x98(%rsp),%r13
 10794cf:	test   %r10d,%r10d
 10794d2:	je     1079281 <check_input_run+0xc571>
 10794d8:	movzbl 0x30(%r9),%eax
 10794dd:	and    $0x1,%al
 10794df:	jne    1079281 <check_input_run+0xc571>
 10794e5:	mov    0x60(%r14),%rdx
 10794e9:	lea    -0x1(%r10),%eax
 10794ed:	mov    0x50(%r14),%rcx
 10794f1:	xor    %esi,%esi
 10794f3:	mov    (%rdx,%rax,4),%r11d
 10794f7:	cmp    %ebp,%r11d
 10794fa:	jae    1079501 <check_input_run+0xc7f1>
 10794fc:	movzbl (%rcx,%r11,1),%esi
 1079501:	mov    %r11,0x70(%rsp)
 1079506:	mov    %esi,0xe8(%rsp)
 107950d:	cmp    %ebp,%r8d
 1079510:	jae    107953b <check_input_run+0xc82b>
 1079512:	mov    %r8d,%r11d
 1079515:	movzbl (%rcx,%r11,1),%esi
 107951a:	cmp    $0x24,%esi
 107951d:	je     1079540 <check_input_run+0xc830>
 107951f:	cmp    $0x23,%esi
 1079522:	jne    1079548 <check_input_run+0xc838>
 1079524:	mov    (%rdx,%r11,4),%edx
 1079528:	cmp    %ebp,%edx
 107952a:	jae    107953b <check_input_run+0xc82b>
 107952c:	cmpb   $0x0,0x0(%r13,%rdx,1)
 1079532:	setne  %sil
 1079536:	xor    %r13d,%r13d
 1079539:	jmp    1079556 <check_input_run+0xc846>
 107953b:	xor    %r13d,%r13d
 107953e:	jmp    1079554 <check_input_run+0xc844>
 1079540:	xor    %r13d,%r13d
 1079543:	mov    $0x1,%sil
 1079546:	jmp    1079556 <check_input_run+0xc846>
 1079548:	add    $0xcd,%sil
 107954c:	cmp    $0x3,%sil
 1079550:	setb   %r13b
 1079554:	xor    %esi,%esi
 1079556:	mov    0x10(%r14),%rdx
 107955a:	movzbl (%rcx,%rax,1),%ecx
 107955e:	cmp    $0xffffffff,%r8d
 1079562:	movl   $0x1,0x210(%rsp)
 107956d:	movzbl (%rdx,%rax,1),%r11d
 1079572:	mov    %rdx,0xd0(%rsp)
 107957a:	sete   %dl
 107957d:	mov    %rcx,0x50(%rsp)
 1079582:	or     %r13b,%dl
 1079585:	lea    -0x41(%rcx),%r13d
 1079589:	cmp    $0xe,%r13d
 107958d:	ja     107959a <check_input_run+0xc88a>
 107958f:	mov    $0x6005,%ecx
 1079594:	bt     %r13d,%ecx
 1079598:	jb     10795a9 <check_input_run+0xc899>
 107959a:	mov    0x50(%rsp),%rcx
 107959f:	lea    -0x7(%rcx),%r13d
 10795a3:	cmp    $0x2,%r13d
 10795a7:	jae    10795fc <check_input_run+0xc8ec>
 10795a9:	mov    0x98(%rsp),%r13
 10795b1:	add    $0xcb,%r11b
 10795b5:	cmp    $0x2,%r11b
 10795b9:	jb     1079268 <check_input_run+0xc558>
 10795bf:	mov    0x210(%rsp),%ecx
 10795c6:	test   %ecx,%ecx
 10795c8:	mov    %ecx,%esi
 10795ca:	sete   %r11b
 10795ce:	cmp    %ebp,%r10d
 10795d1:	jae    10796db <check_input_run+0xc9cb>
 10795d7:	mov    0xd0(%rsp),%rcx
 10795df:	cmpb   $0x48,(%rcx,%r10,1)
 10795e4:	mov    %esi,%ecx
 10795e6:	mov    %ecx,0x210(%rsp)
 10795ed:	jne    10796db <check_input_run+0xc9cb>
 10795f3:	mov    %r10d,0x10(%r9)
 10795f7:	jmp    107926c <check_input_run+0xc55c>
 10795fc:	mov    0x98(%rsp),%r13
 1079604:	test   %sil,%sil
 1079607:	je     107962a <check_input_run+0xc91a>
 1079609:	cmpl   $0x24,0x50(%rsp)
 107960e:	ja     107962a <check_input_run+0xc91a>
 1079610:	mov    0x50(%rsp),%esi
 1079614:	mov    %r13,%rcx
 1079617:	movabs $0x1810000000,%r13
 1079621:	bt     %rsi,%r13
 1079625:	mov    %rcx,%r13
 1079628:	jb     10795b1 <check_input_run+0xc8a1>
 107962a:	xor    %esi,%esi
 107962c:	test   %dl,%dl
 107962e:	je     1079677 <check_input_run+0xc967>
 1079630:	mov    0x50(%rsp),%rcx
 1079635:	lea    -0x1e(%rcx),%esi
 1079638:	cmp    $0x36,%sil
 107963c:	jae    107965c <check_input_run+0xc94c>
 107963e:	mov    %r13,%rcx
 1079641:	movzbl %sil,%esi
 1079645:	movabs $0x20d00000e0000f,%r13
 107964f:	bt     %rsi,%r13
 1079653:	mov    %rcx,%r13
 1079656:	jb     10795b1 <check_input_run+0xc8a1>
 107965c:	cmpl   $0x49,0x50(%rsp)
 1079661:	sete   %cl
 1079664:	cmpl   $0x1e,0xe8(%rsp)
 107966c:	setne  %sil
 1079670:	and    %cl,%sil
 1079673:	movzbl %sil,%esi
 1079677:	cmp    $0x2,%r11b
 107967b:	jne    1079751 <check_input_run+0xca41>
 1079681:	cmpb   $0x6,0x50(%rsp)
 1079686:	jne    1079751 <check_input_run+0xca41>
 107968c:	mov    0xe8(%rsp),%ecx
 1079693:	mov    %esi,%r11d
 1079696:	xor    %esi,%esi
 1079698:	and    $0xfffffffe,%ecx
 107969b:	cmp    $0x4e,%ecx
 107969e:	sete   %sil
 10796a2:	or     %esi,%r11d
 10796a5:	mov    %r11d,%esi
 10796a8:	sete   %r11b
 10796ac:	cmp    %ebp,%r10d
 10796af:	jae    10796c9 <check_input_run+0xc9b9>
 10796b1:	cmp    $0x4e,%ecx
 10796b4:	jne    10796c9 <check_input_run+0xc9b9>
 10796b6:	mov    0xd0(%rsp),%rcx
 10796be:	cmpb   $0xa,(%rcx,%r10,1)
 10796c3:	je     10795f3 <check_input_run+0xc8e3>
 10796c9:	mov    %esi,%ecx
 10796cb:	mov    %ecx,0x210(%rsp)
 10796d2:	cmp    %ebp,%r10d
 10796d5:	jb     10795d7 <check_input_run+0xc8c7>
 10796db:	mov    0x70(%rsp),%rcx
 10796e0:	cmp    %ebp,%ecx
 10796e2:	jae    10796fa <check_input_run+0xc9ea>
 10796e4:	mov    0xd0(%rsp),%r10
 10796ec:	mov    $0x3,%sil
 10796ef:	cmpb   $0x4d,(%r10,%rcx,1)
 10796f4:	je     107926f <check_input_run+0xc55f>
 10796fa:	cmpl   $0x49,0x50(%rsp)
 10796ff:	jne    107970f <check_input_run+0xc9ff>
 1079701:	cmpl   $0x1e,0xe8(%rsp)
 1079709:	je     1079268 <check_input_run+0xc558>
 107970f:	and    %r11b,%dl
 1079712:	cmp    $0x1,%dl
 1079715:	jne    1079738 <check_input_run+0xca28>
 1079717:	mov    0x50(%rsp),%rcx
 107971c:	lea    -0x2(%rcx),%edx
 107971f:	cmp    $0x4f,%edx
 1079722:	ja     107975d <check_input_run+0xca4d>
 1079724:	lea    -0xbdbe13(%rip),%rsi        # 49d918 <cbuiltin_test_generated.edges+0x3ad8>
 107972b:	movslq (%rsi,%rdx,4),%rdx
 107972f:	add    %rsi,%rdx
 1079732:	jmp    *%rdx
 1079734:	mov    %eax,0x10(%r9)
 1079738:	testb  $0x1,0x210(%rsp)
 1079740:	mov    $0x3,%sil
 1079743:	je     107926f <check_input_run+0xc55f>
 1079749:	mov    $0x1,%sil
 107974c:	jmp    107926f <check_input_run+0xc55f>
 1079751:	mov    %esi,0x210(%rsp)
 1079758:	jmp    10795b1 <check_input_run+0xc8a1>
 107975d:	mov    0x50(%rsp),%rcx
 1079762:	and    $0xfe,%cl
 1079765:	cmp    $0x3c,%cl
 1079768:	jne    1079738 <check_input_run+0xca28>
 107976a:	cmpb   $0x0,0x0(%r13,%rax,1)
 1079770:	jne    1079738 <check_input_run+0xca28>
 1079772:	jmp    1079734 <check_input_run+0xca24>
 1079774:	mov    0x2a0(%rsp),%rax
 107977c:	mov    0x1b0(%rsp),%rcx
 1079784:	mov    0x20(%rsp),%r12
 1079789:	mov    0x28(%rsp),%r9
 107978e:	mov    %r10,0x1c0(%rax)
 1079795:	mov    %rcx,0x1c8(%rax)
 107979c:	cmpl   $0x0,0x8(%r10)
 10797a1:	je     10797c6 <check_input_run+0xcab6>
 10797a3:	xor    %eax,%eax
 10797a5:	xor    %ecx,%ecx
 10797a7:	mov    (%r10),%rdx
 10797aa:	inc    %rcx
 10797ad:	movzbl 0x31(%rdx,%rax,1),%esi
 10797b2:	mov    (%rdx,%rax,1),%edx
 10797b5:	add    $0x34,%rax
 10797b9:	mov    %sil,(%rbx,%rdx,1)
 10797bd:	mov    0x8(%r10),%edx
 10797c1:	cmp    %rdx,%rcx
 10797c4:	jb     10797a7 <check_input_run+0xca97>
 10797c6:	mov    0x2c8(%rsp),%rax
 10797ce:	lea    0x2a0(%rsp),%rdi
 10797d6:	mov    %rbx,%rsi
 10797d9:	mov    %r9,0x8(%rax)
 10797dd:	call   1080fc0 <check_input_fp_pragmas>
 10797e2:	mov    0x18(%rsp),%rcx
 10797e7:	xor    $0x1,%al
 10797e9:	or     %al,0x3bd(%rcx)
 10797ef:	test   %al,%al
 10797f1:	jne    1071e23 <check_input_run+0x5113>
 10797f7:	mov    0x48(%r12),%esi
 10797fc:	test   %rsi,%rsi
 10797ff:	je     1071e23 <check_input_run+0x5113>
 1079805:	mov    0x18(%rsp),%rax
 107980a:	mov    0x40(%r12),%rdi
 107980f:	xor    %edx,%edx
 1079811:	xor    %ecx,%ecx
 1079813:	mov    0x1c0(%rax),%rax
 107981a:	jmp    1079828 <check_input_run+0xcb18>
 107981c:	inc    %rcx
 107981f:	cmp    %rsi,%rcx
 1079822:	je     1071e23 <check_input_run+0x5113>
 1079828:	test   %rax,%rax
 107982b:	je     1079857 <check_input_run+0xcb47>
 107982d:	mov    0x8(%rax),%r8d
 1079831:	cmp    %r8d,%edx
 1079834:	jae    1079857 <check_input_run+0xcb47>
 1079836:	mov    %edx,%edx
 1079838:	imul   $0x34,%rdx,%r9
 107983c:	add    (%rax),%r9
 107983f:	nop
 1079840:	mov    (%r9),%r10d
 1079843:	cmp    %r10,%rcx
 1079846:	jbe    1079857 <check_input_run+0xcb47>
 1079848:	inc    %rdx
 107984b:	add    $0x34,%r9
 107984f:	cmp    %rdx,%r8
 1079852:	jne    1079840 <check_input_run+0xcb30>
 1079854:	mov    %r8d,%edx
 1079857:	mov    (%rdi,%rcx,4),%r8d
 107985b:	movzbl (%rbx,%rcx,1),%r9d
 1079860:	cmp    $0x3,%r9d
 1079864:	je     107986b <check_input_run+0xcb5b>
 1079866:	test   %r9d,%r9d
 1079869:	jne    107981c <check_input_run+0xcb0c>
 107986b:	cmpq   $0x0,0x860(%rsp)
 1079874:	jne    107988e <check_input_run+0xcb7e>
 1079876:	mov    0x18(%rsp),%r9
 107987b:	mov    0x1f0(%r9),%r9
 1079882:	test   %r9,%r9
 1079885:	je     107988e <check_input_run+0xcb7e>
 1079887:	cmpb   $0x0,(%r9,%r8,1)
 107988c:	jne    107981c <check_input_run+0xcb0c>
 107988e:	mov    %r8d,0x660(%rsp)
 1079896:	mov    %ecx,0x664(%rsp)
 107989d:	xor    %esi,%esi
 107989f:	cmpb   $0x3,(%rbx,%rcx,1)
 10798a3:	sete   %sil
 10798a7:	mov    %esi,0x66c(%rsp)
 10798ae:	test   %rax,%rax
 10798b1:	je     1071e23 <check_input_run+0x5113>
 10798b7:	cmp    0x8(%rax),%edx
 10798ba:	jae    1071e23 <check_input_run+0x5113>
 10798c0:	mov    (%rax),%rax
 10798c3:	mov    %edx,%edx
 10798c5:	imul   $0x34,%rdx,%rdx
 10798c9:	cmp    %ecx,(%rax,%rdx,1)
 10798cc:	jne    1071e23 <check_input_run+0x5113>
 10798d2:	add    %rdx,%rax
 10798d5:	mov    0x10(%rax),%eax
 10798d8:	mov    %eax,0x668(%rsp)
 10798df:	jmp    1071e23 <check_input_run+0x5113>
 10798e4:	mov    %rax,%rdi
 10798e7:	sub    %r8,%rdi
 10798ea:	mov    0x10(%rsi),%r8
 10798ee:	sub    %rdi,%r8
 10798f1:	jb     1079c06 <check_input_run+0xcef6>
 10798f7:	shl    $0x2,%rdx
 10798fb:	cmp    %r8,%rdx
 10798fe:	ja     1079c06 <check_input_run+0xcef6>
 1079904:	add    %rdx,%rdi
 1079907:	mov    %rdi,0x8(%rsi)
 107990b:	test   %rax,%rax
 107990e:	je     1071dc4 <check_input_run+0x50b4>
 1079914:	mov    %rbp,%rcx
 1079917:	shr    $0x3d,%rcx
 107991b:	jne    1079966 <check_input_run+0xcc56>
 107991d:	mov    0x2c8(%rsp),%rcx
 1079925:	mov    (%rcx),%rdi
 1079928:	mov    0x8(%rcx),%rdx
 107992c:	lea    0x3(%rdx,%rdi,1),%rsi
 1079931:	add    %rdi,%rdx
 1079934:	and    $0xfffffffffffffffc,%rsi
 1079938:	cmp    %rdx,%rsi
 107993b:	jb     1079966 <check_input_run+0xcc56>
 107993d:	mov    %rsi,%r15
 1079940:	sub    %rdi,%rsi
 1079943:	mov    0x10(%rcx),%rdi
 1079947:	lea    0x0(,%rbp,8),%rdx
 107994f:	sub    %rsi,%rdi
 1079952:	setb   %r8b
 1079956:	cmp    %rdi,%rdx
 1079959:	seta   %dil
 107995d:	or     %r8b,%dil
 1079960:	je     107a1c0 <check_input_run+0xd4b0>
 1079966:	xor    %ecx,%ecx
 1079968:	mov    %rax,%r14
 107996b:	jmp    1071dc7 <check_input_run+0x50b7>
 1079970:	mov    0x38(%rsp),%rax
 1079975:	add    %rdx,%rsi
 1079978:	mov    %rsi,0x8(%rax)
 107997c:	mov    %rdi,0x600(%rsp)
 1079984:	test   %rdi,%rdi
 1079987:	je     1079e31 <check_input_run+0xd121>
 107998d:	mov    0xa8(%rsp),%rax
 1079995:	xor    %esi,%esi
 1079997:	mov    0xa4(%rax),%edx
 107999d:	shl    $0x2,%rdx
 10799a1:	vzeroupper
 10799a4:	call   788120 <memset@plt>
 10799a9:	mov    $0x1,%bl
 10799ab:	jmp    1079e33 <check_input_run+0xd123>
 10799b0:	mov    0x860(%rsp),%r8
 10799b8:	add    $0x20008,%rdi
 10799bf:	mov    %rdi,0x2aa40(%r8)
 10799c6:	mov    %rcx,0x2a830(%r8)
 10799cd:	test   %rcx,%rcx
 10799d0:	je     1079c1a <check_input_run+0xcf0a>
 10799d6:	add    $0x20008,%rcx
 10799dd:	mov    %rcx,%rdi
 10799e0:	sub    %rdx,%rdi
 10799e3:	sub    %rdi,%rsi
 10799e6:	jb     1079c1a <check_input_run+0xcf0a>
 10799ec:	imul   $0x150,%rax,%rdx
 10799f3:	add    $0x150,%rdx
 10799fa:	cmp    %rsi,%rdx
 10799fd:	ja     1079c1a <check_input_run+0xcf0a>
 1079a03:	mov    0x860(%rsp),%rsi
 1079a0b:	add    %rdx,%rdi
 1079a0e:	lea    0x1d8(%rsi),%r15
 1079a15:	mov    %rdi,0x2aa40(%rsi)
 1079a1c:	mov    %rcx,0x1d8(%rsi)
 1079a23:	test   %rcx,%rcx
 1079a26:	je     107a1a3 <check_input_run+0xd493>
 1079a2c:	mov    0x860(%rsp),%rcx
 1079a34:	mov    (%rcx),%ecx
 1079a36:	test   %rcx,%rcx
 1079a39:	je     1079aca <check_input_run+0xcdba>
 1079a3f:	xor    %edx,%edx
 1079a41:	mov    0x860(%rsp),%rsi
 1079a49:	mov    0x2aa38(%rsi),%r8
 1079a50:	mov    0x2aa40(%rsi),%rdi
 1079a57:	lea    0x3(%rdi,%r8,1),%rsi
 1079a5c:	add    %r8,%rdi
 1079a5f:	and    $0xfffffffffffffffc,%rsi
 1079a63:	cmp    %rdi,%rsi
 1079a66:	jb     107a276 <check_input_run+0xd566>
 1079a6c:	mov    %rsi,%rdi
 1079a6f:	sub    %r8,%rdi
 1079a72:	mov    0x860(%rsp),%r8
 1079a7a:	mov    0x2aa48(%r8),%r8
 1079a81:	sub    %rdi,%r8
 1079a84:	jb     107a276 <check_input_run+0xd566>
 1079a8a:	cmp    $0x10003,%r8
 1079a91:	jbe    107a276 <check_input_run+0xd566>
 1079a97:	mov    0x860(%rsp),%r8
 1079a9f:	add    $0x10004,%rdi
 1079aa6:	mov    %rdi,0x2aa40(%r8)
 1079aad:	mov    %rsi,0x2a838(%r8,%rdx,8)
 1079ab5:	test   %rsi,%rsi
 1079ab8:	je     107a1a3 <check_input_run+0xd493>
 1079abe:	inc    %rdx
 1079ac1:	cmp    %rdx,%rcx
 1079ac4:	jne    1079a41 <check_input_run+0xcd31>
 1079aca:	mov    0x860(%rsp),%rcx
 1079ad2:	add    $0x1e0,%rcx
 1079ad9:	mov    %rcx,0x28(%rsp)
 1079ade:	test   %rax,%rax
 1079ae1:	je     107a2b9 <check_input_run+0xd5a9>
 1079ae7:	xor    %eax,%eax
 1079ae9:	vpxor  %xmm0,%xmm0,%xmm0
 1079aed:	xor    %ecx,%ecx
 1079aef:	jmp    1079b34 <check_input_run+0xce24>
 1079af1:	add    %rsi,%rdx
 1079af4:	mov    0x860(%rsp),%rsi
 1079afc:	inc    %rcx
 1079aff:	mov    0x4(%rdx),%edx
 1079b02:	vmovq  0x1e8(%rsi),%xmm2
 1079b0a:	sub    %edi,%edx
 1079b0c:	inc    %edx
 1079b0e:	vmovd  %edx,%xmm1
 1079b12:	vpinsrd $0x1,%r8d,%xmm1,%xmm1
 1079b18:	vpmaxud %xmm2,%xmm1,%xmm1
 1079b1d:	vmovq  %xmm1,0x1e8(%rsi)
 1079b25:	mov    0x1e0(%rsi),%edx
 1079b2b:	cmp    %rdx,%rcx
 1079b2e:	jae    107a2bb <check_input_run+0xd5ab>
 1079b34:	mov    0x860(%rsp),%r9
 1079b3c:	lea    (%rcx,%rcx,2),%rsi
 1079b40:	shl    $0x4,%rsi
 1079b44:	mov    0x1d0(%r9),%rdx
 1079b4b:	mov    0x4(%rdx,%rsi,1),%r8d
 1079b50:	mov    (%rdx,%rsi,1),%edi
 1079b53:	add    %rax,%r8
 1079b56:	sub    %rdi,%r8
 1079b59:	mov    %r8,%rax
 1079b5c:	mov    0x2a828(%r9),%r8
 1079b63:	inc    %rax
 1079b66:	mov    %rax,(%r8,%rcx,8)
 1079b6a:	imul   $0x150,%rcx,%r8
 1079b71:	mov    0x1d8(%r9),%rdi
 1079b78:	vmovdqu64 %zmm0,0x10c(%rdi,%r8,1)
 1079b83:	vmovdqu64 %zmm0,0x100(%rdi,%r8,1)
 1079b8b:	vmovdqu64 %zmm0,0xc0(%rdi,%r8,1)
 1079b93:	vmovdqu64 %zmm0,0x80(%rdi,%r8,1)
 1079b9b:	vmovdqu64 %zmm0,0x40(%rdi,%r8,1)
 1079ba3:	vmovdqu64 %zmm0,(%rdi,%r8,1)
 1079baa:	movb   $0x1,0x14c(%rdi,%r8,1)
 1079bb3:	movw   $0x0,0x14d(%rdi,%r8,1)
 1079bbe:	movb   $0x0,0x14f(%rdi,%r8,1)
 1079bc7:	mov    0x580(%rsp),%r8
 1079bcf:	mov    (%rdx,%rsi,1),%edi
 1079bd2:	mov    (%r8,%rdi,4),%r9d
 1079bd6:	mov    $0x0,%r8d
 1079bdc:	cmp    $0xffffffff,%r9d
 1079be0:	je     1079af1 <check_input_run+0xcde1>
 1079be6:	mov    0x588(%rsp),%r10
 1079bee:	xor    %r8d,%r8d
 1079bf1:	mov    %r9d,%r9d
 1079bf4:	mov    (%r10,%r9,4),%r9d
 1079bf8:	inc    %r8d
 1079bfb:	cmp    $0xffffffff,%r9d
 1079bff:	jne    1079bf1 <check_input_run+0xcee1>
 1079c01:	jmp    1079af1 <check_input_run+0xcde1>
 1079c06:	mov    0x20(%rsp),%r12
 1079c0b:	mov    0x28(%rsp),%r9
 1079c10:	xor    %edi,%edi
 1079c12:	xor    %r14d,%r14d
 1079c15:	jmp    1070f60 <check_input_run+0x4250>
 1079c1a:	mov    0x860(%rsp),%r12
 1079c22:	jmp    1076758 <check_input_run+0x9a48>
 1079c27:	mov    0x100(%rsp),%eax
 1079c2e:	xor    %r11d,%r11d
 1079c31:	xor    %ecx,%ecx
 1079c33:	mov    %rax,0xd8(%rsp)
 1079c3b:	xor    %eax,%eax
 1079c3d:	jmp    1079c73 <check_input_run+0xcf63>
 1079c3f:	mov    0x860(%rsp),%r8
 1079c47:	mov    0xe8(%rsp),%r9
 1079c4f:	mov    0xc8(%rsp),%rbx
 1079c57:	mov    0x70(%rsp),%r10
 1079c5c:	inc    %rcx
 1079c5f:	mov    %r15,%rbp
 1079c62:	mov    %r12,%r14
 1079c65:	cmp    0xd8(%rsp),%rcx
 1079c6d:	je     1079e3d <check_input_run+0xd12d>
 1079c73:	lea    (%rcx,%rcx,2),%rsi
 1079c77:	shl    $0x4,%rsi
 1079c7b:	mov    (%r10,%rsi,1),%rdx
 1079c7f:	test   %rdx,%rdx
 1079c82:	je     1077bcb <check_input_run+0xaebb>
 1079c88:	cmpb   $0x0,0x4c(%rdx)
 1079c8c:	jne    1077bcb <check_input_run+0xaebb>
 1079c92:	test   %rcx,%rcx
 1079c95:	je     1079ca4 <check_input_run+0xcf94>
 1079c97:	add    %r10,%rsi
 1079c9a:	cmp    %r10,0x8(%rsi)
 1079c9e:	jne    1077bcb <check_input_run+0xaebb>
 1079ca4:	mov    0x8(%rdx),%edi
 1079ca7:	mov    %r14,%r12
 1079caa:	mov    %rbp,%r15
 1079cad:	test   %rdi,%rdi
 1079cb0:	je     1079c3f <check_input_run+0xcf2f>
 1079cb2:	mov    (%rdx),%rdx
 1079cb5:	mov    %edi,%esi
 1079cb7:	and    $0x3,%esi
 1079cba:	cmp    $0x4,%edi
 1079cbd:	jae    1079cc7 <check_input_run+0xcfb7>
 1079cbf:	xor    %r8d,%r8d
 1079cc2:	jmp    1079dde <check_input_run+0xd0ce>
 1079cc7:	and    $0xfffffffc,%edi
 1079cca:	lea    0x8(%rdx),%r9
 1079cce:	xor    %r8d,%r8d
 1079cd1:	jmp    1079cea <check_input_run+0xcfda>
 1079cd3:	mov    %r10d,%eax
 1079cd6:	add    $0x4,%r8
 1079cda:	add    $0xe0,%r9
 1079ce1:	cmp    %r8,%rdi
 1079ce4:	je     1079dd5 <check_input_run+0xd0c5>
 1079cea:	movzbl (%r9),%r10d
 1079cee:	cmp    $0x1,%r10d
 1079cf2:	je     1079d07 <check_input_run+0xcff7>
 1079cf4:	cmp    $0x3,%r10d
 1079cf8:	jne    1079d1a <check_input_run+0xd00a>
 1079cfa:	mov    0x14(%r9),%r10d
 1079cfe:	cmp    %eax,%r10d
 1079d01:	cmova  %r10d,%eax
 1079d05:	jmp    1079d1a <check_input_run+0xd00a>
 1079d07:	cmpb   $0xb,0x1(%r9)
 1079d0c:	jne    1079d1a <check_input_run+0xd00a>
 1079d0e:	mov    0x8(%r9),%r10
 1079d12:	cmp    %r11,%r10
 1079d15:	jbe    1079d1a <check_input_run+0xd00a>
 1079d17:	mov    %r10,%r11
 1079d1a:	movzbl 0x38(%r9),%r10d
 1079d1f:	cmp    $0x1,%r10d
 1079d23:	je     1079d38 <check_input_run+0xd028>
 1079d25:	cmp    $0x3,%r10d
 1079d29:	jne    1079d4b <check_input_run+0xd03b>
 1079d2b:	mov    0x4c(%r9),%r10d
 1079d2f:	cmp    %eax,%r10d
 1079d32:	cmova  %r10d,%eax
 1079d36:	jmp    1079d4b <check_input_run+0xd03b>
 1079d38:	cmpb   $0xb,0x39(%r9)
 1079d3d:	jne    1079d4b <check_input_run+0xd03b>
 1079d3f:	mov    0x40(%r9),%r10
 1079d43:	cmp    %r11,%r10
 1079d46:	jbe    1079d4b <check_input_run+0xd03b>
 1079d48:	mov    %r10,%r11
 1079d4b:	movzbl 0x70(%r9),%r10d
 1079d50:	cmp    $0x1,%r10d
 1079d54:	je     1079d6c <check_input_run+0xd05c>
 1079d56:	cmp    $0x3,%r10d
 1079d5a:	jne    1079d7f <check_input_run+0xd06f>
 1079d5c:	mov    0x84(%r9),%r10d
 1079d63:	cmp    %eax,%r10d
 1079d66:	cmova  %r10d,%eax
 1079d6a:	jmp    1079d7f <check_input_run+0xd06f>
 1079d6c:	cmpb   $0xb,0x71(%r9)
 1079d71:	jne    1079d7f <check_input_run+0xd06f>
 1079d73:	mov    0x78(%r9),%r10
 1079d77:	cmp    %r11,%r10
 1079d7a:	jbe    1079d7f <check_input_run+0xd06f>
 1079d7c:	mov    %r10,%r11
 1079d7f:	movzbl 0xa8(%r9),%r10d
 1079d87:	cmp    $0x1,%r10d
 1079d8b:	je     1079daf <check_input_run+0xd09f>
 1079d8d:	cmp    $0x3,%r10d
 1079d91:	jne    1079cd6 <check_input_run+0xcfc6>
 1079d97:	mov    0xbc(%r9),%r10d
 1079d9e:	cmp    %eax,%r10d
 1079da1:	ja     1079cd3 <check_input_run+0xcfc3>
 1079da7:	mov    %eax,%r10d
 1079daa:	jmp    1079cd3 <check_input_run+0xcfc3>
 1079daf:	cmpb   $0xb,0xa9(%r9)
 1079db7:	jne    1079cd6 <check_input_run+0xcfc6>
 1079dbd:	mov    0xb0(%r9),%r10
 1079dc4:	cmp    %r11,%r10
 1079dc7:	jbe    1079cd6 <check_input_run+0xcfc6>
 1079dcd:	mov    %r10,%r11
 1079dd0:	jmp    1079cd6 <check_input_run+0xcfc6>
 1079dd5:	test   %rsi,%rsi
 1079dd8:	je     1079c3f <check_input_run+0xcf2f>
 1079dde:	imul   $0x38,%r8,%rdi
 1079de2:	imul   $0x38,%rsi,%rsi
 1079de6:	lea    0x8(%rdx,%rdi,1),%rdx
 1079deb:	xor    %edi,%edi
 1079ded:	jmp    1079dfc <check_input_run+0xd0ec>
 1079def:	add    $0x38,%rdi
 1079df3:	cmp    %rdi,%rsi
 1079df6:	je     1079c3f <check_input_run+0xcf2f>
 1079dfc:	movzbl (%rdx,%rdi,1),%r8d
 1079e01:	cmp    $0x1,%r8d
 1079e05:	je     1079e1b <check_input_run+0xd10b>
 1079e07:	cmp    $0x3,%r8d
 1079e0b:	jne    1079def <check_input_run+0xd0df>
 1079e0d:	mov    0x14(%rdx,%rdi,1),%r8d
 1079e12:	cmp    %eax,%r8d
 1079e15:	cmova  %r8d,%eax
 1079e19:	jmp    1079def <check_input_run+0xd0df>
 1079e1b:	cmpb   $0xb,0x1(%rdx,%rdi,1)
 1079e20:	jne    1079def <check_input_run+0xd0df>
 1079e22:	mov    0x8(%rdx,%rdi,1),%r8
 1079e27:	cmp    %r11,%r8
 1079e2a:	jbe    1079def <check_input_run+0xd0df>
 1079e2c:	mov    %r8,%r11
 1079e2f:	jmp    1079def <check_input_run+0xd0df>
 1079e31:	xor    %ebx,%ebx
 1079e33:	mov    0x20(%rsp),%r12
 1079e38:	jmp    106fc5b <check_input_run+0x2f4b>
 1079e3d:	mov    %r11,%rcx
 1079e40:	inc    %rcx
 1079e43:	mov    %rcx,%r11
 1079e46:	shr    $0x3e,%rcx
 1079e4a:	jne    1077bcb <check_input_run+0xaebb>
 1079e50:	mov    0x2aa38(%r8),%rdx
 1079e57:	lea    0x3(%r13,%rdx,1),%rsi
 1079e5c:	lea    0x0(%r13,%rdx,1),%rcx
 1079e61:	and    $0xfffffffffffffffc,%rsi
 1079e65:	mov    %rsi,0x88(%rsp)
 1079e6d:	cmp    %rcx,%rsi
 1079e70:	jb     1077bcb <check_input_run+0xaebb>
 1079e76:	mov    0x88(%rsp),%rsi
 1079e7e:	mov    0x2aa48(%r8),%rcx
 1079e85:	sub    %rdx,%rsi
 1079e88:	mov    %rcx,%rdi
 1079e8b:	sub    %rsi,%rdi
 1079e8e:	jb     1077bcb <check_input_run+0xaebb>
 1079e94:	shl    $0x2,%r11
 1079e98:	mov    %r11,0x68(%rsp)
 1079e9d:	cmp    %rdi,%r11
 1079ea0:	ja     1077bcb <check_input_run+0xaebb>
 1079ea6:	add    0x68(%rsp),%rsi
 1079eab:	cmpq   $0x0,0x88(%rsp)
 1079eb4:	mov    %rsi,0x2aa40(%r8)
 1079ebb:	je     1077bcb <check_input_run+0xaebb>
 1079ec1:	mov    0x68(%rsp),%rsi
 1079ec6:	add    0x88(%rsp),%rsi
 1079ece:	mov    %rsi,0x68(%rsp)
 1079ed3:	sub    %rdx,%rsi
 1079ed6:	sub    %rsi,%rcx
 1079ed9:	jb     1077bcb <check_input_run+0xaebb>
 1079edf:	mov    %eax,%eax
 1079ee1:	shl    $0x4,%rax
 1079ee5:	add    $0x10,%rax
 1079ee9:	cmp    %rcx,%rax
 1079eec:	ja     1077bcb <check_input_run+0xaebb>
 1079ef2:	add    %rax,%rsi
 1079ef5:	cmpq   $0x0,0x68(%rsp)
 1079efb:	vpxor  %xmm0,%xmm0,%xmm0
 1079eff:	mov    %rsi,0x2aa40(%r8)
 1079f06:	vmovdqu64 %zmm0,0x7c0(%rsp)
 1079f0e:	vmovdqu64 %zmm0,0x780(%rsp)
 1079f16:	vmovdqu64 %zmm0,0x740(%rsp)
 1079f1e:	vmovdqu64 %zmm0,0x700(%rsp)
 1079f26:	je     107a378 <check_input_run+0xd668>
 1079f2c:	xor    %ebp,%ebp
 1079f2e:	test   %r12,%r12
 1079f31:	je     107a0f4 <check_input_run+0xd3e4>
 1079f37:	mov    0x70(%rsp),%rax
 1079f3c:	add    $0x30,%rax
 1079f40:	mov    %rax,0x110(%rsp)
 1079f48:	mov    $0x1,%eax
 1079f4d:	mov    %rax,0xc0(%rsp)
 1079f55:	movq   $0x0,0xa0(%rsp)
 1079f61:	mov    0xa0(%rsp),%rax
 1079f69:	mov    %eax,%eax
 1079f6b:	mov    %rax,0xa0(%rsp)
 1079f73:	imul   $0x38,%rax,%rax
 1079f77:	mov    %rax,0x60(%rsp)
 1079f7c:	jmp    1079fea <check_input_run+0xd2da>
 1079f7e:	mov    (%rcx),%rdx
 1079f81:	test   %rdx,%rdx
 1079f84:	jne    107a045 <check_input_run+0xd335>
 1079f8a:	xor    %eax,%eax
 1079f8c:	lea    0x700(%rsp),%rcx
 1079f94:	mov    0x70(%rsp),%rbx
 1079f99:	mov    0xa8(%rsp),%rdi
 1079fa1:	mov    0x68(%rsp),%r8
 1079fa6:	lea    0x780(%rsp),%r9
 1079fae:	mov    %rax,%rdx
 1079fb1:	mov    %rcx,(%rsp)
 1079fb5:	mov    0x88(%rsp),%rcx
 1079fbd:	mov    %rbx,%rsi
 1079fc0:	vzeroupper
 1079fc3:	call   10f9880 <type_replay_change>
 1079fc8:	mov    %rbx,%r10
 1079fcb:	mov    0xe8(%rsp),%r9
 1079fd3:	mov    0xc8(%rsp),%rbx
 1079fdb:	inc    %ebp
 1079fdd:	xor    %edx,%edx
 1079fdf:	mov    %r12,%r14
 1079fe2:	test   %al,%al
 1079fe4:	je     1077bd0 <check_input_run+0xaec0>
 1079fea:	mov    0x110(%rsp),%rax
 1079ff2:	mov    (%rax),%rcx
 1079ff5:	mov    0xa0(%rsp),%rax
 1079ffd:	cmp    0x8(%rcx),%eax
 107a000:	je     107a0bc <check_input_run+0xd3ac>
 107a006:	mov    0x70(%rsp),%rax
 107a00b:	mov    (%rax),%rax
 107a00e:	cmp    0x8(%rax),%ebp
 107a011:	jae    1079f7e <check_input_run+0xd26e>
 107a017:	mov    (%rax),%rsi
 107a01a:	mov    (%rcx),%rdx
 107a01d:	mov    %ebp,%eax
 107a01f:	imul   $0x38,%rax,%rax
 107a023:	add    %rsi,%rax
 107a026:	test   %rdx,%rdx
 107a029:	je     1079f8c <check_input_run+0xd27c>
 107a02f:	add    0x60(%rsp),%rdx
 107a034:	test   %rsi,%rsi
 107a037:	je     107a04a <check_input_run+0xd33a>
 107a039:	mov    (%rax),%ecx
 107a03b:	cmp    (%rdx),%ecx
 107a03d:	jbe    1079f8c <check_input_run+0xd27c>
 107a043:	jmp    107a04a <check_input_run+0xd33a>
 107a045:	add    0x60(%rsp),%rdx
 107a04a:	mov    0xa8(%rsp),%rdi
 107a052:	mov    0x110(%rsp),%rsi
 107a05a:	mov    0x88(%rsp),%rcx
 107a062:	mov    0x68(%rsp),%r8
 107a067:	lea    0x700(%rsp),%rax
 107a06f:	lea    0x780(%rsp),%r9
 107a077:	mov    %rax,(%rsp)
 107a07b:	vzeroupper
 107a07e:	call   10f9880 <type_replay_change>
 107a083:	mov    0xa0(%rsp),%rcx
 107a08b:	mov    0xe8(%rsp),%r9
 107a093:	mov    0xc8(%rsp),%rbx
 107a09b:	mov    0x70(%rsp),%r10
 107a0a0:	xor    %edx,%edx
 107a0a2:	mov    %r12,%r14
 107a0a5:	inc    %ecx
 107a0a7:	mov    %rcx,0xa0(%rsp)
 107a0af:	test   %al,%al
 107a0b1:	jne    1079f61 <check_input_run+0xd251>
 107a0b7:	jmp    1077bd0 <check_input_run+0xaec0>
 107a0bc:	mov    0xc0(%rsp),%rax
 107a0c4:	inc    %rax
 107a0c7:	lea    (%rax,%rax,2),%rcx
 107a0cb:	mov    %rax,0xc0(%rsp)
 107a0d3:	shl    $0x4,%rcx
 107a0d7:	add    0x70(%rsp),%rcx
 107a0dc:	mov    %rcx,0x110(%rsp)
 107a0e4:	cmp    0xd8(%rsp),%rax
 107a0ec:	jne    1079f55 <check_input_run+0xd245>
 107a0f2:	mov    %ebp,%ebp
 107a0f4:	mov    0x70(%rsp),%r10
 107a0f9:	imul   $0x38,%rbp,%rax
 107a0fd:	dec    %rbp
 107a100:	add    $0xffffffffffffffc8,%rax
 107a104:	mov    %rax,0xa0(%rsp)
 107a10c:	mov    (%r10),%rax
 107a10f:	inc    %rbp
 107a112:	mov    0x8(%rax),%ecx
 107a115:	cmp    %rcx,%rbp
 107a118:	jae    107a435 <check_input_run+0xd725>
 107a11e:	mov    0xa0(%rsp),%rcx
 107a126:	mov    (%rax),%rdx
 107a129:	mov    0x70(%rsp),%rbx
 107a12e:	mov    0xa8(%rsp),%rdi
 107a136:	mov    0x68(%rsp),%r8
 107a13b:	lea    0x700(%rsp),%rax
 107a143:	lea    0x780(%rsp),%r9
 107a14b:	mov    %rax,(%rsp)
 107a14f:	add    $0x38,%rcx
 107a153:	mov    %rbx,%rsi
 107a156:	mov    %rcx,0xa0(%rsp)
 107a15e:	add    %rcx,%rdx
 107a161:	mov    0x88(%rsp),%rcx
 107a169:	vzeroupper
 107a16c:	call   10f9880 <type_replay_change>
 107a171:	mov    %rbx,%r10
 107a174:	mov    0xe8(%rsp),%r9
 107a17c:	mov    0xc8(%rsp),%rbx
 107a184:	xor    %edx,%edx
 107a186:	mov    %r12,%r14
 107a189:	test   %al,%al
 107a18b:	jne    107a10c <check_input_run+0xd3fc>
 107a191:	jmp    1077bd0 <check_input_run+0xaec0>
 107a196:	cmp    %esi,%ecx
 107a198:	jae    10790e9 <check_input_run+0xc3d9>
 107a19e:	jmp    10790eb <check_input_run+0xc3db>
 107a1a3:	mov    0x860(%rsp),%r12
 107a1ab:	jmp    107676c <check_input_run+0x9a5c>
 107a1b0:	mov    0x10(%r14),%rdx
 107a1b4:	cmpb   $0x11,(%rdx,%rsi,1)
 107a1b8:	sete   %dl
 107a1bb:	jmp    10790eb <check_input_run+0xc3db>
 107a1c0:	mov    0x20(%rsp),%r12
 107a1c5:	mov    0x28(%rsp),%r9
 107a1ca:	add    %rdx,%rsi
 107a1cd:	mov    %rax,%r14
 107a1d0:	mov    %r15,%rdi
 107a1d3:	mov    %rsi,0x8(%rcx)
 107a1d7:	xor    %ecx,%ecx
 107a1d9:	jmp    1070f60 <check_input_run+0x4250>
 107a1de:	mov    0x78(%rsp),%rdx
 107a1e3:	mov    0x10(%rsp),%rdi
 107a1e8:	mov    0x18(%rsp),%r8
 107a1ed:	inc    %rdx
 107a1f0:	add    %rdx,%rsi
 107a1f3:	mov    %rsi,0x8(%rdi)
 107a1f7:	lea    0x268(%r8),%rdi
 107a1fe:	mov    %rcx,0x268(%r8)
 107a205:	mov    %rdi,0x40(%rsp)
 107a20a:	test   %rcx,%rcx
 107a20d:	je     107a258 <check_input_run+0xd548>
 107a20f:	mov    0x10(%rsp),%rcx
 107a214:	mov    (%rcx),%rdi
 107a217:	mov    0x8(%rcx),%rsi
 107a21b:	lea    0x7(%rsi,%rdi,1),%rcx
 107a220:	add    %rdi,%rsi
 107a223:	and    $0xfffffffffffffff8,%rcx
 107a227:	cmp    %rsi,%rcx
 107a22a:	jb     107a258 <check_input_run+0xd548>
 107a22c:	mov    %rcx,%rsi
 107a22f:	sub    %rdi,%rsi
 107a232:	mov    0x10(%rsp),%rdi
 107a237:	mov    0x10(%rdi),%rdi
 107a23b:	sub    %rsi,%rdi
 107a23e:	setb   %r8b
 107a242:	cmp    0x78(%rsp),%rdi
 107a247:	setbe  %dil
 107a24b:	or     %r8b,%dil
 107a24e:	cmp    $0x1,%dil
 107a252:	jne    107a2e9 <check_input_run+0xd5d9>
 107a258:	mov    0x18(%rsp),%rdi
 107a25d:	mov    0x10(%rsp),%rsi
 107a262:	mov    0x20(%rsp),%r12
 107a267:	mov    0x40(%rsp),%rax
 107a26c:	mov    0x30(%rsp),%r9
 107a271:	jmp    106d568 <check_input_run+0x858>
 107a276:	mov    0x860(%rsp),%r12
 107a27e:	movq   $0x0,0x2a838(%r12,%rdx,8)
 107a28a:	jmp    107676c <check_input_run+0x9a5c>
 107a28f:	lea    -0x982266(%rip),%rdi        # 6f8030 <pp_string_value.meaning+0x6faaf>
 107a296:	lea    -0x9c8fb4(%rip),%rsi        # 6b12e9 <pp_string_value.meaning+0x28d68>
 107a29d:	lea    -0x9c8fa0(%rip),%rcx        # 6b1304 <pp_string_value.meaning+0x28d83>
 107a2a4:	mov    $0xbd,%edx
 107a2a9:	vzeroupper
 107a2ac:	call   787950 <__assert_fail@plt>
 107a2b1:	vzeroupper
 107a2b4:	call   7878e0 <__stack_chk_fail@plt>
 107a2b9:	xor    %eax,%eax
 107a2bb:	mov    0x860(%rsp),%r12
 107a2c3:	mov    $0x1,%bpl
 107a2c6:	mov    %r12,0x278(%rsp)
 107a2ce:	mov    $0xffffffffffffffff,%rcx
 107a2d5:	cmpb   $0x0,0x2aaa0(%r12)
 107a2de:	je     1076797 <check_input_run+0x9a87>
 107a2e4:	jmp    10767c1 <check_input_run+0x9ab1>
 107a2e9:	mov    0x10(%rsp),%rdi
 107a2ee:	mov    0x18(%rsp),%r8
 107a2f3:	add    %rdx,%rsi
 107a2f6:	mov    %rsi,0x8(%rdi)
 107a2fa:	lea    0x250(%r8),%rdi
 107a301:	mov    %rcx,0x250(%r8)
 107a308:	mov    %rdi,0xa0(%rsp)
 107a310:	test   %rcx,%rcx
 107a313:	je     107a35a <check_input_run+0xd64a>
 107a315:	mov    0x10(%rsp),%rcx
 107a31a:	mov    (%rcx),%rdi
 107a31d:	mov    0x8(%rcx),%rsi
 107a321:	lea    0x7(%rsi,%rdi,1),%rcx
 107a326:	add    %rdi,%rsi
 107a329:	and    $0xfffffffffffffff8,%rcx
 107a32d:	cmp    %rsi,%rcx
 107a330:	jb     107a35a <check_input_run+0xd64a>
 107a332:	mov    %rcx,%rsi
 107a335:	sub    %rdi,%rsi
 107a338:	mov    0x10(%rsp),%rdi
 107a33d:	mov    0x10(%rdi),%rdi
 107a341:	sub    %rsi,%rdi
 107a344:	setb   %r8b
 107a348:	cmp    0x78(%rsp),%rdi
 107a34d:	setbe  %dil
 107a351:	or     %r8b,%dil
 107a354:	cmp    $0x1,%dil
 107a358:	jne    107a397 <check_input_run+0xd687>
 107a35a:	mov    0x18(%rsp),%rdi
 107a35f:	mov    0x10(%rsp),%rsi
 107a364:	mov    0x20(%rsp),%r12
 107a369:	mov    0x40(%rsp),%rax
 107a36e:	mov    0x30(%rsp),%r9
 107a373:	jmp    106d582 <check_input_run+0x872>
 107a378:	xor    %edx,%edx
 107a37a:	mov    0xe8(%rsp),%r9
 107a382:	mov    0xc8(%rsp),%rbx
 107a38a:	mov    0x70(%rsp),%r10
 107a38f:	mov    %r12,%r14
 107a392:	jmp    1077bd0 <check_input_run+0xaec0>
 107a397:	mov    0x10(%rsp),%rdi
 107a39c:	mov    0x18(%rsp),%r8
 107a3a1:	add    %rdx,%rsi
 107a3a4:	mov    %rsi,0x8(%rdi)
 107a3a8:	lea    0x258(%r8),%rdi
 107a3af:	mov    %rcx,0x258(%r8)
 107a3b6:	mov    %rdi,0x110(%rsp)
 107a3be:	test   %rcx,%rcx
 107a3c1:	je     107a40c <check_input_run+0xd6fc>
 107a3c3:	mov    0x10(%rsp),%rcx
 107a3c8:	mov    (%rcx),%rdi
 107a3cb:	mov    0x8(%rcx),%rsi
 107a3cf:	lea    0x7(%rsi,%rdi,1),%rcx
 107a3d4:	add    %rdi,%rsi
 107a3d7:	and    $0xfffffffffffffff8,%rcx
 107a3db:	cmp    %rsi,%rcx
 107a3de:	jb     107a40c <check_input_run+0xd6fc>
 107a3e0:	mov    %rcx,%rsi
 107a3e3:	sub    %rdi,%rsi
 107a3e6:	mov    0x10(%rsp),%rdi
 107a3eb:	mov    0x10(%rdi),%rdi
 107a3ef:	sub    %rsi,%rdi
 107a3f2:	setb   %r8b
 107a3f6:	cmp    0x78(%rsp),%rdi
 107a3fb:	setbe  %dil
 107a3ff:	or     %r8b,%dil
 107a402:	cmp    $0x1,%dil
 107a406:	jne    107a673 <check_input_run+0xd963>
 107a40c:	mov    0x18(%rsp),%rdi
 107a411:	mov    0x10(%rsp),%rsi
 107a416:	mov    0x20(%rsp),%r12
 107a41b:	mov    0x40(%rsp),%rax
 107a420:	mov    0x30(%rsp),%r9
 107a425:	movq   $0x0,0x270(%rdi)
 107a430:	jmp    106d5a7 <check_input_run+0x897>
 107a435:	mov    0xd8(%rsp),%rax
 107a43d:	and    $0x3,%eax
 107a440:	cmpl   $0x4,0x100(%rsp)
 107a448:	jae    107a45d <check_input_run+0xd74d>
 107a44a:	xor    %r9d,%r9d
 107a44d:	xor    %ecx,%ecx
 107a44f:	xor    %esi,%esi
 107a451:	xor    %edi,%edi
 107a453:	xor    %edx,%edx
 107a455:	xor    %r8d,%r8d
 107a458:	jmp    107a5e9 <check_input_run+0xd8d9>
 107a45d:	mov    0xd8(%rsp),%rcx
 107a465:	mov    0x70(%rsp),%r10
 107a46a:	xor    %r9d,%r9d
 107a46d:	xor    %esi,%esi
 107a46f:	xor    %edi,%edi
 107a471:	xor    %edx,%edx
 107a473:	xor    %r8d,%r8d
 107a476:	and    $0xfffffffc,%ecx
 107a479:	mov    %rcx,0xd8(%rsp)
 107a481:	xor    %ecx,%ecx
 107a483:	jmp    107a4b2 <check_input_run+0xd7a2>
 107a485:	mov    0x40(%r11),%edx
 107a489:	mov    0x44(%r11),%esi
 107a48d:	mov    0x48(%r11),%ecx
 107a491:	mov    $0x1,%edi
 107a496:	mov    $0x1,%r8b
 107a499:	add    $0x4,%r9
 107a49d:	add    $0xc0,%r10
 107a4a4:	cmp    %r9,0xd8(%rsp)
 107a4ac:	je     107a5e4 <check_input_run+0xd8d4>
 107a4b2:	mov    (%r10),%r14
 107a4b5:	xor    %r11d,%r11d
 107a4b8:	test   %r9,%r9
 107a4bb:	mov    $0x1,%bpl
 107a4be:	setne  %r11b
 107a4c2:	cmp    $0x1,%r8b
 107a4c6:	jne    107a4ce <check_input_run+0xd7be>
 107a4c8:	cmp    %edx,0x40(%r14)
 107a4cc:	jbe    107a4ee <check_input_run+0xd7de>
 107a4ce:	cmpb   $0x1,0x3c(%r14)
 107a4d3:	jne    107a504 <check_input_run+0xd7f4>
 107a4d5:	test   %bpl,%bpl
 107a4d8:	je     107a504 <check_input_run+0xd7f4>
 107a4da:	mov    0x40(%r14),%edx
 107a4de:	mov    0x44(%r14),%esi
 107a4e2:	mov    0x48(%r14),%ecx
 107a4e6:	mov    $0x1,%r8b
 107a4e9:	mov    %r11d,%edi
 107a4ec:	jmp    107a504 <check_input_run+0xd7f4>
 107a4ee:	jne    107a501 <check_input_run+0xd7f1>
 107a4f0:	cmp    %r11d,%edi
 107a4f3:	jb     107a4ce <check_input_run+0xd7be>
 107a4f5:	jne    107a501 <check_input_run+0xd7f1>
 107a4f7:	cmp    %esi,0x44(%r14)
 107a4fb:	seta   %bpl
 107a4ff:	jmp    107a4ce <check_input_run+0xd7be>
 107a501:	mov    $0x1,%r8b
 107a504:	mov    0x30(%r10),%r11
 107a508:	mov    $0x1,%bpl
 107a50b:	cmp    $0x1,%r8b
 107a50f:	jne    107a517 <check_input_run+0xd807>
 107a511:	cmp    %edx,0x40(%r11)
 107a515:	jbe    107a536 <check_input_run+0xd826>
 107a517:	cmpb   $0x1,0x3c(%r11)
 107a51c:	jne    107a54e <check_input_run+0xd83e>
 107a51e:	test   %bpl,%bpl
 107a521:	je     107a54e <check_input_run+0xd83e>
 107a523:	mov    0x40(%r11),%edx
 107a527:	mov    0x44(%r11),%esi
 107a52b:	mov    0x48(%r11),%ecx
 107a52f:	mov    $0x1,%edi
 107a534:	jmp    107a54b <check_input_run+0xd83b>
 107a536:	jne    107a54b <check_input_run+0xd83b>
 107a538:	test   %edi,%edi
 107a53a:	je     107a517 <check_input_run+0xd807>
 107a53c:	cmp    $0x1,%edi
 107a53f:	jne    107a54b <check_input_run+0xd83b>
 107a541:	cmp    %esi,0x44(%r11)
 107a545:	seta   %bpl
 107a549:	jmp    107a517 <check_input_run+0xd807>
 107a54b:	mov    $0x1,%r8b
 107a54e:	mov    0x60(%r10),%r11
 107a552:	mov    $0x1,%bpl
 107a555:	cmp    $0x1,%r8b
 107a559:	jne    107a561 <check_input_run+0xd851>
 107a55b:	cmp    %edx,0x40(%r11)
 107a55f:	jbe    107a580 <check_input_run+0xd870>
 107a561:	cmpb   $0x1,0x3c(%r11)
 107a566:	jne    107a598 <check_input_run+0xd888>
 107a568:	test   %bpl,%bpl
 107a56b:	je     107a598 <check_input_run+0xd888>
 107a56d:	mov    0x40(%r11),%edx
 107a571:	mov    0x44(%r11),%esi
 107a575:	mov    0x48(%r11),%ecx
 107a579:	mov    $0x1,%edi
 107a57e:	jmp    107a595 <check_input_run+0xd885>
 107a580:	jne    107a595 <check_input_run+0xd885>
 107a582:	test   %edi,%edi
 107a584:	je     107a561 <check_input_run+0xd851>
 107a586:	cmp    $0x1,%edi
 107a589:	jne    107a595 <check_input_run+0xd885>
 107a58b:	cmp    %esi,0x44(%r11)
 107a58f:	seta   %bpl
 107a593:	jmp    107a561 <check_input_run+0xd851>
 107a595:	mov    $0x1,%r8b
 107a598:	mov    0x90(%r10),%r11
 107a59f:	mov    $0x1,%bpl
 107a5a2:	cmp    $0x1,%r8b
 107a5a6:	jne    107a5ae <check_input_run+0xd89e>
 107a5a8:	cmp    %edx,0x40(%r11)
 107a5ac:	jbe    107a5c7 <check_input_run+0xd8b7>
 107a5ae:	cmpb   $0x1,0x3c(%r11)
 107a5b3:	jne    107a499 <check_input_run+0xd789>
 107a5b9:	test   %bpl,%bpl
 107a5bc:	jne    107a485 <check_input_run+0xd775>
 107a5c2:	jmp    107a499 <check_input_run+0xd789>
 107a5c7:	jne    107a496 <check_input_run+0xd786>
 107a5cd:	test   %edi,%edi
 107a5cf:	je     107a5ae <check_input_run+0xd89e>
 107a5d1:	cmp    $0x1,%edi
 107a5d4:	jne    107a496 <check_input_run+0xd786>
 107a5da:	cmp    %esi,0x44(%r11)
 107a5de:	seta   %bpl
 107a5e2:	jmp    107a5ae <check_input_run+0xd89e>
 107a5e4:	test   %rax,%rax
 107a5e7:	je     107a654 <check_input_run+0xd944>
 107a5e9:	shl    $0x4,%r9
 107a5ed:	lea    (%r9,%r9,2),%r9
 107a5f1:	jmp    107a5ff <check_input_run+0xd8ef>
 107a5f3:	mov    $0x1,%r8b
 107a5f6:	add    $0x30,%r9
 107a5fa:	dec    %rax
 107a5fd:	je     107a654 <check_input_run+0xd944>
 107a5ff:	mov    0x70(%rsp),%r10
 107a604:	mov    $0x1,%bpl
 107a607:	mov    (%r10,%r9,1),%r11
 107a60b:	xor    %r10d,%r10d
 107a60e:	test   %r9,%r9
 107a611:	setne  %r10b
 107a615:	cmp    $0x1,%r8b
 107a619:	jne    107a621 <check_input_run+0xd911>
 107a61b:	cmp    %edx,0x40(%r11)
 107a61f:	jbe    107a641 <check_input_run+0xd931>
 107a621:	cmpb   $0x1,0x3c(%r11)
 107a626:	jne    107a5f6 <check_input_run+0xd8e6>
 107a628:	test   %bpl,%bpl
 107a62b:	je     107a5f6 <check_input_run+0xd8e6>
 107a62d:	mov    0x40(%r11),%edx
 107a631:	mov    0x44(%r11),%esi
 107a635:	mov    0x48(%r11),%ecx
 107a639:	mov    $0x1,%r8b
 107a63c:	mov    %r10d,%edi
 107a63f:	jmp    107a5f6 <check_input_run+0xd8e6>
 107a641:	jne    107a5f3 <check_input_run+0xd8e3>
 107a643:	cmp    %r10d,%edi
 107a646:	jb     107a621 <check_input_run+0xd911>
 107a648:	jne    107a5f3 <check_input_run+0xd8e3>
 107a64a:	cmp    %esi,0x44(%r11)
 107a64e:	seta   %bpl
 107a652:	jmp    107a621 <check_input_run+0xd911>
 107a654:	mov    $0x1,%dl
 107a656:	test   $0x1,%r8b
 107a65a:	je     107a37a <check_input_run+0xd66a>
 107a660:	mov    0xa8(%rsp),%rax
 107a668:	mov    %ecx,0x100(%rax)
 107a66e:	jmp    107a37a <check_input_run+0xd66a>
 107a673:	mov    0x10(%rsp),%rdi
 107a678:	add    %rdx,%rsi
 107a67b:	mov    %rsi,0x8(%rdi)
 107a67f:	mov    0x18(%rsp),%rdi
 107a684:	mov    %rcx,0x270(%rdi)
 107a68b:	test   %rcx,%rcx
 107a68e:	je     107a6d5 <check_input_run+0xd9c5>
 107a690:	mov    0x10(%rsp),%rcx
 107a695:	mov    (%rcx),%rdi
 107a698:	mov    0x8(%rcx),%rsi
 107a69c:	lea    0x7(%rsi,%rdi,1),%rcx
 107a6a1:	add    %rdi,%rsi
 107a6a4:	and    $0xfffffffffffffff8,%rcx
 107a6a8:	cmp    %rsi,%rcx
 107a6ab:	jb     107a6d5 <check_input_run+0xd9c5>
 107a6ad:	mov    %rcx,%rsi
 107a6b0:	sub    %rdi,%rsi
 107a6b3:	mov    0x10(%rsp),%rdi
 107a6b8:	mov    0x10(%rdi),%rdi
 107a6bc:	sub    %rsi,%rdi
 107a6bf:	setb   %r8b
 107a6c3:	cmp    0x78(%rsp),%rdi
 107a6c8:	setbe  %dil
 107a6cc:	or     %r8b,%dil
 107a6cf:	cmp    $0x1,%dil
 107a6d3:	jne    107a6f3 <check_input_run+0xd9e3>
 107a6d5:	mov    0x18(%rsp),%rdi
 107a6da:	mov    0x10(%rsp),%rsi
 107a6df:	mov    0x20(%rsp),%r12
 107a6e4:	mov    0x40(%rsp),%rax
 107a6e9:	mov    0x30(%rsp),%r9
 107a6ee:	jmp    106d5a7 <check_input_run+0x897>
 107a6f3:	mov    0x10(%rsp),%rdi
 107a6f8:	mov    0x18(%rsp),%r8
 107a6fd:	add    %rdx,%rsi
 107a700:	mov    %rsi,0x8(%rdi)
 107a704:	lea    0x278(%r8),%rdi
 107a70b:	mov    %rcx,0x278(%r8)
 107a712:	mov    %rdi,0x60(%rsp)
 107a717:	test   %rcx,%rcx
 107a71a:	je     107a761 <check_input_run+0xda51>
 107a71c:	mov    0x10(%rsp),%rcx
 107a721:	mov    (%rcx),%rdi
 107a724:	mov    0x8(%rcx),%rsi
 107a728:	lea    0x7(%rsi,%rdi,1),%rcx
 107a72d:	add    %rdi,%rsi
 107a730:	and    $0xfffffffffffffff8,%rcx
 107a734:	cmp    %rsi,%rcx
 107a737:	jb     107a761 <check_input_run+0xda51>
 107a739:	mov    %rcx,%rsi
 107a73c:	sub    %rdi,%rsi
 107a73f:	mov    0x10(%rsp),%rdi
 107a744:	mov    0x10(%rdi),%rdi
 107a748:	sub    %rsi,%rdi
 107a74b:	setb   %r8b
 107a74f:	cmp    0x78(%rsp),%rdi
 107a754:	setbe  %dil
 107a758:	or     %r8b,%dil
 107a75b:	cmp    $0x1,%dil
 107a75f:	jne    107a77f <check_input_run+0xda6f>
 107a761:	mov    0x18(%rsp),%rdi
 107a766:	mov    0x10(%rsp),%rsi
 107a76b:	mov    0x20(%rsp),%r12
 107a770:	mov    0x40(%rsp),%rax
 107a775:	mov    0x30(%rsp),%r9
 107a77a:	jmp    106d5be <check_input_run+0x8ae>
 107a77f:	mov    0x10(%rsp),%rdi
 107a784:	mov    0x18(%rsp),%r8
 107a789:	add    %rdx,%rsi
 107a78c:	mov    %rsi,0x8(%rdi)
 107a790:	lea    0x280(%r8),%rdi
 107a797:	mov    %rcx,0x280(%r8)
 107a79e:	mov    %rdi,0xc0(%rsp)
 107a7a6:	test   %rcx,%rcx
 107a7a9:	je     107a7c8 <check_input_run+0xdab8>
 107a7ab:	mov    0x10(%rsp),%rcx
 107a7b0:	mov    (%rcx),%rdi
 107a7b3:	mov    0x8(%rcx),%rsi
 107a7b7:	lea    0x7(%rsi,%rdi,1),%rcx
 107a7bc:	add    %rdi,%rsi
 107a7bf:	and    $0xfffffffffffffff8,%rcx
 107a7c3:	cmp    %rsi,%rcx
 107a7c6:	jae    107a7e6 <check_input_run+0xdad6>
 107a7c8:	mov    0x18(%rsp),%rdi
 107a7cd:	mov    0x10(%rsp),%rsi
 107a7d2:	mov    0x20(%rsp),%r12
 107a7d7:	mov    0x40(%rsp),%rax
 107a7dc:	mov    0x30(%rsp),%r9
 107a7e1:	jmp    106d5d8 <check_input_run+0x8c8>
 107a7e6:	mov    %rcx,%rsi
 107a7e9:	sub    %rdi,%rsi
 107a7ec:	mov    0x10(%rsp),%rdi
 107a7f1:	mov    0x10(%rdi),%rdi
 107a7f5:	sub    %rsi,%rdi
 107a7f8:	jb     107a7c8 <check_input_run+0xdab8>
 107a7fa:	mov    0x78(%rsp),%r8
 107a7ff:	lea    0x8(,%r8,8),%r8
 107a807:	cmp    %rdi,%r8
 107a80a:	ja     107a7c8 <check_input_run+0xdab8>
 107a80c:	add    %r8,%rsi
 107a80f:	mov    0x10(%rsp),%rdi
 107a814:	mov    0x18(%rsp),%r8
 107a819:	mov    %rsi,0x8(%rdi)
 107a81d:	lea    0x288(%r8),%rdi
 107a824:	mov    %rcx,0x288(%r8)
 107a82b:	mov    %rdi,0x48(%rsp)
 107a830:	test   %rcx,%rcx
 107a833:	je     107a87e <check_input_run+0xdb6e>
 107a835:	mov    0x10(%rsp),%rcx
 107a83a:	mov    (%rcx),%rdi
 107a83d:	mov    0x8(%rcx),%rsi
 107a841:	lea    0x7(%rsi,%rdi,1),%rcx
 107a846:	add    %rdi,%rsi
 107a849:	and    $0xfffffffffffffff8,%rcx
 107a84d:	cmp    %rsi,%rcx
 107a850:	jb     107a87e <check_input_run+0xdb6e>
 107a852:	mov    %rcx,%rsi
 107a855:	sub    %rdi,%rsi
 107a858:	mov    0x10(%rsp),%rdi
 107a85d:	mov    0x10(%rdi),%rdi
 107a861:	sub    %rsi,%rdi
 107a864:	setb   %r8b
 107a868:	cmp    0x78(%rsp),%rdi
 107a86d:	setbe  %dil
 107a871:	or     %r8b,%dil
 107a874:	cmp    $0x1,%dil
 107a878:	jne    107c8c7 <check_input_run+0xfbb7>
 107a87e:	mov    0x18(%rsp),%rdi
 107a883:	mov    0x10(%rsp),%rsi
 107a888:	mov    0x20(%rsp),%r12
 107a88d:	mov    0x40(%rsp),%rax
 107a892:	mov    0x30(%rsp),%r9
 107a897:	movq   $0x0,0x290(%rdi)
 107a8a2:	movq   $0x0,0x298(%rdi)
 107a8ad:	jmp    106d605 <check_input_run+0x8f5>
 107a8b2:	mov    0x1b0(%rsp),%r14
 107a8ba:	mov    0x60(%rsp),%r8
 107a8bf:	shr    $0x3,%r8d
 107a8c3:	xor    %r10d,%r10d
 107a8c6:	imul   $0xa80,%r8,%r9
 107a8cd:	xor    %r8d,%r8d
 107a8d0:	mov    (%r14),%r11
 107a8d3:	mov    0xb0(%r11,%r10,1),%r11d
 107a8db:	mov    %r11d,(%rsi,%r8,4)
 107a8df:	mov    (%r14),%r11
 107a8e2:	mov    0x200(%r11,%r10,1),%r11d
 107a8ea:	mov    %r11d,0x4(%rsi,%r8,4)
 107a8ef:	mov    (%r14),%r11
 107a8f2:	mov    0x350(%r11,%r10,1),%r11d
 107a8fa:	mov    %r11d,0x8(%rsi,%r8,4)
 107a8ff:	mov    (%r14),%r11
 107a902:	mov    0x4a0(%r11,%r10,1),%r11d
 107a90a:	mov    %r11d,0xc(%rsi,%r8,4)
 107a90f:	mov    (%r14),%r11
 107a912:	mov    0x5f0(%r11,%r10,1),%r11d
 107a91a:	mov    %r11d,0x10(%rsi,%r8,4)
 107a91f:	mov    (%r14),%r11
 107a922:	mov    0x740(%r11,%r10,1),%r11d
 107a92a:	mov    %r11d,0x14(%rsi,%r8,4)
 107a92f:	mov    (%r14),%r11
 107a932:	mov    0x890(%r11,%r10,1),%r11d
 107a93a:	mov    %r11d,0x18(%rsi,%r8,4)
 107a93f:	mov    (%r14),%r11
 107a942:	mov    0x9e0(%r11,%r10,1),%r11d
 107a94a:	add    $0xa80,%r10
 107a951:	mov    %r11d,0x1c(%rsi,%r8,4)
 107a956:	add    $0x8,%r8
 107a95a:	cmp    %r10,%r9
 107a95d:	jne    107a8d0 <check_input_run+0xdbc0>
 107a963:	test   %rdi,%rdi
 107a966:	je     107a99c <check_input_run+0xdc8c>
 107a968:	lea    (%rsi,%r8,4),%r9
 107a96c:	imul   $0x150,%r8,%r8
 107a973:	xor    %r10d,%r10d
 107a976:	mov    0x1b0(%rsp),%r11
 107a97e:	mov    (%r11),%r11
 107a981:	mov    0xb0(%r11,%r8,1),%r11d
 107a989:	add    $0x150,%r8
 107a990:	mov    %r11d,(%r9,%r10,4)
 107a994:	inc    %r10
 107a997:	cmp    %r10,%rdi
 107a99a:	jne    107a976 <check_input_run+0xdc66>
 107a99c:	mov    0x68(%rsp),%r10
 107a9a1:	lea    0x1(%r10),%r8d
 107a9a5:	cmp    $0x1,%r8d
 107a9a9:	adc    $0x1,%r10d
 107a9ad:	mov    %r10d,%edi
 107a9b0:	and    $0x3,%edi
 107a9b3:	cmp    $0x4,%r8d
 107a9b7:	jae    107a9d0 <check_input_run+0xdcc0>
 107a9b9:	xor    %r8d,%r8d
 107a9bc:	xor    %r9d,%r9d
 107a9bf:	movq   $0x0,0xb8(%rsp)
 107a9cb:	jmp    107ac0a <check_input_run+0xdefa>
 107a9d0:	and    $0xfffffffc,%r10d
 107a9d4:	xor    %r8d,%r8d
 107a9d7:	xor    %r9d,%r9d
 107a9da:	movq   $0x0,0xb8(%rsp)
 107a9e6:	jmp    107a9f5 <check_input_run+0xdce5>
 107a9e8:	add    $0x4,%r8
 107a9ec:	cmp    %r10,%r8
 107a9ef:	je     107ac01 <check_input_run+0xdef1>
 107a9f5:	mov    0x28(%rsp),%rcx
 107a9fa:	cmp    (%rcx),%r9d
 107a9fd:	jae    107aa5b <check_input_run+0xdd4b>
 107a9ff:	mov    %r9d,%r9d
 107aa02:	lea    (%r9,%r9,2),%r11
 107aa06:	lea    0x6(,%r11,4),%r11
 107aa0e:	mov    0x860(%rsp),%r14
 107aa16:	mov    0x1d0(%r14),%r14
 107aa1d:	cmp    %r8d,(%r14,%r11,4)
 107aa21:	ja     107aa5b <check_input_run+0xdd4b>
 107aa23:	mov    0xb8(%rsp),%r15
 107aa2b:	mov    0x80(%rsp),%r14
 107aa33:	mov    0x28(%rsp),%rcx
 107aa38:	add    $0xc,%r11
 107aa3c:	lea    (%r15,%r8,1),%ebp
 107aa40:	mov    %ebp,(%r14,%r9,4)
 107aa44:	add    (%rsi,%r9,4),%r15d
 107aa48:	mov    (%rcx),%r14d
 107aa4b:	inc    %r9
 107aa4e:	mov    %r15,0xb8(%rsp)
 107aa56:	cmp    %r14,%r9
 107aa59:	jb     107aa0e <check_input_run+0xdcfe>
 107aa5b:	cmp    0x68(%rsp),%r8
 107aa60:	jae    107aa72 <check_input_run+0xdd62>
 107aa62:	mov    0xb8(%rsp),%r11
 107aa6a:	add    %r8d,%r11d
 107aa6d:	mov    %r11d,0x0(%r13,%r8,4)
 107aa72:	mov    0x28(%rsp),%rcx
 107aa77:	lea    0x1(%r8),%r11
 107aa7b:	cmp    (%rcx),%r9d
 107aa7e:	jae    107aadc <check_input_run+0xddcc>
 107aa80:	mov    %r9d,%r9d
 107aa83:	lea    (%r9,%r9,2),%r14
 107aa87:	lea    0x6(,%r14,4),%r14
 107aa8f:	mov    0x860(%rsp),%r15
 107aa97:	mov    0x1d0(%r15),%r15
 107aa9e:	cmp    %r11d,(%r15,%r14,4)
 107aaa2:	ja     107aadc <check_input_run+0xddcc>
 107aaa4:	mov    0xb8(%rsp),%r12
 107aaac:	mov    0x80(%rsp),%r15
 107aab4:	mov    0x28(%rsp),%rcx
 107aab9:	add    $0xc,%r14
 107aabd:	lea    (%r12,%r11,1),%ebp
 107aac1:	mov    %ebp,(%r15,%r9,4)
 107aac5:	add    (%rsi,%r9,4),%r12d
 107aac9:	mov    (%rcx),%r15d
 107aacc:	inc    %r9
 107aacf:	mov    %r12,0xb8(%rsp)
 107aad7:	cmp    %r15,%r9
 107aada:	jb     107aa8f <check_input_run+0xdd7f>
 107aadc:	cmp    0x68(%rsp),%r11
 107aae1:	jae    107aaf4 <check_input_run+0xdde4>
 107aae3:	mov    0xb8(%rsp),%r14
 107aaeb:	lea    (%r14,%r11,1),%ebp
 107aaef:	mov    %ebp,0x0(%r13,%r11,4)
 107aaf4:	mov    0x28(%rsp),%rcx
 107aaf9:	lea    0x2(%r8),%r11
 107aafd:	cmp    (%rcx),%r9d
 107ab00:	jae    107ab5e <check_input_run+0xde4e>
 107ab02:	mov    %r9d,%r9d
 107ab05:	lea    (%r9,%r9,2),%r14
 107ab09:	lea    0x6(,%r14,4),%r14
 107ab11:	mov    0x860(%rsp),%r15
 107ab19:	mov    0x1d0(%r15),%r15
 107ab20:	cmp    %r11d,(%r15,%r14,4)
 107ab24:	ja     107ab5e <check_input_run+0xde4e>
 107ab26:	mov    0xb8(%rsp),%r12
 107ab2e:	mov    0x80(%rsp),%r15
 107ab36:	mov    0x28(%rsp),%rcx
 107ab3b:	add    $0xc,%r14
 107ab3f:	lea    (%r12,%r11,1),%ebp
 107ab43:	mov    %ebp,(%r15,%r9,4)
 107ab47:	add    (%rsi,%r9,4),%r12d
 107ab4b:	mov    (%rcx),%r15d
 107ab4e:	inc    %r9
 107ab51:	mov    %r12,0xb8(%rsp)
 107ab59:	cmp    %r15,%r9
 107ab5c:	jb     107ab11 <check_input_run+0xde01>
 107ab5e:	cmp    0x68(%rsp),%r11
 107ab63:	jae    107ab76 <check_input_run+0xde66>
 107ab65:	mov    0xb8(%rsp),%r14
 107ab6d:	lea    (%r14,%r11,1),%ebp
 107ab71:	mov    %ebp,0x0(%r13,%r11,4)
 107ab76:	mov    0x28(%rsp),%rcx
 107ab7b:	lea    0x3(%r8),%r11
 107ab7f:	cmp    (%rcx),%r9d
 107ab82:	jae    107abe0 <check_input_run+0xded0>
 107ab84:	mov    %r9d,%r9d
 107ab87:	lea    (%r9,%r9,2),%r14
 107ab8b:	lea    0x6(,%r14,4),%r14
 107ab93:	mov    0x860(%rsp),%r15
 107ab9b:	mov    0x1d0(%r15),%r15
 107aba2:	cmp    %r11d,(%r15,%r14,4)
 107aba6:	ja     107abe0 <check_input_run+0xded0>
 107aba8:	mov    0xb8(%rsp),%r12
 107abb0:	mov    0x80(%rsp),%r15
 107abb8:	mov    0x28(%rsp),%rcx
 107abbd:	add    $0xc,%r14
 107abc1:	lea    (%r12,%r11,1),%ebp
 107abc5:	mov    %ebp,(%r15,%r9,4)
 107abc9:	add    (%rsi,%r9,4),%r12d
 107abcd:	mov    (%rcx),%r15d
 107abd0:	inc    %r9
 107abd3:	mov    %r12,0xb8(%rsp)
 107abdb:	cmp    %r15,%r9
 107abde:	jb     107ab93 <check_input_run+0xde83>
 107abe0:	cmp    0x68(%rsp),%r11
 107abe5:	jae    107a9e8 <check_input_run+0xdcd8>
 107abeb:	mov    0xb8(%rsp),%r14
 107abf3:	lea    (%r14,%r11,1),%ebp
 107abf7:	mov    %ebp,0x0(%r13,%r11,4)
 107abfc:	jmp    107a9e8 <check_input_run+0xdcd8>
 107ac01:	test   %rdi,%rdi
 107ac04:	je     107aca0 <check_input_run+0xdf90>
 107ac0a:	xor    %r10d,%r10d
 107ac0d:	jmp    107ac1e <check_input_run+0xdf0e>
 107ac0f:	inc    %r8
 107ac12:	inc    %r10
 107ac15:	cmp    %rdi,%r10
 107ac18:	je     107aca0 <check_input_run+0xdf90>
 107ac1e:	mov    0x28(%rsp),%rcx
 107ac23:	cmp    (%rcx),%r9d
 107ac26:	jae    107ac84 <check_input_run+0xdf74>
 107ac28:	mov    %r9d,%r9d
 107ac2b:	lea    (%r9,%r9,2),%r11
 107ac2f:	lea    0x6(,%r11,4),%r11
 107ac37:	mov    0x860(%rsp),%r14
 107ac3f:	mov    0x1d0(%r14),%r14
 107ac46:	cmp    %r8d,(%r14,%r11,4)
 107ac4a:	ja     107ac84 <check_input_run+0xdf74>
 107ac4c:	mov    0xb8(%rsp),%r15
 107ac54:	mov    0x80(%rsp),%r14
 107ac5c:	mov    0x28(%rsp),%rcx
 107ac61:	add    $0xc,%r11
 107ac65:	lea    (%r15,%r8,1),%ebp
 107ac69:	mov    %ebp,(%r14,%r9,4)
 107ac6d:	add    (%rsi,%r9,4),%r15d
 107ac71:	mov    (%rcx),%r14d
 107ac74:	inc    %r9
 107ac77:	mov    %r15,0xb8(%rsp)
 107ac7f:	cmp    %r14,%r9
 107ac82:	jb     107ac37 <check_input_run+0xdf27>
 107ac84:	cmp    0x68(%rsp),%r8
 107ac89:	jae    107ac0f <check_input_run+0xdeff>
 107ac8b:	mov    0xb8(%rsp),%r11
 107ac93:	add    %r8d,%r11d
 107ac96:	mov    %r11d,0x0(%r13,%r8,4)
 107ac9b:	jmp    107ac0f <check_input_run+0xdeff>
 107aca0:	cmpl   $0x0,0x60(%rsp)
 107aca5:	je     107adae <check_input_run+0xe09e>
 107acab:	mov    0x60(%rsp),%r8
 107acb0:	mov    %r8d,%edi
 107acb3:	and    $0x7,%edi
 107acb6:	cmp    $0x8,%r8d
 107acba:	jae    107acc4 <check_input_run+0xdfb4>
 107acbc:	xor    %r8d,%r8d
 107acbf:	jmp    107ad7a <check_input_run+0xe06a>
 107acc4:	mov    0x1b0(%rsp),%r14
 107accc:	mov    0x60(%rsp),%r8
 107acd1:	shr    $0x3,%r8d
 107acd5:	xor    %r10d,%r10d
 107acd8:	imul   $0xa80,%r8,%r9
 107acdf:	xor    %r8d,%r8d
 107ace2:	mov    (%r14),%r11
 107ace5:	mov    0xc0(%r11,%r10,1),%r11d
 107aced:	mov    %r11d,(%rsi,%r8,4)
 107acf1:	mov    (%r14),%r11
 107acf4:	mov    0x210(%r11,%r10,1),%r11d
 107acfc:	mov    %r11d,0x4(%rsi,%r8,4)
 107ad01:	mov    (%r14),%r11
 107ad04:	mov    0x360(%r11,%r10,1),%r11d
 107ad0c:	mov    %r11d,0x8(%rsi,%r8,4)
 107ad11:	mov    (%r14),%r11
 107ad14:	mov    0x4b0(%r11,%r10,1),%r11d
 107ad1c:	mov    %r11d,0xc(%rsi,%r8,4)
 107ad21:	mov    (%r14),%r11
 107ad24:	mov    0x600(%r11,%r10,1),%r11d
 107ad2c:	mov    %r11d,0x10(%rsi,%r8,4)
 107ad31:	mov    (%r14),%r11
 107ad34:	mov    0x750(%r11,%r10,1),%r11d
 107ad3c:	mov    %r11d,0x14(%rsi,%r8,4)
 107ad41:	mov    (%r14),%r11
 107ad44:	mov    0x8a0(%r11,%r10,1),%r11d
 107ad4c:	mov    %r11d,0x18(%rsi,%r8,4)
 107ad51:	mov    (%r14),%r11
 107ad54:	mov    0x9f0(%r11,%r10,1),%r11d
 107ad5c:	add    $0xa80,%r10
 107ad63:	mov    %r11d,0x1c(%rsi,%r8,4)
 107ad68:	add    $0x8,%r8
 107ad6c:	cmp    %r10,%r9
 107ad6f:	jne    107ace2 <check_input_run+0xdfd2>
 107ad75:	test   %rdi,%rdi
 107ad78:	je     107adae <check_input_run+0xe09e>
 107ad7a:	lea    (%rsi,%r8,4),%r9
 107ad7e:	imul   $0x150,%r8,%r8
 107ad85:	xor    %r10d,%r10d
 107ad88:	mov    0x1b0(%rsp),%r11
 107ad90:	mov    (%r11),%r11
 107ad93:	mov    0xc0(%r11,%r8,1),%r11d
 107ad9b:	add    $0x150,%r8
 107ada2:	mov    %r11d,(%r9,%r10,4)
 107ada6:	inc    %r10
 107ada9:	cmp    %r10,%rdi
 107adac:	jne    107ad88 <check_input_run+0xe078>
 107adae:	mov    0xa0(%rsp),%r10
 107adb6:	lea    0x1(%r10),%r8d
 107adba:	cmp    $0x1,%r8d
 107adbe:	adc    $0x1,%r10d
 107adc2:	mov    %r10d,%edi
 107adc5:	and    $0x3,%edi
 107adc8:	cmp    $0x4,%r8d
 107adcc:	jae    107ade5 <check_input_run+0xe0d5>
 107adce:	xor    %r8d,%r8d
 107add1:	xor    %r9d,%r9d
 107add4:	movq   $0x0,0xe0(%rsp)
 107ade0:	jmp    107b048 <check_input_run+0xe338>
 107ade5:	and    $0xfffffffc,%r10d
 107ade9:	xor    %r8d,%r8d
 107adec:	xor    %r9d,%r9d
 107adef:	movq   $0x0,0xe0(%rsp)
 107adfb:	jmp    107ae0a <check_input_run+0xe0fa>
 107adfd:	add    $0x4,%r8
 107ae01:	cmp    %r10,%r8
 107ae04:	je     107b03f <check_input_run+0xe32f>
 107ae0a:	mov    0x28(%rsp),%rcx
 107ae0f:	cmp    (%rcx),%r9d
 107ae12:	jae    107ae70 <check_input_run+0xe160>
 107ae14:	mov    %r9d,%r9d
 107ae17:	lea    (%r9,%r9,2),%r11
 107ae1b:	lea    0x7(,%r11,4),%r11
 107ae23:	mov    0x860(%rsp),%r14
 107ae2b:	mov    0x1d0(%r14),%r14
 107ae32:	cmp    %r8d,(%r14,%r11,4)
 107ae36:	ja     107ae70 <check_input_run+0xe160>
 107ae38:	mov    0xe0(%rsp),%rdx
 107ae40:	mov    0xb0(%rsp),%rcx
 107ae48:	add    $0xc,%r11
 107ae4c:	lea    (%rdx,%r8,1),%ebp
 107ae50:	mov    %ebp,(%rcx,%r9,4)
 107ae54:	add    (%rsi,%r9,4),%edx
 107ae58:	inc    %r9
 107ae5b:	mov    %rdx,0xe0(%rsp)
 107ae63:	mov    0x28(%rsp),%rdx
 107ae68:	mov    (%rdx),%r14d
 107ae6b:	cmp    %r14,%r9
 107ae6e:	jb     107ae23 <check_input_run+0xe113>
 107ae70:	cmp    0xa0(%rsp),%r8
 107ae78:	jae    107ae92 <check_input_run+0xe182>
 107ae7a:	mov    0xe0(%rsp),%rcx
 107ae82:	mov    0x110(%rsp),%r14
 107ae8a:	lea    (%rcx,%r8,1),%r11d
 107ae8e:	mov    %r11d,(%r14,%r8,4)
 107ae92:	mov    0x28(%rsp),%rcx
 107ae97:	lea    0x1(%r8),%r11
 107ae9b:	cmp    (%rcx),%r9d
 107ae9e:	jae    107aefc <check_input_run+0xe1ec>
 107aea0:	mov    %r9d,%r9d
 107aea3:	lea    (%r9,%r9,2),%r14
 107aea7:	lea    0x7(,%r14,4),%r14
 107aeaf:	mov    0x860(%rsp),%r15
 107aeb7:	mov    0x1d0(%r15),%r15
 107aebe:	cmp    %r11d,(%r15,%r14,4)
 107aec2:	ja     107aefc <check_input_run+0xe1ec>
 107aec4:	mov    0xe0(%rsp),%rdx
 107aecc:	mov    0xb0(%rsp),%rcx
 107aed4:	add    $0xc,%r14
 107aed8:	lea    (%rdx,%r11,1),%ebp
 107aedc:	mov    %ebp,(%rcx,%r9,4)
 107aee0:	add    (%rsi,%r9,4),%edx
 107aee4:	inc    %r9
 107aee7:	mov    %rdx,0xe0(%rsp)
 107aeef:	mov    0x28(%rsp),%rdx
 107aef4:	mov    (%rdx),%r15d
 107aef7:	cmp    %r15,%r9
 107aefa:	jb     107aeaf <check_input_run+0xe19f>
 107aefc:	cmp    0xa0(%rsp),%r11
 107af04:	jae    107af1e <check_input_run+0xe20e>
 107af06:	mov    0xe0(%rsp),%rcx
 107af0e:	mov    0x110(%rsp),%r14
 107af16:	lea    (%rcx,%r11,1),%ebp
 107af1a:	mov    %ebp,(%r14,%r11,4)
 107af1e:	mov    0x28(%rsp),%rcx
 107af23:	lea    0x2(%r8),%r11
 107af27:	cmp    (%rcx),%r9d
 107af2a:	jae    107af88 <check_input_run+0xe278>
 107af2c:	mov    %r9d,%r9d
 107af2f:	lea    (%r9,%r9,2),%r14
 107af33:	lea    0x7(,%r14,4),%r14
 107af3b:	mov    0x860(%rsp),%r15
 107af43:	mov    0x1d0(%r15),%r15
 107af4a:	cmp    %r11d,(%r15,%r14,4)
 107af4e:	ja     107af88 <check_input_run+0xe278>
 107af50:	mov    0xe0(%rsp),%rdx
 107af58:	mov    0xb0(%rsp),%rcx
 107af60:	add    $0xc,%r14
 107af64:	lea    (%rdx,%r11,1),%ebp
 107af68:	mov    %ebp,(%rcx,%r9,4)
 107af6c:	add    (%rsi,%r9,4),%edx
 107af70:	inc    %r9
 107af73:	mov    %rdx,0xe0(%rsp)
 107af7b:	mov    0x28(%rsp),%rdx
 107af80:	mov    (%rdx),%r15d
 107af83:	cmp    %r15,%r9
 107af86:	jb     107af3b <check_input_run+0xe22b>
 107af88:	cmp    0xa0(%rsp),%r11
 107af90:	jae    107afaa <check_input_run+0xe29a>
 107af92:	mov    0xe0(%rsp),%rcx
 107af9a:	mov    0x110(%rsp),%r14
 107afa2:	lea    (%rcx,%r11,1),%ebp
 107afa6:	mov    %ebp,(%r14,%r11,4)
 107afaa:	mov    0x28(%rsp),%rcx
 107afaf:	lea    0x3(%r8),%r11
 107afb3:	cmp    (%rcx),%r9d
 107afb6:	jae    107b014 <check_input_run+0xe304>
 107afb8:	mov    %r9d,%r9d
 107afbb:	lea    (%r9,%r9,2),%r14
 107afbf:	lea    0x7(,%r14,4),%r14
 107afc7:	mov    0x860(%rsp),%r15
 107afcf:	mov    0x1d0(%r15),%r15
 107afd6:	cmp    %r11d,(%r15,%r14,4)
 107afda:	ja     107b014 <check_input_run+0xe304>
 107afdc:	mov    0xe0(%rsp),%rdx
 107afe4:	mov    0xb0(%rsp),%rcx
 107afec:	add    $0xc,%r14
 107aff0:	lea    (%rdx,%r11,1),%ebp
 107aff4:	mov    %ebp,(%rcx,%r9,4)
 107aff8:	add    (%rsi,%r9,4),%edx
 107affc:	inc    %r9
 107afff:	mov    %rdx,0xe0(%rsp)
 107b007:	mov    0x28(%rsp),%rdx
 107b00c:	mov    (%rdx),%r15d
 107b00f:	cmp    %r15,%r9
 107b012:	jb     107afc7 <check_input_run+0xe2b7>
 107b014:	cmp    0xa0(%rsp),%r11
 107b01c:	jae    107adfd <check_input_run+0xe0ed>
 107b022:	mov    0xe0(%rsp),%rcx
 107b02a:	mov    0x110(%rsp),%r14
 107b032:	lea    (%rcx,%r11,1),%ebp
 107b036:	mov    %ebp,(%r14,%r11,4)
 107b03a:	jmp    107adfd <check_input_run+0xe0ed>
 107b03f:	test   %rdi,%rdi
 107b042:	je     107b0e9 <check_input_run+0xe3d9>
 107b048:	xor    %r10d,%r10d
 107b04b:	jmp    107b05c <check_input_run+0xe34c>
 107b04d:	inc    %r8
 107b050:	inc    %r10
 107b053:	cmp    %rdi,%r10
 107b056:	je     107b0e9 <check_input_run+0xe3d9>
 107b05c:	mov    0x28(%rsp),%rcx
 107b061:	cmp    (%rcx),%r9d
 107b064:	jae    107b0c2 <check_input_run+0xe3b2>
 107b066:	mov    %r9d,%r9d
 107b069:	lea    (%r9,%r9,2),%r11
 107b06d:	lea    0x7(,%r11,4),%r11
 107b075:	mov    0x860(%rsp),%r14
 107b07d:	mov    0x1d0(%r14),%r14
 107b084:	cmp    %r8d,(%r14,%r11,4)
 107b088:	ja     107b0c2 <check_input_run+0xe3b2>
 107b08a:	mov    0xe0(%rsp),%rdx
 107b092:	mov    0xb0(%rsp),%rcx
 107b09a:	add    $0xc,%r11
 107b09e:	lea    (%rdx,%r8,1),%ebp
 107b0a2:	mov    %ebp,(%rcx,%r9,4)
 107b0a6:	add    (%rsi,%r9,4),%edx
 107b0aa:	inc    %r9
 107b0ad:	mov    %rdx,0xe0(%rsp)
 107b0b5:	mov    0x28(%rsp),%rdx
 107b0ba:	mov    (%rdx),%r14d
 107b0bd:	cmp    %r14,%r9
 107b0c0:	jb     107b075 <check_input_run+0xe365>
 107b0c2:	cmp    0xa0(%rsp),%r8
 107b0ca:	jae    107b04d <check_input_run+0xe33d>
 107b0cc:	mov    0xe0(%rsp),%rcx
 107b0d4:	mov    0x110(%rsp),%r14
 107b0dc:	lea    (%rcx,%r8,1),%r11d
 107b0e0:	mov    %r11d,(%r14,%r8,4)
 107b0e4:	jmp    107b04d <check_input_run+0xe33d>
 107b0e9:	cmpl   $0x0,0x60(%rsp)
 107b0ee:	je     107b1f7 <check_input_run+0xe4e7>
 107b0f4:	mov    0x60(%rsp),%r8
 107b0f9:	mov    %r8d,%edi
 107b0fc:	and    $0x7,%edi
 107b0ff:	cmp    $0x8,%r8d
 107b103:	jae    107b10d <check_input_run+0xe3fd>
 107b105:	xor    %r8d,%r8d
 107b108:	jmp    107b1c3 <check_input_run+0xe4b3>
 107b10d:	mov    0x1b0(%rsp),%r14
 107b115:	mov    0x60(%rsp),%r8
 107b11a:	shr    $0x3,%r8d
 107b11e:	xor    %r10d,%r10d
 107b121:	imul   $0xa80,%r8,%r9
 107b128:	xor    %r8d,%r8d
 107b12b:	mov    (%r14),%r11
 107b12e:	mov    0xd0(%r11,%r10,1),%r11d
 107b136:	mov    %r11d,(%rsi,%r8,4)
 107b13a:	mov    (%r14),%r11
 107b13d:	mov    0x220(%r11,%r10,1),%r11d
 107b145:	mov    %r11d,0x4(%rsi,%r8,4)
 107b14a:	mov    (%r14),%r11
 107b14d:	mov    0x370(%r11,%r10,1),%r11d
 107b155:	mov    %r11d,0x8(%rsi,%r8,4)
 107b15a:	mov    (%r14),%r11
 107b15d:	mov    0x4c0(%r11,%r10,1),%r11d
 107b165:	mov    %r11d,0xc(%rsi,%r8,4)
 107b16a:	mov    (%r14),%r11
 107b16d:	mov    0x610(%r11,%r10,1),%r11d
 107b175:	mov    %r11d,0x10(%rsi,%r8,4)
 107b17a:	mov    (%r14),%r11
 107b17d:	mov    0x760(%r11,%r10,1),%r11d
 107b185:	mov    %r11d,0x14(%rsi,%r8,4)
 107b18a:	mov    (%r14),%r11
 107b18d:	mov    0x8b0(%r11,%r10,1),%r11d
 107b195:	mov    %r11d,0x18(%rsi,%r8,4)
 107b19a:	mov    (%r14),%r11
 107b19d:	mov    0xa00(%r11,%r10,1),%r11d
 107b1a5:	add    $0xa80,%r10
 107b1ac:	mov    %r11d,0x1c(%rsi,%r8,4)
 107b1b1:	add    $0x8,%r8
 107b1b5:	cmp    %r10,%r9
 107b1b8:	jne    107b12b <check_input_run+0xe41b>
 107b1be:	test   %rdi,%rdi
 107b1c1:	je     107b1f7 <check_input_run+0xe4e7>
 107b1c3:	lea    (%rsi,%r8,4),%r9
 107b1c7:	imul   $0x150,%r8,%r8
 107b1ce:	xor    %r10d,%r10d
 107b1d1:	mov    0x1b0(%rsp),%r11
 107b1d9:	mov    (%r11),%r11
 107b1dc:	mov    0xd0(%r11,%r8,1),%r11d
 107b1e4:	add    $0x150,%r8
 107b1eb:	mov    %r11d,(%r9,%r10,4)
 107b1ef:	inc    %r10
 107b1f2:	cmp    %r10,%rdi
 107b1f5:	jne    107b1d1 <check_input_run+0xe4c1>
 107b1f7:	mov    0xd8(%rsp),%r10
 107b1ff:	lea    0x1(%r10),%r8d
 107b203:	cmp    $0x1,%r8d
 107b207:	adc    $0x1,%r10d
 107b20b:	mov    %r10d,%edi
 107b20e:	and    $0x3,%edi
 107b211:	cmp    $0x4,%r8d
 107b215:	jae    107b22e <check_input_run+0xe51e>
 107b217:	xor    %r8d,%r8d
 107b21a:	xor    %r9d,%r9d
 107b21d:	movq   $0x0,0x108(%rsp)
 107b229:	jmp    107b491 <check_input_run+0xe781>
 107b22e:	and    $0xfffffffc,%r10d
 107b232:	xor    %r8d,%r8d
 107b235:	xor    %r9d,%r9d
 107b238:	movq   $0x0,0x108(%rsp)
 107b244:	jmp    107b253 <check_input_run+0xe543>
 107b246:	add    $0x4,%r8
 107b24a:	cmp    %r10,%r8
 107b24d:	je     107b488 <check_input_run+0xe778>
 107b253:	mov    0x28(%rsp),%rcx
 107b258:	cmp    (%rcx),%r9d
 107b25b:	jae    107b2b9 <check_input_run+0xe5a9>
 107b25d:	mov    %r9d,%r9d
 107b260:	lea    (%r9,%r9,2),%r11
 107b264:	lea    0x8(,%r11,4),%r11
 107b26c:	mov    0x860(%rsp),%r14
 107b274:	mov    0x1d0(%r14),%r14
 107b27b:	cmp    %r8d,(%r14,%r11,4)
 107b27f:	ja     107b2b9 <check_input_run+0xe5a9>
 107b281:	mov    0x108(%rsp),%rdx
 107b289:	mov    0xf8(%rsp),%rcx
 107b291:	add    $0xc,%r11
 107b295:	lea    (%rdx,%r8,1),%ebp
 107b299:	mov    %ebp,(%rcx,%r9,4)
 107b29d:	add    (%rsi,%r9,4),%edx
 107b2a1:	inc    %r9
 107b2a4:	mov    %rdx,0x108(%rsp)
 107b2ac:	mov    0x28(%rsp),%rdx
 107b2b1:	mov    (%rdx),%r14d
 107b2b4:	cmp    %r14,%r9
 107b2b7:	jb     107b26c <check_input_run+0xe55c>
 107b2b9:	cmp    0xd8(%rsp),%r8
 107b2c1:	jae    107b2db <check_input_run+0xe5cb>
 107b2c3:	mov    0x108(%rsp),%rcx
 107b2cb:	mov    0x88(%rsp),%rdx
 107b2d3:	lea    (%rcx,%r8,1),%r11d
 107b2d7:	mov    %r11d,(%rdx,%r8,4)
 107b2db:	mov    0x28(%rsp),%rcx
 107b2e0:	lea    0x1(%r8),%r11
 107b2e4:	cmp    (%rcx),%r9d
 107b2e7:	jae    107b345 <check_input_run+0xe635>
 107b2e9:	mov    %r9d,%r9d
 107b2ec:	lea    (%r9,%r9,2),%r14
 107b2f0:	lea    0x8(,%r14,4),%r14
 107b2f8:	mov    0x860(%rsp),%r15
 107b300:	mov    0x1d0(%r15),%r15
 107b307:	cmp    %r11d,(%r15,%r14,4)
 107b30b:	ja     107b345 <check_input_run+0xe635>
 107b30d:	mov    0x108(%rsp),%rdx
 107b315:	mov    0xf8(%rsp),%rcx
 107b31d:	add    $0xc,%r14
 107b321:	lea    (%rdx,%r11,1),%ebp
 107b325:	mov    %ebp,(%rcx,%r9,4)
 107b329:	add    (%rsi,%r9,4),%edx
 107b32d:	inc    %r9
 107b330:	mov    %rdx,0x108(%rsp)
 107b338:	mov    0x28(%rsp),%rdx
 107b33d:	mov    (%rdx),%r15d
 107b340:	cmp    %r15,%r9
 107b343:	jb     107b2f8 <check_input_run+0xe5e8>
 107b345:	cmp    0xd8(%rsp),%r11
 107b34d:	jae    107b367 <check_input_run+0xe657>
 107b34f:	mov    0x108(%rsp),%rcx
 107b357:	mov    0x88(%rsp),%rdx
 107b35f:	lea    (%rcx,%r11,1),%ebp
 107b363:	mov    %ebp,(%rdx,%r11,4)
 107b367:	mov    0x28(%rsp),%rcx
 107b36c:	lea    0x2(%r8),%r11
 107b370:	cmp    (%rcx),%r9d
 107b373:	jae    107b3d1 <check_input_run+0xe6c1>
 107b375:	mov    %r9d,%r9d
 107b378:	lea    (%r9,%r9,2),%r14
 107b37c:	lea    0x8(,%r14,4),%r14
 107b384:	mov    0x860(%rsp),%r15
 107b38c:	mov    0x1d0(%r15),%r15
 107b393:	cmp    %r11d,(%r15,%r14,4)
 107b397:	ja     107b3d1 <check_input_run+0xe6c1>
 107b399:	mov    0x108(%rsp),%rdx
 107b3a1:	mov    0xf8(%rsp),%rcx
 107b3a9:	add    $0xc,%r14
 107b3ad:	lea    (%rdx,%r11,1),%ebp
 107b3b1:	mov    %ebp,(%rcx,%r9,4)
 107b3b5:	add    (%rsi,%r9,4),%edx
 107b3b9:	inc    %r9
 107b3bc:	mov    %rdx,0x108(%rsp)
 107b3c4:	mov    0x28(%rsp),%rdx
 107b3c9:	mov    (%rdx),%r15d
 107b3cc:	cmp    %r15,%r9
 107b3cf:	jb     107b384 <check_input_run+0xe674>
 107b3d1:	cmp    0xd8(%rsp),%r11
 107b3d9:	jae    107b3f3 <check_input_run+0xe6e3>
 107b3db:	mov    0x108(%rsp),%rcx
 107b3e3:	mov    0x88(%rsp),%rdx
 107b3eb:	lea    (%rcx,%r11,1),%ebp
 107b3ef:	mov    %ebp,(%rdx,%r11,4)
 107b3f3:	mov    0x28(%rsp),%rcx
 107b3f8:	lea    0x3(%r8),%r11
 107b3fc:	cmp    (%rcx),%r9d
 107b3ff:	jae    107b45d <check_input_run+0xe74d>
 107b401:	mov    %r9d,%r9d
 107b404:	lea    (%r9,%r9,2),%r14
 107b408:	lea    0x8(,%r14,4),%r14
 107b410:	mov    0x860(%rsp),%r15
 107b418:	mov    0x1d0(%r15),%r15
 107b41f:	cmp    %r11d,(%r15,%r14,4)
 107b423:	ja     107b45d <check_input_run+0xe74d>
 107b425:	mov    0x108(%rsp),%rdx
 107b42d:	mov    0xf8(%rsp),%rcx
 107b435:	add    $0xc,%r14
 107b439:	lea    (%rdx,%r11,1),%ebp
 107b43d:	mov    %ebp,(%rcx,%r9,4)
 107b441:	add    (%rsi,%r9,4),%edx
 107b445:	inc    %r9
 107b448:	mov    %rdx,0x108(%rsp)
 107b450:	mov    0x28(%rsp),%rdx
 107b455:	mov    (%rdx),%r15d
 107b458:	cmp    %r15,%r9
 107b45b:	jb     107b410 <check_input_run+0xe700>
 107b45d:	cmp    0xd8(%rsp),%r11
 107b465:	jae    107b246 <check_input_run+0xe536>
 107b46b:	mov    0x108(%rsp),%rcx
 107b473:	mov    0x88(%rsp),%rdx
 107b47b:	lea    (%rcx,%r11,1),%ebp
 107b47f:	mov    %ebp,(%rdx,%r11,4)
 107b483:	jmp    107b246 <check_input_run+0xe536>
 107b488:	test   %rdi,%rdi
 107b48b:	je     107b532 <check_input_run+0xe822>
 107b491:	xor    %r10d,%r10d
 107b494:	jmp    107b4a5 <check_input_run+0xe795>
 107b496:	inc    %r8
 107b499:	inc    %r10
 107b49c:	cmp    %rdi,%r10
 107b49f:	je     107b532 <check_input_run+0xe822>
 107b4a5:	mov    0x28(%rsp),%rcx
 107b4aa:	cmp    (%rcx),%r9d
 107b4ad:	jae    107b50b <check_input_run+0xe7fb>
 107b4af:	mov    %r9d,%r9d
 107b4b2:	lea    (%r9,%r9,2),%r11
 107b4b6:	lea    0x8(,%r11,4),%r11
 107b4be:	mov    0x860(%rsp),%r14
 107b4c6:	mov    0x1d0(%r14),%r14
 107b4cd:	cmp    %r8d,(%r14,%r11,4)
 107b4d1:	ja     107b50b <check_input_run+0xe7fb>
 107b4d3:	mov    0x108(%rsp),%rdx
 107b4db:	mov    0xf8(%rsp),%rcx
 107b4e3:	add    $0xc,%r11
 107b4e7:	lea    (%rdx,%r8,1),%ebp
 107b4eb:	mov    %ebp,(%rcx,%r9,4)
 107b4ef:	add    (%rsi,%r9,4),%edx
 107b4f3:	inc    %r9
 107b4f6:	mov    %rdx,0x108(%rsp)
 107b4fe:	mov    0x28(%rsp),%rdx
 107b503:	mov    (%rdx),%r14d
 107b506:	cmp    %r14,%r9
 107b509:	jb     107b4be <check_input_run+0xe7ae>
 107b50b:	cmp    0xd8(%rsp),%r8
 107b513:	jae    107b496 <check_input_run+0xe786>
 107b515:	mov    0x108(%rsp),%rcx
 107b51d:	mov    0x88(%rsp),%rdx
 107b525:	lea    (%rcx,%r8,1),%r11d
 107b529:	mov    %r11d,(%rdx,%r8,4)
 107b52d:	jmp    107b496 <check_input_run+0xe786>
 107b532:	cmpl   $0x0,0x60(%rsp)
 107b537:	je     107b640 <check_input_run+0xe930>
 107b53d:	mov    0x60(%rsp),%r8
 107b542:	mov    %r8d,%edi
 107b545:	and    $0x7,%edi
 107b548:	cmp    $0x8,%r8d
 107b54c:	jae    107b556 <check_input_run+0xe846>
 107b54e:	xor    %r8d,%r8d
 107b551:	jmp    107b60c <check_input_run+0xe8fc>
 107b556:	mov    0x1b0(%rsp),%r14
 107b55e:	mov    0x60(%rsp),%r8
 107b563:	shr    $0x3,%r8d
 107b567:	xor    %r10d,%r10d
 107b56a:	imul   $0xa80,%r8,%r9
 107b571:	xor    %r8d,%r8d
 107b574:	mov    (%r14),%r11
 107b577:	mov    0xf8(%r11,%r10,1),%r11d
 107b57f:	mov    %r11d,(%rsi,%r8,4)
 107b583:	mov    (%r14),%r11
 107b586:	mov    0x248(%r11,%r10,1),%r11d
 107b58e:	mov    %r11d,0x4(%rsi,%r8,4)
 107b593:	mov    (%r14),%r11
 107b596:	mov    0x398(%r11,%r10,1),%r11d
 107b59e:	mov    %r11d,0x8(%rsi,%r8,4)
 107b5a3:	mov    (%r14),%r11
 107b5a6:	mov    0x4e8(%r11,%r10,1),%r11d
 107b5ae:	mov    %r11d,0xc(%rsi,%r8,4)
 107b5b3:	mov    (%r14),%r11
 107b5b6:	mov    0x638(%r11,%r10,1),%r11d
 107b5be:	mov    %r11d,0x10(%rsi,%r8,4)
 107b5c3:	mov    (%r14),%r11
 107b5c6:	mov    0x788(%r11,%r10,1),%r11d
 107b5ce:	mov    %r11d,0x14(%rsi,%r8,4)
 107b5d3:	mov    (%r14),%r11
 107b5d6:	mov    0x8d8(%r11,%r10,1),%r11d
 107b5de:	mov    %r11d,0x18(%rsi,%r8,4)
 107b5e3:	mov    (%r14),%r11
 107b5e6:	mov    0xa28(%r11,%r10,1),%r11d
 107b5ee:	add    $0xa80,%r10
 107b5f5:	mov    %r11d,0x1c(%rsi,%r8,4)
 107b5fa:	add    $0x8,%r8
 107b5fe:	cmp    %r10,%r9
 107b601:	jne    107b574 <check_input_run+0xe864>
 107b607:	test   %rdi,%rdi
 107b60a:	je     107b640 <check_input_run+0xe930>
 107b60c:	lea    (%rsi,%r8,4),%r9
 107b610:	imul   $0x150,%r8,%r8
 107b617:	xor    %r10d,%r10d
 107b61a:	mov    0x1b0(%rsp),%r11
 107b622:	mov    (%r11),%r11
 107b625:	mov    0xf8(%r11,%r8,1),%r11d
 107b62d:	add    $0x150,%r8
 107b634:	mov    %r11d,(%r9,%r10,4)
 107b638:	inc    %r10
 107b63b:	cmp    %r10,%rdi
 107b63e:	jne    107b61a <check_input_run+0xe90a>
 107b640:	mov    0x70(%rsp),%r10
 107b645:	lea    0x1(%r10),%r8d
 107b649:	cmp    $0x1,%r8d
 107b64d:	adc    $0x1,%r10d
 107b651:	mov    %r10d,%edi
 107b654:	and    $0x3,%edi
 107b657:	cmp    $0x4,%r8d
 107b65b:	jae    107b674 <check_input_run+0xe964>
 107b65d:	xor    %r8d,%r8d
 107b660:	xor    %r9d,%r9d
 107b663:	movq   $0x0,0x128(%rsp)
 107b66f:	jmp    107b8cb <check_input_run+0xebbb>
 107b674:	and    $0xfffffffc,%r10d
 107b678:	xor    %r8d,%r8d
 107b67b:	xor    %r9d,%r9d
 107b67e:	movq   $0x0,0x128(%rsp)
 107b68a:	jmp    107b699 <check_input_run+0xe989>
 107b68c:	add    $0x4,%r8
 107b690:	cmp    %r10,%r8
 107b693:	je     107b8c2 <check_input_run+0xebb2>
 107b699:	mov    0x28(%rsp),%rcx
 107b69e:	cmp    (%rcx),%r9d
 107b6a1:	jae    107b6ff <check_input_run+0xe9ef>
 107b6a3:	mov    %r9d,%r9d
 107b6a6:	lea    (%r9,%r9,2),%r11
 107b6aa:	lea    0x9(,%r11,4),%r11
 107b6b2:	mov    0x860(%rsp),%r14
 107b6ba:	mov    0x1d0(%r14),%r14
 107b6c1:	cmp    %r8d,(%r14,%r11,4)
 107b6c5:	ja     107b6ff <check_input_run+0xe9ef>
 107b6c7:	mov    0x128(%rsp),%rdx
 107b6cf:	mov    0x1a0(%rsp),%rcx
 107b6d7:	add    $0xc,%r11
 107b6db:	lea    (%rdx,%r8,1),%ebp
 107b6df:	mov    %ebp,(%rcx,%r9,4)
 107b6e3:	add    (%rsi,%r9,4),%edx
 107b6e7:	inc    %r9
 107b6ea:	mov    %rdx,0x128(%rsp)
 107b6f2:	mov    0x28(%rsp),%rdx
 107b6f7:	mov    (%rdx),%r14d
 107b6fa:	cmp    %r14,%r9
 107b6fd:	jb     107b6b2 <check_input_run+0xe9a2>
 107b6ff:	cmp    0x70(%rsp),%r8
 107b704:	jae    107b71e <check_input_run+0xea0e>
 107b706:	mov    0x128(%rsp),%rcx
 107b70e:	mov    0x150(%rsp),%rdx
 107b716:	lea    (%rcx,%r8,1),%r11d
 107b71a:	mov    %r11d,(%rdx,%r8,4)
 107b71e:	mov    0x28(%rsp),%rcx
 107b723:	lea    0x1(%r8),%r11
 107b727:	cmp    (%rcx),%r9d
 107b72a:	jae    107b788 <check_input_run+0xea78>
 107b72c:	mov    %r9d,%r9d
 107b72f:	lea    (%r9,%r9,2),%r14
 107b733:	lea    0x9(,%r14,4),%r14
 107b73b:	mov    0x860(%rsp),%r15
 107b743:	mov    0x1d0(%r15),%r15
 107b74a:	cmp    %r11d,(%r15,%r14,4)
 107b74e:	ja     107b788 <check_input_run+0xea78>
 107b750:	mov    0x128(%rsp),%rdx
 107b758:	mov    0x1a0(%rsp),%rcx
 107b760:	add    $0xc,%r14
 107b764:	lea    (%rdx,%r11,1),%ebp
 107b768:	mov    %ebp,(%rcx,%r9,4)
 107b76c:	add    (%rsi,%r9,4),%edx
 107b770:	inc    %r9
 107b773:	mov    %rdx,0x128(%rsp)
 107b77b:	mov    0x28(%rsp),%rdx
 107b780:	mov    (%rdx),%r15d
 107b783:	cmp    %r15,%r9
 107b786:	jb     107b73b <check_input_run+0xea2b>
 107b788:	cmp    0x70(%rsp),%r11
 107b78d:	jae    107b7a7 <check_input_run+0xea97>
 107b78f:	mov    0x128(%rsp),%rcx
 107b797:	mov    0x150(%rsp),%rdx
 107b79f:	lea    (%rcx,%r11,1),%ebp
 107b7a3:	mov    %ebp,(%rdx,%r11,4)
 107b7a7:	mov    0x28(%rsp),%rcx
 107b7ac:	lea    0x2(%r8),%r11
 107b7b0:	cmp    (%rcx),%r9d
 107b7b3:	jae    107b811 <check_input_run+0xeb01>
 107b7b5:	mov    %r9d,%r9d
 107b7b8:	lea    (%r9,%r9,2),%r14
 107b7bc:	lea    0x9(,%r14,4),%r14
 107b7c4:	mov    0x860(%rsp),%r15
 107b7cc:	mov    0x1d0(%r15),%r15
 107b7d3:	cmp    %r11d,(%r15,%r14,4)
 107b7d7:	ja     107b811 <check_input_run+0xeb01>
 107b7d9:	mov    0x128(%rsp),%rdx
 107b7e1:	mov    0x1a0(%rsp),%rcx
 107b7e9:	add    $0xc,%r14
 107b7ed:	lea    (%rdx,%r11,1),%ebp
 107b7f1:	mov    %ebp,(%rcx,%r9,4)
 107b7f5:	add    (%rsi,%r9,4),%edx
 107b7f9:	inc    %r9
 107b7fc:	mov    %rdx,0x128(%rsp)
 107b804:	mov    0x28(%rsp),%rdx
 107b809:	mov    (%rdx),%r15d
 107b80c:	cmp    %r15,%r9
 107b80f:	jb     107b7c4 <check_input_run+0xeab4>
 107b811:	cmp    0x70(%rsp),%r11
 107b816:	jae    107b830 <check_input_run+0xeb20>
 107b818:	mov    0x128(%rsp),%rcx
 107b820:	mov    0x150(%rsp),%rdx
 107b828:	lea    (%rcx,%r11,1),%ebp
 107b82c:	mov    %ebp,(%rdx,%r11,4)
 107b830:	mov    0x28(%rsp),%rcx
 107b835:	lea    0x3(%r8),%r11
 107b839:	cmp    (%rcx),%r9d
 107b83c:	jae    107b89a <check_input_run+0xeb8a>
 107b83e:	mov    %r9d,%r9d
 107b841:	lea    (%r9,%r9,2),%r14
 107b845:	lea    0x9(,%r14,4),%r14
 107b84d:	mov    0x860(%rsp),%r15
 107b855:	mov    0x1d0(%r15),%r15
 107b85c:	cmp    %r11d,(%r15,%r14,4)
 107b860:	ja     107b89a <check_input_run+0xeb8a>
 107b862:	mov    0x128(%rsp),%rdx
 107b86a:	mov    0x1a0(%rsp),%rcx
 107b872:	add    $0xc,%r14
 107b876:	lea    (%rdx,%r11,1),%ebp
 107b87a:	mov    %ebp,(%rcx,%r9,4)
 107b87e:	add    (%rsi,%r9,4),%edx
 107b882:	inc    %r9
 107b885:	mov    %rdx,0x128(%rsp)
 107b88d:	mov    0x28(%rsp),%rdx
 107b892:	mov    (%rdx),%r15d
 107b895:	cmp    %r15,%r9
 107b898:	jb     107b84d <check_input_run+0xeb3d>
 107b89a:	cmp    0x70(%rsp),%r11
 107b89f:	jae    107b68c <check_input_run+0xe97c>
 107b8a5:	mov    0x128(%rsp),%rcx
 107b8ad:	mov    0x150(%rsp),%rdx
 107b8b5:	lea    (%rcx,%r11,1),%ebp
 107b8b9:	mov    %ebp,(%rdx,%r11,4)
 107b8bd:	jmp    107b68c <check_input_run+0xe97c>
 107b8c2:	test   %rdi,%rdi
 107b8c5:	je     107b969 <check_input_run+0xec59>
 107b8cb:	xor    %r10d,%r10d
 107b8ce:	jmp    107b8df <check_input_run+0xebcf>
 107b8d0:	inc    %r8
 107b8d3:	inc    %r10
 107b8d6:	cmp    %rdi,%r10
 107b8d9:	je     107b969 <check_input_run+0xec59>
 107b8df:	mov    0x28(%rsp),%rcx
 107b8e4:	cmp    (%rcx),%r9d
 107b8e7:	jae    107b945 <check_input_run+0xec35>
 107b8e9:	mov    %r9d,%r9d
 107b8ec:	lea    (%r9,%r9,2),%r11
 107b8f0:	lea    0x9(,%r11,4),%r11
 107b8f8:	mov    0x860(%rsp),%r14
 107b900:	mov    0x1d0(%r14),%r14
 107b907:	cmp    %r8d,(%r14,%r11,4)
 107b90b:	ja     107b945 <check_input_run+0xec35>
 107b90d:	mov    0x128(%rsp),%rdx
 107b915:	mov    0x1a0(%rsp),%rcx
 107b91d:	add    $0xc,%r11
 107b921:	lea    (%rdx,%r8,1),%ebp
 107b925:	mov    %ebp,(%rcx,%r9,4)
 107b929:	add    (%rsi,%r9,4),%edx
 107b92d:	inc    %r9
 107b930:	mov    %rdx,0x128(%rsp)
 107b938:	mov    0x28(%rsp),%rdx
 107b93d:	mov    (%rdx),%r14d
 107b940:	cmp    %r14,%r9
 107b943:	jb     107b8f8 <check_input_run+0xebe8>
 107b945:	cmp    0x70(%rsp),%r8
 107b94a:	jae    107b8d0 <check_input_run+0xebc0>
 107b94c:	mov    0x128(%rsp),%rcx
 107b954:	mov    0x150(%rsp),%rdx
 107b95c:	lea    (%rcx,%r8,1),%r11d
 107b960:	mov    %r11d,(%rdx,%r8,4)
 107b964:	jmp    107b8d0 <check_input_run+0xebc0>
 107b969:	cmpl   $0x0,0x60(%rsp)
 107b96e:	je     107ba77 <check_input_run+0xed67>
 107b974:	mov    0x60(%rsp),%r8
 107b979:	mov    %r8d,%edi
 107b97c:	and    $0x7,%edi
 107b97f:	cmp    $0x8,%r8d
 107b983:	jae    107b98d <check_input_run+0xec7d>
 107b985:	xor    %r8d,%r8d
 107b988:	jmp    107ba43 <check_input_run+0xed33>
 107b98d:	mov    0x1b0(%rsp),%r14
 107b995:	mov    0x60(%rsp),%r8
 107b99a:	shr    $0x3,%r8d
 107b99e:	xor    %r10d,%r10d
 107b9a1:	imul   $0xa80,%r8,%r9
 107b9a8:	xor    %r8d,%r8d
 107b9ab:	mov    (%r14),%r11
 107b9ae:	mov    0x108(%r11,%r10,1),%r11d
 107b9b6:	mov    %r11d,(%rsi,%r8,4)
 107b9ba:	mov    (%r14),%r11
 107b9bd:	mov    0x258(%r11,%r10,1),%r11d
 107b9c5:	mov    %r11d,0x4(%rsi,%r8,4)
 107b9ca:	mov    (%r14),%r11
 107b9cd:	mov    0x3a8(%r11,%r10,1),%r11d
 107b9d5:	mov    %r11d,0x8(%rsi,%r8,4)
 107b9da:	mov    (%r14),%r11
 107b9dd:	mov    0x4f8(%r11,%r10,1),%r11d
 107b9e5:	mov    %r11d,0xc(%rsi,%r8,4)
 107b9ea:	mov    (%r14),%r11
 107b9ed:	mov    0x648(%r11,%r10,1),%r11d
 107b9f5:	mov    %r11d,0x10(%rsi,%r8,4)
 107b9fa:	mov    (%r14),%r11
 107b9fd:	mov    0x798(%r11,%r10,1),%r11d
 107ba05:	mov    %r11d,0x14(%rsi,%r8,4)
 107ba0a:	mov    (%r14),%r11
 107ba0d:	mov    0x8e8(%r11,%r10,1),%r11d
 107ba15:	mov    %r11d,0x18(%rsi,%r8,4)
 107ba1a:	mov    (%r14),%r11
 107ba1d:	mov    0xa38(%r11,%r10,1),%r11d
 107ba25:	add    $0xa80,%r10
 107ba2c:	mov    %r11d,0x1c(%rsi,%r8,4)
 107ba31:	add    $0x8,%r8
 107ba35:	cmp    %r10,%r9
 107ba38:	jne    107b9ab <check_input_run+0xec9b>
 107ba3e:	test   %rdi,%rdi
 107ba41:	je     107ba77 <check_input_run+0xed67>
 107ba43:	lea    (%rsi,%r8,4),%r9
 107ba47:	imul   $0x150,%r8,%r8
 107ba4e:	xor    %r10d,%r10d
 107ba51:	mov    0x1b0(%rsp),%r11
 107ba59:	mov    (%r11),%r11
 107ba5c:	mov    0x108(%r11,%r8,1),%r11d
 107ba64:	add    $0x150,%r8
 107ba6b:	mov    %r11d,(%r9,%r10,4)
 107ba6f:	inc    %r10
 107ba72:	cmp    %r10,%rdi
 107ba75:	jne    107ba51 <check_input_run+0xed41>
 107ba77:	mov    0xc8(%rsp),%r10
 107ba7f:	lea    0x1(%r10),%r8d
 107ba83:	cmp    $0x1,%r8d
 107ba87:	adc    $0x1,%r10d
 107ba8b:	mov    %r10d,%edi
 107ba8e:	and    $0x3,%edi
 107ba91:	cmp    $0x4,%r8d
 107ba95:	jae    107baae <check_input_run+0xed9e>
 107ba97:	xor    %r8d,%r8d
 107ba9a:	xor    %r9d,%r9d
 107ba9d:	movq   $0x0,0x120(%rsp)
 107baa9:	jmp    107bd11 <check_input_run+0xf001>
 107baae:	and    $0xfffffffc,%r10d
 107bab2:	xor    %r8d,%r8d
 107bab5:	xor    %r9d,%r9d
 107bab8:	movq   $0x0,0x120(%rsp)
 107bac4:	jmp    107bad3 <check_input_run+0xedc3>
 107bac6:	add    $0x4,%r8
 107baca:	cmp    %r10,%r8
 107bacd:	je     107bd08 <check_input_run+0xeff8>
 107bad3:	mov    0x28(%rsp),%rcx
 107bad8:	cmp    (%rcx),%r9d
 107badb:	jae    107bb39 <check_input_run+0xee29>
 107badd:	mov    %r9d,%r9d
 107bae0:	lea    (%r9,%r9,2),%r11
 107bae4:	lea    0xa(,%r11,4),%r11
 107baec:	mov    0x860(%rsp),%r14
 107baf4:	mov    0x1d0(%r14),%r14
 107bafb:	cmp    %r8d,(%r14,%r11,4)
 107baff:	ja     107bb39 <check_input_run+0xee29>
 107bb01:	mov    0x120(%rsp),%rdx
 107bb09:	mov    0x198(%rsp),%rcx
 107bb11:	add    $0xc,%r11
 107bb15:	lea    (%rdx,%r8,1),%ebp
 107bb19:	mov    %ebp,(%rcx,%r9,4)
 107bb1d:	add    (%rsi,%r9,4),%edx
 107bb21:	inc    %r9
 107bb24:	mov    %rdx,0x120(%rsp)
 107bb2c:	mov    0x28(%rsp),%rdx
 107bb31:	mov    (%rdx),%r14d
 107bb34:	cmp    %r14,%r9
 107bb37:	jb     107baec <check_input_run+0xeddc>
 107bb39:	cmp    0xc8(%rsp),%r8
 107bb41:	jae    107bb5b <check_input_run+0xee4b>
 107bb43:	mov    0x120(%rsp),%rcx
 107bb4b:	mov    0x118(%rsp),%rdx
 107bb53:	lea    (%rcx,%r8,1),%r11d
 107bb57:	mov    %r11d,(%rdx,%r8,4)
 107bb5b:	mov    0x28(%rsp),%rcx
 107bb60:	lea    0x1(%r8),%r11
 107bb64:	cmp    (%rcx),%r9d
 107bb67:	jae    107bbc5 <check_input_run+0xeeb5>
 107bb69:	mov    %r9d,%r9d
 107bb6c:	lea    (%r9,%r9,2),%r14
 107bb70:	lea    0xa(,%r14,4),%r14
 107bb78:	mov    0x860(%rsp),%r15
 107bb80:	mov    0x1d0(%r15),%r15
 107bb87:	cmp    %r11d,(%r15,%r14,4)
 107bb8b:	ja     107bbc5 <check_input_run+0xeeb5>
 107bb8d:	mov    0x120(%rsp),%rdx
 107bb95:	mov    0x198(%rsp),%rcx
 107bb9d:	add    $0xc,%r14
 107bba1:	lea    (%rdx,%r11,1),%ebp
 107bba5:	mov    %ebp,(%rcx,%r9,4)
 107bba9:	add    (%rsi,%r9,4),%edx
 107bbad:	inc    %r9
 107bbb0:	mov    %rdx,0x120(%rsp)
 107bbb8:	mov    0x28(%rsp),%rdx
 107bbbd:	mov    (%rdx),%r15d
 107bbc0:	cmp    %r15,%r9
 107bbc3:	jb     107bb78 <check_input_run+0xee68>
 107bbc5:	cmp    0xc8(%rsp),%r11
 107bbcd:	jae    107bbe7 <check_input_run+0xeed7>
 107bbcf:	mov    0x120(%rsp),%rcx
 107bbd7:	mov    0x118(%rsp),%rdx
 107bbdf:	lea    (%rcx,%r11,1),%ebp
 107bbe3:	mov    %ebp,(%rdx,%r11,4)
 107bbe7:	mov    0x28(%rsp),%rcx
 107bbec:	lea    0x2(%r8),%r11
 107bbf0:	cmp    (%rcx),%r9d
 107bbf3:	jae    107bc51 <check_input_run+0xef41>
 107bbf5:	mov    %r9d,%r9d
 107bbf8:	lea    (%r9,%r9,2),%r14
 107bbfc:	lea    0xa(,%r14,4),%r14
 107bc04:	mov    0x860(%rsp),%r15
 107bc0c:	mov    0x1d0(%r15),%r15
 107bc13:	cmp    %r11d,(%r15,%r14,4)
 107bc17:	ja     107bc51 <check_input_run+0xef41>
 107bc19:	mov    0x120(%rsp),%rdx
 107bc21:	mov    0x198(%rsp),%rcx
 107bc29:	add    $0xc,%r14
 107bc2d:	lea    (%rdx,%r11,1),%ebp
 107bc31:	mov    %ebp,(%rcx,%r9,4)
 107bc35:	add    (%rsi,%r9,4),%edx
 107bc39:	inc    %r9
 107bc3c:	mov    %rdx,0x120(%rsp)
 107bc44:	mov    0x28(%rsp),%rdx
 107bc49:	mov    (%rdx),%r15d
 107bc4c:	cmp    %r15,%r9
 107bc4f:	jb     107bc04 <check_input_run+0xeef4>
 107bc51:	cmp    0xc8(%rsp),%r11
 107bc59:	jae    107bc73 <check_input_run+0xef63>
 107bc5b:	mov    0x120(%rsp),%rcx
 107bc63:	mov    0x118(%rsp),%rdx
 107bc6b:	lea    (%rcx,%r11,1),%ebp
 107bc6f:	mov    %ebp,(%rdx,%r11,4)
 107bc73:	mov    0x28(%rsp),%rcx
 107bc78:	lea    0x3(%r8),%r11
 107bc7c:	cmp    (%rcx),%r9d
 107bc7f:	jae    107bcdd <check_input_run+0xefcd>
 107bc81:	mov    %r9d,%r9d
 107bc84:	lea    (%r9,%r9,2),%r14
 107bc88:	lea    0xa(,%r14,4),%r14
 107bc90:	mov    0x860(%rsp),%r15
 107bc98:	mov    0x1d0(%r15),%r15
 107bc9f:	cmp    %r11d,(%r15,%r14,4)
 107bca3:	ja     107bcdd <check_input_run+0xefcd>
 107bca5:	mov    0x120(%rsp),%rdx
 107bcad:	mov    0x198(%rsp),%rcx
 107bcb5:	add    $0xc,%r14
 107bcb9:	lea    (%rdx,%r11,1),%ebp
 107bcbd:	mov    %ebp,(%rcx,%r9,4)
 107bcc1:	add    (%rsi,%r9,4),%edx
 107bcc5:	inc    %r9
 107bcc8:	mov    %rdx,0x120(%rsp)
 107bcd0:	mov    0x28(%rsp),%rdx
 107bcd5:	mov    (%rdx),%r15d
 107bcd8:	cmp    %r15,%r9
 107bcdb:	jb     107bc90 <check_input_run+0xef80>
 107bcdd:	cmp    0xc8(%rsp),%r11
 107bce5:	jae    107bac6 <check_input_run+0xedb6>
 107bceb:	mov    0x120(%rsp),%rcx
 107bcf3:	mov    0x118(%rsp),%rdx
 107bcfb:	lea    (%rcx,%r11,1),%ebp
 107bcff:	mov    %ebp,(%rdx,%r11,4)
 107bd03:	jmp    107bac6 <check_input_run+0xedb6>
 107bd08:	test   %rdi,%rdi
 107bd0b:	je     107bdb2 <check_input_run+0xf0a2>
 107bd11:	xor    %r10d,%r10d
 107bd14:	jmp    107bd25 <check_input_run+0xf015>
 107bd16:	inc    %r8
 107bd19:	inc    %r10
 107bd1c:	cmp    %rdi,%r10
 107bd1f:	je     107bdb2 <check_input_run+0xf0a2>
 107bd25:	mov    0x28(%rsp),%rcx
 107bd2a:	cmp    (%rcx),%r9d
 107bd2d:	jae    107bd8b <check_input_run+0xf07b>
 107bd2f:	mov    %r9d,%r9d
 107bd32:	lea    (%r9,%r9,2),%r11
 107bd36:	lea    0xa(,%r11,4),%r11
 107bd3e:	mov    0x860(%rsp),%r14
 107bd46:	mov    0x1d0(%r14),%r14
 107bd4d:	cmp    %r8d,(%r14,%r11,4)
 107bd51:	ja     107bd8b <check_input_run+0xf07b>
 107bd53:	mov    0x120(%rsp),%rdx
 107bd5b:	mov    0x198(%rsp),%rcx
 107bd63:	add    $0xc,%r11
 107bd67:	lea    (%rdx,%r8,1),%ebp
 107bd6b:	mov    %ebp,(%rcx,%r9,4)
 107bd6f:	add    (%rsi,%r9,4),%edx
 107bd73:	inc    %r9
 107bd76:	mov    %rdx,0x120(%rsp)
 107bd7e:	mov    0x28(%rsp),%rdx
 107bd83:	mov    (%rdx),%r14d
 107bd86:	cmp    %r14,%r9
 107bd89:	jb     107bd3e <check_input_run+0xf02e>
 107bd8b:	cmp    0xc8(%rsp),%r8
 107bd93:	jae    107bd16 <check_input_run+0xf006>
 107bd95:	mov    0x120(%rsp),%rcx
 107bd9d:	mov    0x118(%rsp),%rdx
 107bda5:	lea    (%rcx,%r8,1),%r11d
 107bda9:	mov    %r11d,(%rdx,%r8,4)
 107bdad:	jmp    107bd16 <check_input_run+0xf006>
 107bdb2:	cmpl   $0x0,0x60(%rsp)
 107bdb7:	je     107bec0 <check_input_run+0xf1b0>
 107bdbd:	mov    0x60(%rsp),%r8
 107bdc2:	mov    %r8d,%edi
 107bdc5:	and    $0x7,%edi
 107bdc8:	cmp    $0x8,%r8d
 107bdcc:	jae    107bdd6 <check_input_run+0xf0c6>
 107bdce:	xor    %r8d,%r8d
 107bdd1:	jmp    107be8c <check_input_run+0xf17c>
 107bdd6:	mov    0x1b0(%rsp),%r14
 107bdde:	mov    0x60(%rsp),%r8
 107bde3:	shr    $0x3,%r8d
 107bde7:	xor    %r10d,%r10d
 107bdea:	imul   $0xa80,%r8,%r9
 107bdf1:	xor    %r8d,%r8d
 107bdf4:	mov    (%r14),%r11
 107bdf7:	mov    0x118(%r11,%r10,1),%r11d
 107bdff:	mov    %r11d,(%rsi,%r8,4)
 107be03:	mov    (%r14),%r11
 107be06:	mov    0x268(%r11,%r10,1),%r11d
 107be0e:	mov    %r11d,0x4(%rsi,%r8,4)
 107be13:	mov    (%r14),%r11
 107be16:	mov    0x3b8(%r11,%r10,1),%r11d
 107be1e:	mov    %r11d,0x8(%rsi,%r8,4)
 107be23:	mov    (%r14),%r11
 107be26:	mov    0x508(%r11,%r10,1),%r11d
 107be2e:	mov    %r11d,0xc(%rsi,%r8,4)
 107be33:	mov    (%r14),%r11
 107be36:	mov    0x658(%r11,%r10,1),%r11d
 107be3e:	mov    %r11d,0x10(%rsi,%r8,4)
 107be43:	mov    (%r14),%r11
 107be46:	mov    0x7a8(%r11,%r10,1),%r11d
 107be4e:	mov    %r11d,0x14(%rsi,%r8,4)
 107be53:	mov    (%r14),%r11
 107be56:	mov    0x8f8(%r11,%r10,1),%r11d
 107be5e:	mov    %r11d,0x18(%rsi,%r8,4)
 107be63:	mov    (%r14),%r11
 107be66:	mov    0xa48(%r11,%r10,1),%r11d
 107be6e:	add    $0xa80,%r10
 107be75:	mov    %r11d,0x1c(%rsi,%r8,4)
 107be7a:	add    $0x8,%r8
 107be7e:	cmp    %r10,%r9
 107be81:	jne    107bdf4 <check_input_run+0xf0e4>
 107be87:	test   %rdi,%rdi
 107be8a:	je     107bec0 <check_input_run+0xf1b0>
 107be8c:	lea    (%rsi,%r8,4),%r9
 107be90:	imul   $0x150,%r8,%r8
 107be97:	xor    %r10d,%r10d
 107be9a:	mov    0x1b0(%rsp),%r11
 107bea2:	mov    (%r11),%r11
 107bea5:	mov    0x118(%r11,%r8,1),%r11d
 107bead:	add    $0x150,%r8
 107beb4:	mov    %r11d,(%r9,%r10,4)
 107beb8:	inc    %r10
 107bebb:	cmp    %r10,%rdi
 107bebe:	jne    107be9a <check_input_run+0xf18a>
 107bec0:	mov    0x100(%rsp),%r10
 107bec8:	lea    0x1(%r10),%r8d
 107becc:	cmp    $0x1,%r8d
 107bed0:	adc    $0x1,%r10d
 107bed4:	mov    %r10d,%edi
 107bed7:	and    $0x3,%edi
 107beda:	cmp    $0x4,%r8d
 107bede:	jae    107beed <check_input_run+0xf1dd>
 107bee0:	xor    %r8d,%r8d
 107bee3:	xor    %r9d,%r9d
 107bee6:	xor    %edx,%edx
 107bee8:	jmp    107c0e6 <check_input_run+0xf3d6>
 107beed:	and    $0xfffffffc,%r10d
 107bef1:	xor    %r8d,%r8d
 107bef4:	xor    %r9d,%r9d
 107bef7:	xor    %edx,%edx
 107bef9:	jmp    107bf08 <check_input_run+0xf1f8>
 107befb:	add    $0x4,%r8
 107beff:	cmp    %r10,%r8
 107bf02:	je     107c0dd <check_input_run+0xf3cd>
 107bf08:	mov    0x28(%rsp),%rcx
 107bf0d:	cmp    (%rcx),%r9d
 107bf10:	jae    107bf5e <check_input_run+0xf24e>
 107bf12:	mov    %r9d,%r9d
 107bf15:	lea    (%r9,%r9,2),%r11
 107bf19:	lea    0xb(,%r11,4),%r11
 107bf21:	mov    0x860(%rsp),%r14
 107bf29:	mov    0x1d0(%r14),%r14
 107bf30:	cmp    %r8d,(%r14,%r11,4)
 107bf34:	ja     107bf5e <check_input_run+0xf24e>
 107bf36:	mov    0x180(%rsp),%rcx
 107bf3e:	mov    0x28(%rsp),%rbx
 107bf43:	lea    (%rdx,%r8,1),%ebp
 107bf47:	add    $0xc,%r11
 107bf4b:	mov    %ebp,(%rcx,%r9,4)
 107bf4f:	add    (%rsi,%r9,4),%edx
 107bf53:	mov    (%rbx),%r14d
 107bf56:	inc    %r9
 107bf59:	cmp    %r14,%r9
 107bf5c:	jb     107bf21 <check_input_run+0xf211>
 107bf5e:	cmp    0x100(%rsp),%r8
 107bf66:	jae    107bf78 <check_input_run+0xf268>
 107bf68:	mov    0x148(%rsp),%rcx
 107bf70:	lea    (%rdx,%r8,1),%r11d
 107bf74:	mov    %r11d,(%rcx,%r8,4)
 107bf78:	mov    0x28(%rsp),%rcx
 107bf7d:	lea    0x1(%r8),%r11
 107bf81:	cmp    (%rcx),%r9d
 107bf84:	jae    107bfd2 <check_input_run+0xf2c2>
 107bf86:	mov    %r9d,%r9d
 107bf89:	lea    (%r9,%r9,2),%r14
 107bf8d:	lea    0xb(,%r14,4),%r14
 107bf95:	mov    0x860(%rsp),%r15
 107bf9d:	mov    0x1d0(%r15),%r15
 107bfa4:	cmp    %r11d,(%r15,%r14,4)
 107bfa8:	ja     107bfd2 <check_input_run+0xf2c2>
 107bfaa:	mov    0x180(%rsp),%rcx
 107bfb2:	mov    0x28(%rsp),%rbx
 107bfb7:	lea    (%rdx,%r11,1),%ebp
 107bfbb:	add    $0xc,%r14
 107bfbf:	mov    %ebp,(%rcx,%r9,4)
 107bfc3:	add    (%rsi,%r9,4),%edx
 107bfc7:	mov    (%rbx),%r15d
 107bfca:	inc    %r9
 107bfcd:	cmp    %r15,%r9
 107bfd0:	jb     107bf95 <check_input_run+0xf285>
 107bfd2:	cmp    0x100(%rsp),%r11
 107bfda:	jae    107bfec <check_input_run+0xf2dc>
 107bfdc:	mov    0x148(%rsp),%rcx
 107bfe4:	lea    (%rdx,%r11,1),%ebp
 107bfe8:	mov    %ebp,(%rcx,%r11,4)
 107bfec:	mov    0x28(%rsp),%rcx
 107bff1:	lea    0x2(%r8),%r11
 107bff5:	cmp    (%rcx),%r9d
 107bff8:	jae    107c046 <check_input_run+0xf336>
 107bffa:	mov    %r9d,%r9d
 107bffd:	lea    (%r9,%r9,2),%r14
 107c001:	lea    0xb(,%r14,4),%r14
 107c009:	mov    0x860(%rsp),%r15
 107c011:	mov    0x1d0(%r15),%r15
 107c018:	cmp    %r11d,(%r15,%r14,4)
 107c01c:	ja     107c046 <check_input_run+0xf336>
 107c01e:	mov    0x180(%rsp),%rcx
 107c026:	mov    0x28(%rsp),%rbx
 107c02b:	lea    (%rdx,%r11,1),%ebp
 107c02f:	add    $0xc,%r14
 107c033:	mov    %ebp,(%rcx,%r9,4)
 107c037:	add    (%rsi,%r9,4),%edx
 107c03b:	mov    (%rbx),%r15d
 107c03e:	inc    %r9
 107c041:	cmp    %r15,%r9
 107c044:	jb     107c009 <check_input_run+0xf2f9>
 107c046:	cmp    0x100(%rsp),%r11
 107c04e:	jae    107c060 <check_input_run+0xf350>
 107c050:	mov    0x148(%rsp),%rcx
 107c058:	lea    (%rdx,%r11,1),%ebp
 107c05c:	mov    %ebp,(%rcx,%r11,4)
 107c060:	mov    0x28(%rsp),%rcx
 107c065:	lea    0x3(%r8),%r11
 107c069:	cmp    (%rcx),%r9d
 107c06c:	jae    107c0ba <check_input_run+0xf3aa>
 107c06e:	mov    %r9d,%r9d
 107c071:	lea    (%r9,%r9,2),%r14
 107c075:	lea    0xb(,%r14,4),%r14
 107c07d:	mov    0x860(%rsp),%r15
 107c085:	mov    0x1d0(%r15),%r15
 107c08c:	cmp    %r11d,(%r15,%r14,4)
 107c090:	ja     107c0ba <check_input_run+0xf3aa>
 107c092:	mov    0x180(%rsp),%rcx
 107c09a:	mov    0x28(%rsp),%rbx
 107c09f:	lea    (%rdx,%r11,1),%ebp
 107c0a3:	add    $0xc,%r14
 107c0a7:	mov    %ebp,(%rcx,%r9,4)
 107c0ab:	add    (%rsi,%r9,4),%edx
 107c0af:	mov    (%rbx),%r15d
 107c0b2:	inc    %r9
 107c0b5:	cmp    %r15,%r9
 107c0b8:	jb     107c07d <check_input_run+0xf36d>
 107c0ba:	cmp    0x100(%rsp),%r11
 107c0c2:	jae    107befb <check_input_run+0xf1eb>
 107c0c8:	mov    0x148(%rsp),%rcx
 107c0d0:	lea    (%rdx,%r11,1),%ebp
 107c0d4:	mov    %ebp,(%rcx,%r11,4)
 107c0d8:	jmp    107befb <check_input_run+0xf1eb>
 107c0dd:	test   %rdi,%rdi
 107c0e0:	je     107c168 <check_input_run+0xf458>
 107c0e6:	xor    %r10d,%r10d
 107c0e9:	jmp    107c0f6 <check_input_run+0xf3e6>
 107c0eb:	inc    %r8
 107c0ee:	inc    %r10
 107c0f1:	cmp    %rdi,%r10
 107c0f4:	je     107c168 <check_input_run+0xf458>
 107c0f6:	mov    0x28(%rsp),%rcx
 107c0fb:	cmp    (%rcx),%r9d
 107c0fe:	jae    107c14c <check_input_run+0xf43c>
 107c100:	mov    %r9d,%r9d
 107c103:	lea    (%r9,%r9,2),%r11
 107c107:	lea    0xb(,%r11,4),%r11
 107c10f:	mov    0x860(%rsp),%r14
 107c117:	mov    0x1d0(%r14),%r14
 107c11e:	cmp    %r8d,(%r14,%r11,4)
 107c122:	ja     107c14c <check_input_run+0xf43c>
 107c124:	mov    0x180(%rsp),%rcx
 107c12c:	mov    0x28(%rsp),%rbx
 107c131:	lea    (%rdx,%r8,1),%ebp
 107c135:	add    $0xc,%r11
 107c139:	mov    %ebp,(%rcx,%r9,4)
 107c13d:	add    (%rsi,%r9,4),%edx
 107c141:	mov    (%rbx),%r14d
 107c144:	inc    %r9
 107c147:	cmp    %r14,%r9
 107c14a:	jb     107c10f <check_input_run+0xf3ff>
 107c14c:	cmp    0x100(%rsp),%r8
 107c154:	jae    107c0eb <check_input_run+0xf3db>
 107c156:	mov    0x148(%rsp),%rcx
 107c15e:	lea    (%rdx,%r8,1),%r11d
 107c162:	mov    %r11d,(%rcx,%r8,4)
 107c166:	jmp    107c0eb <check_input_run+0xf3db>
 107c168:	cmpl   $0x0,0x60(%rsp)
 107c16d:	je     107c270 <check_input_run+0xf560>
 107c173:	mov    0x60(%rsp),%r8
 107c178:	mov    %r8d,%edi
 107c17b:	and    $0x7,%edi
 107c17e:	cmp    $0x8,%r8d
 107c182:	jae    107c18c <check_input_run+0xf47c>
 107c184:	xor    %r8d,%r8d
 107c187:	jmp    107c23f <check_input_run+0xf52f>
 107c18c:	mov    0x1b0(%rsp),%r14
 107c194:	mov    0x60(%rsp),%r8
 107c199:	shr    $0x3,%r8d
 107c19d:	xor    %r10d,%r10d
 107c1a0:	imul   $0xa80,%r8,%r9
 107c1a7:	xor    %r8d,%r8d
 107c1aa:	mov    (%r14),%r11
 107c1ad:	mov    0x60(%r11,%r10,1),%r11d
 107c1b2:	mov    %r11d,(%rsi,%r8,4)
 107c1b6:	mov    (%r14),%r11
 107c1b9:	mov    0x1b0(%r11,%r10,1),%r11d
 107c1c1:	mov    %r11d,0x4(%rsi,%r8,4)
 107c1c6:	mov    (%r14),%r11
 107c1c9:	mov    0x300(%r11,%r10,1),%r11d
 107c1d1:	mov    %r11d,0x8(%rsi,%r8,4)
 107c1d6:	mov    (%r14),%r11
 107c1d9:	mov    0x450(%r11,%r10,1),%r11d
 107c1e1:	mov    %r11d,0xc(%rsi,%r8,4)
 107c1e6:	mov    (%r14),%r11
 107c1e9:	mov    0x5a0(%r11,%r10,1),%r11d
 107c1f1:	mov    %r11d,0x10(%rsi,%r8,4)
 107c1f6:	mov    (%r14),%r11
 107c1f9:	mov    0x6f0(%r11,%r10,1),%r11d
 107c201:	mov    %r11d,0x14(%rsi,%r8,4)
 107c206:	mov    (%r14),%r11
 107c209:	mov    0x840(%r11,%r10,1),%r11d
 107c211:	mov    %r11d,0x18(%rsi,%r8,4)
 107c216:	mov    (%r14),%r11
 107c219:	mov    0x990(%r11,%r10,1),%r11d
 107c221:	add    $0xa80,%r10
 107c228:	mov    %r11d,0x1c(%rsi,%r8,4)
 107c22d:	add    $0x8,%r8
 107c231:	cmp    %r10,%r9
 107c234:	jne    107c1aa <check_input_run+0xf49a>
 107c23a:	test   %rdi,%rdi
 107c23d:	je     107c270 <check_input_run+0xf560>
 107c23f:	lea    (%rsi,%r8,4),%r9
 107c243:	imul   $0x150,%r8,%r8
 107c24a:	xor    %r10d,%r10d
 107c24d:	mov    0x1b0(%rsp),%r11
 107c255:	mov    (%r11),%r11
 107c258:	mov    0x60(%r11,%r8,1),%r11d
 107c25d:	add    $0x150,%r8
 107c264:	mov    %r11d,(%r9,%r10,4)
 107c268:	inc    %r10
 107c26b:	cmp    %r10,%rdi
 107c26e:	jne    107c24d <check_input_run+0xf53d>
 107c270:	mov    0xa8(%rsp),%r11
 107c278:	mov    0xb8(%rsp),%rdi
 107c280:	add    0x68(%rsp),%edi
 107c284:	lea    0x1(%r11),%ecx
 107c288:	cmp    $0x1,%ecx
 107c28b:	mov    %rdi,0xb8(%rsp)
 107c293:	adc    $0x1,%r11d
 107c297:	mov    %r11d,%r8d
 107c29a:	and    $0x3,%r8d
 107c29e:	cmp    $0x4,%ecx
 107c2a1:	jae    107c2b0 <check_input_run+0xf5a0>
 107c2a3:	xor    %r9d,%r9d
 107c2a6:	xor    %r10d,%r10d
 107c2a9:	xor    %edi,%edi
 107c2ab:	jmp    107c488 <check_input_run+0xf778>
 107c2b0:	and    $0xfffffffc,%r11d
 107c2b4:	xor    %r9d,%r9d
 107c2b7:	xor    %r10d,%r10d
 107c2ba:	xor    %edi,%edi
 107c2bc:	jmp    107c2cb <check_input_run+0xf5bb>
 107c2be:	add    $0x4,%r9
 107c2c2:	cmp    %r11,%r9
 107c2c5:	je     107c483 <check_input_run+0xf773>
 107c2cb:	mov    0x28(%rsp),%rcx
 107c2d0:	cmp    (%rcx),%r10d
 107c2d3:	jae    107c321 <check_input_run+0xf611>
 107c2d5:	mov    %r10d,%r10d
 107c2d8:	lea    (%r10,%r10,2),%r14
 107c2dc:	lea    0x4(,%r14,4),%r14
 107c2e4:	mov    0x860(%rsp),%r15
 107c2ec:	mov    0x1d0(%r15),%r15
 107c2f3:	cmp    %r9d,(%r15,%r14,4)
 107c2f7:	ja     107c321 <check_input_run+0xf611>
 107c2f9:	mov    0x1a8(%rsp),%rcx
 107c301:	mov    0x28(%rsp),%rbx
 107c306:	lea    (%rdi,%r9,1),%ebp
 107c30a:	add    $0xc,%r14
 107c30e:	mov    %ebp,(%rcx,%r10,4)
 107c312:	add    (%rsi,%r10,4),%edi
 107c316:	mov    (%rbx),%r15d
 107c319:	inc    %r10
 107c31c:	cmp    %r15,%r10
 107c31f:	jb     107c2e4 <check_input_run+0xf5d4>
 107c321:	cmp    0xa8(%rsp),%r9
 107c329:	jae    107c333 <check_input_run+0xf623>
 107c32b:	lea    (%rdi,%r9,1),%ebp
 107c32f:	mov    %ebp,(%rax,%r9,4)
 107c333:	mov    0x28(%rsp),%rcx
 107c338:	lea    0x1(%r9),%r14
 107c33c:	cmp    (%rcx),%r10d
 107c33f:	jae    107c38e <check_input_run+0xf67e>
 107c341:	mov    %r10d,%r10d
 107c344:	lea    (%r10,%r10,2),%r15
 107c348:	lea    0x4(,%r15,4),%r15
 107c350:	mov    0x860(%rsp),%r12
 107c358:	mov    0x1d0(%r12),%r12
 107c360:	cmp    %r14d,(%r12,%r15,4)
 107c364:	ja     107c38e <check_input_run+0xf67e>
 107c366:	mov    0x1a8(%rsp),%rcx
 107c36e:	mov    0x28(%rsp),%rbx
 107c373:	lea    (%rdi,%r14,1),%ebp
 107c377:	add    $0xc,%r15
 107c37b:	mov    %ebp,(%rcx,%r10,4)
 107c37f:	add    (%rsi,%r10,4),%edi
 107c383:	mov    (%rbx),%r12d
 107c386:	inc    %r10
 107c389:	cmp    %r12,%r10
 107c38c:	jb     107c350 <check_input_run+0xf640>
 107c38e:	cmp    0xa8(%rsp),%r14
 107c396:	jae    107c3a0 <check_input_run+0xf690>
 107c398:	lea    (%rdi,%r14,1),%ebp
 107c39c:	mov    %ebp,(%rax,%r14,4)
 107c3a0:	mov    0x28(%rsp),%rcx
 107c3a5:	lea    0x2(%r9),%r14
 107c3a9:	cmp    (%rcx),%r10d
 107c3ac:	jae    107c3fb <check_input_run+0xf6eb>
 107c3ae:	mov    %r10d,%r10d
 107c3b1:	lea    (%r10,%r10,2),%r15
 107c3b5:	lea    0x4(,%r15,4),%r15
 107c3bd:	mov    0x860(%rsp),%r12
 107c3c5:	mov    0x1d0(%r12),%r12
 107c3cd:	cmp    %r14d,(%r12,%r15,4)
 107c3d1:	ja     107c3fb <check_input_run+0xf6eb>
 107c3d3:	mov    0x1a8(%rsp),%rcx
 107c3db:	mov    0x28(%rsp),%rbx
 107c3e0:	lea    (%rdi,%r14,1),%ebp
 107c3e4:	add    $0xc,%r15
 107c3e8:	mov    %ebp,(%rcx,%r10,4)
 107c3ec:	add    (%rsi,%r10,4),%edi
 107c3f0:	mov    (%rbx),%r12d
 107c3f3:	inc    %r10
 107c3f6:	cmp    %r12,%r10
 107c3f9:	jb     107c3bd <check_input_run+0xf6ad>
 107c3fb:	cmp    0xa8(%rsp),%r14
 107c403:	jae    107c40d <check_input_run+0xf6fd>
 107c405:	lea    (%rdi,%r14,1),%ebp
 107c409:	mov    %ebp,(%rax,%r14,4)
 107c40d:	mov    0x28(%rsp),%rcx
 107c412:	lea    0x3(%r9),%r14
 107c416:	cmp    (%rcx),%r10d
 107c419:	jae    107c468 <check_input_run+0xf758>
 107c41b:	mov    %r10d,%r10d
 107c41e:	lea    (%r10,%r10,2),%r15
 107c422:	lea    0x4(,%r15,4),%r15
 107c42a:	mov    0x860(%rsp),%r12
 107c432:	mov    0x1d0(%r12),%r12
 107c43a:	cmp    %r14d,(%r12,%r15,4)
 107c43e:	ja     107c468 <check_input_run+0xf758>
 107c440:	mov    0x1a8(%rsp),%rcx
 107c448:	mov    0x28(%rsp),%rbx
 107c44d:	lea    (%rdi,%r14,1),%ebp
 107c451:	add    $0xc,%r15
 107c455:	mov    %ebp,(%rcx,%r10,4)
 107c459:	add    (%rsi,%r10,4),%edi
 107c45d:	mov    (%rbx),%r12d
 107c460:	inc    %r10
 107c463:	cmp    %r12,%r10
 107c466:	jb     107c42a <check_input_run+0xf71a>
 107c468:	cmp    0xa8(%rsp),%r14
 107c470:	jae    107c2be <check_input_run+0xf5ae>
 107c476:	lea    (%rdi,%r14,1),%ebp
 107c47a:	mov    %ebp,(%rax,%r14,4)
 107c47e:	jmp    107c2be <check_input_run+0xf5ae>
 107c483:	test   %r8,%r8
 107c486:	je     107c502 <check_input_run+0xf7f2>
 107c488:	xor    %r11d,%r11d
 107c48b:	jmp    107c498 <check_input_run+0xf788>
 107c48d:	inc    %r9
 107c490:	inc    %r11
 107c493:	cmp    %r8,%r11
 107c496:	je     107c502 <check_input_run+0xf7f2>
 107c498:	mov    0x28(%rsp),%rcx
 107c49d:	cmp    (%rcx),%r10d
 107c4a0:	jae    107c4ee <check_input_run+0xf7de>
 107c4a2:	mov    %r10d,%r10d
 107c4a5:	lea    (%r10,%r10,2),%r14
 107c4a9:	lea    0x4(,%r14,4),%r14
 107c4b1:	mov    0x860(%rsp),%r15
 107c4b9:	mov    0x1d0(%r15),%r15
 107c4c0:	cmp    %r9d,(%r15,%r14,4)
 107c4c4:	ja     107c4ee <check_input_run+0xf7de>
 107c4c6:	mov    0x1a8(%rsp),%rcx
 107c4ce:	mov    0x28(%rsp),%rbx
 107c4d3:	lea    (%rdi,%r9,1),%ebp
 107c4d7:	add    $0xc,%r14
 107c4db:	mov    %ebp,(%rcx,%r10,4)
 107c4df:	add    (%rsi,%r10,4),%edi
 107c4e3:	mov    (%rbx),%r15d
 107c4e6:	inc    %r10
 107c4e9:	cmp    %r15,%r10
 107c4ec:	jb     107c4b1 <check_input_run+0xf7a1>
 107c4ee:	cmp    0xa8(%rsp),%r9
 107c4f6:	jae    107c48d <check_input_run+0xf77d>
 107c4f8:	lea    (%rdi,%r9,1),%ebp
 107c4fc:	mov    %ebp,(%rax,%r9,4)
 107c500:	jmp    107c48d <check_input_run+0xf77d>
 107c502:	mov    0xe8(%rsp),%rcx
 107c50a:	inc    %ecx
 107c50c:	mov    %rcx,0x28(%rsp)
 107c511:	cmp    %ecx,0xb8(%rsp)
 107c518:	ja     1077c8e <check_input_run+0xaf7e>
 107c51e:	mov    0xe0(%rsp),%rcx
 107c526:	add    0xa0(%rsp),%ecx
 107c52d:	mov    %rcx,0xe0(%rsp)
 107c535:	cmp    0x28(%rsp),%ecx
 107c539:	ja     1077c8e <check_input_run+0xaf7e>
 107c53f:	mov    0x108(%rsp),%rcx
 107c547:	mov    0xc0(%rsp),%rsi
 107c54f:	add    0xd8(%rsp),%ecx
 107c556:	mov    %rcx,0x108(%rsp)
 107c55e:	cmp    0x334(%rsi),%ecx
 107c564:	ja     1077c8e <check_input_run+0xaf7e>
 107c56a:	mov    0x128(%rsp),%rcx
 107c572:	mov    0xc0(%rsp),%rsi
 107c57a:	add    0x70(%rsp),%ecx
 107c57e:	mov    %rcx,0x128(%rsp)
 107c586:	cmp    0x344(%rsi),%ecx
 107c58c:	ja     1077c8e <check_input_run+0xaf7e>
 107c592:	mov    0x120(%rsp),%rcx
 107c59a:	add    0xc8(%rsp),%ecx
 107c5a1:	mov    %rcx,0x120(%rsp)
 107c5a9:	cmp    0x4e4(%rsp),%ecx
 107c5b0:	ja     1077c8e <check_input_run+0xaf7e>
 107c5b6:	add    0xa8(%rsp),%edi
 107c5bd:	cmp    0x2dc(%rsp),%edi
 107c5c4:	ja     1077c8e <check_input_run+0xaf7e>
 107c5ca:	mov    0x2c0(%rsp),%rsi
 107c5d2:	mov    (%rsi),%r9
 107c5d5:	mov    0x8(%rsi),%r8
 107c5d9:	lea    0x7(%r8,%r9,1),%rcx
 107c5de:	add    %r9,%r8
 107c5e1:	and    $0xfffffffffffffff8,%rcx
 107c5e5:	mov    %rcx,0x178(%rsp)
 107c5ed:	cmp    %r8,%rcx
 107c5f0:	jb     1077c8e <check_input_run+0xaf7e>
 107c5f6:	mov    0x178(%rsp),%r8
 107c5fe:	sub    %r9,%r8
 107c601:	mov    0x10(%rsi),%r9
 107c605:	sub    %r8,%r9
 107c608:	jb     1077c8e <check_input_run+0xaf7e>
 107c60e:	mov    0xe8(%rsp),%rcx
 107c616:	lea    (%rcx,%rcx,4),%r10
 107c61a:	lea    0x28(,%r10,8),%r10
 107c622:	cmp    %r9,%r10
 107c625:	ja     1077c8e <check_input_run+0xaf7e>
 107c62b:	add    %r10,%r8
 107c62e:	cmpq   $0x0,0x178(%rsp)
 107c637:	mov    %r8,0x8(%rsi)
 107c63b:	je     1077c8e <check_input_run+0xaf7e>
 107c641:	mov    0x2c0(%rsp),%rsi
 107c649:	mov    (%rsi),%r9
 107c64c:	mov    0x8(%rsi),%r8
 107c650:	lea    0x3(%r8,%r9,1),%rcx
 107c655:	add    %r9,%r8
 107c658:	and    $0xfffffffffffffffc,%rcx
 107c65c:	mov    %rcx,0x1f8(%rsp)
 107c664:	cmp    %r8,%rcx
 107c667:	jb     1077c8e <check_input_run+0xaf7e>
 107c66d:	mov    0x1f8(%rsp),%r8
 107c675:	sub    %r9,%r8
 107c678:	mov    0x10(%rsi),%r9
 107c67c:	sub    %r8,%r9
 107c67f:	jb     1077c8e <check_input_run+0xaf7e>
 107c685:	mov    0xe8(%rsp),%rcx
 107c68d:	lea    (%rcx,%rcx,2),%r10
 107c691:	lea    0x18(,%r10,8),%r10
 107c699:	cmp    %r9,%r10
 107c69c:	ja     1077c8e <check_input_run+0xaf7e>
 107c6a2:	add    %r10,%r8
 107c6a5:	cmpq   $0x0,0x1f8(%rsp)
 107c6ae:	mov    %r8,0x8(%rsi)
 107c6b2:	je     1077c8e <check_input_run+0xaf7e>
 107c6b8:	mov    0x2c0(%rsp),%rsi
 107c6c0:	mov    (%rsi),%r9
 107c6c3:	mov    0x8(%rsi),%r8
 107c6c7:	lea    0x3(%r8,%r9,1),%rcx
 107c6cc:	add    %r9,%r8
 107c6cf:	and    $0xfffffffffffffffc,%rcx
 107c6d3:	mov    %rcx,0x160(%rsp)
 107c6db:	cmp    %r8,%rcx
 107c6de:	jb     1077c8e <check_input_run+0xaf7e>
 107c6e4:	mov    0x160(%rsp),%r8
 107c6ec:	sub    %r9,%r8
 107c6ef:	mov    0x10(%rsi),%r9
 107c6f3:	sub    %r8,%r9
 107c6f6:	jb     1077c8e <check_input_run+0xaf7e>
 107c6fc:	mov    0xc0(%rsp),%r10
 107c704:	mov    0x334(%r10),%r10d
 107c70b:	lea    (%r10,%r10,8),%r10
 107c70f:	lea    0x24(,%r10,4),%r10
 107c717:	cmp    %r9,%r10
 107c71a:	ja     1077c8e <check_input_run+0xaf7e>
 107c720:	add    %r10,%r8
 107c723:	cmpq   $0x0,0x160(%rsp)
 107c72c:	mov    %r8,0x8(%rsi)
 107c730:	je     1077c8e <check_input_run+0xaf7e>
 107c736:	mov    0x2c0(%rsp),%rsi
 107c73e:	mov    (%rsi),%r9
 107c741:	mov    0x8(%rsi),%r8
 107c745:	lea    0x7(%r8,%r9,1),%rcx
 107c74a:	add    %r9,%r8
 107c74d:	and    $0xfffffffffffffff8,%rcx
 107c751:	mov    %rcx,0x1f0(%rsp)
 107c759:	cmp    %r8,%rcx
 107c75c:	jb     1077c8e <check_input_run+0xaf7e>
 107c762:	mov    0x1f0(%rsp),%r8
 107c76a:	sub    %r9,%r8
 107c76d:	mov    0x10(%rsi),%r9
 107c771:	sub    %r8,%r9
 107c774:	jb     1077c8e <check_input_run+0xaf7e>
 107c77a:	mov    0xc0(%rsp),%r10
 107c782:	mov    0x344(%r10),%r10d
 107c789:	lea    (%r10,%r10,4),%r10
 107c78d:	shl    $0x4,%r10
 107c791:	add    $0x50,%r10
 107c795:	cmp    %r9,%r10
 107c798:	ja     1077c8e <check_input_run+0xaf7e>
 107c79e:	add    %r10,%r8
 107c7a1:	cmpq   $0x0,0x1f0(%rsp)
 107c7aa:	mov    %r8,0x8(%rsi)
 107c7ae:	je     1077c8e <check_input_run+0xaf7e>
 107c7b4:	mov    0x2c8(%rsp),%rsi
 107c7bc:	mov    (%rsi),%r9
 107c7bf:	mov    0x8(%rsi),%r8
 107c7c3:	lea    0x3(%r8,%r9,1),%rcx
 107c7c8:	add    %r9,%r8
 107c7cb:	and    $0xfffffffffffffffc,%rcx
 107c7cf:	mov    %rcx,0x208(%rsp)
 107c7d7:	cmp    %r8,%rcx
 107c7da:	jb     1077c8e <check_input_run+0xaf7e>
 107c7e0:	mov    0x208(%rsp),%r8
 107c7e8:	sub    %r9,%r8
 107c7eb:	mov    0x10(%rsi),%r9
 107c7ef:	sub    %r8,%r9
 107c7f2:	jb     1077c8e <check_input_run+0xaf7e>
 107c7f8:	mov    0x4e4(%rsp),%r10d
 107c800:	imul   $0x2c,%r10,%r10
 107c804:	add    $0x2c,%r10
 107c808:	cmp    %r9,%r10
 107c80b:	ja     1077c8e <check_input_run+0xaf7e>
 107c811:	add    %r10,%r8
 107c814:	cmpq   $0x0,0x208(%rsp)
 107c81d:	mov    %r8,0x8(%rsi)
 107c821:	je     1077c8e <check_input_run+0xaf7e>
 107c827:	mov    0x2c8(%rsp),%rsi
 107c82f:	mov    (%rsi),%r9
 107c832:	mov    0x8(%rsi),%r8
 107c836:	add    %r9,%r8
 107c839:	lea    0xf(%r8),%rcx
 107c83d:	and    $0xfffffffffffffff0,%rcx
 107c841:	mov    %rcx,0x140(%rsp)
 107c849:	cmp    %r8,%rcx
 107c84c:	jb     1077c8e <check_input_run+0xaf7e>
 107c852:	mov    0x140(%rsp),%r8
 107c85a:	sub    %r9,%r8
 107c85d:	mov    0x10(%rsi),%r9
 107c861:	sub    %r8,%r9
 107c864:	jb     1077c8e <check_input_run+0xaf7e>
 107c86a:	add    0x100(%rsp),%edx
 107c871:	mov    %edx,%r10d
 107c874:	lea    (%r10,%r10,2),%r10
 107c878:	mov    %rdx,0x268(%rsp)
 107c880:	shl    $0x5,%r10
 107c884:	add    $0x60,%r10
 107c888:	cmp    %r9,%r10
 107c88b:	ja     1077c8e <check_input_run+0xaf7e>
 107c891:	add    %r10,%r8
 107c894:	cmpq   $0x0,0x140(%rsp)
 107c89d:	mov    %r8,0x8(%rsi)
 107c8a1:	je     107cc3b <check_input_run+0xff2b>
 107c8a7:	cmpl   $0x0,0x68(%rsp)
 107c8ac:	je     107cc3b <check_input_run+0xff2b>
 107c8b2:	xor    %r8d,%r8d
 107c8b5:	cmpl   $0x1,0x68(%rsp)
 107c8ba:	jne    107c997 <check_input_run+0xfc87>
 107c8c0:	xor    %esi,%esi
 107c8c2:	jmp    107cb07 <check_input_run+0xfdf7>
 107c8c7:	mov    0x10(%rsp),%rdi
 107c8cc:	add    %rdx,%rsi
 107c8cf:	mov    %rsi,0x8(%rdi)
 107c8d3:	mov    0x18(%rsp),%rdi
 107c8d8:	mov    %rcx,0x290(%rdi)
 107c8df:	test   %rcx,%rcx
 107c8e2:	je     107c92d <check_input_run+0xfc1d>
 107c8e4:	mov    0x10(%rsp),%rcx
 107c8e9:	mov    (%rcx),%rdi
 107c8ec:	mov    0x8(%rcx),%rsi
 107c8f0:	lea    0x7(%rsi,%rdi,1),%rcx
 107c8f5:	add    %rdi,%rsi
 107c8f8:	and    $0xfffffffffffffff8,%rcx
 107c8fc:	cmp    %rsi,%rcx
 107c8ff:	jb     107c92d <check_input_run+0xfc1d>
 107c901:	mov    %rcx,%rsi
 107c904:	sub    %rdi,%rsi
 107c907:	mov    0x10(%rsp),%rdi
 107c90c:	mov    0x10(%rdi),%rdi
 107c910:	sub    %rsi,%rdi
 107c913:	setb   %r8b
 107c917:	cmp    0x78(%rsp),%rdi
 107c91c:	setbe  %dil
 107c920:	or     %r8b,%dil
 107c923:	cmp    $0x1,%dil
 107c927:	jne    107cb91 <check_input_run+0xfe81>
 107c92d:	mov    0x18(%rsp),%rdi
 107c932:	mov    0x10(%rsp),%rsi
 107c937:	mov    0x20(%rsp),%r12
 107c93c:	mov    0x40(%rsp),%rax
 107c941:	mov    0x30(%rsp),%r9
 107c946:	movq   $0x0,0x298(%rdi)
 107c951:	jmp    106d605 <check_input_run+0x8f5>
 107c956:	xor    %esi,%esi
 107c958:	xor    %ecx,%ecx
 107c95a:	jmp    107c98d <check_input_run+0xfc7d>
 107c95c:	mov    %rax,%rdi
 107c95f:	sub    %rcx,%rdi
 107c962:	xor    %ecx,%ecx
 107c964:	sub    %rdi,%rdx
 107c967:	jb     107c98d <check_input_run+0xfc7d>
 107c969:	mov    0x100(%rsp),%r8
 107c971:	lea    0x0(,%r8,4),%r8
 107c979:	cmp    %rdx,%r8
 107c97c:	ja     107c98d <check_input_run+0xfc7d>
 107c97e:	mov    0x38(%rsp),%rcx
 107c983:	add    %r8,%rdi
 107c986:	mov    %rdi,0x8(%rcx)
 107c98a:	mov    %rax,%rcx
 107c98d:	mov    0x20(%rsp),%r12
 107c992:	jmp    106de21 <check_input_run+0x1111>
 107c997:	mov    0x68(%rsp),%r9
 107c99c:	and    $0xfffffffe,%r9d
 107c9a0:	xor    %esi,%esi
 107c9a2:	mov    0xc0(%rsp),%r12
 107c9aa:	lea    0x0(,%rsi,8),%r14
 107c9b2:	mov    0x0(%r13,%rsi,4),%r10d
 107c9b7:	mov    0x178(%rsp),%rcx
 107c9bf:	lea    (%r14,%r14,4),%r14
 107c9c3:	mov    0x350(%r12),%r11
 107c9cb:	lea    (%r10,%r10,4),%r10
 107c9cf:	mov    0x20(%r11,%r14,1),%r15
 107c9d4:	mov    %r15,0x20(%rcx,%r10,8)
 107c9d9:	vmovdqu (%r11,%r14,1),%ymm0
 107c9df:	mov    $0x0,%r11d
 107c9e5:	vmovdqu %ymm0,(%rcx,%r10,8)
 107c9eb:	mov    0x350(%r12),%r10
 107c9f3:	mov    0x8(%r10,%r14,1),%r10d
 107c9f8:	test   %r10d,%r10d
 107c9fb:	je     107ca35 <check_input_run+0xfd25>
 107c9fd:	mov    %r10d,%r11d
 107ca00:	shr    $0x3,%r11d
 107ca04:	cmpq   $0x0,0x48(%rsp)
 107ca0a:	je     107ca2d <check_input_run+0xfd1d>
 107ca0c:	mov    0x48(%rsp),%r14
 107ca11:	mov    %r11d,%r15d
 107ca14:	sub    0x10(%r14),%r15d
 107ca18:	jae    107ca25 <check_input_run+0xfd15>
 107ca1a:	mov    0x8(%r14),%r14
 107ca1e:	test   %r14,%r14
 107ca21:	jne    107ca11 <check_input_run+0xfd01>
 107ca23:	jmp    107ca2d <check_input_run+0xfd1d>
 107ca25:	mov    0x18(%r14),%r11
 107ca29:	mov    (%r11,%r15,4),%r11d
 107ca2d:	and    $0x7,%r10d
 107ca31:	lea    (%r10,%r11,8),%r11d
 107ca35:	mov    0x0(%r13,%rsi,4),%r10d
 107ca3a:	mov    0x178(%rsp),%rcx
 107ca42:	mov    0xc0(%rsp),%r12
 107ca4a:	lea    0x8(,%rsi,8),%r14
 107ca52:	lea    (%r14,%r14,4),%r14
 107ca56:	lea    (%r10,%r10,4),%r10
 107ca5a:	mov    %r11d,0x8(%rcx,%r10,8)
 107ca5f:	mov    0x350(%r12),%r11
 107ca67:	mov    0x4(%r13,%rsi,4),%r10d
 107ca6c:	mov    0x20(%r11,%r14,1),%r15
 107ca71:	lea    (%r10,%r10,4),%r10
 107ca75:	mov    %r15,0x20(%rcx,%r10,8)
 107ca7a:	vmovdqu (%r11,%r14,1),%ymm0
 107ca80:	vmovdqu %ymm0,(%rcx,%r10,8)
 107ca86:	mov    0x350(%r12),%r10
 107ca8e:	mov    0x8(%r10,%r14,1),%r10d
 107ca93:	test   %r10d,%r10d
 107ca96:	je     107cac0 <check_input_run+0xfdb0>
 107ca98:	mov    %r10d,%r11d
 107ca9b:	shr    $0x3,%r11d
 107ca9f:	cmpq   $0x0,0x48(%rsp)
 107caa5:	je     107cacd <check_input_run+0xfdbd>
 107caa7:	mov    0x48(%rsp),%r14
 107caac:	mov    %r11d,%r15d
 107caaf:	sub    0x10(%r14),%r15d
 107cab3:	jae    107cac5 <check_input_run+0xfdb5>
 107cab5:	mov    0x8(%r14),%r14
 107cab9:	test   %r14,%r14
 107cabc:	jne    107caac <check_input_run+0xfd9c>
 107cabe:	jmp    107cacd <check_input_run+0xfdbd>
 107cac0:	xor    %r10d,%r10d
 107cac3:	jmp    107cad5 <check_input_run+0xfdc5>
 107cac5:	mov    0x18(%r14),%r11
 107cac9:	mov    (%r11,%r15,4),%r11d
 107cacd:	and    $0x7,%r10d
 107cad1:	lea    (%r10,%r11,8),%r10d
 107cad5:	lea    0x1(%rsi),%r11
 107cad9:	mov    0x178(%rsp),%rcx
 107cae1:	add    $0x2,%rsi
 107cae5:	mov    0x0(%r13,%r11,4),%r11d
 107caea:	lea    (%r11,%r11,4),%r11
 107caee:	mov    %r10d,0x8(%rcx,%r11,8)
 107caf3:	cmp    %r9,%rsi
 107caf6:	jne    107c9a2 <check_input_run+0xfc92>
 107cafc:	testb  $0x1,0x68(%rsp)
 107cb01:	je     107cc3b <check_input_run+0xff2b>
 107cb07:	mov    0xc0(%rsp),%r15
 107cb0f:	lea    0x0(,%rsi,8),%r11
 107cb17:	mov    0x0(%r13,%rsi,4),%r9d
 107cb1c:	mov    0x178(%rsp),%rcx
 107cb24:	lea    (%r11,%r11,4),%r11
 107cb28:	mov    0x350(%r15),%r10
 107cb2f:	lea    (%r9,%r9,4),%r9
 107cb33:	mov    0x20(%r10,%r11,1),%r14
 107cb38:	mov    %r14,0x20(%rcx,%r9,8)
 107cb3d:	vmovdqu (%r10,%r11,1),%ymm0
 107cb43:	vmovdqu %ymm0,(%rcx,%r9,8)
 107cb49:	mov    0x350(%r15),%r9
 107cb50:	mov    0x8(%r9,%r11,1),%r9d
 107cb55:	test   %r9d,%r9d
 107cb58:	je     107cc25 <check_input_run+0xff15>
 107cb5e:	mov    %r9d,%r8d
 107cb61:	shr    $0x3,%r8d
 107cb65:	cmpq   $0x0,0x48(%rsp)
 107cb6b:	je     107cc1d <check_input_run+0xff0d>
 107cb71:	mov    0x48(%rsp),%r10
 107cb76:	mov    %r8d,%r11d
 107cb79:	sub    0x10(%r10),%r11d
 107cb7d:	jae    107cc15 <check_input_run+0xff05>
 107cb83:	mov    0x8(%r10),%r10
 107cb87:	test   %r10,%r10
 107cb8a:	jne    107cb76 <check_input_run+0xfe66>
 107cb8c:	jmp    107cc1d <check_input_run+0xff0d>
 107cb91:	mov    0x10(%rsp),%rdi
 107cb96:	add    %rdx,%rsi
 107cb99:	mov    %rsi,0x8(%rdi)
 107cb9d:	mov    0x18(%rsp),%rdi
 107cba2:	mov    %rcx,0x298(%rdi)
 107cba9:	test   %rcx,%rcx
 107cbac:	je     107cbf7 <check_input_run+0xfee7>
 107cbae:	mov    0x10(%rsp),%rcx
 107cbb3:	mov    (%rcx),%rdi
 107cbb6:	mov    0x8(%rcx),%rsi
 107cbba:	lea    0x7(%rsi,%rdi,1),%rcx
 107cbbf:	add    %rdi,%rsi
 107cbc2:	and    $0xfffffffffffffff8,%rcx
 107cbc6:	cmp    %rsi,%rcx
 107cbc9:	jb     107cbf7 <check_input_run+0xfee7>
 107cbcb:	mov    %rcx,%rsi
 107cbce:	sub    %rdi,%rsi
 107cbd1:	mov    0x10(%rsp),%rdi
 107cbd6:	mov    0x10(%rdi),%rdi
 107cbda:	sub    %rsi,%rdi
 107cbdd:	setb   %r8b
 107cbe1:	cmp    0x78(%rsp),%rdi
 107cbe6:	setbe  %dil
 107cbea:	or     %r8b,%dil
 107cbed:	cmp    $0x1,%dil
 107cbf1:	jne    107cc78 <check_input_run+0xff68>
 107cbf7:	mov    0x18(%rsp),%rdi
 107cbfc:	mov    0x10(%rsp),%rsi
 107cc01:	mov    0x20(%rsp),%r12
 107cc06:	mov    0x40(%rsp),%rax
 107cc0b:	mov    0x30(%rsp),%r9
 107cc10:	jmp    106d605 <check_input_run+0x8f5>
 107cc15:	mov    0x18(%r10),%r8
 107cc19:	mov    (%r8,%r11,4),%r8d
 107cc1d:	and    $0x7,%r9d
 107cc21:	lea    (%r9,%r8,8),%r8d
 107cc25:	mov    0x0(%r13,%rsi,4),%esi
 107cc2a:	mov    0x178(%rsp),%rcx
 107cc32:	lea    (%rsi,%rsi,4),%rsi
 107cc36:	mov    %r8d,0x8(%rcx,%rsi,8)
 107cc3b:	cmpq   $0x0,0x140(%rsp)
 107cc44:	je     107d0d9 <check_input_run+0x103c9>
 107cc4a:	cmpl   $0x0,0xa0(%rsp)
 107cc52:	je     107d0d9 <check_input_run+0x103c9>
 107cc58:	mov    0xa0(%rsp),%r8
 107cc60:	mov    %r8d,%esi
 107cc63:	and    $0x7,%esi
 107cc66:	cmp    $0x8,%r8d
 107cc6a:	jae    107cee9 <check_input_run+0x101d9>
 107cc70:	xor    %r8d,%r8d
 107cc73:	jmp    107d07d <check_input_run+0x1036d>
 107cc78:	mov    0x10(%rsp),%rdi
 107cc7d:	mov    0x18(%rsp),%r8
 107cc82:	add    %rdx,%rsi
 107cc85:	mov    %rsi,0x8(%rdi)
 107cc89:	lea    0x2a0(%r8),%rdi
 107cc90:	mov    %rcx,0x2a0(%r8)
 107cc97:	mov    %rdi,0x118(%rsp)
 107cc9f:	test   %rcx,%rcx
 107cca2:	je     107d10e <check_input_run+0x103fe>
 107cca8:	mov    0x10(%rsp),%rcx
 107ccad:	mov    (%rcx),%rdi
 107ccb0:	mov    0x8(%rcx),%rsi
 107ccb4:	lea    0x7(%rsi,%rdi,1),%rcx
 107ccb9:	add    %rdi,%rsi
 107ccbc:	and    $0xfffffffffffffff8,%rcx
 107ccc0:	cmp    %rsi,%rcx
 107ccc3:	jb     107d10e <check_input_run+0x103fe>
 107ccc9:	mov    %rcx,%rsi
 107cccc:	sub    %rdi,%rsi
 107cccf:	mov    0x10(%rsp),%rdi
 107ccd4:	mov    0x10(%rdi),%rdi
 107ccd8:	sub    %rsi,%rdi
 107ccdb:	jb     107d10e <check_input_run+0x103fe>
 107cce1:	cmp    %rdi,%rax
 107cce4:	ja     107d10e <check_input_run+0x103fe>
 107ccea:	mov    0x10(%rsp),%rdi
 107ccef:	mov    0x18(%rsp),%r8
 107ccf4:	add    %rax,%rsi
 107ccf7:	mov    %rsi,0x8(%rdi)
 107ccfb:	lea    0x2a8(%r8),%rdi
 107cd02:	mov    %rcx,0x2a8(%r8)
 107cd09:	mov    %rdi,0x150(%rsp)
 107cd11:	test   %rcx,%rcx
 107cd14:	je     107d12c <check_input_run+0x1041c>
 107cd1a:	mov    0x10(%rsp),%rcx
 107cd1f:	mov    (%rcx),%rdi
 107cd22:	mov    0x8(%rcx),%rsi
 107cd26:	lea    0x7(%rsi,%rdi,1),%rcx
 107cd2b:	add    %rdi,%rsi
 107cd2e:	and    $0xfffffffffffffff8,%rcx
 107cd32:	cmp    %rsi,%rcx
 107cd35:	jb     107d12c <check_input_run+0x1041c>
 107cd3b:	mov    %rcx,%rsi
 107cd3e:	sub    %rdi,%rsi
 107cd41:	mov    0x10(%rsp),%rdi
 107cd46:	mov    0x10(%rdi),%rdi
 107cd4a:	sub    %rsi,%rdi
 107cd4d:	jb     107d12c <check_input_run+0x1041c>
 107cd53:	cmp    %rdi,%rax
 107cd56:	ja     107d12c <check_input_run+0x1041c>
 107cd5c:	mov    0x10(%rsp),%rdi
 107cd61:	mov    0x18(%rsp),%r8
 107cd66:	add    %rax,%rsi
 107cd69:	mov    %rsi,0x8(%rdi)
 107cd6d:	lea    0x2b0(%r8),%rdi
 107cd74:	mov    %rcx,0x2b0(%r8)
 107cd7b:	mov    %rdi,0x260(%rsp)
 107cd83:	test   %rcx,%rcx
 107cd86:	je     107d14a <check_input_run+0x1043a>
 107cd8c:	mov    0x10(%rsp),%rcx
 107cd91:	mov    (%rcx),%rdi
 107cd94:	mov    0x8(%rcx),%rsi
 107cd98:	lea    0x7(%rsi,%rdi,1),%rcx
 107cd9d:	add    %rdi,%rsi
 107cda0:	and    $0xfffffffffffffff8,%rcx
 107cda4:	cmp    %rsi,%rcx
 107cda7:	jb     107d14a <check_input_run+0x1043a>
 107cdad:	mov    %rcx,%rsi
 107cdb0:	sub    %rdi,%rsi
 107cdb3:	mov    0x10(%rsp),%rdi
 107cdb8:	mov    0x10(%rdi),%rdi
 107cdbc:	sub    %rsi,%rdi
 107cdbf:	jb     107d14a <check_input_run+0x1043a>
 107cdc5:	cmp    %rdi,%rax
 107cdc8:	ja     107d14a <check_input_run+0x1043a>
 107cdce:	mov    0x10(%rsp),%rdi
 107cdd3:	mov    0x18(%rsp),%r8
 107cdd8:	add    %rax,%rsi
 107cddb:	mov    %rsi,0x8(%rdi)
 107cddf:	lea    0x2b8(%r8),%rdi
 107cde6:	mov    %rcx,0x2b8(%r8)
 107cded:	mov    %rdi,0x258(%rsp)
 107cdf5:	test   %rcx,%rcx
 107cdf8:	je     107d168 <check_input_run+0x10458>
 107cdfe:	mov    0x10(%rsp),%rcx
 107ce03:	mov    (%rcx),%rdi
 107ce06:	mov    0x8(%rcx),%rsi
 107ce0a:	lea    0x7(%rsi,%rdi,1),%rcx
 107ce0f:	add    %rdi,%rsi
 107ce12:	and    $0xfffffffffffffff8,%rcx
 107ce16:	cmp    %rsi,%rcx
 107ce19:	jb     107d168 <check_input_run+0x10458>
 107ce1f:	mov    %rcx,%rsi
 107ce22:	sub    %rdi,%rsi
 107ce25:	mov    0x10(%rsp),%rdi
 107ce2a:	mov    0x10(%rdi),%rdi
 107ce2e:	sub    %rsi,%rdi
 107ce31:	jb     107d168 <check_input_run+0x10458>
 107ce37:	cmp    %rdi,%rax
 107ce3a:	ja     107d168 <check_input_run+0x10458>
 107ce40:	mov    0x10(%rsp),%rdi
 107ce45:	mov    0x18(%rsp),%r8
 107ce4a:	add    %rax,%rsi
 107ce4d:	mov    %rsi,0x8(%rdi)
 107ce51:	lea    0x2c0(%r8),%rdi
 107ce58:	mov    %rcx,0x2c0(%r8)
 107ce5f:	mov    %rdi,0x148(%rsp)
 107ce67:	test   %rcx,%rcx
 107ce6a:	je     107ceb5 <check_input_run+0x101a5>
 107ce6c:	mov    0x10(%rsp),%rcx
 107ce71:	mov    (%rcx),%rdi
 107ce74:	mov    0x8(%rcx),%rsi
 107ce78:	lea    0x7(%rsi,%rdi,1),%rcx
 107ce7d:	add    %rdi,%rsi
 107ce80:	and    $0xfffffffffffffff8,%rcx
 107ce84:	cmp    %rsi,%rcx
 107ce87:	jb     107ceb5 <check_input_run+0x101a5>
 107ce89:	mov    %rcx,%rsi
 107ce8c:	sub    %rdi,%rsi
 107ce8f:	mov    0x10(%rsp),%rdi
 107ce94:	mov    0x10(%rdi),%rdi
 107ce98:	sub    %rsi,%rdi
 107ce9b:	setb   %r8b
 107ce9f:	cmp    0x78(%rsp),%rdi
 107cea4:	setbe  %dil
 107cea8:	or     %r8b,%dil
 107ceab:	cmp    $0x1,%dil
 107ceaf:	jne    107d186 <check_input_run+0x10476>
 107ceb5:	mov    0x18(%rsp),%rdi
 107ceba:	mov    0x10(%rsp),%rsi
 107cebf:	mov    0x20(%rsp),%r12
 107cec4:	mov    0x40(%rsp),%rax
 107cec9:	mov    0x30(%rsp),%r9
 107cece:	movq   $0x0,0x2c8(%rdi)
 107ced9:	movq   $0x0,0x2d0(%rdi)
 107cee4:	jmp    106d69d <check_input_run+0x98d>
 107cee9:	mov    0x110(%rsp),%r8
 107cef1:	mov    0xc0(%rsp),%rbp
 107cef9:	mov    0x1f8(%rsp),%rcx
 107cf01:	xor    %r11d,%r11d
 107cf04:	lea    0x1c(%r8),%r9
 107cf08:	mov    0xa0(%rsp),%r8
 107cf10:	shr    $0x3,%r8d
 107cf14:	shl    $0x6,%r8
 107cf18:	lea    (%r8,%r8,2),%r10
 107cf1c:	xor    %r8d,%r8d
 107cf1f:	mov    0x310(%rbp),%r15
 107cf26:	mov    -0x1c(%r9,%r8,4),%r14d
 107cf2b:	mov    0x10(%r15,%r11,1),%r12
 107cf30:	lea    (%r14,%r14,2),%r14
 107cf34:	mov    %r12,0x10(%rcx,%r14,8)
 107cf39:	vmovups (%r15,%r11,1),%xmm0
 107cf3f:	vmovups %xmm0,(%rcx,%r14,8)
 107cf45:	mov    0x310(%rbp),%r15
 107cf4c:	mov    -0x18(%r9,%r8,4),%r14d
 107cf51:	mov    0x28(%r15,%r11,1),%r12
 107cf56:	lea    (%r14,%r14,2),%r14
 107cf5a:	mov    %r12,0x10(%rcx,%r14,8)
 107cf5f:	vmovups 0x18(%r15,%r11,1),%xmm0
 107cf66:	vmovups %xmm0,(%rcx,%r14,8)
 107cf6c:	mov    0x310(%rbp),%r15
 107cf73:	mov    -0x14(%r9,%r8,4),%r14d
 107cf78:	mov    0x40(%r15,%r11,1),%r12
 107cf7d:	lea    (%r14,%r14,2),%r14
 107cf81:	mov    %r12,0x10(%rcx,%r14,8)
 107cf86:	vmovups 0x30(%r15,%r11,1),%xmm0
 107cf8d:	vmovups %xmm0,(%rcx,%r14,8)
 107cf93:	mov    0x310(%rbp),%r15
 107cf9a:	mov    -0x10(%r9,%r8,4),%r14d
 107cf9f:	mov    0x58(%r15,%r11,1),%r12
 107cfa4:	lea    (%r14,%r14,2),%r14
 107cfa8:	mov    %r12,0x10(%rcx,%r14,8)
 107cfad:	vmovups 0x48(%r15,%r11,1),%xmm0
 107cfb4:	vmovups %xmm0,(%rcx,%r14,8)
 107cfba:	mov    0x310(%rbp),%r15
 107cfc1:	mov    -0xc(%r9,%r8,4),%r14d
 107cfc6:	mov    0x70(%r15,%r11,1),%r12
 107cfcb:	lea    (%r14,%r14,2),%r14
 107cfcf:	mov    %r12,0x10(%rcx,%r14,8)
 107cfd4:	vmovups 0x60(%r15,%r11,1),%xmm0
 107cfdb:	vmovups %xmm0,(%rcx,%r14,8)
 107cfe1:	mov    0x310(%rbp),%r15
 107cfe8:	mov    -0x8(%r9,%r8,4),%r14d
 107cfed:	mov    0x88(%r15,%r11,1),%r12
 107cff5:	lea    (%r14,%r14,2),%r14
 107cff9:	mov    %r12,0x10(%rcx,%r14,8)
 107cffe:	vmovups 0x78(%r15,%r11,1),%xmm0
 107d005:	vmovups %xmm0,(%rcx,%r14,8)
 107d00b:	mov    0x310(%rbp),%r15
 107d012:	mov    -0x4(%r9,%r8,4),%r14d
 107d017:	mov    0xa0(%r15,%r11,1),%r12
 107d01f:	lea    (%r14,%r14,2),%r14
 107d023:	mov    %r12,0x10(%rcx,%r14,8)
 107d028:	vmovups 0x90(%r15,%r11,1),%xmm0
 107d032:	vmovups %xmm0,(%rcx,%r14,8)
 107d038:	mov    0x310(%rbp),%r15
 107d03f:	mov    (%r9,%r8,4),%r14d
 107d043:	add    $0x8,%r8
 107d047:	mov    0xb8(%r15,%r11,1),%r12
 107d04f:	lea    (%r14,%r14,2),%r14
 107d053:	mov    %r12,0x10(%rcx,%r14,8)
 107d058:	vmovdqu 0xa8(%r15,%r11,1),%xmm0
 107d062:	add    $0xc0,%r11
 107d069:	vmovdqu %xmm0,(%rcx,%r14,8)
 107d06f:	cmp    %r11,%r10
 107d072:	jne    107cf1f <check_input_run+0x1020f>
 107d078:	test   %rsi,%rsi
 107d07b:	je     107d0d9 <check_input_run+0x103c9>
 107d07d:	mov    0x110(%rsp),%r10
 107d085:	mov    0x1f8(%rsp),%rcx
 107d08d:	lea    0x0(,%r8,8),%r9
 107d095:	lea    (%r9,%r9,2),%r9
 107d099:	lea    (%r10,%r8,4),%r8
 107d09d:	xor    %r10d,%r10d
 107d0a0:	mov    0xc0(%rsp),%r14
 107d0a8:	mov    (%r8,%r10,4),%r11d
 107d0ac:	inc    %r10
 107d0af:	mov    0x310(%r14),%r14
 107d0b6:	lea    (%r11,%r11,2),%r11
 107d0ba:	mov    0x10(%r14,%r9,1),%r15
 107d0bf:	mov    %r15,0x10(%rcx,%r11,8)
 107d0c4:	vmovdqu (%r14,%r9,1),%xmm0
 107d0ca:	add    $0x18,%r9
 107d0ce:	vmovdqu %xmm0,(%rcx,%r11,8)
 107d0d4:	cmp    %r10,%rsi
 107d0d7:	jne    107d0a0 <check_input_run+0x10390>
 107d0d9:	cmpq   $0x0,0x140(%rsp)
 107d0e2:	je     107d90d <check_input_run+0x10bfd>
 107d0e8:	cmpl   $0x0,0xd8(%rsp)
 107d0f0:	je     107d90d <check_input_run+0x10bfd>
 107d0f6:	xor    %r8d,%r8d
 107d0f9:	cmpl   $0x1,0xd8(%rsp)
 107d101:	jne    107d215 <check_input_run+0x10505>
 107d107:	xor    %esi,%esi
 107d109:	jmp    107d39c <check_input_run+0x1068c>
 107d10e:	mov    0x18(%rsp),%rdi
 107d113:	mov    0x10(%rsp),%rsi
 107d118:	mov    0x20(%rsp),%r12
 107d11d:	mov    0x40(%rsp),%rax
 107d122:	mov    0x30(%rsp),%r9
 107d127:	jmp    106d61f <check_input_run+0x90f>
 107d12c:	mov    0x18(%rsp),%rdi
 107d131:	mov    0x10(%rsp),%rsi
 107d136:	mov    0x20(%rsp),%r12
 107d13b:	mov    0x40(%rsp),%rax
 107d140:	mov    0x30(%rsp),%r9
 107d145:	jmp    106d639 <check_input_run+0x929>
 107d14a:	mov    0x18(%rsp),%rdi
 107d14f:	mov    0x10(%rsp),%rsi
 107d154:	mov    0x20(%rsp),%r12
 107d159:	mov    0x40(%rsp),%rax
 107d15e:	mov    0x30(%rsp),%r9
 107d163:	jmp    106d653 <check_input_run+0x943>
 107d168:	mov    0x18(%rsp),%rdi
 107d16d:	mov    0x10(%rsp),%rsi
 107d172:	mov    0x20(%rsp),%r12
 107d177:	mov    0x40(%rsp),%rax
 107d17c:	mov    0x30(%rsp),%r9
 107d181:	jmp    106d66d <check_input_run+0x95d>
 107d186:	mov    0x10(%rsp),%rdi
 107d18b:	add    %rdx,%rsi
 107d18e:	mov    %rsi,0x8(%rdi)
 107d192:	mov    0x18(%rsp),%rdi
 107d197:	mov    %rcx,0x2c8(%rdi)
 107d19e:	test   %rcx,%rcx
 107d1a1:	je     107d1ec <check_input_run+0x104dc>
 107d1a3:	mov    0x10(%rsp),%rcx
 107d1a8:	mov    (%rcx),%rdi
 107d1ab:	mov    0x8(%rcx),%rsi
 107d1af:	lea    0x7(%rsi,%rdi,1),%rcx
 107d1b4:	add    %rdi,%rsi
 107d1b7:	and    $0xfffffffffffffff8,%rcx
 107d1bb:	cmp    %rsi,%rcx
 107d1be:	jb     107d1ec <check_input_run+0x104dc>
 107d1c0:	mov    %rcx,%rsi
 107d1c3:	sub    %rdi,%rsi
 107d1c6:	mov    0x10(%rsp),%rdi
 107d1cb:	mov    0x10(%rdi),%rdi
 107d1cf:	sub    %rsi,%rdi
 107d1d2:	setb   %r8b
 107d1d6:	cmp    0x78(%rsp),%rdi
 107d1db:	setbe  %dil
 107d1df:	or     %r8b,%dil
 107d1e2:	cmp    $0x1,%dil
 107d1e6:	jne    107d42d <check_input_run+0x1071d>
 107d1ec:	mov    0x18(%rsp),%rdi
 107d1f1:	mov    0x10(%rsp),%rsi
 107d1f6:	mov    0x20(%rsp),%r12
 107d1fb:	mov    0x40(%rsp),%rax
 107d200:	mov    0x30(%rsp),%r9
 107d205:	movq   $0x0,0x2d0(%rdi)
 107d210:	jmp    106d69d <check_input_run+0x98d>
 107d215:	mov    0x160(%rsp),%rdx
 107d21d:	mov    0xd8(%rsp),%r9
 107d225:	and    $0xfffffffe,%r9d
 107d229:	xor    %esi,%esi
 107d22b:	mov    0xc0(%rsp),%r15
 107d233:	mov    0x88(%rsp),%rcx
 107d23b:	lea    0x0(,%rsi,4),%r10
 107d243:	lea    (%r10,%r10,8),%r10
 107d247:	mov    0x328(%r15),%r14
 107d24e:	mov    (%rcx,%rsi,4),%r11d
 107d252:	mov    0x160(%rsp),%rcx
 107d25a:	mov    0x20(%r14,%r10,1),%ebp
 107d25f:	lea    (%r11,%r11,8),%r11
 107d263:	mov    %ebp,0x20(%rcx,%r11,4)
 107d268:	vmovdqu (%r14,%r10,1),%ymm0
 107d26e:	vmovdqu %ymm0,(%rcx,%r11,4)
 107d274:	mov    0x328(%r15),%r11
 107d27b:	mov    0x4(%r11,%r10,1),%r10d
 107d280:	mov    $0x0,%r11d
 107d286:	test   %r10d,%r10d
 107d289:	je     107d2c3 <check_input_run+0x105b3>
 107d28b:	mov    %r10d,%r11d
 107d28e:	shr    $0x3,%r11d
 107d292:	cmpq   $0x0,0x48(%rsp)
 107d298:	je     107d2bb <check_input_run+0x105ab>
 107d29a:	mov    0x48(%rsp),%r14
 107d29f:	mov    %r11d,%r15d
 107d2a2:	sub    0x10(%r14),%r15d
 107d2a6:	jae    107d2b3 <check_input_run+0x105a3>
 107d2a8:	mov    0x8(%r14),%r14
 107d2ac:	test   %r14,%r14
 107d2af:	jne    107d29f <check_input_run+0x1058f>
 107d2b1:	jmp    107d2bb <check_input_run+0x105ab>
 107d2b3:	mov    0x18(%r14),%r11
 107d2b7:	mov    (%r11,%r15,4),%r11d
 107d2bb:	and    $0x7,%r10d
 107d2bf:	lea    (%r10,%r11,8),%r11d
 107d2c3:	mov    0x88(%rsp),%rcx
 107d2cb:	mov    0xc0(%rsp),%r15
 107d2d3:	mov    (%rcx,%rsi,4),%r10d
 107d2d7:	lea    (%r10,%r10,8),%r10
 107d2db:	mov    %r11d,0x4(%rdx,%r10,4)
 107d2e0:	lea    0x4(,%rsi,4),%r10
 107d2e8:	mov    0x328(%r15),%r14
 107d2ef:	mov    0x4(%rcx,%rsi,4),%r11d
 107d2f4:	lea    (%r10,%r10,8),%r10
 107d2f8:	mov    0x20(%r14,%r10,1),%ebp
 107d2fd:	lea    (%r11,%r11,8),%r11
 107d301:	mov    %ebp,0x20(%rdx,%r11,4)
 107d306:	vmovdqu (%r14,%r10,1),%ymm0
 107d30c:	vmovdqu %ymm0,(%rdx,%r11,4)
 107d312:	mov    0x328(%r15),%r11
 107d319:	mov    0x4(%r11,%r10,1),%r10d
 107d31e:	test   %r10d,%r10d
 107d321:	je     107d34b <check_input_run+0x1063b>
 107d323:	mov    %r10d,%r11d
 107d326:	shr    $0x3,%r11d
 107d32a:	cmpq   $0x0,0x48(%rsp)
 107d330:	je     107d358 <check_input_run+0x10648>
 107d332:	mov    0x48(%rsp),%r14
 107d337:	mov    %r11d,%r15d
 107d33a:	sub    0x10(%r14),%r15d
 107d33e:	jae    107d350 <check_input_run+0x10640>
 107d340:	mov    0x8(%r14),%r14
 107d344:	test   %r14,%r14
 107d347:	jne    107d337 <check_input_run+0x10627>
 107d349:	jmp    107d358 <check_input_run+0x10648>
 107d34b:	xor    %r10d,%r10d
 107d34e:	jmp    107d360 <check_input_run+0x10650>
 107d350:	mov    0x18(%r14),%r11
 107d354:	mov    (%r11,%r15,4),%r11d
 107d358:	and    $0x7,%r10d
 107d35c:	lea    (%r10,%r11,8),%r10d
 107d360:	mov    0x88(%rsp),%rcx
 107d368:	lea    0x1(%rsi),%r11
 107d36c:	add    $0x2,%rsi
 107d370:	mov    (%rcx,%r11,4),%r11d
 107d374:	mov    0x160(%rsp),%rcx
 107d37c:	lea    (%r11,%r11,8),%r11
 107d380:	mov    %r10d,0x4(%rcx,%r11,4)
 107d385:	cmp    %r9,%rsi
 107d388:	jne    107d22b <check_input_run+0x1051b>
 107d38e:	testb  $0x1,0xd8(%rsp)
 107d396:	je     107d90d <check_input_run+0x10bfd>
 107d39c:	mov    0xc0(%rsp),%r14
 107d3a4:	mov    0x88(%rsp),%rcx
 107d3ac:	lea    0x0(,%rsi,4),%r9
 107d3b4:	lea    (%r9,%r9,8),%r9
 107d3b8:	mov    0x328(%r14),%r11
 107d3bf:	mov    (%rcx,%rsi,4),%r10d
 107d3c3:	mov    0x160(%rsp),%rcx
 107d3cb:	mov    0x20(%r11,%r9,1),%ebp
 107d3d0:	lea    (%r10,%r10,8),%r10
 107d3d4:	mov    %ebp,0x20(%rcx,%r10,4)
 107d3d9:	vmovdqu (%r11,%r9,1),%ymm0
 107d3df:	vmovdqu %ymm0,(%rcx,%r10,4)
 107d3e5:	mov    0x328(%r14),%r10
 107d3ec:	mov    0x4(%r10,%r9,1),%r9d
 107d3f1:	test   %r9d,%r9d
 107d3f4:	je     107d8f1 <check_input_run+0x10be1>
 107d3fa:	mov    %r9d,%r8d
 107d3fd:	shr    $0x3,%r8d
 107d401:	cmpq   $0x0,0x48(%rsp)
 107d407:	je     107d8e9 <check_input_run+0x10bd9>
 107d40d:	mov    0x48(%rsp),%r10
 107d412:	mov    %r8d,%r11d
 107d415:	sub    0x10(%r10),%r11d
 107d419:	jae    107d8e1 <check_input_run+0x10bd1>
 107d41f:	mov    0x8(%r10),%r10
 107d423:	test   %r10,%r10
 107d426:	jne    107d412 <check_input_run+0x10702>
 107d428:	jmp    107d8e9 <check_input_run+0x10bd9>
 107d42d:	mov    0x10(%rsp),%rdi
 107d432:	add    %rdx,%rsi
 107d435:	mov    %rsi,0x8(%rdi)
 107d439:	mov    0x18(%rsp),%rdi
 107d43e:	mov    %rcx,0x2d0(%rdi)
 107d445:	test   %rcx,%rcx
 107d448:	je     107d944 <check_input_run+0x10c34>
 107d44e:	mov    0x10(%rsp),%rcx
 107d453:	mov    (%rcx),%rdi
 107d456:	mov    0x8(%rcx),%rsi
 107d45a:	lea    0x7(%rsi,%rdi,1),%rcx
 107d45f:	add    %rdi,%rsi
 107d462:	and    $0xfffffffffffffff8,%rcx
 107d466:	cmp    %rsi,%rcx
 107d469:	jb     107d944 <check_input_run+0x10c34>
 107d46f:	mov    %rcx,%rsi
 107d472:	sub    %rdi,%rsi
 107d475:	mov    0x10(%rsp),%rdi
 107d47a:	mov    0x10(%rdi),%rdi
 107d47e:	sub    %rsi,%rdi
 107d481:	jb     107d944 <check_input_run+0x10c34>
 107d487:	cmp    %rdi,%rax
 107d48a:	ja     107d944 <check_input_run+0x10c34>
 107d490:	mov    0x10(%rsp),%rdi
 107d495:	mov    0x18(%rsp),%r8
 107d49a:	add    %rax,%rsi
 107d49d:	mov    %rsi,0x8(%rdi)
 107d4a1:	lea    0x2d8(%r8),%rdi
 107d4a8:	mov    %rcx,0x2d8(%r8)
 107d4af:	mov    %rdi,0x80(%rsp)
 107d4b7:	test   %rcx,%rcx
 107d4ba:	je     107d962 <check_input_run+0x10c52>
 107d4c0:	mov    0x10(%rsp),%rcx
 107d4c5:	mov    (%rcx),%rdi
 107d4c8:	mov    0x8(%rcx),%rsi
 107d4cc:	lea    0x7(%rsi,%rdi,1),%rcx
 107d4d1:	add    %rdi,%rsi
 107d4d4:	and    $0xfffffffffffffff8,%rcx
 107d4d8:	cmp    %rsi,%rcx
 107d4db:	jb     107d962 <check_input_run+0x10c52>
 107d4e1:	mov    %rcx,%rsi
 107d4e4:	sub    %rdi,%rsi
 107d4e7:	mov    0x10(%rsp),%rdi
 107d4ec:	mov    0x10(%rdi),%rdi
 107d4f0:	sub    %rsi,%rdi
 107d4f3:	jb     107d962 <check_input_run+0x10c52>
 107d4f9:	cmp    %rdi,%rax
 107d4fc:	ja     107d962 <check_input_run+0x10c52>
 107d502:	mov    0x10(%rsp),%rdi
 107d507:	mov    0x18(%rsp),%r8
 107d50c:	add    %rax,%rsi
 107d50f:	mov    %rsi,0x8(%rdi)
 107d513:	lea    0x2e0(%r8),%rdi
 107d51a:	mov    %rcx,0x2e0(%r8)
 107d521:	mov    %rdi,0xb0(%rsp)
 107d529:	test   %rcx,%rcx
 107d52c:	je     107d988 <check_input_run+0x10c78>
 107d532:	mov    0x10(%rsp),%rcx
 107d537:	mov    (%rcx),%rdi
 107d53a:	mov    0x8(%rcx),%rsi
 107d53e:	lea    0x7(%rsi,%rdi,1),%rcx
 107d543:	add    %rdi,%rsi
 107d546:	and    $0xfffffffffffffff8,%rcx
 107d54a:	cmp    %rsi,%rcx
 107d54d:	jb     107d988 <check_input_run+0x10c78>
 107d553:	mov    %rcx,%rsi
 107d556:	sub    %rdi,%rsi
 107d559:	mov    0x10(%rsp),%rdi
 107d55e:	mov    0x10(%rdi),%rdi
 107d562:	sub    %rsi,%rdi
 107d565:	jb     107d988 <check_input_run+0x10c78>
 107d56b:	cmp    %rdi,%rax
 107d56e:	ja     107d988 <check_input_run+0x10c78>
 107d574:	mov    0x10(%rsp),%rdi
 107d579:	add    %rax,%rsi
 107d57c:	mov    %rsi,0x8(%rdi)
 107d580:	mov    0x18(%rsp),%rdi
 107d585:	mov    %rcx,0x2e8(%rdi)
 107d58c:	test   %rcx,%rcx
 107d58f:	je     107d9b6 <check_input_run+0x10ca6>
 107d595:	mov    0x10(%rsp),%rcx
 107d59a:	mov    (%rcx),%rdi
 107d59d:	mov    0x8(%rcx),%rsi
 107d5a1:	lea    0x7(%rsi,%rdi,1),%rcx
 107d5a6:	add    %rdi,%rsi
 107d5a9:	and    $0xfffffffffffffff8,%rcx
 107d5ad:	cmp    %rsi,%rcx
 107d5b0:	jb     107d9b6 <check_input_run+0x10ca6>
 107d5b6:	mov    %rcx,%rsi
 107d5b9:	sub    %rdi,%rsi
 107d5bc:	mov    0x10(%rsp),%rdi
 107d5c1:	mov    0x10(%rdi),%rdi
 107d5c5:	sub    %rsi,%rdi
 107d5c8:	jb     107d9b6 <check_input_run+0x10ca6>
 107d5ce:	cmp    %rdi,%rax
 107d5d1:	ja     107d9b6 <check_input_run+0x10ca6>
 107d5d7:	mov    0x10(%rsp),%rdi
 107d5dc:	mov    0x18(%rsp),%r8
 107d5e1:	add    %rax,%rsi
 107d5e4:	mov    %rsi,0x8(%rdi)
 107d5e8:	lea    0x2f0(%r8),%rdi
 107d5ef:	mov    %rcx,0x2f0(%r8)
 107d5f6:	mov    %rdi,0xf8(%rsp)
 107d5fe:	test   %rcx,%rcx
 107d601:	je     107d9e4 <check_input_run+0x10cd4>
 107d607:	mov    0x10(%rsp),%rcx
 107d60c:	mov    (%rcx),%rdi
 107d60f:	mov    0x8(%rcx),%rsi
 107d613:	lea    0x7(%rsi,%rdi,1),%rcx
 107d618:	add    %rdi,%rsi
 107d61b:	and    $0xfffffffffffffff8,%rcx
 107d61f:	cmp    %rsi,%rcx
 107d622:	jb     107d9e4 <check_input_run+0x10cd4>
 107d628:	mov    %rcx,%rsi
 107d62b:	sub    %rdi,%rsi
 107d62e:	mov    0x10(%rsp),%rdi
 107d633:	mov    0x10(%rdi),%rdi
 107d637:	sub    %rsi,%rdi
 107d63a:	jb     107d9e4 <check_input_run+0x10cd4>
 107d640:	cmp    %rdi,%rax
 107d643:	ja     107d9e4 <check_input_run+0x10cd4>
 107d649:	mov    0x10(%rsp),%rdi
 107d64e:	mov    0x18(%rsp),%r8
 107d653:	add    %rax,%rsi
 107d656:	mov    %rsi,0x8(%rdi)
 107d65a:	lea    0x2f8(%r8),%rdi
 107d661:	mov    %rcx,0x2f8(%r8)
 107d668:	mov    %rdi,0xb8(%rsp)
 107d670:	test   %rcx,%rcx
 107d673:	je     107da1a <check_input_run+0x10d0a>
 107d679:	mov    0x10(%rsp),%rcx
 107d67e:	mov    (%rcx),%rdi
 107d681:	mov    0x8(%rcx),%rsi
 107d685:	lea    0x7(%rsi,%rdi,1),%rcx
 107d68a:	add    %rdi,%rsi
 107d68d:	and    $0xfffffffffffffff8,%rcx
 107d691:	cmp    %rsi,%rcx
 107d694:	jb     107da1a <check_input_run+0x10d0a>
 107d69a:	mov    %rcx,%rsi
 107d69d:	sub    %rdi,%rsi
 107d6a0:	mov    0x10(%rsp),%rdi
 107d6a5:	mov    0x10(%rdi),%rdi
 107d6a9:	sub    %rsi,%rdi
 107d6ac:	jb     107da1a <check_input_run+0x10d0a>
 107d6b2:	cmp    %rdi,%rax
 107d6b5:	ja     107da1a <check_input_run+0x10d0a>
 107d6bb:	mov    0x10(%rsp),%rdi
 107d6c0:	mov    0x18(%rsp),%r8
 107d6c5:	add    %rax,%rsi
 107d6c8:	mov    %rsi,0x8(%rdi)
 107d6cc:	lea    0x300(%r8),%rdi
 107d6d3:	mov    %rcx,0x300(%r8)
 107d6da:	mov    %rdi,0xe0(%rsp)
 107d6e2:	test   %rcx,%rcx
 107d6e5:	je     107da58 <check_input_run+0x10d48>
 107d6eb:	mov    0x10(%rsp),%rcx
 107d6f0:	mov    (%rcx),%rdi
 107d6f3:	mov    0x8(%rcx),%rsi
 107d6f7:	lea    0x7(%rsi,%rdi,1),%rcx
 107d6fc:	add    %rdi,%rsi
 107d6ff:	and    $0xfffffffffffffff8,%rcx
 107d703:	cmp    %rsi,%rcx
 107d706:	jb     107da58 <check_input_run+0x10d48>
 107d70c:	mov    %rcx,%rsi
 107d70f:	sub    %rdi,%rsi
 107d712:	mov    0x10(%rsp),%rdi
 107d717:	mov    0x10(%rdi),%rdi
 107d71b:	sub    %rsi,%rdi
 107d71e:	jb     107da58 <check_input_run+0x10d48>
 107d724:	cmp    %rdi,%rax
 107d727:	ja     107da58 <check_input_run+0x10d48>
 107d72d:	mov    0x10(%rsp),%rdi
 107d732:	mov    0x18(%rsp),%r8
 107d737:	add    %rax,%rsi
 107d73a:	mov    %rsi,0x8(%rdi)
 107d73e:	lea    0x308(%r8),%rdi
 107d745:	mov    %rcx,0x308(%r8)
 107d74c:	mov    %rdi,0x108(%rsp)
 107d754:	test   %rcx,%rcx
 107d757:	je     107da9e <check_input_run+0x10d8e>
 107d75d:	mov    0x10(%rsp),%rcx
 107d762:	mov    (%rcx),%rdi
 107d765:	mov    0x8(%rcx),%rsi
 107d769:	lea    0x7(%rsi,%rdi,1),%rcx
 107d76e:	add    %rdi,%rsi
 107d771:	and    $0xfffffffffffffff8,%rcx
 107d775:	cmp    %rsi,%rcx
 107d778:	jb     107da9e <check_input_run+0x10d8e>
 107d77e:	mov    %rcx,%rsi
 107d781:	sub    %rdi,%rsi
 107d784:	mov    0x10(%rsp),%rdi
 107d789:	mov    0x10(%rdi),%rdi
 107d78d:	sub    %rsi,%rdi
 107d790:	jb     107da9e <check_input_run+0x10d8e>
 107d796:	mov    0x78(%rsp),%r8
 107d79b:	lea    (%r8,%r8,2),%r8
 107d79f:	lea    0x18(,%r8,8),%r8
 107d7a7:	cmp    %rdi,%r8
 107d7aa:	ja     107da9e <check_input_run+0x10d8e>
 107d7b0:	mov    0x10(%rsp),%rdi
 107d7b5:	add    %r8,%rsi
 107d7b8:	mov    %rsi,0x8(%rdi)
 107d7bc:	mov    0x18(%rsp),%rdi
 107d7c1:	mov    %rcx,0x310(%rdi)
 107d7c8:	test   %rcx,%rcx
 107d7cb:	je     107daec <check_input_run+0x10ddc>
 107d7d1:	mov    0x10(%rsp),%rcx
 107d7d6:	mov    (%rcx),%rdi
 107d7d9:	mov    0x8(%rcx),%rsi
 107d7dd:	lea    0x7(%rsi,%rdi,1),%rcx
 107d7e2:	add    %rdi,%rsi
 107d7e5:	and    $0xfffffffffffffff8,%rcx
 107d7e9:	cmp    %rsi,%rcx
 107d7ec:	jb     107daec <check_input_run+0x10ddc>
 107d7f2:	mov    %rcx,%rsi
 107d7f5:	sub    %rdi,%rsi
 107d7f8:	mov    0x10(%rsp),%rdi
 107d7fd:	mov    0x10(%rdi),%rdi
 107d801:	sub    %rsi,%rdi
 107d804:	jb     107daec <check_input_run+0x10ddc>
 107d80a:	cmp    %rdi,%rax
 107d80d:	ja     107daec <check_input_run+0x10ddc>
 107d813:	mov    0x10(%rsp),%rdi
 107d818:	mov    0x18(%rsp),%r8
 107d81d:	add    %rax,%rsi
 107d820:	mov    %rsi,0x8(%rdi)
 107d824:	lea    0x318(%r8),%rdi
 107d82b:	mov    %rcx,0x318(%r8)
 107d832:	mov    %rdi,0x128(%rsp)
 107d83a:	test   %rcx,%rcx
 107d83d:	je     107db3a <check_input_run+0x10e2a>
 107d843:	mov    0x10(%rsp),%rcx
 107d848:	mov    (%rcx),%rdi
 107d84b:	mov    0x8(%rcx),%rsi
 107d84f:	lea    0x7(%rsi,%rdi,1),%rcx
 107d854:	add    %rdi,%rsi
 107d857:	and    $0xfffffffffffffff8,%rcx
 107d85b:	cmp    %rsi,%rcx
 107d85e:	jb     107db3a <check_input_run+0x10e2a>
 107d864:	mov    %rcx,%rsi
 107d867:	sub    %rdi,%rsi
 107d86a:	mov    0x10(%rsp),%rdi
 107d86f:	mov    0x10(%rdi),%rdi
 107d873:	sub    %rsi,%rdi
 107d876:	jb     107db3a <check_input_run+0x10e2a>
 107d87c:	cmp    %rdi,%rax
 107d87f:	ja     107db3a <check_input_run+0x10e2a>
 107d885:	mov    0x10(%rsp),%r8
 107d88a:	mov    0x18(%rsp),%rdi
 107d88f:	add    %rax,%rsi
 107d892:	mov    $0x350,%eax
 107d897:	mov    %rsi,0x8(%r8)
 107d89b:	lea    0x348(%rdi),%rsi
 107d8a2:	mov    %rcx,0x348(%rdi)
 107d8a9:	mov    %rsi,0x120(%rsp)
 107d8b1:	test   %rcx,%rcx
 107d8b4:	je     107d8d7 <check_input_run+0x10bc7>
 107d8b6:	mov    0x10(%rsp),%rcx
 107d8bb:	mov    (%rcx),%rdi
 107d8be:	mov    0x8(%rcx),%rsi
 107d8c2:	lea    0x7(%rsi,%rdi,1),%rcx
 107d8c7:	add    %rdi,%rsi
 107d8ca:	and    $0xfffffffffffffff8,%rcx
 107d8ce:	cmp    %rsi,%rcx
 107d8d1:	jae    107db53 <check_input_run+0x10e43>
 107d8d7:	xor    %ebx,%ebx
 107d8d9:	xor    %r15d,%r15d
 107d8dc:	jmp    107dc18 <check_input_run+0x10f08>
 107d8e1:	mov    0x18(%r10),%r8
 107d8e5:	mov    (%r8,%r11,4),%r8d
 107d8e9:	and    $0x7,%r9d
 107d8ed:	lea    (%r9,%r8,8),%r8d
 107d8f1:	mov    0x88(%rsp),%rcx
 107d8f9:	mov    (%rcx,%rsi,4),%esi
 107d8fc:	mov    0x160(%rsp),%rcx
 107d904:	lea    (%rsi,%rsi,8),%rsi
 107d908:	mov    %r8d,0x4(%rcx,%rsi,4)
 107d90d:	cmpq   $0x0,0x140(%rsp)
 107d916:	je     107dec1 <check_input_run+0x111b1>
 107d91c:	cmpl   $0x0,0x70(%rsp)
 107d921:	je     107dec1 <check_input_run+0x111b1>
 107d927:	mov    0x70(%rsp),%r8
 107d92c:	mov    %r8d,%esi
 107d92f:	and    $0x7,%esi
 107d932:	cmp    $0x8,%r8d
 107d936:	jae    107dc31 <check_input_run+0x10f21>
 107d93c:	xor    %r8d,%r8d
 107d93f:	jmp    107de57 <check_input_run+0x11147>
 107d944:	mov    0x18(%rsp),%rdi
 107d949:	mov    0x10(%rsp),%rsi
 107d94e:	mov    0x20(%rsp),%r12
 107d953:	mov    0x40(%rsp),%rax
 107d958:	mov    0x30(%rsp),%r9
 107d95d:	jmp    106d69d <check_input_run+0x98d>
 107d962:	mov    0x18(%rsp),%rdi
 107d967:	mov    0x10(%rsp),%rsi
 107d96c:	mov    0x20(%rsp),%r12
 107d971:	mov    0x40(%rsp),%rax
 107d976:	mov    0x30(%rsp),%r9
 107d97b:	mov    0x80(%rsp),%rcx
 107d983:	jmp    106d6af <check_input_run+0x99f>
 107d988:	mov    0x18(%rsp),%rdi
 107d98d:	mov    0x10(%rsp),%rsi
 107d992:	mov    0x20(%rsp),%r12
 107d997:	mov    0x40(%rsp),%rax
 107d99c:	mov    0x30(%rsp),%r9
 107d9a1:	mov    0x80(%rsp),%rcx
 107d9a9:	mov    0xb0(%rsp),%rdx
 107d9b1:	jmp    106d6c1 <check_input_run+0x9b1>
 107d9b6:	mov    0x18(%rsp),%rdi
 107d9bb:	mov    0x10(%rsp),%rsi
 107d9c0:	mov    0x20(%rsp),%r12
 107d9c5:	mov    0x40(%rsp),%rax
 107d9ca:	mov    0x30(%rsp),%r9
 107d9cf:	mov    0x80(%rsp),%rcx
 107d9d7:	mov    0xb0(%rsp),%rdx
 107d9df:	jmp    106d6cc <check_input_run+0x9bc>
 107d9e4:	mov    0x18(%rsp),%rdi
 107d9e9:	mov    0x10(%rsp),%rsi
 107d9ee:	mov    0x20(%rsp),%r12
 107d9f3:	mov    0x40(%rsp),%rax
 107d9f8:	mov    0x30(%rsp),%r9
 107d9fd:	mov    0x80(%rsp),%rcx
 107da05:	mov    0xb0(%rsp),%rdx
 107da0d:	mov    0xf8(%rsp),%r8
 107da15:	jmp    106d6de <check_input_run+0x9ce>
 107da1a:	mov    0x18(%rsp),%rdi
 107da1f:	mov    0x10(%rsp),%rsi
 107da24:	mov    0x20(%rsp),%r12
 107da29:	mov    0x40(%rsp),%rax
 107da2e:	mov    0x30(%rsp),%r9
 107da33:	mov    0x80(%rsp),%rcx
 107da3b:	mov    0xb0(%rsp),%rdx
 107da43:	mov    0xf8(%rsp),%r8
 107da4b:	mov    0xb8(%rsp),%r10
 107da53:	jmp    106d6f0 <check_input_run+0x9e0>
 107da58:	mov    0x18(%rsp),%rdi
 107da5d:	mov    0x10(%rsp),%rsi
 107da62:	mov    0x20(%rsp),%r12
 107da67:	mov    0x40(%rsp),%rax
 107da6c:	mov    0x30(%rsp),%r9
 107da71:	mov    0x80(%rsp),%rcx
 107da79:	mov    0xb0(%rsp),%rdx
 107da81:	mov    0xf8(%rsp),%r8
 107da89:	mov    0xb8(%rsp),%r10
 107da91:	mov    0xe0(%rsp),%r11
 107da99:	jmp    106d702 <check_input_run+0x9f2>
 107da9e:	mov    0x18(%rsp),%rdi
 107daa3:	mov    0x10(%rsp),%rsi
 107daa8:	mov    0x20(%rsp),%r12
 107daad:	mov    0x40(%rsp),%rax
 107dab2:	mov    0x30(%rsp),%r9
 107dab7:	mov    0x80(%rsp),%rcx
 107dabf:	mov    0xb0(%rsp),%rdx
 107dac7:	mov    0xf8(%rsp),%r8
 107dacf:	mov    0xb8(%rsp),%r10
 107dad7:	mov    0xe0(%rsp),%r11
 107dadf:	mov    0x108(%rsp),%rbx
 107dae7:	jmp    106d714 <check_input_run+0xa04>
 107daec:	mov    0x18(%rsp),%rdi
 107daf1:	mov    0x10(%rsp),%rsi
 107daf6:	mov    0x20(%rsp),%r12
 107dafb:	mov    0x40(%rsp),%rax
 107db00:	mov    0x30(%rsp),%r9
 107db05:	mov    0x80(%rsp),%rcx
 107db0d:	mov    0xb0(%rsp),%rdx
 107db15:	mov    0xf8(%rsp),%r8
 107db1d:	mov    0xb8(%rsp),%r10
 107db25:	mov    0xe0(%rsp),%r11
 107db2d:	mov    0x108(%rsp),%rbx
 107db35:	jmp    106d71f <check_input_run+0xa0f>
 107db3a:	mov    0x18(%rsp),%rdi
 107db3f:	mov    0x10(%rsp),%rsi
 107db44:	mov    0x20(%rsp),%r12
 107db49:	mov    0x30(%rsp),%r9
 107db4e:	jmp    106d76e <check_input_run+0xa5e>
 107db53:	mov    %rcx,%rsi
 107db56:	sub    %rdi,%rsi
 107db59:	mov    0x10(%rsp),%rdi
 107db5e:	xor    %ebx,%ebx
 107db60:	mov    $0x0,%r15d
 107db66:	mov    0x10(%rdi),%rdi
 107db6a:	sub    %rsi,%rdi
 107db6d:	jb     107dc18 <check_input_run+0x10f08>
 107db73:	mov    0x78(%rsp),%r8
 107db78:	lea    (%r8,%r8,4),%r8
 107db7c:	lea    0x28(,%r8,8),%r8
 107db84:	cmp    %rdi,%r8
 107db87:	ja     107dc18 <check_input_run+0x10f08>
 107db8d:	mov    0x10(%rsp),%rax
 107db92:	add    %r8,%rsi
 107db95:	test   %rcx,%rcx
 107db98:	setne  %r15b
 107db9c:	cmpq   $0x0,0x850(%rsp)
 107dba5:	mov    %rsi,0x8(%rax)
 107dba9:	mov    0x18(%rsp),%rsi
 107dbae:	mov    %rcx,0x350(%rsi)
 107dbb5:	je     107e0c0 <check_input_run+0x113b0>
 107dbbb:	test   %rcx,%rcx
 107dbbe:	je     107e0c0 <check_input_run+0x113b0>
 107dbc4:	mov    0x10(%rsp),%rax
 107dbc9:	mov    0x8(%rax),%rbx
 107dbcd:	mov    0x10(%rax),%rax
 107dbd1:	sub    %rbx,%rax
 107dbd4:	setb   %cl
 107dbd7:	cmp    0x78(%rsp),%rax
 107dbdc:	setbe  %al
 107dbdf:	or     %cl,%al
 107dbe1:	jne    107e0bd <check_input_run+0x113ad>
 107dbe7:	mov    0x10(%rsp),%rcx
 107dbec:	lea    (%rbx,%rdx,1),%rax
 107dbf0:	add    (%rcx),%rbx
 107dbf3:	mov    %rax,0x8(%rcx)
 107dbf7:	je     107e0bd <check_input_run+0x113ad>
 107dbfd:	mov    0x850(%rsp),%rsi
 107dc05:	mov    %rbx,%rdi
 107dc08:	vzeroupper
 107dc0b:	call   788240 <memcpy@plt>
 107dc10:	mov    $0x1,%r15b
 107dc13:	mov    $0x1f0,%eax
 107dc18:	mov    0x18(%rsp),%rdi
 107dc1d:	mov    0x10(%rsp),%rsi
 107dc22:	mov    0x20(%rsp),%r12
 107dc27:	mov    0x30(%rsp),%r9
 107dc2c:	jmp    106d792 <check_input_run+0xa82>
 107dc31:	mov    0x150(%rsp),%rcx
 107dc39:	mov    0xc0(%rsp),%r12
 107dc41:	mov    0x70(%rsp),%r8
 107dc46:	shr    $0x3,%r8d
 107dc4a:	xor    %r11d,%r11d
 107dc4d:	shl    $0x7,%r8
 107dc51:	lea    (%r8,%r8,4),%r10
 107dc55:	xor    %r8d,%r8d
 107dc58:	lea    0x1c(%rcx),%r9
 107dc5c:	mov    0x1f0(%rsp),%rcx
 107dc64:	mov    0x338(%r12),%r15
 107dc6c:	mov    -0x1c(%r9,%r8,4),%r14d
 107dc71:	vmovups (%r15,%r11,1),%zmm0
 107dc78:	vmovups 0x10(%r15,%r11,1),%zmm1
 107dc83:	lea    (%r14,%r14,4),%r14
 107dc87:	shl    $0x4,%r14
 107dc8b:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107dc96:	vmovups %zmm0,(%rcx,%r14,1)
 107dc9d:	mov    0x338(%r12),%r15
 107dca5:	mov    -0x18(%r9,%r8,4),%r14d
 107dcaa:	vmovups 0x50(%r15,%r11,1),%zmm0
 107dcb5:	vmovups 0x60(%r15,%r11,1),%zmm1
 107dcc0:	lea    (%r14,%r14,4),%r14
 107dcc4:	shl    $0x4,%r14
 107dcc8:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107dcd3:	vmovups %zmm0,(%rcx,%r14,1)
 107dcda:	mov    0x338(%r12),%r15
 107dce2:	mov    -0x14(%r9,%r8,4),%r14d
 107dce7:	vmovups 0xa0(%r15,%r11,1),%zmm0
 107dcf2:	vmovups 0xb0(%r15,%r11,1),%zmm1
 107dcfd:	lea    (%r14,%r14,4),%r14
 107dd01:	shl    $0x4,%r14
 107dd05:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107dd10:	vmovups %zmm0,(%rcx,%r14,1)
 107dd17:	mov    0x338(%r12),%r15
 107dd1f:	mov    -0x10(%r9,%r8,4),%r14d
 107dd24:	vmovups 0xf0(%r15,%r11,1),%zmm0
 107dd2f:	vmovups 0x100(%r15,%r11,1),%zmm1
 107dd37:	lea    (%r14,%r14,4),%r14
 107dd3b:	shl    $0x4,%r14
 107dd3f:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107dd4a:	vmovups %zmm0,(%rcx,%r14,1)
 107dd51:	mov    0x338(%r12),%r15
 107dd59:	mov    -0xc(%r9,%r8,4),%r14d
 107dd5e:	vmovups 0x140(%r15,%r11,1),%zmm0
 107dd66:	vmovups 0x150(%r15,%r11,1),%zmm1
 107dd71:	lea    (%r14,%r14,4),%r14
 107dd75:	shl    $0x4,%r14
 107dd79:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107dd84:	vmovups %zmm0,(%rcx,%r14,1)
 107dd8b:	mov    0x338(%r12),%r15
 107dd93:	mov    -0x8(%r9,%r8,4),%r14d
 107dd98:	vmovups 0x190(%r15,%r11,1),%zmm0
 107dda3:	vmovups 0x1a0(%r15,%r11,1),%zmm1
 107ddae:	lea    (%r14,%r14,4),%r14
 107ddb2:	shl    $0x4,%r14
 107ddb6:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107ddc1:	vmovups %zmm0,(%rcx,%r14,1)
 107ddc8:	mov    0x338(%r12),%r15
 107ddd0:	mov    -0x4(%r9,%r8,4),%r14d
 107ddd5:	vmovups 0x1e0(%r15,%r11,1),%zmm0
 107dde0:	vmovups 0x1f0(%r15,%r11,1),%zmm1
 107ddeb:	lea    (%r14,%r14,4),%r14
 107ddef:	shl    $0x4,%r14
 107ddf3:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107ddfe:	vmovups %zmm0,(%rcx,%r14,1)
 107de05:	mov    0x338(%r12),%r15
 107de0d:	mov    (%r9,%r8,4),%r14d
 107de11:	add    $0x8,%r8
 107de15:	vmovdqu64 0x230(%r15,%r11,1),%zmm0
 107de20:	vmovdqu64 0x240(%r15,%r11,1),%zmm1
 107de28:	lea    (%r14,%r14,4),%r14
 107de2c:	add    $0x280,%r11
 107de33:	shl    $0x4,%r14
 107de37:	vmovdqu64 %zmm1,0x10(%rcx,%r14,1)
 107de42:	vmovdqu64 %zmm0,(%rcx,%r14,1)
 107de49:	cmp    %r11,%r10
 107de4c:	jne    107dc64 <check_input_run+0x10f54>
 107de52:	test   %rsi,%rsi
 107de55:	je     107dec1 <check_input_run+0x111b1>
 107de57:	mov    0x150(%rsp),%rcx
 107de5f:	xor    %r10d,%r10d
 107de62:	lea    (%rcx,%r8,4),%r9
 107de66:	mov    0x1f0(%rsp),%rcx
 107de6e:	shl    $0x4,%r8
 107de72:	lea    (%r8,%r8,4),%r8
 107de76:	mov    0xc0(%rsp),%r14
 107de7e:	mov    (%r9,%r10,4),%r11d
 107de82:	inc    %r10
 107de85:	mov    0x338(%r14),%r14
 107de8c:	lea    (%r11,%r11,4),%r11
 107de90:	shl    $0x4,%r11
 107de94:	vmovdqu64 (%r14,%r8,1),%zmm0
 107de9b:	vmovdqu64 0x10(%r14,%r8,1),%zmm1
 107dea6:	add    $0x50,%r8
 107deaa:	vmovdqu64 %zmm1,0x10(%rcx,%r11,1)
 107deb5:	vmovdqu64 %zmm0,(%rcx,%r11,1)
 107debc:	cmp    %r10,%rsi
 107debf:	jne    107de76 <check_input_run+0x11166>
 107dec1:	cmpq   $0x0,0x140(%rsp)
 107deca:	je     107e08c <check_input_run+0x1137c>
 107ded0:	cmpl   $0x0,0xc8(%rsp)
 107ded8:	je     107e08c <check_input_run+0x1137c>
 107dede:	xor    %esi,%esi
 107dee0:	mov    0x4c8(%rsp),%r11
 107dee8:	imul   $0x2c,%rsi,%r14
 107deec:	mov    0x20(%r11,%r14,1),%r9
 107def1:	mov    (%r11,%r14,1),%r12d
 107def5:	mov    0x4(%r11,%r14,1),%r15d
 107defa:	mov    0x8(%r11,%r14,1),%edx
 107deff:	mov    0xc(%r11,%r14,1),%r10d
 107df04:	mov    %r9,0x790(%rsp)
 107df0c:	mov    $0x0,%r9d
 107df12:	vmovdqu 0x10(%r11,%r14,1),%xmm0
 107df19:	vmovdqa %xmm0,0x780(%rsp)
 107df22:	test   %r12d,%r12d
 107df25:	je     107df5f <check_input_run+0x1124f>
 107df27:	mov    %r12d,%r9d
 107df2a:	shr    $0x3,%r9d
 107df2e:	cmpq   $0x0,0x48(%rsp)
 107df34:	je     107df57 <check_input_run+0x11247>
 107df36:	mov    0x48(%rsp),%r8
 107df3b:	mov    %r9d,%ebp
 107df3e:	sub    0x10(%r8),%ebp
 107df42:	jae    107df4f <check_input_run+0x1123f>
 107df44:	mov    0x8(%r8),%r8
 107df48:	test   %r8,%r8
 107df4b:	jne    107df3b <check_input_run+0x1122b>
 107df4d:	jmp    107df57 <check_input_run+0x11247>
 107df4f:	mov    0x18(%r8),%r9
 107df53:	mov    (%r9,%rbp,4),%r9d
 107df57:	and    $0x7,%r12d
 107df5b:	lea    (%r12,%r9,8),%r9d
 107df5f:	mov    0x28(%r11,%r14,1),%r11d
 107df64:	mov    $0x0,%r14d
 107df6a:	xor    %ebp,%ebp
 107df6c:	test   %r15d,%r15d
 107df6f:	je     107dfac <check_input_run+0x1129c>
 107df71:	mov    %r15d,%r14d
 107df74:	shr    $0x3,%r14d
 107df78:	cmpq   $0x0,0x48(%rsp)
 107df7e:	je     107dfa4 <check_input_run+0x11294>
 107df80:	mov    0x48(%rsp),%r12
 107df85:	mov    %r14d,%r8d
 107df88:	sub    0x10(%r12),%r8d
 107df8d:	jae    107df9b <check_input_run+0x1128b>
 107df8f:	mov    0x8(%r12),%r12
 107df94:	test   %r12,%r12
 107df97:	jne    107df85 <check_input_run+0x11275>
 107df99:	jmp    107dfa4 <check_input_run+0x11294>
 107df9b:	mov    0x18(%r12),%r14
 107dfa0:	mov    (%r14,%r8,4),%r14d
 107dfa4:	and    $0x7,%r15d
 107dfa8:	lea    (%r15,%r14,8),%r14d
 107dfac:	test   %r10d,%r10d
 107dfaf:	je     107dfec <check_input_run+0x112dc>
 107dfb1:	mov    %r10d,%r15d
 107dfb4:	shr    $0x3,%r15d
 107dfb8:	cmpq   $0x0,0x48(%rsp)
 107dfbe:	je     107dfe4 <check_input_run+0x112d4>
 107dfc0:	mov    0x48(%rsp),%r12
 107dfc5:	mov    %r15d,%r8d
 107dfc8:	sub    0x10(%r12),%r8d
 107dfcd:	jae    107dfdb <check_input_run+0x112cb>
 107dfcf:	mov    0x8(%r12),%r12
 107dfd4:	test   %r12,%r12
 107dfd7:	jne    107dfc5 <check_input_run+0x112b5>
 107dfd9:	jmp    107dfe4 <check_input_run+0x112d4>
 107dfdb:	mov    0x18(%r12),%r15
 107dfe0:	mov    (%r15,%r8,4),%r15d
 107dfe4:	and    $0x7,%r10d
 107dfe8:	lea    (%r10,%r15,8),%ebp
 107dfec:	test   %r11d,%r11d
 107dfef:	je     107e019 <check_input_run+0x11309>
 107dff1:	mov    %r11d,%r10d
 107dff4:	shr    $0x3,%r10d
 107dff8:	cmpq   $0x0,0x48(%rsp)
 107dffe:	je     107e026 <check_input_run+0x11316>
 107e000:	mov    0x48(%rsp),%r15
 107e005:	mov    %r10d,%r12d
 107e008:	sub    0x10(%r15),%r12d
 107e00c:	jae    107e01e <check_input_run+0x1130e>
 107e00e:	mov    0x8(%r15),%r15
 107e012:	test   %r15,%r15
 107e015:	jne    107e005 <check_input_run+0x112f5>
 107e017:	jmp    107e026 <check_input_run+0x11316>
 107e019:	xor    %r10d,%r10d
 107e01c:	jmp    107e02e <check_input_run+0x1131e>
 107e01e:	mov    0x18(%r15),%r10
 107e022:	mov    (%r10,%r12,4),%r10d
 107e026:	and    $0x7,%r11d
 107e02a:	lea    (%r11,%r10,8),%r10d
 107e02e:	mov    0x118(%rsp),%rcx
 107e036:	mov    (%rcx,%rsi,4),%r11d
 107e03a:	mov    0x208(%rsp),%rcx
 107e042:	inc    %rsi
 107e045:	imul   $0x2c,%r11,%r11
 107e049:	mov    %r9d,(%rcx,%r11,1)
 107e04d:	mov    %r14d,0x4(%rcx,%r11,1)
 107e052:	mov    %edx,0x8(%rcx,%r11,1)
 107e057:	mov    %ebp,0xc(%rcx,%r11,1)
 107e05c:	vmovdqa 0x780(%rsp),%xmm0
 107e065:	vmovdqu %xmm0,0x10(%rcx,%r11,1)
 107e06c:	mov    0x790(%rsp),%r8
 107e074:	mov    %r8,0x20(%rcx,%r11,1)
 107e079:	mov    %r10d,0x28(%rcx,%r11,1)
 107e07e:	cmp    0xc8(%rsp),%rsi
 107e086:	jne    107dee0 <check_input_run+0x111d0>
 107e08c:	cmpq   $0x0,0x140(%rsp)
 107e095:	je     107e330 <check_input_run+0x11620>
 107e09b:	cmpl   $0x0,0x100(%rsp)
 107e0a3:	je     107e330 <check_input_run+0x11620>
 107e0a9:	xor    %r8d,%r8d
 107e0ac:	cmpl   $0x1,0x100(%rsp)
 107e0b4:	jne    107e0d4 <check_input_run+0x113c4>
 107e0b6:	xor    %esi,%esi
 107e0b8:	jmp    107e275 <check_input_run+0x11565>
 107e0bd:	xor    %r15d,%r15d
 107e0c0:	mov    0x18(%rsp),%rdi
 107e0c5:	mov    0x10(%rsp),%rsi
 107e0ca:	mov    0x20(%rsp),%r12
 107e0cf:	jmp    106d79b <check_input_run+0xa8b>
 107e0d4:	mov    0x140(%rsp),%rdx
 107e0dc:	mov    0x100(%rsp),%r9
 107e0e4:	and    $0xfffffffe,%r9d
 107e0e8:	xor    %esi,%esi
 107e0ea:	mov    0x148(%rsp),%rcx
 107e0f2:	mov    0x458(%rsp),%r11
 107e0fa:	mov    %rsi,%r14
 107e0fd:	shl    $0x5,%r14
 107e101:	lea    (%r14,%r14,2),%r14
 107e105:	mov    (%rcx,%rsi,4),%r10d
 107e109:	vmovdqu64 (%r11,%r14,1),%zmm0
 107e110:	vmovdqu64 0x20(%r11,%r14,1),%zmm1
 107e11b:	mov    0x140(%rsp),%rcx
 107e123:	mov    $0x0,%r11d
 107e129:	lea    (%r10,%r10,2),%r10
 107e12d:	shl    $0x5,%r10
 107e131:	vmovdqu64 %zmm1,0x20(%rcx,%r10,1)
 107e13c:	vmovdqu64 %zmm0,(%rcx,%r10,1)
 107e143:	mov    0x458(%rsp),%r10
 107e14b:	mov    (%r10,%r14,1),%r10d
 107e14f:	test   %r10d,%r10d
 107e152:	je     107e18c <check_input_run+0x1147c>
 107e154:	mov    %r10d,%r11d
 107e157:	shr    $0x3,%r11d
 107e15b:	cmpq   $0x0,0x48(%rsp)
 107e161:	je     107e184 <check_input_run+0x11474>
 107e163:	mov    0x48(%rsp),%r14
 107e168:	mov    %r11d,%r15d
 107e16b:	sub    0x10(%r14),%r15d
 107e16f:	jae    107e17c <check_input_run+0x1146c>
 107e171:	mov    0x8(%r14),%r14
 107e175:	test   %r14,%r14
 107e178:	jne    107e168 <check_input_run+0x11458>
 107e17a:	jmp    107e184 <check_input_run+0x11474>
 107e17c:	mov    0x18(%r14),%r11
 107e180:	mov    (%r11,%r15,4),%r11d
 107e184:	and    $0x7,%r10d
 107e188:	lea    (%r10,%r11,8),%r11d
 107e18c:	mov    0x148(%rsp),%rcx
 107e194:	mov    (%rcx,%rsi,4),%r10d
 107e198:	lea    (%r10,%r10,2),%r10
 107e19c:	shl    $0x5,%r10
 107e1a0:	mov    %r11d,(%rdx,%r10,1)
 107e1a4:	lea    0x1(%rsi),%r10
 107e1a8:	mov    0x458(%rsp),%r14
 107e1b0:	mov    %r10,%r15
 107e1b3:	shl    $0x5,%r15
 107e1b7:	mov    0x4(%rcx,%rsi,4),%r11d
 107e1bc:	lea    (%r15,%r15,2),%r15
 107e1c0:	vmovdqu64 (%r14,%r15,1),%zmm0
 107e1c7:	vmovdqu64 0x20(%r14,%r15,1),%zmm1
 107e1d2:	lea    (%r11,%r11,2),%r11
 107e1d6:	shl    $0x5,%r11
 107e1da:	vmovdqu64 %zmm1,0x20(%rdx,%r11,1)
 107e1e5:	vmovdqu64 %zmm0,(%rdx,%r11,1)
 107e1ec:	mov    0x458(%rsp),%r11
 107e1f4:	mov    (%r11,%r15,1),%r11d
 107e1f8:	test   %r11d,%r11d
 107e1fb:	je     107e225 <check_input_run+0x11515>
 107e1fd:	mov    %r11d,%r14d
 107e200:	shr    $0x3,%r14d
 107e204:	cmpq   $0x0,0x48(%rsp)
 107e20a:	je     107e232 <check_input_run+0x11522>
 107e20c:	mov    0x48(%rsp),%r15
 107e211:	mov    %r14d,%r12d
 107e214:	sub    0x10(%r15),%r12d
 107e218:	jae    107e22a <check_input_run+0x1151a>
 107e21a:	mov    0x8(%r15),%r15
 107e21e:	test   %r15,%r15
 107e221:	jne    107e211 <check_input_run+0x11501>
 107e223:	jmp    107e232 <check_input_run+0x11522>
 107e225:	xor    %r11d,%r11d
 107e228:	jmp    107e23a <check_input_run+0x1152a>
 107e22a:	mov    0x18(%r15),%r14
 107e22e:	mov    (%r14,%r12,4),%r14d
 107e232:	and    $0x7,%r11d
 107e236:	lea    (%r11,%r14,8),%r11d
 107e23a:	mov    0x148(%rsp),%rcx
 107e242:	add    $0x2,%rsi
 107e246:	mov    (%rcx,%r10,4),%r10d
 107e24a:	mov    0x140(%rsp),%rcx
 107e252:	lea    (%r10,%r10,2),%r10
 107e256:	shl    $0x5,%r10
 107e25a:	mov    %r11d,(%rcx,%r10,1)
 107e25e:	cmp    %r9,%rsi
 107e261:	jne    107e0ea <check_input_run+0x113da>
 107e267:	testb  $0x1,0x100(%rsp)
 107e26f:	je     107e330 <check_input_run+0x11620>
 107e275:	mov    0x148(%rsp),%rcx
 107e27d:	mov    0x458(%rsp),%r10
 107e285:	mov    %rsi,%r11
 107e288:	shl    $0x5,%r11
 107e28c:	lea    (%r11,%r11,2),%r11
 107e290:	mov    (%rcx,%rsi,4),%r9d
 107e294:	vmovdqu64 (%r10,%r11,1),%zmm0
 107e29b:	vmovdqu64 0x20(%r10,%r11,1),%zmm1
 107e2a6:	mov    0x140(%rsp),%rcx
 107e2ae:	lea    (%r9,%r9,2),%r9
 107e2b2:	shl    $0x5,%r9
 107e2b6:	vmovdqu64 %zmm1,0x20(%rcx,%r9,1)
 107e2c1:	vmovdqu64 %zmm0,(%rcx,%r9,1)
 107e2c8:	mov    0x458(%rsp),%r9
 107e2d0:	mov    (%r9,%r11,1),%r9d
 107e2d4:	test   %r9d,%r9d
 107e2d7:	je     107e311 <check_input_run+0x11601>
 107e2d9:	mov    %r9d,%r8d
 107e2dc:	shr    $0x3,%r8d
 107e2e0:	cmpq   $0x0,0x48(%rsp)
 107e2e6:	je     107e309 <check_input_run+0x115f9>
 107e2e8:	mov    0x48(%rsp),%r10
 107e2ed:	mov    %r8d,%r11d
 107e2f0:	sub    0x10(%r10),%r11d
 107e2f4:	jae    107e301 <check_input_run+0x115f1>
 107e2f6:	mov    0x8(%r10),%r10
 107e2fa:	test   %r10,%r10
 107e2fd:	jne    107e2ed <check_input_run+0x115dd>
 107e2ff:	jmp    107e309 <check_input_run+0x115f9>
 107e301:	mov    0x18(%r10),%r8
 107e305:	mov    (%r8,%r11,4),%r8d
 107e309:	and    $0x7,%r9d
 107e30d:	lea    (%r9,%r8,8),%r8d
 107e311:	mov    0x148(%rsp),%rcx
 107e319:	mov    (%rcx,%rsi,4),%esi
 107e31c:	mov    0x140(%rsp),%rcx
 107e324:	lea    (%rsi,%rsi,2),%rsi
 107e328:	shl    $0x5,%rsi
 107e32c:	mov    %r8d,(%rcx,%rsi,1)
 107e330:	cmpq   $0x0,0x140(%rsp)
 107e339:	movzbl 0x58(%rsp),%ecx
 107e33e:	sete   %sil
 107e342:	xor    $0x1,%cl
 107e345:	or     %cl,%sil
 107e348:	mov    %cl,0x58(%rsp)
 107e34c:	jne    107e9f0 <check_input_run+0x11ce0>
 107e352:	mov    0x60(%rsp),%rsi
 107e357:	movq   $0x0,0x158(%rsp)
 107e363:	cmp    $0x1,%rsi
 107e367:	adc    $0x0,%rsi
 107e36b:	mov    %rsi,0x190(%rsp)
 107e373:	mov    0x1b0(%rsp),%rsi
 107e37b:	mov    0x158(%rsp),%rdx
 107e383:	mov    (%rsi),%rsi
 107e386:	imul   $0x150,%rdx,%r8
 107e38d:	lea    0x1(%rdx),%rcx
 107e391:	mov    %rdx,0x138(%rsp)
 107e399:	lea    (%rcx,%rcx,2),%rdx
 107e39d:	mov    %rcx,0x158(%rsp)
 107e3a5:	shl    $0x4,%rdx
 107e3a9:	add    0x48(%rsp),%rdx
 107e3ae:	cmpl   $0x0,0xb0(%rsi,%r8,1)
 107e3b7:	lea    (%rsi,%r8,1),%rbx
 107e3bb:	je     107e48e <check_input_run+0x1177e>
 107e3c1:	xor    %esi,%esi
 107e3c3:	mov    0x80(%rsp),%r8
 107e3cb:	mov    0x138(%rsp),%rcx
 107e3d3:	mov    0xa8(%rbx),%r9
 107e3da:	lea    0x0(,%rsi,8),%r11
 107e3e2:	lea    (%r11,%r11,4),%r11
 107e3e6:	mov    (%r8,%rcx,4),%r8d
 107e3ea:	mov    0x20(%r9,%r11,1),%r14
 107e3ef:	mov    0x178(%rsp),%rcx
 107e3f7:	add    %esi,%r8d
 107e3fa:	lea    (%r8,%r8,4),%r8
 107e3fe:	mov    %r14,0x20(%rcx,%r8,8)
 107e403:	vmovdqu (%r9,%r11,1),%ymm0
 107e409:	vmovdqu %ymm0,(%rcx,%r8,8)
 107e40f:	mov    0xa8(%rbx),%r8
 107e416:	mov    0x8(%r8,%r11,1),%r8d
 107e41b:	test   %r8d,%r8d
 107e41e:	je     107e43e <check_input_run+0x1172e>
 107e420:	mov    %r8d,%r14d
 107e423:	shr    $0x3,%r14d
 107e427:	mov    %rdx,%r15
 107e42a:	mov    %r14d,%r11d
 107e42d:	sub    0x10(%r15),%r11d
 107e431:	jae    107e443 <check_input_run+0x11733>
 107e433:	mov    0x8(%r15),%r15
 107e437:	test   %r15,%r15
 107e43a:	jne    107e42a <check_input_run+0x1171a>
 107e43c:	jmp    107e44b <check_input_run+0x1173b>
 107e43e:	xor    %r8d,%r8d
 107e441:	jmp    107e453 <check_input_run+0x11743>
 107e443:	mov    0x18(%r15),%r9
 107e447:	mov    (%r9,%r11,4),%r14d
 107e44b:	and    $0x7,%r8d
 107e44f:	lea    (%r8,%r14,8),%r8d
 107e453:	mov    0x80(%rsp),%r9
 107e45b:	mov    0x138(%rsp),%rcx
 107e463:	mov    (%r9,%rcx,4),%r9d
 107e467:	mov    0x178(%rsp),%rcx
 107e46f:	add    %esi,%r9d
 107e472:	inc    %rsi
 107e475:	lea    (%r9,%r9,4),%r9
 107e479:	mov    %r8d,0x8(%rcx,%r9,8)
 107e47e:	mov    0xb0(%rbx),%r8d
 107e485:	cmp    %r8,%rsi
 107e488:	jb     107e3c3 <check_input_run+0x116b3>
 107e48e:	cmpl   $0x0,0xc0(%rbx)
 107e495:	je     107e4ef <check_input_run+0x117df>
 107e497:	xor    %esi,%esi
 107e499:	xor    %r8d,%r8d
 107e49c:	mov    0xb0(%rsp),%rcx
 107e4a4:	mov    0x138(%rsp),%r9
 107e4ac:	mov    0xb8(%rbx),%r11
 107e4b3:	mov    (%rcx,%r9,4),%r9d
 107e4b7:	mov    0x10(%r11,%rsi,1),%r14
 107e4bc:	mov    0x1f8(%rsp),%rcx
 107e4c4:	add    %r8d,%r9d
 107e4c7:	inc    %r8
 107e4ca:	lea    (%r9,%r9,2),%r9
 107e4ce:	mov    %r14,0x10(%rcx,%r9,8)
 107e4d3:	vmovdqu (%r11,%rsi,1),%xmm0
 107e4d9:	add    $0x18,%rsi
 107e4dd:	vmovdqu %xmm0,(%rcx,%r9,8)
 107e4e3:	mov    0xc0(%rbx),%r9d
 107e4ea:	cmp    %r9,%r8
 107e4ed:	jb     107e49c <check_input_run+0x1178c>
 107e4ef:	cmpl   $0x0,0xd0(%rbx)
 107e4f6:	je     107e5c9 <check_input_run+0x118b9>
 107e4fc:	xor    %esi,%esi
 107e4fe:	mov    0xf8(%rsp),%rcx
 107e506:	mov    0x138(%rsp),%r8
 107e50e:	mov    0xc8(%rbx),%r9
 107e515:	lea    0x0(,%rsi,4),%r11
 107e51d:	lea    (%r11,%r11,8),%r11
 107e521:	mov    (%rcx,%r8,4),%r8d
 107e525:	mov    0x20(%r9,%r11,1),%ebp
 107e52a:	mov    0x160(%rsp),%rcx
 107e532:	add    %esi,%r8d
 107e535:	lea    (%r8,%r8,8),%r8
 107e539:	mov    %ebp,0x20(%rcx,%r8,4)
 107e53e:	vmovdqu (%r9,%r11,1),%ymm0
 107e544:	vmovdqu %ymm0,(%rcx,%r8,4)
 107e54a:	mov    0xc8(%rbx),%r8
 107e551:	mov    0x4(%r8,%r11,1),%r8d
 107e556:	test   %r8d,%r8d
 107e559:	je     107e579 <check_input_run+0x11869>
 107e55b:	mov    %r8d,%r14d
 107e55e:	shr    $0x3,%r14d
 107e562:	mov    %rdx,%r15
 107e565:	mov    %r14d,%r11d
 107e568:	sub    0x10(%r15),%r11d
 107e56c:	jae    107e57e <check_input_run+0x1186e>
 107e56e:	mov    0x8(%r15),%r15
 107e572:	test   %r15,%r15
 107e575:	jne    107e565 <check_input_run+0x11855>
 107e577:	jmp    107e586 <check_input_run+0x11876>
 107e579:	xor    %r8d,%r8d
 107e57c:	jmp    107e58e <check_input_run+0x1187e>
 107e57e:	mov    0x18(%r15),%r9
 107e582:	mov    (%r9,%r11,4),%r14d
 107e586:	and    $0x7,%r8d
 107e58a:	lea    (%r8,%r14,8),%r8d
 107e58e:	mov    0xf8(%rsp),%rcx
 107e596:	mov    0x138(%rsp),%r9
 107e59e:	mov    (%rcx,%r9,4),%r9d
 107e5a2:	mov    0x160(%rsp),%rcx
 107e5aa:	add    %esi,%r9d
 107e5ad:	inc    %rsi
 107e5b0:	lea    (%r9,%r9,8),%r9
 107e5b4:	mov    %r8d,0x4(%rcx,%r9,4)
 107e5b9:	mov    0xd0(%rbx),%r8d
 107e5c0:	cmp    %r8,%rsi
 107e5c3:	jb     107e4fe <check_input_run+0x117ee>
 107e5c9:	cmpl   $0x0,0xe8(%rbx)
 107e5d0:	je     107e6af <check_input_run+0x1199f>
 107e5d6:	xor    %esi,%esi
 107e5d8:	mov    0xe0(%rbx),%r9
 107e5df:	lea    (%rsi,%rsi,8),%r11
 107e5e3:	vmovups 0x14(%r9,%r11,4),%xmm0
 107e5ea:	mov    (%r9,%r11,4),%r8d
 107e5ee:	mov    0x4(%r9,%r11,4),%r14d
 107e5f3:	vmovups %xmm0,0x78c(%rsp)
 107e5fc:	vmovdqu 0x8(%r9,%r11,4),%xmm0
 107e603:	vmovdqa %xmm0,0x780(%rsp)
 107e60c:	test   %r14d,%r14d
 107e60f:	je     107e63b <check_input_run+0x1192b>
 107e611:	mov    %r14d,%r15d
 107e614:	shr    $0x3,%r15d
 107e618:	cmpq   $0x0,0x48(%rsp)
 107e61e:	je     107e648 <check_input_run+0x11938>
 107e620:	mov    0x48(%rsp),%r12
 107e625:	mov    %r15d,%r11d
 107e628:	sub    0x10(%r12),%r11d
 107e62d:	jae    107e63f <check_input_run+0x1192f>
 107e62f:	mov    0x8(%r12),%r12
 107e634:	test   %r12,%r12
 107e637:	jne    107e625 <check_input_run+0x11915>
 107e639:	jmp    107e648 <check_input_run+0x11938>
 107e63b:	xor    %ebp,%ebp
 107e63d:	jmp    107e650 <check_input_run+0x11940>
 107e63f:	mov    0x18(%r12),%r9
 107e644:	mov    (%r9,%r11,4),%r15d
 107e648:	and    $0x7,%r14d
 107e64c:	lea    (%r14,%r15,8),%ebp
 107e650:	mov    0xd8(%rbx),%r9
 107e657:	mov    0x88(%rsp),%rcx
 107e65f:	mov    (%r9,%rsi,4),%r9d
 107e663:	inc    %rsi
 107e666:	mov    (%rcx,%r9,4),%r9d
 107e66a:	mov    0x160(%rsp),%rcx
 107e672:	lea    (%r9,%r9,8),%r9
 107e676:	mov    %r8d,(%rcx,%r9,4)
 107e67a:	mov    %ebp,0x4(%rcx,%r9,4)
 107e67f:	vmovaps 0x780(%rsp),%xmm0
 107e688:	vmovups %xmm0,0x8(%rcx,%r9,4)
 107e68f:	vmovdqu 0x78c(%rsp),%xmm0
 107e698:	vmovdqu %xmm0,0x14(%rcx,%r9,4)
 107e69f:	mov    0xe8(%rbx),%r8d
 107e6a6:	cmp    %r8,%rsi
 107e6a9:	jb     107e5d8 <check_input_run+0x118c8>
 107e6af:	cmpl   $0x0,0xf8(%rbx)
 107e6b6:	je     107e722 <check_input_run+0x11a12>
 107e6b8:	xor    %esi,%esi
 107e6ba:	xor    %r8d,%r8d
 107e6bd:	mov    0x1a0(%rsp),%rcx
 107e6c5:	mov    0x138(%rsp),%r9
 107e6cd:	mov    0xf0(%rbx),%r11
 107e6d4:	mov    (%rcx,%r9,4),%r9d
 107e6d8:	vmovdqu64 (%r11,%rsi,1),%zmm0
 107e6df:	vmovdqu64 0x10(%r11,%rsi,1),%zmm1
 107e6ea:	mov    0x1f0(%rsp),%rcx
 107e6f2:	add    $0x50,%rsi
 107e6f6:	add    %r8d,%r9d
 107e6f9:	inc    %r8
 107e6fc:	lea    (%r9,%r9,4),%r9
 107e700:	shl    $0x4,%r9
 107e704:	vmovdqu64 %zmm1,0x10(%rcx,%r9,1)
 107e70f:	vmovdqu64 %zmm0,(%rcx,%r9,1)
 107e716:	mov    0xf8(%rbx),%r9d
 107e71d:	cmp    %r9,%r8
 107e720:	jb     107e6bd <check_input_run+0x119ad>
 107e722:	cmpl   $0x0,0x108(%rbx)
 107e729:	je     107e8ed <check_input_run+0x11bdd>
 107e72f:	xor    %r14d,%r14d
 107e732:	mov    0x100(%rbx),%r10
 107e739:	imul   $0x2c,%r14,%rbp
 107e73d:	movl   $0x0,0x170(%rsp)
 107e748:	movl   $0x0,0x168(%rsp)
 107e753:	mov    0x20(%r10,%rbp,1),%r11
 107e758:	mov    0x8(%r10,%rbp,1),%ecx
 107e75d:	mov    (%r10,%rbp,1),%r9d
 107e761:	mov    0x4(%r10,%rbp,1),%r8d
 107e766:	mov    0xc(%r10,%rbp,1),%esi
 107e76b:	mov    %r11,0x790(%rsp)
 107e773:	mov    %ecx,0x188(%rsp)
 107e77a:	vmovdqu 0x10(%r10,%rbp,1),%xmm0
 107e781:	vmovdqa %xmm0,0x780(%rsp)
 107e78a:	test   %r9d,%r9d
 107e78d:	je     107e7c4 <check_input_run+0x11ab4>
 107e78f:	mov    %r9d,%r15d
 107e792:	shr    $0x3,%r15d
 107e796:	mov    %rdx,%r11
 107e799:	mov    %r15d,%r12d
 107e79c:	sub    0x10(%r11),%r12d
 107e7a0:	jae    107e7ad <check_input_run+0x11a9d>
 107e7a2:	mov    0x8(%r11),%r11
 107e7a6:	test   %r11,%r11
 107e7a9:	jne    107e799 <check_input_run+0x11a89>
 107e7ab:	jmp    107e7b5 <check_input_run+0x11aa5>
 107e7ad:	mov    0x18(%r11),%r11
 107e7b1:	mov    (%r11,%r12,4),%r15d
 107e7b5:	and    $0x7,%r9d
 107e7b9:	lea    (%r9,%r15,8),%ecx
 107e7bd:	mov    %ecx,0x168(%rsp)
 107e7c4:	mov    0x28(%r10,%rbp,1),%r12d
 107e7c9:	test   %r8d,%r8d
 107e7cc:	je     107e803 <check_input_run+0x11af3>
 107e7ce:	mov    %r8d,%r15d
 107e7d1:	shr    $0x3,%r15d
 107e7d5:	mov    %rdx,%r11
 107e7d8:	mov    %r15d,%r9d
 107e7db:	sub    0x10(%r11),%r9d
 107e7df:	jae    107e7ec <check_input_run+0x11adc>
 107e7e1:	mov    0x8(%r11),%r11
 107e7e5:	test   %r11,%r11
 107e7e8:	jne    107e7d8 <check_input_run+0x11ac8>
 107e7ea:	jmp    107e7f4 <check_input_run+0x11ae4>
 107e7ec:	mov    0x18(%r11),%r11
 107e7f0:	mov    (%r11,%r9,4),%r15d
 107e7f4:	and    $0x7,%r8d
 107e7f8:	lea    (%r8,%r15,8),%ecx
 107e7fc:	mov    %ecx,0x170(%rsp)
 107e803:	mov    $0x0,%ebp
 107e808:	xor    %r8d,%r8d
 107e80b:	test   %esi,%esi
 107e80d:	je     107e83c <check_input_run+0x11b2c>
 107e80f:	mov    %esi,%r15d
 107e812:	shr    $0x3,%r15d
 107e816:	mov    %rdx,%r11
 107e819:	mov    %r15d,%r9d
 107e81c:	sub    0x10(%r11),%r9d
 107e820:	jae    107e82d <check_input_run+0x11b1d>
 107e822:	mov    0x8(%r11),%r11
 107e826:	test   %r11,%r11
 107e829:	jne    107e819 <check_input_run+0x11b09>
 107e82b:	jmp    107e835 <check_input_run+0x11b25>
 107e82d:	mov    0x18(%r11),%r11
 107e831:	mov    (%r11,%r9,4),%r15d
 107e835:	and    $0x7,%esi
 107e838:	lea    (%rsi,%r15,8),%ebp
 107e83c:	test   %r12d,%r12d
 107e83f:	je     107e86e <check_input_run+0x11b5e>
 107e841:	mov    %r12d,%esi
 107e844:	shr    $0x3,%esi
 107e847:	mov    %rdx,%r8
 107e84a:	mov    %esi,%r9d
 107e84d:	sub    0x10(%r8),%r9d
 107e851:	jae    107e85e <check_input_run+0x11b4e>
 107e853:	mov    0x8(%r8),%r8
 107e857:	test   %r8,%r8
 107e85a:	jne    107e84a <check_input_run+0x11b3a>
 107e85c:	jmp    107e866 <check_input_run+0x11b56>
 107e85e:	mov    0x18(%r8),%rsi
 107e862:	mov    (%rsi,%r9,4),%esi
 107e866:	and    $0x7,%r12d
 107e86a:	lea    (%r12,%rsi,8),%r8d
 107e86e:	mov    0x198(%rsp),%rcx
 107e876:	mov    0x138(%rsp),%rsi
 107e87e:	mov    0x168(%rsp),%r9d
 107e886:	mov    0x170(%rsp),%r11d
 107e88e:	mov    0x188(%rsp),%r10d
 107e896:	mov    (%rcx,%rsi,4),%esi
 107e899:	mov    0x208(%rsp),%rcx
 107e8a1:	add    %r14d,%esi
 107e8a4:	inc    %r14
 107e8a7:	imul   $0x2c,%rsi,%rsi
 107e8ab:	mov    %r9d,(%rcx,%rsi,1)
 107e8af:	mov    %r11d,0x4(%rcx,%rsi,1)
 107e8b4:	mov    %r10d,0x8(%rcx,%rsi,1)
 107e8b9:	mov    %ebp,0xc(%rcx,%rsi,1)
 107e8bd:	vmovdqa 0x780(%rsp),%xmm0
 107e8c6:	vmovdqu %xmm0,0x10(%rcx,%rsi,1)
 107e8cc:	mov    0x790(%rsp),%r9
 107e8d4:	mov    %r9,0x20(%rcx,%rsi,1)
 107e8d9:	mov    %r8d,0x28(%rcx,%rsi,1)
 107e8de:	mov    0x108(%rbx),%esi
 107e8e4:	cmp    %rsi,%r14
 107e8e7:	jb     107e732 <check_input_run+0x11a22>
 107e8ed:	cmpl   $0x0,0x118(%rbx)
 107e8f4:	je     107e9da <check_input_run+0x11cca>
 107e8fa:	xor    %esi,%esi
 107e8fc:	mov    0x180(%rsp),%rcx
 107e904:	mov    0x138(%rsp),%r8
 107e90c:	mov    0x110(%rbx),%r9
 107e913:	mov    %rsi,%r11
 107e916:	shl    $0x5,%r11
 107e91a:	lea    (%r11,%r11,2),%r11
 107e91e:	mov    (%rcx,%r8,4),%r8d
 107e922:	vmovdqu64 (%r9,%r11,1),%zmm0
 107e929:	vmovdqu64 0x20(%r9,%r11,1),%zmm1
 107e934:	mov    0x140(%rsp),%rcx
 107e93c:	add    %esi,%r8d
 107e93f:	lea    (%r8,%r8,2),%r8
 107e943:	shl    $0x5,%r8
 107e947:	vmovdqu64 %zmm1,0x20(%rcx,%r8,1)
 107e952:	vmovdqu64 %zmm0,(%rcx,%r8,1)
 107e959:	mov    0x110(%rbx),%r8
 107e960:	mov    (%r8,%r11,1),%r8d
 107e964:	test   %r8d,%r8d
 107e967:	je     107e987 <check_input_run+0x11c77>
 107e969:	mov    %r8d,%r14d
 107e96c:	shr    $0x3,%r14d
 107e970:	mov    %rdx,%r11
 107e973:	mov    %r14d,%r9d
 107e976:	sub    0x10(%r11),%r9d
 107e97a:	jae    107e98c <check_input_run+0x11c7c>
 107e97c:	mov    0x8(%r11),%r11
 107e980:	test   %r11,%r11
 107e983:	jne    107e973 <check_input_run+0x11c63>
 107e985:	jmp    107e994 <check_input_run+0x11c84>
 107e987:	xor    %r8d,%r8d
 107e98a:	jmp    107e99c <check_input_run+0x11c8c>
 107e98c:	mov    0x18(%r11),%r11
 107e990:	mov    (%r11,%r9,4),%r14d
 107e994:	and    $0x7,%r8d
 107e998:	lea    (%r8,%r14,8),%r8d
 107e99c:	mov    0x180(%rsp),%rcx
 107e9a4:	mov    0x138(%rsp),%r9
 107e9ac:	mov    (%rcx,%r9,4),%r9d
 107e9b0:	mov    0x140(%rsp),%rcx
 107e9b8:	add    %esi,%r9d
 107e9bb:	inc    %rsi
 107e9be:	lea    (%r9,%r9,2),%r9
 107e9c2:	shl    $0x5,%r9
 107e9c6:	mov    %r8d,(%rcx,%r9,1)
 107e9ca:	mov    0x118(%rbx),%r8d
 107e9d1:	cmp    %r8,%rsi
 107e9d4:	jb     107e8fc <check_input_run+0x11bec>
 107e9da:	mov    0x158(%rsp),%rcx
 107e9e2:	cmp    0x190(%rsp),%rcx
 107e9ea:	jne    107e373 <check_input_run+0x11663>
 107e9f0:	cmpq   $0x0,0x140(%rsp)
 107e9f9:	je     1077c8e <check_input_run+0xaf7e>
 107e9ff:	mov    0x2c8(%rsp),%r8
 107ea07:	mov    (%r8),%rsi
 107ea0a:	mov    0x8(%r8),%r9
 107ea0e:	lea    0x3(%r9,%rsi,1),%rbx
 107ea13:	add    %rsi,%r9
 107ea16:	and    $0xfffffffffffffffc,%rbx
 107ea1a:	cmp    %r9,%rbx
 107ea1d:	jb     1077c8e <check_input_run+0xaf7e>
 107ea23:	mov    0x10(%r8),%r10
 107ea27:	mov    %rbx,%r9
 107ea2a:	sub    %rsi,%r9
 107ea2d:	sub    %r9,%r10
 107ea30:	jb     1077c8e <check_input_run+0xaf7e>
 107ea36:	mov    0x2dc(%rsp),%r12d
 107ea3e:	lea    0x1(%r12),%r15
 107ea43:	lea    0x0(,%r15,4),%rsi
 107ea4b:	cmp    %r10,%rsi
 107ea4e:	ja     1077c8e <check_input_run+0xaf7e>
 107ea54:	add    %rsi,%r9
 107ea57:	mov    %r9,0x8(%r8)
 107ea5b:	test   %rbx,%rbx
 107ea5e:	je     1077c8e <check_input_run+0xaf7e>
 107ea64:	mov    0x2c8(%rsp),%r8
 107ea6c:	mov    (%r8),%r10
 107ea6f:	mov    0x8(%r8),%r9
 107ea73:	lea    0x3(%r9,%r10,1),%rcx
 107ea78:	add    %r10,%r9
 107ea7b:	and    $0xfffffffffffffffc,%rcx
 107ea7f:	mov    %rcx,0x138(%rsp)
 107ea87:	cmp    %r9,%rcx
 107ea8a:	jb     1077c8e <check_input_run+0xaf7e>
 107ea90:	mov    0x138(%rsp),%r9
 107ea98:	sub    %r10,%r9
 107ea9b:	mov    0x10(%r8),%r10
 107ea9f:	sub    %r9,%r10
 107eaa2:	jb     1077c8e <check_input_run+0xaf7e>
 107eaa8:	cmp    %r10,%rsi
 107eaab:	ja     1077c8e <check_input_run+0xaf7e>
 107eab1:	add    %rsi,%r9
 107eab4:	cmpq   $0x0,0x138(%rsp)
 107eabd:	mov    %r9,0x8(%r8)
 107eac1:	je     1077c8e <check_input_run+0xaf7e>
 107eac7:	mov    0x2c8(%rsp),%r8
 107eacf:	mov    (%r8),%r10
 107ead2:	mov    0x8(%r8),%r9
 107ead6:	lea    0x3(%r9,%r10,1),%rcx
 107eadb:	add    %r10,%r9
 107eade:	and    $0xfffffffffffffffc,%rcx
 107eae2:	mov    %rcx,0x158(%rsp)
 107eaea:	cmp    %r9,%rcx
 107eaed:	jb     1077c8e <check_input_run+0xaf7e>
 107eaf3:	mov    0x158(%rsp),%r9
 107eafb:	sub    %r10,%r9
 107eafe:	mov    0x10(%r8),%r10
 107eb02:	sub    %r9,%r10
 107eb05:	jb     1077c8e <check_input_run+0xaf7e>
 107eb0b:	cmp    %r10,%rsi
 107eb0e:	ja     1077c8e <check_input_run+0xaf7e>
 107eb14:	add    %rsi,%r9
 107eb17:	cmpq   $0x0,0x158(%rsp)
 107eb20:	mov    %r9,0x8(%r8)
 107eb24:	je     1077c8e <check_input_run+0xaf7e>
 107eb2a:	mov    0x2c8(%rsp),%r8
 107eb32:	mov    (%r8),%r10
 107eb35:	mov    0x8(%r8),%r9
 107eb39:	lea    0x3(%r9,%r10,1),%rcx
 107eb3e:	add    %r10,%r9
 107eb41:	and    $0xfffffffffffffffc,%rcx
 107eb45:	mov    %rcx,0x170(%rsp)
 107eb4d:	cmp    %r9,%rcx
 107eb50:	jb     1077c8e <check_input_run+0xaf7e>
 107eb56:	mov    0x170(%rsp),%r9
 107eb5e:	sub    %r10,%r9
 107eb61:	mov    0x10(%r8),%r10
 107eb65:	sub    %r9,%r10
 107eb68:	jb     1077c8e <check_input_run+0xaf7e>
 107eb6e:	cmp    %r10,%rsi
 107eb71:	ja     1077c8e <check_input_run+0xaf7e>
 107eb77:	add    %rsi,%r9
 107eb7a:	cmpq   $0x0,0x170(%rsp)
 107eb83:	mov    %r9,0x8(%r8)
 107eb87:	je     1077c8e <check_input_run+0xaf7e>
 107eb8d:	mov    0x2c8(%rsp),%r8
 107eb95:	mov    (%r8),%r10
 107eb98:	mov    0x8(%r8),%r9
 107eb9c:	lea    0x3(%r9,%r10,1),%rcx
 107eba1:	add    %r10,%r9
 107eba4:	and    $0xfffffffffffffffc,%rcx
 107eba8:	mov    %rcx,0x168(%rsp)
 107ebb0:	cmp    %r9,%rcx
 107ebb3:	jb     1077c8e <check_input_run+0xaf7e>
 107ebb9:	mov    0x168(%rsp),%r9
 107ebc1:	sub    %r10,%r9
 107ebc4:	mov    0x10(%r8),%r10
 107ebc8:	sub    %r9,%r10
 107ebcb:	jb     1077c8e <check_input_run+0xaf7e>
 107ebd1:	cmp    %r10,%rsi
 107ebd4:	ja     1077c8e <check_input_run+0xaf7e>
 107ebda:	add    %rsi,%r9
 107ebdd:	cmpq   $0x0,0x168(%rsp)
 107ebe6:	mov    %r9,0x8(%r8)
 107ebea:	je     1077c8e <check_input_run+0xaf7e>
 107ebf0:	mov    0x2c8(%rsp),%r8
 107ebf8:	mov    (%r8),%r10
 107ebfb:	mov    0x8(%r8),%r9
 107ebff:	lea    0x3(%r9,%r10,1),%rcx
 107ec04:	add    %r10,%r9
 107ec07:	and    $0xfffffffffffffffc,%rcx
 107ec0b:	mov    %rcx,0x190(%rsp)
 107ec13:	cmp    %r9,%rcx
 107ec16:	jb     1077c8e <check_input_run+0xaf7e>
 107ec1c:	mov    0x190(%rsp),%r9
 107ec24:	sub    %r10,%r9
 107ec27:	mov    0x10(%r8),%r10
 107ec2b:	sub    %r9,%r10
 107ec2e:	jb     1077c8e <check_input_run+0xaf7e>
 107ec34:	cmp    %r10,%rsi
 107ec37:	ja     1077c8e <check_input_run+0xaf7e>
 107ec3d:	add    %rsi,%r9
 107ec40:	cmpq   $0x0,0x190(%rsp)
 107ec49:	mov    %r9,0x8(%r8)
 107ec4d:	je     1077c8e <check_input_run+0xaf7e>
 107ec53:	mov    0x2c8(%rsp),%rsi
 107ec5b:	mov    0x8(%rsi),%r9
 107ec5f:	mov    0x10(%rsi),%r8
 107ec63:	sub    %r9,%r8
 107ec66:	mov    %r9,%rcx
 107ec69:	setb   %r9b
 107ec6d:	cmp    %r12,%r8
 107ec70:	setbe  %r8b
 107ec74:	or     %r9b,%r8b
 107ec77:	jne    1077c8e <check_input_run+0xaf7e>
 107ec7d:	lea    (%rcx,%r15,1),%r8
 107ec81:	add    (%rsi),%rcx
 107ec84:	mov    %r8,0x8(%rsi)
 107ec88:	mov    %rcx,0x200(%rsp)
 107ec90:	je     1077c8e <check_input_run+0xaf7e>
 107ec96:	mov    0x2c8(%rsp),%rsi
 107ec9e:	mov    0x8(%rsi),%r8
 107eca2:	mov    0x10(%rsi),%r9
 107eca6:	sub    %r8,%r9
 107eca9:	setb   %r10b
 107ecad:	cmp    %r12,%r9
 107ecb0:	setbe  %r9b
 107ecb4:	or     %r10b,%r9b
 107ecb7:	jne    1077c8e <check_input_run+0xaf7e>
 107ecbd:	mov    %r8,%rcx
 107ecc0:	add    %r8,%r15
 107ecc3:	add    (%rsi),%rcx
 107ecc6:	mov    %r15,0x8(%rsi)
 107ecca:	mov    %rcx,0x188(%rsp)
 107ecd2:	je     107efe3 <check_input_run+0x122d3>
 107ecd8:	cmpl   $0x0,0xa8(%rsp)
 107ece0:	je     107efe3 <check_input_run+0x122d3>
 107ece6:	cmpl   $0x1,0xa8(%rsp)
 107ecee:	jne    107ecf8 <check_input_run+0x11fe8>
 107ecf0:	xor    %r15d,%r15d
 107ecf3:	jmp    107eefa <check_input_run+0x121ea>
 107ecf8:	mov    0xa8(%rsp),%r12
 107ed00:	and    $0xfffffffe,%r12d
 107ed04:	lea    0x4(%rax),%rdx
 107ed08:	mov    $0xffffffff,%ebp
 107ed0d:	xor    %r15d,%r15d
 107ed10:	mov    0x2f8(%rsp),%r9
 107ed18:	mov    -0x4(%rdx,%r15,4),%esi
 107ed1d:	mov    0x138(%rsp),%rcx
 107ed25:	mov    (%r9,%r15,4),%r9d
 107ed29:	mov    %r9d,(%rbx,%rsi,4)
 107ed2d:	mov    0x300(%rsp),%r9
 107ed35:	mov    (%r9,%r15,4),%r9d
 107ed39:	mov    %r9d,(%rcx,%rsi,4)
 107ed3d:	mov    0x158(%rsp),%rcx
 107ed45:	mov    0x308(%rsp),%r9
 107ed4d:	mov    (%r9,%r15,4),%r9d
 107ed51:	mov    %r9d,(%rcx,%rsi,4)
 107ed55:	mov    0x310(%rsp),%r9
 107ed5d:	mov    (%r9,%r15,4),%r9d
 107ed61:	cmp    %rbp,%r9
 107ed64:	je     107ed6c <check_input_run+0x1205c>
 107ed66:	mov    (%rax,%r9,4),%r9d
 107ed6a:	jmp    107ed72 <check_input_run+0x12062>
 107ed6c:	mov    $0xffffffff,%r9d
 107ed72:	mov    0x170(%rsp),%rcx
 107ed7a:	mov    %r9d,(%rcx,%rsi,4)
 107ed7e:	mov    0x318(%rsp),%r9
 107ed86:	mov    (%r9,%r15,4),%r9d
 107ed8a:	test   %r9d,%r9d
 107ed8d:	je     107ed9b <check_input_run+0x1208b>
 107ed8f:	dec    %r9d
 107ed92:	mov    (%rax,%r9,4),%r9d
 107ed96:	inc    %r9d
 107ed99:	jmp    107ed9e <check_input_run+0x1208e>
 107ed9b:	xor    %r9d,%r9d
 107ed9e:	mov    0x168(%rsp),%rcx
 107eda6:	mov    %r9d,(%rcx,%rsi,4)
 107edaa:	mov    0x190(%rsp),%rcx
 107edb2:	mov    0x320(%rsp),%r9
 107edba:	mov    (%r9,%r15,4),%r9d
 107edbe:	mov    %r9d,(%rcx,%rsi,4)
 107edc2:	mov    0x200(%rsp),%rcx
 107edca:	mov    0x328(%rsp),%r9
 107edd2:	movzbl (%r9,%r15,1),%r9d
 107edd7:	mov    %r9b,(%rcx,%rsi,1)
 107eddb:	mov    0x188(%rsp),%rcx
 107ede3:	mov    0x330(%rsp),%r9
 107edeb:	movzbl (%r9,%r15,1),%r9d
 107edf0:	mov    %r9b,(%rcx,%rsi,1)
 107edf4:	mov    0x138(%rsp),%rcx
 107edfc:	mov    0x2f8(%rsp),%r9
 107ee04:	mov    (%rdx,%r15,4),%esi
 107ee08:	mov    0x4(%r9,%r15,4),%r9d
 107ee0d:	mov    %r9d,(%rbx,%rsi,4)
 107ee11:	mov    0x300(%rsp),%r9
 107ee19:	mov    0x4(%r9,%r15,4),%r9d
 107ee1e:	mov    %r9d,(%rcx,%rsi,4)
 107ee22:	mov    0x158(%rsp),%rcx
 107ee2a:	mov    0x308(%rsp),%r9
 107ee32:	mov    0x4(%r9,%r15,4),%r9d
 107ee37:	mov    %r9d,(%rcx,%rsi,4)
 107ee3b:	mov    0x310(%rsp),%r9
 107ee43:	mov    0x4(%r9,%r15,4),%r9d
 107ee48:	cmp    %rbp,%r9
 107ee4b:	je     107ee53 <check_input_run+0x12143>
 107ee4d:	mov    (%rax,%r9,4),%r9d
 107ee51:	jmp    107ee59 <check_input_run+0x12149>
 107ee53:	mov    $0xffffffff,%r9d
 107ee59:	mov    0x170(%rsp),%rcx
 107ee61:	mov    %r9d,(%rcx,%rsi,4)
 107ee65:	mov    0x318(%rsp),%r9
 107ee6d:	mov    0x4(%r9,%r15,4),%r9d
 107ee72:	test   %r9d,%r9d
 107ee75:	je     107ee83 <check_input_run+0x12173>
 107ee77:	dec    %r9d
 107ee7a:	mov    (%rax,%r9,4),%r9d
 107ee7e:	inc    %r9d
 107ee81:	jmp    107ee86 <check_input_run+0x12176>
 107ee83:	xor    %r9d,%r9d
 107ee86:	mov    0x168(%rsp),%rcx
 107ee8e:	mov    %r9d,(%rcx,%rsi,4)
 107ee92:	mov    0x190(%rsp),%rcx
 107ee9a:	mov    0x320(%rsp),%r9
 107eea2:	mov    0x4(%r9,%r15,4),%r9d
 107eea7:	mov    %r9d,(%rcx,%rsi,4)
 107eeab:	mov    0x200(%rsp),%rcx
 107eeb3:	mov    0x328(%rsp),%r9
 107eebb:	movzbl 0x1(%r9,%r15,1),%r9d
 107eec1:	mov    %r9b,(%rcx,%rsi,1)
 107eec5:	mov    0x188(%rsp),%rcx
 107eecd:	mov    0x330(%rsp),%r9
 107eed5:	movzbl 0x1(%r9,%r15,1),%r9d
 107eedb:	add    $0x2,%r15
 107eedf:	mov    %r9b,(%rcx,%rsi,1)
 107eee3:	cmp    %r15,%r12
 107eee6:	jne    107ed10 <check_input_run+0x12000>
 107eeec:	testb  $0x1,0xa8(%rsp)
 107eef4:	je     107efe3 <check_input_run+0x122d3>
 107eefa:	mov    0x2f8(%rsp),%r9
 107ef02:	mov    (%rax,%r15,4),%esi
 107ef06:	mov    0x138(%rsp),%rcx
 107ef0e:	mov    $0xffffffff,%r10d
 107ef14:	mov    (%r9,%r15,4),%r9d
 107ef18:	mov    %r9d,(%rbx,%rsi,4)
 107ef1c:	mov    0x300(%rsp),%r9
 107ef24:	mov    (%r9,%r15,4),%r9d
 107ef28:	mov    %r9d,(%rcx,%rsi,4)
 107ef2c:	mov    0x158(%rsp),%rcx
 107ef34:	mov    0x308(%rsp),%r9
 107ef3c:	mov    (%r9,%r15,4),%r9d
 107ef40:	mov    %r9d,(%rcx,%rsi,4)
 107ef44:	mov    0x310(%rsp),%r9
 107ef4c:	mov    (%r9,%r15,4),%r9d
 107ef50:	cmp    %r10,%r9
 107ef53:	je     107ef5b <check_input_run+0x1224b>
 107ef55:	mov    (%rax,%r9,4),%r9d
 107ef59:	jmp    107ef61 <check_input_run+0x12251>
 107ef5b:	mov    $0xffffffff,%r9d
 107ef61:	mov    0x170(%rsp),%rcx
 107ef69:	mov    %r9d,(%rcx,%rsi,4)
 107ef6d:	mov    0x318(%rsp),%r9
 107ef75:	mov    (%r9,%r15,4),%r9d
 107ef79:	test   %r9d,%r9d
 107ef7c:	je     107ef8a <check_input_run+0x1227a>
 107ef7e:	dec    %r9d
 107ef81:	mov    (%rax,%r9,4),%r9d
 107ef85:	inc    %r9d
 107ef88:	jmp    107ef8d <check_input_run+0x1227d>
 107ef8a:	xor    %r9d,%r9d
 107ef8d:	mov    0x168(%rsp),%rcx
 107ef95:	mov    %r9d,(%rcx,%rsi,4)
 107ef99:	mov    0x190(%rsp),%rcx
 107efa1:	mov    0x320(%rsp),%r9
 107efa9:	mov    (%r9,%r15,4),%r9d
 107efad:	mov    %r9d,(%rcx,%rsi,4)
 107efb1:	mov    0x200(%rsp),%rcx
 107efb9:	mov    0x328(%rsp),%r9
 107efc1:	movzbl (%r9,%r15,1),%r9d
 107efc6:	mov    %r9b,(%rcx,%rsi,1)
 107efca:	mov    0x188(%rsp),%rcx
 107efd2:	mov    0x330(%rsp),%r9
 107efda:	movzbl (%r9,%r15,1),%r9d
 107efdf:	mov    %r9b,(%rcx,%rsi,1)
 107efe3:	cmpq   $0x0,0x188(%rsp)
 107efec:	sete   %sil
 107eff0:	or     %sil,0x58(%rsp)
 107eff5:	jne    107f185 <check_input_run+0x12475>
 107effb:	mov    0x60(%rsp),%r15
 107f000:	cmp    $0x1,%r15
 107f004:	adc    $0x0,%r15
 107f008:	xor    %r12d,%r12d
 107f00b:	mov    0x1b0(%rsp),%rsi
 107f013:	mov    (%rsi),%rbp
 107f016:	imul   $0x150,%r12,%rsi
 107f01d:	cmpl   $0x0,0x60(%rbp,%rsi,1)
 107f022:	je     107f179 <check_input_run+0x12469>
 107f028:	mov    0x1a8(%rsp),%rcx
 107f030:	lea    (%r12,%r12,2),%r10
 107f034:	add    %rsi,%rbp
 107f037:	xor    %esi,%esi
 107f039:	shl    $0x4,%r10
 107f03d:	mov    (%rcx,%r12,4),%ecx
 107f041:	mov    %ecx,%r9d
 107f044:	sub    0xa8(%rsp),%r9d
 107f04c:	mov    %rcx,%rdx
 107f04f:	mov    0x68(%rbp),%r14
 107f053:	lea    (%rdx,%rsi,1),%r11d
 107f057:	mov    (%r14,%rsi,4),%r14d
 107f05b:	mov    %r14d,(%rbx,%r11,4)
 107f05f:	mov    0x70(%rbp),%r14
 107f063:	mov    0x98(%rbp),%r8
 107f06a:	cmpb   $0x2,(%r8,%rsi,1)
 107f06f:	mov    (%r14,%rsi,4),%r14d
 107f073:	jne    107f089 <check_input_run+0x12379>
 107f075:	mov    0x860(%rsp),%r8
 107f07d:	mov    0x1d0(%r8),%r8
 107f084:	add    0x14(%r8,%r10,1),%r14d
 107f089:	mov    0x138(%rsp),%rcx
 107f091:	mov    %r14d,(%rcx,%r11,4)
 107f095:	mov    0x158(%rsp),%rcx
 107f09d:	mov    0x78(%rbp),%r8
 107f0a1:	mov    (%r8,%rsi,4),%r8d
 107f0a5:	mov    %r8d,(%rcx,%r11,4)
 107f0a9:	mov    $0xffffffff,%ecx
 107f0ae:	mov    0x80(%rbp),%r8
 107f0b5:	mov    (%r8,%rsi,4),%r14d
 107f0b9:	cmp    %rcx,%r14
 107f0bc:	je     107f0ce <check_input_run+0x123be>
 107f0be:	cmp    0xa8(%rsp),%r14d
 107f0c6:	jae    107f0d6 <check_input_run+0x123c6>
 107f0c8:	mov    (%rax,%r14,4),%r14d
 107f0cc:	jmp    107f0d9 <check_input_run+0x123c9>
 107f0ce:	mov    $0xffffffff,%r14d
 107f0d4:	jmp    107f0d9 <check_input_run+0x123c9>
 107f0d6:	add    %r9d,%r14d
 107f0d9:	mov    0x170(%rsp),%rcx
 107f0e1:	mov    %r14d,(%rcx,%r11,4)
 107f0e5:	mov    0x88(%rbp),%r8
 107f0ec:	mov    (%r8,%rsi,4),%r14d
 107f0f0:	test   %r14d,%r14d
 107f0f3:	je     107f10b <check_input_run+0x123fb>
 107f0f5:	dec    %r14d
 107f0f8:	cmp    0xa8(%rsp),%r14d
 107f100:	jae    107f110 <check_input_run+0x12400>
 107f102:	mov    %r14d,%r8d
 107f105:	mov    (%rax,%r8,4),%r14d
 107f109:	jmp    107f113 <check_input_run+0x12403>
 107f10b:	xor    %r14d,%r14d
 107f10e:	jmp    107f116 <check_input_run+0x12406>
 107f110:	add    %r9d,%r14d
 107f113:	inc    %r14d
 107f116:	mov    0x168(%rsp),%rcx
 107f11e:	mov    %r14d,(%rcx,%r11,4)
 107f122:	mov    0x190(%rsp),%rcx
 107f12a:	mov    0x90(%rbp),%r8
 107f131:	mov    (%r8,%rsi,4),%r8d
 107f135:	mov    %r8d,(%rcx,%r11,4)
 107f139:	mov    0x200(%rsp),%rcx
 107f141:	mov    0x98(%rbp),%r8
 107f148:	movzbl (%r8,%rsi,1),%r8d
 107f14d:	mov    %r8b,(%rcx,%r11,1)
 107f151:	mov    0x188(%rsp),%rcx
 107f159:	mov    0xa0(%rbp),%r8
 107f160:	movzbl (%r8,%rsi,1),%r8d
 107f165:	inc    %rsi
 107f168:	mov    %r8b,(%rcx,%r11,1)
 107f16c:	mov    0x60(%rbp),%r8d
 107f170:	cmp    %r8,%rsi
 107f173:	jb     107f04f <check_input_run+0x1233f>
 107f179:	inc    %r12
 107f17c:	cmp    %r15,%r12
 107f17f:	jne    107f00b <check_input_run+0x122fb>
 107f185:	cmpq   $0x0,0x188(%rsp)
 107f18e:	je     1077c8e <check_input_run+0xaf7e>
 107f194:	cmpl   $0x0,0x2f0(%rsp)
 107f19c:	je     107f1c0 <check_input_run+0x124b0>
 107f19e:	xor    %ecx,%ecx
 107f1a0:	mov    0x2e8(%rsp),%rdx
 107f1a8:	mov    (%rdx,%rcx,4),%esi
 107f1ab:	mov    (%rax,%rsi,4),%esi
 107f1ae:	mov    %esi,(%rdx,%rcx,4)
 107f1b1:	inc    %rcx
 107f1b4:	mov    0x2f0(%rsp),%edx
 107f1bb:	cmp    %rdx,%rcx
 107f1be:	jb     107f1a0 <check_input_run+0x12490>
 107f1c0:	mov    0x2d8(%rsp),%edx
 107f1c7:	test   %rdx,%rdx
 107f1ca:	je     107f350 <check_input_run+0x12640>
 107f1d0:	lea    (%rdx,%rdx,2),%r15
 107f1d4:	mov    %r15d,%ecx
 107f1d7:	and    $0x7,%ecx
 107f1da:	cmp    $0x3,%edx
 107f1dd:	jae    107f1e6 <check_input_run+0x124d6>
 107f1df:	xor    %edx,%edx
 107f1e1:	jmp    107f324 <check_input_run+0x12614>
 107f1e6:	and    $0xfffffffffffffff8,%r15
 107f1ea:	xor    %edx,%edx
 107f1ec:	mov    0x2d0(%rsp),%rsi
 107f1f4:	mov    $0x0,%r10d
 107f1fa:	mov    (%rsi,%rdx,4),%r9d
 107f1fe:	test   %r9d,%r9d
 107f201:	je     107f20d <check_input_run+0x124fd>
 107f203:	dec    %r9d
 107f206:	mov    (%rax,%r9,4),%r10d
 107f20a:	inc    %r10d
 107f20d:	mov    %r10d,(%rsi,%rdx,4)
 107f211:	mov    $0x0,%r11d
 107f217:	xor    %esi,%esi
 107f219:	mov    0x2d0(%rsp),%r9
 107f221:	mov    0x4(%r9,%rdx,4),%r10d
 107f226:	test   %r10d,%r10d
 107f229:	je     107f235 <check_input_run+0x12525>
 107f22b:	dec    %r10d
 107f22e:	mov    (%rax,%r10,4),%r11d
 107f232:	inc    %r11d
 107f235:	mov    %r11d,0x4(%r9,%rdx,4)
 107f23a:	mov    0x2d0(%rsp),%r9
 107f242:	mov    0x8(%r9,%rdx,4),%r10d
 107f247:	test   %r10d,%r10d
 107f24a:	je     107f255 <check_input_run+0x12545>
 107f24c:	dec    %r10d
 107f24f:	mov    (%rax,%r10,4),%esi
 107f253:	inc    %esi
 107f255:	mov    %esi,0x8(%r9,%rdx,4)
 107f25a:	mov    $0x0,%r11d
 107f260:	xor    %esi,%esi
 107f262:	mov    0x2d0(%rsp),%r9
 107f26a:	mov    0xc(%r9,%rdx,4),%r10d
 107f26f:	test   %r10d,%r10d
 107f272:	je     107f27e <check_input_run+0x1256e>
 107f274:	dec    %r10d
 107f277:	mov    (%rax,%r10,4),%r11d
 107f27b:	inc    %r11d
 107f27e:	mov    %r11d,0xc(%r9,%rdx,4)
 107f283:	mov    0x2d0(%rsp),%r9
 107f28b:	mov    0x10(%r9,%rdx,4),%r10d
 107f290:	test   %r10d,%r10d
 107f293:	je     107f29e <check_input_run+0x1258e>
 107f295:	dec    %r10d
 107f298:	mov    (%rax,%r10,4),%esi
 107f29c:	inc    %esi
 107f29e:	mov    %esi,0x10(%r9,%rdx,4)
 107f2a3:	mov    $0x0,%r11d
 107f2a9:	xor    %esi,%esi
 107f2ab:	mov    0x2d0(%rsp),%r9
 107f2b3:	mov    0x14(%r9,%rdx,4),%r10d
 107f2b8:	test   %r10d,%r10d
 107f2bb:	je     107f2c7 <check_input_run+0x125b7>
 107f2bd:	dec    %r10d
 107f2c0:	mov    (%rax,%r10,4),%r11d
 107f2c4:	inc    %r11d
 107f2c7:	mov    %r11d,0x14(%r9,%rdx,4)
 107f2cc:	mov    0x2d0(%rsp),%r9
 107f2d4:	mov    0x18(%r9,%rdx,4),%r10d
 107f2d9:	test   %r10d,%r10d
 107f2dc:	je     107f2e7 <check_input_run+0x125d7>
 107f2de:	dec    %r10d
 107f2e1:	mov    (%rax,%r10,4),%esi
 107f2e5:	inc    %esi
 107f2e7:	mov    %esi,0x18(%r9,%rdx,4)
 107f2ec:	mov    0x2d0(%rsp),%rsi
 107f2f4:	mov    0x1c(%rsi,%rdx,4),%r9d
 107f2f9:	test   %r9d,%r9d
 107f2fc:	je     107f30a <check_input_run+0x125fa>
 107f2fe:	dec    %r9d
 107f301:	mov    (%rax,%r9,4),%r9d
 107f305:	inc    %r9d
 107f308:	jmp    107f30d <check_input_run+0x125fd>
 107f30a:	xor    %r9d,%r9d
 107f30d:	mov    %r9d,0x1c(%rsi,%rdx,4)
 107f312:	add    $0x8,%rdx
 107f316:	cmp    %rdx,%r15
 107f319:	jne    107f1ec <check_input_run+0x124dc>
 107f31f:	test   %rcx,%rcx
 107f322:	je     107f350 <check_input_run+0x12640>
 107f324:	mov    0x2d0(%rsp),%rsi
 107f32c:	mov    (%rsi,%rdx,4),%r9d
 107f330:	test   %r9d,%r9d
 107f333:	je     107f341 <check_input_run+0x12631>
 107f335:	dec    %r9d
 107f338:	mov    (%rax,%r9,4),%r9d
 107f33c:	inc    %r9d
 107f33f:	jmp    107f344 <check_input_run+0x12634>
 107f341:	xor    %r9d,%r9d
 107f344:	mov    %r9d,(%rsi,%rdx,4)
 107f348:	inc    %rdx
 107f34b:	dec    %rcx
 107f34e:	jne    107f324 <check_input_run+0x12614>
 107f350:	mov    0x138(%rsp),%rax
 107f358:	mov    0x158(%rsp),%rdx
 107f360:	mov    0x170(%rsp),%rcx
 107f368:	mov    %rbx,0x2f8(%rsp)
 107f370:	mov    %rax,0x300(%rsp)
 107f378:	mov    %rdx,0x308(%rsp)
 107f380:	mov    %rcx,0x310(%rsp)
 107f388:	mov    0x168(%rsp),%rdx
 107f390:	mov    0x190(%rsp),%rcx
 107f398:	mov    %rdx,0x318(%rsp)
 107f3a0:	mov    %rcx,0x320(%rsp)
 107f3a8:	mov    0x200(%rsp),%rdx
 107f3b0:	mov    0x188(%rsp),%rcx
 107f3b8:	mov    %rdx,0x328(%rsp)
 107f3c0:	mov    %rcx,0x330(%rsp)
 107f3c8:	mov    %edi,0x2e0(%rsp)
 107f3cf:	mov    0x2c8(%rsp),%rax
 107f3d7:	mov    (%rax),%rsi
 107f3da:	mov    0x8(%rax),%rdx
 107f3de:	lea    0x3(%rdx,%rsi,1),%rcx
 107f3e3:	add    %rsi,%rdx
 107f3e6:	and    $0xfffffffffffffffc,%rcx
 107f3ea:	cmp    %rdx,%rcx
 107f3ed:	jae    107f3fd <check_input_run+0x126ed>
 107f3ef:	movq   $0x0,0xa8(%rsp)
 107f3fb:	jmp    107f446 <check_input_run+0x12736>
 107f3fd:	mov    %rcx,%rdx
 107f400:	sub    %rsi,%rdx
 107f403:	mov    0x10(%rax),%rsi
 107f407:	movq   $0x0,0xa8(%rsp)
 107f413:	sub    %rdx,%rsi
 107f416:	jb     107f446 <check_input_run+0x12736>
 107f418:	mov    0x860(%rsp),%rdi
 107f420:	mov    0x8(%rdi),%rdi
 107f424:	mov    0xa4(%rdi),%edi
 107f42a:	lea    0x4(,%rdi,4),%rdi
 107f432:	cmp    %rsi,%rdi
 107f435:	ja     107f446 <check_input_run+0x12736>
 107f437:	add    %rdi,%rdx
 107f43a:	mov    %rcx,0xa8(%rsp)
 107f442:	mov    %rdx,0x8(%rax)
 107f446:	cmpq   $0x0,0x600(%rsp)
 107f44f:	je     107f471 <check_input_run+0x12761>
 107f451:	mov    0x2c8(%rsp),%rax
 107f459:	mov    (%rax),%rsi
 107f45c:	mov    0x8(%rax),%rdx
 107f460:	lea    0x3(%rdx,%rsi,1),%rcx
 107f465:	add    %rsi,%rdx
 107f468:	and    $0xfffffffffffffffc,%rcx
 107f46c:	cmp    %rdx,%rcx
 107f46f:	jae    107f47c <check_input_run+0x1276c>
 107f471:	movq   $0x0,0x58(%rsp)
 107f47a:	jmp    107f4bf <check_input_run+0x127af>
 107f47c:	mov    %rcx,%rdx
 107f47f:	sub    %rsi,%rdx
 107f482:	mov    0x10(%rax),%rsi
 107f486:	movq   $0x0,0x58(%rsp)
 107f48f:	sub    %rdx,%rsi
 107f492:	jb     107f4bf <check_input_run+0x127af>
 107f494:	mov    0x860(%rsp),%rdi
 107f49c:	mov    0x8(%rdi),%rdi
 107f4a0:	mov    0xa4(%rdi),%edi
 107f4a6:	lea    0x4(,%rdi,4),%rdi
 107f4ae:	cmp    %rsi,%rdi
 107f4b1:	ja     107f4bf <check_input_run+0x127af>
 107f4b3:	add    %rdi,%rdx
 107f4b6:	mov    %rcx,0x58(%rsp)
 107f4bb:	mov    %rdx,0x8(%rax)
 107f4bf:	cmpq   $0x0,0xa8(%rsp)
 107f4c8:	je     1077c8e <check_input_run+0xaf7e>
 107f4ce:	cmpq   $0x0,0x58(%rsp)
 107f4d4:	jne    107f4e5 <check_input_run+0x127d5>
 107f4d6:	cmpq   $0x0,0x600(%rsp)
 107f4df:	jne    1077c8e <check_input_run+0xaf7e>
 107f4e5:	mov    0x860(%rsp),%rax
 107f4ed:	mov    0xa8(%rsp),%rdi
 107f4f5:	mov    $0xff,%esi
 107f4fa:	mov    0x8(%rax),%rax
 107f4fe:	mov    0xa4(%rax),%eax
 107f504:	lea    0x4(,%rax,4),%rdx
 107f50c:	vzeroupper
 107f50f:	call   788120 <memset@plt>
 107f514:	cmpq   $0x0,0x58(%rsp)
 107f51a:	je     107f542 <check_input_run+0x12832>
 107f51c:	mov    0x860(%rsp),%rax
 107f524:	mov    0x58(%rsp),%rdi
 107f529:	xor    %esi,%esi
 107f52b:	mov    0x8(%rax),%rax
 107f52f:	mov    0xa4(%rax),%eax
 107f535:	lea    0x4(,%rax,4),%rdx
 107f53d:	call   788120 <memset@plt>
 107f542:	mov    0xd0(%rsp),%rax
 107f54a:	cmpl   $0x2,(%rax)
 107f54d:	jb     107f614 <check_input_run+0x12904>
 107f553:	mov    $0x1,%eax
 107f558:	mov    0x5f0(%rsp),%rcx
 107f560:	cmpq   $0x0,0x48(%rsp)
 107f566:	mov    (%rcx,%rax,4),%ecx
 107f569:	je     107f589 <check_input_run+0x12879>
 107f56b:	mov    0x48(%rsp),%rdx
 107f570:	mov    0x14(%rdx),%edi
 107f573:	mov    %rax,%rsi
 107f576:	sub    %rdi,%rsi
 107f579:	jae    107f5ac <check_input_run+0x1289c>
 107f57b:	mov    0x8(%rdx),%rdx
 107f57f:	test   %rdx,%rdx
 107f582:	jne    107f570 <check_input_run+0x12860>
 107f584:	mov    %rax,%rdx
 107f587:	jmp    107f5b3 <check_input_run+0x128a3>
 107f589:	mov    0xa8(%rsp),%rdx
 107f591:	cmpq   $0x0,0x58(%rsp)
 107f597:	mov    %ecx,(%rdx,%rax,4)
 107f59a:	je     107f5fe <check_input_run+0x128ee>
 107f59c:	mov    0x600(%rsp),%rcx
 107f5a4:	mov    %rax,%rdx
 107f5a7:	mov    (%rcx,%rax,4),%ecx
 107f5aa:	jmp    107f5f6 <check_input_run+0x128e6>
 107f5ac:	mov    0x20(%rdx),%rdx
 107f5b0:	mov    (%rdx,%rsi,4),%edx
 107f5b3:	mov    0xa8(%rsp),%rsi
 107f5bb:	cmpq   $0x0,0x58(%rsp)
 107f5c1:	mov    %ecx,(%rsi,%rdx,4)
 107f5c4:	je     107f5fe <check_input_run+0x128ee>
 107f5c6:	mov    0x600(%rsp),%rcx
 107f5ce:	mov    0x48(%rsp),%rdx
 107f5d3:	mov    (%rcx,%rax,4),%ecx
 107f5d6:	mov    0x14(%rdx),%edi
 107f5d9:	mov    %rax,%rsi
 107f5dc:	sub    %rdi,%rsi
 107f5df:	jae    107f5ef <check_input_run+0x128df>
 107f5e1:	mov    0x8(%rdx),%rdx
 107f5e5:	test   %rdx,%rdx
 107f5e8:	jne    107f5d6 <check_input_run+0x128c6>
 107f5ea:	mov    %rax,%rdx
 107f5ed:	jmp    107f5f6 <check_input_run+0x128e6>
 107f5ef:	mov    0x20(%rdx),%rdx
 107f5f3:	mov    (%rdx,%rsi,4),%edx
 107f5f6:	mov    0x58(%rsp),%rsi
 107f5fb:	mov    %ecx,(%rsi,%rdx,4)
 107f5fe:	mov    0xd0(%rsp),%rcx
 107f606:	inc    %rax
 107f609:	mov    (%rcx),%ecx
 107f60b:	cmp    %rcx,%rax
 107f60e:	jb     107f558 <check_input_run+0x12848>
 107f614:	cmpl   $0x0,0x60(%rsp)
 107f619:	je     107f7fd <check_input_run+0x12aed>
 107f61f:	cmpl   $0x1,0x60(%rsp)
 107f624:	jne    107f62d <check_input_run+0x1291d>
 107f626:	xor    %eax,%eax
 107f628:	jmp    107f76c <check_input_run+0x12a5c>
 107f62d:	mov    0x60(%rsp),%rcx
 107f632:	and    $0xfffffffe,%ecx
 107f635:	xor    %eax,%eax
 107f637:	mov    0x1b0(%rsp),%rdx
 107f63f:	imul   $0x150,%rax,%rdi
 107f646:	lea    0x1(%rax),%rsi
 107f64a:	mov    (%rdx),%rdx
 107f64d:	mov    0x54(%rdx,%rdi,1),%r9d
 107f652:	test   %r9d,%r9d
 107f655:	je     107f6c8 <check_input_run+0x129b8>
 107f657:	add    %rdi,%rdx
 107f65a:	lea    (%rsi,%rsi,2),%rdi
 107f65e:	xor    %r8d,%r8d
 107f661:	shl    $0x4,%rdi
 107f665:	add    0x48(%rsp),%rdi
 107f66a:	mov    0x28(%rdi),%r10
 107f66e:	cmpb   $0x0,(%r10,%r8,1)
 107f673:	jne    107f6bd <check_input_run+0x129ad>
 107f675:	mov    0xd0(%rsp),%r10
 107f67d:	mov    0x58(%rdx),%r9
 107f681:	mov    %rdi,%r11
 107f684:	mov    (%r10),%r10d
 107f687:	mov    (%r9,%r8,4),%r9d
 107f68b:	add    %r8d,%r10d
 107f68e:	mov    %r10d,%r14d
 107f691:	sub    0x14(%r11),%r14d
 107f695:	jae    107f6a2 <check_input_run+0x12992>
 107f697:	mov    0x8(%r11),%r11
 107f69b:	test   %r11,%r11
 107f69e:	jne    107f68e <check_input_run+0x1297e>
 107f6a0:	jmp    107f6aa <check_input_run+0x1299a>
 107f6a2:	mov    0x20(%r11),%r10
 107f6a6:	mov    (%r10,%r14,4),%r10d
 107f6aa:	mov    0xa8(%rsp),%r11
 107f6b2:	mov    %r10d,%r10d
 107f6b5:	mov    %r9d,(%r11,%r10,4)
 107f6b9:	mov    0x54(%rdx),%r9d
 107f6bd:	inc    %r8
 107f6c0:	mov    %r9d,%r10d
 107f6c3:	cmp    %r10,%r8
 107f6c6:	jb     107f66a <check_input_run+0x1295a>
 107f6c8:	mov    0x1b0(%rsp),%rdx
 107f6d0:	imul   $0x150,%rsi,%rsi
 107f6d7:	add    $0x2,%rax
 107f6db:	mov    (%rdx),%rdx
 107f6de:	mov    0x54(%rdx,%rsi,1),%r8d
 107f6e3:	test   %r8d,%r8d
 107f6e6:	je     107f758 <check_input_run+0x12a48>
 107f6e8:	add    %rsi,%rdx
 107f6eb:	lea    (%rax,%rax,2),%rsi
 107f6ef:	xor    %edi,%edi
 107f6f1:	shl    $0x4,%rsi
 107f6f5:	add    0x48(%rsp),%rsi
 107f6fa:	mov    0x28(%rsi),%r9
 107f6fe:	cmpb   $0x0,(%r9,%rdi,1)
 107f703:	jne    107f74d <check_input_run+0x12a3d>
 107f705:	mov    0xd0(%rsp),%r9
 107f70d:	mov    0x58(%rdx),%r8
 107f711:	mov    %rsi,%r10
 107f714:	mov    (%r9),%r9d
 107f717:	mov    (%r8,%rdi,4),%r8d
 107f71b:	add    %edi,%r9d
 107f71e:	mov    %r9d,%r11d
 107f721:	sub    0x14(%r10),%r11d
 107f725:	jae    107f732 <check_input_run+0x12a22>
 107f727:	mov    0x8(%r10),%r10
 107f72b:	test   %r10,%r10
 107f72e:	jne    107f71e <check_input_run+0x12a0e>
 107f730:	jmp    107f73a <check_input_run+0x12a2a>
 107f732:	mov    0x20(%r10),%r9
 107f736:	mov    (%r9,%r11,4),%r9d
 107f73a:	mov    0xa8(%rsp),%r10
 107f742:	mov    %r9d,%r9d
 107f745:	mov    %r8d,(%r10,%r9,4)
 107f749:	mov    0x54(%rdx),%r8d
 107f74d:	inc    %rdi
 107f750:	mov    %r8d,%r9d
 107f753:	cmp    %r9,%rdi
 107f756:	jb     107f6fa <check_input_run+0x129ea>
 107f758:	cmp    %rcx,%rax
 107f75b:	jne    107f637 <check_input_run+0x12927>
 107f761:	testb  $0x1,0x60(%rsp)
 107f766:	je     107f7fd <check_input_run+0x12aed>
 107f76c:	mov    0x1b0(%rsp),%rcx
 107f774:	imul   $0x150,%rax,%rdx
 107f77b:	mov    (%rcx),%rcx
 107f77e:	mov    0x54(%rcx,%rdx,1),%edi
 107f782:	test   %edi,%edi
 107f784:	je     107f7fd <check_input_run+0x12aed>
 107f786:	mov    0x48(%rsp),%r8
 107f78b:	lea    (%rax,%rax,2),%rsi
 107f78f:	add    %rdx,%rcx
 107f792:	shl    $0x4,%rsi
 107f796:	lea    0x30(%r8,%rsi,1),%rdx
 107f79b:	lea    (%r8,%rsi,1),%rax
 107f79f:	xor    %esi,%esi
 107f7a1:	mov    0x58(%rax),%r8
 107f7a5:	cmpb   $0x0,(%r8,%rsi,1)
 107f7aa:	jne    107f7f2 <check_input_run+0x12ae2>
 107f7ac:	mov    0xd0(%rsp),%r8
 107f7b4:	mov    0x58(%rcx),%rdi
 107f7b8:	mov    %rdx,%r9
 107f7bb:	mov    (%r8),%r8d
 107f7be:	mov    (%rdi,%rsi,4),%edi
 107f7c1:	add    %esi,%r8d
 107f7c4:	mov    %r8d,%r10d
 107f7c7:	sub    0x14(%r9),%r10d
 107f7cb:	jae    107f7d8 <check_input_run+0x12ac8>
 107f7cd:	mov    0x8(%r9),%r9
 107f7d1:	test   %r9,%r9
 107f7d4:	jne    107f7c4 <check_input_run+0x12ab4>
 107f7d6:	jmp    107f7e0 <check_input_run+0x12ad0>
 107f7d8:	mov    0x20(%r9),%r8
 107f7dc:	mov    (%r8,%r10,4),%r8d
 107f7e0:	mov    0xa8(%rsp),%r9
 107f7e8:	mov    %r8d,%r8d
 107f7eb:	mov    %edi,(%r9,%r8,4)
 107f7ef:	mov    0x54(%rcx),%edi
 107f7f2:	inc    %rsi
 107f7f5:	mov    %edi,%r8d
 107f7f8:	cmp    %r8,%rsi
 107f7fb:	jb     107f7a1 <check_input_run+0x12a91>
 107f7fd:	mov    0x860(%rsp),%rax
 107f805:	mov    0x2aa38(%rax),%rcx
 107f80c:	mov    0x2aa40(%rax),%rax
 107f813:	lea    0x3(%rax,%rcx,1),%rdx
 107f818:	add    %rcx,%rax
 107f81b:	and    $0xfffffffffffffffc,%rdx
 107f81f:	mov    %rdx,0xd0(%rsp)
 107f827:	cmp    %rax,%rdx
 107f82a:	jb     1077c8e <check_input_run+0xaf7e>
 107f830:	mov    0xd0(%rsp),%rax
 107f838:	sub    %rcx,%rax
 107f83b:	mov    0x860(%rsp),%rcx
 107f843:	mov    0x2aa48(%rcx),%rcx
 107f84a:	sub    %rax,%rcx
 107f84d:	jb     1077c8e <check_input_run+0xaf7e>
 107f853:	mov    0xe8(%rsp),%rdx
 107f85b:	lea    0x4(,%rdx,4),%rdx
 107f863:	cmp    %rcx,%rdx
 107f866:	ja     1077c8e <check_input_run+0xaf7e>
 107f86c:	add    %rdx,%rax
 107f86f:	mov    0x860(%rsp),%rcx
 107f877:	cmpq   $0x0,0xd0(%rsp)
 107f880:	mov    %rax,0x2aa40(%rcx)
 107f887:	je     1077c8e <check_input_run+0xaf7e>
 107f88d:	mov    0xd0(%rsp),%rdi
 107f895:	xor    %esi,%esi
 107f897:	call   788120 <memset@plt>
 107f89c:	cmpl   $0x0,0x60(%rsp)
 107f8a1:	je     107fa20 <check_input_run+0x12d10>
 107f8a7:	cmpl   $0x1,0x60(%rsp)
 107f8ac:	jne    107f8b5 <check_input_run+0x12ba5>
 107f8ae:	xor    %eax,%eax
 107f8b0:	jmp    107f9b2 <check_input_run+0x12ca2>
 107f8b5:	mov    0x60(%rsp),%rcx
 107f8ba:	and    $0xfffffffe,%ecx
 107f8bd:	xor    %eax,%eax
 107f8bf:	mov    0x860(%rsp),%rdx
 107f8c7:	lea    (%rax,%rax,2),%rdi
 107f8cb:	shl    $0x4,%rdi
 107f8cf:	mov    0x1d0(%rdx),%rsi
 107f8d6:	mov    (%rsi,%rdi,1),%edx
 107f8d9:	cmp    0x4(%rsi,%rdi,1),%edx
 107f8dd:	ja     107f8fd <check_input_run+0x12bed>
 107f8df:	add    %rdi,%rsi
 107f8e2:	lea    0x1(%rax),%edi
 107f8e5:	mov    0xd0(%rsp),%r9
 107f8ed:	mov    %edx,%r8d
 107f8f0:	inc    %edx
 107f8f2:	mov    %edi,(%r9,%r8,4)
 107f8f6:	cmp    0x4(%rsi),%edx
 107f8f9:	jbe    107f8e5 <check_input_run+0x12bd5>
 107f8fb:	mov    (%rsi),%edx
 107f8fd:	mov    0x580(%rsp),%rsi
 107f905:	mov    %edx,%edx
 107f907:	mov    (%rsi,%rdx,4),%esi
 107f90a:	lea    0x1(%rax),%rdx
 107f90e:	cmp    $0xffffffff,%esi
 107f911:	je     107f930 <check_input_run+0x12c20>
 107f913:	mov    0xd0(%rsp),%rdi
 107f91b:	mov    %esi,%esi
 107f91d:	mov    %edx,(%rdi,%rsi,4)
 107f920:	mov    0x588(%rsp),%rdi
 107f928:	mov    (%rdi,%rsi,4),%esi
 107f92b:	cmp    $0xffffffff,%esi
 107f92e:	jne    107f913 <check_input_run+0x12c03>
 107f930:	mov    0x860(%rsp),%rsi
 107f938:	lea    (%rdx,%rdx,2),%r8
 107f93c:	shl    $0x4,%r8
 107f940:	mov    0x1d0(%rsi),%rdi
 107f947:	mov    (%rdi,%r8,1),%esi
 107f94b:	cmp    0x4(%rdi,%r8,1),%esi
 107f950:	ja     107f96f <check_input_run+0x12c5f>
 107f952:	add    %r8,%rdi
 107f955:	inc    %edx
 107f957:	mov    0xd0(%rsp),%r9
 107f95f:	mov    %esi,%r8d
 107f962:	inc    %esi
 107f964:	mov    %edx,(%r9,%r8,4)
 107f968:	cmp    0x4(%rdi),%esi
 107f96b:	jbe    107f957 <check_input_run+0x12c47>
 107f96d:	mov    (%rdi),%esi
 107f96f:	mov    0x580(%rsp),%rdx
 107f977:	mov    %esi,%esi
 107f979:	add    $0x2,%rax
 107f97d:	mov    (%rdx,%rsi,4),%edx
 107f980:	cmp    $0xffffffff,%edx
 107f983:	je     107f9a2 <check_input_run+0x12c92>
 107f985:	mov    0xd0(%rsp),%rsi
 107f98d:	mov    %edx,%edx
 107f98f:	mov    %eax,(%rsi,%rdx,4)
 107f992:	mov    0x588(%rsp),%rsi
 107f99a:	mov    (%rsi,%rdx,4),%edx
 107f99d:	cmp    $0xffffffff,%edx
 107f9a0:	jne    107f985 <check_input_run+0x12c75>
 107f9a2:	cmp    %rcx,%rax
 107f9a5:	jne    107f8bf <check_input_run+0x12baf>
 107f9ab:	testb  $0x1,0x60(%rsp)
 107f9b0:	je     107fa20 <check_input_run+0x12d10>
 107f9b2:	mov    0x860(%rsp),%rcx
 107f9ba:	lea    (%rax,%rax,2),%rsi
 107f9be:	shl    $0x4,%rsi
 107f9c2:	mov    0x1d0(%rcx),%rdx
 107f9c9:	mov    (%rdx,%rsi,1),%ecx
 107f9cc:	cmp    0x4(%rdx,%rsi,1),%ecx
 107f9d0:	ja     107f9ef <check_input_run+0x12cdf>
 107f9d2:	mov    0xd0(%rsp),%r8
 107f9da:	add    %rsi,%rdx
 107f9dd:	lea    0x1(%rax),%esi
 107f9e0:	mov    %ecx,%edi
 107f9e2:	mov    %esi,(%r8,%rdi,4)
 107f9e6:	inc    %ecx
 107f9e8:	cmp    0x4(%rdx),%ecx
 107f9eb:	jbe    107f9e0 <check_input_run+0x12cd0>
 107f9ed:	mov    (%rdx),%ecx
 107f9ef:	mov    0x580(%rsp),%rdx
 107f9f7:	mov    %ecx,%ecx
 107f9f9:	mov    (%rdx,%rcx,4),%ecx
 107f9fc:	cmp    $0xffffffff,%ecx
 107f9ff:	je     107fa20 <check_input_run+0x12d10>
 107fa01:	inc    %eax
 107fa03:	mov    0xd0(%rsp),%rdx
 107fa0b:	mov    %ecx,%ecx
 107fa0d:	mov    %eax,(%rdx,%rcx,4)
 107fa10:	mov    0x588(%rsp),%rdx
 107fa18:	mov    (%rdx,%rcx,4),%ecx
 107fa1b:	cmp    $0xffffffff,%ecx
 107fa1e:	jne    107fa03 <check_input_run+0x12cf3>
 107fa20:	mov    0x28(%rsp),%rbx
 107fa25:	mov    $0xffffffff,%ecx
 107fa2a:	cmp    $0x1,%ebx
 107fa2d:	adc    $0x0,%ebx
 107fa30:	xor    %eax,%eax
 107fa32:	xor    %edx,%edx
 107fa34:	mov    0xd0(%rsp),%rsi
 107fa3c:	mov    0xc0(%rsp),%r9
 107fa44:	mov    $0x0,%r11d
 107fa4a:	mov    (%rsi,%rdx,4),%edi
 107fa4d:	mov    0x240(%r9),%r9
 107fa54:	cmp    $0x1,%edi
 107fa57:	mov    %edi,%esi
 107fa59:	mov    %edi,%r8d
 107fa5c:	mov    (%r9,%rdx,4),%r10d
 107fa60:	adc    $0x0,%esi
 107fa63:	sub    $0x1,%r8d
 107fa67:	cmovb  %eax,%esi
 107fa6a:	lea    (%rsi,%rsi,2),%rsi
 107fa6e:	shl    $0x4,%rsi
 107fa72:	add    0x48(%rsp),%rsi
 107fa77:	test   %r10d,%r10d
 107fa7a:	je     107fab2 <check_input_run+0x12da2>
 107fa7c:	mov    %r10d,%r11d
 107fa7f:	shr    $0x3,%r11d
 107fa83:	cmpq   $0x0,0x48(%rsp)
 107fa89:	je     107faaa <check_input_run+0x12d9a>
 107fa8b:	mov    %rsi,%r14
 107fa8e:	mov    %r11d,%r15d
 107fa91:	sub    0x10(%r14),%r15d
 107fa95:	jae    107faa2 <check_input_run+0x12d92>
 107fa97:	mov    0x8(%r14),%r14
 107fa9b:	test   %r14,%r14
 107fa9e:	jne    107fa8e <check_input_run+0x12d7e>
 107faa0:	jmp    107faaa <check_input_run+0x12d9a>
 107faa2:	mov    0x18(%r14),%r11
 107faa6:	mov    (%r11,%r15,4),%r11d
 107faaa:	and    $0x7,%r10d
 107faae:	lea    (%r10,%r11,8),%r11d
 107fab2:	mov    %r11d,(%r9,%rdx,4)
 107fab6:	mov    $0x0,%ebp
 107fabb:	xor    %r9d,%r9d
 107fabe:	mov    0x348(%rsp),%r10
 107fac6:	mov    (%r10,%rdx,4),%r11d
 107faca:	test   %r11d,%r11d
 107facd:	je     107fb05 <check_input_run+0x12df5>
 107facf:	mov    %r11d,%r14d
 107fad2:	shr    $0x3,%r14d
 107fad6:	cmpq   $0x0,0x48(%rsp)
 107fadc:	je     107fafd <check_input_run+0x12ded>
 107fade:	mov    %rsi,%r15
 107fae1:	mov    %r14d,%r12d
 107fae4:	sub    0x10(%r15),%r12d
 107fae8:	jae    107faf5 <check_input_run+0x12de5>
 107faea:	mov    0x8(%r15),%r15
 107faee:	test   %r15,%r15
 107faf1:	jne    107fae1 <check_input_run+0x12dd1>
 107faf3:	jmp    107fafd <check_input_run+0x12ded>
 107faf5:	mov    0x18(%r15),%r14
 107faf9:	mov    (%r14,%r12,4),%r14d
 107fafd:	and    $0x7,%r11d
 107fb01:	lea    (%r11,%r14,8),%ebp
 107fb05:	mov    %ebp,(%r10,%rdx,4)
 107fb09:	mov    0x398(%rsp),%r10
 107fb11:	mov    (%r10,%rdx,4),%r11d
 107fb15:	test   %r11d,%r11d
 107fb18:	je     107fb50 <check_input_run+0x12e40>
 107fb1a:	mov    %r11d,%r9d
 107fb1d:	shr    $0x3,%r9d
 107fb21:	cmpq   $0x0,0x48(%rsp)
 107fb27:	je     107fb48 <check_input_run+0x12e38>
 107fb29:	mov    %rsi,%r14
 107fb2c:	mov    %r9d,%r15d
 107fb2f:	sub    0x10(%r14),%r15d
 107fb33:	jae    107fb40 <check_input_run+0x12e30>
 107fb35:	mov    0x8(%r14),%r14
 107fb39:	test   %r14,%r14
 107fb3c:	jne    107fb2c <check_input_run+0x12e1c>
 107fb3e:	jmp    107fb48 <check_input_run+0x12e38>
 107fb40:	mov    0x18(%r14),%r9
 107fb44:	mov    (%r9,%r15,4),%r9d
 107fb48:	and    $0x7,%r11d
 107fb4c:	lea    (%r11,%r9,8),%r9d
 107fb50:	mov    %r9d,(%r10,%rdx,4)
 107fb54:	mov    $0x0,%ebp
 107fb59:	xor    %r9d,%r9d
 107fb5c:	mov    0x408(%rsp),%r10
 107fb64:	mov    (%r10,%rdx,4),%r11d
 107fb68:	test   %r11d,%r11d
 107fb6b:	je     107fba3 <check_input_run+0x12e93>
 107fb6d:	mov    %r11d,%r14d
 107fb70:	shr    $0x3,%r14d
 107fb74:	cmpq   $0x0,0x48(%rsp)
 107fb7a:	je     107fb9b <check_input_run+0x12e8b>
 107fb7c:	mov    %rsi,%r15
 107fb7f:	mov    %r14d,%r12d
 107fb82:	sub    0x10(%r15),%r12d
 107fb86:	jae    107fb93 <check_input_run+0x12e83>
 107fb88:	mov    0x8(%r15),%r15
 107fb8c:	test   %r15,%r15
 107fb8f:	jne    107fb7f <check_input_run+0x12e6f>
 107fb91:	jmp    107fb9b <check_input_run+0x12e8b>
 107fb93:	mov    0x18(%r15),%r14
 107fb97:	mov    (%r14,%r12,4),%r14d
 107fb9b:	and    $0x7,%r11d
 107fb9f:	lea    (%r11,%r14,8),%ebp
 107fba3:	mov    %ebp,(%r10,%rdx,4)
 107fba7:	mov    0x450(%rsp),%r10
 107fbaf:	mov    (%r10,%rdx,4),%r11d
 107fbb3:	test   %r11d,%r11d
 107fbb6:	je     107fbee <check_input_run+0x12ede>
 107fbb8:	mov    %r11d,%r9d
 107fbbb:	shr    $0x3,%r9d
 107fbbf:	cmpq   $0x0,0x48(%rsp)
 107fbc5:	je     107fbe6 <check_input_run+0x12ed6>
 107fbc7:	mov    %rsi,%r14
 107fbca:	mov    %r9d,%r15d
 107fbcd:	sub    0x10(%r14),%r15d
 107fbd1:	jae    107fbde <check_input_run+0x12ece>
 107fbd3:	mov    0x8(%r14),%r14
 107fbd7:	test   %r14,%r14
 107fbda:	jne    107fbca <check_input_run+0x12eba>
 107fbdc:	jmp    107fbe6 <check_input_run+0x12ed6>
 107fbde:	mov    0x18(%r14),%r9
 107fbe2:	mov    (%r9,%r15,4),%r9d
 107fbe6:	and    $0x7,%r11d
 107fbea:	lea    (%r11,%r9,8),%r9d
 107fbee:	mov    %r9d,(%r10,%rdx,4)
 107fbf2:	mov    $0x0,%ebp
 107fbf7:	xor    %r9d,%r9d
 107fbfa:	mov    0x5d0(%rsp),%r10
 107fc02:	mov    (%r10,%rdx,4),%r11d
 107fc06:	test   %r11d,%r11d
 107fc09:	je     107fc41 <check_input_run+0x12f31>
 107fc0b:	mov    %r11d,%r14d
 107fc0e:	shr    $0x3,%r14d
 107fc12:	cmpq   $0x0,0x48(%rsp)
 107fc18:	je     107fc39 <check_input_run+0x12f29>
 107fc1a:	mov    %rsi,%r15
 107fc1d:	mov    %r14d,%r12d
 107fc20:	sub    0x10(%r15),%r12d
 107fc24:	jae    107fc31 <check_input_run+0x12f21>
 107fc26:	mov    0x8(%r15),%r15
 107fc2a:	test   %r15,%r15
 107fc2d:	jne    107fc1d <check_input_run+0x12f0d>
 107fc2f:	jmp    107fc39 <check_input_run+0x12f29>
 107fc31:	mov    0x18(%r15),%r14
 107fc35:	mov    (%r14,%r12,4),%r14d
 107fc39:	and    $0x7,%r11d
 107fc3d:	lea    (%r11,%r14,8),%ebp
 107fc41:	mov    %ebp,(%r10,%rdx,4)
 107fc45:	mov    0x530(%rsp),%r10
 107fc4d:	mov    (%r10,%rdx,4),%r11d
 107fc51:	test   %r11d,%r11d
 107fc54:	je     107fc8c <check_input_run+0x12f7c>
 107fc56:	mov    %r11d,%r9d
 107fc59:	shr    $0x3,%r9d
 107fc5d:	cmpq   $0x0,0x48(%rsp)
 107fc63:	je     107fc84 <check_input_run+0x12f74>
 107fc65:	mov    %rsi,%r14
 107fc68:	mov    %r9d,%r15d
 107fc6b:	sub    0x10(%r14),%r15d
 107fc6f:	jae    107fc7c <check_input_run+0x12f6c>
 107fc71:	mov    0x8(%r14),%r14
 107fc75:	test   %r14,%r14
 107fc78:	jne    107fc68 <check_input_run+0x12f58>
 107fc7a:	jmp    107fc84 <check_input_run+0x12f74>
 107fc7c:	mov    0x18(%r14),%r9
 107fc80:	mov    (%r9,%r15,4),%r9d
 107fc84:	and    $0x7,%r11d
 107fc88:	lea    (%r11,%r9,8),%r9d
 107fc8c:	mov    %r9d,(%r10,%rdx,4)
 107fc90:	test   %edi,%edi
 107fc92:	je     107fce1 <check_input_run+0x12fd1>
 107fc94:	mov    0xb0(%rsp),%r14
 107fc9c:	mov    %r8d,%edi
 107fc9f:	mov    0x80(%rsp),%r15
 107fca7:	mov    0x198(%rsp),%r8
 107fcaf:	mov    (%r14,%rdi,4),%r11d
 107fcb3:	mov    0x1a0(%rsp),%r14
 107fcbb:	mov    (%r15,%rdi,4),%ebp
 107fcbf:	mov    0xf8(%rsp),%r15
 107fcc7:	mov    (%r8,%rdi,4),%r8d
 107fccb:	mov    (%r14,%rdi,4),%r9d
 107fccf:	mov    0x180(%rsp),%r14
 107fcd7:	mov    (%r15,%rdi,4),%r10d
 107fcdb:	mov    (%r14,%rdi,4),%edi
 107fcdf:	jmp    107fcf1 <check_input_run+0x12fe1>
 107fce1:	xor    %r8d,%r8d
 107fce4:	xor    %r10d,%r10d
 107fce7:	xor    %ebp,%ebp
 107fce9:	xor    %r11d,%r11d
 107fcec:	xor    %r9d,%r9d
 107fcef:	xor    %edi,%edi
 107fcf1:	mov    0x418(%rsp),%r14
 107fcf9:	mov    (%r14,%rdx,4),%r15d
 107fcfd:	cmp    %rcx,%r15
 107fd00:	je     107fd10 <check_input_run+0x13000>
 107fd02:	cmp    0x68(%rsp),%r15d
 107fd07:	jae    107fd17 <check_input_run+0x13007>
 107fd09:	mov    0x0(%r13,%r15,4),%ebp
 107fd0e:	jmp    107fd1e <check_input_run+0x1300e>
 107fd10:	mov    $0xffffffff,%ebp
 107fd15:	jmp    107fd1e <check_input_run+0x1300e>
 107fd17:	sub    0x68(%rsp),%ebp
 107fd1b:	add    %r15d,%ebp
 107fd1e:	mov    %ebp,(%r14,%rdx,4)
 107fd22:	mov    0xc0(%rsp),%r14
 107fd2a:	mov    $0x0,%r12d
 107fd30:	xor    %ebp,%ebp
 107fd32:	mov    0x318(%r14),%r14
 107fd39:	mov    (%r14,%rdx,4),%r15d
 107fd3d:	test   %r15d,%r15d
 107fd40:	je     107fd71 <check_input_run+0x13061>
 107fd42:	dec    %r15d
 107fd45:	cmp    0xa0(%rsp),%r15d
 107fd4d:	jae    107fd60 <check_input_run+0x13050>
 107fd4f:	mov    %r15d,%r11d
 107fd52:	mov    0x110(%rsp),%r15
 107fd5a:	mov    (%r15,%r11,4),%r12d
 107fd5e:	jmp    107fd6e <check_input_run+0x1305e>
 107fd60:	sub    0xa0(%rsp),%r11d
 107fd68:	add    %r15d,%r11d
 107fd6b:	mov    %r11d,%r12d
 107fd6e:	inc    %r12d
 107fd71:	mov    %r12d,(%r14,%rdx,4)
 107fd75:	mov    0x4e8(%rsp),%r11
 107fd7d:	mov    (%r11,%rdx,4),%r14d
 107fd81:	test   %r14d,%r14d
 107fd84:	je     107fdb3 <check_input_run+0x130a3>
 107fd86:	dec    %r14d
 107fd89:	cmp    0xd8(%rsp),%r14d
 107fd91:	jae    107fda4 <check_input_run+0x13094>
 107fd93:	mov    0x88(%rsp),%r15
 107fd9b:	mov    %r14d,%r14d
 107fd9e:	mov    (%r15,%r14,4),%ebp
 107fda2:	jmp    107fdb1 <check_input_run+0x130a1>
 107fda4:	mov    %r10d,%ebp
 107fda7:	sub    0xd8(%rsp),%ebp
 107fdae:	add    %r14d,%ebp
 107fdb1:	inc    %ebp
 107fdb3:	mov    %ebp,(%r11,%rdx,4)
 107fdb7:	mov    $0x0,%r15d
 107fdbd:	xor    %r11d,%r11d
 107fdc0:	mov    0x4f0(%rsp),%r14
 107fdc8:	mov    (%r14,%rdx,4),%ebp
 107fdcc:	test   %ebp,%ebp
 107fdce:	je     107fdfd <check_input_run+0x130ed>
 107fdd0:	dec    %ebp
 107fdd2:	cmp    0xd8(%rsp),%ebp
 107fdd9:	jae    107fdec <check_input_run+0x130dc>
 107fddb:	mov    0x88(%rsp),%r15
 107fde3:	mov    %ebp,%r10d
 107fde6:	mov    (%r15,%r10,4),%r15d
 107fdea:	jmp    107fdfa <check_input_run+0x130ea>
 107fdec:	sub    0xd8(%rsp),%r10d
 107fdf4:	add    %ebp,%r10d
 107fdf7:	mov    %r10d,%r15d
 107fdfa:	inc    %r15d
 107fdfd:	mov    0xc0(%rsp),%r10
 107fe05:	mov    %r15d,(%r14,%rdx,4)
 107fe09:	mov    0x348(%r10),%r10
 107fe10:	mov    (%r10,%rdx,4),%ebp
 107fe14:	test   %ebp,%ebp
 107fe16:	je     107fe3f <check_input_run+0x1312f>
 107fe18:	dec    %ebp
 107fe1a:	cmp    0x70(%rsp),%ebp
 107fe1e:	jae    107fe31 <check_input_run+0x13121>
 107fe20:	mov    0x150(%rsp),%r11
 107fe28:	mov    %ebp,%r9d
 107fe2b:	mov    (%r11,%r9,4),%r11d
 107fe2f:	jmp    107fe3c <check_input_run+0x1312c>
 107fe31:	sub    0x70(%rsp),%r9d
 107fe36:	add    %ebp,%r9d
 107fe39:	mov    %r9d,%r11d
 107fe3c:	inc    %r11d
 107fe3f:	mov    %r11d,(%r10,%rdx,4)
 107fe43:	mov    $0x0,%ebp
 107fe48:	xor    %r9d,%r9d
 107fe4b:	mov    0x4d0(%rsp),%r10
 107fe53:	mov    (%r10,%rdx,4),%r11d
 107fe57:	test   %r11d,%r11d
 107fe5a:	je     107fe89 <check_input_run+0x13179>
 107fe5c:	dec    %r11d
 107fe5f:	cmp    0xc8(%rsp),%r11d
 107fe67:	jae    107fe7a <check_input_run+0x1316a>
 107fe69:	mov    0x118(%rsp),%r14
 107fe71:	mov    %r11d,%r11d
 107fe74:	mov    (%r14,%r11,4),%ebp
 107fe78:	jmp    107fe87 <check_input_run+0x13177>
 107fe7a:	mov    %r8d,%ebp
 107fe7d:	sub    0xc8(%rsp),%ebp
 107fe84:	add    %r11d,%ebp
 107fe87:	inc    %ebp
 107fe89:	mov    %ebp,(%r10,%rdx,4)
 107fe8d:	mov    0x4d8(%rsp),%r10
 107fe95:	mov    (%r10,%rdx,4),%r11d
 107fe99:	test   %r11d,%r11d
 107fe9c:	je     107fecd <check_input_run+0x131bd>
 107fe9e:	dec    %r11d
 107fea1:	cmp    0xc8(%rsp),%r11d
 107fea9:	jae    107febc <check_input_run+0x131ac>
 107feab:	mov    0x118(%rsp),%r9
 107feb3:	mov    %r11d,%r8d
 107feb6:	mov    (%r9,%r8,4),%r9d
 107feba:	jmp    107feca <check_input_run+0x131ba>
 107febc:	sub    0xc8(%rsp),%r8d
 107fec4:	add    %r11d,%r8d
 107fec7:	mov    %r8d,%r9d
 107feca:	inc    %r9d
 107fecd:	mov    %r9d,(%r10,%rdx,4)
 107fed1:	mov    0x460(%rsp),%r8
 107fed9:	mov    (%r8,%rdx,4),%r9d
 107fedd:	test   %r9d,%r9d
 107fee0:	je     107ff00 <check_input_run+0x131f0>
 107fee2:	dec    %r9d
 107fee5:	cmp    0x100(%rsp),%r9d
 107feed:	jae    107ff04 <check_input_run+0x131f4>
 107feef:	mov    0x148(%rsp),%r10
 107fef7:	mov    %r9d,%edi
 107fefa:	mov    (%r10,%rdi,4),%edi
 107fefe:	jmp    107ff0e <check_input_run+0x131fe>
 107ff00:	xor    %edi,%edi
 107ff02:	jmp    107ff10 <check_input_run+0x13200>
 107ff04:	sub    0x100(%rsp),%edi
 107ff0b:	add    %r9d,%edi
 107ff0e:	inc    %edi
 107ff10:	mov    %edi,(%r8,%rdx,4)
 107ff14:	mov    0x358(%rsp),%rdi
 107ff1c:	mov    (%rdi,%rdx,8),%rdi
 107ff20:	test   %rdi,%rdi
 107ff23:	je     107ffb5 <check_input_run+0x132a5>
 107ff29:	mov    0x24(%rdi),%r9d
 107ff2d:	mov    $0x0,%r10d
 107ff33:	xor    %r8d,%r8d
 107ff36:	test   %r9d,%r9d
 107ff39:	je     107ff71 <check_input_run+0x13261>
 107ff3b:	mov    %r9d,%r10d
 107ff3e:	shr    $0x3,%r10d
 107ff42:	cmpq   $0x0,0x48(%rsp)
 107ff48:	je     107ff69 <check_input_run+0x13259>
 107ff4a:	mov    %rsi,%r11
 107ff4d:	mov    %r10d,%r14d
 107ff50:	sub    0x10(%r11),%r14d
 107ff54:	jae    107ff61 <check_input_run+0x13251>
 107ff56:	mov    0x8(%r11),%r11
 107ff5a:	test   %r11,%r11
 107ff5d:	jne    107ff4d <check_input_run+0x1323d>
 107ff5f:	jmp    107ff69 <check_input_run+0x13259>
 107ff61:	mov    0x18(%r11),%r10
 107ff65:	mov    (%r10,%r14,4),%r10d
 107ff69:	and    $0x7,%r9d
 107ff6d:	lea    (%r9,%r10,8),%r10d
 107ff71:	mov    %r10d,0x24(%rdi)
 107ff75:	mov    0x28(%rdi),%r9d
 107ff79:	test   %r9d,%r9d
 107ff7c:	je     107ffb1 <check_input_run+0x132a1>
 107ff7e:	mov    %r9d,%r8d
 107ff81:	shr    $0x3,%r8d
 107ff85:	cmpq   $0x0,0x48(%rsp)
 107ff8b:	je     107ffa9 <check_input_run+0x13299>
 107ff8d:	mov    %r8d,%r10d
 107ff90:	sub    0x10(%rsi),%r10d
 107ff94:	jae    107ffa1 <check_input_run+0x13291>
 107ff96:	mov    0x8(%rsi),%rsi
 107ff9a:	test   %rsi,%rsi
 107ff9d:	jne    107ff8d <check_input_run+0x1327d>
 107ff9f:	jmp    107ffa9 <check_input_run+0x13299>
 107ffa1:	mov    0x18(%rsi),%rsi
 107ffa5:	mov    (%rsi,%r10,4),%r8d
 107ffa9:	and    $0x7,%r9d
 107ffad:	lea    (%r9,%r8,8),%r8d
 107ffb1:	mov    %r8d,0x28(%rdi)
 107ffb5:	inc    %rdx
 107ffb8:	cmp    %rbx,%rdx
 107ffbb:	jne    107fa34 <check_input_run+0x12d24>
 107ffc1:	cmpl   $0x0,0x2d8(%rsp)
 107ffc9:	je     1080027 <check_input_run+0x13317>
 107ffcb:	xor    %eax,%eax
 107ffcd:	mov    0x5c8(%rsp),%rcx
 107ffd5:	mov    $0x0,%esi
 107ffda:	mov    (%rcx,%rax,4),%edx
 107ffdd:	test   %edx,%edx
 107ffdf:	je     1080015 <check_input_run+0x13305>
 107ffe1:	mov    %edx,%esi
 107ffe3:	shr    $0x3,%esi
 107ffe6:	cmpq   $0x0,0x48(%rsp)
 107ffec:	je     108000f <check_input_run+0x132ff>
 107ffee:	mov    0x48(%rsp),%rdi
 107fff3:	mov    %esi,%r8d
 107fff6:	sub    0x10(%rdi),%r8d
 107fffa:	jae    1080007 <check_input_run+0x132f7>
 107fffc:	mov    0x8(%rdi),%rdi
 1080000:	test   %rdi,%rdi
 1080003:	jne    107fff3 <check_input_run+0x132e3>
 1080005:	jmp    108000f <check_input_run+0x132ff>
 1080007:	mov    0x18(%rdi),%rsi
 108000b:	mov    (%rsi,%r8,4),%esi
 108000f:	and    $0x7,%edx
 1080012:	lea    (%rdx,%rsi,8),%esi
 1080015:	mov    %esi,(%rcx,%rax,4)
 1080018:	inc    %rax
 108001b:	mov    0x2d8(%rsp),%ecx
 1080022:	cmp    %rcx,%rax
 1080025:	jb     107ffcd <check_input_run+0x132bd>
 1080027:	mov    0x60(%rsp),%rcx
 108002c:	xor    %edx,%edx
 108002e:	lea    -0x1(%rcx),%rax
 1080032:	and    $0xfffffffe,%ecx
 1080035:	mov    0x690(%rsp,%rdx,4),%esi
 108003c:	mov    $0x0,%r8d
 1080042:	test   %esi,%esi
 1080044:	je     108007b <check_input_run+0x1336b>
 1080046:	mov    %esi,%edi
 1080048:	shr    $0x3,%edi
 108004b:	cmpq   $0x0,0x48(%rsp)
 1080051:	je     1080074 <check_input_run+0x13364>
 1080053:	mov    0x48(%rsp),%r8
 1080058:	mov    %edi,%r9d
 108005b:	sub    0x10(%r8),%r9d
 108005f:	jae    108006c <check_input_run+0x1335c>
 1080061:	mov    0x8(%r8),%r8
 1080065:	test   %r8,%r8
 1080068:	jne    1080058 <check_input_run+0x13348>
 108006a:	jmp    1080074 <check_input_run+0x13364>
 108006c:	mov    0x18(%r8),%rdi
 1080070:	mov    (%rdi,%r9,4),%edi
 1080074:	and    $0x7,%esi
 1080077:	lea    (%rsi,%rdi,8),%r8d
 108007b:	mov    0x6d0(%rsp,%rdx,4),%r9d
 1080083:	cmpl   $0x0,0x60(%rsp)
 1080088:	je     1080206 <check_input_run+0x134f6>
 108008e:	mov    0x1b0(%rsp),%rsi
 1080096:	xor    %edi,%edi
 1080098:	mov    (%rsi),%rsi
 108009b:	test   %rax,%rax
 108009e:	je     108019a <check_input_run+0x1348a>
 10800a4:	imul   $0x150,%rdi,%r10
 10800ab:	add    %rsi,%r10
 10800ae:	mov    0x11c(%r10,%rdx,4),%r10d
 10800b6:	test   %r10d,%r10d
 10800b9:	je     1080113 <check_input_run+0x13403>
 10800bb:	mov    0x860(%rsp),%r11
 10800c3:	lea    (%rdi,%rdi,2),%r14
 10800c7:	shl    $0x4,%r14
 10800cb:	mov    0x1d0(%r11),%r11
 10800d2:	mov    (%r11,%r14,1),%r11d
 10800d6:	cmp    %r9d,%r11d
 10800d9:	jae    1080113 <check_input_run+0x13403>
 10800db:	mov    0x48(%rsp),%r8
 10800e0:	lea    0x30(%r8,%r14,1),%r9
 10800e5:	mov    %r10d,%r8d
 10800e8:	shr    $0x3,%r8d
 10800ec:	mov    %r8d,%r14d
 10800ef:	sub    0x10(%r9),%r14d
 10800f3:	jae    1080100 <check_input_run+0x133f0>
 10800f5:	mov    0x8(%r9),%r9
 10800f9:	test   %r9,%r9
 10800fc:	jne    10800ec <check_input_run+0x133dc>
 10800fe:	jmp    1080108 <check_input_run+0x133f8>
 1080100:	mov    0x18(%r9),%r8
 1080104:	mov    (%r8,%r14,4),%r8d
 1080108:	and    $0x7,%r10d
 108010c:	mov    %r11d,%r9d
 108010f:	lea    (%r10,%r8,8),%r8d
 1080113:	lea    0x1(%rdi),%r11
 1080117:	imul   $0x150,%r11,%r10
 108011e:	add    %rsi,%r10
 1080121:	mov    0x11c(%r10,%rdx,4),%r10d
 1080129:	test   %r10d,%r10d
 108012c:	je     1080186 <check_input_run+0x13476>
 108012e:	mov    0x860(%rsp),%r14
 1080136:	mov    0x1d0(%r14),%r15
 108013d:	lea    (%r11,%r11,2),%r14
 1080141:	shl    $0x4,%r14
 1080145:	mov    (%r15,%r14,1),%r11d
 1080149:	cmp    %r9d,%r11d
 108014c:	jae    1080186 <check_input_run+0x13476>
 108014e:	mov    0x48(%rsp),%r8
 1080153:	lea    0x30(%r8,%r14,1),%r9
 1080158:	mov    %r10d,%r8d
 108015b:	shr    $0x3,%r8d
 108015f:	mov    %r8d,%r14d
 1080162:	sub    0x10(%r9),%r14d
 1080166:	jae    1080173 <check_input_run+0x13463>
 1080168:	mov    0x8(%r9),%r9
 108016c:	test   %r9,%r9
 108016f:	jne    108015f <check_input_run+0x1344f>
 1080171:	jmp    108017b <check_input_run+0x1346b>
 1080173:	mov    0x18(%r9),%r8
 1080177:	mov    (%r8,%r14,4),%r8d
 108017b:	and    $0x7,%r10d
 108017f:	mov    %r11d,%r9d
 1080182:	lea    (%r10,%r8,8),%r8d
 1080186:	add    $0x2,%rdi
 108018a:	cmp    %rcx,%rdi
 108018d:	jne    10800a4 <check_input_run+0x13394>
 1080193:	testb  $0x1,0x60(%rsp)
 1080198:	je     1080206 <check_input_run+0x134f6>
 108019a:	imul   $0x150,%rdi,%r10
 10801a1:	add    %r10,%rsi
 10801a4:	mov    0x11c(%rsi,%rdx,4),%esi
 10801ab:	test   %esi,%esi
 10801ad:	je     1080206 <check_input_run+0x134f6>
 10801af:	mov    0x860(%rsp),%r10
 10801b7:	mov    0x1d0(%r10),%r11
 10801be:	lea    (%rdi,%rdi,2),%r10
 10801c2:	shl    $0x4,%r10
 10801c6:	mov    (%r11,%r10,1),%edi
 10801ca:	cmp    %r9d,%edi
 10801cd:	jae    1080206 <check_input_run+0x134f6>
 10801cf:	mov    0x48(%rsp),%r8
 10801d4:	lea    0x30(%r8,%r10,1),%r9
 10801d9:	mov    %esi,%r8d
 10801dc:	shr    $0x3,%r8d
 10801e0:	mov    %r8d,%r10d
 10801e3:	sub    0x10(%r9),%r10d
 10801e7:	jae    10801f4 <check_input_run+0x134e4>
 10801e9:	mov    0x8(%r9),%r9
 10801ed:	test   %r9,%r9
 10801f0:	jne    10801e0 <check_input_run+0x134d0>
 10801f2:	jmp    10801fc <check_input_run+0x134ec>
 10801f4:	mov    0x18(%r9),%r8
 10801f8:	mov    (%r8,%r10,4),%r8d
 10801fc:	and    $0x7,%esi
 10801ff:	mov    %edi,%r9d
 1080202:	lea    (%rsi,%r8,8),%r8d
 1080206:	mov    %r8d,0x690(%rsp,%rdx,4)
 108020e:	mov    %r9d,0x6d0(%rsp,%rdx,4)
 1080216:	inc    %rdx
 1080219:	cmp    $0x5,%rdx
 108021d:	jne    1080035 <check_input_run+0x13325>
 1080223:	mov    0x384(%rsp),%esi
 108022a:	mov    $0xffffffff,%edx
 108022f:	mov    $0xffffffff,%ecx
 1080234:	mov    $0xffffffff,%edi
 1080239:	cmp    %rdx,%rsi
 108023c:	je     1080243 <check_input_run+0x13533>
 108023e:	mov    0x0(%r13,%rsi,4),%edi
 1080243:	mov    %edi,0x384(%rsp)
 108024a:	mov    0x388(%rsp),%esi
 1080251:	cmp    %rdx,%rsi
 1080254:	je     108025b <check_input_run+0x1354b>
 1080256:	mov    0x0(%r13,%rsi,4),%ecx
 108025b:	mov    %ecx,0x388(%rsp)
 1080262:	mov    0x38c(%rsp),%ecx
 1080269:	cmp    %rdx,%rcx
 108026c:	je     1080275 <check_input_run+0x13565>
 108026e:	mov    0x0(%r13,%rcx,4),%ecx
 1080273:	jmp    108027a <check_input_run+0x1356a>
 1080275:	mov    $0xffffffff,%ecx
 108027a:	mov    0xc0(%rsp),%rdx
 1080282:	mov    %ecx,0x38c(%rsp)
 1080289:	cmpl   $0x0,0x200(%rdx)
 1080290:	je     10803c1 <check_input_run+0x136b1>
 1080296:	xor    %ecx,%ecx
 1080298:	mov    0xc0(%rsp),%rdx
 10802a0:	imul   $0x130,%rcx,%rsi
 10802a7:	mov    $0x0,%r8d
 10802ad:	mov    0x1f8(%rdx),%rdx
 10802b4:	mov    0xc(%rdx,%rsi,1),%edi
 10802b8:	test   %edi,%edi
 10802ba:	je     10802f3 <check_input_run+0x135e3>
 10802bc:	mov    %edi,%r8d
 10802bf:	shr    $0x3,%r8d
 10802c3:	cmpq   $0x0,0x48(%rsp)
 10802c9:	je     10802ec <check_input_run+0x135dc>
 10802cb:	mov    0x48(%rsp),%r9
 10802d0:	mov    %r8d,%r10d
 10802d3:	sub    0x10(%r9),%r10d
 10802d7:	jae    10802e4 <check_input_run+0x135d4>
 10802d9:	mov    0x8(%r9),%r9
 10802dd:	test   %r9,%r9
 10802e0:	jne    10802d0 <check_input_run+0x135c0>
 10802e2:	jmp    10802ec <check_input_run+0x135dc>
 10802e4:	mov    0x18(%r9),%r8
 10802e8:	mov    (%r8,%r10,4),%r8d
 10802ec:	and    $0x7,%edi
 10802ef:	lea    (%rdi,%r8,8),%r8d
 10802f3:	add    %rsi,%rdx
 10802f6:	mov    %r8d,0xc(%rdx)
 10802fa:	mov    0x10(%rdx),%esi
 10802fd:	test   %esi,%esi
 10802ff:	je     1080327 <check_input_run+0x13617>
 1080301:	mov    %esi,%edi
 1080303:	shr    $0x3,%edi
 1080306:	cmpq   $0x0,0x48(%rsp)
 108030c:	je     1080333 <check_input_run+0x13623>
 108030e:	mov    0x48(%rsp),%r8
 1080313:	mov    %edi,%r9d
 1080316:	sub    0x10(%r8),%r9d
 108031a:	jae    108032b <check_input_run+0x1361b>
 108031c:	mov    0x8(%r8),%r8
 1080320:	test   %r8,%r8
 1080323:	jne    1080313 <check_input_run+0x13603>
 1080325:	jmp    1080333 <check_input_run+0x13623>
 1080327:	xor    %esi,%esi
 1080329:	jmp    1080339 <check_input_run+0x13629>
 108032b:	mov    0x18(%r8),%rdi
 108032f:	mov    (%rdi,%r9,4),%edi
 1080333:	and    $0x7,%esi
 1080336:	lea    (%rsi,%rdi,8),%esi
 1080339:	mov    %esi,0x10(%rdx)
 108033c:	cmpl   $0x0,0x114(%rdx)
 1080343:	je     10803a7 <check_input_run+0x13697>
 1080345:	xor    %esi,%esi
 1080347:	mov    0x14(%rdx,%rsi,4),%edi
 108034b:	test   %edi,%edi
 108034d:	je     1080377 <check_input_run+0x13667>
 108034f:	mov    %edi,%r8d
 1080352:	shr    $0x3,%r8d
 1080356:	cmpq   $0x0,0x48(%rsp)
 108035c:	je     1080383 <check_input_run+0x13673>
 108035e:	mov    0x48(%rsp),%r9
 1080363:	mov    %r8d,%r10d
 1080366:	sub    0x10(%r9),%r10d
 108036a:	jae    108037b <check_input_run+0x1366b>
 108036c:	mov    0x8(%r9),%r9
 1080370:	test   %r9,%r9
 1080373:	jne    1080363 <check_input_run+0x13653>
 1080375:	jmp    1080383 <check_input_run+0x13673>
 1080377:	xor    %edi,%edi
 1080379:	jmp    108038a <check_input_run+0x1367a>
 108037b:	mov    0x18(%r9),%r8
 108037f:	mov    (%r8,%r10,4),%r8d
 1080383:	and    $0x7,%edi
 1080386:	lea    (%rdi,%r8,8),%edi
 108038a:	mov    %edi,0x14(%rdx,%rsi,4)
 108038e:	lea    0x1(%rsi),%rdi
 1080392:	mov    0x114(%rdx),%r8d
 1080399:	cmp    %r8,%rdi
 108039c:	jae    10803a7 <check_input_run+0x13697>
 108039e:	cmp    $0x3f,%rsi
 10803a2:	mov    %rdi,%rsi
 10803a5:	jb     1080347 <check_input_run+0x13637>
 10803a7:	mov    0xc0(%rsp),%rdx
 10803af:	inc    %rcx
 10803b2:	mov    0x200(%rdx),%edx
 10803b8:	cmp    %rdx,%rcx
 10803bb:	jb     1080298 <check_input_run+0x13588>
 10803c1:	mov    0xc0(%rsp),%rcx
 10803c9:	mov    0x178(%rsp),%rdx
 10803d1:	mov    0x1f8(%rsp),%rsi
 10803d9:	mov    0x160(%rsp),%rdi
 10803e1:	cmpq   $0x0,0x58(%rsp)
 10803e7:	mov    %rdx,0x350(%rcx)
 10803ee:	mov    0xb8(%rsp),%rdx
 10803f6:	mov    %edx,0x358(%rcx)
 10803fc:	mov    0xe0(%rsp),%rdx
 1080404:	mov    %rsi,0x310(%rcx)
 108040b:	mov    0x1f0(%rsp),%rsi
 1080413:	mov    %edx,0x320(%rcx)
 1080419:	mov    0x108(%rsp),%rdx
 1080421:	mov    %rdi,0x328(%rcx)
 1080428:	mov    %edx,0x330(%rcx)
 108042e:	mov    0x128(%rsp),%rdx
 1080436:	mov    %rsi,0x338(%rcx)
 108043d:	mov    %edx,0x340(%rcx)
 1080443:	jne    1080452 <check_input_run+0x13742>
 1080445:	mov    0x600(%rsp),%rcx
 108044d:	mov    %rcx,0x58(%rsp)
 1080452:	mov    0x208(%rsp),%rcx
 108045a:	mov    0x140(%rsp),%rsi
 1080462:	mov    0xa8(%rsp),%rdx
 108046a:	cmpl   $0x0,0x60(%rsp)
 108046f:	mov    %rcx,0x4c8(%rsp)
 1080477:	mov    0x120(%rsp),%rcx
 108047f:	mov    %ecx,0x4e0(%rsp)
 1080486:	mov    0x268(%rsp),%rcx
 108048e:	mov    %rsi,0x458(%rsp)
 1080496:	mov    0x58(%rsp),%rsi
 108049b:	mov    %ecx,0x468(%rsp)
 10804a2:	mov    %rdx,0x5f0(%rsp)
 10804aa:	mov    0x860(%rsp),%rdx
 10804b2:	mov    %rsi,0x600(%rsp)
 10804ba:	mov    0x8(%rdx),%rcx
 10804be:	mov    %rcx,0x2b8(%rsp)
 10804c6:	movl   $0xffffffff,0x65c(%rsp)
 10804d1:	movl   $0x0,0x654(%rsp)
 10804dc:	je     10807cf <check_input_run+0x13abf>
 10804e2:	mov    0x410(%rsp),%ecx
 10804e9:	test   %rax,%rax
 10804ec:	je     10806e1 <check_input_run+0x139d1>
 10804f2:	mov    0x80(%rsp),%rax
 10804fa:	mov    0x60(%rsp),%rdx
 10804ff:	and    $0xfffffffe,%edx
 1080502:	mov    $0xffffffff,%edi
 1080507:	xor    %r8d,%r8d
 108050a:	lea    0x4(%rax),%rsi
 108050e:	xor    %eax,%eax
 1080510:	mov    0x1b0(%rsp),%r9
 1080518:	mov    (%r9),%r9
 108051b:	mov    0x148(%r9,%r8,1),%r10d
 1080523:	cmp    %ecx,%r10d
 1080526:	cmova  %r10d,%ecx
 108052a:	mov    %ecx,0x410(%rsp)
 1080531:	mov    0x138(%r9,%r8,1),%r10d
 1080539:	cmp    $0xffffffff,%r10d
 108053d:	je     10805ea <check_input_run+0x138da>
 1080543:	mov    %r10d,0x390(%rsp)
 108054b:	mov    $0xffffffff,%r10d
 1080551:	mov    $0xffffffff,%ebp
 1080556:	mov    0x13c(%r9,%r8,1),%r11d
 108055e:	cmp    %rdi,%r11
 1080561:	je     108057e <check_input_run+0x1386e>
 1080563:	cmp    0x68(%rsp),%r11d
 1080568:	jae    1080571 <check_input_run+0x13861>
 108056a:	mov    0x0(%r13,%r11,4),%ebp
 108056f:	jmp    108057e <check_input_run+0x1386e>
 1080571:	sub    0x68(%rsp),%r11d
 1080576:	add    -0x4(%rsi,%rax,4),%r11d
 108057b:	mov    %r11d,%ebp
 108057e:	mov    %ebp,0x378(%rsp)
 1080585:	mov    0x140(%r9,%r8,1),%r11d
 108058d:	cmp    %rdi,%r11
 1080590:	je     10805ad <check_input_run+0x1389d>
 1080592:	cmp    0x68(%rsp),%r11d
 1080597:	jae    10805a0 <check_input_run+0x13890>
 1080599:	mov    0x0(%r13,%r11,4),%r10d
 108059e:	jmp    10805ad <check_input_run+0x1389d>
 10805a0:	sub    0x68(%rsp),%r11d
 10805a5:	add    -0x4(%rsi,%rax,4),%r11d
 10805aa:	mov    %r11d,%r10d
 10805ad:	mov    %r10d,0x37c(%rsp)
 10805b5:	mov    0x144(%r9,%r8,1),%r9d
 10805bd:	cmp    %rdi,%r9
 10805c0:	je     10805d0 <check_input_run+0x138c0>
 10805c2:	cmp    0x68(%rsp),%r9d
 10805c7:	jae    10805d8 <check_input_run+0x138c8>
 10805c9:	mov    0x0(%r13,%r9,4),%r9d
 10805ce:	jmp    10805e2 <check_input_run+0x138d2>
 10805d0:	mov    $0xffffffff,%r9d
 10805d6:	jmp    10805e2 <check_input_run+0x138d2>
 10805d8:	sub    0x68(%rsp),%r9d
 10805dd:	add    -0x4(%rsi,%rax,4),%r9d
 10805e2:	mov    %r9d,0x380(%rsp)
 10805ea:	mov    0x1b0(%rsp),%r9
 10805f2:	mov    (%r9),%r9
 10805f5:	mov    0x298(%r9,%r8,1),%r10d
 10805fd:	cmp    %ecx,%r10d
 1080600:	cmova  %r10d,%ecx
 1080604:	mov    %ecx,0x410(%rsp)
 108060b:	mov    0x288(%r9,%r8,1),%r10d
 1080613:	cmp    $0xffffffff,%r10d
 1080617:	je     10806c1 <check_input_run+0x139b1>
 108061d:	mov    %r10d,0x390(%rsp)
 1080625:	mov    $0xffffffff,%r10d
 108062b:	mov    $0xffffffff,%ebp
 1080630:	mov    0x28c(%r9,%r8,1),%r11d
 1080638:	cmp    %rdi,%r11
 108063b:	je     1080657 <check_input_run+0x13947>
 108063d:	cmp    0x68(%rsp),%r11d
 1080642:	jae    108064b <check_input_run+0x1393b>
 1080644:	mov    0x0(%r13,%r11,4),%ebp
 1080649:	jmp    1080657 <check_input_run+0x13947>
 108064b:	sub    0x68(%rsp),%r11d
 1080650:	add    (%rsi,%rax,4),%r11d
 1080654:	mov    %r11d,%ebp
 1080657:	mov    %ebp,0x378(%rsp)
 108065e:	mov    0x290(%r9,%r8,1),%r11d
 1080666:	cmp    %rdi,%r11
 1080669:	je     1080685 <check_input_run+0x13975>
 108066b:	cmp    0x68(%rsp),%r11d
 1080670:	jae    1080679 <check_input_run+0x13969>
 1080672:	mov    0x0(%r13,%r11,4),%r10d
 1080677:	jmp    1080685 <check_input_run+0x13975>
 1080679:	sub    0x68(%rsp),%r11d
 108067e:	add    (%rsi,%rax,4),%r11d
 1080682:	mov    %r11d,%r10d
 1080685:	mov    %r10d,0x37c(%rsp)
 108068d:	mov    0x294(%r9,%r8,1),%r9d
 1080695:	cmp    %rdi,%r9
 1080698:	je     10806a8 <check_input_run+0x13998>
 108069a:	cmp    0x68(%rsp),%r9d
 108069f:	jae    10806b0 <check_input_run+0x139a0>
 10806a1:	mov    0x0(%r13,%r9,4),%r9d
 10806a6:	jmp    10806b9 <check_input_run+0x139a9>
 10806a8:	mov    $0xffffffff,%r9d
 10806ae:	jmp    10806b9 <check_input_run+0x139a9>
 10806b0:	sub    0x68(%rsp),%r9d
 10806b5:	add    (%rsi,%rax,4),%r9d
 10806b9:	mov    %r9d,0x380(%rsp)
 10806c1:	add    $0x2,%rax
 10806c5:	add    $0x2a0,%r8
 10806cc:	cmp    %rax,%rdx
 10806cf:	jne    1080510 <check_input_run+0x13800>
 10806d5:	testb  $0x1,0x60(%rsp)
 10806da:	jne    10806e3 <check_input_run+0x139d3>
 10806dc:	jmp    10807cf <check_input_run+0x13abf>
 10806e1:	xor    %eax,%eax
 10806e3:	mov    0x1b0(%rsp),%rdx
 10806eb:	imul   $0x150,%rax,%rsi
 10806f2:	mov    (%rdx),%rdx
 10806f5:	mov    0x148(%rdx,%rsi,1),%edi
 10806fc:	cmp    %ecx,%edi
 10806fe:	cmova  %edi,%ecx
 1080701:	mov    %ecx,0x410(%rsp)
 1080708:	mov    0x138(%rdx,%rsi,1),%ecx
 108070f:	cmp    $0xffffffff,%ecx
 1080712:	je     10807cf <check_input_run+0x13abf>
 1080718:	add    %rsi,%rdx
 108071b:	mov    %ecx,0x390(%rsp)
 1080722:	mov    $0xffffffff,%esi
 1080727:	mov    $0xffffffff,%ecx
 108072c:	mov    $0xffffffff,%r8d
 1080732:	mov    0x13c(%rdx),%edi
 1080738:	cmp    %rsi,%rdi
 108073b:	je     108075d <check_input_run+0x13a4d>
 108073d:	cmp    0x68(%rsp),%edi
 1080741:	jae    108074a <check_input_run+0x13a3a>
 1080743:	mov    0x0(%r13,%rdi,4),%r8d
 1080748:	jmp    108075d <check_input_run+0x13a4d>
 108074a:	mov    0x80(%rsp),%r8
 1080752:	sub    0x68(%rsp),%edi
 1080756:	add    (%r8,%rax,4),%edi
 108075a:	mov    %edi,%r8d
 108075d:	mov    %r8d,0x378(%rsp)
 1080765:	mov    0x140(%rdx),%edi
 108076b:	cmp    %rsi,%rdi
 108076e:	je     108078e <check_input_run+0x13a7e>
 1080770:	cmp    0x68(%rsp),%edi
 1080774:	jae    108077d <check_input_run+0x13a6d>
 1080776:	mov    0x0(%r13,%rdi,4),%ecx
 108077b:	jmp    108078e <check_input_run+0x13a7e>
 108077d:	mov    0x80(%rsp),%rcx
 1080785:	sub    0x68(%rsp),%edi
 1080789:	add    (%rcx,%rax,4),%edi
 108078c:	mov    %edi,%ecx
 108078e:	mov    %ecx,0x37c(%rsp)
 1080795:	mov    0x144(%rdx),%ecx
 108079b:	mov    $0xffffffff,%edx
 10807a0:	cmp    %rdx,%rcx
 10807a3:	je     10807b2 <check_input_run+0x13aa2>
 10807a5:	cmp    0x68(%rsp),%ecx
 10807a9:	jae    10807b9 <check_input_run+0x13aa9>
 10807ab:	mov    0x0(%r13,%rcx,4),%ecx
 10807b0:	jmp    10807c8 <check_input_run+0x13ab8>
 10807b2:	mov    $0xffffffff,%ecx
 10807b7:	jmp    10807c8 <check_input_run+0x13ab8>
 10807b9:	mov    0x80(%rsp),%rdx
 10807c1:	sub    0x68(%rsp),%ecx
 10807c5:	add    (%rdx,%rax,4),%ecx
 10807c8:	mov    %ecx,0x380(%rsp)
 10807cf:	mov    0xc0(%rsp),%rax
 10807d7:	movl   $0x0,0x210(%rsp)
 10807e2:	movq   $0x0,0x1f0(%rax)
 10807ed:	jmp    1077c8e <check_input_run+0xaf7e>
