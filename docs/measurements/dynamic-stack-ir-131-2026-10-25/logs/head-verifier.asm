
deliver/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000aa48c0 <ir_verify_path>:
  aa48c0:	push   %rbp
  aa48c1:	push   %r15
  aa48c3:	push   %r14
  aa48c5:	push   %r13
  aa48c7:	push   %r12
  aa48c9:	push   %rbx
  aa48ca:	sub    $0x4e8,%rsp
  aa48d1:	mov    %fs:0x28,%rax
  aa48da:	mov    %ecx,%ebx
  aa48dc:	mov    %rdx,%r14
  aa48df:	mov    %rsi,%r15
  aa48e2:	mov    %rdi,%rbp
  aa48e5:	mov    %rax,0x4e0(%rsp)
  aa48ed:	mov    0x8(%rsi),%r13
  aa48f1:	call   aa7430 <ir_check_shape>
  aa48f6:	movabs $0xffffffff00000000,%r8
  aa4900:	test   %eax,%eax
  aa4902:	je     aa490c <ir_verify_path+0x4c>
  aa4904:	mov    %rax,%r12
  aa4907:	jmp    aa629c <ir_verify_path+0x19dc>
  aa490c:	movzbl %bl,%esi
  aa490f:	mov    %rbp,%rdi
  aa4912:	call   aa7780 <ir_check_rows>
  aa4917:	vpxor  %xmm0,%xmm0,%xmm0
  aa491b:	vmovdqu %ymm0,0xb8(%rsp)
  aa4924:	mov    %rax,%r12
  aa4927:	vmovdqu %ymm0,0xa0(%rsp)
  aa4930:	test   %eax,%eax
  aa4932:	je     aa4943 <ir_verify_path+0x83>
  aa4934:	movabs $0xffffffff00000000,%r8
  aa493e:	jmp    aa629c <ir_verify_path+0x19dc>
  aa4943:	lea    0xa0(%rsp),%rcx
  aa494b:	mov    %ebx,0x2c(%rsp)
  aa494f:	mov    %rdx,%rbx
  aa4952:	mov    %rbp,%rdi
  aa4955:	mov    %r15,%rsi
  aa4958:	mov    %r15,%rdx
  aa495b:	vzeroupper
  aa495e:	call   aa6970 <ir_cfg_validated>
  aa4963:	movabs $0xffffffff00000000,%r8
  aa496d:	mov    %rbx,%rdx
  aa4970:	test   %eax,%eax
  aa4972:	jne    aa629c <ir_verify_path+0x19dc>
  aa4978:	mov    0x48(%rbp),%edx
  aa497b:	mov    $0x1,%bl
  aa497d:	mov    %rbp,0x8(%rsp)
  aa4982:	test   %rdx,%rdx
  aa4985:	je     aa49b4 <ir_verify_path+0xf4>
  aa4987:	mov    (%r15),%rsi
  aa498a:	mov    0x8(%r15),%rax
  aa498e:	mov    $0x2,%ecx
  aa4993:	lea    0x3f(%rax,%rsi,1),%r12
  aa4998:	add    %rsi,%rax
  aa499b:	and    $0xffffffffffffffc0,%r12
  aa499f:	cmp    %rax,%r12
  aa49a2:	jae    aa49c4 <ir_verify_path+0x104>
  aa49a4:	xor    %ebx,%ebx
  aa49a6:	movq   $0x0,0x20(%rsp)
  aa49af:	jmp    aa4a53 <ir_verify_path+0x193>
  aa49b4:	xor    %ecx,%ecx
  aa49b6:	movq   $0x0,0x20(%rsp)
  aa49bf:	jmp    aa4a53 <ir_verify_path+0x193>
  aa49c4:	mov    %r12,%rax
  aa49c7:	sub    %rsi,%rax
  aa49ca:	mov    0x10(%r15),%rsi
  aa49ce:	shl    $0x2,%rdx
  aa49d2:	sub    %rax,%rsi
  aa49d5:	setb   %dil
  aa49d9:	cmp    %rsi,%rdx
  aa49dc:	seta   %sil
  aa49e0:	or     %dil,%sil
  aa49e3:	je     aa49f7 <ir_verify_path+0x137>
  aa49e5:	mov    0x8(%rsp),%rbp
  aa49ea:	xor    %ebx,%ebx
  aa49ec:	movq   $0x0,0x20(%rsp)
  aa49f5:	jmp    aa4a53 <ir_verify_path+0x193>
  aa49f7:	add    %rdx,%rax
  aa49fa:	mov    %rax,0x8(%r15)
  aa49fe:	test   %r12,%r12
  aa4a01:	je     aa4a43 <ir_verify_path+0x183>
  aa4a03:	mov    %r12,%rdi
  aa4a06:	xor    %esi,%esi
  aa4a08:	call   7c4270 <memset@plt>
  aa4a0d:	mov    0x8(%rsp),%rbp
  aa4a12:	mov    0x48(%rbp),%edx
  aa4a15:	test   %rdx,%rdx
  aa4a18:	je     aa4a30 <ir_verify_path+0x170>
  aa4a1a:	shl    $0x2,%rdx
  aa4a1e:	mov    $0xff,%esi
  aa4a23:	mov    %r12,%rdi
  aa4a26:	call   7c4270 <memset@plt>
  aa4a2b:	mov    0x8(%rsp),%rbp
  aa4a30:	movabs $0xffffffff00000000,%r8
  aa4a3a:	xor    %ecx,%ecx
  aa4a3c:	mov    %r12,0x20(%rsp)
  aa4a41:	jmp    aa4a53 <ir_verify_path+0x193>
  aa4a43:	mov    0x8(%rsp),%rbp
  aa4a48:	movq   $0x0,0x20(%rsp)
  aa4a51:	xor    %ebx,%ebx
  aa4a53:	mov    %r15,0x88(%rsp)
  aa4a5b:	mov    %r13,0x80(%rsp)
  aa4a63:	mov    %r14,0x48(%rsp)
  aa4a68:	test   %r14,%r14
  aa4a6b:	je     aa4ae0 <ir_verify_path+0x220>
  aa4a6d:	mov    0x10(%r14),%edx
  aa4a71:	mov    $0xffffffff,%r9d
  aa4a77:	mov    $0xa,%eax
  aa4a7c:	cmp    0x48(%rbp),%edx
  aa4a7f:	jne    aa4ad8 <ir_verify_path+0x218>
  aa4a81:	test   %rdx,%rdx
  aa4a84:	je     aa4b23 <ir_verify_path+0x263>
  aa4a8a:	cmpq   $0x0,(%r14)
  aa4a8e:	je     aa4ad8 <ir_verify_path+0x218>
  aa4a90:	cmpq   $0x0,0x8(%r14)
  aa4a95:	mov    $0xa,%eax
  aa4a9a:	setne  %sil
  aa4a9e:	cmovne %ecx,%eax
  aa4aa1:	test   %bl,%sil
  aa4aa4:	je     aa4ad8 <ir_verify_path+0x218>
  aa4aa6:	mov    (%r14),%rax
  aa4aa9:	mov    0x8(%r14),%rcx
  aa4aad:	xor    %r14d,%r14d
  aa4ab0:	jmp    aa4abe <ir_verify_path+0x1fe>
  aa4ab2:	inc    %r14
  aa4ab5:	cmp    %r14,%rdx
  aa4ab8:	je     aa5641 <ir_verify_path+0xd81>
  aa4abe:	mov    (%rax,%r14,4),%esi
  aa4ac2:	mov    (%rcx,%r14,4),%edi
  aa4ac6:	cmp    %edi,%esi
  aa4ac8:	jb     aa4ab2 <ir_verify_path+0x1f2>
  aa4aca:	or     %esi,%edi
  aa4acc:	je     aa4ab2 <ir_verify_path+0x1f2>
  aa4ace:	mov    $0xa,%eax
  aa4ad3:	jmp    aa6270 <ir_verify_path+0x19b0>
  aa4ad8:	xor    %r14d,%r14d
  aa4adb:	jmp    aa6270 <ir_verify_path+0x19b0>
  aa4ae0:	test   %bl,%bl
  aa4ae2:	je     aa4b18 <ir_verify_path+0x258>
  aa4ae4:	cmpl   $0x0,0x48(%rbp)
  aa4ae8:	lea    0x50(%rbp),%rcx
  aa4aec:	lea    0x40(%rbp),%rax
  aa4af0:	lea    0x28(%rbp),%r10
  aa4af4:	lea    0x20(%rbp),%rdx
  aa4af8:	mov    %rcx,0x38(%rsp)
  aa4afd:	lea    0x30(%rbp),%rcx
  aa4b01:	mov    %rax,0x40(%rsp)
  aa4b06:	mov    %rdx,0x30(%rsp)
  aa4b0b:	mov    %rcx,0x68(%rsp)
  aa4b10:	jne    aa566e <ir_verify_path+0xdae>
  aa4b16:	jmp    aa4b53 <ir_verify_path+0x293>
  aa4b18:	mov    $0xffffffff,%r9d
  aa4b1e:	jmp    aa5535 <ir_verify_path+0xc75>
  aa4b23:	test   %bl,%bl
  aa4b25:	je     aa5535 <ir_verify_path+0xc75>
  aa4b2b:	lea    0x50(%rbp),%rcx
  aa4b2f:	lea    0x40(%rbp),%rax
  aa4b33:	lea    0x28(%rbp),%r10
  aa4b37:	lea    0x20(%rbp),%rdx
  aa4b3b:	mov    %rcx,0x38(%rsp)
  aa4b40:	lea    0x30(%rbp),%rcx
  aa4b44:	mov    %rax,0x40(%rsp)
  aa4b49:	mov    %rdx,0x30(%rsp)
  aa4b4e:	mov    %rcx,0x68(%rsp)
  aa4b53:	vpxor  %xmm0,%xmm0,%xmm0
  aa4b57:	vmovdqu64 %zmm0,0x320(%rsp)
  aa4b62:	vmovdqu64 %zmm0,0x2e0(%rsp)
  aa4b6d:	vmovdqu64 %zmm0,0x2a0(%rsp)
  aa4b78:	vmovdqu64 %zmm0,0x260(%rsp)
  aa4b83:	vmovdqu64 %zmm0,0x220(%rsp)
  aa4b8e:	vmovdqu64 %zmm0,0x1e0(%rsp)
  aa4b99:	vmovdqu64 %zmm0,0x1a0(%rsp)
  aa4ba4:	vmovdqu64 %zmm0,0x160(%rsp)
  aa4baf:	vmovdqu64 %zmm0,0x120(%rsp)
  aa4bba:	vmovdqu64 %zmm0,0xe0(%rsp)
  aa4bc5:	movl   $0x0,0x360(%rsp)
  aa4bd0:	xor    %eax,%eax
  aa4bd2:	mov    0x38(%rbp),%ecx
  aa4bd5:	mov    %rcx,0x20(%rsp)
  aa4bda:	test   %rcx,%rcx
  aa4bdd:	je     aa553f <ir_verify_path+0xc7f>
  aa4be3:	mov    0xc8(%rsp),%rdx
  aa4beb:	mov    0x0(%rbp),%rsi
  aa4bef:	mov    $0xffffffff,%r9d
  aa4bf5:	mov    %r10,0x10(%rsp)
  aa4bfa:	xor    %r14d,%r14d
  aa4bfd:	xor    %r8d,%r8d
  aa4c00:	xor    %ecx,%ecx
  aa4c02:	movzbl (%rsi,%r8,1),%r11d
  aa4c07:	lea    -0x5a96de(%rip),%rdi        # 4fb530 <ir_operand_table>
  aa4c0e:	movzbl (%r11,%rdi,1),%edi
  aa4c13:	cmp    $0x33,%r11
  aa4c17:	je     aa4c43 <ir_verify_path+0x383>
  aa4c19:	mov    0x2c(%rsp),%r15d
  aa4c1e:	cmp    $0x2a,%r11d
  aa4c22:	jne    aa4c66 <ir_verify_path+0x3a6>
  aa4c24:	mov    0x10(%rsp),%r10
  aa4c29:	mov    (%r10),%r11
  aa4c2c:	mov    %edi,%r10d
  aa4c2f:	or     $0x2,%r10d
  aa4c33:	cmpl   $0xffffffff,(%r11,%r8,4)
  aa4c38:	cmove  %edi,%r10d
  aa4c3c:	popcnt %r10d,%r10d
  aa4c41:	jmp    aa4ca8 <ir_verify_path+0x3e8>
  aa4c43:	mov    0x30(%rsp),%r10
  aa4c48:	mov    0x2c(%rsp),%r15d
  aa4c4d:	mov    (%r10),%r11
  aa4c50:	xor    %r10d,%r10d
  aa4c53:	cmpl   $0xffffffff,(%r11,%r8,4)
  aa4c58:	setne  %r10b
  aa4c5c:	or     %edi,%r10d
  aa4c5f:	popcnt %r10d,%r10d
  aa4c64:	jmp    aa4ca8 <ir_verify_path+0x3e8>
  aa4c66:	popcnt %edi,%r10d
  aa4c6b:	lea    -0x2d(%r11),%ebx
  aa4c6f:	cmp    $0x2,%ebx
  aa4c72:	jae    aa4c93 <ir_verify_path+0x3d3>
  aa4c74:	mov    0x8(%rsp),%r11
  aa4c79:	mov    0x28(%r11),%rdi
  aa4c7d:	mov    0x90(%r11),%r11
  aa4c84:	mov    (%rdi,%r8,4),%edi
  aa4c88:	lea    (%rdi,%rdi,4),%rdi
  aa4c8c:	mov    0x4(%r11,%rdi,4),%edi
  aa4c91:	jmp    aa4ca5 <ir_verify_path+0x3e5>
  aa4c93:	cmp    $0x2f,%r11d
  aa4c97:	jne    aa4ca8 <ir_verify_path+0x3e8>
  aa4c99:	mov    0x10(%rsp),%rdi
  aa4c9e:	mov    (%rdi),%rdi
  aa4ca1:	mov    (%rdi,%r8,4),%edi
  aa4ca5:	add    %rdi,%r10
  aa4ca8:	test   %r10,%r10
  aa4cab:	je     aa550b <ir_verify_path+0xc4b>
  aa4cb1:	xor    %r13d,%r13d
  aa4cb4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  aa4cc0:	movzbl (%rsi,%r8,1),%ebp
  aa4cc5:	lea    -0x5a979c(%rip),%rdi        # 4fb530 <ir_operand_table>
  aa4ccc:	movzbl 0x0(%rbp,%rdi,1),%edi
  aa4cd1:	cmp    $0x33,%ebp
  aa4cd4:	je     aa4d00 <ir_verify_path+0x440>
  aa4cd6:	cmp    $0x2a,%ebp
  aa4cd9:	jne    aa4d14 <ir_verify_path+0x454>
  aa4cdb:	mov    0x10(%rsp),%r11
  aa4ce0:	mov    %edi,%ebx
  aa4ce2:	or     $0x2,%ebx
  aa4ce5:	mov    (%r11),%r11
  aa4ce8:	cmpl   $0xffffffff,(%r11,%r8,4)
  aa4ced:	cmovne %ebx,%edi
  aa4cf0:	jmp    aa4d14 <ir_verify_path+0x454>
  aa4cf2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  aa4d00:	mov    0x30(%rsp),%r11
  aa4d05:	xor    %ebx,%ebx
  aa4d07:	mov    (%r11),%r11
  aa4d0a:	cmpl   $0xffffffff,(%r11,%r8,4)
  aa4d0f:	setne  %bl
  aa4d12:	or     %ebx,%edi
  aa4d14:	mov    (%rdx,%r8,4),%r12d
  aa4d18:	popcnt %edi,%ebx
  aa4d1c:	mov    %r13d,%r11d
  aa4d1f:	sub    %ebx,%r11d
  aa4d22:	jae    aa4dc0 <ir_verify_path+0x500>
  aa4d28:	test   %r13d,%r13d
  aa4d2b:	je     aa4d9a <ir_verify_path+0x4da>
  aa4d2d:	cmp    $0x8,%r13d
  aa4d31:	jb     aa4d7f <ir_verify_path+0x4bf>
  aa4d33:	mov    %r13d,%ebp
  aa4d36:	and    $0xfffffff8,%ebp
  aa4d39:	nopl   0x0(%rax)
  aa4d40:	blsr   %edi,%edi
  aa4d45:	lea    -0x2(%rdi),%r11d
  aa4d49:	and    %edi,%r11d
  aa4d4c:	lea    -0x2(%r11),%edi
  aa4d50:	and    %r11d,%edi
  aa4d53:	lea    -0x2(%rdi),%r11d
  aa4d57:	and    %edi,%r11d
  aa4d5a:	lea    -0x2(%r11),%edi
  aa4d5e:	and    %r11d,%edi
  aa4d61:	blsr   %edi,%edi
  aa4d66:	lea    -0x2(%rdi),%r11d
  aa4d6a:	and    %edi,%r11d
  aa4d6d:	lea    -0x2(%r11),%edi
  aa4d71:	and    %r11d,%edi
  aa4d74:	add    $0xfffffff8,%ebp
  aa4d77:	jne    aa4d40 <ir_verify_path+0x480>
  aa4d79:	test   $0x7,%r13b
  aa4d7d:	je     aa4d9a <ir_verify_path+0x4da>
  aa4d7f:	mov    %r13d,%r11d
  aa4d82:	and    $0x7,%r11d
  aa4d86:	cs nopw 0x0(%rax,%rax,1)
  aa4d90:	blsr   %edi,%edi
  aa4d95:	dec    %r11d
  aa4d98:	jne    aa4d90 <ir_verify_path+0x4d0>
  aa4d9a:	lea    0x0(,%r8,4),%rbp
  aa4da2:	tzcnt  %edi,%edi
  aa4da6:	je     aa4e19 <ir_verify_path+0x559>
  aa4da8:	cmp    $0x1,%edi
  aa4dab:	jne    aa4e25 <ir_verify_path+0x565>
  aa4dad:	mov    0x10(%rsp),%rdi
  aa4db2:	add    (%rdi),%rbp
  aa4db5:	mov    $0x1,%edi
  aa4dba:	jmp    aa4e30 <ir_verify_path+0x570>
  aa4dbc:	nopl   0x0(%rax)
  aa4dc0:	mov    0x38(%rsp),%rbx
  aa4dc5:	lea    0x3(%r11),%edi
  aa4dc9:	mov    (%rbx),%rbx
  aa4dcc:	cmp    $0x2f,%bpl
  aa4dd0:	jne    aa4df0 <ir_verify_path+0x530>
  aa4dd2:	mov    0x30(%rsp),%r12
  aa4dd7:	mov    (%r12),%r12
  aa4ddb:	mov    (%r12,%r8,4),%ebp
  aa4ddf:	lea    0x0(%rbp,%r11,2),%r12d
  aa4de4:	lea    0x1(%rbp,%r11,2),%r11d
  aa4de9:	mov    (%rbx,%r12,4),%r12d
  aa4ded:	jmp    aa4e13 <ir_verify_path+0x553>
  aa4def:	nop
  aa4df0:	mov    0x8(%rsp),%r15
  aa4df5:	mov    0x28(%r15),%rbp
  aa4df9:	mov    0x90(%r15),%r15
  aa4e00:	mov    0x0(%rbp,%r8,4),%ebp
  aa4e05:	lea    0x0(%rbp,%rbp,4),%rbp
  aa4e0a:	add    (%r15,%rbp,4),%r11d
  aa4e0e:	mov    0x2c(%rsp),%r15d
  aa4e13:	lea    (%rbx,%r11,4),%rbp
  aa4e17:	jmp    aa4e30 <ir_verify_path+0x570>
  aa4e19:	mov    0x30(%rsp),%rdi
  aa4e1e:	add    (%rdi),%rbp
  aa4e21:	xor    %edi,%edi
  aa4e23:	jmp    aa4e30 <ir_verify_path+0x570>
  aa4e25:	mov    0x68(%rsp),%r11
  aa4e2a:	add    (%r11),%rbp
  aa4e2d:	nopl   (%rax)
  aa4e30:	mov    0x0(%rbp),%r11d
  aa4e34:	mov    %ecx,%ecx
  aa4e36:	mov    (%rdx,%r11,4),%ebp
  aa4e3a:	mov    %r11d,0xe0(%rsp,%rcx,4)
  aa4e42:	mov    %r8d,%r11d
  aa4e45:	cmpb   $0x2f,(%rsi,%r8,1)
  aa4e4a:	jne    aa4e60 <ir_verify_path+0x5a0>
  aa4e4c:	mov    0x40(%rsp),%r11
  aa4e51:	lea    0x1(%r12),%ebx
  aa4e56:	mov    (%r11),%r11
  aa4e59:	mov    (%r11,%rbx,4),%r11d
  aa4e5d:	dec    %r11d
  aa4e60:	mov    0x48(%rsp),%rbx
  aa4e65:	mov    %r11d,0x120(%rsp,%rcx,4)
  aa4e6d:	mov    %ebp,0x160(%rsp,%rcx,4)
  aa4e74:	mov    %r12d,0x1a0(%rsp,%rcx,4)
  aa4e7c:	mov    %r8d,0x2e0(%rsp,%rcx,4)
  aa4e84:	mov    %edi,0x320(%rsp,%rcx,4)
  aa4e8b:	test   %rbx,%rbx
  aa4e8e:	je     aa4ec6 <ir_verify_path+0x606>
  aa4e90:	mov    (%rbx),%rdi
  aa4e93:	mov    (%rdi,%rbp,4),%r11d
  aa4e97:	mov    %r11d,0x1e0(%rsp,%rcx,4)
  aa4e9f:	mov    0x8(%rbx),%r11
  aa4ea3:	mov    (%r11,%rbp,4),%ebx
  aa4ea7:	mov    %ebx,0x220(%rsp,%rcx,4)
  aa4eae:	mov    %r12d,%ebx
  aa4eb1:	mov    (%rdi,%rbx,4),%edi
  aa4eb4:	mov    %edi,0x260(%rsp,%rcx,4)
  aa4ebb:	mov    (%r11,%rbx,4),%edi
  aa4ebf:	mov    %edi,0x2a0(%rsp,%rcx,4)
  aa4ec6:	mov    0x360(%rsp),%ecx
  aa4ecd:	xor    %edi,%edi
  aa4ecf:	inc    %ecx
  aa4ed1:	mov    %ecx,0x360(%rsp)
  aa4ed8:	cmp    $0x10,%ecx
  aa4edb:	jne    aa5302 <ir_verify_path+0xa42>
  aa4ee1:	test   %r15b,%r15b
  aa4ee4:	je     aa4f90 <ir_verify_path+0x6d0>
  aa4eea:	vmovdqu64 0xe0(%rsp),%zmm0
  aa4ef5:	vmovdqu64 0x1a0(%rsp),%zmm1
  aa4f00:	cmpq   $0x0,0x48(%rsp)
  aa4f06:	vpcmpeqd 0x160(%rsp),%zmm1,%k1
  aa4f11:	vpcmpnltud 0x120(%rsp),%zmm0,%k0{%k1}
  aa4f1d:	kmovw  %k0,%ecx
  aa4f21:	je     aa52c0 <ir_verify_path+0xa00>
  aa4f27:	vmovdqu64 0x220(%rsp),%zmm1
  aa4f32:	vmovdqu64 0x2a0(%rsp),%zmm2
  aa4f3d:	kmovw  %k1,%edi
  aa4f41:	vmovdqu64 0x1e0(%rsp),%zmm0
  aa4f4c:	vptestnmd %zmm1,%zmm1,%k0
  aa4f52:	vptestnmd %zmm2,%zmm2,%k1
  aa4f58:	vpcmpltud %zmm2,%zmm1,%k2
  aa4f5f:	korw   %k1,%k0,%k0
  aa4f63:	vpcmpnleud 0x260(%rsp),%zmm0,%k1
  aa4f6f:	korw   %k1,%k2,%k1
  aa4f73:	korw   %k0,%k1,%k0
  aa4f77:	kmovw  %k0,%r9d
  aa4f7b:	andn   %r9d,%edi,%edi
  aa4f80:	or     %edi,%ecx
  aa4f82:	jmp    aa52c0 <ir_verify_path+0xa00>
  aa4f87:	nopw   0x0(%rax,%rax,1)
  aa4f90:	cmpq   $0x0,0x48(%rsp)
  aa4f96:	je     aa5076 <ir_verify_path+0x7b6>
  aa4f9c:	vmovdqu64 0x160(%rsp),%zmm1
  aa4fa7:	vmovdqu64 0x1a0(%rsp),%zmm2
  aa4fb2:	vmovdqu64 0x220(%rsp),%zmm3
  aa4fbd:	vmovdqu64 0x120(%rsp),%zmm0
  aa4fc8:	vpcmpeqd %zmm2,%zmm1,%k0
  aa4fce:	vpcmpneqd %zmm2,%zmm1,%k1
  aa4fd5:	vmovdqu64 0x2a0(%rsp),%zmm2
  aa4fe0:	vptestnmd %zmm3,%zmm3,%k2
  aa4fe6:	vmovdqu64 0x1e0(%rsp),%zmm1
  aa4ff1:	kandw  %k2,%k1,%k3
  aa4ff5:	korw   %k2,%k0,%k0
  aa4ff9:	vpcmpnleud 0x260(%rsp),%zmm1,%k4
  aa5005:	vptestnmd %zmm2,%zmm2,%k2
  aa500b:	korw   %k2,%k0,%k0
  aa500f:	vpcmpleud 0xe0(%rsp),%zmm0,%k2
  aa501b:	korw   %k2,%k1,%k1
  aa501f:	vpcmpltud %zmm2,%zmm3,%k2
  aa5026:	korw   %k4,%k2,%k2
  aa502a:	kandnw %k2,%k0,%k2
  aa502e:	kandw  %k0,%k1,%k0
  aa5032:	korw   %k2,%k0,%k0
  aa5036:	korw   %k0,%k3,%k1
  aa503a:	vmovdqa32 -0x5b3a84(%rip),%zmm0{%k1}{z}        # 4f15c0 <check_builtin_atomic_rmw_test_clang.native_source+0x5c00>
  aa5044:	vextracti64x4 $0x1,%zmm0,%ymm1
  aa504b:	vpord  %zmm1,%zmm0,%zmm0
  aa5051:	vextracti128 $0x1,%ymm0,%xmm1
  aa5057:	vpor   %xmm1,%xmm0,%xmm0
  aa505b:	vpshufd $0xee,%xmm0,%xmm1
  aa5060:	vpor   %xmm1,%xmm0,%xmm0
  aa5064:	vpshufd $0x55,%xmm0,%xmm1
  aa5069:	vpor   %xmm1,%xmm0,%xmm0
  aa506d:	vmovd  %xmm0,%ecx
  aa5071:	jmp    aa52c0 <ir_verify_path+0xa00>
  aa5076:	mov    0x120(%rsp),%ecx
  aa507d:	vmovq  0x160(%rsp),%xmm0
  aa5086:	vmovq  0x1a0(%rsp),%xmm1
  aa508f:	cmp    %ecx,0xe0(%rsp)
  aa5096:	vpcmpeqd %xmm1,%xmm0,%k0
  aa509c:	kmovd  %k0,%edi
  aa50a0:	kmovd  %k0,%r9d
  aa50a4:	setae  %cl
  aa50a7:	and    %cl,%dil
  aa50aa:	movzbl %dil,%ecx
  aa50ae:	test   $0x2,%r9b
  aa50b2:	je     aa531b <ir_verify_path+0xa5b>
  aa50b8:	mov    0xe4(%rsp),%edi
  aa50bf:	xor    %r9d,%r9d
  aa50c2:	cmp    0x124(%rsp),%edi
  aa50c9:	setae  %r9b
  aa50cd:	lea    (%rcx,%r9,2),%ecx
  aa50d1:	mov    0x168(%rsp),%edi
  aa50d8:	cmp    0x1a8(%rsp),%edi
  aa50df:	je     aa532f <ir_verify_path+0xa6f>
  aa50e5:	mov    0x16c(%rsp),%edi
  aa50ec:	cmp    0x1ac(%rsp),%edi
  aa50f3:	jne    aa535c <ir_verify_path+0xa9c>
  aa50f9:	mov    0xec(%rsp),%edi
  aa5100:	xor    %r9d,%r9d
  aa5103:	cmp    0x12c(%rsp),%edi
  aa510a:	setae  %r9b
  aa510e:	lea    (%rcx,%r9,8),%ecx
  aa5112:	mov    0x170(%rsp),%edi
  aa5119:	cmp    0x1b0(%rsp),%edi
  aa5120:	je     aa5370 <ir_verify_path+0xab0>
  aa5126:	mov    0x174(%rsp),%edi
  aa512d:	cmp    0x1b4(%rsp),%edi
  aa5134:	jne    aa53a3 <ir_verify_path+0xae3>
  aa513a:	mov    0xf4(%rsp),%edi
  aa5141:	xor    %r9d,%r9d
  aa5144:	cmp    0x134(%rsp),%edi
  aa514b:	setae  %r9b
  aa514f:	shl    $0x5,%r9d
  aa5153:	or     %ecx,%r9d
  aa5156:	mov    %r9d,%ecx
  aa5159:	mov    0x178(%rsp),%edi
  aa5160:	cmp    0x1b8(%rsp),%edi
  aa5167:	je     aa53b7 <ir_verify_path+0xaf7>
  aa516d:	mov    0x17c(%rsp),%edi
  aa5174:	cmp    0x1bc(%rsp),%edi
  aa517b:	jne    aa53ea <ir_verify_path+0xb2a>
  aa5181:	mov    0xfc(%rsp),%edi
  aa5188:	xor    %r9d,%r9d
  aa518b:	cmp    0x13c(%rsp),%edi
  aa5192:	setae  %r9b
  aa5196:	shl    $0x7,%r9d
  aa519a:	or     %ecx,%r9d
  aa519d:	mov    %r9d,%ecx
  aa51a0:	mov    0x180(%rsp),%edi
  aa51a7:	cmp    0x1c0(%rsp),%edi
  aa51ae:	je     aa53fe <ir_verify_path+0xb3e>
  aa51b4:	mov    0x184(%rsp),%edi
  aa51bb:	cmp    0x1c4(%rsp),%edi
  aa51c2:	jne    aa5431 <ir_verify_path+0xb71>
  aa51c8:	mov    0x104(%rsp),%edi
  aa51cf:	xor    %r9d,%r9d
  aa51d2:	cmp    0x144(%rsp),%edi
  aa51d9:	setae  %r9b
  aa51dd:	shl    $0x9,%r9d
  aa51e1:	or     %ecx,%r9d
  aa51e4:	mov    %r9d,%ecx
  aa51e7:	mov    0x188(%rsp),%edi
  aa51ee:	cmp    0x1c8(%rsp),%edi
  aa51f5:	je     aa5445 <ir_verify_path+0xb85>
  aa51fb:	mov    0x18c(%rsp),%edi
  aa5202:	cmp    0x1cc(%rsp),%edi
  aa5209:	jne    aa5478 <ir_verify_path+0xbb8>
  aa520f:	mov    0x10c(%rsp),%edi
  aa5216:	xor    %r9d,%r9d
  aa5219:	cmp    0x14c(%rsp),%edi
  aa5220:	setae  %r9b
  aa5224:	shl    $0xb,%r9d
  aa5228:	or     %ecx,%r9d
  aa522b:	mov    %r9d,%ecx
  aa522e:	mov    0x190(%rsp),%edi
  aa5235:	cmp    0x1d0(%rsp),%edi
  aa523c:	je     aa548c <ir_verify_path+0xbcc>
  aa5242:	mov    0x194(%rsp),%edi
  aa5249:	cmp    0x1d4(%rsp),%edi
  aa5250:	jne    aa54bf <ir_verify_path+0xbff>
  aa5256:	mov    0x114(%rsp),%edi
  aa525d:	xor    %r9d,%r9d
  aa5260:	cmp    0x154(%rsp),%edi
  aa5267:	setae  %r9b
  aa526b:	shl    $0xd,%r9d
  aa526f:	or     %ecx,%r9d
  aa5272:	mov    %r9d,%ecx
  aa5275:	mov    0x198(%rsp),%edi
  aa527c:	cmp    0x1d8(%rsp),%edi
  aa5283:	je     aa54d3 <ir_verify_path+0xc13>
  aa5289:	mov    0x19c(%rsp),%edi
  aa5290:	cmp    0x1dc(%rsp),%edi
  aa5297:	jne    aa52c0 <ir_verify_path+0xa00>
  aa5299:	mov    0x11c(%rsp),%edi
  aa52a0:	xor    %r9d,%r9d
  aa52a3:	cmp    0x15c(%rsp),%edi
  aa52aa:	setae  %r9b
  aa52ae:	shl    $0xf,%r9d
  aa52b2:	or     %ecx,%r9d
  aa52b5:	mov    %r9d,%ecx
  aa52b8:	nopl   0x0(%rax,%rax,1)
  aa52c0:	test   %ecx,%ecx
  aa52c2:	je     aa52e1 <ir_verify_path+0xa21>
  aa52c4:	tzcnt  %ecx,%ecx
  aa52c8:	mov    0x2e0(%rsp,%rcx,4),%edi
  aa52cf:	mov    0x320(%rsp,%rcx,4),%r14d
  aa52d7:	shl    $0x20,%rdi
  aa52db:	or     $0xa,%rdi
  aa52df:	jmp    aa52ee <ir_verify_path+0xa2e>
  aa52e1:	movabs $0xffffffff00000000,%rdi
  aa52eb:	xor    %r14d,%r14d
  aa52ee:	mov    %rdi,%r9
  aa52f1:	shr    $0x20,%r9
  aa52f5:	xor    %ecx,%ecx
  aa52f7:	movl   $0x0,0x360(%rsp)
  aa5302:	test   %edi,%edi
  aa5304:	jne    aa550d <ir_verify_path+0xc4d>
  aa530a:	inc    %r13d
  aa530d:	cmp    %r13,%r10
  aa5310:	ja     aa4cc0 <ir_verify_path+0x400>
  aa5316:	jmp    aa550d <ir_verify_path+0xc4d>
  aa531b:	mov    0x168(%rsp),%edi
  aa5322:	cmp    0x1a8(%rsp),%edi
  aa5329:	jne    aa50e5 <ir_verify_path+0x825>
  aa532f:	mov    0xe8(%rsp),%edi
  aa5336:	xor    %r9d,%r9d
  aa5339:	cmp    0x128(%rsp),%edi
  aa5340:	setae  %r9b
  aa5344:	lea    (%rcx,%r9,4),%ecx
  aa5348:	mov    0x16c(%rsp),%edi
  aa534f:	cmp    0x1ac(%rsp),%edi
  aa5356:	je     aa50f9 <ir_verify_path+0x839>
  aa535c:	mov    0x170(%rsp),%edi
  aa5363:	cmp    0x1b0(%rsp),%edi
  aa536a:	jne    aa5126 <ir_verify_path+0x866>
  aa5370:	mov    0xf0(%rsp),%edi
  aa5377:	xor    %r9d,%r9d
  aa537a:	cmp    0x130(%rsp),%edi
  aa5381:	setae  %r9b
  aa5385:	shl    $0x4,%r9d
  aa5389:	or     %ecx,%r9d
  aa538c:	mov    %r9d,%ecx
  aa538f:	mov    0x174(%rsp),%edi
  aa5396:	cmp    0x1b4(%rsp),%edi
  aa539d:	je     aa513a <ir_verify_path+0x87a>
  aa53a3:	mov    0x178(%rsp),%edi
  aa53aa:	cmp    0x1b8(%rsp),%edi
  aa53b1:	jne    aa516d <ir_verify_path+0x8ad>
  aa53b7:	mov    0xf8(%rsp),%edi
  aa53be:	xor    %r9d,%r9d
  aa53c1:	cmp    0x138(%rsp),%edi
  aa53c8:	setae  %r9b
  aa53cc:	shl    $0x6,%r9d
  aa53d0:	or     %ecx,%r9d
  aa53d3:	mov    %r9d,%ecx
  aa53d6:	mov    0x17c(%rsp),%edi
  aa53dd:	cmp    0x1bc(%rsp),%edi
  aa53e4:	je     aa5181 <ir_verify_path+0x8c1>
  aa53ea:	mov    0x180(%rsp),%edi
  aa53f1:	cmp    0x1c0(%rsp),%edi
  aa53f8:	jne    aa51b4 <ir_verify_path+0x8f4>
  aa53fe:	mov    0x100(%rsp),%edi
  aa5405:	xor    %r9d,%r9d
  aa5408:	cmp    0x140(%rsp),%edi
  aa540f:	setae  %r9b
  aa5413:	shl    $0x8,%r9d
  aa5417:	or     %ecx,%r9d
  aa541a:	mov    %r9d,%ecx
  aa541d:	mov    0x184(%rsp),%edi
  aa5424:	cmp    0x1c4(%rsp),%edi
  aa542b:	je     aa51c8 <ir_verify_path+0x908>
  aa5431:	mov    0x188(%rsp),%edi
  aa5438:	cmp    0x1c8(%rsp),%edi
  aa543f:	jne    aa51fb <ir_verify_path+0x93b>
  aa5445:	mov    0x108(%rsp),%edi
  aa544c:	xor    %r9d,%r9d
  aa544f:	cmp    0x148(%rsp),%edi
  aa5456:	setae  %r9b
  aa545a:	shl    $0xa,%r9d
  aa545e:	or     %ecx,%r9d
  aa5461:	mov    %r9d,%ecx
  aa5464:	mov    0x18c(%rsp),%edi
  aa546b:	cmp    0x1cc(%rsp),%edi
  aa5472:	je     aa520f <ir_verify_path+0x94f>
  aa5478:	mov    0x190(%rsp),%edi
  aa547f:	cmp    0x1d0(%rsp),%edi
  aa5486:	jne    aa5242 <ir_verify_path+0x982>
  aa548c:	mov    0x110(%rsp),%edi
  aa5493:	xor    %r9d,%r9d
  aa5496:	cmp    0x150(%rsp),%edi
  aa549d:	setae  %r9b
  aa54a1:	shl    $0xc,%r9d
  aa54a5:	or     %ecx,%r9d
  aa54a8:	mov    %r9d,%ecx
  aa54ab:	mov    0x194(%rsp),%edi
  aa54b2:	cmp    0x1d4(%rsp),%edi
  aa54b9:	je     aa5256 <ir_verify_path+0x996>
  aa54bf:	mov    0x198(%rsp),%edi
  aa54c6:	cmp    0x1d8(%rsp),%edi
  aa54cd:	jne    aa5289 <ir_verify_path+0x9c9>
  aa54d3:	mov    0x118(%rsp),%edi
  aa54da:	xor    %r9d,%r9d
  aa54dd:	cmp    0x158(%rsp),%edi
  aa54e4:	setae  %r9b
  aa54e8:	shl    $0xe,%r9d
  aa54ec:	or     %ecx,%r9d
  aa54ef:	mov    %r9d,%ecx
  aa54f2:	mov    0x19c(%rsp),%edi
  aa54f9:	cmp    0x1dc(%rsp),%edi
  aa5500:	je     aa5299 <ir_verify_path+0x9d9>
  aa5506:	jmp    aa52c0 <ir_verify_path+0xa00>
  aa550b:	xor    %edi,%edi
  aa550d:	test   %edi,%edi
  aa550f:	jne    aa562a <ir_verify_path+0xd6a>
  aa5515:	mov    0x88(%rsp),%r15
  aa551d:	mov    0x80(%rsp),%r13
  aa5525:	inc    %r8
  aa5528:	cmp    0x20(%rsp),%r8
  aa552d:	jne    aa4c02 <ir_verify_path+0x342>
  aa5533:	jmp    aa554a <ir_verify_path+0xc8a>
  aa5535:	xor    %r14d,%r14d
  aa5538:	mov    %ecx,%eax
  aa553a:	jmp    aa6270 <ir_verify_path+0x19b0>
  aa553f:	mov    $0xffffffff,%r9d
  aa5545:	xor    %ecx,%ecx
  aa5547:	xor    %r14d,%r14d
  aa554a:	movabs $0xffffffff00000000,%r8
  aa5554:	test   %ecx,%ecx
  aa5556:	je     aa6270 <ir_verify_path+0x19b0>
  aa555c:	cmpb   $0x0,0x2c(%rsp)
  aa5561:	je     aa622f <ir_verify_path+0x196f>
  aa5567:	vmovdqu64 0xe0(%rsp),%zmm0
  aa5572:	vmovdqu64 0x1a0(%rsp),%zmm1
  aa557d:	cmpq   $0x0,0x48(%rsp)
  aa5583:	vpcmpeqd 0x160(%rsp),%zmm1,%k1
  aa558e:	vpcmpnltud 0x120(%rsp),%zmm0,%k0{%k1}
  aa559a:	kmovw  %k0,%eax
  aa559e:	je     aa55fb <ir_verify_path+0xd3b>
  aa55a0:	vmovdqu64 0x220(%rsp),%zmm1
  aa55ab:	vmovdqu64 0x2a0(%rsp),%zmm2
  aa55b6:	kmovw  %k1,%edx
  aa55ba:	vmovdqu64 0x1e0(%rsp),%zmm0
  aa55c5:	vptestnmd %zmm1,%zmm1,%k0
  aa55cb:	vptestnmd %zmm2,%zmm2,%k1
  aa55d1:	vpcmpltud %zmm2,%zmm1,%k2
  aa55d8:	korw   %k1,%k0,%k0
  aa55dc:	vpcmpnleud 0x260(%rsp),%zmm0,%k1
  aa55e8:	korw   %k1,%k2,%k1
  aa55ec:	korw   %k0,%k1,%k0
  aa55f0:	kmovw  %k0,%esi
  aa55f4:	andn   %esi,%edx,%edx
  aa55f9:	or     %edx,%eax
  aa55fb:	bzhi   %ecx,%eax,%edx
  aa5600:	test   %edx,%edx
  aa5602:	je     aa624f <ir_verify_path+0x198f>
  aa5608:	xor    %ecx,%ecx
  aa560a:	tzcnt  %edx,%ecx
  aa560e:	mov    0x2e0(%rsp,%rcx,4),%eax
  aa5615:	mov    0x320(%rsp,%rcx,4),%r14d
  aa561d:	shl    $0x20,%rax
  aa5621:	or     $0xa,%rax
  aa5625:	jmp    aa625c <ir_verify_path+0x199c>
  aa562a:	mov    0x88(%rsp),%r15
  aa5632:	mov    0x80(%rsp),%r13
  aa563a:	mov    %edi,%eax
  aa563c:	jmp    aa6223 <ir_verify_path+0x1963>
  aa5641:	mov    0x8(%rsp),%rbp
  aa5646:	lea    0x50(%rbp),%rcx
  aa564a:	lea    0x40(%rbp),%rax
  aa564e:	lea    0x20(%rbp),%rdx
  aa5652:	lea    0x28(%rbp),%r10
  aa5656:	mov    %rcx,0x38(%rsp)
  aa565b:	lea    0x30(%rbp),%rcx
  aa565f:	mov    %rax,0x40(%rsp)
  aa5664:	mov    %rdx,0x30(%rsp)
  aa5669:	mov    %rcx,0x68(%rsp)
  aa566e:	mov    0x40(%rbp),%rax
  aa5672:	mov    $0xffffffff,%r9d
  aa5678:	xor    %r14d,%r14d
  aa567b:	xor    %ebx,%ebx
  aa567d:	mov    (%rax),%eax
  aa567f:	mov    %rbx,%r11
  aa5682:	inc    %rbx
  aa5685:	mov    %eax,%r12d
  aa5688:	xor    %esi,%esi
  aa568a:	mov    %r11,0x60(%rsp)
  aa568f:	mov    0x40(%rsp),%rax
  aa5694:	mov    (%rax),%rax
  aa5697:	mov    (%rax,%rbx,4),%eax
  aa569a:	cmp    %rax,%r12
  aa569d:	jae    aa6207 <ir_verify_path+0x1947>
  aa56a3:	mov    0x0(%rbp),%rax
  aa56a7:	mov    %esi,%ecx
  aa56a9:	mov    %r12,0x98(%rsp)
  aa56b1:	movzbl (%rax,%r12,1),%eax
  aa56b6:	cmp    $0x2f,%al
  aa56b8:	setne  %sil
  aa56bc:	je     aa57c2 <ir_verify_path+0xf02>
  aa56c2:	cmp    $0x32,%al
  aa56c4:	jne    aa591d <ir_verify_path+0x105d>
  aa56ca:	mov    0x68(%rsp),%rax
  aa56cf:	mov    0x8(%r15),%r9
  aa56d3:	mov    (%rax),%rax
  aa56d6:	mov    (%rax,%r12,4),%edx
  aa56da:	xor    %eax,%eax
  aa56dc:	mov    %rdx,0x58(%rsp)
  aa56e1:	cmp    $0x2,%rdx
  aa56e5:	jb     aa61f3 <ir_verify_path+0x1933>
  aa56eb:	mov    (%r15),%rdx
  aa56ee:	mov    $0x2,%eax
  aa56f3:	lea    0x3f(%r9,%rdx,1),%rdi
  aa56f8:	lea    (%r9,%rdx,1),%rcx
  aa56fc:	and    $0xffffffffffffffc0,%rdi
  aa5700:	cmp    %rcx,%rdi
  aa5703:	jb     aa61f3 <ir_verify_path+0x1933>
  aa5709:	mov    %rdi,%rcx
  aa570c:	sub    %rdx,%rcx
  aa570f:	mov    0x10(%r15),%rdx
  aa5713:	sub    %rcx,%rdx
  aa5716:	jb     aa61f3 <ir_verify_path+0x1933>
  aa571c:	mov    %rdi,0x50(%rsp)
  aa5721:	mov    %r10,%rdi
  aa5724:	mov    0x58(%rsp),%r10
  aa5729:	mov    %rcx,0x10(%rsp)
  aa572e:	lea    0x0(,%r10,4),%rcx
  aa5736:	mov    %rdi,%r10
  aa5739:	cmp    %rdx,%rcx
  aa573c:	ja     aa61f3 <ir_verify_path+0x1933>
  aa5742:	mov    %rcx,%rdx
  aa5745:	mov    0x10(%rsp),%rcx
  aa574a:	mov    0x50(%rsp),%rdi
  aa574f:	mov    $0x2,%eax
  aa5754:	add    %rdx,%rcx
  aa5757:	mov    %rcx,0x8(%r15)
  aa575b:	test   %rdi,%rdi
  aa575e:	je     aa61ea <ir_verify_path+0x192a>
  aa5764:	mov    %esi,0x1c(%rsp)
  aa5768:	xor    %esi,%esi
  aa576a:	mov    %r9,0x70(%rsp)
  aa576f:	mov    %r10,0x10(%rsp)
  aa5774:	mov    %rdx,%r14
  aa5777:	vzeroupper
  aa577a:	call   7c4270 <memset@plt>
  aa577f:	mov    (%r15),%rax
  aa5782:	mov    0x8(%r15),%rcx
  aa5786:	lea    0x3f(%rcx,%rax,1),%rsi
  aa578b:	lea    (%rcx,%rax,1),%rdx
  aa578f:	and    $0xffffffffffffffc0,%rsi
  aa5793:	cmp    %rdx,%rsi
  aa5796:	jae    aa5924 <ir_verify_path+0x1064>
  aa579c:	mov    0x8(%rsp),%rbp
  aa57a1:	mov    0x10(%rsp),%r10
  aa57a6:	mov    0x60(%rsp),%r11
  aa57ab:	mov    $0x2,%eax
  aa57b0:	movabs $0xffffffff00000000,%r8
  aa57ba:	xor    %r14d,%r14d
  aa57bd:	jmp    aa61e1 <ir_verify_path+0x1921>
  aa57c2:	test   %r11,%r11
  aa57c5:	sete   %al
  aa57c8:	or     %cl,%al
  aa57ca:	test   $0x1,%al
  aa57cc:	jne    aa6265 <ir_verify_path+0x19a5>
  aa57d2:	mov    0xb8(%rsp),%rdi
  aa57da:	mov    (%r10),%rax
  aa57dd:	mov    (%rdi,%rbx,4),%edx
  aa57e0:	mov    (%rax,%r12,4),%ecx
  aa57e4:	mov    %rdi,0x10(%rsp)
  aa57e9:	sub    (%rdi,%r11,4),%edx
  aa57ed:	cmp    %edx,%ecx
  aa57ef:	jne    aa6265 <ir_verify_path+0x19a5>
  aa57f5:	test   %ecx,%ecx
  aa57f7:	je     aa591d <ir_verify_path+0x105d>
  aa57fd:	mov    0xc0(%rsp),%rdx
  aa5805:	xor    %ecx,%ecx
  aa5807:	mov    %esi,0x1c(%rsp)
  aa580b:	mov    0x20(%rbp),%rsi
  aa580f:	mov    0x50(%rbp),%rdi
  aa5813:	mov    (%rsi,%r12,4),%r8d
  aa5817:	lea    (%r8,%rcx,2),%esi
  aa581b:	mov    (%rdi,%rsi,4),%esi
  aa581e:	cmp    0x48(%rbp),%esi
  aa5821:	jae    aa6218 <ir_verify_path+0x1958>
  aa5827:	mov    0x10(%rsp),%r12
  aa582c:	mov    %r10,%rax
  aa582f:	mov    %rbx,%r14
  aa5832:	mov    (%r12,%r11,4),%r10d
  aa5836:	mov    (%r12,%rbx,4),%r11d
  aa583a:	cmp    %r11d,%r10d
  aa583d:	jae    aa5873 <ir_verify_path+0xfb3>
  aa583f:	mov    %r11d,%ebp
  aa5842:	jmp    aa5858 <ir_verify_path+0xf98>
  aa5844:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  aa5850:	mov    %r12d,%ebp
  aa5853:	cmp    %ebp,%r10d
  aa5856:	jae    aa5873 <ir_verify_path+0xfb3>
  aa5858:	mov    %ebp,%ebx
  aa585a:	sub    %r10d,%ebx
  aa585d:	shr    $1,%ebx
  aa585f:	lea    (%rbx,%r10,1),%r12d
  aa5863:	cmp    %esi,(%rdx,%r12,4)
  aa5867:	jae    aa5850 <ir_verify_path+0xf90>
  aa5869:	lea    0x1(%rbx,%r10,1),%r10d
  aa586e:	cmp    %ebp,%r10d
  aa5871:	jb     aa5858 <ir_verify_path+0xf98>
  aa5873:	mov    0x98(%rsp),%r12
  aa587b:	cmp    %r11d,%r10d
  aa587e:	mov    0x60(%rsp),%r11
  aa5883:	jae    aa6218 <ir_verify_path+0x1958>
  aa5889:	mov    %r10d,%r10d
  aa588c:	cmp    %esi,(%rdx,%r10,4)
  aa5890:	jne    aa6218 <ir_verify_path+0x1958>
  aa5896:	mov    0x20(%rsp),%r10
  aa589b:	mov    (%r10,%rsi,4),%r10d
  aa589f:	cmp    %r10,%r12
  aa58a2:	je     aa6218 <ir_verify_path+0x1958>
  aa58a8:	lea    0x1(%r8,%rcx,2),%r8d
  aa58ad:	mov    0x8(%rsp),%r10
  aa58b2:	mov    (%rdi,%r8,4),%edi
  aa58b6:	cmp    0x38(%r10),%edi
  aa58ba:	jae    aa6218 <ir_verify_path+0x1958>
  aa58c0:	mov    0x8(%rsp),%r8
  aa58c5:	mov    0x8(%r8),%r8
  aa58c9:	movzbl (%r8,%rdi,1),%edi
  aa58ce:	cmp    (%r8,%r12,1),%dil
  aa58d2:	jne    aa6218 <ir_verify_path+0x1958>
  aa58d8:	mov    0x20(%rsp),%rdi
  aa58dd:	mov    0x8(%rsp),%rbp
  aa58e2:	inc    %ecx
  aa58e4:	mov    %r14,%rbx
  aa58e7:	mov    %rax,%r10
  aa58ea:	mov    %r12d,(%rdi,%rsi,4)
  aa58ee:	mov    (%rax),%rsi
  aa58f1:	cmp    (%rsi,%r12,4),%ecx
  aa58f5:	jb     aa580b <ir_verify_path+0xf4b>
  aa58fb:	mov    0x0(%rbp),%rax
  aa58ff:	mov    0x1c(%rsp),%esi
  aa5903:	movabs $0xffffffff00000000,%r8
  aa590d:	xor    %r14d,%r14d
  aa5910:	movzbl (%rax,%r12,1),%eax
  aa5915:	cmp    $0x32,%al
  aa5917:	je     aa56ca <ir_verify_path+0xe0a>
  aa591d:	xor    %eax,%eax
  aa591f:	jmp    aa61fa <ir_verify_path+0x193a>
  aa5924:	mov    %rsi,%rdx
  aa5927:	sub    %rax,%rdx
  aa592a:	mov    0x10(%r15),%rax
  aa592e:	mov    0x70(%rsp),%r9
  aa5933:	mov    %rsi,0x90(%rsp)
  aa593b:	sub    %rdx,%rax
  aa593e:	jb     aa59c4 <ir_verify_path+0x1104>
  aa5944:	mov    0x8(%rsp),%rbp
  aa5949:	mov    0x10(%rsp),%r10
  aa594e:	mov    0x60(%rsp),%r11
  aa5953:	mov    0x1c(%rsp),%esi
  aa5957:	mov    %r14,%rdi
  aa595a:	movabs $0xffffffff00000000,%r8
  aa5964:	cmp    %rax,%r14
  aa5967:	mov    $0x2,%eax
  aa596c:	mov    $0x0,%r14d
  aa5972:	ja     aa61ea <ir_verify_path+0x192a>
  aa5978:	add    %rdi,%rdx
  aa597b:	mov    %rdi,0x78(%rsp)
  aa5980:	mov    0x90(%rsp),%rdi
  aa5988:	mov    %rdx,0x8(%r15)
  aa598c:	mov    %rdx,%rcx
  aa598f:	test   %rdi,%rdi
  aa5992:	je     aa61ea <ir_verify_path+0x192a>
  aa5998:	mov    0x78(%rsp),%rdx
  aa599d:	xor    %esi,%esi
  aa599f:	call   7c4270 <memset@plt>
  aa59a4:	mov    0x58(%rsp),%rcx
  aa59a9:	mov    %ecx,%eax
  aa59ab:	and    $0x7,%eax
  aa59ae:	cmp    $0x8,%ecx
  aa59b1:	jae    aa59ee <ir_verify_path+0x112e>
  aa59b3:	mov    0x10(%rsp),%r11
  aa59b8:	mov    0x38(%rsp),%rbx
  aa59bd:	xor    %ecx,%ecx
  aa59bf:	jmp    aa5ada <ir_verify_path+0x121a>
  aa59c4:	mov    0x8(%rsp),%rbp
  aa59c9:	mov    0x10(%rsp),%r10
  aa59ce:	mov    0x60(%rsp),%r11
  aa59d3:	mov    0x1c(%rsp),%esi
  aa59d7:	mov    $0x2,%eax
  aa59dc:	movabs $0xffffffff00000000,%r8
  aa59e6:	xor    %r14d,%r14d
  aa59e9:	jmp    aa61ea <ir_verify_path+0x192a>
  aa59ee:	mov    0x10(%rsp),%r11
  aa59f3:	mov    0x38(%rsp),%rbx
  aa59f8:	mov    0x50(%rsp),%r9
  aa59fd:	mov    %ecx,%edx
  aa59ff:	shr    $0x3,%edx
  aa5a02:	and    $0xfffffff8,%ecx
  aa5a05:	xor    %esi,%esi
  aa5a07:	shl    $0x4,%rdx
  aa5a0b:	mov    (%r11),%rdi
  aa5a0e:	mov    (%rbx),%r8
  aa5a11:	mov    (%rdi,%r12,4),%edi
  aa5a15:	lea    0x1(%rsi,%rdi,1),%edi
  aa5a19:	mov    (%r8,%rdi,4),%edi
  aa5a1d:	mov    %edi,(%r9,%rsi,2)
  aa5a21:	mov    (%r11),%r8
  aa5a24:	mov    (%rbx),%rdi
  aa5a27:	mov    (%r8,%r12,4),%r8d
  aa5a2b:	lea    0x3(%rsi,%r8,1),%r8d
  aa5a30:	mov    (%rdi,%r8,4),%edi
  aa5a34:	mov    %edi,0x4(%r9,%rsi,2)
  aa5a39:	mov    (%r11),%r8
  aa5a3c:	mov    (%rbx),%rdi
  aa5a3f:	mov    (%r8,%r12,4),%r8d
  aa5a43:	lea    0x5(%rsi,%r8,1),%r8d
  aa5a48:	mov    (%rdi,%r8,4),%edi
  aa5a4c:	mov    %edi,0x8(%r9,%rsi,2)
  aa5a51:	mov    (%r11),%r8
  aa5a54:	mov    (%rbx),%rdi
  aa5a57:	mov    (%r8,%r12,4),%r8d
  aa5a5b:	lea    0x7(%rsi,%r8,1),%r8d
  aa5a60:	mov    (%rdi,%r8,4),%edi
  aa5a64:	mov    %edi,0xc(%r9,%rsi,2)
  aa5a69:	mov    (%r11),%r8
  aa5a6c:	mov    (%rbx),%rdi
  aa5a6f:	mov    (%r8,%r12,4),%r8d
  aa5a73:	lea    0x9(%rsi,%r8,1),%r8d
  aa5a78:	mov    (%rdi,%r8,4),%edi
  aa5a7c:	mov    %edi,0x10(%r9,%rsi,2)
  aa5a81:	mov    (%r11),%r8
  aa5a84:	mov    (%rbx),%rdi
  aa5a87:	mov    (%r8,%r12,4),%r8d
  aa5a8b:	lea    0xb(%rsi,%r8,1),%r8d
  aa5a90:	mov    (%rdi,%r8,4),%edi
  aa5a94:	mov    %edi,0x14(%r9,%rsi,2)
  aa5a99:	mov    (%r11),%rdi
  aa5a9c:	mov    (%rbx),%r8
  aa5a9f:	mov    (%rdi,%r12,4),%edi
  aa5aa3:	lea    0xd(%rsi,%rdi,1),%edi
  aa5aa7:	mov    (%r8,%rdi,4),%edi
  aa5aab:	mov    %edi,0x18(%r9,%rsi,2)
  aa5ab0:	mov    (%r11),%r8
  aa5ab3:	mov    (%rbx),%rdi
  aa5ab6:	mov    (%r8,%r12,4),%r8d
  aa5aba:	lea    0xf(%rsi,%r8,1),%r8d
  aa5abf:	mov    (%rdi,%r8,4),%edi
  aa5ac3:	mov    %edi,0x1c(%r9,%rsi,2)
  aa5ac8:	add    $0x10,%rsi
  aa5acc:	cmp    %rsi,%rdx
  aa5acf:	jne    aa5a0b <ir_verify_path+0x114b>
  aa5ad5:	test   %rax,%rax
  aa5ad8:	je     aa5b0c <ir_verify_path+0x124c>
  aa5ada:	mov    0x50(%rsp),%rdx
  aa5adf:	lea    (%rax,%rax,1),%esi
  aa5ae2:	xor    %edi,%edi
  aa5ae4:	lea    (%rdx,%rcx,4),%rdx
  aa5ae8:	add    %ecx,%ecx
  aa5aea:	inc    %rcx
  aa5aed:	mov    (%r11),%r9
  aa5af0:	lea    (%rcx,%rdi,1),%r10d
  aa5af4:	mov    (%rbx),%r8
  aa5af7:	add    (%r9,%r12,4),%r10d
  aa5afb:	mov    (%r8,%r10,4),%r8d
  aa5aff:	mov    %r8d,(%rdx,%rdi,2)
  aa5b03:	add    $0x2,%rdi
  aa5b07:	cmp    %rdi,%rsi
  aa5b0a:	jne    aa5aed <ir_verify_path+0x122d>
  aa5b0c:	mov    0x8(%rsp),%rdx
  aa5b11:	mov    0x8(%rdx),%rcx
  aa5b15:	mov    0x20(%rdx),%rdx
  aa5b19:	mov    (%rdx,%r12,4),%edx
  aa5b1d:	movzbl (%rcx,%rdx,1),%ecx
  aa5b21:	lea    -0x5aa618(%rip),%rdx        # 4fb510 <ir_type_bits>
  aa5b28:	movzwl (%rdx,%rcx,2),%ecx
  aa5b2c:	add    $0x7,%ecx
  aa5b2f:	shr    $0x3,%ecx
  aa5b32:	mov    %ecx,0x78(%rsp)
  aa5b36:	je     aa6131 <ir_verify_path+0x1871>
  aa5b3c:	mov    0x58(%rsp),%r15
  aa5b41:	mov    0x90(%rsp),%r14
  aa5b49:	mov    0x50(%rsp),%rbp
  aa5b4e:	xor    %r8d,%r8d
  aa5b51:	vpxor  %xmm0,%xmm0,%xmm0
  aa5b55:	mov    %r15d,%edx
  aa5b58:	mov    %r15d,%esi
  aa5b5b:	mov    %r15d,%edi
  aa5b5e:	and    $0xfffffff8,%edx
  aa5b61:	and    $0x3,%esi
  aa5b64:	and    $0xfffffffc,%edi
  aa5b67:	jmp    aa5b7f <ir_verify_path+0x12bf>
  aa5b69:	mov    0x58(%rsp),%r15
  aa5b6e:	inc    %r8d
  aa5b71:	mov    %r9,%r14
  aa5b74:	cmp    0x78(%rsp),%r8d
  aa5b79:	je     aa613b <ir_verify_path+0x187b>
  aa5b7f:	mov    0x8(%rsp),%rcx
  aa5b84:	vmovdqu64 %zmm0,0x4a0(%rsp)
  aa5b8f:	vmovdqu64 %zmm0,0x460(%rsp)
  aa5b9a:	vmovdqu64 %zmm0,0x420(%rsp)
  aa5ba5:	vmovdqu64 %zmm0,0x3e0(%rsp)
  aa5bb0:	vmovdqu64 %zmm0,0x3a0(%rsp)
  aa5bbb:	vmovdqu64 %zmm0,0x360(%rsp)
  aa5bc6:	vmovdqu64 %zmm0,0x320(%rsp)
  aa5bd1:	vmovdqu64 %zmm0,0x2e0(%rsp)
  aa5bdc:	vmovdqu64 %zmm0,0x2a0(%rsp)
  aa5be7:	vmovdqu64 %zmm0,0x260(%rsp)
  aa5bf2:	vmovdqu64 %zmm0,0x220(%rsp)
  aa5bfd:	vmovdqu64 %zmm0,0x1e0(%rsp)
  aa5c08:	vmovdqu64 %zmm0,0x1a0(%rsp)
  aa5c13:	vmovdqu64 %zmm0,0x160(%rsp)
  aa5c1e:	vmovdqu64 %zmm0,0x120(%rsp)
  aa5c29:	vmovdqu64 %zmm0,0xe0(%rsp)
  aa5c34:	lea    0x0(,%r8,8),%r10d
  aa5c3c:	mov    %rbp,%r9
  aa5c3f:	xor    %r12d,%r12d
  aa5c42:	and    $0x38,%r10d
  aa5c46:	mov    0x60(%rcx),%r11
  aa5c4a:	cmp    $0x8,%r8d
  aa5c4e:	jae    aa5d6a <ir_verify_path+0x14aa>
  aa5c54:	cmp    $0x8,%r15d
  aa5c58:	jb     aa5d3c <ir_verify_path+0x147c>
  aa5c5e:	mov    (%r9,%r12,4),%ebx
  aa5c62:	shl    $0x4,%rbx
  aa5c66:	shrx   %r10,(%r11,%rbx,1),%rbx
  aa5c6c:	movzbl %bl,%ebx
  aa5c6f:	incl   0xe0(%rsp,%rbx,4)
  aa5c76:	mov    0x4(%r9,%r12,4),%ebx
  aa5c7b:	shl    $0x4,%rbx
  aa5c7f:	shrx   %r10,(%r11,%rbx,1),%rbx
  aa5c85:	movzbl %bl,%ebx
  aa5c88:	incl   0xe0(%rsp,%rbx,4)
  aa5c8f:	mov    0x8(%r9,%r12,4),%ebx
  aa5c94:	shl    $0x4,%rbx
  aa5c98:	shrx   %r10,(%r11,%rbx,1),%rbx
  aa5c9e:	movzbl %bl,%ebx
  aa5ca1:	incl   0xe0(%rsp,%rbx,4)
  aa5ca8:	mov    0xc(%r9,%r12,4),%ebx
  aa5cad:	shl    $0x4,%rbx
  aa5cb1:	shrx   %r10,(%r11,%rbx,1),%rbx
  aa5cb7:	movzbl %bl,%ebx
  aa5cba:	incl   0xe0(%rsp,%rbx,4)
  aa5cc1:	mov    0x10(%r9,%r12,4),%ebx
  aa5cc6:	shl    $0x4,%rbx
  aa5cca:	shrx   %r10,(%r11,%rbx,1),%rbx
  aa5cd0:	movzbl %bl,%ebx
  aa5cd3:	incl   0xe0(%rsp,%rbx,4)
  aa5cda:	mov    0x14(%r9,%r12,4),%ebx
  aa5cdf:	shl    $0x4,%rbx
  aa5ce3:	shrx   %r10,(%r11,%rbx,1),%rbx
  aa5ce9:	movzbl %bl,%ebx
  aa5cec:	incl   0xe0(%rsp,%rbx,4)
  aa5cf3:	mov    0x18(%r9,%r12,4),%ebx
  aa5cf8:	shl    $0x4,%rbx
  aa5cfc:	shrx   %r10,(%r11,%rbx,1),%rbx
  aa5d02:	movzbl %bl,%ebx
  aa5d05:	incl   0xe0(%rsp,%rbx,4)
  aa5d0c:	mov    0x1c(%r9,%r12,4),%ebx
  aa5d11:	add    $0x8,%r12
  aa5d15:	shl    $0x4,%rbx
  aa5d19:	shrx   %r10,(%r11,%rbx,1),%rbx
  aa5d1f:	movzbl %bl,%ebx
  aa5d22:	incl   0xe0(%rsp,%rbx,4)
  aa5d29:	cmp    %r12,%rdx
  aa5d2c:	jne    aa5c5e <ir_verify_path+0x139e>
  aa5d32:	test   $0x7,%r15b
  aa5d36:	je     aa5e80 <ir_verify_path+0x15c0>
  aa5d3c:	lea    (%r9,%r12,4),%rbx
  aa5d40:	xor    %r12d,%r12d
  aa5d43:	mov    (%rbx,%r12,4),%r13d
  aa5d47:	inc    %r12
  aa5d4a:	shl    $0x4,%r13
  aa5d4e:	shrx   %r10,(%r11,%r13,1),%r13
  aa5d54:	movzbl %r13b,%r13d
  aa5d58:	incl   0xe0(%rsp,%r13,4)
  aa5d60:	cmp    %r12,%rax
  aa5d63:	jne    aa5d43 <ir_verify_path+0x1483>
  aa5d65:	jmp    aa5e80 <ir_verify_path+0x15c0>
  aa5d6a:	cmp    $0x8,%r15d
  aa5d6e:	jb     aa5e56 <ir_verify_path+0x1596>
  aa5d74:	mov    (%r9,%r12,4),%ebx
  aa5d78:	shl    $0x4,%rbx
  aa5d7c:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aa5d83:	movzbl %bl,%ebx
  aa5d86:	incl   0xe0(%rsp,%rbx,4)
  aa5d8d:	mov    0x4(%r9,%r12,4),%ebx
  aa5d92:	shl    $0x4,%rbx
  aa5d96:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aa5d9d:	movzbl %bl,%ebx
  aa5da0:	incl   0xe0(%rsp,%rbx,4)
  aa5da7:	mov    0x8(%r9,%r12,4),%ebx
  aa5dac:	shl    $0x4,%rbx
  aa5db0:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aa5db7:	movzbl %bl,%ebx
  aa5dba:	incl   0xe0(%rsp,%rbx,4)
  aa5dc1:	mov    0xc(%r9,%r12,4),%ebx
  aa5dc6:	shl    $0x4,%rbx
  aa5dca:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aa5dd1:	movzbl %bl,%ebx
  aa5dd4:	incl   0xe0(%rsp,%rbx,4)
  aa5ddb:	mov    0x10(%r9,%r12,4),%ebx
  aa5de0:	shl    $0x4,%rbx
  aa5de4:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aa5deb:	movzbl %bl,%ebx
  aa5dee:	incl   0xe0(%rsp,%rbx,4)
  aa5df5:	mov    0x14(%r9,%r12,4),%ebx
  aa5dfa:	shl    $0x4,%rbx
  aa5dfe:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aa5e05:	movzbl %bl,%ebx
  aa5e08:	incl   0xe0(%rsp,%rbx,4)
  aa5e0f:	mov    0x18(%r9,%r12,4),%ebx
  aa5e14:	shl    $0x4,%rbx
  aa5e18:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aa5e1f:	movzbl %bl,%ebx
  aa5e22:	incl   0xe0(%rsp,%rbx,4)
  aa5e29:	mov    0x1c(%r9,%r12,4),%ebx
  aa5e2e:	add    $0x8,%r12
  aa5e32:	shl    $0x4,%rbx
  aa5e36:	shrx   %r10,0x8(%r11,%rbx,1),%rbx
  aa5e3d:	movzbl %bl,%ebx
  aa5e40:	incl   0xe0(%rsp,%rbx,4)
  aa5e47:	cmp    %r12,%rdx
  aa5e4a:	jne    aa5d74 <ir_verify_path+0x14b4>
  aa5e50:	test   $0x7,%r15b
  aa5e54:	je     aa5e80 <ir_verify_path+0x15c0>
  aa5e56:	lea    (%r9,%r12,4),%rbx
  aa5e5a:	xor    %r12d,%r12d
  aa5e5d:	mov    (%rbx,%r12,4),%r13d
  aa5e61:	inc    %r12
  aa5e64:	shl    $0x4,%r13
  aa5e68:	shrx   %r10,0x8(%r11,%r13,1),%r13
  aa5e6f:	movzbl %r13b,%r13d
  aa5e73:	incl   0xe0(%rsp,%r13,4)
  aa5e7b:	cmp    %r12,%rax
  aa5e7e:	jne    aa5e5d <ir_verify_path+0x159d>
  aa5e80:	xor    %ebx,%ebx
  aa5e82:	xor    %r11d,%r11d
  aa5e85:	mov    0xe0(%rsp,%r11,4),%ebp
  aa5e8d:	mov    %ebx,0xe0(%rsp,%r11,4)
  aa5e95:	add    %ebx,%ebp
  aa5e97:	mov    0xe4(%rsp,%r11,4),%ebx
  aa5e9f:	mov    %ebp,0xe4(%rsp,%r11,4)
  aa5ea7:	mov    0xe8(%rsp,%r11,4),%ecx
  aa5eaf:	add    %ebp,%ebx
  aa5eb1:	mov    %ebx,0xe8(%rsp,%r11,4)
  aa5eb9:	add    %ebx,%ecx
  aa5ebb:	mov    0xec(%rsp,%r11,4),%ebx
  aa5ec3:	mov    %ecx,0xec(%rsp,%r11,4)
  aa5ecb:	mov    0xf0(%rsp,%r11,4),%r12d
  aa5ed3:	add    %ecx,%ebx
  aa5ed5:	mov    %ebx,0xf0(%rsp,%r11,4)
  aa5edd:	add    %ebx,%r12d
  aa5ee0:	mov    0xf4(%rsp,%r11,4),%ebx
  aa5ee8:	mov    %r12d,0xf4(%rsp,%r11,4)
  aa5ef0:	mov    0xf8(%rsp,%r11,4),%ecx
  aa5ef8:	add    %r12d,%ebx
  aa5efb:	mov    %ebx,0xf8(%rsp,%r11,4)
  aa5f03:	add    %ebx,%ecx
  aa5f05:	mov    0xfc(%rsp,%r11,4),%ebx
  aa5f0d:	mov    %ecx,0xfc(%rsp,%r11,4)
  aa5f15:	mov    0x100(%rsp,%r11,4),%r12d
  aa5f1d:	add    %ecx,%ebx
  aa5f1f:	mov    %ebx,0x100(%rsp,%r11,4)
  aa5f27:	add    %ebx,%r12d
  aa5f2a:	mov    0x104(%rsp,%r11,4),%ebx
  aa5f32:	mov    %r12d,0x104(%rsp,%r11,4)
  aa5f3a:	mov    0x108(%rsp,%r11,4),%ecx
  aa5f42:	add    %r12d,%ebx
  aa5f45:	mov    %ebx,0x108(%rsp,%r11,4)
  aa5f4d:	add    %ebx,%ecx
  aa5f4f:	mov    0x10c(%rsp,%r11,4),%ebx
  aa5f57:	mov    %ecx,0x10c(%rsp,%r11,4)
  aa5f5f:	mov    0x110(%rsp,%r11,4),%r12d
  aa5f67:	add    %ecx,%ebx
  aa5f69:	mov    %ebx,0x110(%rsp,%r11,4)
  aa5f71:	add    %ebx,%r12d
  aa5f74:	mov    0x114(%rsp,%r11,4),%ebx
  aa5f7c:	mov    %r12d,0x114(%rsp,%r11,4)
  aa5f84:	mov    0x118(%rsp,%r11,4),%ecx
  aa5f8c:	add    %r12d,%ebx
  aa5f8f:	mov    %ebx,0x118(%rsp,%r11,4)
  aa5f97:	add    %ebx,%ecx
  aa5f99:	mov    0x11c(%rsp,%r11,4),%ebx
  aa5fa1:	mov    %ecx,0x11c(%rsp,%r11,4)
  aa5fa9:	add    $0x10,%r11
  aa5fad:	add    %ecx,%ebx
  aa5faf:	cmp    $0x100,%r11
  aa5fb6:	jne    aa5e85 <ir_verify_path+0x15c5>
  aa5fbc:	xor    %r11d,%r11d
  aa5fbf:	cmp    $0x4,%r15d
  aa5fc3:	jae    aa5fcf <ir_verify_path+0x170f>
  aa5fc5:	mov    0x8(%rsp),%r15
  aa5fca:	jmp    aa60e0 <ir_verify_path+0x1820>
  aa5fcf:	mov    0x8(%rsp),%r15
  aa5fd4:	mov    %r14,%rbp
  aa5fd7:	mov    (%r9,%r11,4),%ebx
  aa5fdb:	mov    0x60(%r15),%rcx
  aa5fdf:	mov    %rbx,%r12
  aa5fe2:	shl    $0x4,%r12
  aa5fe6:	cmp    $0x8,%r8d
  aa5fea:	lea    (%rcx,%r12,1),%r13
  aa5fee:	lea    0x8(%rcx,%r12,1),%rcx
  aa5ff3:	cmovb  %r13,%rcx
  aa5ff7:	shrx   %r10,(%rcx),%rcx
  aa5ffc:	movzbl %cl,%ecx
  aa5fff:	mov    0xe0(%rsp,%rcx,4),%r12d
  aa6007:	mov    %ebx,0x0(%rbp,%r12,4)
  aa600c:	incl   0xe0(%rsp,%rcx,4)
  aa6013:	mov    0x4(%r9,%r11,4),%ebx
  aa6018:	mov    0x60(%r15),%rcx
  aa601c:	mov    %rbx,%r12
  aa601f:	shl    $0x4,%r12
  aa6023:	cmp    $0x8,%r8d
  aa6027:	lea    (%rcx,%r12,1),%r13
  aa602b:	lea    0x8(%rcx,%r12,1),%rcx
  aa6030:	cmovb  %r13,%rcx
  aa6034:	shrx   %r10,(%rcx),%rcx
  aa6039:	movzbl %cl,%ecx
  aa603c:	mov    0xe0(%rsp,%rcx,4),%r12d
  aa6044:	mov    %ebx,0x0(%rbp,%r12,4)
  aa6049:	incl   0xe0(%rsp,%rcx,4)
  aa6050:	mov    0x8(%r9,%r11,4),%ebx
  aa6055:	mov    0x60(%r15),%rcx
  aa6059:	mov    %rbx,%r12
  aa605c:	shl    $0x4,%r12
  aa6060:	cmp    $0x8,%r8d
  aa6064:	lea    (%rcx,%r12,1),%r13
  aa6068:	lea    0x8(%rcx,%r12,1),%rcx
  aa606d:	cmovb  %r13,%rcx
  aa6071:	shrx   %r10,(%rcx),%rcx
  aa6076:	movzbl %cl,%ecx
  aa6079:	mov    0xe0(%rsp,%rcx,4),%r12d
  aa6081:	mov    %ebx,0x0(%rbp,%r12,4)
  aa6086:	incl   0xe0(%rsp,%rcx,4)
  aa608d:	mov    0xc(%r9,%r11,4),%ebx
  aa6092:	mov    0x60(%r15),%rcx
  aa6096:	mov    %rbx,%r12
  aa6099:	shl    $0x4,%r12
  aa609d:	cmp    $0x8,%r8d
  aa60a1:	lea    (%rcx,%r12,1),%r13
  aa60a5:	lea    0x8(%rcx,%r12,1),%rcx
  aa60aa:	cmovb  %r13,%rcx
  aa60ae:	add    $0x4,%r11
  aa60b2:	shrx   %r10,(%rcx),%rcx
  aa60b7:	movzbl %cl,%ecx
  aa60ba:	mov    0xe0(%rsp,%rcx,4),%r12d
  aa60c2:	mov    %ebx,0x0(%rbp,%r12,4)
  aa60c7:	incl   0xe0(%rsp,%rcx,4)
  aa60ce:	cmp    %r11,%rdi
  aa60d1:	jne    aa5fd7 <ir_verify_path+0x1717>
  aa60d7:	test   %rsi,%rsi
  aa60da:	je     aa5b69 <ir_verify_path+0x12a9>
  aa60e0:	lea    (%r9,%r11,4),%r11
  aa60e4:	xor    %r12d,%r12d
  aa60e7:	mov    (%r11,%r12,4),%r13d
  aa60eb:	mov    0x60(%r15),%rbx
  aa60ef:	mov    %r13,%rbp
  aa60f2:	shl    $0x4,%rbp
  aa60f6:	cmp    $0x8,%r8d
  aa60fa:	lea    (%rbx,%rbp,1),%rcx
  aa60fe:	lea    0x8(%rbx,%rbp,1),%rbx
  aa6103:	mov    %r14,%rbp
  aa6106:	cmovb  %rcx,%rbx
  aa610a:	inc    %r12
  aa610d:	shrx   %r10,(%rbx),%rcx
  aa6112:	movzbl %cl,%ecx
  aa6115:	mov    0xe0(%rsp,%rcx,4),%ebx
  aa611c:	mov    %r13d,(%r14,%rbx,4)
  aa6120:	incl   0xe0(%rsp,%rcx,4)
  aa6127:	cmp    %r12,%rsi
  aa612a:	jne    aa60e7 <ir_verify_path+0x1827>
  aa612c:	jmp    aa5b69 <ir_verify_path+0x12a9>
  aa6131:	mov    0x58(%rsp),%r15
  aa6136:	mov    0x50(%rsp),%rbp
  aa613b:	mov    0x8(%rsp),%rax
  aa6140:	mov    0x0(%rbp),%edi
  aa6143:	mov    $0x2,%edx
  aa6148:	mov    $0x7,%r11d
  aa614e:	mov    %rbp,%rbx
  aa6151:	mov    0x60(%rax),%rcx
  aa6155:	mov    %rdi,%rax
  aa6158:	shl    $0x4,%rax
  aa615c:	mov    (%rcx,%rax,1),%rsi
  aa6160:	mov    -0x4(%rbx,%rdx,4),%r8d
  aa6165:	mov    %rsi,%r10
  aa6168:	xor    %eax,%eax
  aa616a:	mov    %r8,%r9
  aa616d:	shl    $0x4,%r9
  aa6171:	mov    (%rcx,%r9,1),%rsi
  aa6175:	cmp    %rsi,%r10
  aa6178:	jne    aa6195 <ir_verify_path+0x18d5>
  aa617a:	mov    %edi,%eax
  aa617c:	shl    $0x4,%rax
  aa6180:	add    %rcx,%r9
  aa6183:	mov    0x8(%rcx,%rax,1),%rax
  aa6188:	cmp    0x8(%r9),%rax
  aa618c:	mov    $0x0,%eax
  aa6191:	cmove  %r11d,%eax
  aa6195:	test   %eax,%eax
  aa6197:	jne    aa61a5 <ir_verify_path+0x18e5>
  aa6199:	mov    %r8d,%edi
  aa619c:	cmp    %r15,%rdx
  aa619f:	lea    0x1(%rdx),%rdx
  aa61a3:	jb     aa6160 <ir_verify_path+0x18a0>
  aa61a5:	mov    0x88(%rsp),%r15
  aa61ad:	mov    0x60(%rsp),%r11
  aa61b2:	mov    0x80(%rsp),%r13
  aa61ba:	mov    0x8(%rsp),%rbp
  aa61bf:	mov    0x10(%rsp),%r10
  aa61c4:	mov    0x98(%rsp),%r12
  aa61cc:	movabs $0xffffffff00000000,%r8
  aa61d6:	xor    %r14d,%r14d
  aa61d9:	mov    0x8(%r15),%rcx
  aa61dd:	lea    0x1(%r11),%rbx
  aa61e1:	mov    0x1c(%rsp),%esi
  aa61e5:	mov    0x70(%rsp),%r9
  aa61ea:	cmp    %rcx,%r9
  aa61ed:	ja     aa693e <ir_verify_path+0x207e>
  aa61f3:	mov    %r9,0x8(%r15)
  aa61f7:	mov    %r12d,%r9d
  aa61fa:	inc    %r12
  aa61fd:	test   %eax,%eax
  aa61ff:	je     aa568f <ir_verify_path+0xdcf>
  aa6205:	jmp    aa6270 <ir_verify_path+0x19b0>
  aa6207:	mov    0x48(%rbp),%ecx
  aa620a:	cmp    %rcx,%rbx
  aa620d:	jb     aa567f <ir_verify_path+0xdbf>
  aa6213:	jmp    aa4b53 <ir_verify_path+0x293>
  aa6218:	mov    $0x9,%eax
  aa621d:	mov    %ecx,%r14d
  aa6220:	mov    %r12d,%r9d
  aa6223:	movabs $0xffffffff00000000,%r8
  aa622d:	jmp    aa6270 <ir_verify_path+0x19b0>
  aa622f:	cmpq   $0x0,0x48(%rsp)
  aa6235:	mov    %ecx,%eax
  aa6237:	je     aa62de <ir_verify_path+0x1a1e>
  aa623d:	cmp    $0x8,%ecx
  aa6240:	jae    aa62ec <ir_verify_path+0x1a2c>
  aa6246:	xor    %ecx,%ecx
  aa6248:	xor    %edx,%edx
  aa624a:	jmp    aa666b <ir_verify_path+0x1dab>
  aa624f:	movabs $0xffffffff00000000,%rax
  aa6259:	xor    %r14d,%r14d
  aa625c:	mov    %rax,%r9
  aa625f:	shr    $0x20,%r9
  aa6263:	jmp    aa6270 <ir_verify_path+0x19b0>
  aa6265:	mov    $0x9,%eax
  aa626a:	xor    %r14d,%r14d
  aa626d:	mov    %r12d,%r9d
  aa6270:	cmpq   $0x0,0x48(%rsp)
  aa6276:	mov    %eax,%r12d
  aa6279:	setne  %cl
  aa627c:	test   %eax,%eax
  aa627e:	sete   %dl
  aa6281:	cmp    $0x1,%eax
  aa6284:	sbb    %esi,%esi
  aa6286:	and    %cl,%dl
  aa6288:	or     %r9d,%esi
  aa628b:	movzbl %dl,%edx
  aa628e:	shl    $0x20,%rdx
  aa6292:	shl    $0x20,%rsi
  aa6296:	or     %r14,%rdx
  aa6299:	or     %rsi,%r12
  aa629c:	cmp    0x8(%r15),%r13
  aa62a0:	ja     aa693e <ir_verify_path+0x207e>
  aa62a6:	mov    %r13,0x8(%r15)
  aa62aa:	mov    %fs:0x28,%rcx
  aa62b3:	cmp    0x4e0(%rsp),%rcx
  aa62bb:	jne    aa6960 <ir_verify_path+0x20a0>
  aa62c1:	and    %r8,%r12
  aa62c4:	mov    %eax,%eax
  aa62c6:	or     %r12,%rax
  aa62c9:	add    $0x4e8,%rsp
  aa62d0:	pop    %rbx
  aa62d1:	pop    %r12
  aa62d3:	pop    %r13
  aa62d5:	pop    %r14
  aa62d7:	pop    %r15
  aa62d9:	pop    %rbp
  aa62da:	vzeroupper
  aa62dd:	ret
  aa62de:	cmp    $0x8,%ecx
  aa62e1:	jae    aa62fa <ir_verify_path+0x1a3a>
  aa62e3:	xor    %ecx,%ecx
  aa62e5:	xor    %edx,%edx
  aa62e7:	jmp    aa6916 <ir_verify_path+0x2056>
  aa62ec:	cmp    $0x20,%ecx
  aa62ef:	jae    aa630c <ir_verify_path+0x1a4c>
  aa62f1:	xor    %ecx,%ecx
  aa62f3:	xor    %edx,%edx
  aa62f5:	jmp    aa652c <ir_verify_path+0x1c6c>
  aa62fa:	cmp    $0x40,%ecx
  aa62fd:	jae    aa66b4 <ir_verify_path+0x1df4>
  aa6303:	xor    %ecx,%ecx
  aa6305:	xor    %edx,%edx
  aa6307:	jmp    aa686c <ir_verify_path+0x1fac>
  aa630c:	vmovdqa64 -0x5b4d16(%rip),%zmm1        # 4f1600 <check_builtin_atomic_rmw_test_clang.native_source+0x5c40>
  aa6316:	vpbroadcastd -0x4afa48(%rip),%zmm2        # 5f68d8 <cbuiltin_varargs_aggregate.ends+0x248>
  aa6320:	vpbroadcastd -0x4afa4e(%rip),%zmm3        # 5f68dc <cbuiltin_varargs_aggregate.ends+0x24c>
  aa632a:	mov    %eax,%edx
  aa632c:	shr    $0x5,%edx
  aa632f:	mov    %eax,%ecx
  aa6331:	and    $0xffffffe0,%ecx
  aa6334:	lea    0x2e0(%rsp),%rsi
  aa633c:	vpxor  %xmm0,%xmm0,%xmm0
  aa6340:	xor    %edi,%edi
  aa6342:	vpxor  %xmm4,%xmm4,%xmm4
  aa6346:	shl    $0x7,%rdx
  aa634a:	vmovdqu64 0x160(%rsp,%rdi,1),%zmm5
  aa6355:	vmovdqu64 0x1a0(%rsp,%rdi,1),%zmm6
  aa6360:	vmovdqu64 0x1e0(%rsp,%rdi,1),%zmm7
  aa636b:	vpcmpneqd %zmm6,%zmm5,%k2
  aa6372:	vpcmpeqd %zmm6,%zmm5,%k3
  aa6378:	vpcmpneqd %zmm7,%zmm6,%k1
  aa637f:	vpcmpeqd %zmm7,%zmm6,%k4
  aa6385:	vmovdqu32 -0xc0(%rsi,%rdi,1),%zmm5{%k2}{z}
  aa638d:	vmovdqu32 -0x80(%rsi,%rdi,1),%zmm6{%k1}{z}
  aa6395:	kmovw  %k1,0x30(%rsp)
  aa639b:	vptestnmd %zmm5,%zmm5,%k0
  aa63a1:	korw   %k0,%k3,%k5
  aa63a5:	kmovw  %k0,0x40(%rsp)
  aa63ab:	knotw  %k5,%k5
  aa63af:	vmovdqu32 -0x40(%rsi,%rdi,1),%zmm7{%k5}{z}
  aa63b7:	vptestmd %zmm7,%zmm7,%k5{%k5}
  aa63bd:	vpcmpltud %zmm7,%zmm5,%k7
  aa63c4:	vmovdqu32 -0x100(%rsi,%rdi,1),%zmm8{%k5}{z}
  aa63cc:	vmovdqu32 -0x80(%rsi,%rdi,1),%zmm9{%k5}{z}
  aa63d4:	vpcmpnleud %zmm9,%zmm8,%k6
  aa63db:	korw   %k6,%k7,%k0
  aa63df:	vptestnmd %zmm6,%zmm6,%k6
  aa63e5:	korw   %k6,%k4,%k7
  aa63e9:	kmovw  %k0,0x10(%rsp)
  aa63ef:	knotw  %k7,%k7
  aa63f3:	vmovdqu32 (%rsi,%rdi,1),%zmm5{%k7}{z}
  aa63fa:	vptestmd %zmm5,%zmm5,%k7{%k7}
  aa6400:	vpcmpltud %zmm5,%zmm6,%k1
  aa6407:	vmovdqu32 -0x200(%rsi,%rdi,1),%zmm5{%k3}{z}
  aa640f:	vmovdqu32 -0x1c0(%rsi,%rdi,1),%zmm6{%k3}{z}
  aa6417:	kmovw  0x30(%rsp),%k3
  aa641d:	vmovdqu32 -0xc0(%rsi,%rdi,1),%zmm7{%k7}{z}
  aa6425:	vmovdqu32 -0x40(%rsi,%rdi,1),%zmm8{%k7}{z}
  aa642d:	vpcmpnleud %zmm8,%zmm7,%k0
  aa6434:	vmovdqu32 -0x1c0(%rsi,%rdi,1),%zmm7{%k4}{z}
  aa643c:	vmovdqu32 -0x180(%rsi,%rdi,1),%zmm8{%k4}{z}
  aa6444:	sub    $0xffffffffffffff80,%rdi
  aa6448:	korw   %k0,%k1,%k0
  aa644c:	vpcmpnltud %zmm6,%zmm5,%k1
  aa6453:	kmovw  %k0,0x38(%rsp)
  aa6459:	kmovw  0x40(%rsp),%k0
  aa645f:	korw   %k1,%k2,%k1
  aa6463:	kandnw %k1,%k5,%k1
  aa6467:	kandw  %k0,%k2,%k0
  aa646b:	kmovw  0x10(%rsp),%k2
  aa6471:	kandw  %k5,%k2,%k2
  aa6475:	korw   %k1,%k2,%k1
  aa6479:	kandw  %k6,%k3,%k2
  aa647d:	korw   %k1,%k0,%k0
  aa6481:	vpcmpnltud %zmm8,%zmm7,%k1
  aa6488:	vpaddd %zmm2,%zmm1,%zmm7
  aa648e:	korw   %k1,%k3,%k1
  aa6492:	kmovw  0x38(%rsp),%k3
  aa6498:	vpmovm2d %k0,%zmm5
  aa649e:	vpsrld $0x1f,%zmm5,%zmm5
  aa64a5:	kandnw %k1,%k7,%k1
  aa64a9:	vpsllvd %zmm1,%zmm5,%zmm5
  aa64af:	vpaddd %zmm3,%zmm1,%zmm1
  aa64b5:	vpord  %zmm0,%zmm5,%zmm0
  aa64bb:	kandw  %k7,%k3,%k3
  aa64bf:	korw   %k1,%k3,%k1
  aa64c3:	korw   %k1,%k2,%k1
  aa64c7:	vpmovm2d %k1,%zmm6
  aa64cd:	vpsrld $0x1f,%zmm6,%zmm6
  aa64d4:	vpsllvd %zmm7,%zmm6,%zmm6
  aa64da:	vpord  %zmm4,%zmm6,%zmm4
  aa64e0:	cmp    %rdi,%rdx
  aa64e3:	jne    aa634a <ir_verify_path+0x1a8a>
  aa64e9:	vpord  %zmm0,%zmm4,%zmm0
  aa64ef:	vextracti64x4 $0x1,%zmm0,%ymm1
  aa64f6:	vpord  %zmm1,%zmm0,%zmm0
  aa64fc:	vextracti128 $0x1,%ymm0,%xmm1
  aa6502:	vpor   %xmm1,%xmm0,%xmm0
  aa6506:	vpshufd $0xee,%xmm0,%xmm1
  aa650b:	vpor   %xmm1,%xmm0,%xmm0
  aa650f:	vpshufd $0x55,%xmm0,%xmm1
  aa6514:	vpor   %xmm1,%xmm0,%xmm0
  aa6518:	vmovd  %xmm0,%edx
  aa651c:	cmp    %eax,%ecx
  aa651e:	je     aa5600 <ir_verify_path+0xd40>
  aa6524:	test   $0x18,%al
  aa6526:	je     aa666b <ir_verify_path+0x1dab>
  aa652c:	mov    %rcx,%rsi
  aa652f:	vpbroadcastd %esi,%ymm1
  aa6535:	vpor   -0x4defdd(%rip),%ymm1,%ymm1        # 5c7560 <tier0_jcc_rel8+0x11e0>
  aa653d:	vpbroadcastd -0x4afc66(%rip),%ymm2        # 5f68e0 <cbuiltin_varargs_aggregate.ends+0x250>
  aa6546:	mov    %eax,%ecx
  aa6548:	lea    0x2a0(%rsp),%rdi
  aa6550:	and    $0xfffffff8,%ecx
  aa6553:	vmovd  %edx,%xmm0
  aa6557:	vmovdqu 0x160(%rsp,%rsi,4),%ymm3
  aa6560:	vmovdqu 0x1a0(%rsp,%rsi,4),%ymm4
  aa6569:	vpcmpneqd %ymm4,%ymm3,%k1
  aa6570:	vpcmpeqd %ymm4,%ymm3,%k2
  aa6576:	vmovdqu32 -0x80(%rdi,%rsi,4),%ymm3{%k1}{z}
  aa657e:	vptestnmd %ymm3,%ymm3,%k0
  aa6584:	korb   %k0,%k2,%k3
  aa6588:	kandb  %k0,%k1,%k0
  aa658c:	knotb  %k3,%k3
  aa6590:	vmovdqu32 (%rdi,%rsi,4),%ymm4{%k3}{z}
  aa6597:	vptestmd %ymm4,%ymm4,%k3{%k3}
  aa659d:	vpcmpltud %ymm4,%ymm3,%k5
  aa65a4:	vmovdqu32 -0x1c0(%rdi,%rsi,4),%ymm3{%k2}{z}
  aa65ac:	vmovdqu32 -0x180(%rdi,%rsi,4),%ymm4{%k2}{z}
  aa65b4:	vmovdqu32 -0xc0(%rdi,%rsi,4),%ymm5{%k3}{z}
  aa65bc:	vmovdqu32 -0x40(%rdi,%rsi,4),%ymm6{%k3}{z}
  aa65c4:	add    $0x8,%rsi
  aa65c8:	vpcmpnltud %ymm4,%ymm3,%k2
  aa65cf:	korb   %k2,%k1,%k1
  aa65d3:	kandnb %k1,%k3,%k1
  aa65d7:	vpcmpnleud %ymm6,%ymm5,%k4
  aa65de:	korb   %k4,%k5,%k4
  aa65e2:	kandb  %k3,%k4,%k2
  aa65e6:	korb   %k1,%k2,%k1
  aa65ea:	korb   %k1,%k0,%k0
  aa65ee:	vpmovm2d %k0,%ymm3
  aa65f4:	vpsrld $0x1f,%ymm3,%ymm3
  aa65f9:	vpsllvd %ymm1,%ymm3,%ymm3
  aa65fe:	vpaddd %ymm2,%ymm1,%ymm1
  aa6602:	vpor   %ymm0,%ymm3,%ymm0
  aa6606:	cmp    %rsi,%rcx
  aa6609:	jne    aa6557 <ir_verify_path+0x1c97>
  aa660f:	vextracti128 $0x1,%ymm0,%xmm1
  aa6615:	vpor   %xmm1,%xmm0,%xmm0
  aa6619:	vpshufd $0xee,%xmm0,%xmm1
  aa661e:	vpor   %xmm1,%xmm0,%xmm0
  aa6622:	vpshufd $0x55,%xmm0,%xmm1
  aa6627:	vpor   %xmm1,%xmm0,%xmm0
  aa662b:	vmovd  %xmm0,%edx
  aa662f:	cmp    %eax,%ecx
  aa6631:	jne    aa666b <ir_verify_path+0x1dab>
  aa6633:	jmp    aa5600 <ir_verify_path+0xd40>
  aa6638:	mov    0xe0(%rsp,%rcx,4),%esi
  aa663f:	cmp    0x120(%rsp,%rcx,4),%esi
  aa6646:	setae  %sil
  aa664a:	movzbl %sil,%esi
  aa664e:	movabs $0xffffffff00000000,%r8
  aa6658:	shlx   %ecx,%esi,%esi
  aa665d:	inc    %rcx
  aa6660:	or     %esi,%edx
  aa6662:	cmp    %rcx,%rax
  aa6665:	je     aa5600 <ir_verify_path+0xd40>
  aa666b:	mov    0x160(%rsp,%rcx,4),%esi
  aa6672:	cmp    0x1a0(%rsp,%rcx,4),%esi
  aa6679:	je     aa6638 <ir_verify_path+0x1d78>
  aa667b:	mov    0x220(%rsp,%rcx,4),%edi
  aa6682:	mov    $0x1,%sil
  aa6685:	test   %edi,%edi
  aa6687:	je     aa664a <ir_verify_path+0x1d8a>
  aa6689:	mov    0x2a0(%rsp,%rcx,4),%r8d
  aa6691:	test   %r8d,%r8d
  aa6694:	je     aa664a <ir_verify_path+0x1d8a>
  aa6696:	mov    0x1e0(%rsp,%rcx,4),%esi
  aa669d:	cmp    0x260(%rsp,%rcx,4),%esi
  aa66a4:	seta   %r9b
  aa66a8:	cmp    %r8d,%edi
  aa66ab:	setb   %sil
  aa66af:	or     %r9b,%sil
  aa66b2:	jmp    aa664a <ir_verify_path+0x1d8a>
  aa66b4:	vmovdqa64 -0x5b50be(%rip),%zmm1        # 4f1600 <check_builtin_atomic_rmw_test_clang.native_source+0x5c40>
  aa66be:	vpbroadcastd -0x4afdf0(%rip),%zmm2        # 5f68d8 <cbuiltin_varargs_aggregate.ends+0x248>
  aa66c8:	vpbroadcastd -0x4afdf6(%rip),%zmm3        # 5f68dc <cbuiltin_varargs_aggregate.ends+0x24c>
  aa66d2:	vpbroadcastd -0x4afdf8(%rip),%zmm4        # 5f68e4 <cbuiltin_varargs_aggregate.ends+0x254>
  aa66dc:	vpbroadcastd -0x4afdfe(%rip),%zmm5        # 5f68e8 <cbuiltin_varargs_aggregate.ends+0x258>
  aa66e6:	mov    %eax,%edx
  aa66e8:	shr    $0x6,%edx
  aa66eb:	mov    %eax,%ecx
  aa66ed:	and    $0xffffffc0,%ecx
  aa66f0:	lea    0x260(%rsp),%rsi
  aa66f8:	vpxor  %xmm0,%xmm0,%xmm0
  aa66fc:	xor    %edi,%edi
  aa66fe:	vpxor  %xmm6,%xmm6,%xmm6
  aa6702:	vpxor  %xmm8,%xmm8,%xmm8
  aa6707:	vpxor  %xmm7,%xmm7,%xmm7
  aa670b:	shl    $0x8,%rdx
  aa670f:	vmovdqu64 0x1a0(%rsp,%rdi,1),%zmm12
  aa671a:	vmovdqu64 0x1e0(%rsp,%rdi,1),%zmm13
  aa6725:	vmovdqu64 0x220(%rsp,%rdi,1),%zmm14
  aa6730:	vpaddd %zmm2,%zmm1,%zmm9
  aa6736:	vpaddd %zmm3,%zmm1,%zmm10
  aa673c:	vpaddd %zmm4,%zmm1,%zmm11
  aa6742:	vpcmpeqd 0x160(%rsp,%rdi,1),%zmm12,%k2
  aa674d:	vpcmpeqd 0x260(%rsp,%rdi,1),%zmm14,%k1
  aa6758:	vpcmpeqd %zmm13,%zmm12,%k3
  aa675e:	vpcmpeqd %zmm14,%zmm13,%k4
  aa6764:	vmovdqu32 -0x140(%rsi,%rdi,1),%zmm12{%k2}{z}
  aa676c:	vmovdqu32 -0x100(%rsi,%rdi,1),%zmm13{%k3}{z}
  aa6774:	vmovdqu32 -0xc0(%rsi,%rdi,1),%zmm14{%k4}{z}
  aa677c:	vmovdqu32 -0x80(%rsi,%rdi,1),%zmm15{%k1}{z}
  aa6784:	vpcmpleud -0x180(%rsi,%rdi,1),%zmm12,%k0{%k2}
  aa678d:	vpcmpleud -0xc0(%rsi,%rdi,1),%zmm15,%k1{%k1}
  aa6796:	vpmovm2d %k0,%zmm12
  aa679c:	vpcmpleud -0x140(%rsi,%rdi,1),%zmm13,%k0{%k3}
  aa67a5:	vpsrld $0x1f,%zmm12,%zmm12
  aa67ac:	vpmovm2d %k0,%zmm13
  aa67b2:	vpcmpleud -0x100(%rsi,%rdi,1),%zmm14,%k0{%k4}
  aa67bb:	vpsrld $0x1f,%zmm13,%zmm13
  aa67c2:	add    $0x100,%rdi
  aa67c9:	vpsllvd %zmm9,%zmm13,%zmm9
  aa67cf:	vpord  %zmm8,%zmm9,%zmm8
  aa67d5:	vpmovm2d %k0,%zmm9
  aa67db:	vpsrld $0x1f,%zmm9,%zmm9
  aa67e2:	vpsllvd %zmm10,%zmm9,%zmm9
  aa67e8:	vpsllvd %zmm1,%zmm12,%zmm10
  aa67ee:	vpaddd %zmm5,%zmm1,%zmm1
  aa67f4:	vpord  %zmm7,%zmm9,%zmm7
  aa67fa:	vpmovm2d %k1,%zmm9
  aa6800:	vpsrld $0x1f,%zmm9,%zmm9
  aa6807:	vpord  %zmm6,%zmm10,%zmm6
  aa680d:	vpsllvd %zmm11,%zmm9,%zmm9
  aa6813:	vpord  %zmm0,%zmm9,%zmm0
  aa6819:	cmp    %rdi,%rdx
  aa681c:	jne    aa670f <ir_verify_path+0x1e4f>
  aa6822:	vpord  %zmm6,%zmm8,%zmm1
  aa6828:	vpternlogd $0xfe,%zmm1,%zmm7,%zmm0
  aa682f:	vextracti64x4 $0x1,%zmm0,%ymm1
  aa6836:	vpord  %zmm1,%zmm0,%zmm0
  aa683c:	vextracti128 $0x1,%ymm0,%xmm1
  aa6842:	vpor   %xmm1,%xmm0,%xmm0
  aa6846:	vpshufd $0xee,%xmm0,%xmm1
  aa684b:	vpor   %xmm1,%xmm0,%xmm0
  aa684f:	vpshufd $0x55,%xmm0,%xmm1
  aa6854:	vpor   %xmm1,%xmm0,%xmm0
  aa6858:	vmovd  %xmm0,%edx
  aa685c:	cmp    %eax,%ecx
  aa685e:	je     aa5600 <ir_verify_path+0xd40>
  aa6864:	test   $0x38,%al
  aa6866:	je     aa6916 <ir_verify_path+0x2056>
  aa686c:	mov    %rcx,%rsi
  aa686f:	vpbroadcastd %esi,%ymm1
  aa6875:	vpor   -0x4df31d(%rip),%ymm1,%ymm1        # 5c7560 <tier0_jcc_rel8+0x11e0>
  aa687d:	vpbroadcastd -0x4affa6(%rip),%ymm2        # 5f68e0 <cbuiltin_varargs_aggregate.ends+0x250>
  aa6886:	mov    %eax,%ecx
  aa6888:	lea    0x1a0(%rsp),%rdi
  aa6890:	and    $0xfffffff8,%ecx
  aa6893:	vmovd  %edx,%xmm0
  aa6897:	vmovdqu 0x160(%rsp,%rsi,4),%ymm3
  aa68a0:	vpcmpeqd 0x1a0(%rsp,%rsi,4),%ymm3,%k1
  aa68a8:	vmovdqu32 -0x80(%rdi,%rsi,4),%ymm3{%k1}{z}
  aa68b0:	vpcmpleud -0xc0(%rdi,%rsi,4),%ymm3,%k0{%k1}
  aa68b9:	add    $0x8,%rsi
  aa68bd:	vpmovm2d %k0,%ymm3
  aa68c3:	vpsrld $0x1f,%ymm3,%ymm3
  aa68c8:	vpsllvd %ymm1,%ymm3,%ymm3
  aa68cd:	vpaddd %ymm2,%ymm1,%ymm1
  aa68d1:	vpor   %ymm0,%ymm3,%ymm0
  aa68d5:	cmp    %rsi,%rcx
  aa68d8:	jne    aa6897 <ir_verify_path+0x1fd7>
  aa68da:	vextracti128 $0x1,%ymm0,%xmm1
  aa68e0:	vpor   %xmm1,%xmm0,%xmm0
  aa68e4:	vpshufd $0xee,%xmm0,%xmm1
  aa68e9:	vpor   %xmm1,%xmm0,%xmm0
  aa68ed:	vpshufd $0x55,%xmm0,%xmm1
  aa68f2:	vpor   %xmm1,%xmm0,%xmm0
  aa68f6:	vmovd  %xmm0,%edx
  aa68fa:	cmp    %eax,%ecx
  aa68fc:	jne    aa6916 <ir_verify_path+0x2056>
  aa68fe:	jmp    aa5600 <ir_verify_path+0xd40>
  aa6903:	shlx   %ecx,%esi,%esi
  aa6908:	inc    %rcx
  aa690b:	or     %esi,%edx
  aa690d:	cmp    %rcx,%rax
  aa6910:	je     aa5600 <ir_verify_path+0xd40>
  aa6916:	mov    0x160(%rsp,%rcx,4),%edi
  aa691d:	xor    %esi,%esi
  aa691f:	cmp    0x1a0(%rsp,%rcx,4),%edi
  aa6926:	jne    aa6903 <ir_verify_path+0x2043>
  aa6928:	mov    0xe0(%rsp,%rcx,4),%edi
  aa692f:	xor    %esi,%esi
  aa6931:	cmp    0x120(%rsp,%rcx,4),%edi
  aa6938:	setae  %sil
  aa693c:	jmp    aa6903 <ir_verify_path+0x2043>
  aa693e:	lea    -0x375b15(%rip),%rdi        # 730e30 <pp_string_value.meaning+0x6a255>
  aa6945:	lea    -0x3b96d2(%rip),%rsi        # 6ed27a <pp_string_value.meaning+0x2669f>
  aa694c:	lea    -0x3b96be(%rip),%rcx        # 6ed295 <pp_string_value.meaning+0x266ba>
  aa6953:	mov    $0xbb,%edx
  aa6958:	vzeroupper
  aa695b:	call   7c3aa0 <__assert_fail@plt>
  aa6960:	vzeroupper
  aa6963:	call   7c3a30 <__stack_chk_fail@plt>
