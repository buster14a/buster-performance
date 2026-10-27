
/home/david/buster-fast-bench/codex-180-fix-20261027-align64/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001501770 <run_backend_benchmark>:
 1501770:	55                   	push   %rbp
 1501771:	48 89 e5             	mov    %rsp,%rbp
 1501774:	41 57                	push   %r15
 1501776:	41 56                	push   %r14
 1501778:	41 55                	push   %r13
 150177a:	41 54                	push   %r12
 150177c:	53                   	push   %rbx
 150177d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 1501781:	48 81 ec c0 2c 00 00 	sub    $0x2cc0,%rsp
 1501788:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1501791:	48 89 84 24 80 2c 00 00 	mov    %rax,0x2c80(%rsp)
 1501799:	83 ff 02             	cmp    $0x2,%edi
 150179c:	0f 8c dc 01 00 00    	jl     150197e <run_backend_benchmark+0x20e>
 15017a2:	b8 04 00 00 00       	mov    $0x4,%eax
 15017a7:	41 bc 03 00 00 00    	mov    $0x3,%r12d
 15017ad:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 15017b3:	48 89 f3             	mov    %rsi,%rbx
 15017b6:	41 89 fe             	mov    %edi,%r14d
 15017b9:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 15017c5:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 15017ca:	48 89 84 24 c8 00 00 00 	mov    %rax,0xc8(%rsp)
 15017d2:	b8 01 00 00 00       	mov    $0x1,%eax
 15017d7:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 15017df:	b8 00 00 04 00       	mov    $0x40000,%eax
 15017e4:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 15017ec:	0f 1f 40 00          	nopl   0x0(%rax)
 15017f0:	41 8d 44 24 fe       	lea    -0x2(%r12),%eax
 15017f5:	48 8d 35 3c 6b 12 ff 	lea    -0xed94c4(%rip),%rsi        # 628338 <fuzz_comment_end+0x14ae9>
 15017fc:	48 98                	cltq
 15017fe:	4c 8b 2c c3          	mov    (%rbx,%rax,8),%r13
 1501802:	4c 89 ef             	mov    %r13,%rdi
 1501805:	e8 96 2c 26 ff       	call   7644a0 <strcmp@plt>
 150180a:	85 c0                	test   %eax,%eax
 150180c:	75 32                	jne    1501840 <run_backend_benchmark+0xd0>
 150180e:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 1501813:	44 39 f0             	cmp    %r14d,%eax
 1501816:	7d 28                	jge    1501840 <run_backend_benchmark+0xd0>
 1501818:	48 98                	cltq
 150181a:	41 ff c7             	inc    %r15d
 150181d:	31 f6                	xor    %esi,%esi
 150181f:	31 d2                	xor    %edx,%edx
 1501821:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 1501825:	e8 36 23 26 ff       	call   763b60 <strtoull@plt>
 150182a:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 1501832:	b0 01                	mov    $0x1,%al
 1501834:	e9 2a 01 00 00       	jmp    1501963 <run_backend_benchmark+0x1f3>
 1501839:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1501840:	48 8d 35 b6 08 0e ff 	lea    -0xf1f74a(%rip),%rsi        # 5e20fd <foreign_touch.flags+0xebd0>
 1501847:	4c 89 ef             	mov    %r13,%rdi
 150184a:	e8 51 2c 26 ff       	call   7644a0 <strcmp@plt>
 150184f:	85 c0                	test   %eax,%eax
 1501851:	75 2d                	jne    1501880 <run_backend_benchmark+0x110>
 1501853:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 1501858:	44 39 f0             	cmp    %r14d,%eax
 150185b:	7d 23                	jge    1501880 <run_backend_benchmark+0x110>
 150185d:	48 98                	cltq
 150185f:	41 ff c7             	inc    %r15d
 1501862:	31 f6                	xor    %esi,%esi
 1501864:	31 d2                	xor    %edx,%edx
 1501866:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 150186a:	e8 f1 22 26 ff       	call   763b60 <strtoull@plt>
 150186f:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 1501877:	b0 01                	mov    $0x1,%al
 1501879:	e9 e5 00 00 00       	jmp    1501963 <run_backend_benchmark+0x1f3>
 150187e:	66 90                	xchg   %ax,%ax
 1501880:	48 8d 35 b3 5e 0c ff 	lea    -0xf3a14d(%rip),%rsi        # 5c773a <parse_test_openers+0x3c581>
 1501887:	4c 89 ef             	mov    %r13,%rdi
 150188a:	e8 11 2c 26 ff       	call   7644a0 <strcmp@plt>
 150188f:	85 c0                	test   %eax,%eax
 1501891:	75 2d                	jne    15018c0 <run_backend_benchmark+0x150>
 1501893:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 1501898:	44 39 f0             	cmp    %r14d,%eax
 150189b:	7d 23                	jge    15018c0 <run_backend_benchmark+0x150>
 150189d:	48 98                	cltq
 150189f:	41 ff c7             	inc    %r15d
 15018a2:	31 f6                	xor    %esi,%esi
 15018a4:	31 d2                	xor    %edx,%edx
 15018a6:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 15018aa:	e8 b1 22 26 ff       	call   763b60 <strtoull@plt>
 15018af:	48 89 84 24 18 01 00 00 	mov    %rax,0x118(%rsp)
 15018b7:	b0 01                	mov    $0x1,%al
 15018b9:	e9 a5 00 00 00       	jmp    1501963 <run_backend_benchmark+0x1f3>
 15018be:	66 90                	xchg   %ax,%ax
 15018c0:	48 8d 35 d1 84 0f ff 	lea    -0xf07b2f(%rip),%rsi        # 5f9d98 <foreign_touch.flags+0x2686b>
 15018c7:	4c 89 ef             	mov    %r13,%rdi
 15018ca:	e8 d1 2b 26 ff       	call   7644a0 <strcmp@plt>
 15018cf:	85 c0                	test   %eax,%eax
 15018d1:	0f 85 de 00 00 00    	jne    15019b5 <run_backend_benchmark+0x245>
 15018d7:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 15018dc:	44 39 f0             	cmp    %r14d,%eax
 15018df:	0f 8d d0 00 00 00    	jge    15019b5 <run_backend_benchmark+0x245>
 15018e5:	48 98                	cltq
 15018e7:	48 8d 35 bf 44 0e ff 	lea    -0xf1bb41(%rip),%rsi        # 5e5dad <foreign_touch.flags+0x12880>
 15018ee:	41 ff c7             	inc    %r15d
 15018f1:	4c 8b 2c c3          	mov    (%rbx,%rax,8),%r13
 15018f5:	4c 89 ef             	mov    %r13,%rdi
 15018f8:	e8 a3 2b 26 ff       	call   7644a0 <strcmp@plt>
 15018fd:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 1501905:	85 c0                	test   %eax,%eax
 1501907:	48 8d 35 e8 07 0e ff 	lea    -0xf1f818(%rip),%rsi        # 5e20f6 <foreign_touch.flags+0xebc9>
 150190e:	4c 89 ef             	mov    %r13,%rdi
 1501911:	0f 44 d8             	cmove  %eax,%ebx
 1501914:	e8 87 2b 26 ff       	call   7644a0 <strcmp@plt>
 1501919:	85 c0                	test   %eax,%eax
 150191b:	b8 01 00 00 00       	mov    $0x1,%eax
 1501920:	48 8d 35 a1 6a 12 ff 	lea    -0xed955f(%rip),%rsi        # 6283c8 <fuzz_comment_end+0x14b79>
 1501927:	4c 89 ef             	mov    %r13,%rdi
 150192a:	0f 44 d8             	cmove  %eax,%ebx
 150192d:	e8 6e 2b 26 ff       	call   7644a0 <strcmp@plt>
 1501932:	85 c0                	test   %eax,%eax
 1501934:	b8 02 00 00 00       	mov    $0x2,%eax
 1501939:	48 8d 35 c2 5d 15 ff 	lea    -0xeaa23e(%rip),%rsi        # 657702 <fuzz_comment_end+0x43eb3>
 1501940:	4c 89 ef             	mov    %r13,%rdi
 1501943:	0f 44 d8             	cmove  %eax,%ebx
 1501946:	e8 55 2b 26 ff       	call   7644a0 <strcmp@plt>
 150194b:	85 c0                	test   %eax,%eax
 150194d:	b9 03 00 00 00       	mov    $0x3,%ecx
 1501952:	0f 44 d9             	cmove  %ecx,%ebx
 1501955:	83 fb 04             	cmp    $0x4,%ebx
 1501958:	48 89 9c 24 c8 00 00 00 	mov    %rbx,0xc8(%rsp)
 1501960:	0f 95 c0             	setne  %al
 1501963:	45 39 f4             	cmp    %r14d,%r12d
 1501966:	7d 4f                	jge    15019b7 <run_backend_benchmark+0x247>
 1501968:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
 150196d:	41 ff c7             	inc    %r15d
 1501970:	41 83 c4 02          	add    $0x2,%r12d
 1501974:	84 c0                	test   %al,%al
 1501976:	0f 85 74 fe ff ff    	jne    15017f0 <run_backend_benchmark+0x80>
 150197c:	eb 39                	jmp    15019b7 <run_backend_benchmark+0x247>
 150197e:	b8 00 00 04 00       	mov    $0x40000,%eax
 1501983:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 150198f:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 1501997:	b8 01 00 00 00       	mov    $0x1,%eax
 150199c:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 15019a4:	b8 04 00 00 00       	mov    $0x4,%eax
 15019a9:	48 89 84 24 c8 00 00 00 	mov    %rax,0xc8(%rsp)
 15019b1:	31 c0                	xor    %eax,%eax
 15019b3:	eb 04                	jmp    15019b9 <run_backend_benchmark+0x249>
 15019b5:	31 c0                	xor    %eax,%eax
 15019b7:	34 01                	xor    $0x1,%al
 15019b9:	84 c0                	test   %al,%al
 15019bb:	0f 85 5c 90 00 00    	jne    150aa1d <run_backend_benchmark+0x92ad>
 15019c1:	48 83 bc 24 20 01 00 00 00 	cmpq   $0x0,0x120(%rsp)
 15019ca:	0f 84 4d 90 00 00    	je     150aa1d <run_backend_benchmark+0x92ad>
 15019d0:	48 81 bc 24 18 01 00 00 10 27 00 00 	cmpq   $0x2710,0x118(%rsp)
 15019dc:	0f 87 3b 90 00 00    	ja     150aa1d <run_backend_benchmark+0x92ad>
 15019e2:	48 8d 35 67 ca b4 00 	lea    0xb4ca67(%rip),%rsi        # 204e450 <x86_form_descriptions>
 15019e9:	48 8d 15 d0 4e 16 0d 	lea    0xd164ed0(%rip),%rdx        # e6668c0 <x86_template_storage+0x40>
 15019f0:	31 ff                	xor    %edi,%edi
 15019f2:	48 c7 84 24 c0 00 00 00 00 00 00 00 	movq   $0x0,0xc0(%rsp)
 15019fe:	e8 3d fb ff ff       	call   1501540 <x86_build_nonlegacy_templates>
 1501a03:	84 c0                	test   %al,%al
 1501a05:	0f 84 8b 90 00 00    	je     150aa96 <run_backend_benchmark+0x9326>
 1501a0b:	48 8d 1d ee c6 4e 0d 	lea    0xd4ec6ee(%rip),%rbx        # e9ee100 <x86_effects_index>
 1501a12:	ba 40 41 00 00       	mov    $0x4140,%edx
 1501a17:	31 f6                	xor    %esi,%esi
 1501a19:	48 89 df             	mov    %rbx,%rdi
 1501a1c:	e8 0f 29 26 ff       	call   764330 <memset@plt>
 1501a21:	c5 fa 6f 05 47 4a 07 ff 	vmovdqu -0xf8b5b9(%rip),%xmm0        # 576470 <x86_effects_unknown>
 1501a29:	41 bd 01 00 00 00    	mov    $0x1,%r13d
 1501a2f:	4c 8d 1d 8a 0d 02 ff 	lea    -0xfdf276(%rip),%r11        # 5227c0 <x86_effects_rows>
 1501a36:	66 b9 01 00          	mov    $0x1,%cx
 1501a3a:	66 b8 13 00          	mov    $0x13,%ax
 1501a3e:	4c 8d 0d 1b eb 01 ff 	lea    -0xfe14e5(%rip),%r9        # 520560 <branch_sizing_patterns+0x7d0>
 1501a45:	4c 8d 3d ec ea 01 ff 	lea    -0xfe1514(%rip),%r15        # 520538 <branch_sizing_patterns+0x7a8>
 1501a4c:	4c 8d 25 d1 ea 01 ff 	lea    -0xfe152f(%rip),%r12        # 520524 <branch_sizing_patterns+0x794>
 1501a53:	c5 f9 7f 05 e5 07 4f 0d 	vmovdqa %xmm0,0xd4f07e5(%rip)        # e9f2240 <x86_effects_records>
 1501a5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1501a60:	0f b7 c0             	movzwl %ax,%eax
 1501a63:	0f b7 f9             	movzwl %cx,%edi
 1501a66:	45 89 ed             	mov    %r13d,%r13d
 1501a69:	4c 89 5c 24 58       	mov    %r11,0x58(%rsp)
 1501a6e:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
 1501a73:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1501a80:	66 83 3c 7b 00       	cmpw   $0x0,(%rbx,%rdi,2)
 1501a85:	0f 85 e5 0e 00 00    	jne    1502970 <run_backend_benchmark+0x1200>
 1501a8b:	49 81 fd ff 03 00 00 	cmp    $0x3ff,%r13
 1501a92:	0f 87 d8 0e 00 00    	ja     1502970 <run_backend_benchmark+0x1200>
 1501a98:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
 1501a9c:	48 8d 0d ad c9 b4 00 	lea    0xb4c9ad(%rip),%rcx        # 204e450 <x86_form_descriptions>
 1501aa3:	c7 84 24 00 0d 00 00 00 00 00 00 	movl   $0x0,0xd00(%rsp)
 1501aae:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 1501ab7:	4c 89 ac 24 80 00 00 00 	mov    %r13,0x80(%rsp)
 1501abf:	48 89 bc 24 a0 00 00 00 	mov    %rdi,0xa0(%rsp)
 1501ac7:	0f b6 74 c1 1b       	movzbl 0x1b(%rcx,%rax,8),%esi
 1501acc:	48 8d 14 c1          	lea    (%rcx,%rax,8),%rdx
 1501ad0:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 1501ad8:	ba 00 00 00 00       	mov    $0x0,%edx
 1501add:	48 83 fe 0d          	cmp    $0xd,%rsi
 1501ae1:	77 19                	ja     1501afc <run_backend_benchmark+0x38c>
 1501ae3:	48 8d 0d da e8 01 ff 	lea    -0xfe1726(%rip),%rcx        # 5203c4 <branch_sizing_patterns+0x634>
 1501aea:	48 8d 1d 1f ea 01 ff 	lea    -0xfe15e1(%rip),%rbx        # 520510 <branch_sizing_patterns+0x780>
 1501af1:	48 63 04 b1          	movslq (%rcx,%rsi,4),%rax
 1501af5:	48 01 c8             	add    %rcx,%rax
 1501af8:	ff e0                	jmp    *%rax
 1501afa:	b2 01                	mov    $0x1,%dl
 1501afc:	41 0f b7 43 06       	movzwl 0x6(%r11),%eax
 1501b01:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 1501b06:	45 31 f6             	xor    %r14d,%r14d
 1501b09:	45 31 d2             	xor    %r10d,%r10d
 1501b0c:	89 44 24 30          	mov    %eax,0x30(%rsp)
 1501b10:	e9 fe 09 00 00       	jmp    1502513 <run_backend_benchmark+0xda3>
 1501b15:	b0 05                	mov    $0x5,%al
 1501b17:	eb 02                	jmp    1501b1b <run_backend_benchmark+0x3ab>
 1501b19:	b0 04                	mov    $0x4,%al
 1501b1b:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501b20:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 1501b25:	be 02 00 00 00       	mov    $0x2,%esi
 1501b2a:	88 84 24 01 0d 00 00 	mov    %al,0xd01(%rsp)
 1501b31:	31 c0                	xor    %eax,%eax
 1501b33:	eb 5f                	jmp    1501b94 <run_backend_benchmark+0x424>
 1501b35:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 1501b3a:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 1501b3f:	45 0f b7 73 06       	movzwl 0x6(%r11),%r14d
 1501b44:	be 02 00 00 00       	mov    $0x2,%esi
 1501b49:	c6 84 24 01 0d 00 00 05 	movb   $0x5,0xd01(%rsp)
 1501b51:	45 31 d2             	xor    %r10d,%r10d
 1501b54:	8d 41 ff             	lea    -0x1(%rcx),%eax
 1501b57:	3c 04                	cmp    $0x4,%al
 1501b59:	73 1f                	jae    1501b7a <run_backend_benchmark+0x40a>
 1501b5b:	0f b6 c0             	movzbl %al,%eax
 1501b5e:	48 8d 15 0f eb 07 ff 	lea    -0xf814f1(%rip),%rdx        # 580674 <tier0_generate_expression.floating_operations+0x8>
 1501b65:	4c 8d 05 0c eb 07 ff 	lea    -0xf814f4(%rip),%r8        # 580678 <tier0_generate_expression.floating_operations+0xc>
 1501b6c:	0f b6 14 10          	movzbl (%rax,%rdx,1),%edx
 1501b70:	42 0f b6 04 00       	movzbl (%rax,%r8,1),%eax
 1501b75:	09 c7                	or     %eax,%edi
 1501b77:	41 09 d6             	or     %edx,%r14d
 1501b7a:	44 89 74 24 30       	mov    %r14d,0x30(%rsp)
 1501b7f:	45 31 f6             	xor    %r14d,%r14d
 1501b82:	0f b6 c1             	movzbl %cl,%eax
 1501b85:	8d 48 ff             	lea    -0x1(%rax),%ecx
 1501b88:	83 f9 03             	cmp    $0x3,%ecx
 1501b8b:	72 5e                	jb     1501beb <run_backend_benchmark+0x47b>
 1501b8d:	e9 b4 04 00 00       	jmp    1502046 <run_backend_benchmark+0x8d6>
 1501b92:	b0 01                	mov    $0x1,%al
 1501b94:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 1501b99:	41 be 00 00 00 00    	mov    $0x0,%r14d
 1501b9f:	45 31 d2             	xor    %r10d,%r10d
 1501ba2:	8d 51 ff             	lea    -0x1(%rcx),%edx
 1501ba5:	80 fa 04             	cmp    $0x4,%dl
 1501ba8:	73 0f                	jae    1501bb9 <run_backend_benchmark+0x449>
 1501baa:	0f b6 d2             	movzbl %dl,%edx
 1501bad:	48 8d 3d bc ea 07 ff 	lea    -0xf81544(%rip),%rdi        # 580670 <tier0_generate_expression.floating_operations+0x4>
 1501bb4:	44 0f b6 34 3a       	movzbl (%rdx,%rdi,1),%r14d
 1501bb9:	41 0f b7 53 06       	movzwl 0x6(%r11),%edx
 1501bbe:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 1501bc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 1501bc9:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
 1501bce:	89 54 24 30          	mov    %edx,0x30(%rsp)
 1501bd2:	b2 01                	mov    $0x1,%dl
 1501bd4:	84 c0                	test   %al,%al
 1501bd6:	0f 85 37 09 00 00    	jne    1502513 <run_backend_benchmark+0xda3>
 1501bdc:	0f b6 c1             	movzbl %cl,%eax
 1501bdf:	8d 48 ff             	lea    -0x1(%rax),%ecx
 1501be2:	83 f9 03             	cmp    $0x3,%ecx
 1501be5:	0f 83 5b 04 00 00    	jae    1502046 <run_backend_benchmark+0x8d6>
 1501beb:	4c 8d 6e ff          	lea    -0x1(%rsi),%r13
 1501bef:	48 8d 15 56 e9 01 ff 	lea    -0xfe16aa(%rip),%rdx        # 52054c <branch_sizing_patterns+0x7bc>
 1501bf6:	83 c6 fe             	add    $0xfffffffe,%esi
 1501bf9:	45 89 eb             	mov    %r13d,%r11d
 1501bfc:	41 83 e3 07          	and    $0x7,%r11d
 1501c00:	83 fe 07             	cmp    $0x7,%esi
 1501c03:	73 0c                	jae    1501c11 <run_backend_benchmark+0x4a1>
 1501c05:	b9 01 00 00 00       	mov    $0x1,%ecx
 1501c0a:	31 f6                	xor    %esi,%esi
 1501c0c:	e9 4b 03 00 00       	jmp    1501f5c <run_backend_benchmark+0x7ec>
 1501c11:	49 83 e5 f8          	and    $0xfffffffffffffff8,%r13
 1501c15:	48 8d 35 e0 e8 01 ff 	lea    -0xfe1720(%rip),%rsi        # 5204fc <branch_sizing_patterns+0x76c>
 1501c1c:	31 c9                	xor    %ecx,%ecx
 1501c1e:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 1501c27:	eb 14                	jmp    1501c3d <run_backend_benchmark+0x4cd>
 1501c29:	83 cf 02             	or     $0x2,%edi
 1501c2c:	0f 1f 40 00          	nopl   0x0(%rax)
 1501c30:	48 83 c1 08          	add    $0x8,%rcx
 1501c34:	49 39 cd             	cmp    %rcx,%r13
 1501c37:	0f 84 0e 03 00 00    	je     1501f4b <run_backend_benchmark+0x7db>
 1501c3d:	0f b6 84 0c 01 0d 00 00 	movzbl 0xd01(%rsp,%rcx,1),%eax
 1501c45:	48 83 f8 04          	cmp    $0x4,%rax
 1501c49:	77 65                	ja     1501cb0 <run_backend_benchmark+0x540>
 1501c4b:	4c 8d 05 6e e8 01 ff 	lea    -0xfe1792(%rip),%r8        # 5204c0 <branch_sizing_patterns+0x730>
 1501c52:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 1501c56:	4c 01 c0             	add    %r8,%rax
 1501c59:	ff e0                	jmp    *%rax
 1501c5b:	41 83 ca 01          	or     $0x1,%r10d
 1501c5f:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 1501c67:	48 83 f8 04          	cmp    $0x4,%rax
 1501c6b:	76 51                	jbe    1501cbe <run_backend_benchmark+0x54e>
 1501c6d:	e9 9e 00 00 00       	jmp    1501d10 <run_backend_benchmark+0x5a0>
 1501c72:	83 cf 02             	or     $0x2,%edi
 1501c75:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 1501c7d:	48 83 f8 04          	cmp    $0x4,%rax
 1501c81:	76 3b                	jbe    1501cbe <run_backend_benchmark+0x54e>
 1501c83:	e9 88 00 00 00       	jmp    1501d10 <run_backend_benchmark+0x5a0>
 1501c88:	b8 01 00 00 00       	mov    $0x1,%eax
 1501c8d:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501c92:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 1501c9a:	48 83 f8 04          	cmp    $0x4,%rax
 1501c9e:	76 1e                	jbe    1501cbe <run_backend_benchmark+0x54e>
 1501ca0:	eb 6e                	jmp    1501d10 <run_backend_benchmark+0x5a0>
 1501ca2:	83 cf 01             	or     $0x1,%edi
 1501ca5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1501cb0:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 1501cb8:	48 83 f8 04          	cmp    $0x4,%rax
 1501cbc:	77 52                	ja     1501d10 <run_backend_benchmark+0x5a0>
 1501cbe:	4c 8d 05 0f e8 01 ff 	lea    -0xfe17f1(%rip),%r8        # 5204d4 <branch_sizing_patterns+0x744>
 1501cc5:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 1501cc9:	4c 01 c0             	add    %r8,%rax
 1501ccc:	ff e0                	jmp    *%rax
 1501cce:	41 83 ca 01          	or     $0x1,%r10d
 1501cd2:	eb 3c                	jmp    1501d10 <run_backend_benchmark+0x5a0>
 1501cd4:	83 cf 02             	or     $0x2,%edi
 1501cd7:	eb 37                	jmp    1501d10 <run_backend_benchmark+0x5a0>
 1501cd9:	b8 01 00 00 00       	mov    $0x1,%eax
 1501cde:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501ce3:	eb 2b                	jmp    1501d10 <run_backend_benchmark+0x5a0>
 1501ce5:	83 cf 01             	or     $0x1,%edi
 1501ce8:	eb 26                	jmp    1501d10 <run_backend_benchmark+0x5a0>
 1501cea:	41 83 ce 01          	or     $0x1,%r14d
 1501cee:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 1501cf6:	48 83 f8 04          	cmp    $0x4,%rax
 1501cfa:	76 c2                	jbe    1501cbe <run_backend_benchmark+0x54e>
 1501cfc:	eb 12                	jmp    1501d10 <run_backend_benchmark+0x5a0>
 1501cfe:	41 83 ce 01          	or     $0x1,%r14d
 1501d02:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1501d10:	0f b6 84 0c 03 0d 00 00 	movzbl 0xd03(%rsp,%rcx,1),%eax
 1501d18:	48 83 f8 04          	cmp    $0x4,%rax
 1501d1c:	77 62                	ja     1501d80 <run_backend_benchmark+0x610>
 1501d1e:	4c 8d 05 c3 e7 01 ff 	lea    -0xfe183d(%rip),%r8        # 5204e8 <branch_sizing_patterns+0x758>
 1501d25:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 1501d29:	4c 01 c0             	add    %r8,%rax
 1501d2c:	ff e0                	jmp    *%rax
 1501d2e:	41 83 ca 01          	or     $0x1,%r10d
 1501d32:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 1501d3a:	48 83 f8 04          	cmp    $0x4,%rax
 1501d3e:	76 4e                	jbe    1501d8e <run_backend_benchmark+0x61e>
 1501d40:	e9 8b 00 00 00       	jmp    1501dd0 <run_backend_benchmark+0x660>
 1501d45:	83 cf 02             	or     $0x2,%edi
 1501d48:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 1501d50:	48 83 f8 04          	cmp    $0x4,%rax
 1501d54:	76 38                	jbe    1501d8e <run_backend_benchmark+0x61e>
 1501d56:	eb 78                	jmp    1501dd0 <run_backend_benchmark+0x660>
 1501d58:	b8 01 00 00 00       	mov    $0x1,%eax
 1501d5d:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501d62:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 1501d6a:	48 83 f8 04          	cmp    $0x4,%rax
 1501d6e:	76 1e                	jbe    1501d8e <run_backend_benchmark+0x61e>
 1501d70:	eb 5e                	jmp    1501dd0 <run_backend_benchmark+0x660>
 1501d72:	83 cf 01             	or     $0x1,%edi
 1501d75:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1501d80:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 1501d88:	48 83 f8 04          	cmp    $0x4,%rax
 1501d8c:	77 42                	ja     1501dd0 <run_backend_benchmark+0x660>
 1501d8e:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 1501d92:	48 01 f0             	add    %rsi,%rax
 1501d95:	ff e0                	jmp    *%rax
 1501d97:	41 83 ca 01          	or     $0x1,%r10d
 1501d9b:	eb 33                	jmp    1501dd0 <run_backend_benchmark+0x660>
 1501d9d:	83 cf 02             	or     $0x2,%edi
 1501da0:	eb 2e                	jmp    1501dd0 <run_backend_benchmark+0x660>
 1501da2:	b8 01 00 00 00       	mov    $0x1,%eax
 1501da7:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501dac:	eb 22                	jmp    1501dd0 <run_backend_benchmark+0x660>
 1501dae:	83 cf 01             	or     $0x1,%edi
 1501db1:	eb 1d                	jmp    1501dd0 <run_backend_benchmark+0x660>
 1501db3:	41 83 ce 01          	or     $0x1,%r14d
 1501db7:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 1501dbf:	48 83 f8 04          	cmp    $0x4,%rax
 1501dc3:	76 c9                	jbe    1501d8e <run_backend_benchmark+0x61e>
 1501dc5:	eb 09                	jmp    1501dd0 <run_backend_benchmark+0x660>
 1501dc7:	41 83 ce 01          	or     $0x1,%r14d
 1501dcb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1501dd0:	0f b6 84 0c 05 0d 00 00 	movzbl 0xd05(%rsp,%rcx,1),%eax
 1501dd8:	48 83 f8 04          	cmp    $0x4,%rax
 1501ddc:	77 52                	ja     1501e30 <run_backend_benchmark+0x6c0>
 1501dde:	48 63 04 83          	movslq (%rbx,%rax,4),%rax
 1501de2:	48 01 d8             	add    %rbx,%rax
 1501de5:	ff e0                	jmp    *%rax
 1501de7:	41 83 ca 01          	or     $0x1,%r10d
 1501deb:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 1501df3:	48 83 f8 04          	cmp    $0x4,%rax
 1501df7:	76 45                	jbe    1501e3e <run_backend_benchmark+0x6ce>
 1501df9:	e9 82 00 00 00       	jmp    1501e80 <run_backend_benchmark+0x710>
 1501dfe:	83 cf 02             	or     $0x2,%edi
 1501e01:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 1501e09:	48 83 f8 04          	cmp    $0x4,%rax
 1501e0d:	76 2f                	jbe    1501e3e <run_backend_benchmark+0x6ce>
 1501e0f:	eb 6f                	jmp    1501e80 <run_backend_benchmark+0x710>
 1501e11:	b8 01 00 00 00       	mov    $0x1,%eax
 1501e16:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501e1b:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 1501e23:	48 83 f8 04          	cmp    $0x4,%rax
 1501e27:	76 15                	jbe    1501e3e <run_backend_benchmark+0x6ce>
 1501e29:	eb 55                	jmp    1501e80 <run_backend_benchmark+0x710>
 1501e2b:	83 cf 01             	or     $0x1,%edi
 1501e2e:	66 90                	xchg   %ax,%ax
 1501e30:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 1501e38:	48 83 f8 04          	cmp    $0x4,%rax
 1501e3c:	77 42                	ja     1501e80 <run_backend_benchmark+0x710>
 1501e3e:	49 63 04 84          	movslq (%r12,%rax,4),%rax
 1501e42:	4c 01 e0             	add    %r12,%rax
 1501e45:	ff e0                	jmp    *%rax
 1501e47:	41 83 ca 01          	or     $0x1,%r10d
 1501e4b:	eb 33                	jmp    1501e80 <run_backend_benchmark+0x710>
 1501e4d:	83 cf 02             	or     $0x2,%edi
 1501e50:	eb 2e                	jmp    1501e80 <run_backend_benchmark+0x710>
 1501e52:	b8 01 00 00 00       	mov    $0x1,%eax
 1501e57:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501e5c:	eb 22                	jmp    1501e80 <run_backend_benchmark+0x710>
 1501e5e:	83 cf 01             	or     $0x1,%edi
 1501e61:	eb 1d                	jmp    1501e80 <run_backend_benchmark+0x710>
 1501e63:	41 83 ce 01          	or     $0x1,%r14d
 1501e67:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 1501e6f:	48 83 f8 04          	cmp    $0x4,%rax
 1501e73:	76 c9                	jbe    1501e3e <run_backend_benchmark+0x6ce>
 1501e75:	eb 09                	jmp    1501e80 <run_backend_benchmark+0x710>
 1501e77:	41 83 ce 01          	or     $0x1,%r14d
 1501e7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1501e80:	0f b6 84 0c 07 0d 00 00 	movzbl 0xd07(%rsp,%rcx,1),%eax
 1501e88:	48 83 f8 04          	cmp    $0x4,%rax
 1501e8c:	77 62                	ja     1501ef0 <run_backend_benchmark+0x780>
 1501e8e:	49 63 04 87          	movslq (%r15,%rax,4),%rax
 1501e92:	4c 01 f8             	add    %r15,%rax
 1501e95:	ff e0                	jmp    *%rax
 1501e97:	41 83 ca 01          	or     $0x1,%r10d
 1501e9b:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 1501ea3:	48 83 f8 04          	cmp    $0x4,%rax
 1501ea7:	76 59                	jbe    1501f02 <run_backend_benchmark+0x792>
 1501ea9:	e9 82 fd ff ff       	jmp    1501c30 <run_backend_benchmark+0x4c0>
 1501eae:	83 cf 02             	or     $0x2,%edi
 1501eb1:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 1501eb9:	48 83 f8 04          	cmp    $0x4,%rax
 1501ebd:	76 43                	jbe    1501f02 <run_backend_benchmark+0x792>
 1501ebf:	e9 6c fd ff ff       	jmp    1501c30 <run_backend_benchmark+0x4c0>
 1501ec4:	b8 01 00 00 00       	mov    $0x1,%eax
 1501ec9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501ece:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 1501ed6:	48 83 f8 04          	cmp    $0x4,%rax
 1501eda:	76 26                	jbe    1501f02 <run_backend_benchmark+0x792>
 1501edc:	e9 4f fd ff ff       	jmp    1501c30 <run_backend_benchmark+0x4c0>
 1501ee1:	83 cf 01             	or     $0x1,%edi
 1501ee4:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1501ef0:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 1501ef8:	48 83 f8 04          	cmp    $0x4,%rax
 1501efc:	0f 87 2e fd ff ff    	ja     1501c30 <run_backend_benchmark+0x4c0>
 1501f02:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 1501f06:	48 01 d0             	add    %rdx,%rax
 1501f09:	ff e0                	jmp    *%rax
 1501f0b:	41 83 ca 01          	or     $0x1,%r10d
 1501f0f:	e9 1c fd ff ff       	jmp    1501c30 <run_backend_benchmark+0x4c0>
 1501f14:	b8 01 00 00 00       	mov    $0x1,%eax
 1501f19:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 1501f1e:	e9 0d fd ff ff       	jmp    1501c30 <run_backend_benchmark+0x4c0>
 1501f23:	83 cf 01             	or     $0x1,%edi
 1501f26:	e9 05 fd ff ff       	jmp    1501c30 <run_backend_benchmark+0x4c0>
 1501f2b:	41 83 ce 01          	or     $0x1,%r14d
 1501f2f:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 1501f37:	48 83 f8 04          	cmp    $0x4,%rax
 1501f3b:	76 c5                	jbe    1501f02 <run_backend_benchmark+0x792>
 1501f3d:	e9 ee fc ff ff       	jmp    1501c30 <run_backend_benchmark+0x4c0>
 1501f42:	41 83 ce 01          	or     $0x1,%r14d
 1501f46:	e9 e5 fc ff ff       	jmp    1501c30 <run_backend_benchmark+0x4c0>
 1501f4b:	4d 85 db             	test   %r11,%r11
 1501f4e:	0f 84 b8 05 00 00    	je     150250c <run_backend_benchmark+0xd9c>
 1501f54:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 1501f59:	48 ff c1             	inc    %rcx
 1501f5c:	48 8d 8c 0c 00 0d 00 00 	lea    0xd00(%rsp,%rcx,1),%rcx
 1501f64:	31 d2                	xor    %edx,%edx
 1501f66:	eb 10                	jmp    1501f78 <run_backend_benchmark+0x808>
 1501f68:	83 cf 02             	or     $0x2,%edi
 1501f6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1501f70:	48 ff c2             	inc    %rdx
 1501f73:	49 39 d3             	cmp    %rdx,%r11
 1501f76:	74 38                	je     1501fb0 <run_backend_benchmark+0x840>
 1501f78:	0f b6 04 11          	movzbl (%rcx,%rdx,1),%eax
 1501f7c:	48 83 f8 04          	cmp    $0x4,%rax
 1501f80:	77 ee                	ja     1501f70 <run_backend_benchmark+0x800>
 1501f82:	49 63 04 81          	movslq (%r9,%rax,4),%rax
 1501f86:	4c 01 c8             	add    %r9,%rax
 1501f89:	ff e0                	jmp    *%rax
 1501f8b:	41 83 ca 01          	or     $0x1,%r10d
 1501f8f:	eb df                	jmp    1501f70 <run_backend_benchmark+0x800>
 1501f91:	be 01 00 00 00       	mov    $0x1,%esi
 1501f96:	eb d8                	jmp    1501f70 <run_backend_benchmark+0x800>
 1501f98:	83 cf 01             	or     $0x1,%edi
 1501f9b:	eb d3                	jmp    1501f70 <run_backend_benchmark+0x800>
 1501f9d:	41 83 ce 01          	or     $0x1,%r14d
 1501fa1:	eb cd                	jmp    1501f70 <run_backend_benchmark+0x800>
 1501fa3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1501fb0:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 1501fb5:	e9 52 05 00 00       	jmp    150250c <run_backend_benchmark+0xd9c>
 1501fba:	66 c7 84 24 01 0d 00 00 01 05 	movw   $0x501,0xd01(%rsp)
 1501fc4:	be 03 00 00 00       	mov    $0x3,%esi
 1501fc9:	eb 0d                	jmp    1501fd8 <run_backend_benchmark+0x868>
 1501fcb:	be 02 00 00 00       	mov    $0x2,%esi
 1501fd0:	c6 84 24 01 0d 00 00 01 	movb   $0x1,0xd01(%rsp)
 1501fd8:	41 0f b7 43 06       	movzwl 0x6(%r11),%eax
 1501fdd:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 1501fe2:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 1501fe7:	45 31 f6             	xor    %r14d,%r14d
 1501fea:	89 44 24 30          	mov    %eax,0x30(%rsp)
 1501fee:	89 c8                	mov    %ecx,%eax
 1501ff0:	ff c8                	dec    %eax
 1501ff2:	83 f8 03             	cmp    $0x3,%eax
 1501ff5:	77 3d                	ja     1502034 <run_backend_benchmark+0x8c4>
 1501ff7:	48 8d 15 fe e3 01 ff 	lea    -0xfe1c02(%rip),%rdx        # 5203fc <branch_sizing_patterns+0x66c>
 1501ffe:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 1502002:	48 01 d0             	add    %rdx,%rax
 1502005:	ff e0                	jmp    *%rax
 1502007:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 150200d:	0f b6 c1             	movzbl %cl,%eax
 1502010:	8d 48 ff             	lea    -0x1(%rax),%ecx
 1502013:	83 f9 03             	cmp    $0x3,%ecx
 1502016:	0f 82 cf fb ff ff    	jb     1501beb <run_backend_benchmark+0x47b>
 150201c:	eb 28                	jmp    1502046 <run_backend_benchmark+0x8d6>
 150201e:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 1502024:	e9 c2 fb ff ff       	jmp    1501beb <run_backend_benchmark+0x47b>
 1502029:	41 ba 02 00 00 00    	mov    $0x2,%r10d
 150202f:	e9 b7 fb ff ff       	jmp    1501beb <run_backend_benchmark+0x47b>
 1502034:	45 31 d2             	xor    %r10d,%r10d
 1502037:	0f b6 c1             	movzbl %cl,%eax
 150203a:	8d 48 ff             	lea    -0x1(%rax),%ecx
 150203d:	83 f9 03             	cmp    $0x3,%ecx
 1502040:	0f 82 a5 fb ff ff    	jb     1501beb <run_backend_benchmark+0x47b>
 1502046:	83 f8 04             	cmp    $0x4,%eax
 1502049:	75 30                	jne    150207b <run_backend_benchmark+0x90b>
 150204b:	44 8b 4c 24 30       	mov    0x30(%rsp),%r9d
 1502050:	48 8d 4e ff          	lea    -0x1(%rsi),%rcx
 1502054:	83 c6 fe             	add    $0xfffffffe,%esi
 1502057:	48 8d 15 3a e4 01 ff 	lea    -0xfe1bc6(%rip),%rdx        # 520498 <branch_sizing_patterns+0x708>
 150205e:	41 89 cb             	mov    %ecx,%r11d
 1502061:	41 83 e3 07          	and    $0x7,%r11d
 1502065:	83 fe 07             	cmp    $0x7,%esi
 1502068:	0f 83 d4 00 00 00    	jae    1502142 <run_backend_benchmark+0x9d2>
 150206e:	41 bd 01 00 00 00    	mov    $0x1,%r13d
 1502074:	31 db                	xor    %ebx,%ebx
 1502076:	e9 2f 04 00 00       	jmp    15024aa <run_backend_benchmark+0xd3a>
 150207b:	48 8d 56 ff          	lea    -0x1(%rsi),%rdx
 150207f:	83 c6 fe             	add    $0xfffffffe,%esi
 1502082:	b8 01 00 00 00       	mov    $0x1,%eax
 1502087:	89 d1                	mov    %edx,%ecx
 1502089:	83 e1 07             	and    $0x7,%ecx
 150208c:	83 fe 07             	cmp    $0x7,%esi
 150208f:	72 7d                	jb     150210e <run_backend_benchmark+0x99e>
 1502091:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 1502095:	31 c0                	xor    %eax,%eax
 1502097:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 15020a0:	89 fe                	mov    %edi,%esi
 15020a2:	83 ce 02             	or     $0x2,%esi
 15020a5:	80 bc 04 01 0d 00 00 04 	cmpb   $0x4,0xd01(%rsp,%rax,1)
 15020ad:	0f 44 fe             	cmove  %esi,%edi
 15020b0:	80 bc 04 02 0d 00 00 04 	cmpb   $0x4,0xd02(%rsp,%rax,1)
 15020b8:	0f 44 fe             	cmove  %esi,%edi
 15020bb:	80 bc 04 03 0d 00 00 04 	cmpb   $0x4,0xd03(%rsp,%rax,1)
 15020c3:	0f 44 fe             	cmove  %esi,%edi
 15020c6:	80 bc 04 04 0d 00 00 04 	cmpb   $0x4,0xd04(%rsp,%rax,1)
 15020ce:	0f 44 fe             	cmove  %esi,%edi
 15020d1:	80 bc 04 05 0d 00 00 04 	cmpb   $0x4,0xd05(%rsp,%rax,1)
 15020d9:	0f 44 fe             	cmove  %esi,%edi
 15020dc:	80 bc 04 06 0d 00 00 04 	cmpb   $0x4,0xd06(%rsp,%rax,1)
 15020e4:	0f 44 fe             	cmove  %esi,%edi
 15020e7:	80 bc 04 07 0d 00 00 04 	cmpb   $0x4,0xd07(%rsp,%rax,1)
 15020ef:	0f 44 fe             	cmove  %esi,%edi
 15020f2:	80 bc 04 08 0d 00 00 04 	cmpb   $0x4,0xd08(%rsp,%rax,1)
 15020fa:	0f 44 fe             	cmove  %esi,%edi
 15020fd:	48 83 c0 08          	add    $0x8,%rax
 1502101:	48 39 c2             	cmp    %rax,%rdx
 1502104:	75 9a                	jne    15020a0 <run_backend_benchmark+0x930>
 1502106:	48 85 c9             	test   %rcx,%rcx
 1502109:	74 29                	je     1502134 <run_backend_benchmark+0x9c4>
 150210b:	48 ff c0             	inc    %rax
 150210e:	48 8d 84 04 00 0d 00 00 	lea    0xd00(%rsp,%rax,1),%rax
 1502116:	31 d2                	xor    %edx,%edx
 1502118:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1502120:	89 fe                	mov    %edi,%esi
 1502122:	83 cf 02             	or     $0x2,%edi
 1502125:	80 3c 10 04          	cmpb   $0x4,(%rax,%rdx,1)
 1502129:	0f 45 fe             	cmovne %esi,%edi
 150212c:	48 ff c2             	inc    %rdx
 150212f:	48 39 d1             	cmp    %rdx,%rcx
 1502132:	75 ec                	jne    1502120 <run_backend_benchmark+0x9b0>
 1502134:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 150213d:	e9 cf 03 00 00       	jmp    1502511 <run_backend_benchmark+0xda1>
 1502142:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 1502146:	31 db                	xor    %ebx,%ebx
 1502148:	45 31 ed             	xor    %r13d,%r13d
 150214b:	eb 10                	jmp    150215d <run_backend_benchmark+0x9ed>
 150214d:	83 cf 02             	or     $0x2,%edi
 1502150:	49 83 c5 08          	add    $0x8,%r13
 1502154:	4c 39 e9             	cmp    %r13,%rcx
 1502157:	0f 84 45 03 00 00    	je     15024a2 <run_backend_benchmark+0xd32>
 150215d:	42 0f b6 84 2c 01 0d 00 00 	movzbl 0xd01(%rsp,%r13,1),%eax
 1502166:	48 83 f8 04          	cmp    $0x4,%rax
 150216a:	77 64                	ja     15021d0 <run_backend_benchmark+0xa60>
 150216c:	48 8d 35 99 e2 01 ff 	lea    -0xfe1d67(%rip),%rsi        # 52040c <branch_sizing_patterns+0x67c>
 1502173:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 1502177:	48 01 f0             	add    %rsi,%rax
 150217a:	ff e0                	jmp    *%rax
 150217c:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 1502182:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 150218b:	48 83 f8 04          	cmp    $0x4,%rax
 150218f:	76 4e                	jbe    15021df <run_backend_benchmark+0xa6f>
 1502191:	e9 9a 00 00 00       	jmp    1502230 <run_backend_benchmark+0xac0>
 1502196:	83 cf 02             	or     $0x2,%edi
 1502199:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 15021a2:	48 83 f8 04          	cmp    $0x4,%rax
 15021a6:	76 37                	jbe    15021df <run_backend_benchmark+0xa6f>
 15021a8:	e9 83 00 00 00       	jmp    1502230 <run_backend_benchmark+0xac0>
 15021ad:	bb 03 00 00 00       	mov    $0x3,%ebx
 15021b2:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 15021bb:	48 83 f8 04          	cmp    $0x4,%rax
 15021bf:	76 1e                	jbe    15021df <run_backend_benchmark+0xa6f>
 15021c1:	eb 6d                	jmp    1502230 <run_backend_benchmark+0xac0>
 15021c3:	41 83 c9 01          	or     $0x1,%r9d
 15021c7:	83 cf 01             	or     $0x1,%edi
 15021ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 15021d0:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 15021d9:	48 83 f8 04          	cmp    $0x4,%rax
 15021dd:	77 51                	ja     1502230 <run_backend_benchmark+0xac0>
 15021df:	48 8d 35 3a e2 01 ff 	lea    -0xfe1dc6(%rip),%rsi        # 520420 <branch_sizing_patterns+0x690>
 15021e6:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 15021ea:	48 01 f0             	add    %rsi,%rax
 15021ed:	ff e0                	jmp    *%rax
 15021ef:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 15021f5:	eb 39                	jmp    1502230 <run_backend_benchmark+0xac0>
 15021f7:	83 cf 02             	or     $0x2,%edi
 15021fa:	eb 34                	jmp    1502230 <run_backend_benchmark+0xac0>
 15021fc:	bb 03 00 00 00       	mov    $0x3,%ebx
 1502201:	eb 2d                	jmp    1502230 <run_backend_benchmark+0xac0>
 1502203:	41 83 c9 01          	or     $0x1,%r9d
 1502207:	83 cf 01             	or     $0x1,%edi
 150220a:	eb 24                	jmp    1502230 <run_backend_benchmark+0xac0>
 150220c:	41 be 03 00 00 00    	mov    $0x3,%r14d
 1502212:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 150221b:	48 83 f8 04          	cmp    $0x4,%rax
 150221f:	76 be                	jbe    15021df <run_backend_benchmark+0xa6f>
 1502221:	eb 0d                	jmp    1502230 <run_backend_benchmark+0xac0>
 1502223:	41 be 03 00 00 00    	mov    $0x3,%r14d
 1502229:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1502230:	42 0f b6 84 2c 03 0d 00 00 	movzbl 0xd03(%rsp,%r13,1),%eax
 1502239:	48 83 f8 04          	cmp    $0x4,%rax
 150223d:	77 61                	ja     15022a0 <run_backend_benchmark+0xb30>
 150223f:	48 8d 35 ee e1 01 ff 	lea    -0xfe1e12(%rip),%rsi        # 520434 <branch_sizing_patterns+0x6a4>
 1502246:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 150224a:	48 01 f0             	add    %rsi,%rax
 150224d:	ff e0                	jmp    *%rax
 150224f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 1502255:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 150225e:	48 83 f8 04          	cmp    $0x4,%rax
 1502262:	76 4b                	jbe    15022af <run_backend_benchmark+0xb3f>
 1502264:	e9 97 00 00 00       	jmp    1502300 <run_backend_benchmark+0xb90>
 1502269:	83 cf 02             	or     $0x2,%edi
 150226c:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 1502275:	48 83 f8 04          	cmp    $0x4,%rax
 1502279:	76 34                	jbe    15022af <run_backend_benchmark+0xb3f>
 150227b:	e9 80 00 00 00       	jmp    1502300 <run_backend_benchmark+0xb90>
 1502280:	bb 03 00 00 00       	mov    $0x3,%ebx
 1502285:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 150228e:	48 83 f8 04          	cmp    $0x4,%rax
 1502292:	76 1b                	jbe    15022af <run_backend_benchmark+0xb3f>
 1502294:	eb 6a                	jmp    1502300 <run_backend_benchmark+0xb90>
 1502296:	41 83 c9 01          	or     $0x1,%r9d
 150229a:	83 cf 01             	or     $0x1,%edi
 150229d:	0f 1f 00             	nopl   (%rax)
 15022a0:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 15022a9:	48 83 f8 04          	cmp    $0x4,%rax
 15022ad:	77 51                	ja     1502300 <run_backend_benchmark+0xb90>
 15022af:	48 8d 35 92 e1 01 ff 	lea    -0xfe1e6e(%rip),%rsi        # 520448 <branch_sizing_patterns+0x6b8>
 15022b6:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 15022ba:	48 01 f0             	add    %rsi,%rax
 15022bd:	ff e0                	jmp    *%rax
 15022bf:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 15022c5:	eb 39                	jmp    1502300 <run_backend_benchmark+0xb90>
 15022c7:	83 cf 02             	or     $0x2,%edi
 15022ca:	eb 34                	jmp    1502300 <run_backend_benchmark+0xb90>
 15022cc:	bb 03 00 00 00       	mov    $0x3,%ebx
 15022d1:	eb 2d                	jmp    1502300 <run_backend_benchmark+0xb90>
 15022d3:	41 83 c9 01          	or     $0x1,%r9d
 15022d7:	83 cf 01             	or     $0x1,%edi
 15022da:	eb 24                	jmp    1502300 <run_backend_benchmark+0xb90>
 15022dc:	41 be 03 00 00 00    	mov    $0x3,%r14d
 15022e2:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 15022eb:	48 83 f8 04          	cmp    $0x4,%rax
 15022ef:	76 be                	jbe    15022af <run_backend_benchmark+0xb3f>
 15022f1:	eb 0d                	jmp    1502300 <run_backend_benchmark+0xb90>
 15022f3:	41 be 03 00 00 00    	mov    $0x3,%r14d
 15022f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1502300:	42 0f b6 84 2c 05 0d 00 00 	movzbl 0xd05(%rsp,%r13,1),%eax
 1502309:	48 83 f8 04          	cmp    $0x4,%rax
 150230d:	77 61                	ja     1502370 <run_backend_benchmark+0xc00>
 150230f:	48 8d 35 46 e1 01 ff 	lea    -0xfe1eba(%rip),%rsi        # 52045c <branch_sizing_patterns+0x6cc>
 1502316:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 150231a:	48 01 f0             	add    %rsi,%rax
 150231d:	ff e0                	jmp    *%rax
 150231f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 1502325:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 150232e:	48 83 f8 04          	cmp    $0x4,%rax
 1502332:	76 4b                	jbe    150237f <run_backend_benchmark+0xc0f>
 1502334:	e9 97 00 00 00       	jmp    15023d0 <run_backend_benchmark+0xc60>
 1502339:	83 cf 02             	or     $0x2,%edi
 150233c:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 1502345:	48 83 f8 04          	cmp    $0x4,%rax
 1502349:	76 34                	jbe    150237f <run_backend_benchmark+0xc0f>
 150234b:	e9 80 00 00 00       	jmp    15023d0 <run_backend_benchmark+0xc60>
 1502350:	bb 03 00 00 00       	mov    $0x3,%ebx
 1502355:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 150235e:	48 83 f8 04          	cmp    $0x4,%rax
 1502362:	76 1b                	jbe    150237f <run_backend_benchmark+0xc0f>
 1502364:	eb 6a                	jmp    15023d0 <run_backend_benchmark+0xc60>
 1502366:	41 83 c9 01          	or     $0x1,%r9d
 150236a:	83 cf 01             	or     $0x1,%edi
 150236d:	0f 1f 00             	nopl   (%rax)
 1502370:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 1502379:	48 83 f8 04          	cmp    $0x4,%rax
 150237d:	77 51                	ja     15023d0 <run_backend_benchmark+0xc60>
 150237f:	48 8d 35 ea e0 01 ff 	lea    -0xfe1f16(%rip),%rsi        # 520470 <branch_sizing_patterns+0x6e0>
 1502386:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 150238a:	48 01 f0             	add    %rsi,%rax
 150238d:	ff e0                	jmp    *%rax
 150238f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 1502395:	eb 39                	jmp    15023d0 <run_backend_benchmark+0xc60>
 1502397:	83 cf 02             	or     $0x2,%edi
 150239a:	eb 34                	jmp    15023d0 <run_backend_benchmark+0xc60>
 150239c:	bb 03 00 00 00       	mov    $0x3,%ebx
 15023a1:	eb 2d                	jmp    15023d0 <run_backend_benchmark+0xc60>
 15023a3:	41 83 c9 01          	or     $0x1,%r9d
 15023a7:	83 cf 01             	or     $0x1,%edi
 15023aa:	eb 24                	jmp    15023d0 <run_backend_benchmark+0xc60>
 15023ac:	41 be 03 00 00 00    	mov    $0x3,%r14d
 15023b2:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 15023bb:	48 83 f8 04          	cmp    $0x4,%rax
 15023bf:	76 be                	jbe    150237f <run_backend_benchmark+0xc0f>
 15023c1:	eb 0d                	jmp    15023d0 <run_backend_benchmark+0xc60>
 15023c3:	41 be 03 00 00 00    	mov    $0x3,%r14d
 15023c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 15023d0:	42 0f b6 84 2c 07 0d 00 00 	movzbl 0xd07(%rsp,%r13,1),%eax
 15023d9:	48 83 f8 04          	cmp    $0x4,%rax
 15023dd:	77 61                	ja     1502440 <run_backend_benchmark+0xcd0>
 15023df:	48 8d 35 9e e0 01 ff 	lea    -0xfe1f62(%rip),%rsi        # 520484 <branch_sizing_patterns+0x6f4>
 15023e6:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 15023ea:	48 01 f0             	add    %rsi,%rax
 15023ed:	ff e0                	jmp    *%rax
 15023ef:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 15023f5:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 15023fe:	48 83 f8 04          	cmp    $0x4,%rax
 1502402:	76 4f                	jbe    1502453 <run_backend_benchmark+0xce3>
 1502404:	e9 47 fd ff ff       	jmp    1502150 <run_backend_benchmark+0x9e0>
 1502409:	83 cf 02             	or     $0x2,%edi
 150240c:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 1502415:	48 83 f8 04          	cmp    $0x4,%rax
 1502419:	76 38                	jbe    1502453 <run_backend_benchmark+0xce3>
 150241b:	e9 30 fd ff ff       	jmp    1502150 <run_backend_benchmark+0x9e0>
 1502420:	bb 03 00 00 00       	mov    $0x3,%ebx
 1502425:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 150242e:	48 83 f8 04          	cmp    $0x4,%rax
 1502432:	76 1f                	jbe    1502453 <run_backend_benchmark+0xce3>
 1502434:	e9 17 fd ff ff       	jmp    1502150 <run_backend_benchmark+0x9e0>
 1502439:	41 83 c9 01          	or     $0x1,%r9d
 150243d:	83 cf 01             	or     $0x1,%edi
 1502440:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 1502449:	48 83 f8 04          	cmp    $0x4,%rax
 150244d:	0f 87 fd fc ff ff    	ja     1502150 <run_backend_benchmark+0x9e0>
 1502453:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 1502457:	48 01 d0             	add    %rdx,%rax
 150245a:	ff e0                	jmp    *%rax
 150245c:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 1502462:	e9 e9 fc ff ff       	jmp    1502150 <run_backend_benchmark+0x9e0>
 1502467:	bb 03 00 00 00       	mov    $0x3,%ebx
 150246c:	e9 df fc ff ff       	jmp    1502150 <run_backend_benchmark+0x9e0>
 1502471:	41 83 c9 01          	or     $0x1,%r9d
 1502475:	83 cf 01             	or     $0x1,%edi
 1502478:	e9 d3 fc ff ff       	jmp    1502150 <run_backend_benchmark+0x9e0>
 150247d:	41 be 03 00 00 00    	mov    $0x3,%r14d
 1502483:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 150248c:	48 83 f8 04          	cmp    $0x4,%rax
 1502490:	76 c1                	jbe    1502453 <run_backend_benchmark+0xce3>
 1502492:	e9 b9 fc ff ff       	jmp    1502150 <run_backend_benchmark+0x9e0>
 1502497:	41 be 03 00 00 00    	mov    $0x3,%r14d
 150249d:	e9 ae fc ff ff       	jmp    1502150 <run_backend_benchmark+0x9e0>
 15024a2:	4d 85 db             	test   %r11,%r11
 15024a5:	74 5b                	je     1502502 <run_backend_benchmark+0xd92>
 15024a7:	49 ff c5             	inc    %r13
 15024aa:	4a 8d 8c 2c 00 0d 00 00 	lea    0xd00(%rsp,%r13,1),%rcx
 15024b2:	31 d2                	xor    %edx,%edx
 15024b4:	eb 12                	jmp    15024c8 <run_backend_benchmark+0xd58>
 15024b6:	83 cf 02             	or     $0x2,%edi
 15024b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 15024c0:	48 ff c2             	inc    %rdx
 15024c3:	49 39 d3             	cmp    %rdx,%r11
 15024c6:	74 3a                	je     1502502 <run_backend_benchmark+0xd92>
 15024c8:	0f b6 04 11          	movzbl (%rcx,%rdx,1),%eax
 15024cc:	48 83 f8 04          	cmp    $0x4,%rax
 15024d0:	77 ee                	ja     15024c0 <run_backend_benchmark+0xd50>
 15024d2:	48 8d 35 d3 df 01 ff 	lea    -0xfe202d(%rip),%rsi        # 5204ac <branch_sizing_patterns+0x71c>
 15024d9:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 15024dd:	48 01 f0             	add    %rsi,%rax
 15024e0:	ff e0                	jmp    *%rax
 15024e2:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 15024e8:	eb d6                	jmp    15024c0 <run_backend_benchmark+0xd50>
 15024ea:	bb 03 00 00 00       	mov    $0x3,%ebx
 15024ef:	eb cf                	jmp    15024c0 <run_backend_benchmark+0xd50>
 15024f1:	41 83 c9 01          	or     $0x1,%r9d
 15024f5:	83 cf 01             	or     $0x1,%edi
 15024f8:	eb c6                	jmp    15024c0 <run_backend_benchmark+0xd50>
 15024fa:	41 be 03 00 00 00    	mov    $0x3,%r14d
 1502500:	eb be                	jmp    15024c0 <run_backend_benchmark+0xd50>
 1502502:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 1502507:	44 89 4c 24 30       	mov    %r9d,0x30(%rsp)
 150250c:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 1502511:	b2 01                	mov    $0x1,%dl
 1502513:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 150251b:	44 0f b7 48 16       	movzwl 0x16(%rax),%r9d
 1502520:	0f b7 48 18          	movzwl 0x18(%rax),%ecx
 1502524:	0f b7 40 1e          	movzwl 0x1e(%rax),%eax
 1502528:	45 85 c9             	test   %r9d,%r9d
 150252b:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
 1502532:	44 89 c8             	mov    %r9d,%eax
 1502535:	45 89 cf             	mov    %r9d,%r15d
 1502538:	89 4c 24 60          	mov    %ecx,0x60(%rsp)
 150253c:	41 0f b6 4b 0c       	movzbl 0xc(%r11),%ecx
 1502541:	44 89 8c 24 90 00 00 00 	mov    %r9d,0x90(%rsp)
 1502549:	41 0f 95 c0          	setne  %r8b
 150254d:	83 e0 0f             	and    $0xf,%eax
 1502550:	41 83 e7 10          	and    $0x10,%r15d
 1502554:	40 0f 94 c6          	sete   %sil
 1502558:	41 c1 ef 04          	shr    $0x4,%r15d
 150255c:	85 c0                	test   %eax,%eax
 150255e:	41 89 c3             	mov    %eax,%r11d
 1502561:	41 0f 95 c4          	setne  %r12b
 1502565:	45 20 fc             	and    %r15b,%r12b
 1502568:	41 83 eb 05          	sub    $0x5,%r11d
 150256c:	0f 92 c3             	setb   %bl
 150256f:	44 20 e3             	and    %r12b,%bl
 1502572:	41 83 fb 03          	cmp    $0x3,%r11d
 1502576:	41 0f 92 c3          	setb   %r11b
 150257a:	45 20 df             	and    %r11b,%r15b
 150257d:	45 85 d2             	test   %r10d,%r10d
 1502580:	41 0f 94 c4          	sete   %r12b
 1502584:	44 08 e6             	or     %r12b,%sil
 1502587:	45 08 e0             	or     %r12b,%r8b
 150258a:	44 08 de             	or     %r11b,%sil
 150258d:	41 20 d0             	and    %dl,%r8b
 1502590:	40 08 de             	or     %bl,%sil
 1502593:	44 20 c6             	and    %r8b,%sil
 1502596:	45 0f b6 c7          	movzbl %r15b,%r8d
 150259a:	41 c1 e0 04          	shl    $0x4,%r8d
 150259e:	45 09 d0             	or     %r10d,%r8d
 15025a1:	41 f6 c2 02          	test   $0x2,%r10b
 15025a5:	74 39                	je     15025e0 <run_backend_benchmark+0xe70>
 15025a7:	84 db                	test   %bl,%bl
 15025a9:	74 35                	je     15025e0 <run_backend_benchmark+0xe70>
 15025ab:	8d 50 ff             	lea    -0x1(%rax),%edx
 15025ae:	41 b9 01 00 00 00    	mov    $0x1,%r9d
 15025b4:	45 31 e4             	xor    %r12d,%r12d
 15025b7:	83 fa 02             	cmp    $0x2,%edx
 15025ba:	c4 42 69 f7 d1       	shlx   %edx,%r9d,%r10d
 15025bf:	ba 02 00 00 00       	mov    $0x2,%edx
 15025c4:	41 0f 94 c4          	sete   %r12b
 15025c8:	83 f8 03             	cmp    $0x3,%eax
 15025cb:	44 0f 42 e2          	cmovb  %edx,%r12d
 15025cf:	85 c9                	test   %ecx,%ecx
 15025d1:	41 0f 44 ca          	cmove  %r10d,%ecx
 15025d5:	eb 3a                	jmp    1502611 <run_backend_benchmark+0xea1>
 15025d7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 15025e0:	41 83 e2 02          	and    $0x2,%r10d
 15025e4:	45 31 e4             	xor    %r12d,%r12d
 15025e7:	41 d1 ea             	shr    $1,%r10d
 15025ea:	45 20 fa             	and    %r15b,%r10b
 15025ed:	41 80 fa 01          	cmp    $0x1,%r10b
 15025f1:	75 2d                	jne    1502620 <run_backend_benchmark+0xeb0>
 15025f3:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 15025f8:	44 0f b6 50 0d       	movzbl 0xd(%rax),%r10d
 15025fd:	45 85 d2             	test   %r10d,%r10d
 1502600:	45 89 d4             	mov    %r10d,%r12d
 1502603:	0f 95 c0             	setne  %al
 1502606:	41 c1 ec 05          	shr    $0x5,%r12d
 150260a:	41 83 e2 1f          	and    $0x1f,%r10d
 150260e:	40 20 c6             	and    %al,%sil
 1502611:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 1502619:	41 09 c0             	or     %eax,%r8d
 150261c:	eb 05                	jmp    1502623 <run_backend_benchmark+0xeb3>
 150261e:	66 90                	xchg   %ax,%ax
 1502620:	45 31 d2             	xor    %r10d,%r10d
 1502623:	44 8b 4c 24 60       	mov    0x60(%rsp),%r9d
 1502628:	44 89 c8             	mov    %r9d,%eax
 150262b:	83 e0 0f             	and    $0xf,%eax
 150262e:	45 89 cf             	mov    %r9d,%r15d
 1502631:	41 83 e7 10          	and    $0x10,%r15d
 1502635:	0f 94 c2             	sete   %dl
 1502638:	41 c1 ef 04          	shr    $0x4,%r15d
 150263c:	85 c0                	test   %eax,%eax
 150263e:	41 89 c5             	mov    %eax,%r13d
 1502641:	41 0f 95 c3          	setne  %r11b
 1502645:	45 20 fb             	and    %r15b,%r11b
 1502648:	41 83 ed 05          	sub    $0x5,%r13d
 150264c:	0f 92 c3             	setb   %bl
 150264f:	44 20 db             	and    %r11b,%bl
 1502652:	41 83 fd 03          	cmp    $0x3,%r13d
 1502656:	41 0f 92 c3          	setb   %r11b
 150265a:	45 20 df             	and    %r11b,%r15b
 150265d:	45 85 f6             	test   %r14d,%r14d
 1502660:	41 0f 94 c5          	sete   %r13b
 1502664:	45 85 c9             	test   %r9d,%r9d
 1502667:	41 0f 95 c1          	setne  %r9b
 150266b:	44 08 ea             	or     %r13b,%dl
 150266e:	44 08 da             	or     %r11b,%dl
 1502671:	45 08 e9             	or     %r13b,%r9b
 1502674:	08 da                	or     %bl,%dl
 1502676:	44 20 ca             	and    %r9b,%dl
 1502679:	40 20 f2             	and    %sil,%dl
 150267c:	41 0f b6 f7          	movzbl %r15b,%esi
 1502680:	c1 e6 04             	shl    $0x4,%esi
 1502683:	44 09 f6             	or     %r14d,%esi
 1502686:	41 f6 c6 02          	test   $0x2,%r14b
 150268a:	74 54                	je     15026e0 <run_backend_benchmark+0xf70>
 150268c:	84 db                	test   %bl,%bl
 150268e:	74 50                	je     15026e0 <run_backend_benchmark+0xf70>
 1502690:	44 8d 48 ff          	lea    -0x1(%rax),%r9d
 1502694:	45 31 e4             	xor    %r12d,%r12d
 1502697:	44 8b ac 24 98 00 00 00 	mov    0x98(%rsp),%r13d
 150269f:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 15026a5:	41 83 f9 02          	cmp    $0x2,%r9d
 15026a9:	c4 42 31 f7 d2       	shlx   %r9d,%r10d,%r10d
 15026ae:	41 0f 94 c4          	sete   %r12b
 15026b2:	83 f8 03             	cmp    $0x3,%eax
 15026b5:	b8 02 00 00 00       	mov    $0x2,%eax
 15026ba:	44 0f 42 e0          	cmovb  %eax,%r12d
 15026be:	85 c9                	test   %ecx,%ecx
 15026c0:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 15026c8:	41 0f 44 ca          	cmove  %r10d,%ecx
 15026cc:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
 15026d1:	09 c6                	or     %eax,%esi
 15026d3:	eb 4f                	jmp    1502724 <run_backend_benchmark+0xfb4>
 15026d5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 15026e0:	44 8b ac 24 98 00 00 00 	mov    0x98(%rsp),%r13d
 15026e8:	41 83 e6 02          	and    $0x2,%r14d
 15026ec:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
 15026f1:	41 d1 ee             	shr    $1,%r14d
 15026f4:	45 20 fe             	and    %r15b,%r14b
 15026f7:	41 80 fe 01          	cmp    $0x1,%r14b
 15026fb:	75 27                	jne    1502724 <run_backend_benchmark+0xfb4>
 15026fd:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 1502702:	44 0f b6 50 0d       	movzbl 0xd(%rax),%r10d
 1502707:	45 85 d2             	test   %r10d,%r10d
 150270a:	45 89 d4             	mov    %r10d,%r12d
 150270d:	0f 95 c0             	setne  %al
 1502710:	41 c1 ec 05          	shr    $0x5,%r12d
 1502714:	41 83 e2 1f          	and    $0x1f,%r10d
 1502718:	42 8d 0c a5 00 00 00 00 	lea    0x0(,%r12,4),%ecx
 1502720:	20 c2                	and    %al,%dl
 1502722:	09 ce                	or     %ecx,%esi
 1502724:	44 89 e8             	mov    %r13d,%eax
 1502727:	83 e0 0f             	and    $0xf,%eax
 150272a:	45 89 ef             	mov    %r13d,%r15d
 150272d:	41 83 e7 10          	and    $0x10,%r15d
 1502731:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 1502736:	41 0f 94 c6          	sete   %r14b
 150273a:	41 c1 ef 04          	shr    $0x4,%r15d
 150273e:	85 c0                	test   %eax,%eax
 1502740:	41 89 c3             	mov    %eax,%r11d
 1502743:	41 0f 95 c1          	setne  %r9b
 1502747:	45 20 f9             	and    %r15b,%r9b
 150274a:	41 83 eb 05          	sub    $0x5,%r11d
 150274e:	0f 92 c3             	setb   %bl
 1502751:	44 20 cb             	and    %r9b,%bl
 1502754:	41 83 fb 03          	cmp    $0x3,%r11d
 1502758:	41 0f 92 c1          	setb   %r9b
 150275c:	45 20 cf             	and    %r9b,%r15b
 150275f:	85 c9                	test   %ecx,%ecx
 1502761:	41 0f 94 c3          	sete   %r11b
 1502765:	45 85 ed             	test   %r13d,%r13d
 1502768:	41 0f 95 c5          	setne  %r13b
 150276c:	45 08 de             	or     %r11b,%r14b
 150276f:	45 08 ce             	or     %r9b,%r14b
 1502772:	45 08 dd             	or     %r11b,%r13b
 1502775:	41 08 de             	or     %bl,%r14b
 1502778:	45 20 ee             	and    %r13b,%r14b
 150277b:	41 20 d6             	and    %dl,%r14b
 150277e:	41 0f b6 d7          	movzbl %r15b,%edx
 1502782:	c1 e2 04             	shl    $0x4,%edx
 1502785:	09 ca                	or     %ecx,%edx
 1502787:	f6 c1 02             	test   $0x2,%cl
 150278a:	74 54                	je     15027e0 <run_backend_benchmark+0x1070>
 150278c:	84 db                	test   %bl,%bl
 150278e:	74 50                	je     15027e0 <run_backend_benchmark+0x1070>
 1502790:	44 8d 48 ff          	lea    -0x1(%rax),%r9d
 1502794:	45 31 e4             	xor    %r12d,%r12d
 1502797:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 150279c:	4c 8b ac 24 80 00 00 00 	mov    0x80(%rsp),%r13
 15027a4:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 15027a9:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 15027af:	41 83 f9 02          	cmp    $0x2,%r9d
 15027b3:	c4 42 31 f7 d2       	shlx   %r9d,%r10d,%r10d
 15027b8:	41 0f 94 c4          	sete   %r12b
 15027bc:	83 f8 03             	cmp    $0x3,%eax
 15027bf:	b8 02 00 00 00       	mov    $0x2,%eax
 15027c4:	44 0f 42 e0          	cmovb  %eax,%r12d
 15027c8:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 15027d0:	09 c2                	or     %eax,%edx
 15027d2:	85 c9                	test   %ecx,%ecx
 15027d4:	41 0f 44 ca          	cmove  %r10d,%ecx
 15027d8:	eb 66                	jmp    1502840 <run_backend_benchmark+0x10d0>
 15027da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 15027e0:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 15027e5:	4c 8b ac 24 80 00 00 00 	mov    0x80(%rsp),%r13
 15027ed:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 15027f2:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 15027f7:	83 e0 02             	and    $0x2,%eax
 15027fa:	d1 e8                	shr    $1,%eax
 15027fc:	44 20 f8             	and    %r15b,%al
 15027ff:	3c 01                	cmp    $0x1,%al
 1502801:	75 24                	jne    1502827 <run_backend_benchmark+0x10b7>
 1502803:	45 0f b6 53 0d       	movzbl 0xd(%r11),%r10d
 1502808:	45 85 d2             	test   %r10d,%r10d
 150280b:	45 89 d4             	mov    %r10d,%r12d
 150280e:	0f 95 c0             	setne  %al
 1502811:	41 c1 ec 05          	shr    $0x5,%r12d
 1502815:	41 83 e2 1f          	and    $0x1f,%r10d
 1502819:	46 8d 0c a5 00 00 00 00 	lea    0x0(,%r12,4),%r9d
 1502821:	41 20 c6             	and    %al,%r14b
 1502824:	44 09 ca             	or     %r9d,%edx
 1502827:	85 c9                	test   %ecx,%ecx
 1502829:	75 15                	jne    1502840 <run_backend_benchmark+0x10d0>
 150282b:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 1502833:	0f b6 48 1a          	movzbl 0x1a(%rax),%ecx
 1502837:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 1502840:	4d 89 e9             	mov    %r13,%r9
 1502843:	49 c1 e1 04          	shl    $0x4,%r9
 1502847:	48 8d 05 f2 f9 4e 0d 	lea    0xd4ef9f2(%rip),%rax        # e9f2240 <x86_effects_records>
 150284e:	41 0f b7 5b 08       	movzwl 0x8(%r11),%ebx
 1502853:	49 01 c1             	add    %rax,%r9
 1502856:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 150285e:	0f b6 40 12          	movzbl 0x12(%rax),%eax
 1502862:	84 c0                	test   %al,%al
 1502864:	74 0a                	je     1502870 <run_backend_benchmark+0x1100>
 1502866:	45 0f b6 7b 12       	movzbl 0x12(%r11),%r15d
 150286b:	eb 06                	jmp    1502873 <run_backend_benchmark+0x1103>
 150286d:	0f 1f 00             	nopl   (%rax)
 1502870:	45 31 ff             	xor    %r15d,%r15d
 1502873:	84 c0                	test   %al,%al
 1502875:	0f 94 c0             	sete   %al
 1502878:	c1 e6 05             	shl    $0x5,%esi
 150287b:	c1 e2 0a             	shl    $0xa,%edx
 150287e:	44 09 c6             	or     %r8d,%esi
 1502881:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 1502887:	09 d6                	or     %edx,%esi
 1502889:	89 da                	mov    %ebx,%edx
 150288b:	83 e2 fd             	and    $0xfffffffd,%edx
 150288e:	41 83 fc 02          	cmp    $0x2,%r12d
 1502892:	44 8b 64 24 30       	mov    0x30(%rsp),%r12d
 1502897:	0f 44 da             	cmove  %edx,%ebx
 150289a:	f6 44 24 60 10       	testb  $0x10,0x60(%rsp)
 150289f:	0f 44 da             	cmove  %edx,%ebx
 15028a2:	f6 84 24 90 00 00 00 10 	testb  $0x10,0x90(%rsp)
 15028aa:	0f 44 da             	cmove  %edx,%ebx
 15028ad:	8d 51 ff             	lea    -0x1(%rcx),%edx
 15028b0:	83 fa 03             	cmp    $0x3,%edx
 15028b3:	45 0f 42 c4          	cmovb  %r12d,%r8d
 15028b7:	41 09 f8             	or     %edi,%r8d
 15028ba:	45 85 ff             	test   %r15d,%r15d
 15028bd:	41 0f b6 7b 13       	movzbl 0x13(%r11),%edi
 15028c2:	0f 95 c2             	setne  %dl
 15028c5:	66 45 89 01          	mov    %r8w,(%r9)
 15028c9:	66 45 89 61 02       	mov    %r12w,0x2(%r9)
 15028ce:	66 41 89 71 04       	mov    %si,0x4(%r9)
 15028d3:	66 41 89 59 06       	mov    %bx,0x6(%r9)
 15028d8:	41 8b 5b 0e          	mov    0xe(%r11),%ebx
 15028dc:	45 0f b6 43 0a       	movzbl 0xa(%r11),%r8d
 15028e1:	4c 8d 25 3c dc 01 ff 	lea    -0xfe23c4(%rip),%r12        # 520524 <branch_sizing_patterns+0x794>
 15028e8:	08 c2                	or     %al,%dl
 15028ea:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 15028f2:	44 20 f2             	and    %r14b,%dl
 15028f5:	c1 e7 04             	shl    $0x4,%edi
 15028f8:	41 89 59 08          	mov    %ebx,0x8(%r9)
 15028fc:	44 09 ff             	or     %r15d,%edi
 15028ff:	48 8d 1d fa b7 4e 0d 	lea    0xd4eb7fa(%rip),%rbx        # e9ee100 <x86_effects_index>
 1502906:	45 88 41 0c          	mov    %r8b,0xc(%r9)
 150290a:	41 88 49 0d          	mov    %cl,0xd(%r9)
 150290e:	45 88 51 0e          	mov    %r10b,0xe(%r9)
 1502912:	4c 8d 3d 1f dc 01 ff 	lea    -0xfe23e1(%rip),%r15        # 520538 <branch_sizing_patterns+0x7a8>
 1502919:	41 88 79 0f          	mov    %dil,0xf(%r9)
 150291d:	66 44 89 2c 43       	mov    %r13w,(%rbx,%rax,2)
 1502922:	49 ff c5             	inc    %r13
 1502925:	4c 8d 0d 34 dc 01 ff 	lea    -0xfe23cc(%rip),%r9        # 520560 <branch_sizing_patterns+0x7d0>
 150292c:	80 fa 01             	cmp    $0x1,%dl
 150292f:	75 0f                	jne    1502940 <run_backend_benchmark+0x11d0>
 1502931:	48 8d 78 01          	lea    0x1(%rax),%rdi
 1502935:	48 3b 44 24 70       	cmp    0x70(%rsp),%rax
 150293a:	0f 82 40 f1 ff ff    	jb     1501a80 <run_backend_benchmark+0x310>
 1502940:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 1502948:	48 ff c1             	inc    %rcx
 150294b:	48 89 8c 24 c0 00 00 00 	mov    %rcx,0xc0(%rsp)
 1502953:	48 81 f9 bc 00 00 00 	cmp    $0xbc,%rcx
 150295a:	74 6c                	je     15029c8 <run_backend_benchmark+0x1258>
 150295c:	84 d2                	test   %dl,%dl
 150295e:	75 3a                	jne    150299a <run_backend_benchmark+0x122a>
 1502960:	e9 31 81 00 00       	jmp    150aa96 <run_backend_benchmark+0x9326>
 1502965:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1502970:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 1502978:	48 ff c1             	inc    %rcx
 150297b:	48 89 8c 24 c0 00 00 00 	mov    %rcx,0xc0(%rsp)
 1502983:	48 81 f9 bc 00 00 00 	cmp    $0xbc,%rcx
 150298a:	0f 84 06 81 00 00    	je     150aa96 <run_backend_benchmark+0x9326>
 1502990:	31 d2                	xor    %edx,%edx
 1502992:	84 d2                	test   %dl,%dl
 1502994:	0f 84 fc 80 00 00    	je     150aa96 <run_backend_benchmark+0x9326>
 150299a:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 15029a2:	48 8d 15 17 fe 01 ff 	lea    -0xfe01e9(%rip),%rdx        # 5227c0 <x86_effects_rows>
 15029a9:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 15029ad:	4c 8d 1c 82          	lea    (%rdx,%rax,4),%r11
 15029b1:	0f b7 0c 82          	movzwl (%rdx,%rax,4),%ecx
 15029b5:	0f b7 44 82 02       	movzwl 0x2(%rdx,%rax,4),%eax
 15029ba:	66 39 c1             	cmp    %ax,%cx
 15029bd:	0f 86 9d f0 ff ff    	jbe    1501a60 <run_backend_benchmark+0x2f0>
 15029c3:	e9 ce 80 00 00       	jmp    150aa96 <run_backend_benchmark+0x9326>
 15029c8:	84 d2                	test   %dl,%dl
 15029ca:	0f 84 c6 80 00 00    	je     150aa96 <run_backend_benchmark+0x9326>
 15029d0:	62 f3 7d 48 25 c0 ff 	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
 15029d7:	48 8d 3d b2 3a 4f 0d 	lea    0xd4f3ab2(%rip),%rdi        # e9f6490 <x86_choice_rows>
 15029de:	ba 00 09 00 00       	mov    $0x900,%edx
 15029e3:	31 f6                	xor    %esi,%esi
 15029e5:	48 c7 05 90 3a 4f 0d ff ff ff ff 	movq   $0xffffffffffffffff,0xd4f3a90(%rip)        # e9f6480 <x86_choice_row_index+0x240>
 15029f0:	45 31 f6             	xor    %r14d,%r14d
 15029f3:	62 f1 fe 48 7f 05 43 3a 4f 0d 	vmovdqu64 %zmm0,0xd4f3a43(%rip)        # e9f6440 <x86_choice_row_index+0x200>
 15029fd:	62 f1 fe 48 7f 05 f9 39 4f 0d 	vmovdqu64 %zmm0,0xd4f39f9(%rip)        # e9f6400 <x86_choice_row_index+0x1c0>
 1502a07:	62 f1 fe 48 7f 05 af 39 4f 0d 	vmovdqu64 %zmm0,0xd4f39af(%rip)        # e9f63c0 <x86_choice_row_index+0x180>
 1502a11:	62 f1 fe 48 7f 05 65 39 4f 0d 	vmovdqu64 %zmm0,0xd4f3965(%rip)        # e9f6380 <x86_choice_row_index+0x140>
 1502a1b:	62 f1 fe 48 7f 05 1b 39 4f 0d 	vmovdqu64 %zmm0,0xd4f391b(%rip)        # e9f6340 <x86_choice_row_index+0x100>
 1502a25:	62 f1 fe 48 7f 05 d1 38 4f 0d 	vmovdqu64 %zmm0,0xd4f38d1(%rip)        # e9f6300 <x86_choice_row_index+0xc0>
 1502a2f:	62 f1 fe 48 7f 05 87 38 4f 0d 	vmovdqu64 %zmm0,0xd4f3887(%rip)        # e9f62c0 <x86_choice_row_index+0x80>
 1502a39:	62 f1 fe 48 7f 05 3d 38 4f 0d 	vmovdqu64 %zmm0,0xd4f383d(%rip)        # e9f6280 <x86_choice_row_index+0x40>
 1502a43:	62 f1 fe 48 7f 05 f3 37 4f 0d 	vmovdqu64 %zmm0,0xd4f37f3(%rip)        # e9f6240 <x86_choice_row_index>
 1502a4d:	c5 f8 77             	vzeroupper
 1502a50:	e8 db 18 26 ff       	call   764330 <memset@plt>
 1502a55:	62 f2 7d 48 5a 0d a1 30 07 ff 	vbroadcasti32x4 -0xf8cf5f(%rip),%zmm1        # 575b00 <x86_effects_unknown+0xa0>
 1502a5f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1502a63:	31 c0                	xor    %eax,%eax
 1502a65:	62 f1 fd 48 7f 05 51 43 4f 0d 	vmovdqa64 %zmm0,0xd4f4351(%rip)        # e9f6dc0 <x86_choice_row_info>
 1502a6f:	62 f1 fd 48 7f 05 87 43 4f 0d 	vmovdqa64 %zmm0,0xd4f4387(%rip)        # e9f6e00 <x86_choice_row_info+0x40>
 1502a79:	62 f1 fd 48 7f 05 bd 43 4f 0d 	vmovdqa64 %zmm0,0xd4f43bd(%rip)        # e9f6e40 <x86_choice_forms_by_candidate>
 1502a83:	62 f1 fd 48 7f 05 f3 43 4f 0d 	vmovdqa64 %zmm0,0xd4f43f3(%rip)        # e9f6e80 <x86_choice_forms_by_candidate+0x40>
 1502a8d:	62 f1 fd 48 7f 05 29 44 4f 0d 	vmovdqa64 %zmm0,0xd4f4429(%rip)        # e9f6ec0 <x86_choice_forms_by_candidate+0x80>
 1502a97:	62 f1 fd 48 7f 05 5f 44 4f 0d 	vmovdqa64 %zmm0,0xd4f445f(%rip)        # e9f6f00 <x86_choice_forms_by_candidate+0xc0>
 1502aa1:	62 f1 fd 48 7f 05 95 44 4f 0d 	vmovdqa64 %zmm0,0xd4f4495(%rip)        # e9f6f40 <x86_choice_forms_by_candidate+0x100>
 1502aab:	62 f1 fd 48 7f 05 cb 44 4f 0d 	vmovdqa64 %zmm0,0xd4f44cb(%rip)        # e9f6f80 <x86_choice_forms_by_candidate+0x140>
 1502ab5:	62 f1 fd 48 7f 05 01 45 4f 0d 	vmovdqa64 %zmm0,0xd4f4501(%rip)        # e9f6fc0 <x86_choice_forms_by_candidate+0x180>
 1502abf:	62 f1 fd 48 7f 05 37 45 4f 0d 	vmovdqa64 %zmm0,0xd4f4537(%rip)        # e9f7000 <x86_choice_forms_by_candidate+0x1c0>
 1502ac9:	62 f1 fd 48 7f 05 6d 45 4f 0d 	vmovdqa64 %zmm0,0xd4f456d(%rip)        # e9f7040 <x86_choice_forms_by_candidate+0x200>
 1502ad3:	62 f1 fd 48 7f 05 a3 45 4f 0d 	vmovdqa64 %zmm0,0xd4f45a3(%rip)        # e9f7080 <x86_choice_forms_by_candidate+0x240>
 1502add:	62 f1 fd 48 7f 05 d9 45 4f 0d 	vmovdqa64 %zmm0,0xd4f45d9(%rip)        # e9f70c0 <x86_choice_forms_by_candidate+0x280>
 1502ae7:	62 f1 fd 48 7f 05 0f 46 4f 0d 	vmovdqa64 %zmm0,0xd4f460f(%rip)        # e9f7100 <x86_choice_forms_by_candidate+0x2c0>
 1502af1:	62 f1 fd 48 7f 05 45 46 4f 0d 	vmovdqa64 %zmm0,0xd4f4645(%rip)        # e9f7140 <x86_choice_forms_by_candidate+0x300>
 1502afb:	62 f1 fd 48 7f 05 7b 46 4f 0d 	vmovdqa64 %zmm0,0xd4f467b(%rip)        # e9f7180 <x86_choice_forms_by_candidate+0x340>
 1502b05:	62 f1 fd 48 7f 05 b1 46 4f 0d 	vmovdqa64 %zmm0,0xd4f46b1(%rip)        # e9f71c0 <x86_choice_forms_by_candidate+0x380>
 1502b0f:	62 f1 fd 48 7f 05 e7 46 4f 0d 	vmovdqa64 %zmm0,0xd4f46e7(%rip)        # e9f7200 <x86_choice_forms_by_candidate+0x3c0>
 1502b19:	62 f1 fd 48 7f 0d 1d 47 4f 0d 	vmovdqa64 %zmm1,0xd4f471d(%rip)        # e9f7240 <x86_choice_conditions_by_candidate>
 1502b23:	62 f1 fd 48 7f 0d 53 47 4f 0d 	vmovdqa64 %zmm1,0xd4f4753(%rip)        # e9f7280 <x86_choice_conditions_by_candidate+0x40>
 1502b2d:	62 f1 fd 48 7f 0d 89 47 4f 0d 	vmovdqa64 %zmm1,0xd4f4789(%rip)        # e9f72c0 <x86_choice_conditions_by_candidate+0x80>
 1502b37:	62 f1 fd 48 7f 0d bf 47 4f 0d 	vmovdqa64 %zmm1,0xd4f47bf(%rip)        # e9f7300 <x86_choice_conditions_by_candidate+0xc0>
 1502b41:	62 f1 fd 48 7f 0d f5 47 4f 0d 	vmovdqa64 %zmm1,0xd4f47f5(%rip)        # e9f7340 <x86_choice_conditions_by_candidate+0x100>
 1502b4b:	62 f1 fd 48 7f 0d 2b 48 4f 0d 	vmovdqa64 %zmm1,0xd4f482b(%rip)        # e9f7380 <x86_choice_conditions_by_candidate+0x140>
 1502b55:	62 f1 fd 48 7f 0d 61 48 4f 0d 	vmovdqa64 %zmm1,0xd4f4861(%rip)        # e9f73c0 <x86_choice_conditions_by_candidate+0x180>
 1502b5f:	62 f1 fd 48 7f 0d 97 48 4f 0d 	vmovdqa64 %zmm1,0xd4f4897(%rip)        # e9f7400 <x86_choice_conditions_by_candidate+0x1c0>
 1502b69:	62 f1 fd 48 7f 0d cd 48 4f 0d 	vmovdqa64 %zmm1,0xd4f48cd(%rip)        # e9f7440 <x86_choice_conditions_by_candidate+0x200>
 1502b73:	62 f1 fd 48 7f 0d 03 49 4f 0d 	vmovdqa64 %zmm1,0xd4f4903(%rip)        # e9f7480 <x86_choice_conditions_by_candidate+0x240>
 1502b7d:	62 f1 fd 48 7f 0d 39 49 4f 0d 	vmovdqa64 %zmm1,0xd4f4939(%rip)        # e9f74c0 <x86_choice_conditions_by_candidate+0x280>
 1502b87:	62 f1 fd 48 7f 0d 6f 49 4f 0d 	vmovdqa64 %zmm1,0xd4f496f(%rip)        # e9f7500 <x86_choice_conditions_by_candidate+0x2c0>
 1502b91:	62 f1 fd 48 7f 0d a5 49 4f 0d 	vmovdqa64 %zmm1,0xd4f49a5(%rip)        # e9f7540 <x86_choice_conditions_by_candidate+0x300>
 1502b9b:	62 f1 fd 48 7f 0d db 49 4f 0d 	vmovdqa64 %zmm1,0xd4f49db(%rip)        # e9f7580 <x86_choice_conditions_by_candidate+0x340>
 1502ba5:	62 f1 fd 48 7f 0d 11 4a 4f 0d 	vmovdqa64 %zmm1,0xd4f4a11(%rip)        # e9f75c0 <x86_choice_conditions_by_candidate+0x380>
 1502baf:	62 f1 fd 48 7f 0d 47 4a 4f 0d 	vmovdqa64 %zmm1,0xd4f4a47(%rip)        # e9f7600 <x86_choice_conditions_by_candidate+0x3c0>
 1502bb9:	eb 27                	jmp    1502be2 <run_backend_benchmark+0x1472>
 1502bbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1502bc0:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 1502bc8:	8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%edx
 1502bcf:	48 83 f8 3f          	cmp    $0x3f,%rax
 1502bd3:	48 8d 40 01          	lea    0x1(%rax),%rax
 1502bd7:	0f 92 c1             	setb   %cl
 1502bda:	84 ca                	test   %cl,%dl
 1502bdc:	0f 84 95 06 00 00    	je     1503277 <run_backend_benchmark+0x1b07>
 1502be2:	4c 6b d8 36          	imul   $0x36,%rax,%r11
 1502be6:	49 89 c1             	mov    %rax,%r9
 1502be9:	48 8d 05 80 0a 02 ff 	lea    -0xfdf580(%rip),%rax        # 523670 <x86_choice_sources>
 1502bf0:	48 b9 11 11 11 11 11 88 88 08 	movabs $0x888881111111111,%rcx
 1502bfa:	49 01 c3             	add    %rax,%r11
 1502bfd:	4c 0f a3 c9          	bt     %r9,%rcx
 1502c01:	b8 00 00 00 00       	mov    $0x0,%eax
 1502c06:	72 38                	jb     1502c40 <run_backend_benchmark+0x14d0>
 1502c08:	b8 01 00 00 00       	mov    $0x1,%eax
 1502c0d:	48 ba 22 22 22 22 22 11 11 11 	movabs $0x1111112222222222,%rdx
 1502c17:	c4 e2 b1 f7 c8       	shlx   %r9,%rax,%rcx
 1502c1c:	b8 01 00 00 00       	mov    $0x1,%eax
 1502c21:	48 85 d1             	test   %rdx,%rcx
 1502c24:	75 1a                	jne    1502c40 <run_backend_benchmark+0x14d0>
 1502c26:	48 b8 44 44 44 44 44 22 22 22 	movabs $0x2222224444444444,%rax
 1502c30:	48 21 c1             	and    %rax,%rcx
 1502c33:	b8 00 00 00 00       	mov    $0x0,%eax
 1502c38:	48 83 f9 01          	cmp    $0x1,%rcx
 1502c3c:	83 d0 02             	adc    $0x2,%eax
 1502c3f:	90                   	nop
 1502c40:	41 0f b6 13          	movzbl (%r11),%edx
 1502c44:	48 8d 0d f5 35 4f 0d 	lea    0xd4f35f5(%rip),%rcx        # e9f6240 <x86_choice_row_index>
 1502c4b:	45 0f b6 43 02       	movzbl 0x2(%r11),%r8d
 1502c50:	45 0f b6 63 01       	movzbl 0x1(%r11),%r12d
 1502c55:	89 c7                	mov    %eax,%edi
 1502c57:	45 8d 69 d5          	lea    -0x2b(%r9),%r13d
 1502c5b:	4c 89 8c 24 e8 00 00 00 	mov    %r9,0xe8(%rsp)
 1502c63:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
 1502c67:	44 88 84 24 28 01 00 00 	mov    %r8b,0x128(%rsp)
 1502c6f:	0f b7 34 79          	movzwl (%rcx,%rdi,2),%esi
 1502c73:	66 44 89 0c 79       	mov    %r9w,(%rcx,%rdi,2)
 1502c78:	4b 8d 0c c9          	lea    (%r9,%r9,8),%rcx
 1502c7c:	48 8d 3d 0d 38 4f 0d 	lea    0xd4f380d(%rip),%rdi        # e9f6490 <x86_choice_rows>
 1502c83:	88 54 8f 20          	mov    %dl,0x20(%rdi,%rcx,4)
 1502c87:	44 88 64 8f 21       	mov    %r12b,0x21(%rdi,%rcx,4)
 1502c8c:	44 88 44 8f 22       	mov    %r8b,0x22(%rdi,%rcx,4)
 1502c91:	31 ff                	xor    %edi,%edi
 1502c93:	41 83 fd 14          	cmp    $0x14,%r13d
 1502c97:	4c 8d 05 22 41 4f 0d 	lea    0xd4f4122(%rip),%r8        # e9f6dc0 <x86_choice_row_info>
 1502c9e:	40 0f 92 c7          	setb   %dil
 1502ca2:	8d 3c b8             	lea    (%rax,%rdi,4),%edi
 1502ca5:	66 43 89 3c 48       	mov    %di,(%r8,%r9,2)
 1502caa:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 1502caf:	4c 8d 05 8a f5 4e 0d 	lea    0xd4ef58a(%rip),%r8        # e9f2240 <x86_effects_records>
 1502cb6:	81 e7 ff 7f 00 00    	and    $0x7fff,%edi
 1502cbc:	0f b7 3c 7b          	movzwl (%rbx,%rdi,2),%edi
 1502cc0:	c1 e7 04             	shl    $0x4,%edi
 1502cc3:	4d 8d 0c 38          	lea    (%r8,%rdi,1),%r9
 1502cc7:	42 0f b6 7c 07 0c    	movzbl 0xc(%rdi,%r8,1),%edi
 1502ccd:	4c 89 8c 24 a0 00 00 00 	mov    %r9,0xa0(%rsp)
 1502cd5:	48 89 bc 24 10 01 00 00 	mov    %rdi,0x110(%rsp)
 1502cdd:	40 38 d7             	cmp    %dl,%dil
 1502ce0:	75 2e                	jne    1502d10 <run_backend_benchmark+0x15a0>
 1502ce2:	66 83 fe ff          	cmp    $0xffff,%si
 1502ce6:	be 01 00 00 00       	mov    $0x1,%esi
 1502ceb:	c4 e2 79 f7 c6       	shlx   %eax,%esi,%eax
 1502cf0:	0f 94 c2             	sete   %dl
 1502cf3:	44 39 e0             	cmp    %r12d,%eax
 1502cf6:	40 0f 94 c6          	sete   %sil
 1502cfa:	45 38 61 0d          	cmp    %r12b,0xd(%r9)
 1502cfe:	0f 94 c0             	sete   %al
 1502d01:	40 20 d6             	and    %dl,%sil
 1502d04:	40 20 c6             	and    %al,%sil
 1502d07:	89 b4 24 d8 00 00 00 	mov    %esi,0xd8(%rsp)
 1502d0e:	eb 0b                	jmp    1502d1b <run_backend_benchmark+0x15ab>
 1502d10:	c7 84 24 d8 00 00 00 00 00 00 00 	movl   $0x0,0xd8(%rsp)
 1502d1b:	48 8d 05 6e 37 4f 0d 	lea    0xd4f376e(%rip),%rax        # e9f6490 <x86_choice_rows>
 1502d22:	49 83 c3 06          	add    $0x6,%r11
 1502d26:	be 3b 00 00 00       	mov    $0x3b,%esi
 1502d2b:	bf 21 00 00 00       	mov    $0x21,%edi
 1502d30:	44 89 a4 24 08 01 00 00 	mov    %r12d,0x108(%rsp)
 1502d38:	44 89 ac 24 f8 00 00 00 	mov    %r13d,0xf8(%rsp)
 1502d40:	48 8d 04 88          	lea    (%rax,%rcx,4),%rax
 1502d44:	48 8b 8c 24 e8 00 00 00 	mov    0xe8(%rsp),%rcx
 1502d4c:	4c 89 9c 24 e0 00 00 00 	mov    %r11,0xe0(%rsp)
 1502d54:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
 1502d59:	48 8d 05 e0 40 4f 0d 	lea    0xd4f40e0(%rip),%rax        # e9f6e40 <x86_choice_forms_by_candidate>
 1502d60:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
 1502d64:	48 89 84 24 60 01 00 00 	mov    %rax,0x160(%rsp)
 1502d6c:	48 8d 05 cd 44 4f 0d 	lea    0xd4f44cd(%rip),%rax        # e9f7240 <x86_choice_conditions_by_candidate>
 1502d73:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
 1502d77:	48 8b 8c 24 10 01 00 00 	mov    0x110(%rsp),%rcx
 1502d7f:	48 89 84 24 38 01 00 00 	mov    %rax,0x138(%rsp)
 1502d87:	31 c0                	xor    %eax,%eax
 1502d89:	84 c9                	test   %cl,%cl
 1502d8b:	0f 95 c0             	setne  %al
 1502d8e:	c1 e0 18             	shl    $0x18,%eax
 1502d91:	89 44 24 40          	mov    %eax,0x40(%rsp)
 1502d95:	8d 41 e9             	lea    -0x17(%rcx),%eax
 1502d98:	3c 02                	cmp    $0x2,%al
 1502d9a:	0f 93 c2             	setae  %dl
 1502d9d:	0f 42 f7             	cmovb  %edi,%esi
 1502da0:	c0 e2 02             	shl    $0x2,%dl
 1502da3:	89 b4 24 58 01 00 00 	mov    %esi,0x158(%rsp)
 1502daa:	88 94 24 98 00 00 00 	mov    %dl,0x98(%rsp)
 1502db1:	8d 51 e7             	lea    -0x19(%rcx),%edx
 1502db4:	89 f1                	mov    %esi,%ecx
 1502db6:	31 f6                	xor    %esi,%esi
 1502db8:	80 e1 3a             	and    $0x3a,%cl
 1502dbb:	89 54 24 58          	mov    %edx,0x58(%rsp)
 1502dbf:	88 8c 24 50 01 00 00 	mov    %cl,0x150(%rsp)
 1502dc6:	eb 46                	jmp    1502e0e <run_backend_benchmark+0x169e>
 1502dc8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1502dd0:	66 ba 00 80          	mov    $0x8000,%dx
 1502dd4:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 1502dd9:	48 8b 8c 24 60 01 00 00 	mov    0x160(%rsp),%rcx
 1502de1:	66 89 3c 70          	mov    %di,(%rax,%rsi,2)
 1502de5:	66 89 54 70 10       	mov    %dx,0x10(%rax,%rsi,2)
 1502dea:	48 89 f0             	mov    %rsi,%rax
 1502ded:	48 c1 e0 07          	shl    $0x7,%rax
 1502df1:	48 ff c6             	inc    %rsi
 1502df4:	66 89 3c 01          	mov    %di,(%rcx,%rax,1)
 1502df8:	48 8b bc 24 38 01 00 00 	mov    0x138(%rsp),%rdi
 1502e00:	66 89 14 07          	mov    %dx,(%rdi,%rax,1)
 1502e04:	48 83 fe 08          	cmp    $0x8,%rsi
 1502e08:	0f 84 b2 fd ff ff    	je     1502bc0 <run_backend_benchmark+0x1450>
 1502e0e:	48 8d 04 76          	lea    (%rsi,%rsi,2),%rax
 1502e12:	41 0f b7 3c 43       	movzwl (%r11,%rax,2),%edi
 1502e17:	85 ff                	test   %edi,%edi
 1502e19:	74 b5                	je     1502dd0 <run_backend_benchmark+0x1660>
 1502e1b:	89 f9                	mov    %edi,%ecx
 1502e1d:	81 e1 ff 7f 00 00    	and    $0x7fff,%ecx
 1502e23:	ba 60 df ff ff       	mov    $0xffffdf60,%edx
 1502e28:	41 b8 c0 be ff ff    	mov    $0xffffbec0,%r8d
 1502e2e:	49 8d 04 43          	lea    (%r11,%rax,2),%rax
 1502e32:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 1502e37:	89 bc 24 c0 00 00 00 	mov    %edi,0xc0(%rsp)
 1502e3e:	66 81 f9 a0 20       	cmp    $0x20a0,%cx
 1502e43:	41 0f 42 d6          	cmovb  %r14d,%edx
 1502e47:	66 81 f9 40 41       	cmp    $0x4140,%cx
 1502e4c:	41 0f 43 d0          	cmovae %r8d,%edx
 1502e50:	01 ca                	add    %ecx,%edx
 1502e52:	48 8d 0d e7 f3 4e 0d 	lea    0xd4ef3e7(%rip),%rcx        # e9f2240 <x86_effects_records>
 1502e59:	81 fa a0 20 00 00    	cmp    $0x20a0,%edx
 1502e5f:	41 0f 43 d6          	cmovae %r14d,%edx
 1502e63:	0f b7 14 53          	movzwl (%rbx,%rdx,2),%edx
 1502e67:	c1 e2 04             	shl    $0x4,%edx
 1502e6a:	48 01 ca             	add    %rcx,%rdx
 1502e6d:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 1502e72:	41 83 fd 14          	cmp    $0x14,%r13d
 1502e76:	73 38                	jae    1502eb0 <run_backend_benchmark+0x1740>
 1502e78:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 1502e80:	44 0f b7 40 02       	movzwl 0x2(%rax),%r8d
 1502e85:	0f b6 51 09          	movzbl 0x9(%rcx),%edx
 1502e89:	44 0f b7 49 06       	movzwl 0x6(%rcx),%r9d
 1502e8e:	44 89 84 24 d0 00 00 00 	mov    %r8d,0xd0(%rsp)
 1502e96:	88 54 24 60          	mov    %dl,0x60(%rsp)
 1502e9a:	0f b6 51 0a          	movzbl 0xa(%rcx),%edx
 1502e9e:	41 f6 c0 20          	test   $0x20,%r8b
 1502ea2:	0f 85 e6 00 00 00    	jne    1502f8e <run_backend_benchmark+0x181e>
 1502ea8:	0f b6 74 24 60       	movzbl 0x60(%rsp),%esi
 1502ead:	eb 21                	jmp    1502ed0 <run_backend_benchmark+0x1760>
 1502eaf:	90                   	nop
 1502eb0:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 1502eb8:	44 0f b7 49 06       	movzwl 0x6(%rcx),%r9d
 1502ebd:	0f b6 71 09          	movzbl 0x9(%rcx),%esi
 1502ec1:	0f b6 51 0a          	movzbl 0xa(%rcx),%edx
 1502ec5:	0f b7 48 02          	movzwl 0x2(%rax),%ecx
 1502ec9:	89 8c 24 d0 00 00 00 	mov    %ecx,0xd0(%rsp)
 1502ed0:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
 1502ed5:	0f b6 ca             	movzbl %dl,%ecx
 1502ed8:	41 83 e1 20          	and    $0x20,%r9d
 1502edc:	40 0f b6 f6          	movzbl %sil,%esi
 1502ee0:	0f b6 40 04          	movzbl 0x4(%rax),%eax
 1502ee4:	89 ca                	mov    %ecx,%edx
 1502ee6:	c1 e2 10             	shl    $0x10,%edx
 1502ee9:	45 85 c9             	test   %r9d,%r9d
 1502eec:	41 0f 44 d1          	cmove  %r9d,%edx
 1502ef0:	03 54 24 40          	add    0x40(%rsp),%edx
 1502ef4:	c1 e1 08             	shl    $0x8,%ecx
 1502ef7:	41 0f b6 7f 0a       	movzbl 0xa(%r15),%edi
 1502efc:	45 0f b6 57 0c       	movzbl 0xc(%r15),%r10d
 1502f01:	09 d1                	or     %edx,%ecx
 1502f03:	09 ce                	or     %ecx,%esi
 1502f05:	41 89 f8             	mov    %edi,%r8d
 1502f08:	41 c1 e0 10          	shl    $0x10,%r8d
 1502f0c:	41 f6 47 06 20       	testb  $0x20,0x6(%r15)
 1502f11:	45 0f 44 c6          	cmove  %r14d,%r8d
 1502f15:	45 31 c9             	xor    %r9d,%r9d
 1502f18:	45 84 d2             	test   %r10b,%r10b
 1502f1b:	41 0f 95 c1          	setne  %r9b
 1502f1f:	c1 e7 08             	shl    $0x8,%edi
 1502f22:	c1 ea 10             	shr    $0x10,%edx
 1502f25:	44 09 c7             	or     %r8d,%edi
 1502f28:	45 0f b6 47 09       	movzbl 0x9(%r15),%r8d
 1502f2d:	41 c1 e1 18          	shl    $0x18,%r9d
 1502f31:	44 09 cf             	or     %r9d,%edi
 1502f34:	41 89 f1             	mov    %esi,%r9d
 1502f37:	41 09 f8             	or     %edi,%r8d
 1502f3a:	09 cf                	or     %ecx,%edi
 1502f3c:	c1 e9 08             	shr    $0x8,%ecx
 1502f3f:	45 09 c1             	or     %r8d,%r9d
 1502f42:	c1 ef 08             	shr    $0x8,%edi
 1502f45:	c4 e2 68 f2 c9       	andn   %ecx,%edx,%ecx
 1502f4a:	41 21 f0             	and    %esi,%r8d
 1502f4d:	41 09 f9             	or     %edi,%r9d
 1502f50:	41 f7 d1             	not    %r9d
 1502f53:	41 09 c9             	or     %ecx,%r9d
 1502f56:	44 89 c1             	mov    %r8d,%ecx
 1502f59:	41 c1 e8 10          	shr    $0x10,%r8d
 1502f5d:	20 c1                	and    %al,%cl
 1502f5f:	41 20 c0             	and    %al,%r8b
 1502f62:	0f b6 c9             	movzbl %cl,%ecx
 1502f65:	41 0f b6 c0          	movzbl %r8b,%eax
 1502f69:	44 09 c9             	or     %r9d,%ecx
 1502f6c:	09 c8                	or     %ecx,%eax
 1502f6e:	b9 3f 00 00 00       	mov    $0x3f,%ecx
 1502f73:	f7 d0                	not    %eax
 1502f75:	83 e0 3f             	and    $0x3f,%eax
 1502f78:	45 84 d2             	test   %r10b,%r10b
 1502f7b:	0f 44 c1             	cmove  %ecx,%eax
 1502f7e:	80 bc 24 10 01 00 00 00 	cmpb   $0x0,0x110(%rsp)
 1502f86:	0f 44 c1             	cmove  %ecx,%eax
 1502f89:	e9 55 02 00 00       	jmp    15031e3 <run_backend_benchmark+0x1a73>
 1502f8e:	0f b6 70 04          	movzbl 0x4(%rax),%esi
 1502f92:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 1502f97:	45 31 e4             	xor    %r12d,%r12d
 1502f9a:	44 0f b6 5c 24 60    	movzbl 0x60(%rsp),%r11d
 1502fa0:	41 b8 3b 00 00 00    	mov    $0x3b,%r8d
 1502fa6:	0f b6 48 09          	movzbl 0x9(%rax),%ecx
 1502faa:	0f b6 58 0a          	movzbl 0xa(%rax),%ebx
 1502fae:	88 8c 24 b0 00 00 00 	mov    %cl,0xb0(%rsp)
 1502fb5:	0f b7 48 06          	movzwl 0x6(%rax),%ecx
 1502fb9:	89 8c 24 80 00 00 00 	mov    %ecx,0x80(%rsp)
 1502fc0:	0f b6 48 0c          	movzbl 0xc(%rax),%ecx
 1502fc4:	84 c9                	test   %cl,%cl
 1502fc6:	8d 41 e9             	lea    -0x17(%rcx),%eax
 1502fc9:	48 89 8c 24 00 01 00 00 	mov    %rcx,0x100(%rsp)
 1502fd1:	41 0f 95 c4          	setne  %r12b
 1502fd5:	41 c1 e4 18          	shl    $0x18,%r12d
 1502fd9:	3c 02                	cmp    $0x2,%al
 1502fdb:	b8 21 00 00 00       	mov    $0x21,%eax
 1502fe0:	44 0f 42 c0          	cmovb  %eax,%r8d
 1502fe4:	8d 41 e7             	lea    -0x19(%rcx),%eax
 1502fe7:	40 0f 93 c7          	setae  %dil
 1502feb:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
 1502ff2:	44 89 c0             	mov    %r8d,%eax
 1502ff5:	40 c0 e7 02          	shl    $0x2,%dil
 1502ff9:	44 89 84 24 30 01 00 00 	mov    %r8d,0x130(%rsp)
 1503001:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 1503007:	24 3a                	and    $0x3a,%al
 1503009:	40 88 7c 24 78       	mov    %dil,0x78(%rsp)
 150300e:	88 84 24 f0 00 00 00 	mov    %al,0xf0(%rsp)
 1503015:	31 c0                	xor    %eax,%eax
 1503017:	eb 23                	jmp    150303c <run_backend_benchmark+0x18cc>
 1503019:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1503020:	44 0f b6 5c 24 60    	movzbl 0x60(%rsp),%r11d
 1503026:	09 c8                	or     %ecx,%eax
 1503028:	43 8d 0c 00          	lea    (%r8,%r8,1),%ecx
 150302c:	45 89 f1             	mov    %r14d,%r9d
 150302f:	41 83 f8 11          	cmp    $0x11,%r8d
 1503033:	41 89 c8             	mov    %ecx,%r8d
 1503036:	0f 83 7d 01 00 00    	jae    15031b9 <run_backend_benchmark+0x1a49>
 150303c:	44 8b 54 24 40       	mov    0x40(%rsp),%r10d
 1503041:	44 89 df             	mov    %r11d,%edi
 1503044:	41 89 d5             	mov    %edx,%r13d
 1503047:	45 89 ce             	mov    %r9d,%r14d
 150304a:	41 f6 c1 20          	test   $0x20,%r9b
 150304e:	74 5e                	je     15030ae <run_backend_benchmark+0x193e>
 1503050:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 1503058:	89 d1                	mov    %edx,%ecx
 150305a:	41 89 d5             	mov    %edx,%r13d
 150305d:	44 89 df             	mov    %r11d,%edi
 1503060:	45 0f b6 4a 0f       	movzbl 0xf(%r10),%r9d
 1503065:	41 80 e1 0f          	and    $0xf,%r9b
 1503069:	41 80 f9 02          	cmp    $0x2,%r9b
 150306d:	75 32                	jne    15030a1 <run_backend_benchmark+0x1931>
 150306f:	80 7c 24 58 02       	cmpb   $0x2,0x58(%rsp)
 1503074:	0f 92 c1             	setb   %cl
 1503077:	41 80 7a 0d 00       	cmpb   $0x0,0xd(%r10)
 150307c:	41 0f 94 c5          	sete   %r13b
 1503080:	41 20 cd             	and    %cl,%r13b
 1503083:	75 0a                	jne    150308f <run_backend_benchmark+0x191f>
 1503085:	0f b6 bc 24 58 01 00 00 	movzbl 0x158(%rsp),%edi
 150308d:	eb 08                	jmp    1503097 <run_backend_benchmark+0x1927>
 150308f:	0f b6 bc 24 50 01 00 00 	movzbl 0x150(%rsp),%edi
 1503097:	44 02 ac 24 98 00 00 00 	add    0x98(%rsp),%r13b
 150309f:	31 c9                	xor    %ecx,%ecx
 15030a1:	44 0f b6 d1          	movzbl %cl,%r10d
 15030a5:	41 c1 e2 10          	shl    $0x10,%r10d
 15030a9:	44 03 54 24 40       	add    0x40(%rsp),%r10d
 15030ae:	f6 84 24 80 00 00 00 20 	testb  $0x20,0x80(%rsp)
 15030b6:	41 89 df             	mov    %ebx,%r15d
 15030b9:	0f b6 8c 24 b0 00 00 00 	movzbl 0xb0(%rsp),%ecx
 15030c1:	45 89 e1             	mov    %r12d,%r9d
 15030c4:	74 65                	je     150312b <run_backend_benchmark+0x19bb>
 15030c6:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 15030cb:	41 89 d9             	mov    %ebx,%r9d
 15030ce:	41 89 df             	mov    %ebx,%r15d
 15030d1:	44 0f b6 59 0f       	movzbl 0xf(%rcx),%r11d
 15030d6:	0f b6 8c 24 b0 00 00 00 	movzbl 0xb0(%rsp),%ecx
 15030de:	41 80 e3 0f          	and    $0xf,%r11b
 15030e2:	41 80 fb 02          	cmp    $0x2,%r11b
 15030e6:	75 38                	jne    1503120 <run_backend_benchmark+0x19b0>
 15030e8:	80 bc 24 90 00 00 00 02 	cmpb   $0x2,0x90(%rsp)
 15030f0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 15030f5:	0f 92 c1             	setb   %cl
 15030f8:	41 80 79 0d 00       	cmpb   $0x0,0xd(%r9)
 15030fd:	41 0f 94 c7          	sete   %r15b
 1503101:	41 20 cf             	and    %cl,%r15b
 1503104:	75 0a                	jne    1503110 <run_backend_benchmark+0x19a0>
 1503106:	0f b6 8c 24 30 01 00 00 	movzbl 0x130(%rsp),%ecx
 150310e:	eb 08                	jmp    1503118 <run_backend_benchmark+0x19a8>
 1503110:	0f b6 8c 24 f0 00 00 00 	movzbl 0xf0(%rsp),%ecx
 1503118:	44 02 7c 24 78       	add    0x78(%rsp),%r15b
 150311d:	45 31 c9             	xor    %r9d,%r9d
 1503120:	45 0f b6 c9          	movzbl %r9b,%r9d
 1503124:	41 c1 e1 10          	shl    $0x10,%r9d
 1503128:	45 09 e1             	or     %r12d,%r9d
 150312b:	45 0f b6 dd          	movzbl %r13b,%r11d
 150312f:	45 0f b6 ff          	movzbl %r15b,%r15d
 1503133:	40 0f b6 ff          	movzbl %dil,%edi
 1503137:	0f b6 c9             	movzbl %cl,%ecx
 150313a:	45 89 d5             	mov    %r10d,%r13d
 150313d:	41 c1 ed 10          	shr    $0x10,%r13d
 1503141:	41 c1 e3 08          	shl    $0x8,%r11d
 1503145:	41 c1 e7 08          	shl    $0x8,%r15d
 1503149:	45 01 d3             	add    %r10d,%r11d
 150314c:	45 01 cf             	add    %r9d,%r15d
 150314f:	44 09 f9             	or     %r15d,%ecx
 1503152:	45 09 df             	or     %r11d,%r15d
 1503155:	44 09 df             	or     %r11d,%edi
 1503158:	41 c1 eb 08          	shr    $0x8,%r11d
 150315c:	c4 42 10 f2 db       	andn   %r11d,%r13d,%r11d
 1503161:	41 89 fd             	mov    %edi,%r13d
 1503164:	41 09 cd             	or     %ecx,%r13d
 1503167:	41 c1 ef 08          	shr    $0x8,%r15d
 150316b:	21 f9                	and    %edi,%ecx
 150316d:	89 f7                	mov    %esi,%edi
 150316f:	45 09 fd             	or     %r15d,%r13d
 1503172:	40 20 cf             	and    %cl,%dil
 1503175:	c1 e9 10             	shr    $0x10,%ecx
 1503178:	41 f7 d5             	not    %r13d
 150317b:	40 20 f1             	and    %sil,%cl
 150317e:	40 0f b6 ff          	movzbl %dil,%edi
 1503182:	45 09 dd             	or     %r11d,%r13d
 1503185:	0f b6 c9             	movzbl %cl,%ecx
 1503188:	44 09 ef             	or     %r13d,%edi
 150318b:	09 f9                	or     %edi,%ecx
 150318d:	41 f7 c1 00 00 00 01 	test   $0x1000000,%r9d
 1503194:	bf 3f 00 00 00       	mov    $0x3f,%edi
 1503199:	f7 d1                	not    %ecx
 150319b:	0f 44 cf             	cmove  %edi,%ecx
 150319e:	41 f7 c2 00 00 00 01 	test   $0x1000000,%r10d
 15031a5:	0f 44 cf             	cmove  %edi,%ecx
 15031a8:	44 21 c1             	and    %r8d,%ecx
 15031ab:	0f 84 6f fe ff ff    	je     1503020 <run_backend_benchmark+0x18b0>
 15031b1:	44 89 c1             	mov    %r8d,%ecx
 15031b4:	e9 67 fe ff ff       	jmp    1503020 <run_backend_benchmark+0x18b0>
 15031b9:	4c 8b 9c 24 e0 00 00 00 	mov    0xe0(%rsp),%r11
 15031c1:	44 8b a4 24 08 01 00 00 	mov    0x108(%rsp),%r12d
 15031c9:	44 8b ac 24 f8 00 00 00 	mov    0xf8(%rsp),%r13d
 15031d1:	4c 8b 94 24 00 01 00 00 	mov    0x100(%rsp),%r10
 15031d9:	48 8d 1d 20 af 4e 0d 	lea    0xd4eaf20(%rip),%rbx        # e9ee100 <x86_effects_index>
 15031e0:	45 31 f6             	xor    %r14d,%r14d
 15031e3:	31 c9                	xor    %ecx,%ecx
 15031e5:	a9 ea ff ff ff       	test   $0xffffffea,%eax
 15031ea:	0f 95 c2             	setne  %dl
 15031ed:	45 84 d2             	test   %r10b,%r10b
 15031f0:	74 19                	je     150320b <run_backend_benchmark+0x1a9b>
 15031f2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
 15031f7:	0f b6 76 0f          	movzbl 0xf(%rsi),%esi
 15031fb:	40 80 e6 0f          	and    $0xf,%sil
 15031ff:	74 17                	je     1503218 <run_backend_benchmark+0x1aa8>
 1503201:	40 3a b4 24 28 01 00 00 	cmp    0x128(%rsp),%sil
 1503209:	74 0d                	je     1503218 <run_backend_benchmark+0x1aa8>
 150320b:	c7 84 24 d8 00 00 00 00 00 00 00 	movl   $0x0,0xd8(%rsp)
 1503216:	eb 1e                	jmp    1503236 <run_backend_benchmark+0x1ac6>
 1503218:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
 150321d:	8b bc 24 d8 00 00 00 	mov    0xd8(%rsp),%edi
 1503224:	44 38 66 0d          	cmp    %r12b,0xd(%rsi)
 1503228:	40 0f 96 c6          	setbe  %sil
 150322c:	40 20 f7             	and    %sil,%dil
 150322f:	89 bc 24 d8 00 00 00 	mov    %edi,0xd8(%rsp)
 1503236:	89 c6                	mov    %eax,%esi
 1503238:	89 c7                	mov    %eax,%edi
 150323a:	83 e6 01             	and    $0x1,%esi
 150323d:	83 e7 04             	and    $0x4,%edi
 1503240:	88 d1                	mov    %dl,%cl
 1503242:	83 e0 10             	and    $0x10,%eax
 1503245:	8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%edx
 150324c:	c1 e6 0b             	shl    $0xb,%esi
 150324f:	c1 e7 0a             	shl    $0xa,%edi
 1503252:	c1 e0 09             	shl    $0x9,%eax
 1503255:	c1 e1 0e             	shl    $0xe,%ecx
 1503258:	09 f7                	or     %esi,%edi
 150325a:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
 150325f:	09 f8                	or     %edi,%eax
 1503261:	8b bc 24 c0 00 00 00 	mov    0xc0(%rsp),%edi
 1503268:	09 c1                	or     %eax,%ecx
 150326a:	09 ca                	or     %ecx,%edx
 150326c:	81 ca 80 00 00 00    	or     $0x80,%edx
 1503272:	e9 5d fb ff ff       	jmp    1502dd4 <run_backend_benchmark+0x1664>
 1503277:	89 d1                	mov    %edx,%ecx
 1503279:	f6 c1 01             	test   $0x1,%cl
 150327c:	0f 84 14 78 00 00    	je     150aa96 <run_backend_benchmark+0x9326>
 1503282:	80 3d b7 43 4f 0d 00 	cmpb   $0x0,0xd4f43b7(%rip)        # e9f7640 <tier0_initialized>
 1503289:	0f 85 94 37 00 00    	jne    1506a23 <run_backend_benchmark+0x52b3>
 150328f:	48 8d 3d ba 43 4f 0d 	lea    0xd4f43ba(%rip),%rdi        # e9f7650 <tier0_slot_bases>
 1503296:	ba 00 08 00 00       	mov    $0x800,%edx
 150329b:	31 f6                	xor    %esi,%esi
 150329d:	c5 f8 77             	vzeroupper
 15032a0:	e8 8b 10 26 ff       	call   764330 <memset@plt>
 15032a5:	62 f1 7c 48 28 0d 51 cc 01 ff 	vmovaps -0xfe33af(%rip),%zmm1        # 51ff00 <branch_sizing_patterns+0x170>
 15032af:	62 f3 7d 48 25 c0 ff 	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
 15032b6:	62 f1 fd 48 6f 15 80 cc 01 ff 	vmovdqa64 -0xfe3380(%rip),%zmm2        # 51ff40 <branch_sizing_patterns+0x1b0>
 15032c0:	c7 05 86 4b 4f 0d 00 00 00 00 	movl   $0x0,0xd4f4b86(%rip)        # e9f7e50 <tier0_template_count>
 15032ca:	c6 05 af 4c 4f 0d 01 	movb   $0x1,0xd4f4caf(%rip)        # e9f7f80 <tier0_builder+0x100>
 15032d1:	c7 05 e5 cc 4f 0d 20 00 00 00 	movl   $0x20,0xd4fcce5(%rip)        # e9fffc0 <tier0_slot_count>
 15032db:	62 f1 fe 48 7f 05 db 4c 4f 0d 	vmovdqu64 %zmm0,0xd4f4cdb(%rip)        # e9f7fc0 <tier0_slots>
 15032e5:	c4 e2 79 22 05 d2 d0 01 ff 	vpmovsxbq -0xfe2f2e(%rip),%xmm0        # 5203c0 <branch_sizing_patterns+0x630>
 15032ee:	62 f1 7c 48 29 0d 08 0d 51 0d 	vmovaps %zmm1,0xd510d08(%rip)        # ea14000 <tier0_integer_window>
 15032f8:	62 f1 fd 48 6f 0d 7e cc 01 ff 	vmovdqa64 -0xfe3382(%rip),%zmm1        # 51ff80 <branch_sizing_patterns+0x1f0>
 1503302:	62 f1 fd 48 7f 15 74 0d 51 0d 	vmovdqa64 %zmm2,0xd510d74(%rip)        # ea14080 <tier0_floating_window>
 150330c:	62 f1 fd 48 7f 05 2a 0d 51 0d 	vmovdqa64 %zmm0,0xd510d2a(%rip)        # ea14040 <tier0_integer_window+0x40>
 1503316:	62 f1 fd 48 7f 0d a0 0d 51 0d 	vmovdqa64 %zmm1,0xd510da0(%rip)        # ea140c0 <tier0_floating_window+0x40>
 1503320:	c5 f8 77             	vzeroupper
 1503323:	e8 98 1c 01 00       	call   1514fc0 <tier0_define_templates>
 1503328:	8b 05 92 cc 4f 0d    	mov    0xd4fcc92(%rip),%eax        # e9fffc0 <tier0_slot_count>
 150332e:	48 85 c0             	test   %rax,%rax
 1503331:	0f 84 4d 01 00 00    	je     1503484 <run_backend_benchmark+0x1d14>
 1503337:	48 01 c0             	add    %rax,%rax
 150333a:	48 8d 15 7f 4c 4f 0d 	lea    0xd4f4c7f(%rip),%rdx        # e9f7fc0 <tier0_slots>
 1503341:	48 8d 35 88 cc 4f 0d 	lea    0xd4fcc88(%rip),%rsi        # e9fffd0 <tier0_template_infos>
 1503348:	31 c9                	xor    %ecx,%ecx
 150334a:	eb 11                	jmp    150335d <run_backend_benchmark+0x1bed>
 150334c:	0f 1f 40 00          	nopl   0x0(%rax)
 1503350:	48 83 c1 02          	add    $0x2,%rcx
 1503354:	48 39 c8             	cmp    %rcx,%rax
 1503357:	0f 84 27 01 00 00    	je     1503484 <run_backend_benchmark+0x1d14>
 150335d:	0f b7 3c 11          	movzwl (%rcx,%rdx,1),%edi
 1503361:	66 83 ff fd          	cmp    $0xfffd,%di
 1503365:	7f e9                	jg     1503350 <run_backend_benchmark+0x1be0>
 1503367:	81 e7 ff 7f 00 00    	and    $0x7fff,%edi
 150336d:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
 1503371:	44 0f b6 4c fe 13    	movzbl 0x13(%rsi,%rdi,8),%r9d
 1503377:	44 0f b6 54 fe 3b    	movzbl 0x3b(%rsi,%rdi,8),%r10d
 150337d:	45 89 c8             	mov    %r9d,%r8d
 1503380:	45 89 d3             	mov    %r10d,%r11d
 1503383:	41 c0 e8 02          	shr    $0x2,%r8b
 1503387:	41 c0 eb 02          	shr    $0x2,%r11b
 150338b:	41 80 e0 03          	and    $0x3,%r8b
 150338f:	41 80 e3 03          	and    $0x3,%r11b
 1503393:	41 0f b6 d8          	movzbl %r8b,%ebx
 1503397:	45 0f b6 c3          	movzbl %r11b,%r8d
 150339b:	44 38 c3             	cmp    %r8b,%bl
 150339e:	44 0f 47 c3          	cmova  %ebx,%r8d
 15033a2:	41 80 e1 03          	and    $0x3,%r9b
 15033a6:	41 80 e2 03          	and    $0x3,%r10b
 15033aa:	45 0f b6 d9          	movzbl %r9b,%r11d
 15033ae:	45 0f b6 ca          	movzbl %r10b,%r9d
 15033b2:	44 8b 54 fe 40       	mov    0x40(%rsi,%rdi,8),%r10d
 15033b7:	45 38 cb             	cmp    %r9b,%r11b
 15033ba:	45 0f 47 cb          	cmova  %r11d,%r9d
 15033be:	44 0f b6 5c fe 63    	movzbl 0x63(%rsi,%rdi,8),%r11d
 15033c4:	44 0b 54 fe 18       	or     0x18(%rsi,%rdi,8),%r10d
 15033c9:	44 89 db             	mov    %r11d,%ebx
 15033cc:	c0 eb 02             	shr    $0x2,%bl
 15033cf:	80 e3 03             	and    $0x3,%bl
 15033d2:	0f b6 db             	movzbl %bl,%ebx
 15033d5:	41 38 d8             	cmp    %bl,%r8b
 15033d8:	44 0f 46 c3          	cmovbe %ebx,%r8d
 15033dc:	41 80 e3 03          	and    $0x3,%r11b
 15033e0:	45 0f b6 db          	movzbl %r11b,%r11d
 15033e4:	45 38 d9             	cmp    %r11b,%r9b
 15033e7:	45 0f 46 cb          	cmovbe %r11d,%r9d
 15033eb:	44 0f b7 5c fe 0d    	movzwl 0xd(%rsi,%rdi,8),%r11d
 15033f1:	44 0b 54 fe 68       	or     0x68(%rsi,%rdi,8),%r10d
 15033f6:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 15033fb:	44 0f b7 5c fe 35    	movzwl 0x35(%rsi,%rdi,8),%r11d
 1503401:	c4 c1 79 6e cb       	vmovd  %r11d,%xmm1
 1503406:	44 0f b7 5c fe 5d    	movzwl 0x5d(%rsi,%rdi,8),%r11d
 150340c:	c5 f1 de c0          	vpmaxub %xmm0,%xmm1,%xmm0
 1503410:	c4 c1 79 6e cb       	vmovd  %r11d,%xmm1
 1503415:	44 0f b7 9c fe 85 00 00 00 	movzwl 0x85(%rsi,%rdi,8),%r11d
 150341e:	c4 c1 79 6e d3       	vmovd  %r11d,%xmm2
 1503423:	c5 e9 de c9          	vpmaxub %xmm1,%xmm2,%xmm1
 1503427:	c5 f1 de c0          	vpmaxub %xmm0,%xmm1,%xmm0
 150342b:	c4 e3 79 14 44 fe 0d 00 	vpextrb $0x0,%xmm0,0xd(%rsi,%rdi,8)
 1503433:	c4 e3 79 14 44 fe 0e 01 	vpextrb $0x1,%xmm0,0xe(%rsi,%rdi,8)
 150343b:	44 0f b6 9c fe 8b 00 00 00 	movzbl 0x8b(%rsi,%rdi,8),%r11d
 1503444:	44 89 db             	mov    %r11d,%ebx
 1503447:	c0 eb 02             	shr    $0x2,%bl
 150344a:	80 e3 03             	and    $0x3,%bl
 150344d:	0f b6 db             	movzbl %bl,%ebx
 1503450:	41 38 d8             	cmp    %bl,%r8b
 1503453:	44 0f 46 c3          	cmovbe %ebx,%r8d
 1503457:	41 80 e3 03          	and    $0x3,%r11b
 150345b:	45 0f b6 db          	movzbl %r11b,%r11d
 150345f:	45 38 d9             	cmp    %r11b,%r9b
 1503462:	45 0f 46 cb          	cmovbe %r11d,%r9d
 1503466:	41 c0 e0 02          	shl    $0x2,%r8b
 150346a:	45 08 c8             	or     %r9b,%r8b
 150346d:	44 88 44 fe 13       	mov    %r8b,0x13(%rsi,%rdi,8)
 1503472:	44 0b 94 fe 90 00 00 00 	or     0x90(%rsi,%rdi,8),%r10d
 150347a:	44 89 54 fe 18       	mov    %r10d,0x18(%rsi,%rdi,8)
 150347f:	e9 cc fe ff ff       	jmp    1503350 <run_backend_benchmark+0x1be0>
 1503484:	80 3d f5 4a 4f 0d 00 	cmpb   $0x0,0xd4f4af5(%rip)        # e9f7f80 <tier0_builder+0x100>
 150348b:	0f 84 fe 75 00 00    	je     150aa8f <run_backend_benchmark+0x931f>
 1503491:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1503495:	62 f1 fd 48 7f 44 24 37 	vmovdqa64 %zmm0,0xdc0(%rsp)
 150349d:	62 f1 fd 48 7f 44 24 36 	vmovdqa64 %zmm0,0xd80(%rsp)
 15034a5:	62 f1 fd 48 7f 44 24 35 	vmovdqa64 %zmm0,0xd40(%rsp)
 15034ad:	62 f1 fd 48 7f 44 24 34 	vmovdqa64 %zmm0,0xd00(%rsp)
 15034b5:	c4 e2 79 20 05 2a cc 07 ff 	vpmovsxbw -0xf833d6(%rip),%xmm0        # 5800e8 <x86_semantics_benchmark_code.registers+0xf8>
 15034be:	c4 e2 79 20 0d 29 cc 07 ff 	vpmovsxbw -0xf833d7(%rip),%xmm1        # 5800f0 <x86_semantics_benchmark_code.registers+0x100>
 15034c7:	c5 f9 6e 1d 41 26 07 ff 	vmovd  -0xf8d9bf(%rip),%xmm3        # 575b10 <x86_effects_unknown+0xb0>
 15034cf:	b0 01                	mov    $0x1,%al
 15034d1:	48 8d 15 78 41 4f 0d 	lea    0xd4f4178(%rip),%rdx        # e9f7650 <tier0_slot_bases>
 15034d8:	b9 01 00 00 00       	mov    $0x1,%ecx
 15034dd:	c5 e9 76 d2          	vpcmpeqd %xmm2,%xmm2,%xmm2
 15034e1:	45 31 db             	xor    %r11d,%r11d
 15034e4:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 15034e8:	45 31 d2             	xor    %r10d,%r10d
 15034eb:	89 44 24 30          	mov    %eax,0x30(%rsp)
 15034ef:	48 8d 05 ca 4a 4f 0d 	lea    0xd4f4aca(%rip),%rax        # e9f7fc0 <tier0_slots>
 15034f6:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 15034fb:	eb 40                	jmp    150353d <run_backend_benchmark+0x1dcd>
 15034fd:	0f 1f 00             	nopl   (%rax)
 1503500:	c5 f9 6f ac 24 80 02 00 00 	vmovdqa 0x280(%rsp),%xmm5
 1503509:	48 c1 e6 04          	shl    $0x4,%rsi
 150350d:	ff c1                	inc    %ecx
 150350f:	c5 f9 7f ac 34 00 0d 00 00 	vmovdqa %xmm5,0xd00(%rsp,%rsi,1)
 1503518:	83 fa 10             	cmp    $0x10,%edx
 150351b:	48 8d 35 5e 0d 5b 0d 	lea    0xd5b0d5e(%rip),%rsi        # eab4280 <tier0_vector_rows>
 1503522:	41 0f 43 d3          	cmovae %r11d,%edx
 1503526:	48 83 44 24 40 20    	addq   $0x20,0x40(%rsp)
 150352c:	41 88 14 32          	mov    %dl,(%r10,%rsi,1)
 1503530:	49 ff c2             	inc    %r10
 1503533:	49 83 fa 40          	cmp    $0x40,%r10
 1503537:	0f 84 d9 03 00 00    	je     1503916 <run_backend_benchmark+0x21a6>
 150353d:	48 be 80 ff ff ff bb 37 33 03 	movabs $0x33337bbffffff80,%rsi
 1503547:	4b 8d 14 52          	lea    (%r10,%r10,2),%rdx
 150354b:	4c 8d 05 4e 0f 02 ff 	lea    -0xfdf0b2(%rip),%r8        # 5244a0 <tier0_shapes>
 1503552:	45 8d 4a ed          	lea    -0x13(%r10),%r9d
 1503556:	41 8d 5a e2          	lea    -0x1e(%r10),%ebx
 150355a:	46 8d 34 d5 10 ff ff ff 	lea    -0xf0(,%r10,8),%r14d
 1503562:	45 8d 7a f5          	lea    -0xb(%r10),%r15d
 1503566:	45 8d 62 f0          	lea    -0x10(%r10),%r12d
 150356a:	4c 0f a3 d6          	bt     %r10,%rsi
 150356e:	40 0f 92 c6          	setb   %sil
 1503572:	41 0f b6 7c 10 02    	movzbl 0x2(%r8,%rdx,1),%edi
 1503578:	40 c0 e6 02          	shl    $0x2,%sil
 150357c:	41 0a 34 10          	or     (%r8,%rdx,1),%sil
 1503580:	41 8d 52 ea          	lea    -0x16(%r10),%edx
 1503584:	45 89 d0             	mov    %r10d,%r8d
 1503587:	89 94 24 b0 00 00 00 	mov    %edx,0xb0(%rsp)
 150358e:	40 c0 e7 03          	shl    $0x3,%dil
 1503592:	40 08 f7             	or     %sil,%dil
 1503595:	83 fa 06             	cmp    $0x6,%edx
 1503598:	0f 92 c2             	setb   %dl
 150359b:	41 83 e0 3e          	and    $0x3e,%r8d
 150359f:	41 83 f8 24          	cmp    $0x24,%r8d
 15035a3:	40 0f 94 c6          	sete   %sil
 15035a7:	40 00 f6             	add    %sil,%sil
 15035aa:	41 83 f9 02          	cmp    $0x2,%r9d
 15035ae:	41 0f 92 c1          	setb   %r9b
 15035b2:	41 c0 e1 02          	shl    $0x2,%r9b
 15035b6:	83 fb 06             	cmp    $0x6,%ebx
 15035b9:	48 bb 08 00 08 00 00 08 00 00 	movabs $0x80000080008,%rbx
 15035c3:	c4 e2 8b f7 db       	shrx   %r14,%rbx,%rbx
 15035c8:	41 0f 43 db          	cmovae %r11d,%ebx
 15035cc:	49 83 fa 0d          	cmp    $0xd,%r10
 15035d0:	41 0f 94 c6          	sete   %r14b
 15035d4:	41 08 d6             	or     %dl,%r14b
 15035d7:	41 c0 e6 04          	shl    $0x4,%r14b
 15035db:	41 83 ff 02          	cmp    $0x2,%r15d
 15035df:	41 0f 92 c7          	setb   %r15b
 15035e3:	41 83 fc 05          	cmp    $0x5,%r12d
 15035e7:	41 0f 92 c4          	setb   %r12b
 15035eb:	45 08 fc             	or     %r15b,%r12b
 15035ee:	45 89 d7             	mov    %r10d,%r15d
 15035f1:	41 83 e7 3c          	and    $0x3c,%r15d
 15035f5:	41 c0 e4 05          	shl    $0x5,%r12b
 15035f9:	41 83 ff 24          	cmp    $0x24,%r15d
 15035fd:	41 0f 94 c7          	sete   %r15b
 1503601:	41 c0 e7 06          	shl    $0x6,%r15b
 1503605:	45 08 cf             	or     %r9b,%r15b
 1503608:	41 08 f7             	or     %sil,%r15b
 150360b:	41 08 d7             	or     %dl,%r15b
 150360e:	48 8d 15 eb 0a 5b 0d 	lea    0xd5b0aeb(%rip),%rdx        # eab4100 <tier0_vector_shapes>
 1503615:	45 08 e7             	or     %r12b,%r15b
 1503618:	41 88 3c 12          	mov    %dil,(%r10,%rdx,1)
 150361c:	48 8d 3d 5d 0b 5b 0d 	lea    0xd5b0b5d(%rip),%rdi        # eab4180 <tier0_vector_accesses>
 1503623:	48 8d 15 16 0b 5b 0d 	lea    0xd5b0b16(%rip),%rdx        # eab4140 <tier0_vector_kind_flags>
 150362a:	45 08 f7             	or     %r14b,%r15b
 150362d:	45 88 14 3a          	mov    %r10b,(%r10,%rdi,1)
 1503631:	41 08 df             	or     %bl,%r15b
 1503634:	45 88 3c 12          	mov    %r15b,(%r10,%rdx,1)
 1503638:	41 83 f8 04          	cmp    $0x4,%r8d
 150363c:	74 06                	je     1503644 <run_backend_benchmark+0x1ed4>
 150363e:	41 83 f8 20          	cmp    $0x20,%r8d
 1503642:	75 2c                	jne    1503670 <run_backend_benchmark+0x1f00>
 1503644:	44 89 d2             	mov    %r10d,%edx
 1503647:	44 89 d6             	mov    %r10d,%esi
 150364a:	c1 ee 04             	shr    $0x4,%esi
 150364d:	83 e2 01             	and    $0x1,%edx
 1503650:	01 f2                	add    %esi,%edx
 1503652:	8d 72 2e             	lea    0x2e(%rdx),%esi
 1503655:	41 88 74 3a 40       	mov    %sil,0x40(%r10,%rdi,1)
 150365a:	8d 72 32             	lea    0x32(%rdx),%esi
 150365d:	80 c2 36             	add    $0x36,%dl
 1503660:	41 88 b4 3a 80 00 00 00 	mov    %sil,0x80(%r10,%rdi,1)
 1503668:	eb 16                	jmp    1503680 <run_backend_benchmark+0x1f10>
 150366a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1503670:	44 89 d2             	mov    %r10d,%edx
 1503673:	45 88 54 3a 40       	mov    %r10b,0x40(%r10,%rdi,1)
 1503678:	45 88 94 3a 80 00 00 00 	mov    %r10b,0x80(%r10,%rdi,1)
 1503680:	49 83 fa 3a          	cmp    $0x3a,%r10
 1503684:	41 88 94 3a c0 00 00 00 	mov    %dl,0xc0(%r10,%rdi,1)
 150368c:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 1503692:	40 0f 92 c6          	setb   %sil
 1503696:	49 83 fa 09          	cmp    $0x9,%r10
 150369a:	40 0f 95 c7          	setne  %dil
 150369e:	49 83 fa 0a          	cmp    $0xa,%r10
 15036a2:	41 0f 94 c0          	sete   %r8b
 15036a6:	49 83 fa 1d          	cmp    $0x1d,%r10
 15036aa:	0f 94 c2             	sete   %dl
 15036ad:	40 84 fe             	test   %dil,%sil
 15036b0:	0f 84 fa 01 00 00    	je     15038b0 <run_backend_benchmark+0x2140>
 15036b6:	41 08 d0             	or     %dl,%r8b
 15036b9:	45 31 c9             	xor    %r9d,%r9d
 15036bc:	44 88 44 24 60       	mov    %r8b,0x60(%rsp)
 15036c1:	eb 23                	jmp    15036e6 <run_backend_benchmark+0x1f76>
 15036c3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 15036d0:	44 0f b6 44 24 60    	movzbl 0x60(%rsp),%r8d
 15036d6:	49 ff c1             	inc    %r9
 15036d9:	4c 89 f8             	mov    %r15,%rax
 15036dc:	49 83 f9 10          	cmp    $0x10,%r9
 15036e0:	0f 84 d3 01 00 00    	je     15038b9 <run_backend_benchmark+0x2149>
 15036e6:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 15036eb:	46 0f b7 34 4a       	movzwl (%rdx,%r9,2),%r14d
 15036f0:	ba 07 00 04 00       	mov    $0x40007,%edx
 15036f5:	c5 fb 92 ca          	kmovd  %edx,%k1
 15036f9:	66 ba ef 01          	mov    $0x1ef,%dx
 15036fd:	62 b1 ff c9 6f ac 70 02 00 00 00 	vmovdqu16 0x2(%rax,%r14,2),%zmm5{%k1}{z}
 1503708:	c5 fb 92 ca          	kmovd  %edx,%k1
 150370c:	46 0f b7 7c 70 28    	movzwl 0x28(%rax,%r14,2),%r15d
 1503712:	42 0f b7 54 70 1a    	movzwl 0x1a(%rax,%r14,2),%edx
 1503718:	42 0f b7 74 70 24    	movzwl 0x24(%rax,%r14,2),%esi
 150371e:	4a 8d 3c 70          	lea    (%rax,%r14,2),%rdi
 1503722:	62 b1 ff a9 6f b4 70 12 00 00 00 	vmovdqu16 0x12(%rax,%r14,2),%ymm6{%k1}{z}
 150372d:	49 83 fa 0a          	cmp    $0xa,%r10
 1503731:	75 3d                	jne    1503770 <run_backend_benchmark+0x2000>
 1503733:	4c 8d 1d 16 3f 4f 0d 	lea    0xd4f3f16(%rip),%r11        # e9f7650 <tier0_slot_bases>
 150373a:	45 31 ed             	xor    %r13d,%r13d
 150373d:	45 0f b6 e0          	movzbl %r8b,%r12d
 1503741:	43 0f b7 9c 4b 40 01 00 00 	movzwl 0x140(%r11,%r9,2),%ebx
 150374a:	c5 fa 7e 7c 58 08    	vmovq  0x8(%rax,%rbx,2),%xmm7
 1503750:	62 f1 45 08 75 c2    	vpcmpeqw %xmm2,%xmm7,%k0
 1503756:	c5 fb 93 d8          	kmovd  %k0,%ebx
 150375a:	f6 c3 0f             	test   $0xf,%bl
 150375d:	bb 08 00 00 00       	mov    $0x8,%ebx
 1503762:	45 0f 45 e5          	cmovne %r13d,%r12d
 1503766:	45 31 c0             	xor    %r8d,%r8d
 1503769:	eb 50                	jmp    15037bb <run_backend_benchmark+0x204b>
 150376b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1503770:	c5 fa 7e 7f 32       	vmovq  0x32(%rdi),%xmm7
 1503775:	c5 7a 7e 47 2a       	vmovq  0x2a(%rdi),%xmm8
 150377a:	49 83 fa 1d          	cmp    $0x1d,%r10
 150377e:	0f 94 c3             	sete   %bl
 1503781:	62 f1 45 08 75 c2    	vpcmpeqw %xmm2,%xmm7,%k0
 1503787:	c5 7b 93 e0          	kmovd  %k0,%r12d
 150378b:	62 f1 3d 08 75 c2    	vpcmpeqw %xmm2,%xmm8,%k0
 1503791:	41 f6 c4 0f          	test   $0xf,%r12b
 1503795:	45 0f b6 e0          	movzbl %r8b,%r12d
 1503799:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 150379f:	c5 7b 93 e8          	kmovd  %k0,%r13d
 15037a3:	45 0f 45 e0          	cmovne %r8d,%r12d
 15037a7:	41 f6 c5 0f          	test   $0xf,%r13b
 15037ab:	41 0f 94 c5          	sete   %r13b
 15037af:	41 20 dd             	and    %bl,%r13b
 15037b2:	bb 1d 00 00 00       	mov    $0x1d,%ebx
 15037b7:	41 c0 e5 07          	shl    $0x7,%r13b
 15037bb:	62 f2 f5 28 8d f6    	vpermw %ymm6,%ymm1,%ymm6
 15037c1:	62 f2 fd 48 8d ed    	vpermw %zmm5,%zmm0,%zmm5
 15037c7:	66 83 fa ff          	cmp    $0xffff,%dx
 15037cb:	41 0f 95 c3          	setne  %r11b
 15037cf:	66 83 fe ff          	cmp    $0xffff,%si
 15037d3:	0f 95 c2             	setne  %dl
 15037d6:	62 f1 4d 08 75 c2    	vpcmpeqw %xmm2,%xmm6,%k0
 15037dc:	c5 f9 98 c0          	kortestb %k0,%k0
 15037e0:	62 f1 55 08 75 c2    	vpcmpeqw %xmm2,%xmm5,%k0
 15037e6:	62 f3 d5 08 3f ca 04 	vpcmpneqw %xmm2,%xmm5,%k1
 15037ed:	62 f2 7e 08 38 e9    	vpmovm2d %k1,%xmm5
 15037f3:	62 f2 7e 08 38 f0    	vpmovm2d %k0,%xmm6
 15037f9:	c4 e3 49 02 ed 01    	vpblendd $0x1,%xmm5,%xmm6,%xmm5
 15037ff:	40 0f 94 c6          	sete   %sil
 1503803:	44 20 da             	and    %r11b,%dl
 1503806:	4c 8d 1c 58          	lea    (%rax,%rbx,2),%r11
 150380a:	62 f2 7e 08 39 cd    	vpmovd2m %xmm5,%k1
 1503810:	62 f2 65 09 66 2d 96 22 07 ff 	vpblendmb -0xf8dd6a(%rip),%xmm3,%xmm5{%k1}        # 575ab0 <x86_effects_unknown+0x50>
 150381a:	40 20 f2             	and    %sil,%dl
 150381d:	66 41 83 ff ff       	cmp    $0xffff,%r15w
 1503822:	49 89 c7             	mov    %rax,%r15
 1503825:	40 0f 95 c6          	setne  %sil
 1503829:	c0 e2 05             	shl    $0x5,%dl
 150382c:	41 c0 e4 06          	shl    $0x6,%r12b
 1503830:	40 c0 e6 04          	shl    $0x4,%sil
 1503834:	66 43 83 3c 73 ff    	cmpw   $0xffff,(%r11,%r14,2)
 150383a:	45 0f b6 dc          	movzbl %r12b,%r11d
 150383e:	45 0f 44 d8          	cmove  %r8d,%r11d
 1503842:	c5 c9 72 d5 10       	vpsrld $0x10,%xmm5,%xmm6
 1503847:	41 08 d3             	or     %dl,%r11b
 150384a:	c5 d1 eb ee          	vpor   %xmm6,%xmm5,%xmm5
 150384e:	c5 c9 71 d5 08       	vpsrlw $0x8,%xmm5,%xmm6
 1503853:	c5 d1 eb ee          	vpor   %xmm6,%xmm5,%xmm5
 1503857:	c5 f9 7e eb          	vmovd  %xmm5,%ebx
 150385b:	40 08 f3             	or     %sil,%bl
 150385e:	41 08 db             	or     %bl,%r11b
 1503861:	45 08 eb             	or     %r13b,%r11b
 1503864:	83 bc 24 b0 00 00 00 05 	cmpl   $0x5,0xb0(%rsp)
 150386c:	46 88 9c 0c 80 02 00 00 	mov    %r11b,0x280(%rsp,%r9,1)
 1503874:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 150387a:	0f 87 50 fe ff ff    	ja     15036d0 <run_backend_benchmark+0x1f60>
 1503880:	66 83 7f 08 ff       	cmpw   $0xffff,0x8(%rdi)
 1503885:	c4 e3 79 30 c0 02    	kshiftrb $0x2,%k0,%k0
 150388b:	c5 fb 93 d0          	kmovd  %k0,%edx
 150388f:	40 0f 95 c6          	setne  %sil
 1503893:	40 30 d6             	xor    %dl,%sil
 1503896:	8b 54 24 30          	mov    0x30(%rsp),%edx
 150389a:	40 20 f2             	and    %sil,%dl
 150389d:	89 54 24 30          	mov    %edx,0x30(%rsp)
 15038a1:	e9 2a fe ff ff       	jmp    15036d0 <run_backend_benchmark+0x1f60>
 15038a6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 15038b0:	c5 f9 7f a4 24 80 02 00 00 	vmovdqa %xmm4,0x280(%rsp)
 15038b9:	48 8d bc 24 00 0d 00 00 	lea    0xd00(%rsp),%rdi
 15038c1:	89 ce                	mov    %ecx,%esi
 15038c3:	45 31 c0             	xor    %r8d,%r8d
 15038c6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 15038d0:	c5 fa 6f 2f          	vmovdqu (%rdi),%xmm5
 15038d4:	89 ca                	mov    %ecx,%edx
 15038d6:	c5 d1 ef ac 24 80 02 00 00 	vpxor  0x280(%rsp),%xmm5,%xmm5
 15038df:	c4 e2 79 17 ed       	vptest %xmm5,%xmm5
 15038e4:	41 0f 44 d0          	cmove  %r8d,%edx
 15038e8:	49 ff c0             	inc    %r8
 15038eb:	49 39 f0             	cmp    %rsi,%r8
 15038ee:	73 08                	jae    15038f8 <run_backend_benchmark+0x2188>
 15038f0:	48 83 c7 10          	add    $0x10,%rdi
 15038f4:	39 ca                	cmp    %ecx,%edx
 15038f6:	74 d8                	je     15038d0 <run_backend_benchmark+0x2160>
 15038f8:	39 ca                	cmp    %ecx,%edx
 15038fa:	0f 85 18 fc ff ff    	jne    1503518 <run_backend_benchmark+0x1da8>
 1503900:	83 f9 0f             	cmp    $0xf,%ecx
 1503903:	0f 86 f7 fb ff ff    	jbe    1503500 <run_backend_benchmark+0x1d90>
 1503909:	c7 44 24 30 00 00 00 00 	movl   $0x0,0x30(%rsp)
 1503911:	e9 02 fc ff ff       	jmp    1503518 <run_backend_benchmark+0x1da8>
 1503916:	62 f1 7c 48 28 44 24 34 	vmovaps 0xd00(%rsp),%zmm0
 150391e:	62 f1 7c 48 28 54 24 36 	vmovaps 0xd80(%rsp),%zmm2
 1503926:	62 f1 7c 48 28 5c 24 37 	vmovaps 0xdc0(%rsp),%zmm3
 150392e:	62 f1 fd 48 6f 4c 24 35 	vmovdqa64 0xd40(%rsp),%zmm1
 1503936:	48 8d 35 62 0b 5b 0d 	lea    0xd5b0b62(%rip),%rsi        # eab449f <tier0_vector_convert_home+0x1f>
 150393d:	48 8d 15 0c 3d 4f 0d 	lea    0xd4f3d0c(%rip),%rdx        # e9f7650 <tier0_slot_bases>
 1503944:	31 ff                	xor    %edi,%edi
 1503946:	62 f1 7c 48 29 05 70 09 5b 0d 	vmovaps %zmm0,0xd5b0970(%rip)        # eab42c0 <tier0_vector_properties>
 1503950:	62 f2 7d 48 5a 05 c6 21 07 ff 	vbroadcasti32x4 -0xf8de3a(%rip),%zmm0        # 575b20 <x86_effects_unknown+0xc0>
 150395a:	62 f1 7c 48 29 1d 1c 0a 5b 0d 	vmovaps %zmm3,0xd5b0a1c(%rip)        # eab4380 <tier0_vector_properties+0xc0>
 1503964:	62 f1 7c 48 29 15 d2 09 5b 0d 	vmovaps %zmm2,0xd5b09d2(%rip)        # eab4340 <tier0_vector_properties+0x80>
 150396e:	62 f2 7d 48 5a 1d b8 21 07 ff 	vbroadcasti32x4 -0xf8de48(%rip),%zmm3        # 575b30 <x86_effects_unknown+0xd0>
 1503978:	62 f2 7d 48 5a 15 be 21 07 ff 	vbroadcasti32x4 -0xf8de42(%rip),%zmm2        # 575b40 <x86_effects_unknown+0xe0>
 1503982:	62 f1 fd 48 7f 0d 74 09 5b 0d 	vmovdqa64 %zmm1,0xd5b0974(%rip)        # eab4300 <tier0_vector_properties+0x40>
 150398c:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1503990:	62 f1 fd 48 7f 05 a6 0a 5b 0d 	vmovdqa64 %zmm0,0xd5b0aa6(%rip)        # eab4440 <tier0_vector_integer>
 150399a:	c5 f9 76 c0          	vpcmpeqd %xmm0,%xmm0,%xmm0
 150399e:	62 f1 fd 48 7f 1d 18 0a 5b 0d 	vmovdqa64 %zmm3,0xd5b0a18(%rip)        # eab43c0 <tier0_vector_stacks>
 15039a8:	62 f1 fd 48 7f 15 4e 0a 5b 0d 	vmovdqa64 %zmm2,0xd5b0a4e(%rip)        # eab4400 <tier0_vector_wide>
 15039b2:	e9 82 00 00 00       	jmp    1503a39 <run_backend_benchmark+0x22c9>
 15039b7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 15039c0:	0f b7 8c 7a 22 01 00 00 	movzwl 0x122(%rdx,%rdi,2),%ecx
 15039c8:	62 f3 fd 08 3f 4c 48 02 04 	vpcmpneqw 0x20(%rax,%rcx,2),%xmm0,%k1
 15039d1:	62 f1 7f 89 6f 15 e5 20 07 ff 	vmovdqu8 -0xf8df1b(%rip),%xmm2{%k1}{z}        # 575ac0 <x86_effects_unknown+0x60>
 15039db:	c5 f9 d6 56 f1       	vmovq  %xmm2,-0xf(%rsi)
 15039e0:	c5 fa 7e 54 48 30    	vmovq  0x30(%rax,%rcx,2),%xmm2
 15039e6:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 15039ed:	62 f1 7f 89 6f 15 d9 20 07 ff 	vmovdqu8 -0xf8df27(%rip),%xmm2{%k1}{z}        # 575ad0 <x86_effects_unknown+0x70>
 15039f7:	c5 f9 7e 56 f9       	vmovd  %xmm2,-0x7(%rsi)
 15039fc:	c5 f9 6e 54 48 38    	vmovd  0x38(%rax,%rcx,2),%xmm2
 1503a02:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 1503a09:	62 f1 7f 89 6f 15 cd 20 07 ff 	vmovdqu8 -0xf8df33(%rip),%xmm2{%k1}{z}        # 575ae0 <x86_effects_unknown+0x80>
 1503a13:	c4 e3 79 14 56 fd 00 	vpextrb $0x0,%xmm2,-0x3(%rsi)
 1503a1a:	c4 e3 79 14 56 fe 01 	vpextrb $0x1,%xmm2,-0x2(%rsi)
 1503a21:	66 c7 46 ff 00 00    	movw   $0x0,-0x1(%rsi)
 1503a27:	48 83 c7 02          	add    $0x2,%rdi
 1503a2b:	48 83 c6 20          	add    $0x20,%rsi
 1503a2f:	48 83 ff 10          	cmp    $0x10,%rdi
 1503a33:	0f 84 b3 00 00 00    	je     1503aec <run_backend_benchmark+0x237c>
 1503a39:	48 83 ff 0e          	cmp    $0xe,%rdi
 1503a3d:	0f 83 7d 00 00 00    	jae    1503ac0 <run_backend_benchmark+0x2350>
 1503a43:	0f b7 8c 7a 20 01 00 00 	movzwl 0x120(%rdx,%rdi,2),%ecx
 1503a4b:	62 f3 fd 08 3f 4c 48 02 04 	vpcmpneqw 0x20(%rax,%rcx,2),%xmm0,%k1
 1503a54:	62 f1 7f 89 6f 15 62 20 07 ff 	vmovdqu8 -0xf8df9e(%rip),%xmm2{%k1}{z}        # 575ac0 <x86_effects_unknown+0x60>
 1503a5e:	c5 f9 d6 56 e1       	vmovq  %xmm2,-0x1f(%rsi)
 1503a63:	c5 fa 7e 54 48 30    	vmovq  0x30(%rax,%rcx,2),%xmm2
 1503a69:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 1503a70:	62 f1 7f 89 6f 15 56 20 07 ff 	vmovdqu8 -0xf8dfaa(%rip),%xmm2{%k1}{z}        # 575ad0 <x86_effects_unknown+0x70>
 1503a7a:	c5 f9 7e 56 e9       	vmovd  %xmm2,-0x17(%rsi)
 1503a7f:	c5 f9 6e 54 48 38    	vmovd  0x38(%rax,%rcx,2),%xmm2
 1503a85:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 1503a8c:	62 f1 7f 89 6f 15 4a 20 07 ff 	vmovdqu8 -0xf8dfb6(%rip),%xmm2{%k1}{z}        # 575ae0 <x86_effects_unknown+0x80>
 1503a96:	c4 e3 79 14 56 ed 00 	vpextrb $0x0,%xmm2,-0x13(%rsi)
 1503a9d:	c4 e3 79 14 56 ee 01 	vpextrb $0x1,%xmm2,-0x12(%rsi)
 1503aa4:	66 c7 46 ef 00 00    	movw   $0x0,-0x11(%rsi)
 1503aaa:	48 83 ff 0e          	cmp    $0xe,%rdi
 1503aae:	0f 82 0c ff ff ff    	jb     15039c0 <run_backend_benchmark+0x2250>
 1503ab4:	eb 1c                	jmp    1503ad2 <run_backend_benchmark+0x2362>
 1503ab6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 1503ac0:	48 8d 4e e1          	lea    -0x1f(%rsi),%rcx
 1503ac4:	c5 f9 7f 09          	vmovdqa %xmm1,(%rcx)
 1503ac8:	48 83 ff 0e          	cmp    $0xe,%rdi
 1503acc:	0f 82 ee fe ff ff    	jb     15039c0 <run_backend_benchmark+0x2250>
 1503ad2:	48 8d 4e f1          	lea    -0xf(%rsi),%rcx
 1503ad6:	c5 f9 7f 09          	vmovdqa %xmm1,(%rcx)
 1503ada:	48 83 c7 02          	add    $0x2,%rdi
 1503ade:	48 83 c6 20          	add    $0x20,%rsi
 1503ae2:	48 83 ff 10          	cmp    $0x10,%rdi
 1503ae6:	0f 85 4d ff ff ff    	jne    1503a39 <run_backend_benchmark+0x22c9>
 1503aec:	f6 44 24 30 01       	testb  $0x1,0x30(%rsp)
 1503af1:	0f 84 98 6f 00 00    	je     150aa8f <run_backend_benchmark+0x931f>
 1503af7:	8b 15 53 43 4f 0d    	mov    0xd4f4353(%rip),%edx        # e9f7e50 <tier0_template_count>
 1503afd:	48 81 fa 01 10 00 00 	cmp    $0x1001,%rdx
 1503b04:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 1503b0c:	0f 92 c1             	setb   %cl
 1503b0f:	88 4c 24 60          	mov    %cl,0x60(%rsp)
 1503b13:	48 85 d2             	test   %rdx,%rdx
 1503b16:	0f 84 47 02 00 00    	je     1503d63 <run_backend_benchmark+0x25f3>
 1503b1c:	48 8d 3d ad c4 4f 0d 	lea    0xd4fc4ad(%rip),%rdi        # e9fffd0 <tier0_template_infos>
 1503b23:	45 31 c9             	xor    %r9d,%r9d
 1503b26:	45 31 db             	xor    %r11d,%r11d
 1503b29:	e9 d9 00 00 00       	jmp    1503c07 <run_backend_benchmark+0x2497>
 1503b2e:	66 90                	xchg   %ax,%ax
 1503b30:	0f b6 54 24 30       	movzbl 0x30(%rsp),%edx
 1503b35:	31 db                	xor    %ebx,%ebx
 1503b37:	49 89 ca             	mov    %rcx,%r10
 1503b3a:	48 be 00 00 00 00 00 70 00 00 	movabs $0x700000000000,%rsi
 1503b44:	20 54 24 60          	and    %dl,0x60(%rsp)
 1503b48:	80 bc 24 b0 00 00 00 00 	cmpb   $0x0,0xb0(%rsp)
 1503b50:	48 ba 00 00 00 00 00 00 1c 00 	movabs $0x1c000000000000,%rdx
 1503b5a:	0f 95 c3             	setne  %bl
 1503b5d:	49 c1 e2 32          	shl    $0x32,%r10
 1503b61:	48 81 f9 ff 00 00 00 	cmp    $0xff,%rcx
 1503b68:	4c 89 c1             	mov    %r8,%rcx
 1503b6b:	4c 0f 44 d2          	cmove  %rdx,%r10
 1503b6f:	48 c1 e1 2f          	shl    $0x2f,%rcx
 1503b73:	49 81 f8 ff 00 00 00 	cmp    $0xff,%r8
 1503b7a:	48 ba 00 00 00 00 00 80 03 00 	movabs $0x3800000000000,%rdx
 1503b84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 1503b8a:	48 0f 44 ca          	cmove  %rdx,%rcx
 1503b8e:	4c 89 e2             	mov    %r12,%rdx
 1503b91:	48 c1 e2 2c          	shl    $0x2c,%rdx
 1503b95:	49 81 fc ff 00 00 00 	cmp    $0xff,%r12
 1503b9c:	48 0f 44 d6          	cmove  %rsi,%rdx
 1503ba0:	80 7f 02 00          	cmpb   $0x0,0x2(%rdi)
 1503ba4:	48 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rsi
 1503bae:	48 8d b6 00 00 e0 ff 	lea    -0x200000(%rsi),%rsi
 1503bb5:	4c 0f 45 c6          	cmovne %rsi,%r8
 1503bb9:	48 c1 e3 25          	shl    $0x25,%rbx
 1503bbd:	4c 09 d1             	or     %r10,%rcx
 1503bc0:	49 c1 e1 35          	shl    $0x35,%r9
 1503bc4:	49 ff c3             	inc    %r11
 1503bc7:	48 09 d3             	or     %rdx,%rbx
 1503bca:	0f b6 57 05          	movzbl 0x5(%rdi),%edx
 1503bce:	4c 09 c9             	or     %r9,%rcx
 1503bd1:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 1503bd6:	48 83 c7 28          	add    $0x28,%rdi
 1503bda:	48 09 d9             	or     %rbx,%rcx
 1503bdd:	4c 09 c1             	or     %r8,%rcx
 1503be0:	4c 09 f1             	or     %r14,%rcx
 1503be3:	48 c1 e2 26          	shl    $0x26,%rdx
 1503be7:	48 09 d1             	or     %rdx,%rcx
 1503bea:	48 8d 15 8f 49 5b 0d 	lea    0xd5b498f(%rip),%rdx        # eab8580 <tier0_template_words>
 1503bf1:	49 89 0c 11          	mov    %rcx,(%r9,%rdx,1)
 1503bf5:	49 83 c1 08          	add    $0x8,%r9
 1503bf9:	4c 39 9c 24 80 00 00 00 	cmp    %r11,0x80(%rsp)
 1503c01:	0f 84 5c 01 00 00    	je     1503d63 <run_backend_benchmark+0x25f3>
 1503c07:	44 8b 77 18          	mov    0x18(%rdi),%r14d
 1503c0b:	0f b6 74 24 60       	movzbl 0x60(%rsp),%esi
 1503c10:	45 85 f6             	test   %r14d,%r14d
 1503c13:	74 0a                	je     1503c1f <run_backend_benchmark+0x24af>
 1503c15:	41 83 fe 04          	cmp    $0x4,%r14d
 1503c19:	0f 94 c1             	sete   %cl
 1503c1c:	40 20 ce             	and    %cl,%sil
 1503c1f:	0f b6 57 0f          	movzbl 0xf(%rdi),%edx
 1503c23:	41 b0 01             	mov    $0x1,%r8b
 1503c26:	b1 01                	mov    $0x1,%cl
 1503c28:	88 94 24 b0 00 00 00 	mov    %dl,0xb0(%rsp)
 1503c2f:	84 d2                	test   %dl,%dl
 1503c31:	74 07                	je     1503c3a <run_backend_benchmark+0x24ca>
 1503c33:	83 7f 14 00          	cmpl   $0x0,0x14(%rdi)
 1503c37:	0f 94 c1             	sete   %cl
 1503c3a:	44 0f b6 7f 04       	movzbl 0x4(%rdi),%r15d
 1503c3f:	49 81 ff ff 00 00 00 	cmp    $0xff,%r15
 1503c46:	74 09                	je     1503c51 <run_backend_benchmark+0x24e1>
 1503c48:	66 83 7f 06 40       	cmpw   $0x40,0x6(%rdi)
 1503c4d:	41 0f 92 c0          	setb   %r8b
 1503c51:	48 8b 57 20          	mov    0x20(%rdi),%rdx
 1503c55:	44 88 44 24 30       	mov    %r8b,0x30(%rsp)
 1503c5a:	4c 8d 05 1f 09 5b 0d 	lea    0xd5b091f(%rip),%r8        # eab4580 <tier0_masks>
 1503c61:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 1503c66:	4b 89 14 01          	mov    %rdx,(%r9,%r8,1)
 1503c6a:	44 0f b6 47 0c       	movzbl 0xc(%rdi),%r8d
 1503c6f:	44 0f b6 4f 0b       	movzbl 0xb(%rdi),%r9d
 1503c74:	ba 00 80 07 00       	mov    $0x78000,%edx
 1503c79:	45 89 c4             	mov    %r8d,%r12d
 1503c7c:	41 c1 e4 0f          	shl    $0xf,%r12d
 1503c80:	41 81 f8 ff 00 00 00 	cmp    $0xff,%r8d
 1503c87:	4c 0f 44 e2          	cmove  %rdx,%r12
 1503c8b:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 1503c92:	75 13                	jne    1503ca7 <run_backend_benchmark+0x2537>
 1503c94:	80 7f 10 00          	cmpb   $0x0,0x10(%rdi)
 1503c98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 1503c9e:	ba 07 00 00 00       	mov    $0x7,%edx
 1503ca3:	4c 0f 44 ca          	cmove  %rdx,%r9
 1503ca7:	0f b6 5f 01          	movzbl 0x1(%rdi),%ebx
 1503cab:	40 20 ce             	and    %cl,%sil
 1503cae:	31 c9                	xor    %ecx,%ecx
 1503cb0:	45 85 f6             	test   %r14d,%r14d
 1503cb3:	44 0f b6 47 0d       	movzbl 0xd(%rdi),%r8d
 1503cb8:	44 0f b6 77 0e       	movzbl 0xe(%rdi),%r14d
 1503cbd:	8b 17                	mov    (%rdi),%edx
 1503cbf:	44 0f b6 57 03       	movzbl 0x3(%rdi),%r10d
 1503cc4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 1503cca:	0f 95 c1             	setne  %cl
 1503ccd:	40 88 74 24 60       	mov    %sil,0x60(%rsp)
 1503cd2:	c1 e1 17             	shl    $0x17,%ecx
 1503cd5:	48 89 de             	mov    %rbx,%rsi
 1503cd8:	48 c1 e6 1e          	shl    $0x1e,%rsi
 1503cdc:	41 c1 e0 13          	shl    $0x13,%r8d
 1503ce0:	41 c1 e6 15          	shl    $0x15,%r14d
 1503ce4:	c1 e2 18             	shl    $0x18,%edx
 1503ce7:	48 81 ce 00 00 00 08 	or     $0x8000000,%rsi
 1503cee:	48 81 fb ff 00 00 00 	cmp    $0xff,%rbx
 1503cf5:	4c 89 d3             	mov    %r10,%rbx
 1503cf8:	49 0f 44 f5          	cmove  %r13,%rsi
 1503cfc:	48 c1 e3 20          	shl    $0x20,%rbx
 1503d00:	48 81 cb 00 00 00 10 	or     $0x10000000,%rbx
 1503d07:	49 81 fa ff 00 00 00 	cmp    $0xff,%r10
 1503d0e:	49 0f 44 dd          	cmove  %r13,%rbx
 1503d12:	4d 09 c6             	or     %r8,%r14
 1503d15:	4c 09 e1             	or     %r12,%rcx
 1503d18:	44 0f b6 67 08       	movzbl 0x8(%rdi),%r12d
 1503d1d:	44 0f b6 47 09       	movzbl 0x9(%rdi),%r8d
 1503d22:	49 09 d6             	or     %rdx,%r14
 1503d25:	49 09 f6             	or     %rsi,%r14
 1503d28:	49 09 de             	or     %rbx,%r14
 1503d2b:	49 09 ce             	or     %rcx,%r14
 1503d2e:	0f b6 4f 0a          	movzbl 0xa(%rdi),%ecx
 1503d32:	4d 09 de             	or     %r11,%r14
 1503d35:	41 81 ff ff 00 00 00 	cmp    $0xff,%r15d
 1503d3c:	0f 84 ee fd ff ff    	je     1503b30 <run_backend_benchmark+0x23c0>
 1503d42:	0f b7 57 06          	movzwl 0x6(%rdi),%edx
 1503d46:	49 c1 e7 22          	shl    $0x22,%r15
 1503d4a:	48 c1 e2 3a          	shl    $0x3a,%rdx
 1503d4e:	4c 09 fa             	or     %r15,%rdx
 1503d51:	4c 09 f2             	or     %r14,%rdx
 1503d54:	48 81 ca 00 00 00 20 	or     $0x20000000,%rdx
 1503d5b:	49 89 d6             	mov    %rdx,%r14
 1503d5e:	e9 cd fd ff ff       	jmp    1503b30 <run_backend_benchmark+0x23c0>
 1503d63:	48 be 00 60 00 ff ff ff ff fe 	movabs $0xfeffffffff006000,%rsi
 1503d6d:	48 bf 00 10 00 00 00 00 00 01 	movabs $0x100000000001000,%rdi
 1503d77:	4c 8d 35 1a 88 5b 0d 	lea    0xd5b881a(%rip),%r14        # eabc598 <tier0_slot_words+0x18>
 1503d7e:	49 b9 00 a0 07 00 00 f0 ff 00 	movabs $0xfff0000007a000,%r9
 1503d88:	4c 8d 1d f1 47 5b 0d 	lea    0xd5b47f1(%rip),%r11        # eab8580 <tier0_template_words>
 1503d8f:	31 db                	xor    %ebx,%ebx
 1503d91:	eb 2e                	jmp    1503dc1 <run_backend_benchmark+0x2651>
 1503d93:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1503da0:	48 8b 9c 24 b0 00 00 00 	mov    0xb0(%rsp),%rbx
 1503da8:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
 1503dad:	48 ff c3             	inc    %rbx
 1503db0:	49 81 c6 00 10 00 00 	add    $0x1000,%r14
 1503db7:	48 83 fb 40          	cmp    $0x40,%rbx
 1503dbb:	0f 84 4f 02 00 00    	je     1504010 <run_backend_benchmark+0x28a0>
 1503dc1:	48 89 9c 24 b0 00 00 00 	mov    %rbx,0xb0(%rsp)
 1503dc9:	48 c1 e3 05          	shl    $0x5,%rbx
 1503dcd:	48 8d 0d 7c 38 4f 0d 	lea    0xd4f387c(%rip),%rcx        # e9f7650 <tier0_slot_bases>
 1503dd4:	4c 89 74 24 40       	mov    %r14,0x40(%rsp)
 1503dd9:	45 31 ff             	xor    %r15d,%r15d
 1503ddc:	48 01 cb             	add    %rcx,%rbx
 1503ddf:	eb 1f                	jmp    1503e00 <run_backend_benchmark+0x2690>
 1503de1:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1503df0:	49 ff c7             	inc    %r15
 1503df3:	49 81 c6 00 01 00 00 	add    $0x100,%r14
 1503dfa:	49 83 ff 10          	cmp    $0x10,%r15
 1503dfe:	74 a0                	je     1503da0 <run_backend_benchmark+0x2630>
 1503e00:	42 0f b7 0c 7b       	movzwl (%rbx,%r15,2),%ecx
 1503e05:	45 31 ed             	xor    %r13d,%r13d
 1503e08:	4c 8d 64 48 06       	lea    0x6(%rax,%rcx,2),%r12
 1503e0d:	eb 14                	jmp    1503e23 <run_backend_benchmark+0x26b3>
 1503e0f:	90                   	nop
 1503e10:	b9 00 40 00 00       	mov    $0x4000,%ecx
 1503e15:	4b 89 0c ee          	mov    %rcx,(%r14,%r13,8)
 1503e19:	49 83 c5 04          	add    $0x4,%r13
 1503e1d:	49 83 fd 20          	cmp    $0x20,%r13
 1503e21:	74 cd                	je     1503df0 <run_backend_benchmark+0x2680>
 1503e23:	43 0f b7 54 6c fa    	movzwl -0x6(%r12,%r13,2),%edx
 1503e29:	4c 89 c9             	mov    %r9,%rcx
 1503e2c:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 1503e32:	74 6c                	je     1503ea0 <run_backend_benchmark+0x2730>
 1503e34:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 1503e3a:	75 14                	jne    1503e50 <run_backend_benchmark+0x26e0>
 1503e3c:	b9 00 40 00 00       	mov    $0x4000,%ecx
 1503e41:	eb 5d                	jmp    1503ea0 <run_backend_benchmark+0x2730>
 1503e43:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1503e50:	41 89 d0             	mov    %edx,%r8d
 1503e53:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 1503e59:	89 d1                	mov    %edx,%ecx
 1503e5b:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 1503e5f:	66 45 85 c0          	test   %r8w,%r8w
 1503e63:	79 3b                	jns    1503ea0 <run_backend_benchmark+0x2730>
 1503e65:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 1503e6a:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 1503e6f:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 1503e74:	49 31 c8             	xor    %rcx,%r8
 1503e77:	49 31 ca             	xor    %rcx,%r10
 1503e7a:	48 31 ca             	xor    %rcx,%rdx
 1503e7d:	4d 09 c2             	or     %r8,%r10
 1503e80:	4c 09 d2             	or     %r10,%rdx
 1503e83:	48 85 f2             	test   %rsi,%rdx
 1503e86:	ba 00 10 00 00       	mov    $0x1000,%edx
 1503e8b:	48 0f 44 d7          	cmove  %rdi,%rdx
 1503e8f:	48 09 d1             	or     %rdx,%rcx
 1503e92:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1503ea0:	43 0f b7 54 6c fc    	movzwl -0x4(%r12,%r13,2),%edx
 1503ea6:	4b 89 4c ee e8       	mov    %rcx,-0x18(%r14,%r13,8)
 1503eab:	4c 89 c9             	mov    %r9,%rcx
 1503eae:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 1503eb4:	74 6a                	je     1503f20 <run_backend_benchmark+0x27b0>
 1503eb6:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 1503ebc:	75 12                	jne    1503ed0 <run_backend_benchmark+0x2760>
 1503ebe:	b9 00 40 00 00       	mov    $0x4000,%ecx
 1503ec3:	eb 5b                	jmp    1503f20 <run_backend_benchmark+0x27b0>
 1503ec5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1503ed0:	41 89 d0             	mov    %edx,%r8d
 1503ed3:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 1503ed9:	89 d1                	mov    %edx,%ecx
 1503edb:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 1503edf:	66 45 85 c0          	test   %r8w,%r8w
 1503ee3:	79 3b                	jns    1503f20 <run_backend_benchmark+0x27b0>
 1503ee5:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 1503eea:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 1503eef:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 1503ef4:	49 31 c8             	xor    %rcx,%r8
 1503ef7:	49 31 ca             	xor    %rcx,%r10
 1503efa:	48 31 ca             	xor    %rcx,%rdx
 1503efd:	4d 09 c2             	or     %r8,%r10
 1503f00:	4c 09 d2             	or     %r10,%rdx
 1503f03:	48 85 f2             	test   %rsi,%rdx
 1503f06:	ba 00 10 00 00       	mov    $0x1000,%edx
 1503f0b:	48 0f 44 d7          	cmove  %rdi,%rdx
 1503f0f:	48 09 d1             	or     %rdx,%rcx
 1503f12:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1503f20:	43 0f b7 54 6c fe    	movzwl -0x2(%r12,%r13,2),%edx
 1503f26:	4b 89 4c ee f0       	mov    %rcx,-0x10(%r14,%r13,8)
 1503f2b:	4c 89 c9             	mov    %r9,%rcx
 1503f2e:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 1503f34:	74 6a                	je     1503fa0 <run_backend_benchmark+0x2830>
 1503f36:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 1503f3c:	75 12                	jne    1503f50 <run_backend_benchmark+0x27e0>
 1503f3e:	b9 00 40 00 00       	mov    $0x4000,%ecx
 1503f43:	eb 5b                	jmp    1503fa0 <run_backend_benchmark+0x2830>
 1503f45:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1503f50:	41 89 d0             	mov    %edx,%r8d
 1503f53:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 1503f59:	89 d1                	mov    %edx,%ecx
 1503f5b:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 1503f5f:	66 45 85 c0          	test   %r8w,%r8w
 1503f63:	79 3b                	jns    1503fa0 <run_backend_benchmark+0x2830>
 1503f65:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 1503f6a:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 1503f6f:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 1503f74:	49 31 c8             	xor    %rcx,%r8
 1503f77:	49 31 ca             	xor    %rcx,%r10
 1503f7a:	48 31 ca             	xor    %rcx,%rdx
 1503f7d:	4d 09 c2             	or     %r8,%r10
 1503f80:	4c 09 d2             	or     %r10,%rdx
 1503f83:	48 85 f2             	test   %rsi,%rdx
 1503f86:	ba 00 10 00 00       	mov    $0x1000,%edx
 1503f8b:	48 0f 44 d7          	cmove  %rdi,%rdx
 1503f8f:	48 09 d1             	or     %rdx,%rcx
 1503f92:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1503fa0:	43 0f b7 14 6c       	movzwl (%r12,%r13,2),%edx
 1503fa5:	4b 89 4c ee f8       	mov    %rcx,-0x8(%r14,%r13,8)
 1503faa:	4c 89 c9             	mov    %r9,%rcx
 1503fad:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 1503fb3:	0f 84 5c fe ff ff    	je     1503e15 <run_backend_benchmark+0x26a5>
 1503fb9:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 1503fbf:	0f 84 4b fe ff ff    	je     1503e10 <run_backend_benchmark+0x26a0>
 1503fc5:	41 89 d0             	mov    %edx,%r8d
 1503fc8:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 1503fce:	89 d1                	mov    %edx,%ecx
 1503fd0:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 1503fd4:	66 45 85 c0          	test   %r8w,%r8w
 1503fd8:	0f 89 37 fe ff ff    	jns    1503e15 <run_backend_benchmark+0x26a5>
 1503fde:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 1503fe3:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 1503fe8:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 1503fed:	49 31 c8             	xor    %rcx,%r8
 1503ff0:	49 31 ca             	xor    %rcx,%r10
 1503ff3:	48 31 ca             	xor    %rcx,%rdx
 1503ff6:	4d 09 c2             	or     %r8,%r10
 1503ff9:	4c 09 d2             	or     %r10,%rdx
 1503ffc:	48 85 f2             	test   %rsi,%rdx
 1503fff:	ba 00 10 00 00       	mov    $0x1000,%edx
 1504004:	48 0f 44 d7          	cmove  %rdi,%rdx
 1504008:	48 09 d1             	or     %rdx,%rcx
 150400b:	e9 05 fe ff ff       	jmp    1503e15 <run_backend_benchmark+0x26a5>
 1504010:	f6 44 24 60 01       	testb  $0x1,0x60(%rsp)
 1504015:	0f 84 74 6a 00 00    	je     150aa8f <run_backend_benchmark+0x931f>
 150401b:	c5 f9 6f 05 cd 1a 07 ff 	vmovdqa -0xf8e533(%rip),%xmm0        # 575af0 <x86_effects_unknown+0x90>
 1504023:	62 f2 7d 48 5a 0d 23 1b 07 ff 	vbroadcasti32x4 -0xf8e4dd(%rip),%zmm1        # 575b50 <x86_effects_unknown+0xf0>
 150402d:	62 f2 7d 48 5a 15 29 1b 07 ff 	vbroadcasti32x4 -0xf8e4d7(%rip),%zmm2        # 575b60 <x86_effects_unknown+0x100>
 1504037:	62 f2 7d 48 5a 1d 2f 1b 07 ff 	vbroadcasti32x4 -0xf8e4d1(%rip),%zmm3        # 575b70 <x86_effects_unknown+0x110>
 1504041:	62 f2 7d 48 5a 25 35 1b 07 ff 	vbroadcasti32x4 -0xf8e4cb(%rip),%zmm4        # 575b80 <x86_effects_unknown+0x120>
 150404b:	62 f2 7d 48 5a 2d 3b 1b 07 ff 	vbroadcasti32x4 -0xf8e4c5(%rip),%zmm5        # 575b90 <x86_effects_unknown+0x130>
 1504055:	62 f2 7d 48 5a 35 41 1b 07 ff 	vbroadcasti32x4 -0xf8e4bf(%rip),%zmm6        # 575ba0 <x86_effects_unknown+0x140>
 150405f:	62 f2 7d 48 5a 3d 47 1b 07 ff 	vbroadcasti32x4 -0xf8e4b9(%rip),%zmm7        # 575bb0 <x86_effects_unknown+0x150>
 1504069:	48 b8 00 00 01 00 00 00 00 01 	movabs $0x100000000010000,%rax
 1504073:	c4 e1 fc 46 c8       	kxnorq %k0,%k0,%k1
 1504078:	c4 e1 fc 46 e0       	kxnorq %k0,%k0,%k4
 150407d:	c4 e1 fc 46 e8       	kxnorq %k0,%k0,%k5
 1504082:	48 8d 0d c7 a3 b4 00 	lea    0xb4a3c7(%rip),%rcx        # 204e450 <x86_form_descriptions>
 1504089:	31 d2                	xor    %edx,%edx
 150408b:	c4 e1 fb 92 d0       	kmovq  %rax,%k2
 1504090:	48 b8 01 00 00 00 00 01 00 00 	movabs $0x10000000001,%rax
 150409a:	c4 e1 f8 91 94 24 80 00 00 00 	kmovq  %k2,0x80(%rsp)
 15040a4:	c4 e1 fb 92 d8       	kmovq  %rax,%k3
 15040a9:	c4 e1 fc 46 d0       	kxnorq %k0,%k0,%k2
 15040ae:	66 90                	xchg   %ax,%ax
 15040b0:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 15040b5:	c4 e1 f8 91 8c 24 b0 00 00 00 	kmovq  %k1,0xb0(%rsp)
 15040bf:	c4 e1 f8 90 8c 24 80 00 00 00 	kmovq  0x80(%rsp),%k1
 15040c9:	c4 e1 f8 91 6c 24 30 	kmovq  %k5,0x30(%rsp)
 15040d0:	c4 e1 f8 91 64 24 60 	kmovq  %k4,0x60(%rsp)
 15040d7:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 15040dc:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
 15040e0:	62 71 7f c9 6f 8c d1 5b 00 00 00 	vmovdqu8 0x5b(%rcx,%rdx,8),%zmm9{%k1}{z}
 15040eb:	62 71 7f cb 6f 84 d1 1b 00 00 00 	vmovdqu8 0x1b(%rcx,%rdx,8),%zmm8{%k3}{z}
 15040f6:	62 71 7f c9 6f 94 d1 db 02 00 00 	vmovdqu8 0x2db(%rcx,%rdx,8),%zmm10{%k1}{z}
 1504101:	62 e1 7f c9 6f ac d1 7b 03 00 00 	vmovdqu8 0x37b(%rcx,%rdx,8),%zmm21{%k1}{z}
 150410c:	62 e1 7f c9 6f b4 d1 db 07 00 00 	vmovdqu8 0x7db(%rcx,%rdx,8),%zmm22{%k1}{z}
 1504117:	62 e1 7f cb 6f 9c d1 9b 07 00 00 	vmovdqu8 0x79b(%rcx,%rdx,8),%zmm19{%k3}{z}
 1504122:	62 e1 7f cb 6f a4 d1 3b 03 00 00 	vmovdqu8 0x33b(%rcx,%rdx,8),%zmm20{%k3}{z}
 150412d:	62 61 7f c9 6f 8c d1 1b 04 00 00 	vmovdqu8 0x41b(%rcx,%rdx,8),%zmm25{%k1}{z}
 1504138:	62 61 7f cb 6f 84 d1 db 03 00 00 	vmovdqu8 0x3db(%rcx,%rdx,8),%zmm24{%k3}{z}
 1504143:	62 e1 7f c9 6f 94 d1 bb 04 00 00 	vmovdqu8 0x4bb(%rcx,%rdx,8),%zmm18{%k1}{z}
 150414e:	62 e1 7f cb 6f bc d1 3b 08 00 00 	vmovdqu8 0x83b(%rcx,%rdx,8),%zmm23{%k3}{z}
 1504159:	62 71 7f c9 6f 9c d1 5b 05 00 00 	vmovdqu8 0x55b(%rcx,%rdx,8),%zmm11{%k1}{z}
 1504164:	62 71 7f cb 6f bc d1 1b 05 00 00 	vmovdqu8 0x51b(%rcx,%rdx,8),%zmm15{%k3}{z}
 150416f:	62 e1 7f cb 6f 84 d1 bb 05 00 00 	vmovdqu8 0x5bb(%rcx,%rdx,8),%zmm16{%k3}{z}
 150417a:	62 e1 7f c9 6f 8c d1 fb 05 00 00 	vmovdqu8 0x5fb(%rcx,%rdx,8),%zmm17{%k1}{z}
 1504185:	62 71 7f cb 6f b4 d1 5b 06 00 00 	vmovdqu8 0x65b(%rcx,%rdx,8),%zmm14{%k3}{z}
 1504190:	62 71 7f c9 6f ac d1 9b 06 00 00 	vmovdqu8 0x69b(%rcx,%rdx,8),%zmm13{%k1}{z}
 150419b:	62 71 7f cb 6f a4 d1 fb 06 00 00 	vmovdqu8 0x6fb(%rcx,%rdx,8),%zmm12{%k3}{z}
 15041a6:	62 52 7d 48 7d c1    	vpermt2b %zmm9,%zmm0,%zmm8
 15041ac:	62 71 7f cb 6f 8c d1 9b 02 00 00 	vmovdqu8 0x29b(%rcx,%rdx,8),%zmm9{%k3}{z}
 15041b7:	62 a2 7d 48 7d de    	vpermt2b %zmm22,%zmm0,%zmm19
 15041bd:	62 a3 7d 48 39 ee 03 	vextracti32x4 $0x3,%zmm21,%xmm22
 15041c4:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 15041cb:	62 c1 7d 08 7e e2    	vmovd  %xmm20,%r10d
 15041d1:	62 41 7d 08 7e c7    	vmovd  %xmm24,%r15d
 15041d7:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 15041dd:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 15041e4:	62 52 7d 48 7d fb    	vpermt2b %zmm11,%zmm0,%zmm15
 15041ea:	62 71 7f c9 6f 9c d1 3b 07 00 00 	vmovdqu8 0x73b(%rcx,%rdx,8),%zmm11{%k1}{z}
 15041f5:	c4 63 39 20 84 d1 bb 00 00 00 04 	vpinsrb $0x4,0xbb(%rcx,%rdx,8),%xmm8,%xmm8
 1504200:	62 e3 7d 08 14 f6 08 	vpextrb $0x8,%xmm22,%esi
 1504207:	62 e1 7f c9 6f b4 d1 7b 08 00 00 	vmovdqu8 0x87b(%rcx,%rdx,8),%zmm22{%k1}{z}
 1504212:	62 e1 7d 08 7e ef    	vmovd  %xmm21,%edi
 1504218:	62 a3 7d 48 39 e5 02 	vextracti32x4 $0x2,%zmm20,%xmm21
 150421f:	62 23 7d 48 39 cc 03 	vextracti32x4 $0x3,%zmm25,%xmm20
 1504226:	62 c3 7d 08 14 e9 08 	vpextrb $0x8,%xmm21,%r9d
 150422d:	62 23 7d 28 39 cd 01 	vextracti32x4 $0x1,%ymm25,%xmm21
 1504234:	62 c3 7d 08 14 e0 08 	vpextrb $0x8,%xmm20,%r8d
 150423b:	62 e1 7f cb 6f a4 d1 db 08 00 00 	vmovdqu8 0x8db(%rcx,%rdx,8),%zmm20{%k3}{z}
 1504246:	62 61 7f c9 6f 8c d1 1b 0e 00 00 	vmovdqu8 0xe1b(%rcx,%rdx,8),%zmm25{%k1}{z}
 1504251:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 1504257:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 150425e:	62 83 7d 48 39 d0 03 	vextracti32x4 $0x3,%zmm18,%xmm24
 1504265:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 150426c:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 1504273:	62 e1 7f c9 6f ac d1 1b 09 00 00 	vmovdqu8 0x91b(%rcx,%rdx,8),%zmm21{%k1}{z}
 150427e:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 1504285:	c4 63 39 20 84 d1 e3 00 00 00 05 	vpinsrb $0x5,0xe3(%rcx,%rdx,8),%xmm8,%xmm8
 1504290:	62 c3 65 00 20 dd 04 	vpinsrb $0x4,%r13d,%xmm19,%xmm19
 1504297:	62 c3 7d 08 14 fd 08 	vpextrb $0x8,%xmm23,%r13d
 150429e:	62 e1 7f c9 6f bc d1 bb 09 00 00 	vmovdqu8 0x9bb(%rcx,%rdx,8),%zmm23{%k1}{z}
 15042a9:	62 c3 65 00 20 dd 05 	vpinsrb $0x5,%r13d,%xmm19,%xmm19
 15042b0:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 15042b6:	62 71 7f cb 6f 94 d1 7b 04 00 00 	vmovdqu8 0x47b(%rcx,%rdx,8),%zmm10{%k3}{z}
 15042c1:	c4 63 39 20 84 d1 0b 01 00 00 06 	vpinsrb $0x6,0x10b(%rcx,%rdx,8),%xmm8,%xmm8
 15042cc:	c4 63 39 20 84 d1 33 01 00 00 07 	vpinsrb $0x7,0x133(%rcx,%rdx,8),%xmm8,%xmm8
 15042d7:	c4 43 31 20 ca 04    	vpinsrb $0x4,%r10d,%xmm9,%xmm9
 15042dd:	c4 43 31 20 c9 05    	vpinsrb $0x5,%r9d,%xmm9,%xmm9
 15042e3:	c4 63 31 20 cf 06    	vpinsrb $0x6,%edi,%xmm9,%xmm9
 15042e9:	62 13 7d 48 39 d0 02 	vextracti32x4 $0x2,%zmm10,%xmm24
 15042f0:	c4 63 31 20 ce 07    	vpinsrb $0x7,%esi,%xmm9,%xmm9
 15042f6:	c4 63 39 20 84 d1 5b 01 00 00 08 	vpinsrb $0x8,0x15b(%rcx,%rdx,8),%xmm8,%xmm8
 1504301:	62 43 7d 08 14 c4 08 	vpextrb $0x8,%xmm24,%r12d
 1504308:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 150430f:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 1504316:	c4 43 31 20 cf 08    	vpinsrb $0x8,%r15d,%xmm9,%xmm9
 150431c:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1504323:	62 61 7f cb 6f 84 d1 7b 09 00 00 	vmovdqu8 0x97b(%rcx,%rdx,8),%zmm24{%k3}{z}
 150432e:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 1504334:	62 a3 7d 48 39 e6 02 	vextracti32x4 $0x2,%zmm20,%xmm22
 150433b:	c4 43 31 20 ce 09    	vpinsrb $0x9,%r14d,%xmm9,%xmm9
 1504341:	62 c3 65 00 20 dd 06 	vpinsrb $0x6,%r13d,%xmm19,%xmm19
 1504348:	62 c1 7d 08 7e d5    	vmovd  %xmm18,%r13d
 150434e:	62 a3 7d 48 39 ea 03 	vextracti32x4 $0x3,%zmm21,%xmm18
 1504355:	c4 43 31 20 cb 0a    	vpinsrb $0xa,%r11d,%xmm9,%xmm9
 150435b:	62 e3 65 00 20 d8 07 	vpinsrb $0x7,%eax,%xmm19,%xmm19
 1504362:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 1504368:	62 a3 7d 28 39 ec 01 	vextracti32x4 $0x1,%ymm21,%xmm20
 150436f:	c4 43 31 20 c8 0b    	vpinsrb $0xb,%r8d,%xmm9,%xmm9
 1504375:	c4 63 39 20 84 d1 83 01 00 00 09 	vpinsrb $0x9,0x183(%rcx,%rdx,8),%xmm8,%xmm8
 1504380:	62 e3 65 00 20 d8 08 	vpinsrb $0x8,%eax,%xmm19,%xmm19
 1504387:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 150438e:	62 e1 7f c9 6f b4 d1 7b 0d 00 00 	vmovdqu8 0xd7b(%rcx,%rdx,8),%zmm22{%k1}{z}
 1504399:	62 e3 65 00 20 d8 09 	vpinsrb $0x9,%eax,%xmm19,%xmm19
 15043a0:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 15043a6:	62 a3 7d 48 39 fc 03 	vextracti32x4 $0x3,%zmm23,%xmm20
 15043ad:	62 e3 65 00 20 d8 0a 	vpinsrb $0xa,%eax,%xmm19,%xmm19
 15043b4:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 15043bb:	62 a3 7d 48 39 ca 03 	vextracti32x4 $0x3,%zmm17,%xmm18
 15043c2:	62 a3 7d 28 39 c9 01 	vextracti32x4 $0x1,%ymm17,%xmm17
 15043c9:	62 e3 65 00 20 d8 0b 	vpinsrb $0xb,%eax,%xmm19,%xmm19
 15043d0:	c4 63 39 20 84 d1 ab 01 00 00 0a 	vpinsrb $0xa,0x1ab(%rcx,%rdx,8),%xmm8,%xmm8
 15043db:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 15043e1:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 15043e8:	62 61 7f cb 6f 84 d1 db 0d 00 00 	vmovdqu8 0xddb(%rcx,%rdx,8),%zmm24{%k3}{z}
 15043f3:	62 e3 65 00 20 d8 0c 	vpinsrb $0xc,%eax,%xmm19,%xmm19
 15043fa:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 1504401:	62 a3 7d 28 39 fd 01 	vextracti32x4 $0x1,%ymm23,%xmm21
 1504408:	62 e1 7f c9 6f bc d1 7b 12 00 00 	vmovdqu8 0x127b(%rcx,%rdx,8),%zmm23{%k1}{z}
 1504413:	62 e3 65 00 20 d8 0d 	vpinsrb $0xd,%eax,%xmm19,%xmm19
 150441a:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 1504420:	62 e1 7f cb 6f ac d1 3b 0d 00 00 	vmovdqu8 0xd3b(%rcx,%rdx,8),%zmm21{%k3}{z}
 150442b:	c4 63 39 20 84 d1 d3 01 00 00 0b 	vpinsrb $0xb,0x1d3(%rcx,%rdx,8),%xmm8,%xmm8
 1504436:	62 e3 65 00 20 d8 0e 	vpinsrb $0xe,%eax,%xmm19,%xmm19
 150443d:	62 e3 7d 08 14 e0 08 	vpextrb $0x8,%xmm20,%eax
 1504444:	62 e1 7f cb 6f a4 d1 9b 11 00 00 	vmovdqu8 0x119b(%rcx,%rdx,8),%zmm20{%k3}{z}
 150444f:	62 e3 65 00 20 d8 0f 	vpinsrb $0xf,%eax,%xmm19,%xmm19
 1504456:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 150445c:	62 a3 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm16,%xmm16
 1504463:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 1504469:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 1504470:	62 33 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm14,%xmm16
 1504477:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 150447d:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 1504483:	62 e1 7f cb 6f 8c d1 bb 0f 00 00 	vmovdqu8 0xfbb(%rcx,%rdx,8),%zmm17{%k3}{z}
 150448e:	c4 63 39 20 84 d1 fb 01 00 00 0c 	vpinsrb $0xc,0x1fb(%rcx,%rdx,8),%xmm8,%xmm8
 1504499:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 150449f:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 15044a6:	62 e1 7f c9 6f 94 d1 fb 0f 00 00 	vmovdqu8 0xffb(%rcx,%rdx,8),%zmm18{%k1}{z}
 15044b1:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 15044b7:	c5 79 7e f0          	vmovd  %xmm14,%eax
 15044bb:	62 41 7d 08 7e c7    	vmovd  %xmm24,%r15d
 15044c1:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 15044c7:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 15044ce:	c4 43 7d 39 ef 01    	vextracti128 $0x1,%ymm13,%xmm15
 15044d4:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 15044db:	62 e1 7f cb 6f 84 d1 1b 0f 00 00 	vmovdqu8 0xf1b(%rcx,%rdx,8),%zmm16{%k3}{z}
 15044e6:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 15044ec:	c5 79 7e f8          	vmovd  %xmm15,%eax
 15044f0:	62 53 7d 48 39 e7 02 	vextracti32x4 $0x2,%zmm12,%xmm15
 15044f7:	62 c1 7d 08 7e ea    	vmovd  %xmm21,%r10d
 15044fd:	c4 63 39 20 84 d1 23 02 00 00 0d 	vpinsrb $0xd,0x223(%rcx,%rdx,8),%xmm8,%xmm8
 1504508:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 150450e:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 1504514:	62 53 7d 48 39 dd 03 	vextracti32x4 $0x3,%zmm11,%xmm13
 150451b:	c4 43 7d 39 db 01    	vextracti128 $0x1,%ymm11,%xmm11
 1504521:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 1504527:	c5 79 7e e0          	vmovd  %xmm12,%eax
 150452b:	c4 63 09 20 e0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm12
 1504531:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 1504537:	62 71 7f c9 6f bc d1 db 11 00 00 	vmovdqu8 0x11db(%rcx,%rdx,8),%zmm15{%k1}{z}
 1504542:	62 71 7f cb 6f b4 d1 5b 10 00 00 	vmovdqu8 0x105b(%rcx,%rdx,8),%zmm14{%k3}{z}
 150454d:	c4 63 19 20 e0 0d    	vpinsrb $0xd,%eax,%xmm12,%xmm12
 1504553:	c5 79 7e d8          	vmovd  %xmm11,%eax
 1504557:	c4 63 39 20 84 d1 4b 02 00 00 0e 	vpinsrb $0xe,0x24b(%rcx,%rdx,8),%xmm8,%xmm8
 1504562:	c4 63 19 20 d8 0e    	vpinsrb $0xe,%eax,%xmm12,%xmm11
 1504568:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 150456e:	62 71 7f c9 6f a4 d1 5b 0f 00 00 	vmovdqu8 0xf5b(%rcx,%rdx,8),%zmm12{%k1}{z}
 1504579:	62 71 7f c9 6f ac d1 9b 10 00 00 	vmovdqu8 0x109b(%rcx,%rdx,8),%zmm13{%k1}{z}
 1504584:	c4 63 21 20 d8 0f    	vpinsrb $0xf,%eax,%xmm11,%xmm11
 150458a:	c5 79 7e d0          	vmovd  %xmm10,%eax
 150458e:	c4 63 31 20 c8 0c    	vpinsrb $0xc,%eax,%xmm9,%xmm9
 1504594:	62 33 25 28 38 d3 01 	vinserti32x4 $0x1,%xmm19,%ymm11,%ymm10
 150459b:	62 71 7f c9 6f 9c d1 db 0c 00 00 	vmovdqu8 0xcdb(%rcx,%rdx,8),%zmm11{%k1}{z}
 15045a6:	62 e1 7f c9 6f 9c d1 bb 0e 00 00 	vmovdqu8 0xebb(%rcx,%rdx,8),%zmm19{%k1}{z}
 15045b1:	c4 43 31 20 cc 0d    	vpinsrb $0xd,%r12d,%xmm9,%xmm9
 15045b7:	c4 63 39 20 84 d1 73 02 00 00 0f 	vpinsrb $0xf,0x273(%rcx,%rdx,8),%xmm8,%xmm8
 15045c2:	c4 43 31 20 cd 0e    	vpinsrb $0xe,%r13d,%xmm9,%xmm9
 15045c8:	c4 63 31 20 cb 0f    	vpinsrb $0xf,%ebx,%xmm9,%xmm9
 15045ce:	62 c2 7d 48 7d e7    	vpermt2b %zmm15,%zmm0,%zmm20
 15045d4:	62 c3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm15
 15045db:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 15045e2:	62 e1 7d 08 7e f7    	vmovd  %xmm22,%edi
 15045e8:	62 a3 7d 48 39 ee 02 	vextracti32x4 $0x2,%zmm21,%xmm22
 15045ef:	62 23 7d 48 39 cd 03 	vextracti32x4 $0x3,%zmm25,%xmm21
 15045f6:	c4 63 79 14 fe 08    	vpextrb $0x8,%xmm15,%esi
 15045fc:	62 71 7f c9 6f bc d1 3b 11 00 00 	vmovdqu8 0x113b(%rcx,%rdx,8),%zmm15{%k1}{z}
 1504607:	62 c3 7d 08 14 f1 08 	vpextrb $0x8,%xmm22,%r9d
 150460e:	62 e1 7f cb 6f b4 d1 3b 12 00 00 	vmovdqu8 0x123b(%rcx,%rdx,8),%zmm22{%k3}{z}
 1504619:	62 c3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%r8d
 1504620:	62 23 7d 28 39 cd 01 	vextracti32x4 $0x1,%ymm25,%xmm21
 1504627:	62 c2 7d 48 7d c4    	vpermt2b %zmm12,%zmm0,%zmm16
 150462d:	62 71 7f cb 6f a4 d1 fb 10 00 00 	vmovdqu8 0x10fb(%rcx,%rdx,8),%zmm12{%k3}{z}
 1504638:	62 61 7f cb 6f 8c d1 3b 1c 00 00 	vmovdqu8 0x1c3b(%rcx,%rdx,8),%zmm25{%k3}{z}
 1504643:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 1504649:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 1504650:	62 83 7d 48 39 d8 03 	vextracti32x4 $0x3,%zmm19,%xmm24
 1504657:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 150465e:	62 e1 7f cb 6f ac d1 db 12 00 00 	vmovdqu8 0x12db(%rcx,%rdx,8),%zmm21{%k3}{z}
 1504669:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 1504670:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 1504677:	c4 43 3d 38 c1 01    	vinserti128 $0x1,%xmm9,%ymm8,%ymm8
 150467d:	62 71 7f cb 6f 8c d1 1b 0a 00 00 	vmovdqu8 0xa1b(%rcx,%rdx,8),%zmm9{%k3}{z}
 1504688:	62 53 bd 48 3a c2 01 	vinserti64x4 $0x1,%ymm10,%zmm8,%zmm8
 150468f:	62 71 7f c9 6f 94 d1 5b 0a 00 00 	vmovdqu8 0xa5b(%rcx,%rdx,8),%zmm10{%k1}{z}
 150469a:	62 f1 3d 48 74 c3    	vpcmpeqb %zmm3,%zmm8,%k0
 15046a0:	62 f1 3d 48 74 fc    	vpcmpeqb %zmm4,%zmm8,%k7
 15046a6:	c4 e1 fc 45 f7       	korq   %k7,%k0,%k6
 15046ab:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 15046b1:	62 a3 7d 48 39 f6 02 	vextracti32x4 $0x2,%zmm22,%xmm22
 15046b8:	62 c3 5d 00 20 e5 04 	vpinsrb $0x4,%r13d,%xmm20,%xmm20
 15046bf:	62 c3 7d 08 14 f5 08 	vpextrb $0x8,%xmm22,%r13d
 15046c6:	62 e1 7f cb 6f b4 d1 7b 13 00 00 	vmovdqu8 0x137b(%rcx,%rdx,8),%zmm22{%k3}{z}
 15046d1:	62 c3 5d 00 20 e5 05 	vpinsrb $0x5,%r13d,%xmm20,%xmm20
 15046d8:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 15046de:	62 71 7f cb 6f 94 d1 9b 0c 00 00 	vmovdqu8 0xc9b(%rcx,%rdx,8),%zmm10{%k3}{z}
 15046e9:	c4 63 31 20 8c d1 bb 0a 00 00 04 	vpinsrb $0x4,0xabb(%rcx,%rdx,8),%xmm9,%xmm9
 15046f4:	c4 63 31 20 8c d1 e3 0a 00 00 05 	vpinsrb $0x5,0xae3(%rcx,%rdx,8),%xmm9,%xmm9
 15046ff:	62 52 7d 48 7d d3    	vpermt2b %zmm11,%zmm0,%zmm10
 1504705:	62 71 7f cb 6f 9c d1 7b 0e 00 00 	vmovdqu8 0xe7b(%rcx,%rdx,8),%zmm11{%k3}{z}
 1504710:	c4 63 31 20 8c d1 0b 0b 00 00 06 	vpinsrb $0x6,0xb0b(%rcx,%rdx,8),%xmm9,%xmm9
 150471b:	c4 63 31 20 8c d1 33 0b 00 00 07 	vpinsrb $0x7,0xb33(%rcx,%rdx,8),%xmm9,%xmm9
 1504726:	c4 43 29 20 d2 04    	vpinsrb $0x4,%r10d,%xmm10,%xmm10
 150472c:	c4 43 29 20 d1 05    	vpinsrb $0x5,%r9d,%xmm10,%xmm10
 1504732:	c4 63 29 20 d7 06    	vpinsrb $0x6,%edi,%xmm10,%xmm10
 1504738:	62 13 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm11,%xmm24
 150473f:	c4 63 29 20 d6 07    	vpinsrb $0x7,%esi,%xmm10,%xmm10
 1504745:	c4 63 31 20 8c d1 5b 0b 00 00 08 	vpinsrb $0x8,0xb5b(%rcx,%rdx,8),%xmm9,%xmm9
 1504750:	62 43 7d 08 14 c4 08 	vpextrb $0x8,%xmm24,%r12d
 1504757:	62 83 7d 48 39 f8 03 	vextracti32x4 $0x3,%zmm23,%xmm24
 150475e:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 1504765:	c4 43 29 20 d7 08    	vpinsrb $0x8,%r15d,%xmm10,%xmm10
 150476b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1504772:	62 61 7f c9 6f 84 d1 1b 13 00 00 	vmovdqu8 0x131b(%rcx,%rdx,8),%zmm24{%k1}{z}
 150477d:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 1504783:	62 e1 7f c9 6f bc d1 bb 13 00 00 	vmovdqu8 0x13bb(%rcx,%rdx,8),%zmm23{%k1}{z}
 150478e:	c4 43 29 20 d6 09    	vpinsrb $0x9,%r14d,%xmm10,%xmm10
 1504794:	62 c3 5d 00 20 e5 06 	vpinsrb $0x6,%r13d,%xmm20,%xmm20
 150479b:	62 c1 7d 08 7e dd    	vmovd  %xmm19,%r13d
 15047a1:	c4 43 29 20 d3 0a    	vpinsrb $0xa,%r11d,%xmm10,%xmm10
 15047a7:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 15047ae:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 15047b4:	62 a3 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm21,%xmm21
 15047bb:	c4 43 29 20 d0 0b    	vpinsrb $0xb,%r8d,%xmm10,%xmm10
 15047c1:	c4 63 31 20 8c d1 83 0b 00 00 09 	vpinsrb $0x9,0xb83(%rcx,%rdx,8),%xmm9,%xmm9
 15047cc:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 15047d3:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 15047da:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 15047e1:	c4 63 31 20 8c d1 ab 0b 00 00 0a 	vpinsrb $0xa,0xbab(%rcx,%rdx,8),%xmm9,%xmm9
 15047ec:	62 23 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm24,%xmm21
 15047f3:	62 23 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm24,%xmm19
 15047fa:	62 83 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm22,%xmm24
 1504801:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 1504807:	62 a3 7d 48 39 fd 03 	vextracti32x4 $0x3,%zmm23,%xmm21
 150480e:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 1504815:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 150481c:	62 a3 7d 48 39 d3 03 	vextracti32x4 $0x3,%zmm18,%xmm19
 1504823:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 150482a:	c4 63 31 20 8c d1 d3 0b 00 00 0b 	vpinsrb $0xb,0xbd3(%rcx,%rdx,8),%xmm9,%xmm9
 1504835:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 150483c:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 1504842:	62 a3 7d 28 39 fe 01 	vextracti32x4 $0x1,%ymm23,%xmm22
 1504849:	62 e1 7f cb 6f bc d1 db 17 00 00 	vmovdqu8 0x17db(%rcx,%rdx,8),%zmm23{%k3}{z}
 1504854:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 150485b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1504862:	62 61 7f c9 6f 84 d1 bb 18 00 00 	vmovdqu8 0x18bb(%rcx,%rdx,8),%zmm24{%k1}{z}
 150486d:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 1504874:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 150487a:	62 e1 7f c9 6f b4 d1 1b 18 00 00 	vmovdqu8 0x181b(%rcx,%rdx,8),%zmm22{%k1}{z}
 1504885:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 150488c:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 1504893:	62 e1 7f cb 6f ac d1 3b 17 00 00 	vmovdqu8 0x173b(%rcx,%rdx,8),%zmm21{%k3}{z}
 150489e:	c4 63 31 20 8c d1 fb 0b 00 00 0c 	vpinsrb $0xc,0xbfb(%rcx,%rdx,8),%xmm9,%xmm9
 15048a9:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 15048b0:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 15048b6:	62 a3 7d 48 39 c9 02 	vextracti32x4 $0x2,%zmm17,%xmm17
 15048bd:	62 e3 7d 00 20 c0 04 	vpinsrb $0x4,%eax,%xmm16,%xmm16
 15048c4:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 15048cb:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 15048d2:	62 e3 7d 00 20 c0 05 	vpinsrb $0x5,%eax,%xmm16,%xmm16
 15048d9:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 15048df:	62 e1 7f c9 6f 94 d1 7b 17 00 00 	vmovdqu8 0x177b(%rcx,%rdx,8),%zmm18{%k1}{z}
 15048ea:	62 e3 7d 00 20 c0 06 	vpinsrb $0x6,%eax,%xmm16,%xmm16
 15048f1:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 15048f8:	62 e1 7f c9 6f 9c d1 fb 19 00 00 	vmovdqu8 0x19fb(%rcx,%rdx,8),%zmm19{%k1}{z}
 1504903:	c4 63 31 20 8c d1 23 0c 00 00 0d 	vpinsrb $0xd,0xc23(%rcx,%rdx,8),%xmm9,%xmm9
 150490e:	62 e3 7d 00 20 c0 07 	vpinsrb $0x7,%eax,%xmm16,%xmm16
 1504915:	c5 79 7e f0          	vmovd  %xmm14,%eax
 1504919:	62 c1 7d 08 7e ff    	vmovd  %xmm23,%r15d
 150491f:	62 73 7d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm16,%xmm14
 1504926:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 150492d:	62 33 7d 28 39 e8 01 	vextracti32x4 $0x1,%ymm13,%xmm16
 1504934:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 150493b:	62 e1 7f cb 6f 8c d1 bb 19 00 00 	vmovdqu8 0x19bb(%rcx,%rdx,8),%zmm17{%k3}{z}
 1504946:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 150494c:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 1504952:	62 33 7d 48 39 e0 02 	vextracti32x4 $0x2,%zmm12,%xmm16
 1504959:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 150495f:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 1504965:	62 53 7d 48 39 fd 03 	vextracti32x4 $0x3,%zmm15,%xmm13
 150496c:	62 c1 7d 08 7e ea    	vmovd  %xmm21,%r10d
 1504972:	c4 63 31 20 8c d1 4b 0c 00 00 0e 	vpinsrb $0xe,0xc4b(%rcx,%rdx,8),%xmm9,%xmm9
 150497d:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 1504983:	c5 79 7e e0          	vmovd  %xmm12,%eax
 1504987:	c4 63 09 20 e0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm12
 150498d:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 1504994:	c4 43 7d 39 fe 01    	vextracti128 $0x1,%ymm15,%xmm14
 150499a:	62 e1 7f c9 6f 84 d1 db 1b 00 00 	vmovdqu8 0x1bdb(%rcx,%rdx,8),%zmm16{%k1}{z}
 15049a5:	62 71 7f cb 6f bc d1 1b 19 00 00 	vmovdqu8 0x191b(%rcx,%rdx,8),%zmm15{%k3}{z}
 15049b0:	c4 63 19 20 e0 0d    	vpinsrb $0xd,%eax,%xmm12,%xmm12
 15049b6:	c5 79 7e f0          	vmovd  %xmm14,%eax
 15049ba:	62 71 7f cb 6f b4 d1 5b 1a 00 00 	vmovdqu8 0x1a5b(%rcx,%rdx,8),%zmm14{%k3}{z}
 15049c5:	c4 63 19 20 e0 0e    	vpinsrb $0xe,%eax,%xmm12,%xmm12
 15049cb:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 15049d1:	62 71 7f c9 6f ac d1 5b 19 00 00 	vmovdqu8 0x195b(%rcx,%rdx,8),%zmm13{%k1}{z}
 15049dc:	c4 63 31 20 8c d1 73 0c 00 00 0f 	vpinsrb $0xf,0xc73(%rcx,%rdx,8),%xmm9,%xmm9
 15049e7:	c4 63 19 20 e0 0f    	vpinsrb $0xf,%eax,%xmm12,%xmm12
 15049ed:	c5 79 7e d8          	vmovd  %xmm11,%eax
 15049f1:	c4 63 29 20 d0 0c    	vpinsrb $0xc,%eax,%xmm10,%xmm10
 15049f7:	62 33 1d 28 38 dc 01 	vinserti32x4 $0x1,%xmm20,%ymm12,%ymm11
 15049fe:	62 71 7f c9 6f a4 d1 db 16 00 00 	vmovdqu8 0x16db(%rcx,%rdx,8),%zmm12{%k1}{z}
 1504a09:	62 e1 7f cb 6f a4 d1 9b 1b 00 00 	vmovdqu8 0x1b9b(%rcx,%rdx,8),%zmm20{%k3}{z}
 1504a14:	62 61 7d 08 7e c8    	vmovd  %xmm25,%eax
 1504a1a:	c4 43 29 20 d4 0d    	vpinsrb $0xd,%r12d,%xmm10,%xmm10
 1504a20:	c4 43 29 20 d5 0e    	vpinsrb $0xe,%r13d,%xmm10,%xmm10
 1504a26:	c4 63 29 20 d3 0f    	vpinsrb $0xf,%ebx,%xmm10,%xmm10
 1504a2c:	62 52 7d 48 7d fd    	vpermt2b %zmm13,%zmm0,%zmm15
 1504a32:	62 71 7f c9 6f ac d1 9b 1a 00 00 	vmovdqu8 0x1a9b(%rcx,%rdx,8),%zmm13{%k1}{z}
 1504a3d:	c4 43 35 38 ca 01    	vinserti128 $0x1,%xmm10,%ymm9,%ymm9
 1504a43:	62 71 7f cb 6f 94 d1 1b 14 00 00 	vmovdqu8 0x141b(%rcx,%rdx,8),%zmm10{%k3}{z}
 1504a4e:	62 53 b5 48 3a cb 01 	vinserti64x4 $0x1,%ymm11,%zmm9,%zmm9
 1504a55:	62 71 7f c9 6f 9c d1 5b 14 00 00 	vmovdqu8 0x145b(%rcx,%rdx,8),%zmm11{%k1}{z}
 1504a60:	62 a2 7d 48 7d e0    	vpermt2b %zmm16,%zmm0,%zmm20
 1504a66:	62 a3 7d 48 39 d0 03 	vextracti32x4 $0x3,%zmm18,%xmm16
 1504a6d:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 1504a74:	62 e1 7d 08 7e d7    	vmovd  %xmm18,%edi
 1504a7a:	62 a3 7d 48 39 ea 02 	vextracti32x4 $0x2,%zmm21,%xmm18
 1504a81:	62 a3 7d 48 39 f5 03 	vextracti32x4 $0x3,%zmm22,%xmm21
 1504a88:	62 e3 7d 08 14 c6 08 	vpextrb $0x8,%xmm16,%esi
 1504a8f:	62 e1 7f cb 6f 84 d1 fb 1a 00 00 	vmovdqu8 0x1afb(%rcx,%rdx,8),%zmm16{%k3}{z}
 1504a9a:	62 f1 35 48 74 ee    	vpcmpeqb %zmm6,%zmm9,%k5
 1504aa0:	62 f1 35 48 74 e4    	vpcmpeqb %zmm4,%zmm9,%k4
 1504aa6:	62 c3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%r8d
 1504aad:	62 a3 7d 28 39 f5 01 	vextracti32x4 $0x1,%ymm22,%xmm21
 1504ab4:	62 e1 7f c9 6f b4 d1 7b 1c 00 00 	vmovdqu8 0x1c7b(%rcx,%rdx,8),%zmm22{%k1}{z}
 1504abf:	62 c3 7d 08 14 d1 08 	vpextrb $0x8,%xmm18,%r9d
 1504ac6:	62 e1 7f c9 6f 94 d1 3b 1b 00 00 	vmovdqu8 0x1b3b(%rcx,%rdx,8),%zmm18{%k1}{z}
 1504ad1:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 1504ad7:	62 a3 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm23,%xmm21
 1504ade:	62 e1 7f cb 6f bc d1 db 1c 00 00 	vmovdqu8 0x1cdb(%rcx,%rdx,8),%zmm23{%k3}{z}
 1504ae9:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 1504af0:	62 23 7d 48 39 c5 03 	vextracti32x4 $0x3,%zmm24,%xmm21
 1504af7:	62 e3 7d 08 14 eb 08 	vpextrb $0x8,%xmm21,%ebx
 1504afe:	62 e3 5d 00 20 e0 04 	vpinsrb $0x4,%eax,%xmm20,%xmm20
 1504b05:	62 52 7d 48 7d d3    	vpermt2b %zmm11,%zmm0,%zmm10
 1504b0b:	62 71 7f cb 6f 9c d1 9b 16 00 00 	vmovdqu8 0x169b(%rcx,%rdx,8),%zmm11{%k3}{z}
 1504b16:	c4 63 29 20 94 d1 bb 14 00 00 04 	vpinsrb $0x4,0x14bb(%rcx,%rdx,8),%xmm10,%xmm10
 1504b21:	c4 63 29 20 94 d1 e3 14 00 00 05 	vpinsrb $0x5,0x14e3(%rcx,%rdx,8),%xmm10,%xmm10
 1504b2c:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 1504b32:	62 71 7f cb 6f a4 d1 7b 18 00 00 	vmovdqu8 0x187b(%rcx,%rdx,8),%zmm12{%k3}{z}
 1504b3d:	c4 63 29 20 94 d1 0b 15 00 00 06 	vpinsrb $0x6,0x150b(%rcx,%rdx,8),%xmm10,%xmm10
 1504b48:	c4 63 29 20 94 d1 33 15 00 00 07 	vpinsrb $0x7,0x1533(%rcx,%rdx,8),%xmm10,%xmm10
 1504b53:	c4 43 21 20 da 04    	vpinsrb $0x4,%r10d,%xmm11,%xmm11
 1504b59:	c4 43 21 20 d9 05    	vpinsrb $0x5,%r9d,%xmm11,%xmm11
 1504b5f:	c4 63 21 20 df 06    	vpinsrb $0x6,%edi,%xmm11,%xmm11
 1504b65:	62 33 7d 48 39 e5 02 	vextracti32x4 $0x2,%zmm12,%xmm21
 1504b6c:	c4 63 21 20 de 07    	vpinsrb $0x7,%esi,%xmm11,%xmm11
 1504b72:	c4 63 29 20 94 d1 5b 15 00 00 08 	vpinsrb $0x8,0x155b(%rcx,%rdx,8),%xmm10,%xmm10
 1504b7d:	62 c3 7d 08 14 ec 08 	vpextrb $0x8,%xmm21,%r12d
 1504b84:	62 23 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm24,%xmm21
 1504b8b:	62 03 7d 48 39 c8 02 	vextracti32x4 $0x2,%zmm25,%xmm24
 1504b92:	c4 43 21 20 df 08    	vpinsrb $0x8,%r15d,%xmm11,%xmm11
 1504b98:	62 c1 7d 08 7e ed    	vmovd  %xmm21,%r13d
 1504b9e:	62 e1 7f c9 6f ac d1 1b 1d 00 00 	vmovdqu8 0x1d1b(%rcx,%rdx,8),%zmm21{%k1}{z}
 1504ba9:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1504bb0:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 1504bb7:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 1504bbe:	c4 43 21 20 de 09    	vpinsrb $0x9,%r14d,%xmm11,%xmm11
 1504bc4:	62 e3 5d 00 20 e0 05 	vpinsrb $0x5,%eax,%xmm20,%xmm20
 1504bcb:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1504bd1:	62 61 7f cb 6f 84 d1 7b 1d 00 00 	vmovdqu8 0x1d7b(%rcx,%rdx,8),%zmm24{%k3}{z}
 1504bdc:	c4 43 21 20 db 0a    	vpinsrb $0xa,%r11d,%xmm11,%xmm11
 1504be2:	62 e3 5d 00 20 e0 06 	vpinsrb $0x6,%eax,%xmm20,%xmm20
 1504be9:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 1504bf0:	62 e1 7f c9 6f b4 d1 bb 1d 00 00 	vmovdqu8 0x1dbb(%rcx,%rdx,8),%zmm22{%k1}{z}
 1504bfb:	c4 43 21 20 d8 0b    	vpinsrb $0xb,%r8d,%xmm11,%xmm11
 1504c01:	c4 63 29 20 94 d1 83 15 00 00 09 	vpinsrb $0x9,0x1583(%rcx,%rdx,8),%xmm10,%xmm10
 1504c0c:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 1504c13:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1504c19:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 1504c20:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 1504c27:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1504c2e:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 1504c35:	c4 63 29 20 94 d1 ab 15 00 00 0a 	vpinsrb $0xa,0x15ab(%rcx,%rdx,8),%xmm10,%xmm10
 1504c40:	62 a3 7d 48 39 ef 03 	vextracti32x4 $0x3,%zmm21,%xmm23
 1504c47:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 1504c4e:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 1504c54:	62 a3 7d 48 39 dd 03 	vextracti32x4 $0x3,%zmm19,%xmm21
 1504c5b:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 1504c62:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 1504c69:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1504c70:	62 a3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm23
 1504c77:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 1504c7e:	c4 63 29 20 94 d1 d3 15 00 00 0b 	vpinsrb $0xb,0x15d3(%rcx,%rdx,8),%xmm10,%xmm10
 1504c89:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 1504c90:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1504c96:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 1504c9d:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 1504ca4:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1504cab:	62 61 7f c9 6f 84 d1 1b 22 00 00 	vmovdqu8 0x221b(%rcx,%rdx,8),%zmm24{%k1}{z}
 1504cb6:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 1504cbd:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 1504cc3:	62 e1 7f c9 6f b4 d1 bb 22 00 00 	vmovdqu8 0x22bb(%rcx,%rdx,8),%zmm22{%k1}{z}
 1504cce:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 1504cd5:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1504cdc:	62 e1 7f cb 6f bc d1 db 21 00 00 	vmovdqu8 0x21db(%rcx,%rdx,8),%zmm23{%k3}{z}
 1504ce7:	c4 63 29 20 94 d1 fb 15 00 00 0c 	vpinsrb $0xc,0x15fb(%rcx,%rdx,8),%xmm10,%xmm10
 1504cf2:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 1504cf9:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 1504cff:	62 a3 7d 48 39 c9 02 	vextracti32x4 $0x2,%zmm17,%xmm17
 1504d06:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 1504d0c:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 1504d13:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 1504d1a:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 1504d20:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 1504d26:	62 e1 7f c9 6f 9c d1 7b 21 00 00 	vmovdqu8 0x217b(%rcx,%rdx,8),%zmm19{%k1}{z}
 1504d31:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 1504d37:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 1504d3e:	62 e1 7f cb 6f ac d1 9b 25 00 00 	vmovdqu8 0x259b(%rcx,%rdx,8),%zmm21{%k3}{z}
 1504d49:	c4 63 29 20 94 d1 23 16 00 00 0d 	vpinsrb $0xd,0x1623(%rcx,%rdx,8),%xmm10,%xmm10
 1504d54:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 1504d5a:	c5 79 7e f0          	vmovd  %xmm14,%eax
 1504d5e:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 1504d64:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 1504d6b:	c4 43 7d 39 ef 01    	vextracti128 $0x1,%ymm13,%xmm15
 1504d71:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 1504d78:	62 e1 7f c9 6f 8c d1 db 25 00 00 	vmovdqu8 0x25db(%rcx,%rdx,8),%zmm17{%k1}{z}
 1504d83:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 1504d89:	c5 79 7e f8          	vmovd  %xmm15,%eax
 1504d8d:	62 c3 7d 48 39 c7 02 	vextracti32x4 $0x2,%zmm16,%xmm15
 1504d94:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 1504d9a:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 1504da0:	62 c3 7d 48 39 d5 03 	vextracti32x4 $0x3,%zmm18,%xmm13
 1504da7:	62 c1 7d 08 7e ff    	vmovd  %xmm23,%r15d
 1504dad:	c4 63 29 20 94 d1 4b 16 00 00 0e 	vpinsrb $0xe,0x164b(%rcx,%rdx,8),%xmm10,%xmm10
 1504db8:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 1504dbe:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 1504dc4:	62 e1 7f cb 6f 84 d1 bb 23 00 00 	vmovdqu8 0x23bb(%rcx,%rdx,8),%zmm16{%k3}{z}
 1504dcf:	c4 63 09 20 f0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm14
 1504dd5:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 1504ddb:	62 c3 7d 28 39 d7 01 	vextracti32x4 $0x1,%ymm18,%xmm15
 1504de2:	62 e1 7f c9 6f 94 d1 fb 23 00 00 	vmovdqu8 0x23fb(%rcx,%rdx,8),%zmm18{%k1}{z}
 1504ded:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 1504df3:	c5 79 7e f8          	vmovd  %xmm15,%eax
 1504df7:	62 71 7f cb 6f bc d1 1b 23 00 00 	vmovdqu8 0x231b(%rcx,%rdx,8),%zmm15{%k3}{z}
 1504e02:	c4 63 09 20 f0 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm14
 1504e08:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 1504e0e:	c4 63 29 20 94 d1 73 16 00 00 0f 	vpinsrb $0xf,0x1673(%rcx,%rdx,8),%xmm10,%xmm10
 1504e19:	c4 63 09 20 e8 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm13
 1504e1f:	c5 79 7e e0          	vmovd  %xmm12,%eax
 1504e23:	62 71 7f c9 6f b4 d1 5b 23 00 00 	vmovdqu8 0x235b(%rcx,%rdx,8),%zmm14{%k1}{z}
 1504e2e:	c4 63 21 20 d8 0c    	vpinsrb $0xc,%eax,%xmm11,%xmm11
 1504e34:	62 33 15 28 38 e4 01 	vinserti32x4 $0x1,%xmm20,%ymm13,%ymm12
 1504e3b:	62 e1 7f cb 6f a4 d1 3b 21 00 00 	vmovdqu8 0x213b(%rcx,%rdx,8),%zmm20{%k3}{z}
 1504e46:	62 71 7f c9 6f ac d1 db 20 00 00 	vmovdqu8 0x20db(%rcx,%rdx,8),%zmm13{%k1}{z}
 1504e51:	62 a2 7d 48 7d e9    	vpermt2b %zmm17,%zmm0,%zmm21
 1504e57:	62 a3 7d 48 39 d9 03 	vextracti32x4 $0x3,%zmm19,%xmm17
 1504e5e:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 1504e65:	c4 43 21 20 dc 0d    	vpinsrb $0xd,%r12d,%xmm11,%xmm11
 1504e6b:	62 e1 7d 08 7e df    	vmovd  %xmm19,%edi
 1504e71:	62 e3 7d 08 14 ce 08 	vpextrb $0x8,%xmm17,%esi
 1504e78:	62 e1 7f c9 6f 8c d1 9b 24 00 00 	vmovdqu8 0x249b(%rcx,%rdx,8),%zmm17{%k1}{z}
 1504e83:	c4 43 21 20 dd 0e    	vpinsrb $0xe,%r13d,%xmm11,%xmm11
 1504e89:	c4 63 21 20 db 0f    	vpinsrb $0xf,%ebx,%xmm11,%xmm11
 1504e8f:	c4 43 2d 38 d3 01    	vinserti128 $0x1,%xmm11,%ymm10,%ymm10
 1504e95:	62 71 7f cb 6f 9c d1 1b 1e 00 00 	vmovdqu8 0x1e1b(%rcx,%rdx,8),%zmm11{%k3}{z}
 1504ea0:	62 52 7d 48 7d fe    	vpermt2b %zmm14,%zmm0,%zmm15
 1504ea6:	62 71 7f cb 6f b4 d1 5b 24 00 00 	vmovdqu8 0x245b(%rcx,%rdx,8),%zmm14{%k3}{z}
 1504eb1:	62 53 ad 48 3a d4 01 	vinserti64x4 $0x1,%ymm12,%zmm10,%zmm10
 1504eb8:	62 71 7f c9 6f a4 d1 5b 1e 00 00 	vmovdqu8 0x1e5b(%rcx,%rdx,8),%zmm12{%k1}{z}
 1504ec3:	62 a3 7d 48 39 e3 02 	vextracti32x4 $0x2,%zmm20,%xmm19
 1504eca:	62 c1 7d 08 7e e2    	vmovd  %xmm20,%r10d
 1504ed0:	62 a3 7d 48 39 fc 02 	vextracti32x4 $0x2,%zmm23,%xmm20
 1504ed7:	62 a3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm23
 1504ede:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 1504ee5:	62 c3 7d 08 14 d9 08 	vpextrb $0x8,%xmm19,%r9d
 1504eec:	62 23 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm24,%xmm19
 1504ef3:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 1504efa:	62 c3 7d 08 14 fe 08 	vpextrb $0x8,%xmm23,%r14d
 1504f01:	62 c3 7d 08 14 e3 08 	vpextrb $0x8,%xmm20,%r11d
 1504f08:	62 e1 7f c9 6f a4 d1 3b 25 00 00 	vmovdqu8 0x253b(%rcx,%rdx,8),%zmm20{%k1}{z}
 1504f13:	62 f1 2d 48 74 c4    	vpcmpeqb %zmm4,%zmm10,%k0
 1504f19:	62 61 7d 08 7e c3    	vmovd  %xmm24,%ebx
 1504f1f:	62 61 7f cb 6f 84 d1 3b 26 00 00 	vmovdqu8 0x263b(%rcx,%rdx,8),%zmm24{%k3}{z}
 1504f2a:	62 c3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%r8d
 1504f31:	62 e1 7f cb 6f 9c d1 fb 24 00 00 	vmovdqu8 0x24fb(%rcx,%rdx,8),%zmm19{%k3}{z}
 1504f3c:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 1504f42:	62 71 7f cb 6f a4 d1 9b 20 00 00 	vmovdqu8 0x209b(%rcx,%rdx,8),%zmm12{%k3}{z}
 1504f4d:	c4 63 21 20 9c d1 bb 1e 00 00 04 	vpinsrb $0x4,0x1ebb(%rcx,%rdx,8),%xmm11,%xmm11
 1504f58:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 1504f5e:	62 c3 55 00 20 ed 04 	vpinsrb $0x4,%r13d,%xmm21,%xmm21
 1504f65:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 1504f6b:	c4 63 21 20 9c d1 e3 1e 00 00 05 	vpinsrb $0x5,0x1ee3(%rcx,%rdx,8),%xmm11,%xmm11
 1504f76:	62 52 7d 48 7d e5    	vpermt2b %zmm13,%zmm0,%zmm12
 1504f7c:	62 71 7f cb 6f ac d1 7b 22 00 00 	vmovdqu8 0x227b(%rcx,%rdx,8),%zmm13{%k3}{z}
 1504f87:	c4 63 21 20 9c d1 0b 1f 00 00 06 	vpinsrb $0x6,0x1f0b(%rcx,%rdx,8),%xmm11,%xmm11
 1504f92:	c4 63 21 20 9c d1 33 1f 00 00 07 	vpinsrb $0x7,0x1f33(%rcx,%rdx,8),%xmm11,%xmm11
 1504f9d:	c4 43 19 20 e2 04    	vpinsrb $0x4,%r10d,%xmm12,%xmm12
 1504fa3:	44 0f b6 94 d1 a2 01 00 00 	movzbl 0x1a2(%rcx,%rdx,8),%r10d
 1504fac:	c4 43 19 20 e1 05    	vpinsrb $0x5,%r9d,%xmm12,%xmm12
 1504fb2:	44 0f b6 8c d1 ca 01 00 00 	movzbl 0x1ca(%rcx,%rdx,8),%r9d
 1504fbb:	c4 63 19 20 e7 06    	vpinsrb $0x6,%edi,%xmm12,%xmm12
 1504fc1:	0f b6 bc d1 1a 02 00 00 	movzbl 0x21a(%rcx,%rdx,8),%edi
 1504fc9:	62 33 7d 48 39 ef 02 	vextracti32x4 $0x2,%zmm13,%xmm23
 1504fd0:	c4 63 19 20 e6 07    	vpinsrb $0x7,%esi,%xmm12,%xmm12
 1504fd6:	0f b6 b4 d1 42 02 00 00 	movzbl 0x242(%rcx,%rdx,8),%esi
 1504fde:	62 c3 7d 08 14 fc 08 	vpextrb $0x8,%xmm23,%r12d
 1504fe5:	62 23 7d 48 39 c7 02 	vextracti32x4 $0x2,%zmm24,%xmm23
 1504fec:	62 61 7f cb 6f 84 d1 db 26 00 00 	vmovdqu8 0x26db(%rcx,%rdx,8),%zmm24{%k3}{z}
 1504ff7:	c4 63 21 20 9c d1 5b 1f 00 00 08 	vpinsrb $0x8,0x1f5b(%rcx,%rdx,8),%xmm11,%xmm11
 1505002:	c4 43 19 20 e7 08    	vpinsrb $0x8,%r15d,%xmm12,%xmm12
 1505008:	44 0f b6 bc d1 02 01 00 00 	movzbl 0x102(%rcx,%rdx,8),%r15d
 1505011:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505018:	62 e1 7f c9 6f bc d1 7b 26 00 00 	vmovdqu8 0x267b(%rcx,%rdx,8),%zmm23{%k1}{z}
 1505023:	c4 43 19 20 e3 09    	vpinsrb $0x9,%r11d,%xmm12,%xmm12
 1505029:	44 0f b6 9c d1 7a 01 00 00 	movzbl 0x17a(%rcx,%rdx,8),%r11d
 1505032:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 1505039:	c4 63 19 20 e3 0a    	vpinsrb $0xa,%ebx,%xmm12,%xmm12
 150503f:	0f b6 9c d1 52 01 00 00 	movzbl 0x152(%rcx,%rdx,8),%ebx
 1505047:	c4 43 19 20 e0 0b    	vpinsrb $0xb,%r8d,%xmm12,%xmm12
 150504d:	44 0f b6 84 d1 f2 01 00 00 	movzbl 0x1f2(%rcx,%rdx,8),%r8d
 1505056:	c4 63 21 20 9c d1 83 1f 00 00 09 	vpinsrb $0x9,0x1f83(%rcx,%rdx,8),%xmm11,%xmm11
 1505061:	c4 63 21 20 9c d1 ab 1f 00 00 0a 	vpinsrb $0xa,0x1fab(%rcx,%rdx,8),%xmm11,%xmm11
 150506c:	62 a3 7d 28 39 fe 01 	vextracti32x4 $0x1,%ymm23,%xmm22
 1505073:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 150507a:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 1505080:	62 e1 7f c9 6f b4 d1 1b 27 00 00 	vmovdqu8 0x271b(%rcx,%rdx,8),%zmm22{%k1}{z}
 150508b:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 1505092:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505099:	62 e1 7f cb 6f bc d1 7b 27 00 00 	vmovdqu8 0x277b(%rcx,%rdx,8),%zmm23{%k3}{z}
 15050a4:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 15050ab:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 15050b1:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 15050b8:	c4 63 21 20 9c d1 d3 1f 00 00 0b 	vpinsrb $0xb,0x1fd3(%rcx,%rdx,8),%xmm11,%xmm11
 15050c3:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 15050ca:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 15050d1:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 15050d8:	c4 63 21 20 9c d1 fb 1f 00 00 0c 	vpinsrb $0xc,0x1ffb(%rcx,%rdx,8),%xmm11,%xmm11
 15050e3:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 15050ea:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 15050f1:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 15050f7:	62 61 7f c9 6f 84 d1 bb 27 00 00 	vmovdqu8 0x27bb(%rcx,%rdx,8),%zmm24{%k1}{z}
 1505102:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 1505109:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 1505110:	62 a3 7d 48 39 d6 03 	vextracti32x4 $0x3,%zmm18,%xmm22
 1505117:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 150511e:	c4 63 21 20 9c d1 23 20 00 00 0d 	vpinsrb $0xd,0x2023(%rcx,%rdx,8),%xmm11,%xmm11
 1505129:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 1505130:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505136:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 150513d:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 1505144:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 150514b:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 1505152:	c4 63 21 20 9c d1 4b 20 00 00 0e 	vpinsrb $0xe,0x204b(%rcx,%rdx,8),%xmm11,%xmm11
 150515d:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 1505164:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 150516b:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505171:	62 61 7f cb 6f 84 d1 32 08 00 00 	vmovdqu8 0x832(%rcx,%rdx,8),%zmm24{%k3}{z}
 150517c:	c4 63 21 20 9c d1 73 20 00 00 0f 	vpinsrb $0xf,0x2073(%rcx,%rdx,8),%xmm11,%xmm11
 1505187:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 150518e:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505195:	62 e1 7f cb 6f bc d1 92 07 00 00 	vmovdqu8 0x792(%rcx,%rdx,8),%zmm23{%k3}{z}
 15051a0:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 15051a7:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 15051ad:	62 a3 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm16,%xmm16
 15051b4:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 15051ba:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 15051c1:	62 33 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm14,%xmm16
 15051c8:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 15051ce:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 15051d4:	62 e1 7f cb 6f 94 d1 32 03 00 00 	vmovdqu8 0x332(%rcx,%rdx,8),%zmm18{%k3}{z}
 15051df:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 15051e5:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 15051ec:	62 e1 7f c9 6f b4 d1 d2 07 00 00 	vmovdqu8 0x7d2(%rcx,%rdx,8),%zmm22{%k1}{z}
 15051f7:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 15051fd:	c5 79 7e f0          	vmovd  %xmm14,%eax
 1505201:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 1505207:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 150520e:	62 c3 7d 28 39 cf 01 	vextracti32x4 $0x1,%ymm17,%xmm15
 1505215:	62 a3 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm19,%xmm16
 150521c:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 1505222:	c5 79 7e f8          	vmovd  %xmm15,%eax
 1505226:	62 c3 7d 48 39 cf 03 	vextracti32x4 $0x3,%zmm17,%xmm15
 150522d:	62 e1 7f cb 6f 8c d1 92 02 00 00 	vmovdqu8 0x292(%rcx,%rdx,8),%zmm17{%k3}{z}
 1505238:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 150523e:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 1505244:	62 c3 7d 48 39 e7 03 	vextracti32x4 $0x3,%zmm20,%xmm15
 150524b:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 1505251:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 1505257:	62 e1 7f c9 6f 9c d1 72 03 00 00 	vmovdqu8 0x372(%rcx,%rdx,8),%zmm19{%k1}{z}
 1505262:	c4 63 09 20 f0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm14
 1505268:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 150526f:	62 a3 7d 28 39 e0 01 	vextracti32x4 $0x1,%ymm20,%xmm16
 1505276:	62 e1 7f cb 6f a4 d1 12 05 00 00 	vmovdqu8 0x512(%rcx,%rdx,8),%zmm20{%k3}{z}
 1505281:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 1505287:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 150528d:	62 e1 7f cb 6f 84 d1 d2 03 00 00 	vmovdqu8 0x3d2(%rcx,%rdx,8),%zmm16{%k3}{z}
 1505298:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 150529e:	62 e1 7f c9 6f b4 d1 72 08 00 00 	vmovdqu8 0x872(%rcx,%rdx,8),%zmm22{%k1}{z}
 15052a9:	c4 63 09 20 f0 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm14
 15052af:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 15052b5:	62 71 7f c9 6f bc d1 12 04 00 00 	vmovdqu8 0x412(%rcx,%rdx,8),%zmm15{%k1}{z}
 15052c0:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 15052c6:	c5 79 7e e8          	vmovd  %xmm13,%eax
 15052ca:	c4 63 19 20 e0 0c    	vpinsrb $0xc,%eax,%xmm12,%xmm12
 15052d0:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 15052d6:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 15052dd:	62 33 0d 28 38 ed 01 	vinserti32x4 $0x1,%xmm21,%ymm14,%ymm13
 15052e4:	62 e1 7f c9 6f ac d1 52 05 00 00 	vmovdqu8 0x552(%rcx,%rdx,8),%zmm21{%k1}{z}
 15052ef:	62 71 7f cb 6f b4 d1 72 04 00 00 	vmovdqu8 0x472(%rcx,%rdx,8),%zmm14{%k3}{z}
 15052fa:	c4 43 19 20 e4 0d    	vpinsrb $0xd,%r12d,%xmm12,%xmm12
 1505300:	44 0f b6 a4 d1 da 00 00 00 	movzbl 0xda(%rcx,%rdx,8),%r12d
 1505309:	c4 43 19 20 e5 0e    	vpinsrb $0xe,%r13d,%xmm12,%xmm12
 150530f:	44 0f b6 ac d1 b2 00 00 00 	movzbl 0xb2(%rcx,%rdx,8),%r13d
 1505318:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 150531f:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505326:	c4 43 19 20 e6 0f    	vpinsrb $0xf,%r14d,%xmm12,%xmm12
 150532c:	44 0f b6 b4 d1 2a 01 00 00 	movzbl 0x12a(%rcx,%rdx,8),%r14d
 1505335:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 150533c:	c4 43 25 38 dc 01    	vinserti128 $0x1,%xmm12,%ymm11,%ymm11
 1505342:	62 71 7f cb 6f a4 d1 12 00 00 00 	vmovdqu8 0x12(%rcx,%rdx,8),%zmm12{%k3}{z}
 150534d:	62 53 a5 48 3a dd 01 	vinserti64x4 $0x1,%ymm13,%zmm11,%zmm11
 1505354:	62 71 7f c9 6f ac d1 52 00 00 00 	vmovdqu8 0x52(%rcx,%rdx,8),%zmm13{%k1}{z}
 150535f:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 1505366:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 150536d:	62 f1 25 48 74 fb    	vpcmpeqb %zmm3,%zmm11,%k7
 1505373:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505379:	62 61 7f cb 6f 84 d1 d2 08 00 00 	vmovdqu8 0x8d2(%rcx,%rdx,8),%zmm24{%k3}{z}
 1505384:	62 e3 45 00 20 f8 06 	vpinsrb $0x6,%eax,%xmm23,%xmm23
 150538b:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 1505392:	62 e1 7f c9 6f b4 d1 12 09 00 00 	vmovdqu8 0x912(%rcx,%rdx,8),%zmm22{%k1}{z}
 150539d:	62 a2 7d 48 7d e5    	vpermt2b %zmm21,%zmm0,%zmm20
 15053a3:	62 e1 7f cb 6f ac d1 b2 05 00 00 	vmovdqu8 0x5b2(%rcx,%rdx,8),%zmm21{%k3}{z}
 15053ae:	62 e3 45 00 20 f8 07 	vpinsrb $0x7,%eax,%xmm23,%xmm23
 15053b5:	62 52 7d 48 7d e5    	vpermt2b %zmm13,%zmm0,%zmm12
 15053bb:	62 71 7f c9 6f ac d1 d2 02 00 00 	vmovdqu8 0x2d2(%rcx,%rdx,8),%zmm13{%k1}{z}
 15053c6:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 15053cc:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 15053d3:	62 e3 45 00 20 f8 08 	vpinsrb $0x8,%eax,%xmm23,%xmm23
 15053da:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 15053e1:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 15053e8:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 15053ef:	62 e3 45 00 20 f8 09 	vpinsrb $0x9,%eax,%xmm23,%xmm23
 15053f6:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 15053fc:	62 61 7f cb 6f 84 d1 72 09 00 00 	vmovdqu8 0x972(%rcx,%rdx,8),%zmm24{%k3}{z}
 1505407:	62 e3 45 00 20 f8 0a 	vpinsrb $0xa,%eax,%xmm23,%xmm23
 150540e:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 1505415:	62 e1 7f c9 6f b4 d1 b2 09 00 00 	vmovdqu8 0x9b2(%rcx,%rdx,8),%zmm22{%k1}{z}
 1505420:	c4 43 19 20 e5 04    	vpinsrb $0x4,%r13d,%xmm12,%xmm12
 1505426:	44 0f b6 ac d1 b2 0a 00 00 	movzbl 0xab2(%rcx,%rdx,8),%r13d
 150542f:	62 e3 45 00 20 f8 0b 	vpinsrb $0xb,%eax,%xmm23,%xmm23
 1505436:	c4 43 19 20 e4 05    	vpinsrb $0x5,%r12d,%xmm12,%xmm12
 150543c:	44 0f b6 a4 d1 da 0a 00 00 	movzbl 0xada(%rcx,%rdx,8),%r12d
 1505445:	c4 43 19 20 e7 06    	vpinsrb $0x6,%r15d,%xmm12,%xmm12
 150544b:	44 0f b6 bc d1 02 0b 00 00 	movzbl 0xb02(%rcx,%rdx,8),%r15d
 1505454:	62 c2 7d 48 7d cd    	vpermt2b %zmm13,%zmm0,%zmm17
 150545a:	62 71 7f c9 6f ac d1 b2 04 00 00 	vmovdqu8 0x4b2(%rcx,%rdx,8),%zmm13{%k1}{z}
 1505465:	c4 43 19 20 e6 07    	vpinsrb $0x7,%r14d,%xmm12,%xmm12
 150546b:	44 0f b6 b4 d1 2a 0b 00 00 	movzbl 0xb2a(%rcx,%rdx,8),%r14d
 1505474:	c4 63 19 20 e3 08    	vpinsrb $0x8,%ebx,%xmm12,%xmm12
 150547a:	0f b6 9c d1 52 0b 00 00 	movzbl 0xb52(%rcx,%rdx,8),%ebx
 1505482:	c4 43 19 20 e3 09    	vpinsrb $0x9,%r11d,%xmm12,%xmm12
 1505488:	44 0f b6 9c d1 7a 0b 00 00 	movzbl 0xb7a(%rcx,%rdx,8),%r11d
 1505491:	c4 43 19 20 e2 0a    	vpinsrb $0xa,%r10d,%xmm12,%xmm12
 1505497:	44 0f b6 94 d1 a2 0b 00 00 	movzbl 0xba2(%rcx,%rdx,8),%r10d
 15054a0:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 15054a6:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 15054ad:	c4 43 19 20 e1 0b    	vpinsrb $0xb,%r9d,%xmm12,%xmm12
 15054b3:	44 0f b6 8c d1 ca 0b 00 00 	movzbl 0xbca(%rcx,%rdx,8),%r9d
 15054bc:	62 e3 45 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm23,%xmm23
 15054c3:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 15054ca:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 15054d1:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 15054d8:	c4 43 19 20 e0 0c    	vpinsrb $0xc,%r8d,%xmm12,%xmm12
 15054de:	44 0f b6 84 d1 f2 0b 00 00 	movzbl 0xbf2(%rcx,%rdx,8),%r8d
 15054e7:	62 e3 45 00 20 f8 0d 	vpinsrb $0xd,%eax,%xmm23,%xmm23
 15054ee:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 15054f4:	62 61 7f c9 6f 84 d1 f2 05 00 00 	vmovdqu8 0x5f2(%rcx,%rdx,8),%zmm24{%k1}{z}
 15054ff:	c4 63 19 20 e7 0d    	vpinsrb $0xd,%edi,%xmm12,%xmm12
 1505505:	0f b6 bc d1 1a 0c 00 00 	movzbl 0xc1a(%rcx,%rdx,8),%edi
 150550d:	62 e3 45 00 20 f8 0e 	vpinsrb $0xe,%eax,%xmm23,%xmm23
 1505514:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 150551b:	c4 63 19 20 e6 0e    	vpinsrb $0xe,%esi,%xmm12,%xmm12
 1505521:	0f b6 b4 d1 42 0c 00 00 	movzbl 0xc42(%rcx,%rdx,8),%esi
 1505529:	62 e3 45 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm23,%xmm22
 1505530:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 1505536:	62 a3 7d 48 39 ef 02 	vextracti32x4 $0x2,%zmm21,%xmm23
 150553d:	62 e1 7f cb 6f ac d1 52 06 00 00 	vmovdqu8 0x652(%rcx,%rdx,8),%zmm21{%k3}{z}
 1505548:	62 e3 5d 00 20 e0 04 	vpinsrb $0x4,%eax,%xmm20,%xmm20
 150554f:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505556:	62 e3 5d 00 20 e0 05 	vpinsrb $0x5,%eax,%xmm20,%xmm20
 150555d:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 1505564:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 150556b:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505571:	62 e1 7f c9 6f bc d1 92 06 00 00 	vmovdqu8 0x692(%rcx,%rdx,8),%zmm23{%k1}{z}
 150557c:	62 e3 5d 00 20 e0 06 	vpinsrb $0x6,%eax,%xmm20,%xmm20
 1505583:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 150558a:	62 61 7f cb 6f 84 d1 f2 06 00 00 	vmovdqu8 0x6f2(%rcx,%rdx,8),%zmm24{%k3}{z}
 1505595:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 150559c:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 15055a2:	62 a3 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm21,%xmm21
 15055a9:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 15055b0:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 15055b7:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 15055be:	62 a3 7d 28 39 fd 01 	vextracti32x4 $0x1,%ymm23,%xmm21
 15055c5:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 15055cc:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 15055d2:	62 e1 7f c9 6f ac d1 32 07 00 00 	vmovdqu8 0x732(%rcx,%rdx,8),%zmm21{%k1}{z}
 15055dd:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 15055e4:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 15055eb:	62 a3 7d 48 39 df 03 	vextracti32x4 $0x3,%zmm19,%xmm23
 15055f2:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 15055f9:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 1505600:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505606:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 150560d:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 1505614:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 150561b:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 1505622:	62 83 7d 48 39 e8 03 	vextracti32x4 $0x3,%zmm21,%xmm24
 1505629:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 1505630:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 1505636:	62 e1 7f cb 6f ac d1 12 0f 00 00 	vmovdqu8 0xf12(%rcx,%rdx,8),%zmm21{%k3}{z}
 1505641:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 1505648:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 150564f:	62 61 7f cb 6f 84 d1 32 12 00 00 	vmovdqu8 0x1232(%rcx,%rdx,8),%zmm24{%k3}{z}
 150565a:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 1505661:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 1505667:	62 a3 7d 48 39 d2 02 	vextracti32x4 $0x2,%zmm18,%xmm18
 150566e:	62 e3 75 00 20 c8 04 	vpinsrb $0x4,%eax,%xmm17,%xmm17
 1505675:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 150567c:	62 a3 7d 48 39 c2 02 	vextracti32x4 $0x2,%zmm16,%xmm18
 1505683:	62 e3 75 00 20 c8 05 	vpinsrb $0x5,%eax,%xmm17,%xmm17
 150568a:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 1505690:	62 e1 7f cb 6f 9c d1 32 0d 00 00 	vmovdqu8 0xd32(%rcx,%rdx,8),%zmm19{%k3}{z}
 150569b:	62 e3 75 00 20 c8 06 	vpinsrb $0x6,%eax,%xmm17,%xmm17
 15056a2:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 15056a9:	62 e1 7f cb 6f bc d1 92 11 00 00 	vmovdqu8 0x1192(%rcx,%rdx,8),%zmm23{%k3}{z}
 15056b4:	62 e3 75 00 20 c8 07 	vpinsrb $0x7,%eax,%xmm17,%xmm17
 15056bb:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 15056c1:	62 e3 75 00 20 c0 08 	vpinsrb $0x8,%eax,%xmm17,%xmm16
 15056c8:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 15056cf:	62 33 7d 28 39 f9 01 	vextracti32x4 $0x1,%ymm15,%xmm17
 15056d6:	62 53 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm15,%xmm15
 15056dd:	62 e1 7f cb 6f 94 d1 92 0c 00 00 	vmovdqu8 0xc92(%rcx,%rdx,8),%zmm18{%k3}{z}
 15056e8:	62 e3 7d 00 20 c0 09 	vpinsrb $0x9,%eax,%xmm16,%xmm16
 15056ef:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 15056f5:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 15056fc:	62 e3 7d 00 20 c0 0a 	vpinsrb $0xa,%eax,%xmm16,%xmm16
 1505703:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 1505709:	62 53 7d 48 39 ef 03 	vextracti32x4 $0x3,%zmm13,%xmm15
 1505710:	c4 43 7d 39 ed 01    	vextracti128 $0x1,%ymm13,%xmm13
 1505716:	62 e3 7d 00 20 c0 0b 	vpinsrb $0xb,%eax,%xmm16,%xmm16
 150571d:	c5 79 7e f0          	vmovd  %xmm14,%eax
 1505721:	62 73 7d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm16,%xmm14
 1505728:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 150572f:	62 e1 7f cb 6f 8c d1 d2 0d 00 00 	vmovdqu8 0xdd2(%rcx,%rdx,8),%zmm17{%k3}{z}
 150573a:	62 e1 7f c9 6f 84 d1 12 0e 00 00 	vmovdqu8 0xe12(%rcx,%rdx,8),%zmm16{%k1}{z}
 1505745:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 150574b:	c5 79 7e e8          	vmovd  %xmm13,%eax
 150574f:	c4 63 09 20 e8 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm13
 1505755:	62 33 5d 20 38 f6 01 	vinserti32x4 $0x1,%xmm22,%ymm20,%ymm14
 150575c:	62 e1 7f c9 6f b4 d1 52 0f 00 00 	vmovdqu8 0xf52(%rcx,%rdx,8),%zmm22{%k1}{z}
 1505767:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 150576d:	62 e1 7f c9 6f a4 d1 72 0d 00 00 	vmovdqu8 0xd72(%rcx,%rdx,8),%zmm20{%k1}{z}
 1505778:	62 71 7f cb 6f bc d1 72 0e 00 00 	vmovdqu8 0xe72(%rcx,%rdx,8),%zmm15{%k3}{z}
 1505783:	c4 63 11 20 e8 0f    	vpinsrb $0xf,%eax,%xmm13,%xmm13
 1505789:	0f b6 84 d1 6a 02 00 00 	movzbl 0x26a(%rcx,%rdx,8),%eax
 1505791:	c4 63 19 20 e0 0f    	vpinsrb $0xf,%eax,%xmm12,%xmm12
 1505797:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 150579d:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 15057a4:	c4 43 1d 38 e5 01    	vinserti128 $0x1,%xmm13,%ymm12,%ymm12
 15057aa:	62 71 7f cb 6f ac d1 12 0a 00 00 	vmovdqu8 0xa12(%rcx,%rdx,8),%zmm13{%k3}{z}
 15057b5:	62 a2 7d 48 7d ee    	vpermt2b %zmm22,%zmm0,%zmm21
 15057bb:	62 e1 7f c9 6f b4 d1 d2 11 00 00 	vmovdqu8 0x11d2(%rcx,%rdx,8),%zmm22{%k1}{z}
 15057c6:	62 53 9d 48 3a e6 01 	vinserti64x4 $0x1,%ymm14,%zmm12,%zmm12
 15057cd:	62 71 7f c9 6f b4 d1 52 0a 00 00 	vmovdqu8 0xa52(%rcx,%rdx,8),%zmm14{%k1}{z}
 15057d8:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 15057de:	62 e1 7f c9 6f b4 d1 72 12 00 00 	vmovdqu8 0x1272(%rcx,%rdx,8),%zmm22{%k1}{z}
 15057e9:	62 52 7d 48 7d ee    	vpermt2b %zmm14,%zmm0,%zmm13
 15057ef:	62 71 7f c9 6f b4 d1 d2 0c 00 00 	vmovdqu8 0xcd2(%rcx,%rdx,8),%zmm14{%k1}{z}
 15057fa:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 1505801:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505808:	c4 43 11 20 ed 04    	vpinsrb $0x4,%r13d,%xmm13,%xmm13
 150580e:	44 0f b6 ac d1 b2 14 00 00 	movzbl 0x14b2(%rcx,%rdx,8),%r13d
 1505817:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 150581e:	c4 43 11 20 ec 05    	vpinsrb $0x5,%r12d,%xmm13,%xmm13
 1505824:	44 0f b6 a4 d1 da 14 00 00 	movzbl 0x14da(%rcx,%rdx,8),%r12d
 150582d:	c4 43 11 20 ef 06    	vpinsrb $0x6,%r15d,%xmm13,%xmm13
 1505833:	44 0f b6 bc d1 02 15 00 00 	movzbl 0x1502(%rcx,%rdx,8),%r15d
 150583c:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 1505843:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 150584a:	62 c2 7d 48 7d d6    	vpermt2b %zmm14,%zmm0,%zmm18
 1505850:	62 71 7f c9 6f b4 d1 b2 0e 00 00 	vmovdqu8 0xeb2(%rcx,%rdx,8),%zmm14{%k1}{z}
 150585b:	c4 43 11 20 ee 07    	vpinsrb $0x7,%r14d,%xmm13,%xmm13
 1505861:	44 0f b6 b4 d1 2a 15 00 00 	movzbl 0x152a(%rcx,%rdx,8),%r14d
 150586a:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 1505870:	c4 63 11 20 eb 08    	vpinsrb $0x8,%ebx,%xmm13,%xmm13
 1505876:	0f b6 9c d1 52 15 00 00 	movzbl 0x1552(%rcx,%rdx,8),%ebx
 150587e:	62 e3 45 00 20 f0 06 	vpinsrb $0x6,%eax,%xmm23,%xmm22
 1505885:	62 e1 7f cb 6f bc d1 d2 12 00 00 	vmovdqu8 0x12d2(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505890:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505897:	62 61 7f c9 6f 84 d1 12 13 00 00 	vmovdqu8 0x1312(%rcx,%rdx,8),%zmm24{%k1}{z}
 15058a2:	c4 43 11 20 eb 09    	vpinsrb $0x9,%r11d,%xmm13,%xmm13
 15058a8:	44 0f b6 9c d1 7a 15 00 00 	movzbl 0x157a(%rcx,%rdx,8),%r11d
 15058b1:	62 e3 4d 00 20 f0 07 	vpinsrb $0x7,%eax,%xmm22,%xmm22
 15058b8:	c4 43 11 20 ea 0a    	vpinsrb $0xa,%r10d,%xmm13,%xmm13
 15058be:	44 0f b6 94 d1 a2 15 00 00 	movzbl 0x15a2(%rcx,%rdx,8),%r10d
 15058c7:	c4 43 11 20 e9 0b    	vpinsrb $0xb,%r9d,%xmm13,%xmm13
 15058cd:	44 0f b6 8c d1 ca 15 00 00 	movzbl 0x15ca(%rcx,%rdx,8),%r9d
 15058d6:	c4 43 11 20 e8 0c    	vpinsrb $0xc,%r8d,%xmm13,%xmm13
 15058dc:	44 0f b6 84 d1 f2 15 00 00 	movzbl 0x15f2(%rcx,%rdx,8),%r8d
 15058e5:	c4 63 11 20 ef 0d    	vpinsrb $0xd,%edi,%xmm13,%xmm13
 15058eb:	0f b6 bc d1 1a 16 00 00 	movzbl 0x161a(%rcx,%rdx,8),%edi
 15058f3:	c4 63 11 20 ee 0e    	vpinsrb $0xe,%esi,%xmm13,%xmm13
 15058f9:	0f b6 b4 d1 42 16 00 00 	movzbl 0x1642(%rcx,%rdx,8),%esi
 1505901:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505907:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 150590e:	62 e3 4d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm22,%xmm22
 1505915:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 150591c:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 1505923:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 150592a:	62 e3 4d 00 20 f0 09 	vpinsrb $0x9,%eax,%xmm22,%xmm22
 1505931:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505937:	62 e1 7f cb 6f bc d1 72 13 00 00 	vmovdqu8 0x1372(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505942:	62 e3 4d 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm22,%xmm22
 1505949:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505950:	62 61 7f c9 6f 84 d1 b2 13 00 00 	vmovdqu8 0x13b2(%rcx,%rdx,8),%zmm24{%k1}{z}
 150595b:	62 e3 4d 00 20 f0 0b 	vpinsrb $0xb,%eax,%xmm22,%xmm22
 1505962:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505968:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 150596f:	62 e3 4d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm22,%xmm22
 1505976:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 150597d:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 1505984:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 150598b:	62 e3 4d 00 20 f0 0d 	vpinsrb $0xd,%eax,%xmm22,%xmm22
 1505992:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505998:	62 e1 7f cb 6f bc d1 b2 0f 00 00 	vmovdqu8 0xfb2(%rcx,%rdx,8),%zmm23{%k3}{z}
 15059a3:	62 e3 4d 00 20 f0 0e 	vpinsrb $0xe,%eax,%xmm22,%xmm22
 15059aa:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 15059b1:	62 61 7f c9 6f 84 d1 f2 0f 00 00 	vmovdqu8 0xff2(%rcx,%rdx,8),%zmm24{%k1}{z}
 15059bc:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 15059c3:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 15059c9:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 15059d0:	62 e3 55 00 20 e8 04 	vpinsrb $0x4,%eax,%xmm21,%xmm21
 15059d7:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 15059de:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 15059e5:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 15059ec:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 15059f3:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 15059f9:	62 e1 7f cb 6f bc d1 52 10 00 00 	vmovdqu8 0x1052(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505a04:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 1505a0b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505a12:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 1505a19:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505a1f:	62 83 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm23,%xmm24
 1505a26:	62 e1 7f c9 6f bc d1 92 10 00 00 	vmovdqu8 0x1092(%rcx,%rdx,8),%zmm23{%k1}{z}
 1505a31:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 1505a38:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505a3f:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 1505a46:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 1505a4d:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 1505a54:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505a5a:	62 61 7f cb 6f 84 d1 f2 10 00 00 	vmovdqu8 0x10f2(%rcx,%rdx,8),%zmm24{%k3}{z}
 1505a65:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 1505a6c:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505a73:	62 e1 7f c9 6f bc d1 32 11 00 00 	vmovdqu8 0x1132(%rcx,%rdx,8),%zmm23{%k1}{z}
 1505a7e:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 1505a85:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505a8b:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 1505a92:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 1505a99:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505aa0:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 1505aa7:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 1505aae:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 1505ab5:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505abb:	62 83 7d 48 39 e0 03 	vextracti32x4 $0x3,%zmm20,%xmm24
 1505ac2:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 1505ac9:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 1505ad0:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505ad7:	62 e1 7f cb 6f bc d1 92 1b 00 00 	vmovdqu8 0x1b92(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505ae2:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 1505ae9:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 1505aef:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 1505af6:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 1505afd:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 1505b04:	62 a3 7d 48 39 cb 02 	vextracti32x4 $0x2,%zmm17,%xmm19
 1505b0b:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 1505b12:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 1505b18:	62 e1 7f c9 6f a4 d1 72 17 00 00 	vmovdqu8 0x1772(%rcx,%rdx,8),%zmm20{%k1}{z}
 1505b23:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 1505b2a:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505b31:	62 61 7f cb 6f 84 d1 32 1c 00 00 	vmovdqu8 0x1c32(%rcx,%rdx,8),%zmm24{%k3}{z}
 1505b3c:	62 e3 6d 00 20 d0 07 	vpinsrb $0x7,%eax,%xmm18,%xmm18
 1505b43:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 1505b49:	62 e3 6d 00 20 c8 08 	vpinsrb $0x8,%eax,%xmm18,%xmm17
 1505b50:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 1505b57:	62 a3 7d 28 39 c2 01 	vextracti32x4 $0x1,%ymm16,%xmm18
 1505b5e:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 1505b65:	62 e1 7f cb 6f 9c d1 32 17 00 00 	vmovdqu8 0x1732(%rcx,%rdx,8),%zmm19{%k3}{z}
 1505b70:	62 e3 75 00 20 c8 09 	vpinsrb $0x9,%eax,%xmm17,%xmm17
 1505b77:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 1505b7d:	62 33 7d 48 39 fa 02 	vextracti32x4 $0x2,%zmm15,%xmm18
 1505b84:	62 e3 75 00 20 c8 0a 	vpinsrb $0xa,%eax,%xmm17,%xmm17
 1505b8b:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 1505b92:	62 33 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm14,%xmm16
 1505b99:	c4 43 7d 39 f6 01    	vextracti128 $0x1,%ymm14,%xmm14
 1505b9f:	62 e3 75 00 20 c8 0b 	vpinsrb $0xb,%eax,%xmm17,%xmm17
 1505ba6:	c5 79 7e f8          	vmovd  %xmm15,%eax
 1505baa:	62 73 75 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm17,%xmm15
 1505bb1:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 1505bb8:	62 e1 7f cb 6f 94 d1 92 16 00 00 	vmovdqu8 0x1692(%rcx,%rdx,8),%zmm18{%k3}{z}
 1505bc3:	62 e1 7f cb 6f 8c d1 d2 17 00 00 	vmovdqu8 0x17d2(%rcx,%rdx,8),%zmm17{%k3}{z}
 1505bce:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 1505bd4:	c5 79 7e f0          	vmovd  %xmm14,%eax
 1505bd8:	c4 63 01 20 f0 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm14
 1505bde:	62 33 55 20 38 fe 01 	vinserti32x4 $0x1,%xmm22,%ymm21,%ymm15
 1505be5:	62 e1 7f c9 6f b4 d1 52 19 00 00 	vmovdqu8 0x1952(%rcx,%rdx,8),%zmm22{%k1}{z}
 1505bf0:	62 e1 7f cb 6f ac d1 12 19 00 00 	vmovdqu8 0x1912(%rcx,%rdx,8),%zmm21{%k3}{z}
 1505bfb:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 1505c02:	62 e1 7f c9 6f 84 d1 12 18 00 00 	vmovdqu8 0x1812(%rcx,%rdx,8),%zmm16{%k1}{z}
 1505c0d:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 1505c13:	0f b6 84 d1 6a 0c 00 00 	movzbl 0xc6a(%rcx,%rdx,8),%eax
 1505c1b:	c4 63 11 20 e8 0f    	vpinsrb $0xf,%eax,%xmm13,%xmm13
 1505c21:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505c27:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 1505c2e:	c4 43 15 38 ee 01    	vinserti128 $0x1,%xmm14,%ymm13,%ymm13
 1505c34:	62 71 7f cb 6f b4 d1 12 14 00 00 	vmovdqu8 0x1412(%rcx,%rdx,8),%zmm14{%k3}{z}
 1505c3f:	62 a2 7d 48 7d ee    	vpermt2b %zmm22,%zmm0,%zmm21
 1505c45:	62 e1 7f c9 6f b4 d1 d2 1b 00 00 	vmovdqu8 0x1bd2(%rcx,%rdx,8),%zmm22{%k1}{z}
 1505c50:	62 53 95 48 3a ef 01 	vinserti64x4 $0x1,%ymm15,%zmm13,%zmm13
 1505c57:	62 71 7f c9 6f bc d1 52 14 00 00 	vmovdqu8 0x1452(%rcx,%rdx,8),%zmm15{%k1}{z}
 1505c62:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 1505c68:	62 e1 7f c9 6f b4 d1 72 1c 00 00 	vmovdqu8 0x1c72(%rcx,%rdx,8),%zmm22{%k1}{z}
 1505c73:	62 52 7d 48 7d f7    	vpermt2b %zmm15,%zmm0,%zmm14
 1505c79:	62 71 7f c9 6f bc d1 d2 16 00 00 	vmovdqu8 0x16d2(%rcx,%rdx,8),%zmm15{%k1}{z}
 1505c84:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 1505c8b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505c92:	c4 43 09 20 f5 04    	vpinsrb $0x4,%r13d,%xmm14,%xmm14
 1505c98:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 1505c9f:	c4 43 09 20 f4 05    	vpinsrb $0x5,%r12d,%xmm14,%xmm14
 1505ca5:	c4 43 09 20 f7 06    	vpinsrb $0x6,%r15d,%xmm14,%xmm14
 1505cab:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 1505cb2:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 1505cb9:	62 c2 7d 48 7d d7    	vpermt2b %zmm15,%zmm0,%zmm18
 1505cbf:	62 71 7f cb 6f bc d1 72 18 00 00 	vmovdqu8 0x1872(%rcx,%rdx,8),%zmm15{%k3}{z}
 1505cca:	c4 43 09 20 f6 07    	vpinsrb $0x7,%r14d,%xmm14,%xmm14
 1505cd0:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505cd6:	62 61 7f cb 6f 84 d1 d2 1c 00 00 	vmovdqu8 0x1cd2(%rcx,%rdx,8),%zmm24{%k3}{z}
 1505ce1:	c4 63 09 20 f3 08    	vpinsrb $0x8,%ebx,%xmm14,%xmm14
 1505ce7:	62 e3 45 00 20 f8 06 	vpinsrb $0x6,%eax,%xmm23,%xmm23
 1505cee:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 1505cf5:	62 e1 7f c9 6f b4 d1 12 1d 00 00 	vmovdqu8 0x1d12(%rcx,%rdx,8),%zmm22{%k1}{z}
 1505d00:	c4 43 09 20 f3 09    	vpinsrb $0x9,%r11d,%xmm14,%xmm14
 1505d06:	62 e3 45 00 20 f8 07 	vpinsrb $0x7,%eax,%xmm23,%xmm23
 1505d0d:	c4 43 09 20 f2 0a    	vpinsrb $0xa,%r10d,%xmm14,%xmm14
 1505d13:	c4 43 09 20 f1 0b    	vpinsrb $0xb,%r9d,%xmm14,%xmm14
 1505d19:	c4 43 09 20 f0 0c    	vpinsrb $0xc,%r8d,%xmm14,%xmm14
 1505d1f:	c4 63 09 20 f7 0d    	vpinsrb $0xd,%edi,%xmm14,%xmm14
 1505d25:	c4 63 09 20 f6 0e    	vpinsrb $0xe,%esi,%xmm14,%xmm14
 1505d2b:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505d31:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 1505d38:	62 e3 45 00 20 f8 08 	vpinsrb $0x8,%eax,%xmm23,%xmm23
 1505d3f:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505d46:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 1505d4d:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 1505d54:	62 e3 45 00 20 f8 09 	vpinsrb $0x9,%eax,%xmm23,%xmm23
 1505d5b:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 1505d61:	62 e3 45 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm23,%xmm22
 1505d68:	62 e1 7f cb 6f bc d1 72 1d 00 00 	vmovdqu8 0x1d72(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505d73:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505d7a:	62 61 7f c9 6f 84 d1 b2 1d 00 00 	vmovdqu8 0x1db2(%rcx,%rdx,8),%zmm24{%k1}{z}
 1505d85:	62 e3 4d 00 20 f0 0b 	vpinsrb $0xb,%eax,%xmm22,%xmm22
 1505d8c:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505d92:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 1505d99:	62 e3 4d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm22,%xmm22
 1505da0:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505da7:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 1505dae:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 1505db5:	62 e3 4d 00 20 f0 0d 	vpinsrb $0xd,%eax,%xmm22,%xmm22
 1505dbc:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505dc2:	62 e1 7f cb 6f bc d1 b2 19 00 00 	vmovdqu8 0x19b2(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505dcd:	62 e3 4d 00 20 f0 0e 	vpinsrb $0xe,%eax,%xmm22,%xmm22
 1505dd4:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505ddb:	62 61 7f c9 6f 84 d1 f2 19 00 00 	vmovdqu8 0x19f2(%rcx,%rdx,8),%zmm24{%k1}{z}
 1505de6:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 1505ded:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505df3:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 1505dfa:	62 e3 55 00 20 e8 04 	vpinsrb $0x4,%eax,%xmm21,%xmm21
 1505e01:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505e08:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 1505e0f:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 1505e16:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 1505e1d:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505e23:	62 e1 7f cb 6f bc d1 52 1a 00 00 	vmovdqu8 0x1a52(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505e2e:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 1505e35:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505e3c:	62 61 7f c9 6f 84 d1 92 1a 00 00 	vmovdqu8 0x1a92(%rcx,%rdx,8),%zmm24{%k1}{z}
 1505e47:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 1505e4e:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505e54:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 1505e5b:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 1505e62:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505e69:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 1505e70:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 1505e77:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 1505e7e:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505e84:	62 e1 7f cb 6f bc d1 f2 1a 00 00 	vmovdqu8 0x1af2(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505e8f:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 1505e96:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505e9d:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 1505ea4:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 1505eaa:	62 83 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm23,%xmm24
 1505eb1:	62 e1 7f c9 6f bc d1 32 1b 00 00 	vmovdqu8 0x1b32(%rcx,%rdx,8),%zmm23{%k1}{z}
 1505ebc:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 1505ec3:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1505eca:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 1505ed1:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 1505ed8:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 1505edf:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1505ee5:	62 61 7f c9 6f 84 d1 b2 18 00 00 	vmovdqu8 0x18b2(%rcx,%rdx,8),%zmm24{%k1}{z}
 1505ef0:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 1505ef7:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505efe:	62 a3 7d 48 39 e7 03 	vextracti32x4 $0x3,%zmm20,%xmm23
 1505f05:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 1505f0c:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 1505f13:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 1505f19:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 1505f20:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 1505f27:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 1505f2e:	62 a3 7d 48 39 cb 02 	vextracti32x4 $0x2,%zmm17,%xmm19
 1505f35:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 1505f3c:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 1505f42:	62 e1 7f c9 6f a4 d1 52 23 00 00 	vmovdqu8 0x2352(%rcx,%rdx,8),%zmm20{%k1}{z}
 1505f4d:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 1505f54:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 1505f5b:	62 e1 7f cb 6f bc d1 32 21 00 00 	vmovdqu8 0x2132(%rcx,%rdx,8),%zmm23{%k3}{z}
 1505f66:	62 e3 6d 00 20 d0 07 	vpinsrb $0x7,%eax,%xmm18,%xmm18
 1505f6d:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 1505f73:	62 e3 6d 00 20 c8 08 	vpinsrb $0x8,%eax,%xmm18,%xmm17
 1505f7a:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 1505f81:	62 a3 7d 28 39 c2 01 	vextracti32x4 $0x1,%ymm16,%xmm18
 1505f88:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 1505f8f:	62 e1 7f cb 6f 9c d1 d2 21 00 00 	vmovdqu8 0x21d2(%rcx,%rdx,8),%zmm19{%k3}{z}
 1505f9a:	62 e3 75 00 20 c8 09 	vpinsrb $0x9,%eax,%xmm17,%xmm17
 1505fa1:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 1505fa7:	62 33 7d 48 39 fa 02 	vextracti32x4 $0x2,%zmm15,%xmm18
 1505fae:	62 e3 75 00 20 c8 0a 	vpinsrb $0xa,%eax,%xmm17,%xmm17
 1505fb5:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 1505fbc:	62 23 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm16
 1505fc3:	62 e3 75 00 20 c8 0b 	vpinsrb $0xb,%eax,%xmm17,%xmm17
 1505fca:	c5 79 7e f8          	vmovd  %xmm15,%eax
 1505fce:	62 73 75 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm17,%xmm15
 1505fd5:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 1505fdc:	62 23 7d 28 39 c1 01 	vextracti32x4 $0x1,%ymm24,%xmm17
 1505fe3:	62 e1 7f cb 6f 94 d1 12 23 00 00 	vmovdqu8 0x2312(%rcx,%rdx,8),%zmm18{%k3}{z}
 1505fee:	62 61 7f c9 6f 84 d1 12 22 00 00 	vmovdqu8 0x2212(%rcx,%rdx,8),%zmm24{%k1}{z}
 1505ff9:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 1505fff:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 1506005:	62 e1 7f c9 6f 8c d1 d2 20 00 00 	vmovdqu8 0x20d2(%rcx,%rdx,8),%zmm17{%k1}{z}
 1506010:	c4 63 01 20 f8 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm15
 1506016:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 150601d:	62 a3 55 20 38 c6 01 	vinserti32x4 $0x1,%xmm22,%ymm21,%ymm16
 1506024:	62 e1 7f c9 6f ac d1 72 21 00 00 	vmovdqu8 0x2172(%rcx,%rdx,8),%zmm21{%k1}{z}
 150602f:	62 e1 7f cb 6f b4 d1 92 25 00 00 	vmovdqu8 0x2592(%rcx,%rdx,8),%zmm22{%k3}{z}
 150603a:	62 c1 7d 08 7e fa    	vmovd  %xmm23,%r10d
 1506040:	c4 63 01 20 f8 0f    	vpinsrb $0xf,%eax,%xmm15,%xmm15
 1506046:	0f b6 84 d1 6a 16 00 00 	movzbl 0x166a(%rcx,%rdx,8),%eax
 150604e:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 1506054:	62 a2 7d 48 7d d4    	vpermt2b %zmm20,%zmm0,%zmm18
 150605a:	62 e1 7f c9 6f a4 d1 d2 25 00 00 	vmovdqu8 0x25d2(%rcx,%rdx,8),%zmm20{%k1}{z}
 1506065:	c4 43 0d 38 f7 01    	vinserti128 $0x1,%xmm15,%ymm14,%ymm14
 150606b:	62 71 7f cb 6f bc d1 12 1e 00 00 	vmovdqu8 0x1e12(%rcx,%rdx,8),%zmm15{%k3}{z}
 1506076:	62 33 8d 48 3a f0 01 	vinserti64x4 $0x1,%ymm16,%zmm14,%zmm14
 150607d:	62 e1 7f c9 6f 84 d1 52 1e 00 00 	vmovdqu8 0x1e52(%rcx,%rdx,8),%zmm16{%k1}{z}
 1506088:	62 a2 7d 48 7d f4    	vpermt2b %zmm20,%zmm0,%zmm22
 150608e:	62 a3 7d 48 39 ec 03 	vextracti32x4 $0x3,%zmm21,%xmm20
 1506095:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 150609c:	62 e3 7d 08 14 e6 08 	vpextrb $0x8,%xmm20,%esi
 15060a3:	62 e1 7f c9 6f a4 d1 b2 22 00 00 	vmovdqu8 0x22b2(%rcx,%rdx,8),%zmm20{%k1}{z}
 15060ae:	62 e1 7d 08 7e ef    	vmovd  %xmm21,%edi
 15060b4:	62 a3 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm23,%xmm21
 15060bb:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 15060c2:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 15060c9:	62 32 7d 48 7d f8    	vpermt2b %zmm16,%zmm0,%zmm15
 15060cf:	62 e1 7f cb 6f 84 d1 92 20 00 00 	vmovdqu8 0x2092(%rcx,%rdx,8),%zmm16{%k3}{z}
 15060da:	62 41 7d 08 7e c3    	vmovd  %xmm24,%r11d
 15060e0:	62 83 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm19,%xmm24
 15060e7:	62 c3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%r8d
 15060ee:	62 e1 7f c9 6f bc d1 72 26 00 00 	vmovdqu8 0x2672(%rcx,%rdx,8),%zmm23{%k1}{z}
 15060f9:	62 c3 7d 08 14 e9 08 	vpextrb $0x8,%xmm21,%r9d
 1506100:	62 e1 7f c9 6f ac d1 f2 23 00 00 	vmovdqu8 0x23f2(%rcx,%rdx,8),%zmm21{%k1}{z}
 150610b:	62 43 7d 08 14 c6 08 	vpextrb $0x8,%xmm24,%r14d
 1506112:	62 83 7d 48 39 e0 03 	vextracti32x4 $0x3,%zmm20,%xmm24
 1506119:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 1506120:	62 a2 7d 48 7d c1    	vpermt2b %zmm17,%zmm0,%zmm16
 1506126:	62 e1 7f cb 6f 8c d1 72 22 00 00 	vmovdqu8 0x2272(%rcx,%rdx,8),%zmm17{%k3}{z}
 1506131:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 1506138:	62 83 7d 48 39 f9 03 	vextracti32x4 $0x3,%zmm23,%xmm25
 150613f:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 1506146:	62 83 7d 48 39 ea 03 	vextracti32x4 $0x3,%zmm21,%xmm26
 150614d:	62 63 7d 08 14 c8 08 	vpextrb $0x8,%xmm25,%eax
 1506154:	62 43 7d 08 14 d4 08 	vpextrb $0x8,%xmm26,%r12d
 150615b:	62 c3 7d 00 20 c2 04 	vpinsrb $0x4,%r10d,%xmm16,%xmm16
 1506162:	62 c3 7d 00 20 c1 05 	vpinsrb $0x5,%r9d,%xmm16,%xmm16
 1506169:	62 e3 7d 00 20 c7 06 	vpinsrb $0x6,%edi,%xmm16,%xmm16
 1506170:	62 83 7d 48 39 c8 02 	vextracti32x4 $0x2,%zmm17,%xmm24
 1506177:	62 e3 7d 00 20 c6 07 	vpinsrb $0x7,%esi,%xmm16,%xmm16
 150617e:	62 43 7d 08 14 c7 08 	vpextrb $0x8,%xmm24,%r15d
 1506185:	62 61 7f cb 6f 84 d1 32 26 00 00 	vmovdqu8 0x2632(%rcx,%rdx,8),%zmm24{%k3}{z}
 1506190:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 1506196:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 150619d:	62 c3 4d 00 20 f5 04 	vpinsrb $0x4,%r13d,%xmm22,%xmm22
 15061a4:	62 43 7d 08 14 c5 08 	vpextrb $0x8,%xmm24,%r13d
 15061ab:	62 61 7f c9 6f 84 d1 12 27 00 00 	vmovdqu8 0x2712(%rcx,%rdx,8),%zmm24{%k1}{z}
 15061b6:	62 c3 4d 00 20 f5 05 	vpinsrb $0x5,%r13d,%xmm22,%xmm22
 15061bd:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 15061c3:	62 c3 4d 00 20 f5 06 	vpinsrb $0x6,%r13d,%xmm22,%xmm22
 15061ca:	62 e3 4d 00 20 f0 07 	vpinsrb $0x7,%eax,%xmm22,%xmm22
 15061d1:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 15061d8:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 15061df:	62 c3 7d 08 14 fd 08 	vpextrb $0x8,%xmm23,%r13d
 15061e6:	62 e1 7f cb 6f bc d1 d2 26 00 00 	vmovdqu8 0x26d2(%rcx,%rdx,8),%zmm23{%k3}{z}
 15061f1:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 15061f7:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 15061fe:	62 e3 4d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm22,%xmm22
 1506205:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 150620c:	62 e1 7f c9 6f bc d1 b2 27 00 00 	vmovdqu8 0x27b2(%rcx,%rdx,8),%zmm23{%k1}{z}
 1506217:	62 e3 4d 00 20 f0 09 	vpinsrb $0x9,%eax,%xmm22,%xmm22
 150621e:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 1506224:	62 e3 4d 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm22,%xmm22
 150622b:	62 c3 4d 00 20 f5 0b 	vpinsrb $0xb,%r13d,%xmm22,%xmm22
 1506232:	62 83 7d 48 39 f8 03 	vextracti32x4 $0x3,%zmm23,%xmm24
 1506239:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 1506240:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 1506247:	62 61 7f cb 6f 84 d1 72 27 00 00 	vmovdqu8 0x2772(%rcx,%rdx,8),%zmm24{%k3}{z}
 1506252:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 1506258:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 150625f:	62 c3 4d 00 20 f5 0c 	vpinsrb $0xc,%r13d,%xmm22,%xmm22
 1506266:	62 43 7d 08 14 c5 08 	vpextrb $0x8,%xmm24,%r13d
 150626d:	62 c3 4d 00 20 f5 0d 	vpinsrb $0xd,%r13d,%xmm22,%xmm22
 1506274:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 150627a:	62 c3 4d 00 20 f5 0e 	vpinsrb $0xe,%r13d,%xmm22,%xmm22
 1506281:	62 c1 7d 08 7e dd    	vmovd  %xmm19,%r13d
 1506287:	62 e1 7f cb 6f 9c d1 b2 23 00 00 	vmovdqu8 0x23b2(%rcx,%rdx,8),%zmm19{%k3}{z}
 1506292:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 1506299:	62 c3 7d 00 20 c5 08 	vpinsrb $0x8,%r13d,%xmm16,%xmm16
 15062a0:	62 c3 7d 00 20 c6 09 	vpinsrb $0x9,%r14d,%xmm16,%xmm16
 15062a7:	62 c3 7d 00 20 c3 0a 	vpinsrb $0xa,%r11d,%xmm16,%xmm16
 15062ae:	62 c3 7d 00 20 c0 0b 	vpinsrb $0xb,%r8d,%xmm16,%xmm16
 15062b5:	4c 8d 05 c4 62 5f 0d 	lea    0xd5f62c4(%rip),%r8        # eafc580 <tier0_choice_shapes>
 15062bc:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 15062c2:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 15062c9:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 15062d0:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 15062d7:	62 a3 7d 28 39 eb 01 	vextracti32x4 $0x1,%ymm21,%xmm19
 15062de:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 15062e5:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 15062eb:	62 e1 7f cb 6f 9c d1 52 24 00 00 	vmovdqu8 0x2452(%rcx,%rdx,8),%zmm19{%k3}{z}
 15062f6:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 15062fd:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 1506303:	62 e1 7f c9 6f a4 d1 92 24 00 00 	vmovdqu8 0x2492(%rcx,%rdx,8),%zmm20{%k1}{z}
 150630e:	62 c3 6d 00 20 d4 07 	vpinsrb $0x7,%r12d,%xmm18,%xmm18
 1506315:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 150631b:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 1506322:	62 c3 6d 00 20 d4 08 	vpinsrb $0x8,%r12d,%xmm18,%xmm18
 1506329:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 1506330:	62 a3 7d 28 39 e3 01 	vextracti32x4 $0x1,%ymm20,%xmm19
 1506337:	62 a3 7d 48 39 e4 03 	vextracti32x4 $0x3,%zmm20,%xmm20
 150633e:	62 c3 6d 00 20 d4 09 	vpinsrb $0x9,%r12d,%xmm18,%xmm18
 1506345:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 150634b:	62 e1 7f cb 6f 9c d1 f2 24 00 00 	vmovdqu8 0x24f2(%rcx,%rdx,8),%zmm19{%k3}{z}
 1506356:	62 c3 6d 00 20 d4 0a 	vpinsrb $0xa,%r12d,%xmm18,%xmm18
 150635d:	62 c3 7d 08 14 e4 08 	vpextrb $0x8,%xmm20,%r12d
 1506364:	62 e1 7f c9 6f a4 d1 32 25 00 00 	vmovdqu8 0x2532(%rcx,%rdx,8),%zmm20{%k1}{z}
 150636f:	62 f1 3d 48 74 ce    	vpcmpeqb %zmm6,%zmm8,%k1
 1506375:	62 c3 6d 00 20 d4 0b 	vpinsrb $0xb,%r12d,%xmm18,%xmm18
 150637c:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 1506382:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 1506389:	62 c3 6d 00 20 d4 0c 	vpinsrb $0xc,%r12d,%xmm18,%xmm18
 1506390:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 1506397:	62 a3 7d 28 39 e3 01 	vextracti32x4 $0x1,%ymm20,%xmm19
 150639e:	62 c3 6d 00 20 d4 0d 	vpinsrb $0xd,%r12d,%xmm18,%xmm18
 15063a5:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 15063ab:	62 a3 7d 48 39 e3 03 	vextracti32x4 $0x3,%zmm20,%xmm19
 15063b2:	62 e1 9d 48 db e2    	vpandq %zmm2,%zmm12,%zmm20
 15063b8:	62 c3 6d 00 20 d4 0e 	vpinsrb $0xe,%r12d,%xmm18,%xmm18
 15063bf:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 15063c6:	62 71 dd 40 eb c7    	vporq  %zmm7,%zmm20,%zmm8
 15063cc:	62 c3 6d 00 20 d4 0f 	vpinsrb $0xf,%r12d,%xmm18,%xmm18
 15063d3:	62 c1 7d 08 7e cc    	vmovd  %xmm17,%r12d
 15063d9:	62 c1 7f 49 6f e0    	vmovdqu8 %zmm8,%zmm20{%k1}
 15063df:	62 71 8d 48 db c2    	vpandq %zmm2,%zmm14,%zmm8
 15063e5:	62 f1 35 48 74 cb    	vpcmpeqb %zmm3,%zmm9,%k1
 15063eb:	62 c3 7d 00 20 c4 0c 	vpinsrb $0xc,%r12d,%xmm16,%xmm16
 15063f2:	62 a3 6d 20 38 ce 01 	vinserti32x4 $0x1,%xmm22,%ymm18,%ymm17
 15063f9:	62 e1 bd 48 eb d7    	vporq  %zmm7,%zmm8,%zmm18
 15063ff:	c4 e1 f4 45 e4       	korq   %k4,%k1,%k4
 1506404:	62 c3 7d 00 20 c7 0d 	vpinsrb $0xd,%r15d,%xmm16,%xmm16
 150640b:	62 e3 7d 00 20 c0 0e 	vpinsrb $0xe,%eax,%xmm16,%xmm16
 1506412:	0f b6 84 d1 b2 1e 00 00 	movzbl 0x1eb2(%rcx,%rdx,8),%eax
 150641a:	62 e3 7d 00 20 c3 0f 	vpinsrb $0xf,%ebx,%xmm16,%xmm16
 1506421:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 1506427:	0f b6 84 d1 da 1e 00 00 	movzbl 0x1eda(%rcx,%rdx,8),%eax
 150642f:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 1506435:	0f b6 84 d1 02 1f 00 00 	movzbl 0x1f02(%rcx,%rdx,8),%eax
 150643d:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 1506443:	0f b6 84 d1 2a 1f 00 00 	movzbl 0x1f2a(%rcx,%rdx,8),%eax
 150644b:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 1506451:	0f b6 84 d1 52 1f 00 00 	movzbl 0x1f52(%rcx,%rdx,8),%eax
 1506459:	c4 63 01 20 f8 08    	vpinsrb $0x8,%eax,%xmm15,%xmm15
 150645f:	0f b6 84 d1 7a 1f 00 00 	movzbl 0x1f7a(%rcx,%rdx,8),%eax
 1506467:	c4 63 01 20 f8 09    	vpinsrb $0x9,%eax,%xmm15,%xmm15
 150646d:	0f b6 84 d1 a2 1f 00 00 	movzbl 0x1fa2(%rcx,%rdx,8),%eax
 1506475:	c4 63 01 20 f8 0a    	vpinsrb $0xa,%eax,%xmm15,%xmm15
 150647b:	0f b6 84 d1 ca 1f 00 00 	movzbl 0x1fca(%rcx,%rdx,8),%eax
 1506483:	c4 63 01 20 f8 0b    	vpinsrb $0xb,%eax,%xmm15,%xmm15
 1506489:	0f b6 84 d1 f2 1f 00 00 	movzbl 0x1ff2(%rcx,%rdx,8),%eax
 1506491:	c4 63 01 20 f8 0c    	vpinsrb $0xc,%eax,%xmm15,%xmm15
 1506497:	0f b6 84 d1 1a 20 00 00 	movzbl 0x201a(%rcx,%rdx,8),%eax
 150649f:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 15064a5:	0f b6 84 d1 42 20 00 00 	movzbl 0x2042(%rcx,%rdx,8),%eax
 15064ad:	c4 63 01 20 f8 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm15
 15064b3:	0f b6 84 d1 6a 20 00 00 	movzbl 0x206a(%rcx,%rdx,8),%eax
 15064bb:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 15064c0:	c4 63 01 20 f8 0f    	vpinsrb $0xf,%eax,%xmm15,%xmm15
 15064c6:	62 33 05 28 38 f8 01 	vinserti32x4 $0x1,%xmm16,%ymm15,%ymm15
 15064cd:	62 33 85 48 3a f9 01 	vinserti64x4 $0x1,%ymm17,%zmm15,%zmm15
 15064d4:	62 e1 95 48 db ca    	vpandq %zmm2,%zmm13,%zmm17
 15064da:	62 e1 f5 40 eb df    	vporq  %zmm7,%zmm17,%zmm19
 15064e0:	62 f3 05 4a 3e d1 01 	vpcmpltub %zmm1,%zmm15,%k2{%k2}
 15064e7:	62 a1 7f 4d 6f cb    	vmovdqu8 %zmm19,%zmm17{%k5}
 15064ed:	62 f1 2d 48 74 ee    	vpcmpeqb %zmm6,%zmm10,%k5
 15064f3:	62 e1 85 48 db da    	vpandq %zmm2,%zmm15,%zmm19
 15064f9:	62 31 7f 4d 6f c2    	vmovdqu8 %zmm18,%zmm8{%k5}
 15064ff:	62 f1 2d 48 74 eb    	vpcmpeqb %zmm3,%zmm10,%k5
 1506505:	62 e1 f5 40 eb d5    	vporq  %zmm5,%zmm17,%zmm18
 150650b:	62 71 e5 40 eb d7    	vporq  %zmm7,%zmm19,%zmm10
 1506511:	c4 e1 d4 45 c8       	korq   %k0,%k5,%k1
 1506516:	62 f1 25 48 74 c4    	vpcmpeqb %zmm4,%zmm11,%k0
 150651c:	62 f1 25 48 74 ee    	vpcmpeqb %zmm6,%zmm11,%k5
 1506522:	62 71 dd 40 eb dd    	vporq  %zmm5,%zmm20,%zmm11
 1506528:	62 a1 7f 4c 6f ca    	vmovdqu8 %zmm18,%zmm17{%k4}
 150652e:	c4 e1 f8 90 64 24 60 	kmovq  0x60(%rsp),%k4
 1506535:	62 c1 7f 4e 6f e3    	vmovdqu8 %zmm11,%zmm20{%k6}
 150653b:	62 71 bd 48 eb dd    	vporq  %zmm5,%zmm8,%zmm11
 1506541:	62 c1 7f 4d 6f da    	vmovdqu8 %zmm10,%zmm19{%k5}
 1506547:	c4 e1 f8 90 6c 24 30 	kmovq  0x30(%rsp),%k5
 150654e:	c4 e1 c4 45 f8       	korq   %k0,%k7,%k7
 1506553:	62 71 e5 40 eb d5    	vporq  %zmm5,%zmm19,%zmm10
 1506559:	62 a1 fe 48 7f 24 02 	vmovdqu64 %zmm20,(%rdx,%r8,1)
 1506560:	62 a1 fe 48 7f 4c 02 01 	vmovdqu64 %zmm17,0x40(%rdx,%r8,1)
 1506568:	62 51 7f 49 6f c3    	vmovdqu8 %zmm11,%zmm8{%k1}
 150656e:	c4 e1 f8 90 8c 24 b0 00 00 00 	kmovq  0xb0(%rsp),%k1
 1506578:	62 c1 7f 4f 6f da    	vmovdqu8 %zmm10,%zmm19{%k7}
 150657e:	62 31 fe 48 7f 44 02 02 	vmovdqu64 %zmm8,0x80(%rdx,%r8,1)
 1506586:	62 a1 fe 48 7f 5c 02 03 	vmovdqu64 %zmm19,0xc0(%rdx,%r8,1)
 150658e:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
 1506595:	62 f3 15 4c 3e e1 01 	vpcmpltub %zmm1,%zmm13,%k4{%k4}
 150659c:	62 f3 0d 4d 3e e9 01 	vpcmpltub %zmm1,%zmm14,%k5{%k5}
 15065a3:	62 f3 1d 49 3e c9 01 	vpcmpltub %zmm1,%zmm12,%k1{%k1}
 15065aa:	48 81 fa 00 20 00 00 	cmp    $0x2000,%rdx
 15065b1:	0f 85 f9 da ff ff    	jne    15040b0 <run_backend_benchmark+0x2940>
 15065b7:	c4 e2 7d 5a 0d 90 f5 06 ff 	vbroadcasti128 -0xf90a70(%rip),%ymm1        # 575b50 <x86_effects_unknown+0xf0>
 15065c0:	c4 e2 7d 5a 15 97 f5 06 ff 	vbroadcasti128 -0xf90a69(%rip),%ymm2        # 575b60 <x86_effects_unknown+0x100>
 15065c9:	c4 e2 7d 5a 1d 9e f5 06 ff 	vbroadcasti128 -0xf90a62(%rip),%ymm3        # 575b70 <x86_effects_unknown+0x110>
 15065d2:	c4 e2 7d 5a 25 a5 f5 06 ff 	vbroadcasti128 -0xf90a5b(%rip),%ymm4        # 575b80 <x86_effects_unknown+0x120>
 15065db:	c4 e2 7d 5a 2d bc f5 06 ff 	vbroadcasti128 -0xf90a44(%rip),%ymm5        # 575ba0 <x86_effects_unknown+0x140>
 15065e4:	c4 e2 7d 5a 35 c3 f5 06 ff 	vbroadcasti128 -0xf90a3d(%rip),%ymm6        # 575bb0 <x86_effects_unknown+0x150>
 15065ed:	c4 e2 7d 5a 3d 9a f5 06 ff 	vbroadcasti128 -0xf90a66(%rip),%ymm7        # 575b90 <x86_effects_unknown+0x130>
 15065f6:	c4 e1 dc 41 c1       	kandq  %k1,%k4,%k0
 15065fb:	c4 e1 ec 41 cd       	kandq  %k5,%k2,%k1
 1506600:	31 c0                	xor    %eax,%eax
 1506602:	48 8d 0d 59 7e b9 00 	lea    0xb97e59(%rip),%rcx        # 209e462 <x86_form_descriptions+0x50012>
 1506609:	48 be 00 00 01 00 00 00 00 01 	movabs $0x100000000010000,%rsi
 1506613:	48 bf 01 00 00 00 00 01 00 00 	movabs $0x10000000001,%rdi
 150661d:	c4 e1 f4 41 c0       	kandq  %k0,%k1,%k0
 1506622:	c4 e1 f8 98 c0       	kortestq %k0,%k0
 1506627:	0f 92 c0             	setb   %al
 150662a:	31 d2                	xor    %edx,%edx
 150662c:	83 c8 fe             	or     $0xfffffffe,%eax
 150662f:	c5 fb 92 c8          	kmovd  %eax,%k1
 1506633:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1506640:	c4 e1 fb 92 d6       	kmovq  %rsi,%k2
 1506645:	c4 e1 fb 92 df       	kmovq  %rdi,%k3
 150664a:	62 71 7f ca 6f 81 c9 02 00 00 	vmovdqu8 0x2c9(%rcx),%zmm8{%k2}{z}
 1506654:	62 71 7f cb 6f 89 89 02 00 00 	vmovdqu8 0x289(%rcx),%zmm9{%k3}{z}
 150665e:	62 71 7f ca 6f 91 69 03 00 00 	vmovdqu8 0x369(%rcx),%zmm10{%k2}{z}
 1506668:	62 71 7f cb 6f 99 c9 03 00 00 	vmovdqu8 0x3c9(%rcx),%zmm11{%k3}{z}
 1506672:	62 71 7f ca 6f a1 09 04 00 00 	vmovdqu8 0x409(%rcx),%zmm12{%k2}{z}
 150667c:	62 71 7f cb 6f b9 60 04 00 00 	vmovdqu8 0x460(%rcx),%zmm15{%k3}{z}
 1506686:	62 e1 7f ca 6f 81 a0 04 00 00 	vmovdqu8 0x4a0(%rcx),%zmm16{%k2}{z}
 1506690:	62 52 7d 48 7d c8    	vpermt2b %zmm8,%zmm0,%zmm9
 1506696:	62 71 7f cb 6f 81 29 03 00 00 	vmovdqu8 0x329(%rcx),%zmm8{%k3}{z}
 15066a0:	62 53 7d 48 39 d5 03 	vextracti32x4 $0x3,%zmm10,%xmm13
 15066a7:	62 53 7d 48 39 c6 02 	vextracti32x4 $0x2,%zmm8,%xmm14
 15066ae:	c5 79 7e c0          	vmovd  %xmm8,%eax
 15066b2:	c4 63 31 20 c0 04    	vpinsrb $0x4,%eax,%xmm9,%xmm8
 15066b8:	c4 63 79 14 f0 08    	vpextrb $0x8,%xmm14,%eax
 15066be:	c4 43 7d 39 d1 01    	vextracti128 $0x1,%ymm10,%xmm9
 15066c4:	62 53 7d 48 39 e2 03 	vextracti32x4 $0x3,%zmm12,%xmm10
 15066cb:	62 71 7f ca 6f 71 10 	vmovdqu8 0x400(%rcx),%zmm14{%k2}{z}
 15066d2:	c4 63 39 20 c0 05    	vpinsrb $0x5,%eax,%xmm8,%xmm8
 15066d8:	c5 79 7e c8          	vmovd  %xmm9,%eax
 15066dc:	62 71 7f cb 6f 89 69 04 00 00 	vmovdqu8 0x469(%rcx),%zmm9{%k3}{z}
 15066e6:	c4 63 39 20 c0 06    	vpinsrb $0x6,%eax,%xmm8,%xmm8
 15066ec:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 15066f2:	62 53 7d 48 39 dd 02 	vextracti32x4 $0x2,%zmm11,%xmm13
 15066f9:	c4 63 39 20 c0 07    	vpinsrb $0x7,%eax,%xmm8,%xmm8
 15066ff:	c5 79 7e d8          	vmovd  %xmm11,%eax
 1506703:	c4 43 7d 39 e3 01    	vextracti128 $0x1,%ymm12,%xmm11
 1506709:	c4 63 39 20 c0 08    	vpinsrb $0x8,%eax,%xmm8,%xmm8
 150670f:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 1506715:	62 71 7f cb 6f 69 0f 	vmovdqu8 0x3c0(%rcx),%zmm13{%k3}{z}
 150671c:	c4 63 39 20 c0 09    	vpinsrb $0x9,%eax,%xmm8,%xmm8
 1506722:	c5 79 7e d8          	vmovd  %xmm11,%eax
 1506726:	c4 63 39 20 c0 0a    	vpinsrb $0xa,%eax,%xmm8,%xmm8
 150672c:	c4 63 79 14 d0 08    	vpextrb $0x8,%xmm10,%eax
 1506732:	62 71 7f ca 6f 91 a9 04 00 00 	vmovdqu8 0x4a9(%rcx),%zmm10{%k2}{z}
 150673c:	c4 63 39 20 c0 0b    	vpinsrb $0xb,%eax,%xmm8,%xmm8
 1506742:	c5 79 7e c8          	vmovd  %xmm9,%eax
 1506746:	62 53 7d 48 39 cc 02 	vextracti32x4 $0x2,%zmm9,%xmm12
 150674d:	c4 63 39 20 c0 0c    	vpinsrb $0xc,%eax,%xmm8,%xmm8
 1506753:	c4 63 79 14 e0 08    	vpextrb $0x8,%xmm12,%eax
 1506759:	62 71 7f ca 6f 61 0b 	vmovdqu8 0x2c0(%rcx),%zmm12{%k2}{z}
 1506760:	c4 63 39 20 c0 0d    	vpinsrb $0xd,%eax,%xmm8,%xmm8
 1506766:	c4 43 7d 39 d1 01    	vextracti128 $0x1,%ymm10,%xmm9
 150676c:	62 53 7d 48 39 d3 03 	vextracti32x4 $0x3,%zmm10,%xmm11
 1506773:	62 71 7f ca 6f 51 01 	vmovdqu8 0x40(%rcx),%zmm10{%k2}{z}
 150677a:	c5 79 7e c8          	vmovd  %xmm9,%eax
 150677e:	62 71 7f cb 6f 09    	vmovdqu8 (%rcx),%zmm9{%k3}{z}
 1506784:	c4 63 39 20 c0 0e    	vpinsrb $0xe,%eax,%xmm8,%xmm8
 150678a:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 1506790:	62 71 7f cb 6f 59 0a 	vmovdqu8 0x280(%rcx),%zmm11{%k3}{z}
 1506797:	c4 63 39 20 c0 0f    	vpinsrb $0xf,%eax,%xmm8,%xmm8
 150679d:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 15067a3:	62 71 7f cb 6f 91 20 03 00 00 	vmovdqu8 0x320(%rcx),%zmm10{%k3}{z}
 15067ad:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 15067b3:	62 71 7f ca 6f a1 60 03 00 00 	vmovdqu8 0x360(%rcx),%zmm12{%k2}{z}
 15067bd:	c5 79 7e d0          	vmovd  %xmm10,%eax
 15067c1:	62 53 7d 48 39 d2 02 	vextracti32x4 $0x2,%zmm10,%xmm10
 15067c8:	62 33 7d 48 39 e1 03 	vextracti32x4 $0x3,%zmm12,%xmm17
 15067cf:	c4 63 21 20 d8 04    	vpinsrb $0x4,%eax,%xmm11,%xmm11
 15067d5:	c4 63 79 14 d0 08    	vpextrb $0x8,%xmm10,%eax
 15067db:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 15067e1:	c4 63 21 20 d0 05    	vpinsrb $0x5,%eax,%xmm11,%xmm10
 15067e7:	c5 79 7e e0          	vmovd  %xmm12,%eax
 15067eb:	c4 43 7d 39 f4 01    	vextracti128 $0x1,%ymm14,%xmm12
 15067f1:	62 53 7d 48 39 f3 03 	vextracti32x4 $0x3,%zmm14,%xmm11
 15067f8:	c4 63 29 20 d0 06    	vpinsrb $0x6,%eax,%xmm10,%xmm10
 15067fe:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 1506805:	c4 63 29 20 d0 07    	vpinsrb $0x7,%eax,%xmm10,%xmm10
 150680b:	c5 79 7e e8          	vmovd  %xmm13,%eax
 150680f:	62 53 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm13,%xmm13
 1506816:	c4 63 29 20 d0 08    	vpinsrb $0x8,%eax,%xmm10,%xmm10
 150681c:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 1506822:	c4 63 29 20 d0 09    	vpinsrb $0x9,%eax,%xmm10,%xmm10
 1506828:	c5 79 7e e0          	vmovd  %xmm12,%eax
 150682c:	62 71 7f cb 6f a1 09 00 00 00 	vmovdqu8 0x9(%rcx),%zmm12{%k3}{z}
 1506836:	c4 63 29 20 d0 0a    	vpinsrb $0xa,%eax,%xmm10,%xmm10
 150683c:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 1506842:	62 53 7d 48 39 fb 02 	vextracti32x4 $0x2,%zmm15,%xmm11
 1506849:	c4 63 29 20 d0 0b    	vpinsrb $0xb,%eax,%xmm10,%xmm10
 150684f:	c5 79 7e f8          	vmovd  %xmm15,%eax
 1506853:	c4 63 29 20 d0 0c    	vpinsrb $0xc,%eax,%xmm10,%xmm10
 1506859:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 150685f:	62 c3 7d 28 39 c3 01 	vextracti32x4 $0x1,%ymm16,%xmm11
 1506866:	c4 63 29 20 d0 0d    	vpinsrb $0xd,%eax,%xmm10,%xmm10
 150686c:	c5 79 7e d8          	vmovd  %xmm11,%eax
 1506870:	62 c3 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm16,%xmm11
 1506877:	c4 63 29 20 d0 0e    	vpinsrb $0xe,%eax,%xmm10,%xmm10
 150687d:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 1506883:	62 71 7f ca 6f 99 49 00 00 00 	vmovdqu8 0x49(%rcx),%zmm11{%k2}{z}
 150688d:	c4 63 29 20 d0 0f    	vpinsrb $0xf,%eax,%xmm10,%xmm10
 1506893:	0f b6 81 a0 00 00 00 	movzbl 0xa0(%rcx),%eax
 150689a:	c4 63 31 20 c8 04    	vpinsrb $0x4,%eax,%xmm9,%xmm9
 15068a0:	0f b6 81 c8 00 00 00 	movzbl 0xc8(%rcx),%eax
 15068a7:	62 52 7d 48 7d e3    	vpermt2b %zmm11,%zmm0,%zmm12
 15068ad:	c4 63 19 20 99 a9 00 00 00 04 	vpinsrb $0x4,0xa9(%rcx),%xmm12,%xmm11
 15068b7:	c4 63 31 20 c8 05    	vpinsrb $0x5,%eax,%xmm9,%xmm9
 15068bd:	0f b6 81 f0 00 00 00 	movzbl 0xf0(%rcx),%eax
 15068c4:	c4 63 21 20 99 d1 00 00 00 05 	vpinsrb $0x5,0xd1(%rcx),%xmm11,%xmm11
 15068ce:	c4 63 31 20 c8 06    	vpinsrb $0x6,%eax,%xmm9,%xmm9
 15068d4:	0f b6 81 18 01 00 00 	movzbl 0x118(%rcx),%eax
 15068db:	c4 63 21 20 99 f9 00 00 00 06 	vpinsrb $0x6,0xf9(%rcx),%xmm11,%xmm11
 15068e5:	c4 63 31 20 c8 07    	vpinsrb $0x7,%eax,%xmm9,%xmm9
 15068eb:	0f b6 81 40 01 00 00 	movzbl 0x140(%rcx),%eax
 15068f2:	c4 63 21 20 99 21 01 00 00 07 	vpinsrb $0x7,0x121(%rcx),%xmm11,%xmm11
 15068fc:	c4 63 21 20 99 49 01 00 00 08 	vpinsrb $0x8,0x149(%rcx),%xmm11,%xmm11
 1506906:	c4 63 31 20 c8 08    	vpinsrb $0x8,%eax,%xmm9,%xmm9
 150690c:	0f b6 81 68 01 00 00 	movzbl 0x168(%rcx),%eax
 1506913:	c4 63 21 20 99 71 01 00 00 09 	vpinsrb $0x9,0x171(%rcx),%xmm11,%xmm11
 150691d:	c4 63 31 20 c8 09    	vpinsrb $0x9,%eax,%xmm9,%xmm9
 1506923:	0f b6 81 90 01 00 00 	movzbl 0x190(%rcx),%eax
 150692a:	c4 63 21 20 99 99 01 00 00 0a 	vpinsrb $0xa,0x199(%rcx),%xmm11,%xmm11
 1506934:	c4 63 31 20 c8 0a    	vpinsrb $0xa,%eax,%xmm9,%xmm9
 150693a:	0f b6 81 b8 01 00 00 	movzbl 0x1b8(%rcx),%eax
 1506941:	c4 63 21 20 99 c1 01 00 00 0b 	vpinsrb $0xb,0x1c1(%rcx),%xmm11,%xmm11
 150694b:	c4 63 31 20 c8 0b    	vpinsrb $0xb,%eax,%xmm9,%xmm9
 1506951:	0f b6 81 e0 01 00 00 	movzbl 0x1e0(%rcx),%eax
 1506958:	c4 63 21 20 99 e9 01 00 00 0c 	vpinsrb $0xc,0x1e9(%rcx),%xmm11,%xmm11
 1506962:	c4 63 21 20 99 11 02 00 00 0d 	vpinsrb $0xd,0x211(%rcx),%xmm11,%xmm11
 150696c:	c4 63 31 20 c8 0c    	vpinsrb $0xc,%eax,%xmm9,%xmm9
 1506972:	0f b6 81 08 02 00 00 	movzbl 0x208(%rcx),%eax
 1506979:	c4 63 21 20 99 39 02 00 00 0e 	vpinsrb $0xe,0x239(%rcx),%xmm11,%xmm11
 1506983:	c4 63 31 20 c8 0d    	vpinsrb $0xd,%eax,%xmm9,%xmm9
 1506989:	0f b6 81 30 02 00 00 	movzbl 0x230(%rcx),%eax
 1506990:	c4 63 21 20 99 61 02 00 00 0f 	vpinsrb $0xf,0x261(%rcx),%xmm11,%xmm11
 150699a:	c4 63 31 20 c8 0e    	vpinsrb $0xe,%eax,%xmm9,%xmm9
 15069a0:	0f b6 81 58 02 00 00 	movzbl 0x258(%rcx),%eax
 15069a7:	48 81 c1 00 05 00 00 	add    $0x500,%rcx
 15069ae:	c4 63 31 20 c8 0f    	vpinsrb $0xf,%eax,%xmm9,%xmm9
 15069b4:	c4 43 25 38 c0 01    	vinserti128 $0x1,%xmm8,%ymm11,%ymm8
 15069ba:	c4 43 35 38 ca 01    	vinserti128 $0x1,%xmm10,%ymm9,%ymm9
 15069c0:	62 f1 3d 28 74 c3    	vpcmpeqb %ymm3,%ymm8,%k0
 15069c6:	62 f1 3d 28 74 d4    	vpcmpeqb %ymm4,%ymm8,%k2
 15069cc:	62 f1 3d 28 74 dd    	vpcmpeqb %ymm5,%ymm8,%k3
 15069d2:	62 f3 35 29 3e c9 01 	vpcmpltub %ymm1,%ymm9,%k1{%k1}
 15069d9:	c5 35 db ca          	vpand  %ymm2,%ymm9,%ymm9
 15069dd:	c4 e1 fd 45 d2       	kord   %k2,%k0,%k2
 15069e2:	c5 35 eb c6          	vpor   %ymm6,%ymm9,%ymm8
 15069e6:	62 51 7f 2b 6f c8    	vmovdqu8 %ymm8,%ymm9{%k3}
 15069ec:	c5 35 eb c7          	vpor   %ymm7,%ymm9,%ymm8
 15069f0:	62 51 7f 2a 6f c8    	vmovdqu8 %ymm8,%ymm9{%k2}
 15069f6:	c4 21 7e 7f 8c 02 00 20 00 00 	vmovdqu %ymm9,0x2000(%rdx,%r8,1)
 1506a00:	48 83 c2 20          	add    $0x20,%rdx
 1506a04:	48 81 fa a0 00 00 00 	cmp    $0xa0,%rdx
 1506a0b:	0f 85 2f fc ff ff    	jne    1506640 <run_backend_benchmark+0x4ed0>
 1506a11:	c4 e1 f9 98 c9       	kortestd %k1,%k1
 1506a16:	0f 92 05 23 0c 4f 0d 	setb   0xd4f0c23(%rip)        # e9f7640 <tier0_initialized>
 1506a1d:	0f 83 73 40 00 00    	jae    150aa96 <run_backend_benchmark+0x9326>
 1506a23:	48 8d bc 24 00 0d 00 00 	lea    0xd00(%rsp),%rdi
 1506a2b:	c5 f8 77             	vzeroupper
 1506a2e:	e8 1d 4f 00 00       	call   150b950 <tier0_tables_open>
 1506a33:	84 c0                	test   %al,%al
 1506a35:	0f 84 5b 40 00 00    	je     150aa96 <run_backend_benchmark+0x9326>
 1506a3b:	49 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r14
 1506a45:	ba 03 00 00 00       	mov    $0x3,%edx
 1506a4a:	b9 22 40 00 00       	mov    $0x4022,%ecx
 1506a4f:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 1506a55:	45 31 ed             	xor    %r13d,%r13d
 1506a58:	31 ff                	xor    %edi,%edi
 1506a5a:	45 31 c9             	xor    %r9d,%r9d
 1506a5d:	4c 89 f6             	mov    %r14,%rsi
 1506a60:	e8 db da 25 ff       	call   764540 <mmap@plt>
 1506a65:	48 89 84 24 60 01 00 00 	mov    %rax,0x160(%rsp)
 1506a6d:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 1506a71:	74 5e                	je     1506ad1 <run_backend_benchmark+0x5361>
 1506a73:	4c 8d a8 ff ff 20 00 	lea    0x20ffff(%rax),%r13
 1506a7a:	ba 0f 00 00 00       	mov    $0xf,%edx
 1506a7f:	48 89 c7             	mov    %rax,%rdi
 1506a82:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
 1506a89:	4c 89 eb             	mov    %r13,%rbx
 1506a8c:	48 29 c3             	sub    %rax,%rbx
 1506a8f:	48 8d 8b 00 00 ff ff 	lea    -0x10000(%rbx),%rcx
 1506a96:	48 89 de             	mov    %rbx,%rsi
 1506a99:	48 89 8c 24 38 01 00 00 	mov    %rcx,0x138(%rsp)
 1506aa1:	e8 4a da 25 ff       	call   7644f0 <madvise@plt>
 1506aa6:	4c 89 f6             	mov    %r14,%rsi
 1506aa9:	48 29 de             	sub    %rbx,%rsi
 1506aac:	ba 0e 00 00 00       	mov    $0xe,%edx
 1506ab1:	4c 89 ef             	mov    %r13,%rdi
 1506ab4:	e8 37 da 25 ff       	call   7644f0 <madvise@plt>
 1506ab9:	49 81 c5 00 00 ff ff 	add    $0xffffffffffff0000,%r13
 1506ac0:	49 8d 86 00 00 e0 ff 	lea    -0x200000(%r14),%rax
 1506ac7:	48 89 84 24 98 00 00 00 	mov    %rax,0x98(%rsp)
 1506acf:	eb 18                	jmp    1506ae9 <run_backend_benchmark+0x5379>
 1506ad1:	48 c7 84 24 38 01 00 00 00 00 00 00 	movq   $0x0,0x138(%rsp)
 1506add:	48 c7 84 24 98 00 00 00 00 00 00 00 	movq   $0x0,0x98(%rsp)
 1506ae9:	ba 03 00 00 00       	mov    $0x3,%edx
 1506aee:	b9 22 40 00 00       	mov    $0x4022,%ecx
 1506af3:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 1506af9:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1506afd:	c5 fd 7f 84 24 e0 01 00 00 	vmovdqa %ymm0,0x1e0(%rsp)
 1506b06:	31 ff                	xor    %edi,%edi
 1506b08:	4c 89 f6             	mov    %r14,%rsi
 1506b0b:	45 31 c9             	xor    %r9d,%r9d
 1506b0e:	4d 89 f4             	mov    %r14,%r12
 1506b11:	c5 f8 77             	vzeroupper
 1506b14:	e8 27 da 25 ff       	call   764540 <mmap@plt>
 1506b19:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 1506b1d:	74 65                	je     1506b84 <run_backend_benchmark+0x5414>
 1506b1f:	48 8d 98 ff ff 20 00 	lea    0x20ffff(%rax),%rbx
 1506b26:	ba 0f 00 00 00       	mov    $0xf,%edx
 1506b2b:	48 89 c7             	mov    %rax,%rdi
 1506b2e:	48 81 e3 00 00 e0 ff 	and    $0xffffffffffe00000,%rbx
 1506b35:	49 89 de             	mov    %rbx,%r14
 1506b38:	49 29 c6             	sub    %rax,%r14
 1506b3b:	4c 89 f6             	mov    %r14,%rsi
 1506b3e:	4d 8d be 00 00 ff ff 	lea    -0x10000(%r14),%r15
 1506b45:	e8 a6 d9 25 ff       	call   7644f0 <madvise@plt>
 1506b4a:	4c 89 e6             	mov    %r12,%rsi
 1506b4d:	4c 29 f6             	sub    %r14,%rsi
 1506b50:	ba 0e 00 00 00       	mov    $0xe,%edx
 1506b55:	48 89 df             	mov    %rbx,%rdi
 1506b58:	e8 93 d9 25 ff       	call   7644f0 <madvise@plt>
 1506b5d:	48 81 c3 00 00 ff ff 	add    $0xffffffffffff0000,%rbx
 1506b64:	49 8d 84 24 00 00 e0 ff 	lea    -0x200000(%r12),%rax
 1506b6c:	48 89 9c 24 e0 01 00 00 	mov    %rbx,0x1e0(%rsp)
 1506b74:	48 89 84 24 f0 01 00 00 	mov    %rax,0x1f0(%rsp)
 1506b7c:	4c 89 bc 24 f8 01 00 00 	mov    %r15,0x1f8(%rsp)
 1506b84:	49 bc 00 00 20 00 01 00 00 00 	movabs $0x100200000,%r12
 1506b8e:	ba 03 00 00 00       	mov    $0x3,%edx
 1506b93:	b9 22 40 00 00       	mov    $0x4022,%ecx
 1506b98:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 1506b9e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1506ba2:	c5 fd 7f 84 24 c0 01 00 00 	vmovdqa %ymm0,0x1c0(%rsp)
 1506bab:	31 ff                	xor    %edi,%edi
 1506bad:	45 31 c9             	xor    %r9d,%r9d
 1506bb0:	4c 89 e6             	mov    %r12,%rsi
 1506bb3:	c5 f8 77             	vzeroupper
 1506bb6:	e8 85 d9 25 ff       	call   764540 <mmap@plt>
 1506bbb:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 1506bbf:	74 65                	je     1506c26 <run_backend_benchmark+0x54b6>
 1506bc1:	48 8d 98 ff ff 20 00 	lea    0x20ffff(%rax),%rbx
 1506bc8:	ba 0f 00 00 00       	mov    $0xf,%edx
 1506bcd:	48 89 c7             	mov    %rax,%rdi
 1506bd0:	48 81 e3 00 00 e0 ff 	and    $0xffffffffffe00000,%rbx
 1506bd7:	49 89 de             	mov    %rbx,%r14
 1506bda:	49 29 c6             	sub    %rax,%r14
 1506bdd:	4c 89 f6             	mov    %r14,%rsi
 1506be0:	4d 8d be 00 00 ff ff 	lea    -0x10000(%r14),%r15
 1506be7:	e8 04 d9 25 ff       	call   7644f0 <madvise@plt>
 1506bec:	4c 89 e6             	mov    %r12,%rsi
 1506bef:	4c 29 f6             	sub    %r14,%rsi
 1506bf2:	ba 0e 00 00 00       	mov    $0xe,%edx
 1506bf7:	48 89 df             	mov    %rbx,%rdi
 1506bfa:	e8 f1 d8 25 ff       	call   7644f0 <madvise@plt>
 1506bff:	48 81 c3 00 00 ff ff 	add    $0xffffffffffff0000,%rbx
 1506c06:	49 8d 84 24 00 00 e0 ff 	lea    -0x200000(%r12),%rax
 1506c0e:	48 89 9c 24 c0 01 00 00 	mov    %rbx,0x1c0(%rsp)
 1506c16:	48 89 84 24 d0 01 00 00 	mov    %rax,0x1d0(%rsp)
 1506c1e:	4c 89 bc 24 d8 01 00 00 	mov    %r15,0x1d8(%rsp)
 1506c26:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 1506c2e:	49 8d 4d 07          	lea    0x7(%r13),%rcx
 1506c32:	31 db                	xor    %ebx,%ebx
 1506c34:	b8 00 00 00 00       	mov    $0x0,%eax
 1506c39:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1506c3d:	62 f1 fe 48 7f 44 24 06 	vmovdqu64 %zmm0,0x180(%rsp)
 1506c45:	62 f1 fe 48 7f 84 24 70 01 00 00 	vmovdqu64 %zmm0,0x170(%rsp)
 1506c50:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 1506c54:	48 89 ca             	mov    %rcx,%rdx
 1506c57:	4c 29 ea             	sub    %r13,%rdx
 1506c5a:	72 2c                	jb     1506c88 <run_backend_benchmark+0x5518>
 1506c5c:	4c 89 f0             	mov    %r14,%rax
 1506c5f:	48 29 d0             	sub    %rdx,%rax
 1506c62:	40 0f 92 c6          	setb   %sil
 1506c66:	48 3d 00 00 80 00    	cmp    $0x800000,%rax
 1506c6c:	0f 92 c0             	setb   %al
 1506c6f:	31 db                	xor    %ebx,%ebx
 1506c71:	40 08 f0             	or     %sil,%al
 1506c74:	b8 00 00 00 00       	mov    $0x0,%eax
 1506c79:	75 0d                	jne    1506c88 <run_backend_benchmark+0x5518>
 1506c7b:	48 81 c2 00 00 80 00 	add    $0x800000,%rdx
 1506c82:	48 89 c8             	mov    %rcx,%rax
 1506c85:	48 89 d3             	mov    %rdx,%rbx
 1506c88:	4a 8d 4c 2b 07       	lea    0x7(%rbx,%r13,1),%rcx
 1506c8d:	4a 8d 34 2b          	lea    (%rbx,%r13,1),%rsi
 1506c91:	48 89 84 24 68 01 00 00 	mov    %rax,0x168(%rsp)
 1506c99:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 1506c9d:	48 39 f1             	cmp    %rsi,%rcx
 1506ca0:	0f 83 1c 3c 00 00    	jae    150a8c2 <run_backend_benchmark+0x9152>
 1506ca6:	31 c9                	xor    %ecx,%ecx
 1506ca8:	48 89 ca             	mov    %rcx,%rdx
 1506cab:	31 c9                	xor    %ecx,%ecx
 1506cad:	48 c7 84 24 78 01 00 00 00 00 00 00 	movq   $0x0,0x178(%rsp)
 1506cb9:	48 89 ce             	mov    %rcx,%rsi
 1506cbc:	31 c9                	xor    %ecx,%ecx
 1506cbe:	48 c7 84 24 80 01 00 00 00 00 00 00 	movq   $0x0,0x180(%rsp)
 1506cca:	49 89 c8             	mov    %rcx,%r8
 1506ccd:	48 c7 84 24 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rsp)
 1506cd9:	31 c9                	xor    %ecx,%ecx
 1506cdb:	45 31 c9             	xor    %r9d,%r9d
 1506cde:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 1506ce4:	4c 89 8c 24 90 01 00 00 	mov    %r9,0x190(%rsp)
 1506cec:	48 85 c0             	test   %rax,%rax
 1506cef:	0f 84 d6 3e 00 00    	je     150abcb <run_backend_benchmark+0x945b>
 1506cf5:	48 85 d2             	test   %rdx,%rdx
 1506cf8:	0f 84 cd 3e 00 00    	je     150abcb <run_backend_benchmark+0x945b>
 1506cfe:	48 85 f6             	test   %rsi,%rsi
 1506d01:	0f 84 c4 3e 00 00    	je     150abcb <run_backend_benchmark+0x945b>
 1506d07:	4d 85 c0             	test   %r8,%r8
 1506d0a:	0f 84 bb 3e 00 00    	je     150abcb <run_backend_benchmark+0x945b>
 1506d10:	48 85 c9             	test   %rcx,%rcx
 1506d13:	0f 84 b2 3e 00 00    	je     150abcb <run_backend_benchmark+0x945b>
 1506d19:	4d 85 c9             	test   %r9,%r9
 1506d1c:	0f 84 a9 3e 00 00    	je     150abcb <run_backend_benchmark+0x945b>
 1506d22:	48 c7 84 24 d8 00 00 00 00 00 00 00 	movq   $0x0,0xd8(%rsp)
 1506d2e:	4c 89 6c 24 50       	mov    %r13,0x50(%rsp)
 1506d33:	4a 8d 74 2b 07       	lea    0x7(%rbx,%r13,1),%rsi
 1506d38:	4c 01 eb             	add    %r13,%rbx
 1506d3b:	48 83 e6 f8          	and    $0xfffffffffffffff8,%rsi
 1506d3f:	48 39 de             	cmp    %rbx,%rsi
 1506d42:	0f 82 83 3e 00 00    	jb     150abcb <run_backend_benchmark+0x945b>
 1506d48:	48 89 df             	mov    %rbx,%rdi
 1506d4b:	48 89 f3             	mov    %rsi,%rbx
 1506d4e:	4c 29 eb             	sub    %r13,%rbx
 1506d51:	4c 89 f0             	mov    %r14,%rax
 1506d54:	48 29 d8             	sub    %rbx,%rax
 1506d57:	0f 92 c1             	setb   %cl
 1506d5a:	48 3d a0 0d 00 00    	cmp    $0xda0,%rax
 1506d60:	0f 92 c2             	setb   %dl
 1506d63:	08 ca                	or     %cl,%dl
 1506d65:	74 0a                	je     1506d71 <run_backend_benchmark+0x5601>
 1506d67:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 1506d6c:	45 31 c0             	xor    %r8d,%r8d
 1506d6f:	eb 2f                	jmp    1506da0 <run_backend_benchmark+0x5630>
 1506d71:	48 81 c7 a7 0d 00 00 	add    $0xda7,%rdi
 1506d78:	48 8d 86 a0 0d 00 00 	lea    0xda0(%rsi),%rax
 1506d7f:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 1506d83:	48 39 c7             	cmp    %rax,%rdi
 1506d86:	0f 82 3f 3e 00 00    	jb     150abcb <run_backend_benchmark+0x945b>
 1506d8c:	48 89 fb             	mov    %rdi,%rbx
 1506d8f:	4c 29 eb             	sub    %r13,%rbx
 1506d92:	4c 89 f0             	mov    %r14,%rax
 1506d95:	49 89 f0             	mov    %rsi,%r8
 1506d98:	48 89 7c 24 58       	mov    %rdi,0x58(%rsp)
 1506d9d:	48 29 d8             	sub    %rbx,%rax
 1506da0:	4c 39 f3             	cmp    %r14,%rbx
 1506da3:	0f 87 22 3e 00 00    	ja     150abcb <run_backend_benchmark+0x945b>
 1506da9:	48 3d 58 3a 00 00    	cmp    $0x3a58,%rax
 1506daf:	0f 82 16 3e 00 00    	jb     150abcb <run_backend_benchmark+0x945b>
 1506db5:	4d 85 c0             	test   %r8,%r8
 1506db8:	0f 84 0d 3e 00 00    	je     150abcb <run_backend_benchmark+0x945b>
 1506dbe:	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
 1506dc4:	0f 84 01 3e 00 00    	je     150abcb <run_backend_benchmark+0x945b>
 1506dca:	48 8b 84 24 48 01 00 00 	mov    0x148(%rsp),%rax
 1506dd2:	48 8b 8c 24 d8 00 00 00 	mov    0xd8(%rsp),%rcx
 1506dda:	49 8d 78 18          	lea    0x18(%r8),%rdi
 1506dde:	ba 88 0d 00 00       	mov    $0xd88,%edx
 1506de3:	31 f6                	xor    %esi,%esi
 1506de5:	4c 8d b3 58 3a 00 00 	lea    0x3a58(%rbx),%r14
 1506dec:	4c 89 84 24 80 00 00 00 	mov    %r8,0x80(%rsp)
 1506df4:	4c 8d 3c 01          	lea    (%rcx,%rax,1),%r15
 1506df8:	c5 f8 77             	vzeroupper
 1506dfb:	e8 30 d5 25 ff       	call   764330 <memset@plt>
 1506e00:	48 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%rax
 1506e08:	48 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%rsi
 1506e10:	4e 8d 8c 2b 58 3a 00 00 	lea    0x3a58(%rbx,%r13,1),%r9
 1506e18:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 1506e20:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 1506e28:	4c 89 bc 24 30 01 00 00 	mov    %r15,0x130(%rsp)
 1506e30:	4c 29 f0             	sub    %r14,%rax
 1506e33:	41 c7 82 70 0d 00 00 08 00 00 00 	movl   $0x8,0xd70(%r10)
 1506e3e:	66 41 c7 82 99 0d 00 00 00 00 	movw   $0x0,0xd99(%r10)
 1506e48:	41 c6 82 9b 0d 00 00 00 	movb   $0x0,0xd9b(%r10)
 1506e50:	41 c7 42 1c 00 9c 00 00 	movl   $0x9c00,0x1c(%r10)
 1506e58:	41 c7 42 4c 00 02 00 00 	movl   $0x200,0x4c(%r10)
 1506e60:	41 c7 42 7c 08 01 00 00 	movl   $0x108,0x7c(%r10)
 1506e68:	41 c7 82 94 00 00 00 00 21 00 00 	movl   $0x2100,0x94(%r10)
 1506e73:	49 c7 82 88 0d 00 00 00 a0 0f 00 	movq   $0xfa000,0xd88(%r10)
 1506e7e:	0f 92 c1             	setb   %cl
 1506e81:	48 3d 00 9c 00 00    	cmp    $0x9c00,%rax
 1506e87:	0f 92 c0             	setb   %al
 1506e8a:	48 81 c3 58 d6 00 00 	add    $0xd658,%rbx
 1506e91:	08 c8                	or     %cl,%al
 1506e93:	84 c0                	test   %al,%al
 1506e95:	48 89 f0             	mov    %rsi,%rax
 1506e98:	49 0f 45 de          	cmovne %r14,%rbx
 1506e9c:	41 be 00 00 00 00    	mov    $0x0,%r14d
 1506ea2:	4d 0f 45 ce          	cmovne %r14,%r9
 1506ea6:	48 29 d8             	sub    %rbx,%rax
 1506ea9:	4e 8d 1c 2b          	lea    (%rbx,%r13,1),%r11
 1506ead:	0f 92 c1             	setb   %cl
 1506eb0:	48 3d 00 9c 00 00    	cmp    $0x9c00,%rax
 1506eb6:	48 8d 83 00 9c 00 00 	lea    0x9c00(%rbx),%rax
 1506ebd:	4d 89 0a             	mov    %r9,(%r10)
 1506ec0:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 1506ec5:	0f 92 c2             	setb   %dl
 1506ec8:	08 ca                	or     %cl,%dl
 1506eca:	84 d2                	test   %dl,%dl
 1506ecc:	48 0f 45 c3          	cmovne %rbx,%rax
 1506ed0:	4d 0f 45 de          	cmovne %r14,%r11
 1506ed4:	4a 8d 5c 28 07       	lea    0x7(%rax,%r13,1),%rbx
 1506ed9:	4a 8d 14 28          	lea    (%rax,%r13,1),%rdx
 1506edd:	4d 89 5a 08          	mov    %r11,0x8(%r10)
 1506ee1:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
 1506ee5:	48 39 d3             	cmp    %rdx,%rbx
 1506ee8:	72 20                	jb     1506f0a <run_backend_benchmark+0x579a>
 1506eea:	48 89 d9             	mov    %rbx,%rcx
 1506eed:	4c 29 e9             	sub    %r13,%rcx
 1506ef0:	48 89 f7             	mov    %rsi,%rdi
 1506ef3:	48 29 cf             	sub    %rcx,%rdi
 1506ef6:	41 0f 92 c0          	setb   %r8b
 1506efa:	48 81 ff 00 e0 04 00 	cmp    $0x4e000,%rdi
 1506f01:	40 0f 92 c7          	setb   %dil
 1506f05:	44 08 c7             	or     %r8b,%dil
 1506f08:	74 04                	je     1506f0e <run_backend_benchmark+0x579e>
 1506f0a:	31 db                	xor    %ebx,%ebx
 1506f0c:	eb 14                	jmp    1506f22 <run_backend_benchmark+0x57b2>
 1506f0e:	48 89 da             	mov    %rbx,%rdx
 1506f11:	48 81 c1 00 e0 04 00 	add    $0x4e000,%rcx
 1506f18:	48 81 c2 00 e0 04 00 	add    $0x4e000,%rdx
 1506f1f:	48 89 c8             	mov    %rcx,%rax
 1506f22:	48 89 f1             	mov    %rsi,%rcx
 1506f25:	48 29 c1             	sub    %rax,%rcx
 1506f28:	49 89 5a 10          	mov    %rbx,0x10(%r10)
 1506f2c:	4c 89 9c 24 b0 00 00 00 	mov    %r11,0xb0(%rsp)
 1506f34:	48 89 5c 24 60       	mov    %rbx,0x60(%rsp)
 1506f39:	40 0f 92 c7          	setb   %dil
 1506f3d:	48 81 f9 00 02 00 00 	cmp    $0x200,%rcx
 1506f44:	0f 92 c1             	setb   %cl
 1506f47:	40 08 f9             	or     %dil,%cl
 1506f4a:	48 8d b8 00 02 00 00 	lea    0x200(%rax),%rdi
 1506f51:	84 c9                	test   %cl,%cl
 1506f53:	48 0f 45 f8          	cmovne %rax,%rdi
 1506f57:	49 0f 45 d6          	cmovne %r14,%rdx
 1506f5b:	48 89 f0             	mov    %rsi,%rax
 1506f5e:	48 29 f8             	sub    %rdi,%rax
 1506f61:	4e 8d 3c 2f          	lea    (%rdi,%r13,1),%r15
 1506f65:	49 89 52 20          	mov    %rdx,0x20(%r10)
 1506f69:	0f 92 c1             	setb   %cl
 1506f6c:	48 3d 00 02 00 00    	cmp    $0x200,%rax
 1506f72:	48 8d 87 00 02 00 00 	lea    0x200(%rdi),%rax
 1506f79:	41 0f 92 c0          	setb   %r8b
 1506f7d:	41 08 c8             	or     %cl,%r8b
 1506f80:	45 84 c0             	test   %r8b,%r8b
 1506f83:	48 0f 45 c7          	cmovne %rdi,%rax
 1506f87:	4d 0f 45 fe          	cmovne %r14,%r15
 1506f8b:	4e 8d 4c 28 03       	lea    0x3(%rax,%r13,1),%r9
 1506f90:	4e 8d 04 28          	lea    (%rax,%r13,1),%r8
 1506f94:	4d 89 7a 28          	mov    %r15,0x28(%r10)
 1506f98:	4c 89 7c 24 78       	mov    %r15,0x78(%rsp)
 1506f9d:	49 83 e1 fc          	and    $0xfffffffffffffffc,%r9
 1506fa1:	4d 39 c1             	cmp    %r8,%r9
 1506fa4:	73 05                	jae    1506fab <run_backend_benchmark+0x583b>
 1506fa6:	45 31 c9             	xor    %r9d,%r9d
 1506fa9:	eb 41                	jmp    1506fec <run_backend_benchmark+0x587c>
 1506fab:	4c 89 c9             	mov    %r9,%rcx
 1506fae:	4c 29 e9             	sub    %r13,%rcx
 1506fb1:	48 89 f7             	mov    %rsi,%rdi
 1506fb4:	48 29 cf             	sub    %rcx,%rdi
 1506fb7:	41 0f 92 c2          	setb   %r10b
 1506fbb:	48 81 ff 00 08 00 00 	cmp    $0x800,%rdi
 1506fc2:	40 0f 92 c7          	setb   %dil
 1506fc6:	44 08 d7             	or     %r10b,%dil
 1506fc9:	74 05                	je     1506fd0 <run_backend_benchmark+0x5860>
 1506fcb:	45 31 c9             	xor    %r9d,%r9d
 1506fce:	eb 14                	jmp    1506fe4 <run_backend_benchmark+0x5874>
 1506fd0:	4d 89 c8             	mov    %r9,%r8
 1506fd3:	48 81 c1 00 08 00 00 	add    $0x800,%rcx
 1506fda:	49 81 c0 00 08 00 00 	add    $0x800,%r8
 1506fe1:	48 89 c8             	mov    %rcx,%rax
 1506fe4:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 1506fec:	48 89 f1             	mov    %rsi,%rcx
 1506fef:	48 29 c1             	sub    %rax,%rcx
 1506ff2:	4c 8d b8 00 02 00 00 	lea    0x200(%rax),%r15
 1506ff9:	4d 89 4a 30          	mov    %r9,0x30(%r10)
 1506ffd:	40 0f 92 c7          	setb   %dil
 1507001:	48 81 f9 00 02 00 00 	cmp    $0x200,%rcx
 1507008:	0f 92 c1             	setb   %cl
 150700b:	40 08 f9             	or     %dil,%cl
 150700e:	84 c9                	test   %cl,%cl
 1507010:	4c 0f 45 f8          	cmovne %rax,%r15
 1507014:	4d 0f 45 c6          	cmovne %r14,%r8
 1507018:	4f 8d 5c 2f 03       	lea    0x3(%r15,%r13,1),%r11
 150701d:	4d 89 42 38          	mov    %r8,0x38(%r10)
 1507021:	4f 8d 14 2f          	lea    (%r15,%r13,1),%r10
 1507025:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 1507029:	4c 89 d8             	mov    %r11,%rax
 150702c:	4c 29 e8             	sub    %r13,%rax
 150702f:	4d 39 d3             	cmp    %r10,%r11
 1507032:	72 19                	jb     150704d <run_backend_benchmark+0x58dd>
 1507034:	48 89 f1             	mov    %rsi,%rcx
 1507037:	48 29 c1             	sub    %rax,%rcx
 150703a:	40 0f 92 c7          	setb   %dil
 150703e:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 1507045:	0f 92 c1             	setb   %cl
 1507048:	40 08 f9             	or     %dil,%cl
 150704b:	74 15                	je     1507062 <run_backend_benchmark+0x58f2>
 150704d:	31 db                	xor    %ebx,%ebx
 150704f:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 1507057:	48 89 59 50          	mov    %rbx,0x50(%rcx)
 150705b:	4d 39 d3             	cmp    %r10,%r11
 150705e:	72 5a                	jb     15070ba <run_backend_benchmark+0x594a>
 1507060:	eb 3f                	jmp    15070a1 <run_backend_benchmark+0x5931>
 1507062:	49 81 c2 23 04 00 00 	add    $0x423,%r10
 1507069:	49 89 c7             	mov    %rax,%r15
 150706c:	4c 89 d9             	mov    %r11,%rcx
 150706f:	49 81 c7 20 04 00 00 	add    $0x420,%r15
 1507076:	48 81 c1 20 04 00 00 	add    $0x420,%rcx
 150707d:	4c 89 db             	mov    %r11,%rbx
 1507080:	49 83 e2 fc          	and    $0xfffffffffffffffc,%r10
 1507084:	4c 89 d0             	mov    %r10,%rax
 1507087:	4c 29 e8             	sub    %r13,%rax
 150708a:	4d 89 d3             	mov    %r10,%r11
 150708d:	49 89 ca             	mov    %rcx,%r10
 1507090:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 1507098:	48 89 59 50          	mov    %rbx,0x50(%rcx)
 150709c:	4d 39 d3             	cmp    %r10,%r11
 150709f:	72 19                	jb     15070ba <run_backend_benchmark+0x594a>
 15070a1:	48 89 f1             	mov    %rsi,%rcx
 15070a4:	48 29 c1             	sub    %rax,%rcx
 15070a7:	40 0f 92 c7          	setb   %dil
 15070ab:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 15070b2:	0f 92 c1             	setb   %cl
 15070b5:	40 08 f9             	or     %dil,%cl
 15070b8:	74 05                	je     15070bf <run_backend_benchmark+0x594f>
 15070ba:	45 31 e4             	xor    %r12d,%r12d
 15070bd:	eb 24                	jmp    15070e3 <run_backend_benchmark+0x5973>
 15070bf:	4d 89 dc             	mov    %r11,%r12
 15070c2:	4e 8d 9c 28 23 04 00 00 	lea    0x423(%rax,%r13,1),%r11
 15070ca:	4e 8d 94 28 20 04 00 00 	lea    0x420(%rax,%r13,1),%r10
 15070d2:	4c 8d b8 20 04 00 00 	lea    0x420(%rax),%r15
 15070d9:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 15070dd:	4c 89 d8             	mov    %r11,%rax
 15070e0:	4c 29 e8             	sub    %r13,%rax
 15070e3:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 15070eb:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 15070f0:	48 89 5c 24 70       	mov    %rbx,0x70(%rsp)
 15070f5:	4c 89 a4 24 c0 00 00 00 	mov    %r12,0xc0(%rsp)
 15070fd:	4c 89 61 58          	mov    %r12,0x58(%rcx)
 1507101:	4d 39 d3             	cmp    %r10,%r11
 1507104:	72 19                	jb     150711f <run_backend_benchmark+0x59af>
 1507106:	48 89 f1             	mov    %rsi,%rcx
 1507109:	48 29 c1             	sub    %rax,%rcx
 150710c:	40 0f 92 c7          	setb   %dil
 1507110:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 1507117:	0f 92 c1             	setb   %cl
 150711a:	40 08 f9             	or     %dil,%cl
 150711d:	74 05                	je     1507124 <run_backend_benchmark+0x59b4>
 150711f:	45 31 db             	xor    %r11d,%r11d
 1507122:	eb 11                	jmp    1507135 <run_backend_benchmark+0x59c5>
 1507124:	4e 8d 94 28 20 04 00 00 	lea    0x420(%rax,%r13,1),%r10
 150712c:	48 05 20 04 00 00    	add    $0x420,%rax
 1507132:	49 89 c7             	mov    %rax,%r15
 1507135:	48 89 f0             	mov    %rsi,%rax
 1507138:	4c 29 f8             	sub    %r15,%rax
 150713b:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 1507143:	4c 89 84 24 90 00 00 00 	mov    %r8,0x90(%rsp)
 150714b:	0f 92 c1             	setb   %cl
 150714e:	48 3d 08 01 00 00    	cmp    $0x108,%rax
 1507154:	49 8d 87 08 01 00 00 	lea    0x108(%r15),%rax
 150715b:	40 0f 92 c7          	setb   %dil
 150715f:	40 08 cf             	or     %cl,%dil
 1507162:	40 84 ff             	test   %dil,%dil
 1507165:	49 0f 45 c7          	cmovne %r15,%rax
 1507169:	4d 0f 45 d6          	cmovne %r14,%r10
 150716d:	4c 89 5a 60          	mov    %r11,0x60(%rdx)
 1507171:	4e 8d 7c 28 03       	lea    0x3(%rax,%r13,1),%r15
 1507176:	4e 8d 24 28          	lea    (%rax,%r13,1),%r12
 150717a:	4c 89 52 68          	mov    %r10,0x68(%rdx)
 150717e:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 1507182:	4d 39 e7             	cmp    %r12,%r15
 1507185:	72 1f                	jb     15071a6 <run_backend_benchmark+0x5a36>
 1507187:	4c 89 f9             	mov    %r15,%rcx
 150718a:	4c 29 e9             	sub    %r13,%rcx
 150718d:	48 89 f7             	mov    %rsi,%rdi
 1507190:	48 29 cf             	sub    %rcx,%rdi
 1507193:	0f 92 c3             	setb   %bl
 1507196:	48 81 ff 20 04 00 00 	cmp    $0x420,%rdi
 150719d:	40 0f 92 c7          	setb   %dil
 15071a1:	40 08 df             	or     %bl,%dil
 15071a4:	74 05                	je     15071ab <run_backend_benchmark+0x5a3b>
 15071a6:	45 31 ff             	xor    %r15d,%r15d
 15071a9:	eb 14                	jmp    15071bf <run_backend_benchmark+0x5a4f>
 15071ab:	4d 89 fc             	mov    %r15,%r12
 15071ae:	48 81 c1 20 04 00 00 	add    $0x420,%rcx
 15071b5:	49 81 c4 20 04 00 00 	add    $0x420,%r12
 15071bc:	48 89 c8             	mov    %rcx,%rax
 15071bf:	48 89 f1             	mov    %rsi,%rcx
 15071c2:	48 29 c1             	sub    %rax,%rcx
 15071c5:	4c 89 ea             	mov    %r13,%rdx
 15071c8:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 15071d0:	40 0f 92 c7          	setb   %dil
 15071d4:	48 81 f9 00 21 00 00 	cmp    $0x2100,%rcx
 15071db:	0f 92 c1             	setb   %cl
 15071de:	40 08 f9             	or     %dil,%cl
 15071e1:	48 8d b8 00 21 00 00 	lea    0x2100(%rax),%rdi
 15071e8:	84 c9                	test   %cl,%cl
 15071ea:	48 0f 45 f8          	cmovne %rax,%rdi
 15071ee:	4d 0f 45 e6          	cmovne %r14,%r12
 15071f2:	48 89 f0             	mov    %rsi,%rax
 15071f5:	4d 89 78 70          	mov    %r15,0x70(%r8)
 15071f9:	48 29 f8             	sub    %rdi,%rax
 15071fc:	4e 8d 2c 2f          	lea    (%rdi,%r13,1),%r13
 1507200:	4d 89 a0 80 00 00 00 	mov    %r12,0x80(%r8)
 1507207:	0f 92 c1             	setb   %cl
 150720a:	48 3d 00 21 00 00    	cmp    $0x2100,%rax
 1507210:	0f 92 c0             	setb   %al
 1507213:	08 c8                	or     %cl,%al
 1507215:	48 8d 8f 00 21 00 00 	lea    0x2100(%rdi),%rcx
 150721c:	84 c0                	test   %al,%al
 150721e:	48 89 f0             	mov    %rsi,%rax
 1507221:	48 0f 45 cf          	cmovne %rdi,%rcx
 1507225:	4d 0f 45 ee          	cmovne %r14,%r13
 1507229:	48 29 c8             	sub    %rcx,%rax
 150722c:	4c 8d b1 00 02 00 00 	lea    0x200(%rcx),%r14
 1507233:	4d 89 a8 88 00 00 00 	mov    %r13,0x88(%r8)
 150723a:	40 0f 92 c7          	setb   %dil
 150723e:	48 3d 00 02 00 00    	cmp    $0x200,%rax
 1507244:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 1507248:	0f 92 c3             	setb   %bl
 150724b:	40 08 fb             	or     %dil,%bl
 150724e:	31 ff                	xor    %edi,%edi
 1507250:	84 db                	test   %bl,%bl
 1507252:	4c 0f 45 f1          	cmovne %rcx,%r14
 1507256:	48 0f 45 c7          	cmovne %rdi,%rax
 150725a:	49 8d 4c 16 07       	lea    0x7(%r14,%rdx,1),%rcx
 150725f:	49 8d 3c 16          	lea    (%r14,%rdx,1),%rdi
 1507263:	49 89 40 40          	mov    %rax,0x40(%r8)
 1507267:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 150726b:	48 39 f9             	cmp    %rdi,%rcx
 150726e:	72 1f                	jb     150728f <run_backend_benchmark+0x5b1f>
 1507270:	48 89 cb             	mov    %rcx,%rbx
 1507273:	48 29 d3             	sub    %rdx,%rbx
 1507276:	48 89 f2             	mov    %rsi,%rdx
 1507279:	48 29 da             	sub    %rbx,%rdx
 150727c:	40 0f 92 c6          	setb   %sil
 1507280:	48 81 fa 00 20 00 00 	cmp    $0x2000,%rdx
 1507287:	0f 92 c2             	setb   %dl
 150728a:	40 08 f2             	or     %sil,%dl
 150728d:	74 04                	je     1507293 <run_backend_benchmark+0x5b23>
 150728f:	31 c9                	xor    %ecx,%ecx
 1507291:	eb 14                	jmp    15072a7 <run_backend_benchmark+0x5b37>
 1507293:	48 89 cf             	mov    %rcx,%rdi
 1507296:	48 81 c3 00 20 00 00 	add    $0x2000,%rbx
 150729d:	48 81 c7 00 20 00 00 	add    $0x2000,%rdi
 15072a4:	49 89 de             	mov    %rbx,%r14
 15072a7:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 15072af:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 15072b7:	4c 29 f2             	sub    %r14,%rdx
 15072ba:	49 89 88 d8 01 00 00 	mov    %rcx,0x1d8(%r8)
 15072c1:	40 0f 92 c6          	setb   %sil
 15072c5:	48 81 fa 00 a0 0f 00 	cmp    $0xfa000,%rdx
 15072cc:	0f 92 c2             	setb   %dl
 15072cf:	40 08 f2             	or     %sil,%dl
 15072d2:	49 8d b6 00 a0 0f 00 	lea    0xfa000(%r14),%rsi
 15072d9:	84 d2                	test   %dl,%dl
 15072db:	49 0f 45 f6          	cmovne %r14,%rsi
 15072df:	41 be 00 00 00 00    	mov    $0x0,%r14d
 15072e5:	4c 0f 44 f7          	cmove  %rdi,%r14
 15072e9:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 15072ef:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 15072f7:	4d 89 b0 78 0d 00 00 	mov    %r14,0xd78(%r8)
 15072fe:	0f 84 78 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 1507304:	48 83 bc 24 b0 00 00 00 00 	cmpq   $0x0,0xb0(%rsp)
 150730d:	0f 84 69 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 1507313:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
 1507319:	0f 84 5d 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 150731f:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
 1507325:	0f 84 51 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 150732b:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 1507331:	0f 84 45 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 1507337:	4d 85 c9             	test   %r9,%r9
 150733a:	0f 84 3c 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 1507340:	48 83 bc 24 90 00 00 00 00 	cmpq   $0x0,0x90(%rsp)
 1507349:	0f 84 2d 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 150734f:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 1507355:	0f 84 21 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 150735b:	48 83 bc 24 c0 00 00 00 00 	cmpq   $0x0,0xc0(%rsp)
 1507364:	0f 84 12 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 150736a:	4d 85 db             	test   %r11,%r11
 150736d:	0f 84 09 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 1507373:	4d 85 d2             	test   %r10,%r10
 1507376:	0f 84 00 38 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 150737c:	4d 85 e4             	test   %r12,%r12
 150737f:	0f 84 f7 37 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 1507385:	48 85 c0             	test   %rax,%rax
 1507388:	0f 84 ee 37 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 150738e:	4d 85 ed             	test   %r13,%r13
 1507391:	0f 84 e5 37 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 1507397:	4d 85 ff             	test   %r15,%r15
 150739a:	0f 84 dc 37 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 15073a0:	48 85 c9             	test   %rcx,%rcx
 15073a3:	0f 84 d3 37 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 15073a9:	4d 85 f6             	test   %r14,%r14
 15073ac:	0f 84 ca 37 00 00    	je     150ab7c <run_backend_benchmark+0x940c>
 15073b2:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 15073ba:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 15073c4:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 15073ce:	c6 07 00             	movb   $0x0,(%rdi)
 15073d1:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 15073d9:	45 31 c9             	xor    %r9d,%r9d
 15073dc:	4c 8d 2c 01          	lea    (%rcx,%rax,1),%r13
 15073e0:	48 c7 87 90 0d 00 00 00 00 00 00 	movq   $0x0,0xd90(%rdi)
 15073eb:	c6 87 ec 02 00 00 00 	movb   $0x0,0x2ec(%rdi)
 15073f2:	4c 89 e8             	mov    %r13,%rax
 15073f5:	48 c1 e8 1e          	shr    $0x1e,%rax
 15073f9:	4c 31 e8             	xor    %r13,%rax
 15073fc:	49 0f af c4          	imul   %r12,%rax
 1507400:	48 89 c1             	mov    %rax,%rcx
 1507403:	48 c1 e9 1b          	shr    $0x1b,%rcx
 1507407:	48 31 c1             	xor    %rax,%rcx
 150740a:	48 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%rax
 1507414:	48 0f af c8          	imul   %rax,%rcx
 1507418:	48 b8 8f e3 38 8e e3 38 8e e3 	movabs $0xe38e38e38e38e38f,%rax
 1507422:	48 89 ca             	mov    %rcx,%rdx
 1507425:	48 c1 ea 1f          	shr    $0x1f,%rdx
 1507429:	48 31 ca             	xor    %rcx,%rdx
 150742c:	c4 e2 fb f6 c0       	mulx   %rax,%rax,%rax
 1507431:	48 c1 e8 03          	shr    $0x3,%rax
 1507435:	8d 04 c0             	lea    (%rax,%rax,8),%eax
 1507438:	29 c2                	sub    %eax,%edx
 150743a:	48 8d 87 ed 02 00 00 	lea    0x2ed(%rdi),%rax
 1507441:	83 c2 04             	add    $0x4,%edx
 1507444:	48 89 84 24 d0 00 00 00 	mov    %rax,0xd0(%rsp)
 150744c:	89 97 e4 02 00 00    	mov    %edx,0x2e4(%rdi)
 1507452:	eb 4f                	jmp    15074a3 <run_backend_benchmark+0x5d33>
 1507454:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1507460:	4d 89 fd             	mov    %r15,%r13
 1507463:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
 1507468:	48 8d 35 90 3c 0e ff 	lea    -0xf1c370(%rip),%rsi        # 5eb0ff <foreign_touch.flags+0x17bd2>
 150746f:	48 8d 05 36 e2 18 ff 	lea    -0xe71dca(%rip),%rax        # 6956ac <pp_string_value.meaning+0x38460>
 1507476:	4c 89 f7             	mov    %r14,%rdi
 1507479:	48 0f 45 f0          	cmovne %rax,%rsi
 150747d:	31 c0                	xor    %eax,%eax
 150747f:	e8 ec ed 01 00       	call   1526270 <tier0_text>
 1507484:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 150748c:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 1507491:	8b 87 e4 02 00 00    	mov    0x2e4(%rdi),%eax
 1507497:	49 ff c1             	inc    %r9
 150749a:	49 39 c1             	cmp    %rax,%r9
 150749d:	0f 83 a8 07 00 00    	jae    1507c4b <run_backend_benchmark+0x64db>
 15074a3:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 15074ad:	48 be eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%rsi
 15074b7:	4d 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%r15
 15074bc:	4c 89 f8             	mov    %r15,%rax
 15074bf:	48 c1 e8 1e          	shr    $0x1e,%rax
 15074c3:	4c 31 f8             	xor    %r15,%rax
 15074c6:	49 0f af c4          	imul   %r12,%rax
 15074ca:	48 89 c1             	mov    %rax,%rcx
 15074cd:	48 c1 e9 1b          	shr    $0x1b,%rcx
 15074d1:	48 31 c1             	xor    %rax,%rcx
 15074d4:	48 0f af ce          	imul   %rsi,%rcx
 15074d8:	48 89 c8             	mov    %rcx,%rax
 15074db:	48 c1 e8 1f          	shr    $0x1f,%rax
 15074df:	48 31 c8             	xor    %rcx,%rax
 15074e2:	48 b9 25 49 92 24 49 92 24 49 	movabs $0x4924924924924925,%rcx
 15074ec:	48 89 c2             	mov    %rax,%rdx
 15074ef:	48 d1 ea             	shr    $1,%rdx
 15074f2:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 15074f7:	48 d1 e9             	shr    $1,%rcx
 15074fa:	48 89 ca             	mov    %rcx,%rdx
 15074fd:	48 c1 e2 04          	shl    $0x4,%rdx
 1507501:	48 01 c9             	add    %rcx,%rcx
 1507504:	48 29 d1             	sub    %rdx,%rcx
 1507507:	48 01 c1             	add    %rax,%rcx
 150750a:	48 8d 05 bf d0 01 ff 	lea    -0xfe2f41(%rip),%rax        # 5245d0 <tier0_generate_class.classes>
 1507511:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
 1507515:	0f b6 d8             	movzbl %al,%ebx
 1507518:	8d 4b fb             	lea    -0x5(%rbx),%ecx
 150751b:	83 f9 04             	cmp    $0x4,%ecx
 150751e:	72 09                	jb     1507529 <run_backend_benchmark+0x5db9>
 1507520:	83 fb 0a             	cmp    $0xa,%ebx
 1507523:	0f 85 47 02 00 00    	jne    1507770 <run_backend_benchmark+0x6000>
 1507529:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 1507533:	49 01 cd             	add    %rcx,%r13
 1507536:	4c 89 e9             	mov    %r13,%rcx
 1507539:	48 c1 e9 1e          	shr    $0x1e,%rcx
 150753d:	4d 89 ef             	mov    %r13,%r15
 1507540:	4c 31 e9             	xor    %r13,%rcx
 1507543:	49 0f af cc          	imul   %r12,%rcx
 1507547:	48 89 ca             	mov    %rcx,%rdx
 150754a:	48 c1 ea 1b          	shr    $0x1b,%rdx
 150754e:	48 31 ca             	xor    %rcx,%rdx
 1507551:	48 0f af d6          	imul   %rsi,%rdx
 1507555:	48 be c3 f5 28 5c 8f c2 f5 28 	movabs $0x28f5c28f5c28f5c3,%rsi
 150755f:	48 89 d1             	mov    %rdx,%rcx
 1507562:	48 c1 e9 1f          	shr    $0x1f,%rcx
 1507566:	48 31 d1             	xor    %rdx,%rcx
 1507569:	48 89 ca             	mov    %rcx,%rdx
 150756c:	48 c1 ea 02          	shr    $0x2,%rdx
 1507570:	c4 e2 eb f6 d6       	mulx   %rsi,%rdx,%rdx
 1507575:	42 88 84 0f 98 00 00 00 	mov    %al,0x98(%rdi,%r9,1)
 150757d:	b8 01 00 00 00       	mov    $0x1,%eax
 1507582:	48 c1 ea 02          	shr    $0x2,%rdx
 1507586:	48 6b d2 64          	imul   $0x64,%rdx,%rdx
 150758a:	48 29 d1             	sub    %rdx,%rcx
 150758d:	48 83 f9 1e          	cmp    $0x1e,%rcx
 1507591:	b9 10 00 00 00       	mov    $0x10,%ecx
 1507596:	0f 92 c2             	setb   %dl
 1507599:	0f 42 c1             	cmovb  %ecx,%eax
 150759c:	41 89 d5             	mov    %edx,%r13d
 150759f:	42 89 84 8f d8 00 00 00 	mov    %eax,0xd8(%rdi,%r9,4)
 15075a7:	48 8d 35 be d2 17 ff 	lea    -0xe82d42(%rip),%rsi        # 68486c <pp_string_value.meaning+0x27620>
 15075ae:	48 8d 15 84 bf 07 ff 	lea    -0xf8407c(%rip),%rdx        # 583539 <c_fragment_reader_cursor_tests.leaf_phases+0x105>
 15075b5:	4c 8d 05 64 6e 1c ff 	lea    -0xe3919c(%rip),%r8        # 6ce420 <pp_string_value.meaning+0x711d4>
 15075bc:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 15075c1:	49 89 fe             	mov    %rdi,%r14
 15075c4:	8b 87 e0 01 00 00    	mov    0x1e0(%rdi),%eax
 15075ca:	42 89 84 8f e4 01 00 00 	mov    %eax,0x1e4(%rdi,%r9,4)
 15075d2:	42 c6 84 0f ed 02 00 00 00 	movb   $0x0,0x2ed(%rdi,%r9,1)
 15075db:	48 8d 05 4e 8b b9 00 	lea    0xb98b4e(%rip),%rax        # 20a0130 <tier0_c_type.names>
 15075e2:	48 8b 0c d8          	mov    (%rax,%rbx,8),%rcx
 15075e6:	31 c0                	xor    %eax,%eax
 15075e8:	48 89 8c 24 b0 00 00 00 	mov    %rcx,0xb0(%rsp)
 15075f0:	e8 7b ec 01 00       	call   1526270 <tier0_text>
 15075f5:	4c 89 f7             	mov    %r14,%rdi
 15075f8:	45 84 ed             	test   %r13b,%r13b
 15075fb:	74 23                	je     1507620 <run_backend_benchmark+0x5eb0>
 15075fd:	48 8d 35 73 d2 17 ff 	lea    -0xe82d8d(%rip),%rsi        # 684877 <pp_string_value.meaning+0x2762b>
 1507604:	ba 10 00 00 00       	mov    $0x10,%edx
 1507609:	31 c0                	xor    %eax,%eax
 150760b:	e8 60 ec 01 00       	call   1526270 <tier0_text>
 1507610:	eb 1c                	jmp    150762e <run_backend_benchmark+0x5ebe>
 1507612:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1507620:	48 8d 35 50 f2 14 ff 	lea    -0xeb0db0(%rip),%rsi        # 656877 <fuzz_comment_end+0x43028>
 1507627:	31 c0                	xor    %eax,%eax
 1507629:	e8 42 ec 01 00       	call   1526270 <tier0_text>
 150762e:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 1507633:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 150763d:	44 89 6c 24 30       	mov    %r13d,0x30(%rsp)
 1507642:	41 83 bc 86 d8 00 00 00 00 	cmpl   $0x0,0xd8(%r14,%rax,4)
 150764b:	0f 84 0f fe ff ff    	je     1507460 <run_backend_benchmark+0x5cf0>
 1507651:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 150765b:	4d 8d 2c 07          	lea    (%r15,%rax,1),%r13
 150765f:	4c 89 e8             	mov    %r13,%rax
 1507662:	48 c1 e8 1e          	shr    $0x1e,%rax
 1507666:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 150766e:	4c 31 e8             	xor    %r13,%rax
 1507671:	49 0f af c4          	imul   %r12,%rax
 1507675:	48 89 c1             	mov    %rax,%rcx
 1507678:	48 c1 e9 1b          	shr    $0x1b,%rcx
 150767c:	48 31 c1             	xor    %rax,%rcx
 150767f:	49 0f af c8          	imul   %r8,%rcx
 1507683:	48 89 c8             	mov    %rcx,%rax
 1507686:	48 c1 e8 1f          	shr    $0x1f,%rax
 150768a:	48 31 c8             	xor    %rcx,%rax
 150768d:	48 b9 cd cc cc cc cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
 1507697:	48 89 c2             	mov    %rax,%rdx
 150769a:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 150769f:	48 c1 e9 03          	shr    $0x3,%rcx
 15076a3:	48 01 c9             	add    %rcx,%rcx
 15076a6:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 15076aa:	48 29 c8             	sub    %rcx,%rax
 15076ad:	48 83 f8 06          	cmp    $0x6,%rax
 15076b1:	73 6d                	jae    1507720 <run_backend_benchmark+0x5fb0>
 15076b3:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 15076bd:	49 01 cf             	add    %rcx,%r15
 15076c0:	4c 89 f9             	mov    %r15,%rcx
 15076c3:	48 c1 e9 1e          	shr    $0x1e,%rcx
 15076c7:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 15076cf:	4c 31 f9             	xor    %r15,%rcx
 15076d2:	49 0f af cc          	imul   %r12,%rcx
 15076d6:	48 89 ce             	mov    %rcx,%rsi
 15076d9:	48 c1 ee 1b          	shr    $0x1b,%rsi
 15076dd:	48 31 ce             	xor    %rcx,%rsi
 15076e0:	48 b9 e1 83 0f 3e f8 e0 83 0f 	movabs $0xf83e0f83e0f83e1,%rcx
 15076ea:	49 0f af f0          	imul   %r8,%rsi
 15076ee:	48 89 f2             	mov    %rsi,%rdx
 15076f1:	48 c1 ea 1f          	shr    $0x1f,%rdx
 15076f5:	48 31 f2             	xor    %rsi,%rdx
 15076f8:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 15076fd:	48 d1 e9             	shr    $1,%rcx
 1507700:	48 89 ce             	mov    %rcx,%rsi
 1507703:	48 c1 e6 05          	shl    $0x5,%rsi
 1507707:	48 01 ce             	add    %rcx,%rsi
 150770a:	48 f7 de             	neg    %rsi
 150770d:	4c 8d 64 32 f0       	lea    -0x10(%rdx,%rsi,1),%r12
 1507712:	eb 4d                	jmp    1507761 <run_backend_benchmark+0x5ff1>
 1507714:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1507720:	48 83 f8 08          	cmp    $0x8,%rax
 1507724:	73 5f                	jae    1507785 <run_backend_benchmark+0x6015>
 1507726:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 1507730:	49 01 cf             	add    %rcx,%r15
 1507733:	4c 89 f9             	mov    %r15,%rcx
 1507736:	48 c1 e9 1e          	shr    $0x1e,%rcx
 150773a:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 1507742:	4c 31 f9             	xor    %r15,%rcx
 1507745:	49 0f af cc          	imul   %r12,%rcx
 1507749:	48 89 ca             	mov    %rcx,%rdx
 150774c:	48 c1 ea 1b          	shr    $0x1b,%rdx
 1507750:	48 31 ca             	xor    %rcx,%rdx
 1507753:	49 0f af d0          	imul   %r8,%rdx
 1507757:	49 89 d4             	mov    %rdx,%r12
 150775a:	49 c1 ec 1f          	shr    $0x1f,%r12
 150775e:	49 31 d4             	xor    %rdx,%r12
 1507761:	4d 89 fd             	mov    %r15,%r13
 1507764:	ff cb                	dec    %ebx
 1507766:	83 fb 09             	cmp    $0x9,%ebx
 1507769:	76 2f                	jbe    150779a <run_backend_benchmark+0x602a>
 150776b:	e9 70 01 00 00       	jmp    15078e0 <run_backend_benchmark+0x6170>
 1507770:	42 88 84 0f 98 00 00 00 	mov    %al,0x98(%rdi,%r9,1)
 1507778:	b8 01 00 00 00       	mov    $0x1,%eax
 150777d:	45 31 ed             	xor    %r13d,%r13d
 1507780:	e9 1a fe ff ff       	jmp    150759f <run_backend_benchmark+0x5e2f>
 1507785:	0f 95 c1             	setne  %cl
 1507788:	44 0f b6 e1          	movzbl %cl,%r12d
 150778c:	49 f7 dc             	neg    %r12
 150778f:	ff cb                	dec    %ebx
 1507791:	83 fb 09             	cmp    $0x9,%ebx
 1507794:	0f 87 46 01 00 00    	ja     15078e0 <run_backend_benchmark+0x6170>
 150779a:	48 8d 15 d3 8d 01 ff 	lea    -0xfe722d(%rip),%rdx        # 520574 <branch_sizing_patterns+0x7e4>
 15077a1:	48 63 0c 9a          	movslq (%rdx,%rbx,4),%rcx
 15077a5:	48 01 d1             	add    %rdx,%rcx
 15077a8:	ff e1                	jmp    *%rcx
 15077aa:	4d 0f be e4          	movsbq %r12b,%r12
 15077ae:	e9 2d 01 00 00       	jmp    15078e0 <run_backend_benchmark+0x6170>
 15077b3:	45 89 e4             	mov    %r12d,%r12d
 15077b6:	e9 25 01 00 00       	jmp    15078e0 <run_backend_benchmark+0x6170>
 15077bb:	45 0f b6 e4          	movzbl %r12b,%r12d
 15077bf:	e9 1c 01 00 00       	jmp    15078e0 <run_backend_benchmark+0x6170>
 15077c4:	c4 c1 02 2a c4       	vcvtsi2ss %r12d,%xmm15,%xmm0
 15077c9:	c5 fa 59 05 7f 8c 07 ff 	vmulss -0xf87381(%rip),%xmm0,%xmm0        # 580450 <tier0_emit_x87.operations+0x8>
 15077d1:	c5 fa 10 15 7b 8c 07 ff 	vmovss -0xf87385(%rip),%xmm2        # 580454 <tier0_emit_x87.operations+0xc>
 15077d9:	48 83 f8 08          	cmp    $0x8,%rax
 15077dd:	41 8b 96 e0 01 00 00 	mov    0x1e0(%r14),%edx
 15077e4:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 15077e8:	48 8d 35 4a bd 07 ff 	lea    -0xf842b6(%rip),%rsi        # 583539 <c_fragment_reader_cursor_tests.leaf_phases+0x105>
 15077ef:	4c 89 f7             	mov    %r14,%rdi
 15077f2:	0f 94 c1             	sete   %cl
 15077f5:	0f 92 c0             	setb   %al
 15077f8:	c5 fb 92 c9          	kmovd  %ecx,%k1
 15077fc:	49 8b 8e d8 01 00 00 	mov    0x1d8(%r14),%rcx
 1507803:	62 f1 6e 09 10 d1    	vmovss %xmm1,%xmm2,%xmm2{%k1}
 1507809:	c5 fb 92 c8          	kmovd  %eax,%k1
 150780d:	62 f1 6e 09 10 d0    	vmovss %xmm0,%xmm2,%xmm2{%k1}
 1507813:	c5 f9 7e d0          	vmovd  %xmm2,%eax
 1507817:	c5 f8 29 54 24 60    	vmovaps %xmm2,0x60(%rsp)
 150781d:	48 89 04 d1          	mov    %rax,(%rcx,%rdx,8)
 1507821:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 1507828:	31 c0                	xor    %eax,%eax
 150782a:	e8 41 ea 01 00       	call   1526270 <tier0_text>
 150782f:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 1507835:	4c 89 f7             	mov    %r14,%rdi
 1507838:	48 8d 35 3c f0 14 ff 	lea    -0xeb0fc4(%rip),%rsi        # 65687b <fuzz_comment_end+0x4302c>
 150783f:	c5 fa 5a c0          	vcvtss2sd %xmm0,%xmm0,%xmm0
 1507843:	eb 78                	jmp    15078bd <run_backend_benchmark+0x614d>
 1507845:	c4 c1 03 2a c4       	vcvtsi2sd %r12d,%xmm15,%xmm0
 150784a:	c5 fb 59 05 4e 88 07 ff 	vmulsd -0xf877b2(%rip),%xmm0,%xmm0        # 5800a0 <x86_semantics_benchmark_code.registers+0xb0>
 1507852:	c5 fb 10 15 4e 88 07 ff 	vmovsd -0xf877b2(%rip),%xmm2        # 5800a8 <x86_semantics_benchmark_code.registers+0xb8>
 150785a:	48 83 f8 08          	cmp    $0x8,%rax
 150785e:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1507862:	48 8d 35 d0 bc 07 ff 	lea    -0xf84330(%rip),%rsi        # 583539 <c_fragment_reader_cursor_tests.leaf_phases+0x105>
 1507869:	4c 89 f7             	mov    %r14,%rdi
 150786c:	0f 94 c1             	sete   %cl
 150786f:	0f 92 c0             	setb   %al
 1507872:	c5 fb 92 c9          	kmovd  %ecx,%k1
 1507876:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 150787d:	62 f1 ef 09 10 d1    	vmovsd %xmm1,%xmm2,%xmm2{%k1}
 1507883:	c5 fb 92 c8          	kmovd  %eax,%k1
 1507887:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 150788e:	62 f1 ef 09 10 d0    	vmovsd %xmm0,%xmm2,%xmm2{%k1}
 1507894:	c5 f9 29 54 24 60    	vmovapd %xmm2,0x60(%rsp)
 150789a:	c5 fb 11 14 c8       	vmovsd %xmm2,(%rax,%rcx,8)
 150789f:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 15078a6:	31 c0                	xor    %eax,%eax
 15078a8:	e8 c3 e9 01 00       	call   1526270 <tier0_text>
 15078ad:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 15078b3:	48 8d 35 50 84 0d ff 	lea    -0xf27bb0(%rip),%rsi        # 5dfd0a <foreign_touch.flags+0xc7dd>
 15078ba:	4c 89 f7             	mov    %r14,%rdi
 15078bd:	b0 01                	mov    $0x1,%al
 15078bf:	e8 ac e9 01 00       	call   1526270 <tier0_text>
 15078c4:	eb 60                	jmp    1507926 <run_backend_benchmark+0x61b6>
 15078c6:	4d 0f bf e4          	movswq %r12w,%r12
 15078ca:	eb 14                	jmp    15078e0 <run_backend_benchmark+0x6170>
 15078cc:	45 0f b7 e4          	movzwl %r12w,%r12d
 15078d0:	eb 0e                	jmp    15078e0 <run_backend_benchmark+0x6170>
 15078d2:	4d 63 e4             	movslq %r12d,%r12
 15078d5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 15078e0:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 15078e7:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 15078ee:	48 8d 35 44 bc 07 ff 	lea    -0xf843bc(%rip),%rsi        # 583539 <c_fragment_reader_cursor_tests.leaf_phases+0x105>
 15078f5:	4c 89 f7             	mov    %r14,%rdi
 15078f8:	4c 89 24 c8          	mov    %r12,(%rax,%rcx,8)
 15078fc:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 1507903:	31 c0                	xor    %eax,%eax
 1507905:	e8 66 e9 01 00       	call   1526270 <tier0_text>
 150790a:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 1507912:	48 8d 35 5e 10 09 ff 	lea    -0xf6efa2(%rip),%rsi        # 598977 <parse_test_openers+0xd7be>
 1507919:	4c 89 f7             	mov    %r14,%rdi
 150791c:	4c 89 e1             	mov    %r12,%rcx
 150791f:	31 c0                	xor    %eax,%eax
 1507921:	e8 4a e9 01 00       	call   1526270 <tier0_text>
 1507926:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 150792b:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 1507935:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 150793f:	41 83 bc 86 d8 00 00 00 02 	cmpl   $0x2,0xd8(%r14,%rax,4)
 1507948:	0f 82 15 fb ff ff    	jb     1507463 <run_backend_benchmark+0x5cf3>
 150794e:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 1507954:	eb 7a                	jmp    15079d0 <run_backend_benchmark+0x6260>
 1507956:	45 89 e4             	mov    %r12d,%r12d
 1507959:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1507960:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 1507967:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 150796e:	48 8d 35 09 4d 0f ff 	lea    -0xf0b2f7(%rip),%rsi        # 5fc67e <foreign_touch.flags+0x29151>
 1507975:	4c 89 f7             	mov    %r14,%rdi
 1507978:	4c 89 24 c8          	mov    %r12,(%rax,%rcx,8)
 150797c:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 1507983:	31 c0                	xor    %eax,%eax
 1507985:	e8 e6 e8 01 00       	call   1526270 <tier0_text>
 150798a:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 1507992:	48 8d 35 de 0f 09 ff 	lea    -0xf6f022(%rip),%rsi        # 598977 <parse_test_openers+0xd7be>
 1507999:	4c 89 f7             	mov    %r14,%rdi
 150799c:	4c 89 e1             	mov    %r12,%rcx
 150799f:	31 c0                	xor    %eax,%eax
 15079a1:	e8 ca e8 01 00       	call   1526270 <tier0_text>
 15079a6:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 15079ab:	41 ff c7             	inc    %r15d
 15079ae:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 15079b8:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 15079c2:	45 3b bc 86 d8 00 00 00 	cmp    0xd8(%r14,%rax,4),%r15d
 15079ca:	0f 83 93 fa ff ff    	jae    1507463 <run_backend_benchmark+0x5cf3>
 15079d0:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 15079da:	48 be cd cc cc cc cc cc cc cc 	movabs $0xcccccccccccccccd,%rsi
 15079e4:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
 15079e9:	48 89 c8             	mov    %rcx,%rax
 15079ec:	48 c1 e8 1e          	shr    $0x1e,%rax
 15079f0:	48 89 8c 24 80 02 00 00 	mov    %rcx,0x280(%rsp)
 15079f8:	48 31 c8             	xor    %rcx,%rax
 15079fb:	49 0f af c4          	imul   %r12,%rax
 15079ff:	48 89 c2             	mov    %rax,%rdx
 1507a02:	48 c1 ea 1b          	shr    $0x1b,%rdx
 1507a06:	48 31 c2             	xor    %rax,%rdx
 1507a09:	49 0f af d0          	imul   %r8,%rdx
 1507a0d:	48 89 d0             	mov    %rdx,%rax
 1507a10:	48 c1 e8 1f          	shr    $0x1f,%rax
 1507a14:	48 31 d0             	xor    %rdx,%rax
 1507a17:	48 89 c2             	mov    %rax,%rdx
 1507a1a:	c4 e2 eb f6 d6       	mulx   %rsi,%rdx,%rdx
 1507a1f:	48 c1 ea 03          	shr    $0x3,%rdx
 1507a23:	48 01 d2             	add    %rdx,%rdx
 1507a26:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
 1507a2a:	48 29 d0             	sub    %rdx,%rax
 1507a2d:	48 83 f8 05          	cmp    $0x5,%rax
 1507a31:	77 6d                	ja     1507aa0 <run_backend_benchmark+0x6330>
 1507a33:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 1507a3d:	49 01 cd             	add    %rcx,%r13
 1507a40:	4c 89 e9             	mov    %r13,%rcx
 1507a43:	48 c1 e9 1e          	shr    $0x1e,%rcx
 1507a47:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 1507a4f:	4c 31 e9             	xor    %r13,%rcx
 1507a52:	49 0f af cc          	imul   %r12,%rcx
 1507a56:	48 89 ce             	mov    %rcx,%rsi
 1507a59:	48 c1 ee 1b          	shr    $0x1b,%rsi
 1507a5d:	48 31 ce             	xor    %rcx,%rsi
 1507a60:	48 b9 e1 83 0f 3e f8 e0 83 0f 	movabs $0xf83e0f83e0f83e1,%rcx
 1507a6a:	49 0f af f0          	imul   %r8,%rsi
 1507a6e:	48 89 f2             	mov    %rsi,%rdx
 1507a71:	48 c1 ea 1f          	shr    $0x1f,%rdx
 1507a75:	48 31 f2             	xor    %rsi,%rdx
 1507a78:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 1507a7d:	48 d1 e9             	shr    $1,%rcx
 1507a80:	48 89 ce             	mov    %rcx,%rsi
 1507a83:	48 c1 e6 05          	shl    $0x5,%rsi
 1507a87:	48 01 ce             	add    %rcx,%rsi
 1507a8a:	48 f7 de             	neg    %rsi
 1507a8d:	4c 8d 64 32 f0       	lea    -0x10(%rdx,%rsi,1),%r12
 1507a92:	83 fb 09             	cmp    $0x9,%ebx
 1507a95:	76 73                	jbe    1507b0a <run_backend_benchmark+0x639a>
 1507a97:	e9 c4 fe ff ff       	jmp    1507960 <run_backend_benchmark+0x61f0>
 1507a9c:	0f 1f 40 00          	nopl   0x0(%rax)
 1507aa0:	48 83 f8 07          	cmp    $0x7,%rax
 1507aa4:	77 4a                	ja     1507af0 <run_backend_benchmark+0x6380>
 1507aa6:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 1507ab0:	49 01 cd             	add    %rcx,%r13
 1507ab3:	4c 89 e9             	mov    %r13,%rcx
 1507ab6:	48 c1 e9 1e          	shr    $0x1e,%rcx
 1507aba:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 1507ac2:	4c 31 e9             	xor    %r13,%rcx
 1507ac5:	49 0f af cc          	imul   %r12,%rcx
 1507ac9:	48 89 ca             	mov    %rcx,%rdx
 1507acc:	48 c1 ea 1b          	shr    $0x1b,%rdx
 1507ad0:	48 31 ca             	xor    %rcx,%rdx
 1507ad3:	49 0f af d0          	imul   %r8,%rdx
 1507ad7:	49 89 d4             	mov    %rdx,%r12
 1507ada:	49 c1 ec 1f          	shr    $0x1f,%r12
 1507ade:	49 31 d4             	xor    %rdx,%r12
 1507ae1:	83 fb 09             	cmp    $0x9,%ebx
 1507ae4:	76 24                	jbe    1507b0a <run_backend_benchmark+0x639a>
 1507ae6:	e9 75 fe ff ff       	jmp    1507960 <run_backend_benchmark+0x61f0>
 1507aeb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1507af0:	45 31 e4             	xor    %r12d,%r12d
 1507af3:	48 83 f8 08          	cmp    $0x8,%rax
 1507af7:	49 89 cd             	mov    %rcx,%r13
 1507afa:	41 0f 95 c4          	setne  %r12b
 1507afe:	49 f7 dc             	neg    %r12
 1507b01:	83 fb 09             	cmp    $0x9,%ebx
 1507b04:	0f 87 56 fe ff ff    	ja     1507960 <run_backend_benchmark+0x61f0>
 1507b0a:	48 8d 15 8b 8a 01 ff 	lea    -0xfe7575(%rip),%rdx        # 52059c <branch_sizing_patterns+0x80c>
 1507b11:	48 63 0c 9a          	movslq (%rdx,%rbx,4),%rcx
 1507b15:	48 01 d1             	add    %rdx,%rcx
 1507b18:	ff e1                	jmp    *%rcx
 1507b1a:	4d 0f be e4          	movsbq %r12b,%r12
 1507b1e:	e9 3d fe ff ff       	jmp    1507960 <run_backend_benchmark+0x61f0>
 1507b23:	45 0f b6 e4          	movzbl %r12b,%r12d
 1507b27:	e9 34 fe ff ff       	jmp    1507960 <run_backend_benchmark+0x61f0>
 1507b2c:	c4 c1 02 2a c4       	vcvtsi2ss %r12d,%xmm15,%xmm0
 1507b31:	c5 fa 59 05 17 89 07 ff 	vmulss -0xf876e9(%rip),%xmm0,%xmm0        # 580450 <tier0_emit_x87.operations+0x8>
 1507b39:	c5 fa 10 15 13 89 07 ff 	vmovss -0xf876ed(%rip),%xmm2        # 580454 <tier0_emit_x87.operations+0xc>
 1507b41:	48 83 f8 08          	cmp    $0x8,%rax
 1507b45:	41 8b 96 e0 01 00 00 	mov    0x1e0(%r14),%edx
 1507b4c:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1507b50:	48 8d 35 27 4b 0f ff 	lea    -0xf0b4d9(%rip),%rsi        # 5fc67e <foreign_touch.flags+0x29151>
 1507b57:	4c 89 f7             	mov    %r14,%rdi
 1507b5a:	0f 94 c1             	sete   %cl
 1507b5d:	0f 92 c0             	setb   %al
 1507b60:	c5 fb 92 c9          	kmovd  %ecx,%k1
 1507b64:	49 8b 8e d8 01 00 00 	mov    0x1d8(%r14),%rcx
 1507b6b:	62 f1 6e 09 10 d1    	vmovss %xmm1,%xmm2,%xmm2{%k1}
 1507b71:	c5 fb 92 c8          	kmovd  %eax,%k1
 1507b75:	62 f1 6e 09 10 d0    	vmovss %xmm0,%xmm2,%xmm2{%k1}
 1507b7b:	c5 f9 7e d0          	vmovd  %xmm2,%eax
 1507b7f:	c5 f8 29 54 24 60    	vmovaps %xmm2,0x60(%rsp)
 1507b85:	48 89 04 d1          	mov    %rax,(%rcx,%rdx,8)
 1507b89:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 1507b90:	31 c0                	xor    %eax,%eax
 1507b92:	e8 d9 e6 01 00       	call   1526270 <tier0_text>
 1507b97:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 1507b9d:	4c 89 f7             	mov    %r14,%rdi
 1507ba0:	48 8d 35 d4 ec 14 ff 	lea    -0xeb132c(%rip),%rsi        # 65687b <fuzz_comment_end+0x4302c>
 1507ba7:	c5 fa 5a c0          	vcvtss2sd %xmm0,%xmm0,%xmm0
 1507bab:	eb 78                	jmp    1507c25 <run_backend_benchmark+0x64b5>
 1507bad:	c4 c1 03 2a c4       	vcvtsi2sd %r12d,%xmm15,%xmm0
 1507bb2:	c5 fb 59 05 e6 84 07 ff 	vmulsd -0xf87b1a(%rip),%xmm0,%xmm0        # 5800a0 <x86_semantics_benchmark_code.registers+0xb0>
 1507bba:	c5 fb 10 15 e6 84 07 ff 	vmovsd -0xf87b1a(%rip),%xmm2        # 5800a8 <x86_semantics_benchmark_code.registers+0xb8>
 1507bc2:	48 83 f8 08          	cmp    $0x8,%rax
 1507bc6:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1507bca:	48 8d 35 ad 4a 0f ff 	lea    -0xf0b553(%rip),%rsi        # 5fc67e <foreign_touch.flags+0x29151>
 1507bd1:	4c 89 f7             	mov    %r14,%rdi
 1507bd4:	0f 94 c1             	sete   %cl
 1507bd7:	0f 92 c0             	setb   %al
 1507bda:	c5 fb 92 c9          	kmovd  %ecx,%k1
 1507bde:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 1507be5:	62 f1 ef 09 10 d1    	vmovsd %xmm1,%xmm2,%xmm2{%k1}
 1507beb:	c5 fb 92 c8          	kmovd  %eax,%k1
 1507bef:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 1507bf6:	62 f1 ef 09 10 d0    	vmovsd %xmm0,%xmm2,%xmm2{%k1}
 1507bfc:	c5 f9 29 54 24 60    	vmovapd %xmm2,0x60(%rsp)
 1507c02:	c5 fb 11 14 c8       	vmovsd %xmm2,(%rax,%rcx,8)
 1507c07:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 1507c0e:	31 c0                	xor    %eax,%eax
 1507c10:	e8 5b e6 01 00       	call   1526270 <tier0_text>
 1507c15:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 1507c1b:	48 8d 35 e8 80 0d ff 	lea    -0xf27f18(%rip),%rsi        # 5dfd0a <foreign_touch.flags+0xc7dd>
 1507c22:	4c 89 f7             	mov    %r14,%rdi
 1507c25:	b0 01                	mov    $0x1,%al
 1507c27:	e8 44 e6 01 00       	call   1526270 <tier0_text>
 1507c2c:	e9 75 fd ff ff       	jmp    15079a6 <run_backend_benchmark+0x6236>
 1507c31:	4d 0f bf e4          	movswq %r12w,%r12
 1507c35:	e9 26 fd ff ff       	jmp    1507960 <run_backend_benchmark+0x61f0>
 1507c3a:	45 0f b7 e4          	movzwl %r12w,%r12d
 1507c3e:	e9 1d fd ff ff       	jmp    1507960 <run_backend_benchmark+0x61f0>
 1507c43:	4d 63 e4             	movslq %r12d,%r12
 1507c46:	e9 15 fd ff ff       	jmp    1507960 <run_backend_benchmark+0x61f0>
 1507c4b:	48 8d 35 2d 37 12 ff 	lea    -0xedc8d3(%rip),%rsi        # 62b37f <fuzz_comment_end+0x17b30>
 1507c52:	c7 87 e8 02 00 00 ff ff ff ff 	movl   $0xffffffff,0x2e8(%rdi)
 1507c5c:	31 c0                	xor    %eax,%eax
 1507c5e:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 1507c66:	45 31 f6             	xor    %r14d,%r14d
 1507c69:	49 89 fc             	mov    %rdi,%r12
 1507c6c:	e8 ff e5 01 00       	call   1526270 <tier0_text>
 1507c71:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 1507c76:	48 8d 1d 2b c9 01 ff 	lea    -0xfe36d5(%rip),%rbx        # 5245a8 <tier0_program_class_type.types+0x38>
 1507c7d:	4c 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%r15
 1507c85:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1507c90:	41 80 bc 24 98 0d 00 00 01 	cmpb   $0x1,0xd98(%r12)
 1507c99:	0f 84 1e 2f 00 00    	je     150abbd <run_backend_benchmark+0x944d>
 1507c9f:	4c 89 e7             	mov    %r12,%rdi
 1507ca2:	44 89 f6             	mov    %r14d,%esi
 1507ca5:	4c 89 fa             	mov    %r15,%rdx
 1507ca8:	48 89 d9             	mov    %rbx,%rcx
 1507cab:	e8 b0 e8 01 00       	call   1526560 <tier0_generate_function>
 1507cb0:	41 ff c6             	inc    %r14d
 1507cb3:	41 83 fe 08          	cmp    $0x8,%r14d
 1507cb7:	75 d7                	jne    1507c90 <run_backend_benchmark+0x6520>
 1507cb9:	41 80 bc 24 98 0d 00 00 00 	cmpb   $0x0,0xd98(%r12)
 1507cc2:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 1507cca:	0f 85 f5 2e 00 00    	jne    150abc5 <run_backend_benchmark+0x9455>
 1507cd0:	41 8b 84 24 70 0d 00 00 	mov    0xd70(%r12),%eax
 1507cd8:	4d 89 e1             	mov    %r12,%r9
 1507cdb:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 1507ce1:	48 89 84 24 90 00 00 00 	mov    %rax,0x90(%rsp)
 1507ce9:	48 85 c0             	test   %rax,%rax
 1507cec:	74 2a                	je     1507d18 <run_backend_benchmark+0x65a8>
 1507cee:	62 62 fd 48 59 05 b8 83 07 ff 	vpbroadcastq -0xf87c48(%rip),%zmm24        # 5800b0 <x86_semantics_benchmark_code.registers+0xc0>
 1507cf8:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 1507d00:	4c 8d 3d 69 c8 01 ff 	lea    -0xfe3797(%rip),%r15        # 524570 <tier0_program_class_type.types>
 1507d07:	83 f8 10             	cmp    $0x10,%eax
 1507d0a:	73 28                	jae    1507d34 <run_backend_benchmark+0x65c4>
 1507d0c:	31 c0                	xor    %eax,%eax
 1507d0e:	45 31 db             	xor    %r11d,%r11d
 1507d11:	31 d2                	xor    %edx,%edx
 1507d13:	e9 37 09 00 00       	jmp    150864f <run_backend_benchmark+0x6edf>
 1507d18:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 1507d20:	45 31 db             	xor    %r11d,%r11d
 1507d23:	ba 08 00 00 00       	mov    $0x8,%edx
 1507d28:	4c 8d 3d 41 c8 01 ff 	lea    -0xfe37bf(%rip),%r15        # 524570 <tier0_program_class_type.types>
 1507d2f:	e9 5e 09 00 00       	jmp    1508692 <run_backend_benchmark+0x6f22>
 1507d34:	49 8d 89 70 03 00 00 	lea    0x370(%r9),%rcx
 1507d3b:	62 f2 fd 48 7c c1    	vpbroadcastq %rcx,%zmm0
 1507d41:	83 f8 40             	cmp    $0x40,%eax
 1507d44:	73 0c                	jae    1507d52 <run_backend_benchmark+0x65e2>
 1507d46:	31 c0                	xor    %eax,%eax
 1507d48:	45 31 db             	xor    %r11d,%r11d
 1507d4b:	31 d2                	xor    %edx,%edx
 1507d4d:	e9 e2 06 00 00       	jmp    1508434 <run_backend_benchmark+0x6cc4>
 1507d52:	62 f1 fd 48 6f 35 24 85 01 ff 	vmovdqa64 -0xfe7adc(%rip),%zmm6        # 520280 <branch_sizing_patterns+0x4f0>
 1507d5c:	62 f1 fd 48 6f 3d da 84 01 ff 	vmovdqa64 -0xfe7b26(%rip),%zmm7        # 520240 <branch_sizing_patterns+0x4b0>
 1507d66:	62 62 fd 48 59 0d 48 83 07 ff 	vpbroadcastq -0xf87cb8(%rip),%zmm25        # 5800b8 <x86_semantics_benchmark_code.registers+0xc8>
 1507d70:	62 62 fd 48 59 15 46 83 07 ff 	vpbroadcastq -0xf87cba(%rip),%zmm26        # 5800c0 <x86_semantics_benchmark_code.registers+0xd0>
 1507d7a:	62 62 fd 48 59 1d 44 83 07 ff 	vpbroadcastq -0xf87cbc(%rip),%zmm27        # 5800c8 <x86_semantics_benchmark_code.registers+0xd8>
 1507d84:	62 62 fd 48 59 25 42 83 07 ff 	vpbroadcastq -0xf87cbe(%rip),%zmm28        # 5800d0 <x86_semantics_benchmark_code.registers+0xe0>
 1507d8e:	83 e0 c0             	and    $0xffffffc0,%eax
 1507d91:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1507d95:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1507d9a:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
 1507d9f:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
 1507da4:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1507da8:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1507dac:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 1507db0:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 1507db4:	48 89 c2             	mov    %rax,%rdx
 1507db7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 1507dc0:	62 12 cd 48 40 d8    	vpmullq %zmm24,%zmm6,%zmm11
 1507dc6:	62 12 c5 48 40 e0    	vpmullq %zmm24,%zmm7,%zmm12
 1507dcc:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 1507dd0:	62 91 cd 48 d4 f4    	vpaddq %zmm28,%zmm6,%zmm6
 1507dd6:	62 91 c5 48 d4 fc    	vpaddq %zmm28,%zmm7,%zmm7
 1507ddc:	48 83 c2 c0          	add    $0xffffffffffffffc0,%rdx
 1507de0:	62 51 fd 48 d4 fb    	vpaddq %zmm11,%zmm0,%zmm15
 1507de6:	62 51 fd 48 d4 ec    	vpaddq %zmm12,%zmm0,%zmm13
 1507dec:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 1507df1:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 1507df7:	62 33 7d 28 39 fb 01 	vextracti32x4 $0x1,%ymm15,%xmm19
 1507dfe:	62 33 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm15,%xmm21
 1507e05:	62 81 85 48 d4 d3    	vpaddq %zmm27,%zmm15,%zmm18
 1507e0b:	62 81 95 48 d4 cb    	vpaddq %zmm27,%zmm13,%zmm17
 1507e11:	62 81 85 48 d4 c2    	vpaddq %zmm26,%zmm15,%zmm16
 1507e17:	62 11 95 48 d4 f2    	vpaddq %zmm26,%zmm13,%zmm14
 1507e1d:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 1507e21:	62 c3 fd 08 16 d3 01 	vpextrq $0x1,%xmm18,%r11
 1507e28:	62 a3 7d 28 39 d6 01 	vextracti32x4 $0x1,%ymm18,%xmm22
 1507e2f:	62 a3 7d 48 39 d7 02 	vextracti32x4 $0x2,%zmm18,%xmm23
 1507e36:	62 e1 7d 08 6e e7    	vmovd  %edi,%xmm20
 1507e3c:	62 e3 5d 00 20 66 1e 01 	vpinsrb $0x1,0x1e(%rsi),%xmm20,%xmm20
 1507e44:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 1507e4a:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 1507e51:	62 e3 5d 00 20 5f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm20,%xmm19
 1507e59:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 1507e5f:	62 33 7d 48 39 fc 03 	vextracti32x4 $0x3,%zmm15,%xmm20
 1507e66:	62 11 85 48 d4 f9    	vpaddq %zmm25,%zmm15,%zmm15
 1507e6c:	62 e3 65 00 20 5e 1e 03 	vpinsrb $0x3,0x1e(%rsi),%xmm19,%xmm19
 1507e74:	62 e3 fd 08 16 ee 01 	vpextrq $0x1,%xmm21,%rsi
 1507e7b:	62 e3 65 00 20 5f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm19,%xmm19
 1507e83:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 1507e89:	62 e3 65 00 20 5e 1e 05 	vpinsrb $0x5,0x1e(%rsi),%xmm19,%xmm19
 1507e91:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 1507e98:	62 33 7d 28 39 ec 01 	vextracti32x4 $0x1,%ymm13,%xmm20
 1507e9f:	62 e3 65 00 20 5f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm19,%xmm19
 1507ea7:	c4 61 f9 7e ef       	vmovq  %xmm13,%rdi
 1507eac:	62 e3 65 00 20 5e 1e 07 	vpinsrb $0x7,0x1e(%rsi),%xmm19,%xmm19
 1507eb4:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 1507eba:	62 e3 65 00 20 5f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm19,%xmm19
 1507ec2:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 1507ec8:	62 e3 65 00 20 5e 1e 09 	vpinsrb $0x9,0x1e(%rsi),%xmm19,%xmm19
 1507ed0:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 1507ed7:	62 33 7d 48 39 ec 02 	vextracti32x4 $0x2,%zmm13,%xmm20
 1507ede:	62 e3 65 00 20 5f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm19,%xmm19
 1507ee6:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 1507eec:	62 e3 65 00 20 5e 1e 0b 	vpinsrb $0xb,0x1e(%rsi),%xmm19,%xmm19
 1507ef4:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 1507efb:	62 33 7d 48 39 ec 03 	vextracti32x4 $0x3,%zmm13,%xmm20
 1507f02:	62 11 95 48 d4 e9    	vpaddq %zmm25,%zmm13,%zmm13
 1507f08:	62 c1 fd 08 7e e0    	vmovq  %xmm20,%r8
 1507f0e:	62 e3 65 00 20 5f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm19,%xmm19
 1507f16:	62 e1 fd 08 7e d7    	vmovq  %xmm18,%rdi
 1507f1c:	62 a3 7d 48 39 d2 03 	vextracti32x4 $0x3,%zmm18,%xmm18
 1507f23:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 1507f27:	62 e3 65 00 20 5e 1e 0d 	vpinsrb $0xd,0x1e(%rsi),%xmm19,%xmm19
 1507f2f:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 1507f36:	62 e1 7d 08 6e ef    	vmovd  %edi,%xmm21
 1507f3c:	62 c3 55 00 20 6b 1e 01 	vpinsrb $0x1,0x1e(%r11),%xmm21,%xmm21
 1507f44:	62 e1 fd 08 7e f7    	vmovq  %xmm22,%rdi
 1507f4a:	62 c3 65 00 20 58 1e 0e 	vpinsrb $0xe,0x1e(%r8),%xmm19,%xmm19
 1507f52:	62 c3 fd 08 16 c0 01 	vpextrq $0x1,%xmm16,%r8
 1507f59:	62 e3 55 00 20 6f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm21,%xmm21
 1507f61:	62 e3 fd 08 16 f7 01 	vpextrq $0x1,%xmm22,%rdi
 1507f68:	62 e3 55 00 20 6f 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm21,%xmm21
 1507f70:	62 e1 fd 08 7e ff    	vmovq  %xmm23,%rdi
 1507f76:	62 e3 55 00 20 6f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm21,%xmm21
 1507f7e:	62 e3 fd 08 16 ff 01 	vpextrq $0x1,%xmm23,%rdi
 1507f85:	62 e3 55 00 20 6f 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm21,%xmm21
 1507f8d:	62 e1 fd 08 7e d7    	vmovq  %xmm18,%rdi
 1507f93:	62 e3 55 00 20 67 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm21,%xmm20
 1507f9b:	62 e3 fd 08 16 d7 01 	vpextrq $0x1,%xmm18,%rdi
 1507fa2:	62 a3 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm16,%xmm21
 1507fa9:	62 e3 5d 00 20 57 1e 07 	vpinsrb $0x7,0x1e(%rdi),%xmm20,%xmm18
 1507fb1:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 1507fb7:	62 a3 7d 28 39 cc 01 	vextracti32x4 $0x1,%ymm17,%xmm20
 1507fbe:	62 e3 6d 00 20 57 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm18,%xmm18
 1507fc6:	62 e3 fd 08 16 cf 01 	vpextrq $0x1,%xmm17,%rdi
 1507fcd:	62 e3 6d 00 20 57 1e 09 	vpinsrb $0x9,0x1e(%rdi),%xmm18,%xmm18
 1507fd5:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 1507fdb:	62 e3 6d 00 20 57 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm18,%xmm18
 1507fe3:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 1507fea:	62 a3 7d 48 39 cc 02 	vextracti32x4 $0x2,%zmm17,%xmm20
 1507ff1:	62 a3 7d 48 39 c9 03 	vextracti32x4 $0x3,%zmm17,%xmm17
 1507ff8:	62 e3 6d 00 20 57 1e 0b 	vpinsrb $0xb,0x1e(%rdi),%xmm18,%xmm18
 1508000:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 1508006:	62 e3 6d 00 20 57 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm18,%xmm18
 150800e:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 1508015:	62 e3 6d 00 20 57 1e 0d 	vpinsrb $0xd,0x1e(%rdi),%xmm18,%xmm18
 150801d:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 1508023:	62 e3 6d 00 20 57 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm18,%xmm18
 150802b:	62 e1 fd 08 7e c7    	vmovq  %xmm16,%rdi
 1508031:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 1508035:	62 e1 7d 08 6e e7    	vmovd  %edi,%xmm20
 150803b:	62 c3 5d 00 20 60 1e 01 	vpinsrb $0x1,0x1e(%r8),%xmm20,%xmm20
 1508043:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 1508049:	62 e3 5d 00 20 67 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm20,%xmm20
 1508051:	62 e3 fd 08 16 ef 01 	vpextrq $0x1,%xmm21,%rdi
 1508058:	62 a3 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm16,%xmm21
 150805f:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 1508066:	62 e3 5d 00 20 67 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm20,%xmm20
 150806e:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 1508074:	62 e3 5d 00 20 67 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm20,%xmm20
 150807c:	62 e3 fd 08 16 ef 01 	vpextrq $0x1,%xmm21,%rdi
 1508083:	62 e3 5d 00 20 67 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm20,%xmm20
 150808b:	62 e1 fd 08 7e c7    	vmovq  %xmm16,%rdi
 1508091:	62 e3 5d 00 20 67 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm20,%xmm20
 1508099:	62 e3 fd 08 16 c7 01 	vpextrq $0x1,%xmm16,%rdi
 15080a0:	62 e3 5d 00 20 47 1e 07 	vpinsrb $0x7,0x1e(%rdi),%xmm20,%xmm16
 15080a8:	c4 61 f9 7e f7       	vmovq  %xmm14,%rdi
 15080ad:	62 33 7d 28 39 f4 01 	vextracti32x4 $0x1,%ymm14,%xmm20
 15080b4:	62 e3 7d 00 20 47 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm16,%xmm16
 15080bc:	c4 63 f9 16 f7 01    	vpextrq $0x1,%xmm14,%rdi
 15080c2:	62 e3 7d 00 20 47 1e 09 	vpinsrb $0x9,0x1e(%rdi),%xmm16,%xmm16
 15080ca:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 15080d0:	62 e3 7d 00 20 47 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm16,%xmm16
 15080d8:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 15080df:	62 33 7d 48 39 f4 02 	vextracti32x4 $0x2,%zmm14,%xmm20
 15080e6:	62 e3 7d 00 20 47 1e 0b 	vpinsrb $0xb,0x1e(%rdi),%xmm16,%xmm16
 15080ee:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 15080f4:	62 e3 7d 00 20 47 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm16,%xmm16
 15080fc:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 1508103:	62 33 7d 48 39 f4 03 	vextracti32x4 $0x3,%zmm14,%xmm20
 150810a:	62 73 7d 00 20 77 1e 0d 	vpinsrb $0xd,0x1e(%rdi),%xmm16,%xmm14
 1508112:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 1508118:	62 e3 0d 08 20 47 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm14,%xmm16
 1508120:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 1508125:	62 73 65 00 20 76 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm19,%xmm14
 150812d:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 1508133:	62 33 7d 28 39 fb 01 	vextracti32x4 $0x1,%ymm15,%xmm19
 150813a:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 150813e:	62 e1 7d 08 6e ef    	vmovd  %edi,%xmm21
 1508144:	62 e3 55 00 20 6e 1e 01 	vpinsrb $0x1,0x1e(%rsi),%xmm21,%xmm21
 150814c:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 1508152:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 1508159:	62 33 7d 48 39 fb 02 	vextracti32x4 $0x2,%zmm15,%xmm19
 1508160:	62 53 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm15,%xmm15
 1508167:	62 e3 55 00 20 6f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm21,%xmm21
 150816f:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 1508175:	62 e3 55 00 20 6e 1e 03 	vpinsrb $0x3,0x1e(%rsi),%xmm21,%xmm21
 150817d:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 1508184:	62 e3 55 00 20 5f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm21,%xmm19
 150818c:	62 e3 fd 08 16 cf 01 	vpextrq $0x1,%xmm17,%rdi
 1508193:	62 e3 6d 00 20 57 1e 0f 	vpinsrb $0xf,0x1e(%rdi),%xmm18,%xmm18
 150819b:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 15081a0:	62 e3 65 00 20 4e 1e 05 	vpinsrb $0x5,0x1e(%rsi),%xmm19,%xmm17
 15081a8:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 15081ae:	62 a1 55 00 ef ed    	vpxord %xmm21,%xmm21,%xmm21
 15081b4:	62 73 75 00 20 7f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm17,%xmm15
 15081bc:	c4 61 f9 7e ef       	vmovq  %xmm13,%rdi
 15081c1:	62 33 7d 28 39 e9 01 	vextracti32x4 $0x1,%ymm13,%xmm17
 15081c8:	62 a1 65 00 ef db    	vpxord %xmm19,%xmm19,%xmm19
 15081ce:	c4 63 01 20 7e 1e 07 	vpinsrb $0x7,0x1e(%rsi),%xmm15,%xmm15
 15081d5:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 15081db:	c4 63 01 20 7f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm15,%xmm15
 15081e2:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 15081e8:	c4 63 01 20 7e 1e 09 	vpinsrb $0x9,0x1e(%rsi),%xmm15,%xmm15
 15081ef:	62 e3 fd 08 16 ce 01 	vpextrq $0x1,%xmm17,%rsi
 15081f6:	62 33 7d 48 39 e9 02 	vextracti32x4 $0x2,%zmm13,%xmm17
 15081fd:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 1508204:	c4 63 01 20 7f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm15,%xmm15
 150820b:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 1508211:	c4 63 01 20 7e 1e 0b 	vpinsrb $0xb,0x1e(%rsi),%xmm15,%xmm15
 1508218:	62 e3 fd 08 16 ce 01 	vpextrq $0x1,%xmm17,%rsi
 150821f:	62 a1 75 00 ef c9    	vpxord %xmm17,%xmm17,%xmm17
 1508225:	c4 63 01 20 7f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm15,%xmm15
 150822c:	c4 63 01 20 7e 1e 0d 	vpinsrb $0xd,0x1e(%rsi),%xmm15,%xmm15
 1508233:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 150823a:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 1508240:	62 e3 7d 00 20 46 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm16,%xmm16
 1508248:	c4 61 f9 7e ee       	vmovq  %xmm13,%rsi
 150824d:	c4 63 01 20 7e 1e 0e 	vpinsrb $0xe,0x1e(%rsi),%xmm15,%xmm15
 1508254:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 150825a:	c4 63 01 20 6e 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm15,%xmm13
 1508261:	c4 41 01 ef ff       	vpxor  %xmm15,%xmm15,%xmm15
 1508266:	62 32 7d 49 91 7c 21 04 	vpgatherqd 0x10(%rcx,%zmm12,1),%ymm15{%k1}
 150826e:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 1508272:	62 a2 7d 49 91 4c 19 04 	vpgatherqd 0x10(%rcx,%zmm11,1),%ymm17{%k1}
 150827a:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 150827e:	62 a2 7d 49 91 9c 21 90 02 00 00 	vpgatherqd 0x290(%rcx,%zmm12,1),%ymm19{%k1}
 1508289:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 150828d:	62 a2 7d 49 91 a4 19 90 02 00 00 	vpgatherqd 0x290(%rcx,%zmm11,1),%ymm20{%k1}
 1508298:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 150829c:	62 53 f5 40 3a ff 01 	vinserti64x4 $0x1,%ymm15,%zmm17,%zmm15
 15082a3:	62 a1 75 00 ef c9    	vpxord %xmm17,%xmm17,%xmm17
 15082a9:	62 a2 7d 49 91 8c 21 10 05 00 00 	vpgatherqd 0x510(%rcx,%zmm12,1),%ymm17{%k1}
 15082b4:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 15082b8:	62 a2 7d 49 91 ac 19 10 05 00 00 	vpgatherqd 0x510(%rcx,%zmm11,1),%ymm21{%k1}
 15082c3:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 15082c7:	62 f1 05 48 fe ed    	vpaddd %zmm5,%zmm15,%zmm5
 15082cd:	62 a3 dd 40 3a db 01 	vinserti64x4 $0x1,%ymm19,%zmm20,%zmm19
 15082d4:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 15082da:	62 a2 7d 49 91 a4 21 90 07 00 00 	vpgatherqd 0x790(%rcx,%zmm12,1),%ymm20{%k1}
 15082e5:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 15082e9:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
 15082ee:	62 32 7d 49 91 a4 19 90 07 00 00 	vpgatherqd 0x790(%rcx,%zmm11,1),%ymm12{%k1}
 15082f9:	62 51 65 40 fe c0    	vpaddd %zmm8,%zmm19,%zmm8
 15082ff:	62 a3 d5 40 3a c9 01 	vinserti64x4 $0x1,%ymm17,%zmm21,%zmm17
 1508306:	62 d1 55 00 71 f6 07 	vpsllw $0x7,%xmm14,%xmm21
 150830d:	62 52 7d 48 31 f6    	vpmovzxbd %xmm14,%zmm14
 1508313:	62 b2 7e 08 29 d5    	vpmovb2m %xmm21,%k2
 1508319:	62 b1 55 00 71 f0 07 	vpsllw $0x7,%xmm16,%xmm21
 1508320:	62 a2 7d 48 31 c0    	vpmovzxbd %xmm16,%zmm16
 1508326:	62 51 75 40 fe c9    	vpaddd %zmm9,%zmm17,%zmm9
 150832c:	62 33 9d 48 3a dc 01 	vinserti64x4 $0x1,%ymm20,%zmm12,%zmm11
 1508333:	62 b1 5d 00 71 f2 07 	vpsllw $0x7,%xmm18,%xmm20
 150833a:	62 a2 7d 48 31 d2    	vpmovzxbd %xmm18,%zmm18
 1508340:	62 b2 7e 08 29 cd    	vpmovb2m %xmm21,%k1
 1508346:	62 d1 75 4a fe cf    	vpaddd %zmm15,%zmm1,%zmm1{%k2}
 150834c:	62 b2 7e 08 29 dc    	vpmovb2m %xmm20,%k3
 1508352:	62 d1 5d 00 71 f5 07 	vpsllw $0x7,%xmm13,%xmm20
 1508359:	62 52 7d 48 31 ed    	vpmovzxbd %xmm13,%zmm13
 150835f:	62 51 25 48 fe d2    	vpaddd %zmm10,%zmm11,%zmm10
 1508365:	62 b1 65 49 fe d9    	vpaddd %zmm17,%zmm3,%zmm3{%k1}
 150836b:	62 b2 7e 08 29 e4    	vpmovb2m %xmm20,%k4
 1508371:	62 d1 55 48 fa ee    	vpsubd %zmm14,%zmm5,%zmm5
 1508377:	62 b1 6d 4b fe d3    	vpaddd %zmm19,%zmm2,%zmm2{%k3}
 150837d:	62 31 35 48 fa c8    	vpsubd %zmm16,%zmm9,%zmm9
 1508383:	62 d1 5d 4c fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k4}
 1508389:	62 31 3d 48 fa c2    	vpsubd %zmm18,%zmm8,%zmm8
 150838f:	62 51 2d 48 fa d5    	vpsubd %zmm13,%zmm10,%zmm10
 1508395:	0f 85 25 fa ff ff    	jne    1507dc0 <run_backend_benchmark+0x6650>
 150839b:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 15083a1:	62 f1 5d 48 fe d3    	vpaddd %zmm3,%zmm4,%zmm2
 15083a7:	62 f1 3d 48 fe ed    	vpaddd %zmm5,%zmm8,%zmm5
 15083ad:	62 d1 2d 48 fe f1    	vpaddd %zmm9,%zmm10,%zmm6
 15083b3:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 15083bb:	62 f1 4d 48 fe ed    	vpaddd %zmm5,%zmm6,%zmm5
 15083c1:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 15083c7:	62 f3 fd 48 3b ee 01 	vextracti64x4 $0x1,%zmm5,%ymm6
 15083ce:	62 f3 fd 48 3b ca 01 	vextracti64x4 $0x1,%zmm1,%ymm2
 15083d5:	62 f1 55 48 fe ee    	vpaddd %zmm6,%zmm5,%zmm5
 15083db:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
 15083e1:	c4 e3 7d 39 ee 01    	vextracti128 $0x1,%ymm5,%xmm6
 15083e7:	c4 e3 7d 39 ca 01    	vextracti128 $0x1,%ymm1,%xmm2
 15083ed:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 15083f1:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 15083f5:	c5 f9 70 f5 ee       	vpshufd $0xee,%xmm5,%xmm6
 15083fa:	c5 f9 70 d1 ee       	vpshufd $0xee,%xmm1,%xmm2
 15083ff:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 1508403:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 1508407:	c5 f9 70 f5 55       	vpshufd $0x55,%xmm5,%xmm6
 150840c:	c5 f9 70 d1 55       	vpshufd $0x55,%xmm1,%xmm2
 1508411:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 1508415:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 1508419:	c4 c1 79 7e eb       	vmovd  %xmm5,%r11d
 150841e:	c5 f9 7e ca          	vmovd  %xmm1,%edx
 1508422:	39 f0                	cmp    %esi,%eax
 1508424:	0f 84 62 02 00 00    	je     150868c <run_backend_benchmark+0x6f1c>
 150842a:	40 f6 c6 30          	test   $0x30,%sil
 150842e:	0f 84 1b 02 00 00    	je     150864f <run_backend_benchmark+0x6edf>
 1508434:	48 89 c6             	mov    %rax,%rsi
 1508437:	62 f2 fd 48 7c e6    	vpbroadcastq %rsi,%zmm4
 150843d:	62 f1 dd 48 eb 1d f9 7d 01 ff 	vporq  -0xfe8207(%rip),%zmm4,%zmm3        # 520240 <branch_sizing_patterns+0x4b0>
 1508447:	62 f1 dd 48 eb 25 2f 7e 01 ff 	vporq  -0xfe81d1(%rip),%zmm4,%zmm4        # 520280 <branch_sizing_patterns+0x4f0>
 1508451:	62 72 fd 48 59 15 7d 7c 07 ff 	vpbroadcastq -0xf88383(%rip),%zmm10        # 5800d8 <x86_semantics_benchmark_code.registers+0xe8>
 150845b:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 1508463:	83 e0 f0             	and    $0xfffffff0,%eax
 1508466:	c4 c1 79 6e d3       	vmovd  %r11d,%xmm2
 150846b:	c5 f9 6e ca          	vmovd  %edx,%xmm1
 150846f:	48 29 c6             	sub    %rax,%rsi
 1508472:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1508480:	62 92 dd 48 40 f0    	vpmullq %zmm24,%zmm4,%zmm6
 1508486:	62 92 e5 48 40 e8    	vpmullq %zmm24,%zmm3,%zmm5
 150848c:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 1508490:	62 d1 dd 48 d4 e2    	vpaddq %zmm10,%zmm4,%zmm4
 1508496:	62 d1 e5 48 d4 da    	vpaddq %zmm10,%zmm3,%zmm3
 150849c:	48 83 c6 10          	add    $0x10,%rsi
 15084a0:	62 f1 fd 48 d4 fe    	vpaddq %zmm6,%zmm0,%zmm7
 15084a6:	c4 e1 f9 7e fa       	vmovq  %xmm7,%rdx
 15084ab:	c4 e3 f9 16 ff 01    	vpextrq $0x1,%xmm7,%rdi
 15084b1:	c4 c3 7d 39 f8 01    	vextracti128 $0x1,%ymm7,%xmm8
 15084b7:	0f b6 52 1e          	movzbl 0x1e(%rdx),%edx
 15084bb:	c5 79 6e ca          	vmovd  %edx,%xmm9
 15084bf:	c4 63 31 20 4f 1e 01 	vpinsrb $0x1,0x1e(%rdi),%xmm9,%xmm9
 15084c6:	c4 61 f9 7e c2       	vmovq  %xmm8,%rdx
 15084cb:	c4 63 f9 16 c7 01    	vpextrq $0x1,%xmm8,%rdi
 15084d1:	62 d3 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm7,%xmm8
 15084d8:	62 f3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm7,%xmm7
 15084df:	c4 63 31 20 4a 1e 02 	vpinsrb $0x2,0x1e(%rdx),%xmm9,%xmm9
 15084e6:	c4 61 f9 7e c2       	vmovq  %xmm8,%rdx
 15084eb:	c4 63 31 20 4f 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm9,%xmm9
 15084f2:	c4 63 f9 16 c7 01    	vpextrq $0x1,%xmm8,%rdi
 15084f8:	62 71 fd 48 d4 c5    	vpaddq %zmm5,%zmm0,%zmm8
 15084fe:	c4 63 31 20 4a 1e 04 	vpinsrb $0x4,0x1e(%rdx),%xmm9,%xmm9
 1508505:	c4 e3 f9 16 fa 01    	vpextrq $0x1,%xmm7,%rdx
 150850b:	c4 63 31 20 4f 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm9,%xmm9
 1508512:	c4 e1 f9 7e ff       	vmovq  %xmm7,%rdi
 1508517:	c4 e3 31 20 7f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm9,%xmm7
 150851e:	c4 61 f9 7e c7       	vmovq  %xmm8,%rdi
 1508523:	c4 43 7d 39 c1 01    	vextracti128 $0x1,%ymm8,%xmm9
 1508529:	c4 e3 41 20 7a 1e 07 	vpinsrb $0x7,0x1e(%rdx),%xmm7,%xmm7
 1508530:	c4 63 f9 16 c2 01    	vpextrq $0x1,%xmm8,%rdx
 1508536:	c4 e3 41 20 7f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm7,%xmm7
 150853d:	c4 61 f9 7e cf       	vmovq  %xmm9,%rdi
 1508542:	c4 e3 41 20 7a 1e 09 	vpinsrb $0x9,0x1e(%rdx),%xmm7,%xmm7
 1508549:	c4 63 f9 16 ca 01    	vpextrq $0x1,%xmm9,%rdx
 150854f:	62 53 7d 48 39 c1 02 	vextracti32x4 $0x2,%zmm8,%xmm9
 1508556:	62 53 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm8,%xmm8
 150855d:	c4 e3 41 20 7f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm7,%xmm7
 1508564:	c4 61 f9 7e cf       	vmovq  %xmm9,%rdi
 1508569:	c4 e3 41 20 7a 1e 0b 	vpinsrb $0xb,0x1e(%rdx),%xmm7,%xmm7
 1508570:	c4 63 f9 16 ca 01    	vpextrq $0x1,%xmm9,%rdx
 1508576:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
 150857b:	c4 e3 41 20 7f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm7,%xmm7
 1508582:	c4 61 f9 7e c7       	vmovq  %xmm8,%rdi
 1508587:	c4 e3 41 20 7a 1e 0d 	vpinsrb $0xd,0x1e(%rdx),%xmm7,%xmm7
 150858e:	c4 63 f9 16 c2 01    	vpextrq $0x1,%xmm8,%rdx
 1508594:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1508599:	62 72 7d 49 91 44 29 04 	vpgatherqd 0x10(%rcx,%zmm5,1),%ymm8{%k1}
 15085a1:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 15085a5:	62 72 7d 49 91 4c 31 04 	vpgatherqd 0x10(%rcx,%zmm6,1),%ymm9{%k1}
 15085ad:	c4 e3 41 20 7f 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm7,%xmm7
 15085b4:	62 d3 b5 48 3a e8 01 	vinserti64x4 $0x1,%ymm8,%zmm9,%zmm5
 15085bb:	62 f1 55 48 fe d2    	vpaddd %zmm2,%zmm5,%zmm2
 15085c1:	c4 e3 41 20 7a 1e 0f 	vpinsrb $0xf,0x1e(%rdx),%xmm7,%xmm7
 15085c8:	c5 c9 71 f7 07       	vpsllw $0x7,%xmm7,%xmm6
 15085cd:	62 f2 7d 48 31 ff    	vpmovzxbd %xmm7,%zmm7
 15085d3:	62 f2 7e 08 29 ce    	vpmovb2m %xmm6,%k1
 15085d9:	62 f1 75 49 fe cd    	vpaddd %zmm5,%zmm1,%zmm1{%k1}
 15085df:	62 f1 6d 48 fa d7    	vpsubd %zmm7,%zmm2,%zmm2
 15085e5:	0f 85 95 fe ff ff    	jne    1508480 <run_backend_benchmark+0x6d10>
 15085eb:	62 f3 fd 48 3b d0 01 	vextracti64x4 $0x1,%zmm2,%ymm0
 15085f2:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 15085f8:	c4 e3 7d 39 c2 01    	vextracti128 $0x1,%ymm0,%xmm2
 15085fe:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 1508602:	c5 f9 70 d0 ee       	vpshufd $0xee,%xmm0,%xmm2
 1508607:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 150860b:	c5 f9 70 d0 55       	vpshufd $0x55,%xmm0,%xmm2
 1508610:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 1508614:	c4 c1 79 7e c3       	vmovd  %xmm0,%r11d
 1508619:	62 f3 fd 48 3b c8 01 	vextracti64x4 $0x1,%zmm1,%ymm0
 1508620:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 1508626:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 150862c:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1508630:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 1508635:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1508639:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 150863e:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1508642:	c5 f9 7e c2          	vmovd  %xmm0,%edx
 1508646:	3b 84 24 90 00 00 00 	cmp    0x90(%rsp),%eax
 150864d:	74 3d                	je     150868c <run_backend_benchmark+0x6f1c>
 150864f:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 1508657:	48 29 c1             	sub    %rax,%rcx
 150865a:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 150865e:	49 8d 84 c1 8e 03 00 00 	lea    0x38e(%r9,%rax,8),%rax
 1508666:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 1508670:	8b 70 f2             	mov    -0xe(%rax),%esi
 1508673:	0f b6 38             	movzbl (%rax),%edi
 1508676:	41 01 f3             	add    %esi,%r11d
 1508679:	41 29 fb             	sub    %edi,%r11d
 150867c:	85 ff                	test   %edi,%edi
 150867e:	0f 44 f7             	cmove  %edi,%esi
 1508681:	48 83 c0 28          	add    $0x28,%rax
 1508685:	01 f2                	add    %esi,%edx
 1508687:	48 ff c9             	dec    %rcx
 150868a:	75 e4                	jne    1508670 <run_backend_benchmark+0x6f00>
 150868c:	ff c2                	inc    %edx
 150868e:	48 c1 e2 03          	shl    $0x3,%rdx
 1508692:	41 8b 49 78          	mov    0x78(%r9),%ecx
 1508696:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 150869e:	4b 8d 7c 2a 03       	lea    0x3(%r10,%r13,1),%rdi
 15086a3:	4f 8d 04 2a          	lea    (%r10,%r13,1),%r8
 15086a7:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 15086ab:	01 c8                	add    %ecx,%eax
 15086ad:	8d 70 01             	lea    0x1(%rax),%esi
 15086b0:	48 89 84 24 f0 00 00 00 	mov    %rax,0xf0(%rsp)
 15086b8:	4c 39 c7             	cmp    %r8,%rdi
 15086bb:	73 14                	jae    15086d1 <run_backend_benchmark+0x6f61>
 15086bd:	48 c7 44 24 60 00 00 00 00 	movq   $0x0,0x60(%rsp)
 15086c6:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 15086cf:	eb 5c                	jmp    150872d <run_backend_benchmark+0x6fbd>
 15086d1:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 15086d6:	48 8d 04 b5 00 00 00 00 	lea    0x0(,%rsi,4),%rax
 15086de:	4c 29 ef             	sub    %r13,%rdi
 15086e1:	4d 89 f0             	mov    %r14,%r8
 15086e4:	49 29 f8             	sub    %rdi,%r8
 15086e7:	72 2b                	jb     1508714 <run_backend_benchmark+0x6fa4>
 15086e9:	4c 39 c0             	cmp    %r8,%rax
 15086ec:	77 26                	ja     1508714 <run_backend_benchmark+0x6fa4>
 15086ee:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 15086f3:	48 01 c7             	add    %rax,%rdi
 15086f6:	49 89 fa             	mov    %rdi,%r10
 15086f9:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 15086fe:	49 01 c0             	add    %rax,%r8
 1508701:	4c 89 c7             	mov    %r8,%rdi
 1508704:	4c 29 ef             	sub    %r13,%rdi
 1508707:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
 150870c:	4d 89 f0             	mov    %r14,%r8
 150870f:	49 29 f8             	sub    %rdi,%r8
 1508712:	eb 09                	jmp    150871d <run_backend_benchmark+0x6fad>
 1508714:	48 c7 44 24 60 00 00 00 00 	movq   $0x0,0x60(%rsp)
 150871d:	4c 39 f7             	cmp    %r14,%rdi
 1508720:	77 a4                	ja     15086c6 <run_backend_benchmark+0x6f56>
 1508722:	4c 39 c0             	cmp    %r8,%rax
 1508725:	77 9f                	ja     15086c6 <run_backend_benchmark+0x6f56>
 1508727:	48 01 c7             	add    %rax,%rdi
 150872a:	49 89 fa             	mov    %rdi,%r10
 150872d:	49 8b 81 90 0d 00 00 	mov    0xd90(%r9),%rax
 1508734:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 150873a:	4c 89 94 24 a0 00 00 00 	mov    %r10,0xa0(%rsp)
 1508742:	4c 89 9c 24 58 01 00 00 	mov    %r11,0x158(%rsp)
 150874a:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 150874f:	4c 89 f0             	mov    %r14,%rax
 1508752:	4c 29 d0             	sub    %r10,%rax
 1508755:	40 0f 93 c7          	setae  %dil
 1508759:	48 39 f0             	cmp    %rsi,%rax
 150875c:	0f 93 c0             	setae  %al
 150875f:	40 20 f8             	and    %dil,%al
 1508762:	4c 0f 45 c6          	cmovne %rsi,%r8
 1508766:	4d 01 d0             	add    %r10,%r8
 1508769:	4f 8d 54 05 03       	lea    0x3(%r13,%r8,1),%r10
 150876e:	4b 8d 3c 28          	lea    (%r8,%r13,1),%rdi
 1508772:	49 83 e2 fc          	and    $0xfffffffffffffffc,%r10
 1508776:	49 39 fa             	cmp    %rdi,%r10
 1508779:	73 22                	jae    150879d <run_backend_benchmark+0x702d>
 150877b:	4c 89 c7             	mov    %r8,%rdi
 150877e:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 1508787:	45 31 ed             	xor    %r13d,%r13d
 150878a:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 1508793:	31 f6                	xor    %esi,%esi
 1508795:	4d 89 ca             	mov    %r9,%r10
 1508798:	e9 1e 01 00 00       	jmp    15088bb <run_backend_benchmark+0x714b>
 150879d:	41 8b b9 90 00 00 00 	mov    0x90(%r9),%edi
 15087a4:	4d 89 f1             	mov    %r14,%r9
 15087a7:	45 8d 5c 3b 01       	lea    0x1(%r11,%rdi,1),%r11d
 15087ac:	4c 89 d7             	mov    %r10,%rdi
 15087af:	4c 29 ef             	sub    %r13,%rdi
 15087b2:	49 29 f9             	sub    %rdi,%r9
 15087b5:	72 29                	jb     15087e0 <run_backend_benchmark+0x7070>
 15087b7:	4a 8d 1c 9d 00 00 00 00 	lea    0x0(,%r11,4),%rbx
 15087bf:	4c 39 cb             	cmp    %r9,%rbx
 15087c2:	77 1c                	ja     15087e0 <run_backend_benchmark+0x7070>
 15087c4:	4d 89 d5             	mov    %r10,%r13
 15087c7:	48 01 df             	add    %rbx,%rdi
 15087ca:	49 01 da             	add    %rbx,%r10
 15087cd:	4d 89 f1             	mov    %r14,%r9
 15087d0:	49 89 f8             	mov    %rdi,%r8
 15087d3:	4c 89 d7             	mov    %r10,%rdi
 15087d6:	48 2b 7c 24 50       	sub    0x50(%rsp),%rdi
 15087db:	49 29 f9             	sub    %rdi,%r9
 15087de:	eb 03                	jmp    15087e3 <run_backend_benchmark+0x7073>
 15087e0:	45 31 ed             	xor    %r13d,%r13d
 15087e3:	4c 39 f7             	cmp    %r14,%rdi
 15087e6:	77 3e                	ja     1508826 <run_backend_benchmark+0x70b6>
 15087e8:	49 c1 e3 03          	shl    $0x3,%r11
 15087ec:	4d 39 cb             	cmp    %r9,%r11
 15087ef:	77 35                	ja     1508826 <run_backend_benchmark+0x70b6>
 15087f1:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
 15087f6:	4c 01 df             	add    %r11,%rdi
 15087f9:	4d 8d 5c 39 03       	lea    0x3(%r9,%rdi,1),%r11
 15087fe:	4e 8d 04 0f          	lea    (%rdi,%r9,1),%r8
 1508802:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 1508806:	4d 39 c3             	cmp    %r8,%r11
 1508809:	73 29                	jae    1508834 <run_backend_benchmark+0x70c4>
 150880b:	4c 89 54 24 78       	mov    %r10,0x78(%rsp)
 1508810:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 1508818:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 1508821:	e9 93 00 00 00       	jmp    15088b9 <run_backend_benchmark+0x7149>
 1508826:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 150882f:	4d 89 d3             	mov    %r10,%r11
 1508832:	eb 14                	jmp    1508848 <run_backend_benchmark+0x70d8>
 1508834:	49 89 f8             	mov    %rdi,%r8
 1508837:	4c 89 df             	mov    %r11,%rdi
 150883a:	4c 29 cf             	sub    %r9,%rdi
 150883d:	4d 89 f1             	mov    %r14,%r9
 1508840:	4c 89 54 24 78       	mov    %r10,0x78(%rsp)
 1508845:	49 29 f9             	sub    %rdi,%r9
 1508848:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 1508850:	4c 39 f7             	cmp    %r14,%rdi
 1508853:	77 2a                	ja     150887f <run_backend_benchmark+0x710f>
 1508855:	48 c1 e6 04          	shl    $0x4,%rsi
 1508859:	4c 39 ce             	cmp    %r9,%rsi
 150885c:	77 21                	ja     150887f <run_backend_benchmark+0x710f>
 150885e:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
 1508863:	48 01 f7             	add    %rsi,%rdi
 1508866:	49 8d 74 39 03       	lea    0x3(%r9,%rdi,1),%rsi
 150886b:	4e 8d 04 0f          	lea    (%rdi,%r9,1),%r8
 150886f:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 1508873:	4c 39 c6             	cmp    %r8,%rsi
 1508876:	73 15                	jae    150888d <run_backend_benchmark+0x711d>
 1508878:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
 150887d:	eb 3a                	jmp    15088b9 <run_backend_benchmark+0x7149>
 150887f:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 1508888:	4c 89 de             	mov    %r11,%rsi
 150888b:	eb 14                	jmp    15088a1 <run_backend_benchmark+0x7131>
 150888d:	49 89 f8             	mov    %rdi,%r8
 1508890:	48 89 f7             	mov    %rsi,%rdi
 1508893:	4c 29 cf             	sub    %r9,%rdi
 1508896:	4d 89 f1             	mov    %r14,%r9
 1508899:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
 150889e:	49 29 f9             	sub    %rdi,%r9
 15088a1:	4c 39 f7             	cmp    %r14,%rdi
 15088a4:	77 10                	ja     15088b6 <run_backend_benchmark+0x7146>
 15088a6:	ff c1                	inc    %ecx
 15088a8:	48 c1 e1 02          	shl    $0x2,%rcx
 15088ac:	4c 39 c9             	cmp    %r9,%rcx
 15088af:	77 05                	ja     15088b6 <run_backend_benchmark+0x7146>
 15088b1:	48 01 cf             	add    %rcx,%rdi
 15088b4:	eb 05                	jmp    15088bb <run_backend_benchmark+0x714b>
 15088b6:	4c 89 c7             	mov    %r8,%rdi
 15088b9:	31 f6                	xor    %esi,%esi
 15088bb:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 15088c0:	4c 89 f1             	mov    %r14,%rcx
 15088c3:	49 89 b3 08 3a 00 00 	mov    %rsi,0x3a08(%r11)
 15088ca:	41 8b 5a 78          	mov    0x78(%r10),%ebx
 15088ce:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
 15088d3:	ff c3                	inc    %ebx
 15088d5:	48 29 f9             	sub    %rdi,%rcx
 15088d8:	41 0f 92 c0          	setb   %r8b
 15088dc:	48 39 d9             	cmp    %rbx,%rcx
 15088df:	4a 8d 0c 17          	lea    (%rdi,%r10,1),%rcx
 15088e3:	41 0f 92 c1          	setb   %r9b
 15088e7:	45 08 c1             	or     %r8b,%r9b
 15088ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 15088f0:	45 84 c9             	test   %r9b,%r9b
 15088f3:	49 0f 45 d8          	cmovne %r8,%rbx
 15088f7:	49 0f 45 c8          	cmovne %r8,%rcx
 15088fb:	48 01 fb             	add    %rdi,%rbx
 15088fe:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 1508904:	49 89 8b 40 3a 00 00 	mov    %rcx,0x3a40(%r11)
 150890b:	74 17                	je     1508924 <run_backend_benchmark+0x71b4>
 150890d:	4a 8d 7c 13 03       	lea    0x3(%rbx,%r10,1),%rdi
 1508912:	4e 8d 04 13          	lea    (%rbx,%r10,1),%r8
 1508916:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 150891a:	4c 39 c7             	cmp    %r8,%rdi
 150891d:	73 2e                	jae    150894d <run_backend_benchmark+0x71dd>
 150891f:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 1508924:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 150892c:	49 8d 93 48 3a 00 00 	lea    0x3a48(%r11),%rdx
 1508933:	49 c7 83 48 3a 00 00 00 00 00 00 	movq   $0x0,0x3a48(%r11)
 150893e:	31 ff                	xor    %edi,%edi
 1508940:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 1508948:	e9 92 00 00 00       	jmp    15089df <run_backend_benchmark+0x726f>
 150894d:	49 89 f8             	mov    %rdi,%r8
 1508950:	4d 29 d0             	sub    %r10,%r8
 1508953:	4d 89 f1             	mov    %r14,%r9
 1508956:	4d 29 c1             	sub    %r8,%r9
 1508959:	72 31                	jb     150898c <run_backend_benchmark+0x721c>
 150895b:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 1508963:	45 8b 92 90 00 00 00 	mov    0x90(%r10),%r10d
 150896a:	41 ff c2             	inc    %r10d
 150896d:	49 c1 e2 02          	shl    $0x2,%r10
 1508971:	4d 39 ca             	cmp    %r9,%r10
 1508974:	77 16                	ja     150898c <run_backend_benchmark+0x721c>
 1508976:	49 89 f9             	mov    %rdi,%r9
 1508979:	4c 01 d7             	add    %r10,%rdi
 150897c:	4c 89 c3             	mov    %r8,%rbx
 150897f:	4c 01 d3             	add    %r10,%rbx
 1508982:	49 89 f8             	mov    %rdi,%r8
 1508985:	4c 2b 44 24 50       	sub    0x50(%rsp),%r8
 150898a:	eb 03                	jmp    150898f <run_backend_benchmark+0x721f>
 150898c:	45 31 c9             	xor    %r9d,%r9d
 150898f:	4c 8b 54 24 58       	mov    0x58(%rsp),%r10
 1508994:	4d 8d 9a 48 3a 00 00 	lea    0x3a48(%r10),%r11
 150899b:	4d 89 8a 48 3a 00 00 	mov    %r9,0x3a48(%r10)
 15089a2:	4d 89 f1             	mov    %r14,%r9
 15089a5:	4d 29 c1             	sub    %r8,%r9
 15089a8:	4c 89 9c 24 b0 00 00 00 	mov    %r11,0xb0(%rsp)
 15089b0:	72 1e                	jb     15089d0 <run_backend_benchmark+0x7260>
 15089b2:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 15089ba:	4c 39 ca             	cmp    %r9,%rdx
 15089bd:	77 08                	ja     15089c7 <run_backend_benchmark+0x7257>
 15089bf:	49 01 d0             	add    %rdx,%r8
 15089c2:	4c 89 c3             	mov    %r8,%rbx
 15089c5:	eb 02                	jmp    15089c9 <run_backend_benchmark+0x7259>
 15089c7:	31 ff                	xor    %edi,%edi
 15089c9:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 15089ce:	eb 0f                	jmp    15089df <run_backend_benchmark+0x726f>
 15089d0:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 15089d5:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 15089dd:	31 ff                	xor    %edi,%edi
 15089df:	49 89 bb 50 3a 00 00 	mov    %rdi,0x3a50(%r11)
 15089e6:	31 d2                	xor    %edx,%edx
 15089e8:	41 80 ba ec 02 00 00 01 	cmpb   $0x1,0x2ec(%r10)
 15089f0:	75 14                	jne    1508a06 <run_backend_benchmark+0x7296>
 15089f2:	41 8b 92 e4 02 00 00 	mov    0x2e4(%r10),%edx
 15089f9:	4c 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%r8
 1508a01:	41 8d 54 10 01       	lea    0x1(%r8,%rdx,1),%edx
 1508a06:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 1508a0b:	41 89 90 18 3a 00 00 	mov    %edx,0x3a18(%r8)
 1508a12:	41 80 ba ec 02 00 00 01 	cmpb   $0x1,0x2ec(%r10)
 1508a1a:	75 1d                	jne    1508a39 <run_backend_benchmark+0x72c9>
 1508a1c:	4d 89 f1             	mov    %r14,%r9
 1508a1f:	49 29 d9             	sub    %rbx,%r9
 1508a22:	72 15                	jb     1508a39 <run_backend_benchmark+0x72c9>
 1508a24:	41 89 d0             	mov    %edx,%r8d
 1508a27:	4d 39 c1             	cmp    %r8,%r9
 1508a2a:	72 0d                	jb     1508a39 <run_backend_benchmark+0x72c9>
 1508a2c:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
 1508a31:	48 01 da             	add    %rbx,%rdx
 1508a34:	4c 01 c3             	add    %r8,%rbx
 1508a37:	eb 02                	jmp    1508a3b <run_backend_benchmark+0x72cb>
 1508a39:	31 d2                	xor    %edx,%edx
 1508a3b:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 1508a43:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 1508a48:	4c 03 44 24 50       	add    0x50(%rsp),%r8
 1508a4d:	4c 89 84 24 a0 00 00 00 	mov    %r8,0xa0(%rsp)
 1508a55:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 1508a5a:	49 89 90 10 3a 00 00 	mov    %rdx,0x3a10(%r8)
 1508a61:	41 0f 95 c0          	setne  %r8b
 1508a65:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 1508a6b:	0f 84 9e 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508a71:	4d 85 c9             	test   %r9,%r9
 1508a74:	0f 84 95 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508a7a:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
 1508a80:	0f 84 89 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508a86:	41 20 c0             	and    %al,%r8b
 1508a89:	0f 84 80 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508a8f:	4d 85 ed             	test   %r13,%r13
 1508a92:	0f 84 77 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508a98:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 1508a9e:	0f 84 6b 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508aa4:	48 85 f6             	test   %rsi,%rsi
 1508aa7:	0f 84 62 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508aad:	48 85 c9             	test   %rcx,%rcx
 1508ab0:	0f 84 59 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508ab6:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 1508abc:	74 1b                	je     1508ad9 <run_backend_benchmark+0x7369>
 1508abe:	48 85 ff             	test   %rdi,%rdi
 1508ac1:	0f 84 48 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508ac7:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 1508acf:	48 83 38 00          	cmpq   $0x0,(%rax)
 1508ad3:	0f 84 36 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508ad9:	41 0f b6 82 ec 02 00 00 	movzbl 0x2ec(%r10),%eax
 1508ae1:	3c 01                	cmp    $0x1,%al
 1508ae3:	75 09                	jne    1508aee <run_backend_benchmark+0x737e>
 1508ae5:	48 85 d2             	test   %rdx,%rdx
 1508ae8:	0f 84 21 20 00 00    	je     150ab0f <run_backend_benchmark+0x939f>
 1508aee:	48 89 9c 24 10 01 00 00 	mov    %rbx,0x110(%rsp)
 1508af6:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
 1508afb:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 1508b03:	84 c0                	test   %al,%al
 1508b05:	74 62                	je     1508b69 <run_backend_benchmark+0x73f9>
 1508b07:	c6 02 00             	movb   $0x0,(%rdx)
 1508b0a:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 1508b12:	48 8b bb 10 3a 00 00 	mov    0x3a10(%rbx),%rdi
 1508b19:	41 8b 92 e4 02 00 00 	mov    0x2e4(%r10),%edx
 1508b20:	48 ff c7             	inc    %rdi
 1508b23:	c5 f8 77             	vzeroupper
 1508b26:	e8 25 b9 25 ff       	call   764450 <memcpy@plt>
 1508b2b:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 1508b33:	48 8b 83 10 3a 00 00 	mov    0x3a10(%rbx),%rax
 1508b3a:	4c 89 f2             	mov    %r14,%rdx
 1508b3d:	8b 89 e4 02 00 00    	mov    0x2e4(%rcx),%ecx
 1508b43:	48 8d 7c 08 01       	lea    0x1(%rax,%rcx,1),%rdi
 1508b48:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 1508b50:	48 8d b1 2d 03 00 00 	lea    0x32d(%rcx),%rsi
 1508b57:	e8 f4 b8 25 ff       	call   764450 <memcpy@plt>
 1508b5c:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 1508b61:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 1508b69:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 1508b6f:	45 85 f6             	test   %r14d,%r14d
 1508b72:	0f 84 52 01 00 00    	je     1508cca <run_backend_benchmark+0x755a>
 1508b78:	49 8d 8a 70 03 00 00 	lea    0x370(%r10),%rcx
 1508b7f:	31 c0                	xor    %eax,%eax
 1508b81:	31 d2                	xor    %edx,%edx
 1508b83:	eb 1c                	jmp    1508ba1 <run_backend_benchmark+0x7431>
 1508b85:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1508b90:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 1508b95:	48 ff c2             	inc    %rdx
 1508b98:	4c 39 f2             	cmp    %r14,%rdx
 1508b9b:	0f 84 2b 01 00 00    	je     1508ccc <run_backend_benchmark+0x755c>
 1508ba1:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 1508ba7:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
 1508bab:	48 8d 34 f9          	lea    (%rcx,%rdi,8),%rsi
 1508baf:	74 2f                	je     1508be0 <run_backend_benchmark+0x7470>
 1508bb1:	44 0f b6 46 1d       	movzbl 0x1d(%rsi),%r8d
 1508bb6:	49 81 f8 ff 00 00 00 	cmp    $0xff,%r8
 1508bbd:	74 21                	je     1508be0 <run_backend_benchmark+0x7470>
 1508bbf:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 1508bc4:	4d 6b c0 74          	imul   $0x74,%r8,%r8
 1508bc8:	4f 8d 44 01 68       	lea    0x68(%r9,%r8,1),%r8
 1508bcd:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 1508bd2:	eb 20                	jmp    1508bf4 <run_backend_benchmark+0x7484>
 1508bd4:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1508be0:	44 8b 46 1c          	mov    0x1c(%rsi),%r8d
 1508be4:	41 80 f8 0e          	cmp    $0xe,%r8b
 1508be8:	45 0f 43 c3          	cmovae %r11d,%r8d
 1508bec:	45 0f b6 c0          	movzbl %r8b,%r8d
 1508bf0:	4f 8d 04 87          	lea    (%r15,%r8,4),%r8
 1508bf4:	45 8b 00             	mov    (%r8),%r8d
 1508bf7:	0f b6 7c f9 1e       	movzbl 0x1e(%rcx,%rdi,8),%edi
 1508bfc:	45 89 04 91          	mov    %r8d,(%r9,%rdx,4)
 1508c00:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 1508c05:	44 8b 46 10          	mov    0x10(%rsi),%r8d
 1508c09:	41 29 f8             	sub    %edi,%r8d
 1508c0c:	45 89 04 91          	mov    %r8d,(%r9,%rdx,4)
 1508c10:	4c 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%r9
 1508c18:	41 c6 04 11 00       	movb   $0x0,(%r9,%rdx,1)
 1508c1d:	39 7e 10             	cmp    %edi,0x10(%rsi)
 1508c20:	0f 86 6a ff ff ff    	jbe    1508b90 <run_backend_benchmark+0x7420>
 1508c26:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 1508c2c:	75 73                	jne    1508ca1 <run_backend_benchmark+0x7531>
 1508c2e:	eb 1d                	jmp    1508c4d <run_backend_benchmark+0x74dd>
 1508c30:	45 0f b6 c0          	movzbl %r8b,%r8d
 1508c34:	41 89 c1             	mov    %eax,%r9d
 1508c37:	ff c0                	inc    %eax
 1508c39:	ff c7                	inc    %edi
 1508c3b:	47 8b 04 87          	mov    (%r15,%r8,4),%r8d
 1508c3f:	47 89 44 8d 00       	mov    %r8d,0x0(%r13,%r9,4)
 1508c44:	3b 7e 10             	cmp    0x10(%rsi),%edi
 1508c47:	0f 83 43 ff ff ff    	jae    1508b90 <run_backend_benchmark+0x7420>
 1508c4d:	44 8b 46 08          	mov    0x8(%rsi),%r8d
 1508c51:	4d 8b 4a 20          	mov    0x20(%r10),%r9
 1508c55:	41 01 f8             	add    %edi,%r8d
 1508c58:	47 0f b6 04 01       	movzbl (%r9,%r8,1),%r8d
 1508c5d:	41 80 f8 0e          	cmp    $0xe,%r8b
 1508c61:	72 cd                	jb     1508c30 <run_backend_benchmark+0x74c0>
 1508c63:	45 31 c0             	xor    %r8d,%r8d
 1508c66:	eb c8                	jmp    1508c30 <run_backend_benchmark+0x74c0>
 1508c68:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1508c70:	4d 8b 4a 20          	mov    0x20(%r10),%r9
 1508c74:	47 0f b6 04 01       	movzbl (%r9,%r8,1),%r8d
 1508c79:	41 80 f8 0e          	cmp    $0xe,%r8b
 1508c7d:	45 0f 43 c3          	cmovae %r11d,%r8d
 1508c81:	45 0f b6 c0          	movzbl %r8b,%r8d
 1508c85:	4f 8d 04 87          	lea    (%r15,%r8,4),%r8
 1508c89:	45 8b 00             	mov    (%r8),%r8d
 1508c8c:	41 89 c1             	mov    %eax,%r9d
 1508c8f:	ff c0                	inc    %eax
 1508c91:	ff c7                	inc    %edi
 1508c93:	47 89 44 8d 00       	mov    %r8d,0x0(%r13,%r9,4)
 1508c98:	3b 7e 10             	cmp    0x10(%rsi),%edi
 1508c9b:	0f 83 ef fe ff ff    	jae    1508b90 <run_backend_benchmark+0x7420>
 1508ca1:	44 8b 46 08          	mov    0x8(%rsi),%r8d
 1508ca5:	4d 8b 4a 40          	mov    0x40(%r10),%r9
 1508ca9:	41 01 f8             	add    %edi,%r8d
 1508cac:	47 0f b6 0c 01       	movzbl (%r9,%r8,1),%r9d
 1508cb1:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 1508cb8:	74 b6                	je     1508c70 <run_backend_benchmark+0x7500>
 1508cba:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 1508cbf:	4d 6b c1 74          	imul   $0x74,%r9,%r8
 1508cc3:	4f 8d 44 04 68       	lea    0x68(%r12,%r8,1),%r8
 1508cc8:	eb bf                	jmp    1508c89 <run_backend_benchmark+0x7519>
 1508cca:	31 c0                	xor    %eax,%eax
 1508ccc:	41 83 7a 78 00       	cmpl   $0x0,0x78(%r10)
 1508cd1:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 1508cd6:	0f 84 19 02 00 00    	je     1508ef5 <run_backend_benchmark+0x7785>
 1508cdc:	49 8d 8a 70 03 00 00 	lea    0x370(%r10),%rcx
 1508ce3:	31 d2                	xor    %edx,%edx
 1508ce5:	eb 40                	jmp    1508d27 <run_backend_benchmark+0x75b7>
 1508ce7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 1508cf0:	49 8b 7a 50          	mov    0x50(%r10),%rdi
 1508cf4:	41 8b b2 e4 02 00 00 	mov    0x2e4(%r10),%esi
 1508cfb:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 1508cfe:	8d 74 3e 01          	lea    0x1(%rsi,%rdi,1),%esi
 1508d02:	48 8b bb 08 3a 00 00 	mov    0x3a08(%rbx),%rdi
 1508d09:	89 34 97             	mov    %esi,(%rdi,%rdx,4)
 1508d0c:	48 8b b3 40 3a 00 00 	mov    0x3a40(%rbx),%rsi
 1508d13:	c6 04 16 00          	movb   $0x0,(%rsi,%rdx,1)
 1508d17:	48 ff c2             	inc    %rdx
 1508d1a:	41 8b 72 78          	mov    0x78(%r10),%esi
 1508d1e:	48 39 f2             	cmp    %rsi,%rdx
 1508d21:	0f 83 ce 01 00 00    	jae    1508ef5 <run_backend_benchmark+0x7785>
 1508d27:	49 8b 72 50          	mov    0x50(%r10),%rsi
 1508d2b:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 1508d31:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 1508d34:	48 8d 34 b6          	lea    (%rsi,%rsi,4),%rsi
 1508d38:	48 8d 34 f1          	lea    (%rcx,%rsi,8),%rsi
 1508d3c:	74 22                	je     1508d60 <run_backend_benchmark+0x75f0>
 1508d3e:	0f b6 7e 1d          	movzbl 0x1d(%rsi),%edi
 1508d42:	48 81 ff ff 00 00 00 	cmp    $0xff,%rdi
 1508d49:	74 15                	je     1508d60 <run_backend_benchmark+0x75f0>
 1508d4b:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 1508d50:	48 6b f7 74          	imul   $0x74,%rdi,%rsi
 1508d54:	49 8d 74 34 68       	lea    0x68(%r12,%rsi,1),%rsi
 1508d59:	eb 18                	jmp    1508d73 <run_backend_benchmark+0x7603>
 1508d5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1508d60:	8b 76 1c             	mov    0x1c(%rsi),%esi
 1508d63:	40 80 fe 0e          	cmp    $0xe,%sil
 1508d67:	41 0f 43 f3          	cmovae %r11d,%esi
 1508d6b:	40 0f b6 f6          	movzbl %sil,%esi
 1508d6f:	49 8d 34 b7          	lea    (%r15,%rsi,4),%rsi
 1508d73:	8b 36                	mov    (%rsi),%esi
 1508d75:	41 8d 3c 16          	lea    (%r14,%rdx,1),%edi
 1508d79:	4c 8b a4 24 a0 00 00 00 	mov    0xa0(%rsp),%r12
 1508d81:	41 89 34 b9          	mov    %esi,(%r9,%rdi,4)
 1508d85:	49 8b 72 60          	mov    0x60(%r10),%rsi
 1508d89:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 1508d8c:	41 89 34 b8          	mov    %esi,(%r8,%rdi,4)
 1508d90:	41 c6 04 3c 00       	movb   $0x0,(%r12,%rdi,1)
 1508d95:	49 8b 72 60          	mov    0x60(%r10),%rsi
 1508d99:	83 3c 96 00          	cmpl   $0x0,(%rsi,%rdx,4)
 1508d9d:	0f 84 c1 00 00 00    	je     1508e64 <run_backend_benchmark+0x76f4>
 1508da3:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 1508da9:	0f 84 e1 00 00 00    	je     1508e90 <run_backend_benchmark+0x7720>
 1508daf:	31 f6                	xor    %esi,%esi
 1508db1:	eb 45                	jmp    1508df8 <run_backend_benchmark+0x7688>
 1508db3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1508dc0:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 1508dc5:	4d 6b c9 74          	imul   $0x74,%r9,%r9
 1508dc9:	4d 89 d6             	mov    %r10,%r14
 1508dcc:	47 8b 54 0c 68       	mov    0x68(%r12,%r9,1),%r10d
 1508dd1:	47 89 54 85 00       	mov    %r10d,0x0(%r13,%r8,4)
 1508dd6:	47 8b 4c 0c 5c       	mov    0x5c(%r12,%r9,1),%r9d
 1508ddb:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 1508de3:	ff c6                	inc    %esi
 1508de5:	4d 89 f2             	mov    %r14,%r10
 1508de8:	4d 8b 00             	mov    (%r8),%r8
 1508deb:	45 89 0c b8          	mov    %r9d,(%r8,%rdi,4)
 1508def:	49 8b 7e 60          	mov    0x60(%r14),%rdi
 1508df3:	3b 34 97             	cmp    (%rdi,%rdx,4),%esi
 1508df6:	73 58                	jae    1508e50 <run_backend_benchmark+0x76e0>
 1508df8:	49 8b 7a 58          	mov    0x58(%r10),%rdi
 1508dfc:	4d 8b 8a 88 00 00 00 	mov    0x88(%r10),%r9
 1508e03:	44 8d 04 30          	lea    (%rax,%rsi,1),%r8d
 1508e07:	45 89 c0             	mov    %r8d,%r8d
 1508e0a:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 1508e0d:	01 f7                	add    %esi,%edi
 1508e0f:	45 0f b6 0c 39       	movzbl (%r9,%rdi,1),%r9d
 1508e14:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 1508e1b:	75 a3                	jne    1508dc0 <run_backend_benchmark+0x7650>
 1508e1d:	4d 8b 8a 80 00 00 00 	mov    0x80(%r10),%r9
 1508e24:	4d 89 d6             	mov    %r10,%r14
 1508e27:	45 0f b6 14 39       	movzbl (%r9,%rdi,1),%r10d
 1508e2c:	45 31 c9             	xor    %r9d,%r9d
 1508e2f:	41 80 fa 0e          	cmp    $0xe,%r10b
 1508e33:	45 0f 43 d1          	cmovae %r9d,%r10d
 1508e37:	45 0f b6 d2          	movzbl %r10b,%r10d
 1508e3b:	47 8b 14 97          	mov    (%r15,%r10,4),%r10d
 1508e3f:	47 89 54 85 00       	mov    %r10d,0x0(%r13,%r8,4)
 1508e44:	eb 95                	jmp    1508ddb <run_backend_benchmark+0x766b>
 1508e46:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 1508e50:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 1508e58:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 1508e5d:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 1508e62:	01 f0                	add    %esi,%eax
 1508e64:	49 8b 7a 68          	mov    0x68(%r10),%rdi
 1508e68:	48 85 ff             	test   %rdi,%rdi
 1508e6b:	0f 84 7f fe ff ff    	je     1508cf0 <run_backend_benchmark+0x7580>
 1508e71:	31 f6                	xor    %esi,%esi
 1508e73:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
 1508e77:	0f 85 85 fe ff ff    	jne    1508d02 <run_backend_benchmark+0x7592>
 1508e7d:	e9 6e fe ff ff       	jmp    1508cf0 <run_backend_benchmark+0x7580>
 1508e82:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1508e90:	31 f6                	xor    %esi,%esi
 1508e92:	eb 28                	jmp    1508ebc <run_backend_benchmark+0x774c>
 1508e94:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1508ea0:	40 0f b6 ff          	movzbl %dil,%edi
 1508ea4:	44 8d 04 30          	lea    (%rax,%rsi,1),%r8d
 1508ea8:	ff c6                	inc    %esi
 1508eaa:	41 8b 3c bf          	mov    (%r15,%rdi,4),%edi
 1508eae:	43 89 7c 85 00       	mov    %edi,0x0(%r13,%r8,4)
 1508eb3:	49 8b 7a 60          	mov    0x60(%r10),%rdi
 1508eb7:	3b 34 97             	cmp    (%rdi,%rdx,4),%esi
 1508eba:	73 24                	jae    1508ee0 <run_backend_benchmark+0x7770>
 1508ebc:	49 8b 7a 58          	mov    0x58(%r10),%rdi
 1508ec0:	4d 8b 82 80 00 00 00 	mov    0x80(%r10),%r8
 1508ec7:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 1508eca:	01 f7                	add    %esi,%edi
 1508ecc:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
 1508ed1:	40 80 ff 0e          	cmp    $0xe,%dil
 1508ed5:	72 c9                	jb     1508ea0 <run_backend_benchmark+0x7730>
 1508ed7:	31 ff                	xor    %edi,%edi
 1508ed9:	eb c5                	jmp    1508ea0 <run_backend_benchmark+0x7730>
 1508edb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1508ee0:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 1508ee5:	01 f0                	add    %esi,%eax
 1508ee7:	49 8b 7a 68          	mov    0x68(%r10),%rdi
 1508eeb:	48 85 ff             	test   %rdi,%rdi
 1508eee:	75 81                	jne    1508e71 <run_backend_benchmark+0x7701>
 1508ef0:	e9 fb fd ff ff       	jmp    1508cf0 <run_backend_benchmark+0x7580>
 1508ef5:	64 48 8b 34 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%rsi
 1508efe:	48 85 f6             	test   %rsi,%rsi
 1508f01:	74 36                	je     1508f39 <run_backend_benchmark+0x77c9>
 1508f03:	64 48 8b 14 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rdx
 1508f0c:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 1508f11:	4c 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%r9
 1508f19:	45 89 cb             	mov    %r9d,%r11d
 1508f1c:	45 85 c9             	test   %r9d,%r9d
 1508f1f:	0f 84 0a 02 00 00    	je     150912f <run_backend_benchmark+0x79bf>
 1508f25:	41 83 f9 08          	cmp    $0x8,%r9d
 1508f29:	0f 83 93 00 00 00    	jae    1508fc2 <run_backend_benchmark+0x7852>
 1508f2f:	31 c0                	xor    %eax,%eax
 1508f31:	45 31 e4             	xor    %r12d,%r12d
 1508f34:	e9 97 01 00 00       	jmp    15090d0 <run_backend_benchmark+0x7960>
 1508f39:	49 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r14
 1508f43:	ba 03 00 00 00       	mov    $0x3,%edx
 1508f48:	b9 22 40 00 00       	mov    $0x4022,%ecx
 1508f4d:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 1508f53:	31 ff                	xor    %edi,%edi
 1508f55:	45 31 c9             	xor    %r9d,%r9d
 1508f58:	4c 89 f6             	mov    %r14,%rsi
 1508f5b:	c5 f8 77             	vzeroupper
 1508f5e:	e8 dd b5 25 ff       	call   764540 <mmap@plt>
 1508f63:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 1508f67:	0f 84 74 01 00 00    	je     15090e1 <run_backend_benchmark+0x7971>
 1508f6d:	4c 8d b8 ff ff 20 00 	lea    0x20ffff(%rax),%r15
 1508f74:	ba 0f 00 00 00       	mov    $0xf,%edx
 1508f79:	48 89 c7             	mov    %rax,%rdi
 1508f7c:	49 81 e7 00 00 e0 ff 	and    $0xffffffffffe00000,%r15
 1508f83:	4d 89 fc             	mov    %r15,%r12
 1508f86:	49 29 c4             	sub    %rax,%r12
 1508f89:	4c 89 e6             	mov    %r12,%rsi
 1508f8c:	49 8d 9c 24 00 00 ff ff 	lea    -0x10000(%r12),%rbx
 1508f94:	e8 57 b5 25 ff       	call   7644f0 <madvise@plt>
 1508f99:	4c 89 f6             	mov    %r14,%rsi
 1508f9c:	4c 29 e6             	sub    %r12,%rsi
 1508f9f:	ba 0e 00 00 00       	mov    $0xe,%edx
 1508fa4:	4c 89 ff             	mov    %r15,%rdi
 1508fa7:	e8 44 b5 25 ff       	call   7644f0 <madvise@plt>
 1508fac:	4c 89 fe             	mov    %r15,%rsi
 1508faf:	48 81 c6 00 00 ff ff 	add    $0xffffffffffff0000,%rsi
 1508fb6:	49 8d 86 00 00 e0 ff 	lea    -0x200000(%r14),%rax
 1508fbd:	e9 25 01 00 00       	jmp    15090e7 <run_backend_benchmark+0x7977>
 1508fc2:	41 83 f9 20          	cmp    $0x20,%r9d
 1508fc6:	73 0a                	jae    1508fd2 <run_backend_benchmark+0x7862>
 1508fc8:	31 c0                	xor    %eax,%eax
 1508fca:	45 31 e4             	xor    %r12d,%r12d
 1508fcd:	e9 a4 00 00 00       	jmp    1509076 <run_backend_benchmark+0x7906>
 1508fd2:	44 89 d8             	mov    %r11d,%eax
 1508fd5:	83 e0 e0             	and    $0xffffffe0,%eax
 1508fd8:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1508fdc:	31 c9                	xor    %ecx,%ecx
 1508fde:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1508fe2:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1508fe6:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 1508fea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1508ff0:	62 d2 7d 48 35 6c 88 01 	vpmovzxdq 0x20(%r8,%rcx,4),%zmm5
 1508ff8:	62 d2 7d 48 35 24 88 	vpmovzxdq (%r8,%rcx,4),%zmm4
 1508fff:	62 d2 7d 48 35 74 88 02 	vpmovzxdq 0x40(%r8,%rcx,4),%zmm6
 1509007:	62 f1 f5 48 d4 cd    	vpaddq %zmm5,%zmm1,%zmm1
 150900d:	62 d2 7d 48 35 6c 88 03 	vpmovzxdq 0x60(%r8,%rcx,4),%zmm5
 1509015:	62 f1 fd 48 d4 c4    	vpaddq %zmm4,%zmm0,%zmm0
 150901b:	62 f1 ed 48 d4 d6    	vpaddq %zmm6,%zmm2,%zmm2
 1509021:	48 83 c1 20          	add    $0x20,%rcx
 1509025:	62 f1 e5 48 d4 dd    	vpaddq %zmm5,%zmm3,%zmm3
 150902b:	48 39 c8             	cmp    %rcx,%rax
 150902e:	75 c0                	jne    1508ff0 <run_backend_benchmark+0x7880>
 1509030:	62 f1 f5 48 d4 c0    	vpaddq %zmm0,%zmm1,%zmm0
 1509036:	62 f1 ed 48 d4 c0    	vpaddq %zmm0,%zmm2,%zmm0
 150903c:	62 f1 e5 48 d4 c0    	vpaddq %zmm0,%zmm3,%zmm0
 1509042:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 1509049:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 150904f:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 1509055:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 1509059:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 150905e:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 1509062:	c4 c1 f9 7e c4       	vmovq  %xmm0,%r12
 1509067:	44 39 d8             	cmp    %r11d,%eax
 150906a:	0f 84 c2 00 00 00    	je     1509132 <run_backend_benchmark+0x79c2>
 1509070:	41 f6 c3 18          	test   $0x18,%r11b
 1509074:	74 5a                	je     15090d0 <run_backend_benchmark+0x7960>
 1509076:	48 89 c1             	mov    %rax,%rcx
 1509079:	44 89 d8             	mov    %r11d,%eax
 150907c:	83 e0 f8             	and    $0xfffffff8,%eax
 150907f:	c4 c1 f9 6e c4       	vmovq  %r12,%xmm0
 1509084:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1509090:	62 d2 7d 48 35 0c 88 	vpmovzxdq (%r8,%rcx,4),%zmm1
 1509097:	48 83 c1 08          	add    $0x8,%rcx
 150909b:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 15090a1:	48 39 c8             	cmp    %rcx,%rax
 15090a4:	75 ea                	jne    1509090 <run_backend_benchmark+0x7920>
 15090a6:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 15090ad:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 15090b3:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 15090b9:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 15090bd:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 15090c2:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 15090c6:	c4 c1 f9 7e c4       	vmovq  %xmm0,%r12
 15090cb:	44 39 d8             	cmp    %r11d,%eax
 15090ce:	74 62                	je     1509132 <run_backend_benchmark+0x79c2>
 15090d0:	41 8b 0c 80          	mov    (%r8,%rax,4),%ecx
 15090d4:	48 ff c0             	inc    %rax
 15090d7:	49 01 cc             	add    %rcx,%r12
 15090da:	49 39 c3             	cmp    %rax,%r11
 15090dd:	75 f1                	jne    15090d0 <run_backend_benchmark+0x7960>
 15090df:	eb 51                	jmp    1509132 <run_backend_benchmark+0x79c2>
 15090e1:	31 f6                	xor    %esi,%esi
 15090e3:	31 c0                	xor    %eax,%eax
 15090e5:	31 db                	xor    %ebx,%ebx
 15090e7:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 15090ec:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 15090f1:	4c 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%r9
 15090f9:	64 48 89 34 25 10 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff10
 1509102:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 150910f:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 1509118:	31 d2                	xor    %edx,%edx
 150911a:	64 48 89 1c 25 28 ff ff ff 	mov    %rbx,%fs:0xffffffffffffff28
 1509123:	45 89 cb             	mov    %r9d,%r11d
 1509126:	45 85 c9             	test   %r9d,%r9d
 1509129:	0f 85 f6 fd ff ff    	jne    1508f25 <run_backend_benchmark+0x77b5>
 150912f:	45 31 e4             	xor    %r12d,%r12d
 1509132:	48 8d 4c 32 3f       	lea    0x3f(%rdx,%rsi,1),%rcx
 1509137:	48 8d 04 32          	lea    (%rdx,%rsi,1),%rax
 150913b:	48 89 94 24 50 01 00 00 	mov    %rdx,0x150(%rsp)
 1509143:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 1509147:	48 39 c1             	cmp    %rax,%rcx
 150914a:	0f 83 9c 09 00 00    	jae    1509aec <run_backend_benchmark+0x837c>
 1509150:	48 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%rdx
 1509158:	48 8d 8c 24 80 0e 00 00 	lea    0xe80(%rsp),%rcx
 1509160:	45 85 c9             	test   %r9d,%r9d
 1509163:	0f 84 9c 00 00 00    	je     1509205 <run_backend_benchmark+0x7a95>
 1509169:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 150916e:	45 31 f6             	xor    %r14d,%r14d
 1509171:	45 31 ff             	xor    %r15d,%r15d
 1509174:	4c 89 9c 24 d0 00 00 00 	mov    %r11,0xd0(%rsp)
 150917c:	4c 89 ac 24 c0 00 00 00 	mov    %r13,0xc0(%rsp)
 1509184:	48 8d 58 08          	lea    0x8(%rax),%rbx
 1509188:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1509190:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 1509195:	47 8b 24 b0          	mov    (%r8,%r14,4),%r12d
 1509199:	45 31 c0             	xor    %r8d,%r8d
 150919c:	42 80 3c 32 00       	cmpb   $0x0,(%rdx,%r14,1)
 15091a1:	4b 8d 74 bd 00       	lea    0x0(%r13,%r15,4),%rsi
 15091a6:	49 89 cd             	mov    %rcx,%r13
 15091a9:	48 89 cf             	mov    %rcx,%rdi
 15091ac:	46 8b 0c b0          	mov    (%rax,%r14,4),%r9d
 15091b0:	4b 8d 04 fa          	lea    (%r10,%r15,8),%rax
 15091b4:	41 0f 95 c0          	setne  %r8b
 15091b8:	44 89 e2             	mov    %r12d,%edx
 15091bb:	44 89 e1             	mov    %r12d,%ecx
 15091be:	48 89 04 24          	mov    %rax,(%rsp)
 15091c2:	c5 f8 77             	vzeroupper
 15091c5:	e8 96 bb 02 00       	call   1534d60 <abi_assign_call>
 15091ca:	4c 89 e9             	mov    %r13,%rcx
 15091cd:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
 15091d1:	48 89 13             	mov    %rdx,(%rbx)
 15091d4:	4c 8b 9c 24 d0 00 00 00 	mov    0xd0(%rsp),%r11
 15091dc:	4c 8b ac 24 c0 00 00 00 	mov    0xc0(%rsp),%r13
 15091e4:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 15091e9:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 15091ee:	48 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%rdx
 15091f6:	4d 01 e7             	add    %r12,%r15
 15091f9:	49 ff c6             	inc    %r14
 15091fc:	48 83 c3 10          	add    $0x10,%rbx
 1509200:	4d 39 f3             	cmp    %r14,%r11
 1509203:	75 8b                	jne    1509190 <run_backend_benchmark+0x7a20>
 1509205:	48 8b 8c 24 50 01 00 00 	mov    0x150(%rsp),%rcx
 150920d:	64 48 3b 0c 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rcx
 1509216:	0f 87 fd 26 00 00    	ja     150b919 <run_backend_benchmark+0xa1a9>
 150921c:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 1509224:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 150922d:	8b 8c 24 58 01 00 00 	mov    0x158(%rsp),%ecx
 1509234:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 1509239:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 150923e:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 1509246:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 150924a:	48 89 d0             	mov    %rdx,%rax
 150924d:	48 c1 e0 04          	shl    $0x4,%rax
 1509251:	49 8d 0c ca          	lea    (%r10,%rcx,8),%rcx
 1509255:	4c 01 c0             	add    %r8,%rax
 1509258:	49 89 8b 28 3a 00 00 	mov    %rcx,0x3a28(%r11)
 150925f:	49 89 83 38 3a 00 00 	mov    %rax,0x3a38(%r11)
 1509266:	85 d2                	test   %edx,%edx
 1509268:	0f 84 3c 0a 00 00    	je     1509caa <run_backend_benchmark+0x853a>
 150926e:	4c 8d a7 70 03 00 00 	lea    0x370(%rdi),%r12
 1509275:	45 31 c9             	xor    %r9d,%r9d
 1509278:	45 31 ed             	xor    %r13d,%r13d
 150927b:	c7 44 24 60 00 00 00 00 	movl   $0x0,0x60(%rsp)
 1509283:	4c 89 a4 24 c0 00 00 00 	mov    %r12,0xc0(%rsp)
 150928b:	e9 e1 00 00 00       	jmp    1509371 <run_backend_benchmark+0x7c01>
 1509290:	89 93 b0 00 00 00    	mov    %edx,0xb0(%rbx)
 1509296:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 150929e:	48 8b 12             	mov    (%rdx),%rdx
 15092a1:	48 89 93 a0 00 00 00 	mov    %rdx,0xa0(%rbx)
 15092a8:	41 8b 56 14          	mov    0x14(%r14),%edx
 15092ac:	48 c1 e2 02          	shl    $0x2,%rdx
 15092b0:	48 03 57 70          	add    0x70(%rdi),%rdx
 15092b4:	41 29 cd             	sub    %ecx,%r13d
 15092b7:	48 89 93 a8 00 00 00 	mov    %rdx,0xa8(%rbx)
 15092be:	49 ff c1             	inc    %r9
 15092c1:	41 01 c5             	add    %eax,%r13d
 15092c4:	41 8b 46 14          	mov    0x14(%r14),%eax
 15092c8:	48 c1 e0 02          	shl    $0x2,%rax
 15092cc:	49 03 83 08 3a 00 00 	add    0x3a08(%r11),%rax
 15092d3:	48 89 43 48          	mov    %rax,0x48(%rbx)
 15092d7:	41 8b 46 14          	mov    0x14(%r14),%eax
 15092db:	48 c1 e0 02          	shl    $0x2,%rax
 15092df:	48 03 47 58          	add    0x58(%rdi),%rax
 15092e3:	48 89 43 50          	mov    %rax,0x50(%rbx)
 15092e7:	41 8b 46 14          	mov    0x14(%r14),%eax
 15092eb:	48 c1 e0 02          	shl    $0x2,%rax
 15092ef:	48 03 47 60          	add    0x60(%rdi),%rax
 15092f3:	48 89 43 58          	mov    %rax,0x58(%rbx)
 15092f7:	41 8b 46 14          	mov    0x14(%r14),%eax
 15092fb:	49 03 83 40 3a 00 00 	add    0x3a40(%r11),%rax
 1509302:	48 89 43 60          	mov    %rax,0x60(%rbx)
 1509306:	41 8b 46 14          	mov    0x14(%r14),%eax
 150930a:	48 c1 e0 04          	shl    $0x4,%rax
 150930e:	49 03 83 38 3a 00 00 	add    0x3a38(%r11),%rax
 1509315:	48 89 43 68          	mov    %rax,0x68(%rbx)
 1509319:	49 8b 83 28 3a 00 00 	mov    0x3a28(%r11),%rax
 1509320:	48 89 43 70          	mov    %rax,0x70(%rbx)
 1509324:	48 8b 87 80 00 00 00 	mov    0x80(%rdi),%rax
 150932b:	48 89 43 78          	mov    %rax,0x78(%rbx)
 150932f:	41 8b 46 18          	mov    0x18(%r14),%eax
 1509333:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
 1509339:	8b 87 90 00 00 00    	mov    0x90(%rdi),%eax
 150933f:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
 1509345:	49 8b 83 10 3a 00 00 	mov    0x3a10(%r11),%rax
 150934c:	48 89 83 b8 00 00 00 	mov    %rax,0xb8(%rbx)
 1509353:	41 8b 83 18 3a 00 00 	mov    0x3a18(%r11),%eax
 150935a:	89 83 c0 00 00 00    	mov    %eax,0xc0(%rbx)
 1509360:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 1509368:	49 39 c1             	cmp    %rax,%r9
 150936b:	0f 84 e0 03 00 00    	je     1509751 <run_backend_benchmark+0x7fe1>
 1509371:	49 69 c9 e8 00 00 00 	imul   $0xe8,%r9,%rcx
 1509378:	4b 8d 04 89          	lea    (%r9,%r9,4),%rax
 150937c:	4d 8d 34 c4          	lea    (%r12,%rax,8),%r14
 1509380:	62 d1 fe 48 7f a4 0b a8 00 00 00 	vmovdqu64 %zmm4,0xa8(%r11,%rcx,1)
 150938b:	62 d1 fe 48 7f 64 0b 02 	vmovdqu64 %zmm4,0x80(%r11,%rcx,1)
 1509393:	62 d1 fe 48 7f 64 0b 01 	vmovdqu64 %zmm4,0x40(%r11,%rcx,1)
 150939b:	62 d1 fe 48 7f 24 0b 	vmovdqu64 %zmm4,(%r11,%rcx,1)
 15093a2:	49 8d 1c 0b          	lea    (%r11,%rcx,1),%rbx
 15093a6:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 15093aa:	48 03 17             	add    (%rdi),%rdx
 15093ad:	49 89 14 0b          	mov    %rdx,(%r11,%rcx,1)
 15093b1:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 15093b5:	48 03 57 08          	add    0x8(%rdi),%rdx
 15093b9:	49 89 54 0b 08       	mov    %rdx,0x8(%r11,%rcx,1)
 15093be:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 15093c2:	48 c1 e2 03          	shl    $0x3,%rdx
 15093c6:	48 03 57 10          	add    0x10(%rdi),%rdx
 15093ca:	49 89 54 0b 10       	mov    %rdx,0x10(%r11,%rcx,1)
 15093cf:	41 8b 54 c4 04       	mov    0x4(%r12,%rax,8),%edx
 15093d4:	41 89 54 0b 18       	mov    %edx,0x18(%r11,%rcx,1)
 15093d9:	41 8b 54 c4 08       	mov    0x8(%r12,%rax,8),%edx
 15093de:	48 03 57 20          	add    0x20(%rdi),%rdx
 15093e2:	49 89 54 0b 20       	mov    %rdx,0x20(%r11,%rcx,1)
 15093e7:	41 8b 54 c4 08       	mov    0x8(%r12,%rax,8),%edx
 15093ec:	48 03 57 28          	add    0x28(%rdi),%rdx
 15093f0:	49 89 54 0b 28       	mov    %rdx,0x28(%r11,%rcx,1)
 15093f5:	41 8b 4c c4 0c       	mov    0xc(%r12,%rax,8),%ecx
 15093fa:	48 85 c9             	test   %rcx,%rcx
 15093fd:	0f 84 0d 01 00 00    	je     1509510 <run_backend_benchmark+0x7da0>
 1509403:	48 8b 47 30          	mov    0x30(%rdi),%rax
 1509407:	48 85 c0             	test   %rax,%rax
 150940a:	0f 84 00 01 00 00    	je     1509510 <run_backend_benchmark+0x7da0>
 1509410:	41 8b 56 08          	mov    0x8(%r14),%edx
 1509414:	83 f9 08             	cmp    $0x8,%ecx
 1509417:	72 1d                	jb     1509436 <run_backend_benchmark+0x7cc6>
 1509419:	48 8d 71 ff          	lea    -0x1(%rcx),%rsi
 150941d:	89 d7                	mov    %edx,%edi
 150941f:	01 f7                	add    %esi,%edi
 1509421:	40 0f 92 c7          	setb   %dil
 1509425:	48 c1 ee 20          	shr    $0x20,%rsi
 1509429:	40 0f 95 c6          	setne  %sil
 150942d:	40 08 fe             	or     %dil,%sil
 1509430:	0f 84 2b 02 00 00    	je     1509661 <run_backend_benchmark+0x7ef1>
 1509436:	4d 89 cf             	mov    %r9,%r15
 1509439:	31 f6                	xor    %esi,%esi
 150943b:	31 ff                	xor    %edi,%edi
 150943d:	49 89 c9             	mov    %rcx,%r9
 1509440:	49 83 e1 07          	and    $0x7,%r9
 1509444:	49 89 f0             	mov    %rsi,%r8
 1509447:	74 1f                	je     1509468 <run_backend_benchmark+0x7cf8>
 1509449:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1509450:	46 8d 14 02          	lea    (%rdx,%r8,1),%r10d
 1509454:	42 83 3c 90 00       	cmpl   $0x0,(%rax,%r10,4)
 1509459:	41 0f 95 c2          	setne  %r10b
 150945d:	49 ff c0             	inc    %r8
 1509460:	44 08 d7             	or     %r10b,%dil
 1509463:	49 ff c9             	dec    %r9
 1509466:	75 e8                	jne    1509450 <run_backend_benchmark+0x7ce0>
 1509468:	48 29 ce             	sub    %rcx,%rsi
 150946b:	48 83 fe f8          	cmp    $0xfffffffffffffff8,%rsi
 150946f:	77 65                	ja     15094d6 <run_backend_benchmark+0x7d66>
 1509471:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1509480:	42 8d 74 02 01       	lea    0x1(%rdx,%r8,1),%esi
 1509485:	46 8d 0c 02          	lea    (%rdx,%r8,1),%r9d
 1509489:	46 8d 54 02 03       	lea    0x3(%rdx,%r8,1),%r10d
 150948e:	8b 34 b0             	mov    (%rax,%rsi,4),%esi
 1509491:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 1509495:	46 8d 4c 02 02       	lea    0x2(%rdx,%r8,1),%r9d
 150949a:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 150949e:	46 8d 4c 02 04       	lea    0x4(%rdx,%r8,1),%r9d
 15094a3:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 15094a7:	46 8d 54 02 05       	lea    0x5(%rdx,%r8,1),%r10d
 15094ac:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 15094b0:	46 8d 4c 02 06       	lea    0x6(%rdx,%r8,1),%r9d
 15094b5:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 15094b9:	46 8d 54 02 07       	lea    0x7(%rdx,%r8,1),%r10d
 15094be:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 15094c2:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 15094c6:	40 0f 95 c6          	setne  %sil
 15094ca:	49 83 c0 08          	add    $0x8,%r8
 15094ce:	40 08 f7             	or     %sil,%dil
 15094d1:	4c 39 c1             	cmp    %r8,%rcx
 15094d4:	75 aa                	jne    1509480 <run_backend_benchmark+0x7d10>
 15094d6:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 15094db:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 15094e0:	4d 89 f9             	mov    %r15,%r9
 15094e3:	40 f6 c7 01          	test   $0x1,%dil
 15094e7:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 15094ef:	74 1f                	je     1509510 <run_backend_benchmark+0x7da0>
 15094f1:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 15094f5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
 15094fc:	41 8b 46 08          	mov    0x8(%r14),%eax
 1509500:	48 03 47 38          	add    0x38(%rdi),%rax
 1509504:	eb 17                	jmp    150951d <run_backend_benchmark+0x7dad>
 1509506:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 1509510:	31 c0                	xor    %eax,%eax
 1509512:	48 c7 83 88 00 00 00 00 00 00 00 	movq   $0x0,0x88(%rbx)
 150951d:	48 89 83 90 00 00 00 	mov    %rax,0x90(%rbx)
 1509524:	4d 89 cf             	mov    %r9,%r15
 1509527:	49 c1 e7 04          	shl    $0x4,%r15
 150952b:	41 8b 46 0c          	mov    0xc(%r14),%eax
 150952f:	89 43 30             	mov    %eax,0x30(%rbx)
 1509532:	41 8b 46 10          	mov    0x10(%r14),%eax
 1509536:	89 43 34             	mov    %eax,0x34(%rbx)
 1509539:	44 89 e8             	mov    %r13d,%eax
 150953c:	49 8d 34 c2          	lea    (%r10,%rax,8),%rsi
 1509540:	48 89 73 38          	mov    %rsi,0x38(%rbx)
 1509544:	4b 8b 44 38 08       	mov    0x8(%r8,%r15,1),%rax
 1509549:	48 89 43 40          	mov    %rax,0x40(%rbx)
 150954d:	41 80 7e 1e 00       	cmpb   $0x0,0x1e(%r14)
 1509552:	0f 84 d8 00 00 00    	je     1509630 <run_backend_benchmark+0x7ec0>
 1509558:	44 89 6c 24 30       	mov    %r13d,0x30(%rsp)
 150955d:	44 8b 6c 24 60       	mov    0x60(%rsp),%r13d
 1509562:	49 8b 83 50 3a 00 00 	mov    0x3a50(%r11),%rax
 1509569:	4d 89 cc             	mov    %r9,%r12
 150956c:	44 89 e9             	mov    %r13d,%ecx
 150956f:	48 8d 14 c8          	lea    (%rax,%rcx,8),%rdx
 1509573:	48 8d 7c c8 08       	lea    0x8(%rax,%rcx,8),%rdi
 1509578:	48 89 94 24 a0 00 00 00 	mov    %rdx,0xa0(%rsp)
 1509580:	48 ba 00 00 00 00 07 ff 01 00 	movabs $0x1ff0700000000,%rdx
 150958a:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
 150958e:	41 8b 56 10          	mov    0x10(%r14),%edx
 1509592:	ff ca                	dec    %edx
 1509594:	48 c1 e2 03          	shl    $0x3,%rdx
 1509598:	c5 f8 77             	vzeroupper
 150959b:	e8 b0 ae 25 ff       	call   764450 <memcpy@plt>
 15095a0:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 15095a8:	4d 89 e1             	mov    %r12,%r9
 15095ab:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 15095b0:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 15095b5:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 15095bd:	4c 8b a4 24 c0 00 00 00 	mov    0xc0(%rsp),%r12
 15095c5:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 15095ca:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 15095ce:	48 89 43 38          	mov    %rax,0x38(%rbx)
 15095d2:	41 8b 46 10          	mov    0x10(%r14),%eax
 15095d6:	41 0f b6 4e 1e       	movzbl 0x1e(%r14),%ecx
 15095db:	41 01 c5             	add    %eax,%r13d
 15095de:	44 89 6c 24 60       	mov    %r13d,0x60(%rsp)
 15095e3:	44 8b 6c 24 30       	mov    0x30(%rsp),%r13d
 15095e8:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 15095ee:	74 4e                	je     150963e <run_backend_benchmark+0x7ece>
 15095f0:	41 0f b6 76 1d       	movzbl 0x1d(%r14),%esi
 15095f5:	31 d2                	xor    %edx,%edx
 15095f7:	48 81 fe ff 00 00 00 	cmp    $0xff,%rsi
 15095fe:	0f 84 8c fc ff ff    	je     1509290 <run_backend_benchmark+0x7b20>
 1509604:	4d 01 c7             	add    %r8,%r15
 1509607:	41 80 7f 08 01       	cmpb   $0x1,0x8(%r15)
 150960c:	0f 85 7e fc ff ff    	jne    1509290 <run_backend_benchmark+0x7b20>
 1509612:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
 1509617:	48 6b d6 74          	imul   $0x74,%rsi,%rdx
 150961b:	41 8b 54 17 5c       	mov    0x5c(%r15,%rdx,1),%edx
 1509620:	e9 6b fc ff ff       	jmp    1509290 <run_backend_benchmark+0x7b20>
 1509625:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1509630:	41 8b 46 10          	mov    0x10(%r14),%eax
 1509634:	31 c9                	xor    %ecx,%ecx
 1509636:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 150963c:	75 b2                	jne    15095f0 <run_backend_benchmark+0x7e80>
 150963e:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 1509646:	c7 83 b0 00 00 00 00 00 00 00 	movl   $0x0,0xb0(%rbx)
 1509650:	48 8b 12             	mov    (%rdx),%rdx
 1509653:	48 89 93 a0 00 00 00 	mov    %rdx,0xa0(%rbx)
 150965a:	31 d2                	xor    %edx,%edx
 150965c:	e9 53 fc ff ff       	jmp    15092b4 <run_backend_benchmark+0x7b44>
 1509661:	4d 89 cf             	mov    %r9,%r15
 1509664:	83 f9 40             	cmp    $0x40,%ecx
 1509667:	73 09                	jae    1509672 <run_backend_benchmark+0x7f02>
 1509669:	31 f6                	xor    %esi,%esi
 150966b:	31 ff                	xor    %edi,%edi
 150966d:	e9 92 00 00 00       	jmp    1509704 <run_backend_benchmark+0x7f94>
 1509672:	c5 fc 47 c0          	kxorw  %k0,%k0,%k0
 1509676:	89 ce                	mov    %ecx,%esi
 1509678:	83 e6 c0             	and    $0xffffffc0,%esi
 150967b:	89 d7                	mov    %edx,%edi
 150967d:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
 1509681:	c5 fc 47 d0          	kxorw  %k0,%k0,%k2
 1509685:	c5 fc 47 d8          	kxorw  %k0,%k0,%k3
 1509689:	49 89 f0             	mov    %rsi,%r8
 150968c:	0f 1f 40 00          	nopl   0x0(%rax)
 1509690:	41 89 f9             	mov    %edi,%r9d
 1509693:	62 b1 fe 48 6f 04 88 	vmovdqu64 (%rax,%r9,4),%zmm0
 150969a:	62 b1 fe 48 6f 4c 88 01 	vmovdqu64 0x40(%rax,%r9,4),%zmm1
 15096a2:	62 b1 fe 48 6f 5c 88 03 	vmovdqu64 0xc0(%rax,%r9,4),%zmm3
 15096aa:	62 b1 fe 48 6f 54 88 02 	vmovdqu64 0x80(%rax,%r9,4),%zmm2
 15096b2:	83 c7 40             	add    $0x40,%edi
 15096b5:	49 83 c0 c0          	add    $0xffffffffffffffc0,%r8
 15096b9:	62 f2 7d 48 27 e0    	vptestmd %zmm0,%zmm0,%k4
 15096bf:	62 f2 65 48 27 eb    	vptestmd %zmm3,%zmm3,%k5
 15096c5:	c5 fc 45 c4          	korw   %k4,%k0,%k0
 15096c9:	62 f2 75 48 27 e1    	vptestmd %zmm1,%zmm1,%k4
 15096cf:	c5 e4 45 dd          	korw   %k5,%k3,%k3
 15096d3:	c5 f4 45 cc          	korw   %k4,%k1,%k1
 15096d7:	62 f2 6d 48 27 e2    	vptestmd %zmm2,%zmm2,%k4
 15096dd:	c5 ec 45 d4          	korw   %k4,%k2,%k2
 15096e1:	75 ad                	jne    1509690 <run_backend_benchmark+0x7f20>
 15096e3:	c5 f4 45 c0          	korw   %k0,%k1,%k0
 15096e7:	c5 ec 45 c0          	korw   %k0,%k2,%k0
 15096eb:	c5 f8 98 d8          	kortestw %k0,%k3
 15096ef:	40 0f 95 c7          	setne  %dil
 15096f3:	39 ce                	cmp    %ecx,%esi
 15096f5:	0f 84 db fd ff ff    	je     15094d6 <run_backend_benchmark+0x7d66>
 15096fb:	f6 c1 38             	test   $0x38,%cl
 15096fe:	0f 84 39 fd ff ff    	je     150943d <run_backend_benchmark+0x7ccd>
 1509704:	49 89 f0             	mov    %rsi,%r8
 1509707:	89 ce                	mov    %ecx,%esi
 1509709:	83 e6 f8             	and    $0xfffffff8,%esi
 150970c:	40 84 ff             	test   %dil,%dil
 150970f:	40 0f 95 c7          	setne  %dil
 1509713:	c5 fb 92 c7          	kmovd  %edi,%k0
 1509717:	89 d7                	mov    %edx,%edi
 1509719:	44 01 c7             	add    %r8d,%edi
 150971c:	49 29 f0             	sub    %rsi,%r8
 150971f:	90                   	nop
 1509720:	41 89 f9             	mov    %edi,%r9d
 1509723:	c4 a1 7e 6f 04 88    	vmovdqu (%rax,%r9,4),%ymm0
 1509729:	83 c7 08             	add    $0x8,%edi
 150972c:	49 83 c0 08          	add    $0x8,%r8
 1509730:	62 f2 7d 28 27 c8    	vptestmd %ymm0,%ymm0,%k1
 1509736:	c5 fd 45 c1          	korb   %k1,%k0,%k0
 150973a:	75 e4                	jne    1509720 <run_backend_benchmark+0x7fb0>
 150973c:	c5 f9 98 c0          	kortestb %k0,%k0
 1509740:	40 0f 95 c7          	setne  %dil
 1509744:	39 ce                	cmp    %ecx,%esi
 1509746:	0f 85 f1 fc ff ff    	jne    150943d <run_backend_benchmark+0x7ccd>
 150974c:	e9 85 fd ff ff       	jmp    15094d6 <run_backend_benchmark+0x7d66>
 1509751:	41 89 83 00 3a 00 00 	mov    %eax,0x3a00(%r11)
 1509758:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 150975d:	48 8b 9c 24 10 01 00 00 	mov    0x110(%rsp),%rbx
 1509765:	4d 89 df             	mov    %r11,%r15
 1509768:	31 c9                	xor    %ecx,%ecx
 150976a:	48 8b b4 24 a8 01 00 00 	mov    0x1a8(%rsp),%rsi
 1509772:	48 8b 94 24 b0 01 00 00 	mov    0x1b0(%rsp),%rdx
 150977a:	44 8b b4 24 98 01 00 00 	mov    0x198(%rsp),%r14d
 1509782:	48 8b 84 24 a0 01 00 00 	mov    0x1a0(%rsp),%rax
 150978a:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 1509792:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 150979a:	48 8b b4 24 68 01 00 00 	mov    0x168(%rsp),%rsi
 15097a2:	48 8b 94 24 70 01 00 00 	mov    0x170(%rsp),%rdx
 15097aa:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 15097af:	48 89 74 24 78       	mov    %rsi,0x78(%rsp)
 15097b4:	48 89 94 24 90 00 00 00 	mov    %rdx,0x90(%rsp)
 15097bc:	48 8b b4 24 78 01 00 00 	mov    0x178(%rsp),%rsi
 15097c4:	48 8b 94 24 80 01 00 00 	mov    0x180(%rsp),%rdx
 15097cc:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 15097d1:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 15097d9:	48 8b b4 24 88 01 00 00 	mov    0x188(%rsp),%rsi
 15097e1:	48 8b 94 24 90 01 00 00 	mov    0x190(%rsp),%rdx
 15097e9:	48 89 74 24 60       	mov    %rsi,0x60(%rsp)
 15097ee:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
 15097f6:	eb 33                	jmp    150982b <run_backend_benchmark+0x80bb>
 15097f8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1509800:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 1509805:	4c 89 e3             	mov    %r12,%rbx
 1509808:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 150980d:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 1509812:	49 81 c7 e8 00 00 00 	add    $0xe8,%r15
 1509819:	8b 80 00 3a 00 00    	mov    0x3a00(%rax),%eax
 150981f:	48 ff c1             	inc    %rcx
 1509822:	48 39 c1             	cmp    %rax,%rcx
 1509825:	0f 83 c8 04 00 00    	jae    1509cf3 <run_backend_benchmark+0x8583>
 150982b:	41 81 fe 00 00 10 00 	cmp    $0x100000,%r14d
 1509832:	0f 83 bb 04 00 00    	jae    1509cf3 <run_backend_benchmark+0x8583>
 1509838:	49 89 dc             	mov    %rbx,%r12
 150983b:	48 8d 9c 24 e0 01 00 00 	lea    0x1e0(%rsp),%rbx
 1509843:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 150984b:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 1509850:	4c 89 fe             	mov    %r15,%rsi
 1509853:	48 89 da             	mov    %rbx,%rdx
 1509856:	c5 f8 77             	vzeroupper
 1509859:	e8 d2 99 01 00       	call   1523230 <tier0_compile_scalar>
 150985e:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 1509866:	4c 89 fe             	mov    %r15,%rsi
 1509869:	48 89 da             	mov    %rbx,%rdx
 150986c:	e8 df a8 01 00       	call   1524150 <tier0_compile>
 1509871:	8b 9c 24 dc 02 00 00 	mov    0x2dc(%rsp),%ebx
 1509878:	3b 9c 24 74 02 00 00 	cmp    0x274(%rsp),%ebx
 150987f:	0f 85 9d 12 00 00    	jne    150ab22 <run_backend_benchmark+0x93b2>
 1509885:	44 8b ac 24 88 02 00 00 	mov    0x288(%rsp),%r13d
 150988d:	44 3b ac 24 20 02 00 00 	cmp    0x220(%rsp),%r13d
 1509895:	0f 85 87 12 00 00    	jne    150ab22 <run_backend_benchmark+0x93b2>
 150989b:	8b 84 24 a0 02 00 00 	mov    0x2a0(%rsp),%eax
 15098a2:	3b 84 24 38 02 00 00 	cmp    0x238(%rsp),%eax
 15098a9:	0f 85 73 12 00 00    	jne    150ab22 <run_backend_benchmark+0x93b2>
 15098af:	48 8b bc 24 80 02 00 00 	mov    0x280(%rsp),%rdi
 15098b7:	48 8b b4 24 18 02 00 00 	mov    0x218(%rsp),%rsi
 15098bf:	4c 89 ea             	mov    %r13,%rdx
 15098c2:	48 c1 e2 04          	shl    $0x4,%rdx
 15098c6:	e8 f5 a9 25 ff       	call   7642c0 <bcmp@plt>
 15098cb:	85 c0                	test   %eax,%eax
 15098cd:	0f 85 4f 12 00 00    	jne    150ab22 <run_backend_benchmark+0x93b2>
 15098d3:	85 db                	test   %ebx,%ebx
 15098d5:	0f 85 25 ff ff ff    	jne    1509800 <run_backend_benchmark+0x8090>
 15098db:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 15098e0:	44 89 f0             	mov    %r14d,%eax
 15098e3:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 15098eb:	4d 8d 45 01          	lea    0x1(%r13),%r8
 15098ef:	4c 89 e3             	mov    %r12,%rbx
 15098f2:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
 15098f6:	48 6b c8 68          	imul   $0x68,%rax,%rcx
 15098fa:	62 f1 fe 48 6f 84 24 18 02 00 00 	vmovdqu64 0x218(%rsp),%zmm0
 1509905:	62 f1 fe 48 6f 4c 24 09 	vmovdqu64 0x240(%rsp),%zmm1
 150990d:	62 f1 fe 48 7f 8c 0a 28 00 00 00 	vmovdqu64 %zmm1,0x28(%rdx,%rcx,1)
 1509918:	62 f1 fe 48 7f 04 0a 	vmovdqu64 %zmm0,(%rdx,%rcx,1)
 150991f:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
 1509924:	49 8d 74 14 03       	lea    0x3(%r12,%rdx,1),%rsi
 1509929:	49 8d 0c 14          	lea    (%r12,%rdx,1),%rcx
 150992d:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 1509931:	48 89 f7             	mov    %rsi,%rdi
 1509934:	48 29 d7             	sub    %rdx,%rdi
 1509937:	48 39 ce             	cmp    %rcx,%rsi
 150993a:	73 2c                	jae    1509968 <run_backend_benchmark+0x81f8>
 150993c:	4c 8b 4c 24 70       	mov    0x70(%rsp),%r9
 1509941:	49 8d 14 c1          	lea    (%r9,%rax,8),%rdx
 1509945:	49 c7 04 c1 00 00 00 00 	movq   $0x0,(%r9,%rax,8)
 150994d:	48 39 ce             	cmp    %rcx,%rsi
 1509950:	0f 82 99 00 00 00    	jb     15099ef <run_backend_benchmark+0x827f>
 1509956:	4c 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%r9
 150995e:	49 29 f9             	sub    %rdi,%r9
 1509961:	73 4f                	jae    15099b2 <run_backend_benchmark+0x8242>
 1509963:	e9 87 00 00 00       	jmp    15099ef <run_backend_benchmark+0x827f>
 1509968:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 1509970:	48 29 fa             	sub    %rdi,%rdx
 1509973:	72 c7                	jb     150993c <run_backend_benchmark+0x81cc>
 1509975:	4d 89 c1             	mov    %r8,%r9
 1509978:	49 c1 e1 04          	shl    $0x4,%r9
 150997c:	49 39 d1             	cmp    %rdx,%r9
 150997f:	77 bb                	ja     150993c <run_backend_benchmark+0x81cc>
 1509981:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 1509986:	4c 01 cf             	add    %r9,%rdi
 1509989:	49 01 f1             	add    %rsi,%r9
 150998c:	48 89 fb             	mov    %rdi,%rbx
 150998f:	4c 89 cf             	mov    %r9,%rdi
 1509992:	48 2b 7c 24 50       	sub    0x50(%rsp),%rdi
 1509997:	48 8d 14 c1          	lea    (%rcx,%rax,8),%rdx
 150999b:	48 89 34 c1          	mov    %rsi,(%rcx,%rax,8)
 150999f:	4c 89 c9             	mov    %r9,%rcx
 15099a2:	4c 89 ce             	mov    %r9,%rsi
 15099a5:	4c 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%r9
 15099ad:	49 29 f9             	sub    %rdi,%r9
 15099b0:	72 3d                	jb     15099ef <run_backend_benchmark+0x827f>
 15099b2:	49 c1 e0 02          	shl    $0x2,%r8
 15099b6:	4d 39 c8             	cmp    %r9,%r8
 15099b9:	77 34                	ja     15099ef <run_backend_benchmark+0x827f>
 15099bb:	48 89 fb             	mov    %rdi,%rbx
 15099be:	4c 01 c3             	add    %r8,%rbx
 15099c1:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
 15099c6:	49 89 f1             	mov    %rsi,%r9
 15099c9:	49 8d 74 18 03       	lea    0x3(%r8,%rbx,1),%rsi
 15099ce:	4a 8d 0c 03          	lea    (%rbx,%r8,1),%rcx
 15099d2:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 15099d6:	48 89 f7             	mov    %rsi,%rdi
 15099d9:	4c 29 c7             	sub    %r8,%rdi
 15099dc:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 15099e4:	4d 89 0c c0          	mov    %r9,(%r8,%rax,8)
 15099e8:	48 39 ce             	cmp    %rcx,%rsi
 15099eb:	72 51                	jb     1509a3e <run_backend_benchmark+0x82ce>
 15099ed:	eb 14                	jmp    1509a03 <run_backend_benchmark+0x8293>
 15099ef:	45 31 c9             	xor    %r9d,%r9d
 15099f2:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 15099fa:	4d 89 0c c0          	mov    %r9,(%r8,%rax,8)
 15099fe:	48 39 ce             	cmp    %rcx,%rsi
 1509a01:	72 3b                	jb     1509a3e <run_backend_benchmark+0x82ce>
 1509a03:	4c 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%r10
 1509a0b:	49 29 fa             	sub    %rdi,%r10
 1509a0e:	72 2e                	jb     1509a3e <run_backend_benchmark+0x82ce>
 1509a10:	44 8b 84 24 48 02 00 00 	mov    0x248(%rsp),%r8d
 1509a18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 1509a1e:	4e 8d 04 85 40 00 00 00 	lea    0x40(,%r8,4),%r8
 1509a26:	4d 39 d0             	cmp    %r10,%r8
 1509a29:	77 16                	ja     1509a41 <run_backend_benchmark+0x82d1>
 1509a2b:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 1509a30:	49 01 f8             	add    %rdi,%r8
 1509a33:	49 89 f1             	mov    %rsi,%r9
 1509a36:	4c 89 c3             	mov    %r8,%rbx
 1509a39:	4c 01 c1             	add    %r8,%rcx
 1509a3c:	eb 03                	jmp    1509a41 <run_backend_benchmark+0x82d1>
 1509a3e:	45 31 c9             	xor    %r9d,%r9d
 1509a41:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 1509a46:	48 8b bc 24 98 00 00 00 	mov    0x98(%rsp),%rdi
 1509a4e:	4c 89 0c c6          	mov    %r9,(%rsi,%rax,8)
 1509a52:	4b 8d 74 ad 00       	lea    0x0(%r13,%r13,4),%rsi
 1509a57:	48 29 df             	sub    %rbx,%rdi
 1509a5a:	41 0f 92 c0          	setb   %r8b
 1509a5e:	48 8d 74 76 40       	lea    0x40(%rsi,%rsi,2),%rsi
 1509a63:	48 39 fe             	cmp    %rdi,%rsi
 1509a66:	40 0f 97 c7          	seta   %dil
 1509a6a:	44 08 c7             	or     %r8b,%dil
 1509a6d:	4c 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%r8
 1509a75:	bf 00 00 00 00       	mov    $0x0,%edi
 1509a7a:	48 0f 45 cf          	cmovne %rdi,%rcx
 1509a7e:	48 0f 45 f7          	cmovne %rdi,%rsi
 1509a82:	49 89 0c c0          	mov    %rcx,(%r8,%rax,8)
 1509a86:	48 83 3a 00          	cmpq   $0x0,(%rdx)
 1509a8a:	0f 84 49 10 00 00    	je     150aad9 <run_backend_benchmark+0x9369>
 1509a90:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 1509a98:	48 83 3c c2 00       	cmpq   $0x0,(%rdx,%rax,8)
 1509a9d:	0f 84 36 10 00 00    	je     150aad9 <run_backend_benchmark+0x9369>
 1509aa3:	41 8b 57 18          	mov    0x18(%r15),%edx
 1509aa7:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
 1509aac:	41 ff c6             	inc    %r14d
 1509aaf:	4c 01 ac 24 a0 00 00 00 	add    %r13,0xa0(%rsp)
 1509ab7:	48 01 54 24 30       	add    %rdx,0x30(%rsp)
 1509abc:	8b 94 24 6c 02 00 00 	mov    0x26c(%rsp),%edx
 1509ac3:	48 01 94 24 80 00 00 00 	add    %rdx,0x80(%rsp)
 1509acb:	48 83 3c c7 00       	cmpq   $0x0,(%rdi,%rax,8)
 1509ad0:	0f 84 ad 10 00 00    	je     150ab83 <run_backend_benchmark+0x9413>
 1509ad6:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 1509adb:	48 85 c9             	test   %rcx,%rcx
 1509ade:	0f 84 a4 10 00 00    	je     150ab88 <run_backend_benchmark+0x9418>
 1509ae4:	48 01 f3             	add    %rsi,%rbx
 1509ae7:	e9 1c fd ff ff       	jmp    1509808 <run_backend_benchmark+0x8098>
 1509aec:	64 48 8b 04 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rax
 1509af5:	49 89 ce             	mov    %rcx,%r14
 1509af8:	48 29 f1             	sub    %rsi,%rcx
 1509afb:	49 89 f7             	mov    %rsi,%r15
 1509afe:	48 89 c6             	mov    %rax,%rsi
 1509b01:	48 29 ce             	sub    %rcx,%rsi
 1509b04:	0f 82 46 f6 ff ff    	jb     1509150 <run_backend_benchmark+0x79e0>
 1509b0a:	49 8d 54 24 11       	lea    0x11(%r12),%rdx
 1509b0f:	48 39 f2             	cmp    %rsi,%rdx
 1509b12:	0f 87 38 f6 ff ff    	ja     1509150 <run_backend_benchmark+0x79e0>
 1509b18:	48 01 d1             	add    %rdx,%rcx
 1509b1b:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 1509b24:	4d 85 f6             	test   %r14,%r14
 1509b27:	0f 84 23 f6 ff ff    	je     1509150 <run_backend_benchmark+0x79e0>
 1509b2d:	49 8d 4c 24 10       	lea    0x10(%r12),%rcx
 1509b32:	48 89 ce             	mov    %rcx,%rsi
 1509b35:	48 c1 ee 3e          	shr    $0x3e,%rsi
 1509b39:	0f 85 11 f6 ff ff    	jne    1509150 <run_backend_benchmark+0x79e0>
 1509b3f:	4a 8d 5c 32 03       	lea    0x3(%rdx,%r14,1),%rbx
 1509b44:	4a 8d 34 32          	lea    (%rdx,%r14,1),%rsi
 1509b48:	48 83 e3 fc          	and    $0xfffffffffffffffc,%rbx
 1509b4c:	48 39 f3             	cmp    %rsi,%rbx
 1509b4f:	0f 82 fb f5 ff ff    	jb     1509150 <run_backend_benchmark+0x79e0>
 1509b55:	48 89 de             	mov    %rbx,%rsi
 1509b58:	4c 29 fe             	sub    %r15,%rsi
 1509b5b:	48 89 c7             	mov    %rax,%rdi
 1509b5e:	48 29 f7             	sub    %rsi,%rdi
 1509b61:	0f 82 e9 f5 ff ff    	jb     1509150 <run_backend_benchmark+0x79e0>
 1509b67:	48 c1 e1 02          	shl    $0x2,%rcx
 1509b6b:	48 39 f9             	cmp    %rdi,%rcx
 1509b6e:	0f 87 dc f5 ff ff    	ja     1509150 <run_backend_benchmark+0x79e0>
 1509b74:	48 01 ce             	add    %rcx,%rsi
 1509b77:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 1509b80:	48 85 db             	test   %rbx,%rbx
 1509b83:	0f 84 c7 f5 ff ff    	je     1509150 <run_backend_benchmark+0x79e0>
 1509b89:	48 8d 34 0b          	lea    (%rbx,%rcx,1),%rsi
 1509b8d:	48 89 c7             	mov    %rax,%rdi
 1509b90:	48 89 b4 24 28 01 00 00 	mov    %rsi,0x128(%rsp)
 1509b98:	4c 29 fe             	sub    %r15,%rsi
 1509b9b:	48 29 f7             	sub    %rsi,%rdi
 1509b9e:	0f 82 ac f5 ff ff    	jb     1509150 <run_backend_benchmark+0x79e0>
 1509ba4:	48 39 f9             	cmp    %rdi,%rcx
 1509ba7:	0f 87 a3 f5 ff ff    	ja     1509150 <run_backend_benchmark+0x79e0>
 1509bad:	48 01 ce             	add    %rcx,%rsi
 1509bb0:	48 8d 3c 0b          	lea    (%rbx,%rcx,1),%rdi
 1509bb4:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 1509bbd:	48 85 ff             	test   %rdi,%rdi
 1509bc0:	0f 84 8a f5 ff ff    	je     1509150 <run_backend_benchmark+0x79e0>
 1509bc6:	48 8d 34 0b          	lea    (%rbx,%rcx,1),%rsi
 1509bca:	48 89 c7             	mov    %rax,%rdi
 1509bcd:	48 01 ce             	add    %rcx,%rsi
 1509bd0:	48 89 b4 24 00 01 00 00 	mov    %rsi,0x100(%rsp)
 1509bd8:	4c 29 fe             	sub    %r15,%rsi
 1509bdb:	48 29 f7             	sub    %rsi,%rdi
 1509bde:	0f 82 6c f5 ff ff    	jb     1509150 <run_backend_benchmark+0x79e0>
 1509be4:	48 39 f9             	cmp    %rdi,%rcx
 1509be7:	0f 87 63 f5 ff ff    	ja     1509150 <run_backend_benchmark+0x79e0>
 1509bed:	48 01 ce             	add    %rcx,%rsi
 1509bf0:	48 83 bc 24 00 01 00 00 00 	cmpq   $0x0,0x100(%rsp)
 1509bf9:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 1509c02:	0f 84 48 f5 ff ff    	je     1509150 <run_backend_benchmark+0x79e0>
 1509c08:	48 8b bc 24 00 01 00 00 	mov    0x100(%rsp),%rdi
 1509c10:	48 8d 34 0f          	lea    (%rdi,%rcx,1),%rsi
 1509c14:	48 8d 7c 0f 04       	lea    0x4(%rdi,%rcx,1),%rdi
 1509c19:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 1509c1d:	48 39 f7             	cmp    %rsi,%rdi
 1509c20:	0f 82 2a f5 ff ff    	jb     1509150 <run_backend_benchmark+0x79e0>
 1509c26:	48 89 f9             	mov    %rdi,%rcx
 1509c29:	4c 29 f9             	sub    %r15,%rcx
 1509c2c:	48 29 c8             	sub    %rcx,%rax
 1509c2f:	0f 82 1b f5 ff ff    	jb     1509150 <run_backend_benchmark+0x79e0>
 1509c35:	4a 8d 34 dd 00 00 00 00 	lea    0x0(,%r11,8),%rsi
 1509c3d:	48 39 c6             	cmp    %rax,%rsi
 1509c40:	0f 87 0a f5 ff ff    	ja     1509150 <run_backend_benchmark+0x79e0>
 1509c46:	48 01 f1             	add    %rsi,%rcx
 1509c49:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 1509c52:	48 85 ff             	test   %rdi,%rdi
 1509c55:	0f 84 f5 f4 ff ff    	je     1509150 <run_backend_benchmark+0x79e0>
 1509c5b:	48 89 bc 24 e0 00 00 00 	mov    %rdi,0xe0(%rsp)
 1509c63:	48 89 9c 24 08 01 00 00 	mov    %rbx,0x108(%rsp)
 1509c6b:	4c 89 ac 24 c0 00 00 00 	mov    %r13,0xc0(%rsp)
 1509c73:	4c 89 9c 24 d0 00 00 00 	mov    %r11,0xd0(%rsp)
 1509c7b:	4c 89 f7             	mov    %r14,%rdi
 1509c7e:	31 f6                	xor    %esi,%esi
 1509c80:	4c 89 cb             	mov    %r9,%rbx
 1509c83:	c5 f8 77             	vzeroupper
 1509c86:	e8 a5 a6 25 ff       	call   764330 <memset@plt>
 1509c8b:	85 db                	test   %ebx,%ebx
 1509c8d:	0f 84 04 04 00 00    	je     150a097 <run_backend_benchmark+0x8927>
 1509c93:	83 bc 24 f0 00 00 00 01 	cmpl   $0x1,0xf0(%rsp)
 1509c9b:	0f 85 ba 00 00 00    	jne    1509d5b <run_backend_benchmark+0x85eb>
 1509ca1:	31 c9                	xor    %ecx,%ecx
 1509ca3:	31 c0                	xor    %eax,%eax
 1509ca5:	e9 f7 02 00 00       	jmp    1509fa1 <run_backend_benchmark+0x8831>
 1509caa:	41 89 93 00 3a 00 00 	mov    %edx,0x3a00(%r11)
 1509cb1:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 1509cb6:	48 8b 9c 24 10 01 00 00 	mov    0x110(%rsp),%rbx
 1509cbe:	48 8b 84 24 a0 01 00 00 	mov    0x1a0(%rsp),%rax
 1509cc6:	48 8b 94 24 a8 01 00 00 	mov    0x1a8(%rsp),%rdx
 1509cce:	48 8b 8c 24 b0 01 00 00 	mov    0x1b0(%rsp),%rcx
 1509cd6:	44 8b b4 24 98 01 00 00 	mov    0x198(%rsp),%r14d
 1509cde:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 1509ce3:	48 89 94 24 a0 00 00 00 	mov    %rdx,0xa0(%rsp)
 1509ceb:	48 89 8c 24 80 00 00 00 	mov    %rcx,0x80(%rsp)
 1509cf3:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 1509cfb:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 1509d00:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 1509d08:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 1509d10:	48 ff 84 24 d8 00 00 00 	incq   0xd8(%rsp)
 1509d18:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 1509d20:	49 bf 00 00 20 00 01 00 00 00 	movabs $0x100200000,%r15
 1509d2a:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 1509d30:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 1509d38:	48 89 8c 24 a8 01 00 00 	mov    %rcx,0x1a8(%rsp)
 1509d40:	48 89 94 24 b0 01 00 00 	mov    %rdx,0x1b0(%rsp)
 1509d48:	48 3b 84 24 20 01 00 00 	cmp    0x120(%rsp),%rax
 1509d50:	0f 82 dd cf ff ff    	jb     1506d33 <run_backend_benchmark+0x55c3>
 1509d56:	e9 3c 10 00 00       	jmp    150ad97 <run_backend_benchmark+0x9627>
 1509d5b:	48 8b 84 24 d0 00 00 00 	mov    0xd0(%rsp),%rax
 1509d63:	83 e0 fe             	and    $0xfffffffe,%eax
 1509d66:	31 c9                	xor    %ecx,%ecx
 1509d68:	4c 89 b4 24 e8 00 00 00 	mov    %r14,0xe8(%rsp)
 1509d70:	48 89 84 24 40 01 00 00 	mov    %rax,0x140(%rsp)
 1509d78:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 1509d7d:	48 8d 70 1a          	lea    0x1a(%rax),%rsi
 1509d81:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 1509d89:	48 ff c0             	inc    %rax
 1509d8c:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 1509d94:	31 c0                	xor    %eax,%eax
 1509d96:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 1509d9b:	4c 8b 6c 24 60       	mov    0x60(%rsp),%r13
 1509da0:	4c 8b 9c 24 b0 0e 00 00 	mov    0xeb0(%rsp),%r11
 1509da8:	44 8b 04 8a          	mov    (%rdx,%rcx,4),%r8d
 1509dac:	41 8b 5c 8d 00       	mov    0x0(%r13,%rcx,4),%ebx
 1509db1:	49 81 f8 00 80 00 00 	cmp    $0x8000,%r8
 1509db8:	41 0f 93 c1          	setae  %r9b
 1509dbc:	83 e3 f8             	and    $0xfffffff8,%ebx
 1509dbf:	45 8b 7c 1b 02       	mov    0x2(%r11,%rbx,1),%r15d
 1509dc4:	41 0f b6 3c 1b       	movzbl (%r11,%rbx,1),%edi
 1509dc9:	45 0f b6 54 1b 01    	movzbl 0x1(%r11,%rbx,1),%r10d
 1509dcf:	44 89 bc 24 80 02 00 00 	mov    %r15d,0x280(%rsp)
 1509dd7:	45 89 d7             	mov    %r10d,%r15d
 1509dda:	45 0f b7 5c 1b 06    	movzwl 0x6(%r11,%rbx,1),%r11d
 1509de0:	66 44 89 9c 24 84 02 00 00 	mov    %r11w,0x284(%rsp)
 1509de9:	45 31 db             	xor    %r11d,%r11d
 1509dec:	40 80 ff 02          	cmp    $0x2,%dil
 1509df0:	c7 46 e6 00 00 00 00 	movl   $0x0,-0x1a(%rsi)
 1509df7:	c6 46 ea 04          	movb   $0x4,-0x16(%rsi)
 1509dfb:	41 0f 94 c3          	sete   %r11b
 1509dff:	41 c0 e1 06          	shl    $0x6,%r9b
 1509e03:	41 80 e2 08          	and    $0x8,%r10b
 1509e07:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 1509e0c:	41 c0 ea 03          	shr    $0x3,%r10b
 1509e10:	c4 e3 79 20 c7 03    	vpinsrb $0x3,%edi,%xmm0,%xmm0
 1509e16:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 1509e1e:	45 20 da             	and    %r11b,%r10b
 1509e21:	c5 f9 7e 46 eb       	vmovd  %xmm0,-0x15(%rsi)
 1509e26:	44 88 7e ef          	mov    %r15b,-0x11(%rsi)
 1509e2a:	41 c0 e2 05          	shl    $0x5,%r10b
 1509e2e:	8b 9c 24 80 02 00 00 	mov    0x280(%rsp),%ebx
 1509e35:	89 5e f0             	mov    %ebx,-0x10(%rsi)
 1509e38:	0f b7 9c 24 84 02 00 00 	movzwl 0x284(%rsp),%ebx
 1509e40:	66 89 5e f4          	mov    %bx,-0xc(%rsi)
 1509e44:	42 8d 1c dd 00 00 00 00 	lea    0x0(,%r11,8),%ebx
 1509e4c:	48 89 04 cf          	mov    %rax,(%rdi,%rcx,8)
 1509e50:	bf 00 00 00 00       	mov    $0x0,%edi
 1509e55:	41 08 d9             	or     %bl,%r9b
 1509e58:	48 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%rbx
 1509e60:	80 7c 0b ff 00       	cmpb   $0x0,-0x1(%rbx,%rcx,1)
 1509e65:	41 0f 95 c3          	setne  %r11b
 1509e69:	45 08 ca             	or     %r9b,%r10b
 1509e6c:	41 c0 e3 04          	shl    $0x4,%r11b
 1509e70:	45 08 da             	or     %r11b,%r10b
 1509e73:	41 fe c2             	inc    %r10b
 1509e76:	4d 85 c0             	test   %r8,%r8
 1509e79:	45 0f b6 ca          	movzbl %r10b,%r9d
 1509e7d:	44 0f 44 cf          	cmove  %edi,%r9d
 1509e81:	48 8b bc 24 e8 00 00 00 	mov    0xe8(%rsp),%rdi
 1509e89:	44 08 0c 07          	or     %r9b,(%rdi,%rax,1)
 1509e8d:	4c 01 c0             	add    %r8,%rax
 1509e90:	44 8b 44 8a 04       	mov    0x4(%rdx,%rcx,4),%r8d
 1509e95:	41 8b 5c 8d 04       	mov    0x4(%r13,%rcx,4),%ebx
 1509e9a:	4c 8b 9c 24 b0 0e 00 00 	mov    0xeb0(%rsp),%r11
 1509ea2:	48 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%rdx
 1509eaa:	49 81 f8 00 80 00 00 	cmp    $0x8000,%r8
 1509eb1:	41 0f 93 c1          	setae  %r9b
 1509eb5:	83 e3 f8             	and    $0xfffffff8,%ebx
 1509eb8:	45 8b 7c 1b 02       	mov    0x2(%r11,%rbx,1),%r15d
 1509ebd:	41 0f b6 3c 1b       	movzbl (%r11,%rbx,1),%edi
 1509ec2:	45 0f b6 54 1b 01    	movzbl 0x1(%r11,%rbx,1),%r10d
 1509ec8:	44 89 bc 24 80 02 00 00 	mov    %r15d,0x280(%rsp)
 1509ed0:	45 0f b7 5c 1b 06    	movzwl 0x6(%r11,%rbx,1),%r11d
 1509ed6:	66 44 89 9c 24 84 02 00 00 	mov    %r11w,0x284(%rsp)
 1509edf:	45 31 db             	xor    %r11d,%r11d
 1509ee2:	40 80 ff 02          	cmp    $0x2,%dil
 1509ee6:	c7 46 f6 00 00 00 00 	movl   $0x0,-0xa(%rsi)
 1509eed:	c6 46 fa 04          	movb   $0x4,-0x6(%rsi)
 1509ef1:	41 0f 94 c3          	sete   %r11b
 1509ef5:	41 c0 e1 06          	shl    $0x6,%r9b
 1509ef9:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 1509efe:	c4 e3 79 20 c7 03    	vpinsrb $0x3,%edi,%xmm0,%xmm0
 1509f04:	48 8b bc 24 e8 00 00 00 	mov    0xe8(%rsp),%rdi
 1509f0c:	c5 f9 7e 46 fb       	vmovd  %xmm0,-0x5(%rsi)
 1509f11:	44 88 56 ff          	mov    %r10b,-0x1(%rsi)
 1509f15:	41 80 e2 08          	and    $0x8,%r10b
 1509f19:	8b 9c 24 80 02 00 00 	mov    0x280(%rsp),%ebx
 1509f20:	41 c0 ea 03          	shr    $0x3,%r10b
 1509f24:	45 20 da             	and    %r11b,%r10b
 1509f27:	41 c0 e2 05          	shl    $0x5,%r10b
 1509f2b:	89 1e                	mov    %ebx,(%rsi)
 1509f2d:	0f b7 9c 24 84 02 00 00 	movzwl 0x284(%rsp),%ebx
 1509f35:	66 89 5e 04          	mov    %bx,0x4(%rsi)
 1509f39:	42 8d 1c dd 00 00 00 00 	lea    0x0(,%r11,8),%ebx
 1509f41:	48 89 44 ca 08       	mov    %rax,0x8(%rdx,%rcx,8)
 1509f46:	ba 00 00 00 00       	mov    $0x0,%edx
 1509f4b:	41 08 d9             	or     %bl,%r9b
 1509f4e:	48 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%rbx
 1509f56:	80 3c 0b 00          	cmpb   $0x0,(%rbx,%rcx,1)
 1509f5a:	41 0f 95 c3          	setne  %r11b
 1509f5e:	45 08 ca             	or     %r9b,%r10b
 1509f61:	41 c0 e3 04          	shl    $0x4,%r11b
 1509f65:	45 08 da             	or     %r11b,%r10b
 1509f68:	41 fe c2             	inc    %r10b
 1509f6b:	4d 85 c0             	test   %r8,%r8
 1509f6e:	45 0f b6 ca          	movzbl %r10b,%r9d
 1509f72:	44 0f 44 ca          	cmove  %edx,%r9d
 1509f76:	48 83 c1 02          	add    $0x2,%rcx
 1509f7a:	48 83 c6 20          	add    $0x20,%rsi
 1509f7e:	44 08 0c 07          	or     %r9b,(%rdi,%rax,1)
 1509f82:	4c 01 c0             	add    %r8,%rax
 1509f85:	48 39 8c 24 40 01 00 00 	cmp    %rcx,0x140(%rsp)
 1509f8d:	0f 85 03 fe ff ff    	jne    1509d96 <run_backend_benchmark+0x8626>
 1509f93:	f6 84 24 d0 00 00 00 01 	testb  $0x1,0xd0(%rsp)
 1509f9b:	0f 84 f6 00 00 00    	je     150a097 <run_backend_benchmark+0x8927>
 1509fa1:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 1509fa6:	48 8b bc 24 b0 0e 00 00 	mov    0xeb0(%rsp),%rdi
 1509fae:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 1509fb3:	44 8b 04 8e          	mov    (%rsi,%rcx,4),%r8d
 1509fb7:	8b 14 8a             	mov    (%rdx,%rcx,4),%edx
 1509fba:	41 83 e0 f8          	and    $0xfffffff8,%r8d
 1509fbe:	46 8b 54 07 02       	mov    0x2(%rdi,%r8,1),%r10d
 1509fc3:	46 0f b6 0c 07       	movzbl (%rdi,%r8,1),%r9d
 1509fc8:	42 0f b6 74 07 01    	movzbl 0x1(%rdi,%r8,1),%esi
 1509fce:	44 89 94 24 80 02 00 00 	mov    %r10d,0x280(%rsp)
 1509fd6:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
 1509fdb:	42 0f b7 7c 07 06    	movzwl 0x6(%rdi,%r8,1),%edi
 1509fe1:	66 89 bc 24 84 02 00 00 	mov    %di,0x284(%rsp)
 1509fe9:	31 ff                	xor    %edi,%edi
 1509feb:	41 80 f9 02          	cmp    $0x2,%r9b
 1509fef:	40 0f 94 c7          	sete   %dil
 1509ff3:	c5 f9 6e c7          	vmovd  %edi,%xmm0
 1509ff7:	c4 c3 79 20 c1 03    	vpinsrb $0x3,%r9d,%xmm0,%xmm0
 1509ffd:	49 89 c9             	mov    %rcx,%r9
 150a000:	49 c1 e1 04          	shl    $0x4,%r9
 150a004:	43 c7 04 0a 00 00 00 00 	movl   $0x0,(%r10,%r9,1)
 150a00c:	43 c6 44 0a 04 04    	movb   $0x4,0x4(%r10,%r9,1)
 150a012:	c4 81 79 7e 44 0a 05 	vmovd  %xmm0,0x5(%r10,%r9,1)
 150a019:	43 88 74 0a 09       	mov    %sil,0x9(%r10,%r9,1)
 150a01e:	40 80 e6 08          	and    $0x8,%sil
 150a022:	44 8b 84 24 80 02 00 00 	mov    0x280(%rsp),%r8d
 150a02a:	40 c0 ee 03          	shr    $0x3,%sil
 150a02e:	81 fa 00 80 00 00    	cmp    $0x8000,%edx
 150a034:	47 89 44 0a 0a       	mov    %r8d,0xa(%r10,%r9,1)
 150a039:	44 0f b7 84 24 84 02 00 00 	movzwl 0x284(%rsp),%r8d
 150a042:	66 47 89 44 0a 0e    	mov    %r8w,0xe(%r10,%r9,1)
 150a048:	41 0f 93 c1          	setae  %r9b
 150a04c:	44 8d 04 fd 00 00 00 00 	lea    0x0(,%rdi,8),%r8d
 150a054:	4c 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%r10
 150a05c:	40 20 fe             	and    %dil,%sil
 150a05f:	41 c0 e1 06          	shl    $0x6,%r9b
 150a063:	40 c0 e6 05          	shl    $0x5,%sil
 150a067:	45 08 c1             	or     %r8b,%r9b
 150a06a:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 150a072:	49 89 04 ca          	mov    %rax,(%r10,%rcx,8)
 150a076:	41 80 3c 08 00       	cmpb   $0x0,(%r8,%rcx,1)
 150a07b:	0f 95 c1             	setne  %cl
 150a07e:	44 08 ce             	or     %r9b,%sil
 150a081:	c0 e1 04             	shl    $0x4,%cl
 150a084:	40 08 ce             	or     %cl,%sil
 150a087:	40 fe c6             	inc    %sil
 150a08a:	85 d2                	test   %edx,%edx
 150a08c:	40 0f b6 ce          	movzbl %sil,%ecx
 150a090:	0f 44 ca             	cmove  %edx,%ecx
 150a093:	41 08 0c 06          	or     %cl,(%r14,%rax,1)
 150a097:	62 62 7d 48 58 05 c3 63 07 ff 	vpbroadcastd -0xf89c3d(%rip),%zmm24        # 580464 <tier0_emit_x87.operations+0x1c>
 150a0a1:	62 62 7d 48 58 0d bd 63 07 ff 	vpbroadcastd -0xf89c43(%rip),%zmm25        # 580468 <tier0_emit_x87.operations+0x20>
 150a0ab:	62 62 7d 48 58 25 df 63 07 ff 	vpbroadcastd -0xf89c21(%rip),%zmm28        # 580494 <tier0_emit_x87.operations+0x4c>
 150a0b5:	62 62 7d 48 58 2d d9 63 07 ff 	vpbroadcastd -0xf89c27(%rip),%zmm29        # 580498 <tier0_emit_x87.operations+0x50>
 150a0bf:	62 61 fd 48 6f 35 37 62 01 ff 	vmovdqa64 -0xfe9dc9(%rip),%zmm30        # 520300 <branch_sizing_patterns+0x570>
 150a0c9:	62 62 7d 48 58 3d c9 63 07 ff 	vpbroadcastd -0xf89c37(%rip),%zmm31        # 58049c <tier0_emit_x87.operations+0x54>
 150a0d3:	62 e2 7d 48 58 2d c3 63 07 ff 	vpbroadcastd -0xf89c3d(%rip),%zmm21        # 5804a0 <tier0_emit_x87.operations+0x58>
 150a0dd:	62 e2 7d 48 58 35 c5 63 07 ff 	vpbroadcastd -0xf89c3b(%rip),%zmm22        # 5804ac <tier0_emit_x87.operations+0x64>
 150a0e7:	62 e2 7d 48 58 3d bf 63 07 ff 	vpbroadcastd -0xf89c41(%rip),%zmm23        # 5804b0 <tier0_emit_x87.operations+0x68>
 150a0f1:	62 61 fd 48 6f 15 45 62 01 ff 	vmovdqa64 -0xfe9dbb(%rip),%zmm26        # 520340 <branch_sizing_patterns+0x5b0>
 150a0fb:	62 61 fd 48 6f 1d 7b 62 01 ff 	vmovdqa64 -0xfe9d85(%rip),%zmm27        # 520380 <branch_sizing_patterns+0x5f0>
 150a105:	43 c6 04 26 01       	movb   $0x1,(%r14,%r12,1)
 150a10a:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 150a110:	4d 85 e4             	test   %r12,%r12
 150a113:	0f 84 ec 05 00 00    	je     150a705 <run_backend_benchmark+0x8f95>
 150a119:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 150a11e:	49 ff c6             	inc    %r14
 150a121:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 150a125:	4d 89 e5             	mov    %r12,%r13
 150a128:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 150a12c:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 150a130:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 150a134:	31 d2                	xor    %edx,%edx
 150a136:	48 83 c0 40          	add    $0x40,%rax
 150a13a:	48 89 84 24 40 01 00 00 	mov    %rax,0x140(%rsp)
 150a142:	44 89 ee             	mov    %r13d,%esi
 150a145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 150a14a:	49 83 ed 10          	sub    $0x10,%r13
 150a14e:	48 8b bc 24 88 0e 00 00 	mov    0xe88(%rsp),%rdi
 150a156:	4c 8b 84 24 90 0e 00 00 	mov    0xe90(%rsp),%r8
 150a15e:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
 150a163:	c4 e2 49 f7 f0       	shlx   %esi,%eax,%esi
 150a168:	b8 ff ff 00 00       	mov    $0xffff,%eax
 150a16d:	f7 d6                	not    %esi
 150a16f:	0f 43 f0             	cmovae %eax,%esi
 150a172:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 150a17a:	c5 fb 92 d6          	kmovd  %esi,%k2
 150a17e:	c5 f8 91 94 24 e8 00 00 00 	kmovw  %k2,0xe8(%rsp)
 150a187:	c4 e1 f8 90 ca       	kmovq  %k2,%k1
 150a18c:	62 f1 7e ca 6f 04 90 	vmovdqu32 (%rax,%rdx,4),%zmm0{%k2}{z}
 150a193:	62 f1 5d 48 72 d0 03 	vpsrld $0x3,%zmm0,%zmm4
 150a19a:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150a19e:	62 f2 7d 49 90 04 a7 	vpgatherdd (%rdi,%zmm4,4),%zmm0{%k1}
 150a1a5:	c4 e1 f8 90 ca       	kmovq  %k2,%k1
 150a1aa:	62 52 7d 49 90 1c a0 	vpgatherdd (%r8,%zmm4,4),%zmm11{%k1}
 150a1b1:	62 d1 7f 8a 6f a4 16 ff ff ff ff 	vmovdqu8 -0x1(%r14,%rdx,1),%xmm4{%k2}{z}
 150a1bc:	62 92 7d 48 27 d0    	vptestmd %zmm24,%zmm0,%k2
 150a1c2:	62 f1 45 48 72 d0 03 	vpsrld $0x3,%zmm0,%zmm7
 150a1c9:	62 f1 35 48 72 d0 01 	vpsrld $0x1,%zmm0,%zmm9
 150a1d0:	62 11 35 48 db c1    	vpandd %zmm25,%zmm9,%zmm8
 150a1d6:	62 91 45 48 db f9    	vpandd %zmm25,%zmm7,%zmm7
 150a1dc:	62 d1 35 48 72 f1 1f 	vpslld $0x1f,%zmm9,%zmm9
 150a1e3:	62 72 7d 48 31 d4    	vpmovzxbd %xmm4,%zmm10
 150a1e9:	c5 d9 71 f4 07       	vpsllw $0x7,%xmm4,%xmm4
 150a1ee:	62 f2 7e 08 29 e4    	vpmovb2m %xmm4,%k4
 150a1f4:	c4 e3 f9 32 c4 01    	kshiftlw $0x1,%k4,%k0
 150a1fa:	c5 fc 45 ec          	korw   %k4,%k0,%k5
 150a1fe:	62 b3 2d 48 03 e4 0f 	valignd $0xf,%zmm20,%zmm10,%zmm4
 150a205:	c4 e3 f9 32 c5 02    	kshiftlw $0x2,%k5,%k0
 150a20b:	62 d1 0d 48 72 d2 03 	vpsrld $0x3,%zmm10,%zmm14
 150a212:	c5 d4 45 d8          	korw   %k0,%k5,%k3
 150a216:	62 f1 2d 48 eb e4    	vpord  %zmm4,%zmm10,%zmm4
 150a21c:	c4 e3 f9 32 c3 04    	kshiftlw $0x4,%k3,%k0
 150a222:	62 d1 7d 4c 6f e2    	vmovdqa32 %zmm10,%zmm4{%k4}
 150a228:	62 b3 dd 48 03 f4 07 	valignq $0x7,%zmm20,%zmm4,%zmm6
 150a22f:	c5 e4 45 f0          	korw   %k0,%k3,%k6
 150a233:	62 71 2d 58 db 15 4b 62 07 ff 	vpandd -0xf89db5(%rip){1to16},%zmm10,%zmm10        # 580488 <tier0_emit_x87.operations+0x40>
 150a23d:	c4 e3 f9 32 c6 08    	kshiftlw $0x8,%k6,%k0
 150a243:	62 73 7d 58 25 15 3e 62 07 ff f8 	vpternlogd $0xf8,-0xf89dc2(%rip){1to16},%zmm0,%zmm10        # 58048c <tier0_emit_x87.operations+0x44>
 150a24e:	62 f1 5d 48 eb f6    	vpord  %zmm6,%zmm4,%zmm6
 150a254:	c5 cc 45 f8          	korw   %k0,%k6,%k7
 150a258:	62 f2 7d 58 27 05 fe 61 07 ff 	vptestmd -0xf89e02(%rip){1to16},%zmm0,%k0        # 580460 <tier0_emit_x87.operations+0x18>
 150a262:	62 f1 7d 4d 6f f4    	vmovdqa32 %zmm4,%zmm6{%k5}
 150a268:	62 b3 cd 48 03 e4 06 	valignq $0x6,%zmm20,%zmm6,%zmm4
 150a26f:	c5 f8 44 cf          	knotw  %k7,%k1
 150a273:	62 f1 7d c9 6f c9    	vmovdqa32 %zmm1,%zmm1{%k1}{z}
 150a279:	c5 f8 91 8c 24 f8 00 00 00 	kmovw  %k1,0xf8(%rsp)
 150a282:	62 f1 4d 48 eb e4    	vpord  %zmm4,%zmm6,%zmm4
 150a288:	62 f1 7d 4b 6f e6    	vmovdqa32 %zmm6,%zmm4{%k3}
 150a28e:	62 b3 dd 48 03 f4 04 	valignq $0x4,%zmm20,%zmm4,%zmm6
 150a295:	62 f1 75 48 eb f6    	vpord  %zmm6,%zmm1,%zmm6
 150a29b:	62 f1 7d 4e 6f f1    	vmovdqa32 %zmm1,%zmm6{%k6}
 150a2a1:	62 f1 4d 48 eb cc    	vpord  %zmm4,%zmm6,%zmm1
 150a2a7:	62 71 75 58 db 2d a7 61 07 ff 	vpandd -0xf89e59(%rip){1to16},%zmm1,%zmm13        # 580458 <tier0_emit_x87.operations+0x10>
 150a2b1:	62 f1 5d 48 72 d0 02 	vpsrld $0x2,%zmm0,%zmm4
 150a2b8:	62 91 7d 48 db f1    	vpandd %zmm25,%zmm0,%zmm6
 150a2be:	62 91 5d 48 db e1    	vpandd %zmm25,%zmm4,%zmm4
 150a2c4:	62 d2 15 4a 27 cd    	vptestmd %zmm13,%zmm13,%k1{%k2}
 150a2ca:	c5 fc 45 c1          	korw   %k1,%k0,%k0
 150a2ce:	c5 7b 93 c8          	kmovd  %k0,%r9d
 150a2d2:	c4 e2 30 f2 fe       	andn   %esi,%r9d,%edi
 150a2d7:	c5 fb 92 cf          	kmovd  %edi,%k1
 150a2db:	62 e1 3d c9 fe c7    	vpaddd %zmm7,%zmm8,%zmm16{%k1}{z}
 150a2e1:	62 71 5d c9 fe fe    	vpaddd %zmm6,%zmm4,%zmm15{%k1}{z}
 150a2e7:	62 b1 1d 48 72 f0 10 	vpslld $0x10,%zmm16,%zmm12
 150a2ee:	62 d2 06 48 27 c7    	vptestnmd %zmm15,%zmm15,%k0
 150a2f4:	62 c1 1d 48 eb cf    	vpord  %zmm15,%zmm12,%zmm17
 150a2fa:	62 11 0d 48 db e1    	vpandd %zmm25,%zmm14,%zmm12
 150a300:	c5 fb 93 f8          	kmovd  %k0,%edi
 150a304:	62 51 75 40 fe e4    	vpaddd %zmm12,%zmm17,%zmm12
 150a30a:	62 33 1d 48 03 f4 0f 	valignd $0xf,%zmm20,%zmm12,%zmm14
 150a311:	62 51 1d 48 fe f6    	vpaddd %zmm14,%zmm12,%zmm14
 150a317:	62 51 7d 4c 6f f4    	vmovdqa32 %zmm12,%zmm14{%k4}
 150a31d:	62 33 8d 48 03 e4 07 	valignq $0x7,%zmm20,%zmm14,%zmm12
 150a324:	62 51 0d 48 fe e4    	vpaddd %zmm12,%zmm14,%zmm12
 150a32a:	62 51 7d 4d 6f e6    	vmovdqa32 %zmm14,%zmm12{%k5}
 150a330:	62 33 9d 48 03 f4 06 	valignq $0x6,%zmm20,%zmm12,%zmm14
 150a337:	62 51 1d 48 fe f6    	vpaddd %zmm14,%zmm12,%zmm14
 150a33d:	62 51 7d 4b 6f f4    	vmovdqa32 %zmm12,%zmm14{%k3}
 150a343:	62 33 8d 48 03 e4 04 	valignq $0x4,%zmm20,%zmm14,%zmm12
 150a34a:	62 e1 0d 48 fe d3    	vpaddd %zmm3,%zmm14,%zmm18
 150a350:	62 c1 7d 4f 6f d6    	vmovdqa32 %zmm14,%zmm18{%k7}
 150a356:	62 d1 6d 40 fe dc    	vpaddd %zmm12,%zmm18,%zmm3
 150a35c:	62 b1 7d 4e 6f da    	vmovdqa32 %zmm18,%zmm3{%k6}
 150a362:	62 a1 65 48 fa d1    	vpsubd %zmm17,%zmm3,%zmm18
 150a368:	62 71 6d 50 db 25 42 61 07 ff 	vpandd -0xf89ebe(%rip){1to16},%zmm18,%zmm12        # 5804b4 <tier0_emit_x87.operations+0x6c>
 150a372:	62 f3 1d 58 1f 0d f7 60 07 ff 01 	vpcmpltd -0xf89f09(%rip){1to16},%zmm12,%k1        # 580474 <tier0_emit_x87.operations+0x2c>
 150a37d:	62 51 1d 48 fe f7    	vpaddd %zmm15,%zmm12,%zmm14
 150a383:	62 f3 0d 58 1f 05 de 60 07 ff 01 	vpcmpltd -0xf89f22(%rip){1to16},%zmm14,%k0        # 58046c <tier0_emit_x87.operations+0x24>
 150a38e:	62 b1 0d 48 72 d2 10 	vpsrld $0x10,%zmm18,%zmm14
 150a395:	62 f1 1d 48 fe f6    	vpaddd %zmm6,%zmm12,%zmm6
 150a39b:	62 12 1d 48 3b e5    	vpminud %zmm29,%zmm12,%zmm12
 150a3a1:	62 a1 0d 48 fe d8    	vpaddd %zmm16,%zmm14,%zmm19
 150a3a7:	62 51 0d 48 fe c0    	vpaddd %zmm8,%zmm14,%zmm8
 150a3ad:	62 92 4d 48 3b f5    	vpminud %zmm29,%zmm6,%zmm6
 150a3b3:	c5 7b 93 d8          	kmovd  %k0,%r11d
 150a3b7:	62 b2 7e 40 27 c0    	vptestnmd %zmm16,%zmm16,%k0
 150a3bd:	c5 fb 93 d8          	kmovd  %k0,%ebx
 150a3c1:	62 f3 65 50 1f 05 a4 60 07 ff 01 	vpcmpltd -0xf89f5c(%rip){1to16},%zmm19,%k0        # 580470 <tier0_emit_x87.operations+0x28>
 150a3cc:	41 09 fb             	or     %edi,%r11d
 150a3cf:	c5 fb 93 c8          	kmovd  %k0,%ecx
 150a3d3:	62 b2 75 40 27 c1    	vptestmd %zmm17,%zmm17,%k0
 150a3d9:	c5 fb 93 c0          	kmovd  %k0,%eax
 150a3dd:	62 d2 05 49 27 c7    	vptestmd %zmm15,%zmm15,%k0{%k1}
 150a3e3:	62 f3 6d 50 1e 0d 8a 60 07 ff 01 	vpcmpltud -0xf89f76(%rip){1to16},%zmm18,%k1        # 580478 <tier0_emit_x87.operations+0x30>
 150a3ee:	09 d9                	or     %ebx,%ecx
 150a3f0:	44 21 d9             	and    %r11d,%ecx
 150a3f3:	c4 e2 70 f2 f8       	andn   %eax,%ecx,%edi
 150a3f8:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 150a400:	62 b2 7d 41 27 c8    	vptestmd %zmm16,%zmm16,%k1{%k1}
 150a406:	c5 f4 45 c0          	korw   %k0,%k1,%k0
 150a40a:	c5 7b 93 d0          	kmovd  %k0,%r10d
 150a40e:	62 f2 7e 58 27 05 44 60 07 ff 	vptestnmd -0xf89fbc(%rip){1to16},%zmm0,%k0        # 58045c <tier0_emit_x87.operations+0x14>
 150a418:	41 21 fa             	and    %edi,%r10d
 150a41b:	44 09 cf             	or     %r9d,%edi
 150a41e:	21 f7                	and    %esi,%edi
 150a420:	41 89 f9             	mov    %edi,%r9d
 150a423:	31 f7                	xor    %esi,%edi
 150a425:	c5 7b 93 c0          	kmovd  %k0,%r8d
 150a429:	62 f2 75 5a 27 05 51 60 07 ff 	vptestmd -0xf89faf(%rip){1to16},%zmm1,%k0{%k2}        # 580484 <tier0_emit_x87.operations+0x3c>
 150a433:	62 d2 7e 48 39 d1    	vpmovd2m %zmm9,%k2
 150a439:	62 11 fd 48 6f cf    	vmovdqa64 %zmm31,%zmm9
 150a43f:	62 f1 7d 48 70 c9 ff 	vpshufd $0xff,%zmm1,%zmm1
 150a446:	45 21 c1             	and    %r8d,%r9d
 150a449:	62 11 0d 4a eb c8    	vpord  %zmm24,%zmm14,%zmm9{%k2}
 150a44f:	44 21 c7             	and    %r8d,%edi
 150a452:	62 f3 f5 48 43 c9 ff 	vshufi64x2 $0xff,%zmm1,%zmm1,%zmm1
 150a459:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 150a45e:	41 89 f8             	mov    %edi,%r8d
 150a461:	62 51 7d c9 6f db    	vmovdqa32 %zmm11,%zmm11{%k1}{z}
 150a467:	62 33 25 48 03 fc 0f 	valignd $0xf,%zmm20,%zmm11,%zmm15
 150a46e:	62 51 25 48 fe ff    	vpaddd %zmm15,%zmm11,%zmm15
 150a474:	62 51 7d 4c 6f fb    	vmovdqa32 %zmm11,%zmm15{%k4}
 150a47a:	62 a3 85 48 03 c4 07 	valignq $0x7,%zmm20,%zmm15,%zmm16
 150a481:	62 a1 05 48 fe c0    	vpaddd %zmm16,%zmm15,%zmm16
 150a487:	c5 7b 93 d8          	kmovd  %k0,%r11d
 150a48b:	62 d2 16 48 27 c5    	vptestnmd %zmm13,%zmm13,%k0
 150a491:	62 f1 15 48 72 d0 14 	vpsrld $0x14,%zmm0,%zmm13
 150a498:	62 c1 7d 4d 6f c7    	vmovdqa32 %zmm15,%zmm16{%k5}
 150a49e:	62 33 fd 40 03 fc 06 	valignq $0x6,%zmm20,%zmm16,%zmm15
 150a4a5:	c5 fb 93 d8          	kmovd  %k0,%ebx
 150a4a9:	62 d2 2d 48 27 c2    	vptestmd %zmm10,%zmm10,%k0
 150a4af:	c5 fb 93 c0          	kmovd  %k0,%eax
 150a4b3:	44 21 db             	and    %r11d,%ebx
 150a4b6:	62 51 7d 40 fe ff    	vpaddd %zmm15,%zmm16,%zmm15
 150a4bc:	09 d8                	or     %ebx,%eax
 150a4be:	62 31 7d 4b 6f f8    	vmovdqa32 %zmm16,%zmm15{%k3}
 150a4c4:	62 e1 05 48 fe c5    	vpaddd %zmm5,%zmm15,%zmm16
 150a4ca:	62 f1 15 58 db 2d a8 5f 07 ff 	vpandd -0xf8a058(%rip){1to16},%zmm13,%zmm5        # 58047c <tier0_emit_x87.operations+0x34>
 150a4d4:	62 33 85 48 03 d4 04 	valignq $0x4,%zmm20,%zmm15,%zmm10
 150a4db:	44 09 d0             	or     %r10d,%eax
 150a4de:	62 c1 7d 4f 6f c7    	vmovdqa32 %zmm15,%zmm16{%k7}
 150a4e4:	62 f1 55 58 66 05 92 5f 07 ff 	vpcmpgtd -0xf8a06e(%rip){1to16},%zmm5,%k0        # 580480 <tier0_emit_x87.operations+0x38>
 150a4ee:	62 72 35 40 47 ed    	vpsllvd %zmm5,%zmm25,%zmm13
 150a4f4:	62 d1 7d 40 fe ea    	vpaddd %zmm10,%zmm16,%zmm5
 150a4fa:	62 b1 7d 4e 6f e8    	vmovdqa32 %zmm16,%zmm5{%k6}
 150a500:	62 51 55 48 fa d3    	vpsubd %zmm11,%zmm5,%zmm10
 150a506:	62 53 25 48 25 db ff 	vpternlogd $0xff,%zmm11,%zmm11,%zmm11
 150a50d:	62 51 15 48 fe db    	vpaddd %zmm11,%zmm13,%zmm11
 150a513:	62 51 2d 48 db db    	vpandd %zmm11,%zmm10,%zmm11
 150a519:	62 73 7d 58 25 1d 6c 5f 07 ff f8 	vpternlogd $0xf8,-0xf8a094(%rip){1to16},%zmm0,%zmm11        # 580490 <tier0_emit_x87.operations+0x48>
 150a524:	62 d2 25 48 27 fb    	vptestmd %zmm11,%zmm11,%k7
 150a52a:	c5 fc 45 c7          	korw   %k7,%k0,%k0
 150a52e:	c5 7b 93 d0          	kmovd  %k0,%r10d
 150a532:	45 21 ca             	and    %r9d,%r10d
 150a535:	41 09 c2             	or     %eax,%r10d
 150a538:	48 8b 84 24 40 01 00 00 	mov    0x140(%rsp),%rax
 150a540:	41 21 f2             	and    %esi,%r10d
 150a543:	c1 ee 08             	shr    $0x8,%esi
 150a546:	c4 c1 7b 92 c2       	kmovd  %r10d,%k0
 150a54b:	62 72 7e 48 38 d8    	vpmovm2d %k0,%zmm11
 150a551:	62 d1 25 48 72 d3 1f 	vpsrld $0x1f,%zmm11,%zmm11
 150a558:	62 51 25 49 eb dd    	vpord  %zmm13,%zmm11,%zmm11{%k1}
 150a55e:	62 33 25 48 03 ec 0f 	valignd $0xf,%zmm20,%zmm11,%zmm13
 150a565:	62 51 25 48 eb ed    	vpord  %zmm13,%zmm11,%zmm13
 150a56b:	62 51 7d 4c 6f eb    	vmovdqa32 %zmm11,%zmm13{%k4}
 150a571:	62 33 95 48 03 dc 07 	valignq $0x7,%zmm20,%zmm13,%zmm11
 150a578:	62 51 15 48 eb fb    	vpord  %zmm11,%zmm13,%zmm15
 150a57e:	62 51 7d 4d 6f fd    	vmovdqa32 %zmm13,%zmm15{%k5}
 150a584:	62 33 85 48 03 dc 06 	valignq $0x6,%zmm20,%zmm15,%zmm11
 150a58b:	62 51 05 48 eb db    	vpord  %zmm11,%zmm15,%zmm11
 150a591:	62 51 7d 4b 6f df    	vmovdqa32 %zmm15,%zmm11{%k3}
 150a597:	c5 f8 90 9c 24 f8 00 00 00 	kmovw  0xf8(%rsp),%k3
 150a5a0:	62 33 a5 48 03 fc 04 	valignq $0x4,%zmm20,%zmm11,%zmm15
 150a5a7:	62 71 7d cb 6f ea    	vmovdqa32 %zmm2,%zmm13{%k3}{z}
 150a5ad:	62 d1 15 48 eb d7    	vpord  %zmm15,%zmm13,%zmm2
 150a5b3:	62 f1 05 48 72 f0 1f 	vpslld $0x1f,%zmm0,%zmm15
 150a5ba:	62 d2 7e 48 39 d7    	vpmovd2m %zmm15,%k2
 150a5c0:	62 d1 7d 4e 6f d5    	vmovdqa32 %zmm13,%zmm2{%k6}
 150a5c6:	62 12 1d 4a 36 ce    	vpermd %zmm30,%zmm12,%zmm9{%k2}
 150a5cc:	62 f2 45 48 27 d7    	vptestmd %zmm7,%zmm7,%k2
 150a5d2:	62 91 fd 48 6f ff    	vmovdqa64 %zmm31,%zmm7
 150a5d8:	62 91 3d 4a eb f8    	vpord  %zmm24,%zmm8,%zmm7{%k2}
 150a5de:	62 f2 5e 48 27 d4    	vptestnmd %zmm4,%zmm4,%k2
 150a5e4:	62 92 4d 48 36 e6    	vpermd %zmm30,%zmm6,%zmm4
 150a5ea:	62 51 7d c9 6f c2    	vmovdqa32 %zmm10,%zmm8{%k1}{z}
 150a5f0:	62 f1 7d 4a 6f e7    	vmovdqa32 %zmm7,%zmm4{%k2}
 150a5f6:	62 92 7d 48 27 d4    	vptestmd %zmm28,%zmm0,%k2
 150a5fc:	62 b1 fd 48 6f fd    	vmovdqa64 %zmm21,%zmm7
 150a602:	62 f1 7d 48 72 f0 0e 	vpslld $0xe,%zmm0,%zmm0
 150a609:	c5 7b 93 ca          	kmovd  %k2,%r9d
 150a60d:	62 d2 5d 4a 64 f1    	vpblendmd %zmm9,%zmm4,%zmm6{%k2}
 150a613:	62 b1 7d 48 db c6    	vpandd %zmm22,%zmm0,%zmm0
 150a619:	45 21 c8             	and    %r9d,%r8d
 150a61c:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 150a621:	c4 62 30 f2 c7       	andn   %edi,%r9d,%r8d
 150a626:	62 f1 45 4a 72 f4 08 	vpslld $0x8,%zmm4,%zmm7{%k2}
 150a62d:	c5 fb 92 d7          	kmovd  %edi,%k2
 150a631:	62 72 7d ca 58 0d 69 5e 07 ff 	vpbroadcastd -0xf8a197(%rip),%zmm9{%k2}{z}        # 5804a4 <tier0_emit_x87.operations+0x5c>
 150a63b:	62 f2 05 42 64 e6    	vpblendmd %zmm6,%zmm31,%zmm4{%k2}
 150a641:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 150a646:	62 d1 fd 48 6f f0    	vmovdqa64 %zmm8,%zmm6
 150a64c:	62 b1 7d 4a eb c7    	vpord  %zmm23,%zmm0,%zmm0{%k2}
 150a652:	62 f1 45 48 eb e4    	vpord  %zmm4,%zmm7,%zmm4
 150a658:	62 72 7d 49 58 0d 46 5e 07 ff 	vpbroadcastd -0xf8a1ba(%rip),%zmm9{%k1}        # 5804a8 <tier0_emit_x87.operations+0x60>
 150a662:	c5 f8 90 8c 24 e8 00 00 00 	kmovw  0xe8(%rsp),%k1
 150a66b:	62 d3 5d 48 25 c1 fe 	vpternlogd $0xfe,%zmm9,%zmm4,%zmm0
 150a672:	62 d1 7f 89 6f 24 16 	vmovdqu8 (%r14,%rdx,1),%xmm4{%k1}{z}
 150a679:	62 f2 2d 40 7e f0    	vpermt2d %zmm0,%zmm26,%zmm6
 150a67f:	62 72 25 40 7e c0    	vpermt2d %zmm0,%zmm27,%zmm8
 150a685:	62 f1 fe 49 7f 74 d0 ff 	vmovdqu64 %zmm6,-0x40(%rax,%rdx,8){%k1}
 150a68d:	c5 fb 92 ce          	kmovd  %esi,%k1
 150a691:	48 8b b4 24 28 01 00 00 	mov    0x128(%rsp),%rsi
 150a699:	62 71 fe 49 7f 04 d0 	vmovdqu64 %zmm8,(%rax,%rdx,8){%k1}
 150a6a0:	c5 f9 71 f4 07       	vpsllw $0x7,%xmm4,%xmm0
 150a6a5:	62 f2 7e 08 29 c8    	vpmovb2m %xmm0,%k1
 150a6ab:	62 d1 6d 48 eb c3    	vpord  %zmm11,%zmm2,%zmm0
 150a6b1:	62 f1 7d 48 70 d3 ff 	vpshufd $0xff,%zmm3,%zmm2
 150a6b8:	62 f1 7e 49 7f 1c 91 	vmovdqu32 %zmm3,(%rcx,%rdx,4){%k1}
 150a6bf:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 150a6c7:	62 f3 ed 48 43 da ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm3
 150a6ce:	62 f1 7d 48 70 d5 ff 	vpshufd $0xff,%zmm5,%zmm2
 150a6d5:	62 f1 7e 49 7f 2c 96 	vmovdqu32 %zmm5,(%rsi,%rdx,4){%k1}
 150a6dc:	62 f3 ed 48 43 ea ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm5
 150a6e3:	62 f1 7e 49 7f 04 91 	vmovdqu32 %zmm0,(%rcx,%rdx,4){%k1}
 150a6ea:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 150a6f1:	48 83 c2 10          	add    $0x10,%rdx
 150a6f5:	62 f3 fd 48 43 d0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm2
 150a6fc:	4c 39 e2             	cmp    %r12,%rdx
 150a6ff:	0f 82 3d fa ff ff    	jb     150a142 <run_backend_benchmark+0x89d2>
 150a705:	83 bc 24 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rsp)
 150a70d:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 150a715:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 150a71a:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 150a71f:	48 8b 8c 24 d0 00 00 00 	mov    0xd0(%rsp),%rcx
 150a727:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 150a72f:	0f 84 d0 ea ff ff    	je     1509205 <run_backend_benchmark+0x7a95>
 150a735:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
 150a73a:	4c 8d 3c 8d 00 00 00 00 	lea    0x0(,%rcx,4),%r15
 150a742:	45 31 f6             	xor    %r14d,%r14d
 150a745:	31 db                	xor    %ebx,%ebx
 150a747:	eb 2f                	jmp    150a778 <run_backend_benchmark+0x9008>
 150a749:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 150a751:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 150a756:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 150a75e:	4d 89 ec             	mov    %r13,%r12
 150a761:	48 ff c3             	inc    %rbx
 150a764:	49 83 c4 10          	add    $0x10,%r12
 150a768:	49 83 c6 04          	add    $0x4,%r14
 150a76c:	48 ff c0             	inc    %rax
 150a76f:	4d 39 f7             	cmp    %r14,%r15
 150a772:	0f 84 8d ea ff ff    	je     1509205 <run_backend_benchmark+0x7a95>
 150a778:	42 8b 14 32          	mov    (%rdx,%r14,1),%edx
 150a77c:	4c 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%r9
 150a784:	48 8b b4 24 00 01 00 00 	mov    0x100(%rsp),%rsi
 150a78c:	48 89 84 24 a0 00 00 00 	mov    %rax,0xa0(%rsp)
 150a794:	48 85 d2             	test   %rdx,%rdx
 150a797:	74 5b                	je     150a7f4 <run_backend_benchmark+0x9084>
 150a799:	4e 8b 04 77          	mov    (%rdi,%r14,2),%r8
 150a79d:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 150a7a5:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
 150a7aa:	4d 89 e5             	mov    %r12,%r13
 150a7ad:	49 89 dc             	mov    %rbx,%r12
 150a7b0:	49 c1 e4 04          	shl    $0x4,%r12
 150a7b4:	49 01 d0             	add    %rdx,%r8
 150a7b7:	4d 01 dc             	add    %r11,%r12
 150a7ba:	42 8b 4c 80 fc       	mov    -0x4(%rax,%r8,4),%ecx
 150a7bf:	42 8b 44 86 fc       	mov    -0x4(%rsi,%r8,4),%eax
 150a7c4:	47 8b 44 81 fc       	mov    -0x4(%r9,%r8,4),%r8d
 150a7c9:	41 b9 04 00 00 00    	mov    $0x4,%r9d
 150a7cf:	89 c6                	mov    %eax,%esi
 150a7d1:	83 ce 01             	or     $0x1,%esi
 150a7d4:	0f b7 f9             	movzwl %cx,%edi
 150a7d7:	f3 0f bd f6          	lzcnt  %esi,%esi
 150a7db:	83 f6 1f             	xor    $0x1f,%esi
 150a7de:	83 fe 05             	cmp    $0x5,%esi
 150a7e1:	41 0f 42 f1          	cmovb  %r9d,%esi
 150a7e5:	83 ff 06             	cmp    $0x6,%edi
 150a7e8:	41 b9 06 00 00 00    	mov    $0x6,%r9d
 150a7ee:	41 0f 43 f9          	cmovae %r9d,%edi
 150a7f2:	eb 20                	jmp    150a814 <run_backend_benchmark+0x90a4>
 150a7f4:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 150a7fc:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
 150a801:	45 31 c0             	xor    %r8d,%r8d
 150a804:	4d 89 e5             	mov    %r12,%r13
 150a807:	8b 08                	mov    (%rax),%ecx
 150a809:	8b 06                	mov    (%rsi),%eax
 150a80b:	43 0f b6 7c b3 05    	movzbl 0x5(%r11,%r14,4),%edi
 150a811:	40 b6 04             	mov    $0x4,%sil
 150a814:	c1 e9 10             	shr    $0x10,%ecx
 150a817:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 150a81d:	45 89 04 24          	mov    %r8d,(%r12)
 150a821:	43 88 74 b3 04       	mov    %sil,0x4(%r11,%r14,4)
 150a826:	be 00 00 00 00       	mov    $0x0,%esi
 150a82b:	43 88 7c b3 05       	mov    %dil,0x5(%r11,%r14,4)
 150a830:	83 f9 08             	cmp    $0x8,%ecx
 150a833:	41 0f 43 c9          	cmovae %r9d,%ecx
 150a837:	48 85 d2             	test   %rdx,%rdx
 150a83a:	0f 44 ce             	cmove  %esi,%ecx
 150a83d:	43 88 4c b3 06       	mov    %cl,0x6(%r11,%r14,4)
 150a842:	0f 84 01 ff ff ff    	je     150a749 <run_backend_benchmark+0x8fd9>
 150a848:	83 e0 01             	and    $0x1,%eax
 150a84b:	0f 84 f8 fe ff ff    	je     150a749 <run_backend_benchmark+0x8fd9>
 150a851:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 150a856:	48 8b bc 24 a0 00 00 00 	mov    0xa0(%rsp),%rdi
 150a85e:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 150a863:	48 8b b4 24 c0 00 00 00 	mov    0xc0(%rsp),%rsi
 150a86b:	42 8b 0c 30          	mov    (%rax,%r14,1),%ecx
 150a86f:	48 8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%rax
 150a877:	47 8b 0c 33          	mov    (%r11,%r14,1),%r9d
 150a87b:	39 d1                	cmp    %edx,%ecx
 150a87d:	4a 8b 04 70          	mov    (%rax,%r14,2),%rax
 150a881:	0f 43 ca             	cmovae %edx,%ecx
 150a884:	45 31 c0             	xor    %r8d,%r8d
 150a887:	80 3f 00             	cmpb   $0x0,(%rdi)
 150a88a:	48 8d bc 24 80 0e 00 00 	lea    0xe80(%rsp),%rdi
 150a892:	48 8d 34 86          	lea    (%rsi,%rax,4),%rsi
 150a896:	49 8d 04 c2          	lea    (%r10,%rax,8),%rax
 150a89a:	41 0f 95 c0          	setne  %r8b
 150a89e:	48 89 04 24          	mov    %rax,(%rsp)
 150a8a2:	c5 f8 77             	vzeroupper
 150a8a5:	e8 b6 a4 02 00       	call   1534d60 <abi_assign_call>
 150a8aa:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 150a8af:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 150a8b4:	49 89 04 24          	mov    %rax,(%r12)
 150a8b8:	4a 89 54 b1 08       	mov    %rdx,0x8(%rcx,%r14,4)
 150a8bd:	e9 87 fe ff ff       	jmp    150a749 <run_backend_benchmark+0x8fd9>
 150a8c2:	48 89 cf             	mov    %rcx,%rdi
 150a8c5:	4c 29 ef             	sub    %r13,%rdi
 150a8c8:	4c 89 f2             	mov    %r14,%rdx
 150a8cb:	48 29 fa             	sub    %rdi,%rdx
 150a8ce:	41 0f 92 c0          	setb   %r8b
 150a8d2:	48 81 fa 00 00 80 06 	cmp    $0x6800000,%rdx
 150a8d9:	0f 92 c2             	setb   %dl
 150a8dc:	44 08 c2             	or     %r8b,%dl
 150a8df:	80 fa 01             	cmp    $0x1,%dl
 150a8e2:	75 04                	jne    150a8e8 <run_backend_benchmark+0x9178>
 150a8e4:	31 d2                	xor    %edx,%edx
 150a8e6:	eb 39                	jmp    150a921 <run_backend_benchmark+0x91b1>
 150a8e8:	48 81 c6 07 00 80 06 	add    $0x6800007,%rsi
 150a8ef:	48 81 c7 00 00 80 06 	add    $0x6800000,%rdi
 150a8f6:	48 8d 91 00 00 80 06 	lea    0x6800000(%rcx),%rdx
 150a8fd:	48 89 8c 24 70 01 00 00 	mov    %rcx,0x170(%rsp)
 150a905:	48 83 e6 f8          	and    $0xfffffffffffffff8,%rsi
 150a909:	48 89 fb             	mov    %rdi,%rbx
 150a90c:	48 39 d6             	cmp    %rdx,%rsi
 150a90f:	0f 82 93 c3 ff ff    	jb     1506ca8 <run_backend_benchmark+0x5538>
 150a915:	48 89 f7             	mov    %rsi,%rdi
 150a918:	4c 29 ef             	sub    %r13,%rdi
 150a91b:	48 89 ca             	mov    %rcx,%rdx
 150a91e:	48 89 f1             	mov    %rsi,%rcx
 150a921:	4c 89 f6             	mov    %r14,%rsi
 150a924:	48 29 fe             	sub    %rdi,%rsi
 150a927:	41 0f 92 c0          	setb   %r8b
 150a92b:	48 81 fe 00 00 80 00 	cmp    $0x800000,%rsi
 150a932:	40 0f 92 c6          	setb   %sil
 150a936:	44 08 c6             	or     %r8b,%sil
 150a939:	40 80 fe 01          	cmp    $0x1,%sil
 150a93d:	75 10                	jne    150a94f <run_backend_benchmark+0x91df>
 150a93f:	48 c7 84 24 78 01 00 00 00 00 00 00 	movq   $0x0,0x178(%rsp)
 150a94b:	31 f6                	xor    %esi,%esi
 150a94d:	eb 38                	jmp    150a987 <run_backend_benchmark+0x9217>
 150a94f:	4e 8d 84 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r8
 150a957:	4a 8d b4 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%rsi
 150a95f:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 150a966:	48 89 8c 24 78 01 00 00 	mov    %rcx,0x178(%rsp)
 150a96e:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
 150a972:	49 39 f0             	cmp    %rsi,%r8
 150a975:	0f 82 3e c3 ff ff    	jb     1506cb9 <run_backend_benchmark+0x5549>
 150a97b:	4c 89 c7             	mov    %r8,%rdi
 150a97e:	4c 29 ef             	sub    %r13,%rdi
 150a981:	48 89 ce             	mov    %rcx,%rsi
 150a984:	4c 89 c1             	mov    %r8,%rcx
 150a987:	4d 89 f0             	mov    %r14,%r8
 150a98a:	49 29 f8             	sub    %rdi,%r8
 150a98d:	41 0f 92 c1          	setb   %r9b
 150a991:	49 81 f8 00 00 80 00 	cmp    $0x800000,%r8
 150a998:	41 0f 92 c0          	setb   %r8b
 150a99c:	45 08 c8             	or     %r9b,%r8b
 150a99f:	41 80 f8 01          	cmp    $0x1,%r8b
 150a9a3:	75 11                	jne    150a9b6 <run_backend_benchmark+0x9246>
 150a9a5:	48 c7 84 24 80 01 00 00 00 00 00 00 	movq   $0x0,0x180(%rsp)
 150a9b1:	45 31 c0             	xor    %r8d,%r8d
 150a9b4:	eb 38                	jmp    150a9ee <run_backend_benchmark+0x927e>
 150a9b6:	4e 8d 8c 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r9
 150a9be:	4e 8d 84 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%r8
 150a9c6:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 150a9cd:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 150a9d5:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
 150a9d9:	4d 39 c1             	cmp    %r8,%r9
 150a9dc:	0f 82 e8 c2 ff ff    	jb     1506cca <run_backend_benchmark+0x555a>
 150a9e2:	4c 89 cf             	mov    %r9,%rdi
 150a9e5:	4c 29 ef             	sub    %r13,%rdi
 150a9e8:	49 89 c8             	mov    %rcx,%r8
 150a9eb:	4c 89 c9             	mov    %r9,%rcx
 150a9ee:	4d 89 f1             	mov    %r14,%r9
 150a9f1:	49 29 f9             	sub    %rdi,%r9
 150a9f4:	41 0f 92 c2          	setb   %r10b
 150a9f8:	49 81 f9 00 00 80 00 	cmp    $0x800000,%r9
 150a9ff:	41 0f 92 c1          	setb   %r9b
 150aa03:	45 08 d1             	or     %r10b,%r9b
 150aa06:	41 80 f9 01          	cmp    $0x1,%r9b
 150aa0a:	75 26                	jne    150aa32 <run_backend_benchmark+0x92c2>
 150aa0c:	48 c7 84 24 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rsp)
 150aa18:	45 31 d2             	xor    %r10d,%r10d
 150aa1b:	eb 4d                	jmp    150aa6a <run_backend_benchmark+0x92fa>
 150aa1d:	48 8b 05 f4 f2 c8 00 	mov    0xc8f2f4(%rip),%rax        # 2199d18 <stderr@GLIBC_2.2.5>
 150aa24:	48 8d 3d 17 d9 11 ff 	lea    -0xee26e9(%rip),%rdi        # 628342 <fuzz_comment_end+0x14af3>
 150aa2b:	be 7a 00 00 00       	mov    $0x7a,%esi
 150aa30:	eb 77                	jmp    150aaa9 <run_backend_benchmark+0x9339>
 150aa32:	4e 8d 8c 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r9
 150aa3a:	4e 8d 94 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%r10
 150aa42:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 150aa49:	48 89 8c 24 88 01 00 00 	mov    %rcx,0x188(%rsp)
 150aa51:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
 150aa55:	4d 39 d1             	cmp    %r10,%r9
 150aa58:	0f 82 7d c2 ff ff    	jb     1506cdb <run_backend_benchmark+0x556b>
 150aa5e:	4c 89 cf             	mov    %r9,%rdi
 150aa61:	4c 29 ef             	sub    %r13,%rdi
 150aa64:	49 89 ca             	mov    %rcx,%r10
 150aa67:	4c 89 c9             	mov    %r9,%rcx
 150aa6a:	4d 89 f1             	mov    %r14,%r9
 150aa6d:	49 29 f9             	sub    %rdi,%r9
 150aa70:	41 0f 92 c3          	setb   %r11b
 150aa74:	49 81 f9 00 00 80 00 	cmp    $0x800000,%r9
 150aa7b:	41 0f 92 c1          	setb   %r9b
 150aa7f:	45 08 d9             	or     %r11b,%r9b
 150aa82:	74 40                	je     150aac4 <run_backend_benchmark+0x9354>
 150aa84:	45 31 c9             	xor    %r9d,%r9d
 150aa87:	4c 89 d1             	mov    %r10,%rcx
 150aa8a:	e9 4f c2 ff ff       	jmp    1506cde <run_backend_benchmark+0x556e>
 150aa8f:	c6 05 aa cb 4e 0d 00 	movb   $0x0,0xd4ecbaa(%rip)        # e9f7640 <tier0_initialized>
 150aa96:	48 8b 05 7b f2 c8 00 	mov    0xc8f27b(%rip),%rax        # 2199d18 <stderr@GLIBC_2.2.5>
 150aa9d:	48 8d 3d 2c c9 17 ff 	lea    -0xe836d4(%rip),%rdi        # 6873d0 <pp_string_value.meaning+0x2a184>
 150aaa4:	be 2d 00 00 00       	mov    $0x2d,%esi
 150aaa9:	48 8b 08             	mov    (%rax),%rcx
 150aaac:	ba 01 00 00 00       	mov    $0x1,%edx
 150aab1:	c5 f8 77             	vzeroupper
 150aab4:	e8 c7 99 25 ff       	call   764480 <fwrite@plt>
 150aab9:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 150aabf:	e9 a7 02 00 00       	jmp    150ad6b <run_backend_benchmark+0x95fb>
 150aac4:	48 81 c7 00 00 80 00 	add    $0x800000,%rdi
 150aacb:	49 89 c9             	mov    %rcx,%r9
 150aace:	4c 89 d1             	mov    %r10,%rcx
 150aad1:	48 89 fb             	mov    %rdi,%rbx
 150aad4:	e9 05 c2 ff ff       	jmp    1506cde <run_backend_benchmark+0x556e>
 150aad9:	41 8b 47 18          	mov    0x18(%r15),%eax
 150aadd:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 150aae2:	48 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%rsi
 150aaea:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 150aaf2:	41 ff c6             	inc    %r14d
 150aaf5:	48 01 c1             	add    %rax,%rcx
 150aaf8:	8b 84 24 6c 02 00 00 	mov    0x26c(%rsp),%eax
 150aaff:	4c 01 ee             	add    %r13,%rsi
 150ab02:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 150ab07:	48 01 c2             	add    %rax,%rdx
 150ab0a:	e9 8e 00 00 00       	jmp    150ab9d <run_backend_benchmark+0x942d>
 150ab0f:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 150ab14:	4d 85 ed             	test   %r13,%r13
 150ab17:	0f 85 b3 00 00 00    	jne    150abd0 <run_backend_benchmark+0x9460>
 150ab1d:	e9 d5 00 00 00       	jmp    150abf7 <run_backend_benchmark+0x9487>
 150ab22:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 150ab27:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 150ab2f:	48 8b 94 24 30 01 00 00 	mov    0x130(%rsp),%rdx
 150ab37:	48 8d 35 1b 3f 16 ff 	lea    -0xe9c0e5(%rip),%rsi        # 66ea59 <pp_string_value.meaning+0x1180d>
 150ab3e:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 150ab43:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 150ab4b:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 150ab53:	48 89 84 24 a8 01 00 00 	mov    %rax,0x1a8(%rsp)
 150ab5b:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 150ab63:	48 89 84 24 b0 01 00 00 	mov    %rax,0x1b0(%rsp)
 150ab6b:	48 8b 05 a6 f1 c8 00 	mov    0xc8f1a6(%rip),%rax        # 2199d18 <stderr@GLIBC_2.2.5>
 150ab72:	48 8b 38             	mov    (%rax),%rdi
 150ab75:	31 c0                	xor    %eax,%eax
 150ab77:	e8 a4 95 25 ff       	call   764120 <fprintf@plt>
 150ab7c:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 150ab81:	eb 3a                	jmp    150abbd <run_backend_benchmark+0x944d>
 150ab83:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 150ab88:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 150ab8d:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 150ab95:	48 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%rsi
 150ab9d:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 150aba5:	48 89 8c 24 a0 01 00 00 	mov    %rcx,0x1a0(%rsp)
 150abad:	48 89 b4 24 a8 01 00 00 	mov    %rsi,0x1a8(%rsp)
 150abb5:	48 89 94 24 b0 01 00 00 	mov    %rdx,0x1b0(%rsp)
 150abbd:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 150abc5:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 150abcb:	4d 85 ed             	test   %r13,%r13
 150abce:	74 27                	je     150abf7 <run_backend_benchmark+0x9487>
 150abd0:	4c 2b ac 24 38 01 00 00 	sub    0x138(%rsp),%r13
 150abd8:	48 83 bc 24 60 01 00 00 ff 	cmpq   $0xffffffffffffffff,0x160(%rsp)
 150abe1:	49 8d b6 00 00 20 00 	lea    0x200000(%r14),%rsi
 150abe8:	49 0f 44 f6          	cmove  %r14,%rsi
 150abec:	4c 89 ef             	mov    %r13,%rdi
 150abef:	c5 f8 77             	vzeroupper
 150abf2:	e8 a9 90 25 ff       	call   763ca0 <munmap@plt>
 150abf7:	48 8b bc 24 e0 01 00 00 	mov    0x1e0(%rsp),%rdi
 150abff:	48 85 ff             	test   %rdi,%rdi
 150ac02:	74 37                	je     150ac3b <run_backend_benchmark+0x94cb>
 150ac04:	48 8b 84 24 f0 01 00 00 	mov    0x1f0(%rsp),%rax
 150ac0c:	48 2b bc 24 f8 01 00 00 	sub    0x1f8(%rsp),%rdi
 150ac14:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 150ac1b:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 150ac22:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 150ac28:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 150ac2f:	48 0f 42 f1          	cmovb  %rcx,%rsi
 150ac33:	c5 f8 77             	vzeroupper
 150ac36:	e8 65 90 25 ff       	call   763ca0 <munmap@plt>
 150ac3b:	48 8b bc 24 c0 01 00 00 	mov    0x1c0(%rsp),%rdi
 150ac43:	48 85 ff             	test   %rdi,%rdi
 150ac46:	74 37                	je     150ac7f <run_backend_benchmark+0x950f>
 150ac48:	48 8b 84 24 d0 01 00 00 	mov    0x1d0(%rsp),%rax
 150ac50:	48 2b bc 24 d8 01 00 00 	sub    0x1d8(%rsp),%rdi
 150ac58:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 150ac5f:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 150ac66:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 150ac6c:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 150ac73:	48 0f 42 f1          	cmovb  %rcx,%rsi
 150ac77:	c5 f8 77             	vzeroupper
 150ac7a:	e8 21 90 25 ff       	call   763ca0 <munmap@plt>
 150ac7f:	48 8b bc 24 20 0e 00 00 	mov    0xe20(%rsp),%rdi
 150ac87:	48 8d 9c 24 20 0e 00 00 	lea    0xe20(%rsp),%rbx
 150ac8f:	48 85 ff             	test   %rdi,%rdi
 150ac92:	74 37                	je     150accb <run_backend_benchmark+0x955b>
 150ac94:	48 8b 84 24 30 0e 00 00 	mov    0xe30(%rsp),%rax
 150ac9c:	48 2b bc 24 38 0e 00 00 	sub    0xe38(%rsp),%rdi
 150aca4:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 150acab:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 150acb2:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 150acb8:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 150acbf:	48 0f 42 f1          	cmovb  %rcx,%rsi
 150acc3:	c5 f8 77             	vzeroupper
 150acc6:	e8 d5 8f 25 ff       	call   763ca0 <munmap@plt>
 150accb:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150accf:	c5 fd 7f 03          	vmovdqa %ymm0,(%rbx)
 150acd3:	48 8d 9c 24 40 0e 00 00 	lea    0xe40(%rsp),%rbx
 150acdb:	48 8b bc 24 40 0e 00 00 	mov    0xe40(%rsp),%rdi
 150ace3:	48 85 ff             	test   %rdi,%rdi
 150ace6:	74 3b                	je     150ad23 <run_backend_benchmark+0x95b3>
 150ace8:	48 8b 84 24 50 0e 00 00 	mov    0xe50(%rsp),%rax
 150acf0:	48 2b bc 24 58 0e 00 00 	sub    0xe58(%rsp),%rdi
 150acf8:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 150acff:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 150ad06:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 150ad0c:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 150ad13:	48 0f 42 f1          	cmovb  %rcx,%rsi
 150ad17:	c5 f8 77             	vzeroupper
 150ad1a:	e8 81 8f 25 ff       	call   763ca0 <munmap@plt>
 150ad1f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150ad23:	c5 fd 7f 03          	vmovdqa %ymm0,(%rbx)
 150ad27:	48 8b bc 24 40 0f 00 00 	mov    0xf40(%rsp),%rdi
 150ad2f:	48 85 ff             	test   %rdi,%rdi
 150ad32:	74 37                	je     150ad6b <run_backend_benchmark+0x95fb>
 150ad34:	48 8b 84 24 50 0f 00 00 	mov    0xf50(%rsp),%rax
 150ad3c:	48 2b bc 24 58 0f 00 00 	sub    0xf58(%rsp),%rdi
 150ad44:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 150ad4b:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 150ad52:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 150ad58:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 150ad5f:	48 0f 42 f1          	cmovb  %rcx,%rsi
 150ad63:	c5 f8 77             	vzeroupper
 150ad66:	e8 35 8f 25 ff       	call   763ca0 <munmap@plt>
 150ad6b:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 150ad74:	48 3b 84 24 80 2c 00 00 	cmp    0x2c80(%rsp),%rax
 150ad7c:	0f 85 b9 0b 00 00    	jne    150b93b <run_backend_benchmark+0xa1cb>
 150ad82:	44 89 e0             	mov    %r12d,%eax
 150ad85:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 150ad89:	5b                   	pop    %rbx
 150ad8a:	41 5c                	pop    %r12
 150ad8c:	41 5d                	pop    %r13
 150ad8e:	41 5e                	pop    %r14
 150ad90:	41 5f                	pop    %r15
 150ad92:	5d                   	pop    %rbp
 150ad93:	c5 f8 77             	vzeroupper
 150ad96:	c3                   	ret
 150ad97:	48 bb 00 00 00 00 90 00 00 00 	movabs $0x9000000000,%rbx
 150ada1:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 150ada9:	bf 2a 01 00 00       	mov    $0x12a,%edi
 150adae:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 150adb4:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 150adb9:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150adbf:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150adc3:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 150adce:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 150add9:	31 d2                	xor    %edx,%edx
 150addb:	31 c0                	xor    %eax,%eax
 150addd:	48 89 9c 24 80 02 00 00 	mov    %rbx,0x280(%rsp)
 150ade5:	48 c7 84 24 88 02 00 00 00 00 00 00 	movq   $0x0,0x288(%rsp)
 150adf1:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 150adfd:	c5 f8 77             	vzeroupper
 150ae00:	e8 0b 97 25 ff       	call   764510 <syscall@plt>
 150ae05:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 150ae0d:	bf 2a 01 00 00       	mov    $0x12a,%edi
 150ae12:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 150ae18:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 150ae1d:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150ae23:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150ae27:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 150ae2f:	41 89 c6             	mov    %eax,%r14d
 150ae32:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 150ae3d:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 150ae48:	48 89 9c 24 80 02 00 00 	mov    %rbx,0x280(%rsp)
 150ae50:	48 c7 84 24 88 02 00 00 01 00 00 00 	movq   $0x1,0x288(%rsp)
 150ae5c:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 150ae68:	31 d2                	xor    %edx,%edx
 150ae6a:	31 c0                	xor    %eax,%eax
 150ae6c:	c5 f8 77             	vzeroupper
 150ae6f:	e8 9c 96 25 ff       	call   764510 <syscall@plt>
 150ae74:	48 89 84 24 b0 00 00 00 	mov    %rax,0xb0(%rsp)
 150ae7c:	48 c1 e0 20          	shl    $0x20,%rax
 150ae80:	49 81 c7 a0 08 e0 ff 	add    $0xffffffffffe008a0,%r15
 150ae87:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 150ae8f:	bf 2a 01 00 00       	mov    $0x12a,%edi
 150ae94:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 150ae9a:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 150ae9f:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150aea5:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150aea9:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 150aeb4:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 150aebf:	31 d2                	xor    %edx,%edx
 150aec1:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 150aec6:	49 09 c6             	or     %rax,%r14
 150aec9:	48 b8 04 00 00 00 90 00 00 00 	movabs $0x9000000004,%rax
 150aed3:	48 89 84 24 80 02 00 00 	mov    %rax,0x280(%rsp)
 150aedb:	4c 89 bc 24 88 02 00 00 	mov    %r15,0x288(%rsp)
 150aee3:	31 c0                	xor    %eax,%eax
 150aee5:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 150aef1:	c5 f8 77             	vzeroupper
 150aef4:	e8 17 96 25 ff       	call   764510 <syscall@plt>
 150aef9:	4c 8d ac 24 80 02 00 00 	lea    0x280(%rsp),%r13
 150af01:	48 8d 9c 24 68 01 00 00 	lea    0x168(%rsp),%rbx
 150af09:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 150af11:	49 89 c7             	mov    %rax,%r15
 150af14:	31 f6                	xor    %esi,%esi
 150af16:	4d 89 f0             	mov    %r14,%r8
 150af19:	45 89 f9             	mov    %r15d,%r9d
 150af1c:	4c 89 ef             	mov    %r13,%rdi
 150af1f:	48 89 da             	mov    %rbx,%rdx
 150af22:	4c 89 e1             	mov    %r12,%rcx
 150af25:	e8 d6 69 00 00       	call   1511900 <tier0_benchmark_run>
 150af2a:	be 01 00 00 00       	mov    $0x1,%esi
 150af2f:	4c 89 ef             	mov    %r13,%rdi
 150af32:	48 89 da             	mov    %rbx,%rdx
 150af35:	4c 89 e1             	mov    %r12,%rcx
 150af38:	4d 89 f0             	mov    %r14,%r8
 150af3b:	45 89 f9             	mov    %r15d,%r9d
 150af3e:	e8 bd 69 00 00       	call   1511900 <tier0_benchmark_run>
 150af43:	be 02 00 00 00       	mov    $0x2,%esi
 150af48:	4c 89 ef             	mov    %r13,%rdi
 150af4b:	48 89 da             	mov    %rbx,%rdx
 150af4e:	4c 89 e1             	mov    %r12,%rcx
 150af51:	4d 89 f0             	mov    %r14,%r8
 150af54:	45 89 f9             	mov    %r15d,%r9d
 150af57:	e8 a4 69 00 00       	call   1511900 <tier0_benchmark_run>
 150af5c:	be 03 00 00 00       	mov    $0x3,%esi
 150af61:	4c 89 ef             	mov    %r13,%rdi
 150af64:	48 89 da             	mov    %rbx,%rdx
 150af67:	4c 89 e1             	mov    %r12,%rcx
 150af6a:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
 150af6f:	4d 89 f0             	mov    %r14,%r8
 150af72:	45 89 f9             	mov    %r15d,%r9d
 150af75:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
 150af7a:	e8 81 69 00 00       	call   1511900 <tier0_benchmark_run>
 150af7f:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 150af87:	ba 80 0a 00 00       	mov    $0xa80,%edx
 150af8c:	31 f6                	xor    %esi,%esi
 150af8e:	e8 9d 93 25 ff       	call   764330 <memset@plt>
 150af93:	48 8b 84 24 18 01 00 00 	mov    0x118(%rsp),%rax
 150af9b:	48 85 c0             	test   %rax,%rax
 150af9e:	0f 84 1d 03 00 00    	je     150b2c1 <run_backend_benchmark+0x9b51>
 150afa4:	48 69 c0 40 42 0f 00 	imul   $0xf4240,%rax,%rax
 150afab:	4c 8b a4 24 80 00 00 00 	mov    0x80(%rsp),%r12
 150afb3:	4c 8d ac 24 18 02 00 00 	lea    0x218(%rsp),%r13
 150afbb:	48 c7 84 24 90 00 00 00 00 00 00 00 	movq   $0x0,0x90(%rsp)
 150afc7:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
 150afcc:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 150afd4:	eb 1d                	jmp    150aff3 <run_backend_benchmark+0x9883>
 150afd6:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 150afde:	48 ff c2             	inc    %rdx
 150afe1:	48 89 94 24 90 00 00 00 	mov    %rdx,0x90(%rsp)
 150afe9:	48 83 fa 15          	cmp    $0x15,%rdx
 150afed:	0f 84 f0 04 00 00    	je     150b4e3 <run_backend_benchmark+0x9d73>
 150aff3:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
 150aff8:	31 c9                	xor    %ecx,%ecx
 150affa:	e9 99 00 00 00       	jmp    150b098 <run_backend_benchmark+0x9928>
 150afff:	90                   	nop
 150b000:	85 d2                	test   %edx,%edx
 150b002:	0f 84 d7 00 00 00    	je     150b0df <run_backend_benchmark+0x996f>
 150b008:	44 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%r14d
 150b010:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 150b015:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 150b01d:	48 8d 8c 24 c0 01 00 00 	lea    0x1c0(%rsp),%rcx
 150b025:	4c 89 ef             	mov    %r13,%rdi
 150b028:	41 89 d9             	mov    %ebx,%r9d
 150b02b:	44 89 f6             	mov    %r14d,%esi
 150b02e:	c5 f8 77             	vzeroupper
 150b031:	e8 ca 68 00 00       	call   1511900 <tier0_benchmark_run>
 150b036:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 150b041:	44 89 f0             	mov    %r14d,%eax
 150b044:	48 69 c0 a0 02 00 00 	imul   $0x2a0,%rax,%rax
 150b04b:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 150b053:	48 8d 84 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%rax
 150b05b:	c5 f8 13 04 c8       	vmovlps %xmm0,(%rax,%rcx,8)
 150b060:	c5 f8 17 84 c8 a8 00 00 00 	vmovhps %xmm0,0xa8(%rax,%rcx,8)
 150b069:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 150b06f:	c5 f8 13 84 c8 50 01 00 00 	vmovlps %xmm0,0x150(%rax,%rcx,8)
 150b078:	c5 f8 17 84 c8 f8 01 00 00 	vmovhps %xmm0,0x1f8(%rax,%rcx,8)
 150b081:	8b 4c 24 78          	mov    0x78(%rsp),%ecx
 150b085:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 150b08d:	ff c1                	inc    %ecx
 150b08f:	83 f9 04             	cmp    $0x4,%ecx
 150b092:	0f 84 3e ff ff ff    	je     150afd6 <run_backend_benchmark+0x9866>
 150b098:	89 ca                	mov    %ecx,%edx
 150b09a:	83 f2 01             	xor    $0x1,%edx
 150b09d:	f6 84 24 90 00 00 00 01 	testb  $0x1,0x90(%rsp)
 150b0a5:	89 4c 24 78          	mov    %ecx,0x78(%rsp)
 150b0a9:	0f 44 d1             	cmove  %ecx,%edx
 150b0ac:	83 f9 02             	cmp    $0x2,%ecx
 150b0af:	0f 43 d1             	cmovae %ecx,%edx
 150b0b2:	89 94 24 a0 00 00 00 	mov    %edx,0xa0(%rsp)
 150b0b9:	83 f8 04             	cmp    $0x4,%eax
 150b0bc:	0f 84 3e ff ff ff    	je     150b000 <run_backend_benchmark+0x9890>
 150b0c2:	39 c2                	cmp    %eax,%edx
 150b0c4:	0f 84 36 ff ff ff    	je     150b000 <run_backend_benchmark+0x9890>
 150b0ca:	83 f8 03             	cmp    $0x3,%eax
 150b0cd:	75 b2                	jne    150b081 <run_backend_benchmark+0x9911>
 150b0cf:	83 bc 24 a0 00 00 00 02 	cmpl   $0x2,0xa0(%rsp)
 150b0d7:	0f 84 2b ff ff ff    	je     150b008 <run_backend_benchmark+0x9898>
 150b0dd:	eb a2                	jmp    150b081 <run_backend_benchmark+0x9911>
 150b0df:	bf 04 00 00 00       	mov    $0x4,%edi
 150b0e4:	4c 89 ee             	mov    %r13,%rsi
 150b0e7:	c5 f8 77             	vzeroupper
 150b0ea:	e8 c1 89 25 ff       	call   763ab0 <clock_gettime@plt>
 150b0ef:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 150b0fb:	4c 8b b4 24 20 02 00 00 	mov    0x220(%rsp),%r14
 150b103:	bf 04 00 00 00       	mov    $0x4,%edi
 150b108:	4c 89 ee             	mov    %r13,%rsi
 150b10b:	4c 03 74 24 70       	add    0x70(%rsp),%r14
 150b110:	49 01 c6             	add    %rax,%r14
 150b113:	e8 98 89 25 ff       	call   763ab0 <clock_gettime@plt>
 150b118:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 150b124:	4c 89 74 24 60       	mov    %r14,0x60(%rsp)
 150b129:	48 03 84 24 20 02 00 00 	add    0x220(%rsp),%rax
 150b131:	4c 39 f0             	cmp    %r14,%rax
 150b134:	0f 83 ce fe ff ff    	jae    150b008 <run_backend_benchmark+0x9898>
 150b13a:	44 8b bc 24 98 01 00 00 	mov    0x198(%rsp),%r15d
 150b142:	4c 8b b4 24 68 01 00 00 	mov    0x168(%rsp),%r14
 150b14a:	eb 3d                	jmp    150b189 <run_backend_benchmark+0x9a19>
 150b14c:	0f 1f 40 00          	nopl   0x0(%rax)
 150b150:	bf 04 00 00 00       	mov    $0x4,%edi
 150b155:	4c 89 ee             	mov    %r13,%rsi
 150b158:	e8 53 89 25 ff       	call   763ab0 <clock_gettime@plt>
 150b15d:	bf 04 00 00 00       	mov    $0x4,%edi
 150b162:	4c 89 ee             	mov    %r13,%rsi
 150b165:	e8 46 89 25 ff       	call   763ab0 <clock_gettime@plt>
 150b16a:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 150b176:	48 03 84 24 20 02 00 00 	add    0x220(%rsp),%rax
 150b17e:	48 3b 44 24 60       	cmp    0x60(%rsp),%rax
 150b183:	0f 83 7f fe ff ff    	jae    150b008 <run_backend_benchmark+0x9898>
 150b189:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 150b195:	45 85 e4             	test   %r12d,%r12d
 150b198:	78 10                	js     150b1aa <run_backend_benchmark+0x9a3a>
 150b19a:	ba 08 00 00 00       	mov    $0x8,%edx
 150b19f:	44 89 e7             	mov    %r12d,%edi
 150b1a2:	4c 89 ee             	mov    %r13,%rsi
 150b1a5:	e8 c6 8c 25 ff       	call   763e70 <read@plt>
 150b1aa:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 150b1b0:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 150b1bc:	78 15                	js     150b1d3 <run_backend_benchmark+0x9a63>
 150b1be:	ba 08 00 00 00       	mov    $0x8,%edx
 150b1c3:	48 8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%rdi
 150b1cb:	4c 89 ee             	mov    %r13,%rsi
 150b1ce:	e8 9d 8c 25 ff       	call   763e70 <read@plt>
 150b1d3:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 150b1df:	85 db                	test   %ebx,%ebx
 150b1e1:	78 0f                	js     150b1f2 <run_backend_benchmark+0x9a82>
 150b1e3:	ba 08 00 00 00       	mov    $0x8,%edx
 150b1e8:	89 df                	mov    %ebx,%edi
 150b1ea:	4c 89 ee             	mov    %r13,%rsi
 150b1ed:	e8 7e 8c 25 ff       	call   763e70 <read@plt>
 150b1f2:	bf 04 00 00 00       	mov    $0x4,%edi
 150b1f7:	4c 89 ee             	mov    %r13,%rsi
 150b1fa:	e8 b1 88 25 ff       	call   763ab0 <clock_gettime@plt>
 150b1ff:	4d 85 ff             	test   %r15,%r15
 150b202:	74 3e                	je     150b242 <run_backend_benchmark+0x9ad2>
 150b204:	4c 8b a4 24 c8 01 00 00 	mov    0x1c8(%rsp),%r12
 150b20c:	31 db                	xor    %ebx,%ebx
 150b20e:	66 90                	xchg   %ax,%ax
 150b210:	49 8b 34 de          	mov    (%r14,%rbx,8),%rsi
 150b214:	48 8d 94 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdx
 150b21c:	4c 89 ef             	mov    %r13,%rdi
 150b21f:	e8 0c 80 01 00       	call   1523230 <tier0_compile_scalar>
 150b224:	4c 3b a4 24 c8 01 00 00 	cmp    0x1c8(%rsp),%r12
 150b22c:	0f 87 e7 06 00 00    	ja     150b919 <run_backend_benchmark+0xa1a9>
 150b232:	48 ff c3             	inc    %rbx
 150b235:	4c 89 a4 24 c8 01 00 00 	mov    %r12,0x1c8(%rsp)
 150b23d:	49 39 df             	cmp    %rbx,%r15
 150b240:	75 ce                	jne    150b210 <run_backend_benchmark+0x9aa0>
 150b242:	4c 8b a4 24 80 00 00 00 	mov    0x80(%rsp),%r12
 150b24a:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 150b256:	45 85 e4             	test   %r12d,%r12d
 150b259:	78 10                	js     150b26b <run_backend_benchmark+0x9afb>
 150b25b:	ba 08 00 00 00       	mov    $0x8,%edx
 150b260:	44 89 e7             	mov    %r12d,%edi
 150b263:	4c 89 ee             	mov    %r13,%rsi
 150b266:	e8 05 8c 25 ff       	call   763e70 <read@plt>
 150b26b:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 150b271:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
 150b276:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 150b282:	78 15                	js     150b299 <run_backend_benchmark+0x9b29>
 150b284:	ba 08 00 00 00       	mov    $0x8,%edx
 150b289:	48 8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%rdi
 150b291:	4c 89 ee             	mov    %r13,%rsi
 150b294:	e8 d7 8b 25 ff       	call   763e70 <read@plt>
 150b299:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 150b2a5:	85 db                	test   %ebx,%ebx
 150b2a7:	0f 88 a3 fe ff ff    	js     150b150 <run_backend_benchmark+0x99e0>
 150b2ad:	ba 08 00 00 00       	mov    $0x8,%edx
 150b2b2:	89 df                	mov    %ebx,%edi
 150b2b4:	4c 89 ee             	mov    %r13,%rsi
 150b2b7:	e8 b4 8b 25 ff       	call   763e70 <read@plt>
 150b2bc:	e9 8f fe ff ff       	jmp    150b150 <run_backend_benchmark+0x99e0>
 150b2c1:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 150b2c9:	41 b5 01             	mov    $0x1,%r13b
 150b2cc:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 150b2d4:	31 db                	xor    %ebx,%ebx
 150b2d6:	44 8d 70 fe          	lea    -0x2(%rax),%r14d
 150b2da:	8d 48 fd             	lea    -0x3(%rax),%ecx
 150b2dd:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
 150b2e1:	eb 11                	jmp    150b2f4 <run_backend_benchmark+0x9b84>
 150b2e3:	48 ff c3             	inc    %rbx
 150b2e6:	41 80 f5 01          	xor    $0x1,%r13b
 150b2ea:	48 83 fb 15          	cmp    $0x15,%rbx
 150b2ee:	0f 84 ef 01 00 00    	je     150b4e3 <run_backend_benchmark+0x9d73>
 150b2f4:	89 de                	mov    %ebx,%esi
 150b2f6:	83 e6 01             	and    $0x1,%esi
 150b2f9:	83 f8 04             	cmp    $0x4,%eax
 150b2fc:	74 04                	je     150b302 <run_backend_benchmark+0x9b92>
 150b2fe:	39 c6                	cmp    %eax,%esi
 150b300:	75 71                	jne    150b373 <run_backend_benchmark+0x9c03>
 150b302:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 150b307:	48 69 c6 a0 02 00 00 	imul   $0x2a0,%rsi,%rax
 150b30e:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 150b316:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 150b31e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 150b323:	4c 89 e1             	mov    %r12,%rcx
 150b326:	4c 8d bc 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%r15
 150b32e:	c5 f8 77             	vzeroupper
 150b331:	e8 ca 65 00 00       	call   1511900 <tier0_benchmark_run>
 150b336:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 150b341:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 150b349:	c4 c1 78 13 04 df    	vmovlps %xmm0,(%r15,%rbx,8)
 150b34f:	c4 c1 78 17 84 df a8 00 00 00 	vmovhps %xmm0,0xa8(%r15,%rbx,8)
 150b359:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 150b35f:	c4 c1 78 13 84 df 50 01 00 00 	vmovlps %xmm0,0x150(%r15,%rbx,8)
 150b369:	c4 c1 78 17 84 df f8 01 00 00 	vmovhps %xmm0,0x1f8(%r15,%rbx,8)
 150b373:	89 de                	mov    %ebx,%esi
 150b375:	f7 d6                	not    %esi
 150b377:	83 e6 01             	and    $0x1,%esi
 150b37a:	83 f8 04             	cmp    $0x4,%eax
 150b37d:	74 04                	je     150b383 <run_backend_benchmark+0x9c13>
 150b37f:	39 c6                	cmp    %eax,%esi
 150b381:	75 78                	jne    150b3fb <run_backend_benchmark+0x9c8b>
 150b383:	41 0f b6 c5          	movzbl %r13b,%eax
 150b387:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 150b38c:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 150b394:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 150b39c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 150b3a1:	4c 89 e1             	mov    %r12,%rcx
 150b3a4:	83 e0 01             	and    $0x1,%eax
 150b3a7:	48 69 c0 a0 02 00 00 	imul   $0x2a0,%rax,%rax
 150b3ae:	4c 8d bc 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%r15
 150b3b6:	c5 f8 77             	vzeroupper
 150b3b9:	e8 42 65 00 00       	call   1511900 <tier0_benchmark_run>
 150b3be:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 150b3c9:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 150b3d1:	c4 c1 78 13 04 df    	vmovlps %xmm0,(%r15,%rbx,8)
 150b3d7:	c4 c1 78 17 84 df a8 00 00 00 	vmovhps %xmm0,0xa8(%r15,%rbx,8)
 150b3e1:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 150b3e7:	c4 c1 78 13 84 df 50 01 00 00 	vmovlps %xmm0,0x150(%r15,%rbx,8)
 150b3f1:	c4 c1 78 17 84 df f8 01 00 00 	vmovhps %xmm0,0x1f8(%r15,%rbx,8)
 150b3fb:	41 83 fe 02          	cmp    $0x2,%r14d
 150b3ff:	0f 87 de fe ff ff    	ja     150b2e3 <run_backend_benchmark+0x9b73>
 150b405:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 150b40a:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 150b412:	be 02 00 00 00       	mov    $0x2,%esi
 150b417:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 150b41f:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 150b424:	4c 89 e1             	mov    %r12,%rcx
 150b427:	c5 f8 77             	vzeroupper
 150b42a:	e8 d1 64 00 00       	call   1511900 <tier0_benchmark_run>
 150b42f:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 150b43a:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 150b442:	83 7c 24 40 01       	cmpl   $0x1,0x40(%rsp)
 150b447:	c5 f8 13 84 dc c0 07 00 00 	vmovlps %xmm0,0x7c0(%rsp,%rbx,8)
 150b450:	c5 f8 17 84 dc 68 08 00 00 	vmovhps %xmm0,0x868(%rsp,%rbx,8)
 150b459:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 150b45f:	c5 f8 13 84 dc 10 09 00 00 	vmovlps %xmm0,0x910(%rsp,%rbx,8)
 150b468:	c5 f8 17 84 dc b8 09 00 00 	vmovhps %xmm0,0x9b8(%rsp,%rbx,8)
 150b471:	0f 87 6c fe ff ff    	ja     150b2e3 <run_backend_benchmark+0x9b73>
 150b477:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 150b47c:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 150b484:	be 03 00 00 00       	mov    $0x3,%esi
 150b489:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 150b491:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 150b496:	4c 89 e1             	mov    %r12,%rcx
 150b499:	c5 f8 77             	vzeroupper
 150b49c:	e8 5f 64 00 00       	call   1511900 <tier0_benchmark_run>
 150b4a1:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 150b4ac:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 150b4b4:	c5 f8 13 84 dc 60 0a 00 00 	vmovlps %xmm0,0xa60(%rsp,%rbx,8)
 150b4bd:	c5 f8 17 84 dc 08 0b 00 00 	vmovhps %xmm0,0xb08(%rsp,%rbx,8)
 150b4c6:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 150b4cc:	c5 f8 13 84 dc b0 0b 00 00 	vmovlps %xmm0,0xbb0(%rsp,%rbx,8)
 150b4d5:	c5 f8 17 84 dc 58 0c 00 00 	vmovhps %xmm0,0xc58(%rsp,%rbx,8)
 150b4de:	e9 00 fe ff ff       	jmp    150b2e3 <run_backend_benchmark+0x9b73>
 150b4e3:	62 f1 fe 08 7a 54 24 1a 	vcvtuqq2pd 0x1a0(%rsp),%xmm2
 150b4eb:	4c 8b 8c 24 b0 01 00 00 	mov    0x1b0(%rsp),%r9
 150b4f3:	8b b4 24 98 01 00 00 	mov    0x198(%rsp),%esi
 150b4fa:	48 8b 8c 24 a8 01 00 00 	mov    0x1a8(%rsp),%rcx
 150b502:	48 8b 94 24 a0 01 00 00 	mov    0x1a0(%rsp),%rdx
 150b50a:	4c 8b 84 24 b8 01 00 00 	mov    0x1b8(%rsp),%r8
 150b512:	48 89 c3             	mov    %rax,%rbx
 150b515:	48 8d 3d c0 64 1f ff 	lea    -0xe09b40(%rip),%rdi        # 7019dc <pp_decode_file_name.meaning+0x2d7e6>
 150b51c:	b0 02                	mov    $0x2,%al
 150b51e:	c5 e9 c6 c2 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm0
 150b523:	c5 f9 29 54 24 40    	vmovapd %xmm2,0x40(%rsp)
 150b529:	c5 f9 29 84 24 b0 00 00 00 	vmovapd %xmm0,0xb0(%rsp)
 150b532:	c5 fb 5e c2          	vdivsd %xmm2,%xmm0,%xmm0
 150b536:	62 d1 87 08 7b c9    	vcvtusi2sd %r9,%xmm15,%xmm1
 150b53c:	c5 f3 59 0d 9c 4b 07 ff 	vmulsd -0xf8b464(%rip),%xmm1,%xmm1        # 5800e0 <x86_semantics_benchmark_code.registers+0xf0>
 150b544:	c5 f3 5e ca          	vdivsd %xmm2,%xmm1,%xmm1
 150b548:	c5 f8 77             	vzeroupper
 150b54b:	e8 60 8e 25 ff       	call   7643b0 <printf@plt>
 150b550:	48 8d 05 66 ce 11 ff 	lea    -0xee319a(%rip),%rax        # 6283bd <fuzz_comment_end+0x14b6e>
 150b557:	48 8d 3d 02 47 1c ff 	lea    -0xe3b8fe(%rip),%rdi        # 6cfc60 <pp_string_value.meaning+0x72a14>
 150b55e:	48 8d 35 9e e8 1d ff 	lea    -0xe21762(%rip),%rsi        # 6e9e03 <pp_decode_file_name.meaning+0x15c0d>
 150b565:	48 8d 15 92 be 17 ff 	lea    -0xe8416e(%rip),%rdx        # 6873fe <pp_string_value.meaning+0x2a1b2>
 150b56c:	48 8d 0d a8 d8 14 ff 	lea    -0xeb2758(%rip),%rcx        # 658e1b <fuzz_comment_end+0x455cc>
 150b573:	4c 8d 05 de 64 1f ff 	lea    -0xe09b22(%rip),%r8        # 701a58 <pp_decode_file_name.meaning+0x2d862>
 150b57a:	4c 8d 0d 9f e4 1a ff 	lea    -0xe51b61(%rip),%r9        # 6b9a20 <pp_string_value.meaning+0x5c7d4>
 150b581:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
 150b586:	48 8d 05 93 67 0d ff 	lea    -0xf2986d(%rip),%rax        # 5e1d20 <foreign_touch.flags+0xe7f3>
 150b58d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 150b592:	48 8d 05 7c 67 0d ff 	lea    -0xf29884(%rip),%rax        # 5e1d15 <foreign_touch.flags+0xe7e8>
 150b599:	48 89 04 24          	mov    %rax,(%rsp)
 150b59d:	31 c0                	xor    %eax,%eax
 150b59f:	e8 0c 8e 25 ff       	call   7643b0 <printf@plt>
 150b5a4:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 150b5a9:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 150b5b1:	83 fb 04             	cmp    $0x4,%ebx
 150b5b4:	0f 87 8f 02 00 00    	ja     150b849 <run_backend_benchmark+0xa0d9>
 150b5ba:	c5 fb 12 44 24 40    	vmovddup 0x40(%rsp),%xmm0
 150b5c0:	48 8d 0d fd 4f 01 ff 	lea    -0xfeb003(%rip),%rcx        # 5205c4 <branch_sizing_patterns+0x834>
 150b5c7:	89 d8                	mov    %ebx,%eax
 150b5c9:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
 150b5cd:	48 01 c8             	add    %rcx,%rax
 150b5d0:	c5 f9 29 44 24 60    	vmovapd %xmm0,0x60(%rsp)
 150b5d6:	ff e0                	jmp    *%rax
 150b5d8:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 150b5e0:	e8 ab 80 00 00       	call   1513690 <tier0_benchmark_median>
 150b5e5:	48 8d bc 24 28 03 00 00 	lea    0x328(%rsp),%rdi
 150b5ed:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 150b5f3:	e8 98 80 00 00       	call   1513690 <tier0_benchmark_median>
 150b5f8:	48 8d bc 24 d0 03 00 00 	lea    0x3d0(%rsp),%rdi
 150b600:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 150b609:	e8 82 80 00 00       	call   1513690 <tier0_benchmark_median>
 150b60e:	48 8d bc 24 78 04 00 00 	lea    0x478(%rsp),%rdi
 150b616:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 150b61f:	e8 6c 80 00 00       	call   1513690 <tier0_benchmark_median>
 150b624:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 150b62d:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 150b636:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 150b63c:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 150b645:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 150b649:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 150b64d:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 150b651:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 150b655:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 150b65b:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 150b661:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 150b665:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 150b669:	75 02                	jne    150b66d <run_backend_benchmark+0x9efd>
 150b66b:	7b 04                	jnp    150b671 <run_backend_benchmark+0x9f01>
 150b66d:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 150b671:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 150b675:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 150b67a:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 150b67f:	48 8d 3d 9e 66 0d ff 	lea    -0xf29962(%rip),%rdi        # 5e1d24 <foreign_touch.flags+0xe7f7>
 150b686:	48 8d 35 20 a7 0d ff 	lea    -0xf258e0(%rip),%rsi        # 5e5dad <foreign_touch.flags+0x12880>
 150b68d:	b0 07                	mov    $0x7,%al
 150b68f:	e8 1c 8d 25 ff       	call   7643b0 <printf@plt>
 150b694:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 150b69c:	83 fb 04             	cmp    $0x4,%ebx
 150b69f:	74 12                	je     150b6b3 <run_backend_benchmark+0x9f43>
 150b6a1:	83 fb 02             	cmp    $0x2,%ebx
 150b6a4:	0f 84 db 00 00 00    	je     150b785 <run_backend_benchmark+0xa015>
 150b6aa:	83 fb 01             	cmp    $0x1,%ebx
 150b6ad:	0f 85 96 01 00 00    	jne    150b849 <run_backend_benchmark+0xa0d9>
 150b6b3:	48 8d bc 24 20 05 00 00 	lea    0x520(%rsp),%rdi
 150b6bb:	e8 d0 7f 00 00       	call   1513690 <tier0_benchmark_median>
 150b6c0:	48 8d bc 24 c8 05 00 00 	lea    0x5c8(%rsp),%rdi
 150b6c8:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 150b6ce:	e8 bd 7f 00 00       	call   1513690 <tier0_benchmark_median>
 150b6d3:	48 8d bc 24 70 06 00 00 	lea    0x670(%rsp),%rdi
 150b6db:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 150b6e4:	e8 a7 7f 00 00       	call   1513690 <tier0_benchmark_median>
 150b6e9:	48 8d bc 24 18 07 00 00 	lea    0x718(%rsp),%rdi
 150b6f1:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 150b6fa:	e8 91 7f 00 00       	call   1513690 <tier0_benchmark_median>
 150b6ff:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 150b708:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 150b711:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 150b717:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 150b720:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 150b724:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 150b728:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 150b72c:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 150b730:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 150b736:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 150b73c:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 150b740:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 150b744:	75 02                	jne    150b748 <run_backend_benchmark+0x9fd8>
 150b746:	7b 04                	jnp    150b74c <run_backend_benchmark+0x9fdc>
 150b748:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 150b74c:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 150b750:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 150b755:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 150b75a:	48 8d 3d c3 65 0d ff 	lea    -0xf29a3d(%rip),%rdi        # 5e1d24 <foreign_touch.flags+0xe7f7>
 150b761:	48 8d 35 8e 69 0d ff 	lea    -0xf29672(%rip),%rsi        # 5e20f6 <foreign_touch.flags+0xebc9>
 150b768:	b0 07                	mov    $0x7,%al
 150b76a:	e8 41 8c 25 ff       	call   7643b0 <printf@plt>
 150b76f:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 150b777:	83 fb 04             	cmp    $0x4,%ebx
 150b77a:	74 09                	je     150b785 <run_backend_benchmark+0xa015>
 150b77c:	83 fb 02             	cmp    $0x2,%ebx
 150b77f:	0f 85 c4 00 00 00    	jne    150b849 <run_backend_benchmark+0xa0d9>
 150b785:	48 8d bc 24 c0 07 00 00 	lea    0x7c0(%rsp),%rdi
 150b78d:	e8 fe 7e 00 00       	call   1513690 <tier0_benchmark_median>
 150b792:	48 8d bc 24 68 08 00 00 	lea    0x868(%rsp),%rdi
 150b79a:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 150b7a0:	e8 eb 7e 00 00       	call   1513690 <tier0_benchmark_median>
 150b7a5:	48 8d bc 24 10 09 00 00 	lea    0x910(%rsp),%rdi
 150b7ad:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 150b7b6:	e8 d5 7e 00 00       	call   1513690 <tier0_benchmark_median>
 150b7bb:	48 8d bc 24 b8 09 00 00 	lea    0x9b8(%rsp),%rdi
 150b7c3:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 150b7cc:	e8 bf 7e 00 00       	call   1513690 <tier0_benchmark_median>
 150b7d1:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 150b7da:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 150b7e3:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 150b7e9:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 150b7f2:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 150b7f6:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 150b7fa:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 150b7fe:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 150b802:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 150b808:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 150b80e:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 150b812:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 150b816:	75 02                	jne    150b81a <run_backend_benchmark+0xa0aa>
 150b818:	7b 04                	jnp    150b81e <run_backend_benchmark+0xa0ae>
 150b81a:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 150b81e:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 150b822:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 150b827:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 150b82c:	48 8d 3d f1 64 0d ff 	lea    -0xf29b0f(%rip),%rdi        # 5e1d24 <foreign_touch.flags+0xe7f7>
 150b833:	48 8d 35 8e cb 11 ff 	lea    -0xee3472(%rip),%rsi        # 6283c8 <fuzz_comment_end+0x14b79>
 150b83a:	b0 07                	mov    $0x7,%al
 150b83c:	e8 6f 8b 25 ff       	call   7643b0 <printf@plt>
 150b841:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 150b849:	83 c3 fd             	add    $0xfffffffd,%ebx
 150b84c:	83 fb 01             	cmp    $0x1,%ebx
 150b84f:	0f 87 b3 00 00 00    	ja     150b908 <run_backend_benchmark+0xa198>
 150b855:	48 8d bc 24 60 0a 00 00 	lea    0xa60(%rsp),%rdi
 150b85d:	e8 2e 7e 00 00       	call   1513690 <tier0_benchmark_median>
 150b862:	48 8d bc 24 08 0b 00 00 	lea    0xb08(%rsp),%rdi
 150b86a:	c5 f9 29 44 24 60    	vmovapd %xmm0,0x60(%rsp)
 150b870:	e8 1b 7e 00 00       	call   1513690 <tier0_benchmark_median>
 150b875:	48 8d bc 24 b0 0b 00 00 	lea    0xbb0(%rsp),%rdi
 150b87d:	c5 fb 11 44 24 30    	vmovsd %xmm0,0x30(%rsp)
 150b883:	e8 08 7e 00 00       	call   1513690 <tier0_benchmark_median>
 150b888:	48 8d bc 24 58 0c 00 00 	lea    0xc58(%rsp),%rdi
 150b890:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 150b899:	e8 f2 7d 00 00       	call   1513690 <tier0_benchmark_median>
 150b89e:	c5 79 28 84 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm8
 150b8a7:	c5 f9 28 64 24 40    	vmovapd 0x40(%rsp),%xmm4
 150b8ad:	c5 f9 28 54 24 60    	vmovapd 0x60(%rsp),%xmm2
 150b8b3:	c5 fb 10 7c 24 30    	vmovsd 0x30(%rsp),%xmm7
 150b8b9:	c5 f9 28 b4 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm6
 150b8c2:	c5 f9 28 d8          	vmovapd %xmm0,%xmm3
 150b8c6:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 150b8ca:	c5 eb 5e c4          	vdivsd %xmm4,%xmm2,%xmm0
 150b8ce:	c5 b9 14 d2          	vunpcklpd %xmm2,%xmm8,%xmm2
 150b8d2:	c5 c3 5e cc          	vdivsd %xmm4,%xmm7,%xmm1
 150b8d6:	c5 f9 2e fd          	vucomisd %xmm5,%xmm7
 150b8da:	c5 e9 5e d4          	vdivpd %xmm4,%xmm2,%xmm2
 150b8de:	c5 c3 5e e6          	vdivsd %xmm6,%xmm7,%xmm4
 150b8e2:	75 02                	jne    150b8e6 <run_backend_benchmark+0xa176>
 150b8e4:	7b 04                	jnp    150b8ea <run_backend_benchmark+0xa17a>
 150b8e6:	c5 bb 5e ef          	vdivsd %xmm7,%xmm8,%xmm5
 150b8ea:	c5 e3 5e f6          	vdivsd %xmm6,%xmm3,%xmm6
 150b8ee:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 150b8f3:	48 8d 3d 2a 64 0d ff 	lea    -0xf29bd6(%rip),%rdi        # 5e1d24 <foreign_touch.flags+0xe7f7>
 150b8fa:	48 8d 35 01 be 14 ff 	lea    -0xeb41ff(%rip),%rsi        # 657702 <fuzz_comment_end+0x43eb3>
 150b901:	b0 07                	mov    $0x7,%al
 150b903:	e8 a8 8a 25 ff       	call   7643b0 <printf@plt>
 150b908:	45 31 e4             	xor    %r12d,%r12d
 150b90b:	4d 85 ed             	test   %r13,%r13
 150b90e:	0f 85 bc f2 ff ff    	jne    150abd0 <run_backend_benchmark+0x9460>
 150b914:	e9 de f2 ff ff       	jmp    150abf7 <run_backend_benchmark+0x9487>
 150b919:	48 8d 3d d7 46 1c ff 	lea    -0xe3b929(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 150b920:	48 8d 35 6c be 17 ff 	lea    -0xe84194(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 150b927:	48 8d 0d 80 be 17 ff 	lea    -0xe84180(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 150b92e:	ba bf 00 00 00       	mov    $0xbf,%edx
 150b933:	c5 f8 77             	vzeroupper
 150b936:	e8 15 82 25 ff       	call   763b50 <__assert_fail@plt>
 150b93b:	c5 f8 77             	vzeroupper
 150b93e:	e8 9d 81 25 ff       	call   763ae0 <__stack_chk_fail@plt>
