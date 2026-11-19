
compiler:     file format elf64-x86-64


Disassembly of section .text.buster_start:

Disassembly of section .text.buster_checker:

Disassembly of section .text:

0000000001f80880 <node_contexts_window_loop>:
 1f80880:	push   %rbp
 1f80881:	mov    %rsp,%rbp
 1f80884:	push   %r15
 1f80886:	push   %r14
 1f80888:	push   %r13
 1f8088a:	push   %r12
 1f8088c:	push   %rbx
 1f8088d:	and    $0xffffffffffffffc0,%rsp
 1f80891:	sub    $0x900,%rsp
 1f80898:	mov    (%rdi),%rax
 1f8089b:	mov    %rsi,%r12
 1f8089e:	mov    0xb38(%rdi),%r8
 1f808a5:	mov    0x4fb8155(%rip),%esi        # 6f38a00 <node_branches_x_level>
 1f808ab:	add    $0x3f,%edx
 1f808ae:	vpxor  %xmm0,%xmm0,%xmm0
 1f808b2:	mov    0x8(%rax),%rax
 1f808b6:	movzbl 0x14a(%rax),%eax
 1f808bd:	vmovdqa64 %zmm0,0x780(%rsp)
 1f808c5:	vmovdqa64 %zmm0,0x740(%rsp)
 1f808cd:	vmovdqa64 %zmm0,0x700(%rsp)
 1f808d5:	vmovdqa64 %zmm0,0x6c0(%rsp)
 1f808dd:	vmovdqa64 %zmm0,0x680(%rsp)
 1f808e5:	vmovdqa64 %zmm0,0x640(%rsp)
 1f808ed:	vmovdqa64 %zmm0,0x600(%rsp)
 1f808f5:	vmovdqa64 %zmm0,0x5c0(%rsp)
 1f808fd:	mov    %al,0xf(%rsp)
 1f80901:	cmp    $0x40,%edx
 1f80904:	jae    1f80914 <node_contexts_window_loop+0x94>
 1f80906:	xor    %edx,%edx
 1f80908:	xor    %eax,%eax
 1f8090a:	vpxor  %xmm9,%xmm9,%xmm9
 1f8090f:	jmp    1f82275 <node_contexts_window_loop+0x19f5>
 1f80914:	vbroadcasti32x4 -0x19d7f2e(%rip),%zmm8        # 5a89f0 <.LCPI0_36>
 1f8091e:	vbroadcasti32x4 -0x19d7f28(%rip),%zmm11        # 5a8a00 <.LCPI0_37>
 1f80928:	vbroadcasti32x4 -0x19d7f22(%rip),%zmm13        # 5a8a10 <.LCPI0_38>
 1f80932:	vbroadcasti32x4 -0x19d7f1c(%rip),%zmm10        # 5a8a20 <.LCPI0_39>
 1f8093c:	vbroadcasti32x4 -0x19d7f16(%rip),%zmm16        # 5a8a30 <.LCPI0_40>
 1f80946:	vbroadcasti32x4 -0x19d7f10(%rip),%zmm17        # 5a8a40 <.LCPI0_41>
 1f80950:	vbroadcasti32x4 -0x19d7f0a(%rip),%zmm19        # 5a8a50 <.LCPI0_42>
 1f8095a:	vbroadcasti32x4 -0x19d7f04(%rip),%zmm20        # 5a8a60 <.LCPI0_43>
 1f80964:	vbroadcasti32x4 -0x19d7efe(%rip),%zmm15        # 5a8a70 <.LCPI0_44>
 1f8096e:	vbroadcasti32x4 -0x19d7ef8(%rip),%zmm22        # 5a8a80 <.LCPI0_45>
 1f80978:	vbroadcasti32x4 -0x19d7ef2(%rip),%zmm23        # 5a8a90 <.LCPI0_46>
 1f80982:	vbroadcasti32x4 -0x19d7efc(%rip),%zmm6        # 5a8a90 <.LCPI0_46>
 1f8098c:	vbroadcasti32x4 -0x19d7ef6(%rip),%zmm26        # 5a8aa0 <.LCPI0_47>
 1f80996:	shr    $0x6,%edx
 1f80999:	mov    $0xffffffff,%r11d
 1f8099f:	mov    %rcx,0x108(%rsp)
 1f809a7:	vpxor  %xmm9,%xmm9,%xmm9
 1f809ac:	vpxord %xmm18,%xmm18,%xmm18
 1f809b2:	movq   $0x0,0x30(%rsp)
 1f809bb:	xor    %eax,%eax
 1f809bd:	movq   $0x0,0x98(%rsp)
 1f809c9:	movq   $0x0,0xc8(%rsp)
 1f809d5:	vpxord %xmm31,%xmm31,%xmm31
 1f809db:	vpxor  %xmm1,%xmm1,%xmm1
 1f809df:	mov    %r12,0x20(%rsp)
 1f809e4:	mov    %rdi,0x18(%rsp)
 1f809e9:	mov    %r8,0x88(%rsp)
 1f809f1:	mov    %esi,0x7c(%rsp)
 1f809f5:	jmp    1f80b6f <node_contexts_window_loop+0x2ef>
 1f809fa:	nopw   0x0(%rax,%rax,1)
 1f80a00:	vpandq 0x440(%rsp),%zmm29,%zmm3
 1f80a08:	kmovq  0x128(%rsp),%k1
 1f80a12:	vpcmpeqb %zmm22,%zmm5,%k0
 1f80a18:	vpaddb -0x1ace3e2(%rip),%zmm5,%zmm2        # 4b2640 <abi_test_hex.digits+0xb940>
 1f80a22:	vpcmpeqb %zmm26,%zmm5,%k2
 1f80a28:	mov    0xe8(%rsp),%rax
 1f80a30:	vpcmpeqb %zmm23,%zmm5,%k3
 1f80a36:	vpcmpeqb 0x580(%rsp),%zmm8,%k3{%k3}
 1f80a3e:	mov    0x138(%rsp),%r10
 1f80a46:	mov    0x10(%rsp),%r14
 1f80a4b:	vpmovb2m %zmm21,%k4
 1f80a51:	mov    0x70(%rsp),%rbx
 1f80a56:	mov    0x170(%rsp),%r9
 1f80a5e:	korq   %k1,%k0,%k0
 1f80a63:	vpcmpltub -0x1ace26e(%rip),%zmm2,%k1        # 4b2800 <abi_test_hex.digits+0xbb00>
 1f80a6e:	andn   %rsi,%rax,%rdi
 1f80a73:	mov    0x160(%rsp),%rax
 1f80a7b:	andn   %r10,%r14,%rsi
 1f80a80:	andn   %rbx,%rcx,%rcx
 1f80a85:	vmovq  %r10,%xmm4
 1f80a8a:	kandq  %k7,%k0,%k0
 1f80a8f:	and    %rdx,%rcx
 1f80a92:	vptestnmb %zmm3,%zmm3,%k2{%k2}
 1f80a98:	vmovq  %r14,%xmm3
 1f80a9d:	or     %rsi,%rax
 1f80aa0:	korq   %k2,%k1,%k1
 1f80aa5:	korq   %k4,%k1,%k1
 1f80aaa:	korq   %k0,%k1,%k1
 1f80aaf:	kandq  %k6,%k0,%k0
 1f80ab4:	korq   %k3,%k1,%k1
 1f80ab9:	kmovq  %k1,%rsi
 1f80abe:	vptestnmb %zmm0,%zmm0,%k1
 1f80ac4:	vpxor  %xmm0,%xmm0,%xmm0
 1f80ac8:	or     %rdi,%rsi
 1f80acb:	mov    0x18(%rsp),%rdi
 1f80ad0:	or     0x28(%rsp),%rsi
 1f80ad5:	kmovq  %k1,%r8
 1f80ada:	vpcmpgtb %zmm21,%zmm0,%k1{%k6}
 1f80ae0:	and    %rcx,%r8
 1f80ae3:	mov    0xbd0(%rdi),%rdx
 1f80aea:	or     %rax,%rsi
 1f80aed:	mov    %r9d,%eax
 1f80af0:	shl    $0x6,%rax
 1f80af4:	and    %rbx,%rsi
 1f80af7:	mov    %rcx,(%rdx,%rax,1)
 1f80afb:	mov    0xb8(%rsp),%rcx
 1f80b03:	mov    %r8,0x8(%rdx,%rax,1)
 1f80b08:	mov    %rsi,0x10(%rdx,%rax,1)
 1f80b0d:	kmovq  %k0,0x18(%rdx,%rax,1)
 1f80b14:	kmovq  %k1,0x20(%rdx,%rax,1)
 1f80b1b:	mov    0xd0(%rsp),%rdx
 1f80b23:	mov    0xc0(%rsp),%rax
 1f80b2b:	mov    0x88(%rsp),%r8
 1f80b33:	and    %rbx,%rcx
 1f80b36:	and    %rcx,%rdx
 1f80b39:	vmovq  %rcx,%xmm0
 1f80b3e:	vmovq  %rdx,%xmm2
 1f80b43:	mov    0x178(%rsp),%rdx
 1f80b4b:	vpunpcklqdq %xmm2,%xmm0,%xmm0
 1f80b4f:	vpunpcklqdq %xmm3,%xmm4,%xmm2
 1f80b53:	vinserti128 $0x1,%xmm0,%ymm2,%ymm0
 1f80b59:	vpopcntq %ymm0,%ymm0
 1f80b5f:	vpaddq %ymm0,%ymm9,%ymm9
 1f80b63:	dec    %rdx
 1f80b66:	test   %r9d,%r9d
 1f80b69:	je     1f8224e <node_contexts_window_loop+0x19ce>
 1f80b6f:	lea    -0x1(%rdx),%r9d
 1f80b73:	mov    %rax,0xc0(%rsp)
 1f80b7b:	vpbroadcastq -0x19d1dfd(%rip),%zmm2        # 5aed88 <.LCPI0_0>
 1f80b85:	vmovdqa64 %zmm1,0x880(%rsp)
 1f80b8d:	vmovdqa64 %zmm18,%zmm1
 1f80b93:	vmovdqa64 %zmm31,%zmm0
 1f80b99:	vmovdqu64 (%r8),%zmm31
 1f80b9f:	vmovdqa64 -0x1aceb29(%rip),%zmm7        # 4b2080 <abi_test_hex.digits+0xb380>
 1f80ba9:	vmovdqa64 %zmm26,%zmm27
 1f80baf:	vmovdqa64 %zmm6,%zmm26
 1f80bb5:	vmovdqa64 %zmm22,%zmm24
 1f80bbb:	vmovdqa64 %zmm20,%zmm22
 1f80bc1:	vmovdqa64 %zmm11,%zmm20
 1f80bc7:	vmovdqa64 %zmm8,%zmm12
 1f80bcd:	mov    %rdx,0x178(%rsp)
 1f80bd5:	mov    0xb80(%rdi),%rdx
 1f80bdc:	mov    0xb88(%rdi),%rsi
 1f80be3:	mov    0xb90(%rdi),%r13
 1f80bea:	vmovdqa64 %zmm10,%zmm28
 1f80bf0:	mov    0xb98(%rdi),%rcx
 1f80bf7:	mov    %r9,%rbx
 1f80bfa:	shl    $0x6,%rbx
 1f80bfe:	test   %r9d,%r9d
 1f80c01:	mov    %r9,0x170(%rsp)
 1f80c09:	lea    -0x40(%rbx),%eax
 1f80c0c:	vpandq 0x2c(%r12,%rbx,1),%zmm2,%zmm18
 1f80c17:	vmovdqu64 0x196ac(%r12,%rbx,1),%zmm4
 1f80c22:	mov    %rbx,0x68(%rsp)
 1f80c27:	cmove  %r9d,%eax
 1f80c2b:	shl    $0x7,%r9
 1f80c2f:	vmovdqu64 0x6f654(%r12,%r9,1),%zmm2
 1f80c3a:	vmovdqu64 0x6f694(%r12,%r9,1),%zmm3
 1f80c45:	vmovdqu64 (%rdx,%rbx,1),%zmm21
 1f80c4c:	vmovdqu64 (%rsi,%rbx,1),%zmm30
 1f80c53:	vmovdqu64 0x0(%r13,%rbx,1),%zmm10
 1f80c5b:	vptestmb %zmm4,%zmm4,%k2
 1f80c61:	vpermt2b 0x40(%r8),%zmm18,%zmm31
 1f80c68:	vmovdqa64 %zmm18,%zmm6
 1f80c6e:	mov    0xba0(%rdi),%r8
 1f80c75:	vpmovuswb %zmm2,%ymm2
 1f80c7b:	vpmovuswb %zmm3,%ymm3
 1f80c81:	vmovdqa64 %zmm21,0x400(%rsp)
 1f80c89:	vmovdqa64 %zmm30,0x540(%rsp)
 1f80c91:	vmovdqa64 %zmm10,0x580(%rsp)
 1f80c99:	vmovdqu64 (%r8,%rbx,1),%zmm11
 1f80ca0:	vmovdqu64 (%r8,%rax,1),%zmm25
 1f80ca7:	vinserti64x4 $0x1,%ymm3,%zmm2,%zmm2
 1f80cae:	vpaddb -0x1acebf8(%rip),%zmm2,%zmm4        # 4b20c0 <abi_test_hex.digits+0xb3c0>
 1f80cb8:	vmovdqu64 0x6b554(%r12,%r9,1),%zmm3
 1f80cc3:	vpcmpleub %zmm7,%zmm2,%k1{%k2}
 1f80cca:	vmovdqa64 %zmm31,%zmm5
 1f80cd0:	kmovq  %k1,0xf0(%rsp)
 1f80cda:	vmovdqa64 %zmm11,0x440(%rsp)
 1f80ce2:	vpermt2b %zmm1,%zmm4,%zmm6
 1f80ce8:	vmovdqu64 0x6b594(%r12,%r9,1),%zmm1
 1f80cf3:	vpermt2b %zmm0,%zmm4,%zmm5{%k1}{z}
 1f80cf9:	vpmovuswb %zmm3,%ymm0
 1f80cff:	vmovdqu64 0x6d5d4(%r12,%r9,1),%zmm3
 1f80d0a:	vmovdqa64 %zmm4,0x840(%rsp)
 1f80d12:	vpandq %zmm8,%zmm11,%zmm4
 1f80d18:	vmovdqa64 -0x1acec22(%rip),%zmm8        # 4b2100 <abi_test_hex.digits+0xb400>
 1f80d22:	vptestmb %zmm4,%zmm4,%k4
 1f80d28:	kandq  %k4,%k2,%k2
 1f80d2d:	kmovq  %k4,0x60(%rsp)
 1f80d34:	vpmovuswb %zmm1,%ymm1
 1f80d3a:	vinserti64x4 $0x1,%ymm1,%zmm0,%zmm1
 1f80d41:	vpmovuswb %zmm3,%ymm0
 1f80d47:	vmovdqu64 0x6d614(%r12,%r9,1),%zmm3
 1f80d52:	vptestmb %zmm1,%zmm1,%k0
 1f80d58:	vpsubb %zmm1,%zmm8,%zmm4
 1f80d5e:	kandq  %k0,%k4,%k3
 1f80d63:	kmovq  %k0,%r10
 1f80d68:	vpcmpnltub %zmm1,%zmm8,%k0
 1f80d6f:	kmovq  %k0,%r14
 1f80d74:	and    %r10,%r14
 1f80d77:	vpmovuswb %zmm3,%ymm3
 1f80d7d:	vinserti64x4 $0x1,%ymm3,%zmm0,%zmm0
 1f80d84:	vpcmpltub -0x1acec4f(%rip),%zmm0,%k1        # 4b2140 <abi_test_hex.digits+0xb440>
 1f80d8f:	vmovdqu64 0x0(%r13,%rax,1),%zmm3
 1f80d97:	vptestmb %zmm0,%zmm0,%k5{%k1}
 1f80d9d:	vpcmpnleub %zmm7,%zmm2,%k1{%k2}
 1f80da4:	vbroadcasti32x4 -0x19d82fe(%rip),%zmm7        # 5a8ab0 <.LCPI0_48>
 1f80dae:	vpcmpltub %zmm1,%zmm8,%k2{%k3}
 1f80db5:	vmovdqu64 (%rdx,%rax,1),%zmm1
 1f80dbc:	vmovdqu64 (%rsi,%rax,1),%zmm2
 1f80dc3:	kmovq  %r14,%k3
 1f80dc8:	vpsubb %zmm0,%zmm8,%zmm0
 1f80dce:	vmovdqa64 %zmm3,%zmm8
 1f80dd4:	vpandq 0x2c(%r12,%rax,1),%zmm7,%zmm7
 1f80ddf:	vpermt2b %zmm11,%zmm4,%zmm25{%k3}{z}
 1f80de5:	vpermt2b %zmm10,%zmm4,%zmm8{%k3}{z}
 1f80deb:	kortestq %k1,%k2
 1f80df0:	kmovq  %k1,0x168(%rsp)
 1f80dfa:	vmovdqa64 %zmm25,0x1c0(%rsp)
 1f80e02:	vmovdqa64 %zmm1,%zmm29
 1f80e08:	vpermt2b %zmm21,%zmm4,%zmm29{%k3}{z}
 1f80e0e:	vpermt2b %zmm18,%zmm4,%zmm7{%k3}{z}
 1f80e14:	vmovdqa64 %zmm7,0x180(%rsp)
 1f80e1c:	vmovdqa64 %zmm2,%zmm7
 1f80e22:	vpermt2b %zmm30,%zmm4,%zmm7{%k3}{z}
 1f80e28:	jne    1f81dd3 <node_contexts_window_loop+0x1553>
 1f80e2e:	vmovdqa64 %zmm29,0x200(%rsp)
 1f80e36:	vmovdqa64 %zmm7,0x4c0(%rsp)
 1f80e3e:	vpxor  %xmm10,%xmm10,%xmm10
 1f80e43:	vmovdqa64 %zmm20,%zmm11
 1f80e49:	vmovdqa64 0x4c0(%rsp),%zmm25
 1f80e51:	vmovdqa64 %zmm22,%zmm20
 1f80e57:	vmovdqu64 0x1a72c(%r12,%rbx,1),%zmm22
 1f80e62:	vpandq %zmm11,%zmm8,%zmm8
 1f80e68:	vmovdqu64 (%rcx,%rbx,1),%zmm21
 1f80e6f:	vmovdqa64 0x540(%rsp),%zmm29
 1f80e77:	vpbroadcastq -0x19d20f1(%rip),%zmm14        # 5aed90 <.LCPI0_18>
 1f80e81:	vmovdqu64 (%rcx,%rax,1),%zmm7
 1f80e88:	kmovq  %k5,0x70(%rsp)
 1f80e8f:	mov    %r14,0x38(%rsp)
 1f80e94:	vpcmpeqb %zmm13,%zmm8,%k0
 1f80e9a:	vpternlogd $0xff,%zmm8,%zmm8,%zmm8
 1f80ea1:	vpaddb 0x400(%rsp),%zmm8,%zmm8
 1f80ea9:	kmovq  %k0,%rax
 1f80eae:	and    %r14,%rax
 1f80eb1:	vptestmb %zmm13,%zmm25,%k0
 1f80eb7:	vptestnmb %zmm22,%zmm22,%k1
 1f80ebd:	vmovdqa64 %zmm22,0x800(%rsp)
 1f80ec5:	vpandq %zmm15,%zmm21,%zmm22
 1f80ecb:	vpermt2b %zmm29,%zmm0,%zmm2{%k5}{z}
 1f80ed1:	vpandq %zmm14,%zmm31,%zmm30
 1f80ed7:	kmovq  %k0,%rcx
 1f80edc:	vptestmb -0x1aceb26(%rip),%zmm29,%k0        # 4b23c0 <abi_test_hex.digits+0xb6c0>
 1f80ee6:	vpcmpltub %zmm16,%zmm8,%k6
 1f80eed:	vmovdqa64 %zmm8,0x240(%rsp)
 1f80ef5:	vpandq %zmm20,%zmm21,%zmm8
 1f80efb:	vptestnmb %zmm22,%zmm22,%k5
 1f80f01:	vpcmpgtb %zmm5,%zmm10,%k4{%k1}
 1f80f07:	kmovq  %k1,0x158(%rsp)
 1f80f11:	vpcmpeqb %zmm17,%zmm22,%k7
 1f80f17:	vpandq 0x1c0(%rsp),%zmm19,%zmm10
 1f80f1f:	vmovdqa64 %zmm24,%zmm22
 1f80f25:	or     %rax,%rcx
 1f80f28:	kmovq  %k5,%rax
 1f80f2d:	vptestmb %zmm8,%zmm8,%k5
 1f80f33:	vpcmpeqb %zmm24,%zmm8,%k1
 1f80f39:	kmovq  %k4,%r15
 1f80f3e:	vpandq %zmm14,%zmm5,%zmm24
 1f80f44:	vmovdqa64 %zmm8,0x3c0(%rsp)
 1f80f4c:	kmovq  %k7,0x150(%rsp)
 1f80f56:	kmovq  %k6,0x90(%rsp)
 1f80f60:	mov    %rcx,0x40(%rsp)
 1f80f65:	kmovq  %k5,%rdx
 1f80f6a:	vpcmpeqb %zmm17,%zmm30,%k5
 1f80f70:	kmovq  %k1,0xe0(%rsp)
 1f80f7a:	andn   %rax,%r15,%rax
 1f80f7f:	mov    %r15,0xb0(%rsp)
 1f80f87:	vmovdqa64 %zmm24,0x500(%rsp)
 1f80f8f:	kmovq  %k5,%r10
 1f80f94:	mov    %r10,0xe8(%rsp)
 1f80f9c:	kmovq  %k0,%rcx
 1f80fa1:	vptestmb %zmm19,%zmm29,%k0
 1f80fa7:	korq   %k4,%k0,%k5
 1f80fac:	kandq  %k1,%k5,%k0
 1f80fb1:	kmovq  0xf0(%rsp),%k1
 1f80fbb:	kmovq  %k5,0xd8(%rsp)
 1f80fc5:	kmovq  %k0,%rsi
 1f80fca:	vptestmb %zmm28,%zmm29,%k0{%k7}
 1f80fd0:	or     %rax,%rsi
 1f80fd3:	kmovq  %k5,%rax
 1f80fd8:	and    %rdx,%rsi
 1f80fdb:	mov    %rax,0x80(%rsp)
 1f80fe3:	kmovq  %k0,%r9
 1f80fe8:	kandq  %k7,%k6,%k0
 1f80fed:	kmovq  %k0,%r8
 1f80ff2:	vpcmpeqb -0x1aceb3c(%rip),%zmm6,%k0{%k1}        # 4b24c0 <abi_test_hex.digits+0xb7c0>
 1f80ffc:	vpsllw $0x7,0x440(%rsp),%zmm6
 1f81005:	andn   %r9,%r15,%rdi
 1f8100a:	or     %rcx,%rdi
 1f8100d:	andn   %r8,%rax,%rax
 1f81012:	mov    %rdi,%rcx
 1f81015:	not    %rcx
 1f81018:	and    %r10,%rax
 1f8101b:	mov    %rdi,0x58(%rsp)
 1f81020:	mov    %rax,0x10(%rsp)
 1f81025:	kmovq  %k0,%r13
 1f8102a:	vpcmpeqb -0x1acea34(%rip),%zmm30,%k0        # 4b2600 <abi_test_hex.digits+0xb900>
 1f81034:	vpmovb2m %zmm6,%k1
 1f8103a:	kmovq  %k1,%r14
 1f8103f:	kmovq  %k1,0x140(%rsp)
 1f81049:	andn   %rsi,%r14,%rdx
 1f8104e:	mov    %r14,0x148(%rsp)
 1f81056:	andn   %rcx,%rdx,%rdi
 1f8105b:	cmpl   $0x0,0x7c(%rsp)
 1f81060:	mov    %rdx,0xa8(%rsp)
 1f81068:	mov    %rdi,0x28(%rsp)
 1f8106d:	kmovq  %k0,%r12
 1f81072:	jne    1f81fc3 <node_contexts_window_loop+0x1743>
 1f81078:	vbroadcasti32x4 -0x19d85c2(%rip),%zmm6        # 5a8ac0 <.LCPI0_49>
 1f81082:	vpandd -0x19cf8a4(%rip){1to16},%zmm31,%zmm5        # 5b17e8 <.LCPI0_50>
 1f8108c:	vmovdqa64 0x180(%rsp),%zmm29
 1f81094:	vbroadcasti32x4 -0x19d85ce(%rip),%zmm8        # 5a8ad0 <.LCPI0_51>
 1f8109e:	vpermi2b %zmm21,%zmm7,%zmm4{%k3}{z}
 1f810a4:	vpaddb -0x1ace96e(%rip),%zmm29,%zmm14        # 4b2740 <abi_test_hex.digits+0xba40>
 1f810ae:	vmovdqu8 0x780(%rsp),%zmm4{%k2}
 1f810b6:	vpcmpeqb %zmm6,%zmm30,%k5
 1f810bc:	vpcmpeqb %zmm8,%zmm24,%k0
 1f810c2:	vpcmpeqb %zmm6,%zmm24,%k2
 1f810c8:	vmovdqa64 %zmm26,%zmm6
 1f810ce:	vptestmb %zmm5,%zmm5,%k3{%k5}
 1f810d4:	vpcmpltub %zmm26,%zmm14,%k6
 1f810db:	vmovdqa64 %zmm27,%zmm26
 1f810e1:	vmovdqa64 %zmm10,%zmm14
 1f810e7:	kmovq  %k6,%rdx
 1f810ec:	kxorq  %k3,%k5,%k5
 1f810f1:	kandq  %k3,%k6,%k7
 1f810f6:	kmovq  %k3,%rcx
 1f810fb:	kandq  %k5,%k0,%k3
 1f81100:	kmovq  %k5,%r14
 1f81105:	vpcmpeqb -0x1aced0f(%rip),%zmm29,%k5        # 4b2400 <abi_test_hex.digits+0xb700>
 1f8110f:	korq   %k2,%k0,%k0
 1f81114:	mov    %rcx,0xd0(%rsp)
 1f8111c:	kmovq  %k7,%r9
 1f81121:	kmovq  %k3,%rcx
 1f81126:	and    %rdi,%rcx
 1f81129:	mov    %rcx,%rax
 1f8112c:	xor    %r14,%rax
 1f8112f:	or     %rcx,%r9
 1f81132:	and    %rdx,%rax
 1f81135:	kmovq  %k5,%rsi
 1f8113a:	vptestnmb -0x1acedc4(%rip),%zmm4,%k5        # 4b2380 <abi_test_hex.digits+0xb680>
 1f81144:	vpandd -0x19cf962(%rip){1to16},%zmm4,%zmm4        # 5b17ec <.LCPI0_52>
 1f8114e:	and    %rsi,%rcx
 1f81151:	or     %rax,%rcx
 1f81154:	vpcmpeqb %zmm27,%zmm4,%k6
 1f8115a:	vporq  %zmm2,%zmm25,%zmm4
 1f81160:	vptestnmb -0x1acee6a(%rip),%zmm4,%k1        # 4b2300 <abi_test_hex.digits+0xb600>
 1f8116a:	vptestmb %zmm10,%zmm10,%k6{%k6}
 1f81170:	korq   %k6,%k5,%k5
 1f81175:	kmovq  0x60(%rsp),%k6
 1f8117c:	kandq  %k5,%k0,%k2
 1f81181:	vpcmpeqb %zmm8,%zmm30,%k0{%k2}
 1f81187:	kmovq  %k1,%r10
 1f8118c:	vmovdqa64 %zmm12,%zmm8
 1f81192:	kmovq  %k0,%r8
 1f81197:	and    %rdi,%r8
 1f8119a:	or     %r8,%r9
 1f8119d:	xor    %r12,%r8
 1f811a0:	and    %r9,%r10
 1f811a3:	or     %r8,%rcx
 1f811a6:	or     %r9,%r13
 1f811a9:	mov    %rcx,%r12
 1f811ac:	mov    %r10,0xb8(%rsp)
 1f811b4:	vmovdqa64 0x440(%rsp),%zmm4
 1f811bc:	vpermt2b 0x580(%rsp),%zmm0,%zmm3
 1f811c4:	kmovq  0x70(%rsp),%k1
 1f811cb:	mov    %r12,0x160(%rsp)
 1f811d3:	vptestmb %zmm13,%zmm2,%k2
 1f811d9:	mov    %r13,0x130(%rsp)
 1f811e1:	vbroadcasti32x4 -0x19d87db(%rip),%zmm27        # 5a8a10 <.LCPI0_38>
 1f811eb:	mov    0x18(%rsp),%rdi
 1f811f0:	vbroadcasti32x4 -0x19d871a(%rip),%zmm24        # 5a8ae0 <.LCPI0_53>
 1f811fa:	vpermt2b %zmm21,%zmm0,%zmm7
 1f81200:	vpermt2b 0x400(%rsp),%zmm0,%zmm1
 1f81208:	vmovdqa64 %zmm28,%zmm10
 1f8120e:	mov    0xbb0(%rdi),%rsi
 1f81215:	vpandq %zmm20,%zmm7,%zmm2
 1f8121b:	vpandq %zmm28,%zmm25,%zmm7
 1f81221:	vpcmpeqb %zmm19,%zmm2,%k7{%k1}
 1f81227:	vmovdqu8 %zmm17,%zmm2{%k4}{z}
 1f8122d:	kmovq  0x90(%rsp),%k4
 1f81237:	vptestmb %zmm23,%zmm4,%k0
 1f8123d:	vpandq %zmm11,%zmm3,%zmm3
 1f81243:	kmovq  %k0,%r12
 1f81248:	vptestmb %zmm19,%zmm4,%k0
 1f8124e:	vmovdqa64 0x240(%rsp),%zmm4
 1f81256:	kmovq  %k0,%r9
 1f8125b:	vpcmpeqb %zmm13,%zmm3,%k0{%k1}
 1f81261:	vpcmpltub -0x1acefac(%rip),%zmm4,%k3        # 4b22c0 <abi_test_hex.digits+0xb5c0>
 1f8126c:	vmovdqa64 0x1c0(%rsp),%zmm3
 1f81274:	vmovdqu64 %zmm2,(%rsi,%rbx,1)
 1f8127b:	mov    %r12,0x50(%rsp)
 1f81280:	korq   %k0,%k2,%k0
 1f81285:	mov    0xbc0(%rdi),%rsi
 1f8128c:	kmovq  %k4,%r15
 1f81291:	mov    %r9,0x120(%rsp)
 1f81299:	kmovq  %k0,%r13
 1f8129e:	vpcmpeqb %zmm19,%zmm30,%k0
 1f812a4:	mov    %r15,0x110(%rsp)
 1f812ac:	kmovq  %k0,%rax
 1f812b1:	vpcmpeqb -0x1aced7b(%rip),%zmm30,%k0        # 4b2540 <abi_test_hex.digits+0xb840>
 1f812bb:	mov    %r13,0xa0(%rsp)
 1f812c3:	mov    %rax,0x118(%rsp)
 1f812cb:	vmovdqu64 %zmm30,(%rsi,%rbx,1)
 1f812d2:	mov    0x40(%rsp),%rsi
 1f812d7:	vpcmpltub %zmm27,%zmm4,%k2
 1f812de:	kmovq  %k0,%r14
 1f812e3:	vptestmb %zmm28,%zmm31,%k0{%k2}
 1f812e9:	vpcmpeqb %zmm24,%zmm30,%k2{%k3}
 1f812ef:	kmovq  %k2,%r8
 1f812f4:	vpmovb2m %zmm3,%k2
 1f812fa:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f81301:	vptestnmb %zmm29,%zmm29,%k2{%k2}
 1f81307:	vpaddb %zmm3,%zmm1,%zmm0
 1f8130d:	vpcmpltub %zmm16,%zmm0,%k5{%k1}
 1f81314:	kmovq  %k0,0x128(%rsp)
 1f8131e:	kandq  %k7,%k0,%k0
 1f81323:	knotq  %k0,%k0
 1f81328:	kmovq  %k0,%rcx
 1f8132d:	vptestmb %zmm7,%zmm7,%k0
 1f81333:	korq   %k2,%k0,%k0
 1f81338:	and    %rcx,%r8
 1f8133b:	kmovq  %k6,%rcx
 1f81340:	knotq  %k0,%k0
 1f81345:	mov    %rcx,0x70(%rsp)
 1f8134a:	kmovq  %k0,%rdx
 1f8134f:	vptestmb %zmm5,%zmm5,%k0
 1f81355:	vmovdqa64 %zmm30,%zmm5
 1f8135b:	korq   %k5,%k0,%k0
 1f81360:	kmovq  %k0,%r10
 1f81365:	or     %rsi,%r10
 1f81368:	and    %rdx,%r10
 1f8136b:	mov    %rax,%rdx
 1f8136e:	or     %r14,%rdx
 1f81371:	not    %r14
 1f81374:	mov    %r13,%rax
 1f81377:	or     %r12,%rax
 1f8137a:	or     %r15,%r14
 1f8137d:	or     0x80(%rsp),%r14
 1f81385:	mov    0x28(%rsp),%r15
 1f8138a:	andn   %rdx,%rax,%rax
 1f8138f:	mov    0x10(%rsp),%rdx
 1f81394:	and    %rcx,%r14
 1f81397:	and    %r15,%r8
 1f8139a:	and    %r9,%rdx
 1f8139d:	and    %r15,%r14
 1f813a0:	and    %r8,%r10
 1f813a3:	mov    %rdx,%r9
 1f813a6:	mov    %r8,0x138(%rsp)
 1f813ae:	and    %rax,%r14
 1f813b1:	mov    %r10,0x80(%rsp)
 1f813b9:	or     %r10,%r14
 1f813bc:	and    %rsi,%r14
 1f813bf:	je     1f81610 <node_contexts_window_loop+0xd90>
 1f813c5:	vbroadcasti32x4 -0x19d890f(%rip),%zmm28        # 5a8ac0 <.LCPI0_49>
 1f813cf:	vbroadcasti32x4 -0x19d88e9(%rip),%zmm29        # 5a8af0 <.LCPI0_54>
 1f813d9:	vbroadcasti32x4 -0x19d8993(%rip),%zmm30        # 5a8a50 <.LCPI0_42>
 1f813e3:	mov    %rbx,%r8
 1f813e6:	shl    $0x6,%r8
 1f813ea:	add    0x2c0(%rdi),%r8
 1f813f1:	mov    0x20(%rdi),%rbx
 1f813f5:	mov    0x60(%rdi),%r12d
 1f813f9:	mov    0x30(%rsp),%rdx
 1f813fe:	mov    %r14,%r13
 1f81401:	vmovdqa64 %zmm14,%zmm1
 1f81407:	nopw   0x0(%rax,%rax,1)
 1f81410:	xor    %r15d,%r15d
 1f81413:	tzcnt  %r13,%r15
 1f81418:	mov    %r15d,%eax
 1f8141b:	shl    $0x6,%eax
 1f8141e:	mov    0x20(%r8,%rax,1),%esi
 1f81423:	mov    %esi,%ecx
 1f81425:	shr    $0x3,%ecx
 1f81428:	cmp    %r12d,%ecx
 1f8142b:	cmovae %r12d,%ecx
 1f8142f:	shl    $0x6,%rcx
 1f81433:	cmpl   $0x0,0x38(%rbx,%rcx,1)
 1f81438:	setne  %al
 1f8143b:	testb  $0x4,0x34(%rbx,%rcx,1)
 1f81440:	je     1f81460 <node_contexts_window_loop+0xbe0>
 1f81442:	xor    $0x1,%al
 1f81444:	inc    %rdx
 1f81447:	movzbl %al,%eax
 1f8144a:	shlx   %r15,%rax,%rax
 1f8144f:	andn   %r14,%rax,%r14
 1f81454:	blsr   %r13,%r13
 1f81459:	jne    1f81410 <node_contexts_window_loop+0xb90>
 1f8145b:	jmp    1f8163c <node_contexts_window_loop+0xdbc>
 1f81460:	mov    0x18(%rsp),%rdi
 1f81465:	vmovdqa64 %zmm9,0x380(%rsp)
 1f8146d:	mov    %r11d,0x8(%rsp)
 1f81472:	vmovdqa64 %zmm18,0x340(%rsp)
 1f8147a:	mov    %rdx,0x30(%rsp)
 1f8147f:	vmovdqa64 %zmm31,0x300(%rsp)
 1f81487:	vmovdqa64 %zmm21,0x2c0(%rsp)
 1f8148f:	vmovdqa64 %zmm5,0x280(%rsp)
 1f81497:	kmovq  %k7,0x48(%rsp)
 1f8149e:	mov    %r9,0x10(%rsp)
 1f814a3:	vmovdqa64 %zmm1,0x480(%rsp)
 1f814ab:	vmovdqa64 %zmm7,0x7c0(%rsp)
 1f814b3:	kmovq  %k5,0x100(%rsp)
 1f814bd:	mov    %r8,0xf8(%rsp)
 1f814c5:	vzeroupper
 1f814c8:	call   1f828ba <node_contexts_stride_asked>
 1f814cd:	vmovdqa64 0x7c0(%rsp),%zmm7
 1f814d5:	vmovdqa64 0x240(%rsp),%zmm4
 1f814dd:	vmovdqa64 0x480(%rsp),%zmm1
 1f814e5:	vmovdqa64 0x280(%rsp),%zmm5
 1f814ed:	vmovdqa64 0x300(%rsp),%zmm31
 1f814f5:	vbroadcasti32x4 -0x19d8aaf(%rip),%zmm30        # 5a8a50 <.LCPI0_42>
 1f814ff:	vbroadcasti32x4 -0x19d8a19(%rip),%zmm29        # 5a8af0 <.LCPI0_54>
 1f81509:	vbroadcasti32x4 -0x19d8a53(%rip),%zmm28        # 5a8ac0 <.LCPI0_49>
 1f81513:	vbroadcasti32x4 -0x19d8b0d(%rip),%zmm27        # 5a8a10 <.LCPI0_38>
 1f8151d:	vbroadcasti32x4 -0x19d8a87(%rip),%zmm26        # 5a8aa0 <.LCPI0_47>
 1f81527:	vbroadcasti32x4 -0x19d8aa1(%rip),%zmm6        # 5a8a90 <.LCPI0_46>
 1f81531:	vbroadcasti32x4 -0x19d8a5b(%rip),%zmm24        # 5a8ae0 <.LCPI0_53>
 1f8153b:	vbroadcasti32x4 -0x19d8ab5(%rip),%zmm23        # 5a8a90 <.LCPI0_46>
 1f81545:	vbroadcasti32x4 -0x19d8acf(%rip),%zmm22        # 5a8a80 <.LCPI0_45>
 1f8154f:	vbroadcasti32x4 -0x19d8ae9(%rip),%zmm15        # 5a8a70 <.LCPI0_44>
 1f81559:	vmovdqa64 0x2c0(%rsp),%zmm21
 1f81561:	vbroadcasti32x4 -0x19d8b0b(%rip),%zmm20        # 5a8a60 <.LCPI0_43>
 1f8156b:	vbroadcasti32x4 -0x19d8b25(%rip),%zmm19        # 5a8a50 <.LCPI0_42>
 1f81575:	vmovdqa64 0x340(%rsp),%zmm18
 1f8157d:	vbroadcasti32x4 -0x19d8b47(%rip),%zmm17        # 5a8a40 <.LCPI0_41>
 1f81587:	vbroadcasti32x4 -0x19d8b61(%rip),%zmm16        # 5a8a30 <.LCPI0_40>
 1f81591:	vbroadcasti32x4 -0x19d8b7b(%rip),%zmm10        # 5a8a20 <.LCPI0_39>
 1f8159b:	vbroadcasti32x4 -0x19d8b95(%rip),%zmm13        # 5a8a10 <.LCPI0_38>
 1f815a5:	vbroadcasti32x4 -0x19d8baf(%rip),%zmm11        # 5a8a00 <.LCPI0_37>
 1f815af:	vbroadcasti32x4 -0x19d8bc9(%rip),%zmm8        # 5a89f0 <.LCPI0_36>
 1f815b9:	vmovdqa64 0x380(%rsp),%zmm9
 1f815c1:	mov    0xf8(%rsp),%r8
 1f815c9:	kmovq  0x100(%rsp),%k5
 1f815d3:	kmovq  0x90(%rsp),%k4
 1f815dd:	mov    0x10(%rsp),%r9
 1f815e2:	kmovq  0x48(%rsp),%k7
 1f815e9:	kmovq  0x60(%rsp),%k6
 1f815f0:	mov    0x30(%rsp),%rdx
 1f815f5:	mov    0x8(%rsp),%r11d
 1f815fa:	incq   0xc8(%rsp)
 1f81602:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f81609:	jmp    1f81442 <node_contexts_window_loop+0xbc2>
 1f8160e:	xchg   %ax,%ax
 1f81610:	vbroadcasti32x4 -0x19d8b5a(%rip),%zmm28        # 5a8ac0 <.LCPI0_49>
 1f8161a:	vbroadcasti32x4 -0x19d8b34(%rip),%zmm29        # 5a8af0 <.LCPI0_54>
 1f81624:	vbroadcasti32x4 -0x19d8bde(%rip),%zmm30        # 5a8a50 <.LCPI0_42>
 1f8162e:	mov    0x30(%rsp),%rdx
 1f81633:	xor    %r14d,%r14d
 1f81636:	vmovdqa64 %zmm14,%zmm1
 1f8163c:	vmovdqa64 0x180(%rsp),%zmm0
 1f81644:	vpcmpeqb 0x3c0(%rsp),%zmm13,%k2{%k4}
 1f8164c:	mov    %rdx,0x30(%rsp)
 1f81651:	mov    0x58(%rsp),%rdx
 1f81656:	mov    0x50(%rsp),%rsi
 1f8165b:	vptestnmb %zmm7,%zmm7,%k3
 1f81661:	mov    0x28(%rsp),%r13
 1f81666:	kmovq  %k3,%r12
 1f8166b:	and    %r13,%r9
 1f8166e:	mov    %r9,0x10(%rsp)
 1f81673:	vptestnmb %zmm0,%zmm0,%k1
 1f81679:	vpaddb 0x200(%rsp),%zmm3,%zmm0
 1f81681:	vptestmb %zmm1,%zmm1,%k0{%k1}
 1f81687:	kmovq  %k1,0x480(%rsp)
 1f81691:	vpcmpltub %zmm13,%zmm4,%k1
 1f81698:	korq   %k2,%k1,%k1
 1f8169d:	kmovq  0xe0(%rsp),%k2
 1f816a7:	kmovq  %k0,%rax
 1f816ac:	vpcmpeqb %zmm15,%zmm5,%k0
 1f816b2:	korq   %k1,%k2,%k1
 1f816b7:	and    %rax,0x38(%rsp)
 1f816bc:	vpcmpeqb %zmm13,%zmm5,%k2{%k4}
 1f816c2:	kmovq  %k1,%rax
 1f816c7:	kmovq  %k2,%rcx
 1f816cc:	andn   %rax,%rdx,%rax
 1f816d1:	mov    0xa0(%rsp),%rdx
 1f816d9:	and    %rcx,%r12
 1f816dc:	mov    %rax,0x3c0(%rsp)
 1f816e4:	kmovq  %k0,%rax
 1f816e9:	vpcmpltub %zmm16,%zmm0,%k0{%k5}
 1f816f0:	vpaddb -0x1acf13a(%rip),%zmm5,%zmm0        # 4b25c0 <abi_test_hex.digits+0xb8c0>
 1f816fa:	or     0x40(%rsp),%rdx
 1f816ff:	andn   %rax,%rsi,%rdi
 1f81704:	mov    0x110(%rsp),%rsi
 1f8170c:	andn   0x118(%rsp),%rdx,%rcx
 1f81716:	kmovq  %k0,%rdx
 1f8171b:	mov    %rdx,%r8
 1f8171e:	andn   %rsi,%rdx,%rbx
 1f81723:	and    0x70(%rsp),%rbx
 1f81728:	and    %rsi,%r8
 1f8172b:	and    %r13,%r8
 1f8172e:	vpcmpltub %zmm23,%zmm0,%k1
 1f81735:	kmovq  %k1,%rax
 1f8173a:	or     %rax,%rcx
 1f8173d:	and    %rcx,%rbx
 1f81740:	and    %rcx,%r8
 1f81743:	and    %r13,%rbx
 1f81746:	je     1f81930 <node_contexts_window_loop+0x10b0>
 1f8174c:	mov    0x18(%rsp),%rax
 1f81751:	mov    0xc0(%rsp),%r13
 1f81759:	xor    %r15d,%r15d
 1f8175c:	mov    %r12,0x50(%rsp)
 1f81761:	mov    %r8,0x180(%rsp)
 1f81769:	mov    %rdi,0x58(%rsp)
 1f8176e:	kmovq  %k7,0x48(%rsp)
 1f81775:	vmovdqa64 %zmm5,0x280(%rsp)
 1f8177d:	vmovdqa64 %zmm21,0x2c0(%rsp)
 1f81785:	vmovdqa64 %zmm31,0x300(%rsp)
 1f8178d:	vmovdqa64 %zmm18,0x340(%rsp)
 1f81795:	mov    %r11d,0x8(%rsp)
 1f8179a:	vmovdqa64 %zmm9,0x380(%rsp)
 1f817a2:	mov    (%rax),%rcx
 1f817a5:	mov    0x2c0(%rax),%rax
 1f817ac:	mov    %rcx,0x240(%rsp)
 1f817b4:	mov    %rax,0x200(%rsp)
 1f817bc:	mov    0x68(%rsp),%rax
 1f817c1:	mov    0x240(%rsp),%rdi
 1f817c9:	mov    0x200(%rsp),%rsi
 1f817d1:	xor    %r12d,%r12d
 1f817d4:	tzcnt  %rbx,%r12
 1f817d9:	lea    (%rax,%r12,1),%edx
 1f817dd:	vzeroupper
 1f817e0:	call   1f82870 <node_contexts_converted>
 1f817e5:	movzbl %al,%eax
 1f817e8:	inc    %r13
 1f817eb:	shlx   %r12,%rax,%rax
 1f817f0:	or     %rax,%r15
 1f817f3:	blsr   %rbx,%rbx
 1f817f8:	jne    1f817bc <node_contexts_window_loop+0xf3c>
 1f817fa:	vmovdqa64 0x380(%rsp),%zmm9
 1f81802:	vbroadcasti32x4 -0x19d8e1c(%rip),%zmm8        # 5a89f0 <.LCPI0_36>
 1f8180c:	vbroadcasti32x4 -0x19d8e16(%rip),%zmm11        # 5a8a00 <.LCPI0_37>
 1f81816:	vbroadcasti32x4 -0x19d8e10(%rip),%zmm13        # 5a8a10 <.LCPI0_38>
 1f81820:	vbroadcasti32x4 -0x19d8e0a(%rip),%zmm10        # 5a8a20 <.LCPI0_39>
 1f8182a:	vbroadcasti32x4 -0x19d8e04(%rip),%zmm16        # 5a8a30 <.LCPI0_40>
 1f81834:	vbroadcasti32x4 -0x19d8dfe(%rip),%zmm17        # 5a8a40 <.LCPI0_41>
 1f8183e:	vmovdqa64 0x340(%rsp),%zmm18
 1f81846:	vbroadcasti32x4 -0x19d8e00(%rip),%zmm19        # 5a8a50 <.LCPI0_42>
 1f81850:	vbroadcasti32x4 -0x19d8dfa(%rip),%zmm20        # 5a8a60 <.LCPI0_43>
 1f8185a:	vbroadcasti32x4 -0x19d8df4(%rip),%zmm15        # 5a8a70 <.LCPI0_44>
 1f81864:	vbroadcasti32x4 -0x19d8dee(%rip),%zmm22        # 5a8a80 <.LCPI0_45>
 1f8186e:	vbroadcasti32x4 -0x19d8de8(%rip),%zmm23        # 5a8a90 <.LCPI0_46>
 1f81878:	vbroadcasti32x4 -0x19d8da2(%rip),%zmm24        # 5a8ae0 <.LCPI0_53>
 1f81882:	vbroadcasti32x4 -0x19d8dfc(%rip),%zmm6        # 5a8a90 <.LCPI0_46>
 1f8188c:	vbroadcasti32x4 -0x19d8df6(%rip),%zmm26        # 5a8aa0 <.LCPI0_47>
 1f81896:	vbroadcasti32x4 -0x19d8e90(%rip),%zmm27        # 5a8a10 <.LCPI0_38>
 1f818a0:	vbroadcasti32x4 -0x19d8dea(%rip),%zmm28        # 5a8ac0 <.LCPI0_49>
 1f818aa:	vbroadcasti32x4 -0x19d8dc4(%rip),%zmm29        # 5a8af0 <.LCPI0_54>
 1f818b4:	vbroadcasti32x4 -0x19d8e6e(%rip),%zmm30        # 5a8a50 <.LCPI0_42>
 1f818be:	vmovdqa64 0x300(%rsp),%zmm31
 1f818c6:	vmovdqa64 0x2c0(%rsp),%zmm21
 1f818ce:	vmovdqa64 0x280(%rsp),%zmm5
 1f818d6:	mov    0x180(%rsp),%r8
 1f818de:	mov    %r13,0xc0(%rsp)
 1f818e6:	mov    0x8(%rsp),%r11d
 1f818eb:	kmovq  0x60(%rsp),%k6
 1f818f2:	mov    0x18(%rsp),%r10
 1f818f7:	mov    0x28(%rsp),%r13
 1f818fc:	kmovq  0x48(%rsp),%k7
 1f81903:	mov    0x10(%rsp),%r9
 1f81908:	kmovq  0x90(%rsp),%k4
 1f81912:	mov    0x58(%rsp),%rdi
 1f81917:	mov    0x50(%rsp),%r12
 1f8191c:	or     %r15,%r8
 1f8191f:	jmp    1f81935 <node_contexts_window_loop+0x10b5>
 1f81921:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f81930:	mov    0x18(%rsp),%r10
 1f81935:	vmovdqa64 0x440(%rsp),%zmm0
 1f8193d:	kmovq  0xd8(%rsp),%k0
 1f81947:	vbroadcasti32x4 -0x19d8eb1(%rip),%zmm4        # 5a8aa0 <.LCPI0_47>
 1f81951:	and    %r13,%r12
 1f81954:	mov    %r9,%r15
 1f81957:	mov    0x3c0(%rsp),%rbx
 1f8195f:	mov    %r8,0x180(%rsp)
 1f81967:	mov    %r12,%rdx
 1f8196a:	and    0xa8(%rsp),%rbx
 1f81972:	korq   %k4,%k0,%k2
 1f81977:	kmovq  %k2,%rax
 1f8197c:	and    %rax,%rdi
 1f8197f:	mov    0x38(%rsp),%rax
 1f81984:	vptestmb %zmm13,%zmm0,%k0
 1f8198a:	vpcmpeqb %zmm4,%zmm5,%k1
 1f81990:	kmovq  %k0,%rsi
 1f81995:	vptestmb 0x1c0(%rsp),%zmm13,%k0
 1f8199d:	and    %rsi,%r15
 1f819a0:	mov    %rsi,0x240(%rsp)
 1f819a8:	and    %rax,%rdx
 1f819ab:	andn   %r12,%rax,%rax
 1f819b0:	mov    0x20(%rsp),%r12
 1f819b5:	mov    %rax,0x38(%rsp)
 1f819ba:	kmovq  %k0,%rcx
 1f819bf:	vptestmb %zmm10,%zmm0,%k0{%k1}
 1f819c5:	andn   %rdx,%rcx,%r9
 1f819ca:	and    %rcx,%rdx
 1f819cd:	mov    %rdx,0x200(%rsp)
 1f819d5:	mov    0xb0(%rsp),%rdx
 1f819dd:	mov    %r9,0xa8(%rsp)
 1f819e5:	kmovq  %k0,%rax
 1f819ea:	andn   %rax,%rdx,%rcx
 1f819ef:	cmpb   $0x0,0xf(%rsp)
 1f819f4:	mov    0x80(%rsp),%rdx
 1f819fc:	mov    %rcx,0x1c0(%rsp)
 1f81a04:	jne    1f82011 <node_contexts_window_loop+0x1791>
 1f81a0a:	vpsllw $0x7,0x540(%rsp),%zmm0
 1f81a13:	vpcmpnleub 0x400(%rsp),%zmm24,%k0
 1f81a1c:	andn   0x40(%rsp),%r14,%rax
 1f81a23:	mov    0x38(%rsp),%r10
 1f81a28:	or     %rbx,%r15
 1f81a2b:	mov    0x200(%rsp),%r9
 1f81a33:	andn   %rdx,%rax,%rax
 1f81a38:	or     %r10,%r15
 1f81a3b:	mov    %r10,%r8
 1f81a3e:	or     %r9,%r8
 1f81a41:	vpmovb2m %zmm0,%k1
 1f81a47:	vpandq 0x4c0(%rsp),%zmm17,%zmm0
 1f81a4f:	korq   %k1,%k0,%k1
 1f81a54:	vpcmpeqb %zmm23,%zmm5,%k0{%k1}
 1f81a5a:	vpcmpeqb -0x1acf4e4(%rip),%zmm5,%k1        # 4b2580 <abi_test_hex.digits+0xb880>
 1f81a64:	korq   %k0,%k1,%k0
 1f81a69:	vpcmpeqb %zmm16,%zmm5,%k1{%k2}
 1f81a6f:	vpcmpeqb -0x1acf3f9(%rip),%zmm5,%k2{%k4}        # 4b2680 <abi_test_hex.digits+0xb980>
 1f81a79:	kmovq  %k1,%rcx
 1f81a7e:	vpcmpeqb %zmm28,%zmm5,%k1
 1f81a84:	vptestnmb %zmm0,%zmm0,%k1{%k1}
 1f81a8a:	mov    %rcx,%rsi
 1f81a8d:	kmovq  %k2,%rdx
 1f81a92:	or     %rdx,%rsi
 1f81a95:	and    %r13,%rsi
 1f81a98:	or     %rsi,%r15
 1f81a9b:	kmovq  %k1,%rsi
 1f81aa0:	or     %rsi,%rdi
 1f81aa3:	mov    %rdi,%rbx
 1f81aa6:	kmovq  %k0,%rdi
 1f81aab:	or     %rdx,%rbx
 1f81aae:	mov    0x180(%rsp),%rdx
 1f81ab6:	or     %rdi,%rsi
 1f81ab9:	and    %r13,%rbx
 1f81abc:	or     %rcx,%rsi
 1f81abf:	or     %rdi,%rcx
 1f81ac2:	mov    0xa8(%rsp),%rdi
 1f81aca:	and    %r13,%rcx
 1f81acd:	or     0x10(%rsp),%rcx
 1f81ad2:	and    %r13,%rsi
 1f81ad5:	mov    %rax,0x10(%rsp)
 1f81ada:	or     %rsi,%r8
 1f81add:	or     %rdx,%r8
 1f81ae0:	kmovq  %r8,%k1
 1f81ae5:	or     %rdi,%r15
 1f81ae8:	or     %rdi,%r10
 1f81aeb:	or     %rdx,%r15
 1f81aee:	or     %r9,%r10
 1f81af1:	kmovq  %r15,%k3
 1f81af6:	or     %r10,%rcx
 1f81af9:	or     %r10,%rbx
 1f81afc:	vmovdqu8 -0x1acf806(%rip),%zmm0{%k3}{z}        # 4b2300 <abi_test_hex.digits+0xb600>
 1f81b06:	or     %r14,%rcx
 1f81b09:	or     %r14,%rbx
 1f81b0c:	kmovq  %rcx,%k4
 1f81b11:	mov    0x1c0(%rsp),%rcx
 1f81b19:	or     %rdx,%rbx
 1f81b1c:	cmpl   $0x0,0x7c(%rsp)
 1f81b21:	kmovq  %rbx,%k2
 1f81b26:	kmovq  %rcx,%k5
 1f81b2b:	vporq  %zmm30,%zmm0,%zmm1
 1f81b31:	vmovdqu8 %zmm1,%zmm0{%k4}
 1f81b37:	vporq  %zmm23,%zmm0,%zmm1
 1f81b3d:	vmovdqu8 %zmm1,%zmm0{%k1}
 1f81b43:	vporq  %zmm27,%zmm0,%zmm1
 1f81b49:	kmovq  %rax,%k1
 1f81b4e:	vmovdqu8 %zmm1,%zmm0{%k2}
 1f81b54:	vmovdqu8 -0x1acf31e(%rip),%zmm0{%k5}        # 4b2840 <abi_test_hex.digits+0xbb40>
 1f81b5e:	vmovdqu8 -0x1acf2e8(%rip),%zmm0{%k1}        # 4b2880 <abi_test_hex.digits+0xbb80>
 1f81b68:	jne    1f81b81 <node_contexts_window_loop+0x1301>
 1f81b6a:	mov    0xb8(%rsp),%rax
 1f81b72:	kmovq  %rax,%k1
 1f81b77:	vmovdqu8 -0x1acf2c1(%rip),%zmm0{%k1}        # 4b28c0 <abi_test_hex.digits+0xbbc0>
 1f81b81:	vmovdqa64 0x800(%rsp),%zmm1
 1f81b89:	mov    0x10(%rsp),%rdx
 1f81b8e:	mov    0x40(%rsp),%rax
 1f81b93:	vmovdqa64 0x840(%rsp),%zmm3
 1f81b9b:	mov    0x18(%rsp),%r8
 1f81ba0:	mov    0x88(%rsp),%rdi
 1f81ba8:	mov    0x68(%rsp),%r9
 1f81bad:	vmovdqa64 0x500(%rsp),%zmm7
 1f81bb5:	xor    %r15d,%r15d
 1f81bb8:	mov    $0xffffffffffffffff,%rsi
 1f81bbf:	and    %rdx,%rax
 1f81bc2:	vptestmb %zmm1,%zmm1,%k1
 1f81bc8:	vmovdqa64 %zmm0,%zmm1
 1f81bce:	vmovdqu8 %zmm17,%zmm2{%k1}{z}
 1f81bd4:	kmovq  0x480(%rsp),%k1
 1f81bde:	kmovq  %k1,%rcx
 1f81be3:	andn   %rdx,%rcx,%rcx
 1f81be8:	mov    %r11d,%edx
 1f81beb:	sub    %r9d,%edx
 1f81bee:	kmovq  %rcx,%k1
 1f81bf3:	mov    0xba8(%r8),%rcx
 1f81bfa:	vpaddb %zmm6,%zmm0,%zmm1{%k1}
 1f81c00:	kmovq  %rax,%k1
 1f81c05:	mov    0x130(%rsp),%rax
 1f81c0d:	vpaddb %zmm30,%zmm1,%zmm1{%k1}
 1f81c13:	kmovq  0xf0(%rsp),%k1
 1f81c1d:	not    %rax
 1f81c20:	vpermi2b 0x880(%rsp),%zmm1,%zmm3{%k1}{z}
 1f81c28:	kmovq  0x168(%rsp),%k1
 1f81c32:	vmovdqu8 0x600(%rsp),%zmm3{%k1}
 1f81c3a:	kmovq  %rax,%k1
 1f81c3f:	vpaddw %zmm3,%zmm3,%zmm3
 1f81c45:	vporq  %zmm2,%zmm3,%zmm2
 1f81c4b:	vpermb 0x80(%rdi),%zmm2,%zmm2
 1f81c52:	vmovdqu64 %zmm0,(%rcx,%r9,1)
 1f81c59:	mov    0xbb8(%r8),%rcx
 1f81c60:	vpandq %zmm28,%zmm2,%zmm3
 1f81c66:	vmovdqu8 %zmm3,%zmm3{%k1}{z}
 1f81c6c:	vmovdqu64 %zmm3,(%rcx,%r9,1)
 1f81c73:	mov    $0xffffffffffffffff,%rcx
 1f81c7a:	jbe    1f81c8c <node_contexts_window_loop+0x140c>
 1f81c7c:	lea    0x40(%r9),%ecx
 1f81c80:	cmp    %ecx,%r11d
 1f81c83:	shlx   %rdx,%rsi,%rcx
 1f81c88:	cmovae %r15,%rcx
 1f81c8c:	vmovdqa64 0x400(%rsp),%zmm3
 1f81c94:	kmovq  0xd8(%rsp),%k1
 1f81c9e:	mov    0x240(%rsp),%r8
 1f81ca6:	mov    0xe8(%rsp),%rax
 1f81cae:	mov    $0xffffffffffffffff,%r14
 1f81cb5:	movabs $0x7fffffffffffffff,%rbx
 1f81cbf:	vptestnmb %zmm3,%zmm3,%k0{%k6}
 1f81cc5:	korq   %k1,%k0,%k0
 1f81cca:	kmovq  0x158(%rsp),%k1
 1f81cd4:	kmovq  %k0,%rdx
 1f81cd9:	vptestmb %zmm29,%zmm21,%k0
 1f81cdf:	and    %rdx,%r13
 1f81ce2:	or     0x148(%rsp),%r13
 1f81cea:	kmovq  %k1,%rdx
 1f81cef:	kmovq  0x150(%rsp),%k1
 1f81cf9:	and    %rax,%r13
 1f81cfc:	mov    %r13,0x28(%rsp)
 1f81d01:	korq   %k1,%k0,%k0
 1f81d06:	kmovq  0x140(%rsp),%k1
 1f81d10:	korq   %k1,%k0,%k0
 1f81d15:	knotq  %k0,%k0
 1f81d1a:	kmovq  %k0,%rdi
 1f81d1f:	kmovq  0xe0(%rsp),%k0
 1f81d29:	and    %rdx,%rdi
 1f81d2c:	kmovq  %k0,%rsi
 1f81d31:	and    0x120(%rsp),%rsi
 1f81d39:	vpcmpeqb %zmm4,%zmm7,%k0
 1f81d3f:	kmovq  %k0,%rdx
 1f81d44:	vpmovb2m %zmm2,%k0
 1f81d4a:	and    %rdi,%rdx
 1f81d4d:	and    %rdx,%rsi
 1f81d50:	kmovq  %k0,%rdx
 1f81d55:	and    %rsi,%r8
 1f81d58:	andn   %rdx,%r8,%rdx
 1f81d5d:	mov    %rdx,%rdi
 1f81d60:	or     %rax,%rdi
 1f81d63:	andn   0x70(%rsp),%rdi,%rdi
 1f81d6a:	mov    %r9,%rax
 1f81d6d:	je     1f80a00 <node_contexts_window_loop+0x180>
 1f81d73:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f81d80:	xor    %r8d,%r8d
 1f81d83:	tzcnt  %rdi,%r8
 1f81d88:	mov    %r11d,%r13d
 1f81d8b:	lea    (%rax,%r8,1),%r9d
 1f81d8f:	sub    0x651b8(%r12,%r9,4),%r9d
 1f81d97:	lea    0x1(%r9),%r9d
 1f81d9b:	cmovb  %r15d,%r9d
 1f81d9f:	mov    %r9d,%r10d
 1f81da2:	sub    %eax,%r10d
 1f81da5:	cmp    %r11d,%r9d
 1f81da8:	cmovb  %r9d,%r11d
 1f81dac:	cmp    %eax,%r9d
 1f81daf:	shlx   %r10,%r14,%r10
 1f81db4:	cmovbe %rbx,%r10
 1f81db8:	cmovb  %r11d,%r13d
 1f81dbc:	bzhi   %r8,%r10,%r8
 1f81dc1:	mov    %r13d,%r11d
 1f81dc4:	or     %r8,%rcx
 1f81dc7:	blsr   %rdi,%rdi
 1f81dcc:	jne    1f81d80 <node_contexts_window_loop+0x1500>
 1f81dce:	jmp    1f80a00 <node_contexts_window_loop+0x180>
 1f81dd3:	kmovq  %k1,%r10
 1f81dd8:	kmovq  %k2,%r9
 1f81ddd:	mov    %r14,0x38(%rsp)
 1f81de2:	mov    %r11d,0x8(%rsp)
 1f81de7:	mov    %rbx,%rdi
 1f81dea:	test   %r10,%r10
 1f81ded:	je     1f81eac <node_contexts_window_loop+0x162c>
 1f81df3:	mov    0x18(%rsp),%r11
 1f81df8:	mov    %r10,%rbx
 1f81dfb:	mov    0xba8(%r11),%r11
 1f81e02:	mov    %r11,0x40(%rsp)
 1f81e07:	xor    %r11d,%r11d
 1f81e0a:	tzcnt  %rbx,%r11
 1f81e0f:	mov    0x88(%rsp),%r14
 1f81e17:	lea    (%rdi,%r11,1),%r15d
 1f81e1b:	mov    %r11,0x28(%rsp)
 1f81e20:	mov    0x20(%rsp),%r11
 1f81e25:	mov    0x40(%rsp),%rdi
 1f81e2a:	movzwl 0x6f654(%r11,%r15,2),%r12d
 1f81e33:	mov    0x20(%rsp),%r11
 1f81e38:	add    %r15d,%r12d
 1f81e3b:	movzbl 0x2c(%r11,%r12,1),%r15d
 1f81e41:	mov    0x20(%rsp),%r11
 1f81e46:	movzbl (%rdi,%r12,1),%edi
 1f81e4b:	movzwl 0x6b554(%r11,%r12,2),%r11d
 1f81e54:	and    $0x7f,%r15d
 1f81e58:	movzbl (%r14,%r15,1),%r15d
 1f81e5d:	mov    0x28(%rsp),%r14
 1f81e62:	sub    %r11d,%r12d
 1f81e65:	mov    0x20(%rsp),%r11
 1f81e6a:	testb  $0x7f,0x2c(%r11,%r12,1)
 1f81e70:	mov    0x20(%rsp),%r12
 1f81e75:	mov    %r15b,0x5c0(%rsp,%r14,1)
 1f81e7d:	setne  %r11b
 1f81e81:	add    %r11b,%r11b
 1f81e84:	or     $0x14,%r11b
 1f81e88:	cmp    $0x14,%dil
 1f81e8c:	movzbl %r11b,%r11d
 1f81e90:	cmovne %edi,%r11d
 1f81e94:	mov    0x68(%rsp),%rdi
 1f81e99:	blsr   %rbx,%rbx
 1f81e9e:	mov    %r11b,0x600(%rsp,%r14,1)
 1f81ea6:	jne    1f81e07 <node_contexts_window_loop+0x1587>
 1f81eac:	mov    %r9,%r11
 1f81eaf:	vpxor  %xmm10,%xmm10,%xmm10
 1f81eb4:	vmovdqa64 %zmm20,%zmm11
 1f81eba:	test   %r9,%r9
 1f81ebd:	je     1f81f31 <node_contexts_window_loop+0x16b1>
 1f81ebf:	xor    %ebx,%ebx
 1f81ec1:	tzcnt  %r11,%rbx
 1f81ec6:	lea    (%rdi,%rbx,1),%r14d
 1f81eca:	movzwl 0x6b554(%r12,%r14,2),%r15d
 1f81ed3:	sub    %r15d,%r14d
 1f81ed6:	movzbl 0x2c(%r12,%r14,1),%r15d
 1f81edc:	and    $0x7f,%r15b
 1f81ee0:	blsr   %r11,%r11
 1f81ee5:	mov    %r15b,0x640(%rsp,%rbx,1)
 1f81eed:	movzbl (%rdx,%r14,1),%r15d
 1f81ef2:	mov    %r15b,0x680(%rsp,%rbx,1)
 1f81efa:	movzbl (%rsi,%r14,1),%r15d
 1f81eff:	mov    %r15b,0x6c0(%rsp,%rbx,1)
 1f81f07:	movzbl 0x0(%r13,%r14,1),%r15d
 1f81f0d:	mov    %r15b,0x700(%rsp,%rbx,1)
 1f81f15:	movzbl (%r8,%r14,1),%r15d
 1f81f1a:	mov    %r15b,0x740(%rsp,%rbx,1)
 1f81f22:	movzbl (%rcx,%r14,1),%r14d
 1f81f27:	mov    %r14b,0x780(%rsp,%rbx,1)
 1f81f2f:	jne    1f81ebf <node_contexts_window_loop+0x163f>
 1f81f31:	vmovdqa64 0x180(%rsp),%zmm20
 1f81f39:	vmovdqa64 0x1c0(%rsp),%zmm14
 1f81f41:	vmovdqu8 0x680(%rsp),%zmm29{%k2}
 1f81f49:	vmovdqu8 0x6c0(%rsp),%zmm7{%k2}
 1f81f51:	vmovdqu8 0x5c0(%rsp),%zmm5{%k1}
 1f81f59:	vmovdqu8 0x700(%rsp),%zmm8{%k2}
 1f81f61:	popcnt %r10,%rdx
 1f81f66:	mov    0x38(%rsp),%r14
 1f81f6b:	add    0x98(%rsp),%rdx
 1f81f73:	mov    0x8(%rsp),%r11d
 1f81f78:	popcnt %r9,%rsi
 1f81f7d:	mov    %rdi,%rbx
 1f81f80:	add    %rsi,%rdx
 1f81f83:	or     %r9,%r14
 1f81f86:	mov    %rdx,0x98(%rsp)
 1f81f8e:	vmovdqu8 0x640(%rsp),%zmm20{%k2}
 1f81f96:	vmovdqu8 0x740(%rsp),%zmm14{%k2}
 1f81f9e:	vmovdqa64 %zmm29,0x200(%rsp)
 1f81fa6:	vmovdqa64 %zmm7,0x4c0(%rsp)
 1f81fae:	vmovdqa64 %zmm20,0x180(%rsp)
 1f81fb6:	vmovdqa64 %zmm14,0x1c0(%rsp)
 1f81fbe:	jmp    1f80e49 <node_contexts_window_loop+0x5c9>
 1f81fc3:	vpandd -0x19d07e5(%rip){1to16},%zmm31,%zmm5        # 5b17e8 <.LCPI0_50>
 1f81fcd:	vmovdqa64 0x180(%rsp),%zmm29
 1f81fd5:	kmovq  0x60(%rsp),%k6
 1f81fdc:	vmovdqa64 %zmm26,%zmm6
 1f81fe2:	vmovdqa64 %zmm10,%zmm14
 1f81fe8:	movq   $0x0,0xd0(%rsp)
 1f81ff4:	movq   $0x0,0xb8(%rsp)
 1f82000:	vmovdqa64 %zmm12,%zmm8
 1f82006:	vmovdqa64 %zmm27,%zmm26
 1f8200c:	jmp    1f811b4 <node_contexts_window_loop+0x934>
 1f82011:	test   %rdx,%rdx
 1f82014:	je     1f82091 <node_contexts_window_loop+0x1811>
 1f82016:	mov    (%r10),%rax
 1f82019:	mov    0x8(%rax),%rax
 1f8201d:	cmpb   $0x1,0x14a(%rax)
 1f82024:	jne    1f81a0a <node_contexts_window_loop+0x118a>
 1f8202a:	mov    0x2c0(%r10),%rcx
 1f82031:	mov    %rax,0xb0(%rsp)
 1f82039:	kmovq  %k2,0xa0(%rsp)
 1f82043:	mov    %rbx,0x3c0(%rsp)
 1f8204b:	mov    %rdi,0x58(%rsp)
 1f82050:	kmovq  %k7,0x48(%rsp)
 1f82057:	vmovdqa64 %zmm5,0x280(%rsp)
 1f8205f:	vmovdqa64 %zmm21,0x2c0(%rsp)
 1f82067:	vmovdqa64 %zmm31,0x300(%rsp)
 1f8206f:	vmovdqa64 %zmm18,0x340(%rsp)
 1f82077:	mov    %r11d,0x8(%rsp)
 1f8207c:	vmovdqa64 %zmm9,0x380(%rsp)
 1f82084:	mov    %rdx,%r13
 1f82087:	xor    %r12d,%r12d
 1f8208a:	mov    %rcx,0x50(%rsp)
 1f8208f:	jmp    1f820bb <node_contexts_window_loop+0x183b>
 1f82091:	xor    %edx,%edx
 1f82093:	jmp    1f81a0a <node_contexts_window_loop+0x118a>
 1f82098:	lea    -0x1ab950a(%rip),%rdx        # 4c8b95 <check_lower_segment_override.segments>
 1f8209f:	xor    %ecx,%ecx
 1f820a1:	testb  $0x3,-0x110(%rax,%rdx,1)
 1f820a9:	setne  %cl
 1f820ac:	shlx   %rbx,%rcx,%rax
 1f820b1:	or     %rax,%r12
 1f820b4:	blsr   %r13,%r13
 1f820b9:	je     1f82118 <node_contexts_window_loop+0x1898>
 1f820bb:	mov    0x68(%rsp),%rax
 1f820c0:	xor    %ecx,%ecx
 1f820c2:	tzcnt  %r13,%rcx
 1f820c7:	mov    0x50(%rsp),%rdx
 1f820cc:	mov    0xb0(%rsp),%rdi
 1f820d4:	mov    %rcx,%rbx
 1f820d7:	add    %ecx,%eax
 1f820d9:	mov    0x20(%rsp),%rcx
 1f820de:	movzwl 0x6b554(%rcx,%rax,2),%ecx
 1f820e6:	sub    %ecx,%eax
 1f820e8:	shl    $0x6,%rax
 1f820ec:	mov    (%rdx,%rax,1),%esi
 1f820ef:	vzeroupper
 1f820f2:	call   1f2a5e0 <type_object_qualifiers_slow>
 1f820f7:	and    $0xffffff,%eax
 1f820fc:	lea    -0x110(%rax),%ecx
 1f82102:	cmp    $0x2,%ecx
 1f82105:	jbe    1f82098 <node_contexts_window_loop+0x1818>
 1f82107:	xor    %ecx,%ecx
 1f82109:	shlx   %rbx,%rcx,%rax
 1f8210e:	or     %rax,%r12
 1f82111:	blsr   %r13,%r13
 1f82116:	jne    1f820bb <node_contexts_window_loop+0x183b>
 1f82118:	mov    0x80(%rsp),%rdx
 1f82120:	vmovdqa64 0x380(%rsp),%zmm9
 1f82128:	vbroadcasti32x4 -0x19d9742(%rip),%zmm8        # 5a89f0 <.LCPI0_36>
 1f82132:	vbroadcasti32x4 -0x19d973c(%rip),%zmm11        # 5a8a00 <.LCPI0_37>
 1f8213c:	vbroadcasti32x4 -0x19d9736(%rip),%zmm13        # 5a8a10 <.LCPI0_38>
 1f82146:	vbroadcasti32x4 -0x19d9730(%rip),%zmm10        # 5a8a20 <.LCPI0_39>
 1f82150:	vbroadcasti32x4 -0x19d972a(%rip),%zmm16        # 5a8a30 <.LCPI0_40>
 1f8215a:	vbroadcasti32x4 -0x19d9724(%rip),%zmm17        # 5a8a40 <.LCPI0_41>
 1f82164:	vmovdqa64 0x340(%rsp),%zmm18
 1f8216c:	vbroadcasti32x4 -0x19d9726(%rip),%zmm19        # 5a8a50 <.LCPI0_42>
 1f82176:	vbroadcasti32x4 -0x19d9720(%rip),%zmm20        # 5a8a60 <.LCPI0_43>
 1f82180:	vbroadcasti32x4 -0x19d971a(%rip),%zmm15        # 5a8a70 <.LCPI0_44>
 1f8218a:	vbroadcasti32x4 -0x19d9714(%rip),%zmm22        # 5a8a80 <.LCPI0_45>
 1f82194:	vbroadcasti32x4 -0x19d970e(%rip),%zmm23        # 5a8a90 <.LCPI0_46>
 1f8219e:	vbroadcasti32x4 -0x19d96c8(%rip),%zmm24        # 5a8ae0 <.LCPI0_53>
 1f821a8:	vbroadcasti32x4 -0x19d9722(%rip),%zmm6        # 5a8a90 <.LCPI0_46>
 1f821b2:	vbroadcasti32x4 -0x19d971c(%rip),%zmm26        # 5a8aa0 <.LCPI0_47>
 1f821bc:	vbroadcasti32x4 -0x19d97b6(%rip),%zmm27        # 5a8a10 <.LCPI0_38>
 1f821c6:	vbroadcasti32x4 -0x19d9730(%rip),%zmm4        # 5a8aa0 <.LCPI0_47>
 1f821d0:	vbroadcasti32x4 -0x19d971a(%rip),%zmm28        # 5a8ac0 <.LCPI0_49>
 1f821da:	vbroadcasti32x4 -0x19d96f4(%rip),%zmm29        # 5a8af0 <.LCPI0_54>
 1f821e4:	vbroadcasti32x4 -0x19d979e(%rip),%zmm30        # 5a8a50 <.LCPI0_42>
 1f821ee:	vmovdqa64 0x300(%rsp),%zmm31
 1f821f6:	vmovdqa64 0x2c0(%rsp),%zmm21
 1f821fe:	vmovdqa64 0x280(%rsp),%zmm5
 1f82206:	mov    0x8(%rsp),%r11d
 1f8220b:	kmovq  0x60(%rsp),%k6
 1f82212:	mov    0x28(%rsp),%r13
 1f82217:	kmovq  0x48(%rsp),%k7
 1f8221e:	kmovq  0x90(%rsp),%k4
 1f82228:	mov    0x58(%rsp),%rdi
 1f8222d:	mov    0x3c0(%rsp),%rbx
 1f82235:	kmovq  0xa0(%rsp),%k2
 1f8223f:	andn   %rdx,%r12,%rdx
 1f82244:	mov    0x20(%rsp),%r12
 1f82249:	jmp    1f81a0a <node_contexts_window_loop+0x118a>
 1f8224e:	vmovq  0x98(%rsp),%xmm0
 1f82257:	vmovq  %rax,%xmm1
 1f8225c:	mov    0x108(%rsp),%rcx
 1f82264:	mov    0x30(%rsp),%rax
 1f82269:	mov    0xc8(%rsp),%rdx
 1f82271:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f82275:	vmovq  %rdx,%xmm1
 1f8227a:	vmovq  %rax,%xmm2
 1f8227f:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f82283:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f82289:	vinserti64x4 $0x1,%ymm9,%zmm0,%zmm0
 1f82290:	vpaddq (%rcx),%zmm0,%zmm0
 1f82296:	vmovdqu64 %zmm0,(%rcx)
 1f8229c:	lea    -0x28(%rbp),%rsp
 1f822a0:	pop    %rbx
 1f822a1:	pop    %r12
 1f822a3:	pop    %r13
 1f822a5:	pop    %r14
 1f822a7:	pop    %r15
 1f822a9:	pop    %rbp
 1f822aa:	vzeroupper
 1f822ad:	ret

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .iplt:
