
head-v3/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000016becb0 <pp_define>:
 16becb0:	push   %rbp
 16becb1:	push   %r15
 16becb3:	push   %r14
 16becb5:	push   %r13
 16becb7:	push   %r12
 16becb9:	push   %rbx
 16becba:	sub    $0xc8,%rsp
 16becc1:	mov    %fs:0x28,%rax
 16becca:	mov    %ecx,%ebp
 16beccc:	mov    %esi,%ecx
 16becce:	imul   $0xe8,%rcx,%rcx
 16becd5:	mov    %edx,%r15d
 16becd8:	mov    %rdi,%rbx
 16becdb:	mov    %ebp,%r14d
 16becde:	mov    %rax,0xc0(%rsp)
 16bece6:	mov    0xb80(%rdi),%rax
 16beced:	lea    (%rax,%rcx,1),%r13
 16becf1:	cmp    0x3c(%rax,%rcx,1),%ebp
 16becf5:	jae    16bed44 <pp_define+0x94>
 16becf7:	lea    0x0(,%r14,4),%rax
 16becff:	add    0x58(%r13),%rax
 16bed03:	cmp    %r8d,%ebp
 16bed06:	jb     16bed4d <pp_define+0x9d>
 16bed08:	dec    %ebp
 16bed0a:	mov    %rbx,%rdi
 16bed0d:	mov    %r13,%rsi
 16bed10:	mov    %r15d,%edx
 16bed13:	mov    %ebp,%ecx
 16bed15:	call   16c1780 <pp_line_end_location>
 16bed1a:	mov    %fs:0x28,%rcx
 16bed23:	cmp    0xc0(%rsp),%rcx
 16bed2b:	jne    16bfe74 <pp_define+0x11c4>
 16bed31:	lea    -0xfbc91a(%rip),%rcx        # 70241e <pp_string_value.meaning+0x4e77c>
 16bed38:	mov    %rbx,%rdi
 16bed3b:	mov    $0x1,%esi
 16bed40:	mov    %eax,%edx
 16bed42:	jmp    16bedbf <pp_define+0x10f>
 16bed44:	lea    0x30(%r13),%rax
 16bed48:	cmp    %r8d,%ebp
 16bed4b:	jae    16bed08 <pp_define+0x58>
 16bed4d:	mov    (%rax),%edx
 16bed4f:	mov    0x50(%r13),%rax
 16bed53:	movzbl (%rax,%r14,1),%ecx
 16bed58:	add    %r15d,%edx
 16bed5b:	and    $0x7f,%cl
 16bed5e:	cmp    $0x1,%cl
 16bed61:	jne    16bed99 <pp_define+0xe9>
 16bed63:	mov    0x60(%r13),%rcx
 16bed67:	mov    (%rcx,%r14,4),%edi
 16bed6b:	mov    %rdi,0x30(%rsp)
 16bed70:	cmp    $0xa9,%rdi
 16bed77:	jne    16bedd7 <pp_define+0x127>
 16bed79:	mov    %fs:0x28,%rax
 16bed82:	cmp    0xc0(%rsp),%rax
 16bed8a:	jne    16bfe74 <pp_define+0x11c4>
 16bed90:	lea    -0xfbc9a2(%rip),%rcx        # 7023f5 <pp_string_value.meaning+0x4e753>
 16bed97:	jmp    16bedb7 <pp_define+0x107>
 16bed99:	mov    %fs:0x28,%rax
 16beda2:	cmp    0xc0(%rsp),%rax
 16bedaa:	jne    16bfe74 <pp_define+0x11c4>
 16bedb0:	lea    -0x1073abb(%rip),%rcx        # 64b2fc <tier0_test_vector_type_class.classes+0x1fc99>
 16bedb7:	mov    $0x1,%esi
 16bedbc:	mov    %rbx,%rdi
 16bedbf:	xor    %eax,%eax
 16bedc1:	add    $0xc8,%rsp
 16bedc8:	pop    %rbx
 16bedc9:	pop    %r12
 16bedcb:	pop    %r13
 16bedcd:	pop    %r14
 16bedcf:	pop    %r15
 16bedd1:	pop    %rbp
 16bedd2:	jmp    16781f0 <pp_diagnose>
 16bedd7:	mov    0x30(%rsp),%rcx
 16beddc:	inc    %r14
 16beddf:	mov    %edx,0x24(%rsp)
 16bede3:	mov    %r15,0x38(%rsp)
 16bede8:	vpxor  %xmm0,%xmm0,%xmm0
 16bedec:	movq   $0x0,0x70(%rsp)
 16bedf5:	mov    %r8,0x18(%rsp)
 16bedfa:	mov    %ecx,0x78(%rsp)
 16bedfe:	movq   $0x0,0x7c(%rsp)
 16bee07:	movl   $0x0,0x84(%rsp)
 16bee12:	mov    %esi,0x88(%rsp)
 16bee19:	mov    %r15d,0x8c(%rsp)
 16bee21:	mov    %r14d,0x90(%rsp)
 16bee29:	mov    %r8d,0x94(%rsp)
 16bee31:	mov    %r14d,0x98(%rsp)
 16bee39:	mov    %edx,0x9c(%rsp)
 16bee40:	vmovdqu %xmm0,0xa0(%rsp)
 16bee49:	movq   $0x0,0xb0(%rsp)
 16bee55:	cmp    %r8d,%r14d
 16bee58:	jae    16bee8f <pp_define+0x1df>
 16bee5a:	movzbl (%rax,%r14,1),%eax
 16bee5f:	mov    %edx,%edi
 16bee61:	mov    0x68(%r13),%rdx
 16bee65:	mov    %r14d,%ecx
 16bee68:	shr    $0x6,%ecx
 16bee6b:	and    $0x7f,%al
 16bee6d:	cmp    $0xf,%al
 16bee6f:	jne    16bee7f <pp_define+0x1cf>
 16bee71:	mov    (%rdx,%rcx,8),%rsi
 16bee75:	bt     %r14,%rsi
 16bee79:	jae    16bef81 <pp_define+0x2d1>
 16bee7f:	mov    (%rdx,%rcx,8),%rcx
 16bee83:	mov    %r14d,%esi
 16bee86:	and    $0x3f,%esi
 16bee89:	bt     %rsi,%rcx
 16bee8d:	jae    16bee99 <pp_define+0x1e9>
 16bee8f:	movl   $0x0,0x14(%rsp)
 16bee97:	jmp    16beef7 <pp_define+0x247>
 16bee99:	test   %al,%al
 16bee9b:	lea    -0x10f66e7(%rip),%rax        # 5c87bb <foreign_rank_visibilities+0x45d3>
 16beea2:	lea    -0x10257ff(%rip),%rcx        # 6996aa <fuzz_comment_end+0x36b0f>
 16beea9:	lea    -0x10f6726(%rip),%r15        # 5c878a <foreign_rank_visibilities+0x45a2>
 16beeb0:	mov    0x38(%rsp),%rdx
 16beeb5:	mov    %rbx,%rdi
 16beeb8:	mov    %r13,%rsi
 16beebb:	cmove  %rax,%rcx
 16beebf:	cmpl   $0x7cf,0x8(%rbx)
 16beec6:	cmovb  %rcx,%r15
 16beeca:	mov    %r14d,%ecx
 16beecd:	call   16c1990 <pp_define_location>
 16beed2:	lea    -0x10ddb66(%rip),%rcx        # 5e1373 <parse_test_openers+0x14e33>
 16beed9:	mov    %eax,%edx
 16beedb:	movl   $0x0,0x14(%rsp)
 16beee3:	mov    %rbx,%rdi
 16beee6:	xor    %esi,%esi
 16beee8:	mov    %r15,%r8
 16beeeb:	xor    %eax,%eax
 16beeed:	call   16781f0 <pp_diagnose>
 16beef2:	mov    0x18(%rsp),%r8
 16beef7:	mov    %r8d,%r15d
 16beefa:	sub    %r14d,%r15d
 16beefd:	jbe    16bfb13 <pp_define+0xe63>
 16bef03:	mov    0x50(%r13),%r12
 16bef07:	mov    0x60(%r13),%rsi
 16bef0b:	cmpb   $0x1,0x278(%rbx)
 16bef12:	mov    %r14d,%r9d
 16bef15:	mov    %r9,0x28(%rsp)
 16bef1a:	jne    16bef5b <pp_define+0x2ab>
 16bef1c:	mov    %r8,%rcx
 16bef1f:	lea    0x6e(%rsp),%rax
 16bef24:	lea    0xbf(%rsp),%r8
 16bef2c:	lea    0x6f(%rsp),%r9
 16bef31:	mov    %r12,%rdi
 16bef34:	mov    %r14d,%edx
 16bef37:	mov    %rax,(%rsp)
 16bef3b:	vzeroupper
 16bef3e:	call   16c19d0 <pp_scan_body_vector>
 16bef43:	mov    0x18(%rsp),%r8
 16bef48:	movzbl 0xbf(%rsp),%r9d
 16bef51:	movzbl 0x6e(%rsp),%ebp
 16bef56:	jmp    16bf9aa <pp_define+0xcfa>
 16bef5b:	mov    %r8d,%eax
 16bef5e:	mov    %rax,%rdx
 16bef61:	sub    %r9,%rdx
 16bef64:	cmp    $0x8,%rdx
 16bef68:	jae    16bf617 <pp_define+0x967>
 16bef6e:	mov    %r8,%r11
 16bef71:	mov    %r9,%rcx
 16bef74:	xor    %ebp,%ebp
 16bef76:	xor    %r8d,%r8d
 16bef79:	xor    %r9d,%r9d
 16bef7c:	jmp    16bfa52 <pp_define+0xda2>
 16bef81:	vpbroadcastb -0x119de8a(%rip),%xmm9        # 521100 <c_first_char_channels+0x8480>
 16bef8a:	vmovdqa64 -0x119ded4(%rip),%zmm10        # 5210c0 <c_first_char_channels+0x8440>
 16bef94:	vpbroadcastb -0x119de9d(%rip),%xmm11        # 521100 <c_first_char_channels+0x8480>
 16bef9d:	lea    -0x1(%r8),%eax
 16befa1:	lea    0x2(%rbp),%r14d
 16befa5:	movb   $0x1,0x7c(%rsp)
 16befaa:	xor    %r9d,%r9d
 16befad:	mov    %edi,%edx
 16befaf:	mov    %eax,0x4c(%rsp)
 16befb3:	lea    0x4(%rbp),%eax
 16befb6:	mov    %r14d,0x98(%rsp)
 16befbe:	mov    %eax,0x54(%rsp)
 16befc2:	mov    $0xfffffffd,%eax
 16befc7:	sub    %ebp,%eax
 16befc9:	add    $0x62,%ebp
 16befcc:	mov    %eax,0x50(%rsp)
 16befd0:	mov    $0x1,%al
 16befd2:	mov    %eax,0x14(%rsp)
 16befd6:	mov    %r14,0x40(%rsp)
 16befdb:	cmp    %r8d,%r14d
 16befde:	jae    16bfd51 <pp_define+0x10a1>
 16befe4:	mov    0x50(%r13),%rax
 16befe8:	mov    %r14d,%r11d
 16befeb:	movzbl (%rax,%r11,1),%eax
 16beff0:	and    $0x7f,%eax
 16beff3:	mov    %eax,%ecx
 16beff5:	xor    $0x10,%ecx
 16beff8:	or     %r9d,%ecx
 16beffb:	je     16bfd98 <pp_define+0x10e8>
 16bf001:	cmp    $0x10,%al
 16bf003:	je     16bfda0 <pp_define+0x10f0>
 16bf009:	cmp    $0x1,%eax
 16bf00c:	je     16bf039 <pp_define+0x389>
 16bf00e:	cmp    $0x14,%eax
 16bf011:	jne    16bfdcb <pp_define+0x111b>
 16bf017:	mov    0x14(%rsp),%eax
 16bf01b:	mov    $0x1,%r12b
 16bf01e:	or     $0x2,%al
 16bf020:	mov    %eax,0x14(%rsp)
 16bf024:	mov    %al,0x7c(%rsp)
 16bf028:	cmp    $0x10,%r9d
 16bf02c:	jae    16bf39f <pp_define+0x6ef>
 16bf032:	xor    %eax,%eax
 16bf034:	jmp    16bf511 <pp_define+0x861>
 16bf039:	mov    0x60(%r13),%rax
 16bf03d:	mov    %r9d,0x28(%rsp)
 16bf042:	mov    (%rax,%r11,4),%r15d
 16bf046:	cmp    $0xf,%r9d
 16bf04a:	ja     16bf268 <pp_define+0x5b8>
 16bf050:	mov    0x40(%rsp),%rcx
 16bf055:	cmp    %r14d,%ecx
 16bf058:	jae    16bf40b <pp_define+0x75b>
 16bf05e:	mov    0x54(%rsp),%r8d
 16bf063:	mov    $0x0,%r9d
 16bf069:	mov    %ecx,%r12d
 16bf06c:	cmp    %r8d,%r14d
 16bf06f:	cmova  %r14d,%r8d
 16bf073:	add    0x50(%rsp),%r8d
 16bf078:	xor    %r10d,%r10d
 16bf07b:	cmp    $0x10,%r8d
 16bf07f:	jb     16bf23e <pp_define+0x58e>
 16bf085:	mov    %r8d,%ecx
 16bf088:	shr    $1,%ecx
 16bf08a:	lea    0x1(%rcx),%edi
 16bf08d:	cmp    $0x80,%r8d
 16bf094:	jb     16bf1c6 <pp_define+0x516>
 16bf09a:	mov    %edi,%r8d
 16bf09d:	mov    %r11,0x60(%rsp)
 16bf0a2:	and    $0x3f,%r8d
 16bf0a6:	mov    $0x40,%edx
 16bf0ab:	mov    %edi,%esi
 16bf0ad:	vpbroadcastd %r15d,%zmm1
 16bf0b3:	vpxor  %xmm0,%xmm0,%xmm0
 16bf0b7:	mov    %ebp,%r9d
 16bf0ba:	mov    %edi,%r10d
 16bf0bd:	vpxor  %xmm2,%xmm2,%xmm2
 16bf0c1:	vpxor  %xmm4,%xmm4,%xmm4
 16bf0c5:	vpxor  %xmm3,%xmm3,%xmm3
 16bf0c9:	cmove  %edx,%r8d
 16bf0cd:	mov    0x40(%rsp),%rdx
 16bf0d2:	sub    %r8d,%esi
 16bf0d5:	mov    %rsi,0x58(%rsp)
 16bf0da:	lea    (%rdx,%rsi,2),%edx
 16bf0dd:	mov    %edx,0x48(%rsp)
 16bf0e1:	lea    -0x60(%r9),%r11d
 16bf0e5:	lea    -0x40(%r9),%r12d
 16bf0e9:	lea    -0x20(%r9),%edx
 16bf0ed:	mov    %r9d,%esi
 16bf0f0:	vmovdqu64 (%rax,%rsi,4),%zmm8
 16bf0f7:	add    $0xffffffc0,%r10d
 16bf0fb:	sub    $0xffffff80,%r9d
 16bf0ff:	vmovdqu64 (%rax,%r11,4),%zmm5
 16bf106:	vmovdqu64 (%rax,%r12,4),%zmm6
 16bf10d:	vmovdqu64 (%rax,%rdx,4),%zmm7
 16bf114:	vpermt2d 0x40(%rax,%rsi,4),%zmm10,%zmm8
 16bf11c:	vpermt2d 0x40(%rax,%r11,4),%zmm10,%zmm5
 16bf124:	vpermt2d 0x40(%rax,%r12,4),%zmm10,%zmm6
 16bf12c:	vpermt2d 0x40(%rax,%rdx,4),%zmm10,%zmm7
 16bf134:	vpcmpeqd %zmm1,%zmm8,%k4
 16bf13a:	vpcmpeqd %zmm1,%zmm6,%k2
 16bf140:	vpor   %xmm4,%xmm11,%xmm6
 16bf144:	vpcmpeqd %zmm1,%zmm7,%k3
 16bf14a:	vpcmpeqd %zmm1,%zmm5,%k1
 16bf150:	vpor   %xmm2,%xmm11,%xmm7
 16bf154:	vmovdqu8 %xmm7,%xmm2{%k1}
 16bf15a:	vpor   %xmm3,%xmm11,%xmm7
 16bf15e:	vmovdqu8 %xmm6,%xmm4{%k2}
 16bf164:	vpor   %xmm0,%xmm11,%xmm6
 16bf168:	vmovdqu8 %xmm7,%xmm3{%k3}
 16bf16e:	vmovdqu8 %xmm6,%xmm0{%k4}
 16bf174:	cmp    %r10d,%r8d
 16bf177:	jne    16bf0e1 <pp_define+0x431>
 16bf17d:	vpor   %xmm2,%xmm4,%xmm1
 16bf181:	mov    0x60(%rsp),%r11
 16bf186:	mov    0x48(%rsp),%r12d
 16bf18b:	mov    0x58(%rsp),%r10
 16bf190:	vpternlogq $0xfe,%xmm1,%xmm3,%xmm0
 16bf197:	vpshufd $0xee,%xmm0,%xmm1
 16bf19c:	vpor   %xmm1,%xmm0,%xmm0
 16bf1a0:	vpshufd $0x55,%xmm0,%xmm1
 16bf1a5:	vpor   %xmm1,%xmm0,%xmm0
 16bf1a9:	vpsrld $0x10,%xmm0,%xmm1
 16bf1ae:	vpor   %xmm1,%xmm0,%xmm0
 16bf1b2:	vpsrlw $0x8,%xmm0,%xmm1
 16bf1b7:	vpor   %xmm1,%xmm0,%xmm0
 16bf1bb:	vmovd  %xmm0,%r9d
 16bf1c0:	cmp    $0x9,%r8d
 16bf1c4:	jb     16bf23e <pp_define+0x58e>
 16bf1c6:	mov    0x40(%rsp),%r8
 16bf1cb:	mov    %edi,%edx
 16bf1cd:	and    $0x7,%edx
 16bf1d0:	mov    $0x8,%esi
 16bf1d5:	not    %ecx
 16bf1d7:	vpbroadcastd %r15d,%ymm1
 16bf1dd:	cmove  %esi,%edx
 16bf1e0:	movzbl %r9b,%esi
 16bf1e4:	add    %r10d,%ecx
 16bf1e7:	sub    %edx,%edi
 16bf1e9:	vmovd  %esi,%xmm0
 16bf1ed:	add    %edx,%ecx
 16bf1ef:	lea    (%r8,%rdi,2),%r12d
 16bf1f3:	lea    (%r8,%r10,2),%esi
 16bf1f7:	mov    %esi,%edx
 16bf1f9:	vmovdqu64 (%rax,%rdx,4),%zmm2
 16bf200:	add    $0x10,%esi
 16bf203:	add    $0x8,%ecx
 16bf206:	vpmovqd %zmm2,%ymm2
 16bf20c:	vpcmpeqd %ymm1,%ymm2,%k1
 16bf212:	vpor   %xmm0,%xmm9,%xmm2
 16bf216:	vmovdqu8 %xmm2,%xmm0{%k1}
 16bf21c:	jne    16bf1f7 <pp_define+0x547>
 16bf21e:	vpshufd $0x55,%xmm0,%xmm1
 16bf223:	vpor   %xmm1,%xmm0,%xmm0
 16bf227:	vpsrld $0x10,%xmm0,%xmm1
 16bf22c:	vpor   %xmm1,%xmm0,%xmm0
 16bf230:	vpsrlw $0x8,%xmm0,%xmm1
 16bf235:	vpor   %xmm1,%xmm0,%xmm0
 16bf239:	vmovd  %xmm0,%r9d
 16bf23e:	mov    0x18(%rsp),%r8
 16bf243:	mov    %r12d,%ecx
 16bf246:	cs nopw 0x0(%rax,%rax,1)
 16bf250:	cmp    %r15d,(%rax,%rcx,4)
 16bf254:	sete   %dl
 16bf257:	add    $0x2,%rcx
 16bf25b:	or     %dl,%r9b
 16bf25e:	cmp    %r14d,%ecx
 16bf261:	jb     16bf250 <pp_define+0x5a0>
 16bf263:	jmp    16bf40e <pp_define+0x75e>
 16bf268:	lea    0xbf(%rsp),%rax
 16bf270:	lea    0x78(%rsp),%rdx
 16bf275:	lea    0x70(%rsp),%rcx
 16bf27a:	mov    %rbx,%rdi
 16bf27d:	mov    %r13,%rsi
 16bf280:	mov    %r15d,%r8d
 16bf283:	mov    %r11,%r12
 16bf286:	mov    %rax,(%rsp)
 16bf28a:	vzeroupper
 16bf28d:	call   16c2870 <pp_define_parameter_large>
 16bf292:	mov    0x18(%rsp),%r8
 16bf297:	mov    $0x1,%dl
 16bf299:	mov    %r12,%r11
 16bf29c:	test   %al,%al
 16bf29e:	je     16bf495 <pp_define+0x7e5>
 16bf2a4:	cmpb   $0x1,0xbf(%rsp)
 16bf2ac:	jne    16bf426 <pp_define+0x776>
 16bf2b2:	mov    0x38(%rsp),%rdx
 16bf2b7:	mov    %rbx,%rdi
 16bf2ba:	mov    %r13,%rsi
 16bf2bd:	mov    %r14d,%ecx
 16bf2c0:	mov    %r11,%r12
 16bf2c3:	vzeroupper
 16bf2c6:	call   16c1990 <pp_define_location>
 16bf2cb:	mov    0x270(%rbx),%rcx
 16bf2d2:	mov    $0x1,%esi
 16bf2d7:	mov    %rbx,%rdi
 16bf2da:	mov    0x10(%rcx),%rdx
 16bf2de:	mov    (%rdx,%r15,8),%r9d
 16bf2e2:	mov    0x4(%rdx,%r15,8),%r8d
 16bf2e7:	mov    %eax,%edx
 16bf2e9:	xor    %eax,%eax
 16bf2eb:	add    0x40(%rcx),%r9
 16bf2ef:	lea    -0x10f6b16(%rip),%rcx        # 5c87e0 <foreign_rank_visibilities+0x45f8>
 16bf2f6:	call   16781f0 <pp_diagnose>
 16bf2fb:	mov    0x18(%rsp),%r8
 16bf300:	xor    %edx,%edx
 16bf302:	mov    %r12,%r11
 16bf305:	inc    %r11
 16bf308:	cmp    %r8d,%r11d
 16bf30b:	jb     16bf432 <pp_define+0x782>
 16bf311:	vpbroadcastb -0x119e21a(%rip),%xmm9        # 521100 <c_first_char_channels+0x8480>
 16bf31a:	vmovdqa64 -0x119e264(%rip),%zmm10        # 5210c0 <c_first_char_channels+0x8440>
 16bf324:	vpbroadcastb -0x119e22d(%rip),%xmm11        # 521100 <c_first_char_channels+0x8480>
 16bf32d:	mov    0x28(%rsp),%r9d
 16bf332:	test   %dl,%dl
 16bf334:	je     16bf5dc <pp_define+0x92c>
 16bf33a:	mov    %r11d,%r14d
 16bf33d:	lea    -0x1025c72(%rip),%rcx        # 6996d2 <fuzz_comment_end+0x36b37>
 16bf344:	mov    0x38(%rsp),%rdx
 16bf349:	mov    %rcx,%r12
 16bf34c:	mov    %rbx,%rdi
 16bf34f:	mov    %r13,%rsi
 16bf352:	mov    %r14d,%ecx
 16bf355:	vzeroupper
 16bf358:	call   16c1990 <pp_define_location>
 16bf35d:	mov    $0x1,%esi
 16bf362:	mov    %eax,%edx
 16bf364:	xor    %r15d,%r15d
 16bf367:	mov    %rbx,%rdi
 16bf36a:	mov    %r12,%rcx
 16bf36d:	xor    %eax,%eax
 16bf36f:	call   16781f0 <pp_diagnose>
 16bf374:	vpbroadcastb -0x119e27d(%rip),%xmm11        # 521100 <c_first_char_channels+0x8480>
 16bf37d:	vmovdqa64 -0x119e2c7(%rip),%zmm10        # 5210c0 <c_first_char_channels+0x8440>
 16bf387:	vpbroadcastb -0x119e290(%rip),%xmm9        # 521100 <c_first_char_channels+0x8480>
 16bf390:	mov    0x28(%rsp),%r9d
 16bf395:	mov    0x18(%rsp),%r8
 16bf39a:	jmp    16bf5e2 <pp_define+0x932>
 16bf39f:	mov    %edx,%r14d
 16bf3a2:	lea    0xbf(%rsp),%rax
 16bf3aa:	lea    0x78(%rsp),%rdx
 16bf3af:	lea    0x70(%rsp),%rcx
 16bf3b4:	mov    $0xaa,%r8d
 16bf3ba:	mov    %r11,%r12
 16bf3bd:	mov    %rbx,%rdi
 16bf3c0:	mov    %r13,%rsi
 16bf3c3:	mov    %r9d,%r15d
 16bf3c6:	mov    %rax,(%rsp)
 16bf3ca:	vzeroupper
 16bf3cd:	call   16c2870 <pp_define_parameter_large>
 16bf3d2:	test   %al,%al
 16bf3d4:	je     16bf4cc <pp_define+0x81c>
 16bf3da:	vpbroadcastb -0x119e2e3(%rip),%xmm9        # 521100 <c_first_char_channels+0x8480>
 16bf3e3:	vmovdqa64 -0x119e32d(%rip),%zmm10        # 5210c0 <c_first_char_channels+0x8440>
 16bf3ed:	vpbroadcastb -0x119e2f6(%rip),%xmm11        # 521100 <c_first_char_channels+0x8480>
 16bf3f6:	mov    0x18(%rsp),%r8
 16bf3fb:	mov    %r12,%r11
 16bf3fe:	xor    %eax,%eax
 16bf400:	mov    %r15d,%r9d
 16bf403:	mov    $0x1,%r12b
 16bf406:	jmp    16bf511 <pp_define+0x861>
 16bf40b:	xor    %r9d,%r9d
 16bf40e:	mov    %r9b,0xbf(%rsp)
 16bf416:	mov    $0x1,%dl
 16bf418:	cmpb   $0x1,0xbf(%rsp)
 16bf420:	je     16bf2b2 <pp_define+0x602>
 16bf426:	inc    %r11
 16bf429:	cmp    %r8d,%r11d
 16bf42c:	jae    16bf311 <pp_define+0x661>
 16bf432:	mov    0x50(%r13),%rax
 16bf436:	vpbroadcastb -0x119e33f(%rip),%xmm9        # 521100 <c_first_char_channels+0x8480>
 16bf43f:	vmovdqa64 -0x119e389(%rip),%zmm10        # 5210c0 <c_first_char_channels+0x8440>
 16bf449:	vpbroadcastb -0x119e352(%rip),%xmm11        # 521100 <c_first_char_channels+0x8480>
 16bf452:	mov    0x28(%rsp),%r9d
 16bf457:	movzbl (%rax,%r11,1),%ecx
 16bf45c:	and    $0x7f,%cl
 16bf45f:	test   %dl,%dl
 16bf461:	je     16bf476 <pp_define+0x7c6>
 16bf463:	cmp    $0x3b,%cl
 16bf466:	jne    16bf476 <pp_define+0x7c6>
 16bf468:	mov    $0x1,%r12b
 16bf46b:	xor    %r15d,%r15d
 16bf46e:	mov    %r11d,%r14d
 16bf471:	jmp    16bf5e5 <pp_define+0x935>
 16bf476:	mov    $0x1,%r15b
 16bf479:	test   %dl,%dl
 16bf47b:	je     16bf596 <pp_define+0x8e6>
 16bf481:	cmp    $0x10,%cl
 16bf484:	jne    16bf596 <pp_define+0x8e6>
 16bf48a:	mov    %r11d,%r14d
 16bf48d:	mov    $0x1,%r12b
 16bf490:	jmp    16bf5e5 <pp_define+0x935>
 16bf495:	mov    0x24(%rsp),%edx
 16bf499:	mov    $0x2,%esi
 16bf49e:	lea    -0x10ab6f3(%rip),%rcx        # 613db2 <parse_test_openers+0x47872>
 16bf4a5:	mov    %rbx,%rdi
 16bf4a8:	xor    %eax,%eax
 16bf4aa:	call   16781f0 <pp_diagnose>
 16bf4af:	mov    0x18(%rsp),%r8
 16bf4b4:	xor    %edx,%edx
 16bf4b6:	mov    %r12,%r11
 16bf4b9:	cmpb   $0x1,0xbf(%rsp)
 16bf4c1:	jne    16bf426 <pp_define+0x776>
 16bf4c7:	jmp    16bf2b2 <pp_define+0x602>
 16bf4cc:	mov    $0x2,%esi
 16bf4d1:	lea    -0x10ab726(%rip),%rcx        # 613db2 <parse_test_openers+0x47872>
 16bf4d8:	mov    %rbx,%rdi
 16bf4db:	mov    %r14d,%edx
 16bf4de:	xor    %eax,%eax
 16bf4e0:	call   16781f0 <pp_diagnose>
 16bf4e5:	vpbroadcastb -0x119e3ee(%rip),%xmm9        # 521100 <c_first_char_channels+0x8480>
 16bf4ee:	vmovdqa64 -0x119e438(%rip),%zmm10        # 5210c0 <c_first_char_channels+0x8440>
 16bf4f8:	vpbroadcastb -0x119e401(%rip),%xmm11        # 521100 <c_first_char_channels+0x8480>
 16bf501:	mov    0x18(%rsp),%r8
 16bf506:	mov    $0x1,%al
 16bf508:	mov    %r12,%r11
 16bf50b:	mov    %r15d,%r9d
 16bf50e:	xor    %r12d,%r12d
 16bf511:	mov    %r11,%r14
 16bf514:	inc    %r14
 16bf517:	cmp    %r8d,%r14d
 16bf51a:	jae    16bf531 <pp_define+0x881>
 16bf51c:	mov    0x50(%r13),%rcx
 16bf520:	movzbl (%rcx,%r14,1),%ecx
 16bf525:	and    $0x7f,%cl
 16bf528:	cmp    $0x10,%cl
 16bf52b:	sete   %r15b
 16bf52f:	jmp    16bf534 <pp_define+0x884>
 16bf531:	xor    %r15d,%r15d
 16bf534:	or     %r15b,%al
 16bf537:	test   $0x1,%al
 16bf539:	jne    16bf5e5 <pp_define+0x935>
 16bf53f:	mov    0x38(%rsp),%rdx
 16bf544:	mov    %rbx,%rdi
 16bf547:	mov    %r13,%rsi
 16bf54a:	mov    %r14d,%ecx
 16bf54d:	mov    %r9d,%r12d
 16bf550:	vzeroupper
 16bf553:	call   16c1990 <pp_define_location>
 16bf558:	mov    $0x1,%esi
 16bf55d:	lea    -0x105ac80(%rip),%rcx        # 6648e4 <fuzz_comment_end+0x1d49>
 16bf564:	mov    %eax,%edx
 16bf566:	mov    %rbx,%rdi
 16bf569:	xor    %eax,%eax
 16bf56b:	call   16781f0 <pp_diagnose>
 16bf570:	vpbroadcastb -0x119e479(%rip),%xmm11        # 521100 <c_first_char_channels+0x8480>
 16bf579:	vmovdqa64 -0x119e4c3(%rip),%zmm10        # 5210c0 <c_first_char_channels+0x8440>
 16bf583:	vpbroadcastb -0x119e48c(%rip),%xmm9        # 521100 <c_first_char_channels+0x8480>
 16bf58c:	mov    0x18(%rsp),%r8
 16bf591:	mov    %r12d,%r9d
 16bf594:	jmp    16bf5e2 <pp_define+0x932>
 16bf596:	test   %dl,%dl
 16bf598:	je     16bf5d4 <pp_define+0x924>
 16bf59a:	cmp    $0x14,%cl
 16bf59d:	jne    16bf5d4 <pp_define+0x924>
 16bf59f:	mov    0x14(%rsp),%ecx
 16bf5a3:	add    $0x2,%r14d
 16bf5a7:	or     $0x2,%cl
 16bf5aa:	mov    %ecx,0x14(%rsp)
 16bf5ae:	mov    %cl,0x7c(%rsp)
 16bf5b2:	cmp    %r8d,%r14d
 16bf5b5:	jae    16bf60b <pp_define+0x95b>
 16bf5b7:	mov    %r14d,%ecx
 16bf5ba:	movzbl (%rax,%rcx,1),%eax
 16bf5be:	lea    -0x105ace1(%rip),%rcx        # 6648e4 <fuzz_comment_end+0x1d49>
 16bf5c5:	mov    $0x1,%r12b
 16bf5c8:	and    $0x7f,%al
 16bf5ca:	cmp    $0x10,%al
 16bf5cc:	jne    16bf344 <pp_define+0x694>
 16bf5d2:	jmp    16bf5e5 <pp_define+0x935>
 16bf5d4:	test   %dl,%dl
 16bf5d6:	jne    16bf33a <pp_define+0x68a>
 16bf5dc:	xor    %r15d,%r15d
 16bf5df:	mov    %r11d,%r14d
 16bf5e2:	xor    %r12d,%r12d
 16bf5e5:	inc    %r9d
 16bf5e8:	inc    %r14d
 16bf5eb:	test   %r12b,%r12b
 16bf5ee:	je     16bfe17 <pp_define+0x1167>
 16bf5f4:	mov    0x24(%rsp),%edx
 16bf5f8:	test   %r15b,%r15b
 16bf5fb:	mov    0x38(%rsp),%r15
 16bf600:	je     16befdb <pp_define+0x32b>
 16bf606:	jmp    16bfe1b <pp_define+0x116b>
 16bf60b:	lea    -0x105ad2e(%rip),%rcx        # 6648e4 <fuzz_comment_end+0x1d49>
 16bf612:	jmp    16bf344 <pp_define+0x694>
 16bf617:	cmp    $0x40,%rdx
 16bf61b:	jae    16bf62c <pp_define+0x97c>
 16bf61d:	xor    %edi,%edi
 16bf61f:	xor    %ebp,%ebp
 16bf621:	xor    %r8d,%r8d
 16bf624:	xor    %r9d,%r9d
 16bf627:	jmp    16bf868 <pp_define+0xbb8>
 16bf62c:	vpbroadcastb -0x119e535(%rip),%xmm17        # 521101 <c_first_char_channels+0x8481>
 16bf636:	vpbroadcastb -0x119e53e(%rip),%xmm23        # 521102 <c_first_char_channels+0x8482>
 16bf640:	vpbroadcastb -0x119e549(%rip),%xmm11        # 521100 <c_first_char_channels+0x8480>
 16bf649:	vpbroadcastb -0x119e550(%rip),%xmm24        # 521103 <c_first_char_channels+0x8483>
 16bf653:	vpbroadcastd -0x10fbd21(%rip),%zmm18        # 5c393c <executable_lay_out.first_sections+0x408>
 16bf65d:	mov    %rdx,%rdi
 16bf660:	and    $0xffffffffffffffc0,%rdi
 16bf664:	mov    %r8,%r11
 16bf667:	lea    0xc0(%rsi,%r9,4),%r8
 16bf66f:	vpxor  %xmm4,%xmm4,%xmm4
 16bf673:	xor    %r10d,%r10d
 16bf676:	vpxor  %xmm14,%xmm14,%xmm14
 16bf67b:	vpxord %xmm16,%xmm16,%xmm16
 16bf681:	vpxor  %xmm15,%xmm15,%xmm15
 16bf686:	vpxor  %xmm6,%xmm6,%xmm6
 16bf68a:	vpxor  %xmm8,%xmm8,%xmm8
 16bf68f:	vpxor  %xmm7,%xmm7,%xmm7
 16bf693:	vpxor  %xmm5,%xmm5,%xmm5
 16bf697:	vpxord %xmm19,%xmm19,%xmm19
 16bf69d:	vpxord %xmm21,%xmm21,%xmm21
 16bf6a3:	vpxord %xmm20,%xmm20,%xmm20
 16bf6a9:	vpxord %xmm22,%xmm22,%xmm22
 16bf6af:	lea    (%rdi,%r9,1),%rcx
 16bf6b3:	lea    0x30(%r9,%r12,1),%r9
 16bf6b8:	nopl   0x0(%rax,%rax,1)
 16bf6c0:	vpandq -0x30(%r9,%r10,1),%xmm17,%xmm9
 16bf6c8:	vpandq -0x20(%r9,%r10,1),%xmm17,%xmm10
 16bf6d0:	vpandq -0x10(%r9,%r10,1),%xmm17,%xmm12
 16bf6d8:	vpandq (%r9,%r10,1),%xmm17,%xmm13
 16bf6df:	vmovdqa64 %xmm23,%xmm0
 16bf6e5:	vpcmpeqb %xmm11,%xmm9,%k1
 16bf6eb:	vpcmpeqd -0xc0(%r8,%r10,4),%zmm18,%k1{%k1}
 16bf6f3:	vpcmpeqb %xmm0,%xmm9,%xmm1
 16bf6f7:	vpcmpeqb %xmm0,%xmm10,%xmm2
 16bf6fb:	vpcmpeqb %xmm0,%xmm12,%xmm3
 16bf6ff:	vpcmpeqb %xmm0,%xmm13,%xmm0
 16bf703:	vpcmpeqb %xmm11,%xmm10,%k2
 16bf709:	vpcmpeqb %xmm11,%xmm12,%k3
 16bf70f:	vpcmpeqb %xmm11,%xmm13,%k4
 16bf715:	vpternlogq $0xf8,%xmm11,%xmm3,%xmm20
 16bf71c:	vpternlogq $0xf8,%xmm11,%xmm0,%xmm22
 16bf723:	vmovdqa64 %xmm24,%xmm3
 16bf729:	vpcmpeqb %xmm3,%xmm9,%xmm0
 16bf72d:	vpternlogq $0xf8,%xmm11,%xmm1,%xmm19
 16bf734:	vpternlogq $0xf8,%xmm11,%xmm2,%xmm21
 16bf73b:	vpcmpeqb %xmm3,%xmm10,%xmm1
 16bf73f:	vpcmpeqb %xmm3,%xmm12,%xmm2
 16bf743:	vpcmpeqb %xmm3,%xmm13,%xmm3
 16bf747:	vpternlogq $0xf8,%xmm11,%xmm0,%xmm6
 16bf74e:	vpor   %xmm11,%xmm14,%xmm0
 16bf753:	vpternlogq $0xf8,%xmm11,%xmm1,%xmm8
 16bf75a:	vpternlogq $0xf8,%xmm11,%xmm2,%xmm7
 16bf761:	vpternlogq $0xf8,%xmm11,%xmm3,%xmm5
 16bf768:	vmovdqu8 %xmm0,%xmm14{%k1}
 16bf76e:	vpcmpeqd -0x80(%r8,%r10,4),%zmm18,%k1{%k2}
 16bf776:	vporq  %xmm11,%xmm16,%xmm0
 16bf77c:	vmovdqu8 %xmm0,%xmm16{%k1}
 16bf782:	vpcmpeqd -0x40(%r8,%r10,4),%zmm18,%k1{%k3}
 16bf78a:	vpor   %xmm11,%xmm15,%xmm0
 16bf78f:	vmovdqu8 %xmm0,%xmm15{%k1}
 16bf795:	vpcmpeqd (%r8,%r10,4),%zmm18,%k1{%k4}
 16bf79c:	vpor   %xmm4,%xmm11,%xmm0
 16bf7a0:	add    $0x40,%r10
 16bf7a4:	vmovdqu8 %xmm0,%xmm4{%k1}
 16bf7aa:	cmp    %r10,%rdi
 16bf7ad:	jne    16bf6c0 <pp_define+0xa10>
 16bf7b3:	vporq  %xmm14,%xmm16,%xmm0
 16bf7b9:	vpternlogq $0xfe,%xmm0,%xmm15,%xmm4
 16bf7c0:	vpshufd $0xee,%xmm4,%xmm0
 16bf7c5:	vpor   %xmm0,%xmm4,%xmm0
 16bf7c9:	vpshufd $0x55,%xmm0,%xmm1
 16bf7ce:	vpor   %xmm1,%xmm0,%xmm0
 16bf7d2:	vpsrld $0x10,%xmm0,%xmm1
 16bf7d7:	vpor   %xmm1,%xmm0,%xmm0
 16bf7db:	vpsrlw $0x8,%xmm0,%xmm1
 16bf7e0:	vpor   %xmm1,%xmm0,%xmm0
 16bf7e4:	vmovd  %xmm0,%ebp
 16bf7e8:	vpor   %xmm6,%xmm8,%xmm0
 16bf7ec:	vpternlogq $0xfe,%xmm0,%xmm7,%xmm5
 16bf7f3:	vpshufd $0xee,%xmm5,%xmm0
 16bf7f8:	vpor   %xmm0,%xmm5,%xmm0
 16bf7fc:	vpshufd $0x55,%xmm0,%xmm1
 16bf801:	vpor   %xmm1,%xmm0,%xmm0
 16bf805:	vpsrld $0x10,%xmm0,%xmm1
 16bf80a:	vpor   %xmm1,%xmm0,%xmm0
 16bf80e:	vpsrlw $0x8,%xmm0,%xmm1
 16bf813:	vpor   %xmm1,%xmm0,%xmm0
 16bf817:	vmovd  %xmm0,%r8d
 16bf81c:	vporq  %xmm19,%xmm21,%xmm0
 16bf822:	vpternlogq $0xfe,%xmm0,%xmm20,%xmm22
 16bf829:	vpshufd $0xee,%xmm22,%xmm0
 16bf830:	vporq  %xmm0,%xmm22,%xmm0
 16bf836:	vpshufd $0x55,%xmm0,%xmm1
 16bf83b:	vpor   %xmm1,%xmm0,%xmm0
 16bf83f:	vpsrld $0x10,%xmm0,%xmm1
 16bf844:	vpor   %xmm1,%xmm0,%xmm0
 16bf848:	vpsrlw $0x8,%xmm0,%xmm1
 16bf84d:	vpor   %xmm1,%xmm0,%xmm0
 16bf851:	vmovd  %xmm0,%r9d
 16bf856:	cmp    %rdi,%rdx
 16bf859:	je     16bf995 <pp_define+0xce5>
 16bf85f:	test   $0x38,%dl
 16bf862:	je     16bfa52 <pp_define+0xda2>
 16bf868:	mov    %rdx,0x40(%rsp)
 16bf86d:	vpbroadcastb -0x119e775(%rip),%xmm3        # 521101 <c_first_char_channels+0x8481>
 16bf876:	vpbroadcastb -0x119e77d(%rip),%xmm4        # 521102 <c_first_char_channels+0x8482>
 16bf87f:	vpbroadcastb -0x119e788(%rip),%xmm5        # 521100 <c_first_char_channels+0x8480>
 16bf888:	vpbroadcastb -0x119e78e(%rip),%xmm6        # 521103 <c_first_char_channels+0x8483>
 16bf891:	vpbroadcastd -0x10fbf5e(%rip),%ymm7        # 5c393c <executable_lay_out.first_sections+0x408>
 16bf89a:	vpbroadcastb -0x119e7a3(%rip),%xmm8        # 521100 <c_first_char_channels+0x8480>
 16bf8a3:	mov    %rdx,%r10
 16bf8a6:	movzbl %r8b,%r8d
 16bf8aa:	movzbl %bpl,%r11d
 16bf8ae:	and    $0xfffffffffffffff8,%r10
 16bf8b2:	mov    0x28(%rsp),%rdx
 16bf8b7:	vmovd  %r8d,%xmm1
 16bf8bc:	movzbl %r9b,%r8d
 16bf8c0:	vmovd  %r11d,%xmm2
 16bf8c5:	vmovd  %r8d,%xmm0
 16bf8ca:	lea    (%rsi,%rdx,4),%r8
 16bf8ce:	lea    (%r10,%rdx,1),%rcx
 16bf8d2:	lea    (%r12,%rdx,1),%r9
 16bf8d6:	cs nopw 0x0(%rax,%rax,1)
 16bf8e0:	vmovq  (%r9,%rdi,1),%xmm9
 16bf8e6:	vpand  %xmm3,%xmm9,%xmm9
 16bf8ea:	vpcmpeqb %xmm4,%xmm9,%xmm10
 16bf8ee:	vpcmpeqb %xmm5,%xmm9,%k1
 16bf8f4:	vpternlogq $0xf8,%xmm5,%xmm10,%xmm0
 16bf8fb:	vpcmpeqb %xmm6,%xmm9,%xmm10
 16bf8ff:	vmovdqu32 (%r8,%rdi,4),%ymm9{%k1}{z}
 16bf906:	add    $0x8,%rdi
 16bf90a:	vpternlogq $0xf8,%xmm5,%xmm10,%xmm1
 16bf911:	vpcmpeqd %ymm7,%ymm9,%k1{%k1}
 16bf917:	vpor   %xmm2,%xmm8,%xmm9
 16bf91b:	vmovdqu8 %xmm9,%xmm2{%k1}
 16bf921:	cmp    %rdi,%r10
 16bf924:	jne    16bf8e0 <pp_define+0xc30>
 16bf926:	vpshufd $0x55,%xmm2,%xmm3
 16bf92b:	mov    0x18(%rsp),%r11
 16bf930:	vpor   %xmm3,%xmm2,%xmm2
 16bf934:	vpsrld $0x10,%xmm2,%xmm3
 16bf939:	vpor   %xmm3,%xmm2,%xmm2
 16bf93d:	vpsrlw $0x8,%xmm2,%xmm3
 16bf942:	vpor   %xmm3,%xmm2,%xmm2
 16bf946:	vmovd  %xmm2,%ebp
 16bf94a:	vpshufd $0x55,%xmm1,%xmm2
 16bf94f:	vpor   %xmm2,%xmm1,%xmm1
 16bf953:	vpsrld $0x10,%xmm1,%xmm2
 16bf958:	vpor   %xmm2,%xmm1,%xmm1
 16bf95c:	vpsrlw $0x8,%xmm1,%xmm2
 16bf961:	vpor   %xmm2,%xmm1,%xmm1
 16bf965:	vmovd  %xmm1,%r8d
 16bf96a:	vpshufd $0x55,%xmm0,%xmm1
 16bf96f:	vpor   %xmm1,%xmm0,%xmm0
 16bf973:	vpsrld $0x10,%xmm0,%xmm1
 16bf978:	vpor   %xmm1,%xmm0,%xmm0
 16bf97c:	vpsrlw $0x8,%xmm0,%xmm1
 16bf981:	vpor   %xmm1,%xmm0,%xmm0
 16bf985:	vmovd  %xmm0,%r9d
 16bf98a:	cmp    %r10,0x40(%rsp)
 16bf98f:	jne    16bfa52 <pp_define+0xda2>
 16bf995:	mov    %r8b,0x6f(%rsp)
 16bf99a:	mov    %r11,%r8
 16bf99d:	mov    %r9b,0xbf(%rsp)
 16bf9a5:	mov    %bpl,0x6e(%rsp)
 16bf9aa:	mov    0x14(%rsp),%eax
 16bf9ae:	shl    $0x4,%r9b
 16bf9b2:	or     %al,%r9b
 16bf9b5:	test   $0x2,%al
 16bf9b7:	sete   %al
 16bf9ba:	mov    %r9b,0x7c(%rsp)
 16bf9bf:	test   %al,%bpl
 16bf9c2:	je     16bfa84 <pp_define+0xdd4>
 16bf9c8:	mov    0x28(%rsp),%r12
 16bf9cd:	jmp    16bf9dc <pp_define+0xd2c>
 16bf9cf:	nop
 16bf9d0:	inc    %r12
 16bf9d3:	dec    %r15d
 16bf9d6:	je     16bfa80 <pp_define+0xdd0>
 16bf9dc:	mov    0x50(%r13),%rax
 16bf9e0:	movzbl (%rax,%r12,1),%eax
 16bf9e5:	and    $0x7f,%al
 16bf9e7:	cmp    $0x1,%al
 16bf9e9:	jne    16bf9d0 <pp_define+0xd20>
 16bf9eb:	mov    0x60(%r13),%rax
 16bf9ef:	cmpl   $0xab,(%rax,%r12,4)
 16bf9f7:	jne    16bf9d0 <pp_define+0xd20>
 16bf9f9:	mov    0x58(%r13),%rax
 16bf9fd:	mov    0x20(%r13),%rdi
 16bfa01:	movzbl 0x253(%rbx),%edx
 16bfa08:	mov    (%rax,%r12,4),%esi
 16bfa0c:	vzeroupper
 16bfa0f:	call   16c31f0 <pp_start_with_splices>
 16bfa14:	mov    0x38(%rsp),%rcx
 16bfa19:	mov    %rbx,%rdi
 16bfa1c:	xor    %esi,%esi
 16bfa1e:	lea    (%rax,%rcx,1),%edx
 16bfa21:	lea    -0xfd91da(%rip),%rcx        # 6e684e <pp_string_value.meaning+0x32bac>
 16bfa28:	xor    %eax,%eax
 16bfa2a:	call   16781f0 <pp_diagnose>
 16bfa2f:	mov    0x18(%rsp),%r8
 16bfa34:	jmp    16bf9d0 <pp_define+0xd20>
 16bfa36:	cs nopw 0x0(%rax,%rax,1)
 16bfa40:	or     %dl,%r9b
 16bfa43:	or     %dil,%r8b
 16bfa46:	inc    %rcx
 16bfa49:	cmp    %rcx,%rax
 16bfa4c:	je     16bf995 <pp_define+0xce5>
 16bfa52:	movzbl (%r12,%rcx,1),%r10d
 16bfa57:	and    $0x7f,%r10b
 16bfa5b:	cmp    $0x3d,%r10b
 16bfa5f:	sete   %dl
 16bfa62:	cmp    $0x3c,%r10b
 16bfa66:	sete   %dil
 16bfa6a:	cmp    $0x1,%r10b
 16bfa6e:	jne    16bfa40 <pp_define+0xd90>
 16bfa70:	cmpl   $0xab,(%rsi,%rcx,4)
 16bfa77:	sete   %r10b
 16bfa7b:	or     %r10b,%bpl
 16bfa7e:	jmp    16bfa40 <pp_define+0xd90>
 16bfa80:	mov    0x50(%r13),%r12
 16bfa84:	mov    0x28(%rsp),%rax
 16bfa89:	movzbl (%r12,%rax,1),%eax
 16bfa8e:	and    $0x7f,%al
 16bfa90:	cmp    $0x3d,%al
 16bfa92:	jne    16bfa9d <pp_define+0xded>
 16bfa94:	lea    -0xfa1a52(%rip),%r15        # 71e049 <pp_string_value.meaning+0x6a3a7>
 16bfa9b:	jmp    16bfaeb <pp_define+0xe3b>
 16bfa9d:	or     0x6f(%rsp),%bpl
 16bfaa2:	je     16bfad5 <pp_define+0xe25>
 16bfaa4:	mov    0x14(%rsp),%eax
 16bfaa8:	and    $0x1,%al
 16bfaaa:	je     16bfad5 <pp_define+0xe25>
 16bfaac:	mov    0x70(%rsp),%rcx
 16bfab1:	lea    0x78(%rsp),%rdx
 16bfab6:	mov    %rbx,%rdi
 16bfab9:	mov    %r13,%rsi
 16bfabc:	vzeroupper
 16bfabf:	call   16c1b50 <pp_check_replacement_list>
 16bfac4:	test   %al,%al
 16bfac6:	je     16bfcfa <pp_define+0x104a>
 16bfacc:	mov    0x50(%r13),%r12
 16bfad0:	mov    0x18(%rsp),%r8
 16bfad5:	lea    -0x1(%r8),%r14d
 16bfad9:	movzbl (%r12,%r14,1),%eax
 16bfade:	and    $0x7f,%al
 16bfae0:	cmp    $0x3d,%al
 16bfae2:	jne    16bfb13 <pp_define+0xe63>
 16bfae4:	lea    -0x100bf9c(%rip),%r15        # 6b3b4f <fuzz_comment_end+0x50fb4>
 16bfaeb:	mov    0x38(%rsp),%rdx
 16bfaf0:	mov    %rbx,%rdi
 16bfaf3:	mov    %r13,%rsi
 16bfaf6:	mov    %r14d,%ecx
 16bfaf9:	vzeroupper
 16bfafc:	call   16c1990 <pp_define_location>
 16bfb01:	mov    %rbx,%rdi
 16bfb04:	mov    $0x1,%esi
 16bfb09:	mov    %eax,%edx
 16bfb0b:	mov    %r15,%rcx
 16bfb0e:	jmp    16bfcf0 <pp_define+0x1040>
 16bfb13:	cmpb   $0x1,0x278(%rbx)
 16bfb1a:	jne    16bfb4c <pp_define+0xe9c>
 16bfb1c:	mov    0x30(%rsp),%rdx
 16bfb21:	mov    0xde0(%rbx),%rax
 16bfb28:	mov    %edx,%ecx
 16bfb2a:	shr    $0x6,%ecx
 16bfb2d:	mov    (%rax,%rcx,8),%rax
 16bfb31:	bt     %rdx,%rax
 16bfb35:	jae    16bfc74 <pp_define+0xfc4>
 16bfb3b:	mov    0xdd8(%rbx),%rax
 16bfb42:	mov    0x30(%rsp),%rcx
 16bfb47:	mov    (%rax,%rcx,4),%eax
 16bfb4a:	jmp    16bfb63 <pp_define+0xeb3>
 16bfb4c:	mov    0xdd8(%rbx),%rax
 16bfb53:	mov    0x30(%rsp),%rcx
 16bfb58:	mov    (%rax,%rcx,4),%eax
 16bfb5b:	test   %eax,%eax
 16bfb5d:	je     16bfc74 <pp_define+0xfc4>
 16bfb63:	mov    0xde8(%rbx),%r14
 16bfb6a:	mov    %eax,%eax
 16bfb6c:	mov    %rax,%r15
 16bfb6f:	shl    $0x6,%r15
 16bfb73:	movzbl 0x5(%r14,%r15,1),%ecx
 16bfb79:	cmp    $0xc,%ecx
 16bfb7c:	je     16bfc74 <pp_define+0xfc4>
 16bfb82:	cmp    $0x21,%ecx
 16bfb85:	je     16bfc74 <pp_define+0xfc4>
 16bfb8b:	test   %rax,%rax
 16bfb8e:	je     16bfc74 <pp_define+0xfc4>
 16bfb94:	add    %r15,%r14
 16bfb97:	mov    %rbx,%rdi
 16bfb9a:	mov    %r14,%rsi
 16bfb9d:	vzeroupper
 16bfba0:	call   16c22d0 <pp_language_defined>
 16bfba5:	test   %al,%al
 16bfba7:	je     16bfbc5 <pp_define+0xf15>
 16bfba9:	mov    0x24(%rsp),%edx
 16bfbad:	lea    -0x100c038(%rip),%rcx        # 6b3b7c <fuzz_comment_end+0x50fe1>
 16bfbb4:	mov    %rbx,%rdi
 16bfbb7:	xor    %esi,%esi
 16bfbb9:	xor    %eax,%eax
 16bfbbb:	call   16781f0 <pp_diagnose>
 16bfbc0:	jmp    16bfc74 <pp_define+0xfc4>
 16bfbc5:	testb  $0x40,0x4(%r14)
 16bfbca:	jne    16bfc74 <pp_define+0xfc4>
 16bfbd0:	lea    0x78(%rsp),%rdx
 16bfbd5:	mov    %rbx,%rdi
 16bfbd8:	mov    %r14,%rsi
 16bfbdb:	call   16c23e0 <pp_same_definition>
 16bfbe0:	test   %al,%al
 16bfbe2:	jne    16bfc74 <pp_define+0xfc4>
 16bfbe8:	mov    0x270(%rbx),%rax
 16bfbef:	mov    0x30(%rsp),%rdx
 16bfbf4:	mov    %rbx,%rdi
 16bfbf7:	xor    %esi,%esi
 16bfbf9:	mov    0x10(%rax),%rcx
 16bfbfd:	mov    (%rcx,%rdx,8),%r9d
 16bfc01:	mov    0x4(%rcx,%rdx,8),%r8d
 16bfc06:	mov    0x24(%rsp),%edx
 16bfc0a:	lea    -0xfa1b99(%rip),%rcx        # 71e078 <pp_string_value.meaning+0x6a3d6>
 16bfc11:	add    0x40(%rax),%r9
 16bfc15:	xor    %eax,%eax
 16bfc17:	call   16781f0 <pp_diagnose>
 16bfc1c:	cmpb   $0x0,0x1048(%rbx)
 16bfc23:	jne    16bfc74 <pp_define+0xfc4>
 16bfc25:	cmpb   $0x0,0x255(%rbx)
 16bfc2c:	jne    16bfc74 <pp_define+0xfc4>
 16bfc2e:	mov    0x268(%rbx),%r14
 16bfc35:	test   %r14,%r14
 16bfc38:	jne    16bfc44 <pp_define+0xf94>
 16bfc3a:	mov    0xd960b7(%rip),%rax        # 2455cf8 <stderr@GLIBC_2.2.5>
 16bfc41:	mov    (%rax),%r14
 16bfc44:	mov    0xde8(%rbx),%rax
 16bfc4b:	mov    %rbx,%rdi
 16bfc4e:	mov    %r14,%rsi
 16bfc51:	mov    0x24(%rax,%r15,1),%edx
 16bfc56:	call   1678b20 <pp_diagnostic_place>
 16bfc5b:	lea    -0x100c0cd(%rip),%rdi        # 6b3b95 <fuzz_comment_end+0x50ffa>
 16bfc62:	mov    $0x22,%esi
 16bfc67:	mov    $0x1,%edx
 16bfc6c:	mov    %r14,%rcx
 16bfc6f:	call   7ce6b0 <fwrite@plt>
 16bfc74:	mov    0xdf0(%rbx),%edx
 16bfc7a:	cmp    $0x1000000,%rdx
 16bfc81:	jae    16bfcdf <pp_define+0x102f>
 16bfc83:	mov    0xde8(%rbx),%rcx
 16bfc8a:	mov    0x30(%rsp),%rsi
 16bfc8f:	mov    %rdx,%rax
 16bfc92:	shl    $0x6,%rax
 16bfc96:	vpxor  %xmm0,%xmm0,%xmm0
 16bfc9a:	mov    %esi,(%rcx,%rax,1)
 16bfc9d:	vmovdqu %ymm0,0x4(%rcx,%rax,1)
 16bfca3:	vmovdqu %ymm0,0x20(%rcx,%rax,1)
 16bfca9:	incl   0xdf0(%rbx)
 16bfcaf:	test   %rdx,%rdx
 16bfcb2:	je     16bfcfa <pp_define+0x104a>
 16bfcb4:	vmovdqu64 0x78(%rsp),%zmm0
 16bfcbf:	mov    0xde8(%rbx),%rcx
 16bfcc6:	mov    0x30(%rsp),%rsi
 16bfccb:	mov    %rbx,%rdi
 16bfcce:	vmovdqu64 %zmm0,(%rcx,%rax,1)
 16bfcd5:	vzeroupper
 16bfcd8:	call   1679630 <pp_set_macro>
 16bfcdd:	jmp    16bfcfa <pp_define+0x104a>
 16bfcdf:	lea    -0xfa1e83(%rip),%rcx        # 71de63 <pp_string_value.meaning+0x6a1c1>
 16bfce6:	mov    $0x2,%esi
 16bfceb:	mov    %rbx,%rdi
 16bfcee:	xor    %edx,%edx
 16bfcf0:	xor    %eax,%eax
 16bfcf2:	vzeroupper
 16bfcf5:	call   16781f0 <pp_diagnose>
 16bfcfa:	mov    0x70(%rsp),%rax
 16bfcff:	test   %rax,%rax
 16bfd02:	je     16bfd25 <pp_define+0x1075>
 16bfd04:	mov    0x98(%rax),%rcx
 16bfd0b:	test   %rcx,%rcx
 16bfd0e:	je     16bfd25 <pp_define+0x1075>
 16bfd10:	mov    0xa0(%rax),%rax
 16bfd17:	cmp    0x8(%rcx),%rax
 16bfd1b:	ja     16bfe7c <pp_define+0x11cc>
 16bfd21:	mov    %rax,0x8(%rcx)
 16bfd25:	mov    %fs:0x28,%rax
 16bfd2e:	cmp    0xc0(%rsp),%rax
 16bfd36:	jne    16bfe74 <pp_define+0x11c4>
 16bfd3c:	add    $0xc8,%rsp
 16bfd43:	pop    %rbx
 16bfd44:	pop    %r12
 16bfd46:	pop    %r13
 16bfd48:	pop    %r14
 16bfd4a:	pop    %r15
 16bfd4c:	pop    %rbp
 16bfd4d:	vzeroupper
 16bfd50:	ret
 16bfd51:	mov    0x4c(%rsp),%ecx
 16bfd55:	mov    %edx,%ebp
 16bfd57:	mov    %r15d,%edx
 16bfd5a:	mov    %rbx,%rdi
 16bfd5d:	mov    %r13,%rsi
 16bfd60:	mov    %r9d,%r15d
 16bfd63:	vzeroupper
 16bfd66:	call   16c1780 <pp_line_end_location>
 16bfd6b:	lea    -0x105b48e(%rip),%rcx        # 6648e4 <fuzz_comment_end+0x1d49>
 16bfd72:	mov    $0x1,%esi
 16bfd77:	mov    %eax,%edx
 16bfd79:	xor    %r12d,%r12d
 16bfd7c:	mov    %rbx,%rdi
 16bfd7f:	xor    %eax,%eax
 16bfd81:	call   16781f0 <pp_diagnose>
 16bfd86:	mov    0x18(%rsp),%r8
 16bfd8b:	mov    %r15d,%r9d
 16bfd8e:	mov    %ebp,%edx
 16bfd90:	inc    %r14d
 16bfd93:	jmp    16bfe1b <pp_define+0x116b>
 16bfd98:	mov    $0x1,%r12b
 16bfd9b:	inc    %r14d
 16bfd9e:	jmp    16bfe1b <pp_define+0x116b>
 16bfda0:	mov    0x58(%r13),%rax
 16bfda4:	mov    0x20(%r13),%rdi
 16bfda8:	movzbl 0x253(%rbx),%edx
 16bfdaf:	mov    %r9d,%ebp
 16bfdb2:	mov    (%rax,%r11,4),%esi
 16bfdb6:	vzeroupper
 16bfdb9:	call   16c31f0 <pp_start_with_splices>
 16bfdbe:	lea    (%rax,%r15,1),%edx
 16bfdc2:	lea    -0xfbd998(%rip),%rcx        # 702431 <pp_string_value.meaning+0x4e78f>
 16bfdc9:	jmp    16bfdf4 <pp_define+0x1144>
 16bfdcb:	mov    0x58(%r13),%rax
 16bfdcf:	mov    0x20(%r13),%rdi
 16bfdd3:	movzbl 0x253(%rbx),%edx
 16bfdda:	mov    %r9d,%ebp
 16bfddd:	mov    (%rax,%r11,4),%esi
 16bfde1:	vzeroupper
 16bfde4:	call   16c31f0 <pp_start_with_splices>
 16bfde9:	lea    (%rax,%r15,1),%edx
 16bfded:	lea    -0x10ddc48(%rip),%rcx        # 5e21ac <parse_test_openers+0x15c6c>
 16bfdf4:	mov    $0x1,%esi
 16bfdf9:	xor    %r12d,%r12d
 16bfdfc:	mov    %rbx,%rdi
 16bfdff:	xor    %eax,%eax
 16bfe01:	call   16781f0 <pp_diagnose>
 16bfe06:	mov    0x18(%rsp),%r8
 16bfe0b:	mov    0x24(%rsp),%edx
 16bfe0f:	mov    %ebp,%r9d
 16bfe12:	inc    %r14d
 16bfe15:	jmp    16bfe1b <pp_define+0x116b>
 16bfe17:	mov    0x24(%rsp),%edx
 16bfe1b:	cmp    $0x1001,%r9d
 16bfe22:	setae  %al
 16bfe25:	and    %r12b,%al
 16bfe28:	cmp    $0x1,%al
 16bfe2a:	jne    16bfe50 <pp_define+0x11a0>
 16bfe2c:	lea    -0x100c27b(%rip),%rcx        # 6b3bb8 <fuzz_comment_end+0x5101d>
 16bfe33:	mov    $0x1,%esi
 16bfe38:	mov    $0x1000,%r8d
 16bfe3e:	mov    %rbx,%rdi
 16bfe41:	xor    %eax,%eax
 16bfe43:	vzeroupper
 16bfe46:	call   16781f0 <pp_diagnose>
 16bfe4b:	jmp    16bfcfa <pp_define+0x104a>
 16bfe50:	xor    %eax,%eax
 16bfe52:	test   %r12b,%r12b
 16bfe55:	cmovne %r9d,%eax
 16bfe59:	mov    %ax,0x80(%rsp)
 16bfe61:	mov    %r14d,0x90(%rsp)
 16bfe69:	jne    16beef7 <pp_define+0x247>
 16bfe6f:	jmp    16bfcfa <pp_define+0x104a>
 16bfe74:	vzeroupper
 16bfe77:	call   7cdd10 <__stack_chk_fail@plt>
 16bfe7c:	lea    -0xf8cb81(%rip),%rdi        # 733302 <pp_string_value.meaning+0x7f660>
 16bfe83:	lea    -0xfdd3a3(%rip),%rsi        # 6e2ae7 <pp_string_value.meaning+0x2ee45>
 16bfe8a:	lea    -0xfdd38f(%rip),%rcx        # 6e2b02 <pp_string_value.meaning+0x2ee60>
 16bfe91:	mov    $0xce,%edx
 16bfe96:	vzeroupper
 16bfe99:	call   7cdd80 <__assert_fail@plt>
