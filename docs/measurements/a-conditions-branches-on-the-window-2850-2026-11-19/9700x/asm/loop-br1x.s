
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
 1f8089b:	mov    0xb38(%rdi),%r10
 1f808a2:	mov    0x4fb8157(%rip),%r8d        # 6f38a00 <node_branches_x_level>
 1f808a9:	add    $0x3f,%edx
 1f808ac:	vpxor  %xmm0,%xmm0,%xmm0
 1f808b0:	mov    0x8(%rax),%rax
 1f808b4:	movzbl 0x14a(%rax),%eax
 1f808bb:	vmovdqa64 %zmm0,0x740(%rsp)
 1f808c3:	vmovdqa64 %zmm0,0x700(%rsp)
 1f808cb:	vmovdqa64 %zmm0,0x6c0(%rsp)
 1f808d3:	vmovdqa64 %zmm0,0x680(%rsp)
 1f808db:	vmovdqa64 %zmm0,0x640(%rsp)
 1f808e3:	vmovdqa64 %zmm0,0x600(%rsp)
 1f808eb:	vmovdqa64 %zmm0,0x5c0(%rsp)
 1f808f3:	vmovdqa64 %zmm0,0x580(%rsp)
 1f808fb:	mov    %al,0x3f(%rsp)
 1f808ff:	cmp    $0x40,%edx
 1f80902:	jae    1f80912 <node_contexts_window_loop+0x92>
 1f80904:	xor    %edx,%edx
 1f80906:	xor    %eax,%eax
 1f80908:	vpxor  %xmm10,%xmm10,%xmm10
 1f8090d:	jmp    1f822b6 <node_contexts_window_loop+0x1a36>
 1f80912:	vbroadcasti32x4 -0x19d7f6c(%rip),%zmm8        # 5a89b0 <.LCPI0_36>
 1f8091c:	vbroadcasti32x4 -0x19d7f66(%rip),%zmm12        # 5a89c0 <.LCPI0_37>
 1f80926:	vbroadcasti32x4 -0x19d7f60(%rip),%zmm14        # 5a89d0 <.LCPI0_38>
 1f80930:	vbroadcasti32x4 -0x19d7f5a(%rip),%zmm15        # 5a89e0 <.LCPI0_39>
 1f8093a:	vbroadcasti32x4 -0x19d7f54(%rip),%zmm17        # 5a89f0 <.LCPI0_40>
 1f80944:	vbroadcasti32x4 -0x19d7f4e(%rip),%zmm18        # 5a8a00 <.LCPI0_41>
 1f8094e:	vbroadcasti32x4 -0x19d7f48(%rip),%zmm20        # 5a8a10 <.LCPI0_42>
 1f80958:	vbroadcasti32x4 -0x19d7f42(%rip),%zmm21        # 5a8a20 <.LCPI0_43>
 1f80962:	vbroadcasti32x4 -0x19d7f3c(%rip),%zmm16        # 5a8a30 <.LCPI0_44>
 1f8096c:	vbroadcasti32x4 -0x19d7f36(%rip),%zmm23        # 5a8a40 <.LCPI0_45>
 1f80976:	vbroadcasti32x4 -0x19d7f30(%rip),%zmm24        # 5a8a50 <.LCPI0_46>
 1f80980:	vbroadcasti32x4 -0x19d7f3a(%rip),%zmm27        # 5a8a50 <.LCPI0_46>
 1f8098a:	vbroadcasti32x4 -0x19d7f34(%rip),%zmm28        # 5a8a60 <.LCPI0_47>
 1f80994:	vbroadcasti32x4 -0x19d7fce(%rip),%zmm29        # 5a89d0 <.LCPI0_38>
 1f8099e:	shr    $0x6,%edx
 1f809a1:	mov    $0xffffffff,%r13d
 1f809a7:	mov    %rcx,0x158(%rsp)
 1f809af:	vpxor  %xmm10,%xmm10,%xmm10
 1f809b4:	vpxor  %xmm11,%xmm11,%xmm11
 1f809b9:	vpxord %xmm19,%xmm19,%xmm19
 1f809bf:	movq   $0x0,0x78(%rsp)
 1f809c8:	xor    %eax,%eax
 1f809ca:	movq   $0x0,0xc8(%rsp)
 1f809d6:	movq   $0x0,0x108(%rsp)
 1f809e2:	vpxor  %xmm5,%xmm5,%xmm5
 1f809e6:	vpxor  %xmm1,%xmm1,%xmm1
 1f809ea:	mov    %rsi,0x50(%rsp)
 1f809ef:	mov    %rdi,0x80(%rsp)
 1f809f7:	mov    %r10,0xf0(%rsp)
 1f809ff:	mov    %r8d,0xa4(%rsp)
 1f80a07:	jmp    1f80b90 <node_contexts_window_loop+0x310>
 1f80a0c:	nopl   0x0(%rax)
 1f80a10:	kmovq  0x178(%rsp),%k1
 1f80a1a:	vpcmpeqb %zmm23,%zmm22,%k0
 1f80a20:	vpandq 0x480(%rsp),%zmm30,%zmm3
 1f80a28:	vpaddb -0x1ace3b2(%rip),%zmm22,%zmm2        # 4b2680 <abi_test_hex.digits+0xb980>
 1f80a32:	vpcmpeqb %zmm28,%zmm22,%k2
 1f80a38:	vpcmpeqb %zmm24,%zmm22,%k3
 1f80a3e:	vpcmpeqb 0x540(%rsp),%zmm8,%k3{%k3}
 1f80a46:	mov    0x138(%rsp),%rax
 1f80a4e:	mov    0x68(%rsp),%r14
 1f80a53:	mov    0x40(%rsp),%r15
 1f80a58:	mov    0x1b0(%rsp),%r11
 1f80a60:	korq   %k1,%k0,%k0
 1f80a65:	kmovq  0x180(%rsp),%k1
 1f80a6f:	andn   %rbx,%rax,%rdi
 1f80a74:	mov    0x188(%rsp),%rbx
 1f80a7c:	mov    0x118(%rsp),%rax
 1f80a84:	andn   %r14,%rcx,%rcx
 1f80a89:	mov    %r11d,%r10d
 1f80a8c:	shl    $0x6,%r10
 1f80a90:	and    %rdx,%rcx
 1f80a93:	vptestnmb %zmm3,%zmm3,%k2{%k2}
 1f80a99:	vmovq  %r15,%xmm3
 1f80a9e:	kandq  %k1,%k0,%k0
 1f80aa3:	vpcmpltub -0x1ace2ae(%rip),%zmm2,%k1        # 4b2800 <abi_test_hex.digits+0xbb00>
 1f80aae:	vmovdqa64 0x400(%rsp),%zmm2
 1f80ab6:	andn   %rbx,%r15,%r8
 1f80abb:	vmovq  %rbx,%xmm4
 1f80ac0:	or     %r8,%rax
 1f80ac3:	vpmovb2m %zmm2,%k4
 1f80ac9:	korq   %k2,%k1,%k1
 1f80ace:	korq   %k4,%k1,%k1
 1f80ad3:	korq   %k0,%k1,%k1
 1f80ad8:	kandq  %k6,%k0,%k0
 1f80add:	korq   %k3,%k1,%k1
 1f80ae2:	kmovq  %k1,%r9
 1f80ae7:	vptestnmb %zmm0,%zmm0,%k1
 1f80aed:	or     %rdi,%r9
 1f80af0:	mov    0x80(%rsp),%rdi
 1f80af8:	or     0x48(%rsp),%r9
 1f80afd:	kmovq  %k1,%r8
 1f80b02:	and    %rcx,%r8
 1f80b05:	mov    0xbd0(%rdi),%rdx
 1f80b0c:	or     %rax,%r9
 1f80b0f:	mov    0x110(%rsp),%rax
 1f80b17:	and    %r14,%r9
 1f80b1a:	mov    %rcx,(%rdx,%r10,1)
 1f80b1e:	mov    %r8,0x8(%rdx,%r10,1)
 1f80b23:	mov    %r9,0x10(%rdx,%r10,1)
 1f80b28:	kmovq  %k0,0x18(%rdx,%r10,1)
 1f80b2f:	vpcmpgtb %zmm2,%zmm11,%k0{%k6}
 1f80b35:	kmovq  %k0,0x20(%rdx,%r10,1)
 1f80b3c:	mov    0xf8(%rsp),%rdx
 1f80b44:	mov    0xf0(%rsp),%r10
 1f80b4c:	and    %r14,%rdx
 1f80b4f:	and    %rdx,%rax
 1f80b52:	vmovq  %rdx,%xmm0
 1f80b57:	mov    0x1b8(%rsp),%rdx
 1f80b5f:	vmovq  %rax,%xmm2
 1f80b64:	mov    0x100(%rsp),%rax
 1f80b6c:	vpunpcklqdq %xmm2,%xmm0,%xmm0
 1f80b70:	vpunpcklqdq %xmm3,%xmm4,%xmm2
 1f80b74:	vinserti128 $0x1,%xmm0,%ymm2,%ymm0
 1f80b7a:	vpopcntq %ymm0,%ymm0
 1f80b80:	vpaddq %ymm0,%ymm10,%ymm10
 1f80b84:	dec    %rdx
 1f80b87:	test   %r11d,%r11d
 1f80b8a:	je     1f8228f <node_contexts_window_loop+0x1a0f>
 1f80b90:	lea    -0x1(%rdx),%r9d
 1f80b94:	mov    %rax,0x100(%rsp)
 1f80b9c:	vpbroadcastq -0x19d1e5e(%rip),%zmm2        # 5aed48 <.LCPI0_0>
 1f80ba6:	vmovdqa64 %zmm1,0x880(%rsp)
 1f80bae:	vmovdqa64 %zmm19,%zmm1
 1f80bb4:	vmovdqa64 %zmm5,%zmm0
 1f80bba:	vmovdqu64 (%r10),%zmm6
 1f80bc0:	mov    0xba0(%rdi),%r8
 1f80bc7:	vmovdqa64 %zmm29,%zmm30
 1f80bcd:	vmovdqa64 %zmm28,%zmm29
 1f80bd3:	vmovdqa64 %zmm27,%zmm28
 1f80bd9:	mov    %rdx,0x1b8(%rsp)
 1f80be1:	mov    0xb80(%rdi),%rdx
 1f80be8:	mov    %r13d,0xa0(%rsp)
 1f80bf0:	mov    0xb88(%rdi),%r13
 1f80bf7:	mov    0xb90(%rdi),%rbx
 1f80bfe:	mov    0xb98(%rdi),%rcx
 1f80c05:	vmovdqa64 %zmm23,%zmm25
 1f80c0b:	vmovdqa64 %zmm21,%zmm23
 1f80c11:	vmovdqa64 %zmm12,%zmm21
 1f80c17:	mov    %r9,%r15
 1f80c1a:	shl    $0x6,%r15
 1f80c1e:	test   %r9d,%r9d
 1f80c21:	mov    %r9,0x1b0(%rsp)
 1f80c29:	lea    -0x40(%r15),%eax
 1f80c2d:	vpandq 0x2c(%rsi,%r15,1),%zmm2,%zmm19
 1f80c38:	vmovdqu64 0x196ac(%rsi,%r15,1),%zmm4
 1f80c43:	mov    %r15,0x60(%rsp)
 1f80c48:	cmove  %r9d,%eax
 1f80c4c:	shl    $0x7,%r9
 1f80c50:	vmovdqu64 0x6f654(%rsi,%r9,1),%zmm2
 1f80c5b:	vmovdqu64 0x6f694(%rsi,%r9,1),%zmm3
 1f80c66:	vmovdqu64 (%r8,%r15,1),%zmm27
 1f80c6d:	vmovdqu64 (%rdx,%r15,1),%zmm9
 1f80c74:	vmovdqu64 0x0(%r13,%r15,1),%zmm22
 1f80c7c:	vmovdqu64 (%rbx,%r15,1),%zmm12
 1f80c83:	vmovdqu64 (%r8,%rax,1),%zmm13
 1f80c8a:	vptestmb %zmm4,%zmm4,%k2
 1f80c90:	vmovdqa64 -0x1acec1a(%rip),%zmm4        # 4b2080 <abi_test_hex.digits+0xb380>
 1f80c9a:	vpermt2b 0x40(%r10),%zmm19,%zmm6
 1f80ca1:	vmovdqa64 %zmm19,%zmm7
 1f80ca7:	vpmovuswb %zmm2,%ymm2
 1f80cad:	vpmovuswb %zmm3,%ymm3
 1f80cb3:	vmovdqa64 %zmm9,0x440(%rsp)
 1f80cbb:	vmovdqa64 %zmm22,0x500(%rsp)
 1f80cc3:	vmovdqa64 %zmm12,0x540(%rsp)
 1f80ccb:	vmovdqa64 %zmm27,0x480(%rsp)
 1f80cd3:	vinserti64x4 $0x1,%ymm3,%zmm2,%zmm2
 1f80cda:	vpaddb -0x1acec24(%rip),%zmm2,%zmm5        # 4b20c0 <abi_test_hex.digits+0xb3c0>
 1f80ce4:	vmovdqu64 0x6b554(%rsi,%r9,1),%zmm3
 1f80cef:	vpcmpleub %zmm4,%zmm2,%k1{%k2}
 1f80cf6:	vmovdqa64 %zmm6,0x3c0(%rsp)
 1f80cfe:	kmovq  %k1,0x140(%rsp)
 1f80d08:	vpermt2b %zmm1,%zmm5,%zmm7
 1f80d0e:	vmovdqu64 0x6b594(%rsi,%r9,1),%zmm1
 1f80d19:	vpermt2b %zmm0,%zmm5,%zmm6{%k1}{z}
 1f80d1f:	vpmovuswb %zmm3,%ymm0
 1f80d25:	vmovdqu64 0x6d5d4(%rsi,%r9,1),%zmm3
 1f80d30:	vmovdqa64 %zmm5,0x840(%rsp)
 1f80d38:	vpandq %zmm8,%zmm27,%zmm5
 1f80d3e:	vmovdqa64 -0x1acec48(%rip),%zmm8        # 4b2100 <abi_test_hex.digits+0xb400>
 1f80d48:	vptestmb %zmm5,%zmm5,%k5
 1f80d4e:	kandq  %k5,%k2,%k2
 1f80d53:	kmovq  %k5,0xb0(%rsp)
 1f80d5d:	vpcmpnleub %zmm4,%zmm2,%k4{%k2}
 1f80d64:	vbroadcasti32x4 -0x19d82fe(%rip),%zmm2        # 5a8a70 <.LCPI0_48>
 1f80d6e:	vmovdqu64 (%rbx,%rax,1),%zmm4
 1f80d75:	vpandq 0x2c(%rsi,%rax,1),%zmm2,%zmm2
 1f80d80:	kmovq  %k4,0x120(%rsp)
 1f80d8a:	vpmovuswb %zmm1,%ymm1
 1f80d90:	vinserti64x4 $0x1,%ymm1,%zmm0,%zmm1
 1f80d97:	vpmovuswb %zmm3,%ymm0
 1f80d9d:	vmovdqu64 0x6d614(%rsi,%r9,1),%zmm3
 1f80da8:	vptestmb %zmm1,%zmm1,%k0
 1f80dae:	vpsubb %zmm1,%zmm8,%zmm5
 1f80db4:	kandq  %k0,%k5,%k3
 1f80db9:	kmovq  %k0,%r10
 1f80dbe:	vpcmpnltub %zmm1,%zmm8,%k0
 1f80dc5:	kmovq  %k0,%rdi
 1f80dca:	vpcmpltub %zmm1,%zmm8,%k2{%k3}
 1f80dd1:	vmovdqu64 (%rdx,%rax,1),%zmm1
 1f80dd8:	and    %r10,%rdi
 1f80ddb:	kortestq %k4,%k2
 1f80de0:	kmovq  %k2,0x400(%rsp)
 1f80dea:	kmovq  %rdi,%k3
 1f80def:	vpermt2b %zmm19,%zmm5,%zmm2{%k3}{z}
 1f80df5:	vpermt2b %zmm27,%zmm5,%zmm13{%k3}{z}
 1f80dfb:	vpmovuswb %zmm3,%ymm3
 1f80e01:	vmovdqa64 %zmm2,0x1c0(%rsp)
 1f80e09:	vmovdqa64 %zmm1,%zmm2
 1f80e0f:	vpermt2b %zmm9,%zmm5,%zmm2{%k3}{z}
 1f80e15:	vmovdqa64 %zmm4,%zmm9
 1f80e1b:	vpermt2b %zmm12,%zmm5,%zmm9{%k3}{z}
 1f80e21:	vmovdqa64 %zmm13,0x200(%rsp)
 1f80e29:	vinserti64x4 $0x1,%ymm3,%zmm0,%zmm0
 1f80e30:	vpcmpltub -0x1acecfb(%rip),%zmm0,%k1        # 4b2140 <abi_test_hex.digits+0xb440>
 1f80e3b:	vmovdqu64 0x0(%r13,%rax,1),%zmm3
 1f80e43:	vmovdqa64 %zmm2,0x240(%rsp)
 1f80e4b:	vmovdqa64 %zmm3,%zmm2
 1f80e51:	vptestmb %zmm0,%zmm0,%k1{%k1}
 1f80e57:	vpermt2b %zmm22,%zmm5,%zmm2{%k3}{z}
 1f80e5d:	vpsubb %zmm0,%zmm8,%zmm0
 1f80e63:	jne    1f81e10 <node_contexts_window_loop+0x1590>
 1f80e69:	vmovdqa64 %zmm21,%zmm12
 1f80e6f:	vmovdqa64 %zmm23,%zmm21
 1f80e75:	vmovdqa64 %zmm28,%zmm27
 1f80e7b:	vmovdqu64 0x1a72c(%rsi,%r15,1),%zmm23
 1f80e86:	vpandq %zmm12,%zmm9,%zmm9
 1f80e8c:	vmovdqa64 %zmm29,%zmm28
 1f80e92:	vmovdqu64 (%rcx,%r15,1),%zmm29
 1f80e99:	vmovdqa64 0x500(%rsp),%zmm22
 1f80ea1:	vmovdqu64 (%rcx,%rax,1),%zmm8
 1f80ea8:	vpbroadcastq -0x19d2162(%rip),%zmm26        # 5aed50 <.LCPI0_18>
 1f80eb2:	kmovq  %k1,0x68(%rsp)
 1f80eb9:	vpandq 0x200(%rsp),%zmm20,%zmm13
 1f80ec1:	vpcmpeqb %zmm14,%zmm9,%k0
 1f80ec7:	vpternlogd $0xff,%zmm9,%zmm9,%zmm9
 1f80ece:	vpaddb 0x440(%rsp),%zmm9,%zmm9
 1f80ed6:	kmovq  %k0,%rax
 1f80edb:	vptestmb %zmm14,%zmm2,%k0
 1f80ee1:	kmovq  %k0,%rcx
 1f80ee6:	vptestmb -0x1aceb30(%rip),%zmm22,%k0        # 4b23c0 <abi_test_hex.digits+0xb6c0>
 1f80ef0:	and    %rdi,%rax
 1f80ef3:	or     %rax,%rcx
 1f80ef6:	mov    %rcx,0x98(%rsp)
 1f80efe:	vptestnmb %zmm23,%zmm23,%k4
 1f80f04:	vpermt2b %zmm22,%zmm0,%zmm3{%k1}{z}
 1f80f0a:	vmovdqa64 %zmm23,0x800(%rsp)
 1f80f12:	vmovdqa64 %zmm25,%zmm23
 1f80f18:	kmovq  %k4,0x1a8(%rsp)
 1f80f22:	vpcmpgtb %zmm6,%zmm11,%k4{%k4}
 1f80f28:	vpandq %zmm16,%zmm29,%zmm11
 1f80f2e:	vpcmpltub %zmm17,%zmm9,%k2
 1f80f35:	vmovdqa64 %zmm9,0x280(%rsp)
 1f80f3d:	vpandq %zmm21,%zmm29,%zmm9
 1f80f43:	vptestnmb %zmm11,%zmm11,%k5
 1f80f49:	vpcmpeqb %zmm18,%zmm11,%k7
 1f80f4f:	vmovdqa64 0x3c0(%rsp),%zmm11
 1f80f57:	vpcmpeqb %zmm25,%zmm9,%k6
 1f80f5d:	kmovq  %k4,%r12
 1f80f62:	kmovq  %k2,0xa8(%rsp)
 1f80f6c:	vmovdqa64 %zmm9,0x380(%rsp)
 1f80f74:	kmovq  %k0,%rcx
 1f80f79:	vptestmb %zmm20,%zmm22,%k0
 1f80f7f:	kmovq  %k5,%rax
 1f80f84:	vptestmb %zmm9,%zmm9,%k5
 1f80f8a:	kmovq  %k7,0x1a0(%rsp)
 1f80f94:	kmovq  %k6,0x130(%rsp)
 1f80f9e:	mov    %r12,0xe0(%rsp)
 1f80fa6:	korq   %k4,%k0,%k1
 1f80fab:	kmovq  %k5,%rdx
 1f80fb0:	andn   %rax,%r12,%rax
 1f80fb5:	kandq  %k6,%k1,%k0
 1f80fba:	kmovq  %k1,0x128(%rsp)
 1f80fc4:	kmovq  %k0,%rsi
 1f80fc9:	vptestmb %zmm15,%zmm22,%k0{%k7}
 1f80fcf:	or     %rax,%rsi
 1f80fd2:	kmovq  %k1,%rax
 1f80fd7:	and    %rdx,%rsi
 1f80fda:	mov    %rax,0x48(%rsp)
 1f80fdf:	vpandq %zmm26,%zmm11,%zmm25
 1f80fe5:	vpcmpeqb %zmm18,%zmm25,%k5
 1f80feb:	kmovq  %k0,%r9
 1f80ff0:	kandq  %k7,%k2,%k0
 1f80ff5:	vptestnmb %zmm18,%zmm2,%k2
 1f80ffb:	vmovdqa64 %zmm25,%zmm22
 1f81001:	kmovq  %k5,%r10
 1f81006:	kmovq  %k0,%r8
 1f8100b:	kmovq  0x140(%rsp),%k5
 1f81015:	vpcmpeqb -0x1aceb5f(%rip),%zmm7,%k0{%k5}        # 4b24c0 <abi_test_hex.digits+0xb7c0>
 1f8101f:	vpsllw $0x7,0x480(%rsp),%zmm7
 1f81028:	kmovq  %k2,%r11
 1f8102d:	vpcmpeqb -0x1aceab7(%rip),%zmm25,%k5        # 4b2580 <abi_test_hex.digits+0xb880>
 1f81037:	vpcmpeqb -0x1acea01(%rip),%zmm25,%k2        # 4b2640 <abi_test_hex.digits+0xb940>
 1f81041:	vpandq %zmm26,%zmm6,%zmm25
 1f81047:	mov    %r11,0xb8(%rsp)
 1f8104f:	mov    %r10,0x138(%rsp)
 1f81057:	vmovdqa64 %zmm25,0x7c0(%rsp)
 1f8105f:	vpmovb2m %zmm7,%k7
 1f81065:	kmovq  %k5,%rbx
 1f8106a:	kmovq  %k0,%r13
 1f8106f:	kmovq  %k2,%r14
 1f81074:	kmovq  %k7,%r11
 1f81079:	mov    %rbx,0xe8(%rsp)
 1f81081:	andn   %rsi,%r11,%rdx
 1f81086:	andn   %r9,%r12,%rsi
 1f8108b:	mov    %r11,0x198(%rsp)
 1f81093:	or     %rcx,%rsi
 1f81096:	mov    %rdx,0xd8(%rsp)
 1f8109e:	mov    %rsi,%rcx
 1f810a1:	not    %rcx
 1f810a4:	mov    %rsi,0x90(%rsp)
 1f810ac:	andn   %rcx,%rdx,%r11
 1f810b1:	andn   %r8,%rax,%rcx
 1f810b6:	and    %r10,%rcx
 1f810b9:	cmpl   $0x0,0xa4(%rsp)
 1f810c1:	mov    %rcx,0x40(%rsp)
 1f810c6:	jne    1f82004 <node_contexts_window_loop+0x1784>
 1f810cc:	vbroadcasti32x4 -0x19d8656(%rip),%zmm7        # 5a8a80 <.LCPI0_49>
 1f810d6:	vbroadcasti32x4 -0x19d8650(%rip),%zmm9        # 5a8a90 <.LCPI0_50>
 1f810e0:	vpandd -0x19cf942(%rip){1to16},%zmm11,%zmm6        # 5b17a8 <.LCPI0_51>
 1f810ea:	vmovdqa64 0x1c0(%rsp),%zmm31
 1f810f2:	vpermi2b %zmm29,%zmm8,%zmm5{%k3}{z}
 1f810f8:	kmovq  0x400(%rsp),%k1
 1f81102:	vptestmb -0x1acee0c(%rip),%zmm3,%k0        # 4b2300 <abi_test_hex.digits+0xb600>
 1f8110c:	mov    0xb8(%rsp),%rax
 1f81114:	vmovdqa64 %zmm13,%zmm26
 1f8111a:	vmovdqu8 0x740(%rsp),%zmm5{%k1}
 1f81122:	vpcmpeqb %zmm9,%zmm25,%k3
 1f81128:	vpcmpeqb %zmm7,%zmm25,%k2
 1f8112e:	vpaddb -0x1ace9f8(%rip),%zmm31,%zmm25        # 4b2740 <abi_test_hex.digits+0xba40>
 1f81138:	vpcmpeqb %zmm7,%zmm22,%k5
 1f8113e:	kmovq  %k0,%r10
 1f81143:	vptestmb %zmm6,%zmm6,%k5{%k5}
 1f81149:	korq   %k2,%k3,%k2
 1f8114e:	kmovq  %k3,%r8
 1f81153:	and    %r14,%r10
 1f81156:	andn   %rax,%r10,%r10
 1f8115b:	kmovq  %k5,%rcx
 1f81160:	mov    %rcx,0x110(%rsp)
 1f81168:	xor    %rbx,%rcx
 1f8116b:	mov    %r11,%rbx
 1f8116e:	vpcmpltub %zmm27,%zmm25,%k6
 1f81175:	mov    %rcx,%rdx
 1f81178:	and    %r8,%rdx
 1f8117b:	kandq  %k5,%k6,%k3
 1f81180:	vpcmpeqb -0x1aced8a(%rip),%zmm31,%k5        # 4b2400 <abi_test_hex.digits+0xb700>
 1f8118a:	kmovq  %k6,%rsi
 1f8118f:	and    %rbx,%rdx
 1f81192:	kmovq  %k3,%r9
 1f81197:	xor    %rdx,%rcx
 1f8119a:	or     %rdx,%r9
 1f8119d:	and    %rsi,%rcx
 1f811a0:	kmovq  %k5,%r11
 1f811a5:	vptestnmb -0x1acee2f(%rip),%zmm5,%k5        # 4b2380 <abi_test_hex.digits+0xb680>
 1f811af:	vpandd -0x19cfa0d(%rip){1to16},%zmm5,%zmm5        # 5b17ac <.LCPI0_52>
 1f811b9:	and    %r11,%rdx
 1f811bc:	mov    %rbx,%r11
 1f811bf:	or     %rcx,%rdx
 1f811c2:	vpcmpeqb %zmm28,%zmm5,%k6
 1f811c8:	vmovdqa64 %zmm11,%zmm5
 1f811ce:	vptestmb %zmm13,%zmm13,%k6{%k6}
 1f811d4:	korq   %k6,%k5,%k5
 1f811d9:	kandq  %k5,%k2,%k2
 1f811de:	vpcmpeqb %zmm9,%zmm22,%k2{%k2}
 1f811e4:	kmovq  %k2,%r8
 1f811e9:	and    %rbx,%r8
 1f811ec:	or     %r8,%r9
 1f811ef:	xor    %r14,%r8
 1f811f2:	and    %r9,%r10
 1f811f5:	or     %r8,%rdx
 1f811f8:	or     %r9,%r13
 1f811fb:	mov    %r10,0xf8(%rsp)
 1f81203:	mov    %rdx,0x118(%rsp)
 1f8120b:	vmovdqa64 0x480(%rsp),%zmm7
 1f81213:	vpermt2b 0x540(%rsp),%zmm0,%zmm4
 1f8121b:	kmovq  0x68(%rsp),%k5
 1f81222:	vpermt2b %zmm29,%zmm0,%zmm8
 1f81228:	vptestmb %zmm14,%zmm3,%k2
 1f8122e:	mov    %r13,0x190(%rsp)
 1f81236:	vbroadcasti32x4 -0x19d87a0(%rip),%zmm25        # 5a8aa0 <.LCPI0_53>
 1f81240:	mov    %rdi,0x58(%rsp)
 1f81245:	mov    0x80(%rsp),%rdi
 1f8124d:	vpermt2b 0x440(%rsp),%zmm0,%zmm1
 1f81255:	mov    0x98(%rsp),%r10
 1f8125d:	kmovq  0xb0(%rsp),%k6
 1f81267:	vmovdqa64 %zmm29,0x400(%rsp)
 1f8126f:	vmovdqa64 %zmm30,%zmm29
 1f81275:	vpxor  %xmm11,%xmm11,%xmm11
 1f8127a:	vpandq %zmm21,%zmm8,%zmm3
 1f81280:	mov    0xbb0(%rdi),%rsi
 1f81287:	vpcmpeqb %zmm20,%zmm3,%k1{%k5}
 1f8128d:	vmovdqa64 0x200(%rsp),%zmm3
 1f81295:	kmovq  %k1,0x180(%rsp)
 1f8129f:	vptestmb %zmm24,%zmm7,%k0
 1f812a5:	vpandq %zmm12,%zmm4,%zmm4
 1f812ab:	kmovq  %k0,%r12
 1f812b0:	vptestmb %zmm20,%zmm7,%k0
 1f812b6:	vpandq %zmm15,%zmm2,%zmm7
 1f812bc:	vmovdqu8 %zmm18,%zmm2{%k4}{z}
 1f812c2:	kmovq  0xa8(%rsp),%k4
 1f812cc:	kmovq  %k0,%r9
 1f812d1:	vpcmpeqb %zmm14,%zmm4,%k0{%k5}
 1f812d7:	vmovdqa64 0x280(%rsp),%zmm4
 1f812df:	vmovdqu64 %zmm2,(%rsi,%r15,1)
 1f812e6:	mov    %r12,0xd0(%rsp)
 1f812ee:	korq   %k0,%k2,%k0
 1f812f3:	vpcmpltub -0x1acf03e(%rip),%zmm4,%k3        # 4b22c0 <abi_test_hex.digits+0xb5c0>
 1f812fe:	mov    0xbc0(%rdi),%rsi
 1f81305:	mov    %r9,0x170(%rsp)
 1f8130d:	kmovq  %k0,%r13
 1f81312:	vpcmpeqb %zmm20,%zmm22,%k0
 1f81318:	kmovq  %k0,%rax
 1f8131d:	vpcmpeqb -0x1acede7(%rip),%zmm22,%k0        # 4b2540 <abi_test_hex.digits+0xb840>
 1f81327:	mov    %r13,0x168(%rsp)
 1f8132f:	mov    %rax,0x160(%rsp)
 1f81337:	vmovdqu64 %zmm22,(%rsi,%r15,1)
 1f8133e:	kmovq  %k4,%rsi
 1f81343:	mov    %rsi,0xc0(%rsp)
 1f8134b:	vpcmpltub %zmm30,%zmm4,%k2
 1f81352:	kmovq  %k0,%r14
 1f81357:	vptestmb %zmm15,%zmm5,%k0{%k2}
 1f8135d:	vpcmpeqb %zmm25,%zmm22,%k2{%k3}
 1f81363:	kmovq  %k2,%r8
 1f81368:	vpmovb2m %zmm3,%k2
 1f8136e:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f81375:	vptestnmb %zmm31,%zmm31,%k2{%k2}
 1f8137b:	vpaddb %zmm3,%zmm1,%zmm0
 1f81381:	vpcmpltub %zmm17,%zmm0,%k5{%k5}
 1f81388:	vmovdqa64 %zmm31,%zmm0
 1f8138e:	kmovq  %k0,0x178(%rsp)
 1f81398:	kandq  %k1,%k0,%k0
 1f8139d:	knotq  %k0,%k0
 1f813a2:	kmovq  %k0,%rcx
 1f813a7:	vptestmb %zmm7,%zmm7,%k0
 1f813ad:	korq   %k2,%k0,%k0
 1f813b2:	and    %rcx,%r8
 1f813b5:	kmovq  %k6,%rcx
 1f813ba:	knotq  %k0,%k0
 1f813bf:	mov    %rcx,0x68(%rsp)
 1f813c4:	and    %r11,%r8
 1f813c7:	kmovq  %k0,%rdx
 1f813cc:	vptestmb %zmm6,%zmm6,%k0
 1f813d2:	mov    %r8,0x188(%rsp)
 1f813da:	korq   %k5,%k0,%k0
 1f813df:	kmovq  %k0,%rbx
 1f813e4:	or     %r10,%rbx
 1f813e7:	and    %rdx,%rbx
 1f813ea:	mov    %rax,%rdx
 1f813ed:	or     %r14,%rdx
 1f813f0:	not    %r14
 1f813f3:	mov    %r13,%rax
 1f813f6:	or     %r12,%rax
 1f813f9:	or     %rsi,%r14
 1f813fc:	or     0x48(%rsp),%r14
 1f81401:	andn   %rdx,%rax,%rax
 1f81406:	and    %r8,%rbx
 1f81409:	mov    %rbx,0x70(%rsp)
 1f8140e:	and    %rcx,%r14
 1f81411:	mov    0x40(%rsp),%rcx
 1f81416:	and    %r11,%r14
 1f81419:	and    %rax,%r14
 1f8141c:	or     %rbx,%r14
 1f8141f:	and    %r9,%rcx
 1f81422:	and    %r10,%r14
 1f81425:	mov    %rcx,%r9
 1f81428:	je     1f81670 <node_contexts_window_loop+0xdf0>
 1f8142e:	vbroadcasti32x4 -0x19d8a88(%rip),%zmm8        # 5a89b0 <.LCPI0_36>
 1f81438:	vbroadcasti32x4 -0x19d8992(%rip),%zmm30        # 5a8ab0 <.LCPI0_54>
 1f81442:	vbroadcasti32x4 -0x19d8a3c(%rip),%zmm31        # 5a8a10 <.LCPI0_42>
 1f8144c:	mov    %r15,%r8
 1f8144f:	shl    $0x6,%r8
 1f81453:	add    0x2c0(%rdi),%r8
 1f8145a:	mov    0x20(%rdi),%r15
 1f8145e:	mov    0x60(%rdi),%r12d
 1f81462:	mov    0x78(%rsp),%rdx
 1f81467:	mov    %r14,%r13
 1f8146a:	nopw   0x0(%rax,%rax,1)
 1f81470:	xor    %ebx,%ebx
 1f81472:	tzcnt  %r13,%rbx
 1f81477:	mov    %ebx,%eax
 1f81479:	shl    $0x6,%eax
 1f8147c:	mov    0x20(%r8,%rax,1),%esi
 1f81481:	mov    %esi,%ecx
 1f81483:	shr    $0x3,%ecx
 1f81486:	cmp    %r12d,%ecx
 1f81489:	cmovae %r12d,%ecx
 1f8148d:	shl    $0x6,%rcx
 1f81491:	cmpl   $0x0,0x38(%r15,%rcx,1)
 1f81497:	setne  %al
 1f8149a:	testb  $0x4,0x34(%r15,%rcx,1)
 1f814a0:	je     1f814c0 <node_contexts_window_loop+0xc40>
 1f814a2:	xor    $0x1,%al
 1f814a4:	inc    %rdx
 1f814a7:	movzbl %al,%eax
 1f814aa:	shlx   %rbx,%rax,%rax
 1f814af:	andn   %r14,%rax,%r14
 1f814b4:	blsr   %r13,%r13
 1f814b9:	jne    1f81470 <node_contexts_window_loop+0xbf0>
 1f814bb:	jmp    1f81696 <node_contexts_window_loop+0xe16>
 1f814c0:	vmovdqa64 %zmm10,0x340(%rsp)
 1f814c8:	vmovdqa64 %zmm19,0x300(%rsp)
 1f814d0:	mov    %rdx,0x78(%rsp)
 1f814d5:	vmovdqa64 %zmm22,0x2c0(%rsp)
 1f814dd:	mov    %r11,0x48(%rsp)
 1f814e2:	kmovq  %k7,0x88(%rsp)
 1f814ec:	mov    %r9,0x40(%rsp)
 1f814f1:	vmovdqa64 %zmm26,0x4c0(%rsp)
 1f814f9:	vmovdqa64 %zmm7,0x780(%rsp)
 1f81501:	kmovq  %k5,0x150(%rsp)
 1f8150b:	mov    %r8,0x148(%rsp)
 1f81513:	vzeroupper
 1f81516:	call   1f828fa <node_contexts_stride_asked>
 1f8151b:	vmovdqa64 0x780(%rsp),%zmm7
 1f81523:	vmovdqa64 0x4c0(%rsp),%zmm26
 1f8152b:	vmovdqa64 0x280(%rsp),%zmm4
 1f81533:	vmovdqa64 0x1c0(%rsp),%zmm0
 1f8153b:	vmovdqa64 0x3c0(%rsp),%zmm5
 1f81543:	vbroadcasti32x4 -0x19d8b3d(%rip),%zmm31        # 5a8a10 <.LCPI0_42>
 1f8154d:	vbroadcasti32x4 -0x19d8aa7(%rip),%zmm30        # 5a8ab0 <.LCPI0_54>
 1f81557:	vbroadcasti32x4 -0x19d8b91(%rip),%zmm29        # 5a89d0 <.LCPI0_38>
 1f81561:	vbroadcasti32x4 -0x19d8b0b(%rip),%zmm28        # 5a8a60 <.LCPI0_47>
 1f8156b:	vbroadcasti32x4 -0x19d8b25(%rip),%zmm27        # 5a8a50 <.LCPI0_46>
 1f81575:	vbroadcasti32x4 -0x19d8adf(%rip),%zmm25        # 5a8aa0 <.LCPI0_53>
 1f8157f:	vbroadcasti32x4 -0x19d8b39(%rip),%zmm24        # 5a8a50 <.LCPI0_46>
 1f81589:	vbroadcasti32x4 -0x19d8b53(%rip),%zmm23        # 5a8a40 <.LCPI0_45>
 1f81593:	vbroadcasti32x4 -0x19d8b6d(%rip),%zmm16        # 5a8a30 <.LCPI0_44>
 1f8159d:	vmovdqa64 0x2c0(%rsp),%zmm22
 1f815a5:	vbroadcasti32x4 -0x19d8b8f(%rip),%zmm21        # 5a8a20 <.LCPI0_43>
 1f815af:	vbroadcasti32x4 -0x19d8ba9(%rip),%zmm20        # 5a8a10 <.LCPI0_42>
 1f815b9:	vmovdqa64 0x300(%rsp),%zmm19
 1f815c1:	vbroadcasti32x4 -0x19d8bcb(%rip),%zmm18        # 5a8a00 <.LCPI0_41>
 1f815cb:	vbroadcasti32x4 -0x19d8be5(%rip),%zmm17        # 5a89f0 <.LCPI0_40>
 1f815d5:	vbroadcasti32x4 -0x19d8bff(%rip),%zmm15        # 5a89e0 <.LCPI0_39>
 1f815df:	vbroadcasti32x4 -0x19d8c19(%rip),%zmm14        # 5a89d0 <.LCPI0_38>
 1f815e9:	vbroadcasti32x4 -0x19d8c33(%rip),%zmm12        # 5a89c0 <.LCPI0_37>
 1f815f3:	vbroadcasti32x4 -0x19d8c4d(%rip),%zmm8        # 5a89b0 <.LCPI0_36>
 1f815fd:	vmovdqa64 0x340(%rsp),%zmm10
 1f81605:	mov    0x148(%rsp),%r8
 1f8160d:	kmovq  0x150(%rsp),%k5
 1f81617:	mov    0x40(%rsp),%r9
 1f8161c:	kmovq  0xa8(%rsp),%k4
 1f81626:	kmovq  0x88(%rsp),%k7
 1f81630:	mov    0x98(%rsp),%r10
 1f81638:	mov    0x48(%rsp),%r11
 1f8163d:	kmovq  0xb0(%rsp),%k6
 1f81647:	mov    0x78(%rsp),%rdx
 1f8164c:	mov    0x80(%rsp),%rdi
 1f81654:	incq   0x108(%rsp)
 1f8165c:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f81663:	vpxor  %xmm11,%xmm11,%xmm11
 1f81668:	jmp    1f814a2 <node_contexts_window_loop+0xc22>
 1f8166d:	nopl   (%rax)
 1f81670:	vbroadcasti32x4 -0x19d8cca(%rip),%zmm8        # 5a89b0 <.LCPI0_36>
 1f8167a:	vbroadcasti32x4 -0x19d8bd4(%rip),%zmm30        # 5a8ab0 <.LCPI0_54>
 1f81684:	vbroadcasti32x4 -0x19d8c7e(%rip),%zmm31        # 5a8a10 <.LCPI0_42>
 1f8168e:	mov    0x78(%rsp),%rdx
 1f81693:	xor    %r14d,%r14d
 1f81696:	vpcmpeqb 0x380(%rsp),%zmm14,%k2{%k4}
 1f8169e:	vptestnmb %zmm0,%zmm0,%k1
 1f816a4:	vpaddb 0x240(%rsp),%zmm3,%zmm0
 1f816ac:	mov    0x58(%rsp),%rsi
 1f816b1:	mov    0x90(%rsp),%rbx
 1f816b9:	vptestnmb %zmm7,%zmm7,%k3
 1f816bf:	mov    0xd0(%rsp),%r8
 1f816c7:	and    %r11,%r9
 1f816ca:	mov    %rdx,0x78(%rsp)
 1f816cf:	vptestmb %zmm26,%zmm26,%k0{%k1}
 1f816d5:	kmovq  %k1,0x4c0(%rsp)
 1f816df:	vpcmpltub %zmm14,%zmm4,%k1
 1f816e6:	kmovq  %k3,%r13
 1f816eb:	mov    %r9,0x40(%rsp)
 1f816f0:	kmovq  %k0,%rax
 1f816f5:	vpcmpeqb %zmm16,%zmm22,%k0
 1f816fb:	and    %rax,%rsi
 1f816fe:	korq   %k2,%k1,%k1
 1f81703:	kmovq  0x130(%rsp),%k2
 1f8170d:	korq   %k1,%k2,%k1
 1f81712:	vpcmpeqb %zmm14,%zmm22,%k2{%k4}
 1f81718:	kmovq  %k1,%rax
 1f8171d:	kmovq  %k2,%rcx
 1f81722:	andn   %rax,%rbx,%r12
 1f81727:	kmovq  %k0,%rax
 1f8172c:	mov    0x168(%rsp),%rbx
 1f81734:	vpcmpltub %zmm17,%zmm0,%k0{%k5}
 1f8173b:	vpaddb -0x1acf145(%rip),%zmm22,%zmm0        # 4b2600 <abi_test_hex.digits+0xb900>
 1f81745:	and    %rcx,%r13
 1f81748:	andn   %rax,%r8,%r8
 1f8174d:	or     %r10,%rbx
 1f81750:	andn   0x160(%rsp),%rbx,%rcx
 1f8175a:	kmovq  %k0,%rbx
 1f8175f:	vpcmpltub %zmm24,%zmm0,%k1
 1f81766:	kmovq  %k1,%rax
 1f8176b:	or     %rax,%rcx
 1f8176e:	mov    0xc0(%rsp),%rax
 1f81776:	andn   %rax,%rbx,%r15
 1f8177b:	and    0x68(%rsp),%r15
 1f81780:	and    %rax,%rbx
 1f81783:	and    %r11,%rbx
 1f81786:	and    %rcx,%rbx
 1f81789:	mov    %rbx,0x240(%rsp)
 1f81791:	and    %rcx,%r15
 1f81794:	and    %r11,%r15
 1f81797:	je     1f81978 <node_contexts_window_loop+0x10f8>
 1f8179d:	mov    (%rdi),%rax
 1f817a0:	mov    0x2c0(%rdi),%rcx
 1f817a7:	mov    0x100(%rsp),%rbx
 1f817af:	mov    %r12,0x280(%rsp)
 1f817b7:	xor    %r12d,%r12d
 1f817ba:	mov    %r13,0xd0(%rsp)
 1f817c2:	mov    %r8,0x1c0(%rsp)
 1f817ca:	mov    %rsi,0x58(%rsp)
 1f817cf:	kmovq  %k7,0x88(%rsp)
 1f817d9:	mov    %r11,0x48(%rsp)
 1f817de:	vmovdqa64 %zmm22,0x2c0(%rsp)
 1f817e6:	vmovdqa64 %zmm19,0x300(%rsp)
 1f817ee:	vmovdqa64 %zmm10,0x340(%rsp)
 1f817f6:	mov    %rax,0x380(%rsp)
 1f817fe:	mov    %rcx,0x90(%rsp)
 1f81806:	mov    0x60(%rsp),%rax
 1f8180b:	mov    0x380(%rsp),%rdi
 1f81813:	mov    0x90(%rsp),%rsi
 1f8181b:	xor    %r13d,%r13d
 1f8181e:	tzcnt  %r15,%r13
 1f81823:	lea    (%rax,%r13,1),%edx
 1f81827:	vzeroupper
 1f8182a:	call   1f828b0 <node_contexts_converted>
 1f8182f:	movzbl %al,%eax
 1f81832:	inc    %rbx
 1f81835:	shlx   %r13,%rax,%rax
 1f8183a:	or     %rax,%r12
 1f8183d:	blsr   %r15,%r15
 1f81842:	jne    1f81806 <node_contexts_window_loop+0xf86>
 1f81844:	vmovdqa64 0x340(%rsp),%zmm10
 1f8184c:	vbroadcasti32x4 -0x19d8ea6(%rip),%zmm8        # 5a89b0 <.LCPI0_36>
 1f81856:	vbroadcasti32x4 -0x19d8ea0(%rip),%zmm12        # 5a89c0 <.LCPI0_37>
 1f81860:	vbroadcasti32x4 -0x19d8e9a(%rip),%zmm14        # 5a89d0 <.LCPI0_38>
 1f8186a:	vbroadcasti32x4 -0x19d8e94(%rip),%zmm15        # 5a89e0 <.LCPI0_39>
 1f81874:	vbroadcasti32x4 -0x19d8e8e(%rip),%zmm17        # 5a89f0 <.LCPI0_40>
 1f8187e:	vbroadcasti32x4 -0x19d8e88(%rip),%zmm18        # 5a8a00 <.LCPI0_41>
 1f81888:	vmovdqa64 0x300(%rsp),%zmm19
 1f81890:	vbroadcasti32x4 -0x19d8e8a(%rip),%zmm20        # 5a8a10 <.LCPI0_42>
 1f8189a:	vbroadcasti32x4 -0x19d8e84(%rip),%zmm21        # 5a8a20 <.LCPI0_43>
 1f818a4:	vbroadcasti32x4 -0x19d8e7e(%rip),%zmm16        # 5a8a30 <.LCPI0_44>
 1f818ae:	vbroadcasti32x4 -0x19d8e78(%rip),%zmm23        # 5a8a40 <.LCPI0_45>
 1f818b8:	vbroadcasti32x4 -0x19d8e72(%rip),%zmm24        # 5a8a50 <.LCPI0_46>
 1f818c2:	vbroadcasti32x4 -0x19d8e2c(%rip),%zmm25        # 5a8aa0 <.LCPI0_53>
 1f818cc:	vbroadcasti32x4 -0x19d8e86(%rip),%zmm27        # 5a8a50 <.LCPI0_46>
 1f818d6:	vbroadcasti32x4 -0x19d8e80(%rip),%zmm28        # 5a8a60 <.LCPI0_47>
 1f818e0:	vbroadcasti32x4 -0x19d8f1a(%rip),%zmm29        # 5a89d0 <.LCPI0_38>
 1f818ea:	vbroadcasti32x4 -0x19d8e44(%rip),%zmm30        # 5a8ab0 <.LCPI0_54>
 1f818f4:	vbroadcasti32x4 -0x19d8eee(%rip),%zmm31        # 5a8a10 <.LCPI0_42>
 1f818fe:	vmovdqa64 0x3c0(%rsp),%zmm5
 1f81906:	vmovdqa64 0x2c0(%rsp),%zmm22
 1f8190e:	or     %r12,0x240(%rsp)
 1f81916:	mov    0x80(%rsp),%rdi
 1f8191e:	kmovq  0xb0(%rsp),%k6
 1f81928:	mov    0x48(%rsp),%r11
 1f8192d:	mov    0x98(%rsp),%r10
 1f81935:	kmovq  0x88(%rsp),%k7
 1f8193f:	mov    0x58(%rsp),%rsi
 1f81944:	kmovq  0xa8(%rsp),%k4
 1f8194e:	mov    0x40(%rsp),%r9
 1f81953:	mov    0x1c0(%rsp),%r8
 1f8195b:	mov    0x280(%rsp),%r12
 1f81963:	mov    0xd0(%rsp),%r13
 1f8196b:	vpxor  %xmm11,%xmm11,%xmm11
 1f81970:	mov    %rbx,0x100(%rsp)
 1f81978:	kmovq  0x128(%rsp),%k0
 1f81982:	vbroadcasti32x4 -0x19d8f2c(%rip),%zmm4        # 5a8a60 <.LCPI0_47>
 1f8198c:	vmovdqa64 0x480(%rsp),%zmm0
 1f81994:	mov    0xe8(%rsp),%r15
 1f8199c:	and    %r11,%r13
 1f8199f:	and    0xd8(%rsp),%r12
 1f819a7:	mov    %r9,%rbx
 1f819aa:	and    0xb8(%rsp),%r15
 1f819b2:	korq   %k4,%k0,%k2
 1f819b7:	vptestmb 0x200(%rsp),%zmm14,%k0
 1f819bf:	mov    %r12,0x280(%rsp)
 1f819c7:	mov    $0x0,%r12d
 1f819cd:	kmovq  %k2,%rax
 1f819d2:	and    %rax,%r8
 1f819d5:	mov    %r11,%rax
 1f819d8:	and    0xc0(%rsp),%rax
 1f819e0:	vpcmpeqb %zmm4,%zmm22,%k1
 1f819e6:	mov    %r8,0x1c0(%rsp)
 1f819ee:	mov    %r13,%r8
 1f819f1:	and    %rsi,%r8
 1f819f4:	vptestmb %zmm15,%zmm0,%k1{%k1}
 1f819fa:	and    %rax,%r15
 1f819fd:	kmovq  %k0,%rcx
 1f81a02:	vptestmb %zmm14,%zmm0,%k0
 1f81a08:	andn   %r8,%rcx,%rax
 1f81a0d:	and    %rcx,%r8
 1f81a10:	mov    0xe0(%rsp),%rcx
 1f81a18:	kmovq  %k0,%rdx
 1f81a1d:	mov    %rax,0xc0(%rsp)
 1f81a25:	andn   %r13,%rsi,%rax
 1f81a2a:	and    %rdx,%rbx
 1f81a2d:	mov    0x50(%rsp),%rsi
 1f81a32:	mov    0xa0(%rsp),%r13d
 1f81a3a:	mov    %r8,0xb8(%rsp)
 1f81a42:	mov    %rdx,0x200(%rsp)
 1f81a4a:	mov    %rax,0x380(%rsp)
 1f81a52:	kmovq  %k1,%rax
 1f81a57:	andn   %rax,%rcx,%rcx
 1f81a5c:	cmpb   $0x0,0x3f(%rsp)
 1f81a61:	mov    %rcx,0x58(%rsp)
 1f81a66:	jne    1f82047 <node_contexts_window_loop+0x17c7>
 1f81a6c:	vpsllw $0x7,0x500(%rsp),%zmm0
 1f81a75:	vpcmpnleub 0x440(%rsp),%zmm25,%k0
 1f81a7e:	andn   %r10,%r14,%rax
 1f81a83:	or     0x280(%rsp),%rbx
 1f81a8b:	mov    0x380(%rsp),%r10
 1f81a93:	vpcmpeqb %zmm17,%zmm22,%k2{%k2}
 1f81a99:	mov    0xb8(%rsp),%r9
 1f81aa1:	andn   0x70(%rsp),%rax,%rax
 1f81aa8:	kmovq  %k2,%rdx
 1f81aad:	mov    %rdx,%r8
 1f81ab0:	or     %r10,%rbx
 1f81ab3:	vpmovb2m %zmm0,%k1
 1f81ab9:	korq   %k1,%k0,%k1
 1f81abe:	vpcmpeqb %zmm24,%zmm22,%k0{%k1}
 1f81ac4:	vpcmpeqb -0x1acf50e(%rip),%zmm22,%k1        # 4b25c0 <abi_test_hex.digits+0xb8c0>
 1f81ace:	korq   %k0,%k1,%k1
 1f81ad3:	vpcmpeqb -0x1acf41d(%rip),%zmm22,%k0{%k4}        # 4b26c0 <abi_test_hex.digits+0xb9c0>
 1f81add:	kmovq  %k1,%rcx
 1f81ae2:	or     %rdx,%rcx
 1f81ae5:	and    %r11,%rcx
 1f81ae8:	or     %r10,%rcx
 1f81aeb:	or     %r15,%r10
 1f81aee:	or     %r9,%r15
 1f81af1:	or     %rcx,%r15
 1f81af4:	or     0x40(%rsp),%rcx
 1f81af9:	mov    %rax,0x40(%rsp)
 1f81afe:	kmovq  %k0,%rdx
 1f81b03:	or     %rdx,%r8
 1f81b06:	and    %r11,%r8
 1f81b09:	or     %r8,%rbx
 1f81b0c:	mov    0xc0(%rsp),%r8
 1f81b14:	or     %r8,%rbx
 1f81b17:	or     %r8,%r10
 1f81b1a:	or     %r9,%r8
 1f81b1d:	or     %rcx,%r8
 1f81b20:	mov    0x1c0(%rsp),%rcx
 1f81b28:	or     %r14,%r8
 1f81b2b:	kmovq  %r8,%k4
 1f81b30:	or     %rdx,%rcx
 1f81b33:	and    %r11,%rcx
 1f81b36:	or     %r10,%rcx
 1f81b39:	or     %r9,%rcx
 1f81b3c:	mov    0x240(%rsp),%r9
 1f81b44:	or     %r14,%rcx
 1f81b47:	or     %r9,%rbx
 1f81b4a:	or     %r9,%rcx
 1f81b4d:	or     %r9,%r15
 1f81b50:	cmpl   $0x0,0xa4(%rsp)
 1f81b58:	kmovq  %rbx,%k3
 1f81b5d:	kmovq  %rcx,%k2
 1f81b62:	mov    0x58(%rsp),%rcx
 1f81b67:	kmovq  %r15,%k1
 1f81b6c:	vmovdqu8 -0x1acf876(%rip),%zmm0{%k3}{z}        # 4b2300 <abi_test_hex.digits+0xb600>
 1f81b76:	kmovq  %rcx,%k5
 1f81b7b:	vporq  %zmm31,%zmm0,%zmm1
 1f81b81:	vmovdqu8 %zmm1,%zmm0{%k4}
 1f81b87:	vporq  %zmm24,%zmm0,%zmm1
 1f81b8d:	vmovdqu8 %zmm1,%zmm0{%k1}
 1f81b93:	vporq  %zmm29,%zmm0,%zmm1
 1f81b99:	kmovq  %rax,%k1
 1f81b9e:	vmovdqu8 %zmm1,%zmm0{%k2}
 1f81ba4:	vmovdqu8 -0x1acf36e(%rip),%zmm0{%k5}        # 4b2840 <abi_test_hex.digits+0xbb40>
 1f81bae:	vmovdqu8 -0x1acf338(%rip),%zmm0{%k1}        # 4b2880 <abi_test_hex.digits+0xbb80>
 1f81bb8:	jne    1f81bd1 <node_contexts_window_loop+0x1351>
 1f81bba:	mov    0xf8(%rsp),%rax
 1f81bc2:	kmovq  %rax,%k1
 1f81bc7:	vmovdqu8 -0x1acf311(%rip),%zmm0{%k1}        # 4b28c0 <abi_test_hex.digits+0xbbc0>
 1f81bd1:	vmovdqa64 0x800(%rsp),%zmm1
 1f81bd9:	mov    0x40(%rsp),%rax
 1f81bde:	mov    0x98(%rsp),%rdx
 1f81be6:	vmovdqa64 0x840(%rsp),%zmm3
 1f81bee:	kmovq  0x120(%rsp),%k2
 1f81bf8:	mov    0x60(%rsp),%r9
 1f81bfd:	mov    $0xffffffffffffffff,%r8
 1f81c04:	and    %rax,%rdx
 1f81c07:	vptestmb %zmm1,%zmm1,%k1
 1f81c0d:	vmovdqa64 %zmm0,%zmm1
 1f81c13:	vmovdqu8 %zmm18,%zmm2{%k1}{z}
 1f81c19:	kmovq  0x4c0(%rsp),%k1
 1f81c23:	kmovq  %k1,%rcx
 1f81c28:	andn   %rax,%rcx,%rcx
 1f81c2d:	mov    0xf0(%rsp),%rax
 1f81c35:	kmovq  %rcx,%k1
 1f81c3a:	mov    0xba8(%rdi),%rcx
 1f81c41:	vpaddb %zmm27,%zmm0,%zmm1{%k1}
 1f81c47:	kmovq  %rdx,%k1
 1f81c4c:	mov    %r13d,%edx
 1f81c4f:	sub    %r9d,%edx
 1f81c52:	vpaddb %zmm31,%zmm1,%zmm1{%k1}
 1f81c58:	kmovq  0x140(%rsp),%k1
 1f81c62:	vpermi2b 0x880(%rsp),%zmm1,%zmm3{%k1}{z}
 1f81c6a:	vmovdqu8 0x5c0(%rsp),%zmm3{%k2}
 1f81c72:	vpaddw %zmm3,%zmm3,%zmm3
 1f81c78:	vporq  %zmm2,%zmm3,%zmm2
 1f81c7e:	vpermb 0x80(%rax),%zmm2,%zmm2
 1f81c85:	mov    0x190(%rsp),%rax
 1f81c8d:	vmovdqu64 %zmm0,(%rcx,%r9,1)
 1f81c94:	vpandd -0x19d04ee(%rip){1to16},%zmm2,%zmm3        # 5b17b0 <.LCPI0_55>
 1f81c9e:	mov    0xbb8(%rdi),%rcx
 1f81ca5:	not    %rax
 1f81ca8:	kmovq  %rax,%k1
 1f81cad:	vmovdqu8 %zmm3,%zmm3{%k1}{z}
 1f81cb3:	vmovdqu64 %zmm3,(%rcx,%r9,1)
 1f81cba:	mov    $0xffffffffffffffff,%rcx
 1f81cc1:	jbe    1f81cd3 <node_contexts_window_loop+0x1453>
 1f81cc3:	lea    0x40(%r9),%ecx
 1f81cc7:	cmp    %ecx,%r13d
 1f81cca:	shlx   %rdx,%r8,%rcx
 1f81ccf:	cmovae %r12,%rcx
 1f81cd3:	vmovdqa64 0x440(%rsp),%zmm3
 1f81cdb:	kmovq  0x128(%rsp),%k1
 1f81ce5:	mov    0x200(%rsp),%r8
 1f81ced:	mov    0x138(%rsp),%rax
 1f81cf5:	mov    $0xffffffffffffffff,%r14
 1f81cfc:	movabs $0x7fffffffffffffff,%r15
 1f81d06:	vptestnmb %zmm3,%zmm3,%k0{%k6}
 1f81d0c:	korq   %k1,%k0,%k0
 1f81d11:	kmovq  0x1a8(%rsp),%k1
 1f81d1b:	kmovq  %k0,%rdx
 1f81d20:	vptestmb 0x400(%rsp),%zmm30,%k0
 1f81d28:	and    %rdx,%r11
 1f81d2b:	or     0x198(%rsp),%r11
 1f81d33:	kmovq  %k1,%rdx
 1f81d38:	kmovq  0x1a0(%rsp),%k1
 1f81d42:	and    %rax,%r11
 1f81d45:	mov    %r11,0x48(%rsp)
 1f81d4a:	korq   %k1,%k0,%k0
 1f81d4f:	korq   %k7,%k0,%k0
 1f81d54:	knotq  %k0,%k0
 1f81d59:	kmovq  %k0,%rdi
 1f81d5e:	kmovq  0x130(%rsp),%k0
 1f81d68:	and    %rdx,%rdi
 1f81d6b:	kmovq  %k0,%rbx
 1f81d70:	vpcmpeqb 0x7c0(%rsp),%zmm4,%k0
 1f81d78:	and    0x170(%rsp),%rbx
 1f81d80:	kmovq  %k0,%rdx
 1f81d85:	vpmovb2m %zmm2,%k0
 1f81d8b:	and    %rdi,%rdx
 1f81d8e:	and    %rdx,%rbx
 1f81d91:	kmovq  %k0,%rdx
 1f81d96:	and    %rbx,%r8
 1f81d99:	andn   %rdx,%r8,%rdx
 1f81d9e:	mov    %rdx,%rdi
 1f81da1:	or     %rax,%rdi
 1f81da4:	andn   0x68(%rsp),%rdi,%rdi
 1f81dab:	mov    %r9,%rax
 1f81dae:	je     1f80a10 <node_contexts_window_loop+0x190>
 1f81db4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f81dc0:	xor    %r8d,%r8d
 1f81dc3:	tzcnt  %rdi,%r8
 1f81dc8:	mov    %r13d,%r11d
 1f81dcb:	lea    (%rax,%r8,1),%r9d
 1f81dcf:	sub    0x651b8(%rsi,%r9,4),%r9d
 1f81dd7:	lea    0x1(%r9),%r9d
 1f81ddb:	cmovb  %r12d,%r9d
 1f81ddf:	mov    %r9d,%r10d
 1f81de2:	sub    %eax,%r10d
 1f81de5:	cmp    %r13d,%r9d
 1f81de8:	cmovb  %r9d,%r11d
 1f81dec:	cmp    %eax,%r9d
 1f81def:	shlx   %r10,%r14,%r10
 1f81df4:	cmovbe %r15,%r10
 1f81df8:	cmovb  %r11d,%r13d
 1f81dfc:	bzhi   %r8,%r10,%r8
 1f81e01:	or     %r8,%rcx
 1f81e04:	blsr   %rdi,%rdi
 1f81e09:	jne    1f81dc0 <node_contexts_window_loop+0x1540>
 1f81e0b:	jmp    1f80a10 <node_contexts_window_loop+0x190>
 1f81e10:	kmovq  %k4,%r10
 1f81e15:	kmovq  %k2,%r9
 1f81e1a:	mov    %rdi,0x58(%rsp)
 1f81e1f:	test   %r10,%r10
 1f81e22:	je     1f81ee9 <node_contexts_window_loop+0x1669>
 1f81e28:	mov    0x80(%rsp),%rsi
 1f81e30:	mov    %r10,%rdi
 1f81e33:	mov    0xba8(%rsi),%rsi
 1f81e3a:	mov    %rsi,0x68(%rsp)
 1f81e3f:	mov    0x60(%rsp),%rsi
 1f81e44:	mov    0x50(%rsp),%r12
 1f81e49:	xor    %r11d,%r11d
 1f81e4c:	tzcnt  %rdi,%r11
 1f81e51:	mov    %r11,0x40(%rsp)
 1f81e56:	lea    (%rsi,%r11,1),%r15d
 1f81e5a:	mov    0x50(%rsp),%rsi
 1f81e5f:	movzwl 0x6f654(%r12,%r15,2),%r12d
 1f81e68:	add    %r15d,%r12d
 1f81e6b:	movzbl 0x2c(%rsi,%r12,1),%r15d
 1f81e71:	mov    0x68(%rsp),%rsi
 1f81e76:	movzbl (%rsi,%r12,1),%r14d
 1f81e7b:	mov    0x50(%rsp),%rsi
 1f81e80:	and    $0x7f,%r15d
 1f81e84:	movzwl 0x6b554(%rsi,%r12,2),%r11d
 1f81e8d:	mov    0x50(%rsp),%rsi
 1f81e92:	sub    %r11d,%r12d
 1f81e95:	testb  $0x7f,0x2c(%rsi,%r12,1)
 1f81e9b:	mov    0xf0(%rsp),%r12
 1f81ea3:	mov    0x50(%rsp),%rsi
 1f81ea8:	movzbl (%r12,%r15,1),%r15d
 1f81ead:	mov    0x40(%rsp),%r12
 1f81eb2:	setne  %r11b
 1f81eb6:	add    %r11b,%r11b
 1f81eb9:	or     $0x14,%r11b
 1f81ebd:	cmp    $0x14,%r14b
 1f81ec1:	movzbl %r11b,%r11d
 1f81ec5:	cmovne %r14d,%r11d
 1f81ec9:	blsr   %rdi,%rdi
 1f81ece:	mov    %r15b,0x580(%rsp,%r12,1)
 1f81ed6:	mov    0x60(%rsp),%r15
 1f81edb:	mov    %r11b,0x5c0(%rsp,%r12,1)
 1f81ee3:	jne    1f81e3f <node_contexts_window_loop+0x15bf>
 1f81ee9:	mov    %r9,%r11
 1f81eec:	vmovdqa64 %zmm21,%zmm12
 1f81ef2:	vmovdqa64 %zmm28,%zmm27
 1f81ef8:	test   %r9,%r9
 1f81efb:	je     1f81f74 <node_contexts_window_loop+0x16f4>
 1f81efd:	xor    %edi,%edi
 1f81eff:	tzcnt  %r11,%rdi
 1f81f04:	lea    (%r15,%rdi,1),%r14d
 1f81f08:	movzwl 0x6b554(%rsi,%r14,2),%r15d
 1f81f11:	sub    %r15d,%r14d
 1f81f14:	movzbl 0x2c(%rsi,%r14,1),%r15d
 1f81f1a:	and    $0x7f,%r15b
 1f81f1e:	blsr   %r11,%r11
 1f81f23:	mov    %r15b,0x600(%rsp,%rdi,1)
 1f81f2b:	movzbl (%rdx,%r14,1),%r15d
 1f81f30:	mov    %r15b,0x640(%rsp,%rdi,1)
 1f81f38:	movzbl 0x0(%r13,%r14,1),%r15d
 1f81f3e:	mov    %r15b,0x680(%rsp,%rdi,1)
 1f81f46:	movzbl (%rbx,%r14,1),%r15d
 1f81f4b:	mov    %r15b,0x6c0(%rsp,%rdi,1)
 1f81f53:	movzbl (%r8,%r14,1),%r15d
 1f81f58:	mov    %r15b,0x700(%rsp,%rdi,1)
 1f81f60:	mov    0x60(%rsp),%r15
 1f81f65:	movzbl (%rcx,%r14,1),%r14d
 1f81f6a:	mov    %r14b,0x740(%rsp,%rdi,1)
 1f81f72:	jne    1f81efd <node_contexts_window_loop+0x167d>
 1f81f74:	vmovdqa64 0x1c0(%rsp),%zmm8
 1f81f7c:	vmovdqa64 0x240(%rsp),%zmm21
 1f81f84:	vmovdqa64 0x200(%rsp),%zmm13
 1f81f8c:	popcnt %r10,%rdx
 1f81f91:	add    0xc8(%rsp),%rdx
 1f81f99:	vmovdqu8 0x580(%rsp),%zmm6{%k4}
 1f81fa1:	vmovdqu8 0x680(%rsp),%zmm2{%k2}
 1f81fa9:	vmovdqu8 0x6c0(%rsp),%zmm9{%k2}
 1f81fb1:	popcnt %r9,%rdi
 1f81fb6:	add    %rdi,%rdx
 1f81fb9:	mov    0x58(%rsp),%rdi
 1f81fbe:	mov    %rdx,0xc8(%rsp)
 1f81fc6:	vmovdqu8 0x600(%rsp),%zmm8{%k2}
 1f81fce:	vmovdqu8 0x640(%rsp),%zmm21{%k2}
 1f81fd6:	vmovdqu8 0x700(%rsp),%zmm13{%k2}
 1f81fde:	or     %r9,%rdi
 1f81fe1:	vmovdqa64 %zmm21,0x240(%rsp)
 1f81fe9:	vmovdqa64 %zmm23,%zmm21
 1f81fef:	vmovdqa64 %zmm8,0x1c0(%rsp)
 1f81ff7:	vmovdqa64 %zmm13,0x200(%rsp)
 1f81fff:	jmp    1f80e7b <node_contexts_window_loop+0x5fb>
 1f82004:	vpandd -0x19d0866(%rip){1to16},%zmm11,%zmm6        # 5b17a8 <.LCPI0_51>
 1f8200e:	vmovdqa64 0x1c0(%rsp),%zmm31
 1f82016:	vmovdqa64 %zmm13,%zmm26
 1f8201c:	mov    %r14,0x118(%rsp)
 1f82024:	movq   $0x0,0x110(%rsp)
 1f82030:	movq   $0x0,0xf8(%rsp)
 1f8203c:	vmovdqa64 %zmm11,%zmm5
 1f82042:	jmp    1f8120b <node_contexts_window_loop+0x98b>
 1f82047:	cmpq   $0x0,0x70(%rsp)
 1f8204d:	je     1f820bd <node_contexts_window_loop+0x183d>
 1f8204f:	mov    (%rdi),%rax
 1f82052:	mov    0x8(%rax),%rax
 1f82056:	cmpb   $0x1,0x14a(%rax)
 1f8205d:	jne    1f81a6c <node_contexts_window_loop+0x11ec>
 1f82063:	mov    0x2c0(%rdi),%rcx
 1f8206a:	mov    0x70(%rsp),%r13
 1f8206f:	xor    %r12d,%r12d
 1f82072:	mov    %rax,0x90(%rsp)
 1f8207a:	kmovq  %k2,0xd8(%rsp)
 1f82084:	mov    %r15,0xe8(%rsp)
 1f8208c:	kmovq  %k7,0x88(%rsp)
 1f82096:	mov    %r11,0x48(%rsp)
 1f8209b:	vmovdqa64 %zmm22,0x2c0(%rsp)
 1f820a3:	vmovdqa64 %zmm19,0x300(%rsp)
 1f820ab:	vmovdqa64 %zmm10,0x340(%rsp)
 1f820b3:	mov    %rcx,0xe0(%rsp)
 1f820bb:	jmp    1f820ee <node_contexts_window_loop+0x186e>
 1f820bd:	movq   $0x0,0x70(%rsp)
 1f820c6:	jmp    1f81a6c <node_contexts_window_loop+0x11ec>
 1f820cb:	lea    -0x1ab953d(%rip),%rdx        # 4c8b95 <check_lower_segment_override.segments>
 1f820d2:	xor    %ecx,%ecx
 1f820d4:	testb  $0x3,-0x110(%rax,%rdx,1)
 1f820dc:	setne  %cl
 1f820df:	shlx   %r15,%rcx,%rax
 1f820e4:	or     %rax,%r12
 1f820e7:	blsr   %r13,%r13
 1f820ec:	je     1f8214d <node_contexts_window_loop+0x18cd>
 1f820ee:	mov    0x60(%rsp),%rax
 1f820f3:	mov    0x50(%rsp),%rcx
 1f820f8:	xor    %r15d,%r15d
 1f820fb:	tzcnt  %r13,%r15
 1f82100:	mov    0xe0(%rsp),%rdx
 1f82108:	mov    0x90(%rsp),%rdi
 1f82110:	add    %r15d,%eax
 1f82113:	movzwl 0x6b554(%rcx,%rax,2),%ecx
 1f8211b:	sub    %ecx,%eax
 1f8211d:	shl    $0x6,%rax
 1f82121:	mov    (%rdx,%rax,1),%esi
 1f82124:	vzeroupper
 1f82127:	call   1f2a5e0 <type_object_qualifiers_slow>
 1f8212c:	and    $0xffffff,%eax
 1f82131:	lea    -0x110(%rax),%ecx
 1f82137:	cmp    $0x2,%ecx
 1f8213a:	jbe    1f820cb <node_contexts_window_loop+0x184b>
 1f8213c:	xor    %ecx,%ecx
 1f8213e:	shlx   %r15,%rcx,%rax
 1f82143:	or     %rax,%r12
 1f82146:	blsr   %r13,%r13
 1f8214b:	jne    1f820ee <node_contexts_window_loop+0x186e>
 1f8214d:	vmovdqa64 0x340(%rsp),%zmm10
 1f82155:	vbroadcasti32x4 -0x19d97af(%rip),%zmm8        # 5a89b0 <.LCPI0_36>
 1f8215f:	vbroadcasti32x4 -0x19d97a9(%rip),%zmm12        # 5a89c0 <.LCPI0_37>
 1f82169:	vbroadcasti32x4 -0x19d97a3(%rip),%zmm14        # 5a89d0 <.LCPI0_38>
 1f82173:	vbroadcasti32x4 -0x19d979d(%rip),%zmm15        # 5a89e0 <.LCPI0_39>
 1f8217d:	vbroadcasti32x4 -0x19d9797(%rip),%zmm17        # 5a89f0 <.LCPI0_40>
 1f82187:	vbroadcasti32x4 -0x19d9791(%rip),%zmm18        # 5a8a00 <.LCPI0_41>
 1f82191:	vmovdqa64 0x300(%rsp),%zmm19
 1f82199:	vbroadcasti32x4 -0x19d9793(%rip),%zmm20        # 5a8a10 <.LCPI0_42>
 1f821a3:	vbroadcasti32x4 -0x19d978d(%rip),%zmm21        # 5a8a20 <.LCPI0_43>
 1f821ad:	vbroadcasti32x4 -0x19d9787(%rip),%zmm16        # 5a8a30 <.LCPI0_44>
 1f821b7:	vbroadcasti32x4 -0x19d9781(%rip),%zmm23        # 5a8a40 <.LCPI0_45>
 1f821c1:	vbroadcasti32x4 -0x19d977b(%rip),%zmm24        # 5a8a50 <.LCPI0_46>
 1f821cb:	vbroadcasti32x4 -0x19d9735(%rip),%zmm25        # 5a8aa0 <.LCPI0_53>
 1f821d5:	vbroadcasti32x4 -0x19d978f(%rip),%zmm27        # 5a8a50 <.LCPI0_46>
 1f821df:	vbroadcasti32x4 -0x19d9789(%rip),%zmm28        # 5a8a60 <.LCPI0_47>
 1f821e9:	vbroadcasti32x4 -0x19d9823(%rip),%zmm29        # 5a89d0 <.LCPI0_38>
 1f821f3:	vbroadcasti32x4 -0x19d979d(%rip),%zmm4        # 5a8a60 <.LCPI0_47>
 1f821fd:	vbroadcasti32x4 -0x19d9757(%rip),%zmm30        # 5a8ab0 <.LCPI0_54>
 1f82207:	vbroadcasti32x4 -0x19d9801(%rip),%zmm31        # 5a8a10 <.LCPI0_42>
 1f82211:	vmovdqa64 0x3c0(%rsp),%zmm5
 1f82219:	vmovdqa64 0x2c0(%rsp),%zmm22
 1f82221:	mov    0x70(%rsp),%rax
 1f82226:	mov    0x50(%rsp),%rsi
 1f8222b:	mov    0x80(%rsp),%rdi
 1f82233:	mov    0xa0(%rsp),%r13d
 1f8223b:	kmovq  0xb0(%rsp),%k6
 1f82245:	mov    0x48(%rsp),%r11
 1f8224a:	mov    0x98(%rsp),%r10
 1f82252:	kmovq  0x88(%rsp),%k7
 1f8225c:	mov    0xe8(%rsp),%r15
 1f82264:	kmovq  0xa8(%rsp),%k4
 1f8226e:	kmovq  0xd8(%rsp),%k2
 1f82278:	vpxor  %xmm11,%xmm11,%xmm11
 1f8227d:	andn   %rax,%r12,%rax
 1f82282:	xor    %r12d,%r12d
 1f82285:	mov    %rax,0x70(%rsp)
 1f8228a:	jmp    1f81a6c <node_contexts_window_loop+0x11ec>
 1f8228f:	vmovq  0xc8(%rsp),%xmm0
 1f82298:	vmovq  %rax,%xmm1
 1f8229d:	mov    0x158(%rsp),%rcx
 1f822a5:	mov    0x78(%rsp),%rax
 1f822aa:	mov    0x108(%rsp),%rdx
 1f822b2:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f822b6:	vmovq  %rdx,%xmm1
 1f822bb:	vmovq  %rax,%xmm2
 1f822c0:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f822c4:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f822ca:	vinserti64x4 $0x1,%ymm10,%zmm0,%zmm0
 1f822d1:	vpaddq (%rcx),%zmm0,%zmm0
 1f822d7:	vmovdqu64 %zmm0,(%rcx)
 1f822dd:	lea    -0x28(%rbp),%rsp
 1f822e1:	pop    %rbx
 1f822e2:	pop    %r12
 1f822e4:	pop    %r13
 1f822e6:	pop    %r14
 1f822e8:	pop    %r15
 1f822ea:	pop    %rbp
 1f822eb:	vzeroupper
 1f822ee:	ret

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .iplt:
