
/home/david/buster-fast-bench/codex-180-fix-20261027-hybrid/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000018a7620 <run_backend_benchmark>:
 18a7620:	55                   	push   %rbp
 18a7621:	48 89 e5             	mov    %rsp,%rbp
 18a7624:	41 57                	push   %r15
 18a7626:	41 56                	push   %r14
 18a7628:	41 55                	push   %r13
 18a762a:	41 54                	push   %r12
 18a762c:	53                   	push   %rbx
 18a762d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 18a7631:	48 81 ec c0 2c 00 00 	sub    $0x2cc0,%rsp
 18a7638:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18a7641:	48 89 84 24 80 2c 00 00 	mov    %rax,0x2c80(%rsp)
 18a7649:	83 ff 02             	cmp    $0x2,%edi
 18a764c:	0f 8c dc 01 00 00    	jl     18a782e <run_backend_benchmark+0x20e>
 18a7652:	b8 04 00 00 00       	mov    $0x4,%eax
 18a7657:	41 bc 03 00 00 00    	mov    $0x3,%r12d
 18a765d:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18a7663:	48 89 f3             	mov    %rsi,%rbx
 18a7666:	41 89 fe             	mov    %edi,%r14d
 18a7669:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 18a7675:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 18a767a:	48 89 84 24 c8 00 00 00 	mov    %rax,0xc8(%rsp)
 18a7682:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7687:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18a768f:	b8 00 00 04 00       	mov    $0x40000,%eax
 18a7694:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18a769c:	0f 1f 40 00          	nopl   0x0(%rax)
 18a76a0:	41 8d 44 24 fe       	lea    -0x2(%r12),%eax
 18a76a5:	48 8d 35 8c 0c d8 fe 	lea    -0x127f374(%rip),%rsi        # 628338 <fuzz_comment_end+0x14ae9>
 18a76ac:	48 98                	cltq
 18a76ae:	4c 8b 2c c3          	mov    (%rbx,%rax,8),%r13
 18a76b2:	4c 89 ef             	mov    %r13,%rdi
 18a76b5:	e8 e6 cd eb fe       	call   7644a0 <strcmp@plt>
 18a76ba:	85 c0                	test   %eax,%eax
 18a76bc:	75 32                	jne    18a76f0 <run_backend_benchmark+0xd0>
 18a76be:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 18a76c3:	44 39 f0             	cmp    %r14d,%eax
 18a76c6:	7d 28                	jge    18a76f0 <run_backend_benchmark+0xd0>
 18a76c8:	48 98                	cltq
 18a76ca:	41 ff c7             	inc    %r15d
 18a76cd:	31 f6                	xor    %esi,%esi
 18a76cf:	31 d2                	xor    %edx,%edx
 18a76d1:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 18a76d5:	e8 86 c4 eb fe       	call   763b60 <strtoull@plt>
 18a76da:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18a76e2:	b0 01                	mov    $0x1,%al
 18a76e4:	e9 2a 01 00 00       	jmp    18a7813 <run_backend_benchmark+0x1f3>
 18a76e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18a76f0:	48 8d 35 06 aa d3 fe 	lea    -0x12c55fa(%rip),%rsi        # 5e20fd <foreign_touch.flags+0xebd0>
 18a76f7:	4c 89 ef             	mov    %r13,%rdi
 18a76fa:	e8 a1 cd eb fe       	call   7644a0 <strcmp@plt>
 18a76ff:	85 c0                	test   %eax,%eax
 18a7701:	75 2d                	jne    18a7730 <run_backend_benchmark+0x110>
 18a7703:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 18a7708:	44 39 f0             	cmp    %r14d,%eax
 18a770b:	7d 23                	jge    18a7730 <run_backend_benchmark+0x110>
 18a770d:	48 98                	cltq
 18a770f:	41 ff c7             	inc    %r15d
 18a7712:	31 f6                	xor    %esi,%esi
 18a7714:	31 d2                	xor    %edx,%edx
 18a7716:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 18a771a:	e8 41 c4 eb fe       	call   763b60 <strtoull@plt>
 18a771f:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18a7727:	b0 01                	mov    $0x1,%al
 18a7729:	e9 e5 00 00 00       	jmp    18a7813 <run_backend_benchmark+0x1f3>
 18a772e:	66 90                	xchg   %ax,%ax
 18a7730:	48 8d 35 03 00 d2 fe 	lea    -0x12dfffd(%rip),%rsi        # 5c773a <parse_test_openers+0x3c581>
 18a7737:	4c 89 ef             	mov    %r13,%rdi
 18a773a:	e8 61 cd eb fe       	call   7644a0 <strcmp@plt>
 18a773f:	85 c0                	test   %eax,%eax
 18a7741:	75 2d                	jne    18a7770 <run_backend_benchmark+0x150>
 18a7743:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 18a7748:	44 39 f0             	cmp    %r14d,%eax
 18a774b:	7d 23                	jge    18a7770 <run_backend_benchmark+0x150>
 18a774d:	48 98                	cltq
 18a774f:	41 ff c7             	inc    %r15d
 18a7752:	31 f6                	xor    %esi,%esi
 18a7754:	31 d2                	xor    %edx,%edx
 18a7756:	48 8b 3c c3          	mov    (%rbx,%rax,8),%rdi
 18a775a:	e8 01 c4 eb fe       	call   763b60 <strtoull@plt>
 18a775f:	48 89 84 24 18 01 00 00 	mov    %rax,0x118(%rsp)
 18a7767:	b0 01                	mov    $0x1,%al
 18a7769:	e9 a5 00 00 00       	jmp    18a7813 <run_backend_benchmark+0x1f3>
 18a776e:	66 90                	xchg   %ax,%ax
 18a7770:	48 8d 35 21 26 d5 fe 	lea    -0x12ad9df(%rip),%rsi        # 5f9d98 <foreign_touch.flags+0x2686b>
 18a7777:	4c 89 ef             	mov    %r13,%rdi
 18a777a:	e8 21 cd eb fe       	call   7644a0 <strcmp@plt>
 18a777f:	85 c0                	test   %eax,%eax
 18a7781:	0f 85 de 00 00 00    	jne    18a7865 <run_backend_benchmark+0x245>
 18a7787:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
 18a778c:	44 39 f0             	cmp    %r14d,%eax
 18a778f:	0f 8d d0 00 00 00    	jge    18a7865 <run_backend_benchmark+0x245>
 18a7795:	48 98                	cltq
 18a7797:	48 8d 35 0f e6 d3 fe 	lea    -0x12c19f1(%rip),%rsi        # 5e5dad <foreign_touch.flags+0x12880>
 18a779e:	41 ff c7             	inc    %r15d
 18a77a1:	4c 8b 2c c3          	mov    (%rbx,%rax,8),%r13
 18a77a5:	4c 89 ef             	mov    %r13,%rdi
 18a77a8:	e8 f3 cc eb fe       	call   7644a0 <strcmp@plt>
 18a77ad:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 18a77b5:	85 c0                	test   %eax,%eax
 18a77b7:	48 8d 35 38 a9 d3 fe 	lea    -0x12c56c8(%rip),%rsi        # 5e20f6 <foreign_touch.flags+0xebc9>
 18a77be:	4c 89 ef             	mov    %r13,%rdi
 18a77c1:	0f 44 d8             	cmove  %eax,%ebx
 18a77c4:	e8 d7 cc eb fe       	call   7644a0 <strcmp@plt>
 18a77c9:	85 c0                	test   %eax,%eax
 18a77cb:	b8 01 00 00 00       	mov    $0x1,%eax
 18a77d0:	48 8d 35 f1 0b d8 fe 	lea    -0x127f40f(%rip),%rsi        # 6283c8 <fuzz_comment_end+0x14b79>
 18a77d7:	4c 89 ef             	mov    %r13,%rdi
 18a77da:	0f 44 d8             	cmove  %eax,%ebx
 18a77dd:	e8 be cc eb fe       	call   7644a0 <strcmp@plt>
 18a77e2:	85 c0                	test   %eax,%eax
 18a77e4:	b8 02 00 00 00       	mov    $0x2,%eax
 18a77e9:	48 8d 35 12 ff da fe 	lea    -0x12500ee(%rip),%rsi        # 657702 <fuzz_comment_end+0x43eb3>
 18a77f0:	4c 89 ef             	mov    %r13,%rdi
 18a77f3:	0f 44 d8             	cmove  %eax,%ebx
 18a77f6:	e8 a5 cc eb fe       	call   7644a0 <strcmp@plt>
 18a77fb:	85 c0                	test   %eax,%eax
 18a77fd:	b9 03 00 00 00       	mov    $0x3,%ecx
 18a7802:	0f 44 d9             	cmove  %ecx,%ebx
 18a7805:	83 fb 04             	cmp    $0x4,%ebx
 18a7808:	48 89 9c 24 c8 00 00 00 	mov    %rbx,0xc8(%rsp)
 18a7810:	0f 95 c0             	setne  %al
 18a7813:	45 39 f4             	cmp    %r14d,%r12d
 18a7816:	7d 4f                	jge    18a7867 <run_backend_benchmark+0x247>
 18a7818:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
 18a781d:	41 ff c7             	inc    %r15d
 18a7820:	41 83 c4 02          	add    $0x2,%r12d
 18a7824:	84 c0                	test   %al,%al
 18a7826:	0f 85 74 fe ff ff    	jne    18a76a0 <run_backend_benchmark+0x80>
 18a782c:	eb 39                	jmp    18a7867 <run_backend_benchmark+0x247>
 18a782e:	b8 00 00 04 00       	mov    $0x40000,%eax
 18a7833:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 18a783f:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18a7847:	b8 01 00 00 00       	mov    $0x1,%eax
 18a784c:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18a7854:	b8 04 00 00 00       	mov    $0x4,%eax
 18a7859:	48 89 84 24 c8 00 00 00 	mov    %rax,0xc8(%rsp)
 18a7861:	31 c0                	xor    %eax,%eax
 18a7863:	eb 04                	jmp    18a7869 <run_backend_benchmark+0x249>
 18a7865:	31 c0                	xor    %eax,%eax
 18a7867:	34 01                	xor    $0x1,%al
 18a7869:	84 c0                	test   %al,%al
 18a786b:	0f 85 5c 90 00 00    	jne    18b08cd <run_backend_benchmark+0x92ad>
 18a7871:	48 83 bc 24 20 01 00 00 00 	cmpq   $0x0,0x120(%rsp)
 18a787a:	0f 84 4d 90 00 00    	je     18b08cd <run_backend_benchmark+0x92ad>
 18a7880:	48 81 bc 24 18 01 00 00 10 27 00 00 	cmpq   $0x2710,0x118(%rsp)
 18a788c:	0f 87 3b 90 00 00    	ja     18b08cd <run_backend_benchmark+0x92ad>
 18a7892:	48 8d 35 c7 66 7a 00 	lea    0x7a66c7(%rip),%rsi        # 204df60 <x86_form_descriptions>
 18a7899:	48 8d 15 20 eb db 0c 	lea    0xcdbeb20(%rip),%rdx        # e6663c0 <x86_template_storage+0x40>
 18a78a0:	31 ff                	xor    %edi,%edi
 18a78a2:	48 c7 84 24 c0 00 00 00 00 00 00 00 	movq   $0x0,0xc0(%rsp)
 18a78ae:	e8 3d fb ff ff       	call   18a73f0 <x86_build_nonlegacy_templates>
 18a78b3:	84 c0                	test   %al,%al
 18a78b5:	0f 84 8b 90 00 00    	je     18b0946 <run_backend_benchmark+0x9326>
 18a78bb:	48 8d 1d 3e 63 14 0d 	lea    0xd14633e(%rip),%rbx        # e9edc00 <x86_effects_index>
 18a78c2:	ba 40 41 00 00       	mov    $0x4140,%edx
 18a78c7:	31 f6                	xor    %esi,%esi
 18a78c9:	48 89 df             	mov    %rbx,%rdi
 18a78cc:	e8 5f ca eb fe       	call   764330 <memset@plt>
 18a78d1:	c5 fa 6f 05 97 eb cc fe 	vmovdqu -0x1331469(%rip),%xmm0        # 576470 <x86_effects_unknown>
 18a78d9:	41 bd 01 00 00 00    	mov    $0x1,%r13d
 18a78df:	4c 8d 1d da ae c7 fe 	lea    -0x1385126(%rip),%r11        # 5227c0 <x86_effects_rows>
 18a78e6:	66 b9 01 00          	mov    $0x1,%cx
 18a78ea:	66 b8 13 00          	mov    $0x13,%ax
 18a78ee:	4c 8d 0d 6b 8c c7 fe 	lea    -0x1387395(%rip),%r9        # 520560 <branch_sizing_patterns+0x7d0>
 18a78f5:	4c 8d 3d 3c 8c c7 fe 	lea    -0x13873c4(%rip),%r15        # 520538 <branch_sizing_patterns+0x7a8>
 18a78fc:	4c 8d 25 21 8c c7 fe 	lea    -0x13873df(%rip),%r12        # 520524 <branch_sizing_patterns+0x794>
 18a7903:	c5 f9 7f 05 35 a4 14 0d 	vmovdqa %xmm0,0xd14a435(%rip)        # e9f1d40 <x86_effects_records>
 18a790b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18a7910:	0f b7 c0             	movzwl %ax,%eax
 18a7913:	0f b7 f9             	movzwl %cx,%edi
 18a7916:	45 89 ed             	mov    %r13d,%r13d
 18a7919:	4c 89 5c 24 58       	mov    %r11,0x58(%rsp)
 18a791e:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
 18a7923:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a7930:	66 83 3c 7b 00       	cmpw   $0x0,(%rbx,%rdi,2)
 18a7935:	0f 85 e5 0e 00 00    	jne    18a8820 <run_backend_benchmark+0x1200>
 18a793b:	49 81 fd ff 03 00 00 	cmp    $0x3ff,%r13
 18a7942:	0f 87 d8 0e 00 00    	ja     18a8820 <run_backend_benchmark+0x1200>
 18a7948:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
 18a794c:	48 8d 0d 0d 66 7a 00 	lea    0x7a660d(%rip),%rcx        # 204df60 <x86_form_descriptions>
 18a7953:	c7 84 24 00 0d 00 00 00 00 00 00 	movl   $0x0,0xd00(%rsp)
 18a795e:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18a7967:	4c 89 ac 24 80 00 00 00 	mov    %r13,0x80(%rsp)
 18a796f:	48 89 bc 24 a0 00 00 00 	mov    %rdi,0xa0(%rsp)
 18a7977:	0f b6 74 c1 1b       	movzbl 0x1b(%rcx,%rax,8),%esi
 18a797c:	48 8d 14 c1          	lea    (%rcx,%rax,8),%rdx
 18a7980:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 18a7988:	ba 00 00 00 00       	mov    $0x0,%edx
 18a798d:	48 83 fe 0d          	cmp    $0xd,%rsi
 18a7991:	77 19                	ja     18a79ac <run_backend_benchmark+0x38c>
 18a7993:	48 8d 0d 2a 8a c7 fe 	lea    -0x13875d6(%rip),%rcx        # 5203c4 <branch_sizing_patterns+0x634>
 18a799a:	48 8d 1d 6f 8b c7 fe 	lea    -0x1387491(%rip),%rbx        # 520510 <branch_sizing_patterns+0x780>
 18a79a1:	48 63 04 b1          	movslq (%rcx,%rsi,4),%rax
 18a79a5:	48 01 c8             	add    %rcx,%rax
 18a79a8:	ff e0                	jmp    *%rax
 18a79aa:	b2 01                	mov    $0x1,%dl
 18a79ac:	41 0f b7 43 06       	movzwl 0x6(%r11),%eax
 18a79b1:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18a79b6:	45 31 f6             	xor    %r14d,%r14d
 18a79b9:	45 31 d2             	xor    %r10d,%r10d
 18a79bc:	89 44 24 30          	mov    %eax,0x30(%rsp)
 18a79c0:	e9 fe 09 00 00       	jmp    18a83c3 <run_backend_benchmark+0xda3>
 18a79c5:	b0 05                	mov    $0x5,%al
 18a79c7:	eb 02                	jmp    18a79cb <run_backend_benchmark+0x3ab>
 18a79c9:	b0 04                	mov    $0x4,%al
 18a79cb:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a79d0:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18a79d5:	be 02 00 00 00       	mov    $0x2,%esi
 18a79da:	88 84 24 01 0d 00 00 	mov    %al,0xd01(%rsp)
 18a79e1:	31 c0                	xor    %eax,%eax
 18a79e3:	eb 5f                	jmp    18a7a44 <run_backend_benchmark+0x424>
 18a79e5:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 18a79ea:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18a79ef:	45 0f b7 73 06       	movzwl 0x6(%r11),%r14d
 18a79f4:	be 02 00 00 00       	mov    $0x2,%esi
 18a79f9:	c6 84 24 01 0d 00 00 05 	movb   $0x5,0xd01(%rsp)
 18a7a01:	45 31 d2             	xor    %r10d,%r10d
 18a7a04:	8d 41 ff             	lea    -0x1(%rcx),%eax
 18a7a07:	3c 04                	cmp    $0x4,%al
 18a7a09:	73 1f                	jae    18a7a2a <run_backend_benchmark+0x40a>
 18a7a0b:	0f b6 c0             	movzbl %al,%eax
 18a7a0e:	48 8d 15 5f 8c cd fe 	lea    -0x13273a1(%rip),%rdx        # 580674 <tier0_generate_expression.floating_operations+0x8>
 18a7a15:	4c 8d 05 5c 8c cd fe 	lea    -0x13273a4(%rip),%r8        # 580678 <tier0_generate_expression.floating_operations+0xc>
 18a7a1c:	0f b6 14 10          	movzbl (%rax,%rdx,1),%edx
 18a7a20:	42 0f b6 04 00       	movzbl (%rax,%r8,1),%eax
 18a7a25:	09 c7                	or     %eax,%edi
 18a7a27:	41 09 d6             	or     %edx,%r14d
 18a7a2a:	44 89 74 24 30       	mov    %r14d,0x30(%rsp)
 18a7a2f:	45 31 f6             	xor    %r14d,%r14d
 18a7a32:	0f b6 c1             	movzbl %cl,%eax
 18a7a35:	8d 48 ff             	lea    -0x1(%rax),%ecx
 18a7a38:	83 f9 03             	cmp    $0x3,%ecx
 18a7a3b:	72 5e                	jb     18a7a9b <run_backend_benchmark+0x47b>
 18a7a3d:	e9 b4 04 00 00       	jmp    18a7ef6 <run_backend_benchmark+0x8d6>
 18a7a42:	b0 01                	mov    $0x1,%al
 18a7a44:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 18a7a49:	41 be 00 00 00 00    	mov    $0x0,%r14d
 18a7a4f:	45 31 d2             	xor    %r10d,%r10d
 18a7a52:	8d 51 ff             	lea    -0x1(%rcx),%edx
 18a7a55:	80 fa 04             	cmp    $0x4,%dl
 18a7a58:	73 0f                	jae    18a7a69 <run_backend_benchmark+0x449>
 18a7a5a:	0f b6 d2             	movzbl %dl,%edx
 18a7a5d:	48 8d 3d 0c 8c cd fe 	lea    -0x13273f4(%rip),%rdi        # 580670 <tier0_generate_expression.floating_operations+0x4>
 18a7a64:	44 0f b6 34 3a       	movzbl (%rdx,%rdi,1),%r14d
 18a7a69:	41 0f b7 53 06       	movzwl 0x6(%r11),%edx
 18a7a6e:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18a7a73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18a7a79:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
 18a7a7e:	89 54 24 30          	mov    %edx,0x30(%rsp)
 18a7a82:	b2 01                	mov    $0x1,%dl
 18a7a84:	84 c0                	test   %al,%al
 18a7a86:	0f 85 37 09 00 00    	jne    18a83c3 <run_backend_benchmark+0xda3>
 18a7a8c:	0f b6 c1             	movzbl %cl,%eax
 18a7a8f:	8d 48 ff             	lea    -0x1(%rax),%ecx
 18a7a92:	83 f9 03             	cmp    $0x3,%ecx
 18a7a95:	0f 83 5b 04 00 00    	jae    18a7ef6 <run_backend_benchmark+0x8d6>
 18a7a9b:	4c 8d 6e ff          	lea    -0x1(%rsi),%r13
 18a7a9f:	48 8d 15 a6 8a c7 fe 	lea    -0x138755a(%rip),%rdx        # 52054c <branch_sizing_patterns+0x7bc>
 18a7aa6:	83 c6 fe             	add    $0xfffffffe,%esi
 18a7aa9:	45 89 eb             	mov    %r13d,%r11d
 18a7aac:	41 83 e3 07          	and    $0x7,%r11d
 18a7ab0:	83 fe 07             	cmp    $0x7,%esi
 18a7ab3:	73 0c                	jae    18a7ac1 <run_backend_benchmark+0x4a1>
 18a7ab5:	b9 01 00 00 00       	mov    $0x1,%ecx
 18a7aba:	31 f6                	xor    %esi,%esi
 18a7abc:	e9 4b 03 00 00       	jmp    18a7e0c <run_backend_benchmark+0x7ec>
 18a7ac1:	49 83 e5 f8          	and    $0xfffffffffffffff8,%r13
 18a7ac5:	48 8d 35 30 8a c7 fe 	lea    -0x13875d0(%rip),%rsi        # 5204fc <branch_sizing_patterns+0x76c>
 18a7acc:	31 c9                	xor    %ecx,%ecx
 18a7ace:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18a7ad7:	eb 14                	jmp    18a7aed <run_backend_benchmark+0x4cd>
 18a7ad9:	83 cf 02             	or     $0x2,%edi
 18a7adc:	0f 1f 40 00          	nopl   0x0(%rax)
 18a7ae0:	48 83 c1 08          	add    $0x8,%rcx
 18a7ae4:	49 39 cd             	cmp    %rcx,%r13
 18a7ae7:	0f 84 0e 03 00 00    	je     18a7dfb <run_backend_benchmark+0x7db>
 18a7aed:	0f b6 84 0c 01 0d 00 00 	movzbl 0xd01(%rsp,%rcx,1),%eax
 18a7af5:	48 83 f8 04          	cmp    $0x4,%rax
 18a7af9:	77 65                	ja     18a7b60 <run_backend_benchmark+0x540>
 18a7afb:	4c 8d 05 be 89 c7 fe 	lea    -0x1387642(%rip),%r8        # 5204c0 <branch_sizing_patterns+0x730>
 18a7b02:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 18a7b06:	4c 01 c0             	add    %r8,%rax
 18a7b09:	ff e0                	jmp    *%rax
 18a7b0b:	41 83 ca 01          	or     $0x1,%r10d
 18a7b0f:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18a7b17:	48 83 f8 04          	cmp    $0x4,%rax
 18a7b1b:	76 51                	jbe    18a7b6e <run_backend_benchmark+0x54e>
 18a7b1d:	e9 9e 00 00 00       	jmp    18a7bc0 <run_backend_benchmark+0x5a0>
 18a7b22:	83 cf 02             	or     $0x2,%edi
 18a7b25:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18a7b2d:	48 83 f8 04          	cmp    $0x4,%rax
 18a7b31:	76 3b                	jbe    18a7b6e <run_backend_benchmark+0x54e>
 18a7b33:	e9 88 00 00 00       	jmp    18a7bc0 <run_backend_benchmark+0x5a0>
 18a7b38:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7b3d:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a7b42:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18a7b4a:	48 83 f8 04          	cmp    $0x4,%rax
 18a7b4e:	76 1e                	jbe    18a7b6e <run_backend_benchmark+0x54e>
 18a7b50:	eb 6e                	jmp    18a7bc0 <run_backend_benchmark+0x5a0>
 18a7b52:	83 cf 01             	or     $0x1,%edi
 18a7b55:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18a7b60:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18a7b68:	48 83 f8 04          	cmp    $0x4,%rax
 18a7b6c:	77 52                	ja     18a7bc0 <run_backend_benchmark+0x5a0>
 18a7b6e:	4c 8d 05 5f 89 c7 fe 	lea    -0x13876a1(%rip),%r8        # 5204d4 <branch_sizing_patterns+0x744>
 18a7b75:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 18a7b79:	4c 01 c0             	add    %r8,%rax
 18a7b7c:	ff e0                	jmp    *%rax
 18a7b7e:	41 83 ca 01          	or     $0x1,%r10d
 18a7b82:	eb 3c                	jmp    18a7bc0 <run_backend_benchmark+0x5a0>
 18a7b84:	83 cf 02             	or     $0x2,%edi
 18a7b87:	eb 37                	jmp    18a7bc0 <run_backend_benchmark+0x5a0>
 18a7b89:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7b8e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a7b93:	eb 2b                	jmp    18a7bc0 <run_backend_benchmark+0x5a0>
 18a7b95:	83 cf 01             	or     $0x1,%edi
 18a7b98:	eb 26                	jmp    18a7bc0 <run_backend_benchmark+0x5a0>
 18a7b9a:	41 83 ce 01          	or     $0x1,%r14d
 18a7b9e:	0f b6 84 0c 02 0d 00 00 	movzbl 0xd02(%rsp,%rcx,1),%eax
 18a7ba6:	48 83 f8 04          	cmp    $0x4,%rax
 18a7baa:	76 c2                	jbe    18a7b6e <run_backend_benchmark+0x54e>
 18a7bac:	eb 12                	jmp    18a7bc0 <run_backend_benchmark+0x5a0>
 18a7bae:	41 83 ce 01          	or     $0x1,%r14d
 18a7bb2:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a7bc0:	0f b6 84 0c 03 0d 00 00 	movzbl 0xd03(%rsp,%rcx,1),%eax
 18a7bc8:	48 83 f8 04          	cmp    $0x4,%rax
 18a7bcc:	77 62                	ja     18a7c30 <run_backend_benchmark+0x610>
 18a7bce:	4c 8d 05 13 89 c7 fe 	lea    -0x13876ed(%rip),%r8        # 5204e8 <branch_sizing_patterns+0x758>
 18a7bd5:	49 63 04 80          	movslq (%r8,%rax,4),%rax
 18a7bd9:	4c 01 c0             	add    %r8,%rax
 18a7bdc:	ff e0                	jmp    *%rax
 18a7bde:	41 83 ca 01          	or     $0x1,%r10d
 18a7be2:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18a7bea:	48 83 f8 04          	cmp    $0x4,%rax
 18a7bee:	76 4e                	jbe    18a7c3e <run_backend_benchmark+0x61e>
 18a7bf0:	e9 8b 00 00 00       	jmp    18a7c80 <run_backend_benchmark+0x660>
 18a7bf5:	83 cf 02             	or     $0x2,%edi
 18a7bf8:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18a7c00:	48 83 f8 04          	cmp    $0x4,%rax
 18a7c04:	76 38                	jbe    18a7c3e <run_backend_benchmark+0x61e>
 18a7c06:	eb 78                	jmp    18a7c80 <run_backend_benchmark+0x660>
 18a7c08:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7c0d:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a7c12:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18a7c1a:	48 83 f8 04          	cmp    $0x4,%rax
 18a7c1e:	76 1e                	jbe    18a7c3e <run_backend_benchmark+0x61e>
 18a7c20:	eb 5e                	jmp    18a7c80 <run_backend_benchmark+0x660>
 18a7c22:	83 cf 01             	or     $0x1,%edi
 18a7c25:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18a7c30:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18a7c38:	48 83 f8 04          	cmp    $0x4,%rax
 18a7c3c:	77 42                	ja     18a7c80 <run_backend_benchmark+0x660>
 18a7c3e:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a7c42:	48 01 f0             	add    %rsi,%rax
 18a7c45:	ff e0                	jmp    *%rax
 18a7c47:	41 83 ca 01          	or     $0x1,%r10d
 18a7c4b:	eb 33                	jmp    18a7c80 <run_backend_benchmark+0x660>
 18a7c4d:	83 cf 02             	or     $0x2,%edi
 18a7c50:	eb 2e                	jmp    18a7c80 <run_backend_benchmark+0x660>
 18a7c52:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7c57:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a7c5c:	eb 22                	jmp    18a7c80 <run_backend_benchmark+0x660>
 18a7c5e:	83 cf 01             	or     $0x1,%edi
 18a7c61:	eb 1d                	jmp    18a7c80 <run_backend_benchmark+0x660>
 18a7c63:	41 83 ce 01          	or     $0x1,%r14d
 18a7c67:	0f b6 84 0c 04 0d 00 00 	movzbl 0xd04(%rsp,%rcx,1),%eax
 18a7c6f:	48 83 f8 04          	cmp    $0x4,%rax
 18a7c73:	76 c9                	jbe    18a7c3e <run_backend_benchmark+0x61e>
 18a7c75:	eb 09                	jmp    18a7c80 <run_backend_benchmark+0x660>
 18a7c77:	41 83 ce 01          	or     $0x1,%r14d
 18a7c7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18a7c80:	0f b6 84 0c 05 0d 00 00 	movzbl 0xd05(%rsp,%rcx,1),%eax
 18a7c88:	48 83 f8 04          	cmp    $0x4,%rax
 18a7c8c:	77 52                	ja     18a7ce0 <run_backend_benchmark+0x6c0>
 18a7c8e:	48 63 04 83          	movslq (%rbx,%rax,4),%rax
 18a7c92:	48 01 d8             	add    %rbx,%rax
 18a7c95:	ff e0                	jmp    *%rax
 18a7c97:	41 83 ca 01          	or     $0x1,%r10d
 18a7c9b:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18a7ca3:	48 83 f8 04          	cmp    $0x4,%rax
 18a7ca7:	76 45                	jbe    18a7cee <run_backend_benchmark+0x6ce>
 18a7ca9:	e9 82 00 00 00       	jmp    18a7d30 <run_backend_benchmark+0x710>
 18a7cae:	83 cf 02             	or     $0x2,%edi
 18a7cb1:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18a7cb9:	48 83 f8 04          	cmp    $0x4,%rax
 18a7cbd:	76 2f                	jbe    18a7cee <run_backend_benchmark+0x6ce>
 18a7cbf:	eb 6f                	jmp    18a7d30 <run_backend_benchmark+0x710>
 18a7cc1:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7cc6:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a7ccb:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18a7cd3:	48 83 f8 04          	cmp    $0x4,%rax
 18a7cd7:	76 15                	jbe    18a7cee <run_backend_benchmark+0x6ce>
 18a7cd9:	eb 55                	jmp    18a7d30 <run_backend_benchmark+0x710>
 18a7cdb:	83 cf 01             	or     $0x1,%edi
 18a7cde:	66 90                	xchg   %ax,%ax
 18a7ce0:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18a7ce8:	48 83 f8 04          	cmp    $0x4,%rax
 18a7cec:	77 42                	ja     18a7d30 <run_backend_benchmark+0x710>
 18a7cee:	49 63 04 84          	movslq (%r12,%rax,4),%rax
 18a7cf2:	4c 01 e0             	add    %r12,%rax
 18a7cf5:	ff e0                	jmp    *%rax
 18a7cf7:	41 83 ca 01          	or     $0x1,%r10d
 18a7cfb:	eb 33                	jmp    18a7d30 <run_backend_benchmark+0x710>
 18a7cfd:	83 cf 02             	or     $0x2,%edi
 18a7d00:	eb 2e                	jmp    18a7d30 <run_backend_benchmark+0x710>
 18a7d02:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7d07:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a7d0c:	eb 22                	jmp    18a7d30 <run_backend_benchmark+0x710>
 18a7d0e:	83 cf 01             	or     $0x1,%edi
 18a7d11:	eb 1d                	jmp    18a7d30 <run_backend_benchmark+0x710>
 18a7d13:	41 83 ce 01          	or     $0x1,%r14d
 18a7d17:	0f b6 84 0c 06 0d 00 00 	movzbl 0xd06(%rsp,%rcx,1),%eax
 18a7d1f:	48 83 f8 04          	cmp    $0x4,%rax
 18a7d23:	76 c9                	jbe    18a7cee <run_backend_benchmark+0x6ce>
 18a7d25:	eb 09                	jmp    18a7d30 <run_backend_benchmark+0x710>
 18a7d27:	41 83 ce 01          	or     $0x1,%r14d
 18a7d2b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18a7d30:	0f b6 84 0c 07 0d 00 00 	movzbl 0xd07(%rsp,%rcx,1),%eax
 18a7d38:	48 83 f8 04          	cmp    $0x4,%rax
 18a7d3c:	77 62                	ja     18a7da0 <run_backend_benchmark+0x780>
 18a7d3e:	49 63 04 87          	movslq (%r15,%rax,4),%rax
 18a7d42:	4c 01 f8             	add    %r15,%rax
 18a7d45:	ff e0                	jmp    *%rax
 18a7d47:	41 83 ca 01          	or     $0x1,%r10d
 18a7d4b:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18a7d53:	48 83 f8 04          	cmp    $0x4,%rax
 18a7d57:	76 59                	jbe    18a7db2 <run_backend_benchmark+0x792>
 18a7d59:	e9 82 fd ff ff       	jmp    18a7ae0 <run_backend_benchmark+0x4c0>
 18a7d5e:	83 cf 02             	or     $0x2,%edi
 18a7d61:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18a7d69:	48 83 f8 04          	cmp    $0x4,%rax
 18a7d6d:	76 43                	jbe    18a7db2 <run_backend_benchmark+0x792>
 18a7d6f:	e9 6c fd ff ff       	jmp    18a7ae0 <run_backend_benchmark+0x4c0>
 18a7d74:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7d79:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a7d7e:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18a7d86:	48 83 f8 04          	cmp    $0x4,%rax
 18a7d8a:	76 26                	jbe    18a7db2 <run_backend_benchmark+0x792>
 18a7d8c:	e9 4f fd ff ff       	jmp    18a7ae0 <run_backend_benchmark+0x4c0>
 18a7d91:	83 cf 01             	or     $0x1,%edi
 18a7d94:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a7da0:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18a7da8:	48 83 f8 04          	cmp    $0x4,%rax
 18a7dac:	0f 87 2e fd ff ff    	ja     18a7ae0 <run_backend_benchmark+0x4c0>
 18a7db2:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 18a7db6:	48 01 d0             	add    %rdx,%rax
 18a7db9:	ff e0                	jmp    *%rax
 18a7dbb:	41 83 ca 01          	or     $0x1,%r10d
 18a7dbf:	e9 1c fd ff ff       	jmp    18a7ae0 <run_backend_benchmark+0x4c0>
 18a7dc4:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7dc9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18a7dce:	e9 0d fd ff ff       	jmp    18a7ae0 <run_backend_benchmark+0x4c0>
 18a7dd3:	83 cf 01             	or     $0x1,%edi
 18a7dd6:	e9 05 fd ff ff       	jmp    18a7ae0 <run_backend_benchmark+0x4c0>
 18a7ddb:	41 83 ce 01          	or     $0x1,%r14d
 18a7ddf:	0f b6 84 0c 08 0d 00 00 	movzbl 0xd08(%rsp,%rcx,1),%eax
 18a7de7:	48 83 f8 04          	cmp    $0x4,%rax
 18a7deb:	76 c5                	jbe    18a7db2 <run_backend_benchmark+0x792>
 18a7ded:	e9 ee fc ff ff       	jmp    18a7ae0 <run_backend_benchmark+0x4c0>
 18a7df2:	41 83 ce 01          	or     $0x1,%r14d
 18a7df6:	e9 e5 fc ff ff       	jmp    18a7ae0 <run_backend_benchmark+0x4c0>
 18a7dfb:	4d 85 db             	test   %r11,%r11
 18a7dfe:	0f 84 b8 05 00 00    	je     18a83bc <run_backend_benchmark+0xd9c>
 18a7e04:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18a7e09:	48 ff c1             	inc    %rcx
 18a7e0c:	48 8d 8c 0c 00 0d 00 00 	lea    0xd00(%rsp,%rcx,1),%rcx
 18a7e14:	31 d2                	xor    %edx,%edx
 18a7e16:	eb 10                	jmp    18a7e28 <run_backend_benchmark+0x808>
 18a7e18:	83 cf 02             	or     $0x2,%edi
 18a7e1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18a7e20:	48 ff c2             	inc    %rdx
 18a7e23:	49 39 d3             	cmp    %rdx,%r11
 18a7e26:	74 38                	je     18a7e60 <run_backend_benchmark+0x840>
 18a7e28:	0f b6 04 11          	movzbl (%rcx,%rdx,1),%eax
 18a7e2c:	48 83 f8 04          	cmp    $0x4,%rax
 18a7e30:	77 ee                	ja     18a7e20 <run_backend_benchmark+0x800>
 18a7e32:	49 63 04 81          	movslq (%r9,%rax,4),%rax
 18a7e36:	4c 01 c8             	add    %r9,%rax
 18a7e39:	ff e0                	jmp    *%rax
 18a7e3b:	41 83 ca 01          	or     $0x1,%r10d
 18a7e3f:	eb df                	jmp    18a7e20 <run_backend_benchmark+0x800>
 18a7e41:	be 01 00 00 00       	mov    $0x1,%esi
 18a7e46:	eb d8                	jmp    18a7e20 <run_backend_benchmark+0x800>
 18a7e48:	83 cf 01             	or     $0x1,%edi
 18a7e4b:	eb d3                	jmp    18a7e20 <run_backend_benchmark+0x800>
 18a7e4d:	41 83 ce 01          	or     $0x1,%r14d
 18a7e51:	eb cd                	jmp    18a7e20 <run_backend_benchmark+0x800>
 18a7e53:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a7e60:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 18a7e65:	e9 52 05 00 00       	jmp    18a83bc <run_backend_benchmark+0xd9c>
 18a7e6a:	66 c7 84 24 01 0d 00 00 01 05 	movw   $0x501,0xd01(%rsp)
 18a7e74:	be 03 00 00 00       	mov    $0x3,%esi
 18a7e79:	eb 0d                	jmp    18a7e88 <run_backend_benchmark+0x868>
 18a7e7b:	be 02 00 00 00       	mov    $0x2,%esi
 18a7e80:	c6 84 24 01 0d 00 00 01 	movb   $0x1,0xd01(%rsp)
 18a7e88:	41 0f b7 43 06       	movzwl 0x6(%r11),%eax
 18a7e8d:	41 0f b6 4b 0b       	movzbl 0xb(%r11),%ecx
 18a7e92:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18a7e97:	45 31 f6             	xor    %r14d,%r14d
 18a7e9a:	89 44 24 30          	mov    %eax,0x30(%rsp)
 18a7e9e:	89 c8                	mov    %ecx,%eax
 18a7ea0:	ff c8                	dec    %eax
 18a7ea2:	83 f8 03             	cmp    $0x3,%eax
 18a7ea5:	77 3d                	ja     18a7ee4 <run_backend_benchmark+0x8c4>
 18a7ea7:	48 8d 15 4e 85 c7 fe 	lea    -0x1387ab2(%rip),%rdx        # 5203fc <branch_sizing_patterns+0x66c>
 18a7eae:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 18a7eb2:	48 01 d0             	add    %rdx,%rax
 18a7eb5:	ff e0                	jmp    *%rax
 18a7eb7:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a7ebd:	0f b6 c1             	movzbl %cl,%eax
 18a7ec0:	8d 48 ff             	lea    -0x1(%rax),%ecx
 18a7ec3:	83 f9 03             	cmp    $0x3,%ecx
 18a7ec6:	0f 82 cf fb ff ff    	jb     18a7a9b <run_backend_benchmark+0x47b>
 18a7ecc:	eb 28                	jmp    18a7ef6 <run_backend_benchmark+0x8d6>
 18a7ece:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18a7ed4:	e9 c2 fb ff ff       	jmp    18a7a9b <run_backend_benchmark+0x47b>
 18a7ed9:	41 ba 02 00 00 00    	mov    $0x2,%r10d
 18a7edf:	e9 b7 fb ff ff       	jmp    18a7a9b <run_backend_benchmark+0x47b>
 18a7ee4:	45 31 d2             	xor    %r10d,%r10d
 18a7ee7:	0f b6 c1             	movzbl %cl,%eax
 18a7eea:	8d 48 ff             	lea    -0x1(%rax),%ecx
 18a7eed:	83 f9 03             	cmp    $0x3,%ecx
 18a7ef0:	0f 82 a5 fb ff ff    	jb     18a7a9b <run_backend_benchmark+0x47b>
 18a7ef6:	83 f8 04             	cmp    $0x4,%eax
 18a7ef9:	75 30                	jne    18a7f2b <run_backend_benchmark+0x90b>
 18a7efb:	44 8b 4c 24 30       	mov    0x30(%rsp),%r9d
 18a7f00:	48 8d 4e ff          	lea    -0x1(%rsi),%rcx
 18a7f04:	83 c6 fe             	add    $0xfffffffe,%esi
 18a7f07:	48 8d 15 8a 85 c7 fe 	lea    -0x1387a76(%rip),%rdx        # 520498 <branch_sizing_patterns+0x708>
 18a7f0e:	41 89 cb             	mov    %ecx,%r11d
 18a7f11:	41 83 e3 07          	and    $0x7,%r11d
 18a7f15:	83 fe 07             	cmp    $0x7,%esi
 18a7f18:	0f 83 d4 00 00 00    	jae    18a7ff2 <run_backend_benchmark+0x9d2>
 18a7f1e:	41 bd 01 00 00 00    	mov    $0x1,%r13d
 18a7f24:	31 db                	xor    %ebx,%ebx
 18a7f26:	e9 2f 04 00 00       	jmp    18a835a <run_backend_benchmark+0xd3a>
 18a7f2b:	48 8d 56 ff          	lea    -0x1(%rsi),%rdx
 18a7f2f:	83 c6 fe             	add    $0xfffffffe,%esi
 18a7f32:	b8 01 00 00 00       	mov    $0x1,%eax
 18a7f37:	89 d1                	mov    %edx,%ecx
 18a7f39:	83 e1 07             	and    $0x7,%ecx
 18a7f3c:	83 fe 07             	cmp    $0x7,%esi
 18a7f3f:	72 7d                	jb     18a7fbe <run_backend_benchmark+0x99e>
 18a7f41:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 18a7f45:	31 c0                	xor    %eax,%eax
 18a7f47:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18a7f50:	89 fe                	mov    %edi,%esi
 18a7f52:	83 ce 02             	or     $0x2,%esi
 18a7f55:	80 bc 04 01 0d 00 00 04 	cmpb   $0x4,0xd01(%rsp,%rax,1)
 18a7f5d:	0f 44 fe             	cmove  %esi,%edi
 18a7f60:	80 bc 04 02 0d 00 00 04 	cmpb   $0x4,0xd02(%rsp,%rax,1)
 18a7f68:	0f 44 fe             	cmove  %esi,%edi
 18a7f6b:	80 bc 04 03 0d 00 00 04 	cmpb   $0x4,0xd03(%rsp,%rax,1)
 18a7f73:	0f 44 fe             	cmove  %esi,%edi
 18a7f76:	80 bc 04 04 0d 00 00 04 	cmpb   $0x4,0xd04(%rsp,%rax,1)
 18a7f7e:	0f 44 fe             	cmove  %esi,%edi
 18a7f81:	80 bc 04 05 0d 00 00 04 	cmpb   $0x4,0xd05(%rsp,%rax,1)
 18a7f89:	0f 44 fe             	cmove  %esi,%edi
 18a7f8c:	80 bc 04 06 0d 00 00 04 	cmpb   $0x4,0xd06(%rsp,%rax,1)
 18a7f94:	0f 44 fe             	cmove  %esi,%edi
 18a7f97:	80 bc 04 07 0d 00 00 04 	cmpb   $0x4,0xd07(%rsp,%rax,1)
 18a7f9f:	0f 44 fe             	cmove  %esi,%edi
 18a7fa2:	80 bc 04 08 0d 00 00 04 	cmpb   $0x4,0xd08(%rsp,%rax,1)
 18a7faa:	0f 44 fe             	cmove  %esi,%edi
 18a7fad:	48 83 c0 08          	add    $0x8,%rax
 18a7fb1:	48 39 c2             	cmp    %rax,%rdx
 18a7fb4:	75 9a                	jne    18a7f50 <run_backend_benchmark+0x930>
 18a7fb6:	48 85 c9             	test   %rcx,%rcx
 18a7fb9:	74 29                	je     18a7fe4 <run_backend_benchmark+0x9c4>
 18a7fbb:	48 ff c0             	inc    %rax
 18a7fbe:	48 8d 84 04 00 0d 00 00 	lea    0xd00(%rsp,%rax,1),%rax
 18a7fc6:	31 d2                	xor    %edx,%edx
 18a7fc8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18a7fd0:	89 fe                	mov    %edi,%esi
 18a7fd2:	83 cf 02             	or     $0x2,%edi
 18a7fd5:	80 3c 10 04          	cmpb   $0x4,(%rax,%rdx,1)
 18a7fd9:	0f 45 fe             	cmovne %esi,%edi
 18a7fdc:	48 ff c2             	inc    %rdx
 18a7fdf:	48 39 d1             	cmp    %rdx,%rcx
 18a7fe2:	75 ec                	jne    18a7fd0 <run_backend_benchmark+0x9b0>
 18a7fe4:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18a7fed:	e9 cf 03 00 00       	jmp    18a83c1 <run_backend_benchmark+0xda1>
 18a7ff2:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 18a7ff6:	31 db                	xor    %ebx,%ebx
 18a7ff8:	45 31 ed             	xor    %r13d,%r13d
 18a7ffb:	eb 10                	jmp    18a800d <run_backend_benchmark+0x9ed>
 18a7ffd:	83 cf 02             	or     $0x2,%edi
 18a8000:	49 83 c5 08          	add    $0x8,%r13
 18a8004:	4c 39 e9             	cmp    %r13,%rcx
 18a8007:	0f 84 45 03 00 00    	je     18a8352 <run_backend_benchmark+0xd32>
 18a800d:	42 0f b6 84 2c 01 0d 00 00 	movzbl 0xd01(%rsp,%r13,1),%eax
 18a8016:	48 83 f8 04          	cmp    $0x4,%rax
 18a801a:	77 64                	ja     18a8080 <run_backend_benchmark+0xa60>
 18a801c:	48 8d 35 e9 83 c7 fe 	lea    -0x1387c17(%rip),%rsi        # 52040c <branch_sizing_patterns+0x67c>
 18a8023:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a8027:	48 01 f0             	add    %rsi,%rax
 18a802a:	ff e0                	jmp    *%rax
 18a802c:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a8032:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18a803b:	48 83 f8 04          	cmp    $0x4,%rax
 18a803f:	76 4e                	jbe    18a808f <run_backend_benchmark+0xa6f>
 18a8041:	e9 9a 00 00 00       	jmp    18a80e0 <run_backend_benchmark+0xac0>
 18a8046:	83 cf 02             	or     $0x2,%edi
 18a8049:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18a8052:	48 83 f8 04          	cmp    $0x4,%rax
 18a8056:	76 37                	jbe    18a808f <run_backend_benchmark+0xa6f>
 18a8058:	e9 83 00 00 00       	jmp    18a80e0 <run_backend_benchmark+0xac0>
 18a805d:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a8062:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18a806b:	48 83 f8 04          	cmp    $0x4,%rax
 18a806f:	76 1e                	jbe    18a808f <run_backend_benchmark+0xa6f>
 18a8071:	eb 6d                	jmp    18a80e0 <run_backend_benchmark+0xac0>
 18a8073:	41 83 c9 01          	or     $0x1,%r9d
 18a8077:	83 cf 01             	or     $0x1,%edi
 18a807a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18a8080:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18a8089:	48 83 f8 04          	cmp    $0x4,%rax
 18a808d:	77 51                	ja     18a80e0 <run_backend_benchmark+0xac0>
 18a808f:	48 8d 35 8a 83 c7 fe 	lea    -0x1387c76(%rip),%rsi        # 520420 <branch_sizing_patterns+0x690>
 18a8096:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a809a:	48 01 f0             	add    %rsi,%rax
 18a809d:	ff e0                	jmp    *%rax
 18a809f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a80a5:	eb 39                	jmp    18a80e0 <run_backend_benchmark+0xac0>
 18a80a7:	83 cf 02             	or     $0x2,%edi
 18a80aa:	eb 34                	jmp    18a80e0 <run_backend_benchmark+0xac0>
 18a80ac:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a80b1:	eb 2d                	jmp    18a80e0 <run_backend_benchmark+0xac0>
 18a80b3:	41 83 c9 01          	or     $0x1,%r9d
 18a80b7:	83 cf 01             	or     $0x1,%edi
 18a80ba:	eb 24                	jmp    18a80e0 <run_backend_benchmark+0xac0>
 18a80bc:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a80c2:	42 0f b6 84 2c 02 0d 00 00 	movzbl 0xd02(%rsp,%r13,1),%eax
 18a80cb:	48 83 f8 04          	cmp    $0x4,%rax
 18a80cf:	76 be                	jbe    18a808f <run_backend_benchmark+0xa6f>
 18a80d1:	eb 0d                	jmp    18a80e0 <run_backend_benchmark+0xac0>
 18a80d3:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a80d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18a80e0:	42 0f b6 84 2c 03 0d 00 00 	movzbl 0xd03(%rsp,%r13,1),%eax
 18a80e9:	48 83 f8 04          	cmp    $0x4,%rax
 18a80ed:	77 61                	ja     18a8150 <run_backend_benchmark+0xb30>
 18a80ef:	48 8d 35 3e 83 c7 fe 	lea    -0x1387cc2(%rip),%rsi        # 520434 <branch_sizing_patterns+0x6a4>
 18a80f6:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a80fa:	48 01 f0             	add    %rsi,%rax
 18a80fd:	ff e0                	jmp    *%rax
 18a80ff:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a8105:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18a810e:	48 83 f8 04          	cmp    $0x4,%rax
 18a8112:	76 4b                	jbe    18a815f <run_backend_benchmark+0xb3f>
 18a8114:	e9 97 00 00 00       	jmp    18a81b0 <run_backend_benchmark+0xb90>
 18a8119:	83 cf 02             	or     $0x2,%edi
 18a811c:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18a8125:	48 83 f8 04          	cmp    $0x4,%rax
 18a8129:	76 34                	jbe    18a815f <run_backend_benchmark+0xb3f>
 18a812b:	e9 80 00 00 00       	jmp    18a81b0 <run_backend_benchmark+0xb90>
 18a8130:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a8135:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18a813e:	48 83 f8 04          	cmp    $0x4,%rax
 18a8142:	76 1b                	jbe    18a815f <run_backend_benchmark+0xb3f>
 18a8144:	eb 6a                	jmp    18a81b0 <run_backend_benchmark+0xb90>
 18a8146:	41 83 c9 01          	or     $0x1,%r9d
 18a814a:	83 cf 01             	or     $0x1,%edi
 18a814d:	0f 1f 00             	nopl   (%rax)
 18a8150:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18a8159:	48 83 f8 04          	cmp    $0x4,%rax
 18a815d:	77 51                	ja     18a81b0 <run_backend_benchmark+0xb90>
 18a815f:	48 8d 35 e2 82 c7 fe 	lea    -0x1387d1e(%rip),%rsi        # 520448 <branch_sizing_patterns+0x6b8>
 18a8166:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a816a:	48 01 f0             	add    %rsi,%rax
 18a816d:	ff e0                	jmp    *%rax
 18a816f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a8175:	eb 39                	jmp    18a81b0 <run_backend_benchmark+0xb90>
 18a8177:	83 cf 02             	or     $0x2,%edi
 18a817a:	eb 34                	jmp    18a81b0 <run_backend_benchmark+0xb90>
 18a817c:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a8181:	eb 2d                	jmp    18a81b0 <run_backend_benchmark+0xb90>
 18a8183:	41 83 c9 01          	or     $0x1,%r9d
 18a8187:	83 cf 01             	or     $0x1,%edi
 18a818a:	eb 24                	jmp    18a81b0 <run_backend_benchmark+0xb90>
 18a818c:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a8192:	42 0f b6 84 2c 04 0d 00 00 	movzbl 0xd04(%rsp,%r13,1),%eax
 18a819b:	48 83 f8 04          	cmp    $0x4,%rax
 18a819f:	76 be                	jbe    18a815f <run_backend_benchmark+0xb3f>
 18a81a1:	eb 0d                	jmp    18a81b0 <run_backend_benchmark+0xb90>
 18a81a3:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a81a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18a81b0:	42 0f b6 84 2c 05 0d 00 00 	movzbl 0xd05(%rsp,%r13,1),%eax
 18a81b9:	48 83 f8 04          	cmp    $0x4,%rax
 18a81bd:	77 61                	ja     18a8220 <run_backend_benchmark+0xc00>
 18a81bf:	48 8d 35 96 82 c7 fe 	lea    -0x1387d6a(%rip),%rsi        # 52045c <branch_sizing_patterns+0x6cc>
 18a81c6:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a81ca:	48 01 f0             	add    %rsi,%rax
 18a81cd:	ff e0                	jmp    *%rax
 18a81cf:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a81d5:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18a81de:	48 83 f8 04          	cmp    $0x4,%rax
 18a81e2:	76 4b                	jbe    18a822f <run_backend_benchmark+0xc0f>
 18a81e4:	e9 97 00 00 00       	jmp    18a8280 <run_backend_benchmark+0xc60>
 18a81e9:	83 cf 02             	or     $0x2,%edi
 18a81ec:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18a81f5:	48 83 f8 04          	cmp    $0x4,%rax
 18a81f9:	76 34                	jbe    18a822f <run_backend_benchmark+0xc0f>
 18a81fb:	e9 80 00 00 00       	jmp    18a8280 <run_backend_benchmark+0xc60>
 18a8200:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a8205:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18a820e:	48 83 f8 04          	cmp    $0x4,%rax
 18a8212:	76 1b                	jbe    18a822f <run_backend_benchmark+0xc0f>
 18a8214:	eb 6a                	jmp    18a8280 <run_backend_benchmark+0xc60>
 18a8216:	41 83 c9 01          	or     $0x1,%r9d
 18a821a:	83 cf 01             	or     $0x1,%edi
 18a821d:	0f 1f 00             	nopl   (%rax)
 18a8220:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18a8229:	48 83 f8 04          	cmp    $0x4,%rax
 18a822d:	77 51                	ja     18a8280 <run_backend_benchmark+0xc60>
 18a822f:	48 8d 35 3a 82 c7 fe 	lea    -0x1387dc6(%rip),%rsi        # 520470 <branch_sizing_patterns+0x6e0>
 18a8236:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a823a:	48 01 f0             	add    %rsi,%rax
 18a823d:	ff e0                	jmp    *%rax
 18a823f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a8245:	eb 39                	jmp    18a8280 <run_backend_benchmark+0xc60>
 18a8247:	83 cf 02             	or     $0x2,%edi
 18a824a:	eb 34                	jmp    18a8280 <run_backend_benchmark+0xc60>
 18a824c:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a8251:	eb 2d                	jmp    18a8280 <run_backend_benchmark+0xc60>
 18a8253:	41 83 c9 01          	or     $0x1,%r9d
 18a8257:	83 cf 01             	or     $0x1,%edi
 18a825a:	eb 24                	jmp    18a8280 <run_backend_benchmark+0xc60>
 18a825c:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a8262:	42 0f b6 84 2c 06 0d 00 00 	movzbl 0xd06(%rsp,%r13,1),%eax
 18a826b:	48 83 f8 04          	cmp    $0x4,%rax
 18a826f:	76 be                	jbe    18a822f <run_backend_benchmark+0xc0f>
 18a8271:	eb 0d                	jmp    18a8280 <run_backend_benchmark+0xc60>
 18a8273:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a8279:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18a8280:	42 0f b6 84 2c 07 0d 00 00 	movzbl 0xd07(%rsp,%r13,1),%eax
 18a8289:	48 83 f8 04          	cmp    $0x4,%rax
 18a828d:	77 61                	ja     18a82f0 <run_backend_benchmark+0xcd0>
 18a828f:	48 8d 35 ee 81 c7 fe 	lea    -0x1387e12(%rip),%rsi        # 520484 <branch_sizing_patterns+0x6f4>
 18a8296:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a829a:	48 01 f0             	add    %rsi,%rax
 18a829d:	ff e0                	jmp    *%rax
 18a829f:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a82a5:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18a82ae:	48 83 f8 04          	cmp    $0x4,%rax
 18a82b2:	76 4f                	jbe    18a8303 <run_backend_benchmark+0xce3>
 18a82b4:	e9 47 fd ff ff       	jmp    18a8000 <run_backend_benchmark+0x9e0>
 18a82b9:	83 cf 02             	or     $0x2,%edi
 18a82bc:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18a82c5:	48 83 f8 04          	cmp    $0x4,%rax
 18a82c9:	76 38                	jbe    18a8303 <run_backend_benchmark+0xce3>
 18a82cb:	e9 30 fd ff ff       	jmp    18a8000 <run_backend_benchmark+0x9e0>
 18a82d0:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a82d5:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18a82de:	48 83 f8 04          	cmp    $0x4,%rax
 18a82e2:	76 1f                	jbe    18a8303 <run_backend_benchmark+0xce3>
 18a82e4:	e9 17 fd ff ff       	jmp    18a8000 <run_backend_benchmark+0x9e0>
 18a82e9:	41 83 c9 01          	or     $0x1,%r9d
 18a82ed:	83 cf 01             	or     $0x1,%edi
 18a82f0:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18a82f9:	48 83 f8 04          	cmp    $0x4,%rax
 18a82fd:	0f 87 fd fc ff ff    	ja     18a8000 <run_backend_benchmark+0x9e0>
 18a8303:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
 18a8307:	48 01 d0             	add    %rdx,%rax
 18a830a:	ff e0                	jmp    *%rax
 18a830c:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a8312:	e9 e9 fc ff ff       	jmp    18a8000 <run_backend_benchmark+0x9e0>
 18a8317:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a831c:	e9 df fc ff ff       	jmp    18a8000 <run_backend_benchmark+0x9e0>
 18a8321:	41 83 c9 01          	or     $0x1,%r9d
 18a8325:	83 cf 01             	or     $0x1,%edi
 18a8328:	e9 d3 fc ff ff       	jmp    18a8000 <run_backend_benchmark+0x9e0>
 18a832d:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a8333:	42 0f b6 84 2c 08 0d 00 00 	movzbl 0xd08(%rsp,%r13,1),%eax
 18a833c:	48 83 f8 04          	cmp    $0x4,%rax
 18a8340:	76 c1                	jbe    18a8303 <run_backend_benchmark+0xce3>
 18a8342:	e9 b9 fc ff ff       	jmp    18a8000 <run_backend_benchmark+0x9e0>
 18a8347:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a834d:	e9 ae fc ff ff       	jmp    18a8000 <run_backend_benchmark+0x9e0>
 18a8352:	4d 85 db             	test   %r11,%r11
 18a8355:	74 5b                	je     18a83b2 <run_backend_benchmark+0xd92>
 18a8357:	49 ff c5             	inc    %r13
 18a835a:	4a 8d 8c 2c 00 0d 00 00 	lea    0xd00(%rsp,%r13,1),%rcx
 18a8362:	31 d2                	xor    %edx,%edx
 18a8364:	eb 12                	jmp    18a8378 <run_backend_benchmark+0xd58>
 18a8366:	83 cf 02             	or     $0x2,%edi
 18a8369:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18a8370:	48 ff c2             	inc    %rdx
 18a8373:	49 39 d3             	cmp    %rdx,%r11
 18a8376:	74 3a                	je     18a83b2 <run_backend_benchmark+0xd92>
 18a8378:	0f b6 04 11          	movzbl (%rcx,%rdx,1),%eax
 18a837c:	48 83 f8 04          	cmp    $0x4,%rax
 18a8380:	77 ee                	ja     18a8370 <run_backend_benchmark+0xd50>
 18a8382:	48 8d 35 23 81 c7 fe 	lea    -0x1387edd(%rip),%rsi        # 5204ac <branch_sizing_patterns+0x71c>
 18a8389:	48 63 04 86          	movslq (%rsi,%rax,4),%rax
 18a838d:	48 01 f0             	add    %rsi,%rax
 18a8390:	ff e0                	jmp    *%rax
 18a8392:	41 ba 03 00 00 00    	mov    $0x3,%r10d
 18a8398:	eb d6                	jmp    18a8370 <run_backend_benchmark+0xd50>
 18a839a:	bb 03 00 00 00       	mov    $0x3,%ebx
 18a839f:	eb cf                	jmp    18a8370 <run_backend_benchmark+0xd50>
 18a83a1:	41 83 c9 01          	or     $0x1,%r9d
 18a83a5:	83 cf 01             	or     $0x1,%edi
 18a83a8:	eb c6                	jmp    18a8370 <run_backend_benchmark+0xd50>
 18a83aa:	41 be 03 00 00 00    	mov    $0x3,%r14d
 18a83b0:	eb be                	jmp    18a8370 <run_backend_benchmark+0xd50>
 18a83b2:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 18a83b7:	44 89 4c 24 30       	mov    %r9d,0x30(%rsp)
 18a83bc:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18a83c1:	b2 01                	mov    $0x1,%dl
 18a83c3:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 18a83cb:	44 0f b7 48 16       	movzwl 0x16(%rax),%r9d
 18a83d0:	0f b7 48 18          	movzwl 0x18(%rax),%ecx
 18a83d4:	0f b7 40 1e          	movzwl 0x1e(%rax),%eax
 18a83d8:	45 85 c9             	test   %r9d,%r9d
 18a83db:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
 18a83e2:	44 89 c8             	mov    %r9d,%eax
 18a83e5:	45 89 cf             	mov    %r9d,%r15d
 18a83e8:	89 4c 24 60          	mov    %ecx,0x60(%rsp)
 18a83ec:	41 0f b6 4b 0c       	movzbl 0xc(%r11),%ecx
 18a83f1:	44 89 8c 24 90 00 00 00 	mov    %r9d,0x90(%rsp)
 18a83f9:	41 0f 95 c0          	setne  %r8b
 18a83fd:	83 e0 0f             	and    $0xf,%eax
 18a8400:	41 83 e7 10          	and    $0x10,%r15d
 18a8404:	40 0f 94 c6          	sete   %sil
 18a8408:	41 c1 ef 04          	shr    $0x4,%r15d
 18a840c:	85 c0                	test   %eax,%eax
 18a840e:	41 89 c3             	mov    %eax,%r11d
 18a8411:	41 0f 95 c4          	setne  %r12b
 18a8415:	45 20 fc             	and    %r15b,%r12b
 18a8418:	41 83 eb 05          	sub    $0x5,%r11d
 18a841c:	0f 92 c3             	setb   %bl
 18a841f:	44 20 e3             	and    %r12b,%bl
 18a8422:	41 83 fb 03          	cmp    $0x3,%r11d
 18a8426:	41 0f 92 c3          	setb   %r11b
 18a842a:	45 20 df             	and    %r11b,%r15b
 18a842d:	45 85 d2             	test   %r10d,%r10d
 18a8430:	41 0f 94 c4          	sete   %r12b
 18a8434:	44 08 e6             	or     %r12b,%sil
 18a8437:	45 08 e0             	or     %r12b,%r8b
 18a843a:	44 08 de             	or     %r11b,%sil
 18a843d:	41 20 d0             	and    %dl,%r8b
 18a8440:	40 08 de             	or     %bl,%sil
 18a8443:	44 20 c6             	and    %r8b,%sil
 18a8446:	45 0f b6 c7          	movzbl %r15b,%r8d
 18a844a:	41 c1 e0 04          	shl    $0x4,%r8d
 18a844e:	45 09 d0             	or     %r10d,%r8d
 18a8451:	41 f6 c2 02          	test   $0x2,%r10b
 18a8455:	74 39                	je     18a8490 <run_backend_benchmark+0xe70>
 18a8457:	84 db                	test   %bl,%bl
 18a8459:	74 35                	je     18a8490 <run_backend_benchmark+0xe70>
 18a845b:	8d 50 ff             	lea    -0x1(%rax),%edx
 18a845e:	41 b9 01 00 00 00    	mov    $0x1,%r9d
 18a8464:	45 31 e4             	xor    %r12d,%r12d
 18a8467:	83 fa 02             	cmp    $0x2,%edx
 18a846a:	c4 42 69 f7 d1       	shlx   %edx,%r9d,%r10d
 18a846f:	ba 02 00 00 00       	mov    $0x2,%edx
 18a8474:	41 0f 94 c4          	sete   %r12b
 18a8478:	83 f8 03             	cmp    $0x3,%eax
 18a847b:	44 0f 42 e2          	cmovb  %edx,%r12d
 18a847f:	85 c9                	test   %ecx,%ecx
 18a8481:	41 0f 44 ca          	cmove  %r10d,%ecx
 18a8485:	eb 3a                	jmp    18a84c1 <run_backend_benchmark+0xea1>
 18a8487:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18a8490:	41 83 e2 02          	and    $0x2,%r10d
 18a8494:	45 31 e4             	xor    %r12d,%r12d
 18a8497:	41 d1 ea             	shr    $1,%r10d
 18a849a:	45 20 fa             	and    %r15b,%r10b
 18a849d:	41 80 fa 01          	cmp    $0x1,%r10b
 18a84a1:	75 2d                	jne    18a84d0 <run_backend_benchmark+0xeb0>
 18a84a3:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18a84a8:	44 0f b6 50 0d       	movzbl 0xd(%rax),%r10d
 18a84ad:	45 85 d2             	test   %r10d,%r10d
 18a84b0:	45 89 d4             	mov    %r10d,%r12d
 18a84b3:	0f 95 c0             	setne  %al
 18a84b6:	41 c1 ec 05          	shr    $0x5,%r12d
 18a84ba:	41 83 e2 1f          	and    $0x1f,%r10d
 18a84be:	40 20 c6             	and    %al,%sil
 18a84c1:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 18a84c9:	41 09 c0             	or     %eax,%r8d
 18a84cc:	eb 05                	jmp    18a84d3 <run_backend_benchmark+0xeb3>
 18a84ce:	66 90                	xchg   %ax,%ax
 18a84d0:	45 31 d2             	xor    %r10d,%r10d
 18a84d3:	44 8b 4c 24 60       	mov    0x60(%rsp),%r9d
 18a84d8:	44 89 c8             	mov    %r9d,%eax
 18a84db:	83 e0 0f             	and    $0xf,%eax
 18a84de:	45 89 cf             	mov    %r9d,%r15d
 18a84e1:	41 83 e7 10          	and    $0x10,%r15d
 18a84e5:	0f 94 c2             	sete   %dl
 18a84e8:	41 c1 ef 04          	shr    $0x4,%r15d
 18a84ec:	85 c0                	test   %eax,%eax
 18a84ee:	41 89 c5             	mov    %eax,%r13d
 18a84f1:	41 0f 95 c3          	setne  %r11b
 18a84f5:	45 20 fb             	and    %r15b,%r11b
 18a84f8:	41 83 ed 05          	sub    $0x5,%r13d
 18a84fc:	0f 92 c3             	setb   %bl
 18a84ff:	44 20 db             	and    %r11b,%bl
 18a8502:	41 83 fd 03          	cmp    $0x3,%r13d
 18a8506:	41 0f 92 c3          	setb   %r11b
 18a850a:	45 20 df             	and    %r11b,%r15b
 18a850d:	45 85 f6             	test   %r14d,%r14d
 18a8510:	41 0f 94 c5          	sete   %r13b
 18a8514:	45 85 c9             	test   %r9d,%r9d
 18a8517:	41 0f 95 c1          	setne  %r9b
 18a851b:	44 08 ea             	or     %r13b,%dl
 18a851e:	44 08 da             	or     %r11b,%dl
 18a8521:	45 08 e9             	or     %r13b,%r9b
 18a8524:	08 da                	or     %bl,%dl
 18a8526:	44 20 ca             	and    %r9b,%dl
 18a8529:	40 20 f2             	and    %sil,%dl
 18a852c:	41 0f b6 f7          	movzbl %r15b,%esi
 18a8530:	c1 e6 04             	shl    $0x4,%esi
 18a8533:	44 09 f6             	or     %r14d,%esi
 18a8536:	41 f6 c6 02          	test   $0x2,%r14b
 18a853a:	74 54                	je     18a8590 <run_backend_benchmark+0xf70>
 18a853c:	84 db                	test   %bl,%bl
 18a853e:	74 50                	je     18a8590 <run_backend_benchmark+0xf70>
 18a8540:	44 8d 48 ff          	lea    -0x1(%rax),%r9d
 18a8544:	45 31 e4             	xor    %r12d,%r12d
 18a8547:	44 8b ac 24 98 00 00 00 	mov    0x98(%rsp),%r13d
 18a854f:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18a8555:	41 83 f9 02          	cmp    $0x2,%r9d
 18a8559:	c4 42 31 f7 d2       	shlx   %r9d,%r10d,%r10d
 18a855e:	41 0f 94 c4          	sete   %r12b
 18a8562:	83 f8 03             	cmp    $0x3,%eax
 18a8565:	b8 02 00 00 00       	mov    $0x2,%eax
 18a856a:	44 0f 42 e0          	cmovb  %eax,%r12d
 18a856e:	85 c9                	test   %ecx,%ecx
 18a8570:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 18a8578:	41 0f 44 ca          	cmove  %r10d,%ecx
 18a857c:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
 18a8581:	09 c6                	or     %eax,%esi
 18a8583:	eb 4f                	jmp    18a85d4 <run_backend_benchmark+0xfb4>
 18a8585:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18a8590:	44 8b ac 24 98 00 00 00 	mov    0x98(%rsp),%r13d
 18a8598:	41 83 e6 02          	and    $0x2,%r14d
 18a859c:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
 18a85a1:	41 d1 ee             	shr    $1,%r14d
 18a85a4:	45 20 fe             	and    %r15b,%r14b
 18a85a7:	41 80 fe 01          	cmp    $0x1,%r14b
 18a85ab:	75 27                	jne    18a85d4 <run_backend_benchmark+0xfb4>
 18a85ad:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18a85b2:	44 0f b6 50 0d       	movzbl 0xd(%rax),%r10d
 18a85b7:	45 85 d2             	test   %r10d,%r10d
 18a85ba:	45 89 d4             	mov    %r10d,%r12d
 18a85bd:	0f 95 c0             	setne  %al
 18a85c0:	41 c1 ec 05          	shr    $0x5,%r12d
 18a85c4:	41 83 e2 1f          	and    $0x1f,%r10d
 18a85c8:	42 8d 0c a5 00 00 00 00 	lea    0x0(,%r12,4),%ecx
 18a85d0:	20 c2                	and    %al,%dl
 18a85d2:	09 ce                	or     %ecx,%esi
 18a85d4:	44 89 e8             	mov    %r13d,%eax
 18a85d7:	83 e0 0f             	and    $0xf,%eax
 18a85da:	45 89 ef             	mov    %r13d,%r15d
 18a85dd:	41 83 e7 10          	and    $0x10,%r15d
 18a85e1:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18a85e6:	41 0f 94 c6          	sete   %r14b
 18a85ea:	41 c1 ef 04          	shr    $0x4,%r15d
 18a85ee:	85 c0                	test   %eax,%eax
 18a85f0:	41 89 c3             	mov    %eax,%r11d
 18a85f3:	41 0f 95 c1          	setne  %r9b
 18a85f7:	45 20 f9             	and    %r15b,%r9b
 18a85fa:	41 83 eb 05          	sub    $0x5,%r11d
 18a85fe:	0f 92 c3             	setb   %bl
 18a8601:	44 20 cb             	and    %r9b,%bl
 18a8604:	41 83 fb 03          	cmp    $0x3,%r11d
 18a8608:	41 0f 92 c1          	setb   %r9b
 18a860c:	45 20 cf             	and    %r9b,%r15b
 18a860f:	85 c9                	test   %ecx,%ecx
 18a8611:	41 0f 94 c3          	sete   %r11b
 18a8615:	45 85 ed             	test   %r13d,%r13d
 18a8618:	41 0f 95 c5          	setne  %r13b
 18a861c:	45 08 de             	or     %r11b,%r14b
 18a861f:	45 08 ce             	or     %r9b,%r14b
 18a8622:	45 08 dd             	or     %r11b,%r13b
 18a8625:	41 08 de             	or     %bl,%r14b
 18a8628:	45 20 ee             	and    %r13b,%r14b
 18a862b:	41 20 d6             	and    %dl,%r14b
 18a862e:	41 0f b6 d7          	movzbl %r15b,%edx
 18a8632:	c1 e2 04             	shl    $0x4,%edx
 18a8635:	09 ca                	or     %ecx,%edx
 18a8637:	f6 c1 02             	test   $0x2,%cl
 18a863a:	74 54                	je     18a8690 <run_backend_benchmark+0x1070>
 18a863c:	84 db                	test   %bl,%bl
 18a863e:	74 50                	je     18a8690 <run_backend_benchmark+0x1070>
 18a8640:	44 8d 48 ff          	lea    -0x1(%rax),%r9d
 18a8644:	45 31 e4             	xor    %r12d,%r12d
 18a8647:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 18a864c:	4c 8b ac 24 80 00 00 00 	mov    0x80(%rsp),%r13
 18a8654:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18a8659:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18a865f:	41 83 f9 02          	cmp    $0x2,%r9d
 18a8663:	c4 42 31 f7 d2       	shlx   %r9d,%r10d,%r10d
 18a8668:	41 0f 94 c4          	sete   %r12b
 18a866c:	83 f8 03             	cmp    $0x3,%eax
 18a866f:	b8 02 00 00 00       	mov    $0x2,%eax
 18a8674:	44 0f 42 e0          	cmovb  %eax,%r12d
 18a8678:	42 8d 04 a5 00 00 00 00 	lea    0x0(,%r12,4),%eax
 18a8680:	09 c2                	or     %eax,%edx
 18a8682:	85 c9                	test   %ecx,%ecx
 18a8684:	41 0f 44 ca          	cmove  %r10d,%ecx
 18a8688:	eb 66                	jmp    18a86f0 <run_backend_benchmark+0x10d0>
 18a868a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18a8690:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18a8695:	4c 8b ac 24 80 00 00 00 	mov    0x80(%rsp),%r13
 18a869d:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18a86a2:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 18a86a7:	83 e0 02             	and    $0x2,%eax
 18a86aa:	d1 e8                	shr    $1,%eax
 18a86ac:	44 20 f8             	and    %r15b,%al
 18a86af:	3c 01                	cmp    $0x1,%al
 18a86b1:	75 24                	jne    18a86d7 <run_backend_benchmark+0x10b7>
 18a86b3:	45 0f b6 53 0d       	movzbl 0xd(%r11),%r10d
 18a86b8:	45 85 d2             	test   %r10d,%r10d
 18a86bb:	45 89 d4             	mov    %r10d,%r12d
 18a86be:	0f 95 c0             	setne  %al
 18a86c1:	41 c1 ec 05          	shr    $0x5,%r12d
 18a86c5:	41 83 e2 1f          	and    $0x1f,%r10d
 18a86c9:	46 8d 0c a5 00 00 00 00 	lea    0x0(,%r12,4),%r9d
 18a86d1:	41 20 c6             	and    %al,%r14b
 18a86d4:	44 09 ca             	or     %r9d,%edx
 18a86d7:	85 c9                	test   %ecx,%ecx
 18a86d9:	75 15                	jne    18a86f0 <run_backend_benchmark+0x10d0>
 18a86db:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 18a86e3:	0f b6 48 1a          	movzbl 0x1a(%rax),%ecx
 18a86e7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18a86f0:	4d 89 e9             	mov    %r13,%r9
 18a86f3:	49 c1 e1 04          	shl    $0x4,%r9
 18a86f7:	48 8d 05 42 96 14 0d 	lea    0xd149642(%rip),%rax        # e9f1d40 <x86_effects_records>
 18a86fe:	41 0f b7 5b 08       	movzwl 0x8(%r11),%ebx
 18a8703:	49 01 c1             	add    %rax,%r9
 18a8706:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 18a870e:	0f b6 40 12          	movzbl 0x12(%rax),%eax
 18a8712:	84 c0                	test   %al,%al
 18a8714:	74 0a                	je     18a8720 <run_backend_benchmark+0x1100>
 18a8716:	45 0f b6 7b 12       	movzbl 0x12(%r11),%r15d
 18a871b:	eb 06                	jmp    18a8723 <run_backend_benchmark+0x1103>
 18a871d:	0f 1f 00             	nopl   (%rax)
 18a8720:	45 31 ff             	xor    %r15d,%r15d
 18a8723:	84 c0                	test   %al,%al
 18a8725:	0f 94 c0             	sete   %al
 18a8728:	c1 e6 05             	shl    $0x5,%esi
 18a872b:	c1 e2 0a             	shl    $0xa,%edx
 18a872e:	44 09 c6             	or     %r8d,%esi
 18a8731:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18a8737:	09 d6                	or     %edx,%esi
 18a8739:	89 da                	mov    %ebx,%edx
 18a873b:	83 e2 fd             	and    $0xfffffffd,%edx
 18a873e:	41 83 fc 02          	cmp    $0x2,%r12d
 18a8742:	44 8b 64 24 30       	mov    0x30(%rsp),%r12d
 18a8747:	0f 44 da             	cmove  %edx,%ebx
 18a874a:	f6 44 24 60 10       	testb  $0x10,0x60(%rsp)
 18a874f:	0f 44 da             	cmove  %edx,%ebx
 18a8752:	f6 84 24 90 00 00 00 10 	testb  $0x10,0x90(%rsp)
 18a875a:	0f 44 da             	cmove  %edx,%ebx
 18a875d:	8d 51 ff             	lea    -0x1(%rcx),%edx
 18a8760:	83 fa 03             	cmp    $0x3,%edx
 18a8763:	45 0f 42 c4          	cmovb  %r12d,%r8d
 18a8767:	41 09 f8             	or     %edi,%r8d
 18a876a:	45 85 ff             	test   %r15d,%r15d
 18a876d:	41 0f b6 7b 13       	movzbl 0x13(%r11),%edi
 18a8772:	0f 95 c2             	setne  %dl
 18a8775:	66 45 89 01          	mov    %r8w,(%r9)
 18a8779:	66 45 89 61 02       	mov    %r12w,0x2(%r9)
 18a877e:	66 41 89 71 04       	mov    %si,0x4(%r9)
 18a8783:	66 41 89 59 06       	mov    %bx,0x6(%r9)
 18a8788:	41 8b 5b 0e          	mov    0xe(%r11),%ebx
 18a878c:	45 0f b6 43 0a       	movzbl 0xa(%r11),%r8d
 18a8791:	4c 8d 25 8c 7d c7 fe 	lea    -0x1388274(%rip),%r12        # 520524 <branch_sizing_patterns+0x794>
 18a8798:	08 c2                	or     %al,%dl
 18a879a:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18a87a2:	44 20 f2             	and    %r14b,%dl
 18a87a5:	c1 e7 04             	shl    $0x4,%edi
 18a87a8:	41 89 59 08          	mov    %ebx,0x8(%r9)
 18a87ac:	44 09 ff             	or     %r15d,%edi
 18a87af:	48 8d 1d 4a 54 14 0d 	lea    0xd14544a(%rip),%rbx        # e9edc00 <x86_effects_index>
 18a87b6:	45 88 41 0c          	mov    %r8b,0xc(%r9)
 18a87ba:	41 88 49 0d          	mov    %cl,0xd(%r9)
 18a87be:	45 88 51 0e          	mov    %r10b,0xe(%r9)
 18a87c2:	4c 8d 3d 6f 7d c7 fe 	lea    -0x1388291(%rip),%r15        # 520538 <branch_sizing_patterns+0x7a8>
 18a87c9:	41 88 79 0f          	mov    %dil,0xf(%r9)
 18a87cd:	66 44 89 2c 43       	mov    %r13w,(%rbx,%rax,2)
 18a87d2:	49 ff c5             	inc    %r13
 18a87d5:	4c 8d 0d 84 7d c7 fe 	lea    -0x138827c(%rip),%r9        # 520560 <branch_sizing_patterns+0x7d0>
 18a87dc:	80 fa 01             	cmp    $0x1,%dl
 18a87df:	75 0f                	jne    18a87f0 <run_backend_benchmark+0x11d0>
 18a87e1:	48 8d 78 01          	lea    0x1(%rax),%rdi
 18a87e5:	48 3b 44 24 70       	cmp    0x70(%rsp),%rax
 18a87ea:	0f 82 40 f1 ff ff    	jb     18a7930 <run_backend_benchmark+0x310>
 18a87f0:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 18a87f8:	48 ff c1             	inc    %rcx
 18a87fb:	48 89 8c 24 c0 00 00 00 	mov    %rcx,0xc0(%rsp)
 18a8803:	48 81 f9 bc 00 00 00 	cmp    $0xbc,%rcx
 18a880a:	74 6c                	je     18a8878 <run_backend_benchmark+0x1258>
 18a880c:	84 d2                	test   %dl,%dl
 18a880e:	75 3a                	jne    18a884a <run_backend_benchmark+0x122a>
 18a8810:	e9 31 81 00 00       	jmp    18b0946 <run_backend_benchmark+0x9326>
 18a8815:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18a8820:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 18a8828:	48 ff c1             	inc    %rcx
 18a882b:	48 89 8c 24 c0 00 00 00 	mov    %rcx,0xc0(%rsp)
 18a8833:	48 81 f9 bc 00 00 00 	cmp    $0xbc,%rcx
 18a883a:	0f 84 06 81 00 00    	je     18b0946 <run_backend_benchmark+0x9326>
 18a8840:	31 d2                	xor    %edx,%edx
 18a8842:	84 d2                	test   %dl,%dl
 18a8844:	0f 84 fc 80 00 00    	je     18b0946 <run_backend_benchmark+0x9326>
 18a884a:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18a8852:	48 8d 15 67 9f c7 fe 	lea    -0x1386099(%rip),%rdx        # 5227c0 <x86_effects_rows>
 18a8859:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 18a885d:	4c 8d 1c 82          	lea    (%rdx,%rax,4),%r11
 18a8861:	0f b7 0c 82          	movzwl (%rdx,%rax,4),%ecx
 18a8865:	0f b7 44 82 02       	movzwl 0x2(%rdx,%rax,4),%eax
 18a886a:	66 39 c1             	cmp    %ax,%cx
 18a886d:	0f 86 9d f0 ff ff    	jbe    18a7910 <run_backend_benchmark+0x2f0>
 18a8873:	e9 ce 80 00 00       	jmp    18b0946 <run_backend_benchmark+0x9326>
 18a8878:	84 d2                	test   %dl,%dl
 18a887a:	0f 84 c6 80 00 00    	je     18b0946 <run_backend_benchmark+0x9326>
 18a8880:	62 f3 7d 48 25 c0 ff 	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
 18a8887:	48 8d 3d 02 d7 14 0d 	lea    0xd14d702(%rip),%rdi        # e9f5f90 <x86_choice_rows>
 18a888e:	ba 00 09 00 00       	mov    $0x900,%edx
 18a8893:	31 f6                	xor    %esi,%esi
 18a8895:	48 c7 05 e0 d6 14 0d ff ff ff ff 	movq   $0xffffffffffffffff,0xd14d6e0(%rip)        # e9f5f80 <x86_choice_row_index+0x240>
 18a88a0:	45 31 f6             	xor    %r14d,%r14d
 18a88a3:	62 f1 fe 48 7f 05 93 d6 14 0d 	vmovdqu64 %zmm0,0xd14d693(%rip)        # e9f5f40 <x86_choice_row_index+0x200>
 18a88ad:	62 f1 fe 48 7f 05 49 d6 14 0d 	vmovdqu64 %zmm0,0xd14d649(%rip)        # e9f5f00 <x86_choice_row_index+0x1c0>
 18a88b7:	62 f1 fe 48 7f 05 ff d5 14 0d 	vmovdqu64 %zmm0,0xd14d5ff(%rip)        # e9f5ec0 <x86_choice_row_index+0x180>
 18a88c1:	62 f1 fe 48 7f 05 b5 d5 14 0d 	vmovdqu64 %zmm0,0xd14d5b5(%rip)        # e9f5e80 <x86_choice_row_index+0x140>
 18a88cb:	62 f1 fe 48 7f 05 6b d5 14 0d 	vmovdqu64 %zmm0,0xd14d56b(%rip)        # e9f5e40 <x86_choice_row_index+0x100>
 18a88d5:	62 f1 fe 48 7f 05 21 d5 14 0d 	vmovdqu64 %zmm0,0xd14d521(%rip)        # e9f5e00 <x86_choice_row_index+0xc0>
 18a88df:	62 f1 fe 48 7f 05 d7 d4 14 0d 	vmovdqu64 %zmm0,0xd14d4d7(%rip)        # e9f5dc0 <x86_choice_row_index+0x80>
 18a88e9:	62 f1 fe 48 7f 05 8d d4 14 0d 	vmovdqu64 %zmm0,0xd14d48d(%rip)        # e9f5d80 <x86_choice_row_index+0x40>
 18a88f3:	62 f1 fe 48 7f 05 43 d4 14 0d 	vmovdqu64 %zmm0,0xd14d443(%rip)        # e9f5d40 <x86_choice_row_index>
 18a88fd:	c5 f8 77             	vzeroupper
 18a8900:	e8 2b ba eb fe       	call   764330 <memset@plt>
 18a8905:	62 f2 7d 48 5a 0d f1 d1 cc fe 	vbroadcasti32x4 -0x1332e0f(%rip),%zmm1        # 575b00 <x86_effects_unknown+0xa0>
 18a890f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18a8913:	31 c0                	xor    %eax,%eax
 18a8915:	62 f1 fd 48 7f 05 a1 df 14 0d 	vmovdqa64 %zmm0,0xd14dfa1(%rip)        # e9f68c0 <x86_choice_row_info>
 18a891f:	62 f1 fd 48 7f 05 d7 df 14 0d 	vmovdqa64 %zmm0,0xd14dfd7(%rip)        # e9f6900 <x86_choice_row_info+0x40>
 18a8929:	62 f1 fd 48 7f 05 0d e0 14 0d 	vmovdqa64 %zmm0,0xd14e00d(%rip)        # e9f6940 <x86_choice_forms_by_candidate>
 18a8933:	62 f1 fd 48 7f 05 43 e0 14 0d 	vmovdqa64 %zmm0,0xd14e043(%rip)        # e9f6980 <x86_choice_forms_by_candidate+0x40>
 18a893d:	62 f1 fd 48 7f 05 79 e0 14 0d 	vmovdqa64 %zmm0,0xd14e079(%rip)        # e9f69c0 <x86_choice_forms_by_candidate+0x80>
 18a8947:	62 f1 fd 48 7f 05 af e0 14 0d 	vmovdqa64 %zmm0,0xd14e0af(%rip)        # e9f6a00 <x86_choice_forms_by_candidate+0xc0>
 18a8951:	62 f1 fd 48 7f 05 e5 e0 14 0d 	vmovdqa64 %zmm0,0xd14e0e5(%rip)        # e9f6a40 <x86_choice_forms_by_candidate+0x100>
 18a895b:	62 f1 fd 48 7f 05 1b e1 14 0d 	vmovdqa64 %zmm0,0xd14e11b(%rip)        # e9f6a80 <x86_choice_forms_by_candidate+0x140>
 18a8965:	62 f1 fd 48 7f 05 51 e1 14 0d 	vmovdqa64 %zmm0,0xd14e151(%rip)        # e9f6ac0 <x86_choice_forms_by_candidate+0x180>
 18a896f:	62 f1 fd 48 7f 05 87 e1 14 0d 	vmovdqa64 %zmm0,0xd14e187(%rip)        # e9f6b00 <x86_choice_forms_by_candidate+0x1c0>
 18a8979:	62 f1 fd 48 7f 05 bd e1 14 0d 	vmovdqa64 %zmm0,0xd14e1bd(%rip)        # e9f6b40 <x86_choice_forms_by_candidate+0x200>
 18a8983:	62 f1 fd 48 7f 05 f3 e1 14 0d 	vmovdqa64 %zmm0,0xd14e1f3(%rip)        # e9f6b80 <x86_choice_forms_by_candidate+0x240>
 18a898d:	62 f1 fd 48 7f 05 29 e2 14 0d 	vmovdqa64 %zmm0,0xd14e229(%rip)        # e9f6bc0 <x86_choice_forms_by_candidate+0x280>
 18a8997:	62 f1 fd 48 7f 05 5f e2 14 0d 	vmovdqa64 %zmm0,0xd14e25f(%rip)        # e9f6c00 <x86_choice_forms_by_candidate+0x2c0>
 18a89a1:	62 f1 fd 48 7f 05 95 e2 14 0d 	vmovdqa64 %zmm0,0xd14e295(%rip)        # e9f6c40 <x86_choice_forms_by_candidate+0x300>
 18a89ab:	62 f1 fd 48 7f 05 cb e2 14 0d 	vmovdqa64 %zmm0,0xd14e2cb(%rip)        # e9f6c80 <x86_choice_forms_by_candidate+0x340>
 18a89b5:	62 f1 fd 48 7f 05 01 e3 14 0d 	vmovdqa64 %zmm0,0xd14e301(%rip)        # e9f6cc0 <x86_choice_forms_by_candidate+0x380>
 18a89bf:	62 f1 fd 48 7f 05 37 e3 14 0d 	vmovdqa64 %zmm0,0xd14e337(%rip)        # e9f6d00 <x86_choice_forms_by_candidate+0x3c0>
 18a89c9:	62 f1 fd 48 7f 0d 6d e3 14 0d 	vmovdqa64 %zmm1,0xd14e36d(%rip)        # e9f6d40 <x86_choice_conditions_by_candidate>
 18a89d3:	62 f1 fd 48 7f 0d a3 e3 14 0d 	vmovdqa64 %zmm1,0xd14e3a3(%rip)        # e9f6d80 <x86_choice_conditions_by_candidate+0x40>
 18a89dd:	62 f1 fd 48 7f 0d d9 e3 14 0d 	vmovdqa64 %zmm1,0xd14e3d9(%rip)        # e9f6dc0 <x86_choice_conditions_by_candidate+0x80>
 18a89e7:	62 f1 fd 48 7f 0d 0f e4 14 0d 	vmovdqa64 %zmm1,0xd14e40f(%rip)        # e9f6e00 <x86_choice_conditions_by_candidate+0xc0>
 18a89f1:	62 f1 fd 48 7f 0d 45 e4 14 0d 	vmovdqa64 %zmm1,0xd14e445(%rip)        # e9f6e40 <x86_choice_conditions_by_candidate+0x100>
 18a89fb:	62 f1 fd 48 7f 0d 7b e4 14 0d 	vmovdqa64 %zmm1,0xd14e47b(%rip)        # e9f6e80 <x86_choice_conditions_by_candidate+0x140>
 18a8a05:	62 f1 fd 48 7f 0d b1 e4 14 0d 	vmovdqa64 %zmm1,0xd14e4b1(%rip)        # e9f6ec0 <x86_choice_conditions_by_candidate+0x180>
 18a8a0f:	62 f1 fd 48 7f 0d e7 e4 14 0d 	vmovdqa64 %zmm1,0xd14e4e7(%rip)        # e9f6f00 <x86_choice_conditions_by_candidate+0x1c0>
 18a8a19:	62 f1 fd 48 7f 0d 1d e5 14 0d 	vmovdqa64 %zmm1,0xd14e51d(%rip)        # e9f6f40 <x86_choice_conditions_by_candidate+0x200>
 18a8a23:	62 f1 fd 48 7f 0d 53 e5 14 0d 	vmovdqa64 %zmm1,0xd14e553(%rip)        # e9f6f80 <x86_choice_conditions_by_candidate+0x240>
 18a8a2d:	62 f1 fd 48 7f 0d 89 e5 14 0d 	vmovdqa64 %zmm1,0xd14e589(%rip)        # e9f6fc0 <x86_choice_conditions_by_candidate+0x280>
 18a8a37:	62 f1 fd 48 7f 0d bf e5 14 0d 	vmovdqa64 %zmm1,0xd14e5bf(%rip)        # e9f7000 <x86_choice_conditions_by_candidate+0x2c0>
 18a8a41:	62 f1 fd 48 7f 0d f5 e5 14 0d 	vmovdqa64 %zmm1,0xd14e5f5(%rip)        # e9f7040 <x86_choice_conditions_by_candidate+0x300>
 18a8a4b:	62 f1 fd 48 7f 0d 2b e6 14 0d 	vmovdqa64 %zmm1,0xd14e62b(%rip)        # e9f7080 <x86_choice_conditions_by_candidate+0x340>
 18a8a55:	62 f1 fd 48 7f 0d 61 e6 14 0d 	vmovdqa64 %zmm1,0xd14e661(%rip)        # e9f70c0 <x86_choice_conditions_by_candidate+0x380>
 18a8a5f:	62 f1 fd 48 7f 0d 97 e6 14 0d 	vmovdqa64 %zmm1,0xd14e697(%rip)        # e9f7100 <x86_choice_conditions_by_candidate+0x3c0>
 18a8a69:	eb 27                	jmp    18a8a92 <run_backend_benchmark+0x1472>
 18a8a6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18a8a70:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18a8a78:	8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%edx
 18a8a7f:	48 83 f8 3f          	cmp    $0x3f,%rax
 18a8a83:	48 8d 40 01          	lea    0x1(%rax),%rax
 18a8a87:	0f 92 c1             	setb   %cl
 18a8a8a:	84 ca                	test   %cl,%dl
 18a8a8c:	0f 84 95 06 00 00    	je     18a9127 <run_backend_benchmark+0x1b07>
 18a8a92:	4c 6b d8 36          	imul   $0x36,%rax,%r11
 18a8a96:	49 89 c1             	mov    %rax,%r9
 18a8a99:	48 8d 05 d0 ab c7 fe 	lea    -0x1385430(%rip),%rax        # 523670 <x86_choice_sources>
 18a8aa0:	48 b9 11 11 11 11 11 88 88 08 	movabs $0x888881111111111,%rcx
 18a8aaa:	49 01 c3             	add    %rax,%r11
 18a8aad:	4c 0f a3 c9          	bt     %r9,%rcx
 18a8ab1:	b8 00 00 00 00       	mov    $0x0,%eax
 18a8ab6:	72 38                	jb     18a8af0 <run_backend_benchmark+0x14d0>
 18a8ab8:	b8 01 00 00 00       	mov    $0x1,%eax
 18a8abd:	48 ba 22 22 22 22 22 11 11 11 	movabs $0x1111112222222222,%rdx
 18a8ac7:	c4 e2 b1 f7 c8       	shlx   %r9,%rax,%rcx
 18a8acc:	b8 01 00 00 00       	mov    $0x1,%eax
 18a8ad1:	48 85 d1             	test   %rdx,%rcx
 18a8ad4:	75 1a                	jne    18a8af0 <run_backend_benchmark+0x14d0>
 18a8ad6:	48 b8 44 44 44 44 44 22 22 22 	movabs $0x2222224444444444,%rax
 18a8ae0:	48 21 c1             	and    %rax,%rcx
 18a8ae3:	b8 00 00 00 00       	mov    $0x0,%eax
 18a8ae8:	48 83 f9 01          	cmp    $0x1,%rcx
 18a8aec:	83 d0 02             	adc    $0x2,%eax
 18a8aef:	90                   	nop
 18a8af0:	41 0f b6 13          	movzbl (%r11),%edx
 18a8af4:	48 8d 0d 45 d2 14 0d 	lea    0xd14d245(%rip),%rcx        # e9f5d40 <x86_choice_row_index>
 18a8afb:	45 0f b6 43 02       	movzbl 0x2(%r11),%r8d
 18a8b00:	45 0f b6 63 01       	movzbl 0x1(%r11),%r12d
 18a8b05:	89 c7                	mov    %eax,%edi
 18a8b07:	45 8d 69 d5          	lea    -0x2b(%r9),%r13d
 18a8b0b:	4c 89 8c 24 e8 00 00 00 	mov    %r9,0xe8(%rsp)
 18a8b13:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
 18a8b17:	44 88 84 24 28 01 00 00 	mov    %r8b,0x128(%rsp)
 18a8b1f:	0f b7 34 79          	movzwl (%rcx,%rdi,2),%esi
 18a8b23:	66 44 89 0c 79       	mov    %r9w,(%rcx,%rdi,2)
 18a8b28:	4b 8d 0c c9          	lea    (%r9,%r9,8),%rcx
 18a8b2c:	48 8d 3d 5d d4 14 0d 	lea    0xd14d45d(%rip),%rdi        # e9f5f90 <x86_choice_rows>
 18a8b33:	88 54 8f 20          	mov    %dl,0x20(%rdi,%rcx,4)
 18a8b37:	44 88 64 8f 21       	mov    %r12b,0x21(%rdi,%rcx,4)
 18a8b3c:	44 88 44 8f 22       	mov    %r8b,0x22(%rdi,%rcx,4)
 18a8b41:	31 ff                	xor    %edi,%edi
 18a8b43:	41 83 fd 14          	cmp    $0x14,%r13d
 18a8b47:	4c 8d 05 72 dd 14 0d 	lea    0xd14dd72(%rip),%r8        # e9f68c0 <x86_choice_row_info>
 18a8b4e:	40 0f 92 c7          	setb   %dil
 18a8b52:	8d 3c b8             	lea    (%rax,%rdi,4),%edi
 18a8b55:	66 43 89 3c 48       	mov    %di,(%r8,%r9,2)
 18a8b5a:	41 0f b7 7b 04       	movzwl 0x4(%r11),%edi
 18a8b5f:	4c 8d 05 da 91 14 0d 	lea    0xd1491da(%rip),%r8        # e9f1d40 <x86_effects_records>
 18a8b66:	81 e7 ff 7f 00 00    	and    $0x7fff,%edi
 18a8b6c:	0f b7 3c 7b          	movzwl (%rbx,%rdi,2),%edi
 18a8b70:	c1 e7 04             	shl    $0x4,%edi
 18a8b73:	4d 8d 0c 38          	lea    (%r8,%rdi,1),%r9
 18a8b77:	42 0f b6 7c 07 0c    	movzbl 0xc(%rdi,%r8,1),%edi
 18a8b7d:	4c 89 8c 24 a0 00 00 00 	mov    %r9,0xa0(%rsp)
 18a8b85:	48 89 bc 24 10 01 00 00 	mov    %rdi,0x110(%rsp)
 18a8b8d:	40 38 d7             	cmp    %dl,%dil
 18a8b90:	75 2e                	jne    18a8bc0 <run_backend_benchmark+0x15a0>
 18a8b92:	66 83 fe ff          	cmp    $0xffff,%si
 18a8b96:	be 01 00 00 00       	mov    $0x1,%esi
 18a8b9b:	c4 e2 79 f7 c6       	shlx   %eax,%esi,%eax
 18a8ba0:	0f 94 c2             	sete   %dl
 18a8ba3:	44 39 e0             	cmp    %r12d,%eax
 18a8ba6:	40 0f 94 c6          	sete   %sil
 18a8baa:	45 38 61 0d          	cmp    %r12b,0xd(%r9)
 18a8bae:	0f 94 c0             	sete   %al
 18a8bb1:	40 20 d6             	and    %dl,%sil
 18a8bb4:	40 20 c6             	and    %al,%sil
 18a8bb7:	89 b4 24 d8 00 00 00 	mov    %esi,0xd8(%rsp)
 18a8bbe:	eb 0b                	jmp    18a8bcb <run_backend_benchmark+0x15ab>
 18a8bc0:	c7 84 24 d8 00 00 00 00 00 00 00 	movl   $0x0,0xd8(%rsp)
 18a8bcb:	48 8d 05 be d3 14 0d 	lea    0xd14d3be(%rip),%rax        # e9f5f90 <x86_choice_rows>
 18a8bd2:	49 83 c3 06          	add    $0x6,%r11
 18a8bd6:	be 3b 00 00 00       	mov    $0x3b,%esi
 18a8bdb:	bf 21 00 00 00       	mov    $0x21,%edi
 18a8be0:	44 89 a4 24 08 01 00 00 	mov    %r12d,0x108(%rsp)
 18a8be8:	44 89 ac 24 f8 00 00 00 	mov    %r13d,0xf8(%rsp)
 18a8bf0:	48 8d 04 88          	lea    (%rax,%rcx,4),%rax
 18a8bf4:	48 8b 8c 24 e8 00 00 00 	mov    0xe8(%rsp),%rcx
 18a8bfc:	4c 89 9c 24 e0 00 00 00 	mov    %r11,0xe0(%rsp)
 18a8c04:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
 18a8c09:	48 8d 05 30 dd 14 0d 	lea    0xd14dd30(%rip),%rax        # e9f6940 <x86_choice_forms_by_candidate>
 18a8c10:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
 18a8c14:	48 89 84 24 60 01 00 00 	mov    %rax,0x160(%rsp)
 18a8c1c:	48 8d 05 1d e1 14 0d 	lea    0xd14e11d(%rip),%rax        # e9f6d40 <x86_choice_conditions_by_candidate>
 18a8c23:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
 18a8c27:	48 8b 8c 24 10 01 00 00 	mov    0x110(%rsp),%rcx
 18a8c2f:	48 89 84 24 38 01 00 00 	mov    %rax,0x138(%rsp)
 18a8c37:	31 c0                	xor    %eax,%eax
 18a8c39:	84 c9                	test   %cl,%cl
 18a8c3b:	0f 95 c0             	setne  %al
 18a8c3e:	c1 e0 18             	shl    $0x18,%eax
 18a8c41:	89 44 24 40          	mov    %eax,0x40(%rsp)
 18a8c45:	8d 41 e9             	lea    -0x17(%rcx),%eax
 18a8c48:	3c 02                	cmp    $0x2,%al
 18a8c4a:	0f 93 c2             	setae  %dl
 18a8c4d:	0f 42 f7             	cmovb  %edi,%esi
 18a8c50:	c0 e2 02             	shl    $0x2,%dl
 18a8c53:	89 b4 24 58 01 00 00 	mov    %esi,0x158(%rsp)
 18a8c5a:	88 94 24 98 00 00 00 	mov    %dl,0x98(%rsp)
 18a8c61:	8d 51 e7             	lea    -0x19(%rcx),%edx
 18a8c64:	89 f1                	mov    %esi,%ecx
 18a8c66:	31 f6                	xor    %esi,%esi
 18a8c68:	80 e1 3a             	and    $0x3a,%cl
 18a8c6b:	89 54 24 58          	mov    %edx,0x58(%rsp)
 18a8c6f:	88 8c 24 50 01 00 00 	mov    %cl,0x150(%rsp)
 18a8c76:	eb 46                	jmp    18a8cbe <run_backend_benchmark+0x169e>
 18a8c78:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18a8c80:	66 ba 00 80          	mov    $0x8000,%dx
 18a8c84:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18a8c89:	48 8b 8c 24 60 01 00 00 	mov    0x160(%rsp),%rcx
 18a8c91:	66 89 3c 70          	mov    %di,(%rax,%rsi,2)
 18a8c95:	66 89 54 70 10       	mov    %dx,0x10(%rax,%rsi,2)
 18a8c9a:	48 89 f0             	mov    %rsi,%rax
 18a8c9d:	48 c1 e0 07          	shl    $0x7,%rax
 18a8ca1:	48 ff c6             	inc    %rsi
 18a8ca4:	66 89 3c 01          	mov    %di,(%rcx,%rax,1)
 18a8ca8:	48 8b bc 24 38 01 00 00 	mov    0x138(%rsp),%rdi
 18a8cb0:	66 89 14 07          	mov    %dx,(%rdi,%rax,1)
 18a8cb4:	48 83 fe 08          	cmp    $0x8,%rsi
 18a8cb8:	0f 84 b2 fd ff ff    	je     18a8a70 <run_backend_benchmark+0x1450>
 18a8cbe:	48 8d 04 76          	lea    (%rsi,%rsi,2),%rax
 18a8cc2:	41 0f b7 3c 43       	movzwl (%r11,%rax,2),%edi
 18a8cc7:	85 ff                	test   %edi,%edi
 18a8cc9:	74 b5                	je     18a8c80 <run_backend_benchmark+0x1660>
 18a8ccb:	89 f9                	mov    %edi,%ecx
 18a8ccd:	81 e1 ff 7f 00 00    	and    $0x7fff,%ecx
 18a8cd3:	ba 60 df ff ff       	mov    $0xffffdf60,%edx
 18a8cd8:	41 b8 c0 be ff ff    	mov    $0xffffbec0,%r8d
 18a8cde:	49 8d 04 43          	lea    (%r11,%rax,2),%rax
 18a8ce2:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 18a8ce7:	89 bc 24 c0 00 00 00 	mov    %edi,0xc0(%rsp)
 18a8cee:	66 81 f9 a0 20       	cmp    $0x20a0,%cx
 18a8cf3:	41 0f 42 d6          	cmovb  %r14d,%edx
 18a8cf7:	66 81 f9 40 41       	cmp    $0x4140,%cx
 18a8cfc:	41 0f 43 d0          	cmovae %r8d,%edx
 18a8d00:	01 ca                	add    %ecx,%edx
 18a8d02:	48 8d 0d 37 90 14 0d 	lea    0xd149037(%rip),%rcx        # e9f1d40 <x86_effects_records>
 18a8d09:	81 fa a0 20 00 00    	cmp    $0x20a0,%edx
 18a8d0f:	41 0f 43 d6          	cmovae %r14d,%edx
 18a8d13:	0f b7 14 53          	movzwl (%rbx,%rdx,2),%edx
 18a8d17:	c1 e2 04             	shl    $0x4,%edx
 18a8d1a:	48 01 ca             	add    %rcx,%rdx
 18a8d1d:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18a8d22:	41 83 fd 14          	cmp    $0x14,%r13d
 18a8d26:	73 38                	jae    18a8d60 <run_backend_benchmark+0x1740>
 18a8d28:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18a8d30:	44 0f b7 40 02       	movzwl 0x2(%rax),%r8d
 18a8d35:	0f b6 51 09          	movzbl 0x9(%rcx),%edx
 18a8d39:	44 0f b7 49 06       	movzwl 0x6(%rcx),%r9d
 18a8d3e:	44 89 84 24 d0 00 00 00 	mov    %r8d,0xd0(%rsp)
 18a8d46:	88 54 24 60          	mov    %dl,0x60(%rsp)
 18a8d4a:	0f b6 51 0a          	movzbl 0xa(%rcx),%edx
 18a8d4e:	41 f6 c0 20          	test   $0x20,%r8b
 18a8d52:	0f 85 e6 00 00 00    	jne    18a8e3e <run_backend_benchmark+0x181e>
 18a8d58:	0f b6 74 24 60       	movzbl 0x60(%rsp),%esi
 18a8d5d:	eb 21                	jmp    18a8d80 <run_backend_benchmark+0x1760>
 18a8d5f:	90                   	nop
 18a8d60:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18a8d68:	44 0f b7 49 06       	movzwl 0x6(%rcx),%r9d
 18a8d6d:	0f b6 71 09          	movzbl 0x9(%rcx),%esi
 18a8d71:	0f b6 51 0a          	movzbl 0xa(%rcx),%edx
 18a8d75:	0f b7 48 02          	movzwl 0x2(%rax),%ecx
 18a8d79:	89 8c 24 d0 00 00 00 	mov    %ecx,0xd0(%rsp)
 18a8d80:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
 18a8d85:	0f b6 ca             	movzbl %dl,%ecx
 18a8d88:	41 83 e1 20          	and    $0x20,%r9d
 18a8d8c:	40 0f b6 f6          	movzbl %sil,%esi
 18a8d90:	0f b6 40 04          	movzbl 0x4(%rax),%eax
 18a8d94:	89 ca                	mov    %ecx,%edx
 18a8d96:	c1 e2 10             	shl    $0x10,%edx
 18a8d99:	45 85 c9             	test   %r9d,%r9d
 18a8d9c:	41 0f 44 d1          	cmove  %r9d,%edx
 18a8da0:	03 54 24 40          	add    0x40(%rsp),%edx
 18a8da4:	c1 e1 08             	shl    $0x8,%ecx
 18a8da7:	41 0f b6 7f 0a       	movzbl 0xa(%r15),%edi
 18a8dac:	45 0f b6 57 0c       	movzbl 0xc(%r15),%r10d
 18a8db1:	09 d1                	or     %edx,%ecx
 18a8db3:	09 ce                	or     %ecx,%esi
 18a8db5:	41 89 f8             	mov    %edi,%r8d
 18a8db8:	41 c1 e0 10          	shl    $0x10,%r8d
 18a8dbc:	41 f6 47 06 20       	testb  $0x20,0x6(%r15)
 18a8dc1:	45 0f 44 c6          	cmove  %r14d,%r8d
 18a8dc5:	45 31 c9             	xor    %r9d,%r9d
 18a8dc8:	45 84 d2             	test   %r10b,%r10b
 18a8dcb:	41 0f 95 c1          	setne  %r9b
 18a8dcf:	c1 e7 08             	shl    $0x8,%edi
 18a8dd2:	c1 ea 10             	shr    $0x10,%edx
 18a8dd5:	44 09 c7             	or     %r8d,%edi
 18a8dd8:	45 0f b6 47 09       	movzbl 0x9(%r15),%r8d
 18a8ddd:	41 c1 e1 18          	shl    $0x18,%r9d
 18a8de1:	44 09 cf             	or     %r9d,%edi
 18a8de4:	41 89 f1             	mov    %esi,%r9d
 18a8de7:	41 09 f8             	or     %edi,%r8d
 18a8dea:	09 cf                	or     %ecx,%edi
 18a8dec:	c1 e9 08             	shr    $0x8,%ecx
 18a8def:	45 09 c1             	or     %r8d,%r9d
 18a8df2:	c1 ef 08             	shr    $0x8,%edi
 18a8df5:	c4 e2 68 f2 c9       	andn   %ecx,%edx,%ecx
 18a8dfa:	41 21 f0             	and    %esi,%r8d
 18a8dfd:	41 09 f9             	or     %edi,%r9d
 18a8e00:	41 f7 d1             	not    %r9d
 18a8e03:	41 09 c9             	or     %ecx,%r9d
 18a8e06:	44 89 c1             	mov    %r8d,%ecx
 18a8e09:	41 c1 e8 10          	shr    $0x10,%r8d
 18a8e0d:	20 c1                	and    %al,%cl
 18a8e0f:	41 20 c0             	and    %al,%r8b
 18a8e12:	0f b6 c9             	movzbl %cl,%ecx
 18a8e15:	41 0f b6 c0          	movzbl %r8b,%eax
 18a8e19:	44 09 c9             	or     %r9d,%ecx
 18a8e1c:	09 c8                	or     %ecx,%eax
 18a8e1e:	b9 3f 00 00 00       	mov    $0x3f,%ecx
 18a8e23:	f7 d0                	not    %eax
 18a8e25:	83 e0 3f             	and    $0x3f,%eax
 18a8e28:	45 84 d2             	test   %r10b,%r10b
 18a8e2b:	0f 44 c1             	cmove  %ecx,%eax
 18a8e2e:	80 bc 24 10 01 00 00 00 	cmpb   $0x0,0x110(%rsp)
 18a8e36:	0f 44 c1             	cmove  %ecx,%eax
 18a8e39:	e9 55 02 00 00       	jmp    18a9093 <run_backend_benchmark+0x1a73>
 18a8e3e:	0f b6 70 04          	movzbl 0x4(%rax),%esi
 18a8e42:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18a8e47:	45 31 e4             	xor    %r12d,%r12d
 18a8e4a:	44 0f b6 5c 24 60    	movzbl 0x60(%rsp),%r11d
 18a8e50:	41 b8 3b 00 00 00    	mov    $0x3b,%r8d
 18a8e56:	0f b6 48 09          	movzbl 0x9(%rax),%ecx
 18a8e5a:	0f b6 58 0a          	movzbl 0xa(%rax),%ebx
 18a8e5e:	88 8c 24 b0 00 00 00 	mov    %cl,0xb0(%rsp)
 18a8e65:	0f b7 48 06          	movzwl 0x6(%rax),%ecx
 18a8e69:	89 8c 24 80 00 00 00 	mov    %ecx,0x80(%rsp)
 18a8e70:	0f b6 48 0c          	movzbl 0xc(%rax),%ecx
 18a8e74:	84 c9                	test   %cl,%cl
 18a8e76:	8d 41 e9             	lea    -0x17(%rcx),%eax
 18a8e79:	48 89 8c 24 00 01 00 00 	mov    %rcx,0x100(%rsp)
 18a8e81:	41 0f 95 c4          	setne  %r12b
 18a8e85:	41 c1 e4 18          	shl    $0x18,%r12d
 18a8e89:	3c 02                	cmp    $0x2,%al
 18a8e8b:	b8 21 00 00 00       	mov    $0x21,%eax
 18a8e90:	44 0f 42 c0          	cmovb  %eax,%r8d
 18a8e94:	8d 41 e7             	lea    -0x19(%rcx),%eax
 18a8e97:	40 0f 93 c7          	setae  %dil
 18a8e9b:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
 18a8ea2:	44 89 c0             	mov    %r8d,%eax
 18a8ea5:	40 c0 e7 02          	shl    $0x2,%dil
 18a8ea9:	44 89 84 24 30 01 00 00 	mov    %r8d,0x130(%rsp)
 18a8eb1:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 18a8eb7:	24 3a                	and    $0x3a,%al
 18a8eb9:	40 88 7c 24 78       	mov    %dil,0x78(%rsp)
 18a8ebe:	88 84 24 f0 00 00 00 	mov    %al,0xf0(%rsp)
 18a8ec5:	31 c0                	xor    %eax,%eax
 18a8ec7:	eb 23                	jmp    18a8eec <run_backend_benchmark+0x18cc>
 18a8ec9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18a8ed0:	44 0f b6 5c 24 60    	movzbl 0x60(%rsp),%r11d
 18a8ed6:	09 c8                	or     %ecx,%eax
 18a8ed8:	43 8d 0c 00          	lea    (%r8,%r8,1),%ecx
 18a8edc:	45 89 f1             	mov    %r14d,%r9d
 18a8edf:	41 83 f8 11          	cmp    $0x11,%r8d
 18a8ee3:	41 89 c8             	mov    %ecx,%r8d
 18a8ee6:	0f 83 7d 01 00 00    	jae    18a9069 <run_backend_benchmark+0x1a49>
 18a8eec:	44 8b 54 24 40       	mov    0x40(%rsp),%r10d
 18a8ef1:	44 89 df             	mov    %r11d,%edi
 18a8ef4:	41 89 d5             	mov    %edx,%r13d
 18a8ef7:	45 89 ce             	mov    %r9d,%r14d
 18a8efa:	41 f6 c1 20          	test   $0x20,%r9b
 18a8efe:	74 5e                	je     18a8f5e <run_backend_benchmark+0x193e>
 18a8f00:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 18a8f08:	89 d1                	mov    %edx,%ecx
 18a8f0a:	41 89 d5             	mov    %edx,%r13d
 18a8f0d:	44 89 df             	mov    %r11d,%edi
 18a8f10:	45 0f b6 4a 0f       	movzbl 0xf(%r10),%r9d
 18a8f15:	41 80 e1 0f          	and    $0xf,%r9b
 18a8f19:	41 80 f9 02          	cmp    $0x2,%r9b
 18a8f1d:	75 32                	jne    18a8f51 <run_backend_benchmark+0x1931>
 18a8f1f:	80 7c 24 58 02       	cmpb   $0x2,0x58(%rsp)
 18a8f24:	0f 92 c1             	setb   %cl
 18a8f27:	41 80 7a 0d 00       	cmpb   $0x0,0xd(%r10)
 18a8f2c:	41 0f 94 c5          	sete   %r13b
 18a8f30:	41 20 cd             	and    %cl,%r13b
 18a8f33:	75 0a                	jne    18a8f3f <run_backend_benchmark+0x191f>
 18a8f35:	0f b6 bc 24 58 01 00 00 	movzbl 0x158(%rsp),%edi
 18a8f3d:	eb 08                	jmp    18a8f47 <run_backend_benchmark+0x1927>
 18a8f3f:	0f b6 bc 24 50 01 00 00 	movzbl 0x150(%rsp),%edi
 18a8f47:	44 02 ac 24 98 00 00 00 	add    0x98(%rsp),%r13b
 18a8f4f:	31 c9                	xor    %ecx,%ecx
 18a8f51:	44 0f b6 d1          	movzbl %cl,%r10d
 18a8f55:	41 c1 e2 10          	shl    $0x10,%r10d
 18a8f59:	44 03 54 24 40       	add    0x40(%rsp),%r10d
 18a8f5e:	f6 84 24 80 00 00 00 20 	testb  $0x20,0x80(%rsp)
 18a8f66:	41 89 df             	mov    %ebx,%r15d
 18a8f69:	0f b6 8c 24 b0 00 00 00 	movzbl 0xb0(%rsp),%ecx
 18a8f71:	45 89 e1             	mov    %r12d,%r9d
 18a8f74:	74 65                	je     18a8fdb <run_backend_benchmark+0x19bb>
 18a8f76:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18a8f7b:	41 89 d9             	mov    %ebx,%r9d
 18a8f7e:	41 89 df             	mov    %ebx,%r15d
 18a8f81:	44 0f b6 59 0f       	movzbl 0xf(%rcx),%r11d
 18a8f86:	0f b6 8c 24 b0 00 00 00 	movzbl 0xb0(%rsp),%ecx
 18a8f8e:	41 80 e3 0f          	and    $0xf,%r11b
 18a8f92:	41 80 fb 02          	cmp    $0x2,%r11b
 18a8f96:	75 38                	jne    18a8fd0 <run_backend_benchmark+0x19b0>
 18a8f98:	80 bc 24 90 00 00 00 02 	cmpb   $0x2,0x90(%rsp)
 18a8fa0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18a8fa5:	0f 92 c1             	setb   %cl
 18a8fa8:	41 80 79 0d 00       	cmpb   $0x0,0xd(%r9)
 18a8fad:	41 0f 94 c7          	sete   %r15b
 18a8fb1:	41 20 cf             	and    %cl,%r15b
 18a8fb4:	75 0a                	jne    18a8fc0 <run_backend_benchmark+0x19a0>
 18a8fb6:	0f b6 8c 24 30 01 00 00 	movzbl 0x130(%rsp),%ecx
 18a8fbe:	eb 08                	jmp    18a8fc8 <run_backend_benchmark+0x19a8>
 18a8fc0:	0f b6 8c 24 f0 00 00 00 	movzbl 0xf0(%rsp),%ecx
 18a8fc8:	44 02 7c 24 78       	add    0x78(%rsp),%r15b
 18a8fcd:	45 31 c9             	xor    %r9d,%r9d
 18a8fd0:	45 0f b6 c9          	movzbl %r9b,%r9d
 18a8fd4:	41 c1 e1 10          	shl    $0x10,%r9d
 18a8fd8:	45 09 e1             	or     %r12d,%r9d
 18a8fdb:	45 0f b6 dd          	movzbl %r13b,%r11d
 18a8fdf:	45 0f b6 ff          	movzbl %r15b,%r15d
 18a8fe3:	40 0f b6 ff          	movzbl %dil,%edi
 18a8fe7:	0f b6 c9             	movzbl %cl,%ecx
 18a8fea:	45 89 d5             	mov    %r10d,%r13d
 18a8fed:	41 c1 ed 10          	shr    $0x10,%r13d
 18a8ff1:	41 c1 e3 08          	shl    $0x8,%r11d
 18a8ff5:	41 c1 e7 08          	shl    $0x8,%r15d
 18a8ff9:	45 01 d3             	add    %r10d,%r11d
 18a8ffc:	45 01 cf             	add    %r9d,%r15d
 18a8fff:	44 09 f9             	or     %r15d,%ecx
 18a9002:	45 09 df             	or     %r11d,%r15d
 18a9005:	44 09 df             	or     %r11d,%edi
 18a9008:	41 c1 eb 08          	shr    $0x8,%r11d
 18a900c:	c4 42 10 f2 db       	andn   %r11d,%r13d,%r11d
 18a9011:	41 89 fd             	mov    %edi,%r13d
 18a9014:	41 09 cd             	or     %ecx,%r13d
 18a9017:	41 c1 ef 08          	shr    $0x8,%r15d
 18a901b:	21 f9                	and    %edi,%ecx
 18a901d:	89 f7                	mov    %esi,%edi
 18a901f:	45 09 fd             	or     %r15d,%r13d
 18a9022:	40 20 cf             	and    %cl,%dil
 18a9025:	c1 e9 10             	shr    $0x10,%ecx
 18a9028:	41 f7 d5             	not    %r13d
 18a902b:	40 20 f1             	and    %sil,%cl
 18a902e:	40 0f b6 ff          	movzbl %dil,%edi
 18a9032:	45 09 dd             	or     %r11d,%r13d
 18a9035:	0f b6 c9             	movzbl %cl,%ecx
 18a9038:	44 09 ef             	or     %r13d,%edi
 18a903b:	09 f9                	or     %edi,%ecx
 18a903d:	41 f7 c1 00 00 00 01 	test   $0x1000000,%r9d
 18a9044:	bf 3f 00 00 00       	mov    $0x3f,%edi
 18a9049:	f7 d1                	not    %ecx
 18a904b:	0f 44 cf             	cmove  %edi,%ecx
 18a904e:	41 f7 c2 00 00 00 01 	test   $0x1000000,%r10d
 18a9055:	0f 44 cf             	cmove  %edi,%ecx
 18a9058:	44 21 c1             	and    %r8d,%ecx
 18a905b:	0f 84 6f fe ff ff    	je     18a8ed0 <run_backend_benchmark+0x18b0>
 18a9061:	44 89 c1             	mov    %r8d,%ecx
 18a9064:	e9 67 fe ff ff       	jmp    18a8ed0 <run_backend_benchmark+0x18b0>
 18a9069:	4c 8b 9c 24 e0 00 00 00 	mov    0xe0(%rsp),%r11
 18a9071:	44 8b a4 24 08 01 00 00 	mov    0x108(%rsp),%r12d
 18a9079:	44 8b ac 24 f8 00 00 00 	mov    0xf8(%rsp),%r13d
 18a9081:	4c 8b 94 24 00 01 00 00 	mov    0x100(%rsp),%r10
 18a9089:	48 8d 1d 70 4b 14 0d 	lea    0xd144b70(%rip),%rbx        # e9edc00 <x86_effects_index>
 18a9090:	45 31 f6             	xor    %r14d,%r14d
 18a9093:	31 c9                	xor    %ecx,%ecx
 18a9095:	a9 ea ff ff ff       	test   $0xffffffea,%eax
 18a909a:	0f 95 c2             	setne  %dl
 18a909d:	45 84 d2             	test   %r10b,%r10b
 18a90a0:	74 19                	je     18a90bb <run_backend_benchmark+0x1a9b>
 18a90a2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
 18a90a7:	0f b6 76 0f          	movzbl 0xf(%rsi),%esi
 18a90ab:	40 80 e6 0f          	and    $0xf,%sil
 18a90af:	74 17                	je     18a90c8 <run_backend_benchmark+0x1aa8>
 18a90b1:	40 3a b4 24 28 01 00 00 	cmp    0x128(%rsp),%sil
 18a90b9:	74 0d                	je     18a90c8 <run_backend_benchmark+0x1aa8>
 18a90bb:	c7 84 24 d8 00 00 00 00 00 00 00 	movl   $0x0,0xd8(%rsp)
 18a90c6:	eb 1e                	jmp    18a90e6 <run_backend_benchmark+0x1ac6>
 18a90c8:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
 18a90cd:	8b bc 24 d8 00 00 00 	mov    0xd8(%rsp),%edi
 18a90d4:	44 38 66 0d          	cmp    %r12b,0xd(%rsi)
 18a90d8:	40 0f 96 c6          	setbe  %sil
 18a90dc:	40 20 f7             	and    %sil,%dil
 18a90df:	89 bc 24 d8 00 00 00 	mov    %edi,0xd8(%rsp)
 18a90e6:	89 c6                	mov    %eax,%esi
 18a90e8:	89 c7                	mov    %eax,%edi
 18a90ea:	83 e6 01             	and    $0x1,%esi
 18a90ed:	83 e7 04             	and    $0x4,%edi
 18a90f0:	88 d1                	mov    %dl,%cl
 18a90f2:	83 e0 10             	and    $0x10,%eax
 18a90f5:	8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%edx
 18a90fc:	c1 e6 0b             	shl    $0xb,%esi
 18a90ff:	c1 e7 0a             	shl    $0xa,%edi
 18a9102:	c1 e0 09             	shl    $0x9,%eax
 18a9105:	c1 e1 0e             	shl    $0xe,%ecx
 18a9108:	09 f7                	or     %esi,%edi
 18a910a:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
 18a910f:	09 f8                	or     %edi,%eax
 18a9111:	8b bc 24 c0 00 00 00 	mov    0xc0(%rsp),%edi
 18a9118:	09 c1                	or     %eax,%ecx
 18a911a:	09 ca                	or     %ecx,%edx
 18a911c:	81 ca 80 00 00 00    	or     $0x80,%edx
 18a9122:	e9 5d fb ff ff       	jmp    18a8c84 <run_backend_benchmark+0x1664>
 18a9127:	89 d1                	mov    %edx,%ecx
 18a9129:	f6 c1 01             	test   $0x1,%cl
 18a912c:	0f 84 14 78 00 00    	je     18b0946 <run_backend_benchmark+0x9326>
 18a9132:	80 3d 07 e0 14 0d 00 	cmpb   $0x0,0xd14e007(%rip)        # e9f7140 <tier0_initialized>
 18a9139:	0f 85 94 37 00 00    	jne    18ac8d3 <run_backend_benchmark+0x52b3>
 18a913f:	48 8d 3d 0a e0 14 0d 	lea    0xd14e00a(%rip),%rdi        # e9f7150 <tier0_slot_bases>
 18a9146:	ba 00 08 00 00       	mov    $0x800,%edx
 18a914b:	31 f6                	xor    %esi,%esi
 18a914d:	c5 f8 77             	vzeroupper
 18a9150:	e8 db b1 eb fe       	call   764330 <memset@plt>
 18a9155:	62 f1 7c 48 28 0d a1 6d c7 fe 	vmovaps -0x138925f(%rip),%zmm1        # 51ff00 <branch_sizing_patterns+0x170>
 18a915f:	62 f3 7d 48 25 c0 ff 	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
 18a9166:	62 f1 fd 48 6f 15 d0 6d c7 fe 	vmovdqa64 -0x1389230(%rip),%zmm2        # 51ff40 <branch_sizing_patterns+0x1b0>
 18a9170:	c7 05 d6 e7 14 0d 00 00 00 00 	movl   $0x0,0xd14e7d6(%rip)        # e9f7950 <tier0_template_count>
 18a917a:	c6 05 ff e8 14 0d 01 	movb   $0x1,0xd14e8ff(%rip)        # e9f7a80 <tier0_builder+0x100>
 18a9181:	c7 05 35 69 15 0d 20 00 00 00 	movl   $0x20,0xd156935(%rip)        # e9ffac0 <tier0_slot_count>
 18a918b:	62 f1 fe 48 7f 05 2b e9 14 0d 	vmovdqu64 %zmm0,0xd14e92b(%rip)        # e9f7ac0 <tier0_slots>
 18a9195:	c4 e2 79 22 05 22 72 c7 fe 	vpmovsxbq -0x1388dde(%rip),%xmm0        # 5203c0 <branch_sizing_patterns+0x630>
 18a919e:	62 f1 7c 48 29 0d 58 a9 16 0d 	vmovaps %zmm1,0xd16a958(%rip)        # ea13b00 <tier0_integer_window>
 18a91a8:	62 f1 fd 48 6f 0d ce 6d c7 fe 	vmovdqa64 -0x1389232(%rip),%zmm1        # 51ff80 <branch_sizing_patterns+0x1f0>
 18a91b2:	62 f1 fd 48 7f 15 c4 a9 16 0d 	vmovdqa64 %zmm2,0xd16a9c4(%rip)        # ea13b80 <tier0_floating_window>
 18a91bc:	62 f1 fd 48 7f 05 7a a9 16 0d 	vmovdqa64 %zmm0,0xd16a97a(%rip)        # ea13b40 <tier0_integer_window+0x40>
 18a91c6:	62 f1 fd 48 7f 0d f0 a9 16 0d 	vmovdqa64 %zmm1,0xd16a9f0(%rip)        # ea13bc0 <tier0_floating_window+0x40>
 18a91d0:	c5 f8 77             	vzeroupper
 18a91d3:	e8 98 1c 01 00       	call   18bae70 <tier0_define_templates>
 18a91d8:	8b 05 e2 68 15 0d    	mov    0xd1568e2(%rip),%eax        # e9ffac0 <tier0_slot_count>
 18a91de:	48 85 c0             	test   %rax,%rax
 18a91e1:	0f 84 4d 01 00 00    	je     18a9334 <run_backend_benchmark+0x1d14>
 18a91e7:	48 01 c0             	add    %rax,%rax
 18a91ea:	48 8d 15 cf e8 14 0d 	lea    0xd14e8cf(%rip),%rdx        # e9f7ac0 <tier0_slots>
 18a91f1:	48 8d 35 d8 68 15 0d 	lea    0xd1568d8(%rip),%rsi        # e9ffad0 <tier0_template_infos>
 18a91f8:	31 c9                	xor    %ecx,%ecx
 18a91fa:	eb 11                	jmp    18a920d <run_backend_benchmark+0x1bed>
 18a91fc:	0f 1f 40 00          	nopl   0x0(%rax)
 18a9200:	48 83 c1 02          	add    $0x2,%rcx
 18a9204:	48 39 c8             	cmp    %rcx,%rax
 18a9207:	0f 84 27 01 00 00    	je     18a9334 <run_backend_benchmark+0x1d14>
 18a920d:	0f b7 3c 11          	movzwl (%rcx,%rdx,1),%edi
 18a9211:	66 83 ff fd          	cmp    $0xfffd,%di
 18a9215:	7f e9                	jg     18a9200 <run_backend_benchmark+0x1be0>
 18a9217:	81 e7 ff 7f 00 00    	and    $0x7fff,%edi
 18a921d:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
 18a9221:	44 0f b6 4c fe 13    	movzbl 0x13(%rsi,%rdi,8),%r9d
 18a9227:	44 0f b6 54 fe 3b    	movzbl 0x3b(%rsi,%rdi,8),%r10d
 18a922d:	45 89 c8             	mov    %r9d,%r8d
 18a9230:	45 89 d3             	mov    %r10d,%r11d
 18a9233:	41 c0 e8 02          	shr    $0x2,%r8b
 18a9237:	41 c0 eb 02          	shr    $0x2,%r11b
 18a923b:	41 80 e0 03          	and    $0x3,%r8b
 18a923f:	41 80 e3 03          	and    $0x3,%r11b
 18a9243:	41 0f b6 d8          	movzbl %r8b,%ebx
 18a9247:	45 0f b6 c3          	movzbl %r11b,%r8d
 18a924b:	44 38 c3             	cmp    %r8b,%bl
 18a924e:	44 0f 47 c3          	cmova  %ebx,%r8d
 18a9252:	41 80 e1 03          	and    $0x3,%r9b
 18a9256:	41 80 e2 03          	and    $0x3,%r10b
 18a925a:	45 0f b6 d9          	movzbl %r9b,%r11d
 18a925e:	45 0f b6 ca          	movzbl %r10b,%r9d
 18a9262:	44 8b 54 fe 40       	mov    0x40(%rsi,%rdi,8),%r10d
 18a9267:	45 38 cb             	cmp    %r9b,%r11b
 18a926a:	45 0f 47 cb          	cmova  %r11d,%r9d
 18a926e:	44 0f b6 5c fe 63    	movzbl 0x63(%rsi,%rdi,8),%r11d
 18a9274:	44 0b 54 fe 18       	or     0x18(%rsi,%rdi,8),%r10d
 18a9279:	44 89 db             	mov    %r11d,%ebx
 18a927c:	c0 eb 02             	shr    $0x2,%bl
 18a927f:	80 e3 03             	and    $0x3,%bl
 18a9282:	0f b6 db             	movzbl %bl,%ebx
 18a9285:	41 38 d8             	cmp    %bl,%r8b
 18a9288:	44 0f 46 c3          	cmovbe %ebx,%r8d
 18a928c:	41 80 e3 03          	and    $0x3,%r11b
 18a9290:	45 0f b6 db          	movzbl %r11b,%r11d
 18a9294:	45 38 d9             	cmp    %r11b,%r9b
 18a9297:	45 0f 46 cb          	cmovbe %r11d,%r9d
 18a929b:	44 0f b7 5c fe 0d    	movzwl 0xd(%rsi,%rdi,8),%r11d
 18a92a1:	44 0b 54 fe 68       	or     0x68(%rsi,%rdi,8),%r10d
 18a92a6:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 18a92ab:	44 0f b7 5c fe 35    	movzwl 0x35(%rsi,%rdi,8),%r11d
 18a92b1:	c4 c1 79 6e cb       	vmovd  %r11d,%xmm1
 18a92b6:	44 0f b7 5c fe 5d    	movzwl 0x5d(%rsi,%rdi,8),%r11d
 18a92bc:	c5 f1 de c0          	vpmaxub %xmm0,%xmm1,%xmm0
 18a92c0:	c4 c1 79 6e cb       	vmovd  %r11d,%xmm1
 18a92c5:	44 0f b7 9c fe 85 00 00 00 	movzwl 0x85(%rsi,%rdi,8),%r11d
 18a92ce:	c4 c1 79 6e d3       	vmovd  %r11d,%xmm2
 18a92d3:	c5 e9 de c9          	vpmaxub %xmm1,%xmm2,%xmm1
 18a92d7:	c5 f1 de c0          	vpmaxub %xmm0,%xmm1,%xmm0
 18a92db:	c4 e3 79 14 44 fe 0d 00 	vpextrb $0x0,%xmm0,0xd(%rsi,%rdi,8)
 18a92e3:	c4 e3 79 14 44 fe 0e 01 	vpextrb $0x1,%xmm0,0xe(%rsi,%rdi,8)
 18a92eb:	44 0f b6 9c fe 8b 00 00 00 	movzbl 0x8b(%rsi,%rdi,8),%r11d
 18a92f4:	44 89 db             	mov    %r11d,%ebx
 18a92f7:	c0 eb 02             	shr    $0x2,%bl
 18a92fa:	80 e3 03             	and    $0x3,%bl
 18a92fd:	0f b6 db             	movzbl %bl,%ebx
 18a9300:	41 38 d8             	cmp    %bl,%r8b
 18a9303:	44 0f 46 c3          	cmovbe %ebx,%r8d
 18a9307:	41 80 e3 03          	and    $0x3,%r11b
 18a930b:	45 0f b6 db          	movzbl %r11b,%r11d
 18a930f:	45 38 d9             	cmp    %r11b,%r9b
 18a9312:	45 0f 46 cb          	cmovbe %r11d,%r9d
 18a9316:	41 c0 e0 02          	shl    $0x2,%r8b
 18a931a:	45 08 c8             	or     %r9b,%r8b
 18a931d:	44 88 44 fe 13       	mov    %r8b,0x13(%rsi,%rdi,8)
 18a9322:	44 0b 94 fe 90 00 00 00 	or     0x90(%rsi,%rdi,8),%r10d
 18a932a:	44 89 54 fe 18       	mov    %r10d,0x18(%rsi,%rdi,8)
 18a932f:	e9 cc fe ff ff       	jmp    18a9200 <run_backend_benchmark+0x1be0>
 18a9334:	80 3d 45 e7 14 0d 00 	cmpb   $0x0,0xd14e745(%rip)        # e9f7a80 <tier0_builder+0x100>
 18a933b:	0f 84 fe 75 00 00    	je     18b093f <run_backend_benchmark+0x931f>
 18a9341:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18a9345:	62 f1 fd 48 7f 44 24 37 	vmovdqa64 %zmm0,0xdc0(%rsp)
 18a934d:	62 f1 fd 48 7f 44 24 36 	vmovdqa64 %zmm0,0xd80(%rsp)
 18a9355:	62 f1 fd 48 7f 44 24 35 	vmovdqa64 %zmm0,0xd40(%rsp)
 18a935d:	62 f1 fd 48 7f 44 24 34 	vmovdqa64 %zmm0,0xd00(%rsp)
 18a9365:	c4 e2 79 20 05 7a 6d cd fe 	vpmovsxbw -0x1329286(%rip),%xmm0        # 5800e8 <x86_semantics_benchmark_code.registers+0xf8>
 18a936e:	c4 e2 79 20 0d 79 6d cd fe 	vpmovsxbw -0x1329287(%rip),%xmm1        # 5800f0 <x86_semantics_benchmark_code.registers+0x100>
 18a9377:	c5 f9 6e 1d 91 c7 cc fe 	vmovd  -0x133386f(%rip),%xmm3        # 575b10 <x86_effects_unknown+0xb0>
 18a937f:	b0 01                	mov    $0x1,%al
 18a9381:	48 8d 15 c8 dd 14 0d 	lea    0xd14ddc8(%rip),%rdx        # e9f7150 <tier0_slot_bases>
 18a9388:	b9 01 00 00 00       	mov    $0x1,%ecx
 18a938d:	c5 e9 76 d2          	vpcmpeqd %xmm2,%xmm2,%xmm2
 18a9391:	45 31 db             	xor    %r11d,%r11d
 18a9394:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 18a9398:	45 31 d2             	xor    %r10d,%r10d
 18a939b:	89 44 24 30          	mov    %eax,0x30(%rsp)
 18a939f:	48 8d 05 1a e7 14 0d 	lea    0xd14e71a(%rip),%rax        # e9f7ac0 <tier0_slots>
 18a93a6:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 18a93ab:	eb 40                	jmp    18a93ed <run_backend_benchmark+0x1dcd>
 18a93ad:	0f 1f 00             	nopl   (%rax)
 18a93b0:	c5 f9 6f ac 24 80 02 00 00 	vmovdqa 0x280(%rsp),%xmm5
 18a93b9:	48 c1 e6 04          	shl    $0x4,%rsi
 18a93bd:	ff c1                	inc    %ecx
 18a93bf:	c5 f9 7f ac 34 00 0d 00 00 	vmovdqa %xmm5,0xd00(%rsp,%rsi,1)
 18a93c8:	83 fa 10             	cmp    $0x10,%edx
 18a93cb:	48 8d 35 ae a9 20 0d 	lea    0xd20a9ae(%rip),%rsi        # eab3d80 <tier0_vector_rows>
 18a93d2:	41 0f 43 d3          	cmovae %r11d,%edx
 18a93d6:	48 83 44 24 40 20    	addq   $0x20,0x40(%rsp)
 18a93dc:	41 88 14 32          	mov    %dl,(%r10,%rsi,1)
 18a93e0:	49 ff c2             	inc    %r10
 18a93e3:	49 83 fa 40          	cmp    $0x40,%r10
 18a93e7:	0f 84 d9 03 00 00    	je     18a97c6 <run_backend_benchmark+0x21a6>
 18a93ed:	48 be 80 ff ff ff bb 37 33 03 	movabs $0x33337bbffffff80,%rsi
 18a93f7:	4b 8d 14 52          	lea    (%r10,%r10,2),%rdx
 18a93fb:	4c 8d 05 9e b0 c7 fe 	lea    -0x1384f62(%rip),%r8        # 5244a0 <tier0_shapes>
 18a9402:	45 8d 4a ed          	lea    -0x13(%r10),%r9d
 18a9406:	41 8d 5a e2          	lea    -0x1e(%r10),%ebx
 18a940a:	46 8d 34 d5 10 ff ff ff 	lea    -0xf0(,%r10,8),%r14d
 18a9412:	45 8d 7a f5          	lea    -0xb(%r10),%r15d
 18a9416:	45 8d 62 f0          	lea    -0x10(%r10),%r12d
 18a941a:	4c 0f a3 d6          	bt     %r10,%rsi
 18a941e:	40 0f 92 c6          	setb   %sil
 18a9422:	41 0f b6 7c 10 02    	movzbl 0x2(%r8,%rdx,1),%edi
 18a9428:	40 c0 e6 02          	shl    $0x2,%sil
 18a942c:	41 0a 34 10          	or     (%r8,%rdx,1),%sil
 18a9430:	41 8d 52 ea          	lea    -0x16(%r10),%edx
 18a9434:	45 89 d0             	mov    %r10d,%r8d
 18a9437:	89 94 24 b0 00 00 00 	mov    %edx,0xb0(%rsp)
 18a943e:	40 c0 e7 03          	shl    $0x3,%dil
 18a9442:	40 08 f7             	or     %sil,%dil
 18a9445:	83 fa 06             	cmp    $0x6,%edx
 18a9448:	0f 92 c2             	setb   %dl
 18a944b:	41 83 e0 3e          	and    $0x3e,%r8d
 18a944f:	41 83 f8 24          	cmp    $0x24,%r8d
 18a9453:	40 0f 94 c6          	sete   %sil
 18a9457:	40 00 f6             	add    %sil,%sil
 18a945a:	41 83 f9 02          	cmp    $0x2,%r9d
 18a945e:	41 0f 92 c1          	setb   %r9b
 18a9462:	41 c0 e1 02          	shl    $0x2,%r9b
 18a9466:	83 fb 06             	cmp    $0x6,%ebx
 18a9469:	48 bb 08 00 08 00 00 08 00 00 	movabs $0x80000080008,%rbx
 18a9473:	c4 e2 8b f7 db       	shrx   %r14,%rbx,%rbx
 18a9478:	41 0f 43 db          	cmovae %r11d,%ebx
 18a947c:	49 83 fa 0d          	cmp    $0xd,%r10
 18a9480:	41 0f 94 c6          	sete   %r14b
 18a9484:	41 08 d6             	or     %dl,%r14b
 18a9487:	41 c0 e6 04          	shl    $0x4,%r14b
 18a948b:	41 83 ff 02          	cmp    $0x2,%r15d
 18a948f:	41 0f 92 c7          	setb   %r15b
 18a9493:	41 83 fc 05          	cmp    $0x5,%r12d
 18a9497:	41 0f 92 c4          	setb   %r12b
 18a949b:	45 08 fc             	or     %r15b,%r12b
 18a949e:	45 89 d7             	mov    %r10d,%r15d
 18a94a1:	41 83 e7 3c          	and    $0x3c,%r15d
 18a94a5:	41 c0 e4 05          	shl    $0x5,%r12b
 18a94a9:	41 83 ff 24          	cmp    $0x24,%r15d
 18a94ad:	41 0f 94 c7          	sete   %r15b
 18a94b1:	41 c0 e7 06          	shl    $0x6,%r15b
 18a94b5:	45 08 cf             	or     %r9b,%r15b
 18a94b8:	41 08 f7             	or     %sil,%r15b
 18a94bb:	41 08 d7             	or     %dl,%r15b
 18a94be:	48 8d 15 3b a7 20 0d 	lea    0xd20a73b(%rip),%rdx        # eab3c00 <tier0_vector_shapes>
 18a94c5:	45 08 e7             	or     %r12b,%r15b
 18a94c8:	41 88 3c 12          	mov    %dil,(%r10,%rdx,1)
 18a94cc:	48 8d 3d ad a7 20 0d 	lea    0xd20a7ad(%rip),%rdi        # eab3c80 <tier0_vector_accesses>
 18a94d3:	48 8d 15 66 a7 20 0d 	lea    0xd20a766(%rip),%rdx        # eab3c40 <tier0_vector_kind_flags>
 18a94da:	45 08 f7             	or     %r14b,%r15b
 18a94dd:	45 88 14 3a          	mov    %r10b,(%r10,%rdi,1)
 18a94e1:	41 08 df             	or     %bl,%r15b
 18a94e4:	45 88 3c 12          	mov    %r15b,(%r10,%rdx,1)
 18a94e8:	41 83 f8 04          	cmp    $0x4,%r8d
 18a94ec:	74 06                	je     18a94f4 <run_backend_benchmark+0x1ed4>
 18a94ee:	41 83 f8 20          	cmp    $0x20,%r8d
 18a94f2:	75 2c                	jne    18a9520 <run_backend_benchmark+0x1f00>
 18a94f4:	44 89 d2             	mov    %r10d,%edx
 18a94f7:	44 89 d6             	mov    %r10d,%esi
 18a94fa:	c1 ee 04             	shr    $0x4,%esi
 18a94fd:	83 e2 01             	and    $0x1,%edx
 18a9500:	01 f2                	add    %esi,%edx
 18a9502:	8d 72 2e             	lea    0x2e(%rdx),%esi
 18a9505:	41 88 74 3a 40       	mov    %sil,0x40(%r10,%rdi,1)
 18a950a:	8d 72 32             	lea    0x32(%rdx),%esi
 18a950d:	80 c2 36             	add    $0x36,%dl
 18a9510:	41 88 b4 3a 80 00 00 00 	mov    %sil,0x80(%r10,%rdi,1)
 18a9518:	eb 16                	jmp    18a9530 <run_backend_benchmark+0x1f10>
 18a951a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18a9520:	44 89 d2             	mov    %r10d,%edx
 18a9523:	45 88 54 3a 40       	mov    %r10b,0x40(%r10,%rdi,1)
 18a9528:	45 88 94 3a 80 00 00 00 	mov    %r10b,0x80(%r10,%rdi,1)
 18a9530:	49 83 fa 3a          	cmp    $0x3a,%r10
 18a9534:	41 88 94 3a c0 00 00 00 	mov    %dl,0xc0(%r10,%rdi,1)
 18a953c:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18a9542:	40 0f 92 c6          	setb   %sil
 18a9546:	49 83 fa 09          	cmp    $0x9,%r10
 18a954a:	40 0f 95 c7          	setne  %dil
 18a954e:	49 83 fa 0a          	cmp    $0xa,%r10
 18a9552:	41 0f 94 c0          	sete   %r8b
 18a9556:	49 83 fa 1d          	cmp    $0x1d,%r10
 18a955a:	0f 94 c2             	sete   %dl
 18a955d:	40 84 fe             	test   %dil,%sil
 18a9560:	0f 84 fa 01 00 00    	je     18a9760 <run_backend_benchmark+0x2140>
 18a9566:	41 08 d0             	or     %dl,%r8b
 18a9569:	45 31 c9             	xor    %r9d,%r9d
 18a956c:	44 88 44 24 60       	mov    %r8b,0x60(%rsp)
 18a9571:	eb 23                	jmp    18a9596 <run_backend_benchmark+0x1f76>
 18a9573:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a9580:	44 0f b6 44 24 60    	movzbl 0x60(%rsp),%r8d
 18a9586:	49 ff c1             	inc    %r9
 18a9589:	4c 89 f8             	mov    %r15,%rax
 18a958c:	49 83 f9 10          	cmp    $0x10,%r9
 18a9590:	0f 84 d3 01 00 00    	je     18a9769 <run_backend_benchmark+0x2149>
 18a9596:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18a959b:	46 0f b7 34 4a       	movzwl (%rdx,%r9,2),%r14d
 18a95a0:	ba 07 00 04 00       	mov    $0x40007,%edx
 18a95a5:	c5 fb 92 ca          	kmovd  %edx,%k1
 18a95a9:	66 ba ef 01          	mov    $0x1ef,%dx
 18a95ad:	62 b1 ff c9 6f ac 70 02 00 00 00 	vmovdqu16 0x2(%rax,%r14,2),%zmm5{%k1}{z}
 18a95b8:	c5 fb 92 ca          	kmovd  %edx,%k1
 18a95bc:	46 0f b7 7c 70 28    	movzwl 0x28(%rax,%r14,2),%r15d
 18a95c2:	42 0f b7 54 70 1a    	movzwl 0x1a(%rax,%r14,2),%edx
 18a95c8:	42 0f b7 74 70 24    	movzwl 0x24(%rax,%r14,2),%esi
 18a95ce:	4a 8d 3c 70          	lea    (%rax,%r14,2),%rdi
 18a95d2:	62 b1 ff a9 6f b4 70 12 00 00 00 	vmovdqu16 0x12(%rax,%r14,2),%ymm6{%k1}{z}
 18a95dd:	49 83 fa 0a          	cmp    $0xa,%r10
 18a95e1:	75 3d                	jne    18a9620 <run_backend_benchmark+0x2000>
 18a95e3:	4c 8d 1d 66 db 14 0d 	lea    0xd14db66(%rip),%r11        # e9f7150 <tier0_slot_bases>
 18a95ea:	45 31 ed             	xor    %r13d,%r13d
 18a95ed:	45 0f b6 e0          	movzbl %r8b,%r12d
 18a95f1:	43 0f b7 9c 4b 40 01 00 00 	movzwl 0x140(%r11,%r9,2),%ebx
 18a95fa:	c5 fa 7e 7c 58 08    	vmovq  0x8(%rax,%rbx,2),%xmm7
 18a9600:	62 f1 45 08 75 c2    	vpcmpeqw %xmm2,%xmm7,%k0
 18a9606:	c5 fb 93 d8          	kmovd  %k0,%ebx
 18a960a:	f6 c3 0f             	test   $0xf,%bl
 18a960d:	bb 08 00 00 00       	mov    $0x8,%ebx
 18a9612:	45 0f 45 e5          	cmovne %r13d,%r12d
 18a9616:	45 31 c0             	xor    %r8d,%r8d
 18a9619:	eb 50                	jmp    18a966b <run_backend_benchmark+0x204b>
 18a961b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18a9620:	c5 fa 7e 7f 32       	vmovq  0x32(%rdi),%xmm7
 18a9625:	c5 7a 7e 47 2a       	vmovq  0x2a(%rdi),%xmm8
 18a962a:	49 83 fa 1d          	cmp    $0x1d,%r10
 18a962e:	0f 94 c3             	sete   %bl
 18a9631:	62 f1 45 08 75 c2    	vpcmpeqw %xmm2,%xmm7,%k0
 18a9637:	c5 7b 93 e0          	kmovd  %k0,%r12d
 18a963b:	62 f1 3d 08 75 c2    	vpcmpeqw %xmm2,%xmm8,%k0
 18a9641:	41 f6 c4 0f          	test   $0xf,%r12b
 18a9645:	45 0f b6 e0          	movzbl %r8b,%r12d
 18a9649:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18a964f:	c5 7b 93 e8          	kmovd  %k0,%r13d
 18a9653:	45 0f 45 e0          	cmovne %r8d,%r12d
 18a9657:	41 f6 c5 0f          	test   $0xf,%r13b
 18a965b:	41 0f 94 c5          	sete   %r13b
 18a965f:	41 20 dd             	and    %bl,%r13b
 18a9662:	bb 1d 00 00 00       	mov    $0x1d,%ebx
 18a9667:	41 c0 e5 07          	shl    $0x7,%r13b
 18a966b:	62 f2 f5 28 8d f6    	vpermw %ymm6,%ymm1,%ymm6
 18a9671:	62 f2 fd 48 8d ed    	vpermw %zmm5,%zmm0,%zmm5
 18a9677:	66 83 fa ff          	cmp    $0xffff,%dx
 18a967b:	41 0f 95 c3          	setne  %r11b
 18a967f:	66 83 fe ff          	cmp    $0xffff,%si
 18a9683:	0f 95 c2             	setne  %dl
 18a9686:	62 f1 4d 08 75 c2    	vpcmpeqw %xmm2,%xmm6,%k0
 18a968c:	c5 f9 98 c0          	kortestb %k0,%k0
 18a9690:	62 f1 55 08 75 c2    	vpcmpeqw %xmm2,%xmm5,%k0
 18a9696:	62 f3 d5 08 3f ca 04 	vpcmpneqw %xmm2,%xmm5,%k1
 18a969d:	62 f2 7e 08 38 e9    	vpmovm2d %k1,%xmm5
 18a96a3:	62 f2 7e 08 38 f0    	vpmovm2d %k0,%xmm6
 18a96a9:	c4 e3 49 02 ed 01    	vpblendd $0x1,%xmm5,%xmm6,%xmm5
 18a96af:	40 0f 94 c6          	sete   %sil
 18a96b3:	44 20 da             	and    %r11b,%dl
 18a96b6:	4c 8d 1c 58          	lea    (%rax,%rbx,2),%r11
 18a96ba:	62 f2 7e 08 39 cd    	vpmovd2m %xmm5,%k1
 18a96c0:	62 f2 65 09 66 2d e6 c3 cc fe 	vpblendmb -0x1333c1a(%rip),%xmm3,%xmm5{%k1}        # 575ab0 <x86_effects_unknown+0x50>
 18a96ca:	40 20 f2             	and    %sil,%dl
 18a96cd:	66 41 83 ff ff       	cmp    $0xffff,%r15w
 18a96d2:	49 89 c7             	mov    %rax,%r15
 18a96d5:	40 0f 95 c6          	setne  %sil
 18a96d9:	c0 e2 05             	shl    $0x5,%dl
 18a96dc:	41 c0 e4 06          	shl    $0x6,%r12b
 18a96e0:	40 c0 e6 04          	shl    $0x4,%sil
 18a96e4:	66 43 83 3c 73 ff    	cmpw   $0xffff,(%r11,%r14,2)
 18a96ea:	45 0f b6 dc          	movzbl %r12b,%r11d
 18a96ee:	45 0f 44 d8          	cmove  %r8d,%r11d
 18a96f2:	c5 c9 72 d5 10       	vpsrld $0x10,%xmm5,%xmm6
 18a96f7:	41 08 d3             	or     %dl,%r11b
 18a96fa:	c5 d1 eb ee          	vpor   %xmm6,%xmm5,%xmm5
 18a96fe:	c5 c9 71 d5 08       	vpsrlw $0x8,%xmm5,%xmm6
 18a9703:	c5 d1 eb ee          	vpor   %xmm6,%xmm5,%xmm5
 18a9707:	c5 f9 7e eb          	vmovd  %xmm5,%ebx
 18a970b:	40 08 f3             	or     %sil,%bl
 18a970e:	41 08 db             	or     %bl,%r11b
 18a9711:	45 08 eb             	or     %r13b,%r11b
 18a9714:	83 bc 24 b0 00 00 00 05 	cmpl   $0x5,0xb0(%rsp)
 18a971c:	46 88 9c 0c 80 02 00 00 	mov    %r11b,0x280(%rsp,%r9,1)
 18a9724:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18a972a:	0f 87 50 fe ff ff    	ja     18a9580 <run_backend_benchmark+0x1f60>
 18a9730:	66 83 7f 08 ff       	cmpw   $0xffff,0x8(%rdi)
 18a9735:	c4 e3 79 30 c0 02    	kshiftrb $0x2,%k0,%k0
 18a973b:	c5 fb 93 d0          	kmovd  %k0,%edx
 18a973f:	40 0f 95 c6          	setne  %sil
 18a9743:	40 30 d6             	xor    %dl,%sil
 18a9746:	8b 54 24 30          	mov    0x30(%rsp),%edx
 18a974a:	40 20 f2             	and    %sil,%dl
 18a974d:	89 54 24 30          	mov    %edx,0x30(%rsp)
 18a9751:	e9 2a fe ff ff       	jmp    18a9580 <run_backend_benchmark+0x1f60>
 18a9756:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18a9760:	c5 f9 7f a4 24 80 02 00 00 	vmovdqa %xmm4,0x280(%rsp)
 18a9769:	48 8d bc 24 00 0d 00 00 	lea    0xd00(%rsp),%rdi
 18a9771:	89 ce                	mov    %ecx,%esi
 18a9773:	45 31 c0             	xor    %r8d,%r8d
 18a9776:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18a9780:	c5 fa 6f 2f          	vmovdqu (%rdi),%xmm5
 18a9784:	89 ca                	mov    %ecx,%edx
 18a9786:	c5 d1 ef ac 24 80 02 00 00 	vpxor  0x280(%rsp),%xmm5,%xmm5
 18a978f:	c4 e2 79 17 ed       	vptest %xmm5,%xmm5
 18a9794:	41 0f 44 d0          	cmove  %r8d,%edx
 18a9798:	49 ff c0             	inc    %r8
 18a979b:	49 39 f0             	cmp    %rsi,%r8
 18a979e:	73 08                	jae    18a97a8 <run_backend_benchmark+0x2188>
 18a97a0:	48 83 c7 10          	add    $0x10,%rdi
 18a97a4:	39 ca                	cmp    %ecx,%edx
 18a97a6:	74 d8                	je     18a9780 <run_backend_benchmark+0x2160>
 18a97a8:	39 ca                	cmp    %ecx,%edx
 18a97aa:	0f 85 18 fc ff ff    	jne    18a93c8 <run_backend_benchmark+0x1da8>
 18a97b0:	83 f9 0f             	cmp    $0xf,%ecx
 18a97b3:	0f 86 f7 fb ff ff    	jbe    18a93b0 <run_backend_benchmark+0x1d90>
 18a97b9:	c7 44 24 30 00 00 00 00 	movl   $0x0,0x30(%rsp)
 18a97c1:	e9 02 fc ff ff       	jmp    18a93c8 <run_backend_benchmark+0x1da8>
 18a97c6:	62 f1 7c 48 28 44 24 34 	vmovaps 0xd00(%rsp),%zmm0
 18a97ce:	62 f1 7c 48 28 54 24 36 	vmovaps 0xd80(%rsp),%zmm2
 18a97d6:	62 f1 7c 48 28 5c 24 37 	vmovaps 0xdc0(%rsp),%zmm3
 18a97de:	62 f1 fd 48 6f 4c 24 35 	vmovdqa64 0xd40(%rsp),%zmm1
 18a97e6:	48 8d 35 b2 a7 20 0d 	lea    0xd20a7b2(%rip),%rsi        # eab3f9f <tier0_vector_convert_home+0x1f>
 18a97ed:	48 8d 15 5c d9 14 0d 	lea    0xd14d95c(%rip),%rdx        # e9f7150 <tier0_slot_bases>
 18a97f4:	31 ff                	xor    %edi,%edi
 18a97f6:	62 f1 7c 48 29 05 c0 a5 20 0d 	vmovaps %zmm0,0xd20a5c0(%rip)        # eab3dc0 <tier0_vector_properties>
 18a9800:	62 f2 7d 48 5a 05 16 c3 cc fe 	vbroadcasti32x4 -0x1333cea(%rip),%zmm0        # 575b20 <x86_effects_unknown+0xc0>
 18a980a:	62 f1 7c 48 29 1d 6c a6 20 0d 	vmovaps %zmm3,0xd20a66c(%rip)        # eab3e80 <tier0_vector_properties+0xc0>
 18a9814:	62 f1 7c 48 29 15 22 a6 20 0d 	vmovaps %zmm2,0xd20a622(%rip)        # eab3e40 <tier0_vector_properties+0x80>
 18a981e:	62 f2 7d 48 5a 1d 08 c3 cc fe 	vbroadcasti32x4 -0x1333cf8(%rip),%zmm3        # 575b30 <x86_effects_unknown+0xd0>
 18a9828:	62 f2 7d 48 5a 15 0e c3 cc fe 	vbroadcasti32x4 -0x1333cf2(%rip),%zmm2        # 575b40 <x86_effects_unknown+0xe0>
 18a9832:	62 f1 fd 48 7f 0d c4 a5 20 0d 	vmovdqa64 %zmm1,0xd20a5c4(%rip)        # eab3e00 <tier0_vector_properties+0x40>
 18a983c:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18a9840:	62 f1 fd 48 7f 05 f6 a6 20 0d 	vmovdqa64 %zmm0,0xd20a6f6(%rip)        # eab3f40 <tier0_vector_integer>
 18a984a:	c5 f9 76 c0          	vpcmpeqd %xmm0,%xmm0,%xmm0
 18a984e:	62 f1 fd 48 7f 1d 68 a6 20 0d 	vmovdqa64 %zmm3,0xd20a668(%rip)        # eab3ec0 <tier0_vector_stacks>
 18a9858:	62 f1 fd 48 7f 15 9e a6 20 0d 	vmovdqa64 %zmm2,0xd20a69e(%rip)        # eab3f00 <tier0_vector_wide>
 18a9862:	e9 82 00 00 00       	jmp    18a98e9 <run_backend_benchmark+0x22c9>
 18a9867:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18a9870:	0f b7 8c 7a 22 01 00 00 	movzwl 0x122(%rdx,%rdi,2),%ecx
 18a9878:	62 f3 fd 08 3f 4c 48 02 04 	vpcmpneqw 0x20(%rax,%rcx,2),%xmm0,%k1
 18a9881:	62 f1 7f 89 6f 15 35 c2 cc fe 	vmovdqu8 -0x1333dcb(%rip),%xmm2{%k1}{z}        # 575ac0 <x86_effects_unknown+0x60>
 18a988b:	c5 f9 d6 56 f1       	vmovq  %xmm2,-0xf(%rsi)
 18a9890:	c5 fa 7e 54 48 30    	vmovq  0x30(%rax,%rcx,2),%xmm2
 18a9896:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 18a989d:	62 f1 7f 89 6f 15 29 c2 cc fe 	vmovdqu8 -0x1333dd7(%rip),%xmm2{%k1}{z}        # 575ad0 <x86_effects_unknown+0x70>
 18a98a7:	c5 f9 7e 56 f9       	vmovd  %xmm2,-0x7(%rsi)
 18a98ac:	c5 f9 6e 54 48 38    	vmovd  0x38(%rax,%rcx,2),%xmm2
 18a98b2:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 18a98b9:	62 f1 7f 89 6f 15 1d c2 cc fe 	vmovdqu8 -0x1333de3(%rip),%xmm2{%k1}{z}        # 575ae0 <x86_effects_unknown+0x80>
 18a98c3:	c4 e3 79 14 56 fd 00 	vpextrb $0x0,%xmm2,-0x3(%rsi)
 18a98ca:	c4 e3 79 14 56 fe 01 	vpextrb $0x1,%xmm2,-0x2(%rsi)
 18a98d1:	66 c7 46 ff 00 00    	movw   $0x0,-0x1(%rsi)
 18a98d7:	48 83 c7 02          	add    $0x2,%rdi
 18a98db:	48 83 c6 20          	add    $0x20,%rsi
 18a98df:	48 83 ff 10          	cmp    $0x10,%rdi
 18a98e3:	0f 84 b3 00 00 00    	je     18a999c <run_backend_benchmark+0x237c>
 18a98e9:	48 83 ff 0e          	cmp    $0xe,%rdi
 18a98ed:	0f 83 7d 00 00 00    	jae    18a9970 <run_backend_benchmark+0x2350>
 18a98f3:	0f b7 8c 7a 20 01 00 00 	movzwl 0x120(%rdx,%rdi,2),%ecx
 18a98fb:	62 f3 fd 08 3f 4c 48 02 04 	vpcmpneqw 0x20(%rax,%rcx,2),%xmm0,%k1
 18a9904:	62 f1 7f 89 6f 15 b2 c1 cc fe 	vmovdqu8 -0x1333e4e(%rip),%xmm2{%k1}{z}        # 575ac0 <x86_effects_unknown+0x60>
 18a990e:	c5 f9 d6 56 e1       	vmovq  %xmm2,-0x1f(%rsi)
 18a9913:	c5 fa 7e 54 48 30    	vmovq  0x30(%rax,%rcx,2),%xmm2
 18a9919:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 18a9920:	62 f1 7f 89 6f 15 a6 c1 cc fe 	vmovdqu8 -0x1333e5a(%rip),%xmm2{%k1}{z}        # 575ad0 <x86_effects_unknown+0x70>
 18a992a:	c5 f9 7e 56 e9       	vmovd  %xmm2,-0x17(%rsi)
 18a992f:	c5 f9 6e 54 48 38    	vmovd  0x38(%rax,%rcx,2),%xmm2
 18a9935:	62 f3 ed 08 3f c8 04 	vpcmpneqw %xmm0,%xmm2,%k1
 18a993c:	62 f1 7f 89 6f 15 9a c1 cc fe 	vmovdqu8 -0x1333e66(%rip),%xmm2{%k1}{z}        # 575ae0 <x86_effects_unknown+0x80>
 18a9946:	c4 e3 79 14 56 ed 00 	vpextrb $0x0,%xmm2,-0x13(%rsi)
 18a994d:	c4 e3 79 14 56 ee 01 	vpextrb $0x1,%xmm2,-0x12(%rsi)
 18a9954:	66 c7 46 ef 00 00    	movw   $0x0,-0x11(%rsi)
 18a995a:	48 83 ff 0e          	cmp    $0xe,%rdi
 18a995e:	0f 82 0c ff ff ff    	jb     18a9870 <run_backend_benchmark+0x2250>
 18a9964:	eb 1c                	jmp    18a9982 <run_backend_benchmark+0x2362>
 18a9966:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18a9970:	48 8d 4e e1          	lea    -0x1f(%rsi),%rcx
 18a9974:	c5 f9 7f 09          	vmovdqa %xmm1,(%rcx)
 18a9978:	48 83 ff 0e          	cmp    $0xe,%rdi
 18a997c:	0f 82 ee fe ff ff    	jb     18a9870 <run_backend_benchmark+0x2250>
 18a9982:	48 8d 4e f1          	lea    -0xf(%rsi),%rcx
 18a9986:	c5 f9 7f 09          	vmovdqa %xmm1,(%rcx)
 18a998a:	48 83 c7 02          	add    $0x2,%rdi
 18a998e:	48 83 c6 20          	add    $0x20,%rsi
 18a9992:	48 83 ff 10          	cmp    $0x10,%rdi
 18a9996:	0f 85 4d ff ff ff    	jne    18a98e9 <run_backend_benchmark+0x22c9>
 18a999c:	f6 44 24 30 01       	testb  $0x1,0x30(%rsp)
 18a99a1:	0f 84 98 6f 00 00    	je     18b093f <run_backend_benchmark+0x931f>
 18a99a7:	8b 15 a3 df 14 0d    	mov    0xd14dfa3(%rip),%edx        # e9f7950 <tier0_template_count>
 18a99ad:	48 81 fa 01 10 00 00 	cmp    $0x1001,%rdx
 18a99b4:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 18a99bc:	0f 92 c1             	setb   %cl
 18a99bf:	88 4c 24 60          	mov    %cl,0x60(%rsp)
 18a99c3:	48 85 d2             	test   %rdx,%rdx
 18a99c6:	0f 84 47 02 00 00    	je     18a9c13 <run_backend_benchmark+0x25f3>
 18a99cc:	48 8d 3d fd 60 15 0d 	lea    0xd1560fd(%rip),%rdi        # e9ffad0 <tier0_template_infos>
 18a99d3:	45 31 c9             	xor    %r9d,%r9d
 18a99d6:	45 31 db             	xor    %r11d,%r11d
 18a99d9:	e9 d9 00 00 00       	jmp    18a9ab7 <run_backend_benchmark+0x2497>
 18a99de:	66 90                	xchg   %ax,%ax
 18a99e0:	0f b6 54 24 30       	movzbl 0x30(%rsp),%edx
 18a99e5:	31 db                	xor    %ebx,%ebx
 18a99e7:	49 89 ca             	mov    %rcx,%r10
 18a99ea:	48 be 00 00 00 00 00 70 00 00 	movabs $0x700000000000,%rsi
 18a99f4:	20 54 24 60          	and    %dl,0x60(%rsp)
 18a99f8:	80 bc 24 b0 00 00 00 00 	cmpb   $0x0,0xb0(%rsp)
 18a9a00:	48 ba 00 00 00 00 00 00 1c 00 	movabs $0x1c000000000000,%rdx
 18a9a0a:	0f 95 c3             	setne  %bl
 18a9a0d:	49 c1 e2 32          	shl    $0x32,%r10
 18a9a11:	48 81 f9 ff 00 00 00 	cmp    $0xff,%rcx
 18a9a18:	4c 89 c1             	mov    %r8,%rcx
 18a9a1b:	4c 0f 44 d2          	cmove  %rdx,%r10
 18a9a1f:	48 c1 e1 2f          	shl    $0x2f,%rcx
 18a9a23:	49 81 f8 ff 00 00 00 	cmp    $0xff,%r8
 18a9a2a:	48 ba 00 00 00 00 00 80 03 00 	movabs $0x3800000000000,%rdx
 18a9a34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18a9a3a:	48 0f 44 ca          	cmove  %rdx,%rcx
 18a9a3e:	4c 89 e2             	mov    %r12,%rdx
 18a9a41:	48 c1 e2 2c          	shl    $0x2c,%rdx
 18a9a45:	49 81 fc ff 00 00 00 	cmp    $0xff,%r12
 18a9a4c:	48 0f 44 d6          	cmove  %rsi,%rdx
 18a9a50:	80 7f 02 00          	cmpb   $0x0,0x2(%rdi)
 18a9a54:	48 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rsi
 18a9a5e:	48 8d b6 00 00 e0 ff 	lea    -0x200000(%rsi),%rsi
 18a9a65:	4c 0f 45 c6          	cmovne %rsi,%r8
 18a9a69:	48 c1 e3 25          	shl    $0x25,%rbx
 18a9a6d:	4c 09 d1             	or     %r10,%rcx
 18a9a70:	49 c1 e1 35          	shl    $0x35,%r9
 18a9a74:	49 ff c3             	inc    %r11
 18a9a77:	48 09 d3             	or     %rdx,%rbx
 18a9a7a:	0f b6 57 05          	movzbl 0x5(%rdi),%edx
 18a9a7e:	4c 09 c9             	or     %r9,%rcx
 18a9a81:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 18a9a86:	48 83 c7 28          	add    $0x28,%rdi
 18a9a8a:	48 09 d9             	or     %rbx,%rcx
 18a9a8d:	4c 09 c1             	or     %r8,%rcx
 18a9a90:	4c 09 f1             	or     %r14,%rcx
 18a9a93:	48 c1 e2 26          	shl    $0x26,%rdx
 18a9a97:	48 09 d1             	or     %rdx,%rcx
 18a9a9a:	48 8d 15 df e5 20 0d 	lea    0xd20e5df(%rip),%rdx        # eab8080 <tier0_template_words>
 18a9aa1:	49 89 0c 11          	mov    %rcx,(%r9,%rdx,1)
 18a9aa5:	49 83 c1 08          	add    $0x8,%r9
 18a9aa9:	4c 39 9c 24 80 00 00 00 	cmp    %r11,0x80(%rsp)
 18a9ab1:	0f 84 5c 01 00 00    	je     18a9c13 <run_backend_benchmark+0x25f3>
 18a9ab7:	44 8b 77 18          	mov    0x18(%rdi),%r14d
 18a9abb:	0f b6 74 24 60       	movzbl 0x60(%rsp),%esi
 18a9ac0:	45 85 f6             	test   %r14d,%r14d
 18a9ac3:	74 0a                	je     18a9acf <run_backend_benchmark+0x24af>
 18a9ac5:	41 83 fe 04          	cmp    $0x4,%r14d
 18a9ac9:	0f 94 c1             	sete   %cl
 18a9acc:	40 20 ce             	and    %cl,%sil
 18a9acf:	0f b6 57 0f          	movzbl 0xf(%rdi),%edx
 18a9ad3:	41 b0 01             	mov    $0x1,%r8b
 18a9ad6:	b1 01                	mov    $0x1,%cl
 18a9ad8:	88 94 24 b0 00 00 00 	mov    %dl,0xb0(%rsp)
 18a9adf:	84 d2                	test   %dl,%dl
 18a9ae1:	74 07                	je     18a9aea <run_backend_benchmark+0x24ca>
 18a9ae3:	83 7f 14 00          	cmpl   $0x0,0x14(%rdi)
 18a9ae7:	0f 94 c1             	sete   %cl
 18a9aea:	44 0f b6 7f 04       	movzbl 0x4(%rdi),%r15d
 18a9aef:	49 81 ff ff 00 00 00 	cmp    $0xff,%r15
 18a9af6:	74 09                	je     18a9b01 <run_backend_benchmark+0x24e1>
 18a9af8:	66 83 7f 06 40       	cmpw   $0x40,0x6(%rdi)
 18a9afd:	41 0f 92 c0          	setb   %r8b
 18a9b01:	48 8b 57 20          	mov    0x20(%rdi),%rdx
 18a9b05:	44 88 44 24 30       	mov    %r8b,0x30(%rsp)
 18a9b0a:	4c 8d 05 6f a5 20 0d 	lea    0xd20a56f(%rip),%r8        # eab4080 <tier0_masks>
 18a9b11:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 18a9b16:	4b 89 14 01          	mov    %rdx,(%r9,%r8,1)
 18a9b1a:	44 0f b6 47 0c       	movzbl 0xc(%rdi),%r8d
 18a9b1f:	44 0f b6 4f 0b       	movzbl 0xb(%rdi),%r9d
 18a9b24:	ba 00 80 07 00       	mov    $0x78000,%edx
 18a9b29:	45 89 c4             	mov    %r8d,%r12d
 18a9b2c:	41 c1 e4 0f          	shl    $0xf,%r12d
 18a9b30:	41 81 f8 ff 00 00 00 	cmp    $0xff,%r8d
 18a9b37:	4c 0f 44 e2          	cmove  %rdx,%r12
 18a9b3b:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 18a9b42:	75 13                	jne    18a9b57 <run_backend_benchmark+0x2537>
 18a9b44:	80 7f 10 00          	cmpb   $0x0,0x10(%rdi)
 18a9b48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 18a9b4e:	ba 07 00 00 00       	mov    $0x7,%edx
 18a9b53:	4c 0f 44 ca          	cmove  %rdx,%r9
 18a9b57:	0f b6 5f 01          	movzbl 0x1(%rdi),%ebx
 18a9b5b:	40 20 ce             	and    %cl,%sil
 18a9b5e:	31 c9                	xor    %ecx,%ecx
 18a9b60:	45 85 f6             	test   %r14d,%r14d
 18a9b63:	44 0f b6 47 0d       	movzbl 0xd(%rdi),%r8d
 18a9b68:	44 0f b6 77 0e       	movzbl 0xe(%rdi),%r14d
 18a9b6d:	8b 17                	mov    (%rdi),%edx
 18a9b6f:	44 0f b6 57 03       	movzbl 0x3(%rdi),%r10d
 18a9b74:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 18a9b7a:	0f 95 c1             	setne  %cl
 18a9b7d:	40 88 74 24 60       	mov    %sil,0x60(%rsp)
 18a9b82:	c1 e1 17             	shl    $0x17,%ecx
 18a9b85:	48 89 de             	mov    %rbx,%rsi
 18a9b88:	48 c1 e6 1e          	shl    $0x1e,%rsi
 18a9b8c:	41 c1 e0 13          	shl    $0x13,%r8d
 18a9b90:	41 c1 e6 15          	shl    $0x15,%r14d
 18a9b94:	c1 e2 18             	shl    $0x18,%edx
 18a9b97:	48 81 ce 00 00 00 08 	or     $0x8000000,%rsi
 18a9b9e:	48 81 fb ff 00 00 00 	cmp    $0xff,%rbx
 18a9ba5:	4c 89 d3             	mov    %r10,%rbx
 18a9ba8:	49 0f 44 f5          	cmove  %r13,%rsi
 18a9bac:	48 c1 e3 20          	shl    $0x20,%rbx
 18a9bb0:	48 81 cb 00 00 00 10 	or     $0x10000000,%rbx
 18a9bb7:	49 81 fa ff 00 00 00 	cmp    $0xff,%r10
 18a9bbe:	49 0f 44 dd          	cmove  %r13,%rbx
 18a9bc2:	4d 09 c6             	or     %r8,%r14
 18a9bc5:	4c 09 e1             	or     %r12,%rcx
 18a9bc8:	44 0f b6 67 08       	movzbl 0x8(%rdi),%r12d
 18a9bcd:	44 0f b6 47 09       	movzbl 0x9(%rdi),%r8d
 18a9bd2:	49 09 d6             	or     %rdx,%r14
 18a9bd5:	49 09 f6             	or     %rsi,%r14
 18a9bd8:	49 09 de             	or     %rbx,%r14
 18a9bdb:	49 09 ce             	or     %rcx,%r14
 18a9bde:	0f b6 4f 0a          	movzbl 0xa(%rdi),%ecx
 18a9be2:	4d 09 de             	or     %r11,%r14
 18a9be5:	41 81 ff ff 00 00 00 	cmp    $0xff,%r15d
 18a9bec:	0f 84 ee fd ff ff    	je     18a99e0 <run_backend_benchmark+0x23c0>
 18a9bf2:	0f b7 57 06          	movzwl 0x6(%rdi),%edx
 18a9bf6:	49 c1 e7 22          	shl    $0x22,%r15
 18a9bfa:	48 c1 e2 3a          	shl    $0x3a,%rdx
 18a9bfe:	4c 09 fa             	or     %r15,%rdx
 18a9c01:	4c 09 f2             	or     %r14,%rdx
 18a9c04:	48 81 ca 00 00 00 20 	or     $0x20000000,%rdx
 18a9c0b:	49 89 d6             	mov    %rdx,%r14
 18a9c0e:	e9 cd fd ff ff       	jmp    18a99e0 <run_backend_benchmark+0x23c0>
 18a9c13:	48 be 00 60 00 ff ff ff ff fe 	movabs $0xfeffffffff006000,%rsi
 18a9c1d:	48 bf 00 10 00 00 00 00 00 01 	movabs $0x100000000001000,%rdi
 18a9c27:	4c 8d 35 6a 24 21 0d 	lea    0xd21246a(%rip),%r14        # eabc098 <tier0_slot_words+0x18>
 18a9c2e:	49 b9 00 a0 07 00 00 f0 ff 00 	movabs $0xfff0000007a000,%r9
 18a9c38:	4c 8d 1d 41 e4 20 0d 	lea    0xd20e441(%rip),%r11        # eab8080 <tier0_template_words>
 18a9c3f:	31 db                	xor    %ebx,%ebx
 18a9c41:	eb 2e                	jmp    18a9c71 <run_backend_benchmark+0x2651>
 18a9c43:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a9c50:	48 8b 9c 24 b0 00 00 00 	mov    0xb0(%rsp),%rbx
 18a9c58:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
 18a9c5d:	48 ff c3             	inc    %rbx
 18a9c60:	49 81 c6 00 10 00 00 	add    $0x1000,%r14
 18a9c67:	48 83 fb 40          	cmp    $0x40,%rbx
 18a9c6b:	0f 84 4f 02 00 00    	je     18a9ec0 <run_backend_benchmark+0x28a0>
 18a9c71:	48 89 9c 24 b0 00 00 00 	mov    %rbx,0xb0(%rsp)
 18a9c79:	48 c1 e3 05          	shl    $0x5,%rbx
 18a9c7d:	48 8d 0d cc d4 14 0d 	lea    0xd14d4cc(%rip),%rcx        # e9f7150 <tier0_slot_bases>
 18a9c84:	4c 89 74 24 40       	mov    %r14,0x40(%rsp)
 18a9c89:	45 31 ff             	xor    %r15d,%r15d
 18a9c8c:	48 01 cb             	add    %rcx,%rbx
 18a9c8f:	eb 1f                	jmp    18a9cb0 <run_backend_benchmark+0x2690>
 18a9c91:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a9ca0:	49 ff c7             	inc    %r15
 18a9ca3:	49 81 c6 00 01 00 00 	add    $0x100,%r14
 18a9caa:	49 83 ff 10          	cmp    $0x10,%r15
 18a9cae:	74 a0                	je     18a9c50 <run_backend_benchmark+0x2630>
 18a9cb0:	42 0f b7 0c 7b       	movzwl (%rbx,%r15,2),%ecx
 18a9cb5:	45 31 ed             	xor    %r13d,%r13d
 18a9cb8:	4c 8d 64 48 06       	lea    0x6(%rax,%rcx,2),%r12
 18a9cbd:	eb 14                	jmp    18a9cd3 <run_backend_benchmark+0x26b3>
 18a9cbf:	90                   	nop
 18a9cc0:	b9 00 40 00 00       	mov    $0x4000,%ecx
 18a9cc5:	4b 89 0c ee          	mov    %rcx,(%r14,%r13,8)
 18a9cc9:	49 83 c5 04          	add    $0x4,%r13
 18a9ccd:	49 83 fd 20          	cmp    $0x20,%r13
 18a9cd1:	74 cd                	je     18a9ca0 <run_backend_benchmark+0x2680>
 18a9cd3:	43 0f b7 54 6c fa    	movzwl -0x6(%r12,%r13,2),%edx
 18a9cd9:	4c 89 c9             	mov    %r9,%rcx
 18a9cdc:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 18a9ce2:	74 6c                	je     18a9d50 <run_backend_benchmark+0x2730>
 18a9ce4:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 18a9cea:	75 14                	jne    18a9d00 <run_backend_benchmark+0x26e0>
 18a9cec:	b9 00 40 00 00       	mov    $0x4000,%ecx
 18a9cf1:	eb 5d                	jmp    18a9d50 <run_backend_benchmark+0x2730>
 18a9cf3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a9d00:	41 89 d0             	mov    %edx,%r8d
 18a9d03:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 18a9d09:	89 d1                	mov    %edx,%ecx
 18a9d0b:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 18a9d0f:	66 45 85 c0          	test   %r8w,%r8w
 18a9d13:	79 3b                	jns    18a9d50 <run_backend_benchmark+0x2730>
 18a9d15:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 18a9d1a:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 18a9d1f:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 18a9d24:	49 31 c8             	xor    %rcx,%r8
 18a9d27:	49 31 ca             	xor    %rcx,%r10
 18a9d2a:	48 31 ca             	xor    %rcx,%rdx
 18a9d2d:	4d 09 c2             	or     %r8,%r10
 18a9d30:	4c 09 d2             	or     %r10,%rdx
 18a9d33:	48 85 f2             	test   %rsi,%rdx
 18a9d36:	ba 00 10 00 00       	mov    $0x1000,%edx
 18a9d3b:	48 0f 44 d7          	cmove  %rdi,%rdx
 18a9d3f:	48 09 d1             	or     %rdx,%rcx
 18a9d42:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a9d50:	43 0f b7 54 6c fc    	movzwl -0x4(%r12,%r13,2),%edx
 18a9d56:	4b 89 4c ee e8       	mov    %rcx,-0x18(%r14,%r13,8)
 18a9d5b:	4c 89 c9             	mov    %r9,%rcx
 18a9d5e:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 18a9d64:	74 6a                	je     18a9dd0 <run_backend_benchmark+0x27b0>
 18a9d66:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 18a9d6c:	75 12                	jne    18a9d80 <run_backend_benchmark+0x2760>
 18a9d6e:	b9 00 40 00 00       	mov    $0x4000,%ecx
 18a9d73:	eb 5b                	jmp    18a9dd0 <run_backend_benchmark+0x27b0>
 18a9d75:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18a9d80:	41 89 d0             	mov    %edx,%r8d
 18a9d83:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 18a9d89:	89 d1                	mov    %edx,%ecx
 18a9d8b:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 18a9d8f:	66 45 85 c0          	test   %r8w,%r8w
 18a9d93:	79 3b                	jns    18a9dd0 <run_backend_benchmark+0x27b0>
 18a9d95:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 18a9d9a:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 18a9d9f:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 18a9da4:	49 31 c8             	xor    %rcx,%r8
 18a9da7:	49 31 ca             	xor    %rcx,%r10
 18a9daa:	48 31 ca             	xor    %rcx,%rdx
 18a9dad:	4d 09 c2             	or     %r8,%r10
 18a9db0:	4c 09 d2             	or     %r10,%rdx
 18a9db3:	48 85 f2             	test   %rsi,%rdx
 18a9db6:	ba 00 10 00 00       	mov    $0x1000,%edx
 18a9dbb:	48 0f 44 d7          	cmove  %rdi,%rdx
 18a9dbf:	48 09 d1             	or     %rdx,%rcx
 18a9dc2:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a9dd0:	43 0f b7 54 6c fe    	movzwl -0x2(%r12,%r13,2),%edx
 18a9dd6:	4b 89 4c ee f0       	mov    %rcx,-0x10(%r14,%r13,8)
 18a9ddb:	4c 89 c9             	mov    %r9,%rcx
 18a9dde:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 18a9de4:	74 6a                	je     18a9e50 <run_backend_benchmark+0x2830>
 18a9de6:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 18a9dec:	75 12                	jne    18a9e00 <run_backend_benchmark+0x27e0>
 18a9dee:	b9 00 40 00 00       	mov    $0x4000,%ecx
 18a9df3:	eb 5b                	jmp    18a9e50 <run_backend_benchmark+0x2830>
 18a9df5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18a9e00:	41 89 d0             	mov    %edx,%r8d
 18a9e03:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 18a9e09:	89 d1                	mov    %edx,%ecx
 18a9e0b:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 18a9e0f:	66 45 85 c0          	test   %r8w,%r8w
 18a9e13:	79 3b                	jns    18a9e50 <run_backend_benchmark+0x2830>
 18a9e15:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 18a9e1a:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 18a9e1f:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 18a9e24:	49 31 c8             	xor    %rcx,%r8
 18a9e27:	49 31 ca             	xor    %rcx,%r10
 18a9e2a:	48 31 ca             	xor    %rcx,%rdx
 18a9e2d:	4d 09 c2             	or     %r8,%r10
 18a9e30:	4c 09 d2             	or     %r10,%rdx
 18a9e33:	48 85 f2             	test   %rsi,%rdx
 18a9e36:	ba 00 10 00 00       	mov    $0x1000,%edx
 18a9e3b:	48 0f 44 d7          	cmove  %rdi,%rdx
 18a9e3f:	48 09 d1             	or     %rdx,%rcx
 18a9e42:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18a9e50:	43 0f b7 14 6c       	movzwl (%r12,%r13,2),%edx
 18a9e55:	4b 89 4c ee f8       	mov    %rcx,-0x8(%r14,%r13,8)
 18a9e5a:	4c 89 c9             	mov    %r9,%rcx
 18a9e5d:	81 fa fe ff 00 00    	cmp    $0xfffe,%edx
 18a9e63:	0f 84 5c fe ff ff    	je     18a9cc5 <run_backend_benchmark+0x26a5>
 18a9e69:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 18a9e6f:	0f 84 4b fe ff ff    	je     18a9cc0 <run_backend_benchmark+0x26a0>
 18a9e75:	41 89 d0             	mov    %edx,%r8d
 18a9e78:	81 e2 ff 7f 00 00    	and    $0x7fff,%edx
 18a9e7e:	89 d1                	mov    %edx,%ecx
 18a9e80:	49 8b 0c cb          	mov    (%r11,%rcx,8),%rcx
 18a9e84:	66 45 85 c0          	test   %r8w,%r8w
 18a9e88:	0f 89 37 fe ff ff    	jns    18a9cc5 <run_backend_benchmark+0x26a5>
 18a9e8e:	4d 8b 44 d3 08       	mov    0x8(%r11,%rdx,8),%r8
 18a9e93:	4d 8b 54 d3 10       	mov    0x10(%r11,%rdx,8),%r10
 18a9e98:	49 8b 54 d3 18       	mov    0x18(%r11,%rdx,8),%rdx
 18a9e9d:	49 31 c8             	xor    %rcx,%r8
 18a9ea0:	49 31 ca             	xor    %rcx,%r10
 18a9ea3:	48 31 ca             	xor    %rcx,%rdx
 18a9ea6:	4d 09 c2             	or     %r8,%r10
 18a9ea9:	4c 09 d2             	or     %r10,%rdx
 18a9eac:	48 85 f2             	test   %rsi,%rdx
 18a9eaf:	ba 00 10 00 00       	mov    $0x1000,%edx
 18a9eb4:	48 0f 44 d7          	cmove  %rdi,%rdx
 18a9eb8:	48 09 d1             	or     %rdx,%rcx
 18a9ebb:	e9 05 fe ff ff       	jmp    18a9cc5 <run_backend_benchmark+0x26a5>
 18a9ec0:	f6 44 24 60 01       	testb  $0x1,0x60(%rsp)
 18a9ec5:	0f 84 74 6a 00 00    	je     18b093f <run_backend_benchmark+0x931f>
 18a9ecb:	c5 f9 6f 05 1d bc cc fe 	vmovdqa -0x13343e3(%rip),%xmm0        # 575af0 <x86_effects_unknown+0x90>
 18a9ed3:	62 f2 7d 48 5a 0d 73 bc cc fe 	vbroadcasti32x4 -0x133438d(%rip),%zmm1        # 575b50 <x86_effects_unknown+0xf0>
 18a9edd:	62 f2 7d 48 5a 15 79 bc cc fe 	vbroadcasti32x4 -0x1334387(%rip),%zmm2        # 575b60 <x86_effects_unknown+0x100>
 18a9ee7:	62 f2 7d 48 5a 1d 7f bc cc fe 	vbroadcasti32x4 -0x1334381(%rip),%zmm3        # 575b70 <x86_effects_unknown+0x110>
 18a9ef1:	62 f2 7d 48 5a 25 85 bc cc fe 	vbroadcasti32x4 -0x133437b(%rip),%zmm4        # 575b80 <x86_effects_unknown+0x120>
 18a9efb:	62 f2 7d 48 5a 2d 8b bc cc fe 	vbroadcasti32x4 -0x1334375(%rip),%zmm5        # 575b90 <x86_effects_unknown+0x130>
 18a9f05:	62 f2 7d 48 5a 35 91 bc cc fe 	vbroadcasti32x4 -0x133436f(%rip),%zmm6        # 575ba0 <x86_effects_unknown+0x140>
 18a9f0f:	62 f2 7d 48 5a 3d 97 bc cc fe 	vbroadcasti32x4 -0x1334369(%rip),%zmm7        # 575bb0 <x86_effects_unknown+0x150>
 18a9f19:	48 b8 00 00 01 00 00 00 00 01 	movabs $0x100000000010000,%rax
 18a9f23:	c4 e1 fc 46 c8       	kxnorq %k0,%k0,%k1
 18a9f28:	c4 e1 fc 46 e0       	kxnorq %k0,%k0,%k4
 18a9f2d:	c4 e1 fc 46 e8       	kxnorq %k0,%k0,%k5
 18a9f32:	48 8d 0d 27 40 7a 00 	lea    0x7a4027(%rip),%rcx        # 204df60 <x86_form_descriptions>
 18a9f39:	31 d2                	xor    %edx,%edx
 18a9f3b:	c4 e1 fb 92 d0       	kmovq  %rax,%k2
 18a9f40:	48 b8 01 00 00 00 00 01 00 00 	movabs $0x10000000001,%rax
 18a9f4a:	c4 e1 f8 91 94 24 80 00 00 00 	kmovq  %k2,0x80(%rsp)
 18a9f54:	c4 e1 fb 92 d8       	kmovq  %rax,%k3
 18a9f59:	c4 e1 fc 46 d0       	kxnorq %k0,%k0,%k2
 18a9f5e:	66 90                	xchg   %ax,%ax
 18a9f60:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 18a9f65:	c4 e1 f8 91 8c 24 b0 00 00 00 	kmovq  %k1,0xb0(%rsp)
 18a9f6f:	c4 e1 f8 90 8c 24 80 00 00 00 	kmovq  0x80(%rsp),%k1
 18a9f79:	c4 e1 f8 91 6c 24 30 	kmovq  %k5,0x30(%rsp)
 18a9f80:	c4 e1 f8 91 64 24 60 	kmovq  %k4,0x60(%rsp)
 18a9f87:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18a9f8c:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
 18a9f90:	62 71 7f c9 6f 8c d1 5b 00 00 00 	vmovdqu8 0x5b(%rcx,%rdx,8),%zmm9{%k1}{z}
 18a9f9b:	62 71 7f cb 6f 84 d1 1b 00 00 00 	vmovdqu8 0x1b(%rcx,%rdx,8),%zmm8{%k3}{z}
 18a9fa6:	62 71 7f c9 6f 94 d1 db 02 00 00 	vmovdqu8 0x2db(%rcx,%rdx,8),%zmm10{%k1}{z}
 18a9fb1:	62 e1 7f c9 6f ac d1 7b 03 00 00 	vmovdqu8 0x37b(%rcx,%rdx,8),%zmm21{%k1}{z}
 18a9fbc:	62 e1 7f c9 6f b4 d1 db 07 00 00 	vmovdqu8 0x7db(%rcx,%rdx,8),%zmm22{%k1}{z}
 18a9fc7:	62 e1 7f cb 6f 9c d1 9b 07 00 00 	vmovdqu8 0x79b(%rcx,%rdx,8),%zmm19{%k3}{z}
 18a9fd2:	62 e1 7f cb 6f a4 d1 3b 03 00 00 	vmovdqu8 0x33b(%rcx,%rdx,8),%zmm20{%k3}{z}
 18a9fdd:	62 61 7f c9 6f 8c d1 1b 04 00 00 	vmovdqu8 0x41b(%rcx,%rdx,8),%zmm25{%k1}{z}
 18a9fe8:	62 61 7f cb 6f 84 d1 db 03 00 00 	vmovdqu8 0x3db(%rcx,%rdx,8),%zmm24{%k3}{z}
 18a9ff3:	62 e1 7f c9 6f 94 d1 bb 04 00 00 	vmovdqu8 0x4bb(%rcx,%rdx,8),%zmm18{%k1}{z}
 18a9ffe:	62 e1 7f cb 6f bc d1 3b 08 00 00 	vmovdqu8 0x83b(%rcx,%rdx,8),%zmm23{%k3}{z}
 18aa009:	62 71 7f c9 6f 9c d1 5b 05 00 00 	vmovdqu8 0x55b(%rcx,%rdx,8),%zmm11{%k1}{z}
 18aa014:	62 71 7f cb 6f bc d1 1b 05 00 00 	vmovdqu8 0x51b(%rcx,%rdx,8),%zmm15{%k3}{z}
 18aa01f:	62 e1 7f cb 6f 84 d1 bb 05 00 00 	vmovdqu8 0x5bb(%rcx,%rdx,8),%zmm16{%k3}{z}
 18aa02a:	62 e1 7f c9 6f 8c d1 fb 05 00 00 	vmovdqu8 0x5fb(%rcx,%rdx,8),%zmm17{%k1}{z}
 18aa035:	62 71 7f cb 6f b4 d1 5b 06 00 00 	vmovdqu8 0x65b(%rcx,%rdx,8),%zmm14{%k3}{z}
 18aa040:	62 71 7f c9 6f ac d1 9b 06 00 00 	vmovdqu8 0x69b(%rcx,%rdx,8),%zmm13{%k1}{z}
 18aa04b:	62 71 7f cb 6f a4 d1 fb 06 00 00 	vmovdqu8 0x6fb(%rcx,%rdx,8),%zmm12{%k3}{z}
 18aa056:	62 52 7d 48 7d c1    	vpermt2b %zmm9,%zmm0,%zmm8
 18aa05c:	62 71 7f cb 6f 8c d1 9b 02 00 00 	vmovdqu8 0x29b(%rcx,%rdx,8),%zmm9{%k3}{z}
 18aa067:	62 a2 7d 48 7d de    	vpermt2b %zmm22,%zmm0,%zmm19
 18aa06d:	62 a3 7d 48 39 ee 03 	vextracti32x4 $0x3,%zmm21,%xmm22
 18aa074:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 18aa07b:	62 c1 7d 08 7e e2    	vmovd  %xmm20,%r10d
 18aa081:	62 41 7d 08 7e c7    	vmovd  %xmm24,%r15d
 18aa087:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 18aa08d:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18aa094:	62 52 7d 48 7d fb    	vpermt2b %zmm11,%zmm0,%zmm15
 18aa09a:	62 71 7f c9 6f 9c d1 3b 07 00 00 	vmovdqu8 0x73b(%rcx,%rdx,8),%zmm11{%k1}{z}
 18aa0a5:	c4 63 39 20 84 d1 bb 00 00 00 04 	vpinsrb $0x4,0xbb(%rcx,%rdx,8),%xmm8,%xmm8
 18aa0b0:	62 e3 7d 08 14 f6 08 	vpextrb $0x8,%xmm22,%esi
 18aa0b7:	62 e1 7f c9 6f b4 d1 7b 08 00 00 	vmovdqu8 0x87b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18aa0c2:	62 e1 7d 08 7e ef    	vmovd  %xmm21,%edi
 18aa0c8:	62 a3 7d 48 39 e5 02 	vextracti32x4 $0x2,%zmm20,%xmm21
 18aa0cf:	62 23 7d 48 39 cc 03 	vextracti32x4 $0x3,%zmm25,%xmm20
 18aa0d6:	62 c3 7d 08 14 e9 08 	vpextrb $0x8,%xmm21,%r9d
 18aa0dd:	62 23 7d 28 39 cd 01 	vextracti32x4 $0x1,%ymm25,%xmm21
 18aa0e4:	62 c3 7d 08 14 e0 08 	vpextrb $0x8,%xmm20,%r8d
 18aa0eb:	62 e1 7f cb 6f a4 d1 db 08 00 00 	vmovdqu8 0x8db(%rcx,%rdx,8),%zmm20{%k3}{z}
 18aa0f6:	62 61 7f c9 6f 8c d1 1b 0e 00 00 	vmovdqu8 0xe1b(%rcx,%rdx,8),%zmm25{%k1}{z}
 18aa101:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 18aa107:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 18aa10e:	62 83 7d 48 39 d0 03 	vextracti32x4 $0x3,%zmm18,%xmm24
 18aa115:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 18aa11c:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 18aa123:	62 e1 7f c9 6f ac d1 1b 09 00 00 	vmovdqu8 0x91b(%rcx,%rdx,8),%zmm21{%k1}{z}
 18aa12e:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 18aa135:	c4 63 39 20 84 d1 e3 00 00 00 05 	vpinsrb $0x5,0xe3(%rcx,%rdx,8),%xmm8,%xmm8
 18aa140:	62 c3 65 00 20 dd 04 	vpinsrb $0x4,%r13d,%xmm19,%xmm19
 18aa147:	62 c3 7d 08 14 fd 08 	vpextrb $0x8,%xmm23,%r13d
 18aa14e:	62 e1 7f c9 6f bc d1 bb 09 00 00 	vmovdqu8 0x9bb(%rcx,%rdx,8),%zmm23{%k1}{z}
 18aa159:	62 c3 65 00 20 dd 05 	vpinsrb $0x5,%r13d,%xmm19,%xmm19
 18aa160:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 18aa166:	62 71 7f cb 6f 94 d1 7b 04 00 00 	vmovdqu8 0x47b(%rcx,%rdx,8),%zmm10{%k3}{z}
 18aa171:	c4 63 39 20 84 d1 0b 01 00 00 06 	vpinsrb $0x6,0x10b(%rcx,%rdx,8),%xmm8,%xmm8
 18aa17c:	c4 63 39 20 84 d1 33 01 00 00 07 	vpinsrb $0x7,0x133(%rcx,%rdx,8),%xmm8,%xmm8
 18aa187:	c4 43 31 20 ca 04    	vpinsrb $0x4,%r10d,%xmm9,%xmm9
 18aa18d:	c4 43 31 20 c9 05    	vpinsrb $0x5,%r9d,%xmm9,%xmm9
 18aa193:	c4 63 31 20 cf 06    	vpinsrb $0x6,%edi,%xmm9,%xmm9
 18aa199:	62 13 7d 48 39 d0 02 	vextracti32x4 $0x2,%zmm10,%xmm24
 18aa1a0:	c4 63 31 20 ce 07    	vpinsrb $0x7,%esi,%xmm9,%xmm9
 18aa1a6:	c4 63 39 20 84 d1 5b 01 00 00 08 	vpinsrb $0x8,0x15b(%rcx,%rdx,8),%xmm8,%xmm8
 18aa1b1:	62 43 7d 08 14 c4 08 	vpextrb $0x8,%xmm24,%r12d
 18aa1b8:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 18aa1bf:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18aa1c6:	c4 43 31 20 cf 08    	vpinsrb $0x8,%r15d,%xmm9,%xmm9
 18aa1cc:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18aa1d3:	62 61 7f cb 6f 84 d1 7b 09 00 00 	vmovdqu8 0x97b(%rcx,%rdx,8),%zmm24{%k3}{z}
 18aa1de:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 18aa1e4:	62 a3 7d 48 39 e6 02 	vextracti32x4 $0x2,%zmm20,%xmm22
 18aa1eb:	c4 43 31 20 ce 09    	vpinsrb $0x9,%r14d,%xmm9,%xmm9
 18aa1f1:	62 c3 65 00 20 dd 06 	vpinsrb $0x6,%r13d,%xmm19,%xmm19
 18aa1f8:	62 c1 7d 08 7e d5    	vmovd  %xmm18,%r13d
 18aa1fe:	62 a3 7d 48 39 ea 03 	vextracti32x4 $0x3,%zmm21,%xmm18
 18aa205:	c4 43 31 20 cb 0a    	vpinsrb $0xa,%r11d,%xmm9,%xmm9
 18aa20b:	62 e3 65 00 20 d8 07 	vpinsrb $0x7,%eax,%xmm19,%xmm19
 18aa212:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18aa218:	62 a3 7d 28 39 ec 01 	vextracti32x4 $0x1,%ymm21,%xmm20
 18aa21f:	c4 43 31 20 c8 0b    	vpinsrb $0xb,%r8d,%xmm9,%xmm9
 18aa225:	c4 63 39 20 84 d1 83 01 00 00 09 	vpinsrb $0x9,0x183(%rcx,%rdx,8),%xmm8,%xmm8
 18aa230:	62 e3 65 00 20 d8 08 	vpinsrb $0x8,%eax,%xmm19,%xmm19
 18aa237:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18aa23e:	62 e1 7f c9 6f b4 d1 7b 0d 00 00 	vmovdqu8 0xd7b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18aa249:	62 e3 65 00 20 d8 09 	vpinsrb $0x9,%eax,%xmm19,%xmm19
 18aa250:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18aa256:	62 a3 7d 48 39 fc 03 	vextracti32x4 $0x3,%zmm23,%xmm20
 18aa25d:	62 e3 65 00 20 d8 0a 	vpinsrb $0xa,%eax,%xmm19,%xmm19
 18aa264:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18aa26b:	62 a3 7d 48 39 ca 03 	vextracti32x4 $0x3,%zmm17,%xmm18
 18aa272:	62 a3 7d 28 39 c9 01 	vextracti32x4 $0x1,%ymm17,%xmm17
 18aa279:	62 e3 65 00 20 d8 0b 	vpinsrb $0xb,%eax,%xmm19,%xmm19
 18aa280:	c4 63 39 20 84 d1 ab 01 00 00 0a 	vpinsrb $0xa,0x1ab(%rcx,%rdx,8),%xmm8,%xmm8
 18aa28b:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18aa291:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 18aa298:	62 61 7f cb 6f 84 d1 db 0d 00 00 	vmovdqu8 0xddb(%rcx,%rdx,8),%zmm24{%k3}{z}
 18aa2a3:	62 e3 65 00 20 d8 0c 	vpinsrb $0xc,%eax,%xmm19,%xmm19
 18aa2aa:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18aa2b1:	62 a3 7d 28 39 fd 01 	vextracti32x4 $0x1,%ymm23,%xmm21
 18aa2b8:	62 e1 7f c9 6f bc d1 7b 12 00 00 	vmovdqu8 0x127b(%rcx,%rdx,8),%zmm23{%k1}{z}
 18aa2c3:	62 e3 65 00 20 d8 0d 	vpinsrb $0xd,%eax,%xmm19,%xmm19
 18aa2ca:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18aa2d0:	62 e1 7f cb 6f ac d1 3b 0d 00 00 	vmovdqu8 0xd3b(%rcx,%rdx,8),%zmm21{%k3}{z}
 18aa2db:	c4 63 39 20 84 d1 d3 01 00 00 0b 	vpinsrb $0xb,0x1d3(%rcx,%rdx,8),%xmm8,%xmm8
 18aa2e6:	62 e3 65 00 20 d8 0e 	vpinsrb $0xe,%eax,%xmm19,%xmm19
 18aa2ed:	62 e3 7d 08 14 e0 08 	vpextrb $0x8,%xmm20,%eax
 18aa2f4:	62 e1 7f cb 6f a4 d1 9b 11 00 00 	vmovdqu8 0x119b(%rcx,%rdx,8),%zmm20{%k3}{z}
 18aa2ff:	62 e3 65 00 20 d8 0f 	vpinsrb $0xf,%eax,%xmm19,%xmm19
 18aa306:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18aa30c:	62 a3 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm16,%xmm16
 18aa313:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 18aa319:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18aa320:	62 33 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm14,%xmm16
 18aa327:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 18aa32d:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18aa333:	62 e1 7f cb 6f 8c d1 bb 0f 00 00 	vmovdqu8 0xfbb(%rcx,%rdx,8),%zmm17{%k3}{z}
 18aa33e:	c4 63 39 20 84 d1 fb 01 00 00 0c 	vpinsrb $0xc,0x1fb(%rcx,%rdx,8),%xmm8,%xmm8
 18aa349:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 18aa34f:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18aa356:	62 e1 7f c9 6f 94 d1 fb 0f 00 00 	vmovdqu8 0xffb(%rcx,%rdx,8),%zmm18{%k1}{z}
 18aa361:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 18aa367:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18aa36b:	62 41 7d 08 7e c7    	vmovd  %xmm24,%r15d
 18aa371:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 18aa377:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18aa37e:	c4 43 7d 39 ef 01    	vextracti128 $0x1,%ymm13,%xmm15
 18aa384:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 18aa38b:	62 e1 7f cb 6f 84 d1 1b 0f 00 00 	vmovdqu8 0xf1b(%rcx,%rdx,8),%zmm16{%k3}{z}
 18aa396:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 18aa39c:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18aa3a0:	62 53 7d 48 39 e7 02 	vextracti32x4 $0x2,%zmm12,%xmm15
 18aa3a7:	62 c1 7d 08 7e ea    	vmovd  %xmm21,%r10d
 18aa3ad:	c4 63 39 20 84 d1 23 02 00 00 0d 	vpinsrb $0xd,0x223(%rcx,%rdx,8),%xmm8,%xmm8
 18aa3b8:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 18aa3be:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18aa3c4:	62 53 7d 48 39 dd 03 	vextracti32x4 $0x3,%zmm11,%xmm13
 18aa3cb:	c4 43 7d 39 db 01    	vextracti128 $0x1,%ymm11,%xmm11
 18aa3d1:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 18aa3d7:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18aa3db:	c4 63 09 20 e0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm12
 18aa3e1:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18aa3e7:	62 71 7f c9 6f bc d1 db 11 00 00 	vmovdqu8 0x11db(%rcx,%rdx,8),%zmm15{%k1}{z}
 18aa3f2:	62 71 7f cb 6f b4 d1 5b 10 00 00 	vmovdqu8 0x105b(%rcx,%rdx,8),%zmm14{%k3}{z}
 18aa3fd:	c4 63 19 20 e0 0d    	vpinsrb $0xd,%eax,%xmm12,%xmm12
 18aa403:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18aa407:	c4 63 39 20 84 d1 4b 02 00 00 0e 	vpinsrb $0xe,0x24b(%rcx,%rdx,8),%xmm8,%xmm8
 18aa412:	c4 63 19 20 d8 0e    	vpinsrb $0xe,%eax,%xmm12,%xmm11
 18aa418:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18aa41e:	62 71 7f c9 6f a4 d1 5b 0f 00 00 	vmovdqu8 0xf5b(%rcx,%rdx,8),%zmm12{%k1}{z}
 18aa429:	62 71 7f c9 6f ac d1 9b 10 00 00 	vmovdqu8 0x109b(%rcx,%rdx,8),%zmm13{%k1}{z}
 18aa434:	c4 63 21 20 d8 0f    	vpinsrb $0xf,%eax,%xmm11,%xmm11
 18aa43a:	c5 79 7e d0          	vmovd  %xmm10,%eax
 18aa43e:	c4 63 31 20 c8 0c    	vpinsrb $0xc,%eax,%xmm9,%xmm9
 18aa444:	62 33 25 28 38 d3 01 	vinserti32x4 $0x1,%xmm19,%ymm11,%ymm10
 18aa44b:	62 71 7f c9 6f 9c d1 db 0c 00 00 	vmovdqu8 0xcdb(%rcx,%rdx,8),%zmm11{%k1}{z}
 18aa456:	62 e1 7f c9 6f 9c d1 bb 0e 00 00 	vmovdqu8 0xebb(%rcx,%rdx,8),%zmm19{%k1}{z}
 18aa461:	c4 43 31 20 cc 0d    	vpinsrb $0xd,%r12d,%xmm9,%xmm9
 18aa467:	c4 63 39 20 84 d1 73 02 00 00 0f 	vpinsrb $0xf,0x273(%rcx,%rdx,8),%xmm8,%xmm8
 18aa472:	c4 43 31 20 cd 0e    	vpinsrb $0xe,%r13d,%xmm9,%xmm9
 18aa478:	c4 63 31 20 cb 0f    	vpinsrb $0xf,%ebx,%xmm9,%xmm9
 18aa47e:	62 c2 7d 48 7d e7    	vpermt2b %zmm15,%zmm0,%zmm20
 18aa484:	62 c3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm15
 18aa48b:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18aa492:	62 e1 7d 08 7e f7    	vmovd  %xmm22,%edi
 18aa498:	62 a3 7d 48 39 ee 02 	vextracti32x4 $0x2,%zmm21,%xmm22
 18aa49f:	62 23 7d 48 39 cd 03 	vextracti32x4 $0x3,%zmm25,%xmm21
 18aa4a6:	c4 63 79 14 fe 08    	vpextrb $0x8,%xmm15,%esi
 18aa4ac:	62 71 7f c9 6f bc d1 3b 11 00 00 	vmovdqu8 0x113b(%rcx,%rdx,8),%zmm15{%k1}{z}
 18aa4b7:	62 c3 7d 08 14 f1 08 	vpextrb $0x8,%xmm22,%r9d
 18aa4be:	62 e1 7f cb 6f b4 d1 3b 12 00 00 	vmovdqu8 0x123b(%rcx,%rdx,8),%zmm22{%k3}{z}
 18aa4c9:	62 c3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%r8d
 18aa4d0:	62 23 7d 28 39 cd 01 	vextracti32x4 $0x1,%ymm25,%xmm21
 18aa4d7:	62 c2 7d 48 7d c4    	vpermt2b %zmm12,%zmm0,%zmm16
 18aa4dd:	62 71 7f cb 6f a4 d1 fb 10 00 00 	vmovdqu8 0x10fb(%rcx,%rdx,8),%zmm12{%k3}{z}
 18aa4e8:	62 61 7f cb 6f 8c d1 3b 1c 00 00 	vmovdqu8 0x1c3b(%rcx,%rdx,8),%zmm25{%k3}{z}
 18aa4f3:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 18aa4f9:	62 23 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm24,%xmm21
 18aa500:	62 83 7d 48 39 d8 03 	vextracti32x4 $0x3,%zmm19,%xmm24
 18aa507:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 18aa50e:	62 e1 7f cb 6f ac d1 db 12 00 00 	vmovdqu8 0x12db(%rcx,%rdx,8),%zmm21{%k3}{z}
 18aa519:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 18aa520:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 18aa527:	c4 43 3d 38 c1 01    	vinserti128 $0x1,%xmm9,%ymm8,%ymm8
 18aa52d:	62 71 7f cb 6f 8c d1 1b 0a 00 00 	vmovdqu8 0xa1b(%rcx,%rdx,8),%zmm9{%k3}{z}
 18aa538:	62 53 bd 48 3a c2 01 	vinserti64x4 $0x1,%ymm10,%zmm8,%zmm8
 18aa53f:	62 71 7f c9 6f 94 d1 5b 0a 00 00 	vmovdqu8 0xa5b(%rcx,%rdx,8),%zmm10{%k1}{z}
 18aa54a:	62 f1 3d 48 74 c3    	vpcmpeqb %zmm3,%zmm8,%k0
 18aa550:	62 f1 3d 48 74 fc    	vpcmpeqb %zmm4,%zmm8,%k7
 18aa556:	c4 e1 fc 45 f7       	korq   %k7,%k0,%k6
 18aa55b:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 18aa561:	62 a3 7d 48 39 f6 02 	vextracti32x4 $0x2,%zmm22,%xmm22
 18aa568:	62 c3 5d 00 20 e5 04 	vpinsrb $0x4,%r13d,%xmm20,%xmm20
 18aa56f:	62 c3 7d 08 14 f5 08 	vpextrb $0x8,%xmm22,%r13d
 18aa576:	62 e1 7f cb 6f b4 d1 7b 13 00 00 	vmovdqu8 0x137b(%rcx,%rdx,8),%zmm22{%k3}{z}
 18aa581:	62 c3 5d 00 20 e5 05 	vpinsrb $0x5,%r13d,%xmm20,%xmm20
 18aa588:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 18aa58e:	62 71 7f cb 6f 94 d1 9b 0c 00 00 	vmovdqu8 0xc9b(%rcx,%rdx,8),%zmm10{%k3}{z}
 18aa599:	c4 63 31 20 8c d1 bb 0a 00 00 04 	vpinsrb $0x4,0xabb(%rcx,%rdx,8),%xmm9,%xmm9
 18aa5a4:	c4 63 31 20 8c d1 e3 0a 00 00 05 	vpinsrb $0x5,0xae3(%rcx,%rdx,8),%xmm9,%xmm9
 18aa5af:	62 52 7d 48 7d d3    	vpermt2b %zmm11,%zmm0,%zmm10
 18aa5b5:	62 71 7f cb 6f 9c d1 7b 0e 00 00 	vmovdqu8 0xe7b(%rcx,%rdx,8),%zmm11{%k3}{z}
 18aa5c0:	c4 63 31 20 8c d1 0b 0b 00 00 06 	vpinsrb $0x6,0xb0b(%rcx,%rdx,8),%xmm9,%xmm9
 18aa5cb:	c4 63 31 20 8c d1 33 0b 00 00 07 	vpinsrb $0x7,0xb33(%rcx,%rdx,8),%xmm9,%xmm9
 18aa5d6:	c4 43 29 20 d2 04    	vpinsrb $0x4,%r10d,%xmm10,%xmm10
 18aa5dc:	c4 43 29 20 d1 05    	vpinsrb $0x5,%r9d,%xmm10,%xmm10
 18aa5e2:	c4 63 29 20 d7 06    	vpinsrb $0x6,%edi,%xmm10,%xmm10
 18aa5e8:	62 13 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm11,%xmm24
 18aa5ef:	c4 63 29 20 d6 07    	vpinsrb $0x7,%esi,%xmm10,%xmm10
 18aa5f5:	c4 63 31 20 8c d1 5b 0b 00 00 08 	vpinsrb $0x8,0xb5b(%rcx,%rdx,8),%xmm9,%xmm9
 18aa600:	62 43 7d 08 14 c4 08 	vpextrb $0x8,%xmm24,%r12d
 18aa607:	62 83 7d 48 39 f8 03 	vextracti32x4 $0x3,%zmm23,%xmm24
 18aa60e:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 18aa615:	c4 43 29 20 d7 08    	vpinsrb $0x8,%r15d,%xmm10,%xmm10
 18aa61b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18aa622:	62 61 7f c9 6f 84 d1 1b 13 00 00 	vmovdqu8 0x131b(%rcx,%rdx,8),%zmm24{%k1}{z}
 18aa62d:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 18aa633:	62 e1 7f c9 6f bc d1 bb 13 00 00 	vmovdqu8 0x13bb(%rcx,%rdx,8),%zmm23{%k1}{z}
 18aa63e:	c4 43 29 20 d6 09    	vpinsrb $0x9,%r14d,%xmm10,%xmm10
 18aa644:	62 c3 5d 00 20 e5 06 	vpinsrb $0x6,%r13d,%xmm20,%xmm20
 18aa64b:	62 c1 7d 08 7e dd    	vmovd  %xmm19,%r13d
 18aa651:	c4 43 29 20 d3 0a    	vpinsrb $0xa,%r11d,%xmm10,%xmm10
 18aa657:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 18aa65e:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18aa664:	62 a3 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm21,%xmm21
 18aa66b:	c4 43 29 20 d0 0b    	vpinsrb $0xb,%r8d,%xmm10,%xmm10
 18aa671:	c4 63 31 20 8c d1 83 0b 00 00 09 	vpinsrb $0x9,0xb83(%rcx,%rdx,8),%xmm9,%xmm9
 18aa67c:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 18aa683:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18aa68a:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 18aa691:	c4 63 31 20 8c d1 ab 0b 00 00 0a 	vpinsrb $0xa,0xbab(%rcx,%rdx,8),%xmm9,%xmm9
 18aa69c:	62 23 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm24,%xmm21
 18aa6a3:	62 23 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm24,%xmm19
 18aa6aa:	62 83 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm22,%xmm24
 18aa6b1:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18aa6b7:	62 a3 7d 48 39 fd 03 	vextracti32x4 $0x3,%zmm23,%xmm21
 18aa6be:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 18aa6c5:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18aa6cc:	62 a3 7d 48 39 d3 03 	vextracti32x4 $0x3,%zmm18,%xmm19
 18aa6d3:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 18aa6da:	c4 63 31 20 8c d1 d3 0b 00 00 0b 	vpinsrb $0xb,0xbd3(%rcx,%rdx,8),%xmm9,%xmm9
 18aa6e5:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 18aa6ec:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18aa6f2:	62 a3 7d 28 39 fe 01 	vextracti32x4 $0x1,%ymm23,%xmm22
 18aa6f9:	62 e1 7f cb 6f bc d1 db 17 00 00 	vmovdqu8 0x17db(%rcx,%rdx,8),%zmm23{%k3}{z}
 18aa704:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 18aa70b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18aa712:	62 61 7f c9 6f 84 d1 bb 18 00 00 	vmovdqu8 0x18bb(%rcx,%rdx,8),%zmm24{%k1}{z}
 18aa71d:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 18aa724:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18aa72a:	62 e1 7f c9 6f b4 d1 1b 18 00 00 	vmovdqu8 0x181b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18aa735:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 18aa73c:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18aa743:	62 e1 7f cb 6f ac d1 3b 17 00 00 	vmovdqu8 0x173b(%rcx,%rdx,8),%zmm21{%k3}{z}
 18aa74e:	c4 63 31 20 8c d1 fb 0b 00 00 0c 	vpinsrb $0xc,0xbfb(%rcx,%rdx,8),%xmm9,%xmm9
 18aa759:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 18aa760:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18aa766:	62 a3 7d 48 39 c9 02 	vextracti32x4 $0x2,%zmm17,%xmm17
 18aa76d:	62 e3 7d 00 20 c0 04 	vpinsrb $0x4,%eax,%xmm16,%xmm16
 18aa774:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18aa77b:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 18aa782:	62 e3 7d 00 20 c0 05 	vpinsrb $0x5,%eax,%xmm16,%xmm16
 18aa789:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18aa78f:	62 e1 7f c9 6f 94 d1 7b 17 00 00 	vmovdqu8 0x177b(%rcx,%rdx,8),%zmm18{%k1}{z}
 18aa79a:	62 e3 7d 00 20 c0 06 	vpinsrb $0x6,%eax,%xmm16,%xmm16
 18aa7a1:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18aa7a8:	62 e1 7f c9 6f 9c d1 fb 19 00 00 	vmovdqu8 0x19fb(%rcx,%rdx,8),%zmm19{%k1}{z}
 18aa7b3:	c4 63 31 20 8c d1 23 0c 00 00 0d 	vpinsrb $0xd,0xc23(%rcx,%rdx,8),%xmm9,%xmm9
 18aa7be:	62 e3 7d 00 20 c0 07 	vpinsrb $0x7,%eax,%xmm16,%xmm16
 18aa7c5:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18aa7c9:	62 c1 7d 08 7e ff    	vmovd  %xmm23,%r15d
 18aa7cf:	62 73 7d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm16,%xmm14
 18aa7d6:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18aa7dd:	62 33 7d 28 39 e8 01 	vextracti32x4 $0x1,%ymm13,%xmm16
 18aa7e4:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 18aa7eb:	62 e1 7f cb 6f 8c d1 bb 19 00 00 	vmovdqu8 0x19bb(%rcx,%rdx,8),%zmm17{%k3}{z}
 18aa7f6:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 18aa7fc:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18aa802:	62 33 7d 48 39 e0 02 	vextracti32x4 $0x2,%zmm12,%xmm16
 18aa809:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 18aa80f:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18aa815:	62 53 7d 48 39 fd 03 	vextracti32x4 $0x3,%zmm15,%xmm13
 18aa81c:	62 c1 7d 08 7e ea    	vmovd  %xmm21,%r10d
 18aa822:	c4 63 31 20 8c d1 4b 0c 00 00 0e 	vpinsrb $0xe,0xc4b(%rcx,%rdx,8),%xmm9,%xmm9
 18aa82d:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 18aa833:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18aa837:	c4 63 09 20 e0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm12
 18aa83d:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18aa844:	c4 43 7d 39 fe 01    	vextracti128 $0x1,%ymm15,%xmm14
 18aa84a:	62 e1 7f c9 6f 84 d1 db 1b 00 00 	vmovdqu8 0x1bdb(%rcx,%rdx,8),%zmm16{%k1}{z}
 18aa855:	62 71 7f cb 6f bc d1 1b 19 00 00 	vmovdqu8 0x191b(%rcx,%rdx,8),%zmm15{%k3}{z}
 18aa860:	c4 63 19 20 e0 0d    	vpinsrb $0xd,%eax,%xmm12,%xmm12
 18aa866:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18aa86a:	62 71 7f cb 6f b4 d1 5b 1a 00 00 	vmovdqu8 0x1a5b(%rcx,%rdx,8),%zmm14{%k3}{z}
 18aa875:	c4 63 19 20 e0 0e    	vpinsrb $0xe,%eax,%xmm12,%xmm12
 18aa87b:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18aa881:	62 71 7f c9 6f ac d1 5b 19 00 00 	vmovdqu8 0x195b(%rcx,%rdx,8),%zmm13{%k1}{z}
 18aa88c:	c4 63 31 20 8c d1 73 0c 00 00 0f 	vpinsrb $0xf,0xc73(%rcx,%rdx,8),%xmm9,%xmm9
 18aa897:	c4 63 19 20 e0 0f    	vpinsrb $0xf,%eax,%xmm12,%xmm12
 18aa89d:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18aa8a1:	c4 63 29 20 d0 0c    	vpinsrb $0xc,%eax,%xmm10,%xmm10
 18aa8a7:	62 33 1d 28 38 dc 01 	vinserti32x4 $0x1,%xmm20,%ymm12,%ymm11
 18aa8ae:	62 71 7f c9 6f a4 d1 db 16 00 00 	vmovdqu8 0x16db(%rcx,%rdx,8),%zmm12{%k1}{z}
 18aa8b9:	62 e1 7f cb 6f a4 d1 9b 1b 00 00 	vmovdqu8 0x1b9b(%rcx,%rdx,8),%zmm20{%k3}{z}
 18aa8c4:	62 61 7d 08 7e c8    	vmovd  %xmm25,%eax
 18aa8ca:	c4 43 29 20 d4 0d    	vpinsrb $0xd,%r12d,%xmm10,%xmm10
 18aa8d0:	c4 43 29 20 d5 0e    	vpinsrb $0xe,%r13d,%xmm10,%xmm10
 18aa8d6:	c4 63 29 20 d3 0f    	vpinsrb $0xf,%ebx,%xmm10,%xmm10
 18aa8dc:	62 52 7d 48 7d fd    	vpermt2b %zmm13,%zmm0,%zmm15
 18aa8e2:	62 71 7f c9 6f ac d1 9b 1a 00 00 	vmovdqu8 0x1a9b(%rcx,%rdx,8),%zmm13{%k1}{z}
 18aa8ed:	c4 43 35 38 ca 01    	vinserti128 $0x1,%xmm10,%ymm9,%ymm9
 18aa8f3:	62 71 7f cb 6f 94 d1 1b 14 00 00 	vmovdqu8 0x141b(%rcx,%rdx,8),%zmm10{%k3}{z}
 18aa8fe:	62 53 b5 48 3a cb 01 	vinserti64x4 $0x1,%ymm11,%zmm9,%zmm9
 18aa905:	62 71 7f c9 6f 9c d1 5b 14 00 00 	vmovdqu8 0x145b(%rcx,%rdx,8),%zmm11{%k1}{z}
 18aa910:	62 a2 7d 48 7d e0    	vpermt2b %zmm16,%zmm0,%zmm20
 18aa916:	62 a3 7d 48 39 d0 03 	vextracti32x4 $0x3,%zmm18,%xmm16
 18aa91d:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 18aa924:	62 e1 7d 08 7e d7    	vmovd  %xmm18,%edi
 18aa92a:	62 a3 7d 48 39 ea 02 	vextracti32x4 $0x2,%zmm21,%xmm18
 18aa931:	62 a3 7d 48 39 f5 03 	vextracti32x4 $0x3,%zmm22,%xmm21
 18aa938:	62 e3 7d 08 14 c6 08 	vpextrb $0x8,%xmm16,%esi
 18aa93f:	62 e1 7f cb 6f 84 d1 fb 1a 00 00 	vmovdqu8 0x1afb(%rcx,%rdx,8),%zmm16{%k3}{z}
 18aa94a:	62 f1 35 48 74 ee    	vpcmpeqb %zmm6,%zmm9,%k5
 18aa950:	62 f1 35 48 74 e4    	vpcmpeqb %zmm4,%zmm9,%k4
 18aa956:	62 c3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%r8d
 18aa95d:	62 a3 7d 28 39 f5 01 	vextracti32x4 $0x1,%ymm22,%xmm21
 18aa964:	62 e1 7f c9 6f b4 d1 7b 1c 00 00 	vmovdqu8 0x1c7b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18aa96f:	62 c3 7d 08 14 d1 08 	vpextrb $0x8,%xmm18,%r9d
 18aa976:	62 e1 7f c9 6f 94 d1 3b 1b 00 00 	vmovdqu8 0x1b3b(%rcx,%rdx,8),%zmm18{%k1}{z}
 18aa981:	62 c1 7d 08 7e eb    	vmovd  %xmm21,%r11d
 18aa987:	62 a3 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm23,%xmm21
 18aa98e:	62 e1 7f cb 6f bc d1 db 1c 00 00 	vmovdqu8 0x1cdb(%rcx,%rdx,8),%zmm23{%k3}{z}
 18aa999:	62 c3 7d 08 14 ee 08 	vpextrb $0x8,%xmm21,%r14d
 18aa9a0:	62 23 7d 48 39 c5 03 	vextracti32x4 $0x3,%zmm24,%xmm21
 18aa9a7:	62 e3 7d 08 14 eb 08 	vpextrb $0x8,%xmm21,%ebx
 18aa9ae:	62 e3 5d 00 20 e0 04 	vpinsrb $0x4,%eax,%xmm20,%xmm20
 18aa9b5:	62 52 7d 48 7d d3    	vpermt2b %zmm11,%zmm0,%zmm10
 18aa9bb:	62 71 7f cb 6f 9c d1 9b 16 00 00 	vmovdqu8 0x169b(%rcx,%rdx,8),%zmm11{%k3}{z}
 18aa9c6:	c4 63 29 20 94 d1 bb 14 00 00 04 	vpinsrb $0x4,0x14bb(%rcx,%rdx,8),%xmm10,%xmm10
 18aa9d1:	c4 63 29 20 94 d1 e3 14 00 00 05 	vpinsrb $0x5,0x14e3(%rcx,%rdx,8),%xmm10,%xmm10
 18aa9dc:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 18aa9e2:	62 71 7f cb 6f a4 d1 7b 18 00 00 	vmovdqu8 0x187b(%rcx,%rdx,8),%zmm12{%k3}{z}
 18aa9ed:	c4 63 29 20 94 d1 0b 15 00 00 06 	vpinsrb $0x6,0x150b(%rcx,%rdx,8),%xmm10,%xmm10
 18aa9f8:	c4 63 29 20 94 d1 33 15 00 00 07 	vpinsrb $0x7,0x1533(%rcx,%rdx,8),%xmm10,%xmm10
 18aaa03:	c4 43 21 20 da 04    	vpinsrb $0x4,%r10d,%xmm11,%xmm11
 18aaa09:	c4 43 21 20 d9 05    	vpinsrb $0x5,%r9d,%xmm11,%xmm11
 18aaa0f:	c4 63 21 20 df 06    	vpinsrb $0x6,%edi,%xmm11,%xmm11
 18aaa15:	62 33 7d 48 39 e5 02 	vextracti32x4 $0x2,%zmm12,%xmm21
 18aaa1c:	c4 63 21 20 de 07    	vpinsrb $0x7,%esi,%xmm11,%xmm11
 18aaa22:	c4 63 29 20 94 d1 5b 15 00 00 08 	vpinsrb $0x8,0x155b(%rcx,%rdx,8),%xmm10,%xmm10
 18aaa2d:	62 c3 7d 08 14 ec 08 	vpextrb $0x8,%xmm21,%r12d
 18aaa34:	62 23 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm24,%xmm21
 18aaa3b:	62 03 7d 48 39 c8 02 	vextracti32x4 $0x2,%zmm25,%xmm24
 18aaa42:	c4 43 21 20 df 08    	vpinsrb $0x8,%r15d,%xmm11,%xmm11
 18aaa48:	62 c1 7d 08 7e ed    	vmovd  %xmm21,%r13d
 18aaa4e:	62 e1 7f c9 6f ac d1 1b 1d 00 00 	vmovdqu8 0x1d1b(%rcx,%rdx,8),%zmm21{%k1}{z}
 18aaa59:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18aaa60:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18aaa67:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18aaa6e:	c4 43 21 20 de 09    	vpinsrb $0x9,%r14d,%xmm11,%xmm11
 18aaa74:	62 e3 5d 00 20 e0 05 	vpinsrb $0x5,%eax,%xmm20,%xmm20
 18aaa7b:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18aaa81:	62 61 7f cb 6f 84 d1 7b 1d 00 00 	vmovdqu8 0x1d7b(%rcx,%rdx,8),%zmm24{%k3}{z}
 18aaa8c:	c4 43 21 20 db 0a    	vpinsrb $0xa,%r11d,%xmm11,%xmm11
 18aaa92:	62 e3 5d 00 20 e0 06 	vpinsrb $0x6,%eax,%xmm20,%xmm20
 18aaa99:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18aaaa0:	62 e1 7f c9 6f b4 d1 bb 1d 00 00 	vmovdqu8 0x1dbb(%rcx,%rdx,8),%zmm22{%k1}{z}
 18aaaab:	c4 43 21 20 d8 0b    	vpinsrb $0xb,%r8d,%xmm11,%xmm11
 18aaab1:	c4 63 29 20 94 d1 83 15 00 00 09 	vpinsrb $0x9,0x1583(%rcx,%rdx,8),%xmm10,%xmm10
 18aaabc:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 18aaac3:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18aaac9:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18aaad0:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 18aaad7:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18aaade:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 18aaae5:	c4 63 29 20 94 d1 ab 15 00 00 0a 	vpinsrb $0xa,0x15ab(%rcx,%rdx,8),%xmm10,%xmm10
 18aaaf0:	62 a3 7d 48 39 ef 03 	vextracti32x4 $0x3,%zmm21,%xmm23
 18aaaf7:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 18aaafe:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18aab04:	62 a3 7d 48 39 dd 03 	vextracti32x4 $0x3,%zmm19,%xmm21
 18aab0b:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 18aab12:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 18aab19:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18aab20:	62 a3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm23
 18aab27:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18aab2e:	c4 63 29 20 94 d1 d3 15 00 00 0b 	vpinsrb $0xb,0x15d3(%rcx,%rdx,8),%xmm10,%xmm10
 18aab39:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 18aab40:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18aab46:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18aab4d:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 18aab54:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18aab5b:	62 61 7f c9 6f 84 d1 1b 22 00 00 	vmovdqu8 0x221b(%rcx,%rdx,8),%zmm24{%k1}{z}
 18aab66:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 18aab6d:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18aab73:	62 e1 7f c9 6f b4 d1 bb 22 00 00 	vmovdqu8 0x22bb(%rcx,%rdx,8),%zmm22{%k1}{z}
 18aab7e:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 18aab85:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18aab8c:	62 e1 7f cb 6f bc d1 db 21 00 00 	vmovdqu8 0x21db(%rcx,%rdx,8),%zmm23{%k3}{z}
 18aab97:	c4 63 29 20 94 d1 fb 15 00 00 0c 	vpinsrb $0xc,0x15fb(%rcx,%rdx,8),%xmm10,%xmm10
 18aaba2:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 18aaba9:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18aabaf:	62 a3 7d 48 39 c9 02 	vextracti32x4 $0x2,%zmm17,%xmm17
 18aabb6:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 18aabbc:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18aabc3:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 18aabca:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 18aabd0:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18aabd6:	62 e1 7f c9 6f 9c d1 7b 21 00 00 	vmovdqu8 0x217b(%rcx,%rdx,8),%zmm19{%k1}{z}
 18aabe1:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 18aabe7:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18aabee:	62 e1 7f cb 6f ac d1 9b 25 00 00 	vmovdqu8 0x259b(%rcx,%rdx,8),%zmm21{%k3}{z}
 18aabf9:	c4 63 29 20 94 d1 23 16 00 00 0d 	vpinsrb $0xd,0x1623(%rcx,%rdx,8),%xmm10,%xmm10
 18aac04:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 18aac0a:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18aac0e:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 18aac14:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18aac1b:	c4 43 7d 39 ef 01    	vextracti128 $0x1,%ymm13,%xmm15
 18aac21:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 18aac28:	62 e1 7f c9 6f 8c d1 db 25 00 00 	vmovdqu8 0x25db(%rcx,%rdx,8),%zmm17{%k1}{z}
 18aac33:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 18aac39:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18aac3d:	62 c3 7d 48 39 c7 02 	vextracti32x4 $0x2,%zmm16,%xmm15
 18aac44:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 18aac4a:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18aac50:	62 c3 7d 48 39 d5 03 	vextracti32x4 $0x3,%zmm18,%xmm13
 18aac57:	62 c1 7d 08 7e ff    	vmovd  %xmm23,%r15d
 18aac5d:	c4 63 29 20 94 d1 4b 16 00 00 0e 	vpinsrb $0xe,0x164b(%rcx,%rdx,8),%xmm10,%xmm10
 18aac68:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 18aac6e:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18aac74:	62 e1 7f cb 6f 84 d1 bb 23 00 00 	vmovdqu8 0x23bb(%rcx,%rdx,8),%zmm16{%k3}{z}
 18aac7f:	c4 63 09 20 f0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm14
 18aac85:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18aac8b:	62 c3 7d 28 39 d7 01 	vextracti32x4 $0x1,%ymm18,%xmm15
 18aac92:	62 e1 7f c9 6f 94 d1 fb 23 00 00 	vmovdqu8 0x23fb(%rcx,%rdx,8),%zmm18{%k1}{z}
 18aac9d:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 18aaca3:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18aaca7:	62 71 7f cb 6f bc d1 1b 23 00 00 	vmovdqu8 0x231b(%rcx,%rdx,8),%zmm15{%k3}{z}
 18aacb2:	c4 63 09 20 f0 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm14
 18aacb8:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18aacbe:	c4 63 29 20 94 d1 73 16 00 00 0f 	vpinsrb $0xf,0x1673(%rcx,%rdx,8),%xmm10,%xmm10
 18aacc9:	c4 63 09 20 e8 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm13
 18aaccf:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18aacd3:	62 71 7f c9 6f b4 d1 5b 23 00 00 	vmovdqu8 0x235b(%rcx,%rdx,8),%zmm14{%k1}{z}
 18aacde:	c4 63 21 20 d8 0c    	vpinsrb $0xc,%eax,%xmm11,%xmm11
 18aace4:	62 33 15 28 38 e4 01 	vinserti32x4 $0x1,%xmm20,%ymm13,%ymm12
 18aaceb:	62 e1 7f cb 6f a4 d1 3b 21 00 00 	vmovdqu8 0x213b(%rcx,%rdx,8),%zmm20{%k3}{z}
 18aacf6:	62 71 7f c9 6f ac d1 db 20 00 00 	vmovdqu8 0x20db(%rcx,%rdx,8),%zmm13{%k1}{z}
 18aad01:	62 a2 7d 48 7d e9    	vpermt2b %zmm17,%zmm0,%zmm21
 18aad07:	62 a3 7d 48 39 d9 03 	vextracti32x4 $0x3,%zmm19,%xmm17
 18aad0e:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 18aad15:	c4 43 21 20 dc 0d    	vpinsrb $0xd,%r12d,%xmm11,%xmm11
 18aad1b:	62 e1 7d 08 7e df    	vmovd  %xmm19,%edi
 18aad21:	62 e3 7d 08 14 ce 08 	vpextrb $0x8,%xmm17,%esi
 18aad28:	62 e1 7f c9 6f 8c d1 9b 24 00 00 	vmovdqu8 0x249b(%rcx,%rdx,8),%zmm17{%k1}{z}
 18aad33:	c4 43 21 20 dd 0e    	vpinsrb $0xe,%r13d,%xmm11,%xmm11
 18aad39:	c4 63 21 20 db 0f    	vpinsrb $0xf,%ebx,%xmm11,%xmm11
 18aad3f:	c4 43 2d 38 d3 01    	vinserti128 $0x1,%xmm11,%ymm10,%ymm10
 18aad45:	62 71 7f cb 6f 9c d1 1b 1e 00 00 	vmovdqu8 0x1e1b(%rcx,%rdx,8),%zmm11{%k3}{z}
 18aad50:	62 52 7d 48 7d fe    	vpermt2b %zmm14,%zmm0,%zmm15
 18aad56:	62 71 7f cb 6f b4 d1 5b 24 00 00 	vmovdqu8 0x245b(%rcx,%rdx,8),%zmm14{%k3}{z}
 18aad61:	62 53 ad 48 3a d4 01 	vinserti64x4 $0x1,%ymm12,%zmm10,%zmm10
 18aad68:	62 71 7f c9 6f a4 d1 5b 1e 00 00 	vmovdqu8 0x1e5b(%rcx,%rdx,8),%zmm12{%k1}{z}
 18aad73:	62 a3 7d 48 39 e3 02 	vextracti32x4 $0x2,%zmm20,%xmm19
 18aad7a:	62 c1 7d 08 7e e2    	vmovd  %xmm20,%r10d
 18aad80:	62 a3 7d 48 39 fc 02 	vextracti32x4 $0x2,%zmm23,%xmm20
 18aad87:	62 a3 7d 48 39 f7 03 	vextracti32x4 $0x3,%zmm22,%xmm23
 18aad8e:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18aad95:	62 c3 7d 08 14 d9 08 	vpextrb $0x8,%xmm19,%r9d
 18aad9c:	62 23 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm24,%xmm19
 18aada3:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 18aadaa:	62 c3 7d 08 14 fe 08 	vpextrb $0x8,%xmm23,%r14d
 18aadb1:	62 c3 7d 08 14 e3 08 	vpextrb $0x8,%xmm20,%r11d
 18aadb8:	62 e1 7f c9 6f a4 d1 3b 25 00 00 	vmovdqu8 0x253b(%rcx,%rdx,8),%zmm20{%k1}{z}
 18aadc3:	62 f1 2d 48 74 c4    	vpcmpeqb %zmm4,%zmm10,%k0
 18aadc9:	62 61 7d 08 7e c3    	vmovd  %xmm24,%ebx
 18aadcf:	62 61 7f cb 6f 84 d1 3b 26 00 00 	vmovdqu8 0x263b(%rcx,%rdx,8),%zmm24{%k3}{z}
 18aadda:	62 c3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%r8d
 18aade1:	62 e1 7f cb 6f 9c d1 fb 24 00 00 	vmovdqu8 0x24fb(%rcx,%rdx,8),%zmm19{%k3}{z}
 18aadec:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 18aadf2:	62 71 7f cb 6f a4 d1 9b 20 00 00 	vmovdqu8 0x209b(%rcx,%rdx,8),%zmm12{%k3}{z}
 18aadfd:	c4 63 21 20 9c d1 bb 1e 00 00 04 	vpinsrb $0x4,0x1ebb(%rcx,%rdx,8),%xmm11,%xmm11
 18aae08:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 18aae0e:	62 c3 55 00 20 ed 04 	vpinsrb $0x4,%r13d,%xmm21,%xmm21
 18aae15:	62 c1 7d 08 7e f5    	vmovd  %xmm22,%r13d
 18aae1b:	c4 63 21 20 9c d1 e3 1e 00 00 05 	vpinsrb $0x5,0x1ee3(%rcx,%rdx,8),%xmm11,%xmm11
 18aae26:	62 52 7d 48 7d e5    	vpermt2b %zmm13,%zmm0,%zmm12
 18aae2c:	62 71 7f cb 6f ac d1 7b 22 00 00 	vmovdqu8 0x227b(%rcx,%rdx,8),%zmm13{%k3}{z}
 18aae37:	c4 63 21 20 9c d1 0b 1f 00 00 06 	vpinsrb $0x6,0x1f0b(%rcx,%rdx,8),%xmm11,%xmm11
 18aae42:	c4 63 21 20 9c d1 33 1f 00 00 07 	vpinsrb $0x7,0x1f33(%rcx,%rdx,8),%xmm11,%xmm11
 18aae4d:	c4 43 19 20 e2 04    	vpinsrb $0x4,%r10d,%xmm12,%xmm12
 18aae53:	44 0f b6 94 d1 a2 01 00 00 	movzbl 0x1a2(%rcx,%rdx,8),%r10d
 18aae5c:	c4 43 19 20 e1 05    	vpinsrb $0x5,%r9d,%xmm12,%xmm12
 18aae62:	44 0f b6 8c d1 ca 01 00 00 	movzbl 0x1ca(%rcx,%rdx,8),%r9d
 18aae6b:	c4 63 19 20 e7 06    	vpinsrb $0x6,%edi,%xmm12,%xmm12
 18aae71:	0f b6 bc d1 1a 02 00 00 	movzbl 0x21a(%rcx,%rdx,8),%edi
 18aae79:	62 33 7d 48 39 ef 02 	vextracti32x4 $0x2,%zmm13,%xmm23
 18aae80:	c4 63 19 20 e6 07    	vpinsrb $0x7,%esi,%xmm12,%xmm12
 18aae86:	0f b6 b4 d1 42 02 00 00 	movzbl 0x242(%rcx,%rdx,8),%esi
 18aae8e:	62 c3 7d 08 14 fc 08 	vpextrb $0x8,%xmm23,%r12d
 18aae95:	62 23 7d 48 39 c7 02 	vextracti32x4 $0x2,%zmm24,%xmm23
 18aae9c:	62 61 7f cb 6f 84 d1 db 26 00 00 	vmovdqu8 0x26db(%rcx,%rdx,8),%zmm24{%k3}{z}
 18aaea7:	c4 63 21 20 9c d1 5b 1f 00 00 08 	vpinsrb $0x8,0x1f5b(%rcx,%rdx,8),%xmm11,%xmm11
 18aaeb2:	c4 43 19 20 e7 08    	vpinsrb $0x8,%r15d,%xmm12,%xmm12
 18aaeb8:	44 0f b6 bc d1 02 01 00 00 	movzbl 0x102(%rcx,%rdx,8),%r15d
 18aaec1:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18aaec8:	62 e1 7f c9 6f bc d1 7b 26 00 00 	vmovdqu8 0x267b(%rcx,%rdx,8),%zmm23{%k1}{z}
 18aaed3:	c4 43 19 20 e3 09    	vpinsrb $0x9,%r11d,%xmm12,%xmm12
 18aaed9:	44 0f b6 9c d1 7a 01 00 00 	movzbl 0x17a(%rcx,%rdx,8),%r11d
 18aaee2:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 18aaee9:	c4 63 19 20 e3 0a    	vpinsrb $0xa,%ebx,%xmm12,%xmm12
 18aaeef:	0f b6 9c d1 52 01 00 00 	movzbl 0x152(%rcx,%rdx,8),%ebx
 18aaef7:	c4 43 19 20 e0 0b    	vpinsrb $0xb,%r8d,%xmm12,%xmm12
 18aaefd:	44 0f b6 84 d1 f2 01 00 00 	movzbl 0x1f2(%rcx,%rdx,8),%r8d
 18aaf06:	c4 63 21 20 9c d1 83 1f 00 00 09 	vpinsrb $0x9,0x1f83(%rcx,%rdx,8),%xmm11,%xmm11
 18aaf11:	c4 63 21 20 9c d1 ab 1f 00 00 0a 	vpinsrb $0xa,0x1fab(%rcx,%rdx,8),%xmm11,%xmm11
 18aaf1c:	62 a3 7d 28 39 fe 01 	vextracti32x4 $0x1,%ymm23,%xmm22
 18aaf23:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18aaf2a:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18aaf30:	62 e1 7f c9 6f b4 d1 1b 27 00 00 	vmovdqu8 0x271b(%rcx,%rdx,8),%zmm22{%k1}{z}
 18aaf3b:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 18aaf42:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18aaf49:	62 e1 7f cb 6f bc d1 7b 27 00 00 	vmovdqu8 0x277b(%rcx,%rdx,8),%zmm23{%k3}{z}
 18aaf54:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 18aaf5b:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18aaf61:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18aaf68:	c4 63 21 20 9c d1 d3 1f 00 00 0b 	vpinsrb $0xb,0x1fd3(%rcx,%rdx,8),%xmm11,%xmm11
 18aaf73:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 18aaf7a:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18aaf81:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 18aaf88:	c4 63 21 20 9c d1 fb 1f 00 00 0c 	vpinsrb $0xc,0x1ffb(%rcx,%rdx,8),%xmm11,%xmm11
 18aaf93:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18aaf9a:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18aafa1:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18aafa7:	62 61 7f c9 6f 84 d1 bb 27 00 00 	vmovdqu8 0x27bb(%rcx,%rdx,8),%zmm24{%k1}{z}
 18aafb2:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 18aafb9:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18aafc0:	62 a3 7d 48 39 d6 03 	vextracti32x4 $0x3,%zmm18,%xmm22
 18aafc7:	62 a3 7d 28 39 d2 01 	vextracti32x4 $0x1,%ymm18,%xmm18
 18aafce:	c4 63 21 20 9c d1 23 20 00 00 0d 	vpinsrb $0xd,0x2023(%rcx,%rdx,8),%xmm11,%xmm11
 18aafd9:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 18aafe0:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18aafe6:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18aafed:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 18aaff4:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18aaffb:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 18ab002:	c4 63 21 20 9c d1 4b 20 00 00 0e 	vpinsrb $0xe,0x204b(%rcx,%rdx,8),%xmm11,%xmm11
 18ab00d:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 18ab014:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 18ab01b:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab021:	62 61 7f cb 6f 84 d1 32 08 00 00 	vmovdqu8 0x832(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ab02c:	c4 63 21 20 9c d1 73 20 00 00 0f 	vpinsrb $0xf,0x2073(%rcx,%rdx,8),%xmm11,%xmm11
 18ab037:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 18ab03e:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab045:	62 e1 7f cb 6f bc d1 92 07 00 00 	vmovdqu8 0x792(%rcx,%rdx,8),%zmm23{%k3}{z}
 18ab050:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 18ab057:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18ab05d:	62 a3 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm16,%xmm16
 18ab064:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 18ab06a:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18ab071:	62 33 7d 48 39 f0 02 	vextracti32x4 $0x2,%zmm14,%xmm16
 18ab078:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 18ab07e:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18ab084:	62 e1 7f cb 6f 94 d1 32 03 00 00 	vmovdqu8 0x332(%rcx,%rdx,8),%zmm18{%k3}{z}
 18ab08f:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 18ab095:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18ab09c:	62 e1 7f c9 6f b4 d1 d2 07 00 00 	vmovdqu8 0x7d2(%rcx,%rdx,8),%zmm22{%k1}{z}
 18ab0a7:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 18ab0ad:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18ab0b1:	c4 63 01 20 f0 08    	vpinsrb $0x8,%eax,%xmm15,%xmm14
 18ab0b7:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18ab0be:	62 c3 7d 28 39 cf 01 	vextracti32x4 $0x1,%ymm17,%xmm15
 18ab0c5:	62 a3 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm19,%xmm16
 18ab0cc:	c4 63 09 20 f0 09    	vpinsrb $0x9,%eax,%xmm14,%xmm14
 18ab0d2:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18ab0d6:	62 c3 7d 48 39 cf 03 	vextracti32x4 $0x3,%zmm17,%xmm15
 18ab0dd:	62 e1 7f cb 6f 8c d1 92 02 00 00 	vmovdqu8 0x292(%rcx,%rdx,8),%zmm17{%k3}{z}
 18ab0e8:	c4 63 09 20 f0 0a    	vpinsrb $0xa,%eax,%xmm14,%xmm14
 18ab0ee:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18ab0f4:	62 c3 7d 48 39 e7 03 	vextracti32x4 $0x3,%zmm20,%xmm15
 18ab0fb:	c4 63 09 20 f0 0b    	vpinsrb $0xb,%eax,%xmm14,%xmm14
 18ab101:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18ab107:	62 e1 7f c9 6f 9c d1 72 03 00 00 	vmovdqu8 0x372(%rcx,%rdx,8),%zmm19{%k1}{z}
 18ab112:	c4 63 09 20 f0 0c    	vpinsrb $0xc,%eax,%xmm14,%xmm14
 18ab118:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18ab11f:	62 a3 7d 28 39 e0 01 	vextracti32x4 $0x1,%ymm20,%xmm16
 18ab126:	62 e1 7f cb 6f a4 d1 12 05 00 00 	vmovdqu8 0x512(%rcx,%rdx,8),%zmm20{%k3}{z}
 18ab131:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 18ab137:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18ab13d:	62 e1 7f cb 6f 84 d1 d2 03 00 00 	vmovdqu8 0x3d2(%rcx,%rdx,8),%zmm16{%k3}{z}
 18ab148:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 18ab14e:	62 e1 7f c9 6f b4 d1 72 08 00 00 	vmovdqu8 0x872(%rcx,%rdx,8),%zmm22{%k1}{z}
 18ab159:	c4 63 09 20 f0 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm14
 18ab15f:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18ab165:	62 71 7f c9 6f bc d1 12 04 00 00 	vmovdqu8 0x412(%rcx,%rdx,8),%zmm15{%k1}{z}
 18ab170:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 18ab176:	c5 79 7e e8          	vmovd  %xmm13,%eax
 18ab17a:	c4 63 19 20 e0 0c    	vpinsrb $0xc,%eax,%xmm12,%xmm12
 18ab180:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab186:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18ab18d:	62 33 0d 28 38 ed 01 	vinserti32x4 $0x1,%xmm21,%ymm14,%ymm13
 18ab194:	62 e1 7f c9 6f ac d1 52 05 00 00 	vmovdqu8 0x552(%rcx,%rdx,8),%zmm21{%k1}{z}
 18ab19f:	62 71 7f cb 6f b4 d1 72 04 00 00 	vmovdqu8 0x472(%rcx,%rdx,8),%zmm14{%k3}{z}
 18ab1aa:	c4 43 19 20 e4 0d    	vpinsrb $0xd,%r12d,%xmm12,%xmm12
 18ab1b0:	44 0f b6 a4 d1 da 00 00 00 	movzbl 0xda(%rcx,%rdx,8),%r12d
 18ab1b9:	c4 43 19 20 e5 0e    	vpinsrb $0xe,%r13d,%xmm12,%xmm12
 18ab1bf:	44 0f b6 ac d1 b2 00 00 00 	movzbl 0xb2(%rcx,%rdx,8),%r13d
 18ab1c8:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 18ab1cf:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab1d6:	c4 43 19 20 e6 0f    	vpinsrb $0xf,%r14d,%xmm12,%xmm12
 18ab1dc:	44 0f b6 b4 d1 2a 01 00 00 	movzbl 0x12a(%rcx,%rdx,8),%r14d
 18ab1e5:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 18ab1ec:	c4 43 25 38 dc 01    	vinserti128 $0x1,%xmm12,%ymm11,%ymm11
 18ab1f2:	62 71 7f cb 6f a4 d1 12 00 00 00 	vmovdqu8 0x12(%rcx,%rdx,8),%zmm12{%k3}{z}
 18ab1fd:	62 53 a5 48 3a dd 01 	vinserti64x4 $0x1,%ymm13,%zmm11,%zmm11
 18ab204:	62 71 7f c9 6f ac d1 52 00 00 00 	vmovdqu8 0x52(%rcx,%rdx,8),%zmm13{%k1}{z}
 18ab20f:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18ab216:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18ab21d:	62 f1 25 48 74 fb    	vpcmpeqb %zmm3,%zmm11,%k7
 18ab223:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab229:	62 61 7f cb 6f 84 d1 d2 08 00 00 	vmovdqu8 0x8d2(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ab234:	62 e3 45 00 20 f8 06 	vpinsrb $0x6,%eax,%xmm23,%xmm23
 18ab23b:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18ab242:	62 e1 7f c9 6f b4 d1 12 09 00 00 	vmovdqu8 0x912(%rcx,%rdx,8),%zmm22{%k1}{z}
 18ab24d:	62 a2 7d 48 7d e5    	vpermt2b %zmm21,%zmm0,%zmm20
 18ab253:	62 e1 7f cb 6f ac d1 b2 05 00 00 	vmovdqu8 0x5b2(%rcx,%rdx,8),%zmm21{%k3}{z}
 18ab25e:	62 e3 45 00 20 f8 07 	vpinsrb $0x7,%eax,%xmm23,%xmm23
 18ab265:	62 52 7d 48 7d e5    	vpermt2b %zmm13,%zmm0,%zmm12
 18ab26b:	62 71 7f c9 6f ac d1 d2 02 00 00 	vmovdqu8 0x2d2(%rcx,%rdx,8),%zmm13{%k1}{z}
 18ab276:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab27c:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18ab283:	62 e3 45 00 20 f8 08 	vpinsrb $0x8,%eax,%xmm23,%xmm23
 18ab28a:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab291:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18ab298:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18ab29f:	62 e3 45 00 20 f8 09 	vpinsrb $0x9,%eax,%xmm23,%xmm23
 18ab2a6:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab2ac:	62 61 7f cb 6f 84 d1 72 09 00 00 	vmovdqu8 0x972(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ab2b7:	62 e3 45 00 20 f8 0a 	vpinsrb $0xa,%eax,%xmm23,%xmm23
 18ab2be:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18ab2c5:	62 e1 7f c9 6f b4 d1 b2 09 00 00 	vmovdqu8 0x9b2(%rcx,%rdx,8),%zmm22{%k1}{z}
 18ab2d0:	c4 43 19 20 e5 04    	vpinsrb $0x4,%r13d,%xmm12,%xmm12
 18ab2d6:	44 0f b6 ac d1 b2 0a 00 00 	movzbl 0xab2(%rcx,%rdx,8),%r13d
 18ab2df:	62 e3 45 00 20 f8 0b 	vpinsrb $0xb,%eax,%xmm23,%xmm23
 18ab2e6:	c4 43 19 20 e4 05    	vpinsrb $0x5,%r12d,%xmm12,%xmm12
 18ab2ec:	44 0f b6 a4 d1 da 0a 00 00 	movzbl 0xada(%rcx,%rdx,8),%r12d
 18ab2f5:	c4 43 19 20 e7 06    	vpinsrb $0x6,%r15d,%xmm12,%xmm12
 18ab2fb:	44 0f b6 bc d1 02 0b 00 00 	movzbl 0xb02(%rcx,%rdx,8),%r15d
 18ab304:	62 c2 7d 48 7d cd    	vpermt2b %zmm13,%zmm0,%zmm17
 18ab30a:	62 71 7f c9 6f ac d1 b2 04 00 00 	vmovdqu8 0x4b2(%rcx,%rdx,8),%zmm13{%k1}{z}
 18ab315:	c4 43 19 20 e6 07    	vpinsrb $0x7,%r14d,%xmm12,%xmm12
 18ab31b:	44 0f b6 b4 d1 2a 0b 00 00 	movzbl 0xb2a(%rcx,%rdx,8),%r14d
 18ab324:	c4 63 19 20 e3 08    	vpinsrb $0x8,%ebx,%xmm12,%xmm12
 18ab32a:	0f b6 9c d1 52 0b 00 00 	movzbl 0xb52(%rcx,%rdx,8),%ebx
 18ab332:	c4 43 19 20 e3 09    	vpinsrb $0x9,%r11d,%xmm12,%xmm12
 18ab338:	44 0f b6 9c d1 7a 0b 00 00 	movzbl 0xb7a(%rcx,%rdx,8),%r11d
 18ab341:	c4 43 19 20 e2 0a    	vpinsrb $0xa,%r10d,%xmm12,%xmm12
 18ab347:	44 0f b6 94 d1 a2 0b 00 00 	movzbl 0xba2(%rcx,%rdx,8),%r10d
 18ab350:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab356:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18ab35d:	c4 43 19 20 e1 0b    	vpinsrb $0xb,%r9d,%xmm12,%xmm12
 18ab363:	44 0f b6 8c d1 ca 0b 00 00 	movzbl 0xbca(%rcx,%rdx,8),%r9d
 18ab36c:	62 e3 45 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm23,%xmm23
 18ab373:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab37a:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18ab381:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18ab388:	c4 43 19 20 e0 0c    	vpinsrb $0xc,%r8d,%xmm12,%xmm12
 18ab38e:	44 0f b6 84 d1 f2 0b 00 00 	movzbl 0xbf2(%rcx,%rdx,8),%r8d
 18ab397:	62 e3 45 00 20 f8 0d 	vpinsrb $0xd,%eax,%xmm23,%xmm23
 18ab39e:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab3a4:	62 61 7f c9 6f 84 d1 f2 05 00 00 	vmovdqu8 0x5f2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18ab3af:	c4 63 19 20 e7 0d    	vpinsrb $0xd,%edi,%xmm12,%xmm12
 18ab3b5:	0f b6 bc d1 1a 0c 00 00 	movzbl 0xc1a(%rcx,%rdx,8),%edi
 18ab3bd:	62 e3 45 00 20 f8 0e 	vpinsrb $0xe,%eax,%xmm23,%xmm23
 18ab3c4:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18ab3cb:	c4 63 19 20 e6 0e    	vpinsrb $0xe,%esi,%xmm12,%xmm12
 18ab3d1:	0f b6 b4 d1 42 0c 00 00 	movzbl 0xc42(%rcx,%rdx,8),%esi
 18ab3d9:	62 e3 45 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm23,%xmm22
 18ab3e0:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18ab3e6:	62 a3 7d 48 39 ef 02 	vextracti32x4 $0x2,%zmm21,%xmm23
 18ab3ed:	62 e1 7f cb 6f ac d1 52 06 00 00 	vmovdqu8 0x652(%rcx,%rdx,8),%zmm21{%k3}{z}
 18ab3f8:	62 e3 5d 00 20 e0 04 	vpinsrb $0x4,%eax,%xmm20,%xmm20
 18ab3ff:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab406:	62 e3 5d 00 20 e0 05 	vpinsrb $0x5,%eax,%xmm20,%xmm20
 18ab40d:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18ab414:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18ab41b:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ab421:	62 e1 7f c9 6f bc d1 92 06 00 00 	vmovdqu8 0x692(%rcx,%rdx,8),%zmm23{%k1}{z}
 18ab42c:	62 e3 5d 00 20 e0 06 	vpinsrb $0x6,%eax,%xmm20,%xmm20
 18ab433:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab43a:	62 61 7f cb 6f 84 d1 f2 06 00 00 	vmovdqu8 0x6f2(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ab445:	62 e3 5d 00 20 e0 07 	vpinsrb $0x7,%eax,%xmm20,%xmm20
 18ab44c:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18ab452:	62 a3 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm21,%xmm21
 18ab459:	62 e3 5d 00 20 e0 08 	vpinsrb $0x8,%eax,%xmm20,%xmm20
 18ab460:	62 e3 7d 08 14 e8 08 	vpextrb $0x8,%xmm21,%eax
 18ab467:	62 e3 5d 00 20 e0 09 	vpinsrb $0x9,%eax,%xmm20,%xmm20
 18ab46e:	62 a3 7d 28 39 fd 01 	vextracti32x4 $0x1,%ymm23,%xmm21
 18ab475:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18ab47c:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18ab482:	62 e1 7f c9 6f ac d1 32 07 00 00 	vmovdqu8 0x732(%rcx,%rdx,8),%zmm21{%k1}{z}
 18ab48d:	62 e3 5d 00 20 e0 0a 	vpinsrb $0xa,%eax,%xmm20,%xmm20
 18ab494:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab49b:	62 a3 7d 48 39 df 03 	vextracti32x4 $0x3,%zmm19,%xmm23
 18ab4a2:	62 a3 7d 28 39 db 01 	vextracti32x4 $0x1,%ymm19,%xmm19
 18ab4a9:	62 e3 5d 00 20 e0 0b 	vpinsrb $0xb,%eax,%xmm20,%xmm20
 18ab4b0:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab4b6:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18ab4bd:	62 e3 5d 00 20 e0 0c 	vpinsrb $0xc,%eax,%xmm20,%xmm20
 18ab4c4:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab4cb:	62 e3 5d 00 20 e0 0d 	vpinsrb $0xd,%eax,%xmm20,%xmm20
 18ab4d2:	62 83 7d 48 39 e8 03 	vextracti32x4 $0x3,%zmm21,%xmm24
 18ab4d9:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 18ab4e0:	62 e1 7d 08 7e e8    	vmovd  %xmm21,%eax
 18ab4e6:	62 e1 7f cb 6f ac d1 12 0f 00 00 	vmovdqu8 0xf12(%rcx,%rdx,8),%zmm21{%k3}{z}
 18ab4f1:	62 e3 5d 00 20 e0 0e 	vpinsrb $0xe,%eax,%xmm20,%xmm20
 18ab4f8:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab4ff:	62 61 7f cb 6f 84 d1 32 12 00 00 	vmovdqu8 0x1232(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ab50a:	62 e3 5d 00 20 e0 0f 	vpinsrb $0xf,%eax,%xmm20,%xmm20
 18ab511:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18ab517:	62 a3 7d 48 39 d2 02 	vextracti32x4 $0x2,%zmm18,%xmm18
 18ab51e:	62 e3 75 00 20 c8 04 	vpinsrb $0x4,%eax,%xmm17,%xmm17
 18ab525:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18ab52c:	62 a3 7d 48 39 c2 02 	vextracti32x4 $0x2,%zmm16,%xmm18
 18ab533:	62 e3 75 00 20 c8 05 	vpinsrb $0x5,%eax,%xmm17,%xmm17
 18ab53a:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18ab540:	62 e1 7f cb 6f 9c d1 32 0d 00 00 	vmovdqu8 0xd32(%rcx,%rdx,8),%zmm19{%k3}{z}
 18ab54b:	62 e3 75 00 20 c8 06 	vpinsrb $0x6,%eax,%xmm17,%xmm17
 18ab552:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab559:	62 e1 7f cb 6f bc d1 92 11 00 00 	vmovdqu8 0x1192(%rcx,%rdx,8),%zmm23{%k3}{z}
 18ab564:	62 e3 75 00 20 c8 07 	vpinsrb $0x7,%eax,%xmm17,%xmm17
 18ab56b:	62 e1 7d 08 7e c0    	vmovd  %xmm16,%eax
 18ab571:	62 e3 75 00 20 c0 08 	vpinsrb $0x8,%eax,%xmm17,%xmm16
 18ab578:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18ab57f:	62 33 7d 28 39 f9 01 	vextracti32x4 $0x1,%ymm15,%xmm17
 18ab586:	62 53 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm15,%xmm15
 18ab58d:	62 e1 7f cb 6f 94 d1 92 0c 00 00 	vmovdqu8 0xc92(%rcx,%rdx,8),%zmm18{%k3}{z}
 18ab598:	62 e3 7d 00 20 c0 09 	vpinsrb $0x9,%eax,%xmm16,%xmm16
 18ab59f:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18ab5a5:	62 33 7d 48 39 f1 02 	vextracti32x4 $0x2,%zmm14,%xmm17
 18ab5ac:	62 e3 7d 00 20 c0 0a 	vpinsrb $0xa,%eax,%xmm16,%xmm16
 18ab5b3:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18ab5b9:	62 53 7d 48 39 ef 03 	vextracti32x4 $0x3,%zmm13,%xmm15
 18ab5c0:	c4 43 7d 39 ed 01    	vextracti128 $0x1,%ymm13,%xmm13
 18ab5c6:	62 e3 7d 00 20 c0 0b 	vpinsrb $0xb,%eax,%xmm16,%xmm16
 18ab5cd:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18ab5d1:	62 73 7d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm16,%xmm14
 18ab5d8:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18ab5df:	62 e1 7f cb 6f 8c d1 d2 0d 00 00 	vmovdqu8 0xdd2(%rcx,%rdx,8),%zmm17{%k3}{z}
 18ab5ea:	62 e1 7f c9 6f 84 d1 12 0e 00 00 	vmovdqu8 0xe12(%rcx,%rdx,8),%zmm16{%k1}{z}
 18ab5f5:	c4 63 09 20 f0 0d    	vpinsrb $0xd,%eax,%xmm14,%xmm14
 18ab5fb:	c5 79 7e e8          	vmovd  %xmm13,%eax
 18ab5ff:	c4 63 09 20 e8 0e    	vpinsrb $0xe,%eax,%xmm14,%xmm13
 18ab605:	62 33 5d 20 38 f6 01 	vinserti32x4 $0x1,%xmm22,%ymm20,%ymm14
 18ab60c:	62 e1 7f c9 6f b4 d1 52 0f 00 00 	vmovdqu8 0xf52(%rcx,%rdx,8),%zmm22{%k1}{z}
 18ab617:	c4 63 79 14 f8 08    	vpextrb $0x8,%xmm15,%eax
 18ab61d:	62 e1 7f c9 6f a4 d1 72 0d 00 00 	vmovdqu8 0xd72(%rcx,%rdx,8),%zmm20{%k1}{z}
 18ab628:	62 71 7f cb 6f bc d1 72 0e 00 00 	vmovdqu8 0xe72(%rcx,%rdx,8),%zmm15{%k3}{z}
 18ab633:	c4 63 11 20 e8 0f    	vpinsrb $0xf,%eax,%xmm13,%xmm13
 18ab639:	0f b6 84 d1 6a 02 00 00 	movzbl 0x26a(%rcx,%rdx,8),%eax
 18ab641:	c4 63 19 20 e0 0f    	vpinsrb $0xf,%eax,%xmm12,%xmm12
 18ab647:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab64d:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18ab654:	c4 43 1d 38 e5 01    	vinserti128 $0x1,%xmm13,%ymm12,%ymm12
 18ab65a:	62 71 7f cb 6f ac d1 12 0a 00 00 	vmovdqu8 0xa12(%rcx,%rdx,8),%zmm13{%k3}{z}
 18ab665:	62 a2 7d 48 7d ee    	vpermt2b %zmm22,%zmm0,%zmm21
 18ab66b:	62 e1 7f c9 6f b4 d1 d2 11 00 00 	vmovdqu8 0x11d2(%rcx,%rdx,8),%zmm22{%k1}{z}
 18ab676:	62 53 9d 48 3a e6 01 	vinserti64x4 $0x1,%ymm14,%zmm12,%zmm12
 18ab67d:	62 71 7f c9 6f b4 d1 52 0a 00 00 	vmovdqu8 0xa52(%rcx,%rdx,8),%zmm14{%k1}{z}
 18ab688:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 18ab68e:	62 e1 7f c9 6f b4 d1 72 12 00 00 	vmovdqu8 0x1272(%rcx,%rdx,8),%zmm22{%k1}{z}
 18ab699:	62 52 7d 48 7d ee    	vpermt2b %zmm14,%zmm0,%zmm13
 18ab69f:	62 71 7f c9 6f b4 d1 d2 0c 00 00 	vmovdqu8 0xcd2(%rcx,%rdx,8),%zmm14{%k1}{z}
 18ab6aa:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 18ab6b1:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab6b8:	c4 43 11 20 ed 04    	vpinsrb $0x4,%r13d,%xmm13,%xmm13
 18ab6be:	44 0f b6 ac d1 b2 14 00 00 	movzbl 0x14b2(%rcx,%rdx,8),%r13d
 18ab6c7:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 18ab6ce:	c4 43 11 20 ec 05    	vpinsrb $0x5,%r12d,%xmm13,%xmm13
 18ab6d4:	44 0f b6 a4 d1 da 14 00 00 	movzbl 0x14da(%rcx,%rdx,8),%r12d
 18ab6dd:	c4 43 11 20 ef 06    	vpinsrb $0x6,%r15d,%xmm13,%xmm13
 18ab6e3:	44 0f b6 bc d1 02 15 00 00 	movzbl 0x1502(%rcx,%rdx,8),%r15d
 18ab6ec:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 18ab6f3:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18ab6fa:	62 c2 7d 48 7d d6    	vpermt2b %zmm14,%zmm0,%zmm18
 18ab700:	62 71 7f c9 6f b4 d1 b2 0e 00 00 	vmovdqu8 0xeb2(%rcx,%rdx,8),%zmm14{%k1}{z}
 18ab70b:	c4 43 11 20 ee 07    	vpinsrb $0x7,%r14d,%xmm13,%xmm13
 18ab711:	44 0f b6 b4 d1 2a 15 00 00 	movzbl 0x152a(%rcx,%rdx,8),%r14d
 18ab71a:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18ab720:	c4 63 11 20 eb 08    	vpinsrb $0x8,%ebx,%xmm13,%xmm13
 18ab726:	0f b6 9c d1 52 15 00 00 	movzbl 0x1552(%rcx,%rdx,8),%ebx
 18ab72e:	62 e3 45 00 20 f0 06 	vpinsrb $0x6,%eax,%xmm23,%xmm22
 18ab735:	62 e1 7f cb 6f bc d1 d2 12 00 00 	vmovdqu8 0x12d2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18ab740:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab747:	62 61 7f c9 6f 84 d1 12 13 00 00 	vmovdqu8 0x1312(%rcx,%rdx,8),%zmm24{%k1}{z}
 18ab752:	c4 43 11 20 eb 09    	vpinsrb $0x9,%r11d,%xmm13,%xmm13
 18ab758:	44 0f b6 9c d1 7a 15 00 00 	movzbl 0x157a(%rcx,%rdx,8),%r11d
 18ab761:	62 e3 4d 00 20 f0 07 	vpinsrb $0x7,%eax,%xmm22,%xmm22
 18ab768:	c4 43 11 20 ea 0a    	vpinsrb $0xa,%r10d,%xmm13,%xmm13
 18ab76e:	44 0f b6 94 d1 a2 15 00 00 	movzbl 0x15a2(%rcx,%rdx,8),%r10d
 18ab777:	c4 43 11 20 e9 0b    	vpinsrb $0xb,%r9d,%xmm13,%xmm13
 18ab77d:	44 0f b6 8c d1 ca 15 00 00 	movzbl 0x15ca(%rcx,%rdx,8),%r9d
 18ab786:	c4 43 11 20 e8 0c    	vpinsrb $0xc,%r8d,%xmm13,%xmm13
 18ab78c:	44 0f b6 84 d1 f2 15 00 00 	movzbl 0x15f2(%rcx,%rdx,8),%r8d
 18ab795:	c4 63 11 20 ef 0d    	vpinsrb $0xd,%edi,%xmm13,%xmm13
 18ab79b:	0f b6 bc d1 1a 16 00 00 	movzbl 0x161a(%rcx,%rdx,8),%edi
 18ab7a3:	c4 63 11 20 ee 0e    	vpinsrb $0xe,%esi,%xmm13,%xmm13
 18ab7a9:	0f b6 b4 d1 42 16 00 00 	movzbl 0x1642(%rcx,%rdx,8),%esi
 18ab7b1:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ab7b7:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18ab7be:	62 e3 4d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm22,%xmm22
 18ab7c5:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab7cc:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18ab7d3:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18ab7da:	62 e3 4d 00 20 f0 09 	vpinsrb $0x9,%eax,%xmm22,%xmm22
 18ab7e1:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ab7e7:	62 e1 7f cb 6f bc d1 72 13 00 00 	vmovdqu8 0x1372(%rcx,%rdx,8),%zmm23{%k3}{z}
 18ab7f2:	62 e3 4d 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm22,%xmm22
 18ab7f9:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab800:	62 61 7f c9 6f 84 d1 b2 13 00 00 	vmovdqu8 0x13b2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18ab80b:	62 e3 4d 00 20 f0 0b 	vpinsrb $0xb,%eax,%xmm22,%xmm22
 18ab812:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ab818:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18ab81f:	62 e3 4d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm22,%xmm22
 18ab826:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab82d:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18ab834:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18ab83b:	62 e3 4d 00 20 f0 0d 	vpinsrb $0xd,%eax,%xmm22,%xmm22
 18ab842:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ab848:	62 e1 7f cb 6f bc d1 b2 0f 00 00 	vmovdqu8 0xfb2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18ab853:	62 e3 4d 00 20 f0 0e 	vpinsrb $0xe,%eax,%xmm22,%xmm22
 18ab85a:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab861:	62 61 7f c9 6f 84 d1 f2 0f 00 00 	vmovdqu8 0xff2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18ab86c:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 18ab873:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ab879:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18ab880:	62 e3 55 00 20 e8 04 	vpinsrb $0x4,%eax,%xmm21,%xmm21
 18ab887:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab88e:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18ab895:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18ab89c:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 18ab8a3:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ab8a9:	62 e1 7f cb 6f bc d1 52 10 00 00 	vmovdqu8 0x1052(%rcx,%rdx,8),%zmm23{%k3}{z}
 18ab8b4:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 18ab8bb:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab8c2:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 18ab8c9:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ab8cf:	62 83 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm23,%xmm24
 18ab8d6:	62 e1 7f c9 6f bc d1 92 10 00 00 	vmovdqu8 0x1092(%rcx,%rdx,8),%zmm23{%k1}{z}
 18ab8e1:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 18ab8e8:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab8ef:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 18ab8f6:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 18ab8fd:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18ab904:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab90a:	62 61 7f cb 6f 84 d1 f2 10 00 00 	vmovdqu8 0x10f2(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ab915:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 18ab91c:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab923:	62 e1 7f c9 6f bc d1 32 11 00 00 	vmovdqu8 0x1132(%rcx,%rdx,8),%zmm23{%k1}{z}
 18ab92e:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 18ab935:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab93b:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18ab942:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 18ab949:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab950:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 18ab957:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18ab95e:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 18ab965:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ab96b:	62 83 7d 48 39 e0 03 	vextracti32x4 $0x3,%zmm20,%xmm24
 18ab972:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 18ab979:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 18ab980:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ab987:	62 e1 7f cb 6f bc d1 92 1b 00 00 	vmovdqu8 0x1b92(%rcx,%rdx,8),%zmm23{%k3}{z}
 18ab992:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 18ab999:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18ab99f:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18ab9a6:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 18ab9ad:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18ab9b4:	62 a3 7d 48 39 cb 02 	vextracti32x4 $0x2,%zmm17,%xmm19
 18ab9bb:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 18ab9c2:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18ab9c8:	62 e1 7f c9 6f a4 d1 72 17 00 00 	vmovdqu8 0x1772(%rcx,%rdx,8),%zmm20{%k1}{z}
 18ab9d3:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 18ab9da:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ab9e1:	62 61 7f cb 6f 84 d1 32 1c 00 00 	vmovdqu8 0x1c32(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ab9ec:	62 e3 6d 00 20 d0 07 	vpinsrb $0x7,%eax,%xmm18,%xmm18
 18ab9f3:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18ab9f9:	62 e3 6d 00 20 c8 08 	vpinsrb $0x8,%eax,%xmm18,%xmm17
 18aba00:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18aba07:	62 a3 7d 28 39 c2 01 	vextracti32x4 $0x1,%ymm16,%xmm18
 18aba0e:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 18aba15:	62 e1 7f cb 6f 9c d1 32 17 00 00 	vmovdqu8 0x1732(%rcx,%rdx,8),%zmm19{%k3}{z}
 18aba20:	62 e3 75 00 20 c8 09 	vpinsrb $0x9,%eax,%xmm17,%xmm17
 18aba27:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18aba2d:	62 33 7d 48 39 fa 02 	vextracti32x4 $0x2,%zmm15,%xmm18
 18aba34:	62 e3 75 00 20 c8 0a 	vpinsrb $0xa,%eax,%xmm17,%xmm17
 18aba3b:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18aba42:	62 33 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm14,%xmm16
 18aba49:	c4 43 7d 39 f6 01    	vextracti128 $0x1,%ymm14,%xmm14
 18aba4f:	62 e3 75 00 20 c8 0b 	vpinsrb $0xb,%eax,%xmm17,%xmm17
 18aba56:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18aba5a:	62 73 75 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm17,%xmm15
 18aba61:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18aba68:	62 e1 7f cb 6f 94 d1 92 16 00 00 	vmovdqu8 0x1692(%rcx,%rdx,8),%zmm18{%k3}{z}
 18aba73:	62 e1 7f cb 6f 8c d1 d2 17 00 00 	vmovdqu8 0x17d2(%rcx,%rdx,8),%zmm17{%k3}{z}
 18aba7e:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 18aba84:	c5 79 7e f0          	vmovd  %xmm14,%eax
 18aba88:	c4 63 01 20 f0 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm14
 18aba8e:	62 33 55 20 38 fe 01 	vinserti32x4 $0x1,%xmm22,%ymm21,%ymm15
 18aba95:	62 e1 7f c9 6f b4 d1 52 19 00 00 	vmovdqu8 0x1952(%rcx,%rdx,8),%zmm22{%k1}{z}
 18abaa0:	62 e1 7f cb 6f ac d1 12 19 00 00 	vmovdqu8 0x1912(%rcx,%rdx,8),%zmm21{%k3}{z}
 18abaab:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18abab2:	62 e1 7f c9 6f 84 d1 12 18 00 00 	vmovdqu8 0x1812(%rcx,%rdx,8),%zmm16{%k1}{z}
 18ababd:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 18abac3:	0f b6 84 d1 6a 0c 00 00 	movzbl 0xc6a(%rcx,%rdx,8),%eax
 18abacb:	c4 63 11 20 e8 0f    	vpinsrb $0xf,%eax,%xmm13,%xmm13
 18abad1:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18abad7:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18abade:	c4 43 15 38 ee 01    	vinserti128 $0x1,%xmm14,%ymm13,%ymm13
 18abae4:	62 71 7f cb 6f b4 d1 12 14 00 00 	vmovdqu8 0x1412(%rcx,%rdx,8),%zmm14{%k3}{z}
 18abaef:	62 a2 7d 48 7d ee    	vpermt2b %zmm22,%zmm0,%zmm21
 18abaf5:	62 e1 7f c9 6f b4 d1 d2 1b 00 00 	vmovdqu8 0x1bd2(%rcx,%rdx,8),%zmm22{%k1}{z}
 18abb00:	62 53 95 48 3a ef 01 	vinserti64x4 $0x1,%ymm15,%zmm13,%zmm13
 18abb07:	62 71 7f c9 6f bc d1 52 14 00 00 	vmovdqu8 0x1452(%rcx,%rdx,8),%zmm15{%k1}{z}
 18abb12:	62 a2 7d 48 7d fe    	vpermt2b %zmm22,%zmm0,%zmm23
 18abb18:	62 e1 7f c9 6f b4 d1 72 1c 00 00 	vmovdqu8 0x1c72(%rcx,%rdx,8),%zmm22{%k1}{z}
 18abb23:	62 52 7d 48 7d f7    	vpermt2b %zmm15,%zmm0,%zmm14
 18abb29:	62 71 7f c9 6f bc d1 d2 16 00 00 	vmovdqu8 0x16d2(%rcx,%rdx,8),%zmm15{%k1}{z}
 18abb34:	62 e3 45 00 20 f8 04 	vpinsrb $0x4,%eax,%xmm23,%xmm23
 18abb3b:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18abb42:	c4 43 09 20 f5 04    	vpinsrb $0x4,%r13d,%xmm14,%xmm14
 18abb48:	62 e3 45 00 20 f8 05 	vpinsrb $0x5,%eax,%xmm23,%xmm23
 18abb4f:	c4 43 09 20 f4 05    	vpinsrb $0x5,%r12d,%xmm14,%xmm14
 18abb55:	c4 43 09 20 f7 06    	vpinsrb $0x6,%r15d,%xmm14,%xmm14
 18abb5b:	62 83 7d 28 39 f0 01 	vextracti32x4 $0x1,%ymm22,%xmm24
 18abb62:	62 a3 7d 48 39 f6 03 	vextracti32x4 $0x3,%zmm22,%xmm22
 18abb69:	62 c2 7d 48 7d d7    	vpermt2b %zmm15,%zmm0,%zmm18
 18abb6f:	62 71 7f cb 6f bc d1 72 18 00 00 	vmovdqu8 0x1872(%rcx,%rdx,8),%zmm15{%k3}{z}
 18abb7a:	c4 43 09 20 f6 07    	vpinsrb $0x7,%r14d,%xmm14,%xmm14
 18abb80:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18abb86:	62 61 7f cb 6f 84 d1 d2 1c 00 00 	vmovdqu8 0x1cd2(%rcx,%rdx,8),%zmm24{%k3}{z}
 18abb91:	c4 63 09 20 f3 08    	vpinsrb $0x8,%ebx,%xmm14,%xmm14
 18abb97:	62 e3 45 00 20 f8 06 	vpinsrb $0x6,%eax,%xmm23,%xmm23
 18abb9e:	62 e3 7d 08 14 f0 08 	vpextrb $0x8,%xmm22,%eax
 18abba5:	62 e1 7f c9 6f b4 d1 12 1d 00 00 	vmovdqu8 0x1d12(%rcx,%rdx,8),%zmm22{%k1}{z}
 18abbb0:	c4 43 09 20 f3 09    	vpinsrb $0x9,%r11d,%xmm14,%xmm14
 18abbb6:	62 e3 45 00 20 f8 07 	vpinsrb $0x7,%eax,%xmm23,%xmm23
 18abbbd:	c4 43 09 20 f2 0a    	vpinsrb $0xa,%r10d,%xmm14,%xmm14
 18abbc3:	c4 43 09 20 f1 0b    	vpinsrb $0xb,%r9d,%xmm14,%xmm14
 18abbc9:	c4 43 09 20 f0 0c    	vpinsrb $0xc,%r8d,%xmm14,%xmm14
 18abbcf:	c4 63 09 20 f7 0d    	vpinsrb $0xd,%edi,%xmm14,%xmm14
 18abbd5:	c4 63 09 20 f6 0e    	vpinsrb $0xe,%esi,%xmm14,%xmm14
 18abbdb:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18abbe1:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18abbe8:	62 e3 45 00 20 f8 08 	vpinsrb $0x8,%eax,%xmm23,%xmm23
 18abbef:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18abbf6:	62 83 7d 48 39 f0 03 	vextracti32x4 $0x3,%zmm22,%xmm24
 18abbfd:	62 a3 7d 28 39 f6 01 	vextracti32x4 $0x1,%ymm22,%xmm22
 18abc04:	62 e3 45 00 20 f8 09 	vpinsrb $0x9,%eax,%xmm23,%xmm23
 18abc0b:	62 e1 7d 08 7e f0    	vmovd  %xmm22,%eax
 18abc11:	62 e3 45 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm23,%xmm22
 18abc18:	62 e1 7f cb 6f bc d1 72 1d 00 00 	vmovdqu8 0x1d72(%rcx,%rdx,8),%zmm23{%k3}{z}
 18abc23:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18abc2a:	62 61 7f c9 6f 84 d1 b2 1d 00 00 	vmovdqu8 0x1db2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18abc35:	62 e3 4d 00 20 f0 0b 	vpinsrb $0xb,%eax,%xmm22,%xmm22
 18abc3c:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18abc42:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18abc49:	62 e3 4d 00 20 f0 0c 	vpinsrb $0xc,%eax,%xmm22,%xmm22
 18abc50:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18abc57:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18abc5e:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18abc65:	62 e3 4d 00 20 f0 0d 	vpinsrb $0xd,%eax,%xmm22,%xmm22
 18abc6c:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18abc72:	62 e1 7f cb 6f bc d1 b2 19 00 00 	vmovdqu8 0x19b2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18abc7d:	62 e3 4d 00 20 f0 0e 	vpinsrb $0xe,%eax,%xmm22,%xmm22
 18abc84:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18abc8b:	62 61 7f c9 6f 84 d1 f2 19 00 00 	vmovdqu8 0x19f2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18abc96:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 18abc9d:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18abca3:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18abcaa:	62 e3 55 00 20 e8 04 	vpinsrb $0x4,%eax,%xmm21,%xmm21
 18abcb1:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18abcb8:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18abcbf:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18abcc6:	62 e3 55 00 20 e8 05 	vpinsrb $0x5,%eax,%xmm21,%xmm21
 18abccd:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18abcd3:	62 e1 7f cb 6f bc d1 52 1a 00 00 	vmovdqu8 0x1a52(%rcx,%rdx,8),%zmm23{%k3}{z}
 18abcde:	62 e3 55 00 20 e8 06 	vpinsrb $0x6,%eax,%xmm21,%xmm21
 18abce5:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18abcec:	62 61 7f c9 6f 84 d1 92 1a 00 00 	vmovdqu8 0x1a92(%rcx,%rdx,8),%zmm24{%k1}{z}
 18abcf7:	62 e3 55 00 20 e8 07 	vpinsrb $0x7,%eax,%xmm21,%xmm21
 18abcfe:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18abd04:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18abd0b:	62 e3 55 00 20 e8 08 	vpinsrb $0x8,%eax,%xmm21,%xmm21
 18abd12:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18abd19:	62 23 7d 28 39 c7 01 	vextracti32x4 $0x1,%ymm24,%xmm23
 18abd20:	62 03 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm24
 18abd27:	62 e3 55 00 20 e8 09 	vpinsrb $0x9,%eax,%xmm21,%xmm21
 18abd2e:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18abd34:	62 e1 7f cb 6f bc d1 f2 1a 00 00 	vmovdqu8 0x1af2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18abd3f:	62 e3 55 00 20 e8 0a 	vpinsrb $0xa,%eax,%xmm21,%xmm21
 18abd46:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18abd4d:	62 e3 55 00 20 e8 0b 	vpinsrb $0xb,%eax,%xmm21,%xmm21
 18abd54:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18abd5a:	62 83 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm23,%xmm24
 18abd61:	62 e1 7f c9 6f bc d1 32 1b 00 00 	vmovdqu8 0x1b32(%rcx,%rdx,8),%zmm23{%k1}{z}
 18abd6c:	62 e3 55 00 20 e8 0c 	vpinsrb $0xc,%eax,%xmm21,%xmm21
 18abd73:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18abd7a:	62 e3 55 00 20 e8 0d 	vpinsrb $0xd,%eax,%xmm21,%xmm21
 18abd81:	62 83 7d 28 39 f8 01 	vextracti32x4 $0x1,%ymm23,%xmm24
 18abd88:	62 a3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm23,%xmm23
 18abd8f:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18abd95:	62 61 7f c9 6f 84 d1 b2 18 00 00 	vmovdqu8 0x18b2(%rcx,%rdx,8),%zmm24{%k1}{z}
 18abda0:	62 e3 55 00 20 e8 0e 	vpinsrb $0xe,%eax,%xmm21,%xmm21
 18abda7:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18abdae:	62 a3 7d 48 39 e7 03 	vextracti32x4 $0x3,%zmm20,%xmm23
 18abdb5:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 18abdbc:	62 e3 55 00 20 e8 0f 	vpinsrb $0xf,%eax,%xmm21,%xmm21
 18abdc3:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18abdc9:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18abdd0:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 18abdd7:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18abdde:	62 a3 7d 48 39 cb 02 	vextracti32x4 $0x2,%zmm17,%xmm19
 18abde5:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 18abdec:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18abdf2:	62 e1 7f c9 6f a4 d1 52 23 00 00 	vmovdqu8 0x2352(%rcx,%rdx,8),%zmm20{%k1}{z}
 18abdfd:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 18abe04:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18abe0b:	62 e1 7f cb 6f bc d1 32 21 00 00 	vmovdqu8 0x2132(%rcx,%rdx,8),%zmm23{%k3}{z}
 18abe16:	62 e3 6d 00 20 d0 07 	vpinsrb $0x7,%eax,%xmm18,%xmm18
 18abe1d:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18abe23:	62 e3 6d 00 20 c8 08 	vpinsrb $0x8,%eax,%xmm18,%xmm17
 18abe2a:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18abe31:	62 a3 7d 28 39 c2 01 	vextracti32x4 $0x1,%ymm16,%xmm18
 18abe38:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 18abe3f:	62 e1 7f cb 6f 9c d1 d2 21 00 00 	vmovdqu8 0x21d2(%rcx,%rdx,8),%zmm19{%k3}{z}
 18abe4a:	62 e3 75 00 20 c8 09 	vpinsrb $0x9,%eax,%xmm17,%xmm17
 18abe51:	62 e1 7d 08 7e d0    	vmovd  %xmm18,%eax
 18abe57:	62 33 7d 48 39 fa 02 	vextracti32x4 $0x2,%zmm15,%xmm18
 18abe5e:	62 e3 75 00 20 c8 0a 	vpinsrb $0xa,%eax,%xmm17,%xmm17
 18abe65:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18abe6c:	62 23 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm24,%xmm16
 18abe73:	62 e3 75 00 20 c8 0b 	vpinsrb $0xb,%eax,%xmm17,%xmm17
 18abe7a:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18abe7e:	62 73 75 00 20 f8 0c 	vpinsrb $0xc,%eax,%xmm17,%xmm15
 18abe85:	62 e3 7d 08 14 d0 08 	vpextrb $0x8,%xmm18,%eax
 18abe8c:	62 23 7d 28 39 c1 01 	vextracti32x4 $0x1,%ymm24,%xmm17
 18abe93:	62 e1 7f cb 6f 94 d1 12 23 00 00 	vmovdqu8 0x2312(%rcx,%rdx,8),%zmm18{%k3}{z}
 18abe9e:	62 61 7f c9 6f 84 d1 12 22 00 00 	vmovdqu8 0x2212(%rcx,%rdx,8),%zmm24{%k1}{z}
 18abea9:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 18abeaf:	62 e1 7d 08 7e c8    	vmovd  %xmm17,%eax
 18abeb5:	62 e1 7f c9 6f 8c d1 d2 20 00 00 	vmovdqu8 0x20d2(%rcx,%rdx,8),%zmm17{%k1}{z}
 18abec0:	c4 63 01 20 f8 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm15
 18abec6:	62 e3 7d 08 14 c0 08 	vpextrb $0x8,%xmm16,%eax
 18abecd:	62 a3 55 20 38 c6 01 	vinserti32x4 $0x1,%xmm22,%ymm21,%ymm16
 18abed4:	62 e1 7f c9 6f ac d1 72 21 00 00 	vmovdqu8 0x2172(%rcx,%rdx,8),%zmm21{%k1}{z}
 18abedf:	62 e1 7f cb 6f b4 d1 92 25 00 00 	vmovdqu8 0x2592(%rcx,%rdx,8),%zmm22{%k3}{z}
 18abeea:	62 c1 7d 08 7e fa    	vmovd  %xmm23,%r10d
 18abef0:	c4 63 01 20 f8 0f    	vpinsrb $0xf,%eax,%xmm15,%xmm15
 18abef6:	0f b6 84 d1 6a 16 00 00 	movzbl 0x166a(%rcx,%rdx,8),%eax
 18abefe:	c4 63 09 20 f0 0f    	vpinsrb $0xf,%eax,%xmm14,%xmm14
 18abf04:	62 a2 7d 48 7d d4    	vpermt2b %zmm20,%zmm0,%zmm18
 18abf0a:	62 e1 7f c9 6f a4 d1 d2 25 00 00 	vmovdqu8 0x25d2(%rcx,%rdx,8),%zmm20{%k1}{z}
 18abf15:	c4 43 0d 38 f7 01    	vinserti128 $0x1,%xmm15,%ymm14,%ymm14
 18abf1b:	62 71 7f cb 6f bc d1 12 1e 00 00 	vmovdqu8 0x1e12(%rcx,%rdx,8),%zmm15{%k3}{z}
 18abf26:	62 33 8d 48 3a f0 01 	vinserti64x4 $0x1,%ymm16,%zmm14,%zmm14
 18abf2d:	62 e1 7f c9 6f 84 d1 52 1e 00 00 	vmovdqu8 0x1e52(%rcx,%rdx,8),%zmm16{%k1}{z}
 18abf38:	62 a2 7d 48 7d f4    	vpermt2b %zmm20,%zmm0,%zmm22
 18abf3e:	62 a3 7d 48 39 ec 03 	vextracti32x4 $0x3,%zmm21,%xmm20
 18abf45:	62 a3 7d 28 39 ed 01 	vextracti32x4 $0x1,%ymm21,%xmm21
 18abf4c:	62 e3 7d 08 14 e6 08 	vpextrb $0x8,%xmm20,%esi
 18abf53:	62 e1 7f c9 6f a4 d1 b2 22 00 00 	vmovdqu8 0x22b2(%rcx,%rdx,8),%zmm20{%k1}{z}
 18abf5e:	62 e1 7d 08 7e ef    	vmovd  %xmm21,%edi
 18abf64:	62 a3 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm23,%xmm21
 18abf6b:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 18abf72:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 18abf79:	62 32 7d 48 7d f8    	vpermt2b %zmm16,%zmm0,%zmm15
 18abf7f:	62 e1 7f cb 6f 84 d1 92 20 00 00 	vmovdqu8 0x2092(%rcx,%rdx,8),%zmm16{%k3}{z}
 18abf8a:	62 41 7d 08 7e c3    	vmovd  %xmm24,%r11d
 18abf90:	62 83 7d 48 39 d8 02 	vextracti32x4 $0x2,%zmm19,%xmm24
 18abf97:	62 c3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%r8d
 18abf9e:	62 e1 7f c9 6f bc d1 72 26 00 00 	vmovdqu8 0x2672(%rcx,%rdx,8),%zmm23{%k1}{z}
 18abfa9:	62 c3 7d 08 14 e9 08 	vpextrb $0x8,%xmm21,%r9d
 18abfb0:	62 e1 7f c9 6f ac d1 f2 23 00 00 	vmovdqu8 0x23f2(%rcx,%rdx,8),%zmm21{%k1}{z}
 18abfbb:	62 43 7d 08 14 c6 08 	vpextrb $0x8,%xmm24,%r14d
 18abfc2:	62 83 7d 48 39 e0 03 	vextracti32x4 $0x3,%zmm20,%xmm24
 18abfc9:	62 a3 7d 28 39 e4 01 	vextracti32x4 $0x1,%ymm20,%xmm20
 18abfd0:	62 a2 7d 48 7d c1    	vpermt2b %zmm17,%zmm0,%zmm16
 18abfd6:	62 e1 7f cb 6f 8c d1 72 22 00 00 	vmovdqu8 0x2272(%rcx,%rdx,8),%zmm17{%k3}{z}
 18abfe1:	62 63 7d 08 14 c3 08 	vpextrb $0x8,%xmm24,%ebx
 18abfe8:	62 83 7d 48 39 f9 03 	vextracti32x4 $0x3,%zmm23,%xmm25
 18abfef:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 18abff6:	62 83 7d 48 39 ea 03 	vextracti32x4 $0x3,%zmm21,%xmm26
 18abffd:	62 63 7d 08 14 c8 08 	vpextrb $0x8,%xmm25,%eax
 18ac004:	62 43 7d 08 14 d4 08 	vpextrb $0x8,%xmm26,%r12d
 18ac00b:	62 c3 7d 00 20 c2 04 	vpinsrb $0x4,%r10d,%xmm16,%xmm16
 18ac012:	62 c3 7d 00 20 c1 05 	vpinsrb $0x5,%r9d,%xmm16,%xmm16
 18ac019:	62 e3 7d 00 20 c7 06 	vpinsrb $0x6,%edi,%xmm16,%xmm16
 18ac020:	62 83 7d 48 39 c8 02 	vextracti32x4 $0x2,%zmm17,%xmm24
 18ac027:	62 e3 7d 00 20 c6 07 	vpinsrb $0x7,%esi,%xmm16,%xmm16
 18ac02e:	62 43 7d 08 14 c7 08 	vpextrb $0x8,%xmm24,%r15d
 18ac035:	62 61 7f cb 6f 84 d1 32 26 00 00 	vmovdqu8 0x2632(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ac040:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 18ac046:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18ac04d:	62 c3 4d 00 20 f5 04 	vpinsrb $0x4,%r13d,%xmm22,%xmm22
 18ac054:	62 43 7d 08 14 c5 08 	vpextrb $0x8,%xmm24,%r13d
 18ac05b:	62 61 7f c9 6f 84 d1 12 27 00 00 	vmovdqu8 0x2712(%rcx,%rdx,8),%zmm24{%k1}{z}
 18ac066:	62 c3 4d 00 20 f5 05 	vpinsrb $0x5,%r13d,%xmm22,%xmm22
 18ac06d:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 18ac073:	62 c3 4d 00 20 f5 06 	vpinsrb $0x6,%r13d,%xmm22,%xmm22
 18ac07a:	62 e3 4d 00 20 f0 07 	vpinsrb $0x7,%eax,%xmm22,%xmm22
 18ac081:	62 23 7d 48 39 c7 03 	vextracti32x4 $0x3,%zmm24,%xmm23
 18ac088:	62 03 7d 28 39 c0 01 	vextracti32x4 $0x1,%ymm24,%xmm24
 18ac08f:	62 c3 7d 08 14 fd 08 	vpextrb $0x8,%xmm23,%r13d
 18ac096:	62 e1 7f cb 6f bc d1 d2 26 00 00 	vmovdqu8 0x26d2(%rcx,%rdx,8),%zmm23{%k3}{z}
 18ac0a1:	62 e1 7d 08 7e f8    	vmovd  %xmm23,%eax
 18ac0a7:	62 a3 7d 48 39 ff 02 	vextracti32x4 $0x2,%zmm23,%xmm23
 18ac0ae:	62 e3 4d 00 20 f0 08 	vpinsrb $0x8,%eax,%xmm22,%xmm22
 18ac0b5:	62 e3 7d 08 14 f8 08 	vpextrb $0x8,%xmm23,%eax
 18ac0bc:	62 e1 7f c9 6f bc d1 b2 27 00 00 	vmovdqu8 0x27b2(%rcx,%rdx,8),%zmm23{%k1}{z}
 18ac0c7:	62 e3 4d 00 20 f0 09 	vpinsrb $0x9,%eax,%xmm22,%xmm22
 18ac0ce:	62 61 7d 08 7e c0    	vmovd  %xmm24,%eax
 18ac0d4:	62 e3 4d 00 20 f0 0a 	vpinsrb $0xa,%eax,%xmm22,%xmm22
 18ac0db:	62 c3 4d 00 20 f5 0b 	vpinsrb $0xb,%r13d,%xmm22,%xmm22
 18ac0e2:	62 83 7d 48 39 f8 03 	vextracti32x4 $0x3,%zmm23,%xmm24
 18ac0e9:	62 a3 7d 28 39 ff 01 	vextracti32x4 $0x1,%ymm23,%xmm23
 18ac0f0:	62 63 7d 08 14 c0 08 	vpextrb $0x8,%xmm24,%eax
 18ac0f7:	62 61 7f cb 6f 84 d1 72 27 00 00 	vmovdqu8 0x2772(%rcx,%rdx,8),%zmm24{%k3}{z}
 18ac102:	62 41 7d 08 7e c5    	vmovd  %xmm24,%r13d
 18ac108:	62 03 7d 48 39 c0 02 	vextracti32x4 $0x2,%zmm24,%xmm24
 18ac10f:	62 c3 4d 00 20 f5 0c 	vpinsrb $0xc,%r13d,%xmm22,%xmm22
 18ac116:	62 43 7d 08 14 c5 08 	vpextrb $0x8,%xmm24,%r13d
 18ac11d:	62 c3 4d 00 20 f5 0d 	vpinsrb $0xd,%r13d,%xmm22,%xmm22
 18ac124:	62 c1 7d 08 7e fd    	vmovd  %xmm23,%r13d
 18ac12a:	62 c3 4d 00 20 f5 0e 	vpinsrb $0xe,%r13d,%xmm22,%xmm22
 18ac131:	62 c1 7d 08 7e dd    	vmovd  %xmm19,%r13d
 18ac137:	62 e1 7f cb 6f 9c d1 b2 23 00 00 	vmovdqu8 0x23b2(%rcx,%rdx,8),%zmm19{%k3}{z}
 18ac142:	62 e3 4d 00 20 f0 0f 	vpinsrb $0xf,%eax,%xmm22,%xmm22
 18ac149:	62 c3 7d 00 20 c5 08 	vpinsrb $0x8,%r13d,%xmm16,%xmm16
 18ac150:	62 c3 7d 00 20 c6 09 	vpinsrb $0x9,%r14d,%xmm16,%xmm16
 18ac157:	62 c3 7d 00 20 c3 0a 	vpinsrb $0xa,%r11d,%xmm16,%xmm16
 18ac15e:	62 c3 7d 00 20 c0 0b 	vpinsrb $0xb,%r8d,%xmm16,%xmm16
 18ac165:	4c 8d 05 14 ff 24 0d 	lea    0xd24ff14(%rip),%r8        # eafc080 <tier0_choice_shapes>
 18ac16c:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18ac172:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18ac179:	62 e3 6d 00 20 d0 04 	vpinsrb $0x4,%eax,%xmm18,%xmm18
 18ac180:	62 e3 7d 08 14 d8 08 	vpextrb $0x8,%xmm19,%eax
 18ac187:	62 a3 7d 28 39 eb 01 	vextracti32x4 $0x1,%ymm21,%xmm19
 18ac18e:	62 e3 6d 00 20 d0 05 	vpinsrb $0x5,%eax,%xmm18,%xmm18
 18ac195:	62 e1 7d 08 7e d8    	vmovd  %xmm19,%eax
 18ac19b:	62 e1 7f cb 6f 9c d1 52 24 00 00 	vmovdqu8 0x2452(%rcx,%rdx,8),%zmm19{%k3}{z}
 18ac1a6:	62 e3 6d 00 20 d0 06 	vpinsrb $0x6,%eax,%xmm18,%xmm18
 18ac1ad:	62 e1 7d 08 7e e0    	vmovd  %xmm20,%eax
 18ac1b3:	62 e1 7f c9 6f a4 d1 92 24 00 00 	vmovdqu8 0x2492(%rcx,%rdx,8),%zmm20{%k1}{z}
 18ac1be:	62 c3 6d 00 20 d4 07 	vpinsrb $0x7,%r12d,%xmm18,%xmm18
 18ac1c5:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 18ac1cb:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18ac1d2:	62 c3 6d 00 20 d4 08 	vpinsrb $0x8,%r12d,%xmm18,%xmm18
 18ac1d9:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 18ac1e0:	62 a3 7d 28 39 e3 01 	vextracti32x4 $0x1,%ymm20,%xmm19
 18ac1e7:	62 a3 7d 48 39 e4 03 	vextracti32x4 $0x3,%zmm20,%xmm20
 18ac1ee:	62 c3 6d 00 20 d4 09 	vpinsrb $0x9,%r12d,%xmm18,%xmm18
 18ac1f5:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 18ac1fb:	62 e1 7f cb 6f 9c d1 f2 24 00 00 	vmovdqu8 0x24f2(%rcx,%rdx,8),%zmm19{%k3}{z}
 18ac206:	62 c3 6d 00 20 d4 0a 	vpinsrb $0xa,%r12d,%xmm18,%xmm18
 18ac20d:	62 c3 7d 08 14 e4 08 	vpextrb $0x8,%xmm20,%r12d
 18ac214:	62 e1 7f c9 6f a4 d1 32 25 00 00 	vmovdqu8 0x2532(%rcx,%rdx,8),%zmm20{%k1}{z}
 18ac21f:	62 f1 3d 48 74 ce    	vpcmpeqb %zmm6,%zmm8,%k1
 18ac225:	62 c3 6d 00 20 d4 0b 	vpinsrb $0xb,%r12d,%xmm18,%xmm18
 18ac22c:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 18ac232:	62 a3 7d 48 39 db 02 	vextracti32x4 $0x2,%zmm19,%xmm19
 18ac239:	62 c3 6d 00 20 d4 0c 	vpinsrb $0xc,%r12d,%xmm18,%xmm18
 18ac240:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 18ac247:	62 a3 7d 28 39 e3 01 	vextracti32x4 $0x1,%ymm20,%xmm19
 18ac24e:	62 c3 6d 00 20 d4 0d 	vpinsrb $0xd,%r12d,%xmm18,%xmm18
 18ac255:	62 c1 7d 08 7e dc    	vmovd  %xmm19,%r12d
 18ac25b:	62 a3 7d 48 39 e3 03 	vextracti32x4 $0x3,%zmm20,%xmm19
 18ac262:	62 e1 9d 48 db e2    	vpandq %zmm2,%zmm12,%zmm20
 18ac268:	62 c3 6d 00 20 d4 0e 	vpinsrb $0xe,%r12d,%xmm18,%xmm18
 18ac26f:	62 c3 7d 08 14 dc 08 	vpextrb $0x8,%xmm19,%r12d
 18ac276:	62 71 dd 40 eb c7    	vporq  %zmm7,%zmm20,%zmm8
 18ac27c:	62 c3 6d 00 20 d4 0f 	vpinsrb $0xf,%r12d,%xmm18,%xmm18
 18ac283:	62 c1 7d 08 7e cc    	vmovd  %xmm17,%r12d
 18ac289:	62 c1 7f 49 6f e0    	vmovdqu8 %zmm8,%zmm20{%k1}
 18ac28f:	62 71 8d 48 db c2    	vpandq %zmm2,%zmm14,%zmm8
 18ac295:	62 f1 35 48 74 cb    	vpcmpeqb %zmm3,%zmm9,%k1
 18ac29b:	62 c3 7d 00 20 c4 0c 	vpinsrb $0xc,%r12d,%xmm16,%xmm16
 18ac2a2:	62 a3 6d 20 38 ce 01 	vinserti32x4 $0x1,%xmm22,%ymm18,%ymm17
 18ac2a9:	62 e1 bd 48 eb d7    	vporq  %zmm7,%zmm8,%zmm18
 18ac2af:	c4 e1 f4 45 e4       	korq   %k4,%k1,%k4
 18ac2b4:	62 c3 7d 00 20 c7 0d 	vpinsrb $0xd,%r15d,%xmm16,%xmm16
 18ac2bb:	62 e3 7d 00 20 c0 0e 	vpinsrb $0xe,%eax,%xmm16,%xmm16
 18ac2c2:	0f b6 84 d1 b2 1e 00 00 	movzbl 0x1eb2(%rcx,%rdx,8),%eax
 18ac2ca:	62 e3 7d 00 20 c3 0f 	vpinsrb $0xf,%ebx,%xmm16,%xmm16
 18ac2d1:	c4 63 01 20 f8 04    	vpinsrb $0x4,%eax,%xmm15,%xmm15
 18ac2d7:	0f b6 84 d1 da 1e 00 00 	movzbl 0x1eda(%rcx,%rdx,8),%eax
 18ac2df:	c4 63 01 20 f8 05    	vpinsrb $0x5,%eax,%xmm15,%xmm15
 18ac2e5:	0f b6 84 d1 02 1f 00 00 	movzbl 0x1f02(%rcx,%rdx,8),%eax
 18ac2ed:	c4 63 01 20 f8 06    	vpinsrb $0x6,%eax,%xmm15,%xmm15
 18ac2f3:	0f b6 84 d1 2a 1f 00 00 	movzbl 0x1f2a(%rcx,%rdx,8),%eax
 18ac2fb:	c4 63 01 20 f8 07    	vpinsrb $0x7,%eax,%xmm15,%xmm15
 18ac301:	0f b6 84 d1 52 1f 00 00 	movzbl 0x1f52(%rcx,%rdx,8),%eax
 18ac309:	c4 63 01 20 f8 08    	vpinsrb $0x8,%eax,%xmm15,%xmm15
 18ac30f:	0f b6 84 d1 7a 1f 00 00 	movzbl 0x1f7a(%rcx,%rdx,8),%eax
 18ac317:	c4 63 01 20 f8 09    	vpinsrb $0x9,%eax,%xmm15,%xmm15
 18ac31d:	0f b6 84 d1 a2 1f 00 00 	movzbl 0x1fa2(%rcx,%rdx,8),%eax
 18ac325:	c4 63 01 20 f8 0a    	vpinsrb $0xa,%eax,%xmm15,%xmm15
 18ac32b:	0f b6 84 d1 ca 1f 00 00 	movzbl 0x1fca(%rcx,%rdx,8),%eax
 18ac333:	c4 63 01 20 f8 0b    	vpinsrb $0xb,%eax,%xmm15,%xmm15
 18ac339:	0f b6 84 d1 f2 1f 00 00 	movzbl 0x1ff2(%rcx,%rdx,8),%eax
 18ac341:	c4 63 01 20 f8 0c    	vpinsrb $0xc,%eax,%xmm15,%xmm15
 18ac347:	0f b6 84 d1 1a 20 00 00 	movzbl 0x201a(%rcx,%rdx,8),%eax
 18ac34f:	c4 63 01 20 f8 0d    	vpinsrb $0xd,%eax,%xmm15,%xmm15
 18ac355:	0f b6 84 d1 42 20 00 00 	movzbl 0x2042(%rcx,%rdx,8),%eax
 18ac35d:	c4 63 01 20 f8 0e    	vpinsrb $0xe,%eax,%xmm15,%xmm15
 18ac363:	0f b6 84 d1 6a 20 00 00 	movzbl 0x206a(%rcx,%rdx,8),%eax
 18ac36b:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18ac370:	c4 63 01 20 f8 0f    	vpinsrb $0xf,%eax,%xmm15,%xmm15
 18ac376:	62 33 05 28 38 f8 01 	vinserti32x4 $0x1,%xmm16,%ymm15,%ymm15
 18ac37d:	62 33 85 48 3a f9 01 	vinserti64x4 $0x1,%ymm17,%zmm15,%zmm15
 18ac384:	62 e1 95 48 db ca    	vpandq %zmm2,%zmm13,%zmm17
 18ac38a:	62 e1 f5 40 eb df    	vporq  %zmm7,%zmm17,%zmm19
 18ac390:	62 f3 05 4a 3e d1 01 	vpcmpltub %zmm1,%zmm15,%k2{%k2}
 18ac397:	62 a1 7f 4d 6f cb    	vmovdqu8 %zmm19,%zmm17{%k5}
 18ac39d:	62 f1 2d 48 74 ee    	vpcmpeqb %zmm6,%zmm10,%k5
 18ac3a3:	62 e1 85 48 db da    	vpandq %zmm2,%zmm15,%zmm19
 18ac3a9:	62 31 7f 4d 6f c2    	vmovdqu8 %zmm18,%zmm8{%k5}
 18ac3af:	62 f1 2d 48 74 eb    	vpcmpeqb %zmm3,%zmm10,%k5
 18ac3b5:	62 e1 f5 40 eb d5    	vporq  %zmm5,%zmm17,%zmm18
 18ac3bb:	62 71 e5 40 eb d7    	vporq  %zmm7,%zmm19,%zmm10
 18ac3c1:	c4 e1 d4 45 c8       	korq   %k0,%k5,%k1
 18ac3c6:	62 f1 25 48 74 c4    	vpcmpeqb %zmm4,%zmm11,%k0
 18ac3cc:	62 f1 25 48 74 ee    	vpcmpeqb %zmm6,%zmm11,%k5
 18ac3d2:	62 71 dd 40 eb dd    	vporq  %zmm5,%zmm20,%zmm11
 18ac3d8:	62 a1 7f 4c 6f ca    	vmovdqu8 %zmm18,%zmm17{%k4}
 18ac3de:	c4 e1 f8 90 64 24 60 	kmovq  0x60(%rsp),%k4
 18ac3e5:	62 c1 7f 4e 6f e3    	vmovdqu8 %zmm11,%zmm20{%k6}
 18ac3eb:	62 71 bd 48 eb dd    	vporq  %zmm5,%zmm8,%zmm11
 18ac3f1:	62 c1 7f 4d 6f da    	vmovdqu8 %zmm10,%zmm19{%k5}
 18ac3f7:	c4 e1 f8 90 6c 24 30 	kmovq  0x30(%rsp),%k5
 18ac3fe:	c4 e1 c4 45 f8       	korq   %k0,%k7,%k7
 18ac403:	62 71 e5 40 eb d5    	vporq  %zmm5,%zmm19,%zmm10
 18ac409:	62 a1 fe 48 7f 24 02 	vmovdqu64 %zmm20,(%rdx,%r8,1)
 18ac410:	62 a1 fe 48 7f 4c 02 01 	vmovdqu64 %zmm17,0x40(%rdx,%r8,1)
 18ac418:	62 51 7f 49 6f c3    	vmovdqu8 %zmm11,%zmm8{%k1}
 18ac41e:	c4 e1 f8 90 8c 24 b0 00 00 00 	kmovq  0xb0(%rsp),%k1
 18ac428:	62 c1 7f 4f 6f da    	vmovdqu8 %zmm10,%zmm19{%k7}
 18ac42e:	62 31 fe 48 7f 44 02 02 	vmovdqu64 %zmm8,0x80(%rdx,%r8,1)
 18ac436:	62 a1 fe 48 7f 5c 02 03 	vmovdqu64 %zmm19,0xc0(%rdx,%r8,1)
 18ac43e:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
 18ac445:	62 f3 15 4c 3e e1 01 	vpcmpltub %zmm1,%zmm13,%k4{%k4}
 18ac44c:	62 f3 0d 4d 3e e9 01 	vpcmpltub %zmm1,%zmm14,%k5{%k5}
 18ac453:	62 f3 1d 49 3e c9 01 	vpcmpltub %zmm1,%zmm12,%k1{%k1}
 18ac45a:	48 81 fa 00 20 00 00 	cmp    $0x2000,%rdx
 18ac461:	0f 85 f9 da ff ff    	jne    18a9f60 <run_backend_benchmark+0x2940>
 18ac467:	c4 e2 7d 5a 0d e0 96 cc fe 	vbroadcasti128 -0x1336920(%rip),%ymm1        # 575b50 <x86_effects_unknown+0xf0>
 18ac470:	c4 e2 7d 5a 15 e7 96 cc fe 	vbroadcasti128 -0x1336919(%rip),%ymm2        # 575b60 <x86_effects_unknown+0x100>
 18ac479:	c4 e2 7d 5a 1d ee 96 cc fe 	vbroadcasti128 -0x1336912(%rip),%ymm3        # 575b70 <x86_effects_unknown+0x110>
 18ac482:	c4 e2 7d 5a 25 f5 96 cc fe 	vbroadcasti128 -0x133690b(%rip),%ymm4        # 575b80 <x86_effects_unknown+0x120>
 18ac48b:	c4 e2 7d 5a 2d 0c 97 cc fe 	vbroadcasti128 -0x13368f4(%rip),%ymm5        # 575ba0 <x86_effects_unknown+0x140>
 18ac494:	c4 e2 7d 5a 35 13 97 cc fe 	vbroadcasti128 -0x13368ed(%rip),%ymm6        # 575bb0 <x86_effects_unknown+0x150>
 18ac49d:	c4 e2 7d 5a 3d ea 96 cc fe 	vbroadcasti128 -0x1336916(%rip),%ymm7        # 575b90 <x86_effects_unknown+0x130>
 18ac4a6:	c4 e1 dc 41 c1       	kandq  %k1,%k4,%k0
 18ac4ab:	c4 e1 ec 41 cd       	kandq  %k5,%k2,%k1
 18ac4b0:	31 c0                	xor    %eax,%eax
 18ac4b2:	48 8d 0d b9 1a 7f 00 	lea    0x7f1ab9(%rip),%rcx        # 209df72 <x86_form_descriptions+0x50012>
 18ac4b9:	48 be 00 00 01 00 00 00 00 01 	movabs $0x100000000010000,%rsi
 18ac4c3:	48 bf 01 00 00 00 00 01 00 00 	movabs $0x10000000001,%rdi
 18ac4cd:	c4 e1 f4 41 c0       	kandq  %k0,%k1,%k0
 18ac4d2:	c4 e1 f8 98 c0       	kortestq %k0,%k0
 18ac4d7:	0f 92 c0             	setb   %al
 18ac4da:	31 d2                	xor    %edx,%edx
 18ac4dc:	83 c8 fe             	or     $0xfffffffe,%eax
 18ac4df:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ac4e3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18ac4f0:	c4 e1 fb 92 d6       	kmovq  %rsi,%k2
 18ac4f5:	c4 e1 fb 92 df       	kmovq  %rdi,%k3
 18ac4fa:	62 71 7f ca 6f 81 c9 02 00 00 	vmovdqu8 0x2c9(%rcx),%zmm8{%k2}{z}
 18ac504:	62 71 7f cb 6f 89 89 02 00 00 	vmovdqu8 0x289(%rcx),%zmm9{%k3}{z}
 18ac50e:	62 71 7f ca 6f 91 69 03 00 00 	vmovdqu8 0x369(%rcx),%zmm10{%k2}{z}
 18ac518:	62 71 7f cb 6f 99 c9 03 00 00 	vmovdqu8 0x3c9(%rcx),%zmm11{%k3}{z}
 18ac522:	62 71 7f ca 6f a1 09 04 00 00 	vmovdqu8 0x409(%rcx),%zmm12{%k2}{z}
 18ac52c:	62 71 7f cb 6f b9 60 04 00 00 	vmovdqu8 0x460(%rcx),%zmm15{%k3}{z}
 18ac536:	62 e1 7f ca 6f 81 a0 04 00 00 	vmovdqu8 0x4a0(%rcx),%zmm16{%k2}{z}
 18ac540:	62 52 7d 48 7d c8    	vpermt2b %zmm8,%zmm0,%zmm9
 18ac546:	62 71 7f cb 6f 81 29 03 00 00 	vmovdqu8 0x329(%rcx),%zmm8{%k3}{z}
 18ac550:	62 53 7d 48 39 d5 03 	vextracti32x4 $0x3,%zmm10,%xmm13
 18ac557:	62 53 7d 48 39 c6 02 	vextracti32x4 $0x2,%zmm8,%xmm14
 18ac55e:	c5 79 7e c0          	vmovd  %xmm8,%eax
 18ac562:	c4 63 31 20 c0 04    	vpinsrb $0x4,%eax,%xmm9,%xmm8
 18ac568:	c4 63 79 14 f0 08    	vpextrb $0x8,%xmm14,%eax
 18ac56e:	c4 43 7d 39 d1 01    	vextracti128 $0x1,%ymm10,%xmm9
 18ac574:	62 53 7d 48 39 e2 03 	vextracti32x4 $0x3,%zmm12,%xmm10
 18ac57b:	62 71 7f ca 6f 71 10 	vmovdqu8 0x400(%rcx),%zmm14{%k2}{z}
 18ac582:	c4 63 39 20 c0 05    	vpinsrb $0x5,%eax,%xmm8,%xmm8
 18ac588:	c5 79 7e c8          	vmovd  %xmm9,%eax
 18ac58c:	62 71 7f cb 6f 89 69 04 00 00 	vmovdqu8 0x469(%rcx),%zmm9{%k3}{z}
 18ac596:	c4 63 39 20 c0 06    	vpinsrb $0x6,%eax,%xmm8,%xmm8
 18ac59c:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18ac5a2:	62 53 7d 48 39 dd 02 	vextracti32x4 $0x2,%zmm11,%xmm13
 18ac5a9:	c4 63 39 20 c0 07    	vpinsrb $0x7,%eax,%xmm8,%xmm8
 18ac5af:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18ac5b3:	c4 43 7d 39 e3 01    	vextracti128 $0x1,%ymm12,%xmm11
 18ac5b9:	c4 63 39 20 c0 08    	vpinsrb $0x8,%eax,%xmm8,%xmm8
 18ac5bf:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18ac5c5:	62 71 7f cb 6f 69 0f 	vmovdqu8 0x3c0(%rcx),%zmm13{%k3}{z}
 18ac5cc:	c4 63 39 20 c0 09    	vpinsrb $0x9,%eax,%xmm8,%xmm8
 18ac5d2:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18ac5d6:	c4 63 39 20 c0 0a    	vpinsrb $0xa,%eax,%xmm8,%xmm8
 18ac5dc:	c4 63 79 14 d0 08    	vpextrb $0x8,%xmm10,%eax
 18ac5e2:	62 71 7f ca 6f 91 a9 04 00 00 	vmovdqu8 0x4a9(%rcx),%zmm10{%k2}{z}
 18ac5ec:	c4 63 39 20 c0 0b    	vpinsrb $0xb,%eax,%xmm8,%xmm8
 18ac5f2:	c5 79 7e c8          	vmovd  %xmm9,%eax
 18ac5f6:	62 53 7d 48 39 cc 02 	vextracti32x4 $0x2,%zmm9,%xmm12
 18ac5fd:	c4 63 39 20 c0 0c    	vpinsrb $0xc,%eax,%xmm8,%xmm8
 18ac603:	c4 63 79 14 e0 08    	vpextrb $0x8,%xmm12,%eax
 18ac609:	62 71 7f ca 6f 61 0b 	vmovdqu8 0x2c0(%rcx),%zmm12{%k2}{z}
 18ac610:	c4 63 39 20 c0 0d    	vpinsrb $0xd,%eax,%xmm8,%xmm8
 18ac616:	c4 43 7d 39 d1 01    	vextracti128 $0x1,%ymm10,%xmm9
 18ac61c:	62 53 7d 48 39 d3 03 	vextracti32x4 $0x3,%zmm10,%xmm11
 18ac623:	62 71 7f ca 6f 51 01 	vmovdqu8 0x40(%rcx),%zmm10{%k2}{z}
 18ac62a:	c5 79 7e c8          	vmovd  %xmm9,%eax
 18ac62e:	62 71 7f cb 6f 09    	vmovdqu8 (%rcx),%zmm9{%k3}{z}
 18ac634:	c4 63 39 20 c0 0e    	vpinsrb $0xe,%eax,%xmm8,%xmm8
 18ac63a:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 18ac640:	62 71 7f cb 6f 59 0a 	vmovdqu8 0x280(%rcx),%zmm11{%k3}{z}
 18ac647:	c4 63 39 20 c0 0f    	vpinsrb $0xf,%eax,%xmm8,%xmm8
 18ac64d:	62 52 7d 48 7d ca    	vpermt2b %zmm10,%zmm0,%zmm9
 18ac653:	62 71 7f cb 6f 91 20 03 00 00 	vmovdqu8 0x320(%rcx),%zmm10{%k3}{z}
 18ac65d:	62 52 7d 48 7d dc    	vpermt2b %zmm12,%zmm0,%zmm11
 18ac663:	62 71 7f ca 6f a1 60 03 00 00 	vmovdqu8 0x360(%rcx),%zmm12{%k2}{z}
 18ac66d:	c5 79 7e d0          	vmovd  %xmm10,%eax
 18ac671:	62 53 7d 48 39 d2 02 	vextracti32x4 $0x2,%zmm10,%xmm10
 18ac678:	62 33 7d 48 39 e1 03 	vextracti32x4 $0x3,%zmm12,%xmm17
 18ac67f:	c4 63 21 20 d8 04    	vpinsrb $0x4,%eax,%xmm11,%xmm11
 18ac685:	c4 63 79 14 d0 08    	vpextrb $0x8,%xmm10,%eax
 18ac68b:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 18ac691:	c4 63 21 20 d0 05    	vpinsrb $0x5,%eax,%xmm11,%xmm10
 18ac697:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18ac69b:	c4 43 7d 39 f4 01    	vextracti128 $0x1,%ymm14,%xmm12
 18ac6a1:	62 53 7d 48 39 f3 03 	vextracti32x4 $0x3,%zmm14,%xmm11
 18ac6a8:	c4 63 29 20 d0 06    	vpinsrb $0x6,%eax,%xmm10,%xmm10
 18ac6ae:	62 e3 7d 08 14 c8 08 	vpextrb $0x8,%xmm17,%eax
 18ac6b5:	c4 63 29 20 d0 07    	vpinsrb $0x7,%eax,%xmm10,%xmm10
 18ac6bb:	c5 79 7e e8          	vmovd  %xmm13,%eax
 18ac6bf:	62 53 7d 48 39 ed 02 	vextracti32x4 $0x2,%zmm13,%xmm13
 18ac6c6:	c4 63 29 20 d0 08    	vpinsrb $0x8,%eax,%xmm10,%xmm10
 18ac6cc:	c4 63 79 14 e8 08    	vpextrb $0x8,%xmm13,%eax
 18ac6d2:	c4 63 29 20 d0 09    	vpinsrb $0x9,%eax,%xmm10,%xmm10
 18ac6d8:	c5 79 7e e0          	vmovd  %xmm12,%eax
 18ac6dc:	62 71 7f cb 6f a1 09 00 00 00 	vmovdqu8 0x9(%rcx),%zmm12{%k3}{z}
 18ac6e6:	c4 63 29 20 d0 0a    	vpinsrb $0xa,%eax,%xmm10,%xmm10
 18ac6ec:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 18ac6f2:	62 53 7d 48 39 fb 02 	vextracti32x4 $0x2,%zmm15,%xmm11
 18ac6f9:	c4 63 29 20 d0 0b    	vpinsrb $0xb,%eax,%xmm10,%xmm10
 18ac6ff:	c5 79 7e f8          	vmovd  %xmm15,%eax
 18ac703:	c4 63 29 20 d0 0c    	vpinsrb $0xc,%eax,%xmm10,%xmm10
 18ac709:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 18ac70f:	62 c3 7d 28 39 c3 01 	vextracti32x4 $0x1,%ymm16,%xmm11
 18ac716:	c4 63 29 20 d0 0d    	vpinsrb $0xd,%eax,%xmm10,%xmm10
 18ac71c:	c5 79 7e d8          	vmovd  %xmm11,%eax
 18ac720:	62 c3 7d 48 39 c3 03 	vextracti32x4 $0x3,%zmm16,%xmm11
 18ac727:	c4 63 29 20 d0 0e    	vpinsrb $0xe,%eax,%xmm10,%xmm10
 18ac72d:	c4 63 79 14 d8 08    	vpextrb $0x8,%xmm11,%eax
 18ac733:	62 71 7f ca 6f 99 49 00 00 00 	vmovdqu8 0x49(%rcx),%zmm11{%k2}{z}
 18ac73d:	c4 63 29 20 d0 0f    	vpinsrb $0xf,%eax,%xmm10,%xmm10
 18ac743:	0f b6 81 a0 00 00 00 	movzbl 0xa0(%rcx),%eax
 18ac74a:	c4 63 31 20 c8 04    	vpinsrb $0x4,%eax,%xmm9,%xmm9
 18ac750:	0f b6 81 c8 00 00 00 	movzbl 0xc8(%rcx),%eax
 18ac757:	62 52 7d 48 7d e3    	vpermt2b %zmm11,%zmm0,%zmm12
 18ac75d:	c4 63 19 20 99 a9 00 00 00 04 	vpinsrb $0x4,0xa9(%rcx),%xmm12,%xmm11
 18ac767:	c4 63 31 20 c8 05    	vpinsrb $0x5,%eax,%xmm9,%xmm9
 18ac76d:	0f b6 81 f0 00 00 00 	movzbl 0xf0(%rcx),%eax
 18ac774:	c4 63 21 20 99 d1 00 00 00 05 	vpinsrb $0x5,0xd1(%rcx),%xmm11,%xmm11
 18ac77e:	c4 63 31 20 c8 06    	vpinsrb $0x6,%eax,%xmm9,%xmm9
 18ac784:	0f b6 81 18 01 00 00 	movzbl 0x118(%rcx),%eax
 18ac78b:	c4 63 21 20 99 f9 00 00 00 06 	vpinsrb $0x6,0xf9(%rcx),%xmm11,%xmm11
 18ac795:	c4 63 31 20 c8 07    	vpinsrb $0x7,%eax,%xmm9,%xmm9
 18ac79b:	0f b6 81 40 01 00 00 	movzbl 0x140(%rcx),%eax
 18ac7a2:	c4 63 21 20 99 21 01 00 00 07 	vpinsrb $0x7,0x121(%rcx),%xmm11,%xmm11
 18ac7ac:	c4 63 21 20 99 49 01 00 00 08 	vpinsrb $0x8,0x149(%rcx),%xmm11,%xmm11
 18ac7b6:	c4 63 31 20 c8 08    	vpinsrb $0x8,%eax,%xmm9,%xmm9
 18ac7bc:	0f b6 81 68 01 00 00 	movzbl 0x168(%rcx),%eax
 18ac7c3:	c4 63 21 20 99 71 01 00 00 09 	vpinsrb $0x9,0x171(%rcx),%xmm11,%xmm11
 18ac7cd:	c4 63 31 20 c8 09    	vpinsrb $0x9,%eax,%xmm9,%xmm9
 18ac7d3:	0f b6 81 90 01 00 00 	movzbl 0x190(%rcx),%eax
 18ac7da:	c4 63 21 20 99 99 01 00 00 0a 	vpinsrb $0xa,0x199(%rcx),%xmm11,%xmm11
 18ac7e4:	c4 63 31 20 c8 0a    	vpinsrb $0xa,%eax,%xmm9,%xmm9
 18ac7ea:	0f b6 81 b8 01 00 00 	movzbl 0x1b8(%rcx),%eax
 18ac7f1:	c4 63 21 20 99 c1 01 00 00 0b 	vpinsrb $0xb,0x1c1(%rcx),%xmm11,%xmm11
 18ac7fb:	c4 63 31 20 c8 0b    	vpinsrb $0xb,%eax,%xmm9,%xmm9
 18ac801:	0f b6 81 e0 01 00 00 	movzbl 0x1e0(%rcx),%eax
 18ac808:	c4 63 21 20 99 e9 01 00 00 0c 	vpinsrb $0xc,0x1e9(%rcx),%xmm11,%xmm11
 18ac812:	c4 63 21 20 99 11 02 00 00 0d 	vpinsrb $0xd,0x211(%rcx),%xmm11,%xmm11
 18ac81c:	c4 63 31 20 c8 0c    	vpinsrb $0xc,%eax,%xmm9,%xmm9
 18ac822:	0f b6 81 08 02 00 00 	movzbl 0x208(%rcx),%eax
 18ac829:	c4 63 21 20 99 39 02 00 00 0e 	vpinsrb $0xe,0x239(%rcx),%xmm11,%xmm11
 18ac833:	c4 63 31 20 c8 0d    	vpinsrb $0xd,%eax,%xmm9,%xmm9
 18ac839:	0f b6 81 30 02 00 00 	movzbl 0x230(%rcx),%eax
 18ac840:	c4 63 21 20 99 61 02 00 00 0f 	vpinsrb $0xf,0x261(%rcx),%xmm11,%xmm11
 18ac84a:	c4 63 31 20 c8 0e    	vpinsrb $0xe,%eax,%xmm9,%xmm9
 18ac850:	0f b6 81 58 02 00 00 	movzbl 0x258(%rcx),%eax
 18ac857:	48 81 c1 00 05 00 00 	add    $0x500,%rcx
 18ac85e:	c4 63 31 20 c8 0f    	vpinsrb $0xf,%eax,%xmm9,%xmm9
 18ac864:	c4 43 25 38 c0 01    	vinserti128 $0x1,%xmm8,%ymm11,%ymm8
 18ac86a:	c4 43 35 38 ca 01    	vinserti128 $0x1,%xmm10,%ymm9,%ymm9
 18ac870:	62 f1 3d 28 74 c3    	vpcmpeqb %ymm3,%ymm8,%k0
 18ac876:	62 f1 3d 28 74 d4    	vpcmpeqb %ymm4,%ymm8,%k2
 18ac87c:	62 f1 3d 28 74 dd    	vpcmpeqb %ymm5,%ymm8,%k3
 18ac882:	62 f3 35 29 3e c9 01 	vpcmpltub %ymm1,%ymm9,%k1{%k1}
 18ac889:	c5 35 db ca          	vpand  %ymm2,%ymm9,%ymm9
 18ac88d:	c4 e1 fd 45 d2       	kord   %k2,%k0,%k2
 18ac892:	c5 35 eb c6          	vpor   %ymm6,%ymm9,%ymm8
 18ac896:	62 51 7f 2b 6f c8    	vmovdqu8 %ymm8,%ymm9{%k3}
 18ac89c:	c5 35 eb c7          	vpor   %ymm7,%ymm9,%ymm8
 18ac8a0:	62 51 7f 2a 6f c8    	vmovdqu8 %ymm8,%ymm9{%k2}
 18ac8a6:	c4 21 7e 7f 8c 02 00 20 00 00 	vmovdqu %ymm9,0x2000(%rdx,%r8,1)
 18ac8b0:	48 83 c2 20          	add    $0x20,%rdx
 18ac8b4:	48 81 fa a0 00 00 00 	cmp    $0xa0,%rdx
 18ac8bb:	0f 85 2f fc ff ff    	jne    18ac4f0 <run_backend_benchmark+0x4ed0>
 18ac8c1:	c4 e1 f9 98 c9       	kortestd %k1,%k1
 18ac8c6:	0f 92 05 73 a8 14 0d 	setb   0xd14a873(%rip)        # e9f7140 <tier0_initialized>
 18ac8cd:	0f 83 73 40 00 00    	jae    18b0946 <run_backend_benchmark+0x9326>
 18ac8d3:	48 8d bc 24 00 0d 00 00 	lea    0xd00(%rsp),%rdi
 18ac8db:	c5 f8 77             	vzeroupper
 18ac8de:	e8 1d 4f 00 00       	call   18b1800 <tier0_tables_open>
 18ac8e3:	84 c0                	test   %al,%al
 18ac8e5:	0f 84 5b 40 00 00    	je     18b0946 <run_backend_benchmark+0x9326>
 18ac8eb:	49 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r14
 18ac8f5:	ba 03 00 00 00       	mov    $0x3,%edx
 18ac8fa:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18ac8ff:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18ac905:	45 31 ed             	xor    %r13d,%r13d
 18ac908:	31 ff                	xor    %edi,%edi
 18ac90a:	45 31 c9             	xor    %r9d,%r9d
 18ac90d:	4c 89 f6             	mov    %r14,%rsi
 18ac910:	e8 2b 7c eb fe       	call   764540 <mmap@plt>
 18ac915:	48 89 84 24 60 01 00 00 	mov    %rax,0x160(%rsp)
 18ac91d:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18ac921:	74 5e                	je     18ac981 <run_backend_benchmark+0x5361>
 18ac923:	4c 8d a8 ff ff 20 00 	lea    0x20ffff(%rax),%r13
 18ac92a:	ba 0f 00 00 00       	mov    $0xf,%edx
 18ac92f:	48 89 c7             	mov    %rax,%rdi
 18ac932:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
 18ac939:	4c 89 eb             	mov    %r13,%rbx
 18ac93c:	48 29 c3             	sub    %rax,%rbx
 18ac93f:	48 8d 8b 00 00 ff ff 	lea    -0x10000(%rbx),%rcx
 18ac946:	48 89 de             	mov    %rbx,%rsi
 18ac949:	48 89 8c 24 38 01 00 00 	mov    %rcx,0x138(%rsp)
 18ac951:	e8 9a 7b eb fe       	call   7644f0 <madvise@plt>
 18ac956:	4c 89 f6             	mov    %r14,%rsi
 18ac959:	48 29 de             	sub    %rbx,%rsi
 18ac95c:	ba 0e 00 00 00       	mov    $0xe,%edx
 18ac961:	4c 89 ef             	mov    %r13,%rdi
 18ac964:	e8 87 7b eb fe       	call   7644f0 <madvise@plt>
 18ac969:	49 81 c5 00 00 ff ff 	add    $0xffffffffffff0000,%r13
 18ac970:	49 8d 86 00 00 e0 ff 	lea    -0x200000(%r14),%rax
 18ac977:	48 89 84 24 98 00 00 00 	mov    %rax,0x98(%rsp)
 18ac97f:	eb 18                	jmp    18ac999 <run_backend_benchmark+0x5379>
 18ac981:	48 c7 84 24 38 01 00 00 00 00 00 00 	movq   $0x0,0x138(%rsp)
 18ac98d:	48 c7 84 24 98 00 00 00 00 00 00 00 	movq   $0x0,0x98(%rsp)
 18ac999:	ba 03 00 00 00       	mov    $0x3,%edx
 18ac99e:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18ac9a3:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18ac9a9:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18ac9ad:	c5 fd 7f 84 24 e0 01 00 00 	vmovdqa %ymm0,0x1e0(%rsp)
 18ac9b6:	31 ff                	xor    %edi,%edi
 18ac9b8:	4c 89 f6             	mov    %r14,%rsi
 18ac9bb:	45 31 c9             	xor    %r9d,%r9d
 18ac9be:	4d 89 f4             	mov    %r14,%r12
 18ac9c1:	c5 f8 77             	vzeroupper
 18ac9c4:	e8 77 7b eb fe       	call   764540 <mmap@plt>
 18ac9c9:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18ac9cd:	74 65                	je     18aca34 <run_backend_benchmark+0x5414>
 18ac9cf:	48 8d 98 ff ff 20 00 	lea    0x20ffff(%rax),%rbx
 18ac9d6:	ba 0f 00 00 00       	mov    $0xf,%edx
 18ac9db:	48 89 c7             	mov    %rax,%rdi
 18ac9de:	48 81 e3 00 00 e0 ff 	and    $0xffffffffffe00000,%rbx
 18ac9e5:	49 89 de             	mov    %rbx,%r14
 18ac9e8:	49 29 c6             	sub    %rax,%r14
 18ac9eb:	4c 89 f6             	mov    %r14,%rsi
 18ac9ee:	4d 8d be 00 00 ff ff 	lea    -0x10000(%r14),%r15
 18ac9f5:	e8 f6 7a eb fe       	call   7644f0 <madvise@plt>
 18ac9fa:	4c 89 e6             	mov    %r12,%rsi
 18ac9fd:	4c 29 f6             	sub    %r14,%rsi
 18aca00:	ba 0e 00 00 00       	mov    $0xe,%edx
 18aca05:	48 89 df             	mov    %rbx,%rdi
 18aca08:	e8 e3 7a eb fe       	call   7644f0 <madvise@plt>
 18aca0d:	48 81 c3 00 00 ff ff 	add    $0xffffffffffff0000,%rbx
 18aca14:	49 8d 84 24 00 00 e0 ff 	lea    -0x200000(%r12),%rax
 18aca1c:	48 89 9c 24 e0 01 00 00 	mov    %rbx,0x1e0(%rsp)
 18aca24:	48 89 84 24 f0 01 00 00 	mov    %rax,0x1f0(%rsp)
 18aca2c:	4c 89 bc 24 f8 01 00 00 	mov    %r15,0x1f8(%rsp)
 18aca34:	49 bc 00 00 20 00 01 00 00 00 	movabs $0x100200000,%r12
 18aca3e:	ba 03 00 00 00       	mov    $0x3,%edx
 18aca43:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18aca48:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18aca4e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18aca52:	c5 fd 7f 84 24 c0 01 00 00 	vmovdqa %ymm0,0x1c0(%rsp)
 18aca5b:	31 ff                	xor    %edi,%edi
 18aca5d:	45 31 c9             	xor    %r9d,%r9d
 18aca60:	4c 89 e6             	mov    %r12,%rsi
 18aca63:	c5 f8 77             	vzeroupper
 18aca66:	e8 d5 7a eb fe       	call   764540 <mmap@plt>
 18aca6b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18aca6f:	74 65                	je     18acad6 <run_backend_benchmark+0x54b6>
 18aca71:	48 8d 98 ff ff 20 00 	lea    0x20ffff(%rax),%rbx
 18aca78:	ba 0f 00 00 00       	mov    $0xf,%edx
 18aca7d:	48 89 c7             	mov    %rax,%rdi
 18aca80:	48 81 e3 00 00 e0 ff 	and    $0xffffffffffe00000,%rbx
 18aca87:	49 89 de             	mov    %rbx,%r14
 18aca8a:	49 29 c6             	sub    %rax,%r14
 18aca8d:	4c 89 f6             	mov    %r14,%rsi
 18aca90:	4d 8d be 00 00 ff ff 	lea    -0x10000(%r14),%r15
 18aca97:	e8 54 7a eb fe       	call   7644f0 <madvise@plt>
 18aca9c:	4c 89 e6             	mov    %r12,%rsi
 18aca9f:	4c 29 f6             	sub    %r14,%rsi
 18acaa2:	ba 0e 00 00 00       	mov    $0xe,%edx
 18acaa7:	48 89 df             	mov    %rbx,%rdi
 18acaaa:	e8 41 7a eb fe       	call   7644f0 <madvise@plt>
 18acaaf:	48 81 c3 00 00 ff ff 	add    $0xffffffffffff0000,%rbx
 18acab6:	49 8d 84 24 00 00 e0 ff 	lea    -0x200000(%r12),%rax
 18acabe:	48 89 9c 24 c0 01 00 00 	mov    %rbx,0x1c0(%rsp)
 18acac6:	48 89 84 24 d0 01 00 00 	mov    %rax,0x1d0(%rsp)
 18acace:	4c 89 bc 24 d8 01 00 00 	mov    %r15,0x1d8(%rsp)
 18acad6:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18acade:	49 8d 4d 07          	lea    0x7(%r13),%rcx
 18acae2:	31 db                	xor    %ebx,%ebx
 18acae4:	b8 00 00 00 00       	mov    $0x0,%eax
 18acae9:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18acaed:	62 f1 fe 48 7f 44 24 06 	vmovdqu64 %zmm0,0x180(%rsp)
 18acaf5:	62 f1 fe 48 7f 84 24 70 01 00 00 	vmovdqu64 %zmm0,0x170(%rsp)
 18acb00:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 18acb04:	48 89 ca             	mov    %rcx,%rdx
 18acb07:	4c 29 ea             	sub    %r13,%rdx
 18acb0a:	72 2c                	jb     18acb38 <run_backend_benchmark+0x5518>
 18acb0c:	4c 89 f0             	mov    %r14,%rax
 18acb0f:	48 29 d0             	sub    %rdx,%rax
 18acb12:	40 0f 92 c6          	setb   %sil
 18acb16:	48 3d 00 00 80 00    	cmp    $0x800000,%rax
 18acb1c:	0f 92 c0             	setb   %al
 18acb1f:	31 db                	xor    %ebx,%ebx
 18acb21:	40 08 f0             	or     %sil,%al
 18acb24:	b8 00 00 00 00       	mov    $0x0,%eax
 18acb29:	75 0d                	jne    18acb38 <run_backend_benchmark+0x5518>
 18acb2b:	48 81 c2 00 00 80 00 	add    $0x800000,%rdx
 18acb32:	48 89 c8             	mov    %rcx,%rax
 18acb35:	48 89 d3             	mov    %rdx,%rbx
 18acb38:	4a 8d 4c 2b 07       	lea    0x7(%rbx,%r13,1),%rcx
 18acb3d:	4a 8d 34 2b          	lea    (%rbx,%r13,1),%rsi
 18acb41:	48 89 84 24 68 01 00 00 	mov    %rax,0x168(%rsp)
 18acb49:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 18acb4d:	48 39 f1             	cmp    %rsi,%rcx
 18acb50:	0f 83 1c 3c 00 00    	jae    18b0772 <run_backend_benchmark+0x9152>
 18acb56:	31 c9                	xor    %ecx,%ecx
 18acb58:	48 89 ca             	mov    %rcx,%rdx
 18acb5b:	31 c9                	xor    %ecx,%ecx
 18acb5d:	48 c7 84 24 78 01 00 00 00 00 00 00 	movq   $0x0,0x178(%rsp)
 18acb69:	48 89 ce             	mov    %rcx,%rsi
 18acb6c:	31 c9                	xor    %ecx,%ecx
 18acb6e:	48 c7 84 24 80 01 00 00 00 00 00 00 	movq   $0x0,0x180(%rsp)
 18acb7a:	49 89 c8             	mov    %rcx,%r8
 18acb7d:	48 c7 84 24 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rsp)
 18acb89:	31 c9                	xor    %ecx,%ecx
 18acb8b:	45 31 c9             	xor    %r9d,%r9d
 18acb8e:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18acb94:	4c 89 8c 24 90 01 00 00 	mov    %r9,0x190(%rsp)
 18acb9c:	48 85 c0             	test   %rax,%rax
 18acb9f:	0f 84 d6 3e 00 00    	je     18b0a7b <run_backend_benchmark+0x945b>
 18acba5:	48 85 d2             	test   %rdx,%rdx
 18acba8:	0f 84 cd 3e 00 00    	je     18b0a7b <run_backend_benchmark+0x945b>
 18acbae:	48 85 f6             	test   %rsi,%rsi
 18acbb1:	0f 84 c4 3e 00 00    	je     18b0a7b <run_backend_benchmark+0x945b>
 18acbb7:	4d 85 c0             	test   %r8,%r8
 18acbba:	0f 84 bb 3e 00 00    	je     18b0a7b <run_backend_benchmark+0x945b>
 18acbc0:	48 85 c9             	test   %rcx,%rcx
 18acbc3:	0f 84 b2 3e 00 00    	je     18b0a7b <run_backend_benchmark+0x945b>
 18acbc9:	4d 85 c9             	test   %r9,%r9
 18acbcc:	0f 84 a9 3e 00 00    	je     18b0a7b <run_backend_benchmark+0x945b>
 18acbd2:	48 c7 84 24 d8 00 00 00 00 00 00 00 	movq   $0x0,0xd8(%rsp)
 18acbde:	4c 89 6c 24 50       	mov    %r13,0x50(%rsp)
 18acbe3:	4a 8d 74 2b 07       	lea    0x7(%rbx,%r13,1),%rsi
 18acbe8:	4c 01 eb             	add    %r13,%rbx
 18acbeb:	48 83 e6 f8          	and    $0xfffffffffffffff8,%rsi
 18acbef:	48 39 de             	cmp    %rbx,%rsi
 18acbf2:	0f 82 83 3e 00 00    	jb     18b0a7b <run_backend_benchmark+0x945b>
 18acbf8:	48 89 df             	mov    %rbx,%rdi
 18acbfb:	48 89 f3             	mov    %rsi,%rbx
 18acbfe:	4c 29 eb             	sub    %r13,%rbx
 18acc01:	4c 89 f0             	mov    %r14,%rax
 18acc04:	48 29 d8             	sub    %rbx,%rax
 18acc07:	0f 92 c1             	setb   %cl
 18acc0a:	48 3d a0 0d 00 00    	cmp    $0xda0,%rax
 18acc10:	0f 92 c2             	setb   %dl
 18acc13:	08 ca                	or     %cl,%dl
 18acc15:	74 0a                	je     18acc21 <run_backend_benchmark+0x5601>
 18acc17:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 18acc1c:	45 31 c0             	xor    %r8d,%r8d
 18acc1f:	eb 2f                	jmp    18acc50 <run_backend_benchmark+0x5630>
 18acc21:	48 81 c7 a7 0d 00 00 	add    $0xda7,%rdi
 18acc28:	48 8d 86 a0 0d 00 00 	lea    0xda0(%rsi),%rax
 18acc2f:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 18acc33:	48 39 c7             	cmp    %rax,%rdi
 18acc36:	0f 82 3f 3e 00 00    	jb     18b0a7b <run_backend_benchmark+0x945b>
 18acc3c:	48 89 fb             	mov    %rdi,%rbx
 18acc3f:	4c 29 eb             	sub    %r13,%rbx
 18acc42:	4c 89 f0             	mov    %r14,%rax
 18acc45:	49 89 f0             	mov    %rsi,%r8
 18acc48:	48 89 7c 24 58       	mov    %rdi,0x58(%rsp)
 18acc4d:	48 29 d8             	sub    %rbx,%rax
 18acc50:	4c 39 f3             	cmp    %r14,%rbx
 18acc53:	0f 87 22 3e 00 00    	ja     18b0a7b <run_backend_benchmark+0x945b>
 18acc59:	48 3d 58 3a 00 00    	cmp    $0x3a58,%rax
 18acc5f:	0f 82 16 3e 00 00    	jb     18b0a7b <run_backend_benchmark+0x945b>
 18acc65:	4d 85 c0             	test   %r8,%r8
 18acc68:	0f 84 0d 3e 00 00    	je     18b0a7b <run_backend_benchmark+0x945b>
 18acc6e:	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
 18acc74:	0f 84 01 3e 00 00    	je     18b0a7b <run_backend_benchmark+0x945b>
 18acc7a:	48 8b 84 24 48 01 00 00 	mov    0x148(%rsp),%rax
 18acc82:	48 8b 8c 24 d8 00 00 00 	mov    0xd8(%rsp),%rcx
 18acc8a:	49 8d 78 18          	lea    0x18(%r8),%rdi
 18acc8e:	ba 88 0d 00 00       	mov    $0xd88,%edx
 18acc93:	31 f6                	xor    %esi,%esi
 18acc95:	4c 8d b3 58 3a 00 00 	lea    0x3a58(%rbx),%r14
 18acc9c:	4c 89 84 24 80 00 00 00 	mov    %r8,0x80(%rsp)
 18acca4:	4c 8d 3c 01          	lea    (%rcx,%rax,1),%r15
 18acca8:	c5 f8 77             	vzeroupper
 18accab:	e8 80 76 eb fe       	call   764330 <memset@plt>
 18accb0:	48 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%rax
 18accb8:	48 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%rsi
 18accc0:	4e 8d 8c 2b 58 3a 00 00 	lea    0x3a58(%rbx,%r13,1),%r9
 18accc8:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18accd0:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 18accd8:	4c 89 bc 24 30 01 00 00 	mov    %r15,0x130(%rsp)
 18acce0:	4c 29 f0             	sub    %r14,%rax
 18acce3:	41 c7 82 70 0d 00 00 08 00 00 00 	movl   $0x8,0xd70(%r10)
 18accee:	66 41 c7 82 99 0d 00 00 00 00 	movw   $0x0,0xd99(%r10)
 18accf8:	41 c6 82 9b 0d 00 00 00 	movb   $0x0,0xd9b(%r10)
 18acd00:	41 c7 42 1c 00 9c 00 00 	movl   $0x9c00,0x1c(%r10)
 18acd08:	41 c7 42 4c 00 02 00 00 	movl   $0x200,0x4c(%r10)
 18acd10:	41 c7 42 7c 08 01 00 00 	movl   $0x108,0x7c(%r10)
 18acd18:	41 c7 82 94 00 00 00 00 21 00 00 	movl   $0x2100,0x94(%r10)
 18acd23:	49 c7 82 88 0d 00 00 00 a0 0f 00 	movq   $0xfa000,0xd88(%r10)
 18acd2e:	0f 92 c1             	setb   %cl
 18acd31:	48 3d 00 9c 00 00    	cmp    $0x9c00,%rax
 18acd37:	0f 92 c0             	setb   %al
 18acd3a:	48 81 c3 58 d6 00 00 	add    $0xd658,%rbx
 18acd41:	08 c8                	or     %cl,%al
 18acd43:	84 c0                	test   %al,%al
 18acd45:	48 89 f0             	mov    %rsi,%rax
 18acd48:	49 0f 45 de          	cmovne %r14,%rbx
 18acd4c:	41 be 00 00 00 00    	mov    $0x0,%r14d
 18acd52:	4d 0f 45 ce          	cmovne %r14,%r9
 18acd56:	48 29 d8             	sub    %rbx,%rax
 18acd59:	4e 8d 1c 2b          	lea    (%rbx,%r13,1),%r11
 18acd5d:	0f 92 c1             	setb   %cl
 18acd60:	48 3d 00 9c 00 00    	cmp    $0x9c00,%rax
 18acd66:	48 8d 83 00 9c 00 00 	lea    0x9c00(%rbx),%rax
 18acd6d:	4d 89 0a             	mov    %r9,(%r10)
 18acd70:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 18acd75:	0f 92 c2             	setb   %dl
 18acd78:	08 ca                	or     %cl,%dl
 18acd7a:	84 d2                	test   %dl,%dl
 18acd7c:	48 0f 45 c3          	cmovne %rbx,%rax
 18acd80:	4d 0f 45 de          	cmovne %r14,%r11
 18acd84:	4a 8d 5c 28 07       	lea    0x7(%rax,%r13,1),%rbx
 18acd89:	4a 8d 14 28          	lea    (%rax,%r13,1),%rdx
 18acd8d:	4d 89 5a 08          	mov    %r11,0x8(%r10)
 18acd91:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
 18acd95:	48 39 d3             	cmp    %rdx,%rbx
 18acd98:	72 20                	jb     18acdba <run_backend_benchmark+0x579a>
 18acd9a:	48 89 d9             	mov    %rbx,%rcx
 18acd9d:	4c 29 e9             	sub    %r13,%rcx
 18acda0:	48 89 f7             	mov    %rsi,%rdi
 18acda3:	48 29 cf             	sub    %rcx,%rdi
 18acda6:	41 0f 92 c0          	setb   %r8b
 18acdaa:	48 81 ff 00 e0 04 00 	cmp    $0x4e000,%rdi
 18acdb1:	40 0f 92 c7          	setb   %dil
 18acdb5:	44 08 c7             	or     %r8b,%dil
 18acdb8:	74 04                	je     18acdbe <run_backend_benchmark+0x579e>
 18acdba:	31 db                	xor    %ebx,%ebx
 18acdbc:	eb 14                	jmp    18acdd2 <run_backend_benchmark+0x57b2>
 18acdbe:	48 89 da             	mov    %rbx,%rdx
 18acdc1:	48 81 c1 00 e0 04 00 	add    $0x4e000,%rcx
 18acdc8:	48 81 c2 00 e0 04 00 	add    $0x4e000,%rdx
 18acdcf:	48 89 c8             	mov    %rcx,%rax
 18acdd2:	48 89 f1             	mov    %rsi,%rcx
 18acdd5:	48 29 c1             	sub    %rax,%rcx
 18acdd8:	49 89 5a 10          	mov    %rbx,0x10(%r10)
 18acddc:	4c 89 9c 24 b0 00 00 00 	mov    %r11,0xb0(%rsp)
 18acde4:	48 89 5c 24 60       	mov    %rbx,0x60(%rsp)
 18acde9:	40 0f 92 c7          	setb   %dil
 18acded:	48 81 f9 00 02 00 00 	cmp    $0x200,%rcx
 18acdf4:	0f 92 c1             	setb   %cl
 18acdf7:	40 08 f9             	or     %dil,%cl
 18acdfa:	48 8d b8 00 02 00 00 	lea    0x200(%rax),%rdi
 18ace01:	84 c9                	test   %cl,%cl
 18ace03:	48 0f 45 f8          	cmovne %rax,%rdi
 18ace07:	49 0f 45 d6          	cmovne %r14,%rdx
 18ace0b:	48 89 f0             	mov    %rsi,%rax
 18ace0e:	48 29 f8             	sub    %rdi,%rax
 18ace11:	4e 8d 3c 2f          	lea    (%rdi,%r13,1),%r15
 18ace15:	49 89 52 20          	mov    %rdx,0x20(%r10)
 18ace19:	0f 92 c1             	setb   %cl
 18ace1c:	48 3d 00 02 00 00    	cmp    $0x200,%rax
 18ace22:	48 8d 87 00 02 00 00 	lea    0x200(%rdi),%rax
 18ace29:	41 0f 92 c0          	setb   %r8b
 18ace2d:	41 08 c8             	or     %cl,%r8b
 18ace30:	45 84 c0             	test   %r8b,%r8b
 18ace33:	48 0f 45 c7          	cmovne %rdi,%rax
 18ace37:	4d 0f 45 fe          	cmovne %r14,%r15
 18ace3b:	4e 8d 4c 28 03       	lea    0x3(%rax,%r13,1),%r9
 18ace40:	4e 8d 04 28          	lea    (%rax,%r13,1),%r8
 18ace44:	4d 89 7a 28          	mov    %r15,0x28(%r10)
 18ace48:	4c 89 7c 24 78       	mov    %r15,0x78(%rsp)
 18ace4d:	49 83 e1 fc          	and    $0xfffffffffffffffc,%r9
 18ace51:	4d 39 c1             	cmp    %r8,%r9
 18ace54:	73 05                	jae    18ace5b <run_backend_benchmark+0x583b>
 18ace56:	45 31 c9             	xor    %r9d,%r9d
 18ace59:	eb 41                	jmp    18ace9c <run_backend_benchmark+0x587c>
 18ace5b:	4c 89 c9             	mov    %r9,%rcx
 18ace5e:	4c 29 e9             	sub    %r13,%rcx
 18ace61:	48 89 f7             	mov    %rsi,%rdi
 18ace64:	48 29 cf             	sub    %rcx,%rdi
 18ace67:	41 0f 92 c2          	setb   %r10b
 18ace6b:	48 81 ff 00 08 00 00 	cmp    $0x800,%rdi
 18ace72:	40 0f 92 c7          	setb   %dil
 18ace76:	44 08 d7             	or     %r10b,%dil
 18ace79:	74 05                	je     18ace80 <run_backend_benchmark+0x5860>
 18ace7b:	45 31 c9             	xor    %r9d,%r9d
 18ace7e:	eb 14                	jmp    18ace94 <run_backend_benchmark+0x5874>
 18ace80:	4d 89 c8             	mov    %r9,%r8
 18ace83:	48 81 c1 00 08 00 00 	add    $0x800,%rcx
 18ace8a:	49 81 c0 00 08 00 00 	add    $0x800,%r8
 18ace91:	48 89 c8             	mov    %rcx,%rax
 18ace94:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18ace9c:	48 89 f1             	mov    %rsi,%rcx
 18ace9f:	48 29 c1             	sub    %rax,%rcx
 18acea2:	4c 8d b8 00 02 00 00 	lea    0x200(%rax),%r15
 18acea9:	4d 89 4a 30          	mov    %r9,0x30(%r10)
 18acead:	40 0f 92 c7          	setb   %dil
 18aceb1:	48 81 f9 00 02 00 00 	cmp    $0x200,%rcx
 18aceb8:	0f 92 c1             	setb   %cl
 18acebb:	40 08 f9             	or     %dil,%cl
 18acebe:	84 c9                	test   %cl,%cl
 18acec0:	4c 0f 45 f8          	cmovne %rax,%r15
 18acec4:	4d 0f 45 c6          	cmovne %r14,%r8
 18acec8:	4f 8d 5c 2f 03       	lea    0x3(%r15,%r13,1),%r11
 18acecd:	4d 89 42 38          	mov    %r8,0x38(%r10)
 18aced1:	4f 8d 14 2f          	lea    (%r15,%r13,1),%r10
 18aced5:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 18aced9:	4c 89 d8             	mov    %r11,%rax
 18acedc:	4c 29 e8             	sub    %r13,%rax
 18acedf:	4d 39 d3             	cmp    %r10,%r11
 18acee2:	72 19                	jb     18acefd <run_backend_benchmark+0x58dd>
 18acee4:	48 89 f1             	mov    %rsi,%rcx
 18acee7:	48 29 c1             	sub    %rax,%rcx
 18aceea:	40 0f 92 c7          	setb   %dil
 18aceee:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 18acef5:	0f 92 c1             	setb   %cl
 18acef8:	40 08 f9             	or     %dil,%cl
 18acefb:	74 15                	je     18acf12 <run_backend_benchmark+0x58f2>
 18acefd:	31 db                	xor    %ebx,%ebx
 18aceff:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18acf07:	48 89 59 50          	mov    %rbx,0x50(%rcx)
 18acf0b:	4d 39 d3             	cmp    %r10,%r11
 18acf0e:	72 5a                	jb     18acf6a <run_backend_benchmark+0x594a>
 18acf10:	eb 3f                	jmp    18acf51 <run_backend_benchmark+0x5931>
 18acf12:	49 81 c2 23 04 00 00 	add    $0x423,%r10
 18acf19:	49 89 c7             	mov    %rax,%r15
 18acf1c:	4c 89 d9             	mov    %r11,%rcx
 18acf1f:	49 81 c7 20 04 00 00 	add    $0x420,%r15
 18acf26:	48 81 c1 20 04 00 00 	add    $0x420,%rcx
 18acf2d:	4c 89 db             	mov    %r11,%rbx
 18acf30:	49 83 e2 fc          	and    $0xfffffffffffffffc,%r10
 18acf34:	4c 89 d0             	mov    %r10,%rax
 18acf37:	4c 29 e8             	sub    %r13,%rax
 18acf3a:	4d 89 d3             	mov    %r10,%r11
 18acf3d:	49 89 ca             	mov    %rcx,%r10
 18acf40:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18acf48:	48 89 59 50          	mov    %rbx,0x50(%rcx)
 18acf4c:	4d 39 d3             	cmp    %r10,%r11
 18acf4f:	72 19                	jb     18acf6a <run_backend_benchmark+0x594a>
 18acf51:	48 89 f1             	mov    %rsi,%rcx
 18acf54:	48 29 c1             	sub    %rax,%rcx
 18acf57:	40 0f 92 c7          	setb   %dil
 18acf5b:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 18acf62:	0f 92 c1             	setb   %cl
 18acf65:	40 08 f9             	or     %dil,%cl
 18acf68:	74 05                	je     18acf6f <run_backend_benchmark+0x594f>
 18acf6a:	45 31 e4             	xor    %r12d,%r12d
 18acf6d:	eb 24                	jmp    18acf93 <run_backend_benchmark+0x5973>
 18acf6f:	4d 89 dc             	mov    %r11,%r12
 18acf72:	4e 8d 9c 28 23 04 00 00 	lea    0x423(%rax,%r13,1),%r11
 18acf7a:	4e 8d 94 28 20 04 00 00 	lea    0x420(%rax,%r13,1),%r10
 18acf82:	4c 8d b8 20 04 00 00 	lea    0x420(%rax),%r15
 18acf89:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 18acf8d:	4c 89 d8             	mov    %r11,%rax
 18acf90:	4c 29 e8             	sub    %r13,%rax
 18acf93:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18acf9b:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18acfa0:	48 89 5c 24 70       	mov    %rbx,0x70(%rsp)
 18acfa5:	4c 89 a4 24 c0 00 00 00 	mov    %r12,0xc0(%rsp)
 18acfad:	4c 89 61 58          	mov    %r12,0x58(%rcx)
 18acfb1:	4d 39 d3             	cmp    %r10,%r11
 18acfb4:	72 19                	jb     18acfcf <run_backend_benchmark+0x59af>
 18acfb6:	48 89 f1             	mov    %rsi,%rcx
 18acfb9:	48 29 c1             	sub    %rax,%rcx
 18acfbc:	40 0f 92 c7          	setb   %dil
 18acfc0:	48 81 f9 20 04 00 00 	cmp    $0x420,%rcx
 18acfc7:	0f 92 c1             	setb   %cl
 18acfca:	40 08 f9             	or     %dil,%cl
 18acfcd:	74 05                	je     18acfd4 <run_backend_benchmark+0x59b4>
 18acfcf:	45 31 db             	xor    %r11d,%r11d
 18acfd2:	eb 11                	jmp    18acfe5 <run_backend_benchmark+0x59c5>
 18acfd4:	4e 8d 94 28 20 04 00 00 	lea    0x420(%rax,%r13,1),%r10
 18acfdc:	48 05 20 04 00 00    	add    $0x420,%rax
 18acfe2:	49 89 c7             	mov    %rax,%r15
 18acfe5:	48 89 f0             	mov    %rsi,%rax
 18acfe8:	4c 29 f8             	sub    %r15,%rax
 18acfeb:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18acff3:	4c 89 84 24 90 00 00 00 	mov    %r8,0x90(%rsp)
 18acffb:	0f 92 c1             	setb   %cl
 18acffe:	48 3d 08 01 00 00    	cmp    $0x108,%rax
 18ad004:	49 8d 87 08 01 00 00 	lea    0x108(%r15),%rax
 18ad00b:	40 0f 92 c7          	setb   %dil
 18ad00f:	40 08 cf             	or     %cl,%dil
 18ad012:	40 84 ff             	test   %dil,%dil
 18ad015:	49 0f 45 c7          	cmovne %r15,%rax
 18ad019:	4d 0f 45 d6          	cmovne %r14,%r10
 18ad01d:	4c 89 5a 60          	mov    %r11,0x60(%rdx)
 18ad021:	4e 8d 7c 28 03       	lea    0x3(%rax,%r13,1),%r15
 18ad026:	4e 8d 24 28          	lea    (%rax,%r13,1),%r12
 18ad02a:	4c 89 52 68          	mov    %r10,0x68(%rdx)
 18ad02e:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 18ad032:	4d 39 e7             	cmp    %r12,%r15
 18ad035:	72 1f                	jb     18ad056 <run_backend_benchmark+0x5a36>
 18ad037:	4c 89 f9             	mov    %r15,%rcx
 18ad03a:	4c 29 e9             	sub    %r13,%rcx
 18ad03d:	48 89 f7             	mov    %rsi,%rdi
 18ad040:	48 29 cf             	sub    %rcx,%rdi
 18ad043:	0f 92 c3             	setb   %bl
 18ad046:	48 81 ff 20 04 00 00 	cmp    $0x420,%rdi
 18ad04d:	40 0f 92 c7          	setb   %dil
 18ad051:	40 08 df             	or     %bl,%dil
 18ad054:	74 05                	je     18ad05b <run_backend_benchmark+0x5a3b>
 18ad056:	45 31 ff             	xor    %r15d,%r15d
 18ad059:	eb 14                	jmp    18ad06f <run_backend_benchmark+0x5a4f>
 18ad05b:	4d 89 fc             	mov    %r15,%r12
 18ad05e:	48 81 c1 20 04 00 00 	add    $0x420,%rcx
 18ad065:	49 81 c4 20 04 00 00 	add    $0x420,%r12
 18ad06c:	48 89 c8             	mov    %rcx,%rax
 18ad06f:	48 89 f1             	mov    %rsi,%rcx
 18ad072:	48 29 c1             	sub    %rax,%rcx
 18ad075:	4c 89 ea             	mov    %r13,%rdx
 18ad078:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 18ad080:	40 0f 92 c7          	setb   %dil
 18ad084:	48 81 f9 00 21 00 00 	cmp    $0x2100,%rcx
 18ad08b:	0f 92 c1             	setb   %cl
 18ad08e:	40 08 f9             	or     %dil,%cl
 18ad091:	48 8d b8 00 21 00 00 	lea    0x2100(%rax),%rdi
 18ad098:	84 c9                	test   %cl,%cl
 18ad09a:	48 0f 45 f8          	cmovne %rax,%rdi
 18ad09e:	4d 0f 45 e6          	cmovne %r14,%r12
 18ad0a2:	48 89 f0             	mov    %rsi,%rax
 18ad0a5:	4d 89 78 70          	mov    %r15,0x70(%r8)
 18ad0a9:	48 29 f8             	sub    %rdi,%rax
 18ad0ac:	4e 8d 2c 2f          	lea    (%rdi,%r13,1),%r13
 18ad0b0:	4d 89 a0 80 00 00 00 	mov    %r12,0x80(%r8)
 18ad0b7:	0f 92 c1             	setb   %cl
 18ad0ba:	48 3d 00 21 00 00    	cmp    $0x2100,%rax
 18ad0c0:	0f 92 c0             	setb   %al
 18ad0c3:	08 c8                	or     %cl,%al
 18ad0c5:	48 8d 8f 00 21 00 00 	lea    0x2100(%rdi),%rcx
 18ad0cc:	84 c0                	test   %al,%al
 18ad0ce:	48 89 f0             	mov    %rsi,%rax
 18ad0d1:	48 0f 45 cf          	cmovne %rdi,%rcx
 18ad0d5:	4d 0f 45 ee          	cmovne %r14,%r13
 18ad0d9:	48 29 c8             	sub    %rcx,%rax
 18ad0dc:	4c 8d b1 00 02 00 00 	lea    0x200(%rcx),%r14
 18ad0e3:	4d 89 a8 88 00 00 00 	mov    %r13,0x88(%r8)
 18ad0ea:	40 0f 92 c7          	setb   %dil
 18ad0ee:	48 3d 00 02 00 00    	cmp    $0x200,%rax
 18ad0f4:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 18ad0f8:	0f 92 c3             	setb   %bl
 18ad0fb:	40 08 fb             	or     %dil,%bl
 18ad0fe:	31 ff                	xor    %edi,%edi
 18ad100:	84 db                	test   %bl,%bl
 18ad102:	4c 0f 45 f1          	cmovne %rcx,%r14
 18ad106:	48 0f 45 c7          	cmovne %rdi,%rax
 18ad10a:	49 8d 4c 16 07       	lea    0x7(%r14,%rdx,1),%rcx
 18ad10f:	49 8d 3c 16          	lea    (%r14,%rdx,1),%rdi
 18ad113:	49 89 40 40          	mov    %rax,0x40(%r8)
 18ad117:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 18ad11b:	48 39 f9             	cmp    %rdi,%rcx
 18ad11e:	72 1f                	jb     18ad13f <run_backend_benchmark+0x5b1f>
 18ad120:	48 89 cb             	mov    %rcx,%rbx
 18ad123:	48 29 d3             	sub    %rdx,%rbx
 18ad126:	48 89 f2             	mov    %rsi,%rdx
 18ad129:	48 29 da             	sub    %rbx,%rdx
 18ad12c:	40 0f 92 c6          	setb   %sil
 18ad130:	48 81 fa 00 20 00 00 	cmp    $0x2000,%rdx
 18ad137:	0f 92 c2             	setb   %dl
 18ad13a:	40 08 f2             	or     %sil,%dl
 18ad13d:	74 04                	je     18ad143 <run_backend_benchmark+0x5b23>
 18ad13f:	31 c9                	xor    %ecx,%ecx
 18ad141:	eb 14                	jmp    18ad157 <run_backend_benchmark+0x5b37>
 18ad143:	48 89 cf             	mov    %rcx,%rdi
 18ad146:	48 81 c3 00 20 00 00 	add    $0x2000,%rbx
 18ad14d:	48 81 c7 00 20 00 00 	add    $0x2000,%rdi
 18ad154:	49 89 de             	mov    %rbx,%r14
 18ad157:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18ad15f:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 18ad167:	4c 29 f2             	sub    %r14,%rdx
 18ad16a:	49 89 88 d8 01 00 00 	mov    %rcx,0x1d8(%r8)
 18ad171:	40 0f 92 c6          	setb   %sil
 18ad175:	48 81 fa 00 a0 0f 00 	cmp    $0xfa000,%rdx
 18ad17c:	0f 92 c2             	setb   %dl
 18ad17f:	40 08 f2             	or     %sil,%dl
 18ad182:	49 8d b6 00 a0 0f 00 	lea    0xfa000(%r14),%rsi
 18ad189:	84 d2                	test   %dl,%dl
 18ad18b:	49 0f 45 f6          	cmovne %r14,%rsi
 18ad18f:	41 be 00 00 00 00    	mov    $0x0,%r14d
 18ad195:	4c 0f 44 f7          	cmove  %rdi,%r14
 18ad199:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18ad19f:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 18ad1a7:	4d 89 b0 78 0d 00 00 	mov    %r14,0xd78(%r8)
 18ad1ae:	0f 84 78 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad1b4:	48 83 bc 24 b0 00 00 00 00 	cmpq   $0x0,0xb0(%rsp)
 18ad1bd:	0f 84 69 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad1c3:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
 18ad1c9:	0f 84 5d 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad1cf:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
 18ad1d5:	0f 84 51 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad1db:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 18ad1e1:	0f 84 45 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad1e7:	4d 85 c9             	test   %r9,%r9
 18ad1ea:	0f 84 3c 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad1f0:	48 83 bc 24 90 00 00 00 00 	cmpq   $0x0,0x90(%rsp)
 18ad1f9:	0f 84 2d 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad1ff:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 18ad205:	0f 84 21 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad20b:	48 83 bc 24 c0 00 00 00 00 	cmpq   $0x0,0xc0(%rsp)
 18ad214:	0f 84 12 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad21a:	4d 85 db             	test   %r11,%r11
 18ad21d:	0f 84 09 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad223:	4d 85 d2             	test   %r10,%r10
 18ad226:	0f 84 00 38 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad22c:	4d 85 e4             	test   %r12,%r12
 18ad22f:	0f 84 f7 37 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad235:	48 85 c0             	test   %rax,%rax
 18ad238:	0f 84 ee 37 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad23e:	4d 85 ed             	test   %r13,%r13
 18ad241:	0f 84 e5 37 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad247:	4d 85 ff             	test   %r15,%r15
 18ad24a:	0f 84 dc 37 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad250:	48 85 c9             	test   %rcx,%rcx
 18ad253:	0f 84 d3 37 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad259:	4d 85 f6             	test   %r14,%r14
 18ad25c:	0f 84 ca 37 00 00    	je     18b0a2c <run_backend_benchmark+0x940c>
 18ad262:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18ad26a:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 18ad274:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 18ad27e:	c6 07 00             	movb   $0x0,(%rdi)
 18ad281:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18ad289:	45 31 c9             	xor    %r9d,%r9d
 18ad28c:	4c 8d 2c 01          	lea    (%rcx,%rax,1),%r13
 18ad290:	48 c7 87 90 0d 00 00 00 00 00 00 	movq   $0x0,0xd90(%rdi)
 18ad29b:	c6 87 ec 02 00 00 00 	movb   $0x0,0x2ec(%rdi)
 18ad2a2:	4c 89 e8             	mov    %r13,%rax
 18ad2a5:	48 c1 e8 1e          	shr    $0x1e,%rax
 18ad2a9:	4c 31 e8             	xor    %r13,%rax
 18ad2ac:	49 0f af c4          	imul   %r12,%rax
 18ad2b0:	48 89 c1             	mov    %rax,%rcx
 18ad2b3:	48 c1 e9 1b          	shr    $0x1b,%rcx
 18ad2b7:	48 31 c1             	xor    %rax,%rcx
 18ad2ba:	48 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%rax
 18ad2c4:	48 0f af c8          	imul   %rax,%rcx
 18ad2c8:	48 b8 8f e3 38 8e e3 38 8e e3 	movabs $0xe38e38e38e38e38f,%rax
 18ad2d2:	48 89 ca             	mov    %rcx,%rdx
 18ad2d5:	48 c1 ea 1f          	shr    $0x1f,%rdx
 18ad2d9:	48 31 ca             	xor    %rcx,%rdx
 18ad2dc:	c4 e2 fb f6 c0       	mulx   %rax,%rax,%rax
 18ad2e1:	48 c1 e8 03          	shr    $0x3,%rax
 18ad2e5:	8d 04 c0             	lea    (%rax,%rax,8),%eax
 18ad2e8:	29 c2                	sub    %eax,%edx
 18ad2ea:	48 8d 87 ed 02 00 00 	lea    0x2ed(%rdi),%rax
 18ad2f1:	83 c2 04             	add    $0x4,%edx
 18ad2f4:	48 89 84 24 d0 00 00 00 	mov    %rax,0xd0(%rsp)
 18ad2fc:	89 97 e4 02 00 00    	mov    %edx,0x2e4(%rdi)
 18ad302:	eb 4f                	jmp    18ad353 <run_backend_benchmark+0x5d33>
 18ad304:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18ad310:	4d 89 fd             	mov    %r15,%r13
 18ad313:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
 18ad318:	48 8d 35 e0 dd d3 fe 	lea    -0x12c2220(%rip),%rsi        # 5eb0ff <foreign_touch.flags+0x17bd2>
 18ad31f:	48 8d 05 86 83 de fe 	lea    -0x1217c7a(%rip),%rax        # 6956ac <pp_string_value.meaning+0x38460>
 18ad326:	4c 89 f7             	mov    %r14,%rdi
 18ad329:	48 0f 45 f0          	cmovne %rax,%rsi
 18ad32d:	31 c0                	xor    %eax,%eax
 18ad32f:	e8 ec ed 01 00       	call   18cc120 <tier0_text>
 18ad334:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18ad33c:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 18ad341:	8b 87 e4 02 00 00    	mov    0x2e4(%rdi),%eax
 18ad347:	49 ff c1             	inc    %r9
 18ad34a:	49 39 c1             	cmp    %rax,%r9
 18ad34d:	0f 83 a8 07 00 00    	jae    18adafb <run_backend_benchmark+0x64db>
 18ad353:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 18ad35d:	48 be eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%rsi
 18ad367:	4d 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%r15
 18ad36c:	4c 89 f8             	mov    %r15,%rax
 18ad36f:	48 c1 e8 1e          	shr    $0x1e,%rax
 18ad373:	4c 31 f8             	xor    %r15,%rax
 18ad376:	49 0f af c4          	imul   %r12,%rax
 18ad37a:	48 89 c1             	mov    %rax,%rcx
 18ad37d:	48 c1 e9 1b          	shr    $0x1b,%rcx
 18ad381:	48 31 c1             	xor    %rax,%rcx
 18ad384:	48 0f af ce          	imul   %rsi,%rcx
 18ad388:	48 89 c8             	mov    %rcx,%rax
 18ad38b:	48 c1 e8 1f          	shr    $0x1f,%rax
 18ad38f:	48 31 c8             	xor    %rcx,%rax
 18ad392:	48 b9 25 49 92 24 49 92 24 49 	movabs $0x4924924924924925,%rcx
 18ad39c:	48 89 c2             	mov    %rax,%rdx
 18ad39f:	48 d1 ea             	shr    $1,%rdx
 18ad3a2:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 18ad3a7:	48 d1 e9             	shr    $1,%rcx
 18ad3aa:	48 89 ca             	mov    %rcx,%rdx
 18ad3ad:	48 c1 e2 04          	shl    $0x4,%rdx
 18ad3b1:	48 01 c9             	add    %rcx,%rcx
 18ad3b4:	48 29 d1             	sub    %rdx,%rcx
 18ad3b7:	48 01 c1             	add    %rax,%rcx
 18ad3ba:	48 8d 05 0f 72 c7 fe 	lea    -0x1388df1(%rip),%rax        # 5245d0 <tier0_generate_class.classes>
 18ad3c1:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
 18ad3c5:	0f b6 d8             	movzbl %al,%ebx
 18ad3c8:	8d 4b fb             	lea    -0x5(%rbx),%ecx
 18ad3cb:	83 f9 04             	cmp    $0x4,%ecx
 18ad3ce:	72 09                	jb     18ad3d9 <run_backend_benchmark+0x5db9>
 18ad3d0:	83 fb 0a             	cmp    $0xa,%ebx
 18ad3d3:	0f 85 47 02 00 00    	jne    18ad620 <run_backend_benchmark+0x6000>
 18ad3d9:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18ad3e3:	49 01 cd             	add    %rcx,%r13
 18ad3e6:	4c 89 e9             	mov    %r13,%rcx
 18ad3e9:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18ad3ed:	4d 89 ef             	mov    %r13,%r15
 18ad3f0:	4c 31 e9             	xor    %r13,%rcx
 18ad3f3:	49 0f af cc          	imul   %r12,%rcx
 18ad3f7:	48 89 ca             	mov    %rcx,%rdx
 18ad3fa:	48 c1 ea 1b          	shr    $0x1b,%rdx
 18ad3fe:	48 31 ca             	xor    %rcx,%rdx
 18ad401:	48 0f af d6          	imul   %rsi,%rdx
 18ad405:	48 be c3 f5 28 5c 8f c2 f5 28 	movabs $0x28f5c28f5c28f5c3,%rsi
 18ad40f:	48 89 d1             	mov    %rdx,%rcx
 18ad412:	48 c1 e9 1f          	shr    $0x1f,%rcx
 18ad416:	48 31 d1             	xor    %rdx,%rcx
 18ad419:	48 89 ca             	mov    %rcx,%rdx
 18ad41c:	48 c1 ea 02          	shr    $0x2,%rdx
 18ad420:	c4 e2 eb f6 d6       	mulx   %rsi,%rdx,%rdx
 18ad425:	42 88 84 0f 98 00 00 00 	mov    %al,0x98(%rdi,%r9,1)
 18ad42d:	b8 01 00 00 00       	mov    $0x1,%eax
 18ad432:	48 c1 ea 02          	shr    $0x2,%rdx
 18ad436:	48 6b d2 64          	imul   $0x64,%rdx,%rdx
 18ad43a:	48 29 d1             	sub    %rdx,%rcx
 18ad43d:	48 83 f9 1e          	cmp    $0x1e,%rcx
 18ad441:	b9 10 00 00 00       	mov    $0x10,%ecx
 18ad446:	0f 92 c2             	setb   %dl
 18ad449:	0f 42 c1             	cmovb  %ecx,%eax
 18ad44c:	41 89 d5             	mov    %edx,%r13d
 18ad44f:	42 89 84 8f d8 00 00 00 	mov    %eax,0xd8(%rdi,%r9,4)
 18ad457:	48 8d 35 0e 74 dd fe 	lea    -0x1228bf2(%rip),%rsi        # 68486c <pp_string_value.meaning+0x27620>
 18ad45e:	48 8d 15 d4 60 cd fe 	lea    -0x1329f2c(%rip),%rdx        # 583539 <c_fragment_reader_cursor_tests.leaf_phases+0x105>
 18ad465:	4c 8d 05 b4 0f e2 fe 	lea    -0x11df04c(%rip),%r8        # 6ce420 <pp_string_value.meaning+0x711d4>
 18ad46c:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 18ad471:	49 89 fe             	mov    %rdi,%r14
 18ad474:	8b 87 e0 01 00 00    	mov    0x1e0(%rdi),%eax
 18ad47a:	42 89 84 8f e4 01 00 00 	mov    %eax,0x1e4(%rdi,%r9,4)
 18ad482:	42 c6 84 0f ed 02 00 00 00 	movb   $0x0,0x2ed(%rdi,%r9,1)
 18ad48b:	48 8d 05 ae 27 7f 00 	lea    0x7f27ae(%rip),%rax        # 209fc40 <tier0_c_type.names>
 18ad492:	48 8b 0c d8          	mov    (%rax,%rbx,8),%rcx
 18ad496:	31 c0                	xor    %eax,%eax
 18ad498:	48 89 8c 24 b0 00 00 00 	mov    %rcx,0xb0(%rsp)
 18ad4a0:	e8 7b ec 01 00       	call   18cc120 <tier0_text>
 18ad4a5:	4c 89 f7             	mov    %r14,%rdi
 18ad4a8:	45 84 ed             	test   %r13b,%r13b
 18ad4ab:	74 23                	je     18ad4d0 <run_backend_benchmark+0x5eb0>
 18ad4ad:	48 8d 35 c3 73 dd fe 	lea    -0x1228c3d(%rip),%rsi        # 684877 <pp_string_value.meaning+0x2762b>
 18ad4b4:	ba 10 00 00 00       	mov    $0x10,%edx
 18ad4b9:	31 c0                	xor    %eax,%eax
 18ad4bb:	e8 60 ec 01 00       	call   18cc120 <tier0_text>
 18ad4c0:	eb 1c                	jmp    18ad4de <run_backend_benchmark+0x5ebe>
 18ad4c2:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18ad4d0:	48 8d 35 a0 93 da fe 	lea    -0x1256c60(%rip),%rsi        # 656877 <fuzz_comment_end+0x43028>
 18ad4d7:	31 c0                	xor    %eax,%eax
 18ad4d9:	e8 42 ec 01 00       	call   18cc120 <tier0_text>
 18ad4de:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18ad4e3:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 18ad4ed:	44 89 6c 24 30       	mov    %r13d,0x30(%rsp)
 18ad4f2:	41 83 bc 86 d8 00 00 00 00 	cmpl   $0x0,0xd8(%r14,%rax,4)
 18ad4fb:	0f 84 0f fe ff ff    	je     18ad310 <run_backend_benchmark+0x5cf0>
 18ad501:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 18ad50b:	4d 8d 2c 07          	lea    (%r15,%rax,1),%r13
 18ad50f:	4c 89 e8             	mov    %r13,%rax
 18ad512:	48 c1 e8 1e          	shr    $0x1e,%rax
 18ad516:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 18ad51e:	4c 31 e8             	xor    %r13,%rax
 18ad521:	49 0f af c4          	imul   %r12,%rax
 18ad525:	48 89 c1             	mov    %rax,%rcx
 18ad528:	48 c1 e9 1b          	shr    $0x1b,%rcx
 18ad52c:	48 31 c1             	xor    %rax,%rcx
 18ad52f:	49 0f af c8          	imul   %r8,%rcx
 18ad533:	48 89 c8             	mov    %rcx,%rax
 18ad536:	48 c1 e8 1f          	shr    $0x1f,%rax
 18ad53a:	48 31 c8             	xor    %rcx,%rax
 18ad53d:	48 b9 cd cc cc cc cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
 18ad547:	48 89 c2             	mov    %rax,%rdx
 18ad54a:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 18ad54f:	48 c1 e9 03          	shr    $0x3,%rcx
 18ad553:	48 01 c9             	add    %rcx,%rcx
 18ad556:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 18ad55a:	48 29 c8             	sub    %rcx,%rax
 18ad55d:	48 83 f8 06          	cmp    $0x6,%rax
 18ad561:	73 6d                	jae    18ad5d0 <run_backend_benchmark+0x5fb0>
 18ad563:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18ad56d:	49 01 cf             	add    %rcx,%r15
 18ad570:	4c 89 f9             	mov    %r15,%rcx
 18ad573:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18ad577:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 18ad57f:	4c 31 f9             	xor    %r15,%rcx
 18ad582:	49 0f af cc          	imul   %r12,%rcx
 18ad586:	48 89 ce             	mov    %rcx,%rsi
 18ad589:	48 c1 ee 1b          	shr    $0x1b,%rsi
 18ad58d:	48 31 ce             	xor    %rcx,%rsi
 18ad590:	48 b9 e1 83 0f 3e f8 e0 83 0f 	movabs $0xf83e0f83e0f83e1,%rcx
 18ad59a:	49 0f af f0          	imul   %r8,%rsi
 18ad59e:	48 89 f2             	mov    %rsi,%rdx
 18ad5a1:	48 c1 ea 1f          	shr    $0x1f,%rdx
 18ad5a5:	48 31 f2             	xor    %rsi,%rdx
 18ad5a8:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 18ad5ad:	48 d1 e9             	shr    $1,%rcx
 18ad5b0:	48 89 ce             	mov    %rcx,%rsi
 18ad5b3:	48 c1 e6 05          	shl    $0x5,%rsi
 18ad5b7:	48 01 ce             	add    %rcx,%rsi
 18ad5ba:	48 f7 de             	neg    %rsi
 18ad5bd:	4c 8d 64 32 f0       	lea    -0x10(%rdx,%rsi,1),%r12
 18ad5c2:	eb 4d                	jmp    18ad611 <run_backend_benchmark+0x5ff1>
 18ad5c4:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18ad5d0:	48 83 f8 08          	cmp    $0x8,%rax
 18ad5d4:	73 5f                	jae    18ad635 <run_backend_benchmark+0x6015>
 18ad5d6:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18ad5e0:	49 01 cf             	add    %rcx,%r15
 18ad5e3:	4c 89 f9             	mov    %r15,%rcx
 18ad5e6:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18ad5ea:	4c 89 bc 24 80 02 00 00 	mov    %r15,0x280(%rsp)
 18ad5f2:	4c 31 f9             	xor    %r15,%rcx
 18ad5f5:	49 0f af cc          	imul   %r12,%rcx
 18ad5f9:	48 89 ca             	mov    %rcx,%rdx
 18ad5fc:	48 c1 ea 1b          	shr    $0x1b,%rdx
 18ad600:	48 31 ca             	xor    %rcx,%rdx
 18ad603:	49 0f af d0          	imul   %r8,%rdx
 18ad607:	49 89 d4             	mov    %rdx,%r12
 18ad60a:	49 c1 ec 1f          	shr    $0x1f,%r12
 18ad60e:	49 31 d4             	xor    %rdx,%r12
 18ad611:	4d 89 fd             	mov    %r15,%r13
 18ad614:	ff cb                	dec    %ebx
 18ad616:	83 fb 09             	cmp    $0x9,%ebx
 18ad619:	76 2f                	jbe    18ad64a <run_backend_benchmark+0x602a>
 18ad61b:	e9 70 01 00 00       	jmp    18ad790 <run_backend_benchmark+0x6170>
 18ad620:	42 88 84 0f 98 00 00 00 	mov    %al,0x98(%rdi,%r9,1)
 18ad628:	b8 01 00 00 00       	mov    $0x1,%eax
 18ad62d:	45 31 ed             	xor    %r13d,%r13d
 18ad630:	e9 1a fe ff ff       	jmp    18ad44f <run_backend_benchmark+0x5e2f>
 18ad635:	0f 95 c1             	setne  %cl
 18ad638:	44 0f b6 e1          	movzbl %cl,%r12d
 18ad63c:	49 f7 dc             	neg    %r12
 18ad63f:	ff cb                	dec    %ebx
 18ad641:	83 fb 09             	cmp    $0x9,%ebx
 18ad644:	0f 87 46 01 00 00    	ja     18ad790 <run_backend_benchmark+0x6170>
 18ad64a:	48 8d 15 23 2f c7 fe 	lea    -0x138d0dd(%rip),%rdx        # 520574 <branch_sizing_patterns+0x7e4>
 18ad651:	48 63 0c 9a          	movslq (%rdx,%rbx,4),%rcx
 18ad655:	48 01 d1             	add    %rdx,%rcx
 18ad658:	ff e1                	jmp    *%rcx
 18ad65a:	4d 0f be e4          	movsbq %r12b,%r12
 18ad65e:	e9 2d 01 00 00       	jmp    18ad790 <run_backend_benchmark+0x6170>
 18ad663:	45 89 e4             	mov    %r12d,%r12d
 18ad666:	e9 25 01 00 00       	jmp    18ad790 <run_backend_benchmark+0x6170>
 18ad66b:	45 0f b6 e4          	movzbl %r12b,%r12d
 18ad66f:	e9 1c 01 00 00       	jmp    18ad790 <run_backend_benchmark+0x6170>
 18ad674:	c4 c1 02 2a c4       	vcvtsi2ss %r12d,%xmm15,%xmm0
 18ad679:	c5 fa 59 05 cf 2d cd fe 	vmulss -0x132d231(%rip),%xmm0,%xmm0        # 580450 <tier0_emit_x87.operations+0x8>
 18ad681:	c5 fa 10 15 cb 2d cd fe 	vmovss -0x132d235(%rip),%xmm2        # 580454 <tier0_emit_x87.operations+0xc>
 18ad689:	48 83 f8 08          	cmp    $0x8,%rax
 18ad68d:	41 8b 96 e0 01 00 00 	mov    0x1e0(%r14),%edx
 18ad694:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18ad698:	48 8d 35 9a 5e cd fe 	lea    -0x132a166(%rip),%rsi        # 583539 <c_fragment_reader_cursor_tests.leaf_phases+0x105>
 18ad69f:	4c 89 f7             	mov    %r14,%rdi
 18ad6a2:	0f 94 c1             	sete   %cl
 18ad6a5:	0f 92 c0             	setb   %al
 18ad6a8:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18ad6ac:	49 8b 8e d8 01 00 00 	mov    0x1d8(%r14),%rcx
 18ad6b3:	62 f1 6e 09 10 d1    	vmovss %xmm1,%xmm2,%xmm2{%k1}
 18ad6b9:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ad6bd:	62 f1 6e 09 10 d0    	vmovss %xmm0,%xmm2,%xmm2{%k1}
 18ad6c3:	c5 f9 7e d0          	vmovd  %xmm2,%eax
 18ad6c7:	c5 f8 29 54 24 60    	vmovaps %xmm2,0x60(%rsp)
 18ad6cd:	48 89 04 d1          	mov    %rax,(%rcx,%rdx,8)
 18ad6d1:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18ad6d8:	31 c0                	xor    %eax,%eax
 18ad6da:	e8 41 ea 01 00       	call   18cc120 <tier0_text>
 18ad6df:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 18ad6e5:	4c 89 f7             	mov    %r14,%rdi
 18ad6e8:	48 8d 35 8c 91 da fe 	lea    -0x1256e74(%rip),%rsi        # 65687b <fuzz_comment_end+0x4302c>
 18ad6ef:	c5 fa 5a c0          	vcvtss2sd %xmm0,%xmm0,%xmm0
 18ad6f3:	eb 78                	jmp    18ad76d <run_backend_benchmark+0x614d>
 18ad6f5:	c4 c1 03 2a c4       	vcvtsi2sd %r12d,%xmm15,%xmm0
 18ad6fa:	c5 fb 59 05 9e 29 cd fe 	vmulsd -0x132d662(%rip),%xmm0,%xmm0        # 5800a0 <x86_semantics_benchmark_code.registers+0xb0>
 18ad702:	c5 fb 10 15 9e 29 cd fe 	vmovsd -0x132d662(%rip),%xmm2        # 5800a8 <x86_semantics_benchmark_code.registers+0xb8>
 18ad70a:	48 83 f8 08          	cmp    $0x8,%rax
 18ad70e:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18ad712:	48 8d 35 20 5e cd fe 	lea    -0x132a1e0(%rip),%rsi        # 583539 <c_fragment_reader_cursor_tests.leaf_phases+0x105>
 18ad719:	4c 89 f7             	mov    %r14,%rdi
 18ad71c:	0f 94 c1             	sete   %cl
 18ad71f:	0f 92 c0             	setb   %al
 18ad722:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18ad726:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 18ad72d:	62 f1 ef 09 10 d1    	vmovsd %xmm1,%xmm2,%xmm2{%k1}
 18ad733:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ad737:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 18ad73e:	62 f1 ef 09 10 d0    	vmovsd %xmm0,%xmm2,%xmm2{%k1}
 18ad744:	c5 f9 29 54 24 60    	vmovapd %xmm2,0x60(%rsp)
 18ad74a:	c5 fb 11 14 c8       	vmovsd %xmm2,(%rax,%rcx,8)
 18ad74f:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18ad756:	31 c0                	xor    %eax,%eax
 18ad758:	e8 c3 e9 01 00       	call   18cc120 <tier0_text>
 18ad75d:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 18ad763:	48 8d 35 a0 25 d3 fe 	lea    -0x12cda60(%rip),%rsi        # 5dfd0a <foreign_touch.flags+0xc7dd>
 18ad76a:	4c 89 f7             	mov    %r14,%rdi
 18ad76d:	b0 01                	mov    $0x1,%al
 18ad76f:	e8 ac e9 01 00       	call   18cc120 <tier0_text>
 18ad774:	eb 60                	jmp    18ad7d6 <run_backend_benchmark+0x61b6>
 18ad776:	4d 0f bf e4          	movswq %r12w,%r12
 18ad77a:	eb 14                	jmp    18ad790 <run_backend_benchmark+0x6170>
 18ad77c:	45 0f b7 e4          	movzwl %r12w,%r12d
 18ad780:	eb 0e                	jmp    18ad790 <run_backend_benchmark+0x6170>
 18ad782:	4d 63 e4             	movslq %r12d,%r12
 18ad785:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18ad790:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 18ad797:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 18ad79e:	48 8d 35 94 5d cd fe 	lea    -0x132a26c(%rip),%rsi        # 583539 <c_fragment_reader_cursor_tests.leaf_phases+0x105>
 18ad7a5:	4c 89 f7             	mov    %r14,%rdi
 18ad7a8:	4c 89 24 c8          	mov    %r12,(%rax,%rcx,8)
 18ad7ac:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18ad7b3:	31 c0                	xor    %eax,%eax
 18ad7b5:	e8 66 e9 01 00       	call   18cc120 <tier0_text>
 18ad7ba:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18ad7c2:	48 8d 35 ae b1 ce fe 	lea    -0x1314e52(%rip),%rsi        # 598977 <parse_test_openers+0xd7be>
 18ad7c9:	4c 89 f7             	mov    %r14,%rdi
 18ad7cc:	4c 89 e1             	mov    %r12,%rcx
 18ad7cf:	31 c0                	xor    %eax,%eax
 18ad7d1:	e8 4a e9 01 00       	call   18cc120 <tier0_text>
 18ad7d6:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18ad7db:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 18ad7e5:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 18ad7ef:	41 83 bc 86 d8 00 00 00 02 	cmpl   $0x2,0xd8(%r14,%rax,4)
 18ad7f8:	0f 82 15 fb ff ff    	jb     18ad313 <run_backend_benchmark+0x5cf3>
 18ad7fe:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18ad804:	eb 7a                	jmp    18ad880 <run_backend_benchmark+0x6260>
 18ad806:	45 89 e4             	mov    %r12d,%r12d
 18ad809:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18ad810:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 18ad817:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 18ad81e:	48 8d 35 59 ee d4 fe 	lea    -0x12b11a7(%rip),%rsi        # 5fc67e <foreign_touch.flags+0x29151>
 18ad825:	4c 89 f7             	mov    %r14,%rdi
 18ad828:	4c 89 24 c8          	mov    %r12,(%rax,%rcx,8)
 18ad82c:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18ad833:	31 c0                	xor    %eax,%eax
 18ad835:	e8 e6 e8 01 00       	call   18cc120 <tier0_text>
 18ad83a:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18ad842:	48 8d 35 2e b1 ce fe 	lea    -0x1314ed2(%rip),%rsi        # 598977 <parse_test_openers+0xd7be>
 18ad849:	4c 89 f7             	mov    %r14,%rdi
 18ad84c:	4c 89 e1             	mov    %r12,%rcx
 18ad84f:	31 c0                	xor    %eax,%eax
 18ad851:	e8 ca e8 01 00       	call   18cc120 <tier0_text>
 18ad856:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18ad85b:	41 ff c7             	inc    %r15d
 18ad85e:	49 bc b9 e5 e4 1c 6d 47 58 bf 	movabs $0xbf58476d1ce4e5b9,%r12
 18ad868:	49 b8 eb 11 31 13 bb 49 d0 94 	movabs $0x94d049bb133111eb,%r8
 18ad872:	45 3b bc 86 d8 00 00 00 	cmp    0xd8(%r14,%rax,4),%r15d
 18ad87a:	0f 83 93 fa ff ff    	jae    18ad313 <run_backend_benchmark+0x5cf3>
 18ad880:	48 b8 15 7c 4a 7f b9 79 37 9e 	movabs $0x9e3779b97f4a7c15,%rax
 18ad88a:	48 be cd cc cc cc cc cc cc cc 	movabs $0xcccccccccccccccd,%rsi
 18ad894:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
 18ad899:	48 89 c8             	mov    %rcx,%rax
 18ad89c:	48 c1 e8 1e          	shr    $0x1e,%rax
 18ad8a0:	48 89 8c 24 80 02 00 00 	mov    %rcx,0x280(%rsp)
 18ad8a8:	48 31 c8             	xor    %rcx,%rax
 18ad8ab:	49 0f af c4          	imul   %r12,%rax
 18ad8af:	48 89 c2             	mov    %rax,%rdx
 18ad8b2:	48 c1 ea 1b          	shr    $0x1b,%rdx
 18ad8b6:	48 31 c2             	xor    %rax,%rdx
 18ad8b9:	49 0f af d0          	imul   %r8,%rdx
 18ad8bd:	48 89 d0             	mov    %rdx,%rax
 18ad8c0:	48 c1 e8 1f          	shr    $0x1f,%rax
 18ad8c4:	48 31 d0             	xor    %rdx,%rax
 18ad8c7:	48 89 c2             	mov    %rax,%rdx
 18ad8ca:	c4 e2 eb f6 d6       	mulx   %rsi,%rdx,%rdx
 18ad8cf:	48 c1 ea 03          	shr    $0x3,%rdx
 18ad8d3:	48 01 d2             	add    %rdx,%rdx
 18ad8d6:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
 18ad8da:	48 29 d0             	sub    %rdx,%rax
 18ad8dd:	48 83 f8 05          	cmp    $0x5,%rax
 18ad8e1:	77 6d                	ja     18ad950 <run_backend_benchmark+0x6330>
 18ad8e3:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18ad8ed:	49 01 cd             	add    %rcx,%r13
 18ad8f0:	4c 89 e9             	mov    %r13,%rcx
 18ad8f3:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18ad8f7:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 18ad8ff:	4c 31 e9             	xor    %r13,%rcx
 18ad902:	49 0f af cc          	imul   %r12,%rcx
 18ad906:	48 89 ce             	mov    %rcx,%rsi
 18ad909:	48 c1 ee 1b          	shr    $0x1b,%rsi
 18ad90d:	48 31 ce             	xor    %rcx,%rsi
 18ad910:	48 b9 e1 83 0f 3e f8 e0 83 0f 	movabs $0xf83e0f83e0f83e1,%rcx
 18ad91a:	49 0f af f0          	imul   %r8,%rsi
 18ad91e:	48 89 f2             	mov    %rsi,%rdx
 18ad921:	48 c1 ea 1f          	shr    $0x1f,%rdx
 18ad925:	48 31 f2             	xor    %rsi,%rdx
 18ad928:	c4 e2 f3 f6 c9       	mulx   %rcx,%rcx,%rcx
 18ad92d:	48 d1 e9             	shr    $1,%rcx
 18ad930:	48 89 ce             	mov    %rcx,%rsi
 18ad933:	48 c1 e6 05          	shl    $0x5,%rsi
 18ad937:	48 01 ce             	add    %rcx,%rsi
 18ad93a:	48 f7 de             	neg    %rsi
 18ad93d:	4c 8d 64 32 f0       	lea    -0x10(%rdx,%rsi,1),%r12
 18ad942:	83 fb 09             	cmp    $0x9,%ebx
 18ad945:	76 73                	jbe    18ad9ba <run_backend_benchmark+0x639a>
 18ad947:	e9 c4 fe ff ff       	jmp    18ad810 <run_backend_benchmark+0x61f0>
 18ad94c:	0f 1f 40 00          	nopl   0x0(%rax)
 18ad950:	48 83 f8 07          	cmp    $0x7,%rax
 18ad954:	77 4a                	ja     18ad9a0 <run_backend_benchmark+0x6380>
 18ad956:	48 b9 2a f8 94 fe 72 f3 6e 3c 	movabs $0x3c6ef372fe94f82a,%rcx
 18ad960:	49 01 cd             	add    %rcx,%r13
 18ad963:	4c 89 e9             	mov    %r13,%rcx
 18ad966:	48 c1 e9 1e          	shr    $0x1e,%rcx
 18ad96a:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 18ad972:	4c 31 e9             	xor    %r13,%rcx
 18ad975:	49 0f af cc          	imul   %r12,%rcx
 18ad979:	48 89 ca             	mov    %rcx,%rdx
 18ad97c:	48 c1 ea 1b          	shr    $0x1b,%rdx
 18ad980:	48 31 ca             	xor    %rcx,%rdx
 18ad983:	49 0f af d0          	imul   %r8,%rdx
 18ad987:	49 89 d4             	mov    %rdx,%r12
 18ad98a:	49 c1 ec 1f          	shr    $0x1f,%r12
 18ad98e:	49 31 d4             	xor    %rdx,%r12
 18ad991:	83 fb 09             	cmp    $0x9,%ebx
 18ad994:	76 24                	jbe    18ad9ba <run_backend_benchmark+0x639a>
 18ad996:	e9 75 fe ff ff       	jmp    18ad810 <run_backend_benchmark+0x61f0>
 18ad99b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18ad9a0:	45 31 e4             	xor    %r12d,%r12d
 18ad9a3:	48 83 f8 08          	cmp    $0x8,%rax
 18ad9a7:	49 89 cd             	mov    %rcx,%r13
 18ad9aa:	41 0f 95 c4          	setne  %r12b
 18ad9ae:	49 f7 dc             	neg    %r12
 18ad9b1:	83 fb 09             	cmp    $0x9,%ebx
 18ad9b4:	0f 87 56 fe ff ff    	ja     18ad810 <run_backend_benchmark+0x61f0>
 18ad9ba:	48 8d 15 db 2b c7 fe 	lea    -0x138d425(%rip),%rdx        # 52059c <branch_sizing_patterns+0x80c>
 18ad9c1:	48 63 0c 9a          	movslq (%rdx,%rbx,4),%rcx
 18ad9c5:	48 01 d1             	add    %rdx,%rcx
 18ad9c8:	ff e1                	jmp    *%rcx
 18ad9ca:	4d 0f be e4          	movsbq %r12b,%r12
 18ad9ce:	e9 3d fe ff ff       	jmp    18ad810 <run_backend_benchmark+0x61f0>
 18ad9d3:	45 0f b6 e4          	movzbl %r12b,%r12d
 18ad9d7:	e9 34 fe ff ff       	jmp    18ad810 <run_backend_benchmark+0x61f0>
 18ad9dc:	c4 c1 02 2a c4       	vcvtsi2ss %r12d,%xmm15,%xmm0
 18ad9e1:	c5 fa 59 05 67 2a cd fe 	vmulss -0x132d599(%rip),%xmm0,%xmm0        # 580450 <tier0_emit_x87.operations+0x8>
 18ad9e9:	c5 fa 10 15 63 2a cd fe 	vmovss -0x132d59d(%rip),%xmm2        # 580454 <tier0_emit_x87.operations+0xc>
 18ad9f1:	48 83 f8 08          	cmp    $0x8,%rax
 18ad9f5:	41 8b 96 e0 01 00 00 	mov    0x1e0(%r14),%edx
 18ad9fc:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18ada00:	48 8d 35 77 ec d4 fe 	lea    -0x12b1389(%rip),%rsi        # 5fc67e <foreign_touch.flags+0x29151>
 18ada07:	4c 89 f7             	mov    %r14,%rdi
 18ada0a:	0f 94 c1             	sete   %cl
 18ada0d:	0f 92 c0             	setb   %al
 18ada10:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18ada14:	49 8b 8e d8 01 00 00 	mov    0x1d8(%r14),%rcx
 18ada1b:	62 f1 6e 09 10 d1    	vmovss %xmm1,%xmm2,%xmm2{%k1}
 18ada21:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ada25:	62 f1 6e 09 10 d0    	vmovss %xmm0,%xmm2,%xmm2{%k1}
 18ada2b:	c5 f9 7e d0          	vmovd  %xmm2,%eax
 18ada2f:	c5 f8 29 54 24 60    	vmovaps %xmm2,0x60(%rsp)
 18ada35:	48 89 04 d1          	mov    %rax,(%rcx,%rdx,8)
 18ada39:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18ada40:	31 c0                	xor    %eax,%eax
 18ada42:	e8 d9 e6 01 00       	call   18cc120 <tier0_text>
 18ada47:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 18ada4d:	4c 89 f7             	mov    %r14,%rdi
 18ada50:	48 8d 35 24 8e da fe 	lea    -0x12571dc(%rip),%rsi        # 65687b <fuzz_comment_end+0x4302c>
 18ada57:	c5 fa 5a c0          	vcvtss2sd %xmm0,%xmm0,%xmm0
 18ada5b:	eb 78                	jmp    18adad5 <run_backend_benchmark+0x64b5>
 18ada5d:	c4 c1 03 2a c4       	vcvtsi2sd %r12d,%xmm15,%xmm0
 18ada62:	c5 fb 59 05 36 26 cd fe 	vmulsd -0x132d9ca(%rip),%xmm0,%xmm0        # 5800a0 <x86_semantics_benchmark_code.registers+0xb0>
 18ada6a:	c5 fb 10 15 36 26 cd fe 	vmovsd -0x132d9ca(%rip),%xmm2        # 5800a8 <x86_semantics_benchmark_code.registers+0xb8>
 18ada72:	48 83 f8 08          	cmp    $0x8,%rax
 18ada76:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18ada7a:	48 8d 35 fd eb d4 fe 	lea    -0x12b1403(%rip),%rsi        # 5fc67e <foreign_touch.flags+0x29151>
 18ada81:	4c 89 f7             	mov    %r14,%rdi
 18ada84:	0f 94 c1             	sete   %cl
 18ada87:	0f 92 c0             	setb   %al
 18ada8a:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18ada8e:	41 8b 8e e0 01 00 00 	mov    0x1e0(%r14),%ecx
 18ada95:	62 f1 ef 09 10 d1    	vmovsd %xmm1,%xmm2,%xmm2{%k1}
 18ada9b:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ada9f:	49 8b 86 d8 01 00 00 	mov    0x1d8(%r14),%rax
 18adaa6:	62 f1 ef 09 10 d0    	vmovsd %xmm0,%xmm2,%xmm2{%k1}
 18adaac:	c5 f9 29 54 24 60    	vmovapd %xmm2,0x60(%rsp)
 18adab2:	c5 fb 11 14 c8       	vmovsd %xmm2,(%rax,%rcx,8)
 18adab7:	41 ff 86 e0 01 00 00 	incl   0x1e0(%r14)
 18adabe:	31 c0                	xor    %eax,%eax
 18adac0:	e8 5b e6 01 00       	call   18cc120 <tier0_text>
 18adac5:	c5 f8 28 44 24 60    	vmovaps 0x60(%rsp),%xmm0
 18adacb:	48 8d 35 38 22 d3 fe 	lea    -0x12cddc8(%rip),%rsi        # 5dfd0a <foreign_touch.flags+0xc7dd>
 18adad2:	4c 89 f7             	mov    %r14,%rdi
 18adad5:	b0 01                	mov    $0x1,%al
 18adad7:	e8 44 e6 01 00       	call   18cc120 <tier0_text>
 18adadc:	e9 75 fd ff ff       	jmp    18ad856 <run_backend_benchmark+0x6236>
 18adae1:	4d 0f bf e4          	movswq %r12w,%r12
 18adae5:	e9 26 fd ff ff       	jmp    18ad810 <run_backend_benchmark+0x61f0>
 18adaea:	45 0f b7 e4          	movzwl %r12w,%r12d
 18adaee:	e9 1d fd ff ff       	jmp    18ad810 <run_backend_benchmark+0x61f0>
 18adaf3:	4d 63 e4             	movslq %r12d,%r12
 18adaf6:	e9 15 fd ff ff       	jmp    18ad810 <run_backend_benchmark+0x61f0>
 18adafb:	48 8d 35 7d d8 d7 fe 	lea    -0x1282783(%rip),%rsi        # 62b37f <fuzz_comment_end+0x17b30>
 18adb02:	c7 87 e8 02 00 00 ff ff ff ff 	movl   $0xffffffff,0x2e8(%rdi)
 18adb0c:	31 c0                	xor    %eax,%eax
 18adb0e:	4c 89 ac 24 80 02 00 00 	mov    %r13,0x280(%rsp)
 18adb16:	45 31 f6             	xor    %r14d,%r14d
 18adb19:	49 89 fc             	mov    %rdi,%r12
 18adb1c:	e8 ff e5 01 00       	call   18cc120 <tier0_text>
 18adb21:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18adb26:	48 8d 1d 7b 6a c7 fe 	lea    -0x1389585(%rip),%rbx        # 5245a8 <tier0_program_class_type.types+0x38>
 18adb2d:	4c 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%r15
 18adb35:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18adb40:	41 80 bc 24 98 0d 00 00 01 	cmpb   $0x1,0xd98(%r12)
 18adb49:	0f 84 1e 2f 00 00    	je     18b0a6d <run_backend_benchmark+0x944d>
 18adb4f:	4c 89 e7             	mov    %r12,%rdi
 18adb52:	44 89 f6             	mov    %r14d,%esi
 18adb55:	4c 89 fa             	mov    %r15,%rdx
 18adb58:	48 89 d9             	mov    %rbx,%rcx
 18adb5b:	e8 b0 e8 01 00       	call   18cc410 <tier0_generate_function>
 18adb60:	41 ff c6             	inc    %r14d
 18adb63:	41 83 fe 08          	cmp    $0x8,%r14d
 18adb67:	75 d7                	jne    18adb40 <run_backend_benchmark+0x6520>
 18adb69:	41 80 bc 24 98 0d 00 00 00 	cmpb   $0x0,0xd98(%r12)
 18adb72:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18adb7a:	0f 85 f5 2e 00 00    	jne    18b0a75 <run_backend_benchmark+0x9455>
 18adb80:	41 8b 84 24 70 0d 00 00 	mov    0xd70(%r12),%eax
 18adb88:	4d 89 e1             	mov    %r12,%r9
 18adb8b:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18adb91:	48 89 84 24 90 00 00 00 	mov    %rax,0x90(%rsp)
 18adb99:	48 85 c0             	test   %rax,%rax
 18adb9c:	74 2a                	je     18adbc8 <run_backend_benchmark+0x65a8>
 18adb9e:	62 62 fd 48 59 05 08 25 cd fe 	vpbroadcastq -0x132daf8(%rip),%zmm24        # 5800b0 <x86_semantics_benchmark_code.registers+0xc0>
 18adba8:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 18adbb0:	4c 8d 3d b9 69 c7 fe 	lea    -0x1389647(%rip),%r15        # 524570 <tier0_program_class_type.types>
 18adbb7:	83 f8 10             	cmp    $0x10,%eax
 18adbba:	73 28                	jae    18adbe4 <run_backend_benchmark+0x65c4>
 18adbbc:	31 c0                	xor    %eax,%eax
 18adbbe:	45 31 db             	xor    %r11d,%r11d
 18adbc1:	31 d2                	xor    %edx,%edx
 18adbc3:	e9 37 09 00 00       	jmp    18ae4ff <run_backend_benchmark+0x6edf>
 18adbc8:	4c 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%r10
 18adbd0:	45 31 db             	xor    %r11d,%r11d
 18adbd3:	ba 08 00 00 00       	mov    $0x8,%edx
 18adbd8:	4c 8d 3d 91 69 c7 fe 	lea    -0x138966f(%rip),%r15        # 524570 <tier0_program_class_type.types>
 18adbdf:	e9 5e 09 00 00       	jmp    18ae542 <run_backend_benchmark+0x6f22>
 18adbe4:	49 8d 89 70 03 00 00 	lea    0x370(%r9),%rcx
 18adbeb:	62 f2 fd 48 7c c1    	vpbroadcastq %rcx,%zmm0
 18adbf1:	83 f8 40             	cmp    $0x40,%eax
 18adbf4:	73 0c                	jae    18adc02 <run_backend_benchmark+0x65e2>
 18adbf6:	31 c0                	xor    %eax,%eax
 18adbf8:	45 31 db             	xor    %r11d,%r11d
 18adbfb:	31 d2                	xor    %edx,%edx
 18adbfd:	e9 e2 06 00 00       	jmp    18ae2e4 <run_backend_benchmark+0x6cc4>
 18adc02:	62 f1 fd 48 6f 35 74 26 c7 fe 	vmovdqa64 -0x138d98c(%rip),%zmm6        # 520280 <branch_sizing_patterns+0x4f0>
 18adc0c:	62 f1 fd 48 6f 3d 2a 26 c7 fe 	vmovdqa64 -0x138d9d6(%rip),%zmm7        # 520240 <branch_sizing_patterns+0x4b0>
 18adc16:	62 62 fd 48 59 0d 98 24 cd fe 	vpbroadcastq -0x132db68(%rip),%zmm25        # 5800b8 <x86_semantics_benchmark_code.registers+0xc8>
 18adc20:	62 62 fd 48 59 15 96 24 cd fe 	vpbroadcastq -0x132db6a(%rip),%zmm26        # 5800c0 <x86_semantics_benchmark_code.registers+0xd0>
 18adc2a:	62 62 fd 48 59 1d 94 24 cd fe 	vpbroadcastq -0x132db6c(%rip),%zmm27        # 5800c8 <x86_semantics_benchmark_code.registers+0xd8>
 18adc34:	62 62 fd 48 59 25 92 24 cd fe 	vpbroadcastq -0x132db6e(%rip),%zmm28        # 5800d0 <x86_semantics_benchmark_code.registers+0xe0>
 18adc3e:	83 e0 c0             	and    $0xffffffc0,%eax
 18adc41:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18adc45:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18adc4a:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
 18adc4f:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
 18adc54:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18adc58:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18adc5c:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18adc60:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 18adc64:	48 89 c2             	mov    %rax,%rdx
 18adc67:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18adc70:	62 12 cd 48 40 d8    	vpmullq %zmm24,%zmm6,%zmm11
 18adc76:	62 12 c5 48 40 e0    	vpmullq %zmm24,%zmm7,%zmm12
 18adc7c:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18adc80:	62 91 cd 48 d4 f4    	vpaddq %zmm28,%zmm6,%zmm6
 18adc86:	62 91 c5 48 d4 fc    	vpaddq %zmm28,%zmm7,%zmm7
 18adc8c:	48 83 c2 c0          	add    $0xffffffffffffffc0,%rdx
 18adc90:	62 51 fd 48 d4 fb    	vpaddq %zmm11,%zmm0,%zmm15
 18adc96:	62 51 fd 48 d4 ec    	vpaddq %zmm12,%zmm0,%zmm13
 18adc9c:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 18adca1:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 18adca7:	62 33 7d 28 39 fb 01 	vextracti32x4 $0x1,%ymm15,%xmm19
 18adcae:	62 33 7d 48 39 fd 02 	vextracti32x4 $0x2,%zmm15,%xmm21
 18adcb5:	62 81 85 48 d4 d3    	vpaddq %zmm27,%zmm15,%zmm18
 18adcbb:	62 81 95 48 d4 cb    	vpaddq %zmm27,%zmm13,%zmm17
 18adcc1:	62 81 85 48 d4 c2    	vpaddq %zmm26,%zmm15,%zmm16
 18adcc7:	62 11 95 48 d4 f2    	vpaddq %zmm26,%zmm13,%zmm14
 18adccd:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 18adcd1:	62 c3 fd 08 16 d3 01 	vpextrq $0x1,%xmm18,%r11
 18adcd8:	62 a3 7d 28 39 d6 01 	vextracti32x4 $0x1,%ymm18,%xmm22
 18adcdf:	62 a3 7d 48 39 d7 02 	vextracti32x4 $0x2,%zmm18,%xmm23
 18adce6:	62 e1 7d 08 6e e7    	vmovd  %edi,%xmm20
 18adcec:	62 e3 5d 00 20 66 1e 01 	vpinsrb $0x1,0x1e(%rsi),%xmm20,%xmm20
 18adcf4:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 18adcfa:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 18add01:	62 e3 5d 00 20 5f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm20,%xmm19
 18add09:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 18add0f:	62 33 7d 48 39 fc 03 	vextracti32x4 $0x3,%zmm15,%xmm20
 18add16:	62 11 85 48 d4 f9    	vpaddq %zmm25,%zmm15,%zmm15
 18add1c:	62 e3 65 00 20 5e 1e 03 	vpinsrb $0x3,0x1e(%rsi),%xmm19,%xmm19
 18add24:	62 e3 fd 08 16 ee 01 	vpextrq $0x1,%xmm21,%rsi
 18add2b:	62 e3 65 00 20 5f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm19,%xmm19
 18add33:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18add39:	62 e3 65 00 20 5e 1e 05 	vpinsrb $0x5,0x1e(%rsi),%xmm19,%xmm19
 18add41:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18add48:	62 33 7d 28 39 ec 01 	vextracti32x4 $0x1,%ymm13,%xmm20
 18add4f:	62 e3 65 00 20 5f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm19,%xmm19
 18add57:	c4 61 f9 7e ef       	vmovq  %xmm13,%rdi
 18add5c:	62 e3 65 00 20 5e 1e 07 	vpinsrb $0x7,0x1e(%rsi),%xmm19,%xmm19
 18add64:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 18add6a:	62 e3 65 00 20 5f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm19,%xmm19
 18add72:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18add78:	62 e3 65 00 20 5e 1e 09 	vpinsrb $0x9,0x1e(%rsi),%xmm19,%xmm19
 18add80:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18add87:	62 33 7d 48 39 ec 02 	vextracti32x4 $0x2,%zmm13,%xmm20
 18add8e:	62 e3 65 00 20 5f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm19,%xmm19
 18add96:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18add9c:	62 e3 65 00 20 5e 1e 0b 	vpinsrb $0xb,0x1e(%rsi),%xmm19,%xmm19
 18adda4:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18addab:	62 33 7d 48 39 ec 03 	vextracti32x4 $0x3,%zmm13,%xmm20
 18addb2:	62 11 95 48 d4 e9    	vpaddq %zmm25,%zmm13,%zmm13
 18addb8:	62 c1 fd 08 7e e0    	vmovq  %xmm20,%r8
 18addbe:	62 e3 65 00 20 5f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm19,%xmm19
 18addc6:	62 e1 fd 08 7e d7    	vmovq  %xmm18,%rdi
 18addcc:	62 a3 7d 48 39 d2 03 	vextracti32x4 $0x3,%zmm18,%xmm18
 18addd3:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 18addd7:	62 e3 65 00 20 5e 1e 0d 	vpinsrb $0xd,0x1e(%rsi),%xmm19,%xmm19
 18adddf:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18adde6:	62 e1 7d 08 6e ef    	vmovd  %edi,%xmm21
 18addec:	62 c3 55 00 20 6b 1e 01 	vpinsrb $0x1,0x1e(%r11),%xmm21,%xmm21
 18addf4:	62 e1 fd 08 7e f7    	vmovq  %xmm22,%rdi
 18addfa:	62 c3 65 00 20 58 1e 0e 	vpinsrb $0xe,0x1e(%r8),%xmm19,%xmm19
 18ade02:	62 c3 fd 08 16 c0 01 	vpextrq $0x1,%xmm16,%r8
 18ade09:	62 e3 55 00 20 6f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm21,%xmm21
 18ade11:	62 e3 fd 08 16 f7 01 	vpextrq $0x1,%xmm22,%rdi
 18ade18:	62 e3 55 00 20 6f 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm21,%xmm21
 18ade20:	62 e1 fd 08 7e ff    	vmovq  %xmm23,%rdi
 18ade26:	62 e3 55 00 20 6f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm21,%xmm21
 18ade2e:	62 e3 fd 08 16 ff 01 	vpextrq $0x1,%xmm23,%rdi
 18ade35:	62 e3 55 00 20 6f 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm21,%xmm21
 18ade3d:	62 e1 fd 08 7e d7    	vmovq  %xmm18,%rdi
 18ade43:	62 e3 55 00 20 67 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm21,%xmm20
 18ade4b:	62 e3 fd 08 16 d7 01 	vpextrq $0x1,%xmm18,%rdi
 18ade52:	62 a3 7d 28 39 c5 01 	vextracti32x4 $0x1,%ymm16,%xmm21
 18ade59:	62 e3 5d 00 20 57 1e 07 	vpinsrb $0x7,0x1e(%rdi),%xmm20,%xmm18
 18ade61:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 18ade67:	62 a3 7d 28 39 cc 01 	vextracti32x4 $0x1,%ymm17,%xmm20
 18ade6e:	62 e3 6d 00 20 57 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm18,%xmm18
 18ade76:	62 e3 fd 08 16 cf 01 	vpextrq $0x1,%xmm17,%rdi
 18ade7d:	62 e3 6d 00 20 57 1e 09 	vpinsrb $0x9,0x1e(%rdi),%xmm18,%xmm18
 18ade85:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18ade8b:	62 e3 6d 00 20 57 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm18,%xmm18
 18ade93:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 18ade9a:	62 a3 7d 48 39 cc 02 	vextracti32x4 $0x2,%zmm17,%xmm20
 18adea1:	62 a3 7d 48 39 c9 03 	vextracti32x4 $0x3,%zmm17,%xmm17
 18adea8:	62 e3 6d 00 20 57 1e 0b 	vpinsrb $0xb,0x1e(%rdi),%xmm18,%xmm18
 18adeb0:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18adeb6:	62 e3 6d 00 20 57 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm18,%xmm18
 18adebe:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 18adec5:	62 e3 6d 00 20 57 1e 0d 	vpinsrb $0xd,0x1e(%rdi),%xmm18,%xmm18
 18adecd:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 18aded3:	62 e3 6d 00 20 57 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm18,%xmm18
 18adedb:	62 e1 fd 08 7e c7    	vmovq  %xmm16,%rdi
 18adee1:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 18adee5:	62 e1 7d 08 6e e7    	vmovd  %edi,%xmm20
 18adeeb:	62 c3 5d 00 20 60 1e 01 	vpinsrb $0x1,0x1e(%r8),%xmm20,%xmm20
 18adef3:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 18adef9:	62 e3 5d 00 20 67 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm20,%xmm20
 18adf01:	62 e3 fd 08 16 ef 01 	vpextrq $0x1,%xmm21,%rdi
 18adf08:	62 a3 7d 48 39 c5 02 	vextracti32x4 $0x2,%zmm16,%xmm21
 18adf0f:	62 a3 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm16,%xmm16
 18adf16:	62 e3 5d 00 20 67 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm20,%xmm20
 18adf1e:	62 e1 fd 08 7e ef    	vmovq  %xmm21,%rdi
 18adf24:	62 e3 5d 00 20 67 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm20,%xmm20
 18adf2c:	62 e3 fd 08 16 ef 01 	vpextrq $0x1,%xmm21,%rdi
 18adf33:	62 e3 5d 00 20 67 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm20,%xmm20
 18adf3b:	62 e1 fd 08 7e c7    	vmovq  %xmm16,%rdi
 18adf41:	62 e3 5d 00 20 67 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm20,%xmm20
 18adf49:	62 e3 fd 08 16 c7 01 	vpextrq $0x1,%xmm16,%rdi
 18adf50:	62 e3 5d 00 20 47 1e 07 	vpinsrb $0x7,0x1e(%rdi),%xmm20,%xmm16
 18adf58:	c4 61 f9 7e f7       	vmovq  %xmm14,%rdi
 18adf5d:	62 33 7d 28 39 f4 01 	vextracti32x4 $0x1,%ymm14,%xmm20
 18adf64:	62 e3 7d 00 20 47 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm16,%xmm16
 18adf6c:	c4 63 f9 16 f7 01    	vpextrq $0x1,%xmm14,%rdi
 18adf72:	62 e3 7d 00 20 47 1e 09 	vpinsrb $0x9,0x1e(%rdi),%xmm16,%xmm16
 18adf7a:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18adf80:	62 e3 7d 00 20 47 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm16,%xmm16
 18adf88:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 18adf8f:	62 33 7d 48 39 f4 02 	vextracti32x4 $0x2,%zmm14,%xmm20
 18adf96:	62 e3 7d 00 20 47 1e 0b 	vpinsrb $0xb,0x1e(%rdi),%xmm16,%xmm16
 18adf9e:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18adfa4:	62 e3 7d 00 20 47 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm16,%xmm16
 18adfac:	62 e3 fd 08 16 e7 01 	vpextrq $0x1,%xmm20,%rdi
 18adfb3:	62 33 7d 48 39 f4 03 	vextracti32x4 $0x3,%zmm14,%xmm20
 18adfba:	62 73 7d 00 20 77 1e 0d 	vpinsrb $0xd,0x1e(%rdi),%xmm16,%xmm14
 18adfc2:	62 e1 fd 08 7e e7    	vmovq  %xmm20,%rdi
 18adfc8:	62 e3 0d 08 20 47 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm14,%xmm16
 18adfd0:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 18adfd5:	62 73 65 00 20 76 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm19,%xmm14
 18adfdd:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 18adfe3:	62 33 7d 28 39 fb 01 	vextracti32x4 $0x1,%ymm15,%xmm19
 18adfea:	0f b6 7f 1e          	movzbl 0x1e(%rdi),%edi
 18adfee:	62 e1 7d 08 6e ef    	vmovd  %edi,%xmm21
 18adff4:	62 e3 55 00 20 6e 1e 01 	vpinsrb $0x1,0x1e(%rsi),%xmm21,%xmm21
 18adffc:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 18ae002:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 18ae009:	62 33 7d 48 39 fb 02 	vextracti32x4 $0x2,%zmm15,%xmm19
 18ae010:	62 53 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm15,%xmm15
 18ae017:	62 e3 55 00 20 6f 1e 02 	vpinsrb $0x2,0x1e(%rdi),%xmm21,%xmm21
 18ae01f:	62 e1 fd 08 7e df    	vmovq  %xmm19,%rdi
 18ae025:	62 e3 55 00 20 6e 1e 03 	vpinsrb $0x3,0x1e(%rsi),%xmm21,%xmm21
 18ae02d:	62 e3 fd 08 16 de 01 	vpextrq $0x1,%xmm19,%rsi
 18ae034:	62 e3 55 00 20 5f 1e 04 	vpinsrb $0x4,0x1e(%rdi),%xmm21,%xmm19
 18ae03c:	62 e3 fd 08 16 cf 01 	vpextrq $0x1,%xmm17,%rdi
 18ae043:	62 e3 6d 00 20 57 1e 0f 	vpinsrb $0xf,0x1e(%rdi),%xmm18,%xmm18
 18ae04b:	c4 61 f9 7e ff       	vmovq  %xmm15,%rdi
 18ae050:	62 e3 65 00 20 4e 1e 05 	vpinsrb $0x5,0x1e(%rsi),%xmm19,%xmm17
 18ae058:	c4 63 f9 16 fe 01    	vpextrq $0x1,%xmm15,%rsi
 18ae05e:	62 a1 55 00 ef ed    	vpxord %xmm21,%xmm21,%xmm21
 18ae064:	62 73 75 00 20 7f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm17,%xmm15
 18ae06c:	c4 61 f9 7e ef       	vmovq  %xmm13,%rdi
 18ae071:	62 33 7d 28 39 e9 01 	vextracti32x4 $0x1,%ymm13,%xmm17
 18ae078:	62 a1 65 00 ef db    	vpxord %xmm19,%xmm19,%xmm19
 18ae07e:	c4 63 01 20 7e 1e 07 	vpinsrb $0x7,0x1e(%rsi),%xmm15,%xmm15
 18ae085:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 18ae08b:	c4 63 01 20 7f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm15,%xmm15
 18ae092:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 18ae098:	c4 63 01 20 7e 1e 09 	vpinsrb $0x9,0x1e(%rsi),%xmm15,%xmm15
 18ae09f:	62 e3 fd 08 16 ce 01 	vpextrq $0x1,%xmm17,%rsi
 18ae0a6:	62 33 7d 48 39 e9 02 	vextracti32x4 $0x2,%zmm13,%xmm17
 18ae0ad:	62 53 7d 48 39 ed 03 	vextracti32x4 $0x3,%zmm13,%xmm13
 18ae0b4:	c4 63 01 20 7f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm15,%xmm15
 18ae0bb:	62 e1 fd 08 7e cf    	vmovq  %xmm17,%rdi
 18ae0c1:	c4 63 01 20 7e 1e 0b 	vpinsrb $0xb,0x1e(%rsi),%xmm15,%xmm15
 18ae0c8:	62 e3 fd 08 16 ce 01 	vpextrq $0x1,%xmm17,%rsi
 18ae0cf:	62 a1 75 00 ef c9    	vpxord %xmm17,%xmm17,%xmm17
 18ae0d5:	c4 63 01 20 7f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm15,%xmm15
 18ae0dc:	c4 63 01 20 7e 1e 0d 	vpinsrb $0xd,0x1e(%rsi),%xmm15,%xmm15
 18ae0e3:	62 e3 fd 08 16 e6 01 	vpextrq $0x1,%xmm20,%rsi
 18ae0ea:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 18ae0f0:	62 e3 7d 00 20 46 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm16,%xmm16
 18ae0f8:	c4 61 f9 7e ee       	vmovq  %xmm13,%rsi
 18ae0fd:	c4 63 01 20 7e 1e 0e 	vpinsrb $0xe,0x1e(%rsi),%xmm15,%xmm15
 18ae104:	c4 63 f9 16 ee 01    	vpextrq $0x1,%xmm13,%rsi
 18ae10a:	c4 63 01 20 6e 1e 0f 	vpinsrb $0xf,0x1e(%rsi),%xmm15,%xmm13
 18ae111:	c4 41 01 ef ff       	vpxor  %xmm15,%xmm15,%xmm15
 18ae116:	62 32 7d 49 91 7c 21 04 	vpgatherqd 0x10(%rcx,%zmm12,1),%ymm15{%k1}
 18ae11e:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae122:	62 a2 7d 49 91 4c 19 04 	vpgatherqd 0x10(%rcx,%zmm11,1),%ymm17{%k1}
 18ae12a:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae12e:	62 a2 7d 49 91 9c 21 90 02 00 00 	vpgatherqd 0x290(%rcx,%zmm12,1),%ymm19{%k1}
 18ae139:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae13d:	62 a2 7d 49 91 a4 19 90 02 00 00 	vpgatherqd 0x290(%rcx,%zmm11,1),%ymm20{%k1}
 18ae148:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae14c:	62 53 f5 40 3a ff 01 	vinserti64x4 $0x1,%ymm15,%zmm17,%zmm15
 18ae153:	62 a1 75 00 ef c9    	vpxord %xmm17,%xmm17,%xmm17
 18ae159:	62 a2 7d 49 91 8c 21 10 05 00 00 	vpgatherqd 0x510(%rcx,%zmm12,1),%ymm17{%k1}
 18ae164:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae168:	62 a2 7d 49 91 ac 19 10 05 00 00 	vpgatherqd 0x510(%rcx,%zmm11,1),%ymm21{%k1}
 18ae173:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae177:	62 f1 05 48 fe ed    	vpaddd %zmm5,%zmm15,%zmm5
 18ae17d:	62 a3 dd 40 3a db 01 	vinserti64x4 $0x1,%ymm19,%zmm20,%zmm19
 18ae184:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 18ae18a:	62 a2 7d 49 91 a4 21 90 07 00 00 	vpgatherqd 0x790(%rcx,%zmm12,1),%ymm20{%k1}
 18ae195:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae199:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
 18ae19e:	62 32 7d 49 91 a4 19 90 07 00 00 	vpgatherqd 0x790(%rcx,%zmm11,1),%ymm12{%k1}
 18ae1a9:	62 51 65 40 fe c0    	vpaddd %zmm8,%zmm19,%zmm8
 18ae1af:	62 a3 d5 40 3a c9 01 	vinserti64x4 $0x1,%ymm17,%zmm21,%zmm17
 18ae1b6:	62 d1 55 00 71 f6 07 	vpsllw $0x7,%xmm14,%xmm21
 18ae1bd:	62 52 7d 48 31 f6    	vpmovzxbd %xmm14,%zmm14
 18ae1c3:	62 b2 7e 08 29 d5    	vpmovb2m %xmm21,%k2
 18ae1c9:	62 b1 55 00 71 f0 07 	vpsllw $0x7,%xmm16,%xmm21
 18ae1d0:	62 a2 7d 48 31 c0    	vpmovzxbd %xmm16,%zmm16
 18ae1d6:	62 51 75 40 fe c9    	vpaddd %zmm9,%zmm17,%zmm9
 18ae1dc:	62 33 9d 48 3a dc 01 	vinserti64x4 $0x1,%ymm20,%zmm12,%zmm11
 18ae1e3:	62 b1 5d 00 71 f2 07 	vpsllw $0x7,%xmm18,%xmm20
 18ae1ea:	62 a2 7d 48 31 d2    	vpmovzxbd %xmm18,%zmm18
 18ae1f0:	62 b2 7e 08 29 cd    	vpmovb2m %xmm21,%k1
 18ae1f6:	62 d1 75 4a fe cf    	vpaddd %zmm15,%zmm1,%zmm1{%k2}
 18ae1fc:	62 b2 7e 08 29 dc    	vpmovb2m %xmm20,%k3
 18ae202:	62 d1 5d 00 71 f5 07 	vpsllw $0x7,%xmm13,%xmm20
 18ae209:	62 52 7d 48 31 ed    	vpmovzxbd %xmm13,%zmm13
 18ae20f:	62 51 25 48 fe d2    	vpaddd %zmm10,%zmm11,%zmm10
 18ae215:	62 b1 65 49 fe d9    	vpaddd %zmm17,%zmm3,%zmm3{%k1}
 18ae21b:	62 b2 7e 08 29 e4    	vpmovb2m %xmm20,%k4
 18ae221:	62 d1 55 48 fa ee    	vpsubd %zmm14,%zmm5,%zmm5
 18ae227:	62 b1 6d 4b fe d3    	vpaddd %zmm19,%zmm2,%zmm2{%k3}
 18ae22d:	62 31 35 48 fa c8    	vpsubd %zmm16,%zmm9,%zmm9
 18ae233:	62 d1 5d 4c fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k4}
 18ae239:	62 31 3d 48 fa c2    	vpsubd %zmm18,%zmm8,%zmm8
 18ae23f:	62 51 2d 48 fa d5    	vpsubd %zmm13,%zmm10,%zmm10
 18ae245:	0f 85 25 fa ff ff    	jne    18adc70 <run_backend_benchmark+0x6650>
 18ae24b:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18ae251:	62 f1 5d 48 fe d3    	vpaddd %zmm3,%zmm4,%zmm2
 18ae257:	62 f1 3d 48 fe ed    	vpaddd %zmm5,%zmm8,%zmm5
 18ae25d:	62 d1 2d 48 fe f1    	vpaddd %zmm9,%zmm10,%zmm6
 18ae263:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18ae26b:	62 f1 4d 48 fe ed    	vpaddd %zmm5,%zmm6,%zmm5
 18ae271:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18ae277:	62 f3 fd 48 3b ee 01 	vextracti64x4 $0x1,%zmm5,%ymm6
 18ae27e:	62 f3 fd 48 3b ca 01 	vextracti64x4 $0x1,%zmm1,%ymm2
 18ae285:	62 f1 55 48 fe ee    	vpaddd %zmm6,%zmm5,%zmm5
 18ae28b:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
 18ae291:	c4 e3 7d 39 ee 01    	vextracti128 $0x1,%ymm5,%xmm6
 18ae297:	c4 e3 7d 39 ca 01    	vextracti128 $0x1,%ymm1,%xmm2
 18ae29d:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 18ae2a1:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 18ae2a5:	c5 f9 70 f5 ee       	vpshufd $0xee,%xmm5,%xmm6
 18ae2aa:	c5 f9 70 d1 ee       	vpshufd $0xee,%xmm1,%xmm2
 18ae2af:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 18ae2b3:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 18ae2b7:	c5 f9 70 f5 55       	vpshufd $0x55,%xmm5,%xmm6
 18ae2bc:	c5 f9 70 d1 55       	vpshufd $0x55,%xmm1,%xmm2
 18ae2c1:	c5 d1 fe ee          	vpaddd %xmm6,%xmm5,%xmm5
 18ae2c5:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 18ae2c9:	c4 c1 79 7e eb       	vmovd  %xmm5,%r11d
 18ae2ce:	c5 f9 7e ca          	vmovd  %xmm1,%edx
 18ae2d2:	39 f0                	cmp    %esi,%eax
 18ae2d4:	0f 84 62 02 00 00    	je     18ae53c <run_backend_benchmark+0x6f1c>
 18ae2da:	40 f6 c6 30          	test   $0x30,%sil
 18ae2de:	0f 84 1b 02 00 00    	je     18ae4ff <run_backend_benchmark+0x6edf>
 18ae2e4:	48 89 c6             	mov    %rax,%rsi
 18ae2e7:	62 f2 fd 48 7c e6    	vpbroadcastq %rsi,%zmm4
 18ae2ed:	62 f1 dd 48 eb 1d 49 1f c7 fe 	vporq  -0x138e0b7(%rip),%zmm4,%zmm3        # 520240 <branch_sizing_patterns+0x4b0>
 18ae2f7:	62 f1 dd 48 eb 25 7f 1f c7 fe 	vporq  -0x138e081(%rip),%zmm4,%zmm4        # 520280 <branch_sizing_patterns+0x4f0>
 18ae301:	62 72 fd 48 59 15 cd 1d cd fe 	vpbroadcastq -0x132e233(%rip),%zmm10        # 5800d8 <x86_semantics_benchmark_code.registers+0xe8>
 18ae30b:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18ae313:	83 e0 f0             	and    $0xfffffff0,%eax
 18ae316:	c4 c1 79 6e d3       	vmovd  %r11d,%xmm2
 18ae31b:	c5 f9 6e ca          	vmovd  %edx,%xmm1
 18ae31f:	48 29 c6             	sub    %rax,%rsi
 18ae322:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18ae330:	62 92 dd 48 40 f0    	vpmullq %zmm24,%zmm4,%zmm6
 18ae336:	62 92 e5 48 40 e8    	vpmullq %zmm24,%zmm3,%zmm5
 18ae33c:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae340:	62 d1 dd 48 d4 e2    	vpaddq %zmm10,%zmm4,%zmm4
 18ae346:	62 d1 e5 48 d4 da    	vpaddq %zmm10,%zmm3,%zmm3
 18ae34c:	48 83 c6 10          	add    $0x10,%rsi
 18ae350:	62 f1 fd 48 d4 fe    	vpaddq %zmm6,%zmm0,%zmm7
 18ae356:	c4 e1 f9 7e fa       	vmovq  %xmm7,%rdx
 18ae35b:	c4 e3 f9 16 ff 01    	vpextrq $0x1,%xmm7,%rdi
 18ae361:	c4 c3 7d 39 f8 01    	vextracti128 $0x1,%ymm7,%xmm8
 18ae367:	0f b6 52 1e          	movzbl 0x1e(%rdx),%edx
 18ae36b:	c5 79 6e ca          	vmovd  %edx,%xmm9
 18ae36f:	c4 63 31 20 4f 1e 01 	vpinsrb $0x1,0x1e(%rdi),%xmm9,%xmm9
 18ae376:	c4 61 f9 7e c2       	vmovq  %xmm8,%rdx
 18ae37b:	c4 63 f9 16 c7 01    	vpextrq $0x1,%xmm8,%rdi
 18ae381:	62 d3 7d 48 39 f8 02 	vextracti32x4 $0x2,%zmm7,%xmm8
 18ae388:	62 f3 7d 48 39 ff 03 	vextracti32x4 $0x3,%zmm7,%xmm7
 18ae38f:	c4 63 31 20 4a 1e 02 	vpinsrb $0x2,0x1e(%rdx),%xmm9,%xmm9
 18ae396:	c4 61 f9 7e c2       	vmovq  %xmm8,%rdx
 18ae39b:	c4 63 31 20 4f 1e 03 	vpinsrb $0x3,0x1e(%rdi),%xmm9,%xmm9
 18ae3a2:	c4 63 f9 16 c7 01    	vpextrq $0x1,%xmm8,%rdi
 18ae3a8:	62 71 fd 48 d4 c5    	vpaddq %zmm5,%zmm0,%zmm8
 18ae3ae:	c4 63 31 20 4a 1e 04 	vpinsrb $0x4,0x1e(%rdx),%xmm9,%xmm9
 18ae3b5:	c4 e3 f9 16 fa 01    	vpextrq $0x1,%xmm7,%rdx
 18ae3bb:	c4 63 31 20 4f 1e 05 	vpinsrb $0x5,0x1e(%rdi),%xmm9,%xmm9
 18ae3c2:	c4 e1 f9 7e ff       	vmovq  %xmm7,%rdi
 18ae3c7:	c4 e3 31 20 7f 1e 06 	vpinsrb $0x6,0x1e(%rdi),%xmm9,%xmm7
 18ae3ce:	c4 61 f9 7e c7       	vmovq  %xmm8,%rdi
 18ae3d3:	c4 43 7d 39 c1 01    	vextracti128 $0x1,%ymm8,%xmm9
 18ae3d9:	c4 e3 41 20 7a 1e 07 	vpinsrb $0x7,0x1e(%rdx),%xmm7,%xmm7
 18ae3e0:	c4 63 f9 16 c2 01    	vpextrq $0x1,%xmm8,%rdx
 18ae3e6:	c4 e3 41 20 7f 1e 08 	vpinsrb $0x8,0x1e(%rdi),%xmm7,%xmm7
 18ae3ed:	c4 61 f9 7e cf       	vmovq  %xmm9,%rdi
 18ae3f2:	c4 e3 41 20 7a 1e 09 	vpinsrb $0x9,0x1e(%rdx),%xmm7,%xmm7
 18ae3f9:	c4 63 f9 16 ca 01    	vpextrq $0x1,%xmm9,%rdx
 18ae3ff:	62 53 7d 48 39 c1 02 	vextracti32x4 $0x2,%zmm8,%xmm9
 18ae406:	62 53 7d 48 39 c0 03 	vextracti32x4 $0x3,%zmm8,%xmm8
 18ae40d:	c4 e3 41 20 7f 1e 0a 	vpinsrb $0xa,0x1e(%rdi),%xmm7,%xmm7
 18ae414:	c4 61 f9 7e cf       	vmovq  %xmm9,%rdi
 18ae419:	c4 e3 41 20 7a 1e 0b 	vpinsrb $0xb,0x1e(%rdx),%xmm7,%xmm7
 18ae420:	c4 63 f9 16 ca 01    	vpextrq $0x1,%xmm9,%rdx
 18ae426:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
 18ae42b:	c4 e3 41 20 7f 1e 0c 	vpinsrb $0xc,0x1e(%rdi),%xmm7,%xmm7
 18ae432:	c4 61 f9 7e c7       	vmovq  %xmm8,%rdi
 18ae437:	c4 e3 41 20 7a 1e 0d 	vpinsrb $0xd,0x1e(%rdx),%xmm7,%xmm7
 18ae43e:	c4 63 f9 16 c2 01    	vpextrq $0x1,%xmm8,%rdx
 18ae444:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18ae449:	62 72 7d 49 91 44 29 04 	vpgatherqd 0x10(%rcx,%zmm5,1),%ymm8{%k1}
 18ae451:	c5 fd 46 c8          	kxnorb %k0,%k0,%k1
 18ae455:	62 72 7d 49 91 4c 31 04 	vpgatherqd 0x10(%rcx,%zmm6,1),%ymm9{%k1}
 18ae45d:	c4 e3 41 20 7f 1e 0e 	vpinsrb $0xe,0x1e(%rdi),%xmm7,%xmm7
 18ae464:	62 d3 b5 48 3a e8 01 	vinserti64x4 $0x1,%ymm8,%zmm9,%zmm5
 18ae46b:	62 f1 55 48 fe d2    	vpaddd %zmm2,%zmm5,%zmm2
 18ae471:	c4 e3 41 20 7a 1e 0f 	vpinsrb $0xf,0x1e(%rdx),%xmm7,%xmm7
 18ae478:	c5 c9 71 f7 07       	vpsllw $0x7,%xmm7,%xmm6
 18ae47d:	62 f2 7d 48 31 ff    	vpmovzxbd %xmm7,%zmm7
 18ae483:	62 f2 7e 08 29 ce    	vpmovb2m %xmm6,%k1
 18ae489:	62 f1 75 49 fe cd    	vpaddd %zmm5,%zmm1,%zmm1{%k1}
 18ae48f:	62 f1 6d 48 fa d7    	vpsubd %zmm7,%zmm2,%zmm2
 18ae495:	0f 85 95 fe ff ff    	jne    18ae330 <run_backend_benchmark+0x6d10>
 18ae49b:	62 f3 fd 48 3b d0 01 	vextracti64x4 $0x1,%zmm2,%ymm0
 18ae4a2:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18ae4a8:	c4 e3 7d 39 c2 01    	vextracti128 $0x1,%ymm0,%xmm2
 18ae4ae:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 18ae4b2:	c5 f9 70 d0 ee       	vpshufd $0xee,%xmm0,%xmm2
 18ae4b7:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 18ae4bb:	c5 f9 70 d0 55       	vpshufd $0x55,%xmm0,%xmm2
 18ae4c0:	c5 f9 fe c2          	vpaddd %xmm2,%xmm0,%xmm0
 18ae4c4:	c4 c1 79 7e c3       	vmovd  %xmm0,%r11d
 18ae4c9:	62 f3 fd 48 3b c8 01 	vextracti64x4 $0x1,%zmm1,%ymm0
 18ae4d0:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18ae4d6:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 18ae4dc:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 18ae4e0:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 18ae4e5:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 18ae4e9:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 18ae4ee:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 18ae4f2:	c5 f9 7e c2          	vmovd  %xmm0,%edx
 18ae4f6:	3b 84 24 90 00 00 00 	cmp    0x90(%rsp),%eax
 18ae4fd:	74 3d                	je     18ae53c <run_backend_benchmark+0x6f1c>
 18ae4ff:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18ae507:	48 29 c1             	sub    %rax,%rcx
 18ae50a:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 18ae50e:	49 8d 84 c1 8e 03 00 00 	lea    0x38e(%r9,%rax,8),%rax
 18ae516:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18ae520:	8b 70 f2             	mov    -0xe(%rax),%esi
 18ae523:	0f b6 38             	movzbl (%rax),%edi
 18ae526:	41 01 f3             	add    %esi,%r11d
 18ae529:	41 29 fb             	sub    %edi,%r11d
 18ae52c:	85 ff                	test   %edi,%edi
 18ae52e:	0f 44 f7             	cmove  %edi,%esi
 18ae531:	48 83 c0 28          	add    $0x28,%rax
 18ae535:	01 f2                	add    %esi,%edx
 18ae537:	48 ff c9             	dec    %rcx
 18ae53a:	75 e4                	jne    18ae520 <run_backend_benchmark+0x6f00>
 18ae53c:	ff c2                	inc    %edx
 18ae53e:	48 c1 e2 03          	shl    $0x3,%rdx
 18ae542:	41 8b 49 78          	mov    0x78(%r9),%ecx
 18ae546:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18ae54e:	4b 8d 7c 2a 03       	lea    0x3(%r10,%r13,1),%rdi
 18ae553:	4f 8d 04 2a          	lea    (%r10,%r13,1),%r8
 18ae557:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 18ae55b:	01 c8                	add    %ecx,%eax
 18ae55d:	8d 70 01             	lea    0x1(%rax),%esi
 18ae560:	48 89 84 24 f0 00 00 00 	mov    %rax,0xf0(%rsp)
 18ae568:	4c 39 c7             	cmp    %r8,%rdi
 18ae56b:	73 14                	jae    18ae581 <run_backend_benchmark+0x6f61>
 18ae56d:	48 c7 44 24 60 00 00 00 00 	movq   $0x0,0x60(%rsp)
 18ae576:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18ae57f:	eb 5c                	jmp    18ae5dd <run_backend_benchmark+0x6fbd>
 18ae581:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 18ae586:	48 8d 04 b5 00 00 00 00 	lea    0x0(,%rsi,4),%rax
 18ae58e:	4c 29 ef             	sub    %r13,%rdi
 18ae591:	4d 89 f0             	mov    %r14,%r8
 18ae594:	49 29 f8             	sub    %rdi,%r8
 18ae597:	72 2b                	jb     18ae5c4 <run_backend_benchmark+0x6fa4>
 18ae599:	4c 39 c0             	cmp    %r8,%rax
 18ae59c:	77 26                	ja     18ae5c4 <run_backend_benchmark+0x6fa4>
 18ae59e:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18ae5a3:	48 01 c7             	add    %rax,%rdi
 18ae5a6:	49 89 fa             	mov    %rdi,%r10
 18ae5a9:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 18ae5ae:	49 01 c0             	add    %rax,%r8
 18ae5b1:	4c 89 c7             	mov    %r8,%rdi
 18ae5b4:	4c 29 ef             	sub    %r13,%rdi
 18ae5b7:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
 18ae5bc:	4d 89 f0             	mov    %r14,%r8
 18ae5bf:	49 29 f8             	sub    %rdi,%r8
 18ae5c2:	eb 09                	jmp    18ae5cd <run_backend_benchmark+0x6fad>
 18ae5c4:	48 c7 44 24 60 00 00 00 00 	movq   $0x0,0x60(%rsp)
 18ae5cd:	4c 39 f7             	cmp    %r14,%rdi
 18ae5d0:	77 a4                	ja     18ae576 <run_backend_benchmark+0x6f56>
 18ae5d2:	4c 39 c0             	cmp    %r8,%rax
 18ae5d5:	77 9f                	ja     18ae576 <run_backend_benchmark+0x6f56>
 18ae5d7:	48 01 c7             	add    %rax,%rdi
 18ae5da:	49 89 fa             	mov    %rdi,%r10
 18ae5dd:	49 8b 81 90 0d 00 00 	mov    0xd90(%r9),%rax
 18ae5e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18ae5ea:	4c 89 94 24 a0 00 00 00 	mov    %r10,0xa0(%rsp)
 18ae5f2:	4c 89 9c 24 58 01 00 00 	mov    %r11,0x158(%rsp)
 18ae5fa:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18ae5ff:	4c 89 f0             	mov    %r14,%rax
 18ae602:	4c 29 d0             	sub    %r10,%rax
 18ae605:	40 0f 93 c7          	setae  %dil
 18ae609:	48 39 f0             	cmp    %rsi,%rax
 18ae60c:	0f 93 c0             	setae  %al
 18ae60f:	40 20 f8             	and    %dil,%al
 18ae612:	4c 0f 45 c6          	cmovne %rsi,%r8
 18ae616:	4d 01 d0             	add    %r10,%r8
 18ae619:	4f 8d 54 05 03       	lea    0x3(%r13,%r8,1),%r10
 18ae61e:	4b 8d 3c 28          	lea    (%r8,%r13,1),%rdi
 18ae622:	49 83 e2 fc          	and    $0xfffffffffffffffc,%r10
 18ae626:	49 39 fa             	cmp    %rdi,%r10
 18ae629:	73 22                	jae    18ae64d <run_backend_benchmark+0x702d>
 18ae62b:	4c 89 c7             	mov    %r8,%rdi
 18ae62e:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18ae637:	45 31 ed             	xor    %r13d,%r13d
 18ae63a:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 18ae643:	31 f6                	xor    %esi,%esi
 18ae645:	4d 89 ca             	mov    %r9,%r10
 18ae648:	e9 1e 01 00 00       	jmp    18ae76b <run_backend_benchmark+0x714b>
 18ae64d:	41 8b b9 90 00 00 00 	mov    0x90(%r9),%edi
 18ae654:	4d 89 f1             	mov    %r14,%r9
 18ae657:	45 8d 5c 3b 01       	lea    0x1(%r11,%rdi,1),%r11d
 18ae65c:	4c 89 d7             	mov    %r10,%rdi
 18ae65f:	4c 29 ef             	sub    %r13,%rdi
 18ae662:	49 29 f9             	sub    %rdi,%r9
 18ae665:	72 29                	jb     18ae690 <run_backend_benchmark+0x7070>
 18ae667:	4a 8d 1c 9d 00 00 00 00 	lea    0x0(,%r11,4),%rbx
 18ae66f:	4c 39 cb             	cmp    %r9,%rbx
 18ae672:	77 1c                	ja     18ae690 <run_backend_benchmark+0x7070>
 18ae674:	4d 89 d5             	mov    %r10,%r13
 18ae677:	48 01 df             	add    %rbx,%rdi
 18ae67a:	49 01 da             	add    %rbx,%r10
 18ae67d:	4d 89 f1             	mov    %r14,%r9
 18ae680:	49 89 f8             	mov    %rdi,%r8
 18ae683:	4c 89 d7             	mov    %r10,%rdi
 18ae686:	48 2b 7c 24 50       	sub    0x50(%rsp),%rdi
 18ae68b:	49 29 f9             	sub    %rdi,%r9
 18ae68e:	eb 03                	jmp    18ae693 <run_backend_benchmark+0x7073>
 18ae690:	45 31 ed             	xor    %r13d,%r13d
 18ae693:	4c 39 f7             	cmp    %r14,%rdi
 18ae696:	77 3e                	ja     18ae6d6 <run_backend_benchmark+0x70b6>
 18ae698:	49 c1 e3 03          	shl    $0x3,%r11
 18ae69c:	4d 39 cb             	cmp    %r9,%r11
 18ae69f:	77 35                	ja     18ae6d6 <run_backend_benchmark+0x70b6>
 18ae6a1:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
 18ae6a6:	4c 01 df             	add    %r11,%rdi
 18ae6a9:	4d 8d 5c 39 03       	lea    0x3(%r9,%rdi,1),%r11
 18ae6ae:	4e 8d 04 0f          	lea    (%rdi,%r9,1),%r8
 18ae6b2:	49 83 e3 fc          	and    $0xfffffffffffffffc,%r11
 18ae6b6:	4d 39 c3             	cmp    %r8,%r11
 18ae6b9:	73 29                	jae    18ae6e4 <run_backend_benchmark+0x70c4>
 18ae6bb:	4c 89 54 24 78       	mov    %r10,0x78(%rsp)
 18ae6c0:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18ae6c8:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18ae6d1:	e9 93 00 00 00       	jmp    18ae769 <run_backend_benchmark+0x7149>
 18ae6d6:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 18ae6df:	4d 89 d3             	mov    %r10,%r11
 18ae6e2:	eb 14                	jmp    18ae6f8 <run_backend_benchmark+0x70d8>
 18ae6e4:	49 89 f8             	mov    %rdi,%r8
 18ae6e7:	4c 89 df             	mov    %r11,%rdi
 18ae6ea:	4c 29 cf             	sub    %r9,%rdi
 18ae6ed:	4d 89 f1             	mov    %r14,%r9
 18ae6f0:	4c 89 54 24 78       	mov    %r10,0x78(%rsp)
 18ae6f5:	49 29 f9             	sub    %rdi,%r9
 18ae6f8:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18ae700:	4c 39 f7             	cmp    %r14,%rdi
 18ae703:	77 2a                	ja     18ae72f <run_backend_benchmark+0x710f>
 18ae705:	48 c1 e6 04          	shl    $0x4,%rsi
 18ae709:	4c 39 ce             	cmp    %r9,%rsi
 18ae70c:	77 21                	ja     18ae72f <run_backend_benchmark+0x710f>
 18ae70e:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
 18ae713:	48 01 f7             	add    %rsi,%rdi
 18ae716:	49 8d 74 39 03       	lea    0x3(%r9,%rdi,1),%rsi
 18ae71b:	4e 8d 04 0f          	lea    (%rdi,%r9,1),%r8
 18ae71f:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 18ae723:	4c 39 c6             	cmp    %r8,%rsi
 18ae726:	73 15                	jae    18ae73d <run_backend_benchmark+0x711d>
 18ae728:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
 18ae72d:	eb 3a                	jmp    18ae769 <run_backend_benchmark+0x7149>
 18ae72f:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18ae738:	4c 89 de             	mov    %r11,%rsi
 18ae73b:	eb 14                	jmp    18ae751 <run_backend_benchmark+0x7131>
 18ae73d:	49 89 f8             	mov    %rdi,%r8
 18ae740:	48 89 f7             	mov    %rsi,%rdi
 18ae743:	4c 29 cf             	sub    %r9,%rdi
 18ae746:	4d 89 f1             	mov    %r14,%r9
 18ae749:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
 18ae74e:	49 29 f9             	sub    %rdi,%r9
 18ae751:	4c 39 f7             	cmp    %r14,%rdi
 18ae754:	77 10                	ja     18ae766 <run_backend_benchmark+0x7146>
 18ae756:	ff c1                	inc    %ecx
 18ae758:	48 c1 e1 02          	shl    $0x2,%rcx
 18ae75c:	4c 39 c9             	cmp    %r9,%rcx
 18ae75f:	77 05                	ja     18ae766 <run_backend_benchmark+0x7146>
 18ae761:	48 01 cf             	add    %rcx,%rdi
 18ae764:	eb 05                	jmp    18ae76b <run_backend_benchmark+0x714b>
 18ae766:	4c 89 c7             	mov    %r8,%rdi
 18ae769:	31 f6                	xor    %esi,%esi
 18ae76b:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18ae770:	4c 89 f1             	mov    %r14,%rcx
 18ae773:	49 89 b3 08 3a 00 00 	mov    %rsi,0x3a08(%r11)
 18ae77a:	41 8b 5a 78          	mov    0x78(%r10),%ebx
 18ae77e:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
 18ae783:	ff c3                	inc    %ebx
 18ae785:	48 29 f9             	sub    %rdi,%rcx
 18ae788:	41 0f 92 c0          	setb   %r8b
 18ae78c:	48 39 d9             	cmp    %rbx,%rcx
 18ae78f:	4a 8d 0c 17          	lea    (%rdi,%r10,1),%rcx
 18ae793:	41 0f 92 c1          	setb   %r9b
 18ae797:	45 08 c1             	or     %r8b,%r9b
 18ae79a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18ae7a0:	45 84 c9             	test   %r9b,%r9b
 18ae7a3:	49 0f 45 d8          	cmovne %r8,%rbx
 18ae7a7:	49 0f 45 c8          	cmovne %r8,%rcx
 18ae7ab:	48 01 fb             	add    %rdi,%rbx
 18ae7ae:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18ae7b4:	49 89 8b 40 3a 00 00 	mov    %rcx,0x3a40(%r11)
 18ae7bb:	74 17                	je     18ae7d4 <run_backend_benchmark+0x71b4>
 18ae7bd:	4a 8d 7c 13 03       	lea    0x3(%rbx,%r10,1),%rdi
 18ae7c2:	4e 8d 04 13          	lea    (%rbx,%r10,1),%r8
 18ae7c6:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 18ae7ca:	4c 39 c7             	cmp    %r8,%rdi
 18ae7cd:	73 2e                	jae    18ae7fd <run_backend_benchmark+0x71dd>
 18ae7cf:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18ae7d4:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18ae7dc:	49 8d 93 48 3a 00 00 	lea    0x3a48(%r11),%rdx
 18ae7e3:	49 c7 83 48 3a 00 00 00 00 00 00 	movq   $0x0,0x3a48(%r11)
 18ae7ee:	31 ff                	xor    %edi,%edi
 18ae7f0:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 18ae7f8:	e9 92 00 00 00       	jmp    18ae88f <run_backend_benchmark+0x726f>
 18ae7fd:	49 89 f8             	mov    %rdi,%r8
 18ae800:	4d 29 d0             	sub    %r10,%r8
 18ae803:	4d 89 f1             	mov    %r14,%r9
 18ae806:	4d 29 c1             	sub    %r8,%r9
 18ae809:	72 31                	jb     18ae83c <run_backend_benchmark+0x721c>
 18ae80b:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18ae813:	45 8b 92 90 00 00 00 	mov    0x90(%r10),%r10d
 18ae81a:	41 ff c2             	inc    %r10d
 18ae81d:	49 c1 e2 02          	shl    $0x2,%r10
 18ae821:	4d 39 ca             	cmp    %r9,%r10
 18ae824:	77 16                	ja     18ae83c <run_backend_benchmark+0x721c>
 18ae826:	49 89 f9             	mov    %rdi,%r9
 18ae829:	4c 01 d7             	add    %r10,%rdi
 18ae82c:	4c 89 c3             	mov    %r8,%rbx
 18ae82f:	4c 01 d3             	add    %r10,%rbx
 18ae832:	49 89 f8             	mov    %rdi,%r8
 18ae835:	4c 2b 44 24 50       	sub    0x50(%rsp),%r8
 18ae83a:	eb 03                	jmp    18ae83f <run_backend_benchmark+0x721f>
 18ae83c:	45 31 c9             	xor    %r9d,%r9d
 18ae83f:	4c 8b 54 24 58       	mov    0x58(%rsp),%r10
 18ae844:	4d 8d 9a 48 3a 00 00 	lea    0x3a48(%r10),%r11
 18ae84b:	4d 89 8a 48 3a 00 00 	mov    %r9,0x3a48(%r10)
 18ae852:	4d 89 f1             	mov    %r14,%r9
 18ae855:	4d 29 c1             	sub    %r8,%r9
 18ae858:	4c 89 9c 24 b0 00 00 00 	mov    %r11,0xb0(%rsp)
 18ae860:	72 1e                	jb     18ae880 <run_backend_benchmark+0x7260>
 18ae862:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18ae86a:	4c 39 ca             	cmp    %r9,%rdx
 18ae86d:	77 08                	ja     18ae877 <run_backend_benchmark+0x7257>
 18ae86f:	49 01 d0             	add    %rdx,%r8
 18ae872:	4c 89 c3             	mov    %r8,%rbx
 18ae875:	eb 02                	jmp    18ae879 <run_backend_benchmark+0x7259>
 18ae877:	31 ff                	xor    %edi,%edi
 18ae879:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18ae87e:	eb 0f                	jmp    18ae88f <run_backend_benchmark+0x726f>
 18ae880:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18ae885:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18ae88d:	31 ff                	xor    %edi,%edi
 18ae88f:	49 89 bb 50 3a 00 00 	mov    %rdi,0x3a50(%r11)
 18ae896:	31 d2                	xor    %edx,%edx
 18ae898:	41 80 ba ec 02 00 00 01 	cmpb   $0x1,0x2ec(%r10)
 18ae8a0:	75 14                	jne    18ae8b6 <run_backend_benchmark+0x7296>
 18ae8a2:	41 8b 92 e4 02 00 00 	mov    0x2e4(%r10),%edx
 18ae8a9:	4c 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%r8
 18ae8b1:	41 8d 54 10 01       	lea    0x1(%r8,%rdx,1),%edx
 18ae8b6:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18ae8bb:	41 89 90 18 3a 00 00 	mov    %edx,0x3a18(%r8)
 18ae8c2:	41 80 ba ec 02 00 00 01 	cmpb   $0x1,0x2ec(%r10)
 18ae8ca:	75 1d                	jne    18ae8e9 <run_backend_benchmark+0x72c9>
 18ae8cc:	4d 89 f1             	mov    %r14,%r9
 18ae8cf:	49 29 d9             	sub    %rbx,%r9
 18ae8d2:	72 15                	jb     18ae8e9 <run_backend_benchmark+0x72c9>
 18ae8d4:	41 89 d0             	mov    %edx,%r8d
 18ae8d7:	4d 39 c1             	cmp    %r8,%r9
 18ae8da:	72 0d                	jb     18ae8e9 <run_backend_benchmark+0x72c9>
 18ae8dc:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
 18ae8e1:	48 01 da             	add    %rbx,%rdx
 18ae8e4:	4c 01 c3             	add    %r8,%rbx
 18ae8e7:	eb 02                	jmp    18ae8eb <run_backend_benchmark+0x72cb>
 18ae8e9:	31 d2                	xor    %edx,%edx
 18ae8eb:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18ae8f3:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18ae8f8:	4c 03 44 24 50       	add    0x50(%rsp),%r8
 18ae8fd:	4c 89 84 24 a0 00 00 00 	mov    %r8,0xa0(%rsp)
 18ae905:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18ae90a:	49 89 90 10 3a 00 00 	mov    %rdx,0x3a10(%r8)
 18ae911:	41 0f 95 c0          	setne  %r8b
 18ae915:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 18ae91b:	0f 84 9e 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae921:	4d 85 c9             	test   %r9,%r9
 18ae924:	0f 84 95 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae92a:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
 18ae930:	0f 84 89 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae936:	41 20 c0             	and    %al,%r8b
 18ae939:	0f 84 80 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae93f:	4d 85 ed             	test   %r13,%r13
 18ae942:	0f 84 77 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae948:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 18ae94e:	0f 84 6b 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae954:	48 85 f6             	test   %rsi,%rsi
 18ae957:	0f 84 62 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae95d:	48 85 c9             	test   %rcx,%rcx
 18ae960:	0f 84 59 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae966:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18ae96c:	74 1b                	je     18ae989 <run_backend_benchmark+0x7369>
 18ae96e:	48 85 ff             	test   %rdi,%rdi
 18ae971:	0f 84 48 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae977:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
 18ae97f:	48 83 38 00          	cmpq   $0x0,(%rax)
 18ae983:	0f 84 36 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae989:	41 0f b6 82 ec 02 00 00 	movzbl 0x2ec(%r10),%eax
 18ae991:	3c 01                	cmp    $0x1,%al
 18ae993:	75 09                	jne    18ae99e <run_backend_benchmark+0x737e>
 18ae995:	48 85 d2             	test   %rdx,%rdx
 18ae998:	0f 84 21 20 00 00    	je     18b09bf <run_backend_benchmark+0x939f>
 18ae99e:	48 89 9c 24 10 01 00 00 	mov    %rbx,0x110(%rsp)
 18ae9a6:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
 18ae9ab:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 18ae9b3:	84 c0                	test   %al,%al
 18ae9b5:	74 62                	je     18aea19 <run_backend_benchmark+0x73f9>
 18ae9b7:	c6 02 00             	movb   $0x0,(%rdx)
 18ae9ba:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 18ae9c2:	48 8b bb 10 3a 00 00 	mov    0x3a10(%rbx),%rdi
 18ae9c9:	41 8b 92 e4 02 00 00 	mov    0x2e4(%r10),%edx
 18ae9d0:	48 ff c7             	inc    %rdi
 18ae9d3:	c5 f8 77             	vzeroupper
 18ae9d6:	e8 75 5a eb fe       	call   764450 <memcpy@plt>
 18ae9db:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18ae9e3:	48 8b 83 10 3a 00 00 	mov    0x3a10(%rbx),%rax
 18ae9ea:	4c 89 f2             	mov    %r14,%rdx
 18ae9ed:	8b 89 e4 02 00 00    	mov    0x2e4(%rcx),%ecx
 18ae9f3:	48 8d 7c 08 01       	lea    0x1(%rax,%rcx,1),%rdi
 18ae9f8:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18aea00:	48 8d b1 2d 03 00 00 	lea    0x32d(%rcx),%rsi
 18aea07:	e8 44 5a eb fe       	call   764450 <memcpy@plt>
 18aea0c:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18aea11:	4c 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%r10
 18aea19:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18aea1f:	45 85 f6             	test   %r14d,%r14d
 18aea22:	0f 84 52 01 00 00    	je     18aeb7a <run_backend_benchmark+0x755a>
 18aea28:	49 8d 8a 70 03 00 00 	lea    0x370(%r10),%rcx
 18aea2f:	31 c0                	xor    %eax,%eax
 18aea31:	31 d2                	xor    %edx,%edx
 18aea33:	eb 1c                	jmp    18aea51 <run_backend_benchmark+0x7431>
 18aea35:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18aea40:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18aea45:	48 ff c2             	inc    %rdx
 18aea48:	4c 39 f2             	cmp    %r14,%rdx
 18aea4b:	0f 84 2b 01 00 00    	je     18aeb7c <run_backend_benchmark+0x755c>
 18aea51:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18aea57:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
 18aea5b:	48 8d 34 f9          	lea    (%rcx,%rdi,8),%rsi
 18aea5f:	74 2f                	je     18aea90 <run_backend_benchmark+0x7470>
 18aea61:	44 0f b6 46 1d       	movzbl 0x1d(%rsi),%r8d
 18aea66:	49 81 f8 ff 00 00 00 	cmp    $0xff,%r8
 18aea6d:	74 21                	je     18aea90 <run_backend_benchmark+0x7470>
 18aea6f:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 18aea74:	4d 6b c0 74          	imul   $0x74,%r8,%r8
 18aea78:	4f 8d 44 01 68       	lea    0x68(%r9,%r8,1),%r8
 18aea7d:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18aea82:	eb 20                	jmp    18aeaa4 <run_backend_benchmark+0x7484>
 18aea84:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18aea90:	44 8b 46 1c          	mov    0x1c(%rsi),%r8d
 18aea94:	41 80 f8 0e          	cmp    $0xe,%r8b
 18aea98:	45 0f 43 c3          	cmovae %r11d,%r8d
 18aea9c:	45 0f b6 c0          	movzbl %r8b,%r8d
 18aeaa0:	4f 8d 04 87          	lea    (%r15,%r8,4),%r8
 18aeaa4:	45 8b 00             	mov    (%r8),%r8d
 18aeaa7:	0f b6 7c f9 1e       	movzbl 0x1e(%rcx,%rdi,8),%edi
 18aeaac:	45 89 04 91          	mov    %r8d,(%r9,%rdx,4)
 18aeab0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18aeab5:	44 8b 46 10          	mov    0x10(%rsi),%r8d
 18aeab9:	41 29 f8             	sub    %edi,%r8d
 18aeabc:	45 89 04 91          	mov    %r8d,(%r9,%rdx,4)
 18aeac0:	4c 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%r9
 18aeac8:	41 c6 04 11 00       	movb   $0x0,(%r9,%rdx,1)
 18aeacd:	39 7e 10             	cmp    %edi,0x10(%rsi)
 18aead0:	0f 86 6a ff ff ff    	jbe    18aea40 <run_backend_benchmark+0x7420>
 18aead6:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18aeadc:	75 73                	jne    18aeb51 <run_backend_benchmark+0x7531>
 18aeade:	eb 1d                	jmp    18aeafd <run_backend_benchmark+0x74dd>
 18aeae0:	45 0f b6 c0          	movzbl %r8b,%r8d
 18aeae4:	41 89 c1             	mov    %eax,%r9d
 18aeae7:	ff c0                	inc    %eax
 18aeae9:	ff c7                	inc    %edi
 18aeaeb:	47 8b 04 87          	mov    (%r15,%r8,4),%r8d
 18aeaef:	47 89 44 8d 00       	mov    %r8d,0x0(%r13,%r9,4)
 18aeaf4:	3b 7e 10             	cmp    0x10(%rsi),%edi
 18aeaf7:	0f 83 43 ff ff ff    	jae    18aea40 <run_backend_benchmark+0x7420>
 18aeafd:	44 8b 46 08          	mov    0x8(%rsi),%r8d
 18aeb01:	4d 8b 4a 20          	mov    0x20(%r10),%r9
 18aeb05:	41 01 f8             	add    %edi,%r8d
 18aeb08:	47 0f b6 04 01       	movzbl (%r9,%r8,1),%r8d
 18aeb0d:	41 80 f8 0e          	cmp    $0xe,%r8b
 18aeb11:	72 cd                	jb     18aeae0 <run_backend_benchmark+0x74c0>
 18aeb13:	45 31 c0             	xor    %r8d,%r8d
 18aeb16:	eb c8                	jmp    18aeae0 <run_backend_benchmark+0x74c0>
 18aeb18:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18aeb20:	4d 8b 4a 20          	mov    0x20(%r10),%r9
 18aeb24:	47 0f b6 04 01       	movzbl (%r9,%r8,1),%r8d
 18aeb29:	41 80 f8 0e          	cmp    $0xe,%r8b
 18aeb2d:	45 0f 43 c3          	cmovae %r11d,%r8d
 18aeb31:	45 0f b6 c0          	movzbl %r8b,%r8d
 18aeb35:	4f 8d 04 87          	lea    (%r15,%r8,4),%r8
 18aeb39:	45 8b 00             	mov    (%r8),%r8d
 18aeb3c:	41 89 c1             	mov    %eax,%r9d
 18aeb3f:	ff c0                	inc    %eax
 18aeb41:	ff c7                	inc    %edi
 18aeb43:	47 89 44 8d 00       	mov    %r8d,0x0(%r13,%r9,4)
 18aeb48:	3b 7e 10             	cmp    0x10(%rsi),%edi
 18aeb4b:	0f 83 ef fe ff ff    	jae    18aea40 <run_backend_benchmark+0x7420>
 18aeb51:	44 8b 46 08          	mov    0x8(%rsi),%r8d
 18aeb55:	4d 8b 4a 40          	mov    0x40(%r10),%r9
 18aeb59:	41 01 f8             	add    %edi,%r8d
 18aeb5c:	47 0f b6 0c 01       	movzbl (%r9,%r8,1),%r9d
 18aeb61:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 18aeb68:	74 b6                	je     18aeb20 <run_backend_benchmark+0x7500>
 18aeb6a:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 18aeb6f:	4d 6b c1 74          	imul   $0x74,%r9,%r8
 18aeb73:	4f 8d 44 04 68       	lea    0x68(%r12,%r8,1),%r8
 18aeb78:	eb bf                	jmp    18aeb39 <run_backend_benchmark+0x7519>
 18aeb7a:	31 c0                	xor    %eax,%eax
 18aeb7c:	41 83 7a 78 00       	cmpl   $0x0,0x78(%r10)
 18aeb81:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18aeb86:	0f 84 19 02 00 00    	je     18aeda5 <run_backend_benchmark+0x7785>
 18aeb8c:	49 8d 8a 70 03 00 00 	lea    0x370(%r10),%rcx
 18aeb93:	31 d2                	xor    %edx,%edx
 18aeb95:	eb 40                	jmp    18aebd7 <run_backend_benchmark+0x75b7>
 18aeb97:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18aeba0:	49 8b 7a 50          	mov    0x50(%r10),%rdi
 18aeba4:	41 8b b2 e4 02 00 00 	mov    0x2e4(%r10),%esi
 18aebab:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 18aebae:	8d 74 3e 01          	lea    0x1(%rsi,%rdi,1),%esi
 18aebb2:	48 8b bb 08 3a 00 00 	mov    0x3a08(%rbx),%rdi
 18aebb9:	89 34 97             	mov    %esi,(%rdi,%rdx,4)
 18aebbc:	48 8b b3 40 3a 00 00 	mov    0x3a40(%rbx),%rsi
 18aebc3:	c6 04 16 00          	movb   $0x0,(%rsi,%rdx,1)
 18aebc7:	48 ff c2             	inc    %rdx
 18aebca:	41 8b 72 78          	mov    0x78(%r10),%esi
 18aebce:	48 39 f2             	cmp    %rsi,%rdx
 18aebd1:	0f 83 ce 01 00 00    	jae    18aeda5 <run_backend_benchmark+0x7785>
 18aebd7:	49 8b 72 50          	mov    0x50(%r10),%rsi
 18aebdb:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18aebe1:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 18aebe4:	48 8d 34 b6          	lea    (%rsi,%rsi,4),%rsi
 18aebe8:	48 8d 34 f1          	lea    (%rcx,%rsi,8),%rsi
 18aebec:	74 22                	je     18aec10 <run_backend_benchmark+0x75f0>
 18aebee:	0f b6 7e 1d          	movzbl 0x1d(%rsi),%edi
 18aebf2:	48 81 ff ff 00 00 00 	cmp    $0xff,%rdi
 18aebf9:	74 15                	je     18aec10 <run_backend_benchmark+0x75f0>
 18aebfb:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 18aec00:	48 6b f7 74          	imul   $0x74,%rdi,%rsi
 18aec04:	49 8d 74 34 68       	lea    0x68(%r12,%rsi,1),%rsi
 18aec09:	eb 18                	jmp    18aec23 <run_backend_benchmark+0x7603>
 18aec0b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18aec10:	8b 76 1c             	mov    0x1c(%rsi),%esi
 18aec13:	40 80 fe 0e          	cmp    $0xe,%sil
 18aec17:	41 0f 43 f3          	cmovae %r11d,%esi
 18aec1b:	40 0f b6 f6          	movzbl %sil,%esi
 18aec1f:	49 8d 34 b7          	lea    (%r15,%rsi,4),%rsi
 18aec23:	8b 36                	mov    (%rsi),%esi
 18aec25:	41 8d 3c 16          	lea    (%r14,%rdx,1),%edi
 18aec29:	4c 8b a4 24 a0 00 00 00 	mov    0xa0(%rsp),%r12
 18aec31:	41 89 34 b9          	mov    %esi,(%r9,%rdi,4)
 18aec35:	49 8b 72 60          	mov    0x60(%r10),%rsi
 18aec39:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 18aec3c:	41 89 34 b8          	mov    %esi,(%r8,%rdi,4)
 18aec40:	41 c6 04 3c 00       	movb   $0x0,(%r12,%rdi,1)
 18aec45:	49 8b 72 60          	mov    0x60(%r10),%rsi
 18aec49:	83 3c 96 00          	cmpl   $0x0,(%rsi,%rdx,4)
 18aec4d:	0f 84 c1 00 00 00    	je     18aed14 <run_backend_benchmark+0x76f4>
 18aec53:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18aec59:	0f 84 e1 00 00 00    	je     18aed40 <run_backend_benchmark+0x7720>
 18aec5f:	31 f6                	xor    %esi,%esi
 18aec61:	eb 45                	jmp    18aeca8 <run_backend_benchmark+0x7688>
 18aec63:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18aec70:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 18aec75:	4d 6b c9 74          	imul   $0x74,%r9,%r9
 18aec79:	4d 89 d6             	mov    %r10,%r14
 18aec7c:	47 8b 54 0c 68       	mov    0x68(%r12,%r9,1),%r10d
 18aec81:	47 89 54 85 00       	mov    %r10d,0x0(%r13,%r8,4)
 18aec86:	47 8b 4c 0c 5c       	mov    0x5c(%r12,%r9,1),%r9d
 18aec8b:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 18aec93:	ff c6                	inc    %esi
 18aec95:	4d 89 f2             	mov    %r14,%r10
 18aec98:	4d 8b 00             	mov    (%r8),%r8
 18aec9b:	45 89 0c b8          	mov    %r9d,(%r8,%rdi,4)
 18aec9f:	49 8b 7e 60          	mov    0x60(%r14),%rdi
 18aeca3:	3b 34 97             	cmp    (%rdi,%rdx,4),%esi
 18aeca6:	73 58                	jae    18aed00 <run_backend_benchmark+0x76e0>
 18aeca8:	49 8b 7a 58          	mov    0x58(%r10),%rdi
 18aecac:	4d 8b 8a 88 00 00 00 	mov    0x88(%r10),%r9
 18aecb3:	44 8d 04 30          	lea    (%rax,%rsi,1),%r8d
 18aecb7:	45 89 c0             	mov    %r8d,%r8d
 18aecba:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 18aecbd:	01 f7                	add    %esi,%edi
 18aecbf:	45 0f b6 0c 39       	movzbl (%r9,%rdi,1),%r9d
 18aecc4:	49 81 f9 ff 00 00 00 	cmp    $0xff,%r9
 18aeccb:	75 a3                	jne    18aec70 <run_backend_benchmark+0x7650>
 18aeccd:	4d 8b 8a 80 00 00 00 	mov    0x80(%r10),%r9
 18aecd4:	4d 89 d6             	mov    %r10,%r14
 18aecd7:	45 0f b6 14 39       	movzbl (%r9,%rdi,1),%r10d
 18aecdc:	45 31 c9             	xor    %r9d,%r9d
 18aecdf:	41 80 fa 0e          	cmp    $0xe,%r10b
 18aece3:	45 0f 43 d1          	cmovae %r9d,%r10d
 18aece7:	45 0f b6 d2          	movzbl %r10b,%r10d
 18aeceb:	47 8b 14 97          	mov    (%r15,%r10,4),%r10d
 18aecef:	47 89 54 85 00       	mov    %r10d,0x0(%r13,%r8,4)
 18aecf4:	eb 95                	jmp    18aec8b <run_backend_benchmark+0x766b>
 18aecf6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18aed00:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 18aed08:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18aed0d:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 18aed12:	01 f0                	add    %esi,%eax
 18aed14:	49 8b 7a 68          	mov    0x68(%r10),%rdi
 18aed18:	48 85 ff             	test   %rdi,%rdi
 18aed1b:	0f 84 7f fe ff ff    	je     18aeba0 <run_backend_benchmark+0x7580>
 18aed21:	31 f6                	xor    %esi,%esi
 18aed23:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
 18aed27:	0f 85 85 fe ff ff    	jne    18aebb2 <run_backend_benchmark+0x7592>
 18aed2d:	e9 6e fe ff ff       	jmp    18aeba0 <run_backend_benchmark+0x7580>
 18aed32:	66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18aed40:	31 f6                	xor    %esi,%esi
 18aed42:	eb 28                	jmp    18aed6c <run_backend_benchmark+0x774c>
 18aed44:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18aed50:	40 0f b6 ff          	movzbl %dil,%edi
 18aed54:	44 8d 04 30          	lea    (%rax,%rsi,1),%r8d
 18aed58:	ff c6                	inc    %esi
 18aed5a:	41 8b 3c bf          	mov    (%r15,%rdi,4),%edi
 18aed5e:	43 89 7c 85 00       	mov    %edi,0x0(%r13,%r8,4)
 18aed63:	49 8b 7a 60          	mov    0x60(%r10),%rdi
 18aed67:	3b 34 97             	cmp    (%rdi,%rdx,4),%esi
 18aed6a:	73 24                	jae    18aed90 <run_backend_benchmark+0x7770>
 18aed6c:	49 8b 7a 58          	mov    0x58(%r10),%rdi
 18aed70:	4d 8b 82 80 00 00 00 	mov    0x80(%r10),%r8
 18aed77:	8b 3c 97             	mov    (%rdi,%rdx,4),%edi
 18aed7a:	01 f7                	add    %esi,%edi
 18aed7c:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
 18aed81:	40 80 ff 0e          	cmp    $0xe,%dil
 18aed85:	72 c9                	jb     18aed50 <run_backend_benchmark+0x7730>
 18aed87:	31 ff                	xor    %edi,%edi
 18aed89:	eb c5                	jmp    18aed50 <run_backend_benchmark+0x7730>
 18aed8b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18aed90:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18aed95:	01 f0                	add    %esi,%eax
 18aed97:	49 8b 7a 68          	mov    0x68(%r10),%rdi
 18aed9b:	48 85 ff             	test   %rdi,%rdi
 18aed9e:	75 81                	jne    18aed21 <run_backend_benchmark+0x7701>
 18aeda0:	e9 fb fd ff ff       	jmp    18aeba0 <run_backend_benchmark+0x7580>
 18aeda5:	64 48 8b 34 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%rsi
 18aedae:	48 85 f6             	test   %rsi,%rsi
 18aedb1:	74 36                	je     18aede9 <run_backend_benchmark+0x77c9>
 18aedb3:	64 48 8b 14 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rdx
 18aedbc:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18aedc1:	4c 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%r9
 18aedc9:	45 89 cb             	mov    %r9d,%r11d
 18aedcc:	45 85 c9             	test   %r9d,%r9d
 18aedcf:	0f 84 0a 02 00 00    	je     18aefdf <run_backend_benchmark+0x79bf>
 18aedd5:	41 83 f9 08          	cmp    $0x8,%r9d
 18aedd9:	0f 83 93 00 00 00    	jae    18aee72 <run_backend_benchmark+0x7852>
 18aeddf:	31 c0                	xor    %eax,%eax
 18aede1:	45 31 e4             	xor    %r12d,%r12d
 18aede4:	e9 97 01 00 00       	jmp    18aef80 <run_backend_benchmark+0x7960>
 18aede9:	49 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r14
 18aedf3:	ba 03 00 00 00       	mov    $0x3,%edx
 18aedf8:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18aedfd:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18aee03:	31 ff                	xor    %edi,%edi
 18aee05:	45 31 c9             	xor    %r9d,%r9d
 18aee08:	4c 89 f6             	mov    %r14,%rsi
 18aee0b:	c5 f8 77             	vzeroupper
 18aee0e:	e8 2d 57 eb fe       	call   764540 <mmap@plt>
 18aee13:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18aee17:	0f 84 74 01 00 00    	je     18aef91 <run_backend_benchmark+0x7971>
 18aee1d:	4c 8d b8 ff ff 20 00 	lea    0x20ffff(%rax),%r15
 18aee24:	ba 0f 00 00 00       	mov    $0xf,%edx
 18aee29:	48 89 c7             	mov    %rax,%rdi
 18aee2c:	49 81 e7 00 00 e0 ff 	and    $0xffffffffffe00000,%r15
 18aee33:	4d 89 fc             	mov    %r15,%r12
 18aee36:	49 29 c4             	sub    %rax,%r12
 18aee39:	4c 89 e6             	mov    %r12,%rsi
 18aee3c:	49 8d 9c 24 00 00 ff ff 	lea    -0x10000(%r12),%rbx
 18aee44:	e8 a7 56 eb fe       	call   7644f0 <madvise@plt>
 18aee49:	4c 89 f6             	mov    %r14,%rsi
 18aee4c:	4c 29 e6             	sub    %r12,%rsi
 18aee4f:	ba 0e 00 00 00       	mov    $0xe,%edx
 18aee54:	4c 89 ff             	mov    %r15,%rdi
 18aee57:	e8 94 56 eb fe       	call   7644f0 <madvise@plt>
 18aee5c:	4c 89 fe             	mov    %r15,%rsi
 18aee5f:	48 81 c6 00 00 ff ff 	add    $0xffffffffffff0000,%rsi
 18aee66:	49 8d 86 00 00 e0 ff 	lea    -0x200000(%r14),%rax
 18aee6d:	e9 25 01 00 00       	jmp    18aef97 <run_backend_benchmark+0x7977>
 18aee72:	41 83 f9 20          	cmp    $0x20,%r9d
 18aee76:	73 0a                	jae    18aee82 <run_backend_benchmark+0x7862>
 18aee78:	31 c0                	xor    %eax,%eax
 18aee7a:	45 31 e4             	xor    %r12d,%r12d
 18aee7d:	e9 a4 00 00 00       	jmp    18aef26 <run_backend_benchmark+0x7906>
 18aee82:	44 89 d8             	mov    %r11d,%eax
 18aee85:	83 e0 e0             	and    $0xffffffe0,%eax
 18aee88:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18aee8c:	31 c9                	xor    %ecx,%ecx
 18aee8e:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18aee92:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18aee96:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18aee9a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18aeea0:	62 d2 7d 48 35 6c 88 01 	vpmovzxdq 0x20(%r8,%rcx,4),%zmm5
 18aeea8:	62 d2 7d 48 35 24 88 	vpmovzxdq (%r8,%rcx,4),%zmm4
 18aeeaf:	62 d2 7d 48 35 74 88 02 	vpmovzxdq 0x40(%r8,%rcx,4),%zmm6
 18aeeb7:	62 f1 f5 48 d4 cd    	vpaddq %zmm5,%zmm1,%zmm1
 18aeebd:	62 d2 7d 48 35 6c 88 03 	vpmovzxdq 0x60(%r8,%rcx,4),%zmm5
 18aeec5:	62 f1 fd 48 d4 c4    	vpaddq %zmm4,%zmm0,%zmm0
 18aeecb:	62 f1 ed 48 d4 d6    	vpaddq %zmm6,%zmm2,%zmm2
 18aeed1:	48 83 c1 20          	add    $0x20,%rcx
 18aeed5:	62 f1 e5 48 d4 dd    	vpaddq %zmm5,%zmm3,%zmm3
 18aeedb:	48 39 c8             	cmp    %rcx,%rax
 18aeede:	75 c0                	jne    18aeea0 <run_backend_benchmark+0x7880>
 18aeee0:	62 f1 f5 48 d4 c0    	vpaddq %zmm0,%zmm1,%zmm0
 18aeee6:	62 f1 ed 48 d4 c0    	vpaddq %zmm0,%zmm2,%zmm0
 18aeeec:	62 f1 e5 48 d4 c0    	vpaddq %zmm0,%zmm3,%zmm0
 18aeef2:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 18aeef9:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 18aeeff:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 18aef05:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 18aef09:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 18aef0e:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 18aef12:	c4 c1 f9 7e c4       	vmovq  %xmm0,%r12
 18aef17:	44 39 d8             	cmp    %r11d,%eax
 18aef1a:	0f 84 c2 00 00 00    	je     18aefe2 <run_backend_benchmark+0x79c2>
 18aef20:	41 f6 c3 18          	test   $0x18,%r11b
 18aef24:	74 5a                	je     18aef80 <run_backend_benchmark+0x7960>
 18aef26:	48 89 c1             	mov    %rax,%rcx
 18aef29:	44 89 d8             	mov    %r11d,%eax
 18aef2c:	83 e0 f8             	and    $0xfffffff8,%eax
 18aef2f:	c4 c1 f9 6e c4       	vmovq  %r12,%xmm0
 18aef34:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18aef40:	62 d2 7d 48 35 0c 88 	vpmovzxdq (%r8,%rcx,4),%zmm1
 18aef47:	48 83 c1 08          	add    $0x8,%rcx
 18aef4b:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 18aef51:	48 39 c8             	cmp    %rcx,%rax
 18aef54:	75 ea                	jne    18aef40 <run_backend_benchmark+0x7920>
 18aef56:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 18aef5d:	62 f1 fd 48 d4 c1    	vpaddq %zmm1,%zmm0,%zmm0
 18aef63:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 18aef69:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 18aef6d:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 18aef72:	c5 f9 d4 c1          	vpaddq %xmm1,%xmm0,%xmm0
 18aef76:	c4 c1 f9 7e c4       	vmovq  %xmm0,%r12
 18aef7b:	44 39 d8             	cmp    %r11d,%eax
 18aef7e:	74 62                	je     18aefe2 <run_backend_benchmark+0x79c2>
 18aef80:	41 8b 0c 80          	mov    (%r8,%rax,4),%ecx
 18aef84:	48 ff c0             	inc    %rax
 18aef87:	49 01 cc             	add    %rcx,%r12
 18aef8a:	49 39 c3             	cmp    %rax,%r11
 18aef8d:	75 f1                	jne    18aef80 <run_backend_benchmark+0x7960>
 18aef8f:	eb 51                	jmp    18aefe2 <run_backend_benchmark+0x79c2>
 18aef91:	31 f6                	xor    %esi,%esi
 18aef93:	31 c0                	xor    %eax,%eax
 18aef95:	31 db                	xor    %ebx,%ebx
 18aef97:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18aef9c:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18aefa1:	4c 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%r9
 18aefa9:	64 48 89 34 25 10 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff10
 18aefb2:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18aefbf:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 18aefc8:	31 d2                	xor    %edx,%edx
 18aefca:	64 48 89 1c 25 28 ff ff ff 	mov    %rbx,%fs:0xffffffffffffff28
 18aefd3:	45 89 cb             	mov    %r9d,%r11d
 18aefd6:	45 85 c9             	test   %r9d,%r9d
 18aefd9:	0f 85 f6 fd ff ff    	jne    18aedd5 <run_backend_benchmark+0x77b5>
 18aefdf:	45 31 e4             	xor    %r12d,%r12d
 18aefe2:	48 8d 4c 32 3f       	lea    0x3f(%rdx,%rsi,1),%rcx
 18aefe7:	48 8d 04 32          	lea    (%rdx,%rsi,1),%rax
 18aefeb:	48 89 94 24 50 01 00 00 	mov    %rdx,0x150(%rsp)
 18aeff3:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18aeff7:	48 39 c1             	cmp    %rax,%rcx
 18aeffa:	0f 83 9c 09 00 00    	jae    18af99c <run_backend_benchmark+0x837c>
 18af000:	48 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%rdx
 18af008:	48 8d 8c 24 80 0e 00 00 	lea    0xe80(%rsp),%rcx
 18af010:	45 85 c9             	test   %r9d,%r9d
 18af013:	0f 84 9c 00 00 00    	je     18af0b5 <run_backend_benchmark+0x7a95>
 18af019:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18af01e:	45 31 f6             	xor    %r14d,%r14d
 18af021:	45 31 ff             	xor    %r15d,%r15d
 18af024:	4c 89 9c 24 d0 00 00 00 	mov    %r11,0xd0(%rsp)
 18af02c:	4c 89 ac 24 c0 00 00 00 	mov    %r13,0xc0(%rsp)
 18af034:	48 8d 58 08          	lea    0x8(%rax),%rbx
 18af038:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18af040:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 18af045:	47 8b 24 b0          	mov    (%r8,%r14,4),%r12d
 18af049:	45 31 c0             	xor    %r8d,%r8d
 18af04c:	42 80 3c 32 00       	cmpb   $0x0,(%rdx,%r14,1)
 18af051:	4b 8d 74 bd 00       	lea    0x0(%r13,%r15,4),%rsi
 18af056:	49 89 cd             	mov    %rcx,%r13
 18af059:	48 89 cf             	mov    %rcx,%rdi
 18af05c:	46 8b 0c b0          	mov    (%rax,%r14,4),%r9d
 18af060:	4b 8d 04 fa          	lea    (%r10,%r15,8),%rax
 18af064:	41 0f 95 c0          	setne  %r8b
 18af068:	44 89 e2             	mov    %r12d,%edx
 18af06b:	44 89 e1             	mov    %r12d,%ecx
 18af06e:	48 89 04 24          	mov    %rax,(%rsp)
 18af072:	c5 f8 77             	vzeroupper
 18af075:	e8 96 bb 02 00       	call   18dac10 <abi_assign_call>
 18af07a:	4c 89 e9             	mov    %r13,%rcx
 18af07d:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
 18af081:	48 89 13             	mov    %rdx,(%rbx)
 18af084:	4c 8b 9c 24 d0 00 00 00 	mov    0xd0(%rsp),%r11
 18af08c:	4c 8b ac 24 c0 00 00 00 	mov    0xc0(%rsp),%r13
 18af094:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18af099:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18af09e:	48 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%rdx
 18af0a6:	4d 01 e7             	add    %r12,%r15
 18af0a9:	49 ff c6             	inc    %r14
 18af0ac:	48 83 c3 10          	add    $0x10,%rbx
 18af0b0:	4d 39 f3             	cmp    %r14,%r11
 18af0b3:	75 8b                	jne    18af040 <run_backend_benchmark+0x7a20>
 18af0b5:	48 8b 8c 24 50 01 00 00 	mov    0x150(%rsp),%rcx
 18af0bd:	64 48 3b 0c 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rcx
 18af0c6:	0f 87 fd 26 00 00    	ja     18b17c9 <run_backend_benchmark+0xa1a9>
 18af0cc:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18af0d4:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18af0dd:	8b 8c 24 58 01 00 00 	mov    0x158(%rsp),%ecx
 18af0e4:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18af0e9:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18af0ee:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18af0f6:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 18af0fa:	48 89 d0             	mov    %rdx,%rax
 18af0fd:	48 c1 e0 04          	shl    $0x4,%rax
 18af101:	49 8d 0c ca          	lea    (%r10,%rcx,8),%rcx
 18af105:	4c 01 c0             	add    %r8,%rax
 18af108:	49 89 8b 28 3a 00 00 	mov    %rcx,0x3a28(%r11)
 18af10f:	49 89 83 38 3a 00 00 	mov    %rax,0x3a38(%r11)
 18af116:	85 d2                	test   %edx,%edx
 18af118:	0f 84 3c 0a 00 00    	je     18afb5a <run_backend_benchmark+0x853a>
 18af11e:	4c 8d a7 70 03 00 00 	lea    0x370(%rdi),%r12
 18af125:	45 31 c9             	xor    %r9d,%r9d
 18af128:	45 31 ed             	xor    %r13d,%r13d
 18af12b:	c7 44 24 60 00 00 00 00 	movl   $0x0,0x60(%rsp)
 18af133:	4c 89 a4 24 c0 00 00 00 	mov    %r12,0xc0(%rsp)
 18af13b:	e9 e1 00 00 00       	jmp    18af221 <run_backend_benchmark+0x7c01>
 18af140:	89 93 b0 00 00 00    	mov    %edx,0xb0(%rbx)
 18af146:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18af14e:	48 8b 12             	mov    (%rdx),%rdx
 18af151:	48 89 93 a0 00 00 00 	mov    %rdx,0xa0(%rbx)
 18af158:	41 8b 56 14          	mov    0x14(%r14),%edx
 18af15c:	48 c1 e2 02          	shl    $0x2,%rdx
 18af160:	48 03 57 70          	add    0x70(%rdi),%rdx
 18af164:	41 29 cd             	sub    %ecx,%r13d
 18af167:	48 89 93 a8 00 00 00 	mov    %rdx,0xa8(%rbx)
 18af16e:	49 ff c1             	inc    %r9
 18af171:	41 01 c5             	add    %eax,%r13d
 18af174:	41 8b 46 14          	mov    0x14(%r14),%eax
 18af178:	48 c1 e0 02          	shl    $0x2,%rax
 18af17c:	49 03 83 08 3a 00 00 	add    0x3a08(%r11),%rax
 18af183:	48 89 43 48          	mov    %rax,0x48(%rbx)
 18af187:	41 8b 46 14          	mov    0x14(%r14),%eax
 18af18b:	48 c1 e0 02          	shl    $0x2,%rax
 18af18f:	48 03 47 58          	add    0x58(%rdi),%rax
 18af193:	48 89 43 50          	mov    %rax,0x50(%rbx)
 18af197:	41 8b 46 14          	mov    0x14(%r14),%eax
 18af19b:	48 c1 e0 02          	shl    $0x2,%rax
 18af19f:	48 03 47 60          	add    0x60(%rdi),%rax
 18af1a3:	48 89 43 58          	mov    %rax,0x58(%rbx)
 18af1a7:	41 8b 46 14          	mov    0x14(%r14),%eax
 18af1ab:	49 03 83 40 3a 00 00 	add    0x3a40(%r11),%rax
 18af1b2:	48 89 43 60          	mov    %rax,0x60(%rbx)
 18af1b6:	41 8b 46 14          	mov    0x14(%r14),%eax
 18af1ba:	48 c1 e0 04          	shl    $0x4,%rax
 18af1be:	49 03 83 38 3a 00 00 	add    0x3a38(%r11),%rax
 18af1c5:	48 89 43 68          	mov    %rax,0x68(%rbx)
 18af1c9:	49 8b 83 28 3a 00 00 	mov    0x3a28(%r11),%rax
 18af1d0:	48 89 43 70          	mov    %rax,0x70(%rbx)
 18af1d4:	48 8b 87 80 00 00 00 	mov    0x80(%rdi),%rax
 18af1db:	48 89 43 78          	mov    %rax,0x78(%rbx)
 18af1df:	41 8b 46 18          	mov    0x18(%r14),%eax
 18af1e3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
 18af1e9:	8b 87 90 00 00 00    	mov    0x90(%rdi),%eax
 18af1ef:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
 18af1f5:	49 8b 83 10 3a 00 00 	mov    0x3a10(%r11),%rax
 18af1fc:	48 89 83 b8 00 00 00 	mov    %rax,0xb8(%rbx)
 18af203:	41 8b 83 18 3a 00 00 	mov    0x3a18(%r11),%eax
 18af20a:	89 83 c0 00 00 00    	mov    %eax,0xc0(%rbx)
 18af210:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18af218:	49 39 c1             	cmp    %rax,%r9
 18af21b:	0f 84 e0 03 00 00    	je     18af601 <run_backend_benchmark+0x7fe1>
 18af221:	49 69 c9 e8 00 00 00 	imul   $0xe8,%r9,%rcx
 18af228:	4b 8d 04 89          	lea    (%r9,%r9,4),%rax
 18af22c:	4d 8d 34 c4          	lea    (%r12,%rax,8),%r14
 18af230:	62 d1 fe 48 7f a4 0b a8 00 00 00 	vmovdqu64 %zmm4,0xa8(%r11,%rcx,1)
 18af23b:	62 d1 fe 48 7f 64 0b 02 	vmovdqu64 %zmm4,0x80(%r11,%rcx,1)
 18af243:	62 d1 fe 48 7f 64 0b 01 	vmovdqu64 %zmm4,0x40(%r11,%rcx,1)
 18af24b:	62 d1 fe 48 7f 24 0b 	vmovdqu64 %zmm4,(%r11,%rcx,1)
 18af252:	49 8d 1c 0b          	lea    (%r11,%rcx,1),%rbx
 18af256:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 18af25a:	48 03 17             	add    (%rdi),%rdx
 18af25d:	49 89 14 0b          	mov    %rdx,(%r11,%rcx,1)
 18af261:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 18af265:	48 03 57 08          	add    0x8(%rdi),%rdx
 18af269:	49 89 54 0b 08       	mov    %rdx,0x8(%r11,%rcx,1)
 18af26e:	41 8b 14 c4          	mov    (%r12,%rax,8),%edx
 18af272:	48 c1 e2 03          	shl    $0x3,%rdx
 18af276:	48 03 57 10          	add    0x10(%rdi),%rdx
 18af27a:	49 89 54 0b 10       	mov    %rdx,0x10(%r11,%rcx,1)
 18af27f:	41 8b 54 c4 04       	mov    0x4(%r12,%rax,8),%edx
 18af284:	41 89 54 0b 18       	mov    %edx,0x18(%r11,%rcx,1)
 18af289:	41 8b 54 c4 08       	mov    0x8(%r12,%rax,8),%edx
 18af28e:	48 03 57 20          	add    0x20(%rdi),%rdx
 18af292:	49 89 54 0b 20       	mov    %rdx,0x20(%r11,%rcx,1)
 18af297:	41 8b 54 c4 08       	mov    0x8(%r12,%rax,8),%edx
 18af29c:	48 03 57 28          	add    0x28(%rdi),%rdx
 18af2a0:	49 89 54 0b 28       	mov    %rdx,0x28(%r11,%rcx,1)
 18af2a5:	41 8b 4c c4 0c       	mov    0xc(%r12,%rax,8),%ecx
 18af2aa:	48 85 c9             	test   %rcx,%rcx
 18af2ad:	0f 84 0d 01 00 00    	je     18af3c0 <run_backend_benchmark+0x7da0>
 18af2b3:	48 8b 47 30          	mov    0x30(%rdi),%rax
 18af2b7:	48 85 c0             	test   %rax,%rax
 18af2ba:	0f 84 00 01 00 00    	je     18af3c0 <run_backend_benchmark+0x7da0>
 18af2c0:	41 8b 56 08          	mov    0x8(%r14),%edx
 18af2c4:	83 f9 08             	cmp    $0x8,%ecx
 18af2c7:	72 1d                	jb     18af2e6 <run_backend_benchmark+0x7cc6>
 18af2c9:	48 8d 71 ff          	lea    -0x1(%rcx),%rsi
 18af2cd:	89 d7                	mov    %edx,%edi
 18af2cf:	01 f7                	add    %esi,%edi
 18af2d1:	40 0f 92 c7          	setb   %dil
 18af2d5:	48 c1 ee 20          	shr    $0x20,%rsi
 18af2d9:	40 0f 95 c6          	setne  %sil
 18af2dd:	40 08 fe             	or     %dil,%sil
 18af2e0:	0f 84 2b 02 00 00    	je     18af511 <run_backend_benchmark+0x7ef1>
 18af2e6:	4d 89 cf             	mov    %r9,%r15
 18af2e9:	31 f6                	xor    %esi,%esi
 18af2eb:	31 ff                	xor    %edi,%edi
 18af2ed:	49 89 c9             	mov    %rcx,%r9
 18af2f0:	49 83 e1 07          	and    $0x7,%r9
 18af2f4:	49 89 f0             	mov    %rsi,%r8
 18af2f7:	74 1f                	je     18af318 <run_backend_benchmark+0x7cf8>
 18af2f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 18af300:	46 8d 14 02          	lea    (%rdx,%r8,1),%r10d
 18af304:	42 83 3c 90 00       	cmpl   $0x0,(%rax,%r10,4)
 18af309:	41 0f 95 c2          	setne  %r10b
 18af30d:	49 ff c0             	inc    %r8
 18af310:	44 08 d7             	or     %r10b,%dil
 18af313:	49 ff c9             	dec    %r9
 18af316:	75 e8                	jne    18af300 <run_backend_benchmark+0x7ce0>
 18af318:	48 29 ce             	sub    %rcx,%rsi
 18af31b:	48 83 fe f8          	cmp    $0xfffffffffffffff8,%rsi
 18af31f:	77 65                	ja     18af386 <run_backend_benchmark+0x7d66>
 18af321:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18af330:	42 8d 74 02 01       	lea    0x1(%rdx,%r8,1),%esi
 18af335:	46 8d 0c 02          	lea    (%rdx,%r8,1),%r9d
 18af339:	46 8d 54 02 03       	lea    0x3(%rdx,%r8,1),%r10d
 18af33e:	8b 34 b0             	mov    (%rax,%rsi,4),%esi
 18af341:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 18af345:	46 8d 4c 02 02       	lea    0x2(%rdx,%r8,1),%r9d
 18af34a:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 18af34e:	46 8d 4c 02 04       	lea    0x4(%rdx,%r8,1),%r9d
 18af353:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 18af357:	46 8d 54 02 05       	lea    0x5(%rdx,%r8,1),%r10d
 18af35c:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 18af360:	46 8d 4c 02 06       	lea    0x6(%rdx,%r8,1),%r9d
 18af365:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 18af369:	46 8d 54 02 07       	lea    0x7(%rdx,%r8,1),%r10d
 18af36e:	42 0b 34 88          	or     (%rax,%r9,4),%esi
 18af372:	42 0b 34 90          	or     (%rax,%r10,4),%esi
 18af376:	40 0f 95 c6          	setne  %sil
 18af37a:	49 83 c0 08          	add    $0x8,%r8
 18af37e:	40 08 f7             	or     %sil,%dil
 18af381:	4c 39 c1             	cmp    %r8,%rcx
 18af384:	75 aa                	jne    18af330 <run_backend_benchmark+0x7d10>
 18af386:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18af38b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18af390:	4d 89 f9             	mov    %r15,%r9
 18af393:	40 f6 c7 01          	test   $0x1,%dil
 18af397:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18af39f:	74 1f                	je     18af3c0 <run_backend_benchmark+0x7da0>
 18af3a1:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 18af3a5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
 18af3ac:	41 8b 46 08          	mov    0x8(%r14),%eax
 18af3b0:	48 03 47 38          	add    0x38(%rdi),%rax
 18af3b4:	eb 17                	jmp    18af3cd <run_backend_benchmark+0x7dad>
 18af3b6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18af3c0:	31 c0                	xor    %eax,%eax
 18af3c2:	48 c7 83 88 00 00 00 00 00 00 00 	movq   $0x0,0x88(%rbx)
 18af3cd:	48 89 83 90 00 00 00 	mov    %rax,0x90(%rbx)
 18af3d4:	4d 89 cf             	mov    %r9,%r15
 18af3d7:	49 c1 e7 04          	shl    $0x4,%r15
 18af3db:	41 8b 46 0c          	mov    0xc(%r14),%eax
 18af3df:	89 43 30             	mov    %eax,0x30(%rbx)
 18af3e2:	41 8b 46 10          	mov    0x10(%r14),%eax
 18af3e6:	89 43 34             	mov    %eax,0x34(%rbx)
 18af3e9:	44 89 e8             	mov    %r13d,%eax
 18af3ec:	49 8d 34 c2          	lea    (%r10,%rax,8),%rsi
 18af3f0:	48 89 73 38          	mov    %rsi,0x38(%rbx)
 18af3f4:	4b 8b 44 38 08       	mov    0x8(%r8,%r15,1),%rax
 18af3f9:	48 89 43 40          	mov    %rax,0x40(%rbx)
 18af3fd:	41 80 7e 1e 00       	cmpb   $0x0,0x1e(%r14)
 18af402:	0f 84 d8 00 00 00    	je     18af4e0 <run_backend_benchmark+0x7ec0>
 18af408:	44 89 6c 24 30       	mov    %r13d,0x30(%rsp)
 18af40d:	44 8b 6c 24 60       	mov    0x60(%rsp),%r13d
 18af412:	49 8b 83 50 3a 00 00 	mov    0x3a50(%r11),%rax
 18af419:	4d 89 cc             	mov    %r9,%r12
 18af41c:	44 89 e9             	mov    %r13d,%ecx
 18af41f:	48 8d 14 c8          	lea    (%rax,%rcx,8),%rdx
 18af423:	48 8d 7c c8 08       	lea    0x8(%rax,%rcx,8),%rdi
 18af428:	48 89 94 24 a0 00 00 00 	mov    %rdx,0xa0(%rsp)
 18af430:	48 ba 00 00 00 00 07 ff 01 00 	movabs $0x1ff0700000000,%rdx
 18af43a:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
 18af43e:	41 8b 56 10          	mov    0x10(%r14),%edx
 18af442:	ff ca                	dec    %edx
 18af444:	48 c1 e2 03          	shl    $0x3,%rdx
 18af448:	c5 f8 77             	vzeroupper
 18af44b:	e8 00 50 eb fe       	call   764450 <memcpy@plt>
 18af450:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18af458:	4d 89 e1             	mov    %r12,%r9
 18af45b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18af460:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18af465:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18af46d:	4c 8b a4 24 c0 00 00 00 	mov    0xc0(%rsp),%r12
 18af475:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18af47a:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 18af47e:	48 89 43 38          	mov    %rax,0x38(%rbx)
 18af482:	41 8b 46 10          	mov    0x10(%r14),%eax
 18af486:	41 0f b6 4e 1e       	movzbl 0x1e(%r14),%ecx
 18af48b:	41 01 c5             	add    %eax,%r13d
 18af48e:	44 89 6c 24 60       	mov    %r13d,0x60(%rsp)
 18af493:	44 8b 6c 24 30       	mov    0x30(%rsp),%r13d
 18af498:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18af49e:	74 4e                	je     18af4ee <run_backend_benchmark+0x7ece>
 18af4a0:	41 0f b6 76 1d       	movzbl 0x1d(%r14),%esi
 18af4a5:	31 d2                	xor    %edx,%edx
 18af4a7:	48 81 fe ff 00 00 00 	cmp    $0xff,%rsi
 18af4ae:	0f 84 8c fc ff ff    	je     18af140 <run_backend_benchmark+0x7b20>
 18af4b4:	4d 01 c7             	add    %r8,%r15
 18af4b7:	41 80 7f 08 01       	cmpb   $0x1,0x8(%r15)
 18af4bc:	0f 85 7e fc ff ff    	jne    18af140 <run_backend_benchmark+0x7b20>
 18af4c2:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
 18af4c7:	48 6b d6 74          	imul   $0x74,%rsi,%rdx
 18af4cb:	41 8b 54 17 5c       	mov    0x5c(%r15,%rdx,1),%edx
 18af4d0:	e9 6b fc ff ff       	jmp    18af140 <run_backend_benchmark+0x7b20>
 18af4d5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18af4e0:	41 8b 46 10          	mov    0x10(%r14),%eax
 18af4e4:	31 c9                	xor    %ecx,%ecx
 18af4e6:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18af4ec:	75 b2                	jne    18af4a0 <run_backend_benchmark+0x7e80>
 18af4ee:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18af4f6:	c7 83 b0 00 00 00 00 00 00 00 	movl   $0x0,0xb0(%rbx)
 18af500:	48 8b 12             	mov    (%rdx),%rdx
 18af503:	48 89 93 a0 00 00 00 	mov    %rdx,0xa0(%rbx)
 18af50a:	31 d2                	xor    %edx,%edx
 18af50c:	e9 53 fc ff ff       	jmp    18af164 <run_backend_benchmark+0x7b44>
 18af511:	4d 89 cf             	mov    %r9,%r15
 18af514:	83 f9 40             	cmp    $0x40,%ecx
 18af517:	73 09                	jae    18af522 <run_backend_benchmark+0x7f02>
 18af519:	31 f6                	xor    %esi,%esi
 18af51b:	31 ff                	xor    %edi,%edi
 18af51d:	e9 92 00 00 00       	jmp    18af5b4 <run_backend_benchmark+0x7f94>
 18af522:	c5 fc 47 c0          	kxorw  %k0,%k0,%k0
 18af526:	89 ce                	mov    %ecx,%esi
 18af528:	83 e6 c0             	and    $0xffffffc0,%esi
 18af52b:	89 d7                	mov    %edx,%edi
 18af52d:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
 18af531:	c5 fc 47 d0          	kxorw  %k0,%k0,%k2
 18af535:	c5 fc 47 d8          	kxorw  %k0,%k0,%k3
 18af539:	49 89 f0             	mov    %rsi,%r8
 18af53c:	0f 1f 40 00          	nopl   0x0(%rax)
 18af540:	41 89 f9             	mov    %edi,%r9d
 18af543:	62 b1 fe 48 6f 04 88 	vmovdqu64 (%rax,%r9,4),%zmm0
 18af54a:	62 b1 fe 48 6f 4c 88 01 	vmovdqu64 0x40(%rax,%r9,4),%zmm1
 18af552:	62 b1 fe 48 6f 5c 88 03 	vmovdqu64 0xc0(%rax,%r9,4),%zmm3
 18af55a:	62 b1 fe 48 6f 54 88 02 	vmovdqu64 0x80(%rax,%r9,4),%zmm2
 18af562:	83 c7 40             	add    $0x40,%edi
 18af565:	49 83 c0 c0          	add    $0xffffffffffffffc0,%r8
 18af569:	62 f2 7d 48 27 e0    	vptestmd %zmm0,%zmm0,%k4
 18af56f:	62 f2 65 48 27 eb    	vptestmd %zmm3,%zmm3,%k5
 18af575:	c5 fc 45 c4          	korw   %k4,%k0,%k0
 18af579:	62 f2 75 48 27 e1    	vptestmd %zmm1,%zmm1,%k4
 18af57f:	c5 e4 45 dd          	korw   %k5,%k3,%k3
 18af583:	c5 f4 45 cc          	korw   %k4,%k1,%k1
 18af587:	62 f2 6d 48 27 e2    	vptestmd %zmm2,%zmm2,%k4
 18af58d:	c5 ec 45 d4          	korw   %k4,%k2,%k2
 18af591:	75 ad                	jne    18af540 <run_backend_benchmark+0x7f20>
 18af593:	c5 f4 45 c0          	korw   %k0,%k1,%k0
 18af597:	c5 ec 45 c0          	korw   %k0,%k2,%k0
 18af59b:	c5 f8 98 d8          	kortestw %k0,%k3
 18af59f:	40 0f 95 c7          	setne  %dil
 18af5a3:	39 ce                	cmp    %ecx,%esi
 18af5a5:	0f 84 db fd ff ff    	je     18af386 <run_backend_benchmark+0x7d66>
 18af5ab:	f6 c1 38             	test   $0x38,%cl
 18af5ae:	0f 84 39 fd ff ff    	je     18af2ed <run_backend_benchmark+0x7ccd>
 18af5b4:	49 89 f0             	mov    %rsi,%r8
 18af5b7:	89 ce                	mov    %ecx,%esi
 18af5b9:	83 e6 f8             	and    $0xfffffff8,%esi
 18af5bc:	40 84 ff             	test   %dil,%dil
 18af5bf:	40 0f 95 c7          	setne  %dil
 18af5c3:	c5 fb 92 c7          	kmovd  %edi,%k0
 18af5c7:	89 d7                	mov    %edx,%edi
 18af5c9:	44 01 c7             	add    %r8d,%edi
 18af5cc:	49 29 f0             	sub    %rsi,%r8
 18af5cf:	90                   	nop
 18af5d0:	41 89 f9             	mov    %edi,%r9d
 18af5d3:	c4 a1 7e 6f 04 88    	vmovdqu (%rax,%r9,4),%ymm0
 18af5d9:	83 c7 08             	add    $0x8,%edi
 18af5dc:	49 83 c0 08          	add    $0x8,%r8
 18af5e0:	62 f2 7d 28 27 c8    	vptestmd %ymm0,%ymm0,%k1
 18af5e6:	c5 fd 45 c1          	korb   %k1,%k0,%k0
 18af5ea:	75 e4                	jne    18af5d0 <run_backend_benchmark+0x7fb0>
 18af5ec:	c5 f9 98 c0          	kortestb %k0,%k0
 18af5f0:	40 0f 95 c7          	setne  %dil
 18af5f4:	39 ce                	cmp    %ecx,%esi
 18af5f6:	0f 85 f1 fc ff ff    	jne    18af2ed <run_backend_benchmark+0x7ccd>
 18af5fc:	e9 85 fd ff ff       	jmp    18af386 <run_backend_benchmark+0x7d66>
 18af601:	41 89 83 00 3a 00 00 	mov    %eax,0x3a00(%r11)
 18af608:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18af60d:	48 8b 9c 24 10 01 00 00 	mov    0x110(%rsp),%rbx
 18af615:	4d 89 df             	mov    %r11,%r15
 18af618:	31 c9                	xor    %ecx,%ecx
 18af61a:	48 8b b4 24 a8 01 00 00 	mov    0x1a8(%rsp),%rsi
 18af622:	48 8b 94 24 b0 01 00 00 	mov    0x1b0(%rsp),%rdx
 18af62a:	44 8b b4 24 98 01 00 00 	mov    0x198(%rsp),%r14d
 18af632:	48 8b 84 24 a0 01 00 00 	mov    0x1a0(%rsp),%rax
 18af63a:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 18af642:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 18af64a:	48 8b b4 24 68 01 00 00 	mov    0x168(%rsp),%rsi
 18af652:	48 8b 94 24 70 01 00 00 	mov    0x170(%rsp),%rdx
 18af65a:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 18af65f:	48 89 74 24 78       	mov    %rsi,0x78(%rsp)
 18af664:	48 89 94 24 90 00 00 00 	mov    %rdx,0x90(%rsp)
 18af66c:	48 8b b4 24 78 01 00 00 	mov    0x178(%rsp),%rsi
 18af674:	48 8b 94 24 80 01 00 00 	mov    0x180(%rsp),%rdx
 18af67c:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 18af681:	48 89 94 24 b0 00 00 00 	mov    %rdx,0xb0(%rsp)
 18af689:	48 8b b4 24 88 01 00 00 	mov    0x188(%rsp),%rsi
 18af691:	48 8b 94 24 90 01 00 00 	mov    0x190(%rsp),%rdx
 18af699:	48 89 74 24 60       	mov    %rsi,0x60(%rsp)
 18af69e:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
 18af6a6:	eb 33                	jmp    18af6db <run_backend_benchmark+0x80bb>
 18af6a8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18af6b0:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18af6b5:	4c 89 e3             	mov    %r12,%rbx
 18af6b8:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18af6bd:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18af6c2:	49 81 c7 e8 00 00 00 	add    $0xe8,%r15
 18af6c9:	8b 80 00 3a 00 00    	mov    0x3a00(%rax),%eax
 18af6cf:	48 ff c1             	inc    %rcx
 18af6d2:	48 39 c1             	cmp    %rax,%rcx
 18af6d5:	0f 83 c8 04 00 00    	jae    18afba3 <run_backend_benchmark+0x8583>
 18af6db:	41 81 fe 00 00 10 00 	cmp    $0x100000,%r14d
 18af6e2:	0f 83 bb 04 00 00    	jae    18afba3 <run_backend_benchmark+0x8583>
 18af6e8:	49 89 dc             	mov    %rbx,%r12
 18af6eb:	48 8d 9c 24 e0 01 00 00 	lea    0x1e0(%rsp),%rbx
 18af6f3:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 18af6fb:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 18af700:	4c 89 fe             	mov    %r15,%rsi
 18af703:	48 89 da             	mov    %rbx,%rdx
 18af706:	c5 f8 77             	vzeroupper
 18af709:	e8 d2 99 01 00       	call   18c90e0 <tier0_compile_scalar>
 18af70e:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18af716:	4c 89 fe             	mov    %r15,%rsi
 18af719:	48 89 da             	mov    %rbx,%rdx
 18af71c:	e8 df a8 01 00       	call   18ca000 <tier0_compile>
 18af721:	8b 9c 24 dc 02 00 00 	mov    0x2dc(%rsp),%ebx
 18af728:	3b 9c 24 74 02 00 00 	cmp    0x274(%rsp),%ebx
 18af72f:	0f 85 9d 12 00 00    	jne    18b09d2 <run_backend_benchmark+0x93b2>
 18af735:	44 8b ac 24 88 02 00 00 	mov    0x288(%rsp),%r13d
 18af73d:	44 3b ac 24 20 02 00 00 	cmp    0x220(%rsp),%r13d
 18af745:	0f 85 87 12 00 00    	jne    18b09d2 <run_backend_benchmark+0x93b2>
 18af74b:	8b 84 24 a0 02 00 00 	mov    0x2a0(%rsp),%eax
 18af752:	3b 84 24 38 02 00 00 	cmp    0x238(%rsp),%eax
 18af759:	0f 85 73 12 00 00    	jne    18b09d2 <run_backend_benchmark+0x93b2>
 18af75f:	48 8b bc 24 80 02 00 00 	mov    0x280(%rsp),%rdi
 18af767:	48 8b b4 24 18 02 00 00 	mov    0x218(%rsp),%rsi
 18af76f:	4c 89 ea             	mov    %r13,%rdx
 18af772:	48 c1 e2 04          	shl    $0x4,%rdx
 18af776:	e8 45 4b eb fe       	call   7642c0 <bcmp@plt>
 18af77b:	85 c0                	test   %eax,%eax
 18af77d:	0f 85 4f 12 00 00    	jne    18b09d2 <run_backend_benchmark+0x93b2>
 18af783:	85 db                	test   %ebx,%ebx
 18af785:	0f 85 25 ff ff ff    	jne    18af6b0 <run_backend_benchmark+0x8090>
 18af78b:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
 18af790:	44 89 f0             	mov    %r14d,%eax
 18af793:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18af79b:	4d 8d 45 01          	lea    0x1(%r13),%r8
 18af79f:	4c 89 e3             	mov    %r12,%rbx
 18af7a2:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
 18af7a6:	48 6b c8 68          	imul   $0x68,%rax,%rcx
 18af7aa:	62 f1 fe 48 6f 84 24 18 02 00 00 	vmovdqu64 0x218(%rsp),%zmm0
 18af7b5:	62 f1 fe 48 6f 4c 24 09 	vmovdqu64 0x240(%rsp),%zmm1
 18af7bd:	62 f1 fe 48 7f 8c 0a 28 00 00 00 	vmovdqu64 %zmm1,0x28(%rdx,%rcx,1)
 18af7c8:	62 f1 fe 48 7f 04 0a 	vmovdqu64 %zmm0,(%rdx,%rcx,1)
 18af7cf:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
 18af7d4:	49 8d 74 14 03       	lea    0x3(%r12,%rdx,1),%rsi
 18af7d9:	49 8d 0c 14          	lea    (%r12,%rdx,1),%rcx
 18af7dd:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 18af7e1:	48 89 f7             	mov    %rsi,%rdi
 18af7e4:	48 29 d7             	sub    %rdx,%rdi
 18af7e7:	48 39 ce             	cmp    %rcx,%rsi
 18af7ea:	73 2c                	jae    18af818 <run_backend_benchmark+0x81f8>
 18af7ec:	4c 8b 4c 24 70       	mov    0x70(%rsp),%r9
 18af7f1:	49 8d 14 c1          	lea    (%r9,%rax,8),%rdx
 18af7f5:	49 c7 04 c1 00 00 00 00 	movq   $0x0,(%r9,%rax,8)
 18af7fd:	48 39 ce             	cmp    %rcx,%rsi
 18af800:	0f 82 99 00 00 00    	jb     18af89f <run_backend_benchmark+0x827f>
 18af806:	4c 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%r9
 18af80e:	49 29 f9             	sub    %rdi,%r9
 18af811:	73 4f                	jae    18af862 <run_backend_benchmark+0x8242>
 18af813:	e9 87 00 00 00       	jmp    18af89f <run_backend_benchmark+0x827f>
 18af818:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18af820:	48 29 fa             	sub    %rdi,%rdx
 18af823:	72 c7                	jb     18af7ec <run_backend_benchmark+0x81cc>
 18af825:	4d 89 c1             	mov    %r8,%r9
 18af828:	49 c1 e1 04          	shl    $0x4,%r9
 18af82c:	49 39 d1             	cmp    %rdx,%r9
 18af82f:	77 bb                	ja     18af7ec <run_backend_benchmark+0x81cc>
 18af831:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 18af836:	4c 01 cf             	add    %r9,%rdi
 18af839:	49 01 f1             	add    %rsi,%r9
 18af83c:	48 89 fb             	mov    %rdi,%rbx
 18af83f:	4c 89 cf             	mov    %r9,%rdi
 18af842:	48 2b 7c 24 50       	sub    0x50(%rsp),%rdi
 18af847:	48 8d 14 c1          	lea    (%rcx,%rax,8),%rdx
 18af84b:	48 89 34 c1          	mov    %rsi,(%rcx,%rax,8)
 18af84f:	4c 89 c9             	mov    %r9,%rcx
 18af852:	4c 89 ce             	mov    %r9,%rsi
 18af855:	4c 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%r9
 18af85d:	49 29 f9             	sub    %rdi,%r9
 18af860:	72 3d                	jb     18af89f <run_backend_benchmark+0x827f>
 18af862:	49 c1 e0 02          	shl    $0x2,%r8
 18af866:	4d 39 c8             	cmp    %r9,%r8
 18af869:	77 34                	ja     18af89f <run_backend_benchmark+0x827f>
 18af86b:	48 89 fb             	mov    %rdi,%rbx
 18af86e:	4c 01 c3             	add    %r8,%rbx
 18af871:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
 18af876:	49 89 f1             	mov    %rsi,%r9
 18af879:	49 8d 74 18 03       	lea    0x3(%r8,%rbx,1),%rsi
 18af87e:	4a 8d 0c 03          	lea    (%rbx,%r8,1),%rcx
 18af882:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 18af886:	48 89 f7             	mov    %rsi,%rdi
 18af889:	4c 29 c7             	sub    %r8,%rdi
 18af88c:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 18af894:	4d 89 0c c0          	mov    %r9,(%r8,%rax,8)
 18af898:	48 39 ce             	cmp    %rcx,%rsi
 18af89b:	72 51                	jb     18af8ee <run_backend_benchmark+0x82ce>
 18af89d:	eb 14                	jmp    18af8b3 <run_backend_benchmark+0x8293>
 18af89f:	45 31 c9             	xor    %r9d,%r9d
 18af8a2:	4c 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%r8
 18af8aa:	4d 89 0c c0          	mov    %r9,(%r8,%rax,8)
 18af8ae:	48 39 ce             	cmp    %rcx,%rsi
 18af8b1:	72 3b                	jb     18af8ee <run_backend_benchmark+0x82ce>
 18af8b3:	4c 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%r10
 18af8bb:	49 29 fa             	sub    %rdi,%r10
 18af8be:	72 2e                	jb     18af8ee <run_backend_benchmark+0x82ce>
 18af8c0:	44 8b 84 24 48 02 00 00 	mov    0x248(%rsp),%r8d
 18af8c8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 18af8ce:	4e 8d 04 85 40 00 00 00 	lea    0x40(,%r8,4),%r8
 18af8d6:	4d 39 d0             	cmp    %r10,%r8
 18af8d9:	77 16                	ja     18af8f1 <run_backend_benchmark+0x82d1>
 18af8db:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 18af8e0:	49 01 f8             	add    %rdi,%r8
 18af8e3:	49 89 f1             	mov    %rsi,%r9
 18af8e6:	4c 89 c3             	mov    %r8,%rbx
 18af8e9:	4c 01 c1             	add    %r8,%rcx
 18af8ec:	eb 03                	jmp    18af8f1 <run_backend_benchmark+0x82d1>
 18af8ee:	45 31 c9             	xor    %r9d,%r9d
 18af8f1:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18af8f6:	48 8b bc 24 98 00 00 00 	mov    0x98(%rsp),%rdi
 18af8fe:	4c 89 0c c6          	mov    %r9,(%rsi,%rax,8)
 18af902:	4b 8d 74 ad 00       	lea    0x0(%r13,%r13,4),%rsi
 18af907:	48 29 df             	sub    %rbx,%rdi
 18af90a:	41 0f 92 c0          	setb   %r8b
 18af90e:	48 8d 74 76 40       	lea    0x40(%rsi,%rsi,2),%rsi
 18af913:	48 39 fe             	cmp    %rdi,%rsi
 18af916:	40 0f 97 c7          	seta   %dil
 18af91a:	44 08 c7             	or     %r8b,%dil
 18af91d:	4c 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%r8
 18af925:	bf 00 00 00 00       	mov    $0x0,%edi
 18af92a:	48 0f 45 cf          	cmovne %rdi,%rcx
 18af92e:	48 0f 45 f7          	cmovne %rdi,%rsi
 18af932:	49 89 0c c0          	mov    %rcx,(%r8,%rax,8)
 18af936:	48 83 3a 00          	cmpq   $0x0,(%rdx)
 18af93a:	0f 84 49 10 00 00    	je     18b0989 <run_backend_benchmark+0x9369>
 18af940:	48 8b 94 24 b0 00 00 00 	mov    0xb0(%rsp),%rdx
 18af948:	48 83 3c c2 00       	cmpq   $0x0,(%rdx,%rax,8)
 18af94d:	0f 84 36 10 00 00    	je     18b0989 <run_backend_benchmark+0x9369>
 18af953:	41 8b 57 18          	mov    0x18(%r15),%edx
 18af957:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
 18af95c:	41 ff c6             	inc    %r14d
 18af95f:	4c 01 ac 24 a0 00 00 00 	add    %r13,0xa0(%rsp)
 18af967:	48 01 54 24 30       	add    %rdx,0x30(%rsp)
 18af96c:	8b 94 24 6c 02 00 00 	mov    0x26c(%rsp),%edx
 18af973:	48 01 94 24 80 00 00 00 	add    %rdx,0x80(%rsp)
 18af97b:	48 83 3c c7 00       	cmpq   $0x0,(%rdi,%rax,8)
 18af980:	0f 84 ad 10 00 00    	je     18b0a33 <run_backend_benchmark+0x9413>
 18af986:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18af98b:	48 85 c9             	test   %rcx,%rcx
 18af98e:	0f 84 a4 10 00 00    	je     18b0a38 <run_backend_benchmark+0x9418>
 18af994:	48 01 f3             	add    %rsi,%rbx
 18af997:	e9 1c fd ff ff       	jmp    18af6b8 <run_backend_benchmark+0x8098>
 18af99c:	64 48 8b 04 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rax
 18af9a5:	49 89 ce             	mov    %rcx,%r14
 18af9a8:	48 29 f1             	sub    %rsi,%rcx
 18af9ab:	49 89 f7             	mov    %rsi,%r15
 18af9ae:	48 89 c6             	mov    %rax,%rsi
 18af9b1:	48 29 ce             	sub    %rcx,%rsi
 18af9b4:	0f 82 46 f6 ff ff    	jb     18af000 <run_backend_benchmark+0x79e0>
 18af9ba:	49 8d 54 24 11       	lea    0x11(%r12),%rdx
 18af9bf:	48 39 f2             	cmp    %rsi,%rdx
 18af9c2:	0f 87 38 f6 ff ff    	ja     18af000 <run_backend_benchmark+0x79e0>
 18af9c8:	48 01 d1             	add    %rdx,%rcx
 18af9cb:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18af9d4:	4d 85 f6             	test   %r14,%r14
 18af9d7:	0f 84 23 f6 ff ff    	je     18af000 <run_backend_benchmark+0x79e0>
 18af9dd:	49 8d 4c 24 10       	lea    0x10(%r12),%rcx
 18af9e2:	48 89 ce             	mov    %rcx,%rsi
 18af9e5:	48 c1 ee 3e          	shr    $0x3e,%rsi
 18af9e9:	0f 85 11 f6 ff ff    	jne    18af000 <run_backend_benchmark+0x79e0>
 18af9ef:	4a 8d 5c 32 03       	lea    0x3(%rdx,%r14,1),%rbx
 18af9f4:	4a 8d 34 32          	lea    (%rdx,%r14,1),%rsi
 18af9f8:	48 83 e3 fc          	and    $0xfffffffffffffffc,%rbx
 18af9fc:	48 39 f3             	cmp    %rsi,%rbx
 18af9ff:	0f 82 fb f5 ff ff    	jb     18af000 <run_backend_benchmark+0x79e0>
 18afa05:	48 89 de             	mov    %rbx,%rsi
 18afa08:	4c 29 fe             	sub    %r15,%rsi
 18afa0b:	48 89 c7             	mov    %rax,%rdi
 18afa0e:	48 29 f7             	sub    %rsi,%rdi
 18afa11:	0f 82 e9 f5 ff ff    	jb     18af000 <run_backend_benchmark+0x79e0>
 18afa17:	48 c1 e1 02          	shl    $0x2,%rcx
 18afa1b:	48 39 f9             	cmp    %rdi,%rcx
 18afa1e:	0f 87 dc f5 ff ff    	ja     18af000 <run_backend_benchmark+0x79e0>
 18afa24:	48 01 ce             	add    %rcx,%rsi
 18afa27:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18afa30:	48 85 db             	test   %rbx,%rbx
 18afa33:	0f 84 c7 f5 ff ff    	je     18af000 <run_backend_benchmark+0x79e0>
 18afa39:	48 8d 34 0b          	lea    (%rbx,%rcx,1),%rsi
 18afa3d:	48 89 c7             	mov    %rax,%rdi
 18afa40:	48 89 b4 24 28 01 00 00 	mov    %rsi,0x128(%rsp)
 18afa48:	4c 29 fe             	sub    %r15,%rsi
 18afa4b:	48 29 f7             	sub    %rsi,%rdi
 18afa4e:	0f 82 ac f5 ff ff    	jb     18af000 <run_backend_benchmark+0x79e0>
 18afa54:	48 39 f9             	cmp    %rdi,%rcx
 18afa57:	0f 87 a3 f5 ff ff    	ja     18af000 <run_backend_benchmark+0x79e0>
 18afa5d:	48 01 ce             	add    %rcx,%rsi
 18afa60:	48 8d 3c 0b          	lea    (%rbx,%rcx,1),%rdi
 18afa64:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18afa6d:	48 85 ff             	test   %rdi,%rdi
 18afa70:	0f 84 8a f5 ff ff    	je     18af000 <run_backend_benchmark+0x79e0>
 18afa76:	48 8d 34 0b          	lea    (%rbx,%rcx,1),%rsi
 18afa7a:	48 89 c7             	mov    %rax,%rdi
 18afa7d:	48 01 ce             	add    %rcx,%rsi
 18afa80:	48 89 b4 24 00 01 00 00 	mov    %rsi,0x100(%rsp)
 18afa88:	4c 29 fe             	sub    %r15,%rsi
 18afa8b:	48 29 f7             	sub    %rsi,%rdi
 18afa8e:	0f 82 6c f5 ff ff    	jb     18af000 <run_backend_benchmark+0x79e0>
 18afa94:	48 39 f9             	cmp    %rdi,%rcx
 18afa97:	0f 87 63 f5 ff ff    	ja     18af000 <run_backend_benchmark+0x79e0>
 18afa9d:	48 01 ce             	add    %rcx,%rsi
 18afaa0:	48 83 bc 24 00 01 00 00 00 	cmpq   $0x0,0x100(%rsp)
 18afaa9:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18afab2:	0f 84 48 f5 ff ff    	je     18af000 <run_backend_benchmark+0x79e0>
 18afab8:	48 8b bc 24 00 01 00 00 	mov    0x100(%rsp),%rdi
 18afac0:	48 8d 34 0f          	lea    (%rdi,%rcx,1),%rsi
 18afac4:	48 8d 7c 0f 04       	lea    0x4(%rdi,%rcx,1),%rdi
 18afac9:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 18afacd:	48 39 f7             	cmp    %rsi,%rdi
 18afad0:	0f 82 2a f5 ff ff    	jb     18af000 <run_backend_benchmark+0x79e0>
 18afad6:	48 89 f9             	mov    %rdi,%rcx
 18afad9:	4c 29 f9             	sub    %r15,%rcx
 18afadc:	48 29 c8             	sub    %rcx,%rax
 18afadf:	0f 82 1b f5 ff ff    	jb     18af000 <run_backend_benchmark+0x79e0>
 18afae5:	4a 8d 34 dd 00 00 00 00 	lea    0x0(,%r11,8),%rsi
 18afaed:	48 39 c6             	cmp    %rax,%rsi
 18afaf0:	0f 87 0a f5 ff ff    	ja     18af000 <run_backend_benchmark+0x79e0>
 18afaf6:	48 01 f1             	add    %rsi,%rcx
 18afaf9:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18afb02:	48 85 ff             	test   %rdi,%rdi
 18afb05:	0f 84 f5 f4 ff ff    	je     18af000 <run_backend_benchmark+0x79e0>
 18afb0b:	48 89 bc 24 e0 00 00 00 	mov    %rdi,0xe0(%rsp)
 18afb13:	48 89 9c 24 08 01 00 00 	mov    %rbx,0x108(%rsp)
 18afb1b:	4c 89 ac 24 c0 00 00 00 	mov    %r13,0xc0(%rsp)
 18afb23:	4c 89 9c 24 d0 00 00 00 	mov    %r11,0xd0(%rsp)
 18afb2b:	4c 89 f7             	mov    %r14,%rdi
 18afb2e:	31 f6                	xor    %esi,%esi
 18afb30:	4c 89 cb             	mov    %r9,%rbx
 18afb33:	c5 f8 77             	vzeroupper
 18afb36:	e8 f5 47 eb fe       	call   764330 <memset@plt>
 18afb3b:	85 db                	test   %ebx,%ebx
 18afb3d:	0f 84 04 04 00 00    	je     18aff47 <run_backend_benchmark+0x8927>
 18afb43:	83 bc 24 f0 00 00 00 01 	cmpl   $0x1,0xf0(%rsp)
 18afb4b:	0f 85 ba 00 00 00    	jne    18afc0b <run_backend_benchmark+0x85eb>
 18afb51:	31 c9                	xor    %ecx,%ecx
 18afb53:	31 c0                	xor    %eax,%eax
 18afb55:	e9 f7 02 00 00       	jmp    18afe51 <run_backend_benchmark+0x8831>
 18afb5a:	41 89 93 00 3a 00 00 	mov    %edx,0x3a00(%r11)
 18afb61:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18afb66:	48 8b 9c 24 10 01 00 00 	mov    0x110(%rsp),%rbx
 18afb6e:	48 8b 84 24 a0 01 00 00 	mov    0x1a0(%rsp),%rax
 18afb76:	48 8b 94 24 a8 01 00 00 	mov    0x1a8(%rsp),%rdx
 18afb7e:	48 8b 8c 24 b0 01 00 00 	mov    0x1b0(%rsp),%rcx
 18afb86:	44 8b b4 24 98 01 00 00 	mov    0x198(%rsp),%r14d
 18afb8e:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 18afb93:	48 89 94 24 a0 00 00 00 	mov    %rdx,0xa0(%rsp)
 18afb9b:	48 89 8c 24 80 00 00 00 	mov    %rcx,0x80(%rsp)
 18afba3:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 18afbab:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18afbb0:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18afbb8:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18afbc0:	48 ff 84 24 d8 00 00 00 	incq   0xd8(%rsp)
 18afbc8:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18afbd0:	49 bf 00 00 20 00 01 00 00 00 	movabs $0x100200000,%r15
 18afbda:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18afbe0:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 18afbe8:	48 89 8c 24 a8 01 00 00 	mov    %rcx,0x1a8(%rsp)
 18afbf0:	48 89 94 24 b0 01 00 00 	mov    %rdx,0x1b0(%rsp)
 18afbf8:	48 3b 84 24 20 01 00 00 	cmp    0x120(%rsp),%rax
 18afc00:	0f 82 dd cf ff ff    	jb     18acbe3 <run_backend_benchmark+0x55c3>
 18afc06:	e9 3c 10 00 00       	jmp    18b0c47 <run_backend_benchmark+0x9627>
 18afc0b:	48 8b 84 24 d0 00 00 00 	mov    0xd0(%rsp),%rax
 18afc13:	83 e0 fe             	and    $0xfffffffe,%eax
 18afc16:	31 c9                	xor    %ecx,%ecx
 18afc18:	4c 89 b4 24 e8 00 00 00 	mov    %r14,0xe8(%rsp)
 18afc20:	48 89 84 24 40 01 00 00 	mov    %rax,0x140(%rsp)
 18afc28:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18afc2d:	48 8d 70 1a          	lea    0x1a(%rax),%rsi
 18afc31:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18afc39:	48 ff c0             	inc    %rax
 18afc3c:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 18afc44:	31 c0                	xor    %eax,%eax
 18afc46:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18afc4b:	4c 8b 6c 24 60       	mov    0x60(%rsp),%r13
 18afc50:	4c 8b 9c 24 b0 0e 00 00 	mov    0xeb0(%rsp),%r11
 18afc58:	44 8b 04 8a          	mov    (%rdx,%rcx,4),%r8d
 18afc5c:	41 8b 5c 8d 00       	mov    0x0(%r13,%rcx,4),%ebx
 18afc61:	49 81 f8 00 80 00 00 	cmp    $0x8000,%r8
 18afc68:	41 0f 93 c1          	setae  %r9b
 18afc6c:	83 e3 f8             	and    $0xfffffff8,%ebx
 18afc6f:	45 8b 7c 1b 02       	mov    0x2(%r11,%rbx,1),%r15d
 18afc74:	41 0f b6 3c 1b       	movzbl (%r11,%rbx,1),%edi
 18afc79:	45 0f b6 54 1b 01    	movzbl 0x1(%r11,%rbx,1),%r10d
 18afc7f:	44 89 bc 24 80 02 00 00 	mov    %r15d,0x280(%rsp)
 18afc87:	45 89 d7             	mov    %r10d,%r15d
 18afc8a:	45 0f b7 5c 1b 06    	movzwl 0x6(%r11,%rbx,1),%r11d
 18afc90:	66 44 89 9c 24 84 02 00 00 	mov    %r11w,0x284(%rsp)
 18afc99:	45 31 db             	xor    %r11d,%r11d
 18afc9c:	40 80 ff 02          	cmp    $0x2,%dil
 18afca0:	c7 46 e6 00 00 00 00 	movl   $0x0,-0x1a(%rsi)
 18afca7:	c6 46 ea 04          	movb   $0x4,-0x16(%rsi)
 18afcab:	41 0f 94 c3          	sete   %r11b
 18afcaf:	41 c0 e1 06          	shl    $0x6,%r9b
 18afcb3:	41 80 e2 08          	and    $0x8,%r10b
 18afcb7:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 18afcbc:	41 c0 ea 03          	shr    $0x3,%r10b
 18afcc0:	c4 e3 79 20 c7 03    	vpinsrb $0x3,%edi,%xmm0,%xmm0
 18afcc6:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 18afcce:	45 20 da             	and    %r11b,%r10b
 18afcd1:	c5 f9 7e 46 eb       	vmovd  %xmm0,-0x15(%rsi)
 18afcd6:	44 88 7e ef          	mov    %r15b,-0x11(%rsi)
 18afcda:	41 c0 e2 05          	shl    $0x5,%r10b
 18afcde:	8b 9c 24 80 02 00 00 	mov    0x280(%rsp),%ebx
 18afce5:	89 5e f0             	mov    %ebx,-0x10(%rsi)
 18afce8:	0f b7 9c 24 84 02 00 00 	movzwl 0x284(%rsp),%ebx
 18afcf0:	66 89 5e f4          	mov    %bx,-0xc(%rsi)
 18afcf4:	42 8d 1c dd 00 00 00 00 	lea    0x0(,%r11,8),%ebx
 18afcfc:	48 89 04 cf          	mov    %rax,(%rdi,%rcx,8)
 18afd00:	bf 00 00 00 00       	mov    $0x0,%edi
 18afd05:	41 08 d9             	or     %bl,%r9b
 18afd08:	48 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%rbx
 18afd10:	80 7c 0b ff 00       	cmpb   $0x0,-0x1(%rbx,%rcx,1)
 18afd15:	41 0f 95 c3          	setne  %r11b
 18afd19:	45 08 ca             	or     %r9b,%r10b
 18afd1c:	41 c0 e3 04          	shl    $0x4,%r11b
 18afd20:	45 08 da             	or     %r11b,%r10b
 18afd23:	41 fe c2             	inc    %r10b
 18afd26:	4d 85 c0             	test   %r8,%r8
 18afd29:	45 0f b6 ca          	movzbl %r10b,%r9d
 18afd2d:	44 0f 44 cf          	cmove  %edi,%r9d
 18afd31:	48 8b bc 24 e8 00 00 00 	mov    0xe8(%rsp),%rdi
 18afd39:	44 08 0c 07          	or     %r9b,(%rdi,%rax,1)
 18afd3d:	4c 01 c0             	add    %r8,%rax
 18afd40:	44 8b 44 8a 04       	mov    0x4(%rdx,%rcx,4),%r8d
 18afd45:	41 8b 5c 8d 04       	mov    0x4(%r13,%rcx,4),%ebx
 18afd4a:	4c 8b 9c 24 b0 0e 00 00 	mov    0xeb0(%rsp),%r11
 18afd52:	48 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%rdx
 18afd5a:	49 81 f8 00 80 00 00 	cmp    $0x8000,%r8
 18afd61:	41 0f 93 c1          	setae  %r9b
 18afd65:	83 e3 f8             	and    $0xfffffff8,%ebx
 18afd68:	45 8b 7c 1b 02       	mov    0x2(%r11,%rbx,1),%r15d
 18afd6d:	41 0f b6 3c 1b       	movzbl (%r11,%rbx,1),%edi
 18afd72:	45 0f b6 54 1b 01    	movzbl 0x1(%r11,%rbx,1),%r10d
 18afd78:	44 89 bc 24 80 02 00 00 	mov    %r15d,0x280(%rsp)
 18afd80:	45 0f b7 5c 1b 06    	movzwl 0x6(%r11,%rbx,1),%r11d
 18afd86:	66 44 89 9c 24 84 02 00 00 	mov    %r11w,0x284(%rsp)
 18afd8f:	45 31 db             	xor    %r11d,%r11d
 18afd92:	40 80 ff 02          	cmp    $0x2,%dil
 18afd96:	c7 46 f6 00 00 00 00 	movl   $0x0,-0xa(%rsi)
 18afd9d:	c6 46 fa 04          	movb   $0x4,-0x6(%rsi)
 18afda1:	41 0f 94 c3          	sete   %r11b
 18afda5:	41 c0 e1 06          	shl    $0x6,%r9b
 18afda9:	c4 c1 79 6e c3       	vmovd  %r11d,%xmm0
 18afdae:	c4 e3 79 20 c7 03    	vpinsrb $0x3,%edi,%xmm0,%xmm0
 18afdb4:	48 8b bc 24 e8 00 00 00 	mov    0xe8(%rsp),%rdi
 18afdbc:	c5 f9 7e 46 fb       	vmovd  %xmm0,-0x5(%rsi)
 18afdc1:	44 88 56 ff          	mov    %r10b,-0x1(%rsi)
 18afdc5:	41 80 e2 08          	and    $0x8,%r10b
 18afdc9:	8b 9c 24 80 02 00 00 	mov    0x280(%rsp),%ebx
 18afdd0:	41 c0 ea 03          	shr    $0x3,%r10b
 18afdd4:	45 20 da             	and    %r11b,%r10b
 18afdd7:	41 c0 e2 05          	shl    $0x5,%r10b
 18afddb:	89 1e                	mov    %ebx,(%rsi)
 18afddd:	0f b7 9c 24 84 02 00 00 	movzwl 0x284(%rsp),%ebx
 18afde5:	66 89 5e 04          	mov    %bx,0x4(%rsi)
 18afde9:	42 8d 1c dd 00 00 00 00 	lea    0x0(,%r11,8),%ebx
 18afdf1:	48 89 44 ca 08       	mov    %rax,0x8(%rdx,%rcx,8)
 18afdf6:	ba 00 00 00 00       	mov    $0x0,%edx
 18afdfb:	41 08 d9             	or     %bl,%r9b
 18afdfe:	48 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%rbx
 18afe06:	80 3c 0b 00          	cmpb   $0x0,(%rbx,%rcx,1)
 18afe0a:	41 0f 95 c3          	setne  %r11b
 18afe0e:	45 08 ca             	or     %r9b,%r10b
 18afe11:	41 c0 e3 04          	shl    $0x4,%r11b
 18afe15:	45 08 da             	or     %r11b,%r10b
 18afe18:	41 fe c2             	inc    %r10b
 18afe1b:	4d 85 c0             	test   %r8,%r8
 18afe1e:	45 0f b6 ca          	movzbl %r10b,%r9d
 18afe22:	44 0f 44 ca          	cmove  %edx,%r9d
 18afe26:	48 83 c1 02          	add    $0x2,%rcx
 18afe2a:	48 83 c6 20          	add    $0x20,%rsi
 18afe2e:	44 08 0c 07          	or     %r9b,(%rdi,%rax,1)
 18afe32:	4c 01 c0             	add    %r8,%rax
 18afe35:	48 39 8c 24 40 01 00 00 	cmp    %rcx,0x140(%rsp)
 18afe3d:	0f 85 03 fe ff ff    	jne    18afc46 <run_backend_benchmark+0x8626>
 18afe43:	f6 84 24 d0 00 00 00 01 	testb  $0x1,0xd0(%rsp)
 18afe4b:	0f 84 f6 00 00 00    	je     18aff47 <run_backend_benchmark+0x8927>
 18afe51:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18afe56:	48 8b bc 24 b0 0e 00 00 	mov    0xeb0(%rsp),%rdi
 18afe5e:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18afe63:	44 8b 04 8e          	mov    (%rsi,%rcx,4),%r8d
 18afe67:	8b 14 8a             	mov    (%rdx,%rcx,4),%edx
 18afe6a:	41 83 e0 f8          	and    $0xfffffff8,%r8d
 18afe6e:	46 8b 54 07 02       	mov    0x2(%rdi,%r8,1),%r10d
 18afe73:	46 0f b6 0c 07       	movzbl (%rdi,%r8,1),%r9d
 18afe78:	42 0f b6 74 07 01    	movzbl 0x1(%rdi,%r8,1),%esi
 18afe7e:	44 89 94 24 80 02 00 00 	mov    %r10d,0x280(%rsp)
 18afe86:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
 18afe8b:	42 0f b7 7c 07 06    	movzwl 0x6(%rdi,%r8,1),%edi
 18afe91:	66 89 bc 24 84 02 00 00 	mov    %di,0x284(%rsp)
 18afe99:	31 ff                	xor    %edi,%edi
 18afe9b:	41 80 f9 02          	cmp    $0x2,%r9b
 18afe9f:	40 0f 94 c7          	sete   %dil
 18afea3:	c5 f9 6e c7          	vmovd  %edi,%xmm0
 18afea7:	c4 c3 79 20 c1 03    	vpinsrb $0x3,%r9d,%xmm0,%xmm0
 18afead:	49 89 c9             	mov    %rcx,%r9
 18afeb0:	49 c1 e1 04          	shl    $0x4,%r9
 18afeb4:	43 c7 04 0a 00 00 00 00 	movl   $0x0,(%r10,%r9,1)
 18afebc:	43 c6 44 0a 04 04    	movb   $0x4,0x4(%r10,%r9,1)
 18afec2:	c4 81 79 7e 44 0a 05 	vmovd  %xmm0,0x5(%r10,%r9,1)
 18afec9:	43 88 74 0a 09       	mov    %sil,0x9(%r10,%r9,1)
 18afece:	40 80 e6 08          	and    $0x8,%sil
 18afed2:	44 8b 84 24 80 02 00 00 	mov    0x280(%rsp),%r8d
 18afeda:	40 c0 ee 03          	shr    $0x3,%sil
 18afede:	81 fa 00 80 00 00    	cmp    $0x8000,%edx
 18afee4:	47 89 44 0a 0a       	mov    %r8d,0xa(%r10,%r9,1)
 18afee9:	44 0f b7 84 24 84 02 00 00 	movzwl 0x284(%rsp),%r8d
 18afef2:	66 47 89 44 0a 0e    	mov    %r8w,0xe(%r10,%r9,1)
 18afef8:	41 0f 93 c1          	setae  %r9b
 18afefc:	44 8d 04 fd 00 00 00 00 	lea    0x0(,%rdi,8),%r8d
 18aff04:	4c 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%r10
 18aff0c:	40 20 fe             	and    %dil,%sil
 18aff0f:	41 c0 e1 06          	shl    $0x6,%r9b
 18aff13:	40 c0 e6 05          	shl    $0x5,%sil
 18aff17:	45 08 c1             	or     %r8b,%r9b
 18aff1a:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18aff22:	49 89 04 ca          	mov    %rax,(%r10,%rcx,8)
 18aff26:	41 80 3c 08 00       	cmpb   $0x0,(%r8,%rcx,1)
 18aff2b:	0f 95 c1             	setne  %cl
 18aff2e:	44 08 ce             	or     %r9b,%sil
 18aff31:	c0 e1 04             	shl    $0x4,%cl
 18aff34:	40 08 ce             	or     %cl,%sil
 18aff37:	40 fe c6             	inc    %sil
 18aff3a:	85 d2                	test   %edx,%edx
 18aff3c:	40 0f b6 ce          	movzbl %sil,%ecx
 18aff40:	0f 44 ca             	cmove  %edx,%ecx
 18aff43:	41 08 0c 06          	or     %cl,(%r14,%rax,1)
 18aff47:	62 62 7d 48 58 05 13 05 cd fe 	vpbroadcastd -0x132faed(%rip),%zmm24        # 580464 <tier0_emit_x87.operations+0x1c>
 18aff51:	62 62 7d 48 58 0d 0d 05 cd fe 	vpbroadcastd -0x132faf3(%rip),%zmm25        # 580468 <tier0_emit_x87.operations+0x20>
 18aff5b:	62 62 7d 48 58 25 2f 05 cd fe 	vpbroadcastd -0x132fad1(%rip),%zmm28        # 580494 <tier0_emit_x87.operations+0x4c>
 18aff65:	62 62 7d 48 58 2d 29 05 cd fe 	vpbroadcastd -0x132fad7(%rip),%zmm29        # 580498 <tier0_emit_x87.operations+0x50>
 18aff6f:	62 61 fd 48 6f 35 87 03 c7 fe 	vmovdqa64 -0x138fc79(%rip),%zmm30        # 520300 <branch_sizing_patterns+0x570>
 18aff79:	62 62 7d 48 58 3d 19 05 cd fe 	vpbroadcastd -0x132fae7(%rip),%zmm31        # 58049c <tier0_emit_x87.operations+0x54>
 18aff83:	62 e2 7d 48 58 2d 13 05 cd fe 	vpbroadcastd -0x132faed(%rip),%zmm21        # 5804a0 <tier0_emit_x87.operations+0x58>
 18aff8d:	62 e2 7d 48 58 35 15 05 cd fe 	vpbroadcastd -0x132faeb(%rip),%zmm22        # 5804ac <tier0_emit_x87.operations+0x64>
 18aff97:	62 e2 7d 48 58 3d 0f 05 cd fe 	vpbroadcastd -0x132faf1(%rip),%zmm23        # 5804b0 <tier0_emit_x87.operations+0x68>
 18affa1:	62 61 fd 48 6f 15 95 03 c7 fe 	vmovdqa64 -0x138fc6b(%rip),%zmm26        # 520340 <branch_sizing_patterns+0x5b0>
 18affab:	62 61 fd 48 6f 1d cb 03 c7 fe 	vmovdqa64 -0x138fc35(%rip),%zmm27        # 520380 <branch_sizing_patterns+0x5f0>
 18affb5:	43 c6 04 26 01       	movb   $0x1,(%r14,%r12,1)
 18affba:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 18affc0:	4d 85 e4             	test   %r12,%r12
 18affc3:	0f 84 ec 05 00 00    	je     18b05b5 <run_backend_benchmark+0x8f95>
 18affc9:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18affce:	49 ff c6             	inc    %r14
 18affd1:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18affd5:	4d 89 e5             	mov    %r12,%r13
 18affd8:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18affdc:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18affe0:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18affe4:	31 d2                	xor    %edx,%edx
 18affe6:	48 83 c0 40          	add    $0x40,%rax
 18affea:	48 89 84 24 40 01 00 00 	mov    %rax,0x140(%rsp)
 18afff2:	44 89 ee             	mov    %r13d,%esi
 18afff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18afffa:	49 83 ed 10          	sub    $0x10,%r13
 18afffe:	48 8b bc 24 88 0e 00 00 	mov    0xe88(%rsp),%rdi
 18b0006:	4c 8b 84 24 90 0e 00 00 	mov    0xe90(%rsp),%r8
 18b000e:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
 18b0013:	c4 e2 49 f7 f0       	shlx   %esi,%eax,%esi
 18b0018:	b8 ff ff 00 00       	mov    $0xffff,%eax
 18b001d:	f7 d6                	not    %esi
 18b001f:	0f 43 f0             	cmovae %eax,%esi
 18b0022:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18b002a:	c5 fb 92 d6          	kmovd  %esi,%k2
 18b002e:	c5 f8 91 94 24 e8 00 00 00 	kmovw  %k2,0xe8(%rsp)
 18b0037:	c4 e1 f8 90 ca       	kmovq  %k2,%k1
 18b003c:	62 f1 7e ca 6f 04 90 	vmovdqu32 (%rax,%rdx,4),%zmm0{%k2}{z}
 18b0043:	62 f1 5d 48 72 d0 03 	vpsrld $0x3,%zmm0,%zmm4
 18b004a:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b004e:	62 f2 7d 49 90 04 a7 	vpgatherdd (%rdi,%zmm4,4),%zmm0{%k1}
 18b0055:	c4 e1 f8 90 ca       	kmovq  %k2,%k1
 18b005a:	62 52 7d 49 90 1c a0 	vpgatherdd (%r8,%zmm4,4),%zmm11{%k1}
 18b0061:	62 d1 7f 8a 6f a4 16 ff ff ff ff 	vmovdqu8 -0x1(%r14,%rdx,1),%xmm4{%k2}{z}
 18b006c:	62 92 7d 48 27 d0    	vptestmd %zmm24,%zmm0,%k2
 18b0072:	62 f1 45 48 72 d0 03 	vpsrld $0x3,%zmm0,%zmm7
 18b0079:	62 f1 35 48 72 d0 01 	vpsrld $0x1,%zmm0,%zmm9
 18b0080:	62 11 35 48 db c1    	vpandd %zmm25,%zmm9,%zmm8
 18b0086:	62 91 45 48 db f9    	vpandd %zmm25,%zmm7,%zmm7
 18b008c:	62 d1 35 48 72 f1 1f 	vpslld $0x1f,%zmm9,%zmm9
 18b0093:	62 72 7d 48 31 d4    	vpmovzxbd %xmm4,%zmm10
 18b0099:	c5 d9 71 f4 07       	vpsllw $0x7,%xmm4,%xmm4
 18b009e:	62 f2 7e 08 29 e4    	vpmovb2m %xmm4,%k4
 18b00a4:	c4 e3 f9 32 c4 01    	kshiftlw $0x1,%k4,%k0
 18b00aa:	c5 fc 45 ec          	korw   %k4,%k0,%k5
 18b00ae:	62 b3 2d 48 03 e4 0f 	valignd $0xf,%zmm20,%zmm10,%zmm4
 18b00b5:	c4 e3 f9 32 c5 02    	kshiftlw $0x2,%k5,%k0
 18b00bb:	62 d1 0d 48 72 d2 03 	vpsrld $0x3,%zmm10,%zmm14
 18b00c2:	c5 d4 45 d8          	korw   %k0,%k5,%k3
 18b00c6:	62 f1 2d 48 eb e4    	vpord  %zmm4,%zmm10,%zmm4
 18b00cc:	c4 e3 f9 32 c3 04    	kshiftlw $0x4,%k3,%k0
 18b00d2:	62 d1 7d 4c 6f e2    	vmovdqa32 %zmm10,%zmm4{%k4}
 18b00d8:	62 b3 dd 48 03 f4 07 	valignq $0x7,%zmm20,%zmm4,%zmm6
 18b00df:	c5 e4 45 f0          	korw   %k0,%k3,%k6
 18b00e3:	62 71 2d 58 db 15 9b 03 cd fe 	vpandd -0x132fc65(%rip){1to16},%zmm10,%zmm10        # 580488 <tier0_emit_x87.operations+0x40>
 18b00ed:	c4 e3 f9 32 c6 08    	kshiftlw $0x8,%k6,%k0
 18b00f3:	62 73 7d 58 25 15 8e 03 cd fe f8 	vpternlogd $0xf8,-0x132fc72(%rip){1to16},%zmm0,%zmm10        # 58048c <tier0_emit_x87.operations+0x44>
 18b00fe:	62 f1 5d 48 eb f6    	vpord  %zmm6,%zmm4,%zmm6
 18b0104:	c5 cc 45 f8          	korw   %k0,%k6,%k7
 18b0108:	62 f2 7d 58 27 05 4e 03 cd fe 	vptestmd -0x132fcb2(%rip){1to16},%zmm0,%k0        # 580460 <tier0_emit_x87.operations+0x18>
 18b0112:	62 f1 7d 4d 6f f4    	vmovdqa32 %zmm4,%zmm6{%k5}
 18b0118:	62 b3 cd 48 03 e4 06 	valignq $0x6,%zmm20,%zmm6,%zmm4
 18b011f:	c5 f8 44 cf          	knotw  %k7,%k1
 18b0123:	62 f1 7d c9 6f c9    	vmovdqa32 %zmm1,%zmm1{%k1}{z}
 18b0129:	c5 f8 91 8c 24 f8 00 00 00 	kmovw  %k1,0xf8(%rsp)
 18b0132:	62 f1 4d 48 eb e4    	vpord  %zmm4,%zmm6,%zmm4
 18b0138:	62 f1 7d 4b 6f e6    	vmovdqa32 %zmm6,%zmm4{%k3}
 18b013e:	62 b3 dd 48 03 f4 04 	valignq $0x4,%zmm20,%zmm4,%zmm6
 18b0145:	62 f1 75 48 eb f6    	vpord  %zmm6,%zmm1,%zmm6
 18b014b:	62 f1 7d 4e 6f f1    	vmovdqa32 %zmm1,%zmm6{%k6}
 18b0151:	62 f1 4d 48 eb cc    	vpord  %zmm4,%zmm6,%zmm1
 18b0157:	62 71 75 58 db 2d f7 02 cd fe 	vpandd -0x132fd09(%rip){1to16},%zmm1,%zmm13        # 580458 <tier0_emit_x87.operations+0x10>
 18b0161:	62 f1 5d 48 72 d0 02 	vpsrld $0x2,%zmm0,%zmm4
 18b0168:	62 91 7d 48 db f1    	vpandd %zmm25,%zmm0,%zmm6
 18b016e:	62 91 5d 48 db e1    	vpandd %zmm25,%zmm4,%zmm4
 18b0174:	62 d2 15 4a 27 cd    	vptestmd %zmm13,%zmm13,%k1{%k2}
 18b017a:	c5 fc 45 c1          	korw   %k1,%k0,%k0
 18b017e:	c5 7b 93 c8          	kmovd  %k0,%r9d
 18b0182:	c4 e2 30 f2 fe       	andn   %esi,%r9d,%edi
 18b0187:	c5 fb 92 cf          	kmovd  %edi,%k1
 18b018b:	62 e1 3d c9 fe c7    	vpaddd %zmm7,%zmm8,%zmm16{%k1}{z}
 18b0191:	62 71 5d c9 fe fe    	vpaddd %zmm6,%zmm4,%zmm15{%k1}{z}
 18b0197:	62 b1 1d 48 72 f0 10 	vpslld $0x10,%zmm16,%zmm12
 18b019e:	62 d2 06 48 27 c7    	vptestnmd %zmm15,%zmm15,%k0
 18b01a4:	62 c1 1d 48 eb cf    	vpord  %zmm15,%zmm12,%zmm17
 18b01aa:	62 11 0d 48 db e1    	vpandd %zmm25,%zmm14,%zmm12
 18b01b0:	c5 fb 93 f8          	kmovd  %k0,%edi
 18b01b4:	62 51 75 40 fe e4    	vpaddd %zmm12,%zmm17,%zmm12
 18b01ba:	62 33 1d 48 03 f4 0f 	valignd $0xf,%zmm20,%zmm12,%zmm14
 18b01c1:	62 51 1d 48 fe f6    	vpaddd %zmm14,%zmm12,%zmm14
 18b01c7:	62 51 7d 4c 6f f4    	vmovdqa32 %zmm12,%zmm14{%k4}
 18b01cd:	62 33 8d 48 03 e4 07 	valignq $0x7,%zmm20,%zmm14,%zmm12
 18b01d4:	62 51 0d 48 fe e4    	vpaddd %zmm12,%zmm14,%zmm12
 18b01da:	62 51 7d 4d 6f e6    	vmovdqa32 %zmm14,%zmm12{%k5}
 18b01e0:	62 33 9d 48 03 f4 06 	valignq $0x6,%zmm20,%zmm12,%zmm14
 18b01e7:	62 51 1d 48 fe f6    	vpaddd %zmm14,%zmm12,%zmm14
 18b01ed:	62 51 7d 4b 6f f4    	vmovdqa32 %zmm12,%zmm14{%k3}
 18b01f3:	62 33 8d 48 03 e4 04 	valignq $0x4,%zmm20,%zmm14,%zmm12
 18b01fa:	62 e1 0d 48 fe d3    	vpaddd %zmm3,%zmm14,%zmm18
 18b0200:	62 c1 7d 4f 6f d6    	vmovdqa32 %zmm14,%zmm18{%k7}
 18b0206:	62 d1 6d 40 fe dc    	vpaddd %zmm12,%zmm18,%zmm3
 18b020c:	62 b1 7d 4e 6f da    	vmovdqa32 %zmm18,%zmm3{%k6}
 18b0212:	62 a1 65 48 fa d1    	vpsubd %zmm17,%zmm3,%zmm18
 18b0218:	62 71 6d 50 db 25 92 02 cd fe 	vpandd -0x132fd6e(%rip){1to16},%zmm18,%zmm12        # 5804b4 <tier0_emit_x87.operations+0x6c>
 18b0222:	62 f3 1d 58 1f 0d 47 02 cd fe 01 	vpcmpltd -0x132fdb9(%rip){1to16},%zmm12,%k1        # 580474 <tier0_emit_x87.operations+0x2c>
 18b022d:	62 51 1d 48 fe f7    	vpaddd %zmm15,%zmm12,%zmm14
 18b0233:	62 f3 0d 58 1f 05 2e 02 cd fe 01 	vpcmpltd -0x132fdd2(%rip){1to16},%zmm14,%k0        # 58046c <tier0_emit_x87.operations+0x24>
 18b023e:	62 b1 0d 48 72 d2 10 	vpsrld $0x10,%zmm18,%zmm14
 18b0245:	62 f1 1d 48 fe f6    	vpaddd %zmm6,%zmm12,%zmm6
 18b024b:	62 12 1d 48 3b e5    	vpminud %zmm29,%zmm12,%zmm12
 18b0251:	62 a1 0d 48 fe d8    	vpaddd %zmm16,%zmm14,%zmm19
 18b0257:	62 51 0d 48 fe c0    	vpaddd %zmm8,%zmm14,%zmm8
 18b025d:	62 92 4d 48 3b f5    	vpminud %zmm29,%zmm6,%zmm6
 18b0263:	c5 7b 93 d8          	kmovd  %k0,%r11d
 18b0267:	62 b2 7e 40 27 c0    	vptestnmd %zmm16,%zmm16,%k0
 18b026d:	c5 fb 93 d8          	kmovd  %k0,%ebx
 18b0271:	62 f3 65 50 1f 05 f4 01 cd fe 01 	vpcmpltd -0x132fe0c(%rip){1to16},%zmm19,%k0        # 580470 <tier0_emit_x87.operations+0x28>
 18b027c:	41 09 fb             	or     %edi,%r11d
 18b027f:	c5 fb 93 c8          	kmovd  %k0,%ecx
 18b0283:	62 b2 75 40 27 c1    	vptestmd %zmm17,%zmm17,%k0
 18b0289:	c5 fb 93 c0          	kmovd  %k0,%eax
 18b028d:	62 d2 05 49 27 c7    	vptestmd %zmm15,%zmm15,%k0{%k1}
 18b0293:	62 f3 6d 50 1e 0d da 01 cd fe 01 	vpcmpltud -0x132fe26(%rip){1to16},%zmm18,%k1        # 580478 <tier0_emit_x87.operations+0x30>
 18b029e:	09 d9                	or     %ebx,%ecx
 18b02a0:	44 21 d9             	and    %r11d,%ecx
 18b02a3:	c4 e2 70 f2 f8       	andn   %eax,%ecx,%edi
 18b02a8:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18b02b0:	62 b2 7d 41 27 c8    	vptestmd %zmm16,%zmm16,%k1{%k1}
 18b02b6:	c5 f4 45 c0          	korw   %k0,%k1,%k0
 18b02ba:	c5 7b 93 d0          	kmovd  %k0,%r10d
 18b02be:	62 f2 7e 58 27 05 94 01 cd fe 	vptestnmd -0x132fe6c(%rip){1to16},%zmm0,%k0        # 58045c <tier0_emit_x87.operations+0x14>
 18b02c8:	41 21 fa             	and    %edi,%r10d
 18b02cb:	44 09 cf             	or     %r9d,%edi
 18b02ce:	21 f7                	and    %esi,%edi
 18b02d0:	41 89 f9             	mov    %edi,%r9d
 18b02d3:	31 f7                	xor    %esi,%edi
 18b02d5:	c5 7b 93 c0          	kmovd  %k0,%r8d
 18b02d9:	62 f2 75 5a 27 05 a1 01 cd fe 	vptestmd -0x132fe5f(%rip){1to16},%zmm1,%k0{%k2}        # 580484 <tier0_emit_x87.operations+0x3c>
 18b02e3:	62 d2 7e 48 39 d1    	vpmovd2m %zmm9,%k2
 18b02e9:	62 11 fd 48 6f cf    	vmovdqa64 %zmm31,%zmm9
 18b02ef:	62 f1 7d 48 70 c9 ff 	vpshufd $0xff,%zmm1,%zmm1
 18b02f6:	45 21 c1             	and    %r8d,%r9d
 18b02f9:	62 11 0d 4a eb c8    	vpord  %zmm24,%zmm14,%zmm9{%k2}
 18b02ff:	44 21 c7             	and    %r8d,%edi
 18b0302:	62 f3 f5 48 43 c9 ff 	vshufi64x2 $0xff,%zmm1,%zmm1,%zmm1
 18b0309:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 18b030e:	41 89 f8             	mov    %edi,%r8d
 18b0311:	62 51 7d c9 6f db    	vmovdqa32 %zmm11,%zmm11{%k1}{z}
 18b0317:	62 33 25 48 03 fc 0f 	valignd $0xf,%zmm20,%zmm11,%zmm15
 18b031e:	62 51 25 48 fe ff    	vpaddd %zmm15,%zmm11,%zmm15
 18b0324:	62 51 7d 4c 6f fb    	vmovdqa32 %zmm11,%zmm15{%k4}
 18b032a:	62 a3 85 48 03 c4 07 	valignq $0x7,%zmm20,%zmm15,%zmm16
 18b0331:	62 a1 05 48 fe c0    	vpaddd %zmm16,%zmm15,%zmm16
 18b0337:	c5 7b 93 d8          	kmovd  %k0,%r11d
 18b033b:	62 d2 16 48 27 c5    	vptestnmd %zmm13,%zmm13,%k0
 18b0341:	62 f1 15 48 72 d0 14 	vpsrld $0x14,%zmm0,%zmm13
 18b0348:	62 c1 7d 4d 6f c7    	vmovdqa32 %zmm15,%zmm16{%k5}
 18b034e:	62 33 fd 40 03 fc 06 	valignq $0x6,%zmm20,%zmm16,%zmm15
 18b0355:	c5 fb 93 d8          	kmovd  %k0,%ebx
 18b0359:	62 d2 2d 48 27 c2    	vptestmd %zmm10,%zmm10,%k0
 18b035f:	c5 fb 93 c0          	kmovd  %k0,%eax
 18b0363:	44 21 db             	and    %r11d,%ebx
 18b0366:	62 51 7d 40 fe ff    	vpaddd %zmm15,%zmm16,%zmm15
 18b036c:	09 d8                	or     %ebx,%eax
 18b036e:	62 31 7d 4b 6f f8    	vmovdqa32 %zmm16,%zmm15{%k3}
 18b0374:	62 e1 05 48 fe c5    	vpaddd %zmm5,%zmm15,%zmm16
 18b037a:	62 f1 15 58 db 2d f8 00 cd fe 	vpandd -0x132ff08(%rip){1to16},%zmm13,%zmm5        # 58047c <tier0_emit_x87.operations+0x34>
 18b0384:	62 33 85 48 03 d4 04 	valignq $0x4,%zmm20,%zmm15,%zmm10
 18b038b:	44 09 d0             	or     %r10d,%eax
 18b038e:	62 c1 7d 4f 6f c7    	vmovdqa32 %zmm15,%zmm16{%k7}
 18b0394:	62 f1 55 58 66 05 e2 00 cd fe 	vpcmpgtd -0x132ff1e(%rip){1to16},%zmm5,%k0        # 580480 <tier0_emit_x87.operations+0x38>
 18b039e:	62 72 35 40 47 ed    	vpsllvd %zmm5,%zmm25,%zmm13
 18b03a4:	62 d1 7d 40 fe ea    	vpaddd %zmm10,%zmm16,%zmm5
 18b03aa:	62 b1 7d 4e 6f e8    	vmovdqa32 %zmm16,%zmm5{%k6}
 18b03b0:	62 51 55 48 fa d3    	vpsubd %zmm11,%zmm5,%zmm10
 18b03b6:	62 53 25 48 25 db ff 	vpternlogd $0xff,%zmm11,%zmm11,%zmm11
 18b03bd:	62 51 15 48 fe db    	vpaddd %zmm11,%zmm13,%zmm11
 18b03c3:	62 51 2d 48 db db    	vpandd %zmm11,%zmm10,%zmm11
 18b03c9:	62 73 7d 58 25 1d bc 00 cd fe f8 	vpternlogd $0xf8,-0x132ff44(%rip){1to16},%zmm0,%zmm11        # 580490 <tier0_emit_x87.operations+0x48>
 18b03d4:	62 d2 25 48 27 fb    	vptestmd %zmm11,%zmm11,%k7
 18b03da:	c5 fc 45 c7          	korw   %k7,%k0,%k0
 18b03de:	c5 7b 93 d0          	kmovd  %k0,%r10d
 18b03e2:	45 21 ca             	and    %r9d,%r10d
 18b03e5:	41 09 c2             	or     %eax,%r10d
 18b03e8:	48 8b 84 24 40 01 00 00 	mov    0x140(%rsp),%rax
 18b03f0:	41 21 f2             	and    %esi,%r10d
 18b03f3:	c1 ee 08             	shr    $0x8,%esi
 18b03f6:	c4 c1 7b 92 c2       	kmovd  %r10d,%k0
 18b03fb:	62 72 7e 48 38 d8    	vpmovm2d %k0,%zmm11
 18b0401:	62 d1 25 48 72 d3 1f 	vpsrld $0x1f,%zmm11,%zmm11
 18b0408:	62 51 25 49 eb dd    	vpord  %zmm13,%zmm11,%zmm11{%k1}
 18b040e:	62 33 25 48 03 ec 0f 	valignd $0xf,%zmm20,%zmm11,%zmm13
 18b0415:	62 51 25 48 eb ed    	vpord  %zmm13,%zmm11,%zmm13
 18b041b:	62 51 7d 4c 6f eb    	vmovdqa32 %zmm11,%zmm13{%k4}
 18b0421:	62 33 95 48 03 dc 07 	valignq $0x7,%zmm20,%zmm13,%zmm11
 18b0428:	62 51 15 48 eb fb    	vpord  %zmm11,%zmm13,%zmm15
 18b042e:	62 51 7d 4d 6f fd    	vmovdqa32 %zmm13,%zmm15{%k5}
 18b0434:	62 33 85 48 03 dc 06 	valignq $0x6,%zmm20,%zmm15,%zmm11
 18b043b:	62 51 05 48 eb db    	vpord  %zmm11,%zmm15,%zmm11
 18b0441:	62 51 7d 4b 6f df    	vmovdqa32 %zmm15,%zmm11{%k3}
 18b0447:	c5 f8 90 9c 24 f8 00 00 00 	kmovw  0xf8(%rsp),%k3
 18b0450:	62 33 a5 48 03 fc 04 	valignq $0x4,%zmm20,%zmm11,%zmm15
 18b0457:	62 71 7d cb 6f ea    	vmovdqa32 %zmm2,%zmm13{%k3}{z}
 18b045d:	62 d1 15 48 eb d7    	vpord  %zmm15,%zmm13,%zmm2
 18b0463:	62 f1 05 48 72 f0 1f 	vpslld $0x1f,%zmm0,%zmm15
 18b046a:	62 d2 7e 48 39 d7    	vpmovd2m %zmm15,%k2
 18b0470:	62 d1 7d 4e 6f d5    	vmovdqa32 %zmm13,%zmm2{%k6}
 18b0476:	62 12 1d 4a 36 ce    	vpermd %zmm30,%zmm12,%zmm9{%k2}
 18b047c:	62 f2 45 48 27 d7    	vptestmd %zmm7,%zmm7,%k2
 18b0482:	62 91 fd 48 6f ff    	vmovdqa64 %zmm31,%zmm7
 18b0488:	62 91 3d 4a eb f8    	vpord  %zmm24,%zmm8,%zmm7{%k2}
 18b048e:	62 f2 5e 48 27 d4    	vptestnmd %zmm4,%zmm4,%k2
 18b0494:	62 92 4d 48 36 e6    	vpermd %zmm30,%zmm6,%zmm4
 18b049a:	62 51 7d c9 6f c2    	vmovdqa32 %zmm10,%zmm8{%k1}{z}
 18b04a0:	62 f1 7d 4a 6f e7    	vmovdqa32 %zmm7,%zmm4{%k2}
 18b04a6:	62 92 7d 48 27 d4    	vptestmd %zmm28,%zmm0,%k2
 18b04ac:	62 b1 fd 48 6f fd    	vmovdqa64 %zmm21,%zmm7
 18b04b2:	62 f1 7d 48 72 f0 0e 	vpslld $0xe,%zmm0,%zmm0
 18b04b9:	c5 7b 93 ca          	kmovd  %k2,%r9d
 18b04bd:	62 d2 5d 4a 64 f1    	vpblendmd %zmm9,%zmm4,%zmm6{%k2}
 18b04c3:	62 b1 7d 48 db c6    	vpandd %zmm22,%zmm0,%zmm0
 18b04c9:	45 21 c8             	and    %r9d,%r8d
 18b04cc:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 18b04d1:	c4 62 30 f2 c7       	andn   %edi,%r9d,%r8d
 18b04d6:	62 f1 45 4a 72 f4 08 	vpslld $0x8,%zmm4,%zmm7{%k2}
 18b04dd:	c5 fb 92 d7          	kmovd  %edi,%k2
 18b04e1:	62 72 7d ca 58 0d b9 ff cc fe 	vpbroadcastd -0x1330047(%rip),%zmm9{%k2}{z}        # 5804a4 <tier0_emit_x87.operations+0x5c>
 18b04eb:	62 f2 05 42 64 e6    	vpblendmd %zmm6,%zmm31,%zmm4{%k2}
 18b04f1:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 18b04f6:	62 d1 fd 48 6f f0    	vmovdqa64 %zmm8,%zmm6
 18b04fc:	62 b1 7d 4a eb c7    	vpord  %zmm23,%zmm0,%zmm0{%k2}
 18b0502:	62 f1 45 48 eb e4    	vpord  %zmm4,%zmm7,%zmm4
 18b0508:	62 72 7d 49 58 0d 96 ff cc fe 	vpbroadcastd -0x133006a(%rip),%zmm9{%k1}        # 5804a8 <tier0_emit_x87.operations+0x60>
 18b0512:	c5 f8 90 8c 24 e8 00 00 00 	kmovw  0xe8(%rsp),%k1
 18b051b:	62 d3 5d 48 25 c1 fe 	vpternlogd $0xfe,%zmm9,%zmm4,%zmm0
 18b0522:	62 d1 7f 89 6f 24 16 	vmovdqu8 (%r14,%rdx,1),%xmm4{%k1}{z}
 18b0529:	62 f2 2d 40 7e f0    	vpermt2d %zmm0,%zmm26,%zmm6
 18b052f:	62 72 25 40 7e c0    	vpermt2d %zmm0,%zmm27,%zmm8
 18b0535:	62 f1 fe 49 7f 74 d0 ff 	vmovdqu64 %zmm6,-0x40(%rax,%rdx,8){%k1}
 18b053d:	c5 fb 92 ce          	kmovd  %esi,%k1
 18b0541:	48 8b b4 24 28 01 00 00 	mov    0x128(%rsp),%rsi
 18b0549:	62 71 fe 49 7f 04 d0 	vmovdqu64 %zmm8,(%rax,%rdx,8){%k1}
 18b0550:	c5 f9 71 f4 07       	vpsllw $0x7,%xmm4,%xmm0
 18b0555:	62 f2 7e 08 29 c8    	vpmovb2m %xmm0,%k1
 18b055b:	62 d1 6d 48 eb c3    	vpord  %zmm11,%zmm2,%zmm0
 18b0561:	62 f1 7d 48 70 d3 ff 	vpshufd $0xff,%zmm3,%zmm2
 18b0568:	62 f1 7e 49 7f 1c 91 	vmovdqu32 %zmm3,(%rcx,%rdx,4){%k1}
 18b056f:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 18b0577:	62 f3 ed 48 43 da ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm3
 18b057e:	62 f1 7d 48 70 d5 ff 	vpshufd $0xff,%zmm5,%zmm2
 18b0585:	62 f1 7e 49 7f 2c 96 	vmovdqu32 %zmm5,(%rsi,%rdx,4){%k1}
 18b058c:	62 f3 ed 48 43 ea ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm5
 18b0593:	62 f1 7e 49 7f 04 91 	vmovdqu32 %zmm0,(%rcx,%rdx,4){%k1}
 18b059a:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18b05a1:	48 83 c2 10          	add    $0x10,%rdx
 18b05a5:	62 f3 fd 48 43 d0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm2
 18b05ac:	4c 39 e2             	cmp    %r12,%rdx
 18b05af:	0f 82 3d fa ff ff    	jb     18afff2 <run_backend_benchmark+0x89d2>
 18b05b5:	83 bc 24 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rsp)
 18b05bd:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18b05c5:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18b05ca:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18b05cf:	48 8b 8c 24 d0 00 00 00 	mov    0xd0(%rsp),%rcx
 18b05d7:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 18b05df:	0f 84 d0 ea ff ff    	je     18af0b5 <run_backend_benchmark+0x7a95>
 18b05e5:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
 18b05ea:	4c 8d 3c 8d 00 00 00 00 	lea    0x0(,%rcx,4),%r15
 18b05f2:	45 31 f6             	xor    %r14d,%r14d
 18b05f5:	31 db                	xor    %ebx,%ebx
 18b05f7:	eb 2f                	jmp    18b0628 <run_backend_benchmark+0x9008>
 18b05f9:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18b0601:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18b0606:	48 8b bc 24 e0 00 00 00 	mov    0xe0(%rsp),%rdi
 18b060e:	4d 89 ec             	mov    %r13,%r12
 18b0611:	48 ff c3             	inc    %rbx
 18b0614:	49 83 c4 10          	add    $0x10,%r12
 18b0618:	49 83 c6 04          	add    $0x4,%r14
 18b061c:	48 ff c0             	inc    %rax
 18b061f:	4d 39 f7             	cmp    %r14,%r15
 18b0622:	0f 84 8d ea ff ff    	je     18af0b5 <run_backend_benchmark+0x7a95>
 18b0628:	42 8b 14 32          	mov    (%rdx,%r14,1),%edx
 18b062c:	4c 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%r9
 18b0634:	48 8b b4 24 00 01 00 00 	mov    0x100(%rsp),%rsi
 18b063c:	48 89 84 24 a0 00 00 00 	mov    %rax,0xa0(%rsp)
 18b0644:	48 85 d2             	test   %rdx,%rdx
 18b0647:	74 5b                	je     18b06a4 <run_backend_benchmark+0x9084>
 18b0649:	4e 8b 04 77          	mov    (%rdi,%r14,2),%r8
 18b064d:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 18b0655:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
 18b065a:	4d 89 e5             	mov    %r12,%r13
 18b065d:	49 89 dc             	mov    %rbx,%r12
 18b0660:	49 c1 e4 04          	shl    $0x4,%r12
 18b0664:	49 01 d0             	add    %rdx,%r8
 18b0667:	4d 01 dc             	add    %r11,%r12
 18b066a:	42 8b 4c 80 fc       	mov    -0x4(%rax,%r8,4),%ecx
 18b066f:	42 8b 44 86 fc       	mov    -0x4(%rsi,%r8,4),%eax
 18b0674:	47 8b 44 81 fc       	mov    -0x4(%r9,%r8,4),%r8d
 18b0679:	41 b9 04 00 00 00    	mov    $0x4,%r9d
 18b067f:	89 c6                	mov    %eax,%esi
 18b0681:	83 ce 01             	or     $0x1,%esi
 18b0684:	0f b7 f9             	movzwl %cx,%edi
 18b0687:	f3 0f bd f6          	lzcnt  %esi,%esi
 18b068b:	83 f6 1f             	xor    $0x1f,%esi
 18b068e:	83 fe 05             	cmp    $0x5,%esi
 18b0691:	41 0f 42 f1          	cmovb  %r9d,%esi
 18b0695:	83 ff 06             	cmp    $0x6,%edi
 18b0698:	41 b9 06 00 00 00    	mov    $0x6,%r9d
 18b069e:	41 0f 43 f9          	cmovae %r9d,%edi
 18b06a2:	eb 20                	jmp    18b06c4 <run_backend_benchmark+0x90a4>
 18b06a4:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 18b06ac:	4c 8b 5c 24 70       	mov    0x70(%rsp),%r11
 18b06b1:	45 31 c0             	xor    %r8d,%r8d
 18b06b4:	4d 89 e5             	mov    %r12,%r13
 18b06b7:	8b 08                	mov    (%rax),%ecx
 18b06b9:	8b 06                	mov    (%rsi),%eax
 18b06bb:	43 0f b6 7c b3 05    	movzbl 0x5(%r11,%r14,4),%edi
 18b06c1:	40 b6 04             	mov    $0x4,%sil
 18b06c4:	c1 e9 10             	shr    $0x10,%ecx
 18b06c7:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 18b06cd:	45 89 04 24          	mov    %r8d,(%r12)
 18b06d1:	43 88 74 b3 04       	mov    %sil,0x4(%r11,%r14,4)
 18b06d6:	be 00 00 00 00       	mov    $0x0,%esi
 18b06db:	43 88 7c b3 05       	mov    %dil,0x5(%r11,%r14,4)
 18b06e0:	83 f9 08             	cmp    $0x8,%ecx
 18b06e3:	41 0f 43 c9          	cmovae %r9d,%ecx
 18b06e7:	48 85 d2             	test   %rdx,%rdx
 18b06ea:	0f 44 ce             	cmove  %esi,%ecx
 18b06ed:	43 88 4c b3 06       	mov    %cl,0x6(%r11,%r14,4)
 18b06f2:	0f 84 01 ff ff ff    	je     18b05f9 <run_backend_benchmark+0x8fd9>
 18b06f8:	83 e0 01             	and    $0x1,%eax
 18b06fb:	0f 84 f8 fe ff ff    	je     18b05f9 <run_backend_benchmark+0x8fd9>
 18b0701:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18b0706:	48 8b bc 24 a0 00 00 00 	mov    0xa0(%rsp),%rdi
 18b070e:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18b0713:	48 8b b4 24 c0 00 00 00 	mov    0xc0(%rsp),%rsi
 18b071b:	42 8b 0c 30          	mov    (%rax,%r14,1),%ecx
 18b071f:	48 8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%rax
 18b0727:	47 8b 0c 33          	mov    (%r11,%r14,1),%r9d
 18b072b:	39 d1                	cmp    %edx,%ecx
 18b072d:	4a 8b 04 70          	mov    (%rax,%r14,2),%rax
 18b0731:	0f 43 ca             	cmovae %edx,%ecx
 18b0734:	45 31 c0             	xor    %r8d,%r8d
 18b0737:	80 3f 00             	cmpb   $0x0,(%rdi)
 18b073a:	48 8d bc 24 80 0e 00 00 	lea    0xe80(%rsp),%rdi
 18b0742:	48 8d 34 86          	lea    (%rsi,%rax,4),%rsi
 18b0746:	49 8d 04 c2          	lea    (%r10,%rax,8),%rax
 18b074a:	41 0f 95 c0          	setne  %r8b
 18b074e:	48 89 04 24          	mov    %rax,(%rsp)
 18b0752:	c5 f8 77             	vzeroupper
 18b0755:	e8 b6 a4 02 00       	call   18dac10 <abi_assign_call>
 18b075a:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18b075f:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 18b0764:	49 89 04 24          	mov    %rax,(%r12)
 18b0768:	4a 89 54 b1 08       	mov    %rdx,0x8(%rcx,%r14,4)
 18b076d:	e9 87 fe ff ff       	jmp    18b05f9 <run_backend_benchmark+0x8fd9>
 18b0772:	48 89 cf             	mov    %rcx,%rdi
 18b0775:	4c 29 ef             	sub    %r13,%rdi
 18b0778:	4c 89 f2             	mov    %r14,%rdx
 18b077b:	48 29 fa             	sub    %rdi,%rdx
 18b077e:	41 0f 92 c0          	setb   %r8b
 18b0782:	48 81 fa 00 00 80 06 	cmp    $0x6800000,%rdx
 18b0789:	0f 92 c2             	setb   %dl
 18b078c:	44 08 c2             	or     %r8b,%dl
 18b078f:	80 fa 01             	cmp    $0x1,%dl
 18b0792:	75 04                	jne    18b0798 <run_backend_benchmark+0x9178>
 18b0794:	31 d2                	xor    %edx,%edx
 18b0796:	eb 39                	jmp    18b07d1 <run_backend_benchmark+0x91b1>
 18b0798:	48 81 c6 07 00 80 06 	add    $0x6800007,%rsi
 18b079f:	48 81 c7 00 00 80 06 	add    $0x6800000,%rdi
 18b07a6:	48 8d 91 00 00 80 06 	lea    0x6800000(%rcx),%rdx
 18b07ad:	48 89 8c 24 70 01 00 00 	mov    %rcx,0x170(%rsp)
 18b07b5:	48 83 e6 f8          	and    $0xfffffffffffffff8,%rsi
 18b07b9:	48 89 fb             	mov    %rdi,%rbx
 18b07bc:	48 39 d6             	cmp    %rdx,%rsi
 18b07bf:	0f 82 93 c3 ff ff    	jb     18acb58 <run_backend_benchmark+0x5538>
 18b07c5:	48 89 f7             	mov    %rsi,%rdi
 18b07c8:	4c 29 ef             	sub    %r13,%rdi
 18b07cb:	48 89 ca             	mov    %rcx,%rdx
 18b07ce:	48 89 f1             	mov    %rsi,%rcx
 18b07d1:	4c 89 f6             	mov    %r14,%rsi
 18b07d4:	48 29 fe             	sub    %rdi,%rsi
 18b07d7:	41 0f 92 c0          	setb   %r8b
 18b07db:	48 81 fe 00 00 80 00 	cmp    $0x800000,%rsi
 18b07e2:	40 0f 92 c6          	setb   %sil
 18b07e6:	44 08 c6             	or     %r8b,%sil
 18b07e9:	40 80 fe 01          	cmp    $0x1,%sil
 18b07ed:	75 10                	jne    18b07ff <run_backend_benchmark+0x91df>
 18b07ef:	48 c7 84 24 78 01 00 00 00 00 00 00 	movq   $0x0,0x178(%rsp)
 18b07fb:	31 f6                	xor    %esi,%esi
 18b07fd:	eb 38                	jmp    18b0837 <run_backend_benchmark+0x9217>
 18b07ff:	4e 8d 84 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r8
 18b0807:	4a 8d b4 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%rsi
 18b080f:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 18b0816:	48 89 8c 24 78 01 00 00 	mov    %rcx,0x178(%rsp)
 18b081e:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
 18b0822:	49 39 f0             	cmp    %rsi,%r8
 18b0825:	0f 82 3e c3 ff ff    	jb     18acb69 <run_backend_benchmark+0x5549>
 18b082b:	4c 89 c7             	mov    %r8,%rdi
 18b082e:	4c 29 ef             	sub    %r13,%rdi
 18b0831:	48 89 ce             	mov    %rcx,%rsi
 18b0834:	4c 89 c1             	mov    %r8,%rcx
 18b0837:	4d 89 f0             	mov    %r14,%r8
 18b083a:	49 29 f8             	sub    %rdi,%r8
 18b083d:	41 0f 92 c1          	setb   %r9b
 18b0841:	49 81 f8 00 00 80 00 	cmp    $0x800000,%r8
 18b0848:	41 0f 92 c0          	setb   %r8b
 18b084c:	45 08 c8             	or     %r9b,%r8b
 18b084f:	41 80 f8 01          	cmp    $0x1,%r8b
 18b0853:	75 11                	jne    18b0866 <run_backend_benchmark+0x9246>
 18b0855:	48 c7 84 24 80 01 00 00 00 00 00 00 	movq   $0x0,0x180(%rsp)
 18b0861:	45 31 c0             	xor    %r8d,%r8d
 18b0864:	eb 38                	jmp    18b089e <run_backend_benchmark+0x927e>
 18b0866:	4e 8d 8c 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r9
 18b086e:	4e 8d 84 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%r8
 18b0876:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 18b087d:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 18b0885:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
 18b0889:	4d 39 c1             	cmp    %r8,%r9
 18b088c:	0f 82 e8 c2 ff ff    	jb     18acb7a <run_backend_benchmark+0x555a>
 18b0892:	4c 89 cf             	mov    %r9,%rdi
 18b0895:	4c 29 ef             	sub    %r13,%rdi
 18b0898:	49 89 c8             	mov    %rcx,%r8
 18b089b:	4c 89 c9             	mov    %r9,%rcx
 18b089e:	4d 89 f1             	mov    %r14,%r9
 18b08a1:	49 29 f9             	sub    %rdi,%r9
 18b08a4:	41 0f 92 c2          	setb   %r10b
 18b08a8:	49 81 f9 00 00 80 00 	cmp    $0x800000,%r9
 18b08af:	41 0f 92 c1          	setb   %r9b
 18b08b3:	45 08 d1             	or     %r10b,%r9b
 18b08b6:	41 80 f9 01          	cmp    $0x1,%r9b
 18b08ba:	75 26                	jne    18b08e2 <run_backend_benchmark+0x92c2>
 18b08bc:	48 c7 84 24 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rsp)
 18b08c8:	45 31 d2             	xor    %r10d,%r10d
 18b08cb:	eb 4d                	jmp    18b091a <run_backend_benchmark+0x92fa>
 18b08cd:	48 8b 05 54 8f 8e 00 	mov    0x8e8f54(%rip),%rax        # 2199828 <stderr@GLIBC_2.2.5>
 18b08d4:	48 8d 3d 67 7a d7 fe 	lea    -0x1288599(%rip),%rdi        # 628342 <fuzz_comment_end+0x14af3>
 18b08db:	be 7a 00 00 00       	mov    $0x7a,%esi
 18b08e0:	eb 77                	jmp    18b0959 <run_backend_benchmark+0x9339>
 18b08e2:	4e 8d 8c 2f 07 00 80 00 	lea    0x800007(%rdi,%r13,1),%r9
 18b08ea:	4e 8d 94 2f 00 00 80 00 	lea    0x800000(%rdi,%r13,1),%r10
 18b08f2:	48 8d 9f 00 00 80 00 	lea    0x800000(%rdi),%rbx
 18b08f9:	48 89 8c 24 88 01 00 00 	mov    %rcx,0x188(%rsp)
 18b0901:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
 18b0905:	4d 39 d1             	cmp    %r10,%r9
 18b0908:	0f 82 7d c2 ff ff    	jb     18acb8b <run_backend_benchmark+0x556b>
 18b090e:	4c 89 cf             	mov    %r9,%rdi
 18b0911:	4c 29 ef             	sub    %r13,%rdi
 18b0914:	49 89 ca             	mov    %rcx,%r10
 18b0917:	4c 89 c9             	mov    %r9,%rcx
 18b091a:	4d 89 f1             	mov    %r14,%r9
 18b091d:	49 29 f9             	sub    %rdi,%r9
 18b0920:	41 0f 92 c3          	setb   %r11b
 18b0924:	49 81 f9 00 00 80 00 	cmp    $0x800000,%r9
 18b092b:	41 0f 92 c1          	setb   %r9b
 18b092f:	45 08 d9             	or     %r11b,%r9b
 18b0932:	74 40                	je     18b0974 <run_backend_benchmark+0x9354>
 18b0934:	45 31 c9             	xor    %r9d,%r9d
 18b0937:	4c 89 d1             	mov    %r10,%rcx
 18b093a:	e9 4f c2 ff ff       	jmp    18acb8e <run_backend_benchmark+0x556e>
 18b093f:	c6 05 fa 67 14 0d 00 	movb   $0x0,0xd1467fa(%rip)        # e9f7140 <tier0_initialized>
 18b0946:	48 8b 05 db 8e 8e 00 	mov    0x8e8edb(%rip),%rax        # 2199828 <stderr@GLIBC_2.2.5>
 18b094d:	48 8d 3d 7c 6a dd fe 	lea    -0x1229584(%rip),%rdi        # 6873d0 <pp_string_value.meaning+0x2a184>
 18b0954:	be 2d 00 00 00       	mov    $0x2d,%esi
 18b0959:	48 8b 08             	mov    (%rax),%rcx
 18b095c:	ba 01 00 00 00       	mov    $0x1,%edx
 18b0961:	c5 f8 77             	vzeroupper
 18b0964:	e8 17 3b eb fe       	call   764480 <fwrite@plt>
 18b0969:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18b096f:	e9 a7 02 00 00       	jmp    18b0c1b <run_backend_benchmark+0x95fb>
 18b0974:	48 81 c7 00 00 80 00 	add    $0x800000,%rdi
 18b097b:	49 89 c9             	mov    %rcx,%r9
 18b097e:	4c 89 d1             	mov    %r10,%rcx
 18b0981:	48 89 fb             	mov    %rdi,%rbx
 18b0984:	e9 05 c2 ff ff       	jmp    18acb8e <run_backend_benchmark+0x556e>
 18b0989:	41 8b 47 18          	mov    0x18(%r15),%eax
 18b098d:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18b0992:	48 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%rsi
 18b099a:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18b09a2:	41 ff c6             	inc    %r14d
 18b09a5:	48 01 c1             	add    %rax,%rcx
 18b09a8:	8b 84 24 6c 02 00 00 	mov    0x26c(%rsp),%eax
 18b09af:	4c 01 ee             	add    %r13,%rsi
 18b09b2:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18b09b7:	48 01 c2             	add    %rax,%rdx
 18b09ba:	e9 8e 00 00 00       	jmp    18b0a4d <run_backend_benchmark+0x942d>
 18b09bf:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18b09c4:	4d 85 ed             	test   %r13,%r13
 18b09c7:	0f 85 b3 00 00 00    	jne    18b0a80 <run_backend_benchmark+0x9460>
 18b09cd:	e9 d5 00 00 00       	jmp    18b0aa7 <run_backend_benchmark+0x9487>
 18b09d2:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18b09d7:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 18b09df:	48 8b 94 24 30 01 00 00 	mov    0x130(%rsp),%rdx
 18b09e7:	48 8d 35 6b e0 db fe 	lea    -0x1241f95(%rip),%rsi        # 66ea59 <pp_string_value.meaning+0x1180d>
 18b09ee:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18b09f3:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 18b09fb:	48 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%rax
 18b0a03:	48 89 84 24 a8 01 00 00 	mov    %rax,0x1a8(%rsp)
 18b0a0b:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 18b0a13:	48 89 84 24 b0 01 00 00 	mov    %rax,0x1b0(%rsp)
 18b0a1b:	48 8b 05 06 8e 8e 00 	mov    0x8e8e06(%rip),%rax        # 2199828 <stderr@GLIBC_2.2.5>
 18b0a22:	48 8b 38             	mov    (%rax),%rdi
 18b0a25:	31 c0                	xor    %eax,%eax
 18b0a27:	e8 f4 36 eb fe       	call   764120 <fprintf@plt>
 18b0a2c:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18b0a31:	eb 3a                	jmp    18b0a6d <run_backend_benchmark+0x944d>
 18b0a33:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18b0a38:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18b0a3d:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18b0a45:	48 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%rsi
 18b0a4d:	44 89 b4 24 98 01 00 00 	mov    %r14d,0x198(%rsp)
 18b0a55:	48 89 8c 24 a0 01 00 00 	mov    %rcx,0x1a0(%rsp)
 18b0a5d:	48 89 b4 24 a8 01 00 00 	mov    %rsi,0x1a8(%rsp)
 18b0a65:	48 89 94 24 b0 01 00 00 	mov    %rdx,0x1b0(%rsp)
 18b0a6d:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18b0a75:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18b0a7b:	4d 85 ed             	test   %r13,%r13
 18b0a7e:	74 27                	je     18b0aa7 <run_backend_benchmark+0x9487>
 18b0a80:	4c 2b ac 24 38 01 00 00 	sub    0x138(%rsp),%r13
 18b0a88:	48 83 bc 24 60 01 00 00 ff 	cmpq   $0xffffffffffffffff,0x160(%rsp)
 18b0a91:	49 8d b6 00 00 20 00 	lea    0x200000(%r14),%rsi
 18b0a98:	49 0f 44 f6          	cmove  %r14,%rsi
 18b0a9c:	4c 89 ef             	mov    %r13,%rdi
 18b0a9f:	c5 f8 77             	vzeroupper
 18b0aa2:	e8 f9 31 eb fe       	call   763ca0 <munmap@plt>
 18b0aa7:	48 8b bc 24 e0 01 00 00 	mov    0x1e0(%rsp),%rdi
 18b0aaf:	48 85 ff             	test   %rdi,%rdi
 18b0ab2:	74 37                	je     18b0aeb <run_backend_benchmark+0x94cb>
 18b0ab4:	48 8b 84 24 f0 01 00 00 	mov    0x1f0(%rsp),%rax
 18b0abc:	48 2b bc 24 f8 01 00 00 	sub    0x1f8(%rsp),%rdi
 18b0ac4:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18b0acb:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18b0ad2:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18b0ad8:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18b0adf:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18b0ae3:	c5 f8 77             	vzeroupper
 18b0ae6:	e8 b5 31 eb fe       	call   763ca0 <munmap@plt>
 18b0aeb:	48 8b bc 24 c0 01 00 00 	mov    0x1c0(%rsp),%rdi
 18b0af3:	48 85 ff             	test   %rdi,%rdi
 18b0af6:	74 37                	je     18b0b2f <run_backend_benchmark+0x950f>
 18b0af8:	48 8b 84 24 d0 01 00 00 	mov    0x1d0(%rsp),%rax
 18b0b00:	48 2b bc 24 d8 01 00 00 	sub    0x1d8(%rsp),%rdi
 18b0b08:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18b0b0f:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18b0b16:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18b0b1c:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18b0b23:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18b0b27:	c5 f8 77             	vzeroupper
 18b0b2a:	e8 71 31 eb fe       	call   763ca0 <munmap@plt>
 18b0b2f:	48 8b bc 24 20 0e 00 00 	mov    0xe20(%rsp),%rdi
 18b0b37:	48 8d 9c 24 20 0e 00 00 	lea    0xe20(%rsp),%rbx
 18b0b3f:	48 85 ff             	test   %rdi,%rdi
 18b0b42:	74 37                	je     18b0b7b <run_backend_benchmark+0x955b>
 18b0b44:	48 8b 84 24 30 0e 00 00 	mov    0xe30(%rsp),%rax
 18b0b4c:	48 2b bc 24 38 0e 00 00 	sub    0xe38(%rsp),%rdi
 18b0b54:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18b0b5b:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18b0b62:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18b0b68:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18b0b6f:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18b0b73:	c5 f8 77             	vzeroupper
 18b0b76:	e8 25 31 eb fe       	call   763ca0 <munmap@plt>
 18b0b7b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b0b7f:	c5 fd 7f 03          	vmovdqa %ymm0,(%rbx)
 18b0b83:	48 8d 9c 24 40 0e 00 00 	lea    0xe40(%rsp),%rbx
 18b0b8b:	48 8b bc 24 40 0e 00 00 	mov    0xe40(%rsp),%rdi
 18b0b93:	48 85 ff             	test   %rdi,%rdi
 18b0b96:	74 3b                	je     18b0bd3 <run_backend_benchmark+0x95b3>
 18b0b98:	48 8b 84 24 50 0e 00 00 	mov    0xe50(%rsp),%rax
 18b0ba0:	48 2b bc 24 58 0e 00 00 	sub    0xe58(%rsp),%rdi
 18b0ba8:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18b0baf:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18b0bb6:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18b0bbc:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18b0bc3:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18b0bc7:	c5 f8 77             	vzeroupper
 18b0bca:	e8 d1 30 eb fe       	call   763ca0 <munmap@plt>
 18b0bcf:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b0bd3:	c5 fd 7f 03          	vmovdqa %ymm0,(%rbx)
 18b0bd7:	48 8b bc 24 40 0f 00 00 	mov    0xf40(%rsp),%rdi
 18b0bdf:	48 85 ff             	test   %rdi,%rdi
 18b0be2:	74 37                	je     18b0c1b <run_backend_benchmark+0x95fb>
 18b0be4:	48 8b 84 24 50 0f 00 00 	mov    0xf50(%rsp),%rax
 18b0bec:	48 2b bc 24 58 0f 00 00 	sub    0xf58(%rsp),%rdi
 18b0bf4:	48 8d 88 ff 0f 00 00 	lea    0xfff(%rax),%rcx
 18b0bfb:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
 18b0c02:	48 3d 01 00 01 00    	cmp    $0x10001,%rax
 18b0c08:	48 8d b1 00 00 20 00 	lea    0x200000(%rcx),%rsi
 18b0c0f:	48 0f 42 f1          	cmovb  %rcx,%rsi
 18b0c13:	c5 f8 77             	vzeroupper
 18b0c16:	e8 85 30 eb fe       	call   763ca0 <munmap@plt>
 18b0c1b:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18b0c24:	48 3b 84 24 80 2c 00 00 	cmp    0x2c80(%rsp),%rax
 18b0c2c:	0f 85 b9 0b 00 00    	jne    18b17eb <run_backend_benchmark+0xa1cb>
 18b0c32:	44 89 e0             	mov    %r12d,%eax
 18b0c35:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 18b0c39:	5b                   	pop    %rbx
 18b0c3a:	41 5c                	pop    %r12
 18b0c3c:	41 5d                	pop    %r13
 18b0c3e:	41 5e                	pop    %r14
 18b0c40:	41 5f                	pop    %r15
 18b0c42:	5d                   	pop    %rbp
 18b0c43:	c5 f8 77             	vzeroupper
 18b0c46:	c3                   	ret
 18b0c47:	48 bb 00 00 00 00 90 00 00 00 	movabs $0x9000000000,%rbx
 18b0c51:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 18b0c59:	bf 2a 01 00 00       	mov    $0x12a,%edi
 18b0c5e:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 18b0c64:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18b0c69:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b0c6f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b0c73:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 18b0c7e:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 18b0c89:	31 d2                	xor    %edx,%edx
 18b0c8b:	31 c0                	xor    %eax,%eax
 18b0c8d:	48 89 9c 24 80 02 00 00 	mov    %rbx,0x280(%rsp)
 18b0c95:	48 c7 84 24 88 02 00 00 00 00 00 00 	movq   $0x0,0x288(%rsp)
 18b0ca1:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 18b0cad:	c5 f8 77             	vzeroupper
 18b0cb0:	e8 5b 38 eb fe       	call   764510 <syscall@plt>
 18b0cb5:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 18b0cbd:	bf 2a 01 00 00       	mov    $0x12a,%edi
 18b0cc2:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 18b0cc8:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18b0ccd:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b0cd3:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b0cd7:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18b0cdf:	41 89 c6             	mov    %eax,%r14d
 18b0ce2:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 18b0ced:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 18b0cf8:	48 89 9c 24 80 02 00 00 	mov    %rbx,0x280(%rsp)
 18b0d00:	48 c7 84 24 88 02 00 00 01 00 00 00 	movq   $0x1,0x288(%rsp)
 18b0d0c:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 18b0d18:	31 d2                	xor    %edx,%edx
 18b0d1a:	31 c0                	xor    %eax,%eax
 18b0d1c:	c5 f8 77             	vzeroupper
 18b0d1f:	e8 ec 37 eb fe       	call   764510 <syscall@plt>
 18b0d24:	48 89 84 24 b0 00 00 00 	mov    %rax,0xb0(%rsp)
 18b0d2c:	48 c1 e0 20          	shl    $0x20,%rax
 18b0d30:	49 81 c7 a0 08 e0 ff 	add    $0xffffffffffe008a0,%r15
 18b0d37:	48 8d b4 24 80 02 00 00 	lea    0x280(%rsp),%rsi
 18b0d3f:	bf 2a 01 00 00       	mov    $0x12a,%edi
 18b0d44:	41 b9 08 00 00 00    	mov    $0x8,%r9d
 18b0d4a:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18b0d4f:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b0d55:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b0d59:	62 f1 fe 48 7f 84 24 90 02 00 00 	vmovdqu64 %zmm0,0x290(%rsp)
 18b0d64:	62 f1 fe 48 7f 84 24 d0 02 00 00 	vmovdqu64 %zmm0,0x2d0(%rsp)
 18b0d6f:	31 d2                	xor    %edx,%edx
 18b0d71:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18b0d76:	49 09 c6             	or     %rax,%r14
 18b0d79:	48 b8 04 00 00 00 90 00 00 00 	movabs $0x9000000004,%rax
 18b0d83:	48 89 84 24 80 02 00 00 	mov    %rax,0x280(%rsp)
 18b0d8b:	4c 89 bc 24 88 02 00 00 	mov    %r15,0x288(%rsp)
 18b0d93:	31 c0                	xor    %eax,%eax
 18b0d95:	48 c7 84 24 a8 02 00 00 60 00 00 00 	movq   $0x60,0x2a8(%rsp)
 18b0da1:	c5 f8 77             	vzeroupper
 18b0da4:	e8 67 37 eb fe       	call   764510 <syscall@plt>
 18b0da9:	4c 8d ac 24 80 02 00 00 	lea    0x280(%rsp),%r13
 18b0db1:	48 8d 9c 24 68 01 00 00 	lea    0x168(%rsp),%rbx
 18b0db9:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18b0dc1:	49 89 c7             	mov    %rax,%r15
 18b0dc4:	31 f6                	xor    %esi,%esi
 18b0dc6:	4d 89 f0             	mov    %r14,%r8
 18b0dc9:	45 89 f9             	mov    %r15d,%r9d
 18b0dcc:	4c 89 ef             	mov    %r13,%rdi
 18b0dcf:	48 89 da             	mov    %rbx,%rdx
 18b0dd2:	4c 89 e1             	mov    %r12,%rcx
 18b0dd5:	e8 d6 69 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b0dda:	be 01 00 00 00       	mov    $0x1,%esi
 18b0ddf:	4c 89 ef             	mov    %r13,%rdi
 18b0de2:	48 89 da             	mov    %rbx,%rdx
 18b0de5:	4c 89 e1             	mov    %r12,%rcx
 18b0de8:	4d 89 f0             	mov    %r14,%r8
 18b0deb:	45 89 f9             	mov    %r15d,%r9d
 18b0dee:	e8 bd 69 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b0df3:	be 02 00 00 00       	mov    $0x2,%esi
 18b0df8:	4c 89 ef             	mov    %r13,%rdi
 18b0dfb:	48 89 da             	mov    %rbx,%rdx
 18b0dfe:	4c 89 e1             	mov    %r12,%rcx
 18b0e01:	4d 89 f0             	mov    %r14,%r8
 18b0e04:	45 89 f9             	mov    %r15d,%r9d
 18b0e07:	e8 a4 69 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b0e0c:	be 03 00 00 00       	mov    $0x3,%esi
 18b0e11:	4c 89 ef             	mov    %r13,%rdi
 18b0e14:	48 89 da             	mov    %rbx,%rdx
 18b0e17:	4c 89 e1             	mov    %r12,%rcx
 18b0e1a:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
 18b0e1f:	4d 89 f0             	mov    %r14,%r8
 18b0e22:	45 89 f9             	mov    %r15d,%r9d
 18b0e25:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
 18b0e2a:	e8 81 69 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b0e2f:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 18b0e37:	ba 80 0a 00 00       	mov    $0xa80,%edx
 18b0e3c:	31 f6                	xor    %esi,%esi
 18b0e3e:	e8 ed 34 eb fe       	call   764330 <memset@plt>
 18b0e43:	48 8b 84 24 18 01 00 00 	mov    0x118(%rsp),%rax
 18b0e4b:	48 85 c0             	test   %rax,%rax
 18b0e4e:	0f 84 1d 03 00 00    	je     18b1171 <run_backend_benchmark+0x9b51>
 18b0e54:	48 69 c0 40 42 0f 00 	imul   $0xf4240,%rax,%rax
 18b0e5b:	4c 8b a4 24 80 00 00 00 	mov    0x80(%rsp),%r12
 18b0e63:	4c 8d ac 24 18 02 00 00 	lea    0x218(%rsp),%r13
 18b0e6b:	48 c7 84 24 90 00 00 00 00 00 00 00 	movq   $0x0,0x90(%rsp)
 18b0e77:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
 18b0e7c:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18b0e84:	eb 1d                	jmp    18b0ea3 <run_backend_benchmark+0x9883>
 18b0e86:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18b0e8e:	48 ff c2             	inc    %rdx
 18b0e91:	48 89 94 24 90 00 00 00 	mov    %rdx,0x90(%rsp)
 18b0e99:	48 83 fa 15          	cmp    $0x15,%rdx
 18b0e9d:	0f 84 f0 04 00 00    	je     18b1393 <run_backend_benchmark+0x9d73>
 18b0ea3:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
 18b0ea8:	31 c9                	xor    %ecx,%ecx
 18b0eaa:	e9 99 00 00 00       	jmp    18b0f48 <run_backend_benchmark+0x9928>
 18b0eaf:	90                   	nop
 18b0eb0:	85 d2                	test   %edx,%edx
 18b0eb2:	0f 84 d7 00 00 00    	je     18b0f8f <run_backend_benchmark+0x996f>
 18b0eb8:	44 8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%r14d
 18b0ec0:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18b0ec5:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18b0ecd:	48 8d 8c 24 c0 01 00 00 	lea    0x1c0(%rsp),%rcx
 18b0ed5:	4c 89 ef             	mov    %r13,%rdi
 18b0ed8:	41 89 d9             	mov    %ebx,%r9d
 18b0edb:	44 89 f6             	mov    %r14d,%esi
 18b0ede:	c5 f8 77             	vzeroupper
 18b0ee1:	e8 ca 68 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b0ee6:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18b0ef1:	44 89 f0             	mov    %r14d,%eax
 18b0ef4:	48 69 c0 a0 02 00 00 	imul   $0x2a0,%rax,%rax
 18b0efb:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18b0f03:	48 8d 84 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%rax
 18b0f0b:	c5 f8 13 04 c8       	vmovlps %xmm0,(%rax,%rcx,8)
 18b0f10:	c5 f8 17 84 c8 a8 00 00 00 	vmovhps %xmm0,0xa8(%rax,%rcx,8)
 18b0f19:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18b0f1f:	c5 f8 13 84 c8 50 01 00 00 	vmovlps %xmm0,0x150(%rax,%rcx,8)
 18b0f28:	c5 f8 17 84 c8 f8 01 00 00 	vmovhps %xmm0,0x1f8(%rax,%rcx,8)
 18b0f31:	8b 4c 24 78          	mov    0x78(%rsp),%ecx
 18b0f35:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18b0f3d:	ff c1                	inc    %ecx
 18b0f3f:	83 f9 04             	cmp    $0x4,%ecx
 18b0f42:	0f 84 3e ff ff ff    	je     18b0e86 <run_backend_benchmark+0x9866>
 18b0f48:	89 ca                	mov    %ecx,%edx
 18b0f4a:	83 f2 01             	xor    $0x1,%edx
 18b0f4d:	f6 84 24 90 00 00 00 01 	testb  $0x1,0x90(%rsp)
 18b0f55:	89 4c 24 78          	mov    %ecx,0x78(%rsp)
 18b0f59:	0f 44 d1             	cmove  %ecx,%edx
 18b0f5c:	83 f9 02             	cmp    $0x2,%ecx
 18b0f5f:	0f 43 d1             	cmovae %ecx,%edx
 18b0f62:	89 94 24 a0 00 00 00 	mov    %edx,0xa0(%rsp)
 18b0f69:	83 f8 04             	cmp    $0x4,%eax
 18b0f6c:	0f 84 3e ff ff ff    	je     18b0eb0 <run_backend_benchmark+0x9890>
 18b0f72:	39 c2                	cmp    %eax,%edx
 18b0f74:	0f 84 36 ff ff ff    	je     18b0eb0 <run_backend_benchmark+0x9890>
 18b0f7a:	83 f8 03             	cmp    $0x3,%eax
 18b0f7d:	75 b2                	jne    18b0f31 <run_backend_benchmark+0x9911>
 18b0f7f:	83 bc 24 a0 00 00 00 02 	cmpl   $0x2,0xa0(%rsp)
 18b0f87:	0f 84 2b ff ff ff    	je     18b0eb8 <run_backend_benchmark+0x9898>
 18b0f8d:	eb a2                	jmp    18b0f31 <run_backend_benchmark+0x9911>
 18b0f8f:	bf 04 00 00 00       	mov    $0x4,%edi
 18b0f94:	4c 89 ee             	mov    %r13,%rsi
 18b0f97:	c5 f8 77             	vzeroupper
 18b0f9a:	e8 11 2b eb fe       	call   763ab0 <clock_gettime@plt>
 18b0f9f:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 18b0fab:	4c 8b b4 24 20 02 00 00 	mov    0x220(%rsp),%r14
 18b0fb3:	bf 04 00 00 00       	mov    $0x4,%edi
 18b0fb8:	4c 89 ee             	mov    %r13,%rsi
 18b0fbb:	4c 03 74 24 70       	add    0x70(%rsp),%r14
 18b0fc0:	49 01 c6             	add    %rax,%r14
 18b0fc3:	e8 e8 2a eb fe       	call   763ab0 <clock_gettime@plt>
 18b0fc8:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 18b0fd4:	4c 89 74 24 60       	mov    %r14,0x60(%rsp)
 18b0fd9:	48 03 84 24 20 02 00 00 	add    0x220(%rsp),%rax
 18b0fe1:	4c 39 f0             	cmp    %r14,%rax
 18b0fe4:	0f 83 ce fe ff ff    	jae    18b0eb8 <run_backend_benchmark+0x9898>
 18b0fea:	44 8b bc 24 98 01 00 00 	mov    0x198(%rsp),%r15d
 18b0ff2:	4c 8b b4 24 68 01 00 00 	mov    0x168(%rsp),%r14
 18b0ffa:	eb 3d                	jmp    18b1039 <run_backend_benchmark+0x9a19>
 18b0ffc:	0f 1f 40 00          	nopl   0x0(%rax)
 18b1000:	bf 04 00 00 00       	mov    $0x4,%edi
 18b1005:	4c 89 ee             	mov    %r13,%rsi
 18b1008:	e8 a3 2a eb fe       	call   763ab0 <clock_gettime@plt>
 18b100d:	bf 04 00 00 00       	mov    $0x4,%edi
 18b1012:	4c 89 ee             	mov    %r13,%rsi
 18b1015:	e8 96 2a eb fe       	call   763ab0 <clock_gettime@plt>
 18b101a:	48 69 84 24 18 02 00 00 00 ca 9a 3b 	imul   $0x3b9aca00,0x218(%rsp),%rax
 18b1026:	48 03 84 24 20 02 00 00 	add    0x220(%rsp),%rax
 18b102e:	48 3b 44 24 60       	cmp    0x60(%rsp),%rax
 18b1033:	0f 83 7f fe ff ff    	jae    18b0eb8 <run_backend_benchmark+0x9898>
 18b1039:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18b1045:	45 85 e4             	test   %r12d,%r12d
 18b1048:	78 10                	js     18b105a <run_backend_benchmark+0x9a3a>
 18b104a:	ba 08 00 00 00       	mov    $0x8,%edx
 18b104f:	44 89 e7             	mov    %r12d,%edi
 18b1052:	4c 89 ee             	mov    %r13,%rsi
 18b1055:	e8 16 2e eb fe       	call   763e70 <read@plt>
 18b105a:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18b1060:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18b106c:	78 15                	js     18b1083 <run_backend_benchmark+0x9a63>
 18b106e:	ba 08 00 00 00       	mov    $0x8,%edx
 18b1073:	48 8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%rdi
 18b107b:	4c 89 ee             	mov    %r13,%rsi
 18b107e:	e8 ed 2d eb fe       	call   763e70 <read@plt>
 18b1083:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18b108f:	85 db                	test   %ebx,%ebx
 18b1091:	78 0f                	js     18b10a2 <run_backend_benchmark+0x9a82>
 18b1093:	ba 08 00 00 00       	mov    $0x8,%edx
 18b1098:	89 df                	mov    %ebx,%edi
 18b109a:	4c 89 ee             	mov    %r13,%rsi
 18b109d:	e8 ce 2d eb fe       	call   763e70 <read@plt>
 18b10a2:	bf 04 00 00 00       	mov    $0x4,%edi
 18b10a7:	4c 89 ee             	mov    %r13,%rsi
 18b10aa:	e8 01 2a eb fe       	call   763ab0 <clock_gettime@plt>
 18b10af:	4d 85 ff             	test   %r15,%r15
 18b10b2:	74 3e                	je     18b10f2 <run_backend_benchmark+0x9ad2>
 18b10b4:	4c 8b a4 24 c8 01 00 00 	mov    0x1c8(%rsp),%r12
 18b10bc:	31 db                	xor    %ebx,%ebx
 18b10be:	66 90                	xchg   %ax,%ax
 18b10c0:	49 8b 34 de          	mov    (%r14,%rbx,8),%rsi
 18b10c4:	48 8d 94 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdx
 18b10cc:	4c 89 ef             	mov    %r13,%rdi
 18b10cf:	e8 0c 80 01 00       	call   18c90e0 <tier0_compile_scalar>
 18b10d4:	4c 3b a4 24 c8 01 00 00 	cmp    0x1c8(%rsp),%r12
 18b10dc:	0f 87 e7 06 00 00    	ja     18b17c9 <run_backend_benchmark+0xa1a9>
 18b10e2:	48 ff c3             	inc    %rbx
 18b10e5:	4c 89 a4 24 c8 01 00 00 	mov    %r12,0x1c8(%rsp)
 18b10ed:	49 39 df             	cmp    %rbx,%r15
 18b10f0:	75 ce                	jne    18b10c0 <run_backend_benchmark+0x9aa0>
 18b10f2:	4c 8b a4 24 80 00 00 00 	mov    0x80(%rsp),%r12
 18b10fa:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18b1106:	45 85 e4             	test   %r12d,%r12d
 18b1109:	78 10                	js     18b111b <run_backend_benchmark+0x9afb>
 18b110b:	ba 08 00 00 00       	mov    $0x8,%edx
 18b1110:	44 89 e7             	mov    %r12d,%edi
 18b1113:	4c 89 ee             	mov    %r13,%rsi
 18b1116:	e8 55 2d eb fe       	call   763e70 <read@plt>
 18b111b:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18b1121:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
 18b1126:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18b1132:	78 15                	js     18b1149 <run_backend_benchmark+0x9b29>
 18b1134:	ba 08 00 00 00       	mov    $0x8,%edx
 18b1139:	48 8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%rdi
 18b1141:	4c 89 ee             	mov    %r13,%rsi
 18b1144:	e8 27 2d eb fe       	call   763e70 <read@plt>
 18b1149:	48 c7 84 24 18 02 00 00 00 00 00 00 	movq   $0x0,0x218(%rsp)
 18b1155:	85 db                	test   %ebx,%ebx
 18b1157:	0f 88 a3 fe ff ff    	js     18b1000 <run_backend_benchmark+0x99e0>
 18b115d:	ba 08 00 00 00       	mov    $0x8,%edx
 18b1162:	89 df                	mov    %ebx,%edi
 18b1164:	4c 89 ee             	mov    %r13,%rsi
 18b1167:	e8 04 2d eb fe       	call   763e70 <read@plt>
 18b116c:	e9 8f fe ff ff       	jmp    18b1000 <run_backend_benchmark+0x99e0>
 18b1171:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18b1179:	41 b5 01             	mov    $0x1,%r13b
 18b117c:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18b1184:	31 db                	xor    %ebx,%ebx
 18b1186:	44 8d 70 fe          	lea    -0x2(%rax),%r14d
 18b118a:	8d 48 fd             	lea    -0x3(%rax),%ecx
 18b118d:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
 18b1191:	eb 11                	jmp    18b11a4 <run_backend_benchmark+0x9b84>
 18b1193:	48 ff c3             	inc    %rbx
 18b1196:	41 80 f5 01          	xor    $0x1,%r13b
 18b119a:	48 83 fb 15          	cmp    $0x15,%rbx
 18b119e:	0f 84 ef 01 00 00    	je     18b1393 <run_backend_benchmark+0x9d73>
 18b11a4:	89 de                	mov    %ebx,%esi
 18b11a6:	83 e6 01             	and    $0x1,%esi
 18b11a9:	83 f8 04             	cmp    $0x4,%eax
 18b11ac:	74 04                	je     18b11b2 <run_backend_benchmark+0x9b92>
 18b11ae:	39 c6                	cmp    %eax,%esi
 18b11b0:	75 71                	jne    18b1223 <run_backend_benchmark+0x9c03>
 18b11b2:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18b11b7:	48 69 c6 a0 02 00 00 	imul   $0x2a0,%rsi,%rax
 18b11be:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18b11c6:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18b11ce:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18b11d3:	4c 89 e1             	mov    %r12,%rcx
 18b11d6:	4c 8d bc 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%r15
 18b11de:	c5 f8 77             	vzeroupper
 18b11e1:	e8 ca 65 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b11e6:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18b11f1:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18b11f9:	c4 c1 78 13 04 df    	vmovlps %xmm0,(%r15,%rbx,8)
 18b11ff:	c4 c1 78 17 84 df a8 00 00 00 	vmovhps %xmm0,0xa8(%r15,%rbx,8)
 18b1209:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18b120f:	c4 c1 78 13 84 df 50 01 00 00 	vmovlps %xmm0,0x150(%r15,%rbx,8)
 18b1219:	c4 c1 78 17 84 df f8 01 00 00 	vmovhps %xmm0,0x1f8(%r15,%rbx,8)
 18b1223:	89 de                	mov    %ebx,%esi
 18b1225:	f7 d6                	not    %esi
 18b1227:	83 e6 01             	and    $0x1,%esi
 18b122a:	83 f8 04             	cmp    $0x4,%eax
 18b122d:	74 04                	je     18b1233 <run_backend_benchmark+0x9c13>
 18b122f:	39 c6                	cmp    %eax,%esi
 18b1231:	75 78                	jne    18b12ab <run_backend_benchmark+0x9c8b>
 18b1233:	41 0f b6 c5          	movzbl %r13b,%eax
 18b1237:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18b123c:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18b1244:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18b124c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18b1251:	4c 89 e1             	mov    %r12,%rcx
 18b1254:	83 e0 01             	and    $0x1,%eax
 18b1257:	48 69 c0 a0 02 00 00 	imul   $0x2a0,%rax,%rax
 18b125e:	4c 8d bc 04 80 02 00 00 	lea    0x280(%rsp,%rax,1),%r15
 18b1266:	c5 f8 77             	vzeroupper
 18b1269:	e8 42 65 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b126e:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18b1279:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18b1281:	c4 c1 78 13 04 df    	vmovlps %xmm0,(%r15,%rbx,8)
 18b1287:	c4 c1 78 17 84 df a8 00 00 00 	vmovhps %xmm0,0xa8(%r15,%rbx,8)
 18b1291:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18b1297:	c4 c1 78 13 84 df 50 01 00 00 	vmovlps %xmm0,0x150(%r15,%rbx,8)
 18b12a1:	c4 c1 78 17 84 df f8 01 00 00 	vmovhps %xmm0,0x1f8(%r15,%rbx,8)
 18b12ab:	41 83 fe 02          	cmp    $0x2,%r14d
 18b12af:	0f 87 de fe ff ff    	ja     18b1193 <run_backend_benchmark+0x9b73>
 18b12b5:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18b12ba:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18b12c2:	be 02 00 00 00       	mov    $0x2,%esi
 18b12c7:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18b12cf:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18b12d4:	4c 89 e1             	mov    %r12,%rcx
 18b12d7:	c5 f8 77             	vzeroupper
 18b12da:	e8 d1 64 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b12df:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18b12ea:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18b12f2:	83 7c 24 40 01       	cmpl   $0x1,0x40(%rsp)
 18b12f7:	c5 f8 13 84 dc c0 07 00 00 	vmovlps %xmm0,0x7c0(%rsp,%rbx,8)
 18b1300:	c5 f8 17 84 dc 68 08 00 00 	vmovhps %xmm0,0x868(%rsp,%rbx,8)
 18b1309:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18b130f:	c5 f8 13 84 dc 10 09 00 00 	vmovlps %xmm0,0x910(%rsp,%rbx,8)
 18b1318:	c5 f8 17 84 dc b8 09 00 00 	vmovhps %xmm0,0x9b8(%rsp,%rbx,8)
 18b1321:	0f 87 6c fe ff ff    	ja     18b1193 <run_backend_benchmark+0x9b73>
 18b1327:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 18b132c:	48 8d bc 24 18 02 00 00 	lea    0x218(%rsp),%rdi
 18b1334:	be 03 00 00 00       	mov    $0x3,%esi
 18b1339:	48 8d 94 24 68 01 00 00 	lea    0x168(%rsp),%rdx
 18b1341:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18b1346:	4c 89 e1             	mov    %r12,%rcx
 18b1349:	c5 f8 77             	vzeroupper
 18b134c:	e8 5f 64 00 00       	call   18b77b0 <tier0_benchmark_run>
 18b1351:	62 f1 fe 28 7a 84 24 18 02 00 00 	vcvtuqq2pd 0x218(%rsp),%ymm0
 18b135c:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18b1364:	c5 f8 13 84 dc 60 0a 00 00 	vmovlps %xmm0,0xa60(%rsp,%rbx,8)
 18b136d:	c5 f8 17 84 dc 08 0b 00 00 	vmovhps %xmm0,0xb08(%rsp,%rbx,8)
 18b1376:	c4 e3 7d 19 c0 01    	vextractf128 $0x1,%ymm0,%xmm0
 18b137c:	c5 f8 13 84 dc b0 0b 00 00 	vmovlps %xmm0,0xbb0(%rsp,%rbx,8)
 18b1385:	c5 f8 17 84 dc 58 0c 00 00 	vmovhps %xmm0,0xc58(%rsp,%rbx,8)
 18b138e:	e9 00 fe ff ff       	jmp    18b1193 <run_backend_benchmark+0x9b73>
 18b1393:	62 f1 fe 08 7a 54 24 1a 	vcvtuqq2pd 0x1a0(%rsp),%xmm2
 18b139b:	4c 8b 8c 24 b0 01 00 00 	mov    0x1b0(%rsp),%r9
 18b13a3:	8b b4 24 98 01 00 00 	mov    0x198(%rsp),%esi
 18b13aa:	48 8b 8c 24 a8 01 00 00 	mov    0x1a8(%rsp),%rcx
 18b13b2:	48 8b 94 24 a0 01 00 00 	mov    0x1a0(%rsp),%rdx
 18b13ba:	4c 8b 84 24 b8 01 00 00 	mov    0x1b8(%rsp),%r8
 18b13c2:	48 89 c3             	mov    %rax,%rbx
 18b13c5:	48 8d 3d 10 06 e5 fe 	lea    -0x11af9f0(%rip),%rdi        # 7019dc <pp_decode_file_name.meaning+0x2d7e6>
 18b13cc:	b0 02                	mov    $0x2,%al
 18b13ce:	c5 e9 c6 c2 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm0
 18b13d3:	c5 f9 29 54 24 40    	vmovapd %xmm2,0x40(%rsp)
 18b13d9:	c5 f9 29 84 24 b0 00 00 00 	vmovapd %xmm0,0xb0(%rsp)
 18b13e2:	c5 fb 5e c2          	vdivsd %xmm2,%xmm0,%xmm0
 18b13e6:	62 d1 87 08 7b c9    	vcvtusi2sd %r9,%xmm15,%xmm1
 18b13ec:	c5 f3 59 0d ec ec cc fe 	vmulsd -0x1331314(%rip),%xmm1,%xmm1        # 5800e0 <x86_semantics_benchmark_code.registers+0xf0>
 18b13f4:	c5 f3 5e ca          	vdivsd %xmm2,%xmm1,%xmm1
 18b13f8:	c5 f8 77             	vzeroupper
 18b13fb:	e8 b0 2f eb fe       	call   7643b0 <printf@plt>
 18b1400:	48 8d 05 b6 6f d7 fe 	lea    -0x128904a(%rip),%rax        # 6283bd <fuzz_comment_end+0x14b6e>
 18b1407:	48 8d 3d 52 e8 e1 fe 	lea    -0x11e17ae(%rip),%rdi        # 6cfc60 <pp_string_value.meaning+0x72a14>
 18b140e:	48 8d 35 ee 89 e3 fe 	lea    -0x11c7612(%rip),%rsi        # 6e9e03 <pp_decode_file_name.meaning+0x15c0d>
 18b1415:	48 8d 15 e2 5f dd fe 	lea    -0x122a01e(%rip),%rdx        # 6873fe <pp_string_value.meaning+0x2a1b2>
 18b141c:	48 8d 0d f8 79 da fe 	lea    -0x1258608(%rip),%rcx        # 658e1b <fuzz_comment_end+0x455cc>
 18b1423:	4c 8d 05 2e 06 e5 fe 	lea    -0x11af9d2(%rip),%r8        # 701a58 <pp_decode_file_name.meaning+0x2d862>
 18b142a:	4c 8d 0d ef 85 e0 fe 	lea    -0x11f7a11(%rip),%r9        # 6b9a20 <pp_string_value.meaning+0x5c7d4>
 18b1431:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
 18b1436:	48 8d 05 e3 08 d3 fe 	lea    -0x12cf71d(%rip),%rax        # 5e1d20 <foreign_touch.flags+0xe7f3>
 18b143d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 18b1442:	48 8d 05 cc 08 d3 fe 	lea    -0x12cf734(%rip),%rax        # 5e1d15 <foreign_touch.flags+0xe7e8>
 18b1449:	48 89 04 24          	mov    %rax,(%rsp)
 18b144d:	31 c0                	xor    %eax,%eax
 18b144f:	e8 5c 2f eb fe       	call   7643b0 <printf@plt>
 18b1454:	4c 8b 6c 24 50       	mov    0x50(%rsp),%r13
 18b1459:	4c 8b b4 24 98 00 00 00 	mov    0x98(%rsp),%r14
 18b1461:	83 fb 04             	cmp    $0x4,%ebx
 18b1464:	0f 87 8f 02 00 00    	ja     18b16f9 <run_backend_benchmark+0xa0d9>
 18b146a:	c5 fb 12 44 24 40    	vmovddup 0x40(%rsp),%xmm0
 18b1470:	48 8d 0d 4d f1 c6 fe 	lea    -0x1390eb3(%rip),%rcx        # 5205c4 <branch_sizing_patterns+0x834>
 18b1477:	89 d8                	mov    %ebx,%eax
 18b1479:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
 18b147d:	48 01 c8             	add    %rcx,%rax
 18b1480:	c5 f9 29 44 24 60    	vmovapd %xmm0,0x60(%rsp)
 18b1486:	ff e0                	jmp    *%rax
 18b1488:	48 8d bc 24 80 02 00 00 	lea    0x280(%rsp),%rdi
 18b1490:	e8 ab 80 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1495:	48 8d bc 24 28 03 00 00 	lea    0x328(%rsp),%rdi
 18b149d:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 18b14a3:	e8 98 80 00 00       	call   18b9540 <tier0_benchmark_median>
 18b14a8:	48 8d bc 24 d0 03 00 00 	lea    0x3d0(%rsp),%rdi
 18b14b0:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 18b14b9:	e8 82 80 00 00       	call   18b9540 <tier0_benchmark_median>
 18b14be:	48 8d bc 24 78 04 00 00 	lea    0x478(%rsp),%rdi
 18b14c6:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 18b14cf:	e8 6c 80 00 00       	call   18b9540 <tier0_benchmark_median>
 18b14d4:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 18b14dd:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 18b14e6:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 18b14ec:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 18b14f5:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 18b14f9:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b14fd:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 18b1501:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 18b1505:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 18b150b:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 18b1511:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 18b1515:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 18b1519:	75 02                	jne    18b151d <run_backend_benchmark+0x9efd>
 18b151b:	7b 04                	jnp    18b1521 <run_backend_benchmark+0x9f01>
 18b151d:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 18b1521:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 18b1525:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 18b152a:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 18b152f:	48 8d 3d ee 07 d3 fe 	lea    -0x12cf812(%rip),%rdi        # 5e1d24 <foreign_touch.flags+0xe7f7>
 18b1536:	48 8d 35 70 48 d3 fe 	lea    -0x12cb790(%rip),%rsi        # 5e5dad <foreign_touch.flags+0x12880>
 18b153d:	b0 07                	mov    $0x7,%al
 18b153f:	e8 6c 2e eb fe       	call   7643b0 <printf@plt>
 18b1544:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 18b154c:	83 fb 04             	cmp    $0x4,%ebx
 18b154f:	74 12                	je     18b1563 <run_backend_benchmark+0x9f43>
 18b1551:	83 fb 02             	cmp    $0x2,%ebx
 18b1554:	0f 84 db 00 00 00    	je     18b1635 <run_backend_benchmark+0xa015>
 18b155a:	83 fb 01             	cmp    $0x1,%ebx
 18b155d:	0f 85 96 01 00 00    	jne    18b16f9 <run_backend_benchmark+0xa0d9>
 18b1563:	48 8d bc 24 20 05 00 00 	lea    0x520(%rsp),%rdi
 18b156b:	e8 d0 7f 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1570:	48 8d bc 24 c8 05 00 00 	lea    0x5c8(%rsp),%rdi
 18b1578:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 18b157e:	e8 bd 7f 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1583:	48 8d bc 24 70 06 00 00 	lea    0x670(%rsp),%rdi
 18b158b:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 18b1594:	e8 a7 7f 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1599:	48 8d bc 24 18 07 00 00 	lea    0x718(%rsp),%rdi
 18b15a1:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 18b15aa:	e8 91 7f 00 00       	call   18b9540 <tier0_benchmark_median>
 18b15af:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 18b15b8:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 18b15c1:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 18b15c7:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 18b15d0:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 18b15d4:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b15d8:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 18b15dc:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 18b15e0:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 18b15e6:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 18b15ec:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 18b15f0:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 18b15f4:	75 02                	jne    18b15f8 <run_backend_benchmark+0x9fd8>
 18b15f6:	7b 04                	jnp    18b15fc <run_backend_benchmark+0x9fdc>
 18b15f8:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 18b15fc:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 18b1600:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 18b1605:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 18b160a:	48 8d 3d 13 07 d3 fe 	lea    -0x12cf8ed(%rip),%rdi        # 5e1d24 <foreign_touch.flags+0xe7f7>
 18b1611:	48 8d 35 de 0a d3 fe 	lea    -0x12cf522(%rip),%rsi        # 5e20f6 <foreign_touch.flags+0xebc9>
 18b1618:	b0 07                	mov    $0x7,%al
 18b161a:	e8 91 2d eb fe       	call   7643b0 <printf@plt>
 18b161f:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 18b1627:	83 fb 04             	cmp    $0x4,%ebx
 18b162a:	74 09                	je     18b1635 <run_backend_benchmark+0xa015>
 18b162c:	83 fb 02             	cmp    $0x2,%ebx
 18b162f:	0f 85 c4 00 00 00    	jne    18b16f9 <run_backend_benchmark+0xa0d9>
 18b1635:	48 8d bc 24 c0 07 00 00 	lea    0x7c0(%rsp),%rdi
 18b163d:	e8 fe 7e 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1642:	48 8d bc 24 68 08 00 00 	lea    0x868(%rsp),%rdi
 18b164a:	c5 f9 29 44 24 30    	vmovapd %xmm0,0x30(%rsp)
 18b1650:	e8 eb 7e 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1655:	48 8d bc 24 10 09 00 00 	lea    0x910(%rsp),%rdi
 18b165d:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 18b1666:	e8 d5 7e 00 00       	call   18b9540 <tier0_benchmark_median>
 18b166b:	48 8d bc 24 b8 09 00 00 	lea    0x9b8(%rsp),%rdi
 18b1673:	c5 f9 29 84 24 a0 00 00 00 	vmovapd %xmm0,0xa0(%rsp)
 18b167c:	e8 bf 7e 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1681:	c5 f9 28 bc 24 a0 00 00 00 	vmovapd 0xa0(%rsp),%xmm7
 18b168a:	c5 f9 28 b4 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm6
 18b1693:	c5 f9 28 54 24 30    	vmovapd 0x30(%rsp),%xmm2
 18b1699:	c5 f9 28 9c 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm3
 18b16a2:	c5 f9 28 c8          	vmovapd %xmm0,%xmm1
 18b16a6:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b16aa:	c5 e9 14 c6          	vunpcklpd %xmm6,%xmm2,%xmm0
 18b16ae:	c5 c1 14 d2          	vunpcklpd %xmm2,%xmm7,%xmm2
 18b16b2:	c5 f9 5e 44 24 60    	vdivpd 0x60(%rsp),%xmm0,%xmm0
 18b16b8:	c5 e9 5e 54 24 40    	vdivpd 0x40(%rsp),%xmm2,%xmm2
 18b16be:	c5 cb 5e e3          	vdivsd %xmm3,%xmm6,%xmm4
 18b16c2:	c5 f9 2e f5          	vucomisd %xmm5,%xmm6
 18b16c6:	75 02                	jne    18b16ca <run_backend_benchmark+0xa0aa>
 18b16c8:	7b 04                	jnp    18b16ce <run_backend_benchmark+0xa0ae>
 18b16ca:	c5 c3 5e ee          	vdivsd %xmm6,%xmm7,%xmm5
 18b16ce:	c5 f3 5e f3          	vdivsd %xmm3,%xmm1,%xmm6
 18b16d2:	c5 f9 c6 c8 01       	vshufpd $0x1,%xmm0,%xmm0,%xmm1
 18b16d7:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 18b16dc:	48 8d 3d 41 06 d3 fe 	lea    -0x12cf9bf(%rip),%rdi        # 5e1d24 <foreign_touch.flags+0xe7f7>
 18b16e3:	48 8d 35 de 6c d7 fe 	lea    -0x1289322(%rip),%rsi        # 6283c8 <fuzz_comment_end+0x14b79>
 18b16ea:	b0 07                	mov    $0x7,%al
 18b16ec:	e8 bf 2c eb fe       	call   7643b0 <printf@plt>
 18b16f1:	48 8b 9c 24 c8 00 00 00 	mov    0xc8(%rsp),%rbx
 18b16f9:	83 c3 fd             	add    $0xfffffffd,%ebx
 18b16fc:	83 fb 01             	cmp    $0x1,%ebx
 18b16ff:	0f 87 b3 00 00 00    	ja     18b17b8 <run_backend_benchmark+0xa198>
 18b1705:	48 8d bc 24 60 0a 00 00 	lea    0xa60(%rsp),%rdi
 18b170d:	e8 2e 7e 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1712:	48 8d bc 24 08 0b 00 00 	lea    0xb08(%rsp),%rdi
 18b171a:	c5 f9 29 44 24 60    	vmovapd %xmm0,0x60(%rsp)
 18b1720:	e8 1b 7e 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1725:	48 8d bc 24 b0 0b 00 00 	lea    0xbb0(%rsp),%rdi
 18b172d:	c5 fb 11 44 24 30    	vmovsd %xmm0,0x30(%rsp)
 18b1733:	e8 08 7e 00 00       	call   18b9540 <tier0_benchmark_median>
 18b1738:	48 8d bc 24 58 0c 00 00 	lea    0xc58(%rsp),%rdi
 18b1740:	c5 f9 29 84 24 80 00 00 00 	vmovapd %xmm0,0x80(%rsp)
 18b1749:	e8 f2 7d 00 00       	call   18b9540 <tier0_benchmark_median>
 18b174e:	c5 79 28 84 24 80 00 00 00 	vmovapd 0x80(%rsp),%xmm8
 18b1757:	c5 f9 28 64 24 40    	vmovapd 0x40(%rsp),%xmm4
 18b175d:	c5 f9 28 54 24 60    	vmovapd 0x60(%rsp),%xmm2
 18b1763:	c5 fb 10 7c 24 30    	vmovsd 0x30(%rsp),%xmm7
 18b1769:	c5 f9 28 b4 24 b0 00 00 00 	vmovapd 0xb0(%rsp),%xmm6
 18b1772:	c5 f9 28 d8          	vmovapd %xmm0,%xmm3
 18b1776:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b177a:	c5 eb 5e c4          	vdivsd %xmm4,%xmm2,%xmm0
 18b177e:	c5 b9 14 d2          	vunpcklpd %xmm2,%xmm8,%xmm2
 18b1782:	c5 c3 5e cc          	vdivsd %xmm4,%xmm7,%xmm1
 18b1786:	c5 f9 2e fd          	vucomisd %xmm5,%xmm7
 18b178a:	c5 e9 5e d4          	vdivpd %xmm4,%xmm2,%xmm2
 18b178e:	c5 c3 5e e6          	vdivsd %xmm6,%xmm7,%xmm4
 18b1792:	75 02                	jne    18b1796 <run_backend_benchmark+0xa176>
 18b1794:	7b 04                	jnp    18b179a <run_backend_benchmark+0xa17a>
 18b1796:	c5 bb 5e ef          	vdivsd %xmm7,%xmm8,%xmm5
 18b179a:	c5 e3 5e f6          	vdivsd %xmm6,%xmm3,%xmm6
 18b179e:	c5 e9 c6 da 01       	vshufpd $0x1,%xmm2,%xmm2,%xmm3
 18b17a3:	48 8d 3d 7a 05 d3 fe 	lea    -0x12cfa86(%rip),%rdi        # 5e1d24 <foreign_touch.flags+0xe7f7>
 18b17aa:	48 8d 35 51 5f da fe 	lea    -0x125a0af(%rip),%rsi        # 657702 <fuzz_comment_end+0x43eb3>
 18b17b1:	b0 07                	mov    $0x7,%al
 18b17b3:	e8 f8 2b eb fe       	call   7643b0 <printf@plt>
 18b17b8:	45 31 e4             	xor    %r12d,%r12d
 18b17bb:	4d 85 ed             	test   %r13,%r13
 18b17be:	0f 85 bc f2 ff ff    	jne    18b0a80 <run_backend_benchmark+0x9460>
 18b17c4:	e9 de f2 ff ff       	jmp    18b0aa7 <run_backend_benchmark+0x9487>
 18b17c9:	48 8d 3d 27 e8 e1 fe 	lea    -0x11e17d9(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 18b17d0:	48 8d 35 bc 5f dd fe 	lea    -0x122a044(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 18b17d7:	48 8d 0d d0 5f dd fe 	lea    -0x122a030(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 18b17de:	ba bf 00 00 00       	mov    $0xbf,%edx
 18b17e3:	c5 f8 77             	vzeroupper
 18b17e6:	e8 65 23 eb fe       	call   763b50 <__assert_fail@plt>
 18b17eb:	c5 f8 77             	vzeroupper
 18b17ee:	e8 ed 22 eb fe       	call   763ae0 <__stack_chk_fail@plt>
