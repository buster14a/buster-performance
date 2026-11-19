
compiler:     file format elf64-x86-64


Disassembly of section .text.buster_start:

Disassembly of section .text.buster_checker:

Disassembly of section .text:

0000000001f80800 <node_contexts_window_loop>:
 1f80800:	push   %rbp
 1f80801:	mov    %rsp,%rbp
 1f80804:	push   %r15
 1f80806:	push   %r14
 1f80808:	push   %r13
 1f8080a:	push   %r12
 1f8080c:	push   %rbx
 1f8080d:	and    $0xffffffffffffffc0,%rsp
 1f80811:	sub    $0x880,%rsp
 1f80818:	mov    (%rdi),%rax
 1f8081b:	mov    0xb38(%rdi),%rbx
 1f80822:	add    $0x3f,%edx
 1f80825:	vpxor  %xmm0,%xmm0,%xmm0
 1f80829:	mov    0x8(%rax),%rax
 1f8082d:	movzbl 0x14a(%rax),%eax
 1f80834:	vmovdqa64 %zmm0,0x7c0(%rsp)
 1f8083c:	vmovdqa64 %zmm0,0x780(%rsp)
 1f80844:	vmovdqa64 %zmm0,0x740(%rsp)
 1f8084c:	vmovdqa64 %zmm0,0x700(%rsp)
 1f80854:	vmovdqa64 %zmm0,0x6c0(%rsp)
 1f8085c:	vmovdqa64 %zmm0,0x680(%rsp)
 1f80864:	vmovdqa64 %zmm0,0x640(%rsp)
 1f8086c:	mov    %al,0x27(%rsp)
 1f80870:	cmp    $0x40,%edx
 1f80873:	jae    1f80887 <node_contexts_window_loop+0x87>
 1f80875:	vpxor  %xmm0,%xmm0,%xmm0
 1f80879:	vpxor  %xmm8,%xmm8,%xmm8
 1f8087e:	xor    %edx,%edx
 1f80880:	xor    %eax,%eax
 1f80882:	jmp    1f81fc4 <node_contexts_window_loop+0x17c4>
 1f80887:	vbroadcasti32x4 -0x19dc1e1(%rip),%zmm6        # 5a46b0 <.LCPI0_33>
 1f80891:	vbroadcasti32x4 -0x19dc1db(%rip),%zmm13        # 5a46c0 <.LCPI0_34>
 1f8089b:	vbroadcasti32x4 -0x19dc1d5(%rip),%zmm14        # 5a46d0 <.LCPI0_35>
 1f808a5:	vbroadcasti32x4 -0x19dc1cf(%rip),%zmm15        # 5a46e0 <.LCPI0_36>
 1f808af:	vbroadcasti32x4 -0x19dc1c9(%rip),%zmm17        # 5a46f0 <.LCPI0_37>
 1f808b9:	vbroadcasti32x4 -0x19dc1c3(%rip),%zmm19        # 5a4700 <.LCPI0_38>
 1f808c3:	vbroadcasti32x4 -0x19dc1bd(%rip),%zmm7        # 5a4710 <.LCPI0_39>
 1f808cd:	vbroadcasti32x4 -0x19dc1b7(%rip),%zmm21        # 5a4720 <.LCPI0_40>
 1f808d7:	vbroadcasti32x4 -0x19dc1b1(%rip),%zmm5        # 5a4730 <.LCPI0_41>
 1f808e1:	vbroadcasti32x4 -0x19dc1ab(%rip),%zmm23        # 5a4740 <.LCPI0_42>
 1f808eb:	vbroadcasti32x4 -0x19dc1a5(%rip),%zmm24        # 5a4750 <.LCPI0_43>
 1f808f5:	shr    $0x6,%edx
 1f808f8:	mov    $0xffffffff,%r15d
 1f808fe:	mov    %rcx,0x138(%rsp)
 1f80906:	vpxor  %xmm8,%xmm8,%xmm8
 1f8090b:	vpxord %xmm30,%xmm30,%xmm30
 1f80911:	movq   $0x0,0x38(%rsp)
 1f8091a:	xor    %r13d,%r13d
 1f8091d:	movq   $0x0,0x98(%rsp)
 1f80929:	movq   $0x0,0x108(%rsp)
 1f80935:	vpxord %xmm25,%xmm25,%xmm25
 1f8093b:	vpxord %xmm31,%xmm31,%xmm31
 1f80941:	mov    %rdi,0x30(%rsp)
 1f80946:	mov    %rsi,0xa0(%rsp)
 1f8094e:	mov    %rbx,0x110(%rsp)
 1f80956:	jmp    1f80ab2 <node_contexts_window_loop+0x2b2>
 1f8095b:	nopl   0x0(%rax,%rax,1)
 1f80960:	kmovq  0x158(%rsp),%k1
 1f8096a:	vpcmpeqb %zmm5,%zmm12,%k0
 1f80970:	vpcmpeqb -0x1ace5fa(%rip),%zmm12,%k2        # 4b2380 <abi_test_hex.digits+0xb680>
 1f8097a:	vpaddb -0x1ace304(%rip),%zmm12,%zmm2        # 4b2680 <abi_test_hex.digits+0xb980>
 1f80984:	vpandq %zmm24,%zmm27,%zmm3
 1f8098a:	mov    0x1c0(%rsp),%rdi
 1f80992:	vpcmpeqb %zmm23,%zmm12,%k3
 1f80998:	vpmovb2m %zmm28,%k4
 1f8099e:	mov    0x160(%rsp),%rax
 1f809a6:	mov    0x80(%rsp),%r8
 1f809ae:	mov    0x170(%rsp),%r9
 1f809b6:	mov    0xe0(%rsp),%r13
 1f809be:	vmovdqa64 %zmm26,%zmm30
 1f809c4:	vmovdqa64 %zmm1,%zmm31
 1f809ca:	vpcmpeqb %zmm6,%zmm29,%k3{%k3}
 1f809d0:	korq   %k1,%k0,%k0
 1f809d5:	kmovq  0x168(%rsp),%k1
 1f809df:	andn   %rdx,%rdi,%rdx
 1f809e4:	mov    0x30(%rsp),%rdi
 1f809e9:	vmovq  %rax,%xmm4
 1f809ee:	andn   %rax,%r8,%rax
 1f809f3:	vptestnmb %zmm3,%zmm3,%k2{%k2}
 1f809f9:	kandq  %k1,%k0,%k0
 1f809fe:	vpcmpltub -0x1ace289(%rip),%zmm2,%k1        # 4b2780 <abi_test_hex.digits+0xba80>
 1f80a09:	mov    0xbd0(%rdi),%r11
 1f80a10:	vmovq  %r8,%xmm2
 1f80a15:	vpunpcklqdq %xmm2,%xmm4,%xmm2
 1f80a19:	vpopcntq %xmm2,%xmm2
 1f80a1f:	vpaddq %xmm2,%xmm8,%xmm8
 1f80a23:	korq   %k2,%k1,%k1
 1f80a28:	korq   %k4,%k1,%k1
 1f80a2d:	korq   %k3,%k1,%k1
 1f80a32:	korq   %k0,%k1,%k1
 1f80a37:	kandq  %k5,%k0,%k0
 1f80a3c:	kmovq  %k1,%r10
 1f80a41:	vptestnmb %zmm0,%zmm0,%k1
 1f80a47:	or     %rdx,%r10
 1f80a4a:	or     0x28(%rsp),%r10
 1f80a4f:	mov    0x90(%rsp),%rdx
 1f80a57:	kmovq  %k1,%r8
 1f80a5c:	vpcmpgtb %zmm28,%zmm9,%k1{%k5}
 1f80a62:	or     %rax,%r10
 1f80a65:	andn   %rdx,%rcx,%rax
 1f80a6a:	and    %rbx,%rax
 1f80a6d:	and    %rdx,%r10
 1f80a70:	mov    %r9d,%edx
 1f80a73:	shl    $0x6,%rdx
 1f80a77:	mov    0x110(%rsp),%rbx
 1f80a7f:	and    %rax,%r8
 1f80a82:	mov    %rax,(%r11,%rdx,1)
 1f80a86:	mov    %r8,0x8(%r11,%rdx,1)
 1f80a8b:	mov    %r10,0x10(%r11,%rdx,1)
 1f80a90:	kmovq  %k0,0x18(%r11,%rdx,1)
 1f80a97:	kmovq  %k1,0x20(%r11,%rdx,1)
 1f80a9e:	mov    0x178(%rsp),%rdx
 1f80aa6:	dec    %rdx
 1f80aa9:	test   %r9d,%r9d
 1f80aac:	je     1f81f9d <node_contexts_window_loop+0x179d>
 1f80ab2:	lea    -0x1(%rdx),%r8d
 1f80ab6:	vpbroadcastq -0x19d6078(%rip),%zmm1        # 5aaa48 <.LCPI0_0>
 1f80ac0:	mov    %rdx,0x178(%rsp)
 1f80ac8:	mov    0xba0(%rdi),%rdx
 1f80acf:	vmovdqa64 %zmm5,%zmm20
 1f80ad5:	vmovdqa64 %zmm25,%zmm0
 1f80adb:	vmovdqu64 (%rbx),%zmm25
 1f80ae1:	vmovdqa64 -0x1acea6b(%rip),%zmm10        # 4b2080 <abi_test_hex.digits+0xb380>
 1f80aeb:	vmovdqa64 %zmm6,%zmm18
 1f80af1:	vmovdqa64 -0x1ace9fb(%rip),%zmm11        # 4b2100 <abi_test_hex.digits+0xb400>
 1f80afb:	mov    0xb80(%rdi),%rax
 1f80b02:	vmovdqa64 %zmm21,%zmm16
 1f80b08:	vmovdqa64 %zmm7,%zmm21
 1f80b0e:	mov    0xb88(%rdi),%rcx
 1f80b15:	mov    0xb90(%rdi),%r14
 1f80b1c:	vmovdqa64 %zmm24,%zmm9
 1f80b22:	mov    %r15d,0xec(%rsp)
 1f80b2a:	mov    %r8,%r12
 1f80b2d:	shl    $0x6,%r12
 1f80b31:	test   %r8d,%r8d
 1f80b34:	mov    %r8,0x170(%rsp)
 1f80b3c:	lea    -0x40(%r12),%r10d
 1f80b41:	vpandq 0x2c(%rsi,%r12,1),%zmm1,%zmm26
 1f80b4c:	mov    %r12,0x78(%rsp)
 1f80b51:	cmove  %r8d,%r10d
 1f80b55:	shl    $0x7,%r8
 1f80b59:	vmovdqu64 0x6b554(%rsi,%r8,1),%zmm1
 1f80b64:	vmovdqu64 0x6b594(%rsi,%r8,1),%zmm2
 1f80b6f:	vmovdqu64 0x6d5d4(%rsi,%r8,1),%zmm3
 1f80b7a:	vmovdqu64 0x6d614(%rsi,%r8,1),%zmm4
 1f80b85:	vmovdqu64 (%rdx,%r12,1),%zmm27
 1f80b8c:	vmovdqu64 (%rax,%r12,1),%zmm12
 1f80b93:	vmovdqu64 (%rcx,%r12,1),%zmm24
 1f80b9a:	vmovdqu64 (%r14,%r12,1),%zmm29
 1f80ba1:	vmovdqu64 (%rdx,%r10,1),%zmm22
 1f80ba8:	vpermt2b 0x40(%rbx),%zmm26,%zmm25
 1f80baf:	vpmovuswb %zmm1,%ymm1
 1f80bb5:	vpmovuswb %zmm2,%ymm2
 1f80bbb:	vmovdqa64 %zmm24,0x580(%rsp)
 1f80bc3:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm5
 1f80bca:	vpandq %zmm6,%zmm27,%zmm1
 1f80bd0:	vmovdqu64 0x6f694(%rsi,%r8,1),%zmm2
 1f80bdb:	vptestmb %zmm1,%zmm1,%k5
 1f80be1:	vmovdqu64 0x6f654(%rsi,%r8,1),%zmm1
 1f80bec:	mov    0xb98(%rdi),%r8
 1f80bf3:	vptestmb %zmm5,%zmm5,%k0
 1f80bf9:	kandq  %k0,%k5,%k2
 1f80bfe:	kmovq  %k0,%r9
 1f80c03:	vpcmpnltub %zmm5,%zmm11,%k0
 1f80c0a:	kmovq  %k0,%r11
 1f80c0f:	vpcmpltub %zmm5,%zmm11,%k2{%k2}
 1f80c16:	and    %r9,%r11
 1f80c19:	mov    %r11,0x70(%rsp)
 1f80c1e:	vmovdqu64 (%r8,%r12,1),%zmm28
 1f80c25:	vpmovuswb %zmm2,%ymm2
 1f80c2b:	vpmovuswb %zmm1,%ymm1
 1f80c31:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm1
 1f80c38:	vmovdqu64 0x196ac(%rsi,%r12,1),%zmm2
 1f80c43:	vpaddb -0x1aceb8d(%rip),%zmm1,%zmm6        # 4b20c0 <abi_test_hex.digits+0xb3c0>
 1f80c4d:	vptestmb %zmm2,%zmm2,%k3
 1f80c53:	vmovdqa64 %zmm25,%zmm2
 1f80c59:	vmovdqa64 %zmm6,0x800(%rsp)
 1f80c61:	vpcmpleub %zmm10,%zmm1,%k4{%k3}
 1f80c68:	kandq  %k5,%k3,%k3
 1f80c6d:	vpermt2b %zmm0,%zmm6,%zmm2{%k4}{z}
 1f80c73:	vpmovuswb %zmm3,%ymm0
 1f80c79:	vpcmpnleub %zmm10,%zmm1,%k6{%k3}
 1f80c80:	vbroadcasti32x4 -0x19dc52a(%rip),%zmm1        # 5a4760 <.LCPI0_44>
 1f80c8a:	vmovdqu64 (%rcx,%r10,1),%zmm3
 1f80c91:	vpsubb %zmm5,%zmm11,%zmm6
 1f80c97:	kmovq  %r11,%k3
 1f80c9c:	vmovdqa64 %zmm12,%zmm10
 1f80ca2:	kmovq  %k4,0x68(%rsp)
 1f80ca9:	vpandq 0x2c(%rsi,%r10,1),%zmm1,%zmm1
 1f80cb4:	vpermt2b %zmm27,%zmm6,%zmm22{%k3}{z}
 1f80cba:	kortestq %k6,%k2
 1f80cbf:	kmovq  %k6,0x60(%rsp)
 1f80cc6:	vmovdqa64 %zmm2,0x5c0(%rsp)
 1f80cce:	vpmovuswb %zmm4,%ymm2
 1f80cd4:	vmovdqu64 (%r14,%r10,1),%zmm4
 1f80cdb:	vmovdqa64 %zmm22,0x1c0(%rsp)
 1f80ce3:	vpermt2b %zmm26,%zmm6,%zmm1{%k3}{z}
 1f80ce9:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 1f80cf0:	vpcmpltub -0x1acebbb(%rip),%zmm0,%k1        # 4b2140 <abi_test_hex.digits+0xb440>
 1f80cfb:	vmovdqu64 (%r8,%r10,1),%zmm2
 1f80d02:	kmovq  %k5,%r8
 1f80d07:	vpsubb %zmm0,%zmm11,%zmm7
 1f80d0d:	mov    %r8,0x90(%rsp)
 1f80d15:	vptestmb %zmm0,%zmm0,%k1{%k1}
 1f80d1b:	vmovdqu64 (%rax,%r10,1),%zmm0
 1f80d22:	vpermt2b %zmm28,%zmm7,%zmm2
 1f80d28:	vmovdqa64 %zmm0,%zmm5
 1f80d2e:	vpermt2b %zmm12,%zmm6,%zmm5{%k3}{z}
 1f80d34:	vmovdqa64 %zmm3,%zmm12
 1f80d3a:	vpermt2b %zmm24,%zmm6,%zmm12{%k3}{z}
 1f80d40:	vpermt2b %zmm10,%zmm7,%zmm0
 1f80d46:	vpermt2b %zmm24,%zmm7,%zmm3
 1f80d4c:	vmovdqa64 %zmm5,0x200(%rsp)
 1f80d54:	vmovdqa64 %zmm4,%zmm5
 1f80d5a:	vpermt2b %zmm29,%zmm6,%zmm5{%k3}{z}
 1f80d60:	vpermt2b %zmm29,%zmm7,%zmm4
 1f80d66:	jne    1f81b60 <node_contexts_window_loop+0x1360>
 1f80d6c:	vmovdqa64 %zmm21,%zmm7
 1f80d72:	vmovdqa64 %zmm16,%zmm21
 1f80d78:	vpternlogd $0xff,%zmm11,%zmm11,%zmm11
 1f80d7f:	vmovdqa64 %zmm9,%zmm24
 1f80d85:	vbroadcasti32x4 -0x19dc61f(%rip),%zmm6        # 5a4770 <.LCPI0_45>
 1f80d8f:	vmovdqu64 0x1a72c(%rsi,%r12,1),%zmm16
 1f80d9a:	vptestmb %zmm14,%zmm12,%k3
 1f80da0:	vpxor  %xmm9,%xmm9,%xmm9
 1f80da5:	mov    %r13,0xe0(%rsp)
 1f80dad:	vpaddb %zmm11,%zmm0,%zmm0
 1f80db3:	kmovq  %k3,%rsi
 1f80db8:	vptestmb %zmm14,%zmm3,%k3
 1f80dbe:	vpandq %zmm21,%zmm28,%zmm3
 1f80dc4:	vptestnmb %zmm3,%zmm3,%k4
 1f80dca:	vpcmpeqb %zmm13,%zmm3,%k6
 1f80dd0:	kmovq  %k6,0x120(%rsp)
 1f80dda:	vpandq %zmm6,%zmm5,%zmm5
 1f80de0:	vpandq %zmm6,%zmm4,%zmm4
 1f80de6:	vmovdqa64 0x580(%rsp),%zmm6
 1f80dee:	vptestnmb %zmm16,%zmm16,%k2
 1f80df4:	vpcmpeqb %zmm14,%zmm5,%k0
 1f80dfa:	kmovq  %k2,0x150(%rsp)
 1f80e04:	vpcmpgtb 0x5c0(%rsp),%zmm9,%k2{%k2}
 1f80e0c:	vmovdqa64 %zmm20,%zmm5
 1f80e12:	kmovq  %k0,%rcx
 1f80e17:	vpcmpeqb %zmm14,%zmm4,%k0
 1f80e1d:	vbroadcasti32x4 -0x19dc6a7(%rip),%zmm4        # 5a4780 <.LCPI0_46>
 1f80e27:	and    0x70(%rsp),%rcx
 1f80e2c:	korq   %k0,%k3,%k0
 1f80e31:	vptestmb -0x1ace9bb(%rip),%zmm6,%k3        # 4b2480 <abi_test_hex.digits+0xb780>
 1f80e3b:	or     %rcx,%rsi
 1f80e3e:	mov    0x30(%rsp),%rcx
 1f80e43:	vmovdqu8 %zmm13,%zmm3{%k2}{z}
 1f80e49:	vpandq %zmm4,%zmm28,%zmm22
 1f80e4f:	vpandq %zmm4,%zmm2,%zmm2
 1f80e55:	vmovdqa64 %zmm12,%zmm4
 1f80e5b:	vpandq -0x19d6415(%rip){1to8},%zmm25,%zmm12        # 5aaa50 <.LCPI0_14>
 1f80e65:	vmovdqa64 %zmm4,0x600(%rsp)
 1f80e6d:	kmovq  %k3,%rax
 1f80e72:	vptestmb %zmm19,%zmm6,%k3
 1f80e78:	vpcmpeqb %zmm20,%zmm22,%k7
 1f80e7e:	mov    %rax,0x28(%rsp)
 1f80e83:	kmovq  %k4,%rax
 1f80e88:	vptestmb %zmm22,%zmm22,%k4
 1f80e8e:	kmovq  %k7,0x118(%rsp)
 1f80e98:	kmovq  %k4,%rdx
 1f80e9d:	knotq  %k2,%k4
 1f80ea2:	kmovq  %k4,%r13
 1f80ea7:	korq   %k2,%k3,%k4
 1f80eac:	mov    %rdx,0x88(%rsp)
 1f80eb4:	kandq  %k7,%k4,%k3
 1f80eb9:	and    %r13,%rax
 1f80ebc:	mov    %r13,0xd8(%rsp)
 1f80ec4:	kmovq  %k3,%rdi
 1f80ec9:	vptestmb %zmm15,%zmm6,%k3{%k6}
 1f80ecf:	vpaddb %zmm11,%zmm10,%zmm6
 1f80ed5:	vpcmpltub %zmm14,%zmm6,%k2
 1f80edc:	or     %rax,%rdi
 1f80edf:	mov    0xbb0(%rcx),%rax
 1f80ee6:	vpcmpltub %zmm17,%zmm6,%k6
 1f80eed:	and    0x88(%rsp),%rdi
 1f80ef5:	kmovq  %k4,0x88(%rsp)
 1f80eff:	kmovq  %k2,0xb8(%rsp)
 1f80f09:	vptestmb %zmm15,%zmm25,%k2{%k2}
 1f80f0f:	kmovq  %k6,0xc8(%rsp)
 1f80f19:	kmovq  %k3,%rdx
 1f80f1e:	vpcmpeqb %zmm19,%zmm2,%k3{%k1}
 1f80f24:	vpandq %zmm15,%zmm4,%zmm2
 1f80f2a:	kmovq  %k3,0x168(%rsp)
 1f80f34:	vmovdqu64 %zmm3,(%rax,%r12,1)
 1f80f3b:	and    %r13,%rdx
 1f80f3e:	or     0x28(%rsp),%rdx
 1f80f43:	kmovq  %k2,0x158(%rsp)
 1f80f4d:	kandq  %k3,%k2,%k2
 1f80f52:	vptestnmb %zmm1,%zmm1,%k3
 1f80f58:	vbroadcasti32x4 -0x19dc7d2(%rip),%zmm1        # 5a4790 <.LCPI0_47>
 1f80f62:	mov    0xbc0(%rcx),%rax
 1f80f69:	kmovq  %k3,0x80(%rsp)
 1f80f73:	vpcmpgtb 0x1c0(%rsp),%zmm9,%k3{%k3}
 1f80f7b:	knotq  %k2,%k2
 1f80f80:	kmovq  %k2,%r8
 1f80f85:	vpcmpeqb %zmm7,%zmm12,%k2{%k6}
 1f80f8b:	kmovq  %k2,%r15
 1f80f90:	vptestmb %zmm2,%zmm2,%k2
 1f80f96:	and    %r8,%r15
 1f80f99:	mov    %rsi,%r8
 1f80f9c:	mov    %rdx,0xc0(%rsp)
 1f80fa4:	not    %rdx
 1f80fa7:	mov    %r8,0x48(%rsp)
 1f80fac:	vmovdqu64 %zmm12,(%rax,%r12,1)
 1f80fb3:	kmovq  %k6,%rax
 1f80fb8:	korq   %k3,%k2,%k2
 1f80fbd:	vpcmpeqb %zmm19,%zmm12,%k3
 1f80fc3:	knotq  %k2,%k2
 1f80fc8:	kmovq  %k2,%r9
 1f80fcd:	kandq  %k0,%k1,%k2
 1f80fd2:	vpcmpltub %zmm17,%zmm0,%k1{%k1}
 1f80fd9:	vptestmb %zmm24,%zmm25,%k0
 1f80fdf:	vpsllw $0x7,%zmm27,%zmm0
 1f80fe6:	korq   %k1,%k0,%k0
 1f80feb:	kmovq  %k0,%rbx
 1f80ff0:	vpcmpeqb %zmm1,%zmm12,%k0
 1f80ff6:	korq   %k0,%k3,%k0
 1f80ffb:	or     %rsi,%rbx
 1f80ffe:	kmovq  %k4,%rsi
 1f81003:	kmovq  %k0,%r10
 1f81008:	vpcmpneqb %zmm1,%zmm12,%k0
 1f8100f:	vpandq %zmm23,%zmm27,%zmm1
 1f81015:	and    %r9,%rbx
 1f81018:	mov    %rax,%r9
 1f8101b:	mov    %rsi,0xb0(%rsp)
 1f81023:	kmovq  %k0,%r14
 1f81028:	vptestmb %zmm1,%zmm1,%k0
 1f8102e:	or     %r9,%r14
 1f81031:	korq   %k0,%k2,%k0
 1f81036:	or     %rsi,%r14
 1f81039:	and    0x90(%rsp),%r14
 1f81041:	knotq  %k0,%k0
 1f81046:	kmovq  %k0,%r11
 1f8104b:	vpmovb2m %zmm0,%k0
 1f81051:	kmovq  %k0,%rax
 1f81056:	and    %r10,%r11
 1f81059:	kmovq  %k0,0x140(%rsp)
 1f81063:	andn   %rdi,%rax,%rdi
 1f81068:	mov    %rax,0x148(%rsp)
 1f81070:	mov    %rdi,0xa8(%rsp)
 1f81078:	and    %r11,%r14
 1f8107b:	andn   %rdx,%rdi,%r11
 1f81080:	and    %r11,%r15
 1f81083:	and    %r11,%r14
 1f81086:	and    %r15,%rbx
 1f81089:	mov    %r15,0x160(%rsp)
 1f81091:	or     %rbx,%r14
 1f81094:	mov    %rbx,0xd0(%rsp)
 1f8109c:	and    %r8,%r14
 1f8109f:	je     1f81350 <node_contexts_window_loop+0xb50>
 1f810a5:	vmovdqa64 %zmm18,%zmm6
 1f810ab:	vbroadcasti32x4 -0x19dc915(%rip),%zmm18        # 5a47a0 <.LCPI0_48>
 1f810b5:	mov    %r12,%rdi
 1f810b8:	shl    $0x6,%rdi
 1f810bc:	add    0x2c0(%rcx),%rdi
 1f810c3:	mov    0x20(%rcx),%rbx
 1f810c7:	mov    0x60(%rcx),%r12d
 1f810cb:	mov    0x38(%rsp),%rdx
 1f810d0:	kmovq  0x68(%rsp),%k6
 1f810d7:	kmovq  0x60(%rsp),%k7
 1f810de:	mov    %r14,%r13
 1f810e1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f810f0:	xor    %r15d,%r15d
 1f810f3:	tzcnt  %r13,%r15
 1f810f8:	mov    %r15d,%eax
 1f810fb:	shl    $0x6,%eax
 1f810fe:	mov    0x20(%rdi,%rax,1),%esi
 1f81102:	mov    %esi,%ecx
 1f81104:	shr    $0x3,%ecx
 1f81107:	cmp    %r12d,%ecx
 1f8110a:	cmovae %r12d,%ecx
 1f8110e:	shl    $0x6,%rcx
 1f81112:	cmpl   $0x0,0x38(%rbx,%rcx,1)
 1f81117:	setne  %al
 1f8111a:	testb  $0x4,0x34(%rbx,%rcx,1)
 1f8111f:	je     1f8113f <node_contexts_window_loop+0x93f>
 1f81121:	xor    $0x1,%al
 1f81123:	inc    %rdx
 1f81126:	movzbl %al,%eax
 1f81129:	shlx   %r15,%rax,%rax
 1f8112e:	andn   %r14,%rax,%r14
 1f81133:	blsr   %r13,%r13
 1f81138:	jne    1f810f0 <node_contexts_window_loop+0x8f0>
 1f8113a:	jmp    1f81376 <node_contexts_window_loop+0xb76>
 1f8113f:	mov    %rdi,0x128(%rsp)
 1f81147:	mov    0x30(%rsp),%rdi
 1f8114c:	vmovdqa %xmm8,0xf0(%rsp)
 1f81155:	mov    %rdx,0x38(%rsp)
 1f8115a:	vmovdqa64 %zmm25,0x540(%rsp)
 1f81162:	vmovdqa64 %zmm26,0x500(%rsp)
 1f8116a:	kmovq  %k5,0x40(%rsp)
 1f81171:	vmovdqa64 %zmm27,0x4c0(%rsp)
 1f81179:	vmovdqa64 %zmm28,0x480(%rsp)
 1f81181:	vmovdqa64 %zmm29,0x440(%rsp)
 1f81189:	vmovdqa64 %zmm30,0x400(%rsp)
 1f81191:	vmovdqa64 %zmm31,0x3c0(%rsp)
 1f81199:	vmovdqa64 %zmm10,0x380(%rsp)
 1f811a1:	vmovdqa64 %zmm12,0x340(%rsp)
 1f811a9:	mov    %r11,0x28(%rsp)
 1f811ae:	vmovdqa64 %zmm16,0x300(%rsp)
 1f811b6:	vmovdqa64 %zmm22,0x180(%rsp)
 1f811be:	vmovdqa64 %zmm1,0x2c0(%rsp)
 1f811c6:	vmovdqa64 %zmm2,0x280(%rsp)
 1f811ce:	kmovq  %k1,0x58(%rsp)
 1f811d5:	kmovq  %k2,0x50(%rsp)
 1f811dc:	kmovq  %k3,0x240(%rsp)
 1f811e6:	mov    %r9,0x130(%rsp)
 1f811ee:	vzeroupper
 1f811f1:	call   1f8260a <node_contexts_stride_asked>
 1f811f6:	vmovdqa64 0x280(%rsp),%zmm2
 1f811fe:	vmovdqa64 0x2c0(%rsp),%zmm1
 1f81206:	vmovdqa64 0x300(%rsp),%zmm16
 1f8120e:	vmovdqa64 0x380(%rsp),%zmm10
 1f81216:	vmovdqa64 0x3c0(%rsp),%zmm31
 1f8121e:	vmovdqa64 0x400(%rsp),%zmm30
 1f81226:	vmovdqa64 0x440(%rsp),%zmm29
 1f8122e:	vmovdqa64 0x480(%rsp),%zmm28
 1f81236:	vmovdqa64 0x4c0(%rsp),%zmm27
 1f8123e:	vmovdqa64 0x500(%rsp),%zmm26
 1f81246:	vmovdqa64 0x540(%rsp),%zmm25
 1f8124e:	vbroadcasti32x4 -0x19dcb08(%rip),%zmm24        # 5a4750 <.LCPI0_43>
 1f81258:	vbroadcasti32x4 -0x19dcb22(%rip),%zmm23        # 5a4740 <.LCPI0_42>
 1f81262:	vbroadcasti32x4 -0x19dcb3c(%rip),%zmm5        # 5a4730 <.LCPI0_41>
 1f8126c:	vmovdqa64 0x180(%rsp),%zmm22
 1f81274:	vbroadcasti32x4 -0x19dcb5e(%rip),%zmm21        # 5a4720 <.LCPI0_40>
 1f8127e:	vbroadcasti32x4 -0x19dcb78(%rip),%zmm7        # 5a4710 <.LCPI0_39>
 1f81288:	vbroadcasti32x4 -0x19dcb92(%rip),%zmm19        # 5a4700 <.LCPI0_38>
 1f81292:	vbroadcasti32x4 -0x19dcafc(%rip),%zmm18        # 5a47a0 <.LCPI0_48>
 1f8129c:	vbroadcasti32x4 -0x19dcbb6(%rip),%zmm17        # 5a46f0 <.LCPI0_37>
 1f812a6:	vbroadcasti32x4 -0x19dcbd0(%rip),%zmm15        # 5a46e0 <.LCPI0_36>
 1f812b0:	vbroadcasti32x4 -0x19dcbea(%rip),%zmm14        # 5a46d0 <.LCPI0_35>
 1f812ba:	vbroadcasti32x4 -0x19dcc04(%rip),%zmm13        # 5a46c0 <.LCPI0_34>
 1f812c4:	vbroadcasti32x4 -0x19dcc1e(%rip),%zmm6        # 5a46b0 <.LCPI0_33>
 1f812ce:	vmovdqa64 0x340(%rsp),%zmm12
 1f812d6:	vmovdqa 0xf0(%rsp),%xmm8
 1f812df:	mov    0x128(%rsp),%rdi
 1f812e7:	mov    0x130(%rsp),%r9
 1f812ef:	kmovq  0x240(%rsp),%k3
 1f812f9:	kmovq  0x50(%rsp),%k2
 1f81300:	kmovq  0x58(%rsp),%k1
 1f81307:	mov    0x28(%rsp),%r11
 1f8130c:	mov    0x48(%rsp),%r8
 1f81311:	kmovq  0x60(%rsp),%k7
 1f81318:	kmovq  0x68(%rsp),%k6
 1f8131f:	kmovq  0x40(%rsp),%k5
 1f81326:	mov    0x38(%rsp),%rdx
 1f8132b:	incq   0x108(%rsp)
 1f81333:	vpternlogd $0xff,%zmm11,%zmm11,%zmm11
 1f8133a:	vpxor  %xmm9,%xmm9,%xmm9
 1f8133f:	jmp    1f81121 <node_contexts_window_loop+0x921>
 1f81344:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f81350:	vmovdqa64 %zmm18,%zmm6
 1f81356:	vbroadcasti32x4 -0x19dcbc0(%rip),%zmm18        # 5a47a0 <.LCPI0_48>
 1f81360:	mov    0x38(%rsp),%rdx
 1f81365:	kmovq  0x68(%rsp),%k6
 1f8136c:	kmovq  0x60(%rsp),%k7
 1f81373:	xor    %r14d,%r14d
 1f81376:	vpaddb 0x200(%rsp),%zmm11,%zmm3
 1f8137e:	vpaddb -0x1aced48(%rip),%zmm12,%zmm0        # 4b2640 <abi_test_hex.digits+0xb940>
 1f81388:	kmovq  %k2,%rax
 1f8138d:	kmovq  %k3,%rcx
 1f81392:	mov    %rdx,0x38(%rsp)
 1f81397:	mov    %r9,%rdi
 1f8139a:	or     %r8,%rax
 1f8139d:	andn   %rcx,%rax,%rax
 1f813a2:	vpcmpltub %zmm17,%zmm3,%k1{%k1}
 1f813a9:	vpcmpltub %zmm23,%zmm0,%k0
 1f813b0:	kmovq  %k1,%rsi
 1f813b5:	kmovq  %k0,%rdx
 1f813ba:	andn   %r9,%rsi,%r15
 1f813bf:	and    0x90(%rsp),%r15
 1f813c7:	or     %rdx,%rax
 1f813ca:	and    %rsi,%rdi
 1f813cd:	and    %rax,%rdi
 1f813d0:	and    %r11,%rdi
 1f813d3:	mov    %rdi,0x200(%rsp)
 1f813db:	and    %rax,%r15
 1f813de:	and    %r11,%r15
 1f813e1:	je     1f815e8 <node_contexts_window_loop+0xde8>
 1f813e7:	mov    0x30(%rsp),%rax
 1f813ec:	mov    0xe0(%rsp),%rbx
 1f813f4:	xor    %r12d,%r12d
 1f813f7:	vmovdqa64 %zmm3,0x240(%rsp)
 1f813ff:	vmovdqa64 %zmm2,0x280(%rsp)
 1f81407:	vmovdqa64 %zmm1,0x2c0(%rsp)
 1f8140f:	vmovdqa64 %zmm22,0x180(%rsp)
 1f81417:	vmovdqa64 %zmm16,0x300(%rsp)
 1f8141f:	mov    %r11,0x28(%rsp)
 1f81424:	vmovdqa64 %zmm12,0x340(%rsp)
 1f8142c:	vmovdqa64 %zmm10,0x380(%rsp)
 1f81434:	vmovdqa64 %zmm31,0x3c0(%rsp)
 1f8143c:	vmovdqa64 %zmm30,0x400(%rsp)
 1f81444:	vmovdqa64 %zmm29,0x440(%rsp)
 1f8144c:	vmovdqa64 %zmm28,0x480(%rsp)
 1f81454:	vmovdqa64 %zmm27,0x4c0(%rsp)
 1f8145c:	kmovq  %k5,0x40(%rsp)
 1f81463:	vmovdqa64 %zmm26,0x500(%rsp)
 1f8146b:	vmovdqa64 %zmm25,0x540(%rsp)
 1f81473:	vmovdqa %xmm8,0xf0(%rsp)
 1f8147c:	mov    (%rax),%rcx
 1f8147f:	mov    0x2c0(%rax),%rax
 1f81486:	mov    %rcx,0x58(%rsp)
 1f8148b:	mov    %rax,0x50(%rsp)
 1f81490:	mov    0x78(%rsp),%rax
 1f81495:	mov    0x58(%rsp),%rdi
 1f8149a:	mov    0x50(%rsp),%rsi
 1f8149f:	xor    %r13d,%r13d
 1f814a2:	tzcnt  %r15,%r13
 1f814a7:	lea    (%rax,%r13,1),%edx
 1f814ab:	vzeroupper
 1f814ae:	call   1f825c0 <node_contexts_converted>
 1f814b3:	movzbl %al,%eax
 1f814b6:	inc    %rbx
 1f814b9:	shlx   %r13,%rax,%rax
 1f814be:	or     %rax,%r12
 1f814c1:	blsr   %r15,%r15
 1f814c6:	jne    1f81490 <node_contexts_window_loop+0xc90>
 1f814c8:	vmovdqa 0xf0(%rsp),%xmm8
 1f814d1:	vbroadcasti32x4 -0x19dce2b(%rip),%zmm6        # 5a46b0 <.LCPI0_33>
 1f814db:	vbroadcasti32x4 -0x19dce25(%rip),%zmm13        # 5a46c0 <.LCPI0_34>
 1f814e5:	vbroadcasti32x4 -0x19dce1f(%rip),%zmm14        # 5a46d0 <.LCPI0_35>
 1f814ef:	vbroadcasti32x4 -0x19dce19(%rip),%zmm15        # 5a46e0 <.LCPI0_36>
 1f814f9:	vbroadcasti32x4 -0x19dce13(%rip),%zmm17        # 5a46f0 <.LCPI0_37>
 1f81503:	vbroadcasti32x4 -0x19dcd6d(%rip),%zmm18        # 5a47a0 <.LCPI0_48>
 1f8150d:	vbroadcasti32x4 -0x19dce17(%rip),%zmm19        # 5a4700 <.LCPI0_38>
 1f81517:	vbroadcasti32x4 -0x19dce11(%rip),%zmm7        # 5a4710 <.LCPI0_39>
 1f81521:	vbroadcasti32x4 -0x19dce0b(%rip),%zmm21        # 5a4720 <.LCPI0_40>
 1f8152b:	vbroadcasti32x4 -0x19dce05(%rip),%zmm5        # 5a4730 <.LCPI0_41>
 1f81535:	vbroadcasti32x4 -0x19dcdff(%rip),%zmm23        # 5a4740 <.LCPI0_42>
 1f8153f:	vbroadcasti32x4 -0x19dcdf9(%rip),%zmm24        # 5a4750 <.LCPI0_43>
 1f81549:	vmovdqa64 0x540(%rsp),%zmm25
 1f81551:	vmovdqa64 0x500(%rsp),%zmm26
 1f81559:	vmovdqa64 0x4c0(%rsp),%zmm27
 1f81561:	vmovdqa64 0x480(%rsp),%zmm28
 1f81569:	vmovdqa64 0x440(%rsp),%zmm29
 1f81571:	vmovdqa64 0x400(%rsp),%zmm30
 1f81579:	vmovdqa64 0x3c0(%rsp),%zmm31
 1f81581:	vmovdqa64 0x380(%rsp),%zmm10
 1f81589:	vmovdqa64 0x340(%rsp),%zmm12
 1f81591:	vmovdqa64 0x300(%rsp),%zmm16
 1f81599:	vmovdqa64 0x180(%rsp),%zmm22
 1f815a1:	vmovdqa64 0x2c0(%rsp),%zmm1
 1f815a9:	vmovdqa64 0x280(%rsp),%zmm2
 1f815b1:	vmovdqa64 0x240(%rsp),%zmm3
 1f815b9:	or     %r12,0x200(%rsp)
 1f815c1:	kmovq  0x40(%rsp),%k5
 1f815c8:	kmovq  0x68(%rsp),%k6
 1f815cf:	kmovq  0x60(%rsp),%k7
 1f815d6:	mov    0x28(%rsp),%r11
 1f815db:	vpxor  %xmm9,%xmm9,%xmm9
 1f815e0:	mov    %rbx,0xe0(%rsp)
 1f815e8:	vmovdqa64 0x1c0(%rsp),%zmm0
 1f815f0:	kmovq  0x80(%rsp),%k1
 1f815fa:	vpsllw $0x7,0x580(%rsp),%zmm4
 1f81603:	kmovq  0xc8(%rsp),%k3
 1f8160d:	kmovq  0x118(%rsp),%k2
 1f81617:	kmovq  0xb8(%rsp),%k4
 1f81621:	mov    0x70(%rsp),%r9
 1f81626:	korq   %k4,%k2,%k2
 1f8162b:	vptestmb %zmm19,%zmm0,%k0{%k1}
 1f81631:	vpmovb2m %zmm4,%k1
 1f81637:	vbroadcasti32x4 -0x19dce91(%rip),%zmm4        # 5a47b0 <.LCPI0_49>
 1f81641:	kmovq  %k0,%rcx
 1f81646:	vptestmb %zmm14,%zmm0,%k0
 1f8164c:	kmovq  %k0,%rax
 1f81651:	vpcmpltub %zmm7,%zmm10,%k0
 1f81658:	and    %rcx,%r9
 1f8165b:	korq   %k1,%k0,%k1
 1f81660:	vptestmb %zmm19,%zmm27,%k0
 1f81666:	mov    %rax,0x28(%rsp)
 1f8166b:	kmovq  %k0,%r13
 1f81670:	vptestmb %zmm14,%zmm27,%k0
 1f81676:	vpcmpeqb %zmm23,%zmm12,%k1{%k1}
 1f8167c:	kmovq  %k0,%r12
 1f81681:	vpcmpeqb %zmm13,%zmm12,%k0
 1f81687:	mov    %r13,0x580(%rsp)
 1f8168f:	kmovq  %k0,%r10
 1f81694:	vpcmpeqb %zmm21,%zmm12,%k0
 1f8169a:	mov    %r12,0x70(%rsp)
 1f8169f:	kmovq  %k0,%rax
 1f816a4:	vpcmpeqb %zmm14,%zmm22,%k0{%k3}
 1f816aa:	korq   %k0,%k2,%k0
 1f816af:	kmovq  %k0,%rsi
 1f816b4:	vpcmpeqb %zmm14,%zmm12,%k0{%k3}
 1f816ba:	kmovq  %k0,%rdi
 1f816bf:	vptestnmb %zmm2,%zmm2,%k0
 1f816c5:	kmovq  %k0,%rcx
 1f816ca:	kmovq  0x120(%rsp),%k0
 1f816d4:	and    %rdi,%rcx
 1f816d7:	mov    0xc0(%rsp),%rdi
 1f816df:	and    %r11,%rcx
 1f816e2:	kandq  %k0,%k3,%k0
 1f816e7:	kmovq  %k0,%r8
 1f816ec:	vpcmpeqb -0x1acf0f6(%rip),%zmm12,%k0        # 4b2600 <abi_test_hex.digits+0xb900>
 1f816f6:	andn   %rsi,%rdi,%rdi
 1f816fb:	and    0xa8(%rsp),%rdi
 1f81703:	mov    %rdi,0x58(%rsp)
 1f81708:	mov    0xb0(%rsp),%rdi
 1f81710:	korq   %k1,%k0,%k0
 1f81715:	kmovq  %k0,%rdx
 1f8171a:	kmovq  0x88(%rsp),%k0
 1f81724:	andn   %r8,%rdi,%r8
 1f81729:	and    %r11,%rdx
 1f8172c:	and    %r10,%r8
 1f8172f:	and    %r13,%r8
 1f81732:	and    %r11,%r8
 1f81735:	korq   %k3,%k0,%k1
 1f8173a:	mov    %r8,0xc8(%rsp)
 1f81742:	and    %r12,%r8
 1f81745:	mov    $0x0,%r12d
 1f8174b:	vpcmpeqb %zmm17,%zmm12,%k0{%k1}
 1f81751:	kmovq  %k1,%rsi
 1f81756:	vpcmpeqb %zmm18,%zmm12,%k1
 1f8175c:	vptestnmb 0x600(%rsp),%zmm13,%k1{%k1}
 1f81764:	mov    %rdx,0x600(%rsp)
 1f8176c:	kmovq  %k0,%rbx
 1f81771:	vptestnmb %zmm1,%zmm1,%k0
 1f81777:	kmovq  %k0,%r15
 1f8177c:	vpcmpeqb -0x1acf0c6(%rip),%zmm12,%k0{%k3}        # 4b26c0 <abi_test_hex.digits+0xb9c0>
 1f81786:	and    %r11,%rbx
 1f81789:	and    %rax,%r15
 1f8178c:	andn   %rcx,%r9,%rax
 1f81791:	and    %r9,%rcx
 1f81794:	mov    %r10,%r9
 1f81797:	mov    0xd8(%rsp),%r10
 1f8179f:	mov    %r9,0x1c0(%rsp)
 1f817a7:	and    %rsi,%r15
 1f817aa:	mov    0x28(%rsp),%rsi
 1f817af:	mov    %rax,0xb0(%rsp)
 1f817b7:	and    %r11,%r15
 1f817ba:	andn   %rcx,%rsi,%rax
 1f817bf:	and    %rsi,%rcx
 1f817c2:	mov    0xa0(%rsp),%rsi
 1f817ca:	kmovq  %k0,%rdi
 1f817cf:	vpcmpltub %zmm4,%zmm3,%k0{%k1}
 1f817d6:	vpcmpeqb %zmm4,%zmm12,%k1
 1f817dc:	mov    %rax,0xb8(%rsp)
 1f817e4:	mov    %rcx,0xc0(%rsp)
 1f817ec:	vptestmb %zmm15,%zmm27,%k1{%k1}
 1f817f2:	kandq  %k0,%k3,%k0
 1f817f7:	and    %r11,%rdi
 1f817fa:	kmovq  %k0,%r13
 1f817ff:	mov    %rdi,0x50(%rsp)
 1f81804:	and    %r11,%r13
 1f81807:	mov    %r13,0xa8(%rsp)
 1f8180f:	kmovq  %k1,%rax
 1f81814:	and    %rax,%r10
 1f81817:	cmpb   $0x0,0x27(%rsp)
 1f8181c:	jne    1f81d13 <node_contexts_window_loop+0x1513>
 1f81822:	mov    0x30(%rsp),%rdx
 1f81827:	mov    0xd0(%rsp),%rcx
 1f8182f:	mov    0x48(%rsp),%r9
 1f81834:	mov    0x58(%rsp),%rdi
 1f81839:	andn   %r9,%r14,%rax
 1f8183e:	vmovdqa64 0x800(%rsp),%zmm3
 1f81846:	vmovdqa64 %zmm26,%zmm1
 1f8184c:	andn   %rcx,%rax,%r13
 1f81851:	mov    0xb0(%rsp),%rax
 1f81859:	and    %r13,%r9
 1f8185c:	or     %r8,%rdi
 1f8185f:	mov    0xb8(%rsp),%r8
 1f81867:	or     %rbx,%rdi
 1f8186a:	or     %rax,%rbx
 1f8186d:	or     0x600(%rsp),%rbx
 1f81875:	or     %rax,%r15
 1f81878:	or     %rax,%rdi
 1f8187b:	mov    0x50(%rsp),%rax
 1f81880:	vpermt2b %zmm30,%zmm3,%zmm1
 1f81886:	or     %r8,%r15
 1f81889:	mov    %rbx,%rcx
 1f8188c:	or     0xc8(%rsp),%rbx
 1f81894:	or     %rax,%rdi
 1f81897:	or     %rax,%r15
 1f8189a:	mov    0xa8(%rsp),%rax
 1f818a2:	or     %r8,%rdi
 1f818a5:	vpcmpeqb -0x1acf66f(%rip),%zmm1,%k0{%k6}        # 4b2240 <abi_test_hex.digits+0xb540>
 1f818af:	or     %r8,%rbx
 1f818b2:	mov    0x200(%rsp),%r8
 1f818ba:	or     %rax,%rcx
 1f818bd:	or     %rax,%r15
 1f818c0:	mov    0xc0(%rsp),%rax
 1f818c8:	or     %r8,%rdi
 1f818cb:	kmovq  %rdi,%k3
 1f818d0:	or     %rax,%rbx
 1f818d3:	or     %rax,%rcx
 1f818d6:	or     %rax,%r15
 1f818d9:	mov    0x110(%rsp),%rax
 1f818e1:	vmovdqu8 -0x1acf6eb(%rip),%zmm0{%k3}{z}        # 4b2200 <abi_test_hex.digits+0xb500>
 1f818eb:	or     %r14,%rbx
 1f818ee:	or     %r8,%rcx
 1f818f1:	or     %r14,%r15
 1f818f4:	vptestmb %zmm16,%zmm16,%k3
 1f818fa:	kmovq  %rbx,%k4
 1f818ff:	kmovq  %rcx,%k1
 1f81904:	or     %r8,%r15
 1f81907:	kmovq  %r15,%k2
 1f8190c:	mov    0xec(%rsp),%r15d
 1f81914:	vporq  %zmm19,%zmm0,%zmm2
 1f8191a:	vmovdqu8 %zmm2,%zmm0{%k4}
 1f81920:	vporq  %zmm23,%zmm0,%zmm1
 1f81926:	vmovdqu8 %zmm13,%zmm2{%k3}{z}
 1f8192c:	kmovq  %r10,%k3
 1f81931:	kmovq  0x80(%rsp),%k4
 1f8193b:	mov    %r13,0x80(%rsp)
 1f81943:	vmovdqu8 %zmm1,%zmm0{%k1}
 1f81949:	vpord  -0x19d44ab(%rip){1to16},%zmm0,%zmm1        # 5ad4a8 <.LCPI0_50>
 1f81953:	kmovq  %r13,%k1
 1f81958:	kmovq  %k4,%rcx
 1f8195d:	andn   %r13,%rcx,%rcx
 1f81962:	vmovdqu8 %zmm1,%zmm0{%k2}
 1f81968:	vmovdqu8 -0x1acf1b2(%rip),%zmm0{%k3}        # 4b27c0 <abi_test_hex.digits+0xbac0>
 1f81972:	vmovdqu8 -0x1acf17c(%rip),%zmm0{%k1}        # 4b2800 <abi_test_hex.digits+0xbb00>
 1f8197c:	kmovq  %rcx,%k1
 1f81981:	mov    0xba8(%rdx),%rcx
 1f81988:	vmovdqa64 %zmm0,%zmm1
 1f8198e:	vpaddb %zmm23,%zmm0,%zmm1{%k1}
 1f81994:	kmovq  %r9,%k1
 1f81999:	mov    0x78(%rsp),%r9
 1f8199e:	vpaddb %zmm19,%zmm1,%zmm1{%k1}
 1f819a4:	knotq  %k0,%k1
 1f819a9:	vpermi2b %zmm31,%zmm1,%zmm3{%k6}{z}
 1f819af:	vmovdqu8 0x680(%rsp),%zmm3{%k7}
 1f819b7:	vpaddw %zmm3,%zmm3,%zmm3
 1f819bd:	vporq  %zmm2,%zmm3,%zmm2
 1f819c3:	vpermb 0x80(%rax),%zmm2,%zmm2
 1f819ca:	vmovdqu64 %zmm0,(%rcx,%r9,1)
 1f819d1:	mov    0xbb8(%rdx),%rcx
 1f819d8:	mov    %r15d,%edx
 1f819db:	sub    %r9d,%edx
 1f819de:	vpandq %zmm18,%zmm2,%zmm3
 1f819e4:	vmovdqu8 %zmm3,%zmm3{%k1}{z}
 1f819ea:	vmovdqu64 %zmm3,(%rcx,%r9,1)
 1f819f1:	mov    $0xffffffffffffffff,%rcx
 1f819f8:	jbe    1f81a11 <node_contexts_window_loop+0x1211>
 1f819fa:	lea    0x40(%r9),%ecx
 1f819fe:	mov    $0xffffffffffffffff,%rax
 1f81a05:	cmp    %ecx,%r15d
 1f81a08:	shlx   %rdx,%rax,%rcx
 1f81a0d:	cmovae %r12,%rcx
 1f81a11:	kmovq  0x150(%rsp),%k1
 1f81a1b:	kmovq  0x118(%rsp),%k0
 1f81a25:	vmovdqa64 0x5c0(%rsp),%zmm3
 1f81a2d:	mov    0x1c0(%rsp),%r10
 1f81a35:	mov    $0xffffffffffffffff,%r14
 1f81a3c:	movabs $0x7fffffffffffffff,%r13
 1f81a46:	mov    %r9,%rax
 1f81a49:	vpandd -0x19d45a7(%rip){1to16},%zmm3,%zmm3        # 5ad4ac <.LCPI0_51>
 1f81a53:	kmovq  %k1,%rdi
 1f81a58:	kmovq  %k0,%rdx
 1f81a5d:	vptestnmb %zmm10,%zmm10,%k0{%k5}
 1f81a63:	kmovq  0x88(%rsp),%k1
 1f81a6d:	and    %rdi,%rdx
 1f81a70:	and    0x580(%rsp),%rdx
 1f81a78:	korq   %k1,%k0,%k0
 1f81a7d:	kmovq  0x120(%rsp),%k1
 1f81a87:	kmovq  %k0,%rdi
 1f81a8c:	vpcmpeqb %zmm4,%zmm3,%k0
 1f81a92:	and    %rdi,%r11
 1f81a95:	or     0x148(%rsp),%r11
 1f81a9d:	kmovq  %k0,%r8
 1f81aa2:	vptestmb %zmm24,%zmm28,%k0
 1f81aa8:	korq   %k1,%k0,%k0
 1f81aad:	kmovq  0x140(%rsp),%k1
 1f81ab7:	and    %r10,%r11
 1f81aba:	mov    %r11,0x28(%rsp)
 1f81abf:	mov    0x70(%rsp),%r11
 1f81ac4:	korq   %k1,%k0,%k0
 1f81ac9:	knotq  %k0,%k0
 1f81ace:	kmovq  %k0,%rdi
 1f81ad3:	vpmovb2m %zmm2,%k0
 1f81ad9:	and    %r8,%rdi
 1f81adc:	and    %rdi,%rdx
 1f81adf:	kmovq  %k0,%rdi
 1f81ae4:	and    %rdx,%r11
 1f81ae7:	andn   %rdi,%r11,%rbx
 1f81aec:	mov    %rbx,%rdi
 1f81aef:	or     %r10,%rdi
 1f81af2:	andn   0x90(%rsp),%rdi,%rdi
 1f81afc:	je     1f80960 <node_contexts_window_loop+0x160>
 1f81b02:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f81b10:	xor    %r8d,%r8d
 1f81b13:	tzcnt  %rdi,%r8
 1f81b18:	mov    %r15d,%r11d
 1f81b1b:	lea    (%rax,%r8,1),%r9d
 1f81b1f:	sub    0x651b8(%rsi,%r9,4),%r9d
 1f81b27:	lea    0x1(%r9),%r9d
 1f81b2b:	cmovb  %r12d,%r9d
 1f81b2f:	mov    %r9d,%r10d
 1f81b32:	sub    %eax,%r10d
 1f81b35:	cmp    %r15d,%r9d
 1f81b38:	cmovb  %r9d,%r11d
 1f81b3c:	cmp    %eax,%r9d
 1f81b3f:	shlx   %r10,%r14,%r10
 1f81b44:	cmovbe %r13,%r10
 1f81b48:	cmovb  %r11d,%r15d
 1f81b4c:	bzhi   %r8,%r10,%r8
 1f81b51:	or     %r8,%rcx
 1f81b54:	blsr   %rdi,%rdi
 1f81b59:	jne    1f81b10 <node_contexts_window_loop+0x1310>
 1f81b5b:	jmp    1f80960 <node_contexts_window_loop+0x160>
 1f81b60:	kmovq  %k6,%rdi
 1f81b65:	test   %rdi,%rdi
 1f81b68:	je     1f81bfd <node_contexts_window_loop+0x13fd>
 1f81b6e:	mov    0x30(%rsp),%r9
 1f81b73:	mov    %rbx,%r15
 1f81b76:	mov    0xba8(%r9),%r8
 1f81b7d:	mov    %rdi,%r9
 1f81b80:	mov    %r8,0x28(%rsp)
 1f81b85:	xor    %r10d,%r10d
 1f81b88:	tzcnt  %r9,%r10
 1f81b8d:	mov    0x28(%rsp),%r8
 1f81b92:	lea    (%r12,%r10,1),%r11d
 1f81b96:	mov    %r15,%r12
 1f81b99:	movzwl 0x6f654(%rsi,%r11,2),%ebx
 1f81ba2:	add    %r11d,%ebx
 1f81ba5:	movzwl 0x6b554(%rsi,%rbx,2),%r15d
 1f81bae:	movzbl 0x2c(%rsi,%rbx,1),%r11d
 1f81bb4:	movzbl (%r8,%rbx,1),%r8d
 1f81bb9:	sub    %r15d,%ebx
 1f81bbc:	and    $0x7f,%r11d
 1f81bc0:	mov    %r12,%r15
 1f81bc3:	testb  $0x7f,0x2c(%rsi,%rbx,1)
 1f81bc8:	movzbl (%r12,%r11,1),%r11d
 1f81bcd:	mov    0x78(%rsp),%r12
 1f81bd2:	setne  %bl
 1f81bd5:	mov    %r11b,0x640(%rsp,%r10,1)
 1f81bdd:	add    %bl,%bl
 1f81bdf:	or     $0x14,%bl
 1f81be2:	cmp    $0x14,%r8b
 1f81be6:	movzbl %bl,%r11d
 1f81bea:	cmovne %r8d,%r11d
 1f81bee:	blsr   %r9,%r9
 1f81bf3:	mov    %r11b,0x680(%rsp,%r10,1)
 1f81bfb:	jne    1f81b85 <node_contexts_window_loop+0x1385>
 1f81bfd:	kmovq  %k2,%r8
 1f81c02:	vpternlogd $0xff,%zmm11,%zmm11,%zmm11
 1f81c09:	vmovdqa64 %zmm21,%zmm7
 1f81c0f:	vmovdqa64 %zmm16,%zmm21
 1f81c15:	vmovdqa64 %zmm9,%zmm24
 1f81c1b:	mov    %r8,%r9
 1f81c1e:	test   %r8,%r8
 1f81c21:	je     1f81c8c <node_contexts_window_loop+0x148c>
 1f81c23:	xor    %r10d,%r10d
 1f81c26:	tzcnt  %r9,%r10
 1f81c2b:	lea    (%r12,%r10,1),%r11d
 1f81c2f:	mov    0x78(%rsp),%r12
 1f81c34:	movzwl 0x6b554(%rsi,%r11,2),%ebx
 1f81c3d:	sub    %ebx,%r11d
 1f81c40:	movzbl 0x2c(%rsi,%r11,1),%ebx
 1f81c46:	and    $0x7f,%bl
 1f81c49:	blsr   %r9,%r9
 1f81c4e:	mov    %bl,0x6c0(%rsp,%r10,1)
 1f81c56:	movzbl (%rax,%r11,1),%ebx
 1f81c5b:	mov    %bl,0x700(%rsp,%r10,1)
 1f81c63:	movzbl (%rcx,%r11,1),%ebx
 1f81c68:	mov    %bl,0x740(%rsp,%r10,1)
 1f81c70:	movzbl (%r14,%r11,1),%ebx
 1f81c75:	mov    %bl,0x780(%rsp,%r10,1)
 1f81c7d:	movzbl (%rdx,%r11,1),%r11d
 1f81c82:	mov    %r11b,0x7c0(%rsp,%r10,1)
 1f81c8a:	jne    1f81c23 <node_contexts_window_loop+0x1423>
 1f81c8c:	vmovdqa64 0x5c0(%rsp),%zmm6
 1f81c94:	vmovdqa64 0x200(%rsp),%zmm16
 1f81c9c:	vmovdqa64 0x1c0(%rsp),%zmm9
 1f81ca4:	vmovdqu8 0x6c0(%rsp),%zmm1{%k2}
 1f81cac:	vmovdqu8 0x740(%rsp),%zmm12{%k2}
 1f81cb4:	vmovdqu8 0x780(%rsp),%zmm5{%k2}
 1f81cbc:	popcnt %rdi,%rax
 1f81cc1:	add    0x98(%rsp),%rax
 1f81cc9:	or     %r8,0x70(%rsp)
 1f81cce:	popcnt %r8,%rcx
 1f81cd3:	add    %rcx,%rax
 1f81cd6:	mov    %rax,0x98(%rsp)
 1f81cde:	vmovdqu8 0x640(%rsp),%zmm6{%k6}
 1f81ce6:	vmovdqu8 0x700(%rsp),%zmm16{%k2}
 1f81cee:	vmovdqu8 0x7c0(%rsp),%zmm9{%k2}
 1f81cf6:	vmovdqa64 %zmm6,0x5c0(%rsp)
 1f81cfe:	vmovdqa64 %zmm16,0x200(%rsp)
 1f81d06:	vmovdqa64 %zmm9,0x1c0(%rsp)
 1f81d0e:	jmp    1f80d85 <node_contexts_window_loop+0x585>
 1f81d13:	mov    0xd0(%rsp),%rcx
 1f81d1b:	mov    0x30(%rsp),%rdx
 1f81d20:	mov    %r8,0x180(%rsp)
 1f81d28:	test   %rcx,%rcx
 1f81d2b:	je     1f81dd6 <node_contexts_window_loop+0x15d6>
 1f81d31:	mov    (%rdx),%rax
 1f81d34:	mov    0x48(%rsp),%r9
 1f81d39:	mov    0x8(%rax),%rax
 1f81d3d:	cmpb   $0x1,0x14a(%rax)
 1f81d44:	jne    1f81ddd <node_contexts_window_loop+0x15dd>
 1f81d4a:	mov    0x2c0(%rdx),%rdx
 1f81d51:	mov    %rax,0x280(%rsp)
 1f81d59:	mov    %r10,0xd8(%rsp)
 1f81d61:	vmovdqa64 %zmm16,0x300(%rsp)
 1f81d69:	mov    %r11,0x28(%rsp)
 1f81d6e:	vmovdqa64 %zmm12,0x340(%rsp)
 1f81d76:	vmovdqa64 %zmm10,0x380(%rsp)
 1f81d7e:	vmovdqa64 %zmm31,0x3c0(%rsp)
 1f81d86:	vmovdqa64 %zmm30,0x400(%rsp)
 1f81d8e:	vmovdqa64 %zmm29,0x440(%rsp)
 1f81d96:	vmovdqa64 %zmm28,0x480(%rsp)
 1f81d9e:	vmovdqa64 %zmm27,0x4c0(%rsp)
 1f81da6:	kmovq  %k5,0x40(%rsp)
 1f81dad:	vmovdqa64 %zmm26,0x500(%rsp)
 1f81db5:	vmovdqa64 %zmm25,0x540(%rsp)
 1f81dbd:	vmovdqa %xmm8,0xf0(%rsp)
 1f81dc6:	xor    %r13d,%r13d
 1f81dc9:	mov    %rcx,%r12
 1f81dcc:	mov    %rdx,0x240(%rsp)
 1f81dd4:	jmp    1f81e15 <node_contexts_window_loop+0x1615>
 1f81dd6:	mov    0x48(%rsp),%r9
 1f81ddb:	xor    %ecx,%ecx
 1f81ddd:	mov    0x180(%rsp),%r8
 1f81de5:	jmp    1f81834 <node_contexts_window_loop+0x1034>
 1f81dea:	lea    -0x1ab931c(%rip),%rdx        # 4c8ad5 <check_lower_segment_override.segments>
 1f81df1:	xor    %ecx,%ecx
 1f81df3:	testb  $0x3,-0x110(%rax,%rdx,1)
 1f81dfb:	setne  %cl
 1f81dfe:	mov    0x2c0(%rsp),%rax
 1f81e06:	shlx   %rax,%rcx,%rax
 1f81e0b:	or     %rax,%r13
 1f81e0e:	blsr   %r12,%r12
 1f81e13:	je     1f81e74 <node_contexts_window_loop+0x1674>
 1f81e15:	mov    0x78(%rsp),%rax
 1f81e1a:	xor    %ecx,%ecx
 1f81e1c:	tzcnt  %r12,%rcx
 1f81e21:	mov    0x240(%rsp),%rdx
 1f81e29:	mov    0x280(%rsp),%rdi
 1f81e31:	mov    %rcx,0x2c0(%rsp)
 1f81e39:	add    %ecx,%eax
 1f81e3b:	mov    0xa0(%rsp),%rcx
 1f81e43:	movzwl 0x6b554(%rcx,%rax,2),%ecx
 1f81e4b:	sub    %ecx,%eax
 1f81e4d:	shl    $0x6,%rax
 1f81e51:	mov    (%rdx,%rax,1),%esi
 1f81e54:	vzeroupper
 1f81e57:	call   1f2a5a0 <type_object_qualifiers_slow>
 1f81e5c:	and    $0xffffff,%eax
 1f81e61:	lea    -0x110(%rax),%ecx
 1f81e67:	cmp    $0x2,%ecx
 1f81e6a:	jbe    1f81dea <node_contexts_window_loop+0x15ea>
 1f81e70:	xor    %ecx,%ecx
 1f81e72:	jmp    1f81dfe <node_contexts_window_loop+0x15fe>
 1f81e74:	vmovdqa 0xf0(%rsp),%xmm8
 1f81e7d:	vbroadcasti32x4 -0x19dd7d7(%rip),%zmm6        # 5a46b0 <.LCPI0_33>
 1f81e87:	vbroadcasti32x4 -0x19dd7d1(%rip),%zmm13        # 5a46c0 <.LCPI0_34>
 1f81e91:	vbroadcasti32x4 -0x19dd7cb(%rip),%zmm14        # 5a46d0 <.LCPI0_35>
 1f81e9b:	vbroadcasti32x4 -0x19dd7c5(%rip),%zmm15        # 5a46e0 <.LCPI0_36>
 1f81ea5:	vbroadcasti32x4 -0x19dd7bf(%rip),%zmm17        # 5a46f0 <.LCPI0_37>
 1f81eaf:	vbroadcasti32x4 -0x19dd709(%rip),%zmm4        # 5a47b0 <.LCPI0_49>
 1f81eb9:	vbroadcasti32x4 -0x19dd723(%rip),%zmm18        # 5a47a0 <.LCPI0_48>
 1f81ec3:	vbroadcasti32x4 -0x19dd7cd(%rip),%zmm19        # 5a4700 <.LCPI0_38>
 1f81ecd:	vbroadcasti32x4 -0x19dd7c7(%rip),%zmm7        # 5a4710 <.LCPI0_39>
 1f81ed7:	vbroadcasti32x4 -0x19dd7c1(%rip),%zmm21        # 5a4720 <.LCPI0_40>
 1f81ee1:	vbroadcasti32x4 -0x19dd7bb(%rip),%zmm5        # 5a4730 <.LCPI0_41>
 1f81eeb:	vbroadcasti32x4 -0x19dd7b5(%rip),%zmm23        # 5a4740 <.LCPI0_42>
 1f81ef5:	vbroadcasti32x4 -0x19dd7af(%rip),%zmm24        # 5a4750 <.LCPI0_43>
 1f81eff:	vmovdqa64 0x540(%rsp),%zmm25
 1f81f07:	vmovdqa64 0x500(%rsp),%zmm26
 1f81f0f:	vmovdqa64 0x4c0(%rsp),%zmm27
 1f81f17:	vmovdqa64 0x480(%rsp),%zmm28
 1f81f1f:	vmovdqa64 0x440(%rsp),%zmm29
 1f81f27:	vmovdqa64 0x400(%rsp),%zmm30
 1f81f2f:	vmovdqa64 0x3c0(%rsp),%zmm31
 1f81f37:	vmovdqa64 0x380(%rsp),%zmm10
 1f81f3f:	vmovdqa64 0x340(%rsp),%zmm12
 1f81f47:	vmovdqa64 0x300(%rsp),%zmm16
 1f81f4f:	mov    0xd0(%rsp),%rcx
 1f81f57:	mov    0xa0(%rsp),%rsi
 1f81f5f:	mov    0x30(%rsp),%rdx
 1f81f64:	kmovq  0x40(%rsp),%k5
 1f81f6b:	kmovq  0x68(%rsp),%k6
 1f81f72:	kmovq  0x60(%rsp),%k7
 1f81f79:	mov    0x48(%rsp),%r9
 1f81f7e:	mov    0x28(%rsp),%r11
 1f81f83:	mov    0xd8(%rsp),%r10
 1f81f8b:	vpxor  %xmm9,%xmm9,%xmm9
 1f81f90:	xor    %r12d,%r12d
 1f81f93:	andn   %rcx,%r13,%rcx
 1f81f98:	jmp    1f81ddd <node_contexts_window_loop+0x15dd>
 1f81f9d:	vmovq  0x98(%rsp),%xmm0
 1f81fa6:	mov    0x138(%rsp),%rcx
 1f81fae:	mov    0x38(%rsp),%rax
 1f81fb3:	mov    0x108(%rsp),%rdx
 1f81fbb:	vmovq  %r13,%xmm1
 1f81fc0:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f81fc4:	vmovq  %rdx,%xmm1
 1f81fc9:	vmovq  %rax,%xmm2
 1f81fce:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f81fd2:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f81fd8:	vpaddq (%rcx),%ymm0,%ymm0
 1f81fdc:	vmovdqu %ymm0,(%rcx)
 1f81fe0:	vpaddq 0x20(%rcx),%xmm8,%xmm0
 1f81fe5:	vmovdqu %xmm0,0x20(%rcx)
 1f81fea:	lea    -0x28(%rbp),%rsp
 1f81fee:	pop    %rbx
 1f81fef:	pop    %r12
 1f81ff1:	pop    %r13
 1f81ff3:	pop    %r14
 1f81ff5:	pop    %r15
 1f81ff7:	pop    %rbp
 1f81ff8:	vzeroupper
 1f81ffb:	ret

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .iplt:
