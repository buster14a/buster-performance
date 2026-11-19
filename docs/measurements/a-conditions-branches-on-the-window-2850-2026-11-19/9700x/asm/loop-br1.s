
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
 1f80858:	mov    %rdi,%rbx
 1f8085b:	mov    (%rbx),%rax
 1f8085e:	mov    0xb38(%rdi),%rdi
 1f80865:	add    $0x3f,%edx
 1f80868:	vpxor  %xmm0,%xmm0,%xmm0
 1f8086c:	mov    0x8(%rax),%rax
 1f80870:	movzbl 0x14a(%rax),%eax
 1f80877:	vmovdqa64 %zmm0,0x900(%rsp)
 1f8087f:	vmovdqa64 %zmm0,0x8c0(%rsp)
 1f80887:	vmovdqa64 %zmm0,0x880(%rsp)
 1f8088f:	vmovdqa64 %zmm0,0x840(%rsp)
 1f80897:	vmovdqa64 %zmm0,0x800(%rsp)
 1f8089f:	vmovdqa64 %zmm0,0x7c0(%rsp)
 1f808a7:	vmovdqa64 %zmm0,0x780(%rsp)
 1f808af:	vmovdqa64 %zmm0,0x740(%rsp)
 1f808b7:	mov    %al,0x2f(%rsp)
 1f808bb:	cmp    $0x40,%edx
 1f808be:	jae    1f808cd <node_contexts_window_loop+0x8d>
 1f808c0:	xor    %edx,%edx
 1f808c2:	xor    %eax,%eax
 1f808c4:	vpxor  %xmm5,%xmm5,%xmm5
 1f808c8:	jmp    1f821e9 <node_contexts_window_loop+0x19a9>
 1f808cd:	vbroadcasti32x4 -0x19d7f27(%rip),%zmm9        # 5a89b0 <.LCPI0_36>
 1f808d7:	vbroadcasti32x4 -0x19d7f21(%rip),%zmm10        # 5a89c0 <.LCPI0_37>
 1f808e1:	vbroadcasti32x4 -0x19d7f1b(%rip),%zmm11        # 5a89d0 <.LCPI0_38>
 1f808eb:	vbroadcasti32x4 -0x19d7f15(%rip),%zmm12        # 5a89e0 <.LCPI0_39>
 1f808f5:	vbroadcasti32x4 -0x19d7f0f(%rip),%zmm13        # 5a89f0 <.LCPI0_40>
 1f808ff:	vbroadcasti32x4 -0x19d7f09(%rip),%zmm15        # 5a8a00 <.LCPI0_41>
 1f80909:	vbroadcasti32x4 -0x19d7f03(%rip),%zmm16        # 5a8a10 <.LCPI0_42>
 1f80913:	vbroadcasti32x4 -0x19d7efd(%rip),%zmm18        # 5a8a20 <.LCPI0_43>
 1f8091d:	vbroadcasti32x4 -0x19d7ef7(%rip),%zmm6        # 5a8a30 <.LCPI0_44>
 1f80927:	vbroadcasti32x4 -0x19d7ef1(%rip),%zmm20        # 5a8a40 <.LCPI0_45>
 1f80931:	shr    $0x6,%edx
 1f80934:	mov    $0xffffffff,%r12d
 1f8093a:	mov    %rcx,0x148(%rsp)
 1f80942:	vpxor  %xmm5,%xmm5,%xmm5
 1f80946:	vpxord %xmm27,%xmm27,%xmm27
 1f8094c:	movq   $0x0,0x48(%rsp)
 1f80955:	xor    %eax,%eax
 1f80957:	movq   $0x0,0xb8(%rsp)
 1f80963:	movq   $0x0,0x128(%rsp)
 1f8096f:	vpxord %xmm22,%xmm22,%xmm22
 1f80975:	vpxord %xmm28,%xmm28,%xmm28
 1f8097b:	mov    %rbx,0x30(%rsp)
 1f80980:	mov    %rsi,0x78(%rsp)
 1f80985:	mov    %rdi,0x118(%rsp)
 1f8098d:	jmp    1f80b37 <node_contexts_window_loop+0x2f7>
 1f80992:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f809a0:	kmovq  0x150(%rsp),%k1
 1f809aa:	vpcmpeqb %zmm6,%zmm4,%k0
 1f809b0:	vpcmpeqb -0x1ace37a(%rip),%zmm4,%k3        # 4b2640 <abi_test_hex.digits+0xb940>
 1f809ba:	vpaddb -0x1ace304(%rip),%zmm4,%zmm2        # 4b26c0 <abi_test_hex.digits+0xb9c0>
 1f809c4:	vpandq %zmm21,%zmm26,%zmm3
 1f809ca:	mov    0x50(%rsp),%r14
 1f809cf:	mov    0x200(%rsp),%r8
 1f809d7:	mov    0x160(%rsp),%r11
 1f809df:	vpcmpeqb %zmm20,%zmm4,%k2
 1f809e5:	mov    0xb0(%rsp),%r10
 1f809ed:	mov    0x30(%rsp),%rbx
 1f809f2:	vmovdqa64 %zmm23,%zmm27
 1f809f8:	vmovdqa64 %zmm0,%zmm28
 1f809fe:	or     0x180(%rsp),%r14
 1f80a06:	andn   0x38(%rsp),%r8,%r9
 1f80a0d:	vpcmpeqb %zmm9,%zmm24,%k2{%k2}
 1f80a13:	or     0x280(%rsp),%r14
 1f80a1b:	korq   %k1,%k0,%k0
 1f80a20:	kmovq  0x158(%rsp),%k1
 1f80a2a:	vmovq  %r11,%xmm4
 1f80a2f:	or     %rcx,%r14
 1f80a32:	andn   %r11,%rax,%rcx
 1f80a37:	vptestnmb %zmm3,%zmm3,%k3{%k3}
 1f80a3d:	or     %rcx,%r14
 1f80a40:	andn   %r10,%rdx,%rcx
 1f80a45:	mov    0xbd0(%rbx),%rdx
 1f80a4c:	vmovq  %rax,%xmm3
 1f80a51:	mov    0x120(%rsp),%rax
 1f80a59:	and    %rdi,%rcx
 1f80a5c:	kandq  %k1,%k0,%k0
 1f80a61:	vpcmpltub -0x1ace26c(%rip),%zmm2,%k1        # 4b2800 <abi_test_hex.digits+0xbb00>
 1f80a6c:	korq   %k3,%k1,%k1
 1f80a71:	vpmovb2m %zmm25,%k3
 1f80a77:	korq   %k3,%k1,%k1
 1f80a7c:	korq   %k0,%k1,%k1
 1f80a81:	korq   %k2,%k1,%k1
 1f80a86:	kmovq  %k1,%r8
 1f80a8b:	vptestnmb %zmm1,%zmm1,%k1
 1f80a91:	vpxor  %xmm1,%xmm1,%xmm1
 1f80a95:	kmovq  %k1,%r15
 1f80a9a:	or     %r9,%r8
 1f80a9d:	mov    0x170(%rsp),%r9
 1f80aa5:	kmovq  0x138(%rsp),%k1
 1f80aaf:	or     %r8,%r14
 1f80ab2:	and    %rcx,%r15
 1f80ab5:	and    %r10,%r14
 1f80ab8:	mov    %r9d,%edi
 1f80abb:	shl    $0x6,%rdi
 1f80abf:	kandq  %k1,%k0,%k0
 1f80ac4:	vpcmpgtb %zmm25,%zmm1,%k1{%k1}
 1f80aca:	mov    %rcx,(%rdx,%rdi,1)
 1f80ace:	mov    %r15,0x8(%rdx,%rdi,1)
 1f80ad3:	mov    %r14,0x10(%rdx,%rdi,1)
 1f80ad8:	kmovq  %k0,0x18(%rdx,%rdi,1)
 1f80adf:	kmovq  %k1,0x20(%rdx,%rdi,1)
 1f80ae6:	mov    0x240(%rsp),%rdx
 1f80aee:	kmovq  %k4,%rcx
 1f80af3:	mov    0x118(%rsp),%rdi
 1f80afb:	and    %r10,%rdx
 1f80afe:	and    %rdx,%rcx
 1f80b01:	vmovq  %rdx,%xmm1
 1f80b06:	mov    0x178(%rsp),%rdx
 1f80b0e:	vmovq  %rcx,%xmm2
 1f80b13:	vpunpcklqdq %xmm2,%xmm1,%xmm1
 1f80b17:	vpunpcklqdq %xmm3,%xmm4,%xmm2
 1f80b1b:	vinserti128 $0x1,%xmm1,%ymm2,%ymm1
 1f80b21:	vpopcntq %ymm1,%ymm1
 1f80b27:	vpaddq %ymm5,%ymm1,%ymm5
 1f80b2b:	dec    %rdx
 1f80b2e:	test   %r9d,%r9d
 1f80b31:	je     1f821c2 <node_contexts_window_loop+0x1982>
 1f80b37:	lea    -0x1(%rdx),%r9d
 1f80b3b:	vpbroadcastq -0x19d1ddd(%rip),%zmm1        # 5aed68 <.LCPI0_0>
 1f80b45:	mov    0xba0(%rbx),%r11
 1f80b4c:	vmovdqa64 %zmm22,%zmm0
 1f80b52:	vmovdqu64 (%rdi),%zmm22
 1f80b58:	vmovdqa64 -0x1aceae2(%rip),%zmm7        # 4b2080 <abi_test_hex.digits+0xb380>
 1f80b62:	mov    %rax,0x120(%rsp)
 1f80b6a:	mov    0xb88(%rbx),%rax
 1f80b71:	vmovdqa64 -0x1acea7b(%rip),%zmm8        # 4b2100 <abi_test_hex.digits+0xb400>
 1f80b7b:	vmovdqa64 %zmm18,%zmm21
 1f80b81:	mov    %rdx,0x178(%rsp)
 1f80b89:	vmovdqa64 %zmm16,%zmm18
 1f80b8f:	mov    0xb80(%rbx),%r14
 1f80b96:	mov    0xb90(%rbx),%rdx
 1f80b9d:	vmovdqa64 %zmm9,%zmm19
 1f80ba3:	mov    0xb98(%rbx),%r15
 1f80baa:	vmovdqa64 %zmm13,%zmm14
 1f80bb0:	vmovdqa64 %zmm6,%zmm17
 1f80bb6:	mov    %r12d,0x74(%rsp)
 1f80bbb:	mov    %r9,%r13
 1f80bbe:	shl    $0x6,%r13
 1f80bc2:	test   %r9d,%r9d
 1f80bc5:	mov    %r9,0x170(%rsp)
 1f80bcd:	lea    -0x40(%r13),%r8d
 1f80bd1:	vpandq 0x2c(%rsi,%r13,1),%zmm1,%zmm23
 1f80bdc:	cmove  %r9d,%r8d
 1f80be0:	shl    $0x7,%r9
 1f80be4:	vmovdqu64 0x6b554(%rsi,%r9,1),%zmm1
 1f80bef:	vmovdqu64 0x6b594(%rsi,%r9,1),%zmm2
 1f80bfa:	vmovdqu64 (%r11,%r13,1),%zmm26
 1f80c01:	vmovdqu64 (%rax,%r13,1),%zmm16
 1f80c08:	vmovdqu64 (%r14,%r13,1),%zmm30
 1f80c0f:	vmovdqu64 (%rdx,%r13,1),%zmm24
 1f80c16:	vmovdqu64 (%r15,%r13,1),%zmm25
 1f80c1d:	vmovdqu64 (%r11,%r8,1),%zmm31
 1f80c24:	vpermt2b 0x40(%rdi),%zmm23,%zmm22
 1f80c2b:	vpmovuswb %zmm1,%ymm1
 1f80c31:	vpmovuswb %zmm2,%ymm2
 1f80c37:	vmovdqa64 %zmm16,0x240(%rsp)
 1f80c3f:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm3
 1f80c46:	vpandq %zmm9,%zmm26,%zmm1
 1f80c4c:	vmovdqu64 0x6f694(%rsi,%r9,1),%zmm2
 1f80c57:	vmovdqu64 (%rax,%r8,1),%zmm9
 1f80c5e:	vptestmb %zmm1,%zmm1,%k4
 1f80c64:	vmovdqu64 0x6f654(%rsi,%r9,1),%zmm1
 1f80c6f:	vptestmb %zmm3,%zmm3,%k0
 1f80c75:	vpsubb %zmm3,%zmm8,%zmm13
 1f80c7b:	kandq  %k0,%k4,%k2
 1f80c80:	kmovq  %k0,%r10
 1f80c85:	vpcmpnltub %zmm3,%zmm8,%k0
 1f80c8c:	kmovq  %k4,%rdi
 1f80c91:	kmovq  %k4,0x138(%rsp)
 1f80c9b:	kmovq  %k0,%rcx
 1f80ca0:	vpcmpltub %zmm3,%zmm8,%k2{%k2}
 1f80ca7:	mov    %rdi,0xb0(%rsp)
 1f80caf:	and    %r10,%rcx
 1f80cb2:	mov    %rcx,0x38(%rsp)
 1f80cb7:	vpmovuswb %zmm2,%ymm2
 1f80cbd:	vmovdqa64 %zmm9,%zmm3
 1f80cc3:	vpmovuswb %zmm1,%ymm1
 1f80cc9:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm1
 1f80cd0:	vmovdqu64 0x196ac(%rsi,%r13,1),%zmm2
 1f80cdb:	vpaddb -0x1acec25(%rip),%zmm1,%zmm29        # 4b20c0 <abi_test_hex.digits+0xb3c0>
 1f80ce5:	vptestmb %zmm2,%zmm2,%k3
 1f80ceb:	vmovdqa64 %zmm22,%zmm2
 1f80cf1:	vpcmpleub %zmm7,%zmm1,%k1{%k3}
 1f80cf8:	kandq  %k4,%k3,%k3
 1f80cfd:	vpermt2b %zmm0,%zmm29,%zmm2{%k1}{z}
 1f80d03:	vmovdqu64 0x6d5d4(%rsi,%r9,1),%zmm0
 1f80d0e:	kmovq  %k1,0x168(%rsp)
 1f80d18:	vpcmpnleub %zmm7,%zmm1,%k5{%k3}
 1f80d1f:	vbroadcasti32x4 -0x19d82d9(%rip),%zmm7        # 5a8a50 <.LCPI0_46>
 1f80d29:	vmovdqu64 (%r15,%r8,1),%zmm1
 1f80d30:	kmovq  %rcx,%k3
 1f80d35:	vpandq 0x2c(%rsi,%r8,1),%zmm7,%zmm7
 1f80d40:	vpermt2b %zmm16,%zmm13,%zmm3{%k3}{z}
 1f80d46:	vpermt2b %zmm26,%zmm13,%zmm31{%k3}{z}
 1f80d4c:	kortestq %k5,%k2
 1f80d51:	kmovq  %k5,0x130(%rsp)
 1f80d5b:	vmovdqa64 %zmm2,0x180(%rsp)
 1f80d63:	vmovdqu64 0x6d614(%rsi,%r9,1),%zmm2
 1f80d6e:	vmovdqa64 %zmm3,0x200(%rsp)
 1f80d76:	vpmovuswb %zmm0,%ymm0
 1f80d7c:	vpermt2b %zmm23,%zmm13,%zmm7{%k3}{z}
 1f80d82:	vpmovuswb %zmm2,%ymm2
 1f80d88:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 1f80d8f:	vpcmpltub -0x1acec5a(%rip),%zmm0,%k1        # 4b2140 <abi_test_hex.digits+0xb440>
 1f80d9a:	vmovdqu64 (%rdx,%r8,1),%zmm2
 1f80da1:	vpsubb %zmm0,%zmm8,%zmm4
 1f80da7:	vptestmb %zmm0,%zmm0,%k1{%k1}
 1f80dad:	vmovdqu64 (%r14,%r8,1),%zmm0
 1f80db4:	vmovdqa64 %zmm2,%zmm3
 1f80dba:	vpermt2b %zmm24,%zmm13,%zmm3{%k3}{z}
 1f80dc0:	vpermt2b %zmm24,%zmm4,%zmm2
 1f80dc6:	vpermt2b %zmm16,%zmm4,%zmm9{%k1}{z}
 1f80dcc:	vmovdqa64 %zmm0,%zmm6
 1f80dd2:	vpermt2b %zmm30,%zmm13,%zmm6{%k3}{z}
 1f80dd8:	vpermi2b %zmm25,%zmm1,%zmm13{%k3}{z}
 1f80dde:	vpermt2b %zmm30,%zmm4,%zmm0
 1f80de4:	vpermt2b %zmm25,%zmm4,%zmm1
 1f80dea:	vmovdqa64 %zmm9,0x280(%rsp)
 1f80df2:	vmovdqa64 %zmm13,0x640(%rsp)
 1f80dfa:	jne    1f81d62 <node_contexts_window_loop+0x1522>
 1f80e00:	vmovdqa64 %zmm6,0x1c0(%rsp)
 1f80e08:	vmovdqa64 %zmm17,%zmm6
 1f80e0e:	vmovdqa64 %zmm18,%zmm16
 1f80e14:	vmovdqa64 0x200(%rsp),%zmm9
 1f80e1c:	vbroadcasti32x4 -0x19d83c6(%rip),%zmm4        # 5a8a60 <.LCPI0_47>
 1f80e26:	vmovdqu64 0x1a72c(%rsi,%r13,1),%zmm8
 1f80e31:	vpxor  %xmm13,%xmm13,%xmm13
 1f80e36:	vmovdqa64 %zmm21,%zmm18
 1f80e3c:	vpandq %zmm16,%zmm1,%zmm1
 1f80e42:	mov    %r13,0xa0(%rsp)
 1f80e4a:	vptestmb %zmm11,%zmm9,%k3
 1f80e50:	vpandq %zmm4,%zmm3,%zmm3
 1f80e56:	vpandq %zmm4,%zmm2,%zmm2
 1f80e5c:	vptestnmb %zmm8,%zmm8,%k2
 1f80e62:	vpandq -0x19d20fc(%rip){1to8},%zmm22,%zmm4        # 5aed70 <.LCPI0_20>
 1f80e6c:	kmovq  %k3,%r15
 1f80e71:	vptestmb 0x280(%rsp),%zmm11,%k3
 1f80e79:	vpcmpeqb %zmm11,%zmm3,%k0
 1f80e7f:	vmovdqa64 0x240(%rsp),%zmm3
 1f80e87:	kmovq  %k2,0x108(%rsp)
 1f80e91:	vpcmpgtb 0x180(%rsp),%zmm13,%k2{%k2}
 1f80e99:	kmovq  %k0,%rax
 1f80e9e:	vpcmpeqb %zmm11,%zmm2,%k0{%k1}
 1f80ea4:	vpandq %zmm21,%zmm25,%zmm2
 1f80eaa:	vbroadcasti32x4 -0x19d8444(%rip),%zmm21        # 5a8a70 <.LCPI0_48>
 1f80eb4:	and    0x38(%rsp),%rax
 1f80eb9:	vpcmpeqb %zmm10,%zmm2,%k6
 1f80ebf:	kmovq  %k6,0x100(%rsp)
 1f80ec9:	or     %rax,%r15
 1f80ecc:	korq   %k0,%k3,%k7
 1f80ed1:	vptestmb -0x1aceadb(%rip),%zmm3,%k0        # 4b2400 <abi_test_hex.digits+0xb700>
 1f80edb:	vptestnmb %zmm2,%zmm2,%k3
 1f80ee1:	vpandq %zmm16,%zmm25,%zmm2
 1f80ee7:	kmovq  %k3,%rdx
 1f80eec:	vptestmb %zmm2,%zmm2,%k3
 1f80ef2:	vpcmpeqb %zmm6,%zmm2,%k5
 1f80ef8:	vmovdqa64 %zmm2,0x700(%rsp)
 1f80f00:	vmovdqu8 %zmm10,%zmm2{%k2}{z}
 1f80f06:	kmovq  %k3,%rsi
 1f80f0b:	knotq  %k2,%k3
 1f80f10:	kmovq  %k5,%k4
 1f80f15:	kmovq  %k3,%r12
 1f80f1a:	mov    %rsi,0xa8(%rsp)
 1f80f22:	and    %r12,%rdx
 1f80f25:	kmovq  %k0,%rcx
 1f80f2a:	vptestmb %zmm15,%zmm3,%k0
 1f80f30:	korq   %k2,%k0,%k3
 1f80f35:	mov    %rcx,0x58(%rsp)
 1f80f3a:	kandq  %k5,%k3,%k0
 1f80f3f:	kmovq  %k3,0xf0(%rsp)
 1f80f49:	kmovq  %k0,%rbx
 1f80f4e:	vptestmb %zmm12,%zmm3,%k0{%k6}
 1f80f54:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f80f5b:	vptestnmb %zmm7,%zmm7,%k6
 1f80f61:	vpaddb %zmm3,%zmm30,%zmm17
 1f80f67:	or     %rdx,%rbx
 1f80f6a:	mov    0x30(%rsp),%rdx
 1f80f6f:	vpaddb %zmm3,%zmm0,%zmm0
 1f80f75:	and    0xa8(%rsp),%rbx
 1f80f7d:	mov    %r12,0xa8(%rsp)
 1f80f85:	vpcmpltub %zmm11,%zmm17,%k2
 1f80f8c:	vpcmpltub %zmm14,%zmm17,%k5
 1f80f93:	vbroadcasti32x4 -0x19d851d(%rip),%zmm17        # 5a8a80 <.LCPI0_49>
 1f80f9d:	kmovq  %k2,0xd0(%rsp)
 1f80fa7:	vptestmb %zmm12,%zmm22,%k2{%k2}
 1f80fad:	kmovq  %k5,0xd8(%rsp)
 1f80fb7:	kmovq  %k0,%rsi
 1f80fbc:	vpcmpeqb %zmm15,%zmm1,%k0{%k1}
 1f80fc2:	vpcmpltub %zmm14,%zmm0,%k1{%k1}
 1f80fc9:	vbroadcasti32x4 -0x19d8543(%rip),%zmm0        # 5a8a90 <.LCPI0_50>
 1f80fd3:	vpandq %zmm12,%zmm9,%zmm1
 1f80fd9:	kmovq  %k0,0x158(%rsp)
 1f80fe3:	mov    0xbb0(%rdx),%rax
 1f80fea:	kmovq  %k1,0x50(%rsp)
 1f80ff1:	and    %r12,%rsi
 1f80ff4:	or     0x58(%rsp),%rsi
 1f80ff9:	kmovq  %k5,%r12
 1f80ffe:	vmovdqa64 %zmm1,0x6c0(%rsp)
 1f81006:	mov    %r15,0x58(%rsp)
 1f8100b:	kandq  %k0,%k2,%k0
 1f81010:	kmovq  %k2,0x150(%rsp)
 1f8101a:	vpcmpgtb %zmm31,%zmm13,%k2{%k6}
 1f81020:	vmovdqa64 %zmm14,%zmm13
 1f81026:	vpandq %zmm20,%zmm26,%zmm14
 1f8102c:	knotq  %k0,%k0
 1f81031:	kmovq  %k0,%r8
 1f81036:	vpcmpeqb %zmm17,%zmm4,%k0{%k5}
 1f8103c:	kmovq  %k0,%rdi
 1f81041:	vptestmb %zmm1,%zmm1,%k0
 1f81047:	vmovdqu64 %zmm2,(%rax,%r13,1)
 1f8104e:	mov    %rsi,0xf8(%rsp)
 1f81056:	not    %rsi
 1f81059:	korq   %k2,%k0,%k0
 1f8105e:	mov    0xbc0(%rdx),%rax
 1f81065:	and    %r8,%rdi
 1f81068:	kmovq  %k7,%k2
 1f8106d:	knotq  %k0,%k0
 1f81072:	kmovq  %k0,%r9
 1f81077:	vptestmb %zmm21,%zmm22,%k0
 1f8107d:	kmovq  %k0,0xe0(%rsp)
 1f81087:	korq   %k1,%k0,%k0
 1f8108c:	vpcmpeqb %zmm15,%zmm4,%k1
 1f81092:	kmovq  %k0,%r14
 1f81097:	vpcmpeqb %zmm0,%zmm4,%k0
 1f8109d:	kmovq  %k1,0x98(%rsp)
 1f810a7:	korq   %k0,%k1,%k0
 1f810ac:	or     %r15,%r14
 1f810af:	vmovdqu64 %zmm4,(%rax,%r13,1)
 1f810b6:	kmovq  %k0,%r10
 1f810bb:	vpcmpneqb %zmm0,%zmm4,%k0
 1f810c2:	and    %r9,%r14
 1f810c5:	kmovq  %k3,%r9
 1f810ca:	vpsllw $0x7,%zmm26,%zmm0
 1f810d1:	kmovq  %k0,%rcx
 1f810d6:	vptestmb %zmm14,%zmm14,%k0
 1f810dc:	mov    %r9,0x80(%rsp)
 1f810e4:	korq   %k0,%k7,%k0
 1f810e9:	or     %r12,%rcx
 1f810ec:	or     %r9,%rcx
 1f810ef:	knotq  %k0,%k0
 1f810f4:	and    0xb0(%rsp),%rcx
 1f810fc:	kmovq  %k0,%r11
 1f81101:	vpmovb2m %zmm0,%k0
 1f81107:	kmovq  %k0,%rax
 1f8110c:	and    %r10,%r11
 1f8110f:	kmovq  %k0,0xe8(%rsp)
 1f81119:	mov    %r12,%r10
 1f8111c:	andn   %rbx,%rax,%r8
 1f81121:	mov    %rax,0x88(%rsp)
 1f81129:	mov    %r8,0xc8(%rsp)
 1f81131:	andn   %rsi,%r8,%r8
 1f81136:	and    %r8,%rcx
 1f81139:	and    %r8,%rdi
 1f8113c:	mov    %r8,0x90(%rsp)
 1f81144:	and    %rdi,%r14
 1f81147:	and    %r11,%rcx
 1f8114a:	mov    %rdi,0x160(%rsp)
 1f81152:	mov    %rcx,%rdi
 1f81155:	or     %r14,%rdi
 1f81158:	mov    %r14,0x40(%rsp)
 1f8115d:	and    %r15,%rdi
 1f81160:	je     1f813d0 <node_contexts_window_loop+0xb90>
 1f81166:	mov    %r13,%r15
 1f81169:	shl    $0x6,%r15
 1f8116d:	add    0x2c0(%rdx),%r15
 1f81174:	mov    0x20(%rdx),%rbx
 1f81178:	mov    0x60(%rdx),%r12d
 1f8117c:	mov    0x48(%rsp),%rdx
 1f81181:	kmovq  %k4,%k7
 1f81186:	mov    %rdi,%r13
 1f81189:	vmovdqa64 %zmm19,%zmm9
 1f8118f:	nop
 1f81190:	xor    %r14d,%r14d
 1f81193:	tzcnt  %r13,%r14
 1f81198:	mov    %r14d,%eax
 1f8119b:	shl    $0x6,%eax
 1f8119e:	mov    0x20(%r15,%rax,1),%esi
 1f811a3:	mov    %esi,%ecx
 1f811a5:	shr    $0x3,%ecx
 1f811a8:	cmp    %r12d,%ecx
 1f811ab:	cmovae %r12d,%ecx
 1f811af:	shl    $0x6,%rcx
 1f811b3:	cmpl   $0x0,0x38(%rbx,%rcx,1)
 1f811b8:	setne  %al
 1f811bb:	testb  $0x4,0x34(%rbx,%rcx,1)
 1f811c0:	je     1f811e0 <node_contexts_window_loop+0x9a0>
 1f811c2:	xor    $0x1,%al
 1f811c4:	inc    %rdx
 1f811c7:	movzbl %al,%eax
 1f811ca:	shlx   %r14,%rax,%rax
 1f811cf:	andn   %rdi,%rax,%rdi
 1f811d4:	blsr   %r13,%r13
 1f811d9:	jne    1f81190 <node_contexts_window_loop+0x950>
 1f811db:	jmp    1f813e2 <node_contexts_window_loop+0xba2>
 1f811e0:	mov    %rdi,0x110(%rsp)
 1f811e8:	mov    0x30(%rsp),%rdi
 1f811ed:	vmovdqa64 %zmm5,0x600(%rsp)
 1f811f5:	mov    %rdx,0x48(%rsp)
 1f811fa:	vmovdqa64 %zmm22,0x5c0(%rsp)
 1f81202:	vmovdqa64 %zmm23,0x580(%rsp)
 1f8120a:	vmovdqa64 %zmm24,0x540(%rsp)
 1f81212:	vmovdqa64 %zmm25,0x500(%rsp)
 1f8121a:	vmovdqa64 %zmm26,0x4c0(%rsp)
 1f81222:	vmovdqa64 %zmm27,0x480(%rsp)
 1f8122a:	vmovdqa64 %zmm28,0x440(%rsp)
 1f81232:	vmovdqa64 %zmm7,0x400(%rsp)
 1f8123a:	vmovdqa64 %zmm29,0x3c0(%rsp)
 1f81242:	vmovdqa64 %zmm4,0x380(%rsp)
 1f8124a:	vmovdqa64 %zmm8,0x340(%rsp)
 1f81252:	vmovdqa64 %zmm30,0x300(%rsp)
 1f8125a:	vmovdqa64 %zmm31,0x2c0(%rsp)
 1f81262:	kmovq  %k6,0x60(%rsp)
 1f81269:	kmovq  %k7,0xc0(%rsp)
 1f81273:	vmovdqa64 %zmm14,0x680(%rsp)
 1f8127b:	kmovq  %k2,0x68(%rsp)
 1f81282:	mov    %r10,0x140(%rsp)
 1f8128a:	vzeroupper
 1f8128d:	call   1f8283a <node_contexts_stride_asked>
 1f81292:	vmovdqa64 0x2c0(%rsp),%zmm31
 1f8129a:	vmovdqa64 0x300(%rsp),%zmm30
 1f812a2:	vmovdqa64 0x340(%rsp),%zmm8
 1f812aa:	vmovdqa64 0x380(%rsp),%zmm4
 1f812b2:	vmovdqa64 0x3c0(%rsp),%zmm29
 1f812ba:	vmovdqa64 0x400(%rsp),%zmm7
 1f812c2:	vmovdqa64 0x440(%rsp),%zmm28
 1f812ca:	vmovdqa64 0x480(%rsp),%zmm27
 1f812d2:	vmovdqa64 0x4c0(%rsp),%zmm26
 1f812da:	vmovdqa64 0x500(%rsp),%zmm25
 1f812e2:	vmovdqa64 0x540(%rsp),%zmm24
 1f812ea:	vmovdqa64 0x580(%rsp),%zmm23
 1f812f2:	vmovdqa64 0x5c0(%rsp),%zmm22
 1f812fa:	vbroadcasti32x4 -0x19d8894(%rip),%zmm21        # 5a8a70 <.LCPI0_48>
 1f81304:	vbroadcasti32x4 -0x19d88ce(%rip),%zmm20        # 5a8a40 <.LCPI0_45>
 1f8130e:	vbroadcasti32x4 -0x19d88e8(%rip),%zmm6        # 5a8a30 <.LCPI0_44>
 1f81318:	vbroadcasti32x4 -0x19d8902(%rip),%zmm18        # 5a8a20 <.LCPI0_43>
 1f81322:	vbroadcasti32x4 -0x19d88ac(%rip),%zmm17        # 5a8a80 <.LCPI0_49>
 1f8132c:	vbroadcasti32x4 -0x19d8926(%rip),%zmm16        # 5a8a10 <.LCPI0_42>
 1f81336:	vbroadcasti32x4 -0x19d8940(%rip),%zmm15        # 5a8a00 <.LCPI0_41>
 1f81340:	vbroadcasti32x4 -0x19d895a(%rip),%zmm13        # 5a89f0 <.LCPI0_40>
 1f8134a:	vmovdqa64 0x680(%rsp),%zmm14
 1f81352:	vbroadcasti32x4 -0x19d897c(%rip),%zmm12        # 5a89e0 <.LCPI0_39>
 1f8135c:	vbroadcasti32x4 -0x19d8996(%rip),%zmm11        # 5a89d0 <.LCPI0_38>
 1f81366:	vbroadcasti32x4 -0x19d89b0(%rip),%zmm10        # 5a89c0 <.LCPI0_37>
 1f81370:	vbroadcasti32x4 -0x19d89ca(%rip),%zmm9        # 5a89b0 <.LCPI0_36>
 1f8137a:	vmovdqa64 0x600(%rsp),%zmm5
 1f81382:	mov    0x140(%rsp),%r10
 1f8138a:	kmovq  0x68(%rsp),%k2
 1f81391:	mov    0x90(%rsp),%r8
 1f81399:	kmovq  0xc0(%rsp),%k7
 1f813a3:	mov    0x110(%rsp),%rdi
 1f813ab:	kmovq  0x60(%rsp),%k6
 1f813b2:	mov    0x48(%rsp),%rdx
 1f813b7:	incq   0x128(%rsp)
 1f813bf:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f813c6:	jmp    1f811c2 <node_contexts_window_loop+0x982>
 1f813cb:	nopl   0x0(%rax,%rax,1)
 1f813d0:	mov    0x48(%rsp),%rdx
 1f813d5:	kmovq  %k4,%k7
 1f813da:	xor    %edi,%edi
 1f813dc:	vmovdqa64 %zmm19,%zmm9
 1f813e2:	vpaddb 0x1c0(%rsp),%zmm3,%zmm0
 1f813ea:	kmovq  %k2,%rax
 1f813ef:	kmovq  0x50(%rsp),%k2
 1f813f6:	vpaddb -0x1acee00(%rip),%zmm4,%zmm1        # 4b2600 <abi_test_hex.digits+0xb900>
 1f81400:	kmovq  0x98(%rsp),%k0
 1f8140a:	or     0x58(%rsp),%rax
 1f8140f:	mov    %rdx,0x48(%rsp)
 1f81414:	mov    %rdi,0x110(%rsp)
 1f8141c:	mov    %r8,%rdi
 1f8141f:	and    %r10,%rdi
 1f81422:	mov    %rdi,0x1c0(%rsp)
 1f8142a:	kmovq  %k0,%rcx
 1f8142f:	andn   %rcx,%rax,%rax
 1f81434:	vpcmpltub %zmm13,%zmm0,%k1{%k2}
 1f8143b:	vpcmpltub %zmm20,%zmm1,%k0
 1f81442:	kmovq  %k1,%rsi
 1f81447:	kmovq  %k0,%rdx
 1f8144c:	andn   %r10,%rsi,%rbx
 1f81451:	and    0xb0(%rsp),%rbx
 1f81459:	or     %rdx,%rax
 1f8145c:	and    %rsi,%rdi
 1f8145f:	and    %rax,%rdi
 1f81462:	mov    %rdi,0x98(%rsp)
 1f8146a:	and    %rax,%rbx
 1f8146d:	and    %r8,%rbx
 1f81470:	je     1f8166f <node_contexts_window_loop+0xe2f>
 1f81476:	mov    0x30(%rsp),%rax
 1f8147b:	mov    0x120(%rsp),%r13
 1f81483:	mov    0xa0(%rsp),%r15
 1f8148b:	xor    %r14d,%r14d
 1f8148e:	vmovdqa64 %zmm14,0x680(%rsp)
 1f81496:	kmovq  %k7,0xc0(%rsp)
 1f814a0:	kmovq  %k6,0x60(%rsp)
 1f814a7:	vmovdqa64 %zmm31,0x2c0(%rsp)
 1f814af:	vmovdqa64 %zmm30,0x300(%rsp)
 1f814b7:	vmovdqa64 %zmm8,0x340(%rsp)
 1f814bf:	vmovdqa64 %zmm4,0x380(%rsp)
 1f814c7:	vmovdqa64 %zmm29,0x3c0(%rsp)
 1f814cf:	vmovdqa64 %zmm7,0x400(%rsp)
 1f814d7:	vmovdqa64 %zmm28,0x440(%rsp)
 1f814df:	vmovdqa64 %zmm27,0x480(%rsp)
 1f814e7:	vmovdqa64 %zmm26,0x4c0(%rsp)
 1f814ef:	vmovdqa64 %zmm25,0x500(%rsp)
 1f814f7:	vmovdqa64 %zmm24,0x540(%rsp)
 1f814ff:	vmovdqa64 %zmm23,0x580(%rsp)
 1f81507:	vmovdqa64 %zmm22,0x5c0(%rsp)
 1f8150f:	vmovdqa64 %zmm5,0x600(%rsp)
 1f81517:	mov    (%rax),%rcx
 1f8151a:	mov    0x2c0(%rax),%rax
 1f81521:	mov    %rcx,0x50(%rsp)
 1f81526:	mov    %rax,0x68(%rsp)
 1f8152b:	mov    0x50(%rsp),%rdi
 1f81530:	mov    0x68(%rsp),%rsi
 1f81535:	xor    %r12d,%r12d
 1f81538:	tzcnt  %rbx,%r12
 1f8153d:	lea    (%r15,%r12,1),%edx
 1f81541:	vzeroupper
 1f81544:	call   1f827f0 <node_contexts_converted>
 1f81549:	movzbl %al,%eax
 1f8154c:	inc    %r13
 1f8154f:	shlx   %r12,%rax,%rax
 1f81554:	or     %rax,%r14
 1f81557:	blsr   %rbx,%rbx
 1f8155c:	jne    1f8152b <node_contexts_window_loop+0xceb>
 1f8155e:	vmovdqa64 0x600(%rsp),%zmm5
 1f81566:	vbroadcasti32x4 -0x19d8bc0(%rip),%zmm9        # 5a89b0 <.LCPI0_36>
 1f81570:	vbroadcasti32x4 -0x19d8bba(%rip),%zmm10        # 5a89c0 <.LCPI0_37>
 1f8157a:	vbroadcasti32x4 -0x19d8bb4(%rip),%zmm11        # 5a89d0 <.LCPI0_38>
 1f81584:	vbroadcasti32x4 -0x19d8bae(%rip),%zmm12        # 5a89e0 <.LCPI0_39>
 1f8158e:	vbroadcasti32x4 -0x19d8ba8(%rip),%zmm13        # 5a89f0 <.LCPI0_40>
 1f81598:	vbroadcasti32x4 -0x19d8ba2(%rip),%zmm15        # 5a8a00 <.LCPI0_41>
 1f815a2:	vbroadcasti32x4 -0x19d8b9c(%rip),%zmm16        # 5a8a10 <.LCPI0_42>
 1f815ac:	vbroadcasti32x4 -0x19d8b36(%rip),%zmm17        # 5a8a80 <.LCPI0_49>
 1f815b6:	vbroadcasti32x4 -0x19d8ba0(%rip),%zmm18        # 5a8a20 <.LCPI0_43>
 1f815c0:	vbroadcasti32x4 -0x19d8b9a(%rip),%zmm6        # 5a8a30 <.LCPI0_44>
 1f815ca:	vbroadcasti32x4 -0x19d8b94(%rip),%zmm20        # 5a8a40 <.LCPI0_45>
 1f815d4:	vbroadcasti32x4 -0x19d8b6e(%rip),%zmm21        # 5a8a70 <.LCPI0_48>
 1f815de:	vmovdqa64 0x5c0(%rsp),%zmm22
 1f815e6:	vmovdqa64 0x580(%rsp),%zmm23
 1f815ee:	vmovdqa64 0x540(%rsp),%zmm24
 1f815f6:	vmovdqa64 0x500(%rsp),%zmm25
 1f815fe:	vmovdqa64 0x4c0(%rsp),%zmm26
 1f81606:	vmovdqa64 0x480(%rsp),%zmm27
 1f8160e:	vmovdqa64 0x440(%rsp),%zmm28
 1f81616:	vmovdqa64 0x400(%rsp),%zmm7
 1f8161e:	vmovdqa64 0x3c0(%rsp),%zmm29
 1f81626:	vmovdqa64 0x380(%rsp),%zmm4
 1f8162e:	vmovdqa64 0x340(%rsp),%zmm8
 1f81636:	vmovdqa64 0x300(%rsp),%zmm30
 1f8163e:	vmovdqa64 0x2c0(%rsp),%zmm31
 1f81646:	vmovdqa64 0x680(%rsp),%zmm14
 1f8164e:	or     %r14,0x98(%rsp)
 1f81656:	kmovq  0x60(%rsp),%k6
 1f8165d:	kmovq  0xc0(%rsp),%k7
 1f81667:	mov    %r13,0x120(%rsp)
 1f8166f:	vptestnmb 0x200(%rsp),%zmm10,%k0
 1f81677:	vpsllw $0x7,0x240(%rsp),%zmm0
 1f81680:	vptestmb %zmm15,%zmm31,%k2
 1f81686:	vbroadcasti32x4 -0x19d8bf0(%rip),%zmm3        # 5a8aa0 <.LCPI0_51>
 1f81690:	vmovdqa64 0x640(%rsp),%zmm1
 1f81698:	vbroadcasti32x4 -0x19d8bf2(%rip),%zmm2        # 5a8ab0 <.LCPI0_52>
 1f816a2:	kmovq  0xd8(%rsp),%k5
 1f816ac:	kmovq  0xf0(%rsp),%k4
 1f816b6:	mov    0x38(%rsp),%rdi
 1f816bb:	kmovq  %k0,%r12
 1f816c0:	kandq  %k6,%k2,%k0
 1f816c5:	vpmovb2m %zmm0,%k1
 1f816cb:	vpandq %zmm3,%zmm1,%zmm0
 1f816d1:	kmovq  %k0,%rdx
 1f816d6:	vpcmpltub %zmm17,%zmm30,%k0
 1f816dd:	vbroadcasti32x4 -0x19d8c27(%rip),%zmm17        # 5a8ac0 <.LCPI0_53>
 1f816e7:	korq   %k1,%k0,%k1
 1f816ec:	vptestmb %zmm15,%zmm26,%k0
 1f816f2:	and    %rdx,%rdi
 1f816f5:	mov    0xf8(%rsp),%rdx
 1f816fd:	kmovq  %k0,%rax
 1f81702:	vpcmpeqb %zmm10,%zmm4,%k0
 1f81708:	kmovq  %k0,%rcx
 1f8170d:	vpcmpeqb %zmm18,%zmm4,%k0
 1f81713:	mov    %rax,0x240(%rsp)
 1f8171b:	kmovq  %k0,%rsi
 1f81720:	vpcmpeqb %zmm2,%zmm0,%k0{%k2}
 1f81726:	vptestnmb %zmm16,%zmm1,%k2
 1f8172c:	vmovdqa64 0x6c0(%rsp),%zmm0
 1f81734:	mov    %rcx,0x200(%rsp)
 1f8173c:	vpaddb -0x1acef86(%rip),%zmm7,%zmm1        # 4b27c0 <abi_test_hex.digits+0xbac0>
 1f81746:	korq   %k0,%k2,%k0
 1f8174b:	vpcmpeqb %zmm17,%zmm4,%k3
 1f81751:	kmovq  %k3,%r14
 1f81756:	kandq  %k0,%k3,%k2
 1f8175b:	kmovq  0xd0(%rsp),%k3
 1f81765:	mov    %r14,0x640(%rsp)
 1f8176d:	korq   %k3,%k7,%k0
 1f81772:	vpcmpeqb 0x700(%rsp),%zmm11,%k3{%k5}
 1f8177a:	korq   %k3,%k0,%k0
 1f8177f:	kmovq  0x138(%rsp),%k3
 1f81789:	kmovq  %k0,%r15
 1f8178e:	vpcmpeqb %zmm11,%zmm4,%k0{%k5}
 1f81794:	kmovq  %k0,%rcx
 1f81799:	vptestnmb %zmm0,%zmm0,%k0
 1f8179f:	vpandq 0x180(%rsp),%zmm3,%zmm0
 1f817a7:	vbroadcasti32x4 -0x19d8ce1(%rip),%zmm3        # 5a8ad0 <.LCPI0_54>
 1f817b1:	kmovq  %k0,%rbx
 1f817b6:	and    %rcx,%rbx
 1f817b9:	andn   %r15,%rdx,%rcx
 1f817be:	mov    0x80(%rsp),%rdx
 1f817c6:	and    0xc8(%rsp),%rcx
 1f817ce:	vptestnmb %zmm30,%zmm30,%k0{%k3}
 1f817d4:	kmovq  0x100(%rsp),%k3
 1f817de:	mov    %rcx,0xd0(%rsp)
 1f817e6:	korq   %k4,%k0,%k0
 1f817eb:	kmovq  %k0,%r13
 1f817f0:	kandq  %k3,%k5,%k0
 1f817f5:	kmovq  %k0,%r10
 1f817fa:	vpcmpeqb %zmm20,%zmm4,%k0{%k1}
 1f81800:	vpcmpeqb -0x1acf24a(%rip),%zmm4,%k1        # 4b25c0 <abi_test_hex.digits+0xb8c0>
 1f8180a:	andn   %r10,%rdx,%r15
 1f8180f:	and    0x200(%rsp),%r15
 1f81817:	mov    %r13,%r10
 1f8181a:	mov    0xa0(%rsp),%r13
 1f81822:	korq   %k0,%k1,%k0
 1f81827:	korq   %k5,%k4,%k1
 1f8182c:	kmovq  0xe0(%rsp),%k4
 1f81836:	kmovq  %k0,%r9
 1f8183b:	vpcmpeqb %zmm13,%zmm4,%k0{%k1}
 1f81841:	kmovq  %k1,%r11
 1f81846:	vpcmpeqb %zmm3,%zmm0,%k1
 1f8184c:	kmovq  %k0,%r8
 1f81851:	vptestnmb %zmm14,%zmm14,%k0
 1f81857:	kmovq  %k0,%rax
 1f8185c:	vpcmpeqb %zmm17,%zmm0,%k0
 1f81862:	korq   %k1,%k0,%k1
 1f81867:	and    %rsi,%rax
 1f8186a:	kandq  %k1,%k2,%k1
 1f8186f:	vpcmpeqb -0x1acf179(%rip),%zmm4,%k2{%k5}        # 4b2700 <abi_test_hex.digits+0xba00>
 1f81879:	and    %r11,%rax
 1f8187c:	kmovq  %k2,%rsi
 1f81881:	vptestmb 0x280(%rsp),%zmm10,%k2
 1f81889:	kmovq  %k2,%rdx
 1f8188e:	vpcmpeqb %zmm3,%zmm4,%k2
 1f81894:	and    %r14,%rdx
 1f81897:	kmovq  %k2,%rcx
 1f8189c:	kandq  %k2,%k4,%k4
 1f818a1:	andn   %r12,%rdx,%r11
 1f818a6:	and    %rcx,%r12
 1f818a9:	mov    0x90(%rsp),%rcx
 1f818b1:	mov    0x1c0(%rsp),%rdx
 1f818b9:	kxorq  %k2,%k4,%k5
 1f818be:	kmovq  %k4,0x68(%rsp)
 1f818c5:	kandq  %k0,%k5,%k0
 1f818ca:	and    %rcx,%r9
 1f818cd:	and    %rcx,%rsi
 1f818d0:	and    %r12,%rdx
 1f818d3:	mov    0x240(%rsp),%r12
 1f818db:	and    %rcx,%rax
 1f818de:	and    %rcx,%r8
 1f818e1:	and    %rcx,%rbx
 1f818e4:	and    %rcx,%r10
 1f818e7:	mov    %r9,0xe0(%rsp)
 1f818ef:	kmovq  %k1,%r9
 1f818f4:	mov    %rsi,0xf8(%rsp)
 1f818fc:	kmovq  %k0,%rsi
 1f81901:	vptestmb %zmm11,%zmm31,%k0
 1f81907:	vpcmpeqb %zmm2,%zmm4,%k1
 1f8190d:	mov    %rax,0x700(%rsp)
 1f81915:	andn   %rbx,%rdi,%r14
 1f8191a:	mov    %r8,0xf0(%rsp)
 1f81922:	and    %rdi,%rbx
 1f81925:	mov    %rdx,0x1c0(%rsp)
 1f8192d:	kmovq  %k0,%rax
 1f81932:	vptestmb %zmm12,%zmm26,%k0{%k1}
 1f81938:	kmovq  0xe8(%rsp),%k1
 1f81942:	and    %rcx,%rsi
 1f81945:	and    %rcx,%r9
 1f81948:	andn   %rbx,%rax,%rdi
 1f8194d:	and    %rax,%rbx
 1f81950:	kmovq  %k7,%rax
 1f81955:	mov    %rsi,0x180(%rsp)
 1f8195d:	mov    %r9,0x50(%rsp)
 1f81962:	mov    %rbx,0xd8(%rsp)
 1f8196a:	and    %r12,%r15
 1f8196d:	and    %rcx,%r15
 1f81970:	kmovq  %k0,%rcx
 1f81975:	vptestmb %zmm21,%zmm25,%k0
 1f8197b:	korq   %k3,%k0,%k0
 1f81980:	and    %rcx,0xa8(%rsp)
 1f81988:	korq   %k1,%k0,%k0
 1f8198d:	vpcmpeqb %zmm2,%zmm0,%k1
 1f81993:	kmovq  %k1,%rcx
 1f81998:	kmovq  0x108(%rsp),%k1
 1f819a2:	knotq  %k0,%k0
 1f819a7:	kmovq  %k0,%r8
 1f819ac:	vptestmb %zmm11,%zmm26,%k0
 1f819b2:	and    %rcx,%r8
 1f819b5:	mov    %r8,0x38(%rsp)
 1f819ba:	kmovq  %k1,%rcx
 1f819bf:	vpcmpltub %zmm20,%zmm1,%k1
 1f819c6:	and    %rcx,%rax
 1f819c9:	kmovq  %k0,%rcx
 1f819ce:	kandq  %k4,%k1,%k0
 1f819d3:	kmovq  %k1,0x108(%rsp)
 1f819dd:	kmovq  %k0,%r8
 1f819e2:	and    %r12,%rax
 1f819e5:	mov    0x74(%rsp),%r12d
 1f819ea:	mov    %rcx,0x90(%rsp)
 1f819f2:	or     %r9,%r8
 1f819f5:	mov    %rax,0x6c0(%rsp)
 1f819fd:	mov    %r15,%rax
 1f81a00:	and    %rcx,%rax
 1f81a03:	or     %rsi,%r8
 1f81a06:	mov    %rax,0xe8(%rsp)
 1f81a0e:	and    %r8,%r11
 1f81a11:	cmpb   $0x0,0x2f(%rsp)
 1f81a16:	mov    %r8,0x100(%rsp)
 1f81a1e:	mov    %r11,0x240(%rsp)
 1f81a26:	jne    1f81f36 <node_contexts_window_loop+0x16f6>
 1f81a2c:	mov    0x78(%rsp),%rsi
 1f81a31:	mov    0x88(%rsp),%rax
 1f81a39:	mov    0x6c0(%rsp),%rdx
 1f81a41:	mov    0xd0(%rsp),%rbx
 1f81a49:	mov    0x58(%rsp),%r9
 1f81a4e:	mov    0xf8(%rsp),%r8
 1f81a56:	or     %rax,%r10
 1f81a59:	mov    0xf0(%rsp),%rax
 1f81a61:	or     %rdi,%r15
 1f81a64:	vmovdqa64 %zmm23,%zmm0
 1f81a6a:	vpermt2b %zmm27,%zmm29,%zmm0
 1f81a70:	kmovq  0x168(%rsp),%k7
 1f81a7a:	vptestmb %zmm8,%zmm8,%k3
 1f81a80:	or     0xe8(%rsp),%rbx
 1f81a88:	mov    %r10,0x280(%rsp)
 1f81a90:	mov    %r14,%r10
 1f81a93:	vmovdqu8 %zmm10,%zmm2{%k3}{z}
 1f81a99:	and    %rdx,0x38(%rsp)
 1f81a9e:	mov    0x110(%rsp),%rdx
 1f81aa6:	vpcmpeqb -0x1acf870(%rip),%zmm0,%k0{%k7}        # 4b2240 <abi_test_hex.digits+0xb540>
 1f81ab0:	or     %rax,%rbx
 1f81ab3:	or     %r14,%rax
 1f81ab6:	or     0xe0(%rsp),%rax
 1f81abe:	andn   %r9,%rdx,%rcx
 1f81ac3:	andn   0x40(%rsp),%rcx,%r11
 1f81aca:	mov    %r14,%rcx
 1f81acd:	or     %r8,%rcx
 1f81ad0:	mov    0xd8(%rsp),%r14
 1f81ad8:	or     %rdi,%rcx
 1f81adb:	or     %rbx,%rcx
 1f81ade:	mov    0x1c0(%rsp),%rbx
 1f81ae6:	or     %r14,%r15
 1f81ae9:	and    %r11,%r9
 1f81aec:	or     %rax,%r15
 1f81aef:	or     %rbx,%r8
 1f81af2:	or     %r14,%rbx
 1f81af5:	or     %rdx,%r15
 1f81af8:	or     %rax,%rbx
 1f81afb:	mov    0x700(%rsp),%rax
 1f81b03:	kmovq  %r15,%k2
 1f81b08:	or     %r14,%r8
 1f81b0b:	mov    $0x0,%r15d
 1f81b11:	or     %r10,%rax
 1f81b14:	or     %rdi,%rax
 1f81b17:	mov    0x98(%rsp),%rdi
 1f81b1f:	or     %rax,%r8
 1f81b22:	mov    %r11,%rax
 1f81b25:	or     %rdx,%r8
 1f81b28:	kmovq  %k0,%rdx
 1f81b2d:	or     %rdi,%rcx
 1f81b30:	or     %rdi,%rbx
 1f81b33:	or     %rdi,%r8
 1f81b36:	mov    0xa8(%rsp),%rdi
 1f81b3e:	kmovq  %rcx,%k4
 1f81b43:	kmovq  %rbx,%k1
 1f81b48:	kmovq  %k5,%rcx
 1f81b4d:	kmovq  %r8,%k3
 1f81b52:	xor    0x180(%rsp),%rcx
 1f81b5a:	vmovdqu8 -0x1acf964(%rip),%zmm1{%k4}{z}        # 4b2200 <abi_test_hex.digits+0xb500>
 1f81b64:	kmovq  %r9,%k4
 1f81b69:	kmovq  %rdi,%k5
 1f81b6e:	kmovq  %k6,%rdi
 1f81b73:	andn   %r11,%rdi,%rdi
 1f81b78:	kmovq  %rdi,%k6
 1f81b7d:	mov    0x240(%rsp),%rdi
 1f81b85:	vporq  %zmm15,%zmm1,%zmm0
 1f81b8b:	vmovdqu8 %zmm0,%zmm1{%k2}
 1f81b91:	vporq  %zmm20,%zmm1,%zmm0
 1f81b97:	vmovdqu8 %zmm0,%zmm1{%k1}
 1f81b9d:	vpord  -0x19d03df(%rip){1to16},%zmm1,%zmm0        # 5b17c8 <.LCPI0_55>
 1f81ba7:	kmovq  %rax,%k1
 1f81bac:	vmovdqu8 %zmm0,%zmm1{%k3}
 1f81bb2:	vmovdqu8 -0x1acf37c(%rip),%zmm1{%k5}        # 4b2840 <abi_test_hex.digits+0xbb40>
 1f81bbc:	vmovdqu8 -0x1acf346(%rip),%zmm1{%k1}        # 4b2880 <abi_test_hex.digits+0xbb80>
 1f81bc6:	kmovq  %rdi,%k1
 1f81bcb:	mov    0x118(%rsp),%rdi
 1f81bd3:	vmovdqu8 -0x1acf31d(%rip),%zmm1{%k1}        # 4b28c0 <abi_test_hex.digits+0xbbc0>
 1f81bdd:	kmovq  0x130(%rsp),%k1
 1f81be7:	vmovdqa64 %zmm1,%zmm0
 1f81bed:	vpaddb %zmm20,%zmm1,%zmm0{%k6}
 1f81bf3:	vpaddb %zmm15,%zmm0,%zmm0{%k4}
 1f81bf9:	vpermi2b %zmm28,%zmm0,%zmm29{%k7}{z}
 1f81bff:	vmovdqu8 0x780(%rsp),%zmm29{%k1}
 1f81c07:	vpaddw %zmm29,%zmm29,%zmm3
 1f81c0d:	vporq  %zmm2,%zmm3,%zmm2
 1f81c13:	vpermb 0x80(%rdi),%zmm2,%zmm2
 1f81c1a:	mov    0x100(%rsp),%rdi
 1f81c22:	vpandd -0x19d0460(%rip){1to16},%zmm2,%zmm3        # 5b17cc <.LCPI0_56>
 1f81c2c:	or     %rdx,%rdi
 1f81c2f:	not    %rdi
 1f81c32:	kmovq  %rdi,%k1
 1f81c37:	mov    0x30(%rsp),%rdi
 1f81c3c:	vmovdqu8 %zmm3,%zmm3{%k1}{z}
 1f81c42:	mov    0xba8(%rdi),%rdx
 1f81c49:	vmovdqu64 %zmm1,(%rdx,%r13,1)
 1f81c50:	mov    0xbb8(%rdi),%rdx
 1f81c57:	mov    %r12d,%edi
 1f81c5a:	sub    %r13d,%edi
 1f81c5d:	vmovdqu64 %zmm3,(%rdx,%r13,1)
 1f81c64:	mov    $0xffffffffffffffff,%rdx
 1f81c6b:	jbe    1f81c84 <node_contexts_window_loop+0x1444>
 1f81c6d:	lea    0x40(%r13),%edx
 1f81c71:	cmp    %edx,%r12d
 1f81c74:	mov    $0xffffffffffffffff,%rdx
 1f81c7b:	shlx   %rdi,%rdx,%rdx
 1f81c80:	cmovae %r15,%rdx
 1f81c84:	mov    0x640(%rsp),%r10
 1f81c8c:	kmovq  0x108(%rsp),%k0
 1f81c96:	mov    0x200(%rsp),%r9
 1f81c9e:	kmovq  0x68(%rsp),%k4
 1f81ca5:	xor    %r10,0x50(%rsp)
 1f81caa:	mov    0x90(%rsp),%r10
 1f81cb2:	kmovq  %k0,%rdi
 1f81cb7:	vpcmpeqb %zmm18,%zmm7,%k0
 1f81cbd:	and    %r9,0x280(%rsp)
 1f81cc5:	and    0x38(%rsp),%r10
 1f81cca:	kmovq  %k0,%r8
 1f81ccf:	vpmovb2m %zmm2,%k0
 1f81cd5:	and    %rdi,%rcx
 1f81cd8:	kmovq  %k0,%rdi
 1f81cdd:	and    %r8,0x180(%rsp)
 1f81ce5:	andn   %rdi,%r10,%rdi
 1f81cea:	mov    %rdi,%r8
 1f81ced:	or     %r9,%r8
 1f81cf0:	andn   0xb0(%rsp),%r8,%rbx
 1f81cfa:	je     1f809a0 <node_contexts_window_loop+0x160>
 1f81d00:	xor    %r8d,%r8d
 1f81d03:	tzcnt  %rbx,%r8
 1f81d08:	mov    $0xffffffffffffffff,%r14
 1f81d0f:	mov    %r12d,%r11d
 1f81d12:	lea    0x0(%r13,%r8,1),%r9d
 1f81d17:	sub    0x651b8(%rsi,%r9,4),%r9d
 1f81d1f:	lea    0x1(%r9),%r9d
 1f81d23:	cmovb  %r15d,%r9d
 1f81d27:	mov    %r9d,%r10d
 1f81d2a:	sub    %r13d,%r10d
 1f81d2d:	cmp    %r12d,%r9d
 1f81d30:	cmovb  %r9d,%r11d
 1f81d34:	cmp    %r13d,%r9d
 1f81d37:	shlx   %r10,%r14,%r9
 1f81d3c:	movabs $0x7fffffffffffffff,%r14
 1f81d46:	cmovbe %r14,%r9
 1f81d4a:	cmovb  %r11d,%r12d
 1f81d4e:	bzhi   %r8,%r9,%r8
 1f81d53:	or     %r8,%rdx
 1f81d56:	blsr   %rbx,%rbx
 1f81d5b:	jne    1f81d00 <node_contexts_window_loop+0x14c0>
 1f81d5d:	jmp    1f809a0 <node_contexts_window_loop+0x160>
 1f81d62:	mov    0x118(%rsp),%rcx
 1f81d6a:	kmovq  %k5,%r8
 1f81d6f:	mov    %r14,0x58(%rsp)
 1f81d74:	test   %r8,%r8
 1f81d77:	je     1f81e06 <node_contexts_window_loop+0x15c6>
 1f81d7d:	mov    0x30(%rsp),%rdi
 1f81d82:	mov    %r8,%r10
 1f81d85:	mov    0xba8(%rdi),%rdi
 1f81d8c:	mov    %rdi,0x1c0(%rsp)
 1f81d94:	xor    %r9d,%r9d
 1f81d97:	tzcnt  %r10,%r9
 1f81d9c:	mov    0x1c0(%rsp),%rdi
 1f81da4:	lea    0x0(%r13,%r9,1),%ebx
 1f81da9:	movzwl 0x6f654(%rsi,%rbx,2),%r14d
 1f81db2:	add    %ebx,%r14d
 1f81db5:	movzwl 0x6b554(%rsi,%r14,2),%r12d
 1f81dbe:	movzbl 0x2c(%rsi,%r14,1),%ebx
 1f81dc4:	movzbl (%rdi,%r14,1),%edi
 1f81dc9:	sub    %r12d,%r14d
 1f81dcc:	and    $0x7f,%ebx
 1f81dcf:	testb  $0x7f,0x2c(%rsi,%r14,1)
 1f81dd5:	movzbl (%rcx,%rbx,1),%ebx
 1f81dd9:	setne  %r14b
 1f81ddd:	mov    %bl,0x740(%rsp,%r9,1)
 1f81de5:	add    %r14b,%r14b
 1f81de8:	or     $0x14,%r14b
 1f81dec:	cmp    $0x14,%dil
 1f81df0:	movzbl %r14b,%ebx
 1f81df4:	cmovne %edi,%ebx
 1f81df7:	blsr   %r10,%r10
 1f81dfc:	mov    %bl,0x780(%rsp,%r9,1)
 1f81e04:	jne    1f81d94 <node_contexts_window_loop+0x1554>
 1f81e06:	mov    0x58(%rsp),%rcx
 1f81e0b:	kmovq  %k2,%r9
 1f81e10:	vmovdqa64 %zmm18,%zmm16
 1f81e16:	mov    %r9,%r10
 1f81e19:	test   %r9,%r9
 1f81e1c:	je     1f81e8f <node_contexts_window_loop+0x164f>
 1f81e1e:	xor    %edi,%edi
 1f81e20:	tzcnt  %r10,%rdi
 1f81e25:	lea    0x0(%r13,%rdi,1),%ebx
 1f81e2a:	movzwl 0x6b554(%rsi,%rbx,2),%r14d
 1f81e33:	sub    %r14d,%ebx
 1f81e36:	movzbl 0x2c(%rsi,%rbx,1),%r14d
 1f81e3c:	and    $0x7f,%r14b
 1f81e40:	blsr   %r10,%r10
 1f81e45:	mov    %r14b,0x7c0(%rsp,%rdi,1)
 1f81e4d:	movzbl (%rcx,%rbx,1),%r14d
 1f81e52:	mov    %r14b,0x800(%rsp,%rdi,1)
 1f81e5a:	movzbl (%rax,%rbx,1),%r14d
 1f81e5f:	mov    %r14b,0x840(%rsp,%rdi,1)
 1f81e67:	movzbl (%rdx,%rbx,1),%r14d
 1f81e6c:	mov    %r14b,0x880(%rsp,%rdi,1)
 1f81e74:	movzbl (%r11,%rbx,1),%r14d
 1f81e79:	mov    %r14b,0x8c0(%rsp,%rdi,1)
 1f81e81:	movzbl (%r15,%rbx,1),%ebx
 1f81e86:	mov    %bl,0x900(%rsp,%rdi,1)
 1f81e8d:	jne    1f81e1e <node_contexts_window_loop+0x15de>
 1f81e8f:	vmovdqu8 0x800(%rsp),%zmm6{%k2}
 1f81e97:	vmovdqa64 0x200(%rsp),%zmm8
 1f81e9f:	vmovdqa64 0x180(%rsp),%zmm4
 1f81ea7:	kmovq  0x130(%rsp),%k3
 1f81eb1:	vmovdqu8 0x7c0(%rsp),%zmm7{%k2}
 1f81eb9:	vmovdqu8 0x880(%rsp),%zmm3{%k2}
 1f81ec1:	vmovdqu8 0x8c0(%rsp),%zmm31{%k2}
 1f81ec9:	popcnt %r8,%rax
 1f81ece:	add    0xb8(%rsp),%rax
 1f81ed6:	or     %r9,0x38(%rsp)
 1f81edb:	popcnt %r9,%rcx
 1f81ee0:	add    %rcx,%rax
 1f81ee3:	mov    %rax,0xb8(%rsp)
 1f81eeb:	vmovdqa64 %zmm6,0x1c0(%rsp)
 1f81ef3:	vmovdqa64 0x640(%rsp),%zmm6
 1f81efb:	vmovdqu8 0x740(%rsp),%zmm4{%k3}
 1f81f03:	vmovdqu8 0x840(%rsp),%zmm8{%k2}
 1f81f0b:	vmovdqu8 0x900(%rsp),%zmm6{%k2}
 1f81f13:	vmovdqa64 %zmm4,0x180(%rsp)
 1f81f1b:	vmovdqa64 %zmm8,0x200(%rsp)
 1f81f23:	vmovdqa64 %zmm6,0x640(%rsp)
 1f81f2b:	vmovdqa64 %zmm17,%zmm6
 1f81f31:	jmp    1f80e14 <node_contexts_window_loop+0x5d4>
 1f81f36:	cmpq   $0x0,0x40(%rsp)
 1f81f3c:	mov    0x78(%rsp),%rsi
 1f81f41:	mov    0x30(%rsp),%rax
 1f81f46:	je     1f81f78 <node_contexts_window_loop+0x1738>
 1f81f48:	mov    %r14,0x80(%rsp)
 1f81f50:	mov    %rax,%r14
 1f81f53:	mov    (%rax),%rax
 1f81f56:	mov    0x8(%rax),%rax
 1f81f5a:	cmpb   $0x1,0x14a(%rax)
 1f81f61:	je     1f81f8e <node_contexts_window_loop+0x174e>
 1f81f63:	mov    0x88(%rsp),%rax
 1f81f6b:	mov    0x80(%rsp),%r14
 1f81f73:	jmp    1f81a39 <node_contexts_window_loop+0x11f9>
 1f81f78:	mov    0x88(%rsp),%rax
 1f81f80:	movq   $0x0,0x40(%rsp)
 1f81f89:	jmp    1f81a39 <node_contexts_window_loop+0x11f9>
 1f81f8e:	mov    0x2c0(%r14),%rbx
 1f81f95:	mov    0x40(%rsp),%r13
 1f81f9a:	xor    %r12d,%r12d
 1f81f9d:	mov    %rax,0xc8(%rsp)
 1f81fa5:	mov    %rdi,0x2c0(%rsp)
 1f81fad:	kmovq  %k5,0x300(%rsp)
 1f81fb7:	mov    %r10,0x280(%rsp)
 1f81fbf:	kmovq  %k6,0x60(%rsp)
 1f81fc6:	vmovdqa64 %zmm8,0x340(%rsp)
 1f81fce:	vmovdqa64 %zmm4,0x380(%rsp)
 1f81fd6:	vmovdqa64 %zmm29,0x3c0(%rsp)
 1f81fde:	vmovdqa64 %zmm7,0x400(%rsp)
 1f81fe6:	vmovdqa64 %zmm28,0x440(%rsp)
 1f81fee:	vmovdqa64 %zmm27,0x480(%rsp)
 1f81ff6:	vmovdqa64 %zmm26,0x4c0(%rsp)
 1f81ffe:	vmovdqa64 %zmm25,0x500(%rsp)
 1f82006:	vmovdqa64 %zmm24,0x540(%rsp)
 1f8200e:	vmovdqa64 %zmm23,0x580(%rsp)
 1f82016:	vmovdqa64 %zmm22,0x5c0(%rsp)
 1f8201e:	vmovdqa64 %zmm5,0x600(%rsp)
 1f82026:	jmp    1f8204b <node_contexts_window_loop+0x180b>
 1f82028:	lea    -0x1ab949a(%rip),%rdx        # 4c8b95 <check_lower_segment_override.segments>
 1f8202f:	xor    %ecx,%ecx
 1f82031:	testb  $0x3,-0x110(%rax,%rdx,1)
 1f82039:	setne  %cl
 1f8203c:	shlx   %r14,%rcx,%rax
 1f82041:	or     %rax,%r12
 1f82044:	blsr   %r13,%r13
 1f82049:	je     1f820a5 <node_contexts_window_loop+0x1865>
 1f8204b:	mov    0xa0(%rsp),%rax
 1f82053:	mov    0x78(%rsp),%rcx
 1f82058:	xor    %r14d,%r14d
 1f8205b:	tzcnt  %r13,%r14
 1f82060:	mov    0xc8(%rsp),%rdi
 1f82068:	add    %r14d,%eax
 1f8206b:	movzwl 0x6b554(%rcx,%rax,2),%ecx
 1f82073:	sub    %ecx,%eax
 1f82075:	shl    $0x6,%rax
 1f82079:	mov    (%rbx,%rax,1),%esi
 1f8207c:	vzeroupper
 1f8207f:	call   1f2a5a0 <type_object_qualifiers_slow>
 1f82084:	and    $0xffffff,%eax
 1f82089:	lea    -0x110(%rax),%ecx
 1f8208f:	cmp    $0x2,%ecx
 1f82092:	jbe    1f82028 <node_contexts_window_loop+0x17e8>
 1f82094:	xor    %ecx,%ecx
 1f82096:	shlx   %r14,%rcx,%rax
 1f8209b:	or     %rax,%r12
 1f8209e:	blsr   %r13,%r13
 1f820a3:	jne    1f8204b <node_contexts_window_loop+0x180b>
 1f820a5:	mov    0x40(%rsp),%rax
 1f820aa:	vmovdqa64 0x600(%rsp),%zmm5
 1f820b2:	vbroadcasti32x4 -0x19d970c(%rip),%zmm9        # 5a89b0 <.LCPI0_36>
 1f820bc:	vbroadcasti32x4 -0x19d9706(%rip),%zmm10        # 5a89c0 <.LCPI0_37>
 1f820c6:	vbroadcasti32x4 -0x19d9700(%rip),%zmm11        # 5a89d0 <.LCPI0_38>
 1f820d0:	vbroadcasti32x4 -0x19d96fa(%rip),%zmm12        # 5a89e0 <.LCPI0_39>
 1f820da:	vbroadcasti32x4 -0x19d96f4(%rip),%zmm13        # 5a89f0 <.LCPI0_40>
 1f820e4:	vbroadcasti32x4 -0x19d96ee(%rip),%zmm15        # 5a8a00 <.LCPI0_41>
 1f820ee:	vbroadcasti32x4 -0x19d96e8(%rip),%zmm16        # 5a8a10 <.LCPI0_42>
 1f820f8:	vbroadcasti32x4 -0x19d96e2(%rip),%zmm18        # 5a8a20 <.LCPI0_43>
 1f82102:	vbroadcasti32x4 -0x19d96dc(%rip),%zmm6        # 5a8a30 <.LCPI0_44>
 1f8210c:	vbroadcasti32x4 -0x19d96d6(%rip),%zmm20        # 5a8a40 <.LCPI0_45>
 1f82116:	vbroadcasti32x4 -0x19d96b0(%rip),%zmm21        # 5a8a70 <.LCPI0_48>
 1f82120:	vmovdqa64 0x5c0(%rsp),%zmm22
 1f82128:	vmovdqa64 0x580(%rsp),%zmm23
 1f82130:	vmovdqa64 0x540(%rsp),%zmm24
 1f82138:	vmovdqa64 0x500(%rsp),%zmm25
 1f82140:	vmovdqa64 0x4c0(%rsp),%zmm26
 1f82148:	vmovdqa64 0x480(%rsp),%zmm27
 1f82150:	vmovdqa64 0x440(%rsp),%zmm28
 1f82158:	vmovdqa64 0x400(%rsp),%zmm7
 1f82160:	vmovdqa64 0x3c0(%rsp),%zmm29
 1f82168:	vmovdqa64 0x380(%rsp),%zmm4
 1f82170:	vmovdqa64 0x340(%rsp),%zmm8
 1f82178:	mov    0x78(%rsp),%rsi
 1f8217d:	mov    0xa0(%rsp),%r13
 1f82185:	kmovq  0x60(%rsp),%k6
 1f8218c:	mov    0x280(%rsp),%r10
 1f82194:	kmovq  0x300(%rsp),%k5
 1f8219e:	mov    0x80(%rsp),%r14
 1f821a6:	mov    0x2c0(%rsp),%rdi
 1f821ae:	andn   %rax,%r12,%rax
 1f821b3:	mov    0x74(%rsp),%r12d
 1f821b8:	mov    %rax,0x40(%rsp)
 1f821bd:	jmp    1f81a31 <node_contexts_window_loop+0x11f1>
 1f821c2:	vmovq  0xb8(%rsp),%xmm0
 1f821cb:	vmovq  %rax,%xmm1
 1f821d0:	mov    0x148(%rsp),%rcx
 1f821d8:	mov    0x48(%rsp),%rax
 1f821dd:	mov    0x128(%rsp),%rdx
 1f821e5:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f821e9:	vmovq  %rdx,%xmm1
 1f821ee:	vmovq  %rax,%xmm2
 1f821f3:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f821f7:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f821fd:	vinserti64x4 $0x1,%ymm5,%zmm0,%zmm0
 1f82204:	vpaddq (%rcx),%zmm0,%zmm0
 1f8220a:	vmovdqu64 %zmm0,(%rcx)
 1f82210:	lea    -0x28(%rbp),%rsp
 1f82214:	pop    %rbx
 1f82215:	pop    %r12
 1f82217:	pop    %r13
 1f82219:	pop    %r14
 1f8221b:	pop    %r15
 1f8221d:	pop    %rbp
 1f8221e:	vzeroupper
 1f82221:	ret

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .iplt:
