
compact/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008c3790 <check_lower_drain>:
  8c3790:	55                   	push   %rbp
  8c3791:	41 57                	push   %r15
  8c3793:	41 56                	push   %r14
  8c3795:	41 55                	push   %r13
  8c3797:	41 54                	push   %r12
  8c3799:	53                   	push   %rbx
  8c379a:	48 81 ec 38 02 00 00 	sub    $0x238,%rsp
  8c37a1:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c37a8:	00 00 
  8c37aa:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  8c37b1:	00 
  8c37b2:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8c37b8:	85 c9                	test   %ecx,%ecx
  8c37ba:	0f 84 06 50 00 00    	je     8c87c6 <check_lower_drain+0x5036>
  8c37c0:	4c 8d 6f 08          	lea    0x8(%rdi),%r13
  8c37c4:	48 89 fb             	mov    %rdi,%rbx
  8c37c7:	e9 e6 00 00 00       	jmp    8c38b2 <check_lower_drain+0x122>
  8c37cc:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c37d1:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c37d6:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
  8c37dd:	00 
  8c37de:	48 8d bc 24 f0 01 00 	lea    0x1f0(%rsp),%rdi
  8c37e5:	00 
  8c37e6:	4c 89 f6             	mov    %r14,%rsi
  8c37e9:	c5 f8 29 84 24 c0 00 	vmovaps %xmm0,0xc0(%rsp)
  8c37f0:	00 00 
  8c37f2:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c37f6:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  8c37fd:	00 
  8c37fe:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3804:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  8c380b:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3811:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3816:	0f 43 c1             	cmovae %ecx,%eax
  8c3819:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c381e:	89 84 24 dc 00 00 00 	mov    %eax,0xdc(%rsp)
  8c3825:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c382c:	00 
  8c382d:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
  8c3834:	00 00 
  8c3836:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c383c:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  8c3843:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3849:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c384e:	0f 43 c1             	cmovae %ecx,%eax
  8c3851:	89 84 24 f4 00 00 00 	mov    %eax,0xf4(%rsp)
  8c3858:	89 e8                	mov    %ebp,%eax
  8c385a:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
  8c385e:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3865:	48 c1 e2 02          	shl    $0x2,%rdx
  8c3869:	48 03 93 28 01 00 00 	add    0x128(%rbx),%rdx
  8c3870:	83 f1 01             	xor    $0x1,%ecx
  8c3873:	c5 f8 77             	vzeroupper
  8c3876:	e8 15 0b 98 00       	call   1244390 <cbuiltin_misc_append>
  8c387b:	48 8b 84 24 00 02 00 	mov    0x200(%rsp),%rax
  8c3882:	00 
  8c3883:	48 89 df             	mov    %rbx,%rdi
  8c3886:	4c 89 f6             	mov    %r14,%rsi
  8c3889:	44 89 e2             	mov    %r12d,%edx
  8c388c:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8c3891:	c5 fa 6f 84 24 f0 01 	vmovdqu 0x1f0(%rsp),%xmm0
  8c3898:	00 00 
  8c389a:	c5 fa 7f 04 24       	vmovdqu %xmm0,(%rsp)
  8c389f:	e8 ac 15 01 00       	call   8d4e50 <check_lower_builtin_finish>
  8c38a4:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c38aa:	85 c9                	test   %ecx,%ecx
  8c38ac:	0f 84 14 4f 00 00    	je     8c87c6 <check_lower_drain+0x5036>
  8c38b2:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c38b6:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c38bd:	0f 85 03 4f 00 00    	jne    8c87c6 <check_lower_drain+0x5036>
  8c38c3:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c38c7:	ff c9                	dec    %ecx
  8c38c9:	89 8b 3c 01 00 00    	mov    %ecx,0x13c(%rbx)
  8c38cf:	48 c1 e1 04          	shl    $0x4,%rcx
  8c38d3:	48 8b 2c 0a          	mov    (%rdx,%rcx,1),%rbp
  8c38d7:	4c 8b 64 0a 08       	mov    0x8(%rdx,%rcx,1),%r12
  8c38dc:	48 89 ea             	mov    %rbp,%rdx
  8c38df:	48 c1 ea 20          	shr    $0x20,%rdx
  8c38e3:	48 89 e9             	mov    %rbp,%rcx
  8c38e6:	48 c1 e9 30          	shr    $0x30,%rcx
  8c38ea:	44 0f b6 fa          	movzbl %dl,%r15d
  8c38ee:	41 89 ce             	mov    %ecx,%r14d
  8c38f1:	41 83 ff 01          	cmp    $0x1,%r15d
  8c38f5:	45 0f 45 f4          	cmovne %r12d,%r14d
  8c38f9:	75 45                	jne    8c3940 <check_lower_drain+0x1b0>
  8c38fb:	80 f9 0f             	cmp    $0xf,%cl
  8c38fe:	0f 82 0c 01 00 00    	jb     8c3a10 <check_lower_drain+0x280>
  8c3904:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c390b:	75 97                	jne    8c38a4 <check_lower_drain+0x114>
  8c390d:	48 8d 0d 2f 5b dc ff 	lea    -0x23a4d1(%rip),%rcx        # 689443 <fuzz_comment_end+0x26c80>
  8c3914:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c391b:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c391f:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3926:	0f 85 78 ff ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c392c:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c3933:	00 00 00 
  8c3936:	e9 03 18 00 00       	jmp    8c513e <check_lower_drain+0x19ae>
  8c393b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8c3940:	0f b6 ca             	movzbl %dl,%ecx
  8c3943:	83 c1 fe             	add    $0xfffffffe,%ecx
  8c3946:	83 f9 04             	cmp    $0x4,%ecx
  8c3949:	0f 87 27 02 00 00    	ja     8c3b76 <check_lower_drain+0x3e6>
  8c394f:	48 8d 15 36 3a be ff 	lea    -0x41c5ca(%rip),%rdx        # 4a738c <cbuiltin_test_generated.edges+0xacfc>
  8c3956:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  8c395a:	48 01 d1             	add    %rdx,%rcx
  8c395d:	ff e1                	jmp    *%rcx
  8c395f:	8b 8b b0 01 00 00    	mov    0x1b0(%rbx),%ecx
  8c3965:	89 ea                	mov    %ebp,%edx
  8c3967:	c1 ea 03             	shr    $0x3,%edx
  8c396a:	39 ca                	cmp    %ecx,%edx
  8c396c:	73 11                	jae    8c397f <check_lower_drain+0x1ef>
  8c396e:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3975:	f6 04 17 02          	testb  $0x2,(%rdi,%rdx,1)
  8c3979:	0f 85 ee 04 00 00    	jne    8c3e6d <check_lower_drain+0x6dd>
  8c397f:	44 89 f6             	mov    %r14d,%esi
  8c3982:	c1 ee 03             	shr    $0x3,%esi
  8c3985:	39 ce                	cmp    %ecx,%esi
  8c3987:	73 11                	jae    8c399a <check_lower_drain+0x20a>
  8c3989:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3990:	f6 04 37 02          	testb  $0x2,(%rdi,%rsi,1)
  8c3994:	0f 85 d9 04 00 00    	jne    8c3e73 <check_lower_drain+0x6e3>
  8c399a:	41 b4 ff             	mov    $0xff,%r12b
  8c399d:	41 b7 ff             	mov    $0xff,%r15b
  8c39a0:	39 ca                	cmp    %ecx,%edx
  8c39a2:	73 1c                	jae    8c39c0 <check_lower_drain+0x230>
  8c39a4:	48 8b b3 a0 01 00 00 	mov    0x1a0(%rbx),%rsi
  8c39ab:	41 b7 08             	mov    $0x8,%r15b
  8c39ae:	f6 04 16 01          	testb  $0x1,(%rsi,%rdx,1)
  8c39b2:	75 0c                	jne    8c39c0 <check_lower_drain+0x230>
  8c39b4:	48 8b b3 98 01 00 00 	mov    0x198(%rbx),%rsi
  8c39bb:	44 0f b6 3c 16       	movzbl (%rsi,%rdx,1),%r15d
  8c39c0:	44 89 f6             	mov    %r14d,%esi
  8c39c3:	c1 ee 03             	shr    $0x3,%esi
  8c39c6:	39 ce                	cmp    %ecx,%esi
  8c39c8:	73 1c                	jae    8c39e6 <check_lower_drain+0x256>
  8c39ca:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c39d1:	41 b4 08             	mov    $0x8,%r12b
  8c39d4:	f6 04 37 01          	testb  $0x1,(%rdi,%rsi,1)
  8c39d8:	75 0c                	jne    8c39e6 <check_lower_drain+0x256>
  8c39da:	48 8b bb 98 01 00 00 	mov    0x198(%rbx),%rdi
  8c39e1:	44 0f b6 24 37       	movzbl (%rdi,%rsi,1),%r12d
  8c39e6:	39 ca                	cmp    %ecx,%edx
  8c39e8:	0f 83 dd 02 00 00    	jae    8c3ccb <check_lower_drain+0x53b>
  8c39ee:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c39f5:	0f b6 3c 17          	movzbl (%rdi,%rdx,1),%edi
  8c39f9:	39 ce                	cmp    %ecx,%esi
  8c39fb:	0f 82 d0 02 00 00    	jb     8c3cd1 <check_lower_drain+0x541>
  8c3a01:	e9 d6 02 00 00       	jmp    8c3cdc <check_lower_drain+0x54c>
  8c3a06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8c3a0d:	00 00 00 
  8c3a10:	8b 93 38 01 00 00    	mov    0x138(%rbx),%edx
  8c3a16:	81 fa ff ff ff 00    	cmp    $0xffffff,%edx
  8c3a1c:	0f 87 05 17 00 00    	ja     8c5127 <check_lower_drain+0x1997>
  8c3a22:	3b 93 40 01 00 00    	cmp    0x140(%rbx),%edx
  8c3a28:	0f 83 f9 16 00 00    	jae    8c5127 <check_lower_drain+0x1997>
  8c3a2e:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c3a35:	0f 85 82 01 00 00    	jne    8c3bbd <check_lower_drain+0x42d>
  8c3a3b:	0f b6 d1             	movzbl %cl,%edx
  8c3a3e:	40 0f b6 f5          	movzbl %bpl,%esi
  8c3a42:	48 89 df             	mov    %rbx,%rdi
  8c3a45:	4c 89 e1             	mov    %r12,%rcx
  8c3a48:	c5 f8 77             	vzeroupper
  8c3a4b:	e8 40 d1 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c3a50:	e9 4f fe ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c3a55:	48 89 df             	mov    %rbx,%rdi
  8c3a58:	89 ee                	mov    %ebp,%esi
  8c3a5a:	c5 f8 77             	vzeroupper
  8c3a5d:	e8 de ae ff ff       	call   8be940 <check_lower_control>
  8c3a62:	e9 3d fe ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c3a67:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c3a6c:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c3a71:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
  8c3a78:	00 
  8c3a79:	48 8d bc 24 f0 01 00 	lea    0x1f0(%rsp),%rdi
  8c3a80:	00 
  8c3a81:	4c 89 f6             	mov    %r14,%rsi
  8c3a84:	c5 f8 29 84 24 c0 00 	vmovaps %xmm0,0xc0(%rsp)
  8c3a8b:	00 00 
  8c3a8d:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3a91:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  8c3a98:	00 
  8c3a99:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3a9f:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  8c3aa6:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3aac:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3ab1:	0f 43 c1             	cmovae %ecx,%eax
  8c3ab4:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c3ab9:	89 84 24 dc 00 00 00 	mov    %eax,0xdc(%rsp)
  8c3ac0:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c3ac7:	00 
  8c3ac8:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
  8c3acf:	00 00 
  8c3ad1:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c3ad7:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  8c3ade:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3ae4:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c3ae9:	0f 43 c1             	cmovae %ecx,%eax
  8c3aec:	89 84 24 f4 00 00 00 	mov    %eax,0xf4(%rsp)
  8c3af3:	89 e8                	mov    %ebp,%eax
  8c3af5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8c3af9:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3b00:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  8c3b04:	48 01 c2             	add    %rax,%rdx
  8c3b07:	48 03 93 20 01 00 00 	add    0x120(%rbx),%rdx
  8c3b0e:	83 f1 01             	xor    $0x1,%ecx
  8c3b11:	c5 f8 77             	vzeroupper
  8c3b14:	e8 17 8a 97 00       	call   123c530 <cbuiltin_lower_append>
  8c3b19:	e9 5d fd ff ff       	jmp    8c387b <check_lower_drain+0xeb>
  8c3b1e:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c3b24:	48 8b 53 48          	mov    0x48(%rbx),%rdx
  8c3b28:	89 e8                	mov    %ebp,%eax
  8c3b2a:	89 0c 82             	mov    %ecx,(%rdx,%rax,4)
  8c3b2d:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c3b34:	0f 85 6a fd ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c3b3a:	48 8b 4b 50          	mov    0x50(%rbx),%rcx
  8c3b3e:	80 bb 7c 01 00 00 00 	cmpb   $0x0,0x17c(%rbx)
  8c3b45:	75 14                	jne    8c3b5b <check_lower_drain+0x3cb>
  8c3b47:	8b 14 81             	mov    (%rcx,%rax,4),%edx
  8c3b4a:	be 00 00 00 00       	mov    $0x0,%esi
  8c3b4f:	83 fa ff             	cmp    $0xffffffff,%edx
  8c3b52:	0f 44 d6             	cmove  %esi,%edx
  8c3b55:	89 93 74 01 00 00    	mov    %edx,0x174(%rbx)
  8c3b5b:	83 3c 81 ff          	cmpl   $0xffffffff,(%rcx,%rax,4)
  8c3b5f:	75 09                	jne    8c3b6a <check_lower_drain+0x3da>
  8c3b61:	8b 93 74 01 00 00    	mov    0x174(%rbx),%edx
  8c3b67:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  8c3b6a:	c6 83 7c 01 00 00 01 	movb   $0x1,0x17c(%rbx)
  8c3b71:	e9 2e fd ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c3b76:	41 8d 4f f9          	lea    -0x7(%r15),%ecx
  8c3b7a:	83 f9 01             	cmp    $0x1,%ecx
  8c3b7d:	77 70                	ja     8c3bef <check_lower_drain+0x45f>
  8c3b7f:	89 ea                	mov    %ebp,%edx
  8c3b81:	48 c1 e2 05          	shl    $0x5,%rdx
  8c3b85:	48 03 93 30 01 00 00 	add    0x130(%rbx),%rdx
  8c3b8c:	41 83 ff 08          	cmp    $0x8,%r15d
  8c3b90:	0f 85 92 00 00 00    	jne    8c3c28 <check_lower_drain+0x498>
  8c3b96:	8b 02                	mov    (%rdx),%eax
  8c3b98:	b9 b3 fe ff ff       	mov    $0xfffffeb3,%ecx
  8c3b9d:	01 c8                	add    %ecx,%eax
  8c3b9f:	83 f8 01             	cmp    $0x1,%eax
  8c3ba2:	0f 87 80 00 00 00    	ja     8c3c28 <check_lower_drain+0x498>
  8c3ba8:	48 89 df             	mov    %rbx,%rdi
  8c3bab:	89 ee                	mov    %ebp,%esi
  8c3bad:	44 89 e2             	mov    %r12d,%edx
  8c3bb0:	c5 f8 77             	vzeroupper
  8c3bb3:	e8 48 1b 01 00       	call   8d5700 <check_lower_floating_strict>
  8c3bb8:	e9 e7 fc ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c3bbd:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3bc4:	0f 85 da fc ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c3bca:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c3bce:	40 88 2c 10          	mov    %bpl,(%rax,%rdx,1)
  8c3bd2:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c3bd6:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8c3bd9:	8d 4a 01             	lea    0x1(%rdx),%ecx
  8c3bdc:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3be0:	4c 89 24 d0          	mov    %r12,(%rax,%rdx,8)
  8c3be4:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c3bea:	e9 b5 fc ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c3bef:	0f b6 ca             	movzbl %dl,%ecx
  8c3bf2:	83 c1 f7             	add    $0xfffffff7,%ecx
  8c3bf5:	83 f9 0a             	cmp    $0xa,%ecx
  8c3bf8:	0f 87 9b 08 00 00    	ja     8c4499 <check_lower_drain+0xd09>
  8c3bfe:	48 8d 15 9b 37 be ff 	lea    -0x41c865(%rip),%rdx        # 4a73a0 <cbuiltin_test_generated.edges+0xad10>
  8c3c05:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  8c3c09:	48 01 d1             	add    %rdx,%rcx
  8c3c0c:	ff e1                	jmp    *%rcx
  8c3c0e:	48 8b 03             	mov    (%rbx),%rax
  8c3c11:	89 e9                	mov    %ebp,%ecx
  8c3c13:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  8c3c17:	48 c1 e6 05          	shl    $0x5,%rsi
  8c3c1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c3c1f:	48 03 70 08          	add    0x8(%rax),%rsi
  8c3c23:	e9 d6 04 00 00       	jmp    8c40fe <check_lower_drain+0x96e>
  8c3c28:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c3c2d:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c3c32:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
  8c3c39:	00 
  8c3c3a:	48 8d bc 24 f0 01 00 	lea    0x1f0(%rsp),%rdi
  8c3c41:	00 
  8c3c42:	4c 89 f6             	mov    %r14,%rsi
  8c3c45:	c5 f8 29 84 24 c0 00 	vmovaps %xmm0,0xc0(%rsp)
  8c3c4c:	00 00 
  8c3c4e:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3c52:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  8c3c59:	00 
  8c3c5a:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3c60:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  8c3c67:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3c6d:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3c72:	0f 43 c1             	cmovae %ecx,%eax
  8c3c75:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c3c7a:	89 84 24 dc 00 00 00 	mov    %eax,0xdc(%rsp)
  8c3c81:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c3c88:	00 
  8c3c89:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
  8c3c90:	00 00 
  8c3c92:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c3c98:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  8c3c9f:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3ca5:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c3caa:	0f 43 c1             	cmovae %ecx,%eax
  8c3cad:	89 84 24 f4 00 00 00 	mov    %eax,0xf4(%rsp)
  8c3cb4:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3cbb:	83 f1 01             	xor    $0x1,%ecx
  8c3cbe:	c5 f8 77             	vzeroupper
  8c3cc1:	e8 1a 1c 98 00       	call   12458e0 <cbuiltin_float_lower_append>
  8c3cc6:	e9 b0 fb ff ff       	jmp    8c387b <check_lower_drain+0xeb>
  8c3ccb:	31 ff                	xor    %edi,%edi
  8c3ccd:	39 ce                	cmp    %ecx,%esi
  8c3ccf:	73 0b                	jae    8c3cdc <check_lower_drain+0x54c>
  8c3cd1:	48 8b 93 a0 01 00 00 	mov    0x1a0(%rbx),%rdx
  8c3cd8:	40 32 3c 32          	xor    (%rdx,%rsi,1),%dil
  8c3cdc:	48 8b 13             	mov    (%rbx),%rdx
  8c3cdf:	45 84 e4             	test   %r12b,%r12b
  8c3ce2:	41 0f 95 c1          	setne  %r9b
  8c3ce6:	41 20 f9             	and    %dil,%r9b
  8c3ce9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8c3ced:	41 80 ff 0e          	cmp    $0xe,%r15b
  8c3cf1:	0f 87 a4 00 00 00    	ja     8c3d9b <check_lower_drain+0x60b>
  8c3cf7:	41 80 fc 0e          	cmp    $0xe,%r12b
  8c3cfb:	0f 87 9a 00 00 00    	ja     8c3d9b <check_lower_drain+0x60b>
  8c3d01:	45 84 c9             	test   %r9b,%r9b
  8c3d04:	0f 85 91 00 00 00    	jne    8c3d9b <check_lower_drain+0x60b>
  8c3d0a:	45 84 e4             	test   %r12b,%r12b
  8c3d0d:	0f 84 92 01 00 00    	je     8c3ea5 <check_lower_drain+0x715>
  8c3d13:	39 ce                	cmp    %ecx,%esi
  8c3d15:	73 11                	jae    8c3d28 <check_lower_drain+0x598>
  8c3d17:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c3d1e:	f6 04 31 10          	testb  $0x10,(%rcx,%rsi,1)
  8c3d22:	0f 85 2e 02 00 00    	jne    8c3f56 <check_lower_drain+0x7c6>
  8c3d28:	44 89 f9             	mov    %r15d,%ecx
  8c3d2b:	80 e1 0e             	and    $0xe,%cl
  8c3d2e:	80 f9 0c             	cmp    $0xc,%cl
  8c3d31:	0f 85 b4 01 00 00    	jne    8c3eeb <check_lower_drain+0x75b>
  8c3d37:	41 8d 4c 24 f7       	lea    -0x9(%r12),%ecx
  8c3d3c:	80 f9 02             	cmp    $0x2,%cl
  8c3d3f:	0f 87 a6 01 00 00    	ja     8c3eeb <check_lower_drain+0x75b>
  8c3d45:	31 c0                	xor    %eax,%eax
  8c3d47:	41 80 ff 0c          	cmp    $0xc,%r15b
  8c3d4b:	41 0f b6 ef          	movzbl %r15b,%ebp
  8c3d4f:	48 89 df             	mov    %rbx,%rdi
  8c3d52:	0f 95 c0             	setne  %al
  8c3d55:	89 ee                	mov    %ebp,%esi
  8c3d57:	8d 04 c5 70 00 00 00 	lea    0x70(,%rax,8),%eax
  8c3d5e:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
  8c3d65:	c5 f8 77             	vzeroupper
  8c3d68:	e8 93 a8 ff ff       	call   8be600 <check_lower_temporary>
  8c3d6d:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c3d71:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c3d78:	0f 84 94 07 00 00    	je     8c4512 <check_lower_drain+0xd82>
  8c3d7e:	45 31 c0             	xor    %r8d,%r8d
  8c3d81:	41 89 c6             	mov    %eax,%r14d
  8c3d84:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3d8a:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c3d90:	0f 86 eb 07 00 00    	jbe    8c4581 <check_lower_drain+0xdf1>
  8c3d96:	e9 18 08 00 00       	jmp    8c45b3 <check_lower_drain+0xe23>
  8c3d9b:	4c 8d 05 55 7d d2 ff 	lea    -0x2d82ab(%rip),%r8        # 5ebaf7 <parse_test_openers+0x1f9e2>
  8c3da2:	45 84 c9             	test   %r9b,%r9b
  8c3da5:	0f 85 1f 0f 00 00    	jne    8c4cca <check_lower_drain+0x153a>
  8c3dab:	48 8b 0a             	mov    (%rdx),%rcx
  8c3dae:	41 80 ff 0f          	cmp    $0xf,%r15b
  8c3db2:	44 0f 43 f5          	cmovae %ebp,%r14d
  8c3db6:	44 89 f7             	mov    %r14d,%edi
  8c3db9:	c1 ef 03             	shr    $0x3,%edi
  8c3dbc:	0f b6 34 39          	movzbl (%rcx,%rdi,1),%esi
  8c3dc0:	40 80 fe 0f          	cmp    $0xf,%sil
  8c3dc4:	75 12                	jne    8c3dd8 <check_lower_drain+0x648>
  8c3dc6:	48 8b 72 20          	mov    0x20(%rdx),%rsi
  8c3dca:	44 8b 34 be          	mov    (%rsi,%rdi,4),%r14d
  8c3dce:	44 89 f7             	mov    %r14d,%edi
  8c3dd1:	c1 ef 03             	shr    $0x3,%edi
  8c3dd4:	0f b6 34 39          	movzbl (%rcx,%rdi,1),%esi
  8c3dd8:	4c 8d 05 c1 0b d4 ff 	lea    -0x2bf43f(%rip),%r8        # 6049a0 <parse_test_openers+0x3888b>
  8c3ddf:	40 80 fe 03          	cmp    $0x3,%sil
  8c3de3:	0f 84 e1 0e 00 00    	je     8c4cca <check_lower_drain+0x153a>
  8c3de9:	41 83 e6 f8          	and    $0xfffffff8,%r14d
  8c3ded:	4c 8d 05 ac 0b d4 ff 	lea    -0x2bf454(%rip),%r8        # 6049a0 <parse_test_openers+0x3888b>
  8c3df4:	41 81 fe 88 00 00 00 	cmp    $0x88,%r14d
  8c3dfb:	0f 84 c9 0e 00 00    	je     8c4cca <check_lower_drain+0x153a>
  8c3e01:	4c 8d 05 98 0b d4 ff 	lea    -0x2bf468(%rip),%r8        # 6049a0 <parse_test_openers+0x3888b>
  8c3e08:	41 81 fe b0 00 00 00 	cmp    $0xb0,%r14d
  8c3e0f:	0f 84 b5 0e 00 00    	je     8c4cca <check_lower_drain+0x153a>
  8c3e15:	4c 8d 05 3f 17 e9 ff 	lea    -0x16e8c1(%rip),%r8        # 75555b <pp_decode_file_name.meaning+0x1e6d5>
  8c3e1c:	40 80 fe 05          	cmp    $0x5,%sil
  8c3e20:	0f 84 a4 0e 00 00    	je     8c4cca <check_lower_drain+0x153a>
  8c3e26:	44 0f b6 c6          	movzbl %sil,%r8d
  8c3e2a:	41 83 f8 06          	cmp    $0x6,%r8d
  8c3e2e:	0f 85 68 0e 00 00    	jne    8c4c9c <check_lower_drain+0x150c>
  8c3e34:	48 8b 52 20          	mov    0x20(%rdx),%rdx
  8c3e38:	8b 34 ba             	mov    (%rdx,%rdi,4),%esi
  8c3e3b:	c1 ee 03             	shr    $0x3,%esi
  8c3e3e:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
  8c3e42:	40 80 ff 0f          	cmp    $0xf,%dil
  8c3e46:	75 0a                	jne    8c3e52 <check_lower_drain+0x6c2>
  8c3e48:	8b 14 b2             	mov    (%rdx,%rsi,4),%edx
  8c3e4b:	c1 ea 03             	shr    $0x3,%edx
  8c3e4e:	0f b6 3c 11          	movzbl (%rcx,%rdx,1),%edi
  8c3e52:	40 80 ff 02          	cmp    $0x2,%dil
  8c3e56:	4c 8d 05 2b 7c d2 ff 	lea    -0x2d83d5(%rip),%r8        # 5eba88 <parse_test_openers+0x1f973>
  8c3e5d:	48 8d 0d 5e ee d0 ff 	lea    -0x2f11a2(%rip),%rcx        # 5d2cc2 <parse_test_openers+0x6bad>
  8c3e64:	4c 0f 44 c1          	cmove  %rcx,%r8
  8c3e68:	e9 5d 0e 00 00       	jmp    8c4cca <check_lower_drain+0x153a>
  8c3e6d:	44 89 f6             	mov    %r14d,%esi
  8c3e70:	c1 ee 03             	shr    $0x3,%esi
  8c3e73:	39 ce                	cmp    %ecx,%esi
  8c3e75:	73 19                	jae    8c3e90 <check_lower_drain+0x700>
  8c3e77:	89 f6                	mov    %esi,%esi
  8c3e79:	f6 04 37 01          	testb  $0x1,(%rdi,%rsi,1)
  8c3e7d:	75 11                	jne    8c3e90 <check_lower_drain+0x700>
  8c3e7f:	48 8b bb 98 01 00 00 	mov    0x198(%rbx),%rdi
  8c3e86:	80 3c 37 00          	cmpb   $0x0,(%rdi,%rsi,1)
  8c3e8a:	0f 84 0a fb ff ff    	je     8c399a <check_lower_drain+0x20a>
  8c3e90:	48 89 df             	mov    %rbx,%rdi
  8c3e93:	89 ee                	mov    %ebp,%esi
  8c3e95:	44 89 f2             	mov    %r14d,%edx
  8c3e98:	c5 f8 77             	vzeroupper
  8c3e9b:	e8 50 df 00 00       	call   8d1df0 <check_lower_complex_conversion>
  8c3ea0:	e9 ff f9 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c3ea5:	45 84 ff             	test   %r15b,%r15b
  8c3ea8:	0f 84 f6 f9 ff ff    	je     8c38a4 <check_lower_drain+0x114>
  8c3eae:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c3eb4:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c3ebb:	0f 87 66 12 00 00    	ja     8c5127 <check_lower_drain+0x1997>
  8c3ec1:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c3ec7:	0f 83 5a 12 00 00    	jae    8c5127 <check_lower_drain+0x1997>
  8c3ecd:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c3ed4:	0f 85 d8 09 00 00    	jne    8c48b2 <check_lower_drain+0x1122>
  8c3eda:	41 0f b6 d7          	movzbl %r15b,%edx
  8c3ede:	be 23 00 00 00       	mov    $0x23,%esi
  8c3ee3:	48 89 df             	mov    %rbx,%rdi
  8c3ee6:	e9 29 12 00 00       	jmp    8c5114 <check_lower_drain+0x1984>
  8c3eeb:	44 89 e1             	mov    %r12d,%ecx
  8c3eee:	80 e1 0e             	and    $0xe,%cl
  8c3ef1:	80 f9 0c             	cmp    $0xc,%cl
  8c3ef4:	0f 85 d2 05 00 00    	jne    8c44cc <check_lower_drain+0xd3c>
  8c3efa:	41 8d 4f f7          	lea    -0x9(%r15),%ecx
  8c3efe:	80 f9 02             	cmp    $0x2,%cl
  8c3f01:	0f 87 c5 05 00 00    	ja     8c44cc <check_lower_drain+0xd3c>
  8c3f07:	31 c0                	xor    %eax,%eax
  8c3f09:	41 80 ff 0a          	cmp    $0xa,%r15b
  8c3f0d:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c3f12:	41 0f b6 ec          	movzbl %r12b,%ebp
  8c3f16:	48 89 df             	mov    %rbx,%rdi
  8c3f19:	0f 95 c0             	setne  %al
  8c3f1c:	41 80 ff 09          	cmp    $0x9,%r15b
  8c3f20:	89 ee                	mov    %ebp,%esi
  8c3f22:	8d 04 c5 a0 00 00 00 	lea    0xa0(,%rax,8),%eax
  8c3f29:	0f 44 c1             	cmove  %ecx,%eax
  8c3f2c:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
  8c3f33:	c5 f8 77             	vzeroupper
  8c3f36:	e8 c5 a6 ff ff       	call   8be600 <check_lower_temporary>
  8c3f3b:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c3f3f:	41 89 c6             	mov    %eax,%r14d
  8c3f42:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c3f49:	0f 84 0f 0b 00 00    	je     8c4a5e <check_lower_drain+0x12ce>
  8c3f4f:	31 c9                	xor    %ecx,%ecx
  8c3f51:	e9 51 0b 00 00       	jmp    8c4aa7 <check_lower_drain+0x1317>
  8c3f56:	41 8d 4f ff          	lea    -0x1(%r15),%ecx
  8c3f5a:	80 f9 03             	cmp    $0x3,%cl
  8c3f5d:	0f 87 62 10 00 00    	ja     8c4fc5 <check_lower_drain+0x1835>
  8c3f63:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c3f69:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c3f70:	0f 87 6e 0b 00 00    	ja     8c4ae4 <check_lower_drain+0x1354>
  8c3f76:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c3f7c:	0f 83 62 0b 00 00    	jae    8c4ae4 <check_lower_drain+0x1354>
  8c3f82:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c3f89:	0f 85 06 10 00 00    	jne    8c4f95 <check_lower_drain+0x1805>
  8c3f8f:	be 09 00 00 00       	mov    $0x9,%esi
  8c3f94:	ba 05 00 00 00       	mov    $0x5,%edx
  8c3f99:	48 89 df             	mov    %rbx,%rdi
  8c3f9c:	31 c9                	xor    %ecx,%ecx
  8c3f9e:	c5 f8 77             	vzeroupper
  8c3fa1:	e8 ea cb 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c3fa6:	41 b7 05             	mov    $0x5,%r15b
  8c3fa9:	e9 17 10 00 00       	jmp    8c4fc5 <check_lower_drain+0x1835>
  8c3fae:	4d 85 e4             	test   %r12,%r12
  8c3fb1:	0f 84 6c 0a 00 00    	je     8c4a23 <check_lower_drain+0x1293>
  8c3fb7:	48 89 e8             	mov    %rbp,%rax
  8c3fba:	48 c1 e8 28          	shr    $0x28,%rax
  8c3fbe:	48 89 df             	mov    %rbx,%rdi
  8c3fc1:	83 e0 01             	and    $0x1,%eax
  8c3fc4:	49 81 fc 01 01 00 00 	cmp    $0x101,%r12
  8c3fcb:	0f 93 c1             	setae  %cl
  8c3fce:	08 c1                	or     %al,%cl
  8c3fd0:	0f 84 f7 0a 00 00    	je     8c4acd <check_lower_drain+0x133d>
  8c3fd6:	be 08 00 00 00       	mov    $0x8,%esi
  8c3fdb:	c5 f8 77             	vzeroupper
  8c3fde:	e8 1d a6 ff ff       	call   8be600 <check_lower_temporary>
  8c3fe3:	48 0f ba e5 28       	bt     $0x28,%rbp
  8c3fe8:	41 89 c6             	mov    %eax,%r14d
  8c3feb:	0f 83 36 0d 00 00    	jae    8c4d27 <check_lower_drain+0x1597>
  8c3ff1:	be 08 00 00 00       	mov    $0x8,%esi
  8c3ff6:	48 89 df             	mov    %rbx,%rdi
  8c3ff9:	e8 02 a6 ff ff       	call   8be600 <check_lower_temporary>
  8c3ffe:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c4003:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4008:	44 89 f1             	mov    %r14d,%ecx
  8c400b:	48 89 df             	mov    %rbx,%rdi
  8c400e:	41 89 c7             	mov    %eax,%r15d
  8c4011:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8c4016:	e8 e5 47 00 00       	call   8c8800 <check_lower_emit>
  8c401b:	be 1e 00 00 00       	mov    $0x1e,%esi
  8c4020:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4025:	48 89 df             	mov    %rbx,%rdi
  8c4028:	4c 89 f9             	mov    %r15,%rcx
  8c402b:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  8c4030:	e9 11 0d 00 00       	jmp    8c4d46 <check_lower_drain+0x15b6>
  8c4035:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c403a:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c403f:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
  8c4046:	00 
  8c4047:	48 8d bc 24 f0 01 00 	lea    0x1f0(%rsp),%rdi
  8c404e:	00 
  8c404f:	4c 89 f6             	mov    %r14,%rsi
  8c4052:	c5 f8 29 84 24 c0 00 	vmovaps %xmm0,0xc0(%rsp)
  8c4059:	00 00 
  8c405b:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c405f:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  8c4066:	00 
  8c4067:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c406d:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  8c4074:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c407a:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c407f:	0f 43 c1             	cmovae %ecx,%eax
  8c4082:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c4087:	89 84 24 dc 00 00 00 	mov    %eax,0xdc(%rsp)
  8c408e:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c4095:	00 
  8c4096:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
  8c409d:	00 00 
  8c409f:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c40a5:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  8c40ac:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c40b2:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c40b7:	0f 43 c1             	cmovae %ecx,%eax
  8c40ba:	89 84 24 f4 00 00 00 	mov    %eax,0xf4(%rsp)
  8c40c1:	89 e8                	mov    %ebp,%eax
  8c40c3:	48 6b d0 34          	imul   $0x34,%rax,%rdx
  8c40c7:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c40ce:	48 03 93 d0 01 00 00 	add    0x1d0(%rbx),%rdx
  8c40d5:	83 f1 01             	xor    $0x1,%ecx
  8c40d8:	c5 f8 77             	vzeroupper
  8c40db:	e8 50 4e 98 00       	call   1248f30 <cbuiltin_varargs_append>
  8c40e0:	e9 96 f7 ff ff       	jmp    8c387b <check_lower_drain+0xeb>
  8c40e5:	48 8b 03             	mov    (%rbx),%rax
  8c40e8:	89 e9                	mov    %ebp,%ecx
  8c40ea:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c40f1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c40f5:	48 8b 40 68          	mov    0x68(%rax),%rax
  8c40f9:	48 8d 74 08 10       	lea    0x10(%rax,%rcx,1),%rsi
  8c40fe:	48 89 df             	mov    %rbx,%rdi
  8c4101:	c5 f8 77             	vzeroupper
  8c4104:	e8 87 97 00 00       	call   8cd890 <check_lower_constant>
  8c4109:	e9 96 f7 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c410e:	8b ab 74 01 00 00    	mov    0x174(%rbx),%ebp
  8c4114:	89 e8                	mov    %ebp,%eax
  8c4116:	85 ed                	test   %ebp,%ebp
  8c4118:	75 5f                	jne    8c4179 <check_lower_drain+0x9e9>
  8c411a:	8b 8b 44 01 00 00    	mov    0x144(%rbx),%ecx
  8c4120:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4126:	0f 83 b7 04 00 00    	jae    8c45e3 <check_lower_drain+0xe53>
  8c412c:	48 8b 43 48          	mov    0x48(%rbx),%rax
  8c4130:	c7 04 88 ff ff ff ff 	movl   $0xffffffff,(%rax,%rcx,4)
  8c4137:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c413e:	75 0b                	jne    8c414b <check_lower_drain+0x9bb>
  8c4140:	48 8b 43 50          	mov    0x50(%rbx),%rax
  8c4144:	c7 04 88 ff ff ff ff 	movl   $0xffffffff,(%rax,%rcx,4)
  8c414b:	ff 83 44 01 00 00    	incl   0x144(%rbx)
  8c4151:	e9 b4 04 00 00       	jmp    8c460a <check_lower_drain+0xe7a>
  8c4156:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8c415d:	00 00 00 
  8c4160:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4164:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c416b:	74 6b                	je     8c41d8 <check_lower_drain+0xa48>
  8c416d:	48 8b 43 58          	mov    0x58(%rbx),%rax
  8c4171:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c4175:	85 c0                	test   %eax,%eax
  8c4177:	74 a1                	je     8c411a <check_lower_drain+0x98a>
  8c4179:	48 8b 4b 60          	mov    0x60(%rbx),%rcx
  8c417d:	41 89 c6             	mov    %eax,%r14d
  8c4180:	42 0f b6 04 31       	movzbl (%rcx,%r14,1),%eax
  8c4185:	3c 0f                	cmp    $0xf,%al
  8c4187:	73 d7                	jae    8c4160 <check_lower_drain+0x9d0>
  8c4189:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c418f:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8c4195:	77 28                	ja     8c41bf <check_lower_drain+0xa2f>
  8c4197:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c419d:	73 20                	jae    8c41bf <check_lower_drain+0xa2f>
  8c419f:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c41a6:	75 6e                	jne    8c4216 <check_lower_drain+0xa86>
  8c41a8:	0f b6 d0             	movzbl %al,%edx
  8c41ab:	be 23 00 00 00       	mov    $0x23,%esi
  8c41b0:	48 89 df             	mov    %rbx,%rdi
  8c41b3:	31 c9                	xor    %ecx,%ecx
  8c41b5:	c5 f8 77             	vzeroupper
  8c41b8:	e8 d3 c9 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c41bd:	eb ae                	jmp    8c416d <check_lower_drain+0x9dd>
  8c41bf:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c41c3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c41ca:	75 a1                	jne    8c416d <check_lower_drain+0x9dd>
  8c41cc:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c41d3:	00 00 00 
  8c41d6:	eb 29                	jmp    8c4201 <check_lower_drain+0xa71>
  8c41d8:	48 8d 0d 64 52 dc ff 	lea    -0x23ad9c(%rip),%rcx        # 689443 <fuzz_comment_end+0x26c80>
  8c41df:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c41e6:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c41ea:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c41f1:	0f 85 76 ff ff ff    	jne    8c416d <check_lower_drain+0x9dd>
  8c41f7:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c41fe:	00 00 00 
  8c4201:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4207:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c420b:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4211:	e9 57 ff ff ff       	jmp    8c416d <check_lower_drain+0x9dd>
  8c4216:	49 8b 55 00          	mov    0x0(%r13),%rdx
  8c421a:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c4221:	0f 85 46 ff ff ff    	jne    8c416d <check_lower_drain+0x9dd>
  8c4227:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c422b:	c6 04 0a 23          	movb   $0x23,(%rdx,%rcx,1)
  8c422f:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c4233:	88 04 0a             	mov    %al,(%rdx,%rcx,1)
  8c4236:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c423a:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c4241:	00 
  8c4242:	ff c1                	inc    %ecx
  8c4244:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c424a:	e9 1e ff ff ff       	jmp    8c416d <check_lower_drain+0x9dd>
  8c424f:	b8 03 06 00 00       	mov    $0x603,%eax
  8c4254:	48 c7 84 24 c0 00 00 	movq   $0x0,0xc0(%rsp)
  8c425b:	00 00 00 00 00 
  8c4260:	48 8d 94 24 d2 00 00 	lea    0xd2(%rsp),%rdx
  8c4267:	00 
  8c4268:	48 89 df             	mov    %rbx,%rdi
  8c426b:	c4 c2 78 f7 c6       	bextr  %eax,%r14d,%eax
  8c4270:	41 83 e6 07          	and    $0x7,%r14d
  8c4274:	41 8d 74 06 08       	lea    0x8(%r14,%rax,1),%esi
  8c4279:	8d 48 01             	lea    0x1(%rax),%ecx
  8c427c:	44 89 b4 24 c8 00 00 	mov    %r14d,0xc8(%rsp)
  8c4283:	00 
  8c4284:	89 8c 24 cc 00 00 00 	mov    %ecx,0xcc(%rsp)
  8c428b:	44 89 e1             	mov    %r12d,%ecx
  8c428e:	c1 e9 09             	shr    $0x9,%ecx
  8c4291:	41 c1 ec 0d          	shr    $0xd,%r12d
  8c4295:	80 e1 0f             	and    $0xf,%cl
  8c4298:	c1 ee 03             	shr    $0x3,%esi
  8c429b:	41 80 e4 01          	and    $0x1,%r12b
  8c429f:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
  8c42a6:	44 88 a4 24 d1 00 00 	mov    %r12b,0xd1(%rsp)
  8c42ad:	00 
  8c42ae:	66 c7 42 04 00 00    	movw   $0x0,0x4(%rdx)
  8c42b4:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
  8c42ba:	c5 f8 77             	vzeroupper
  8c42bd:	e8 ee 32 01 00       	call   8d75b0 <check_lower_bit_unit>
  8c42c2:	48 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%rsi
  8c42c9:	00 
  8c42ca:	48 89 df             	mov    %rbx,%rdi
  8c42cd:	44 89 f2             	mov    %r14d,%edx
  8c42d0:	e8 bb 39 01 00       	call   8d7c90 <check_lower_bit_extract>
  8c42d5:	e9 ca f5 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c42da:	48 89 df             	mov    %rbx,%rdi
  8c42dd:	89 ee                	mov    %ebp,%esi
  8c42df:	4c 89 e2             	mov    %r12,%rdx
  8c42e2:	c5 f8 77             	vzeroupper
  8c42e5:	e8 f6 a2 00 00       	call   8ce5e0 <check_lower_address>
  8c42ea:	e9 b5 f5 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c42ef:	48 8b 03             	mov    (%rbx),%rax
  8c42f2:	89 e9                	mov    %ebp,%ecx
  8c42f4:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c42f8:	44 89 e2             	mov    %r12d,%edx
  8c42fb:	48 69 f2 b0 00 00 00 	imul   $0xb0,%rdx,%rsi
  8c4302:	49 c1 ec 20          	shr    $0x20,%r12
  8c4306:	48 89 df             	mov    %rbx,%rdi
  8c4309:	48 c1 e1 04          	shl    $0x4,%rcx
  8c430d:	48 8b 40 28          	mov    0x28(%rax),%rax
  8c4311:	48 8b 00             	mov    (%rax),%rax
  8c4314:	48 03 74 08 10       	add    0x10(%rax,%rcx,1),%rsi
  8c4319:	eb 44                	jmp    8c435f <check_lower_drain+0xbcf>
  8c431b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c431f:	62 f1 fe 48 7f 44 24 	vmovdqu64 %zmm0,0xc0(%rsp)
  8c4326:	03 
  8c4327:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x130(%rsp)
  8c432e:	30 01 00 00 
  8c4332:	44 89 e0             	mov    %r12d,%eax
  8c4335:	62 f1 fe 48 7f 44 24 	vmovdqu64 %zmm0,0x100(%rsp)
  8c433c:	04 
  8c433d:	c7 84 24 c0 00 00 00 	movl   $0x2,0xc0(%rsp)
  8c4344:	02 00 00 00 
  8c4348:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  8c434f:	00 
  8c4350:	49 c1 ec 20          	shr    $0x20,%r12
  8c4354:	48 89 df             	mov    %rbx,%rdi
  8c4357:	48 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%rsi
  8c435e:	00 
  8c435f:	44 89 e2             	mov    %r12d,%edx
  8c4362:	c5 f8 77             	vzeroupper
  8c4365:	e8 a6 ab 00 00       	call   8cef10 <check_lower_fill>
  8c436a:	e9 35 f5 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c436f:	ba 07 00 00 00       	mov    $0x7,%edx
  8c4374:	48 89 df             	mov    %rbx,%rdi
  8c4377:	44 89 f6             	mov    %r14d,%esi
  8c437a:	c5 f8 77             	vzeroupper
  8c437d:	e8 4e 8c 00 00       	call   8ccfd0 <check_lower_vla_size>
  8c4382:	e9 1d f5 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c4387:	b9 03 06 00 00       	mov    $0x603,%ecx
  8c438c:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  8c4393:	44 89 e2             	mov    %r12d,%edx
  8c4396:	c1 ea 0d             	shr    $0xd,%edx
  8c4399:	48 8d b4 24 d2 00 00 	lea    0xd2(%rsp),%rsi
  8c43a0:	00 
  8c43a1:	48 c7 84 24 c0 00 00 	movq   $0x0,0xc0(%rsp)
  8c43a8:	00 00 00 00 00 
  8c43ad:	c4 c2 70 f7 fe       	bextr  %ecx,%r14d,%edi
  8c43b2:	44 89 e1             	mov    %r12d,%ecx
  8c43b5:	c1 e9 09             	shr    $0x9,%ecx
  8c43b8:	41 83 e6 07          	and    $0x7,%r14d
  8c43bc:	80 e2 01             	and    $0x1,%dl
  8c43bf:	44 8d 6f 01          	lea    0x1(%rdi),%r13d
  8c43c3:	80 e1 0f             	and    $0xf,%cl
  8c43c6:	44 89 b4 24 c8 00 00 	mov    %r14d,0xc8(%rsp)
  8c43cd:	00 
  8c43ce:	c4 42 91 f7 f8       	shlx   %r13,%r8,%r15
  8c43d3:	41 83 fd 40          	cmp    $0x40,%r13d
  8c43d7:	44 89 ac 24 cc 00 00 	mov    %r13d,0xcc(%rsp)
  8c43de:	00 
  8c43df:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
  8c43e6:	88 94 24 d1 00 00 00 	mov    %dl,0xd1(%rsp)
  8c43ed:	66 c7 46 04 00 00    	movw   $0x0,0x4(%rsi)
  8c43f3:	c7 06 00 00 00 00    	movl   $0x0,(%rsi)
  8c43f9:	49 f7 d7             	not    %r15
  8c43fc:	4c 89 fe             	mov    %r15,%rsi
  8c43ff:	49 0f 44 f0          	cmove  %r8,%rsi
  8c4403:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
  8c4408:	8b b3 48 01 00 00    	mov    0x148(%rbx),%esi
  8c440e:	48 81 fe ff ff 00 00 	cmp    $0xffff,%rsi
  8c4415:	0f 87 a5 02 00 00    	ja     8c46c0 <check_lower_drain+0xf30>
  8c441b:	3b b3 4c 01 00 00    	cmp    0x14c(%rbx),%esi
  8c4421:	0f 83 99 02 00 00    	jae    8c46c0 <check_lower_drain+0xf30>
  8c4427:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8c442e:	c6 04 30 08          	movb   $0x8,(%rax,%rsi,1)
  8c4432:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
  8c4439:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c443d:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
  8c4444:	c7 04 b0 00 00 00 00 	movl   $0x0,(%rax,%rsi,4)
  8c444b:	48 8b 83 e0 00 00 00 	mov    0xe0(%rbx),%rax
  8c4452:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c4456:	48 8b 83 b0 00 00 00 	mov    0xb0(%rbx),%rax
  8c445d:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c4461:	ff 83 48 01 00 00    	incl   0x148(%rbx)
  8c4467:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c446b:	48 8b 00             	mov    (%rax),%rax
  8c446e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4475:	0f 85 66 02 00 00    	jne    8c46e1 <check_lower_drain+0xf51>
  8c447b:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  8c4482:	c6 04 30 08          	movb   $0x8,(%rax,%rsi,1)
  8c4486:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c448b:	80 f9 08             	cmp    $0x8,%cl
  8c448e:	0f 84 2d 0d 00 00    	je     8c51c1 <check_lower_drain+0x1a31>
  8c4494:	e9 56 02 00 00       	jmp    8c46ef <check_lower_drain+0xf5f>
  8c4499:	41 83 ff 14          	cmp    $0x14,%r15d
  8c449d:	0f 82 a2 02 00 00    	jb     8c4745 <check_lower_drain+0xfb5>
  8c44a3:	0f 85 56 07 00 00    	jne    8c4bff <check_lower_drain+0x146f>
  8c44a9:	c7 84 24 a0 00 00 00 	movl   $0x14,0xa0(%rsp)
  8c44b0:	14 00 00 00 
  8c44b4:	89 ac 24 a4 00 00 00 	mov    %ebp,0xa4(%rsp)
  8c44bb:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  8c44c2:	00 00 00 00 00 
  8c44c7:	e9 59 07 00 00       	jmp    8c4c25 <check_lower_drain+0x1495>
  8c44cc:	45 38 e7             	cmp    %r12b,%r15b
  8c44cf:	0f 84 cf f3 ff ff    	je     8c38a4 <check_lower_drain+0x114>
  8c44d5:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c44db:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c44e2:	0f 87 3f 0c 00 00    	ja     8c5127 <check_lower_drain+0x1997>
  8c44e8:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c44ee:	0f 83 33 0c 00 00    	jae    8c5127 <check_lower_drain+0x1997>
  8c44f4:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c44fb:	0f 85 e6 1d 00 00    	jne    8c62e7 <check_lower_drain+0x2b57>
  8c4501:	41 0f b6 d4          	movzbl %r12b,%edx
  8c4505:	48 89 df             	mov    %rbx,%rdi
  8c4508:	be 09 00 00 00       	mov    $0x9,%esi
  8c450d:	e9 02 0c 00 00       	jmp    8c5114 <check_lower_drain+0x1984>
  8c4512:	31 c9                	xor    %ecx,%ecx
  8c4514:	41 80 ff 0c          	cmp    $0xc,%r15b
  8c4518:	bf 98 00 00 00       	mov    $0x98,%edi
  8c451d:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4523:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  8c4529:	41 89 c6             	mov    %eax,%r14d
  8c452c:	0f 95 c1             	setne  %cl
  8c452f:	31 d2                	xor    %edx,%edx
  8c4531:	41 80 fc 0a          	cmp    $0xa,%r12b
  8c4535:	0f 95 c2             	setne  %dl
  8c4538:	41 80 fc 09          	cmp    $0x9,%r12b
  8c453c:	8d 0c 49             	lea    (%rcx,%rcx,2),%ecx
  8c453f:	8d 72 01             	lea    0x1(%rdx),%esi
  8c4542:	8d 14 d5 a0 00 00 00 	lea    0xa0(,%rdx,8),%edx
  8c4549:	0f 44 d7             	cmove  %edi,%edx
  8c454c:	bf 00 00 00 00       	mov    $0x0,%edi
  8c4551:	0f 44 f7             	cmove  %edi,%esi
  8c4554:	48 89 df             	mov    %rbx,%rdi
  8c4557:	8d 74 0e 05          	lea    0x5(%rsi,%rcx,1),%esi
  8c455b:	48 8d 8c 24 c0 00 00 	lea    0xc0(%rsp),%rcx
  8c4562:	00 
  8c4563:	e8 48 04 01 00       	call   8d49b0 <check_lower_runtime_call>
  8c4568:	89 c1                	mov    %eax,%ecx
  8c456a:	44 89 f0             	mov    %r14d,%eax
  8c456d:	41 89 c8             	mov    %ecx,%r8d
  8c4570:	41 89 c6             	mov    %eax,%r14d
  8c4573:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4579:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c457f:	77 32                	ja     8c45b3 <check_lower_drain+0xe23>
  8c4581:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4587:	73 2a                	jae    8c45b3 <check_lower_drain+0xe23>
  8c4589:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4590:	0f 85 52 03 00 00    	jne    8c48e8 <check_lower_drain+0x1158>
  8c4596:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c459b:	48 89 df             	mov    %rbx,%rdi
  8c459e:	89 ea                	mov    %ebp,%edx
  8c45a0:	4c 89 f1             	mov    %r14,%rcx
  8c45a3:	4d 89 c7             	mov    %r8,%r15
  8c45a6:	e8 e5 c5 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c45ab:	4d 89 f8             	mov    %r15,%r8
  8c45ae:	e9 62 03 00 00       	jmp    8c4915 <check_lower_drain+0x1185>
  8c45b3:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c45b7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c45be:	0f 85 51 03 00 00    	jne    8c4915 <check_lower_drain+0x1185>
  8c45c4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c45cb:	00 00 00 
  8c45ce:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c45d4:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c45d8:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c45de:	e9 32 03 00 00       	jmp    8c4915 <check_lower_drain+0x1185>
  8c45e3:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c45e7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c45ee:	75 1a                	jne    8c460a <check_lower_drain+0xe7a>
  8c45f0:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c45f7:	00 00 00 
  8c45fa:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4600:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c4604:	89 82 f4 00 00 00    	mov    %eax,0xf4(%rdx)
  8c460a:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4610:	48 8b 53 48          	mov    0x48(%rbx),%rdx
  8c4614:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  8c4617:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c461e:	75 3d                	jne    8c465d <check_lower_drain+0xecd>
  8c4620:	48 8b 53 50          	mov    0x50(%rbx),%rdx
  8c4624:	80 bb 7c 01 00 00 00 	cmpb   $0x0,0x17c(%rbx)
  8c462b:	75 14                	jne    8c4641 <check_lower_drain+0xeb1>
  8c462d:	8b 34 8a             	mov    (%rdx,%rcx,4),%esi
  8c4630:	bf 00 00 00 00       	mov    $0x0,%edi
  8c4635:	83 fe ff             	cmp    $0xffffffff,%esi
  8c4638:	0f 44 f7             	cmove  %edi,%esi
  8c463b:	89 b3 74 01 00 00    	mov    %esi,0x174(%rbx)
  8c4641:	83 3c 8a ff          	cmpl   $0xffffffff,(%rdx,%rcx,4)
  8c4645:	75 0f                	jne    8c4656 <check_lower_drain+0xec6>
  8c4647:	8b 83 74 01 00 00    	mov    0x174(%rbx),%eax
  8c464d:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  8c4650:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4656:	c6 83 7c 01 00 00 01 	movb   $0x1,0x17c(%rbx)
  8c465d:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  8c4662:	77 2c                	ja     8c4690 <check_lower_drain+0xf00>
  8c4664:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c466a:	73 24                	jae    8c4690 <check_lower_drain+0xf00>
  8c466c:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4673:	0f 85 9a 04 00 00    	jne    8c4b13 <check_lower_drain+0x1383>
  8c4679:	be 26 00 00 00       	mov    $0x26,%esi
  8c467e:	48 89 df             	mov    %rbx,%rdi
  8c4681:	31 d2                	xor    %edx,%edx
  8c4683:	c5 f8 77             	vzeroupper
  8c4686:	e8 05 c5 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c468b:	e9 fb 04 00 00       	jmp    8c4b8b <check_lower_drain+0x13fb>
  8c4690:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4694:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c469b:	0f 85 ea 04 00 00    	jne    8c4b8b <check_lower_drain+0x13fb>
  8c46a1:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c46a8:	00 00 00 
  8c46ab:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c46b1:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c46b5:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c46bb:	e9 cb 04 00 00       	jmp    8c4b8b <check_lower_drain+0x13fb>
  8c46c0:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c46c7:	0f 84 27 06 00 00    	je     8c4cf4 <check_lower_drain+0x1564>
  8c46cd:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c46d1:	48 8b 00             	mov    (%rax),%rax
  8c46d4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c46db:	0f 84 9a fd ff ff    	je     8c447b <check_lower_drain+0xceb>
  8c46e1:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c46e6:	80 f9 08             	cmp    $0x8,%cl
  8c46e9:	0f 84 d2 0a 00 00    	je     8c51c1 <check_lower_drain+0x1a31>
  8c46ef:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c46f5:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c46fb:	0f 87 cb 04 00 00    	ja     8c4bcc <check_lower_drain+0x143c>
  8c4701:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4707:	0f 83 bf 04 00 00    	jae    8c4bcc <check_lower_drain+0x143c>
  8c470d:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4714:	0f 85 73 0a 00 00    	jne    8c518d <check_lower_drain+0x19fd>
  8c471a:	be 09 00 00 00       	mov    $0x9,%esi
  8c471f:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4724:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8c4729:	48 89 df             	mov    %rbx,%rdi
  8c472c:	31 c9                	xor    %ecx,%ecx
  8c472e:	c5 f8 77             	vzeroupper
  8c4731:	e8 5a c4 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c4736:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c473b:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c4740:	e9 7c 0a 00 00       	jmp    8c51c1 <check_lower_drain+0x1a31>
  8c4745:	80 bb f8 01 00 00 00 	cmpb   $0x0,0x1f8(%rbx)
  8c474c:	75 0d                	jne    8c475b <check_lower_drain+0xfcb>
  8c474e:	80 bb f9 01 00 00 00 	cmpb   $0x0,0x1f9(%rbx)
  8c4755:	0f 84 08 18 00 00    	je     8c5f63 <check_lower_drain+0x27d3>
  8c475b:	48 ff 83 40 05 00 00 	incq   0x540(%rbx)
  8c4762:	41 83 ff 0d          	cmp    $0xd,%r15d
  8c4766:	77 0d                	ja     8c4775 <check_lower_drain+0xfe5>
  8c4768:	b8 02 24 00 00       	mov    $0x2402,%eax
  8c476d:	31 c9                	xor    %ecx,%ecx
  8c476f:	44 0f a3 f8          	bt     %r15d,%eax
  8c4773:	72 07                	jb     8c477c <check_lower_drain+0xfec>
  8c4775:	44 89 e1             	mov    %r12d,%ecx
  8c4778:	49 c1 ec 20          	shr    $0x20,%r12
  8c477c:	48 89 e8             	mov    %rbp,%rax
  8c477f:	48 c1 e8 28          	shr    $0x28,%rax
  8c4783:	48 89 ef             	mov    %rbp,%rdi
  8c4786:	48 89 ea             	mov    %rbp,%rdx
  8c4789:	48 c1 ef 29          	shr    $0x29,%rdi
  8c478d:	48 c1 ea 2a          	shr    $0x2a,%rdx
  8c4791:	4c 8d 8c 24 8b 01 00 	lea    0x18b(%rsp),%r9
  8c4798:	00 
  8c4799:	89 c6                	mov    %eax,%esi
  8c479b:	41 89 f8             	mov    %edi,%r8d
  8c479e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8c47a3:	89 d0                	mov    %edx,%eax
  8c47a5:	41 c6 41 04 00       	movb   $0x0,0x4(%r9)
  8c47aa:	41 c7 01 00 00 00 00 	movl   $0x0,(%r9)
  8c47b1:	44 89 bc 24 70 01 00 	mov    %r15d,0x170(%rsp)
  8c47b8:	00 
  8c47b9:	89 ac 24 74 01 00 00 	mov    %ebp,0x174(%rsp)
  8c47c0:	89 8c 24 78 01 00 00 	mov    %ecx,0x178(%rsp)
  8c47c7:	c7 84 24 7c 01 00 00 	movl   $0x0,0x17c(%rsp)
  8c47ce:	00 00 00 00 
  8c47d2:	4c 89 a4 24 80 01 00 	mov    %r12,0x180(%rsp)
  8c47d9:	00 
  8c47da:	41 89 ef             	mov    %ebp,%r15d
  8c47dd:	40 80 e6 01          	and    $0x1,%sil
  8c47e1:	24 01                	and    $0x1,%al
  8c47e3:	41 80 e0 01          	and    $0x1,%r8b
  8c47e7:	40 88 b4 24 88 01 00 	mov    %sil,0x188(%rsp)
  8c47ee:	00 
  8c47ef:	44 88 84 24 89 01 00 	mov    %r8b,0x189(%rsp)
  8c47f6:	00 
  8c47f7:	88 84 24 8a 01 00 00 	mov    %al,0x18a(%rsp)
  8c47fe:	88 44 24 78          	mov    %al,0x78(%rsp)
  8c4802:	4f 8d 04 7f          	lea    (%r15,%r15,2),%r8
  8c4806:	48 8b 03             	mov    (%rbx),%rax
  8c4809:	49 c1 e0 05          	shl    $0x5,%r8
  8c480d:	4c 8b 10             	mov    (%rax),%r10
  8c4810:	4c 8b 70 08          	mov    0x8(%rax),%r14
  8c4814:	4d 8b 4a 10          	mov    0x10(%r10),%r9
  8c4818:	49 8b 0a             	mov    (%r10),%rcx
  8c481b:	4d 8b 66 08          	mov    0x8(%r14),%r12
  8c481f:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  8c4824:	47 8b 0c b9          	mov    (%r9,%r15,4),%r9d
  8c4828:	46 8b 1c b9          	mov    (%rcx,%r15,4),%r11d
  8c482c:	49 8b 4e 10          	mov    0x10(%r14),%rcx
  8c4830:	4c 89 4c 24 38       	mov    %r9,0x38(%rsp)
  8c4835:	4d 89 f9             	mov    %r15,%r9
  8c4838:	49 c1 e1 05          	shl    $0x5,%r9
  8c483c:	46 8b 2c 09          	mov    (%rcx,%r9,1),%r13d
  8c4840:	42 8b 4c 09 08       	mov    0x8(%rcx,%r9,1),%ecx
  8c4845:	4c 8b 48 10          	mov    0x10(%rax),%r9
  8c4849:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  8c4850:	00 
  8c4851:	49 8b 4a 18          	mov    0x18(%r10),%rcx
  8c4855:	44 8b 93 b0 01 00 00 	mov    0x1b0(%rbx),%r10d
  8c485c:	4c 89 6c 24 48       	mov    %r13,0x48(%rsp)
  8c4861:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
  8c4866:	42 8b 0c b9          	mov    (%rcx,%r15,4),%ecx
  8c486a:	48 89 8c 24 88 00 00 	mov    %rcx,0x88(%rsp)
  8c4871:	00 
  8c4872:	43 8b 0c 04          	mov    (%r12,%r8,1),%ecx
  8c4876:	c1 e9 03             	shr    $0x3,%ecx
  8c4879:	44 39 d1             	cmp    %r10d,%ecx
  8c487c:	0f 83 0b 04 00 00    	jae    8c4c8d <check_lower_drain+0x14fd>
  8c4882:	4c 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%r9
  8c4889:	45 0f b6 0c 09       	movzbl (%r9,%rcx,1),%r9d
  8c488e:	45 89 cd             	mov    %r9d,%r13d
  8c4891:	41 80 e5 04          	and    $0x4,%r13b
  8c4895:	41 c0 ed 02          	shr    $0x2,%r13b
  8c4899:	44 89 6c 24 68       	mov    %r13d,0x68(%rsp)
  8c489e:	41 f6 c1 01          	test   $0x1,%r9b
  8c48a2:	0f 84 f0 17 00 00    	je     8c6098 <check_lower_drain+0x2908>
  8c48a8:	b1 08                	mov    $0x8,%cl
  8c48aa:	41 b5 01             	mov    $0x1,%r13b
  8c48ad:	e9 f5 17 00 00       	jmp    8c60a7 <check_lower_drain+0x2917>
  8c48b2:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c48b9:	0f 85 e5 ef ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c48bf:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c48c3:	c6 04 08 23          	movb   $0x23,(%rax,%rcx,1)
  8c48c7:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c48cb:	44 88 3c 08          	mov    %r15b,(%rax,%rcx,1)
  8c48cf:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c48d3:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c48da:	00 
  8c48db:	ff c1                	inc    %ecx
  8c48dd:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c48e3:	e9 bc ef ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c48e8:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c48ec:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c48f3:	75 20                	jne    8c4915 <check_lower_drain+0x1185>
  8c48f5:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c48f9:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c48fd:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4901:	44 88 3c 01          	mov    %r15b,(%rcx,%rax,1)
  8c4905:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4909:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c490d:	ff c0                	inc    %eax
  8c490f:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4915:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c491b:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4921:	77 2e                	ja     8c4951 <check_lower_drain+0x11c1>
  8c4923:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4929:	73 26                	jae    8c4951 <check_lower_drain+0x11c1>
  8c492b:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4932:	75 46                	jne    8c497a <check_lower_drain+0x11ea>
  8c4934:	be 03 00 00 00       	mov    $0x3,%esi
  8c4939:	ba 08 00 00 00       	mov    $0x8,%edx
  8c493e:	4c 89 f1             	mov    %r14,%rcx
  8c4941:	48 89 df             	mov    %rbx,%rdi
  8c4944:	4d 89 c6             	mov    %r8,%r14
  8c4947:	e8 44 c2 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c494c:	4d 89 f0             	mov    %r14,%r8
  8c494f:	eb 56                	jmp    8c49a7 <check_lower_drain+0x1217>
  8c4951:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4955:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c495c:	75 49                	jne    8c49a7 <check_lower_drain+0x1217>
  8c495e:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4965:	00 00 00 
  8c4968:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c496e:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4972:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4978:	eb 2d                	jmp    8c49a7 <check_lower_drain+0x1217>
  8c497a:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c497e:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4985:	75 20                	jne    8c49a7 <check_lower_drain+0x1217>
  8c4987:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c498b:	c6 04 01 03          	movb   $0x3,(%rcx,%rax,1)
  8c498f:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4993:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c4997:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c499b:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c499f:	ff c0                	inc    %eax
  8c49a1:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c49a7:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c49ad:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c49b3:	77 2a                	ja     8c49df <check_lower_drain+0x124f>
  8c49b5:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c49bb:	73 22                	jae    8c49df <check_lower_drain+0x124f>
  8c49bd:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c49c4:	75 2f                	jne    8c49f5 <check_lower_drain+0x1265>
  8c49c6:	41 0f b6 d4          	movzbl %r12b,%edx
  8c49ca:	be 22 00 00 00       	mov    $0x22,%esi
  8c49cf:	48 89 df             	mov    %rbx,%rdi
  8c49d2:	4c 89 c1             	mov    %r8,%rcx
  8c49d5:	e8 b6 c1 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c49da:	e9 c5 ee ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c49df:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c49e3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c49ea:	0f 85 b4 ee ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c49f0:	e9 3f 07 00 00       	jmp    8c5134 <check_lower_drain+0x19a4>
  8c49f5:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c49f9:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4a00:	0f 85 9e ee ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c4a06:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4a0a:	c6 04 01 22          	movb   $0x22,(%rcx,%rax,1)
  8c4a0e:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4a12:	44 88 24 01          	mov    %r12b,(%rcx,%rax,1)
  8c4a16:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4a1a:	4c 89 04 c1          	mov    %r8,(%rcx,%rax,8)
  8c4a1e:	e9 5d 07 00 00       	jmp    8c5180 <check_lower_drain+0x19f0>
  8c4a23:	be 23 00 00 00       	mov    $0x23,%esi
  8c4a28:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4a2d:	48 89 df             	mov    %rbx,%rdi
  8c4a30:	31 c9                	xor    %ecx,%ecx
  8c4a32:	c5 f8 77             	vzeroupper
  8c4a35:	e8 c6 3d 00 00       	call   8c8800 <check_lower_emit>
  8c4a3a:	48 0f ba e5 28       	bt     $0x28,%rbp
  8c4a3f:	0f 82 5f ee ff ff    	jb     8c38a4 <check_lower_drain+0x114>
  8c4a45:	be 23 00 00 00       	mov    $0x23,%esi
  8c4a4a:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4a4f:	48 89 df             	mov    %rbx,%rdi
  8c4a52:	31 c9                	xor    %ecx,%ecx
  8c4a54:	e8 a7 3d 00 00       	call   8c8800 <check_lower_emit>
  8c4a59:	e9 46 ee ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c4a5e:	31 c0                	xor    %eax,%eax
  8c4a60:	41 80 fc 0c          	cmp    $0xc,%r12b
  8c4a64:	be 00 00 00 00       	mov    $0x0,%esi
  8c4a69:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4a6f:	48 89 df             	mov    %rbx,%rdi
  8c4a72:	45 89 f1             	mov    %r14d,%r9d
  8c4a75:	0f 95 c0             	setne  %al
  8c4a78:	31 c9                	xor    %ecx,%ecx
  8c4a7a:	41 80 ff 0a          	cmp    $0xa,%r15b
  8c4a7e:	0f 95 c1             	setne  %cl
  8c4a81:	8d 14 c5 70 00 00 00 	lea    0x70(,%rax,8),%edx
  8c4a88:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c4a8b:	ff c1                	inc    %ecx
  8c4a8d:	41 80 ff 09          	cmp    $0x9,%r15b
  8c4a91:	0f 44 ce             	cmove  %esi,%ecx
  8c4a94:	8d 74 01 0b          	lea    0xb(%rcx,%rax,1),%esi
  8c4a98:	48 8d 8c 24 c0 00 00 	lea    0xc0(%rsp),%rcx
  8c4a9f:	00 
  8c4aa0:	e8 0b ff 00 00       	call   8d49b0 <check_lower_runtime_call>
  8c4aa5:	89 c1                	mov    %eax,%ecx
  8c4aa7:	be 22 00 00 00       	mov    $0x22,%esi
  8c4aac:	48 89 df             	mov    %rbx,%rdi
  8c4aaf:	31 d2                	xor    %edx,%edx
  8c4ab1:	e8 4a 3d 00 00       	call   8c8800 <check_lower_emit>
  8c4ab6:	be 02 00 00 00       	mov    $0x2,%esi
  8c4abb:	44 89 f1             	mov    %r14d,%ecx
  8c4abe:	48 89 df             	mov    %rbx,%rdi
  8c4ac1:	89 ea                	mov    %ebp,%edx
  8c4ac3:	e8 38 3d 00 00       	call   8c8800 <check_lower_emit>
  8c4ac8:	e9 d7 ed ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c4acd:	be 29 00 00 00       	mov    $0x29,%esi
  8c4ad2:	31 d2                	xor    %edx,%edx
  8c4ad4:	4c 89 e1             	mov    %r12,%rcx
  8c4ad7:	c5 f8 77             	vzeroupper
  8c4ada:	e8 21 3d 00 00       	call   8c8800 <check_lower_emit>
  8c4adf:	e9 c0 ed ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c4ae4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4aeb:	41 b7 05             	mov    $0x5,%r15b
  8c4aee:	0f 85 d1 04 00 00    	jne    8c4fc5 <check_lower_drain+0x1835>
  8c4af4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4afb:	00 00 00 
  8c4afe:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4b04:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4b08:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4b0e:	e9 b2 04 00 00       	jmp    8c4fc5 <check_lower_drain+0x1835>
  8c4b13:	49 8b 55 00          	mov    0x0(%r13),%rdx
  8c4b17:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c4b1e:	75 6b                	jne    8c4b8b <check_lower_drain+0x13fb>
  8c4b20:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c4b24:	89 c6                	mov    %eax,%esi
  8c4b26:	ff c0                	inc    %eax
  8c4b28:	c6 04 32 26          	movb   $0x26,(%rdx,%rsi,1)
  8c4b2c:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c4b30:	c6 04 32 00          	movb   $0x0,(%rdx,%rsi,1)
  8c4b34:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c4b38:	48 89 0c f2          	mov    %rcx,(%rdx,%rsi,8)
  8c4b3c:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4b42:	eb 47                	jmp    8c4b8b <check_lower_drain+0x13fb>
  8c4b44:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c4b4b:	00 00 00 00 00 
  8c4b50:	48 8b 73 60          	mov    0x60(%rbx),%rsi
  8c4b54:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c4b58:	8d 79 01             	lea    0x1(%rcx),%edi
  8c4b5b:	48 c1 e1 04          	shl    $0x4,%rcx
  8c4b5f:	0f b6 34 06          	movzbl (%rsi,%rax,1),%esi
  8c4b63:	89 bb 3c 01 00 00    	mov    %edi,0x13c(%rbx)
  8c4b69:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8c4b6e:	48 c1 e6 30          	shl    $0x30,%rsi
  8c4b72:	48 8d 74 37 02       	lea    0x2(%rdi,%rsi,1),%rsi
  8c4b77:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c4b7b:	48 c7 44 0a 08 00 00 	movq   $0x0,0x8(%rdx,%rcx,1)
  8c4b82:	00 00 
  8c4b84:	48 8b 4b 58          	mov    0x58(%rbx),%rcx
  8c4b88:	8b 2c 81             	mov    (%rcx,%rax,4),%ebp
  8c4b8b:	85 ed                	test   %ebp,%ebp
  8c4b8d:	0f 84 11 ed ff ff    	je     8c38a4 <check_lower_drain+0x114>
  8c4b93:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c4b99:	89 e8                	mov    %ebp,%eax
  8c4b9b:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4ba1:	72 ad                	jb     8c4b50 <check_lower_drain+0x13c0>
  8c4ba3:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c4ba7:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4bae:	75 d4                	jne    8c4b84 <check_lower_drain+0x13f4>
  8c4bb0:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c4bb7:	00 00 00 
  8c4bba:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c4bc0:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c4bc4:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c4bca:	eb b8                	jmp    8c4b84 <check_lower_drain+0x13f4>
  8c4bcc:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4bd0:	48 8b 00             	mov    (%rax),%rax
  8c4bd3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4bda:	0f 85 e1 05 00 00    	jne    8c51c1 <check_lower_drain+0x1a31>
  8c4be0:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4be7:	00 00 00 
  8c4bea:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4bf0:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4bf4:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4bfa:	e9 c2 05 00 00       	jmp    8c51c1 <check_lower_drain+0x1a31>
  8c4bff:	44 89 bc 24 a0 00 00 	mov    %r15d,0xa0(%rsp)
  8c4c06:	00 
  8c4c07:	89 ac 24 a4 00 00 00 	mov    %ebp,0xa4(%rsp)
  8c4c0e:	44 89 a4 24 a8 00 00 	mov    %r12d,0xa8(%rsp)
  8c4c15:	00 
  8c4c16:	c7 84 24 ac 00 00 00 	movl   $0x0,0xac(%rsp)
  8c4c1d:	00 00 00 00 
  8c4c21:	49 c1 ec 20          	shr    $0x20,%r12
  8c4c25:	48 89 e8             	mov    %rbp,%rax
  8c4c28:	48 c1 e8 28          	shr    $0x28,%rax
  8c4c2c:	4c 89 a4 24 b0 00 00 	mov    %r12,0xb0(%rsp)
  8c4c33:	00 
  8c4c34:	48 8d 8c 24 bb 00 00 	lea    0xbb(%rsp),%rcx
  8c4c3b:	00 
  8c4c3c:	48 89 df             	mov    %rbx,%rdi
  8c4c3f:	24 01                	and    $0x1,%al
  8c4c41:	88 84 24 b8 00 00 00 	mov    %al,0xb8(%rsp)
  8c4c48:	48 89 e8             	mov    %rbp,%rax
  8c4c4b:	48 c1 e8 29          	shr    $0x29,%rax
  8c4c4f:	48 c1 ed 2a          	shr    $0x2a,%rbp
  8c4c53:	24 01                	and    $0x1,%al
  8c4c55:	40 80 e5 01          	and    $0x1,%bpl
  8c4c59:	88 84 24 b9 00 00 00 	mov    %al,0xb9(%rsp)
  8c4c60:	40 88 ac 24 ba 00 00 	mov    %bpl,0xba(%rsp)
  8c4c67:	00 
  8c4c68:	c6 41 04 00          	movb   $0x0,0x4(%rcx)
  8c4c6c:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c4c72:	c5 fe 6f 84 24 a0 00 	vmovdqu 0xa0(%rsp),%ymm0
  8c4c79:	00 00 
  8c4c7b:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c4c80:	c5 f8 77             	vzeroupper
  8c4c83:	e8 b8 b1 00 00       	call   8cfe40 <check_lower_complex_task>
  8c4c88:	e9 17 ec ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c4c8d:	b1 ff                	mov    $0xff,%cl
  8c4c8f:	c7 44 24 68 00 00 00 	movl   $0x0,0x68(%rsp)
  8c4c96:	00 
  8c4c97:	e9 08 14 00 00       	jmp    8c60a4 <check_lower_drain+0x2914>
  8c4c9c:	89 f1                	mov    %esi,%ecx
  8c4c9e:	4c 8d 05 d2 d9 e2 ff 	lea    -0x1d262e(%rip),%r8        # 6f2677 <pp_string_value.meaning+0x3ef32>
  8c4ca5:	80 e1 fe             	and    $0xfe,%cl
  8c4ca8:	80 f9 0c             	cmp    $0xc,%cl
  8c4cab:	74 1d                	je     8c4cca <check_lower_drain+0x153a>
  8c4cad:	4c 8d 05 48 27 e2 ff 	lea    -0x1dd8b8(%rip),%r8        # 6e73fc <pp_string_value.meaning+0x33cb7>
  8c4cb4:	40 80 fe 0e          	cmp    $0xe,%sil
  8c4cb8:	74 10                	je     8c4cca <check_lower_drain+0x153a>
  8c4cba:	4c 8d 05 07 6e d2 ff 	lea    -0x2d91f9(%rip),%r8        # 5ebac8 <parse_test_openers+0x1f9b3>
  8c4cc1:	80 f9 10             	cmp    $0x10,%cl
  8c4cc4:	0f 85 89 17 00 00    	jne    8c6453 <check_lower_drain+0x2cc3>
  8c4cca:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4cd1:	0f 85 cd eb ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c4cd7:	4c 89 80 00 01 00 00 	mov    %r8,0x100(%rax)
  8c4cde:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4ce2:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4ce9:	0f 85 b5 eb ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c4cef:	e9 38 ec ff ff       	jmp    8c392c <check_lower_drain+0x19c>
  8c4cf4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4cfb:	00 00 00 
  8c4cfe:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4d04:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c4d08:	89 82 f4 00 00 00    	mov    %eax,0xf4(%rdx)
  8c4d0e:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4d12:	48 8b 00             	mov    (%rax),%rax
  8c4d15:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4d1c:	0f 85 bf f9 ff ff    	jne    8c46e1 <check_lower_drain+0xf51>
  8c4d22:	e9 54 f7 ff ff       	jmp    8c447b <check_lower_drain+0xceb>
  8c4d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c4d2c:	44 89 f1             	mov    %r14d,%ecx
  8c4d2f:	48 89 df             	mov    %rbx,%rdi
  8c4d32:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c4d37:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4d3c:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8c4d41:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8c4d46:	e8 b5 3a 00 00       	call   8c8800 <check_lower_emit>
  8c4d4b:	4d 89 e5             	mov    %r12,%r13
  8c4d4e:	45 31 f6             	xor    %r14d,%r14d
  8c4d51:	eb 29                	jmp    8c4d7c <check_lower_drain+0x15ec>
  8c4d53:	be 29 00 00 00       	mov    $0x29,%esi
  8c4d58:	48 89 df             	mov    %rbx,%rdi
  8c4d5b:	31 d2                	xor    %edx,%edx
  8c4d5d:	4c 89 f9             	mov    %r15,%rcx
  8c4d60:	e8 2b be 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c4d65:	49 81 c6 00 01 00 00 	add    $0x100,%r14
  8c4d6c:	49 81 c5 00 ff ff ff 	add    $0xffffffffffffff00,%r13
  8c4d73:	4d 39 e6             	cmp    %r12,%r14
  8c4d76:	0f 83 ee 01 00 00    	jae    8c4f6a <check_lower_drain+0x17da>
  8c4d7c:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4d80:	49 81 fd 00 01 00 00 	cmp    $0x100,%r13
  8c4d87:	b9 00 01 00 00       	mov    $0x100,%ecx
  8c4d8c:	48 8b 00             	mov    (%rax),%rax
  8c4d8f:	49 0f 42 cd          	cmovb  %r13,%rcx
  8c4d93:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4d9a:	0f 85 ca 01 00 00    	jne    8c4f6a <check_lower_drain+0x17da>
  8c4da0:	49 81 fd 00 01 00 00 	cmp    $0x100,%r13
  8c4da7:	41 bf 00 01 00 00    	mov    $0x100,%r15d
  8c4dad:	4d 0f 42 fd          	cmovb  %r13,%r15
  8c4db1:	4c 39 e9             	cmp    %r13,%rcx
  8c4db4:	74 76                	je     8c4e2c <check_lower_drain+0x169c>
  8c4db6:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c4dbc:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4dc3:	77 27                	ja     8c4dec <check_lower_drain+0x165c>
  8c4dc5:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4dcb:	73 1f                	jae    8c4dec <check_lower_drain+0x165c>
  8c4dcd:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4dd4:	75 32                	jne    8c4e08 <check_lower_drain+0x1678>
  8c4dd6:	be 06 00 00 00       	mov    $0x6,%esi
  8c4ddb:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4de0:	48 89 df             	mov    %rbx,%rdi
  8c4de3:	31 c9                	xor    %ecx,%ecx
  8c4de5:	e8 a6 bd 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c4dea:	eb 40                	jmp    8c4e2c <check_lower_drain+0x169c>
  8c4dec:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4df3:	00 00 00 
  8c4df6:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4dfc:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4e00:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4e06:	eb 24                	jmp    8c4e2c <check_lower_drain+0x169c>
  8c4e08:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c4e0c:	c6 04 08 06          	movb   $0x6,(%rax,%rcx,1)
  8c4e10:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c4e14:	c6 04 08 08          	movb   $0x8,(%rax,%rcx,1)
  8c4e18:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c4e1c:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c4e23:	00 
  8c4e24:	ff c1                	inc    %ecx
  8c4e26:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c4e2c:	48 89 df             	mov    %rbx,%rdi
  8c4e2f:	4c 89 f6             	mov    %r14,%rsi
  8c4e32:	e8 29 9b 00 00       	call   8ce960 <check_lower_offset>
  8c4e37:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4e3d:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4e43:	77 2a                	ja     8c4e6f <check_lower_drain+0x16df>
  8c4e45:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4e4b:	73 22                	jae    8c4e6f <check_lower_drain+0x16df>
  8c4e4d:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4e54:	75 45                	jne    8c4e9b <check_lower_drain+0x170b>
  8c4e56:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c4e5b:	be 02 00 00 00       	mov    $0x2,%esi
  8c4e60:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4e65:	48 89 df             	mov    %rbx,%rdi
  8c4e68:	e8 23 bd 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c4e6d:	eb 61                	jmp    8c4ed0 <check_lower_drain+0x1740>
  8c4e6f:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4e73:	48 8b 00             	mov    (%rax),%rax
  8c4e76:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4e7d:	75 51                	jne    8c4ed0 <check_lower_drain+0x1740>
  8c4e7f:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4e86:	00 00 00 
  8c4e89:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4e8f:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4e93:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4e99:	eb 35                	jmp    8c4ed0 <check_lower_drain+0x1740>
  8c4e9b:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c4e9f:	48 8b 09             	mov    (%rcx),%rcx
  8c4ea2:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4ea9:	75 25                	jne    8c4ed0 <check_lower_drain+0x1740>
  8c4eab:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4eaf:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c4eb4:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c4eb8:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4ebc:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c4ec0:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4ec4:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c4ec8:	ff c0                	inc    %eax
  8c4eca:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4ed0:	48 89 df             	mov    %rbx,%rdi
  8c4ed3:	4c 89 f6             	mov    %r14,%rsi
  8c4ed6:	e8 85 9a 00 00       	call   8ce960 <check_lower_offset>
  8c4edb:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4ee1:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4ee7:	77 4e                	ja     8c4f37 <check_lower_drain+0x17a7>
  8c4ee9:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4eef:	73 46                	jae    8c4f37 <check_lower_drain+0x17a7>
  8c4ef1:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4ef8:	0f 84 55 fe ff ff    	je     8c4d53 <check_lower_drain+0x15c3>
  8c4efe:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c4f02:	48 8b 09             	mov    (%rcx),%rcx
  8c4f05:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4f0c:	0f 85 53 fe ff ff    	jne    8c4d65 <check_lower_drain+0x15d5>
  8c4f12:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4f16:	c6 04 01 29          	movb   $0x29,(%rcx,%rax,1)
  8c4f1a:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4f1e:	c6 04 01 00          	movb   $0x0,(%rcx,%rax,1)
  8c4f22:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4f26:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c4f2a:	ff c0                	inc    %eax
  8c4f2c:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4f32:	e9 2e fe ff ff       	jmp    8c4d65 <check_lower_drain+0x15d5>
  8c4f37:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4f3b:	48 8b 00             	mov    (%rax),%rax
  8c4f3e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4f45:	0f 85 1a fe ff ff    	jne    8c4d65 <check_lower_drain+0x15d5>
  8c4f4b:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4f52:	00 00 00 
  8c4f55:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4f5b:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4f5f:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4f65:	e9 fb fd ff ff       	jmp    8c4d65 <check_lower_drain+0x15d5>
  8c4f6a:	48 0f ba e5 28       	bt     $0x28,%rbp
  8c4f6f:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c4f73:	0f 83 2b e9 ff ff    	jae    8c38a4 <check_lower_drain+0x114>
  8c4f79:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c4f7e:	be 02 00 00 00       	mov    $0x2,%esi
  8c4f83:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4f88:	48 89 df             	mov    %rbx,%rdi
  8c4f8b:	e8 70 38 00 00       	call   8c8800 <check_lower_emit>
  8c4f90:	e9 0f e9 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c4f95:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4f9c:	41 b7 05             	mov    $0x5,%r15b
  8c4f9f:	75 24                	jne    8c4fc5 <check_lower_drain+0x1835>
  8c4fa1:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c4fa5:	c6 04 08 09          	movb   $0x9,(%rax,%rcx,1)
  8c4fa9:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c4fad:	c6 04 08 05          	movb   $0x5,(%rax,%rcx,1)
  8c4fb1:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c4fb5:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c4fbc:	00 
  8c4fbd:	ff c1                	inc    %ecx
  8c4fbf:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c4fc5:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4fcb:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4fd1:	77 29                	ja     8c4ffc <check_lower_drain+0x186c>
  8c4fd3:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4fd9:	73 21                	jae    8c4ffc <check_lower_drain+0x186c>
  8c4fdb:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4fe2:	75 41                	jne    8c5025 <check_lower_drain+0x1895>
  8c4fe4:	41 0f b6 d7          	movzbl %r15b,%edx
  8c4fe8:	be 01 00 00 00       	mov    $0x1,%esi
  8c4fed:	48 89 df             	mov    %rbx,%rdi
  8c4ff0:	31 c9                	xor    %ecx,%ecx
  8c4ff2:	c5 f8 77             	vzeroupper
  8c4ff5:	e8 96 bb 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c4ffa:	eb 5a                	jmp    8c5056 <check_lower_drain+0x18c6>
  8c4ffc:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5000:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5007:	75 4d                	jne    8c5056 <check_lower_drain+0x18c6>
  8c5009:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5010:	00 00 00 
  8c5013:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5019:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c501d:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5023:	eb 31                	jmp    8c5056 <check_lower_drain+0x18c6>
  8c5025:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5029:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5030:	75 24                	jne    8c5056 <check_lower_drain+0x18c6>
  8c5032:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5036:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c503a:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c503e:	44 88 3c 01          	mov    %r15b,(%rcx,%rax,1)
  8c5042:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5046:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c504d:	00 
  8c504e:	ff c0                	inc    %eax
  8c5050:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5056:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c505c:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5062:	77 2a                	ja     8c508e <check_lower_drain+0x18fe>
  8c5064:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c506a:	73 22                	jae    8c508e <check_lower_drain+0x18fe>
  8c506c:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5073:	75 42                	jne    8c50b7 <check_lower_drain+0x1927>
  8c5075:	be 17 00 00 00       	mov    $0x17,%esi
  8c507a:	ba 05 00 00 00       	mov    $0x5,%edx
  8c507f:	48 89 df             	mov    %rbx,%rdi
  8c5082:	31 c9                	xor    %ecx,%ecx
  8c5084:	c5 f8 77             	vzeroupper
  8c5087:	e8 04 bb 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c508c:	eb 5a                	jmp    8c50e8 <check_lower_drain+0x1958>
  8c508e:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5092:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5099:	75 4d                	jne    8c50e8 <check_lower_drain+0x1958>
  8c509b:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c50a2:	00 00 00 
  8c50a5:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c50ab:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c50af:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c50b5:	eb 31                	jmp    8c50e8 <check_lower_drain+0x1958>
  8c50b7:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c50bb:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c50c2:	75 24                	jne    8c50e8 <check_lower_drain+0x1958>
  8c50c4:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c50c8:	c6 04 01 17          	movb   $0x17,(%rcx,%rax,1)
  8c50cc:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c50d0:	c6 04 01 05          	movb   $0x5,(%rcx,%rax,1)
  8c50d4:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c50d8:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c50df:	00 
  8c50e0:	ff c0                	inc    %eax
  8c50e2:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c50e8:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c50ee:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c50f4:	77 2d                	ja     8c5123 <check_lower_drain+0x1993>
  8c50f6:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c50fc:	73 25                	jae    8c5123 <check_lower_drain+0x1993>
  8c50fe:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5105:	75 4c                	jne    8c5153 <check_lower_drain+0x19c3>
  8c5107:	48 89 df             	mov    %rbx,%rdi
  8c510a:	be 09 00 00 00       	mov    $0x9,%esi
  8c510f:	ba 02 00 00 00       	mov    $0x2,%edx
  8c5114:	31 c9                	xor    %ecx,%ecx
  8c5116:	c5 f8 77             	vzeroupper
  8c5119:	e8 72 ba 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c511e:	e9 81 e7 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c5123:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5127:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c512e:	0f 85 70 e7 ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c5134:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c513b:	00 00 00 
  8c513e:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5144:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5148:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c514e:	e9 51 e7 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c5153:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5157:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c515e:	0f 85 40 e7 ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c5164:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5168:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c516c:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5170:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5174:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5178:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c517f:	00 
  8c5180:	ff c0                	inc    %eax
  8c5182:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5188:	e9 17 e7 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c518d:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5191:	48 8b 09             	mov    (%rcx),%rcx
  8c5194:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c519b:	75 24                	jne    8c51c1 <check_lower_drain+0x1a31>
  8c519d:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c51a1:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c51a5:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c51a9:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c51ad:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c51b1:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c51b8:	00 
  8c51b9:	ff c0                	inc    %eax
  8c51bb:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c51c1:	41 83 fd 40          	cmp    $0x40,%r13d
  8c51c5:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c51c9:	0f 84 3b 01 00 00    	je     8c530a <check_lower_drain+0x1b7a>
  8c51cf:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c51d5:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c51db:	77 3a                	ja     8c5217 <check_lower_drain+0x1a87>
  8c51dd:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c51e3:	73 32                	jae    8c5217 <check_lower_drain+0x1a87>
  8c51e5:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c51ec:	75 52                	jne    8c5240 <check_lower_drain+0x1ab0>
  8c51ee:	be 01 00 00 00       	mov    $0x1,%esi
  8c51f3:	ba 08 00 00 00       	mov    $0x8,%edx
  8c51f8:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8c51fd:	48 89 df             	mov    %rbx,%rdi
  8c5200:	4c 89 f9             	mov    %r15,%rcx
  8c5203:	c5 f8 77             	vzeroupper
  8c5206:	e8 85 b9 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c520b:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c5210:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c5215:	eb 56                	jmp    8c526d <check_lower_drain+0x1add>
  8c5217:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c521b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5222:	75 49                	jne    8c526d <check_lower_drain+0x1add>
  8c5224:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c522b:	00 00 00 
  8c522e:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5234:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5238:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c523e:	eb 2d                	jmp    8c526d <check_lower_drain+0x1add>
  8c5240:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5244:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c524b:	75 20                	jne    8c526d <check_lower_drain+0x1add>
  8c524d:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5251:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c5255:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5259:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c525d:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5261:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c5265:	ff c0                	inc    %eax
  8c5267:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c526d:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5273:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5279:	77 35                	ja     8c52b0 <check_lower_drain+0x1b20>
  8c527b:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5281:	73 2d                	jae    8c52b0 <check_lower_drain+0x1b20>
  8c5283:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c528a:	75 4d                	jne    8c52d9 <check_lower_drain+0x1b49>
  8c528c:	be 10 00 00 00       	mov    $0x10,%esi
  8c5291:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5296:	49 89 ff             	mov    %rdi,%r15
  8c5299:	48 89 df             	mov    %rbx,%rdi
  8c529c:	31 c9                	xor    %ecx,%ecx
  8c529e:	c5 f8 77             	vzeroupper
  8c52a1:	e8 ea b8 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c52a6:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c52ab:	4c 89 ff             	mov    %r15,%rdi
  8c52ae:	eb 5a                	jmp    8c530a <check_lower_drain+0x1b7a>
  8c52b0:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c52b4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c52bb:	75 4d                	jne    8c530a <check_lower_drain+0x1b7a>
  8c52bd:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c52c4:	00 00 00 
  8c52c7:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c52cd:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c52d1:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c52d7:	eb 31                	jmp    8c530a <check_lower_drain+0x1b7a>
  8c52d9:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c52dd:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c52e4:	75 24                	jne    8c530a <check_lower_drain+0x1b7a>
  8c52e6:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c52ea:	c6 04 01 10          	movb   $0x10,(%rcx,%rax,1)
  8c52ee:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c52f2:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c52f6:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c52fa:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5301:	00 
  8c5302:	ff c0                	inc    %eax
  8c5304:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c530a:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5310:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5316:	77 33                	ja     8c534b <check_lower_drain+0x1bbb>
  8c5318:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c531e:	73 2b                	jae    8c534b <check_lower_drain+0x1bbb>
  8c5320:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5327:	75 4b                	jne    8c5374 <check_lower_drain+0x1be4>
  8c5329:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c532e:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c5333:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5338:	49 89 ff             	mov    %rdi,%r15
  8c533b:	48 89 df             	mov    %rbx,%rdi
  8c533e:	c5 f8 77             	vzeroupper
  8c5341:	e8 4a b8 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5346:	4c 89 ff             	mov    %r15,%rdi
  8c5349:	eb 56                	jmp    8c53a1 <check_lower_drain+0x1c11>
  8c534b:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c534f:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5356:	75 49                	jne    8c53a1 <check_lower_drain+0x1c11>
  8c5358:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c535f:	00 00 00 
  8c5362:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5368:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c536c:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5372:	eb 2d                	jmp    8c53a1 <check_lower_drain+0x1c11>
  8c5374:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5378:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c537f:	75 20                	jne    8c53a1 <check_lower_drain+0x1c11>
  8c5381:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5385:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c5389:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c538d:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5391:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5395:	48 89 34 c1          	mov    %rsi,(%rcx,%rax,8)
  8c5399:	ff c0                	inc    %eax
  8c539b:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c53a1:	45 8d 7c 3e 08       	lea    0x8(%r14,%rdi,1),%r15d
  8c53a6:	4c 89 e0             	mov    %r12,%rax
  8c53a9:	48 c1 e8 20          	shr    $0x20,%rax
  8c53ad:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8c53b2:	41 c1 ef 03          	shr    $0x3,%r15d
  8c53b6:	f3 41 0f b8 c7       	popcnt %r15d,%eax
  8c53bb:	89 44 24 28          	mov    %eax,0x28(%rsp)
  8c53bf:	83 f8 01             	cmp    $0x1,%eax
  8c53c2:	0f 87 96 00 00 00    	ja     8c545e <check_lower_drain+0x1cce>
  8c53c8:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c53ce:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c53d4:	77 2d                	ja     8c5403 <check_lower_drain+0x1c73>
  8c53d6:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c53dc:	73 25                	jae    8c5403 <check_lower_drain+0x1c73>
  8c53de:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c53e5:	75 45                	jne    8c542c <check_lower_drain+0x1c9c>
  8c53e7:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c53ec:	be 02 00 00 00       	mov    $0x2,%esi
  8c53f1:	ba 08 00 00 00       	mov    $0x8,%edx
  8c53f6:	48 89 df             	mov    %rbx,%rdi
  8c53f9:	c5 f8 77             	vzeroupper
  8c53fc:	e8 8f b7 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5401:	eb 5b                	jmp    8c545e <check_lower_drain+0x1cce>
  8c5403:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5407:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c540e:	75 4e                	jne    8c545e <check_lower_drain+0x1cce>
  8c5410:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5417:	00 00 00 
  8c541a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5420:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5424:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c542a:	eb 32                	jmp    8c545e <check_lower_drain+0x1cce>
  8c542c:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5430:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5437:	75 25                	jne    8c545e <check_lower_drain+0x1cce>
  8c5439:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c543d:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c5442:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5446:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c544a:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c544e:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5452:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c5456:	ff c0                	inc    %eax
  8c5458:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c545e:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5464:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c546a:	77 2d                	ja     8c5499 <check_lower_drain+0x1d09>
  8c546c:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5472:	73 25                	jae    8c5499 <check_lower_drain+0x1d09>
  8c5474:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c547b:	75 45                	jne    8c54c2 <check_lower_drain+0x1d32>
  8c547d:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c5482:	be 02 00 00 00       	mov    $0x2,%esi
  8c5487:	ba 08 00 00 00       	mov    $0x8,%edx
  8c548c:	48 89 df             	mov    %rbx,%rdi
  8c548f:	c5 f8 77             	vzeroupper
  8c5492:	e8 f9 b6 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5497:	eb 5b                	jmp    8c54f4 <check_lower_drain+0x1d64>
  8c5499:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c549d:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c54a4:	75 4e                	jne    8c54f4 <check_lower_drain+0x1d64>
  8c54a6:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c54ad:	00 00 00 
  8c54b0:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c54b6:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c54ba:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c54c0:	eb 32                	jmp    8c54f4 <check_lower_drain+0x1d64>
  8c54c2:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c54c6:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c54cd:	75 25                	jne    8c54f4 <check_lower_drain+0x1d64>
  8c54cf:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c54d3:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c54d8:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c54dc:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c54e0:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c54e4:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c54e8:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c54ec:	ff c0                	inc    %eax
  8c54ee:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c54f4:	48 89 df             	mov    %rbx,%rdi
  8c54f7:	44 89 fe             	mov    %r15d,%esi
  8c54fa:	c5 f8 77             	vzeroupper
  8c54fd:	e8 ae 20 01 00       	call   8d75b0 <check_lower_bit_unit>
  8c5502:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5508:	41 83 e4 07          	and    $0x7,%r12d
  8c550c:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5512:	77 2f                	ja     8c5543 <check_lower_drain+0x1db3>
  8c5514:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c551a:	73 27                	jae    8c5543 <check_lower_drain+0x1db3>
  8c551c:	c4 e2 99 f7 4c 24 50 	shlx   %r12,0x50(%rsp),%rcx
  8c5523:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c552a:	48 f7 d1             	not    %rcx
  8c552d:	75 3d                	jne    8c556c <check_lower_drain+0x1ddc>
  8c552f:	be 01 00 00 00       	mov    $0x1,%esi
  8c5534:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5539:	48 89 df             	mov    %rbx,%rdi
  8c553c:	e8 4f b6 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5541:	eb 56                	jmp    8c5599 <check_lower_drain+0x1e09>
  8c5543:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5547:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c554e:	75 49                	jne    8c5599 <check_lower_drain+0x1e09>
  8c5550:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5557:	00 00 00 
  8c555a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5560:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5564:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c556a:	eb 2d                	jmp    8c5599 <check_lower_drain+0x1e09>
  8c556c:	49 8b 55 00          	mov    0x0(%r13),%rdx
  8c5570:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c5577:	75 20                	jne    8c5599 <check_lower_drain+0x1e09>
  8c5579:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c557d:	c6 04 02 01          	movb   $0x1,(%rdx,%rax,1)
  8c5581:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c5585:	c6 04 02 08          	movb   $0x8,(%rdx,%rax,1)
  8c5589:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c558d:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c5591:	ff c0                	inc    %eax
  8c5593:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5599:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c559f:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c55a5:	77 27                	ja     8c55ce <check_lower_drain+0x1e3e>
  8c55a7:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c55ad:	73 1f                	jae    8c55ce <check_lower_drain+0x1e3e>
  8c55af:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c55b6:	75 3f                	jne    8c55f7 <check_lower_drain+0x1e67>
  8c55b8:	be 10 00 00 00       	mov    $0x10,%esi
  8c55bd:	ba 08 00 00 00       	mov    $0x8,%edx
  8c55c2:	48 89 df             	mov    %rbx,%rdi
  8c55c5:	31 c9                	xor    %ecx,%ecx
  8c55c7:	e8 c4 b5 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c55cc:	eb 5a                	jmp    8c5628 <check_lower_drain+0x1e98>
  8c55ce:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c55d2:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c55d9:	75 4d                	jne    8c5628 <check_lower_drain+0x1e98>
  8c55db:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c55e2:	00 00 00 
  8c55e5:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c55eb:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c55ef:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c55f5:	eb 31                	jmp    8c5628 <check_lower_drain+0x1e98>
  8c55f7:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c55fb:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5602:	75 24                	jne    8c5628 <check_lower_drain+0x1e98>
  8c5604:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5608:	c6 04 01 10          	movb   $0x10,(%rcx,%rax,1)
  8c560c:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5610:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5614:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5618:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c561f:	00 
  8c5620:	ff c0                	inc    %eax
  8c5622:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5628:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c562e:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5634:	77 2a                	ja     8c5660 <check_lower_drain+0x1ed0>
  8c5636:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c563c:	73 22                	jae    8c5660 <check_lower_drain+0x1ed0>
  8c563e:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5645:	75 42                	jne    8c5689 <check_lower_drain+0x1ef9>
  8c5647:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c564c:	be 02 00 00 00       	mov    $0x2,%esi
  8c5651:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5656:	48 89 df             	mov    %rbx,%rdi
  8c5659:	e8 32 b5 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c565e:	eb 5b                	jmp    8c56bb <check_lower_drain+0x1f2b>
  8c5660:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5664:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c566b:	75 4e                	jne    8c56bb <check_lower_drain+0x1f2b>
  8c566d:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5674:	00 00 00 
  8c5677:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c567d:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5681:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5687:	eb 32                	jmp    8c56bb <check_lower_drain+0x1f2b>
  8c5689:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c568d:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5694:	75 25                	jne    8c56bb <check_lower_drain+0x1f2b>
  8c5696:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c569a:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c569f:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c56a3:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c56a7:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c56ab:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c56af:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c56b3:	ff c0                	inc    %eax
  8c56b5:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c56bb:	45 85 f6             	test   %r14d,%r14d
  8c56be:	0f 84 1b 01 00 00    	je     8c57df <check_lower_drain+0x204f>
  8c56c4:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c56ca:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c56d0:	77 28                	ja     8c56fa <check_lower_drain+0x1f6a>
  8c56d2:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c56d8:	73 20                	jae    8c56fa <check_lower_drain+0x1f6a>
  8c56da:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c56e1:	75 40                	jne    8c5723 <check_lower_drain+0x1f93>
  8c56e3:	be 01 00 00 00       	mov    $0x1,%esi
  8c56e8:	ba 08 00 00 00       	mov    $0x8,%edx
  8c56ed:	48 89 df             	mov    %rbx,%rdi
  8c56f0:	4c 89 e1             	mov    %r12,%rcx
  8c56f3:	e8 98 b4 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c56f8:	eb 56                	jmp    8c5750 <check_lower_drain+0x1fc0>
  8c56fa:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c56fe:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5705:	75 49                	jne    8c5750 <check_lower_drain+0x1fc0>
  8c5707:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c570e:	00 00 00 
  8c5711:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5717:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c571b:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5721:	eb 2d                	jmp    8c5750 <check_lower_drain+0x1fc0>
  8c5723:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5727:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c572e:	75 20                	jne    8c5750 <check_lower_drain+0x1fc0>
  8c5730:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5734:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c5738:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c573c:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5740:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5744:	4c 89 24 c1          	mov    %r12,(%rcx,%rax,8)
  8c5748:	ff c0                	inc    %eax
  8c574a:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5750:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5756:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c575c:	77 27                	ja     8c5785 <check_lower_drain+0x1ff5>
  8c575e:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5764:	73 1f                	jae    8c5785 <check_lower_drain+0x1ff5>
  8c5766:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c576d:	75 3f                	jne    8c57ae <check_lower_drain+0x201e>
  8c576f:	be 13 00 00 00       	mov    $0x13,%esi
  8c5774:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5779:	48 89 df             	mov    %rbx,%rdi
  8c577c:	31 c9                	xor    %ecx,%ecx
  8c577e:	e8 0d b4 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5783:	eb 5a                	jmp    8c57df <check_lower_drain+0x204f>
  8c5785:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5789:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5790:	75 4d                	jne    8c57df <check_lower_drain+0x204f>
  8c5792:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5799:	00 00 00 
  8c579c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c57a2:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c57a6:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c57ac:	eb 31                	jmp    8c57df <check_lower_drain+0x204f>
  8c57ae:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c57b2:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c57b9:	75 24                	jne    8c57df <check_lower_drain+0x204f>
  8c57bb:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c57bf:	c6 04 01 13          	movb   $0x13,(%rcx,%rax,1)
  8c57c3:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c57c7:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c57cb:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c57cf:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c57d6:	00 
  8c57d7:	ff c0                	inc    %eax
  8c57d9:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c57df:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c57e5:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c57eb:	77 27                	ja     8c5814 <check_lower_drain+0x2084>
  8c57ed:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c57f3:	73 1f                	jae    8c5814 <check_lower_drain+0x2084>
  8c57f5:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c57fc:	75 3f                	jne    8c583d <check_lower_drain+0x20ad>
  8c57fe:	be 11 00 00 00       	mov    $0x11,%esi
  8c5803:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5808:	48 89 df             	mov    %rbx,%rdi
  8c580b:	31 c9                	xor    %ecx,%ecx
  8c580d:	e8 7e b3 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5812:	eb 5a                	jmp    8c586e <check_lower_drain+0x20de>
  8c5814:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5818:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c581f:	75 4d                	jne    8c586e <check_lower_drain+0x20de>
  8c5821:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5828:	00 00 00 
  8c582b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5831:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5835:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c583b:	eb 31                	jmp    8c586e <check_lower_drain+0x20de>
  8c583d:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5841:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5848:	75 24                	jne    8c586e <check_lower_drain+0x20de>
  8c584a:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c584e:	c6 04 01 11          	movb   $0x11,(%rcx,%rax,1)
  8c5852:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5856:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c585a:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c585e:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5865:	00 
  8c5866:	ff c0                	inc    %eax
  8c5868:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c586e:	83 7c 24 28 01       	cmpl   $0x1,0x28(%rsp)
  8c5873:	77 29                	ja     8c589e <check_lower_drain+0x210e>
  8c5875:	41 83 ff 02          	cmp    $0x2,%r15d
  8c5879:	0f 84 36 01 00 00    	je     8c59b5 <check_lower_drain+0x2225>
  8c587f:	41 83 ff 04          	cmp    $0x4,%r15d
  8c5883:	0f 84 27 01 00 00    	je     8c59b0 <check_lower_drain+0x2220>
  8c5889:	41 b6 08             	mov    $0x8,%r14b
  8c588c:	41 83 ff 08          	cmp    $0x8,%r15d
  8c5890:	0f 84 35 01 00 00    	je     8c59cb <check_lower_drain+0x223b>
  8c5896:	41 b6 02             	mov    $0x2,%r14b
  8c5899:	e9 1a 01 00 00       	jmp    8c59b8 <check_lower_drain+0x2228>
  8c589e:	44 8b b3 48 01 00 00 	mov    0x148(%rbx),%r14d
  8c58a5:	49 81 fe ff ff 00 00 	cmp    $0xffff,%r14
  8c58ac:	77 77                	ja     8c5925 <check_lower_drain+0x2195>
  8c58ae:	44 3b b3 4c 01 00 00 	cmp    0x14c(%rbx),%r14d
  8c58b5:	73 6e                	jae    8c5925 <check_lower_drain+0x2195>
  8c58b7:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8c58be:	42 c6 04 30 08       	movb   $0x8,(%rax,%r14,1)
  8c58c3:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
  8c58ca:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c58cf:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
  8c58d6:	42 c7 04 b0 00 00 00 	movl   $0x0,(%rax,%r14,4)
  8c58dd:	00 
  8c58de:	48 8b 83 e0 00 00 00 	mov    0xe0(%rbx),%rax
  8c58e5:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c58ea:	48 8b 83 b0 00 00 00 	mov    0xb0(%rbx),%rax
  8c58f1:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c58f6:	ff 83 48 01 00 00    	incl   0x148(%rbx)
  8c58fc:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5900:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5907:	75 3a                	jne    8c5943 <check_lower_drain+0x21b3>
  8c5909:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  8c5910:	42 c6 04 30 08       	movb   $0x8,(%rax,%r14,1)
  8c5915:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c591b:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5921:	76 2e                	jbe    8c5951 <check_lower_drain+0x21c1>
  8c5923:	eb 5b                	jmp    8c5980 <check_lower_drain+0x21f0>
  8c5925:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5929:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5930:	0f 84 d3 09 00 00    	je     8c6309 <check_lower_drain+0x2b79>
  8c5936:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c593a:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5941:	74 c6                	je     8c5909 <check_lower_drain+0x2179>
  8c5943:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5949:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c594f:	77 2f                	ja     8c5980 <check_lower_drain+0x21f0>
  8c5951:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5957:	73 27                	jae    8c5980 <check_lower_drain+0x21f0>
  8c5959:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5960:	0f 85 d0 00 00 00    	jne    8c5a36 <check_lower_drain+0x22a6>
  8c5966:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c596b:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5970:	48 89 df             	mov    %rbx,%rdi
  8c5973:	4c 89 f1             	mov    %r14,%rcx
  8c5976:	e8 15 b2 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c597b:	e9 e3 00 00 00       	jmp    8c5a63 <check_lower_drain+0x22d3>
  8c5980:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5984:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c598b:	0f 85 d2 00 00 00    	jne    8c5a63 <check_lower_drain+0x22d3>
  8c5991:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5998:	00 00 00 
  8c599b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c59a1:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c59a5:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c59ab:	e9 b3 00 00 00       	jmp    8c5a63 <check_lower_drain+0x22d3>
  8c59b0:	41 b6 06             	mov    $0x6,%r14b
  8c59b3:	eb 03                	jmp    8c59b8 <check_lower_drain+0x2228>
  8c59b5:	41 b6 04             	mov    $0x4,%r14b
  8c59b8:	41 0f b6 d6          	movzbl %r14b,%edx
  8c59bc:	be 09 00 00 00       	mov    $0x9,%esi
  8c59c1:	48 89 df             	mov    %rbx,%rdi
  8c59c4:	31 c9                	xor    %ecx,%ecx
  8c59c6:	e8 35 2e 00 00       	call   8c8800 <check_lower_emit>
  8c59cb:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c59d1:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c59d7:	77 2d                	ja     8c5a06 <check_lower_drain+0x2276>
  8c59d9:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c59df:	73 25                	jae    8c5a06 <check_lower_drain+0x2276>
  8c59e1:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c59e8:	0f 85 8f 04 00 00    	jne    8c5e7d <check_lower_drain+0x26ed>
  8c59ee:	41 0f b6 d6          	movzbl %r14b,%edx
  8c59f2:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c59f7:	48 89 df             	mov    %rbx,%rdi
  8c59fa:	31 c9                	xor    %ecx,%ecx
  8c59fc:	e8 8f b1 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5a01:	e9 a8 04 00 00       	jmp    8c5eae <check_lower_drain+0x271e>
  8c5a06:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5a0a:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5a11:	0f 85 97 04 00 00    	jne    8c5eae <check_lower_drain+0x271e>
  8c5a17:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5a1e:	00 00 00 
  8c5a21:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5a27:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5a2b:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5a31:	e9 78 04 00 00       	jmp    8c5eae <check_lower_drain+0x271e>
  8c5a36:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5a3a:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5a41:	75 20                	jne    8c5a63 <check_lower_drain+0x22d3>
  8c5a43:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5a47:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c5a4b:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5a4f:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5a53:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5a57:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c5a5b:	ff c0                	inc    %eax
  8c5a5d:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5a63:	45 31 e4             	xor    %r12d,%r12d
  8c5a66:	4c 89 74 24 50       	mov    %r14,0x50(%rsp)
  8c5a6b:	44 89 7c 24 28       	mov    %r15d,0x28(%rsp)
  8c5a70:	eb 24                	jmp    8c5a96 <check_lower_drain+0x2306>
  8c5a72:	41 0f b6 d7          	movzbl %r15b,%edx
  8c5a76:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c5a7b:	48 89 df             	mov    %rbx,%rdi
  8c5a7e:	31 c9                	xor    %ecx,%ecx
  8c5a80:	e8 0b b1 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5a85:	44 8b 7c 24 28       	mov    0x28(%rsp),%r15d
  8c5a8a:	45 01 f4             	add    %r14d,%r12d
  8c5a8d:	45 39 fc             	cmp    %r15d,%r12d
  8c5a90:	0f 83 18 04 00 00    	jae    8c5eae <check_lower_drain+0x271e>
  8c5a96:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5a9a:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5aa1:	0f 85 07 04 00 00    	jne    8c5eae <check_lower_drain+0x271e>
  8c5aa7:	44 89 f9             	mov    %r15d,%ecx
  8c5aaa:	44 29 e1             	sub    %r12d,%ecx
  8c5aad:	83 f9 07             	cmp    $0x7,%ecx
  8c5ab0:	76 1a                	jbe    8c5acc <check_lower_drain+0x233c>
  8c5ab2:	41 b7 08             	mov    $0x8,%r15b
  8c5ab5:	41 be 08 00 00 00    	mov    $0x8,%r14d
  8c5abb:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5ac1:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5ac8:	76 45                	jbe    8c5b0f <check_lower_drain+0x237f>
  8c5aca:	eb 6d                	jmp    8c5b39 <check_lower_drain+0x23a9>
  8c5acc:	83 f9 03             	cmp    $0x3,%ecx
  8c5acf:	76 1a                	jbe    8c5aeb <check_lower_drain+0x235b>
  8c5ad1:	41 b7 06             	mov    $0x6,%r15b
  8c5ad4:	41 be 04 00 00 00    	mov    $0x4,%r14d
  8c5ada:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5ae0:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5ae7:	76 26                	jbe    8c5b0f <check_lower_drain+0x237f>
  8c5ae9:	eb 4e                	jmp    8c5b39 <check_lower_drain+0x23a9>
  8c5aeb:	45 31 ff             	xor    %r15d,%r15d
  8c5aee:	83 f9 02             	cmp    $0x2,%ecx
  8c5af1:	41 0f 93 c7          	setae  %r15b
  8c5af5:	45 8d 77 01          	lea    0x1(%r15),%r14d
  8c5af9:	45 00 ff             	add    %r15b,%r15b
  8c5afc:	41 80 c7 02          	add    $0x2,%r15b
  8c5b00:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5b06:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5b0d:	77 2a                	ja     8c5b39 <check_lower_drain+0x23a9>
  8c5b0f:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c5b15:	73 22                	jae    8c5b39 <check_lower_drain+0x23a9>
  8c5b17:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5b1e:	75 35                	jne    8c5b55 <check_lower_drain+0x23c5>
  8c5b20:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c5b25:	be 02 00 00 00       	mov    $0x2,%esi
  8c5b2a:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5b2f:	48 89 df             	mov    %rbx,%rdi
  8c5b32:	e8 59 b0 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5b37:	eb 41                	jmp    8c5b7a <check_lower_drain+0x23ea>
  8c5b39:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5b40:	00 00 00 
  8c5b43:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5b49:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5b4d:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5b53:	eb 25                	jmp    8c5b7a <check_lower_drain+0x23ea>
  8c5b55:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c5b59:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8c5b5e:	c6 04 08 02          	movb   $0x2,(%rax,%rcx,1)
  8c5b62:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c5b66:	c6 04 08 08          	movb   $0x8,(%rax,%rcx,1)
  8c5b6a:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c5b6e:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
  8c5b72:	ff c1                	inc    %ecx
  8c5b74:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c5b7a:	44 89 e6             	mov    %r12d,%esi
  8c5b7d:	48 89 df             	mov    %rbx,%rdi
  8c5b80:	e8 db 8d 00 00       	call   8ce960 <check_lower_offset>
  8c5b85:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5b8b:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5b91:	77 2a                	ja     8c5bbd <check_lower_drain+0x242d>
  8c5b93:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5b99:	73 22                	jae    8c5bbd <check_lower_drain+0x242d>
  8c5b9b:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5ba2:	75 42                	jne    8c5be6 <check_lower_drain+0x2456>
  8c5ba4:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8c5ba9:	be 02 00 00 00       	mov    $0x2,%esi
  8c5bae:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5bb3:	48 89 df             	mov    %rbx,%rdi
  8c5bb6:	e8 d5 af 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5bbb:	eb 63                	jmp    8c5c20 <check_lower_drain+0x2490>
  8c5bbd:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5bc1:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5bc8:	75 56                	jne    8c5c20 <check_lower_drain+0x2490>
  8c5bca:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5bd1:	00 00 00 
  8c5bd4:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5bda:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5bde:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5be4:	eb 3a                	jmp    8c5c20 <check_lower_drain+0x2490>
  8c5be6:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5bea:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5bf1:	75 2d                	jne    8c5c20 <check_lower_drain+0x2490>
  8c5bf3:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5bf7:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  8c5bfc:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5c00:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5c04:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5c08:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5c0c:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c5c10:	ff c0                	inc    %eax
  8c5c12:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5c18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8c5c1f:	00 
  8c5c20:	45 85 e4             	test   %r12d,%r12d
  8c5c23:	0f 84 27 01 00 00    	je     8c5d50 <check_lower_drain+0x25c0>
  8c5c29:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5c2f:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5c35:	77 2d                	ja     8c5c64 <check_lower_drain+0x24d4>
  8c5c37:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5c3d:	73 25                	jae    8c5c64 <check_lower_drain+0x24d4>
  8c5c3f:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5c46:	42 8d 0c e5 00 00 00 	lea    0x0(,%r12,8),%ecx
  8c5c4d:	00 
  8c5c4e:	75 3d                	jne    8c5c8d <check_lower_drain+0x24fd>
  8c5c50:	be 01 00 00 00       	mov    $0x1,%esi
  8c5c55:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5c5a:	48 89 df             	mov    %rbx,%rdi
  8c5c5d:	e8 2e af 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5c62:	eb 56                	jmp    8c5cba <check_lower_drain+0x252a>
  8c5c64:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5c68:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5c6f:	75 49                	jne    8c5cba <check_lower_drain+0x252a>
  8c5c71:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5c78:	00 00 00 
  8c5c7b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5c81:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5c85:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5c8b:	eb 2d                	jmp    8c5cba <check_lower_drain+0x252a>
  8c5c8d:	49 8b 55 00          	mov    0x0(%r13),%rdx
  8c5c91:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c5c98:	75 20                	jne    8c5cba <check_lower_drain+0x252a>
  8c5c9a:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c5c9e:	c6 04 02 01          	movb   $0x1,(%rdx,%rax,1)
  8c5ca2:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c5ca6:	c6 04 02 08          	movb   $0x8,(%rdx,%rax,1)
  8c5caa:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c5cae:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c5cb2:	ff c0                	inc    %eax
  8c5cb4:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5cba:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5cc0:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5cc6:	77 27                	ja     8c5cef <check_lower_drain+0x255f>
  8c5cc8:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5cce:	73 1f                	jae    8c5cef <check_lower_drain+0x255f>
  8c5cd0:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5cd7:	75 3f                	jne    8c5d18 <check_lower_drain+0x2588>
  8c5cd9:	be 14 00 00 00       	mov    $0x14,%esi
  8c5cde:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5ce3:	48 89 df             	mov    %rbx,%rdi
  8c5ce6:	31 c9                	xor    %ecx,%ecx
  8c5ce8:	e8 a3 ae 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5ced:	eb 61                	jmp    8c5d50 <check_lower_drain+0x25c0>
  8c5cef:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5cf3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5cfa:	75 54                	jne    8c5d50 <check_lower_drain+0x25c0>
  8c5cfc:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5d03:	00 00 00 
  8c5d06:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5d0c:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5d10:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5d16:	eb 38                	jmp    8c5d50 <check_lower_drain+0x25c0>
  8c5d18:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5d1c:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5d23:	75 2b                	jne    8c5d50 <check_lower_drain+0x25c0>
  8c5d25:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5d29:	c6 04 01 14          	movb   $0x14,(%rcx,%rax,1)
  8c5d2d:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5d31:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5d35:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5d39:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5d40:	00 
  8c5d41:	ff c0                	inc    %eax
  8c5d43:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5d49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8c5d50:	41 80 ff 08          	cmp    $0x8,%r15b
  8c5d54:	0f 84 96 00 00 00    	je     8c5df0 <check_lower_drain+0x2660>
  8c5d5a:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5d60:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5d66:	77 26                	ja     8c5d8e <check_lower_drain+0x25fe>
  8c5d68:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5d6e:	73 1e                	jae    8c5d8e <check_lower_drain+0x25fe>
  8c5d70:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5d77:	75 3e                	jne    8c5db7 <check_lower_drain+0x2627>
  8c5d79:	41 0f b6 d7          	movzbl %r15b,%edx
  8c5d7d:	be 09 00 00 00       	mov    $0x9,%esi
  8c5d82:	48 89 df             	mov    %rbx,%rdi
  8c5d85:	31 c9                	xor    %ecx,%ecx
  8c5d87:	e8 04 ae 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5d8c:	eb 62                	jmp    8c5df0 <check_lower_drain+0x2660>
  8c5d8e:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5d92:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5d99:	75 55                	jne    8c5df0 <check_lower_drain+0x2660>
  8c5d9b:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5da2:	00 00 00 
  8c5da5:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5dab:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5daf:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5db5:	eb 39                	jmp    8c5df0 <check_lower_drain+0x2660>
  8c5db7:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5dbb:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5dc2:	75 2c                	jne    8c5df0 <check_lower_drain+0x2660>
  8c5dc4:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5dc8:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c5dcc:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5dd0:	44 88 3c 01          	mov    %r15b,(%rcx,%rax,1)
  8c5dd4:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5dd8:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5ddf:	00 
  8c5de0:	ff c0                	inc    %eax
  8c5de2:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5de8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8c5def:	00 
  8c5df0:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5df6:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5dfc:	77 4f                	ja     8c5e4d <check_lower_drain+0x26bd>
  8c5dfe:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5e04:	73 47                	jae    8c5e4d <check_lower_drain+0x26bd>
  8c5e06:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5e0d:	0f 84 5f fc ff ff    	je     8c5a72 <check_lower_drain+0x22e2>
  8c5e13:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5e17:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5e1e:	0f 85 61 fc ff ff    	jne    8c5a85 <check_lower_drain+0x22f5>
  8c5e24:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5e28:	c6 04 01 1d          	movb   $0x1d,(%rcx,%rax,1)
  8c5e2c:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5e30:	44 88 3c 01          	mov    %r15b,(%rcx,%rax,1)
  8c5e34:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5e38:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5e3f:	00 
  8c5e40:	ff c0                	inc    %eax
  8c5e42:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5e48:	e9 38 fc ff ff       	jmp    8c5a85 <check_lower_drain+0x22f5>
  8c5e4d:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5e51:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5e58:	0f 85 27 fc ff ff    	jne    8c5a85 <check_lower_drain+0x22f5>
  8c5e5e:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5e65:	00 00 00 
  8c5e68:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5e6e:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5e72:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5e78:	e9 08 fc ff ff       	jmp    8c5a85 <check_lower_drain+0x22f5>
  8c5e7d:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5e81:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5e88:	75 24                	jne    8c5eae <check_lower_drain+0x271e>
  8c5e8a:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5e8e:	c6 04 01 1d          	movb   $0x1d,(%rcx,%rax,1)
  8c5e92:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5e96:	44 88 34 01          	mov    %r14b,(%rcx,%rax,1)
  8c5e9a:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5e9e:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5ea5:	00 
  8c5ea6:	ff c0                	inc    %eax
  8c5ea8:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5eae:	48 0f ba e5 2a       	bt     $0x2a,%rbp
  8c5eb3:	0f 82 eb d9 ff ff    	jb     8c38a4 <check_lower_drain+0x114>
  8c5eb9:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5ebf:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5ec5:	77 2a                	ja     8c5ef1 <check_lower_drain+0x2761>
  8c5ec7:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5ecd:	73 22                	jae    8c5ef1 <check_lower_drain+0x2761>
  8c5ecf:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5ed6:	75 42                	jne    8c5f1a <check_lower_drain+0x278a>
  8c5ed8:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c5edd:	be 02 00 00 00       	mov    $0x2,%esi
  8c5ee2:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5ee7:	48 89 df             	mov    %rbx,%rdi
  8c5eea:	e8 a1 ac 01 00       	call   8e0b90 <check_lower_emit_tracked>
  8c5eef:	eb 5b                	jmp    8c5f4c <check_lower_drain+0x27bc>
  8c5ef1:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5ef5:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5efc:	75 4e                	jne    8c5f4c <check_lower_drain+0x27bc>
  8c5efe:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5f05:	00 00 00 
  8c5f08:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5f0e:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5f12:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5f18:	eb 32                	jmp    8c5f4c <check_lower_drain+0x27bc>
  8c5f1a:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5f1e:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5f25:	75 25                	jne    8c5f4c <check_lower_drain+0x27bc>
  8c5f27:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5f2b:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c5f30:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5f34:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5f38:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5f3c:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5f40:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c5f44:	ff c0                	inc    %eax
  8c5f46:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5f4c:	48 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%rsi
  8c5f53:	00 
  8c5f54:	48 89 df             	mov    %rbx,%rdi
  8c5f57:	31 d2                	xor    %edx,%edx
  8c5f59:	e8 32 1d 01 00       	call   8d7c90 <check_lower_bit_extract>
  8c5f5e:	e9 41 d9 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c5f63:	48 b8 00 00 00 00 00 	movabs $0x50000000000,%rax
  8c5f6a:	05 00 00 
  8c5f6d:	48 85 c5             	test   %rax,%rbp
  8c5f70:	0f 85 e5 e7 ff ff    	jne    8c475b <check_lower_drain+0xfcb>
  8c5f76:	48 83 bb a8 01 00 00 	cmpq   $0x0,0x1a8(%rbx)
  8c5f7d:	00 
  8c5f7e:	0f 84 d7 e7 ff ff    	je     8c475b <check_lower_drain+0xfcb>
  8c5f84:	48 8b 33             	mov    (%rbx),%rsi
  8c5f87:	89 ea                	mov    %ebp,%edx
  8c5f89:	4c 8d 2c 52          	lea    (%rdx,%rdx,2),%r13
  8c5f8d:	49 c1 e5 05          	shl    $0x5,%r13
  8c5f91:	48 8b 0e             	mov    (%rsi),%rcx
  8c5f94:	48 8b 46 08          	mov    0x8(%rsi),%rax
  8c5f98:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  8c5f9d:	48 8b 09             	mov    (%rcx),%rcx
  8c5fa0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c5fa4:	8b 0c 91             	mov    (%rcx,%rdx,4),%ecx
  8c5fa7:	4c 01 e8             	add    %r13,%rax
  8c5faa:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8c5faf:	48 83 f9 3f          	cmp    $0x3f,%rcx
  8c5fb3:	77 10                	ja     8c5fc5 <check_lower_drain+0x2835>
  8c5fb5:	48 b8 08 00 e0 fa ef 	movabs $0xffefffeffae00008,%rax
  8c5fbc:	ff ef ff 
  8c5fbf:	48 0f a3 c8          	bt     %rcx,%rax
  8c5fc3:	73 0f                	jae    8c5fd4 <check_lower_drain+0x2844>
  8c5fc5:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c5fca:	83 78 0c 01          	cmpl   $0x1,0xc(%rax)
  8c5fce:	0f 85 87 e7 ff ff    	jne    8c475b <check_lower_drain+0xfcb>
  8c5fd4:	b8 04 02 00 00       	mov    $0x204,%eax
  8c5fd9:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  8c5fde:	48 8d 8b 00 02 00 00 	lea    0x200(%rbx),%rcx
  8c5fe5:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  8c5fea:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  8c5fef:	89 ee                	mov    %ebp,%esi
  8c5ff1:	c4 e2 78 f7 c5       	bextr  %eax,%ebp,%eax
  8c5ff6:	48 69 c0 d0 00 00 00 	imul   $0xd0,%rax,%rax
  8c5ffd:	8b 94 01 c8 00 00 00 	mov    0xc8(%rcx,%rax,1),%edx
  8c6004:	4c 8d 04 01          	lea    (%rcx,%rax,1),%r8
  8c6008:	29 d6                	sub    %edx,%esi
  8c600a:	0f 92 c0             	setb   %al
  8c600d:	83 fe 10             	cmp    $0x10,%esi
  8c6010:	f6 d0                	not    %al
  8c6012:	0f 92 c1             	setb   %cl
  8c6015:	84 c8                	test   %cl,%al
  8c6017:	75 21                	jne    8c603a <check_lower_drain+0x28aa>
  8c6019:	48 89 df             	mov    %rbx,%rdi
  8c601c:	4c 89 c6             	mov    %r8,%rsi
  8c601f:	89 ea                	mov    %ebp,%edx
  8c6021:	4d 89 c6             	mov    %r8,%r14
  8c6024:	c5 f8 77             	vzeroupper
  8c6027:	e8 34 2c 01 00       	call   8d8c60 <check_lower_batch_prepare>
  8c602c:	41 8b 96 c8 00 00 00 	mov    0xc8(%r14),%edx
  8c6033:	89 ee                	mov    %ebp,%esi
  8c6035:	4d 89 f0             	mov    %r14,%r8
  8c6038:	29 d6                	sub    %edx,%esi
  8c603a:	41 89 f6             	mov    %esi,%r14d
  8c603d:	49 8b 88 c0 00 00 00 	mov    0xc0(%r8),%rcx
  8c6044:	47 0f b7 54 70 20    	movzwl 0x20(%r8,%r14,2),%r10d
  8c604a:	47 0f b7 0c 70       	movzwl (%r8,%r14,2),%r9d
  8c604f:	89 94 24 80 00 00 00 	mov    %edx,0x80(%rsp)
  8c6056:	41 0f b6 c2          	movzbl %r10b,%eax
  8c605a:	48 0f a3 f1          	bt     %rsi,%rcx
  8c605e:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  8c6063:	89 84 24 88 00 00 00 	mov    %eax,0x88(%rsp)
  8c606a:	0f 83 f1 0a 00 00    	jae    8c6b61 <check_lower_drain+0x33d1>
  8c6070:	4c 8b 1b             	mov    (%rbx),%r11
  8c6073:	49 8b 43 08          	mov    0x8(%r11),%rax
  8c6077:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8c607b:	42 8b 44 29 40       	mov    0x40(%rcx,%r13,1),%eax
  8c6080:	48 85 c0             	test   %rax,%rax
  8c6083:	0f 84 b0 05 00 00    	je     8c6639 <check_lower_drain+0x2ea9>
  8c6089:	41 3b 83 c0 00 00 00 	cmp    0xc0(%r11),%eax
  8c6090:	0f 92 c2             	setb   %dl
  8c6093:	e9 a3 05 00 00       	jmp    8c663b <check_lower_drain+0x2eab>
  8c6098:	4c 8b 8b 98 01 00 00 	mov    0x198(%rbx),%r9
  8c609f:	41 0f b6 0c 09       	movzbl (%r9,%rcx,1),%ecx
  8c60a4:	45 31 ed             	xor    %r13d,%r13d
  8c60a7:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  8c60ac:	4d 01 c4             	add    %r8,%r12
  8c60af:	4d 8b 41 08          	mov    0x8(%r9),%r8
  8c60b3:	47 8b 04 b8          	mov    (%r8,%r15,4),%r8d
  8c60b7:	44 89 83 64 01 00 00 	mov    %r8d,0x164(%rbx)
  8c60be:	45 8b 44 24 0c       	mov    0xc(%r12),%r8d
  8c60c3:	45 85 c0             	test   %r8d,%r8d
  8c60c6:	74 08                	je     8c60d0 <check_lower_drain+0x2940>
  8c60c8:	41 83 7c 24 54 00    	cmpl   $0x0,0x54(%r12)
  8c60ce:	74 05                	je     8c60d5 <check_lower_drain+0x2945>
  8c60d0:	45 31 c9             	xor    %r9d,%r9d
  8c60d3:	eb 0d                	jmp    8c60e2 <check_lower_drain+0x2952>
  8c60d5:	41 f7 44 24 08 10 08 	testl  $0x810,0x8(%r12)
  8c60dc:	00 00 
  8c60de:	41 0f 94 c1          	sete   %r9b
  8c60e2:	45 85 db             	test   %r11d,%r11d
  8c60e5:	0f 85 c1 00 00 00    	jne    8c61ac <check_lower_drain+0x2a1c>
  8c60eb:	40 f6 c7 01          	test   $0x1,%dil
  8c60ef:	0f 85 b7 00 00 00    	jne    8c61ac <check_lower_drain+0x2a1c>
  8c60f5:	41 8b 74 24 40       	mov    0x40(%r12),%esi
  8c60fa:	85 f6                	test   %esi,%esi
  8c60fc:	0f 84 c6 00 00 00    	je     8c61c8 <check_lower_drain+0x2a38>
  8c6102:	3b b0 c0 00 00 00    	cmp    0xc0(%rax),%esi
  8c6108:	0f 83 ba 00 00 00    	jae    8c61c8 <check_lower_drain+0x2a38>
  8c610e:	48 8b 38             	mov    (%rax),%rdi
  8c6111:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  8c6116:	4c 89 74 24 30       	mov    %r14,0x30(%rsp)
  8c611b:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  8c6120:	ff ce                	dec    %esi
  8c6122:	4c 8b 64 24 58       	mov    0x58(%rsp),%r12
  8c6127:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  8c612c:	48 8b 87 90 02 00 00 	mov    0x290(%rdi),%rax
  8c6133:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1)
  8c6137:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c613c:	0f 84 86 00 00 00    	je     8c61c8 <check_lower_drain+0x2a38>
  8c6142:	48 8b bf 78 02 00 00 	mov    0x278(%rdi),%rdi
  8c6149:	80 3c 37 00          	cmpb   $0x0,(%rdi,%rsi,1)
  8c614d:	75 79                	jne    8c61c8 <check_lower_drain+0x2a38>
  8c614f:	48 8b 40 28          	mov    0x28(%rax),%rax
  8c6153:	48 85 c0             	test   %rax,%rax
  8c6156:	0f 84 e3 22 00 00    	je     8c843f <check_lower_drain+0x4caf>
  8c615c:	48 8b 40 10          	mov    0x10(%rax),%rax
  8c6160:	44 8b 34 b0          	mov    (%rax,%rsi,4),%r14d
  8c6164:	45 85 f6             	test   %r14d,%r14d
  8c6167:	0f 84 d2 22 00 00    	je     8c843f <check_lower_drain+0x4caf>
  8c616d:	c6 84 24 89 01 00 00 	movb   $0x1,0x189(%rsp)
  8c6174:	01 
  8c6175:	48 89 df             	mov    %rbx,%rdi
  8c6178:	c5 fe 6f 84 24 70 01 	vmovdqu 0x170(%rsp),%ymm0
  8c617f:	00 00 
  8c6181:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c6186:	c5 f8 77             	vzeroupper
  8c6189:	e8 72 69 00 00       	call   8ccb00 <check_lower_push>
  8c618e:	41 8b 74 24 40       	mov    0x40(%r12),%esi
  8c6193:	41 ff ce             	dec    %r14d
  8c6196:	48 89 df             	mov    %rbx,%rdi
  8c6199:	4c 89 f2             	mov    %r14,%rdx
  8c619c:	ff ce                	dec    %esi
  8c619e:	48 c1 e6 20          	shl    $0x20,%rsi
  8c61a2:	e8 a9 2d 00 00       	call   8c8f50 <check_lower_initializer>
  8c61a7:	e9 bd 22 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c61ac:	41 83 fb 37          	cmp    $0x37,%r11d
  8c61b0:	75 16                	jne    8c61c8 <check_lower_drain+0x2a38>
  8c61b2:	40 0f b6 d6          	movzbl %sil,%edx
  8c61b6:	48 89 df             	mov    %rbx,%rdi
  8c61b9:	89 ee                	mov    %ebp,%esi
  8c61bb:	c5 f8 77             	vzeroupper
  8c61be:	e8 0d 2e 01 00       	call   8d8fd0 <check_lower_region>
  8c61c3:	e9 a1 22 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c61c8:	45 84 c9             	test   %r9b,%r9b
  8c61cb:	74 54                	je     8c6221 <check_lower_drain+0x2a91>
  8c61cd:	41 83 fb 23          	cmp    $0x23,%r11d
  8c61d1:	0f 84 8f 00 00 00    	je     8c6266 <check_lower_drain+0x2ad6>
  8c61d7:	41 83 fb 3e          	cmp    $0x3e,%r11d
  8c61db:	0f 84 85 00 00 00    	je     8c6266 <check_lower_drain+0x2ad6>
  8c61e1:	41 83 7c 24 04 00    	cmpl   $0x0,0x4(%r12)
  8c61e7:	75 07                	jne    8c61f0 <check_lower_drain+0x2a60>
  8c61e9:	f6 44 24 40 01       	testb  $0x1,0x40(%rsp)
  8c61ee:	74 15                	je     8c6205 <check_lower_drain+0x2a75>
  8c61f0:	8b 74 24 68          	mov    0x68(%rsp),%esi
  8c61f4:	40 0a 74 24 40       	or     0x40(%rsp),%sil
  8c61f9:	40 f6 c6 01          	test   $0x1,%sil
  8c61fd:	74 22                	je     8c6221 <check_lower_drain+0x2a91>
  8c61ff:	41 83 f8 03          	cmp    $0x3,%r8d
  8c6203:	75 1c                	jne    8c6221 <check_lower_drain+0x2a91>
  8c6205:	f6 c2 01             	test   $0x1,%dl
  8c6208:	0f 85 5b 22 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c620e:	48 89 df             	mov    %rbx,%rdi
  8c6211:	4c 89 e6             	mov    %r12,%rsi
  8c6214:	c5 f8 77             	vzeroupper
  8c6217:	e8 74 76 00 00       	call   8cd890 <check_lower_constant>
  8c621c:	e9 48 22 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c6221:	41 83 fb 34          	cmp    $0x34,%r11d
  8c6225:	0f 84 9d 00 00 00    	je     8c62c8 <check_lower_drain+0x2b38>
  8c622b:	45 85 db             	test   %r11d,%r11d
  8c622e:	75 36                	jne    8c6266 <check_lower_drain+0x2ad6>
  8c6230:	41 83 3c 24 08       	cmpl   $0x8,(%r12)
  8c6235:	0f 84 2e 22 00 00    	je     8c8469 <check_lower_drain+0x4cd9>
  8c623b:	8b 54 24 68          	mov    0x68(%rsp),%edx
  8c623f:	41 8b 74 24 40       	mov    0x40(%r12),%esi
  8c6244:	0a 54 24 40          	or     0x40(%rsp),%dl
  8c6248:	f6 c2 01             	test   $0x1,%dl
  8c624b:	0f 84 be 02 00 00    	je     8c650f <check_lower_drain+0x2d7f>
  8c6251:	49 8b 54 24 48       	mov    0x48(%r12),%rdx
  8c6256:	48 89 df             	mov    %rbx,%rdi
  8c6259:	c5 f8 77             	vzeroupper
  8c625c:	e8 7f 83 00 00       	call   8ce5e0 <check_lower_address>
  8c6261:	e9 03 22 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c6266:	44 89 de             	mov    %r11d,%esi
  8c6269:	83 e6 fe             	and    $0xfffffffe,%esi
  8c626c:	83 fe 40             	cmp    $0x40,%esi
  8c626f:	0f 85 c4 00 00 00    	jne    8c6339 <check_lower_drain+0x2ba9>
  8c6275:	48 89 ce             	mov    %rcx,%rsi
  8c6278:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c627d:	49 8b 46 08          	mov    0x8(%r14),%rax
  8c6281:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  8c6286:	4d 89 f4             	mov    %r14,%r12
  8c6289:	4c 8d 34 49          	lea    (%rcx,%rcx,2),%r14
  8c628d:	48 8b 0f             	mov    (%rdi),%rcx
  8c6290:	49 c1 e6 05          	shl    $0x5,%r14
  8c6294:	46 8b 3c 30          	mov    (%rax,%r14,1),%r15d
  8c6298:	41 c1 ef 03          	shr    $0x3,%r15d
  8c629c:	42 80 3c 39 0f       	cmpb   $0xf,(%rcx,%r15,1)
  8c62a1:	4c 89 fa             	mov    %r15,%rdx
  8c62a4:	75 0b                	jne    8c62b1 <check_lower_drain+0x2b21>
  8c62a6:	48 8b 57 20          	mov    0x20(%rdi),%rdx
  8c62aa:	42 8b 14 ba          	mov    (%rdx,%r15,4),%edx
  8c62ae:	c1 ea 03             	shr    $0x3,%edx
  8c62b1:	0f b6 0c 11          	movzbl (%rcx,%rdx,1),%ecx
  8c62b5:	80 f9 06             	cmp    $0x6,%cl
  8c62b8:	0f 84 44 01 00 00    	je     8c6402 <check_lower_drain+0x2c72>
  8c62be:	41 83 fb 40          	cmp    $0x40,%r11d
  8c62c2:	0f 85 3a 01 00 00    	jne    8c6402 <check_lower_drain+0x2c72>
  8c62c8:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c62cd:	48 89 df             	mov    %rbx,%rdi
  8c62d0:	89 ee                	mov    %ebp,%esi
  8c62d2:	31 d2                	xor    %edx,%edx
  8c62d4:	83 e1 01             	and    $0x1,%ecx
  8c62d7:	45 31 c0             	xor    %r8d,%r8d
  8c62da:	c5 f8 77             	vzeroupper
  8c62dd:	e8 9e 2a 01 00       	call   8d8d80 <check_lower_operand>
  8c62e2:	e9 82 21 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c62e7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c62ee:	0f 85 b0 d5 ff ff    	jne    8c38a4 <check_lower_drain+0x114>
  8c62f4:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c62f8:	c6 04 08 09          	movb   $0x9,(%rax,%rcx,1)
  8c62fc:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c6300:	44 88 24 08          	mov    %r12b,(%rax,%rcx,1)
  8c6304:	e9 c6 e5 ff ff       	jmp    8c48cf <check_lower_drain+0x113f>
  8c6309:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6310:	00 00 00 
  8c6313:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6319:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c631d:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6323:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c6327:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c632e:	0f 85 0f f6 ff ff    	jne    8c5943 <check_lower_drain+0x21b3>
  8c6334:	e9 d0 f5 ff ff       	jmp    8c5909 <check_lower_drain+0x2179>
  8c6339:	41 8d 7b c7          	lea    -0x39(%r11),%edi
  8c633d:	83 ff 01             	cmp    $0x1,%edi
  8c6340:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  8c6344:	0f 87 db 00 00 00    	ja     8c6425 <check_lower_drain+0x2c95>
  8c634a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8c634f:	48 89 c1             	mov    %rax,%rcx
  8c6352:	48 8b 42 38          	mov    0x38(%rdx),%rax
  8c6356:	46 8b 34 b8          	mov    (%rax,%r15,4),%r14d
  8c635a:	45 85 f6             	test   %r14d,%r14d
  8c635d:	0f 84 e8 00 00 00    	je     8c644b <check_lower_drain+0x2cbb>
  8c6363:	48 8b 01             	mov    (%rcx),%rax
  8c6366:	44 3b b0 58 03 00 00 	cmp    0x358(%rax),%r14d
  8c636d:	0f 87 d8 00 00 00    	ja     8c644b <check_lower_drain+0x2cbb>
  8c6373:	48 8b 80 50 03 00 00 	mov    0x350(%rax),%rax
  8c637a:	48 8b 93 80 01 00 00 	mov    0x180(%rbx),%rdx
  8c6381:	41 ff ce             	dec    %r14d
  8c6384:	4b 8d 0c f6          	lea    (%r14,%r14,8),%rcx
  8c6388:	8b 44 88 14          	mov    0x14(%rax,%rcx,4),%eax
  8c638c:	3b 42 04             	cmp    0x4(%rdx),%eax
  8c638f:	0f 85 b6 00 00 00    	jne    8c644b <check_lower_drain+0x2cbb>
  8c6395:	48 8b 83 98 00 00 00 	mov    0x98(%rbx),%rax
  8c639c:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c63a0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c63a3:	75 2c                	jne    8c63d1 <check_lower_drain+0x2c41>
  8c63a5:	be 08 00 00 00       	mov    $0x8,%esi
  8c63aa:	48 89 df             	mov    %rbx,%rdi
  8c63ad:	4d 89 df             	mov    %r11,%r15
  8c63b0:	c5 f8 77             	vzeroupper
  8c63b3:	e8 48 82 ff ff       	call   8be600 <check_lower_temporary>
  8c63b8:	48 8b 8b 98 00 00 00 	mov    0x98(%rbx),%rcx
  8c63bf:	4d 89 fb             	mov    %r15,%r11
  8c63c2:	42 89 04 b1          	mov    %eax,(%rcx,%r14,4)
  8c63c6:	48 8b 83 98 00 00 00 	mov    0x98(%rbx),%rax
  8c63cd:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c63d1:	41 83 fb 39          	cmp    $0x39,%r11d
  8c63d5:	be 02 00 00 00       	mov    $0x2,%esi
  8c63da:	ba 1e 00 00 00       	mov    $0x1e,%edx
  8c63df:	89 c1                	mov    %eax,%ecx
  8c63e1:	48 89 df             	mov    %rbx,%rdi
  8c63e4:	4d 89 de             	mov    %r11,%r14
  8c63e7:	0f 44 f2             	cmove  %edx,%esi
  8c63ea:	ba 08 00 00 00       	mov    $0x8,%edx
  8c63ef:	c5 f8 77             	vzeroupper
  8c63f2:	e8 59 29 00 00       	call   8c8d50 <check_lower_instruction>
  8c63f7:	41 83 fe 39          	cmp    $0x39,%r14d
  8c63fb:	74 32                	je     8c642f <check_lower_drain+0x2c9f>
  8c63fd:	e9 67 20 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c6402:	80 f9 06             	cmp    $0x6,%cl
  8c6405:	74 63                	je     8c646a <check_lower_drain+0x2cda>
  8c6407:	40 0f b6 d6          	movzbl %sil,%edx
  8c640b:	be 01 00 00 00       	mov    $0x1,%esi
  8c6410:	48 89 df             	mov    %rbx,%rdi
  8c6413:	31 c9                	xor    %ecx,%ecx
  8c6415:	c5 f8 77             	vzeroupper
  8c6418:	e8 33 29 00 00       	call   8c8d50 <check_lower_instruction>
  8c641d:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c6423:	eb 10                	jmp    8c6435 <check_lower_drain+0x2ca5>
  8c6425:	41 83 fb 3b          	cmp    $0x3b,%r11d
  8c6429:	0f 85 c1 00 00 00    	jne    8c64f0 <check_lower_drain+0x2d60>
  8c642f:	41 b8 58 00 00 00    	mov    $0x58,%r8d
  8c6435:	48 89 df             	mov    %rbx,%rdi
  8c6438:	89 ee                	mov    %ebp,%esi
  8c643a:	31 d2                	xor    %edx,%edx
  8c643c:	31 c9                	xor    %ecx,%ecx
  8c643e:	c5 f8 77             	vzeroupper
  8c6441:	e8 3a 29 01 00       	call   8d8d80 <check_lower_operand>
  8c6446:	e9 1e 20 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c644b:	48 8b 07             	mov    (%rdi),%rax
  8c644e:	e9 f3 1f 00 00       	jmp    8c8446 <check_lower_drain+0x4cb6>
  8c6453:	40 80 fe 0a          	cmp    $0xa,%sil
  8c6457:	4c 8d 05 e5 2f dc ff 	lea    -0x23d01b(%rip),%r8        # 689443 <fuzz_comment_end+0x26c80>
  8c645e:	48 8d 0d 73 c8 d0 ff 	lea    -0x2f378d(%rip),%rcx        # 5d2cd8 <parse_test_openers+0x6bc3>
  8c6465:	e9 fa d9 ff ff       	jmp    8c3e64 <check_lower_drain+0x6d4>
  8c646a:	4c 01 f0             	add    %r14,%rax
  8c646d:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6471:	83 78 04 01          	cmpl   $0x1,0x4(%rax)
  8c6475:	0f 85 0e 01 00 00    	jne    8c6589 <check_lower_drain+0x2df9>
  8c647b:	f6 44 24 40 01       	testb  $0x1,0x40(%rsp)
  8c6480:	75 21                	jne    8c64a3 <check_lower_drain+0x2d13>
  8c6482:	40 0f b6 d6          	movzbl %sil,%edx
  8c6486:	be 0a 00 00 00       	mov    $0xa,%esi
  8c648b:	48 89 df             	mov    %rbx,%rdi
  8c648e:	31 c9                	xor    %ecx,%ecx
  8c6490:	4d 89 dd             	mov    %r11,%r13
  8c6493:	c5 f8 77             	vzeroupper
  8c6496:	e8 b5 28 00 00       	call   8c8d50 <check_lower_instruction>
  8c649b:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  8c64a0:	4d 89 eb             	mov    %r13,%r11
  8c64a3:	41 83 fb 41          	cmp    $0x41,%r11d
  8c64a7:	0f 85 9d 03 00 00    	jne    8c684a <check_lower_drain+0x30ba>
  8c64ad:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c64b3:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c64b9:	0f 83 e1 02 00 00    	jae    8c67a0 <check_lower_drain+0x3010>
  8c64bf:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c64c3:	8d 50 01             	lea    0x1(%rax),%edx
  8c64c6:	48 c1 e0 04          	shl    $0x4,%rax
  8c64ca:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c64d0:	48 ba 01 00 00 00 01 	movabs $0x8000100000001,%rdx
  8c64d7:	00 08 00 
  8c64da:	48 83 c2 14          	add    $0x14,%rdx
  8c64de:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c64e2:	48 c7 44 01 08 01 00 	movq   $0x1,0x8(%rcx,%rax,1)
  8c64e9:	00 00 
  8c64eb:	e9 da 02 00 00       	jmp    8c67ca <check_lower_drain+0x303a>
  8c64f0:	41 8d 7b cb          	lea    -0x35(%r11),%edi
  8c64f4:	83 ff 01             	cmp    $0x1,%edi
  8c64f7:	0f 87 bc 00 00 00    	ja     8c65b9 <check_lower_drain+0x2e29>
  8c64fd:	48 89 df             	mov    %rbx,%rdi
  8c6500:	89 ee                	mov    %ebp,%esi
  8c6502:	c5 f8 77             	vzeroupper
  8c6505:	e8 66 34 01 00       	call   8d9970 <check_lower_builtin_prepare>
  8c650a:	e9 5a 1f 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c650f:	41 83 7c 24 04 01    	cmpl   $0x1,0x4(%r12)
  8c6515:	48 89 c7             	mov    %rax,%rdi
  8c6518:	49 89 ce             	mov    %rcx,%r14
  8c651b:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c651f:	0f 94 c0             	sete   %al
  8c6522:	85 f6                	test   %esi,%esi
  8c6524:	0f 95 c1             	setne  %cl
  8c6527:	20 c1                	and    %al,%cl
  8c6529:	80 f9 01             	cmp    $0x1,%cl
  8c652c:	0f 85 c6 00 00 00    	jne    8c65f8 <check_lower_drain+0x2e68>
  8c6532:	8b 87 c0 00 00 00    	mov    0xc0(%rdi),%eax
  8c6538:	39 c6                	cmp    %eax,%esi
  8c653a:	73 17                	jae    8c6553 <check_lower_drain+0x2dc3>
  8c653c:	41 8d 4e f5          	lea    -0xb(%r14),%ecx
  8c6540:	80 f9 02             	cmp    $0x2,%cl
  8c6543:	77 0e                	ja     8c6553 <check_lower_drain+0x2dc3>
  8c6545:	48 8b 4b 68          	mov    0x68(%rbx),%rcx
  8c6549:	83 3c b1 ff          	cmpl   $0xffffffff,(%rcx,%rsi,4)
  8c654d:	0f 84 67 03 00 00    	je     8c68ba <check_lower_drain+0x312a>
  8c6553:	39 c6                	cmp    %eax,%esi
  8c6555:	0f 83 9d 00 00 00    	jae    8c65f8 <check_lower_drain+0x2e68>
  8c655b:	48 8b 43 68          	mov    0x68(%rbx),%rax
  8c655f:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c6562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c6567:	48 39 c1             	cmp    %rax,%rcx
  8c656a:	0f 84 72 03 00 00    	je     8c68e2 <check_lower_drain+0x3152>
  8c6570:	41 0f b6 d6          	movzbl %r14b,%edx
  8c6574:	be 02 00 00 00       	mov    $0x2,%esi
  8c6579:	48 89 df             	mov    %rbx,%rdi
  8c657c:	c5 f8 77             	vzeroupper
  8c657f:	e8 7c 22 00 00       	call   8c8800 <check_lower_emit>
  8c6584:	e9 e0 1e 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c6589:	45 39 d7             	cmp    %r10d,%r15d
  8c658c:	73 12                	jae    8c65a0 <check_lower_drain+0x2e10>
  8c658e:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c6595:	42 f6 04 38 02       	testb  $0x2,(%rax,%r15,1)
  8c659a:	0f 85 db fe ff ff    	jne    8c647b <check_lower_drain+0x2ceb>
  8c65a0:	48 8b 01             	mov    (%rcx),%rax
  8c65a3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c65aa:	0f 85 b9 1e 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c65b0:	48 8d 0d cd c0 e2 ff 	lea    -0x1d3f33(%rip),%rcx        # 6f2684 <pp_string_value.meaning+0x3ef3f>
  8c65b7:	eb 56                	jmp    8c660f <check_lower_drain+0x2e7f>
  8c65b9:	41 83 fb 3f          	cmp    $0x3f,%r11d
  8c65bd:	74 27                	je     8c65e6 <check_lower_drain+0x2e56>
  8c65bf:	41 83 fb 3c          	cmp    $0x3c,%r11d
  8c65c3:	0f 85 aa 01 00 00    	jne    8c6773 <check_lower_drain+0x2fe3>
  8c65c9:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c65ce:	b9 df fe ff ff       	mov    $0xfffffedf,%ecx
  8c65d3:	48 8b 40 38          	mov    0x38(%rax),%rax
  8c65d7:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c65db:	01 c8                	add    %ecx,%eax
  8c65dd:	83 f8 01             	cmp    $0x1,%eax
  8c65e0:	0f 87 80 02 00 00    	ja     8c6866 <check_lower_drain+0x30d6>
  8c65e6:	48 89 df             	mov    %rbx,%rdi
  8c65e9:	89 ee                	mov    %ebp,%esi
  8c65eb:	c5 f8 77             	vzeroupper
  8c65ee:	e8 dd 3b 01 00       	call   8da1d0 <check_lower_helper>
  8c65f3:	e9 71 1e 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c65f8:	48 8b 02             	mov    (%rdx),%rax
  8c65fb:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6602:	0f 85 61 1e 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c6608:	48 8d 0d b4 d9 e7 ff 	lea    -0x18264c(%rip),%rcx        # 743fc3 <pp_decode_file_name.meaning+0xd13d>
  8c660f:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c6616:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c661a:	48 8b 01             	mov    (%rcx),%rax
  8c661d:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6624:	0f 85 3f 1e 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c662a:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c6631:	00 00 00 
  8c6634:	e9 20 1e 00 00       	jmp    8c8459 <check_lower_drain+0x4cc9>
  8c6639:	31 d2                	xor    %edx,%edx
  8c663b:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  8c6640:	4c 0f a3 f7          	bt     %r14,%rdi
  8c6644:	0f 83 17 05 00 00    	jae    8c6b61 <check_lower_drain+0x33d1>
  8c664a:	4c 01 e9             	add    %r13,%rcx
  8c664d:	83 79 44 00          	cmpl   $0x0,0x44(%rcx)
  8c6651:	0f 85 0a 05 00 00    	jne    8c6b61 <check_lower_drain+0x33d1>
  8c6657:	49 8b 3b             	mov    (%r11),%rdi
  8c665a:	4c 89 44 24 78       	mov    %r8,0x78(%rsp)
  8c665f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8c6664:	4c 8b 2f             	mov    (%rdi),%r13
  8c6667:	47 8b 6c 85 00       	mov    0x0(%r13,%r8,4),%r13d
  8c666c:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
  8c6671:	45 85 ed             	test   %r13d,%r13d
  8c6674:	44 89 6c 24 60       	mov    %r13d,0x60(%rsp)
  8c6679:	41 0f 94 c5          	sete   %r13b
  8c667d:	41 20 d5             	and    %dl,%r13b
  8c6680:	41 80 fd 01          	cmp    $0x1,%r13b
  8c6684:	75 45                	jne    8c66cb <check_lower_drain+0x2f3b>
  8c6686:	4c 8b af 90 02 00 00 	mov    0x290(%rdi),%r13
  8c668d:	89 54 24 70          	mov    %edx,0x70(%rsp)
  8c6691:	8d 50 ff             	lea    -0x1(%rax),%edx
  8c6694:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
  8c6699:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c669e:	4c 89 6c 24 58       	mov    %r13,0x58(%rsp)
  8c66a3:	4c 8b 6c 24 58       	mov    0x58(%rsp),%r13
  8c66a8:	41 80 7c 15 00 00    	cmpb   $0x0,0x0(%r13,%rdx,1)
  8c66ae:	8b 54 24 70          	mov    0x70(%rsp),%edx
  8c66b2:	74 17                	je     8c66cb <check_lower_drain+0x2f3b>
  8c66b4:	48 8b bf 78 02 00 00 	mov    0x278(%rdi),%rdi
  8c66bb:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
  8c66c0:	42 80 3c 2f 00       	cmpb   $0x0,(%rdi,%r13,1)
  8c66c5:	0f 84 96 04 00 00    	je     8c6b61 <check_lower_drain+0x33d1>
  8c66cb:	44 8b 69 0c          	mov    0xc(%rcx),%r13d
  8c66cf:	45 85 ed             	test   %r13d,%r13d
  8c66d2:	74 1c                	je     8c66f0 <check_lower_drain+0x2f60>
  8c66d4:	83 79 54 00          	cmpl   $0x0,0x54(%rcx)
  8c66d8:	75 16                	jne    8c66f0 <check_lower_drain+0x2f60>
  8c66da:	0f b7 79 08          	movzwl 0x8(%rcx),%edi
  8c66de:	f7 c7 10 08 00 00    	test   $0x810,%edi
  8c66e4:	75 0a                	jne    8c66f0 <check_lower_drain+0x2f60>
  8c66e6:	83 79 04 00          	cmpl   $0x0,0x4(%rcx)
  8c66ea:	0f 84 4e 04 00 00    	je     8c6b3e <check_lower_drain+0x33ae>
  8c66f0:	83 7c 24 60 00       	cmpl   $0x0,0x60(%rsp)
  8c66f5:	0f 85 66 04 00 00    	jne    8c6b61 <check_lower_drain+0x33d1>
  8c66fb:	83 79 04 01          	cmpl   $0x1,0x4(%rcx)
  8c66ff:	0f 94 c1             	sete   %cl
  8c6702:	20 d1                	and    %dl,%cl
  8c6704:	80 f9 01             	cmp    $0x1,%cl
  8c6707:	0f 85 54 04 00 00    	jne    8c6b61 <check_lower_drain+0x33d1>
  8c670d:	48 8b 4b 68          	mov    0x68(%rbx),%rcx
  8c6711:	49 8b 93 80 00 00 00 	mov    0x80(%r11),%rdx
  8c6718:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  8c671b:	8b 04 82             	mov    (%rdx,%rax,4),%eax
  8c671e:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8c6721:	41 0f 94 c5          	sete   %r13b
  8c6725:	45 00 ed             	add    %r13b,%r13b
  8c6728:	41 80 c5 02          	add    $0x2,%r13b
  8c672c:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8c672f:	0f 44 c8             	cmove  %eax,%ecx
  8c6732:	75 0d                	jne    8c6741 <check_lower_drain+0x2fb1>
  8c6734:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
  8c6739:	85 c0                	test   %eax,%eax
  8c673b:	0f 84 20 04 00 00    	je     8c6b61 <check_lower_drain+0x33d1>
  8c6741:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c6746:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c674b:	41 0f b6 f5          	movzbl %r13b,%esi
  8c674f:	48 89 df             	mov    %rbx,%rdi
  8c6752:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c6756:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  8c6759:	8b 94 24 88 00 00 00 	mov    0x88(%rsp),%edx
  8c6760:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c6766:	c5 f8 77             	vzeroupper
  8c6769:	e8 92 20 00 00       	call   8c8800 <check_lower_emit>
  8c676e:	e9 9e 19 00 00       	jmp    8c8111 <check_lower_drain+0x4981>
  8c6773:	41 8d 7b be          	lea    -0x42(%r11),%edi
  8c6777:	83 ff 02             	cmp    $0x2,%edi
  8c677a:	0f 87 f8 00 00 00    	ja     8c6878 <check_lower_drain+0x30e8>
  8c6780:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6784:	48 8b 00             	mov    (%rax),%rax
  8c6787:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c678e:	0f 85 d5 1c 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c6794:	48 8d 0d fb 76 da ff 	lea    -0x258905(%rip),%rcx        # 66de96 <fuzz_comment_end+0xb6d3>
  8c679b:	e9 6f fe ff ff       	jmp    8c660f <check_lower_drain+0x2e7f>
  8c67a0:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c67a4:	48 8b 00             	mov    (%rax),%rax
  8c67a7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c67ae:	75 1a                	jne    8c67ca <check_lower_drain+0x303a>
  8c67b0:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c67b7:	00 00 00 
  8c67ba:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c67c0:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c67c4:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c67ca:	48 8b 57 20          	mov    0x20(%rdi),%rdx
  8c67ce:	48 8b 37             	mov    (%rdi),%rsi
  8c67d1:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
  8c67d5:	42 8b 04 ba          	mov    (%rdx,%r15,4),%eax
  8c67d9:	c1 e8 03             	shr    $0x3,%eax
  8c67dc:	80 3c 06 0f          	cmpb   $0xf,(%rsi,%rax,1)
  8c67e0:	75 06                	jne    8c67e8 <check_lower_drain+0x3058>
  8c67e2:	8b 04 82             	mov    (%rdx,%rax,4),%eax
  8c67e5:	c1 e8 03             	shr    $0x3,%eax
  8c67e8:	8b 93 3c 01 00 00    	mov    0x13c(%rbx),%edx
  8c67ee:	3b 93 40 01 00 00    	cmp    0x140(%rbx),%edx
  8c67f4:	73 2a                	jae    8c6820 <check_lower_drain+0x3090>
  8c67f6:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8c67fa:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  8c67fe:	8d 72 01             	lea    0x1(%rdx),%esi
  8c6801:	48 c1 e2 04          	shl    $0x4,%rdx
  8c6805:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c680b:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c6812:	00 08 00 
  8c6815:	48 89 34 17          	mov    %rsi,(%rdi,%rdx,1)
  8c6819:	48 89 44 17 08       	mov    %rax,0x8(%rdi,%rdx,1)
  8c681e:	eb 2a                	jmp    8c684a <check_lower_drain+0x30ba>
  8c6820:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6824:	48 8b 00             	mov    (%rax),%rax
  8c6827:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c682e:	75 1a                	jne    8c684a <check_lower_drain+0x30ba>
  8c6830:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6837:	00 00 00 
  8c683a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6840:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6844:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c684a:	49 8b 44 24 08       	mov    0x8(%r12),%rax
  8c684f:	31 c9                	xor    %ecx,%ecx
  8c6851:	48 89 df             	mov    %rbx,%rdi
  8c6854:	89 ee                	mov    %ebp,%esi
  8c6856:	42 83 7c 30 04 01    	cmpl   $0x1,0x4(%rax,%r14,1)
  8c685c:	0f 94 c1             	sete   %cl
  8c685f:	31 d2                	xor    %edx,%edx
  8c6861:	e9 71 fa ff ff       	jmp    8c62d7 <check_lower_drain+0x2b47>
  8c6866:	48 89 df             	mov    %rbx,%rdi
  8c6869:	89 ee                	mov    %ebp,%esi
  8c686b:	c5 f8 77             	vzeroupper
  8c686e:	e8 cd 42 01 00       	call   8dab40 <check_lower_miscellaneous_prepare>
  8c6873:	e9 f1 1b 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c6878:	41 8d 7b e7          	lea    -0x19(%r11),%edi
  8c687c:	44 89 54 24 70       	mov    %r10d,0x70(%rsp)
  8c6881:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  8c6886:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
  8c688b:	4c 89 5c 24 30       	mov    %r11,0x30(%rsp)
  8c6890:	83 ff 25             	cmp    $0x25,%edi
  8c6893:	0f 87 b8 01 00 00    	ja     8c6a51 <check_lower_drain+0x32c1>
  8c6899:	4c 8d 05 2c 0b be ff 	lea    -0x41f4d4(%rip),%r8        # 4a73cc <cbuiltin_test_generated.edges+0xad3c>
  8c68a0:	49 63 3c b8          	movslq (%r8,%rdi,4),%rdi
  8c68a4:	4c 01 c7             	add    %r8,%rdi
  8c68a7:	ff e7                	jmp    *%rdi
  8c68a9:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c68ae:	48 89 df             	mov    %rbx,%rdi
  8c68b1:	89 ee                	mov    %ebp,%esi
  8c68b3:	31 d2                	xor    %edx,%edx
  8c68b5:	e9 1d fa ff ff       	jmp    8c62d7 <check_lower_drain+0x2b47>
  8c68ba:	49 8b 54 24 48       	mov    0x48(%r12),%rdx
  8c68bf:	48 89 df             	mov    %rbx,%rdi
  8c68c2:	c5 f8 77             	vzeroupper
  8c68c5:	e8 16 7d 00 00       	call   8ce5e0 <check_lower_address>
  8c68ca:	41 0f b6 d6          	movzbl %r14b,%edx
  8c68ce:	be 0a 00 00 00       	mov    $0xa,%esi
  8c68d3:	48 89 df             	mov    %rbx,%rdi
  8c68d6:	31 c9                	xor    %ecx,%ecx
  8c68d8:	e8 23 1f 00 00       	call   8c8800 <check_lower_emit>
  8c68dd:	e9 87 1b 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c68e2:	48 8b 87 80 00 00 00 	mov    0x80(%rdi),%rax
  8c68e9:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c68ec:	48 85 c9             	test   %rcx,%rcx
  8c68ef:	0f 84 4a 1b 00 00    	je     8c843f <check_lower_drain+0x4caf>
  8c68f5:	41 0f b6 d6          	movzbl %r14b,%edx
  8c68f9:	be 04 00 00 00       	mov    $0x4,%esi
  8c68fe:	48 89 df             	mov    %rbx,%rdi
  8c6901:	c5 f8 77             	vzeroupper
  8c6904:	e8 f7 1e 00 00       	call   8c8800 <check_lower_emit>
  8c6909:	e9 5b 1b 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c690e:	4d 8b 66 60          	mov    0x60(%r14),%r12
  8c6912:	41 8b b6 b4 00 00 00 	mov    0xb4(%r14),%esi
  8c6919:	ba 00 01 00 00       	mov    $0x100,%edx
  8c691e:	89 e9                	mov    %ebp,%ecx
  8c6920:	4c 89 e7             	mov    %r12,%rdi
  8c6923:	c5 f8 77             	vzeroupper
  8c6926:	e8 a5 60 fc ff       	call   88c9d0 <check_program_builtin_index>
  8c692b:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c692e:	0f 84 5e 01 00 00    	je     8c6a92 <check_lower_drain+0x3302>
  8c6934:	4d 85 e4             	test   %r12,%r12
  8c6937:	0f 84 55 01 00 00    	je     8c6a92 <check_lower_drain+0x3302>
  8c693d:	89 c0                	mov    %eax,%eax
  8c693f:	48 c1 e0 08          	shl    $0x8,%rax
  8c6943:	49 01 c4             	add    %rax,%r12
  8c6946:	41 83 bc 24 d0 00 00 	cmpl   $0x0,0xd0(%r12)
  8c694d:	00 00 
  8c694f:	0f 84 3d 01 00 00    	je     8c6a92 <check_lower_drain+0x3302>
  8c6955:	41 83 bc 24 f0 00 00 	cmpl   $0x0,0xf0(%r12)
  8c695c:	00 00 
  8c695e:	0f 84 2e 01 00 00    	je     8c6a92 <check_lower_drain+0x3302>
  8c6964:	48 89 df             	mov    %rbx,%rdi
  8c6967:	89 ee                	mov    %ebp,%esi
  8c6969:	4c 89 e2             	mov    %r12,%rdx
  8c696c:	e8 5f 45 01 00       	call   8daed0 <check_lower_math>
  8c6971:	e9 f3 1a 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c6976:	8b 44 24 68          	mov    0x68(%rsp),%eax
  8c697a:	0a 44 24 40          	or     0x40(%rsp),%al
  8c697e:	a8 01                	test   $0x1,%al
  8c6980:	75 17                	jne    8c6999 <check_lower_drain+0x3209>
  8c6982:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c6987:	be 0a 00 00 00       	mov    $0xa,%esi
  8c698c:	48 89 df             	mov    %rbx,%rdi
  8c698f:	31 c9                	xor    %ecx,%ecx
  8c6991:	c5 f8 77             	vzeroupper
  8c6994:	e8 b7 23 00 00       	call   8c8d50 <check_lower_instruction>
  8c6999:	4c 8b 44 24 48       	mov    0x48(%rsp),%r8
  8c699e:	48 89 df             	mov    %rbx,%rdi
  8c69a1:	89 ee                	mov    %ebp,%esi
  8c69a3:	31 d2                	xor    %edx,%edx
  8c69a5:	31 c9                	xor    %ecx,%ecx
  8c69a7:	c5 f8 77             	vzeroupper
  8c69aa:	e8 d1 23 01 00       	call   8d8d80 <check_lower_operand>
  8c69af:	e9 b5 1a 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c69b4:	4d 8b 66 68          	mov    0x68(%r14),%r12
  8c69b8:	41 8b b6 b8 00 00 00 	mov    0xb8(%r14),%esi
  8c69bf:	ba b0 00 00 00       	mov    $0xb0,%edx
  8c69c4:	89 e9                	mov    %ebp,%ecx
  8c69c6:	4c 89 e7             	mov    %r12,%rdi
  8c69c9:	c5 f8 77             	vzeroupper
  8c69cc:	e8 ff 5f fc ff       	call   88c9d0 <check_program_builtin_index>
  8c69d1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c69d4:	0f 84 65 1a 00 00    	je     8c843f <check_lower_drain+0x4caf>
  8c69da:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  8c69df:	89 c1                	mov    %eax,%ecx
  8c69e1:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c69e8:	49 01 cc             	add    %rcx,%r12
  8c69eb:	48 8b 0a             	mov    (%rdx),%rcx
  8c69ee:	48 8b 51 38          	mov    0x38(%rcx),%rdx
  8c69f2:	b1 01                	mov    $0x1,%cl
  8c69f4:	42 81 3c ba 30 01 00 	cmpl   $0x130,(%rdx,%r15,4)
  8c69fb:	00 
  8c69fc:	75 10                	jne    8c6a0e <check_lower_drain+0x327e>
  8c69fe:	41 8b 8c 24 8c 00 00 	mov    0x8c(%r12),%ecx
  8c6a05:	00 
  8c6a06:	ff c9                	dec    %ecx
  8c6a08:	83 f9 02             	cmp    $0x2,%ecx
  8c6a0b:	0f 92 c1             	setb   %cl
  8c6a0e:	84 c9                	test   %cl,%cl
  8c6a10:	74 1f                	je     8c6a31 <check_lower_drain+0x32a1>
  8c6a12:	41 83 bc 24 a0 00 00 	cmpl   $0x0,0xa0(%r12)
  8c6a19:	00 00 
  8c6a1b:	75 14                	jne    8c6a31 <check_lower_drain+0x32a1>
  8c6a1d:	41 83 7c 24 1c 00    	cmpl   $0x0,0x1c(%r12)
  8c6a23:	74 0c                	je     8c6a31 <check_lower_drain+0x32a1>
  8c6a25:	41 83 7c 24 64 00    	cmpl   $0x0,0x64(%r12)
  8c6a2b:	0f 84 b3 07 00 00    	je     8c71e4 <check_lower_drain+0x3a54>
  8c6a31:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6a35:	48 8b 00             	mov    (%rax),%rax
  8c6a38:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6a3f:	0f 85 24 1a 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c6a45:	48 8d 0d ee bb e2 ff 	lea    -0x1d4412(%rip),%rcx        # 6f263a <pp_string_value.meaning+0x3eef5>
  8c6a4c:	e9 be fb ff ff       	jmp    8c660f <check_lower_drain+0x2e7f>
  8c6a51:	83 fe 20             	cmp    $0x20,%esi
  8c6a54:	75 62                	jne    8c6ab8 <check_lower_drain+0x3328>
  8c6a56:	83 7c 24 30 21       	cmpl   $0x21,0x30(%rsp)
  8c6a5b:	0f 85 83 04 00 00    	jne    8c6ee4 <check_lower_drain+0x3754>
  8c6a61:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8c6a66:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8c6a6b:	48 8b 01             	mov    (%rcx),%rax
  8c6a6e:	89 f2                	mov    %esi,%edx
  8c6a70:	c1 ea 03             	shr    $0x3,%edx
  8c6a73:	48 8b 49 20          	mov    0x20(%rcx),%rcx
  8c6a77:	83 e6 07             	and    $0x7,%esi
  8c6a7a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8c6a7e:	04 f8                	add    $0xf8,%al
  8c6a80:	3c 03                	cmp    $0x3,%al
  8c6a82:	b8 00 00 00 00       	mov    $0x0,%eax
  8c6a87:	0f 43 f0             	cmovae %eax,%esi
  8c6a8a:	0b 34 91             	or     (%rcx,%rdx,4),%esi
  8c6a8d:	e9 66 04 00 00       	jmp    8c6ef8 <check_lower_drain+0x3768>
  8c6a92:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6a97:	48 8b 40 38          	mov    0x38(%rax),%rax
  8c6a9b:	42 81 3c b8 52 01 00 	cmpl   $0x152,(%rax,%r15,4)
  8c6aa2:	00 
  8c6aa3:	0f 84 3d fb ff ff    	je     8c65e6 <check_lower_drain+0x2e56>
  8c6aa9:	48 89 df             	mov    %rbx,%rdi
  8c6aac:	89 ee                	mov    %ebp,%esi
  8c6aae:	e8 3d 4a 01 00       	call   8db4f0 <check_lower_floating_prepare>
  8c6ab3:	e9 b1 19 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c6ab8:	45 8b 04 24          	mov    (%r12),%r8d
  8c6abc:	83 7c 24 30 24       	cmpl   $0x24,0x30(%rsp)
  8c6ac1:	0f 87 c8 04 00 00    	ja     8c6f8f <check_lower_drain+0x37ff>
  8c6ac7:	8b 7c 24 30          	mov    0x30(%rsp),%edi
  8c6acb:	41 b9 f4 01 00 00    	mov    $0x1f4,%r9d
  8c6ad1:	49 0f a3 f9          	bt     %rdi,%r9
  8c6ad5:	0f 83 a0 04 00 00    	jae    8c6f7b <check_lower_drain+0x37eb>
  8c6adb:	44 89 c6             	mov    %r8d,%esi
  8c6ade:	c1 ee 03             	shr    $0x3,%esi
  8c6ae1:	3b 74 24 70          	cmp    0x70(%rsp),%esi
  8c6ae5:	73 1b                	jae    8c6b02 <check_lower_drain+0x3372>
  8c6ae7:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c6aee:	89 f6                	mov    %esi,%esi
  8c6af0:	f6 04 30 02          	testb  $0x2,(%rax,%rsi,1)
  8c6af4:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  8c6afb:	00 
  8c6afc:	0f 85 73 05 00 00    	jne    8c7075 <check_lower_drain+0x38e5>
  8c6b02:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c6b07:	8d 71 fe             	lea    -0x2(%rcx),%esi
  8c6b0a:	83 fe 23             	cmp    $0x23,%esi
  8c6b0d:	0f 87 d8 07 00 00    	ja     8c72eb <check_lower_drain+0x3b5b>
  8c6b13:	48 8d 3d 4a 09 be ff 	lea    -0x41f6b6(%rip),%rdi        # 4a7464 <cbuiltin_test_generated.edges+0xadd4>
  8c6b1a:	48 63 34 b7          	movslq (%rdi,%rsi,4),%rsi
  8c6b1e:	48 01 fe             	add    %rdi,%rsi
  8c6b21:	ff e6                	jmp    *%rsi
  8c6b23:	31 f6                	xor    %esi,%esi
  8c6b25:	83 7c 24 30 02       	cmpl   $0x2,0x30(%rsp)
  8c6b2a:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c6b2f:	48 89 df             	mov    %rbx,%rdi
  8c6b32:	40 0f 95 c6          	setne  %sil
  8c6b36:	83 c6 07             	add    $0x7,%esi
  8c6b39:	e9 51 fe ff ff       	jmp    8c698f <check_lower_drain+0x31ff>
  8c6b3e:	83 7c 24 60 3e       	cmpl   $0x3e,0x60(%rsp)
  8c6b43:	0f 87 08 06 00 00    	ja     8c7151 <check_lower_drain+0x39c1>
  8c6b49:	8b 44 24 60          	mov    0x60(%rsp),%eax
  8c6b4d:	48 ba 00 00 00 00 08 	movabs $0x4080000800000000,%rdx
  8c6b54:	00 80 40 
  8c6b57:	48 0f a3 c2          	bt     %rax,%rdx
  8c6b5b:	0f 83 f0 05 00 00    	jae    8c7151 <check_lower_drain+0x39c1>
  8c6b61:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c6b66:	45 31 d2             	xor    %r10d,%r10d
  8c6b69:	8d 79 fb             	lea    -0x5(%rcx),%edi
  8c6b6c:	83 f9 23             	cmp    $0x23,%ecx
  8c6b6f:	7f 1b                	jg     8c6b8c <check_lower_drain+0x33fc>
  8c6b71:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6b76:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c6b7b:	83 f9 01             	cmp    $0x1,%ecx
  8c6b7e:	74 3e                	je     8c6bbe <check_lower_drain+0x342e>
  8c6b80:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6b85:	83 f9 18             	cmp    $0x18,%ecx
  8c6b88:	74 34                	je     8c6bbe <check_lower_drain+0x342e>
  8c6b8a:	eb 19                	jmp    8c6ba5 <check_lower_drain+0x3415>
  8c6b8c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6b91:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c6b96:	83 f9 24             	cmp    $0x24,%ecx
  8c6b99:	74 23                	je     8c6bbe <check_lower_drain+0x342e>
  8c6b9b:	83 f9 34             	cmp    $0x34,%ecx
  8c6b9e:	75 05                	jne    8c6ba5 <check_lower_drain+0x3415>
  8c6ba0:	45 31 db             	xor    %r11d,%r11d
  8c6ba3:	eb 3f                	jmp    8c6be4 <check_lower_drain+0x3454>
  8c6ba5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c6baa:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8c6bae:	48 89 d0             	mov    %rdx,%rax
  8c6bb1:	48 c1 e0 05          	shl    $0x5,%rax
  8c6bb5:	48 03 41 10          	add    0x10(%rcx),%rax
  8c6bb9:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c6bbe:	44 8b 18             	mov    (%rax),%r11d
  8c6bc1:	83 ff 0f             	cmp    $0xf,%edi
  8c6bc4:	77 1e                	ja     8c6be4 <check_lower_drain+0x3454>
  8c6bc6:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c6bcb:	48 89 d1             	mov    %rdx,%rcx
  8c6bce:	48 c1 e1 05          	shl    $0x5,%rcx
  8c6bd2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c6bd6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8c6bda:	44 8b 54 08 08       	mov    0x8(%rax,%rcx,1),%r10d
  8c6bdf:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c6be4:	c4 e2 cb f7 44 24 50 	shrx   %rsi,0x50(%rsp),%rax
  8c6beb:	a8 01                	test   $0x1,%al
  8c6bed:	0f 84 68 db ff ff    	je     8c475b <check_lower_drain+0xfcb>
  8c6bf3:	45 84 c9             	test   %r9b,%r9b
  8c6bf6:	0f 84 5f db ff ff    	je     8c475b <check_lower_drain+0xfcb>
  8c6bfc:	41 0f b6 f1          	movzbl %r9b,%esi
  8c6c00:	81 fe fe 00 00 00    	cmp    $0xfe,%esi
  8c6c06:	0f 84 4f db ff ff    	je     8c475b <check_lower_drain+0xfcb>
  8c6c0c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6c11:	83 78 44 00          	cmpl   $0x0,0x44(%rax)
  8c6c15:	0f 85 40 db ff ff    	jne    8c475b <check_lower_drain+0xfcb>
  8c6c1b:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6c20:	83 78 0c 00          	cmpl   $0x0,0xc(%rax)
  8c6c24:	74 43                	je     8c6c69 <check_lower_drain+0x34d9>
  8c6c26:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6c2b:	83 78 54 00          	cmpl   $0x0,0x54(%rax)
  8c6c2f:	75 38                	jne    8c6c69 <check_lower_drain+0x34d9>
  8c6c31:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6c36:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8c6c3a:	a9 10 08 00 00       	test   $0x810,%eax
  8c6c3f:	75 28                	jne    8c6c69 <check_lower_drain+0x34d9>
  8c6c41:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6c46:	83 78 04 00          	cmpl   $0x0,0x4(%rax)
  8c6c4a:	75 1d                	jne    8c6c69 <check_lower_drain+0x34d9>
  8c6c4c:	83 f9 3e             	cmp    $0x3e,%ecx
  8c6c4f:	0f 87 06 db ff ff    	ja     8c475b <check_lower_drain+0xfcb>
  8c6c55:	48 b8 00 00 00 00 08 	movabs $0x4080000800000000,%rax
  8c6c5c:	00 80 40 
  8c6c5f:	48 0f a3 c8          	bt     %rcx,%rax
  8c6c63:	0f 83 f2 da ff ff    	jae    8c475b <check_lower_drain+0xfcb>
  8c6c69:	8b 83 b0 01 00 00    	mov    0x1b0(%rbx),%eax
  8c6c6f:	44 89 da             	mov    %r11d,%edx
  8c6c72:	c1 ea 03             	shr    $0x3,%edx
  8c6c75:	b9 ff 00 00 00       	mov    $0xff,%ecx
  8c6c7a:	44 89 54 24 40       	mov    %r10d,0x40(%rsp)
  8c6c7f:	89 7c 24 28          	mov    %edi,0x28(%rsp)
  8c6c83:	4d 89 f2             	mov    %r14,%r10
  8c6c86:	4c 89 44 24 78       	mov    %r8,0x78(%rsp)
  8c6c8b:	39 c2                	cmp    %eax,%edx
  8c6c8d:	73 0c                	jae    8c6c9b <check_lower_drain+0x350b>
  8c6c8f:	48 8b 8b a8 01 00 00 	mov    0x1a8(%rbx),%rcx
  8c6c96:	89 d2                	mov    %edx,%edx
  8c6c98:	8b 0c 91             	mov    (%rcx,%rdx,4),%ecx
  8c6c9b:	44 89 5c 24 48       	mov    %r11d,0x48(%rsp)
  8c6ca0:	45 85 db             	test   %r11d,%r11d
  8c6ca3:	74 69                	je     8c6d0e <check_lower_drain+0x357e>
  8c6ca5:	44 8b 44 24 28       	mov    0x28(%rsp),%r8d
  8c6caa:	31 d2                	xor    %edx,%edx
  8c6cac:	0f b6 f9             	movzbl %cl,%edi
  8c6caf:	41 83 f8 02          	cmp    $0x2,%r8d
  8c6cb3:	0f 92 c2             	setb   %dl
  8c6cb6:	41 83 f8 10          	cmp    $0x10,%r8d
  8c6cba:	41 0f 93 c3          	setae  %r11b
  8c6cbe:	c1 e2 0b             	shl    $0xb,%edx
  8c6cc1:	81 ca 00 07 00 00    	or     $0x700,%edx
  8c6cc7:	83 ff 0b             	cmp    $0xb,%edi
  8c6cca:	40 0f 92 c7          	setb   %dil
  8c6cce:	85 d1                	test   %edx,%ecx
  8c6cd0:	0f 94 c1             	sete   %cl
  8c6cd3:	40 20 f9             	and    %dil,%cl
  8c6cd6:	80 f9 01             	cmp    $0x1,%cl
  8c6cd9:	75 06                	jne    8c6ce1 <check_lower_drain+0x3551>
  8c6cdb:	41 83 f8 10          	cmp    $0x10,%r8d
  8c6cdf:	72 3d                	jb     8c6d1e <check_lower_drain+0x358e>
  8c6ce1:	84 c9                	test   %cl,%cl
  8c6ce3:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c6ce8:	0f 84 6d da ff ff    	je     8c475b <check_lower_drain+0xfcb>
  8c6cee:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c6cf3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8c6cf7:	44 8b 2c 88          	mov    (%rax,%rcx,4),%r13d
  8c6cfb:	41 83 f8 0f          	cmp    $0xf,%r8d
  8c6cff:	76 7c                	jbe    8c6d7d <check_lower_drain+0x35ed>
  8c6d01:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c6d06:	45 31 c9             	xor    %r9d,%r9d
  8c6d09:	e9 a2 00 00 00       	jmp    8c6db0 <check_lower_drain+0x3620>
  8c6d0e:	45 31 c9             	xor    %r9d,%r9d
  8c6d11:	83 7c 24 28 10       	cmpl   $0x10,0x28(%rsp)
  8c6d16:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8c6d1c:	73 78                	jae    8c6d96 <check_lower_drain+0x3606>
  8c6d1e:	8b 54 24 40          	mov    0x40(%rsp),%edx
  8c6d22:	b9 ff 00 00 00       	mov    $0xff,%ecx
  8c6d27:	c1 ea 03             	shr    $0x3,%edx
  8c6d2a:	39 c2                	cmp    %eax,%edx
  8c6d2c:	73 0c                	jae    8c6d3a <check_lower_drain+0x35aa>
  8c6d2e:	48 8b 83 a8 01 00 00 	mov    0x1a8(%rbx),%rax
  8c6d35:	89 d1                	mov    %edx,%ecx
  8c6d37:	8b 0c 88             	mov    (%rax,%rcx,4),%ecx
  8c6d3a:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
  8c6d3f:	4c 8b 4c 24 38       	mov    0x38(%rsp),%r9
  8c6d44:	8b 54 24 28          	mov    0x28(%rsp),%edx
  8c6d48:	74 26                	je     8c6d70 <check_lower_drain+0x35e0>
  8c6d4a:	31 c0                	xor    %eax,%eax
  8c6d4c:	83 fa 02             	cmp    $0x2,%edx
  8c6d4f:	0f b6 f9             	movzbl %cl,%edi
  8c6d52:	0f 92 c2             	setb   %dl
  8c6d55:	83 ff 0a             	cmp    $0xa,%edi
  8c6d58:	0f 87 fd d9 ff ff    	ja     8c475b <check_lower_drain+0xfcb>
  8c6d5e:	88 d0                	mov    %dl,%al
  8c6d60:	c1 e0 0b             	shl    $0xb,%eax
  8c6d63:	0d 00 07 00 00       	or     $0x700,%eax
  8c6d68:	21 c1                	and    %eax,%ecx
  8c6d6a:	0f 85 eb d9 ff ff    	jne    8c475b <check_lower_drain+0xfcb>
  8c6d70:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c6d75:	48 8b 40 10          	mov    0x10(%rax),%rax
  8c6d79:	46 8b 2c 88          	mov    (%rax,%r9,4),%r13d
  8c6d7d:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c6d82:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c6d87:	48 8b 40 18          	mov    0x18(%rax),%rax
  8c6d8b:	44 8b 0c 88          	mov    (%rax,%rcx,4),%r9d
  8c6d8f:	b9 02 00 00 00       	mov    $0x2,%ecx
  8c6d94:	eb 1a                	jmp    8c6db0 <check_lower_drain+0x3620>
  8c6d96:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c6d9b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c6da0:	41 b3 01             	mov    $0x1,%r11b
  8c6da3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8c6da7:	44 8b 2c 88          	mov    (%rax,%rcx,4),%r13d
  8c6dab:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c6db0:	83 7c 24 28 10       	cmpl   $0x10,0x28(%rsp)
  8c6db5:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c6dbb:	41 bf 00 00 00 01    	mov    $0x1000000,%r15d
  8c6dc1:	c7 44 24 60 00 00 00 	movl   $0x0,0x60(%rsp)
  8c6dc8:	00 
  8c6dc9:	41 0f 92 c4          	setb   %r12b
  8c6dcd:	45 31 f6             	xor    %r14d,%r14d
  8c6dd0:	66 81 fe ff 00       	cmp    $0xff,%si
  8c6dd5:	0f 95 c2             	setne  %dl
  8c6dd8:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c6ddd:	44 0f 42 f8          	cmovb  %eax,%r15d
  8c6de1:	41 39 ca             	cmp    %ecx,%r10d
  8c6de4:	0f 82 bf 12 00 00    	jb     8c80a9 <check_lower_drain+0x4919>
  8c6dea:	83 7c 24 28 10       	cmpl   $0x10,0x28(%rsp)
  8c6def:	44 89 ef             	mov    %r13d,%edi
  8c6df2:	83 d7 01             	adc    $0x1,%edi
  8c6df5:	39 ef                	cmp    %ebp,%edi
  8c6df7:	0f 85 ac 12 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c6dfd:	83 7c 24 28 0f       	cmpl   $0xf,0x28(%rsp)
  8c6e02:	77 0c                	ja     8c6e10 <check_lower_drain+0x3680>
  8c6e04:	41 8d 79 01          	lea    0x1(%r9),%edi
  8c6e08:	39 ef                	cmp    %ebp,%edi
  8c6e0a:	0f 85 99 12 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c6e10:	83 7c 24 48 00       	cmpl   $0x0,0x48(%rsp)
  8c6e15:	8b 7c 24 60          	mov    0x60(%rsp),%edi
  8c6e19:	44 88 e7             	mov    %r12b,%dil
  8c6e1c:	89 7c 24 60          	mov    %edi,0x60(%rsp)
  8c6e20:	74 1e                	je     8c6e40 <check_lower_drain+0x36b0>
  8c6e22:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
  8c6e27:	8b 7c 24 60          	mov    0x60(%rsp),%edi
  8c6e2b:	f7 d7                	not    %edi
  8c6e2d:	44 8b 64 24 48       	mov    0x48(%rsp),%r12d
  8c6e32:	44 01 d7             	add    %r10d,%edi
  8c6e35:	45 3b 64 b8 40       	cmp    0x40(%r8,%rdi,4),%r12d
  8c6e3a:	0f 85 69 12 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c6e40:	83 7c 24 28 0f       	cmpl   $0xf,0x28(%rsp)
  8c6e45:	77 20                	ja     8c6e67 <check_lower_drain+0x36d7>
  8c6e47:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
  8c6e4c:	74 19                	je     8c6e67 <check_lower_drain+0x36d7>
  8c6e4e:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
  8c6e53:	41 8d 7a ff          	lea    -0x1(%r10),%edi
  8c6e57:	44 8b 64 24 40       	mov    0x40(%rsp),%r12d
  8c6e5c:	45 3b 64 b8 40       	cmp    0x40(%r8,%rdi,4),%r12d
  8c6e61:	0f 85 42 12 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c6e67:	44 8b a3 38 01 00 00 	mov    0x138(%rbx),%r12d
  8c6e6e:	45 29 e7             	sub    %r12d,%r15d
  8c6e71:	0f 82 32 12 00 00    	jb     8c80a9 <check_lower_drain+0x4919>
  8c6e77:	41 88 d6             	mov    %dl,%r14b
  8c6e7a:	41 01 ce             	add    %ecx,%r14d
  8c6e7d:	45 39 fe             	cmp    %r15d,%r14d
  8c6e80:	0f 87 23 12 00 00    	ja     8c80a9 <check_lower_drain+0x4919>
  8c6e86:	2b 83 3c 01 00 00    	sub    0x13c(%rbx),%eax
  8c6e8c:	0f 93 c2             	setae  %dl
  8c6e8f:	83 f8 05             	cmp    $0x5,%eax
  8c6e92:	0f 93 c0             	setae  %al
  8c6e95:	20 d0                	and    %dl,%al
  8c6e97:	3c 01                	cmp    $0x1,%al
  8c6e99:	0f 85 0a 12 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c6e9f:	48 8b 03             	mov    (%rbx),%rax
  8c6ea2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8c6ea7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c6eab:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8c6eaf:	44 89 e8             	mov    %r13d,%eax
  8c6eb2:	4c 8d 34 40          	lea    (%rax,%rax,2),%r14
  8c6eb6:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  8c6ebb:	49 c1 e6 05          	shl    $0x5,%r14
  8c6ebf:	42 8b 44 32 40       	mov    0x40(%rdx,%r14,1),%eax
  8c6ec4:	49 89 d0             	mov    %rdx,%r8
  8c6ec7:	48 85 c0             	test   %rax,%rax
  8c6eca:	0f 84 f9 06 00 00    	je     8c75c9 <check_lower_drain+0x3e39>
  8c6ed0:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c6ed5:	3b 82 c0 00 00 00    	cmp    0xc0(%rdx),%eax
  8c6edb:	41 0f 92 c7          	setb   %r15b
  8c6edf:	e9 e8 06 00 00       	jmp    8c75cc <check_lower_drain+0x3e3c>
  8c6ee4:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c6ee9:	49 8b 4e 08          	mov    0x8(%r14),%rcx
  8c6eed:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8c6ef1:	48 c1 e0 05          	shl    $0x5,%rax
  8c6ef5:	8b 34 01             	mov    (%rcx,%rax,1),%esi
  8c6ef8:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c6efd:	48 c7 84 24 28 02 00 	movq   $0x0,0x228(%rsp)
  8c6f04:	00 00 00 00 00 
  8c6f09:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  8c6f0e:	48 8d 8c 24 28 02 00 	lea    0x228(%rsp),%rcx
  8c6f15:	00 
  8c6f16:	48 8b 40 38          	mov    0x38(%rax),%rax
  8c6f1a:	42 8b 14 b8          	mov    (%rax,%r15,4),%edx
  8c6f1e:	c5 f8 77             	vzeroupper
  8c6f21:	e8 8a ee 91 00       	call   11e5db0 <type_find_member>
  8c6f26:	41 8b 4c 24 08       	mov    0x8(%r12),%ecx
  8c6f2b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c6f2f:	c5 f9 7f 84 24 10 02 	vmovdqa %xmm0,0x210(%rsp)
  8c6f36:	00 00 
  8c6f38:	48 c7 84 24 20 02 00 	movq   $0x0,0x220(%rsp)
  8c6f3f:	00 00 00 00 00 
  8c6f44:	85 c0                	test   %eax,%eax
  8c6f46:	74 13                	je     8c6f5b <check_lower_drain+0x37cb>
  8c6f48:	f6 c1 04             	test   $0x4,%cl
  8c6f4b:	75 62                	jne    8c6faf <check_lower_drain+0x381f>
  8c6f4d:	f6 84 24 28 02 00 00 	testb  $0x7,0x228(%rsp)
  8c6f54:	07 
  8c6f55:	0f 84 f0 02 00 00    	je     8c724b <check_lower_drain+0x3abb>
  8c6f5b:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6f5f:	48 8b 00             	mov    (%rax),%rax
  8c6f62:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6f69:	0f 85 fa 14 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c6f6f:	48 8d 0d d1 9a d5 ff 	lea    -0x2a652f(%rip),%rcx        # 620a47 <foreign_touch.flags+0x49a2>
  8c6f76:	e9 94 f6 ff ff       	jmp    8c660f <check_lower_drain+0x2e7f>
  8c6f7b:	49 b9 02 00 00 01 10 	movabs $0x1001000002,%r9
  8c6f82:	00 00 00 
  8c6f85:	49 0f a3 f9          	bt     %rdi,%r9
  8c6f89:	0f 82 0f fa ff ff    	jb     8c699e <check_lower_drain+0x320e>
  8c6f8f:	83 fe 10             	cmp    $0x10,%esi
  8c6f92:	0f 85 6a fb ff ff    	jne    8c6b02 <check_lower_drain+0x3372>
  8c6f98:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8c6f9d:	c1 ee 03             	shr    $0x3,%esi
  8c6fa0:	3b 74 24 70          	cmp    0x70(%rsp),%esi
  8c6fa4:	0f 82 3d fb ff ff    	jb     8c6ae7 <check_lower_drain+0x3357>
  8c6faa:	e9 53 fb ff ff       	jmp    8c6b02 <check_lower_drain+0x3372>
  8c6faf:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  8c6fb4:	48 8d 94 24 10 02 00 	lea    0x210(%rsp),%rdx
  8c6fbb:	00 
  8c6fbc:	89 ee                	mov    %ebp,%esi
  8c6fbe:	e8 2d 56 01 00       	call   8dc5f0 <check_lower_bit_member>
  8c6fc3:	84 c0                	test   %al,%al
  8c6fc5:	0f 84 f9 01 00 00    	je     8c71c4 <check_lower_drain+0x3a34>
  8c6fcb:	f6 44 24 40 01       	testb  $0x1,0x40(%rsp)
  8c6fd0:	0f 85 95 02 00 00    	jne    8c726b <check_lower_drain+0x3adb>
  8c6fd6:	8b 84 24 1c 02 00 00 	mov    0x21c(%rsp),%eax
  8c6fdd:	0f b6 8c 24 20 02 00 	movzbl 0x220(%rsp),%ecx
  8c6fe4:	00 
  8c6fe5:	0f b6 94 24 21 02 00 	movzbl 0x221(%rsp),%edx
  8c6fec:	00 
  8c6fed:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c6ff1:	c5 fe 7f 84 24 f0 01 	vmovdqu %ymm0,0x1f0(%rsp)
  8c6ff8:	00 00 
  8c6ffa:	c7 84 24 f0 01 00 00 	movl   $0x10,0x1f0(%rsp)
  8c7001:	10 00 00 00 
  8c7005:	48 89 df             	mov    %rbx,%rdi
  8c7008:	8d 04 c5 f8 ff ff ff 	lea    -0x8(,%rax,8),%eax
  8c700f:	0b 84 24 18 02 00 00 	or     0x218(%rsp),%eax
  8c7016:	c1 e1 09             	shl    $0x9,%ecx
  8c7019:	c1 e2 0d             	shl    $0xd,%edx
  8c701c:	09 ca                	or     %ecx,%edx
  8c701e:	09 c2                	or     %eax,%edx
  8c7020:	89 94 24 f8 01 00 00 	mov    %edx,0x1f8(%rsp)
  8c7027:	c5 fe 6f 84 24 f0 01 	vmovdqu 0x1f0(%rsp),%ymm0
  8c702e:	00 00 
  8c7030:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c7035:	c5 f8 77             	vzeroupper
  8c7038:	e8 c3 5a 00 00       	call   8ccb00 <check_lower_push>
  8c703d:	e9 29 02 00 00       	jmp    8c726b <check_lower_drain+0x3adb>
  8c7042:	31 d2                	xor    %edx,%edx
  8c7044:	83 7c 24 30 03       	cmpl   $0x3,0x30(%rsp)
  8c7049:	4c 8b 6c 24 48       	mov    0x48(%rsp),%r13
  8c704e:	48 89 df             	mov    %rbx,%rdi
  8c7051:	0f 94 c2             	sete   %dl
  8c7054:	44 89 ee             	mov    %r13d,%esi
  8c7057:	c5 f8 77             	vzeroupper
  8c705a:	e8 41 57 01 00       	call   8dc7a0 <check_lower_truth>
  8c705f:	48 89 df             	mov    %rbx,%rdi
  8c7062:	89 ee                	mov    %ebp,%esi
  8c7064:	31 d2                	xor    %edx,%edx
  8c7066:	31 c9                	xor    %ecx,%ecx
  8c7068:	45 89 e8             	mov    %r13d,%r8d
  8c706b:	e8 10 1d 01 00       	call   8d8d80 <check_lower_operand>
  8c7070:	e9 f4 13 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7075:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  8c707a:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8c707f:	c5 f8 77             	vzeroupper
  8c7082:	e8 79 78 fe ff       	call   8ae900 <check_lower_complex_element>
  8c7087:	c1 e8 03             	shr    $0x3,%eax
  8c708a:	b1 ff                	mov    $0xff,%cl
  8c708c:	3b 44 24 70          	cmp    0x70(%rsp),%eax
  8c7090:	73 0b                	jae    8c709d <check_lower_drain+0x390d>
  8c7092:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c7099:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c709d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c70a2:	49 8b 56 08          	mov    0x8(%r14),%rdx
  8c70a6:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8c70aa:	48 c1 e0 05          	shl    $0x5,%rax
  8c70ae:	8b 34 02             	mov    (%rdx,%rax,1),%esi
  8c70b1:	89 c8                	mov    %ecx,%eax
  8c70b3:	c1 ee 03             	shr    $0x3,%esi
  8c70b6:	3b 74 24 70          	cmp    0x70(%rsp),%esi
  8c70ba:	73 17                	jae    8c70d3 <check_lower_drain+0x3943>
  8c70bc:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8c70c3:	00 
  8c70c4:	f6 04 30 02          	testb  $0x2,(%rax,%rsi,1)
  8c70c8:	0f b6 c1             	movzbl %cl,%eax
  8c70cb:	be 08 00 00 00       	mov    $0x8,%esi
  8c70d0:	0f 45 c6             	cmovne %esi,%eax
  8c70d3:	83 7c 24 30 02       	cmpl   $0x2,0x30(%rsp)
  8c70d8:	74 36                	je     8c7110 <check_lower_drain+0x3980>
  8c70da:	83 7c 24 30 04       	cmpl   $0x4,0x30(%rsp)
  8c70df:	74 2f                	je     8c7110 <check_lower_drain+0x3980>
  8c70e1:	48 8b b4 24 88 00 00 	mov    0x88(%rsp),%rsi
  8c70e8:	00 
  8c70e9:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  8c70ed:	48 c1 e6 05          	shl    $0x5,%rsi
  8c70f1:	8b 14 32             	mov    (%rdx,%rsi,1),%edx
  8c70f4:	c1 ea 03             	shr    $0x3,%edx
  8c70f7:	3b 54 24 70          	cmp    0x70(%rsp),%edx
  8c70fb:	73 13                	jae    8c7110 <check_lower_drain+0x3980>
  8c70fd:	48 8b b4 24 98 00 00 	mov    0x98(%rsp),%rsi
  8c7104:	00 
  8c7105:	c6 44 24 28 08       	movb   $0x8,0x28(%rsp)
  8c710a:	f6 04 16 02          	testb  $0x2,(%rsi,%rdx,1)
  8c710e:	75 04                	jne    8c7114 <check_lower_drain+0x3984>
  8c7110:	88 4c 24 28          	mov    %cl,0x28(%rsp)
  8c7114:	44 0f b6 e8          	movzbl %al,%r13d
  8c7118:	48 89 df             	mov    %rbx,%rdi
  8c711b:	44 89 ee             	mov    %r13d,%esi
  8c711e:	e8 dd 74 ff ff       	call   8be600 <check_lower_temporary>
  8c7123:	83 7c 24 30 02       	cmpl   $0x2,0x30(%rsp)
  8c7128:	41 89 c7             	mov    %eax,%r15d
  8c712b:	0f 84 e6 02 00 00    	je     8c7417 <check_lower_drain+0x3c87>
  8c7131:	83 7c 24 30 04       	cmpl   $0x4,0x30(%rsp)
  8c7136:	44 89 f8             	mov    %r15d,%eax
  8c7139:	0f 84 db 02 00 00    	je     8c741a <check_lower_drain+0x3c8a>
  8c713f:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  8c7144:	48 89 df             	mov    %rbx,%rdi
  8c7147:	e8 b4 74 ff ff       	call   8be600 <check_lower_temporary>
  8c714c:	e9 c9 02 00 00       	jmp    8c741a <check_lower_drain+0x3c8a>
  8c7151:	41 83 fd 01          	cmp    $0x1,%r13d
  8c7155:	0f 85 06 fa ff ff    	jne    8c6b61 <check_lower_drain+0x33d1>
  8c715b:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  8c715f:	66 83 bc 24 88 00 00 	cmpw   $0x6,0x88(%rsp)
  8c7166:	00 06 
  8c7168:	41 b5 01             	mov    $0x1,%r13b
  8c716b:	0f 87 d0 f5 ff ff    	ja     8c6741 <check_lower_drain+0x2fb1>
  8c7171:	41 fe ca             	dec    %r10b
  8c7174:	ba 08 00 00 00       	mov    $0x8,%edx
  8c7179:	44 89 d0             	mov    %r10d,%eax
  8c717c:	c0 e8 07             	shr    $0x7,%al
  8c717f:	44 00 d0             	add    %r10b,%al
  8c7182:	d0 f8                	sar    $1,%al
  8c7184:	c4 e2 79 f7 c2       	shlx   %eax,%edx,%eax
  8c7189:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  8c7190:	c4 e2 f8 f5 f1       	bzhi   %rax,%rcx,%rsi
  8c7195:	0f b7 8c 24 88 00 00 	movzwl 0x88(%rsp),%ecx
  8c719c:	00 
  8c719d:	c4 e2 f9 f7 d2       	shlx   %rax,%rdx,%rdx
  8c71a2:	ff c8                	dec    %eax
  8c71a4:	c4 e2 fb f7 c6       	shrx   %rax,%rsi,%rax
  8c71a9:	48 85 c0             	test   %rax,%rax
  8c71ac:	48 0f 44 d0          	cmove  %rax,%rdx
  8c71b0:	f6 c1 01             	test   $0x1,%cl
  8c71b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c71b8:	48 0f 45 ca          	cmovne %rdx,%rcx
  8c71bc:	48 09 f1             	or     %rsi,%rcx
  8c71bf:	e9 7d f5 ff ff       	jmp    8c6741 <check_lower_drain+0x2fb1>
  8c71c4:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c71c8:	48 8b 00             	mov    (%rax),%rax
  8c71cb:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c71d2:	0f 85 91 12 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c71d8:	48 8d 0d e3 61 e4 ff 	lea    -0x1b9e1d(%rip),%rcx        # 70d3c2 <pp_string_value.meaning+0x59c7d>
  8c71df:	e9 2b f4 ff ff       	jmp    8c660f <check_lower_drain+0x2e7f>
  8c71e4:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c71e9:	45 8b 74 24 70       	mov    0x70(%r12),%r14d
  8c71ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8c71f3:	48 8b 89 a0 00 00 00 	mov    0xa0(%rcx),%rcx
  8c71fa:	46 8b 2c b9          	mov    (%rcx,%r15,4),%r13d
  8c71fe:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c7203:	41 83 fd 20          	cmp    $0x20,%r13d
  8c7207:	c4 e2 11 f7 c9       	shlx   %r13d,%ecx,%ecx
  8c720c:	0f 43 ca             	cmovae %edx,%ecx
  8c720f:	44 85 f1             	test   %r14d,%ecx
  8c7212:	0f 84 05 03 00 00    	je     8c751d <check_lower_drain+0x3d8d>
  8c7218:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c721c:	48 8b 09             	mov    (%rcx),%rcx
  8c721f:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c7226:	0f 85 27 03 00 00    	jne    8c7553 <check_lower_drain+0x3dc3>
  8c722c:	c7 81 f0 00 00 00 01 	movl   $0x1,0xf0(%rcx)
  8c7233:	00 00 00 
  8c7236:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c723c:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c7240:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c7246:	e9 08 03 00 00       	jmp    8c7553 <check_lower_drain+0x3dc3>
  8c724b:	8b 44 24 68          	mov    0x68(%rsp),%eax
  8c724f:	0a 44 24 40          	or     0x40(%rsp),%al
  8c7253:	a8 01                	test   $0x1,%al
  8c7255:	75 14                	jne    8c726b <check_lower_drain+0x3adb>
  8c7257:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c725c:	be 0a 00 00 00       	mov    $0xa,%esi
  8c7261:	48 89 df             	mov    %rbx,%rdi
  8c7264:	31 c9                	xor    %ecx,%ecx
  8c7266:	e8 e5 1a 00 00       	call   8c8d50 <check_lower_instruction>
  8c726b:	48 8b 84 24 28 02 00 	mov    0x228(%rsp),%rax
  8c7272:	00 
  8c7273:	48 83 f8 08          	cmp    $0x8,%rax
  8c7277:	0f 82 7a 01 00 00    	jb     8c73f7 <check_lower_drain+0x3c67>
  8c727d:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c7283:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c7289:	0f 83 dc 00 00 00    	jae    8c736b <check_lower_drain+0x3bdb>
  8c728f:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c7293:	8d 71 01             	lea    0x1(%rcx),%esi
  8c7296:	48 c1 e1 04          	shl    $0x4,%rcx
  8c729a:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c72a0:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c72a7:	00 08 00 
  8c72aa:	48 83 c6 14          	add    $0x14,%rsi
  8c72ae:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c72b2:	48 c7 44 0a 08 01 00 	movq   $0x1,0x8(%rdx,%rcx,1)
  8c72b9:	00 00 
  8c72bb:	e9 d5 00 00 00       	jmp    8c7395 <check_lower_drain+0x3c05>
  8c72c0:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c72c5:	f6 c2 01             	test   $0x1,%dl
  8c72c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8c72cd:	ba 01 00 00 00       	mov    $0x1,%edx
  8c72d2:	48 89 df             	mov    %rbx,%rdi
  8c72d5:	89 ee                	mov    %ebp,%esi
  8c72d7:	44 0f 45 c0          	cmovne %eax,%r8d
  8c72db:	83 e1 01             	and    $0x1,%ecx
  8c72de:	c5 f8 77             	vzeroupper
  8c72e1:	e8 9a 1a 01 00       	call   8d8d80 <check_lower_operand>
  8c72e6:	e9 32 f1 ff ff       	jmp    8c641d <check_lower_drain+0x2c8d>
  8c72eb:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c72f0:	8d 71 eb             	lea    -0x15(%rcx),%esi
  8c72f3:	83 fe 02             	cmp    $0x2,%esi
  8c72f6:	0f 87 09 05 00 00    	ja     8c7805 <check_lower_drain+0x4075>
  8c72fc:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c7301:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  8c7306:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c730b:	83 f0 17             	xor    $0x17,%eax
  8c730e:	c6 84 24 f0 01 00 00 	movb   $0x0,0x1f0(%rsp)
  8c7315:	00 
  8c7316:	89 ee                	mov    %ebp,%esi
  8c7318:	89 d1                	mov    %edx,%ecx
  8c731a:	33 8c 24 88 00 00 00 	xor    0x88(%rsp),%ecx
  8c7321:	09 c1                	or     %eax,%ecx
  8c7323:	48 8d 8c 24 f0 01 00 	lea    0x1f0(%rsp),%rcx
  8c732a:	00 
  8c732b:	41 0f 94 c6          	sete   %r14b
  8c732f:	c5 f8 77             	vzeroupper
  8c7332:	e8 39 52 fc ff       	call   88c570 <check_program_runtime_truth>
  8c7337:	84 c0                	test   %al,%al
  8c7339:	0f 84 e6 04 00 00    	je     8c7825 <check_lower_drain+0x4095>
  8c733f:	83 7c 24 30 17       	cmpl   $0x17,0x30(%rsp)
  8c7344:	0f 85 84 05 00 00    	jne    8c78ce <check_lower_drain+0x413e>
  8c734a:	44 0f b6 bc 24 f0 01 	movzbl 0x1f0(%rsp),%r15d
  8c7351:	00 00 
  8c7353:	45 8b 04 24          	mov    (%r12),%r8d
  8c7357:	ba 02 00 00 00       	mov    $0x2,%edx
  8c735c:	48 89 df             	mov    %rbx,%rdi
  8c735f:	89 ee                	mov    %ebp,%esi
  8c7361:	31 c9                	xor    %ecx,%ecx
  8c7363:	44 29 fa             	sub    %r15d,%edx
  8c7366:	e9 75 08 00 00       	jmp    8c7be0 <check_lower_drain+0x4450>
  8c736b:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c736f:	48 8b 09             	mov    (%rcx),%rcx
  8c7372:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c7379:	75 1a                	jne    8c7395 <check_lower_drain+0x3c05>
  8c737b:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c7382:	00 00 00 
  8c7385:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c738b:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c738f:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c7395:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c739b:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c73a1:	73 2a                	jae    8c73cd <check_lower_drain+0x3c3d>
  8c73a3:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c73a7:	8d 71 01             	lea    0x1(%rcx),%esi
  8c73aa:	48 c1 e8 03          	shr    $0x3,%rax
  8c73ae:	48 c1 e1 04          	shl    $0x4,%rcx
  8c73b2:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c73b8:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c73bf:	00 08 00 
  8c73c2:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c73c6:	48 89 44 0a 08       	mov    %rax,0x8(%rdx,%rcx,1)
  8c73cb:	eb 2a                	jmp    8c73f7 <check_lower_drain+0x3c67>
  8c73cd:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c73d1:	48 8b 00             	mov    (%rax),%rax
  8c73d4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c73db:	75 1a                	jne    8c73f7 <check_lower_drain+0x3c67>
  8c73dd:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c73e4:	00 00 00 
  8c73e7:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c73ed:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c73f1:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c73f7:	31 c9                	xor    %ecx,%ecx
  8c73f9:	83 7c 24 30 20       	cmpl   $0x20,0x30(%rsp)
  8c73fe:	48 89 df             	mov    %rbx,%rdi
  8c7401:	89 ee                	mov    %ebp,%esi
  8c7403:	0f 94 c1             	sete   %cl
  8c7406:	31 d2                	xor    %edx,%edx
  8c7408:	4c 8b 44 24 48       	mov    0x48(%rsp),%r8
  8c740d:	e8 6e 19 01 00       	call   8d8d80 <check_lower_operand>
  8c7412:	e9 52 10 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7417:	44 89 f8             	mov    %r15d,%eax
  8c741a:	41 89 c4             	mov    %eax,%r12d
  8c741d:	4c 89 e0             	mov    %r12,%rax
  8c7420:	48 c1 e0 20          	shl    $0x20,%rax
  8c7424:	45 89 ff             	mov    %r15d,%r15d
  8c7427:	c7 84 24 f0 01 00 00 	movl   $0x14,0x1f0(%rsp)
  8c742e:	14 00 00 00 
  8c7432:	89 ac 24 f4 01 00 00 	mov    %ebp,0x1f4(%rsp)
  8c7439:	48 c7 84 24 f8 01 00 	movq   $0x0,0x1f8(%rsp)
  8c7440:	00 00 00 00 00 
  8c7445:	48 89 df             	mov    %rbx,%rdi
  8c7448:	4c 09 f8             	or     %r15,%rax
  8c744b:	48 89 84 24 00 02 00 	mov    %rax,0x200(%rsp)
  8c7452:	00 
  8c7453:	48 c7 84 24 08 02 00 	movq   $0x0,0x208(%rsp)
  8c745a:	00 00 00 00 00 
  8c745f:	c5 fe 6f 84 24 f0 01 	vmovdqu 0x1f0(%rsp),%ymm0
  8c7466:	00 00 
  8c7468:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c746d:	c5 f8 77             	vzeroupper
  8c7470:	e8 8b 56 00 00       	call   8ccb00 <check_lower_push>
  8c7475:	83 7c 24 30 02       	cmpl   $0x2,0x30(%rsp)
  8c747a:	74 57                	je     8c74d3 <check_lower_drain+0x3d43>
  8c747c:	83 7c 24 30 04       	cmpl   $0x4,0x30(%rsp)
  8c7481:	74 50                	je     8c74d3 <check_lower_drain+0x3d43>
  8c7483:	0f b6 54 24 28       	movzbl 0x28(%rsp),%edx
  8c7488:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c748d:	48 89 df             	mov    %rbx,%rdi
  8c7490:	4c 89 e1             	mov    %r12,%rcx
  8c7493:	e8 b8 18 00 00       	call   8c8d50 <check_lower_instruction>
  8c7498:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  8c749f:	00 
  8c74a0:	49 8b 46 08          	mov    0x8(%r14),%rax
  8c74a4:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  8c74ab:	00 
  8c74ac:	48 89 df             	mov    %rbx,%rdi
  8c74af:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c74b3:	48 c1 e1 05          	shl    $0x5,%rcx
  8c74b7:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c74ba:	e8 41 52 01 00       	call   8dc700 <check_lower_complex_target>
  8c74bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8c74c4:	48 89 df             	mov    %rbx,%rdi
  8c74c7:	89 ee                	mov    %ebp,%esi
  8c74c9:	31 c9                	xor    %ecx,%ecx
  8c74cb:	41 89 c0             	mov    %eax,%r8d
  8c74ce:	e8 ad 18 01 00       	call   8d8d80 <check_lower_operand>
  8c74d3:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c74d8:	48 89 df             	mov    %rbx,%rdi
  8c74db:	44 89 ea             	mov    %r13d,%edx
  8c74de:	4c 89 f9             	mov    %r15,%rcx
  8c74e1:	e8 6a 18 00 00       	call   8c8d50 <check_lower_instruction>
  8c74e6:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c74eb:	49 8b 46 08          	mov    0x8(%r14),%rax
  8c74ef:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c74f4:	48 89 df             	mov    %rbx,%rdi
  8c74f7:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c74fb:	48 c1 e1 05          	shl    $0x5,%rcx
  8c74ff:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c7502:	e8 f9 51 01 00       	call   8dc700 <check_lower_complex_target>
  8c7507:	48 89 df             	mov    %rbx,%rdi
  8c750a:	89 ee                	mov    %ebp,%esi
  8c750c:	31 d2                	xor    %edx,%edx
  8c750e:	31 c9                	xor    %ecx,%ecx
  8c7510:	41 89 c0             	mov    %eax,%r8d
  8c7513:	e8 68 18 01 00       	call   8d8d80 <check_lower_operand>
  8c7518:	e9 4c 0f 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c751d:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c7522:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  8c7526:	42 81 3c b9 30 01 00 	cmpl   $0x130,(%rcx,%r15,4)
  8c752d:	00 
  8c752e:	75 23                	jne    8c7553 <check_lower_drain+0x3dc3>
  8c7530:	31 c9                	xor    %ecx,%ecx
  8c7532:	41 83 bc 24 8c 00 00 	cmpl   $0x2,0x8c(%r12)
  8c7539:	00 02 
  8c753b:	0f 94 c2             	sete   %dl
  8c753e:	41 83 fd 01          	cmp    $0x1,%r13d
  8c7542:	0f 85 d0 fc ff ff    	jne    8c7218 <check_lower_drain+0x3a88>
  8c7548:	88 d1                	mov    %dl,%cl
  8c754a:	41 39 ce             	cmp    %ecx,%r14d
  8c754d:	0f 85 c5 fc ff ff    	jne    8c7218 <check_lower_drain+0x3a88>
  8c7553:	48 8d 8c 24 d2 00 00 	lea    0xd2(%rsp),%rcx
  8c755a:	00 
  8c755b:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
  8c755f:	48 89 df             	mov    %rbx,%rdi
  8c7562:	c5 f8 11 41 f6       	vmovups %xmm0,-0xa(%rcx)
  8c7567:	48 c7 41 06 00 00 00 	movq   $0x0,0x6(%rcx)
  8c756e:	00 
  8c756f:	c7 84 24 c0 00 00 00 	movl   $0xb,0xc0(%rsp)
  8c7576:	0b 00 00 00 
  8c757a:	89 84 24 c4 00 00 00 	mov    %eax,0xc4(%rsp)
  8c7581:	c5 fe 6f 84 24 c0 00 	vmovdqu 0xc0(%rsp),%ymm0
  8c7588:	00 00 
  8c758a:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c758f:	c5 f8 77             	vzeroupper
  8c7592:	e8 69 55 00 00       	call   8ccb00 <check_lower_push>
  8c7597:	45 85 ed             	test   %r13d,%r13d
  8c759a:	0f 84 c9 0e 00 00    	je     8c8469 <check_lower_drain+0x4cd9>
  8c75a0:	44 89 ea             	mov    %r13d,%edx
  8c75a3:	44 8d 6a ff          	lea    -0x1(%rdx),%r13d
  8c75a7:	83 fa 20             	cmp    $0x20,%edx
  8c75aa:	77 eb                	ja     8c7597 <check_lower_drain+0x3e07>
  8c75ac:	45 0f a3 ee          	bt     %r13d,%r14d
  8c75b0:	73 e5                	jae    8c7597 <check_lower_drain+0x3e07>
  8c75b2:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c75b8:	83 c2 02             	add    $0x2,%edx
  8c75bb:	48 89 df             	mov    %rbx,%rdi
  8c75be:	89 ee                	mov    %ebp,%esi
  8c75c0:	31 c9                	xor    %ecx,%ecx
  8c75c2:	e8 b9 17 01 00       	call   8d8d80 <check_lower_operand>
  8c75c7:	eb ce                	jmp    8c7597 <check_lower_drain+0x3e07>
  8c75c9:	45 31 ff             	xor    %r15d,%r15d
  8c75cc:	44 2b ac 24 80 00 00 	sub    0x80(%rsp),%r13d
  8c75d3:	00 
  8c75d4:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  8c75d9:	4c 0f a3 ea          	bt     %r13,%rdx
  8c75dd:	0f 83 c6 0a 00 00    	jae    8c80a9 <check_lower_drain+0x4919>
  8c75e3:	4d 01 c6             	add    %r8,%r14
  8c75e6:	41 83 7e 44 00       	cmpl   $0x0,0x44(%r14)
  8c75eb:	0f 85 b8 0a 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c75f1:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c75f6:	48 8b 12             	mov    (%rdx),%rdx
  8c75f9:	48 8b 3a             	mov    (%rdx),%rdi
  8c75fc:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  8c7601:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8c7606:	8b 14 97             	mov    (%rdi,%rdx,4),%edx
  8c7609:	48 89 bc 24 98 00 00 	mov    %rdi,0x98(%rsp)
  8c7610:	00 
  8c7611:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  8c7616:	42 0f b6 7c 6f 20    	movzbl 0x20(%rdi,%r13,2),%edi
  8c761c:	85 d2                	test   %edx,%edx
  8c761e:	41 0f 94 c5          	sete   %r13b
  8c7622:	45 20 fd             	and    %r15b,%r13b
  8c7625:	89 bc 24 94 00 00 00 	mov    %edi,0x94(%rsp)
  8c762c:	41 80 fd 01          	cmp    $0x1,%r13b
  8c7630:	75 2f                	jne    8c7661 <check_lower_drain+0x3ed1>
  8c7632:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  8c7637:	4c 8b af 90 02 00 00 	mov    0x290(%rdi),%r13
  8c763e:	8d 78 ff             	lea    -0x1(%rax),%edi
  8c7641:	41 80 7c 3d 00 00    	cmpb   $0x0,0x0(%r13,%rdi,1)
  8c7647:	74 18                	je     8c7661 <check_lower_drain+0x3ed1>
  8c7649:	4c 8b 6c 24 70       	mov    0x70(%rsp),%r13
  8c764e:	4d 8b ad 78 02 00 00 	mov    0x278(%r13),%r13
  8c7655:	41 80 7c 3d 00 00    	cmpb   $0x0,0x0(%r13,%rdi,1)
  8c765b:	0f 84 48 0a 00 00    	je     8c80a9 <check_lower_drain+0x4919>
  8c7661:	45 8b 6e 0c          	mov    0xc(%r14),%r13d
  8c7665:	45 85 ed             	test   %r13d,%r13d
  8c7668:	74 1f                	je     8c7689 <check_lower_drain+0x3ef9>
  8c766a:	41 83 7e 54 00       	cmpl   $0x0,0x54(%r14)
  8c766f:	75 18                	jne    8c7689 <check_lower_drain+0x3ef9>
  8c7671:	41 0f b7 7e 08       	movzwl 0x8(%r14),%edi
  8c7676:	f7 c7 10 08 00 00    	test   $0x810,%edi
  8c767c:	75 0b                	jne    8c7689 <check_lower_drain+0x3ef9>
  8c767e:	41 83 7e 04 00       	cmpl   $0x0,0x4(%r14)
  8c7683:	0f 84 01 0a 00 00    	je     8c808a <check_lower_drain+0x48fa>
  8c7689:	85 d2                	test   %edx,%edx
  8c768b:	0f 85 18 0a 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c7691:	41 83 7e 04 01       	cmpl   $0x1,0x4(%r14)
  8c7696:	0f 94 c2             	sete   %dl
  8c7699:	44 20 fa             	and    %r15b,%dl
  8c769c:	80 fa 01             	cmp    $0x1,%dl
  8c769f:	0f 85 04 0a 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c76a5:	48 8b 53 68          	mov    0x68(%rbx),%rdx
  8c76a9:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  8c76ae:	44 8b 2c 82          	mov    (%rdx,%rax,4),%r13d
  8c76b2:	49 8b 96 80 00 00 00 	mov    0x80(%r14),%rdx
  8c76b9:	8b 14 82             	mov    (%rdx,%rax,4),%edx
  8c76bc:	85 d2                	test   %edx,%edx
  8c76be:	0f 94 c0             	sete   %al
  8c76c1:	31 ff                	xor    %edi,%edi
  8c76c3:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8c76c7:	40 0f 94 c7          	sete   %dil
  8c76cb:	44 0f 44 ea          	cmove  %edx,%r13d
  8c76cf:	8d 54 3f 02          	lea    0x2(%rdi,%rdi,1),%edx
  8c76d3:	40 20 f8             	and    %dil,%al
  8c76d6:	89 94 24 90 00 00 00 	mov    %edx,0x90(%rsp)
  8c76dd:	41 08 c3             	or     %al,%r11b
  8c76e0:	0f 84 e2 06 00 00    	je     8c7dc8 <check_lower_drain+0x4638>
  8c76e6:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  8c76eb:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  8c76f0:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8c76f4:	8b 14 ba             	mov    (%rdx,%rdi,4),%edx
  8c76f7:	89 93 64 01 00 00    	mov    %edx,0x164(%rbx)
  8c76fd:	84 c0                	test   %al,%al
  8c76ff:	0f 85 bb 09 00 00    	jne    8c80c0 <check_lower_drain+0x4930>
  8c7705:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
  8c770a:	31 c0                	xor    %eax,%eax
  8c770c:	31 ff                	xor    %edi,%edi
  8c770e:	49 83 c0 08          	add    $0x8,%r8
  8c7712:	44 8b 9c 24 90 00 00 	mov    0x90(%rsp),%r11d
  8c7719:	00 
  8c771a:	ba 00 00 00 00       	mov    $0x0,%edx
  8c771f:	41 09 c3             	or     %eax,%r11d
  8c7722:	66 81 fe ff 00       	cmp    $0xff,%si
  8c7727:	89 f0                	mov    %esi,%eax
  8c7729:	0f 44 c2             	cmove  %edx,%eax
  8c772c:	41 ff ca             	dec    %r10d
  8c772f:	c1 e0 10             	shl    $0x10,%eax
  8c7732:	44 89 d2             	mov    %r10d,%edx
  8c7735:	2b 54 24 60          	sub    0x60(%rsp),%edx
  8c7739:	44 09 d8             	or     %r11d,%eax
  8c773c:	4d 89 d3             	mov    %r10,%r11
  8c773f:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
  8c7744:	83 7c 24 28 0f       	cmpl   $0xf,0x28(%rsp)
  8c7749:	41 0f b7 54 52 20    	movzwl 0x20(%r10,%rdx,2),%edx
  8c774f:	41 b2 01             	mov    $0x1,%r10b
  8c7752:	77 20                	ja     8c7774 <check_lower_drain+0x3fe4>
  8c7754:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
  8c7759:	45 89 da             	mov    %r11d,%r10d
  8c775c:	45 89 c9             	mov    %r9d,%r9d
  8c775f:	4c 89 4c 24 58       	mov    %r9,0x58(%rsp)
  8c7764:	47 0f b7 54 56 20    	movzwl 0x20(%r14,%r10,2),%r10d
  8c776a:	41 c1 e2 08          	shl    $0x8,%r10d
  8c776e:	44 09 d2             	or     %r10d,%edx
  8c7771:	41 b2 03             	mov    $0x3,%r10b
  8c7774:	66 81 fe ff 00       	cmp    $0xff,%si
  8c7779:	44 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9d
  8c7780:	00 
  8c7781:	c5 f9 6e c0          	vmovd  %eax,%xmm0
  8c7785:	c4 c1 f9 6e cd       	vmovq  %r13,%xmm1
  8c778a:	40 0f 95 c6          	setne  %sil
  8c778e:	ff c1                	inc    %ecx
  8c7790:	40 c0 e6 02          	shl    $0x2,%sil
  8c7794:	44 08 d6             	or     %r10b,%sil
  8c7797:	4c 8b 53 20          	mov    0x20(%rbx),%r10
  8c779b:	c5 fb 92 ce          	kmovd  %esi,%k1
  8c779f:	40 0f b6 c6          	movzbl %sil,%eax
  8c77a3:	c5 f9 90 d1          	kmovb  %k1,%k2
  8c77a7:	41 c1 e1 10          	shl    $0x10,%r9d
  8c77ab:	f3 0f b8 c0          	popcnt %eax,%eax
  8c77af:	41 09 d1             	or     %edx,%r9d
  8c77b2:	62 92 7d 0a 63 04 22 	vpcompressb %xmm0,(%r10,%r12,1){%k2}
  8c77b9:	c4 c1 79 6e c1       	vmovd  %r9d,%xmm0
  8c77be:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c77c2:	8b b3 38 01 00 00    	mov    0x138(%rbx),%esi
  8c77c8:	62 f2 7d 0a 63 04 32 	vpcompressb %xmm0,(%rdx,%rsi,1){%k2}
  8c77cf:	c4 e1 f9 6e c7       	vmovq  %rdi,%xmm0
  8c77d4:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c77d8:	8b b3 38 01 00 00    	mov    0x138(%rbx),%esi
  8c77de:	c5 f1 6c c0          	vpunpcklqdq %xmm0,%xmm1,%xmm0
  8c77e2:	62 f2 fd 49 8b 04 f2 	vpcompressq %zmm0,(%rdx,%rsi,8){%k1}
  8c77e9:	01 83 38 01 00 00    	add    %eax,0x138(%rbx)
  8c77ef:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8c77f4:	49 8b 00             	mov    (%r8),%rax
  8c77f7:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  8c77fa:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c7800:	e9 11 09 00 00       	jmp    8c8116 <check_lower_drain+0x4986>
  8c7805:	83 7c 24 30 38       	cmpl   $0x38,0x30(%rsp)
  8c780a:	74 74                	je     8c7880 <check_lower_drain+0x40f0>
  8c780c:	83 7c 24 30 22       	cmpl   $0x22,0x30(%rsp)
  8c7811:	75 7f                	jne    8c7892 <check_lower_drain+0x4102>
  8c7813:	48 89 df             	mov    %rbx,%rdi
  8c7816:	89 ee                	mov    %ebp,%esi
  8c7818:	c5 f8 77             	vzeroupper
  8c781b:	e8 e0 52 01 00       	call   8dcb00 <check_lower_call>
  8c7820:	e9 44 0c 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7825:	48 89 df             	mov    %rbx,%rdi
  8c7828:	e8 03 60 00 00       	call   8cd830 <check_lower_label>
  8c782d:	48 89 df             	mov    %rbx,%rdi
  8c7830:	89 44 24 28          	mov    %eax,0x28(%rsp)
  8c7834:	e8 f7 5f 00 00       	call   8cd830 <check_lower_label>
  8c7839:	41 89 c7             	mov    %eax,%r15d
  8c783c:	45 84 f6             	test   %r14b,%r14b
  8c783f:	0f 84 f4 00 00 00    	je     8c7939 <check_lower_drain+0x41a9>
  8c7845:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c784a:	c1 e8 03             	shr    $0x3,%eax
  8c784d:	b1 ff                	mov    $0xff,%cl
  8c784f:	3b 83 b0 01 00 00    	cmp    0x1b0(%rbx),%eax
  8c7855:	73 0b                	jae    8c7862 <check_lower_drain+0x40d2>
  8c7857:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c785e:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c7862:	0f b6 f1             	movzbl %cl,%esi
  8c7865:	48 89 df             	mov    %rbx,%rdi
  8c7868:	e8 93 6d ff ff       	call   8be600 <check_lower_temporary>
  8c786d:	41 89 c5             	mov    %eax,%r13d
  8c7870:	48 89 df             	mov    %rbx,%rdi
  8c7873:	44 89 fe             	mov    %r15d,%esi
  8c7876:	e8 15 52 01 00       	call   8dca90 <check_lower_mark>
  8c787b:	e9 d5 00 00 00       	jmp    8c7955 <check_lower_drain+0x41c5>
  8c7880:	48 89 df             	mov    %rbx,%rdi
  8c7883:	89 ee                	mov    %ebp,%esi
  8c7885:	c5 f8 77             	vzeroupper
  8c7888:	e8 e3 5f 01 00       	call   8dd870 <check_lower_varargs_prepare>
  8c788d:	e9 d7 0b 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7892:	83 7c 24 30 1b       	cmpl   $0x1b,0x30(%rsp)
  8c7897:	0f 85 82 01 00 00    	jne    8c7a1f <check_lower_drain+0x428f>
  8c789d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c78a2:	49 8b 76 08          	mov    0x8(%r14),%rsi
  8c78a6:	48 8d 3c 40          	lea    (%rax,%rax,2),%rdi
  8c78aa:	48 c1 e7 05          	shl    $0x5,%rdi
  8c78ae:	f6 44 3e 08 04       	testb  $0x4,0x8(%rsi,%rdi,1)
  8c78b3:	0f 84 a4 01 00 00    	je     8c7a5d <check_lower_drain+0x42cd>
  8c78b9:	83 e2 01             	and    $0x1,%edx
  8c78bc:	48 89 df             	mov    %rbx,%rdi
  8c78bf:	89 ee                	mov    %ebp,%esi
  8c78c1:	c5 f8 77             	vzeroupper
  8c78c4:	e8 b7 6d 01 00       	call   8de680 <check_lower_bit_assign>
  8c78c9:	e9 9b 0b 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c78ce:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c78d3:	44 0f b6 bc 24 f0 01 	movzbl 0x1f0(%rsp),%r15d
  8c78da:	00 00 
  8c78dc:	83 f9 16             	cmp    $0x16,%ecx
  8c78df:	44 89 fa             	mov    %r15d,%edx
  8c78e2:	0f 94 c0             	sete   %al
  8c78e5:	83 f9 15             	cmp    $0x15,%ecx
  8c78e8:	0f 94 c1             	sete   %cl
  8c78eb:	80 f2 01             	xor    $0x1,%dl
  8c78ee:	44 20 f8             	and    %r15b,%al
  8c78f1:	20 ca                	and    %cl,%dl
  8c78f3:	08 c2                	or     %al,%dl
  8c78f5:	80 fa 01             	cmp    $0x1,%dl
  8c78f8:	0f 85 be 02 00 00    	jne    8c7bbc <check_lower_drain+0x442c>
  8c78fe:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c7904:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c790a:	0f 83 52 04 00 00    	jae    8c7d62 <check_lower_drain+0x45d2>
  8c7910:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c7914:	8d 50 01             	lea    0x1(%rax),%edx
  8c7917:	48 c1 e0 04          	shl    $0x4,%rax
  8c791b:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c7921:	48 ba 01 00 00 00 01 	movabs $0x5000100000001,%rdx
  8c7928:	00 05 00 
  8c792b:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c792f:	4c 89 7c 01 08       	mov    %r15,0x8(%rcx,%rax,1)
  8c7934:	e9 ac 02 00 00       	jmp    8c7be5 <check_lower_drain+0x4455>
  8c7939:	48 89 df             	mov    %rbx,%rdi
  8c793c:	44 89 fe             	mov    %r15d,%esi
  8c793f:	e8 4c 51 01 00       	call   8dca90 <check_lower_mark>
  8c7944:	83 7c 24 30 17       	cmpl   $0x17,0x30(%rsp)
  8c7949:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8c794f:	0f 85 c9 02 00 00    	jne    8c7c1e <check_lower_drain+0x448e>
  8c7955:	45 8b 04 24          	mov    (%r12),%r8d
  8c7959:	ba 02 00 00 00       	mov    $0x2,%edx
  8c795e:	48 89 df             	mov    %rbx,%rdi
  8c7961:	89 ee                	mov    %ebp,%esi
  8c7963:	31 c9                	xor    %ecx,%ecx
  8c7965:	e8 16 14 01 00       	call   8d8d80 <check_lower_operand>
  8c796a:	8b 74 24 28          	mov    0x28(%rsp),%esi
  8c796e:	48 89 df             	mov    %rbx,%rdi
  8c7971:	e8 1a 51 01 00       	call   8dca90 <check_lower_mark>
  8c7976:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c797b:	be 27 00 00 00       	mov    $0x27,%esi
  8c7980:	44 89 f9             	mov    %r15d,%ecx
  8c7983:	48 89 df             	mov    %rbx,%rdi
  8c7986:	3c 01                	cmp    $0x1,%al
  8c7988:	0f b6 d0             	movzbl %al,%edx
  8c798b:	83 de 00             	sbb    $0x0,%esi
  8c798e:	e8 bd 13 00 00       	call   8c8d50 <check_lower_instruction>
  8c7993:	83 7c 24 30 17       	cmpl   $0x17,0x30(%rsp)
  8c7998:	75 5c                	jne    8c79f6 <check_lower_drain+0x4266>
  8c799a:	45 8b 04 24          	mov    (%r12),%r8d
  8c799e:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c79a3:	3b 84 24 88 00 00 00 	cmp    0x88(%rsp),%eax
  8c79aa:	0f 85 b3 02 00 00    	jne    8c7c63 <check_lower_drain+0x44d3>
  8c79b0:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  8c79b5:	48 89 df             	mov    %rbx,%rdi
  8c79b8:	44 89 c2             	mov    %r8d,%edx
  8c79bb:	44 89 fe             	mov    %r15d,%esi
  8c79be:	e8 fd 51 00 00       	call   8ccbc0 <check_lower_convert>
  8c79c3:	41 c1 ef 03          	shr    $0x3,%r15d
  8c79c7:	b1 ff                	mov    $0xff,%cl
  8c79c9:	44 3b bb b0 01 00 00 	cmp    0x1b0(%rbx),%r15d
  8c79d0:	73 0c                	jae    8c79de <check_lower_drain+0x424e>
  8c79d2:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c79d9:	42 0f b6 0c 39       	movzbl (%rcx,%r15,1),%ecx
  8c79de:	0f b6 d1             	movzbl %cl,%edx
  8c79e1:	be 02 00 00 00       	mov    $0x2,%esi
  8c79e6:	48 89 df             	mov    %rbx,%rdi
  8c79e9:	4c 89 e9             	mov    %r13,%rcx
  8c79ec:	e8 5f 13 00 00       	call   8c8d50 <check_lower_instruction>
  8c79f1:	e9 7e 02 00 00       	jmp    8c7c74 <check_lower_drain+0x44e4>
  8c79f6:	4c 8b bc 24 80 00 00 	mov    0x80(%rsp),%r15
  8c79fd:	00 
  8c79fe:	48 89 df             	mov    %rbx,%rdi
  8c7a01:	31 d2                	xor    %edx,%edx
  8c7a03:	44 89 fe             	mov    %r15d,%esi
  8c7a06:	e8 95 4d 01 00       	call   8dc7a0 <check_lower_truth>
  8c7a0b:	ba 01 00 00 00       	mov    $0x1,%edx
  8c7a10:	48 89 df             	mov    %rbx,%rdi
  8c7a13:	89 ee                	mov    %ebp,%esi
  8c7a15:	31 c9                	xor    %ecx,%ecx
  8c7a17:	45 89 f8             	mov    %r15d,%r8d
  8c7a1a:	e9 50 02 00 00       	jmp    8c7c6f <check_lower_drain+0x44df>
  8c7a1f:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c7a24:	8d 71 da             	lea    -0x26(%rcx),%esi
  8c7a27:	83 fe 0d             	cmp    $0xd,%esi
  8c7a2a:	77 31                	ja     8c7a5d <check_lower_drain+0x42cd>
  8c7a2c:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c7a31:	49 8b 7e 08          	mov    0x8(%r14),%rdi
  8c7a35:	40 b6 01             	mov    $0x1,%sil
  8c7a38:	4c 8d 0c 40          	lea    (%rax,%rax,2),%r9
  8c7a3c:	49 c1 e1 05          	shl    $0x5,%r9
  8c7a40:	42 f6 44 0f 08 04    	testb  $0x4,0x8(%rdi,%r9,1)
  8c7a46:	74 17                	je     8c7a5f <check_lower_drain+0x42cf>
  8c7a48:	83 e2 01             	and    $0x1,%edx
  8c7a4b:	48 89 df             	mov    %rbx,%rdi
  8c7a4e:	89 ee                	mov    %ebp,%esi
  8c7a50:	c5 f8 77             	vzeroupper
  8c7a53:	e8 88 6f 01 00       	call   8de9e0 <check_lower_bit_update>
  8c7a58:	e9 0c 0a 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7a5d:	31 f6                	xor    %esi,%esi
  8c7a5f:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c7a64:	8d 51 e5             	lea    -0x1b(%rcx),%edx
  8c7a67:	f7 c2 f7 ff ff ff    	test   $0xfffffff7,%edx
  8c7a6d:	0f 94 c2             	sete   %dl
  8c7a70:	44 20 ea             	and    %r13b,%dl
  8c7a73:	80 fa 01             	cmp    $0x1,%dl
  8c7a76:	0f 85 98 02 00 00    	jne    8c7d14 <check_lower_drain+0x4584>
  8c7a7c:	83 7c 24 30 23       	cmpl   $0x23,0x30(%rsp)
  8c7a81:	c7 44 24 28 ff ff ff 	movl   $0xffffffff,0x28(%rsp)
  8c7a88:	ff 
  8c7a89:	75 0f                	jne    8c7a9a <check_lower_drain+0x430a>
  8c7a8b:	48 8b 8b b8 00 00 00 	mov    0xb8(%rbx),%rcx
  8c7a92:	42 8b 04 b9          	mov    (%rcx,%r15,4),%eax
  8c7a96:	89 44 24 28          	mov    %eax,0x28(%rsp)
  8c7a9a:	c4 e2 79 22 05 e5 f8 	vpmovsxbq -0x42071b(%rip),%xmm0        # 4a7388 <cbuiltin_test_generated.edges+0xacf8>
  8c7aa1:	bd ff 
  8c7aa3:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8c7aa8:	41 c1 e8 03          	shr    $0x3,%r8d
  8c7aac:	c5 f8 29 84 24 d0 01 	vmovaps %xmm0,0x1d0(%rsp)
  8c7ab3:	00 00 
  8c7ab5:	48 8b 08             	mov    (%rax),%rcx
  8c7ab8:	42 80 3c 01 0f       	cmpb   $0xf,(%rcx,%r8,1)
  8c7abd:	75 11                	jne    8c7ad0 <check_lower_drain+0x4340>
  8c7abf:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8c7ac4:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8c7ac8:	46 8b 04 81          	mov    (%rcx,%r8,4),%r8d
  8c7acc:	41 c1 e8 03          	shr    $0x3,%r8d
  8c7ad0:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8c7ad5:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
  8c7ada:	45 31 f6             	xor    %r14d,%r14d
  8c7add:	48 89 df             	mov    %rbx,%rdi
  8c7ae0:	48 8b 48 38          	mov    0x38(%rax),%rcx
  8c7ae4:	0f b6 44 24 78       	movzbl 0x78(%rsp),%eax
  8c7ae9:	41 83 fd 23          	cmp    $0x23,%r13d
  8c7aed:	41 0f 95 c6          	setne  %r14b
  8c7af1:	4a 8b 0c c1          	mov    (%rcx,%r8,8),%rcx
  8c7af5:	34 01                	xor    $0x1,%al
  8c7af7:	48 89 8c 24 e0 01 00 	mov    %rcx,0x1e0(%rsp)
  8c7afe:	00 
  8c7aff:	48 8d 8c 24 e9 01 00 	lea    0x1e9(%rsp),%rcx
  8c7b06:	00 
  8c7b07:	88 84 24 e8 01 00 00 	mov    %al,0x1e8(%rsp)
  8c7b0e:	c7 41 03 00 00 00 00 	movl   $0x0,0x3(%rcx)
  8c7b15:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c7b1b:	c5 fe 6f 84 24 d0 01 	vmovdqu 0x1d0(%rsp),%ymm0
  8c7b22:	00 00 
  8c7b24:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c7b29:	c5 f8 77             	vzeroupper
  8c7b2c:	e8 cf 4f 00 00       	call   8ccb00 <check_lower_push>
  8c7b31:	45 8b 04 24          	mov    (%r12),%r8d
  8c7b35:	48 89 df             	mov    %rbx,%rdi
  8c7b38:	89 ee                	mov    %ebp,%esi
  8c7b3a:	44 89 f2             	mov    %r14d,%edx
  8c7b3d:	31 c9                	xor    %ecx,%ecx
  8c7b3f:	e8 3c 12 01 00       	call   8d8d80 <check_lower_operand>
  8c7b44:	41 83 fd 1b          	cmp    $0x1b,%r13d
  8c7b48:	0f 84 5b ed ff ff    	je     8c68a9 <check_lower_drain+0x3119>
  8c7b4e:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c7b53:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  8c7b57:	48 8b 00             	mov    (%rax),%rax
  8c7b5a:	3b 88 84 03 00 00    	cmp    0x384(%rax),%ecx
  8c7b60:	0f 83 d9 08 00 00    	jae    8c843f <check_lower_drain+0x4caf>
  8c7b66:	48 8d 8c 24 b8 01 00 	lea    0x1b8(%rsp),%rcx
  8c7b6d:	00 
  8c7b6e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c7b72:	c5 fa 7f 01          	vmovdqu %xmm0,(%rcx)
  8c7b76:	48 c7 41 10 00 00 00 	movq   $0x0,0x10(%rcx)
  8c7b7d:	00 
  8c7b7e:	c7 84 24 b0 01 00 00 	movl   $0xa,0x1b0(%rsp)
  8c7b85:	0a 00 00 00 
  8c7b89:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  8c7b8d:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
  8c7b94:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c7b97:	89 84 24 b4 01 00 00 	mov    %eax,0x1b4(%rsp)
  8c7b9e:	c5 fe 6f 84 24 b0 01 	vmovdqu 0x1b0(%rsp),%ymm0
  8c7ba5:	00 00 
  8c7ba7:	48 89 df             	mov    %rbx,%rdi
  8c7baa:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c7baf:	c5 f8 77             	vzeroupper
  8c7bb2:	e8 49 4f 00 00       	call   8ccb00 <check_lower_push>
  8c7bb7:	e9 ad 08 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7bbc:	4c 8b a4 24 80 00 00 	mov    0x80(%rsp),%r12
  8c7bc3:	00 
  8c7bc4:	48 89 df             	mov    %rbx,%rdi
  8c7bc7:	31 d2                	xor    %edx,%edx
  8c7bc9:	44 89 e6             	mov    %r12d,%esi
  8c7bcc:	e8 cf 4b 01 00       	call   8dc7a0 <check_lower_truth>
  8c7bd1:	ba 01 00 00 00       	mov    $0x1,%edx
  8c7bd6:	48 89 df             	mov    %rbx,%rdi
  8c7bd9:	89 ee                	mov    %ebp,%esi
  8c7bdb:	31 c9                	xor    %ecx,%ecx
  8c7bdd:	45 89 e0             	mov    %r12d,%r8d
  8c7be0:	e8 9b 11 01 00       	call   8d8d80 <check_lower_operand>
  8c7be5:	45 84 fe             	test   %r15b,%r14b
  8c7be8:	0f 85 7b 08 00 00    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c7bee:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8c7bf3:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c7bf8:	48 8b 01             	mov    (%rcx),%rax
  8c7bfb:	48 8b 71 08          	mov    0x8(%rcx),%rsi
  8c7bff:	48 8b 38             	mov    (%rax),%rdi
  8c7c02:	e8 c9 4d 01 00       	call   8dc9d0 <check_program_runtime_effects>
  8c7c07:	b9 08 00 00 00       	mov    $0x8,%ecx
  8c7c0c:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  8c7c11:	84 c0                	test   %al,%al
  8c7c13:	0f 85 ed 00 00 00    	jne    8c7d06 <check_lower_drain+0x4576>
  8c7c19:	e9 4b 08 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7c1e:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c7c24:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c7c2a:	0f 83 65 01 00 00    	jae    8c7d95 <check_lower_drain+0x4605>
  8c7c30:	31 c9                	xor    %ecx,%ecx
  8c7c32:	83 7c 24 30 16       	cmpl   $0x16,0x30(%rsp)
  8c7c37:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c7c3b:	8d 70 01             	lea    0x1(%rax),%esi
  8c7c3e:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c7c44:	48 be 01 00 00 00 01 	movabs $0x5000100000001,%rsi
  8c7c4b:	00 05 00 
  8c7c4e:	0f 94 c1             	sete   %cl
  8c7c51:	48 c1 e0 04          	shl    $0x4,%rax
  8c7c55:	48 89 34 02          	mov    %rsi,(%rdx,%rax,1)
  8c7c59:	48 89 4c 02 08       	mov    %rcx,0x8(%rdx,%rax,1)
  8c7c5e:	e9 07 fd ff ff       	jmp    8c796a <check_lower_drain+0x41da>
  8c7c63:	48 89 df             	mov    %rbx,%rdi
  8c7c66:	89 ee                	mov    %ebp,%esi
  8c7c68:	ba 01 00 00 00       	mov    $0x1,%edx
  8c7c6d:	31 c9                	xor    %ecx,%ecx
  8c7c6f:	e8 0c 11 01 00       	call   8d8d80 <check_lower_operand>
  8c7c74:	31 f6                	xor    %esi,%esi
  8c7c76:	83 7c 24 30 16       	cmpl   $0x16,0x30(%rsp)
  8c7c7b:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  8c7c7f:	ba 05 00 00 00       	mov    $0x5,%edx
  8c7c84:	48 89 df             	mov    %rbx,%rdi
  8c7c87:	40 0f 94 c6          	sete   %sil
  8c7c8b:	83 ce 24             	or     $0x24,%esi
  8c7c8e:	e8 bd 10 00 00       	call   8c8d50 <check_lower_instruction>
  8c7c93:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8c7c98:	48 89 df             	mov    %rbx,%rdi
  8c7c9b:	31 d2                	xor    %edx,%edx
  8c7c9d:	e8 fe 4a 01 00       	call   8dc7a0 <check_lower_truth>
  8c7ca2:	45 84 f6             	test   %r14b,%r14b
  8c7ca5:	74 5f                	je     8c7d06 <check_lower_drain+0x4576>
  8c7ca7:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
  8c7cac:	41 c1 ee 03          	shr    $0x3,%r14d
  8c7cb0:	41 b7 ff             	mov    $0xff,%r15b
  8c7cb3:	b0 ff                	mov    $0xff,%al
  8c7cb5:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c7cbc:	73 0c                	jae    8c7cca <check_lower_drain+0x453a>
  8c7cbe:	48 8b 83 98 01 00 00 	mov    0x198(%rbx),%rax
  8c7cc5:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax
  8c7cca:	0f b6 d0             	movzbl %al,%edx
  8c7ccd:	be 02 00 00 00       	mov    $0x2,%esi
  8c7cd2:	48 89 df             	mov    %rbx,%rdi
  8c7cd5:	4c 89 e9             	mov    %r13,%rcx
  8c7cd8:	e8 73 10 00 00       	call   8c8d50 <check_lower_instruction>
  8c7cdd:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c7ce4:	73 0c                	jae    8c7cf2 <check_lower_drain+0x4562>
  8c7ce6:	48 8b 83 98 01 00 00 	mov    0x198(%rbx),%rax
  8c7ced:	46 0f b6 3c 30       	movzbl (%rax,%r14,1),%r15d
  8c7cf2:	41 0f b6 d7          	movzbl %r15b,%edx
  8c7cf6:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c7cfb:	48 89 df             	mov    %rbx,%rdi
  8c7cfe:	4c 89 e9             	mov    %r13,%rcx
  8c7d01:	e8 4a 10 00 00       	call   8c8d50 <check_lower_instruction>
  8c7d06:	48 89 df             	mov    %rbx,%rdi
  8c7d09:	89 ee                	mov    %ebp,%esi
  8c7d0b:	31 d2                	xor    %edx,%edx
  8c7d0d:	31 c9                	xor    %ecx,%ecx
  8c7d0f:	e9 f4 f6 ff ff       	jmp    8c7408 <check_lower_drain+0x3c78>
  8c7d14:	83 7c 24 30 23       	cmpl   $0x23,0x30(%rsp)
  8c7d19:	74 0b                	je     8c7d26 <check_lower_drain+0x4596>
  8c7d1b:	83 7c 24 30 1b       	cmpl   $0x1b,0x30(%rsp)
  8c7d20:	0f 85 c5 01 00 00    	jne    8c7eeb <check_lower_drain+0x475b>
  8c7d26:	83 7c 24 30 23       	cmpl   $0x23,0x30(%rsp)
  8c7d2b:	0f 85 c4 00 00 00    	jne    8c7df5 <check_lower_drain+0x4665>
  8c7d31:	48 8b 83 b8 00 00 00 	mov    0xb8(%rbx),%rax
  8c7d38:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c7d3d:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c7d41:	48 39 c8             	cmp    %rcx,%rax
  8c7d44:	0f 84 ab 00 00 00    	je     8c7df5 <check_lower_drain+0x4665>
  8c7d4a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8c7d4f:	48 c1 e0 02          	shl    $0x2,%rax
  8c7d53:	48 8b 09             	mov    (%rcx),%rcx
  8c7d56:	48 03 81 70 02 00 00 	add    0x270(%rcx),%rax
  8c7d5d:	e9 c0 00 00 00       	jmp    8c7e22 <check_lower_drain+0x4692>
  8c7d62:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7d66:	48 8b 00             	mov    (%rax),%rax
  8c7d69:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c7d70:	0f 85 6f fe ff ff    	jne    8c7be5 <check_lower_drain+0x4455>
  8c7d76:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c7d7d:	00 00 00 
  8c7d80:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c7d86:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c7d8a:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c7d90:	e9 50 fe ff ff       	jmp    8c7be5 <check_lower_drain+0x4455>
  8c7d95:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7d99:	48 8b 00             	mov    (%rax),%rax
  8c7d9c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c7da3:	0f 85 c1 fb ff ff    	jne    8c796a <check_lower_drain+0x41da>
  8c7da9:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c7db0:	00 00 00 
  8c7db3:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c7db9:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c7dbd:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c7dc3:	e9 a2 fb ff ff       	jmp    8c796a <check_lower_drain+0x41da>
  8c7dc8:	44 89 ca             	mov    %r9d,%edx
  8c7dcb:	4c 8d 34 52          	lea    (%rdx,%rdx,2),%r14
  8c7dcf:	49 c1 e6 05          	shl    $0x5,%r14
  8c7dd3:	47 8b 5c 30 40       	mov    0x40(%r8,%r14,1),%r11d
  8c7dd8:	4d 85 db             	test   %r11,%r11
  8c7ddb:	0f 84 75 01 00 00    	je     8c7f56 <check_lower_drain+0x47c6>
  8c7de1:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c7de6:	44 3b 98 c0 00 00 00 	cmp    0xc0(%rax),%r11d
  8c7ded:	0f 92 c0             	setb   %al
  8c7df0:	e9 63 01 00 00       	jmp    8c7f58 <check_lower_drain+0x47c8>
  8c7df5:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c7dfa:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c7dff:	48 8b 00             	mov    (%rax),%rax
  8c7e02:	83 3c 88 00          	cmpl   $0x0,(%rax,%rcx,4)
  8c7e06:	0f 85 a3 00 00 00    	jne    8c7eaf <check_lower_drain+0x471f>
  8c7e0c:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c7e11:	49 8b 46 08          	mov    0x8(%r14),%rax
  8c7e15:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c7e19:	48 c1 e1 05          	shl    $0x5,%rcx
  8c7e1d:	48 8d 44 08 40       	lea    0x40(%rax,%rcx,1),%rax
  8c7e22:	44 8b 30             	mov    (%rax),%r14d
  8c7e25:	4d 85 f6             	test   %r14,%r14
  8c7e28:	0f 84 81 00 00 00    	je     8c7eaf <check_lower_drain+0x471f>
  8c7e2e:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c7e33:	44 3b b0 c0 00 00 00 	cmp    0xc0(%rax),%r14d
  8c7e3a:	73 73                	jae    8c7eaf <check_lower_drain+0x471f>
  8c7e3c:	48 8b 43 68          	mov    0x68(%rbx),%rax
  8c7e40:	b2 1e                	mov    $0x1e,%dl
  8c7e42:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c7e46:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c7e49:	75 2b                	jne    8c7e76 <check_lower_drain+0x46e6>
  8c7e4b:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c7e50:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c7e55:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8c7e5c:	83 c1 f5             	add    $0xfffffff5,%ecx
  8c7e5f:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c7e63:	80 f9 03             	cmp    $0x3,%cl
  8c7e66:	0f 82 62 05 00 00    	jb     8c83ce <check_lower_drain+0x4c3e>
  8c7e6c:	b2 20                	mov    $0x20,%dl
  8c7e6e:	85 c0                	test   %eax,%eax
  8c7e70:	0f 84 58 05 00 00    	je     8c83ce <check_lower_drain+0x4c3e>
  8c7e76:	45 31 f6             	xor    %r14d,%r14d
  8c7e79:	83 7c 24 30 23       	cmpl   $0x23,0x30(%rsp)
  8c7e7e:	0f b6 f2             	movzbl %dl,%esi
  8c7e81:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c7e86:	89 c1                	mov    %eax,%ecx
  8c7e88:	48 89 df             	mov    %rbx,%rdi
  8c7e8b:	41 0f 95 c6          	setne  %r14b
  8c7e8f:	c5 f8 77             	vzeroupper
  8c7e92:	e8 b9 0e 00 00       	call   8c8d50 <check_lower_instruction>
  8c7e97:	45 8b 04 24          	mov    (%r12),%r8d
  8c7e9b:	48 89 df             	mov    %rbx,%rdi
  8c7e9e:	89 ee                	mov    %ebp,%esi
  8c7ea0:	44 89 f2             	mov    %r14d,%edx
  8c7ea3:	31 c9                	xor    %ecx,%ecx
  8c7ea5:	e8 d6 0e 01 00       	call   8d8d80 <check_lower_operand>
  8c7eaa:	e9 ba 05 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7eaf:	83 7c 24 30 1b       	cmpl   $0x1b,0x30(%rsp)
  8c7eb4:	0f 85 85 05 00 00    	jne    8c843f <check_lower_drain+0x4caf>
  8c7eba:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c7ebf:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c7ec4:	48 89 df             	mov    %rbx,%rdi
  8c7ec7:	31 c9                	xor    %ecx,%ecx
  8c7ec9:	c5 f8 77             	vzeroupper
  8c7ecc:	e8 7f 0e 00 00       	call   8c8d50 <check_lower_instruction>
  8c7ed1:	45 8b 04 24          	mov    (%r12),%r8d
  8c7ed5:	ba 01 00 00 00       	mov    $0x1,%edx
  8c7eda:	48 89 df             	mov    %rbx,%rdi
  8c7edd:	89 ee                	mov    %ebp,%esi
  8c7edf:	31 c9                	xor    %ecx,%ecx
  8c7ee1:	e8 9a 0e 01 00       	call   8d8d80 <check_lower_operand>
  8c7ee6:	e9 be e9 ff ff       	jmp    8c68a9 <check_lower_drain+0x3119>
  8c7eeb:	40 84 f6             	test   %sil,%sil
  8c7eee:	0f 84 3d 02 00 00    	je     8c8131 <check_lower_drain+0x49a1>
  8c7ef4:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c7ef9:	49 8b 46 08          	mov    0x8(%r14),%rax
  8c7efd:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c7f01:	48 c1 e1 05          	shl    $0x5,%rcx
  8c7f05:	8b 04 08             	mov    (%rax,%rcx,1),%eax
  8c7f08:	c1 e8 03             	shr    $0x3,%eax
  8c7f0b:	3b 44 24 70          	cmp    0x70(%rsp),%eax
  8c7f0f:	73 11                	jae    8c7f22 <check_lower_drain+0x4792>
  8c7f11:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c7f18:	f6 04 01 02          	testb  $0x2,(%rcx,%rax,1)
  8c7f1c:	0f 85 4f 02 00 00    	jne    8c8171 <check_lower_drain+0x49e1>
  8c7f22:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c7f27:	c1 e8 03             	shr    $0x3,%eax
  8c7f2a:	3b 44 24 70          	cmp    0x70(%rsp),%eax
  8c7f2e:	73 14                	jae    8c7f44 <check_lower_drain+0x47b4>
  8c7f30:	48 8b 93 a0 01 00 00 	mov    0x1a0(%rbx),%rdx
  8c7f37:	48 89 c1             	mov    %rax,%rcx
  8c7f3a:	f6 04 0a 02          	testb  $0x2,(%rdx,%rcx,1)
  8c7f3e:	0f 85 2d 02 00 00    	jne    8c8171 <check_lower_drain+0x49e1>
  8c7f44:	48 89 df             	mov    %rbx,%rdi
  8c7f47:	89 ee                	mov    %ebp,%esi
  8c7f49:	c5 f8 77             	vzeroupper
  8c7f4c:	e8 ef 75 01 00       	call   8df540 <check_lower_update>
  8c7f51:	e9 13 05 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c7f56:	31 c0                	xor    %eax,%eax
  8c7f58:	45 89 cf             	mov    %r9d,%r15d
  8c7f5b:	44 2b bc 24 80 00 00 	sub    0x80(%rsp),%r15d
  8c7f62:	00 
  8c7f63:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  8c7f68:	4c 0f a3 ff          	bt     %r15,%rdi
  8c7f6c:	0f 83 37 01 00 00    	jae    8c80a9 <check_lower_drain+0x4919>
  8c7f72:	4d 01 f0             	add    %r14,%r8
  8c7f75:	41 83 78 44 00       	cmpl   $0x0,0x44(%r8)
  8c7f7a:	4c 89 44 24 50       	mov    %r8,0x50(%rsp)
  8c7f7f:	0f 85 24 01 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c7f85:	48 8b bc 24 98 00 00 	mov    0x98(%rsp),%rdi
  8c7f8c:	00 
  8c7f8d:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
  8c7f90:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
  8c7f95:	42 0f b6 54 7a 20    	movzbl 0x20(%rdx,%r15,2),%edx
  8c7f9b:	85 ff                	test   %edi,%edi
  8c7f9d:	41 0f 94 c0          	sete   %r8b
  8c7fa1:	41 20 c0             	and    %al,%r8b
  8c7fa4:	41 80 f8 01          	cmp    $0x1,%r8b
  8c7fa8:	75 2e                	jne    8c7fd8 <check_lower_drain+0x4848>
  8c7faa:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  8c7faf:	4d 8b b0 90 02 00 00 	mov    0x290(%r8),%r14
  8c7fb6:	45 8d 43 ff          	lea    -0x1(%r11),%r8d
  8c7fba:	43 80 3c 06 00       	cmpb   $0x0,(%r14,%r8,1)
  8c7fbf:	74 17                	je     8c7fd8 <check_lower_drain+0x4848>
  8c7fc1:	4c 8b 74 24 70       	mov    0x70(%rsp),%r14
  8c7fc6:	4d 8b b6 78 02 00 00 	mov    0x278(%r14),%r14
  8c7fcd:	43 80 3c 06 00       	cmpb   $0x0,(%r14,%r8,1)
  8c7fd2:	0f 84 d1 00 00 00    	je     8c80a9 <check_lower_drain+0x4919>
  8c7fd8:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
  8c7fdd:	45 8b 40 0c          	mov    0xc(%r8),%r8d
  8c7fe1:	45 85 c0             	test   %r8d,%r8d
  8c7fe4:	74 2f                	je     8c8015 <check_lower_drain+0x4885>
  8c7fe6:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  8c7feb:	41 83 7e 54 00       	cmpl   $0x0,0x54(%r14)
  8c7ff0:	75 23                	jne    8c8015 <check_lower_drain+0x4885>
  8c7ff2:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  8c7ff7:	45 0f b7 76 08       	movzwl 0x8(%r14),%r14d
  8c7ffc:	41 f7 c6 10 08 00 00 	test   $0x810,%r14d
  8c8003:	75 10                	jne    8c8015 <check_lower_drain+0x4885>
  8c8005:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  8c800a:	41 83 7e 04 00       	cmpl   $0x0,0x4(%r14)
  8c800f:	0f 84 0f 07 00 00    	je     8c8724 <check_lower_drain+0x4f94>
  8c8015:	85 ff                	test   %edi,%edi
  8c8017:	0f 85 8c 00 00 00    	jne    8c80a9 <check_lower_drain+0x4919>
  8c801d:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  8c8022:	83 7a 04 01          	cmpl   $0x1,0x4(%rdx)
  8c8026:	0f 94 c2             	sete   %dl
  8c8029:	20 c2                	and    %al,%dl
  8c802b:	80 fa 01             	cmp    $0x1,%dl
  8c802e:	75 79                	jne    8c80a9 <check_lower_drain+0x4919>
  8c8030:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c8035:	48 8b 43 68          	mov    0x68(%rbx),%rax
  8c8039:	4c 8b 74 24 68       	mov    0x68(%rsp),%r14
  8c803e:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  8c8045:	42 8b 3c 98          	mov    (%rax,%r11,4),%edi
  8c8049:	4d 8d 46 08          	lea    0x8(%r14),%r8
  8c804d:	31 c0                	xor    %eax,%eax
  8c804f:	42 8b 14 9a          	mov    (%rdx,%r11,4),%edx
  8c8053:	4d 8b 5e 08          	mov    0x8(%r14),%r11
  8c8057:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
  8c805c:	83 ff ff             	cmp    $0xffffffff,%edi
  8c805f:	0f 94 c0             	sete   %al
  8c8062:	c1 e0 09             	shl    $0x9,%eax
  8c8065:	05 00 02 00 00       	add    $0x200,%eax
  8c806a:	47 8b 1c b3          	mov    (%r11,%r14,4),%r11d
  8c806e:	44 89 9b 64 01 00 00 	mov    %r11d,0x164(%rbx)
  8c8075:	83 ff ff             	cmp    $0xffffffff,%edi
  8c8078:	0f 44 fa             	cmove  %edx,%edi
  8c807b:	0f 85 91 f6 ff ff    	jne    8c7712 <check_lower_drain+0x3f82>
  8c8081:	85 d2                	test   %edx,%edx
  8c8083:	74 3b                	je     8c80c0 <check_lower_drain+0x4930>
  8c8085:	e9 88 f6 ff ff       	jmp    8c7712 <check_lower_drain+0x3f82>
  8c808a:	83 fa 3e             	cmp    $0x3e,%edx
  8c808d:	0f 87 e9 01 00 00    	ja     8c827c <check_lower_drain+0x4aec>
  8c8093:	48 bf 00 00 00 00 08 	movabs $0x4080000800000000,%rdi
  8c809a:	00 80 40 
  8c809d:	89 d0                	mov    %edx,%eax
  8c809f:	48 0f a3 c7          	bt     %rax,%rdi
  8c80a3:	0f 83 d3 01 00 00    	jae    8c827c <check_lower_drain+0x4aec>
  8c80a9:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c80ae:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c80b3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c80b7:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c80ba:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c80c0:	66 81 fe ff 00       	cmp    $0xff,%si
  8c80c5:	74 14                	je     8c80db <check_lower_drain+0x494b>
  8c80c7:	8b 94 24 88 00 00 00 	mov    0x88(%rsp),%edx
  8c80ce:	48 89 df             	mov    %rbx,%rdi
  8c80d1:	31 c9                	xor    %ecx,%ecx
  8c80d3:	c5 f8 77             	vzeroupper
  8c80d6:	e8 75 0c 00 00       	call   8c8d50 <check_lower_instruction>
  8c80db:	83 7c 24 28 0f       	cmpl   $0xf,0x28(%rsp)
  8c80e0:	77 19                	ja     8c80fb <check_lower_drain+0x496b>
  8c80e2:	44 8b 44 24 40       	mov    0x40(%rsp),%r8d
  8c80e7:	ba 01 00 00 00       	mov    $0x1,%edx
  8c80ec:	48 89 df             	mov    %rbx,%rdi
  8c80ef:	89 ee                	mov    %ebp,%esi
  8c80f1:	31 c9                	xor    %ecx,%ecx
  8c80f3:	c5 f8 77             	vzeroupper
  8c80f6:	e8 85 0c 01 00       	call   8d8d80 <check_lower_operand>
  8c80fb:	44 8b 44 24 48       	mov    0x48(%rsp),%r8d
  8c8100:	48 89 df             	mov    %rbx,%rdi
  8c8103:	89 ee                	mov    %ebp,%esi
  8c8105:	31 d2                	xor    %edx,%edx
  8c8107:	31 c9                	xor    %ecx,%ecx
  8c8109:	c5 f8 77             	vzeroupper
  8c810c:	e8 6f 0c 01 00       	call   8d8d80 <check_lower_operand>
  8c8111:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c8116:	62 f2 fd 08 7c c1    	vpbroadcastq %rcx,%xmm0
  8c811c:	c5 f9 d4 83 40 05 00 	vpaddq 0x540(%rbx),%xmm0,%xmm0
  8c8123:	00 
  8c8124:	c5 fa 7f 83 40 05 00 	vmovdqu %xmm0,0x540(%rbx)
  8c812b:	00 
  8c812c:	e9 38 03 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c8131:	83 7c 24 30 1d       	cmpl   $0x1d,0x30(%rsp)
  8c8136:	0f 87 bf 01 00 00    	ja     8c82fb <check_lower_drain+0x4b6b>
  8c813c:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c8141:	b8 60 00 00 20       	mov    $0x20000060,%eax
  8c8146:	0f a3 c8             	bt     %ecx,%eax
  8c8149:	0f 83 ac 01 00 00    	jae    8c82fb <check_lower_drain+0x4b6b>
  8c814f:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
  8c8154:	41 c1 ee 03          	shr    $0x3,%r14d
  8c8158:	44 3b 74 24 70       	cmp    0x70(%rsp),%r14d
  8c815d:	73 24                	jae    8c8183 <check_lower_drain+0x49f3>
  8c815f:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c8166:	46 0f b6 2c 30       	movzbl (%rax,%r14,1),%r13d
  8c816b:	41 80 e5 08          	and    $0x8,%r13b
  8c816f:	eb 15                	jmp    8c8186 <check_lower_drain+0x49f6>
  8c8171:	48 89 df             	mov    %rbx,%rdi
  8c8174:	89 ee                	mov    %ebp,%esi
  8c8176:	c5 f8 77             	vzeroupper
  8c8179:	e8 62 6f 01 00       	call   8df0e0 <check_lower_complex_update>
  8c817e:	e9 e6 02 00 00       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c8183:	45 31 ed             	xor    %r13d,%r13d
  8c8186:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  8c818d:	00 
  8c818e:	c1 e8 03             	shr    $0x3,%eax
  8c8191:	3b 44 24 70          	cmp    0x70(%rsp),%eax
  8c8195:	73 16                	jae    8c81ad <check_lower_drain+0x4a1d>
  8c8197:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c819e:	44 0f b6 3c 01       	movzbl (%rcx,%rax,1),%r15d
  8c81a3:	41 80 e7 08          	and    $0x8,%r15b
  8c81a7:	41 c0 ef 03          	shr    $0x3,%r15b
  8c81ab:	eb 03                	jmp    8c81b0 <check_lower_drain+0x4a20>
  8c81ad:	45 31 ff             	xor    %r15d,%r15d
  8c81b0:	45 84 ed             	test   %r13b,%r13b
  8c81b3:	75 42                	jne    8c81f7 <check_lower_drain+0x4a67>
  8c81b5:	45 84 ff             	test   %r15b,%r15b
  8c81b8:	75 3d                	jne    8c81f7 <check_lower_drain+0x4a67>
  8c81ba:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8c81bf:	c5 f8 77             	vzeroupper
  8c81c2:	e8 79 0a 01 00       	call   8d8c40 <check_lower_binary>
  8c81c7:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c81cc:	0f b6 f0             	movzbl %al,%esi
  8c81cf:	48 89 df             	mov    %rbx,%rdi
  8c81d2:	31 c9                	xor    %ecx,%ecx
  8c81d4:	e8 77 0b 00 00       	call   8c8d50 <check_lower_instruction>
  8c81d9:	ba 01 00 00 00       	mov    $0x1,%edx
  8c81de:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  8c81e5:	00 
  8c81e6:	48 89 df             	mov    %rbx,%rdi
  8c81e9:	89 ee                	mov    %ebp,%esi
  8c81eb:	31 c9                	xor    %ecx,%ecx
  8c81ed:	e8 8e 0b 01 00       	call   8d8d80 <check_lower_operand>
  8c81f2:	e9 a2 e7 ff ff       	jmp    8c6999 <check_lower_drain+0x3209>
  8c81f7:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  8c81fe:	00 
  8c81ff:	45 84 ed             	test   %r13b,%r13b
  8c8202:	48 89 df             	mov    %rbx,%rdi
  8c8205:	41 0f 95 c4          	setne  %r12b
  8c8209:	89 c6                	mov    %eax,%esi
  8c820b:	0f 45 74 24 48       	cmovne 0x48(%rsp),%esi
  8c8210:	89 74 24 28          	mov    %esi,0x28(%rsp)
  8c8214:	c5 f8 77             	vzeroupper
  8c8217:	e8 64 80 01 00       	call   8e0280 <check_lower_stride>
  8c821c:	45 20 fc             	and    %r15b,%r12b
  8c821f:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  8c8224:	41 80 fc 01          	cmp    $0x1,%r12b
  8c8228:	0f 85 25 01 00 00    	jne    8c8353 <check_lower_drain+0x4bc3>
  8c822e:	83 7c 24 30 06       	cmpl   $0x6,0x30(%rsp)
  8c8233:	0f 85 1a 01 00 00    	jne    8c8353 <check_lower_drain+0x4bc3>
  8c8239:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c823f:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8245:	0f 83 27 02 00 00    	jae    8c8472 <check_lower_drain+0x4ce2>
  8c824b:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c824f:	8d 50 01             	lea    0x1(%rax),%edx
  8c8252:	48 c1 e0 04          	shl    $0x4,%rax
  8c8256:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c825c:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8263:	00 07 00 
  8c8266:	48 83 c2 0d          	add    $0xd,%rdx
  8c826a:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c826e:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8275:	00 00 
  8c8277:	e9 20 02 00 00       	jmp    8c849c <check_lower_drain+0x4d0c>
  8c827c:	41 83 fd 01          	cmp    $0x1,%r13d
  8c8280:	0f 85 23 fe ff ff    	jne    8c80a9 <check_lower_drain+0x4919>
  8c8286:	4d 8b 6e 10          	mov    0x10(%r14),%r13
  8c828a:	66 83 bc 24 94 00 00 	cmpw   $0x6,0x94(%rsp)
  8c8291:	00 06 
  8c8293:	c7 84 24 90 00 00 00 	movl   $0x1,0x90(%rsp)
  8c829a:	01 00 00 00 
  8c829e:	0f 87 c6 02 00 00    	ja     8c856a <check_lower_drain+0x4dda>
  8c82a4:	8b bc 24 94 00 00 00 	mov    0x94(%rsp),%edi
  8c82ab:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  8c82b2:	0f b7 d7             	movzwl %di,%edx
  8c82b5:	40 fe cf             	dec    %dil
  8c82b8:	89 f8                	mov    %edi,%eax
  8c82ba:	c0 e8 07             	shr    $0x7,%al
  8c82bd:	40 00 f8             	add    %dil,%al
  8c82c0:	bf 08 00 00 00       	mov    $0x8,%edi
  8c82c5:	d0 f8                	sar    $1,%al
  8c82c7:	c4 e2 79 f7 c7       	shlx   %eax,%edi,%eax
  8c82cc:	c4 c2 f9 f7 fe       	shlx   %rax,%r14,%rdi
  8c82d1:	c4 42 f8 f5 f5       	bzhi   %rax,%r13,%r14
  8c82d6:	ff c8                	dec    %eax
  8c82d8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8c82de:	c4 c2 fb f7 c6       	shrx   %rax,%r14,%rax
  8c82e3:	48 85 c0             	test   %rax,%rax
  8c82e6:	48 0f 44 f8          	cmove  %rax,%rdi
  8c82ea:	31 c0                	xor    %eax,%eax
  8c82ec:	f6 c2 01             	test   $0x1,%dl
  8c82ef:	4c 0f 45 ef          	cmovne %rdi,%r13
  8c82f3:	4d 09 f5             	or     %r14,%r13
  8c82f6:	e9 e2 f3 ff ff       	jmp    8c76dd <check_lower_drain+0x3f4d>
  8c82fb:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8c8300:	c5 f8 77             	vzeroupper
  8c8303:	e8 38 09 01 00       	call   8d8c40 <check_lower_binary>
  8c8308:	84 c0                	test   %al,%al
  8c830a:	0f 84 d8 01 00 00    	je     8c84e8 <check_lower_drain+0x4d58>
  8c8310:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c8315:	44 0f b6 f0          	movzbl %al,%r14d
  8c8319:	48 89 df             	mov    %rbx,%rdi
  8c831c:	44 89 f6             	mov    %r14d,%esi
  8c831f:	e8 fc 81 01 00       	call   8e0520 <check_lower_operation>
  8c8324:	44 89 f6             	mov    %r14d,%esi
  8c8327:	4c 8b b4 24 80 00 00 	mov    0x80(%rsp),%r14
  8c832e:	00 
  8c832f:	48 89 df             	mov    %rbx,%rdi
  8c8332:	44 89 f2             	mov    %r14d,%edx
  8c8335:	e8 f6 85 01 00       	call   8e0930 <check_lower_count>
  8c833a:	ba 01 00 00 00       	mov    $0x1,%edx
  8c833f:	48 89 df             	mov    %rbx,%rdi
  8c8342:	89 ee                	mov    %ebp,%esi
  8c8344:	31 c9                	xor    %ecx,%ecx
  8c8346:	45 89 f0             	mov    %r14d,%r8d
  8c8349:	e8 32 0a 01 00       	call   8d8d80 <check_lower_operand>
  8c834e:	e9 46 e6 ff ff       	jmp    8c6999 <check_lower_drain+0x3209>
  8c8353:	83 7c 24 30 1d       	cmpl   $0x1d,0x30(%rsp)
  8c8358:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  8c835d:	0f 95 c0             	setne  %al
  8c8360:	0a 4c 24 68          	or     0x68(%rsp),%cl
  8c8364:	08 c1                	or     %al,%cl
  8c8366:	f6 c1 01             	test   $0x1,%cl
  8c8369:	0f 84 99 01 00 00    	je     8c8508 <check_lower_drain+0x4d78>
  8c836f:	8b 74 24 28          	mov    0x28(%rsp),%esi
  8c8373:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c8378:	48 89 df             	mov    %rbx,%rdi
  8c837b:	e8 20 80 01 00       	call   8e03a0 <check_lower_scale>
  8c8380:	83 7c 24 30 06       	cmpl   $0x6,0x30(%rsp)
  8c8385:	0f 85 a2 01 00 00    	jne    8c852d <check_lower_drain+0x4d9d>
  8c838b:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8391:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8397:	0f 83 54 03 00 00    	jae    8c86f1 <check_lower_drain+0x4f61>
  8c839d:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c83a1:	8d 50 01             	lea    0x1(%rax),%edx
  8c83a4:	48 c1 e0 04          	shl    $0x4,%rax
  8c83a8:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c83ae:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c83b5:	00 07 00 
  8c83b8:	48 83 c2 06          	add    $0x6,%rdx
  8c83bc:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c83c0:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c83c7:	00 00 
  8c83c9:	e9 5f 01 00 00       	jmp    8c852d <check_lower_drain+0x4d9d>
  8c83ce:	83 7c 24 30 1b       	cmpl   $0x1b,0x30(%rsp)
  8c83d3:	0f 84 e1 fa ff ff    	je     8c7eba <check_lower_drain+0x472a>
  8c83d9:	85 c0                	test   %eax,%eax
  8c83db:	74 62                	je     8c843f <check_lower_drain+0x4caf>
  8c83dd:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c83e2:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c83e7:	48 89 df             	mov    %rbx,%rdi
  8c83ea:	31 c9                	xor    %ecx,%ecx
  8c83ec:	c5 f8 77             	vzeroupper
  8c83ef:	e8 5c 09 00 00       	call   8c8d50 <check_lower_instruction>
  8c83f4:	45 8b 04 24          	mov    (%r12),%r8d
  8c83f8:	48 89 df             	mov    %rbx,%rdi
  8c83fb:	89 ee                	mov    %ebp,%esi
  8c83fd:	31 d2                	xor    %edx,%edx
  8c83ff:	31 c9                	xor    %ecx,%ecx
  8c8401:	e8 7a 09 01 00       	call   8d8d80 <check_lower_operand>
  8c8406:	48 8d 84 24 98 01 00 	lea    0x198(%rsp),%rax
  8c840d:	00 
  8c840e:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
  8c8412:	c5 f8 11 00          	vmovups %xmm0,(%rax)
  8c8416:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8c841d:	00 
  8c841e:	c7 84 24 90 01 00 00 	movl   $0xa,0x190(%rsp)
  8c8425:	0a 00 00 00 
  8c8429:	44 89 b4 24 94 01 00 	mov    %r14d,0x194(%rsp)
  8c8430:	00 
  8c8431:	c5 fe 6f 84 24 90 01 	vmovdqu 0x190(%rsp),%ymm0
  8c8438:	00 00 
  8c843a:	e9 68 f7 ff ff       	jmp    8c7ba7 <check_lower_drain+0x4417>
  8c843f:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8443:	48 8b 00             	mov    (%rax),%rax
  8c8446:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c844d:	75 1a                	jne    8c8469 <check_lower_drain+0x4cd9>
  8c844f:	c7 80 f0 00 00 00 01 	movl   $0x1,0xf0(%rax)
  8c8456:	00 00 00 
  8c8459:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c845f:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8463:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8469:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c846d:	e9 32 b4 ff ff       	jmp    8c38a4 <check_lower_drain+0x114>
  8c8472:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8476:	48 8b 00             	mov    (%rax),%rax
  8c8479:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8480:	75 1a                	jne    8c849c <check_lower_drain+0x4d0c>
  8c8482:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8489:	00 00 00 
  8c848c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8492:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8496:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c849c:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c84a2:	0f 84 c9 00 00 00    	je     8c8571 <check_lower_drain+0x4de1>
  8c84a8:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c84ae:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c84b4:	0f 83 35 01 00 00    	jae    8c85ef <check_lower_drain+0x4e5f>
  8c84ba:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c84be:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8c84c3:	8d 50 01             	lea    0x1(%rax),%edx
  8c84c6:	48 c1 e0 04          	shl    $0x4,%rax
  8c84ca:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c84d0:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c84d7:	00 07 00 
  8c84da:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c84de:	48 89 74 01 08       	mov    %rsi,0x8(%rcx,%rax,1)
  8c84e3:	e9 31 01 00 00       	jmp    8c8619 <check_lower_drain+0x4e89>
  8c84e8:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c84ec:	48 8b 00             	mov    (%rax),%rax
  8c84ef:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c84f6:	0f 85 6d ff ff ff    	jne    8c8469 <check_lower_drain+0x4cd9>
  8c84fc:	48 8d 0d 64 dc e0 ff 	lea    -0x1f239c(%rip),%rcx        # 6d6167 <pp_string_value.meaning+0x22a22>
  8c8503:	e9 07 e1 ff ff       	jmp    8c660f <check_lower_drain+0x2e7f>
  8c8508:	0f b6 54 24 58       	movzbl 0x58(%rsp),%edx
  8c850d:	be 0a 00 00 00       	mov    $0xa,%esi
  8c8512:	48 89 df             	mov    %rbx,%rdi
  8c8515:	31 c9                	xor    %ecx,%ecx
  8c8517:	e8 34 08 00 00       	call   8c8d50 <check_lower_instruction>
  8c851c:	8b 74 24 28          	mov    0x28(%rsp),%esi
  8c8520:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c8525:	48 89 df             	mov    %rbx,%rdi
  8c8528:	e8 73 7e 01 00       	call   8e03a0 <check_lower_scale>
  8c852d:	45 31 ff             	xor    %r15d,%r15d
  8c8530:	45 84 ed             	test   %r13b,%r13b
  8c8533:	41 b8 50 00 00 00    	mov    $0x50,%r8d
  8c8539:	48 89 df             	mov    %rbx,%rdi
  8c853c:	89 ee                	mov    %ebp,%esi
  8c853e:	41 0f 94 c7          	sete   %r15b
  8c8542:	41 c0 ed 03          	shr    $0x3,%r13b
  8c8546:	31 c9                	xor    %ecx,%ecx
  8c8548:	41 0f b6 d5          	movzbl %r13b,%edx
  8c854c:	e8 2f 08 01 00       	call   8d8d80 <check_lower_operand>
  8c8551:	44 8b 44 24 28       	mov    0x28(%rsp),%r8d
  8c8556:	48 89 df             	mov    %rbx,%rdi
  8c8559:	89 ee                	mov    %ebp,%esi
  8c855b:	44 89 fa             	mov    %r15d,%edx
  8c855e:	31 c9                	xor    %ecx,%ecx
  8c8560:	e8 1b 08 01 00       	call   8d8d80 <check_lower_operand>
  8c8565:	e9 ff fe ff ff       	jmp    8c8469 <check_lower_drain+0x4cd9>
  8c856a:	31 c0                	xor    %eax,%eax
  8c856c:	e9 6c f1 ff ff       	jmp    8c76dd <check_lower_drain+0x3f4d>
  8c8571:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8c8576:	48 8b 08             	mov    (%rax),%rcx
  8c8579:	48 8b 40 20          	mov    0x20(%rax),%rax
  8c857d:	42 80 3c 31 0f       	cmpb   $0xf,(%rcx,%r14,1)
  8c8582:	75 10                	jne    8c8594 <check_lower_drain+0x4e04>
  8c8584:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c8589:	83 e2 07             	and    $0x7,%edx
  8c858c:	42 0b 14 b0          	or     (%rax,%r14,4),%edx
  8c8590:	89 54 24 28          	mov    %edx,0x28(%rsp)
  8c8594:	8b 74 24 28          	mov    0x28(%rsp),%esi
  8c8598:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
  8c859c:	48 89 df             	mov    %rbx,%rdi
  8c859f:	89 f2                	mov    %esi,%edx
  8c85a1:	c1 ea 03             	shr    $0x3,%edx
  8c85a4:	83 e6 07             	and    $0x7,%esi
  8c85a7:	0f b6 0c 11          	movzbl (%rcx,%rdx,1),%ecx
  8c85ab:	80 c1 f8             	add    $0xf8,%cl
  8c85ae:	80 f9 03             	cmp    $0x3,%cl
  8c85b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c85b6:	0f 43 f1             	cmovae %ecx,%esi
  8c85b9:	0b 34 90             	or     (%rax,%rdx,4),%esi
  8c85bc:	c5 fc 11 84 24 f0 01 	vmovups %ymm0,0x1f0(%rsp)
  8c85c3:	00 00 
  8c85c5:	c7 84 24 f0 01 00 00 	movl   $0x13,0x1f0(%rsp)
  8c85cc:	13 00 00 00 
  8c85d0:	89 b4 24 f8 01 00 00 	mov    %esi,0x1f8(%rsp)
  8c85d7:	c5 fe 6f 84 24 f0 01 	vmovdqu 0x1f0(%rsp),%ymm0
  8c85de:	00 00 
  8c85e0:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c85e5:	c5 f8 77             	vzeroupper
  8c85e8:	e8 13 45 00 00       	call   8ccb00 <check_lower_push>
  8c85ed:	eb 2a                	jmp    8c8619 <check_lower_drain+0x4e89>
  8c85ef:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c85f3:	48 8b 00             	mov    (%rax),%rax
  8c85f6:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c85fd:	75 1a                	jne    8c8619 <check_lower_drain+0x4e89>
  8c85ff:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8606:	00 00 00 
  8c8609:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c860f:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8613:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8619:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c861f:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8625:	73 2e                	jae    8c8655 <check_lower_drain+0x4ec5>
  8c8627:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c862b:	8d 50 01             	lea    0x1(%rax),%edx
  8c862e:	48 c1 e0 04          	shl    $0x4,%rax
  8c8632:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8638:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c863f:	00 07 00 
  8c8642:	48 83 c2 08          	add    $0x8,%rdx
  8c8646:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c864a:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8651:	00 00 
  8c8653:	eb 2a                	jmp    8c867f <check_lower_drain+0x4eef>
  8c8655:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8659:	48 8b 00             	mov    (%rax),%rax
  8c865c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8663:	75 1a                	jne    8c867f <check_lower_drain+0x4eef>
  8c8665:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c866c:	00 00 00 
  8c866f:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8675:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8679:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c867f:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8685:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c868b:	73 31                	jae    8c86be <check_lower_drain+0x4f2e>
  8c868d:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8691:	8d 50 01             	lea    0x1(%rax),%edx
  8c8694:	48 c1 e0 04          	shl    $0x4,%rax
  8c8698:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c869e:	48 ba 01 00 00 00 01 	movabs $0x8000100000001,%rdx
  8c86a5:	00 08 00 
  8c86a8:	48 83 c2 0b          	add    $0xb,%rdx
  8c86ac:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c86b0:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c86b7:	00 00 
  8c86b9:	e9 1b fb ff ff       	jmp    8c81d9 <check_lower_drain+0x4a49>
  8c86be:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c86c2:	48 8b 00             	mov    (%rax),%rax
  8c86c5:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c86cc:	0f 85 07 fb ff ff    	jne    8c81d9 <check_lower_drain+0x4a49>
  8c86d2:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c86d9:	00 00 00 
  8c86dc:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c86e2:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c86e6:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c86ec:	e9 e8 fa ff ff       	jmp    8c81d9 <check_lower_drain+0x4a49>
  8c86f1:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c86f5:	48 8b 00             	mov    (%rax),%rax
  8c86f8:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c86ff:	0f 85 28 fe ff ff    	jne    8c852d <check_lower_drain+0x4d9d>
  8c8705:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c870c:	00 00 00 
  8c870f:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8715:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8719:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c871f:	e9 09 fe ff ff       	jmp    8c852d <check_lower_drain+0x4d9d>
  8c8724:	83 ff 3e             	cmp    $0x3e,%edi
  8c8727:	77 16                	ja     8c873f <check_lower_drain+0x4faf>
  8c8729:	49 bb 00 00 00 00 08 	movabs $0x4080000800000000,%r11
  8c8730:	00 80 40 
  8c8733:	89 f8                	mov    %edi,%eax
  8c8735:	49 0f a3 c3          	bt     %rax,%r11
  8c8739:	0f 82 6a f9 ff ff    	jb     8c80a9 <check_lower_drain+0x4919>
  8c873f:	41 83 f8 01          	cmp    $0x1,%r8d
  8c8743:	0f 85 60 f9 ff ff    	jne    8c80a9 <check_lower_drain+0x4919>
  8c8749:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8c874e:	48 8b 78 10          	mov    0x10(%rax),%rdi
  8c8752:	66 83 fa 06          	cmp    $0x6,%dx
  8c8756:	77 49                	ja     8c87a1 <check_lower_drain+0x5011>
  8c8758:	0f b7 c2             	movzwl %dx,%eax
  8c875b:	fe ca                	dec    %dl
  8c875d:	49 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%r11
  8c8764:	41 89 d0             	mov    %edx,%r8d
  8c8767:	41 c0 e8 07          	shr    $0x7,%r8b
  8c876b:	41 00 d0             	add    %dl,%r8b
  8c876e:	ba 08 00 00 00       	mov    $0x8,%edx
  8c8773:	41 d0 f8             	sar    $1,%r8b
  8c8776:	c4 e2 39 f7 d2       	shlx   %r8d,%edx,%edx
  8c877b:	c4 42 e9 f7 c3       	shlx   %rdx,%r11,%r8
  8c8780:	c4 62 e8 f5 df       	bzhi   %rdx,%rdi,%r11
  8c8785:	ff ca                	dec    %edx
  8c8787:	bf 00 00 00 00       	mov    $0x0,%edi
  8c878c:	c4 c2 eb f7 d3       	shrx   %rdx,%r11,%rdx
  8c8791:	48 85 d2             	test   %rdx,%rdx
  8c8794:	4c 0f 44 c2          	cmove  %rdx,%r8
  8c8798:	a8 01                	test   $0x1,%al
  8c879a:	49 0f 45 f8          	cmovne %r8,%rdi
  8c879e:	4c 09 df             	or     %r11,%rdi
  8c87a1:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
  8c87a6:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c87ab:	49 8b 40 08          	mov    0x8(%r8),%rax
  8c87af:	49 83 c0 08          	add    $0x8,%r8
  8c87b3:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  8c87b6:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c87bc:	b8 00 01 00 00       	mov    $0x100,%eax
  8c87c1:	e9 4c ef ff ff       	jmp    8c7712 <check_lower_drain+0x3f82>
  8c87c6:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c87cd:	00 00 
  8c87cf:	48 3b 84 24 30 02 00 	cmp    0x230(%rsp),%rax
  8c87d6:	00 
  8c87d7:	75 15                	jne    8c87ee <check_lower_drain+0x505e>
  8c87d9:	48 81 c4 38 02 00 00 	add    $0x238,%rsp
  8c87e0:	5b                   	pop    %rbx
  8c87e1:	41 5c                	pop    %r12
  8c87e3:	41 5d                	pop    %r13
  8c87e5:	41 5e                	pop    %r14
  8c87e7:	41 5f                	pop    %r15
  8c87e9:	5d                   	pop    %rbp
  8c87ea:	c5 f8 77             	vzeroupper
  8c87ed:	c3                   	ret
  8c87ee:	c5 f8 77             	vzeroupper
  8c87f1:	e8 3a 4e f0 ff       	call   7cd630 <__stack_chk_fail@plt>
