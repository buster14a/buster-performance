
../campaign/native-images/base/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000010826a0 <check_input_resolve_range>:
 10826a0:	push   %rbp
 10826a1:	push   %r15
 10826a3:	push   %r14
 10826a5:	push   %r13
 10826a7:	push   %r12
 10826a9:	push   %rbx
 10826aa:	sub    $0x238,%rsp
 10826b1:	mov    %fs:0x28,%rax
 10826ba:	mov    %rax,0x230(%rsp)
 10826c2:	mov    %edx,0xbc(%rsp)
 10826c9:	mov    %esi,0xb8(%rsp)
 10826d0:	cmp    %edx,%esi
 10826d2:	jbe    1082700 <check_input_resolve_range+0x60>
 10826d4:	mov    %fs:0x28,%rax
 10826dd:	cmp    0x230(%rsp),%rax
 10826e5:	jne    1088ad2 <check_input_resolve_range+0x6432>
 10826eb:	add    $0x238,%rsp
 10826f2:	pop    %rbx
 10826f3:	pop    %r12
 10826f5:	pop    %r13
 10826f7:	pop    %r14
 10826f9:	pop    %r15
 10826fb:	pop    %rbp
 10826fc:	vzeroupper
 10826ff:	ret
 1082700:	vpbroadcastq -0xad633a(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108270a:	vpbroadcastd -0xad6b33(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082713:	vpbroadcastq -0xad633d(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 108271d:	vpbroadcastd -0xad6b47(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082727:	vpbroadcastq -0xad6359(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1082731:	lea    0x40(%rdi),%rax
 1082735:	mov    0x8(%rdi),%r12
 1082739:	mov    %rdi,%rbx
 108273c:	mov    %rdi,0x8(%rsp)
 1082741:	mov    %rax,0x118(%rsp)
 1082749:	mov    0xb8(%rsp),%eax
 1082750:	mov    %r12,0x48(%rsp)
 1082755:	mov    %eax,%r13d
 1082758:	jmp    1082796 <check_input_resolve_range+0xf6>
 108275a:	movb   $0x1,0x3bd(%rax)
 1082761:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082770:	mov    0x138(%rbx),%rax
 1082777:	cmpb   $0x0,(%rax,%rbp,1)
 108277b:	je     1082c6a <check_input_resolve_range+0x5ca>
 1082781:	mov    (%rsp),%r13
 1082785:	inc    %r13d
 1082788:	cmp    0xbc(%rsp),%r13d
 1082790:	ja     10826d4 <check_input_resolve_range+0x34>
 1082796:	mov    (%rbx),%rax
 1082799:	cmpl   $0x0,0x230(%rax)
 10827a0:	jne    10826d4 <check_input_resolve_range+0x34>
 10827a6:	cmpb   $0x0,0x3bd(%rax)
 10827ad:	jne    10826d4 <check_input_resolve_range+0x34>
 10827b3:	cmp    0x3c0(%rbx),%r13d
 10827ba:	je     1088983 <check_input_resolve_range+0x62e3>
 10827c0:	mov    %r13d,0x42c(%rbx)
 10827c7:	mov    0x18(%rbx),%rax
 10827cb:	mov    0x108(%rax),%rax
 10827d2:	test   %rax,%rax
 10827d5:	je     10827e8 <check_input_resolve_range+0x148>
 10827d7:	cmp    %r13d,0x30(%rax)
 10827db:	je     10827e8 <check_input_resolve_range+0x148>
 10827dd:	mov    %r13d,0x30(%rax)
 10827e1:	movl   $0x0,0x34(%rax)
 10827e8:	cmpb   $0x1,0x458(%rbx)
 10827ef:	mov    %r13d,%eax
 10827f2:	mov    %rax,0x28(%rsp)
 10827f7:	mov    %r13,(%rsp)
 10827fb:	jne    1082819 <check_input_resolve_range+0x179>
 10827fd:	cmp    0xb8(%rsp),%r13d
 1082805:	je     1082d40 <check_input_resolve_range+0x6a0>
 108280b:	cmp    0xbc(%rsp),%r13d
 1082813:	je     1082d40 <check_input_resolve_range+0x6a0>
 1082819:	mov    0x158(%rbx),%rax
 1082820:	mov    0x28(%rsp),%rcx
 1082825:	mov    (%rax,%rcx,4),%eax
 1082828:	cmp    $0xffffffff,%eax
 108282b:	jne    1082858 <check_input_resolve_range+0x1b8>
 108282d:	jmp    1082d40 <check_input_resolve_range+0x6a0>
 1082832:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082840:	mov    0x160(%rbx),%rax
 1082847:	mov    (%rsp),%r13
 108284b:	mov    (%rax,%r15,4),%eax
 108284f:	cmp    $0xffffffff,%eax
 1082852:	je     1082d40 <check_input_resolve_range+0x6a0>
 1082858:	mov    (%rbx),%rcx
 108285b:	mov    %eax,%r15d
 108285e:	mov    0x2b0(%rcx),%rdx
 1082865:	mov    0x280(%rcx),%rsi
 108286c:	mov    0x2b8(%rcx),%rcx
 1082873:	mov    (%rdx,%r15,4),%edx
 1082877:	cmpb   $0x0,(%rsi,%r15,1)
 108287c:	mov    (%rcx,%r15,4),%ecx
 1082880:	lea    -0x1(%rdx),%ebp
 1082883:	cmovne %eax,%ebp
 1082886:	cmp    %ecx,%edx
 1082888:	jae    1082cf0 <check_input_resolve_range+0x650>
 108288e:	mov    0x8(%rbx),%r12
 1082892:	cmp    0x30(%r12),%ecx
 1082897:	ja     1082cf0 <check_input_resolve_range+0x650>
 108289d:	mov    0xa0(%rbx),%rax
 10828a4:	mov    0x18(%rbx),%rdi
 10828a8:	mov    (%rax,%r15,4),%r11d
 10828ac:	mov    (%rdi),%rax
 10828af:	mov    %r11d,%r13d
 10828b2:	shr    $0x3,%r13d
 10828b6:	cmpb   $0x9,(%rax,%r13,1)
 10828bb:	jne    1082840 <check_input_resolve_range+0x1a0>
 10828bd:	mov    0x50(%r12),%rsi
 10828c2:	mov    0x20(%rdi),%rdi
 10828c6:	movzbl (%rsi,%rdx,1),%esi
 10828ca:	mov    (%rdi,%r13,4),%r14d
 10828ce:	add    $0xc9,%sil
 10828d2:	mov    %r14d,%r8d
 10828d5:	cmp    $0x2,%sil
 10828d9:	mov    %rdx,%rsi
 10828dc:	adc    $0x0,%rsi
 10828e0:	shr    $0x3,%r8d
 10828e4:	cmpb   $0xf,(%rax,%r8,1)
 10828e9:	jne    10828ef <check_input_resolve_range+0x24f>
 10828eb:	mov    (%rdi,%r8,4),%r14d
 10828ef:	cmp    %ecx,%esi
 10828f1:	jae    1082aa0 <check_input_resolve_range+0x400>
 10828f7:	mov    0x10(%r12),%rax
 10828fc:	cmpb   $0x5,(%rax,%rsi,1)
 1082900:	jne    1082aa0 <check_input_resolve_range+0x400>
 1082906:	mov    %rbx,%rdi
 1082909:	mov    %rdx,0x30(%rsp)
 108290e:	mov    %ecx,%ebx
 1082910:	mov    %r11,0x60(%rsp)
 1082915:	vzeroupper
 1082918:	call   10a1210 <check_input_string>
 108291d:	vpbroadcastq -0xad654f(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1082927:	vpbroadcastd -0xad6d51(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082931:	vpbroadcastq -0xad655b(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 108293b:	vpbroadcastd -0xad6d64(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082944:	vpbroadcastq -0xad657e(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108294e:	mov    %ebx,%ecx
 1082950:	mov    0x60(%rsp),%r11
 1082955:	mov    0x8(%rsp),%rbx
 108295a:	mov    0x30(%rsp),%rdx
 108295f:	test   %rax,%rax
 1082962:	je     1082aa0 <check_input_resolve_range+0x400>
 1082968:	mov    0x18(%rbx),%rdi
 108296c:	mov    0x8(%rax),%r9d
 1082970:	and    $0xfffffff8,%r14d
 1082974:	mov    (%rdi),%rsi
 1082977:	mov    %r9d,%r10d
 108297a:	shr    $0x3,%r10d
 108297e:	mov    0x20(%rdi),%r8
 1082982:	and    $0x7,%r9d
 1082986:	movzbl (%rsi,%r10,1),%esi
 108298b:	add    $0xf8,%sil
 108298f:	cmp    $0x3,%sil
 1082993:	mov    $0x0,%esi
 1082998:	cmovae %esi,%r9d
 108299c:	or     (%r8,%r10,4),%r9d
 10829a0:	cmp    $0x29,%r14d
 10829a4:	setae  %sil
 10829a8:	cmp    $0x18,%r9d
 10829ac:	setne  %r8b
 10829b0:	cmp    %r9d,%r14d
 10829b3:	je     10829d4 <check_input_resolve_range+0x334>
 10829b5:	movabs $0xfefeffffff,%r9
 10829bf:	shrx   %r14,%r9,%r9
 10829c4:	or     %r9b,%sil
 10829c7:	or     %r8b,%sil
 10829ca:	test   $0x1,%sil
 10829ce:	jne    1082aa4 <check_input_resolve_range+0x404>
 10829d4:	mov    (%rdi),%rcx
 10829d7:	mov    0x20(%rdi),%rdx
 10829db:	movzbl (%rcx,%r13,1),%esi
 10829e0:	mov    (%rdx,%r13,4),%ebx
 10829e4:	mov    $0x0,%edx
 10829e9:	add    $0xf8,%sil
 10829ed:	cmp    $0x3,%sil
 10829f1:	cmovae %edx,%r11d
 10829f5:	mov    %ebx,%edx
 10829f7:	shr    $0x3,%edx
 10829fa:	je     1083a56 <check_input_resolve_range+0x13b6>
 1082a00:	cmp    0x48(%rdi),%edx
 1082a03:	jae    1083a56 <check_input_resolve_range+0x13b6>
 1082a09:	cmpb   $0x0,(%rcx,%rdx,1)
 1082a0d:	je     1083a56 <check_input_resolve_range+0x13b6>
 1082a13:	mov    0x8(%rax),%eax
 1082a16:	mov    0x30(%rdi),%rcx
 1082a1a:	mov    $0x8,%esi
 1082a1f:	mov    %r11,%r14
 1082a22:	xor    %edx,%edx
 1082a24:	xor    %r9d,%r9d
 1082a27:	and    $0xfffffff8,%eax
 1082a2a:	mov    (%rcx,%rax,1),%r8
 1082a2e:	mov    %ebx,%ecx
 1082a30:	and    $0xfffffff8,%ecx
 1082a33:	vzeroupper
 1082a36:	call   10a1a00 <type_find_or_add>
 1082a3b:	vpbroadcastq -0xad666d(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1082a45:	vpbroadcastd -0xad6e6f(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082a4f:	vpbroadcastq -0xad6679(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1082a59:	vpbroadcastd -0xad6e82(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082a62:	vpbroadcastq -0xad669c(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1082a6c:	mov    0x8(%rsp),%r8
 1082a71:	test   %eax,%eax
 1082a73:	je     1083a87 <check_input_resolve_range+0x13e7>
 1082a79:	or     %ebx,%r14d
 1082a7c:	and    $0x7,%r14d
 1082a80:	lea    (%r14,%rax,8),%ecx
 1082a84:	test   %ecx,%ecx
 1082a86:	jne    1082c26 <check_input_resolve_range+0x586>
 1082a8c:	jmp    1083a87 <check_input_resolve_range+0x13e7>
 1082a91:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082aa0:	mov    0x18(%rbx),%rdi
 1082aa4:	vmovdqu 0x180(%rbx),%xmm0
 1082aac:	mov    0x28(%rbx),%r14
 1082ab0:	mov    0xa0(%rbx),%rax
 1082ab7:	vpxor  %xmm1,%xmm1,%xmm1
 1082abb:	vmovdqu %ymm1,0x200(%rsp)
 1082ac4:	vmovdqu %ymm1,0x210(%rsp)
 1082acd:	mov    %r11d,0x200(%rsp)
 1082ad5:	movl   $0xffffffff,0x220(%rsp)
 1082ae0:	test   %r14,%r14
 1082ae3:	je     1082c95 <check_input_resolve_range+0x5f5>
 1082ae9:	mov    0x8(%r14),%rbx
 1082aed:	test   %r13d,%r13d
 1082af0:	je     1082c91 <check_input_resolve_range+0x5f1>
 1082af6:	test   %rdi,%rdi
 1082af9:	je     1082c91 <check_input_resolve_range+0x5f1>
 1082aff:	cmp    0x48(%rdi),%r13d
 1082b03:	jae    1082c91 <check_input_resolve_range+0x5f1>
 1082b09:	mov    (%rdi),%rsi
 1082b0c:	cmpb   $0x0,(%rsi,%r13,1)
 1082b11:	je     1082c91 <check_input_resolve_range+0x5f1>
 1082b17:	xor    %esi,%esi
 1082b19:	cmp    0x30(%r12),%ecx
 1082b1e:	seta   %sil
 1082b22:	mov    %esi,0x21c(%rsp)
 1082b29:	ja     1082c91 <check_input_resolve_range+0x5f1>
 1082b2f:	lea    0x140(%rsp),%rsi
 1082b37:	mov    %rdi,0x130(%rsp)
 1082b3f:	mov    %r12,0x138(%rsp)
 1082b47:	vpxor  %xmm1,%xmm1,%xmm1
 1082b4b:	lea    0x130(%rsp),%rdi
 1082b53:	vmovdqu64 %zmm1,(%rsi)
 1082b59:	vmovdqu %xmm0,0x180(%rsp)
 1082b62:	mov    %rax,0x190(%rsp)
 1082b6a:	lea    0x200(%rsp),%rax
 1082b72:	vmovdqu64 %zmm1,0x58(%rsi)
 1082b7c:	movq   $0x0,0x98(%rsi)
 1082b87:	movq   $0x1000001,0x1e0(%rsp)
 1082b93:	movq   $0x0,0x1e8(%rsp)
 1082b9f:	mov    %r14,0x1f0(%rsp)
 1082ba7:	mov    %r11d,%esi
 1082baa:	mov    %rax,0x1f8(%rsp)
 1082bb2:	vzeroupper
 1082bb5:	call   10a2fb0 <check_init_walk>
 1082bba:	cmp    0x8(%r14),%rbx
 1082bbe:	ja     1088ab0 <check_input_resolve_range+0x6410>
 1082bc4:	mov    0x8(%rsp),%r8
 1082bc9:	mov    %rbx,0x8(%r14)
 1082bcd:	vpbroadcastq -0xad6807(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1082bd7:	vpbroadcastd -0xad7000(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082be0:	vpbroadcastq -0xad680a(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1082bea:	vpbroadcastd -0xad7014(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082bf4:	vpbroadcastq -0xad6826(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1082bfe:	cmpl   $0x5,0x21c(%rsp)
 1082c06:	mov    0x200(%rsp),%ecx
 1082c0d:	mov    0x220(%rsp),%edx
 1082c14:	mov    (%r8),%rdi
 1082c17:	sete   %sil
 1082c1b:	or     %sil,0x3bd(%rdi)
 1082c22:	test   %al,%al
 1082c24:	je     1082c9f <check_input_resolve_range+0x5ff>
 1082c26:	mov    0xa0(%r8),%rax
 1082c2d:	mov    %ebp,%edx
 1082c2f:	mov    %r8,%rbx
 1082c32:	mov    %ecx,(%rax,%r15,4)
 1082c36:	mov    0xa8(%r8),%rax
 1082c3d:	mov    %ecx,(%rax,%rdx,4)
 1082c40:	mov    0x128(%r8),%rax
 1082c47:	cmpb   $0x0,(%rax,%r15,1)
 1082c4c:	je     1082840 <check_input_resolve_range+0x1a0>
 1082c52:	mov    0x18(%r12),%rax
 1082c57:	mov    0x328(%rbx),%rdx
 1082c5e:	mov    (%rax,%r15,4),%eax
 1082c62:	mov    %ecx,(%rdx,%rax,4)
 1082c65:	jmp    1082840 <check_input_resolve_range+0x1a0>
 1082c6a:	cmpl   $0x5,0x3c(%rsp)
 1082c6f:	mov    0x48(%rsp),%r12
 1082c74:	mov    (%rsp),%r13
 1082c78:	jne    108323d <check_input_resolve_range+0xb9d>
 1082c7e:	mov    %rbx,%rdi
 1082c81:	mov    %r13d,%esi
 1082c84:	vzeroupper
 1082c87:	call   10a1210 <check_input_string>
 1082c8c:	jmp    1083258 <check_input_resolve_range+0xbb8>
 1082c91:	mov    %rbx,0x8(%r14)
 1082c95:	mov    0x8(%rsp),%r8
 1082c9a:	mov    $0xffffffff,%edx
 1082c9f:	mov    (%r8),%rax
 1082ca2:	mov    %r8,%rbx
 1082ca5:	mov    0x230(%rax),%ecx
 1082cab:	cmp    0x234(%rax),%ecx
 1082cb1:	jae    1082ce5 <check_input_resolve_range+0x645>
 1082cb3:	movzbl 0x3bd(%rax),%esi
 1082cba:	mov    0x228(%rax),%rdi
 1082cc1:	lea    0x1(%rcx),%r8d
 1082cc5:	mov    %r8d,0x230(%rax)
 1082ccc:	lea    (%rcx,%rcx,2),%rax
 1082cd0:	lea    0x1(%rsi,%rsi,2),%esi
 1082cd4:	mov    %edx,(%rdi,%rax,4)
 1082cd7:	mov    %esi,0x4(%rdi,%rax,4)
 1082cdb:	movl   $0x0,0x8(%rdi,%rax,4)
 1082ce3:	jmp    1082cec <check_input_resolve_range+0x64c>
 1082ce5:	movb   $0x1,0x3bd(%rax)
 1082cec:	mov    (%rsp),%r13
 1082cf0:	mov    (%rbx),%rax
 1082cf3:	cmpl   $0x0,0x230(%rax)
 1082cfa:	jne    1082d40 <check_input_resolve_range+0x6a0>
 1082cfc:	cmpl   $0x0,0x234(%rax)
 1082d03:	je     108328e <check_input_resolve_range+0xbee>
 1082d09:	movzbl 0x3bd(%rax),%ecx
 1082d10:	mov    0x228(%rax),%rdx
 1082d17:	movl   $0x1,0x230(%rax)
 1082d21:	lea    0x1(%rcx,%rcx,2),%ecx
 1082d25:	mov    %ebp,(%rdx)
 1082d27:	mov    %ecx,0x4(%rdx)
 1082d2a:	movl   $0x0,0x8(%rdx)
 1082d31:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082d40:	mov    (%rbx),%rax
 1082d43:	mov    0x48(%rsp),%r12
 1082d48:	cmpl   $0x0,0x230(%rax)
 1082d4f:	jne    10826d4 <check_input_resolve_range+0x34>
 1082d55:	cmpb   $0x0,0x3bd(%rax)
 1082d5c:	jne    10826d4 <check_input_resolve_range+0x34>
 1082d62:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082d70:	mov    0x3b0(%rbx),%ecx
 1082d76:	test   %ecx,%ecx
 1082d78:	je     1082eb0 <check_input_resolve_range+0x810>
 1082d7e:	mov    0x3a0(%rbx),%rax
 1082d85:	dec    %ecx
 1082d87:	cmp    %r13d,(%rax,%rcx,4)
 1082d8b:	jae    1082eb0 <check_input_resolve_range+0x810>
 1082d91:	mov    %ecx,0x3b0(%rbx)
 1082d97:	mov    $0x1,%dl
 1082d99:	mov    0x40(%rbx),%eax
 1082d9c:	cmp    0x9c(%rbx),%eax
 1082da2:	je     1082db2 <check_input_resolve_range+0x712>
 1082da4:	mov    0x68(%rbx),%rdx
 1082da8:	lea    -0x1(%rax),%esi
 1082dab:	cmp    (%rdx,%rsi,4),%r13d
 1082daf:	setae  %dl
 1082db2:	cmpb   $0x1,0x98(%rbx)
 1082db9:	jne    1082dca <check_input_resolve_range+0x72a>
 1082dbb:	mov    0x398(%rbx),%rsi
 1082dc2:	mov    (%rsi,%rcx,4),%ecx
 1082dc5:	cmp    0x50(%rbx),%ecx
 1082dc8:	jbe    1082df0 <check_input_resolve_range+0x750>
 1082dca:	movb   $0x0,0x98(%rbx)
 1082dd1:	cmpb   $0x0,0x98(%rbx)
 1082dd8:	jne    1082d70 <check_input_resolve_range+0x6d0>
 1082dda:	mov    (%rbx),%rax
 1082ddd:	movb   $0x1,0x3bd(%rax)
 1082de4:	jmp    1082d70 <check_input_resolve_range+0x6d0>
 1082de6:	cs nopw 0x0(%rax,%rax,1)
 1082df0:	cmp    0x3c(%rbx),%eax
 1082df3:	setb   %sil
 1082df7:	and    %dl,%sil
 1082dfa:	mov    %sil,0x98(%rbx)
 1082e01:	cmp    $0x1,%sil
 1082e05:	jne    1082dd1 <check_input_resolve_range+0x731>
 1082e07:	lea    0x1(%rax),%edx
 1082e0a:	mov    %edx,0x40(%rbx)
 1082e0d:	mov    0x88(%rbx),%rdx
 1082e14:	movb   $0x2,(%rdx,%rax,1)
 1082e18:	mov    0x60(%rbx),%rdx
 1082e1c:	mov    %ecx,(%rdx,%rax,4)
 1082e1f:	mov    0x68(%rbx),%rdx
 1082e23:	mov    %r13d,(%rdx,%rax,4)
 1082e27:	mov    0x58(%rbx),%rdx
 1082e2b:	movl   $0x0,(%rdx,%rax,4)
 1082e32:	mov    0x70(%rbx),%rdx
 1082e36:	movl   $0xffffffff,(%rdx,%rax,4)
 1082e3d:	mov    0x78(%rbx),%rdx
 1082e41:	movl   $0x0,(%rdx,%rax,4)
 1082e48:	mov    0x80(%rbx),%rdx
 1082e4f:	movl   $0x0,(%rdx,%rax,4)
 1082e56:	mov    0x90(%rbx),%rdx
 1082e5d:	movb   $0x0,(%rdx,%rax,1)
 1082e61:	mov    0x50(%rbx),%edx
 1082e64:	cmp    %ecx,%edx
 1082e66:	jbe    1082dd1 <check_input_resolve_range+0x731>
 1082e6c:	nopl   0x0(%rax)
 1082e70:	dec    %edx
 1082e72:	mov    %edx,0x50(%rbx)
 1082e75:	mov    0x48(%rbx),%rsi
 1082e79:	mov    0x70(%rbx),%rdi
 1082e7d:	mov    (%rsi,%rdx,4),%edx
 1082e80:	mov    %eax,(%rdi,%rdx,4)
 1082e83:	mov    0x78(%rbx),%rsi
 1082e87:	mov    0x58(%rbx),%r8
 1082e8b:	mov    0x30(%rbx),%rdi
 1082e8f:	mov    (%rsi,%rdx,4),%esi
 1082e92:	mov    (%r8,%rdx,4),%edx
 1082e96:	mov    %esi,(%rdi,%rdx,4)
 1082e99:	mov    0x50(%rbx),%edx
 1082e9c:	cmp    %ecx,%edx
 1082e9e:	ja     1082e70 <check_input_resolve_range+0x7d0>
 1082ea0:	jmp    1082dd1 <check_input_resolve_range+0x731>
 1082ea5:	data16 cs nopw 0x0(%rax,%rax,1)
 1082eb0:	cmp    0x3b8(%rbx),%r13d
 1082eb7:	jbe    1082ecd <check_input_resolve_range+0x82d>
 1082eb9:	movl   $0x0,0x3b4(%rbx)
 1082ec3:	movl   $0xffffffff,0x3bc(%rbx)
 1082ecd:	cmp    0xbc(%rsp),%r13d
 1082ed5:	je     10826d4 <check_input_resolve_range+0x34>
 1082edb:	mov    (%rbx),%rax
 1082ede:	mov    0x28(%rsp),%rbp
 1082ee3:	mov    0x1f0(%rax),%rax
 1082eea:	test   %rax,%rax
 1082eed:	je     1083040 <check_input_resolve_range+0x9a0>
 1082ef3:	cmpb   $0x0,(%rax,%rbp,1)
 1082ef7:	je     1083040 <check_input_resolve_range+0x9a0>
 1082efd:	mov    0x2d0(%rbx),%rax
 1082f04:	mov    (%rax,%rbp,4),%ebp
 1082f07:	cmp    $0xffffffff,%ebp
 1082f0a:	je     1082f31 <check_input_resolve_range+0x891>
 1082f0c:	nopl   0x0(%rax)
 1082f10:	mov    %rbx,%rdi
 1082f13:	mov    %ebp,%esi
 1082f15:	mov    %r13d,%edx
 1082f18:	vzeroupper
 1082f1b:	call   1090540 <check_input_bind>
 1082f20:	mov    0x2d8(%rbx),%rax
 1082f27:	mov    %ebp,%ecx
 1082f29:	mov    (%rax,%rcx,4),%ebp
 1082f2c:	cmp    $0xffffffff,%ebp
 1082f2f:	jne    1082f10 <check_input_resolve_range+0x870>
 1082f31:	vpbroadcastq -0xad6b6b(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1082f3b:	vpbroadcastd -0xad7364(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082f44:	vpbroadcastq -0xad6b6e(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1082f4e:	vpbroadcastd -0xad7378(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1082f58:	vpbroadcastq -0xad6b8a(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1082f62:	mov    0x448(%rbx),%rax
 1082f69:	mov    0x28(%rsp),%r14
 1082f6e:	test   %rax,%rax
 1082f71:	je     108322f <check_input_resolve_range+0xb8f>
 1082f77:	mov    0x1e0(%rax),%ecx
 1082f7d:	cmp    0x1e4(%rax),%ecx
 1082f83:	jae    108321a <check_input_resolve_range+0xb7a>
 1082f89:	mov    $0x11,%r11b
 1082f8c:	mov    (%rbx),%rsi
 1082f8f:	vpmovsxbd -0xad73b4(%rip),%xmm2        # 5abbe4 <link_program_emit_worker.forms+0x3d4>
 1082f98:	mov    0x18(%rbx),%r8
 1082f9c:	mov    0x8(%rbx),%rdi
 1082fa0:	vmovdqa -0xb06828(%rip),%ymm3        # 57c780 <static_test_starved.starved+0xd60>
 1082fa8:	mov    0x1d0(%rax),%rdx
 1082faf:	mov    0x240(%rbx),%r9d
 1082fb6:	mov    0x1c8(%rbx),%r10d
 1082fbd:	lea    (%rcx,%rcx,2),%rcx
 1082fc1:	kmovd  %r11d,%k1
 1082fc6:	mov    0x118(%rsp),%r11
 1082fce:	shl    $0x4,%rcx
 1082fd2:	mov    0x60(%rdi),%rdi
 1082fd6:	vmovdqu32 (%r11),%ymm0{%k1}{z}
 1082fdc:	mov    $0x4111,%r11w
 1082fe1:	kmovd  %r11d,%k1
 1082fe6:	vmovdqu32 0x320(%rsi),%zmm1{%k1}{z}
 1082ff0:	mov    (%rdi,%r14,4),%edi
 1082ff4:	vpermd %zmm1,%zmm2,%zmm1
 1082ffa:	vmovd  0x48(%r8),%xmm2
 1083000:	vpinsrd $0x1,0xa0(%r8),%xmm2,%xmm2
 108300a:	mov    %r13d,(%rdx,%rcx,1)
 108300e:	mov    %edi,0x4(%rdx,%rcx,1)
 1083012:	vinserti128 $0x1,%xmm1,%ymm2,%ymm1
 1083018:	vpermt2d %ymm0,%ymm3,%ymm1
 108301e:	vmovdqu %ymm1,0x8(%rdx,%rcx,1)
 1083024:	mov    %r9d,0x28(%rdx,%rcx,1)
 1083029:	mov    %r10d,0x2c(%rdx,%rcx,1)
 108302e:	incl   0x1e0(%rax)
 1083034:	mov    0x2aa60(%rax),%rcx
 108303b:	jmp    1083228 <check_input_resolve_range+0xb88>
 1083040:	mov    0x188(%rbx),%rax
 1083047:	cmpb   $0x2,(%rax,%rbp,1)
 108304b:	jne    10835b4 <check_input_resolve_range+0xf14>
 1083051:	mov    0x180(%rbx),%rax
 1083058:	mov    0x198(%rbx),%rcx
 108305f:	vpxor  %xmm0,%xmm0,%xmm0
 1083063:	mov    %rbx,%rdi
 1083066:	xor    %r8d,%r8d
 1083069:	lea    0x130(%rsp),%r9
 1083071:	mov    (%rcx,%rbp,4),%r14d
 1083075:	mov    (%rax,%rbp,8),%r15
 1083079:	lea    0x1(%r13),%ebp
 108307d:	vmovdqu64 %zmm0,0x150(%rsp)
 1083088:	vmovdqu64 %zmm0,0x130(%rsp)
 1083093:	xor    %ecx,%ecx
 1083095:	mov    %ebp,%esi
 1083097:	mov    %r14d,%edx
 108309a:	push   $0x0
 108309c:	lea    0x208(%rsp),%rax
 10830a4:	push   %rax
 10830a5:	vzeroupper
 10830a8:	call   10c1fc0 <check_input_constant_read>
 10830ad:	add    $0x10,%rsp
 10830b1:	test   %al,%al
 10830b3:	je     108892e <check_input_resolve_range+0x628e>
 10830b9:	cmpl   $0x0,0x184(%rsp)
 10830c1:	jne    108892e <check_input_resolve_range+0x628e>
 10830c7:	cmpl   $0x1,0x13c(%rsp)
 10830cf:	jne    108892e <check_input_resolve_range+0x628e>
 10830d5:	testb  $0x10,0x138(%rsp)
 10830dd:	jne    108892e <check_input_resolve_range+0x628e>
 10830e3:	mov    0x18(%rbx),%rax
 10830e7:	mov    0x130(%rsp),%edx
 10830ee:	mov    (%rax),%rcx
 10830f1:	mov    %edx,%esi
 10830f3:	shr    $0x3,%esi
 10830f6:	movzbl (%rcx,%rsi,1),%edi
 10830fa:	cmp    $0xf,%dil
 10830fe:	jne    1083110 <check_input_resolve_range+0xa70>
 1083100:	mov    0x20(%rax),%rdx
 1083104:	mov    (%rdx,%rsi,4),%edx
 1083107:	mov    %edx,%esi
 1083109:	shr    $0x3,%esi
 108310c:	movzbl (%rcx,%rsi,1),%edi
 1083110:	cmp    $0x12,%dil
 1083114:	jne    1083127 <check_input_resolve_range+0xa87>
 1083116:	mov    0x10(%rax),%rdi
 108311a:	testb  $0x4,(%rdi,%rsi,1)
 108311e:	je     1083127 <check_input_resolve_range+0xa87>
 1083120:	mov    0x20(%rax),%rdx
 1083124:	mov    (%rdx,%rsi,4),%edx
 1083127:	shr    $0x3,%edx
 108312a:	movzbl (%rcx,%rdx,1),%ecx
 108312e:	cmp    $0x2,%ecx
 1083131:	je     1083153 <check_input_resolve_range+0xab3>
 1083133:	cmp    $0x5,%ecx
 1083136:	jne    108892e <check_input_resolve_range+0x628e>
 108313c:	mov    0x10(%rax),%rsi
 1083140:	mov    0x30(%rax),%rax
 1083144:	movzbl (%rsi,%rdx,1),%r9d
 1083149:	mov    (%rax,%rdx,8),%rcx
 108314d:	xor    $0x1,%r9b
 1083151:	jmp    1083169 <check_input_resolve_range+0xac9>
 1083153:	lea    (%rdx,%rdx,2),%rax
 1083157:	lea    -0xbda66e(%rip),%rdx        # 4a8af0 <type_integer_info>
 108315e:	movzbl 0x2(%rdx,%rax,2),%ecx
 1083163:	movzbl 0x3(%rdx,%rax,2),%r9d
 1083169:	lea    -0x1(%rcx),%rax
 108316d:	cmp    $0x7f,%rax
 1083171:	ja     108892e <check_input_resolve_range+0x628e>
 1083177:	mov    $0xffffffffffffffff,%rax
 108317e:	xor    %edx,%edx
 1083180:	test   $0x40,%cl
 1083183:	mov    0x148(%rsp),%rdi
 108318b:	shlx   %rcx,%rax,%rsi
 1083190:	mov    %rsi,%r8
 1083193:	cmovne %rdx,%r8
 1083197:	cmove  %rax,%rsi
 108319b:	cmp    $0x80,%rcx
 10831a2:	not    %rsi
 10831a5:	not    %r8
 10831a8:	cmove  %rax,%r8
 10831ac:	cmove  %rax,%rsi
 10831b0:	mov    0x140(%rsp),%rax
 10831b8:	and    %rsi,%rdi
 10831bb:	and    %r8,%rax
 10831be:	test   $0x1,%r9b
 10831c2:	je     10832b1 <check_input_resolve_range+0xc11>
 10831c8:	dec    %cl
 10831ca:	mov    %rax,%r9
 10831cd:	mov    $0x0,%edx
 10831d2:	shrd   %cl,%rdi,%r9
 10831d6:	shrx   %rcx,%rdi,%r10
 10831db:	test   $0x40,%cl
 10831de:	mov    $0x0,%ecx
 10831e3:	cmovne %r10,%r9
 10831e7:	cmovne %rcx,%r10
 10831eb:	mov    %rax,%rcx
 10831ee:	neg    %rcx
 10831f1:	sbb    %rdi,%rdx
 10831f4:	or     %r9,%r10
 10831f7:	je     10832af <check_input_resolve_range+0xc0f>
 10831fd:	and    %rdx,%rsi
 1083200:	and    %rcx,%r8
 1083203:	mov    $0x1,%dl
 1083205:	movabs $0x8000000000000000,%rcx
 108320f:	mov    %r8,%rax
 1083212:	mov    %rsi,%rdi
 1083215:	jmp    10832bb <check_input_resolve_range+0xc1b>
 108321a:	lea    -0x9c26f4(%rip),%rcx        # 6c0b2d <pp_string_value.meaning+0x385ac>
 1083221:	movb   $0x1,0x2aa58(%rax)
 1083228:	mov    %rcx,0x2aa60(%rax)
 108322f:	mov    0x60(%r12),%rax
 1083234:	mov    (%rax,%r14,4),%r13d
 1083238:	jmp    1082785 <check_input_resolve_range+0xe5>
 108323d:	cmp    0x30(%r12),%r13d
 1083242:	jae    1083258 <check_input_resolve_range+0xbb8>
 1083244:	mov    0x18(%r12),%rax
 1083249:	mov    (%rax,%rbp,4),%eax
 108324c:	add    $0xffffffbe,%eax
 108324f:	cmp    $0x2,%eax
 1083252:	jbe    1082c7e <check_input_resolve_range+0x5de>
 1083258:	vpbroadcastq -0xad6e92(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1083262:	vpbroadcastd -0xad768b(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108326b:	vpbroadcastq -0xad6e95(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1083275:	vpbroadcastd -0xad769f(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108327f:	vpbroadcastq -0xad6eb1(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1083289:	jmp    1082785 <check_input_resolve_range+0xe5>
 108328e:	movb   $0x1,0x3bd(%rax)
 1083295:	mov    (%rbx),%rax
 1083298:	mov    0x48(%rsp),%r12
 108329d:	cmpl   $0x0,0x230(%rax)
 10832a4:	je     1082d55 <check_input_resolve_range+0x6b5>
 10832aa:	jmp    10826d4 <check_input_resolve_range+0x34>
 10832af:	xor    %edx,%edx
 10832b1:	movabs $0x7fffffffffffffff,%rcx
 10832bb:	cmp    %rax,%rcx
 10832be:	mov    $0x0,%ecx
 10832c3:	sbb    %rdi,%rcx
 10832c6:	jb     108892e <check_input_resolve_range+0x628e>
 10832cc:	mov    %rax,%r12
 10832cf:	neg    %r12
 10832d2:	test   %dl,%dl
 10832d4:	lea    0x130(%rsp),%rcx
 10832dc:	mov    $0x1,%r8d
 10832e2:	mov    %rbx,%rdi
 10832e5:	mov    %ebp,%esi
 10832e7:	mov    %r14d,%edx
 10832ea:	cmove  %rax,%r12
 10832ee:	call   10c1db0 <check_input_constant_warning>
 10832f3:	test   %r12,%r12
 10832f6:	js     108892e <check_input_resolve_range+0x628e>
 10832fc:	cmp    %r15d,%r14d
 10832ff:	jne    1083316 <check_input_resolve_range+0xc76>
 1083301:	mov    0x28(%rsp),%r14
 1083306:	mov    0x8(%rsp),%rdx
 108330b:	mov    %r12,%rbx
 108330e:	mov    %ebp,%r13d
 1083311:	jmp    108354d <check_input_resolve_range+0xead>
 1083316:	mov    0x8(%rsp),%rbx
 108331b:	lea    0x1(%r14),%r13d
 108331f:	vpxor  %xmm0,%xmm0,%xmm0
 1083323:	vmovdqu64 %zmm0,0x150(%rsp)
 108332e:	vmovdqu64 %zmm0,0x130(%rsp)
 1083339:	mov    %r15d,%edx
 108333c:	xor    %ecx,%ecx
 108333e:	xor    %r8d,%r8d
 1083341:	lea    0x130(%rsp),%r9
 1083349:	mov    %r13d,%esi
 108334c:	mov    %rbx,%rdi
 108334f:	push   $0x0
 1083351:	lea    0x208(%rsp),%rax
 1083359:	push   %rax
 108335a:	vzeroupper
 108335d:	call   10c1fc0 <check_input_constant_read>
 1083362:	add    $0x10,%rsp
 1083366:	test   %al,%al
 1083368:	je     108892e <check_input_resolve_range+0x628e>
 108336e:	cmpl   $0x0,0x184(%rsp)
 1083376:	jne    108892e <check_input_resolve_range+0x628e>
 108337c:	cmpl   $0x1,0x13c(%rsp)
 1083384:	jne    108892e <check_input_resolve_range+0x628e>
 108338a:	testb  $0x10,0x138(%rsp)
 1083392:	jne    108892e <check_input_resolve_range+0x628e>
 1083398:	mov    0x18(%rbx),%rax
 108339c:	mov    0x130(%rsp),%edx
 10833a3:	mov    (%rax),%rcx
 10833a6:	mov    %edx,%esi
 10833a8:	shr    $0x3,%esi
 10833ab:	movzbl (%rcx,%rsi,1),%edi
 10833af:	cmp    $0xf,%dil
 10833b3:	jne    10833c5 <check_input_resolve_range+0xd25>
 10833b5:	mov    0x20(%rax),%rdx
 10833b9:	mov    (%rdx,%rsi,4),%edx
 10833bc:	mov    %edx,%esi
 10833be:	shr    $0x3,%esi
 10833c1:	movzbl (%rcx,%rsi,1),%edi
 10833c5:	cmp    $0x12,%dil
 10833c9:	jne    10833dc <check_input_resolve_range+0xd3c>
 10833cb:	mov    0x10(%rax),%rdi
 10833cf:	testb  $0x4,(%rdi,%rsi,1)
 10833d3:	je     10833dc <check_input_resolve_range+0xd3c>
 10833d5:	mov    0x20(%rax),%rdx
 10833d9:	mov    (%rdx,%rsi,4),%edx
 10833dc:	shr    $0x3,%edx
 10833df:	movzbl (%rcx,%rdx,1),%ecx
 10833e3:	cmp    $0x2,%ecx
 10833e6:	je     1083408 <check_input_resolve_range+0xd68>
 10833e8:	cmp    $0x5,%ecx
 10833eb:	jne    108892e <check_input_resolve_range+0x628e>
 10833f1:	mov    0x10(%rax),%rsi
 10833f5:	mov    0x30(%rax),%rax
 10833f9:	movzbl (%rsi,%rdx,1),%r9d
 10833fe:	mov    (%rax,%rdx,8),%rcx
 1083402:	xor    $0x1,%r9b
 1083406:	jmp    108341e <check_input_resolve_range+0xd7e>
 1083408:	lea    (%rdx,%rdx,2),%rax
 108340c:	lea    -0xbda923(%rip),%rdx        # 4a8af0 <type_integer_info>
 1083413:	movzbl 0x2(%rdx,%rax,2),%ecx
 1083418:	movzbl 0x3(%rdx,%rax,2),%r9d
 108341e:	lea    -0x1(%rcx),%rax
 1083422:	cmp    $0x7f,%rax
 1083426:	ja     108892e <check_input_resolve_range+0x628e>
 108342c:	mov    $0xffffffffffffffff,%rax
 1083433:	mov    $0xffffffffffffffff,%rdi
 108343a:	xor    %esi,%esi
 108343c:	mov    $0x0,%r8d
 1083442:	shld   %cl,%rax,%rax
 1083446:	shlx   %rcx,%rdi,%rdx
 108344b:	test   $0x40,%cl
 108344e:	cmove  %rdx,%r8
 1083452:	cmovne %rdx,%rax
 1083456:	cmp    $0x80,%rcx
 108345d:	not    %r8
 1083460:	mov    0x140(%rsp),%rdx
 1083468:	not    %rax
 108346b:	cmove  %rdi,%r8
 108346f:	cmove  %rdi,%rax
 1083473:	mov    0x148(%rsp),%rdi
 108347b:	and    %r8,%rdx
 108347e:	and    %rax,%rdi
 1083481:	test   $0x1,%r9b
 1083485:	je     10834d5 <check_input_resolve_range+0xe35>
 1083487:	dec    %cl
 1083489:	mov    %rdx,%r9
 108348c:	mov    $0x0,%esi
 1083491:	shrd   %cl,%rdi,%r9
 1083495:	shrx   %rcx,%rdi,%r10
 108349a:	test   $0x40,%cl
 108349d:	mov    $0x0,%ecx
 10834a2:	cmovne %r10,%r9
 10834a6:	cmovne %rcx,%r10
 10834aa:	mov    %rdx,%rcx
 10834ad:	neg    %rcx
 10834b0:	sbb    %rdi,%rsi
 10834b3:	or     %r9,%r10
 10834b6:	je     10834d3 <check_input_resolve_range+0xe33>
 10834b8:	and    %rsi,%rax
 10834bb:	and    %rcx,%r8
 10834be:	mov    $0x1,%sil
 10834c1:	movabs $0x8000000000000000,%rcx
 10834cb:	mov    %r8,%rdx
 10834ce:	mov    %rax,%rdi
 10834d1:	jmp    10834df <check_input_resolve_range+0xe3f>
 10834d3:	xor    %esi,%esi
 10834d5:	movabs $0x7fffffffffffffff,%rcx
 10834df:	cmp    %rdx,%rcx
 10834e2:	mov    $0x0,%eax
 10834e7:	sbb    %rdi,%rax
 10834ea:	jb     108892e <check_input_resolve_range+0x628e>
 10834f0:	mov    %rbx,%rdi
 10834f3:	mov    %rdx,%rbx
 10834f6:	neg    %rbx
 10834f9:	test   %sil,%sil
 10834fc:	lea    0x130(%rsp),%rcx
 1083504:	mov    $0x1,%r8d
 108350a:	mov    %r13d,%esi
 108350d:	cmove  %rdx,%rbx
 1083511:	mov    %r15d,%edx
 1083514:	call   10c1db0 <check_input_constant_warning>
 1083519:	cmp    %r12,%rbx
 108351c:	jl     108892e <check_input_resolve_range+0x628e>
 1083522:	mov    0x8(%rsp),%rdx
 1083527:	mov    0x28(%rsp),%rcx
 108352c:	mov    0x180(%rdx),%rax
 1083533:	mov    %r12,(%rax,%rcx,8)
 1083537:	mov    0x188(%rdx),%rax
 108353e:	movb   $0x1,(%rax,%rcx,1)
 1083542:	mov    0x190(%rdx),%rax
 1083549:	mov    %ebp,(%rax,%r14,4)
 108354d:	mov    0x180(%rdx),%rcx
 1083554:	vpbroadcastq -0xad718e(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108355e:	vpbroadcastd -0xad7987(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1083567:	vpbroadcastq -0xad7191(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1083571:	vpbroadcastd -0xad799b(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108357b:	vpbroadcastq -0xad71ad(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1083585:	mov    %r15d,%eax
 1083588:	mov    0x48(%rsp),%r12
 108358d:	mov    0x28(%rsp),%rbp
 1083592:	mov    %rbx,(%rcx,%r14,8)
 1083596:	mov    %rdx,%rbx
 1083599:	mov    0x188(%rdx),%rcx
 10835a0:	movb   $0x1,(%rcx,%r14,1)
 10835a5:	mov    0x190(%rdx),%rcx
 10835ac:	mov    %r13d,(%rcx,%rax,4)
 10835b0:	mov    (%rsp),%r13
 10835b4:	mov    0xb8(%rbx),%rax
 10835bb:	mov    (%rax,%rbp,8),%r14
 10835bf:	test   %r14,%r14
 10835c2:	je     1083ac0 <check_input_resolve_range+0x1420>
 10835c8:	cmpb   $0x0,0x41(%r14)
 10835cd:	jne    1083ac0 <check_input_resolve_range+0x1420>
 10835d3:	vpxor  %xmm0,%xmm0,%xmm0
 10835d7:	vmovdqu64 %zmm0,0x150(%rsp)
 10835e2:	vmovdqu64 %zmm0,0x130(%rsp)
 10835ed:	movl   $0xffffffff,0x12c(%rsp)
 10835f8:	movb   $0x0,0x2ce(%rbx)
 10835ff:	lea    0x12c(%rsp),%rax
 1083607:	mov    %rbx,%rdi
 108360a:	xor    %ecx,%ecx
 108360c:	mov    $0x1,%r8d
 1083612:	lea    0x130(%rsp),%r9
 108361a:	mov    0x4(%r14),%esi
 108361e:	mov    0x8(%r14),%edx
 1083622:	add    $0x2,%esi
 1083625:	push   %rax
 1083626:	lea    0x208(%rsp),%rax
 108362e:	push   %rax
 108362f:	vzeroupper
 1083632:	call   10c1fc0 <check_input_constant_read>
 1083637:	add    $0x10,%rsp
 108363b:	mov    0x4(%r14),%edx
 108363f:	mov    0x8(%r14),%ecx
 1083643:	add    $0x2,%edx
 1083646:	cmp    %ecx,%edx
 1083648:	jae    10836c9 <check_input_resolve_range+0x1029>
 108364a:	mov    (%rbx),%rsi
 108364d:	cmpq   $0x0,0x2c8(%rsi)
 1083655:	je     10836c9 <check_input_resolve_range+0x1029>
 1083657:	mov    0x8(%rbx),%rsi
 108365b:	cmp    0x30(%rsi),%ecx
 108365e:	ja     10836c9 <check_input_resolve_range+0x1029>
 1083660:	mov    %ecx,%r8d
 1083663:	sub    %edx,%r8d
 1083666:	mov    %edx,%edi
 1083668:	mov    %rdi,%rsi
 108366b:	and    $0x3,%r8d
 108366f:	je     10836c0 <check_input_resolve_range+0x1020>
 1083671:	mov    %rdi,%rsi
 1083674:	jmp    1083688 <check_input_resolve_range+0xfe8>
 1083676:	cs nopw 0x0(%rax,%rax,1)
 1083680:	inc    %rsi
 1083683:	dec    %r8
 1083686:	je     10836c0 <check_input_resolve_range+0x1020>
 1083688:	mov    0x280(%rbx),%r9
 108368f:	test   %r9,%r9
 1083692:	je     108369b <check_input_resolve_range+0xffb>
 1083694:	testb  $0x2,(%r9,%rsi,1)
 1083699:	jne    1083680 <check_input_resolve_range+0xfe0>
 108369b:	mov    (%rbx),%r9
 108369e:	mov    0x2c8(%r9),%r9
 10836a5:	andb   $0x87,(%r9,%rsi,1)
 10836aa:	mov    (%rbx),%r9
 10836ad:	mov    0x2d0(%r9),%r9
 10836b4:	test   %r9,%r9
 10836b7:	je     1083680 <check_input_resolve_range+0xfe0>
 10836b9:	andb   $0x87,(%r9,%rsi,1)
 10836be:	jmp    1083680 <check_input_resolve_range+0xfe0>
 10836c0:	sub    %rcx,%rdi
 10836c3:	cmp    $0xfffffffffffffffc,%rdi
 10836c7:	jbe    1083719 <check_input_resolve_range+0x1079>
 10836c9:	cmp    %ecx,%edx
 10836cb:	jae    1083832 <check_input_resolve_range+0x1192>
 10836d1:	cmpq   $0x0,0x288(%rbx)
 10836d9:	je     1083832 <check_input_resolve_range+0x1192>
 10836df:	mov    0x8(%rbx),%rsi
 10836e3:	cmp    0x30(%rsi),%ecx
 10836e6:	ja     1083832 <check_input_resolve_range+0x1192>
 10836ec:	mov    %ecx,%edi
 10836ee:	sub    %edx,%edi
 10836f0:	mov    %edx,%esi
 10836f2:	mov    %rsi,%rdx
 10836f5:	and    $0x3,%edi
 10836f8:	je     1083829 <check_input_resolve_range+0x1189>
 10836fe:	mov    %rsi,%rdx
 1083701:	jmp    1083814 <check_input_resolve_range+0x1174>
 1083706:	cs nopw 0x0(%rax,%rax,1)
 1083710:	add    $0x4,%rsi
 1083714:	cmp    %rsi,%rcx
 1083717:	je     10836c9 <check_input_resolve_range+0x1029>
 1083719:	mov    0x280(%rbx),%rdi
 1083720:	test   %rdi,%rdi
 1083723:	je     108372b <check_input_resolve_range+0x108b>
 1083725:	testb  $0x2,(%rdi,%rsi,1)
 1083729:	jne    108374c <check_input_resolve_range+0x10ac>
 108372b:	mov    (%rbx),%rdi
 108372e:	mov    0x2c8(%rdi),%rdi
 1083735:	andb   $0x87,(%rdi,%rsi,1)
 1083739:	mov    (%rbx),%rdi
 108373c:	mov    0x2d0(%rdi),%rdi
 1083743:	test   %rdi,%rdi
 1083746:	je     108374c <check_input_resolve_range+0x10ac>
 1083748:	andb   $0x87,(%rdi,%rsi,1)
 108374c:	mov    0x280(%rbx),%rdi
 1083753:	test   %rdi,%rdi
 1083756:	je     108375f <check_input_resolve_range+0x10bf>
 1083758:	testb  $0x2,0x1(%rdi,%rsi,1)
 108375d:	jne    1083782 <check_input_resolve_range+0x10e2>
 108375f:	mov    (%rbx),%rdi
 1083762:	mov    0x2c8(%rdi),%rdi
 1083769:	andb   $0x87,0x1(%rdi,%rsi,1)
 108376e:	mov    (%rbx),%rdi
 1083771:	mov    0x2d0(%rdi),%rdi
 1083778:	test   %rdi,%rdi
 108377b:	je     1083782 <check_input_resolve_range+0x10e2>
 108377d:	andb   $0x87,0x1(%rdi,%rsi,1)
 1083782:	mov    0x280(%rbx),%rdi
 1083789:	test   %rdi,%rdi
 108378c:	je     1083795 <check_input_resolve_range+0x10f5>
 108378e:	testb  $0x2,0x2(%rdi,%rsi,1)
 1083793:	jne    10837b8 <check_input_resolve_range+0x1118>
 1083795:	mov    (%rbx),%rdi
 1083798:	mov    0x2c8(%rdi),%rdi
 108379f:	andb   $0x87,0x2(%rdi,%rsi,1)
 10837a4:	mov    (%rbx),%rdi
 10837a7:	mov    0x2d0(%rdi),%rdi
 10837ae:	test   %rdi,%rdi
 10837b1:	je     10837b8 <check_input_resolve_range+0x1118>
 10837b3:	andb   $0x87,0x2(%rdi,%rsi,1)
 10837b8:	mov    0x280(%rbx),%rdi
 10837bf:	test   %rdi,%rdi
 10837c2:	je     10837cf <check_input_resolve_range+0x112f>
 10837c4:	testb  $0x2,0x3(%rdi,%rsi,1)
 10837c9:	jne    1083710 <check_input_resolve_range+0x1070>
 10837cf:	mov    (%rbx),%rdi
 10837d2:	mov    0x2c8(%rdi),%rdi
 10837d9:	andb   $0x87,0x3(%rdi,%rsi,1)
 10837de:	mov    (%rbx),%rdi
 10837e1:	mov    0x2d0(%rdi),%rdi
 10837e8:	test   %rdi,%rdi
 10837eb:	je     1083710 <check_input_resolve_range+0x1070>
 10837f1:	andb   $0x87,0x3(%rdi,%rsi,1)
 10837f6:	jmp    1083710 <check_input_resolve_range+0x1070>
 10837fb:	nopl   0x0(%rax,%rax,1)
 1083800:	mov    0x288(%rbx),%r8
 1083807:	orb    $0x78,(%r8,%rdx,1)
 108380c:	inc    %rdx
 108380f:	dec    %rdi
 1083812:	je     1083829 <check_input_resolve_range+0x1189>
 1083814:	mov    0x280(%rbx),%r8
 108381b:	test   %r8,%r8
 108381e:	je     1083800 <check_input_resolve_range+0x1160>
 1083820:	testb  $0x2,(%r8,%rdx,1)
 1083825:	je     1083800 <check_input_resolve_range+0x1160>
 1083827:	jmp    108380c <check_input_resolve_range+0x116c>
 1083829:	sub    %rcx,%rsi
 108382c:	cmp    $0xfffffffffffffffc,%rsi
 1083830:	jbe    1083875 <check_input_resolve_range+0x11d5>
 1083832:	xor    %ecx,%ecx
 1083834:	test   %al,%al
 1083836:	je     108383f <check_input_resolve_range+0x119f>
 1083838:	mov    0x130(%rsp),%ecx
 108383f:	mov    %ecx,0x28(%r14)
 1083843:	je     10838e9 <check_input_resolve_range+0x1249>
 1083849:	movzbl 0x2ce(%rbx),%eax
 1083850:	mov    %al,0x39(%r14)
 1083854:	jmp    108393f <check_input_resolve_range+0x129f>
 1083859:	nopl   0x0(%rax)
 1083860:	mov    0x288(%rbx),%rsi
 1083867:	orb    $0x78,0x3(%rsi,%rdx,1)
 108386c:	add    $0x4,%rdx
 1083870:	cmp    %rdx,%rcx
 1083873:	je     1083832 <check_input_resolve_range+0x1192>
 1083875:	mov    0x280(%rbx),%rsi
 108387c:	test   %rsi,%rsi
 108387f:	je     1083887 <check_input_resolve_range+0x11e7>
 1083881:	testb  $0x2,(%rsi,%rdx,1)
 1083885:	jne    1083892 <check_input_resolve_range+0x11f2>
 1083887:	mov    0x288(%rbx),%rsi
 108388e:	orb    $0x78,(%rsi,%rdx,1)
 1083892:	mov    0x280(%rbx),%rsi
 1083899:	test   %rsi,%rsi
 108389c:	je     10838a5 <check_input_resolve_range+0x1205>
 108389e:	testb  $0x2,0x1(%rsi,%rdx,1)
 10838a3:	jne    10838b1 <check_input_resolve_range+0x1211>
 10838a5:	mov    0x288(%rbx),%rsi
 10838ac:	orb    $0x78,0x1(%rsi,%rdx,1)
 10838b1:	mov    0x280(%rbx),%rsi
 10838b8:	test   %rsi,%rsi
 10838bb:	je     10838c4 <check_input_resolve_range+0x1224>
 10838bd:	testb  $0x2,0x2(%rsi,%rdx,1)
 10838c2:	jne    10838d0 <check_input_resolve_range+0x1230>
 10838c4:	mov    0x288(%rbx),%rsi
 10838cb:	orb    $0x78,0x2(%rsi,%rdx,1)
 10838d0:	mov    0x280(%rbx),%rsi
 10838d7:	test   %rsi,%rsi
 10838da:	je     1083860 <check_input_resolve_range+0x11c0>
 10838dc:	testb  $0x2,0x3(%rsi,%rdx,1)
 10838e1:	je     1083860 <check_input_resolve_range+0x11c0>
 10838e7:	jmp    108386c <check_input_resolve_range+0x11cc>
 10838e9:	movb   $0x0,0x39(%r14)
 10838ee:	mov    0x12c(%rsp),%eax
 10838f5:	cmp    0x30(%r12),%eax
 10838fa:	jae    108393f <check_input_resolve_range+0x129f>
 10838fc:	mov    (%rbx),%rcx
 10838ff:	cmpb   $0x0,0x3bd(%rcx)
 1083906:	jne    108393f <check_input_resolve_range+0x129f>
 1083908:	mov    0x230(%rcx),%edx
 108390e:	cmp    0x234(%rcx),%edx
 1083914:	jae    1083938 <check_input_resolve_range+0x1298>
 1083916:	mov    0x228(%rcx),%rsi
 108391d:	lea    0x1(%rdx),%edi
 1083920:	mov    %edi,0x230(%rcx)
 1083926:	lea    (%rdx,%rdx,2),%rcx
 108392a:	mov    %eax,(%rsi,%rcx,4)
 108392d:	movq   $0x1,0x4(%rsi,%rcx,4)
 1083936:	jmp    108393f <check_input_resolve_range+0x129f>
 1083938:	movb   $0x1,0x3bd(%rcx)
 108393f:	mov    0x18(%r12),%rax
 1083944:	mov    0x4(%r14),%ecx
 1083948:	mov    (%rax,%rcx,4),%eax
 108394b:	add    $0xffffffc6,%eax
 108394e:	cmp    $0x2b,%eax
 1083951:	ja     108398b <check_input_resolve_range+0x12eb>
 1083953:	movabs $0xc0000000001,%rcx
 108395d:	bt     %rax,%rcx
 1083961:	jae    108398b <check_input_resolve_range+0x12eb>
 1083963:	mov    0x28(%r14),%ecx
 1083967:	mov    %ecx,%eax
 1083969:	and    $0xfffffff8,%eax
 108396c:	shr    $0x3,%ecx
 108396f:	mov    %eax,0x28(%r14)
 1083973:	mov    0x18(%rbx),%rdx
 1083977:	mov    (%rdx),%rsi
 108397a:	cmpb   $0xe,(%rsi,%rcx,1)
 108397e:	jne    1083987 <check_input_resolve_range+0x12e7>
 1083980:	mov    0x20(%rdx),%rax
 1083984:	mov    (%rax,%rcx,4),%eax
 1083987:	mov    %eax,0x28(%r14)
 108398b:	movb   $0x1,0x41(%r14)
 1083990:	decl   0xc4(%rbx)
 1083996:	cmpl   $0x0,0x28(%r14)
 108399b:	je     10839de <check_input_resolve_range+0x133e>
 108399d:	mov    (%r14),%esi
 10839a0:	mov    %rbx,%rdi
 10839a3:	call   10929a0 <check_input_declaration>
 10839a8:	vpbroadcastq -0xad75e2(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10839b2:	vpbroadcastd -0xad7ddb(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10839bb:	vpbroadcastq -0xad75e5(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10839c5:	vpbroadcastd -0xad7def(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10839cf:	vpbroadcastq -0xad7601(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10839d9:	jmp    1083ac0 <check_input_resolve_range+0x1420>
 10839de:	mov    (%rbx),%rax
 10839e1:	vpbroadcastq -0xad761b(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10839eb:	vpbroadcastd -0xad7e14(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10839f4:	vpbroadcastq -0xad761e(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10839fe:	vpbroadcastd -0xad7e28(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1083a08:	vpbroadcastq -0xad763a(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1083a12:	cmpl   $0x0,0x230(%rax)
 1083a19:	jne    1083ac0 <check_input_resolve_range+0x1420>
 1083a1f:	cmpb   $0x0,0x3bd(%rax)
 1083a26:	jne    1083ac0 <check_input_resolve_range+0x1420>
 1083a2c:	cmpl   $0x0,0x234(%rax)
 1083a33:	je     1083aae <check_input_resolve_range+0x140e>
 1083a35:	mov    0x4(%r14),%ecx
 1083a39:	mov    0x228(%rax),%rdx
 1083a40:	movl   $0x1,0x230(%rax)
 1083a4a:	mov    %ecx,(%rdx)
 1083a4c:	movq   $0x1,0x4(%rdx)
 1083a54:	jmp    1083ac0 <check_input_resolve_range+0x1420>
 1083a56:	mov    0x108(%rdi),%rax
 1083a5d:	mov    0x8(%rsp),%r8
 1083a62:	movl   $0x2,0x100(%rdi)
 1083a6c:	test   %rax,%rax
 1083a6f:	je     1083a87 <check_input_resolve_range+0x13e7>
 1083a71:	movb   $0x1,0x3c(%rax)
 1083a75:	mov    0x30(%rax),%rcx
 1083a79:	mov    %rcx,0x40(%rax)
 1083a7d:	movl   $0x2,0x48(%rax)
 1083a84:	incl   0x34(%rax)
 1083a87:	mov    0x18(%r8),%rax
 1083a8b:	mov    (%rsp),%r13
 1083a8f:	mov    %r8,%rbx
 1083a92:	cmpl   $0x1,0x100(%rax)
 1083a99:	jne    1082cf0 <check_input_resolve_range+0x650>
 1083a9f:	mov    (%rbx),%rax
 1083aa2:	movb   $0x1,0x3bd(%rax)
 1083aa9:	jmp    1082cf0 <check_input_resolve_range+0x650>
 1083aae:	movb   $0x1,0x3bd(%rax)
 1083ab5:	data16 cs nopw 0x0(%rax,%rax,1)
 1083ac0:	mov    0x10(%r12),%rcx
 1083ac5:	mov    0x50(%r12),%rax
 1083aca:	movzbl (%rax,%rbp,1),%esi
 1083ace:	movzbl (%rcx,%rbp,1),%edx
 1083ad2:	mov    %edx,0x3c(%rsp)
 1083ad6:	mov    %rsi,0x50(%rsp)
 1083adb:	cmp    $0x2,%sil
 1083adf:	jne    1083b20 <check_input_resolve_range+0x1480>
 1083ae1:	mov    0x60(%r12),%rdx
 1083ae6:	mov    (%rdx,%rbp,4),%esi
 1083ae9:	cmp    0x30(%r12),%esi
 1083aee:	jae    1083b20 <check_input_resolve_range+0x1480>
 1083af0:	movzbl (%rax,%rsi,1),%edx
 1083af4:	mov    $0x1,%al
 1083af6:	cmp    $0x21,%dl
 1083af9:	je     1083b22 <check_input_resolve_range+0x1482>
 1083afb:	movzbl (%rcx,%rsi,1),%ecx
 1083aff:	cmp    $0x4f,%cl
 1083b02:	je     1083b22 <check_input_resolve_range+0x1482>
 1083b04:	xor    $0x9,%dl
 1083b07:	xor    $0xf,%cl
 1083b0a:	or     %dl,%cl
 1083b0c:	sete   %al
 1083b0f:	jmp    1083b22 <check_input_resolve_range+0x1482>
 1083b11:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1083b20:	xor    %eax,%eax
 1083b22:	mov    0x50(%rsp),%rsi
 1083b27:	mov    0x3c(%rsp),%edx
 1083b2b:	cmp    $0x21,%sil
 1083b2f:	sete   %cl
 1083b32:	or     %al,%cl
 1083b34:	cmp    $0x4f,%edx
 1083b37:	sete   %al
 1083b3a:	cmp    $0x49,%edx
 1083b3d:	sete   %dl
 1083b40:	or     %al,%dl
 1083b42:	or     %cl,%dl
 1083b44:	cmp    $0x3a,%sil
 1083b48:	sete   %al
 1083b4b:	or     %dl,%al
 1083b4d:	mov    0x138(%rbx),%rdx
 1083b54:	or     %al,(%rdx,%rbp,1)
 1083b57:	cmp    $0x22,%sil
 1083b5b:	jne    1083ca0 <check_input_resolve_range+0x1600>
 1083b61:	mov    0x138(%rbx),%rax
 1083b68:	cmpb   $0x0,(%rax,%rbp,1)
 1083b6c:	jne    1083ca0 <check_input_resolve_range+0x1600>
 1083b72:	lea    0x1(%r13),%eax
 1083b76:	cmp    0x30(%r12),%eax
 1083b7b:	jae    1083ca0 <check_input_resolve_range+0x1600>
 1083b81:	mov    0x50(%r12),%rdx
 1083b86:	mov    %eax,%ecx
 1083b88:	cmpb   $0x33,(%rdx,%rcx,1)
 1083b8c:	jne    1083ca0 <check_input_resolve_range+0x1600>
 1083b92:	mov    0x8(%rbx),%rdx
 1083b96:	mov    0x30(%rdx),%r9d
 1083b9a:	cmp    %r9d,0x3bc(%rbx)
 1083ba1:	jae    1083c3b <check_input_resolve_range+0x159b>
 1083ba7:	mov    0x60(%rdx),%rsi
 1083bab:	mov    (%rsi,%rbp,4),%eax
 1083bae:	cmp    %r9d,%eax
 1083bb1:	jae    1083c3b <check_input_resolve_range+0x159b>
 1083bb7:	mov    (%rsi,%rcx,4),%ecx
 1083bba:	lea    0x1(%rcx),%esi
 1083bbd:	cmp    %eax,%esi
 1083bbf:	jne    1083c3b <check_input_resolve_range+0x159b>
 1083bc5:	mov    0x50(%rdx),%rsi
 1083bc9:	cmpb   $0x4c,(%rsi,%rcx,1)
 1083bcd:	jne    1083c3b <check_input_resolve_range+0x159b>
 1083bcf:	mov    0x370(%rbx),%r11
 1083bd6:	mov    (%r11,%rcx,4),%r10d
 1083bda:	cmp    $0xffffffff,%r10d
 1083bde:	je     1085c4e <check_input_resolve_range+0x35ae>
 1083be4:	mov    0x378(%rbx),%r8
 1083beb:	mov    $0xffffffff,%edi
 1083bf0:	mov    %r10d,%ebx
 1083bf3:	cmpb   $0x33,(%rsi,%rbx,1)
 1083bf7:	cmovne %r10d,%edi
 1083bfb:	mov    (%r8,%rbx,4),%r10d
 1083bff:	cmp    $0xffffffff,%r10d
 1083c03:	jne    1083bf0 <check_input_resolve_range+0x1550>
 1083c05:	mov    $0xffffffff,%r10d
 1083c0b:	cmp    %r9d,%edi
 1083c0e:	jae    1088790 <check_input_resolve_range+0x60f0>
 1083c14:	mov    %edi,%r9d
 1083c17:	cmpb   $0x1e,(%rsi,%r9,1)
 1083c1c:	jne    1088790 <check_input_resolve_range+0x60f0>
 1083c22:	mov    (%r11,%r9,4),%ebx
 1083c26:	cmp    $0xffffffff,%ebx
 1083c29:	je     1088790 <check_input_resolve_range+0x60f0>
 1083c2f:	mov    0x10(%rdx),%r9
 1083c33:	mov    $0x1,%bpl
 1083c36:	jmp    1085b70 <check_input_resolve_range+0x34d0>
 1083c3b:	mov    (%rbx),%rax
 1083c3e:	mov    0x230(%rax),%ecx
 1083c44:	cmp    0x234(%rax),%ecx
 1083c4a:	jae    1083c8f <check_input_resolve_range+0x15ef>
 1083c4c:	movzbl 0x3bd(%rax),%edx
 1083c53:	mov    0x228(%rax),%rsi
 1083c5a:	lea    0x1(%rcx),%edi
 1083c5d:	mov    %edi,0x230(%rax)
 1083c63:	lea    (%rcx,%rcx,2),%rax
 1083c67:	lea    0x1(%rdx,%rdx,2),%edx
 1083c6b:	mov    %r13d,(%rsi,%rax,4)
 1083c6f:	mov    %edx,0x4(%rsi,%rax,4)
 1083c73:	movl   $0x0,0x8(%rsi,%rax,4)
 1083c7b:	mov    0x138(%rbx),%rax
 1083c82:	movzbl (%rax,%rbp,1),%eax
 1083c86:	test   %al,%al
 1083c88:	je     1083cb3 <check_input_resolve_range+0x1613>
 1083c8a:	jmp    108649b <check_input_resolve_range+0x3dfb>
 1083c8f:	movb   $0x1,0x3bd(%rax)
 1083c96:	cs nopw 0x0(%rax,%rax,1)
 1083ca0:	mov    0x138(%rbx),%rax
 1083ca7:	movzbl (%rax,%rbp,1),%eax
 1083cab:	test   %al,%al
 1083cad:	jne    108649b <check_input_resolve_range+0x3dfb>
 1083cb3:	cmpb   $0x3d,0x3c(%rsp)
 1083cb8:	jne    108649b <check_input_resolve_range+0x3dfb>
 1083cbe:	mov    0x8(%rbx),%rbp
 1083cc2:	lea    0x1(%r13),%edx
 1083cc6:	mov    $0xffffffff,%r11d
 1083ccc:	xor    %eax,%eax
 1083cce:	mov    0x30(%rbp),%ecx
 1083cd1:	cmp    %ecx,%edx
 1083cd3:	jae    1083cef <check_input_resolve_range+0x164f>
 1083cd5:	mov    0x10(%rbp),%rdi
 1083cd9:	mov    %edx,%esi
 1083cdb:	nopl   0x0(%rax,%rax,1)
 1083ce0:	cmpb   $0x8,(%rdi,%rsi,1)
 1083ce4:	je     1083cf3 <check_input_resolve_range+0x1653>
 1083ce6:	inc    %rsi
 1083ce9:	cmp    %esi,%ecx
 1083ceb:	jne    1083ce0 <check_input_resolve_range+0x1640>
 1083ced:	jmp    1083d20 <check_input_resolve_range+0x1680>
 1083cef:	mov    %edx,%ecx
 1083cf1:	jmp    1083d20 <check_input_resolve_range+0x1680>
 1083cf3:	mov    0x50(%rbp),%r8
 1083cf7:	mov    0x60(%rbp),%r9
 1083cfb:	mov    (%r9,%rsi,4),%r11d
 1083cff:	cmpb   $0x2e,(%r8,%rsi,1)
 1083d04:	jne    1083d1e <check_input_resolve_range+0x167e>
 1083d06:	cmp    %ecx,%r11d
 1083d09:	jae    1083d1e <check_input_resolve_range+0x167e>
 1083d0b:	lea    0x1(%r11),%r8
 1083d0f:	cmp    %ecx,%r8d
 1083d12:	jae    1083d1e <check_input_resolve_range+0x167e>
 1083d14:	xor    %eax,%eax
 1083d16:	cmpb   $0x30,(%rdi,%r8,1)
 1083d1b:	sete   %al
 1083d1e:	mov    %esi,%ecx
 1083d20:	mov    (%rbx),%r14
 1083d23:	xor    %esi,%esi
 1083d25:	mov    %r11,0x30(%rsp)
 1083d2a:	mov    0x340(%r14),%r15d
 1083d31:	movzbl 0x3bd(%r14),%edi
 1083d39:	cmp    0x344(%r14),%r15d
 1083d40:	setae  %sil
 1083d44:	or     %edi,%esi
 1083d46:	mov    %sil,0x3bd(%r14)
 1083d4d:	xor    $0x1,%esi
 1083d50:	test   %esi,%eax
 1083d52:	je     1083dea <check_input_resolve_range+0x174a>
 1083d58:	mov    0x28(%rbx),%rax
 1083d5c:	mov    0x338(%r14),%rsi
 1083d63:	lea    (%r15,%r15,4),%rdi
 1083d67:	lea    0x1(%r11),%r8d
 1083d6b:	vpxor  %xmm0,%xmm0,%xmm0
 1083d6f:	shl    $0x4,%rdi
 1083d73:	mov    0x8(%rax),%rax
 1083d77:	lea    (%rsi,%rdi,1),%r12
 1083d7b:	mov    %rax,0xe8(%rsp)
 1083d83:	lea    0x1(%rcx),%eax
 1083d86:	mov    %eax,0x130(%rsp)
 1083d8d:	mov    0x3bc(%rbx),%r9d
 1083d94:	vmovdqu %ymm0,0x18(%rsi,%rdi,1)
 1083d9a:	vmovdqu %ymm0,(%rsi,%rdi,1)
 1083d9f:	mov    %r13d,0x38(%rsi,%rdi,1)
 1083da4:	mov    %r11d,0x3c(%rsi,%rdi,1)
 1083da9:	mov    %r8d,0x40(%rsi,%rdi,1)
 1083dae:	mov    %r9d,0x44(%rsi,%rdi,1)
 1083db3:	movq   $0x0,0x48(%rsi,%rdi,1)
 1083dbc:	cmp    %ecx,%edx
 1083dbe:	jae    1083fe0 <check_input_resolve_range+0x1940>
 1083dc4:	mov    %r13d,%esi
 1083dc7:	sub    %ecx,%esi
 1083dc9:	mov    %ecx,%edi
 1083dcb:	sub    %r13d,%edi
 1083dce:	mov    %edx,%edx
 1083dd0:	not    %esi
 1083dd2:	add    $0xfffffffe,%edi
 1083dd5:	and    $0x3,%esi
 1083dd8:	cmp    $0x3,%edi
 1083ddb:	jae    1083e30 <check_input_resolve_range+0x1790>
 1083ddd:	xor    %edi,%edi
 1083ddf:	xor    %r8d,%r8d
 1083de2:	xor    %r10d,%r10d
 1083de5:	jmp    1083fa0 <check_input_resolve_range+0x1900>
 1083dea:	mov    0x28(%rbx),%rax
 1083dee:	inc    %ecx
 1083df0:	inc    %r15d
 1083df3:	movq   $0x0,0x90(%rsp)
 1083dff:	movq   $0x0,0x58(%rsp)
 1083e08:	xor    %r12d,%r12d
 1083e0b:	movq   $0x0,0x70(%rsp)
 1083e14:	xor    %edx,%edx
 1083e16:	mov    0x8(%rax),%rax
 1083e1a:	mov    %ecx,0x130(%rsp)
 1083e21:	mov    %rax,0xe8(%rsp)
 1083e29:	xor    %eax,%eax
 1083e2b:	jmp    1084380 <check_input_resolve_range+0x1ce0>
 1083e30:	mov    %r13d,%edi
 1083e33:	not    %edi
 1083e35:	xor    %r9d,%r9d
 1083e38:	xor    %r8d,%r8d
 1083e3b:	xor    %r10d,%r10d
 1083e3e:	add    %edi,%ecx
 1083e40:	xor    %edi,%edi
 1083e42:	and    $0xfffffffc,%ecx
 1083e45:	data16 cs nopw 0x0(%rax,%rax,1)
 1083e50:	mov    0x10(%rbp),%r11
 1083e54:	add    %rdx,%r11
 1083e57:	cmpb   $0x37,(%r9,%r11,1)
 1083e5c:	sete   %r11b
 1083e60:	or     %r11b,%r10b
 1083e63:	mov    %r10b,0x49(%r12)
 1083e68:	mov    0x10(%rbp),%r11
 1083e6c:	add    %rdx,%r11
 1083e6f:	cmpb   $0x3a,(%r9,%r11,1)
 1083e74:	sete   %r11b
 1083e78:	or     %r11b,%r8b
 1083e7b:	mov    %r8b,0x4a(%r12)
 1083e80:	mov    0x10(%rbp),%r11
 1083e84:	add    %rdx,%r11
 1083e87:	cmpb   $0x4f,(%r9,%r11,1)
 1083e8c:	sete   %r11b
 1083e90:	or     %r11b,%dil
 1083e93:	mov    %dil,0x4b(%r12)
 1083e98:	mov    0x10(%rbp),%r11
 1083e9c:	add    %rdx,%r11
 1083e9f:	cmpb   $0x37,0x1(%r9,%r11,1)
 1083ea5:	sete   %r11b
 1083ea9:	or     %r10b,%r11b
 1083eac:	mov    %r11b,0x49(%r12)
 1083eb1:	mov    0x10(%rbp),%r10
 1083eb5:	add    %rdx,%r10
 1083eb8:	cmpb   $0x3a,0x1(%r9,%r10,1)
 1083ebe:	sete   %r10b
 1083ec2:	or     %r8b,%r10b
 1083ec5:	mov    %r10b,0x4a(%r12)
 1083eca:	mov    0x10(%rbp),%r8
 1083ece:	add    %rdx,%r8
 1083ed1:	cmpb   $0x4f,0x1(%r9,%r8,1)
 1083ed7:	sete   %r8b
 1083edb:	or     %dil,%r8b
 1083ede:	mov    %r8b,0x4b(%r12)
 1083ee3:	mov    0x10(%rbp),%rdi
 1083ee7:	add    %rdx,%rdi
 1083eea:	cmpb   $0x37,0x2(%r9,%rdi,1)
 1083ef0:	sete   %dil
 1083ef4:	or     %r11b,%dil
 1083ef7:	mov    %dil,0x49(%r12)
 1083efc:	mov    0x10(%rbp),%r11
 1083f00:	add    %rdx,%r11
 1083f03:	cmpb   $0x3a,0x2(%r9,%r11,1)
 1083f09:	sete   %r11b
 1083f0d:	or     %r10b,%r11b
 1083f10:	mov    %r11b,0x4a(%r12)
 1083f15:	mov    0x10(%rbp),%r10
 1083f19:	add    %rdx,%r10
 1083f1c:	cmpb   $0x4f,0x2(%r9,%r10,1)
 1083f22:	sete   %bl
 1083f25:	or     %r8b,%bl
 1083f28:	mov    %bl,0x4b(%r12)
 1083f2d:	mov    0x10(%rbp),%r8
 1083f31:	add    %rdx,%r8
 1083f34:	cmpb   $0x37,0x3(%r9,%r8,1)
 1083f3a:	sete   %r10b
 1083f3e:	or     %dil,%r10b
 1083f41:	mov    %r10b,0x49(%r12)
 1083f46:	mov    0x10(%rbp),%rdi
 1083f4a:	add    %rdx,%rdi
 1083f4d:	cmpb   $0x3a,0x3(%r9,%rdi,1)
 1083f53:	sete   %r8b
 1083f57:	or     %r11b,%r8b
 1083f5a:	mov    %r8b,0x4a(%r12)
 1083f5f:	mov    0x10(%rbp),%rdi
 1083f63:	add    %rdx,%rdi
 1083f66:	cmpb   $0x4f,0x3(%r9,%rdi,1)
 1083f6c:	sete   %dil
 1083f70:	add    $0x4,%r9
 1083f74:	or     %bl,%dil
 1083f77:	mov    %dil,0x4b(%r12)
 1083f7c:	cmp    %r9d,%ecx
 1083f7f:	jne    1083e50 <check_input_resolve_range+0x17b0>
 1083f85:	mov    0x8(%rsp),%rbx
 1083f8a:	mov    0x30(%rsp),%r11
 1083f8f:	test   %esi,%esi
 1083f91:	je     1083fe0 <check_input_resolve_range+0x1940>
 1083f93:	add    %r9,%rdx
 1083f96:	cs nopw 0x0(%rax,%rax,1)
 1083fa0:	mov    0x10(%rbp),%rcx
 1083fa4:	cmpb   $0x37,(%rcx,%rdx,1)
 1083fa8:	sete   %cl
 1083fab:	or     %cl,%r10b
 1083fae:	mov    %r10b,0x49(%r12)
 1083fb3:	mov    0x10(%rbp),%rcx
 1083fb7:	cmpb   $0x3a,(%rcx,%rdx,1)
 1083fbb:	sete   %cl
 1083fbe:	or     %cl,%r8b
 1083fc1:	mov    %r8b,0x4a(%r12)
 1083fc6:	mov    0x10(%rbp),%rcx
 1083fca:	cmpb   $0x4f,(%rcx,%rdx,1)
 1083fce:	sete   %cl
 1083fd1:	inc    %rdx
 1083fd4:	or     %cl,%dil
 1083fd7:	dec    %esi
 1083fd9:	mov    %dil,0x4b(%r12)
 1083fde:	jne    1083fa0 <check_input_resolve_range+0x1900>
 1083fe0:	inc    %r15d
 1083fe3:	cmp    %eax,%r13d
 1083fe6:	jae    1084123 <check_input_resolve_range+0x1a83>
 1083fec:	mov    0x28(%rsp),%rcx
 1083ff1:	mov    %eax,%edx
 1083ff3:	sub    %ecx,%edx
 1083ff5:	and    $0x7,%edx
 1083ff8:	je     1084021 <check_input_resolve_range+0x1981>
 1083ffa:	mov    0x28(%rsp),%rcx
 1083fff:	nop
 1084000:	mov    0x138(%rbx),%rsi
 1084007:	movb   $0x1,(%rsi,%rcx,1)
 108400b:	mov    (%rbx),%rsi
 108400e:	mov    0x348(%rsi),%rsi
 1084015:	mov    %r15d,(%rsi,%rcx,4)
 1084019:	inc    %rcx
 108401c:	dec    %rdx
 108401f:	jne    1084000 <check_input_resolve_range+0x1960>
 1084021:	mov    0x28(%rsp),%rdx
 1084026:	mov    %eax,%eax
 1084028:	sub    %rax,%rdx
 108402b:	cmp    $0xfffffffffffffff8,%rdx
 108402f:	ja     1084123 <check_input_resolve_range+0x1a83>
 1084035:	data16 cs nopw 0x0(%rax,%rax,1)
 1084040:	mov    0x138(%rbx),%rdx
 1084047:	movb   $0x1,(%rdx,%rcx,1)
 108404b:	mov    (%rbx),%rdx
 108404e:	mov    0x348(%rdx),%rdx
 1084055:	mov    %r15d,(%rdx,%rcx,4)
 1084059:	mov    0x138(%rbx),%rdx
 1084060:	movb   $0x1,0x1(%rdx,%rcx,1)
 1084065:	mov    (%rbx),%rdx
 1084068:	mov    0x348(%rdx),%rdx
 108406f:	mov    %r15d,0x4(%rdx,%rcx,4)
 1084074:	mov    0x138(%rbx),%rdx
 108407b:	movb   $0x1,0x2(%rdx,%rcx,1)
 1084080:	mov    (%rbx),%rdx
 1084083:	mov    0x348(%rdx),%rdx
 108408a:	mov    %r15d,0x8(%rdx,%rcx,4)
 108408f:	mov    0x138(%rbx),%rdx
 1084096:	movb   $0x1,0x3(%rdx,%rcx,1)
 108409b:	mov    (%rbx),%rdx
 108409e:	mov    0x348(%rdx),%rdx
 10840a5:	mov    %r15d,0xc(%rdx,%rcx,4)
 10840aa:	mov    0x138(%rbx),%rdx
 10840b1:	movb   $0x1,0x4(%rdx,%rcx,1)
 10840b6:	mov    (%rbx),%rdx
 10840b9:	mov    0x348(%rdx),%rdx
 10840c0:	mov    %r15d,0x10(%rdx,%rcx,4)
 10840c5:	mov    0x138(%rbx),%rdx
 10840cc:	movb   $0x1,0x5(%rdx,%rcx,1)
 10840d1:	mov    (%rbx),%rdx
 10840d4:	mov    0x348(%rdx),%rdx
 10840db:	mov    %r15d,0x14(%rdx,%rcx,4)
 10840e0:	mov    0x138(%rbx),%rdx
 10840e7:	movb   $0x1,0x6(%rdx,%rcx,1)
 10840ec:	mov    (%rbx),%rdx
 10840ef:	mov    0x348(%rdx),%rdx
 10840f6:	mov    %r15d,0x18(%rdx,%rcx,4)
 10840fb:	mov    0x138(%rbx),%rdx
 1084102:	movb   $0x1,0x7(%rdx,%rcx,1)
 1084107:	mov    (%rbx),%rdx
 108410a:	mov    0x348(%rdx),%rdx
 1084111:	mov    %r15d,0x1c(%rdx,%rcx,4)
 1084116:	add    $0x8,%rcx
 108411a:	cmp    %rcx,%rax
 108411d:	jne    1084040 <check_input_resolve_range+0x19a0>
 1084123:	cmp    $0xfffffffd,%r11d
 1084127:	ja     108416d <check_input_resolve_range+0x1acd>
 1084129:	mov    0x138(%rbx),%rdx
 1084130:	mov    %r11d,%eax
 1084133:	lea    0x2(%r11),%ecx
 1084137:	lea    0x1(%rax),%rsi
 108413b:	movb   $0x1,(%rdx,%rax,1)
 108413f:	mov    (%rbx),%rdx
 1084142:	mov    0x348(%rdx),%rdx
 1084149:	mov    %r15d,(%rdx,%rax,4)
 108414d:	cmp    %rcx,%rsi
 1084150:	je     108416d <check_input_resolve_range+0x1acd>
 1084152:	mov    0x138(%rbx),%rcx
 1084159:	movb   $0x1,0x1(%rcx,%rax,1)
 108415e:	mov    (%rbx),%rcx
 1084161:	mov    0x348(%rcx),%rcx
 1084168:	mov    %r15d,0x4(%rcx,%rax,4)
 108416d:	lea    0x130(%rsp),%rsi
 1084175:	mov    %rbx,%rdi
 1084178:	mov    %r11d,%edx
 108417b:	mov    %r15d,%ecx
 108417e:	mov    %r12,%r8
 1084181:	vzeroupper
 1084184:	call   10e9c70 <check_input_asm_text>
 1084189:	mov    0x30(%rsp),%r11
 108418e:	mov    0x130(%rsp),%ecx
 1084195:	mov    %r11d,%edx
 1084198:	sub    %ecx,%edx
 108419a:	setne  %sil
 108419e:	and    %al,%sil
 10841a1:	cmp    $0x1,%sil
 10841a5:	jne    1084224 <check_input_resolve_range+0x1b84>
 10841a7:	mov    0x28(%rbx),%rax
 10841ab:	vpbroadcastq -0xad7de5(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10841b5:	vpbroadcastd -0xad85de(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10841be:	vpbroadcastq -0xad7de8(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10841c8:	vpbroadcastd -0xad85f2(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10841d2:	vpbroadcastq -0xad7e04(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10841dc:	mov    %rdx,%r8
 10841df:	shl    $0x4,%r8
 10841e3:	mov    (%rax),%rsi
 10841e6:	mov    0x8(%rax),%rdi
 10841ea:	lea    0x7(%rdi,%rsi,1),%r10
 10841ef:	add    %rsi,%rdi
 10841f2:	and    $0xfffffffffffffff8,%r10
 10841f6:	mov    %r10,%r9
 10841f9:	sub    %rsi,%r9
 10841fc:	mov    %r10,0x70(%rsp)
 1084201:	cmp    %rdi,%r10
 1084204:	jae    108427a <check_input_resolve_range+0x1bda>
 1084206:	movq   $0x0,0x58(%rsp)
 108420f:	mov    0x30(%rsp),%r11
 1084214:	cmp    %rdi,0x70(%rsp)
 1084219:	jb     10842fe <check_input_resolve_range+0x1c5e>
 108421f:	jmp    10842cc <check_input_resolve_range+0x1c2c>
 1084224:	vpbroadcastq -0xad7e5e(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108422e:	vpbroadcastd -0xad8657(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084237:	vpbroadcastq -0xad7e61(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1084241:	vpbroadcastd -0xad866b(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108424b:	vpbroadcastq -0xad7e7d(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1084255:	movq   $0x0,0x90(%rsp)
 1084261:	movq   $0x0,0x58(%rsp)
 108426a:	movq   $0x0,0x70(%rsp)
 1084273:	xor    %edx,%edx
 1084275:	jmp    1084380 <check_input_resolve_range+0x1ce0>
 108427a:	mov    0x10(%rax),%r10
 108427e:	sub    %r9,%r10
 1084281:	jb     1084206 <check_input_resolve_range+0x1b66>
 1084283:	lea    (%r8,%r8,2),%r11
 1084287:	cmp    %r10,%r11
 108428a:	ja     1084206 <check_input_resolve_range+0x1b66>
 1084290:	add    %r11,%r9
 1084293:	mov    0x70(%rsp),%rsi
 1084298:	mov    %r9,0x8(%rax)
 108429c:	mov    0x28(%rbx),%rax
 10842a0:	mov    %rsi,0x58(%rsp)
 10842a5:	mov    (%rax),%rsi
 10842a8:	mov    0x8(%rax),%rdi
 10842ac:	lea    0x7(%rdi,%rsi,1),%r9
 10842b1:	add    %rsi,%rdi
 10842b4:	and    $0xfffffffffffffff8,%r9
 10842b8:	mov    %r9,0x70(%rsp)
 10842bd:	sub    %rsi,%r9
 10842c0:	mov    0x30(%rsp),%r11
 10842c5:	cmp    %rdi,0x70(%rsp)
 10842ca:	jb     10842fe <check_input_resolve_range+0x1c5e>
 10842cc:	mov    0x10(%rax),%r10
 10842d0:	sub    %r9,%r10
 10842d3:	jb     10842fe <check_input_resolve_range+0x1c5e>
 10842d5:	cmp    %r10,%r8
 10842d8:	ja     10842fe <check_input_resolve_range+0x1c5e>
 10842da:	add    %r8,%r9
 10842dd:	mov    %r9,0x8(%rax)
 10842e1:	mov    0x28(%rbx),%rax
 10842e5:	mov    (%rax),%rsi
 10842e8:	mov    0x8(%rax),%rdi
 10842ec:	add    %rsi,%rdi
 10842ef:	lea    0x3(%rdi),%r8
 10842f3:	and    $0xfffffffffffffffc,%r8
 10842f7:	cmp    %rdi,%r8
 10842fa:	jb     108434f <check_input_resolve_range+0x1caf>
 10842fc:	jmp    1084314 <check_input_resolve_range+0x1c74>
 10842fe:	movq   $0x0,0x70(%rsp)
 1084307:	lea    0x3(%rdi),%r8
 108430b:	and    $0xfffffffffffffffc,%r8
 108430f:	cmp    %rdi,%r8
 1084312:	jb     108434f <check_input_resolve_range+0x1caf>
 1084314:	mov    %r8,%rdi
 1084317:	sub    %rsi,%rdi
 108431a:	mov    0x10(%rax),%rsi
 108431e:	sub    %rdi,%rsi
 1084321:	jb     108434f <check_input_resolve_range+0x1caf>
 1084323:	shl    $0x2,%rdx
 1084327:	mov    $0x0,%r9d
 108432d:	lea    (%rdx,%rdx,2),%rdx
 1084331:	mov    %r9,0x90(%rsp)
 1084339:	cmp    %rsi,%rdx
 108433c:	ja     108435b <check_input_resolve_range+0x1cbb>
 108433e:	add    %rdx,%rdi
 1084341:	mov    %r8,0x90(%rsp)
 1084349:	mov    %rdi,0x8(%rax)
 108434d:	jmp    108435b <check_input_resolve_range+0x1cbb>
 108434f:	movq   $0x0,0x90(%rsp)
 108435b:	cmpq   $0x0,0x58(%rsp)
 1084361:	mov    $0x1,%edx
 1084366:	mov    $0x1,%al
 1084368:	je     1084380 <check_input_resolve_range+0x1ce0>
 108436a:	cmpq   $0x0,0x70(%rsp)
 1084370:	je     1084380 <check_input_resolve_range+0x1ce0>
 1084372:	xor    %edx,%edx
 1084374:	cmpq   $0x0,0x90(%rsp)
 108437d:	sete   %dl
 1084380:	movzbl 0x3bd(%r14),%esi
 1084388:	mov    %r12,0x10(%rsp)
 108438d:	mov    %r14,0xf0(%rsp)
 1084395:	or     %edx,%esi
 1084397:	sete   %dl
 108439a:	mov    %sil,0x3bd(%r14)
 10843a1:	and    %al,%dl
 10843a3:	cmp    %r11d,%ecx
 10843a6:	setb   %r9b
 10843aa:	and    %dl,%r9b
 10843ad:	cmp    $0x1,%r9b
 10843b1:	jne    1084eb2 <check_input_resolve_range+0x2812>
 10843b7:	mov    0x10(%rbp),%rdx
 10843bb:	mov    %ecx,%eax
 10843bd:	mov    %r13d,0x24(%rsp)
 10843c2:	cmpb   $0x2f,(%rdx,%rax,1)
 10843c6:	jne    1086420 <check_input_resolve_range+0x3d80>
 10843cc:	xor    %esi,%esi
 10843ce:	mov    %r13d,0x24(%rsp)
 10843d3:	mov    %r9b,0x18(%rsp)
 10843d8:	lea    0x1(%rcx),%r13d
 10843dc:	mov    %esi,%edx
 10843de:	mov    %rax,%rsi
 10843e1:	mov    %r13d,%edi
 10843e4:	sub    %eax,%edi
 10843e6:	and    $0x7,%edi
 10843e9:	je     1084412 <check_input_resolve_range+0x1d72>
 10843eb:	mov    %rax,%rsi
 10843ee:	xchg   %ax,%ax
 10843f0:	mov    0x138(%rbx),%r8
 10843f7:	movb   $0x1,(%r8,%rsi,1)
 10843fc:	mov    (%rbx),%r8
 10843ff:	mov    0x348(%r8),%r8
 1084406:	mov    %r15d,(%r8,%rsi,4)
 108440a:	inc    %rsi
 108440d:	dec    %rdi
 1084410:	jne    10843f0 <check_input_resolve_range+0x1d50>
 1084412:	mov    %ecx,%ecx
 1084414:	sub    %rax,%rcx
 1084417:	cmp    $0x7,%rcx
 108441b:	jb     1084513 <check_input_resolve_range+0x1e73>
 1084421:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1084430:	mov    0x138(%rbx),%rax
 1084437:	movb   $0x1,(%rax,%rsi,1)
 108443b:	mov    (%rbx),%rax
 108443e:	mov    0x348(%rax),%rax
 1084445:	mov    %r15d,(%rax,%rsi,4)
 1084449:	mov    0x138(%rbx),%rax
 1084450:	movb   $0x1,0x1(%rax,%rsi,1)
 1084455:	mov    (%rbx),%rax
 1084458:	mov    0x348(%rax),%rax
 108445f:	mov    %r15d,0x4(%rax,%rsi,4)
 1084464:	mov    0x138(%rbx),%rax
 108446b:	movb   $0x1,0x2(%rax,%rsi,1)
 1084470:	mov    (%rbx),%rax
 1084473:	mov    0x348(%rax),%rax
 108447a:	mov    %r15d,0x8(%rax,%rsi,4)
 108447f:	mov    0x138(%rbx),%rax
 1084486:	movb   $0x1,0x3(%rax,%rsi,1)
 108448b:	mov    (%rbx),%rax
 108448e:	mov    0x348(%rax),%rax
 1084495:	mov    %r15d,0xc(%rax,%rsi,4)
 108449a:	mov    0x138(%rbx),%rax
 10844a1:	movb   $0x1,0x4(%rax,%rsi,1)
 10844a6:	mov    (%rbx),%rax
 10844a9:	mov    0x348(%rax),%rax
 10844b0:	mov    %r15d,0x10(%rax,%rsi,4)
 10844b5:	mov    0x138(%rbx),%rax
 10844bc:	movb   $0x1,0x5(%rax,%rsi,1)
 10844c1:	mov    (%rbx),%rax
 10844c4:	mov    0x348(%rax),%rax
 10844cb:	mov    %r15d,0x14(%rax,%rsi,4)
 10844d0:	mov    0x138(%rbx),%rax
 10844d7:	movb   $0x1,0x6(%rax,%rsi,1)
 10844dc:	mov    (%rbx),%rax
 10844df:	mov    0x348(%rax),%rax
 10844e6:	mov    %r15d,0x18(%rax,%rsi,4)
 10844eb:	mov    0x138(%rbx),%rax
 10844f2:	movb   $0x1,0x7(%rax,%rsi,1)
 10844f7:	mov    (%rbx),%rax
 10844fa:	mov    0x348(%rax),%rax
 1084501:	mov    %r15d,0x1c(%rax,%rsi,4)
 1084506:	add    $0x8,%rsi
 108450a:	cmp    %rsi,%r13
 108450d:	jne    1084430 <check_input_resolve_range+0x1d90>
 1084513:	lea    0x1(%rdx),%esi
 1084516:	xor    %eax,%eax
 1084518:	mov    %r13d,0x130(%rsp)
 1084520:	cmp    $0x2,%esi
 1084523:	sete   %cl
 1084526:	cmp    %r11d,%r13d
 1084529:	jae    10863f3 <check_input_resolve_range+0x3d53>
 108452f:	mov    %esi,0x40(%rsp)
 1084533:	cmp    $0x1,%edx
 1084536:	ja     1084910 <check_input_resolve_range+0x2270>
 108453c:	mov    0x10(%rsp),%r12
 1084541:	xor    $0x1,%edx
 1084544:	mov    %cl,%al
 1084546:	mov    $0x1,%cl
 1084548:	vmovd  %edx,%xmm0
 108454c:	vpinsrd $0x1,%eax,%xmm0,%xmm0
 1084552:	vmovdqa %xmm0,0x60(%rsp)
 1084558:	jmp    108458e <check_input_resolve_range+0x1eee>
 108455a:	nopw   0x0(%rax,%rax,1)
 1084560:	mov    0x1c(%r14),%r13d
 1084564:	inc    %r13d
 1084567:	mov    %r13d,0x130(%rsp)
 108456f:	xor    %ecx,%ecx
 1084571:	vmovq  0x28(%r12),%xmm0
 1084578:	vpaddd 0x60(%rsp),%xmm0,%xmm0
 108457e:	vmovq  %xmm0,0x28(%r12)
 1084585:	cmp    %r11d,%r13d
 1084588:	jae    1085c27 <check_input_resolve_range+0x3587>
 108458e:	mov    0x10(%rbp),%rdx
 1084592:	mov    %r13d,%eax
 1084595:	movzbl (%rdx,%rax,1),%edx
 1084599:	cmp    $0x2f,%dl
 108459c:	je     108492c <check_input_resolve_range+0x228c>
 10845a2:	test   $0x1,%cl
 10845a5:	jne    10845d4 <check_input_resolve_range+0x1f34>
 10845a7:	cmp    $0x33,%dl
 10845aa:	jne    1086269 <check_input_resolve_range+0x3bc9>
 10845b0:	mov    0x138(%rbx),%rcx
 10845b7:	inc    %r13d
 10845ba:	movb   $0x1,(%rcx,%rax,1)
 10845be:	mov    (%rbx),%rcx
 10845c1:	mov    0x348(%rcx),%rcx
 10845c8:	mov    %r15d,(%rcx,%rax,4)
 10845cc:	mov    %r13d,0x130(%rsp)
 10845d4:	mov    0x2c(%r12),%eax
 10845d9:	mov    0x58(%rsp),%rcx
 10845de:	vpxor  %xmm0,%xmm0,%xmm0
 10845e2:	add    0x28(%r12),%eax
 10845e7:	lea    (%rax,%rax,2),%rax
 10845eb:	shl    $0x4,%rax
 10845ef:	vmovdqu %xmm0,(%rcx,%rax,1)
 10845f4:	movl   $0x0,0x10(%rcx,%rax,1)
 10845fc:	mov    %r13d,0x14(%rcx,%rax,1)
 1084601:	movq   $0x0,0x18(%rcx,%rax,1)
 108460a:	movq   $0xffffffffffffffff,0x20(%rcx,%rax,1)
 1084613:	movq   $0x0,0x28(%rcx,%rax,1)
 108461c:	lea    (%rcx,%rax,1),%r14
 1084620:	mov    (%rsp),%r13
 1084624:	mov    0x130(%rsp),%ecx
 108462b:	cmp    %r11d,%ecx
 108462e:	jae    10846f0 <check_input_resolve_range+0x2050>
 1084634:	mov    0x10(%rbp),%rax
 1084638:	cmpb   $0x6,(%rax,%rcx,1)
 108463c:	jne    10846f0 <check_input_resolve_range+0x2050>
 1084642:	lea    0x2(%rcx),%edx
 1084645:	cmp    %r11d,%edx
 1084648:	jae    108474b <check_input_resolve_range+0x20ab>
 108464e:	cmpb   $0x2,0x1(%rcx,%rax,1)
 1084653:	jne    108474b <check_input_resolve_range+0x20ab>
 1084659:	mov    %edx,%edx
 108465b:	cmpb   $0x7,(%rax,%rdx,1)
 108465f:	jne    108474b <check_input_resolve_range+0x20ab>
 1084665:	mov    0x18(%rbp),%rax
 1084669:	mov    0x4(%rax,%rcx,4),%eax
 108466d:	mov    %eax,0x10(%r14)
 1084671:	mov    0x130(%rsp),%eax
 1084678:	mov    %eax,%ecx
 108467a:	sub    $0xfffffffd,%ecx
 108467d:	jae    10846e2 <check_input_resolve_range+0x2042>
 108467f:	mov    0x138(%rbx),%rsi
 1084686:	lea    0x1(%rax),%rdi
 108468a:	mov    %ecx,%edx
 108468c:	movb   $0x1,(%rsi,%rax,1)
 1084690:	mov    (%rbx),%rsi
 1084693:	mov    0x348(%rsi),%rsi
 108469a:	mov    %r15d,(%rsi,%rax,4)
 108469e:	cmp    %rdx,%rdi
 10846a1:	je     10846e2 <check_input_resolve_range+0x2042>
 10846a3:	mov    0x138(%rbx),%rsi
 10846aa:	lea    0x2(%rax),%rdi
 10846ae:	movb   $0x1,0x1(%rsi,%rax,1)
 10846b3:	mov    (%rbx),%rsi
 10846b6:	mov    0x348(%rsi),%rsi
 10846bd:	mov    %r15d,0x4(%rsi,%rax,4)
 10846c2:	cmp    %rdx,%rdi
 10846c5:	je     10846e2 <check_input_resolve_range+0x2042>
 10846c7:	mov    0x138(%rbx),%rdx
 10846ce:	movb   $0x1,0x2(%rdx,%rax,1)
 10846d3:	mov    (%rbx),%rdx
 10846d6:	mov    0x348(%rdx),%rdx
 10846dd:	mov    %r15d,0x8(%rdx,%rax,4)
 10846e2:	mov    %ecx,0x130(%rsp)
 10846e9:	nopl   0x0(%rax)
 10846f0:	lea    0x130(%rsp),%rsi
 10846f8:	mov    %rbx,%rdi
 10846fb:	mov    %r11d,%edx
 10846fe:	mov    %r15d,%ecx
 1084701:	mov    %r14,%r8
 1084704:	vzeroupper
 1084707:	call   10e9c70 <check_input_asm_text>
 108470c:	vpbroadcastq -0xad833e(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1084716:	vpbroadcastd -0xad8b40(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084720:	vpbroadcastq -0xad834a(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 108472a:	vpbroadcastd -0xad8b53(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084733:	vpbroadcastq -0xad836d(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108473d:	mov    0x30(%rsp),%r11
 1084742:	mov    0x130(%rsp),%ecx
 1084749:	jmp    108474d <check_input_resolve_range+0x20ad>
 108474b:	xor    %eax,%eax
 108474d:	mov    %ecx,0x18(%r14)
 1084751:	mov    $0xffffffff,%ecx
 1084756:	mov    0x130(%rsp),%edx
 108475d:	cmp    %r11d,%edx
 1084760:	jae    1084769 <check_input_resolve_range+0x20c9>
 1084762:	mov    0x60(%rbp),%rcx
 1084766:	mov    (%rcx,%rdx,4),%ecx
 1084769:	mov    %ecx,0x1c(%r14)
 108476d:	test   %al,%al
 108476f:	je     1086420 <check_input_resolve_range+0x3d80>
 1084775:	mov    0x130(%rsp),%eax
 108477c:	cmp    %r11d,%eax
 108477f:	jae    1086420 <check_input_resolve_range+0x3d80>
 1084785:	mov    0x10(%rbp),%rdx
 1084789:	cmpb   $0x8,(%rdx,%rax,1)
 108478d:	jne    1086420 <check_input_resolve_range+0x3d80>
 1084793:	cmp    %r11d,%ecx
 1084796:	jae    1086420 <check_input_resolve_range+0x3d80>
 108479c:	lea    0x1(%rax),%edx
 108479f:	cmp    %edx,%ecx
 10847a1:	jbe    1086420 <check_input_resolve_range+0x3d80>
 10847a7:	mov    0x138(%rbx),%rcx
 10847ae:	movb   $0x1,(%rcx,%rax,1)
 10847b2:	mov    (%rbx),%rcx
 10847b5:	mov    0x348(%rcx),%rcx
 10847bc:	mov    %r15d,(%rcx,%rax,4)
 10847c0:	mov    $0xffffffff,%ecx
 10847c5:	mov    0x1c(%r14),%eax
 10847c9:	cmp    %rcx,%rax
 10847cc:	je     1084908 <check_input_resolve_range+0x2268>
 10847d2:	lea    0x1(%rax),%rcx
 10847d6:	mov    %ecx,%edx
 10847d8:	sub    %eax,%edx
 10847da:	test   $0x7,%dl
 10847dd:	je     1084811 <check_input_resolve_range+0x2171>
 10847df:	mov    $0x1,%edx
 10847e4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 10847f0:	mov    0x138(%rbx),%rsi
 10847f7:	movb   $0x1,(%rsi,%rax,1)
 10847fb:	mov    (%rbx),%rsi
 10847fe:	mov    0x348(%rsi),%rsi
 1084805:	mov    %r15d,(%rsi,%rax,4)
 1084809:	inc    %rax
 108480c:	dec    %rdx
 108480f:	jne    10847f0 <check_input_resolve_range+0x2150>
 1084811:	mov    $0x1,%dl
 1084813:	test   %dl,%dl
 1084815:	jne    1084560 <check_input_resolve_range+0x1ec0>
 108481b:	nopl   0x0(%rax,%rax,1)
 1084820:	mov    0x138(%rbx),%rdx
 1084827:	movb   $0x1,(%rdx,%rax,1)
 108482b:	mov    (%rbx),%rdx
 108482e:	mov    0x348(%rdx),%rdx
 1084835:	mov    %r15d,(%rdx,%rax,4)
 1084839:	mov    0x138(%rbx),%rdx
 1084840:	movb   $0x1,0x1(%rdx,%rax,1)
 1084845:	mov    (%rbx),%rdx
 1084848:	mov    0x348(%rdx),%rdx
 108484f:	mov    %r15d,0x4(%rdx,%rax,4)
 1084854:	mov    0x138(%rbx),%rdx
 108485b:	movb   $0x1,0x2(%rdx,%rax,1)
 1084860:	mov    (%rbx),%rdx
 1084863:	mov    0x348(%rdx),%rdx
 108486a:	mov    %r15d,0x8(%rdx,%rax,4)
 108486f:	mov    0x138(%rbx),%rdx
 1084876:	movb   $0x1,0x3(%rdx,%rax,1)
 108487b:	mov    (%rbx),%rdx
 108487e:	mov    0x348(%rdx),%rdx
 1084885:	mov    %r15d,0xc(%rdx,%rax,4)
 108488a:	mov    0x138(%rbx),%rdx
 1084891:	movb   $0x1,0x4(%rdx,%rax,1)
 1084896:	mov    (%rbx),%rdx
 1084899:	mov    0x348(%rdx),%rdx
 10848a0:	mov    %r15d,0x10(%rdx,%rax,4)
 10848a5:	mov    0x138(%rbx),%rdx
 10848ac:	movb   $0x1,0x5(%rdx,%rax,1)
 10848b1:	mov    (%rbx),%rdx
 10848b4:	mov    0x348(%rdx),%rdx
 10848bb:	mov    %r15d,0x14(%rdx,%rax,4)
 10848c0:	mov    0x138(%rbx),%rdx
 10848c7:	movb   $0x1,0x6(%rdx,%rax,1)
 10848cc:	mov    (%rbx),%rdx
 10848cf:	mov    0x348(%rdx),%rdx
 10848d6:	mov    %r15d,0x18(%rdx,%rax,4)
 10848db:	mov    0x138(%rbx),%rdx
 10848e2:	movb   $0x1,0x7(%rdx,%rax,1)
 10848e7:	mov    (%rbx),%rdx
 10848ea:	mov    0x348(%rdx),%rdx
 10848f1:	mov    %r15d,0x1c(%rdx,%rax,4)
 10848f6:	add    $0x8,%rax
 10848fa:	cmp    %rax,%rcx
 10848fd:	jne    1084820 <check_input_resolve_range+0x2180>
 1084903:	jmp    1084560 <check_input_resolve_range+0x1ec0>
 1084908:	xor    %r13d,%r13d
 108490b:	jmp    1084567 <check_input_resolve_range+0x1ec7>
 1084910:	mov    0x10(%rsp),%r12
 1084915:	cmp    $0x3,%esi
 1084918:	jne    1084953 <check_input_resolve_range+0x22b3>
 108491a:	mov    0x10(%rbp),%rax
 108491e:	cmpb   $0x2f,(%rax,%r13,1)
 1084923:	jne    1084b58 <check_input_resolve_range+0x24b8>
 1084929:	mov    %r13,%rax
 108492c:	mov    %r13d,%ecx
 108492f:	mov    (%rsp),%r13
 1084933:	movzbl 0x4b(%r12),%edx
 1084939:	mov    0x40(%rsp),%esi
 108493d:	movzbl 0x18(%rsp),%r9d
 1084943:	add    $0x3,%edx
 1084946:	cmp    %edx,%esi
 1084948:	jb     10843d8 <check_input_resolve_range+0x1d38>
 108494e:	jmp    1086420 <check_input_resolve_range+0x3d80>
 1084953:	mov    $0x1,%cl
 1084955:	jmp    1084973 <check_input_resolve_range+0x22d3>
 1084957:	nopw   0x0(%rax,%rax,1)
 1084960:	mov    %r13d,0x130(%rsp)
 1084968:	xor    %ecx,%ecx
 108496a:	cmp    %r11d,%r13d
 108496d:	jae    1085c27 <check_input_resolve_range+0x3587>
 1084973:	mov    0x10(%rbp),%rdx
 1084977:	mov    %r13d,%eax
 108497a:	movzbl (%rdx,%rax,1),%edx
 108497e:	cmp    $0x2f,%dl
 1084981:	je     108492c <check_input_resolve_range+0x228c>
 1084983:	test   $0x1,%cl
 1084986:	jne    10849b5 <check_input_resolve_range+0x2315>
 1084988:	cmp    $0x33,%dl
 108498b:	jne    1086269 <check_input_resolve_range+0x3bc9>
 1084991:	mov    0x138(%rbx),%rcx
 1084998:	inc    %r13d
 108499b:	movb   $0x1,(%rcx,%rax,1)
 108499f:	mov    (%rbx),%rcx
 10849a2:	mov    0x348(%rcx),%rcx
 10849a9:	mov    %r15d,(%rcx,%rax,4)
 10849ad:	mov    %r13d,0x130(%rsp)
 10849b5:	cmp    %r11d,%r13d
 10849b8:	jae    1086269 <check_input_resolve_range+0x3bc9>
 10849be:	mov    0x10(%rbp),%rcx
 10849c2:	mov    %r13d,%eax
 10849c5:	cmpb   $0x2,(%rcx,%rax,1)
 10849c9:	jne    1086269 <check_input_resolve_range+0x3bc9>
 10849cf:	mov    0x34(%r12),%ecx
 10849d4:	mov    0x90(%rsp),%rsi
 10849dc:	lea    0x1(%rcx),%edx
 10849df:	lea    (%rcx,%rcx,2),%rcx
 10849e3:	mov    %edx,0x34(%r12)
 10849e8:	mov    0x18(%rbp),%rdx
 10849ec:	mov    (%rdx,%rax,4),%eax
 10849ef:	mov    %eax,(%rsi,%rcx,4)
 10849f2:	mov    %r13d,0x4(%rsi,%rcx,4)
 10849f7:	movl   $0xffffffff,0x8(%rsi,%rcx,4)
 10849ff:	mov    0x130(%rsp),%edx
 1084a06:	mov    %edx,%r13d
 1084a09:	inc    %r13d
 1084a0c:	je     1084960 <check_input_resolve_range+0x22c0>
 1084a12:	mov    %r13d,%ecx
 1084a15:	sub    %edx,%ecx
 1084a17:	mov    %rdx,%rax
 1084a1a:	test   $0x7,%cl
 1084a1d:	je     1084a51 <check_input_resolve_range+0x23b1>
 1084a1f:	mov    $0x1,%ecx
 1084a24:	mov    %rdx,%rax
 1084a27:	nopw   0x0(%rax,%rax,1)
 1084a30:	mov    0x138(%rbx),%rsi
 1084a37:	movb   $0x1,(%rsi,%rax,1)
 1084a3b:	mov    (%rbx),%rsi
 1084a3e:	mov    0x348(%rsi),%rsi
 1084a45:	mov    %r15d,(%rsi,%rax,4)
 1084a49:	inc    %rax
 1084a4c:	dec    %rcx
 1084a4f:	jne    1084a30 <check_input_resolve_range+0x2390>
 1084a51:	mov    %r13d,%ecx
 1084a54:	sub    %rcx,%rdx
 1084a57:	cmp    $0xfffffffffffffff8,%rdx
 1084a5b:	ja     1084960 <check_input_resolve_range+0x22c0>
 1084a61:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1084a70:	mov    0x138(%rbx),%rdx
 1084a77:	movb   $0x1,(%rdx,%rax,1)
 1084a7b:	mov    (%rbx),%rdx
 1084a7e:	mov    0x348(%rdx),%rdx
 1084a85:	mov    %r15d,(%rdx,%rax,4)
 1084a89:	mov    0x138(%rbx),%rdx
 1084a90:	movb   $0x1,0x1(%rdx,%rax,1)
 1084a95:	mov    (%rbx),%rdx
 1084a98:	mov    0x348(%rdx),%rdx
 1084a9f:	mov    %r15d,0x4(%rdx,%rax,4)
 1084aa4:	mov    0x138(%rbx),%rdx
 1084aab:	movb   $0x1,0x2(%rdx,%rax,1)
 1084ab0:	mov    (%rbx),%rdx
 1084ab3:	mov    0x348(%rdx),%rdx
 1084aba:	mov    %r15d,0x8(%rdx,%rax,4)
 1084abf:	mov    0x138(%rbx),%rdx
 1084ac6:	movb   $0x1,0x3(%rdx,%rax,1)
 1084acb:	mov    (%rbx),%rdx
 1084ace:	mov    0x348(%rdx),%rdx
 1084ad5:	mov    %r15d,0xc(%rdx,%rax,4)
 1084ada:	mov    0x138(%rbx),%rdx
 1084ae1:	movb   $0x1,0x4(%rdx,%rax,1)
 1084ae6:	mov    (%rbx),%rdx
 1084ae9:	mov    0x348(%rdx),%rdx
 1084af0:	mov    %r15d,0x10(%rdx,%rax,4)
 1084af5:	mov    0x138(%rbx),%rdx
 1084afc:	movb   $0x1,0x5(%rdx,%rax,1)
 1084b01:	mov    (%rbx),%rdx
 1084b04:	mov    0x348(%rdx),%rdx
 1084b0b:	mov    %r15d,0x14(%rdx,%rax,4)
 1084b10:	mov    0x138(%rbx),%rdx
 1084b17:	movb   $0x1,0x6(%rdx,%rax,1)
 1084b1c:	mov    (%rbx),%rdx
 1084b1f:	mov    0x348(%rdx),%rdx
 1084b26:	mov    %r15d,0x18(%rdx,%rax,4)
 1084b2b:	mov    0x138(%rbx),%rdx
 1084b32:	movb   $0x1,0x7(%rdx,%rax,1)
 1084b37:	mov    (%rbx),%rdx
 1084b3a:	mov    0x348(%rdx),%rdx
 1084b41:	mov    %r15d,0x1c(%rdx,%rax,4)
 1084b46:	add    $0x8,%rax
 1084b4a:	cmp    %rax,%rcx
 1084b4d:	jne    1084a70 <check_input_resolve_range+0x23d0>
 1084b53:	jmp    1084960 <check_input_resolve_range+0x22c0>
 1084b58:	mov    0x30(%r12),%r14d
 1084b5d:	lea    0x130(%rsp),%rsi
 1084b65:	mov    %rbx,%rdi
 1084b68:	mov    %r11d,%edx
 1084b6b:	mov    %r15d,%ecx
 1084b6e:	shl    $0x4,%r14
 1084b72:	add    0x70(%rsp),%r14
 1084b77:	mov    %r14,%r8
 1084b7a:	vzeroupper
 1084b7d:	call   10e9c70 <check_input_asm_text>
 1084b82:	test   %al,%al
 1084b84:	je     108640e <check_input_resolve_range+0x3d6e>
 1084b8a:	cmpl   $0x6,0x8(%r14)
 1084b8f:	jne    1084bad <check_input_resolve_range+0x250d>
 1084b91:	mov    (%r14),%rax
 1084b94:	mov    $0x6f6d656d,%edx
 1084b99:	mov    (%rax),%ecx
 1084b9b:	movzwl 0x4(%rax),%eax
 1084b9f:	xor    %edx,%ecx
 1084ba1:	xor    $0x7972,%eax
 1084ba6:	or     %ecx,%eax
 1084ba8:	sete   %al
 1084bab:	jmp    1084baf <check_input_resolve_range+0x250f>
 1084bad:	xor    %eax,%eax
 1084baf:	or     %al,0x4c(%r12)
 1084bb4:	cmpl   $0x2,0x8(%r14)
 1084bb9:	jne    1084bc8 <check_input_resolve_range+0x2528>
 1084bbb:	mov    (%r14),%rax
 1084bbe:	cmpw   $0x6363,(%rax)
 1084bc3:	sete   %al
 1084bc6:	jmp    1084bca <check_input_resolve_range+0x252a>
 1084bc8:	xor    %eax,%eax
 1084bca:	or     %al,0x4d(%r12)
 1084bcf:	xor    %esi,%esi
 1084bd1:	mov    (%r14),%r12
 1084bd4:	mov    0x8(%r14),%edx
 1084bd8:	mov    %r12,%rdi
 1084bdb:	call   787f30 <memchr@plt>
 1084be0:	test   %rax,%rax
 1084be3:	jne    1086406 <check_input_resolve_range+0x3d66>
 1084be9:	mov    0x8(%r14),%r14
 1084bed:	mov    %r14d,%edx
 1084bf0:	cmp    $0x6,%r14d
 1084bf4:	je     1084c08 <check_input_resolve_range+0x2568>
 1084bf6:	cmp    $0x2,%r14d
 1084bfa:	jne    1084c1b <check_input_resolve_range+0x257b>
 1084bfc:	mov    %r12,%rdi
 1084bff:	lea    -0x9d0079(%rip),%rsi        # 6b4b8d <pp_string_value.meaning+0x2c60c>
 1084c06:	jmp    1084c12 <check_input_resolve_range+0x2572>
 1084c08:	lea    -0x9b6584(%rip),%rsi        # 6ce68b <pp_string_value.meaning+0x4610a>
 1084c0f:	mov    %r12,%rdi
 1084c12:	call   7880b0 <bcmp@plt>
 1084c17:	test   %eax,%eax
 1084c19:	je     1084c6e <check_input_resolve_range+0x25ce>
 1084c1b:	mov    %r12,%rdi
 1084c1e:	mov    %r14,%rsi
 1084c21:	call   10ea090 <check_asm_register>
 1084c26:	mov    0x10(%rsp),%rcx
 1084c2b:	vpbroadcastq -0xad8865(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1084c35:	vpbroadcastd -0xad905e(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084c3e:	vpbroadcastq -0xad8868(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1084c48:	vpbroadcastd -0xad9072(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084c52:	vpbroadcastq -0xad8884(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1084c5c:	movzbl 0x18(%rsp),%r9d
 1084c62:	incl   0x30(%rcx)
 1084c65:	test   %al,%al
 1084c67:	jne    1084cad <check_input_resolve_range+0x260d>
 1084c69:	jmp    108640e <check_input_resolve_range+0x3d6e>
 1084c6e:	mov    0x10(%rsp),%rax
 1084c73:	vpbroadcastq -0xad88ad(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1084c7d:	vpbroadcastd -0xad90a6(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084c86:	vpbroadcastq -0xad88b0(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1084c90:	vpbroadcastd -0xad90ba(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084c9a:	vpbroadcastq -0xad88cc(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1084ca4:	movzbl 0x18(%rsp),%r9d
 1084caa:	incl   0x30(%rax)
 1084cad:	mov    0x130(%rsp),%ecx
 1084cb4:	mov    0x30(%rsp),%r11
 1084cb9:	cmp    %r11d,%ecx
 1084cbc:	jae    1088920 <check_input_resolve_range+0x6280>
 1084cc2:	mov    %r13d,0x24(%rsp)
 1084cc7:	mov    (%rsp),%r13
 1084ccb:	jmp    1084d34 <check_input_resolve_range+0x2694>
 1084ccd:	mov    %r12,%rdi
 1084cd0:	mov    %r14,%rsi
 1084cd3:	call   10ea090 <check_asm_register>
 1084cd8:	mov    0x10(%rsp),%rcx
 1084cdd:	vpbroadcastq -0xad8917(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1084ce7:	vpbroadcastd -0xad9110(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084cf0:	vpbroadcastq -0xad891a(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1084cfa:	vpbroadcastd -0xad9124(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084d04:	vpbroadcastq -0xad8936(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1084d0e:	movzbl 0x18(%rsp),%r9d
 1084d14:	incl   0x30(%rcx)
 1084d17:	test   %al,%al
 1084d19:	je     1086420 <check_input_resolve_range+0x3d80>
 1084d1f:	mov    0x130(%rsp),%ecx
 1084d26:	mov    0x30(%rsp),%r11
 1084d2b:	cmp    %r11d,%ecx
 1084d2e:	jae    1084ebf <check_input_resolve_range+0x281f>
 1084d34:	mov    0x10(%rbp),%rdx
 1084d38:	mov    %ecx,%eax
 1084d3a:	movzbl (%rdx,%rax,1),%edx
 1084d3e:	cmp    $0x33,%edx
 1084d41:	jne    1084e9f <check_input_resolve_range+0x27ff>
 1084d47:	mov    0x138(%rbx),%rdx
 1084d4e:	mov    0x10(%rsp),%r12
 1084d53:	lea    0x130(%rsp),%rsi
 1084d5b:	mov    %rbx,%rdi
 1084d5e:	movb   $0x1,(%rdx,%rax,1)
 1084d62:	mov    (%rbx),%rdx
 1084d65:	mov    0x348(%rdx),%rdx
 1084d6c:	mov    %r15d,(%rdx,%rax,4)
 1084d70:	mov    %ecx,%eax
 1084d72:	inc    %eax
 1084d74:	mov    %r11d,%edx
 1084d77:	mov    %r15d,%ecx
 1084d7a:	mov    %eax,0x130(%rsp)
 1084d81:	mov    %eax,0x24(%rsp)
 1084d85:	mov    0x30(%r12),%r14d
 1084d8a:	shl    $0x4,%r14
 1084d8e:	add    0x70(%rsp),%r14
 1084d93:	mov    %r14,%r8
 1084d96:	vzeroupper
 1084d99:	call   10e9c70 <check_input_asm_text>
 1084d9e:	test   %al,%al
 1084da0:	je     1086420 <check_input_resolve_range+0x3d80>
 1084da6:	cmpl   $0x6,0x8(%r14)
 1084dab:	jne    1084dd7 <check_input_resolve_range+0x2737>
 1084dad:	mov    (%r14),%rax
 1084db0:	mov    $0x6f6d656d,%edx
 1084db5:	mov    (%rax),%ecx
 1084db7:	movzwl 0x4(%rax),%eax
 1084dbb:	xor    %edx,%ecx
 1084dbd:	xor    $0x7972,%eax
 1084dc2:	or     %ecx,%eax
 1084dc4:	sete   %al
 1084dc7:	or     %al,0x4c(%r12)
 1084dcc:	cmpl   $0x2,0x8(%r14)
 1084dd1:	je     1084de5 <check_input_resolve_range+0x2745>
 1084dd3:	xor    %eax,%eax
 1084dd5:	jmp    1084df0 <check_input_resolve_range+0x2750>
 1084dd7:	xor    %eax,%eax
 1084dd9:	or     %al,0x4c(%r12)
 1084dde:	cmpl   $0x2,0x8(%r14)
 1084de3:	jne    1084dd3 <check_input_resolve_range+0x2733>
 1084de5:	mov    (%r14),%rax
 1084de8:	cmpw   $0x6363,(%rax)
 1084ded:	sete   %al
 1084df0:	or     %al,0x4d(%r12)
 1084df5:	xor    %esi,%esi
 1084df7:	mov    (%r14),%r12
 1084dfa:	mov    0x8(%r14),%edx
 1084dfe:	mov    %r12,%rdi
 1084e01:	call   787f30 <memchr@plt>
 1084e06:	test   %rax,%rax
 1084e09:	jne    10863ff <check_input_resolve_range+0x3d5f>
 1084e0f:	mov    0x8(%r14),%r14
 1084e13:	mov    %r14d,%edx
 1084e16:	cmp    $0x6,%r14d
 1084e1a:	je     1084e32 <check_input_resolve_range+0x2792>
 1084e1c:	cmp    $0x2,%r14d
 1084e20:	jne    1084ccd <check_input_resolve_range+0x262d>
 1084e26:	mov    %r12,%rdi
 1084e29:	lea    -0x9d02a3(%rip),%rsi        # 6b4b8d <pp_string_value.meaning+0x2c60c>
 1084e30:	jmp    1084e3c <check_input_resolve_range+0x279c>
 1084e32:	lea    -0x9b67ae(%rip),%rsi        # 6ce68b <pp_string_value.meaning+0x4610a>
 1084e39:	mov    %r12,%rdi
 1084e3c:	call   7880b0 <bcmp@plt>
 1084e41:	test   %eax,%eax
 1084e43:	jne    1084ccd <check_input_resolve_range+0x262d>
 1084e49:	mov    0x10(%rsp),%rax
 1084e4e:	vpbroadcastq -0xad8a88(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1084e58:	vpbroadcastd -0xad9281(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084e61:	vpbroadcastq -0xad8a8b(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1084e6b:	vpbroadcastd -0xad9295(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1084e75:	vpbroadcastq -0xad8aa7(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1084e7f:	movzbl 0x18(%rsp),%r9d
 1084e85:	incl   0x30(%rax)
 1084e88:	mov    0x130(%rsp),%ecx
 1084e8f:	mov    0x30(%rsp),%r11
 1084e94:	cmp    %r11d,%ecx
 1084e97:	jb     1084d34 <check_input_resolve_range+0x2694>
 1084e9d:	jmp    1084ebf <check_input_resolve_range+0x281f>
 1084e9f:	mov    0x10(%rsp),%r12
 1084ea4:	cmp    $0x2f,%edx
 1084ea7:	jne    1086420 <check_input_resolve_range+0x3d80>
 1084ead:	jmp    1084933 <check_input_resolve_range+0x2293>
 1084eb2:	mov    %r13d,0x24(%rsp)
 1084eb7:	test   %dl,%dl
 1084eb9:	je     1086420 <check_input_resolve_range+0x3d80>
 1084ebf:	mov    0x10(%rsp),%r12
 1084ec4:	xor    $0x1,%r9b
 1084ec8:	mov    %r9b,0x48(%r12)
 1084ecd:	mov    0x28(%r12),%esi
 1084ed2:	test   %esi,%esi
 1084ed4:	je     1084ede <check_input_resolve_range+0x283e>
 1084ed6:	movzbl 0x4b(%r12),%eax
 1084edc:	jmp    1084ee3 <check_input_resolve_range+0x2843>
 1084ede:	mov    $0x1,%eax
 1084ee3:	movzbl 0x49(%r12),%edx
 1084ee9:	mov    0x58(%rsp),%r15
 1084eee:	or     %eax,%edx
 1084ef0:	mov    %dl,0x49(%r12)
 1084ef5:	cmp    %r11d,%ecx
 1084ef8:	jne    1084f1e <check_input_resolve_range+0x287e>
 1084efa:	cmpb   $0x1,0x4b(%r12)
 1084f00:	jne    1084f0a <check_input_resolve_range+0x286a>
 1084f02:	cmpl   $0x0,0x34(%r12)
 1084f08:	je     1084f1e <check_input_resolve_range+0x287e>
 1084f0a:	cmpl   $0xffffffff,0x44(%r12)
 1084f10:	movzbl %r9b,%eax
 1084f14:	mov    $0x1,%ecx
 1084f19:	cmovne %ecx,%eax
 1084f1c:	jmp    1084f20 <check_input_resolve_range+0x2880>
 1084f1e:	xor    %eax,%eax
 1084f20:	add    0x2c(%r12),%esi
 1084f25:	mov    0x70(%rsp),%rcx
 1084f2a:	mov    0x90(%rsp),%rdx
 1084f32:	mov    %r15,0x10(%r12)
 1084f37:	mov    %rcx,0x18(%r12)
 1084f3c:	mov    %rdx,0x20(%r12)
 1084f41:	mov    %esi,0xb4(%rsp)
 1084f48:	test   %al,%al
 1084f4a:	je     1085a58 <check_input_resolve_range+0x33b8>
 1084f50:	test   %esi,%esi
 1084f52:	je     1085a58 <check_input_resolve_range+0x33b8>
 1084f58:	mov    0xb4(%rsp),%eax
 1084f5f:	lea    0x10(%r15),%rcx
 1084f63:	xor    %r13d,%r13d
 1084f66:	xor    %r8d,%r8d
 1084f69:	mov    %r15,0x58(%rsp)
 1084f6e:	mov    %rcx,0xe0(%rsp)
 1084f76:	mov    %rax,0x100(%rsp)
 1084f7e:	xchg   %ax,%ax
 1084f80:	mov    %r13,%rax
 1084f83:	shl    $0x4,%rax
 1084f87:	mov    0x10(%rbx),%rdx
 1084f8b:	mov    0x10(%r12),%rcx
 1084f90:	mov    0x28(%r12),%r9d
 1084f95:	lea    (%rax,%rax,2),%rdi
 1084f99:	mov    0xc(%r15,%rdi,1),%eax
 1084f9e:	mov    (%rcx,%rdi,1),%r10
 1084fa2:	mov    0x8(%rcx,%rdi,1),%r11d
 1084fa7:	lea    (%rcx,%rdi,1),%rbx
 1084fab:	mov    %eax,0x24(%rsp)
 1084faf:	mov    0x270(%rdx),%rax
 1084fb6:	mov    %rax,0xc8(%rsp)
 1084fbe:	test   %r11,%r11
 1084fc1:	je     1085090 <check_input_resolve_range+0x29f0>
 1084fc7:	mov    %rdi,%r12
 1084fca:	mov    %r8d,0x80(%rsp)
 1084fd2:	xor    %ebp,%ebp
 1084fd4:	mov    %r10,0x40(%rsp)
 1084fd9:	mov    %r10,%rdi
 1084fdc:	xor    %esi,%esi
 1084fde:	mov    %r11,%rdx
 1084fe1:	mov    %r11,%r15
 1084fe4:	mov    %r9,%r14
 1084fe7:	vzeroupper
 1084fea:	call   787f30 <memchr@plt>
 1084fef:	test   %rax,%rax
 1084ff2:	mov    $0x2,%edx
 1084ff7:	mov    %r14,%r9
 1084ffa:	lea    0x24(%rbx),%rsi
 1084ffe:	movl   $0xffffffff,0x24(%rbx)
 1085005:	sete   %cl
 1085008:	cmp    %r14,%r13
 108500b:	lea    0x28(%rbx),%r14
 108500f:	sbb    $0x0,%edx
 1085012:	mov    %edx,0x28(%rbx)
 1085015:	cmp    %r9,%r13
 1085018:	jae    10850d0 <check_input_resolve_range+0x2a30>
 108501e:	vpbroadcastq -0xad8c58(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1085028:	vpbroadcastd -0xad9451(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1085031:	vpbroadcastq -0xad8c5b(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 108503b:	vpbroadcastd -0xad9465(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1085045:	vpbroadcastq -0xad8c77(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 108504f:	mov    0x8(%rsp),%rbx
 1085054:	mov    0x80(%rsp),%r8d
 108505c:	mov    %r12,%rdi
 108505f:	mov    %r15,%r11
 1085062:	mov    %r14,%rdx
 1085065:	test   %rax,%rax
 1085068:	je     1085145 <check_input_resolve_range+0x2aa5>
 108506e:	mov    0x40(%rsp),%r10
 1085073:	mov    0x10(%rsp),%r12
 1085078:	mov    0x58(%rsp),%r15
 108507d:	xor    %ecx,%ecx
 108507f:	mov    $0x1,%r14d
 1085085:	jmp    1085180 <check_input_resolve_range+0x2ae0>
 108508a:	nopw   0x0(%rax,%rax,1)
 1085090:	cmp    %r9,%r13
 1085093:	mov    $0x2,%eax
 1085098:	movl   $0xffffffff,0x24(%rbx)
 108509f:	sbb    $0x0,%eax
 10850a2:	xor    %ecx,%ecx
 10850a4:	mov    %eax,0x28(%rbx)
 10850a7:	cmp    %r9,%r13
 10850aa:	jae    108513b <check_input_resolve_range+0x2a9b>
 10850b0:	lea    0x24(%rbx),%rsi
 10850b4:	add    $0x28,%rbx
 10850b8:	mov    $0x1,%r14d
 10850be:	mov    %rbx,%rdx
 10850c1:	mov    0x8(%rsp),%rbx
 10850c6:	jmp    1085180 <check_input_resolve_range+0x2ae0>
 10850cb:	nopl   0x0(%rax,%rax,1)
 10850d0:	vpbroadcastq -0xad8d0a(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10850da:	vpbroadcastd -0xad9503(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10850e3:	vpbroadcastq -0xad8d0d(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10850ed:	vpbroadcastd -0xad9517(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10850f7:	vpbroadcastq -0xad8d29(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1085101:	mov    %r12,%rdi
 1085104:	mov    %r15,%r11
 1085107:	mov    0x8(%rsp),%rbx
 108510c:	mov    0x80(%rsp),%r8d
 1085114:	mov    0x40(%rsp),%r10
 1085119:	mov    0x10(%rsp),%r12
 108511e:	mov    0x58(%rsp),%r15
 1085123:	mov    %r14,%rdx
 1085126:	mov    $0x2,%r14d
 108512c:	cmp    %r11d,%ebp
 108512f:	setb   %al
 1085132:	test   %al,%cl
 1085134:	jne    1085196 <check_input_resolve_range+0x2af6>
 1085136:	jmp    1085950 <check_input_resolve_range+0x32b0>
 108513b:	mov    0x8(%rsp),%rbx
 1085140:	jmp    1085950 <check_input_resolve_range+0x32b0>
 1085145:	mov    0x40(%rsp),%r10
 108514a:	mov    0x10(%rsp),%r12
 108514f:	mov    0x58(%rsp),%r15
 1085154:	movzbl (%r10),%eax
 1085158:	cmp    $0x3d,%eax
 108515b:	je     1085166 <check_input_resolve_range+0x2ac6>
 108515d:	cmp    $0x2b,%eax
 1085160:	jne    108507d <check_input_resolve_range+0x29dd>
 1085166:	xor    %ecx,%ecx
 1085168:	cmp    $0x2b,%al
 108516a:	sete   %cl
 108516d:	lea    0x1(%rcx,%rcx,1),%r14d
 1085172:	mov    $0x1,%cl
 1085174:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1085180:	mov    $0x1,%ebp
 1085185:	mov    %r14d,(%rdx)
 1085188:	cmp    %r11d,%ebp
 108518b:	setb   %al
 108518e:	test   %al,%cl
 1085190:	je     1085950 <check_input_resolve_range+0x32b0>
 1085196:	xor    %eax,%eax
 1085198:	cmp    %r9,%r13
 108519b:	mov    %rsi,0xf8(%rsp)
 10851a3:	mov    $0x1,%esi
 10851a8:	mov    %r14d,0x60(%rsp)
 10851ad:	movl   $0xffffffff,0xa0(%rsp)
 10851b8:	mov    %rdx,0x18(%rsp)
 10851bd:	setae  %al
 10851c0:	xor    %r12d,%r12d
 10851c3:	mov    %eax,0x30(%rsp)
 10851c7:	shl    $0x4,%eax
 10851ca:	or     $0xc,%eax
 10851cd:	mov    %eax,0x10c(%rsp)
 10851d4:	mov    %r11d,%eax
 10851d7:	neg    %eax
 10851d9:	mov    %rax,0x110(%rsp)
 10851e1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10851f0:	mov    %ebp,%eax
 10851f2:	movzbl (%r10,%rax,1),%r14d
 10851f7:	lea    0x1(%rbp),%r15d
 10851fb:	cmp    $0x2c,%r14d
 10851ff:	jne    1085210 <check_input_resolve_range+0x2b70>
 1085201:	mov    %r12d,%ecx
 1085204:	or     0x30(%rsp),%cl
 1085208:	inc    %esi
 108520a:	xor    %r12d,%r12d
 108520d:	jmp    1085260 <check_input_resolve_range+0x2bc0>
 108520f:	nop
 1085210:	lea    -0x25(%r14),%eax
 1085214:	cmp    $0x1,%al
 1085216:	ja     1085240 <check_input_resolve_range+0x2ba0>
 1085218:	cmp    %r9,%r13
 108521b:	mov    0x60(%rsp),%ebp
 108521f:	setb   %cl
 1085222:	xor    %eax,%eax
 1085224:	cmp    $0x26,%r14d
 1085228:	setne  %al
 108522b:	or     %al,%cl
 108522d:	shl    $0x6,%eax
 1085230:	add    $0x40,%eax
 1085233:	or     %eax,%ebp
 1085235:	mov    %ebp,0x60(%rsp)
 1085239:	mov    %ebp,(%rdx)
 108523b:	jmp    1085260 <check_input_resolve_range+0x2bc0>
 108523d:	nopl   (%rax)
 1085240:	cmp    $0x3f,%r14d
 1085244:	ja     108527a <check_input_resolve_range+0x2bda>
 1085246:	movabs $0x8000040b00000200,%rdx
 1085250:	mov    %r14d,%eax
 1085253:	mov    $0x1,%cl
 1085255:	bt     %rax,%rdx
 1085259:	mov    0x18(%rsp),%rdx
 108525e:	jae    108527a <check_input_resolve_range+0x2bda>
 1085260:	test   $0x1,%cl
 1085263:	je     1085970 <check_input_resolve_range+0x32d0>
 1085269:	mov    %r15d,%ebp
 108526c:	cmp    %r11d,%r15d
 108526f:	jb     10851f0 <check_input_resolve_range+0x2b50>
 1085275:	jmp    1085970 <check_input_resolve_range+0x32d0>
 108527a:	cmp    %r9,%r13
 108527d:	jae    1085414 <check_input_resolve_range+0x2d74>
 1085283:	lea    -0x3c(%r14),%eax
 1085287:	cmp    $0x3f,%eax
 108528a:	ja     10857c1 <check_input_resolve_range+0x3121>
 1085290:	lea    -0xbe7797(%rip),%rcx        # 49db00 <cbuiltin_test_generated.edges+0x3cc0>
 1085297:	movslq (%rcx,%rax,4),%rax
 108529b:	add    %rcx,%rax
 108529e:	jmp    *%rax
 10852a0:	lea    0x3(%rbp),%eax
 10852a3:	mov    %eax,0xd0(%rsp)
 10852aa:	cmp    %r11d,%eax
 10852ad:	jae    10857c1 <check_input_resolve_range+0x3121>
 10852b3:	mov    %r15d,%eax
 10852b6:	cmpb   $0x63,(%r10,%rax,1)
 10852bb:	jne    10857c1 <check_input_resolve_range+0x3121>
 10852c1:	add    $0x2,%ebp
 10852c4:	cmpb   $0x63,(%r10,%rbp,1)
 10852c9:	jne    10857c1 <check_input_resolve_range+0x3121>
 10852cf:	mov    0xd0(%rsp),%r15d
 10852d7:	mov    %rdi,0x88(%rsp)
 10852df:	mov    %r8d,0x80(%rsp)
 10852e7:	mov    %r9,0xa8(%rsp)
 10852ef:	mov    %r11,0x98(%rsp)
 10852f7:	mov    %esi,0x7c(%rsp)
 10852fb:	mov    %r15,0xd8(%rsp)
 1085303:	cmpb   $0x2c,(%r10,%r15,1)
 1085308:	je     1085315 <check_input_resolve_range+0x2c75>
 108530a:	inc    %r15
 108530d:	cmp    %r15,%r11
 1085310:	jne    1085303 <check_input_resolve_range+0x2c63>
 1085312:	mov    %r11d,%r15d
 1085315:	mov    %r15d,%eax
 1085318:	sub    0xd0(%rsp),%eax
 108531f:	add    %r10,0xd8(%rsp)
 1085327:	lea    0xc13eb2(%rip),%rbx        # 1c991e0 <check_asm_constraint.conditions>
 108532e:	xor    %ebp,%ebp
 1085330:	mov    %r10,0x40(%rsp)
 1085335:	mov    %rax,0xc0(%rsp)
 108533d:	cmp    0xd0(%rsp),%r15d
 1085345:	mov    (%rbx),%r14
 1085348:	mov    %r14,%rdi
 108534b:	sete   %r12b
 108534f:	vzeroupper
 1085352:	call   787bf0 <strlen@plt>
 1085357:	cmp    0xc0(%rsp),%rax
 108535f:	setne  %al
 1085362:	sete   %cl
 1085365:	or     %r12b,%al
 1085368:	jne    1085387 <check_input_resolve_range+0x2ce7>
 108536a:	mov    0xd8(%rsp),%rdi
 1085372:	mov    0xc0(%rsp),%rdx
 108537a:	mov    %r14,%rsi
 108537d:	call   7880b0 <bcmp@plt>
 1085382:	test   %eax,%eax
 1085384:	sete   %cl
 1085387:	test   %cl,%cl
 1085389:	jne    1085399 <check_input_resolve_range+0x2cf9>
 108538b:	add    $0x8,%rbx
 108538f:	cmp    $0x1a,%rbp
 1085393:	lea    0x1(%rbp),%rbp
 1085397:	jbe    108533d <check_input_resolve_range+0x2c9d>
 1085399:	vpbroadcastq -0xad8fd3(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10853a3:	vpbroadcastd -0xad97cc(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10853ac:	vpbroadcastq -0xad8fd6(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10853b6:	vpbroadcastd -0xad97e0(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10853c0:	vpbroadcastq -0xad8ff2(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10853ca:	mov    0x60(%rsp),%eax
 10853ce:	mov    0x18(%rsp),%rdx
 10853d3:	mov    0x8(%rsp),%rbx
 10853d8:	mov    0x88(%rsp),%rdi
 10853e0:	mov    0x80(%rsp),%r8d
 10853e8:	mov    0xa8(%rsp),%r9
 10853f0:	mov    0x40(%rsp),%r10
 10853f5:	mov    0x98(%rsp),%r11
 10853fd:	mov    0x7c(%rsp),%esi
 1085401:	mov    $0x1,%r12b
 1085404:	or     $0x108,%eax
 1085409:	mov    %eax,0x60(%rsp)
 108540d:	mov    %eax,(%rdx)
 108540f:	jmp    1085260 <check_input_resolve_range+0x2bc0>
 1085414:	cmp    $0x5b,%r14d
 1085418:	lea    -0x30(%r14),%ecx
 108541c:	setne  %al
 108541f:	cmp    $0xa,%cl
 1085422:	setae  %cl
 1085425:	test   %cl,%al
 1085427:	jne    1085488 <check_input_resolve_range+0x2de8>
 1085429:	mov    %esi,0x7c(%rsp)
 108542d:	cmp    $0x5b,%r14d
 1085431:	jne    10854c0 <check_input_resolve_range+0x2e20>
 1085437:	mov    $0xffffffff,%r14d
 108543d:	xor    %eax,%eax
 108543f:	cmp    %r11d,%r15d
 1085442:	jae    108574e <check_input_resolve_range+0x30ae>
 1085448:	mov    0x110(%rsp),%rcx
 1085450:	mov    %r15d,%r15d
 1085453:	lea    (%r10,%r15,1),%rbp
 1085457:	xor    %r12d,%r12d
 108545a:	add    %r15,%rcx
 108545d:	nopl   (%rax)
 1085460:	cmpb   $0x5d,0x0(%rbp,%r12,1)
 1085466:	je     108561a <check_input_resolve_range+0x2f7a>
 108546c:	inc    %r12
 108546f:	mov    %ecx,%edx
 1085471:	add    %r12d,%edx
 1085474:	jne    1085460 <check_input_resolve_range+0x2dc0>
 1085476:	mov    0x10(%rsp),%rsi
 108547b:	mov    0x18(%rsp),%rdx
 1085480:	mov    %r11d,%r15d
 1085483:	jmp    1085753 <check_input_resolve_range+0x30b3>
 1085488:	lea    -0x3c(%r14),%eax
 108548c:	cmp    $0x3f,%eax
 108548f:	ja     10857c1 <check_input_resolve_range+0x3121>
 1085495:	movabs $0xa000004000005,%rcx
 108549f:	bt     %rax,%rcx
 10854a3:	jae    1085544 <check_input_resolve_range+0x2ea4>
 10854a9:	mov    0x60(%rsp),%eax
 10854ad:	mov    $0x1,%r12b
 10854b0:	mov    $0x1,%cl
 10854b2:	or     $0x4,%eax
 10854b5:	mov    %eax,0x60(%rsp)
 10854b9:	mov    %eax,(%rdx)
 10854bb:	jmp    1085260 <check_input_resolve_range+0x2bc0>
 10854c0:	mov    0x10(%rsp),%rsi
 10854c5:	mov    0xa0(%rsp),%ebp
 10854cc:	add    $0xffffffd0,%r14d
 10854d0:	mov    $0x1,%eax
 10854d5:	cmp    %r11d,%r15d
 10854d8:	jae    108551a <check_input_resolve_range+0x2e7a>
 10854da:	mov    %r15d,%r15d
 10854dd:	nopl   (%rax)
 10854e0:	movzbl (%r10,%r15,1),%ecx
 10854e5:	lea    -0x30(%rcx),%edx
 10854e8:	cmp    $0x9,%dl
 10854eb:	ja     1085507 <check_input_resolve_range+0x2e67>
 10854ed:	cmp    0x28(%rsi),%r14d
 10854f1:	jae    1085507 <check_input_resolve_range+0x2e67>
 10854f3:	lea    (%r14,%r14,4),%edx
 10854f7:	inc    %r15
 10854fa:	lea    -0x30(%rcx,%rdx,2),%r14d
 10854ff:	cmp    %r15,%r11
 1085502:	jne    10854e0 <check_input_resolve_range+0x2e40>
 1085504:	mov    %r11d,%r15d
 1085507:	mov    0x18(%rsp),%rdx
 108550c:	xor    %ecx,%ecx
 108550e:	cmp    0x28(%rsi),%r14d
 1085512:	jae    1085769 <check_input_resolve_range+0x30c9>
 1085518:	jmp    1085526 <check_input_resolve_range+0x2e86>
 108551a:	xor    %ecx,%ecx
 108551c:	cmp    0x28(%rsi),%r14d
 1085520:	jae    1085769 <check_input_resolve_range+0x30c9>
 1085526:	cmp    $0xffffffff,%ebp
 1085529:	je     1085608 <check_input_resolve_range+0x2f68>
 108552f:	xor    %ecx,%ecx
 1085531:	cmp    %r14d,%ebp
 1085534:	sete   %cl
 1085537:	test   %eax,%ecx
 1085539:	jne    1085771 <check_input_resolve_range+0x30d1>
 108553f:	jmp    108595d <check_input_resolve_range+0x32bd>
 1085544:	cmp    $0x1d,%rax
 1085548:	jne    10857b7 <check_input_resolve_range+0x3117>
 108554e:	cmp    %r11d,%r15d
 1085551:	jae    10855eb <check_input_resolve_range+0x2f4b>
 1085557:	mov    %r15d,%eax
 108555a:	mov    %esi,0x7c(%rsp)
 108555e:	movzbl (%r10,%rax,1),%esi
 1085563:	mov    %rdi,0x88(%rsp)
 108556b:	mov    $0x7,%edx
 1085570:	lea    -0xa50413(%rip),%rdi        # 635164 <foreign_touch.flags+0x3310e>
 1085577:	mov    %r8d,%ebp
 108557a:	mov    %r9,%r12
 108557d:	mov    %r10,%r14
 1085580:	mov    %r11,0x98(%rsp)
 1085588:	vzeroupper
 108558b:	call   787f30 <memchr@plt>
 1085590:	vpbroadcastq -0xad91c2(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 108559a:	vpbroadcastd -0xad99c4(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10855a4:	vpbroadcastq -0xad91ce(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10855ae:	vpbroadcastd -0xad99d7(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10855b7:	vpbroadcastq -0xad91f1(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10855c1:	mov    0x18(%rsp),%rdx
 10855c6:	mov    0x7c(%rsp),%esi
 10855ca:	mov    0x98(%rsp),%r11
 10855d2:	mov    0x88(%rsp),%rdi
 10855da:	test   %rax,%rax
 10855dd:	mov    %r14,%r10
 10855e0:	mov    %r12,%r9
 10855e3:	mov    %ebp,%r8d
 10855e6:	setne  %cl
 10855e9:	jmp    10855ed <check_input_resolve_range+0x2f4d>
 10855eb:	xor    %ecx,%ecx
 10855ed:	movzbl %cl,%eax
 10855f0:	add    %eax,%r15d
 10855f3:	mov    0x60(%rsp),%eax
 10855f7:	or     $0x8,%eax
 10855fa:	mov    $0x1,%r12b
 10855fd:	mov    %eax,0x60(%rsp)
 1085601:	mov    %eax,(%rdx)
 1085603:	jmp    1085260 <check_input_resolve_range+0x2bc0>
 1085608:	mov    $0x1,%ecx
 108560d:	test   %eax,%ecx
 108560f:	jne    1085771 <check_input_resolve_range+0x30d1>
 1085615:	jmp    108595d <check_input_resolve_range+0x32bd>
 108561a:	mov    0x10(%rsp),%rsi
 108561f:	add    %r12,%r15
 1085622:	mov    0x18(%rsp),%rdx
 1085627:	mov    0x2c(%rsi),%eax
 108562a:	add    0x28(%rsi),%eax
 108562d:	je     1085940 <check_input_resolve_range+0x32a0>
 1085633:	mov    0x10(%rsi),%rcx
 1085637:	mov    %eax,%eax
 1085639:	mov    %rbp,0xd0(%rsp)
 1085641:	mov    %rax,%rsi
 1085644:	xor    %ebp,%ebp
 1085646:	mov    %rdi,0x88(%rsp)
 108564e:	mov    %r9,0xa8(%rsp)
 1085656:	mov    %r10,0x40(%rsp)
 108565b:	mov    %r11,0x98(%rsp)
 1085663:	mov    %rax,0xd8(%rsp)
 108566b:	add    $0x10,%rcx
 108566f:	nop
 1085670:	mov    (%rcx),%eax
 1085672:	mov    $0xffffffff,%r14d
 1085678:	mov    %rcx,0xc0(%rsp)
 1085680:	test   %rax,%rax
 1085683:	je     108572b <check_input_resolve_range+0x308b>
 1085689:	mov    0xc8(%rsp),%rcx
 1085691:	mov    0x10(%rcx),%rcx
 1085695:	cmp    %r12d,0x4(%rcx,%rax,8)
 108569a:	jne    108572b <check_input_resolve_range+0x308b>
 10856a0:	mov    (%rcx,%rax,8),%edi
 10856a3:	mov    0xc8(%rsp),%rax
 10856ab:	mov    0xd0(%rsp),%rsi
 10856b3:	mov    %r12,%rdx
 10856b6:	mov    %r8d,%r14d
 10856b9:	add    0x40(%rax),%rdi
 10856bd:	vzeroupper
 10856c0:	call   7880b0 <bcmp@plt>
 10856c5:	vpbroadcastq -0xad92f7(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10856cf:	vpbroadcastd -0xad9af9(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10856d9:	vpbroadcastq -0xad9303(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10856e3:	vpbroadcastd -0xad9b0c(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10856ec:	vpbroadcastq -0xad9326(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10856f6:	mov    0xd8(%rsp),%rsi
 10856fe:	mov    0x18(%rsp),%rdx
 1085703:	mov    0x98(%rsp),%r11
 108570b:	mov    0x40(%rsp),%r10
 1085710:	mov    0xa8(%rsp),%r9
 1085718:	mov    0x88(%rsp),%rdi
 1085720:	neg    %eax
 1085722:	mov    %r14d,%r8d
 1085725:	sbb    %r14d,%r14d
 1085728:	or     %ebp,%r14d
 108572b:	mov    0xc0(%rsp),%rcx
 1085733:	cmp    $0xffffffff,%r14d
 1085737:	jne    1085749 <check_input_resolve_range+0x30a9>
 1085739:	inc    %rbp
 108573c:	add    $0x30,%rcx
 1085740:	cmp    %rsi,%rbp
 1085743:	jb     1085670 <check_input_resolve_range+0x2fd0>
 1085749:	mov    $0x1,%eax
 108574e:	mov    0x10(%rsp),%rsi
 1085753:	mov    0xa0(%rsp),%ebp
 108575a:	add    %eax,%r15d
 108575d:	xor    %ecx,%ecx
 108575f:	cmp    0x28(%rsi),%r14d
 1085763:	jb     1085526 <check_input_resolve_range+0x2e86>
 1085769:	test   %eax,%ecx
 108576b:	je     108595d <check_input_resolve_range+0x32bd>
 1085771:	mov    0xf8(%rsp),%rax
 1085779:	mov    %r14d,%ecx
 108577c:	lea    (%rcx,%rcx,2),%rcx
 1085780:	mov    $0x1,%r12b
 1085783:	mov    %r14d,0xa0(%rsp)
 108578b:	shl    $0x4,%rcx
 108578f:	mov    %r14d,(%rax)
 1085792:	mov    0x10(%rsi),%rax
 1085796:	mov    0x7c(%rsp),%esi
 108579a:	mov    0x28(%rax,%rcx,1),%eax
 108579e:	mov    0x60(%rsp),%ecx
 10857a2:	and    $0xc,%eax
 10857a5:	or     %eax,%ecx
 10857a7:	or     $0x20,%ecx
 10857aa:	mov    %ecx,0x60(%rsp)
 10857ae:	mov    %ecx,(%rdx)
 10857b0:	mov    $0x1,%cl
 10857b2:	jmp    1085260 <check_input_resolve_range+0x2bc0>
 10857b7:	cmp    $0x3f,%rax
 10857bb:	je     1085964 <check_input_resolve_range+0x32c4>
 10857c1:	mov    %rdi,0x88(%rsp)
 10857c9:	mov    $0x14,%edx
 10857ce:	lea    -0xa3a6d0(%rip),%rdi        # 64b105 <fuzz_comment_end+0xa9df>
 10857d5:	mov    %esi,%ebp
 10857d7:	mov    %r14d,%esi
 10857da:	mov    %r11,0x98(%rsp)
 10857e2:	mov    %r10,0x40(%rsp)
 10857e7:	mov    %r9,0xa8(%rsp)
 10857ef:	mov    %r8d,0x80(%rsp)
 10857f7:	vzeroupper
 10857fa:	call   787f30 <memchr@plt>
 10857ff:	test   %rax,%rax
 1085802:	je     1085820 <check_input_resolve_range+0x3180>
 1085804:	mov    0x60(%rsp),%eax
 1085808:	cmp    $0x66,%r14d
 108580c:	mov    0x18(%rsp),%rdx
 1085811:	mov    $0x1,%r12b
 1085814:	setne  %cl
 1085817:	or     0x30(%rsp),%cl
 108581b:	or     $0x8,%eax
 108581e:	jmp    108584c <check_input_resolve_range+0x31ac>
 1085820:	mov    $0x11,%edx
 1085825:	lea    -0xa67647(%rip),%rdi        # 61e1e5 <foreign_touch.flags+0x1c18f>
 108582c:	mov    %r14d,%esi
 108582f:	call   787f30 <memchr@plt>
 1085834:	test   %rax,%rax
 1085837:	je     10858af <check_input_resolve_range+0x320f>
 1085839:	mov    0x60(%rsp),%eax
 108583d:	mov    0x18(%rsp),%rdx
 1085842:	mov    $0x1,%r12b
 1085845:	mov    0x30(%rsp),%ecx
 1085849:	or     $0x10,%eax
 108584c:	mov    %eax,0x60(%rsp)
 1085850:	mov    %eax,(%rdx)
 1085852:	vpbroadcastq -0xad948c(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108585c:	vpbroadcastd -0xad9c85(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1085865:	vpbroadcastq -0xad948f(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 108586f:	vpbroadcastd -0xad9c99(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1085879:	vpbroadcastq -0xad94ab(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1085883:	mov    0x88(%rsp),%rdi
 108588b:	mov    0x80(%rsp),%r8d
 1085893:	mov    0xa8(%rsp),%r9
 108589b:	mov    0x40(%rsp),%r10
 10858a0:	mov    0x98(%rsp),%r11
 10858a8:	mov    %ebp,%esi
 10858aa:	jmp    1085260 <check_input_resolve_range+0x2bc0>
 10858af:	lea    -0x58(%r14),%eax
 10858b3:	xor    %ecx,%ecx
 10858b5:	mov    %ebp,%esi
 10858b7:	cmp    $0x18,%eax
 10858ba:	ja     1085a0e <check_input_resolve_range+0x336e>
 10858c0:	vpbroadcastq -0xad94fa(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10858ca:	vpbroadcastd -0xad9cf3(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10858d3:	vpbroadcastq -0xad94fd(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10858dd:	vpbroadcastd -0xad9d07(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10858e7:	vpbroadcastq -0xad9519(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10858f1:	mov    0x88(%rsp),%rdi
 10858f9:	mov    0x80(%rsp),%r8d
 1085901:	mov    0xa8(%rsp),%r9
 1085909:	mov    0x40(%rsp),%r10
 108590e:	mov    0x98(%rsp),%r11
 1085916:	mov    $0x1008001,%edx
 108591b:	bt     %eax,%edx
 108591e:	jae    1085970 <check_input_resolve_range+0x32d0>
 1085920:	cmp    $0x70,%r14d
 1085924:	mov    0x60(%rsp),%eax
 1085928:	mov    0x18(%rsp),%rdx
 108592d:	setne  %cl
 1085930:	or     0x30(%rsp),%cl
 1085934:	or     0x10c(%rsp),%eax
 108593b:	jmp    10855fa <check_input_resolve_range+0x2f5a>
 1085940:	mov    $0x1,%eax
 1085945:	jmp    1085753 <check_input_resolve_range+0x30b3>
 108594a:	nopw   0x0(%rax,%rax,1)
 1085950:	cmp    %r9,%r13
 1085953:	mov    $0x1,%esi
 1085958:	setae  %al
 108595b:	jmp    1085981 <check_input_resolve_range+0x32e1>
 108595d:	mov    0x7c(%rsp),%esi
 1085961:	mov    $0x1,%r12b
 1085964:	xor    %ecx,%ecx
 1085966:	cs nopw 0x0(%rax,%rax,1)
 1085970:	mov    0x30(%rsp),%eax
 1085974:	mov    0x58(%rsp),%r15
 1085979:	or     %r12b,%al
 108597c:	mov    0x10(%rsp),%r12
 1085981:	mov    %eax,0x30(%rsp)
 1085985:	test   %r13,%r13
 1085988:	mov    %esi,%r9d
 108598b:	sete   %dl
 108598e:	cmp    %r8d,%esi
 1085991:	sete   %sil
 1085995:	xor    %eax,%eax
 1085997:	test   $0x1,%cl
 108599a:	je     1085a54 <check_input_resolve_range+0x33b4>
 10859a0:	testb  $0x1,0x30(%rsp)
 10859a5:	je     1085a54 <check_input_resolve_range+0x33b4>
 10859ab:	or     %sil,%dl
 10859ae:	je     1085a54 <check_input_resolve_range+0x33b4>
 10859b4:	mov    $0x1,%al
 10859b6:	test   %r13,%r13
 10859b9:	je     10859f4 <check_input_resolve_range+0x3354>
 10859bb:	add    %r15,%rdi
 10859be:	mov    0x10(%rdi),%ecx
 10859c1:	test   %ecx,%ecx
 10859c3:	je     10859f4 <check_input_resolve_range+0x3354>
 10859c5:	mov    0xe0(%rsp),%rdx
 10859cd:	mov    $0x1,%esi
 10859d2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10859e0:	cmp    %ecx,(%rdx)
 10859e2:	setne  %al
 10859e5:	je     10859f4 <check_input_resolve_range+0x3354>
 10859e7:	add    $0x30,%rdx
 10859eb:	cmp    %r13,%rsi
 10859ee:	lea    0x1(%rsi),%rsi
 10859f2:	jb     10859e0 <check_input_resolve_range+0x3340>
 10859f4:	test   %al,%al
 10859f6:	je     1085a54 <check_input_resolve_range+0x33b4>
 10859f8:	inc    %r13
 10859fb:	mov    %r9d,%r8d
 10859fe:	cmp    0x100(%rsp),%r13
 1085a06:	jb     1084f80 <check_input_resolve_range+0x28e0>
 1085a0c:	jmp    1085a54 <check_input_resolve_range+0x33b4>
 1085a0e:	vpbroadcastq -0xad9648(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1085a18:	vpbroadcastd -0xad9e41(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1085a21:	vpbroadcastq -0xad964b(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1085a2b:	vpbroadcastd -0xad9e55(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1085a35:	vpbroadcastq -0xad9667(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1085a3f:	mov    0x88(%rsp),%rdi
 1085a47:	mov    0x80(%rsp),%r8d
 1085a4f:	jmp    1085970 <check_input_resolve_range+0x32d0>
 1085a54:	mov    (%rsp),%r13
 1085a58:	test   %al,%al
 1085a5a:	je     1086420 <check_input_resolve_range+0x3d80>
 1085a60:	mov    0x10(%rsp),%rax
 1085a65:	mov    0xb4(%rsp),%r15d
 1085a6d:	mov    0x90(%rsp),%r10
 1085a75:	mov    0x34(%rax),%r11d
 1085a79:	mov    %r15d,%r12d
 1085a7c:	test   %r11,%r11
 1085a7f:	je     1085b2d <check_input_resolve_range+0x348d>
 1085a85:	mov    0x58(%rsp),%rax
 1085a8a:	xor    %ecx,%ecx
 1085a8c:	add    $0x10,%rax
 1085a90:	lea    (%rcx,%rcx,2),%rdx
 1085a94:	lea    (%r10,%rdx,4),%rdx
 1085a98:	test   %r15d,%r15d
 1085a9b:	je     1085ae0 <check_input_resolve_range+0x3440>
 1085a9d:	mov    (%rdx),%esi
 1085a9f:	mov    $0x1,%r8d
 1085aa5:	mov    %rax,%rdi
 1085aa8:	nopl   0x0(%rax,%rax,1)
 1085ab0:	mov    (%rdi),%r9d
 1085ab3:	cmp    %r9d,%esi
 1085ab6:	je     1085ac5 <check_input_resolve_range+0x3425>
 1085ab8:	add    $0x30,%rdi
 1085abc:	cmp    %r12,%r8
 1085abf:	lea    0x1(%r8),%r8
 1085ac3:	jb     1085ab0 <check_input_resolve_range+0x3410>
 1085ac5:	cmp    %r9d,%esi
 1085ac8:	setne  %sil
 1085acc:	test   %rcx,%rcx
 1085acf:	jne    1085ae8 <check_input_resolve_range+0x3448>
 1085ad1:	jmp    1085b1c <check_input_resolve_range+0x347c>
 1085ad3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1085ae0:	mov    $0x1,%sil
 1085ae3:	test   %rcx,%rcx
 1085ae6:	je     1085b1c <check_input_resolve_range+0x347c>
 1085ae8:	test   %sil,%sil
 1085aeb:	je     1085b1c <check_input_resolve_range+0x347c>
 1085aed:	mov    (%rdx),%esi
 1085aef:	mov    $0x1,%r8d
 1085af5:	mov    %r10,%rdi
 1085af8:	nopl   0x0(%rax,%rax,1)
 1085b00:	mov    (%rdi),%r9d
 1085b03:	cmp    %esi,%r9d
 1085b06:	je     1085b15 <check_input_resolve_range+0x3475>
 1085b08:	add    $0xc,%rdi
 1085b0c:	cmp    %rcx,%r8
 1085b0f:	lea    0x1(%r8),%r8
 1085b13:	jb     1085b00 <check_input_resolve_range+0x3460>
 1085b15:	cmp    %esi,%r9d
 1085b18:	setne  %sil
 1085b1c:	test   %sil,%sil
 1085b1f:	je     1085b54 <check_input_resolve_range+0x34b4>
 1085b21:	inc    %rcx
 1085b24:	cmp    %r11,%rcx
 1085b27:	jne    1085a90 <check_input_resolve_range+0x33f0>
 1085b2d:	mov    0x10(%rsp),%rax
 1085b32:	mov    0x28(%rax),%esi
 1085b35:	test   %rsi,%rsi
 1085b38:	je     1085c39 <check_input_resolve_range+0x3599>
 1085b3e:	mov    0x10(%rax),%rax
 1085b42:	cmp    $0x8,%esi
 1085b45:	jae    1085c40 <check_input_resolve_range+0x35a0>
 1085b4b:	xor    %ecx,%ecx
 1085b4d:	xor    %edi,%edi
 1085b4f:	jmp    1085e73 <check_input_resolve_range+0x37d3>
 1085b54:	mov    0x4(%rdx),%eax
 1085b57:	mov    %eax,0x24(%rsp)
 1085b5b:	jmp    1086420 <check_input_resolve_range+0x3d80>
 1085b60:	mov    %r11d,%ebp
 1085b63:	mov    (%r8,%r10,4),%ebx
 1085b67:	cmp    $0xffffffff,%ebx
 1085b6a:	je     108877d <check_input_resolve_range+0x60dd>
 1085b70:	mov    %ebx,%r10d
 1085b73:	movzbl (%rsi,%r10,1),%ebx
 1085b78:	mov    %ebp,%r11d
 1085b7b:	xor    %ebp,%ebp
 1085b7d:	cmp    $0x7,%bl
 1085b80:	je     1085b63 <check_input_resolve_range+0x34c3>
 1085b82:	cmp    $0x1a,%bl
 1085b85:	je     1085b63 <check_input_resolve_range+0x34c3>
 1085b87:	movzbl (%r9,%r10,1),%ebx
 1085b8c:	cmp    $0x43,%bl
 1085b8f:	je     1085b63 <check_input_resolve_range+0x34c3>
 1085b91:	cmp    $0x4f,%bl
 1085b94:	je     1085b63 <check_input_resolve_range+0x34c3>
 1085b96:	lea    -0x37(%rbx),%r14d
 1085b9a:	cmp    $0xfd,%r14b
 1085b9e:	ja     1085b63 <check_input_resolve_range+0x34c3>
 1085ba0:	cmp    %edi,%r10d
 1085ba3:	jae    1085beb <check_input_resolve_range+0x354b>
 1085ba5:	mov    0x18(%rdx),%r14
 1085ba9:	movzbl %bl,%ebx
 1085bac:	vmovd  %ebx,%xmm0
 1085bb0:	mov    (%r14,%r10,4),%ebp
 1085bb4:	vpinsrd $0x1,%ebp,%xmm0,%xmm0
 1085bba:	cmp    $0x6b,%ebp
 1085bbd:	vpshufd $0x50,%xmm0,%xmm0
 1085bc2:	vpand  -0xaf68ba(%rip),%xmm0,%xmm0        # 58f310 <abi_test_hex.digits+0xb40>
 1085bca:	sete   %bpl
 1085bce:	vpcmpeqd -0xaf68b8(%rip),%xmm0,%k0        # 58f320 <abi_test_hex.digits+0xb50>
 1085bd8:	kortestb %k0,%k0
 1085bdc:	setne  %r14b
 1085be0:	or     %bpl,%r14b
 1085be3:	cmp    $0x6,%bl
 1085be6:	sete   %bl
 1085be9:	jmp    1085bf0 <check_input_resolve_range+0x3550>
 1085beb:	xor    %ebx,%ebx
 1085bed:	xor    %r14d,%r14d
 1085bf0:	mov    %r14d,%ebp
 1085bf3:	xor    $0x1,%bpl
 1085bf7:	and    %r11b,%bpl
 1085bfa:	test   %r14b,%r14b
 1085bfd:	jne    1085b63 <check_input_resolve_range+0x34c3>
 1085c03:	test   %bl,%bl
 1085c05:	je     1085b63 <check_input_resolve_range+0x34c3>
 1085c0b:	lea    0x1(%r10),%rbx
 1085c0f:	cmp    %edi,%ebx
 1085c11:	jae    1085b60 <check_input_resolve_range+0x34c0>
 1085c17:	cmpb   $0x6,(%r9,%rbx,1)
 1085c1c:	setne  %bl
 1085c1f:	and    %bl,%r11b
 1085c22:	jmp    1085b60 <check_input_resolve_range+0x34c0>
 1085c27:	mov    %r13d,%ecx
 1085c2a:	mov    (%rsp),%r13
 1085c2e:	movzbl 0x18(%rsp),%r9d
 1085c34:	jmp    1084ebf <check_input_resolve_range+0x281f>
 1085c39:	xor    %edi,%edi
 1085c3b:	jmp    1085ea0 <check_input_resolve_range+0x3800>
 1085c40:	cmp    $0x40,%esi
 1085c43:	jae    1085c59 <check_input_resolve_range+0x35b9>
 1085c45:	xor    %ecx,%ecx
 1085c47:	xor    %edi,%edi
 1085c49:	jmp    1085e00 <check_input_resolve_range+0x3760>
 1085c4e:	mov    $0xffffffff,%r10d
 1085c54:	jmp    1088790 <check_input_resolve_range+0x60f0>
 1085c59:	vmovdqa64 -0xbe81a3(%rip),%zmm1        # 49dac0 <cbuiltin_test_generated.edges+0x3c80>
 1085c63:	vmovdqa64 -0xbe81ed(%rip),%zmm2        # 49da80 <cbuiltin_test_generated.edges+0x3c40>
 1085c6d:	mov    %esi,%ecx
 1085c6f:	and    $0xffffffc0,%ecx
 1085c72:	vpxor  %xmm0,%xmm0,%xmm0
 1085c76:	vpxor  %xmm3,%xmm3,%xmm3
 1085c7a:	vpxor  %xmm4,%xmm4,%xmm4
 1085c7e:	vpxor  %xmm5,%xmm5,%xmm5
 1085c82:	mov    %rcx,%rdx
 1085c85:	data16 cs nopw 0x0(%rax,%rax,1)
 1085c90:	vpmullq %zmm12,%zmm2,%zmm7
 1085c96:	vpmullq %zmm12,%zmm1,%zmm6
 1085c9c:	kxnorb %k0,%k0,%k1
 1085ca0:	vpxor  %xmm8,%xmm8,%xmm8
 1085ca5:	vpxor  %xmm9,%xmm9,%xmm9
 1085caa:	vpxor  %xmm10,%xmm10,%xmm10
 1085caf:	vpxor  %xmm11,%xmm11,%xmm11
 1085cb4:	vpaddq %zmm16,%zmm1,%zmm1
 1085cba:	vpaddq %zmm16,%zmm2,%zmm2
 1085cc0:	add    $0xffffffffffffffc0,%rdx
 1085cc4:	vpgatherqd 0x28(%rax,%zmm7,1),%ymm8{%k1}
 1085ccc:	kxnorb %k0,%k0,%k1
 1085cd0:	vpgatherqd 0x28(%rax,%zmm6,1),%ymm9{%k1}
 1085cd8:	kxnorb %k0,%k0,%k1
 1085cdc:	vinserti64x4 $0x1,%ymm8,%zmm9,%zmm8
 1085ce3:	vpxor  %xmm9,%xmm9,%xmm9
 1085ce8:	vpgatherqd 0x328(%rax,%zmm7,1),%ymm9{%k1}
 1085cf3:	kxnorb %k0,%k0,%k1
 1085cf7:	vpgatherqd 0x328(%rax,%zmm6,1),%ymm10{%k1}
 1085d02:	kxnorb %k0,%k0,%k1
 1085d06:	vinserti64x4 $0x1,%ymm9,%zmm10,%zmm9
 1085d0d:	vpxor  %xmm10,%xmm10,%xmm10
 1085d12:	vpgatherqd 0x628(%rax,%zmm7,1),%ymm10{%k1}
 1085d1d:	kxnorb %k0,%k0,%k1
 1085d21:	vpgatherqd 0x628(%rax,%zmm6,1),%ymm11{%k1}
 1085d2c:	kxnorb %k0,%k0,%k1
 1085d30:	vinserti64x4 $0x1,%ymm10,%zmm11,%zmm10
 1085d37:	vpxor  %xmm11,%xmm11,%xmm11
 1085d3c:	vpgatherqd 0x928(%rax,%zmm7,1),%ymm11{%k1}
 1085d47:	kxnorb %k0,%k0,%k1
 1085d4b:	vpxor  %xmm7,%xmm7,%xmm7
 1085d4f:	vpgatherqd 0x928(%rax,%zmm6,1),%ymm7{%k1}
 1085d5a:	vinserti64x4 $0x1,%ymm11,%zmm7,%zmm6
 1085d61:	vpsrld $0x1,%zmm8,%zmm11
 1085d68:	vpsrld $0x1,%zmm9,%zmm8
 1085d6f:	vpsrld $0x1,%zmm10,%zmm9
 1085d76:	vpsrld $0x1,%zmm6,%zmm6
 1085d7d:	vpandd %zmm15,%zmm8,%zmm10
 1085d83:	vpandd %zmm15,%zmm11,%zmm7
 1085d89:	vpandd %zmm15,%zmm9,%zmm8
 1085d8f:	vpandd %zmm15,%zmm6,%zmm6
 1085d95:	vpaddd %zmm0,%zmm7,%zmm0
 1085d9b:	vpaddd %zmm3,%zmm10,%zmm3
 1085da1:	vpaddd %zmm4,%zmm8,%zmm4
 1085da7:	vpaddd %zmm5,%zmm6,%zmm5
 1085dad:	jne    1085c90 <check_input_resolve_range+0x35f0>
 1085db3:	vpaddd %zmm0,%zmm3,%zmm0
 1085db9:	vpaddd %zmm0,%zmm4,%zmm0
 1085dbf:	vpaddd %zmm0,%zmm5,%zmm0
 1085dc5:	vextracti64x4 $0x1,%zmm0,%ymm1
 1085dcc:	vpaddd %zmm1,%zmm0,%zmm0
 1085dd2:	vextracti128 $0x1,%ymm0,%xmm1
 1085dd8:	vpaddd %xmm1,%xmm0,%xmm0
 1085ddc:	vpshufd $0xee,%xmm0,%xmm1
 1085de1:	vpaddd %xmm1,%xmm0,%xmm0
 1085de5:	vpshufd $0x55,%xmm0,%xmm1
 1085dea:	vpaddd %xmm1,%xmm0,%xmm0
 1085dee:	vmovd  %xmm0,%edi
 1085df2:	cmp    %esi,%ecx
 1085df4:	je     1085ea0 <check_input_resolve_range+0x3800>
 1085dfa:	test   $0x38,%sil
 1085dfe:	je     1085e73 <check_input_resolve_range+0x37d3>
 1085e00:	mov    %rcx,%rdx
 1085e03:	vpbroadcastq %rdx,%zmm1
 1085e09:	vporq  -0xbe8353(%rip),%zmm1,%zmm1        # 49dac0 <cbuiltin_test_generated.edges+0x3c80>
 1085e13:	mov    %esi,%ecx
 1085e15:	and    $0xfffffff8,%ecx
 1085e18:	vmovd  %edi,%xmm0
 1085e1c:	sub    %rcx,%rdx
 1085e1f:	nop
 1085e20:	vpmullq %zmm12,%zmm1,%zmm2
 1085e26:	kxnorb %k0,%k0,%k1
 1085e2a:	vpxor  %xmm3,%xmm3,%xmm3
 1085e2e:	vpaddq %zmm14,%zmm1,%zmm1
 1085e34:	add    $0x8,%rdx
 1085e38:	vpgatherqd 0x28(%rax,%zmm2,1),%ymm3{%k1}
 1085e40:	vpsrld $0x1,%ymm3,%ymm2
 1085e45:	vpand  %ymm2,%ymm13,%ymm2
 1085e49:	vpaddd %ymm0,%ymm2,%ymm0
 1085e4d:	jne    1085e20 <check_input_resolve_range+0x3780>
 1085e4f:	vextracti128 $0x1,%ymm0,%xmm1
 1085e55:	vpaddd %xmm1,%xmm0,%xmm0
 1085e59:	vpshufd $0xee,%xmm0,%xmm1
 1085e5e:	vpaddd %xmm1,%xmm0,%xmm0
 1085e62:	vpshufd $0x55,%xmm0,%xmm1
 1085e67:	vpaddd %xmm1,%xmm0,%xmm0
 1085e6b:	vmovd  %xmm0,%edi
 1085e6f:	cmp    %esi,%ecx
 1085e71:	je     1085ea0 <check_input_resolve_range+0x3800>
 1085e73:	mov    %rsi,%rdx
 1085e76:	sub    %rcx,%rdx
 1085e79:	lea    (%rcx,%rcx,2),%rcx
 1085e7d:	shl    $0x4,%rcx
 1085e81:	lea    0x28(%rax,%rcx,1),%rax
 1085e86:	cs nopw 0x0(%rax,%rax,1)
 1085e90:	btl    $0x1,(%rax)
 1085e94:	adc    $0x0,%edi
 1085e97:	add    $0x30,%rax
 1085e9b:	dec    %rdx
 1085e9e:	jne    1085e90 <check_input_resolve_range+0x37f0>
 1085ea0:	mov    0x10(%rsp),%rcx
 1085ea5:	mov    0x8(%rcx),%r8d
 1085ea9:	mov    0xc(%rcx),%eax
 1085eac:	test   %r8d,%r8d
 1085eaf:	mov    %eax,0x24(%rsp)
 1085eb3:	sete   %al
 1085eb6:	or     0x48(%rcx),%al
 1085eb9:	je     1085f91 <check_input_resolve_range+0x38f1>
 1085ebf:	test   %r15d,%r15d
 1085ec2:	je     1085ee4 <check_input_resolve_range+0x3844>
 1085ec4:	mov    0x20(%rbx),%rax
 1085ec8:	mov    (%rax),%rsi
 1085ecb:	mov    0x8(%rax),%rdx
 1085ecf:	lea    0x7(%rdx,%rsi,1),%rcx
 1085ed4:	add    %rsi,%rdx
 1085ed7:	and    $0xfffffffffffffff8,%rcx
 1085edb:	cmp    %rdx,%rcx
 1085ede:	jae    1086272 <check_input_resolve_range+0x3bd2>
 1085ee4:	mov    (%rsp),%r13
 1085ee8:	xor    %esi,%esi
 1085eea:	mov    0x10(%rsp),%rax
 1085eef:	mov    %rsi,0x10(%rax)
 1085ef3:	mov    0x30(%rax),%eax
 1085ef6:	test   %rax,%rax
 1085ef9:	je     1085f1b <check_input_resolve_range+0x387b>
 1085efb:	mov    0x20(%rbx),%rcx
 1085eff:	mov    (%rcx),%rdi
 1085f02:	mov    0x8(%rcx),%rsi
 1085f06:	lea    0x7(%rsi,%rdi,1),%rdx
 1085f0b:	add    %rdi,%rsi
 1085f0e:	and    $0xfffffffffffffff8,%rdx
 1085f12:	cmp    %rsi,%rdx
 1085f15:	jae    10862b1 <check_input_resolve_range+0x3c11>
 1085f1b:	xor    %edi,%edi
 1085f1d:	mov    0x10(%rsp),%rax
 1085f22:	mov    %rdi,0x18(%rax)
 1085f26:	mov    0x34(%rax),%eax
 1085f29:	test   %rax,%rax
 1085f2c:	je     1085f4e <check_input_resolve_range+0x38ae>
 1085f2e:	mov    0x20(%rbx),%rcx
 1085f32:	mov    (%rcx),%rdi
 1085f35:	mov    0x8(%rcx),%rsi
 1085f39:	lea    0x3(%rsi,%rdi,1),%rdx
 1085f3e:	add    %rdi,%rsi
 1085f41:	and    $0xfffffffffffffffc,%rdx
 1085f45:	cmp    %rsi,%rdx
 1085f48:	jae    10862e5 <check_input_resolve_range+0x3c45>
 1085f4e:	xor    %eax,%eax
 1085f50:	mov    0x10(%rsp),%rcx
 1085f55:	mov    %rax,0x20(%rcx)
 1085f59:	test   %r15d,%r15d
 1085f5c:	je     1085f69 <check_input_resolve_range+0x38c9>
 1085f5e:	cmpq   $0x0,0x10(%rcx)
 1085f63:	je     108631d <check_input_resolve_range+0x3c7d>
 1085f69:	cmpl   $0x0,0x30(%rcx)
 1085f6d:	je     1085f7a <check_input_resolve_range+0x38da>
 1085f6f:	cmpq   $0x0,0x18(%rcx)
 1085f74:	je     1086335 <check_input_resolve_range+0x3c95>
 1085f7a:	cmpl   $0x0,0x34(%rcx)
 1085f7e:	je     1086331 <check_input_resolve_range+0x3c91>
 1085f84:	xor    %ecx,%ecx
 1085f86:	test   %rax,%rax
 1085f89:	sete   %cl
 1085f8c:	jmp    108633a <check_input_resolve_range+0x3c9a>
 1085f91:	mov    0x10(%rbx),%rax
 1085f95:	xor    %r13d,%r13d
 1085f98:	mov    %r11,0x60(%rsp)
 1085f9d:	mov    %r8,0xc8(%rsp)
 1085fa5:	mov    0x270(%rax),%rax
 1085fac:	mov    %rax,0x18(%rsp)
 1085fb1:	mov    0x10(%rsp),%rax
 1085fb6:	add    0x2c(%rax),%esi
 1085fb9:	mov    (%rax),%r9
 1085fbc:	add    %esi,%edi
 1085fbe:	mov    %esi,%eax
 1085fc0:	mov    %rax,0x30(%rsp)
 1085fc5:	mov    $0x1,%eax
 1085fca:	lea    0x1(%r9),%rcx
 1085fce:	mov    %rsi,0xe0(%rsp)
 1085fd6:	mov    %r9,0x40(%rsp)
 1085fdb:	mov    %rdi,0xf8(%rsp)
 1085fe3:	add    %r11d,%edi
 1085fe6:	sub    %r8d,%eax
 1085fe9:	mov    %rcx,0xc0(%rsp)
 1085ff1:	mov    %rax,0xa0(%rsp)
 1085ff9:	mov    %edi,0x100(%rsp)
 1086000:	jmp    108601e <check_input_resolve_range+0x397e>
 1086002:	cmp    0xe0(%rsp),%ecx
 1086009:	jae    1086269 <check_input_resolve_range+0x3bc9>
 108600f:	dec    %r13d
 1086012:	inc    %r13d
 1086015:	cmp    %r8d,%r13d
 1086018:	jae    1085ebf <check_input_resolve_range+0x381f>
 108601e:	mov    %r13d,%ebp
 1086021:	cmpb   $0x25,(%r9,%rbp,1)
 1086026:	jne    1086012 <check_input_resolve_range+0x3972>
 1086028:	inc    %rbp
 108602b:	cmp    %r8d,%ebp
 108602e:	jae    1086269 <check_input_resolve_range+0x3bc9>
 1086034:	movzbl (%r9,%rbp,1),%r14d
 1086039:	test   %r14d,%r14d
 108603c:	je     1086067 <check_input_resolve_range+0x39c7>
 108603e:	mov    $0x5,%edx
 1086043:	lea    -0x9dec12(%rip),%rdi        # 6a7438 <pp_string_value.meaning+0x1eeb7>
 108604a:	mov    %r14d,%esi
 108604d:	vzeroupper
 1086050:	call   787f30 <memchr@plt>
 1086055:	test   %rax,%rax
 1086058:	je     108606b <check_input_resolve_range+0x39cb>
 108605a:	mov    0x60(%rsp),%r11
 108605f:	mov    %ebp,%r13d
 1086062:	jmp    1086257 <check_input_resolve_range+0x3bb7>
 1086067:	xor    %eax,%eax
 1086069:	jmp    108608e <check_input_resolve_range+0x39ee>
 108606b:	cmp    $0x6c,%r14d
 108606f:	mov    0x60(%rsp),%r11
 1086074:	sete   %al
 1086077:	and    $0xdf,%r14b
 108607b:	add    $0x2,%r13d
 108607f:	add    $0xbf,%r14b
 1086083:	cmp    $0x1a,%r14b
 1086087:	cmovae %ebp,%r13d
 108608b:	mov    %r13d,%ebp
 108608e:	mov    0xc8(%rsp),%r8
 1086096:	mov    0x40(%rsp),%r9
 108609b:	cmp    %r8d,%ebp
 108609e:	jae    1086269 <check_input_resolve_range+0x3bc9>
 10860a4:	mov    %ebp,%r13d
 10860a7:	cmpb   $0x5b,(%r9,%r13,1)
 10860ac:	jne    10860f6 <check_input_resolve_range+0x3a56>
 10860ae:	inc    %ebp
 10860b0:	cmp    %r8d,%ebp
 10860b3:	jae    1086269 <check_input_resolve_range+0x3bc9>
 10860b9:	mov    0xa0(%rsp),%rcx
 10860c1:	mov    0xc0(%rsp),%rdx
 10860c9:	mov    0x18(%rsp),%r8
 10860ce:	xor    %r14d,%r14d
 10860d1:	add    %r13,%rcx
 10860d4:	add    %r13,%rdx
 10860d7:	nopw   0x0(%rax,%rax,1)
 10860e0:	cmpb   $0x5d,(%rdx,%r14,1)
 10860e5:	je     108614f <check_input_resolve_range+0x3aaf>
 10860e7:	inc    %r14
 10860ea:	mov    %ecx,%esi
 10860ec:	add    %r14d,%esi
 10860ef:	jne    10860e0 <check_input_resolve_range+0x3a40>
 10860f1:	jmp    1086269 <check_input_resolve_range+0x3bc9>
 10860f6:	mov    0x100(%rsp),%edi
 10860fd:	xor    %ecx,%ecx
 10860ff:	nop
 1086100:	movzbl (%r9,%r13,1),%edx
 1086105:	lea    -0x3a(%rdx),%esi
 1086108:	cmp    $0xf6,%sil
 108610c:	jb     1086124 <check_input_resolve_range+0x3a84>
 108610e:	cmp    %edi,%ecx
 1086110:	ja     1086124 <check_input_resolve_range+0x3a84>
 1086112:	lea    (%rcx,%rcx,4),%ecx
 1086115:	inc    %r13
 1086118:	lea    -0x30(%rdx,%rcx,2),%ecx
 108611c:	cmp    %r13,%r8
 108611f:	jne    1086100 <check_input_resolve_range+0x3a60>
 1086121:	mov    %r8d,%r13d
 1086124:	cmp    %ebp,%r13d
 1086127:	jbe    1086269 <check_input_resolve_range+0x3bc9>
 108612d:	test   %al,%al
 108612f:	je     1086002 <check_input_resolve_range+0x3962>
 1086135:	cmp    0xf8(%rsp),%ecx
 108613c:	jb     1086269 <check_input_resolve_range+0x3bc9>
 1086142:	cmp    %edi,%ecx
 1086144:	jb     108600f <check_input_resolve_range+0x396f>
 108614a:	jmp    1086269 <check_input_resolve_range+0x3bc9>
 108614f:	mov    %ebp,%ecx
 1086151:	add    0x40(%rsp),%rcx
 1086156:	mov    %rcx,0x80(%rsp)
 108615e:	test   %al,%al
 1086160:	je     10861d1 <check_input_resolve_range+0x3b31>
 1086162:	test   %r11d,%r11d
 1086165:	je     1086269 <check_input_resolve_range+0x3bc9>
 108616b:	mov    0x10(%rsp),%rax
 1086170:	xor    %r15d,%r15d
 1086173:	mov    0x20(%rax),%rbp
 1086177:	mov    0x0(%rbp),%ecx
 108617a:	mov    $0xffffffff,%eax
 108617f:	test   %rcx,%rcx
 1086182:	je     10861ba <check_input_resolve_range+0x3b1a>
 1086184:	mov    0x10(%r8),%rdx
 1086188:	cmp    %r14d,0x4(%rdx,%rcx,8)
 108618d:	jne    10861ba <check_input_resolve_range+0x3b1a>
 108618f:	mov    (%rdx,%rcx,8),%edi
 1086192:	mov    0x80(%rsp),%rsi
 108619a:	mov    %r14,%rdx
 108619d:	add    0x40(%r8),%rdi
 10861a1:	vzeroupper
 10861a4:	call   7880b0 <bcmp@plt>
 10861a9:	mov    0x18(%rsp),%r8
 10861ae:	mov    0x60(%rsp),%r11
 10861b3:	neg    %eax
 10861b5:	sbb    %eax,%eax
 10861b7:	or     %r15d,%eax
 10861ba:	cmp    $0xffffffff,%eax
 10861bd:	jne    1086245 <check_input_resolve_range+0x3ba5>
 10861c3:	inc    %r15
 10861c6:	add    $0xc,%rbp
 10861ca:	cmp    %r11,%r15
 10861cd:	jb     1086177 <check_input_resolve_range+0x3ad7>
 10861cf:	jmp    1086245 <check_input_resolve_range+0x3ba5>
 10861d1:	cmpl   $0x0,0xe0(%rsp)
 10861d9:	je     1086269 <check_input_resolve_range+0x3bc9>
 10861df:	mov    0x10(%rsp),%rax
 10861e4:	xor    %r15d,%r15d
 10861e7:	mov    0x10(%rax),%rbp
 10861eb:	add    $0x10,%rbp
 10861ef:	mov    0x0(%rbp),%ecx
 10861f2:	mov    $0xffffffff,%eax
 10861f7:	test   %rcx,%rcx
 10861fa:	je     1086232 <check_input_resolve_range+0x3b92>
 10861fc:	mov    0x10(%r8),%rdx
 1086200:	cmp    %r14d,0x4(%rdx,%rcx,8)
 1086205:	jne    1086232 <check_input_resolve_range+0x3b92>
 1086207:	mov    (%rdx,%rcx,8),%edi
 108620a:	mov    0x80(%rsp),%rsi
 1086212:	mov    %r14,%rdx
 1086215:	add    0x40(%r8),%rdi
 1086219:	vzeroupper
 108621c:	call   7880b0 <bcmp@plt>
 1086221:	mov    0x18(%rsp),%r8
 1086226:	mov    0x60(%rsp),%r11
 108622b:	neg    %eax
 108622d:	sbb    %eax,%eax
 108622f:	or     %r15d,%eax
 1086232:	cmp    $0xffffffff,%eax
 1086235:	jne    1086245 <check_input_resolve_range+0x3ba5>
 1086237:	inc    %r15
 108623a:	add    $0x30,%rbp
 108623e:	cmp    0x30(%rsp),%r15
 1086243:	jb     10861ef <check_input_resolve_range+0x3b4f>
 1086245:	cmp    $0xffffffff,%eax
 1086248:	je     1086269 <check_input_resolve_range+0x3bc9>
 108624a:	mov    0xb4(%rsp),%r15d
 1086252:	lea    0x1(%r13,%r14,1),%r13
 1086257:	mov    0xc8(%rsp),%r8
 108625f:	mov    0x40(%rsp),%r9
 1086264:	jmp    1086012 <check_input_resolve_range+0x3972>
 1086269:	mov    (%rsp),%r13
 108626d:	jmp    1086420 <check_input_resolve_range+0x3d80>
 1086272:	mov    0x10(%rax),%rdi
 1086276:	mov    %rcx,%rdx
 1086279:	sub    %rsi,%rdx
 108627c:	sub    %rdx,%rdi
 108627f:	jb     1085ee4 <check_input_resolve_range+0x3844>
 1086285:	mov    (%rsp),%r13
 1086289:	mov    %r12,%rsi
 108628c:	shl    $0x4,%rsi
 1086290:	lea    (%rsi,%rsi,2),%r8
 1086294:	mov    $0x0,%esi
 1086299:	cmp    %rdi,%r8
 108629c:	ja     1085eea <check_input_resolve_range+0x384a>
 10862a2:	add    %r8,%rdx
 10862a5:	mov    %rcx,%rsi
 10862a8:	mov    %rdx,0x8(%rax)
 10862ac:	jmp    1085eea <check_input_resolve_range+0x384a>
 10862b1:	mov    0x10(%rcx),%r8
 10862b5:	mov    %rdx,%rsi
 10862b8:	sub    %rdi,%rsi
 10862bb:	sub    %rsi,%r8
 10862be:	jb     1085f1b <check_input_resolve_range+0x387b>
 10862c4:	shl    $0x4,%rax
 10862c8:	mov    $0x0,%edi
 10862cd:	cmp    %r8,%rax
 10862d0:	ja     1085f1d <check_input_resolve_range+0x387d>
 10862d6:	add    %rax,%rsi
 10862d9:	mov    %rdx,%rdi
 10862dc:	mov    %rsi,0x8(%rcx)
 10862e0:	jmp    1085f1d <check_input_resolve_range+0x387d>
 10862e5:	mov    %rdx,%rsi
 10862e8:	sub    %rdi,%rsi
 10862eb:	mov    0x10(%rcx),%rdi
 10862ef:	sub    %rsi,%rdi
 10862f2:	jb     1085f4e <check_input_resolve_range+0x38ae>
 10862f8:	shl    $0x2,%rax
 10862fc:	lea    (%rax,%rax,2),%r8
 1086300:	mov    $0x0,%eax
 1086305:	cmp    %rdi,%r8
 1086308:	ja     1085f50 <check_input_resolve_range+0x38b0>
 108630e:	add    %r8,%rsi
 1086311:	mov    %rdx,%rax
 1086314:	mov    %rsi,0x8(%rcx)
 1086318:	jmp    1085f50 <check_input_resolve_range+0x38b0>
 108631d:	mov    0xf0(%rsp),%rax
 1086325:	movb   $0x1,0x3bd(%rax)
 108632c:	jmp    1086420 <check_input_resolve_range+0x3d80>
 1086331:	xor    %ecx,%ecx
 1086333:	jmp    108633a <check_input_resolve_range+0x3c9a>
 1086335:	mov    $0x1,%ecx
 108633a:	mov    0xf0(%rsp),%rdx
 1086342:	movzbl 0x3bd(%rdx),%eax
 1086349:	or     %ecx,%eax
 108634b:	mov    %al,0x3bd(%rdx)
 1086351:	jne    1086420 <check_input_resolve_range+0x3d80>
 1086357:	mov    0x10(%rsp),%r14
 108635c:	test   %r15d,%r15d
 108635f:	je     108637a <check_input_resolve_range+0x3cda>
 1086361:	mov    0x10(%r14),%rdi
 1086365:	mov    0x58(%rsp),%rsi
 108636a:	shl    $0x4,%r12
 108636e:	lea    (%r12,%r12,2),%rdx
 1086372:	vzeroupper
 1086375:	call   788240 <memcpy@plt>
 108637a:	mov    0x30(%r14),%edx
 108637e:	mov    0x48(%rsp),%r12
 1086383:	mov    0x28(%rsp),%rbp
 1086388:	mov    0x90(%rsp),%r15
 1086390:	test   %rdx,%rdx
 1086393:	je     10863aa <check_input_resolve_range+0x3d0a>
 1086395:	mov    0x18(%r14),%rdi
 1086399:	mov    0x70(%rsp),%rsi
 108639e:	shl    $0x4,%rdx
 10863a2:	vzeroupper
 10863a5:	call   788240 <memcpy@plt>
 10863aa:	mov    0x34(%r14),%eax
 10863ae:	test   %rax,%rax
 10863b1:	je     10863ca <check_input_resolve_range+0x3d2a>
 10863b3:	mov    0x20(%r14),%rdi
 10863b7:	shl    $0x2,%rax
 10863bb:	mov    %r15,%rsi
 10863be:	lea    (%rax,%rax,2),%rdx
 10863c2:	vzeroupper
 10863c5:	call   788240 <memcpy@plt>
 10863ca:	mov    0xf0(%rsp),%rax
 10863d2:	incl   0x340(%rax)
 10863d8:	mov    0xe8(%rsp),%rcx
 10863e0:	mov    0x28(%rbx),%rax
 10863e4:	cmp    0x8(%rax),%rcx
 10863e8:	jbe    108648c <check_input_resolve_range+0x3dec>
 10863ee:	jmp    1088ab0 <check_input_resolve_range+0x6410>
 10863f3:	mov    %r13d,%ecx
 10863f6:	mov    (%rsp),%r13
 10863fa:	jmp    1084ebf <check_input_resolve_range+0x281f>
 10863ff:	mov    0x24(%rsp),%eax
 1086403:	mov    %eax,%r13d
 1086406:	mov    0x10(%rsp),%rax
 108640b:	incl   0x30(%rax)
 108640e:	mov    %r13d,0x24(%rsp)
 1086413:	mov    (%rsp),%r13
 1086417:	nopw   0x0(%rax,%rax,1)
 1086420:	mov    (%rbx),%rax
 1086423:	mov    0x230(%rax),%ecx
 1086429:	cmp    0x234(%rax),%ecx
 108642f:	jae    1086465 <check_input_resolve_range+0x3dc5>
 1086431:	movzbl 0x3bd(%rax),%edx
 1086438:	lea    0x1(%rcx),%edi
 108643b:	mov    0x228(%rax),%rsi
 1086442:	mov    %edi,0x230(%rax)
 1086448:	lea    (%rcx,%rcx,2),%rax
 108644c:	mov    0x24(%rsp),%ecx
 1086450:	lea    0x1(%rdx,%rdx,2),%edx
 1086454:	mov    %ecx,(%rsi,%rax,4)
 1086457:	mov    %edx,0x4(%rsi,%rax,4)
 108645b:	movl   $0x0,0x8(%rsi,%rax,4)
 1086463:	jmp    108646c <check_input_resolve_range+0x3dcc>
 1086465:	movb   $0x1,0x3bd(%rax)
 108646c:	mov    0x48(%rsp),%r12
 1086471:	mov    0x28(%rsp),%rbp
 1086476:	mov    0xe8(%rsp),%rcx
 108647e:	mov    0x28(%rbx),%rax
 1086482:	cmp    0x8(%rax),%rcx
 1086486:	ja     1088ab0 <check_input_resolve_range+0x6410>
 108648c:	mov    %rcx,0x8(%rax)
 1086490:	mov    0x138(%rbx),%rax
 1086497:	movzbl (%rax,%rbp,1),%eax
 108649b:	test   %al,%al
 108649d:	je     1086510 <check_input_resolve_range+0x3e70>
 108649f:	mov    0x138(%rbx),%rsi
 10864a6:	cmpb   $0x0,(%rsi,%rbp,1)
 10864aa:	je     10865bc <check_input_resolve_range+0x3f1c>
 10864b0:	mov    0x138(%rbx),%rax
 10864b7:	cmpb   $0x0,(%rax,%rbp,1)
 10864bb:	jne    1086f00 <check_input_resolve_range+0x4860>
 10864c1:	mov    0x18(%r12),%rax
 10864c6:	mov    (%rax,%rbp,4),%eax
 10864c9:	add    $0xffffffb3,%eax
 10864cc:	cmp    $0x1,%eax
 10864cf:	ja     1086f00 <check_input_resolve_range+0x4860>
 10864d5:	mov    0x30(%r12),%ebp
 10864da:	lea    0x1(%r13),%r15d
 10864de:	cmp    %ebp,%r15d
 10864e1:	jae    1086ac4 <check_input_resolve_range+0x4424>
 10864e7:	mov    0x60(%r12),%rax
 10864ec:	mov    %r15d,%ecx
 10864ef:	mov    (%rax,%rcx,4),%ecx
 10864f2:	cmp    %ebp,%ecx
 10864f4:	jae    10867ca <check_input_resolve_range+0x412a>
 10864fa:	lea    0x2(%r13),%edx
 10864fe:	cmp    %ecx,%edx
 1086500:	jae    1086ac2 <check_input_resolve_range+0x4422>
 1086506:	mov    0x10(%r12),%rsi
 108650b:	jmp    1086649 <check_input_resolve_range+0x3fa9>
 1086510:	mov    0x18(%r12),%rax
 1086515:	cmpl   $0x4f,(%rax,%rbp,4)
 1086519:	jne    108653f <check_input_resolve_range+0x3e9f>
 108651b:	mov    $0x102,%edx
 1086520:	mov    %rbx,%rdi
 1086523:	mov    %r13d,%esi
 1086526:	vzeroupper
 1086529:	call   1095510 <check_input_vararg_prepare>
 108652e:	mov    0x138(%rbx),%rax
 1086535:	cmpb   $0x0,(%rax,%rbp,1)
 1086539:	jne    108649f <check_input_resolve_range+0x3dff>
 108653f:	mov    0x18(%r12),%rax
 1086544:	mov    (%rax,%rbp,4),%eax
 1086547:	cmp    $0x7e,%eax
 108654a:	je     1086555 <check_input_resolve_range+0x3eb5>
 108654c:	cmp    $0x50,%eax
 108654f:	jne    108649f <check_input_resolve_range+0x3dff>
 1086555:	mov    0x8(%rbx),%rcx
 1086559:	xor    %r8d,%r8d
 108655c:	cmp    $0x7e,%eax
 108655f:	lea    0x1(%r13),%ebx
 1086563:	sete   %r9b
 1086567:	mov    0x30(%rcx),%edi
 108656a:	cmp    %edi,%ebx
 108656c:	jae    1086731 <check_input_resolve_range+0x4091>
 1086572:	mov    0x60(%rcx),%r10
 1086576:	mov    %ebx,%r11d
 1086579:	xor    %esi,%esi
 108657b:	mov    (%r10,%r11,4),%edx
 108657f:	cmp    %edx,%ebx
 1086581:	jae    1086b47 <check_input_resolve_range+0x44a7>
 1086587:	mov    0x8(%rsp),%rbx
 108658c:	cmp    %edi,%edx
 108658e:	jae    1086b40 <check_input_resolve_range+0x44a0>
 1086594:	mov    0x50(%rcx),%rsi
 1086598:	cmpb   $0x2f,(%rsi,%r11,1)
 108659d:	jne    1086b53 <check_input_resolve_range+0x44b3>
 10865a3:	lea    0x2(%r13),%r11d
 10865a7:	mov    $0x1,%sil
 10865aa:	cmp    %edx,%r11d
 10865ad:	jae    1086b5c <check_input_resolve_range+0x44bc>
 10865b3:	mov    0x10(%rcx),%rdi
 10865b7:	jmp    10866fb <check_input_resolve_range+0x405b>
 10865bc:	mov    0x18(%r12),%rax
 10865c1:	mov    (%rax,%rbp,4),%eax
 10865c4:	cmp    $0x4c,%eax
 10865c7:	je     10865d2 <check_input_resolve_range+0x3f32>
 10865c9:	cmp    $0x28,%eax
 10865cc:	jne    10864b0 <check_input_resolve_range+0x3e10>
 10865d2:	mov    0x8(%rbx),%rax
 10865d6:	lea    0x1(%r13),%r10d
 10865da:	mov    0x30(%rax),%ecx
 10865dd:	cmp    %ecx,%r10d
 10865e0:	jae    10866d3 <check_input_resolve_range+0x4033>
 10865e6:	mov    0x60(%rax),%r8
 10865ea:	mov    %r10d,%r9d
 10865ed:	xor    %edi,%edi
 10865ef:	mov    (%r8,%r9,4),%edx
 10865f3:	cmp    %edx,%r10d
 10865f6:	jae    10867c6 <check_input_resolve_range+0x4126>
 10865fc:	cmp    %ecx,%edx
 10865fe:	jae    10867c6 <check_input_resolve_range+0x4126>
 1086604:	mov    0x50(%rax),%rcx
 1086608:	cmpb   $0x2f,(%rcx,%r9,1)
 108660d:	jne    10867dd <check_input_resolve_range+0x413d>
 1086613:	lea    0x2(%r13),%r9d
 1086617:	mov    $0x1,%dil
 108661a:	cmp    %edx,%r9d
 108661d:	jae    10866c9 <check_input_resolve_range+0x4029>
 1086623:	mov    0x10(%rax),%rcx
 1086627:	jmp    108669f <check_input_resolve_range+0x3fff>
 1086629:	cmp    $0xa,%r8d
 108662d:	jne    1086664 <check_input_resolve_range+0x3fc4>
 108662f:	mov    (%rax,%rdi,4),%edi
 1086632:	lea    0x1(%rdi),%ebp
 1086635:	cmp    %ecx,%edi
 1086637:	cmovae %ecx,%ebp
 108663a:	cmp    %edx,%edi
 108663c:	cmovbe %ecx,%ebp
 108663f:	mov    %ebp,%edx
 1086641:	cmp    %ecx,%ebp
 1086643:	jae    1086ac4 <check_input_resolve_range+0x4424>
 1086649:	mov    %edx,%edi
 108664b:	movzbl (%rsi,%rdi,1),%r8d
 1086650:	cmp    $0x9,%r8d
 1086654:	jg     1086629 <check_input_resolve_range+0x3f89>
 1086656:	cmp    $0x6,%r8d
 108665a:	je     108662f <check_input_resolve_range+0x3f8f>
 108665c:	cmp    $0x8,%r8d
 1086660:	je     108662f <check_input_resolve_range+0x3f8f>
 1086662:	jmp    108666e <check_input_resolve_range+0x3fce>
 1086664:	cmp    $0x33,%r8d
 1086668:	je     1086c95 <check_input_resolve_range+0x45f5>
 108666e:	inc    %edx
 1086670:	mov    %edx,%ebp
 1086672:	cmp    %ecx,%ebp
 1086674:	jb     1086649 <check_input_resolve_range+0x3fa9>
 1086676:	jmp    1086ac4 <check_input_resolve_range+0x4424>
 108667b:	cmp    $0xa,%r11d
 108667f:	jne    10866bb <check_input_resolve_range+0x401b>
 1086681:	mov    (%r8,%r10,4),%r10d
 1086685:	lea    0x1(%r10),%r11d
 1086689:	cmp    %edx,%r10d
 108668c:	cmovae %edx,%r11d
 1086690:	cmp    %r9d,%r10d
 1086693:	cmovbe %edx,%r11d
 1086697:	mov    %r11d,%r9d
 108669a:	cmp    %edx,%r9d
 108669d:	jae    10866c9 <check_input_resolve_range+0x4029>
 108669f:	mov    %r9d,%r10d
 10866a2:	movzbl (%rcx,%r10,1),%r11d
 10866a7:	cmp    $0x9,%r11d
 10866ab:	jg     108667b <check_input_resolve_range+0x3fdb>
 10866ad:	cmp    $0x6,%r11d
 10866b1:	je     1086681 <check_input_resolve_range+0x3fe1>
 10866b3:	cmp    $0x8,%r11d
 10866b7:	je     1086681 <check_input_resolve_range+0x3fe1>
 10866b9:	jmp    10866c1 <check_input_resolve_range+0x4021>
 10866bb:	cmp    $0x33,%r11d
 10866bf:	je     10866c9 <check_input_resolve_range+0x4029>
 10866c1:	inc    %r9d
 10866c4:	cmp    %edx,%r9d
 10866c7:	jb     108669f <check_input_resolve_range+0x3fff>
 10866c9:	mov    %edx,%ecx
 10866cb:	mov    %r9d,%edx
 10866ce:	jmp    10867e1 <check_input_resolve_range+0x4141>
 10866d3:	xor    %edi,%edi
 10866d5:	mov    %ecx,%edx
 10866d7:	jmp    10867e1 <check_input_resolve_range+0x4141>
 10866dc:	cmp    $0xa,%ebp
 10866df:	jne    1086713 <check_input_resolve_range+0x4073>
 10866e1:	mov    (%r10,%rbx,4),%ebx
 10866e5:	lea    0x1(%rbx),%ebp
 10866e8:	cmp    %edx,%ebx
 10866ea:	cmovae %edx,%ebp
 10866ed:	cmp    %r11d,%ebx
 10866f0:	cmovbe %edx,%ebp
 10866f3:	mov    %ebp,%r11d
 10866f6:	cmp    %edx,%r11d
 10866f9:	jae    1086720 <check_input_resolve_range+0x4080>
 10866fb:	mov    %r11d,%ebx
 10866fe:	movzbl (%rdi,%rbx,1),%ebp
 1086702:	cmp    $0x9,%ebp
 1086705:	jg     10866dc <check_input_resolve_range+0x403c>
 1086707:	cmp    $0x6,%ebp
 108670a:	je     10866e1 <check_input_resolve_range+0x4041>
 108670c:	cmp    $0x8,%ebp
 108670f:	je     10866e1 <check_input_resolve_range+0x4041>
 1086711:	jmp    1086718 <check_input_resolve_range+0x4078>
 1086713:	cmp    $0x33,%ebp
 1086716:	je     1086720 <check_input_resolve_range+0x4080>
 1086718:	inc    %r11d
 108671b:	cmp    %edx,%r11d
 108671e:	jb     10866fb <check_input_resolve_range+0x405b>
 1086720:	mov    0x8(%rsp),%rbx
 1086725:	mov    0x28(%rsp),%rbp
 108672a:	mov    %edx,%edi
 108672c:	mov    %r11d,%edx
 108672f:	jmp    108673a <check_input_resolve_range+0x409a>
 1086731:	mov    0x8(%rsp),%rbx
 1086736:	xor    %esi,%esi
 1086738:	mov    %edi,%edx
 108673a:	lea    0x2(%r13),%r11d
 108673e:	cmp    %edx,%r11d
 1086741:	jae    1086bcd <check_input_resolve_range+0x452d>
 1086747:	lea    0x1(%rdx),%r10d
 108674b:	cmp    %edi,%r10d
 108674e:	jae    1086bcd <check_input_resolve_range+0x452d>
 1086754:	mov    %r9b,%r8b
 1086757:	mov    0x10(%rcx),%r9
 108675b:	mov    %r10d,%ebx
 108675e:	lea    0x313(,%r8,4),%r8d
 1086766:	jmp    1086797 <check_input_resolve_range+0x40f7>
 1086768:	nopl   0x0(%rax,%rax,1)
 1086770:	cmp    $0xa,%ebp
 1086773:	jne    10867b0 <check_input_resolve_range+0x4110>
 1086775:	mov    0x60(%rcx),%r15
 1086779:	mov    (%r15,%r14,4),%r14d
 108677d:	lea    0x1(%r14),%ebp
 1086781:	cmp    %edi,%r14d
 1086784:	cmovae %edi,%ebp
 1086787:	cmp    %ebx,%r14d
 108678a:	cmovbe %edi,%ebp
 108678d:	mov    %ebp,%ebx
 108678f:	cmp    %edi,%ebp
 1086791:	jae    1086b68 <check_input_resolve_range+0x44c8>
 1086797:	mov    %ebx,%r14d
 108679a:	movzbl (%r9,%r14,1),%ebp
 108679f:	cmp    $0x9,%ebp
 10867a2:	jg     1086770 <check_input_resolve_range+0x40d0>
 10867a4:	cmp    $0x6,%ebp
 10867a7:	je     1086775 <check_input_resolve_range+0x40d5>
 10867a9:	cmp    $0x8,%ebp
 10867ac:	je     1086775 <check_input_resolve_range+0x40d5>
 10867ae:	jmp    10867b9 <check_input_resolve_range+0x4119>
 10867b0:	cmp    $0x33,%ebp
 10867b3:	je     1086b66 <check_input_resolve_range+0x44c6>
 10867b9:	inc    %ebx
 10867bb:	mov    %ebx,%ebp
 10867bd:	cmp    %edi,%ebp
 10867bf:	jb     1086797 <check_input_resolve_range+0x40f7>
 10867c1:	jmp    1086b68 <check_input_resolve_range+0x44c8>
 10867c6:	mov    %edx,%ecx
 10867c8:	jmp    10867e1 <check_input_resolve_range+0x4141>
 10867ca:	mov    %ecx,%ebp
 10867cc:	lea    0x2(%r13),%ecx
 10867d0:	cmp    %ebp,%ecx
 10867d2:	jb     1086ad0 <check_input_resolve_range+0x4430>
 10867d8:	jmp    1086ca3 <check_input_resolve_range+0x4603>
 10867dd:	xor    %edi,%edi
 10867df:	mov    %edx,%ecx
 10867e1:	mov    0x18(%rax),%r8
 10867e5:	lea    0x2(%r13),%r9d
 10867e9:	cmp    %edx,%r9d
 10867ec:	setb   %r10b
 10867f0:	cmp    %ecx,%edx
 10867f2:	setb   %r9b
 10867f6:	and    %dil,%r9b
 10867f9:	mov    (%r8,%rbp,4),%r8d
 10867fd:	and    %r10b,%r9b
 1086800:	cmp    $0x1,%r9b
 1086804:	jne    1086a30 <check_input_resolve_range+0x4390>
 108680a:	cmp    $0x28,%r8d
 108680e:	jne    1086a30 <check_input_resolve_range+0x4390>
 1086814:	inc    %edx
 1086816:	cmp    %ecx,%edx
 1086818:	jae    1088723 <check_input_resolve_range+0x6083>
 108681e:	xchg   %ax,%ax
 1086820:	mov    0x10(%rax),%rdi
 1086824:	mov    %edx,%r8d
 1086827:	jmp    1086855 <check_input_resolve_range+0x41b5>
 1086829:	nopl   0x0(%rax)
 1086830:	cmp    $0xa,%r9d
 1086834:	jne    1086871 <check_input_resolve_range+0x41d1>
 1086836:	mov    0x60(%rax),%r9
 108683a:	mov    (%r9,%rsi,4),%r9d
 108683e:	lea    0x1(%r9),%esi
 1086842:	cmp    %ecx,%r9d
 1086845:	cmovae %ecx,%esi
 1086848:	cmp    %r8d,%r9d
 108684b:	cmovbe %ecx,%esi
 108684e:	mov    %esi,%r8d
 1086851:	cmp    %ecx,%esi
 1086853:	jae    1086889 <check_input_resolve_range+0x41e9>
 1086855:	mov    %r8d,%esi
 1086858:	movzbl (%rdi,%rsi,1),%r9d
 108685d:	cmp    $0x9,%r9d
 1086861:	jg     1086830 <check_input_resolve_range+0x4190>
 1086863:	cmp    $0x6,%r9d
 1086867:	je     1086836 <check_input_resolve_range+0x4196>
 1086869:	cmp    $0x8,%r9d
 108686d:	je     1086836 <check_input_resolve_range+0x4196>
 108686f:	jmp    1086877 <check_input_resolve_range+0x41d7>
 1086871:	cmp    $0x2f,%r9d
 1086875:	je     1086886 <check_input_resolve_range+0x41e6>
 1086877:	inc    %r8d
 108687a:	mov    %r8d,%esi
 108687d:	mov    %esi,%r8d
 1086880:	cmp    %ecx,%esi
 1086882:	jb     1086855 <check_input_resolve_range+0x41b5>
 1086884:	jmp    1086889 <check_input_resolve_range+0x41e9>
 1086886:	mov    %r8d,%esi
 1086889:	cmp    %ecx,%esi
 108688b:	jae    108872c <check_input_resolve_range+0x608c>
 1086891:	lea    0x1(%rsi),%r9d
 1086895:	cmp    %ecx,%r9d
 1086898:	jae    108872c <check_input_resolve_range+0x608c>
 108689e:	mov    %r9d,%r10d
 10868a1:	jmp    10868d8 <check_input_resolve_range+0x4238>
 10868a3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10868b0:	cmp    $0xa,%r11d
 10868b4:	jne    10868f4 <check_input_resolve_range+0x4254>
 10868b6:	mov    0x60(%rax),%r11
 10868ba:	mov    (%r11,%r8,4),%r11d
 10868be:	lea    0x1(%r11),%r8d
 10868c2:	cmp    %ecx,%r11d
 10868c5:	cmovae %ecx,%r8d
 10868c9:	cmp    %r10d,%r11d
 10868cc:	cmovbe %ecx,%r8d
 10868d0:	mov    %r8d,%r10d
 10868d3:	cmp    %ecx,%r8d
 10868d6:	jae    108690a <check_input_resolve_range+0x426a>
 10868d8:	mov    %r10d,%r8d
 10868db:	movzbl (%rdi,%r8,1),%r11d
 10868e0:	cmp    $0x9,%r11d
 10868e4:	jg     10868b0 <check_input_resolve_range+0x4210>
 10868e6:	cmp    $0x6,%r11d
 10868ea:	je     10868b6 <check_input_resolve_range+0x4216>
 10868ec:	cmp    $0x8,%r11d
 10868f0:	je     10868b6 <check_input_resolve_range+0x4216>
 10868f2:	jmp    10868fa <check_input_resolve_range+0x425a>
 10868f4:	cmp    $0x33,%r11d
 10868f8:	je     1086907 <check_input_resolve_range+0x4267>
 10868fa:	inc    %r10d
 10868fd:	mov    %r10d,%r8d
 1086900:	cmp    %ecx,%r8d
 1086903:	jb     10868d8 <check_input_resolve_range+0x4238>
 1086905:	jmp    108690a <check_input_resolve_range+0x426a>
 1086907:	mov    %r10d,%r8d
 108690a:	cmp    %esi,%edx
 108690c:	jae    108872c <check_input_resolve_range+0x608c>
 1086912:	cmp    %r8d,%r9d
 1086915:	jae    108872c <check_input_resolve_range+0x608c>
 108691b:	mov    %edx,%r10d
 108691e:	movzbl (%rdi,%r10,1),%edi
 1086923:	mov    0x1a8(%rbx),%r11
 108692a:	mov    $0x0,%r9d
 1086930:	cmp    $0x4b,%dil
 1086934:	cmovne %esi,%r9d
 1086938:	mov    %r9d,(%r11,%r10,4)
 108693c:	mov    %esi,%r11d
 108693f:	sub    %edx,%r11d
 1086942:	mov    %r10,%r9
 1086945:	and    $0x7,%r11d
 1086949:	je     108696e <check_input_resolve_range+0x42ce>
 108694b:	mov    %r10,%r9
 108694e:	xchg   %ax,%ax
 1086950:	mov    0x8(%rsp),%rbx
 1086955:	mov    0x138(%rbx),%rbx
 108695c:	movb   $0x1,(%rbx,%r9,1)
 1086961:	mov    0x8(%rsp),%rbx
 1086966:	inc    %r9
 1086969:	dec    %r11
 108696c:	jne    1086950 <check_input_resolve_range+0x42b0>
 108696e:	mov    %esi,%r11d
 1086971:	sub    %r11,%r10
 1086974:	cmp    $0xfffffffffffffff8,%r10
 1086978:	ja     10869f0 <check_input_resolve_range+0x4350>
 108697a:	nopw   0x0(%rax,%rax,1)
 1086980:	mov    0x138(%rbx),%r10
 1086987:	movb   $0x1,(%r10,%r9,1)
 108698c:	mov    0x138(%rbx),%r10
 1086993:	movb   $0x1,0x1(%r10,%r9,1)
 1086999:	mov    0x138(%rbx),%r10
 10869a0:	movb   $0x1,0x2(%r10,%r9,1)
 10869a6:	mov    0x138(%rbx),%r10
 10869ad:	movb   $0x1,0x3(%r10,%r9,1)
 10869b3:	mov    0x138(%rbx),%r10
 10869ba:	movb   $0x1,0x4(%r10,%r9,1)
 10869c0:	mov    0x138(%rbx),%r10
 10869c7:	movb   $0x1,0x5(%r10,%r9,1)
 10869cd:	mov    0x138(%rbx),%r10
 10869d4:	movb   $0x1,0x6(%r10,%r9,1)
 10869da:	mov    0x138(%rbx),%r10
 10869e1:	movb   $0x1,0x7(%r10,%r9,1)
 10869e7:	add    $0x8,%r9
 10869eb:	cmp    %r9,%r11
 10869ee:	jne    1086980 <check_input_resolve_range+0x42e0>
 10869f0:	cmp    $0x4b,%dil
 10869f4:	setne  %dil
 10869f8:	inc    %edx
 10869fa:	cmp    %esi,%edx
 10869fc:	sete   %sil
 1086a00:	inc    %r8d
 1086a03:	or     %dil,%sil
 1086a06:	cmp    %ecx,%r8d
 1086a09:	jae    1086a17 <check_input_resolve_range+0x4377>
 1086a0b:	mov    %r8d,%edx
 1086a0e:	test   %sil,%sil
 1086a11:	jne    1086820 <check_input_resolve_range+0x4180>
 1086a17:	test   %sil,%sil
 1086a1a:	je     108872c <check_input_resolve_range+0x608c>
 1086a20:	mov    0x138(%rbx),%rsi
 1086a27:	movb   $0x1,(%rsi,%rbp,1)
 1086a2b:	jmp    10864b0 <check_input_resolve_range+0x3e10>
 1086a30:	cmp    $0x4c,%r8d
 1086a34:	sete   %dil
 1086a38:	and    %dil,%r9b
 1086a3b:	cmp    $0x1,%r9b
 1086a3f:	jne    108872c <check_input_resolve_range+0x608c>
 1086a45:	inc    %edx
 1086a47:	cmp    %ecx,%edx
 1086a49:	jae    108872c <check_input_resolve_range+0x608c>
 1086a4f:	mov    0x10(%rax),%rdi
 1086a53:	mov    %edx,%r9d
 1086a56:	jmp    1086a8c <check_input_resolve_range+0x43ec>
 1086a58:	nopl   0x0(%rax,%rax,1)
 1086a60:	cmp    $0xa,%r10d
 1086a64:	jne    1086aa8 <check_input_resolve_range+0x4408>
 1086a66:	mov    0x60(%rax),%r10
 1086a6a:	mov    (%r10,%r8,4),%r10d
 1086a6e:	lea    0x1(%r10),%r8d
 1086a72:	cmp    %ecx,%r10d
 1086a75:	cmovae %ecx,%r8d
 1086a79:	cmp    %r9d,%r10d
 1086a7c:	cmovbe %ecx,%r8d
 1086a80:	mov    %r8d,%r9d
 1086a83:	cmp    %ecx,%r8d
 1086a86:	jae    1086c21 <check_input_resolve_range+0x4581>
 1086a8c:	mov    %r9d,%r8d
 1086a8f:	movzbl (%rdi,%r8,1),%r10d
 1086a94:	cmp    $0x9,%r10d
 1086a98:	jg     1086a60 <check_input_resolve_range+0x43c0>
 1086a9a:	cmp    $0x6,%r10d
 1086a9e:	je     1086a66 <check_input_resolve_range+0x43c6>
 1086aa0:	cmp    $0x8,%r10d
 1086aa4:	je     1086a66 <check_input_resolve_range+0x43c6>
 1086aa6:	jmp    1086ab2 <check_input_resolve_range+0x4412>
 1086aa8:	cmp    $0x33,%r10d
 1086aac:	je     1086c1e <check_input_resolve_range+0x457e>
 1086ab2:	inc    %r9d
 1086ab5:	mov    %r9d,%r8d
 1086ab8:	cmp    %ecx,%r8d
 1086abb:	jb     1086a8c <check_input_resolve_range+0x43ec>
 1086abd:	jmp    1086c21 <check_input_resolve_range+0x4581>
 1086ac2:	mov    %edx,%ebp
 1086ac4:	lea    0x2(%r13),%ecx
 1086ac8:	cmp    %ebp,%ecx
 1086aca:	jae    1086ca3 <check_input_resolve_range+0x4603>
 1086ad0:	mov    0x50(%r12),%rax
 1086ad5:	mov    %ecx,%r14d
 1086ad8:	nopl   0x0(%rax,%rax,1)
 1086ae0:	cmpb   $0x7,(%rax,%r14,1)
 1086ae5:	jne    1086af4 <check_input_resolve_range+0x4454>
 1086ae7:	inc    %r14
 1086aea:	cmp    %r14d,%ebp
 1086aed:	jne    1086ae0 <check_input_resolve_range+0x4440>
 1086aef:	jmp    1086ca3 <check_input_resolve_range+0x4603>
 1086af4:	mov    0x10(%r12),%rbx
 1086af9:	movzbl (%rbx,%r14,1),%eax
 1086afe:	add    $0xcb,%al
 1086b00:	cmp    $0x1,%al
 1086b02:	ja     1086ca3 <check_input_resolve_range+0x4603>
 1086b08:	mov    %r12,%rdi
 1086b0b:	mov    %r14d,%esi
 1086b0e:	mov    %ebp,%edx
 1086b10:	vzeroupper
 1086b13:	call   1095860 <check_input_tag_body>
 1086b18:	cmp    %ebp,%eax
 1086b1a:	jae    1086ca3 <check_input_resolve_range+0x4603>
 1086b20:	mov    %eax,%eax
 1086b22:	cmpb   $0xa,(%rbx,%rax,1)
 1086b26:	jne    1086ca3 <check_input_resolve_range+0x4603>
 1086b2c:	mov    0x8(%rsp),%rdi
 1086b31:	mov    %r14d,%esi
 1086b34:	mov    %ebp,%edx
 1086b36:	call   1095b50 <check_input_tag_definition>
 1086b3b:	jmp    1086ca3 <check_input_resolve_range+0x4603>
 1086b40:	mov    %edx,%edi
 1086b42:	jmp    108673a <check_input_resolve_range+0x409a>
 1086b47:	mov    0x8(%rsp),%rbx
 1086b4c:	mov    %edx,%edi
 1086b4e:	jmp    108673a <check_input_resolve_range+0x409a>
 1086b53:	xor    %esi,%esi
 1086b55:	mov    %edx,%edi
 1086b57:	jmp    108673a <check_input_resolve_range+0x409a>
 1086b5c:	mov    %edx,%edi
 1086b5e:	mov    %r11d,%edx
 1086b61:	jmp    108673a <check_input_resolve_range+0x409a>
 1086b66:	mov    %ebx,%ebp
 1086b68:	cmp    %edi,%ebp
 1086b6a:	mov    0x8(%rsp),%rbx
 1086b6f:	mov    0x28(%rsp),%rbp
 1086b74:	setne  %cl
 1086b77:	xor    $0x1,%sil
 1086b7b:	or     %cl,%sil
 1086b7e:	jne    1086bcd <check_input_resolve_range+0x452d>
 1086b80:	mov    0x208(%rbx),%r9
 1086b87:	mov    %edi,%ecx
 1086b89:	cmp    $0x7e,%eax
 1086b8c:	mov    $0x1,%esi
 1086b91:	cmove  %r11d,%r10d
 1086b95:	cmovne %edi,%edx
 1086b98:	sub    %r10d,%edx
 1086b9b:	mov    %r8w,(%r9,%rcx,2)
 1086ba0:	mov    0x210(%rbx),%rax
 1086ba7:	mov    %edi,(%rax,%r10,4)
 1086bab:	mov    0x138(%rbx),%rax
 1086bb2:	movb   $0x1,(%rax,%rbp,1)
 1086bb6:	mov    0x138(%rbx),%rdi
 1086bbd:	add    %r10,%rdi
 1086bc0:	vzeroupper
 1086bc3:	call   788120 <memset@plt>
 1086bc8:	jmp    108649f <check_input_resolve_range+0x3dff>
 1086bcd:	mov    (%rbx),%rax
 1086bd0:	mov    0x230(%rax),%ecx
 1086bd6:	cmp    0x234(%rax),%ecx
 1086bdc:	jae    1086c12 <check_input_resolve_range+0x4572>
 1086bde:	movzbl 0x3bd(%rax),%edx
 1086be5:	mov    0x228(%rax),%rsi
 1086bec:	lea    0x1(%rcx),%edi
 1086bef:	mov    %edi,0x230(%rax)
 1086bf5:	lea    (%rcx,%rcx,2),%rax
 1086bf9:	lea    0x1(%rdx,%rdx,2),%edx
 1086bfd:	mov    %r13d,(%rsi,%rax,4)
 1086c01:	mov    %edx,0x4(%rsi,%rax,4)
 1086c05:	movl   $0x0,0x8(%rsi,%rax,4)
 1086c0d:	jmp    108649f <check_input_resolve_range+0x3dff>
 1086c12:	movb   $0x1,0x3bd(%rax)
 1086c19:	jmp    108649f <check_input_resolve_range+0x3dff>
 1086c1e:	mov    %r9d,%r8d
 1086c21:	cmp    %r8d,%edx
 1086c24:	jae    108872c <check_input_resolve_range+0x608c>
 1086c2a:	inc    %r8d
 1086c2d:	cmp    %ecx,%r8d
 1086c30:	jb     1086c60 <check_input_resolve_range+0x45c0>
 1086c32:	jmp    108872c <check_input_resolve_range+0x608c>
 1086c37:	cmp    $0xa,%r9d
 1086c3b:	jne    1086c7c <check_input_resolve_range+0x45dc>
 1086c3d:	mov    0x60(%rax),%r9
 1086c41:	mov    (%r9,%rdx,4),%r9d
 1086c45:	lea    0x1(%r9),%edx
 1086c49:	cmp    %ecx,%r9d
 1086c4c:	cmovae %ecx,%edx
 1086c4f:	cmp    %r8d,%r9d
 1086c52:	cmovbe %ecx,%edx
 1086c55:	mov    %edx,%r8d
 1086c58:	cmp    %ecx,%edx
 1086c5a:	jae    108871f <check_input_resolve_range+0x607f>
 1086c60:	mov    %r8d,%edx
 1086c63:	movzbl (%rdi,%rdx,1),%r9d
 1086c68:	cmp    $0x9,%r9d
 1086c6c:	jg     1086c37 <check_input_resolve_range+0x4597>
 1086c6e:	cmp    $0x6,%r9d
 1086c72:	je     1086c3d <check_input_resolve_range+0x459d>
 1086c74:	cmp    $0x8,%r9d
 1086c78:	je     1086c3d <check_input_resolve_range+0x459d>
 1086c7a:	jmp    1086c86 <check_input_resolve_range+0x45e6>
 1086c7c:	cmp    $0x33,%r9d
 1086c80:	je     108871c <check_input_resolve_range+0x607c>
 1086c86:	inc    %r8d
 1086c89:	mov    %r8d,%edx
 1086c8c:	cmp    %ecx,%edx
 1086c8e:	jb     1086c60 <check_input_resolve_range+0x45c0>
 1086c90:	jmp    108871f <check_input_resolve_range+0x607f>
 1086c95:	mov    %edx,%ebp
 1086c97:	lea    0x2(%r13),%ecx
 1086c9b:	cmp    %ebp,%ecx
 1086c9d:	jb     1086ad0 <check_input_resolve_range+0x4430>
 1086ca3:	mov    0x8(%rsp),%rbx
 1086ca8:	mov    0x28(%rsp),%rbp
 1086cad:	mov    (%rbx),%rax
 1086cb0:	cmpl   $0x0,0x230(%rax)
 1086cb7:	jne    1086f00 <check_input_resolve_range+0x4860>
 1086cbd:	cmpb   $0x0,0x3bd(%rax)
 1086cc4:	jne    1086f00 <check_input_resolve_range+0x4860>
 1086cca:	mov    0x8(%rbx),%rax
 1086cce:	mov    %r15d,%ecx
 1086cd1:	mov    0x30(%rax),%edx
 1086cd4:	mov    %edx,%r14d
 1086cd7:	cmp    %edx,%r15d
 1086cda:	jae    1086ce4 <check_input_resolve_range+0x4644>
 1086cdc:	mov    0x60(%rax),%rsi
 1086ce0:	mov    (%rsi,%rcx,4),%r14d
 1086ce4:	mov    0x18(%rax),%rsi
 1086ce8:	vpxor  %xmm0,%xmm0,%xmm0
 1086cec:	mov    (%rsi,%rbp,4),%esi
 1086cef:	vmovdqu64 %zmm0,0x150(%rsp)
 1086cfa:	vmovdqu64 %zmm0,0x130(%rsp)
 1086d05:	add    $0xffffffb3,%esi
 1086d08:	cmp    $0x1,%esi
 1086d0b:	ja     1086ea9 <check_input_resolve_range+0x4809>
 1086d11:	cmp    %r14d,%r15d
 1086d14:	jae    1086ea9 <check_input_resolve_range+0x4809>
 1086d1a:	cmp    %edx,%r14d
 1086d1d:	jae    1086ea9 <check_input_resolve_range+0x4809>
 1086d23:	mov    0x50(%rax),%rax
 1086d27:	cmpb   $0x2f,(%rax,%rcx,1)
 1086d2b:	jne    1086ea9 <check_input_resolve_range+0x4809>
 1086d31:	lea    0x1(%r14),%edx
 1086d35:	mov    %rbx,%rdi
 1086d38:	mov    %r13d,%esi
 1086d3b:	xor    %ecx,%ecx
 1086d3d:	xor    %r8d,%r8d
 1086d40:	lea    0x130(%rsp),%r9
 1086d48:	push   $0x0
 1086d4a:	lea    0x208(%rsp),%rax
 1086d52:	push   %rax
 1086d53:	vzeroupper
 1086d56:	call   10c1fc0 <check_input_constant_read>
 1086d5b:	add    $0x10,%rsp
 1086d5f:	test   %al,%al
 1086d61:	je     1086ea9 <check_input_resolve_range+0x4809>
 1086d67:	cmpl   $0x0,0x184(%rsp)
 1086d6f:	jne    1086ea9 <check_input_resolve_range+0x4809>
 1086d75:	cmpl   $0x1,0x13c(%rsp)
 1086d7d:	jne    1086ea9 <check_input_resolve_range+0x4809>
 1086d83:	testb  $0x10,0x138(%rsp)
 1086d8b:	jne    1086ea9 <check_input_resolve_range+0x4809>
 1086d91:	mov    0x1c8(%rbx),%eax
 1086d97:	lea    0x1(%rax),%ecx
 1086d9a:	lea    (%rax,%rax,2),%rax
 1086d9e:	mov    %ecx,0x1c8(%rbx)
 1086da4:	vmovdqu64 0x130(%rsp),%zmm0
 1086daf:	vmovdqu64 0x150(%rsp),%zmm1
 1086dba:	mov    0x1b8(%rbx),%rdx
 1086dc1:	shl    $0x5,%rax
 1086dc5:	vmovdqu64 %zmm1,0x20(%rdx,%rax,1)
 1086dd0:	vmovdqu64 %zmm0,(%rdx,%rax,1)
 1086dd7:	mov    %r14d,%edx
 1086dda:	mov    0x1c0(%rbx),%rax
 1086de1:	mov    %ecx,(%rax,%rdx,4)
 1086de4:	mov    %r14d,%ecx
 1086de7:	sub    %r13d,%ecx
 1086dea:	jb     1086f00 <check_input_resolve_range+0x4860>
 1086df0:	lea    0x1(%rcx),%edx
 1086df3:	mov    %rbp,%rax
 1086df6:	and    $0x7,%edx
 1086df9:	je     1086e10 <check_input_resolve_range+0x4770>
 1086dfb:	mov    %rbp,%rax
 1086dfe:	mov    0x138(%rbx),%rsi
 1086e05:	movb   $0x1,(%rsi,%rax,1)
 1086e09:	inc    %rax
 1086e0c:	dec    %edx
 1086e0e:	jne    1086dfe <check_input_resolve_range+0x475e>
 1086e10:	cmp    $0x7,%ecx
 1086e13:	jb     1086f00 <check_input_resolve_range+0x4860>
 1086e19:	not    %r14d
 1086e1c:	xor    %ecx,%ecx
 1086e1e:	add    %rax,%r14
 1086e21:	mov    0x138(%rbx),%rdx
 1086e28:	add    %rax,%rdx
 1086e2b:	movb   $0x1,(%rcx,%rdx,1)
 1086e2f:	mov    0x138(%rbx),%rdx
 1086e36:	add    %rax,%rdx
 1086e39:	movb   $0x1,0x1(%rcx,%rdx,1)
 1086e3e:	mov    0x138(%rbx),%rdx
 1086e45:	add    %rax,%rdx
 1086e48:	movb   $0x1,0x2(%rcx,%rdx,1)
 1086e4d:	mov    0x138(%rbx),%rdx
 1086e54:	add    %rax,%rdx
 1086e57:	movb   $0x1,0x3(%rcx,%rdx,1)
 1086e5c:	mov    0x138(%rbx),%rdx
 1086e63:	add    %rax,%rdx
 1086e66:	movb   $0x1,0x4(%rcx,%rdx,1)
 1086e6b:	mov    0x138(%rbx),%rdx
 1086e72:	add    %rax,%rdx
 1086e75:	movb   $0x1,0x5(%rcx,%rdx,1)
 1086e7a:	mov    0x138(%rbx),%rdx
 1086e81:	add    %rax,%rdx
 1086e84:	movb   $0x1,0x6(%rcx,%rdx,1)
 1086e89:	mov    0x138(%rbx),%rdx
 1086e90:	add    %rax,%rdx
 1086e93:	movb   $0x1,0x7(%rcx,%rdx,1)
 1086e98:	add    $0x8,%rcx
 1086e9c:	mov    %r14d,%edx
 1086e9f:	add    %ecx,%edx
 1086ea1:	jne    1086e21 <check_input_resolve_range+0x4781>
 1086ea7:	jmp    1086f00 <check_input_resolve_range+0x4860>
 1086ea9:	mov    (%rbx),%rax
 1086eac:	mov    0x230(%rax),%ecx
 1086eb2:	cmp    0x234(%rax),%ecx
 1086eb8:	jae    1086eeb <check_input_resolve_range+0x484b>
 1086eba:	movzbl 0x3bd(%rax),%edx
 1086ec1:	mov    0x228(%rax),%rsi
 1086ec8:	lea    0x1(%rcx),%edi
 1086ecb:	mov    %edi,0x230(%rax)
 1086ed1:	lea    (%rcx,%rcx,2),%rax
 1086ed5:	lea    0x1(%rdx,%rdx,2),%edx
 1086ed9:	mov    %r13d,(%rsi,%rax,4)
 1086edd:	mov    %edx,0x4(%rsi,%rax,4)
 1086ee1:	movl   $0x0,0x8(%rsi,%rax,4)
 1086ee9:	jmp    1086f00 <check_input_resolve_range+0x4860>
 1086eeb:	movb   $0x1,0x3bd(%rax)
 1086ef2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1086f00:	mov    0x1a8(%rbx),%rax
 1086f07:	mov    (%rax,%rbp,4),%r14d
 1086f0b:	test   %r14,%r14
 1086f0e:	je     1087030 <check_input_resolve_range+0x4990>
 1086f14:	cmp    %r13d,%r14d
 1086f17:	jbe    1086ff0 <check_input_resolve_range+0x4950>
 1086f1d:	mov    $0x1,%ecx
 1086f22:	vpxor  %xmm0,%xmm0,%xmm0
 1086f26:	vmovdqu64 %zmm0,0x150(%rsp)
 1086f31:	vmovdqu64 %zmm0,0x130(%rsp)
 1086f3c:	movl   $0x0,0x200(%rsp)
 1086f47:	mov    %rbx,%rdi
 1086f4a:	mov    %r13d,%esi
 1086f4d:	mov    %r14d,%edx
 1086f50:	xor    %r8d,%r8d
 1086f53:	lea    0x130(%rsp),%r9
 1086f5b:	push   $0x0
 1086f5d:	lea    0x208(%rsp),%rax
 1086f65:	push   %rax
 1086f66:	vzeroupper
 1086f69:	call   10c1fc0 <check_input_constant_read>
 1086f6e:	add    $0x10,%rsp
 1086f72:	mov    0x18(%rbx),%rsi
 1086f76:	mov    0x200(%rsp),%ecx
 1086f7d:	test   %al,%al
 1086f7f:	mov    $0x0,%r8d
 1086f85:	mov    (%rsi),%rdx
 1086f88:	cmovne %ecx,%r8d
 1086f8c:	mov    %r8d,%eax
 1086f8f:	shr    $0x3,%eax
 1086f92:	cmpb   $0xf,(%rdx,%rax,1)
 1086f96:	jne    1086fad <check_input_resolve_range+0x490d>
 1086f98:	test   %r8d,%r8d
 1086f9b:	je     1086ff0 <check_input_resolve_range+0x4950>
 1086f9d:	mov    0x20(%rsi),%rdi
 1086fa1:	mov    (%rdi,%rax,4),%edi
 1086fa4:	mov    %edi,%r9d
 1086fa7:	shr    $0x3,%r9d
 1086fab:	jmp    1086fb7 <check_input_resolve_range+0x4917>
 1086fad:	mov    %ecx,%edi
 1086faf:	mov    %rax,%r9
 1086fb2:	test   %r8d,%r8d
 1086fb5:	je     1086ff0 <check_input_resolve_range+0x4950>
 1086fb7:	mov    0x10(%rsi),%rsi
 1086fbb:	testb  $0x4,(%rsi,%r9,1)
 1086fc0:	je     1086ff0 <check_input_resolve_range+0x4950>
 1086fc2:	shr    $0x3,%edi
 1086fc5:	movzbl (%rdx,%rdi,1),%edx
 1086fc9:	cmp    $0x1,%edx
 1086fcc:	je     1086ff0 <check_input_resolve_range+0x4950>
 1086fce:	cmp    $0xb,%edx
 1086fd1:	je     1086ff0 <check_input_resolve_range+0x4950>
 1086fd3:	testb  $0x8,(%rsi,%rax,1)
 1086fd7:	jne    1086ff0 <check_input_resolve_range+0x4950>
 1086fd9:	mov    0x1b0(%rbx),%rax
 1086fe0:	mov    %ecx,(%rax,%r14,4)
 1086fe4:	cmp    0xb8(%rsp),%r13d
 1086fec:	je     108704d <check_input_resolve_range+0x49ad>
 1086fee:	jmp    1087056 <check_input_resolve_range+0x49b6>
 1086ff0:	mov    (%rbx),%rax
 1086ff3:	mov    0x230(%rax),%ecx
 1086ff9:	cmp    0x234(%rax),%ecx
 1086fff:	jae    108703c <check_input_resolve_range+0x499c>
 1087001:	movzbl 0x3bd(%rax),%edx
 1087008:	mov    0x228(%rax),%rsi
 108700f:	lea    0x1(%rcx),%edi
 1087012:	mov    %edi,0x230(%rax)
 1087018:	lea    (%rcx,%rcx,2),%rax
 108701c:	lea    0x1(%rdx,%rdx,2),%edx
 1087020:	mov    %r13d,(%rsi,%rax,4)
 1087024:	mov    %edx,0x4(%rsi,%rax,4)
 1087028:	movl   $0x0,0x8(%rsi,%rax,4)
 1087030:	cmp    0xb8(%rsp),%r13d
 1087038:	je     108704d <check_input_resolve_range+0x49ad>
 108703a:	jmp    1087056 <check_input_resolve_range+0x49b6>
 108703c:	movb   $0x1,0x3bd(%rax)
 1087043:	cmp    0xb8(%rsp),%r13d
 108704b:	jne    1087056 <check_input_resolve_range+0x49b6>
 108704d:	cmpb   $0x0,0x458(%rbx)
 1087054:	jne    1087091 <check_input_resolve_range+0x49f1>
 1087056:	mov    0x2d0(%rbx),%rax
 108705d:	mov    0x28(%rsp),%rcx
 1087062:	mov    (%rax,%rcx,4),%ebp
 1087065:	cmp    $0xffffffff,%ebp
 1087068:	je     1087091 <check_input_resolve_range+0x49f1>
 108706a:	nopw   0x0(%rax,%rax,1)
 1087070:	mov    %rbx,%rdi
 1087073:	mov    %ebp,%esi
 1087075:	mov    %r13d,%edx
 1087078:	vzeroupper
 108707b:	call   1090540 <check_input_bind>
 1087080:	mov    0x2d8(%rbx),%rax
 1087087:	mov    %ebp,%ecx
 1087089:	mov    (%rax,%rcx,4),%ebp
 108708c:	cmp    $0xffffffff,%ebp
 108708f:	jne    1087070 <check_input_resolve_range+0x49d0>
 1087091:	mov    0x238(%rbx),%rax
 1087098:	mov    0x28(%rsp),%rbp
 108709d:	mov    %rbx,%rdi
 10870a0:	mov    (%rax,%rbp,4),%eax
 10870a3:	test   %eax,%eax
 10870a5:	je     10871a0 <check_input_resolve_range+0x4b00>
 10870ab:	mov    0x228(%rdi),%rbx
 10870b2:	dec    %eax
 10870b4:	imul   $0x2c,%rax,%rax
 10870b8:	cmpl   $0x2,0x20(%rbx,%rax,1)
 10870bd:	jne    10871a0 <check_input_resolve_range+0x4b00>
 10870c3:	add    %rax,%rbx
 10870c6:	vpxor  %xmm0,%xmm0,%xmm0
 10870ca:	xor    %ebp,%ebp
 10870cc:	mov    %r13d,%esi
 10870cf:	mov    $0x1,%ecx
 10870d4:	xor    %r8d,%r8d
 10870d7:	lea    0x130(%rsp),%r9
 10870df:	mov    0x1c(%rbx),%edx
 10870e2:	vmovdqu64 %zmm0,0x150(%rsp)
 10870ed:	vmovdqu64 %zmm0,0x130(%rsp)
 10870f8:	movl   $0x0,0x200(%rsp)
 1087103:	push   $0x0
 1087105:	lea    0x208(%rsp),%rax
 108710d:	push   %rax
 108710e:	vzeroupper
 1087111:	call   10c1fc0 <check_input_constant_read>
 1087116:	add    $0x10,%rsp
 108711a:	test   %al,%al
 108711c:	je     1087125 <check_input_resolve_range+0x4a85>
 108711e:	mov    0x200(%rsp),%ebp
 1087125:	mov    0x8(%rsp),%rdi
 108712a:	mov    %ebp,0x28(%rbx)
 108712d:	mov    0x1c(%rbx),%ecx
 1087130:	mov    0xa8(%rdi),%rax
 1087137:	mov    %ebp,(%rax,%rcx,4)
 108713a:	mov    0x28(%rsp),%rbp
 108713f:	cmpl   $0x0,0x28(%rbx)
 1087143:	jne    10871a0 <check_input_resolve_range+0x4b00>
 1087145:	mov    (%rdi),%rax
 1087148:	mov    0x230(%rax),%ecx
 108714e:	cmp    0x234(%rax),%ecx
 1087154:	jae    1087187 <check_input_resolve_range+0x4ae7>
 1087156:	movzbl 0x3bd(%rax),%edx
 108715d:	mov    0x228(%rax),%rsi
 1087164:	lea    0x1(%rcx),%edi
 1087167:	mov    %edi,0x230(%rax)
 108716d:	lea    (%rcx,%rcx,2),%rax
 1087171:	lea    0x1(%rdx,%rdx,2),%edx
 1087175:	mov    %r13d,(%rsi,%rax,4)
 1087179:	mov    %edx,0x4(%rsi,%rax,4)
 108717d:	movl   $0x0,0x8(%rsi,%rax,4)
 1087185:	jmp    108718e <check_input_resolve_range+0x4aee>
 1087187:	movb   $0x1,0x3bd(%rax)
 108718e:	mov    0x8(%rsp),%rdi
 1087193:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10871a0:	mov    0x210(%rdi),%rax
 10871a7:	mov    %rdi,%rbx
 10871aa:	mov    (%rax,%rbp,4),%r14d
 10871ae:	test   %r14,%r14
 10871b1:	je     10872ab <check_input_resolve_range+0x4c0b>
 10871b7:	mov    0x208(%rbx),%rax
 10871be:	cmpw   $0x317,(%rax,%r14,2)
 10871c5:	jne    108722e <check_input_resolve_range+0x4b8e>
 10871c7:	mov    %r13d,%edx
 10871ca:	cmp    %r14d,%r13d
 10871cd:	jae    1087231 <check_input_resolve_range+0x4b91>
 10871cf:	mov    0x8(%rbx),%rax
 10871d3:	mov    %r13d,%esi
 10871d6:	mov    0x10(%rax),%rcx
 10871da:	jmp    1087203 <check_input_resolve_range+0x4b63>
 10871dc:	nopl   0x0(%rax)
 10871e0:	cmp    $0xa,%edi
 10871e3:	jne    108721a <check_input_resolve_range+0x4b7a>
 10871e5:	mov    0x60(%rax),%rdi
 10871e9:	mov    (%rdi,%rdx,4),%edi
 10871ec:	lea    0x1(%rdi),%edx
 10871ef:	cmp    %r14d,%edi
 10871f2:	cmovae %r14d,%edx
 10871f6:	cmp    %esi,%edi
 10871f8:	cmovbe %r14d,%edx
 10871fc:	mov    %edx,%esi
 10871fe:	cmp    %r14d,%edx
 1087201:	jae    1087231 <check_input_resolve_range+0x4b91>
 1087203:	mov    %esi,%edx
 1087205:	movzbl (%rcx,%rdx,1),%edi
 1087209:	cmp    $0x9,%edi
 108720c:	jg     10871e0 <check_input_resolve_range+0x4b40>
 108720e:	cmp    $0x6,%edi
 1087211:	je     10871e5 <check_input_resolve_range+0x4b45>
 1087213:	cmp    $0x8,%edi
 1087216:	je     10871e5 <check_input_resolve_range+0x4b45>
 1087218:	jmp    1087223 <check_input_resolve_range+0x4b83>
 108721a:	cmp    $0x33,%edi
 108721d:	je     1087c15 <check_input_resolve_range+0x5575>
 1087223:	inc    %esi
 1087225:	mov    %esi,%edx
 1087227:	cmp    %r14d,%edx
 108722a:	jb     1087203 <check_input_resolve_range+0x4b63>
 108722c:	jmp    1087231 <check_input_resolve_range+0x4b91>
 108722e:	mov    %r14d,%edx
 1087231:	vpxor  %xmm0,%xmm0,%xmm0
 1087235:	vmovdqu64 %zmm0,0x150(%rsp)
 1087240:	mov    %rbx,%rdi
 1087243:	xor    %ebx,%ebx
 1087245:	vmovdqu64 %zmm0,0x130(%rsp)
 1087250:	movl   $0x0,0x200(%rsp)
 108725b:	mov    %r13d,%esi
 108725e:	mov    $0x1,%ecx
 1087263:	xor    %r8d,%r8d
 1087266:	lea    0x130(%rsp),%r9
 108726e:	push   $0x0
 1087270:	lea    0x208(%rsp),%rax
 1087278:	push   %rax
 1087279:	vzeroupper
 108727c:	call   10c1fc0 <check_input_constant_read>
 1087281:	add    $0x10,%rsp
 1087285:	test   %al,%al
 1087287:	je     1087290 <check_input_resolve_range+0x4bf0>
 1087289:	mov    0x200(%rsp),%ebx
 1087290:	mov    0x8(%rsp),%rcx
 1087295:	test   %ebx,%ebx
 1087297:	mov    0xa8(%rcx),%rax
 108729e:	mov    %ebx,(%rax,%r14,4)
 10872a2:	mov    %rcx,%rbx
 10872a5:	je     10875d8 <check_input_resolve_range+0x4f38>
 10872ab:	mov    0x138(%rbx),%rax
 10872b2:	cmpb   $0x0,(%rax,%rbp,1)
 10872b6:	je     1087643 <check_input_resolve_range+0x4fa3>
 10872bc:	mov    0x140(%rbx),%rax
 10872c3:	cmpb   $0x0,(%rax,%rbp,1)
 10872c7:	je     1087304 <check_input_resolve_range+0x4c64>
 10872c9:	mov    0x150(%rbx),%rax
 10872d0:	mov    $0xffffffff,%ecx
 10872d5:	mov    (%rax,%rbp,4),%eax
 10872d8:	cmp    %rcx,%rax
 10872db:	je     1087304 <check_input_resolve_range+0x4c64>
 10872dd:	mov    (%rbx),%rcx
 10872e0:	mov    0x3c0(%rbx),%edx
 10872e6:	mov    0x2b8(%rcx),%rsi
 10872ed:	cmp    %edx,(%rsi,%rax,4)
 10872f0:	ja     1088a09 <check_input_resolve_range+0x6369>
 10872f6:	mov    %rbx,%rdi
 10872f9:	mov    %r13d,%esi
 10872fc:	vzeroupper
 10872ff:	call   109a260 <check_input_initializer_prepare>
 1087304:	mov    0x138(%rbx),%rax
 108730b:	mov    0x48(%rsp),%r12
 1087310:	movzbl (%rax,%rbp,1),%eax
 1087314:	test   %al,%al
 1087316:	je     1087334 <check_input_resolve_range+0x4c94>
 1087318:	mov    0x290(%rbx),%rcx
 108731f:	cmpl   $0x0,(%rcx,%rbp,4)
 1087323:	jne    1087360 <check_input_resolve_range+0x4cc0>
 1087325:	movzbl 0x50(%rsp),%r14d
 108732b:	test   %al,%al
 108732d:	jne    1087383 <check_input_resolve_range+0x4ce3>
 108732f:	jmp    10873ce <check_input_resolve_range+0x4d2e>
 1087334:	cmpb   $0x7,0x50(%rsp)
 1087339:	je     1087360 <check_input_resolve_range+0x4cc0>
 108733b:	cmpl   $0x3f,0x3c(%rsp)
 1087340:	ja     1087bb8 <check_input_resolve_range+0x5518>
 1087346:	mov    0x3c(%rsp),%ecx
 108734a:	movabs $0x8160000000000000,%rdx
 1087354:	bt     %rcx,%rdx
 1087358:	jae    1087bb8 <check_input_resolve_range+0x5518>
 108735e:	xchg   %ax,%ax
 1087360:	mov    %rbx,%rdi
 1087363:	mov    %r13d,%esi
 1087366:	vzeroupper
 1087369:	call   10929a0 <check_input_declaration>
 108736e:	mov    0x138(%rbx),%rax
 1087375:	movzbl (%rax,%rbp,1),%eax
 1087379:	movzbl 0x50(%rsp),%r14d
 108737f:	test   %al,%al
 1087381:	je     10873ce <check_input_resolve_range+0x4d2e>
 1087383:	vpbroadcastq -0xadafbd(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108738d:	vpbroadcastd -0xadb7b6(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1087396:	vpbroadcastq -0xadafc0(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10873a0:	vpbroadcastd -0xadb7ca(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10873aa:	vpbroadcastq -0xadafdc(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10873b4:	cmpb   $0x31,0x50(%rsp)
 10873b9:	je     1087c41 <check_input_resolve_range+0x55a1>
 10873bf:	cmp    $0x1a,%r14d
 10873c3:	je     10878d5 <check_input_resolve_range+0x5235>
 10873c9:	jmp    1087ca0 <check_input_resolve_range+0x5600>
 10873ce:	vpbroadcastq -0xadb008(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10873d8:	vpbroadcastd -0xadb801(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10873e1:	vpbroadcastq -0xadb00b(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10873eb:	vpbroadcastd -0xadb815(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10873f5:	vpbroadcastq -0xadb027(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10873ff:	cmpb   $0x34,0x50(%rsp)
 1087404:	ja     1087ca0 <check_input_resolve_range+0x5600>
 108740a:	movabs $0x1b000000000000,%rax
 1087414:	bt     %r14,%rax
 1087418:	jae    10878cb <check_input_resolve_range+0x522b>
 108741e:	mov    0x60(%r12),%rax
 1087423:	mov    0x50(%rbx),%ecx
 1087426:	mov    0x398(%rbx),%rdx
 108742d:	mov    0x3b0(%rbx),%esi
 1087433:	mov    (%rax,%rbp,4),%eax
 1087436:	mov    %ecx,(%rdx,%rsi,4)
 1087439:	mov    0x3a8(%rbx),%rcx
 1087440:	mov    0x3b0(%rbx),%edx
 1087446:	mov    %r13d,(%rcx,%rdx,4)
 108744a:	mov    0x30(%r12),%ecx
 108744f:	cmp    %ecx,%eax
 1087451:	jae    108745d <check_input_resolve_range+0x4dbd>
 1087453:	mov    0x368(%rbx),%rcx
 108745a:	mov    (%rcx,%rax,4),%ecx
 108745d:	mov    0x3a0(%rbx),%rax
 1087464:	mov    0x3b0(%rbx),%edx
 108746a:	cmpb   $0x31,0x50(%rsp)
 108746f:	mov    %ecx,(%rax,%rdx,4)
 1087472:	mov    0x3b0(%rbx),%eax
 1087478:	lea    0x1(%rax),%ecx
 108747b:	mov    %ecx,0x3b0(%rbx)
 1087481:	je     1087c41 <check_input_resolve_range+0x55a1>
 1087487:	cmp    $0x34,%r14d
 108748b:	jne    1087ca0 <check_input_resolve_range+0x5600>
 1087491:	mov    0xa8(%rbx),%rdx
 1087498:	mov    (%rbx),%rcx
 108749b:	mov    (%rdx,%rbp,4),%edx
 108749e:	mov    %edx,0x3b4(%rbx)
 10874a4:	mov    0x3a0(%rbx),%rdx
 10874ab:	mov    (%rdx,%rax,4),%eax
 10874ae:	mov    %eax,0x3b8(%rbx)
 10874b4:	mov    %r13d,0x3bc(%rbx)
 10874bb:	mov    0x2d8(%rcx),%rax
 10874c2:	cmpl   $0xffffffff,(%rax,%rbp,4)
 10874c6:	je     10879f7 <check_input_resolve_range+0x5357>
 10874cc:	mov    0x308(%rbx),%rax
 10874d3:	mov    (%rax,%rbp,4),%edx
 10874d6:	jmp    10874fb <check_input_resolve_range+0x4e5b>
 10874d8:	nopl   0x0(%rax,%rax,1)
 10874e0:	movb   $0x0,0x98(%rbx)
 10874e7:	mov    (%rbx),%rax
 10874ea:	movb   $0x1,0x3bd(%rax)
 10874f1:	mov    0x310(%rbx),%rax
 10874f8:	mov    (%rax,%rcx,4),%edx
 10874fb:	cmp    $0xffffffff,%edx
 10874fe:	je     10879f7 <check_input_resolve_range+0x5357>
 1087504:	mov    0x40(%rbx),%eax
 1087507:	mov    $0x1,%sil
 108750a:	cmp    0x9c(%rbx),%eax
 1087510:	je     1087521 <check_input_resolve_range+0x4e81>
 1087512:	mov    0x68(%rbx),%rcx
 1087516:	lea    -0x1(%rax),%esi
 1087519:	cmp    (%rcx,%rsi,4),%r13d
 108751d:	setae  %sil
 1087521:	cmpb   $0x1,0x98(%rbx)
 1087528:	mov    %edx,%ecx
 108752a:	jne    10874e0 <check_input_resolve_range+0x4e40>
 108752c:	mov    0x18(%r12),%rdi
 1087531:	cmp    0x3c(%rbx),%eax
 1087534:	mov    (%rdi,%rcx,4),%r8d
 1087538:	setb   %dil
 108753c:	test   %r8d,%r8d
 108753f:	je     10874e0 <check_input_resolve_range+0x4e40>
 1087541:	and    %sil,%dil
 1087544:	je     10874e0 <check_input_resolve_range+0x4e40>
 1087546:	mov    0x38(%rbx),%esi
 1087549:	mov    0x3b0(%rbx),%r9d
 1087550:	cmp    %esi,%r8d
 1087553:	setb   0x98(%rbx)
 108755a:	jae    10874e7 <check_input_resolve_range+0x4e47>
 108755c:	lea    0x1(%rax),%edi
 108755f:	add    %r8d,%esi
 1087562:	mov    %edi,0x40(%rbx)
 1087565:	mov    0x58(%rbx),%r8
 1087569:	mov    %esi,(%r8,%rax,4)
 108756d:	mov    0x60(%rbx),%r8
 1087571:	mov    %edx,(%r8,%rax,4)
 1087575:	mov    0x68(%rbx),%rdx
 1087579:	mov    %r13d,(%rdx,%rax,4)
 108757d:	mov    0x70(%rbx),%rdx
 1087581:	movl   $0xffffffff,(%rdx,%rax,4)
 1087588:	mov    0x80(%rbx),%rdx
 108758f:	mov    %r9d,(%rdx,%rax,4)
 1087593:	mov    0x88(%rbx),%rdx
 108759a:	movb   $0x0,(%rdx,%rax,1)
 108759e:	mov    0x90(%rbx),%rdx
 10875a5:	movb   $0x4,(%rdx,%rax,1)
 10875a9:	mov    0x30(%rbx),%rdx
 10875ad:	mov    0x78(%rbx),%r8
 10875b1:	mov    (%rdx,%rsi,4),%edx
 10875b4:	mov    %edx,(%r8,%rax,4)
 10875b8:	mov    0x50(%rbx),%r8d
 10875bc:	mov    0x48(%rbx),%rdx
 10875c0:	lea    0x1(%r8),%r9d
 10875c4:	mov    %r9d,0x50(%rbx)
 10875c8:	mov    %eax,(%rdx,%r8,4)
 10875cc:	mov    0x30(%rbx),%rax
 10875d0:	mov    %edi,(%rax,%rsi,4)
 10875d3:	jmp    10874f1 <check_input_resolve_range+0x4e51>
 10875d8:	mov    (%rbx),%rax
 10875db:	mov    0x230(%rax),%ecx
 10875e1:	cmp    0x234(%rax),%ecx
 10875e7:	jae    108762b <check_input_resolve_range+0x4f8b>
 10875e9:	movzbl 0x3bd(%rax),%edx
 10875f0:	mov    0x228(%rax),%rsi
 10875f7:	lea    0x1(%rcx),%edi
 10875fa:	mov    %edi,0x230(%rax)
 1087600:	lea    (%rcx,%rcx,2),%rax
 1087604:	lea    0x1(%rdx,%rdx,2),%edx
 1087608:	mov    %r13d,(%rsi,%rax,4)
 108760c:	mov    %edx,0x4(%rsi,%rax,4)
 1087610:	movl   $0x0,0x8(%rsi,%rax,4)
 1087618:	mov    0x138(%rbx),%rax
 108761f:	cmpb   $0x0,(%rax,%rbp,1)
 1087623:	jne    10872bc <check_input_resolve_range+0x4c1c>
 1087629:	jmp    1087643 <check_input_resolve_range+0x4fa3>
 108762b:	movb   $0x1,0x3bd(%rax)
 1087632:	mov    0x138(%rbx),%rax
 1087639:	cmpb   $0x0,(%rax,%rbp,1)
 108763d:	jne    10872bc <check_input_resolve_range+0x4c1c>
 1087643:	mov    0x48(%rsp),%rdx
 1087648:	mov    0x30(%rdx),%eax
 108764b:	cmp    %eax,%r13d
 108764e:	jae    10876a0 <check_input_resolve_range+0x5000>
 1087650:	mov    0x10(%rdx),%rcx
 1087654:	mov    0x18(%rdx),%rdx
 1087658:	movzbl (%rcx,%rbp,1),%esi
 108765c:	mov    (%rdx,%rbp,4),%edx
 108765f:	vmovd  %esi,%xmm0
 1087663:	cmp    $0x6,%esi
 1087666:	vpinsrd $0x1,%edx,%xmm0,%xmm0
 108766c:	sete   %cl
 108766f:	cmp    $0x6b,%edx
 1087672:	vpshufd $0x50,%xmm0,%xmm0
 1087677:	vpand  -0xaf836f(%rip),%xmm0,%xmm0        # 58f310 <abi_test_hex.digits+0xb40>
 108767f:	sete   %sil
 1087683:	vpcmpeqd -0xaf836d(%rip),%xmm0,%k0        # 58f320 <abi_test_hex.digits+0xb50>
 108768d:	kortestb %k0,%k0
 1087691:	setne  %dl
 1087694:	or     %sil,%dl
 1087697:	test   %dl,%dl
 1087699:	jne    10876ac <check_input_resolve_range+0x500c>
 108769b:	jmp    108789d <check_input_resolve_range+0x51fd>
 10876a0:	xor    %ecx,%ecx
 10876a2:	xor    %edx,%edx
 10876a4:	test   %dl,%dl
 10876a6:	je     108789d <check_input_resolve_range+0x51fd>
 10876ac:	mov    0x8(%rbx),%r14
 10876b0:	movabs $0x7000000000000040,%r8
 10876ba:	mov    %r13d,%r15d
 10876bd:	mov    0x30(%r14),%edx
 10876c1:	jmp    10876d3 <check_input_resolve_range+0x5033>
 10876c3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10876d0:	mov    %edx,%r15d
 10876d3:	cmp    %edx,%r15d
 10876d6:	jae    10877a0 <check_input_resolve_range+0x5100>
 10876dc:	mov    0x10(%r14),%rax
 10876e0:	mov    0x18(%r14),%rsi
 10876e4:	mov    %r15d,%ecx
 10876e7:	movzbl (%rax,%rcx,1),%edi
 10876eb:	mov    (%rsi,%rcx,4),%ecx
 10876ee:	vmovd  %edi,%xmm0
 10876f2:	cmp    $0x6,%edi
 10876f5:	vpinsrd $0x1,%ecx,%xmm0,%xmm0
 10876fb:	sete   %al
 10876fe:	cmp    $0x6b,%ecx
 1087701:	vpshufd $0x50,%xmm0,%xmm0
 1087706:	vpand  -0xaf83fe(%rip),%xmm0,%xmm0        # 58f310 <abi_test_hex.digits+0xb40>
 108770e:	sete   %sil
 1087712:	vpcmpeqd -0xaf83fc(%rip),%xmm0,%k0        # 58f320 <abi_test_hex.digits+0xb50>
 108771c:	kortestb %k0,%k0
 1087720:	setne  %cl
 1087723:	or     %sil,%cl
 1087726:	test   %cl,%cl
 1087728:	jne    10877a8 <check_input_resolve_range+0x5108>
 108772a:	test   %al,%al
 108772c:	je     10877d1 <check_input_resolve_range+0x5131>
 1087732:	lea    0x1(%r15),%eax
 1087736:	cmp    %edx,%eax
 1087738:	jae    10877d1 <check_input_resolve_range+0x5131>
 108773e:	mov    0x10(%r14),%rcx
 1087742:	mov    %eax,%esi
 1087744:	cmpb   $0x6,(%rcx,%rsi,1)
 1087748:	jne    10877d1 <check_input_resolve_range+0x5131>
 108774e:	mov    %r15d,%esi
 1087751:	movzbl (%rcx,%rsi,1),%esi
 1087755:	cmp    $0x6,%rsi
 1087759:	je     108775e <check_input_resolve_range+0x50be>
 108775b:	mov    %eax,%r15d
 108775e:	mov    %r15d,%ecx
 1087761:	mov    %eax,%r15d
 1087764:	cmp    $0x3e,%rsi
 1087768:	ja     10876d3 <check_input_resolve_range+0x5033>
 108776e:	bt     %rsi,%r8
 1087772:	mov    %eax,%r15d
 1087775:	jae    10876d3 <check_input_resolve_range+0x5033>
 108777b:	mov    %edx,%eax
 108777d:	cmp    %edx,%ecx
 108777f:	jae    108778a <check_input_resolve_range+0x50ea>
 1087781:	mov    0x60(%r14),%rax
 1087785:	mov    %ecx,%esi
 1087787:	mov    (%rax,%rsi,4),%eax
 108778a:	cmp    %edx,%eax
 108778c:	jb     10877c0 <check_input_resolve_range+0x5120>
 108778e:	mov    %edx,%r15d
 1087791:	cmp    %ecx,%eax
 1087793:	ja     10876d3 <check_input_resolve_range+0x5033>
 1087799:	jmp    10876d0 <check_input_resolve_range+0x5030>
 108779e:	xchg   %ax,%ax
 10877a0:	xor    %eax,%eax
 10877a2:	xor    %ecx,%ecx
 10877a4:	test   %cl,%cl
 10877a6:	je     108772a <check_input_resolve_range+0x508a>
 10877a8:	mov    0x10(%r14),%rcx
 10877ac:	lea    0x1(%r15),%eax
 10877b0:	mov    %r15d,%esi
 10877b3:	movzbl (%rcx,%rsi,1),%esi
 10877b7:	cmp    $0x6,%rsi
 10877bb:	jne    108775b <check_input_resolve_range+0x50bb>
 10877bd:	jmp    108775e <check_input_resolve_range+0x50be>
 10877bf:	nop
 10877c0:	lea    0x1(%rax),%r15d
 10877c4:	cmp    %ecx,%eax
 10877c6:	ja     10876d3 <check_input_resolve_range+0x5033>
 10877cc:	jmp    10876d0 <check_input_resolve_range+0x5030>
 10877d1:	cmp    %edx,%r15d
 10877d4:	jae    10872bc <check_input_resolve_range+0x4c1c>
 10877da:	mov    0x10(%r14),%rax
 10877de:	mov    %r15d,%r12d
 10877e1:	cmpb   $0x30,(%rax,%r12,1)
 10877e6:	jne    10872bc <check_input_resolve_range+0x4c1c>
 10877ec:	lea    0x200(%rsp),%rsi
 10877f4:	lea    0x130(%rsp),%rcx
 10877fc:	mov    %rbx,%rdi
 10877ff:	mov    %r13d,0x200(%rsp)
 1087807:	movq   $0x0,0x130(%rsp)
 1087813:	vzeroupper
 1087816:	call   10ea410 <check_input_read_attributes>
 108781b:	test   %al,%al
 108781d:	je     1087b6f <check_input_resolve_range+0x54cf>
 1087823:	cmp    %r15d,0x200(%rsp)
 108782b:	mov    0x130(%rsp),%rax
 1087833:	sete   %cl
 1087836:	test   %rax,%rax
 1087839:	setne  %dl
 108783c:	and    %cl,%dl
 108783e:	cmp    $0x1,%dl
 1087841:	jne    1087b6f <check_input_resolve_range+0x54cf>
 1087847:	mov    0x3bc(%rbx),%ecx
 108784d:	cmp    0x30(%r14),%ecx
 1087851:	jae    1087b6f <check_input_resolve_range+0x54cf>
 1087857:	mov    0x8(%rax),%ecx
 108785a:	test   %rcx,%rcx
 108785d:	je     1087883 <check_input_resolve_range+0x51e3>
 108785f:	mov    (%rax),%rdx
 1087862:	mov    %rcx,%rsi
 1087865:	shl    $0x4,%rsi
 1087869:	xor    %edi,%edi
 108786b:	lea    (%rsi,%rsi,4),%rsi
 108786f:	cmpl   $0x45,0x1c(%rdx,%rdi,1)
 1087874:	jne    1087b6f <check_input_resolve_range+0x54cf>
 108787a:	add    $0x50,%rdi
 108787e:	cmp    %rdi,%rsi
 1087881:	jne    108786f <check_input_resolve_range+0x51cf>
 1087883:	mov    (%rbx),%rdx
 1087886:	test   %rcx,%rcx
 1087889:	cmove  %rcx,%rax
 108788d:	mov    0x288(%rdx),%rcx
 1087894:	mov    %rax,(%rcx,%r12,8)
 1087898:	jmp    10872bc <check_input_resolve_range+0x4c1c>
 108789d:	test   %cl,%cl
 108789f:	je     10872bc <check_input_resolve_range+0x4c1c>
 10878a5:	lea    0x1(%r13),%ecx
 10878a9:	cmp    %eax,%ecx
 10878ab:	jae    10872bc <check_input_resolve_range+0x4c1c>
 10878b1:	mov    0x48(%rsp),%rax
 10878b6:	mov    %ecx,%ecx
 10878b8:	mov    0x10(%rax),%rax
 10878bc:	cmpb   $0x6,(%rax,%rcx,1)
 10878c0:	jne    10872bc <check_input_resolve_range+0x4c1c>
 10878c6:	jmp    10876ac <check_input_resolve_range+0x500c>
 10878cb:	cmp    $0x1a,%r14
 10878cf:	jne    1087ca0 <check_input_resolve_range+0x5600>
 10878d5:	mov    0x3c(%rsp),%eax
 10878d9:	cmp    $0x52,%eax
 10878dc:	jne    10878f3 <check_input_resolve_range+0x5253>
 10878de:	mov    0x3b4(%rbx),%eax
 10878e4:	mov    0xf8(%rbx),%rcx
 10878eb:	mov    %eax,(%rcx,%rbp,4)
 10878ee:	jmp    1087ca0 <check_input_resolve_range+0x5600>
 10878f3:	and    $0xfe,%al
 10878f5:	cmp    $0x50,%al
 10878f7:	jne    1087ca0 <check_input_resolve_range+0x5600>
 10878fd:	mov    0x60(%r12),%rax
 1087902:	mov    0x30(%r12),%ecx
 1087907:	mov    (%rax,%rbp,4),%r9d
 108790b:	cmp    %ecx,%r9d
 108790e:	jae    10879ae <check_input_resolve_range+0x530e>
 1087914:	mov    0x50(%r12),%rdx
 1087919:	mov    0x370(%rbx),%rsi
 1087920:	mov    %r9d,%edi
 1087923:	movzbl (%rdx,%rdi,1),%r10d
 1087928:	mov    (%rsi,%rdi,4),%r8d
 108792c:	cmp    %r9d,%r13d
 108792f:	ja     1087937 <check_input_resolve_range+0x5297>
 1087931:	cmp    $0x20,%r10b
 1087935:	jne    1087990 <check_input_resolve_range+0x52f0>
 1087937:	movzbl %r10b,%r9d
 108793b:	cmp    $0x49,%r9d
 108793f:	je     1087956 <check_input_resolve_range+0x52b6>
 1087941:	cmp    $0x20,%r9d
 1087945:	je     1087c2f <check_input_resolve_range+0x558f>
 108794b:	cmp    $0x4a,%r9d
 108794f:	jne    1087990 <check_input_resolve_range+0x52f0>
 1087951:	jmp    1087c2f <check_input_resolve_range+0x558f>
 1087956:	cmp    %ecx,%r8d
 1087959:	jae    1087990 <check_input_resolve_range+0x52f0>
 108795b:	mov    0x10(%r12),%r9
 1087960:	movzbl (%r9,%r8,1),%r8d
 1087965:	cmp    $0x4c,%r8b
 1087969:	je     1087c2f <check_input_resolve_range+0x558f>
 108796f:	mov    0x3c(%rsp),%r9d
 1087974:	xor    $0x51,%r9b
 1087978:	xor    $0x49,%r8b
 108797c:	or     %r9b,%r8b
 108797f:	sete   %r8b
 1087983:	jmp    1087993 <check_input_resolve_range+0x52f3>
 1087985:	data16 cs nopw 0x0(%rax,%rax,1)
 1087990:	xor    %r8d,%r8d
 1087993:	test   %r8b,%r8b
 1087996:	jne    10879a5 <check_input_resolve_range+0x5305>
 1087998:	mov    (%rax,%rdi,4),%r9d
 108799c:	cmp    %ecx,%r9d
 108799f:	jb     1087920 <check_input_resolve_range+0x5280>
 10879a5:	test   %r8b,%r8b
 10879a8:	jne    1087c2f <check_input_resolve_range+0x558f>
 10879ae:	mov    (%rbx),%rax
 10879b1:	mov    0x230(%rax),%ecx
 10879b7:	cmp    0x234(%rax),%ecx
 10879bd:	jae    1087c28 <check_input_resolve_range+0x5588>
 10879c3:	movzbl 0x3bd(%rax),%edx
 10879ca:	mov    0x228(%rax),%rsi
 10879d1:	lea    0x1(%rcx),%edi
 10879d4:	mov    %edi,0x230(%rax)
 10879da:	lea    (%rcx,%rcx,2),%rax
 10879de:	lea    0x1(%rdx,%rdx,2),%edx
 10879e2:	mov    %r13d,(%rsi,%rax,4)
 10879e6:	mov    %edx,0x4(%rsi,%rax,4)
 10879ea:	movl   $0x0,0x8(%rsi,%rax,4)
 10879f2:	jmp    1087c2f <check_input_resolve_range+0x558f>
 10879f7:	mov    0x2e0(%rbx),%rax
 10879fe:	mov    (%rax,%rbp,4),%esi
 1087a01:	cmp    $0xffffffff,%esi
 1087a04:	jne    1087a4a <check_input_resolve_range+0x53aa>
 1087a06:	jmp    1087383 <check_input_resolve_range+0x4ce3>
 1087a0b:	nopl   0x0(%rax,%rax,1)
 1087a10:	movb   $0x1,0x3bd(%rax)
 1087a17:	mov    0x8(%rsp),%r15
 1087a1c:	mov    (%r15),%rax
 1087a1f:	mov    %r15,%rdi
 1087a22:	mov    %r13d,%edx
 1087a25:	mov    0x2e0(%rax),%rax
 1087a2c:	mov    %r13d,(%rax,%rbx,4)
 1087a30:	vzeroupper
 1087a33:	call   1090540 <check_input_bind>
 1087a38:	mov    0x2e8(%r15),%rax
 1087a3f:	mov    (%rax,%rbx,4),%esi
 1087a42:	mov    %r15,%rbx
 1087a45:	cmp    $0xffffffff,%esi
 1087a48:	je     1087aa2 <check_input_resolve_range+0x5402>
 1087a4a:	mov    0x300(%rbx),%rax
 1087a51:	mov    %rbx,%r15
 1087a54:	mov    %esi,%ebx
 1087a56:	testb  $0x2,(%rax,%rbx,1)
 1087a5a:	je     1087a1c <check_input_resolve_range+0x537c>
 1087a5c:	mov    (%r15),%rax
 1087a5f:	mov    0x230(%rax),%ecx
 1087a65:	cmp    0x234(%rax),%ecx
 1087a6b:	jae    1087a10 <check_input_resolve_range+0x5370>
 1087a6d:	movzbl 0x3bd(%rax),%edx
 1087a74:	mov    0x228(%rax),%rdi
 1087a7b:	lea    0x1(%rcx),%r8d
 1087a7f:	mov    %r8d,0x230(%rax)
 1087a86:	lea    (%rcx,%rcx,2),%rax
 1087a8a:	lea    0x1(%rdx,%rdx,2),%edx
 1087a8e:	mov    %esi,(%rdi,%rax,4)
 1087a91:	mov    %edx,0x4(%rdi,%rax,4)
 1087a95:	movl   $0x0,0x8(%rdi,%rax,4)
 1087a9d:	jmp    1087a17 <check_input_resolve_range+0x5377>
 1087aa2:	mov    0x2e0(%rbx),%rax
 1087aa9:	mov    (%rax,%rbp,4),%edx
 1087aac:	cmp    $0xffffffff,%edx
 1087aaf:	je     1087383 <check_input_resolve_range+0x4ce3>
 1087ab5:	mov    0x2e8(%rbx),%rsi
 1087abc:	mov    $0xffffffff,%ecx
 1087ac1:	xor    %eax,%eax
 1087ac3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1087ad0:	cmp    %ecx,%edx
 1087ad2:	cmovb  %edx,%ecx
 1087ad5:	cmp    %eax,%edx
 1087ad7:	cmova  %edx,%eax
 1087ada:	mov    %edx,%edx
 1087adc:	mov    (%rsi,%rdx,4),%edx
 1087adf:	cmp    $0xffffffff,%edx
 1087ae2:	jne    1087ad0 <check_input_resolve_range+0x5430>
 1087ae4:	mov    (%rbx),%rdi
 1087ae7:	cmpl   $0x0,0x330(%rdi)
 1087aee:	je     1087383 <check_input_resolve_range+0x4ce3>
 1087af4:	xor    %edx,%edx
 1087af6:	xor    %esi,%esi
 1087af8:	jmp    1087b17 <check_input_resolve_range+0x5477>
 1087afa:	nopw   0x0(%rax,%rax,1)
 1087b00:	mov    0x330(%rdi),%r8d
 1087b07:	inc    %rsi
 1087b0a:	add    $0x24,%rdx
 1087b0e:	cmp    %r8,%rsi
 1087b11:	jae    1087383 <check_input_resolve_range+0x4ce3>
 1087b17:	mov    0x328(%rdi),%r8
 1087b1e:	mov    (%r8,%rdx,1),%r9d
 1087b22:	cmp    %ecx,%r9d
 1087b25:	jb     1087b00 <check_input_resolve_range+0x5460>
 1087b27:	cmp    %eax,%r9d
 1087b2a:	ja     1087b00 <check_input_resolve_range+0x5460>
 1087b2c:	mov    0x2e0(%rdi),%r10
 1087b33:	cmp    %r13d,(%r10,%r9,4)
 1087b37:	jne    1087b00 <check_input_resolve_range+0x5460>
 1087b39:	mov    %r13d,0x14(%r8,%rdx,1)
 1087b3e:	mov    %r13d,0x18(%r8,%rdx,1)
 1087b43:	mov    0x3b8(%rbx),%edi
 1087b49:	mov    %edi,0x1c(%r8,%rdx,1)
 1087b4e:	mov    0x18(%rbx),%rdi
 1087b52:	mov    0x4(%r8,%rdx,1),%r9d
 1087b57:	mov    0x30(%rdi),%rdi
 1087b5b:	and    $0xfffffff8,%r9d
 1087b5f:	cmpq   $0x0,(%rdi,%r9,1)
 1087b64:	setne  0x20(%r8,%rdx,1)
 1087b6a:	mov    (%rbx),%rdi
 1087b6d:	jmp    1087b00 <check_input_resolve_range+0x5460>
 1087b6f:	mov    (%rbx),%rax
 1087b72:	mov    0x230(%rax),%ecx
 1087b78:	cmp    0x234(%rax),%ecx
 1087b7e:	jae    1087c1c <check_input_resolve_range+0x557c>
 1087b84:	movzbl 0x3bd(%rax),%edx
 1087b8b:	mov    0x228(%rax),%rsi
 1087b92:	lea    0x1(%rcx),%edi
 1087b95:	mov    %edi,0x230(%rax)
 1087b9b:	lea    (%rcx,%rcx,2),%rax
 1087b9f:	lea    0x1(%rdx,%rdx,2),%edx
 1087ba3:	mov    %r13d,(%rsi,%rax,4)
 1087ba7:	mov    %edx,0x4(%rsi,%rax,4)
 1087bab:	movl   $0x0,0x8(%rsi,%rax,4)
 1087bb3:	jmp    10872bc <check_input_resolve_range+0x4c1c>
 1087bb8:	mov    0x30(%r12),%ecx
 1087bbd:	cmp    %ecx,%r13d
 1087bc0:	jae    10885ac <check_input_resolve_range+0x5f0c>
 1087bc6:	mov    0x10(%r12),%rdx
 1087bcb:	mov    0x18(%r12),%rsi
 1087bd0:	movzbl (%rdx,%rbp,1),%edi
 1087bd4:	mov    (%rsi,%rbp,4),%esi
 1087bd7:	vmovd  %edi,%xmm0
 1087bdb:	cmp    $0x6,%edi
 1087bde:	vpinsrd $0x1,%esi,%xmm0,%xmm0
 1087be4:	sete   %dl
 1087be7:	cmp    $0x6b,%esi
 1087bea:	vpshufd $0x50,%xmm0,%xmm0
 1087bef:	vpand  -0xaf88e7(%rip),%xmm0,%xmm0        # 58f310 <abi_test_hex.digits+0xb40>
 1087bf7:	sete   %dil
 1087bfb:	vpcmpeqd -0xaf88e5(%rip),%xmm0,%k0        # 58f320 <abi_test_hex.digits+0xb50>
 1087c05:	kortestb %k0,%k0
 1087c09:	setne  %sil
 1087c0d:	or     %dil,%sil
 1087c10:	jmp    10885b0 <check_input_resolve_range+0x5f10>
 1087c15:	mov    %esi,%edx
 1087c17:	jmp    1087231 <check_input_resolve_range+0x4b91>
 1087c1c:	movb   $0x1,0x3bd(%rax)
 1087c23:	jmp    10872bc <check_input_resolve_range+0x4c1c>
 1087c28:	movb   $0x1,0x3bd(%rax)
 1087c2f:	mov    0x138(%rbx),%rax
 1087c36:	cmpb   $0x31,0x50(%rsp)
 1087c3b:	movb   $0x1,(%rax,%rbp,1)
 1087c3f:	jne    1087ca0 <check_input_resolve_range+0x5600>
 1087c41:	mov    0x60(%r12),%rax
 1087c46:	mov    0x370(%rbx),%rcx
 1087c4d:	mov    (%rax,%rbp,4),%eax
 1087c50:	mov    (%rcx,%rax,4),%edx
 1087c53:	cmp    $0xffffffff,%edx
 1087c56:	je     1087ca0 <check_input_resolve_range+0x5600>
 1087c58:	xor    %ecx,%ecx
 1087c5a:	jmp    1087c71 <check_input_resolve_range+0x55d1>
 1087c5c:	nopl   0x0(%rax)
 1087c60:	mov    %edx,%edx
 1087c62:	mov    0x378(%rbx),%rsi
 1087c69:	mov    (%rsi,%rdx,4),%edx
 1087c6c:	cmp    $0xffffffff,%edx
 1087c6f:	je     1087ca0 <check_input_resolve_range+0x5600>
 1087c71:	cmp    %r13d,%edx
 1087c74:	jbe    1087c60 <check_input_resolve_range+0x55c0>
 1087c76:	cmp    %eax,%edx
 1087c78:	jae    1087c60 <check_input_resolve_range+0x55c0>
 1087c7a:	mov    0x10(%r12),%rsi
 1087c7f:	mov    %edx,%edx
 1087c81:	cmpb   $0x30,(%rsi,%rdx,1)
 1087c85:	jne    1087c62 <check_input_resolve_range+0x55c2>
 1087c87:	mov    0x270(%rbx),%rsi
 1087c8e:	inc    %ecx
 1087c90:	cmp    $0x2,%ecx
 1087c93:	sete   (%rsi,%rdx,1)
 1087c97:	jmp    1087c62 <check_input_resolve_range+0x55c2>
 1087c99:	nopl   0x0(%rax)
 1087ca0:	mov    0x138(%rbx),%rax
 1087ca7:	cmpb   $0x0,(%rax,%rbp,1)
 1087cab:	je     1087cb5 <check_input_resolve_range+0x5615>
 1087cad:	xor    %r12d,%r12d
 1087cb0:	jmp    1087f60 <check_input_resolve_range+0x58c0>
 1087cb5:	mov    0x50(%rsp),%rax
 1087cba:	mov    $0x1,%r12b
 1087cbd:	add    $0xffffffdb,%eax
 1087cc0:	cmp    $0x2,%al
 1087cc2:	ja     1087f60 <check_input_resolve_range+0x58c0>
 1087cc8:	mov    0x48(%rsp),%rcx
 1087ccd:	mov    0x60(%rcx),%rax
 1087cd1:	mov    (%rax,%rbp,4),%r14d
 1087cd5:	lea    0x1(%r13),%ebp
 1087cd9:	cmp    %r14d,%ebp
 1087cdc:	jae    1087f60 <check_input_resolve_range+0x58c0>
 1087ce2:	cmp    0x30(%rcx),%r14d
 1087ce6:	jae    1087f60 <check_input_resolve_range+0x58c0>
 1087cec:	mov    0x50(%rcx),%rbx
 1087cf0:	mov    %ebp,%r15d
 1087cf3:	cmpb   $0x7,(%rbx,%r15,1)
 1087cf8:	je     1087d26 <check_input_resolve_range+0x5686>
 1087cfa:	mov    0x48(%rsp),%rax
 1087cff:	mov    0x10(%rax),%rax
 1087d03:	movzbl (%rax,%r15,1),%eax
 1087d08:	cmp    $0x3f,%rax
 1087d0c:	ja     10886cc <check_input_resolve_range+0x602c>
 1087d12:	movabs $0x8160000000000000,%rcx
 1087d1c:	bt     %rax,%rcx
 1087d20:	jae    10886cc <check_input_resolve_range+0x602c>
 1087d26:	mov    0x48(%rsp),%r12
 1087d2b:	mov    %ebp,0x130(%rsp)
 1087d32:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1087d40:	cmpb   $0x7,(%rbx,%r15,1)
 1087d45:	jne    1087d51 <check_input_resolve_range+0x56b1>
 1087d47:	inc    %r15
 1087d4a:	cmp    %r15d,%r14d
 1087d4d:	jne    1087d40 <check_input_resolve_range+0x56a0>
 1087d4f:	jmp    1087d8f <check_input_resolve_range+0x56ef>
 1087d51:	mov    0x10(%r12),%rbx
 1087d56:	movzbl (%rbx,%r15,1),%eax
 1087d5b:	add    $0xcb,%al
 1087d5d:	cmp    $0x1,%al
 1087d5f:	ja     1087d8f <check_input_resolve_range+0x56ef>
 1087d61:	mov    %r12,%rdi
 1087d64:	mov    %r15d,%esi
 1087d67:	mov    %r14d,%edx
 1087d6a:	vzeroupper
 1087d6d:	call   1095860 <check_input_tag_body>
 1087d72:	cmp    %r14d,%eax
 1087d75:	jae    1087d8f <check_input_resolve_range+0x56ef>
 1087d77:	mov    %eax,%eax
 1087d79:	cmpb   $0xa,(%rbx,%rax,1)
 1087d7d:	jne    1087d8f <check_input_resolve_range+0x56ef>
 1087d7f:	mov    0x8(%rsp),%rdi
 1087d84:	mov    %r15d,%esi
 1087d87:	mov    %r14d,%edx
 1087d8a:	call   1095b50 <check_input_tag_definition>
 1087d8f:	mov    0x8(%rsp),%rbx
 1087d94:	lea    0x130(%rsp),%r15
 1087d9c:	lea    0x12b(%rsp),%rcx
 1087da4:	lea    0x200(%rsp),%r8
 1087dac:	lea    0x12a(%rsp),%r9
 1087db4:	mov    %r14d,%edx
 1087db7:	mov    %r15,%rsi
 1087dba:	mov    %rbx,%rdi
 1087dbd:	vzeroupper
 1087dc0:	call   109a5d0 <check_input_specifiers>
 1087dc5:	lea    0x12c(%rsp),%r8
 1087dcd:	lea    0x124(%rsp),%r9
 1087dd5:	mov    %rbx,%rdi
 1087dd8:	mov    %eax,%esi
 1087dda:	mov    %r15,%rdx
 1087ddd:	mov    %r14d,%ecx
 1087de0:	call   109b940 <check_input_declarator>
 1087de5:	test   %eax,%eax
 1087de7:	je     1087e1b <check_input_resolve_range+0x577b>
 1087de9:	cmp    %r14d,0x130(%rsp)
 1087df1:	jne    1087e1b <check_input_resolve_range+0x577b>
 1087df3:	cmpl   $0xffffffff,0x12c(%rsp)
 1087dfb:	jne    1087e1b <check_input_resolve_range+0x577b>
 1087dfd:	cmpb   $0x0,0x12b(%rsp)
 1087e05:	jne    1087e1b <check_input_resolve_range+0x577b>
 1087e07:	cmpl   $0x0,0x200(%rsp)
 1087e0f:	jne    1087e1b <check_input_resolve_range+0x577b>
 1087e11:	cmpb   $0x0,0x12a(%rsp)
 1087e19:	je     1087e66 <check_input_resolve_range+0x57c6>
 1087e1b:	mov    (%rbx),%rcx
 1087e1e:	mov    0x230(%rcx),%edx
 1087e24:	cmp    0x234(%rcx),%edx
 1087e2a:	jae    1087e5f <check_input_resolve_range+0x57bf>
 1087e2c:	movzbl 0x3bd(%rcx),%esi
 1087e33:	mov    0x228(%rcx),%rdi
 1087e3a:	lea    0x1(%rdx),%r8d
 1087e3e:	mov    %r8d,0x230(%rcx)
 1087e45:	lea    (%rdx,%rdx,2),%rcx
 1087e49:	lea    0x1(%rsi,%rsi,2),%esi
 1087e4d:	mov    %r13d,(%rdi,%rcx,4)
 1087e51:	mov    %esi,0x4(%rdi,%rcx,4)
 1087e55:	movl   $0x0,0x8(%rdi,%rcx,4)
 1087e5d:	jmp    1087e66 <check_input_resolve_range+0x57c6>
 1087e5f:	movb   $0x1,0x3bd(%rcx)
 1087e66:	vpbroadcastq -0xadbaa0(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1087e70:	vpbroadcastd -0xadc299(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1087e79:	vpbroadcastq -0xadbaa3(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1087e83:	vpbroadcastd -0xadc2ad(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1087e8d:	vpbroadcastq -0xadbabf(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1087e97:	mov    0xa8(%rbx),%rcx
 1087e9e:	cmpb   $0x26,0x50(%rsp)
 1087ea3:	mov    %eax,(%rcx,%r14,4)
 1087ea7:	jne    1087f42 <check_input_resolve_range+0x58a2>
 1087ead:	test   %eax,%eax
 1087eaf:	je     1087f42 <check_input_resolve_range+0x58a2>
 1087eb5:	mov    0x30(%r12),%esi
 1087eba:	lea    0x1(%r14),%ecx
 1087ebe:	cmp    %esi,%ecx
 1087ec0:	jae    1087ef9 <check_input_resolve_range+0x5859>
 1087ec2:	mov    0x60(%r12),%rdx
 1087ec7:	mov    %ecx,%edi
 1087ec9:	mov    (%rdx,%rdi,4),%edx
 1087ecc:	cmp    %esi,%edx
 1087ece:	jae    1087ef9 <check_input_resolve_range+0x5859>
 1087ed0:	mov    0x50(%r12),%rsi
 1087ed5:	cmpb   $0x38,(%rsi,%rdi,1)
 1087ed9:	jne    1087ef9 <check_input_resolve_range+0x5859>
 1087edb:	mov    0x18(%rbx),%rsi
 1087edf:	mov    %eax,%edi
 1087ee1:	shr    $0x3,%edi
 1087ee4:	mov    (%rsi),%rsi
 1087ee7:	movzbl (%rsi,%rdi,1),%esi
 1087eeb:	cmp    $0x1,%esi
 1087eee:	je     1087ef9 <check_input_resolve_range+0x5859>
 1087ef0:	cmp    $0xb,%esi
 1087ef3:	jne    1088819 <check_input_resolve_range+0x6179>
 1087ef9:	mov    (%rbx),%rax
 1087efc:	mov    0x230(%rax),%ecx
 1087f02:	cmp    0x234(%rax),%ecx
 1087f08:	jae    1087f3b <check_input_resolve_range+0x589b>
 1087f0a:	movzbl 0x3bd(%rax),%edx
 1087f11:	mov    0x228(%rax),%rsi
 1087f18:	lea    0x1(%rcx),%edi
 1087f1b:	mov    %edi,0x230(%rax)
 1087f21:	lea    (%rcx,%rcx,2),%rax
 1087f25:	lea    0x1(%rdx,%rdx,2),%edx
 1087f29:	mov    %r13d,(%rsi,%rax,4)
 1087f2d:	mov    %edx,0x4(%rsi,%rax,4)
 1087f31:	movl   $0x0,0x8(%rsi,%rax,4)
 1087f39:	jmp    1087f42 <check_input_resolve_range+0x58a2>
 1087f3b:	movb   $0x1,0x3bd(%rax)
 1087f42:	mov    0x138(%rbx),%rax
 1087f49:	mov    0x28(%rsp),%rcx
 1087f4e:	cmpb   $0x0,(%rax,%rcx,1)
 1087f52:	sete   %r12b
 1087f56:	cs nopw 0x0(%rax,%rax,1)
 1087f60:	cmpb   $0x6,0x50(%rsp)
 1087f65:	mov    0x8(%rsp),%rbx
 1087f6a:	mov    0x28(%rsp),%rbp
 1087f6f:	je     1082770 <check_input_resolve_range+0xd0>
 1087f75:	cmpb   $0x8,0x50(%rsp)
 1087f7a:	je     1082770 <check_input_resolve_range+0xd0>
 1087f80:	cmpb   $0x3,0x50(%rsp)
 1087f85:	je     1082770 <check_input_resolve_range+0xd0>
 1087f8b:	test   %r12b,%r12b
 1087f8e:	je     1082770 <check_input_resolve_range+0xd0>
 1087f94:	cmpb   $0x2,0x3c(%rsp)
 1087f99:	jne    1082770 <check_input_resolve_range+0xd0>
 1087f9f:	mov    0x48(%rsp),%rax
 1087fa4:	mov    (%rbx),%rcx
 1087fa7:	mov    0x18(%rax),%rax
 1087fab:	mov    (%rax,%rbp,4),%r15d
 1087faf:	mov    0x220(%rcx),%rax
 1087fb6:	test   %rax,%rax
 1087fb9:	je     1087fec <check_input_resolve_range+0x594c>
 1087fbb:	xor    %ecx,%ecx
 1087fbd:	test   %r15d,%r15d
 1087fc0:	je     1087fe9 <check_input_resolve_range+0x5949>
 1087fc2:	cmpb   $0x0,0x98(%rbx)
 1087fc9:	je     1087fe9 <check_input_resolve_range+0x5949>
 1087fcb:	cmp    0x38(%rbx),%r15d
 1087fcf:	jae    1087fe9 <check_input_resolve_range+0x5949>
 1087fd1:	mov    0x30(%rbx),%rdx
 1087fd5:	mov    (%rdx,%r15,4),%edx
 1087fd9:	test   %edx,%edx
 1087fdb:	je     1087fe9 <check_input_resolve_range+0x5949>
 1087fdd:	mov    0x60(%rbx),%rcx
 1087fe1:	dec    %edx
 1087fe3:	mov    (%rcx,%rdx,4),%ecx
 1087fe6:	mov    (%rax,%rcx,4),%ecx
 1087fe9:	mov    %ecx,(%rax,%rbp,4)
 1087fec:	mov    0x8(%rbx),%rax
 1087ff0:	mov    0x1d0(%rbx),%rcx
 1087ff7:	mov    0x18(%rax),%rax
 1087ffb:	mov    (%rax,%rbp,4),%r12d
 1087fff:	movzwl (%rcx,%r12,2),%r13d
 1088004:	cmp    $0xffff,%r13w
 1088009:	je     108801b <check_input_resolve_range+0x597b>
 108800b:	cmpb   $0x2,0x50(%rsp)
 1088010:	je     1088105 <check_input_resolve_range+0x5a65>
 1088016:	jmp    108813a <check_input_resolve_range+0x5a9a>
 108801b:	mov    0x10(%rbx),%rax
 108801f:	mov    %rcx,0x60(%rsp)
 1088024:	mov    %r15,0x30(%rsp)
 1088029:	xor    %r13d,%r13d
 108802c:	mov    0x270(%rax),%rax
 1088033:	mov    0x40(%rax),%r14
 1088037:	test   %r14,%r14
 108803a:	je     10880ef <check_input_resolve_range+0x5a4f>
 1088040:	mov    0x10(%rax),%rax
 1088044:	mov    0x4(%rax,%r12,8),%r15d
 1088049:	lea    -0x1(%r15),%ecx
 108804d:	cmp    $0x2e,%ecx
 1088050:	ja     10880ef <check_input_resolve_range+0x5a4f>
 1088056:	mov    (%rax,%r12,8),%eax
 108805a:	lea    0xbb6e7f(%rip),%rbx        # 1c3eee0 <cbuiltin_catalog+0x10>
 1088061:	xor    %ebp,%ebp
 1088063:	add    %rax,%r14
 1088066:	cs nopw 0x0(%rax,%rax,1)
 1088070:	xor    %r13d,%r13d
 1088073:	cmp    (%rbx),%r15d
 1088076:	jne    10880d0 <check_input_resolve_range+0x5a30>
 1088078:	mov    -0x8(%rbx),%rsi
 108807c:	mov    %r14,%rdi
 108807f:	mov    %r15,%rdx
 1088082:	vzeroupper
 1088085:	call   7880b0 <bcmp@plt>
 108808a:	vpbroadcastq -0xadbcbc(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1088094:	vpbroadcastd -0xadc4be(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108809e:	vpbroadcastq -0xadbcc8(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10880a8:	vpbroadcastd -0xadc4d1(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10880b1:	vpbroadcastq -0xadbceb(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10880bb:	test   %eax,%eax
 10880bd:	jne    10880d0 <check_input_resolve_range+0x5a30>
 10880bf:	mov    -0x10(%rbx),%r13d
 10880c3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10880d0:	cmp    $0x97,%rbp
 10880d7:	ja     10880e5 <check_input_resolve_range+0x5a45>
 10880d9:	inc    %rbp
 10880dc:	add    $0x18,%rbx
 10880e0:	test   %r13d,%r13d
 10880e3:	je     1088070 <check_input_resolve_range+0x59d0>
 10880e5:	mov    0x8(%rsp),%rbx
 10880ea:	mov    0x28(%rsp),%rbp
 10880ef:	mov    0x60(%rsp),%rax
 10880f4:	mov    0x30(%rsp),%r15
 10880f9:	mov    %r13w,(%rax,%r12,2)
 10880fe:	cmpb   $0x2,0x50(%rsp)
 1088103:	jne    108813a <check_input_resolve_range+0x5a9a>
 1088105:	test   %r13w,%r13w
 1088109:	je     108813a <check_input_resolve_range+0x5a9a>
 108810b:	test   %r15d,%r15d
 108810e:	je     108834c <check_input_resolve_range+0x5cac>
 1088114:	cmpb   $0x0,0x98(%rbx)
 108811b:	je     108834c <check_input_resolve_range+0x5cac>
 1088121:	cmp    0x38(%rbx),%r15d
 1088125:	jae    108834c <check_input_resolve_range+0x5cac>
 108812b:	mov    0x30(%rbx),%rax
 108812f:	cmpl   $0x0,(%rax,%r15,4)
 1088134:	je     108834c <check_input_resolve_range+0x5cac>
 108813a:	mov    (%rbx),%rax
 108813d:	mov    0x238(%rax),%rax
 1088144:	cmpl   $0xffffffff,(%rax,%rbp,4)
 1088148:	jne    1082770 <check_input_resolve_range+0xd0>
 108814e:	mov    (%rsp),%r14
 1088152:	mov    %rbx,%rdi
 1088155:	mov    %r14d,%esi
 1088158:	vzeroupper
 108815b:	call   10a07d0 <check_input_intrinsic_prepare>
 1088160:	test   %eax,%eax
 1088162:	je     108843d <check_input_resolve_range+0x5d9d>
 1088168:	vpbroadcastq -0xadbda2(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1088172:	vpbroadcastd -0xadc59b(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108817b:	vpbroadcastq -0xadbda5(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1088185:	vpbroadcastd -0xadc5af(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108818f:	vpbroadcastq -0xadbdc1(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1088199:	cmp    $0x1,%eax
 108819c:	jne    1082770 <check_input_resolve_range+0xd0>
 10881a2:	mov    0x48(%rsp),%rax
 10881a7:	mov    (%rbx),%rcx
 10881aa:	mov    0x138(%rbx),%rdx
 10881b1:	mov    0x60(%rax),%rax
 10881b5:	mov    0x1f8(%rcx),%rsi
 10881bc:	mov    0x208(%rcx),%r15
 10881c3:	mov    0x218(%rcx),%rcx
 10881ca:	mov    (%rax,%rbp,4),%eax
 10881cd:	mov    (%rcx,%rax,4),%r8d
 10881d1:	shl    $0x5,%r8
 10881d5:	mov    -0x20(%r15,%r8,1),%ecx
 10881da:	movb   $0x1,(%rdx,%rbp,1)
 10881de:	mov    0xa8(%rbx),%rdi
 10881e5:	imul   $0x130,%rcx,%rcx
 10881ec:	mov    0xc(%rsi,%rcx,1),%edx
 10881f0:	mov    %edx,(%rdi,%rax,4)
 10881f3:	mov    (%rsi,%rcx,1),%rax
 10881f7:	mov    0x118(%rsi,%rcx,1),%rdi
 10881ff:	test   %rax,%rax
 1088202:	je     108865d <check_input_resolve_range+0x5fbd>
 1088208:	mov    %rdi,0x50(%rsp)
 108820d:	mov    (%rax),%rcx
 1088210:	mov    0x40(%rax),%edi
 1088213:	mov    $0xb9,%eax
 1088218:	xor    %r13d,%r13d
 108821b:	mov    %r8,0x18(%rsp)
 1088220:	mov    %rcx,0x60(%rsp)
 1088225:	jmp    108823b <check_input_resolve_range+0x5b9b>
 1088227:	nopw   0x0(%rax,%rax,1)
 1088230:	mov    %r14d,%eax
 1088233:	mov    %r12d,%edi
 1088236:	cmp    %eax,%r13d
 1088239:	jae    1088298 <check_input_resolve_range+0x5bf8>
 108823b:	mov    %eax,%ebx
 108823d:	sub    %r13d,%ebx
 1088240:	mov    %eax,0x30(%rsp)
 1088244:	lea    0xc11075(%rip),%rcx        # 1c992c0 <check_builtin_x86_rules>
 108824b:	xor    %ebp,%ebp
 108824d:	mov    %edi,%r12d
 1088250:	shr    $1,%ebx
 1088252:	lea    (%rbx,%r13,1),%r14d
 1088256:	lea    (%r14,%r14,4),%rax
 108825a:	mov    0x8(%rcx,%rax,8),%edx
 108825e:	mov    (%rcx,%rax,8),%rsi
 1088262:	cmp    %edx,%edi
 1088264:	cmovb  %edi,%edx
 1088267:	mov    0x60(%rsp),%rdi
 108826c:	seta   %bpl
 1088270:	vzeroupper
 1088273:	call   7880f0 <memcmp@plt>
 1088278:	xor    %ecx,%ecx
 108827a:	test   %eax,%eax
 108827c:	setg   %cl
 108827f:	cmovne %ecx,%ebp
 1088282:	test   %bpl,%bpl
 1088285:	je     1088230 <check_input_resolve_range+0x5b90>
 1088287:	mov    0x30(%rsp),%eax
 108828b:	lea    0x1(%rbx,%r13,1),%r13d
 1088290:	mov    %r12d,%edi
 1088293:	cmp    %eax,%r13d
 1088296:	jb     108823b <check_input_resolve_range+0x5b9b>
 1088298:	cmp    $0xb8,%r13d
 108829f:	ja     1088618 <check_input_resolve_range+0x5f78>
 10882a5:	mov    %r13d,%r12d
 10882a8:	lea    (%r12,%r12,4),%rax
 10882ac:	lea    0xc1100d(%rip),%rcx        # 1c992c0 <check_builtin_x86_rules>
 10882b3:	inc    %r12
 10882b6:	xor    %ebx,%ebx
 10882b8:	lea    0x10(%rcx,%rax,8),%r13
 10882bd:	mov    -0x8(%r13),%r14d
 10882c1:	mov    -0x10(%r13),%rsi
 10882c5:	mov    %edi,%ebp
 10882c7:	cmp    %r14d,%edi
 10882ca:	mov    %r14d,%edx
 10882cd:	cmovb  %edi,%edx
 10882d0:	mov    0x60(%rsp),%rdi
 10882d5:	call   7880b0 <bcmp@plt>
 10882da:	test   %eax,%eax
 10882dc:	jne    10882ff <check_input_resolve_range+0x5c5f>
 10882de:	cmp    %r14d,%ebp
 10882e1:	jne    10882ff <check_input_resolve_range+0x5c5f>
 10882e3:	movzbl 0x0(%r13),%eax
 10882e8:	add    $0x28,%r13
 10882ec:	mov    %ebp,%edi
 10882ee:	bts    %rax,%rbx
 10882f2:	mov    %r12d,%eax
 10882f5:	inc    %r12
 10882f8:	cmp    $0xb9,%eax
 10882fd:	jne    10882bd <check_input_resolve_range+0x5c1d>
 10882ff:	mov    0x50(%rsp),%rdi
 1088304:	vpbroadcastq -0xadbf3e(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108830e:	vpbroadcastd -0xadc737(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1088317:	vpbroadcastq -0xadbf41(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1088321:	vpbroadcastd -0xadc74b(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108832b:	vpbroadcastq -0xadbf5d(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1088335:	mov    0x18(%rsp),%r8
 108833a:	mov    0x28(%rsp),%rbp
 108833f:	or     %rbx,%rdi
 1088342:	mov    0x8(%rsp),%rbx
 1088347:	jmp    108865d <check_input_resolve_range+0x5fbd>
 108834c:	mov    0x48(%rsp),%rcx
 1088351:	mov    0x60(%rcx),%rax
 1088355:	mov    (%rax,%rbp,4),%eax
 1088358:	cmp    0x30(%rcx),%eax
 108835b:	jae    10883f2 <check_input_resolve_range+0x5d52>
 1088361:	mov    0x50(%rcx),%rcx
 1088365:	cmpb   $0x3c,(%rcx,%rax,1)
 1088369:	jne    10883f2 <check_input_resolve_range+0x5d52>
 108836f:	mov    (%rsp),%rdx
 1088373:	inc    %edx
 1088375:	cmp    %eax,%edx
 1088377:	jae    10883f2 <check_input_resolve_range+0x5d52>
 1088379:	mov    %edx,%edx
 108837b:	cmpb   $0x23,(%rcx,%rdx,1)
 108837f:	jne    10883f2 <check_input_resolve_range+0x5d52>
 1088381:	mov    0x208(%rbx),%rcx
 1088388:	mov    %r13w,(%rcx,%rax,2)
 108838d:	mov    0x138(%rbx),%rax
 1088394:	movb   $0x1,(%rax,%rbp,1)
 1088398:	lea    -0x100(%r13),%eax
 108839f:	cmp    $0x4,%ax
 10883a3:	ja     1082770 <check_input_resolve_range+0xd0>
 10883a9:	movzwl %r13w,%edx
 10883ad:	mov    (%rsp),%rsi
 10883b1:	mov    %rbx,%rdi
 10883b4:	vzeroupper
 10883b7:	call   1095510 <check_input_vararg_prepare>
 10883bc:	vpbroadcastq -0xadbfee(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10883c6:	vpbroadcastd -0xadc7f0(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10883d0:	vpbroadcastq -0xadbffa(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10883da:	vpbroadcastd -0xadc803(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10883e3:	vpbroadcastq -0xadc01d(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 10883ed:	jmp    1082770 <check_input_resolve_range+0xd0>
 10883f2:	mov    (%rbx),%rax
 10883f5:	mov    0x230(%rax),%ecx
 10883fb:	cmp    0x234(%rax),%ecx
 1088401:	jae    108275a <check_input_resolve_range+0xba>
 1088407:	movzbl 0x3bd(%rax),%edx
 108840e:	shl    $0x2,%edx
 1088411:	lea    0x1(%rcx),%edi
 1088414:	mov    0x228(%rax),%rsi
 108841b:	mov    %edi,0x230(%rax)
 1088421:	lea    (%rcx,%rcx,2),%rax
 1088425:	mov    (%rsp),%rcx
 1088429:	mov    %ecx,(%rsi,%rax,4)
 108842c:	mov    %edx,0x4(%rsi,%rax,4)
 1088430:	movl   $0x0,0x8(%rsi,%rax,4)
 1088438:	jmp    1082770 <check_input_resolve_range+0xd0>
 108843d:	mov    0x40(%rbx),%eax
 1088440:	mov    $0x1,%cl
 1088442:	cmp    0x9c(%rbx),%eax
 1088448:	je     1088458 <check_input_resolve_range+0x5db8>
 108844a:	mov    0x68(%rbx),%rcx
 108844e:	lea    -0x1(%rax),%edx
 1088451:	cmp    (%rcx,%rdx,4),%r14d
 1088455:	setae  %cl
 1088458:	vpbroadcastq -0xadc092(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1088462:	vpbroadcastd -0xadc88b(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108846b:	vpbroadcastq -0xadc095(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1088475:	vpbroadcastd -0xadc89f(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108847f:	vpbroadcastq -0xadc0b1(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1088489:	cmpb   $0x1,0x98(%rbx)
 1088490:	jne    108850c <check_input_resolve_range+0x5e6c>
 1088492:	cmp    0x3c(%rbx),%eax
 1088495:	setb   %dl
 1088498:	test   %r15d,%r15d
 108849b:	je     108850c <check_input_resolve_range+0x5e6c>
 108849d:	and    %cl,%dl
 108849f:	je     108850c <check_input_resolve_range+0x5e6c>
 10884a1:	cmp    0x38(%rbx),%r15d
 10884a5:	setb   0x98(%rbx)
 10884ac:	jae    1088513 <check_input_resolve_range+0x5e73>
 10884ae:	lea    0x1(%rax),%ecx
 10884b1:	mov    %ecx,0x40(%rbx)
 10884b4:	mov    0x58(%rbx),%rcx
 10884b8:	mov    %r15d,(%rcx,%rax,4)
 10884bc:	mov    0x60(%rbx),%rcx
 10884c0:	mov    %r14d,(%rcx,%rax,4)
 10884c4:	mov    0x68(%rbx),%rcx
 10884c8:	mov    %r14d,(%rcx,%rax,4)
 10884cc:	mov    0x70(%rbx),%rcx
 10884d0:	movl   $0xffffffff,(%rcx,%rax,4)
 10884d7:	mov    0x80(%rbx),%rcx
 10884de:	movl   $0x0,(%rcx,%rax,4)
 10884e5:	mov    0x88(%rbx),%rcx
 10884ec:	movb   $0x1,(%rcx,%rax,1)
 10884f0:	mov    0x90(%rbx),%rcx
 10884f7:	movb   $0x1,(%rcx,%rax,1)
 10884fb:	mov    0x30(%rbx),%rcx
 10884ff:	mov    0x78(%rbx),%rdx
 1088503:	mov    (%rcx,%r15,4),%ecx
 1088507:	mov    %ecx,(%rdx,%rax,4)
 108850a:	jmp    108851d <check_input_resolve_range+0x5e7d>
 108850c:	movb   $0x0,0x98(%rbx)
 1088513:	mov    (%rbx),%rax
 1088516:	movb   $0x1,0x3bd(%rax)
 108851d:	mov    0xc4(%rbx),%eax
 1088523:	test   %eax,%eax
 1088525:	jne    1088537 <check_input_resolve_range+0x5e97>
 1088527:	mov    (%rsp),%rcx
 108852b:	cmp    0x170(%rbx),%ecx
 1088531:	jae    1082770 <check_input_resolve_range+0xd0>
 1088537:	test   %r15d,%r15d
 108853a:	je     108857f <check_input_resolve_range+0x5edf>
 108853c:	cmpb   $0x0,0x98(%rbx)
 1088543:	je     108857f <check_input_resolve_range+0x5edf>
 1088545:	cmp    0x38(%rbx),%r15d
 1088549:	jae    108857f <check_input_resolve_range+0x5edf>
 108854b:	mov    0x30(%rbx),%rcx
 108854f:	mov    (%rcx,%r15,4),%ecx
 1088553:	test   %ecx,%ecx
 1088555:	je     108857f <check_input_resolve_range+0x5edf>
 1088557:	mov    (%rbx),%rax
 108855a:	mov    0x60(%rbx),%rdx
 108855e:	dec    %ecx
 1088560:	mov    (%rdx,%rcx,4),%ecx
 1088563:	mov    0x238(%rax),%rax
 108856a:	mov    %ecx,(%rax,%rbp,4)
 108856d:	mov    0xa0(%rbx),%rax
 1088574:	mov    (%rax,%rcx,4),%ecx
 1088577:	mov    %ecx,(%rax,%rbp,4)
 108857a:	jmp    1082770 <check_input_resolve_range+0xd0>
 108857f:	test   %eax,%eax
 1088581:	je     1082770 <check_input_resolve_range+0xd0>
 1088587:	mov    (%rbx),%rax
 108858a:	mov    0x230(%rax),%ecx
 1088590:	cmp    0x234(%rax),%ecx
 1088596:	jae    108275a <check_input_resolve_range+0xba>
 108859c:	movzbl 0x3bd(%rax),%edx
 10885a3:	lea    0x2(%rdx,%rdx,1),%edx
 10885a7:	jmp    1088411 <check_input_resolve_range+0x5d71>
 10885ac:	xor    %edx,%edx
 10885ae:	xor    %esi,%esi
 10885b0:	test   %sil,%sil
 10885b3:	jne    1087360 <check_input_resolve_range+0x4cc0>
 10885b9:	test   %dl,%dl
 10885bb:	je     10885d6 <check_input_resolve_range+0x5f36>
 10885bd:	lea    0x1(%r13),%edx
 10885c1:	cmp    %ecx,%edx
 10885c3:	jae    10885d6 <check_input_resolve_range+0x5f36>
 10885c5:	mov    0x10(%r12),%rsi
 10885ca:	mov    %edx,%edx
 10885cc:	cmpb   $0x6,(%rsi,%rdx,1)
 10885d0:	je     1087360 <check_input_resolve_range+0x4cc0>
 10885d6:	cmpl   $0x44,0x3c(%rsp)
 10885db:	jne    1087318 <check_input_resolve_range+0x4c78>
 10885e1:	lea    0x1(%r13),%edx
 10885e5:	cmp    %ecx,%edx
 10885e7:	jae    1087318 <check_input_resolve_range+0x4c78>
 10885ed:	mov    0x50(%r12),%rsi
 10885f2:	mov    %edx,%ecx
 10885f4:	cmpb   $0x7,(%rsi,%rcx,1)
 10885f8:	je     1087360 <check_input_resolve_range+0x4cc0>
 10885fe:	mov    0x10(%r12),%rdx
 1088603:	movzbl (%rdx,%rcx,1),%ecx
 1088607:	add    $0xcb,%cl
 108860a:	cmp    $0x2,%cl
 108860d:	jae    1087318 <check_input_resolve_range+0x4c78>
 1088613:	jmp    1087360 <check_input_resolve_range+0x4cc0>
 1088618:	vpbroadcastq -0xadc252(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 1088622:	vpbroadcastd -0xadca4b(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108862b:	vpbroadcastq -0xadc255(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 1088635:	vpbroadcastd -0xadca5f(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 108863f:	vpbroadcastq -0xadc271(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 1088649:	mov    0x8(%rsp),%rbx
 108864e:	mov    0x28(%rsp),%rbp
 1088653:	mov    0x50(%rsp),%rdi
 1088658:	mov    0x18(%rsp),%r8
 108865d:	add    %r8,%r15
 1088660:	mov    -0xc(%r15),%ecx
 1088664:	test   %ecx,%ecx
 1088666:	je     1082770 <check_input_resolve_range+0xd0>
 108866c:	xor    %eax,%eax
 108866e:	xchg   %ax,%ax
 1088670:	bt     %rax,%rdi
 1088674:	jae    10886af <check_input_resolve_range+0x600f>
 1088676:	mov    -0x8(%r15),%rsi
 108867a:	mov    (%rsi,%rax,8),%edx
 108867d:	cmp    0x4(%rsi,%rax,8),%edx
 1088681:	jae    10886af <check_input_resolve_range+0x600f>
 1088683:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088690:	mov    0x280(%rbx),%rcx
 1088697:	orb    $0x1,(%rcx,%rdx,1)
 108869b:	inc    %rdx
 108869e:	mov    -0x8(%r15),%rcx
 10886a2:	mov    0x4(%rcx,%rax,8),%ecx
 10886a6:	cmp    %rcx,%rdx
 10886a9:	jb     1088690 <check_input_resolve_range+0x5ff0>
 10886ab:	mov    -0xc(%r15),%ecx
 10886af:	lea    0x1(%rax),%rdx
 10886b3:	mov    %ecx,%esi
 10886b5:	cmp    %rsi,%rdx
 10886b8:	jae    1082770 <check_input_resolve_range+0xd0>
 10886be:	cmp    $0x3f,%rax
 10886c2:	mov    %rdx,%rax
 10886c5:	jb     1088670 <check_input_resolve_range+0x5fd0>
 10886c7:	jmp    1082770 <check_input_resolve_range+0xd0>
 10886cc:	mov    0x48(%rsp),%rdi
 10886d1:	mov    %ebp,%esi
 10886d3:	mov    %r14d,%edx
 10886d6:	vzeroupper
 10886d9:	call   109a1e0 <check_input_attribute_starts>
 10886de:	vpbroadcastq -0xadc310(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10886e8:	vpbroadcastd -0xadcb12(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10886f2:	vpbroadcastq -0xadc31c(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10886fc:	vpbroadcastd -0xadcb25(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1088705:	vpbroadcastq -0xadc33f(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108870f:	test   %al,%al
 1088711:	jne    1087d26 <check_input_resolve_range+0x5686>
 1088717:	jmp    1087f60 <check_input_resolve_range+0x58c0>
 108871c:	mov    %r8d,%edx
 108871f:	cmp    %ecx,%edx
 1088721:	jne    108872c <check_input_resolve_range+0x608c>
 1088723:	movb   $0x1,(%rsi,%rbp,1)
 1088727:	jmp    10864b0 <check_input_resolve_range+0x3e10>
 108872c:	mov    (%rbx),%rax
 108872f:	mov    0x230(%rax),%ecx
 1088735:	cmp    0x234(%rax),%ecx
 108873b:	jae    1088771 <check_input_resolve_range+0x60d1>
 108873d:	movzbl 0x3bd(%rax),%edx
 1088744:	mov    0x228(%rax),%rsi
 108874b:	lea    0x1(%rcx),%edi
 108874e:	mov    %edi,0x230(%rax)
 1088754:	lea    (%rcx,%rcx,2),%rax
 1088758:	lea    0x1(%rdx,%rdx,2),%edx
 108875c:	mov    %r13d,(%rsi,%rax,4)
 1088760:	mov    %edx,0x4(%rsi,%rax,4)
 1088764:	movl   $0x0,0x8(%rsi,%rax,4)
 108876c:	jmp    10864b0 <check_input_resolve_range+0x3e10>
 1088771:	movb   $0x1,0x3bd(%rax)
 1088778:	jmp    10864b0 <check_input_resolve_range+0x3e10>
 108877d:	and    $0x1,%bpl
 1088781:	cmp    $0x1,%bpl
 1088785:	mov    0x28(%rsp),%rbp
 108878a:	sbb    %r10d,%r10d
 108878d:	or     %edi,%r10d
 1088790:	mov    0x8(%rsp),%rbx
 1088795:	mov    (%rbx),%rdx
 1088798:	mov    0x320(%rdx),%esi
 108879e:	lea    0x1(%rsi),%edi
 10887a1:	lea    (%rsi,%rsi,2),%rsi
 10887a5:	mov    %edi,0x320(%rdx)
 10887ab:	mov    (%rbx),%rdx
 10887ae:	mov    0x3bc(%rbx),%r8d
 10887b5:	mov    0x310(%rdx),%rdx
 10887bc:	mov    %r13d,(%rdx,%rsi,8)
 10887c0:	mov    %eax,0x4(%rdx,%rsi,8)
 10887c4:	mov    %ecx,0x8(%rdx,%rsi,8)
 10887c8:	mov    %r8d,0xc(%rdx,%rsi,8)
 10887cd:	movl   $0xffffffff,0x10(%rdx,%rsi,8)
 10887d5:	mov    %r10d,0x14(%rdx,%rsi,8)
 10887da:	mov    (%rbx),%rdx
 10887dd:	mov    0x318(%rdx),%rdx
 10887e4:	mov    %edi,(%rdx,%rbp,4)
 10887e7:	mov    (%rbx),%rdx
 10887ea:	mov    0x318(%rdx),%rdx
 10887f1:	mov    %edi,(%rdx,%rax,4)
 10887f4:	mov    (%rbx),%rax
 10887f7:	mov    0x318(%rax),%rax
 10887fe:	mov    %edi,(%rax,%rcx,4)
 1088801:	mov    0x138(%rbx),%rax
 1088808:	movzbl (%rax,%rbp,1),%eax
 108880c:	test   %al,%al
 108880e:	je     1083cb3 <check_input_resolve_range+0x1613>
 1088814:	jmp    108649b <check_input_resolve_range+0x3dfb>
 1088819:	mov    (%rbx),%rsi
 108881c:	mov    0x28(%rsp),%r8
 1088821:	mov    0x238(%rsi),%rsi
 1088828:	mov    %r13d,(%rsi,%r8,4)
 108882c:	mov    0xa0(%rbx),%rsi
 1088833:	mov    %eax,(%rsi,%r8,4)
 1088837:	mov    0x100(%rbx),%rsi
 108883e:	movb   $0x1,(%rsi,%r8,1)
 1088843:	mov    0x130(%rbx),%rsi
 108884a:	mov    %ebp,(%rsi,%r8,4)
 108884e:	cmpl   $0x0,0x3b4(%rbx)
 1088855:	mov    0x118(%rbx),%rsi
 108885c:	sete   (%rsi,%r8,1)
 1088861:	mov    0x108(%rbx),%rsi
 1088868:	movb   $0x1,(%rsi,%r8,1)
 108886d:	mov    (%rbx),%rsi
 1088870:	mov    0x280(%rsi),%rsi
 1088877:	movb   $0x1,(%rsi,%r8,1)
 108887c:	mov    (%rbx),%rdi
 108887f:	mov    0x3bc(%rbx),%esi
 1088885:	mov    0x2e0(%rdi),%rdi
 108888c:	mov    %esi,(%rdi,%r8,4)
 1088890:	mov    %rbx,%rdi
 1088893:	mov    (%rbx),%rsi
 1088896:	mov    0x2b0(%rsi),%rsi
 108889d:	mov    %ecx,(%rsi,%r8,4)
 10888a1:	lea    0x1(%rdx),%ecx
 10888a4:	mov    (%rbx),%rsi
 10888a7:	mov    0x2b8(%rsi),%rsi
 10888ae:	mov    %ecx,(%rsi,%r8,4)
 10888b2:	mov    %r13d,%esi
 10888b5:	mov    0x150(%rbx),%rcx
 10888bc:	mov    %r13d,(%rcx,%r8,4)
 10888c0:	mov    0x150(%rbx),%rcx
 10888c7:	mov    %r13d,(%rcx,%rdx,4)
 10888cb:	mov    0xa8(%rbx),%rcx
 10888d2:	mov    %eax,(%rcx,%r8,4)
 10888d6:	vzeroupper
 10888d9:	call   109a260 <check_input_initializer_prepare>
 10888de:	vpbroadcastq -0xadc510(%rip),%zmm16        # 5ac3d8 <check_mutation_families+0x1b8>
 10888e8:	vpbroadcastd -0xadcd12(%rip),%zmm15        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 10888f2:	vpbroadcastq -0xadc51c(%rip),%zmm14        # 5ac3e0 <check_mutation_families+0x1c0>
 10888fc:	vpbroadcastd -0xadcd25(%rip),%ymm13        # 5abbe0 <link_program_emit_worker.forms+0x3d0>
 1088905:	vpbroadcastq -0xadc53f(%rip),%zmm12        # 5ac3d0 <check_mutation_families+0x1b0>
 108890f:	mov    0x138(%rbx),%rax
 1088916:	movb   $0x1,(%rax,%r14,1)
 108891b:	jmp    1087f42 <check_input_resolve_range+0x58a2>
 1088920:	mov    %r13d,0x24(%rsp)
 1088925:	mov    (%rsp),%r13
 1088929:	jmp    1084ebf <check_input_resolve_range+0x281f>
 108892e:	mov    0x8(%rsp),%rax
 1088933:	mov    (%rax),%rax
 1088936:	mov    0x230(%rax),%ecx
 108893c:	cmp    0x234(%rax),%ecx
 1088942:	jae    1088977 <check_input_resolve_range+0x62d7>
 1088944:	movzbl 0x3bd(%rax),%edx
 108894b:	mov    0x228(%rax),%rsi
 1088952:	lea    0x1(%rcx),%edi
 1088955:	mov    %edi,0x230(%rax)
 108895b:	lea    (%rcx,%rcx,2),%rax
 108895f:	lea    0x1(%rdx,%rdx,2),%edx
 1088963:	mov    %ebp,(%rsi,%rax,4)
 1088966:	mov    %edx,0x4(%rsi,%rax,4)
 108896a:	movl   $0x0,0x8(%rsi,%rax,4)
 1088972:	jmp    10826d4 <check_input_resolve_range+0x34>
 1088977:	movb   $0x1,0x3bd(%rax)
 108897e:	jmp    10826d4 <check_input_resolve_range+0x34>
 1088983:	cmpl   $0x0,0x234(%rax)
 108898a:	je     10889ce <check_input_resolve_range+0x632e>
 108898c:	mov    0x3c8(%rbx),%ecx
 1088992:	mov    0x3cc(%rbx),%edx
 1088998:	mov    0x228(%rax),%rsi
 108899f:	movl   $0x1,0x230(%rax)
 10889a9:	cmp    $0xffffffff,%ecx
 10889ac:	cmovne %ecx,%r13d
 10889b0:	mov    %r13d,(%rsi)
 10889b3:	mov    %edx,0x4(%rsi)
 10889b6:	movl   $0x0,0x8(%rsi)
 10889bd:	mov    (%rbx),%rax
 10889c0:	cmpl   $0x0,0x230(%rax)
 10889c7:	jne    10889e5 <check_input_resolve_range+0x6345>
 10889c9:	jmp    10826d4 <check_input_resolve_range+0x34>
 10889ce:	movb   $0x1,0x3bd(%rax)
 10889d5:	mov    (%rbx),%rax
 10889d8:	cmpl   $0x0,0x230(%rax)
 10889df:	je     10826d4 <check_input_resolve_range+0x34>
 10889e5:	cmpl   $0xffffffff,0x3c8(%rbx)
 10889ec:	jne    10826d4 <check_input_resolve_range+0x34>
 10889f2:	mov    0x3c4(%rbx),%ecx
 10889f8:	mov    0x228(%rax),%rax
 10889ff:	inc    %ecx
 1088a01:	mov    %ecx,0x8(%rax)
 1088a04:	jmp    10826d4 <check_input_resolve_range+0x34>
 1088a09:	mov    0x3d0(%rbx),%eax
 1088a0f:	cmp    %eax,%r13d
 1088a12:	cmovb  %r13d,%eax
 1088a16:	mov    %eax,0x3d0(%rbx)
 1088a1c:	mov    0x230(%rcx),%eax
 1088a22:	cmp    0x234(%rcx),%eax
 1088a28:	jae    1088a71 <check_input_resolve_range+0x63d1>
 1088a2a:	mov    0x3c8(%rbx),%esi
 1088a30:	cmp    $0xffffffff,%esi
 1088a33:	cmovne %esi,%edx
 1088a36:	cmpb   $0x0,0x3bd(%rcx)
 1088a3d:	mov    $0x4,%esi
 1088a42:	jne    1088a4a <check_input_resolve_range+0x63aa>
 1088a44:	mov    0x3cc(%rbx),%esi
 1088a4a:	mov    0x228(%rcx),%rdi
 1088a51:	lea    0x1(%rax),%r8d
 1088a55:	mov    %r8d,0x230(%rcx)
 1088a5c:	lea    (%rax,%rax,2),%rcx
 1088a60:	mov    %edx,(%rdi,%rcx,4)
 1088a63:	mov    %esi,0x4(%rdi,%rcx,4)
 1088a67:	movl   $0x0,0x8(%rdi,%rcx,4)
 1088a6f:	jmp    1088a78 <check_input_resolve_range+0x63d8>
 1088a71:	movb   $0x1,0x3bd(%rcx)
 1088a78:	mov    (%rbx),%rcx
 1088a7b:	cmp    %eax,0x230(%rcx)
 1088a81:	je     10826d4 <check_input_resolve_range+0x34>
 1088a87:	cmpl   $0xffffffff,0x3c8(%rbx)
 1088a8e:	jne    10826d4 <check_input_resolve_range+0x34>
 1088a94:	mov    0x3c4(%rbx),%edx
 1088a9a:	mov    0x228(%rcx),%rcx
 1088aa1:	lea    (%rax,%rax,2),%rax
 1088aa5:	inc    %edx
 1088aa7:	mov    %edx,0x8(%rcx,%rax,4)
 1088aab:	jmp    10826d4 <check_input_resolve_range+0x34>
 1088ab0:	lea    -0x990a87(%rip),%rdi        # 6f8030 <pp_string_value.meaning+0x6faaf>
 1088ab7:	lea    -0x9d77d5(%rip),%rsi        # 6b12e9 <pp_string_value.meaning+0x28d68>
 1088abe:	lea    -0x9d77c1(%rip),%rcx        # 6b1304 <pp_string_value.meaning+0x28d83>
 1088ac5:	mov    $0xbd,%edx
 1088aca:	vzeroupper
 1088acd:	call   787950 <__assert_fail@plt>
 1088ad2:	vzeroupper
 1088ad5:	call   7878e0 <__stack_chk_fail@plt>
