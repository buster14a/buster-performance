
/home/david/buster-fast-bench/codex-180-fix-20261027-align64/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

000000000150b950 <tier0_tables_open>:
 150b950:	55                   	push   %rbp
 150b951:	41 57                	push   %r15
 150b953:	41 56                	push   %r14
 150b955:	41 55                	push   %r13
 150b957:	41 54                	push   %r12
 150b959:	53                   	push   %rbx
 150b95a:	48 81 ec c8 02 00 00 	sub    $0x2c8,%rsp
 150b961:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 150b96a:	be 00 a0 00 00       	mov    $0xa000,%esi
 150b96f:	ba 03 00 00 00       	mov    $0x3,%edx
 150b974:	b9 22 40 00 00       	mov    $0x4022,%ecx
 150b979:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150b97f:	48 89 fb             	mov    %rdi,%rbx
 150b982:	45 31 f6             	xor    %r14d,%r14d
 150b985:	31 ff                	xor    %edi,%edi
 150b987:	45 31 c9             	xor    %r9d,%r9d
 150b98a:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 150b992:	e8 a9 8b 25 ff       	call   764540 <mmap@plt>
 150b997:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 150b99b:	74 1c                	je     150b9b9 <tier0_tables_open+0x69>
 150b99d:	be 00 a0 00 00       	mov    $0xa000,%esi
 150b9a2:	ba 0f 00 00 00       	mov    $0xf,%edx
 150b9a7:	48 89 c7             	mov    %rax,%rdi
 150b9aa:	49 89 c6             	mov    %rax,%r14
 150b9ad:	e8 3e 8b 25 ff       	call   7644f0 <madvise@plt>
 150b9b2:	b8 99 9e 00 00       	mov    $0x9e99,%eax
 150b9b7:	eb 02                	jmp    150b9bb <tier0_tables_open+0x6b>
 150b9b9:	31 c0                	xor    %eax,%eax
 150b9bb:	be 00 90 00 00       	mov    $0x9000,%esi
 150b9c0:	ba 03 00 00 00       	mov    $0x3,%edx
 150b9c5:	b9 22 40 00 00       	mov    $0x4022,%ecx
 150b9ca:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150b9d0:	4c 89 b3 20 01 00 00 	mov    %r14,0x120(%rbx)
 150b9d7:	48 c7 83 28 01 00 00 00 00 00 00 	movq   $0x0,0x128(%rbx)
 150b9e2:	48 89 83 30 01 00 00 	mov    %rax,0x130(%rbx)
 150b9e9:	48 c7 83 38 01 00 00 00 00 00 00 	movq   $0x0,0x138(%rbx)
 150b9f4:	45 31 ff             	xor    %r15d,%r15d
 150b9f7:	31 ff                	xor    %edi,%edi
 150b9f9:	45 31 c9             	xor    %r9d,%r9d
 150b9fc:	e8 3f 8b 25 ff       	call   764540 <mmap@plt>
 150ba01:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 150ba05:	74 1d                	je     150ba24 <tier0_tables_open+0xd4>
 150ba07:	be 00 90 00 00       	mov    $0x9000,%esi
 150ba0c:	ba 0f 00 00 00       	mov    $0xf,%edx
 150ba11:	48 89 c7             	mov    %rax,%rdi
 150ba14:	49 89 c6             	mov    %rax,%r14
 150ba17:	e8 d4 8a 25 ff       	call   7644f0 <madvise@plt>
 150ba1c:	41 bf 40 80 00 00    	mov    $0x8040,%r15d
 150ba22:	eb 03                	jmp    150ba27 <tier0_tables_open+0xd7>
 150ba24:	45 31 f6             	xor    %r14d,%r14d
 150ba27:	4c 89 b3 40 01 00 00 	mov    %r14,0x140(%rbx)
 150ba2e:	48 c7 83 48 01 00 00 00 00 00 00 	movq   $0x0,0x148(%rbx)
 150ba39:	4c 89 bb 50 01 00 00 	mov    %r15,0x150(%rbx)
 150ba40:	48 c7 83 58 01 00 00 00 00 00 00 	movq   $0x0,0x158(%rbx)
 150ba4b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150ba4f:	48 8b 83 28 01 00 00 	mov    0x128(%rbx),%rax
 150ba56:	c5 fa 7f 84 24 bc 01 00 00 	vmovdqu %xmm0,0x1bc(%rsp)
 150ba5f:	c5 f9 7f 84 24 b0 01 00 00 	vmovdqa %xmm0,0x1b0(%rsp)
 150ba68:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150ba6f:	4c 8d 74 10 3f       	lea    0x3f(%rax,%rdx,1),%r14
 150ba74:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
 150ba78:	49 83 e6 c0          	and    $0xffffffffffffffc0,%r14
 150ba7c:	49 39 ce             	cmp    %rcx,%r14
 150ba7f:	0f 82 6c 10 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150ba85:	4c 89 f1             	mov    %r14,%rcx
 150ba88:	48 29 d1             	sub    %rdx,%rcx
 150ba8b:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150ba92:	48 29 ca             	sub    %rcx,%rdx
 150ba95:	40 0f 92 c6          	setb   %sil
 150ba99:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 150baa0:	0f 92 c2             	setb   %dl
 150baa3:	40 08 f2             	or     %sil,%dl
 150baa6:	0f 85 45 10 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150baac:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 150bab3:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150baba:	4d 85 f6             	test   %r14,%r14
 150babd:	0f 84 2e 10 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bac3:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150bac7:	62 d1 fd 48 7f 06    	vmovdqa64 %zmm0,(%r14)
 150bacd:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150bad4:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150badb:	4c 8d 4c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r9
 150bae0:	48 01 d1             	add    %rdx,%rcx
 150bae3:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 150bae7:	49 39 c9             	cmp    %rcx,%r9
 150baea:	0f 82 01 10 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150baf0:	4c 89 c9             	mov    %r9,%rcx
 150baf3:	48 29 d1             	sub    %rdx,%rcx
 150baf6:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150bafd:	48 29 ca             	sub    %rcx,%rdx
 150bb00:	40 0f 92 c6          	setb   %sil
 150bb04:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 150bb0b:	0f 92 c2             	setb   %dl
 150bb0e:	40 08 f2             	or     %sil,%dl
 150bb11:	0f 85 da 0f 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bb17:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 150bb1e:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150bb25:	4d 85 c9             	test   %r9,%r9
 150bb28:	0f 84 c3 0f 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bb2e:	62 d1 fd 48 7f 01    	vmovdqa64 %zmm0,(%r9)
 150bb34:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150bb3b:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150bb42:	4c 8d 54 11 3f       	lea    0x3f(%rcx,%rdx,1),%r10
 150bb47:	48 01 d1             	add    %rdx,%rcx
 150bb4a:	49 83 e2 c0          	and    $0xffffffffffffffc0,%r10
 150bb4e:	49 39 ca             	cmp    %rcx,%r10
 150bb51:	0f 82 9a 0f 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150bb57:	4c 89 d1             	mov    %r10,%rcx
 150bb5a:	48 29 d1             	sub    %rdx,%rcx
 150bb5d:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150bb64:	48 29 ca             	sub    %rcx,%rdx
 150bb67:	40 0f 92 c6          	setb   %sil
 150bb6b:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 150bb72:	0f 92 c2             	setb   %dl
 150bb75:	40 08 f2             	or     %sil,%dl
 150bb78:	0f 85 73 0f 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bb7e:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 150bb85:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150bb8c:	4d 85 d2             	test   %r10,%r10
 150bb8f:	0f 84 5c 0f 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bb95:	62 d1 fd 48 7f 02    	vmovdqa64 %zmm0,(%r10)
 150bb9b:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150bba2:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150bba9:	4c 8d 5c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r11
 150bbae:	48 01 d1             	add    %rdx,%rcx
 150bbb1:	49 83 e3 c0          	and    $0xffffffffffffffc0,%r11
 150bbb5:	49 39 cb             	cmp    %rcx,%r11
 150bbb8:	0f 82 33 0f 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150bbbe:	4c 89 d9             	mov    %r11,%rcx
 150bbc1:	48 29 d1             	sub    %rdx,%rcx
 150bbc4:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150bbcb:	48 29 ca             	sub    %rcx,%rdx
 150bbce:	40 0f 92 c6          	setb   %sil
 150bbd2:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 150bbd9:	0f 92 c2             	setb   %dl
 150bbdc:	40 08 f2             	or     %sil,%dl
 150bbdf:	0f 85 0c 0f 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bbe5:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 150bbec:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150bbf3:	4d 85 db             	test   %r11,%r11
 150bbf6:	0f 84 f5 0e 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bbfc:	62 d1 fd 48 7f 03    	vmovdqa64 %zmm0,(%r11)
 150bc02:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150bc09:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150bc10:	4c 8d 7c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r15
 150bc15:	48 01 d1             	add    %rdx,%rcx
 150bc18:	49 83 e7 c0          	and    $0xffffffffffffffc0,%r15
 150bc1c:	49 39 cf             	cmp    %rcx,%r15
 150bc1f:	0f 82 cc 0e 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150bc25:	4c 89 f9             	mov    %r15,%rcx
 150bc28:	48 29 d1             	sub    %rdx,%rcx
 150bc2b:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150bc32:	48 29 ca             	sub    %rcx,%rdx
 150bc35:	40 0f 92 c6          	setb   %sil
 150bc39:	48 81 fa 00 09 00 00 	cmp    $0x900,%rdx
 150bc40:	0f 92 c2             	setb   %dl
 150bc43:	40 08 f2             	or     %sil,%dl
 150bc46:	0f 85 a5 0e 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bc4c:	48 81 c1 00 09 00 00 	add    $0x900,%rcx
 150bc53:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150bc5a:	4d 85 ff             	test   %r15,%r15
 150bc5d:	0f 84 8e 0e 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bc63:	62 d1 fd 48 7f 47 03 	vmovdqa64 %zmm0,0xc0(%r15)
 150bc6a:	62 d1 fd 48 7f 47 02 	vmovdqa64 %zmm0,0x80(%r15)
 150bc71:	62 d1 fd 48 7f 47 01 	vmovdqa64 %zmm0,0x40(%r15)
 150bc78:	62 d1 fd 48 7f 07    	vmovdqa64 %zmm0,(%r15)
 150bc7e:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150bc85:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150bc8c:	4c 8d 6c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r13
 150bc91:	48 01 d1             	add    %rdx,%rcx
 150bc94:	49 83 e5 c0          	and    $0xffffffffffffffc0,%r13
 150bc98:	49 39 cd             	cmp    %rcx,%r13
 150bc9b:	0f 82 50 0e 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150bca1:	4c 89 e9             	mov    %r13,%rcx
 150bca4:	48 29 d1             	sub    %rdx,%rcx
 150bca7:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150bcae:	48 29 ca             	sub    %rcx,%rdx
 150bcb1:	40 0f 92 c6          	setb   %sil
 150bcb5:	48 81 fa 00 09 00 00 	cmp    $0x900,%rdx
 150bcbc:	0f 92 c2             	setb   %dl
 150bcbf:	40 08 f2             	or     %sil,%dl
 150bcc2:	0f 85 29 0e 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bcc8:	48 81 c1 00 09 00 00 	add    $0x900,%rcx
 150bccf:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150bcd6:	4d 85 ed             	test   %r13,%r13
 150bcd9:	0f 84 12 0e 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bcdf:	62 d1 fd 48 7f 45 03 	vmovdqa64 %zmm0,0xc0(%r13)
 150bce6:	62 d1 fd 48 7f 45 02 	vmovdqa64 %zmm0,0x80(%r13)
 150bced:	62 d1 fd 48 7f 45 01 	vmovdqa64 %zmm0,0x40(%r13)
 150bcf4:	62 d1 fd 48 7f 45 00 	vmovdqa64 %zmm0,0x0(%r13)
 150bcfb:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150bd02:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150bd09:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150bd0e:	48 01 d1             	add    %rdx,%rcx
 150bd11:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150bd15:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 150bd1a:	48 39 ce             	cmp    %rcx,%rsi
 150bd1d:	0f 82 ce 0d 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150bd23:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 150bd28:	48 29 d1             	sub    %rdx,%rcx
 150bd2b:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150bd32:	48 29 ca             	sub    %rcx,%rdx
 150bd35:	40 0f 92 c6          	setb   %sil
 150bd39:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 150bd40:	0f 92 c2             	setb   %dl
 150bd43:	40 08 f2             	or     %sil,%dl
 150bd46:	0f 85 a5 0d 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bd4c:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 150bd53:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
 150bd59:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150bd60:	0f 84 8b 0d 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bd66:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 150bd6b:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 150bd72:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 150bd79:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 150bd80:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 150bd87:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 150bd8e:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 150bd95:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 150bd9c:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 150bda2:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150bda9:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150bdb0:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150bdb5:	48 01 d1             	add    %rdx,%rcx
 150bdb8:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150bdbc:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
 150bdc1:	48 39 ce             	cmp    %rcx,%rsi
 150bdc4:	0f 82 27 0d 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150bdca:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 150bdcf:	48 29 d1             	sub    %rdx,%rcx
 150bdd2:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150bdd9:	48 29 ca             	sub    %rcx,%rdx
 150bddc:	40 0f 92 c6          	setb   %sil
 150bde0:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 150bde7:	0f 92 c2             	setb   %dl
 150bdea:	40 08 f2             	or     %sil,%dl
 150bded:	0f 85 fe 0c 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bdf3:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 150bdfa:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
 150be00:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150be07:	0f 84 e4 0c 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150be0d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 150be12:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 150be19:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 150be20:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 150be27:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 150be2e:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 150be35:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 150be3c:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 150be43:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 150be49:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150be50:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150be57:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150be5c:	48 01 d1             	add    %rdx,%rcx
 150be5f:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150be63:	48 89 b4 24 80 00 00 00 	mov    %rsi,0x80(%rsp)
 150be6b:	48 39 ce             	cmp    %rcx,%rsi
 150be6e:	0f 82 7d 0c 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150be74:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 150be7c:	48 29 d1             	sub    %rdx,%rcx
 150be7f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150be86:	48 29 ca             	sub    %rcx,%rdx
 150be89:	40 0f 92 c6          	setb   %sil
 150be8d:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 150be94:	0f 92 c2             	setb   %dl
 150be97:	40 08 f2             	or     %sil,%dl
 150be9a:	0f 85 51 0c 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bea0:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 150bea7:	48 83 bc 24 80 00 00 00 00 	cmpq   $0x0,0x80(%rsp)
 150beb0:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150beb7:	0f 84 34 0c 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bebd:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 150bec5:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 150becc:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 150bed3:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 150beda:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 150bee1:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 150bee8:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 150beef:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 150bef6:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 150befc:	48 8b 8b 20 01 00 00 	mov    0x120(%rbx),%rcx
 150bf03:	48 8b b3 28 01 00 00 	mov    0x128(%rbx),%rsi
 150bf0a:	48 8d 54 0e 3f       	lea    0x3f(%rsi,%rcx,1),%rdx
 150bf0f:	48 01 ce             	add    %rcx,%rsi
 150bf12:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 150bf16:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 150bf1b:	48 39 f2             	cmp    %rsi,%rdx
 150bf1e:	0f 82 cd 0b 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150bf24:	49 89 f4             	mov    %rsi,%r12
 150bf27:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 150bf2c:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150bf33:	48 29 ce             	sub    %rcx,%rsi
 150bf36:	48 89 d7             	mov    %rdx,%rdi
 150bf39:	48 29 f7             	sub    %rsi,%rdi
 150bf3c:	41 0f 92 c0          	setb   %r8b
 150bf40:	48 81 ff 04 10 00 00 	cmp    $0x1004,%rdi
 150bf47:	40 0f 92 c7          	setb   %dil
 150bf4b:	44 08 c7             	or     %r8b,%dil
 150bf4e:	0f 85 9d 0b 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bf54:	48 81 c6 04 10 00 00 	add    $0x1004,%rsi
 150bf5b:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 150bf61:	48 89 b3 28 01 00 00 	mov    %rsi,0x128(%rbx)
 150bf68:	0f 84 83 0b 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bf6e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 150bf73:	49 81 c4 7f 10 00 00 	add    $0x107f,%r12
 150bf7a:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
 150bf7e:	4c 89 64 24 60       	mov    %r12,0x60(%rsp)
 150bf83:	48 81 c6 04 10 00 00 	add    $0x1004,%rsi
 150bf8a:	49 39 f4             	cmp    %rsi,%r12
 150bf8d:	0f 82 5e 0b 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150bf93:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 150bf98:	48 29 ce             	sub    %rcx,%rsi
 150bf9b:	48 29 f2             	sub    %rsi,%rdx
 150bf9e:	0f 92 c1             	setb   %cl
 150bfa1:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 150bfa8:	0f 92 c2             	setb   %dl
 150bfab:	08 ca                	or     %cl,%dl
 150bfad:	0f 85 3e 0b 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150bfb3:	48 81 c6 04 02 00 00 	add    $0x204,%rsi
 150bfba:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
 150bfc0:	48 89 b3 28 01 00 00 	mov    %rsi,0x128(%rbx)
 150bfc7:	0f 84 24 0b 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150bfcd:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 150bfd2:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 150bfd8:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150bfdf:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150bfe6:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150bfeb:	48 01 d1             	add    %rdx,%rcx
 150bfee:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150bff2:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 150bff7:	48 39 ce             	cmp    %rcx,%rsi
 150bffa:	0f 82 f1 0a 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c000:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 150c005:	48 29 d1             	sub    %rdx,%rcx
 150c008:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c00f:	48 29 ca             	sub    %rcx,%rdx
 150c012:	40 0f 92 c6          	setb   %sil
 150c016:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 150c01d:	0f 92 c2             	setb   %dl
 150c020:	40 08 f2             	or     %sil,%dl
 150c023:	0f 85 c8 0a 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c029:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 150c030:	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
 150c036:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c03d:	0f 84 ae 0a 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c043:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 150c048:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 150c04e:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c055:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c05c:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c061:	48 01 d1             	add    %rdx,%rcx
 150c064:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c068:	48 89 b4 24 08 01 00 00 	mov    %rsi,0x108(%rsp)
 150c070:	48 39 ce             	cmp    %rcx,%rsi
 150c073:	0f 82 78 0a 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c079:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 150c081:	48 29 d1             	sub    %rdx,%rcx
 150c084:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c08b:	48 29 ca             	sub    %rcx,%rdx
 150c08e:	40 0f 92 c6          	setb   %sil
 150c092:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 150c099:	0f 92 c2             	setb   %dl
 150c09c:	40 08 f2             	or     %sil,%dl
 150c09f:	0f 85 4c 0a 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c0a5:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 150c0ac:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 150c0b5:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c0bc:	0f 84 2f 0a 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c0c2:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 150c0ca:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 150c0d0:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c0d7:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c0de:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c0e3:	48 01 d1             	add    %rdx,%rcx
 150c0e6:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c0ea:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 150c0ef:	48 39 ce             	cmp    %rcx,%rsi
 150c0f2:	0f 82 f9 09 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c0f8:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 150c0fd:	48 29 d1             	sub    %rdx,%rcx
 150c100:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c107:	48 29 ca             	sub    %rcx,%rdx
 150c10a:	40 0f 92 c6          	setb   %sil
 150c10e:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 150c115:	0f 92 c2             	setb   %dl
 150c118:	40 08 f2             	or     %sil,%dl
 150c11b:	0f 85 d0 09 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c121:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 150c128:	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
 150c12e:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c135:	0f 84 b6 09 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c13b:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 150c140:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 150c146:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c14d:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c154:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c159:	48 01 d1             	add    %rdx,%rcx
 150c15c:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c160:	48 89 b4 24 00 01 00 00 	mov    %rsi,0x100(%rsp)
 150c168:	48 39 ce             	cmp    %rcx,%rsi
 150c16b:	0f 82 80 09 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c171:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 150c179:	48 29 d1             	sub    %rdx,%rcx
 150c17c:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c183:	48 29 ca             	sub    %rcx,%rdx
 150c186:	40 0f 92 c6          	setb   %sil
 150c18a:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 150c191:	0f 92 c2             	setb   %dl
 150c194:	40 08 f2             	or     %sil,%dl
 150c197:	0f 85 54 09 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c19d:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 150c1a4:	48 83 bc 24 00 01 00 00 00 	cmpq   $0x0,0x100(%rsp)
 150c1ad:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c1b4:	0f 84 37 09 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c1ba:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 150c1c2:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 150c1c8:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c1cf:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c1d6:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c1db:	48 01 d1             	add    %rdx,%rcx
 150c1de:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c1e2:	48 89 b4 24 a8 00 00 00 	mov    %rsi,0xa8(%rsp)
 150c1ea:	48 39 ce             	cmp    %rcx,%rsi
 150c1ed:	0f 82 fe 08 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c1f3:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 150c1fb:	48 29 d1             	sub    %rdx,%rcx
 150c1fe:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c205:	48 29 ca             	sub    %rcx,%rdx
 150c208:	40 0f 92 c6          	setb   %sil
 150c20c:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 150c213:	0f 92 c2             	setb   %dl
 150c216:	40 08 f2             	or     %sil,%dl
 150c219:	0f 85 d2 08 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c21f:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 150c226:	48 83 bc 24 a8 00 00 00 00 	cmpq   $0x0,0xa8(%rsp)
 150c22f:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c236:	0f 84 b5 08 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c23c:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 150c244:	c6 01 00             	movb   $0x0,(%rcx)
 150c247:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c24e:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c255:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c25a:	48 01 d1             	add    %rdx,%rcx
 150c25d:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c261:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
 150c266:	48 39 ce             	cmp    %rcx,%rsi
 150c269:	0f 82 82 08 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c26f:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 150c274:	48 29 d1             	sub    %rdx,%rcx
 150c277:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c27e:	48 29 ca             	sub    %rcx,%rdx
 150c281:	40 0f 92 c6          	setb   %sil
 150c285:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 150c28c:	0f 92 c2             	setb   %dl
 150c28f:	40 08 f2             	or     %sil,%dl
 150c292:	0f 85 59 08 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c298:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 150c29f:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
 150c2a5:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c2ac:	0f 84 3f 08 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c2b2:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 150c2b7:	c6 01 00             	movb   $0x0,(%rcx)
 150c2ba:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c2c1:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c2c8:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c2cd:	48 01 d1             	add    %rdx,%rcx
 150c2d0:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c2d4:	48 89 b4 24 f8 00 00 00 	mov    %rsi,0xf8(%rsp)
 150c2dc:	48 39 ce             	cmp    %rcx,%rsi
 150c2df:	0f 82 0c 08 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c2e5:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
 150c2ed:	48 29 d1             	sub    %rdx,%rcx
 150c2f0:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c2f7:	48 29 ca             	sub    %rcx,%rdx
 150c2fa:	40 0f 92 c6          	setb   %sil
 150c2fe:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 150c305:	0f 92 c2             	setb   %dl
 150c308:	40 08 f2             	or     %sil,%dl
 150c30b:	0f 85 e0 07 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c311:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 150c318:	48 83 bc 24 f8 00 00 00 00 	cmpq   $0x0,0xf8(%rsp)
 150c321:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c328:	0f 84 c3 07 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c32e:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
 150c336:	c6 01 00             	movb   $0x0,(%rcx)
 150c339:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c340:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c347:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c34c:	48 01 d1             	add    %rdx,%rcx
 150c34f:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c353:	48 89 b4 24 38 01 00 00 	mov    %rsi,0x138(%rsp)
 150c35b:	48 39 ce             	cmp    %rcx,%rsi
 150c35e:	0f 82 8d 07 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c364:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 150c36c:	48 29 d1             	sub    %rdx,%rcx
 150c36f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c376:	48 29 ca             	sub    %rcx,%rdx
 150c379:	40 0f 92 c6          	setb   %sil
 150c37d:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 150c384:	0f 92 c2             	setb   %dl
 150c387:	40 08 f2             	or     %sil,%dl
 150c38a:	0f 85 61 07 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c390:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 150c397:	48 83 bc 24 38 01 00 00 00 	cmpq   $0x0,0x138(%rsp)
 150c3a0:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c3a7:	0f 84 44 07 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c3ad:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 150c3b5:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 150c3bb:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c3c2:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c3c9:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c3ce:	48 01 d1             	add    %rdx,%rcx
 150c3d1:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c3d5:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 150c3dd:	48 39 ce             	cmp    %rcx,%rsi
 150c3e0:	0f 82 0b 07 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c3e6:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 150c3ee:	48 29 d1             	sub    %rdx,%rcx
 150c3f1:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c3f8:	48 29 ca             	sub    %rcx,%rdx
 150c3fb:	40 0f 92 c6          	setb   %sil
 150c3ff:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 150c406:	0f 92 c2             	setb   %dl
 150c409:	40 08 f2             	or     %sil,%dl
 150c40c:	0f 85 df 06 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c412:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 150c419:	48 83 bc 24 a0 00 00 00 00 	cmpq   $0x0,0xa0(%rsp)
 150c422:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c429:	0f 84 c2 06 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c42f:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 150c437:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 150c43d:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c444:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c44b:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c450:	48 01 d1             	add    %rdx,%rcx
 150c453:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c457:	48 89 b4 24 30 01 00 00 	mov    %rsi,0x130(%rsp)
 150c45f:	48 39 ce             	cmp    %rcx,%rsi
 150c462:	0f 82 89 06 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c468:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 150c470:	48 29 d1             	sub    %rdx,%rcx
 150c473:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c47a:	48 29 ca             	sub    %rcx,%rdx
 150c47d:	40 0f 92 c6          	setb   %sil
 150c481:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 150c488:	0f 92 c2             	setb   %dl
 150c48b:	40 08 f2             	or     %sil,%dl
 150c48e:	0f 85 5d 06 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c494:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 150c49b:	48 83 bc 24 30 01 00 00 00 	cmpq   $0x0,0x130(%rsp)
 150c4a4:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c4ab:	0f 84 40 06 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c4b1:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 150c4b9:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 150c4bf:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c4c6:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c4cd:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c4d2:	48 01 d1             	add    %rdx,%rcx
 150c4d5:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c4d9:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
 150c4de:	48 39 ce             	cmp    %rcx,%rsi
 150c4e1:	0f 82 0a 06 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c4e7:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 150c4ec:	48 29 d1             	sub    %rdx,%rcx
 150c4ef:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c4f6:	48 29 ca             	sub    %rcx,%rdx
 150c4f9:	40 0f 92 c6          	setb   %sil
 150c4fd:	48 81 fa 01 02 00 00 	cmp    $0x201,%rdx
 150c504:	0f 92 c2             	setb   %dl
 150c507:	40 08 f2             	or     %sil,%dl
 150c50a:	0f 85 e1 05 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c510:	48 81 c1 01 02 00 00 	add    $0x201,%rcx
 150c517:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
 150c51d:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c524:	0f 84 c7 05 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c52a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 150c52f:	c6 01 00             	movb   $0x0,(%rcx)
 150c532:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c539:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c540:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c545:	48 01 d1             	add    %rdx,%rcx
 150c548:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c54c:	48 89 b4 24 28 01 00 00 	mov    %rsi,0x128(%rsp)
 150c554:	48 39 ce             	cmp    %rcx,%rsi
 150c557:	0f 82 94 05 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c55d:	48 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%rcx
 150c565:	48 29 d1             	sub    %rdx,%rcx
 150c568:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c56f:	48 29 ca             	sub    %rcx,%rdx
 150c572:	40 0f 92 c6          	setb   %sil
 150c576:	48 81 fa 01 02 00 00 	cmp    $0x201,%rdx
 150c57d:	0f 92 c2             	setb   %dl
 150c580:	40 08 f2             	or     %sil,%dl
 150c583:	0f 85 68 05 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c589:	48 81 c1 01 02 00 00 	add    $0x201,%rcx
 150c590:	48 83 bc 24 28 01 00 00 00 	cmpq   $0x0,0x128(%rsp)
 150c599:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c5a0:	0f 84 4b 05 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c5a6:	48 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%rcx
 150c5ae:	c6 01 00             	movb   $0x0,(%rcx)
 150c5b1:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 150c5b8:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 150c5bf:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c5c4:	48 01 d1             	add    %rdx,%rcx
 150c5c7:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c5cb:	48 89 b4 24 c8 00 00 00 	mov    %rsi,0xc8(%rsp)
 150c5d3:	48 39 ce             	cmp    %rcx,%rsi
 150c5d6:	0f 82 15 05 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c5dc:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 150c5e4:	48 29 d1             	sub    %rdx,%rcx
 150c5e7:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 150c5ee:	48 29 ca             	sub    %rcx,%rdx
 150c5f1:	40 0f 92 c6          	setb   %sil
 150c5f5:	48 81 fa 08 10 00 00 	cmp    $0x1008,%rdx
 150c5fc:	0f 92 c2             	setb   %dl
 150c5ff:	40 08 f2             	or     %sil,%dl
 150c602:	0f 85 e9 04 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c608:	48 81 c1 08 10 00 00 	add    $0x1008,%rcx
 150c60f:	48 83 bc 24 c8 00 00 00 00 	cmpq   $0x0,0xc8(%rsp)
 150c618:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 150c61f:	0f 84 cc 04 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c625:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 150c62d:	48 c7 01 00 00 00 00 	movq   $0x0,(%rcx)
 150c634:	48 8b 93 40 01 00 00 	mov    0x140(%rbx),%rdx
 150c63b:	48 8b 8b 48 01 00 00 	mov    0x148(%rbx),%rcx
 150c642:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 150c647:	48 01 d1             	add    %rdx,%rcx
 150c64a:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 150c64e:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 150c653:	48 39 ce             	cmp    %rcx,%rsi
 150c656:	0f 82 95 04 00 00    	jb     150caf1 <tier0_tables_open+0x11a1>
 150c65c:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 150c661:	48 29 d1             	sub    %rdx,%rcx
 150c664:	48 8b 93 50 01 00 00 	mov    0x150(%rbx),%rdx
 150c66b:	48 29 ca             	sub    %rcx,%rdx
 150c66e:	40 0f 92 c6          	setb   %sil
 150c672:	48 81 fa 00 10 00 00 	cmp    $0x1000,%rdx
 150c679:	0f 92 c2             	setb   %dl
 150c67c:	40 08 f2             	or     %sil,%dl
 150c67f:	0f 85 6c 04 00 00    	jne    150caf1 <tier0_tables_open+0x11a1>
 150c685:	48 81 c1 00 10 00 00 	add    $0x1000,%rcx
 150c68c:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 150c692:	48 89 8b 48 01 00 00 	mov    %rcx,0x148(%rbx)
 150c699:	0f 84 52 04 00 00    	je     150caf1 <tier0_tables_open+0x11a1>
 150c69f:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
 150c6a4:	48 8d 83 40 01 00 00 	lea    0x140(%rbx),%rax
 150c6ab:	ba 00 10 00 00       	mov    $0x1000,%edx
 150c6b0:	4c 89 ac 24 d8 00 00 00 	mov    %r13,0xd8(%rsp)
 150c6b8:	4c 89 7c 24 20       	mov    %r15,0x20(%rsp)
 150c6bd:	48 89 1c 24          	mov    %rbx,(%rsp)
 150c6c1:	31 f6                	xor    %esi,%esi
 150c6c3:	45 31 ff             	xor    %r15d,%r15d
 150c6c6:	4d 89 cd             	mov    %r9,%r13
 150c6c9:	4d 89 d4             	mov    %r10,%r12
 150c6cc:	4c 89 db             	mov    %r11,%rbx
 150c6cf:	48 89 84 24 d0 00 00 00 	mov    %rax,0xd0(%rsp)
 150c6d7:	c5 f8 77             	vzeroupper
 150c6da:	e8 51 7c 25 ff       	call   764330 <memset@plt>
 150c6df:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 150c6e4:	41 c6 46 01 01       	movb   $0x1,0x1(%r14)
 150c6e9:	41 c6 45 01 01       	movb   $0x1,0x1(%r13)
 150c6ee:	41 c6 44 24 01 00    	movb   $0x0,0x1(%r12)
 150c6f4:	c6 43 01 00          	movb   $0x0,0x1(%rbx)
 150c6f8:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 150c700:	4c 89 ef             	mov    %r13,%rdi
 150c703:	4d 89 e0             	mov    %r12,%r8
 150c706:	49 89 d9             	mov    %rbx,%r9
 150c709:	48 c7 40 08 01 00 00 00 	movq   $0x1,0x8(%rax)
 150c711:	48 8d 05 a2 36 b9 00 	lea    0xb936a2(%rip),%rax        # 209fdba <type_builtins+0x6a>
 150c718:	41 8d 4f ea          	lea    -0x16(%r15),%ecx
 150c71c:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c71f:	73 43                	jae    150c764 <tier0_tables_open+0xe14>
 150c721:	41 8d 4f eb          	lea    -0x15(%r15),%ecx
 150c725:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c728:	73 7a                	jae    150c7a4 <tier0_tables_open+0xe54>
 150c72a:	41 8d 4f ec          	lea    -0x14(%r15),%ecx
 150c72e:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c731:	0f 83 b1 00 00 00    	jae    150c7e8 <tier0_tables_open+0xe98>
 150c737:	41 8d 4f ed          	lea    -0x13(%r15),%ecx
 150c73b:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c73e:	0f 83 e8 00 00 00    	jae    150c82c <tier0_tables_open+0xedc>
 150c744:	41 8d 4f ee          	lea    -0x12(%r15),%ecx
 150c748:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c74b:	0f 83 1f 01 00 00    	jae    150c870 <tier0_tables_open+0xf20>
 150c751:	49 83 c7 05          	add    $0x5,%r15
 150c755:	48 83 c0 50          	add    $0x50,%rax
 150c759:	49 83 ff 1e          	cmp    $0x1e,%r15
 150c75d:	75 b9                	jne    150c718 <tier0_tables_open+0xdc8>
 150c75f:	e9 54 01 00 00       	jmp    150c8b8 <tier0_tables_open+0xf68>
 150c764:	0f b6 48 be          	movzbl -0x42(%rax),%ecx
 150c768:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 150c770:	0f b6 50 c0          	movzbl -0x40(%rax),%edx
 150c774:	42 88 4c 3e 02       	mov    %cl,0x2(%rsi,%r15,1)
 150c779:	41 8d 4f 02          	lea    0x2(%r15),%ecx
 150c77d:	42 88 4c 3f 02       	mov    %cl,0x2(%rdi,%r15,1)
 150c782:	43 c6 44 38 02 04    	movb   $0x4,0x2(%r8,%r15,1)
 150c788:	43 88 54 39 02       	mov    %dl,0x2(%r9,%r15,1)
 150c78d:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 150c792:	0f b6 48 bf          	movzbl -0x41(%rax),%ecx
 150c796:	4a 89 4c fa 10       	mov    %rcx,0x10(%rdx,%r15,8)
 150c79b:	41 8d 4f eb          	lea    -0x15(%r15),%ecx
 150c79f:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c7a2:	72 86                	jb     150c72a <tier0_tables_open+0xdda>
 150c7a4:	0f b6 48 ce          	movzbl -0x32(%rax),%ecx
 150c7a8:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 150c7b0:	0f b6 50 d0          	movzbl -0x30(%rax),%edx
 150c7b4:	42 88 4c 3e 03       	mov    %cl,0x3(%rsi,%r15,1)
 150c7b9:	41 8d 4f 03          	lea    0x3(%r15),%ecx
 150c7bd:	42 88 4c 3f 03       	mov    %cl,0x3(%rdi,%r15,1)
 150c7c2:	43 c6 44 38 03 04    	movb   $0x4,0x3(%r8,%r15,1)
 150c7c8:	43 88 54 39 03       	mov    %dl,0x3(%r9,%r15,1)
 150c7cd:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 150c7d2:	0f b6 48 cf          	movzbl -0x31(%rax),%ecx
 150c7d6:	4a 89 4c fa 18       	mov    %rcx,0x18(%rdx,%r15,8)
 150c7db:	41 8d 4f ec          	lea    -0x14(%r15),%ecx
 150c7df:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c7e2:	0f 82 4f ff ff ff    	jb     150c737 <tier0_tables_open+0xde7>
 150c7e8:	0f b6 48 de          	movzbl -0x22(%rax),%ecx
 150c7ec:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 150c7f4:	0f b6 50 e0          	movzbl -0x20(%rax),%edx
 150c7f8:	42 88 4c 3e 04       	mov    %cl,0x4(%rsi,%r15,1)
 150c7fd:	41 8d 4f 04          	lea    0x4(%r15),%ecx
 150c801:	42 88 4c 3f 04       	mov    %cl,0x4(%rdi,%r15,1)
 150c806:	43 c6 44 38 04 04    	movb   $0x4,0x4(%r8,%r15,1)
 150c80c:	43 88 54 39 04       	mov    %dl,0x4(%r9,%r15,1)
 150c811:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 150c816:	0f b6 48 df          	movzbl -0x21(%rax),%ecx
 150c81a:	4a 89 4c fa 20       	mov    %rcx,0x20(%rdx,%r15,8)
 150c81f:	41 8d 4f ed          	lea    -0x13(%r15),%ecx
 150c823:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c826:	0f 82 18 ff ff ff    	jb     150c744 <tier0_tables_open+0xdf4>
 150c82c:	0f b6 48 ee          	movzbl -0x12(%rax),%ecx
 150c830:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 150c838:	0f b6 50 f0          	movzbl -0x10(%rax),%edx
 150c83c:	42 88 4c 3e 05       	mov    %cl,0x5(%rsi,%r15,1)
 150c841:	41 8d 4f 05          	lea    0x5(%r15),%ecx
 150c845:	42 88 4c 3f 05       	mov    %cl,0x5(%rdi,%r15,1)
 150c84a:	43 c6 44 38 05 04    	movb   $0x4,0x5(%r8,%r15,1)
 150c850:	43 88 54 39 05       	mov    %dl,0x5(%r9,%r15,1)
 150c855:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 150c85a:	0f b6 48 ef          	movzbl -0x11(%rax),%ecx
 150c85e:	4a 89 4c fa 28       	mov    %rcx,0x28(%rdx,%r15,8)
 150c863:	41 8d 4f ee          	lea    -0x12(%r15),%ecx
 150c867:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 150c86a:	0f 82 e1 fe ff ff    	jb     150c751 <tier0_tables_open+0xe01>
 150c870:	0f b6 48 fe          	movzbl -0x2(%rax),%ecx
 150c874:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 150c87c:	0f b6 10             	movzbl (%rax),%edx
 150c87f:	42 88 4c 3e 06       	mov    %cl,0x6(%rsi,%r15,1)
 150c884:	41 8d 4f 06          	lea    0x6(%r15),%ecx
 150c888:	42 88 4c 3f 06       	mov    %cl,0x6(%rdi,%r15,1)
 150c88d:	43 c6 44 38 06 04    	movb   $0x4,0x6(%r8,%r15,1)
 150c893:	43 88 54 39 06       	mov    %dl,0x6(%r9,%r15,1)
 150c898:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 150c89d:	0f b6 48 ff          	movzbl -0x1(%rax),%ecx
 150c8a1:	4a 89 4c fa 30       	mov    %rcx,0x30(%rdx,%r15,8)
 150c8a6:	49 83 c7 05          	add    $0x5,%r15
 150c8aa:	48 83 c0 50          	add    $0x50,%rax
 150c8ae:	49 83 ff 1e          	cmp    $0x1e,%r15
 150c8b2:	0f 85 60 fe ff ff    	jne    150c718 <tier0_tables_open+0xdc8>
 150c8b8:	c5 fa 7e 0d e0 93 06 ff 	vmovq  -0xf96c20(%rip),%xmm1        # 575ca0 <x86_effects_unknown+0x240>
 150c8c0:	c4 e2 79 31 15 f3 3b 07 ff 	vpmovzxbd -0xf8c40d(%rip),%xmm2        # 5804bc <tier0_emit_x87.operations+0x74>
 150c8c9:	c5 fa 7e 05 df 93 06 ff 	vmovq  -0xf96c21(%rip),%xmm0        # 575cb0 <x86_effects_unknown+0x250>
 150c8d1:	bb 10 11 11 00       	mov    $0x111110,%ebx
 150c8d6:	41 be 02 00 00 00    	mov    $0x2,%r14d
 150c8dc:	41 bf 04 00 00 00    	mov    $0x4,%r15d
 150c8e2:	41 bc 08 00 00 00    	mov    $0x8,%r12d
 150c8e8:	4c 8d 15 61 34 b9 00 	lea    0xb93461(%rip),%r10        # 209fd50 <type_builtins>
 150c8ef:	31 d2                	xor    %edx,%edx
 150c8f1:	45 31 db             	xor    %r11d,%r11d
 150c8f4:	48 0f a3 d3          	bt     %rdx,%rbx
 150c8f8:	73 47                	jae    150c941 <tier0_tables_open+0xff1>
 150c8fa:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 150c902:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 150c907:	c6 44 10 20 06       	movb   $0x6,0x20(%rax,%rdx,1)
 150c90c:	8d 42 20             	lea    0x20(%rdx),%eax
 150c90f:	88 44 17 20          	mov    %al,0x20(%rdi,%rdx,1)
 150c913:	41 c6 44 10 20 04    	movb   $0x4,0x20(%r8,%rdx,1)
 150c919:	43 0f b6 44 5a 0a    	movzbl 0xa(%r10,%r11,2),%eax
 150c91f:	41 88 44 11 20       	mov    %al,0x20(%r9,%rdx,1)
 150c924:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 150c929:	44 89 9c 90 80 00 00 00 	mov    %r11d,0x80(%rax,%rdx,4)
 150c931:	43 0f b6 44 5a 09    	movzbl 0x9(%r10,%r11,2),%eax
 150c937:	01 c0                	add    %eax,%eax
 150c939:	48 89 84 d1 00 01 00 00 	mov    %rax,0x100(%rcx,%rdx,8)
 150c941:	c4 c2 e9 f7 c6       	shlx   %rdx,%r14,%rax
 150c946:	a9 20 22 22 00       	test   $0x222220,%eax
 150c94b:	74 42                	je     150c98f <tier0_tables_open+0x103f>
 150c94d:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 150c955:	48 89 d0             	mov    %rdx,%rax
 150c958:	48 83 c8 21          	or     $0x21,%rax
 150c95c:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 150c961:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 150c965:	88 04 07             	mov    %al,(%rdi,%rax,1)
 150c968:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 150c96d:	43 0f b6 4c 5a 1a    	movzbl 0x1a(%r10,%r11,2),%ecx
 150c973:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 150c977:	41 8d 4b 08          	lea    0x8(%r11),%ecx
 150c97b:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 150c97e:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 150c983:	43 0f b6 4c 5a 19    	movzbl 0x19(%r10,%r11,2),%ecx
 150c989:	01 c9                	add    %ecx,%ecx
 150c98b:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 150c98f:	c4 c2 e9 f7 c7       	shlx   %rdx,%r15,%rax
 150c994:	a9 40 44 40 00       	test   $0x404440,%eax
 150c999:	74 42                	je     150c9dd <tier0_tables_open+0x108d>
 150c99b:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 150c9a3:	48 89 d0             	mov    %rdx,%rax
 150c9a6:	48 83 c8 22          	or     $0x22,%rax
 150c9aa:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 150c9af:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 150c9b3:	88 04 07             	mov    %al,(%rdi,%rax,1)
 150c9b6:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 150c9bb:	43 0f b6 4c 5a 2a    	movzbl 0x2a(%r10,%r11,2),%ecx
 150c9c1:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 150c9c5:	41 8d 4b 10          	lea    0x10(%r11),%ecx
 150c9c9:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 150c9cc:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 150c9d1:	43 0f b6 4c 5a 29    	movzbl 0x29(%r10,%r11,2),%ecx
 150c9d7:	01 c9                	add    %ecx,%ecx
 150c9d9:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 150c9dd:	c4 c2 e9 f7 c4       	shlx   %rdx,%r12,%rax
 150c9e2:	a9 88 88 08 00       	test   $0x88888,%eax
 150c9e7:	74 42                	je     150ca2b <tier0_tables_open+0x10db>
 150c9e9:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 150c9f1:	48 89 d0             	mov    %rdx,%rax
 150c9f4:	48 83 c8 23          	or     $0x23,%rax
 150c9f8:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 150c9fd:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 150ca01:	88 04 07             	mov    %al,(%rdi,%rax,1)
 150ca04:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 150ca09:	43 0f b6 4c 5a 3a    	movzbl 0x3a(%r10,%r11,2),%ecx
 150ca0f:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 150ca13:	41 8d 4b 18          	lea    0x18(%r11),%ecx
 150ca17:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 150ca1a:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 150ca1f:	43 0f b6 4c 5a 39    	movzbl 0x39(%r10,%r11,2),%ecx
 150ca25:	01 c9                	add    %ecx,%ecx
 150ca27:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 150ca2b:	b0 01                	mov    $0x1,%al
 150ca2d:	48 83 c2 04          	add    $0x4,%rdx
 150ca31:	49 83 c3 20          	add    $0x20,%r11
 150ca35:	48 89 84 24 b8 00 00 00 	mov    %rax,0xb8(%rsp)
 150ca3d:	48 83 fa 20          	cmp    $0x20,%rdx
 150ca41:	0f 85 ad fe ff ff    	jne    150c8f4 <tier0_tables_open+0xfa4>
 150ca47:	ba 40 60 00 00       	mov    $0x6040,%edx
 150ca4c:	48 89 bc 24 40 01 00 00 	mov    %rdi,0x140(%rsp)
 150ca54:	4c 89 84 24 18 01 00 00 	mov    %r8,0x118(%rsp)
 150ca5c:	4c 89 4c 24 68       	mov    %r9,0x68(%rsp)
 150ca61:	48 8b 1c 24          	mov    (%rsp),%rbx
 150ca65:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 150ca6a:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 150ca6f:	4c 8b bc 24 08 01 00 00 	mov    0x108(%rsp),%r15
 150ca77:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 150ca7c:	4c 8b 94 24 00 01 00 00 	mov    0x100(%rsp),%r10
 150ca84:	48 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%rdi
 150ca8c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
 150ca91:	4c 8b b4 24 f8 00 00 00 	mov    0xf8(%rsp),%r14
 150ca99:	4c 8b 9c 24 38 01 00 00 	mov    0x138(%rsp),%r11
 150caa1:	4c 8b ac 24 a0 00 00 00 	mov    0xa0(%rsp),%r13
 150caa9:	48 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%rbp
 150cab1:	4c 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%r9
 150cab9:	4c 8b a4 24 c8 00 00 00 	mov    0xc8(%rsp),%r12
 150cac1:	c7 44 24 48 00 00 00 00 	movl   $0x0,0x48(%rsp)
 150cac9:	c7 44 24 30 40 00 00 00 	movl   $0x40,0x30(%rsp)
 150cad1:	c7 84 24 10 01 00 00 00 04 00 00 	movl   $0x400,0x110(%rsp)
 150cadc:	48 89 94 24 48 01 00 00 	mov    %rdx,0x148(%rsp)
 150cae4:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 150caec:	e9 10 01 00 00       	jmp    150cc01 <tier0_tables_open+0x12b1>
 150caf1:	48 3b 83 28 01 00 00 	cmp    0x128(%rbx),%rax
 150caf8:	0f 87 04 4c 00 00    	ja     1511702 <tier0_tables_open+0x5db2>
 150cafe:	48 89 83 28 01 00 00 	mov    %rax,0x128(%rbx)
 150cb05:	b8 c0 01 00 00       	mov    $0x1c0,%eax
 150cb0a:	48 c7 83 48 01 00 00 00 00 00 00 	movq   $0x0,0x148(%rbx)
 150cb15:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150cb19:	c5 fa 7f 84 24 bc 01 00 00 	vmovdqu %xmm0,0x1bc(%rsp)
 150cb22:	c5 f9 7f 84 24 b0 01 00 00 	vmovdqa %xmm0,0x1b0(%rsp)
 150cb2b:	c7 44 24 48 01 00 00 00 	movl   $0x1,0x48(%rsp)
 150cb33:	48 c7 84 24 b8 00 00 00 00 00 00 00 	movq   $0x0,0xb8(%rsp)
 150cb3f:	31 d2                	xor    %edx,%edx
 150cb41:	48 c7 84 24 40 01 00 00 00 00 00 00 	movq   $0x0,0x140(%rsp)
 150cb4d:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 150cb59:	48 c7 44 24 68 00 00 00 00 	movq   $0x0,0x68(%rsp)
 150cb62:	48 c7 44 24 20 00 00 00 00 	movq   $0x0,0x20(%rsp)
 150cb6b:	48 c7 84 24 d8 00 00 00 00 00 00 00 	movq   $0x0,0xd8(%rsp)
 150cb77:	48 c7 44 24 10 00 00 00 00 	movq   $0x0,0x10(%rsp)
 150cb80:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 150cb89:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 150cb95:	c7 44 24 30 00 00 00 00 	movl   $0x0,0x30(%rsp)
 150cb9d:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 150cba6:	c7 84 24 10 01 00 00 00 00 00 00 	movl   $0x0,0x110(%rsp)
 150cbb1:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 150cbb5:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 150cbb9:	31 c9                	xor    %ecx,%ecx
 150cbbb:	45 31 ff             	xor    %r15d,%r15d
 150cbbe:	31 f6                	xor    %esi,%esi
 150cbc0:	45 31 d2             	xor    %r10d,%r10d
 150cbc3:	31 ff                	xor    %edi,%edi
 150cbc5:	45 31 c0             	xor    %r8d,%r8d
 150cbc8:	45 31 f6             	xor    %r14d,%r14d
 150cbcb:	45 31 db             	xor    %r11d,%r11d
 150cbce:	45 31 ed             	xor    %r13d,%r13d
 150cbd1:	31 ed                	xor    %ebp,%ebp
 150cbd3:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
 150cbdc:	45 31 c9             	xor    %r9d,%r9d
 150cbdf:	45 31 e4             	xor    %r12d,%r12d
 150cbe2:	48 c7 84 24 d0 00 00 00 00 00 00 00 	movq   $0x0,0xd0(%rsp)
 150cbee:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 150cbf7:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 150cbff:	31 c0                	xor    %eax,%eax
 150cc01:	48 89 13             	mov    %rdx,(%rbx)
 150cc04:	48 8b 94 24 40 01 00 00 	mov    0x140(%rsp),%rdx
 150cc0c:	48 89 53 08          	mov    %rdx,0x8(%rbx)
 150cc10:	48 8b 94 24 18 01 00 00 	mov    0x118(%rsp),%rdx
 150cc18:	48 89 53 10          	mov    %rdx,0x10(%rbx)
 150cc1c:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 150cc21:	48 89 53 18          	mov    %rdx,0x18(%rbx)
 150cc25:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 150cc2a:	48 89 53 20          	mov    %rdx,0x20(%rbx)
 150cc2e:	48 8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%rdx
 150cc36:	48 89 53 28          	mov    %rdx,0x28(%rbx)
 150cc3a:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 150cc3f:	48 89 53 30          	mov    %rdx,0x30(%rbx)
 150cc43:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 150cc48:	48 89 53 38          	mov    %rdx,0x38(%rbx)
 150cc4c:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 150cc54:	48 89 53 40          	mov    %rdx,0x40(%rbx)
 150cc58:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 150cc5d:	c5 f9 d6 43 48       	vmovq  %xmm0,0x48(%rbx)
 150cc62:	48 89 53 50          	mov    %rdx,0x50(%rbx)
 150cc66:	8b 94 24 10 01 00 00 	mov    0x110(%rsp),%edx
 150cc6d:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%rbx)
 150cc74:	89 53 5c             	mov    %edx,0x5c(%rbx)
 150cc77:	48 89 43 60          	mov    %rax,0x60(%rbx)
 150cc7b:	48 89 4b 68          	mov    %rcx,0x68(%rbx)
 150cc7f:	4c 89 7b 70          	mov    %r15,0x70(%rbx)
 150cc83:	48 89 73 78          	mov    %rsi,0x78(%rbx)
 150cc87:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
 150cc8c:	4c 89 93 80 00 00 00 	mov    %r10,0x80(%rbx)
 150cc93:	48 89 bb 88 00 00 00 	mov    %rdi,0x88(%rbx)
 150cc9a:	4c 89 83 90 00 00 00 	mov    %r8,0x90(%rbx)
 150cca1:	4c 89 b3 98 00 00 00 	mov    %r14,0x98(%rbx)
 150cca8:	c5 f9 d6 93 a0 00 00 00 	vmovq  %xmm2,0xa0(%rbx)
 150ccb0:	48 c7 83 a8 00 00 00 00 00 00 00 	movq   $0x0,0xa8(%rbx)
 150ccbb:	4c 89 9b b0 00 00 00 	mov    %r11,0xb0(%rbx)
 150ccc2:	4c 89 ab b8 00 00 00 	mov    %r13,0xb8(%rbx)
 150ccc9:	48 89 ab c0 00 00 00 	mov    %rbp,0xc0(%rbx)
 150ccd0:	4c 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%r10
 150ccd8:	8b 54 24 30          	mov    0x30(%rsp),%edx
 150ccdc:	8b 4c 24 48          	mov    0x48(%rsp),%ecx
 150cce0:	4c 8b bc 24 48 01 00 00 	mov    0x148(%rsp),%r15
 150cce8:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150ccee:	31 ed                	xor    %ebp,%ebp
 150ccf0:	31 ff                	xor    %edi,%edi
 150ccf2:	48 89 b3 c8 00 00 00 	mov    %rsi,0xc8(%rbx)
 150ccf9:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
 150ccfe:	4c 89 8b d0 00 00 00 	mov    %r9,0xd0(%rbx)
 150cd05:	4c 89 a3 d8 00 00 00 	mov    %r12,0xd8(%rbx)
 150cd0c:	c5 f9 d6 8b e0 00 00 00 	vmovq  %xmm1,0xe0(%rbx)
 150cd14:	4c 89 93 e8 00 00 00 	mov    %r10,0xe8(%rbx)
 150cd1b:	45 8d b7 c0 0f 00 00 	lea    0xfc0(%r15),%r14d
 150cd22:	45 31 c9             	xor    %r9d,%r9d
 150cd25:	41 81 e6 00 70 00 00 	and    $0x7000,%r14d
 150cd2c:	48 89 b3 f0 00 00 00 	mov    %rsi,0xf0(%rbx)
 150cd33:	89 93 f8 00 00 00    	mov    %edx,0xf8(%rbx)
 150cd39:	c7 83 fc 00 00 00 00 00 00 00 	movl   $0x0,0xfc(%rbx)
 150cd43:	89 8b 00 01 00 00    	mov    %ecx,0x100(%rbx)
 150cd49:	ba 03 00 00 00       	mov    $0x3,%edx
 150cd4e:	b9 22 40 00 00       	mov    $0x4022,%ecx
 150cd53:	4c 89 f6             	mov    %r14,%rsi
 150cd56:	c5 f8 10 84 24 bc 01 00 00 	vmovups 0x1bc(%rsp),%xmm0
 150cd5f:	c5 f8 11 83 10 01 00 00 	vmovups %xmm0,0x110(%rbx)
 150cd67:	c5 f9 6f 84 24 b0 01 00 00 	vmovdqa 0x1b0(%rsp),%xmm0
 150cd70:	c5 fa 7f 83 04 01 00 00 	vmovdqu %xmm0,0x104(%rbx)
 150cd78:	c5 f8 77             	vzeroupper
 150cd7b:	e8 c0 77 25 ff       	call   764540 <mmap@plt>
 150cd80:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 150cd84:	74 18                	je     150cd9e <tier0_tables_open+0x144e>
 150cd86:	ba 0f 00 00 00       	mov    $0xf,%edx
 150cd8b:	49 89 c4             	mov    %rax,%r12
 150cd8e:	48 89 c7             	mov    %rax,%rdi
 150cd91:	4c 89 f6             	mov    %r14,%rsi
 150cd94:	e8 57 77 25 ff       	call   7644f0 <madvise@plt>
 150cd99:	4c 89 fd             	mov    %r15,%rbp
 150cd9c:	eb 03                	jmp    150cda1 <tier0_tables_open+0x1451>
 150cd9e:	45 31 e4             	xor    %r12d,%r12d
 150cda1:	80 bc 24 b8 00 00 00 00 	cmpb   $0x0,0xb8(%rsp)
 150cda9:	4c 89 a3 40 02 00 00 	mov    %r12,0x240(%rbx)
 150cdb0:	48 c7 83 48 02 00 00 00 00 00 00 	movq   $0x0,0x248(%rbx)
 150cdbb:	48 89 ab 50 02 00 00 	mov    %rbp,0x250(%rbx)
 150cdc2:	48 c7 83 58 02 00 00 00 00 00 00 	movq   $0x0,0x258(%rbx)
 150cdcd:	0f 84 ac 00 00 00    	je     150ce7f <tier0_tables_open+0x152f>
 150cdd3:	44 8b 7b 4c          	mov    0x4c(%rbx),%r15d
 150cdd7:	49 8d 44 24 3f       	lea    0x3f(%r12),%rax
 150cddc:	4c 8d b3 80 01 00 00 	lea    0x180(%rbx),%r14
 150cde3:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 150cde7:	48 89 c2             	mov    %rax,%rdx
 150cdea:	4c 29 e2             	sub    %r12,%rdx
 150cded:	72 25                	jb     150ce14 <tier0_tables_open+0x14c4>
 150cdef:	4c 89 f9             	mov    %r15,%rcx
 150cdf2:	48 c1 e1 04          	shl    $0x4,%rcx
 150cdf6:	48 89 ee             	mov    %rbp,%rsi
 150cdf9:	48 29 d6             	sub    %rdx,%rsi
 150cdfc:	40 0f 92 c7          	setb   %dil
 150ce00:	48 39 f1             	cmp    %rsi,%rcx
 150ce03:	40 0f 97 c6          	seta   %sil
 150ce07:	40 08 fe             	or     %dil,%sil
 150ce0a:	40 80 fe 01          	cmp    $0x1,%sil
 150ce0e:	0f 85 99 00 00 00    	jne    150cead <tier0_tables_open+0x155d>
 150ce14:	49 c7 06 00 00 00 00 	movq   $0x0,(%r14)
 150ce1b:	48 c7 83 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rbx)
 150ce26:	48 c7 83 90 01 00 00 00 00 00 00 	movq   $0x0,0x190(%rbx)
 150ce31:	48 c7 83 98 01 00 00 00 00 00 00 	movq   $0x0,0x198(%rbx)
 150ce3c:	48 c7 83 a0 01 00 00 00 00 00 00 	movq   $0x0,0x1a0(%rbx)
 150ce47:	48 c7 83 a8 01 00 00 00 00 00 00 	movq   $0x0,0x1a8(%rbx)
 150ce52:	c4 e2 79 21 05 65 36 07 ff 	vpmovsxbd -0xf8c99b(%rip),%xmm0        # 5804c0 <tier0_emit_x87.operations+0x78>
 150ce5b:	48 c7 83 b0 01 00 00 00 00 00 00 	movq   $0x0,0x1b0(%rbx)
 150ce66:	c4 c3 79 22 c7 00    	vpinsrd $0x0,%r15d,%xmm0,%xmm0
 150ce6c:	c5 fa 7f 83 b8 01 00 00 	vmovdqu %xmm0,0x1b8(%rbx)
 150ce74:	48 c7 83 48 02 00 00 00 00 00 00 	movq   $0x0,0x248(%rbx)
 150ce7f:	31 c0                	xor    %eax,%eax
 150ce81:	64 48 8b 0c 25 28 00 00 00 	mov    %fs:0x28,%rcx
 150ce8a:	48 3b 8c 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rcx
 150ce92:	0f 85 92 12 00 00    	jne    150e12a <tier0_tables_open+0x27da>
 150ce98:	48 81 c4 c8 02 00 00 	add    $0x2c8,%rsp
 150ce9f:	5b                   	pop    %rbx
 150cea0:	41 5c                	pop    %r12
 150cea2:	41 5d                	pop    %r13
 150cea4:	41 5e                	pop    %r14
 150cea6:	41 5f                	pop    %r15
 150cea8:	5d                   	pop    %rbp
 150cea9:	c5 f8 77             	vzeroupper
 150ceac:	c3                   	ret
 150cead:	48 01 ca             	add    %rcx,%rdx
 150ceb0:	48 89 93 48 02 00 00 	mov    %rdx,0x248(%rbx)
 150ceb7:	48 89 83 80 01 00 00 	mov    %rax,0x180(%rbx)
 150cebe:	48 85 c0             	test   %rax,%rax
 150cec1:	0f 84 54 ff ff ff    	je     150ce1b <tier0_tables_open+0x14cb>
 150cec7:	48 8d 7c 01 30       	lea    0x30(%rcx,%rax,1),%rdi
 150cecc:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
 150ced0:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 150ced4:	48 39 d7             	cmp    %rdx,%rdi
 150ced7:	0f 82 3e ff ff ff    	jb     150ce1b <tier0_tables_open+0x14cb>
 150cedd:	48 89 f8             	mov    %rdi,%rax
 150cee0:	4a 8d 14 bd 00 00 00 00 	lea    0x0(,%r15,4),%rdx
 150cee8:	4c 29 e0             	sub    %r12,%rax
 150ceeb:	48 89 e9             	mov    %rbp,%rcx
 150ceee:	48 29 c1             	sub    %rax,%rcx
 150cef1:	40 0f 92 c6          	setb   %sil
 150cef5:	48 39 ca             	cmp    %rcx,%rdx
 150cef8:	0f 97 c1             	seta   %cl
 150cefb:	40 08 f1             	or     %sil,%cl
 150cefe:	80 f9 01             	cmp    $0x1,%cl
 150cf01:	0f 84 14 ff ff ff    	je     150ce1b <tier0_tables_open+0x14cb>
 150cf07:	48 01 d0             	add    %rdx,%rax
 150cf0a:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 150cf11:	48 89 bb 88 01 00 00 	mov    %rdi,0x188(%rbx)
 150cf18:	48 85 ff             	test   %rdi,%rdi
 150cf1b:	0f 84 05 ff ff ff    	je     150ce26 <tier0_tables_open+0x14d6>
 150cf21:	48 8d 4c 17 3c       	lea    0x3c(%rdi,%rdx,1),%rcx
 150cf26:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
 150cf2a:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 150cf2e:	48 39 c1             	cmp    %rax,%rcx
 150cf31:	0f 82 ef fe ff ff    	jb     150ce26 <tier0_tables_open+0x14d6>
 150cf37:	48 89 c8             	mov    %rcx,%rax
 150cf3a:	4c 29 e0             	sub    %r12,%rax
 150cf3d:	48 89 ee             	mov    %rbp,%rsi
 150cf40:	48 29 c6             	sub    %rax,%rsi
 150cf43:	41 0f 92 c0          	setb   %r8b
 150cf47:	48 39 f2             	cmp    %rsi,%rdx
 150cf4a:	40 0f 97 c6          	seta   %sil
 150cf4e:	44 08 c6             	or     %r8b,%sil
 150cf51:	40 80 fe 01          	cmp    $0x1,%sil
 150cf55:	0f 84 cb fe ff ff    	je     150ce26 <tier0_tables_open+0x14d6>
 150cf5b:	48 01 d0             	add    %rdx,%rax
 150cf5e:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 150cf65:	48 89 8b 90 01 00 00 	mov    %rcx,0x190(%rbx)
 150cf6c:	48 85 c9             	test   %rcx,%rcx
 150cf6f:	0f 84 bc fe ff ff    	je     150ce31 <tier0_tables_open+0x14e1>
 150cf75:	48 8d 44 11 3c       	lea    0x3c(%rcx,%rdx,1),%rax
 150cf7a:	48 01 d1             	add    %rdx,%rcx
 150cf7d:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 150cf81:	48 39 c8             	cmp    %rcx,%rax
 150cf84:	0f 82 a7 fe ff ff    	jb     150ce31 <tier0_tables_open+0x14e1>
 150cf8a:	48 89 c1             	mov    %rax,%rcx
 150cf8d:	4c 29 e1             	sub    %r12,%rcx
 150cf90:	48 89 ee             	mov    %rbp,%rsi
 150cf93:	48 29 ce             	sub    %rcx,%rsi
 150cf96:	41 0f 92 c0          	setb   %r8b
 150cf9a:	4c 39 fe             	cmp    %r15,%rsi
 150cf9d:	40 0f 92 c6          	setb   %sil
 150cfa1:	44 08 c6             	or     %r8b,%sil
 150cfa4:	40 80 fe 01          	cmp    $0x1,%sil
 150cfa8:	0f 84 83 fe ff ff    	je     150ce31 <tier0_tables_open+0x14e1>
 150cfae:	4c 01 f9             	add    %r15,%rcx
 150cfb1:	48 89 8b 48 02 00 00 	mov    %rcx,0x248(%rbx)
 150cfb8:	48 89 83 98 01 00 00 	mov    %rax,0x198(%rbx)
 150cfbf:	48 85 c0             	test   %rax,%rax
 150cfc2:	0f 84 74 fe ff ff    	je     150ce3c <tier0_tables_open+0x14ec>
 150cfc8:	4a 8d 4c 38 3f       	lea    0x3f(%rax,%r15,1),%rcx
 150cfcd:	4c 01 f8             	add    %r15,%rax
 150cfd0:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 150cfd4:	48 39 c1             	cmp    %rax,%rcx
 150cfd7:	0f 82 5f fe ff ff    	jb     150ce3c <tier0_tables_open+0x14ec>
 150cfdd:	48 89 c8             	mov    %rcx,%rax
 150cfe0:	4c 29 e0             	sub    %r12,%rax
 150cfe3:	48 89 ee             	mov    %rbp,%rsi
 150cfe6:	48 29 c6             	sub    %rax,%rsi
 150cfe9:	41 0f 92 c0          	setb   %r8b
 150cfed:	4c 39 fe             	cmp    %r15,%rsi
 150cff0:	40 0f 92 c6          	setb   %sil
 150cff4:	44 08 c6             	or     %r8b,%sil
 150cff7:	40 80 fe 01          	cmp    $0x1,%sil
 150cffb:	0f 84 3b fe ff ff    	je     150ce3c <tier0_tables_open+0x14ec>
 150d001:	4c 01 f8             	add    %r15,%rax
 150d004:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 150d00b:	48 89 8b a0 01 00 00 	mov    %rcx,0x1a0(%rbx)
 150d012:	48 85 c9             	test   %rcx,%rcx
 150d015:	0f 84 2c fe ff ff    	je     150ce47 <tier0_tables_open+0x14f7>
 150d01b:	4a 8d 44 39 3f       	lea    0x3f(%rcx,%r15,1),%rax
 150d020:	4c 01 f9             	add    %r15,%rcx
 150d023:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 150d027:	48 39 c8             	cmp    %rcx,%rax
 150d02a:	0f 82 17 fe ff ff    	jb     150ce47 <tier0_tables_open+0x14f7>
 150d030:	48 89 c1             	mov    %rax,%rcx
 150d033:	4e 8d 2c fd 00 00 00 00 	lea    0x0(,%r15,8),%r13
 150d03b:	4c 29 e1             	sub    %r12,%rcx
 150d03e:	48 89 ee             	mov    %rbp,%rsi
 150d041:	48 29 ce             	sub    %rcx,%rsi
 150d044:	41 0f 92 c0          	setb   %r8b
 150d048:	49 39 f5             	cmp    %rsi,%r13
 150d04b:	40 0f 97 c6          	seta   %sil
 150d04f:	44 08 c6             	or     %r8b,%sil
 150d052:	40 80 fe 01          	cmp    $0x1,%sil
 150d056:	0f 84 eb fd ff ff    	je     150ce47 <tier0_tables_open+0x14f7>
 150d05c:	4c 01 e9             	add    %r13,%rcx
 150d05f:	48 89 8b 48 02 00 00 	mov    %rcx,0x248(%rbx)
 150d066:	48 89 83 a8 01 00 00 	mov    %rax,0x1a8(%rbx)
 150d06d:	48 85 c0             	test   %rax,%rax
 150d070:	0f 84 dc fd ff ff    	je     150ce52 <tier0_tables_open+0x1502>
 150d076:	4a 8d 4c 28 38       	lea    0x38(%rax,%r13,1),%rcx
 150d07b:	4c 01 e8             	add    %r13,%rax
 150d07e:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 150d082:	48 39 c1             	cmp    %rax,%rcx
 150d085:	0f 82 c7 fd ff ff    	jb     150ce52 <tier0_tables_open+0x1502>
 150d08b:	48 89 c8             	mov    %rcx,%rax
 150d08e:	4c 29 e0             	sub    %r12,%rax
 150d091:	48 29 c5             	sub    %rax,%rbp
 150d094:	40 0f 92 c6          	setb   %sil
 150d098:	49 39 ed             	cmp    %rbp,%r13
 150d09b:	41 0f 97 c0          	seta   %r8b
 150d09f:	41 08 f0             	or     %sil,%r8b
 150d0a2:	41 80 f8 01          	cmp    $0x1,%r8b
 150d0a6:	0f 84 a6 fd ff ff    	je     150ce52 <tier0_tables_open+0x1502>
 150d0ac:	c4 e2 79 21 05 0b 34 07 ff 	vpmovsxbd -0xf8cbf5(%rip),%xmm0        # 5804c0 <tier0_emit_x87.operations+0x78>
 150d0b5:	4c 01 e8             	add    %r13,%rax
 150d0b8:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 150d0bf:	48 89 8b b0 01 00 00 	mov    %rcx,0x1b0(%rbx)
 150d0c6:	c4 c3 79 22 c7 00    	vpinsrd $0x0,%r15d,%xmm0,%xmm0
 150d0cc:	c5 fa 7f 83 b8 01 00 00 	vmovdqu %xmm0,0x1b8(%rbx)
 150d0d4:	48 85 c9             	test   %rcx,%rcx
 150d0d7:	0f 84 97 fd ff ff    	je     150ce74 <tier0_tables_open+0x1524>
 150d0dd:	31 f6                	xor    %esi,%esi
 150d0df:	45 31 e4             	xor    %r12d,%r12d
 150d0e2:	e8 49 72 25 ff       	call   764330 <memset@plt>
 150d0e7:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
 150d0ee:	31 f6                	xor    %esi,%esi
 150d0f0:	4c 89 fa             	mov    %r15,%rdx
 150d0f3:	e8 38 72 25 ff       	call   764330 <memset@plt>
 150d0f8:	48 8b bb a8 01 00 00 	mov    0x1a8(%rbx),%rdi
 150d0ff:	31 f6                	xor    %esi,%esi
 150d101:	4c 89 ea             	mov    %r13,%rdx
 150d104:	e8 27 72 25 ff       	call   764330 <memset@plt>
 150d109:	c5 fd 6f 05 4f 34 04 ff 	vmovdqa -0xfbcbb1(%rip),%ymm0        # 550560 <x86_disassembly_format.rounding_names+0x180>
 150d111:	c5 f9 6f 0d e7 8a 06 ff 	vmovdqa -0xf97519(%rip),%xmm1        # 575c00 <x86_effects_unknown+0x1a0>
 150d119:	48 b8 07 07 07 07 07 07 07 07 	movabs $0x707070707070707,%rax
 150d123:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 150d129:	bd 77 00 00 00       	mov    $0x77,%ebp
 150d12e:	66 41 bd 01 00       	mov    $0x1,%r13w
 150d133:	c7 83 00 02 00 00 00 00 00 00 	movl   $0x0,0x200(%rbx)
 150d13d:	c7 83 03 02 00 00 00 00 00 00 	movl   $0x0,0x203(%rbx)
 150d147:	48 89 1c 24          	mov    %rbx,(%rsp)
 150d14b:	c5 fe 7f 83 07 02 00 00 	vmovdqu %ymm0,0x207(%rbx)
 150d153:	c5 fa 7f 8b 27 02 00 00 	vmovdqu %xmm1,0x227(%rbx)
 150d15b:	c6 83 37 02 00 00 07 	movb   $0x7,0x237(%rbx)
 150d162:	48 89 83 38 02 00 00 	mov    %rax,0x238(%rbx)
 150d169:	e9 a3 00 00 00       	jmp    150d211 <tier0_tables_open+0x18c1>
 150d16e:	c1 e8 18             	shr    $0x18,%eax
 150d171:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 150d177:	c5 f9 fc 05 91 8a 06 ff 	vpaddb -0xf9756f(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 150d17f:	89 c8                	mov    %ecx,%eax
 150d181:	62 f3 7d 08 3e 0d 94 8a 06 ff 06 	vpcmpnleub -0xf9756c(%rip),%xmm0,%k1        # 575c20 <x86_effects_unknown+0x1c0>
 150d18c:	0c 60                	or     $0x60,%al
 150d18e:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 150d194:	89 c8                	mov    %ecx,%eax
 150d196:	c1 e0 04             	shl    $0x4,%eax
 150d199:	09 c1                	or     %eax,%ecx
 150d19b:	0c 06                	or     $0x6,%al
 150d19d:	62 f2 7d 08 7a c8    	vpbroadcastb %eax,%xmm1
 150d1a3:	62 f2 7d 09 7a c1    	vpbroadcastb %ecx,%xmm0{%k1}
 150d1a9:	c5 f9 6c c1          	vpunpcklqdq %xmm1,%xmm0,%xmm0
 150d1ad:	b8 10 00 00 00       	mov    $0x10,%eax
 150d1b2:	b9 00 00 00 00       	mov    $0x0,%ecx
 150d1b7:	48 8b 34 24          	mov    (%rsp),%rsi
 150d1bb:	c4 c1 7b 92 cd       	kmovd  %r13d,%k1
 150d1c0:	4c 89 f7             	mov    %r14,%rdi
 150d1c3:	48 29 d0             	sub    %rdx,%rax
 150d1c6:	44 89 fa             	mov    %r15d,%edx
 150d1c9:	48 0f 43 c8          	cmovae %rax,%rcx
 150d1cd:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 150d1d3:	62 f3 75 08 3e 05 32 8a 06 ff 05 	vpcmpnltub -0xf975ce(%rip),%xmm1,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 150d1de:	c4 e2 79 78 0d d9 35 01 ff 	vpbroadcastb -0xfeca27(%rip),%xmm1        # 5207c0 <branch_sizing_patterns+0xa30>
 150d1e7:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 150d1ee:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 150d1f2:	62 f2 75 09 66 c0    	vpblendmb %xmm0,%xmm1,%xmm0{%k1}
 150d1f8:	c4 a1 79 7f 44 20 10 	vmovdqa %xmm0,0x10(%rax,%r12,1)
 150d1ff:	e8 8c 30 01 00       	call   1520290 <abi_finish>
 150d204:	49 ff c7             	inc    %r15
 150d207:	49 83 c4 10          	add    $0x10,%r12
 150d20b:	49 83 ff 40          	cmp    $0x40,%r15
 150d20f:	74 65                	je     150d276 <tier0_tables_open+0x1926>
 150d211:	48 8b 04 24          	mov    (%rsp),%rax
 150d215:	8b 40 48             	mov    0x48(%rax),%eax
 150d218:	49 39 c7             	cmp    %rax,%r15
 150d21b:	73 59                	jae    150d276 <tier0_tables_open+0x1926>
 150d21d:	48 8b 04 24          	mov    (%rsp),%rax
 150d221:	48 8b 00             	mov    (%rax),%rax
 150d224:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
 150d229:	74 d9                	je     150d204 <tier0_tables_open+0x18b4>
 150d22b:	48 8b 34 24          	mov    (%rsp),%rsi
 150d22f:	4c 89 f7             	mov    %r14,%rdi
 150d232:	44 89 fa             	mov    %r15d,%edx
 150d235:	c5 f8 77             	vzeroupper
 150d238:	e8 23 2e 01 00       	call   1520060 <abi_simple>
 150d23d:	89 c6                	mov    %eax,%esi
 150d23f:	c1 ee 10             	shr    $0x10,%esi
 150d242:	48 89 c1             	mov    %rax,%rcx
 150d245:	48 c1 e9 08          	shr    $0x8,%rcx
 150d249:	89 f7                	mov    %esi,%edi
 150d24b:	40 c0 e7 04          	shl    $0x4,%dil
 150d24f:	40 08 cf             	or     %cl,%dil
 150d252:	40 80 fe 07          	cmp    $0x7,%sil
 150d256:	40 0f b6 f7          	movzbl %dil,%esi
 150d25a:	0f 44 f5             	cmove  %ebp,%esi
 150d25d:	80 f9 07             	cmp    $0x7,%cl
 150d260:	0f 44 f5             	cmove  %ebp,%esi
 150d263:	3c 01                	cmp    $0x1,%al
 150d265:	0f 84 03 ff ff ff    	je     150d16e <tier0_tables_open+0x181e>
 150d26b:	62 f2 7d 08 7a c6    	vpbroadcastb %esi,%xmm0
 150d271:	e9 37 ff ff ff       	jmp    150d1ad <tier0_tables_open+0x185d>
 150d276:	48 8b 04 24          	mov    (%rsp),%rax
 150d27a:	ba 04 1d 00 00       	mov    $0x1d04,%edx
 150d27f:	31 f6                	xor    %esi,%esi
 150d281:	48 8d b8 60 02 00 00 	lea    0x260(%rax),%rdi
 150d288:	c5 f8 77             	vzeroupper
 150d28b:	e8 a0 70 25 ff       	call   764330 <memset@plt>
 150d290:	48 c7 44 24 68 00 00 00 00 	movq   $0x0,0x68(%rsp)
 150d299:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 150d29e:	48 8d 05 ab 2c b9 00 	lea    0xb92cab(%rip),%rax        # 209ff50 <tier0_record_shapes>
 150d2a5:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
 150d2a9:	80 3e 75             	cmpb   $0x75,(%rsi)
 150d2ac:	75 09                	jne    150d2b7 <tier0_tables_open+0x1967>
 150d2ae:	80 7e 01 3a          	cmpb   $0x3a,0x1(%rsi)
 150d2b2:	0f 94 c0             	sete   %al
 150d2b5:	eb 02                	jmp    150d2b9 <tier0_tables_open+0x1969>
 150d2b7:	31 c0                	xor    %eax,%eax
 150d2b9:	48 6b 54 24 68 74    	imul   $0x74,0x68(%rsp),%rdx
 150d2bf:	48 8b 0c 24          	mov    (%rsp),%rcx
 150d2c3:	48 81 c1 60 02 00 00 	add    $0x260,%rcx
 150d2ca:	48 01 ca             	add    %rcx,%rdx
 150d2cd:	88 42 64             	mov    %al,0x64(%rdx)
 150d2d0:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 150d2d5:	80 3e 61             	cmpb   $0x61,(%rsi)
 150d2d8:	75 09                	jne    150d2e3 <tier0_tables_open+0x1993>
 150d2da:	80 7e 01 3a          	cmpb   $0x3a,0x1(%rsi)
 150d2de:	0f 94 c2             	sete   %dl
 150d2e1:	eb 02                	jmp    150d2e5 <tier0_tables_open+0x1995>
 150d2e3:	31 d2                	xor    %edx,%edx
 150d2e5:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 150d2ea:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 150d2f0:	88 51 65             	mov    %dl,0x65(%rcx)
 150d2f3:	c7 41 60 01 00 00 00 	movl   $0x1,0x60(%rcx)
 150d2fa:	8b 79 58             	mov    0x58(%rcx),%edi
 150d2fd:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 150d302:	48 83 ff 10          	cmp    $0x10,%rdi
 150d306:	0f 87 38 01 00 00    	ja     150d444 <tier0_tables_open+0x1af4>
 150d30c:	41 89 d1             	mov    %edx,%r9d
 150d30f:	41 08 c1             	or     %al,%r9b
 150d312:	45 0f b6 c9          	movzbl %r9b,%r9d
 150d316:	41 83 e1 01          	and    $0x1,%r9d
 150d31a:	4a 8d 34 4e          	lea    (%rsi,%r9,2),%rsi
 150d31e:	44 0f b6 14 37       	movzbl (%rdi,%rsi,1),%r10d
 150d323:	45 84 d2             	test   %r10b,%r10b
 150d326:	0f 84 18 01 00 00    	je     150d444 <tier0_tables_open+0x1af4>
 150d32c:	31 c0                	xor    %eax,%eax
 150d32e:	41 89 f9             	mov    %edi,%r9d
 150d331:	31 c9                	xor    %ecx,%ecx
 150d333:	41 80 c2 b7          	add    $0xb7,%r10b
 150d337:	bd 0a 00 00 00       	mov    $0xa,%ebp
 150d33c:	41 80 fa 2a          	cmp    $0x2a,%r10b
 150d340:	77 10                	ja     150d352 <tier0_tables_open+0x1a02>
 150d342:	45 0f b6 c2          	movzbl %r10b,%r8d
 150d346:	4c 8d 15 6f 73 01 ff 	lea    -0xfe8c91(%rip),%r10        # 5246bc <tier0_emit_int128.extensions+0x10>
 150d34d:	43 0f b6 2c 10       	movzbl (%r8,%r10,1),%ebp
 150d352:	4c 8d 05 37 91 06 ff 	lea    -0xf96ec9(%rip),%r8        # 576490 <tier0_class_bytes.bytes>
 150d359:	41 89 ea             	mov    %ebp,%r10d
 150d35c:	f6 c2 01             	test   $0x1,%dl
 150d35f:	ba 10 00 00 00       	mov    $0x10,%edx
 150d364:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
 150d369:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 150d36f:	47 0f b6 1c 02       	movzbl (%r10,%r8,1),%r11d
 150d374:	45 89 d8             	mov    %r11d,%r8d
 150d377:	44 0f 45 c2          	cmovne %edx,%r8d
 150d37b:	45 85 c9             	test   %r9d,%r9d
 150d37e:	45 0f 45 c3          	cmovne %r11d,%r8d
 150d382:	42 8d 54 00 ff       	lea    -0x1(%rax,%r8,1),%edx
 150d387:	44 89 c0             	mov    %r8d,%eax
 150d38a:	f7 d8                	neg    %eax
 150d38c:	21 d0                	and    %edx,%eax
 150d38e:	41 80 7f 64 00       	cmpb   $0x0,0x64(%r15)
 150d393:	41 88 2c 3f          	mov    %bpl,(%r15,%rdi,1)
 150d397:	41 0f 45 c5          	cmovne %r13d,%eax
 150d39b:	45 31 e4             	xor    %r12d,%r12d
 150d39e:	41 89 44 bf 14       	mov    %eax,0x14(%r15,%rdi,4)
 150d3a3:	41 0f b6 57 65       	movzbl 0x65(%r15),%edx
 150d3a8:	41 8b 5f 60          	mov    0x60(%r15),%ebx
 150d3ac:	84 d2                	test   %dl,%dl
 150d3ae:	41 0f 95 c4          	setne  %r12b
 150d3b2:	45 85 c9             	test   %r9d,%r9d
 150d3b5:	43 8d 2c a4          	lea    (%r12,%r12,4),%ebp
 150d3b9:	41 0f 45 ed          	cmovne %r13d,%ebp
 150d3bd:	44 01 d8             	add    %r11d,%eax
 150d3c0:	4c 8d 1d a9 71 01 ff 	lea    -0xfe8e57(%rip),%r11        # 524570 <tier0_program_class_type.types>
 150d3c7:	39 c8                	cmp    %ecx,%eax
 150d3c9:	0f 47 c8             	cmova  %eax,%ecx
 150d3cc:	41 39 d8             	cmp    %ebx,%r8d
 150d3cf:	44 0f 46 c3          	cmovbe %ebx,%r8d
 150d3d3:	48 c1 e7 04          	shl    $0x4,%rdi
 150d3d7:	41 ff c1             	inc    %r9d
 150d3da:	45 89 47 60          	mov    %r8d,0x60(%r15)
 150d3de:	44 89 8c 3c b0 01 00 00 	mov    %r9d,0x1b0(%rsp,%rdi,1)
 150d3e6:	47 8b 14 93          	mov    (%r11,%r10,4),%r10d
 150d3ea:	44 89 94 3c b4 01 00 00 	mov    %r10d,0x1b4(%rsp,%rdi,1)
 150d3f2:	c7 84 3c b8 01 00 00 ff ff ff ff 	movl   $0xffffffff,0x1b8(%rsp,%rdi,1)
 150d3fd:	40 88 ac 3c bc 01 00 00 	mov    %bpl,0x1bc(%rsp,%rdi,1)
 150d405:	c6 84 3c bd 01 00 00 00 	movb   $0x0,0x1bd(%rsp,%rdi,1)
 150d40d:	66 c7 84 3c be 01 00 00 00 00 	movw   $0x0,0x1be(%rsp,%rdi,1)
 150d417:	45 8b 4f 58          	mov    0x58(%r15),%r9d
 150d41b:	41 ff c1             	inc    %r9d
 150d41e:	45 89 4f 58          	mov    %r9d,0x58(%r15)
 150d422:	41 83 f9 10          	cmp    $0x10,%r9d
 150d426:	77 11                	ja     150d439 <tier0_tables_open+0x1ae9>
 150d428:	46 0f b6 14 0e       	movzbl (%rsi,%r9,1),%r10d
 150d42d:	4c 89 cf             	mov    %r9,%rdi
 150d430:	45 84 d2             	test   %r10b,%r10b
 150d433:	0f 85 fa fe ff ff    	jne    150d333 <tier0_tables_open+0x19e3>
 150d439:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 150d43e:	ff c9                	dec    %ecx
 150d440:	0f b6 40 64          	movzbl 0x64(%rax),%eax
 150d444:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 150d449:	48 8b 14 24          	mov    (%rsp),%rdx
 150d44d:	44 01 c1             	add    %r8d,%ecx
 150d450:	41 f7 d8             	neg    %r8d
 150d453:	41 21 c8             	and    %ecx,%r8d
 150d456:	44 89 46 5c          	mov    %r8d,0x5c(%rsi)
 150d45a:	44 8b 62 48          	mov    0x48(%rdx),%r12d
 150d45e:	44 3b 62 4c          	cmp    0x4c(%rdx),%r12d
 150d462:	0f 84 ca 0c 00 00    	je     150e132 <tier0_tables_open+0x27e2>
 150d468:	48 8b 14 24          	mov    (%rsp),%rdx
 150d46c:	8b 8a a0 00 00 00    	mov    0xa0(%rdx),%ecx
 150d472:	3b 8a a4 00 00 00    	cmp    0xa4(%rdx),%ecx
 150d478:	0f 84 b4 0c 00 00    	je     150e132 <tier0_tables_open+0x27e2>
 150d47e:	48 8b 3c 24          	mov    (%rsp),%rdi
 150d482:	0c 10                	or     $0x10,%al
 150d484:	42 8d 34 e5 00 00 00 00 	lea    0x0(,%r12,8),%esi
 150d48c:	89 74 24 40          	mov    %esi,0x40(%rsp)
 150d490:	48 8b 17             	mov    (%rdi),%rdx
 150d493:	42 88 04 22          	mov    %al,(%rdx,%r12,1)
 150d497:	48 8b 57 08          	mov    0x8(%rdi),%rdx
 150d49b:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 150d4a0:	48 8b 57 10          	mov    0x10(%rdi),%rdx
 150d4a4:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 150d4a9:	48 8b 57 18          	mov    0x18(%rdi),%rdx
 150d4ad:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 150d4b2:	48 8b 57 20          	mov    0x20(%rdi),%rdx
 150d4b6:	42 c7 04 a2 00 00 00 00 	movl   $0x0,(%rdx,%r12,4)
 150d4be:	48 8b 57 28          	mov    0x28(%rdi),%rdx
 150d4c2:	42 89 0c a2          	mov    %ecx,(%rdx,%r12,4)
 150d4c6:	48 8b 57 30          	mov    0x30(%rdi),%rdx
 150d4ca:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 150d4d2:	48 8b 57 38          	mov    0x38(%rdi),%rdx
 150d4d6:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 150d4de:	48 8b 57 40          	mov    0x40(%rdi),%rdx
 150d4e2:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 150d4ea:	ff 47 48             	incl   0x48(%rdi)
 150d4ed:	48 8b 57 60          	mov    0x60(%rdi),%rdx
 150d4f1:	89 34 8a             	mov    %esi,(%rdx,%rcx,4)
 150d4f4:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 150d4f9:	48 8b 77 68          	mov    0x68(%rdi),%rsi
 150d4fd:	81 c2 e8 03 00 00    	add    $0x3e8,%edx
 150d503:	89 14 8e             	mov    %edx,(%rsi,%rcx,4)
 150d506:	48 8b 77 70          	mov    0x70(%rdi),%rsi
 150d50a:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 150d511:	48 8b 77 78          	mov    0x78(%rdi),%rsi
 150d515:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 150d51c:	48 8b b7 80 00 00 00 	mov    0x80(%rdi),%rsi
 150d523:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 150d52a:	48 8b b7 88 00 00 00 	mov    0x88(%rdi),%rsi
 150d531:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 150d535:	48 8b b7 90 00 00 00 	mov    0x90(%rdi),%rsi
 150d53c:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 150d540:	48 8b b7 98 00 00 00 	mov    0x98(%rdi),%rsi
 150d547:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 150d54b:	ff 87 a0 00 00 00    	incl   0xa0(%rdi)
 150d551:	48 8b b7 08 01 00 00 	mov    0x108(%rdi),%rsi
 150d558:	48 85 f6             	test   %rsi,%rsi
 150d55b:	74 76                	je     150d5d3 <tier0_tables_open+0x1c83>
 150d55d:	80 7e 4c 00          	cmpb   $0x0,0x4c(%rsi)
 150d561:	75 70                	jne    150d5d3 <tier0_tables_open+0x1c83>
 150d563:	8b 7e 08             	mov    0x8(%rsi),%edi
 150d566:	3b 7e 0c             	cmp    0xc(%rsi),%edi
 150d569:	75 06                	jne    150d571 <tier0_tables_open+0x1c21>
 150d56b:	c6 46 4c 01          	movb   $0x1,0x4c(%rsi)
 150d56f:	eb 62                	jmp    150d5d3 <tier0_tables_open+0x1c83>
 150d571:	44 8d 4f 01          	lea    0x1(%rdi),%r9d
 150d575:	44 8b 46 38          	mov    0x38(%rsi),%r8d
 150d579:	c6 46 4c 00          	movb   $0x0,0x4c(%rsi)
 150d57d:	48 6b ff 38          	imul   $0x38,%rdi,%rdi
 150d581:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150d585:	44 89 4e 08          	mov    %r9d,0x8(%rsi)
 150d589:	4c 8b 0e             	mov    (%rsi),%r9
 150d58c:	4c 8b 56 30          	mov    0x30(%rsi),%r10
 150d590:	ff 46 34             	incl   0x34(%rsi)
 150d593:	8b 74 24 40          	mov    0x40(%rsp),%esi
 150d597:	4d 89 14 39          	mov    %r10,(%r9,%rdi,1)
 150d59b:	41 c6 44 39 08 02    	movb   $0x2,0x8(%r9,%rdi,1)
 150d5a1:	41 88 44 39 09       	mov    %al,0x9(%r9,%rdi,1)
 150d5a6:	c4 c1 7a 7f 44 39 0a 	vmovdqu %xmm0,0xa(%r9,%rdi,1)
 150d5ad:	49 c7 44 39 18 00 00 00 00 	movq   $0x0,0x18(%r9,%rdi,1)
 150d5b6:	41 89 74 39 20       	mov    %esi,0x20(%r9,%rdi,1)
 150d5bb:	41 89 54 39 24       	mov    %edx,0x24(%r9,%rdi,1)
 150d5c0:	45 89 44 39 28       	mov    %r8d,0x28(%r9,%rdi,1)
 150d5c5:	41 89 4c 39 2c       	mov    %ecx,0x2c(%r9,%rdi,1)
 150d5ca:	49 c7 44 39 30 00 00 00 00 	movq   $0x0,0x30(%r9,%rdi,1)
 150d5d3:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 150d5d8:	8b 4c 24 40          	mov    0x40(%rsp),%ecx
 150d5dc:	89 48 68             	mov    %ecx,0x68(%rax)
 150d5df:	85 c9                	test   %ecx,%ecx
 150d5e1:	0f 84 c1 0b 00 00    	je     150e1a8 <tier0_tables_open+0x2858>
 150d5e7:	48 8b 04 24          	mov    (%rsp),%rax
 150d5eb:	41 81 e4 ff ff ff 1f 	and    $0x1fffffff,%r12d
 150d5f2:	41 ba 0d 00 00 00    	mov    $0xd,%r10d
 150d5f8:	8b 58 48             	mov    0x48(%rax),%ebx
 150d5fb:	41 39 dc             	cmp    %ebx,%r12d
 150d5fe:	0f 83 7a 0b 00 00    	jae    150e17e <tier0_tables_open+0x282e>
 150d604:	48 8b 04 24          	mov    (%rsp),%rax
 150d608:	48 8b 30             	mov    (%rax),%rsi
 150d60b:	42 0f b6 04 26       	movzbl (%rsi,%r12,1),%eax
 150d610:	24 fe                	and    $0xfe,%al
 150d612:	3c 10                	cmp    $0x10,%al
 150d614:	0f 85 64 0b 00 00    	jne    150e17e <tier0_tables_open+0x282e>
 150d61a:	48 8b 04 24          	mov    (%rsp),%rax
 150d61e:	48 8b 40 10          	mov    0x10(%rax),%rax
 150d622:	42 f6 04 20 24       	testb  $0x24,(%rax,%r12,1)
 150d627:	0f 85 51 0b 00 00    	jne    150e17e <tier0_tables_open+0x282e>
 150d62d:	49 89 c7             	mov    %rax,%r15
 150d630:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 150d635:	8b 48 58             	mov    0x58(%rax),%ecx
 150d638:	48 8b 04 24          	mov    (%rsp),%rax
 150d63c:	8b 90 e0 00 00 00    	mov    0xe0(%rax),%edx
 150d642:	8b 80 e4 00 00 00    	mov    0xe4(%rax),%eax
 150d648:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 150d64d:	ff c9                	dec    %ecx
 150d64f:	29 d0                	sub    %edx,%eax
 150d651:	89 94 24 80 00 00 00 	mov    %edx,0x80(%rsp)
 150d658:	39 c1                	cmp    %eax,%ecx
 150d65a:	0f 83 e1 01 00 00    	jae    150d841 <tier0_tables_open+0x1ef1>
 150d660:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 150d666:	4c 8d 8c 24 bc 01 00 00 	lea    0x1bc(%rsp),%r9
 150d66e:	c6 44 24 20 20       	movb   $0x20,0x20(%rsp)
 150d673:	45 8b 59 f8          	mov    -0x8(%r9),%r11d
 150d677:	41 ba 02 00 00 00    	mov    $0x2,%r10d
 150d67d:	45 89 dd             	mov    %r11d,%r13d
 150d680:	41 c1 ed 03          	shr    $0x3,%r13d
 150d684:	0f 84 f4 0a 00 00    	je     150e17e <tier0_tables_open+0x282e>
 150d68a:	41 39 dd             	cmp    %ebx,%r13d
 150d68d:	0f 83 eb 0a 00 00    	jae    150e17e <tier0_tables_open+0x282e>
 150d693:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 150d698:	84 c9                	test   %cl,%cl
 150d69a:	0f 84 de 0a 00 00    	je     150e17e <tier0_tables_open+0x282e>
 150d6a0:	89 cd                	mov    %ecx,%ebp
 150d6a2:	80 f9 0f             	cmp    $0xf,%cl
 150d6a5:	75 13                	jne    150d6ba <tier0_tables_open+0x1d6a>
 150d6a7:	48 8b 04 24          	mov    (%rsp),%rax
 150d6ab:	48 8b 40 20          	mov    0x20(%rax),%rax
 150d6af:	42 8b 04 a8          	mov    (%rax,%r13,4),%eax
 150d6b3:	c1 e8 03             	shr    $0x3,%eax
 150d6b6:	0f b6 2c 06          	movzbl (%rsi,%rax,1),%ebp
 150d6ba:	41 ba 0e 00 00 00    	mov    $0xe,%r10d
 150d6c0:	40 80 fd 01          	cmp    $0x1,%bpl
 150d6c4:	0f 84 b4 0a 00 00    	je     150e17e <tier0_tables_open+0x282e>
 150d6ca:	40 0f b6 c5          	movzbl %bpl,%eax
 150d6ce:	83 f8 0b             	cmp    $0xb,%eax
 150d6d1:	0f 84 a7 0a 00 00    	je     150e17e <tier0_tables_open+0x282e>
 150d6d7:	43 0f b6 14 2f       	movzbl (%r15,%r13,1),%edx
 150d6dc:	f6 c2 08             	test   $0x8,%dl
 150d6df:	0f 85 99 0a 00 00    	jne    150e17e <tier0_tables_open+0x282e>
 150d6e5:	80 f9 0f             	cmp    $0xf,%cl
 150d6e8:	75 2a                	jne    150d714 <tier0_tables_open+0x1dc4>
 150d6ea:	48 8b 04 24          	mov    (%rsp),%rax
 150d6ee:	48 8b 40 20          	mov    0x20(%rax),%rax
 150d6f2:	42 8b 04 a8          	mov    (%rax,%r13,4),%eax
 150d6f6:	c1 e8 03             	shr    $0x3,%eax
 150d6f9:	41 0f b6 14 07       	movzbl (%r15,%rax,1),%edx
 150d6fe:	41 8b 41 fc          	mov    -0x4(%r9),%eax
 150d702:	45 31 d2             	xor    %r10d,%r10d
 150d705:	f6 c2 04             	test   $0x4,%dl
 150d708:	74 16                	je     150d720 <tier0_tables_open+0x1dd0>
 150d70a:	45 85 d2             	test   %r10d,%r10d
 150d70d:	74 53                	je     150d762 <tier0_tables_open+0x1e12>
 150d70f:	e9 ce 00 00 00       	jmp    150d7e2 <tier0_tables_open+0x1e92>
 150d714:	41 8b 41 fc          	mov    -0x4(%r9),%eax
 150d718:	45 31 d2             	xor    %r10d,%r10d
 150d71b:	f6 c2 04             	test   $0x4,%dl
 150d71e:	75 ea                	jne    150d70a <tier0_tables_open+0x1dba>
 150d720:	83 f8 ff             	cmp    $0xffffffff,%eax
 150d723:	0f 95 c2             	setne  %dl
 150d726:	4c 39 44 24 08       	cmp    %r8,0x8(%rsp)
 150d72b:	40 0f 95 c7          	setne  %dil
 150d72f:	40 80 fd 09          	cmp    $0x9,%bpl
 150d733:	41 0f 95 c2          	setne  %r10b
 150d737:	40 08 d7             	or     %dl,%dil
 150d73a:	ba 0e 00 00 00       	mov    $0xe,%edx
 150d73f:	44 08 d7             	or     %r10b,%dil
 150d742:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 150d748:	44 0f 45 d2          	cmovne %edx,%r10d
 150d74c:	40 80 f7 01          	xor    $0x1,%dil
 150d750:	40 c0 e7 06          	shl    $0x6,%dil
 150d754:	40 08 7c 24 20       	or     %dil,0x20(%rsp)
 150d759:	45 85 d2             	test   %r10d,%r10d
 150d75c:	0f 85 80 00 00 00    	jne    150d7e2 <tier0_tables_open+0x1e92>
 150d762:	83 f8 ff             	cmp    $0xffffffff,%eax
 150d765:	74 7b                	je     150d7e2 <tier0_tables_open+0x1e92>
 150d767:	80 f9 0f             	cmp    $0xf,%cl
 150d76a:	75 18                	jne    150d784 <tier0_tables_open+0x1e34>
 150d76c:	48 8b 0c 24          	mov    (%rsp),%rcx
 150d770:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 150d774:	46 8b 1c a9          	mov    (%rcx,%r13,4),%r11d
 150d778:	45 89 dd             	mov    %r11d,%r13d
 150d77b:	41 c1 ed 03          	shr    $0x3,%r13d
 150d77f:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 150d784:	80 f9 12             	cmp    $0x12,%cl
 150d787:	75 21                	jne    150d7aa <tier0_tables_open+0x1e5a>
 150d789:	43 f6 04 2f 04       	testb  $0x4,(%r15,%r13,1)
 150d78e:	0f 84 e4 09 00 00    	je     150e178 <tier0_tables_open+0x2828>
 150d794:	48 8b 0c 24          	mov    (%rsp),%rcx
 150d798:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 150d79c:	46 8b 1c a9          	mov    (%rcx,%r13,4),%r11d
 150d7a0:	44 89 d9             	mov    %r11d,%ecx
 150d7a3:	c1 e9 03             	shr    $0x3,%ecx
 150d7a6:	0f b6 0c 0e          	movzbl (%rsi,%rcx,1),%ecx
 150d7aa:	41 ba 0f 00 00 00    	mov    $0xf,%r10d
 150d7b0:	80 f9 05             	cmp    $0x5,%cl
 150d7b3:	74 37                	je     150d7ec <tier0_tables_open+0x1e9c>
 150d7b5:	0f b6 c9             	movzbl %cl,%ecx
 150d7b8:	83 f9 02             	cmp    $0x2,%ecx
 150d7bb:	0f 85 bd 09 00 00    	jne    150e17e <tier0_tables_open+0x282e>
 150d7c1:	41 83 e3 f8          	and    $0xfffffff8,%r11d
 150d7c5:	b9 01 00 00 00       	mov    $0x1,%ecx
 150d7ca:	41 83 fb 10          	cmp    $0x10,%r11d
 150d7ce:	74 35                	je     150d805 <tier0_tables_open+0x1eb5>
 150d7d0:	48 8b 0c 24          	mov    (%rsp),%rcx
 150d7d4:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 150d7d8:	4a 8b 0c 19          	mov    (%rcx,%r11,1),%rcx
 150d7dc:	48 c1 e1 03          	shl    $0x3,%rcx
 150d7e0:	eb 1a                	jmp    150d7fc <tier0_tables_open+0x1eac>
 150d7e2:	45 85 d2             	test   %r10d,%r10d
 150d7e5:	74 37                	je     150d81e <tier0_tables_open+0x1ece>
 150d7e7:	e9 92 09 00 00       	jmp    150e17e <tier0_tables_open+0x282e>
 150d7ec:	48 8b 0c 24          	mov    (%rsp),%rcx
 150d7f0:	41 83 e3 f8          	and    $0xfffffff8,%r11d
 150d7f4:	48 8b 49 30          	mov    0x30(%rcx),%rcx
 150d7f8:	4a 8b 0c 19          	mov    (%rcx,%r11,1),%rcx
 150d7fc:	48 85 c9             	test   %rcx,%rcx
 150d7ff:	0f 84 79 09 00 00    	je     150e17e <tier0_tables_open+0x282e>
 150d805:	48 39 c1             	cmp    %rax,%rcx
 150d808:	0f 82 70 09 00 00    	jb     150e17e <tier0_tables_open+0x282e>
 150d80e:	48 85 c0             	test   %rax,%rax
 150d811:	75 0b                	jne    150d81e <tier0_tables_open+0x1ece>
 150d813:	41 83 79 f4 00       	cmpl   $0x0,-0xc(%r9)
 150d818:	0f 85 60 09 00 00    	jne    150e17e <tier0_tables_open+0x282e>
 150d81e:	41 0f b6 01          	movzbl (%r9),%eax
 150d822:	4c 3b 44 24 08       	cmp    0x8(%rsp),%r8
 150d827:	73 0f                	jae    150d838 <tier0_tables_open+0x1ee8>
 150d829:	49 ff c0             	inc    %r8
 150d82c:	49 83 c1 10          	add    $0x10,%r9
 150d830:	3c 22                	cmp    $0x22,%al
 150d832:	0f 82 3b fe ff ff    	jb     150d673 <tier0_tables_open+0x1d23>
 150d838:	3c 22                	cmp    $0x22,%al
 150d83a:	72 14                	jb     150d850 <tier0_tables_open+0x1f00>
 150d83c:	e9 26 0a 00 00       	jmp    150e267 <tier0_tables_open+0x2917>
 150d841:	c6 44 24 20 20       	movb   $0x20,0x20(%rsp)
 150d846:	39 44 24 08          	cmp    %eax,0x8(%rsp)
 150d84a:	0f 87 20 09 00 00    	ja     150e170 <tier0_tables_open+0x2820>
 150d850:	48 8b 04 24          	mov    (%rsp),%rax
 150d854:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
 150d859:	48 8b 40 28          	mov    0x28(%rax),%rax
 150d85d:	46 8b 3c a0          	mov    (%rax,%r12,4),%r15d
 150d861:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 150d868:	0f 84 bd 01 00 00    	je     150da2b <tier0_tables_open+0x20db>
 150d86e:	83 7c 24 08 01       	cmpl   $0x1,0x8(%rsp)
 150d873:	75 07                	jne    150d87c <tier0_tables_open+0x1f2c>
 150d875:	31 c0                	xor    %eax,%eax
 150d877:	e9 18 01 00 00       	jmp    150d994 <tier0_tables_open+0x2044>
 150d87c:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 150d883:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 150d888:	83 e1 fe             	and    $0xfffffffe,%ecx
 150d88b:	48 8d b4 24 cd 01 00 00 	lea    0x1cd(%rsp),%rsi
 150d893:	89 c2                	mov    %eax,%edx
 150d895:	31 c0                	xor    %eax,%eax
 150d897:	48 8b 1c 24          	mov    (%rsp),%rbx
 150d89b:	8b 7e e3             	mov    -0x1d(%rsi),%edi
 150d89e:	44 8b 46 eb          	mov    -0x15(%rsi),%r8d
 150d8a2:	41 89 d3             	mov    %edx,%r11d
 150d8a5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 150d8ab:	4c 8b 93 b0 00 00 00 	mov    0xb0(%rbx),%r10
 150d8b2:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 150d8b6:	45 0f 44 c5          	cmove  %r13d,%r8d
 150d8ba:	41 0f 95 c1          	setne  %r9b
 150d8be:	45 00 c9             	add    %r9b,%r9b
 150d8c1:	43 89 3c 9a          	mov    %edi,(%r10,%r11,4)
 150d8c5:	8b 7e e7             	mov    -0x19(%rsi),%edi
 150d8c8:	4c 8b 93 b8 00 00 00 	mov    0xb8(%rbx),%r10
 150d8cf:	43 89 3c 9a          	mov    %edi,(%r10,%r11,4)
 150d8d3:	48 8b bb c0 00 00 00 	mov    0xc0(%rbx),%rdi
 150d8da:	46 89 04 9f          	mov    %r8d,(%rdi,%r11,4)
 150d8de:	0f b6 7e ef          	movzbl -0x11(%rsi),%edi
 150d8e2:	4c 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%r8
 150d8e9:	43 88 3c 18          	mov    %dil,(%r8,%r11,1)
 150d8ed:	44 0a 4e f0          	or     -0x10(%rsi),%r9b
 150d8f1:	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
 150d8f8:	46 88 0c 1f          	mov    %r9b,(%rdi,%r11,1)
 150d8fc:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
 150d900:	48 8b bb d8 00 00 00 	mov    0xd8(%rbx),%rdi
 150d907:	4a c7 04 df 00 00 00 00 	movq   $0x0,(%rdi,%r11,8)
 150d90f:	8b 7e f3             	mov    -0xd(%rsi),%edi
 150d912:	4c 8b 9b b0 00 00 00 	mov    0xb0(%rbx),%r11
 150d919:	44 8b 46 fb          	mov    -0x5(%rsi),%r8d
 150d91d:	43 89 3c 8b          	mov    %edi,(%r11,%r9,4)
 150d921:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 150d925:	8b 7e f7             	mov    -0x9(%rsi),%edi
 150d928:	4c 8b 9b b8 00 00 00 	mov    0xb8(%rbx),%r11
 150d92f:	45 0f 44 c5          	cmove  %r13d,%r8d
 150d933:	41 0f 95 c2          	setne  %r10b
 150d937:	48 83 c0 02          	add    $0x2,%rax
 150d93b:	83 c2 02             	add    $0x2,%edx
 150d93e:	45 00 d2             	add    %r10b,%r10b
 150d941:	43 89 3c 8b          	mov    %edi,(%r11,%r9,4)
 150d945:	48 8b bb c0 00 00 00 	mov    0xc0(%rbx),%rdi
 150d94c:	46 89 04 8f          	mov    %r8d,(%rdi,%r9,4)
 150d950:	0f b6 7e ff          	movzbl -0x1(%rsi),%edi
 150d954:	4c 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%r8
 150d95b:	43 88 3c 08          	mov    %dil,(%r8,%r9,1)
 150d95f:	44 0a 16             	or     (%rsi),%r10b
 150d962:	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
 150d969:	48 83 c6 20          	add    $0x20,%rsi
 150d96d:	46 88 14 0f          	mov    %r10b,(%rdi,%r9,1)
 150d971:	48 8b bb d8 00 00 00 	mov    0xd8(%rbx),%rdi
 150d978:	4a c7 04 cf 00 00 00 00 	movq   $0x0,(%rdi,%r9,8)
 150d980:	48 39 c1             	cmp    %rax,%rcx
 150d983:	0f 85 0e ff ff ff    	jne    150d897 <tier0_tables_open+0x1f47>
 150d989:	f6 44 24 08 01       	testb  $0x1,0x8(%rsp)
 150d98e:	0f 84 8d 00 00 00    	je     150da21 <tier0_tables_open+0x20d1>
 150d994:	4c 8b 0c 24          	mov    (%rsp),%r9
 150d998:	48 89 c1             	mov    %rax,%rcx
 150d99b:	48 c1 e1 04          	shl    $0x4,%rcx
 150d99f:	03 84 24 80 00 00 00 	add    0x80(%rsp),%eax
 150d9a6:	8b 94 0c b0 01 00 00 	mov    0x1b0(%rsp,%rcx,1),%edx
 150d9ad:	8b b4 0c b8 01 00 00 	mov    0x1b8(%rsp,%rcx,1),%esi
 150d9b4:	4d 8b 81 b0 00 00 00 	mov    0xb0(%r9),%r8
 150d9bb:	83 fe ff             	cmp    $0xffffffff,%esi
 150d9be:	40 0f 95 c7          	setne  %dil
 150d9c2:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 150d9c6:	8b 94 0c b4 01 00 00 	mov    0x1b4(%rsp,%rcx,1),%edx
 150d9cd:	4d 8b 81 b8 00 00 00 	mov    0xb8(%r9),%r8
 150d9d4:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 150d9d8:	ba 00 00 00 00       	mov    $0x0,%edx
 150d9dd:	0f 44 f2             	cmove  %edx,%esi
 150d9e0:	49 8b 91 c0 00 00 00 	mov    0xc0(%r9),%rdx
 150d9e7:	40 00 ff             	add    %dil,%dil
 150d9ea:	89 34 82             	mov    %esi,(%rdx,%rax,4)
 150d9ed:	0f b6 94 0c bc 01 00 00 	movzbl 0x1bc(%rsp,%rcx,1),%edx
 150d9f5:	49 8b b1 c8 00 00 00 	mov    0xc8(%r9),%rsi
 150d9fc:	88 14 06             	mov    %dl,(%rsi,%rax,1)
 150d9ff:	40 0a bc 0c bd 01 00 00 	or     0x1bd(%rsp,%rcx,1),%dil
 150da07:	49 8b 91 d0 00 00 00 	mov    0xd0(%r9),%rdx
 150da0e:	40 88 3c 02          	mov    %dil,(%rdx,%rax,1)
 150da12:	49 8b 89 d8 00 00 00 	mov    0xd8(%r9),%rcx
 150da19:	48 c7 04 c1 00 00 00 00 	movq   $0x0,(%rcx,%rax,8)
 150da21:	48 8b 04 24          	mov    (%rsp),%rax
 150da25:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
 150da2b:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 150da30:	48 8b 0c 24          	mov    (%rsp),%rcx
 150da34:	8b b4 24 80 00 00 00 	mov    0x80(%rsp),%esi
 150da3b:	01 d0                	add    %edx,%eax
 150da3d:	89 81 e0 00 00 00    	mov    %eax,0xe0(%rcx)
 150da43:	48 8b 41 70          	mov    0x70(%rcx),%rax
 150da47:	42 89 34 b8          	mov    %esi,(%rax,%r15,4)
 150da4b:	48 8b 41 78          	mov    0x78(%rcx),%rax
 150da4f:	42 89 14 b8          	mov    %edx,(%rax,%r15,4)
 150da53:	0f b6 54 24 20       	movzbl 0x20(%rsp),%edx
 150da58:	48 8b 81 88 00 00 00 	mov    0x88(%rcx),%rax
 150da5f:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 150da64:	48 8b 81 90 00 00 00 	mov    0x90(%rcx),%rax
 150da6b:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 150da70:	48 8b 81 98 00 00 00 	mov    0x98(%rcx),%rax
 150da77:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 150da7c:	48 8b 41 10          	mov    0x10(%rcx),%rax
 150da80:	42 08 14 20          	or     %dl,(%rax,%r12,1)
 150da84:	4c 8b a9 08 01 00 00 	mov    0x108(%rcx),%r13
 150da8b:	4d 85 ed             	test   %r13,%r13
 150da8e:	0f 84 e4 00 00 00    	je     150db78 <tier0_tables_open+0x2228>
 150da94:	41 80 7d 4c 00       	cmpb   $0x0,0x4c(%r13)
 150da99:	0f 85 d9 00 00 00    	jne    150db78 <tier0_tables_open+0x2228>
 150da9f:	41 8b 45 08          	mov    0x8(%r13),%eax
 150daa3:	41 3b 45 0c          	cmp    0xc(%r13),%eax
 150daa7:	75 0a                	jne    150dab3 <tier0_tables_open+0x2163>
 150daa9:	41 c6 45 4c 01       	movb   $0x1,0x4c(%r13)
 150daae:	e9 c5 00 00 00       	jmp    150db78 <tier0_tables_open+0x2228>
 150dab3:	41 8b 6d 28          	mov    0x28(%r13),%ebp
 150dab7:	41 8b 4d 2c          	mov    0x2c(%r13),%ecx
 150dabb:	29 e9                	sub    %ebp,%ecx
 150dabd:	39 4c 24 08          	cmp    %ecx,0x8(%rsp)
 150dac1:	41 0f 97 45 4c       	seta   0x4c(%r13)
 150dac6:	0f 87 ac 00 00 00    	ja     150db78 <tier0_tables_open+0x2228>
 150dacc:	c4 c1 7b 10 45 30    	vmovsd 0x30(%r13),%xmm0
 150dad2:	41 ff 45 34          	incl   0x34(%r13)
 150dad6:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
 150dadb:	c5 f8 29 84 24 80 00 00 00 	vmovaps %xmm0,0x80(%rsp)
 150dae4:	74 2e                	je     150db14 <tier0_tables_open+0x21c4>
 150dae6:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
 150daeb:	48 89 ef             	mov    %rbp,%rdi
 150daee:	48 c1 e7 04          	shl    $0x4,%rdi
 150daf2:	49 03 7d 20          	add    0x20(%r13),%rdi
 150daf6:	48 8d b4 24 b0 01 00 00 	lea    0x1b0(%rsp),%rsi
 150dafe:	48 89 da             	mov    %rbx,%rdx
 150db01:	48 c1 e2 04          	shl    $0x4,%rdx
 150db05:	e8 46 69 25 ff       	call   764450 <memcpy@plt>
 150db0a:	41 01 5d 28          	add    %ebx,0x28(%r13)
 150db0e:	41 8b 45 08          	mov    0x8(%r13),%eax
 150db12:	eb 02                	jmp    150db16 <tier0_tables_open+0x21c6>
 150db14:	31 ed                	xor    %ebp,%ebp
 150db16:	c5 f9 6f 84 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm0
 150db1f:	8d 50 01             	lea    0x1(%rax),%edx
 150db22:	49 8b 4d 00          	mov    0x0(%r13),%rcx
 150db26:	8b 74 24 40          	mov    0x40(%rsp),%esi
 150db2a:	89 c0                	mov    %eax,%eax
 150db2c:	48 6b c0 38          	imul   $0x38,%rax,%rax
 150db30:	41 89 55 08          	mov    %edx,0x8(%r13)
 150db34:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 150db39:	c5 f9 d6 04 01       	vmovq  %xmm0,(%rcx,%rax,1)
 150db3e:	c6 44 01 08 03       	movb   $0x3,0x8(%rcx,%rax,1)
 150db43:	48 c7 44 01 09 00 00 00 00 	movq   $0x0,0x9(%rcx,%rax,1)
 150db4c:	48 c7 44 01 10 00 00 00 00 	movq   $0x0,0x10(%rcx,%rax,1)
 150db55:	89 6c 01 18          	mov    %ebp,0x18(%rcx,%rax,1)
 150db59:	89 54 01 1c          	mov    %edx,0x1c(%rcx,%rax,1)
 150db5d:	89 74 01 20          	mov    %esi,0x20(%rcx,%rax,1)
 150db61:	48 c7 44 01 24 00 00 00 00 	movq   $0x0,0x24(%rcx,%rax,1)
 150db6a:	44 89 7c 01 2c       	mov    %r15d,0x2c(%rcx,%rax,1)
 150db6f:	48 c7 44 01 30 00 00 00 00 	movq   $0x0,0x30(%rcx,%rax,1)
 150db78:	48 8b 0c 24          	mov    (%rsp),%rcx
 150db7c:	b8 0d 00 00 00       	mov    $0xd,%eax
 150db81:	44 3b 61 48          	cmp    0x48(%rcx),%r12d
 150db85:	0f 83 31 06 00 00    	jae    150e1bc <tier0_tables_open+0x286c>
 150db8b:	48 8b 0c 24          	mov    (%rsp),%rcx
 150db8f:	48 8b 09             	mov    (%rcx),%rcx
 150db92:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 150db97:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 150db9c:	84 c9                	test   %cl,%cl
 150db9e:	0f 84 18 06 00 00    	je     150e1bc <tier0_tables_open+0x286c>
 150dba4:	80 e1 fe             	and    $0xfe,%cl
 150dba7:	80 f9 10             	cmp    $0x10,%cl
 150dbaa:	0f 85 0c 06 00 00    	jne    150e1bc <tier0_tables_open+0x286c>
 150dbb0:	48 8b 0c 24          	mov    (%rsp),%rcx
 150dbb4:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 150dbb8:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 150dbbd:	80 e1 24             	and    $0x24,%cl
 150dbc0:	80 f9 20             	cmp    $0x20,%cl
 150dbc3:	0f 85 f3 05 00 00    	jne    150e1bc <tier0_tables_open+0x286c>
 150dbc9:	48 8b 3c 24          	mov    (%rsp),%rdi
 150dbcd:	be ff ff ff ff       	mov    $0xffffffff,%esi
 150dbd2:	bb 00 00 00 00       	mov    $0x0,%ebx
 150dbd7:	48 8b 47 28          	mov    0x28(%rdi),%rax
 150dbdb:	48 8b 8f 90 00 00 00 	mov    0x90(%rdi),%rcx
 150dbe2:	46 8b 04 a0          	mov    (%rax,%r12,4),%r8d
 150dbe6:	48 8b 47 38          	mov    0x38(%rdi),%rax
 150dbea:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 150dbef:	48 8b 47 60          	mov    0x60(%rdi),%rax
 150dbf3:	42 0f b6 0c 01       	movzbl (%rcx,%r8,1),%ecx
 150dbf8:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 150dbfd:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
 150dc01:	89 ca                	mov    %ecx,%edx
 150dc03:	01 f1                	add    %esi,%ecx
 150dc05:	c1 e8 03             	shr    $0x3,%eax
 150dc08:	84 d2                	test   %dl,%dl
 150dc0a:	ba 08 00 00 00       	mov    $0x8,%edx
 150dc0f:	c4 e2 f1 f7 ca       	shlx   %rcx,%rdx,%rcx
 150dc14:	48 0f 45 d9          	cmovne %rcx,%rbx
 150dc18:	48 8b 4f 78          	mov    0x78(%rdi),%rcx
 150dc1c:	46 8b 0c 81          	mov    (%rcx,%r8,4),%r9d
 150dc20:	48 8b 8f 98 00 00 00 	mov    0x98(%rdi),%rcx
 150dc27:	42 0f b6 0c 01       	movzbl (%rcx,%r8,1),%ecx
 150dc2c:	4c 89 8c 24 d8 00 00 00 	mov    %r9,0xd8(%rsp)
 150dc34:	89 ca                	mov    %ecx,%edx
 150dc36:	01 f1                	add    %esi,%ecx
 150dc38:	84 d2                	test   %dl,%dl
 150dc3a:	ba 01 00 00 00       	mov    $0x1,%edx
 150dc3f:	c4 e2 f1 f7 f2       	shlx   %rcx,%rdx,%rsi
 150dc44:	48 0f 44 f2          	cmove  %rdx,%rsi
 150dc48:	4d 85 c9             	test   %r9,%r9
 150dc4b:	0f 84 58 03 00 00    	je     150dfa9 <tier0_tables_open+0x2659>
 150dc51:	48 8b 0c 24          	mov    (%rsp),%rcx
 150dc55:	45 31 e4             	xor    %r12d,%r12d
 150dc58:	45 31 db             	xor    %r11d,%r11d
 150dc5b:	45 31 c9             	xor    %r9d,%r9d
 150dc5e:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 150dc6a:	48 8b b9 b8 00 00 00 	mov    0xb8(%rcx),%rdi
 150dc71:	4c 8b 41 20          	mov    0x20(%rcx),%r8
 150dc75:	48 8b 51 18          	mov    0x18(%rcx),%rdx
 150dc79:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
 150dc7e:	48 8b b9 c0 00 00 00 	mov    0xc0(%rcx),%rdi
 150dc85:	4c 89 84 24 40 01 00 00 	mov    %r8,0x140(%rsp)
 150dc8d:	4c 8b 81 c8 00 00 00 	mov    0xc8(%rcx),%r8
 150dc94:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
 150dc99:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 150dc9e:	48 89 bc 24 18 01 00 00 	mov    %rdi,0x118(%rsp)
 150dca6:	48 8b b9 b0 00 00 00 	mov    0xb0(%rcx),%rdi
 150dcad:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 150dcb5:	4c 8b 81 d0 00 00 00 	mov    0xd0(%rcx),%r8
 150dcbc:	48 89 bc 24 10 01 00 00 	mov    %rdi,0x110(%rsp)
 150dcc4:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
 150dcc9:	4c 89 84 24 b8 00 00 00 	mov    %r8,0xb8(%rsp)
 150dcd1:	4c 8b 81 d8 00 00 00 	mov    0xd8(%rcx),%r8
 150dcd8:	0f b6 04 07          	movzbl (%rdi,%rax,1),%eax
 150dcdc:	4c 89 84 24 48 01 00 00 	mov    %r8,0x148(%rsp)
 150dce4:	88 44 24 08          	mov    %al,0x8(%rsp)
 150dce8:	48 8b 81 88 00 00 00 	mov    0x88(%rcx),%rax
 150dcef:	48 8b 49 70          	mov    0x70(%rcx),%rcx
 150dcf3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
 150dcf7:	88 44 24 48          	mov    %al,0x48(%rsp)
 150dcfb:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 150dcfe:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 150dd03:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 150dd08:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 150dd0d:	42 8d 2c 20          	lea    (%rax,%r12,1),%ebp
 150dd11:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 150dd16:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
 150dd19:	c1 e8 03             	shr    $0x3,%eax
 150dd1c:	80 3c 01 0f          	cmpb   $0xf,(%rcx,%rax,1)
 150dd20:	48 89 c1             	mov    %rax,%rcx
 150dd23:	75 0e                	jne    150dd33 <tier0_tables_open+0x23e3>
 150dd25:	48 8b 8c 24 40 01 00 00 	mov    0x140(%rsp),%rcx
 150dd2d:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
 150dd30:	c1 e9 03             	shr    $0x3,%ecx
 150dd33:	48 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%rdx
 150dd3b:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
 150dd40:	41 ba 08 00 00 00    	mov    $0x8,%r10d
 150dd46:	0f b6 3c 2a          	movzbl (%rdx,%rbp,1),%edi
 150dd4a:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 150dd52:	41 0f 95 c5          	setne  %r13b
 150dd56:	44 0f b6 04 2a       	movzbl (%rdx,%rbp,1),%r8d
 150dd5b:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 150dd60:	48 8b 14 ca          	mov    (%rdx,%rcx,8),%rdx
 150dd64:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 150dd69:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
 150dd6d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 150dd72:	48 c1 e2 03          	shl    $0x3,%rdx
 150dd76:	40 84 ff             	test   %dil,%dil
 150dd79:	8d 0c 39             	lea    (%rcx,%rdi,1),%ecx
 150dd7c:	c4 c2 f1 f7 fa       	shlx   %rcx,%r10,%rdi
 150dd81:	b9 00 00 00 00       	mov    $0x0,%ecx
 150dd86:	48 0f 45 cf          	cmovne %rdi,%rcx
 150dd8a:	45 08 c5             	or     %r8b,%r13b
 150dd8d:	c4 c2 f9 f7 c2       	shlx   %rax,%r10,%rax
 150dd92:	41 f6 c0 02          	test   $0x2,%r8b
 150dd96:	0f 85 89 00 00 00    	jne    150de25 <tier0_tables_open+0x24d5>
 150dd9c:	48 39 c8             	cmp    %rcx,%rax
 150dd9f:	48 0f 46 c1          	cmovbe %rcx,%rax
 150dda3:	48 83 f9 09          	cmp    $0x9,%rcx
 150dda7:	73 05                	jae    150ddae <tier0_tables_open+0x245e>
 150dda9:	b9 08 00 00 00       	mov    $0x8,%ecx
 150ddae:	48 85 db             	test   %rbx,%rbx
 150ddb1:	74 10                	je     150ddc3 <tier0_tables_open+0x2473>
 150ddb3:	48 39 d8             	cmp    %rbx,%rax
 150ddb6:	72 03                	jb     150ddbb <tier0_tables_open+0x246b>
 150ddb8:	48 89 d8             	mov    %rbx,%rax
 150ddbb:	48 39 d9             	cmp    %rbx,%rcx
 150ddbe:	72 03                	jb     150ddc3 <tier0_tables_open+0x2473>
 150ddc0:	48 89 d9             	mov    %rbx,%rcx
 150ddc3:	44 0f b6 7c 24 08    	movzbl 0x8(%rsp),%r15d
 150ddc9:	41 f6 c5 01          	test   $0x1,%r13b
 150ddcd:	48 89 c7             	mov    %rax,%rdi
 150ddd0:	49 8d 43 ff          	lea    -0x1(%r11),%rax
 150ddd4:	48 0f 45 f9          	cmovne %rcx,%rdi
 150ddd8:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
 150dddf:	49 89 fa             	mov    %rdi,%r10
 150dde2:	41 80 ff 11          	cmp    $0x11,%r15b
 150dde6:	48 0f 44 c1          	cmove  %rcx,%rax
 150ddea:	49 f7 da             	neg    %r10
 150dded:	48 01 f8             	add    %rdi,%rax
 150ddf0:	49 21 c2             	and    %rax,%r10
 150ddf3:	4c 89 d1             	mov    %r10,%rcx
 150ddf6:	48 01 d1             	add    %rdx,%rcx
 150ddf9:	41 0f 93 c0          	setae  %r8b
 150ddfd:	0f 99 c0             	setns  %al
 150de00:	44 20 c0             	and    %r8b,%al
 150de03:	41 80 ff 11          	cmp    $0x11,%r15b
 150de07:	0f 85 b2 00 00 00    	jne    150debf <tier0_tables_open+0x256f>
 150de0d:	49 39 d3             	cmp    %rdx,%r11
 150de10:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 150de1c:	4c 0f 46 da          	cmovbe %rdx,%r11
 150de20:	e9 1f 01 00 00       	jmp    150df44 <tier0_tables_open+0x25f4>
 150de25:	48 8b bc 24 18 01 00 00 	mov    0x118(%rsp),%rdi
 150de2d:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 150de33:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 150de39:	44 8b 04 af          	mov    (%rdi,%rbp,4),%r8d
 150de3d:	4c 89 df             	mov    %r11,%rdi
 150de40:	48 2b bc 24 80 00 00 00 	sub    0x80(%rsp),%rdi
 150de48:	80 7c 24 08 11       	cmpb   $0x11,0x8(%rsp)
 150de4d:	4c 0f 45 d7          	cmovne %rdi,%r10
 150de51:	45 85 c0             	test   %r8d,%r8d
 150de54:	48 89 c7             	mov    %rax,%rdi
 150de57:	49 0f 45 ff          	cmovne %r15,%rdi
 150de5b:	41 f6 c5 01          	test   $0x1,%r13b
 150de5f:	48 0f 44 f8          	cmove  %rax,%rdi
 150de63:	48 85 c9             	test   %rcx,%rcx
 150de66:	74 0e                	je     150de76 <tier0_tables_open+0x2526>
 150de68:	48 39 cf             	cmp    %rcx,%rdi
 150de6b:	48 0f 46 f9          	cmovbe %rcx,%rdi
 150de6f:	48 39 c8             	cmp    %rcx,%rax
 150de72:	48 0f 46 c1          	cmovbe %rcx,%rax
 150de76:	48 85 db             	test   %rbx,%rbx
 150de79:	74 19                	je     150de94 <tier0_tables_open+0x2544>
 150de7b:	45 85 c0             	test   %r8d,%r8d
 150de7e:	74 14                	je     150de94 <tier0_tables_open+0x2544>
 150de80:	41 f6 c5 01          	test   $0x1,%r13b
 150de84:	48 0f 45 f8          	cmovne %rax,%rdi
 150de88:	48 39 df             	cmp    %rbx,%rdi
 150de8b:	72 03                	jb     150de90 <tier0_tables_open+0x2540>
 150de8d:	48 89 df             	mov    %rbx,%rdi
 150de90:	b0 01                	mov    $0x1,%al
 150de92:	eb 3e                	jmp    150ded2 <tier0_tables_open+0x2582>
 150de94:	4d 85 c0             	test   %r8,%r8
 150de97:	74 16                	je     150deaf <tier0_tables_open+0x255f>
 150de99:	b0 01                	mov    $0x1,%al
 150de9b:	48 85 db             	test   %rbx,%rbx
 150de9e:	75 32                	jne    150ded2 <tier0_tables_open+0x2582>
 150dea0:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 150dea4:	4c 21 d0             	and    %r10,%rax
 150dea7:	4c 01 c0             	add    %r8,%rax
 150deaa:	48 39 d0             	cmp    %rdx,%rax
 150dead:	76 21                	jbe    150ded0 <tier0_tables_open+0x2580>
 150deaf:	49 8d 44 3a ff       	lea    -0x1(%r10,%rdi,1),%rax
 150deb4:	49 89 fa             	mov    %rdi,%r10
 150deb7:	49 f7 da             	neg    %r10
 150deba:	49 21 c2             	and    %rax,%r10
 150debd:	eb 30                	jmp    150deef <tier0_tables_open+0x259f>
 150debf:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 150decb:	49 89 cb             	mov    %rcx,%r11
 150dece:	eb 74                	jmp    150df44 <tier0_tables_open+0x25f4>
 150ded0:	31 c0                	xor    %eax,%eax
 150ded2:	48 39 d9             	cmp    %rbx,%rcx
 150ded5:	0f 97 c2             	seta   %dl
 150ded8:	48 85 c9             	test   %rcx,%rcx
 150dedb:	74 12                	je     150deef <tier0_tables_open+0x259f>
 150dedd:	20 c2                	and    %al,%dl
 150dedf:	75 0e                	jne    150deef <tier0_tables_open+0x259f>
 150dee1:	49 8d 44 0a ff       	lea    -0x1(%r10,%rcx,1),%rax
 150dee6:	48 f7 d9             	neg    %rcx
 150dee9:	48 21 c1             	and    %rax,%rcx
 150deec:	49 89 ca             	mov    %rcx,%r10
 150deef:	48 8b 84 24 10 01 00 00 	mov    0x110(%rsp),%rax
 150def7:	83 3c a8 00          	cmpl   $0x0,(%rax,%rbp,4)
 150defb:	b8 01 00 00 00       	mov    $0x1,%eax
 150df00:	48 0f 44 f8          	cmove  %rax,%rdi
 150df04:	80 7c 24 08 11       	cmpb   $0x11,0x8(%rsp)
 150df09:	75 1d                	jne    150df28 <tier0_tables_open+0x25d8>
 150df0b:	49 83 c0 07          	add    $0x7,%r8
 150df0f:	48 b8 f8 ff ff ff 01 00 00 00 	movabs $0x1fffffff8,%rax
 150df19:	49 21 c0             	and    %rax,%r8
 150df1c:	4d 39 c3             	cmp    %r8,%r11
 150df1f:	77 03                	ja     150df24 <tier0_tables_open+0x25d4>
 150df21:	4d 89 c3             	mov    %r8,%r11
 150df24:	b0 01                	mov    $0x1,%al
 150df26:	eb 1c                	jmp    150df44 <tier0_tables_open+0x25f4>
 150df28:	4f 8d 5c 02 07       	lea    0x7(%r10,%r8,1),%r11
 150df2d:	49 83 e3 f8          	and    $0xfffffffffffffff8,%r11
 150df31:	4c 89 d9             	mov    %r11,%rcx
 150df34:	4c 29 d1             	sub    %r10,%rcx
 150df37:	4c 29 c1             	sub    %r8,%rcx
 150df3a:	b0 01                	mov    $0x1,%al
 150df3c:	48 89 8c 24 80 00 00 00 	mov    %rcx,0x80(%rsp)
 150df44:	48 8b 8c 24 48 01 00 00 	mov    0x148(%rsp),%rcx
 150df4c:	4d 39 d9             	cmp    %r11,%r9
 150df4f:	4d 0f 46 cb          	cmovbe %r11,%r9
 150df53:	48 c1 ef 03          	shr    $0x3,%rdi
 150df57:	48 39 fe             	cmp    %rdi,%rsi
 150df5a:	48 0f 46 f7          	cmovbe %rdi,%rsi
 150df5e:	4d 85 db             	test   %r11,%r11
 150df61:	4c 89 14 e9          	mov    %r10,(%rcx,%rbp,8)
 150df65:	0f 99 c1             	setns  %cl
 150df68:	20 c1                	and    %al,%cl
 150df6a:	80 f9 01             	cmp    $0x1,%cl
 150df6d:	75 11                	jne    150df80 <tier0_tables_open+0x2630>
 150df6f:	49 ff c4             	inc    %r12
 150df72:	4c 3b a4 24 d8 00 00 00 	cmp    0xd8(%rsp),%r12
 150df7a:	0f 82 83 fd ff ff    	jb     150dd03 <tier0_tables_open+0x23b3>
 150df80:	84 c9                	test   %cl,%cl
 150df82:	0f 84 2f 02 00 00    	je     150e1b7 <tier0_tables_open+0x2867>
 150df88:	48 8b 04 24          	mov    (%rsp),%rax
 150df8c:	49 ff c9             	dec    %r9
 150df8f:	48 8b 48 38          	mov    0x38(%rax),%rcx
 150df93:	48 8b 40 60          	mov    0x60(%rax),%rax
 150df97:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 150df9c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 150dfa1:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 150dfa4:	c1 e8 03             	shr    $0x3,%eax
 150dfa7:	eb 07                	jmp    150dfb0 <tier0_tables_open+0x2660>
 150dfa9:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
 150dfb0:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 150dfb5:	31 c9                	xor    %ecx,%ecx
 150dfb7:	f3 48 0f bc ce       	tzcnt  %rsi,%rcx
 150dfbc:	49 8d 14 f1          	lea    (%r9,%rsi,8),%rdx
 150dfc0:	48 c1 e6 03          	shl    $0x3,%rsi
 150dfc4:	48 f7 de             	neg    %rsi
 150dfc7:	48 21 d6             	and    %rdx,%rsi
 150dfca:	48 c1 ee 03          	shr    $0x3,%rsi
 150dfce:	48 89 34 c7          	mov    %rsi,(%rdi,%rax,8)
 150dfd2:	48 8b 3c 24          	mov    (%rsp),%rdi
 150dfd6:	48 8b 57 18          	mov    0x18(%rdi),%rdx
 150dfda:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
 150dfdd:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 150dfe2:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
 150dfe6:	80 0c 01 04          	orb    $0x4,(%rcx,%rax,1)
 150dfea:	8b 87 a8 00 00 00    	mov    0xa8(%rdi),%eax
 150dff0:	ff c0                	inc    %eax
 150dff2:	89 87 a8 00 00 00    	mov    %eax,0xa8(%rdi)
 150dff8:	48 8b 8f 80 00 00 00 	mov    0x80(%rdi),%rcx
 150dfff:	89 04 91             	mov    %eax,(%rcx,%rdx,4)
 150e002:	48 8b 87 08 01 00 00 	mov    0x108(%rdi),%rax
 150e009:	48 85 c0             	test   %rax,%rax
 150e00c:	74 74                	je     150e082 <tier0_tables_open+0x2732>
 150e00e:	80 78 4c 00          	cmpb   $0x0,0x4c(%rax)
 150e012:	75 6e                	jne    150e082 <tier0_tables_open+0x2732>
 150e014:	8b 48 08             	mov    0x8(%rax),%ecx
 150e017:	3b 48 0c             	cmp    0xc(%rax),%ecx
 150e01a:	75 06                	jne    150e022 <tier0_tables_open+0x26d2>
 150e01c:	c6 40 4c 01          	movb   $0x1,0x4c(%rax)
 150e020:	eb 60                	jmp    150e082 <tier0_tables_open+0x2732>
 150e022:	48 8b 14 24          	mov    (%rsp),%rdx
 150e026:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 150e02b:	8d 71 01             	lea    0x1(%rcx),%esi
 150e02e:	48 6b c9 38          	imul   $0x38,%rcx,%rcx
 150e032:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150e036:	48 8b 52 60          	mov    0x60(%rdx),%rdx
 150e03a:	42 8b 14 82          	mov    (%rdx,%r8,4),%edx
 150e03e:	c6 40 4c 00          	movb   $0x0,0x4c(%rax)
 150e042:	89 70 08             	mov    %esi,0x8(%rax)
 150e045:	48 8b 30             	mov    (%rax),%rsi
 150e048:	48 8b 78 30          	mov    0x30(%rax),%rdi
 150e04c:	ff 40 34             	incl   0x34(%rax)
 150e04f:	48 89 3c 0e          	mov    %rdi,(%rsi,%rcx,1)
 150e053:	c6 44 0e 08 04       	movb   $0x4,0x8(%rsi,%rcx,1)
 150e058:	c5 fa 7f 44 0e 09    	vmovdqu %xmm0,0x9(%rsi,%rcx,1)
 150e05e:	48 c7 44 0e 18 00 00 00 00 	movq   $0x0,0x18(%rsi,%rcx,1)
 150e067:	89 54 0e 20          	mov    %edx,0x20(%rsi,%rcx,1)
 150e06b:	48 c7 44 0e 24 00 00 00 00 	movq   $0x0,0x24(%rsi,%rcx,1)
 150e074:	44 89 44 0e 2c       	mov    %r8d,0x2c(%rsi,%rcx,1)
 150e079:	48 c7 44 0e 30 00 00 00 00 	movq   $0x0,0x30(%rsi,%rcx,1)
 150e082:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 150e087:	48 8b 0c 24          	mov    (%rsp),%rcx
 150e08b:	8b 40 68             	mov    0x68(%rax),%eax
 150e08e:	48 8b 11             	mov    (%rcx),%rdx
 150e091:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 150e095:	c1 e8 03             	shr    $0x3,%eax
 150e098:	80 3c 02 0f          	cmpb   $0xf,(%rdx,%rax,1)
 150e09c:	48 89 c2             	mov    %rax,%rdx
 150e09f:	75 0e                	jne    150e0af <tier0_tables_open+0x275f>
 150e0a1:	48 8b 14 24          	mov    (%rsp),%rdx
 150e0a5:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 150e0a9:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 150e0ac:	c1 ea 03             	shr    $0x3,%edx
 150e0af:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 150e0b4:	8b 76 5c             	mov    0x5c(%rsi),%esi
 150e0b7:	48 39 34 d1          	cmp    %rsi,(%rcx,%rdx,8)
 150e0bb:	0f 85 e7 00 00 00    	jne    150e1a8 <tier0_tables_open+0x2858>
 150e0c1:	48 8b 14 24          	mov    (%rsp),%rdx
 150e0c5:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
 150e0c9:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
 150e0cd:	b9 01 00 00 00       	mov    $0x1,%ecx
 150e0d2:	c4 e2 79 f7 c1       	shlx   %eax,%ecx,%eax
 150e0d7:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 150e0dc:	8b 49 60             	mov    0x60(%rcx),%ecx
 150e0df:	ff 82 60 1f 00 00    	incl   0x1f60(%rdx)
 150e0e5:	48 83 7c 24 68 39    	cmpq   $0x39,0x68(%rsp)
 150e0eb:	77 0d                	ja     150e0fa <tier0_tables_open+0x27aa>
 150e0ed:	48 ff 44 24 68       	incq   0x68(%rsp)
 150e0f2:	39 c8                	cmp    %ecx,%eax
 150e0f4:	0f 84 9f f1 ff ff    	je     150d299 <tier0_tables_open+0x1949>
 150e0fa:	39 c8                	cmp    %ecx,%eax
 150e0fc:	0f 85 7d ed ff ff    	jne    150ce7f <tier0_tables_open+0x152f>
 150e102:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 150e10b:	4d 85 e4             	test   %r12,%r12
 150e10e:	0f 84 d2 00 00 00    	je     150e1e6 <tier0_tables_open+0x2896>
 150e114:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 150e11d:	48 89 84 24 58 01 00 00 	mov    %rax,0x158(%rsp)
 150e125:	e9 81 01 00 00       	jmp    150e2ab <tier0_tables_open+0x295b>
 150e12a:	c5 f8 77             	vzeroupper
 150e12d:	e8 ae 59 25 ff       	call   763ae0 <__stack_chk_fail@plt>
 150e132:	48 8b 0c 24          	mov    (%rsp),%rcx
 150e136:	48 8b 81 08 01 00 00 	mov    0x108(%rcx),%rax
 150e13d:	c7 81 00 01 00 00 01 00 00 00 	movl   $0x1,0x100(%rcx)
 150e147:	48 85 c0             	test   %rax,%rax
 150e14a:	74 16                	je     150e162 <tier0_tables_open+0x2812>
 150e14c:	c6 40 3c 01          	movb   $0x1,0x3c(%rax)
 150e150:	48 8b 48 30          	mov    0x30(%rax),%rcx
 150e154:	48 89 48 40          	mov    %rcx,0x40(%rax)
 150e158:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%rax)
 150e15f:	ff 40 34             	incl   0x34(%rax)
 150e162:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 150e167:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
 150e16e:	eb 38                	jmp    150e1a8 <tier0_tables_open+0x2858>
 150e170:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 150e176:	eb 06                	jmp    150e17e <tier0_tables_open+0x282e>
 150e178:	41 ba 0f 00 00 00    	mov    $0xf,%r10d
 150e17e:	48 8b 0c 24          	mov    (%rsp),%rcx
 150e182:	48 8b 81 08 01 00 00 	mov    0x108(%rcx),%rax
 150e189:	44 89 91 00 01 00 00 	mov    %r10d,0x100(%rcx)
 150e190:	48 85 c0             	test   %rax,%rax
 150e193:	74 13                	je     150e1a8 <tier0_tables_open+0x2858>
 150e195:	c6 40 3c 01          	movb   $0x1,0x3c(%rax)
 150e199:	48 8b 48 30          	mov    0x30(%rax),%rcx
 150e19d:	48 89 48 40          	mov    %rcx,0x40(%rax)
 150e1a1:	44 89 50 48          	mov    %r10d,0x48(%rax)
 150e1a5:	ff 40 34             	incl   0x34(%rax)
 150e1a8:	48 8b 04 24          	mov    (%rsp),%rax
 150e1ac:	ff 80 60 1f 00 00    	incl   0x1f60(%rax)
 150e1b2:	e9 c8 ec ff ff       	jmp    150ce7f <tier0_tables_open+0x152f>
 150e1b7:	b8 05 00 00 00       	mov    $0x5,%eax
 150e1bc:	48 8b 14 24          	mov    (%rsp),%rdx
 150e1c0:	48 8b 8a 08 01 00 00 	mov    0x108(%rdx),%rcx
 150e1c7:	89 82 00 01 00 00    	mov    %eax,0x100(%rdx)
 150e1cd:	48 85 c9             	test   %rcx,%rcx
 150e1d0:	74 d6                	je     150e1a8 <tier0_tables_open+0x2858>
 150e1d2:	c6 41 3c 01          	movb   $0x1,0x3c(%rcx)
 150e1d6:	48 8b 51 30          	mov    0x30(%rcx),%rdx
 150e1da:	48 89 51 40          	mov    %rdx,0x40(%rcx)
 150e1de:	89 41 48             	mov    %eax,0x48(%rcx)
 150e1e1:	ff 41 34             	incl   0x34(%rcx)
 150e1e4:	eb c2                	jmp    150e1a8 <tier0_tables_open+0x2858>
 150e1e6:	49 bf 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r15
 150e1f0:	ba 03 00 00 00       	mov    $0x3,%edx
 150e1f5:	b9 22 40 00 00       	mov    $0x4022,%ecx
 150e1fa:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150e200:	45 31 ed             	xor    %r13d,%r13d
 150e203:	31 ff                	xor    %edi,%edi
 150e205:	45 31 c9             	xor    %r9d,%r9d
 150e208:	4c 89 fe             	mov    %r15,%rsi
 150e20b:	e8 30 63 25 ff       	call   764540 <mmap@plt>
 150e210:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 150e214:	74 5c                	je     150e272 <tier0_tables_open+0x2922>
 150e216:	4c 8d a0 ff ff 20 00 	lea    0x20ffff(%rax),%r12
 150e21d:	ba 0f 00 00 00       	mov    $0xf,%edx
 150e222:	48 89 c7             	mov    %rax,%rdi
 150e225:	49 81 e4 00 00 e0 ff 	and    $0xffffffffffe00000,%r12
 150e22c:	4d 89 e5             	mov    %r12,%r13
 150e22f:	49 29 c5             	sub    %rax,%r13
 150e232:	4c 89 ee             	mov    %r13,%rsi
 150e235:	49 8d ad 00 00 ff ff 	lea    -0x10000(%r13),%rbp
 150e23c:	e8 af 62 25 ff       	call   7644f0 <madvise@plt>
 150e241:	4c 89 fe             	mov    %r15,%rsi
 150e244:	4c 29 ee             	sub    %r13,%rsi
 150e247:	ba 0e 00 00 00       	mov    $0xe,%edx
 150e24c:	4c 89 e7             	mov    %r12,%rdi
 150e24f:	e8 9c 62 25 ff       	call   7644f0 <madvise@plt>
 150e254:	49 81 c7 00 00 e0 ff 	add    $0xffffffffffe00000,%r15
 150e25b:	49 81 c4 00 00 ff ff 	add    $0xffffffffffff0000,%r12
 150e262:	4d 89 fd             	mov    %r15,%r13
 150e265:	eb 10                	jmp    150e277 <tier0_tables_open+0x2927>
 150e267:	41 ba 0c 00 00 00    	mov    $0xc,%r10d
 150e26d:	e9 0c ff ff ff       	jmp    150e17e <tier0_tables_open+0x282e>
 150e272:	45 31 e4             	xor    %r12d,%r12d
 150e275:	31 ed                	xor    %ebp,%ebp
 150e277:	64 4c 89 24 25 10 ff ff ff 	mov    %r12,%fs:0xffffffffffffff10
 150e280:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 150e28d:	64 4c 89 2c 25 20 ff ff ff 	mov    %r13,%fs:0xffffffffffffff20
 150e296:	64 48 89 2c 25 28 ff ff ff 	mov    %rbp,%fs:0xffffffffffffff28
 150e29f:	48 c7 84 24 58 01 00 00 00 00 00 00 	movq   $0x0,0x158(%rsp)
 150e2ab:	48 8b 04 24          	mov    (%rsp),%rax
 150e2af:	48 8b 8c 24 58 01 00 00 	mov    0x158(%rsp),%rcx
 150e2b7:	44 8b 68 48          	mov    0x48(%rax),%r13d
 150e2bb:	4a 8d 04 21          	lea    (%rcx,%r12,1),%rax
 150e2bf:	4a 8d 4c 21 03       	lea    0x3(%rcx,%r12,1),%rcx
 150e2c4:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 150e2c8:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
 150e2cd:	48 39 c1             	cmp    %rax,%rcx
 150e2d0:	72 6f                	jb     150e341 <tier0_tables_open+0x29f1>
 150e2d2:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 150e2d7:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 150e2e0:	4a 8d 04 ad 00 00 00 00 	lea    0x0(,%r13,4),%rax
 150e2e8:	4c 29 e2             	sub    %r12,%rdx
 150e2eb:	48 89 ce             	mov    %rcx,%rsi
 150e2ee:	48 29 d6             	sub    %rdx,%rsi
 150e2f1:	40 0f 92 c7          	setb   %dil
 150e2f5:	48 39 f0             	cmp    %rsi,%rax
 150e2f8:	40 0f 97 c6          	seta   %sil
 150e2fc:	40 08 fe             	or     %dil,%sil
 150e2ff:	75 40                	jne    150e341 <tier0_tables_open+0x29f1>
 150e301:	48 01 c2             	add    %rax,%rdx
 150e304:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
 150e30a:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 150e313:	74 2c                	je     150e341 <tier0_tables_open+0x29f1>
 150e315:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 150e31a:	48 01 c2             	add    %rax,%rdx
 150e31d:	48 89 94 24 60 01 00 00 	mov    %rdx,0x160(%rsp)
 150e325:	4c 29 e2             	sub    %r12,%rdx
 150e328:	48 29 d1             	sub    %rdx,%rcx
 150e32b:	40 0f 92 c6          	setb   %sil
 150e32f:	48 39 c8             	cmp    %rcx,%rax
 150e332:	0f 97 c1             	seta   %cl
 150e335:	40 08 f1             	or     %sil,%cl
 150e338:	80 f9 01             	cmp    $0x1,%cl
 150e33b:	0f 85 f1 04 00 00    	jne    150e832 <tier0_tables_open+0x2ee2>
 150e341:	48 8b 04 24          	mov    (%rsp),%rax
 150e345:	83 b8 c0 01 00 00 00 	cmpl   $0x0,0x1c0(%rax)
 150e34c:	0f 95 c0             	setne  %al
 150e34f:	89 44 24 18          	mov    %eax,0x18(%rsp)
 150e353:	41 83 fd 02          	cmp    $0x2,%r13d
 150e357:	0f 82 54 33 00 00    	jb     15116b1 <tier0_tables_open+0x5d61>
 150e35d:	b8 01 00 00 00       	mov    $0x1,%eax
 150e362:	49 83 fd 02          	cmp    $0x2,%r13
 150e366:	0f 84 08 02 00 00    	je     150e574 <tier0_tables_open+0x2c24>
 150e36c:	49 8d 4d ff          	lea    -0x1(%r13),%rcx
 150e370:	48 89 ca             	mov    %rcx,%rdx
 150e373:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
 150e377:	48 f7 da             	neg    %rdx
 150e37a:	eb 1b                	jmp    150e397 <tier0_tables_open+0x2a47>
 150e37c:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 150e384:	48 8d 74 02 02       	lea    0x2(%rdx,%rax,1),%rsi
 150e389:	48 83 c0 02          	add    $0x2,%rax
 150e38d:	48 83 fe 01          	cmp    $0x1,%rsi
 150e391:	0f 84 d4 01 00 00    	je     150e56b <tier0_tables_open+0x2c1b>
 150e397:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
 150e39c:	74 09                	je     150e3a7 <tier0_tables_open+0x2a57>
 150e39e:	40 b6 01             	mov    $0x1,%sil
 150e3a1:	89 74 24 18          	mov    %esi,0x18(%rsp)
 150e3a5:	eb dd                	jmp    150e384 <tier0_tables_open+0x2a34>
 150e3a7:	48 8b 34 24          	mov    (%rsp),%rsi
 150e3ab:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 150e3b2:	f6 44 86 01 80       	testb  $0x80,0x1(%rsi,%rax,4)
 150e3b7:	0f 85 ae 00 00 00    	jne    150e46b <tier0_tables_open+0x2b1b>
 150e3bd:	48 8b 34 24          	mov    (%rsp),%rsi
 150e3c1:	89 c7                	mov    %eax,%edi
 150e3c3:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 150e3c9:	48 8b 36             	mov    (%rsi),%rsi
 150e3cc:	44 0f b6 0c 3e       	movzbl (%rsi,%rdi,1),%r9d
 150e3d1:	41 80 f9 0f          	cmp    $0xf,%r9b
 150e3d5:	75 14                	jne    150e3eb <tier0_tables_open+0x2a9b>
 150e3d7:	4c 8b 04 24          	mov    (%rsp),%r8
 150e3db:	4d 8b 40 20          	mov    0x20(%r8),%r8
 150e3df:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 150e3e3:	c1 ef 03             	shr    $0x3,%edi
 150e3e6:	44 0f b6 0c 3e       	movzbl (%rsi,%rdi,1),%r9d
 150e3eb:	45 0f b6 d1          	movzbl %r9b,%r10d
 150e3ef:	45 31 c0             	xor    %r8d,%r8d
 150e3f2:	45 8d 5a f7          	lea    -0x9(%r10),%r11d
 150e3f6:	41 83 fb 03          	cmp    $0x3,%r11d
 150e3fa:	72 72                	jb     150e46e <tier0_tables_open+0x2b1e>
 150e3fc:	45 85 d2             	test   %r10d,%r10d
 150e3ff:	74 6d                	je     150e46e <tier0_tables_open+0x2b1e>
 150e401:	41 83 fa 01          	cmp    $0x1,%r10d
 150e405:	74 1b                	je     150e422 <tier0_tables_open+0x2ad2>
 150e407:	45 31 c0             	xor    %r8d,%r8d
 150e40a:	45 84 c9             	test   %r9b,%r9b
 150e40d:	74 5f                	je     150e46e <tier0_tables_open+0x2b1e>
 150e40f:	4c 8b 0c 24          	mov    (%rsp),%r9
 150e413:	4d 8b 49 10          	mov    0x10(%r9),%r9
 150e417:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
 150e41c:	40 80 e7 04          	and    $0x4,%dil
 150e420:	74 4c                	je     150e46e <tier0_tables_open+0x2b1e>
 150e422:	80 3c 06 0e          	cmpb   $0xe,(%rsi,%rax,1)
 150e426:	0f 85 27 01 00 00    	jne    150e553 <tier0_tables_open+0x2c03>
 150e42c:	48 8b 3c 24          	mov    (%rsp),%rdi
 150e430:	4c 8b 47 20          	mov    0x20(%rdi),%r8
 150e434:	41 8b 3c 80          	mov    (%r8,%rax,4),%edi
 150e438:	c1 ef 03             	shr    $0x3,%edi
 150e43b:	80 3c 3e 0f          	cmpb   $0xf,(%rsi,%rdi,1)
 150e43f:	75 07                	jne    150e448 <tier0_tables_open+0x2af8>
 150e441:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 150e445:	c1 ef 03             	shr    $0x3,%edi
 150e448:	48 8b 34 24          	mov    (%rsp),%rsi
 150e44c:	48 8b 76 38          	mov    0x38(%rsi),%rsi
 150e450:	48 83 3c fe 00       	cmpq   $0x0,(%rsi,%rdi,8)
 150e455:	41 0f 94 c0          	sete   %r8b
 150e459:	40 b6 01             	mov    $0x1,%sil
 150e45c:	89 74 24 18          	mov    %esi,0x18(%rsp)
 150e460:	45 84 c0             	test   %r8b,%r8b
 150e463:	0f 85 1b ff ff ff    	jne    150e384 <tier0_tables_open+0x2a34>
 150e469:	eb 13                	jmp    150e47e <tier0_tables_open+0x2b2e>
 150e46b:	45 31 c0             	xor    %r8d,%r8d
 150e46e:	40 b6 01             	mov    $0x1,%sil
 150e471:	89 74 24 18          	mov    %esi,0x18(%rsp)
 150e475:	45 84 c0             	test   %r8b,%r8b
 150e478:	0f 85 06 ff ff ff    	jne    150e384 <tier0_tables_open+0x2a34>
 150e47e:	48 8b 34 24          	mov    (%rsp),%rsi
 150e482:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 150e489:	f6 44 86 05 80       	testb  $0x80,0x5(%rsi,%rax,4)
 150e48e:	0f 85 e8 fe ff ff    	jne    150e37c <tier0_tables_open+0x2a2c>
 150e494:	48 8b 34 24          	mov    (%rsp),%rsi
 150e498:	48 8d 78 01          	lea    0x1(%rax),%rdi
 150e49c:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 150e4a2:	48 8b 36             	mov    (%rsi),%rsi
 150e4a5:	44 0f b6 04 3e       	movzbl (%rsi,%rdi,1),%r8d
 150e4aa:	41 80 f8 0f          	cmp    $0xf,%r8b
 150e4ae:	75 14                	jne    150e4c4 <tier0_tables_open+0x2b74>
 150e4b0:	4c 8b 04 24          	mov    (%rsp),%r8
 150e4b4:	4d 8b 40 20          	mov    0x20(%r8),%r8
 150e4b8:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 150e4bc:	c1 ef 03             	shr    $0x3,%edi
 150e4bf:	44 0f b6 04 3e       	movzbl (%rsi,%rdi,1),%r8d
 150e4c4:	45 0f b6 c8          	movzbl %r8b,%r9d
 150e4c8:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 150e4d0:	45 8d 51 f7          	lea    -0x9(%r9),%r10d
 150e4d4:	41 83 fa 03          	cmp    $0x3,%r10d
 150e4d8:	0f 82 a6 fe ff ff    	jb     150e384 <tier0_tables_open+0x2a34>
 150e4de:	45 85 c9             	test   %r9d,%r9d
 150e4e1:	0f 84 9d fe ff ff    	je     150e384 <tier0_tables_open+0x2a34>
 150e4e7:	41 83 f9 01          	cmp    $0x1,%r9d
 150e4eb:	74 28                	je     150e515 <tier0_tables_open+0x2bc5>
 150e4ed:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 150e4f5:	45 84 c0             	test   %r8b,%r8b
 150e4f8:	0f 84 86 fe ff ff    	je     150e384 <tier0_tables_open+0x2a34>
 150e4fe:	4c 8b 04 24          	mov    (%rsp),%r8
 150e502:	4d 8b 40 10          	mov    0x10(%r8),%r8
 150e506:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
 150e50b:	40 80 e7 04          	and    $0x4,%dil
 150e50f:	0f 84 6f fe ff ff    	je     150e384 <tier0_tables_open+0x2a34>
 150e515:	80 7c 06 01 0e       	cmpb   $0xe,0x1(%rsi,%rax,1)
 150e51a:	0f 85 5c fe ff ff    	jne    150e37c <tier0_tables_open+0x2a2c>
 150e520:	48 8b 3c 24          	mov    (%rsp),%rdi
 150e524:	4c 8b 47 20          	mov    0x20(%rdi),%r8
 150e528:	41 8b 7c 80 04       	mov    0x4(%r8,%rax,4),%edi
 150e52d:	c1 ef 03             	shr    $0x3,%edi
 150e530:	80 3c 3e 0f          	cmpb   $0xf,(%rsi,%rdi,1)
 150e534:	75 07                	jne    150e53d <tier0_tables_open+0x2bed>
 150e536:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 150e53a:	c1 ef 03             	shr    $0x3,%edi
 150e53d:	48 8b 34 24          	mov    (%rsp),%rsi
 150e541:	48 8b 76 38          	mov    0x38(%rsi),%rsi
 150e545:	48 83 3c fe 00       	cmpq   $0x0,(%rsi,%rdi,8)
 150e54a:	40 0f 94 c6          	sete   %sil
 150e54e:	e9 4e fe ff ff       	jmp    150e3a1 <tier0_tables_open+0x2a51>
 150e553:	45 31 c0             	xor    %r8d,%r8d
 150e556:	40 b6 01             	mov    $0x1,%sil
 150e559:	89 74 24 18          	mov    %esi,0x18(%rsp)
 150e55d:	45 84 c0             	test   %r8b,%r8b
 150e560:	0f 85 1e fe ff ff    	jne    150e384 <tier0_tables_open+0x2a34>
 150e566:	e9 13 ff ff ff       	jmp    150e47e <tier0_tables_open+0x2b2e>
 150e56b:	f6 c1 01             	test   $0x1,%cl
 150e56e:	0f 84 c9 00 00 00    	je     150e63d <tier0_tables_open+0x2ced>
 150e574:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 150e579:	b1 01                	mov    $0x1,%cl
 150e57b:	89 4c 24 18          	mov    %ecx,0x18(%rsp)
 150e57f:	0f 85 b8 00 00 00    	jne    150e63d <tier0_tables_open+0x2ced>
 150e585:	48 8b 0c 24          	mov    (%rsp),%rcx
 150e589:	48 8b 89 88 01 00 00 	mov    0x188(%rcx),%rcx
 150e590:	f6 44 81 01 80       	testb  $0x80,0x1(%rcx,%rax,4)
 150e595:	0f 85 9a 00 00 00    	jne    150e635 <tier0_tables_open+0x2ce5>
 150e59b:	48 8b 0c 24          	mov    (%rsp),%rcx
 150e59f:	89 c2                	mov    %eax,%edx
 150e5a1:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 150e5a7:	48 8b 09             	mov    (%rcx),%rcx
 150e5aa:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 150e5ae:	40 80 fe 0f          	cmp    $0xf,%sil
 150e5b2:	75 12                	jne    150e5c6 <tier0_tables_open+0x2c76>
 150e5b4:	48 8b 34 24          	mov    (%rsp),%rsi
 150e5b8:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 150e5bc:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 150e5bf:	c1 ea 03             	shr    $0x3,%edx
 150e5c2:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 150e5c6:	40 0f b6 fe          	movzbl %sil,%edi
 150e5ca:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 150e5d2:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 150e5d6:	41 83 f8 03          	cmp    $0x3,%r8d
 150e5da:	72 61                	jb     150e63d <tier0_tables_open+0x2ced>
 150e5dc:	85 ff                	test   %edi,%edi
 150e5de:	74 5d                	je     150e63d <tier0_tables_open+0x2ced>
 150e5e0:	83 ff 01             	cmp    $0x1,%edi
 150e5e3:	74 1e                	je     150e603 <tier0_tables_open+0x2cb3>
 150e5e5:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 150e5ed:	40 84 f6             	test   %sil,%sil
 150e5f0:	74 4b                	je     150e63d <tier0_tables_open+0x2ced>
 150e5f2:	48 8b 34 24          	mov    (%rsp),%rsi
 150e5f6:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 150e5fa:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
 150e5fe:	80 e2 04             	and    $0x4,%dl
 150e601:	74 3a                	je     150e63d <tier0_tables_open+0x2ced>
 150e603:	80 3c 01 0e          	cmpb   $0xe,(%rcx,%rax,1)
 150e607:	75 2c                	jne    150e635 <tier0_tables_open+0x2ce5>
 150e609:	48 8b 14 24          	mov    (%rsp),%rdx
 150e60d:	48 8b 72 20          	mov    0x20(%rdx),%rsi
 150e611:	48 8b 52 38          	mov    0x38(%rdx),%rdx
 150e615:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 150e618:	c1 e8 03             	shr    $0x3,%eax
 150e61b:	80 3c 01 0f          	cmpb   $0xf,(%rcx,%rax,1)
 150e61f:	75 06                	jne    150e627 <tier0_tables_open+0x2cd7>
 150e621:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 150e624:	c1 e8 03             	shr    $0x3,%eax
 150e627:	48 83 3c c2 00       	cmpq   $0x0,(%rdx,%rax,8)
 150e62c:	0f 94 c0             	sete   %al
 150e62f:	89 44 24 18          	mov    %eax,0x18(%rsp)
 150e633:	eb 08                	jmp    150e63d <tier0_tables_open+0x2ced>
 150e635:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 150e63d:	bd 01 00 00 00       	mov    $0x1,%ebp
 150e642:	45 31 ff             	xor    %r15d,%r15d
 150e645:	48 8d 9c 24 b0 01 00 00 	lea    0x1b0(%rsp),%rbx
 150e64d:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 150e653:	eb 35                	jmp    150e68a <tier0_tables_open+0x2d3a>
 150e655:	48 8b 34 24          	mov    (%rsp),%rsi
 150e659:	b9 01 00 00 00       	mov    $0x1,%ecx
 150e65e:	4c 89 f7             	mov    %r14,%rdi
 150e661:	48 89 da             	mov    %rbx,%rdx
 150e664:	e8 97 43 01 00       	call   1522a00 <abi_classify_scalar>
 150e669:	41 b7 01             	mov    $0x1,%r15b
 150e66c:	49 ff c4             	inc    %r12
 150e66f:	4d 39 ec             	cmp    %r13,%r12
 150e672:	0f 95 c0             	setne  %al
 150e675:	4c 0f 44 e5          	cmove  %rbp,%r12
 150e679:	89 c1                	mov    %eax,%ecx
 150e67b:	44 08 f9             	or     %r15b,%cl
 150e67e:	41 20 c7             	and    %al,%r15b
 150e681:	f6 c1 01             	test   $0x1,%cl
 150e684:	0f 84 27 30 00 00    	je     15116b1 <tier0_tables_open+0x5d61>
 150e68a:	48 8b 0c 24          	mov    (%rsp),%rcx
 150e68e:	42 8d 04 e5 00 00 00 00 	lea    0x0(,%r12,8),%eax
 150e696:	89 84 24 b0 01 00 00 	mov    %eax,0x1b0(%rsp)
 150e69d:	48 8b 81 88 01 00 00 	mov    0x188(%rcx),%rax
 150e6a4:	42 f6 44 a0 01 80    	testb  $0x80,0x1(%rax,%r12,4)
 150e6aa:	75 c0                	jne    150e66c <tier0_tables_open+0x2d1c>
 150e6ac:	48 8b 0c 24          	mov    (%rsp),%rcx
 150e6b0:	44 89 e2             	mov    %r12d,%edx
 150e6b3:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 150e6b9:	48 8b 09             	mov    (%rcx),%rcx
 150e6bc:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 150e6c0:	40 80 fe 0f          	cmp    $0xf,%sil
 150e6c4:	75 12                	jne    150e6d8 <tier0_tables_open+0x2d88>
 150e6c6:	48 8b 34 24          	mov    (%rsp),%rsi
 150e6ca:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 150e6ce:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 150e6d1:	c1 ea 03             	shr    $0x3,%edx
 150e6d4:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 150e6d8:	40 0f b6 fe          	movzbl %sil,%edi
 150e6dc:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 150e6e0:	41 83 f8 03          	cmp    $0x3,%r8d
 150e6e4:	72 86                	jb     150e66c <tier0_tables_open+0x2d1c>
 150e6e6:	85 ff                	test   %edi,%edi
 150e6e8:	74 82                	je     150e66c <tier0_tables_open+0x2d1c>
 150e6ea:	83 ff 01             	cmp    $0x1,%edi
 150e6ed:	74 1e                	je     150e70d <tier0_tables_open+0x2dbd>
 150e6ef:	40 84 f6             	test   %sil,%sil
 150e6f2:	0f 84 74 ff ff ff    	je     150e66c <tier0_tables_open+0x2d1c>
 150e6f8:	48 8b 34 24          	mov    (%rsp),%rsi
 150e6fc:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 150e700:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
 150e704:	80 e2 04             	and    $0x4,%dl
 150e707:	0f 84 5f ff ff ff    	je     150e66c <tier0_tables_open+0x2d1c>
 150e70d:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 150e712:	83 f9 0f             	cmp    $0xf,%ecx
 150e715:	77 53                	ja     150e76a <tier0_tables_open+0x2e1a>
 150e717:	ba 00 c1 00 00       	mov    $0xc100,%edx
 150e71c:	0f a3 ca             	bt     %ecx,%edx
 150e71f:	73 49                	jae    150e76a <tier0_tables_open+0x2e1a>
 150e721:	48 8b 14 24          	mov    (%rsp),%rdx
 150e725:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 150e729:	42 8b 14 a2          	mov    (%rdx,%r12,4),%edx
 150e72d:	89 d6                	mov    %edx,%esi
 150e72f:	c1 ee 03             	shr    $0x3,%esi
 150e732:	f6 44 b0 01 80       	testb  $0x80,0x1(%rax,%rsi,4)
 150e737:	0f 84 2f ff ff ff    	je     150e66c <tier0_tables_open+0x2d1c>
 150e73d:	80 f9 08             	cmp    $0x8,%cl
 150e740:	0f 85 0f ff ff ff    	jne    150e655 <tier0_tables_open+0x2d05>
 150e746:	48 8b 04 24          	mov    (%rsp),%rax
 150e74a:	48 8b 40 38          	mov    0x38(%rax),%rax
 150e74e:	4a 83 3c e0 00       	cmpq   $0x0,(%rax,%r12,8)
 150e753:	0f 85 fc fe ff ff    	jne    150e655 <tier0_tables_open+0x2d05>
 150e759:	48 8b 34 24          	mov    (%rsp),%rsi
 150e75d:	4c 89 f7             	mov    %r14,%rdi
 150e760:	e8 d2 fa 46 00       	call   197e237 <abi_wide_classified>
 150e765:	e9 bb 00 00 00       	jmp    150e825 <tier0_tables_open+0x2ed5>
 150e76a:	80 e1 fe             	and    $0xfe,%cl
 150e76d:	80 f9 10             	cmp    $0x10,%cl
 150e770:	0f 85 df fe ff ff    	jne    150e655 <tier0_tables_open+0x2d05>
 150e776:	48 8b 0c 24          	mov    (%rsp),%rcx
 150e77a:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 150e77e:	4a 8b 0c e1          	mov    (%rcx,%r12,8),%rcx
 150e782:	48 83 f9 40          	cmp    $0x40,%rcx
 150e786:	77 69                	ja     150e7f1 <tier0_tables_open+0x2ea1>
 150e788:	48 8b 14 24          	mov    (%rsp),%rdx
 150e78c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 150e790:	42 f6 04 22 40       	testb  $0x40,(%rdx,%r12,1)
 150e795:	75 5a                	jne    150e7f1 <tier0_tables_open+0x2ea1>
 150e797:	48 8b 3c 24          	mov    (%rsp),%rdi
 150e79b:	48 8b 4f 28          	mov    0x28(%rdi),%rcx
 150e79f:	48 8b 57 70          	mov    0x70(%rdi),%rdx
 150e7a3:	48 8b 7f 78          	mov    0x78(%rdi),%rdi
 150e7a7:	42 8b 34 a1          	mov    (%rcx,%r12,4),%esi
 150e7ab:	8b 0c b2             	mov    (%rdx,%rsi,4),%ecx
 150e7ae:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 150e7b1:	01 ce                	add    %ecx,%esi
 150e7b3:	39 f1                	cmp    %esi,%ecx
 150e7b5:	0f 83 9a fe ff ff    	jae    150e655 <tier0_tables_open+0x2d05>
 150e7bb:	48 8b 14 24          	mov    (%rsp),%rdx
 150e7bf:	48 ff c1             	inc    %rcx
 150e7c2:	89 f6                	mov    %esi,%esi
 150e7c4:	48 8b 92 b8 00 00 00 	mov    0xb8(%rdx),%rdx
 150e7cb:	8b 7c 8a fc          	mov    -0x4(%rdx,%rcx,4),%edi
 150e7cf:	c1 ef 03             	shr    $0x3,%edi
 150e7d2:	8b 3c b8             	mov    (%rax,%rdi,4),%edi
 150e7d5:	66 85 ff             	test   %di,%di
 150e7d8:	79 09                	jns    150e7e3 <tier0_tables_open+0x2e93>
 150e7da:	48 39 f1             	cmp    %rsi,%rcx
 150e7dd:	48 8d 49 01          	lea    0x1(%rcx),%rcx
 150e7e1:	72 e8                	jb     150e7cb <tier0_tables_open+0x2e7b>
 150e7e3:	66 85 ff             	test   %di,%di
 150e7e6:	0f 88 69 fe ff ff    	js     150e655 <tier0_tables_open+0x2d05>
 150e7ec:	e9 7b fe ff ff       	jmp    150e66c <tier0_tables_open+0x2d1c>
 150e7f1:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 150e7f6:	75 1e                	jne    150e816 <tier0_tables_open+0x2ec6>
 150e7f8:	48 85 c9             	test   %rcx,%rcx
 150e7fb:	0f 85 54 fe ff ff    	jne    150e655 <tier0_tables_open+0x2d05>
 150e801:	48 8b 04 24          	mov    (%rsp),%rax
 150e805:	48 8b 40 10          	mov    0x10(%rax),%rax
 150e809:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
 150e80e:	24 40                	and    $0x40,%al
 150e810:	0f 84 3f fe ff ff    	je     150e655 <tier0_tables_open+0x2d05>
 150e816:	48 8b 34 24          	mov    (%rsp),%rsi
 150e81a:	4c 89 f7             	mov    %r14,%rdi
 150e81d:	44 89 e2             	mov    %r12d,%edx
 150e820:	e8 4d fa 46 00       	call   197e272 <abi_members_classified>
 150e825:	84 c0                	test   %al,%al
 150e827:	0f 85 28 fe ff ff    	jne    150e655 <tier0_tables_open+0x2d05>
 150e82d:	e9 3a fe ff ff       	jmp    150e66c <tier0_tables_open+0x2d1c>
 150e832:	48 01 c2             	add    %rax,%rdx
 150e835:	48 8b 04 24          	mov    (%rsp),%rax
 150e839:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 150e842:	83 b8 c0 01 00 00 00 	cmpl   $0x0,0x1c0(%rax)
 150e849:	0f 95 c0             	setne  %al
 150e84c:	48 83 bc 24 60 01 00 00 00 	cmpq   $0x0,0x160(%rsp)
 150e855:	89 44 24 18          	mov    %eax,0x18(%rsp)
 150e859:	0f 84 f4 fa ff ff    	je     150e353 <tier0_tables_open+0x2a03>
 150e85f:	41 83 fd 02          	cmp    $0x2,%r13d
 150e863:	0f 82 48 2e 00 00    	jb     15116b1 <tier0_tables_open+0x5d61>
 150e869:	49 83 fd 02          	cmp    $0x2,%r13
 150e86d:	75 14                	jne    150e883 <tier0_tables_open+0x2f33>
 150e86f:	31 c0                	xor    %eax,%eax
 150e871:	b9 01 00 00 00       	mov    $0x1,%ecx
 150e876:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 150e87e:	e9 81 01 00 00       	jmp    150ea04 <tier0_tables_open+0x30b4>
 150e883:	49 ff cd             	dec    %r13
 150e886:	b9 01 00 00 00       	mov    $0x1,%ecx
 150e88b:	31 c0                	xor    %eax,%eax
 150e88d:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 150e895:	4c 89 ea             	mov    %r13,%rdx
 150e898:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
 150e89c:	48 f7 da             	neg    %rdx
 150e89f:	eb 37                	jmp    150e8d8 <tier0_tables_open+0x2f88>
 150e8a1:	44 8b 54 24 2c       	mov    0x2c(%rsp),%r10d
 150e8a6:	4c 8b 4c 24 48       	mov    0x48(%rsp),%r9
 150e8ab:	44 89 d7             	mov    %r10d,%edi
 150e8ae:	41 ff c2             	inc    %r10d
 150e8b1:	41 83 f8 0e          	cmp    $0xe,%r8d
 150e8b5:	41 89 34 b9          	mov    %esi,(%r9,%rdi,4)
 150e8b9:	40 0f 94 c6          	sete   %sil
 150e8bd:	44 89 54 24 2c       	mov    %r10d,0x2c(%rsp)
 150e8c2:	40 08 f0             	or     %sil,%al
 150e8c5:	48 8d 74 0a 02       	lea    0x2(%rdx,%rcx,1),%rsi
 150e8ca:	48 83 c1 02          	add    $0x2,%rcx
 150e8ce:	48 83 fe 01          	cmp    $0x1,%rsi
 150e8d2:	0f 84 22 01 00 00    	je     150e9fa <tier0_tables_open+0x30aa>
 150e8d8:	48 8b 34 24          	mov    (%rsp),%rsi
 150e8dc:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 150e8e3:	f6 44 8e 01 80       	testb  $0x80,0x1(%rsi,%rcx,4)
 150e8e8:	75 7e                	jne    150e968 <tier0_tables_open+0x3018>
 150e8ea:	48 8b 3c 24          	mov    (%rsp),%rdi
 150e8ee:	89 ce                	mov    %ecx,%esi
 150e8f0:	81 e6 ff ff ff 1f    	and    $0x1fffffff,%esi
 150e8f6:	4c 8b 07             	mov    (%rdi),%r8
 150e8f9:	41 0f b6 3c 30       	movzbl (%r8,%rsi,1),%edi
 150e8fe:	40 80 ff 0f          	cmp    $0xf,%dil
 150e902:	75 13                	jne    150e917 <tier0_tables_open+0x2fc7>
 150e904:	48 8b 3c 24          	mov    (%rsp),%rdi
 150e908:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
 150e90c:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 150e90f:	c1 ee 03             	shr    $0x3,%esi
 150e912:	41 0f b6 3c 30       	movzbl (%r8,%rsi,1),%edi
 150e917:	40 0f b6 ff          	movzbl %dil,%edi
 150e91b:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 150e91f:	41 83 f8 03          	cmp    $0x3,%r8d
 150e923:	72 43                	jb     150e968 <tier0_tables_open+0x3018>
 150e925:	85 ff                	test   %edi,%edi
 150e927:	74 3f                	je     150e968 <tier0_tables_open+0x3018>
 150e929:	83 ff 01             	cmp    $0x1,%edi
 150e92c:	74 17                	je     150e945 <tier0_tables_open+0x2ff5>
 150e92e:	85 ff                	test   %edi,%edi
 150e930:	74 36                	je     150e968 <tier0_tables_open+0x3018>
 150e932:	4c 8b 04 24          	mov    (%rsp),%r8
 150e936:	4d 8b 40 10          	mov    0x10(%r8),%r8
 150e93a:	41 0f b6 34 30       	movzbl (%r8,%rsi,1),%esi
 150e93f:	40 80 e6 04          	and    $0x4,%sil
 150e943:	74 23                	je     150e968 <tier0_tables_open+0x3018>
 150e945:	44 8b 4c 24 2c       	mov    0x2c(%rsp),%r9d
 150e94a:	4c 8b 44 24 48       	mov    0x48(%rsp),%r8
 150e94f:	44 89 ce             	mov    %r9d,%esi
 150e952:	41 ff c1             	inc    %r9d
 150e955:	83 ff 0e             	cmp    $0xe,%edi
 150e958:	41 89 0c b0          	mov    %ecx,(%r8,%rsi,4)
 150e95c:	40 0f 94 c6          	sete   %sil
 150e960:	44 89 4c 24 2c       	mov    %r9d,0x2c(%rsp)
 150e965:	40 08 f0             	or     %sil,%al
 150e968:	48 8b 34 24          	mov    (%rsp),%rsi
 150e96c:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 150e973:	f6 44 8e 05 80       	testb  $0x80,0x5(%rsi,%rcx,4)
 150e978:	0f 85 47 ff ff ff    	jne    150e8c5 <tier0_tables_open+0x2f75>
 150e97e:	4c 8b 04 24          	mov    (%rsp),%r8
 150e982:	48 8d 71 01          	lea    0x1(%rcx),%rsi
 150e986:	89 f7                	mov    %esi,%edi
 150e988:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 150e98e:	4d 8b 08             	mov    (%r8),%r9
 150e991:	45 0f b6 04 39       	movzbl (%r9,%rdi,1),%r8d
 150e996:	41 80 f8 0f          	cmp    $0xf,%r8b
 150e99a:	75 14                	jne    150e9b0 <tier0_tables_open+0x3060>
 150e99c:	4c 8b 04 24          	mov    (%rsp),%r8
 150e9a0:	4d 8b 40 20          	mov    0x20(%r8),%r8
 150e9a4:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 150e9a8:	c1 ef 03             	shr    $0x3,%edi
 150e9ab:	45 0f b6 04 39       	movzbl (%r9,%rdi,1),%r8d
 150e9b0:	45 0f b6 c0          	movzbl %r8b,%r8d
 150e9b4:	45 8d 48 f7          	lea    -0x9(%r8),%r9d
 150e9b8:	41 83 f9 03          	cmp    $0x3,%r9d
 150e9bc:	0f 82 03 ff ff ff    	jb     150e8c5 <tier0_tables_open+0x2f75>
 150e9c2:	45 85 c0             	test   %r8d,%r8d
 150e9c5:	0f 84 fa fe ff ff    	je     150e8c5 <tier0_tables_open+0x2f75>
 150e9cb:	41 83 f8 01          	cmp    $0x1,%r8d
 150e9cf:	0f 84 cc fe ff ff    	je     150e8a1 <tier0_tables_open+0x2f51>
 150e9d5:	45 85 c0             	test   %r8d,%r8d
 150e9d8:	0f 84 e7 fe ff ff    	je     150e8c5 <tier0_tables_open+0x2f75>
 150e9de:	4c 8b 0c 24          	mov    (%rsp),%r9
 150e9e2:	4d 8b 49 10          	mov    0x10(%r9),%r9
 150e9e6:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
 150e9eb:	40 80 e7 04          	and    $0x4,%dil
 150e9ef:	0f 85 ac fe ff ff    	jne    150e8a1 <tier0_tables_open+0x2f51>
 150e9f5:	e9 cb fe ff ff       	jmp    150e8c5 <tier0_tables_open+0x2f75>
 150e9fa:	41 f6 c5 01          	test   $0x1,%r13b
 150e9fe:	0f 84 87 00 00 00    	je     150ea8b <tier0_tables_open+0x313b>
 150ea04:	48 8b 14 24          	mov    (%rsp),%rdx
 150ea08:	48 8b 92 88 01 00 00 	mov    0x188(%rdx),%rdx
 150ea0f:	f6 44 8a 01 80       	testb  $0x80,0x1(%rdx,%rcx,4)
 150ea14:	75 75                	jne    150ea8b <tier0_tables_open+0x313b>
 150ea16:	48 8b 34 24          	mov    (%rsp),%rsi
 150ea1a:	89 ca                	mov    %ecx,%edx
 150ea1c:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 150ea22:	48 8b 3e             	mov    (%rsi),%rdi
 150ea25:	0f b6 34 17          	movzbl (%rdi,%rdx,1),%esi
 150ea29:	40 80 fe 0f          	cmp    $0xf,%sil
 150ea2d:	75 12                	jne    150ea41 <tier0_tables_open+0x30f1>
 150ea2f:	48 8b 34 24          	mov    (%rsp),%rsi
 150ea33:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 150ea37:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 150ea3a:	c1 ea 03             	shr    $0x3,%edx
 150ea3d:	0f b6 34 17          	movzbl (%rdi,%rdx,1),%esi
 150ea41:	40 0f b6 f6          	movzbl %sil,%esi
 150ea45:	8d 7e f7             	lea    -0x9(%rsi),%edi
 150ea48:	83 ff 03             	cmp    $0x3,%edi
 150ea4b:	72 3e                	jb     150ea8b <tier0_tables_open+0x313b>
 150ea4d:	85 f6                	test   %esi,%esi
 150ea4f:	74 3a                	je     150ea8b <tier0_tables_open+0x313b>
 150ea51:	83 fe 01             	cmp    $0x1,%esi
 150ea54:	74 15                	je     150ea6b <tier0_tables_open+0x311b>
 150ea56:	85 f6                	test   %esi,%esi
 150ea58:	74 31                	je     150ea8b <tier0_tables_open+0x313b>
 150ea5a:	48 8b 3c 24          	mov    (%rsp),%rdi
 150ea5e:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 150ea62:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
 150ea66:	80 e2 04             	and    $0x4,%dl
 150ea69:	74 20                	je     150ea8b <tier0_tables_open+0x313b>
 150ea6b:	44 8b 44 24 2c       	mov    0x2c(%rsp),%r8d
 150ea70:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 150ea75:	44 89 c2             	mov    %r8d,%edx
 150ea78:	41 ff c0             	inc    %r8d
 150ea7b:	83 fe 0e             	cmp    $0xe,%esi
 150ea7e:	89 0c 97             	mov    %ecx,(%rdi,%rdx,4)
 150ea81:	0f 94 c1             	sete   %cl
 150ea84:	44 89 44 24 2c       	mov    %r8d,0x2c(%rsp)
 150ea89:	08 c8                	or     %cl,%al
 150ea8b:	a8 01                	test   $0x1,%al
 150ea8d:	0f 84 dc 01 00 00    	je     150ec6f <tier0_tables_open+0x331f>
 150ea93:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 150ea98:	0f 84 d1 01 00 00    	je     150ec6f <tier0_tables_open+0x331f>
 150ea9e:	8b 4c 24 2c          	mov    0x2c(%rsp),%ecx
 150eaa2:	89 ca                	mov    %ecx,%edx
 150eaa4:	89 d0                	mov    %edx,%eax
 150eaa6:	83 e0 03             	and    $0x3,%eax
 150eaa9:	83 f9 04             	cmp    $0x4,%ecx
 150eaac:	73 07                	jae    150eab5 <tier0_tables_open+0x3165>
 150eaae:	31 c9                	xor    %ecx,%ecx
 150eab0:	e9 4c 01 00 00       	jmp    150ec01 <tier0_tables_open+0x32b1>
 150eab5:	83 e2 fc             	and    $0xfffffffc,%edx
 150eab8:	31 c9                	xor    %ecx,%ecx
 150eaba:	eb 15                	jmp    150ead1 <tier0_tables_open+0x3181>
 150eabc:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 150eac4:	48 83 c1 04          	add    $0x4,%rcx
 150eac8:	48 39 ca             	cmp    %rcx,%rdx
 150eacb:	0f 84 2b 01 00 00    	je     150ebfc <tier0_tables_open+0x32ac>
 150ead1:	8b 74 24 18          	mov    0x18(%rsp),%esi
 150ead5:	40 f6 c6 01          	test   $0x1,%sil
 150ead9:	40 b6 01             	mov    $0x1,%sil
 150eadc:	89 74 24 18          	mov    %esi,0x18(%rsp)
 150eae0:	75 e2                	jne    150eac4 <tier0_tables_open+0x3174>
 150eae2:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 150eae7:	48 8b 3c 24          	mov    (%rsp),%rdi
 150eaeb:	8b 34 8e             	mov    (%rsi,%rcx,4),%esi
 150eaee:	48 8b 3f             	mov    (%rdi),%rdi
 150eaf1:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 150eaf5:	75 2b                	jne    150eb22 <tier0_tables_open+0x31d2>
 150eaf7:	4c 8b 04 24          	mov    (%rsp),%r8
 150eafb:	4d 8b 40 20          	mov    0x20(%r8),%r8
 150eaff:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150eb03:	c1 ee 03             	shr    $0x3,%esi
 150eb06:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 150eb0a:	75 07                	jne    150eb13 <tier0_tables_open+0x31c3>
 150eb0c:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150eb10:	c1 ee 03             	shr    $0x3,%esi
 150eb13:	48 8b 3c 24          	mov    (%rsp),%rdi
 150eb17:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 150eb1b:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 150eb20:	74 a2                	je     150eac4 <tier0_tables_open+0x3174>
 150eb22:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 150eb27:	48 8b 3c 24          	mov    (%rsp),%rdi
 150eb2b:	8b 74 8e 04          	mov    0x4(%rsi,%rcx,4),%esi
 150eb2f:	48 8b 3f             	mov    (%rdi),%rdi
 150eb32:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 150eb36:	75 2f                	jne    150eb67 <tier0_tables_open+0x3217>
 150eb38:	4c 8b 04 24          	mov    (%rsp),%r8
 150eb3c:	4d 8b 40 20          	mov    0x20(%r8),%r8
 150eb40:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150eb44:	c1 ee 03             	shr    $0x3,%esi
 150eb47:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 150eb4b:	75 07                	jne    150eb54 <tier0_tables_open+0x3204>
 150eb4d:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150eb51:	c1 ee 03             	shr    $0x3,%esi
 150eb54:	48 8b 3c 24          	mov    (%rsp),%rdi
 150eb58:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 150eb5c:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 150eb61:	0f 84 5d ff ff ff    	je     150eac4 <tier0_tables_open+0x3174>
 150eb67:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 150eb6c:	48 8b 3c 24          	mov    (%rsp),%rdi
 150eb70:	8b 74 8e 08          	mov    0x8(%rsi,%rcx,4),%esi
 150eb74:	48 8b 3f             	mov    (%rdi),%rdi
 150eb77:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 150eb7b:	75 2f                	jne    150ebac <tier0_tables_open+0x325c>
 150eb7d:	4c 8b 04 24          	mov    (%rsp),%r8
 150eb81:	4d 8b 40 20          	mov    0x20(%r8),%r8
 150eb85:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150eb89:	c1 ee 03             	shr    $0x3,%esi
 150eb8c:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 150eb90:	75 07                	jne    150eb99 <tier0_tables_open+0x3249>
 150eb92:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150eb96:	c1 ee 03             	shr    $0x3,%esi
 150eb99:	48 8b 3c 24          	mov    (%rsp),%rdi
 150eb9d:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 150eba1:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 150eba6:	0f 84 18 ff ff ff    	je     150eac4 <tier0_tables_open+0x3174>
 150ebac:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 150ebb1:	48 8b 3c 24          	mov    (%rsp),%rdi
 150ebb5:	8b 74 8e 0c          	mov    0xc(%rsi,%rcx,4),%esi
 150ebb9:	48 8b 3f             	mov    (%rdi),%rdi
 150ebbc:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 150ebc0:	0f 85 f6 fe ff ff    	jne    150eabc <tier0_tables_open+0x316c>
 150ebc6:	4c 8b 04 24          	mov    (%rsp),%r8
 150ebca:	4d 8b 40 20          	mov    0x20(%r8),%r8
 150ebce:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150ebd2:	c1 ee 03             	shr    $0x3,%esi
 150ebd5:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 150ebd9:	75 07                	jne    150ebe2 <tier0_tables_open+0x3292>
 150ebdb:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150ebdf:	c1 ee 03             	shr    $0x3,%esi
 150ebe2:	48 8b 3c 24          	mov    (%rsp),%rdi
 150ebe6:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 150ebea:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 150ebef:	40 0f 94 c6          	sete   %sil
 150ebf3:	89 74 24 18          	mov    %esi,0x18(%rsp)
 150ebf7:	e9 c8 fe ff ff       	jmp    150eac4 <tier0_tables_open+0x3174>
 150ebfc:	48 85 c0             	test   %rax,%rax
 150ebff:	74 6e                	je     150ec6f <tier0_tables_open+0x331f>
 150ec01:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 150ec06:	48 8d 0c 8a          	lea    (%rdx,%rcx,4),%rcx
 150ec0a:	31 d2                	xor    %edx,%edx
 150ec0c:	eb 10                	jmp    150ec1e <tier0_tables_open+0x32ce>
 150ec0e:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 150ec16:	48 ff c2             	inc    %rdx
 150ec19:	48 39 d0             	cmp    %rdx,%rax
 150ec1c:	74 51                	je     150ec6f <tier0_tables_open+0x331f>
 150ec1e:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
 150ec23:	40 b6 01             	mov    $0x1,%sil
 150ec26:	89 74 24 18          	mov    %esi,0x18(%rsp)
 150ec2a:	75 ea                	jne    150ec16 <tier0_tables_open+0x32c6>
 150ec2c:	48 8b 3c 24          	mov    (%rsp),%rdi
 150ec30:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 150ec33:	48 8b 3f             	mov    (%rdi),%rdi
 150ec36:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 150ec3a:	75 d2                	jne    150ec0e <tier0_tables_open+0x32be>
 150ec3c:	4c 8b 04 24          	mov    (%rsp),%r8
 150ec40:	4d 8b 40 20          	mov    0x20(%r8),%r8
 150ec44:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150ec48:	c1 ee 03             	shr    $0x3,%esi
 150ec4b:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 150ec4f:	75 07                	jne    150ec58 <tier0_tables_open+0x3308>
 150ec51:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 150ec55:	c1 ee 03             	shr    $0x3,%esi
 150ec58:	48 8b 3c 24          	mov    (%rsp),%rdi
 150ec5c:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 150ec60:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 150ec65:	40 0f 94 c6          	sete   %sil
 150ec69:	89 74 24 18          	mov    %esi,0x18(%rsp)
 150ec6d:	eb a7                	jmp    150ec16 <tier0_tables_open+0x32c6>
 150ec6f:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 150ec74:	0f 84 37 2a 00 00    	je     15116b1 <tier0_tables_open+0x5d61>
 150ec7a:	44 8b 7c 24 2c       	mov    0x2c(%rsp),%r15d
 150ec7f:	45 31 e4             	xor    %r12d,%r12d
 150ec82:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 150ec8a:	c7 84 24 a0 00 00 00 00 00 00 00 	movl   $0x0,0xa0(%rsp)
 150ec95:	eb 35                	jmp    150eccc <tier0_tables_open+0x337c>
 150ec97:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 150ec9c:	8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%esi
 150eca3:	48 8b 94 24 60 01 00 00 	mov    0x160(%rsp),%rdx
 150ecab:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
 150ecaf:	89 f1                	mov    %esi,%ecx
 150ecb1:	ff c6                	inc    %esi
 150ecb3:	89 b4 24 a0 00 00 00 	mov    %esi,0xa0(%rsp)
 150ecba:	c1 e0 03             	shl    $0x3,%eax
 150ecbd:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
 150ecc0:	49 ff c4             	inc    %r12
 150ecc3:	4d 39 fc             	cmp    %r15,%r12
 150ecc6:	0f 84 64 01 00 00    	je     150ee30 <tier0_tables_open+0x34e0>
 150eccc:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 150ecd1:	48 8b 34 24          	mov    (%rsp),%rsi
 150ecd5:	42 8b 14 a0          	mov    (%rax,%r12,4),%edx
 150ecd9:	48 8b 06             	mov    (%rsi),%rax
 150ecdc:	0f b6 0c 10          	movzbl (%rax,%rdx,1),%ecx
 150ece0:	83 f9 0f             	cmp    $0xf,%ecx
 150ece3:	77 7f                	ja     150ed64 <tier0_tables_open+0x3414>
 150ece5:	b8 00 c1 00 00       	mov    $0xc100,%eax
 150ecea:	0f a3 c8             	bt     %ecx,%eax
 150eced:	73 75                	jae    150ed64 <tier0_tables_open+0x3414>
 150ecef:	48 8b 34 24          	mov    (%rsp),%rsi
 150ecf3:	48 8b 46 20          	mov    0x20(%rsi),%rax
 150ecf7:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 150ecfe:	8b 04 90             	mov    (%rax,%rdx,4),%eax
 150ed01:	89 c7                	mov    %eax,%edi
 150ed03:	c1 ef 03             	shr    $0x3,%edi
 150ed06:	f6 44 be 01 80       	testb  $0x80,0x1(%rsi,%rdi,4)
 150ed0b:	75 25                	jne    150ed32 <tier0_tables_open+0x33e2>
 150ed0d:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 150ed12:	8b 74 24 2c          	mov    0x2c(%rsp),%esi
 150ed16:	42 8b 04 a2          	mov    (%rdx,%r12,4),%eax
 150ed1a:	89 f1                	mov    %esi,%ecx
 150ed1c:	ff c6                	inc    %esi
 150ed1e:	89 74 24 2c          	mov    %esi,0x2c(%rsp)
 150ed22:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
 150ed25:	49 ff c4             	inc    %r12
 150ed28:	4d 39 fc             	cmp    %r15,%r12
 150ed2b:	75 9f                	jne    150eccc <tier0_tables_open+0x337c>
 150ed2d:	e9 fe 00 00 00       	jmp    150ee30 <tier0_tables_open+0x34e0>
 150ed32:	80 f9 08             	cmp    $0x8,%cl
 150ed35:	0f 85 5c ff ff ff    	jne    150ec97 <tier0_tables_open+0x3347>
 150ed3b:	48 8b 0c 24          	mov    (%rsp),%rcx
 150ed3f:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 150ed43:	48 83 3c d1 00       	cmpq   $0x0,(%rcx,%rdx,8)
 150ed48:	0f 85 49 ff ff ff    	jne    150ec97 <tier0_tables_open+0x3347>
 150ed4e:	48 8b 34 24          	mov    (%rsp),%rsi
 150ed52:	4c 89 f7             	mov    %r14,%rdi
 150ed55:	89 c2                	mov    %eax,%edx
 150ed57:	c5 f8 77             	vzeroupper
 150ed5a:	e8 d8 f4 46 00       	call   197e237 <abi_wide_classified>
 150ed5f:	e9 bf 00 00 00       	jmp    150ee23 <tier0_tables_open+0x34d3>
 150ed64:	80 e1 fe             	and    $0xfe,%cl
 150ed67:	80 f9 10             	cmp    $0x10,%cl
 150ed6a:	0f 85 27 ff ff ff    	jne    150ec97 <tier0_tables_open+0x3347>
 150ed70:	48 8b 04 24          	mov    (%rsp),%rax
 150ed74:	48 8b 40 38          	mov    0x38(%rax),%rax
 150ed78:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
 150ed7c:	48 83 f8 40          	cmp    $0x40,%rax
 150ed80:	77 6e                	ja     150edf0 <tier0_tables_open+0x34a0>
 150ed82:	48 8b 0c 24          	mov    (%rsp),%rcx
 150ed86:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 150ed8a:	f6 04 11 40          	testb  $0x40,(%rcx,%rdx,1)
 150ed8e:	75 60                	jne    150edf0 <tier0_tables_open+0x34a0>
 150ed90:	48 8b 34 24          	mov    (%rsp),%rsi
 150ed94:	48 8b 46 28          	mov    0x28(%rsi),%rax
 150ed98:	48 8b 4e 70          	mov    0x70(%rsi),%rcx
 150ed9c:	48 8b 7e 78          	mov    0x78(%rsi),%rdi
 150eda0:	8b 14 90             	mov    (%rax,%rdx,4),%edx
 150eda3:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 150eda6:	8b 34 97             	mov    (%rdi,%rdx,4),%esi
 150eda9:	01 c6                	add    %eax,%esi
 150edab:	39 f0                	cmp    %esi,%eax
 150edad:	0f 83 e4 fe ff ff    	jae    150ec97 <tier0_tables_open+0x3347>
 150edb3:	48 8b 14 24          	mov    (%rsp),%rdx
 150edb7:	48 ff c0             	inc    %rax
 150edba:	89 f6                	mov    %esi,%esi
 150edbc:	48 8b 8a b8 00 00 00 	mov    0xb8(%rdx),%rcx
 150edc3:	48 8b 92 88 01 00 00 	mov    0x188(%rdx),%rdx
 150edca:	8b 7c 81 fc          	mov    -0x4(%rcx,%rax,4),%edi
 150edce:	c1 ef 03             	shr    $0x3,%edi
 150edd1:	8b 3c ba             	mov    (%rdx,%rdi,4),%edi
 150edd4:	66 85 ff             	test   %di,%di
 150edd7:	79 09                	jns    150ede2 <tier0_tables_open+0x3492>
 150edd9:	48 39 f0             	cmp    %rsi,%rax
 150eddc:	48 8d 40 01          	lea    0x1(%rax),%rax
 150ede0:	72 e8                	jb     150edca <tier0_tables_open+0x347a>
 150ede2:	66 85 ff             	test   %di,%di
 150ede5:	0f 88 ac fe ff ff    	js     150ec97 <tier0_tables_open+0x3347>
 150edeb:	e9 1d ff ff ff       	jmp    150ed0d <tier0_tables_open+0x33bd>
 150edf0:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 150edf5:	75 1d                	jne    150ee14 <tier0_tables_open+0x34c4>
 150edf7:	48 85 c0             	test   %rax,%rax
 150edfa:	0f 85 97 fe ff ff    	jne    150ec97 <tier0_tables_open+0x3347>
 150ee00:	48 8b 04 24          	mov    (%rsp),%rax
 150ee04:	48 8b 40 10          	mov    0x10(%rax),%rax
 150ee08:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
 150ee0c:	24 40                	and    $0x40,%al
 150ee0e:	0f 84 83 fe ff ff    	je     150ec97 <tier0_tables_open+0x3347>
 150ee14:	48 8b 34 24          	mov    (%rsp),%rsi
 150ee18:	4c 89 f7             	mov    %r14,%rdi
 150ee1b:	c5 f8 77             	vzeroupper
 150ee1e:	e8 4f f4 46 00       	call   197e272 <abi_members_classified>
 150ee23:	84 c0                	test   %al,%al
 150ee25:	0f 85 6c fe ff ff    	jne    150ec97 <tier0_tables_open+0x3347>
 150ee2b:	e9 dd fe ff ff       	jmp    150ed0d <tier0_tables_open+0x33bd>
 150ee30:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 150ee39:	4d 85 e4             	test   %r12,%r12
 150ee3c:	74 16                	je     150ee54 <tier0_tables_open+0x3504>
 150ee3e:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 150ee47:	48 89 84 24 c0 00 00 00 	mov    %rax,0xc0(%rsp)
 150ee4f:	e9 c1 00 00 00       	jmp    150ef15 <tier0_tables_open+0x35c5>
 150ee54:	48 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rsi
 150ee5e:	ba 03 00 00 00       	mov    $0x3,%edx
 150ee63:	b9 22 40 00 00       	mov    $0x4022,%ecx
 150ee68:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150ee6e:	31 ff                	xor    %edi,%edi
 150ee70:	45 31 c9             	xor    %r9d,%r9d
 150ee73:	c5 f8 77             	vzeroupper
 150ee76:	e8 c5 56 25 ff       	call   764540 <mmap@plt>
 150ee7b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 150ee7f:	74 58                	je     150eed9 <tier0_tables_open+0x3589>
 150ee81:	4c 8d a0 ff ff 20 00 	lea    0x20ffff(%rax),%r12
 150ee88:	ba 0f 00 00 00       	mov    $0xf,%edx
 150ee8d:	48 89 c7             	mov    %rax,%rdi
 150ee90:	49 81 e4 00 00 e0 ff 	and    $0xffffffffffe00000,%r12
 150ee97:	4d 89 e5             	mov    %r12,%r13
 150ee9a:	49 29 c5             	sub    %rax,%r13
 150ee9d:	4c 89 ee             	mov    %r13,%rsi
 150eea0:	4d 8d bd 00 00 ff ff 	lea    -0x10000(%r13),%r15
 150eea7:	e8 44 56 25 ff       	call   7644f0 <madvise@plt>
 150eeac:	48 bd 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbp
 150eeb6:	ba 0e 00 00 00       	mov    $0xe,%edx
 150eebb:	4c 89 e7             	mov    %r12,%rdi
 150eebe:	48 89 ee             	mov    %rbp,%rsi
 150eec1:	4c 29 ee             	sub    %r13,%rsi
 150eec4:	e8 27 56 25 ff       	call   7644f0 <madvise@plt>
 150eec9:	49 81 c4 00 00 ff ff 	add    $0xffffffffffff0000,%r12
 150eed0:	48 8d 85 00 00 e0 ff 	lea    -0x200000(%rbp),%rax
 150eed7:	eb 08                	jmp    150eee1 <tier0_tables_open+0x3591>
 150eed9:	45 31 e4             	xor    %r12d,%r12d
 150eedc:	31 c0                	xor    %eax,%eax
 150eede:	45 31 ff             	xor    %r15d,%r15d
 150eee1:	64 4c 89 24 25 10 ff ff ff 	mov    %r12,%fs:0xffffffffffffff10
 150eeea:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 150eef7:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 150ef00:	64 4c 89 3c 25 28 ff ff ff 	mov    %r15,%fs:0xffffffffffffff28
 150ef09:	48 c7 84 24 c0 00 00 00 00 00 00 00 	movq   $0x0,0xc0(%rsp)
 150ef15:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 150ef1d:	4e 8d 7c 21 03       	lea    0x3(%rcx,%r12,1),%r15
 150ef22:	4a 8d 04 21          	lea    (%rcx,%r12,1),%rax
 150ef26:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 150ef2a:	49 39 c7             	cmp    %rax,%r15
 150ef2d:	73 0f                	jae    150ef3e <tier0_tables_open+0x35ee>
 150ef2f:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 150ef37:	31 c9                	xor    %ecx,%ecx
 150ef39:	e9 1d 27 00 00       	jmp    151165b <tier0_tables_open+0x5d0b>
 150ef3e:	64 48 8b 34 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rsi
 150ef47:	4c 89 fa             	mov    %r15,%rdx
 150ef4a:	4c 29 e2             	sub    %r12,%rdx
 150ef4d:	31 c9                	xor    %ecx,%ecx
 150ef4f:	48 29 d6             	sub    %rdx,%rsi
 150ef52:	0f 82 5f 04 00 00    	jb     150f3b7 <tier0_tables_open+0x3a67>
 150ef58:	8b ac 24 a0 00 00 00 	mov    0xa0(%rsp),%ebp
 150ef5f:	48 8d 04 ad 00 00 00 00 	lea    0x0(,%rbp,4),%rax
 150ef67:	48 8d 3c 40          	lea    (%rax,%rax,2),%rdi
 150ef6b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 150ef73:	48 39 f7             	cmp    %rsi,%rdi
 150ef76:	0f 87 df 26 00 00    	ja     151165b <tier0_tables_open+0x5d0b>
 150ef7c:	48 01 fa             	add    %rdi,%rdx
 150ef7f:	83 bc 24 a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsp)
 150ef87:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 150ef90:	0f 84 2e 04 00 00    	je     150f3c4 <tier0_tables_open+0x3a74>
 150ef96:	4d 85 ff             	test   %r15,%r15
 150ef99:	0f 84 25 04 00 00    	je     150f3c4 <tier0_tables_open+0x3a74>
 150ef9f:	31 db                	xor    %ebx,%ebx
 150efa1:	45 31 e4             	xor    %r12d,%r12d
 150efa4:	e9 ac 00 00 00       	jmp    150f055 <tier0_tables_open+0x3705>
 150efa9:	4c 8b 0c 24          	mov    (%rsp),%r9
 150efad:	42 8d 0c ad 00 00 00 00 	lea    0x0(,%r13,4),%ecx
 150efb5:	4c 89 ef             	mov    %r13,%rdi
 150efb8:	48 c1 e7 04          	shl    $0x4,%rdi
 150efbc:	49 8b 41 20          	mov    0x20(%r9),%rax
 150efc0:	49 8b 91 80 01 00 00 	mov    0x180(%r9),%rdx
 150efc7:	8b 04 08             	mov    (%rax,%rcx,1),%eax
 150efca:	89 c6                	mov    %eax,%esi
 150efcc:	c1 ee 03             	shr    $0x3,%esi
 150efcf:	83 e0 f8             	and    $0xfffffff8,%eax
 150efd2:	49 89 f0             	mov    %rsi,%r8
 150efd5:	49 c1 e0 04          	shl    $0x4,%r8
 150efd9:	c4 a1 7a 6f 04 02    	vmovdqu (%rdx,%r8,1),%xmm0
 150efdf:	c5 fa 7f 04 3a       	vmovdqu %xmm0,(%rdx,%rdi,1)
 150efe4:	89 f7                	mov    %esi,%edi
 150efe6:	c1 e7 02             	shl    $0x2,%edi
 150efe9:	49 8b 91 88 01 00 00 	mov    0x188(%r9),%rdx
 150eff0:	44 8b 04 3a          	mov    (%rdx,%rdi,1),%r8d
 150eff4:	44 89 04 0a          	mov    %r8d,(%rdx,%rcx,1)
 150eff8:	49 8b 91 90 01 00 00 	mov    0x190(%r9),%rdx
 150efff:	8b 3c 3a             	mov    (%rdx,%rdi,1),%edi
 150f002:	89 3c 0a             	mov    %edi,(%rdx,%rcx,1)
 150f005:	49 8b 89 98 01 00 00 	mov    0x198(%r9),%rcx
 150f00c:	0f b6 14 31          	movzbl (%rcx,%rsi,1),%edx
 150f010:	42 88 14 29          	mov    %dl,(%rcx,%r13,1)
 150f014:	49 8b 89 a0 01 00 00 	mov    0x1a0(%r9),%rcx
 150f01b:	0f b6 14 31          	movzbl (%rcx,%rsi,1),%edx
 150f01f:	42 8d 34 ed 00 00 00 00 	lea    0x0(,%r13,8),%esi
 150f027:	42 88 14 29          	mov    %dl,(%rcx,%r13,1)
 150f02b:	49 8b 89 a8 01 00 00 	mov    0x1a8(%r9),%rcx
 150f032:	48 8b 14 01          	mov    (%rcx,%rax,1),%rdx
 150f036:	48 89 14 31          	mov    %rdx,(%rcx,%rsi,1)
 150f03a:	49 8b 89 b0 01 00 00 	mov    0x1b0(%r9),%rcx
 150f041:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 150f045:	48 89 04 31          	mov    %rax,(%rcx,%rsi,1)
 150f049:	49 ff c4             	inc    %r12
 150f04c:	4c 39 e5             	cmp    %r12,%rbp
 150f04f:	0f 84 8a 03 00 00    	je     150f3df <tier0_tables_open+0x3a8f>
 150f055:	48 8b 84 24 60 01 00 00 	mov    0x160(%rsp),%rax
 150f05d:	48 8b 0c 24          	mov    (%rsp),%rcx
 150f061:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
 150f065:	48 8b 31             	mov    (%rcx),%rsi
 150f068:	41 89 c5             	mov    %eax,%r13d
 150f06b:	41 c1 ed 03          	shr    $0x3,%r13d
 150f06f:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 150f074:	80 f9 0f             	cmp    $0xf,%cl
 150f077:	0f 84 2c ff ff ff    	je     150efa9 <tier0_tables_open+0x3659>
 150f07d:	48 8b 14 24          	mov    (%rsp),%rdx
 150f081:	83 e0 f8             	and    $0xfffffff8,%eax
 150f084:	89 cf                	mov    %ecx,%edi
 150f086:	40 80 e7 fe          	and    $0xfe,%dil
 150f08a:	48 8b 52 38          	mov    0x38(%rdx),%rdx
 150f08e:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
 150f092:	40 80 ff 10          	cmp    $0x10,%dil
 150f096:	0f 85 b8 00 00 00    	jne    150f154 <tier0_tables_open+0x3804>
 150f09c:	48 8b 14 24          	mov    (%rsp),%rdx
 150f0a0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 150f0a4:	42 f6 04 2a 40       	testb  $0x40,(%rdx,%r13,1)
 150f0a9:	0f 85 fe 00 00 00    	jne    150f1ad <tier0_tables_open+0x385d>
 150f0af:	48 83 f8 40          	cmp    $0x40,%rax
 150f0b3:	0f 87 f4 00 00 00    	ja     150f1ad <tier0_tables_open+0x385d>
 150f0b9:	48 83 f8 11          	cmp    $0x11,%rax
 150f0bd:	72 13                	jb     150f0d2 <tier0_tables_open+0x3782>
 150f0bf:	48 8b 14 24          	mov    (%rsp),%rdx
 150f0c3:	8b 92 bc 01 00 00    	mov    0x1bc(%rdx),%edx
 150f0c9:	48 39 d0             	cmp    %rdx,%rax
 150f0cc:	0f 87 db 00 00 00    	ja     150f1ad <tier0_tables_open+0x385d>
 150f0d2:	48 8b 34 24          	mov    (%rsp),%rsi
 150f0d6:	80 f9 10             	cmp    $0x10,%cl
 150f0d9:	89 df                	mov    %ebx,%edi
 150f0db:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 150f0df:	0f 94 c1             	sete   %cl
 150f0e2:	48 8b 56 28          	mov    0x28(%rsi),%rdx
 150f0e6:	48 8b 76 78          	mov    0x78(%rsi),%rsi
 150f0ea:	42 8b 14 aa          	mov    (%rdx,%r13,4),%edx
 150f0ee:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 150f0f1:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
 150f0f7:	40 0f 92 c6          	setb   %sil
 150f0fb:	40 08 ce             	or     %cl,%sil
 150f0fe:	48 83 f8 11          	cmp    $0x11,%rax
 150f102:	0f 92 c1             	setb   %cl
 150f105:	41 0f 93 44 bf 0a    	setae  0xa(%r15,%rdi,4)
 150f10b:	45 89 2c bf          	mov    %r13d,(%r15,%rdi,4)
 150f10f:	41 89 54 bf 04       	mov    %edx,0x4(%r15,%rdi,4)
 150f114:	40 20 f1             	and    %sil,%cl
 150f117:	be 10 00 00 00       	mov    $0x10,%esi
 150f11c:	48 29 c6             	sub    %rax,%rsi
 150f11f:	b8 00 00 00 00       	mov    $0x0,%eax
 150f124:	48 0f 43 c6          	cmovae %rsi,%rax
 150f128:	ff c3                	inc    %ebx
 150f12a:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 150f130:	62 f3 7d 08 3e 05 d5 6a 06 ff 01 	vpcmpltub -0xf9952b(%rip),%xmm0,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 150f13b:	c5 fb 93 c0          	kmovd  %k0,%eax
 150f13f:	25 fe ff 00 00       	and    $0xfffe,%eax
 150f144:	66 41 89 44 bf 08    	mov    %ax,0x8(%r15,%rdi,4)
 150f14a:	41 88 4c bf 0b       	mov    %cl,0xb(%r15,%rdi,4)
 150f14f:	e9 f5 fe ff ff       	jmp    150f049 <tier0_tables_open+0x36f9>
 150f154:	80 f9 08             	cmp    $0x8,%cl
 150f157:	75 74                	jne    150f1cd <tier0_tables_open+0x387d>
 150f159:	48 8b 0c 24          	mov    (%rsp),%rcx
 150f15d:	48 8b 79 20          	mov    0x20(%rcx),%rdi
 150f161:	42 8b 0c af          	mov    (%rdi,%r13,4),%ecx
 150f165:	c1 e9 03             	shr    $0x3,%ecx
 150f168:	80 3c 0e 0f          	cmpb   $0xf,(%rsi,%rcx,1)
 150f16c:	48 89 ce             	mov    %rcx,%rsi
 150f16f:	75 06                	jne    150f177 <tier0_tables_open+0x3827>
 150f171:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 150f174:	c1 ee 03             	shr    $0x3,%esi
 150f177:	48 8b 3c 24          	mov    (%rsp),%rdi
 150f17b:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 150f181:	48 8b 7f 18          	mov    0x18(%rdi),%rdi
 150f185:	0f b6 3c 0f          	movzbl (%rdi,%rcx,1),%edi
 150f189:	40 80 ff 07          	cmp    $0x7,%dil
 150f18d:	c4 c2 41 f7 f8       	shlx   %edi,%r8d,%edi
 150f192:	41 b8 7f 00 00 00    	mov    $0x7f,%r8d
 150f198:	40 f6 d7             	not    %dil
 150f19b:	40 0f b6 ff          	movzbl %dil,%edi
 150f19f:	41 0f 43 f8          	cmovae %r8d,%edi
 150f1a3:	48 83 f8 41          	cmp    $0x41,%rax
 150f1a7:	0f 82 a9 00 00 00    	jb     150f256 <tier0_tables_open+0x3906>
 150f1ad:	48 8b 34 24          	mov    (%rsp),%rsi
 150f1b1:	c4 e2 79 59 05 3e 0f 07 ff 	vpbroadcastq -0xf8f0c2(%rip),%xmm0        # 5800f8 <x86_semantics_benchmark_code.registers+0x108>
 150f1ba:	4c 89 e9             	mov    %r13,%rcx
 150f1bd:	48 c1 e1 04          	shl    $0x4,%rcx
 150f1c1:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 150f1c8:	e9 34 01 00 00       	jmp    150f301 <tier0_tables_open+0x39b1>
 150f1cd:	48 8b 34 24          	mov    (%rsp),%rsi
 150f1d1:	4c 89 f7             	mov    %r14,%rdi
 150f1d4:	44 89 ea             	mov    %r13d,%edx
 150f1d7:	c5 f8 77             	vzeroupper
 150f1da:	e8 81 0e 01 00       	call   1520060 <abi_simple>
 150f1df:	89 c6                	mov    %eax,%esi
 150f1e1:	c1 ee 10             	shr    $0x10,%esi
 150f1e4:	48 89 c1             	mov    %rax,%rcx
 150f1e7:	48 c1 e9 08          	shr    $0x8,%rcx
 150f1eb:	41 b8 77 00 00 00    	mov    $0x77,%r8d
 150f1f1:	89 f7                	mov    %esi,%edi
 150f1f3:	40 c0 e7 04          	shl    $0x4,%dil
 150f1f7:	40 08 cf             	or     %cl,%dil
 150f1fa:	40 80 fe 07          	cmp    $0x7,%sil
 150f1fe:	40 0f b6 f7          	movzbl %dil,%esi
 150f202:	41 0f 44 f0          	cmove  %r8d,%esi
 150f206:	80 f9 07             	cmp    $0x7,%cl
 150f209:	41 0f 44 f0          	cmove  %r8d,%esi
 150f20d:	3c 01                	cmp    $0x1,%al
 150f20f:	0f 85 97 00 00 00    	jne    150f2ac <tier0_tables_open+0x395c>
 150f215:	c1 e8 18             	shr    $0x18,%eax
 150f218:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 150f21e:	c5 f9 fc 05 ea 69 06 ff 	vpaddb -0xf99616(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 150f226:	89 c8                	mov    %ecx,%eax
 150f228:	62 f3 7d 08 3e 0d ed 69 06 ff 06 	vpcmpnleub -0xf99613(%rip),%xmm0,%k1        # 575c20 <x86_effects_unknown+0x1c0>
 150f233:	0c 60                	or     $0x60,%al
 150f235:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 150f23b:	89 c8                	mov    %ecx,%eax
 150f23d:	c1 e0 04             	shl    $0x4,%eax
 150f240:	09 c1                	or     %eax,%ecx
 150f242:	0c 06                	or     $0x6,%al
 150f244:	62 f2 7d 08 7a c8    	vpbroadcastb %eax,%xmm1
 150f24a:	62 f2 7d 09 7a c1    	vpbroadcastb %ecx,%xmm0{%k1}
 150f250:	c5 f9 6c c1          	vpunpcklqdq %xmm1,%xmm0,%xmm0
 150f254:	eb 5c                	jmp    150f2b2 <tier0_tables_open+0x3962>
 150f256:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 150f25c:	c5 f9 db 05 ac 69 06 ff 	vpand  -0xf99654(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 150f264:	48 8b 34 f2          	mov    (%rdx,%rsi,8),%rsi
 150f268:	62 f2 7e 08 26 c8    	vptestnmb %xmm0,%xmm0,%k1
 150f26e:	48 83 f8 11          	cmp    $0x11,%rax
 150f272:	0f 82 a1 00 00 00    	jb     150f319 <tier0_tables_open+0x39c9>
 150f278:	48 39 f0             	cmp    %rsi,%rax
 150f27b:	75 13                	jne    150f290 <tier0_tables_open+0x3940>
 150f27d:	48 8b 0c 24          	mov    (%rsp),%rcx
 150f281:	8b 89 bc 01 00 00    	mov    0x1bc(%rcx),%ecx
 150f287:	48 39 c8             	cmp    %rcx,%rax
 150f28a:	0f 86 be 00 00 00    	jbe    150f34e <tier0_tables_open+0x39fe>
 150f290:	48 8b 34 24          	mov    (%rsp),%rsi
 150f294:	c5 f9 6f 05 a4 69 06 ff 	vmovdqa -0xf9965c(%rip),%xmm0        # 575c40 <x86_effects_unknown+0x1e0>
 150f29c:	4c 89 e9             	mov    %r13,%rcx
 150f29f:	48 c1 e1 04          	shl    $0x4,%rcx
 150f2a3:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 150f2aa:	eb 55                	jmp    150f301 <tier0_tables_open+0x39b1>
 150f2ac:	62 f2 7d 08 7a c6    	vpbroadcastb %esi,%xmm0
 150f2b2:	b8 10 00 00 00       	mov    $0x10,%eax
 150f2b7:	b9 00 00 00 00       	mov    $0x0,%ecx
 150f2bc:	48 8b 34 24          	mov    (%rsp),%rsi
 150f2c0:	48 29 d0             	sub    %rdx,%rax
 150f2c3:	48 0f 43 c8          	cmovae %rax,%rcx
 150f2c7:	66 b8 01 00          	mov    $0x1,%ax
 150f2cb:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 150f2d1:	62 f3 75 08 3e 05 34 69 06 ff 05 	vpcmpnltub -0xf996cc(%rip),%xmm1,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 150f2dc:	c4 e2 79 78 0d db 14 01 ff 	vpbroadcastb -0xfeeb25(%rip),%xmm1        # 5207c0 <branch_sizing_patterns+0xa30>
 150f2e5:	c5 fb 92 c8          	kmovd  %eax,%k1
 150f2e9:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 150f2f0:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 150f2f4:	62 f2 75 09 66 c0    	vpblendmb %xmm0,%xmm1,%xmm0{%k1}
 150f2fa:	4c 89 e9             	mov    %r13,%rcx
 150f2fd:	48 c1 e1 04          	shl    $0x4,%rcx
 150f301:	c5 f9 7f 04 08       	vmovdqa %xmm0,(%rax,%rcx,1)
 150f306:	4c 89 f7             	mov    %r14,%rdi
 150f309:	44 89 ea             	mov    %r13d,%edx
 150f30c:	c5 f8 77             	vzeroupper
 150f30f:	e8 7c 0f 01 00       	call   1520290 <abi_finish>
 150f314:	e9 30 fd ff ff       	jmp    150f049 <tier0_tables_open+0x36f9>
 150f319:	48 8b 14 24          	mov    (%rsp),%rdx
 150f31d:	48 8b 52 30          	mov    0x30(%rdx),%rdx
 150f321:	48 85 f6             	test   %rsi,%rsi
 150f324:	75 30                	jne    150f356 <tier0_tables_open+0x3a06>
 150f326:	4a 83 3c ea 00       	cmpq   $0x0,(%rdx,%r13,8)
 150f32b:	74 29                	je     150f356 <tier0_tables_open+0x3a06>
 150f32d:	48 8b 34 24          	mov    (%rsp),%rsi
 150f331:	c4 e2 79 78 05 86 14 01 ff 	vpbroadcastb -0xfeeb7a(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 150f33a:	48 c1 e1 04          	shl    $0x4,%rcx
 150f33e:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 150f345:	62 f2 7d 09 66 04 08 	vpblendmb (%rax,%rcx,1),%xmm0,%xmm0{%k1}
 150f34c:	eb ac                	jmp    150f2fa <tier0_tables_open+0x39aa>
 150f34e:	48 8b 0c 24          	mov    (%rsp),%rcx
 150f352:	48 8b 51 30          	mov    0x30(%rcx),%rdx
 150f356:	be 10 00 00 00       	mov    $0x10,%esi
 150f35b:	bf 00 00 00 00       	mov    $0x0,%edi
 150f360:	42 8b 14 ea          	mov    (%rdx,%r13,8),%edx
 150f364:	c5 fb 93 c9          	kmovd  %k1,%ecx
 150f368:	48 29 c6             	sub    %rax,%rsi
 150f36b:	48 0f 43 fe          	cmovae %rsi,%rdi
 150f36f:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 150f375:	62 f3 7d 08 3e 05 90 68 06 ff 05 	vpcmpnltub -0xf99770(%rip),%xmm0,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 150f380:	c5 fb 93 f0          	kmovd  %k0,%esi
 150f384:	83 ce 01             	or     $0x1,%esi
 150f387:	21 f1                	and    %esi,%ecx
 150f389:	48 83 f8 11          	cmp    $0x11,%rax
 150f38d:	89 d8                	mov    %ebx,%eax
 150f38f:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 150f393:	f7 d1                	not    %ecx
 150f395:	45 89 2c 87          	mov    %r13d,(%r15,%rax,4)
 150f399:	41 89 54 87 04       	mov    %edx,0x4(%r15,%rax,4)
 150f39e:	66 41 89 4c 87 08    	mov    %cx,0x8(%r15,%rax,4)
 150f3a4:	41 0f 93 44 87 0a    	setae  0xa(%r15,%rax,4)
 150f3aa:	41 0f 92 44 87 0b    	setb   0xb(%r15,%rax,4)
 150f3b0:	ff c3                	inc    %ebx
 150f3b2:	e9 92 fc ff ff       	jmp    150f049 <tier0_tables_open+0x36f9>
 150f3b7:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 150f3bf:	e9 97 22 00 00       	jmp    151165b <tier0_tables_open+0x5d0b>
 150f3c4:	c7 84 24 b4 00 00 00 00 00 00 00 	movl   $0x0,0xb4(%rsp)
 150f3cf:	4d 85 ff             	test   %r15,%r15
 150f3d2:	0f 84 b9 01 00 00    	je     150f591 <tier0_tables_open+0x3c41>
 150f3d8:	31 db                	xor    %ebx,%ebx
 150f3da:	48 89 d0             	mov    %rdx,%rax
 150f3dd:	eb 1f                	jmp    150f3fe <tier0_tables_open+0x3aae>
 150f3df:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 150f3e8:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 150f3f1:	8d 4b 03             	lea    0x3(%rbx),%ecx
 150f3f4:	c1 e9 02             	shr    $0x2,%ecx
 150f3f7:	89 8c 24 b4 00 00 00 	mov    %ecx,0xb4(%rsp)
 150f3fe:	4a 8d 54 20 03       	lea    0x3(%rax,%r12,1),%rdx
 150f403:	89 d9                	mov    %ebx,%ecx
 150f405:	48 89 8c 24 98 00 00 00 	mov    %rcx,0x98(%rsp)
 150f40d:	4a 8d 0c 20          	lea    (%rax,%r12,1),%rcx
 150f411:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
 150f415:	48 39 ca             	cmp    %rcx,%rdx
 150f418:	72 54                	jb     150f46e <tier0_tables_open+0x3b1e>
 150f41a:	64 4c 8b 04 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%r8
 150f423:	48 89 d6             	mov    %rdx,%rsi
 150f426:	4c 29 e6             	sub    %r12,%rsi
 150f429:	49 29 f0             	sub    %rsi,%r8
 150f42c:	72 40                	jb     150f46e <tier0_tables_open+0x3b1e>
 150f42e:	48 8b bc 24 98 00 00 00 	mov    0x98(%rsp),%rdi
 150f436:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 150f43c:	4c 89 4c 24 78       	mov    %r9,0x78(%rsp)
 150f441:	48 8d 3c bd 00 00 00 00 	lea    0x0(,%rdi,4),%rdi
 150f449:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 150f44d:	4c 39 c7             	cmp    %r8,%rdi
 150f450:	77 25                	ja     150f477 <tier0_tables_open+0x3b27>
 150f452:	48 01 fe             	add    %rdi,%rsi
 150f455:	48 89 d1             	mov    %rdx,%rcx
 150f458:	48 01 f9             	add    %rdi,%rcx
 150f45b:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
 150f460:	48 89 f0             	mov    %rsi,%rax
 150f463:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 150f46c:	eb 09                	jmp    150f477 <tier0_tables_open+0x3b27>
 150f46e:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 150f477:	8b 94 24 b4 00 00 00 	mov    0xb4(%rsp),%edx
 150f47e:	48 89 94 24 50 01 00 00 	mov    %rdx,0x150(%rsp)
 150f486:	48 8d 51 07          	lea    0x7(%rcx),%rdx
 150f48a:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 150f48e:	48 39 ca             	cmp    %rcx,%rdx
 150f491:	72 50                	jb     150f4e3 <tier0_tables_open+0x3b93>
 150f493:	64 48 8b 34 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rsi
 150f49c:	48 89 d1             	mov    %rdx,%rcx
 150f49f:	4c 29 e1             	sub    %r12,%rcx
 150f4a2:	48 29 ce             	sub    %rcx,%rsi
 150f4a5:	72 3c                	jb     150f4e3 <tier0_tables_open+0x3b93>
 150f4a7:	48 8b bc 24 50 01 00 00 	mov    0x150(%rsp),%rdi
 150f4af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 150f4b5:	4c 89 84 24 20 01 00 00 	mov    %r8,0x120(%rsp)
 150f4bd:	48 c1 e7 04          	shl    $0x4,%rdi
 150f4c1:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 150f4c5:	48 39 f7             	cmp    %rsi,%rdi
 150f4c8:	77 25                	ja     150f4ef <tier0_tables_open+0x3b9f>
 150f4ca:	48 01 f9             	add    %rdi,%rcx
 150f4cd:	48 89 94 24 20 01 00 00 	mov    %rdx,0x120(%rsp)
 150f4d5:	48 89 c8             	mov    %rcx,%rax
 150f4d8:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 150f4e1:	eb 0c                	jmp    150f4ef <tier0_tables_open+0x3b9f>
 150f4e3:	48 c7 84 24 20 01 00 00 00 00 00 00 	movq   $0x0,0x120(%rsp)
 150f4ef:	48 83 bc 24 98 00 00 00 00 	cmpq   $0x0,0x98(%rsp)
 150f4f8:	74 73                	je     150f56d <tier0_tables_open+0x3c1d>
 150f4fa:	31 c9                	xor    %ecx,%ecx
 150f4fc:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 150f502:	0f 84 53 21 00 00    	je     151165b <tier0_tables_open+0x5d0b>
 150f508:	48 83 bc 24 20 01 00 00 00 	cmpq   $0x0,0x120(%rsp)
 150f511:	0f 84 44 21 00 00    	je     151165b <tier0_tables_open+0x5d0b>
 150f517:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
 150f51f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 150f523:	62 f1 fe 48 7f 84 24 70 02 00 00 	vmovdqu64 %zmm0,0x270(%rsp)
 150f52e:	62 f1 fe 48 7f 84 24 30 02 00 00 	vmovdqu64 %zmm0,0x230(%rsp)
 150f539:	62 f1 fe 48 7f 84 24 f0 01 00 00 	vmovdqu64 %zmm0,0x1f0(%rsp)
 150f544:	62 f1 fe 48 7f 84 24 b0 01 00 00 	vmovdqu64 %zmm0,0x1b0(%rsp)
 150f54f:	c7 84 24 b0 02 00 00 00 00 00 00 	movl   $0x0,0x2b0(%rsp)
 150f55a:	89 c8                	mov    %ecx,%eax
 150f55c:	83 e0 07             	and    $0x7,%eax
 150f55f:	83 f9 08             	cmp    $0x8,%ecx
 150f562:	73 37                	jae    150f59b <tier0_tables_open+0x3c4b>
 150f564:	31 c9                	xor    %ecx,%ecx
 150f566:	31 ff                	xor    %edi,%edi
 150f568:	e9 4f 01 00 00       	jmp    150f6bc <tier0_tables_open+0x3d6c>
 150f56d:	48 39 84 24 c0 00 00 00 	cmp    %rax,0xc0(%rsp)
 150f575:	0f 87 87 21 00 00    	ja     1511702 <tier0_tables_open+0x5db2>
 150f57b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 150f583:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 150f58c:	e9 0b 21 00 00       	jmp    151169c <tier0_tables_open+0x5d4c>
 150f591:	48 89 d0             	mov    %rdx,%rax
 150f594:	31 c9                	xor    %ecx,%ecx
 150f596:	e9 c0 20 00 00       	jmp    151165b <tier0_tables_open+0x5d0b>
 150f59b:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 150f5a3:	83 e2 f8             	and    $0xfffffff8,%edx
 150f5a6:	49 8d 77 04          	lea    0x4(%r15),%rsi
 150f5aa:	31 c9                	xor    %ecx,%ecx
 150f5ac:	31 ff                	xor    %edi,%edi
 150f5ae:	eb 11                	jmp    150f5c1 <tier0_tables_open+0x3c71>
 150f5b0:	48 83 c1 08          	add    $0x8,%rcx
 150f5b4:	48 83 c6 60          	add    $0x60,%rsi
 150f5b8:	48 39 ca             	cmp    %rcx,%rdx
 150f5bb:	0f 84 f6 00 00 00    	je     150f6b7 <tier0_tables_open+0x3d67>
 150f5c1:	44 8b 06             	mov    (%rsi),%r8d
 150f5c4:	41 b9 3f 00 00 00    	mov    $0x3f,%r9d
 150f5ca:	41 83 f8 3f          	cmp    $0x3f,%r8d
 150f5ce:	45 0f 43 c1          	cmovae %r9d,%r8d
 150f5d2:	41 ff c0             	inc    %r8d
 150f5d5:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 150f5dd:	41 39 f8             	cmp    %edi,%r8d
 150f5e0:	77 03                	ja     150f5e5 <tier0_tables_open+0x3c95>
 150f5e2:	41 89 f8             	mov    %edi,%r8d
 150f5e5:	8b 7e 0c             	mov    0xc(%rsi),%edi
 150f5e8:	83 ff 3f             	cmp    $0x3f,%edi
 150f5eb:	41 0f 43 f9          	cmovae %r9d,%edi
 150f5ef:	ff c7                	inc    %edi
 150f5f1:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 150f5f8:	44 39 c7             	cmp    %r8d,%edi
 150f5fb:	77 03                	ja     150f600 <tier0_tables_open+0x3cb0>
 150f5fd:	44 89 c7             	mov    %r8d,%edi
 150f600:	44 8b 46 18          	mov    0x18(%rsi),%r8d
 150f604:	41 83 f8 3f          	cmp    $0x3f,%r8d
 150f608:	45 0f 43 c1          	cmovae %r9d,%r8d
 150f60c:	41 ff c0             	inc    %r8d
 150f60f:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 150f617:	41 39 f8             	cmp    %edi,%r8d
 150f61a:	77 03                	ja     150f61f <tier0_tables_open+0x3ccf>
 150f61c:	41 89 f8             	mov    %edi,%r8d
 150f61f:	8b 7e 24             	mov    0x24(%rsi),%edi
 150f622:	83 ff 3f             	cmp    $0x3f,%edi
 150f625:	41 0f 43 f9          	cmovae %r9d,%edi
 150f629:	ff c7                	inc    %edi
 150f62b:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 150f632:	44 39 c7             	cmp    %r8d,%edi
 150f635:	77 03                	ja     150f63a <tier0_tables_open+0x3cea>
 150f637:	44 89 c7             	mov    %r8d,%edi
 150f63a:	44 8b 46 30          	mov    0x30(%rsi),%r8d
 150f63e:	41 83 f8 3f          	cmp    $0x3f,%r8d
 150f642:	45 0f 43 c1          	cmovae %r9d,%r8d
 150f646:	41 ff c0             	inc    %r8d
 150f649:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 150f651:	41 39 f8             	cmp    %edi,%r8d
 150f654:	77 03                	ja     150f659 <tier0_tables_open+0x3d09>
 150f656:	41 89 f8             	mov    %edi,%r8d
 150f659:	8b 7e 3c             	mov    0x3c(%rsi),%edi
 150f65c:	83 ff 3f             	cmp    $0x3f,%edi
 150f65f:	41 0f 43 f9          	cmovae %r9d,%edi
 150f663:	ff c7                	inc    %edi
 150f665:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 150f66c:	44 39 c7             	cmp    %r8d,%edi
 150f66f:	77 03                	ja     150f674 <tier0_tables_open+0x3d24>
 150f671:	44 89 c7             	mov    %r8d,%edi
 150f674:	44 8b 46 48          	mov    0x48(%rsi),%r8d
 150f678:	41 83 f8 3f          	cmp    $0x3f,%r8d
 150f67c:	45 0f 43 c1          	cmovae %r9d,%r8d
 150f680:	41 ff c0             	inc    %r8d
 150f683:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 150f68b:	41 39 f8             	cmp    %edi,%r8d
 150f68e:	77 03                	ja     150f693 <tier0_tables_open+0x3d43>
 150f690:	41 89 f8             	mov    %edi,%r8d
 150f693:	8b 7e 54             	mov    0x54(%rsi),%edi
 150f696:	83 ff 3f             	cmp    $0x3f,%edi
 150f699:	41 0f 43 f9          	cmovae %r9d,%edi
 150f69d:	ff c7                	inc    %edi
 150f69f:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 150f6a6:	44 39 c7             	cmp    %r8d,%edi
 150f6a9:	0f 87 01 ff ff ff    	ja     150f5b0 <tier0_tables_open+0x3c60>
 150f6af:	44 89 c7             	mov    %r8d,%edi
 150f6b2:	e9 f9 fe ff ff       	jmp    150f5b0 <tier0_tables_open+0x3c60>
 150f6b7:	48 85 c0             	test   %rax,%rax
 150f6ba:	74 3b                	je     150f6f7 <tier0_tables_open+0x3da7>
 150f6bc:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 150f6c0:	c1 e0 02             	shl    $0x2,%eax
 150f6c3:	31 d2                	xor    %edx,%edx
 150f6c5:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 150f6c9:	49 8d 4c 8f 04       	lea    0x4(%r15,%rcx,4),%rcx
 150f6ce:	89 fe                	mov    %edi,%esi
 150f6d0:	8b 3c 11             	mov    (%rcx,%rdx,1),%edi
 150f6d3:	41 b8 3f 00 00 00    	mov    $0x3f,%r8d
 150f6d9:	83 ff 3f             	cmp    $0x3f,%edi
 150f6dc:	41 0f 43 f8          	cmovae %r8d,%edi
 150f6e0:	ff c7                	inc    %edi
 150f6e2:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 150f6e9:	39 f7                	cmp    %esi,%edi
 150f6eb:	0f 46 fe             	cmovbe %esi,%edi
 150f6ee:	48 83 c2 0c          	add    $0xc,%rdx
 150f6f2:	48 39 d0             	cmp    %rdx,%rax
 150f6f5:	75 d7                	jne    150f6ce <tier0_tables_open+0x3d7e>
 150f6f7:	89 fa                	mov    %edi,%edx
 150f6f9:	89 d0                	mov    %edx,%eax
 150f6fb:	83 e0 07             	and    $0x7,%eax
 150f6fe:	ff cf                	dec    %edi
 150f700:	83 ff 07             	cmp    $0x7,%edi
 150f703:	73 09                	jae    150f70e <tier0_tables_open+0x3dbe>
 150f705:	31 c9                	xor    %ecx,%ecx
 150f707:	31 f6                	xor    %esi,%esi
 150f709:	e9 88 00 00 00       	jmp    150f796 <tier0_tables_open+0x3e46>
 150f70e:	81 e2 f8 ff ff 7f    	and    $0x7ffffff8,%edx
 150f714:	31 c9                	xor    %ecx,%ecx
 150f716:	31 f6                	xor    %esi,%esi
 150f718:	03 8c b4 b4 01 00 00 	add    0x1b4(%rsp,%rsi,4),%ecx
 150f71f:	89 8c b4 b4 01 00 00 	mov    %ecx,0x1b4(%rsp,%rsi,4)
 150f726:	03 8c b4 b8 01 00 00 	add    0x1b8(%rsp,%rsi,4),%ecx
 150f72d:	89 8c b4 b8 01 00 00 	mov    %ecx,0x1b8(%rsp,%rsi,4)
 150f734:	03 8c b4 bc 01 00 00 	add    0x1bc(%rsp,%rsi,4),%ecx
 150f73b:	89 8c b4 bc 01 00 00 	mov    %ecx,0x1bc(%rsp,%rsi,4)
 150f742:	03 8c b4 c0 01 00 00 	add    0x1c0(%rsp,%rsi,4),%ecx
 150f749:	89 8c b4 c0 01 00 00 	mov    %ecx,0x1c0(%rsp,%rsi,4)
 150f750:	03 8c b4 c4 01 00 00 	add    0x1c4(%rsp,%rsi,4),%ecx
 150f757:	89 8c b4 c4 01 00 00 	mov    %ecx,0x1c4(%rsp,%rsi,4)
 150f75e:	03 8c b4 c8 01 00 00 	add    0x1c8(%rsp,%rsi,4),%ecx
 150f765:	89 8c b4 c8 01 00 00 	mov    %ecx,0x1c8(%rsp,%rsi,4)
 150f76c:	03 8c b4 cc 01 00 00 	add    0x1cc(%rsp,%rsi,4),%ecx
 150f773:	89 8c b4 cc 01 00 00 	mov    %ecx,0x1cc(%rsp,%rsi,4)
 150f77a:	03 8c b4 d0 01 00 00 	add    0x1d0(%rsp,%rsi,4),%ecx
 150f781:	89 8c b4 d0 01 00 00 	mov    %ecx,0x1d0(%rsp,%rsi,4)
 150f788:	48 83 c6 08          	add    $0x8,%rsi
 150f78c:	48 39 f2             	cmp    %rsi,%rdx
 150f78f:	75 87                	jne    150f718 <tier0_tables_open+0x3dc8>
 150f791:	48 85 c0             	test   %rax,%rax
 150f794:	74 1c                	je     150f7b2 <tier0_tables_open+0x3e62>
 150f796:	48 8d 94 24 b4 01 00 00 	lea    0x1b4(%rsp),%rdx
 150f79e:	48 8d 14 b2          	lea    (%rdx,%rsi,4),%rdx
 150f7a2:	31 f6                	xor    %esi,%esi
 150f7a4:	03 0c b2             	add    (%rdx,%rsi,4),%ecx
 150f7a7:	89 0c b2             	mov    %ecx,(%rdx,%rsi,4)
 150f7aa:	48 ff c6             	inc    %rsi
 150f7ad:	48 39 f0             	cmp    %rsi,%rax
 150f7b0:	75 f2                	jne    150f7a4 <tier0_tables_open+0x3e54>
 150f7b2:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
 150f7ba:	89 c8                	mov    %ecx,%eax
 150f7bc:	83 e0 03             	and    $0x3,%eax
 150f7bf:	83 f9 04             	cmp    $0x4,%ecx
 150f7c2:	73 07                	jae    150f7cb <tier0_tables_open+0x3e7b>
 150f7c4:	31 c9                	xor    %ecx,%ecx
 150f7c6:	e9 f9 00 00 00       	jmp    150f8c4 <tier0_tables_open+0x3f74>
 150f7cb:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 150f7d3:	83 e2 fc             	and    $0xfffffffc,%edx
 150f7d6:	49 8d 77 28          	lea    0x28(%r15),%rsi
 150f7da:	31 c9                	xor    %ecx,%ecx
 150f7dc:	8b 7e dc             	mov    -0x24(%rsi),%edi
 150f7df:	41 bb 3f 00 00 00    	mov    $0x3f,%r11d
 150f7e5:	44 8b 56 e0          	mov    -0x20(%rsi),%r10d
 150f7e9:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 150f7ee:	83 ff 3f             	cmp    $0x3f,%edi
 150f7f1:	41 0f 43 fb          	cmovae %r11d,%edi
 150f7f5:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 150f7fd:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 150f801:	41 ff c0             	inc    %r8d
 150f804:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 150f809:	4c 8b 56 d8          	mov    -0x28(%rsi),%r10
 150f80d:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 150f811:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 150f819:	8b 7e e8             	mov    -0x18(%rsi),%edi
 150f81c:	44 8b 56 ec          	mov    -0x14(%rsi),%r10d
 150f820:	83 ff 3f             	cmp    $0x3f,%edi
 150f823:	41 0f 43 fb          	cmovae %r11d,%edi
 150f827:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 150f82f:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 150f833:	41 ff c0             	inc    %r8d
 150f836:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 150f83b:	4c 8b 56 e4          	mov    -0x1c(%rsi),%r10
 150f83f:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 150f843:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 150f84b:	8b 7e f4             	mov    -0xc(%rsi),%edi
 150f84e:	44 8b 56 f8          	mov    -0x8(%rsi),%r10d
 150f852:	83 ff 3f             	cmp    $0x3f,%edi
 150f855:	41 0f 43 fb          	cmovae %r11d,%edi
 150f859:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 150f861:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 150f865:	41 ff c0             	inc    %r8d
 150f868:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 150f86d:	4c 8b 56 f0          	mov    -0x10(%rsi),%r10
 150f871:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 150f875:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 150f87d:	8b 3e                	mov    (%rsi),%edi
 150f87f:	44 8b 56 04          	mov    0x4(%rsi),%r10d
 150f883:	83 ff 3f             	cmp    $0x3f,%edi
 150f886:	41 0f 43 fb          	cmovae %r11d,%edi
 150f88a:	48 83 c1 04          	add    $0x4,%rcx
 150f88e:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 150f896:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 150f89a:	41 ff c0             	inc    %r8d
 150f89d:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 150f8a2:	4c 8b 56 fc          	mov    -0x4(%rsi),%r10
 150f8a6:	48 83 c6 30          	add    $0x30,%rsi
 150f8aa:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 150f8ae:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 150f8b6:	48 39 ca             	cmp    %rcx,%rdx
 150f8b9:	0f 85 1d ff ff ff    	jne    150f7dc <tier0_tables_open+0x3e8c>
 150f8bf:	48 85 c0             	test   %rax,%rax
 150f8c2:	74 55                	je     150f919 <tier0_tables_open+0x3fc9>
 150f8c4:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 150f8c8:	c1 e0 02             	shl    $0x2,%eax
 150f8cb:	31 d2                	xor    %edx,%edx
 150f8cd:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 150f8d1:	49 8d 4c 8f 04       	lea    0x4(%r15,%rcx,4),%rcx
 150f8d6:	8b 34 11             	mov    (%rcx,%rdx,1),%esi
 150f8d9:	bf 3f 00 00 00       	mov    $0x3f,%edi
 150f8de:	44 8b 4c 11 04       	mov    0x4(%rcx,%rdx,1),%r9d
 150f8e3:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 150f8e8:	83 fe 3f             	cmp    $0x3f,%esi
 150f8eb:	0f 43 f7             	cmovae %edi,%esi
 150f8ee:	8b bc b4 b0 01 00 00 	mov    0x1b0(%rsp,%rsi,4),%edi
 150f8f5:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
 150f8f9:	ff c7                	inc    %edi
 150f8fb:	47 89 4c 82 08       	mov    %r9d,0x8(%r10,%r8,4)
 150f900:	4c 8b 4c 11 fc       	mov    -0x4(%rcx,%rdx,1),%r9
 150f905:	48 83 c2 0c          	add    $0xc,%rdx
 150f909:	4f 89 0c 82          	mov    %r9,(%r10,%r8,4)
 150f90d:	89 bc b4 b0 01 00 00 	mov    %edi,0x1b0(%rsp,%rsi,4)
 150f914:	48 39 d0             	cmp    %rdx,%rax
 150f917:	75 bd                	jne    150f8d6 <tier0_tables_open+0x3f86>
 150f919:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 150f921:	0f 84 a8 01 00 00    	je     150facf <tier0_tables_open+0x417f>
 150f927:	48 8b 84 24 50 01 00 00 	mov    0x150(%rsp),%rax
 150f92f:	b9 0a 00 00 00       	mov    $0xa,%ecx
 150f934:	31 d2                	xor    %edx,%edx
 150f936:	31 ff                	xor    %edi,%edi
 150f938:	8d 1c 85 00 00 00 00 	lea    0x0(,%rax,4),%ebx
 150f93f:	eb 66                	jmp    150f9a7 <tier0_tables_open+0x4057>
 150f941:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 150f947:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 150f94c:	41 bb ff ff ff ff    	mov    $0xffffffff,%r11d
 150f952:	45 31 c0             	xor    %r8d,%r8d
 150f955:	45 31 c9             	xor    %r9d,%r9d
 150f958:	45 31 d2             	xor    %r10d,%r10d
 150f95b:	48 8b 84 24 20 01 00 00 	mov    0x120(%rsp),%rax
 150f963:	48 83 c2 04          	add    $0x4,%rdx
 150f967:	44 89 5c 88 d8       	mov    %r11d,-0x28(%rax,%rcx,4)
 150f96c:	89 6c 88 dc          	mov    %ebp,-0x24(%rax,%rcx,4)
 150f970:	44 89 7c 88 e0       	mov    %r15d,-0x20(%rax,%rcx,4)
 150f975:	89 7c 88 e4          	mov    %edi,-0x1c(%rax,%rcx,4)
 150f979:	44 89 cf             	mov    %r9d,%edi
 150f97c:	48 89 74 88 e8       	mov    %rsi,-0x18(%rax,%rcx,4)
 150f981:	44 89 4c 88 f0       	mov    %r9d,-0x10(%rax,%rcx,4)
 150f986:	c7 44 88 f4 00 00 00 00 	movl   $0x0,-0xc(%rax,%rcx,4)
 150f98e:	4c 89 44 88 f8       	mov    %r8,-0x8(%rax,%rcx,4)
 150f993:	4c 89 14 88          	mov    %r10,(%rax,%rcx,4)
 150f997:	48 01 f7             	add    %rsi,%rdi
 150f99a:	48 83 c1 0c          	add    $0xc,%rcx
 150f99e:	48 39 d3             	cmp    %rdx,%rbx
 150f9a1:	0f 84 1e 01 00 00    	je     150fac5 <tier0_tables_open+0x4175>
 150f9a7:	48 89 fe             	mov    %rdi,%rsi
 150f9aa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 150f9af:	48 3b 94 24 98 00 00 00 	cmp    0x98(%rsp),%rdx
 150f9b7:	73 88                	jae    150f941 <tier0_tables_open+0x3ff1>
 150f9b9:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 150f9be:	4c 8d 7a 01          	lea    0x1(%rdx),%r15
 150f9c2:	44 0f b6 54 88 e2    	movzbl -0x1e(%rax,%rcx,4),%r10d
 150f9c8:	44 8b 5c 88 d8       	mov    -0x28(%rax,%rcx,4),%r11d
 150f9cd:	44 8b 4c 88 dc       	mov    -0x24(%rax,%rcx,4),%r9d
 150f9d2:	44 0f b7 44 88 e0    	movzwl -0x20(%rax,%rcx,4),%r8d
 150f9d8:	41 83 e2 01          	and    $0x1,%r10d
 150f9dc:	4c 3b bc 24 98 00 00 00 	cmp    0x98(%rsp),%r15
 150f9e4:	0f 83 c0 00 00 00    	jae    150faaa <tier0_tables_open+0x415a>
 150f9ea:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 150f9ef:	44 8b 7c 88 e8       	mov    -0x18(%rax,%rcx,4),%r15d
 150f9f4:	44 0f b6 64 88 ee    	movzbl -0x12(%rax,%rcx,4),%r12d
 150f9fa:	8b 6c 88 e4          	mov    -0x1c(%rax,%rcx,4),%ebp
 150f9fe:	45 39 cf             	cmp    %r9d,%r15d
 150fa01:	45 0f 47 cf          	cmova  %r15d,%r9d
 150fa05:	44 8b 7c 88 ec       	mov    -0x14(%rax,%rcx,4),%r15d
 150fa0a:	41 83 e4 01          	and    $0x1,%r12d
 150fa0e:	48 8d 42 02          	lea    0x2(%rdx),%rax
 150fa12:	41 c1 e4 10          	shl    $0x10,%r12d
 150fa16:	4d 09 e2             	or     %r12,%r10
 150fa19:	41 c1 e7 10          	shl    $0x10,%r15d
 150fa1d:	4d 09 f8             	or     %r15,%r8
 150fa20:	48 3b 84 24 98 00 00 00 	cmp    0x98(%rsp),%rax
 150fa28:	0f 83 8c 00 00 00    	jae    150faba <tier0_tables_open+0x416a>
 150fa2e:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 150fa33:	44 8b 64 88 f4       	mov    -0xc(%rax,%rcx,4),%r12d
 150fa38:	44 8b 7c 88 f0       	mov    -0x10(%rax,%rcx,4),%r15d
 150fa3d:	44 0f b7 6c 88 f8    	movzwl -0x8(%rax,%rcx,4),%r13d
 150fa43:	0f b6 44 88 fa       	movzbl -0x6(%rax,%rcx,4),%eax
 150fa48:	45 39 cc             	cmp    %r9d,%r12d
 150fa4b:	45 0f 47 cc          	cmova  %r12d,%r9d
 150fa4f:	83 e0 01             	and    $0x1,%eax
 150fa52:	49 c1 e5 20          	shl    $0x20,%r13
 150fa56:	4c 8d 62 03          	lea    0x3(%rdx),%r12
 150fa5a:	48 c1 e0 20          	shl    $0x20,%rax
 150fa5e:	4d 09 e8             	or     %r13,%r8
 150fa61:	49 09 c2             	or     %rax,%r10
 150fa64:	4c 3b a4 24 98 00 00 00 	cmp    0x98(%rsp),%r12
 150fa6c:	0f 83 e9 fe ff ff    	jae    150f95b <tier0_tables_open+0x400b>
 150fa72:	4c 8b 6c 24 78       	mov    0x78(%rsp),%r13
 150fa77:	41 8b 44 8d 00       	mov    0x0(%r13,%rcx,4),%eax
 150fa7c:	45 0f b6 64 8d 06    	movzbl 0x6(%r13,%rcx,4),%r12d
 150fa82:	41 8b 7c 8d fc       	mov    -0x4(%r13,%rcx,4),%edi
 150fa87:	44 39 c8             	cmp    %r9d,%eax
 150fa8a:	44 0f 47 c8          	cmova  %eax,%r9d
 150fa8e:	41 8b 44 8d 04       	mov    0x4(%r13,%rcx,4),%eax
 150fa93:	41 83 e4 01          	and    $0x1,%r12d
 150fa97:	49 c1 e4 30          	shl    $0x30,%r12
 150fa9b:	4d 09 e2             	or     %r12,%r10
 150fa9e:	48 c1 e0 30          	shl    $0x30,%rax
 150faa2:	49 09 c0             	or     %rax,%r8
 150faa5:	e9 b1 fe ff ff       	jmp    150f95b <tier0_tables_open+0x400b>
 150faaa:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 150fab0:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 150fab5:	e9 a1 fe ff ff       	jmp    150f95b <tier0_tables_open+0x400b>
 150faba:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 150fac0:	e9 96 fe ff ff       	jmp    150f95b <tier0_tables_open+0x400b>
 150fac5:	48 c1 e7 06          	shl    $0x6,%rdi
 150fac9:	48 83 c7 40          	add    $0x40,%rdi
 150facd:	eb 05                	jmp    150fad4 <tier0_tables_open+0x4184>
 150facf:	bf 40 00 00 00       	mov    $0x40,%edi
 150fad4:	64 48 8b 0c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%rcx
 150fadd:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 150fae6:	48 8d 54 08 3f       	lea    0x3f(%rax,%rcx,1),%rdx
 150faeb:	48 01 c8             	add    %rcx,%rax
 150faee:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 150faf2:	48 89 94 24 e8 00 00 00 	mov    %rdx,0xe8(%rsp)
 150fafa:	48 39 c2             	cmp    %rax,%rdx
 150fafd:	73 07                	jae    150fb06 <tier0_tables_open+0x41b6>
 150faff:	31 c9                	xor    %ecx,%ecx
 150fb01:	e9 4c 1b 00 00       	jmp    1511652 <tier0_tables_open+0x5d02>
 150fb06:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 150fb0e:	64 48 8b 14 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rdx
 150fb17:	48 29 c8             	sub    %rcx,%rax
 150fb1a:	31 c9                	xor    %ecx,%ecx
 150fb1c:	48 29 c2             	sub    %rax,%rdx
 150fb1f:	0f 82 2d 1b 00 00    	jb     1511652 <tier0_tables_open+0x5d02>
 150fb25:	48 39 d7             	cmp    %rdx,%rdi
 150fb28:	0f 87 24 1b 00 00    	ja     1511652 <tier0_tables_open+0x5d02>
 150fb2e:	48 01 f8             	add    %rdi,%rax
 150fb31:	48 83 bc 24 e8 00 00 00 00 	cmpq   $0x0,0xe8(%rsp)
 150fb3a:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 150fb43:	0f 84 45 16 00 00    	je     151118e <tier0_tables_open+0x583e>
 150fb49:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 150fb51:	0f 84 37 16 00 00    	je     151118e <tier0_tables_open+0x583e>
 150fb57:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 150fb5f:	48 c7 84 24 68 01 00 00 00 00 00 00 	movq   $0x0,0x168(%rsp)
 150fb6b:	48 05 00 01 00 00    	add    $0x100,%rax
 150fb71:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 150fb79:	eb 21                	jmp    150fb9c <tier0_tables_open+0x424c>
 150fb7b:	48 8b 8c 24 68 01 00 00 	mov    0x168(%rsp),%rcx
 150fb83:	48 ff c1             	inc    %rcx
 150fb86:	48 89 8c 24 68 01 00 00 	mov    %rcx,0x168(%rsp)
 150fb8e:	48 3b 8c 24 50 01 00 00 	cmp    0x150(%rsp),%rcx
 150fb96:	0f 84 f2 15 00 00    	je     151118e <tier0_tables_open+0x583e>
 150fb9c:	48 8b 84 24 68 01 00 00 	mov    0x168(%rsp),%rax
 150fba4:	48 8b b4 24 20 01 00 00 	mov    0x120(%rsp),%rsi
 150fbac:	48 8b 94 24 a0 01 00 00 	mov    0x1a0(%rsp),%rdx
 150fbb4:	48 c7 84 24 c8 00 00 00 00 00 00 00 	movq   $0x0,0xc8(%rsp)
 150fbc0:	48 c1 e0 04          	shl    $0x4,%rax
 150fbc4:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 150fbcc:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
 150fbd0:	48 8d 04 0e          	lea    (%rsi,%rcx,1),%rax
 150fbd4:	48 03 4c 24 78       	add    0x78(%rsp),%rcx
 150fbd9:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 150fbe1:	48 89 8c 24 a8 01 00 00 	mov    %rcx,0x1a8(%rsp)
 150fbe9:	48 8b 8c 24 e8 00 00 00 	mov    0xe8(%rsp),%rcx
 150fbf1:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 150fbf9:	eb 7d                	jmp    150fc78 <tier0_tables_open+0x4328>
 150fbfb:	48 8b 34 24          	mov    (%rsp),%rsi
 150fbff:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 150fc07:	4c 89 f7             	mov    %r14,%rdi
 150fc0a:	c5 f8 77             	vzeroupper
 150fc0d:	e8 ae 0d 01 00       	call   15209c0 <abi_storage>
 150fc12:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 150fc17:	b1 30                	mov    $0x30,%cl
 150fc19:	c4 e2 f0 f5 d2       	bzhi   %rcx,%rdx,%rdx
 150fc1e:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 150fc23:	48 8b 34 24          	mov    (%rsp),%rsi
 150fc27:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 150fc2f:	48 8b 8e a0 01 00 00 	mov    0x1a0(%rsi),%rcx
 150fc36:	88 04 11             	mov    %al,(%rcx,%rdx,1)
 150fc39:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 150fc3e:	48 8b 86 a8 01 00 00 	mov    0x1a8(%rsi),%rax
 150fc45:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
 150fc49:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 150fc51:	48 83 84 24 80 01 00 00 10 	addq   $0x10,0x180(%rsp)
 150fc5a:	48 83 84 24 78 01 00 00 10 	addq   $0x10,0x178(%rsp)
 150fc63:	48 ff c1             	inc    %rcx
 150fc66:	48 89 8c 24 c8 00 00 00 	mov    %rcx,0xc8(%rsp)
 150fc6e:	48 83 f9 04          	cmp    $0x4,%rcx
 150fc72:	0f 84 03 ff ff ff    	je     150fb7b <tier0_tables_open+0x422b>
 150fc78:	48 8b 84 24 48 01 00 00 	mov    0x148(%rsp),%rax
 150fc80:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 150fc88:	48 8b 50 10          	mov    0x10(%rax),%rdx
 150fc8c:	48 89 ce             	mov    %rcx,%rsi
 150fc8f:	48 c1 e6 04          	shl    $0x4,%rsi
 150fc93:	48 03 b4 24 e8 00 00 00 	add    0xe8(%rsp),%rsi
 150fc9b:	48 c1 e2 06          	shl    $0x6,%rdx
 150fc9f:	48 01 d6             	add    %rdx,%rsi
 150fca2:	48 89 94 24 88 01 00 00 	mov    %rdx,0x188(%rsp)
 150fcaa:	8b 14 88             	mov    (%rax,%rcx,4),%edx
 150fcad:	8b 40 18             	mov    0x18(%rax),%eax
 150fcb0:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
 150fcb5:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
 150fcba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 150fcbf:	48 89 94 24 f0 00 00 00 	mov    %rdx,0xf0(%rsp)
 150fcc7:	48 39 c2             	cmp    %rax,%rdx
 150fcca:	0f 84 ec 00 00 00    	je     150fdbc <tier0_tables_open+0x446c>
 150fcd0:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 150fcd8:	48 8b 8c 24 a8 01 00 00 	mov    0x1a8(%rsp),%rcx
 150fce0:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 150fce4:	0f b6 44 81 0b       	movzbl 0xb(%rcx,%rax,4),%eax
 150fce9:	48 8b 0c 24          	mov    (%rsp),%rcx
 150fced:	88 84 24 00 01 00 00 	mov    %al,0x100(%rsp)
 150fcf4:	48 8b 01             	mov    (%rcx),%rax
 150fcf7:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 150fcff:	0f b6 0c 08          	movzbl (%rax,%rcx,1),%ecx
 150fd03:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
 150fd0a:	80 f9 08             	cmp    $0x8,%cl
 150fd0d:	0f 85 ed 00 00 00    	jne    150fe00 <tier0_tables_open+0x44b0>
 150fd13:	48 8b 0c 24          	mov    (%rsp),%rcx
 150fd17:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 150fd1f:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 150fd23:	8b 14 91             	mov    (%rcx,%rdx,4),%edx
 150fd26:	c1 ea 03             	shr    $0x3,%edx
 150fd29:	80 3c 10 0f          	cmpb   $0xf,(%rax,%rdx,1)
 150fd2d:	48 89 d0             	mov    %rdx,%rax
 150fd30:	75 06                	jne    150fd38 <tier0_tables_open+0x43e8>
 150fd32:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 150fd35:	c1 e8 03             	shr    $0x3,%eax
 150fd38:	48 8b 0c 24          	mov    (%rsp),%rcx
 150fd3c:	48 8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%rsi
 150fd44:	48 8b 49 30          	mov    0x30(%rcx),%rcx
 150fd48:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
 150fd4c:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 150fd51:	48 85 f6             	test   %rsi,%rsi
 150fd54:	0f 84 fb 0b 00 00    	je     1510955 <tier0_tables_open+0x5005>
 150fd5a:	48 8b 0c 24          	mov    (%rsp),%rcx
 150fd5e:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 150fd62:	48 8b 0c c1          	mov    (%rcx,%rax,8),%rcx
 150fd66:	48 89 d0             	mov    %rdx,%rax
 150fd69:	48 c1 e0 04          	shl    $0x4,%rax
 150fd6d:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 150fd75:	0f 84 e8 0b 00 00    	je     1510963 <tier0_tables_open+0x5013>
 150fd7b:	48 85 c9             	test   %rcx,%rcx
 150fd7e:	0f 84 99 0e 00 00    	je     1510c1d <tier0_tables_open+0x52cd>
 150fd84:	48 8b 34 24          	mov    (%rsp),%rsi
 150fd88:	48 8b be a8 01 00 00 	mov    0x1a8(%rsi),%rdi
 150fd8f:	48 8b 1c d7          	mov    (%rdi,%rdx,8),%rbx
 150fd93:	48 89 da             	mov    %rbx,%rdx
 150fd96:	48 c1 ea 20          	shr    $0x20,%rdx
 150fd9a:	48 83 7c 24 58 01    	cmpq   $0x1,0x58(%rsp)
 150fda0:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 150fda5:	0f 85 8d 0e 00 00    	jne    1510c38 <tier0_tables_open+0x52e8>
 150fdab:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 150fdb4:	45 31 c0             	xor    %r8d,%r8d
 150fdb7:	e9 db 0f 00 00       	jmp    1510d97 <tier0_tables_open+0x5447>
 150fdbc:	48 83 7c 24 68 00    	cmpq   $0x0,0x68(%rsp)
 150fdc2:	0f 84 81 fe ff ff    	je     150fc49 <tier0_tables_open+0x42f9>
 150fdc8:	31 c0                	xor    %eax,%eax
 150fdca:	31 c9                	xor    %ecx,%ecx
 150fdcc:	c4 e2 79 59 05 2b 03 07 ff 	vpbroadcastq -0xf8fcd5(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 150fdd5:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 150fdda:	89 c2                	mov    %eax,%edx
 150fddc:	83 e2 c0             	and    $0xffffffc0,%edx
 150fddf:	48 ff c1             	inc    %rcx
 150fde2:	48 83 c0 40          	add    $0x40,%rax
 150fde6:	c5 f9 7f 04 16       	vmovdqa %xmm0,(%rsi,%rdx,1)
 150fdeb:	48 8b b4 24 48 01 00 00 	mov    0x148(%rsp),%rsi
 150fdf3:	8b 56 18             	mov    0x18(%rsi),%edx
 150fdf6:	48 39 d1             	cmp    %rdx,%rcx
 150fdf9:	72 d1                	jb     150fdcc <tier0_tables_open+0x447c>
 150fdfb:	e9 49 fe ff ff       	jmp    150fc49 <tier0_tables_open+0x42f9>
 150fe00:	48 8b 34 24          	mov    (%rsp),%rsi
 150fe04:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 150fe0c:	48 8b 46 28          	mov    0x28(%rsi),%rax
 150fe10:	48 8b 56 70          	mov    0x70(%rsi),%rdx
 150fe14:	48 8b 76 78          	mov    0x78(%rsi),%rsi
 150fe18:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 150fe1b:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 150fe1e:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 150fe21:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 150fe26:	01 d0                	add    %edx,%eax
 150fe28:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 150fe2d:	89 84 24 e0 00 00 00 	mov    %eax,0xe0(%rsp)
 150fe34:	39 c2                	cmp    %eax,%edx
 150fe36:	0f 83 19 0b 00 00    	jae    1510955 <tier0_tables_open+0x5005>
 150fe3c:	48 8b 04 24          	mov    (%rsp),%rax
 150fe40:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 150fe48:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
 150fe4d:	48 c7 84 24 70 01 00 00 00 00 00 00 	movq   $0x0,0x170(%rsp)
 150fe59:	48 c7 84 24 28 01 00 00 00 00 00 00 	movq   $0x0,0x128(%rsp)
 150fe65:	48 c7 84 24 a8 00 00 00 00 00 00 00 	movq   $0x0,0xa8(%rsp)
 150fe71:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 150fe7a:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 150fe83:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 150fe8c:	48 8b 40 38          	mov    0x38(%rax),%rax
 150fe90:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
 150fe95:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
 150fe99:	48 89 84 24 b8 00 00 00 	mov    %rax,0xb8(%rsp)
 150fea1:	8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%eax
 150fea8:	48 89 84 24 98 01 00 00 	mov    %rax,0x198(%rsp)
 150feb0:	44 89 e8             	mov    %r13d,%eax
 150feb3:	f7 d0                	not    %eax
 150feb5:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 150febd:	41 8d 45 01          	lea    0x1(%r13),%eax
 150fec1:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 150fec9:	b0 ff                	mov    $0xff,%al
 150fecb:	89 84 24 e4 00 00 00 	mov    %eax,0xe4(%rsp)
 150fed2:	e9 93 01 00 00       	jmp    151006a <tier0_tables_open+0x471a>
 150fed7:	48 89 c8             	mov    %rcx,%rax
 150feda:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
 150fee3:	4c 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%r8
 150feeb:	45 89 fa             	mov    %r15d,%r10d
 150feee:	48 09 ac 24 28 01 00 00 	or     %rbp,0x128(%rsp)
 150fef6:	31 c9                	xor    %ecx,%ecx
 150fef8:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 150fefe:	48 be 00 00 00 00 00 00 02 00 	movabs $0x2000000000000,%rsi
 150ff08:	49 89 ed             	mov    %rbp,%r13
 150ff0b:	bd 00 00 00 00       	mov    $0x0,%ebp
 150ff10:	48 8b 9c 24 18 01 00 00 	mov    0x118(%rsp),%rbx
 150ff18:	45 08 c2             	or     %r8b,%r10b
 150ff1b:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 150ff24:	4c 89 94 24 70 01 00 00 	mov    %r10,0x170(%rsp)
 150ff2c:	4c 89 94 24 a8 00 00 00 	mov    %r10,0xa8(%rsp)
 150ff34:	0f 95 c1             	setne  %cl
 150ff37:	41 f6 c1 10          	test   $0x10,%r9b
 150ff3b:	49 b9 00 00 00 00 fe ff 7f 00 	movabs $0x7ffffe00000000,%r9
 150ff45:	4c 0f 45 de          	cmovne %rsi,%r11
 150ff49:	be ff ff ff ff       	mov    $0xffffffff,%esi
 150ff4e:	4c 8d 66 01          	lea    0x1(%rsi),%r12
 150ff52:	be 1f 00 00 00       	mov    $0x1f,%esi
 150ff57:	4c 0f 44 e5          	cmove  %rbp,%r12
 150ff5b:	41 f6 c0 01          	test   $0x1,%r8b
 150ff5f:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
 150ff64:	4c 0f 45 dd          	cmovne %rbp,%r11
 150ff68:	45 84 ff             	test   %r15b,%r15b
 150ff6b:	49 89 ff             	mov    %rdi,%r15
 150ff6e:	4c 0f 44 dd          	cmove  %rbp,%r11
 150ff72:	49 c1 e7 3c          	shl    $0x3c,%r15
 150ff76:	48 83 fb 1f          	cmp    $0x1f,%rbx
 150ff7a:	48 0f 42 f3          	cmovb  %rbx,%rsi
 150ff7e:	48 c1 e6 37          	shl    $0x37,%rsi
 150ff82:	49 c1 e0 21          	shl    $0x21,%r8
 150ff86:	4d 29 c1             	sub    %r8,%r9
 150ff89:	48 85 db             	test   %rbx,%rbx
 150ff8c:	44 0f b6 84 24 d0 00 00 00 	movzbl 0xd0(%rsp),%r8d
 150ff95:	4c 0f 44 e3          	cmove  %rbx,%r12
 150ff99:	49 09 f1             	or     %rsi,%r9
 150ff9c:	40 80 cf 20          	or     $0x20,%dil
 150ffa0:	31 f6                	xor    %esi,%esi
 150ffa2:	48 bb 00 00 00 00 00 00 04 00 	movabs $0x4000000000000,%rbx
 150ffac:	4d 09 f9             	or     %r15,%r9
 150ffaf:	4c 0b 8c 24 10 01 00 00 	or     0x110(%rsp),%r9
 150ffb7:	4d 09 e1             	or     %r12,%r9
 150ffba:	f6 44 24 70 20       	testb  $0x20,0x70(%rsp)
 150ffbf:	40 0f 94 c6          	sete   %sil
 150ffc3:	f6 84 24 d8 00 00 00 02 	testb  $0x2,0xd8(%rsp)
 150ffcb:	0f 45 f1             	cmovne %ecx,%esi
 150ffce:	b9 00 00 00 00       	mov    $0x0,%ecx
 150ffd3:	40 84 f6             	test   %sil,%sil
 150ffd6:	48 0f 45 cb          	cmovne %rbx,%rcx
 150ffda:	48 03 4c 24 38       	add    0x38(%rsp),%rcx
 150ffdf:	49 0f ab fb          	bts    %rdi,%r11
 150ffe3:	4c 09 ea             	or     %r13,%rdx
 150ffe6:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
 150ffeb:	48 01 c8             	add    %rcx,%rax
 150ffee:	4c 01 d8             	add    %r11,%rax
 150fff1:	41 80 f8 11          	cmp    $0x11,%r8b
 150fff5:	49 0f 44 c1          	cmove  %r9,%rax
 150fff9:	80 bc 24 40 01 00 00 00 	cmpb   $0x0,0x140(%rsp)
 1510001:	48 0f 44 c5          	cmove  %rbp,%rax
 1510005:	48 0f 44 d5          	cmove  %rbp,%rdx
 1510009:	48 89 c6             	mov    %rax,%rsi
 151000c:	48 09 fe             	or     %rdi,%rsi
 151000f:	48 39 f8             	cmp    %rdi,%rax
 1510012:	48 0f 46 c7          	cmovbe %rdi,%rax
 1510016:	41 80 f8 11          	cmp    $0x11,%r8b
 151001a:	48 0f 45 c6          	cmovne %rsi,%rax
 151001e:	48 0f 45 cd          	cmovne %rbp,%rcx
 1510022:	48 0b 54 24 30       	or     0x30(%rsp),%rdx
 1510027:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
 151002c:	48 09 ca             	or     %rcx,%rdx
 151002f:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 1510034:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 151003c:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 1510041:	48 ff 44 24 10       	incq   0x10(%rsp)
 1510046:	48 ff 8c 24 f8 00 00 00 	decq   0xf8(%rsp)
 151004e:	48 ff c1             	inc    %rcx
 1510051:	ff c0                	inc    %eax
 1510053:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 151005b:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 1510060:	39 4c 24 58          	cmp    %ecx,0x58(%rsp)
 1510064:	0f 84 d7 0e 00 00    	je     1510f41 <tier0_tables_open+0x55f1>
 151006a:	48 8b 04 24          	mov    (%rsp),%rax
 151006e:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 1510073:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
 1510077:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
 151007e:	0f b6 0c 08          	movzbl (%rax,%rcx,1),%ecx
 1510082:	f6 c1 02             	test   $0x2,%cl
 1510085:	74 1a                	je     15100a1 <tier0_tables_open+0x4751>
 1510087:	48 8b 04 24          	mov    (%rsp),%rax
 151008b:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 1510090:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
 1510097:	83 3c 90 01          	cmpl   $0x1,(%rax,%rdx,4)
 151009b:	19 c0                	sbb    %eax,%eax
 151009d:	c5 fb 92 c8          	kmovd  %eax,%k1
 15100a1:	48 8b 14 24          	mov    (%rsp),%rdx
 15100a5:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 15100aa:	48 8b 82 b8 00 00 00 	mov    0xb8(%rdx),%rax
 15100b1:	48 8b 12             	mov    (%rdx),%rdx
 15100b4:	8b 04 b0             	mov    (%rax,%rsi,4),%eax
 15100b7:	c1 e8 03             	shr    $0x3,%eax
 15100ba:	80 3c 02 0f          	cmpb   $0xf,(%rdx,%rax,1)
 15100be:	48 89 c2             	mov    %rax,%rdx
 15100c1:	75 0e                	jne    15100d1 <tier0_tables_open+0x4781>
 15100c3:	48 8b 14 24          	mov    (%rsp),%rdx
 15100c7:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 15100cb:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 15100ce:	c1 ea 03             	shr    $0x3,%edx
 15100d1:	48 8b 34 24          	mov    (%rsp),%rsi
 15100d5:	48 83 bc 24 b8 00 00 00 11 	cmpq   $0x11,0xb8(%rsp)
 15100de:	48 8b 7e 38          	mov    0x38(%rsi),%rdi
 15100e2:	4c 8b 0c d7          	mov    (%rdi,%rdx,8),%r9
 15100e6:	48 8b be d8 00 00 00 	mov    0xd8(%rsi),%rdi
 15100ed:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 15100f2:	48 8b 14 f7          	mov    (%rdi,%rsi,8),%rdx
 15100f6:	72 42                	jb     151013a <tier0_tables_open+0x47ea>
 15100f8:	80 bc 24 d0 00 00 00 11 	cmpb   $0x11,0xd0(%rsp)
 1510100:	74 17                	je     1510119 <tier0_tables_open+0x47c9>
 1510102:	c4 e2 79 78 05 b5 06 01 ff 	vpbroadcastb -0xfef94b(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 151010b:	4c 39 8c 24 b8 00 00 00 	cmp    %r9,0xb8(%rsp)
 1510113:	0f 85 67 01 00 00    	jne    1510280 <tier0_tables_open+0x4930>
 1510119:	48 8b 34 24          	mov    (%rsp),%rsi
 151011d:	c4 e2 79 78 05 9a 06 01 ff 	vpbroadcastb -0xfef966(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 1510126:	8b be bc 01 00 00    	mov    0x1bc(%rsi),%edi
 151012c:	48 39 bc 24 b8 00 00 00 	cmp    %rdi,0xb8(%rsp)
 1510134:	0f 87 46 01 00 00    	ja     1510280 <tier0_tables_open+0x4930>
 151013a:	f6 c1 02             	test   $0x2,%cl
 151013d:	0f 85 ba 00 00 00    	jne    15101fd <tier0_tables_open+0x48ad>
 1510143:	48 c1 ea 03          	shr    $0x3,%rdx
 1510147:	31 ff                	xor    %edi,%edi
 1510149:	4d 85 c9             	test   %r9,%r9
 151014c:	75 1b                	jne    1510169 <tier0_tables_open+0x4819>
 151014e:	48 85 d2             	test   %rdx,%rdx
 1510151:	74 16                	je     1510169 <tier0_tables_open+0x4819>
 1510153:	48 8b 0c 24          	mov    (%rsp),%rcx
 1510157:	be 0d 01 00 00       	mov    $0x10d,%esi
 151015c:	48 8b 89 88 01 00 00 	mov    0x188(%rcx),%rcx
 1510163:	c4 e2 48 f7 3c 81    	bextr  %esi,(%rcx,%rax,4),%edi
 1510169:	48 8b 34 24          	mov    (%rsp),%rsi
 151016d:	62 f2 7d 08 7a c2    	vpbroadcastb %edx,%xmm0
 1510173:	c5 f9 fc 05 95 5a 06 ff 	vpaddb -0xf9a56b(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 151017b:	b1 10                	mov    $0x10,%cl
 151017d:	41 b8 fe ff ff ff    	mov    $0xfffffffe,%r8d
 1510183:	28 d1                	sub    %dl,%cl
 1510185:	62 f1 7d 18 db 1d 35 03 07 ff 	vpandd -0xf8fccb(%rip){1to4},%xmm0,%xmm3        # 5804c4 <tier0_emit_x87.operations+0x7c>
 151018f:	4c 8b 96 98 01 00 00 	mov    0x198(%rsi),%r10
 1510196:	4c 8b 8e 80 01 00 00 	mov    0x180(%rsi),%r9
 151019d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 15101a2:	45 0f b6 14 02       	movzbl (%r10,%rax,1),%r10d
 15101a7:	41 80 fa 07          	cmp    $0x7,%r10b
 15101ab:	c4 62 29 f7 d6       	shlx   %r10d,%esi,%r10d
 15101b0:	be 7f 00 00 00       	mov    $0x7f,%esi
 15101b5:	41 f6 d2             	not    %r10b
 15101b8:	41 0f b6 d2          	movzbl %r10b,%edx
 15101bc:	0f 43 d6             	cmovae %esi,%edx
 15101bf:	41 d3 c0             	rol    %cl,%r8d
 15101c2:	40 84 ff             	test   %dil,%dil
 15101c5:	be ff ff 00 00       	mov    $0xffff,%esi
 15101ca:	44 0f 44 c6          	cmove  %esi,%r8d
 15101ce:	48 c1 e0 04          	shl    $0x4,%rax
 15101d2:	62 f2 7d 08 7a ca    	vpbroadcastb %edx,%xmm1
 15101d8:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 15101dd:	c4 c1 79 6f 14 01    	vmovdqa (%r9,%rax,1),%xmm2
 15101e3:	62 f2 76 0a 26 d0    	vptestnmb %xmm0,%xmm1,%k2{%k2}
 15101e9:	c4 e2 79 78 05 ce 05 01 ff 	vpbroadcastb -0xfefa32(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 15101f2:	62 f2 6d 0a 00 c3    	vpshufb %xmm3,%xmm2,%xmm0{%k2}
 15101f8:	e9 83 00 00 00       	jmp    1510280 <tier0_tables_open+0x4930>
 15101fd:	48 8b 04 24          	mov    (%rsp),%rax
 1510201:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 1510206:	bf 47 00 00 00       	mov    $0x47,%edi
 151020b:	41 b9 48 00 00 00    	mov    $0x48,%r9d
 1510211:	29 d7                	sub    %edx,%edi
 1510213:	c1 ef 03             	shr    $0x3,%edi
 1510216:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
 151021d:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 1510220:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
 1510224:	48 8d 44 02 bf       	lea    -0x41(%rdx,%rax,1),%rax
 1510229:	41 29 c9             	sub    %ecx,%r9d
 151022c:	b9 00 00 00 00       	mov    $0x0,%ecx
 1510231:	41 c1 e9 03          	shr    $0x3,%r9d
 1510235:	48 83 fa 40          	cmp    $0x40,%rdx
 1510239:	0f 43 f9             	cmovae %ecx,%edi
 151023c:	48 83 f8 c0          	cmp    $0xffffffffffffffc0,%rax
 1510240:	44 0f 42 c9          	cmovb  %ecx,%r9d
 1510244:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 151024a:	62 f3 7d 08 3e 15 bb 59 06 ff 06 	vpcmpnleub -0xf9a645(%rip),%xmm0,%k2        # 575c10 <x86_effects_unknown+0x1b0>
 1510255:	62 d2 7d 08 7a c1    	vpbroadcastb %r9d,%xmm0
 151025b:	62 f3 7d 08 3e 1d ea 59 06 ff 05 	vpcmpnltub -0xf9a616(%rip),%xmm0,%k3        # 575c50 <x86_effects_unknown+0x1f0>
 1510266:	62 f1 7f 8b 6f 0d f0 59 06 ff 	vmovdqu8 -0xf9a610(%rip),%xmm1{%k3}{z}        # 575c60 <x86_effects_unknown+0x200>
 1510270:	62 f1 75 18 eb 05 4e 02 07 ff 	vpord  -0xf8fdb2(%rip){1to4},%xmm1,%xmm0        # 5804c8 <tier0_emit_x87.operations+0x80>
 151027a:	62 f1 7f 0a 6f c1    	vmovdqu8 %xmm1,%xmm0{%k2}
 1510280:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 1510288:	62 f1 7f 09 6f 05 fe 59 06 ff 	vmovdqu8 -0xf9a602(%rip),%xmm0{%k1}        # 575c90 <x86_effects_unknown+0x230>
 1510292:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 1510297:	89 c0                	mov    %eax,%eax
 1510299:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 15102a1:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 15102a6:	48 c1 e0 06          	shl    $0x6,%rax
 15102aa:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 15102b2:	c5 f9 7f 04 01       	vmovdqa %xmm0,(%rcx,%rax,1)
 15102b7:	0f 84 77 fd ff ff    	je     1510034 <tier0_tables_open+0x46e4>
 15102bd:	48 8b 04 24          	mov    (%rsp),%rax
 15102c1:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 15102c6:	4c 8b a8 b8 00 00 00 	mov    0xb8(%rax),%r13
 15102cd:	48 8b 00             	mov    (%rax),%rax
 15102d0:	45 8b 54 8d 00       	mov    0x0(%r13,%rcx,4),%r10d
 15102d5:	48 89 84 24 90 00 00 00 	mov    %rax,0x90(%rsp)
 15102dd:	41 c1 ea 03          	shr    $0x3,%r10d
 15102e1:	42 80 3c 10 0f       	cmpb   $0xf,(%rax,%r10,1)
 15102e6:	4c 89 d0             	mov    %r10,%rax
 15102e9:	75 0f                	jne    15102fa <tier0_tables_open+0x49aa>
 15102eb:	48 8b 04 24          	mov    (%rsp),%rax
 15102ef:	48 8b 40 20          	mov    0x20(%rax),%rax
 15102f3:	42 8b 04 90          	mov    (%rax,%r10,4),%eax
 15102f7:	c1 e8 03             	shr    $0x3,%eax
 15102fa:	48 8b 14 24          	mov    (%rsp),%rdx
 15102fe:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
 1510302:	48 8b 3c c1          	mov    (%rcx,%rax,8),%rdi
 1510306:	48 8b 8a c0 00 00 00 	mov    0xc0(%rdx),%rcx
 151030d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 1510312:	48 8b 92 d0 00 00 00 	mov    0xd0(%rdx),%rdx
 1510319:	44 8b 1c 81          	mov    (%rcx,%rax,4),%r11d
 151031d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
 1510321:	48 8d 2c fd 00 00 00 00 	lea    0x0(,%rdi,8),%rbp
 1510329:	48 89 8c 24 30 01 00 00 	mov    %rcx,0x130(%rsp)
 1510331:	48 89 94 24 38 01 00 00 	mov    %rdx,0x138(%rsp)
 1510339:	4d 85 db             	test   %r11,%r11
 151033c:	4c 89 9c 24 08 01 00 00 	mov    %r11,0x108(%rsp)
 1510344:	88 84 24 d8 00 00 00 	mov    %al,0xd8(%rsp)
 151034b:	41 0f 95 c0          	setne  %r8b
 151034f:	a8 02                	test   $0x2,%al
 1510351:	48 b8 f8 ff ff ff 01 00 00 00 	movabs $0x1fffffff8,%rax
 151035b:	0f 94 44 24 70       	sete   0x70(%rsp)
 1510360:	4c 39 dd             	cmp    %r11,%rbp
 1510363:	4c 0f 42 dd          	cmovb  %rbp,%r11
 1510367:	45 31 ff             	xor    %r15d,%r15d
 151036a:	49 83 c3 07          	add    $0x7,%r11
 151036e:	49 21 c3             	and    %rax,%r11
 1510371:	49 83 fb 09          	cmp    $0x9,%r11
 1510375:	72 26                	jb     151039d <tier0_tables_open+0x4a4d>
 1510377:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 151037d:	49 83 fb 11          	cmp    $0x11,%r11
 1510381:	72 1a                	jb     151039d <tier0_tables_open+0x4a4d>
 1510383:	41 bf 02 00 00 00    	mov    $0x2,%r15d
 1510389:	49 83 fb 21          	cmp    $0x21,%r11
 151038d:	72 0e                	jb     151039d <tier0_tables_open+0x4a4d>
 151038f:	49 83 fb 41          	cmp    $0x41,%r11
 1510393:	41 bf 04 00 00 00    	mov    $0x4,%r15d
 1510399:	41 83 df 00          	sbb    $0x0,%r15d
 151039d:	48 8b 04 24          	mov    (%rsp),%rax
 15103a1:	48 8b 88 d8 00 00 00 	mov    0xd8(%rax),%rcx
 15103a8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 15103ad:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
 15103b1:	48 89 8c 24 90 01 00 00 	mov    %rcx,0x190(%rsp)
 15103b9:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
 15103be:	48 c1 e8 03          	shr    $0x3,%rax
 15103c2:	f6 84 24 d8 00 00 00 02 	testb  $0x2,0xd8(%rsp)
 15103ca:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
 15103cf:	74 39                	je     151040a <tier0_tables_open+0x4aba>
 15103d1:	31 c0                	xor    %eax,%eax
 15103d3:	c4 e2 f8 f3 cf       	blsr   %rdi,%rax
 15103d8:	0f 94 c0             	sete   %al
 15103db:	48 85 ed             	test   %rbp,%rbp
 15103de:	0f 94 c1             	sete   %cl
 15103e1:	08 c1                	or     %al,%cl
 15103e3:	0f 85 93 00 00 00    	jne    151047c <tier0_tables_open+0x4b2c>
 15103e9:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 15103ee:	48 09 e8             	or     %rbp,%rax
 15103f1:	48 c1 e8 20          	shr    $0x20,%rax
 15103f5:	0f 84 8e 00 00 00    	je     1510489 <tier0_tables_open+0x4b39>
 15103fb:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 1510400:	31 d2                	xor    %edx,%edx
 1510402:	48 f7 f5             	div    %rbp
 1510405:	e9 88 00 00 00       	jmp    1510492 <tier0_tables_open+0x4b42>
 151040a:	48 8b 04 24          	mov    (%rsp),%rax
 151040e:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 1510413:	4c 8b 4c 24 38       	mov    0x38(%rsp),%r9
 1510418:	48 89 bc 24 18 01 00 00 	mov    %rdi,0x118(%rsp)
 1510420:	48 8b 80 a8 01 00 00 	mov    0x1a8(%rax),%rax
 1510427:	8d 0c 36             	lea    (%rsi,%rsi,1),%ecx
 151042a:	49 f7 c1 88 ff ff ff 	test   $0xffffffffffffff88,%r9
 1510431:	4a 8b 04 d0          	mov    (%rax,%r10,8),%rax
 1510435:	c4 e2 f1 f7 c8       	shlx   %rcx,%rax,%rcx
 151043a:	89 ca                	mov    %ecx,%edx
 151043c:	b9 00 00 00 00       	mov    $0x0,%ecx
 1510441:	48 0f 45 d1          	cmovne %rcx,%rdx
 1510445:	48 c1 e8 20          	shr    $0x20,%rax
 1510449:	48 89 94 24 10 01 00 00 	mov    %rdx,0x110(%rsp)
 1510451:	c4 e2 c9 f7 d0       	shlx   %rsi,%rax,%rdx
 1510456:	48 b8 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rax
 1510460:	48 c1 e2 20          	shl    $0x20,%rdx
 1510464:	48 21 c2             	and    %rax,%rdx
 1510467:	49 81 f9 80 00 00 00 	cmp    $0x80,%r9
 151046e:	48 89 f0             	mov    %rsi,%rax
 1510471:	48 0f 43 d1          	cmovae %rcx,%rdx
 1510475:	b1 01                	mov    $0x1,%cl
 1510477:	e9 f1 00 00 00       	jmp    151056d <tier0_tables_open+0x4c1d>
 151047c:	48 89 f8             	mov    %rdi,%rax
 151047f:	48 f7 d8             	neg    %rax
 1510482:	48 23 44 24 60       	and    0x60(%rsp),%rax
 1510487:	eb 0d                	jmp    1510496 <tier0_tables_open+0x4b46>
 1510489:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 151048e:	31 d2                	xor    %edx,%edx
 1510490:	f7 f5                	div    %ebp
 1510492:	48 0f af c7          	imul   %rdi,%rax
 1510496:	80 bc 24 d0 00 00 00 11 	cmpb   $0x11,0xd0(%rsp)
 151049e:	b9 01 00 00 00       	mov    $0x1,%ecx
 15104a3:	be 00 00 00 00       	mov    $0x0,%esi
 15104a8:	41 bc 10 00 00 00    	mov    $0x10,%r12d
 15104ae:	c4 e2 81 f7 d1       	shlx   %r15,%rcx,%rdx
 15104b3:	48 0f 45 d7          	cmovne %rdi,%rdx
 15104b7:	48 0f 44 c6          	cmove  %rsi,%rax
 15104bb:	f3 48 0f b8 ca       	popcnt %rdx,%rcx
 15104c0:	48 89 94 24 18 01 00 00 	mov    %rdx,0x118(%rsp)
 15104c8:	f3 48 0f bc d2       	tzcnt  %rdx,%rdx
 15104cd:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
 15104d1:	48 83 fa 04          	cmp    $0x4,%rdx
 15104d5:	ba 09 00 00 00       	mov    $0x9,%edx
 15104da:	4c 0f 43 ca          	cmovae %rdx,%r9
 15104de:	83 f9 01             	cmp    $0x1,%ecx
 15104e1:	8d 0c 00             	lea    (%rax,%rax,1),%ecx
 15104e4:	4c 0f 45 ca          	cmovne %rdx,%r9
 15104e8:	48 a9 f1 ff ff ff    	test   $0xfffffffffffffff1,%rax
 15104ee:	c4 c2 f1 f7 d1       	shlx   %rcx,%r9,%rdx
 15104f3:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 15104f9:	89 d2                	mov    %edx,%edx
 15104fb:	48 0f 45 d6          	cmovne %rsi,%rdx
 15104ff:	48 89 94 24 10 01 00 00 	mov    %rdx,0x110(%rsp)
 1510507:	ba 0f 00 00 00       	mov    $0xf,%edx
 151050c:	c4 e2 f1 f7 ca       	shlx   %rcx,%rdx,%rcx
 1510511:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 1510516:	48 0f 45 ce          	cmovne %rsi,%rcx
 151051a:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 151051f:	48 8d 54 15 ff       	lea    -0x1(%rbp,%rdx,1),%rdx
 1510524:	48 c1 ea 03          	shr    $0x3,%rdx
 1510528:	48 29 f2             	sub    %rsi,%rdx
 151052b:	48 ff c2             	inc    %rdx
 151052e:	48 83 fe 10          	cmp    $0x10,%rsi
 1510532:	4c 0f 42 ce          	cmovb  %rsi,%r9
 1510536:	be 10 00 00 00       	mov    $0x10,%esi
 151053b:	4d 29 cc             	sub    %r9,%r12
 151053e:	4c 39 e2             	cmp    %r12,%rdx
 1510541:	42 8d 14 0a          	lea    (%rdx,%r9,1),%edx
 1510545:	0f 43 d6             	cmovae %esi,%edx
 1510548:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
 151054f:	44 29 ca             	sub    %r9d,%edx
 1510552:	c4 e2 e9 f7 d6       	shlx   %rdx,%rsi,%rdx
 1510557:	f7 d2                	not    %edx
 1510559:	c4 e2 b1 f7 d2       	shlx   %r9,%rdx,%rdx
 151055e:	48 c1 e2 20          	shl    $0x20,%rdx
 1510562:	48 85 8c 24 28 01 00 00 	test   %rcx,0x128(%rsp)
 151056a:	0f 94 c1             	sete   %cl
 151056d:	44 89 c6             	mov    %r8d,%esi
 1510570:	40 0a 74 24 70       	or     0x70(%rsp),%sil
 1510575:	f6 c1 01             	test   $0x1,%cl
 1510578:	44 0f b6 8c 24 d0 00 00 00 	movzbl 0xd0(%rsp),%r9d
 1510581:	bd 00 00 00 00       	mov    $0x0,%ebp
 1510586:	b9 00 00 00 00       	mov    $0x0,%ecx
 151058b:	48 0f 45 ac 24 10 01 00 00 	cmovne 0x110(%rsp),%rbp
 1510594:	41 80 f9 11          	cmp    $0x11,%r9b
 1510598:	40 88 b4 24 40 01 00 00 	mov    %sil,0x140(%rsp)
 15105a0:	48 0f 44 e9          	cmove  %rcx,%rbp
 15105a4:	40 84 f6             	test   %sil,%sil
 15105a7:	48 0f 44 e9          	cmove  %rcx,%rbp
 15105ab:	41 80 f9 11          	cmp    $0x11,%r9b
 15105af:	75 2e                	jne    15105df <tier0_tables_open+0x4c8f>
 15105b1:	48 8b 04 24          	mov    (%rsp),%rax
 15105b5:	48 8b 80 a0 01 00 00 	mov    0x1a0(%rax),%rax
 15105bc:	42 0f b6 04 10       	movzbl (%rax,%r10,1),%eax
 15105c1:	88 44 24 70          	mov    %al,0x70(%rsp)
 15105c5:	31 c0                	xor    %eax,%eax
 15105c7:	49 81 fb 80 00 00 00 	cmp    $0x80,%r11
 15105ce:	0f 94 c0             	sete   %al
 15105d1:	45 31 db             	xor    %r11d,%r11d
 15105d4:	c1 e0 04             	shl    $0x4,%eax
 15105d7:	41 09 c7             	or     %eax,%r15d
 15105da:	e9 bf 02 00 00       	jmp    151089e <tier0_tables_open+0x4f4e>
 15105df:	44 0f b6 84 24 d8 00 00 00 	movzbl 0xd8(%rsp),%r8d
 15105e8:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 15105f1:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 15105f7:	45 89 c3             	mov    %r8d,%r11d
 15105fa:	0f 95 c1             	setne  %cl
 15105fd:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 1510603:	41 80 e3 02          	and    $0x2,%r11b
 1510607:	41 d0 eb             	shr    $1,%r11b
 151060a:	48 83 f8 10          	cmp    $0x10,%rax
 151060e:	49 0f 43 c0          	cmovae %r8,%rax
 1510612:	4c 8b 04 24          	mov    (%rsp),%r8
 1510616:	49 29 c1             	sub    %rax,%r9
 1510619:	8d 34 07             	lea    (%rdi,%rax,1),%esi
 151061c:	4c 39 cf             	cmp    %r9,%rdi
 151061f:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 1510625:	41 0f 43 f1          	cmovae %r9d,%esi
 1510629:	41 20 cb             	and    %cl,%r11b
 151062c:	49 8b b8 a0 01 00 00 	mov    0x1a0(%r8),%rdi
 1510633:	48 89 fb             	mov    %rdi,%rbx
 1510636:	42 0f b6 3c 17       	movzbl (%rdi,%r10,1),%edi
 151063b:	40 88 7c 24 70       	mov    %dil,0x70(%rsp)
 1510640:	41 80 fb 01          	cmp    $0x1,%r11b
 1510644:	0f 85 15 02 00 00    	jne    151085f <tier0_tables_open+0x4f0f>
 151064a:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
 151064e:	48 39 4c 24 10       	cmp    %rcx,0x10(%rsp)
 1510653:	0f 82 06 02 00 00    	jb     151085f <tier0_tables_open+0x4f0f>
 1510659:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 151065e:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 1510666:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
 151066b:	41 ff c0             	inc    %r8d
 151066e:	48 01 cf             	add    %rcx,%rdi
 1510671:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
 1510676:	44 3b 84 24 e0 00 00 00 	cmp    0xe0(%rsp),%r8d
 151067e:	0f 83 ac 00 00 00    	jae    1510730 <tier0_tables_open+0x4de0>
 1510684:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 151068c:	4c 8b 94 24 98 01 00 00 	mov    0x198(%rsp),%r10
 1510694:	4c 8b bc 24 38 01 00 00 	mov    0x138(%rsp),%r15
 151069c:	48 c7 44 24 20 00 00 00 00 	movq   $0x0,0x20(%rsp)
 15106a5:	4a 8d 0c 85 00 00 00 00 	lea    0x0(,%r8,4),%rcx
 15106ad:	4e 8d 0c c5 00 00 00 00 	lea    0x0(,%r8,8),%r9
 15106b5:	48 03 8c 24 30 01 00 00 	add    0x130(%rsp),%rcx
 15106bd:	4c 03 8c 24 90 01 00 00 	add    0x190(%rsp),%r9
 15106c5:	4d 29 c2             	sub    %r8,%r10
 15106c8:	4d 01 f8             	add    %r15,%r8
 15106cb:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 15106d3:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 15106d8:	4c 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%r15
 15106e0:	43 f6 04 07 02       	testb  $0x2,(%r15,%r8,1)
 15106e5:	74 38                	je     151071f <tier0_tables_open+0x4dcf>
 15106e7:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 15106ec:	4f 8b 3c c1          	mov    (%r9,%r8,8),%r15
 15106f0:	41 f6 c7 07          	test   $0x7,%r15b
 15106f4:	74 29                	je     151071f <tier0_tables_open+0x4dcf>
 15106f6:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 15106fb:	46 8b 24 81          	mov    (%rcx,%r8,4),%r12d
 15106ff:	4d 01 e7             	add    %r12,%r15
 1510702:	49 39 ff             	cmp    %rdi,%r15
 1510705:	49 0f 47 ff          	cmova  %r15,%rdi
 1510709:	49 ff c0             	inc    %r8
 151070c:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
 1510711:	4d 39 c2             	cmp    %r8,%r10
 1510714:	75 bd                	jne    15106d3 <tier0_tables_open+0x4d83>
 1510716:	8b 8c 24 e0 00 00 00 	mov    0xe0(%rsp),%ecx
 151071d:	eb 0c                	jmp    151072b <tier0_tables_open+0x4ddb>
 151071f:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 1510724:	2b 8c 24 f8 00 00 00 	sub    0xf8(%rsp),%ecx
 151072b:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 1510730:	48 2b 7c 24 38       	sub    0x38(%rsp),%rdi
 1510735:	b1 ff                	mov    $0xff,%cl
 1510737:	89 8c 24 e4 00 00 00 	mov    %ecx,0xe4(%rsp)
 151073e:	48 83 c7 07          	add    $0x7,%rdi
 1510742:	48 83 ff 48          	cmp    $0x48,%rdi
 1510746:	0f 82 03 01 00 00    	jb     151084f <tier0_tables_open+0x4eff>
 151074c:	48 8b 8c 24 b8 00 00 00 	mov    0xb8(%rsp),%rcx
 1510754:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 1510759:	44 3b 84 24 e0 00 00 00 	cmp    0xe0(%rsp),%r8d
 1510761:	0f 83 ad 00 00 00    	jae    1510814 <tier0_tables_open+0x4ec4>
 1510767:	44 8b 54 24 20       	mov    0x20(%rsp),%r10d
 151076c:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 1510774:	46 0f b6 0c 11       	movzbl (%rcx,%r10,1),%r9d
 1510779:	b1 01                	mov    $0x1,%cl
 151077b:	41 f6 c1 02          	test   $0x2,%r9b
 151077f:	74 10                	je     1510791 <tier0_tables_open+0x4e41>
 1510781:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 1510789:	42 83 3c 91 00       	cmpl   $0x0,(%rcx,%r10,4)
 151078e:	0f 95 c1             	setne  %cl
 1510791:	47 8b 64 95 00       	mov    0x0(%r13,%r10,4),%r12d
 1510796:	4c 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%r8
 151079e:	41 c1 ec 03          	shr    $0x3,%r12d
 15107a2:	43 80 3c 20 0f       	cmpb   $0xf,(%r8,%r12,1)
 15107a7:	75 23                	jne    15107cc <tier0_tables_open+0x4e7c>
 15107a9:	4c 8b 04 24          	mov    (%rsp),%r8
 15107ad:	4d 8b 78 20          	mov    0x20(%r8),%r15
 15107b1:	47 8b 24 a7          	mov    (%r15,%r12,4),%r12d
 15107b5:	41 c1 ec 03          	shr    $0x3,%r12d
 15107b9:	41 b7 01             	mov    $0x1,%r15b
 15107bc:	41 f6 c1 02          	test   $0x2,%r9b
 15107c0:	74 13                	je     15107d5 <tier0_tables_open+0x4e85>
 15107c2:	44 20 f9             	and    %r15b,%cl
 15107c5:	80 f9 01             	cmp    $0x1,%cl
 15107c8:	75 1f                	jne    15107e9 <tier0_tables_open+0x4e99>
 15107ca:	eb 38                	jmp    1510804 <tier0_tables_open+0x4eb4>
 15107cc:	41 b7 01             	mov    $0x1,%r15b
 15107cf:	41 f6 c1 02          	test   $0x2,%r9b
 15107d3:	75 ed                	jne    15107c2 <tier0_tables_open+0x4e72>
 15107d5:	45 89 e1             	mov    %r12d,%r9d
 15107d8:	42 f6 04 0b 20       	testb  $0x20,(%rbx,%r9,1)
 15107dd:	41 0f 94 c7          	sete   %r15b
 15107e1:	44 20 f9             	and    %r15b,%cl
 15107e4:	80 f9 01             	cmp    $0x1,%cl
 15107e7:	74 1b                	je     1510804 <tier0_tables_open+0x4eb4>
 15107e9:	49 ff c2             	inc    %r10
 15107ec:	4c 39 94 24 98 01 00 00 	cmp    %r10,0x198(%rsp)
 15107f4:	0f 85 72 ff ff ff    	jne    151076c <tier0_tables_open+0x4e1c>
 15107fa:	48 8b 8c 24 b8 00 00 00 	mov    0xb8(%rsp),%rcx
 1510802:	eb 10                	jmp    1510814 <tier0_tables_open+0x4ec4>
 1510804:	48 8b 8c 24 90 01 00 00 	mov    0x190(%rsp),%rcx
 151080c:	4a 8b 0c d1          	mov    (%rcx,%r10,8),%rcx
 1510810:	48 c1 e9 03          	shr    $0x3,%rcx
 1510814:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 1510819:	48 c1 ef 03          	shr    $0x3,%rdi
 151081d:	48 83 c7 0f          	add    $0xf,%rdi
 1510821:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
 1510825:	48 83 ff 10          	cmp    $0x10,%rdi
 1510829:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 151082d:	41 0f 94 c0          	sete   %r8b
 1510831:	bf 00 00 00 00       	mov    $0x0,%edi
 1510836:	41 c0 e0 04          	shl    $0x4,%r8b
 151083a:	41 80 c8 04          	or     $0x4,%r8b
 151083e:	49 39 c9             	cmp    %rcx,%r9
 1510841:	41 0f b6 c8          	movzbl %r8b,%ecx
 1510845:	0f 47 cf             	cmova  %edi,%ecx
 1510848:	89 8c 24 e4 00 00 00 	mov    %ecx,0xe4(%rsp)
 151084f:	48 8b 9c 24 70 01 00 00 	mov    0x170(%rsp),%rbx
 1510857:	48 89 9c 24 a8 00 00 00 	mov    %rbx,0xa8(%rsp)
 151085f:	29 c6                	sub    %eax,%esi
 1510861:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
 1510868:	c4 e2 c9 f7 c9       	shlx   %rsi,%rcx,%rcx
 151086d:	f7 d1                	not    %ecx
 151086f:	c4 e2 f9 f7 c1       	shlx   %rax,%rcx,%rax
 1510874:	8b 8c 24 e4 00 00 00 	mov    0xe4(%rsp),%ecx
 151087b:	48 c1 e0 30          	shl    $0x30,%rax
 151087f:	48 09 c2             	or     %rax,%rdx
 1510882:	0f b6 44 24 70       	movzbl 0x70(%rsp),%eax
 1510887:	44 0f b6 f9          	movzbl %cl,%r15d
 151088b:	24 0f                	and    $0xf,%al
 151088d:	80 f9 ff             	cmp    $0xff,%cl
 1510890:	0f b6 c0             	movzbl %al,%eax
 1510893:	44 0f 44 f8          	cmove  %eax,%r15d
 1510897:	45 84 db             	test   %r11b,%r11b
 151089a:	44 0f 44 f8          	cmove  %eax,%r15d
 151089e:	44 0f b6 84 24 d8 00 00 00 	movzbl 0xd8(%rsp),%r8d
 15108a7:	0f b6 44 24 70       	movzbl 0x70(%rsp),%eax
 15108ac:	41 0f b6 cf          	movzbl %r15b,%ecx
 15108b0:	41 f6 c0 02          	test   $0x2,%r8b
 15108b4:	0f 44 c8             	cmove  %eax,%ecx
 15108b7:	89 cf                	mov    %ecx,%edi
 15108b9:	83 e7 0f             	and    $0xf,%edi
 15108bc:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
 15108c2:	44 0f b6 c9          	movzbl %cl,%r9d
 15108c6:	0f 94 c0             	sete   %al
 15108c9:	22 84 24 40 01 00 00 	and    0x140(%rsp),%al
 15108d0:	48 83 bc 24 18 01 00 00 00 	cmpq   $0x0,0x118(%rsp)
 15108d9:	41 0f 95 c7          	setne  %r15b
 15108dd:	41 20 c7             	and    %al,%r15b
 15108e0:	41 f6 c0 02          	test   $0x2,%r8b
 15108e4:	74 33                	je     1510919 <tier0_tables_open+0x4fc9>
 15108e6:	80 bc 24 e4 00 00 00 ff 	cmpb   $0xff,0xe4(%rsp)
 15108ee:	49 ba 00 00 00 00 00 00 08 00 	movabs $0x8000000000000,%r10
 15108f8:	b9 00 00 00 00       	mov    $0x0,%ecx
 15108fd:	b8 00 00 00 00       	mov    $0x0,%eax
 1510902:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
 1510907:	41 0f 94 c4          	sete   %r12b
 151090b:	45 84 e3             	test   %r12b,%r11b
 151090e:	0f 84 c3 f5 ff ff    	je     150fed7 <tier0_tables_open+0x4587>
 1510914:	e9 ca f5 ff ff       	jmp    150fee3 <tier0_tables_open+0x4593>
 1510919:	c4 e2 40 f5 44 24 60 	bzhi   %edi,0x60(%rsp),%eax
 1510920:	48 b9 00 00 00 00 00 00 01 00 	movabs $0x1000000000000,%rcx
 151092a:	b8 00 00 00 00       	mov    $0x0,%eax
 151092f:	49 ba 00 00 00 00 00 00 08 00 	movabs $0x8000000000000,%r10
 1510939:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
 151093e:	48 0f 44 c8          	cmove  %rax,%rcx
 1510942:	f6 44 24 70 40       	testb  $0x40,0x70(%rsp)
 1510947:	48 89 c8             	mov    %rcx,%rax
 151094a:	0f 85 93 f5 ff ff    	jne    150fee3 <tier0_tables_open+0x4593>
 1510950:	e9 82 f5 ff ff       	jmp    150fed7 <tier0_tables_open+0x4587>
 1510955:	48 c7 44 24 58 00 00 00 00 	movq   $0x0,0x58(%rsp)
 151095e:	e9 cc 05 00 00       	jmp    1510f2f <tier0_tables_open+0x55df>
 1510963:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 1510968:	89 f2                	mov    %esi,%edx
 151096a:	83 e2 07             	and    $0x7,%edx
 151096d:	48 83 fe 08          	cmp    $0x8,%rsi
 1510971:	73 07                	jae    151097a <tier0_tables_open+0x502a>
 1510973:	31 ff                	xor    %edi,%edi
 1510975:	e9 42 02 00 00       	jmp    1510bbc <tier0_tables_open+0x526c>
 151097a:	8d 34 cd 00 00 00 00 	lea    0x0(,%rcx,8),%esi
 1510981:	8d 3c cd 00 00 00 00 	lea    0x0(,%rcx,8),%edi
 1510988:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
 151098d:	44 8d 24 8d 00 00 00 00 	lea    0x0(,%rcx,4),%r12d
 1510995:	44 8d 2c 49          	lea    (%rcx,%rcx,2),%r13d
 1510999:	8d 2c 09             	lea    (%rcx,%rcx,1),%ebp
 151099c:	41 ba c0 01 00 00    	mov    $0x1c0,%r10d
 15109a2:	45 31 c0             	xor    %r8d,%r8d
 15109a5:	29 ce                	sub    %ecx,%esi
 15109a7:	89 bc 24 80 00 00 00 	mov    %edi,0x80(%rsp)
 15109ae:	8d 3c 09             	lea    (%rcx,%rcx,1),%edi
 15109b1:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 15109b6:	8d 34 7f             	lea    (%rdi,%rdi,2),%esi
 15109b9:	31 ff                	xor    %edi,%edi
 15109bb:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 15109c0:	8d 34 89             	lea    (%rcx,%rcx,4),%esi
 15109c3:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
 15109c7:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
 15109cc:	4d 8b 0e             	mov    (%r14),%r9
 15109cf:	c5 f9 6f 15 39 52 06 ff 	vmovdqa -0xf9adc7(%rip),%xmm2        # 575c10 <x86_effects_unknown+0x1b0>
 15109d7:	c4 e2 79 78 1d e1 fd 00 ff 	vpbroadcastb -0xff021f(%rip),%xmm3        # 5207c1 <branch_sizing_patterns+0xa31>
 15109e0:	62 d2 7d 08 7a c8    	vpbroadcastb %r8d,%xmm1
 15109e6:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
 15109eb:	4d 8d 9a 40 fe ff ff 	lea    -0x1c0(%r10),%r11
 15109f2:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 15109fc:	48 83 c7 08          	add    $0x8,%rdi
 1510a00:	49 21 f3             	and    %rsi,%r11
 1510a03:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 1510a09:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 1510a0d:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 1510a11:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510a16:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 1510a1c:	4d 8d 9a 80 fe ff ff 	lea    -0x180(%r10),%r11
 1510a23:	4d 8b 0e             	mov    (%r14),%r9
 1510a26:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 1510a2c:	46 8d 0c 01          	lea    (%rcx,%r8,1),%r9d
 1510a30:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 1510a36:	4c 8d 4e 40          	lea    0x40(%rsi),%r9
 1510a3a:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 1510a3e:	4d 21 cb             	and    %r9,%r11
 1510a41:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 1510a45:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510a4a:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 1510a50:	46 8d 5c 05 00       	lea    0x0(%rbp,%r8,1),%r11d
 1510a55:	4d 8b 0e             	mov    (%r14),%r9
 1510a58:	62 d2 7d 08 7a cb    	vpbroadcastb %r11d,%xmm1
 1510a5e:	4c 8d 9e 80 00 00 00 	lea    0x80(%rsi),%r11
 1510a65:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 1510a69:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 1510a6d:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 1510a73:	4d 8d 8a c0 fe ff ff 	lea    -0x140(%r10),%r9
 1510a7a:	4d 21 cb             	and    %r9,%r11
 1510a7d:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510a82:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 1510a88:	4d 8d 9a 00 ff ff ff 	lea    -0x100(%r10),%r11
 1510a8f:	4d 8b 0e             	mov    (%r14),%r9
 1510a92:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 1510a98:	47 8d 4c 05 00       	lea    0x0(%r13,%r8,1),%r9d
 1510a9d:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 1510aa3:	4c 8d 8e c0 00 00 00 	lea    0xc0(%rsi),%r9
 1510aaa:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 1510aae:	4d 21 d9             	and    %r11,%r9
 1510ab1:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 1510ab5:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510aba:	c4 81 79 7f 04 0f    	vmovdqa %xmm0,(%r15,%r9,1)
 1510ac0:	4d 8d 8a 40 ff ff ff 	lea    -0xc0(%r10),%r9
 1510ac7:	4d 8b 1e             	mov    (%r14),%r11
 1510aca:	c4 c1 79 6f 04 03    	vmovdqa (%r11,%rax,1),%xmm0
 1510ad0:	4c 8d 9e 00 01 00 00 	lea    0x100(%rsi),%r11
 1510ad7:	4d 21 cb             	and    %r9,%r11
 1510ada:	47 8d 0c 04          	lea    (%r12,%r8,1),%r9d
 1510ade:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 1510ae4:	4d 8d 4a 80          	lea    -0x80(%r10),%r9
 1510ae8:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 1510aec:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 1510af0:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510af5:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 1510afb:	4c 8d 9e 40 01 00 00 	lea    0x140(%rsi),%r11
 1510b02:	4d 21 cb             	and    %r9,%r11
 1510b05:	4d 8b 0e             	mov    (%r14),%r9
 1510b08:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 1510b0e:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 1510b13:	45 01 c1             	add    %r8d,%r9d
 1510b16:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 1510b1c:	4d 8d 4a c0          	lea    -0x40(%r10),%r9
 1510b20:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 1510b24:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 1510b28:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510b2d:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 1510b33:	4d 8b 1e             	mov    (%r14),%r11
 1510b36:	c4 c1 79 6f 04 03    	vmovdqa (%r11,%rax,1),%xmm0
 1510b3c:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
 1510b41:	45 01 c3             	add    %r8d,%r11d
 1510b44:	62 d2 7d 08 7a cb    	vpbroadcastb %r11d,%xmm1
 1510b4a:	4c 8d 9e 80 01 00 00 	lea    0x180(%rsi),%r11
 1510b51:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 1510b55:	4d 21 cb             	and    %r9,%r11
 1510b58:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 1510b5c:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510b61:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 1510b67:	4d 8b 0e             	mov    (%r14),%r9
 1510b6a:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 1510b70:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 1510b75:	45 01 c1             	add    %r8d,%r9d
 1510b78:	44 02 84 24 80 00 00 00 	add    0x80(%rsp),%r8b
 1510b80:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 1510b86:	4c 8d 8e c0 01 00 00 	lea    0x1c0(%rsi),%r9
 1510b8d:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 1510b91:	4d 21 d1             	and    %r10,%r9
 1510b94:	49 81 c2 00 02 00 00 	add    $0x200,%r10
 1510b9b:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 1510b9f:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510ba4:	c4 81 79 7f 04 0f    	vmovdqa %xmm0,(%r15,%r9,1)
 1510baa:	48 39 fb             	cmp    %rdi,%rbx
 1510bad:	0f 85 19 fe ff ff    	jne    15109cc <tier0_tables_open+0x507c>
 1510bb3:	48 85 d2             	test   %rdx,%rdx
 1510bb6:	0f 84 73 03 00 00    	je     1510f2f <tier0_tables_open+0x55df>
 1510bbc:	41 89 c8             	mov    %ecx,%r8d
 1510bbf:	44 0f af c7          	imul   %edi,%r8d
 1510bc3:	48 c1 e7 06          	shl    $0x6,%rdi
 1510bc7:	4d 8b 0e             	mov    (%r14),%r9
 1510bca:	62 d2 7d 08 7a c8    	vpbroadcastb %r8d,%xmm1
 1510bd0:	c5 f1 fc 0d 38 50 06 ff 	vpaddb -0xf9afc8(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 1510bd8:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 1510be2:	41 00 c8             	add    %cl,%r8b
 1510be5:	62 f1 75 18 db 0d d5 f8 06 ff 	vpandd -0xf9072b(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 1510bef:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 1510bf6:	48 21 fe             	and    %rdi,%rsi
 1510bf9:	48 83 c7 40          	add    $0x40,%rdi
 1510bfd:	48 ff ca             	dec    %rdx
 1510c00:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 1510c06:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
 1510c0b:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510c10:	c4 c1 79 7f 04 31    	vmovdqa %xmm0,(%r9,%rsi,1)
 1510c16:	75 af                	jne    1510bc7 <tier0_tables_open+0x5277>
 1510c18:	e9 12 03 00 00       	jmp    1510f2f <tier0_tables_open+0x55df>
 1510c1d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 1510c22:	89 d1                	mov    %edx,%ecx
 1510c24:	83 e1 07             	and    $0x7,%ecx
 1510c27:	48 83 fa 08          	cmp    $0x8,%rdx
 1510c2b:	0f 83 fe 01 00 00    	jae    1510e2f <tier0_tables_open+0x54df>
 1510c31:	31 d2                	xor    %edx,%edx
 1510c33:	e9 c4 02 00 00       	jmp    1510efc <tier0_tables_open+0x55ac>
 1510c38:	4c 8b 4c 24 58       	mov    0x58(%rsp),%r9
 1510c3d:	41 89 cf             	mov    %ecx,%r15d
 1510c40:	41 83 e7 7f          	and    $0x7f,%r15d
 1510c44:	45 31 e4             	xor    %r12d,%r12d
 1510c47:	45 31 ed             	xor    %r13d,%r13d
 1510c4a:	31 ed                	xor    %ebp,%ebp
 1510c4c:	45 31 db             	xor    %r11d,%r11d
 1510c4f:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 1510c58:	45 31 c0             	xor    %r8d,%r8d
 1510c5b:	45 01 ff             	add    %r15d,%r15d
 1510c5e:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
 1510c62:	eb 25                	jmp    1510c89 <tier0_tables_open+0x5339>
 1510c64:	48 8d 14 8d 00 00 00 00 	lea    0x0(,%rcx,4),%rdx
 1510c6c:	49 83 c0 02          	add    $0x2,%r8
 1510c70:	49 83 eb 80          	sub    $0xffffffffffffff80,%r11
 1510c74:	4d 01 fc             	add    %r15,%r12
 1510c77:	49 01 cd             	add    %rcx,%r13
 1510c7a:	49 01 cd             	add    %rcx,%r13
 1510c7d:	48 01 d5             	add    %rdx,%rbp
 1510c80:	4d 39 c1             	cmp    %r8,%r9
 1510c83:	0f 84 03 01 00 00    	je     1510d8c <tier0_tables_open+0x543c>
 1510c89:	49 8b 36             	mov    (%r14),%rsi
 1510c8c:	62 d2 7d 08 7a cc    	vpbroadcastb %r12d,%xmm1
 1510c92:	c5 f1 fc 0d 76 4f 06 ff 	vpaddb -0xf9b08a(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 1510c9a:	48 ba 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rdx
 1510ca4:	62 f1 75 18 db 0d 16 f8 06 ff 	vpandd -0xf907ea(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 1510cae:	4c 8d 92 80 01 00 00 	lea    0x180(%rdx),%r10
 1510cb5:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 1510cba:	4d 21 da             	and    %r11,%r10
 1510cbd:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
 1510cc2:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510cc7:	c4 a1 79 7f 04 12    	vmovdqa %xmm0,(%rdx,%r10,1)
 1510ccd:	49 83 fd 0f          	cmp    $0xf,%r13
 1510cd1:	77 28                	ja     1510cfb <tier0_tables_open+0x53ab>
 1510cd3:	c4 e2 91 f7 54 24 10 	shlx   %r13,0x10(%rsp),%rdx
 1510cda:	48 be 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rsi
 1510ce4:	c4 62 d1 f7 d3       	shlx   %rbp,%rbx,%r10
 1510ce9:	45 89 d2             	mov    %r10d,%r10d
 1510cec:	48 c1 e2 20          	shl    $0x20,%rdx
 1510cf0:	48 21 f2             	and    %rsi,%rdx
 1510cf3:	4c 09 d2             	or     %r10,%rdx
 1510cf6:	48 09 54 24 30       	or     %rdx,0x30(%rsp)
 1510cfb:	49 8b 3e             	mov    (%r14),%rdi
 1510cfe:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 1510d08:	49 8d 53 40          	lea    0x40(%r11),%rdx
 1510d0c:	4c 8d 96 c0 01 00 00 	lea    0x1c0(%rsi),%r10
 1510d13:	42 8d 34 21          	lea    (%rcx,%r12,1),%esi
 1510d17:	62 f2 7d 08 7a ce    	vpbroadcastb %esi,%xmm1
 1510d1d:	c5 f1 fc 0d eb 4e 06 ff 	vpaddb -0xf9b115(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 1510d25:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 1510d2a:	4c 21 d2             	and    %r10,%rdx
 1510d2d:	4e 8d 14 29          	lea    (%rcx,%r13,1),%r10
 1510d31:	62 f1 75 18 db 0d 89 f7 06 ff 	vpandd -0xf90877(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 1510d3b:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 1510d40:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510d45:	c5 f9 7f 04 16       	vmovdqa %xmm0,(%rsi,%rdx,1)
 1510d4a:	49 83 fa 0f          	cmp    $0xf,%r10
 1510d4e:	0f 87 10 ff ff ff    	ja     1510c64 <tier0_tables_open+0x5314>
 1510d54:	c4 e2 a9 f7 7c 24 10 	shlx   %r10,0x10(%rsp),%rdi
 1510d5b:	48 8d 14 09          	lea    (%rcx,%rcx,1),%rdx
 1510d5f:	be 00 00 00 00       	mov    $0x0,%esi
 1510d64:	01 ea                	add    %ebp,%edx
 1510d66:	c4 e2 e9 f7 d3       	shlx   %rdx,%rbx,%rdx
 1510d6b:	83 e2 fe             	and    $0xfffffffe,%edx
 1510d6e:	f6 c1 01             	test   $0x1,%cl
 1510d71:	48 0f 45 d6          	cmovne %rsi,%rdx
 1510d75:	81 e7 fe ff 00 00    	and    $0xfffe,%edi
 1510d7b:	48 c1 e7 20          	shl    $0x20,%rdi
 1510d7f:	48 09 d7             	or     %rdx,%rdi
 1510d82:	48 09 7c 24 30       	or     %rdi,0x30(%rsp)
 1510d87:	e9 d8 fe ff ff       	jmp    1510c64 <tier0_tables_open+0x5314>
 1510d8c:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
 1510d91:	0f 84 8a 00 00 00    	je     1510e21 <tier0_tables_open+0x54d1>
 1510d97:	49 8b 3e             	mov    (%r14),%rdi
 1510d9a:	49 0f af c8          	imul   %r8,%rcx
 1510d9e:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 1510da8:	4c 89 c2             	mov    %r8,%rdx
 1510dab:	48 c1 e2 06          	shl    $0x6,%rdx
 1510daf:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 1510db6:	48 21 d6             	and    %rdx,%rsi
 1510db9:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 1510dbf:	c5 f1 fc 0d 49 4e 06 ff 	vpaddb -0xf9b1b7(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 1510dc7:	62 f1 75 18 db 0d f3 f6 06 ff 	vpandd -0xf9090d(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 1510dd1:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 1510dd6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1510ddb:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 1510de0:	c5 f9 7f 04 30       	vmovdqa %xmm0,(%rax,%rsi,1)
 1510de5:	48 83 f9 0f          	cmp    $0xf,%rcx
 1510de9:	77 36                	ja     1510e21 <tier0_tables_open+0x54d1>
 1510deb:	c4 e2 f1 f7 54 24 10 	shlx   %rcx,0x10(%rsp),%rdx
 1510df2:	89 c8                	mov    %ecx,%eax
 1510df4:	01 c9                	add    %ecx,%ecx
 1510df6:	a8 01                	test   $0x1,%al
 1510df8:	c4 e2 f1 f7 c3       	shlx   %rcx,%rbx,%rax
 1510dfd:	b9 00 00 00 00       	mov    $0x0,%ecx
 1510e02:	89 c0                	mov    %eax,%eax
 1510e04:	48 0f 45 c1          	cmovne %rcx,%rax
 1510e08:	48 b9 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rcx
 1510e12:	48 c1 e2 20          	shl    $0x20,%rdx
 1510e16:	48 21 ca             	and    %rcx,%rdx
 1510e19:	48 09 c2             	or     %rax,%rdx
 1510e1c:	48 09 54 24 30       	or     %rdx,0x30(%rsp)
 1510e21:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 1510e2a:	e9 12 01 00 00       	jmp    1510f41 <tier0_tables_open+0x55f1>
 1510e2f:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 1510e34:	45 31 c0             	xor    %r8d,%r8d
 1510e37:	31 d2                	xor    %edx,%edx
 1510e39:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 1510e3d:	4d 8b 16             	mov    (%r14),%r10
 1510e40:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 1510e4a:	4d 89 c1             	mov    %r8,%r9
 1510e4d:	48 83 c2 08          	add    $0x8,%rdx
 1510e51:	49 81 c0 00 02 00 00 	add    $0x200,%r8
 1510e58:	49 21 f1             	and    %rsi,%r9
 1510e5b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 1510e60:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 1510e66:	c4 a1 78 29 04 0e    	vmovaps %xmm0,(%rsi,%r9,1)
 1510e6c:	4d 8b 16             	mov    (%r14),%r10
 1510e6f:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 1510e75:	c4 a1 78 29 44 0e 40 	vmovaps %xmm0,0x40(%rsi,%r9,1)
 1510e7c:	4d 8b 16             	mov    (%r14),%r10
 1510e7f:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 1510e85:	c4 a1 78 29 84 0e 80 00 00 00 	vmovaps %xmm0,0x80(%rsi,%r9,1)
 1510e8f:	4d 8b 16             	mov    (%r14),%r10
 1510e92:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 1510e98:	c4 a1 78 29 84 0e c0 00 00 00 	vmovaps %xmm0,0xc0(%rsi,%r9,1)
 1510ea2:	4d 8b 16             	mov    (%r14),%r10
 1510ea5:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 1510eab:	c4 a1 78 29 84 0e 00 01 00 00 	vmovaps %xmm0,0x100(%rsi,%r9,1)
 1510eb5:	4d 8b 16             	mov    (%r14),%r10
 1510eb8:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 1510ebe:	c4 a1 78 29 84 0e 40 01 00 00 	vmovaps %xmm0,0x140(%rsi,%r9,1)
 1510ec8:	4d 8b 16             	mov    (%r14),%r10
 1510ecb:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 1510ed1:	c4 a1 78 29 84 0e 80 01 00 00 	vmovaps %xmm0,0x180(%rsi,%r9,1)
 1510edb:	4d 8b 16             	mov    (%r14),%r10
 1510ede:	c4 c1 79 6f 04 02    	vmovdqa (%r10,%rax,1),%xmm0
 1510ee4:	c4 a1 79 7f 84 0e c0 01 00 00 	vmovdqa %xmm0,0x1c0(%rsi,%r9,1)
 1510eee:	48 39 d7             	cmp    %rdx,%rdi
 1510ef1:	0f 85 46 ff ff ff    	jne    1510e3d <tier0_tables_open+0x54ed>
 1510ef7:	48 85 c9             	test   %rcx,%rcx
 1510efa:	74 33                	je     1510f2f <tier0_tables_open+0x55df>
 1510efc:	48 c1 e2 06          	shl    $0x6,%rdx
 1510f00:	49 8b 3e             	mov    (%r14),%rdi
 1510f03:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 1510f0d:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 1510f14:	48 21 d6             	and    %rdx,%rsi
 1510f17:	48 83 c2 40          	add    $0x40,%rdx
 1510f1b:	48 ff c9             	dec    %rcx
 1510f1e:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 1510f23:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 1510f28:	c5 f9 7f 04 37       	vmovdqa %xmm0,(%rdi,%rsi,1)
 1510f2d:	75 d1                	jne    1510f00 <tier0_tables_open+0x55b0>
 1510f2f:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 1510f38:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 1510f41:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 1510f46:	3b 44 24 68          	cmp    0x68(%rsp),%eax
 1510f4a:	0f 83 c2 00 00 00    	jae    1511012 <tier0_tables_open+0x56c2>
 1510f50:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 1510f55:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 1510f5a:	29 d1                	sub    %edx,%ecx
 1510f5c:	89 d0                	mov    %edx,%eax
 1510f5e:	48 89 c2             	mov    %rax,%rdx
 1510f61:	83 e1 07             	and    $0x7,%ecx
 1510f64:	74 3b                	je     1510fa1 <tier0_tables_open+0x5651>
 1510f66:	48 89 c2             	mov    %rax,%rdx
 1510f69:	48 c1 e2 06          	shl    $0x6,%rdx
 1510f6d:	48 03 94 24 88 01 00 00 	add    0x188(%rsp),%rdx
 1510f75:	48 f7 d9             	neg    %rcx
 1510f78:	31 ff                	xor    %edi,%edi
 1510f7a:	48 03 94 24 80 01 00 00 	add    0x180(%rsp),%rdx
 1510f82:	c4 e2 79 59 05 75 f1 06 ff 	vpbroadcastq -0xf90e8b(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 1510f8b:	48 ff cf             	dec    %rdi
 1510f8e:	c5 f9 7f 02          	vmovdqa %xmm0,(%rdx)
 1510f92:	48 83 c2 40          	add    $0x40,%rdx
 1510f96:	48 39 f9             	cmp    %rdi,%rcx
 1510f99:	75 e7                	jne    1510f82 <tier0_tables_open+0x5632>
 1510f9b:	48 89 c2             	mov    %rax,%rdx
 1510f9e:	48 29 fa             	sub    %rdi,%rdx
 1510fa1:	48 2b 44 24 68       	sub    0x68(%rsp),%rax
 1510fa6:	48 83 f8 f8          	cmp    $0xfffffffffffffff8,%rax
 1510faa:	77 66                	ja     1511012 <tier0_tables_open+0x56c2>
 1510fac:	48 8b 84 24 88 01 00 00 	mov    0x188(%rsp),%rax
 1510fb4:	48 29 54 24 68       	sub    %rdx,0x68(%rsp)
 1510fb9:	48 c1 e2 06          	shl    $0x6,%rdx
 1510fbd:	48 03 84 24 78 01 00 00 	add    0x178(%rsp),%rax
 1510fc5:	48 01 d0             	add    %rdx,%rax
 1510fc8:	c4 e2 79 59 05 2f f1 06 ff 	vpbroadcastq -0xf90ed1(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 1510fd1:	c5 f9 7f 80 00 ff ff ff 	vmovdqa %xmm0,-0x100(%rax)
 1510fd9:	c5 f9 7f 80 40 ff ff ff 	vmovdqa %xmm0,-0xc0(%rax)
 1510fe1:	c5 f9 7f 40 80       	vmovdqa %xmm0,-0x80(%rax)
 1510fe6:	c5 f9 7f 40 c0       	vmovdqa %xmm0,-0x40(%rax)
 1510feb:	c5 f9 7f 00          	vmovdqa %xmm0,(%rax)
 1510fef:	c5 f9 7f 40 40       	vmovdqa %xmm0,0x40(%rax)
 1510ff4:	c5 f9 7f 80 80 00 00 00 	vmovdqa %xmm0,0x80(%rax)
 1510ffc:	c5 f9 7f 80 c0 00 00 00 	vmovdqa %xmm0,0xc0(%rax)
 1511004:	48 05 00 02 00 00    	add    $0x200,%rax
 151100a:	48 83 44 24 68 f8    	addq   $0xfffffffffffffff8,0x68(%rsp)
 1511010:	75 b6                	jne    1510fc8 <tier0_tables_open+0x5678>
 1511012:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 151101a:	0f 84 29 ec ff ff    	je     150fc49 <tier0_tables_open+0x42f9>
 1511020:	48 8b 0c 24          	mov    (%rsp),%rcx
 1511024:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 151102c:	48 8b 01             	mov    (%rcx),%rax
 151102f:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 1511033:	0f b6 34 10          	movzbl (%rax,%rdx,1),%esi
 1511037:	48 8b 0c d1          	mov    (%rcx,%rdx,8),%rcx
 151103b:	40 80 fe 11          	cmp    $0x11,%sil
 151103f:	75 52                	jne    1511093 <tier0_tables_open+0x5743>
 1511041:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
 1511046:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 151104b:	4c 8d 42 01          	lea    0x1(%rdx),%r8
 151104f:	48 89 f8             	mov    %rdi,%rax
 1511052:	48 c1 e8 3c          	shr    $0x3c,%rax
 1511056:	49 21 f8             	and    %rdi,%r8
 1511059:	c4 e2 78 f5 d1       	bzhi   %eax,%ecx,%edx
 151105e:	ba 00 00 00 00       	mov    $0x0,%edx
 1511063:	0f 44 d0             	cmove  %eax,%edx
 1511066:	b8 37 05 00 00       	mov    $0x537,%eax
 151106b:	c4 e2 f8 f7 c7       	bextr  %rax,%rdi,%rax
 1511070:	bf 10 00 00 00       	mov    $0x10,%edi
 1511075:	48 83 f8 10          	cmp    $0x10,%rax
 1511079:	48 0f 43 c7          	cmovae %rdi,%rax
 151107d:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 1511084:	c4 e2 f9 f7 ff       	shlx   %rax,%rdi,%rdi
 1511089:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 151108e:	48 f7 d7             	not    %rdi
 1511091:	eb 5f                	jmp    15110f2 <tier0_tables_open+0x57a2>
 1511093:	48 b8 00 00 00 00 00 00 01 00 	movabs $0x1000000000000,%rax
 151109d:	31 d2                	xor    %edx,%edx
 151109f:	48 85 44 24 50       	test   %rax,0x50(%rsp)
 15110a4:	75 23                	jne    15110c9 <tier0_tables_open+0x5779>
 15110a6:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 15110ab:	48 c1 e8 20          	shr    $0x20,%rax
 15110af:	83 c8 01             	or     $0x1,%eax
 15110b2:	0f b7 c0             	movzwl %ax,%eax
 15110b5:	f3 0f bd d0          	lzcnt  %eax,%edx
 15110b9:	83 f2 1f             	xor    $0x1f,%edx
 15110bc:	c4 e2 68 f5 c1       	bzhi   %edx,%ecx,%eax
 15110c1:	b8 00 00 00 00       	mov    $0x0,%eax
 15110c6:	0f 45 d0             	cmovne %eax,%edx
 15110c9:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
 15110ce:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 15110d3:	48 b8 00 00 00 00 00 00 02 00 	movabs $0x2000000000000,%rax
 15110dd:	4d 89 d0             	mov    %r10,%r8
 15110e0:	4c 89 cf             	mov    %r9,%rdi
 15110e3:	49 21 c0             	and    %rax,%r8
 15110e6:	48 c1 ef 30          	shr    $0x30,%rdi
 15110ea:	4c 89 d0             	mov    %r10,%rax
 15110ed:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
 15110f2:	45 31 c9             	xor    %r9d,%r9d
 15110f5:	4d 85 c0             	test   %r8,%r8
 15110f8:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 15110fe:	49 bb 00 00 00 00 00 00 04 00 	movabs $0x4000000000000,%r11
 1511108:	41 0f 95 c2          	setne  %r10b
 151110c:	48 83 f9 10          	cmp    $0x10,%rcx
 1511110:	49 0f 43 c8          	cmovae %r8,%rcx
 1511114:	45 31 c0             	xor    %r8d,%r8d
 1511117:	4c 85 d8             	test   %r11,%rax
 151111a:	41 0f 94 c3          	sete   %r11b
 151111e:	40 80 fe 08          	cmp    $0x8,%sil
 1511122:	0f 84 d3 ea ff ff    	je     150fbfb <tier0_tables_open+0x42ab>
 1511128:	45 88 d1             	mov    %r10b,%r9b
 151112b:	45 88 d8             	mov    %r11b,%r8b
 151112e:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 1511133:	48 c1 e8 2d          	shr    $0x2d,%rax
 1511137:	8b 74 24 50          	mov    0x50(%rsp),%esi
 151113b:	41 c1 e1 04          	shl    $0x4,%r9d
 151113f:	41 c1 e0 05          	shl    $0x5,%r8d
 1511143:	c4 e2 71 f7 cd       	shlx   %ecx,%ebp,%ecx
 1511148:	83 e0 40             	and    $0x40,%eax
 151114b:	45 09 c8             	or     %r9d,%r8d
 151114e:	09 cf                	or     %ecx,%edi
 1511150:	b9 55 55 00 00       	mov    $0x5555,%ecx
 1511155:	41 09 d0             	or     %edx,%r8d
 1511158:	f7 d7                	not    %edi
 151115a:	48 ba 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rdx
 1511164:	44 09 c0             	or     %r8d,%eax
 1511167:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 151116c:	c4 e2 42 f5 c9       	pext   %ecx,%edi,%ecx
 1511171:	bf 11 11 11 11       	mov    $0x11111111,%edi
 1511176:	c4 e2 73 f5 cf       	pdep   %edi,%ecx,%ecx
 151117b:	49 21 d0             	and    %rdx,%r8
 151117e:	49 09 f0             	or     %rsi,%r8
 1511181:	49 09 c8             	or     %rcx,%r8
 1511184:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
 1511189:	e9 95 ea ff ff       	jmp    150fc23 <tier0_tables_open+0x42d3>
 151118e:	48 83 bc 24 e8 00 00 00 00 	cmpq   $0x0,0xe8(%rsp)
 1511197:	0f 84 62 e9 ff ff    	je     150faff <tier0_tables_open+0x41af>
 151119d:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 15111a5:	0f 84 79 04 00 00    	je     1511624 <tier0_tables_open+0x5cd4>
 15111ab:	48 8b 04 24          	mov    (%rsp),%rax
 15111af:	31 c9                	xor    %ecx,%ecx
 15111b1:	48 05 00 02 00 00    	add    $0x200,%rax
 15111b7:	62 f1 fd 48 6f 00    	vmovdqa64 (%rax),%zmm0
 15111bd:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 15111c5:	48 05 c0 01 00 00    	add    $0x1c0,%rax
 15111cb:	eb 11                	jmp    15111de <tier0_tables_open+0x588e>
 15111cd:	48 ff c1             	inc    %rcx
 15111d0:	48 3b 8c 24 50 01 00 00 	cmp    0x150(%rsp),%rcx
 15111d8:	0f 84 46 04 00 00    	je     1511624 <tier0_tables_open+0x5cd4>
 15111de:	4c 8b 94 24 20 01 00 00 	mov    0x120(%rsp),%r10
 15111e6:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
 15111ea:	62 f2 fd 48 59 0d 0c ef 06 ff 	vpbroadcastq -0xf910f4(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 15111f4:	49 c1 e1 04          	shl    $0x4,%r9
 15111f8:	47 8b 04 0a          	mov    (%r10,%r9,1),%r8d
 15111fc:	43 8b 7c 0a 04       	mov    0x4(%r10,%r9,1),%edi
 1511201:	43 8b 74 0a 08       	mov    0x8(%r10,%r9,1),%esi
 1511206:	43 8b 54 0a 0c       	mov    0xc(%r10,%r9,1),%edx
 151120b:	4f 8b 5c 0a 10       	mov    0x10(%r10,%r9,1),%r11
 1511210:	47 8b 7c 0a 18       	mov    0x18(%r10,%r9,1),%r15d
 1511215:	c4 81 f8 90 4c 0a 20 	kmovq  0x20(%r10,%r9,1),%k1
 151121c:	c4 81 f8 90 44 0a 28 	kmovq  0x28(%r10,%r9,1),%k0
 1511223:	4d 85 ff             	test   %r15,%r15
 1511226:	0f 84 e6 02 00 00    	je     1511512 <tier0_tables_open+0x5bc2>
 151122c:	45 89 f9             	mov    %r15d,%r9d
 151122f:	49 c1 e3 06          	shl    $0x6,%r11
 1511233:	41 83 e1 07          	and    $0x7,%r9d
 1511237:	41 83 ff 08          	cmp    $0x8,%r15d
 151123b:	73 12                	jae    151124f <tier0_tables_open+0x58ff>
 151123d:	62 f2 fd 48 59 0d b9 ee 06 ff 	vpbroadcastq -0xf91147(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 1511247:	45 31 d2             	xor    %r10d,%r10d
 151124a:	e9 57 02 00 00       	jmp    15114a6 <tier0_tables_open+0x5b56>
 151124f:	62 f2 fd 48 59 0d a7 ee 06 ff 	vpbroadcastq -0xf91159(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 1511259:	41 83 e7 f8          	and    $0xfffffff8,%r15d
 151125d:	4e 8d 24 18          	lea    (%rax,%r11,1),%r12
 1511261:	45 31 d2             	xor    %r10d,%r10d
 1511264:	62 d1 fd 48 6f 5c 24 f9 	vmovdqa64 -0x1c0(%r12),%zmm3
 151126c:	62 f2 7d 48 58 3d 42 f2 06 ff 	vpbroadcastd -0xf90dbe(%rip),%zmm7        # 5804b8 <tier0_emit_x87.operations+0x70>
 1511276:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 151127d:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 1511284:	62 d1 fd 48 6f 64 24 fa 	vmovdqa64 -0x180(%r12),%zmm4
 151128c:	62 d1 fd 48 6f 6c 24 fb 	vmovdqa64 -0x140(%r12),%zmm5
 1511294:	62 d1 fd 48 6f 74 24 fc 	vmovdqa64 -0x100(%r12),%zmm6
 151129c:	49 83 c2 08          	add    $0x8,%r10
 15112a0:	62 f3 65 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm3,%zmm2
 15112a7:	62 f1 65 48 71 d3 04 	vpsrlw $0x4,%zmm3,%zmm3
 15112ae:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 15112b5:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 15112bb:	62 f2 65 48 8d d0    	vpermb %zmm0,%zmm3,%zmm2
 15112c1:	62 f1 65 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm3
 15112c8:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 15112cf:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 15112d5:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 15112dc:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 15112e3:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 15112ea:	62 f3 5d 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm2
 15112f1:	62 f2 65 48 8d d8    	vpermb %zmm0,%zmm3,%zmm3
 15112f7:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 15112fd:	62 f1 6d 48 71 f3 04 	vpsllw $0x4,%zmm3,%zmm2
 1511304:	62 f1 65 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm3
 151130b:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 1511311:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 1511318:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 151131f:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 1511326:	62 f3 55 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm2
 151132d:	62 d1 fd 48 6f 6c 24 fd 	vmovdqa64 -0xc0(%r12),%zmm5
 1511335:	62 f2 65 48 8d e0    	vpermb %zmm0,%zmm3,%zmm4
 151133b:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 1511341:	62 f1 65 48 71 d6 04 	vpsrlw $0x4,%zmm6,%zmm3
 1511348:	62 f1 6d 48 71 f4 04 	vpsllw $0x4,%zmm4,%zmm2
 151134f:	62 d1 fd 48 6f 64 24 fe 	vmovdqa64 -0x80(%r12),%zmm4
 1511357:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 151135d:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 1511364:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 151136b:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 1511372:	62 f3 4d 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm6,%zmm2
 1511379:	62 f2 65 48 8d d8    	vpermb %zmm0,%zmm3,%zmm3
 151137f:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 1511385:	62 f1 6d 48 71 f3 04 	vpsllw $0x4,%zmm3,%zmm2
 151138c:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 1511392:	62 f1 6d 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm2
 1511399:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 15113a0:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 15113a7:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 15113ae:	62 f3 55 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm3
 15113b5:	62 d1 fd 48 6f 6c 24 ff 	vmovdqa64 -0x40(%r12),%zmm5
 15113bd:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 15113c3:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 15113c9:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 15113d0:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 15113d6:	62 f1 6d 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm2
 15113dd:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 15113e4:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 15113eb:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 15113f2:	62 f3 5d 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm3
 15113f9:	62 d1 fd 48 6f 24 24 	vmovdqa64 (%r12),%zmm4
 1511400:	49 81 c4 00 02 00 00 	add    $0x200,%r12
 1511407:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 151140d:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 1511413:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 151141a:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 1511420:	62 f1 6d 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm2
 1511427:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 151142e:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 1511435:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 151143c:	62 f3 55 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm3
 1511443:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 1511449:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 151144f:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 1511456:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 151145c:	62 f1 6d 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm2
 1511463:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 151146a:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 1511471:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 1511478:	62 f3 5d 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm3
 151147f:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 1511485:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 151148b:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 1511492:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 1511498:	4d 39 d7             	cmp    %r10,%r15
 151149b:	0f 85 c3 fd ff ff    	jne    1511264 <tier0_tables_open+0x5914>
 15114a1:	4d 85 c9             	test   %r9,%r9
 15114a4:	74 6c                	je     1511512 <tier0_tables_open+0x5bc2>
 15114a6:	49 c1 e2 06          	shl    $0x6,%r10
 15114aa:	4c 03 94 24 e8 00 00 00 	add    0xe8(%rsp),%r10
 15114b2:	41 c1 e1 06          	shl    $0x6,%r9d
 15114b6:	4d 01 da             	add    %r11,%r10
 15114b9:	45 31 db             	xor    %r11d,%r11d
 15114bc:	62 91 fd 48 6f 14 1a 	vmovdqa64 (%r10,%r11,1),%zmm2
 15114c3:	62 f2 7d 48 58 25 eb ef 06 ff 	vpbroadcastd -0xf91015(%rip),%zmm4        # 5804b8 <tier0_emit_x87.operations+0x70>
 15114cd:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 15114d4:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 15114db:	49 83 c3 40          	add    $0x40,%r11
 15114df:	62 f3 6d 48 25 dc e4 	vpternlogd $0xe4,%zmm4,%zmm2,%zmm3
 15114e6:	62 f1 6d 48 71 d2 04 	vpsrlw $0x4,%zmm2,%zmm2
 15114ed:	62 f3 75 48 25 d4 d8 	vpternlogd $0xd8,%zmm4,%zmm1,%zmm2
 15114f4:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 15114fa:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 1511500:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 1511507:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 151150d:	4d 39 d9             	cmp    %r11,%r9
 1511510:	75 aa                	jne    15114bc <tier0_tables_open+0x5b6c>
 1511512:	62 f2 7d 48 5a 25 a4 47 06 ff 	vbroadcasti32x4 -0xf9b85c(%rip),%zmm4        # 575cc0 <x86_effects_unknown+0x260>
 151151c:	62 f1 f5 58 db 1d e2 eb 06 ff 	vpandq -0xf9141e(%rip){1to8},%zmm1,%zmm3        # 580108 <x86_semantics_benchmark_code.registers+0x118>
 1511526:	62 f1 6d 48 71 d1 04 	vpsrlw $0x4,%zmm1,%zmm2
 151152d:	62 f3 65 48 3f 1d 88 f1 00 ff 04 	vpcmpneqb -0xff0e78(%rip),%zmm3,%k3        # 5206c0 <branch_sizing_patterns+0x930>
 1511538:	62 f1 ed 48 db d4    	vpandq %zmm4,%zmm2,%zmm2
 151153e:	62 f1 6d 48 74 15 38 f1 00 ff 	vpcmpeqb -0xff0ec8(%rip),%zmm2,%k2        # 520680 <branch_sizing_patterns+0x8f0>
 1511548:	62 f1 65 48 74 e4    	vpcmpeqb %zmm4,%zmm3,%k4
 151154e:	62 f1 6d 4b 74 1d a8 f1 00 ff 	vpcmpeqb -0xff0e58(%rip),%zmm2,%k3{%k3}        # 520700 <branch_sizing_patterns+0x970>
 1511558:	62 f1 6d 48 74 ec    	vpcmpeqb %zmm4,%zmm2,%k5
 151155e:	62 f2 7d 48 5a 25 68 47 06 ff 	vbroadcasti32x4 -0xf9b898(%rip),%zmm4        # 575cd0 <x86_effects_unknown+0x270>
 1511568:	62 f1 65 58 eb 15 5a ef 06 ff 	vpord  -0xf910a6(%rip){1to16},%zmm3,%zmm2        # 5804cc <tier0_emit_x87.operations+0x84>
 1511572:	c4 e1 dc 45 e5       	korq   %k5,%k4,%k4
 1511577:	c4 e1 dc 45 db       	korq   %k3,%k4,%k3
 151157c:	c4 e1 f4 45 cb       	korq   %k3,%k1,%k1
 1511581:	62 f1 65 4a 74 dc    	vpcmpeqb %zmm4,%zmm3,%k3{%k2}
 1511587:	62 f3 65 4a 3f d4 04 	vpcmpneqb %zmm4,%zmm3,%k2{%k2}
 151158e:	c4 e1 f8 44 db       	knotq  %k3,%k3
 1511593:	62 f1 7f 4a 6f ca    	vmovdqu8 %zmm2,%zmm1{%k2}
 1511599:	c4 e1 fc 41 c3       	kandq  %k3,%k0,%k0
 151159e:	c4 e1 f4 45 c8       	korq   %k0,%k1,%k1
 15115a3:	62 f1 7f 49 6f 0d d3 f1 00 ff 	vmovdqu8 -0xff0e2d(%rip),%zmm1{%k1}        # 520780 <branch_sizing_patterns+0x9f0>
 15115ad:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 15115b1:	74 0d                	je     15115c0 <tier0_tables_open+0x5c70>
 15115b3:	4d 8b 0e             	mov    (%r14),%r9
 15115b6:	49 c1 e0 04          	shl    $0x4,%r8
 15115ba:	c4 81 7a 7f 0c 01    	vmovdqu %xmm1,(%r9,%r8,1)
 15115c0:	83 ff ff             	cmp    $0xffffffff,%edi
 15115c3:	74 0f                	je     15115d4 <tier0_tables_open+0x5c84>
 15115c5:	4d 8b 06             	mov    (%r14),%r8
 15115c8:	48 c1 e7 04          	shl    $0x4,%rdi
 15115cc:	62 d3 7d 48 39 0c 38 01 	vextracti32x4 $0x1,%zmm1,(%r8,%rdi,1)
 15115d4:	83 fe ff             	cmp    $0xffffffff,%esi
 15115d7:	74 0f                	je     15115e8 <tier0_tables_open+0x5c98>
 15115d9:	49 8b 3e             	mov    (%r14),%rdi
 15115dc:	48 c1 e6 04          	shl    $0x4,%rsi
 15115e0:	62 f3 7d 48 39 0c 37 02 	vextracti32x4 $0x2,%zmm1,(%rdi,%rsi,1)
 15115e8:	83 fa ff             	cmp    $0xffffffff,%edx
 15115eb:	0f 84 dc fb ff ff    	je     15111cd <tier0_tables_open+0x587d>
 15115f1:	49 8b 36             	mov    (%r14),%rsi
 15115f4:	48 c1 e2 04          	shl    $0x4,%rdx
 15115f8:	62 f3 7d 48 39 0c 16 03 	vextracti32x4 $0x3,%zmm1,(%rsi,%rdx,1)
 1511600:	e9 c8 fb ff ff       	jmp    15111cd <tier0_tables_open+0x587d>
 1511605:	48 8b 34 24          	mov    (%rsp),%rsi
 1511609:	4c 89 f7             	mov    %r14,%rdi
 151160c:	c5 f8 77             	vzeroupper
 151160f:	e8 7c ec 00 00       	call   1520290 <abi_finish>
 1511614:	48 83 44 24 78 0c    	addq   $0xc,0x78(%rsp)
 151161a:	48 ff 8c 24 98 00 00 00 	decq   0x98(%rsp)
 1511622:	74 2c                	je     1511650 <tier0_tables_open+0x5d00>
 1511624:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 1511629:	8b 10                	mov    (%rax),%edx
 151162b:	80 78 0b 01          	cmpb   $0x1,0xb(%rax)
 151162f:	75 d4                	jne    1511605 <tier0_tables_open+0x5cb5>
 1511631:	48 8b 34 24          	mov    (%rsp),%rsi
 1511635:	4c 89 f7             	mov    %r14,%rdi
 1511638:	c5 f8 77             	vzeroupper
 151163b:	e8 c0 f9 00 00       	call   1521000 <abi_finish_passing>
 1511640:	48 83 44 24 78 0c    	addq   $0xc,0x78(%rsp)
 1511646:	48 ff 8c 24 98 00 00 00 	decq   0x98(%rsp)
 151164e:	75 d4                	jne    1511624 <tier0_tables_open+0x5cd4>
 1511650:	b1 01                	mov    $0x1,%cl
 1511652:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 151165b:	48 39 84 24 c0 00 00 00 	cmp    %rax,0xc0(%rsp)
 1511663:	0f 87 99 00 00 00    	ja     1511702 <tier0_tables_open+0x5db2>
 1511669:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 1511671:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 151167a:	84 c9                	test   %cl,%cl
 151167c:	75 1e                	jne    151169c <tier0_tables_open+0x5d4c>
 151167e:	48 8b 34 24          	mov    (%rsp),%rsi
 1511682:	48 8b 94 24 60 01 00 00 	mov    0x160(%rsp),%rdx
 151168a:	8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%ecx
 1511691:	4c 89 f7             	mov    %r14,%rdi
 1511694:	c5 f8 77             	vzeroupper
 1511697:	e8 64 13 01 00       	call   1522a00 <abi_classify_scalar>
 151169c:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 15116a1:	74 0e                	je     15116b1 <tier0_tables_open+0x5d61>
 15116a3:	83 bc 24 a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsp)
 15116ab:	0f 85 c9 d5 ff ff    	jne    150ec7a <tier0_tables_open+0x332a>
 15116b1:	48 8b 84 24 58 01 00 00 	mov    0x158(%rsp),%rax
 15116b9:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 15116c2:	77 3e                	ja     1511702 <tier0_tables_open+0x5db2>
 15116c4:	48 8b 84 24 58 01 00 00 	mov    0x158(%rsp),%rax
 15116cc:	48 8b 0c 24          	mov    (%rsp),%rcx
 15116d0:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 15116d9:	8b b1 60 1f 00 00    	mov    0x1f60(%rcx),%esi
 15116df:	48 85 f6             	test   %rsi,%rsi
 15116e2:	74 40                	je     1511724 <tier0_tables_open+0x5dd4>
 15116e4:	48 8b 04 24          	mov    (%rsp),%rax
 15116e8:	89 f2                	mov    %esi,%edx
 15116ea:	83 e2 03             	and    $0x3,%edx
 15116ed:	48 8b 88 b0 01 00 00 	mov    0x1b0(%rax),%rcx
 15116f4:	83 fe 04             	cmp    $0x4,%esi
 15116f7:	73 32                	jae    151172b <tier0_tables_open+0x5ddb>
 15116f9:	b0 01                	mov    $0x1,%al
 15116fb:	31 ff                	xor    %edi,%edi
 15116fd:	e9 8b 01 00 00       	jmp    151188d <tier0_tables_open+0x5f3d>
 1511702:	48 8d 3d ee e8 1b ff 	lea    -0xe41712(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 1511709:	48 8d 35 83 60 17 ff 	lea    -0xe89f7d(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 1511710:	48 8d 0d 97 60 17 ff 	lea    -0xe89f69(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 1511717:	ba bf 00 00 00       	mov    $0xbf,%edx
 151171c:	c5 f8 77             	vzeroupper
 151171f:	e8 2c 24 25 ff       	call   763b50 <__assert_fail@plt>
 1511724:	b0 01                	mov    $0x1,%al
 1511726:	e9 56 b7 ff ff       	jmp    150ce81 <tier0_tables_open+0x1531>
 151172b:	48 8b 04 24          	mov    (%rsp),%rax
 151172f:	83 e6 fc             	and    $0xfffffffc,%esi
 1511732:	31 ff                	xor    %edi,%edi
 1511734:	4c 8d 80 28 04 00 00 	lea    0x428(%rax),%r8
 151173b:	b0 01                	mov    $0x1,%al
 151173d:	45 8b 88 a0 fe ff ff 	mov    -0x160(%r8),%r9d
 1511744:	45 89 ca             	mov    %r9d,%r10d
 1511747:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 151174b:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 151174f:	4d 89 90 a4 fe ff ff 	mov    %r10,-0x15c(%r8)
 1511756:	3c 01                	cmp    $0x1,%al
 1511758:	75 19                	jne    1511773 <tier0_tables_open+0x5e23>
 151175a:	48 8b 04 24          	mov    (%rsp),%rax
 151175e:	41 c1 e9 03          	shr    $0x3,%r9d
 1511762:	48 8b 80 88 01 00 00 	mov    0x188(%rax),%rax
 1511769:	46 8b 0c 88          	mov    (%rax,%r9,4),%r9d
 151176d:	66 45 85 c9          	test   %r9w,%r9w
 1511771:	78 49                	js     15117bc <tier0_tables_open+0x5e6c>
 1511773:	41 8b 80 14 ff ff ff 	mov    -0xec(%r8),%eax
 151177a:	83 e0 f8             	and    $0xfffffff8,%eax
 151177d:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 1511781:	49 89 80 18 ff ff ff 	mov    %rax,-0xe8(%r8)
 1511788:	41 8b 40 88          	mov    -0x78(%r8),%eax
 151178c:	83 e0 f8             	and    $0xfffffff8,%eax
 151178f:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 1511793:	49 89 40 8c          	mov    %rax,-0x74(%r8)
 1511797:	41 8b 40 fc          	mov    -0x4(%r8),%eax
 151179b:	83 e0 f8             	and    $0xfffffff8,%eax
 151179e:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 15117a2:	49 89 00             	mov    %rax,(%r8)
 15117a5:	31 c0                	xor    %eax,%eax
 15117a7:	48 83 c7 04          	add    $0x4,%rdi
 15117ab:	49 81 c0 d0 01 00 00 	add    $0x1d0,%r8
 15117b2:	48 39 fe             	cmp    %rdi,%rsi
 15117b5:	75 86                	jne    151173d <tier0_tables_open+0x5ded>
 15117b7:	e9 c8 00 00 00       	jmp    1511884 <tier0_tables_open+0x5f34>
 15117bc:	41 8b 80 14 ff ff ff 	mov    -0xec(%r8),%eax
 15117c3:	41 89 c2             	mov    %eax,%r10d
 15117c6:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 15117ca:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 15117ce:	4d 89 90 18 ff ff ff 	mov    %r10,-0xe8(%r8)
 15117d5:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 15117dc:	75 aa                	jne    1511788 <tier0_tables_open+0x5e38>
 15117de:	4c 8b 0c 24          	mov    (%rsp),%r9
 15117e2:	c1 e8 03             	shr    $0x3,%eax
 15117e5:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 15117ec:	45 8b 0c 81          	mov    (%r9,%rax,4),%r9d
 15117f0:	66 45 85 c9          	test   %r9w,%r9w
 15117f4:	79 92                	jns    1511788 <tier0_tables_open+0x5e38>
 15117f6:	41 8b 40 88          	mov    -0x78(%r8),%eax
 15117fa:	41 89 c2             	mov    %eax,%r10d
 15117fd:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 1511801:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 1511805:	4d 89 50 8c          	mov    %r10,-0x74(%r8)
 1511809:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 1511810:	75 85                	jne    1511797 <tier0_tables_open+0x5e47>
 1511812:	4c 8b 0c 24          	mov    (%rsp),%r9
 1511816:	c1 e8 03             	shr    $0x3,%eax
 1511819:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 1511820:	45 8b 0c 81          	mov    (%r9,%rax,4),%r9d
 1511824:	66 45 85 c9          	test   %r9w,%r9w
 1511828:	0f 89 69 ff ff ff    	jns    1511797 <tier0_tables_open+0x5e47>
 151182e:	41 8b 40 fc          	mov    -0x4(%r8),%eax
 1511832:	41 89 c2             	mov    %eax,%r10d
 1511835:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 1511839:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 151183d:	4d 89 10             	mov    %r10,(%r8)
 1511840:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 1511847:	0f 85 58 ff ff ff    	jne    15117a5 <tier0_tables_open+0x5e55>
 151184d:	4c 8b 0c 24          	mov    (%rsp),%r9
 1511851:	c1 e8 03             	shr    $0x3,%eax
 1511854:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 151185b:	41 8b 04 81          	mov    (%r9,%rax,4),%eax
 151185f:	66 85 c0             	test   %ax,%ax
 1511862:	0f 89 3d ff ff ff    	jns    15117a5 <tier0_tables_open+0x5e55>
 1511868:	a9 00 40 00 00       	test   $0x4000,%eax
 151186d:	0f 94 c0             	sete   %al
 1511870:	48 83 c7 04          	add    $0x4,%rdi
 1511874:	49 81 c0 d0 01 00 00 	add    $0x1d0,%r8
 151187b:	48 39 fe             	cmp    %rdi,%rsi
 151187e:	0f 85 b9 fe ff ff    	jne    151173d <tier0_tables_open+0x5ded>
 1511884:	48 85 d2             	test   %rdx,%rdx
 1511887:	0f 84 f4 b5 ff ff    	je     150ce81 <tier0_tables_open+0x1531>
 151188d:	48 6b f7 74          	imul   $0x74,%rdi,%rsi
 1511891:	48 8b 3c 24          	mov    (%rsp),%rdi
 1511895:	48 6b d2 74          	imul   $0x74,%rdx,%rdx
 1511899:	48 8d b4 3e cc 02 00 00 	lea    0x2cc(%rsi,%rdi,1),%rsi
 15118a1:	31 ff                	xor    %edi,%edi
 15118a3:	eb 0f                	jmp    15118b4 <tier0_tables_open+0x5f64>
 15118a5:	31 c0                	xor    %eax,%eax
 15118a7:	48 83 c7 74          	add    $0x74,%rdi
 15118ab:	48 39 fa             	cmp    %rdi,%rdx
 15118ae:	0f 84 cd b5 ff ff    	je     150ce81 <tier0_tables_open+0x1531>
 15118b4:	44 8b 44 3e fc       	mov    -0x4(%rsi,%rdi,1),%r8d
 15118b9:	45 89 c1             	mov    %r8d,%r9d
 15118bc:	41 83 e1 f8          	and    $0xfffffff8,%r9d
 15118c0:	4e 8b 0c 09          	mov    (%rcx,%r9,1),%r9
 15118c4:	4c 89 0c 3e          	mov    %r9,(%rsi,%rdi,1)
 15118c8:	3c 01                	cmp    $0x1,%al
 15118ca:	75 d9                	jne    15118a5 <tier0_tables_open+0x5f55>
 15118cc:	48 8b 04 24          	mov    (%rsp),%rax
 15118d0:	41 c1 e8 03          	shr    $0x3,%r8d
 15118d4:	48 8b 80 88 01 00 00 	mov    0x188(%rax),%rax
 15118db:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
 15118df:	66 85 c0             	test   %ax,%ax
 15118e2:	79 c1                	jns    15118a5 <tier0_tables_open+0x5f55>
 15118e4:	a9 00 40 00 00       	test   $0x4000,%eax
 15118e9:	0f 94 c0             	sete   %al
 15118ec:	48 83 c7 74          	add    $0x74,%rdi
 15118f0:	48 39 fa             	cmp    %rdi,%rdx
 15118f3:	75 bf                	jne    15118b4 <tier0_tables_open+0x5f64>
 15118f5:	e9 87 b5 ff ff       	jmp    150ce81 <tier0_tables_open+0x1531>
