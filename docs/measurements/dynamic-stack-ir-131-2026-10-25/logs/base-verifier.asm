
current/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000aaab80 <ir_verify_path>:
  aaab80:	push   %rbp
  aaab81:	push   %r15
  aaab83:	push   %r14
  aaab85:	push   %r13
  aaab87:	push   %r12
  aaab89:	push   %rbx
  aaab8a:	sub    $0x4e8,%rsp
  aaab91:	mov    %fs:0x28,%rax
  aaab9a:	mov    %ecx,%ebx
  aaab9c:	mov    %rdx,%r14
  aaab9f:	mov    %rsi,%r15
  aaaba2:	mov    %rdi,%rbp
  aaaba5:	mov    %rax,0x4e0(%rsp)
  aaabad:	mov    0x8(%rsi),%r13
  aaabb1:	call   aad6f0 <ir_check_shape>
  aaabb6:	movabs $0xffffffff00000000,%r8
  aaabc0:	test   %eax,%eax
  aaabc2:	je     aaabcc <ir_verify_path+0x4c>
  aaabc4:	mov    %rax,%r12
  aaabc7:	jmp    aac55c <ir_verify_path+0x19dc>
  aaabcc:	movzbl %bl,%esi
  aaabcf:	mov    %rbp,%rdi
  aaabd2:	call   aada40 <ir_check_rows>
  aaabd7:	vpxor  %xmm0,%xmm0,%xmm0
  aaabdb:	vmovdqu %ymm0,0xb8(%rsp)
  aaabe4:	mov    %rax,%r12
  aaabe7:	vmovdqu %ymm0,0xa0(%rsp)
  aaabf0:	test   %eax,%eax
  aaabf2:	je     aaac03 <ir_verify_path+0x83>
  aaabf4:	movabs $0xffffffff00000000,%r8
  aaabfe:	jmp    aac55c <ir_verify_path+0x19dc>
  aaac03:	lea    0xa0(%rsp),%rcx
  aaac0b:	mov    %ebx,0x2c(%rsp)
  aaac0f:	mov    %rdx,%rbx
  aaac12:	mov    %rbp,%rdi
  aaac15:	mov    %r15,%rsi
  aaac18:	mov    %r15,%rdx
  aaac1b:	vzeroupper
  aaac1e:	call   aacc30 <ir_cfg_validated>
  aaac23:	movabs $0xffffffff00000000,%r8
  aaac2d:	mov    %rbx,%rdx
  aaac30:	test   %eax,%eax
  aaac32:	jne    aac55c <ir_verify_path+0x19dc>
  aaac38:	mov    0x48(%rbp),%edx
  aaac3b:	mov    $0x1,%bl
  aaac3d:	mov    %rbp,0x8(%rsp)
  aaac42:	test   %rdx,%rdx
  aaac45:	je     aaac74 <ir_verify_path+0xf4>
  aaac47:	mov    (%r15),%rsi
  aaac4a:	mov    0x8(%r15),%rax
  aaac4e:	mov    $0x2,%ecx
  aaac53:	lea    0x3f(%rax,%rsi,1),%r12
  aaac58:	add    %rsi,%rax
  aaac5b:	and    $0xffffffffffffffc0,%r12
  aaac5f:	cmp    %rax,%r12
  aaac62:	jae    aaac84 <ir_verify_path+0x104>
  aaac64:	xor    %ebx,%ebx
  aaac66:	movq   $0x0,0x20(%rsp)
  aaac6f:	jmp    aaad13 <ir_verify_path+0x193>
  aaac74:	xor    %ecx,%ecx
  aaac76:	movq   $0x0,0x20(%rsp)
  aaac7f:	jmp    aaad13 <ir_verify_path+0x193>
  aaac84:	mov    %r12,%rax
  aaac87:	sub    %rsi,%rax
  aaac8a:	mov    0x10(%r15),%rsi
  aaac8e:	shl    $0x2,%rdx
  aaac92:	sub    %rax,%rsi
  aaac95:	setb   %dil
  aaac99:	cmp    %rsi,%rdx
  aaac9c:	seta   %sil
  aaaca0:	or     %dil,%sil
  aaaca3:	je     aaacb7 <ir_verify_path+0x137>
  aaaca5:	mov    0x8(%rsp),%rbp
  aaacaa:	xor    %ebx,%ebx
  aaacac:	movq   $0x0,0x20(%rsp)
  aaacb5:	jmp    aaad13 <ir_verify_path+0x193>
  aaacb7:	add    %rdx,%rax
  aaacba:	mov    %rax,0x8(%r15)
  aaacbe:	test   %r12,%r12
  aaacc1:	je     aaad03 <ir_verify_path+0x183>
  aaacc3:	mov    %r12,%rdi
  aaacc6:	xor    %esi,%esi
  aaacc8:	call   7c40c0 <memset@plt>
  aaaccd:	mov    0x8(%rsp),%rbp
  aaacd2:	mov    0x48(%rbp),%edx
  aaacd5:	test   %rdx,%rdx
  aaacd8:	je     aaacf0 <ir_verify_path+0x170>
  aaacda:	shl    $0x2,%rdx
  aaacde:	mov    $0xff,%esi
  aaace3:	mov    %r12,%rdi
  aaace6:	call   7c40c0 <memset@plt>
  aaaceb:	mov    0x8(%rsp),%rbp
  aaacf0:	movabs $0xffffffff00000000,%r8
  aaacfa:	xor    %ecx,%ecx
  aaacfc:	mov    %r12,0x20(%rsp)
  aaad01:	jmp    aaad13 <ir_verify_path+0x193>
  aaad03:	mov    0x8(%rsp),%rbp
  aaad08:	movq   $0x0,0x20(%rsp)
  aaad11:	xor    %ebx,%ebx
  aaad13:	mov    %r15,0x88(%rsp)
  aaad1b:	mov    %r13,0x80(%rsp)
  aaad23:	mov    %r14,0x48(%rsp)
  aaad28:	test   %r14,%r14
  aaad2b:	je     aaada0 <ir_verify_path+0x220>
  aaad2d:	mov    0x10(%r14),%edx
  aaad31:	mov    $0xffffffff,%r9d
  aaad37:	mov    $0xa,%eax
  aaad3c:	cmp    0x48(%rbp),%edx
  aaad3f:	jne    aaad98 <ir_verify_path+0x218>
  aaad41:	test   %rdx,%rdx
  aaad44:	je     aaade3 <ir_verify_path+0x263>
  aaad4a:	cmpq   $0x0,(%r14)
  aaad4e:	je     aaad98 <ir_verify_path+0x218>
  aaad50:	cmpq   $0x0,0x8(%r14)
  aaad55:	mov    $0xa,%eax
  aaad5a:	setne  %sil
  aaad5e:	cmovne %ecx,%eax
  aaad61:	test   %bl,%sil
  aaad64:	je     aaad98 <ir_verify_path+0x218>
  aaad66:	mov    (%r14),%rax
  aaad69:	mov    0x8(%r14),%rcx
  aaad6d:	xor    %r14d,%r14d
  aaad70:	jmp    aaad7e <ir_verify_path+0x1fe>
  aaad72:	inc    %r14
  aaad75:	cmp    %r14,%rdx
  aaad78:	je     aab901 <ir_verify_path+0xd81>
  aaad7e:	mov    (%rax,%r14,4),%esi
  aaad82:	mov    (%rcx,%r14,4),%edi
  aaad86:	cmp    %edi,%esi
  aaad88:	jb     aaad72 <ir_verify_path+0x1f2>
  aaad8a:	or     %esi,%edi
  aaad8c:	je     aaad72 <ir_verify_path+0x1f2>
  aaad8e:	mov    $0xa,%eax
  aaad93:	jmp    aac530 <ir_verify_path+0x19b0>
  aaad98:	xor    %r14d,%r14d
  aaad9b:	jmp    aac530 <ir_verify_path+0x19b0>
  aaada0:	test   %bl,%bl
  aaada2:	je     aaadd8 <ir_verify_path+0x258>
  aaada4:	cmpl   $0x0,0x48(%rbp)
  aaada8:	lea    0x50(%rbp),%rcx
  aaadac:	lea    0x40(%rbp),%rax
  aaadb0:	lea    0x28(%rbp),%r10
  aaadb4:	lea    0x20(%rbp),%rdx
  aaadb8:	mov    %rcx,0x38(%rsp)
  aaadbd:	lea    0x30(%rbp),%rcx
  aaadc1:	mov    %rax,0x40(%rsp)
  aaadc6:	mov    %rdx,0x30(%rsp)
  aaadcb:	mov    %rcx,0x68(%rsp)
  aaadd0:	jne    aab92e <ir_verify_path+0xdae>
  aaadd6:	jmp    aaae13 <ir_verify_path+0x293>
  aaadd8:	mov    $0xffffffff,%r9d
  aaadde:	jmp    aab7f5 <ir_verify_path+0xc75>
  aaade3:	test   %bl,%bl
  aaade5:	je     aab7f5 <ir_verify_path+0xc75>
  aaadeb:	lea    0x50(%rbp),%rcx
  aaadef:	lea    0x40(%rbp),%rax
  aaadf3:	lea    0x28(%rbp),%r10
  aaadf7:	lea    0x20(%rbp),%rdx
  aaadfb:	mov    %rcx,0x38(%rsp)
  aaae00:	lea    0x30(%rbp),%rcx
  aaae04:	mov    %rax,0x40(%rsp)
  aaae09:	mov    %rdx,0x30(%rsp)
  aaae0e:	mov    %rcx,0x68(%rsp)
  aaae13:	vpxor  %xmm0,%xmm0,%xmm0
  aaae17:	vmovdqu64 %zmm0,0x320(%rsp)
  aaae22:	vmovdqu64 %zmm0,0x2e0(%rsp)
  aaae2d:	vmovdqu64 %zmm0,0x2a0(%rsp)
  aaae38:	vmovdqu64 %zmm0,0x260(%rsp)
  aaae43:	vmovdqu64 %zmm0,0x220(%rsp)
  aaae4e:	vmovdqu64 %zmm0,0x1e0(%rsp)
  aaae59:	vmovdqu64 %zmm0,0x1a0(%rsp)
  aaae64:	vmovdqu64 %zmm0,0x160(%rsp)
  aaae6f:	vmovdqu64 %zmm0,0x120(%rsp)
  aaae7a:	vmovdqu64 %zmm0,0xe0(%rsp)
  aaae85:	movl   $0x0,0x360(%rsp)
  aaae90:	xor    %eax,%eax
  aaae92:	mov    0x38(%rbp),%ecx
  aaae95:	mov    %rcx,0x20(%rsp)
  aaae9a:	test   %rcx,%rcx
  aaae9d:	je     aab7ff <ir_verify_path+0xc7f>
  aaaea3:	mov    0xc8(%rsp),%rdx
  aaaeab:	mov    0x0(%rbp),%rsi
  aaaeaf:	mov    $0xffffffff,%r9d
  aaaeb5:	mov    %r10,0x10(%rsp)
  aaaeba:	xor    %r14d,%r14d
  aaaebd:	xor    %r8d,%r8d
  aaaec0:	xor    %ecx,%ecx
  aaaec2:	movzbl (%rsi,%r8,1),%r11d
  aaaec7:	lea    -0x5afb1e(%rip),%rdi        # 4fb3b0 <ir_operand_table>
  aaaece:	movzbl (%r11,%rdi,1),%edi
  aaaed3:	cmp    $0x33,%r11
  aaaed7:	je     aaaf03 <ir_verify_path+0x383>
  aaaed9:	mov    0x2c(%rsp),%r15d
  aaaede:	cmp    $0x2a,%r11d
  aaaee2:	jne    aaaf26 <ir_verify_path+0x3a6>
  aaaee4:	mov    0x10(%rsp),%r10
  aaaee9:	mov    (%r10),%r11
  aaaeec:	mov    %edi,%r10d
  aaaeef:	or     $0x2,%r10d
  aaaef3:	cmpl   $0xffffffff,(%r11,%r8,4)
  aaaef8:	cmove  %edi,%r10d
  aaaefc:	popcnt %r10d,%r10d
  aaaf01:	jmp    aaaf68 <ir_verify_path+0x3e8>
  aaaf03:	mov    0x30(%rsp),%r10
  aaaf08:	mov    0x2c(%rsp),%r15d
  aaaf0d:	mov    (%r10),%r11
  aaaf10:	xor    %r10d,%r10d
  aaaf13:	cmpl   $0xffffffff,(%r11,%r8,4)
  aaaf18:	setne  %r10b
  aaaf1c:	or     %edi,%r10d
  aaaf1f:	popcnt %r10d,%r10d
  aaaf24:	jmp    aaaf68 <ir_verify_path+0x3e8>
  aaaf26:	popcnt %edi,%r10d
  aaaf2b:	lea    -0x2d(%r11),%ebx
  aaaf2f:	cmp    $0x2,%ebx
  aaaf32:	jae    aaaf53 <ir_verify_path+0x3d3>
  aaaf34:	mov    0x8(%rsp),%r11
  aaaf39:	mov    0x28(%r11),%rdi
  aaaf3d:	mov    0x90(%r11),%r11
  aaaf44:	mov    (%rdi,%r8,4),%edi
  aaaf48:	lea    (%rdi,%rdi,4),%rdi
  aaaf4c:	mov    0x4(%r11,%rdi,4),%edi
  aaaf51:	jmp    aaaf65 <ir_verify_path+0x3e5>
  aaaf53:	cmp    $0x2f,%r11d
  aaaf57:	jne    aaaf68 <ir_verify_path+0x3e8>
  aaaf59:	mov    0x10(%rsp),%rdi
  aaaf5e:	mov    (%rdi),%rdi
  aaaf61:	mov    (%rdi,%r8,4),%edi
  aaaf65:	add    %rdi,%r10
  aaaf68:	test   %r10,%r10
  aaaf6b:	je     aab7cb <ir_verify_path+0xc4b>
  aaaf71:	xor    %r13d,%r13d
  aaaf74:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  aaaf80:	movzbl (%rsi,%r8,1),%ebp
  aaaf85:	lea    -0x5afbdc(%rip),%rdi        # 4fb3b0 <ir_operand_table>
  aaaf8c:	movzbl 0x0(%rbp,%rdi,1),%edi
  aaaf91:	cmp    $0x33,%ebp
  aaaf94:	je     aaafc0 <ir_verify_path+0x440>
  aaaf96:	cmp    $0x2a,%ebp
  aaaf99:	jne    aaafd4 <ir_verify_path+0x454>
  aaaf9b:	mov    0x10(%rsp),%r11
  aaafa0:	mov    %edi,%ebx
  aaafa2:	or     $0x2,%ebx
  aaafa5:	mov    (%r11),%r11
  aaafa8:	cmpl   $0xffffffff,(%r11,%r8,4)
  aaafad:	cmovne %ebx,%edi
  aaafb0:	jmp    aaafd4 <ir_verify_path+0x454>
  aaafb2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  aaafc0:	mov    0x30(%rsp),%r11
  aaafc5:	xor    %ebx,%ebx
  aaafc7:	mov    (%r11),%r11
  aaafca:	cmpl   $0xffffffff,(%r11,%r8,4)
  aaafcf:	setne  %bl
  aaafd2:	or     %ebx,%edi
  aaafd4:	mov    (%rdx,%r8,4),%r12d
  aaafd8:	popcnt %edi,%ebx
  aaafdc:	mov    %r13d,%r11d
  aaafdf:	sub    %ebx,%r11d
  aaafe2:	jae    aab080 <ir_verify_path+0x500>
  aaafe8:	test   %r13d,%r13d
  aaafeb:	je     aab05a <ir_verify_path+0x4da>
  aaafed:	cmp    $0x8,%r13d
  aaaff1:	jb     aab03f <ir_verify_path+0x4bf>
  aaaff3:	mov    %r13d,%ebp
  aaaff6:	and    $0xfffffff8,%ebp
  aaaff9:	nopl   0x0(%rax)
  aab000:	blsr   %edi,%edi
  aab005:	lea    -0x2(%rdi),%r11d
  aab009:	and    %edi,%r11d
  aab00c:	lea    -0x2(%r11),%edi
  aab010:	and    %r11d,%edi
  aab013:	lea    -0x2(%rdi),%r11d
  aab017:	and    %edi,%r11d
  aab01a:	lea    -0x2(%r11),%edi
  aab01e:	and    %r11d,%edi
  aab021:	blsr   %edi,%edi
  aab026:	lea    -0x2(%rdi),%r11d
  aab02a:	and    %edi,%r11d
  aab02d:	lea    -0x2(%r11),%edi
  aab031:	and    %r11d,%edi
  aab034:	add    $0xfffffff8,%ebp
  aab037:	jne    aab000 <ir_verify_path+0x480>
  aab039:	test   $0x7,%r13b
  aab03d:	je     aab05a <ir_verify_path+0x4da>
  aab03f:	mov    %r13d,%r11d
  aab042:	and    $0x7,%r11d
  aab046:	cs nopw 0x0(%rax,%rax,1)
  aab050:	blsr   %edi,%edi
  aab055:	dec    %r11d
  aab058:	jne    aab050 <ir_verify_path+0x4d0>
  aab05a:	lea    0x0(,%r8,4),%rbp
  aab062:	tzcnt  %edi,%edi
  aab066:	je     aab0d9 <ir_verify_path+0x559>
  aab068:	cmp    $0x1,%edi
  aab06b:	jne    aab0e5 <ir_verify_path+0x565>
  aab06d:	mov    0x10(%rsp),%rdi
  aab072:	add    (%rdi),%rbp
  aab075:	mov    $0x1,%edi
  aab07a:	jmp    aab0f0 <ir_verify_path+0x570>
  aab07c:	nopl   0x0(%rax)
  aab080:	mov    0x38(%rsp),%rbx
  aab085:	lea    0x3(%r11),%edi
  aab089:	mov    (%rbx),%rbx
  aab08c:	cmp    $0x2f,%bpl
  aab090:	jne    aab0b0 <ir_verify_path+0x530>
  aab092:	mov    0x30(%rsp),%r12
  aab097:	mov    (%r12),%r12
  aab09b:	mov    (%r12,%r8,4),%ebp
  aab09f:	lea    0x0(%rbp,%r11,2),%r12d
  aab0a4:	lea    0x1(%rbp,%r11,2),%r11d
  aab0a9:	mov    (%rbx,%r12,4),%r12d
  aab0ad:	jmp    aab0d3 <ir_verify_path+0x553>
  aab0af:	nop
  aab0b0:	mov    0x8(%rsp),%r15
  aab0b5:	mov    0x28(%r15),%rbp
  aab0b9:	mov    0x90(%r15),%r15
  aab0c0:	mov    0x0(%rbp,%r8,4),%ebp
  aab0c5:	lea    0x0(%rbp,%rbp,4),%rbp
  aab0ca:	add    (%r15,%rbp,4),%r11d
  aab0ce:	mov    0x2c(%rsp),%r15d
  aab0d3:	lea    (%rbx,%r11,4),%rbp
  aab0d7:	jmp    aab0f0 <ir_verify_path+0x570>
  aab0d9:	mov    0x30(%rsp),%rdi
  aab0de:	add    (%rdi),%rbp
  aab0e1:	xor    %edi,%edi
  aab0e3:	jmp    aab0f0 <ir_verify_path+0x570>
  aab0e5:	mov    0x68(%rsp),%r11
  aab0ea:	add    (%r11),%rbp
  aab0ed:	nopl   (%rax)
  aab0f0:	mov    0x0(%rbp),%r11d
  aab0f4:	mov    %ecx,%ecx
  aab0f6:	mov    (%rdx,%r11,4),%ebp
  aab0fa:	mov    %r11d,0xe0(%rsp,%rcx,4)
  aab102:	mov    %r8d,%r11d
  aab105:	cmpb   $0x2f,(%rsi,%r8,1)
  aab10a:	jne    aab120 <ir_verify_path+0x5a0>
  aab10c:	mov    0x40(%rsp),%r11
  aab111:	lea    0x1(%r12),%ebx
  aab116:	mov    (%r11),%r11
  aab119:	mov    (%r11,%rbx,4),%r11d
  aab11d:	dec    %r11d
  aab120:	mov    0x48(%rsp),%rbx
  aab125:	mov    %r11d,0x120(%rsp,%rcx,4)
  aab12d:	mov    %ebp,0x160(%rsp,%rcx,4)
  aab134:	mov    %r12d,0x1a0(%rsp,%rcx,4)
  aab13c:	mov    %r8d,0x2e0(%rsp,%rcx,4)
  aab144:	mov    %edi,0x320(%rsp,%rcx,4)
  aab14b:	test   %rbx,%rbx
  aab14e:	je     aab186 <ir_verify_path+0x606>
  aab150:	mov    (%rbx),%rdi
  aab153:	mov    (%rdi,%rbp,4),%r11d
  aab157:	mov    %r11d,0x1e0(%rsp,%rcx,4)
  aab15f:	mov    0x8(%rbx),%r11
  aab163:	mov    (%r11,%rbp,4),%ebx
  aab167:	mov    %ebx,0x220(%rsp,%rcx,4)
  aab16e:	mov    %r12d,%ebx
  aab171:	mov    (%rdi,%rbx,4),%edi
  aab174:	mov    %edi,0x260(%rsp,%rcx,4)
  aab17b:	mov    (%r11,%rbx,4),%edi
  aab17f:	mov    %edi,0x2a0(%rsp,%rcx,4)
  aab186:	mov    0x360(%rsp),%ecx
  aab18d:	xor    %edi,%edi
  aab18f:	inc    %ecx
  aab191:	mov    %ecx,0x360(%rsp)
  aab198:	cmp    $0x10,%ecx
  aab19b:	jne    aab5c2 <ir_verify_path+0xa42>
  aab1a1:	test   %r15b,%r15b
  aab1a4:	je     aab250 <ir_verify_path+0x6d0>
  aab1aa:	vmovdqu64 0xe0(%rsp),%zmm0
  aab1b5:	vmovdqu64 0x1a0(%rsp),%zmm1
  aab1c0:	cmpq   $0x0,0x48(%rsp)
  aab1c6:	vpcmpeqd 0x160(%rsp),%zmm1,%k1
  aab1d1:	vpcmpnltud 0x120(%rsp),%zmm0,%k0{%k1}
  aab1dd:	kmovw  %k0,%ecx
  aab1e1:	je     aab580 <ir_verify_path+0xa00>
  aab1e7:	vmovdqu64 0x220(%rsp),%zmm1
  aab1f2:	vmovdqu64 0x2a0(%rsp),%zmm2
  aab1fd:	kmovw  %k1,%edi
  aab201:	vmovdqu64 0x1e0(%rsp),%zmm0
  aab20c:	vptestnmd %zmm1,%zmm1,%k0
  aab212:	vptestnmd %zmm2,%zmm2,%k1
  aab218:	vpcmpltud %zmm2,%zmm1,%k2
  aab21f:	korw   %k1,%k0,%k0
  aab223:	vpcmpnleud 0x260(%rsp),%zmm0,%k1
  aab22f:	korw   %k1,%k2,%k1
  aab233:	korw   %k0,%k1,%k0
  aab237:	kmovw  %k0,%r9d
  aab23b:	andn   %r9d,%edi,%edi
  aab240:	or     %edi,%ecx
  aab242:	jmp    aab580 <ir_verify_path+0xa00>
  aab247:	nopw   0x0(%rax,%rax,1)
  aab250:	cmpq   $0x0,0x48(%rsp)
  aab256:	je     aab336 <ir_verify_path+0x7b6>
  aab25c:	vmovdqu64 0x160(%rsp),%zmm1
  aab267:	vmovdqu64 0x1a0(%rsp),%zmm2
  aab272:	vmovdqu64 0x220(%rsp),%zmm3
  aab27d:	vmovdqu64 0x120(%rsp),%zmm0
  aab288:	vpcmpeqd %zmm2,%zmm1,%k0
  aab28e:	vpcmpneqd %zmm2,%zmm1,%k1
  aab295:	vmovdqu64 0x2a0(%rsp),%zmm2
  aab2a0:	vptestnmd %zmm3,%zmm3,%k2
  aab2a6:	vmovdqu64 0x1e0(%rsp),%zmm1
  aab2b1:	kandw  %k2,%k1,%k3
  aab2b5:	korw   %k2,%k0,%k0
  aab2b9:	vpcmpnleud 0x260(%rsp),%zmm1,%k4
  aab2c5:	vptestnmd %zmm2,%zmm2,%k2
  aab2cb:	korw   %k2,%k0,%k0
  aab2cf:	vpcmpleud 0xe0(%rsp),%zmm0,%k2
  aab2db:	korw   %k2,%k1,%k1
  aab2df:	vpcmpltud %zmm2,%zmm3,%k2
  aab2e6:	korw   %k4,%k2,%k2
  aab2ea:	kandnw %k2,%k0,%k2
  aab2ee:	kandw  %k0,%k1,%k0
  aab2f2:	korw   %k2,%k0,%k0
  aab2f6:	korw   %k0,%k3,%k1
  aab2fa:	vmovdqa32 -0x5b9d44(%rip),%zmm0{%k1}{z}        # 4f15c0 <check_builtin_atomic_rmw_test_clang.native_source+0x5c00>
  aab304:	vextracti64x4 $0x1,%zmm0,%ymm1
  aab30b:	vpord  %zmm1,%zmm0,%zmm0
  aab311:	vextracti128 $0x1,%ymm0,%xmm1
  aab317:	vpor   %xmm1,%xmm0,%xmm0
  aab31b:	vpshufd $0xee,%xmm0,%xmm1
  aab320:	vpor   %xmm1,%xmm0,%xmm0
  aab324:	vpshufd $0x55,%xmm0,%xmm1
  aab329:	vpor   %xmm1,%xmm0,%xmm0
  aab32d:	vmovd  %xmm0,%ecx
  aab331:	jmp    aab580 <ir_verify_path+0xa00>
  aab336:	mov    0x120(%rsp),%ecx
  aab33d:	vmovq  0x160(%rsp),%xmm0
  aab346:	vmovq  0x1a0(%rsp),%xmm1
  aab34f:	cmp    %ecx,0xe0(%rsp)
  aab356:	vpcmpeqd %xmm1,%xmm0,%k0
  aab35c:	kmovd  %k0,%edi
  aab360:	kmovd  %k0,%r9d
  aab364:	setae  %cl
  aab367:	and    %cl,%dil
  aab36a:	movzbl %dil,%ecx
  aab36e:	test   $0x2,%r9b
  aab372:	je     aab5db <ir_verify_path+0xa5b>
  aab378:	mov    0xe4(%rsp),%edi
  aab37f:	xor    %r9d,%r9d
  aab382:	cmp    0x124(%rsp),%edi
  aab389:	setae  %r9b
  aab38d:	lea    (%rcx,%r9,2),%ecx
  aab391:	mov    0x168(%rsp),%edi
  aab398:	cmp    0x1a8(%rsp),%edi
  aab39f:	je     aab5ef <ir_verify_path+0xa6f>
  aab3a5:	mov    0x16c(%rsp),%edi
  aab3ac:	cmp    0x1ac(%rsp),%edi
  aab3b3:	jne    aab61c <ir_verify_path+0xa9c>
  aab3b9:	mov    0xec(%rsp),%edi
  aab3c0:	xor    %r9d,%r9d
  aab3c3:	cmp    0x12c(%rsp),%edi
  aab3ca:	setae  %r9b
  aab3ce:	lea    (%rcx,%r9,8),%ecx
  aab3d2:	mov    0x170(%rsp),%edi
  aab3d9:	cmp    0x1b0(%rsp),%edi
  aab3e0:	je     aab630 <ir_verify_path+0xab0>
  aab3e6:	mov    0x174(%rsp),%edi
  aab3ed:	cmp    0x1b4(%rsp),%edi
  aab3f4:	jne    aab663 <ir_verify_path+0xae3>
  aab3fa:	mov    0xf4(%rsp),%edi
  aab401:	xor    %r9d,%r9d
  aab404:	cmp    0x134(%rsp),%edi
  aab40b:	setae  %r9b
  aab40f:	shl    $0x5,%r9d
  aab413:	or     %ecx,%r9d
  aab416:	mov    %r9d,%ecx
  aab419:	mov    0x178(%rsp),%edi
  aab420:	cmp    0x1b8(%rsp),%edi
  aab427:	je     aab677 <ir_verify_path+0xaf7>
  aab42d:	mov    0x17c(%rsp),%edi
  aab434:	cmp    0x1bc(%rsp),%edi
  aab43b:	jne    aab6aa <ir_verify_path+0xb2a>
  aab441:	mov    0xfc(%rsp),%edi
  aab448:	xor    %r9d,%r9d
  aab44b:	cmp    0x13c(%rsp),%edi
  aab452:	setae  %r9b
  aab456:	shl    $0x7,%r9d
  aab45a:	or     %ecx,%r9d
  aab45d:	mov    %r9d,%ecx
  aab460:	mov    0x180(%rsp),%edi
  aab467:	cmp    0x1c0(%rsp),%edi
  aab46e:	je     aab6be <ir_verify_path+0xb3e>
  aab474:	mov    0x184(%rsp),%edi
  aab47b:	cmp    0x1c4(%rsp),%edi
  aab482:	jne    aab6f1 <ir_verify_path+0xb71>
  aab488:	mov    0x104(%rsp),%edi
  aab48f:	xor    %r9d,%r9d
  aab492:	cmp    0x144(%rsp),%edi
  aab499:	setae  %r9b
  aab49d:	shl    $0x9,%r9d
  aab4a1:	or     %ecx,%r9d
  aab4a4:	mov    %r9d,%ecx
  aab4a7:	mov    0x188(%rsp),%edi
  aab4ae:	cmp    0x1c8(%rsp),%edi
  aab4b5:	je     aab705 <ir_verify_path+0xb85>
  aab4bb:	mov    0x18c(%rsp),%edi
  aab4c2:	cmp    0x1cc(%rsp),%edi
  aab4c9:	jne    aab738 <ir_verify_path+0xbb8>
  aab4cf:	mov    0x10c(%rsp),%edi
  aab4d6:	xor    %r9d,%r9d
  aab4d9:	cmp    0x14c(%rsp),%edi
  aab4e0:	setae  %r9b
  aab4e4:	shl    $0xb,%r9d
  aab4e8:	or     %ecx,%r9d
  aab4eb:	mov    %r9d,%ecx
  aab4ee:	mov    0x190(%rsp),%edi
  aab4f5:	cmp    0x1d0(%rsp),%edi
  aab4fc:	je     aab74c <ir_verify_path+0xbcc>
  aab502:	mov    0x194(%rsp),%edi
  aab509:	cmp    0x1d4(%rsp),%edi
  aab510:	jne    aab77f <ir_verify_path+0xbff>
  aab516:	mov    0x114(%rsp),%edi
  aab51d:	xor    %r9d,%r9d
  aab520:	cmp    0x154(%rsp),%edi
  aab527:	setae  %r9b
  aab52b:	shl    $0xd,%r9d
  aab52f:	or     %ecx,%r9d
  aab532:	mov    %r9d,%ecx
  aab535:	mov    0x198(%rsp),%edi
  aab53c:	cmp    0x1d8(%rsp),%edi
  aab543:	je     aab793 <ir_verify_path+0xc13>
  aab549:	mov    0x19c(%rsp),%edi
  aab550:	cmp    0x1dc(%rsp),%edi
  aab557:	jne    aab580 <ir_verify_path+0xa00>
  aab559:	mov    0x11c(%rsp),%edi
  aab560:	xor    %r9d,%r9d
  aab563:	cmp    0x15c(%rsp),%edi
  aab56a:	setae  %r9b
  aab56e:	shl    $0xf,%r9d
  aab572:	or     %ecx,%r9d
  aab575:	mov    %r9d,%ecx
  aab578:	nopl   0x0(%rax,%rax,1)
  aab580:	test   %ecx,%ecx
  aab582:	je     aab5a1 <ir_verify_path+0xa21>
  aab584:	tzcnt  %ecx,%ecx
  aab588:	mov    0x2e0(%rsp,%rcx,4),%edi
  aab58f:	mov    0x320(%rsp,%rcx,4),%r14d
  aab597:	shl    $0x20,%rdi
  aab59b:	or     $0xa,%rdi
  aab59f:	jmp    aab5ae <ir_verify_path+0xa2e>
  aab5a1:	movabs $0xffffffff00000000,%rdi
  aab5ab:	xor    %r14d,%r14d
  aab5ae:	mov    %rdi,%r9
  aab5b1:	shr    $0x20,%r9
  aab5b5:	xor    %ecx,%ecx
  aab5b7:	movl   $0x0,0x360(%rsp)
  aab5c2:	test   %edi,%edi
  aab5c4:	jne    aab7cd <ir_verify_path+0xc4d>
  aab5ca:	inc    %r13d
  aab5cd:	cmp    %r13,%r10
  aab5d0:	ja     aaaf80 <ir_verify_path+0x400>
  aab5d6:	jmp    aab7cd <ir_verify_path+0xc4d>
  aab5db:	mov    0x168(%rsp),%edi
  aab5e2:	cmp    0x1a8(%rsp),%edi
  aab5e9:	jne    aab3a5 <ir_verify_path+0x825>
  aab5ef:	mov    0xe8(%rsp),%edi
  aab5f6:	xor    %r9d,%r9d
  aab5f9:	cmp    0x128(%rsp),%edi
  aab600:	setae  %r9b
  aab604:	lea    (%rcx,%r9,4),%ecx
  aab608:	mov    0x16c(%rsp),%edi
  aab60f:	cmp    0x1ac(%rsp),%edi
  aab616:	je     aab3b9 <ir_verify_path+0x839>
  aab61c:	mov    0x170(%rsp),%edi
  aab623:	cmp    0x1b0(%rsp),%edi
  aab62a:	jne    aab3e6 <ir_verify_path+0x866>
  aab630:	mov    0xf0(%rsp),%edi
  aab637:	xor    %r9d,%r9d
  aab63a:	cmp    0x130(%rsp),%edi
  aab641:	setae  %r9b
  aab645:	shl    $0x4,%r9d
  aab649:	or     %ecx,%r9d
  aab64c:	mov    %r9d,%ecx
  aab64f:	mov    0x174(%rsp),%edi
  aab656:	cmp    0x1b4(%rsp),%edi
  aab65d:	je     aab3fa <ir_verify_path+0x87a>
  aab663:	mov    0x178(%rsp),%edi
  aab66a:	cmp    0x1b8(%rsp),%edi
  aab671:	jne    aab42d <ir_verify_path+0x8ad>
  aab677:	mov    0xf8(%rsp),%edi
  aab67e:	xor    %r9d,%r9d
  aab681:	cmp    0x138(%rsp),%edi
  aab688:	setae  %r9b
  aab68c:	shl    $0x6,%r9d
  aab690:	or     %ecx,%r9d
  aab693:	mov    %r9d,%ecx
  aab696:	mov    0x17c(%rsp),%edi
  aab69d:	cmp    0x1bc(%rsp),%edi
  aab6a4:	je     aab441 <ir_verify_path+0x8c1>
  aab6aa:	mov    0x180(%rsp),%edi
  aab6b1:	cmp    0x1c0(%rsp),%edi
  aab6b8:	jne    aab474 <ir_verify_path+0x8f4>
  aab6be:	mov    0x100(%rsp),%edi
  aab6c5:	xor    %r9d,%r9d
  aab6c8:	cmp    0x140(%rsp),%edi
  aab6cf:	setae  %r9b
  aab6d3:	shl    $0x8,%r9d
  aab6d7:	or     %ecx,%r9d
  aab6da:	mov    %r9d,%ecx
  aab6dd:	mov    0x184(%rsp),%edi
  aab6e4:	cmp    0x1c4(%rsp),%edi
  aab6eb:	je     aab488 <ir_verify_path+0x908>
  aab6f1:	mov    0x188(%rsp),%edi
  aab6f8:	cmp    0x1c8(%rsp),%edi
  aab6ff:	jne    aab4bb <ir_verify_path+0x93b>
  aab705:	mov    0x108(%rsp),%edi
  aab70c:	xor    %r9d,%r9d
  aab70f:	cmp    0x148(%rsp),%edi
  aab716:	setae  %r9b
  aab71a:	shl    $0xa,%r9d
  aab71e:	or     %ecx,%r9d
  aab721:	mov    %r9d,%ecx
  aab724:	mov    0x18c(%rsp),%edi
  aab72b:	cmp    0x1cc(%rsp),%edi
  aab732:	je     aab4cf <ir_verify_path+0x94f>
  aab738:	mov    0x190(%rsp),%edi
  aab73f:	cmp    0x1d0(%rsp),%edi
  aab746:	jne    aab502 <ir_verify_path+0x982>
  aab74c:	mov    0x110(%rsp),%edi
  aab753:	xor    %r9d,%r9d
  aab756:	cmp    0x150(%rsp),%edi
  aab75d:	setae  %r9b
  aab761:	shl    $0xc,%r9d
  aab765:	or     %ecx,%r9d
  aab768:	mov    %r9d,%ecx
  aab76b:	mov    0x194(%rsp),%edi
  aab772:	cmp    0x1d4(%rsp),%edi
  aab779:	je     aab516 <ir_verify_path+0x996>
  aab77f:	mov    0x198(%rsp),%edi
  aab786:	cmp    0x1d8(%rsp),%edi
  aab78d:	jne    aab549 <ir_verify_path+0x9c9>
  aab793:	mov    0x118(%rsp),%edi
  aab79a:	xor    %r9d,%r9d
  aab79d:	cmp    0x158(%rsp),%edi
  aab7a4:	setae  %r9b
  aab7a8:	shl    $0xe,%r9d
  aab7ac:	or     %ecx,%r9d
  aab7af:	mov    %r9d,%ecx
  aab7b2:	mov    0x19c(%rsp),%edi
  aab7b9:	cmp    0x1dc(%rsp),%edi
  aab7c0:	je     aab559 <ir_verify_path+0x9d9>
  aab7c6:	jmp    aab580 <ir_verify_path+0xa00>
  aab7cb:	xor    %edi,%edi
  aab7cd:	test   %edi,%edi
  aab7cf:	jne    aab8ea <ir_verify_path+0xd6a>
  aab7d5:	mov    0x88(%rsp),%r15
  aab7dd:	mov    0x80(%rsp),%r13
  aab7e5:	inc    %r8
  aab7e8:	cmp    0x20(%rsp),%r8
  aab7ed:	jne    aaaec2 <ir_verify_path+0x342>
  aab7f3:	jmp    aab80a <ir_verify_path+0xc8a>
  aab7f5:	xor    %r14d,%r14d
  aab7f8:	mov    %ecx,%eax
  aab7fa:	jmp    aac530 <ir_verify_path+0x19b0>
  aab7ff:	mov    $0xffffffff,%r9d
  aab805:	xor    %ecx,%ecx
  aab807:	xor    %r14d,%r14d
  aab80a:	movabs $0xffffffff00000000,%r8
  aab814:	test   %ecx,%ecx
  aab816:	je     aac530 <ir_verify_path+0x19b0>
  aab81c:	cmpb   $0x0,0x2c(%rsp)
  aab821:	je     aac4ef <ir_verify_path+0x196f>
  aab827:	vmovdqu64 0xe0(%rsp),%zmm0
  aab832:	vmovdqu64 0x1a0(%rsp),%zmm1
  aab83d:	cmpq   $0x0,0x48(%rsp)
  aab843:	vpcmpeqd 0x160(%rsp),%zmm1,%k1
  aab84e:	vpcmpnltud 0x120(%rsp),%zmm0,%k0{%k1}
  aab85a:	kmovw  %k0,%eax
  aab85e:	je     aab8bb <ir_verify_path+0xd3b>
  aab860:	vmovdqu64 0x220(%rsp),%zmm1
  aab86b:	vmovdqu64 0x2a0(%rsp),%zmm2
  aab876:	kmovw  %k1,%edx
  aab87a:	vmovdqu64 0x1e0(%rsp),%zmm0
  aab885:	vptestnmd %zmm1,%zmm1,%k0
  aab88b:	vptestnmd %zmm2,%zmm2,%k1
  aab891:	vpcmpltud %zmm2,%zmm1,%k2
  aab898:	korw   %k1,%k0,%k0
  aab89c:	vpcmpnleud 0x260(%rsp),%zmm0,%k1
  aab8a8:	korw   %k1,%k2,%k1
  aab8ac:	korw   %k0,%k1,%k0
  aab8b0:	kmovw  %k0,%esi
  aab8b4:	andn   %esi,%edx,%edx
  aab8b9:	or     %edx,%eax
  aab8bb:	bzhi   %ecx,%eax,%edx
  aab8c0:	test   %edx,%edx
  aab8c2:	je     aac50f <ir_verify_path+0x198f>
  aab8c8:	xor    %ecx,%ecx
  aab8ca:	tzcnt  %edx,%ecx
  aab8ce:	mov    0x2e0(%rsp,%rcx,4),%eax
  aab8d5:	mov    0x320(%rsp,%rcx,4),%r14d
  aab8dd:	shl    $0x20,%rax
  aab8e1:	or     $0xa,%rax
  aab8e5:	jmp    aac51c <ir_verify_path+0x199c>
  aab8ea:	mov    0x88(%rsp),%r15
  aab8f2:	mov    0x80(%rsp),%r13
  aab8fa:	mov    %edi,%eax
  aab8fc:	jmp    aac4e3 <ir_verify_path+0x1963>
  aab901:	mov    0x8(%rsp),%rbp
  aab906:	lea    0x50(%rbp),%rcx
  aab90a:	lea    0x40(%rbp),%rax
  aab90e:	lea    0x20(%rbp),%rdx
  aab912:	lea    0x28(%rbp),%r10
  aab916:	mov    %rcx,0x38(%rsp)
  aab91b:	lea    0x30(%rbp),%rcx
  aab91f:	mov    %rax,0x40(%rsp)
  aab924:	mov    %rdx,0x30(%rsp)
  aab929:	mov    %rcx,0x68(%rsp)
  aab92e:	mov    0x40(%rbp),%rax
  aab932:	mov    $0xffffffff,%r9d
  aab938:	xor    %r14d,%r14d
  aab93b:	xor    %ebx,%ebx
  aab93d:	mov    (%rax),%eax
  aab93f:	mov    %rbx,%r11
  aab942:	inc    %rbx
  aab945:	mov    %eax,%r12d
  aab948:	xor    %esi,%esi
  aab94a:	mov    %r11,0x60(%rsp)
  aab94f:	mov    0x40(%rsp),%rax
  aab954:	mov    (%rax),%rax
  aab957:	mov    (%rax,%rbx,4),%eax
  aab95a:	cmp    %rax,%r12
  aab95d:	jae    aac4c7 <ir_verify_path+0x1947>
  aab963:	mov    0x0(%rbp),%rax
  aab967:	mov    %esi,%ecx
  aab969:	mov    %r12,0x98(%rsp)
  aab971:	movzbl (%rax,%r12,1),%eax
  aab976:	cmp    $0x2f,%al
  aab978:	setne  %sil
  aab97c:	je     aaba82 <ir_verify_path+0xf02>
  aab982:	cmp    $0x32,%al
  aab984:	jne    aabbdd <ir_verify_path+0x105d>
  aab98a:	mov    0x68(%rsp),%rax
  aab98f:	mov    0x8(%r15),%r9
  aab993:	mov    (%rax),%rax
  aab996:	mov    (%rax,%r12,4),%edx
  aab99a:	xor    %eax,%eax
  aab99c:	mov    %rdx,0x58(%rsp)
  aab9a1:	cmp    $0x2,%rdx
  aab9a5:	jb     aac4b3 <ir_verify_path+0x1933>
  aab9ab:	mov    (%r15),%rdx
  aab9ae:	mov    $0x2,%eax
  aab9b3:	lea    0x3f(%r9,%rdx,1),%rdi
  aab9b8:	lea    (%r9,%rdx,1),%rcx
  aab9bc:	and    $0xffffffffffffffc0,%rdi
  aab9c0:	cmp    %rcx,%rdi
  aab9c3:	jb     aac4b3 <ir_verify_path+0x1933>
  aab9c9:	mov    %rdi,%rcx
  aab9cc:	sub    %rdx,%rcx
  aab9cf:	mov    0x10(%r15),%rdx
  aab9d3:	sub    %rcx,%rdx
  aab9d6:	jb     aac4b3 <ir_verify_path+0x1933>
  aab9dc:	mov    %rdi,0x50(%rsp)
  aab9e1:	mov    %r10,%rdi
  aab9e4:	mov    0x58(%rsp),%r10
  aab9e9:	mov    %rcx,0x10(%rsp)
  aab9ee:	lea    0x0(,%r10,4),%rcx
  aab9f6:	mov    %rdi,%r10
  aab9f9:	cmp    %rdx,%rcx
  aab9fc:	ja     aac4b3 <ir_verify_path+0x1933>
  aaba02:	mov    %rcx,%rdx
  aaba05:	mov    0x10(%rsp),%rcx
  aaba0a:	mov    0x50(%rsp),%rdi
  aaba0f:	mov    $0x2,%eax
  aaba14:	add    %rdx,%rcx
  aaba17:	mov    %rcx,0x8(%r15)
  aaba1b:	test   %rdi,%rdi
  aaba1e:	je     aac4aa <ir_verify_path+0x192a>
  aaba24:	mov    %esi,0x1c(%rsp)
  aaba28:	xor    %esi,%esi
  aaba2a:	mov    %r9,0x70(%rsp)
  aaba2f:	mov    %r10,0x10(%rsp)
  aaba34:	mov    %rdx,%r14
  aaba37:	vzeroupper
  aaba3a:	call   7c40c0 <memset@plt>
  aaba3f:	mov    (%r15),%rax
  aaba42:	mov    0x8(%r15),%rcx
  aaba46:	lea    0x3f(%rcx,%rax,1),%rsi
  aaba4b:	lea    (%rcx,%rax,1),%rdx
  aaba4f:	and    $0xffffffffffffffc0,%rsi
  aaba53:	cmp    %rdx,%rsi
  aaba56:	jae    aabbe4 <ir_verify_path+0x1064>
  aaba5c:	mov    0x8(%rsp),%rbp
  aaba61:	mov    0x10(%rsp),%r10
  aaba66:	mov    0x60(%rsp),%r11
  aaba6b:	mov    $0x2,%eax
  aaba70:	movabs $0xffffffff00000000,%r8
  aaba7a:	xor    %r14d,%r14d
  aaba7d:	jmp    aac4a1 <ir_verify_path+0x1921>
  aaba82:	test   %r11,%r11
  aaba85:	sete   %al
  aaba88:	or     %cl,%al
  aaba8a:	test   $0x1,%al
  aaba8c:	jne    aac525 <ir_verify_path+0x19a5>
  aaba92:	mov    0xb8(%rsp),%rdi
  aaba9a:	mov    (%r10),%rax
  aaba9d:	mov    (%rdi,%rbx,4),%edx
  aabaa0:	mov    (%rax,%r12,4),%ecx
  aabaa4:	mov    %rdi,0x10(%rsp)
  aabaa9:	sub    (%rdi,%r11,4),%edx
  aabaad:	cmp    %edx,%ecx
  aabaaf:	jne    aac525 <ir_verify_path+0x19a5>
  aabab5:	test   %ecx,%ecx
  aabab7:	je     aabbdd <ir_verify_path+0x105d>
  aababd:	mov    0xc0(%rsp),%rdx
  aabac5:	xor    %ecx,%ecx
  aabac7:	mov    %esi,0x1c(%rsp)
  aabacb:	mov    0x20(%rbp),%rsi
  aabacf:	mov    0x50(%rbp),%rdi
  aabad3:	mov    (%rsi,%r12,4),%r8d
  aabad7:	lea    (%r8,%rcx,2),%esi
  aabadb:	mov    (%rdi,%rsi,4),%esi
  aabade:	cmp    0x48(%rbp),%esi
  aabae1:	jae    aac4d8 <ir_verify_path+0x1958>
  aabae7:	mov    0x10(%rsp),%r12
  aabaec:	mov    %r10,%rax
  aabaef:	mov    %rbx,%r14
  aabaf2:	mov    (%r12,%r11,4),%r10d
  aabaf6:	mov    (%r12,%rbx,4),%r11d
  aabafa:	cmp    %r11d,%r10d
  aabafd:	jae    aabb33 <ir_verify_path+0xfb3>
  aabaff:	mov    %r11d,%ebp
  aabb02:	jmp    aabb18 <ir_verify_path+0xf98>
  aabb04:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  aabb10:	mov    %r12d,%ebp
  aabb13:	cmp    %ebp,%r10d
  aabb16:	jae    aabb33 <ir_verify_path+0xfb3>
  aabb18:	mov    %ebp,%ebx
  aabb1a:	sub    %r10d,%ebx
  aabb1d:	shr    $1,%ebx
  aabb1f:	lea    (%rbx,%r10,1),%r12d
  aabb23:	cmp    %esi,(%rdx,%r12,4)
  aabb27:	jae    aabb10 <ir_verify_path+0xf90>
  aabb29:	lea    0x1(%rbx,%r10,1),%r10d
  aabb2e:	cmp    %ebp,%r10d
  aabb31:	jb     aabb18 <ir_verify_path+0xf98>
  aabb33:	mov    0x98(%rsp),%r12
  aabb3b:	cmp    %r11d,%r10d
  aabb3e:	mov    0x60(%rsp),%r11
  aabb43:	jae    aac4d8 <ir_verify_path+0x1958>
  aabb49:	mov    %r10d,%r10d
  aabb4c:	cmp    %esi,(%rdx,%r10,4)
  aabb50:	jne    aac4d8 <ir_verify_path+0x1958>
  aabb56:	mov    0x20(%rsp),%r10
  aabb5b:	mov    (%r10,%rsi,4),%r10d
  aabb5f:	cmp    %r10,%r12
  aabb62:	je     aac4d8 <ir_verify_path+0x1958>
  aabb68:	lea    0x1(%r8,%rcx,2),%r8d
  aabb6d:	mov    0x8(%rsp),%r10
  aabb72:	mov    (%rdi,%r8,4),%edi
  aabb76:	cmp    0x38(%r10),%edi
  aabb7a:	jae    aac4d8 <ir_verify_path+0x1958>
  aabb80:	mov    0x8(%rsp),%r8
  aabb85:	mov    0x8(%r8),%r8
  aabb89:	movzbl (%r8,%rdi,1),%edi
  aabb8e:	cmp    (%r8,%r12,1),%dil
  aabb92:	jne    aac4d8 <ir_verify_path+0x1958>
  aabb98:	mov    0x20(%rsp),%rdi
  aabb9d:	mov    0x8(%rsp),%rbp
  aabba2:	inc    %ecx
  aabba4:	mov    %r14,%rbx
  aabba7:	mov    %rax,%r10
  aabbaa:	mov    %r12d,(%rdi,%rsi,4)
  aabbae:	mov    (%rax),%rsi
  aabbb1:	cmp    (%rsi,%r12,4),%ecx
  aabbb5:	jb     aabacb <ir_verify_path+0xf4b>
  aabbbb:	mov    0x0(%rbp),%rax
  aabbbf:	mov    0x1c(%rsp),%esi
  aabbc3:	movabs $0xffffffff00000000,%r8
  aabbcd:	xor    %r14d,%r14d
  aabbd0:	movzbl (%rax,%r12,1),%eax
  aabbd5:	cmp    $0x32,%al
  aabbd7:	je     aab98a <ir_verify_path+0xe0a>
  aabbdd:	xor    %eax,%eax
  aabbdf:	jmp    aac4ba <ir_verify_path+0x193a>
  aabbe4:	mov    %rsi,%rdx
  aabbe7:	sub    %rax,%rdx
  aabbea:	mov    0x10(%r15),%rax
  aabbee:	mov    0x70(%rsp),%r9
  aabbf3:	mov    %rsi,0x90(%rsp)
  aabbfb:	sub    %rdx,%rax
  aabbfe:	jb     aabc84 <ir_verify_path+0x1104>
  aabc04:	mov    0x8(%rsp),%rbp
  aabc09:	mov    0x10(%rsp),%r10
  aabc0e:	mov    0x60(%rsp),%r11
  aabc13:	mov    0x1c(%rsp),%esi
  aabc17:	mov    %r14,%rdi
  aabc1a:	movabs $0xffffffff00000000,%r8
  aabc24:	cmp    %rax,%r14
  aabc27:	mov    $0x2,%eax
  aabc2c:	mov    $0x0,%r14d
  aabc32:	ja     aac4aa <ir_verify_path+0x192a>
  aabc38:	add    %rdi,%rdx
  aabc3b:	mov    %rdi,0x78(%rsp)
  aabc40:	mov    0x90(%rsp),%rdi
  aabc48:	mov    %rdx,0x8(%r15)
  aabc4c:	mov    %rdx,%rcx
  aabc4f:	test   %rdi,%rdi
  aabc52:	je     aac4aa <ir_verify_path+0x192a>
  aabc58:	mov    0x78(%rsp),%rdx
  aabc5d:	xor    %esi,%esi
  aabc5f:	call   7c40c0 <memset@plt>
  aabc64:	mov    0x58(%rsp),%rcx
  aabc69:	mov    %ecx,%eax
  aabc6b:	and    $0x7,%eax
  aabc6e:	cmp    $0x8,%ecx
  aabc71:	jae    aabcae <ir_verify_path+0x112e>
  aabc73:	mov    0x10(%rsp),%r11
  aabc78:	mov    0x38(%rsp),%rbx
  aabc7d:	xor    %ecx,%ecx
  aabc7f:	jmp    aabd9a <ir_verify_path+0x121a>
  aabc84:	mov    0x8(%rsp),%rbp
  aabc89:	mov    0x10(%rsp),%r10
  aabc8e:	mov    0x60(%rsp),%r11
  aabc93:	mov    0x1c(%rsp),%esi
  aabc97:	mov    $0x2,%eax
  aabc9c:	movabs $0xffffffff00000000,%r8
  aabca6:	xor    %r14d,%r14d
  aabca9:	jmp    aac4aa <ir_verify_path+0x192a>
  aabcae:	mov    0x10(%rsp),%r11
  aabcb3:	mov    0x38(%rsp),%rbx
  aabcb8:	mov    0x50(%rsp),%r9
  aabcbd:	mov    %ecx,%edx
  aabcbf:	shr    $0x3,%edx
  aabcc2:	and    $0xfffffff8,%ecx
  aabcc5:	xor    %esi,%esi
  aabcc7:	shl    $0x4,%rdx
  aabccb:	mov    (%r11),%rdi
  aabcce:	mov    (%rbx),%r8
  aabcd1:	mov    (%rdi,%r12,4),%edi
  aabcd5:	lea    0x1(%rsi,%rdi,1),%edi
  aabcd9:	mov    (%r8,%rdi,4),%edi
  aabcdd:	mov    %edi,(%r9,%rsi,2)
  aabce1:	mov    (%r11),%r8
  aabce4:	mov    (%rbx),%rdi
  aabce7:	mov    (%r8,%r12,4),%r8d
  aabceb:	lea    0x3(%rsi,%r8,1),%r8d
  aabcf0:	mov    (%rdi,%r8,4),%edi
  aabcf4:	mov    %edi,0x4(%r9,%rsi,2)
  aabcf9:	mov    (%r11),%r8
  aabcfc:	mov    (%rbx),%rdi
  aabcff:	mov    (%r8,%r12,4),%r8d
  aabd03:	lea    0x5(%rsi,%r8,1),%r8d
  aabd08:	mov    (%rdi,%r8,4),%edi
  aabd0c:	mov    %edi,0x8(%r9,%rsi,2)
  aabd11:	mov    (%r11),%r8
  aabd14:	mov    (%rbx),%rdi
  aabd17:	mov    (%r8,%r12,4),%r8d
  aabd1b:	lea    0x7(%rsi,%r8,1),%r8d
  aabd20:	mov    (%rdi,%r8,4),%edi
  aabd24:	mov    %edi,0xc(%r9,%rsi,2)
  aabd29:	mov    (%r11),%r8
  aabd2c:	mov    (%rbx),%rdi
  aabd2f:	mov    (%r8,%r12,4),%r8d
  aabd33:	lea    0x9(%rsi,%r8,1),%r8d
  aabd38:	mov    (%rdi,%r8,4),%edi
  aabd3c:	mov    %edi,0x10(%r9,%rsi,2)
  aabd41:	mov    (%r11),%r8
  aabd44:	mov    (%rbx),%rdi
  aabd47:	mov    (%r8,%r12,4),%r8d
  aabd4b:	lea    0xb(%rsi,%r8,1),%r8d
  aabd50:	mov    (%rdi,%r8,4),%edi
  aabd54:	mov    %edi,0x14(%r9,%rsi,2)
  aabd59:	mov    (%r11),%rdi
  aabd5c:	mov    (%rbx),%r8
  aabd5f:	mov    (%rdi,%r12,4),%edi
  aabd63:	lea    0xd(%rsi,%rdi,1),%edi
  aabd67:	mov    (%r8,%rdi,4),%edi
  aabd6b:	mov    %edi,0x18(%r9,%rsi,2)
  aabd70:	mov    (%r11),%r8
  aabd73:	mov    (%rbx),%rdi
  aabd76:	mov    (%r8,%r12,4),%r8d
  aabd7a:	lea    0xf(%rsi,%r8,1),%r8d
  aabd7f:	mov    (%rdi,%r8,4),%edi
  aabd83:	mov    %edi,0x1c(%r9,%rsi,2)
  aabd88:	add    $0x10,%rsi
  aabd8c:	cmp    %rsi,%rdx
  aabd8f:	jne    aabccb <ir_verify_path+0x114b>
  aabd95:	test   %rax,%rax
  aabd98:	je     aabdcc <ir_verify_path+0x124c>
  aabd9a:	mov    0x50(%rsp),%rdx
  aabd9f:	lea    (%rax,%rax,1),%esi
  aabda2:	xor    %edi,%edi
  aabda4:	lea    (%rdx,%rcx,4),%rdx
  aabda8:	add    %ecx,%ecx
  aabdaa:	inc    %rcx
  aabdad:	mov    (%r11),%r9
  aabdb0:	lea    (%rcx,%rdi,1),%r10d
  aabdb4:	mov    (%rbx),%r8
  aabdb7:	add    (%r9,%r12,4),%r10d
  aabdbb:	mov    (%r8,%r10,4),%r8d
  aabdbf:	mov    %r8d,(%rdx,%rdi,2)
  aabdc3:	add    $0x2,%rdi
  aabdc7:	cmp    %rdi,%rsi
  aabdca:	jne    aabdad <ir_verify_path+0x122d>
  aabdcc:	mov    0x8(%rsp),%rdx
  aabdd1:	mov    0x8(%rdx),%rcx
  aabdd5:	mov    0x20(%rdx),%rdx
  aabdd9:	mov    (%rdx,%r12,4),%edx
  aabddd:	movzbl (%rcx,%rdx,1),%ecx
  aabde1:	lea    -0x5b0a58(%rip),%rdx        # 4fb390 <ir_type_bits>
  aabde8:	movzwl (%rdx,%rcx,2),%ecx
  aabdec:	add    $0x7,%ecx
  aabdef:	shr    $0x3,%ecx
  aabdf2:	mov    %ecx,0x78(%rsp)
  aabdf6:	je     aac3f1 <ir_verify_path+0x1871>
  aabdfc:	mov    0x58(%rsp),%r15
  aabe01:	mov    0x90(%rsp),%r14
  aabe09:	mov    0x50(%rsp),%rbp
  aabe0e:	xor    %r8d,%r8d
  aabe11:	vpxor  %xmm0,%xmm0,%xmm0
  aabe15:	mov    %r15d,%edx
  aabe18:	mov    %r15d,%esi
  aabe1b:	mov    %r15d,%edi
  aabe1e:	and    $0xfffffff8,%edx
  aabe21:	and    $0x3,%esi
  aabe24:	and    $0xfffffffc,%edi
  aabe27:	jmp    aabe3f <ir_verify_path+0x12bf>
  aabe29:	mov    0x58(%rsp),%r15
  aabe2e:	inc    %r8d
  aabe31:	mov    %r9,%r14
  aabe34:	cmp    0x78(%rsp),%r8d
  aabe39:	je     aac3fb <ir_verify_path+0x187b>
  aabe3f:	mov    0x8(%rsp),%rcx
  aabe44:	vmovdqu64 %zmm0,0x4a0(%rsp)
  aabe4f:	vmovdqu64 %zmm0,0x460(%rsp)
  aabe5a:	vmovdqu64 %zmm0,0x420(%rsp)
  aabe65:	vmovdqu64 %zmm0,0x3e0(%rsp)
  aabe70:	vmovdqu64 %zmm0,0x3a0(%rsp)
  aabe7b:	vmovdqu64 %zmm0,0x360(%rsp)
  aabe86:	vmovdqu64 %zmm0,0x320(%rsp)
  aabe91:	vmovdqu64 %zmm0,0x2e0(%rsp)
  aabe9c:	vmovdqu64 %zmm0,0x2a0(%rsp)
  aabea7:	vmovdqu64 %zmm0,0x260(%rsp)
  aabeb2:	vmovdqu64 %zmm0,0x220(%rsp)
  aabebd:	vmovdqu64 %zmm0,0x1e0(%rsp)
  aabec8:	vmovdqu64 %zmm0,0x1a0(%rsp)
  aabed3:	vmovdqu64 %zmm0,0x160(%rsp)
  aabede:	vmovdqu64 %zmm0,0x120(%rsp)
  aabee9:	vmovdqu64 %zmm0,0xe0(%rsp)
  aabef4:	lea    0x0(,%r8,8),%r10d
  aabefc:	mov    %rbp,%r9
  aabeff:	xor    %r12d,%r12d
  aabf02:	and    $0x38,%r10d
  aabf06:	mov    0x60(%rcx),%r11
  aabf0a:	cmp    $0x8,%r8d
  aabf0e:	jae    aac02a <ir_verify_path+0x14aa>
  aabf14:	cmp    $0x8,%r15d
  aabf18:	jb     aabffc <ir_verify_path+0x147c>
  aabf1e:	mov    (%r9,%r12,4),%ebx
  aabf22:	shl    $0x4,%rbx
  aabf26:	shrx   %r10,(%r11,%rbx,1),%rbx
  aabf2c:	movzbl %bl,%ebx
  aabf2f:	incl   0xe0(%rsp,%rbx,4)
  aabf36:	mov    0x4(%r9,%r12,4),%ebx
  aabf3b:	shl    $0x4,%rbx
  aabf3f:	shrx   %r10,(%r11,%rbx,1),%rbx
  aabf45:	movzbl %bl,%ebx
  aabf48:	incl   0xe0(%rsp,%rbx,4)
  aabf4f:	mov    0x8(%r9,%r12,4),%ebx
  aabf54:	shl    $0x4,%rbx
  aabf58:	shrx   %r10,(%r11,%rbx,1),%rbx
  aabf5e:	movzbl %bl,%ebx
  aabf61:	incl   0xe0(%rsp,%rbx,4)
  aabf68:	mov    0xc(%r9,%r12,4),%ebx
  aabf6d:	shl    $0x4,%rbx
  aabf71:	shrx   %r10,(%r11,%rbx,1),%rbx
  aabf77:	movzbl %bl,%ebx
  aabf7a:	incl   0xe0(%rsp,%rbx,4)
  aabf81:	mov    0x10(%r9,%r12,4),%ebx
  aabf86:	shl    $0x4,%rbx
  aabf8a:	shrx   %r10,(%r11,%rbx,1),%rbx
  aabf90:	movzbl %bl,%ebx
  aabf93:	incl   0xe0(%rsp,%rbx,4)
  aabf9a:	mov    0x14(%r9,%r12,4),%ebx
  aabf9f:	shl    $0x4,%rbx
  aabfa3:	shrx   %r10,(%r11,%rbx,1),%rbx
  aabfa9:	movzbl %bl,%ebx
  aabfac:	incl   0xe0(%rsp,%rbx,4)
  aabfb3:	mov    0x18(%r9,%r12,4),%ebx
  aabfb8:	shl    $0x4,%rbx
  aabfbc:	shrx   %r10,(%r11,%rbx,1),%rbx
  aabfc2:	movzbl %bl,%ebx
  aabfc5:	incl   0xe0(%rsp,%rbx,4)
  aabfcc:	mov    0x1c(%r9,%r12,4),%ebx
  aabfd1:	add    $0x8,%r12
  aabfd5:	shl    $0x4,%rbx
  aabfd9:	shrx   %r10,(%r11,%rbx,1),%rbx
  aabfdf:	movzbl %bl,%ebx
  aabfe2:	incl   0xe0(%rsp,%rbx,4)
  aabfe9:	cmp    %r12,%rdx
  aabfec:	jne    aabf1e <ir_verify_path+0x139e>
  aabff2:	test   $0x7,%r15b
  aabff6:	je     aac140 <ir_verify_path+0x15c0>
  aabffc:	lea    (%r9,%r12,4),%rbx
  aac000:	xor    %r12d,%r12d
  aac003:	mov    (%rbx,%r12,4),%r13d
  aac007:	inc    %r12
  aac00a:	shl    $0x4,%r13
  aac00e:	shrx   %r10,(%r11,%r13,1),%r13
  aac014:	movzbl %r13b,%r13d
  aac018:	incl   0xe0(%rsp,%r13,4)
  aac020:	cmp    %r12,%rax
  aac023:	jne    aac003 <ir_verify_path+0x1483>
  aac025:	jmp    aac140 <ir_verify_path+0x15c0>
  aac02a:	cmp    $0x8,%r15d
  aac02e:	jb     aac116 <ir_verify_path+0x1596>
  aac034:	mov    (%r9,%r12,4),%ebx
  aac038:	shl    $0x4,%rbx
  aac03c:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aac043:	movzbl %bl,%ebx
  aac046:	incl   0xe0(%rsp,%rbx,4)
  aac04d:	mov    0x4(%r9,%r12,4),%ebx
  aac052:	shl    $0x4,%rbx
  aac056:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aac05d:	movzbl %bl,%ebx
  aac060:	incl   0xe0(%rsp,%rbx,4)
  aac067:	mov    0x8(%r9,%r12,4),%ebx
  aac06c:	shl    $0x4,%rbx
  aac070:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aac077:	movzbl %bl,%ebx
  aac07a:	incl   0xe0(%rsp,%rbx,4)
  aac081:	mov    0xc(%r9,%r12,4),%ebx
  aac086:	shl    $0x4,%rbx
  aac08a:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aac091:	movzbl %bl,%ebx
  aac094:	incl   0xe0(%rsp,%rbx,4)
  aac09b:	mov    0x10(%r9,%r12,4),%ebx
  aac0a0:	shl    $0x4,%rbx
  aac0a4:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aac0ab:	movzbl %bl,%ebx
  aac0ae:	incl   0xe0(%rsp,%rbx,4)
  aac0b5:	mov    0x14(%r9,%r12,4),%ebx
  aac0ba:	shl    $0x4,%rbx
  aac0be:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aac0c5:	movzbl %bl,%ebx
  aac0c8:	incl   0xe0(%rsp,%rbx,4)
  aac0cf:	mov    0x18(%r9,%r12,4),%ebx
  aac0d4:	shl    $0x4,%rbx
  aac0d8:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aac0df:	movzbl %bl,%ebx
  aac0e2:	incl   0xe0(%rsp,%rbx,4)
  aac0e9:	mov    0x1c(%r9,%r12,4),%ebx
  aac0ee:	add    $0x8,%r12
  aac0f2:	shl    $0x4,%rbx
  aac0f6:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aac0fd:	movzbl %bl,%ebx
  aac100:	incl   0xe0(%rsp,%rbx,4)
  aac107:	cmp    %r12,%rdx
  aac10a:	jne    aac034 <ir_verify_path+0x14b4>
  aac110:	test   $0x7,%r15b
  aac114:	je     aac140 <ir_verify_path+0x15c0>
  aac116:	lea    (%r9,%r12,4),%rbx
  aac11a:	xor    %r12d,%r12d
  aac11d:	mov    (%rbx,%r12,4),%r13d
  aac121:	inc    %r12
  aac124:	shl    $0x4,%r13
  aac128:	shrx   %r10,0x8(%r11,%r13,1),%r13
  aac12f:	movzbl %r13b,%r13d
  aac133:	incl   0xe0(%rsp,%r13,4)
  aac13b:	cmp    %r12,%rax
  aac13e:	jne    aac11d <ir_verify_path+0x159d>
  aac140:	xor    %ebx,%ebx
  aac142:	xor    %r11d,%r11d
  aac145:	mov    0xe0(%rsp,%r11,4),%ebp
  aac14d:	mov    %ebx,0xe0(%rsp,%r11,4)
  aac155:	add    %ebx,%ebp
  aac157:	mov    0xe4(%rsp,%r11,4),%ebx
  aac15f:	mov    %ebp,0xe4(%rsp,%r11,4)
  aac167:	mov    0xe8(%rsp,%r11,4),%ecx
  aac16f:	add    %ebp,%ebx
  aac171:	mov    %ebx,0xe8(%rsp,%r11,4)
  aac179:	add    %ebx,%ecx
  aac17b:	mov    0xec(%rsp,%r11,4),%ebx
  aac183:	mov    %ecx,0xec(%rsp,%r11,4)
  aac18b:	mov    0xf0(%rsp,%r11,4),%r12d
  aac193:	add    %ecx,%ebx
  aac195:	mov    %ebx,0xf0(%rsp,%r11,4)
  aac19d:	add    %ebx,%r12d
  aac1a0:	mov    0xf4(%rsp,%r11,4),%ebx
  aac1a8:	mov    %r12d,0xf4(%rsp,%r11,4)
  aac1b0:	mov    0xf8(%rsp,%r11,4),%ecx
  aac1b8:	add    %r12d,%ebx
  aac1bb:	mov    %ebx,0xf8(%rsp,%r11,4)
  aac1c3:	add    %ebx,%ecx
  aac1c5:	mov    0xfc(%rsp,%r11,4),%ebx
  aac1cd:	mov    %ecx,0xfc(%rsp,%r11,4)
  aac1d5:	mov    0x100(%rsp,%r11,4),%r12d
  aac1dd:	add    %ecx,%ebx
  aac1df:	mov    %ebx,0x100(%rsp,%r11,4)
  aac1e7:	add    %ebx,%r12d
  aac1ea:	mov    0x104(%rsp,%r11,4),%ebx
  aac1f2:	mov    %r12d,0x104(%rsp,%r11,4)
  aac1fa:	mov    0x108(%rsp,%r11,4),%ecx
  aac202:	add    %r12d,%ebx
  aac205:	mov    %ebx,0x108(%rsp,%r11,4)
  aac20d:	add    %ebx,%ecx
  aac20f:	mov    0x10c(%rsp,%r11,4),%ebx
  aac217:	mov    %ecx,0x10c(%rsp,%r11,4)
  aac21f:	mov    0x110(%rsp,%r11,4),%r12d
  aac227:	add    %ecx,%ebx
  aac229:	mov    %ebx,0x110(%rsp,%r11,4)
  aac231:	add    %ebx,%r12d
  aac234:	mov    0x114(%rsp,%r11,4),%ebx
  aac23c:	mov    %r12d,0x114(%rsp,%r11,4)
  aac244:	mov    0x118(%rsp,%r11,4),%ecx
  aac24c:	add    %r12d,%ebx
  aac24f:	mov    %ebx,0x118(%rsp,%r11,4)
  aac257:	add    %ebx,%ecx
  aac259:	mov    0x11c(%rsp,%r11,4),%ebx
  aac261:	mov    %ecx,0x11c(%rsp,%r11,4)
  aac269:	add    $0x10,%r11
  aac26d:	add    %ecx,%ebx
  aac26f:	cmp    $0x100,%r11
  aac276:	jne    aac145 <ir_verify_path+0x15c5>
  aac27c:	xor    %r11d,%r11d
  aac27f:	cmp    $0x4,%r15d
  aac283:	jae    aac28f <ir_verify_path+0x170f>
  aac285:	mov    0x8(%rsp),%r15
  aac28a:	jmp    aac3a0 <ir_verify_path+0x1820>
  aac28f:	mov    0x8(%rsp),%r15
  aac294:	mov    %r14,%rbp
  aac297:	mov    (%r9,%r11,4),%ebx
  aac29b:	mov    0x60(%r15),%rcx
  aac29f:	mov    %rbx,%r12
  aac2a2:	shl    $0x4,%r12
  aac2a6:	cmp    $0x8,%r8d
  aac2aa:	lea    (%rcx,%r12,1),%r13
  aac2ae:	lea    0x8(%rcx,%r12,1),%rcx
  aac2b3:	cmovb  %r13,%rcx
  aac2b7:	shrx   %r10,(%rcx),%rcx
  aac2bc:	movzbl %cl,%ecx
  aac2bf:	mov    0xe0(%rsp,%rcx,4),%r12d
  aac2c7:	mov    %ebx,0x0(%rbp,%r12,4)
  aac2cc:	incl   0xe0(%rsp,%rcx,4)
  aac2d3:	mov    0x4(%r9,%r11,4),%ebx
  aac2d8:	mov    0x60(%r15),%rcx
  aac2dc:	mov    %rbx,%r12
  aac2df:	shl    $0x4,%r12
  aac2e3:	cmp    $0x8,%r8d
  aac2e7:	lea    (%rcx,%r12,1),%r13
  aac2eb:	lea    0x8(%rcx,%r12,1),%rcx
  aac2f0:	cmovb  %r13,%rcx
  aac2f4:	shrx   %r10,(%rcx),%rcx
  aac2f9:	movzbl %cl,%ecx
  aac2fc:	mov    0xe0(%rsp,%rcx,4),%r12d
  aac304:	mov    %ebx,0x0(%rbp,%r12,4)
  aac309:	incl   0xe0(%rsp,%rcx,4)
  aac310:	mov    0x8(%r9,%r11,4),%ebx
  aac315:	mov    0x60(%r15),%rcx
  aac319:	mov    %rbx,%r12
  aac31c:	shl    $0x4,%r12
  aac320:	cmp    $0x8,%r8d
  aac324:	lea    (%rcx,%r12,1),%r13
  aac328:	lea    0x8(%rcx,%r12,1),%rcx
  aac32d:	cmovb  %r13,%rcx
  aac331:	shrx   %r10,(%rcx),%rcx
  aac336:	movzbl %cl,%ecx
  aac339:	mov    0xe0(%rsp,%rcx,4),%r12d
  aac341:	mov    %ebx,0x0(%rbp,%r12,4)
  aac346:	incl   0xe0(%rsp,%rcx,4)
  aac34d:	mov    0xc(%r9,%r11,4),%ebx
  aac352:	mov    0x60(%r15),%rcx
  aac356:	mov    %rbx,%r12
  aac359:	shl    $0x4,%r12
  aac35d:	cmp    $0x8,%r8d
  aac361:	lea    (%rcx,%r12,1),%r13
  aac365:	lea    0x8(%rcx,%r12,1),%rcx
  aac36a:	cmovb  %r13,%rcx
  aac36e:	add    $0x4,%r11
  aac372:	shrx   %r10,(%rcx),%rcx
  aac377:	movzbl %cl,%ecx
  aac37a:	mov    0xe0(%rsp,%rcx,4),%r12d
  aac382:	mov    %ebx,0x0(%rbp,%r12,4)
  aac387:	incl   0xe0(%rsp,%rcx,4)
  aac38e:	cmp    %r11,%rdi
  aac391:	jne    aac297 <ir_verify_path+0x1717>
  aac397:	test   %rsi,%rsi
  aac39a:	je     aabe29 <ir_verify_path+0x12a9>
  aac3a0:	lea    (%r9,%r11,4),%r11
  aac3a4:	xor    %r12d,%r12d
  aac3a7:	mov    (%r11,%r12,4),%r13d
  aac3ab:	mov    0x60(%r15),%rbx
  aac3af:	mov    %r13,%rbp
  aac3b2:	shl    $0x4,%rbp
  aac3b6:	cmp    $0x8,%r8d
  aac3ba:	lea    (%rbx,%rbp,1),%rcx
  aac3be:	lea    0x8(%rbx,%rbp,1),%rbx
  aac3c3:	mov    %r14,%rbp
  aac3c6:	cmovb  %rcx,%rbx
  aac3ca:	inc    %r12
  aac3cd:	shrx   %r10,(%rbx),%rcx
  aac3d2:	movzbl %cl,%ecx
  aac3d5:	mov    0xe0(%rsp,%rcx,4),%ebx
  aac3dc:	mov    %r13d,(%r14,%rbx,4)
  aac3e0:	incl   0xe0(%rsp,%rcx,4)
  aac3e7:	cmp    %r12,%rsi
  aac3ea:	jne    aac3a7 <ir_verify_path+0x1827>
  aac3ec:	jmp    aabe29 <ir_verify_path+0x12a9>
  aac3f1:	mov    0x58(%rsp),%r15
  aac3f6:	mov    0x50(%rsp),%rbp
  aac3fb:	mov    0x8(%rsp),%rax
  aac400:	mov    0x0(%rbp),%edi
  aac403:	mov    $0x2,%edx
  aac408:	mov    $0x7,%r11d
  aac40e:	mov    %rbp,%rbx
  aac411:	mov    0x60(%rax),%rcx
  aac415:	mov    %rdi,%rax
  aac418:	shl    $0x4,%rax
  aac41c:	mov    (%rcx,%rax,1),%rsi
  aac420:	mov    -0x4(%rbx,%rdx,4),%r8d
  aac425:	mov    %rsi,%r10
  aac428:	xor    %eax,%eax
  aac42a:	mov    %r8,%r9
  aac42d:	shl    $0x4,%r9
  aac431:	mov    (%rcx,%r9,1),%rsi
  aac435:	cmp    %rsi,%r10
  aac438:	jne    aac455 <ir_verify_path+0x18d5>
  aac43a:	mov    %edi,%eax
  aac43c:	shl    $0x4,%rax
  aac440:	add    %rcx,%r9
  aac443:	mov    0x8(%rcx,%rax,1),%rax
  aac448:	cmp    0x8(%r9),%rax
  aac44c:	mov    $0x0,%eax
  aac451:	cmove  %r11d,%eax
  aac455:	test   %eax,%eax
  aac457:	jne    aac465 <ir_verify_path+0x18e5>
  aac459:	mov    %r8d,%edi
  aac45c:	cmp    %r15,%rdx
  aac45f:	lea    0x1(%rdx),%rdx
  aac463:	jb     aac420 <ir_verify_path+0x18a0>
  aac465:	mov    0x88(%rsp),%r15
  aac46d:	mov    0x60(%rsp),%r11
  aac472:	mov    0x80(%rsp),%r13
  aac47a:	mov    0x8(%rsp),%rbp
  aac47f:	mov    0x10(%rsp),%r10
  aac484:	mov    0x98(%rsp),%r12
  aac48c:	movabs $0xffffffff00000000,%r8
  aac496:	xor    %r14d,%r14d
  aac499:	mov    0x8(%r15),%rcx
  aac49d:	lea    0x1(%r11),%rbx
  aac4a1:	mov    0x1c(%rsp),%esi
  aac4a5:	mov    0x70(%rsp),%r9
  aac4aa:	cmp    %rcx,%r9
  aac4ad:	ja     aacbfe <ir_verify_path+0x207e>
  aac4b3:	mov    %r9,0x8(%r15)
  aac4b7:	mov    %r12d,%r9d
  aac4ba:	inc    %r12
  aac4bd:	test   %eax,%eax
  aac4bf:	je     aab94f <ir_verify_path+0xdcf>
  aac4c5:	jmp    aac530 <ir_verify_path+0x19b0>
  aac4c7:	mov    0x48(%rbp),%ecx
  aac4ca:	cmp    %rcx,%rbx
  aac4cd:	jb     aab93f <ir_verify_path+0xdbf>
  aac4d3:	jmp    aaae13 <ir_verify_path+0x293>
  aac4d8:	mov    $0x9,%eax
  aac4dd:	mov    %ecx,%r14d
  aac4e0:	mov    %r12d,%r9d
  aac4e3:	movabs $0xffffffff00000000,%r8
  aac4ed:	jmp    aac530 <ir_verify_path+0x19b0>
  aac4ef:	cmpq   $0x0,0x48(%rsp)
  aac4f5:	mov    %ecx,%eax
  aac4f7:	je     aac59e <ir_verify_path+0x1a1e>
  aac4fd:	cmp    $0x8,%ecx
  aac500:	jae    aac5ac <ir_verify_path+0x1a2c>
  aac506:	xor    %ecx,%ecx
  aac508:	xor    %edx,%edx
  aac50a:	jmp    aac92b <ir_verify_path+0x1dab>
  aac50f:	movabs $0xffffffff00000000,%rax
  aac519:	xor    %r14d,%r14d
  aac51c:	mov    %rax,%r9
  aac51f:	shr    $0x20,%r9
  aac523:	jmp    aac530 <ir_verify_path+0x19b0>
  aac525:	mov    $0x9,%eax
  aac52a:	xor    %r14d,%r14d
  aac52d:	mov    %r12d,%r9d
  aac530:	cmpq   $0x0,0x48(%rsp)
  aac536:	mov    %eax,%r12d
  aac539:	setne  %cl
  aac53c:	test   %eax,%eax
  aac53e:	sete   %dl
  aac541:	cmp    $0x1,%eax
  aac544:	sbb    %esi,%esi
  aac546:	and    %cl,%dl
  aac548:	or     %r9d,%esi
  aac54b:	movzbl %dl,%edx
  aac54e:	shl    $0x20,%rdx
  aac552:	shl    $0x20,%rsi
  aac556:	or     %r14,%rdx
  aac559:	or     %rsi,%r12
  aac55c:	cmp    0x8(%r15),%r13
  aac560:	ja     aacbfe <ir_verify_path+0x207e>
  aac566:	mov    %r13,0x8(%r15)
  aac56a:	mov    %fs:0x28,%rcx
  aac573:	cmp    0x4e0(%rsp),%rcx
  aac57b:	jne    aacc20 <ir_verify_path+0x20a0>
  aac581:	and    %r8,%r12
  aac584:	mov    %eax,%eax
  aac586:	or     %r12,%rax
  aac589:	add    $0x4e8,%rsp
  aac590:	pop    %rbx
  aac591:	pop    %r12
  aac593:	pop    %r13
  aac595:	pop    %r14
  aac597:	pop    %r15
  aac599:	pop    %rbp
  aac59a:	vzeroupper
  aac59d:	ret
  aac59e:	cmp    $0x8,%ecx
  aac5a1:	jae    aac5ba <ir_verify_path+0x1a3a>
  aac5a3:	xor    %ecx,%ecx
  aac5a5:	xor    %edx,%edx
  aac5a7:	jmp    aacbd6 <ir_verify_path+0x2056>
  aac5ac:	cmp    $0x20,%ecx
  aac5af:	jae    aac5cc <ir_verify_path+0x1a4c>
  aac5b1:	xor    %ecx,%ecx
  aac5b3:	xor    %edx,%edx
  aac5b5:	jmp    aac7ec <ir_verify_path+0x1c6c>
  aac5ba:	cmp    $0x40,%ecx
  aac5bd:	jae    aac974 <ir_verify_path+0x1df4>
  aac5c3:	xor    %ecx,%ecx
  aac5c5:	xor    %edx,%edx
  aac5c7:	jmp    aacb2c <ir_verify_path+0x1fac>
  aac5cc:	vmovdqa64 -0x5bafd6(%rip),%zmm1        # 4f1600 <check_builtin_atomic_rmw_test_clang.native_source+0x5c40>
  aac5d6:	vpbroadcastd -0x4b6888(%rip),%zmm2        # 5f5d58 <cbuiltin_varargs_aggregate.ends+0x248>
  aac5e0:	vpbroadcastd -0x4b688e(%rip),%zmm3        # 5f5d5c <cbuiltin_varargs_aggregate.ends+0x24c>
  aac5ea:	mov    %eax,%edx
  aac5ec:	shr    $0x5,%edx
  aac5ef:	mov    %eax,%ecx
  aac5f1:	and    $0xffffffe0,%ecx
  aac5f4:	lea    0x2e0(%rsp),%rsi
  aac5fc:	vpxor  %xmm0,%xmm0,%xmm0
  aac600:	xor    %edi,%edi
  aac602:	vpxor  %xmm4,%xmm4,%xmm4
  aac606:	shl    $0x7,%rdx
  aac60a:	vmovdqu64 0x160(%rsp,%rdi,1),%zmm5
  aac615:	vmovdqu64 0x1a0(%rsp,%rdi,1),%zmm6
  aac620:	vmovdqu64 0x1e0(%rsp,%rdi,1),%zmm7
  aac62b:	vpcmpneqd %zmm6,%zmm5,%k2
  aac632:	vpcmpeqd %zmm6,%zmm5,%k3
  aac638:	vpcmpneqd %zmm7,%zmm6,%k1
  aac63f:	vpcmpeqd %zmm7,%zmm6,%k4
  aac645:	vmovdqu32 -0xc0(%rsi,%rdi,1),%zmm5{%k2}{z}
  aac64d:	vmovdqu32 -0x80(%rsi,%rdi,1),%zmm6{%k1}{z}
  aac655:	kmovw  %k1,0x30(%rsp)
  aac65b:	vptestnmd %zmm5,%zmm5,%k0
  aac661:	korw   %k0,%k3,%k5
  aac665:	kmovw  %k0,0x40(%rsp)
  aac66b:	knotw  %k5,%k5
  aac66f:	vmovdqu32 -0x40(%rsi,%rdi,1),%zmm7{%k5}{z}
  aac677:	vptestmd %zmm7,%zmm7,%k5{%k5}
  aac67d:	vpcmpltud %zmm7,%zmm5,%k7
  aac684:	vmovdqu32 -0x100(%rsi,%rdi,1),%zmm8{%k5}{z}
  aac68c:	vmovdqu32 -0x80(%rsi,%rdi,1),%zmm9{%k5}{z}
  aac694:	vpcmpnleud %zmm9,%zmm8,%k6
  aac69b:	korw   %k6,%k7,%k0
  aac69f:	vptestnmd %zmm6,%zmm6,%k6
  aac6a5:	korw   %k6,%k4,%k7
  aac6a9:	kmovw  %k0,0x10(%rsp)
  aac6af:	knotw  %k7,%k7
  aac6b3:	vmovdqu32 (%rsi,%rdi,1),%zmm5{%k7}{z}
  aac6ba:	vptestmd %zmm5,%zmm5,%k7{%k7}
  aac6c0:	vpcmpltud %zmm5,%zmm6,%k1
  aac6c7:	vmovdqu32 -0x200(%rsi,%rdi,1),%zmm5{%k3}{z}
  aac6cf:	vmovdqu32 -0x1c0(%rsi,%rdi,1),%zmm6{%k3}{z}
  aac6d7:	kmovw  0x30(%rsp),%k3
  aac6dd:	vmovdqu32 -0xc0(%rsi,%rdi,1),%zmm7{%k7}{z}
  aac6e5:	vmovdqu32 -0x40(%rsi,%rdi,1),%zmm8{%k7}{z}
  aac6ed:	vpcmpnleud %zmm8,%zmm7,%k0
  aac6f4:	vmovdqu32 -0x1c0(%rsi,%rdi,1),%zmm7{%k4}{z}
  aac6fc:	vmovdqu32 -0x180(%rsi,%rdi,1),%zmm8{%k4}{z}
  aac704:	sub    $0xffffffffffffff80,%rdi
  aac708:	korw   %k0,%k1,%k0
  aac70c:	vpcmpnltud %zmm6,%zmm5,%k1
  aac713:	kmovw  %k0,0x38(%rsp)
  aac719:	kmovw  0x40(%rsp),%k0
  aac71f:	korw   %k1,%k2,%k1
  aac723:	kandnw %k1,%k5,%k1
  aac727:	kandw  %k0,%k2,%k0
  aac72b:	kmovw  0x10(%rsp),%k2
  aac731:	kandw  %k5,%k2,%k2
  aac735:	korw   %k1,%k2,%k1
  aac739:	kandw  %k6,%k3,%k2
  aac73d:	korw   %k1,%k0,%k0
  aac741:	vpcmpnltud %zmm8,%zmm7,%k1
  aac748:	vpaddd %zmm2,%zmm1,%zmm7
  aac74e:	korw   %k1,%k3,%k1
  aac752:	kmovw  0x38(%rsp),%k3
  aac758:	vpmovm2d %k0,%zmm5
  aac75e:	vpsrld $0x1f,%zmm5,%zmm5
  aac765:	kandnw %k1,%k7,%k1
  aac769:	vpsllvd %zmm1,%zmm5,%zmm5
  aac76f:	vpaddd %zmm3,%zmm1,%zmm1
  aac775:	vpord  %zmm0,%zmm5,%zmm0
  aac77b:	kandw  %k7,%k3,%k3
  aac77f:	korw   %k1,%k3,%k1
  aac783:	korw   %k1,%k2,%k1
  aac787:	vpmovm2d %k1,%zmm6
  aac78d:	vpsrld $0x1f,%zmm6,%zmm6
  aac794:	vpsllvd %zmm7,%zmm6,%zmm6
  aac79a:	vpord  %zmm4,%zmm6,%zmm4
  aac7a0:	cmp    %rdi,%rdx
  aac7a3:	jne    aac60a <ir_verify_path+0x1a8a>
  aac7a9:	vpord  %zmm0,%zmm4,%zmm0
  aac7af:	vextracti64x4 $0x1,%zmm0,%ymm1
  aac7b6:	vpord  %zmm1,%zmm0,%zmm0
  aac7bc:	vextracti128 $0x1,%ymm0,%xmm1
  aac7c2:	vpor   %xmm1,%xmm0,%xmm0
  aac7c6:	vpshufd $0xee,%xmm0,%xmm1
  aac7cb:	vpor   %xmm1,%xmm0,%xmm0
  aac7cf:	vpshufd $0x55,%xmm0,%xmm1
  aac7d4:	vpor   %xmm1,%xmm0,%xmm0
  aac7d8:	vmovd  %xmm0,%edx
  aac7dc:	cmp    %eax,%ecx
  aac7de:	je     aab8c0 <ir_verify_path+0xd40>
  aac7e4:	test   $0x18,%al
  aac7e6:	je     aac92b <ir_verify_path+0x1dab>
  aac7ec:	mov    %rcx,%rsi
  aac7ef:	vpbroadcastd %esi,%ymm1
  aac7f5:	vpor   -0x4e5cbd(%rip),%ymm1,%ymm1        # 5c6b40 <tier0_jcc_rel8+0x11e0>
  aac7fd:	vpbroadcastd -0x4b6aa6(%rip),%ymm2        # 5f5d60 <cbuiltin_varargs_aggregate.ends+0x250>
  aac806:	mov    %eax,%ecx
  aac808:	lea    0x2a0(%rsp),%rdi
  aac810:	and    $0xfffffff8,%ecx
  aac813:	vmovd  %edx,%xmm0
  aac817:	vmovdqu 0x160(%rsp,%rsi,4),%ymm3
  aac820:	vmovdqu 0x1a0(%rsp,%rsi,4),%ymm4
  aac829:	vpcmpneqd %ymm4,%ymm3,%k1
  aac830:	vpcmpeqd %ymm4,%ymm3,%k2
  aac836:	vmovdqu32 -0x80(%rdi,%rsi,4),%ymm3{%k1}{z}
  aac83e:	vptestnmd %ymm3,%ymm3,%k0
  aac844:	korb   %k0,%k2,%k3
  aac848:	kandb  %k0,%k1,%k0
  aac84c:	knotb  %k3,%k3
  aac850:	vmovdqu32 (%rdi,%rsi,4),%ymm4{%k3}{z}
  aac857:	vptestmd %ymm4,%ymm4,%k3{%k3}
  aac85d:	vpcmpltud %ymm4,%ymm3,%k5
  aac864:	vmovdqu32 -0x1c0(%rdi,%rsi,4),%ymm3{%k2}{z}
  aac86c:	vmovdqu32 -0x180(%rdi,%rsi,4),%ymm4{%k2}{z}
  aac874:	vmovdqu32 -0xc0(%rdi,%rsi,4),%ymm5{%k3}{z}
  aac87c:	vmovdqu32 -0x40(%rdi,%rsi,4),%ymm6{%k3}{z}
  aac884:	add    $0x8,%rsi
  aac888:	vpcmpnltud %ymm4,%ymm3,%k2
  aac88f:	korb   %k2,%k1,%k1
  aac893:	kandnb %k1,%k3,%k1
  aac897:	vpcmpnleud %ymm6,%ymm5,%k4
  aac89e:	korb   %k4,%k5,%k4
  aac8a2:	kandb  %k3,%k4,%k2
  aac8a6:	korb   %k1,%k2,%k1
  aac8aa:	korb   %k1,%k0,%k0
  aac8ae:	vpmovm2d %k0,%ymm3
  aac8b4:	vpsrld $0x1f,%ymm3,%ymm3
  aac8b9:	vpsllvd %ymm1,%ymm3,%ymm3
  aac8be:	vpaddd %ymm2,%ymm1,%ymm1
  aac8c2:	vpor   %ymm0,%ymm3,%ymm0
  aac8c6:	cmp    %rsi,%rcx
  aac8c9:	jne    aac817 <ir_verify_path+0x1c97>
  aac8cf:	vextracti128 $0x1,%ymm0,%xmm1
  aac8d5:	vpor   %xmm1,%xmm0,%xmm0
  aac8d9:	vpshufd $0xee,%xmm0,%xmm1
  aac8de:	vpor   %xmm1,%xmm0,%xmm0
  aac8e2:	vpshufd $0x55,%xmm0,%xmm1
  aac8e7:	vpor   %xmm1,%xmm0,%xmm0
  aac8eb:	vmovd  %xmm0,%edx
  aac8ef:	cmp    %eax,%ecx
  aac8f1:	jne    aac92b <ir_verify_path+0x1dab>
  aac8f3:	jmp    aab8c0 <ir_verify_path+0xd40>
  aac8f8:	mov    0xe0(%rsp,%rcx,4),%esi
  aac8ff:	cmp    0x120(%rsp,%rcx,4),%esi
  aac906:	setae  %sil
  aac90a:	movzbl %sil,%esi
  aac90e:	movabs $0xffffffff00000000,%r8
  aac918:	shlx   %ecx,%esi,%esi
  aac91d:	inc    %rcx
  aac920:	or     %esi,%edx
  aac922:	cmp    %rcx,%rax
  aac925:	je     aab8c0 <ir_verify_path+0xd40>
  aac92b:	mov    0x160(%rsp,%rcx,4),%esi
  aac932:	cmp    0x1a0(%rsp,%rcx,4),%esi
  aac939:	je     aac8f8 <ir_verify_path+0x1d78>
  aac93b:	mov    0x220(%rsp,%rcx,4),%edi
  aac942:	mov    $0x1,%sil
  aac945:	test   %edi,%edi
  aac947:	je     aac90a <ir_verify_path+0x1d8a>
  aac949:	mov    0x2a0(%rsp,%rcx,4),%r8d
  aac951:	test   %r8d,%r8d
  aac954:	je     aac90a <ir_verify_path+0x1d8a>
  aac956:	mov    0x1e0(%rsp,%rcx,4),%esi
  aac95d:	cmp    0x260(%rsp,%rcx,4),%esi
  aac964:	seta   %r9b
  aac968:	cmp    %r8d,%edi
  aac96b:	setb   %sil
  aac96f:	or     %r9b,%sil
  aac972:	jmp    aac90a <ir_verify_path+0x1d8a>
  aac974:	vmovdqa64 -0x5bb37e(%rip),%zmm1        # 4f1600 <check_builtin_atomic_rmw_test_clang.native_source+0x5c40>
  aac97e:	vpbroadcastd -0x4b6c30(%rip),%zmm2        # 5f5d58 <cbuiltin_varargs_aggregate.ends+0x248>
  aac988:	vpbroadcastd -0x4b6c36(%rip),%zmm3        # 5f5d5c <cbuiltin_varargs_aggregate.ends+0x24c>
  aac992:	vpbroadcastd -0x4b6c38(%rip),%zmm4        # 5f5d64 <cbuiltin_varargs_aggregate.ends+0x254>
  aac99c:	vpbroadcastd -0x4b6c3e(%rip),%zmm5        # 5f5d68 <cbuiltin_varargs_aggregate.ends+0x258>
  aac9a6:	mov    %eax,%edx
  aac9a8:	shr    $0x6,%edx
  aac9ab:	mov    %eax,%ecx
  aac9ad:	and    $0xffffffc0,%ecx
  aac9b0:	lea    0x260(%rsp),%rsi
  aac9b8:	vpxor  %xmm0,%xmm0,%xmm0
  aac9bc:	xor    %edi,%edi
  aac9be:	vpxor  %xmm6,%xmm6,%xmm6
  aac9c2:	vpxor  %xmm8,%xmm8,%xmm8
  aac9c7:	vpxor  %xmm7,%xmm7,%xmm7
  aac9cb:	shl    $0x8,%rdx
  aac9cf:	vmovdqu64 0x1a0(%rsp,%rdi,1),%zmm12
  aac9da:	vmovdqu64 0x1e0(%rsp,%rdi,1),%zmm13
  aac9e5:	vmovdqu64 0x220(%rsp,%rdi,1),%zmm14
  aac9f0:	vpaddd %zmm2,%zmm1,%zmm9
  aac9f6:	vpaddd %zmm3,%zmm1,%zmm10
  aac9fc:	vpaddd %zmm4,%zmm1,%zmm11
  aaca02:	vpcmpeqd 0x160(%rsp,%rdi,1),%zmm12,%k2
  aaca0d:	vpcmpeqd 0x260(%rsp,%rdi,1),%zmm14,%k1
  aaca18:	vpcmpeqd %zmm13,%zmm12,%k3
  aaca1e:	vpcmpeqd %zmm14,%zmm13,%k4
  aaca24:	vmovdqu32 -0x140(%rsi,%rdi,1),%zmm12{%k2}{z}
  aaca2c:	vmovdqu32 -0x100(%rsi,%rdi,1),%zmm13{%k3}{z}
  aaca34:	vmovdqu32 -0xc0(%rsi,%rdi,1),%zmm14{%k4}{z}
  aaca3c:	vmovdqu32 -0x80(%rsi,%rdi,1),%zmm15{%k1}{z}
  aaca44:	vpcmpleud -0x180(%rsi,%rdi,1),%zmm12,%k0{%k2}
  aaca4d:	vpcmpleud -0xc0(%rsi,%rdi,1),%zmm15,%k1{%k1}
  aaca56:	vpmovm2d %k0,%zmm12
  aaca5c:	vpcmpleud -0x140(%rsi,%rdi,1),%zmm13,%k0{%k3}
  aaca65:	vpsrld $0x1f,%zmm12,%zmm12
  aaca6c:	vpmovm2d %k0,%zmm13
  aaca72:	vpcmpleud -0x100(%rsi,%rdi,1),%zmm14,%k0{%k4}
  aaca7b:	vpsrld $0x1f,%zmm13,%zmm13
  aaca82:	add    $0x100,%rdi
  aaca89:	vpsllvd %zmm9,%zmm13,%zmm9
  aaca8f:	vpord  %zmm8,%zmm9,%zmm8
  aaca95:	vpmovm2d %k0,%zmm9
  aaca9b:	vpsrld $0x1f,%zmm9,%zmm9
  aacaa2:	vpsllvd %zmm10,%zmm9,%zmm9
  aacaa8:	vpsllvd %zmm1,%zmm12,%zmm10
  aacaae:	vpaddd %zmm5,%zmm1,%zmm1
  aacab4:	vpord  %zmm7,%zmm9,%zmm7
  aacaba:	vpmovm2d %k1,%zmm9
  aacac0:	vpsrld $0x1f,%zmm9,%zmm9
  aacac7:	vpord  %zmm6,%zmm10,%zmm6
  aacacd:	vpsllvd %zmm11,%zmm9,%zmm9
  aacad3:	vpord  %zmm0,%zmm9,%zmm0
  aacad9:	cmp    %rdi,%rdx
  aacadc:	jne    aac9cf <ir_verify_path+0x1e4f>
  aacae2:	vpord  %zmm6,%zmm8,%zmm1
  aacae8:	vpternlogd $0xfe,%zmm1,%zmm7,%zmm0
  aacaef:	vextracti64x4 $0x1,%zmm0,%ymm1
  aacaf6:	vpord  %zmm1,%zmm0,%zmm0
  aacafc:	vextracti128 $0x1,%ymm0,%xmm1
  aacb02:	vpor   %xmm1,%xmm0,%xmm0
  aacb06:	vpshufd $0xee,%xmm0,%xmm1
  aacb0b:	vpor   %xmm1,%xmm0,%xmm0
  aacb0f:	vpshufd $0x55,%xmm0,%xmm1
  aacb14:	vpor   %xmm1,%xmm0,%xmm0
  aacb18:	vmovd  %xmm0,%edx
  aacb1c:	cmp    %eax,%ecx
  aacb1e:	je     aab8c0 <ir_verify_path+0xd40>
  aacb24:	test   $0x38,%al
  aacb26:	je     aacbd6 <ir_verify_path+0x2056>
  aacb2c:	mov    %rcx,%rsi
  aacb2f:	vpbroadcastd %esi,%ymm1
  aacb35:	vpor   -0x4e5ffd(%rip),%ymm1,%ymm1        # 5c6b40 <tier0_jcc_rel8+0x11e0>
  aacb3d:	vpbroadcastd -0x4b6de6(%rip),%ymm2        # 5f5d60 <cbuiltin_varargs_aggregate.ends+0x250>
  aacb46:	mov    %eax,%ecx
  aacb48:	lea    0x1a0(%rsp),%rdi
  aacb50:	and    $0xfffffff8,%ecx
  aacb53:	vmovd  %edx,%xmm0
  aacb57:	vmovdqu 0x160(%rsp,%rsi,4),%ymm3
  aacb60:	vpcmpeqd 0x1a0(%rsp,%rsi,4),%ymm3,%k1
  aacb68:	vmovdqu32 -0x80(%rdi,%rsi,4),%ymm3{%k1}{z}
  aacb70:	vpcmpleud -0xc0(%rdi,%rsi,4),%ymm3,%k0{%k1}
  aacb79:	add    $0x8,%rsi
  aacb7d:	vpmovm2d %k0,%ymm3
  aacb83:	vpsrld $0x1f,%ymm3,%ymm3
  aacb88:	vpsllvd %ymm1,%ymm3,%ymm3
  aacb8d:	vpaddd %ymm2,%ymm1,%ymm1
  aacb91:	vpor   %ymm0,%ymm3,%ymm0
  aacb95:	cmp    %rsi,%rcx
  aacb98:	jne    aacb57 <ir_verify_path+0x1fd7>
  aacb9a:	vextracti128 $0x1,%ymm0,%xmm1
  aacba0:	vpor   %xmm1,%xmm0,%xmm0
  aacba4:	vpshufd $0xee,%xmm0,%xmm1
  aacba9:	vpor   %xmm1,%xmm0,%xmm0
  aacbad:	vpshufd $0x55,%xmm0,%xmm1
  aacbb2:	vpor   %xmm1,%xmm0,%xmm0
  aacbb6:	vmovd  %xmm0,%edx
  aacbba:	cmp    %eax,%ecx
  aacbbc:	jne    aacbd6 <ir_verify_path+0x2056>
  aacbbe:	jmp    aab8c0 <ir_verify_path+0xd40>
  aacbc3:	shlx   %ecx,%esi,%esi
  aacbc8:	inc    %rcx
  aacbcb:	or     %esi,%edx
  aacbcd:	cmp    %rcx,%rax
  aacbd0:	je     aab8c0 <ir_verify_path+0xd40>
  aacbd6:	mov    0x160(%rsp,%rcx,4),%edi
  aacbdd:	xor    %esi,%esi
  aacbdf:	cmp    0x1a0(%rsp,%rcx,4),%edi
  aacbe6:	jne    aacbc3 <ir_verify_path+0x2043>
  aacbe8:	mov    0xe0(%rsp,%rcx,4),%edi
  aacbef:	xor    %esi,%esi
  aacbf1:	cmp    0x120(%rsp,%rcx,4),%edi
  aacbf8:	setae  %sil
  aacbfc:	jmp    aacbc3 <ir_verify_path+0x2043>
  aacbfe:	lea    -0x37d11a(%rip),%rdi        # 72faeb <pp_string_value.meaning+0x6a16a>
  aacc05:	lea    -0x3c0c8b(%rip),%rsi        # 6ebf81 <pp_string_value.meaning+0x26600>
  aacc0c:	lea    -0x3c0c77(%rip),%rcx        # 6ebf9c <pp_string_value.meaning+0x2661b>
  aacc13:	mov    $0xbb,%edx
  aacc18:	vzeroupper
  aacc1b:	call   7c38f0 <__assert_fail@plt>
  aacc20:	vzeroupper
  aacc23:	call   7c3880 <__stack_chk_fail@plt>
