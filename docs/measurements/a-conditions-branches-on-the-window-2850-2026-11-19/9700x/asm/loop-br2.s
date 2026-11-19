
compiler:     file format elf64-x86-64


Disassembly of section .text.buster_start:

Disassembly of section .text.buster_checker:

Disassembly of section .text:

0000000001f80840 <node_contexts_window_loop>:
 1f80840:	push   %rbp
 1f80841:	mov    %rsp,%rbp
 1f80844:	push   %r15
 1f80846:	push   %r14
 1f80848:	push   %r13
 1f8084a:	push   %r12
 1f8084c:	push   %rbx
 1f8084d:	and    $0xffffffffffffffc0,%rsp
 1f80851:	sub    $0x980,%rsp
 1f80858:	mov    (%rdi),%rax
 1f8085b:	mov    0xb38(%rdi),%r14
 1f80862:	add    $0x3f,%edx
 1f80865:	vpxor  %xmm0,%xmm0,%xmm0
 1f80869:	mov    0x8(%rax),%rax
 1f8086d:	movzbl 0x14a(%rax),%eax
 1f80874:	vmovdqa64 %zmm0,0x900(%rsp)
 1f8087c:	vmovdqa64 %zmm0,0x8c0(%rsp)
 1f80884:	vmovdqa64 %zmm0,0x880(%rsp)
 1f8088c:	vmovdqa64 %zmm0,0x840(%rsp)
 1f80894:	vmovdqa64 %zmm0,0x800(%rsp)
 1f8089c:	vmovdqa64 %zmm0,0x7c0(%rsp)
 1f808a4:	vmovdqa64 %zmm0,0x780(%rsp)
 1f808ac:	vmovdqa64 %zmm0,0x740(%rsp)
 1f808b4:	mov    %al,0x2f(%rsp)
 1f808b8:	cmp    $0x40,%edx
 1f808bb:	jae    1f808ca <node_contexts_window_loop+0x8a>
 1f808bd:	xor    %edx,%edx
 1f808bf:	xor    %eax,%eax
 1f808c1:	vpxor  %xmm5,%xmm5,%xmm5
 1f808c5:	jmp    1f821f5 <node_contexts_window_loop+0x19b5>
 1f808ca:	vbroadcasti32x4 -0x19d7ee4(%rip),%zmm9        # 5a89f0 <.LCPI0_36>
 1f808d4:	vbroadcasti32x4 -0x19d7ede(%rip),%zmm10        # 5a8a00 <.LCPI0_37>
 1f808de:	vbroadcasti32x4 -0x19d7ed8(%rip),%zmm11        # 5a8a10 <.LCPI0_38>
 1f808e8:	vbroadcasti32x4 -0x19d7ed2(%rip),%zmm12        # 5a8a20 <.LCPI0_39>
 1f808f2:	vbroadcasti32x4 -0x19d7ecc(%rip),%zmm14        # 5a8a30 <.LCPI0_40>
 1f808fc:	vbroadcasti32x4 -0x19d7ec6(%rip),%zmm15        # 5a8a40 <.LCPI0_41>
 1f80906:	vbroadcasti32x4 -0x19d7ec0(%rip),%zmm16        # 5a8a50 <.LCPI0_42>
 1f80910:	vbroadcasti32x4 -0x19d7eba(%rip),%zmm17        # 5a8a60 <.LCPI0_43>
 1f8091a:	vbroadcasti32x4 -0x19d7eb4(%rip),%zmm18        # 5a8a70 <.LCPI0_44>
 1f80924:	vbroadcasti32x4 -0x19d7eae(%rip),%zmm19        # 5a8a80 <.LCPI0_45>
 1f8092e:	vbroadcasti32x4 -0x19d7ea8(%rip),%zmm20        # 5a8a90 <.LCPI0_46>
 1f80938:	vbroadcasti32x4 -0x19d7ea2(%rip),%zmm21        # 5a8aa0 <.LCPI0_47>
 1f80942:	shr    $0x6,%edx
 1f80945:	mov    $0xffffffff,%r12d
 1f8094b:	mov    %rcx,0x148(%rsp)
 1f80953:	vpxor  %xmm5,%xmm5,%xmm5
 1f80957:	vpxord %xmm27,%xmm27,%xmm27
 1f8095d:	movq   $0x0,0x58(%rsp)
 1f80966:	movq   $0x0,0xb0(%rsp)
 1f80972:	movq   $0x0,0xa8(%rsp)
 1f8097e:	movq   $0x0,0x108(%rsp)
 1f8098a:	vpxord %xmm22,%xmm22,%xmm22
 1f80990:	vpxord %xmm28,%xmm28,%xmm28
 1f80996:	mov    %rdi,0x48(%rsp)
 1f8099b:	mov    %rsi,0x80(%rsp)
 1f809a3:	mov    %r14,0x118(%rsp)
 1f809ab:	jmp    1f80b40 <node_contexts_window_loop+0x300>
 1f809b0:	kmovq  0x150(%rsp),%k1
 1f809ba:	vpcmpeqb %zmm19,%zmm4,%k0
 1f809c0:	vpcmpeqb -0x1ace38a(%rip),%zmm4,%k3        # 4b2640 <abi_test_hex.digits+0xb940>
 1f809ca:	vpaddb -0x1ace314(%rip),%zmm4,%zmm2        # 4b26c0 <abi_test_hex.digits+0xb9c0>
 1f809d4:	vpandq %zmm21,%zmm26,%zmm3
 1f809da:	mov    0x180(%rsp),%rbx
 1f809e2:	mov    0x300(%rsp),%rdi
 1f809ea:	mov    0x160(%rsp),%r11
 1f809f2:	mov    0x30(%rsp),%r14
 1f809f7:	vpcmpeqb %zmm20,%zmm4,%k2
 1f809fd:	mov    0xa0(%rsp),%r10
 1f80a05:	vmovdqa64 %zmm23,%zmm27
 1f80a0b:	vmovdqa64 %zmm0,%zmm28
 1f80a11:	or     0x1c0(%rsp),%rbx
 1f80a19:	andn   0x38(%rsp),%rdi,%r9
 1f80a20:	mov    0x48(%rsp),%rdi
 1f80a25:	vpcmpeqb %zmm9,%zmm24,%k2{%k2}
 1f80a2b:	or     0x200(%rsp),%rbx
 1f80a33:	korq   %k1,%k0,%k0
 1f80a38:	kmovq  0x158(%rsp),%k1
 1f80a42:	vmovq  %r11,%xmm4
 1f80a47:	or     %rcx,%rbx
 1f80a4a:	andn   %r11,%r14,%rcx
 1f80a4f:	vptestnmb %zmm3,%zmm3,%k3{%k3}
 1f80a55:	or     %rcx,%rbx
 1f80a58:	andn   %r10,%rdx,%rcx
 1f80a5d:	mov    0xbd0(%rdi),%rdx
 1f80a64:	vmovq  %r14,%xmm3
 1f80a69:	mov    0x118(%rsp),%r14
 1f80a71:	and    %rax,%rcx
 1f80a74:	kandq  %k1,%k0,%k0
 1f80a79:	vpcmpltub -0x1ace284(%rip),%zmm2,%k1        # 4b2800 <abi_test_hex.digits+0xbb00>
 1f80a84:	korq   %k3,%k1,%k1
 1f80a89:	vpmovb2m %zmm25,%k3
 1f80a8f:	korq   %k3,%k1,%k1
 1f80a94:	korq   %k0,%k1,%k1
 1f80a99:	korq   %k2,%k1,%k1
 1f80a9e:	kmovq  %k1,%r8
 1f80aa3:	vptestnmb %zmm1,%zmm1,%k1
 1f80aa9:	kmovq  %k1,%r15
 1f80aae:	or     %r9,%r8
 1f80ab1:	mov    0x170(%rsp),%r9
 1f80ab9:	kmovq  0x128(%rsp),%k1
 1f80ac3:	or     %r8,%rbx
 1f80ac6:	and    %rcx,%r15
 1f80ac9:	and    %r10,%rbx
 1f80acc:	mov    %r9d,%eax
 1f80acf:	shl    $0x6,%rax
 1f80ad3:	kandq  %k1,%k0,%k0
 1f80ad8:	vpcmpgtb %zmm25,%zmm13,%k1{%k1}
 1f80ade:	mov    %rcx,(%rdx,%rax,1)
 1f80ae2:	mov    %r15,0x8(%rdx,%rax,1)
 1f80ae7:	mov    %rbx,0x10(%rdx,%rax,1)
 1f80aec:	kmovq  %k0,0x18(%rdx,%rax,1)
 1f80af3:	kmovq  %k1,0x20(%rdx,%rax,1)
 1f80afa:	mov    0x40(%rsp),%rdx
 1f80aff:	kmovq  %k4,%rcx
 1f80b04:	and    %r10,%rdx
 1f80b07:	and    %rdx,%rcx
 1f80b0a:	vmovq  %rdx,%xmm1
 1f80b0f:	mov    0x178(%rsp),%rdx
 1f80b17:	vmovq  %rcx,%xmm2
 1f80b1c:	vpunpcklqdq %xmm2,%xmm1,%xmm1
 1f80b20:	vpunpcklqdq %xmm3,%xmm4,%xmm2
 1f80b24:	vinserti128 $0x1,%xmm1,%ymm2,%ymm1
 1f80b2a:	vpopcntq %ymm1,%ymm1
 1f80b30:	vpaddq %ymm5,%ymm1,%ymm5
 1f80b34:	dec    %rdx
 1f80b37:	test   %r9d,%r9d
 1f80b3a:	je     1f821ca <node_contexts_window_loop+0x198a>
 1f80b40:	lea    -0x1(%rdx),%r9d
 1f80b44:	vpbroadcastq -0x19d1da6(%rip),%zmm1        # 5aeda8 <.LCPI0_0>
 1f80b4e:	mov    0xba0(%rdi),%r11
 1f80b55:	vmovdqa64 %zmm22,%zmm0
 1f80b5b:	vmovdqu64 (%r14),%zmm22
 1f80b61:	vmovdqa64 -0x1aceaeb(%rip),%zmm7        # 4b2080 <abi_test_hex.digits+0xb380>
 1f80b6b:	vmovdqa64 -0x1acea75(%rip),%zmm8        # 4b2100 <abi_test_hex.digits+0xb400>
 1f80b75:	mov    0xb80(%rdi),%rax
 1f80b7c:	mov    %rdx,0x178(%rsp)
 1f80b84:	mov    0xb88(%rdi),%rcx
 1f80b8b:	mov    0xb90(%rdi),%rdx
 1f80b92:	mov    0xb98(%rdi),%r15
 1f80b99:	vmovdqa64 %zmm18,%zmm6
 1f80b9f:	vmovdqa64 %zmm16,%zmm18
 1f80ba5:	vmovdqa64 %zmm17,%zmm16
 1f80bab:	vmovdqa64 %zmm19,%zmm17
 1f80bb1:	mov    %r12d,0x7c(%rsp)
 1f80bb6:	mov    %r9,%r13
 1f80bb9:	shl    $0x6,%r13
 1f80bbd:	test   %r9d,%r9d
 1f80bc0:	mov    %r9,0x170(%rsp)
 1f80bc8:	lea    -0x40(%r13),%r8d
 1f80bcc:	vpandq 0x2c(%rsi,%r13,1),%zmm1,%zmm23
 1f80bd7:	cmove  %r9d,%r8d
 1f80bdb:	shl    $0x7,%r9
 1f80bdf:	vmovdqu64 0x6b554(%rsi,%r9,1),%zmm1
 1f80bea:	vmovdqu64 0x6b594(%rsi,%r9,1),%zmm2
 1f80bf5:	vmovdqu64 (%r11,%r13,1),%zmm26
 1f80bfc:	vmovdqu64 (%rax,%r13,1),%zmm13
 1f80c03:	vmovdqu64 (%rcx,%r13,1),%zmm19
 1f80c0a:	vmovdqu64 (%rdx,%r13,1),%zmm24
 1f80c11:	vmovdqu64 (%r15,%r13,1),%zmm25
 1f80c18:	vmovdqu64 (%rcx,%r8,1),%zmm30
 1f80c1f:	vpermt2b 0x40(%r14),%zmm23,%zmm22
 1f80c26:	vpmovuswb %zmm1,%ymm1
 1f80c2c:	vpmovuswb %zmm2,%ymm2
 1f80c32:	vmovdqa64 %zmm19,0x300(%rsp)
 1f80c3a:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm3
 1f80c41:	vpandq %zmm9,%zmm26,%zmm1
 1f80c47:	vmovdqu64 0x6f694(%rsi,%r9,1),%zmm2
 1f80c52:	vmovdqu64 (%r11,%r8,1),%zmm9
 1f80c59:	vptestmb %zmm1,%zmm1,%k4
 1f80c5f:	vmovdqu64 0x6f654(%rsi,%r9,1),%zmm1
 1f80c6a:	vptestmb %zmm3,%zmm3,%k0
 1f80c70:	vpsubb %zmm3,%zmm8,%zmm31
 1f80c76:	kandq  %k0,%k4,%k2
 1f80c7b:	kmovq  %k0,%r10
 1f80c80:	vpcmpnltub %zmm3,%zmm8,%k0
 1f80c87:	kmovq  %k4,0x128(%rsp)
 1f80c91:	kmovq  %k0,%rbx
 1f80c96:	vpcmpltub %zmm3,%zmm8,%k2{%k2}
 1f80c9d:	and    %r10,%rbx
 1f80ca0:	mov    %rbx,0x38(%rsp)
 1f80ca5:	vpmovuswb %zmm2,%ymm2
 1f80cab:	vpmovuswb %zmm1,%ymm1
 1f80cb1:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm1
 1f80cb8:	vmovdqu64 0x196ac(%rsi,%r13,1),%zmm2
 1f80cc3:	vpaddb -0x1acec0d(%rip),%zmm1,%zmm29        # 4b20c0 <abi_test_hex.digits+0xb3c0>
 1f80ccd:	vptestmb %zmm2,%zmm2,%k3
 1f80cd3:	vmovdqa64 %zmm22,%zmm2
 1f80cd9:	vpcmpleub %zmm7,%zmm1,%k1{%k3}
 1f80ce0:	kandq  %k4,%k3,%k3
 1f80ce5:	vpermt2b %zmm0,%zmm29,%zmm2{%k1}{z}
 1f80ceb:	vmovdqu64 0x6d5d4(%rsi,%r9,1),%zmm0
 1f80cf6:	kmovq  %k1,0x168(%rsp)
 1f80d00:	vpcmpnleub %zmm7,%zmm1,%k5{%k3}
 1f80d07:	vbroadcasti32x4 -0x19d8261(%rip),%zmm7        # 5a8ab0 <.LCPI0_48>
 1f80d11:	vmovdqu64 (%r15,%r8,1),%zmm1
 1f80d18:	kmovq  %rbx,%k3
 1f80d1d:	vpandq 0x2c(%rsi,%r8,1),%zmm7,%zmm7
 1f80d28:	vpermt2b %zmm26,%zmm31,%zmm9{%k3}{z}
 1f80d2e:	kortestq %k5,%k2
 1f80d33:	kmovq  %k5,0x110(%rsp)
 1f80d3d:	vmovdqa64 %zmm2,0x200(%rsp)
 1f80d45:	vmovdqu64 0x6d614(%rsi,%r9,1),%zmm2
 1f80d50:	kmovq  %k4,%r9
 1f80d55:	mov    %r9,0xa0(%rsp)
 1f80d5d:	vmovdqa64 %zmm9,0x1c0(%rsp)
 1f80d65:	vpmovuswb %zmm0,%ymm0
 1f80d6b:	vpermt2b %zmm23,%zmm31,%zmm7{%k3}{z}
 1f80d71:	vpmovuswb %zmm2,%ymm2
 1f80d77:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 1f80d7e:	vpcmpltub -0x1acec49(%rip),%zmm0,%k1        # 4b2140 <abi_test_hex.digits+0xb440>
 1f80d89:	vmovdqu64 (%rdx,%r8,1),%zmm2
 1f80d90:	vpsubb %zmm0,%zmm8,%zmm4
 1f80d96:	vmovdqa64 %zmm30,%zmm8
 1f80d9c:	vpermt2b %zmm19,%zmm31,%zmm8{%k3}{z}
 1f80da2:	vptestmb %zmm0,%zmm0,%k6{%k1}
 1f80da8:	vmovdqu64 (%rax,%r8,1),%zmm0
 1f80daf:	vpermt2b %zmm19,%zmm4,%zmm30{%k6}{z}
 1f80db5:	vmovdqa64 %zmm0,%zmm3
 1f80dbb:	vpermt2b %zmm13,%zmm31,%zmm3{%k3}{z}
 1f80dc1:	vpermt2b %zmm13,%zmm4,%zmm0
 1f80dc7:	vmovdqa64 %zmm3,0x180(%rsp)
 1f80dcf:	vmovdqa64 %zmm2,%zmm3
 1f80dd5:	vpermt2b %zmm24,%zmm31,%zmm3{%k3}{z}
 1f80ddb:	vpermi2b %zmm25,%zmm1,%zmm31{%k3}{z}
 1f80de1:	vpermt2b %zmm24,%zmm4,%zmm2
 1f80de7:	vpermt2b %zmm25,%zmm4,%zmm1
 1f80ded:	jne    1f81d92 <node_contexts_window_loop+0x1552>
 1f80df3:	vmovdqa64 %zmm31,0x2c0(%rsp)
 1f80dfb:	vmovdqa64 %zmm17,%zmm19
 1f80e01:	vbroadcasti32x4 -0x19d834b(%rip),%zmm4        # 5a8ac0 <.LCPI0_49>
 1f80e0b:	vmovdqu64 0x1a72c(%rsi,%r13,1),%zmm31
 1f80e16:	vptestmb %zmm11,%zmm8,%k3
 1f80e1c:	vpxor  %xmm9,%xmm9,%xmm9
 1f80e21:	vmovdqa64 %zmm16,%zmm17
 1f80e27:	vmovdqa64 %zmm18,%zmm16
 1f80e2d:	vpandq %zmm18,%zmm1,%zmm1
 1f80e33:	vmovdqa64 %zmm6,%zmm18
 1f80e39:	vmovdqa64 %zmm13,0x700(%rsp)
 1f80e41:	kmovq  %k3,%r12
 1f80e46:	vptestmb %zmm11,%zmm30,%k3
 1f80e4c:	vpandq %zmm4,%zmm3,%zmm3
 1f80e52:	vpandq %zmm4,%zmm2,%zmm2
 1f80e58:	vptestnmb %zmm31,%zmm31,%k2
 1f80e5e:	vpandq -0x19d20b8(%rip){1to8},%zmm22,%zmm4        # 5aedb0 <.LCPI0_20>
 1f80e68:	vpcmpeqb %zmm11,%zmm3,%k0
 1f80e6e:	vmovdqa64 0x300(%rsp),%zmm3
 1f80e76:	kmovq  %k2,0x40(%rsp)
 1f80e7d:	vpcmpgtb 0x200(%rsp),%zmm9,%k2{%k2}
 1f80e85:	kmovq  %k0,%rsi
 1f80e8a:	vpcmpeqb %zmm11,%zmm2,%k0{%k6}
 1f80e90:	vpandq %zmm6,%zmm25,%zmm2
 1f80e96:	vpandq %zmm16,%zmm25,%zmm6
 1f80e9c:	and    0x38(%rsp),%rsi
 1f80ea1:	korq   %k0,%k3,%k1
 1f80ea6:	vptestmb -0x1aceab0(%rip),%zmm3,%k0        # 4b2400 <abi_test_hex.digits+0xb700>
 1f80eb0:	vpcmpeqb %zmm19,%zmm6,%k7
 1f80eb6:	vpcmpeqb %zmm10,%zmm2,%k5
 1f80ebc:	vptestnmb %zmm2,%zmm2,%k3
 1f80ec2:	kmovq  %k5,0xf8(%rsp)
 1f80ecc:	or     %rsi,%r12
 1f80ecf:	vmovdqu8 %zmm10,%zmm2{%k2}{z}
 1f80ed5:	kmovq  %k0,%rax
 1f80eda:	vptestmb %zmm15,%zmm3,%k0
 1f80ee0:	korq   %k2,%k0,%k4
 1f80ee5:	mov    %rax,0x50(%rsp)
 1f80eea:	kmovq  %k3,%rax
 1f80eef:	vptestmb %zmm6,%zmm6,%k3
 1f80ef5:	kandq  %k7,%k4,%k0
 1f80efa:	kmovq  %k3,%rcx
 1f80eff:	knotq  %k2,%k3
 1f80f04:	kmovq  %k4,0xe8(%rsp)
 1f80f0e:	kmovq  %k0,%rbx
 1f80f13:	vptestmb %zmm12,%zmm3,%k0{%k5}
 1f80f19:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f80f20:	kmovq  %k3,%r15
 1f80f25:	vptestnmb %zmm7,%zmm7,%k3
 1f80f2b:	mov    %rcx,0x30(%rsp)
 1f80f30:	and    %r15,%rax
 1f80f33:	mov    %r15,0x120(%rsp)
 1f80f3b:	vpaddb %zmm3,%zmm0,%zmm0
 1f80f41:	kmovq  %k3,0x100(%rsp)
 1f80f4b:	or     %rax,%rbx
 1f80f4e:	and    0x30(%rsp),%rbx
 1f80f53:	mov    %r13,0x30(%rsp)
 1f80f58:	kmovq  %k0,%rdx
 1f80f5d:	vpcmpeqb %zmm15,%zmm1,%k0{%k6}
 1f80f63:	vpaddb %zmm3,%zmm13,%zmm1
 1f80f69:	vpxor  %xmm13,%xmm13,%xmm13
 1f80f6e:	vpcmpltub %zmm11,%zmm1,%k2
 1f80f75:	kmovq  %k0,0x158(%rsp)
 1f80f7f:	vpcmpltub %zmm14,%zmm1,%k5
 1f80f86:	and    %r15,%rdx
 1f80f89:	vpandq %zmm12,%zmm8,%zmm1
 1f80f8f:	mov    0x48(%rsp),%r15
 1f80f94:	or     0x50(%rsp),%rdx
 1f80f99:	mov    %r12,0x50(%rsp)
 1f80f9e:	kmovq  %k2,0xb8(%rsp)
 1f80fa8:	vptestmb %zmm12,%zmm22,%k2{%k2}
 1f80fae:	vmovdqa64 %zmm1,0x680(%rsp)
 1f80fb6:	kmovq  %k5,%rsi
 1f80fbb:	kmovq  %k5,0xd8(%rsp)
 1f80fc5:	mov    0xbb0(%r15),%rax
 1f80fcc:	mov    %rdx,0xf0(%rsp)
 1f80fd4:	not    %rdx
 1f80fd7:	kandq  %k0,%k2,%k0
 1f80fdc:	kmovq  %k2,0x150(%rsp)
 1f80fe6:	vpcmpgtb 0x1c0(%rsp),%zmm9,%k2{%k3}
 1f80fee:	knotq  %k0,%k0
 1f80ff3:	kmovq  %k0,%r8
 1f80ff8:	vpcmpeqb %zmm17,%zmm4,%k0{%k5}
 1f80ffe:	kmovq  %k0,%rdi
 1f81003:	vptestmb %zmm1,%zmm1,%k0
 1f81009:	vbroadcasti32x4 -0x19d8543(%rip),%zmm1        # 5a8ad0 <.LCPI0_50>
 1f81013:	vmovdqu64 %zmm2,(%rax,%r13,1)
 1f8101a:	and    %r8,%rdi
 1f8101d:	mov    0xbc0(%r15),%rax
 1f81024:	korq   %k2,%k0,%k0
 1f81029:	vpcmpltub %zmm14,%zmm0,%k2{%k6}
 1f81030:	vpcmpeqb %zmm15,%zmm4,%k6
 1f81036:	vpandq %zmm20,%zmm26,%zmm0
 1f8103c:	knotq  %k0,%k0
 1f81041:	vmovdqa64 %zmm0,0x6c0(%rsp)
 1f81049:	kmovq  %k6,0x98(%rsp)
 1f81053:	kmovq  %k0,%r9
 1f81058:	vptestmb %zmm21,%zmm22,%k0
 1f8105e:	vmovdqu64 %zmm4,(%rax,%r13,1)
 1f81065:	kmovq  %k0,0xd0(%rsp)
 1f8106f:	korq   %k2,%k0,%k0
 1f81074:	kmovq  %k0,%rcx
 1f81079:	vpcmpeqb %zmm1,%zmm4,%k0
 1f8107f:	korq   %k0,%k6,%k0
 1f81084:	or     %r12,%rcx
 1f81087:	kmovq  %k0,%r10
 1f8108c:	vpcmpneqb %zmm1,%zmm4,%k0
 1f81093:	and    %r9,%rcx
 1f81096:	mov    %rsi,%r9
 1f81099:	kmovq  %k4,%rsi
 1f8109e:	kmovq  %k0,%r14
 1f810a3:	vptestmb %zmm0,%zmm0,%k0
 1f810a9:	vpsllw $0x7,%zmm26,%zmm0
 1f810b0:	mov    %rsi,0xc8(%rsp)
 1f810b8:	korq   %k0,%k1,%k0
 1f810bd:	or     %r9,%r14
 1f810c0:	or     %rsi,%r14
 1f810c3:	knotq  %k0,%k0
 1f810c8:	and    0xa0(%rsp),%r14
 1f810d0:	kmovq  %k0,%r11
 1f810d5:	vpmovb2m %zmm0,%k0
 1f810db:	kmovq  %k0,%rax
 1f810e0:	and    %r10,%r11
 1f810e3:	kmovq  %k0,0xe0(%rsp)
 1f810ed:	andn   %rbx,%rax,%r8
 1f810f2:	mov    %rax,0x88(%rsp)
 1f810fa:	mov    %r8,0xc0(%rsp)
 1f81102:	andn   %rdx,%r8,%r8
 1f81107:	and    %r8,%r14
 1f8110a:	and    %r8,%rdi
 1f8110d:	mov    %r8,0x90(%rsp)
 1f81115:	and    %rdi,%rcx
 1f81118:	and    %r11,%r14
 1f8111b:	mov    %rdi,0x160(%rsp)
 1f81123:	or     %rcx,%r14
 1f81126:	mov    %rcx,0x68(%rsp)
 1f8112b:	and    %r12,%r14
 1f8112e:	je     1f813b0 <node_contexts_window_loop+0xb70>
 1f81134:	mov    %r13,%r10
 1f81137:	shl    $0x6,%r10
 1f8113b:	add    0x2c0(%r15),%r10
 1f81142:	mov    0x20(%r15),%rbx
 1f81146:	mov    0x60(%r15),%r12d
 1f8114a:	mov    0x58(%rsp),%rdx
 1f8114f:	kmovq  0x40(%rsp),%k6
 1f81156:	mov    %r14,%r13
 1f81159:	nopl   0x0(%rax)
 1f81160:	xor    %r15d,%r15d
 1f81163:	tzcnt  %r13,%r15
 1f81168:	mov    %r15d,%eax
 1f8116b:	shl    $0x6,%eax
 1f8116e:	mov    0x20(%r10,%rax,1),%esi
 1f81173:	mov    %esi,%ecx
 1f81175:	shr    $0x3,%ecx
 1f81178:	cmp    %r12d,%ecx
 1f8117b:	cmovae %r12d,%ecx
 1f8117f:	shl    $0x6,%rcx
 1f81183:	cmpl   $0x0,0x38(%rbx,%rcx,1)
 1f81188:	setne  %al
 1f8118b:	testb  $0x4,0x34(%rbx,%rcx,1)
 1f81190:	je     1f811b0 <node_contexts_window_loop+0x970>
 1f81192:	xor    $0x1,%al
 1f81194:	inc    %rdx
 1f81197:	movzbl %al,%eax
 1f8119a:	shlx   %r15,%rax,%rax
 1f8119f:	andn   %r14,%rax,%r14
 1f811a4:	blsr   %r13,%r13
 1f811a9:	jne    1f81160 <node_contexts_window_loop+0x920>
 1f811ab:	jmp    1f813bf <node_contexts_window_loop+0xb7f>
 1f811b0:	mov    0x48(%rsp),%rdi
 1f811b5:	vmovdqa64 %zmm5,0x280(%rsp)
 1f811bd:	mov    %rdx,0x58(%rsp)
 1f811c2:	vmovdqa64 %zmm22,0x240(%rsp)
 1f811ca:	vmovdqa64 %zmm23,0x640(%rsp)
 1f811d2:	vmovdqa64 %zmm24,0x600(%rsp)
 1f811da:	vmovdqa64 %zmm25,0x5c0(%rsp)
 1f811e2:	vmovdqa64 %zmm26,0x580(%rsp)
 1f811ea:	vmovdqa64 %zmm27,0x540(%rsp)
 1f811f2:	vmovdqa64 %zmm28,0x500(%rsp)
 1f811fa:	vmovdqa64 %zmm7,0x4c0(%rsp)
 1f81202:	vmovdqa64 %zmm29,0x480(%rsp)
 1f8120a:	vmovdqa64 %zmm4,0x440(%rsp)
 1f81212:	vmovdqa64 %zmm30,0x3c0(%rsp)
 1f8121a:	vmovdqa64 %zmm8,0x380(%rsp)
 1f81222:	vmovdqa64 %zmm31,0x400(%rsp)
 1f8122a:	kmovq  %k7,0x60(%rsp)
 1f81231:	vmovdqa64 %zmm6,0x340(%rsp)
 1f81239:	kmovq  %k1,0x70(%rsp)
 1f81240:	kmovq  %k2,0x140(%rsp)
 1f8124a:	mov    %r9,0x138(%rsp)
 1f81252:	mov    %r10,0x130(%rsp)
 1f8125a:	vzeroupper
 1f8125d:	call   1f8283a <node_contexts_stride_asked>
 1f81262:	vmovdqa64 0x340(%rsp),%zmm6
 1f8126a:	vmovdqa64 0x400(%rsp),%zmm31
 1f81272:	vmovdqa64 0x380(%rsp),%zmm8
 1f8127a:	vmovdqa64 0x3c0(%rsp),%zmm30
 1f81282:	vmovdqa64 0x440(%rsp),%zmm4
 1f8128a:	vmovdqa64 0x480(%rsp),%zmm29
 1f81292:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f8129a:	vmovdqa64 0x500(%rsp),%zmm28
 1f812a2:	vmovdqa64 0x540(%rsp),%zmm27
 1f812aa:	vmovdqa64 0x580(%rsp),%zmm26
 1f812b2:	vmovdqa64 0x5c0(%rsp),%zmm25
 1f812ba:	vmovdqa64 0x600(%rsp),%zmm24
 1f812c2:	vmovdqa64 0x640(%rsp),%zmm23
 1f812ca:	vmovdqa64 0x240(%rsp),%zmm22
 1f812d2:	vbroadcasti32x4 -0x19d883c(%rip),%zmm21        # 5a8aa0 <.LCPI0_47>
 1f812dc:	vbroadcasti32x4 -0x19d8856(%rip),%zmm20        # 5a8a90 <.LCPI0_46>
 1f812e6:	vbroadcasti32x4 -0x19d8870(%rip),%zmm19        # 5a8a80 <.LCPI0_45>
 1f812f0:	vbroadcasti32x4 -0x19d888a(%rip),%zmm18        # 5a8a70 <.LCPI0_44>
 1f812fa:	vbroadcasti32x4 -0x19d88a4(%rip),%zmm17        # 5a8a60 <.LCPI0_43>
 1f81304:	vbroadcasti32x4 -0x19d88be(%rip),%zmm16        # 5a8a50 <.LCPI0_42>
 1f8130e:	vbroadcasti32x4 -0x19d88d8(%rip),%zmm15        # 5a8a40 <.LCPI0_41>
 1f81318:	vbroadcasti32x4 -0x19d88f2(%rip),%zmm14        # 5a8a30 <.LCPI0_40>
 1f81322:	vbroadcasti32x4 -0x19d890c(%rip),%zmm12        # 5a8a20 <.LCPI0_39>
 1f8132c:	vbroadcasti32x4 -0x19d8926(%rip),%zmm11        # 5a8a10 <.LCPI0_38>
 1f81336:	vbroadcasti32x4 -0x19d8940(%rip),%zmm10        # 5a8a00 <.LCPI0_37>
 1f81340:	vmovdqa64 0x280(%rsp),%zmm5
 1f81348:	mov    0x130(%rsp),%r10
 1f81350:	mov    0x138(%rsp),%r9
 1f81358:	kmovq  0x140(%rsp),%k2
 1f81362:	kmovq  0x70(%rsp),%k1
 1f81369:	mov    0x90(%rsp),%r8
 1f81371:	kmovq  0x60(%rsp),%k7
 1f81378:	kmovq  0x40(%rsp),%k6
 1f8137f:	kmovq  0x100(%rsp),%k3
 1f81389:	mov    0x58(%rsp),%rdx
 1f8138e:	incq   0x108(%rsp)
 1f81396:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f8139d:	vpxor  %xmm13,%xmm13,%xmm13
 1f813a2:	jmp    1f81192 <node_contexts_window_loop+0x952>
 1f813a7:	nopw   0x0(%rax,%rax,1)
 1f813b0:	mov    0x58(%rsp),%rdx
 1f813b5:	kmovq  0x40(%rsp),%k6
 1f813bc:	xor    %r14d,%r14d
 1f813bf:	vpaddb 0x180(%rsp),%zmm3,%zmm0
 1f813c7:	vpaddb -0x1acedd1(%rip),%zmm4,%zmm1        # 4b2600 <abi_test_hex.digits+0xb900>
 1f813d1:	kmovq  0x98(%rsp),%k0
 1f813db:	kmovq  %k1,%rax
 1f813e0:	or     0x50(%rsp),%rax
 1f813e5:	mov    %rdx,0x58(%rsp)
 1f813ea:	mov    %r9,%rdi
 1f813ed:	kmovq  %k0,%rcx
 1f813f2:	andn   %rcx,%rax,%rax
 1f813f7:	vpcmpltub %zmm14,%zmm0,%k1{%k2}
 1f813fe:	vpcmpltub %zmm20,%zmm1,%k0
 1f81405:	kmovq  %k1,%rsi
 1f8140a:	kmovq  %k0,%rdx
 1f8140f:	andn   %r9,%rsi,%rbx
 1f81414:	and    0xa0(%rsp),%rbx
 1f8141c:	and    %rsi,%rdi
 1f8141f:	or     %rdx,%rax
 1f81422:	and    %r8,%rdi
 1f81425:	and    %rax,%rdi
 1f81428:	mov    %rdi,0x98(%rsp)
 1f81430:	and    %rax,%rbx
 1f81433:	and    %r8,%rbx
 1f81436:	je     1f81640 <node_contexts_window_loop+0xe00>
 1f8143c:	mov    0x48(%rsp),%rax
 1f81441:	mov    0xb0(%rsp),%r13
 1f81449:	xor    %r15d,%r15d
 1f8144c:	vmovdqa64 %zmm6,0x340(%rsp)
 1f81454:	kmovq  %k7,0x60(%rsp)
 1f8145b:	vmovdqa64 %zmm31,0x400(%rsp)
 1f81463:	vmovdqa64 %zmm8,0x380(%rsp)
 1f8146b:	vmovdqa64 %zmm30,0x3c0(%rsp)
 1f81473:	vmovdqa64 %zmm4,0x440(%rsp)
 1f8147b:	vmovdqa64 %zmm29,0x480(%rsp)
 1f81483:	vmovdqa64 %zmm7,0x4c0(%rsp)
 1f8148b:	vmovdqa64 %zmm28,0x500(%rsp)
 1f81493:	vmovdqa64 %zmm27,0x540(%rsp)
 1f8149b:	vmovdqa64 %zmm26,0x580(%rsp)
 1f814a3:	vmovdqa64 %zmm25,0x5c0(%rsp)
 1f814ab:	vmovdqa64 %zmm24,0x600(%rsp)
 1f814b3:	vmovdqa64 %zmm23,0x640(%rsp)
 1f814bb:	vmovdqa64 %zmm22,0x240(%rsp)
 1f814c3:	vmovdqa64 %zmm5,0x280(%rsp)
 1f814cb:	mov    (%rax),%rcx
 1f814ce:	mov    0x2c0(%rax),%rax
 1f814d5:	mov    %rcx,0x180(%rsp)
 1f814dd:	mov    %rax,0x70(%rsp)
 1f814e2:	mov    0x30(%rsp),%rax
 1f814e7:	mov    0x180(%rsp),%rdi
 1f814ef:	mov    0x70(%rsp),%rsi
 1f814f4:	xor    %r12d,%r12d
 1f814f7:	tzcnt  %rbx,%r12
 1f814fc:	lea    (%rax,%r12,1),%edx
 1f81500:	vzeroupper
 1f81503:	call   1f827f0 <node_contexts_converted>
 1f81508:	movzbl %al,%eax
 1f8150b:	inc    %r13
 1f8150e:	shlx   %r12,%rax,%rax
 1f81513:	or     %rax,%r15
 1f81516:	blsr   %rbx,%rbx
 1f8151b:	jne    1f814e2 <node_contexts_window_loop+0xca2>
 1f8151d:	vmovdqa64 0x280(%rsp),%zmm5
 1f81525:	vbroadcasti32x4 -0x19d8b2f(%rip),%zmm10        # 5a8a00 <.LCPI0_37>
 1f8152f:	vbroadcasti32x4 -0x19d8b29(%rip),%zmm11        # 5a8a10 <.LCPI0_38>
 1f81539:	vbroadcasti32x4 -0x19d8b23(%rip),%zmm12        # 5a8a20 <.LCPI0_39>
 1f81543:	vbroadcasti32x4 -0x19d8b1d(%rip),%zmm14        # 5a8a30 <.LCPI0_40>
 1f8154d:	vbroadcasti32x4 -0x19d8b17(%rip),%zmm15        # 5a8a40 <.LCPI0_41>
 1f81557:	vbroadcasti32x4 -0x19d8b11(%rip),%zmm16        # 5a8a50 <.LCPI0_42>
 1f81561:	vbroadcasti32x4 -0x19d8b0b(%rip),%zmm17        # 5a8a60 <.LCPI0_43>
 1f8156b:	vbroadcasti32x4 -0x19d8b05(%rip),%zmm18        # 5a8a70 <.LCPI0_44>
 1f81575:	vbroadcasti32x4 -0x19d8aff(%rip),%zmm19        # 5a8a80 <.LCPI0_45>
 1f8157f:	vbroadcasti32x4 -0x19d8af9(%rip),%zmm20        # 5a8a90 <.LCPI0_46>
 1f81589:	vbroadcasti32x4 -0x19d8af3(%rip),%zmm21        # 5a8aa0 <.LCPI0_47>
 1f81593:	vmovdqa64 0x240(%rsp),%zmm22
 1f8159b:	vmovdqa64 0x640(%rsp),%zmm23
 1f815a3:	vmovdqa64 0x600(%rsp),%zmm24
 1f815ab:	vmovdqa64 0x5c0(%rsp),%zmm25
 1f815b3:	vmovdqa64 0x580(%rsp),%zmm26
 1f815bb:	vmovdqa64 0x540(%rsp),%zmm27
 1f815c3:	vmovdqa64 0x500(%rsp),%zmm28
 1f815cb:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f815d3:	vmovdqa64 0x480(%rsp),%zmm29
 1f815db:	vmovdqa64 0x440(%rsp),%zmm4
 1f815e3:	vmovdqa64 0x3c0(%rsp),%zmm30
 1f815eb:	vmovdqa64 0x380(%rsp),%zmm8
 1f815f3:	vmovdqa64 0x400(%rsp),%zmm31
 1f815fb:	vmovdqa64 0x340(%rsp),%zmm6
 1f81603:	or     %r15,0x98(%rsp)
 1f8160b:	mov    0x80(%rsp),%rsi
 1f81613:	kmovq  0x100(%rsp),%k3
 1f8161d:	kmovq  0x40(%rsp),%k6
 1f81624:	kmovq  0x60(%rsp),%k7
 1f8162b:	vpxor  %xmm13,%xmm13,%xmm13
 1f81630:	mov    %r13,0xb0(%rsp)
 1f81638:	jmp    1f81648 <node_contexts_window_loop+0xe08>
 1f8163a:	nopw   0x0(%rax,%rax,1)
 1f81640:	mov    0x80(%rsp),%rsi
 1f81648:	vmovdqa64 0x1c0(%rsp),%zmm9
 1f81650:	vpsllw $0x7,0x300(%rsp),%zmm0
 1f81659:	vmovdqa64 0x700(%rsp),%zmm1
 1f81661:	kmovq  0xd8(%rsp),%k4
 1f8166b:	kmovq  0xf8(%rsp),%k5
 1f81675:	vbroadcasti32x4 -0x19d8b9f(%rip),%zmm3        # 5a8ae0 <.LCPI0_51>
 1f8167f:	vbroadcasti32x4 -0x19d8b99(%rip),%zmm2        # 5a8af0 <.LCPI0_52>
 1f81689:	mov    0x38(%rsp),%rbx
 1f8168e:	vptestmb %zmm15,%zmm9,%k1
 1f81694:	vpmovb2m %zmm0,%k2
 1f8169a:	vmovdqa64 0x680(%rsp),%zmm0
 1f816a2:	kandq  %k3,%k1,%k0
 1f816a7:	kmovq  0xb8(%rsp),%k3
 1f816b1:	kmovq  %k0,%rax
 1f816b6:	vpcmpltub %zmm17,%zmm1,%k0
 1f816bd:	korq   %k2,%k0,%k2
 1f816c2:	vptestmb %zmm15,%zmm26,%k0
 1f816c8:	mov    %rax,0x180(%rsp)
 1f816d0:	kmovq  %k0,%rax
 1f816d5:	vpcmpeqb %zmm10,%zmm4,%k0
 1f816db:	and    0x180(%rsp),%rbx
 1f816e3:	kmovq  %k0,%rdx
 1f816e8:	vpcmpeqb %zmm18,%zmm4,%k0
 1f816ee:	mov    %rax,0x280(%rsp)
 1f816f6:	kmovq  %k0,%rcx
 1f816fb:	korq   %k3,%k7,%k0
 1f81700:	vpcmpeqb %zmm11,%zmm6,%k3{%k4}
 1f81706:	vmovdqa64 0x6c0(%rsp),%zmm6
 1f8170e:	mov    %rdx,0x300(%rsp)
 1f81716:	korq   %k3,%k0,%k0
 1f8171b:	kmovq  0x128(%rsp),%k3
 1f81725:	mov    %rcx,0x240(%rsp)
 1f8172d:	kmovq  %k0,%rdi
 1f81732:	vpcmpeqb %zmm11,%zmm4,%k0{%k4}
 1f81738:	kmovq  %k0,%r8
 1f8173d:	vptestnmb %zmm0,%zmm0,%k0
 1f81743:	kmovq  %k0,%r11
 1f81748:	and    %r8,%r11
 1f8174b:	mov    0xf0(%rsp),%r8
 1f81753:	vptestnmb %zmm1,%zmm1,%k0{%k3}
 1f81759:	kmovq  0xe8(%rsp),%k3
 1f81763:	vmovdqa64 0x2c0(%rsp),%zmm1
 1f8176b:	andn   %rdi,%r8,%rdi
 1f81770:	and    0xc0(%rsp),%rdi
 1f81778:	mov    0x280(%rsp),%r8
 1f81780:	korq   %k3,%k0,%k0
 1f81785:	kmovq  %k0,%r13
 1f8178a:	kandq  %k5,%k4,%k0
 1f8178f:	kmovq  %k0,%r15
 1f81794:	vpcmpeqb %zmm20,%zmm4,%k0{%k2}
 1f8179a:	vpcmpeqb -0x1acf1e4(%rip),%zmm4,%k2        # 4b25c0 <abi_test_hex.digits+0xb8c0>
 1f817a4:	vpandq %zmm3,%zmm1,%zmm0
 1f817aa:	mov    %rdi,0xc0(%rsp)
 1f817b2:	mov    0xc8(%rsp),%rdi
 1f817ba:	andn   %r15,%rdi,%r15
 1f817bf:	mov    0x90(%rsp),%rdi
 1f817c7:	and    0x300(%rsp),%r15
 1f817cf:	korq   %k0,%k2,%k0
 1f817d4:	vpcmpeqb -0x1acf0de(%rip),%zmm4,%k2{%k4}        # 4b2700 <abi_test_hex.digits+0xba00>
 1f817de:	kmovq  %k0,%r10
 1f817e3:	vpcmpeqb %zmm2,%zmm0,%k0{%k1}
 1f817e9:	vptestnmb %zmm16,%zmm1,%k1
 1f817ef:	vbroadcasti32x4 -0x19d8cf9(%rip),%zmm1        # 5a8b00 <.LCPI0_53>
 1f817f9:	vpandq 0x200(%rsp),%zmm3,%zmm0
 1f81801:	korq   %k0,%k1,%k0
 1f81806:	korq   %k4,%k3,%k1
 1f8180b:	kmovq  0xd0(%rsp),%k3
 1f81815:	kmovq  %k1,%rax
 1f8181a:	vpcmpeqb %zmm14,%zmm4,%k1{%k1}
 1f81820:	kmovq  %k1,%rdx
 1f81825:	vptestnmb %zmm6,%zmm6,%k1
 1f8182b:	vbroadcasti32x4 -0x19d8d25(%rip),%zmm6        # 5a8b10 <.LCPI0_54>
 1f81835:	mov    %rax,0x2c0(%rsp)
 1f8183d:	and    %rdi,%r10
 1f81840:	and    %r8,%r15
 1f81843:	and    %rdi,%r11
 1f81846:	and    %rdi,%r13
 1f81849:	kmovq  %k1,%rax
 1f8184e:	and    0x240(%rsp),%rax
 1f81856:	and    %rdi,%rdx
 1f81859:	and    %rdi,%r15
 1f8185c:	mov    %r13,0x200(%rsp)
 1f81864:	mov    0x30(%rsp),%r13
 1f81869:	and    0x2c0(%rsp),%rax
 1f81871:	mov    %r10,0x2c0(%rsp)
 1f81879:	mov    %rdx,0xd0(%rsp)
 1f81881:	kmovq  %k2,%rcx
 1f81886:	vpcmpeqb %zmm1,%zmm4,%k1
 1f8188c:	and    %rdi,%rcx
 1f8188f:	kandq  %k1,%k3,%k4
 1f81894:	mov    %rcx,0xd8(%rsp)
 1f8189c:	kxorq  %k4,%k1,%k3
 1f818a1:	and    %rdi,%rax
 1f818a4:	kmovq  %k4,0x70(%rsp)
 1f818ab:	vpcmpeqb %zmm6,%zmm0,%k2
 1f818b1:	kmovq  %k3,0xe8(%rsp)
 1f818bb:	mov    %rax,0xf0(%rsp)
 1f818c3:	andn   %r11,%rbx,%rax
 1f818c8:	kandq  %k3,%k2,%k3
 1f818cd:	mov    %rax,0xb8(%rsp)
 1f818d5:	kmovq  %k7,%rax
 1f818da:	kmovq  %k3,%r12
 1f818df:	vpcmpeqb %zmm1,%zmm0,%k3
 1f818e5:	vpaddb -0x1acf12f(%rip),%zmm7,%zmm1        # 4b27c0 <abi_test_hex.digits+0xbac0>
 1f818ef:	korq   %k3,%k2,%k2
 1f818f4:	vpcmpeqb %zmm6,%zmm4,%k3
 1f818fa:	and    %rdi,%r12
 1f818fd:	kandq  %k0,%k3,%k0
 1f81902:	mov    %r12,0x1c0(%rsp)
 1f8190a:	kmovq  %k3,0x700(%rsp)
 1f81914:	kandq  %k2,%k0,%k0
 1f81919:	kmovq  %k0,%r9
 1f8191e:	vptestnmb %zmm10,%zmm8,%k0{%k1}
 1f81924:	vpcmpeqb %zmm2,%zmm4,%k1
 1f8192a:	and    %rdi,%r9
 1f8192d:	mov    %r9,0x180(%rsp)
 1f81935:	kmovq  %k0,%r10
 1f8193a:	vptestmb %zmm11,%zmm9,%k0
 1f81940:	kmovq  %k0,%rcx
 1f81945:	vptestmb %zmm12,%zmm26,%k0{%k1}
 1f8194b:	kmovq  0xe0(%rsp),%k1
 1f81955:	and    %rdi,%r10
 1f81958:	mov    %r11,%rdi
 1f8195b:	and    %rbx,%rdi
 1f8195e:	andn   %rdi,%rcx,%rbx
 1f81963:	and    %rcx,%rdi
 1f81966:	mov    %r10,0x6c0(%rsp)
 1f8196e:	mov    %rdi,0xc8(%rsp)
 1f81976:	kmovq  %k0,%rcx
 1f8197b:	vptestmb %zmm21,%zmm25,%k0
 1f81981:	korq   %k5,%k0,%k0
 1f81986:	and    %rcx,0x120(%rsp)
 1f8198e:	korq   %k1,%k0,%k0
 1f81993:	vpcmpeqb %zmm2,%zmm0,%k1
 1f81999:	vporq  %zmm30,%zmm8,%zmm0
 1f8199f:	knotq  %k0,%k0
 1f819a4:	kmovq  %k1,%rcx
 1f819a9:	vpcmpltub %zmm20,%zmm1,%k1
 1f819b0:	kmovq  %k0,%rdx
 1f819b5:	vptestmb %zmm11,%zmm26,%k0
 1f819bb:	kmovq  %k1,0xf8(%rsp)
 1f819c5:	and    %rcx,%rdx
 1f819c8:	kmovq  %k6,%rcx
 1f819cd:	and    %rcx,%rax
 1f819d0:	and    %r8,%rax
 1f819d3:	kmovq  %k0,%r8
 1f819d8:	kandq  %k4,%k1,%k0
 1f819dd:	kmovq  %k0,%r11
 1f819e2:	mov    %rax,0x680(%rsp)
 1f819ea:	mov    %r15,%rax
 1f819ed:	and    %r8,%rax
 1f819f0:	vptestnmb %zmm10,%zmm0,%k0
 1f819f6:	mov    %r8,0x90(%rsp)
 1f819fe:	or     %r9,%r11
 1f81a01:	mov    %rax,0xe0(%rsp)
 1f81a09:	kmovq  %k0,%rax
 1f81a0e:	or     %r12,%r11
 1f81a11:	mov    0x7c(%rsp),%r12d
 1f81a16:	and    %r11,%rax
 1f81a19:	cmpb   $0x0,0x2f(%rsp)
 1f81a1e:	mov    %rax,0x40(%rsp)
 1f81a23:	jne    1f81f5b <node_contexts_window_loop+0x171b>
 1f81a29:	vbroadcasti32x4 -0x19d9043(%rip),%zmm9        # 5a89f0 <.LCPI0_36>
 1f81a33:	mov    0x68(%rsp),%rcx
 1f81a38:	mov    0x88(%rsp),%rax
 1f81a40:	or     %rax,0x200(%rsp)
 1f81a48:	andn   0x50(%rsp),%r14,%rax
 1f81a4f:	and    0x680(%rsp),%rdx
 1f81a57:	mov    0xb8(%rsp),%r8
 1f81a5f:	mov    0xd8(%rsp),%r10
 1f81a67:	mov    %rbx,%r9
 1f81a6a:	or     %r9,%r15
 1f81a6d:	vmovdqa64 %zmm23,%zmm0
 1f81a73:	kmovq  0xe8(%rsp),%k0
 1f81a7d:	vpermt2b %zmm27,%zmm29,%zmm0
 1f81a83:	kmovq  0x168(%rsp),%k7
 1f81a8d:	kmovq  0x100(%rsp),%k6
 1f81a97:	vptestmb %zmm31,%zmm31,%k3
 1f81a9d:	vmovdqu8 %zmm10,%zmm2{%k3}{z}
 1f81aa3:	andn   %rcx,%rax,%rax
 1f81aa8:	mov    %rdx,0x38(%rsp)
 1f81aad:	mov    0xc0(%rsp),%rdx
 1f81ab5:	mov    %r8,%rcx
 1f81ab8:	or     %r10,%rcx
 1f81abb:	mov    %rax,0x30(%rsp)
 1f81ac0:	or     0xe0(%rsp),%rdx
 1f81ac8:	mov    0xd0(%rsp),%rax
 1f81ad0:	or     %rbx,%rcx
 1f81ad3:	mov    0xc8(%rsp),%rbx
 1f81adb:	or     %rax,%rdx
 1f81ade:	or     %r8,%rax
 1f81ae1:	or     0x2c0(%rsp),%rax
 1f81ae9:	or     %rbx,%r15
 1f81aec:	or     %rdx,%rcx
 1f81aef:	mov    0x6c0(%rsp),%rdx
 1f81af7:	or     %rax,%r15
 1f81afa:	mov    %rdx,%rdi
 1f81afd:	or     %rbx,%rdi
 1f81b00:	or     %r10,%rdx
 1f81b03:	or     %r14,%r15
 1f81b06:	mov    0x1c0(%rsp),%r10
 1f81b0e:	or     %rax,%rdi
 1f81b11:	mov    0xf0(%rsp),%rax
 1f81b19:	or     %rbx,%rdx
 1f81b1c:	kmovq  %r15,%k2
 1f81b21:	mov    $0x0,%r15d
 1f81b27:	or     %r8,%rax
 1f81b2a:	or     %r9,%rax
 1f81b2d:	or     %rax,%rdx
 1f81b30:	mov    0x98(%rsp),%rax
 1f81b38:	or     %r14,%rdx
 1f81b3b:	or     %rax,%rcx
 1f81b3e:	or     %rax,%rdi
 1f81b41:	or     %rax,%rdx
 1f81b44:	mov    0x120(%rsp),%rax
 1f81b4c:	kmovq  %rcx,%k4
 1f81b51:	kmovq  %k0,%rcx
 1f81b56:	vpcmpeqb -0x1acf920(%rip),%zmm0,%k0{%k7}        # 4b2240 <abi_test_hex.digits+0xb540>
 1f81b60:	kmovq  %rdi,%k1
 1f81b65:	mov    0x30(%rsp),%rdi
 1f81b6a:	kmovq  %rdx,%k3
 1f81b6f:	vmovdqu8 -0x1acf979(%rip),%zmm1{%k4}{z}        # 4b2200 <abi_test_hex.digits+0xb500>
 1f81b79:	xor    %r10,%rcx
 1f81b7c:	kmovq  %rax,%k5
 1f81b81:	kmovq  %k6,%rax
 1f81b86:	andn   %rdi,%rax,%rax
 1f81b8b:	kmovq  %rax,%k6
 1f81b90:	mov    0x50(%rsp),%rax
 1f81b95:	kmovq  %k0,%rdx
 1f81b9a:	vporq  %zmm15,%zmm1,%zmm0
 1f81ba0:	or     %rdx,%r11
 1f81ba3:	vmovdqu8 %zmm0,%zmm1{%k2}
 1f81ba9:	vporq  %zmm20,%zmm1,%zmm0
 1f81baf:	not    %r11
 1f81bb2:	vmovdqu8 %zmm0,%zmm1{%k1}
 1f81bb8:	vpord  -0x19d03ba(%rip){1to16},%zmm1,%zmm0        # 5b1808 <.LCPI0_55>
 1f81bc2:	kmovq  %rdi,%k1
 1f81bc7:	and    %rdi,%rax
 1f81bca:	kmovq  %rax,%k4
 1f81bcf:	mov    0x40(%rsp),%rax
 1f81bd4:	vmovdqu8 %zmm0,%zmm1{%k3}
 1f81bda:	vmovdqu8 -0x1acf3a4(%rip),%zmm1{%k5}        # 4b2840 <abi_test_hex.digits+0xbb40>
 1f81be4:	vmovdqu8 -0x1acf36e(%rip),%zmm1{%k1}        # 4b2880 <abi_test_hex.digits+0xbb80>
 1f81bee:	kmovq  %rax,%k1
 1f81bf3:	mov    0x118(%rsp),%rax
 1f81bfb:	vmovdqu8 -0x1acf345(%rip),%zmm1{%k1}        # 4b28c0 <abi_test_hex.digits+0xbbc0>
 1f81c05:	kmovq  0x110(%rsp),%k1
 1f81c0f:	vmovdqa64 %zmm1,%zmm0
 1f81c15:	vpaddb %zmm20,%zmm1,%zmm0{%k6}
 1f81c1b:	vpaddb %zmm15,%zmm0,%zmm0{%k4}
 1f81c21:	vpermi2b %zmm28,%zmm0,%zmm29{%k7}{z}
 1f81c27:	vmovdqu8 0x780(%rsp),%zmm29{%k1}
 1f81c2f:	kmovq  %r11,%k1
 1f81c34:	vpaddw %zmm29,%zmm29,%zmm3
 1f81c3a:	vporq  %zmm2,%zmm3,%zmm2
 1f81c40:	vpermb 0x80(%rax),%zmm2,%zmm2
 1f81c47:	mov    0x48(%rsp),%rax
 1f81c4c:	vpandd -0x19d044a(%rip){1to16},%zmm2,%zmm3        # 5b180c <.LCPI0_56>
 1f81c56:	mov    0xba8(%rax),%rdx
 1f81c5d:	vmovdqu8 %zmm3,%zmm3{%k1}{z}
 1f81c63:	vmovdqu64 %zmm1,(%rdx,%r13,1)
 1f81c6a:	mov    0xbb8(%rax),%rdx
 1f81c71:	mov    %r12d,%eax
 1f81c74:	sub    %r13d,%eax
 1f81c77:	vmovdqu64 %zmm3,(%rdx,%r13,1)
 1f81c7e:	mov    $0xffffffffffffffff,%rdx
 1f81c85:	jbe    1f81c9e <node_contexts_window_loop+0x145e>
 1f81c87:	lea    0x40(%r13),%edx
 1f81c8b:	cmp    %edx,%r12d
 1f81c8e:	mov    $0xffffffffffffffff,%rdx
 1f81c95:	shlx   %rax,%rdx,%rdx
 1f81c9a:	cmovae %r15,%rdx
 1f81c9e:	kmovq  0x700(%rsp),%k0
 1f81ca8:	mov    0x300(%rsp),%rdi
 1f81cb0:	kmovq  0x70(%rsp),%k4
 1f81cb7:	kmovq  %k0,%rax
 1f81cbc:	kmovq  0xf8(%rsp),%k0
 1f81cc6:	and    %rdi,0x200(%rsp)
 1f81cce:	xor    %rax,0x180(%rsp)
 1f81cd6:	kmovq  %k0,%r9
 1f81cdb:	vpcmpeqb %zmm18,%zmm7,%k0
 1f81ce1:	and    %r9,%rcx
 1f81ce4:	mov    0x90(%rsp),%r9
 1f81cec:	kmovq  %k0,%r8
 1f81cf1:	vpmovb2m %zmm2,%k0
 1f81cf7:	and    0x38(%rsp),%r9
 1f81cfc:	kmovq  %k0,%rax
 1f81d01:	and    %r8,%r10
 1f81d04:	mov    %r10,0x1c0(%rsp)
 1f81d0c:	andn   %rax,%r9,%rax
 1f81d11:	mov    %rax,%r8
 1f81d14:	or     %rdi,%r8
 1f81d17:	andn   0xa0(%rsp),%r8,%rbx
 1f81d21:	je     1f809b0 <node_contexts_window_loop+0x170>
 1f81d27:	nopw   0x0(%rax,%rax,1)
 1f81d30:	xor    %r8d,%r8d
 1f81d33:	tzcnt  %rbx,%r8
 1f81d38:	mov    $0xffffffffffffffff,%r14
 1f81d3f:	mov    %r12d,%r11d
 1f81d42:	movabs $0x7fffffffffffffff,%rdi
 1f81d4c:	lea    0x0(%r13,%r8,1),%r9d
 1f81d51:	sub    0x651b8(%rsi,%r9,4),%r9d
 1f81d59:	lea    0x1(%r9),%r9d
 1f81d5d:	cmovb  %r15d,%r9d
 1f81d61:	mov    %r9d,%r10d
 1f81d64:	sub    %r13d,%r10d
 1f81d67:	cmp    %r12d,%r9d
 1f81d6a:	cmovb  %r9d,%r11d
 1f81d6e:	cmp    %r13d,%r9d
 1f81d71:	shlx   %r10,%r14,%r14
 1f81d76:	cmovbe %rdi,%r14
 1f81d7a:	cmovb  %r11d,%r12d
 1f81d7e:	bzhi   %r8,%r14,%r8
 1f81d83:	or     %r8,%rdx
 1f81d86:	blsr   %rbx,%rbx
 1f81d8b:	jne    1f81d30 <node_contexts_window_loop+0x14f0>
 1f81d8d:	jmp    1f809b0 <node_contexts_window_loop+0x170>
 1f81d92:	kmovq  %k5,%r8
 1f81d97:	test   %r8,%r8
 1f81d9a:	je     1f81e36 <node_contexts_window_loop+0x15f6>
 1f81da0:	mov    0x48(%rsp),%rdi
 1f81da5:	mov    %r14,%r12
 1f81da8:	mov    %r8,%r10
 1f81dab:	mov    0xba8(%rdi),%rdi
 1f81db2:	mov    %rdi,0x30(%rsp)
 1f81db7:	xor    %edi,%edi
 1f81db9:	tzcnt  %r10,%rdi
 1f81dbe:	mov    %r12,%r9
 1f81dc1:	lea    0x0(%r13,%rdi,1),%ebx
 1f81dc6:	mov    %rdi,0x50(%rsp)
 1f81dcb:	mov    0x30(%rsp),%rdi
 1f81dd0:	movzwl 0x6f654(%rsi,%rbx,2),%r14d
 1f81dd9:	add    %ebx,%r14d
 1f81ddc:	movzwl 0x6b554(%rsi,%r14,2),%r12d
 1f81de5:	movzbl 0x2c(%rsi,%r14,1),%ebx
 1f81deb:	movzbl (%rdi,%r14,1),%edi
 1f81df0:	sub    %r12d,%r14d
 1f81df3:	and    $0x7f,%ebx
 1f81df6:	mov    %r9,%r12
 1f81df9:	testb  $0x7f,0x2c(%rsi,%r14,1)
 1f81dff:	movzbl (%r9,%rbx,1),%ebx
 1f81e04:	mov    0x50(%rsp),%r9
 1f81e09:	setne  %r14b
 1f81e0d:	mov    %bl,0x740(%rsp,%r9,1)
 1f81e15:	add    %r14b,%r14b
 1f81e18:	or     $0x14,%r14b
 1f81e1c:	cmp    $0x14,%dil
 1f81e20:	movzbl %r14b,%ebx
 1f81e24:	cmovne %edi,%ebx
 1f81e27:	blsr   %r10,%r10
 1f81e2c:	mov    %bl,0x780(%rsp,%r9,1)
 1f81e34:	jne    1f81db7 <node_contexts_window_loop+0x1577>
 1f81e36:	kmovq  %k2,%r9
 1f81e3b:	vmovdqa64 %zmm17,%zmm19
 1f81e41:	mov    %r9,%r10
 1f81e44:	test   %r9,%r9
 1f81e47:	je     1f81eba <node_contexts_window_loop+0x167a>
 1f81e49:	xor    %edi,%edi
 1f81e4b:	tzcnt  %r10,%rdi
 1f81e50:	lea    0x0(%r13,%rdi,1),%ebx
 1f81e55:	movzwl 0x6b554(%rsi,%rbx,2),%r14d
 1f81e5e:	sub    %r14d,%ebx
 1f81e61:	movzbl 0x2c(%rsi,%rbx,1),%r14d
 1f81e67:	and    $0x7f,%r14b
 1f81e6b:	blsr   %r10,%r10
 1f81e70:	mov    %r14b,0x7c0(%rsp,%rdi,1)
 1f81e78:	movzbl (%rax,%rbx,1),%r14d
 1f81e7d:	mov    %r14b,0x800(%rsp,%rdi,1)
 1f81e85:	movzbl (%rcx,%rbx,1),%r14d
 1f81e8a:	mov    %r14b,0x840(%rsp,%rdi,1)
 1f81e92:	movzbl (%rdx,%rbx,1),%r14d
 1f81e97:	mov    %r14b,0x880(%rsp,%rdi,1)
 1f81e9f:	movzbl (%r11,%rbx,1),%r14d
 1f81ea4:	mov    %r14b,0x8c0(%rsp,%rdi,1)
 1f81eac:	movzbl (%r15,%rbx,1),%ebx
 1f81eb1:	mov    %bl,0x900(%rsp,%rdi,1)
 1f81eb8:	jne    1f81e49 <node_contexts_window_loop+0x1609>
 1f81eba:	vmovdqa64 0x180(%rsp),%zmm17
 1f81ec2:	vmovdqa64 0x1c0(%rsp),%zmm9
 1f81eca:	vmovdqa64 0x200(%rsp),%zmm4
 1f81ed2:	kmovq  0x110(%rsp),%k3
 1f81edc:	vmovdqu8 0x900(%rsp),%zmm31{%k2}
 1f81ee4:	vmovdqu8 0x7c0(%rsp),%zmm7{%k2}
 1f81eec:	vmovdqu8 0x840(%rsp),%zmm8{%k2}
 1f81ef4:	vmovdqu8 0x880(%rsp),%zmm3{%k2}
 1f81efc:	popcnt %r8,%rax
 1f81f01:	add    0xa8(%rsp),%rax
 1f81f09:	or     %r9,0x38(%rsp)
 1f81f0e:	popcnt %r9,%rcx
 1f81f13:	add    %rcx,%rax
 1f81f16:	mov    %rax,0xa8(%rsp)
 1f81f1e:	vmovdqu8 0x740(%rsp),%zmm4{%k3}
 1f81f26:	vmovdqu8 0x800(%rsp),%zmm17{%k2}
 1f81f2e:	vmovdqu8 0x8c0(%rsp),%zmm9{%k2}
 1f81f36:	vmovdqa64 %zmm31,0x2c0(%rsp)
 1f81f3e:	vmovdqa64 %zmm4,0x200(%rsp)
 1f81f46:	vmovdqa64 %zmm17,0x180(%rsp)
 1f81f4e:	vmovdqa64 %zmm9,0x1c0(%rsp)
 1f81f56:	jmp    1f80e01 <node_contexts_window_loop+0x5c1>
 1f81f5b:	vbroadcasti32x4 -0x19d9575(%rip),%zmm9        # 5a89f0 <.LCPI0_36>
 1f81f65:	cmpq   $0x0,0x68(%rsp)
 1f81f6b:	mov    0x48(%rsp),%rax
 1f81f70:	je     1f82020 <node_contexts_window_loop+0x17e0>
 1f81f76:	mov    %rax,%rcx
 1f81f79:	mov    (%rax),%rax
 1f81f7c:	mov    0x8(%rax),%rax
 1f81f80:	cmpb   $0x1,0x14a(%rax)
 1f81f87:	jne    1f81a33 <node_contexts_window_loop+0x11f3>
 1f81f8d:	mov    0x2c0(%rcx),%rcx
 1f81f94:	mov    0x68(%rsp),%r13
 1f81f99:	xor    %r12d,%r12d
 1f81f9c:	mov    %rax,0x3c0(%rsp)
 1f81fa4:	mov    %rbx,0x340(%rsp)
 1f81fac:	mov    %r11,0x60(%rsp)
 1f81fb1:	mov    %rdx,0x38(%rsp)
 1f81fb6:	vmovdqa64 %zmm31,0x400(%rsp)
 1f81fbe:	vmovdqa64 %zmm4,0x440(%rsp)
 1f81fc6:	vmovdqa64 %zmm29,0x480(%rsp)
 1f81fce:	vmovdqa64 %zmm7,0x4c0(%rsp)
 1f81fd6:	vmovdqa64 %zmm28,0x500(%rsp)
 1f81fde:	vmovdqa64 %zmm27,0x540(%rsp)
 1f81fe6:	vmovdqa64 %zmm26,0x580(%rsp)
 1f81fee:	vmovdqa64 %zmm25,0x5c0(%rsp)
 1f81ff6:	vmovdqa64 %zmm24,0x600(%rsp)
 1f81ffe:	vmovdqa64 %zmm23,0x640(%rsp)
 1f82006:	vmovdqa64 %zmm22,0x240(%rsp)
 1f8200e:	vmovdqa64 %zmm5,0x280(%rsp)
 1f82016:	mov    %rcx,0x380(%rsp)
 1f8201e:	jmp    1f82052 <node_contexts_window_loop+0x1812>
 1f82020:	mov    0x88(%rsp),%rax
 1f82028:	xor    %ecx,%ecx
 1f8202a:	jmp    1f81a40 <node_contexts_window_loop+0x1200>
 1f8202f:	lea    -0x1ab94a1(%rip),%rdx        # 4c8b95 <check_lower_segment_override.segments>
 1f82036:	xor    %ecx,%ecx
 1f82038:	testb  $0x3,-0x110(%rax,%rdx,1)
 1f82040:	setne  %cl
 1f82043:	shlx   %rbx,%rcx,%rax
 1f82048:	or     %rax,%r12
 1f8204b:	blsr   %r13,%r13
 1f82050:	je     1f820b2 <node_contexts_window_loop+0x1872>
 1f82052:	mov    0x30(%rsp),%rax
 1f82057:	mov    0x80(%rsp),%rcx
 1f8205f:	xor    %ebx,%ebx
 1f82061:	tzcnt  %r13,%rbx
 1f82066:	mov    0x380(%rsp),%rdx
 1f8206e:	mov    0x3c0(%rsp),%rdi
 1f82076:	add    %ebx,%eax
 1f82078:	movzwl 0x6b554(%rcx,%rax,2),%ecx
 1f82080:	sub    %ecx,%eax
 1f82082:	shl    $0x6,%rax
 1f82086:	mov    (%rdx,%rax,1),%esi
 1f82089:	vzeroupper
 1f8208c:	call   1f2a5a0 <type_object_qualifiers_slow>
 1f82091:	and    $0xffffff,%eax
 1f82096:	lea    -0x110(%rax),%ecx
 1f8209c:	cmp    $0x2,%ecx
 1f8209f:	jbe    1f8202f <node_contexts_window_loop+0x17ef>
 1f820a1:	xor    %ecx,%ecx
 1f820a3:	shlx   %rbx,%rcx,%rax
 1f820a8:	or     %rax,%r12
 1f820ab:	blsr   %r13,%r13
 1f820b0:	jne    1f82052 <node_contexts_window_loop+0x1812>
 1f820b2:	mov    0x68(%rsp),%rcx
 1f820b7:	vmovdqa64 0x280(%rsp),%zmm5
 1f820bf:	vbroadcasti32x4 -0x19d96d9(%rip),%zmm9        # 5a89f0 <.LCPI0_36>
 1f820c9:	vbroadcasti32x4 -0x19d96d3(%rip),%zmm10        # 5a8a00 <.LCPI0_37>
 1f820d3:	vbroadcasti32x4 -0x19d96cd(%rip),%zmm11        # 5a8a10 <.LCPI0_38>
 1f820dd:	vbroadcasti32x4 -0x19d96c7(%rip),%zmm12        # 5a8a20 <.LCPI0_39>
 1f820e7:	vbroadcasti32x4 -0x19d96c1(%rip),%zmm14        # 5a8a30 <.LCPI0_40>
 1f820f1:	vbroadcasti32x4 -0x19d96bb(%rip),%zmm15        # 5a8a40 <.LCPI0_41>
 1f820fb:	vbroadcasti32x4 -0x19d96b5(%rip),%zmm16        # 5a8a50 <.LCPI0_42>
 1f82105:	vbroadcasti32x4 -0x19d96af(%rip),%zmm17        # 5a8a60 <.LCPI0_43>
 1f8210f:	vbroadcasti32x4 -0x19d96a9(%rip),%zmm18        # 5a8a70 <.LCPI0_44>
 1f82119:	vbroadcasti32x4 -0x19d96a3(%rip),%zmm19        # 5a8a80 <.LCPI0_45>
 1f82123:	vbroadcasti32x4 -0x19d969d(%rip),%zmm20        # 5a8a90 <.LCPI0_46>
 1f8212d:	vbroadcasti32x4 -0x19d9697(%rip),%zmm21        # 5a8aa0 <.LCPI0_47>
 1f82137:	vmovdqa64 0x240(%rsp),%zmm22
 1f8213f:	vmovdqa64 0x640(%rsp),%zmm23
 1f82147:	vmovdqa64 0x600(%rsp),%zmm24
 1f8214f:	vmovdqa64 0x5c0(%rsp),%zmm25
 1f82157:	vmovdqa64 0x580(%rsp),%zmm26
 1f8215f:	vmovdqa64 0x540(%rsp),%zmm27
 1f82167:	vmovdqa64 0x500(%rsp),%zmm28
 1f8216f:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f82177:	vmovdqa64 0x480(%rsp),%zmm29
 1f8217f:	vmovdqa64 0x440(%rsp),%zmm4
 1f82187:	vmovdqa64 0x400(%rsp),%zmm31
 1f8218f:	mov    0x80(%rsp),%rsi
 1f82197:	mov    0x30(%rsp),%r13
 1f8219c:	mov    0x88(%rsp),%rax
 1f821a4:	mov    0x38(%rsp),%rdx
 1f821a9:	mov    0x60(%rsp),%r11
 1f821ae:	mov    0x340(%rsp),%rbx
 1f821b6:	vpxor  %xmm13,%xmm13,%xmm13
 1f821bb:	andn   %rcx,%r12,%rcx
 1f821c0:	mov    0x7c(%rsp),%r12d
 1f821c5:	jmp    1f81a40 <node_contexts_window_loop+0x1200>
 1f821ca:	vmovq  0xa8(%rsp),%xmm0
 1f821d3:	vmovq  0xb0(%rsp),%xmm1
 1f821dc:	mov    0x148(%rsp),%rcx
 1f821e4:	mov    0x58(%rsp),%rax
 1f821e9:	mov    0x108(%rsp),%rdx
 1f821f1:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f821f5:	vmovq  %rdx,%xmm1
 1f821fa:	vmovq  %rax,%xmm2
 1f821ff:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f82203:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f82209:	vinserti64x4 $0x1,%ymm5,%zmm0,%zmm0
 1f82210:	vpaddq (%rcx),%zmm0,%zmm0
 1f82216:	vmovdqu64 %zmm0,(%rcx)
 1f8221c:	lea    -0x28(%rbp),%rsp
 1f82220:	pop    %rbx
 1f82221:	pop    %r12
 1f82223:	pop    %r13
 1f82225:	pop    %r14
 1f82227:	pop    %r15
 1f82229:	pop    %rbp
 1f8222a:	vzeroupper
 1f8222d:	ret

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .iplt:
