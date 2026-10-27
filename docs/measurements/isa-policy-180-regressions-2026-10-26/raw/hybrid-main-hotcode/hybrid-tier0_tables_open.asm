
/home/david/buster-fast-bench/codex-180-fix-20261027-hybrid/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

00000000018b1800 <tier0_tables_open>:
 18b1800:	55                   	push   %rbp
 18b1801:	41 57                	push   %r15
 18b1803:	41 56                	push   %r14
 18b1805:	41 55                	push   %r13
 18b1807:	41 54                	push   %r12
 18b1809:	53                   	push   %rbx
 18b180a:	48 81 ec c8 02 00 00 	sub    $0x2c8,%rsp
 18b1811:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18b181a:	be 00 a0 00 00       	mov    $0xa000,%esi
 18b181f:	ba 03 00 00 00       	mov    $0x3,%edx
 18b1824:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b1829:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b182f:	48 89 fb             	mov    %rdi,%rbx
 18b1832:	45 31 f6             	xor    %r14d,%r14d
 18b1835:	31 ff                	xor    %edi,%edi
 18b1837:	45 31 c9             	xor    %r9d,%r9d
 18b183a:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 18b1842:	e8 f9 2c eb fe       	call   764540 <mmap@plt>
 18b1847:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b184b:	74 1c                	je     18b1869 <tier0_tables_open+0x69>
 18b184d:	be 00 a0 00 00       	mov    $0xa000,%esi
 18b1852:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b1857:	48 89 c7             	mov    %rax,%rdi
 18b185a:	49 89 c6             	mov    %rax,%r14
 18b185d:	e8 8e 2c eb fe       	call   7644f0 <madvise@plt>
 18b1862:	b8 99 9e 00 00       	mov    $0x9e99,%eax
 18b1867:	eb 02                	jmp    18b186b <tier0_tables_open+0x6b>
 18b1869:	31 c0                	xor    %eax,%eax
 18b186b:	be 00 90 00 00       	mov    $0x9000,%esi
 18b1870:	ba 03 00 00 00       	mov    $0x3,%edx
 18b1875:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b187a:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b1880:	4c 89 b3 20 01 00 00 	mov    %r14,0x120(%rbx)
 18b1887:	48 c7 83 28 01 00 00 00 00 00 00 	movq   $0x0,0x128(%rbx)
 18b1892:	48 89 83 30 01 00 00 	mov    %rax,0x130(%rbx)
 18b1899:	48 c7 83 38 01 00 00 00 00 00 00 	movq   $0x0,0x138(%rbx)
 18b18a4:	45 31 ff             	xor    %r15d,%r15d
 18b18a7:	31 ff                	xor    %edi,%edi
 18b18a9:	45 31 c9             	xor    %r9d,%r9d
 18b18ac:	e8 8f 2c eb fe       	call   764540 <mmap@plt>
 18b18b1:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b18b5:	74 1d                	je     18b18d4 <tier0_tables_open+0xd4>
 18b18b7:	be 00 90 00 00       	mov    $0x9000,%esi
 18b18bc:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b18c1:	48 89 c7             	mov    %rax,%rdi
 18b18c4:	49 89 c6             	mov    %rax,%r14
 18b18c7:	e8 24 2c eb fe       	call   7644f0 <madvise@plt>
 18b18cc:	41 bf 40 80 00 00    	mov    $0x8040,%r15d
 18b18d2:	eb 03                	jmp    18b18d7 <tier0_tables_open+0xd7>
 18b18d4:	45 31 f6             	xor    %r14d,%r14d
 18b18d7:	4c 89 b3 40 01 00 00 	mov    %r14,0x140(%rbx)
 18b18de:	48 c7 83 48 01 00 00 00 00 00 00 	movq   $0x0,0x148(%rbx)
 18b18e9:	4c 89 bb 50 01 00 00 	mov    %r15,0x150(%rbx)
 18b18f0:	48 c7 83 58 01 00 00 00 00 00 00 	movq   $0x0,0x158(%rbx)
 18b18fb:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b18ff:	48 8b 83 28 01 00 00 	mov    0x128(%rbx),%rax
 18b1906:	c5 fa 7f 84 24 bc 01 00 00 	vmovdqu %xmm0,0x1bc(%rsp)
 18b190f:	c5 f9 7f 84 24 b0 01 00 00 	vmovdqa %xmm0,0x1b0(%rsp)
 18b1918:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b191f:	4c 8d 74 10 3f       	lea    0x3f(%rax,%rdx,1),%r14
 18b1924:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
 18b1928:	49 83 e6 c0          	and    $0xffffffffffffffc0,%r14
 18b192c:	49 39 ce             	cmp    %rcx,%r14
 18b192f:	0f 82 6c 10 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1935:	4c 89 f1             	mov    %r14,%rcx
 18b1938:	48 29 d1             	sub    %rdx,%rcx
 18b193b:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1942:	48 29 ca             	sub    %rcx,%rdx
 18b1945:	40 0f 92 c6          	setb   %sil
 18b1949:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18b1950:	0f 92 c2             	setb   %dl
 18b1953:	40 08 f2             	or     %sil,%dl
 18b1956:	0f 85 45 10 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b195c:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18b1963:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b196a:	4d 85 f6             	test   %r14,%r14
 18b196d:	0f 84 2e 10 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1973:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b1977:	62 d1 fd 48 7f 06    	vmovdqa64 %zmm0,(%r14)
 18b197d:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1984:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b198b:	4c 8d 4c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r9
 18b1990:	48 01 d1             	add    %rdx,%rcx
 18b1993:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 18b1997:	49 39 c9             	cmp    %rcx,%r9
 18b199a:	0f 82 01 10 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b19a0:	4c 89 c9             	mov    %r9,%rcx
 18b19a3:	48 29 d1             	sub    %rdx,%rcx
 18b19a6:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b19ad:	48 29 ca             	sub    %rcx,%rdx
 18b19b0:	40 0f 92 c6          	setb   %sil
 18b19b4:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18b19bb:	0f 92 c2             	setb   %dl
 18b19be:	40 08 f2             	or     %sil,%dl
 18b19c1:	0f 85 da 0f 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b19c7:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18b19ce:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b19d5:	4d 85 c9             	test   %r9,%r9
 18b19d8:	0f 84 c3 0f 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b19de:	62 d1 fd 48 7f 01    	vmovdqa64 %zmm0,(%r9)
 18b19e4:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b19eb:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b19f2:	4c 8d 54 11 3f       	lea    0x3f(%rcx,%rdx,1),%r10
 18b19f7:	48 01 d1             	add    %rdx,%rcx
 18b19fa:	49 83 e2 c0          	and    $0xffffffffffffffc0,%r10
 18b19fe:	49 39 ca             	cmp    %rcx,%r10
 18b1a01:	0f 82 9a 0f 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1a07:	4c 89 d1             	mov    %r10,%rcx
 18b1a0a:	48 29 d1             	sub    %rdx,%rcx
 18b1a0d:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1a14:	48 29 ca             	sub    %rcx,%rdx
 18b1a17:	40 0f 92 c6          	setb   %sil
 18b1a1b:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18b1a22:	0f 92 c2             	setb   %dl
 18b1a25:	40 08 f2             	or     %sil,%dl
 18b1a28:	0f 85 73 0f 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1a2e:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18b1a35:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1a3c:	4d 85 d2             	test   %r10,%r10
 18b1a3f:	0f 84 5c 0f 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1a45:	62 d1 fd 48 7f 02    	vmovdqa64 %zmm0,(%r10)
 18b1a4b:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1a52:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1a59:	4c 8d 5c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r11
 18b1a5e:	48 01 d1             	add    %rdx,%rcx
 18b1a61:	49 83 e3 c0          	and    $0xffffffffffffffc0,%r11
 18b1a65:	49 39 cb             	cmp    %rcx,%r11
 18b1a68:	0f 82 33 0f 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1a6e:	4c 89 d9             	mov    %r11,%rcx
 18b1a71:	48 29 d1             	sub    %rdx,%rcx
 18b1a74:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1a7b:	48 29 ca             	sub    %rcx,%rdx
 18b1a7e:	40 0f 92 c6          	setb   %sil
 18b1a82:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18b1a89:	0f 92 c2             	setb   %dl
 18b1a8c:	40 08 f2             	or     %sil,%dl
 18b1a8f:	0f 85 0c 0f 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1a95:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18b1a9c:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1aa3:	4d 85 db             	test   %r11,%r11
 18b1aa6:	0f 84 f5 0e 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1aac:	62 d1 fd 48 7f 03    	vmovdqa64 %zmm0,(%r11)
 18b1ab2:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1ab9:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1ac0:	4c 8d 7c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r15
 18b1ac5:	48 01 d1             	add    %rdx,%rcx
 18b1ac8:	49 83 e7 c0          	and    $0xffffffffffffffc0,%r15
 18b1acc:	49 39 cf             	cmp    %rcx,%r15
 18b1acf:	0f 82 cc 0e 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1ad5:	4c 89 f9             	mov    %r15,%rcx
 18b1ad8:	48 29 d1             	sub    %rdx,%rcx
 18b1adb:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1ae2:	48 29 ca             	sub    %rcx,%rdx
 18b1ae5:	40 0f 92 c6          	setb   %sil
 18b1ae9:	48 81 fa 00 09 00 00 	cmp    $0x900,%rdx
 18b1af0:	0f 92 c2             	setb   %dl
 18b1af3:	40 08 f2             	or     %sil,%dl
 18b1af6:	0f 85 a5 0e 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1afc:	48 81 c1 00 09 00 00 	add    $0x900,%rcx
 18b1b03:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1b0a:	4d 85 ff             	test   %r15,%r15
 18b1b0d:	0f 84 8e 0e 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1b13:	62 d1 fd 48 7f 47 03 	vmovdqa64 %zmm0,0xc0(%r15)
 18b1b1a:	62 d1 fd 48 7f 47 02 	vmovdqa64 %zmm0,0x80(%r15)
 18b1b21:	62 d1 fd 48 7f 47 01 	vmovdqa64 %zmm0,0x40(%r15)
 18b1b28:	62 d1 fd 48 7f 07    	vmovdqa64 %zmm0,(%r15)
 18b1b2e:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1b35:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1b3c:	4c 8d 6c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r13
 18b1b41:	48 01 d1             	add    %rdx,%rcx
 18b1b44:	49 83 e5 c0          	and    $0xffffffffffffffc0,%r13
 18b1b48:	49 39 cd             	cmp    %rcx,%r13
 18b1b4b:	0f 82 50 0e 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1b51:	4c 89 e9             	mov    %r13,%rcx
 18b1b54:	48 29 d1             	sub    %rdx,%rcx
 18b1b57:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1b5e:	48 29 ca             	sub    %rcx,%rdx
 18b1b61:	40 0f 92 c6          	setb   %sil
 18b1b65:	48 81 fa 00 09 00 00 	cmp    $0x900,%rdx
 18b1b6c:	0f 92 c2             	setb   %dl
 18b1b6f:	40 08 f2             	or     %sil,%dl
 18b1b72:	0f 85 29 0e 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1b78:	48 81 c1 00 09 00 00 	add    $0x900,%rcx
 18b1b7f:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1b86:	4d 85 ed             	test   %r13,%r13
 18b1b89:	0f 84 12 0e 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1b8f:	62 d1 fd 48 7f 45 03 	vmovdqa64 %zmm0,0xc0(%r13)
 18b1b96:	62 d1 fd 48 7f 45 02 	vmovdqa64 %zmm0,0x80(%r13)
 18b1b9d:	62 d1 fd 48 7f 45 01 	vmovdqa64 %zmm0,0x40(%r13)
 18b1ba4:	62 d1 fd 48 7f 45 00 	vmovdqa64 %zmm0,0x0(%r13)
 18b1bab:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1bb2:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1bb9:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b1bbe:	48 01 d1             	add    %rdx,%rcx
 18b1bc1:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b1bc5:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 18b1bca:	48 39 ce             	cmp    %rcx,%rsi
 18b1bcd:	0f 82 ce 0d 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1bd3:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b1bd8:	48 29 d1             	sub    %rdx,%rcx
 18b1bdb:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1be2:	48 29 ca             	sub    %rcx,%rdx
 18b1be5:	40 0f 92 c6          	setb   %sil
 18b1be9:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18b1bf0:	0f 92 c2             	setb   %dl
 18b1bf3:	40 08 f2             	or     %sil,%dl
 18b1bf6:	0f 85 a5 0d 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1bfc:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18b1c03:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
 18b1c09:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1c10:	0f 84 8b 0d 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1c16:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b1c1b:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18b1c22:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18b1c29:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18b1c30:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18b1c37:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18b1c3e:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18b1c45:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18b1c4c:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18b1c52:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1c59:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1c60:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b1c65:	48 01 d1             	add    %rdx,%rcx
 18b1c68:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b1c6c:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
 18b1c71:	48 39 ce             	cmp    %rcx,%rsi
 18b1c74:	0f 82 27 0d 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1c7a:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b1c7f:	48 29 d1             	sub    %rdx,%rcx
 18b1c82:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1c89:	48 29 ca             	sub    %rcx,%rdx
 18b1c8c:	40 0f 92 c6          	setb   %sil
 18b1c90:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18b1c97:	0f 92 c2             	setb   %dl
 18b1c9a:	40 08 f2             	or     %sil,%dl
 18b1c9d:	0f 85 fe 0c 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1ca3:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18b1caa:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
 18b1cb0:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1cb7:	0f 84 e4 0c 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1cbd:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b1cc2:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18b1cc9:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18b1cd0:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18b1cd7:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18b1cde:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18b1ce5:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18b1cec:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18b1cf3:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18b1cf9:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1d00:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1d07:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b1d0c:	48 01 d1             	add    %rdx,%rcx
 18b1d0f:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b1d13:	48 89 b4 24 80 00 00 00 	mov    %rsi,0x80(%rsp)
 18b1d1b:	48 39 ce             	cmp    %rcx,%rsi
 18b1d1e:	0f 82 7d 0c 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1d24:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18b1d2c:	48 29 d1             	sub    %rdx,%rcx
 18b1d2f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1d36:	48 29 ca             	sub    %rcx,%rdx
 18b1d39:	40 0f 92 c6          	setb   %sil
 18b1d3d:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18b1d44:	0f 92 c2             	setb   %dl
 18b1d47:	40 08 f2             	or     %sil,%dl
 18b1d4a:	0f 85 51 0c 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1d50:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18b1d57:	48 83 bc 24 80 00 00 00 00 	cmpq   $0x0,0x80(%rsp)
 18b1d60:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1d67:	0f 84 34 0c 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1d6d:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18b1d75:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18b1d7c:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18b1d83:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18b1d8a:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18b1d91:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18b1d98:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18b1d9f:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18b1da6:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18b1dac:	48 8b 8b 20 01 00 00 	mov    0x120(%rbx),%rcx
 18b1db3:	48 8b b3 28 01 00 00 	mov    0x128(%rbx),%rsi
 18b1dba:	48 8d 54 0e 3f       	lea    0x3f(%rsi,%rcx,1),%rdx
 18b1dbf:	48 01 ce             	add    %rcx,%rsi
 18b1dc2:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 18b1dc6:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 18b1dcb:	48 39 f2             	cmp    %rsi,%rdx
 18b1dce:	0f 82 cd 0b 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1dd4:	49 89 f4             	mov    %rsi,%r12
 18b1dd7:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18b1ddc:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1de3:	48 29 ce             	sub    %rcx,%rsi
 18b1de6:	48 89 d7             	mov    %rdx,%rdi
 18b1de9:	48 29 f7             	sub    %rsi,%rdi
 18b1dec:	41 0f 92 c0          	setb   %r8b
 18b1df0:	48 81 ff 04 10 00 00 	cmp    $0x1004,%rdi
 18b1df7:	40 0f 92 c7          	setb   %dil
 18b1dfb:	44 08 c7             	or     %r8b,%dil
 18b1dfe:	0f 85 9d 0b 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1e04:	48 81 c6 04 10 00 00 	add    $0x1004,%rsi
 18b1e0b:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18b1e11:	48 89 b3 28 01 00 00 	mov    %rsi,0x128(%rbx)
 18b1e18:	0f 84 83 0b 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1e1e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18b1e23:	49 81 c4 7f 10 00 00 	add    $0x107f,%r12
 18b1e2a:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
 18b1e2e:	4c 89 64 24 60       	mov    %r12,0x60(%rsp)
 18b1e33:	48 81 c6 04 10 00 00 	add    $0x1004,%rsi
 18b1e3a:	49 39 f4             	cmp    %rsi,%r12
 18b1e3d:	0f 82 5e 0b 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1e43:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18b1e48:	48 29 ce             	sub    %rcx,%rsi
 18b1e4b:	48 29 f2             	sub    %rsi,%rdx
 18b1e4e:	0f 92 c1             	setb   %cl
 18b1e51:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b1e58:	0f 92 c2             	setb   %dl
 18b1e5b:	08 ca                	or     %cl,%dl
 18b1e5d:	0f 85 3e 0b 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1e63:	48 81 c6 04 02 00 00 	add    $0x204,%rsi
 18b1e6a:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
 18b1e70:	48 89 b3 28 01 00 00 	mov    %rsi,0x128(%rbx)
 18b1e77:	0f 84 24 0b 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1e7d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 18b1e82:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b1e88:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1e8f:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1e96:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b1e9b:	48 01 d1             	add    %rdx,%rcx
 18b1e9e:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b1ea2:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 18b1ea7:	48 39 ce             	cmp    %rcx,%rsi
 18b1eaa:	0f 82 f1 0a 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1eb0:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18b1eb5:	48 29 d1             	sub    %rdx,%rcx
 18b1eb8:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1ebf:	48 29 ca             	sub    %rcx,%rdx
 18b1ec2:	40 0f 92 c6          	setb   %sil
 18b1ec6:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b1ecd:	0f 92 c2             	setb   %dl
 18b1ed0:	40 08 f2             	or     %sil,%dl
 18b1ed3:	0f 85 c8 0a 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1ed9:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18b1ee0:	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
 18b1ee6:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1eed:	0f 84 ae 0a 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1ef3:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18b1ef8:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b1efe:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1f05:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1f0c:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b1f11:	48 01 d1             	add    %rdx,%rcx
 18b1f14:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b1f18:	48 89 b4 24 08 01 00 00 	mov    %rsi,0x108(%rsp)
 18b1f20:	48 39 ce             	cmp    %rcx,%rsi
 18b1f23:	0f 82 78 0a 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1f29:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18b1f31:	48 29 d1             	sub    %rdx,%rcx
 18b1f34:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1f3b:	48 29 ca             	sub    %rcx,%rdx
 18b1f3e:	40 0f 92 c6          	setb   %sil
 18b1f42:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b1f49:	0f 92 c2             	setb   %dl
 18b1f4c:	40 08 f2             	or     %sil,%dl
 18b1f4f:	0f 85 4c 0a 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1f55:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18b1f5c:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18b1f65:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1f6c:	0f 84 2f 0a 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1f72:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18b1f7a:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b1f80:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1f87:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b1f8e:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b1f93:	48 01 d1             	add    %rdx,%rcx
 18b1f96:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b1f9a:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18b1f9f:	48 39 ce             	cmp    %rcx,%rsi
 18b1fa2:	0f 82 f9 09 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b1fa8:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 18b1fad:	48 29 d1             	sub    %rdx,%rcx
 18b1fb0:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b1fb7:	48 29 ca             	sub    %rcx,%rdx
 18b1fba:	40 0f 92 c6          	setb   %sil
 18b1fbe:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b1fc5:	0f 92 c2             	setb   %dl
 18b1fc8:	40 08 f2             	or     %sil,%dl
 18b1fcb:	0f 85 d0 09 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b1fd1:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18b1fd8:	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
 18b1fde:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b1fe5:	0f 84 b6 09 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b1feb:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 18b1ff0:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b1ff6:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b1ffd:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b2004:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b2009:	48 01 d1             	add    %rdx,%rcx
 18b200c:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b2010:	48 89 b4 24 00 01 00 00 	mov    %rsi,0x100(%rsp)
 18b2018:	48 39 ce             	cmp    %rcx,%rsi
 18b201b:	0f 82 80 09 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b2021:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 18b2029:	48 29 d1             	sub    %rdx,%rcx
 18b202c:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b2033:	48 29 ca             	sub    %rcx,%rdx
 18b2036:	40 0f 92 c6          	setb   %sil
 18b203a:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b2041:	0f 92 c2             	setb   %dl
 18b2044:	40 08 f2             	or     %sil,%dl
 18b2047:	0f 85 54 09 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b204d:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18b2054:	48 83 bc 24 00 01 00 00 00 	cmpq   $0x0,0x100(%rsp)
 18b205d:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b2064:	0f 84 37 09 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b206a:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 18b2072:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b2078:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b207f:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b2086:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b208b:	48 01 d1             	add    %rdx,%rcx
 18b208e:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b2092:	48 89 b4 24 a8 00 00 00 	mov    %rsi,0xa8(%rsp)
 18b209a:	48 39 ce             	cmp    %rcx,%rsi
 18b209d:	0f 82 fe 08 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b20a3:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18b20ab:	48 29 d1             	sub    %rdx,%rcx
 18b20ae:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b20b5:	48 29 ca             	sub    %rcx,%rdx
 18b20b8:	40 0f 92 c6          	setb   %sil
 18b20bc:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18b20c3:	0f 92 c2             	setb   %dl
 18b20c6:	40 08 f2             	or     %sil,%dl
 18b20c9:	0f 85 d2 08 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b20cf:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18b20d6:	48 83 bc 24 a8 00 00 00 00 	cmpq   $0x0,0xa8(%rsp)
 18b20df:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b20e6:	0f 84 b5 08 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b20ec:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18b20f4:	c6 01 00             	movb   $0x0,(%rcx)
 18b20f7:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b20fe:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b2105:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b210a:	48 01 d1             	add    %rdx,%rcx
 18b210d:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b2111:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
 18b2116:	48 39 ce             	cmp    %rcx,%rsi
 18b2119:	0f 82 82 08 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b211f:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 18b2124:	48 29 d1             	sub    %rdx,%rcx
 18b2127:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b212e:	48 29 ca             	sub    %rcx,%rdx
 18b2131:	40 0f 92 c6          	setb   %sil
 18b2135:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18b213c:	0f 92 c2             	setb   %dl
 18b213f:	40 08 f2             	or     %sil,%dl
 18b2142:	0f 85 59 08 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b2148:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18b214f:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
 18b2155:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b215c:	0f 84 3f 08 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b2162:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 18b2167:	c6 01 00             	movb   $0x0,(%rcx)
 18b216a:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b2171:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b2178:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b217d:	48 01 d1             	add    %rdx,%rcx
 18b2180:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b2184:	48 89 b4 24 f8 00 00 00 	mov    %rsi,0xf8(%rsp)
 18b218c:	48 39 ce             	cmp    %rcx,%rsi
 18b218f:	0f 82 0c 08 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b2195:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
 18b219d:	48 29 d1             	sub    %rdx,%rcx
 18b21a0:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b21a7:	48 29 ca             	sub    %rcx,%rdx
 18b21aa:	40 0f 92 c6          	setb   %sil
 18b21ae:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18b21b5:	0f 92 c2             	setb   %dl
 18b21b8:	40 08 f2             	or     %sil,%dl
 18b21bb:	0f 85 e0 07 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b21c1:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18b21c8:	48 83 bc 24 f8 00 00 00 00 	cmpq   $0x0,0xf8(%rsp)
 18b21d1:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b21d8:	0f 84 c3 07 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b21de:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
 18b21e6:	c6 01 00             	movb   $0x0,(%rcx)
 18b21e9:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b21f0:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b21f7:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b21fc:	48 01 d1             	add    %rdx,%rcx
 18b21ff:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b2203:	48 89 b4 24 38 01 00 00 	mov    %rsi,0x138(%rsp)
 18b220b:	48 39 ce             	cmp    %rcx,%rsi
 18b220e:	0f 82 8d 07 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b2214:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18b221c:	48 29 d1             	sub    %rdx,%rcx
 18b221f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b2226:	48 29 ca             	sub    %rcx,%rdx
 18b2229:	40 0f 92 c6          	setb   %sil
 18b222d:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18b2234:	0f 92 c2             	setb   %dl
 18b2237:	40 08 f2             	or     %sil,%dl
 18b223a:	0f 85 61 07 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b2240:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18b2247:	48 83 bc 24 38 01 00 00 00 	cmpq   $0x0,0x138(%rsp)
 18b2250:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b2257:	0f 84 44 07 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b225d:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18b2265:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b226b:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b2272:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b2279:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b227e:	48 01 d1             	add    %rdx,%rcx
 18b2281:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b2285:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 18b228d:	48 39 ce             	cmp    %rcx,%rsi
 18b2290:	0f 82 0b 07 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b2296:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18b229e:	48 29 d1             	sub    %rdx,%rcx
 18b22a1:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b22a8:	48 29 ca             	sub    %rcx,%rdx
 18b22ab:	40 0f 92 c6          	setb   %sil
 18b22af:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18b22b6:	0f 92 c2             	setb   %dl
 18b22b9:	40 08 f2             	or     %sil,%dl
 18b22bc:	0f 85 df 06 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b22c2:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18b22c9:	48 83 bc 24 a0 00 00 00 00 	cmpq   $0x0,0xa0(%rsp)
 18b22d2:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b22d9:	0f 84 c2 06 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b22df:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18b22e7:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b22ed:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b22f4:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b22fb:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b2300:	48 01 d1             	add    %rdx,%rcx
 18b2303:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b2307:	48 89 b4 24 30 01 00 00 	mov    %rsi,0x130(%rsp)
 18b230f:	48 39 ce             	cmp    %rcx,%rsi
 18b2312:	0f 82 89 06 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b2318:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18b2320:	48 29 d1             	sub    %rdx,%rcx
 18b2323:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b232a:	48 29 ca             	sub    %rcx,%rdx
 18b232d:	40 0f 92 c6          	setb   %sil
 18b2331:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18b2338:	0f 92 c2             	setb   %dl
 18b233b:	40 08 f2             	or     %sil,%dl
 18b233e:	0f 85 5d 06 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b2344:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18b234b:	48 83 bc 24 30 01 00 00 00 	cmpq   $0x0,0x130(%rsp)
 18b2354:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b235b:	0f 84 40 06 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b2361:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18b2369:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b236f:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b2376:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b237d:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b2382:	48 01 d1             	add    %rdx,%rcx
 18b2385:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b2389:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
 18b238e:	48 39 ce             	cmp    %rcx,%rsi
 18b2391:	0f 82 0a 06 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b2397:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18b239c:	48 29 d1             	sub    %rdx,%rcx
 18b239f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b23a6:	48 29 ca             	sub    %rcx,%rdx
 18b23a9:	40 0f 92 c6          	setb   %sil
 18b23ad:	48 81 fa 01 02 00 00 	cmp    $0x201,%rdx
 18b23b4:	0f 92 c2             	setb   %dl
 18b23b7:	40 08 f2             	or     %sil,%dl
 18b23ba:	0f 85 e1 05 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b23c0:	48 81 c1 01 02 00 00 	add    $0x201,%rcx
 18b23c7:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
 18b23cd:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b23d4:	0f 84 c7 05 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b23da:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18b23df:	c6 01 00             	movb   $0x0,(%rcx)
 18b23e2:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b23e9:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b23f0:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b23f5:	48 01 d1             	add    %rdx,%rcx
 18b23f8:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b23fc:	48 89 b4 24 28 01 00 00 	mov    %rsi,0x128(%rsp)
 18b2404:	48 39 ce             	cmp    %rcx,%rsi
 18b2407:	0f 82 94 05 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b240d:	48 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%rcx
 18b2415:	48 29 d1             	sub    %rdx,%rcx
 18b2418:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b241f:	48 29 ca             	sub    %rcx,%rdx
 18b2422:	40 0f 92 c6          	setb   %sil
 18b2426:	48 81 fa 01 02 00 00 	cmp    $0x201,%rdx
 18b242d:	0f 92 c2             	setb   %dl
 18b2430:	40 08 f2             	or     %sil,%dl
 18b2433:	0f 85 68 05 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b2439:	48 81 c1 01 02 00 00 	add    $0x201,%rcx
 18b2440:	48 83 bc 24 28 01 00 00 00 	cmpq   $0x0,0x128(%rsp)
 18b2449:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b2450:	0f 84 4b 05 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b2456:	48 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%rcx
 18b245e:	c6 01 00             	movb   $0x0,(%rcx)
 18b2461:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b2468:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b246f:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b2474:	48 01 d1             	add    %rdx,%rcx
 18b2477:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b247b:	48 89 b4 24 c8 00 00 00 	mov    %rsi,0xc8(%rsp)
 18b2483:	48 39 ce             	cmp    %rcx,%rsi
 18b2486:	0f 82 15 05 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b248c:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18b2494:	48 29 d1             	sub    %rdx,%rcx
 18b2497:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b249e:	48 29 ca             	sub    %rcx,%rdx
 18b24a1:	40 0f 92 c6          	setb   %sil
 18b24a5:	48 81 fa 08 10 00 00 	cmp    $0x1008,%rdx
 18b24ac:	0f 92 c2             	setb   %dl
 18b24af:	40 08 f2             	or     %sil,%dl
 18b24b2:	0f 85 e9 04 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b24b8:	48 81 c1 08 10 00 00 	add    $0x1008,%rcx
 18b24bf:	48 83 bc 24 c8 00 00 00 00 	cmpq   $0x0,0xc8(%rsp)
 18b24c8:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b24cf:	0f 84 cc 04 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b24d5:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18b24dd:	48 c7 01 00 00 00 00 	movq   $0x0,(%rcx)
 18b24e4:	48 8b 93 40 01 00 00 	mov    0x140(%rbx),%rdx
 18b24eb:	48 8b 8b 48 01 00 00 	mov    0x148(%rbx),%rcx
 18b24f2:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b24f7:	48 01 d1             	add    %rdx,%rcx
 18b24fa:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b24fe:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 18b2503:	48 39 ce             	cmp    %rcx,%rsi
 18b2506:	0f 82 95 04 00 00    	jb     18b29a1 <tier0_tables_open+0x11a1>
 18b250c:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 18b2511:	48 29 d1             	sub    %rdx,%rcx
 18b2514:	48 8b 93 50 01 00 00 	mov    0x150(%rbx),%rdx
 18b251b:	48 29 ca             	sub    %rcx,%rdx
 18b251e:	40 0f 92 c6          	setb   %sil
 18b2522:	48 81 fa 00 10 00 00 	cmp    $0x1000,%rdx
 18b2529:	0f 92 c2             	setb   %dl
 18b252c:	40 08 f2             	or     %sil,%dl
 18b252f:	0f 85 6c 04 00 00    	jne    18b29a1 <tier0_tables_open+0x11a1>
 18b2535:	48 81 c1 00 10 00 00 	add    $0x1000,%rcx
 18b253c:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 18b2542:	48 89 8b 48 01 00 00 	mov    %rcx,0x148(%rbx)
 18b2549:	0f 84 52 04 00 00    	je     18b29a1 <tier0_tables_open+0x11a1>
 18b254f:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
 18b2554:	48 8d 83 40 01 00 00 	lea    0x140(%rbx),%rax
 18b255b:	ba 00 10 00 00       	mov    $0x1000,%edx
 18b2560:	4c 89 ac 24 d8 00 00 00 	mov    %r13,0xd8(%rsp)
 18b2568:	4c 89 7c 24 20       	mov    %r15,0x20(%rsp)
 18b256d:	48 89 1c 24          	mov    %rbx,(%rsp)
 18b2571:	31 f6                	xor    %esi,%esi
 18b2573:	45 31 ff             	xor    %r15d,%r15d
 18b2576:	4d 89 cd             	mov    %r9,%r13
 18b2579:	4d 89 d4             	mov    %r10,%r12
 18b257c:	4c 89 db             	mov    %r11,%rbx
 18b257f:	48 89 84 24 d0 00 00 00 	mov    %rax,0xd0(%rsp)
 18b2587:	c5 f8 77             	vzeroupper
 18b258a:	e8 a1 1d eb fe       	call   764330 <memset@plt>
 18b258f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18b2594:	41 c6 46 01 01       	movb   $0x1,0x1(%r14)
 18b2599:	41 c6 45 01 01       	movb   $0x1,0x1(%r13)
 18b259e:	41 c6 44 24 01 00    	movb   $0x0,0x1(%r12)
 18b25a4:	c6 43 01 00          	movb   $0x0,0x1(%rbx)
 18b25a8:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 18b25b0:	4c 89 ef             	mov    %r13,%rdi
 18b25b3:	4d 89 e0             	mov    %r12,%r8
 18b25b6:	49 89 d9             	mov    %rbx,%r9
 18b25b9:	48 c7 40 08 01 00 00 00 	movq   $0x1,0x8(%rax)
 18b25c1:	48 8d 05 02 d3 7e 00 	lea    0x7ed302(%rip),%rax        # 209f8ca <type_builtins+0x6a>
 18b25c8:	41 8d 4f ea          	lea    -0x16(%r15),%ecx
 18b25cc:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b25cf:	73 43                	jae    18b2614 <tier0_tables_open+0xe14>
 18b25d1:	41 8d 4f eb          	lea    -0x15(%r15),%ecx
 18b25d5:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b25d8:	73 7a                	jae    18b2654 <tier0_tables_open+0xe54>
 18b25da:	41 8d 4f ec          	lea    -0x14(%r15),%ecx
 18b25de:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b25e1:	0f 83 b1 00 00 00    	jae    18b2698 <tier0_tables_open+0xe98>
 18b25e7:	41 8d 4f ed          	lea    -0x13(%r15),%ecx
 18b25eb:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b25ee:	0f 83 e8 00 00 00    	jae    18b26dc <tier0_tables_open+0xedc>
 18b25f4:	41 8d 4f ee          	lea    -0x12(%r15),%ecx
 18b25f8:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b25fb:	0f 83 1f 01 00 00    	jae    18b2720 <tier0_tables_open+0xf20>
 18b2601:	49 83 c7 05          	add    $0x5,%r15
 18b2605:	48 83 c0 50          	add    $0x50,%rax
 18b2609:	49 83 ff 1e          	cmp    $0x1e,%r15
 18b260d:	75 b9                	jne    18b25c8 <tier0_tables_open+0xdc8>
 18b260f:	e9 54 01 00 00       	jmp    18b2768 <tier0_tables_open+0xf68>
 18b2614:	0f b6 48 be          	movzbl -0x42(%rax),%ecx
 18b2618:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b2620:	0f b6 50 c0          	movzbl -0x40(%rax),%edx
 18b2624:	42 88 4c 3e 02       	mov    %cl,0x2(%rsi,%r15,1)
 18b2629:	41 8d 4f 02          	lea    0x2(%r15),%ecx
 18b262d:	42 88 4c 3f 02       	mov    %cl,0x2(%rdi,%r15,1)
 18b2632:	43 c6 44 38 02 04    	movb   $0x4,0x2(%r8,%r15,1)
 18b2638:	43 88 54 39 02       	mov    %dl,0x2(%r9,%r15,1)
 18b263d:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b2642:	0f b6 48 bf          	movzbl -0x41(%rax),%ecx
 18b2646:	4a 89 4c fa 10       	mov    %rcx,0x10(%rdx,%r15,8)
 18b264b:	41 8d 4f eb          	lea    -0x15(%r15),%ecx
 18b264f:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b2652:	72 86                	jb     18b25da <tier0_tables_open+0xdda>
 18b2654:	0f b6 48 ce          	movzbl -0x32(%rax),%ecx
 18b2658:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b2660:	0f b6 50 d0          	movzbl -0x30(%rax),%edx
 18b2664:	42 88 4c 3e 03       	mov    %cl,0x3(%rsi,%r15,1)
 18b2669:	41 8d 4f 03          	lea    0x3(%r15),%ecx
 18b266d:	42 88 4c 3f 03       	mov    %cl,0x3(%rdi,%r15,1)
 18b2672:	43 c6 44 38 03 04    	movb   $0x4,0x3(%r8,%r15,1)
 18b2678:	43 88 54 39 03       	mov    %dl,0x3(%r9,%r15,1)
 18b267d:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b2682:	0f b6 48 cf          	movzbl -0x31(%rax),%ecx
 18b2686:	4a 89 4c fa 18       	mov    %rcx,0x18(%rdx,%r15,8)
 18b268b:	41 8d 4f ec          	lea    -0x14(%r15),%ecx
 18b268f:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b2692:	0f 82 4f ff ff ff    	jb     18b25e7 <tier0_tables_open+0xde7>
 18b2698:	0f b6 48 de          	movzbl -0x22(%rax),%ecx
 18b269c:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b26a4:	0f b6 50 e0          	movzbl -0x20(%rax),%edx
 18b26a8:	42 88 4c 3e 04       	mov    %cl,0x4(%rsi,%r15,1)
 18b26ad:	41 8d 4f 04          	lea    0x4(%r15),%ecx
 18b26b1:	42 88 4c 3f 04       	mov    %cl,0x4(%rdi,%r15,1)
 18b26b6:	43 c6 44 38 04 04    	movb   $0x4,0x4(%r8,%r15,1)
 18b26bc:	43 88 54 39 04       	mov    %dl,0x4(%r9,%r15,1)
 18b26c1:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b26c6:	0f b6 48 df          	movzbl -0x21(%rax),%ecx
 18b26ca:	4a 89 4c fa 20       	mov    %rcx,0x20(%rdx,%r15,8)
 18b26cf:	41 8d 4f ed          	lea    -0x13(%r15),%ecx
 18b26d3:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b26d6:	0f 82 18 ff ff ff    	jb     18b25f4 <tier0_tables_open+0xdf4>
 18b26dc:	0f b6 48 ee          	movzbl -0x12(%rax),%ecx
 18b26e0:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b26e8:	0f b6 50 f0          	movzbl -0x10(%rax),%edx
 18b26ec:	42 88 4c 3e 05       	mov    %cl,0x5(%rsi,%r15,1)
 18b26f1:	41 8d 4f 05          	lea    0x5(%r15),%ecx
 18b26f5:	42 88 4c 3f 05       	mov    %cl,0x5(%rdi,%r15,1)
 18b26fa:	43 c6 44 38 05 04    	movb   $0x4,0x5(%r8,%r15,1)
 18b2700:	43 88 54 39 05       	mov    %dl,0x5(%r9,%r15,1)
 18b2705:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b270a:	0f b6 48 ef          	movzbl -0x11(%rax),%ecx
 18b270e:	4a 89 4c fa 28       	mov    %rcx,0x28(%rdx,%r15,8)
 18b2713:	41 8d 4f ee          	lea    -0x12(%r15),%ecx
 18b2717:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b271a:	0f 82 e1 fe ff ff    	jb     18b2601 <tier0_tables_open+0xe01>
 18b2720:	0f b6 48 fe          	movzbl -0x2(%rax),%ecx
 18b2724:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b272c:	0f b6 10             	movzbl (%rax),%edx
 18b272f:	42 88 4c 3e 06       	mov    %cl,0x6(%rsi,%r15,1)
 18b2734:	41 8d 4f 06          	lea    0x6(%r15),%ecx
 18b2738:	42 88 4c 3f 06       	mov    %cl,0x6(%rdi,%r15,1)
 18b273d:	43 c6 44 38 06 04    	movb   $0x4,0x6(%r8,%r15,1)
 18b2743:	43 88 54 39 06       	mov    %dl,0x6(%r9,%r15,1)
 18b2748:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b274d:	0f b6 48 ff          	movzbl -0x1(%rax),%ecx
 18b2751:	4a 89 4c fa 30       	mov    %rcx,0x30(%rdx,%r15,8)
 18b2756:	49 83 c7 05          	add    $0x5,%r15
 18b275a:	48 83 c0 50          	add    $0x50,%rax
 18b275e:	49 83 ff 1e          	cmp    $0x1e,%r15
 18b2762:	0f 85 60 fe ff ff    	jne    18b25c8 <tier0_tables_open+0xdc8>
 18b2768:	c5 fa 7e 0d 30 35 cc fe 	vmovq  -0x133cad0(%rip),%xmm1        # 575ca0 <x86_effects_unknown+0x240>
 18b2770:	c4 e2 79 31 15 43 dd cc fe 	vpmovzxbd -0x13322bd(%rip),%xmm2        # 5804bc <tier0_emit_x87.operations+0x74>
 18b2779:	c5 fa 7e 05 2f 35 cc fe 	vmovq  -0x133cad1(%rip),%xmm0        # 575cb0 <x86_effects_unknown+0x250>
 18b2781:	bb 10 11 11 00       	mov    $0x111110,%ebx
 18b2786:	41 be 02 00 00 00    	mov    $0x2,%r14d
 18b278c:	41 bf 04 00 00 00    	mov    $0x4,%r15d
 18b2792:	41 bc 08 00 00 00    	mov    $0x8,%r12d
 18b2798:	4c 8d 15 c1 d0 7e 00 	lea    0x7ed0c1(%rip),%r10        # 209f860 <type_builtins>
 18b279f:	31 d2                	xor    %edx,%edx
 18b27a1:	45 31 db             	xor    %r11d,%r11d
 18b27a4:	48 0f a3 d3          	bt     %rdx,%rbx
 18b27a8:	73 47                	jae    18b27f1 <tier0_tables_open+0xff1>
 18b27aa:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18b27b2:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b27b7:	c6 44 10 20 06       	movb   $0x6,0x20(%rax,%rdx,1)
 18b27bc:	8d 42 20             	lea    0x20(%rdx),%eax
 18b27bf:	88 44 17 20          	mov    %al,0x20(%rdi,%rdx,1)
 18b27c3:	41 c6 44 10 20 04    	movb   $0x4,0x20(%r8,%rdx,1)
 18b27c9:	43 0f b6 44 5a 0a    	movzbl 0xa(%r10,%r11,2),%eax
 18b27cf:	41 88 44 11 20       	mov    %al,0x20(%r9,%rdx,1)
 18b27d4:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 18b27d9:	44 89 9c 90 80 00 00 00 	mov    %r11d,0x80(%rax,%rdx,4)
 18b27e1:	43 0f b6 44 5a 09    	movzbl 0x9(%r10,%r11,2),%eax
 18b27e7:	01 c0                	add    %eax,%eax
 18b27e9:	48 89 84 d1 00 01 00 00 	mov    %rax,0x100(%rcx,%rdx,8)
 18b27f1:	c4 c2 e9 f7 c6       	shlx   %rdx,%r14,%rax
 18b27f6:	a9 20 22 22 00       	test   $0x222220,%eax
 18b27fb:	74 42                	je     18b283f <tier0_tables_open+0x103f>
 18b27fd:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18b2805:	48 89 d0             	mov    %rdx,%rax
 18b2808:	48 83 c8 21          	or     $0x21,%rax
 18b280c:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18b2811:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18b2815:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18b2818:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18b281d:	43 0f b6 4c 5a 1a    	movzbl 0x1a(%r10,%r11,2),%ecx
 18b2823:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18b2827:	41 8d 4b 08          	lea    0x8(%r11),%ecx
 18b282b:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18b282e:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b2833:	43 0f b6 4c 5a 19    	movzbl 0x19(%r10,%r11,2),%ecx
 18b2839:	01 c9                	add    %ecx,%ecx
 18b283b:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18b283f:	c4 c2 e9 f7 c7       	shlx   %rdx,%r15,%rax
 18b2844:	a9 40 44 40 00       	test   $0x404440,%eax
 18b2849:	74 42                	je     18b288d <tier0_tables_open+0x108d>
 18b284b:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18b2853:	48 89 d0             	mov    %rdx,%rax
 18b2856:	48 83 c8 22          	or     $0x22,%rax
 18b285a:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18b285f:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18b2863:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18b2866:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18b286b:	43 0f b6 4c 5a 2a    	movzbl 0x2a(%r10,%r11,2),%ecx
 18b2871:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18b2875:	41 8d 4b 10          	lea    0x10(%r11),%ecx
 18b2879:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18b287c:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b2881:	43 0f b6 4c 5a 29    	movzbl 0x29(%r10,%r11,2),%ecx
 18b2887:	01 c9                	add    %ecx,%ecx
 18b2889:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18b288d:	c4 c2 e9 f7 c4       	shlx   %rdx,%r12,%rax
 18b2892:	a9 88 88 08 00       	test   $0x88888,%eax
 18b2897:	74 42                	je     18b28db <tier0_tables_open+0x10db>
 18b2899:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18b28a1:	48 89 d0             	mov    %rdx,%rax
 18b28a4:	48 83 c8 23          	or     $0x23,%rax
 18b28a8:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18b28ad:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18b28b1:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18b28b4:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18b28b9:	43 0f b6 4c 5a 3a    	movzbl 0x3a(%r10,%r11,2),%ecx
 18b28bf:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18b28c3:	41 8d 4b 18          	lea    0x18(%r11),%ecx
 18b28c7:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18b28ca:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b28cf:	43 0f b6 4c 5a 39    	movzbl 0x39(%r10,%r11,2),%ecx
 18b28d5:	01 c9                	add    %ecx,%ecx
 18b28d7:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18b28db:	b0 01                	mov    $0x1,%al
 18b28dd:	48 83 c2 04          	add    $0x4,%rdx
 18b28e1:	49 83 c3 20          	add    $0x20,%r11
 18b28e5:	48 89 84 24 b8 00 00 00 	mov    %rax,0xb8(%rsp)
 18b28ed:	48 83 fa 20          	cmp    $0x20,%rdx
 18b28f1:	0f 85 ad fe ff ff    	jne    18b27a4 <tier0_tables_open+0xfa4>
 18b28f7:	ba 40 60 00 00       	mov    $0x6040,%edx
 18b28fc:	48 89 bc 24 40 01 00 00 	mov    %rdi,0x140(%rsp)
 18b2904:	4c 89 84 24 18 01 00 00 	mov    %r8,0x118(%rsp)
 18b290c:	4c 89 4c 24 68       	mov    %r9,0x68(%rsp)
 18b2911:	48 8b 1c 24          	mov    (%rsp),%rbx
 18b2915:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 18b291a:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18b291f:	4c 8b bc 24 08 01 00 00 	mov    0x108(%rsp),%r15
 18b2927:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 18b292c:	4c 8b 94 24 00 01 00 00 	mov    0x100(%rsp),%r10
 18b2934:	48 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%rdi
 18b293c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
 18b2941:	4c 8b b4 24 f8 00 00 00 	mov    0xf8(%rsp),%r14
 18b2949:	4c 8b 9c 24 38 01 00 00 	mov    0x138(%rsp),%r11
 18b2951:	4c 8b ac 24 a0 00 00 00 	mov    0xa0(%rsp),%r13
 18b2959:	48 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%rbp
 18b2961:	4c 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%r9
 18b2969:	4c 8b a4 24 c8 00 00 00 	mov    0xc8(%rsp),%r12
 18b2971:	c7 44 24 48 00 00 00 00 	movl   $0x0,0x48(%rsp)
 18b2979:	c7 44 24 30 40 00 00 00 	movl   $0x40,0x30(%rsp)
 18b2981:	c7 84 24 10 01 00 00 00 04 00 00 	movl   $0x400,0x110(%rsp)
 18b298c:	48 89 94 24 48 01 00 00 	mov    %rdx,0x148(%rsp)
 18b2994:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18b299c:	e9 10 01 00 00       	jmp    18b2ab1 <tier0_tables_open+0x12b1>
 18b29a1:	48 3b 83 28 01 00 00 	cmp    0x128(%rbx),%rax
 18b29a8:	0f 87 04 4c 00 00    	ja     18b75b2 <tier0_tables_open+0x5db2>
 18b29ae:	48 89 83 28 01 00 00 	mov    %rax,0x128(%rbx)
 18b29b5:	b8 c0 01 00 00       	mov    $0x1c0,%eax
 18b29ba:	48 c7 83 48 01 00 00 00 00 00 00 	movq   $0x0,0x148(%rbx)
 18b29c5:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b29c9:	c5 fa 7f 84 24 bc 01 00 00 	vmovdqu %xmm0,0x1bc(%rsp)
 18b29d2:	c5 f9 7f 84 24 b0 01 00 00 	vmovdqa %xmm0,0x1b0(%rsp)
 18b29db:	c7 44 24 48 01 00 00 00 	movl   $0x1,0x48(%rsp)
 18b29e3:	48 c7 84 24 b8 00 00 00 00 00 00 00 	movq   $0x0,0xb8(%rsp)
 18b29ef:	31 d2                	xor    %edx,%edx
 18b29f1:	48 c7 84 24 40 01 00 00 00 00 00 00 	movq   $0x0,0x140(%rsp)
 18b29fd:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 18b2a09:	48 c7 44 24 68 00 00 00 00 	movq   $0x0,0x68(%rsp)
 18b2a12:	48 c7 44 24 20 00 00 00 00 	movq   $0x0,0x20(%rsp)
 18b2a1b:	48 c7 84 24 d8 00 00 00 00 00 00 00 	movq   $0x0,0xd8(%rsp)
 18b2a27:	48 c7 44 24 10 00 00 00 00 	movq   $0x0,0x10(%rsp)
 18b2a30:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 18b2a39:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18b2a45:	c7 44 24 30 00 00 00 00 	movl   $0x0,0x30(%rsp)
 18b2a4d:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18b2a56:	c7 84 24 10 01 00 00 00 00 00 00 	movl   $0x0,0x110(%rsp)
 18b2a61:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18b2a65:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18b2a69:	31 c9                	xor    %ecx,%ecx
 18b2a6b:	45 31 ff             	xor    %r15d,%r15d
 18b2a6e:	31 f6                	xor    %esi,%esi
 18b2a70:	45 31 d2             	xor    %r10d,%r10d
 18b2a73:	31 ff                	xor    %edi,%edi
 18b2a75:	45 31 c0             	xor    %r8d,%r8d
 18b2a78:	45 31 f6             	xor    %r14d,%r14d
 18b2a7b:	45 31 db             	xor    %r11d,%r11d
 18b2a7e:	45 31 ed             	xor    %r13d,%r13d
 18b2a81:	31 ed                	xor    %ebp,%ebp
 18b2a83:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
 18b2a8c:	45 31 c9             	xor    %r9d,%r9d
 18b2a8f:	45 31 e4             	xor    %r12d,%r12d
 18b2a92:	48 c7 84 24 d0 00 00 00 00 00 00 00 	movq   $0x0,0xd0(%rsp)
 18b2a9e:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18b2aa7:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18b2aaf:	31 c0                	xor    %eax,%eax
 18b2ab1:	48 89 13             	mov    %rdx,(%rbx)
 18b2ab4:	48 8b 94 24 40 01 00 00 	mov    0x140(%rsp),%rdx
 18b2abc:	48 89 53 08          	mov    %rdx,0x8(%rbx)
 18b2ac0:	48 8b 94 24 18 01 00 00 	mov    0x118(%rsp),%rdx
 18b2ac8:	48 89 53 10          	mov    %rdx,0x10(%rbx)
 18b2acc:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 18b2ad1:	48 89 53 18          	mov    %rdx,0x18(%rbx)
 18b2ad5:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 18b2ada:	48 89 53 20          	mov    %rdx,0x20(%rbx)
 18b2ade:	48 8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%rdx
 18b2ae6:	48 89 53 28          	mov    %rdx,0x28(%rbx)
 18b2aea:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 18b2aef:	48 89 53 30          	mov    %rdx,0x30(%rbx)
 18b2af3:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b2af8:	48 89 53 38          	mov    %rdx,0x38(%rbx)
 18b2afc:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18b2b04:	48 89 53 40          	mov    %rdx,0x40(%rbx)
 18b2b08:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18b2b0d:	c5 f9 d6 43 48       	vmovq  %xmm0,0x48(%rbx)
 18b2b12:	48 89 53 50          	mov    %rdx,0x50(%rbx)
 18b2b16:	8b 94 24 10 01 00 00 	mov    0x110(%rsp),%edx
 18b2b1d:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%rbx)
 18b2b24:	89 53 5c             	mov    %edx,0x5c(%rbx)
 18b2b27:	48 89 43 60          	mov    %rax,0x60(%rbx)
 18b2b2b:	48 89 4b 68          	mov    %rcx,0x68(%rbx)
 18b2b2f:	4c 89 7b 70          	mov    %r15,0x70(%rbx)
 18b2b33:	48 89 73 78          	mov    %rsi,0x78(%rbx)
 18b2b37:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
 18b2b3c:	4c 89 93 80 00 00 00 	mov    %r10,0x80(%rbx)
 18b2b43:	48 89 bb 88 00 00 00 	mov    %rdi,0x88(%rbx)
 18b2b4a:	4c 89 83 90 00 00 00 	mov    %r8,0x90(%rbx)
 18b2b51:	4c 89 b3 98 00 00 00 	mov    %r14,0x98(%rbx)
 18b2b58:	c5 f9 d6 93 a0 00 00 00 	vmovq  %xmm2,0xa0(%rbx)
 18b2b60:	48 c7 83 a8 00 00 00 00 00 00 00 	movq   $0x0,0xa8(%rbx)
 18b2b6b:	4c 89 9b b0 00 00 00 	mov    %r11,0xb0(%rbx)
 18b2b72:	4c 89 ab b8 00 00 00 	mov    %r13,0xb8(%rbx)
 18b2b79:	48 89 ab c0 00 00 00 	mov    %rbp,0xc0(%rbx)
 18b2b80:	4c 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%r10
 18b2b88:	8b 54 24 30          	mov    0x30(%rsp),%edx
 18b2b8c:	8b 4c 24 48          	mov    0x48(%rsp),%ecx
 18b2b90:	4c 8b bc 24 48 01 00 00 	mov    0x148(%rsp),%r15
 18b2b98:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b2b9e:	31 ed                	xor    %ebp,%ebp
 18b2ba0:	31 ff                	xor    %edi,%edi
 18b2ba2:	48 89 b3 c8 00 00 00 	mov    %rsi,0xc8(%rbx)
 18b2ba9:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
 18b2bae:	4c 89 8b d0 00 00 00 	mov    %r9,0xd0(%rbx)
 18b2bb5:	4c 89 a3 d8 00 00 00 	mov    %r12,0xd8(%rbx)
 18b2bbc:	c5 f9 d6 8b e0 00 00 00 	vmovq  %xmm1,0xe0(%rbx)
 18b2bc4:	4c 89 93 e8 00 00 00 	mov    %r10,0xe8(%rbx)
 18b2bcb:	45 8d b7 c0 0f 00 00 	lea    0xfc0(%r15),%r14d
 18b2bd2:	45 31 c9             	xor    %r9d,%r9d
 18b2bd5:	41 81 e6 00 70 00 00 	and    $0x7000,%r14d
 18b2bdc:	48 89 b3 f0 00 00 00 	mov    %rsi,0xf0(%rbx)
 18b2be3:	89 93 f8 00 00 00    	mov    %edx,0xf8(%rbx)
 18b2be9:	c7 83 fc 00 00 00 00 00 00 00 	movl   $0x0,0xfc(%rbx)
 18b2bf3:	89 8b 00 01 00 00    	mov    %ecx,0x100(%rbx)
 18b2bf9:	ba 03 00 00 00       	mov    $0x3,%edx
 18b2bfe:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b2c03:	4c 89 f6             	mov    %r14,%rsi
 18b2c06:	c5 f8 10 84 24 bc 01 00 00 	vmovups 0x1bc(%rsp),%xmm0
 18b2c0f:	c5 f8 11 83 10 01 00 00 	vmovups %xmm0,0x110(%rbx)
 18b2c17:	c5 f9 6f 84 24 b0 01 00 00 	vmovdqa 0x1b0(%rsp),%xmm0
 18b2c20:	c5 fa 7f 83 04 01 00 00 	vmovdqu %xmm0,0x104(%rbx)
 18b2c28:	c5 f8 77             	vzeroupper
 18b2c2b:	e8 10 19 eb fe       	call   764540 <mmap@plt>
 18b2c30:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b2c34:	74 18                	je     18b2c4e <tier0_tables_open+0x144e>
 18b2c36:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b2c3b:	49 89 c4             	mov    %rax,%r12
 18b2c3e:	48 89 c7             	mov    %rax,%rdi
 18b2c41:	4c 89 f6             	mov    %r14,%rsi
 18b2c44:	e8 a7 18 eb fe       	call   7644f0 <madvise@plt>
 18b2c49:	4c 89 fd             	mov    %r15,%rbp
 18b2c4c:	eb 03                	jmp    18b2c51 <tier0_tables_open+0x1451>
 18b2c4e:	45 31 e4             	xor    %r12d,%r12d
 18b2c51:	80 bc 24 b8 00 00 00 00 	cmpb   $0x0,0xb8(%rsp)
 18b2c59:	4c 89 a3 40 02 00 00 	mov    %r12,0x240(%rbx)
 18b2c60:	48 c7 83 48 02 00 00 00 00 00 00 	movq   $0x0,0x248(%rbx)
 18b2c6b:	48 89 ab 50 02 00 00 	mov    %rbp,0x250(%rbx)
 18b2c72:	48 c7 83 58 02 00 00 00 00 00 00 	movq   $0x0,0x258(%rbx)
 18b2c7d:	0f 84 ac 00 00 00    	je     18b2d2f <tier0_tables_open+0x152f>
 18b2c83:	44 8b 7b 4c          	mov    0x4c(%rbx),%r15d
 18b2c87:	49 8d 44 24 3f       	lea    0x3f(%r12),%rax
 18b2c8c:	4c 8d b3 80 01 00 00 	lea    0x180(%rbx),%r14
 18b2c93:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18b2c97:	48 89 c2             	mov    %rax,%rdx
 18b2c9a:	4c 29 e2             	sub    %r12,%rdx
 18b2c9d:	72 25                	jb     18b2cc4 <tier0_tables_open+0x14c4>
 18b2c9f:	4c 89 f9             	mov    %r15,%rcx
 18b2ca2:	48 c1 e1 04          	shl    $0x4,%rcx
 18b2ca6:	48 89 ee             	mov    %rbp,%rsi
 18b2ca9:	48 29 d6             	sub    %rdx,%rsi
 18b2cac:	40 0f 92 c7          	setb   %dil
 18b2cb0:	48 39 f1             	cmp    %rsi,%rcx
 18b2cb3:	40 0f 97 c6          	seta   %sil
 18b2cb7:	40 08 fe             	or     %dil,%sil
 18b2cba:	40 80 fe 01          	cmp    $0x1,%sil
 18b2cbe:	0f 85 99 00 00 00    	jne    18b2d5d <tier0_tables_open+0x155d>
 18b2cc4:	49 c7 06 00 00 00 00 	movq   $0x0,(%r14)
 18b2ccb:	48 c7 83 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rbx)
 18b2cd6:	48 c7 83 90 01 00 00 00 00 00 00 	movq   $0x0,0x190(%rbx)
 18b2ce1:	48 c7 83 98 01 00 00 00 00 00 00 	movq   $0x0,0x198(%rbx)
 18b2cec:	48 c7 83 a0 01 00 00 00 00 00 00 	movq   $0x0,0x1a0(%rbx)
 18b2cf7:	48 c7 83 a8 01 00 00 00 00 00 00 	movq   $0x0,0x1a8(%rbx)
 18b2d02:	c4 e2 79 21 05 b5 d7 cc fe 	vpmovsxbd -0x133284b(%rip),%xmm0        # 5804c0 <tier0_emit_x87.operations+0x78>
 18b2d0b:	48 c7 83 b0 01 00 00 00 00 00 00 	movq   $0x0,0x1b0(%rbx)
 18b2d16:	c4 c3 79 22 c7 00    	vpinsrd $0x0,%r15d,%xmm0,%xmm0
 18b2d1c:	c5 fa 7f 83 b8 01 00 00 	vmovdqu %xmm0,0x1b8(%rbx)
 18b2d24:	48 c7 83 48 02 00 00 00 00 00 00 	movq   $0x0,0x248(%rbx)
 18b2d2f:	31 c0                	xor    %eax,%eax
 18b2d31:	64 48 8b 0c 25 28 00 00 00 	mov    %fs:0x28,%rcx
 18b2d3a:	48 3b 8c 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rcx
 18b2d42:	0f 85 92 12 00 00    	jne    18b3fda <tier0_tables_open+0x27da>
 18b2d48:	48 81 c4 c8 02 00 00 	add    $0x2c8,%rsp
 18b2d4f:	5b                   	pop    %rbx
 18b2d50:	41 5c                	pop    %r12
 18b2d52:	41 5d                	pop    %r13
 18b2d54:	41 5e                	pop    %r14
 18b2d56:	41 5f                	pop    %r15
 18b2d58:	5d                   	pop    %rbp
 18b2d59:	c5 f8 77             	vzeroupper
 18b2d5c:	c3                   	ret
 18b2d5d:	48 01 ca             	add    %rcx,%rdx
 18b2d60:	48 89 93 48 02 00 00 	mov    %rdx,0x248(%rbx)
 18b2d67:	48 89 83 80 01 00 00 	mov    %rax,0x180(%rbx)
 18b2d6e:	48 85 c0             	test   %rax,%rax
 18b2d71:	0f 84 54 ff ff ff    	je     18b2ccb <tier0_tables_open+0x14cb>
 18b2d77:	48 8d 7c 01 30       	lea    0x30(%rcx,%rax,1),%rdi
 18b2d7c:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
 18b2d80:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 18b2d84:	48 39 d7             	cmp    %rdx,%rdi
 18b2d87:	0f 82 3e ff ff ff    	jb     18b2ccb <tier0_tables_open+0x14cb>
 18b2d8d:	48 89 f8             	mov    %rdi,%rax
 18b2d90:	4a 8d 14 bd 00 00 00 00 	lea    0x0(,%r15,4),%rdx
 18b2d98:	4c 29 e0             	sub    %r12,%rax
 18b2d9b:	48 89 e9             	mov    %rbp,%rcx
 18b2d9e:	48 29 c1             	sub    %rax,%rcx
 18b2da1:	40 0f 92 c6          	setb   %sil
 18b2da5:	48 39 ca             	cmp    %rcx,%rdx
 18b2da8:	0f 97 c1             	seta   %cl
 18b2dab:	40 08 f1             	or     %sil,%cl
 18b2dae:	80 f9 01             	cmp    $0x1,%cl
 18b2db1:	0f 84 14 ff ff ff    	je     18b2ccb <tier0_tables_open+0x14cb>
 18b2db7:	48 01 d0             	add    %rdx,%rax
 18b2dba:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18b2dc1:	48 89 bb 88 01 00 00 	mov    %rdi,0x188(%rbx)
 18b2dc8:	48 85 ff             	test   %rdi,%rdi
 18b2dcb:	0f 84 05 ff ff ff    	je     18b2cd6 <tier0_tables_open+0x14d6>
 18b2dd1:	48 8d 4c 17 3c       	lea    0x3c(%rdi,%rdx,1),%rcx
 18b2dd6:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
 18b2dda:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18b2dde:	48 39 c1             	cmp    %rax,%rcx
 18b2de1:	0f 82 ef fe ff ff    	jb     18b2cd6 <tier0_tables_open+0x14d6>
 18b2de7:	48 89 c8             	mov    %rcx,%rax
 18b2dea:	4c 29 e0             	sub    %r12,%rax
 18b2ded:	48 89 ee             	mov    %rbp,%rsi
 18b2df0:	48 29 c6             	sub    %rax,%rsi
 18b2df3:	41 0f 92 c0          	setb   %r8b
 18b2df7:	48 39 f2             	cmp    %rsi,%rdx
 18b2dfa:	40 0f 97 c6          	seta   %sil
 18b2dfe:	44 08 c6             	or     %r8b,%sil
 18b2e01:	40 80 fe 01          	cmp    $0x1,%sil
 18b2e05:	0f 84 cb fe ff ff    	je     18b2cd6 <tier0_tables_open+0x14d6>
 18b2e0b:	48 01 d0             	add    %rdx,%rax
 18b2e0e:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18b2e15:	48 89 8b 90 01 00 00 	mov    %rcx,0x190(%rbx)
 18b2e1c:	48 85 c9             	test   %rcx,%rcx
 18b2e1f:	0f 84 bc fe ff ff    	je     18b2ce1 <tier0_tables_open+0x14e1>
 18b2e25:	48 8d 44 11 3c       	lea    0x3c(%rcx,%rdx,1),%rax
 18b2e2a:	48 01 d1             	add    %rdx,%rcx
 18b2e2d:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18b2e31:	48 39 c8             	cmp    %rcx,%rax
 18b2e34:	0f 82 a7 fe ff ff    	jb     18b2ce1 <tier0_tables_open+0x14e1>
 18b2e3a:	48 89 c1             	mov    %rax,%rcx
 18b2e3d:	4c 29 e1             	sub    %r12,%rcx
 18b2e40:	48 89 ee             	mov    %rbp,%rsi
 18b2e43:	48 29 ce             	sub    %rcx,%rsi
 18b2e46:	41 0f 92 c0          	setb   %r8b
 18b2e4a:	4c 39 fe             	cmp    %r15,%rsi
 18b2e4d:	40 0f 92 c6          	setb   %sil
 18b2e51:	44 08 c6             	or     %r8b,%sil
 18b2e54:	40 80 fe 01          	cmp    $0x1,%sil
 18b2e58:	0f 84 83 fe ff ff    	je     18b2ce1 <tier0_tables_open+0x14e1>
 18b2e5e:	4c 01 f9             	add    %r15,%rcx
 18b2e61:	48 89 8b 48 02 00 00 	mov    %rcx,0x248(%rbx)
 18b2e68:	48 89 83 98 01 00 00 	mov    %rax,0x198(%rbx)
 18b2e6f:	48 85 c0             	test   %rax,%rax
 18b2e72:	0f 84 74 fe ff ff    	je     18b2cec <tier0_tables_open+0x14ec>
 18b2e78:	4a 8d 4c 38 3f       	lea    0x3f(%rax,%r15,1),%rcx
 18b2e7d:	4c 01 f8             	add    %r15,%rax
 18b2e80:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18b2e84:	48 39 c1             	cmp    %rax,%rcx
 18b2e87:	0f 82 5f fe ff ff    	jb     18b2cec <tier0_tables_open+0x14ec>
 18b2e8d:	48 89 c8             	mov    %rcx,%rax
 18b2e90:	4c 29 e0             	sub    %r12,%rax
 18b2e93:	48 89 ee             	mov    %rbp,%rsi
 18b2e96:	48 29 c6             	sub    %rax,%rsi
 18b2e99:	41 0f 92 c0          	setb   %r8b
 18b2e9d:	4c 39 fe             	cmp    %r15,%rsi
 18b2ea0:	40 0f 92 c6          	setb   %sil
 18b2ea4:	44 08 c6             	or     %r8b,%sil
 18b2ea7:	40 80 fe 01          	cmp    $0x1,%sil
 18b2eab:	0f 84 3b fe ff ff    	je     18b2cec <tier0_tables_open+0x14ec>
 18b2eb1:	4c 01 f8             	add    %r15,%rax
 18b2eb4:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18b2ebb:	48 89 8b a0 01 00 00 	mov    %rcx,0x1a0(%rbx)
 18b2ec2:	48 85 c9             	test   %rcx,%rcx
 18b2ec5:	0f 84 2c fe ff ff    	je     18b2cf7 <tier0_tables_open+0x14f7>
 18b2ecb:	4a 8d 44 39 3f       	lea    0x3f(%rcx,%r15,1),%rax
 18b2ed0:	4c 01 f9             	add    %r15,%rcx
 18b2ed3:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18b2ed7:	48 39 c8             	cmp    %rcx,%rax
 18b2eda:	0f 82 17 fe ff ff    	jb     18b2cf7 <tier0_tables_open+0x14f7>
 18b2ee0:	48 89 c1             	mov    %rax,%rcx
 18b2ee3:	4e 8d 2c fd 00 00 00 00 	lea    0x0(,%r15,8),%r13
 18b2eeb:	4c 29 e1             	sub    %r12,%rcx
 18b2eee:	48 89 ee             	mov    %rbp,%rsi
 18b2ef1:	48 29 ce             	sub    %rcx,%rsi
 18b2ef4:	41 0f 92 c0          	setb   %r8b
 18b2ef8:	49 39 f5             	cmp    %rsi,%r13
 18b2efb:	40 0f 97 c6          	seta   %sil
 18b2eff:	44 08 c6             	or     %r8b,%sil
 18b2f02:	40 80 fe 01          	cmp    $0x1,%sil
 18b2f06:	0f 84 eb fd ff ff    	je     18b2cf7 <tier0_tables_open+0x14f7>
 18b2f0c:	4c 01 e9             	add    %r13,%rcx
 18b2f0f:	48 89 8b 48 02 00 00 	mov    %rcx,0x248(%rbx)
 18b2f16:	48 89 83 a8 01 00 00 	mov    %rax,0x1a8(%rbx)
 18b2f1d:	48 85 c0             	test   %rax,%rax
 18b2f20:	0f 84 dc fd ff ff    	je     18b2d02 <tier0_tables_open+0x1502>
 18b2f26:	4a 8d 4c 28 38       	lea    0x38(%rax,%r13,1),%rcx
 18b2f2b:	4c 01 e8             	add    %r13,%rax
 18b2f2e:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18b2f32:	48 39 c1             	cmp    %rax,%rcx
 18b2f35:	0f 82 c7 fd ff ff    	jb     18b2d02 <tier0_tables_open+0x1502>
 18b2f3b:	48 89 c8             	mov    %rcx,%rax
 18b2f3e:	4c 29 e0             	sub    %r12,%rax
 18b2f41:	48 29 c5             	sub    %rax,%rbp
 18b2f44:	40 0f 92 c6          	setb   %sil
 18b2f48:	49 39 ed             	cmp    %rbp,%r13
 18b2f4b:	41 0f 97 c0          	seta   %r8b
 18b2f4f:	41 08 f0             	or     %sil,%r8b
 18b2f52:	41 80 f8 01          	cmp    $0x1,%r8b
 18b2f56:	0f 84 a6 fd ff ff    	je     18b2d02 <tier0_tables_open+0x1502>
 18b2f5c:	c4 e2 79 21 05 5b d5 cc fe 	vpmovsxbd -0x1332aa5(%rip),%xmm0        # 5804c0 <tier0_emit_x87.operations+0x78>
 18b2f65:	4c 01 e8             	add    %r13,%rax
 18b2f68:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18b2f6f:	48 89 8b b0 01 00 00 	mov    %rcx,0x1b0(%rbx)
 18b2f76:	c4 c3 79 22 c7 00    	vpinsrd $0x0,%r15d,%xmm0,%xmm0
 18b2f7c:	c5 fa 7f 83 b8 01 00 00 	vmovdqu %xmm0,0x1b8(%rbx)
 18b2f84:	48 85 c9             	test   %rcx,%rcx
 18b2f87:	0f 84 97 fd ff ff    	je     18b2d24 <tier0_tables_open+0x1524>
 18b2f8d:	31 f6                	xor    %esi,%esi
 18b2f8f:	45 31 e4             	xor    %r12d,%r12d
 18b2f92:	e8 99 13 eb fe       	call   764330 <memset@plt>
 18b2f97:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
 18b2f9e:	31 f6                	xor    %esi,%esi
 18b2fa0:	4c 89 fa             	mov    %r15,%rdx
 18b2fa3:	e8 88 13 eb fe       	call   764330 <memset@plt>
 18b2fa8:	48 8b bb a8 01 00 00 	mov    0x1a8(%rbx),%rdi
 18b2faf:	31 f6                	xor    %esi,%esi
 18b2fb1:	4c 89 ea             	mov    %r13,%rdx
 18b2fb4:	e8 77 13 eb fe       	call   764330 <memset@plt>
 18b2fb9:	c5 fd 6f 05 9f d5 c9 fe 	vmovdqa -0x1362a61(%rip),%ymm0        # 550560 <x86_disassembly_format.rounding_names+0x180>
 18b2fc1:	c5 f9 6f 0d 37 2c cc fe 	vmovdqa -0x133d3c9(%rip),%xmm1        # 575c00 <x86_effects_unknown+0x1a0>
 18b2fc9:	48 b8 07 07 07 07 07 07 07 07 	movabs $0x707070707070707,%rax
 18b2fd3:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18b2fd9:	bd 77 00 00 00       	mov    $0x77,%ebp
 18b2fde:	66 41 bd 01 00       	mov    $0x1,%r13w
 18b2fe3:	c7 83 00 02 00 00 00 00 00 00 	movl   $0x0,0x200(%rbx)
 18b2fed:	c7 83 03 02 00 00 00 00 00 00 	movl   $0x0,0x203(%rbx)
 18b2ff7:	48 89 1c 24          	mov    %rbx,(%rsp)
 18b2ffb:	c5 fe 7f 83 07 02 00 00 	vmovdqu %ymm0,0x207(%rbx)
 18b3003:	c5 fa 7f 8b 27 02 00 00 	vmovdqu %xmm1,0x227(%rbx)
 18b300b:	c6 83 37 02 00 00 07 	movb   $0x7,0x237(%rbx)
 18b3012:	48 89 83 38 02 00 00 	mov    %rax,0x238(%rbx)
 18b3019:	e9 a3 00 00 00       	jmp    18b30c1 <tier0_tables_open+0x18c1>
 18b301e:	c1 e8 18             	shr    $0x18,%eax
 18b3021:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18b3027:	c5 f9 fc 05 e1 2b cc fe 	vpaddb -0x133d41f(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 18b302f:	89 c8                	mov    %ecx,%eax
 18b3031:	62 f3 7d 08 3e 0d e4 2b cc fe 06 	vpcmpnleub -0x133d41c(%rip),%xmm0,%k1        # 575c20 <x86_effects_unknown+0x1c0>
 18b303c:	0c 60                	or     $0x60,%al
 18b303e:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18b3044:	89 c8                	mov    %ecx,%eax
 18b3046:	c1 e0 04             	shl    $0x4,%eax
 18b3049:	09 c1                	or     %eax,%ecx
 18b304b:	0c 06                	or     $0x6,%al
 18b304d:	62 f2 7d 08 7a c8    	vpbroadcastb %eax,%xmm1
 18b3053:	62 f2 7d 09 7a c1    	vpbroadcastb %ecx,%xmm0{%k1}
 18b3059:	c5 f9 6c c1          	vpunpcklqdq %xmm1,%xmm0,%xmm0
 18b305d:	b8 10 00 00 00       	mov    $0x10,%eax
 18b3062:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b3067:	48 8b 34 24          	mov    (%rsp),%rsi
 18b306b:	c4 c1 7b 92 cd       	kmovd  %r13d,%k1
 18b3070:	4c 89 f7             	mov    %r14,%rdi
 18b3073:	48 29 d0             	sub    %rdx,%rax
 18b3076:	44 89 fa             	mov    %r15d,%edx
 18b3079:	48 0f 43 c8          	cmovae %rax,%rcx
 18b307d:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18b3083:	62 f3 75 08 3e 05 82 2b cc fe 05 	vpcmpnltub -0x133d47e(%rip),%xmm1,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 18b308e:	c4 e2 79 78 0d 29 d7 c6 fe 	vpbroadcastb -0x13928d7(%rip),%xmm1        # 5207c0 <branch_sizing_patterns+0xa30>
 18b3097:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18b309e:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18b30a2:	62 f2 75 09 66 c0    	vpblendmb %xmm0,%xmm1,%xmm0{%k1}
 18b30a8:	c4 a1 79 7f 44 20 10 	vmovdqa %xmm0,0x10(%rax,%r12,1)
 18b30af:	e8 8c 30 01 00       	call   18c6140 <abi_finish>
 18b30b4:	49 ff c7             	inc    %r15
 18b30b7:	49 83 c4 10          	add    $0x10,%r12
 18b30bb:	49 83 ff 40          	cmp    $0x40,%r15
 18b30bf:	74 65                	je     18b3126 <tier0_tables_open+0x1926>
 18b30c1:	48 8b 04 24          	mov    (%rsp),%rax
 18b30c5:	8b 40 48             	mov    0x48(%rax),%eax
 18b30c8:	49 39 c7             	cmp    %rax,%r15
 18b30cb:	73 59                	jae    18b3126 <tier0_tables_open+0x1926>
 18b30cd:	48 8b 04 24          	mov    (%rsp),%rax
 18b30d1:	48 8b 00             	mov    (%rax),%rax
 18b30d4:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
 18b30d9:	74 d9                	je     18b30b4 <tier0_tables_open+0x18b4>
 18b30db:	48 8b 34 24          	mov    (%rsp),%rsi
 18b30df:	4c 89 f7             	mov    %r14,%rdi
 18b30e2:	44 89 fa             	mov    %r15d,%edx
 18b30e5:	c5 f8 77             	vzeroupper
 18b30e8:	e8 23 2e 01 00       	call   18c5f10 <abi_simple>
 18b30ed:	89 c6                	mov    %eax,%esi
 18b30ef:	c1 ee 10             	shr    $0x10,%esi
 18b30f2:	48 89 c1             	mov    %rax,%rcx
 18b30f5:	48 c1 e9 08          	shr    $0x8,%rcx
 18b30f9:	89 f7                	mov    %esi,%edi
 18b30fb:	40 c0 e7 04          	shl    $0x4,%dil
 18b30ff:	40 08 cf             	or     %cl,%dil
 18b3102:	40 80 fe 07          	cmp    $0x7,%sil
 18b3106:	40 0f b6 f7          	movzbl %dil,%esi
 18b310a:	0f 44 f5             	cmove  %ebp,%esi
 18b310d:	80 f9 07             	cmp    $0x7,%cl
 18b3110:	0f 44 f5             	cmove  %ebp,%esi
 18b3113:	3c 01                	cmp    $0x1,%al
 18b3115:	0f 84 03 ff ff ff    	je     18b301e <tier0_tables_open+0x181e>
 18b311b:	62 f2 7d 08 7a c6    	vpbroadcastb %esi,%xmm0
 18b3121:	e9 37 ff ff ff       	jmp    18b305d <tier0_tables_open+0x185d>
 18b3126:	48 8b 04 24          	mov    (%rsp),%rax
 18b312a:	ba 04 1d 00 00       	mov    $0x1d04,%edx
 18b312f:	31 f6                	xor    %esi,%esi
 18b3131:	48 8d b8 60 02 00 00 	lea    0x260(%rax),%rdi
 18b3138:	c5 f8 77             	vzeroupper
 18b313b:	e8 f0 11 eb fe       	call   764330 <memset@plt>
 18b3140:	48 c7 44 24 68 00 00 00 00 	movq   $0x0,0x68(%rsp)
 18b3149:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 18b314e:	48 8d 05 0b c9 7e 00 	lea    0x7ec90b(%rip),%rax        # 209fa60 <tier0_record_shapes>
 18b3155:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
 18b3159:	80 3e 75             	cmpb   $0x75,(%rsi)
 18b315c:	75 09                	jne    18b3167 <tier0_tables_open+0x1967>
 18b315e:	80 7e 01 3a          	cmpb   $0x3a,0x1(%rsi)
 18b3162:	0f 94 c0             	sete   %al
 18b3165:	eb 02                	jmp    18b3169 <tier0_tables_open+0x1969>
 18b3167:	31 c0                	xor    %eax,%eax
 18b3169:	48 6b 54 24 68 74    	imul   $0x74,0x68(%rsp),%rdx
 18b316f:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3173:	48 81 c1 60 02 00 00 	add    $0x260,%rcx
 18b317a:	48 01 ca             	add    %rcx,%rdx
 18b317d:	88 42 64             	mov    %al,0x64(%rdx)
 18b3180:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 18b3185:	80 3e 61             	cmpb   $0x61,(%rsi)
 18b3188:	75 09                	jne    18b3193 <tier0_tables_open+0x1993>
 18b318a:	80 7e 01 3a          	cmpb   $0x3a,0x1(%rsi)
 18b318e:	0f 94 c2             	sete   %dl
 18b3191:	eb 02                	jmp    18b3195 <tier0_tables_open+0x1995>
 18b3193:	31 d2                	xor    %edx,%edx
 18b3195:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b319a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 18b31a0:	88 51 65             	mov    %dl,0x65(%rcx)
 18b31a3:	c7 41 60 01 00 00 00 	movl   $0x1,0x60(%rcx)
 18b31aa:	8b 79 58             	mov    0x58(%rcx),%edi
 18b31ad:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18b31b2:	48 83 ff 10          	cmp    $0x10,%rdi
 18b31b6:	0f 87 38 01 00 00    	ja     18b32f4 <tier0_tables_open+0x1af4>
 18b31bc:	41 89 d1             	mov    %edx,%r9d
 18b31bf:	41 08 c1             	or     %al,%r9b
 18b31c2:	45 0f b6 c9          	movzbl %r9b,%r9d
 18b31c6:	41 83 e1 01          	and    $0x1,%r9d
 18b31ca:	4a 8d 34 4e          	lea    (%rsi,%r9,2),%rsi
 18b31ce:	44 0f b6 14 37       	movzbl (%rdi,%rsi,1),%r10d
 18b31d3:	45 84 d2             	test   %r10b,%r10b
 18b31d6:	0f 84 18 01 00 00    	je     18b32f4 <tier0_tables_open+0x1af4>
 18b31dc:	31 c0                	xor    %eax,%eax
 18b31de:	41 89 f9             	mov    %edi,%r9d
 18b31e1:	31 c9                	xor    %ecx,%ecx
 18b31e3:	41 80 c2 b7          	add    $0xb7,%r10b
 18b31e7:	bd 0a 00 00 00       	mov    $0xa,%ebp
 18b31ec:	41 80 fa 2a          	cmp    $0x2a,%r10b
 18b31f0:	77 10                	ja     18b3202 <tier0_tables_open+0x1a02>
 18b31f2:	45 0f b6 c2          	movzbl %r10b,%r8d
 18b31f6:	4c 8d 15 bf 14 c7 fe 	lea    -0x138eb41(%rip),%r10        # 5246bc <tier0_emit_int128.extensions+0x10>
 18b31fd:	43 0f b6 2c 10       	movzbl (%r8,%r10,1),%ebp
 18b3202:	4c 8d 05 87 32 cc fe 	lea    -0x133cd79(%rip),%r8        # 576490 <tier0_class_bytes.bytes>
 18b3209:	41 89 ea             	mov    %ebp,%r10d
 18b320c:	f6 c2 01             	test   $0x1,%dl
 18b320f:	ba 10 00 00 00       	mov    $0x10,%edx
 18b3214:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
 18b3219:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 18b321f:	47 0f b6 1c 02       	movzbl (%r10,%r8,1),%r11d
 18b3224:	45 89 d8             	mov    %r11d,%r8d
 18b3227:	44 0f 45 c2          	cmovne %edx,%r8d
 18b322b:	45 85 c9             	test   %r9d,%r9d
 18b322e:	45 0f 45 c3          	cmovne %r11d,%r8d
 18b3232:	42 8d 54 00 ff       	lea    -0x1(%rax,%r8,1),%edx
 18b3237:	44 89 c0             	mov    %r8d,%eax
 18b323a:	f7 d8                	neg    %eax
 18b323c:	21 d0                	and    %edx,%eax
 18b323e:	41 80 7f 64 00       	cmpb   $0x0,0x64(%r15)
 18b3243:	41 88 2c 3f          	mov    %bpl,(%r15,%rdi,1)
 18b3247:	41 0f 45 c5          	cmovne %r13d,%eax
 18b324b:	45 31 e4             	xor    %r12d,%r12d
 18b324e:	41 89 44 bf 14       	mov    %eax,0x14(%r15,%rdi,4)
 18b3253:	41 0f b6 57 65       	movzbl 0x65(%r15),%edx
 18b3258:	41 8b 5f 60          	mov    0x60(%r15),%ebx
 18b325c:	84 d2                	test   %dl,%dl
 18b325e:	41 0f 95 c4          	setne  %r12b
 18b3262:	45 85 c9             	test   %r9d,%r9d
 18b3265:	43 8d 2c a4          	lea    (%r12,%r12,4),%ebp
 18b3269:	41 0f 45 ed          	cmovne %r13d,%ebp
 18b326d:	44 01 d8             	add    %r11d,%eax
 18b3270:	4c 8d 1d f9 12 c7 fe 	lea    -0x138ed07(%rip),%r11        # 524570 <tier0_program_class_type.types>
 18b3277:	39 c8                	cmp    %ecx,%eax
 18b3279:	0f 47 c8             	cmova  %eax,%ecx
 18b327c:	41 39 d8             	cmp    %ebx,%r8d
 18b327f:	44 0f 46 c3          	cmovbe %ebx,%r8d
 18b3283:	48 c1 e7 04          	shl    $0x4,%rdi
 18b3287:	41 ff c1             	inc    %r9d
 18b328a:	45 89 47 60          	mov    %r8d,0x60(%r15)
 18b328e:	44 89 8c 3c b0 01 00 00 	mov    %r9d,0x1b0(%rsp,%rdi,1)
 18b3296:	47 8b 14 93          	mov    (%r11,%r10,4),%r10d
 18b329a:	44 89 94 3c b4 01 00 00 	mov    %r10d,0x1b4(%rsp,%rdi,1)
 18b32a2:	c7 84 3c b8 01 00 00 ff ff ff ff 	movl   $0xffffffff,0x1b8(%rsp,%rdi,1)
 18b32ad:	40 88 ac 3c bc 01 00 00 	mov    %bpl,0x1bc(%rsp,%rdi,1)
 18b32b5:	c6 84 3c bd 01 00 00 00 	movb   $0x0,0x1bd(%rsp,%rdi,1)
 18b32bd:	66 c7 84 3c be 01 00 00 00 00 	movw   $0x0,0x1be(%rsp,%rdi,1)
 18b32c7:	45 8b 4f 58          	mov    0x58(%r15),%r9d
 18b32cb:	41 ff c1             	inc    %r9d
 18b32ce:	45 89 4f 58          	mov    %r9d,0x58(%r15)
 18b32d2:	41 83 f9 10          	cmp    $0x10,%r9d
 18b32d6:	77 11                	ja     18b32e9 <tier0_tables_open+0x1ae9>
 18b32d8:	46 0f b6 14 0e       	movzbl (%rsi,%r9,1),%r10d
 18b32dd:	4c 89 cf             	mov    %r9,%rdi
 18b32e0:	45 84 d2             	test   %r10b,%r10b
 18b32e3:	0f 85 fa fe ff ff    	jne    18b31e3 <tier0_tables_open+0x19e3>
 18b32e9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b32ee:	ff c9                	dec    %ecx
 18b32f0:	0f b6 40 64          	movzbl 0x64(%rax),%eax
 18b32f4:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18b32f9:	48 8b 14 24          	mov    (%rsp),%rdx
 18b32fd:	44 01 c1             	add    %r8d,%ecx
 18b3300:	41 f7 d8             	neg    %r8d
 18b3303:	41 21 c8             	and    %ecx,%r8d
 18b3306:	44 89 46 5c          	mov    %r8d,0x5c(%rsi)
 18b330a:	44 8b 62 48          	mov    0x48(%rdx),%r12d
 18b330e:	44 3b 62 4c          	cmp    0x4c(%rdx),%r12d
 18b3312:	0f 84 ca 0c 00 00    	je     18b3fe2 <tier0_tables_open+0x27e2>
 18b3318:	48 8b 14 24          	mov    (%rsp),%rdx
 18b331c:	8b 8a a0 00 00 00    	mov    0xa0(%rdx),%ecx
 18b3322:	3b 8a a4 00 00 00    	cmp    0xa4(%rdx),%ecx
 18b3328:	0f 84 b4 0c 00 00    	je     18b3fe2 <tier0_tables_open+0x27e2>
 18b332e:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b3332:	0c 10                	or     $0x10,%al
 18b3334:	42 8d 34 e5 00 00 00 00 	lea    0x0(,%r12,8),%esi
 18b333c:	89 74 24 40          	mov    %esi,0x40(%rsp)
 18b3340:	48 8b 17             	mov    (%rdi),%rdx
 18b3343:	42 88 04 22          	mov    %al,(%rdx,%r12,1)
 18b3347:	48 8b 57 08          	mov    0x8(%rdi),%rdx
 18b334b:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18b3350:	48 8b 57 10          	mov    0x10(%rdi),%rdx
 18b3354:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18b3359:	48 8b 57 18          	mov    0x18(%rdi),%rdx
 18b335d:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18b3362:	48 8b 57 20          	mov    0x20(%rdi),%rdx
 18b3366:	42 c7 04 a2 00 00 00 00 	movl   $0x0,(%rdx,%r12,4)
 18b336e:	48 8b 57 28          	mov    0x28(%rdi),%rdx
 18b3372:	42 89 0c a2          	mov    %ecx,(%rdx,%r12,4)
 18b3376:	48 8b 57 30          	mov    0x30(%rdi),%rdx
 18b337a:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18b3382:	48 8b 57 38          	mov    0x38(%rdi),%rdx
 18b3386:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18b338e:	48 8b 57 40          	mov    0x40(%rdi),%rdx
 18b3392:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18b339a:	ff 47 48             	incl   0x48(%rdi)
 18b339d:	48 8b 57 60          	mov    0x60(%rdi),%rdx
 18b33a1:	89 34 8a             	mov    %esi,(%rdx,%rcx,4)
 18b33a4:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 18b33a9:	48 8b 77 68          	mov    0x68(%rdi),%rsi
 18b33ad:	81 c2 e8 03 00 00    	add    $0x3e8,%edx
 18b33b3:	89 14 8e             	mov    %edx,(%rsi,%rcx,4)
 18b33b6:	48 8b 77 70          	mov    0x70(%rdi),%rsi
 18b33ba:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18b33c1:	48 8b 77 78          	mov    0x78(%rdi),%rsi
 18b33c5:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18b33cc:	48 8b b7 80 00 00 00 	mov    0x80(%rdi),%rsi
 18b33d3:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18b33da:	48 8b b7 88 00 00 00 	mov    0x88(%rdi),%rsi
 18b33e1:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18b33e5:	48 8b b7 90 00 00 00 	mov    0x90(%rdi),%rsi
 18b33ec:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18b33f0:	48 8b b7 98 00 00 00 	mov    0x98(%rdi),%rsi
 18b33f7:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18b33fb:	ff 87 a0 00 00 00    	incl   0xa0(%rdi)
 18b3401:	48 8b b7 08 01 00 00 	mov    0x108(%rdi),%rsi
 18b3408:	48 85 f6             	test   %rsi,%rsi
 18b340b:	74 76                	je     18b3483 <tier0_tables_open+0x1c83>
 18b340d:	80 7e 4c 00          	cmpb   $0x0,0x4c(%rsi)
 18b3411:	75 70                	jne    18b3483 <tier0_tables_open+0x1c83>
 18b3413:	8b 7e 08             	mov    0x8(%rsi),%edi
 18b3416:	3b 7e 0c             	cmp    0xc(%rsi),%edi
 18b3419:	75 06                	jne    18b3421 <tier0_tables_open+0x1c21>
 18b341b:	c6 46 4c 01          	movb   $0x1,0x4c(%rsi)
 18b341f:	eb 62                	jmp    18b3483 <tier0_tables_open+0x1c83>
 18b3421:	44 8d 4f 01          	lea    0x1(%rdi),%r9d
 18b3425:	44 8b 46 38          	mov    0x38(%rsi),%r8d
 18b3429:	c6 46 4c 00          	movb   $0x0,0x4c(%rsi)
 18b342d:	48 6b ff 38          	imul   $0x38,%rdi,%rdi
 18b3431:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b3435:	44 89 4e 08          	mov    %r9d,0x8(%rsi)
 18b3439:	4c 8b 0e             	mov    (%rsi),%r9
 18b343c:	4c 8b 56 30          	mov    0x30(%rsi),%r10
 18b3440:	ff 46 34             	incl   0x34(%rsi)
 18b3443:	8b 74 24 40          	mov    0x40(%rsp),%esi
 18b3447:	4d 89 14 39          	mov    %r10,(%r9,%rdi,1)
 18b344b:	41 c6 44 39 08 02    	movb   $0x2,0x8(%r9,%rdi,1)
 18b3451:	41 88 44 39 09       	mov    %al,0x9(%r9,%rdi,1)
 18b3456:	c4 c1 7a 7f 44 39 0a 	vmovdqu %xmm0,0xa(%r9,%rdi,1)
 18b345d:	49 c7 44 39 18 00 00 00 00 	movq   $0x0,0x18(%r9,%rdi,1)
 18b3466:	41 89 74 39 20       	mov    %esi,0x20(%r9,%rdi,1)
 18b346b:	41 89 54 39 24       	mov    %edx,0x24(%r9,%rdi,1)
 18b3470:	45 89 44 39 28       	mov    %r8d,0x28(%r9,%rdi,1)
 18b3475:	41 89 4c 39 2c       	mov    %ecx,0x2c(%r9,%rdi,1)
 18b347a:	49 c7 44 39 30 00 00 00 00 	movq   $0x0,0x30(%r9,%rdi,1)
 18b3483:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b3488:	8b 4c 24 40          	mov    0x40(%rsp),%ecx
 18b348c:	89 48 68             	mov    %ecx,0x68(%rax)
 18b348f:	85 c9                	test   %ecx,%ecx
 18b3491:	0f 84 c1 0b 00 00    	je     18b4058 <tier0_tables_open+0x2858>
 18b3497:	48 8b 04 24          	mov    (%rsp),%rax
 18b349b:	41 81 e4 ff ff ff 1f 	and    $0x1fffffff,%r12d
 18b34a2:	41 ba 0d 00 00 00    	mov    $0xd,%r10d
 18b34a8:	8b 58 48             	mov    0x48(%rax),%ebx
 18b34ab:	41 39 dc             	cmp    %ebx,%r12d
 18b34ae:	0f 83 7a 0b 00 00    	jae    18b402e <tier0_tables_open+0x282e>
 18b34b4:	48 8b 04 24          	mov    (%rsp),%rax
 18b34b8:	48 8b 30             	mov    (%rax),%rsi
 18b34bb:	42 0f b6 04 26       	movzbl (%rsi,%r12,1),%eax
 18b34c0:	24 fe                	and    $0xfe,%al
 18b34c2:	3c 10                	cmp    $0x10,%al
 18b34c4:	0f 85 64 0b 00 00    	jne    18b402e <tier0_tables_open+0x282e>
 18b34ca:	48 8b 04 24          	mov    (%rsp),%rax
 18b34ce:	48 8b 40 10          	mov    0x10(%rax),%rax
 18b34d2:	42 f6 04 20 24       	testb  $0x24,(%rax,%r12,1)
 18b34d7:	0f 85 51 0b 00 00    	jne    18b402e <tier0_tables_open+0x282e>
 18b34dd:	49 89 c7             	mov    %rax,%r15
 18b34e0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b34e5:	8b 48 58             	mov    0x58(%rax),%ecx
 18b34e8:	48 8b 04 24          	mov    (%rsp),%rax
 18b34ec:	8b 90 e0 00 00 00    	mov    0xe0(%rax),%edx
 18b34f2:	8b 80 e4 00 00 00    	mov    0xe4(%rax),%eax
 18b34f8:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 18b34fd:	ff c9                	dec    %ecx
 18b34ff:	29 d0                	sub    %edx,%eax
 18b3501:	89 94 24 80 00 00 00 	mov    %edx,0x80(%rsp)
 18b3508:	39 c1                	cmp    %eax,%ecx
 18b350a:	0f 83 e1 01 00 00    	jae    18b36f1 <tier0_tables_open+0x1ef1>
 18b3510:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 18b3516:	4c 8d 8c 24 bc 01 00 00 	lea    0x1bc(%rsp),%r9
 18b351e:	c6 44 24 20 20       	movb   $0x20,0x20(%rsp)
 18b3523:	45 8b 59 f8          	mov    -0x8(%r9),%r11d
 18b3527:	41 ba 02 00 00 00    	mov    $0x2,%r10d
 18b352d:	45 89 dd             	mov    %r11d,%r13d
 18b3530:	41 c1 ed 03          	shr    $0x3,%r13d
 18b3534:	0f 84 f4 0a 00 00    	je     18b402e <tier0_tables_open+0x282e>
 18b353a:	41 39 dd             	cmp    %ebx,%r13d
 18b353d:	0f 83 eb 0a 00 00    	jae    18b402e <tier0_tables_open+0x282e>
 18b3543:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18b3548:	84 c9                	test   %cl,%cl
 18b354a:	0f 84 de 0a 00 00    	je     18b402e <tier0_tables_open+0x282e>
 18b3550:	89 cd                	mov    %ecx,%ebp
 18b3552:	80 f9 0f             	cmp    $0xf,%cl
 18b3555:	75 13                	jne    18b356a <tier0_tables_open+0x1d6a>
 18b3557:	48 8b 04 24          	mov    (%rsp),%rax
 18b355b:	48 8b 40 20          	mov    0x20(%rax),%rax
 18b355f:	42 8b 04 a8          	mov    (%rax,%r13,4),%eax
 18b3563:	c1 e8 03             	shr    $0x3,%eax
 18b3566:	0f b6 2c 06          	movzbl (%rsi,%rax,1),%ebp
 18b356a:	41 ba 0e 00 00 00    	mov    $0xe,%r10d
 18b3570:	40 80 fd 01          	cmp    $0x1,%bpl
 18b3574:	0f 84 b4 0a 00 00    	je     18b402e <tier0_tables_open+0x282e>
 18b357a:	40 0f b6 c5          	movzbl %bpl,%eax
 18b357e:	83 f8 0b             	cmp    $0xb,%eax
 18b3581:	0f 84 a7 0a 00 00    	je     18b402e <tier0_tables_open+0x282e>
 18b3587:	43 0f b6 14 2f       	movzbl (%r15,%r13,1),%edx
 18b358c:	f6 c2 08             	test   $0x8,%dl
 18b358f:	0f 85 99 0a 00 00    	jne    18b402e <tier0_tables_open+0x282e>
 18b3595:	80 f9 0f             	cmp    $0xf,%cl
 18b3598:	75 2a                	jne    18b35c4 <tier0_tables_open+0x1dc4>
 18b359a:	48 8b 04 24          	mov    (%rsp),%rax
 18b359e:	48 8b 40 20          	mov    0x20(%rax),%rax
 18b35a2:	42 8b 04 a8          	mov    (%rax,%r13,4),%eax
 18b35a6:	c1 e8 03             	shr    $0x3,%eax
 18b35a9:	41 0f b6 14 07       	movzbl (%r15,%rax,1),%edx
 18b35ae:	41 8b 41 fc          	mov    -0x4(%r9),%eax
 18b35b2:	45 31 d2             	xor    %r10d,%r10d
 18b35b5:	f6 c2 04             	test   $0x4,%dl
 18b35b8:	74 16                	je     18b35d0 <tier0_tables_open+0x1dd0>
 18b35ba:	45 85 d2             	test   %r10d,%r10d
 18b35bd:	74 53                	je     18b3612 <tier0_tables_open+0x1e12>
 18b35bf:	e9 ce 00 00 00       	jmp    18b3692 <tier0_tables_open+0x1e92>
 18b35c4:	41 8b 41 fc          	mov    -0x4(%r9),%eax
 18b35c8:	45 31 d2             	xor    %r10d,%r10d
 18b35cb:	f6 c2 04             	test   $0x4,%dl
 18b35ce:	75 ea                	jne    18b35ba <tier0_tables_open+0x1dba>
 18b35d0:	83 f8 ff             	cmp    $0xffffffff,%eax
 18b35d3:	0f 95 c2             	setne  %dl
 18b35d6:	4c 39 44 24 08       	cmp    %r8,0x8(%rsp)
 18b35db:	40 0f 95 c7          	setne  %dil
 18b35df:	40 80 fd 09          	cmp    $0x9,%bpl
 18b35e3:	41 0f 95 c2          	setne  %r10b
 18b35e7:	40 08 d7             	or     %dl,%dil
 18b35ea:	ba 0e 00 00 00       	mov    $0xe,%edx
 18b35ef:	44 08 d7             	or     %r10b,%dil
 18b35f2:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 18b35f8:	44 0f 45 d2          	cmovne %edx,%r10d
 18b35fc:	40 80 f7 01          	xor    $0x1,%dil
 18b3600:	40 c0 e7 06          	shl    $0x6,%dil
 18b3604:	40 08 7c 24 20       	or     %dil,0x20(%rsp)
 18b3609:	45 85 d2             	test   %r10d,%r10d
 18b360c:	0f 85 80 00 00 00    	jne    18b3692 <tier0_tables_open+0x1e92>
 18b3612:	83 f8 ff             	cmp    $0xffffffff,%eax
 18b3615:	74 7b                	je     18b3692 <tier0_tables_open+0x1e92>
 18b3617:	80 f9 0f             	cmp    $0xf,%cl
 18b361a:	75 18                	jne    18b3634 <tier0_tables_open+0x1e34>
 18b361c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3620:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18b3624:	46 8b 1c a9          	mov    (%rcx,%r13,4),%r11d
 18b3628:	45 89 dd             	mov    %r11d,%r13d
 18b362b:	41 c1 ed 03          	shr    $0x3,%r13d
 18b362f:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18b3634:	80 f9 12             	cmp    $0x12,%cl
 18b3637:	75 21                	jne    18b365a <tier0_tables_open+0x1e5a>
 18b3639:	43 f6 04 2f 04       	testb  $0x4,(%r15,%r13,1)
 18b363e:	0f 84 e4 09 00 00    	je     18b4028 <tier0_tables_open+0x2828>
 18b3644:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3648:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18b364c:	46 8b 1c a9          	mov    (%rcx,%r13,4),%r11d
 18b3650:	44 89 d9             	mov    %r11d,%ecx
 18b3653:	c1 e9 03             	shr    $0x3,%ecx
 18b3656:	0f b6 0c 0e          	movzbl (%rsi,%rcx,1),%ecx
 18b365a:	41 ba 0f 00 00 00    	mov    $0xf,%r10d
 18b3660:	80 f9 05             	cmp    $0x5,%cl
 18b3663:	74 37                	je     18b369c <tier0_tables_open+0x1e9c>
 18b3665:	0f b6 c9             	movzbl %cl,%ecx
 18b3668:	83 f9 02             	cmp    $0x2,%ecx
 18b366b:	0f 85 bd 09 00 00    	jne    18b402e <tier0_tables_open+0x282e>
 18b3671:	41 83 e3 f8          	and    $0xfffffff8,%r11d
 18b3675:	b9 01 00 00 00       	mov    $0x1,%ecx
 18b367a:	41 83 fb 10          	cmp    $0x10,%r11d
 18b367e:	74 35                	je     18b36b5 <tier0_tables_open+0x1eb5>
 18b3680:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3684:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18b3688:	4a 8b 0c 19          	mov    (%rcx,%r11,1),%rcx
 18b368c:	48 c1 e1 03          	shl    $0x3,%rcx
 18b3690:	eb 1a                	jmp    18b36ac <tier0_tables_open+0x1eac>
 18b3692:	45 85 d2             	test   %r10d,%r10d
 18b3695:	74 37                	je     18b36ce <tier0_tables_open+0x1ece>
 18b3697:	e9 92 09 00 00       	jmp    18b402e <tier0_tables_open+0x282e>
 18b369c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b36a0:	41 83 e3 f8          	and    $0xfffffff8,%r11d
 18b36a4:	48 8b 49 30          	mov    0x30(%rcx),%rcx
 18b36a8:	4a 8b 0c 19          	mov    (%rcx,%r11,1),%rcx
 18b36ac:	48 85 c9             	test   %rcx,%rcx
 18b36af:	0f 84 79 09 00 00    	je     18b402e <tier0_tables_open+0x282e>
 18b36b5:	48 39 c1             	cmp    %rax,%rcx
 18b36b8:	0f 82 70 09 00 00    	jb     18b402e <tier0_tables_open+0x282e>
 18b36be:	48 85 c0             	test   %rax,%rax
 18b36c1:	75 0b                	jne    18b36ce <tier0_tables_open+0x1ece>
 18b36c3:	41 83 79 f4 00       	cmpl   $0x0,-0xc(%r9)
 18b36c8:	0f 85 60 09 00 00    	jne    18b402e <tier0_tables_open+0x282e>
 18b36ce:	41 0f b6 01          	movzbl (%r9),%eax
 18b36d2:	4c 3b 44 24 08       	cmp    0x8(%rsp),%r8
 18b36d7:	73 0f                	jae    18b36e8 <tier0_tables_open+0x1ee8>
 18b36d9:	49 ff c0             	inc    %r8
 18b36dc:	49 83 c1 10          	add    $0x10,%r9
 18b36e0:	3c 22                	cmp    $0x22,%al
 18b36e2:	0f 82 3b fe ff ff    	jb     18b3523 <tier0_tables_open+0x1d23>
 18b36e8:	3c 22                	cmp    $0x22,%al
 18b36ea:	72 14                	jb     18b3700 <tier0_tables_open+0x1f00>
 18b36ec:	e9 26 0a 00 00       	jmp    18b4117 <tier0_tables_open+0x2917>
 18b36f1:	c6 44 24 20 20       	movb   $0x20,0x20(%rsp)
 18b36f6:	39 44 24 08          	cmp    %eax,0x8(%rsp)
 18b36fa:	0f 87 20 09 00 00    	ja     18b4020 <tier0_tables_open+0x2820>
 18b3700:	48 8b 04 24          	mov    (%rsp),%rax
 18b3704:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
 18b3709:	48 8b 40 28          	mov    0x28(%rax),%rax
 18b370d:	46 8b 3c a0          	mov    (%rax,%r12,4),%r15d
 18b3711:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 18b3718:	0f 84 bd 01 00 00    	je     18b38db <tier0_tables_open+0x20db>
 18b371e:	83 7c 24 08 01       	cmpl   $0x1,0x8(%rsp)
 18b3723:	75 07                	jne    18b372c <tier0_tables_open+0x1f2c>
 18b3725:	31 c0                	xor    %eax,%eax
 18b3727:	e9 18 01 00 00       	jmp    18b3844 <tier0_tables_open+0x2044>
 18b372c:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 18b3733:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b3738:	83 e1 fe             	and    $0xfffffffe,%ecx
 18b373b:	48 8d b4 24 cd 01 00 00 	lea    0x1cd(%rsp),%rsi
 18b3743:	89 c2                	mov    %eax,%edx
 18b3745:	31 c0                	xor    %eax,%eax
 18b3747:	48 8b 1c 24          	mov    (%rsp),%rbx
 18b374b:	8b 7e e3             	mov    -0x1d(%rsi),%edi
 18b374e:	44 8b 46 eb          	mov    -0x15(%rsi),%r8d
 18b3752:	41 89 d3             	mov    %edx,%r11d
 18b3755:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 18b375b:	4c 8b 93 b0 00 00 00 	mov    0xb0(%rbx),%r10
 18b3762:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18b3766:	45 0f 44 c5          	cmove  %r13d,%r8d
 18b376a:	41 0f 95 c1          	setne  %r9b
 18b376e:	45 00 c9             	add    %r9b,%r9b
 18b3771:	43 89 3c 9a          	mov    %edi,(%r10,%r11,4)
 18b3775:	8b 7e e7             	mov    -0x19(%rsi),%edi
 18b3778:	4c 8b 93 b8 00 00 00 	mov    0xb8(%rbx),%r10
 18b377f:	43 89 3c 9a          	mov    %edi,(%r10,%r11,4)
 18b3783:	48 8b bb c0 00 00 00 	mov    0xc0(%rbx),%rdi
 18b378a:	46 89 04 9f          	mov    %r8d,(%rdi,%r11,4)
 18b378e:	0f b6 7e ef          	movzbl -0x11(%rsi),%edi
 18b3792:	4c 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%r8
 18b3799:	43 88 3c 18          	mov    %dil,(%r8,%r11,1)
 18b379d:	44 0a 4e f0          	or     -0x10(%rsi),%r9b
 18b37a1:	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
 18b37a8:	46 88 0c 1f          	mov    %r9b,(%rdi,%r11,1)
 18b37ac:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
 18b37b0:	48 8b bb d8 00 00 00 	mov    0xd8(%rbx),%rdi
 18b37b7:	4a c7 04 df 00 00 00 00 	movq   $0x0,(%rdi,%r11,8)
 18b37bf:	8b 7e f3             	mov    -0xd(%rsi),%edi
 18b37c2:	4c 8b 9b b0 00 00 00 	mov    0xb0(%rbx),%r11
 18b37c9:	44 8b 46 fb          	mov    -0x5(%rsi),%r8d
 18b37cd:	43 89 3c 8b          	mov    %edi,(%r11,%r9,4)
 18b37d1:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18b37d5:	8b 7e f7             	mov    -0x9(%rsi),%edi
 18b37d8:	4c 8b 9b b8 00 00 00 	mov    0xb8(%rbx),%r11
 18b37df:	45 0f 44 c5          	cmove  %r13d,%r8d
 18b37e3:	41 0f 95 c2          	setne  %r10b
 18b37e7:	48 83 c0 02          	add    $0x2,%rax
 18b37eb:	83 c2 02             	add    $0x2,%edx
 18b37ee:	45 00 d2             	add    %r10b,%r10b
 18b37f1:	43 89 3c 8b          	mov    %edi,(%r11,%r9,4)
 18b37f5:	48 8b bb c0 00 00 00 	mov    0xc0(%rbx),%rdi
 18b37fc:	46 89 04 8f          	mov    %r8d,(%rdi,%r9,4)
 18b3800:	0f b6 7e ff          	movzbl -0x1(%rsi),%edi
 18b3804:	4c 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%r8
 18b380b:	43 88 3c 08          	mov    %dil,(%r8,%r9,1)
 18b380f:	44 0a 16             	or     (%rsi),%r10b
 18b3812:	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
 18b3819:	48 83 c6 20          	add    $0x20,%rsi
 18b381d:	46 88 14 0f          	mov    %r10b,(%rdi,%r9,1)
 18b3821:	48 8b bb d8 00 00 00 	mov    0xd8(%rbx),%rdi
 18b3828:	4a c7 04 cf 00 00 00 00 	movq   $0x0,(%rdi,%r9,8)
 18b3830:	48 39 c1             	cmp    %rax,%rcx
 18b3833:	0f 85 0e ff ff ff    	jne    18b3747 <tier0_tables_open+0x1f47>
 18b3839:	f6 44 24 08 01       	testb  $0x1,0x8(%rsp)
 18b383e:	0f 84 8d 00 00 00    	je     18b38d1 <tier0_tables_open+0x20d1>
 18b3844:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b3848:	48 89 c1             	mov    %rax,%rcx
 18b384b:	48 c1 e1 04          	shl    $0x4,%rcx
 18b384f:	03 84 24 80 00 00 00 	add    0x80(%rsp),%eax
 18b3856:	8b 94 0c b0 01 00 00 	mov    0x1b0(%rsp,%rcx,1),%edx
 18b385d:	8b b4 0c b8 01 00 00 	mov    0x1b8(%rsp,%rcx,1),%esi
 18b3864:	4d 8b 81 b0 00 00 00 	mov    0xb0(%r9),%r8
 18b386b:	83 fe ff             	cmp    $0xffffffff,%esi
 18b386e:	40 0f 95 c7          	setne  %dil
 18b3872:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 18b3876:	8b 94 0c b4 01 00 00 	mov    0x1b4(%rsp,%rcx,1),%edx
 18b387d:	4d 8b 81 b8 00 00 00 	mov    0xb8(%r9),%r8
 18b3884:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 18b3888:	ba 00 00 00 00       	mov    $0x0,%edx
 18b388d:	0f 44 f2             	cmove  %edx,%esi
 18b3890:	49 8b 91 c0 00 00 00 	mov    0xc0(%r9),%rdx
 18b3897:	40 00 ff             	add    %dil,%dil
 18b389a:	89 34 82             	mov    %esi,(%rdx,%rax,4)
 18b389d:	0f b6 94 0c bc 01 00 00 	movzbl 0x1bc(%rsp,%rcx,1),%edx
 18b38a5:	49 8b b1 c8 00 00 00 	mov    0xc8(%r9),%rsi
 18b38ac:	88 14 06             	mov    %dl,(%rsi,%rax,1)
 18b38af:	40 0a bc 0c bd 01 00 00 	or     0x1bd(%rsp,%rcx,1),%dil
 18b38b7:	49 8b 91 d0 00 00 00 	mov    0xd0(%r9),%rdx
 18b38be:	40 88 3c 02          	mov    %dil,(%rdx,%rax,1)
 18b38c2:	49 8b 89 d8 00 00 00 	mov    0xd8(%r9),%rcx
 18b38c9:	48 c7 04 c1 00 00 00 00 	movq   $0x0,(%rcx,%rax,8)
 18b38d1:	48 8b 04 24          	mov    (%rsp),%rax
 18b38d5:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
 18b38db:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b38e0:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b38e4:	8b b4 24 80 00 00 00 	mov    0x80(%rsp),%esi
 18b38eb:	01 d0                	add    %edx,%eax
 18b38ed:	89 81 e0 00 00 00    	mov    %eax,0xe0(%rcx)
 18b38f3:	48 8b 41 70          	mov    0x70(%rcx),%rax
 18b38f7:	42 89 34 b8          	mov    %esi,(%rax,%r15,4)
 18b38fb:	48 8b 41 78          	mov    0x78(%rcx),%rax
 18b38ff:	42 89 14 b8          	mov    %edx,(%rax,%r15,4)
 18b3903:	0f b6 54 24 20       	movzbl 0x20(%rsp),%edx
 18b3908:	48 8b 81 88 00 00 00 	mov    0x88(%rcx),%rax
 18b390f:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18b3914:	48 8b 81 90 00 00 00 	mov    0x90(%rcx),%rax
 18b391b:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18b3920:	48 8b 81 98 00 00 00 	mov    0x98(%rcx),%rax
 18b3927:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18b392c:	48 8b 41 10          	mov    0x10(%rcx),%rax
 18b3930:	42 08 14 20          	or     %dl,(%rax,%r12,1)
 18b3934:	4c 8b a9 08 01 00 00 	mov    0x108(%rcx),%r13
 18b393b:	4d 85 ed             	test   %r13,%r13
 18b393e:	0f 84 e4 00 00 00    	je     18b3a28 <tier0_tables_open+0x2228>
 18b3944:	41 80 7d 4c 00       	cmpb   $0x0,0x4c(%r13)
 18b3949:	0f 85 d9 00 00 00    	jne    18b3a28 <tier0_tables_open+0x2228>
 18b394f:	41 8b 45 08          	mov    0x8(%r13),%eax
 18b3953:	41 3b 45 0c          	cmp    0xc(%r13),%eax
 18b3957:	75 0a                	jne    18b3963 <tier0_tables_open+0x2163>
 18b3959:	41 c6 45 4c 01       	movb   $0x1,0x4c(%r13)
 18b395e:	e9 c5 00 00 00       	jmp    18b3a28 <tier0_tables_open+0x2228>
 18b3963:	41 8b 6d 28          	mov    0x28(%r13),%ebp
 18b3967:	41 8b 4d 2c          	mov    0x2c(%r13),%ecx
 18b396b:	29 e9                	sub    %ebp,%ecx
 18b396d:	39 4c 24 08          	cmp    %ecx,0x8(%rsp)
 18b3971:	41 0f 97 45 4c       	seta   0x4c(%r13)
 18b3976:	0f 87 ac 00 00 00    	ja     18b3a28 <tier0_tables_open+0x2228>
 18b397c:	c4 c1 7b 10 45 30    	vmovsd 0x30(%r13),%xmm0
 18b3982:	41 ff 45 34          	incl   0x34(%r13)
 18b3986:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
 18b398b:	c5 f8 29 84 24 80 00 00 00 	vmovaps %xmm0,0x80(%rsp)
 18b3994:	74 2e                	je     18b39c4 <tier0_tables_open+0x21c4>
 18b3996:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
 18b399b:	48 89 ef             	mov    %rbp,%rdi
 18b399e:	48 c1 e7 04          	shl    $0x4,%rdi
 18b39a2:	49 03 7d 20          	add    0x20(%r13),%rdi
 18b39a6:	48 8d b4 24 b0 01 00 00 	lea    0x1b0(%rsp),%rsi
 18b39ae:	48 89 da             	mov    %rbx,%rdx
 18b39b1:	48 c1 e2 04          	shl    $0x4,%rdx
 18b39b5:	e8 96 0a eb fe       	call   764450 <memcpy@plt>
 18b39ba:	41 01 5d 28          	add    %ebx,0x28(%r13)
 18b39be:	41 8b 45 08          	mov    0x8(%r13),%eax
 18b39c2:	eb 02                	jmp    18b39c6 <tier0_tables_open+0x21c6>
 18b39c4:	31 ed                	xor    %ebp,%ebp
 18b39c6:	c5 f9 6f 84 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm0
 18b39cf:	8d 50 01             	lea    0x1(%rax),%edx
 18b39d2:	49 8b 4d 00          	mov    0x0(%r13),%rcx
 18b39d6:	8b 74 24 40          	mov    0x40(%rsp),%esi
 18b39da:	89 c0                	mov    %eax,%eax
 18b39dc:	48 6b c0 38          	imul   $0x38,%rax,%rax
 18b39e0:	41 89 55 08          	mov    %edx,0x8(%r13)
 18b39e4:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b39e9:	c5 f9 d6 04 01       	vmovq  %xmm0,(%rcx,%rax,1)
 18b39ee:	c6 44 01 08 03       	movb   $0x3,0x8(%rcx,%rax,1)
 18b39f3:	48 c7 44 01 09 00 00 00 00 	movq   $0x0,0x9(%rcx,%rax,1)
 18b39fc:	48 c7 44 01 10 00 00 00 00 	movq   $0x0,0x10(%rcx,%rax,1)
 18b3a05:	89 6c 01 18          	mov    %ebp,0x18(%rcx,%rax,1)
 18b3a09:	89 54 01 1c          	mov    %edx,0x1c(%rcx,%rax,1)
 18b3a0d:	89 74 01 20          	mov    %esi,0x20(%rcx,%rax,1)
 18b3a11:	48 c7 44 01 24 00 00 00 00 	movq   $0x0,0x24(%rcx,%rax,1)
 18b3a1a:	44 89 7c 01 2c       	mov    %r15d,0x2c(%rcx,%rax,1)
 18b3a1f:	48 c7 44 01 30 00 00 00 00 	movq   $0x0,0x30(%rcx,%rax,1)
 18b3a28:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3a2c:	b8 0d 00 00 00       	mov    $0xd,%eax
 18b3a31:	44 3b 61 48          	cmp    0x48(%rcx),%r12d
 18b3a35:	0f 83 31 06 00 00    	jae    18b406c <tier0_tables_open+0x286c>
 18b3a3b:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3a3f:	48 8b 09             	mov    (%rcx),%rcx
 18b3a42:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 18b3a47:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18b3a4c:	84 c9                	test   %cl,%cl
 18b3a4e:	0f 84 18 06 00 00    	je     18b406c <tier0_tables_open+0x286c>
 18b3a54:	80 e1 fe             	and    $0xfe,%cl
 18b3a57:	80 f9 10             	cmp    $0x10,%cl
 18b3a5a:	0f 85 0c 06 00 00    	jne    18b406c <tier0_tables_open+0x286c>
 18b3a60:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3a64:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 18b3a68:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18b3a6d:	80 e1 24             	and    $0x24,%cl
 18b3a70:	80 f9 20             	cmp    $0x20,%cl
 18b3a73:	0f 85 f3 05 00 00    	jne    18b406c <tier0_tables_open+0x286c>
 18b3a79:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b3a7d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18b3a82:	bb 00 00 00 00       	mov    $0x0,%ebx
 18b3a87:	48 8b 47 28          	mov    0x28(%rdi),%rax
 18b3a8b:	48 8b 8f 90 00 00 00 	mov    0x90(%rdi),%rcx
 18b3a92:	46 8b 04 a0          	mov    (%rax,%r12,4),%r8d
 18b3a96:	48 8b 47 38          	mov    0x38(%rdi),%rax
 18b3a9a:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18b3a9f:	48 8b 47 60          	mov    0x60(%rdi),%rax
 18b3aa3:	42 0f b6 0c 01       	movzbl (%rcx,%r8,1),%ecx
 18b3aa8:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 18b3aad:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
 18b3ab1:	89 ca                	mov    %ecx,%edx
 18b3ab3:	01 f1                	add    %esi,%ecx
 18b3ab5:	c1 e8 03             	shr    $0x3,%eax
 18b3ab8:	84 d2                	test   %dl,%dl
 18b3aba:	ba 08 00 00 00       	mov    $0x8,%edx
 18b3abf:	c4 e2 f1 f7 ca       	shlx   %rcx,%rdx,%rcx
 18b3ac4:	48 0f 45 d9          	cmovne %rcx,%rbx
 18b3ac8:	48 8b 4f 78          	mov    0x78(%rdi),%rcx
 18b3acc:	46 8b 0c 81          	mov    (%rcx,%r8,4),%r9d
 18b3ad0:	48 8b 8f 98 00 00 00 	mov    0x98(%rdi),%rcx
 18b3ad7:	42 0f b6 0c 01       	movzbl (%rcx,%r8,1),%ecx
 18b3adc:	4c 89 8c 24 d8 00 00 00 	mov    %r9,0xd8(%rsp)
 18b3ae4:	89 ca                	mov    %ecx,%edx
 18b3ae6:	01 f1                	add    %esi,%ecx
 18b3ae8:	84 d2                	test   %dl,%dl
 18b3aea:	ba 01 00 00 00       	mov    $0x1,%edx
 18b3aef:	c4 e2 f1 f7 f2       	shlx   %rcx,%rdx,%rsi
 18b3af4:	48 0f 44 f2          	cmove  %rdx,%rsi
 18b3af8:	4d 85 c9             	test   %r9,%r9
 18b3afb:	0f 84 58 03 00 00    	je     18b3e59 <tier0_tables_open+0x2659>
 18b3b01:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3b05:	45 31 e4             	xor    %r12d,%r12d
 18b3b08:	45 31 db             	xor    %r11d,%r11d
 18b3b0b:	45 31 c9             	xor    %r9d,%r9d
 18b3b0e:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18b3b1a:	48 8b b9 b8 00 00 00 	mov    0xb8(%rcx),%rdi
 18b3b21:	4c 8b 41 20          	mov    0x20(%rcx),%r8
 18b3b25:	48 8b 51 18          	mov    0x18(%rcx),%rdx
 18b3b29:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
 18b3b2e:	48 8b b9 c0 00 00 00 	mov    0xc0(%rcx),%rdi
 18b3b35:	4c 89 84 24 40 01 00 00 	mov    %r8,0x140(%rsp)
 18b3b3d:	4c 8b 81 c8 00 00 00 	mov    0xc8(%rcx),%r8
 18b3b44:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
 18b3b49:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 18b3b4e:	48 89 bc 24 18 01 00 00 	mov    %rdi,0x118(%rsp)
 18b3b56:	48 8b b9 b0 00 00 00 	mov    0xb0(%rcx),%rdi
 18b3b5d:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 18b3b65:	4c 8b 81 d0 00 00 00 	mov    0xd0(%rcx),%r8
 18b3b6c:	48 89 bc 24 10 01 00 00 	mov    %rdi,0x110(%rsp)
 18b3b74:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
 18b3b79:	4c 89 84 24 b8 00 00 00 	mov    %r8,0xb8(%rsp)
 18b3b81:	4c 8b 81 d8 00 00 00 	mov    0xd8(%rcx),%r8
 18b3b88:	0f b6 04 07          	movzbl (%rdi,%rax,1),%eax
 18b3b8c:	4c 89 84 24 48 01 00 00 	mov    %r8,0x148(%rsp)
 18b3b94:	88 44 24 08          	mov    %al,0x8(%rsp)
 18b3b98:	48 8b 81 88 00 00 00 	mov    0x88(%rcx),%rax
 18b3b9f:	48 8b 49 70          	mov    0x70(%rcx),%rcx
 18b3ba3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
 18b3ba7:	88 44 24 48          	mov    %al,0x48(%rsp)
 18b3bab:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18b3bae:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 18b3bb3:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18b3bb8:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18b3bbd:	42 8d 2c 20          	lea    (%rax,%r12,1),%ebp
 18b3bc1:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18b3bc6:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
 18b3bc9:	c1 e8 03             	shr    $0x3,%eax
 18b3bcc:	80 3c 01 0f          	cmpb   $0xf,(%rcx,%rax,1)
 18b3bd0:	48 89 c1             	mov    %rax,%rcx
 18b3bd3:	75 0e                	jne    18b3be3 <tier0_tables_open+0x23e3>
 18b3bd5:	48 8b 8c 24 40 01 00 00 	mov    0x140(%rsp),%rcx
 18b3bdd:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
 18b3be0:	c1 e9 03             	shr    $0x3,%ecx
 18b3be3:	48 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%rdx
 18b3beb:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
 18b3bf0:	41 ba 08 00 00 00    	mov    $0x8,%r10d
 18b3bf6:	0f b6 3c 2a          	movzbl (%rdx,%rbp,1),%edi
 18b3bfa:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 18b3c02:	41 0f 95 c5          	setne  %r13b
 18b3c06:	44 0f b6 04 2a       	movzbl (%rdx,%rbp,1),%r8d
 18b3c0b:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18b3c10:	48 8b 14 ca          	mov    (%rdx,%rcx,8),%rdx
 18b3c14:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18b3c19:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
 18b3c1d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18b3c22:	48 c1 e2 03          	shl    $0x3,%rdx
 18b3c26:	40 84 ff             	test   %dil,%dil
 18b3c29:	8d 0c 39             	lea    (%rcx,%rdi,1),%ecx
 18b3c2c:	c4 c2 f1 f7 fa       	shlx   %rcx,%r10,%rdi
 18b3c31:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b3c36:	48 0f 45 cf          	cmovne %rdi,%rcx
 18b3c3a:	45 08 c5             	or     %r8b,%r13b
 18b3c3d:	c4 c2 f9 f7 c2       	shlx   %rax,%r10,%rax
 18b3c42:	41 f6 c0 02          	test   $0x2,%r8b
 18b3c46:	0f 85 89 00 00 00    	jne    18b3cd5 <tier0_tables_open+0x24d5>
 18b3c4c:	48 39 c8             	cmp    %rcx,%rax
 18b3c4f:	48 0f 46 c1          	cmovbe %rcx,%rax
 18b3c53:	48 83 f9 09          	cmp    $0x9,%rcx
 18b3c57:	73 05                	jae    18b3c5e <tier0_tables_open+0x245e>
 18b3c59:	b9 08 00 00 00       	mov    $0x8,%ecx
 18b3c5e:	48 85 db             	test   %rbx,%rbx
 18b3c61:	74 10                	je     18b3c73 <tier0_tables_open+0x2473>
 18b3c63:	48 39 d8             	cmp    %rbx,%rax
 18b3c66:	72 03                	jb     18b3c6b <tier0_tables_open+0x246b>
 18b3c68:	48 89 d8             	mov    %rbx,%rax
 18b3c6b:	48 39 d9             	cmp    %rbx,%rcx
 18b3c6e:	72 03                	jb     18b3c73 <tier0_tables_open+0x2473>
 18b3c70:	48 89 d9             	mov    %rbx,%rcx
 18b3c73:	44 0f b6 7c 24 08    	movzbl 0x8(%rsp),%r15d
 18b3c79:	41 f6 c5 01          	test   $0x1,%r13b
 18b3c7d:	48 89 c7             	mov    %rax,%rdi
 18b3c80:	49 8d 43 ff          	lea    -0x1(%r11),%rax
 18b3c84:	48 0f 45 f9          	cmovne %rcx,%rdi
 18b3c88:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
 18b3c8f:	49 89 fa             	mov    %rdi,%r10
 18b3c92:	41 80 ff 11          	cmp    $0x11,%r15b
 18b3c96:	48 0f 44 c1          	cmove  %rcx,%rax
 18b3c9a:	49 f7 da             	neg    %r10
 18b3c9d:	48 01 f8             	add    %rdi,%rax
 18b3ca0:	49 21 c2             	and    %rax,%r10
 18b3ca3:	4c 89 d1             	mov    %r10,%rcx
 18b3ca6:	48 01 d1             	add    %rdx,%rcx
 18b3ca9:	41 0f 93 c0          	setae  %r8b
 18b3cad:	0f 99 c0             	setns  %al
 18b3cb0:	44 20 c0             	and    %r8b,%al
 18b3cb3:	41 80 ff 11          	cmp    $0x11,%r15b
 18b3cb7:	0f 85 b2 00 00 00    	jne    18b3d6f <tier0_tables_open+0x256f>
 18b3cbd:	49 39 d3             	cmp    %rdx,%r11
 18b3cc0:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18b3ccc:	4c 0f 46 da          	cmovbe %rdx,%r11
 18b3cd0:	e9 1f 01 00 00       	jmp    18b3df4 <tier0_tables_open+0x25f4>
 18b3cd5:	48 8b bc 24 18 01 00 00 	mov    0x118(%rsp),%rdi
 18b3cdd:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 18b3ce3:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18b3ce9:	44 8b 04 af          	mov    (%rdi,%rbp,4),%r8d
 18b3ced:	4c 89 df             	mov    %r11,%rdi
 18b3cf0:	48 2b bc 24 80 00 00 00 	sub    0x80(%rsp),%rdi
 18b3cf8:	80 7c 24 08 11       	cmpb   $0x11,0x8(%rsp)
 18b3cfd:	4c 0f 45 d7          	cmovne %rdi,%r10
 18b3d01:	45 85 c0             	test   %r8d,%r8d
 18b3d04:	48 89 c7             	mov    %rax,%rdi
 18b3d07:	49 0f 45 ff          	cmovne %r15,%rdi
 18b3d0b:	41 f6 c5 01          	test   $0x1,%r13b
 18b3d0f:	48 0f 44 f8          	cmove  %rax,%rdi
 18b3d13:	48 85 c9             	test   %rcx,%rcx
 18b3d16:	74 0e                	je     18b3d26 <tier0_tables_open+0x2526>
 18b3d18:	48 39 cf             	cmp    %rcx,%rdi
 18b3d1b:	48 0f 46 f9          	cmovbe %rcx,%rdi
 18b3d1f:	48 39 c8             	cmp    %rcx,%rax
 18b3d22:	48 0f 46 c1          	cmovbe %rcx,%rax
 18b3d26:	48 85 db             	test   %rbx,%rbx
 18b3d29:	74 19                	je     18b3d44 <tier0_tables_open+0x2544>
 18b3d2b:	45 85 c0             	test   %r8d,%r8d
 18b3d2e:	74 14                	je     18b3d44 <tier0_tables_open+0x2544>
 18b3d30:	41 f6 c5 01          	test   $0x1,%r13b
 18b3d34:	48 0f 45 f8          	cmovne %rax,%rdi
 18b3d38:	48 39 df             	cmp    %rbx,%rdi
 18b3d3b:	72 03                	jb     18b3d40 <tier0_tables_open+0x2540>
 18b3d3d:	48 89 df             	mov    %rbx,%rdi
 18b3d40:	b0 01                	mov    $0x1,%al
 18b3d42:	eb 3e                	jmp    18b3d82 <tier0_tables_open+0x2582>
 18b3d44:	4d 85 c0             	test   %r8,%r8
 18b3d47:	74 16                	je     18b3d5f <tier0_tables_open+0x255f>
 18b3d49:	b0 01                	mov    $0x1,%al
 18b3d4b:	48 85 db             	test   %rbx,%rbx
 18b3d4e:	75 32                	jne    18b3d82 <tier0_tables_open+0x2582>
 18b3d50:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 18b3d54:	4c 21 d0             	and    %r10,%rax
 18b3d57:	4c 01 c0             	add    %r8,%rax
 18b3d5a:	48 39 d0             	cmp    %rdx,%rax
 18b3d5d:	76 21                	jbe    18b3d80 <tier0_tables_open+0x2580>
 18b3d5f:	49 8d 44 3a ff       	lea    -0x1(%r10,%rdi,1),%rax
 18b3d64:	49 89 fa             	mov    %rdi,%r10
 18b3d67:	49 f7 da             	neg    %r10
 18b3d6a:	49 21 c2             	and    %rax,%r10
 18b3d6d:	eb 30                	jmp    18b3d9f <tier0_tables_open+0x259f>
 18b3d6f:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18b3d7b:	49 89 cb             	mov    %rcx,%r11
 18b3d7e:	eb 74                	jmp    18b3df4 <tier0_tables_open+0x25f4>
 18b3d80:	31 c0                	xor    %eax,%eax
 18b3d82:	48 39 d9             	cmp    %rbx,%rcx
 18b3d85:	0f 97 c2             	seta   %dl
 18b3d88:	48 85 c9             	test   %rcx,%rcx
 18b3d8b:	74 12                	je     18b3d9f <tier0_tables_open+0x259f>
 18b3d8d:	20 c2                	and    %al,%dl
 18b3d8f:	75 0e                	jne    18b3d9f <tier0_tables_open+0x259f>
 18b3d91:	49 8d 44 0a ff       	lea    -0x1(%r10,%rcx,1),%rax
 18b3d96:	48 f7 d9             	neg    %rcx
 18b3d99:	48 21 c1             	and    %rax,%rcx
 18b3d9c:	49 89 ca             	mov    %rcx,%r10
 18b3d9f:	48 8b 84 24 10 01 00 00 	mov    0x110(%rsp),%rax
 18b3da7:	83 3c a8 00          	cmpl   $0x0,(%rax,%rbp,4)
 18b3dab:	b8 01 00 00 00       	mov    $0x1,%eax
 18b3db0:	48 0f 44 f8          	cmove  %rax,%rdi
 18b3db4:	80 7c 24 08 11       	cmpb   $0x11,0x8(%rsp)
 18b3db9:	75 1d                	jne    18b3dd8 <tier0_tables_open+0x25d8>
 18b3dbb:	49 83 c0 07          	add    $0x7,%r8
 18b3dbf:	48 b8 f8 ff ff ff 01 00 00 00 	movabs $0x1fffffff8,%rax
 18b3dc9:	49 21 c0             	and    %rax,%r8
 18b3dcc:	4d 39 c3             	cmp    %r8,%r11
 18b3dcf:	77 03                	ja     18b3dd4 <tier0_tables_open+0x25d4>
 18b3dd1:	4d 89 c3             	mov    %r8,%r11
 18b3dd4:	b0 01                	mov    $0x1,%al
 18b3dd6:	eb 1c                	jmp    18b3df4 <tier0_tables_open+0x25f4>
 18b3dd8:	4f 8d 5c 02 07       	lea    0x7(%r10,%r8,1),%r11
 18b3ddd:	49 83 e3 f8          	and    $0xfffffffffffffff8,%r11
 18b3de1:	4c 89 d9             	mov    %r11,%rcx
 18b3de4:	4c 29 d1             	sub    %r10,%rcx
 18b3de7:	4c 29 c1             	sub    %r8,%rcx
 18b3dea:	b0 01                	mov    $0x1,%al
 18b3dec:	48 89 8c 24 80 00 00 00 	mov    %rcx,0x80(%rsp)
 18b3df4:	48 8b 8c 24 48 01 00 00 	mov    0x148(%rsp),%rcx
 18b3dfc:	4d 39 d9             	cmp    %r11,%r9
 18b3dff:	4d 0f 46 cb          	cmovbe %r11,%r9
 18b3e03:	48 c1 ef 03          	shr    $0x3,%rdi
 18b3e07:	48 39 fe             	cmp    %rdi,%rsi
 18b3e0a:	48 0f 46 f7          	cmovbe %rdi,%rsi
 18b3e0e:	4d 85 db             	test   %r11,%r11
 18b3e11:	4c 89 14 e9          	mov    %r10,(%rcx,%rbp,8)
 18b3e15:	0f 99 c1             	setns  %cl
 18b3e18:	20 c1                	and    %al,%cl
 18b3e1a:	80 f9 01             	cmp    $0x1,%cl
 18b3e1d:	75 11                	jne    18b3e30 <tier0_tables_open+0x2630>
 18b3e1f:	49 ff c4             	inc    %r12
 18b3e22:	4c 3b a4 24 d8 00 00 00 	cmp    0xd8(%rsp),%r12
 18b3e2a:	0f 82 83 fd ff ff    	jb     18b3bb3 <tier0_tables_open+0x23b3>
 18b3e30:	84 c9                	test   %cl,%cl
 18b3e32:	0f 84 2f 02 00 00    	je     18b4067 <tier0_tables_open+0x2867>
 18b3e38:	48 8b 04 24          	mov    (%rsp),%rax
 18b3e3c:	49 ff c9             	dec    %r9
 18b3e3f:	48 8b 48 38          	mov    0x38(%rax),%rcx
 18b3e43:	48 8b 40 60          	mov    0x60(%rax),%rax
 18b3e47:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 18b3e4c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 18b3e51:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18b3e54:	c1 e8 03             	shr    $0x3,%eax
 18b3e57:	eb 07                	jmp    18b3e60 <tier0_tables_open+0x2660>
 18b3e59:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
 18b3e60:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 18b3e65:	31 c9                	xor    %ecx,%ecx
 18b3e67:	f3 48 0f bc ce       	tzcnt  %rsi,%rcx
 18b3e6c:	49 8d 14 f1          	lea    (%r9,%rsi,8),%rdx
 18b3e70:	48 c1 e6 03          	shl    $0x3,%rsi
 18b3e74:	48 f7 de             	neg    %rsi
 18b3e77:	48 21 d6             	and    %rdx,%rsi
 18b3e7a:	48 c1 ee 03          	shr    $0x3,%rsi
 18b3e7e:	48 89 34 c7          	mov    %rsi,(%rdi,%rax,8)
 18b3e82:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b3e86:	48 8b 57 18          	mov    0x18(%rdi),%rdx
 18b3e8a:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
 18b3e8d:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 18b3e92:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
 18b3e96:	80 0c 01 04          	orb    $0x4,(%rcx,%rax,1)
 18b3e9a:	8b 87 a8 00 00 00    	mov    0xa8(%rdi),%eax
 18b3ea0:	ff c0                	inc    %eax
 18b3ea2:	89 87 a8 00 00 00    	mov    %eax,0xa8(%rdi)
 18b3ea8:	48 8b 8f 80 00 00 00 	mov    0x80(%rdi),%rcx
 18b3eaf:	89 04 91             	mov    %eax,(%rcx,%rdx,4)
 18b3eb2:	48 8b 87 08 01 00 00 	mov    0x108(%rdi),%rax
 18b3eb9:	48 85 c0             	test   %rax,%rax
 18b3ebc:	74 74                	je     18b3f32 <tier0_tables_open+0x2732>
 18b3ebe:	80 78 4c 00          	cmpb   $0x0,0x4c(%rax)
 18b3ec2:	75 6e                	jne    18b3f32 <tier0_tables_open+0x2732>
 18b3ec4:	8b 48 08             	mov    0x8(%rax),%ecx
 18b3ec7:	3b 48 0c             	cmp    0xc(%rax),%ecx
 18b3eca:	75 06                	jne    18b3ed2 <tier0_tables_open+0x26d2>
 18b3ecc:	c6 40 4c 01          	movb   $0x1,0x4c(%rax)
 18b3ed0:	eb 60                	jmp    18b3f32 <tier0_tables_open+0x2732>
 18b3ed2:	48 8b 14 24          	mov    (%rsp),%rdx
 18b3ed6:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 18b3edb:	8d 71 01             	lea    0x1(%rcx),%esi
 18b3ede:	48 6b c9 38          	imul   $0x38,%rcx,%rcx
 18b3ee2:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b3ee6:	48 8b 52 60          	mov    0x60(%rdx),%rdx
 18b3eea:	42 8b 14 82          	mov    (%rdx,%r8,4),%edx
 18b3eee:	c6 40 4c 00          	movb   $0x0,0x4c(%rax)
 18b3ef2:	89 70 08             	mov    %esi,0x8(%rax)
 18b3ef5:	48 8b 30             	mov    (%rax),%rsi
 18b3ef8:	48 8b 78 30          	mov    0x30(%rax),%rdi
 18b3efc:	ff 40 34             	incl   0x34(%rax)
 18b3eff:	48 89 3c 0e          	mov    %rdi,(%rsi,%rcx,1)
 18b3f03:	c6 44 0e 08 04       	movb   $0x4,0x8(%rsi,%rcx,1)
 18b3f08:	c5 fa 7f 44 0e 09    	vmovdqu %xmm0,0x9(%rsi,%rcx,1)
 18b3f0e:	48 c7 44 0e 18 00 00 00 00 	movq   $0x0,0x18(%rsi,%rcx,1)
 18b3f17:	89 54 0e 20          	mov    %edx,0x20(%rsi,%rcx,1)
 18b3f1b:	48 c7 44 0e 24 00 00 00 00 	movq   $0x0,0x24(%rsi,%rcx,1)
 18b3f24:	44 89 44 0e 2c       	mov    %r8d,0x2c(%rsi,%rcx,1)
 18b3f29:	48 c7 44 0e 30 00 00 00 00 	movq   $0x0,0x30(%rsi,%rcx,1)
 18b3f32:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b3f37:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3f3b:	8b 40 68             	mov    0x68(%rax),%eax
 18b3f3e:	48 8b 11             	mov    (%rcx),%rdx
 18b3f41:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18b3f45:	c1 e8 03             	shr    $0x3,%eax
 18b3f48:	80 3c 02 0f          	cmpb   $0xf,(%rdx,%rax,1)
 18b3f4c:	48 89 c2             	mov    %rax,%rdx
 18b3f4f:	75 0e                	jne    18b3f5f <tier0_tables_open+0x275f>
 18b3f51:	48 8b 14 24          	mov    (%rsp),%rdx
 18b3f55:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18b3f59:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18b3f5c:	c1 ea 03             	shr    $0x3,%edx
 18b3f5f:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18b3f64:	8b 76 5c             	mov    0x5c(%rsi),%esi
 18b3f67:	48 39 34 d1          	cmp    %rsi,(%rcx,%rdx,8)
 18b3f6b:	0f 85 e7 00 00 00    	jne    18b4058 <tier0_tables_open+0x2858>
 18b3f71:	48 8b 14 24          	mov    (%rsp),%rdx
 18b3f75:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
 18b3f79:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
 18b3f7d:	b9 01 00 00 00       	mov    $0x1,%ecx
 18b3f82:	c4 e2 79 f7 c1       	shlx   %eax,%ecx,%eax
 18b3f87:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b3f8c:	8b 49 60             	mov    0x60(%rcx),%ecx
 18b3f8f:	ff 82 60 1f 00 00    	incl   0x1f60(%rdx)
 18b3f95:	48 83 7c 24 68 39    	cmpq   $0x39,0x68(%rsp)
 18b3f9b:	77 0d                	ja     18b3faa <tier0_tables_open+0x27aa>
 18b3f9d:	48 ff 44 24 68       	incq   0x68(%rsp)
 18b3fa2:	39 c8                	cmp    %ecx,%eax
 18b3fa4:	0f 84 9f f1 ff ff    	je     18b3149 <tier0_tables_open+0x1949>
 18b3faa:	39 c8                	cmp    %ecx,%eax
 18b3fac:	0f 85 7d ed ff ff    	jne    18b2d2f <tier0_tables_open+0x152f>
 18b3fb2:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18b3fbb:	4d 85 e4             	test   %r12,%r12
 18b3fbe:	0f 84 d2 00 00 00    	je     18b4096 <tier0_tables_open+0x2896>
 18b3fc4:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18b3fcd:	48 89 84 24 58 01 00 00 	mov    %rax,0x158(%rsp)
 18b3fd5:	e9 81 01 00 00       	jmp    18b415b <tier0_tables_open+0x295b>
 18b3fda:	c5 f8 77             	vzeroupper
 18b3fdd:	e8 fe fa ea fe       	call   763ae0 <__stack_chk_fail@plt>
 18b3fe2:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b3fe6:	48 8b 81 08 01 00 00 	mov    0x108(%rcx),%rax
 18b3fed:	c7 81 00 01 00 00 01 00 00 00 	movl   $0x1,0x100(%rcx)
 18b3ff7:	48 85 c0             	test   %rax,%rax
 18b3ffa:	74 16                	je     18b4012 <tier0_tables_open+0x2812>
 18b3ffc:	c6 40 3c 01          	movb   $0x1,0x3c(%rax)
 18b4000:	48 8b 48 30          	mov    0x30(%rax),%rcx
 18b4004:	48 89 48 40          	mov    %rcx,0x40(%rax)
 18b4008:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%rax)
 18b400f:	ff 40 34             	incl   0x34(%rax)
 18b4012:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b4017:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
 18b401e:	eb 38                	jmp    18b4058 <tier0_tables_open+0x2858>
 18b4020:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18b4026:	eb 06                	jmp    18b402e <tier0_tables_open+0x282e>
 18b4028:	41 ba 0f 00 00 00    	mov    $0xf,%r10d
 18b402e:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b4032:	48 8b 81 08 01 00 00 	mov    0x108(%rcx),%rax
 18b4039:	44 89 91 00 01 00 00 	mov    %r10d,0x100(%rcx)
 18b4040:	48 85 c0             	test   %rax,%rax
 18b4043:	74 13                	je     18b4058 <tier0_tables_open+0x2858>
 18b4045:	c6 40 3c 01          	movb   $0x1,0x3c(%rax)
 18b4049:	48 8b 48 30          	mov    0x30(%rax),%rcx
 18b404d:	48 89 48 40          	mov    %rcx,0x40(%rax)
 18b4051:	44 89 50 48          	mov    %r10d,0x48(%rax)
 18b4055:	ff 40 34             	incl   0x34(%rax)
 18b4058:	48 8b 04 24          	mov    (%rsp),%rax
 18b405c:	ff 80 60 1f 00 00    	incl   0x1f60(%rax)
 18b4062:	e9 c8 ec ff ff       	jmp    18b2d2f <tier0_tables_open+0x152f>
 18b4067:	b8 05 00 00 00       	mov    $0x5,%eax
 18b406c:	48 8b 14 24          	mov    (%rsp),%rdx
 18b4070:	48 8b 8a 08 01 00 00 	mov    0x108(%rdx),%rcx
 18b4077:	89 82 00 01 00 00    	mov    %eax,0x100(%rdx)
 18b407d:	48 85 c9             	test   %rcx,%rcx
 18b4080:	74 d6                	je     18b4058 <tier0_tables_open+0x2858>
 18b4082:	c6 41 3c 01          	movb   $0x1,0x3c(%rcx)
 18b4086:	48 8b 51 30          	mov    0x30(%rcx),%rdx
 18b408a:	48 89 51 40          	mov    %rdx,0x40(%rcx)
 18b408e:	89 41 48             	mov    %eax,0x48(%rcx)
 18b4091:	ff 41 34             	incl   0x34(%rcx)
 18b4094:	eb c2                	jmp    18b4058 <tier0_tables_open+0x2858>
 18b4096:	49 bf 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r15
 18b40a0:	ba 03 00 00 00       	mov    $0x3,%edx
 18b40a5:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b40aa:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b40b0:	45 31 ed             	xor    %r13d,%r13d
 18b40b3:	31 ff                	xor    %edi,%edi
 18b40b5:	45 31 c9             	xor    %r9d,%r9d
 18b40b8:	4c 89 fe             	mov    %r15,%rsi
 18b40bb:	e8 80 04 eb fe       	call   764540 <mmap@plt>
 18b40c0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b40c4:	74 5c                	je     18b4122 <tier0_tables_open+0x2922>
 18b40c6:	4c 8d a0 ff ff 20 00 	lea    0x20ffff(%rax),%r12
 18b40cd:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b40d2:	48 89 c7             	mov    %rax,%rdi
 18b40d5:	49 81 e4 00 00 e0 ff 	and    $0xffffffffffe00000,%r12
 18b40dc:	4d 89 e5             	mov    %r12,%r13
 18b40df:	49 29 c5             	sub    %rax,%r13
 18b40e2:	4c 89 ee             	mov    %r13,%rsi
 18b40e5:	49 8d ad 00 00 ff ff 	lea    -0x10000(%r13),%rbp
 18b40ec:	e8 ff 03 eb fe       	call   7644f0 <madvise@plt>
 18b40f1:	4c 89 fe             	mov    %r15,%rsi
 18b40f4:	4c 29 ee             	sub    %r13,%rsi
 18b40f7:	ba 0e 00 00 00       	mov    $0xe,%edx
 18b40fc:	4c 89 e7             	mov    %r12,%rdi
 18b40ff:	e8 ec 03 eb fe       	call   7644f0 <madvise@plt>
 18b4104:	49 81 c7 00 00 e0 ff 	add    $0xffffffffffe00000,%r15
 18b410b:	49 81 c4 00 00 ff ff 	add    $0xffffffffffff0000,%r12
 18b4112:	4d 89 fd             	mov    %r15,%r13
 18b4115:	eb 10                	jmp    18b4127 <tier0_tables_open+0x2927>
 18b4117:	41 ba 0c 00 00 00    	mov    $0xc,%r10d
 18b411d:	e9 0c ff ff ff       	jmp    18b402e <tier0_tables_open+0x282e>
 18b4122:	45 31 e4             	xor    %r12d,%r12d
 18b4125:	31 ed                	xor    %ebp,%ebp
 18b4127:	64 4c 89 24 25 10 ff ff ff 	mov    %r12,%fs:0xffffffffffffff10
 18b4130:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18b413d:	64 4c 89 2c 25 20 ff ff ff 	mov    %r13,%fs:0xffffffffffffff20
 18b4146:	64 48 89 2c 25 28 ff ff ff 	mov    %rbp,%fs:0xffffffffffffff28
 18b414f:	48 c7 84 24 58 01 00 00 00 00 00 00 	movq   $0x0,0x158(%rsp)
 18b415b:	48 8b 04 24          	mov    (%rsp),%rax
 18b415f:	48 8b 8c 24 58 01 00 00 	mov    0x158(%rsp),%rcx
 18b4167:	44 8b 68 48          	mov    0x48(%rax),%r13d
 18b416b:	4a 8d 04 21          	lea    (%rcx,%r12,1),%rax
 18b416f:	4a 8d 4c 21 03       	lea    0x3(%rcx,%r12,1),%rcx
 18b4174:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 18b4178:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
 18b417d:	48 39 c1             	cmp    %rax,%rcx
 18b4180:	72 6f                	jb     18b41f1 <tier0_tables_open+0x29f1>
 18b4182:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18b4187:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 18b4190:	4a 8d 04 ad 00 00 00 00 	lea    0x0(,%r13,4),%rax
 18b4198:	4c 29 e2             	sub    %r12,%rdx
 18b419b:	48 89 ce             	mov    %rcx,%rsi
 18b419e:	48 29 d6             	sub    %rdx,%rsi
 18b41a1:	40 0f 92 c7          	setb   %dil
 18b41a5:	48 39 f0             	cmp    %rsi,%rax
 18b41a8:	40 0f 97 c6          	seta   %sil
 18b41ac:	40 08 fe             	or     %dil,%sil
 18b41af:	75 40                	jne    18b41f1 <tier0_tables_open+0x29f1>
 18b41b1:	48 01 c2             	add    %rax,%rdx
 18b41b4:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
 18b41ba:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18b41c3:	74 2c                	je     18b41f1 <tier0_tables_open+0x29f1>
 18b41c5:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18b41ca:	48 01 c2             	add    %rax,%rdx
 18b41cd:	48 89 94 24 60 01 00 00 	mov    %rdx,0x160(%rsp)
 18b41d5:	4c 29 e2             	sub    %r12,%rdx
 18b41d8:	48 29 d1             	sub    %rdx,%rcx
 18b41db:	40 0f 92 c6          	setb   %sil
 18b41df:	48 39 c8             	cmp    %rcx,%rax
 18b41e2:	0f 97 c1             	seta   %cl
 18b41e5:	40 08 f1             	or     %sil,%cl
 18b41e8:	80 f9 01             	cmp    $0x1,%cl
 18b41eb:	0f 85 f1 04 00 00    	jne    18b46e2 <tier0_tables_open+0x2ee2>
 18b41f1:	48 8b 04 24          	mov    (%rsp),%rax
 18b41f5:	83 b8 c0 01 00 00 00 	cmpl   $0x0,0x1c0(%rax)
 18b41fc:	0f 95 c0             	setne  %al
 18b41ff:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18b4203:	41 83 fd 02          	cmp    $0x2,%r13d
 18b4207:	0f 82 54 33 00 00    	jb     18b7561 <tier0_tables_open+0x5d61>
 18b420d:	b8 01 00 00 00       	mov    $0x1,%eax
 18b4212:	49 83 fd 02          	cmp    $0x2,%r13
 18b4216:	0f 84 08 02 00 00    	je     18b4424 <tier0_tables_open+0x2c24>
 18b421c:	49 8d 4d ff          	lea    -0x1(%r13),%rcx
 18b4220:	48 89 ca             	mov    %rcx,%rdx
 18b4223:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
 18b4227:	48 f7 da             	neg    %rdx
 18b422a:	eb 1b                	jmp    18b4247 <tier0_tables_open+0x2a47>
 18b422c:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b4234:	48 8d 74 02 02       	lea    0x2(%rdx,%rax,1),%rsi
 18b4239:	48 83 c0 02          	add    $0x2,%rax
 18b423d:	48 83 fe 01          	cmp    $0x1,%rsi
 18b4241:	0f 84 d4 01 00 00    	je     18b441b <tier0_tables_open+0x2c1b>
 18b4247:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
 18b424c:	74 09                	je     18b4257 <tier0_tables_open+0x2a57>
 18b424e:	40 b6 01             	mov    $0x1,%sil
 18b4251:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b4255:	eb dd                	jmp    18b4234 <tier0_tables_open+0x2a34>
 18b4257:	48 8b 34 24          	mov    (%rsp),%rsi
 18b425b:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18b4262:	f6 44 86 01 80       	testb  $0x80,0x1(%rsi,%rax,4)
 18b4267:	0f 85 ae 00 00 00    	jne    18b431b <tier0_tables_open+0x2b1b>
 18b426d:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4271:	89 c7                	mov    %eax,%edi
 18b4273:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18b4279:	48 8b 36             	mov    (%rsi),%rsi
 18b427c:	44 0f b6 0c 3e       	movzbl (%rsi,%rdi,1),%r9d
 18b4281:	41 80 f9 0f          	cmp    $0xf,%r9b
 18b4285:	75 14                	jne    18b429b <tier0_tables_open+0x2a9b>
 18b4287:	4c 8b 04 24          	mov    (%rsp),%r8
 18b428b:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b428f:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18b4293:	c1 ef 03             	shr    $0x3,%edi
 18b4296:	44 0f b6 0c 3e       	movzbl (%rsi,%rdi,1),%r9d
 18b429b:	45 0f b6 d1          	movzbl %r9b,%r10d
 18b429f:	45 31 c0             	xor    %r8d,%r8d
 18b42a2:	45 8d 5a f7          	lea    -0x9(%r10),%r11d
 18b42a6:	41 83 fb 03          	cmp    $0x3,%r11d
 18b42aa:	72 72                	jb     18b431e <tier0_tables_open+0x2b1e>
 18b42ac:	45 85 d2             	test   %r10d,%r10d
 18b42af:	74 6d                	je     18b431e <tier0_tables_open+0x2b1e>
 18b42b1:	41 83 fa 01          	cmp    $0x1,%r10d
 18b42b5:	74 1b                	je     18b42d2 <tier0_tables_open+0x2ad2>
 18b42b7:	45 31 c0             	xor    %r8d,%r8d
 18b42ba:	45 84 c9             	test   %r9b,%r9b
 18b42bd:	74 5f                	je     18b431e <tier0_tables_open+0x2b1e>
 18b42bf:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b42c3:	4d 8b 49 10          	mov    0x10(%r9),%r9
 18b42c7:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
 18b42cc:	40 80 e7 04          	and    $0x4,%dil
 18b42d0:	74 4c                	je     18b431e <tier0_tables_open+0x2b1e>
 18b42d2:	80 3c 06 0e          	cmpb   $0xe,(%rsi,%rax,1)
 18b42d6:	0f 85 27 01 00 00    	jne    18b4403 <tier0_tables_open+0x2c03>
 18b42dc:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b42e0:	4c 8b 47 20          	mov    0x20(%rdi),%r8
 18b42e4:	41 8b 3c 80          	mov    (%r8,%rax,4),%edi
 18b42e8:	c1 ef 03             	shr    $0x3,%edi
 18b42eb:	80 3c 3e 0f          	cmpb   $0xf,(%rsi,%rdi,1)
 18b42ef:	75 07                	jne    18b42f8 <tier0_tables_open+0x2af8>
 18b42f1:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18b42f5:	c1 ef 03             	shr    $0x3,%edi
 18b42f8:	48 8b 34 24          	mov    (%rsp),%rsi
 18b42fc:	48 8b 76 38          	mov    0x38(%rsi),%rsi
 18b4300:	48 83 3c fe 00       	cmpq   $0x0,(%rsi,%rdi,8)
 18b4305:	41 0f 94 c0          	sete   %r8b
 18b4309:	40 b6 01             	mov    $0x1,%sil
 18b430c:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b4310:	45 84 c0             	test   %r8b,%r8b
 18b4313:	0f 85 1b ff ff ff    	jne    18b4234 <tier0_tables_open+0x2a34>
 18b4319:	eb 13                	jmp    18b432e <tier0_tables_open+0x2b2e>
 18b431b:	45 31 c0             	xor    %r8d,%r8d
 18b431e:	40 b6 01             	mov    $0x1,%sil
 18b4321:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b4325:	45 84 c0             	test   %r8b,%r8b
 18b4328:	0f 85 06 ff ff ff    	jne    18b4234 <tier0_tables_open+0x2a34>
 18b432e:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4332:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18b4339:	f6 44 86 05 80       	testb  $0x80,0x5(%rsi,%rax,4)
 18b433e:	0f 85 e8 fe ff ff    	jne    18b422c <tier0_tables_open+0x2a2c>
 18b4344:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4348:	48 8d 78 01          	lea    0x1(%rax),%rdi
 18b434c:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18b4352:	48 8b 36             	mov    (%rsi),%rsi
 18b4355:	44 0f b6 04 3e       	movzbl (%rsi,%rdi,1),%r8d
 18b435a:	41 80 f8 0f          	cmp    $0xf,%r8b
 18b435e:	75 14                	jne    18b4374 <tier0_tables_open+0x2b74>
 18b4360:	4c 8b 04 24          	mov    (%rsp),%r8
 18b4364:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b4368:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18b436c:	c1 ef 03             	shr    $0x3,%edi
 18b436f:	44 0f b6 04 3e       	movzbl (%rsi,%rdi,1),%r8d
 18b4374:	45 0f b6 c8          	movzbl %r8b,%r9d
 18b4378:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b4380:	45 8d 51 f7          	lea    -0x9(%r9),%r10d
 18b4384:	41 83 fa 03          	cmp    $0x3,%r10d
 18b4388:	0f 82 a6 fe ff ff    	jb     18b4234 <tier0_tables_open+0x2a34>
 18b438e:	45 85 c9             	test   %r9d,%r9d
 18b4391:	0f 84 9d fe ff ff    	je     18b4234 <tier0_tables_open+0x2a34>
 18b4397:	41 83 f9 01          	cmp    $0x1,%r9d
 18b439b:	74 28                	je     18b43c5 <tier0_tables_open+0x2bc5>
 18b439d:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b43a5:	45 84 c0             	test   %r8b,%r8b
 18b43a8:	0f 84 86 fe ff ff    	je     18b4234 <tier0_tables_open+0x2a34>
 18b43ae:	4c 8b 04 24          	mov    (%rsp),%r8
 18b43b2:	4d 8b 40 10          	mov    0x10(%r8),%r8
 18b43b6:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
 18b43bb:	40 80 e7 04          	and    $0x4,%dil
 18b43bf:	0f 84 6f fe ff ff    	je     18b4234 <tier0_tables_open+0x2a34>
 18b43c5:	80 7c 06 01 0e       	cmpb   $0xe,0x1(%rsi,%rax,1)
 18b43ca:	0f 85 5c fe ff ff    	jne    18b422c <tier0_tables_open+0x2a2c>
 18b43d0:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b43d4:	4c 8b 47 20          	mov    0x20(%rdi),%r8
 18b43d8:	41 8b 7c 80 04       	mov    0x4(%r8,%rax,4),%edi
 18b43dd:	c1 ef 03             	shr    $0x3,%edi
 18b43e0:	80 3c 3e 0f          	cmpb   $0xf,(%rsi,%rdi,1)
 18b43e4:	75 07                	jne    18b43ed <tier0_tables_open+0x2bed>
 18b43e6:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18b43ea:	c1 ef 03             	shr    $0x3,%edi
 18b43ed:	48 8b 34 24          	mov    (%rsp),%rsi
 18b43f1:	48 8b 76 38          	mov    0x38(%rsi),%rsi
 18b43f5:	48 83 3c fe 00       	cmpq   $0x0,(%rsi,%rdi,8)
 18b43fa:	40 0f 94 c6          	sete   %sil
 18b43fe:	e9 4e fe ff ff       	jmp    18b4251 <tier0_tables_open+0x2a51>
 18b4403:	45 31 c0             	xor    %r8d,%r8d
 18b4406:	40 b6 01             	mov    $0x1,%sil
 18b4409:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b440d:	45 84 c0             	test   %r8b,%r8b
 18b4410:	0f 85 1e fe ff ff    	jne    18b4234 <tier0_tables_open+0x2a34>
 18b4416:	e9 13 ff ff ff       	jmp    18b432e <tier0_tables_open+0x2b2e>
 18b441b:	f6 c1 01             	test   $0x1,%cl
 18b441e:	0f 84 c9 00 00 00    	je     18b44ed <tier0_tables_open+0x2ced>
 18b4424:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18b4429:	b1 01                	mov    $0x1,%cl
 18b442b:	89 4c 24 18          	mov    %ecx,0x18(%rsp)
 18b442f:	0f 85 b8 00 00 00    	jne    18b44ed <tier0_tables_open+0x2ced>
 18b4435:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b4439:	48 8b 89 88 01 00 00 	mov    0x188(%rcx),%rcx
 18b4440:	f6 44 81 01 80       	testb  $0x80,0x1(%rcx,%rax,4)
 18b4445:	0f 85 9a 00 00 00    	jne    18b44e5 <tier0_tables_open+0x2ce5>
 18b444b:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b444f:	89 c2                	mov    %eax,%edx
 18b4451:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18b4457:	48 8b 09             	mov    (%rcx),%rcx
 18b445a:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18b445e:	40 80 fe 0f          	cmp    $0xf,%sil
 18b4462:	75 12                	jne    18b4476 <tier0_tables_open+0x2c76>
 18b4464:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4468:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18b446c:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18b446f:	c1 ea 03             	shr    $0x3,%edx
 18b4472:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18b4476:	40 0f b6 fe          	movzbl %sil,%edi
 18b447a:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b4482:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18b4486:	41 83 f8 03          	cmp    $0x3,%r8d
 18b448a:	72 61                	jb     18b44ed <tier0_tables_open+0x2ced>
 18b448c:	85 ff                	test   %edi,%edi
 18b448e:	74 5d                	je     18b44ed <tier0_tables_open+0x2ced>
 18b4490:	83 ff 01             	cmp    $0x1,%edi
 18b4493:	74 1e                	je     18b44b3 <tier0_tables_open+0x2cb3>
 18b4495:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b449d:	40 84 f6             	test   %sil,%sil
 18b44a0:	74 4b                	je     18b44ed <tier0_tables_open+0x2ced>
 18b44a2:	48 8b 34 24          	mov    (%rsp),%rsi
 18b44a6:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 18b44aa:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
 18b44ae:	80 e2 04             	and    $0x4,%dl
 18b44b1:	74 3a                	je     18b44ed <tier0_tables_open+0x2ced>
 18b44b3:	80 3c 01 0e          	cmpb   $0xe,(%rcx,%rax,1)
 18b44b7:	75 2c                	jne    18b44e5 <tier0_tables_open+0x2ce5>
 18b44b9:	48 8b 14 24          	mov    (%rsp),%rdx
 18b44bd:	48 8b 72 20          	mov    0x20(%rdx),%rsi
 18b44c1:	48 8b 52 38          	mov    0x38(%rdx),%rdx
 18b44c5:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18b44c8:	c1 e8 03             	shr    $0x3,%eax
 18b44cb:	80 3c 01 0f          	cmpb   $0xf,(%rcx,%rax,1)
 18b44cf:	75 06                	jne    18b44d7 <tier0_tables_open+0x2cd7>
 18b44d1:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18b44d4:	c1 e8 03             	shr    $0x3,%eax
 18b44d7:	48 83 3c c2 00       	cmpq   $0x0,(%rdx,%rax,8)
 18b44dc:	0f 94 c0             	sete   %al
 18b44df:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18b44e3:	eb 08                	jmp    18b44ed <tier0_tables_open+0x2ced>
 18b44e5:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b44ed:	bd 01 00 00 00       	mov    $0x1,%ebp
 18b44f2:	45 31 ff             	xor    %r15d,%r15d
 18b44f5:	48 8d 9c 24 b0 01 00 00 	lea    0x1b0(%rsp),%rbx
 18b44fd:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18b4503:	eb 35                	jmp    18b453a <tier0_tables_open+0x2d3a>
 18b4505:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4509:	b9 01 00 00 00       	mov    $0x1,%ecx
 18b450e:	4c 89 f7             	mov    %r14,%rdi
 18b4511:	48 89 da             	mov    %rbx,%rdx
 18b4514:	e8 97 43 01 00       	call   18c88b0 <abi_classify_scalar>
 18b4519:	41 b7 01             	mov    $0x1,%r15b
 18b451c:	49 ff c4             	inc    %r12
 18b451f:	4d 39 ec             	cmp    %r13,%r12
 18b4522:	0f 95 c0             	setne  %al
 18b4525:	4c 0f 44 e5          	cmove  %rbp,%r12
 18b4529:	89 c1                	mov    %eax,%ecx
 18b452b:	44 08 f9             	or     %r15b,%cl
 18b452e:	41 20 c7             	and    %al,%r15b
 18b4531:	f6 c1 01             	test   $0x1,%cl
 18b4534:	0f 84 27 30 00 00    	je     18b7561 <tier0_tables_open+0x5d61>
 18b453a:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b453e:	42 8d 04 e5 00 00 00 00 	lea    0x0(,%r12,8),%eax
 18b4546:	89 84 24 b0 01 00 00 	mov    %eax,0x1b0(%rsp)
 18b454d:	48 8b 81 88 01 00 00 	mov    0x188(%rcx),%rax
 18b4554:	42 f6 44 a0 01 80    	testb  $0x80,0x1(%rax,%r12,4)
 18b455a:	75 c0                	jne    18b451c <tier0_tables_open+0x2d1c>
 18b455c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b4560:	44 89 e2             	mov    %r12d,%edx
 18b4563:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18b4569:	48 8b 09             	mov    (%rcx),%rcx
 18b456c:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18b4570:	40 80 fe 0f          	cmp    $0xf,%sil
 18b4574:	75 12                	jne    18b4588 <tier0_tables_open+0x2d88>
 18b4576:	48 8b 34 24          	mov    (%rsp),%rsi
 18b457a:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18b457e:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18b4581:	c1 ea 03             	shr    $0x3,%edx
 18b4584:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18b4588:	40 0f b6 fe          	movzbl %sil,%edi
 18b458c:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18b4590:	41 83 f8 03          	cmp    $0x3,%r8d
 18b4594:	72 86                	jb     18b451c <tier0_tables_open+0x2d1c>
 18b4596:	85 ff                	test   %edi,%edi
 18b4598:	74 82                	je     18b451c <tier0_tables_open+0x2d1c>
 18b459a:	83 ff 01             	cmp    $0x1,%edi
 18b459d:	74 1e                	je     18b45bd <tier0_tables_open+0x2dbd>
 18b459f:	40 84 f6             	test   %sil,%sil
 18b45a2:	0f 84 74 ff ff ff    	je     18b451c <tier0_tables_open+0x2d1c>
 18b45a8:	48 8b 34 24          	mov    (%rsp),%rsi
 18b45ac:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 18b45b0:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
 18b45b4:	80 e2 04             	and    $0x4,%dl
 18b45b7:	0f 84 5f ff ff ff    	je     18b451c <tier0_tables_open+0x2d1c>
 18b45bd:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18b45c2:	83 f9 0f             	cmp    $0xf,%ecx
 18b45c5:	77 53                	ja     18b461a <tier0_tables_open+0x2e1a>
 18b45c7:	ba 00 c1 00 00       	mov    $0xc100,%edx
 18b45cc:	0f a3 ca             	bt     %ecx,%edx
 18b45cf:	73 49                	jae    18b461a <tier0_tables_open+0x2e1a>
 18b45d1:	48 8b 14 24          	mov    (%rsp),%rdx
 18b45d5:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18b45d9:	42 8b 14 a2          	mov    (%rdx,%r12,4),%edx
 18b45dd:	89 d6                	mov    %edx,%esi
 18b45df:	c1 ee 03             	shr    $0x3,%esi
 18b45e2:	f6 44 b0 01 80       	testb  $0x80,0x1(%rax,%rsi,4)
 18b45e7:	0f 84 2f ff ff ff    	je     18b451c <tier0_tables_open+0x2d1c>
 18b45ed:	80 f9 08             	cmp    $0x8,%cl
 18b45f0:	0f 85 0f ff ff ff    	jne    18b4505 <tier0_tables_open+0x2d05>
 18b45f6:	48 8b 04 24          	mov    (%rsp),%rax
 18b45fa:	48 8b 40 38          	mov    0x38(%rax),%rax
 18b45fe:	4a 83 3c e0 00       	cmpq   $0x0,(%rax,%r12,8)
 18b4603:	0f 85 fc fe ff ff    	jne    18b4505 <tier0_tables_open+0x2d05>
 18b4609:	48 8b 34 24          	mov    (%rsp),%rsi
 18b460d:	4c 89 f7             	mov    %r14,%rdi
 18b4610:	e8 32 97 0c 00       	call   197dd47 <abi_wide_classified>
 18b4615:	e9 bb 00 00 00       	jmp    18b46d5 <tier0_tables_open+0x2ed5>
 18b461a:	80 e1 fe             	and    $0xfe,%cl
 18b461d:	80 f9 10             	cmp    $0x10,%cl
 18b4620:	0f 85 df fe ff ff    	jne    18b4505 <tier0_tables_open+0x2d05>
 18b4626:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b462a:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18b462e:	4a 8b 0c e1          	mov    (%rcx,%r12,8),%rcx
 18b4632:	48 83 f9 40          	cmp    $0x40,%rcx
 18b4636:	77 69                	ja     18b46a1 <tier0_tables_open+0x2ea1>
 18b4638:	48 8b 14 24          	mov    (%rsp),%rdx
 18b463c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 18b4640:	42 f6 04 22 40       	testb  $0x40,(%rdx,%r12,1)
 18b4645:	75 5a                	jne    18b46a1 <tier0_tables_open+0x2ea1>
 18b4647:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b464b:	48 8b 4f 28          	mov    0x28(%rdi),%rcx
 18b464f:	48 8b 57 70          	mov    0x70(%rdi),%rdx
 18b4653:	48 8b 7f 78          	mov    0x78(%rdi),%rdi
 18b4657:	42 8b 34 a1          	mov    (%rcx,%r12,4),%esi
 18b465b:	8b 0c b2             	mov    (%rdx,%rsi,4),%ecx
 18b465e:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 18b4661:	01 ce                	add    %ecx,%esi
 18b4663:	39 f1                	cmp    %esi,%ecx
 18b4665:	0f 83 9a fe ff ff    	jae    18b4505 <tier0_tables_open+0x2d05>
 18b466b:	48 8b 14 24          	mov    (%rsp),%rdx
 18b466f:	48 ff c1             	inc    %rcx
 18b4672:	89 f6                	mov    %esi,%esi
 18b4674:	48 8b 92 b8 00 00 00 	mov    0xb8(%rdx),%rdx
 18b467b:	8b 7c 8a fc          	mov    -0x4(%rdx,%rcx,4),%edi
 18b467f:	c1 ef 03             	shr    $0x3,%edi
 18b4682:	8b 3c b8             	mov    (%rax,%rdi,4),%edi
 18b4685:	66 85 ff             	test   %di,%di
 18b4688:	79 09                	jns    18b4693 <tier0_tables_open+0x2e93>
 18b468a:	48 39 f1             	cmp    %rsi,%rcx
 18b468d:	48 8d 49 01          	lea    0x1(%rcx),%rcx
 18b4691:	72 e8                	jb     18b467b <tier0_tables_open+0x2e7b>
 18b4693:	66 85 ff             	test   %di,%di
 18b4696:	0f 88 69 fe ff ff    	js     18b4505 <tier0_tables_open+0x2d05>
 18b469c:	e9 7b fe ff ff       	jmp    18b451c <tier0_tables_open+0x2d1c>
 18b46a1:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18b46a6:	75 1e                	jne    18b46c6 <tier0_tables_open+0x2ec6>
 18b46a8:	48 85 c9             	test   %rcx,%rcx
 18b46ab:	0f 85 54 fe ff ff    	jne    18b4505 <tier0_tables_open+0x2d05>
 18b46b1:	48 8b 04 24          	mov    (%rsp),%rax
 18b46b5:	48 8b 40 10          	mov    0x10(%rax),%rax
 18b46b9:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
 18b46be:	24 40                	and    $0x40,%al
 18b46c0:	0f 84 3f fe ff ff    	je     18b4505 <tier0_tables_open+0x2d05>
 18b46c6:	48 8b 34 24          	mov    (%rsp),%rsi
 18b46ca:	4c 89 f7             	mov    %r14,%rdi
 18b46cd:	44 89 e2             	mov    %r12d,%edx
 18b46d0:	e8 ad 96 0c 00       	call   197dd82 <abi_members_classified>
 18b46d5:	84 c0                	test   %al,%al
 18b46d7:	0f 85 28 fe ff ff    	jne    18b4505 <tier0_tables_open+0x2d05>
 18b46dd:	e9 3a fe ff ff       	jmp    18b451c <tier0_tables_open+0x2d1c>
 18b46e2:	48 01 c2             	add    %rax,%rdx
 18b46e5:	48 8b 04 24          	mov    (%rsp),%rax
 18b46e9:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18b46f2:	83 b8 c0 01 00 00 00 	cmpl   $0x0,0x1c0(%rax)
 18b46f9:	0f 95 c0             	setne  %al
 18b46fc:	48 83 bc 24 60 01 00 00 00 	cmpq   $0x0,0x160(%rsp)
 18b4705:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18b4709:	0f 84 f4 fa ff ff    	je     18b4203 <tier0_tables_open+0x2a03>
 18b470f:	41 83 fd 02          	cmp    $0x2,%r13d
 18b4713:	0f 82 48 2e 00 00    	jb     18b7561 <tier0_tables_open+0x5d61>
 18b4719:	49 83 fd 02          	cmp    $0x2,%r13
 18b471d:	75 14                	jne    18b4733 <tier0_tables_open+0x2f33>
 18b471f:	31 c0                	xor    %eax,%eax
 18b4721:	b9 01 00 00 00       	mov    $0x1,%ecx
 18b4726:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18b472e:	e9 81 01 00 00       	jmp    18b48b4 <tier0_tables_open+0x30b4>
 18b4733:	49 ff cd             	dec    %r13
 18b4736:	b9 01 00 00 00       	mov    $0x1,%ecx
 18b473b:	31 c0                	xor    %eax,%eax
 18b473d:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18b4745:	4c 89 ea             	mov    %r13,%rdx
 18b4748:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
 18b474c:	48 f7 da             	neg    %rdx
 18b474f:	eb 37                	jmp    18b4788 <tier0_tables_open+0x2f88>
 18b4751:	44 8b 54 24 2c       	mov    0x2c(%rsp),%r10d
 18b4756:	4c 8b 4c 24 48       	mov    0x48(%rsp),%r9
 18b475b:	44 89 d7             	mov    %r10d,%edi
 18b475e:	41 ff c2             	inc    %r10d
 18b4761:	41 83 f8 0e          	cmp    $0xe,%r8d
 18b4765:	41 89 34 b9          	mov    %esi,(%r9,%rdi,4)
 18b4769:	40 0f 94 c6          	sete   %sil
 18b476d:	44 89 54 24 2c       	mov    %r10d,0x2c(%rsp)
 18b4772:	40 08 f0             	or     %sil,%al
 18b4775:	48 8d 74 0a 02       	lea    0x2(%rdx,%rcx,1),%rsi
 18b477a:	48 83 c1 02          	add    $0x2,%rcx
 18b477e:	48 83 fe 01          	cmp    $0x1,%rsi
 18b4782:	0f 84 22 01 00 00    	je     18b48aa <tier0_tables_open+0x30aa>
 18b4788:	48 8b 34 24          	mov    (%rsp),%rsi
 18b478c:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18b4793:	f6 44 8e 01 80       	testb  $0x80,0x1(%rsi,%rcx,4)
 18b4798:	75 7e                	jne    18b4818 <tier0_tables_open+0x3018>
 18b479a:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b479e:	89 ce                	mov    %ecx,%esi
 18b47a0:	81 e6 ff ff ff 1f    	and    $0x1fffffff,%esi
 18b47a6:	4c 8b 07             	mov    (%rdi),%r8
 18b47a9:	41 0f b6 3c 30       	movzbl (%r8,%rsi,1),%edi
 18b47ae:	40 80 ff 0f          	cmp    $0xf,%dil
 18b47b2:	75 13                	jne    18b47c7 <tier0_tables_open+0x2fc7>
 18b47b4:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b47b8:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
 18b47bc:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 18b47bf:	c1 ee 03             	shr    $0x3,%esi
 18b47c2:	41 0f b6 3c 30       	movzbl (%r8,%rsi,1),%edi
 18b47c7:	40 0f b6 ff          	movzbl %dil,%edi
 18b47cb:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18b47cf:	41 83 f8 03          	cmp    $0x3,%r8d
 18b47d3:	72 43                	jb     18b4818 <tier0_tables_open+0x3018>
 18b47d5:	85 ff                	test   %edi,%edi
 18b47d7:	74 3f                	je     18b4818 <tier0_tables_open+0x3018>
 18b47d9:	83 ff 01             	cmp    $0x1,%edi
 18b47dc:	74 17                	je     18b47f5 <tier0_tables_open+0x2ff5>
 18b47de:	85 ff                	test   %edi,%edi
 18b47e0:	74 36                	je     18b4818 <tier0_tables_open+0x3018>
 18b47e2:	4c 8b 04 24          	mov    (%rsp),%r8
 18b47e6:	4d 8b 40 10          	mov    0x10(%r8),%r8
 18b47ea:	41 0f b6 34 30       	movzbl (%r8,%rsi,1),%esi
 18b47ef:	40 80 e6 04          	and    $0x4,%sil
 18b47f3:	74 23                	je     18b4818 <tier0_tables_open+0x3018>
 18b47f5:	44 8b 4c 24 2c       	mov    0x2c(%rsp),%r9d
 18b47fa:	4c 8b 44 24 48       	mov    0x48(%rsp),%r8
 18b47ff:	44 89 ce             	mov    %r9d,%esi
 18b4802:	41 ff c1             	inc    %r9d
 18b4805:	83 ff 0e             	cmp    $0xe,%edi
 18b4808:	41 89 0c b0          	mov    %ecx,(%r8,%rsi,4)
 18b480c:	40 0f 94 c6          	sete   %sil
 18b4810:	44 89 4c 24 2c       	mov    %r9d,0x2c(%rsp)
 18b4815:	40 08 f0             	or     %sil,%al
 18b4818:	48 8b 34 24          	mov    (%rsp),%rsi
 18b481c:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18b4823:	f6 44 8e 05 80       	testb  $0x80,0x5(%rsi,%rcx,4)
 18b4828:	0f 85 47 ff ff ff    	jne    18b4775 <tier0_tables_open+0x2f75>
 18b482e:	4c 8b 04 24          	mov    (%rsp),%r8
 18b4832:	48 8d 71 01          	lea    0x1(%rcx),%rsi
 18b4836:	89 f7                	mov    %esi,%edi
 18b4838:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18b483e:	4d 8b 08             	mov    (%r8),%r9
 18b4841:	45 0f b6 04 39       	movzbl (%r9,%rdi,1),%r8d
 18b4846:	41 80 f8 0f          	cmp    $0xf,%r8b
 18b484a:	75 14                	jne    18b4860 <tier0_tables_open+0x3060>
 18b484c:	4c 8b 04 24          	mov    (%rsp),%r8
 18b4850:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b4854:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18b4858:	c1 ef 03             	shr    $0x3,%edi
 18b485b:	45 0f b6 04 39       	movzbl (%r9,%rdi,1),%r8d
 18b4860:	45 0f b6 c0          	movzbl %r8b,%r8d
 18b4864:	45 8d 48 f7          	lea    -0x9(%r8),%r9d
 18b4868:	41 83 f9 03          	cmp    $0x3,%r9d
 18b486c:	0f 82 03 ff ff ff    	jb     18b4775 <tier0_tables_open+0x2f75>
 18b4872:	45 85 c0             	test   %r8d,%r8d
 18b4875:	0f 84 fa fe ff ff    	je     18b4775 <tier0_tables_open+0x2f75>
 18b487b:	41 83 f8 01          	cmp    $0x1,%r8d
 18b487f:	0f 84 cc fe ff ff    	je     18b4751 <tier0_tables_open+0x2f51>
 18b4885:	45 85 c0             	test   %r8d,%r8d
 18b4888:	0f 84 e7 fe ff ff    	je     18b4775 <tier0_tables_open+0x2f75>
 18b488e:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b4892:	4d 8b 49 10          	mov    0x10(%r9),%r9
 18b4896:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
 18b489b:	40 80 e7 04          	and    $0x4,%dil
 18b489f:	0f 85 ac fe ff ff    	jne    18b4751 <tier0_tables_open+0x2f51>
 18b48a5:	e9 cb fe ff ff       	jmp    18b4775 <tier0_tables_open+0x2f75>
 18b48aa:	41 f6 c5 01          	test   $0x1,%r13b
 18b48ae:	0f 84 87 00 00 00    	je     18b493b <tier0_tables_open+0x313b>
 18b48b4:	48 8b 14 24          	mov    (%rsp),%rdx
 18b48b8:	48 8b 92 88 01 00 00 	mov    0x188(%rdx),%rdx
 18b48bf:	f6 44 8a 01 80       	testb  $0x80,0x1(%rdx,%rcx,4)
 18b48c4:	75 75                	jne    18b493b <tier0_tables_open+0x313b>
 18b48c6:	48 8b 34 24          	mov    (%rsp),%rsi
 18b48ca:	89 ca                	mov    %ecx,%edx
 18b48cc:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18b48d2:	48 8b 3e             	mov    (%rsi),%rdi
 18b48d5:	0f b6 34 17          	movzbl (%rdi,%rdx,1),%esi
 18b48d9:	40 80 fe 0f          	cmp    $0xf,%sil
 18b48dd:	75 12                	jne    18b48f1 <tier0_tables_open+0x30f1>
 18b48df:	48 8b 34 24          	mov    (%rsp),%rsi
 18b48e3:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18b48e7:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18b48ea:	c1 ea 03             	shr    $0x3,%edx
 18b48ed:	0f b6 34 17          	movzbl (%rdi,%rdx,1),%esi
 18b48f1:	40 0f b6 f6          	movzbl %sil,%esi
 18b48f5:	8d 7e f7             	lea    -0x9(%rsi),%edi
 18b48f8:	83 ff 03             	cmp    $0x3,%edi
 18b48fb:	72 3e                	jb     18b493b <tier0_tables_open+0x313b>
 18b48fd:	85 f6                	test   %esi,%esi
 18b48ff:	74 3a                	je     18b493b <tier0_tables_open+0x313b>
 18b4901:	83 fe 01             	cmp    $0x1,%esi
 18b4904:	74 15                	je     18b491b <tier0_tables_open+0x311b>
 18b4906:	85 f6                	test   %esi,%esi
 18b4908:	74 31                	je     18b493b <tier0_tables_open+0x313b>
 18b490a:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b490e:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 18b4912:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
 18b4916:	80 e2 04             	and    $0x4,%dl
 18b4919:	74 20                	je     18b493b <tier0_tables_open+0x313b>
 18b491b:	44 8b 44 24 2c       	mov    0x2c(%rsp),%r8d
 18b4920:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 18b4925:	44 89 c2             	mov    %r8d,%edx
 18b4928:	41 ff c0             	inc    %r8d
 18b492b:	83 fe 0e             	cmp    $0xe,%esi
 18b492e:	89 0c 97             	mov    %ecx,(%rdi,%rdx,4)
 18b4931:	0f 94 c1             	sete   %cl
 18b4934:	44 89 44 24 2c       	mov    %r8d,0x2c(%rsp)
 18b4939:	08 c8                	or     %cl,%al
 18b493b:	a8 01                	test   $0x1,%al
 18b493d:	0f 84 dc 01 00 00    	je     18b4b1f <tier0_tables_open+0x331f>
 18b4943:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18b4948:	0f 84 d1 01 00 00    	je     18b4b1f <tier0_tables_open+0x331f>
 18b494e:	8b 4c 24 2c          	mov    0x2c(%rsp),%ecx
 18b4952:	89 ca                	mov    %ecx,%edx
 18b4954:	89 d0                	mov    %edx,%eax
 18b4956:	83 e0 03             	and    $0x3,%eax
 18b4959:	83 f9 04             	cmp    $0x4,%ecx
 18b495c:	73 07                	jae    18b4965 <tier0_tables_open+0x3165>
 18b495e:	31 c9                	xor    %ecx,%ecx
 18b4960:	e9 4c 01 00 00       	jmp    18b4ab1 <tier0_tables_open+0x32b1>
 18b4965:	83 e2 fc             	and    $0xfffffffc,%edx
 18b4968:	31 c9                	xor    %ecx,%ecx
 18b496a:	eb 15                	jmp    18b4981 <tier0_tables_open+0x3181>
 18b496c:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b4974:	48 83 c1 04          	add    $0x4,%rcx
 18b4978:	48 39 ca             	cmp    %rcx,%rdx
 18b497b:	0f 84 2b 01 00 00    	je     18b4aac <tier0_tables_open+0x32ac>
 18b4981:	8b 74 24 18          	mov    0x18(%rsp),%esi
 18b4985:	40 f6 c6 01          	test   $0x1,%sil
 18b4989:	40 b6 01             	mov    $0x1,%sil
 18b498c:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b4990:	75 e2                	jne    18b4974 <tier0_tables_open+0x3174>
 18b4992:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18b4997:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b499b:	8b 34 8e             	mov    (%rsi,%rcx,4),%esi
 18b499e:	48 8b 3f             	mov    (%rdi),%rdi
 18b49a1:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18b49a5:	75 2b                	jne    18b49d2 <tier0_tables_open+0x31d2>
 18b49a7:	4c 8b 04 24          	mov    (%rsp),%r8
 18b49ab:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b49af:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b49b3:	c1 ee 03             	shr    $0x3,%esi
 18b49b6:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18b49ba:	75 07                	jne    18b49c3 <tier0_tables_open+0x31c3>
 18b49bc:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b49c0:	c1 ee 03             	shr    $0x3,%esi
 18b49c3:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b49c7:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18b49cb:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18b49d0:	74 a2                	je     18b4974 <tier0_tables_open+0x3174>
 18b49d2:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18b49d7:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b49db:	8b 74 8e 04          	mov    0x4(%rsi,%rcx,4),%esi
 18b49df:	48 8b 3f             	mov    (%rdi),%rdi
 18b49e2:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18b49e6:	75 2f                	jne    18b4a17 <tier0_tables_open+0x3217>
 18b49e8:	4c 8b 04 24          	mov    (%rsp),%r8
 18b49ec:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b49f0:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b49f4:	c1 ee 03             	shr    $0x3,%esi
 18b49f7:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18b49fb:	75 07                	jne    18b4a04 <tier0_tables_open+0x3204>
 18b49fd:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b4a01:	c1 ee 03             	shr    $0x3,%esi
 18b4a04:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b4a08:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18b4a0c:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18b4a11:	0f 84 5d ff ff ff    	je     18b4974 <tier0_tables_open+0x3174>
 18b4a17:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18b4a1c:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b4a20:	8b 74 8e 08          	mov    0x8(%rsi,%rcx,4),%esi
 18b4a24:	48 8b 3f             	mov    (%rdi),%rdi
 18b4a27:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18b4a2b:	75 2f                	jne    18b4a5c <tier0_tables_open+0x325c>
 18b4a2d:	4c 8b 04 24          	mov    (%rsp),%r8
 18b4a31:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b4a35:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b4a39:	c1 ee 03             	shr    $0x3,%esi
 18b4a3c:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18b4a40:	75 07                	jne    18b4a49 <tier0_tables_open+0x3249>
 18b4a42:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b4a46:	c1 ee 03             	shr    $0x3,%esi
 18b4a49:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b4a4d:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18b4a51:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18b4a56:	0f 84 18 ff ff ff    	je     18b4974 <tier0_tables_open+0x3174>
 18b4a5c:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18b4a61:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b4a65:	8b 74 8e 0c          	mov    0xc(%rsi,%rcx,4),%esi
 18b4a69:	48 8b 3f             	mov    (%rdi),%rdi
 18b4a6c:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18b4a70:	0f 85 f6 fe ff ff    	jne    18b496c <tier0_tables_open+0x316c>
 18b4a76:	4c 8b 04 24          	mov    (%rsp),%r8
 18b4a7a:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b4a7e:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b4a82:	c1 ee 03             	shr    $0x3,%esi
 18b4a85:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18b4a89:	75 07                	jne    18b4a92 <tier0_tables_open+0x3292>
 18b4a8b:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b4a8f:	c1 ee 03             	shr    $0x3,%esi
 18b4a92:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b4a96:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18b4a9a:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18b4a9f:	40 0f 94 c6          	sete   %sil
 18b4aa3:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b4aa7:	e9 c8 fe ff ff       	jmp    18b4974 <tier0_tables_open+0x3174>
 18b4aac:	48 85 c0             	test   %rax,%rax
 18b4aaf:	74 6e                	je     18b4b1f <tier0_tables_open+0x331f>
 18b4ab1:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18b4ab6:	48 8d 0c 8a          	lea    (%rdx,%rcx,4),%rcx
 18b4aba:	31 d2                	xor    %edx,%edx
 18b4abc:	eb 10                	jmp    18b4ace <tier0_tables_open+0x32ce>
 18b4abe:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b4ac6:	48 ff c2             	inc    %rdx
 18b4ac9:	48 39 d0             	cmp    %rdx,%rax
 18b4acc:	74 51                	je     18b4b1f <tier0_tables_open+0x331f>
 18b4ace:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
 18b4ad3:	40 b6 01             	mov    $0x1,%sil
 18b4ad6:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b4ada:	75 ea                	jne    18b4ac6 <tier0_tables_open+0x32c6>
 18b4adc:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b4ae0:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 18b4ae3:	48 8b 3f             	mov    (%rdi),%rdi
 18b4ae6:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18b4aea:	75 d2                	jne    18b4abe <tier0_tables_open+0x32be>
 18b4aec:	4c 8b 04 24          	mov    (%rsp),%r8
 18b4af0:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b4af4:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b4af8:	c1 ee 03             	shr    $0x3,%esi
 18b4afb:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18b4aff:	75 07                	jne    18b4b08 <tier0_tables_open+0x3308>
 18b4b01:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18b4b05:	c1 ee 03             	shr    $0x3,%esi
 18b4b08:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b4b0c:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18b4b10:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18b4b15:	40 0f 94 c6          	sete   %sil
 18b4b19:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b4b1d:	eb a7                	jmp    18b4ac6 <tier0_tables_open+0x32c6>
 18b4b1f:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18b4b24:	0f 84 37 2a 00 00    	je     18b7561 <tier0_tables_open+0x5d61>
 18b4b2a:	44 8b 7c 24 2c       	mov    0x2c(%rsp),%r15d
 18b4b2f:	45 31 e4             	xor    %r12d,%r12d
 18b4b32:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18b4b3a:	c7 84 24 a0 00 00 00 00 00 00 00 	movl   $0x0,0xa0(%rsp)
 18b4b45:	eb 35                	jmp    18b4b7c <tier0_tables_open+0x337c>
 18b4b47:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 18b4b4c:	8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%esi
 18b4b53:	48 8b 94 24 60 01 00 00 	mov    0x160(%rsp),%rdx
 18b4b5b:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
 18b4b5f:	89 f1                	mov    %esi,%ecx
 18b4b61:	ff c6                	inc    %esi
 18b4b63:	89 b4 24 a0 00 00 00 	mov    %esi,0xa0(%rsp)
 18b4b6a:	c1 e0 03             	shl    $0x3,%eax
 18b4b6d:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
 18b4b70:	49 ff c4             	inc    %r12
 18b4b73:	4d 39 fc             	cmp    %r15,%r12
 18b4b76:	0f 84 64 01 00 00    	je     18b4ce0 <tier0_tables_open+0x34e0>
 18b4b7c:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 18b4b81:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4b85:	42 8b 14 a0          	mov    (%rax,%r12,4),%edx
 18b4b89:	48 8b 06             	mov    (%rsi),%rax
 18b4b8c:	0f b6 0c 10          	movzbl (%rax,%rdx,1),%ecx
 18b4b90:	83 f9 0f             	cmp    $0xf,%ecx
 18b4b93:	77 7f                	ja     18b4c14 <tier0_tables_open+0x3414>
 18b4b95:	b8 00 c1 00 00       	mov    $0xc100,%eax
 18b4b9a:	0f a3 c8             	bt     %ecx,%eax
 18b4b9d:	73 75                	jae    18b4c14 <tier0_tables_open+0x3414>
 18b4b9f:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4ba3:	48 8b 46 20          	mov    0x20(%rsi),%rax
 18b4ba7:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18b4bae:	8b 04 90             	mov    (%rax,%rdx,4),%eax
 18b4bb1:	89 c7                	mov    %eax,%edi
 18b4bb3:	c1 ef 03             	shr    $0x3,%edi
 18b4bb6:	f6 44 be 01 80       	testb  $0x80,0x1(%rsi,%rdi,4)
 18b4bbb:	75 25                	jne    18b4be2 <tier0_tables_open+0x33e2>
 18b4bbd:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18b4bc2:	8b 74 24 2c          	mov    0x2c(%rsp),%esi
 18b4bc6:	42 8b 04 a2          	mov    (%rdx,%r12,4),%eax
 18b4bca:	89 f1                	mov    %esi,%ecx
 18b4bcc:	ff c6                	inc    %esi
 18b4bce:	89 74 24 2c          	mov    %esi,0x2c(%rsp)
 18b4bd2:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
 18b4bd5:	49 ff c4             	inc    %r12
 18b4bd8:	4d 39 fc             	cmp    %r15,%r12
 18b4bdb:	75 9f                	jne    18b4b7c <tier0_tables_open+0x337c>
 18b4bdd:	e9 fe 00 00 00       	jmp    18b4ce0 <tier0_tables_open+0x34e0>
 18b4be2:	80 f9 08             	cmp    $0x8,%cl
 18b4be5:	0f 85 5c ff ff ff    	jne    18b4b47 <tier0_tables_open+0x3347>
 18b4beb:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b4bef:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18b4bf3:	48 83 3c d1 00       	cmpq   $0x0,(%rcx,%rdx,8)
 18b4bf8:	0f 85 49 ff ff ff    	jne    18b4b47 <tier0_tables_open+0x3347>
 18b4bfe:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4c02:	4c 89 f7             	mov    %r14,%rdi
 18b4c05:	89 c2                	mov    %eax,%edx
 18b4c07:	c5 f8 77             	vzeroupper
 18b4c0a:	e8 38 91 0c 00       	call   197dd47 <abi_wide_classified>
 18b4c0f:	e9 bf 00 00 00       	jmp    18b4cd3 <tier0_tables_open+0x34d3>
 18b4c14:	80 e1 fe             	and    $0xfe,%cl
 18b4c17:	80 f9 10             	cmp    $0x10,%cl
 18b4c1a:	0f 85 27 ff ff ff    	jne    18b4b47 <tier0_tables_open+0x3347>
 18b4c20:	48 8b 04 24          	mov    (%rsp),%rax
 18b4c24:	48 8b 40 38          	mov    0x38(%rax),%rax
 18b4c28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
 18b4c2c:	48 83 f8 40          	cmp    $0x40,%rax
 18b4c30:	77 6e                	ja     18b4ca0 <tier0_tables_open+0x34a0>
 18b4c32:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b4c36:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 18b4c3a:	f6 04 11 40          	testb  $0x40,(%rcx,%rdx,1)
 18b4c3e:	75 60                	jne    18b4ca0 <tier0_tables_open+0x34a0>
 18b4c40:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4c44:	48 8b 46 28          	mov    0x28(%rsi),%rax
 18b4c48:	48 8b 4e 70          	mov    0x70(%rsi),%rcx
 18b4c4c:	48 8b 7e 78          	mov    0x78(%rsi),%rdi
 18b4c50:	8b 14 90             	mov    (%rax,%rdx,4),%edx
 18b4c53:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18b4c56:	8b 34 97             	mov    (%rdi,%rdx,4),%esi
 18b4c59:	01 c6                	add    %eax,%esi
 18b4c5b:	39 f0                	cmp    %esi,%eax
 18b4c5d:	0f 83 e4 fe ff ff    	jae    18b4b47 <tier0_tables_open+0x3347>
 18b4c63:	48 8b 14 24          	mov    (%rsp),%rdx
 18b4c67:	48 ff c0             	inc    %rax
 18b4c6a:	89 f6                	mov    %esi,%esi
 18b4c6c:	48 8b 8a b8 00 00 00 	mov    0xb8(%rdx),%rcx
 18b4c73:	48 8b 92 88 01 00 00 	mov    0x188(%rdx),%rdx
 18b4c7a:	8b 7c 81 fc          	mov    -0x4(%rcx,%rax,4),%edi
 18b4c7e:	c1 ef 03             	shr    $0x3,%edi
 18b4c81:	8b 3c ba             	mov    (%rdx,%rdi,4),%edi
 18b4c84:	66 85 ff             	test   %di,%di
 18b4c87:	79 09                	jns    18b4c92 <tier0_tables_open+0x3492>
 18b4c89:	48 39 f0             	cmp    %rsi,%rax
 18b4c8c:	48 8d 40 01          	lea    0x1(%rax),%rax
 18b4c90:	72 e8                	jb     18b4c7a <tier0_tables_open+0x347a>
 18b4c92:	66 85 ff             	test   %di,%di
 18b4c95:	0f 88 ac fe ff ff    	js     18b4b47 <tier0_tables_open+0x3347>
 18b4c9b:	e9 1d ff ff ff       	jmp    18b4bbd <tier0_tables_open+0x33bd>
 18b4ca0:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18b4ca5:	75 1d                	jne    18b4cc4 <tier0_tables_open+0x34c4>
 18b4ca7:	48 85 c0             	test   %rax,%rax
 18b4caa:	0f 85 97 fe ff ff    	jne    18b4b47 <tier0_tables_open+0x3347>
 18b4cb0:	48 8b 04 24          	mov    (%rsp),%rax
 18b4cb4:	48 8b 40 10          	mov    0x10(%rax),%rax
 18b4cb8:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
 18b4cbc:	24 40                	and    $0x40,%al
 18b4cbe:	0f 84 83 fe ff ff    	je     18b4b47 <tier0_tables_open+0x3347>
 18b4cc4:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4cc8:	4c 89 f7             	mov    %r14,%rdi
 18b4ccb:	c5 f8 77             	vzeroupper
 18b4cce:	e8 af 90 0c 00       	call   197dd82 <abi_members_classified>
 18b4cd3:	84 c0                	test   %al,%al
 18b4cd5:	0f 85 6c fe ff ff    	jne    18b4b47 <tier0_tables_open+0x3347>
 18b4cdb:	e9 dd fe ff ff       	jmp    18b4bbd <tier0_tables_open+0x33bd>
 18b4ce0:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18b4ce9:	4d 85 e4             	test   %r12,%r12
 18b4cec:	74 16                	je     18b4d04 <tier0_tables_open+0x3504>
 18b4cee:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18b4cf7:	48 89 84 24 c0 00 00 00 	mov    %rax,0xc0(%rsp)
 18b4cff:	e9 c1 00 00 00       	jmp    18b4dc5 <tier0_tables_open+0x35c5>
 18b4d04:	48 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rsi
 18b4d0e:	ba 03 00 00 00       	mov    $0x3,%edx
 18b4d13:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b4d18:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b4d1e:	31 ff                	xor    %edi,%edi
 18b4d20:	45 31 c9             	xor    %r9d,%r9d
 18b4d23:	c5 f8 77             	vzeroupper
 18b4d26:	e8 15 f8 ea fe       	call   764540 <mmap@plt>
 18b4d2b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b4d2f:	74 58                	je     18b4d89 <tier0_tables_open+0x3589>
 18b4d31:	4c 8d a0 ff ff 20 00 	lea    0x20ffff(%rax),%r12
 18b4d38:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b4d3d:	48 89 c7             	mov    %rax,%rdi
 18b4d40:	49 81 e4 00 00 e0 ff 	and    $0xffffffffffe00000,%r12
 18b4d47:	4d 89 e5             	mov    %r12,%r13
 18b4d4a:	49 29 c5             	sub    %rax,%r13
 18b4d4d:	4c 89 ee             	mov    %r13,%rsi
 18b4d50:	4d 8d bd 00 00 ff ff 	lea    -0x10000(%r13),%r15
 18b4d57:	e8 94 f7 ea fe       	call   7644f0 <madvise@plt>
 18b4d5c:	48 bd 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbp
 18b4d66:	ba 0e 00 00 00       	mov    $0xe,%edx
 18b4d6b:	4c 89 e7             	mov    %r12,%rdi
 18b4d6e:	48 89 ee             	mov    %rbp,%rsi
 18b4d71:	4c 29 ee             	sub    %r13,%rsi
 18b4d74:	e8 77 f7 ea fe       	call   7644f0 <madvise@plt>
 18b4d79:	49 81 c4 00 00 ff ff 	add    $0xffffffffffff0000,%r12
 18b4d80:	48 8d 85 00 00 e0 ff 	lea    -0x200000(%rbp),%rax
 18b4d87:	eb 08                	jmp    18b4d91 <tier0_tables_open+0x3591>
 18b4d89:	45 31 e4             	xor    %r12d,%r12d
 18b4d8c:	31 c0                	xor    %eax,%eax
 18b4d8e:	45 31 ff             	xor    %r15d,%r15d
 18b4d91:	64 4c 89 24 25 10 ff ff ff 	mov    %r12,%fs:0xffffffffffffff10
 18b4d9a:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18b4da7:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 18b4db0:	64 4c 89 3c 25 28 ff ff ff 	mov    %r15,%fs:0xffffffffffffff28
 18b4db9:	48 c7 84 24 c0 00 00 00 00 00 00 00 	movq   $0x0,0xc0(%rsp)
 18b4dc5:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 18b4dcd:	4e 8d 7c 21 03       	lea    0x3(%rcx,%r12,1),%r15
 18b4dd2:	4a 8d 04 21          	lea    (%rcx,%r12,1),%rax
 18b4dd6:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 18b4dda:	49 39 c7             	cmp    %rax,%r15
 18b4ddd:	73 0f                	jae    18b4dee <tier0_tables_open+0x35ee>
 18b4ddf:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18b4de7:	31 c9                	xor    %ecx,%ecx
 18b4de9:	e9 1d 27 00 00       	jmp    18b750b <tier0_tables_open+0x5d0b>
 18b4dee:	64 48 8b 34 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rsi
 18b4df7:	4c 89 fa             	mov    %r15,%rdx
 18b4dfa:	4c 29 e2             	sub    %r12,%rdx
 18b4dfd:	31 c9                	xor    %ecx,%ecx
 18b4dff:	48 29 d6             	sub    %rdx,%rsi
 18b4e02:	0f 82 5f 04 00 00    	jb     18b5267 <tier0_tables_open+0x3a67>
 18b4e08:	8b ac 24 a0 00 00 00 	mov    0xa0(%rsp),%ebp
 18b4e0f:	48 8d 04 ad 00 00 00 00 	lea    0x0(,%rbp,4),%rax
 18b4e17:	48 8d 3c 40          	lea    (%rax,%rax,2),%rdi
 18b4e1b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18b4e23:	48 39 f7             	cmp    %rsi,%rdi
 18b4e26:	0f 87 df 26 00 00    	ja     18b750b <tier0_tables_open+0x5d0b>
 18b4e2c:	48 01 fa             	add    %rdi,%rdx
 18b4e2f:	83 bc 24 a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsp)
 18b4e37:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18b4e40:	0f 84 2e 04 00 00    	je     18b5274 <tier0_tables_open+0x3a74>
 18b4e46:	4d 85 ff             	test   %r15,%r15
 18b4e49:	0f 84 25 04 00 00    	je     18b5274 <tier0_tables_open+0x3a74>
 18b4e4f:	31 db                	xor    %ebx,%ebx
 18b4e51:	45 31 e4             	xor    %r12d,%r12d
 18b4e54:	e9 ac 00 00 00       	jmp    18b4f05 <tier0_tables_open+0x3705>
 18b4e59:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b4e5d:	42 8d 0c ad 00 00 00 00 	lea    0x0(,%r13,4),%ecx
 18b4e65:	4c 89 ef             	mov    %r13,%rdi
 18b4e68:	48 c1 e7 04          	shl    $0x4,%rdi
 18b4e6c:	49 8b 41 20          	mov    0x20(%r9),%rax
 18b4e70:	49 8b 91 80 01 00 00 	mov    0x180(%r9),%rdx
 18b4e77:	8b 04 08             	mov    (%rax,%rcx,1),%eax
 18b4e7a:	89 c6                	mov    %eax,%esi
 18b4e7c:	c1 ee 03             	shr    $0x3,%esi
 18b4e7f:	83 e0 f8             	and    $0xfffffff8,%eax
 18b4e82:	49 89 f0             	mov    %rsi,%r8
 18b4e85:	49 c1 e0 04          	shl    $0x4,%r8
 18b4e89:	c4 a1 7a 6f 04 02    	vmovdqu (%rdx,%r8,1),%xmm0
 18b4e8f:	c5 fa 7f 04 3a       	vmovdqu %xmm0,(%rdx,%rdi,1)
 18b4e94:	89 f7                	mov    %esi,%edi
 18b4e96:	c1 e7 02             	shl    $0x2,%edi
 18b4e99:	49 8b 91 88 01 00 00 	mov    0x188(%r9),%rdx
 18b4ea0:	44 8b 04 3a          	mov    (%rdx,%rdi,1),%r8d
 18b4ea4:	44 89 04 0a          	mov    %r8d,(%rdx,%rcx,1)
 18b4ea8:	49 8b 91 90 01 00 00 	mov    0x190(%r9),%rdx
 18b4eaf:	8b 3c 3a             	mov    (%rdx,%rdi,1),%edi
 18b4eb2:	89 3c 0a             	mov    %edi,(%rdx,%rcx,1)
 18b4eb5:	49 8b 89 98 01 00 00 	mov    0x198(%r9),%rcx
 18b4ebc:	0f b6 14 31          	movzbl (%rcx,%rsi,1),%edx
 18b4ec0:	42 88 14 29          	mov    %dl,(%rcx,%r13,1)
 18b4ec4:	49 8b 89 a0 01 00 00 	mov    0x1a0(%r9),%rcx
 18b4ecb:	0f b6 14 31          	movzbl (%rcx,%rsi,1),%edx
 18b4ecf:	42 8d 34 ed 00 00 00 00 	lea    0x0(,%r13,8),%esi
 18b4ed7:	42 88 14 29          	mov    %dl,(%rcx,%r13,1)
 18b4edb:	49 8b 89 a8 01 00 00 	mov    0x1a8(%r9),%rcx
 18b4ee2:	48 8b 14 01          	mov    (%rcx,%rax,1),%rdx
 18b4ee6:	48 89 14 31          	mov    %rdx,(%rcx,%rsi,1)
 18b4eea:	49 8b 89 b0 01 00 00 	mov    0x1b0(%r9),%rcx
 18b4ef1:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18b4ef5:	48 89 04 31          	mov    %rax,(%rcx,%rsi,1)
 18b4ef9:	49 ff c4             	inc    %r12
 18b4efc:	4c 39 e5             	cmp    %r12,%rbp
 18b4eff:	0f 84 8a 03 00 00    	je     18b528f <tier0_tables_open+0x3a8f>
 18b4f05:	48 8b 84 24 60 01 00 00 	mov    0x160(%rsp),%rax
 18b4f0d:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b4f11:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
 18b4f15:	48 8b 31             	mov    (%rcx),%rsi
 18b4f18:	41 89 c5             	mov    %eax,%r13d
 18b4f1b:	41 c1 ed 03          	shr    $0x3,%r13d
 18b4f1f:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18b4f24:	80 f9 0f             	cmp    $0xf,%cl
 18b4f27:	0f 84 2c ff ff ff    	je     18b4e59 <tier0_tables_open+0x3659>
 18b4f2d:	48 8b 14 24          	mov    (%rsp),%rdx
 18b4f31:	83 e0 f8             	and    $0xfffffff8,%eax
 18b4f34:	89 cf                	mov    %ecx,%edi
 18b4f36:	40 80 e7 fe          	and    $0xfe,%dil
 18b4f3a:	48 8b 52 38          	mov    0x38(%rdx),%rdx
 18b4f3e:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
 18b4f42:	40 80 ff 10          	cmp    $0x10,%dil
 18b4f46:	0f 85 b8 00 00 00    	jne    18b5004 <tier0_tables_open+0x3804>
 18b4f4c:	48 8b 14 24          	mov    (%rsp),%rdx
 18b4f50:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 18b4f54:	42 f6 04 2a 40       	testb  $0x40,(%rdx,%r13,1)
 18b4f59:	0f 85 fe 00 00 00    	jne    18b505d <tier0_tables_open+0x385d>
 18b4f5f:	48 83 f8 40          	cmp    $0x40,%rax
 18b4f63:	0f 87 f4 00 00 00    	ja     18b505d <tier0_tables_open+0x385d>
 18b4f69:	48 83 f8 11          	cmp    $0x11,%rax
 18b4f6d:	72 13                	jb     18b4f82 <tier0_tables_open+0x3782>
 18b4f6f:	48 8b 14 24          	mov    (%rsp),%rdx
 18b4f73:	8b 92 bc 01 00 00    	mov    0x1bc(%rdx),%edx
 18b4f79:	48 39 d0             	cmp    %rdx,%rax
 18b4f7c:	0f 87 db 00 00 00    	ja     18b505d <tier0_tables_open+0x385d>
 18b4f82:	48 8b 34 24          	mov    (%rsp),%rsi
 18b4f86:	80 f9 10             	cmp    $0x10,%cl
 18b4f89:	89 df                	mov    %ebx,%edi
 18b4f8b:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18b4f8f:	0f 94 c1             	sete   %cl
 18b4f92:	48 8b 56 28          	mov    0x28(%rsi),%rdx
 18b4f96:	48 8b 76 78          	mov    0x78(%rsi),%rsi
 18b4f9a:	42 8b 14 aa          	mov    (%rdx,%r13,4),%edx
 18b4f9e:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18b4fa1:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
 18b4fa7:	40 0f 92 c6          	setb   %sil
 18b4fab:	40 08 ce             	or     %cl,%sil
 18b4fae:	48 83 f8 11          	cmp    $0x11,%rax
 18b4fb2:	0f 92 c1             	setb   %cl
 18b4fb5:	41 0f 93 44 bf 0a    	setae  0xa(%r15,%rdi,4)
 18b4fbb:	45 89 2c bf          	mov    %r13d,(%r15,%rdi,4)
 18b4fbf:	41 89 54 bf 04       	mov    %edx,0x4(%r15,%rdi,4)
 18b4fc4:	40 20 f1             	and    %sil,%cl
 18b4fc7:	be 10 00 00 00       	mov    $0x10,%esi
 18b4fcc:	48 29 c6             	sub    %rax,%rsi
 18b4fcf:	b8 00 00 00 00       	mov    $0x0,%eax
 18b4fd4:	48 0f 43 c6          	cmovae %rsi,%rax
 18b4fd8:	ff c3                	inc    %ebx
 18b4fda:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18b4fe0:	62 f3 7d 08 3e 05 25 0c cc fe 01 	vpcmpltub -0x133f3db(%rip),%xmm0,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 18b4feb:	c5 fb 93 c0          	kmovd  %k0,%eax
 18b4fef:	25 fe ff 00 00       	and    $0xfffe,%eax
 18b4ff4:	66 41 89 44 bf 08    	mov    %ax,0x8(%r15,%rdi,4)
 18b4ffa:	41 88 4c bf 0b       	mov    %cl,0xb(%r15,%rdi,4)
 18b4fff:	e9 f5 fe ff ff       	jmp    18b4ef9 <tier0_tables_open+0x36f9>
 18b5004:	80 f9 08             	cmp    $0x8,%cl
 18b5007:	75 74                	jne    18b507d <tier0_tables_open+0x387d>
 18b5009:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b500d:	48 8b 79 20          	mov    0x20(%rcx),%rdi
 18b5011:	42 8b 0c af          	mov    (%rdi,%r13,4),%ecx
 18b5015:	c1 e9 03             	shr    $0x3,%ecx
 18b5018:	80 3c 0e 0f          	cmpb   $0xf,(%rsi,%rcx,1)
 18b501c:	48 89 ce             	mov    %rcx,%rsi
 18b501f:	75 06                	jne    18b5027 <tier0_tables_open+0x3827>
 18b5021:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 18b5024:	c1 ee 03             	shr    $0x3,%esi
 18b5027:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b502b:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b5031:	48 8b 7f 18          	mov    0x18(%rdi),%rdi
 18b5035:	0f b6 3c 0f          	movzbl (%rdi,%rcx,1),%edi
 18b5039:	40 80 ff 07          	cmp    $0x7,%dil
 18b503d:	c4 c2 41 f7 f8       	shlx   %edi,%r8d,%edi
 18b5042:	41 b8 7f 00 00 00    	mov    $0x7f,%r8d
 18b5048:	40 f6 d7             	not    %dil
 18b504b:	40 0f b6 ff          	movzbl %dil,%edi
 18b504f:	41 0f 43 f8          	cmovae %r8d,%edi
 18b5053:	48 83 f8 41          	cmp    $0x41,%rax
 18b5057:	0f 82 a9 00 00 00    	jb     18b5106 <tier0_tables_open+0x3906>
 18b505d:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5061:	c4 e2 79 59 05 8e b0 cc fe 	vpbroadcastq -0x1334f72(%rip),%xmm0        # 5800f8 <x86_semantics_benchmark_code.registers+0x108>
 18b506a:	4c 89 e9             	mov    %r13,%rcx
 18b506d:	48 c1 e1 04          	shl    $0x4,%rcx
 18b5071:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18b5078:	e9 34 01 00 00       	jmp    18b51b1 <tier0_tables_open+0x39b1>
 18b507d:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5081:	4c 89 f7             	mov    %r14,%rdi
 18b5084:	44 89 ea             	mov    %r13d,%edx
 18b5087:	c5 f8 77             	vzeroupper
 18b508a:	e8 81 0e 01 00       	call   18c5f10 <abi_simple>
 18b508f:	89 c6                	mov    %eax,%esi
 18b5091:	c1 ee 10             	shr    $0x10,%esi
 18b5094:	48 89 c1             	mov    %rax,%rcx
 18b5097:	48 c1 e9 08          	shr    $0x8,%rcx
 18b509b:	41 b8 77 00 00 00    	mov    $0x77,%r8d
 18b50a1:	89 f7                	mov    %esi,%edi
 18b50a3:	40 c0 e7 04          	shl    $0x4,%dil
 18b50a7:	40 08 cf             	or     %cl,%dil
 18b50aa:	40 80 fe 07          	cmp    $0x7,%sil
 18b50ae:	40 0f b6 f7          	movzbl %dil,%esi
 18b50b2:	41 0f 44 f0          	cmove  %r8d,%esi
 18b50b6:	80 f9 07             	cmp    $0x7,%cl
 18b50b9:	41 0f 44 f0          	cmove  %r8d,%esi
 18b50bd:	3c 01                	cmp    $0x1,%al
 18b50bf:	0f 85 97 00 00 00    	jne    18b515c <tier0_tables_open+0x395c>
 18b50c5:	c1 e8 18             	shr    $0x18,%eax
 18b50c8:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18b50ce:	c5 f9 fc 05 3a 0b cc fe 	vpaddb -0x133f4c6(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 18b50d6:	89 c8                	mov    %ecx,%eax
 18b50d8:	62 f3 7d 08 3e 0d 3d 0b cc fe 06 	vpcmpnleub -0x133f4c3(%rip),%xmm0,%k1        # 575c20 <x86_effects_unknown+0x1c0>
 18b50e3:	0c 60                	or     $0x60,%al
 18b50e5:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18b50eb:	89 c8                	mov    %ecx,%eax
 18b50ed:	c1 e0 04             	shl    $0x4,%eax
 18b50f0:	09 c1                	or     %eax,%ecx
 18b50f2:	0c 06                	or     $0x6,%al
 18b50f4:	62 f2 7d 08 7a c8    	vpbroadcastb %eax,%xmm1
 18b50fa:	62 f2 7d 09 7a c1    	vpbroadcastb %ecx,%xmm0{%k1}
 18b5100:	c5 f9 6c c1          	vpunpcklqdq %xmm1,%xmm0,%xmm0
 18b5104:	eb 5c                	jmp    18b5162 <tier0_tables_open+0x3962>
 18b5106:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18b510c:	c5 f9 db 05 fc 0a cc fe 	vpand  -0x133f504(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 18b5114:	48 8b 34 f2          	mov    (%rdx,%rsi,8),%rsi
 18b5118:	62 f2 7e 08 26 c8    	vptestnmb %xmm0,%xmm0,%k1
 18b511e:	48 83 f8 11          	cmp    $0x11,%rax
 18b5122:	0f 82 a1 00 00 00    	jb     18b51c9 <tier0_tables_open+0x39c9>
 18b5128:	48 39 f0             	cmp    %rsi,%rax
 18b512b:	75 13                	jne    18b5140 <tier0_tables_open+0x3940>
 18b512d:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b5131:	8b 89 bc 01 00 00    	mov    0x1bc(%rcx),%ecx
 18b5137:	48 39 c8             	cmp    %rcx,%rax
 18b513a:	0f 86 be 00 00 00    	jbe    18b51fe <tier0_tables_open+0x39fe>
 18b5140:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5144:	c5 f9 6f 05 f4 0a cc fe 	vmovdqa -0x133f50c(%rip),%xmm0        # 575c40 <x86_effects_unknown+0x1e0>
 18b514c:	4c 89 e9             	mov    %r13,%rcx
 18b514f:	48 c1 e1 04          	shl    $0x4,%rcx
 18b5153:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18b515a:	eb 55                	jmp    18b51b1 <tier0_tables_open+0x39b1>
 18b515c:	62 f2 7d 08 7a c6    	vpbroadcastb %esi,%xmm0
 18b5162:	b8 10 00 00 00       	mov    $0x10,%eax
 18b5167:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b516c:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5170:	48 29 d0             	sub    %rdx,%rax
 18b5173:	48 0f 43 c8          	cmovae %rax,%rcx
 18b5177:	66 b8 01 00          	mov    $0x1,%ax
 18b517b:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18b5181:	62 f3 75 08 3e 05 84 0a cc fe 05 	vpcmpnltub -0x133f57c(%rip),%xmm1,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 18b518c:	c4 e2 79 78 0d 2b b6 c6 fe 	vpbroadcastb -0x13949d5(%rip),%xmm1        # 5207c0 <branch_sizing_patterns+0xa30>
 18b5195:	c5 fb 92 c8          	kmovd  %eax,%k1
 18b5199:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18b51a0:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18b51a4:	62 f2 75 09 66 c0    	vpblendmb %xmm0,%xmm1,%xmm0{%k1}
 18b51aa:	4c 89 e9             	mov    %r13,%rcx
 18b51ad:	48 c1 e1 04          	shl    $0x4,%rcx
 18b51b1:	c5 f9 7f 04 08       	vmovdqa %xmm0,(%rax,%rcx,1)
 18b51b6:	4c 89 f7             	mov    %r14,%rdi
 18b51b9:	44 89 ea             	mov    %r13d,%edx
 18b51bc:	c5 f8 77             	vzeroupper
 18b51bf:	e8 7c 0f 01 00       	call   18c6140 <abi_finish>
 18b51c4:	e9 30 fd ff ff       	jmp    18b4ef9 <tier0_tables_open+0x36f9>
 18b51c9:	48 8b 14 24          	mov    (%rsp),%rdx
 18b51cd:	48 8b 52 30          	mov    0x30(%rdx),%rdx
 18b51d1:	48 85 f6             	test   %rsi,%rsi
 18b51d4:	75 30                	jne    18b5206 <tier0_tables_open+0x3a06>
 18b51d6:	4a 83 3c ea 00       	cmpq   $0x0,(%rdx,%r13,8)
 18b51db:	74 29                	je     18b5206 <tier0_tables_open+0x3a06>
 18b51dd:	48 8b 34 24          	mov    (%rsp),%rsi
 18b51e1:	c4 e2 79 78 05 d6 b5 c6 fe 	vpbroadcastb -0x1394a2a(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 18b51ea:	48 c1 e1 04          	shl    $0x4,%rcx
 18b51ee:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18b51f5:	62 f2 7d 09 66 04 08 	vpblendmb (%rax,%rcx,1),%xmm0,%xmm0{%k1}
 18b51fc:	eb ac                	jmp    18b51aa <tier0_tables_open+0x39aa>
 18b51fe:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b5202:	48 8b 51 30          	mov    0x30(%rcx),%rdx
 18b5206:	be 10 00 00 00       	mov    $0x10,%esi
 18b520b:	bf 00 00 00 00       	mov    $0x0,%edi
 18b5210:	42 8b 14 ea          	mov    (%rdx,%r13,8),%edx
 18b5214:	c5 fb 93 c9          	kmovd  %k1,%ecx
 18b5218:	48 29 c6             	sub    %rax,%rsi
 18b521b:	48 0f 43 fe          	cmovae %rsi,%rdi
 18b521f:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18b5225:	62 f3 7d 08 3e 05 e0 09 cc fe 05 	vpcmpnltub -0x133f620(%rip),%xmm0,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 18b5230:	c5 fb 93 f0          	kmovd  %k0,%esi
 18b5234:	83 ce 01             	or     $0x1,%esi
 18b5237:	21 f1                	and    %esi,%ecx
 18b5239:	48 83 f8 11          	cmp    $0x11,%rax
 18b523d:	89 d8                	mov    %ebx,%eax
 18b523f:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18b5243:	f7 d1                	not    %ecx
 18b5245:	45 89 2c 87          	mov    %r13d,(%r15,%rax,4)
 18b5249:	41 89 54 87 04       	mov    %edx,0x4(%r15,%rax,4)
 18b524e:	66 41 89 4c 87 08    	mov    %cx,0x8(%r15,%rax,4)
 18b5254:	41 0f 93 44 87 0a    	setae  0xa(%r15,%rax,4)
 18b525a:	41 0f 92 44 87 0b    	setb   0xb(%r15,%rax,4)
 18b5260:	ff c3                	inc    %ebx
 18b5262:	e9 92 fc ff ff       	jmp    18b4ef9 <tier0_tables_open+0x36f9>
 18b5267:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18b526f:	e9 97 22 00 00       	jmp    18b750b <tier0_tables_open+0x5d0b>
 18b5274:	c7 84 24 b4 00 00 00 00 00 00 00 	movl   $0x0,0xb4(%rsp)
 18b527f:	4d 85 ff             	test   %r15,%r15
 18b5282:	0f 84 b9 01 00 00    	je     18b5441 <tier0_tables_open+0x3c41>
 18b5288:	31 db                	xor    %ebx,%ebx
 18b528a:	48 89 d0             	mov    %rdx,%rax
 18b528d:	eb 1f                	jmp    18b52ae <tier0_tables_open+0x3aae>
 18b528f:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18b5298:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18b52a1:	8d 4b 03             	lea    0x3(%rbx),%ecx
 18b52a4:	c1 e9 02             	shr    $0x2,%ecx
 18b52a7:	89 8c 24 b4 00 00 00 	mov    %ecx,0xb4(%rsp)
 18b52ae:	4a 8d 54 20 03       	lea    0x3(%rax,%r12,1),%rdx
 18b52b3:	89 d9                	mov    %ebx,%ecx
 18b52b5:	48 89 8c 24 98 00 00 00 	mov    %rcx,0x98(%rsp)
 18b52bd:	4a 8d 0c 20          	lea    (%rax,%r12,1),%rcx
 18b52c1:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
 18b52c5:	48 39 ca             	cmp    %rcx,%rdx
 18b52c8:	72 54                	jb     18b531e <tier0_tables_open+0x3b1e>
 18b52ca:	64 4c 8b 04 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%r8
 18b52d3:	48 89 d6             	mov    %rdx,%rsi
 18b52d6:	4c 29 e6             	sub    %r12,%rsi
 18b52d9:	49 29 f0             	sub    %rsi,%r8
 18b52dc:	72 40                	jb     18b531e <tier0_tables_open+0x3b1e>
 18b52de:	48 8b bc 24 98 00 00 00 	mov    0x98(%rsp),%rdi
 18b52e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 18b52ec:	4c 89 4c 24 78       	mov    %r9,0x78(%rsp)
 18b52f1:	48 8d 3c bd 00 00 00 00 	lea    0x0(,%rdi,4),%rdi
 18b52f9:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18b52fd:	4c 39 c7             	cmp    %r8,%rdi
 18b5300:	77 25                	ja     18b5327 <tier0_tables_open+0x3b27>
 18b5302:	48 01 fe             	add    %rdi,%rsi
 18b5305:	48 89 d1             	mov    %rdx,%rcx
 18b5308:	48 01 f9             	add    %rdi,%rcx
 18b530b:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
 18b5310:	48 89 f0             	mov    %rsi,%rax
 18b5313:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18b531c:	eb 09                	jmp    18b5327 <tier0_tables_open+0x3b27>
 18b531e:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 18b5327:	8b 94 24 b4 00 00 00 	mov    0xb4(%rsp),%edx
 18b532e:	48 89 94 24 50 01 00 00 	mov    %rdx,0x150(%rsp)
 18b5336:	48 8d 51 07          	lea    0x7(%rcx),%rdx
 18b533a:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 18b533e:	48 39 ca             	cmp    %rcx,%rdx
 18b5341:	72 50                	jb     18b5393 <tier0_tables_open+0x3b93>
 18b5343:	64 48 8b 34 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rsi
 18b534c:	48 89 d1             	mov    %rdx,%rcx
 18b534f:	4c 29 e1             	sub    %r12,%rcx
 18b5352:	48 29 ce             	sub    %rcx,%rsi
 18b5355:	72 3c                	jb     18b5393 <tier0_tables_open+0x3b93>
 18b5357:	48 8b bc 24 50 01 00 00 	mov    0x150(%rsp),%rdi
 18b535f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18b5365:	4c 89 84 24 20 01 00 00 	mov    %r8,0x120(%rsp)
 18b536d:	48 c1 e7 04          	shl    $0x4,%rdi
 18b5371:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18b5375:	48 39 f7             	cmp    %rsi,%rdi
 18b5378:	77 25                	ja     18b539f <tier0_tables_open+0x3b9f>
 18b537a:	48 01 f9             	add    %rdi,%rcx
 18b537d:	48 89 94 24 20 01 00 00 	mov    %rdx,0x120(%rsp)
 18b5385:	48 89 c8             	mov    %rcx,%rax
 18b5388:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18b5391:	eb 0c                	jmp    18b539f <tier0_tables_open+0x3b9f>
 18b5393:	48 c7 84 24 20 01 00 00 00 00 00 00 	movq   $0x0,0x120(%rsp)
 18b539f:	48 83 bc 24 98 00 00 00 00 	cmpq   $0x0,0x98(%rsp)
 18b53a8:	74 73                	je     18b541d <tier0_tables_open+0x3c1d>
 18b53aa:	31 c9                	xor    %ecx,%ecx
 18b53ac:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 18b53b2:	0f 84 53 21 00 00    	je     18b750b <tier0_tables_open+0x5d0b>
 18b53b8:	48 83 bc 24 20 01 00 00 00 	cmpq   $0x0,0x120(%rsp)
 18b53c1:	0f 84 44 21 00 00    	je     18b750b <tier0_tables_open+0x5d0b>
 18b53c7:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
 18b53cf:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b53d3:	62 f1 fe 48 7f 84 24 70 02 00 00 	vmovdqu64 %zmm0,0x270(%rsp)
 18b53de:	62 f1 fe 48 7f 84 24 30 02 00 00 	vmovdqu64 %zmm0,0x230(%rsp)
 18b53e9:	62 f1 fe 48 7f 84 24 f0 01 00 00 	vmovdqu64 %zmm0,0x1f0(%rsp)
 18b53f4:	62 f1 fe 48 7f 84 24 b0 01 00 00 	vmovdqu64 %zmm0,0x1b0(%rsp)
 18b53ff:	c7 84 24 b0 02 00 00 00 00 00 00 	movl   $0x0,0x2b0(%rsp)
 18b540a:	89 c8                	mov    %ecx,%eax
 18b540c:	83 e0 07             	and    $0x7,%eax
 18b540f:	83 f9 08             	cmp    $0x8,%ecx
 18b5412:	73 37                	jae    18b544b <tier0_tables_open+0x3c4b>
 18b5414:	31 c9                	xor    %ecx,%ecx
 18b5416:	31 ff                	xor    %edi,%edi
 18b5418:	e9 4f 01 00 00       	jmp    18b556c <tier0_tables_open+0x3d6c>
 18b541d:	48 39 84 24 c0 00 00 00 	cmp    %rax,0xc0(%rsp)
 18b5425:	0f 87 87 21 00 00    	ja     18b75b2 <tier0_tables_open+0x5db2>
 18b542b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18b5433:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18b543c:	e9 0b 21 00 00       	jmp    18b754c <tier0_tables_open+0x5d4c>
 18b5441:	48 89 d0             	mov    %rdx,%rax
 18b5444:	31 c9                	xor    %ecx,%ecx
 18b5446:	e9 c0 20 00 00       	jmp    18b750b <tier0_tables_open+0x5d0b>
 18b544b:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18b5453:	83 e2 f8             	and    $0xfffffff8,%edx
 18b5456:	49 8d 77 04          	lea    0x4(%r15),%rsi
 18b545a:	31 c9                	xor    %ecx,%ecx
 18b545c:	31 ff                	xor    %edi,%edi
 18b545e:	eb 11                	jmp    18b5471 <tier0_tables_open+0x3c71>
 18b5460:	48 83 c1 08          	add    $0x8,%rcx
 18b5464:	48 83 c6 60          	add    $0x60,%rsi
 18b5468:	48 39 ca             	cmp    %rcx,%rdx
 18b546b:	0f 84 f6 00 00 00    	je     18b5567 <tier0_tables_open+0x3d67>
 18b5471:	44 8b 06             	mov    (%rsi),%r8d
 18b5474:	41 b9 3f 00 00 00    	mov    $0x3f,%r9d
 18b547a:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18b547e:	45 0f 43 c1          	cmovae %r9d,%r8d
 18b5482:	41 ff c0             	inc    %r8d
 18b5485:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18b548d:	41 39 f8             	cmp    %edi,%r8d
 18b5490:	77 03                	ja     18b5495 <tier0_tables_open+0x3c95>
 18b5492:	41 89 f8             	mov    %edi,%r8d
 18b5495:	8b 7e 0c             	mov    0xc(%rsi),%edi
 18b5498:	83 ff 3f             	cmp    $0x3f,%edi
 18b549b:	41 0f 43 f9          	cmovae %r9d,%edi
 18b549f:	ff c7                	inc    %edi
 18b54a1:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18b54a8:	44 39 c7             	cmp    %r8d,%edi
 18b54ab:	77 03                	ja     18b54b0 <tier0_tables_open+0x3cb0>
 18b54ad:	44 89 c7             	mov    %r8d,%edi
 18b54b0:	44 8b 46 18          	mov    0x18(%rsi),%r8d
 18b54b4:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18b54b8:	45 0f 43 c1          	cmovae %r9d,%r8d
 18b54bc:	41 ff c0             	inc    %r8d
 18b54bf:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18b54c7:	41 39 f8             	cmp    %edi,%r8d
 18b54ca:	77 03                	ja     18b54cf <tier0_tables_open+0x3ccf>
 18b54cc:	41 89 f8             	mov    %edi,%r8d
 18b54cf:	8b 7e 24             	mov    0x24(%rsi),%edi
 18b54d2:	83 ff 3f             	cmp    $0x3f,%edi
 18b54d5:	41 0f 43 f9          	cmovae %r9d,%edi
 18b54d9:	ff c7                	inc    %edi
 18b54db:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18b54e2:	44 39 c7             	cmp    %r8d,%edi
 18b54e5:	77 03                	ja     18b54ea <tier0_tables_open+0x3cea>
 18b54e7:	44 89 c7             	mov    %r8d,%edi
 18b54ea:	44 8b 46 30          	mov    0x30(%rsi),%r8d
 18b54ee:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18b54f2:	45 0f 43 c1          	cmovae %r9d,%r8d
 18b54f6:	41 ff c0             	inc    %r8d
 18b54f9:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18b5501:	41 39 f8             	cmp    %edi,%r8d
 18b5504:	77 03                	ja     18b5509 <tier0_tables_open+0x3d09>
 18b5506:	41 89 f8             	mov    %edi,%r8d
 18b5509:	8b 7e 3c             	mov    0x3c(%rsi),%edi
 18b550c:	83 ff 3f             	cmp    $0x3f,%edi
 18b550f:	41 0f 43 f9          	cmovae %r9d,%edi
 18b5513:	ff c7                	inc    %edi
 18b5515:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18b551c:	44 39 c7             	cmp    %r8d,%edi
 18b551f:	77 03                	ja     18b5524 <tier0_tables_open+0x3d24>
 18b5521:	44 89 c7             	mov    %r8d,%edi
 18b5524:	44 8b 46 48          	mov    0x48(%rsi),%r8d
 18b5528:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18b552c:	45 0f 43 c1          	cmovae %r9d,%r8d
 18b5530:	41 ff c0             	inc    %r8d
 18b5533:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18b553b:	41 39 f8             	cmp    %edi,%r8d
 18b553e:	77 03                	ja     18b5543 <tier0_tables_open+0x3d43>
 18b5540:	41 89 f8             	mov    %edi,%r8d
 18b5543:	8b 7e 54             	mov    0x54(%rsi),%edi
 18b5546:	83 ff 3f             	cmp    $0x3f,%edi
 18b5549:	41 0f 43 f9          	cmovae %r9d,%edi
 18b554d:	ff c7                	inc    %edi
 18b554f:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18b5556:	44 39 c7             	cmp    %r8d,%edi
 18b5559:	0f 87 01 ff ff ff    	ja     18b5460 <tier0_tables_open+0x3c60>
 18b555f:	44 89 c7             	mov    %r8d,%edi
 18b5562:	e9 f9 fe ff ff       	jmp    18b5460 <tier0_tables_open+0x3c60>
 18b5567:	48 85 c0             	test   %rax,%rax
 18b556a:	74 3b                	je     18b55a7 <tier0_tables_open+0x3da7>
 18b556c:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 18b5570:	c1 e0 02             	shl    $0x2,%eax
 18b5573:	31 d2                	xor    %edx,%edx
 18b5575:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18b5579:	49 8d 4c 8f 04       	lea    0x4(%r15,%rcx,4),%rcx
 18b557e:	89 fe                	mov    %edi,%esi
 18b5580:	8b 3c 11             	mov    (%rcx,%rdx,1),%edi
 18b5583:	41 b8 3f 00 00 00    	mov    $0x3f,%r8d
 18b5589:	83 ff 3f             	cmp    $0x3f,%edi
 18b558c:	41 0f 43 f8          	cmovae %r8d,%edi
 18b5590:	ff c7                	inc    %edi
 18b5592:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18b5599:	39 f7                	cmp    %esi,%edi
 18b559b:	0f 46 fe             	cmovbe %esi,%edi
 18b559e:	48 83 c2 0c          	add    $0xc,%rdx
 18b55a2:	48 39 d0             	cmp    %rdx,%rax
 18b55a5:	75 d7                	jne    18b557e <tier0_tables_open+0x3d7e>
 18b55a7:	89 fa                	mov    %edi,%edx
 18b55a9:	89 d0                	mov    %edx,%eax
 18b55ab:	83 e0 07             	and    $0x7,%eax
 18b55ae:	ff cf                	dec    %edi
 18b55b0:	83 ff 07             	cmp    $0x7,%edi
 18b55b3:	73 09                	jae    18b55be <tier0_tables_open+0x3dbe>
 18b55b5:	31 c9                	xor    %ecx,%ecx
 18b55b7:	31 f6                	xor    %esi,%esi
 18b55b9:	e9 88 00 00 00       	jmp    18b5646 <tier0_tables_open+0x3e46>
 18b55be:	81 e2 f8 ff ff 7f    	and    $0x7ffffff8,%edx
 18b55c4:	31 c9                	xor    %ecx,%ecx
 18b55c6:	31 f6                	xor    %esi,%esi
 18b55c8:	03 8c b4 b4 01 00 00 	add    0x1b4(%rsp,%rsi,4),%ecx
 18b55cf:	89 8c b4 b4 01 00 00 	mov    %ecx,0x1b4(%rsp,%rsi,4)
 18b55d6:	03 8c b4 b8 01 00 00 	add    0x1b8(%rsp,%rsi,4),%ecx
 18b55dd:	89 8c b4 b8 01 00 00 	mov    %ecx,0x1b8(%rsp,%rsi,4)
 18b55e4:	03 8c b4 bc 01 00 00 	add    0x1bc(%rsp,%rsi,4),%ecx
 18b55eb:	89 8c b4 bc 01 00 00 	mov    %ecx,0x1bc(%rsp,%rsi,4)
 18b55f2:	03 8c b4 c0 01 00 00 	add    0x1c0(%rsp,%rsi,4),%ecx
 18b55f9:	89 8c b4 c0 01 00 00 	mov    %ecx,0x1c0(%rsp,%rsi,4)
 18b5600:	03 8c b4 c4 01 00 00 	add    0x1c4(%rsp,%rsi,4),%ecx
 18b5607:	89 8c b4 c4 01 00 00 	mov    %ecx,0x1c4(%rsp,%rsi,4)
 18b560e:	03 8c b4 c8 01 00 00 	add    0x1c8(%rsp,%rsi,4),%ecx
 18b5615:	89 8c b4 c8 01 00 00 	mov    %ecx,0x1c8(%rsp,%rsi,4)
 18b561c:	03 8c b4 cc 01 00 00 	add    0x1cc(%rsp,%rsi,4),%ecx
 18b5623:	89 8c b4 cc 01 00 00 	mov    %ecx,0x1cc(%rsp,%rsi,4)
 18b562a:	03 8c b4 d0 01 00 00 	add    0x1d0(%rsp,%rsi,4),%ecx
 18b5631:	89 8c b4 d0 01 00 00 	mov    %ecx,0x1d0(%rsp,%rsi,4)
 18b5638:	48 83 c6 08          	add    $0x8,%rsi
 18b563c:	48 39 f2             	cmp    %rsi,%rdx
 18b563f:	75 87                	jne    18b55c8 <tier0_tables_open+0x3dc8>
 18b5641:	48 85 c0             	test   %rax,%rax
 18b5644:	74 1c                	je     18b5662 <tier0_tables_open+0x3e62>
 18b5646:	48 8d 94 24 b4 01 00 00 	lea    0x1b4(%rsp),%rdx
 18b564e:	48 8d 14 b2          	lea    (%rdx,%rsi,4),%rdx
 18b5652:	31 f6                	xor    %esi,%esi
 18b5654:	03 0c b2             	add    (%rdx,%rsi,4),%ecx
 18b5657:	89 0c b2             	mov    %ecx,(%rdx,%rsi,4)
 18b565a:	48 ff c6             	inc    %rsi
 18b565d:	48 39 f0             	cmp    %rsi,%rax
 18b5660:	75 f2                	jne    18b5654 <tier0_tables_open+0x3e54>
 18b5662:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
 18b566a:	89 c8                	mov    %ecx,%eax
 18b566c:	83 e0 03             	and    $0x3,%eax
 18b566f:	83 f9 04             	cmp    $0x4,%ecx
 18b5672:	73 07                	jae    18b567b <tier0_tables_open+0x3e7b>
 18b5674:	31 c9                	xor    %ecx,%ecx
 18b5676:	e9 f9 00 00 00       	jmp    18b5774 <tier0_tables_open+0x3f74>
 18b567b:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18b5683:	83 e2 fc             	and    $0xfffffffc,%edx
 18b5686:	49 8d 77 28          	lea    0x28(%r15),%rsi
 18b568a:	31 c9                	xor    %ecx,%ecx
 18b568c:	8b 7e dc             	mov    -0x24(%rsi),%edi
 18b568f:	41 bb 3f 00 00 00    	mov    $0x3f,%r11d
 18b5695:	44 8b 56 e0          	mov    -0x20(%rsi),%r10d
 18b5699:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 18b569e:	83 ff 3f             	cmp    $0x3f,%edi
 18b56a1:	41 0f 43 fb          	cmovae %r11d,%edi
 18b56a5:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18b56ad:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18b56b1:	41 ff c0             	inc    %r8d
 18b56b4:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18b56b9:	4c 8b 56 d8          	mov    -0x28(%rsi),%r10
 18b56bd:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18b56c1:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18b56c9:	8b 7e e8             	mov    -0x18(%rsi),%edi
 18b56cc:	44 8b 56 ec          	mov    -0x14(%rsi),%r10d
 18b56d0:	83 ff 3f             	cmp    $0x3f,%edi
 18b56d3:	41 0f 43 fb          	cmovae %r11d,%edi
 18b56d7:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18b56df:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18b56e3:	41 ff c0             	inc    %r8d
 18b56e6:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18b56eb:	4c 8b 56 e4          	mov    -0x1c(%rsi),%r10
 18b56ef:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18b56f3:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18b56fb:	8b 7e f4             	mov    -0xc(%rsi),%edi
 18b56fe:	44 8b 56 f8          	mov    -0x8(%rsi),%r10d
 18b5702:	83 ff 3f             	cmp    $0x3f,%edi
 18b5705:	41 0f 43 fb          	cmovae %r11d,%edi
 18b5709:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18b5711:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18b5715:	41 ff c0             	inc    %r8d
 18b5718:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18b571d:	4c 8b 56 f0          	mov    -0x10(%rsi),%r10
 18b5721:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18b5725:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18b572d:	8b 3e                	mov    (%rsi),%edi
 18b572f:	44 8b 56 04          	mov    0x4(%rsi),%r10d
 18b5733:	83 ff 3f             	cmp    $0x3f,%edi
 18b5736:	41 0f 43 fb          	cmovae %r11d,%edi
 18b573a:	48 83 c1 04          	add    $0x4,%rcx
 18b573e:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18b5746:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18b574a:	41 ff c0             	inc    %r8d
 18b574d:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18b5752:	4c 8b 56 fc          	mov    -0x4(%rsi),%r10
 18b5756:	48 83 c6 30          	add    $0x30,%rsi
 18b575a:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18b575e:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18b5766:	48 39 ca             	cmp    %rcx,%rdx
 18b5769:	0f 85 1d ff ff ff    	jne    18b568c <tier0_tables_open+0x3e8c>
 18b576f:	48 85 c0             	test   %rax,%rax
 18b5772:	74 55                	je     18b57c9 <tier0_tables_open+0x3fc9>
 18b5774:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 18b5778:	c1 e0 02             	shl    $0x2,%eax
 18b577b:	31 d2                	xor    %edx,%edx
 18b577d:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18b5781:	49 8d 4c 8f 04       	lea    0x4(%r15,%rcx,4),%rcx
 18b5786:	8b 34 11             	mov    (%rcx,%rdx,1),%esi
 18b5789:	bf 3f 00 00 00       	mov    $0x3f,%edi
 18b578e:	44 8b 4c 11 04       	mov    0x4(%rcx,%rdx,1),%r9d
 18b5793:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18b5798:	83 fe 3f             	cmp    $0x3f,%esi
 18b579b:	0f 43 f7             	cmovae %edi,%esi
 18b579e:	8b bc b4 b0 01 00 00 	mov    0x1b0(%rsp,%rsi,4),%edi
 18b57a5:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
 18b57a9:	ff c7                	inc    %edi
 18b57ab:	47 89 4c 82 08       	mov    %r9d,0x8(%r10,%r8,4)
 18b57b0:	4c 8b 4c 11 fc       	mov    -0x4(%rcx,%rdx,1),%r9
 18b57b5:	48 83 c2 0c          	add    $0xc,%rdx
 18b57b9:	4f 89 0c 82          	mov    %r9,(%r10,%r8,4)
 18b57bd:	89 bc b4 b0 01 00 00 	mov    %edi,0x1b0(%rsp,%rsi,4)
 18b57c4:	48 39 d0             	cmp    %rdx,%rax
 18b57c7:	75 bd                	jne    18b5786 <tier0_tables_open+0x3f86>
 18b57c9:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18b57d1:	0f 84 a8 01 00 00    	je     18b597f <tier0_tables_open+0x417f>
 18b57d7:	48 8b 84 24 50 01 00 00 	mov    0x150(%rsp),%rax
 18b57df:	b9 0a 00 00 00       	mov    $0xa,%ecx
 18b57e4:	31 d2                	xor    %edx,%edx
 18b57e6:	31 ff                	xor    %edi,%edi
 18b57e8:	8d 1c 85 00 00 00 00 	lea    0x0(,%rax,4),%ebx
 18b57ef:	eb 66                	jmp    18b5857 <tier0_tables_open+0x4057>
 18b57f1:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18b57f7:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18b57fc:	41 bb ff ff ff ff    	mov    $0xffffffff,%r11d
 18b5802:	45 31 c0             	xor    %r8d,%r8d
 18b5805:	45 31 c9             	xor    %r9d,%r9d
 18b5808:	45 31 d2             	xor    %r10d,%r10d
 18b580b:	48 8b 84 24 20 01 00 00 	mov    0x120(%rsp),%rax
 18b5813:	48 83 c2 04          	add    $0x4,%rdx
 18b5817:	44 89 5c 88 d8       	mov    %r11d,-0x28(%rax,%rcx,4)
 18b581c:	89 6c 88 dc          	mov    %ebp,-0x24(%rax,%rcx,4)
 18b5820:	44 89 7c 88 e0       	mov    %r15d,-0x20(%rax,%rcx,4)
 18b5825:	89 7c 88 e4          	mov    %edi,-0x1c(%rax,%rcx,4)
 18b5829:	44 89 cf             	mov    %r9d,%edi
 18b582c:	48 89 74 88 e8       	mov    %rsi,-0x18(%rax,%rcx,4)
 18b5831:	44 89 4c 88 f0       	mov    %r9d,-0x10(%rax,%rcx,4)
 18b5836:	c7 44 88 f4 00 00 00 00 	movl   $0x0,-0xc(%rax,%rcx,4)
 18b583e:	4c 89 44 88 f8       	mov    %r8,-0x8(%rax,%rcx,4)
 18b5843:	4c 89 14 88          	mov    %r10,(%rax,%rcx,4)
 18b5847:	48 01 f7             	add    %rsi,%rdi
 18b584a:	48 83 c1 0c          	add    $0xc,%rcx
 18b584e:	48 39 d3             	cmp    %rdx,%rbx
 18b5851:	0f 84 1e 01 00 00    	je     18b5975 <tier0_tables_open+0x4175>
 18b5857:	48 89 fe             	mov    %rdi,%rsi
 18b585a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 18b585f:	48 3b 94 24 98 00 00 00 	cmp    0x98(%rsp),%rdx
 18b5867:	73 88                	jae    18b57f1 <tier0_tables_open+0x3ff1>
 18b5869:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18b586e:	4c 8d 7a 01          	lea    0x1(%rdx),%r15
 18b5872:	44 0f b6 54 88 e2    	movzbl -0x1e(%rax,%rcx,4),%r10d
 18b5878:	44 8b 5c 88 d8       	mov    -0x28(%rax,%rcx,4),%r11d
 18b587d:	44 8b 4c 88 dc       	mov    -0x24(%rax,%rcx,4),%r9d
 18b5882:	44 0f b7 44 88 e0    	movzwl -0x20(%rax,%rcx,4),%r8d
 18b5888:	41 83 e2 01          	and    $0x1,%r10d
 18b588c:	4c 3b bc 24 98 00 00 00 	cmp    0x98(%rsp),%r15
 18b5894:	0f 83 c0 00 00 00    	jae    18b595a <tier0_tables_open+0x415a>
 18b589a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18b589f:	44 8b 7c 88 e8       	mov    -0x18(%rax,%rcx,4),%r15d
 18b58a4:	44 0f b6 64 88 ee    	movzbl -0x12(%rax,%rcx,4),%r12d
 18b58aa:	8b 6c 88 e4          	mov    -0x1c(%rax,%rcx,4),%ebp
 18b58ae:	45 39 cf             	cmp    %r9d,%r15d
 18b58b1:	45 0f 47 cf          	cmova  %r15d,%r9d
 18b58b5:	44 8b 7c 88 ec       	mov    -0x14(%rax,%rcx,4),%r15d
 18b58ba:	41 83 e4 01          	and    $0x1,%r12d
 18b58be:	48 8d 42 02          	lea    0x2(%rdx),%rax
 18b58c2:	41 c1 e4 10          	shl    $0x10,%r12d
 18b58c6:	4d 09 e2             	or     %r12,%r10
 18b58c9:	41 c1 e7 10          	shl    $0x10,%r15d
 18b58cd:	4d 09 f8             	or     %r15,%r8
 18b58d0:	48 3b 84 24 98 00 00 00 	cmp    0x98(%rsp),%rax
 18b58d8:	0f 83 8c 00 00 00    	jae    18b596a <tier0_tables_open+0x416a>
 18b58de:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18b58e3:	44 8b 64 88 f4       	mov    -0xc(%rax,%rcx,4),%r12d
 18b58e8:	44 8b 7c 88 f0       	mov    -0x10(%rax,%rcx,4),%r15d
 18b58ed:	44 0f b7 6c 88 f8    	movzwl -0x8(%rax,%rcx,4),%r13d
 18b58f3:	0f b6 44 88 fa       	movzbl -0x6(%rax,%rcx,4),%eax
 18b58f8:	45 39 cc             	cmp    %r9d,%r12d
 18b58fb:	45 0f 47 cc          	cmova  %r12d,%r9d
 18b58ff:	83 e0 01             	and    $0x1,%eax
 18b5902:	49 c1 e5 20          	shl    $0x20,%r13
 18b5906:	4c 8d 62 03          	lea    0x3(%rdx),%r12
 18b590a:	48 c1 e0 20          	shl    $0x20,%rax
 18b590e:	4d 09 e8             	or     %r13,%r8
 18b5911:	49 09 c2             	or     %rax,%r10
 18b5914:	4c 3b a4 24 98 00 00 00 	cmp    0x98(%rsp),%r12
 18b591c:	0f 83 e9 fe ff ff    	jae    18b580b <tier0_tables_open+0x400b>
 18b5922:	4c 8b 6c 24 78       	mov    0x78(%rsp),%r13
 18b5927:	41 8b 44 8d 00       	mov    0x0(%r13,%rcx,4),%eax
 18b592c:	45 0f b6 64 8d 06    	movzbl 0x6(%r13,%rcx,4),%r12d
 18b5932:	41 8b 7c 8d fc       	mov    -0x4(%r13,%rcx,4),%edi
 18b5937:	44 39 c8             	cmp    %r9d,%eax
 18b593a:	44 0f 47 c8          	cmova  %eax,%r9d
 18b593e:	41 8b 44 8d 04       	mov    0x4(%r13,%rcx,4),%eax
 18b5943:	41 83 e4 01          	and    $0x1,%r12d
 18b5947:	49 c1 e4 30          	shl    $0x30,%r12
 18b594b:	4d 09 e2             	or     %r12,%r10
 18b594e:	48 c1 e0 30          	shl    $0x30,%rax
 18b5952:	49 09 c0             	or     %rax,%r8
 18b5955:	e9 b1 fe ff ff       	jmp    18b580b <tier0_tables_open+0x400b>
 18b595a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18b5960:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18b5965:	e9 a1 fe ff ff       	jmp    18b580b <tier0_tables_open+0x400b>
 18b596a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18b5970:	e9 96 fe ff ff       	jmp    18b580b <tier0_tables_open+0x400b>
 18b5975:	48 c1 e7 06          	shl    $0x6,%rdi
 18b5979:	48 83 c7 40          	add    $0x40,%rdi
 18b597d:	eb 05                	jmp    18b5984 <tier0_tables_open+0x4184>
 18b597f:	bf 40 00 00 00       	mov    $0x40,%edi
 18b5984:	64 48 8b 0c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%rcx
 18b598d:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18b5996:	48 8d 54 08 3f       	lea    0x3f(%rax,%rcx,1),%rdx
 18b599b:	48 01 c8             	add    %rcx,%rax
 18b599e:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 18b59a2:	48 89 94 24 e8 00 00 00 	mov    %rdx,0xe8(%rsp)
 18b59aa:	48 39 c2             	cmp    %rax,%rdx
 18b59ad:	73 07                	jae    18b59b6 <tier0_tables_open+0x41b6>
 18b59af:	31 c9                	xor    %ecx,%ecx
 18b59b1:	e9 4c 1b 00 00       	jmp    18b7502 <tier0_tables_open+0x5d02>
 18b59b6:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18b59be:	64 48 8b 14 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rdx
 18b59c7:	48 29 c8             	sub    %rcx,%rax
 18b59ca:	31 c9                	xor    %ecx,%ecx
 18b59cc:	48 29 c2             	sub    %rax,%rdx
 18b59cf:	0f 82 2d 1b 00 00    	jb     18b7502 <tier0_tables_open+0x5d02>
 18b59d5:	48 39 d7             	cmp    %rdx,%rdi
 18b59d8:	0f 87 24 1b 00 00    	ja     18b7502 <tier0_tables_open+0x5d02>
 18b59de:	48 01 f8             	add    %rdi,%rax
 18b59e1:	48 83 bc 24 e8 00 00 00 00 	cmpq   $0x0,0xe8(%rsp)
 18b59ea:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18b59f3:	0f 84 45 16 00 00    	je     18b703e <tier0_tables_open+0x583e>
 18b59f9:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18b5a01:	0f 84 37 16 00 00    	je     18b703e <tier0_tables_open+0x583e>
 18b5a07:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18b5a0f:	48 c7 84 24 68 01 00 00 00 00 00 00 	movq   $0x0,0x168(%rsp)
 18b5a1b:	48 05 00 01 00 00    	add    $0x100,%rax
 18b5a21:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 18b5a29:	eb 21                	jmp    18b5a4c <tier0_tables_open+0x424c>
 18b5a2b:	48 8b 8c 24 68 01 00 00 	mov    0x168(%rsp),%rcx
 18b5a33:	48 ff c1             	inc    %rcx
 18b5a36:	48 89 8c 24 68 01 00 00 	mov    %rcx,0x168(%rsp)
 18b5a3e:	48 3b 8c 24 50 01 00 00 	cmp    0x150(%rsp),%rcx
 18b5a46:	0f 84 f2 15 00 00    	je     18b703e <tier0_tables_open+0x583e>
 18b5a4c:	48 8b 84 24 68 01 00 00 	mov    0x168(%rsp),%rax
 18b5a54:	48 8b b4 24 20 01 00 00 	mov    0x120(%rsp),%rsi
 18b5a5c:	48 8b 94 24 a0 01 00 00 	mov    0x1a0(%rsp),%rdx
 18b5a64:	48 c7 84 24 c8 00 00 00 00 00 00 00 	movq   $0x0,0xc8(%rsp)
 18b5a70:	48 c1 e0 04          	shl    $0x4,%rax
 18b5a74:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 18b5a7c:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
 18b5a80:	48 8d 04 0e          	lea    (%rsi,%rcx,1),%rax
 18b5a84:	48 03 4c 24 78       	add    0x78(%rsp),%rcx
 18b5a89:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18b5a91:	48 89 8c 24 a8 01 00 00 	mov    %rcx,0x1a8(%rsp)
 18b5a99:	48 8b 8c 24 e8 00 00 00 	mov    0xe8(%rsp),%rcx
 18b5aa1:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 18b5aa9:	eb 7d                	jmp    18b5b28 <tier0_tables_open+0x4328>
 18b5aab:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5aaf:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18b5ab7:	4c 89 f7             	mov    %r14,%rdi
 18b5aba:	c5 f8 77             	vzeroupper
 18b5abd:	e8 ae 0d 01 00       	call   18c6870 <abi_storage>
 18b5ac2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18b5ac7:	b1 30                	mov    $0x30,%cl
 18b5ac9:	c4 e2 f0 f5 d2       	bzhi   %rcx,%rdx,%rdx
 18b5ace:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18b5ad3:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5ad7:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18b5adf:	48 8b 8e a0 01 00 00 	mov    0x1a0(%rsi),%rcx
 18b5ae6:	88 04 11             	mov    %al,(%rcx,%rdx,1)
 18b5ae9:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18b5aee:	48 8b 86 a8 01 00 00 	mov    0x1a8(%rsi),%rax
 18b5af5:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
 18b5af9:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18b5b01:	48 83 84 24 80 01 00 00 10 	addq   $0x10,0x180(%rsp)
 18b5b0a:	48 83 84 24 78 01 00 00 10 	addq   $0x10,0x178(%rsp)
 18b5b13:	48 ff c1             	inc    %rcx
 18b5b16:	48 89 8c 24 c8 00 00 00 	mov    %rcx,0xc8(%rsp)
 18b5b1e:	48 83 f9 04          	cmp    $0x4,%rcx
 18b5b22:	0f 84 03 ff ff ff    	je     18b5a2b <tier0_tables_open+0x422b>
 18b5b28:	48 8b 84 24 48 01 00 00 	mov    0x148(%rsp),%rax
 18b5b30:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18b5b38:	48 8b 50 10          	mov    0x10(%rax),%rdx
 18b5b3c:	48 89 ce             	mov    %rcx,%rsi
 18b5b3f:	48 c1 e6 04          	shl    $0x4,%rsi
 18b5b43:	48 03 b4 24 e8 00 00 00 	add    0xe8(%rsp),%rsi
 18b5b4b:	48 c1 e2 06          	shl    $0x6,%rdx
 18b5b4f:	48 01 d6             	add    %rdx,%rsi
 18b5b52:	48 89 94 24 88 01 00 00 	mov    %rdx,0x188(%rsp)
 18b5b5a:	8b 14 88             	mov    (%rax,%rcx,4),%edx
 18b5b5d:	8b 40 18             	mov    0x18(%rax),%eax
 18b5b60:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
 18b5b65:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
 18b5b6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18b5b6f:	48 89 94 24 f0 00 00 00 	mov    %rdx,0xf0(%rsp)
 18b5b77:	48 39 c2             	cmp    %rax,%rdx
 18b5b7a:	0f 84 ec 00 00 00    	je     18b5c6c <tier0_tables_open+0x446c>
 18b5b80:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18b5b88:	48 8b 8c 24 a8 01 00 00 	mov    0x1a8(%rsp),%rcx
 18b5b90:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18b5b94:	0f b6 44 81 0b       	movzbl 0xb(%rcx,%rax,4),%eax
 18b5b99:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b5b9d:	88 84 24 00 01 00 00 	mov    %al,0x100(%rsp)
 18b5ba4:	48 8b 01             	mov    (%rcx),%rax
 18b5ba7:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18b5baf:	0f b6 0c 08          	movzbl (%rax,%rcx,1),%ecx
 18b5bb3:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
 18b5bba:	80 f9 08             	cmp    $0x8,%cl
 18b5bbd:	0f 85 ed 00 00 00    	jne    18b5cb0 <tier0_tables_open+0x44b0>
 18b5bc3:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b5bc7:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18b5bcf:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18b5bd3:	8b 14 91             	mov    (%rcx,%rdx,4),%edx
 18b5bd6:	c1 ea 03             	shr    $0x3,%edx
 18b5bd9:	80 3c 10 0f          	cmpb   $0xf,(%rax,%rdx,1)
 18b5bdd:	48 89 d0             	mov    %rdx,%rax
 18b5be0:	75 06                	jne    18b5be8 <tier0_tables_open+0x43e8>
 18b5be2:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18b5be5:	c1 e8 03             	shr    $0x3,%eax
 18b5be8:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b5bec:	48 8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%rsi
 18b5bf4:	48 8b 49 30          	mov    0x30(%rcx),%rcx
 18b5bf8:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
 18b5bfc:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 18b5c01:	48 85 f6             	test   %rsi,%rsi
 18b5c04:	0f 84 fb 0b 00 00    	je     18b6805 <tier0_tables_open+0x5005>
 18b5c0a:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b5c0e:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18b5c12:	48 8b 0c c1          	mov    (%rcx,%rax,8),%rcx
 18b5c16:	48 89 d0             	mov    %rdx,%rax
 18b5c19:	48 c1 e0 04          	shl    $0x4,%rax
 18b5c1d:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18b5c25:	0f 84 e8 0b 00 00    	je     18b6813 <tier0_tables_open+0x5013>
 18b5c2b:	48 85 c9             	test   %rcx,%rcx
 18b5c2e:	0f 84 99 0e 00 00    	je     18b6acd <tier0_tables_open+0x52cd>
 18b5c34:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5c38:	48 8b be a8 01 00 00 	mov    0x1a8(%rsi),%rdi
 18b5c3f:	48 8b 1c d7          	mov    (%rdi,%rdx,8),%rbx
 18b5c43:	48 89 da             	mov    %rbx,%rdx
 18b5c46:	48 c1 ea 20          	shr    $0x20,%rdx
 18b5c4a:	48 83 7c 24 58 01    	cmpq   $0x1,0x58(%rsp)
 18b5c50:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 18b5c55:	0f 85 8d 0e 00 00    	jne    18b6ae8 <tier0_tables_open+0x52e8>
 18b5c5b:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18b5c64:	45 31 c0             	xor    %r8d,%r8d
 18b5c67:	e9 db 0f 00 00       	jmp    18b6c47 <tier0_tables_open+0x5447>
 18b5c6c:	48 83 7c 24 68 00    	cmpq   $0x0,0x68(%rsp)
 18b5c72:	0f 84 81 fe ff ff    	je     18b5af9 <tier0_tables_open+0x42f9>
 18b5c78:	31 c0                	xor    %eax,%eax
 18b5c7a:	31 c9                	xor    %ecx,%ecx
 18b5c7c:	c4 e2 79 59 05 7b a4 cc fe 	vpbroadcastq -0x1335b85(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18b5c85:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b5c8a:	89 c2                	mov    %eax,%edx
 18b5c8c:	83 e2 c0             	and    $0xffffffc0,%edx
 18b5c8f:	48 ff c1             	inc    %rcx
 18b5c92:	48 83 c0 40          	add    $0x40,%rax
 18b5c96:	c5 f9 7f 04 16       	vmovdqa %xmm0,(%rsi,%rdx,1)
 18b5c9b:	48 8b b4 24 48 01 00 00 	mov    0x148(%rsp),%rsi
 18b5ca3:	8b 56 18             	mov    0x18(%rsi),%edx
 18b5ca6:	48 39 d1             	cmp    %rdx,%rcx
 18b5ca9:	72 d1                	jb     18b5c7c <tier0_tables_open+0x447c>
 18b5cab:	e9 49 fe ff ff       	jmp    18b5af9 <tier0_tables_open+0x42f9>
 18b5cb0:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5cb4:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18b5cbc:	48 8b 46 28          	mov    0x28(%rsi),%rax
 18b5cc0:	48 8b 56 70          	mov    0x70(%rsi),%rdx
 18b5cc4:	48 8b 76 78          	mov    0x78(%rsi),%rsi
 18b5cc8:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18b5ccb:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18b5cce:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18b5cd1:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 18b5cd6:	01 d0                	add    %edx,%eax
 18b5cd8:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 18b5cdd:	89 84 24 e0 00 00 00 	mov    %eax,0xe0(%rsp)
 18b5ce4:	39 c2                	cmp    %eax,%edx
 18b5ce6:	0f 83 19 0b 00 00    	jae    18b6805 <tier0_tables_open+0x5005>
 18b5cec:	48 8b 04 24          	mov    (%rsp),%rax
 18b5cf0:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18b5cf8:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
 18b5cfd:	48 c7 84 24 70 01 00 00 00 00 00 00 	movq   $0x0,0x170(%rsp)
 18b5d09:	48 c7 84 24 28 01 00 00 00 00 00 00 	movq   $0x0,0x128(%rsp)
 18b5d15:	48 c7 84 24 a8 00 00 00 00 00 00 00 	movq   $0x0,0xa8(%rsp)
 18b5d21:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18b5d2a:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18b5d33:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18b5d3c:	48 8b 40 38          	mov    0x38(%rax),%rax
 18b5d40:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
 18b5d45:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
 18b5d49:	48 89 84 24 b8 00 00 00 	mov    %rax,0xb8(%rsp)
 18b5d51:	8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%eax
 18b5d58:	48 89 84 24 98 01 00 00 	mov    %rax,0x198(%rsp)
 18b5d60:	44 89 e8             	mov    %r13d,%eax
 18b5d63:	f7 d0                	not    %eax
 18b5d65:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 18b5d6d:	41 8d 45 01          	lea    0x1(%r13),%eax
 18b5d71:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18b5d79:	b0 ff                	mov    $0xff,%al
 18b5d7b:	89 84 24 e4 00 00 00 	mov    %eax,0xe4(%rsp)
 18b5d82:	e9 93 01 00 00       	jmp    18b5f1a <tier0_tables_open+0x471a>
 18b5d87:	48 89 c8             	mov    %rcx,%rax
 18b5d8a:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
 18b5d93:	4c 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%r8
 18b5d9b:	45 89 fa             	mov    %r15d,%r10d
 18b5d9e:	48 09 ac 24 28 01 00 00 	or     %rbp,0x128(%rsp)
 18b5da6:	31 c9                	xor    %ecx,%ecx
 18b5da8:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18b5dae:	48 be 00 00 00 00 00 00 02 00 	movabs $0x2000000000000,%rsi
 18b5db8:	49 89 ed             	mov    %rbp,%r13
 18b5dbb:	bd 00 00 00 00       	mov    $0x0,%ebp
 18b5dc0:	48 8b 9c 24 18 01 00 00 	mov    0x118(%rsp),%rbx
 18b5dc8:	45 08 c2             	or     %r8b,%r10b
 18b5dcb:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18b5dd4:	4c 89 94 24 70 01 00 00 	mov    %r10,0x170(%rsp)
 18b5ddc:	4c 89 94 24 a8 00 00 00 	mov    %r10,0xa8(%rsp)
 18b5de4:	0f 95 c1             	setne  %cl
 18b5de7:	41 f6 c1 10          	test   $0x10,%r9b
 18b5deb:	49 b9 00 00 00 00 fe ff 7f 00 	movabs $0x7ffffe00000000,%r9
 18b5df5:	4c 0f 45 de          	cmovne %rsi,%r11
 18b5df9:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18b5dfe:	4c 8d 66 01          	lea    0x1(%rsi),%r12
 18b5e02:	be 1f 00 00 00       	mov    $0x1f,%esi
 18b5e07:	4c 0f 44 e5          	cmove  %rbp,%r12
 18b5e0b:	41 f6 c0 01          	test   $0x1,%r8b
 18b5e0f:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
 18b5e14:	4c 0f 45 dd          	cmovne %rbp,%r11
 18b5e18:	45 84 ff             	test   %r15b,%r15b
 18b5e1b:	49 89 ff             	mov    %rdi,%r15
 18b5e1e:	4c 0f 44 dd          	cmove  %rbp,%r11
 18b5e22:	49 c1 e7 3c          	shl    $0x3c,%r15
 18b5e26:	48 83 fb 1f          	cmp    $0x1f,%rbx
 18b5e2a:	48 0f 42 f3          	cmovb  %rbx,%rsi
 18b5e2e:	48 c1 e6 37          	shl    $0x37,%rsi
 18b5e32:	49 c1 e0 21          	shl    $0x21,%r8
 18b5e36:	4d 29 c1             	sub    %r8,%r9
 18b5e39:	48 85 db             	test   %rbx,%rbx
 18b5e3c:	44 0f b6 84 24 d0 00 00 00 	movzbl 0xd0(%rsp),%r8d
 18b5e45:	4c 0f 44 e3          	cmove  %rbx,%r12
 18b5e49:	49 09 f1             	or     %rsi,%r9
 18b5e4c:	40 80 cf 20          	or     $0x20,%dil
 18b5e50:	31 f6                	xor    %esi,%esi
 18b5e52:	48 bb 00 00 00 00 00 00 04 00 	movabs $0x4000000000000,%rbx
 18b5e5c:	4d 09 f9             	or     %r15,%r9
 18b5e5f:	4c 0b 8c 24 10 01 00 00 	or     0x110(%rsp),%r9
 18b5e67:	4d 09 e1             	or     %r12,%r9
 18b5e6a:	f6 44 24 70 20       	testb  $0x20,0x70(%rsp)
 18b5e6f:	40 0f 94 c6          	sete   %sil
 18b5e73:	f6 84 24 d8 00 00 00 02 	testb  $0x2,0xd8(%rsp)
 18b5e7b:	0f 45 f1             	cmovne %ecx,%esi
 18b5e7e:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b5e83:	40 84 f6             	test   %sil,%sil
 18b5e86:	48 0f 45 cb          	cmovne %rbx,%rcx
 18b5e8a:	48 03 4c 24 38       	add    0x38(%rsp),%rcx
 18b5e8f:	49 0f ab fb          	bts    %rdi,%r11
 18b5e93:	4c 09 ea             	or     %r13,%rdx
 18b5e96:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
 18b5e9b:	48 01 c8             	add    %rcx,%rax
 18b5e9e:	4c 01 d8             	add    %r11,%rax
 18b5ea1:	41 80 f8 11          	cmp    $0x11,%r8b
 18b5ea5:	49 0f 44 c1          	cmove  %r9,%rax
 18b5ea9:	80 bc 24 40 01 00 00 00 	cmpb   $0x0,0x140(%rsp)
 18b5eb1:	48 0f 44 c5          	cmove  %rbp,%rax
 18b5eb5:	48 0f 44 d5          	cmove  %rbp,%rdx
 18b5eb9:	48 89 c6             	mov    %rax,%rsi
 18b5ebc:	48 09 fe             	or     %rdi,%rsi
 18b5ebf:	48 39 f8             	cmp    %rdi,%rax
 18b5ec2:	48 0f 46 c7          	cmovbe %rdi,%rax
 18b5ec6:	41 80 f8 11          	cmp    $0x11,%r8b
 18b5eca:	48 0f 45 c6          	cmovne %rsi,%rax
 18b5ece:	48 0f 45 cd          	cmovne %rbp,%rcx
 18b5ed2:	48 0b 54 24 30       	or     0x30(%rsp),%rdx
 18b5ed7:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
 18b5edc:	48 09 ca             	or     %rcx,%rdx
 18b5edf:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18b5ee4:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 18b5eec:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18b5ef1:	48 ff 44 24 10       	incq   0x10(%rsp)
 18b5ef6:	48 ff 8c 24 f8 00 00 00 	decq   0xf8(%rsp)
 18b5efe:	48 ff c1             	inc    %rcx
 18b5f01:	ff c0                	inc    %eax
 18b5f03:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18b5f0b:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 18b5f10:	39 4c 24 58          	cmp    %ecx,0x58(%rsp)
 18b5f14:	0f 84 d7 0e 00 00    	je     18b6df1 <tier0_tables_open+0x55f1>
 18b5f1a:	48 8b 04 24          	mov    (%rsp),%rax
 18b5f1e:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b5f23:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
 18b5f27:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
 18b5f2e:	0f b6 0c 08          	movzbl (%rax,%rcx,1),%ecx
 18b5f32:	f6 c1 02             	test   $0x2,%cl
 18b5f35:	74 1a                	je     18b5f51 <tier0_tables_open+0x4751>
 18b5f37:	48 8b 04 24          	mov    (%rsp),%rax
 18b5f3b:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 18b5f40:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
 18b5f47:	83 3c 90 01          	cmpl   $0x1,(%rax,%rdx,4)
 18b5f4b:	19 c0                	sbb    %eax,%eax
 18b5f4d:	c5 fb 92 c8          	kmovd  %eax,%k1
 18b5f51:	48 8b 14 24          	mov    (%rsp),%rdx
 18b5f55:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18b5f5a:	48 8b 82 b8 00 00 00 	mov    0xb8(%rdx),%rax
 18b5f61:	48 8b 12             	mov    (%rdx),%rdx
 18b5f64:	8b 04 b0             	mov    (%rax,%rsi,4),%eax
 18b5f67:	c1 e8 03             	shr    $0x3,%eax
 18b5f6a:	80 3c 02 0f          	cmpb   $0xf,(%rdx,%rax,1)
 18b5f6e:	48 89 c2             	mov    %rax,%rdx
 18b5f71:	75 0e                	jne    18b5f81 <tier0_tables_open+0x4781>
 18b5f73:	48 8b 14 24          	mov    (%rsp),%rdx
 18b5f77:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18b5f7b:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18b5f7e:	c1 ea 03             	shr    $0x3,%edx
 18b5f81:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5f85:	48 83 bc 24 b8 00 00 00 11 	cmpq   $0x11,0xb8(%rsp)
 18b5f8e:	48 8b 7e 38          	mov    0x38(%rsi),%rdi
 18b5f92:	4c 8b 0c d7          	mov    (%rdi,%rdx,8),%r9
 18b5f96:	48 8b be d8 00 00 00 	mov    0xd8(%rsi),%rdi
 18b5f9d:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18b5fa2:	48 8b 14 f7          	mov    (%rdi,%rsi,8),%rdx
 18b5fa6:	72 42                	jb     18b5fea <tier0_tables_open+0x47ea>
 18b5fa8:	80 bc 24 d0 00 00 00 11 	cmpb   $0x11,0xd0(%rsp)
 18b5fb0:	74 17                	je     18b5fc9 <tier0_tables_open+0x47c9>
 18b5fb2:	c4 e2 79 78 05 05 a8 c6 fe 	vpbroadcastb -0x13957fb(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 18b5fbb:	4c 39 8c 24 b8 00 00 00 	cmp    %r9,0xb8(%rsp)
 18b5fc3:	0f 85 67 01 00 00    	jne    18b6130 <tier0_tables_open+0x4930>
 18b5fc9:	48 8b 34 24          	mov    (%rsp),%rsi
 18b5fcd:	c4 e2 79 78 05 ea a7 c6 fe 	vpbroadcastb -0x1395816(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 18b5fd6:	8b be bc 01 00 00    	mov    0x1bc(%rsi),%edi
 18b5fdc:	48 39 bc 24 b8 00 00 00 	cmp    %rdi,0xb8(%rsp)
 18b5fe4:	0f 87 46 01 00 00    	ja     18b6130 <tier0_tables_open+0x4930>
 18b5fea:	f6 c1 02             	test   $0x2,%cl
 18b5fed:	0f 85 ba 00 00 00    	jne    18b60ad <tier0_tables_open+0x48ad>
 18b5ff3:	48 c1 ea 03          	shr    $0x3,%rdx
 18b5ff7:	31 ff                	xor    %edi,%edi
 18b5ff9:	4d 85 c9             	test   %r9,%r9
 18b5ffc:	75 1b                	jne    18b6019 <tier0_tables_open+0x4819>
 18b5ffe:	48 85 d2             	test   %rdx,%rdx
 18b6001:	74 16                	je     18b6019 <tier0_tables_open+0x4819>
 18b6003:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b6007:	be 0d 01 00 00       	mov    $0x10d,%esi
 18b600c:	48 8b 89 88 01 00 00 	mov    0x188(%rcx),%rcx
 18b6013:	c4 e2 48 f7 3c 81    	bextr  %esi,(%rcx,%rax,4),%edi
 18b6019:	48 8b 34 24          	mov    (%rsp),%rsi
 18b601d:	62 f2 7d 08 7a c2    	vpbroadcastb %edx,%xmm0
 18b6023:	c5 f9 fc 05 e5 fb cb fe 	vpaddb -0x134041b(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 18b602b:	b1 10                	mov    $0x10,%cl
 18b602d:	41 b8 fe ff ff ff    	mov    $0xfffffffe,%r8d
 18b6033:	28 d1                	sub    %dl,%cl
 18b6035:	62 f1 7d 18 db 1d 85 a4 cc fe 	vpandd -0x1335b7b(%rip){1to4},%xmm0,%xmm3        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18b603f:	4c 8b 96 98 01 00 00 	mov    0x198(%rsi),%r10
 18b6046:	4c 8b 8e 80 01 00 00 	mov    0x180(%rsi),%r9
 18b604d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18b6052:	45 0f b6 14 02       	movzbl (%r10,%rax,1),%r10d
 18b6057:	41 80 fa 07          	cmp    $0x7,%r10b
 18b605b:	c4 62 29 f7 d6       	shlx   %r10d,%esi,%r10d
 18b6060:	be 7f 00 00 00       	mov    $0x7f,%esi
 18b6065:	41 f6 d2             	not    %r10b
 18b6068:	41 0f b6 d2          	movzbl %r10b,%edx
 18b606c:	0f 43 d6             	cmovae %esi,%edx
 18b606f:	41 d3 c0             	rol    %cl,%r8d
 18b6072:	40 84 ff             	test   %dil,%dil
 18b6075:	be ff ff 00 00       	mov    $0xffff,%esi
 18b607a:	44 0f 44 c6          	cmove  %esi,%r8d
 18b607e:	48 c1 e0 04          	shl    $0x4,%rax
 18b6082:	62 f2 7d 08 7a ca    	vpbroadcastb %edx,%xmm1
 18b6088:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 18b608d:	c4 c1 79 6f 14 01    	vmovdqa (%r9,%rax,1),%xmm2
 18b6093:	62 f2 76 0a 26 d0    	vptestnmb %xmm0,%xmm1,%k2{%k2}
 18b6099:	c4 e2 79 78 05 1e a7 c6 fe 	vpbroadcastb -0x13958e2(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 18b60a2:	62 f2 6d 0a 00 c3    	vpshufb %xmm3,%xmm2,%xmm0{%k2}
 18b60a8:	e9 83 00 00 00       	jmp    18b6130 <tier0_tables_open+0x4930>
 18b60ad:	48 8b 04 24          	mov    (%rsp),%rax
 18b60b1:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b60b6:	bf 47 00 00 00       	mov    $0x47,%edi
 18b60bb:	41 b9 48 00 00 00    	mov    $0x48,%r9d
 18b60c1:	29 d7                	sub    %edx,%edi
 18b60c3:	c1 ef 03             	shr    $0x3,%edi
 18b60c6:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
 18b60cd:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18b60d0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
 18b60d4:	48 8d 44 02 bf       	lea    -0x41(%rdx,%rax,1),%rax
 18b60d9:	41 29 c9             	sub    %ecx,%r9d
 18b60dc:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b60e1:	41 c1 e9 03          	shr    $0x3,%r9d
 18b60e5:	48 83 fa 40          	cmp    $0x40,%rdx
 18b60e9:	0f 43 f9             	cmovae %ecx,%edi
 18b60ec:	48 83 f8 c0          	cmp    $0xffffffffffffffc0,%rax
 18b60f0:	44 0f 42 c9          	cmovb  %ecx,%r9d
 18b60f4:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18b60fa:	62 f3 7d 08 3e 15 0b fb cb fe 06 	vpcmpnleub -0x13404f5(%rip),%xmm0,%k2        # 575c10 <x86_effects_unknown+0x1b0>
 18b6105:	62 d2 7d 08 7a c1    	vpbroadcastb %r9d,%xmm0
 18b610b:	62 f3 7d 08 3e 1d 3a fb cb fe 05 	vpcmpnltub -0x13404c6(%rip),%xmm0,%k3        # 575c50 <x86_effects_unknown+0x1f0>
 18b6116:	62 f1 7f 8b 6f 0d 40 fb cb fe 	vmovdqu8 -0x13404c0(%rip),%xmm1{%k3}{z}        # 575c60 <x86_effects_unknown+0x200>
 18b6120:	62 f1 75 18 eb 05 9e a3 cc fe 	vpord  -0x1335c62(%rip){1to4},%xmm1,%xmm0        # 5804c8 <tier0_emit_x87.operations+0x80>
 18b612a:	62 f1 7f 0a 6f c1    	vmovdqu8 %xmm1,%xmm0{%k2}
 18b6130:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 18b6138:	62 f1 7f 09 6f 05 4e fb cb fe 	vmovdqu8 -0x13404b2(%rip),%xmm0{%k1}        # 575c90 <x86_effects_unknown+0x230>
 18b6142:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b6147:	89 c0                	mov    %eax,%eax
 18b6149:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18b6151:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18b6156:	48 c1 e0 06          	shl    $0x6,%rax
 18b615a:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18b6162:	c5 f9 7f 04 01       	vmovdqa %xmm0,(%rcx,%rax,1)
 18b6167:	0f 84 77 fd ff ff    	je     18b5ee4 <tier0_tables_open+0x46e4>
 18b616d:	48 8b 04 24          	mov    (%rsp),%rax
 18b6171:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b6176:	4c 8b a8 b8 00 00 00 	mov    0xb8(%rax),%r13
 18b617d:	48 8b 00             	mov    (%rax),%rax
 18b6180:	45 8b 54 8d 00       	mov    0x0(%r13,%rcx,4),%r10d
 18b6185:	48 89 84 24 90 00 00 00 	mov    %rax,0x90(%rsp)
 18b618d:	41 c1 ea 03          	shr    $0x3,%r10d
 18b6191:	42 80 3c 10 0f       	cmpb   $0xf,(%rax,%r10,1)
 18b6196:	4c 89 d0             	mov    %r10,%rax
 18b6199:	75 0f                	jne    18b61aa <tier0_tables_open+0x49aa>
 18b619b:	48 8b 04 24          	mov    (%rsp),%rax
 18b619f:	48 8b 40 20          	mov    0x20(%rax),%rax
 18b61a3:	42 8b 04 90          	mov    (%rax,%r10,4),%eax
 18b61a7:	c1 e8 03             	shr    $0x3,%eax
 18b61aa:	48 8b 14 24          	mov    (%rsp),%rdx
 18b61ae:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
 18b61b2:	48 8b 3c c1          	mov    (%rcx,%rax,8),%rdi
 18b61b6:	48 8b 8a c0 00 00 00 	mov    0xc0(%rdx),%rcx
 18b61bd:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b61c2:	48 8b 92 d0 00 00 00 	mov    0xd0(%rdx),%rdx
 18b61c9:	44 8b 1c 81          	mov    (%rcx,%rax,4),%r11d
 18b61cd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
 18b61d1:	48 8d 2c fd 00 00 00 00 	lea    0x0(,%rdi,8),%rbp
 18b61d9:	48 89 8c 24 30 01 00 00 	mov    %rcx,0x130(%rsp)
 18b61e1:	48 89 94 24 38 01 00 00 	mov    %rdx,0x138(%rsp)
 18b61e9:	4d 85 db             	test   %r11,%r11
 18b61ec:	4c 89 9c 24 08 01 00 00 	mov    %r11,0x108(%rsp)
 18b61f4:	88 84 24 d8 00 00 00 	mov    %al,0xd8(%rsp)
 18b61fb:	41 0f 95 c0          	setne  %r8b
 18b61ff:	a8 02                	test   $0x2,%al
 18b6201:	48 b8 f8 ff ff ff 01 00 00 00 	movabs $0x1fffffff8,%rax
 18b620b:	0f 94 44 24 70       	sete   0x70(%rsp)
 18b6210:	4c 39 dd             	cmp    %r11,%rbp
 18b6213:	4c 0f 42 dd          	cmovb  %rbp,%r11
 18b6217:	45 31 ff             	xor    %r15d,%r15d
 18b621a:	49 83 c3 07          	add    $0x7,%r11
 18b621e:	49 21 c3             	and    %rax,%r11
 18b6221:	49 83 fb 09          	cmp    $0x9,%r11
 18b6225:	72 26                	jb     18b624d <tier0_tables_open+0x4a4d>
 18b6227:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18b622d:	49 83 fb 11          	cmp    $0x11,%r11
 18b6231:	72 1a                	jb     18b624d <tier0_tables_open+0x4a4d>
 18b6233:	41 bf 02 00 00 00    	mov    $0x2,%r15d
 18b6239:	49 83 fb 21          	cmp    $0x21,%r11
 18b623d:	72 0e                	jb     18b624d <tier0_tables_open+0x4a4d>
 18b623f:	49 83 fb 41          	cmp    $0x41,%r11
 18b6243:	41 bf 04 00 00 00    	mov    $0x4,%r15d
 18b6249:	41 83 df 00          	sbb    $0x0,%r15d
 18b624d:	48 8b 04 24          	mov    (%rsp),%rax
 18b6251:	48 8b 88 d8 00 00 00 	mov    0xd8(%rax),%rcx
 18b6258:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b625d:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
 18b6261:	48 89 8c 24 90 01 00 00 	mov    %rcx,0x190(%rsp)
 18b6269:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
 18b626e:	48 c1 e8 03          	shr    $0x3,%rax
 18b6272:	f6 84 24 d8 00 00 00 02 	testb  $0x2,0xd8(%rsp)
 18b627a:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
 18b627f:	74 39                	je     18b62ba <tier0_tables_open+0x4aba>
 18b6281:	31 c0                	xor    %eax,%eax
 18b6283:	c4 e2 f8 f3 cf       	blsr   %rdi,%rax
 18b6288:	0f 94 c0             	sete   %al
 18b628b:	48 85 ed             	test   %rbp,%rbp
 18b628e:	0f 94 c1             	sete   %cl
 18b6291:	08 c1                	or     %al,%cl
 18b6293:	0f 85 93 00 00 00    	jne    18b632c <tier0_tables_open+0x4b2c>
 18b6299:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18b629e:	48 09 e8             	or     %rbp,%rax
 18b62a1:	48 c1 e8 20          	shr    $0x20,%rax
 18b62a5:	0f 84 8e 00 00 00    	je     18b6339 <tier0_tables_open+0x4b39>
 18b62ab:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18b62b0:	31 d2                	xor    %edx,%edx
 18b62b2:	48 f7 f5             	div    %rbp
 18b62b5:	e9 88 00 00 00       	jmp    18b6342 <tier0_tables_open+0x4b42>
 18b62ba:	48 8b 04 24          	mov    (%rsp),%rax
 18b62be:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18b62c3:	4c 8b 4c 24 38       	mov    0x38(%rsp),%r9
 18b62c8:	48 89 bc 24 18 01 00 00 	mov    %rdi,0x118(%rsp)
 18b62d0:	48 8b 80 a8 01 00 00 	mov    0x1a8(%rax),%rax
 18b62d7:	8d 0c 36             	lea    (%rsi,%rsi,1),%ecx
 18b62da:	49 f7 c1 88 ff ff ff 	test   $0xffffffffffffff88,%r9
 18b62e1:	4a 8b 04 d0          	mov    (%rax,%r10,8),%rax
 18b62e5:	c4 e2 f1 f7 c8       	shlx   %rcx,%rax,%rcx
 18b62ea:	89 ca                	mov    %ecx,%edx
 18b62ec:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b62f1:	48 0f 45 d1          	cmovne %rcx,%rdx
 18b62f5:	48 c1 e8 20          	shr    $0x20,%rax
 18b62f9:	48 89 94 24 10 01 00 00 	mov    %rdx,0x110(%rsp)
 18b6301:	c4 e2 c9 f7 d0       	shlx   %rsi,%rax,%rdx
 18b6306:	48 b8 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rax
 18b6310:	48 c1 e2 20          	shl    $0x20,%rdx
 18b6314:	48 21 c2             	and    %rax,%rdx
 18b6317:	49 81 f9 80 00 00 00 	cmp    $0x80,%r9
 18b631e:	48 89 f0             	mov    %rsi,%rax
 18b6321:	48 0f 43 d1          	cmovae %rcx,%rdx
 18b6325:	b1 01                	mov    $0x1,%cl
 18b6327:	e9 f1 00 00 00       	jmp    18b641d <tier0_tables_open+0x4c1d>
 18b632c:	48 89 f8             	mov    %rdi,%rax
 18b632f:	48 f7 d8             	neg    %rax
 18b6332:	48 23 44 24 60       	and    0x60(%rsp),%rax
 18b6337:	eb 0d                	jmp    18b6346 <tier0_tables_open+0x4b46>
 18b6339:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18b633e:	31 d2                	xor    %edx,%edx
 18b6340:	f7 f5                	div    %ebp
 18b6342:	48 0f af c7          	imul   %rdi,%rax
 18b6346:	80 bc 24 d0 00 00 00 11 	cmpb   $0x11,0xd0(%rsp)
 18b634e:	b9 01 00 00 00       	mov    $0x1,%ecx
 18b6353:	be 00 00 00 00       	mov    $0x0,%esi
 18b6358:	41 bc 10 00 00 00    	mov    $0x10,%r12d
 18b635e:	c4 e2 81 f7 d1       	shlx   %r15,%rcx,%rdx
 18b6363:	48 0f 45 d7          	cmovne %rdi,%rdx
 18b6367:	48 0f 44 c6          	cmove  %rsi,%rax
 18b636b:	f3 48 0f b8 ca       	popcnt %rdx,%rcx
 18b6370:	48 89 94 24 18 01 00 00 	mov    %rdx,0x118(%rsp)
 18b6378:	f3 48 0f bc d2       	tzcnt  %rdx,%rdx
 18b637d:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
 18b6381:	48 83 fa 04          	cmp    $0x4,%rdx
 18b6385:	ba 09 00 00 00       	mov    $0x9,%edx
 18b638a:	4c 0f 43 ca          	cmovae %rdx,%r9
 18b638e:	83 f9 01             	cmp    $0x1,%ecx
 18b6391:	8d 0c 00             	lea    (%rax,%rax,1),%ecx
 18b6394:	4c 0f 45 ca          	cmovne %rdx,%r9
 18b6398:	48 a9 f1 ff ff ff    	test   $0xfffffffffffffff1,%rax
 18b639e:	c4 c2 f1 f7 d1       	shlx   %rcx,%r9,%rdx
 18b63a3:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18b63a9:	89 d2                	mov    %edx,%edx
 18b63ab:	48 0f 45 d6          	cmovne %rsi,%rdx
 18b63af:	48 89 94 24 10 01 00 00 	mov    %rdx,0x110(%rsp)
 18b63b7:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b63bc:	c4 e2 f1 f7 ca       	shlx   %rcx,%rdx,%rcx
 18b63c1:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 18b63c6:	48 0f 45 ce          	cmovne %rsi,%rcx
 18b63ca:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18b63cf:	48 8d 54 15 ff       	lea    -0x1(%rbp,%rdx,1),%rdx
 18b63d4:	48 c1 ea 03          	shr    $0x3,%rdx
 18b63d8:	48 29 f2             	sub    %rsi,%rdx
 18b63db:	48 ff c2             	inc    %rdx
 18b63de:	48 83 fe 10          	cmp    $0x10,%rsi
 18b63e2:	4c 0f 42 ce          	cmovb  %rsi,%r9
 18b63e6:	be 10 00 00 00       	mov    $0x10,%esi
 18b63eb:	4d 29 cc             	sub    %r9,%r12
 18b63ee:	4c 39 e2             	cmp    %r12,%rdx
 18b63f1:	42 8d 14 0a          	lea    (%rdx,%r9,1),%edx
 18b63f5:	0f 43 d6             	cmovae %esi,%edx
 18b63f8:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
 18b63ff:	44 29 ca             	sub    %r9d,%edx
 18b6402:	c4 e2 e9 f7 d6       	shlx   %rdx,%rsi,%rdx
 18b6407:	f7 d2                	not    %edx
 18b6409:	c4 e2 b1 f7 d2       	shlx   %r9,%rdx,%rdx
 18b640e:	48 c1 e2 20          	shl    $0x20,%rdx
 18b6412:	48 85 8c 24 28 01 00 00 	test   %rcx,0x128(%rsp)
 18b641a:	0f 94 c1             	sete   %cl
 18b641d:	44 89 c6             	mov    %r8d,%esi
 18b6420:	40 0a 74 24 70       	or     0x70(%rsp),%sil
 18b6425:	f6 c1 01             	test   $0x1,%cl
 18b6428:	44 0f b6 8c 24 d0 00 00 00 	movzbl 0xd0(%rsp),%r9d
 18b6431:	bd 00 00 00 00       	mov    $0x0,%ebp
 18b6436:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b643b:	48 0f 45 ac 24 10 01 00 00 	cmovne 0x110(%rsp),%rbp
 18b6444:	41 80 f9 11          	cmp    $0x11,%r9b
 18b6448:	40 88 b4 24 40 01 00 00 	mov    %sil,0x140(%rsp)
 18b6450:	48 0f 44 e9          	cmove  %rcx,%rbp
 18b6454:	40 84 f6             	test   %sil,%sil
 18b6457:	48 0f 44 e9          	cmove  %rcx,%rbp
 18b645b:	41 80 f9 11          	cmp    $0x11,%r9b
 18b645f:	75 2e                	jne    18b648f <tier0_tables_open+0x4c8f>
 18b6461:	48 8b 04 24          	mov    (%rsp),%rax
 18b6465:	48 8b 80 a0 01 00 00 	mov    0x1a0(%rax),%rax
 18b646c:	42 0f b6 04 10       	movzbl (%rax,%r10,1),%eax
 18b6471:	88 44 24 70          	mov    %al,0x70(%rsp)
 18b6475:	31 c0                	xor    %eax,%eax
 18b6477:	49 81 fb 80 00 00 00 	cmp    $0x80,%r11
 18b647e:	0f 94 c0             	sete   %al
 18b6481:	45 31 db             	xor    %r11d,%r11d
 18b6484:	c1 e0 04             	shl    $0x4,%eax
 18b6487:	41 09 c7             	or     %eax,%r15d
 18b648a:	e9 bf 02 00 00       	jmp    18b674e <tier0_tables_open+0x4f4e>
 18b648f:	44 0f b6 84 24 d8 00 00 00 	movzbl 0xd8(%rsp),%r8d
 18b6498:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18b64a1:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18b64a7:	45 89 c3             	mov    %r8d,%r11d
 18b64aa:	0f 95 c1             	setne  %cl
 18b64ad:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 18b64b3:	41 80 e3 02          	and    $0x2,%r11b
 18b64b7:	41 d0 eb             	shr    $1,%r11b
 18b64ba:	48 83 f8 10          	cmp    $0x10,%rax
 18b64be:	49 0f 43 c0          	cmovae %r8,%rax
 18b64c2:	4c 8b 04 24          	mov    (%rsp),%r8
 18b64c6:	49 29 c1             	sub    %rax,%r9
 18b64c9:	8d 34 07             	lea    (%rdi,%rax,1),%esi
 18b64cc:	4c 39 cf             	cmp    %r9,%rdi
 18b64cf:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18b64d5:	41 0f 43 f1          	cmovae %r9d,%esi
 18b64d9:	41 20 cb             	and    %cl,%r11b
 18b64dc:	49 8b b8 a0 01 00 00 	mov    0x1a0(%r8),%rdi
 18b64e3:	48 89 fb             	mov    %rdi,%rbx
 18b64e6:	42 0f b6 3c 17       	movzbl (%rdi,%r10,1),%edi
 18b64eb:	40 88 7c 24 70       	mov    %dil,0x70(%rsp)
 18b64f0:	41 80 fb 01          	cmp    $0x1,%r11b
 18b64f4:	0f 85 15 02 00 00    	jne    18b670f <tier0_tables_open+0x4f0f>
 18b64fa:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
 18b64fe:	48 39 4c 24 10       	cmp    %rcx,0x10(%rsp)
 18b6503:	0f 82 06 02 00 00    	jb     18b670f <tier0_tables_open+0x4f0f>
 18b6509:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18b650e:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18b6516:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
 18b651b:	41 ff c0             	inc    %r8d
 18b651e:	48 01 cf             	add    %rcx,%rdi
 18b6521:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
 18b6526:	44 3b 84 24 e0 00 00 00 	cmp    0xe0(%rsp),%r8d
 18b652e:	0f 83 ac 00 00 00    	jae    18b65e0 <tier0_tables_open+0x4de0>
 18b6534:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 18b653c:	4c 8b 94 24 98 01 00 00 	mov    0x198(%rsp),%r10
 18b6544:	4c 8b bc 24 38 01 00 00 	mov    0x138(%rsp),%r15
 18b654c:	48 c7 44 24 20 00 00 00 00 	movq   $0x0,0x20(%rsp)
 18b6555:	4a 8d 0c 85 00 00 00 00 	lea    0x0(,%r8,4),%rcx
 18b655d:	4e 8d 0c c5 00 00 00 00 	lea    0x0(,%r8,8),%r9
 18b6565:	48 03 8c 24 30 01 00 00 	add    0x130(%rsp),%rcx
 18b656d:	4c 03 8c 24 90 01 00 00 	add    0x190(%rsp),%r9
 18b6575:	4d 29 c2             	sub    %r8,%r10
 18b6578:	4d 01 f8             	add    %r15,%r8
 18b657b:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 18b6583:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18b6588:	4c 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%r15
 18b6590:	43 f6 04 07 02       	testb  $0x2,(%r15,%r8,1)
 18b6595:	74 38                	je     18b65cf <tier0_tables_open+0x4dcf>
 18b6597:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18b659c:	4f 8b 3c c1          	mov    (%r9,%r8,8),%r15
 18b65a0:	41 f6 c7 07          	test   $0x7,%r15b
 18b65a4:	74 29                	je     18b65cf <tier0_tables_open+0x4dcf>
 18b65a6:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18b65ab:	46 8b 24 81          	mov    (%rcx,%r8,4),%r12d
 18b65af:	4d 01 e7             	add    %r12,%r15
 18b65b2:	49 39 ff             	cmp    %rdi,%r15
 18b65b5:	49 0f 47 ff          	cmova  %r15,%rdi
 18b65b9:	49 ff c0             	inc    %r8
 18b65bc:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
 18b65c1:	4d 39 c2             	cmp    %r8,%r10
 18b65c4:	75 bd                	jne    18b6583 <tier0_tables_open+0x4d83>
 18b65c6:	8b 8c 24 e0 00 00 00 	mov    0xe0(%rsp),%ecx
 18b65cd:	eb 0c                	jmp    18b65db <tier0_tables_open+0x4ddb>
 18b65cf:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18b65d4:	2b 8c 24 f8 00 00 00 	sub    0xf8(%rsp),%ecx
 18b65db:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 18b65e0:	48 2b 7c 24 38       	sub    0x38(%rsp),%rdi
 18b65e5:	b1 ff                	mov    $0xff,%cl
 18b65e7:	89 8c 24 e4 00 00 00 	mov    %ecx,0xe4(%rsp)
 18b65ee:	48 83 c7 07          	add    $0x7,%rdi
 18b65f2:	48 83 ff 48          	cmp    $0x48,%rdi
 18b65f6:	0f 82 03 01 00 00    	jb     18b66ff <tier0_tables_open+0x4eff>
 18b65fc:	48 8b 8c 24 b8 00 00 00 	mov    0xb8(%rsp),%rcx
 18b6604:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18b6609:	44 3b 84 24 e0 00 00 00 	cmp    0xe0(%rsp),%r8d
 18b6611:	0f 83 ad 00 00 00    	jae    18b66c4 <tier0_tables_open+0x4ec4>
 18b6617:	44 8b 54 24 20       	mov    0x20(%rsp),%r10d
 18b661c:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18b6624:	46 0f b6 0c 11       	movzbl (%rcx,%r10,1),%r9d
 18b6629:	b1 01                	mov    $0x1,%cl
 18b662b:	41 f6 c1 02          	test   $0x2,%r9b
 18b662f:	74 10                	je     18b6641 <tier0_tables_open+0x4e41>
 18b6631:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18b6639:	42 83 3c 91 00       	cmpl   $0x0,(%rcx,%r10,4)
 18b663e:	0f 95 c1             	setne  %cl
 18b6641:	47 8b 64 95 00       	mov    0x0(%r13,%r10,4),%r12d
 18b6646:	4c 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%r8
 18b664e:	41 c1 ec 03          	shr    $0x3,%r12d
 18b6652:	43 80 3c 20 0f       	cmpb   $0xf,(%r8,%r12,1)
 18b6657:	75 23                	jne    18b667c <tier0_tables_open+0x4e7c>
 18b6659:	4c 8b 04 24          	mov    (%rsp),%r8
 18b665d:	4d 8b 78 20          	mov    0x20(%r8),%r15
 18b6661:	47 8b 24 a7          	mov    (%r15,%r12,4),%r12d
 18b6665:	41 c1 ec 03          	shr    $0x3,%r12d
 18b6669:	41 b7 01             	mov    $0x1,%r15b
 18b666c:	41 f6 c1 02          	test   $0x2,%r9b
 18b6670:	74 13                	je     18b6685 <tier0_tables_open+0x4e85>
 18b6672:	44 20 f9             	and    %r15b,%cl
 18b6675:	80 f9 01             	cmp    $0x1,%cl
 18b6678:	75 1f                	jne    18b6699 <tier0_tables_open+0x4e99>
 18b667a:	eb 38                	jmp    18b66b4 <tier0_tables_open+0x4eb4>
 18b667c:	41 b7 01             	mov    $0x1,%r15b
 18b667f:	41 f6 c1 02          	test   $0x2,%r9b
 18b6683:	75 ed                	jne    18b6672 <tier0_tables_open+0x4e72>
 18b6685:	45 89 e1             	mov    %r12d,%r9d
 18b6688:	42 f6 04 0b 20       	testb  $0x20,(%rbx,%r9,1)
 18b668d:	41 0f 94 c7          	sete   %r15b
 18b6691:	44 20 f9             	and    %r15b,%cl
 18b6694:	80 f9 01             	cmp    $0x1,%cl
 18b6697:	74 1b                	je     18b66b4 <tier0_tables_open+0x4eb4>
 18b6699:	49 ff c2             	inc    %r10
 18b669c:	4c 39 94 24 98 01 00 00 	cmp    %r10,0x198(%rsp)
 18b66a4:	0f 85 72 ff ff ff    	jne    18b661c <tier0_tables_open+0x4e1c>
 18b66aa:	48 8b 8c 24 b8 00 00 00 	mov    0xb8(%rsp),%rcx
 18b66b2:	eb 10                	jmp    18b66c4 <tier0_tables_open+0x4ec4>
 18b66b4:	48 8b 8c 24 90 01 00 00 	mov    0x190(%rsp),%rcx
 18b66bc:	4a 8b 0c d1          	mov    (%rcx,%r10,8),%rcx
 18b66c0:	48 c1 e9 03          	shr    $0x3,%rcx
 18b66c4:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 18b66c9:	48 c1 ef 03          	shr    $0x3,%rdi
 18b66cd:	48 83 c7 0f          	add    $0xf,%rdi
 18b66d1:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
 18b66d5:	48 83 ff 10          	cmp    $0x10,%rdi
 18b66d9:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 18b66dd:	41 0f 94 c0          	sete   %r8b
 18b66e1:	bf 00 00 00 00       	mov    $0x0,%edi
 18b66e6:	41 c0 e0 04          	shl    $0x4,%r8b
 18b66ea:	41 80 c8 04          	or     $0x4,%r8b
 18b66ee:	49 39 c9             	cmp    %rcx,%r9
 18b66f1:	41 0f b6 c8          	movzbl %r8b,%ecx
 18b66f5:	0f 47 cf             	cmova  %edi,%ecx
 18b66f8:	89 8c 24 e4 00 00 00 	mov    %ecx,0xe4(%rsp)
 18b66ff:	48 8b 9c 24 70 01 00 00 	mov    0x170(%rsp),%rbx
 18b6707:	48 89 9c 24 a8 00 00 00 	mov    %rbx,0xa8(%rsp)
 18b670f:	29 c6                	sub    %eax,%esi
 18b6711:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
 18b6718:	c4 e2 c9 f7 c9       	shlx   %rsi,%rcx,%rcx
 18b671d:	f7 d1                	not    %ecx
 18b671f:	c4 e2 f9 f7 c1       	shlx   %rax,%rcx,%rax
 18b6724:	8b 8c 24 e4 00 00 00 	mov    0xe4(%rsp),%ecx
 18b672b:	48 c1 e0 30          	shl    $0x30,%rax
 18b672f:	48 09 c2             	or     %rax,%rdx
 18b6732:	0f b6 44 24 70       	movzbl 0x70(%rsp),%eax
 18b6737:	44 0f b6 f9          	movzbl %cl,%r15d
 18b673b:	24 0f                	and    $0xf,%al
 18b673d:	80 f9 ff             	cmp    $0xff,%cl
 18b6740:	0f b6 c0             	movzbl %al,%eax
 18b6743:	44 0f 44 f8          	cmove  %eax,%r15d
 18b6747:	45 84 db             	test   %r11b,%r11b
 18b674a:	44 0f 44 f8          	cmove  %eax,%r15d
 18b674e:	44 0f b6 84 24 d8 00 00 00 	movzbl 0xd8(%rsp),%r8d
 18b6757:	0f b6 44 24 70       	movzbl 0x70(%rsp),%eax
 18b675c:	41 0f b6 cf          	movzbl %r15b,%ecx
 18b6760:	41 f6 c0 02          	test   $0x2,%r8b
 18b6764:	0f 44 c8             	cmove  %eax,%ecx
 18b6767:	89 cf                	mov    %ecx,%edi
 18b6769:	83 e7 0f             	and    $0xf,%edi
 18b676c:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
 18b6772:	44 0f b6 c9          	movzbl %cl,%r9d
 18b6776:	0f 94 c0             	sete   %al
 18b6779:	22 84 24 40 01 00 00 	and    0x140(%rsp),%al
 18b6780:	48 83 bc 24 18 01 00 00 00 	cmpq   $0x0,0x118(%rsp)
 18b6789:	41 0f 95 c7          	setne  %r15b
 18b678d:	41 20 c7             	and    %al,%r15b
 18b6790:	41 f6 c0 02          	test   $0x2,%r8b
 18b6794:	74 33                	je     18b67c9 <tier0_tables_open+0x4fc9>
 18b6796:	80 bc 24 e4 00 00 00 ff 	cmpb   $0xff,0xe4(%rsp)
 18b679e:	49 ba 00 00 00 00 00 00 08 00 	movabs $0x8000000000000,%r10
 18b67a8:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b67ad:	b8 00 00 00 00       	mov    $0x0,%eax
 18b67b2:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
 18b67b7:	41 0f 94 c4          	sete   %r12b
 18b67bb:	45 84 e3             	test   %r12b,%r11b
 18b67be:	0f 84 c3 f5 ff ff    	je     18b5d87 <tier0_tables_open+0x4587>
 18b67c4:	e9 ca f5 ff ff       	jmp    18b5d93 <tier0_tables_open+0x4593>
 18b67c9:	c4 e2 40 f5 44 24 60 	bzhi   %edi,0x60(%rsp),%eax
 18b67d0:	48 b9 00 00 00 00 00 00 01 00 	movabs $0x1000000000000,%rcx
 18b67da:	b8 00 00 00 00       	mov    $0x0,%eax
 18b67df:	49 ba 00 00 00 00 00 00 08 00 	movabs $0x8000000000000,%r10
 18b67e9:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
 18b67ee:	48 0f 44 c8          	cmove  %rax,%rcx
 18b67f2:	f6 44 24 70 40       	testb  $0x40,0x70(%rsp)
 18b67f7:	48 89 c8             	mov    %rcx,%rax
 18b67fa:	0f 85 93 f5 ff ff    	jne    18b5d93 <tier0_tables_open+0x4593>
 18b6800:	e9 82 f5 ff ff       	jmp    18b5d87 <tier0_tables_open+0x4587>
 18b6805:	48 c7 44 24 58 00 00 00 00 	movq   $0x0,0x58(%rsp)
 18b680e:	e9 cc 05 00 00       	jmp    18b6ddf <tier0_tables_open+0x55df>
 18b6813:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 18b6818:	89 f2                	mov    %esi,%edx
 18b681a:	83 e2 07             	and    $0x7,%edx
 18b681d:	48 83 fe 08          	cmp    $0x8,%rsi
 18b6821:	73 07                	jae    18b682a <tier0_tables_open+0x502a>
 18b6823:	31 ff                	xor    %edi,%edi
 18b6825:	e9 42 02 00 00       	jmp    18b6a6c <tier0_tables_open+0x526c>
 18b682a:	8d 34 cd 00 00 00 00 	lea    0x0(,%rcx,8),%esi
 18b6831:	8d 3c cd 00 00 00 00 	lea    0x0(,%rcx,8),%edi
 18b6838:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
 18b683d:	44 8d 24 8d 00 00 00 00 	lea    0x0(,%rcx,4),%r12d
 18b6845:	44 8d 2c 49          	lea    (%rcx,%rcx,2),%r13d
 18b6849:	8d 2c 09             	lea    (%rcx,%rcx,1),%ebp
 18b684c:	41 ba c0 01 00 00    	mov    $0x1c0,%r10d
 18b6852:	45 31 c0             	xor    %r8d,%r8d
 18b6855:	29 ce                	sub    %ecx,%esi
 18b6857:	89 bc 24 80 00 00 00 	mov    %edi,0x80(%rsp)
 18b685e:	8d 3c 09             	lea    (%rcx,%rcx,1),%edi
 18b6861:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 18b6866:	8d 34 7f             	lea    (%rdi,%rdi,2),%esi
 18b6869:	31 ff                	xor    %edi,%edi
 18b686b:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 18b6870:	8d 34 89             	lea    (%rcx,%rcx,4),%esi
 18b6873:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
 18b6877:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
 18b687c:	4d 8b 0e             	mov    (%r14),%r9
 18b687f:	c5 f9 6f 15 89 f3 cb fe 	vmovdqa -0x1340c77(%rip),%xmm2        # 575c10 <x86_effects_unknown+0x1b0>
 18b6887:	c4 e2 79 78 1d 31 9f c6 fe 	vpbroadcastb -0x13960cf(%rip),%xmm3        # 5207c1 <branch_sizing_patterns+0xa31>
 18b6890:	62 d2 7d 08 7a c8    	vpbroadcastb %r8d,%xmm1
 18b6896:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
 18b689b:	4d 8d 9a 40 fe ff ff 	lea    -0x1c0(%r10),%r11
 18b68a2:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18b68ac:	48 83 c7 08          	add    $0x8,%rdi
 18b68b0:	49 21 f3             	and    %rsi,%r11
 18b68b3:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18b68b9:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18b68bd:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18b68c1:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b68c6:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18b68cc:	4d 8d 9a 80 fe ff ff 	lea    -0x180(%r10),%r11
 18b68d3:	4d 8b 0e             	mov    (%r14),%r9
 18b68d6:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18b68dc:	46 8d 0c 01          	lea    (%rcx,%r8,1),%r9d
 18b68e0:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18b68e6:	4c 8d 4e 40          	lea    0x40(%rsi),%r9
 18b68ea:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18b68ee:	4d 21 cb             	and    %r9,%r11
 18b68f1:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18b68f5:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b68fa:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18b6900:	46 8d 5c 05 00       	lea    0x0(%rbp,%r8,1),%r11d
 18b6905:	4d 8b 0e             	mov    (%r14),%r9
 18b6908:	62 d2 7d 08 7a cb    	vpbroadcastb %r11d,%xmm1
 18b690e:	4c 8d 9e 80 00 00 00 	lea    0x80(%rsi),%r11
 18b6915:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18b6919:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18b691d:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18b6923:	4d 8d 8a c0 fe ff ff 	lea    -0x140(%r10),%r9
 18b692a:	4d 21 cb             	and    %r9,%r11
 18b692d:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b6932:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18b6938:	4d 8d 9a 00 ff ff ff 	lea    -0x100(%r10),%r11
 18b693f:	4d 8b 0e             	mov    (%r14),%r9
 18b6942:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18b6948:	47 8d 4c 05 00       	lea    0x0(%r13,%r8,1),%r9d
 18b694d:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18b6953:	4c 8d 8e c0 00 00 00 	lea    0xc0(%rsi),%r9
 18b695a:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18b695e:	4d 21 d9             	and    %r11,%r9
 18b6961:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18b6965:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b696a:	c4 81 79 7f 04 0f    	vmovdqa %xmm0,(%r15,%r9,1)
 18b6970:	4d 8d 8a 40 ff ff ff 	lea    -0xc0(%r10),%r9
 18b6977:	4d 8b 1e             	mov    (%r14),%r11
 18b697a:	c4 c1 79 6f 04 03    	vmovdqa (%r11,%rax,1),%xmm0
 18b6980:	4c 8d 9e 00 01 00 00 	lea    0x100(%rsi),%r11
 18b6987:	4d 21 cb             	and    %r9,%r11
 18b698a:	47 8d 0c 04          	lea    (%r12,%r8,1),%r9d
 18b698e:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18b6994:	4d 8d 4a 80          	lea    -0x80(%r10),%r9
 18b6998:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18b699c:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18b69a0:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b69a5:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18b69ab:	4c 8d 9e 40 01 00 00 	lea    0x140(%rsi),%r11
 18b69b2:	4d 21 cb             	and    %r9,%r11
 18b69b5:	4d 8b 0e             	mov    (%r14),%r9
 18b69b8:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18b69be:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 18b69c3:	45 01 c1             	add    %r8d,%r9d
 18b69c6:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18b69cc:	4d 8d 4a c0          	lea    -0x40(%r10),%r9
 18b69d0:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18b69d4:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18b69d8:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b69dd:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18b69e3:	4d 8b 1e             	mov    (%r14),%r11
 18b69e6:	c4 c1 79 6f 04 03    	vmovdqa (%r11,%rax,1),%xmm0
 18b69ec:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
 18b69f1:	45 01 c3             	add    %r8d,%r11d
 18b69f4:	62 d2 7d 08 7a cb    	vpbroadcastb %r11d,%xmm1
 18b69fa:	4c 8d 9e 80 01 00 00 	lea    0x180(%rsi),%r11
 18b6a01:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18b6a05:	4d 21 cb             	and    %r9,%r11
 18b6a08:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18b6a0c:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b6a11:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18b6a17:	4d 8b 0e             	mov    (%r14),%r9
 18b6a1a:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18b6a20:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18b6a25:	45 01 c1             	add    %r8d,%r9d
 18b6a28:	44 02 84 24 80 00 00 00 	add    0x80(%rsp),%r8b
 18b6a30:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18b6a36:	4c 8d 8e c0 01 00 00 	lea    0x1c0(%rsi),%r9
 18b6a3d:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18b6a41:	4d 21 d1             	and    %r10,%r9
 18b6a44:	49 81 c2 00 02 00 00 	add    $0x200,%r10
 18b6a4b:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18b6a4f:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b6a54:	c4 81 79 7f 04 0f    	vmovdqa %xmm0,(%r15,%r9,1)
 18b6a5a:	48 39 fb             	cmp    %rdi,%rbx
 18b6a5d:	0f 85 19 fe ff ff    	jne    18b687c <tier0_tables_open+0x507c>
 18b6a63:	48 85 d2             	test   %rdx,%rdx
 18b6a66:	0f 84 73 03 00 00    	je     18b6ddf <tier0_tables_open+0x55df>
 18b6a6c:	41 89 c8             	mov    %ecx,%r8d
 18b6a6f:	44 0f af c7          	imul   %edi,%r8d
 18b6a73:	48 c1 e7 06          	shl    $0x6,%rdi
 18b6a77:	4d 8b 0e             	mov    (%r14),%r9
 18b6a7a:	62 d2 7d 08 7a c8    	vpbroadcastb %r8d,%xmm1
 18b6a80:	c5 f1 fc 0d 88 f1 cb fe 	vpaddb -0x1340e78(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 18b6a88:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18b6a92:	41 00 c8             	add    %cl,%r8b
 18b6a95:	62 f1 75 18 db 0d 25 9a cc fe 	vpandd -0x13365db(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18b6a9f:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18b6aa6:	48 21 fe             	and    %rdi,%rsi
 18b6aa9:	48 83 c7 40          	add    $0x40,%rdi
 18b6aad:	48 ff ca             	dec    %rdx
 18b6ab0:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18b6ab6:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
 18b6abb:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b6ac0:	c4 c1 79 7f 04 31    	vmovdqa %xmm0,(%r9,%rsi,1)
 18b6ac6:	75 af                	jne    18b6a77 <tier0_tables_open+0x5277>
 18b6ac8:	e9 12 03 00 00       	jmp    18b6ddf <tier0_tables_open+0x55df>
 18b6acd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 18b6ad2:	89 d1                	mov    %edx,%ecx
 18b6ad4:	83 e1 07             	and    $0x7,%ecx
 18b6ad7:	48 83 fa 08          	cmp    $0x8,%rdx
 18b6adb:	0f 83 fe 01 00 00    	jae    18b6cdf <tier0_tables_open+0x54df>
 18b6ae1:	31 d2                	xor    %edx,%edx
 18b6ae3:	e9 c4 02 00 00       	jmp    18b6dac <tier0_tables_open+0x55ac>
 18b6ae8:	4c 8b 4c 24 58       	mov    0x58(%rsp),%r9
 18b6aed:	41 89 cf             	mov    %ecx,%r15d
 18b6af0:	41 83 e7 7f          	and    $0x7f,%r15d
 18b6af4:	45 31 e4             	xor    %r12d,%r12d
 18b6af7:	45 31 ed             	xor    %r13d,%r13d
 18b6afa:	31 ed                	xor    %ebp,%ebp
 18b6afc:	45 31 db             	xor    %r11d,%r11d
 18b6aff:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18b6b08:	45 31 c0             	xor    %r8d,%r8d
 18b6b0b:	45 01 ff             	add    %r15d,%r15d
 18b6b0e:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
 18b6b12:	eb 25                	jmp    18b6b39 <tier0_tables_open+0x5339>
 18b6b14:	48 8d 14 8d 00 00 00 00 	lea    0x0(,%rcx,4),%rdx
 18b6b1c:	49 83 c0 02          	add    $0x2,%r8
 18b6b20:	49 83 eb 80          	sub    $0xffffffffffffff80,%r11
 18b6b24:	4d 01 fc             	add    %r15,%r12
 18b6b27:	49 01 cd             	add    %rcx,%r13
 18b6b2a:	49 01 cd             	add    %rcx,%r13
 18b6b2d:	48 01 d5             	add    %rdx,%rbp
 18b6b30:	4d 39 c1             	cmp    %r8,%r9
 18b6b33:	0f 84 03 01 00 00    	je     18b6c3c <tier0_tables_open+0x543c>
 18b6b39:	49 8b 36             	mov    (%r14),%rsi
 18b6b3c:	62 d2 7d 08 7a cc    	vpbroadcastb %r12d,%xmm1
 18b6b42:	c5 f1 fc 0d c6 f0 cb fe 	vpaddb -0x1340f3a(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 18b6b4a:	48 ba 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rdx
 18b6b54:	62 f1 75 18 db 0d 66 99 cc fe 	vpandd -0x133669a(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18b6b5e:	4c 8d 92 80 01 00 00 	lea    0x180(%rdx),%r10
 18b6b65:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b6b6a:	4d 21 da             	and    %r11,%r10
 18b6b6d:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
 18b6b72:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b6b77:	c4 a1 79 7f 04 12    	vmovdqa %xmm0,(%rdx,%r10,1)
 18b6b7d:	49 83 fd 0f          	cmp    $0xf,%r13
 18b6b81:	77 28                	ja     18b6bab <tier0_tables_open+0x53ab>
 18b6b83:	c4 e2 91 f7 54 24 10 	shlx   %r13,0x10(%rsp),%rdx
 18b6b8a:	48 be 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rsi
 18b6b94:	c4 62 d1 f7 d3       	shlx   %rbp,%rbx,%r10
 18b6b99:	45 89 d2             	mov    %r10d,%r10d
 18b6b9c:	48 c1 e2 20          	shl    $0x20,%rdx
 18b6ba0:	48 21 f2             	and    %rsi,%rdx
 18b6ba3:	4c 09 d2             	or     %r10,%rdx
 18b6ba6:	48 09 54 24 30       	or     %rdx,0x30(%rsp)
 18b6bab:	49 8b 3e             	mov    (%r14),%rdi
 18b6bae:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18b6bb8:	49 8d 53 40          	lea    0x40(%r11),%rdx
 18b6bbc:	4c 8d 96 c0 01 00 00 	lea    0x1c0(%rsi),%r10
 18b6bc3:	42 8d 34 21          	lea    (%rcx,%r12,1),%esi
 18b6bc7:	62 f2 7d 08 7a ce    	vpbroadcastb %esi,%xmm1
 18b6bcd:	c5 f1 fc 0d 3b f0 cb fe 	vpaddb -0x1340fc5(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 18b6bd5:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b6bda:	4c 21 d2             	and    %r10,%rdx
 18b6bdd:	4e 8d 14 29          	lea    (%rcx,%r13,1),%r10
 18b6be1:	62 f1 75 18 db 0d d9 98 cc fe 	vpandd -0x1336727(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18b6beb:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18b6bf0:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b6bf5:	c5 f9 7f 04 16       	vmovdqa %xmm0,(%rsi,%rdx,1)
 18b6bfa:	49 83 fa 0f          	cmp    $0xf,%r10
 18b6bfe:	0f 87 10 ff ff ff    	ja     18b6b14 <tier0_tables_open+0x5314>
 18b6c04:	c4 e2 a9 f7 7c 24 10 	shlx   %r10,0x10(%rsp),%rdi
 18b6c0b:	48 8d 14 09          	lea    (%rcx,%rcx,1),%rdx
 18b6c0f:	be 00 00 00 00       	mov    $0x0,%esi
 18b6c14:	01 ea                	add    %ebp,%edx
 18b6c16:	c4 e2 e9 f7 d3       	shlx   %rdx,%rbx,%rdx
 18b6c1b:	83 e2 fe             	and    $0xfffffffe,%edx
 18b6c1e:	f6 c1 01             	test   $0x1,%cl
 18b6c21:	48 0f 45 d6          	cmovne %rsi,%rdx
 18b6c25:	81 e7 fe ff 00 00    	and    $0xfffe,%edi
 18b6c2b:	48 c1 e7 20          	shl    $0x20,%rdi
 18b6c2f:	48 09 d7             	or     %rdx,%rdi
 18b6c32:	48 09 7c 24 30       	or     %rdi,0x30(%rsp)
 18b6c37:	e9 d8 fe ff ff       	jmp    18b6b14 <tier0_tables_open+0x5314>
 18b6c3c:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
 18b6c41:	0f 84 8a 00 00 00    	je     18b6cd1 <tier0_tables_open+0x54d1>
 18b6c47:	49 8b 3e             	mov    (%r14),%rdi
 18b6c4a:	49 0f af c8          	imul   %r8,%rcx
 18b6c4e:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18b6c58:	4c 89 c2             	mov    %r8,%rdx
 18b6c5b:	48 c1 e2 06          	shl    $0x6,%rdx
 18b6c5f:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18b6c66:	48 21 d6             	and    %rdx,%rsi
 18b6c69:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18b6c6f:	c5 f1 fc 0d 99 ef cb fe 	vpaddb -0x1341067(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 18b6c77:	62 f1 75 18 db 0d 43 98 cc fe 	vpandd -0x13367bd(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18b6c81:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18b6c86:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18b6c8b:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18b6c90:	c5 f9 7f 04 30       	vmovdqa %xmm0,(%rax,%rsi,1)
 18b6c95:	48 83 f9 0f          	cmp    $0xf,%rcx
 18b6c99:	77 36                	ja     18b6cd1 <tier0_tables_open+0x54d1>
 18b6c9b:	c4 e2 f1 f7 54 24 10 	shlx   %rcx,0x10(%rsp),%rdx
 18b6ca2:	89 c8                	mov    %ecx,%eax
 18b6ca4:	01 c9                	add    %ecx,%ecx
 18b6ca6:	a8 01                	test   $0x1,%al
 18b6ca8:	c4 e2 f1 f7 c3       	shlx   %rcx,%rbx,%rax
 18b6cad:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b6cb2:	89 c0                	mov    %eax,%eax
 18b6cb4:	48 0f 45 c1          	cmovne %rcx,%rax
 18b6cb8:	48 b9 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rcx
 18b6cc2:	48 c1 e2 20          	shl    $0x20,%rdx
 18b6cc6:	48 21 ca             	and    %rcx,%rdx
 18b6cc9:	48 09 c2             	or     %rax,%rdx
 18b6ccc:	48 09 54 24 30       	or     %rdx,0x30(%rsp)
 18b6cd1:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18b6cda:	e9 12 01 00 00       	jmp    18b6df1 <tier0_tables_open+0x55f1>
 18b6cdf:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 18b6ce4:	45 31 c0             	xor    %r8d,%r8d
 18b6ce7:	31 d2                	xor    %edx,%edx
 18b6ce9:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 18b6ced:	4d 8b 16             	mov    (%r14),%r10
 18b6cf0:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18b6cfa:	4d 89 c1             	mov    %r8,%r9
 18b6cfd:	48 83 c2 08          	add    $0x8,%rdx
 18b6d01:	49 81 c0 00 02 00 00 	add    $0x200,%r8
 18b6d08:	49 21 f1             	and    %rsi,%r9
 18b6d0b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b6d10:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18b6d16:	c4 a1 78 29 04 0e    	vmovaps %xmm0,(%rsi,%r9,1)
 18b6d1c:	4d 8b 16             	mov    (%r14),%r10
 18b6d1f:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18b6d25:	c4 a1 78 29 44 0e 40 	vmovaps %xmm0,0x40(%rsi,%r9,1)
 18b6d2c:	4d 8b 16             	mov    (%r14),%r10
 18b6d2f:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18b6d35:	c4 a1 78 29 84 0e 80 00 00 00 	vmovaps %xmm0,0x80(%rsi,%r9,1)
 18b6d3f:	4d 8b 16             	mov    (%r14),%r10
 18b6d42:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18b6d48:	c4 a1 78 29 84 0e c0 00 00 00 	vmovaps %xmm0,0xc0(%rsi,%r9,1)
 18b6d52:	4d 8b 16             	mov    (%r14),%r10
 18b6d55:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18b6d5b:	c4 a1 78 29 84 0e 00 01 00 00 	vmovaps %xmm0,0x100(%rsi,%r9,1)
 18b6d65:	4d 8b 16             	mov    (%r14),%r10
 18b6d68:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18b6d6e:	c4 a1 78 29 84 0e 40 01 00 00 	vmovaps %xmm0,0x140(%rsi,%r9,1)
 18b6d78:	4d 8b 16             	mov    (%r14),%r10
 18b6d7b:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18b6d81:	c4 a1 78 29 84 0e 80 01 00 00 	vmovaps %xmm0,0x180(%rsi,%r9,1)
 18b6d8b:	4d 8b 16             	mov    (%r14),%r10
 18b6d8e:	c4 c1 79 6f 04 02    	vmovdqa (%r10,%rax,1),%xmm0
 18b6d94:	c4 a1 79 7f 84 0e c0 01 00 00 	vmovdqa %xmm0,0x1c0(%rsi,%r9,1)
 18b6d9e:	48 39 d7             	cmp    %rdx,%rdi
 18b6da1:	0f 85 46 ff ff ff    	jne    18b6ced <tier0_tables_open+0x54ed>
 18b6da7:	48 85 c9             	test   %rcx,%rcx
 18b6daa:	74 33                	je     18b6ddf <tier0_tables_open+0x55df>
 18b6dac:	48 c1 e2 06          	shl    $0x6,%rdx
 18b6db0:	49 8b 3e             	mov    (%r14),%rdi
 18b6db3:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18b6dbd:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18b6dc4:	48 21 d6             	and    %rdx,%rsi
 18b6dc7:	48 83 c2 40          	add    $0x40,%rdx
 18b6dcb:	48 ff c9             	dec    %rcx
 18b6dce:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18b6dd3:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 18b6dd8:	c5 f9 7f 04 37       	vmovdqa %xmm0,(%rdi,%rsi,1)
 18b6ddd:	75 d1                	jne    18b6db0 <tier0_tables_open+0x55b0>
 18b6ddf:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18b6de8:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18b6df1:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18b6df6:	3b 44 24 68          	cmp    0x68(%rsp),%eax
 18b6dfa:	0f 83 c2 00 00 00    	jae    18b6ec2 <tier0_tables_open+0x56c2>
 18b6e00:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 18b6e05:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 18b6e0a:	29 d1                	sub    %edx,%ecx
 18b6e0c:	89 d0                	mov    %edx,%eax
 18b6e0e:	48 89 c2             	mov    %rax,%rdx
 18b6e11:	83 e1 07             	and    $0x7,%ecx
 18b6e14:	74 3b                	je     18b6e51 <tier0_tables_open+0x5651>
 18b6e16:	48 89 c2             	mov    %rax,%rdx
 18b6e19:	48 c1 e2 06          	shl    $0x6,%rdx
 18b6e1d:	48 03 94 24 88 01 00 00 	add    0x188(%rsp),%rdx
 18b6e25:	48 f7 d9             	neg    %rcx
 18b6e28:	31 ff                	xor    %edi,%edi
 18b6e2a:	48 03 94 24 80 01 00 00 	add    0x180(%rsp),%rdx
 18b6e32:	c4 e2 79 59 05 c5 92 cc fe 	vpbroadcastq -0x1336d3b(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18b6e3b:	48 ff cf             	dec    %rdi
 18b6e3e:	c5 f9 7f 02          	vmovdqa %xmm0,(%rdx)
 18b6e42:	48 83 c2 40          	add    $0x40,%rdx
 18b6e46:	48 39 f9             	cmp    %rdi,%rcx
 18b6e49:	75 e7                	jne    18b6e32 <tier0_tables_open+0x5632>
 18b6e4b:	48 89 c2             	mov    %rax,%rdx
 18b6e4e:	48 29 fa             	sub    %rdi,%rdx
 18b6e51:	48 2b 44 24 68       	sub    0x68(%rsp),%rax
 18b6e56:	48 83 f8 f8          	cmp    $0xfffffffffffffff8,%rax
 18b6e5a:	77 66                	ja     18b6ec2 <tier0_tables_open+0x56c2>
 18b6e5c:	48 8b 84 24 88 01 00 00 	mov    0x188(%rsp),%rax
 18b6e64:	48 29 54 24 68       	sub    %rdx,0x68(%rsp)
 18b6e69:	48 c1 e2 06          	shl    $0x6,%rdx
 18b6e6d:	48 03 84 24 78 01 00 00 	add    0x178(%rsp),%rax
 18b6e75:	48 01 d0             	add    %rdx,%rax
 18b6e78:	c4 e2 79 59 05 7f 92 cc fe 	vpbroadcastq -0x1336d81(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18b6e81:	c5 f9 7f 80 00 ff ff ff 	vmovdqa %xmm0,-0x100(%rax)
 18b6e89:	c5 f9 7f 80 40 ff ff ff 	vmovdqa %xmm0,-0xc0(%rax)
 18b6e91:	c5 f9 7f 40 80       	vmovdqa %xmm0,-0x80(%rax)
 18b6e96:	c5 f9 7f 40 c0       	vmovdqa %xmm0,-0x40(%rax)
 18b6e9b:	c5 f9 7f 00          	vmovdqa %xmm0,(%rax)
 18b6e9f:	c5 f9 7f 40 40       	vmovdqa %xmm0,0x40(%rax)
 18b6ea4:	c5 f9 7f 80 80 00 00 00 	vmovdqa %xmm0,0x80(%rax)
 18b6eac:	c5 f9 7f 80 c0 00 00 00 	vmovdqa %xmm0,0xc0(%rax)
 18b6eb4:	48 05 00 02 00 00    	add    $0x200,%rax
 18b6eba:	48 83 44 24 68 f8    	addq   $0xfffffffffffffff8,0x68(%rsp)
 18b6ec0:	75 b6                	jne    18b6e78 <tier0_tables_open+0x5678>
 18b6ec2:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18b6eca:	0f 84 29 ec ff ff    	je     18b5af9 <tier0_tables_open+0x42f9>
 18b6ed0:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b6ed4:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18b6edc:	48 8b 01             	mov    (%rcx),%rax
 18b6edf:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18b6ee3:	0f b6 34 10          	movzbl (%rax,%rdx,1),%esi
 18b6ee7:	48 8b 0c d1          	mov    (%rcx,%rdx,8),%rcx
 18b6eeb:	40 80 fe 11          	cmp    $0x11,%sil
 18b6eef:	75 52                	jne    18b6f43 <tier0_tables_open+0x5743>
 18b6ef1:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
 18b6ef6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 18b6efb:	4c 8d 42 01          	lea    0x1(%rdx),%r8
 18b6eff:	48 89 f8             	mov    %rdi,%rax
 18b6f02:	48 c1 e8 3c          	shr    $0x3c,%rax
 18b6f06:	49 21 f8             	and    %rdi,%r8
 18b6f09:	c4 e2 78 f5 d1       	bzhi   %eax,%ecx,%edx
 18b6f0e:	ba 00 00 00 00       	mov    $0x0,%edx
 18b6f13:	0f 44 d0             	cmove  %eax,%edx
 18b6f16:	b8 37 05 00 00       	mov    $0x537,%eax
 18b6f1b:	c4 e2 f8 f7 c7       	bextr  %rax,%rdi,%rax
 18b6f20:	bf 10 00 00 00       	mov    $0x10,%edi
 18b6f25:	48 83 f8 10          	cmp    $0x10,%rax
 18b6f29:	48 0f 43 c7          	cmovae %rdi,%rax
 18b6f2d:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 18b6f34:	c4 e2 f9 f7 ff       	shlx   %rax,%rdi,%rdi
 18b6f39:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18b6f3e:	48 f7 d7             	not    %rdi
 18b6f41:	eb 5f                	jmp    18b6fa2 <tier0_tables_open+0x57a2>
 18b6f43:	48 b8 00 00 00 00 00 00 01 00 	movabs $0x1000000000000,%rax
 18b6f4d:	31 d2                	xor    %edx,%edx
 18b6f4f:	48 85 44 24 50       	test   %rax,0x50(%rsp)
 18b6f54:	75 23                	jne    18b6f79 <tier0_tables_open+0x5779>
 18b6f56:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18b6f5b:	48 c1 e8 20          	shr    $0x20,%rax
 18b6f5f:	83 c8 01             	or     $0x1,%eax
 18b6f62:	0f b7 c0             	movzwl %ax,%eax
 18b6f65:	f3 0f bd d0          	lzcnt  %eax,%edx
 18b6f69:	83 f2 1f             	xor    $0x1f,%edx
 18b6f6c:	c4 e2 68 f5 c1       	bzhi   %edx,%ecx,%eax
 18b6f71:	b8 00 00 00 00       	mov    $0x0,%eax
 18b6f76:	0f 45 d0             	cmovne %eax,%edx
 18b6f79:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
 18b6f7e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18b6f83:	48 b8 00 00 00 00 00 00 02 00 	movabs $0x2000000000000,%rax
 18b6f8d:	4d 89 d0             	mov    %r10,%r8
 18b6f90:	4c 89 cf             	mov    %r9,%rdi
 18b6f93:	49 21 c0             	and    %rax,%r8
 18b6f96:	48 c1 ef 30          	shr    $0x30,%rdi
 18b6f9a:	4c 89 d0             	mov    %r10,%rax
 18b6f9d:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
 18b6fa2:	45 31 c9             	xor    %r9d,%r9d
 18b6fa5:	4d 85 c0             	test   %r8,%r8
 18b6fa8:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 18b6fae:	49 bb 00 00 00 00 00 00 04 00 	movabs $0x4000000000000,%r11
 18b6fb8:	41 0f 95 c2          	setne  %r10b
 18b6fbc:	48 83 f9 10          	cmp    $0x10,%rcx
 18b6fc0:	49 0f 43 c8          	cmovae %r8,%rcx
 18b6fc4:	45 31 c0             	xor    %r8d,%r8d
 18b6fc7:	4c 85 d8             	test   %r11,%rax
 18b6fca:	41 0f 94 c3          	sete   %r11b
 18b6fce:	40 80 fe 08          	cmp    $0x8,%sil
 18b6fd2:	0f 84 d3 ea ff ff    	je     18b5aab <tier0_tables_open+0x42ab>
 18b6fd8:	45 88 d1             	mov    %r10b,%r9b
 18b6fdb:	45 88 d8             	mov    %r11b,%r8b
 18b6fde:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18b6fe3:	48 c1 e8 2d          	shr    $0x2d,%rax
 18b6fe7:	8b 74 24 50          	mov    0x50(%rsp),%esi
 18b6feb:	41 c1 e1 04          	shl    $0x4,%r9d
 18b6fef:	41 c1 e0 05          	shl    $0x5,%r8d
 18b6ff3:	c4 e2 71 f7 cd       	shlx   %ecx,%ebp,%ecx
 18b6ff8:	83 e0 40             	and    $0x40,%eax
 18b6ffb:	45 09 c8             	or     %r9d,%r8d
 18b6ffe:	09 cf                	or     %ecx,%edi
 18b7000:	b9 55 55 00 00       	mov    $0x5555,%ecx
 18b7005:	41 09 d0             	or     %edx,%r8d
 18b7008:	f7 d7                	not    %edi
 18b700a:	48 ba 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rdx
 18b7014:	44 09 c0             	or     %r8d,%eax
 18b7017:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18b701c:	c4 e2 42 f5 c9       	pext   %ecx,%edi,%ecx
 18b7021:	bf 11 11 11 11       	mov    $0x11111111,%edi
 18b7026:	c4 e2 73 f5 cf       	pdep   %edi,%ecx,%ecx
 18b702b:	49 21 d0             	and    %rdx,%r8
 18b702e:	49 09 f0             	or     %rsi,%r8
 18b7031:	49 09 c8             	or     %rcx,%r8
 18b7034:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
 18b7039:	e9 95 ea ff ff       	jmp    18b5ad3 <tier0_tables_open+0x42d3>
 18b703e:	48 83 bc 24 e8 00 00 00 00 	cmpq   $0x0,0xe8(%rsp)
 18b7047:	0f 84 62 e9 ff ff    	je     18b59af <tier0_tables_open+0x41af>
 18b704d:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18b7055:	0f 84 79 04 00 00    	je     18b74d4 <tier0_tables_open+0x5cd4>
 18b705b:	48 8b 04 24          	mov    (%rsp),%rax
 18b705f:	31 c9                	xor    %ecx,%ecx
 18b7061:	48 05 00 02 00 00    	add    $0x200,%rax
 18b7067:	62 f1 fd 48 6f 00    	vmovdqa64 (%rax),%zmm0
 18b706d:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18b7075:	48 05 c0 01 00 00    	add    $0x1c0,%rax
 18b707b:	eb 11                	jmp    18b708e <tier0_tables_open+0x588e>
 18b707d:	48 ff c1             	inc    %rcx
 18b7080:	48 3b 8c 24 50 01 00 00 	cmp    0x150(%rsp),%rcx
 18b7088:	0f 84 46 04 00 00    	je     18b74d4 <tier0_tables_open+0x5cd4>
 18b708e:	4c 8b 94 24 20 01 00 00 	mov    0x120(%rsp),%r10
 18b7096:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
 18b709a:	62 f2 fd 48 59 0d 5c 90 cc fe 	vpbroadcastq -0x1336fa4(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18b70a4:	49 c1 e1 04          	shl    $0x4,%r9
 18b70a8:	47 8b 04 0a          	mov    (%r10,%r9,1),%r8d
 18b70ac:	43 8b 7c 0a 04       	mov    0x4(%r10,%r9,1),%edi
 18b70b1:	43 8b 74 0a 08       	mov    0x8(%r10,%r9,1),%esi
 18b70b6:	43 8b 54 0a 0c       	mov    0xc(%r10,%r9,1),%edx
 18b70bb:	4f 8b 5c 0a 10       	mov    0x10(%r10,%r9,1),%r11
 18b70c0:	47 8b 7c 0a 18       	mov    0x18(%r10,%r9,1),%r15d
 18b70c5:	c4 81 f8 90 4c 0a 20 	kmovq  0x20(%r10,%r9,1),%k1
 18b70cc:	c4 81 f8 90 44 0a 28 	kmovq  0x28(%r10,%r9,1),%k0
 18b70d3:	4d 85 ff             	test   %r15,%r15
 18b70d6:	0f 84 e6 02 00 00    	je     18b73c2 <tier0_tables_open+0x5bc2>
 18b70dc:	45 89 f9             	mov    %r15d,%r9d
 18b70df:	49 c1 e3 06          	shl    $0x6,%r11
 18b70e3:	41 83 e1 07          	and    $0x7,%r9d
 18b70e7:	41 83 ff 08          	cmp    $0x8,%r15d
 18b70eb:	73 12                	jae    18b70ff <tier0_tables_open+0x58ff>
 18b70ed:	62 f2 fd 48 59 0d 09 90 cc fe 	vpbroadcastq -0x1336ff7(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18b70f7:	45 31 d2             	xor    %r10d,%r10d
 18b70fa:	e9 57 02 00 00       	jmp    18b7356 <tier0_tables_open+0x5b56>
 18b70ff:	62 f2 fd 48 59 0d f7 8f cc fe 	vpbroadcastq -0x1337009(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18b7109:	41 83 e7 f8          	and    $0xfffffff8,%r15d
 18b710d:	4e 8d 24 18          	lea    (%rax,%r11,1),%r12
 18b7111:	45 31 d2             	xor    %r10d,%r10d
 18b7114:	62 d1 fd 48 6f 5c 24 f9 	vmovdqa64 -0x1c0(%r12),%zmm3
 18b711c:	62 f2 7d 48 58 3d 92 93 cc fe 	vpbroadcastd -0x1336c6e(%rip),%zmm7        # 5804b8 <tier0_emit_x87.operations+0x70>
 18b7126:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18b712d:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b7134:	62 d1 fd 48 6f 64 24 fa 	vmovdqa64 -0x180(%r12),%zmm4
 18b713c:	62 d1 fd 48 6f 6c 24 fb 	vmovdqa64 -0x140(%r12),%zmm5
 18b7144:	62 d1 fd 48 6f 74 24 fc 	vmovdqa64 -0x100(%r12),%zmm6
 18b714c:	49 83 c2 08          	add    $0x8,%r10
 18b7150:	62 f3 65 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm3,%zmm2
 18b7157:	62 f1 65 48 71 d3 04 	vpsrlw $0x4,%zmm3,%zmm3
 18b715e:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18b7165:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18b716b:	62 f2 65 48 8d d0    	vpermb %zmm0,%zmm3,%zmm2
 18b7171:	62 f1 65 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm3
 18b7178:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18b717f:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b7185:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18b718c:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b7193:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18b719a:	62 f3 5d 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm2
 18b71a1:	62 f2 65 48 8d d8    	vpermb %zmm0,%zmm3,%zmm3
 18b71a7:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18b71ad:	62 f1 6d 48 71 f3 04 	vpsllw $0x4,%zmm3,%zmm2
 18b71b4:	62 f1 65 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm3
 18b71bb:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b71c1:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18b71c8:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b71cf:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18b71d6:	62 f3 55 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm2
 18b71dd:	62 d1 fd 48 6f 6c 24 fd 	vmovdqa64 -0xc0(%r12),%zmm5
 18b71e5:	62 f2 65 48 8d e0    	vpermb %zmm0,%zmm3,%zmm4
 18b71eb:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18b71f1:	62 f1 65 48 71 d6 04 	vpsrlw $0x4,%zmm6,%zmm3
 18b71f8:	62 f1 6d 48 71 f4 04 	vpsllw $0x4,%zmm4,%zmm2
 18b71ff:	62 d1 fd 48 6f 64 24 fe 	vmovdqa64 -0x80(%r12),%zmm4
 18b7207:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b720d:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18b7214:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b721b:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18b7222:	62 f3 4d 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm6,%zmm2
 18b7229:	62 f2 65 48 8d d8    	vpermb %zmm0,%zmm3,%zmm3
 18b722f:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18b7235:	62 f1 6d 48 71 f3 04 	vpsllw $0x4,%zmm3,%zmm2
 18b723c:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b7242:	62 f1 6d 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm2
 18b7249:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18b7250:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b7257:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18b725e:	62 f3 55 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm3
 18b7265:	62 d1 fd 48 6f 6c 24 ff 	vmovdqa64 -0x40(%r12),%zmm5
 18b726d:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18b7273:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18b7279:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18b7280:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b7286:	62 f1 6d 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm2
 18b728d:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18b7294:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b729b:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18b72a2:	62 f3 5d 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm3
 18b72a9:	62 d1 fd 48 6f 24 24 	vmovdqa64 (%r12),%zmm4
 18b72b0:	49 81 c4 00 02 00 00 	add    $0x200,%r12
 18b72b7:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18b72bd:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18b72c3:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18b72ca:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b72d0:	62 f1 6d 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm2
 18b72d7:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18b72de:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b72e5:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18b72ec:	62 f3 55 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm3
 18b72f3:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18b72f9:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18b72ff:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18b7306:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b730c:	62 f1 6d 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm2
 18b7313:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18b731a:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b7321:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18b7328:	62 f3 5d 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm3
 18b732f:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18b7335:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18b733b:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18b7342:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b7348:	4d 39 d7             	cmp    %r10,%r15
 18b734b:	0f 85 c3 fd ff ff    	jne    18b7114 <tier0_tables_open+0x5914>
 18b7351:	4d 85 c9             	test   %r9,%r9
 18b7354:	74 6c                	je     18b73c2 <tier0_tables_open+0x5bc2>
 18b7356:	49 c1 e2 06          	shl    $0x6,%r10
 18b735a:	4c 03 94 24 e8 00 00 00 	add    0xe8(%rsp),%r10
 18b7362:	41 c1 e1 06          	shl    $0x6,%r9d
 18b7366:	4d 01 da             	add    %r11,%r10
 18b7369:	45 31 db             	xor    %r11d,%r11d
 18b736c:	62 91 fd 48 6f 14 1a 	vmovdqa64 (%r10,%r11,1),%zmm2
 18b7373:	62 f2 7d 48 58 25 3b 91 cc fe 	vpbroadcastd -0x1336ec5(%rip),%zmm4        # 5804b8 <tier0_emit_x87.operations+0x70>
 18b737d:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18b7384:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18b738b:	49 83 c3 40          	add    $0x40,%r11
 18b738f:	62 f3 6d 48 25 dc e4 	vpternlogd $0xe4,%zmm4,%zmm2,%zmm3
 18b7396:	62 f1 6d 48 71 d2 04 	vpsrlw $0x4,%zmm2,%zmm2
 18b739d:	62 f3 75 48 25 d4 d8 	vpternlogd $0xd8,%zmm4,%zmm1,%zmm2
 18b73a4:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18b73aa:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18b73b0:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18b73b7:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18b73bd:	4d 39 d9             	cmp    %r11,%r9
 18b73c0:	75 aa                	jne    18b736c <tier0_tables_open+0x5b6c>
 18b73c2:	62 f2 7d 48 5a 25 f4 e8 cb fe 	vbroadcasti32x4 -0x134170c(%rip),%zmm4        # 575cc0 <x86_effects_unknown+0x260>
 18b73cc:	62 f1 f5 58 db 1d 32 8d cc fe 	vpandq -0x13372ce(%rip){1to8},%zmm1,%zmm3        # 580108 <x86_semantics_benchmark_code.registers+0x118>
 18b73d6:	62 f1 6d 48 71 d1 04 	vpsrlw $0x4,%zmm1,%zmm2
 18b73dd:	62 f3 65 48 3f 1d d8 92 c6 fe 04 	vpcmpneqb -0x1396d28(%rip),%zmm3,%k3        # 5206c0 <branch_sizing_patterns+0x930>
 18b73e8:	62 f1 ed 48 db d4    	vpandq %zmm4,%zmm2,%zmm2
 18b73ee:	62 f1 6d 48 74 15 88 92 c6 fe 	vpcmpeqb -0x1396d78(%rip),%zmm2,%k2        # 520680 <branch_sizing_patterns+0x8f0>
 18b73f8:	62 f1 65 48 74 e4    	vpcmpeqb %zmm4,%zmm3,%k4
 18b73fe:	62 f1 6d 4b 74 1d f8 92 c6 fe 	vpcmpeqb -0x1396d08(%rip),%zmm2,%k3{%k3}        # 520700 <branch_sizing_patterns+0x970>
 18b7408:	62 f1 6d 48 74 ec    	vpcmpeqb %zmm4,%zmm2,%k5
 18b740e:	62 f2 7d 48 5a 25 b8 e8 cb fe 	vbroadcasti32x4 -0x1341748(%rip),%zmm4        # 575cd0 <x86_effects_unknown+0x270>
 18b7418:	62 f1 65 58 eb 15 aa 90 cc fe 	vpord  -0x1336f56(%rip){1to16},%zmm3,%zmm2        # 5804cc <tier0_emit_x87.operations+0x84>
 18b7422:	c4 e1 dc 45 e5       	korq   %k5,%k4,%k4
 18b7427:	c4 e1 dc 45 db       	korq   %k3,%k4,%k3
 18b742c:	c4 e1 f4 45 cb       	korq   %k3,%k1,%k1
 18b7431:	62 f1 65 4a 74 dc    	vpcmpeqb %zmm4,%zmm3,%k3{%k2}
 18b7437:	62 f3 65 4a 3f d4 04 	vpcmpneqb %zmm4,%zmm3,%k2{%k2}
 18b743e:	c4 e1 f8 44 db       	knotq  %k3,%k3
 18b7443:	62 f1 7f 4a 6f ca    	vmovdqu8 %zmm2,%zmm1{%k2}
 18b7449:	c4 e1 fc 41 c3       	kandq  %k3,%k0,%k0
 18b744e:	c4 e1 f4 45 c8       	korq   %k0,%k1,%k1
 18b7453:	62 f1 7f 49 6f 0d 23 93 c6 fe 	vmovdqu8 -0x1396cdd(%rip),%zmm1{%k1}        # 520780 <branch_sizing_patterns+0x9f0>
 18b745d:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18b7461:	74 0d                	je     18b7470 <tier0_tables_open+0x5c70>
 18b7463:	4d 8b 0e             	mov    (%r14),%r9
 18b7466:	49 c1 e0 04          	shl    $0x4,%r8
 18b746a:	c4 81 7a 7f 0c 01    	vmovdqu %xmm1,(%r9,%r8,1)
 18b7470:	83 ff ff             	cmp    $0xffffffff,%edi
 18b7473:	74 0f                	je     18b7484 <tier0_tables_open+0x5c84>
 18b7475:	4d 8b 06             	mov    (%r14),%r8
 18b7478:	48 c1 e7 04          	shl    $0x4,%rdi
 18b747c:	62 d3 7d 48 39 0c 38 01 	vextracti32x4 $0x1,%zmm1,(%r8,%rdi,1)
 18b7484:	83 fe ff             	cmp    $0xffffffff,%esi
 18b7487:	74 0f                	je     18b7498 <tier0_tables_open+0x5c98>
 18b7489:	49 8b 3e             	mov    (%r14),%rdi
 18b748c:	48 c1 e6 04          	shl    $0x4,%rsi
 18b7490:	62 f3 7d 48 39 0c 37 02 	vextracti32x4 $0x2,%zmm1,(%rdi,%rsi,1)
 18b7498:	83 fa ff             	cmp    $0xffffffff,%edx
 18b749b:	0f 84 dc fb ff ff    	je     18b707d <tier0_tables_open+0x587d>
 18b74a1:	49 8b 36             	mov    (%r14),%rsi
 18b74a4:	48 c1 e2 04          	shl    $0x4,%rdx
 18b74a8:	62 f3 7d 48 39 0c 16 03 	vextracti32x4 $0x3,%zmm1,(%rsi,%rdx,1)
 18b74b0:	e9 c8 fb ff ff       	jmp    18b707d <tier0_tables_open+0x587d>
 18b74b5:	48 8b 34 24          	mov    (%rsp),%rsi
 18b74b9:	4c 89 f7             	mov    %r14,%rdi
 18b74bc:	c5 f8 77             	vzeroupper
 18b74bf:	e8 7c ec 00 00       	call   18c6140 <abi_finish>
 18b74c4:	48 83 44 24 78 0c    	addq   $0xc,0x78(%rsp)
 18b74ca:	48 ff 8c 24 98 00 00 00 	decq   0x98(%rsp)
 18b74d2:	74 2c                	je     18b7500 <tier0_tables_open+0x5d00>
 18b74d4:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18b74d9:	8b 10                	mov    (%rax),%edx
 18b74db:	80 78 0b 01          	cmpb   $0x1,0xb(%rax)
 18b74df:	75 d4                	jne    18b74b5 <tier0_tables_open+0x5cb5>
 18b74e1:	48 8b 34 24          	mov    (%rsp),%rsi
 18b74e5:	4c 89 f7             	mov    %r14,%rdi
 18b74e8:	c5 f8 77             	vzeroupper
 18b74eb:	e8 c0 f9 00 00       	call   18c6eb0 <abi_finish_passing>
 18b74f0:	48 83 44 24 78 0c    	addq   $0xc,0x78(%rsp)
 18b74f6:	48 ff 8c 24 98 00 00 00 	decq   0x98(%rsp)
 18b74fe:	75 d4                	jne    18b74d4 <tier0_tables_open+0x5cd4>
 18b7500:	b1 01                	mov    $0x1,%cl
 18b7502:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18b750b:	48 39 84 24 c0 00 00 00 	cmp    %rax,0xc0(%rsp)
 18b7513:	0f 87 99 00 00 00    	ja     18b75b2 <tier0_tables_open+0x5db2>
 18b7519:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18b7521:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18b752a:	84 c9                	test   %cl,%cl
 18b752c:	75 1e                	jne    18b754c <tier0_tables_open+0x5d4c>
 18b752e:	48 8b 34 24          	mov    (%rsp),%rsi
 18b7532:	48 8b 94 24 60 01 00 00 	mov    0x160(%rsp),%rdx
 18b753a:	8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%ecx
 18b7541:	4c 89 f7             	mov    %r14,%rdi
 18b7544:	c5 f8 77             	vzeroupper
 18b7547:	e8 64 13 01 00       	call   18c88b0 <abi_classify_scalar>
 18b754c:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18b7551:	74 0e                	je     18b7561 <tier0_tables_open+0x5d61>
 18b7553:	83 bc 24 a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsp)
 18b755b:	0f 85 c9 d5 ff ff    	jne    18b4b2a <tier0_tables_open+0x332a>
 18b7561:	48 8b 84 24 58 01 00 00 	mov    0x158(%rsp),%rax
 18b7569:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 18b7572:	77 3e                	ja     18b75b2 <tier0_tables_open+0x5db2>
 18b7574:	48 8b 84 24 58 01 00 00 	mov    0x158(%rsp),%rax
 18b757c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b7580:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18b7589:	8b b1 60 1f 00 00    	mov    0x1f60(%rcx),%esi
 18b758f:	48 85 f6             	test   %rsi,%rsi
 18b7592:	74 40                	je     18b75d4 <tier0_tables_open+0x5dd4>
 18b7594:	48 8b 04 24          	mov    (%rsp),%rax
 18b7598:	89 f2                	mov    %esi,%edx
 18b759a:	83 e2 03             	and    $0x3,%edx
 18b759d:	48 8b 88 b0 01 00 00 	mov    0x1b0(%rax),%rcx
 18b75a4:	83 fe 04             	cmp    $0x4,%esi
 18b75a7:	73 32                	jae    18b75db <tier0_tables_open+0x5ddb>
 18b75a9:	b0 01                	mov    $0x1,%al
 18b75ab:	31 ff                	xor    %edi,%edi
 18b75ad:	e9 8b 01 00 00       	jmp    18b773d <tier0_tables_open+0x5f3d>
 18b75b2:	48 8d 3d 3e 8a e1 fe 	lea    -0x11e75c2(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 18b75b9:	48 8d 35 d3 01 dd fe 	lea    -0x122fe2d(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 18b75c0:	48 8d 0d e7 01 dd fe 	lea    -0x122fe19(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 18b75c7:	ba bf 00 00 00       	mov    $0xbf,%edx
 18b75cc:	c5 f8 77             	vzeroupper
 18b75cf:	e8 7c c5 ea fe       	call   763b50 <__assert_fail@plt>
 18b75d4:	b0 01                	mov    $0x1,%al
 18b75d6:	e9 56 b7 ff ff       	jmp    18b2d31 <tier0_tables_open+0x1531>
 18b75db:	48 8b 04 24          	mov    (%rsp),%rax
 18b75df:	83 e6 fc             	and    $0xfffffffc,%esi
 18b75e2:	31 ff                	xor    %edi,%edi
 18b75e4:	4c 8d 80 28 04 00 00 	lea    0x428(%rax),%r8
 18b75eb:	b0 01                	mov    $0x1,%al
 18b75ed:	45 8b 88 a0 fe ff ff 	mov    -0x160(%r8),%r9d
 18b75f4:	45 89 ca             	mov    %r9d,%r10d
 18b75f7:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18b75fb:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18b75ff:	4d 89 90 a4 fe ff ff 	mov    %r10,-0x15c(%r8)
 18b7606:	3c 01                	cmp    $0x1,%al
 18b7608:	75 19                	jne    18b7623 <tier0_tables_open+0x5e23>
 18b760a:	48 8b 04 24          	mov    (%rsp),%rax
 18b760e:	41 c1 e9 03          	shr    $0x3,%r9d
 18b7612:	48 8b 80 88 01 00 00 	mov    0x188(%rax),%rax
 18b7619:	46 8b 0c 88          	mov    (%rax,%r9,4),%r9d
 18b761d:	66 45 85 c9          	test   %r9w,%r9w
 18b7621:	78 49                	js     18b766c <tier0_tables_open+0x5e6c>
 18b7623:	41 8b 80 14 ff ff ff 	mov    -0xec(%r8),%eax
 18b762a:	83 e0 f8             	and    $0xfffffff8,%eax
 18b762d:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18b7631:	49 89 80 18 ff ff ff 	mov    %rax,-0xe8(%r8)
 18b7638:	41 8b 40 88          	mov    -0x78(%r8),%eax
 18b763c:	83 e0 f8             	and    $0xfffffff8,%eax
 18b763f:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18b7643:	49 89 40 8c          	mov    %rax,-0x74(%r8)
 18b7647:	41 8b 40 fc          	mov    -0x4(%r8),%eax
 18b764b:	83 e0 f8             	and    $0xfffffff8,%eax
 18b764e:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18b7652:	49 89 00             	mov    %rax,(%r8)
 18b7655:	31 c0                	xor    %eax,%eax
 18b7657:	48 83 c7 04          	add    $0x4,%rdi
 18b765b:	49 81 c0 d0 01 00 00 	add    $0x1d0,%r8
 18b7662:	48 39 fe             	cmp    %rdi,%rsi
 18b7665:	75 86                	jne    18b75ed <tier0_tables_open+0x5ded>
 18b7667:	e9 c8 00 00 00       	jmp    18b7734 <tier0_tables_open+0x5f34>
 18b766c:	41 8b 80 14 ff ff ff 	mov    -0xec(%r8),%eax
 18b7673:	41 89 c2             	mov    %eax,%r10d
 18b7676:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18b767a:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18b767e:	4d 89 90 18 ff ff ff 	mov    %r10,-0xe8(%r8)
 18b7685:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18b768c:	75 aa                	jne    18b7638 <tier0_tables_open+0x5e38>
 18b768e:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b7692:	c1 e8 03             	shr    $0x3,%eax
 18b7695:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18b769c:	45 8b 0c 81          	mov    (%r9,%rax,4),%r9d
 18b76a0:	66 45 85 c9          	test   %r9w,%r9w
 18b76a4:	79 92                	jns    18b7638 <tier0_tables_open+0x5e38>
 18b76a6:	41 8b 40 88          	mov    -0x78(%r8),%eax
 18b76aa:	41 89 c2             	mov    %eax,%r10d
 18b76ad:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18b76b1:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18b76b5:	4d 89 50 8c          	mov    %r10,-0x74(%r8)
 18b76b9:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18b76c0:	75 85                	jne    18b7647 <tier0_tables_open+0x5e47>
 18b76c2:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b76c6:	c1 e8 03             	shr    $0x3,%eax
 18b76c9:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18b76d0:	45 8b 0c 81          	mov    (%r9,%rax,4),%r9d
 18b76d4:	66 45 85 c9          	test   %r9w,%r9w
 18b76d8:	0f 89 69 ff ff ff    	jns    18b7647 <tier0_tables_open+0x5e47>
 18b76de:	41 8b 40 fc          	mov    -0x4(%r8),%eax
 18b76e2:	41 89 c2             	mov    %eax,%r10d
 18b76e5:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18b76e9:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18b76ed:	4d 89 10             	mov    %r10,(%r8)
 18b76f0:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18b76f7:	0f 85 58 ff ff ff    	jne    18b7655 <tier0_tables_open+0x5e55>
 18b76fd:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b7701:	c1 e8 03             	shr    $0x3,%eax
 18b7704:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18b770b:	41 8b 04 81          	mov    (%r9,%rax,4),%eax
 18b770f:	66 85 c0             	test   %ax,%ax
 18b7712:	0f 89 3d ff ff ff    	jns    18b7655 <tier0_tables_open+0x5e55>
 18b7718:	a9 00 40 00 00       	test   $0x4000,%eax
 18b771d:	0f 94 c0             	sete   %al
 18b7720:	48 83 c7 04          	add    $0x4,%rdi
 18b7724:	49 81 c0 d0 01 00 00 	add    $0x1d0,%r8
 18b772b:	48 39 fe             	cmp    %rdi,%rsi
 18b772e:	0f 85 b9 fe ff ff    	jne    18b75ed <tier0_tables_open+0x5ded>
 18b7734:	48 85 d2             	test   %rdx,%rdx
 18b7737:	0f 84 f4 b5 ff ff    	je     18b2d31 <tier0_tables_open+0x1531>
 18b773d:	48 6b f7 74          	imul   $0x74,%rdi,%rsi
 18b7741:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b7745:	48 6b d2 74          	imul   $0x74,%rdx,%rdx
 18b7749:	48 8d b4 3e cc 02 00 00 	lea    0x2cc(%rsi,%rdi,1),%rsi
 18b7751:	31 ff                	xor    %edi,%edi
 18b7753:	eb 0f                	jmp    18b7764 <tier0_tables_open+0x5f64>
 18b7755:	31 c0                	xor    %eax,%eax
 18b7757:	48 83 c7 74          	add    $0x74,%rdi
 18b775b:	48 39 fa             	cmp    %rdi,%rdx
 18b775e:	0f 84 cd b5 ff ff    	je     18b2d31 <tier0_tables_open+0x1531>
 18b7764:	44 8b 44 3e fc       	mov    -0x4(%rsi,%rdi,1),%r8d
 18b7769:	45 89 c1             	mov    %r8d,%r9d
 18b776c:	41 83 e1 f8          	and    $0xfffffff8,%r9d
 18b7770:	4e 8b 0c 09          	mov    (%rcx,%r9,1),%r9
 18b7774:	4c 89 0c 3e          	mov    %r9,(%rsi,%rdi,1)
 18b7778:	3c 01                	cmp    $0x1,%al
 18b777a:	75 d9                	jne    18b7755 <tier0_tables_open+0x5f55>
 18b777c:	48 8b 04 24          	mov    (%rsp),%rax
 18b7780:	41 c1 e8 03          	shr    $0x3,%r8d
 18b7784:	48 8b 80 88 01 00 00 	mov    0x188(%rax),%rax
 18b778b:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
 18b778f:	66 85 c0             	test   %ax,%ax
 18b7792:	79 c1                	jns    18b7755 <tier0_tables_open+0x5f55>
 18b7794:	a9 00 40 00 00       	test   $0x4000,%eax
 18b7799:	0f 94 c0             	sete   %al
 18b779c:	48 83 c7 74          	add    $0x74,%rdi
 18b77a0:	48 39 fa             	cmp    %rdi,%rdx
 18b77a3:	75 bf                	jne    18b7764 <tier0_tables_open+0x5f64>
 18b77a5:	e9 87 b5 ff ff       	jmp    18b2d31 <tier0_tables_open+0x1531>
