
work/analysis/compiler-08545:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000011ac630 <tier1_select_known_bits>:
 11ac630:	push   %rbp
 11ac631:	push   %r15
 11ac633:	push   %r14
 11ac635:	push   %r13
 11ac637:	push   %r12
 11ac639:	push   %rbx
 11ac63a:	sub    $0x20,%rsp
 11ac63e:	mov    0x20(%rdi),%r9
 11ac642:	mov    (%rdi),%rcx
 11ac645:	mov    0x28(%rdi),%r10
 11ac649:	mov    0x38(%rdi),%eax
 11ac64c:	mov    0x8(%rdi),%r8
 11ac650:	mov    %rdi,-0x80(%rsp)
 11ac655:	mov    %r9,-0x30(%rsp)
 11ac65a:	mov    0x30(%rdi),%r9
 11ac65e:	mov    0x60(%rdi),%rdi
 11ac662:	mov    %rcx,-0x28(%rsp)
 11ac667:	mov    %r10,0x18(%rsp)
 11ac66c:	mov    %r9,0x8(%rsp)
 11ac671:	mov    %rdi,-0x38(%rsp)
 11ac676:	test   %edx,%edx
 11ac678:	je     11ad255 <tier1_select_known_bits+0xc25>
 11ac67e:	test   %eax,%eax
 11ac680:	je     11ad26a <tier1_select_known_bits+0xc3a>
 11ac686:	vbroadcasti32x4 -0xb14800(%rip),%zmm0        # 697e90 <abi_test_hex.digits+0x3710>
 11ac690:	vbroadcasti128 -0xb147f9(%rip),%ymm1        # 697ea0 <abi_test_hex.digits+0x3720>
 11ac699:	vbroadcasti128 -0xb147f2(%rip),%ymm2        # 697eb0 <abi_test_hex.digits+0x3730>
 11ac6a2:	vbroadcasti128 -0xb147eb(%rip),%ymm3        # 697ec0 <abi_test_hex.digits+0x3740>
 11ac6ab:	vbroadcasti32x4 -0xb147e5(%rip),%zmm4        # 697ed0 <abi_test_hex.digits+0x3750>
 11ac6b5:	mov    $0xffffffff,%edx
 11ac6ba:	xor    %ecx,%ecx
 11ac6bc:	mov    %eax,%edi
 11ac6be:	xchg   %ax,%ax
 11ac6c0:	mov    %edi,%r9d
 11ac6c3:	sub    $0x20,%edi
 11ac6c6:	mov    %ecx,%r10d
 11ac6c9:	shlx   %r9d,%edx,%r9d
 11ac6ce:	not    %r9d
 11ac6d1:	cmovae %edx,%r9d
 11ac6d5:	add    $0x20,%ecx
 11ac6d8:	kmovd  %r9d,%k1
 11ac6dd:	vmovdqu8 (%r8,%r10,1),%ymm5{%k1}{z}
 11ac6e4:	vpcmpeqb %ymm0,%ymm5,%k2
 11ac6ea:	vpcmpeqb %ymm1,%ymm5,%k3
 11ac6f0:	vpcmpeqb %ymm2,%ymm5,%k4
 11ac6f6:	vpcmpeqb %ymm3,%ymm5,%k5
 11ac6fc:	vpblendmw %zmm0,%zmm4,%zmm5{%k2}
 11ac702:	vmovdqu16 -0xcc2e0c(%rip),%zmm5{%k3}        # 4e9900 <cbuiltin_test_generated.edges+0x1b120>
 11ac70c:	vmovdqu16 -0xcc2dd6(%rip),%zmm5{%k4}        # 4e9940 <cbuiltin_test_generated.edges+0x1b160>
 11ac716:	vmovdqu16 -0xcc2da0(%rip),%zmm5{%k5}        # 4e9980 <cbuiltin_test_generated.edges+0x1b1a0>
 11ac720:	vmovdqu16 %zmm5,(%rsi,%r10,2){%k1}
 11ac727:	cmp    %eax,%ecx
 11ac729:	jb     11ac6c0 <tier1_select_known_bits+0x90>
 11ac72b:	xor    %ecx,%ecx
 11ac72d:	jmp    11ac747 <tier1_select_known_bits+0x117>
 11ac72f:	nop
 11ac730:	mov    0x10(%rsp),%rcx
 11ac735:	cmp    $0x7,%ecx
 11ac738:	lea    0x1(%rcx),%ecx
 11ac73b:	setb   %dl
 11ac73e:	test   %dl,%r11b
 11ac741:	je     11ad26a <tier1_select_known_bits+0xc3a>
 11ac747:	mov    %rcx,0x10(%rsp)
 11ac74c:	xor    %edx,%edx
 11ac74e:	xor    %r11d,%r11d
 11ac751:	jmp    11ac7d4 <tier1_select_known_bits+0x1a4>
 11ac756:	cs nopw 0x0(%rax,%rax,1)
 11ac760:	mov    -0x38(%rsp),%rdi
 11ac765:	shl    $0x4,%r10
 11ac769:	mov    (%rdi,%r10,1),%rdi
 11ac76d:	and    %rcx,%rdi
 11ac770:	lea    -0x1(%rbp),%r9d
 11ac774:	andn   %rcx,%rdi,%rcx
 11ac779:	mov    $0x40,%ebx
 11ac77e:	mov    $0x41,%r15d
 11ac784:	shrx   %r9,%rdi,%r9
 11ac789:	test   %r9,%r9
 11ac78c:	cmove  %rdi,%rcx
 11ac790:	lzcnt  %rdi,%rdi
 11ac795:	lzcnt  %rcx,%rcx
 11ac79a:	sub    %edi,%ebx
 11ac79c:	sub    %ecx,%r15d
 11ac79f:	cmp    %ebp,%ebx
 11ac7a1:	mov    %ebp,%ecx
 11ac7a3:	cmovb  %ebx,%ecx
 11ac7a6:	cmp    %ebp,%r15d
 11ac7a9:	cmovb  %r15d,%ebp
 11ac7ad:	lea    0x1(%rcx),%edi
 11ac7b0:	cmp    %ebp,%ebx
 11ac7b2:	cmovae %ebp,%edi
 11ac7b5:	shl    $0x8,%edi
 11ac7b8:	or     %ecx,%edi
 11ac7ba:	cmp    %di,(%rsi,%rdx,2)
 11ac7be:	mov    %di,(%rsi,%rdx,2)
 11ac7c2:	setne  %cl
 11ac7c5:	or     %cl,%r11b
 11ac7c8:	inc    %rdx
 11ac7cb:	cmp    %rax,%rdx
 11ac7ce:	je     11ac730 <tier1_select_known_bits+0x100>
 11ac7d4:	movzbl (%r8,%rdx,1),%ebx
 11ac7d9:	lea    -0x1(%rbx),%ecx
 11ac7dc:	cmp    $0x5,%ecx
 11ac7df:	jae    11ac8e0 <tier1_select_known_bits+0x2b0>
 11ac7e5:	mov    -0x30(%rsp),%rdi
 11ac7ea:	lea    -0xca6831(%rip),%rcx        # 505fc0 <ir_type_bits>
 11ac7f1:	movzwl (%rcx,%rbx,2),%ebp
 11ac7f5:	mov    (%rdi,%rdx,4),%r10d
 11ac7f9:	mov    %ebp,%r13d
 11ac7fc:	cmp    %eax,%r10d
 11ac7ff:	jae    11ac806 <tier1_select_known_bits+0x1d6>
 11ac801:	movzbl (%rsi,%r10,2),%r13d
 11ac806:	mov    0x18(%rsp),%rcx
 11ac80b:	mov    %ebp,%r14d
 11ac80e:	mov    (%rcx,%rdx,4),%r9d
 11ac812:	cmp    %eax,%r9d
 11ac815:	jb     11ac870 <tier1_select_known_bits+0x240>
 11ac817:	mov    %ebp,%ecx
 11ac819:	cmp    %eax,%r10d
 11ac81c:	jb     11ac87c <tier1_select_known_bits+0x24c>
 11ac81e:	mov    %ebp,%edi
 11ac820:	cmp    %eax,%r9d
 11ac823:	jae    11ac82b <tier1_select_known_bits+0x1fb>
 11ac825:	movzbl 0x1(%rsi,%r9,2),%edi
 11ac82b:	mov    -0x28(%rsp),%r15
 11ac830:	movzbl (%r15,%rdx,1),%r12d
 11ac835:	lea    -0x1(%r12),%r15d
 11ac83a:	cmp    $0x2,%r15b
 11ac83e:	jae    11ac890 <tier1_select_known_bits+0x260>
 11ac840:	mov    $0x520,%ecx
 11ac845:	mov    $0xffffffffffffffff,%rdi
 11ac84c:	bt     %rbx,%rcx
 11ac850:	shlx   %rbp,%rdi,%rcx
 11ac855:	not    %rcx
 11ac858:	cmovb  %rdi,%rcx
 11ac85c:	cmp    $0x1,%r12d
 11ac860:	je     11ac760 <tier1_select_known_bits+0x130>
 11ac866:	xor    %edi,%edi
 11ac868:	jmp    11ac770 <tier1_select_known_bits+0x140>
 11ac86d:	nopl   (%rax)
 11ac870:	movzbl (%rsi,%r9,2),%r14d
 11ac875:	mov    %ebp,%ecx
 11ac877:	cmp    %eax,%r10d
 11ac87a:	jae    11ac81e <tier1_select_known_bits+0x1ee>
 11ac87c:	movzbl 0x1(%rsi,%r10,2),%ecx
 11ac882:	mov    %ebp,%edi
 11ac884:	cmp    %eax,%r9d
 11ac887:	jb     11ac825 <tier1_select_known_bits+0x1f5>
 11ac889:	jmp    11ac82b <tier1_select_known_bits+0x1fb>
 11ac88b:	nopl   0x0(%rax,%rax,1)
 11ac890:	cmp    $0x27,%r12d
 11ac894:	ja     11ac921 <tier1_select_known_bits+0x2f1>
 11ac89a:	movabs $0xe010000010,%r15
 11ac8a4:	mov    %r12d,%ebx
 11ac8a7:	bt     %rbx,%r15
 11ac8ab:	jae    11ac8ee <tier1_select_known_bits+0x2be>
 11ac8ad:	mov    %ebp,%r15d
 11ac8b0:	mov    %ebp,%ebx
 11ac8b2:	cmp    %eax,%r10d
 11ac8b5:	jae    11ac79f <tier1_select_known_bits+0x16f>
 11ac8bb:	movzbl (%r8,%r10,1),%edi
 11ac8c0:	cmp    $0xa,%dil
 11ac8c4:	setne  %r9b
 11ac8c8:	add    $0xfa,%dil
 11ac8cc:	cmp    $0xfb,%dil
 11ac8d0:	setb   %dil
 11ac8d4:	test   %dil,%r9b
 11ac8d7:	cmovne %ebp,%ecx
 11ac8da:	cmovne %ebp,%r13d
 11ac8de:	jmp    11ac916 <tier1_select_known_bits+0x2e6>
 11ac8e0:	cmp    $0xa,%ebx
 11ac8e3:	jne    11ac7c8 <tier1_select_known_bits+0x198>
 11ac8e9:	jmp    11ac7e5 <tier1_select_known_bits+0x1b5>
 11ac8ee:	cmp    $0x1d,%rbx
 11ac8f2:	je     11aca27 <tier1_select_known_bits+0x3f7>
 11ac8f8:	cmp    $0x1e,%rbx
 11ac8fc:	jne    11ac921 <tier1_select_known_bits+0x2f1>
 11ac8fe:	movzbl (%r8,%r10,1),%edi
 11ac903:	lea    -0xca694a(%rip),%r9        # 505fc0 <ir_type_bits>
 11ac90a:	movzwl (%r9,%rdi,2),%edi
 11ac90f:	cmp    %edi,%r13d
 11ac912:	cmovae %ebp,%r13d
 11ac916:	mov    %ecx,%r15d
 11ac919:	mov    %r13d,%ebx
 11ac91c:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11ac921:	lea    -0x19(%r12),%r10d
 11ac926:	mov    $0x1,%ebx
 11ac92b:	mov    %ebp,%r15d
 11ac92e:	cmp    $0x2,%r10b
 11ac932:	jb     11ac79f <tier1_select_known_bits+0x16f>
 11ac938:	lea    -0xc(%r12),%r10d
 11ac93d:	cmp    $0x3,%r10b
 11ac941:	jae    11ac952 <tier1_select_known_bits+0x322>
 11ac943:	cmp    $0xc,%r12d
 11ac947:	jne    11ac99f <tier1_select_known_bits+0x36f>
 11ac949:	cmp    %r14d,%r13d
 11ac94c:	cmovb  %r13d,%r14d
 11ac950:	jmp    11ac9a6 <tier1_select_known_bits+0x376>
 11ac952:	lea    -0x5(%r12),%r10d
 11ac957:	cmp    $0xe,%r10d
 11ac95b:	ja     11ac9b6 <tier1_select_known_bits+0x386>
 11ac95d:	lea    -0xcc2fa4(%rip),%rbx        # 4e99c0 <cbuiltin_test_generated.edges+0x1b1e0>
 11ac964:	movslq (%rbx,%r10,4),%r10
 11ac968:	add    %rbx,%r10
 11ac96b:	jmp    *%r10
 11ac96e:	cmp    %edi,%ecx
 11ac970:	mov    %edi,%r15d
 11ac973:	cmova  %ecx,%r15d
 11ac977:	cmp    $0x5,%r12d
 11ac97b:	je     11aca32 <tier1_select_known_bits+0x402>
 11ac981:	cmp    $0x7,%r12d
 11ac985:	je     11ac9fc <tier1_select_known_bits+0x3cc>
 11ac987:	mov    %ebp,%ebx
 11ac989:	cmp    $0x12,%r12d
 11ac98d:	jne    11aca3f <tier1_select_known_bits+0x40f>
 11ac993:	inc    %ecx
 11ac995:	mov    %ecx,%r15d
 11ac998:	mov    %ebp,%ebx
 11ac99a:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11ac99f:	cmp    %r14d,%r13d
 11ac9a2:	cmova  %r13d,%r14d
 11ac9a6:	cmp    %edi,%ecx
 11ac9a8:	mov    %r14d,%ebx
 11ac9ab:	cmova  %ecx,%edi
 11ac9ae:	mov    %edi,%r15d
 11ac9b1:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11ac9b6:	lea    -0xf(%r12),%r10d
 11ac9bb:	cmp    $0x3,%r10b
 11ac9bf:	jae    11aca47 <tier1_select_known_bits+0x417>
 11ac9c5:	cmp    %eax,%r9d
 11ac9c8:	jae    11acad0 <tier1_select_known_bits+0x4a0>
 11ac9ce:	mov    -0x28(%rsp),%rdi
 11ac9d3:	cmpb   $0x1,(%rdi,%r9,1)
 11ac9d8:	jne    11acad0 <tier1_select_known_bits+0x4a0>
 11ac9de:	mov    -0x30(%rsp),%rdi
 11ac9e3:	mov    (%rdi,%r9,4),%edi
 11ac9e7:	mov    -0x38(%rsp),%r9
 11ac9ec:	shl    $0x4,%rdi
 11ac9f0:	mov    (%r9,%rdi,1),%rdi
 11ac9f4:	mov    $0x1,%r9b
 11ac9f7:	jmp    11acad5 <tier1_select_known_bits+0x4a5>
 11ac9fc:	lea    (%r14,%r13,1),%ebx
 11aca00:	test   %r14d,%r14d
 11aca03:	cmove  %r14d,%ebx
 11aca07:	test   %r13d,%r13d
 11aca0a:	cmove  %r13d,%ebx
 11aca0e:	add    %ecx,%edi
 11aca10:	mov    %edi,%r15d
 11aca13:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11aca18:	mov    %ebp,%r15d
 11aca1b:	mov    %r14d,%ebx
 11aca1e:	cmp    %r13d,%r14d
 11aca21:	jb     11ac79f <tier1_select_known_bits+0x16f>
 11aca27:	mov    %ebp,%r15d
 11aca2a:	mov    %r13d,%ebx
 11aca2d:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11aca32:	cmp    %r14d,%r13d
 11aca35:	cmova  %r13d,%r14d
 11aca39:	inc    %r14d
 11aca3c:	mov    %r14d,%ebx
 11aca3f:	inc    %r15d
 11aca42:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11aca47:	cmp    $0x1b,%r12d
 11aca4b:	je     11acb09 <tier1_select_known_bits+0x4d9>
 11aca51:	mov    %ebp,%r15d
 11aca54:	mov    %ebp,%ebx
 11aca56:	cmp    $0x2f,%r12d
 11aca5a:	jne    11ac79f <tier1_select_known_bits+0x16f>
 11aca60:	mov    -0x80(%rsp),%r10
 11aca65:	movabs $0x7ff79bffffffffff,%rdi
 11aca6f:	mov    (%r10),%rcx
 11aca72:	movzbl (%rcx,%rdx,1),%r13d
 11aca77:	lea    -0xca6a3e(%rip),%rcx        # 506040 <ir_operand_table>
 11aca7e:	movzbl 0x0(%r13,%rcx,1),%ecx
 11aca84:	bt     %r13,%rdi
 11aca88:	mov    %ecx,%edi
 11aca8a:	jae    11acb4c <tier1_select_known_bits+0x51c>
 11aca90:	popcnt %edi,%edi
 11aca94:	lea    -0x2d(%r13),%r9d
 11aca98:	cmp    $0x2,%r9d
 11aca9c:	jae    11acbb7 <tier1_select_known_bits+0x587>
 11acaa2:	mov    0x28(%r10),%r9
 11acaa6:	mov    -0x80(%rsp),%r10
 11acaab:	mov    (%r9,%rdx,4),%r9d
 11acaaf:	mov    0x90(%r10),%r10
 11acab6:	lea    (%r9,%r9,8),%rbx
 11acaba:	lea    (%rbx,%rbx,2),%rbx
 11acabe:	add    %r9,%rbx
 11acac1:	add    0x4(%r10,%rbx,1),%edi
 11acac6:	mov    -0x80(%rsp),%r10
 11acacb:	jmp    11acbc5 <tier1_select_known_bits+0x595>
 11acad0:	xor    %r9d,%r9d
 11acad3:	xor    %edi,%edi
 11acad5:	cmp    $0xf,%r12d
 11acad9:	mov    %ebp,%r15d
 11acadc:	mov    %ebp,%ebx
 11acade:	setne  %r10b
 11acae2:	cmp    %rbp,%rdi
 11acae5:	jae    11ac79f <tier1_select_known_bits+0x16f>
 11acaeb:	or     %r9b,%r10b
 11acaee:	mov    %ebp,%r15d
 11acaf1:	mov    %ebp,%ebx
 11acaf3:	je     11ac79f <tier1_select_known_bits+0x16f>
 11acaf9:	cmp    $0xf,%r12d
 11acafd:	jne    11acb31 <tier1_select_known_bits+0x501>
 11acaff:	add    %edi,%r13d
 11acb02:	add    %edi,%ecx
 11acb04:	jmp    11ac916 <tier1_select_known_bits+0x2e6>
 11acb09:	mov    0x8(%rsp),%rcx
 11acb0e:	mov    (%rcx,%rdx,4),%ecx
 11acb11:	movzwl (%rsi,%rcx,2),%r15d
 11acb16:	movzbl %r15b,%ebx
 11acb1a:	cmp    %ebx,%r14d
 11acb1d:	cmova  %r14d,%ebx
 11acb21:	shr    $0x8,%r15d
 11acb25:	cmp    %r15d,%edi
 11acb28:	cmova  %edi,%r15d
 11acb2c:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11acb31:	cmp    $0x10,%r12d
 11acb35:	je     11acc60 <tier1_select_known_bits+0x630>
 11acb3b:	cmp    %ebp,%r13d
 11acb3e:	jb     11acc60 <tier1_select_known_bits+0x630>
 11acb44:	mov    %ebp,%r13d
 11acb47:	jmp    11acc83 <tier1_select_known_bits+0x653>
 11acb4c:	lea    -0xca6913(%rip),%rdi        # 506240 <ir_optional_table>
 11acb53:	xor    %ebx,%ebx
 11acb55:	movzbl 0x0(%r13,%rdi,1),%r9d
 11acb5b:	mov    0x20(%r10),%rdi
 11acb5f:	mov    -0x80(%rsp),%r10
 11acb64:	cmpl   $0xffffffff,(%rdi,%rdx,4)
 11acb68:	mov    0x28(%r10),%r10
 11acb6c:	mov    -0x80(%rsp),%rdi
 11acb71:	setne  %bl
 11acb74:	xor    %r14d,%r14d
 11acb77:	cmpl   $0xffffffff,(%r10,%rdx,4)
 11acb7c:	mov    0x30(%rdi),%r10
 11acb80:	setne  %r14b
 11acb84:	xor    %edi,%edi
 11acb86:	add    %r14d,%r14d
 11acb89:	or     %ebx,%r14d
 11acb8c:	cmpl   $0xffffffff,(%r10,%rdx,4)
 11acb91:	mov    -0x80(%rsp),%r10
 11acb96:	setne  %dil
 11acb9a:	shl    $0x2,%edi
 11acb9d:	or     %r14d,%edi
 11acba0:	and    %r9d,%edi
 11acba3:	or     %ecx,%edi
 11acba5:	popcnt %edi,%edi
 11acba9:	lea    -0x2d(%r13),%r9d
 11acbad:	cmp    $0x2,%r9d
 11acbb1:	jb     11acaa2 <tier1_select_known_bits+0x472>
 11acbb7:	cmp    $0x2f,%r13d
 11acbbb:	jne    11acbc5 <tier1_select_known_bits+0x595>
 11acbbd:	mov    0x28(%r10),%r9
 11acbc1:	add    (%r9,%rdx,4),%edi
 11acbc5:	test   %edi,%edi
 11acbc7:	je     11acc53 <tier1_select_known_bits+0x623>
 11acbcd:	mov    $0x1,%r9d
 11acbd3:	movabs $0x7ff79bffffffffff,%rbx
 11acbdd:	mov    %edi,%r14d
 11acbe0:	shlx   %r13,%r9,%r9
 11acbe5:	test   %rbx,%r9
 11acbe8:	je     11acc9a <tier1_select_known_bits+0x66a>
 11acbee:	popcnt %ecx,%r12d
 11acbf3:	mov    %ecx,%ecx
 11acbf5:	lea    (%rcx,%rcx,2),%r9
 11acbf9:	mov    %r9,-0x58(%rsp)
 11acbfe:	cmp    $0x1,%edi
 11acc01:	jne    11acd75 <tier1_select_known_bits+0x745>
 11acc07:	mov    $0x1,%r15d
 11acc0d:	xor    %ecx,%ecx
 11acc0f:	xor    %ebx,%ebx
 11acc11:	mov    %rcx,%rdi
 11acc14:	sub    %r12,%rdi
 11acc17:	jae    11acf9e <tier1_select_known_bits+0x96e>
 11acc1d:	mov    -0x58(%rsp),%r9
 11acc22:	lea    -0xca69a9(%rip),%rdi        # 506280 <ir_operand_positions>
 11acc29:	add    %rdi,%r9
 11acc2c:	movzbl (%r9,%rcx,1),%ecx
 11acc31:	test   %ecx,%ecx
 11acc33:	je     11ad1f7 <tier1_select_known_bits+0xbc7>
 11acc39:	cmp    $0x1,%ecx
 11acc3c:	jne    11ad205 <tier1_select_known_bits+0xbd5>
 11acc42:	lea    0x0(,%rdx,4),%rcx
 11acc4a:	add    0x28(%r10),%rcx
 11acc4e:	jmp    11ad211 <tier1_select_known_bits+0xbe1>
 11acc53:	xor    %ebx,%ebx
 11acc55:	mov    $0x1,%r15d
 11acc5b:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11acc60:	mov    %r13d,%r9d
 11acc63:	sub    %edi,%r13d
 11acc66:	cmp    %r9,%rdi
 11acc69:	mov    $0x0,%r9d
 11acc6f:	mov    %ebp,%r15d
 11acc72:	cmovae %r9d,%r13d
 11acc76:	mov    %r13d,%ebx
 11acc79:	cmp    $0x11,%r12d
 11acc7d:	jne    11ac79f <tier1_select_known_bits+0x16f>
 11acc83:	mov    %ecx,%r9d
 11acc86:	sub    %edi,%ecx
 11acc88:	cmp    %r9,%rdi
 11acc8b:	mov    $0x1,%r9d
 11acc91:	cmovae %r9d,%ecx
 11acc95:	jmp    11ac916 <tier1_select_known_bits+0x2e6>
 11acc9a:	mov    0x20(%r10),%r12
 11acc9e:	mov    0x28(%r10),%r15
 11acca2:	mov    %r14,-0x50(%rsp)
 11acca7:	mov    %r10,%r14
 11accaa:	xor    %r10d,%r10d
 11accad:	mov    0x30(%r14),%r14
 11accb1:	lea    -0xca6a78(%rip),%r9        # 506240 <ir_optional_table>
 11accb8:	movzbl 0x0(%r13,%r9,1),%r9d
 11accbe:	cmpl   $0xffffffff,(%r12,%rdx,4)
 11accc3:	lea    (%r12,%rdx,4),%rbx
 11accc7:	mov    %r15,-0x70(%rsp)
 11acccc:	mov    %r12,-0x78(%rsp)
 11accd1:	mov    %rbx,-0x20(%rsp)
 11accd6:	lea    (%r15,%rdx,4),%rbx
 11accda:	mov    %rbx,-0x10(%rsp)
 11accdf:	setne  %r10b
 11acce3:	xor    %ebx,%ebx
 11acce5:	cmpl   $0xffffffff,(%r15,%rdx,4)
 11accea:	lea    (%r14,%rdx,4),%r15
 11accee:	mov    %r15,-0x58(%rsp)
 11accf3:	setne  %bl
 11accf6:	add    %ebx,%ebx
 11accf8:	or     %r10d,%ebx
 11accfb:	xor    %r10d,%r10d
 11accfe:	cmpl   $0xffffffff,(%r14,%rdx,4)
 11acd03:	setne  %r10b
 11acd07:	shl    $0x2,%r10d
 11acd0b:	or     %ebx,%r10d
 11acd0e:	and    %r9d,%r10d
 11acd11:	or     %ecx,%r10d
 11acd14:	lea    (%r10,%r10,2),%r9
 11acd18:	popcnt %r10d,%r14d
 11acd1d:	mov    %r9,-0x18(%rsp)
 11acd22:	cmp    $0x1,%edi
 11acd25:	jne    11acfc2 <tier1_select_known_bits+0x992>
 11acd2b:	mov    $0x1,%r15d
 11acd31:	xor    %r12d,%r12d
 11acd34:	xor    %ebx,%ebx
 11acd36:	mov    %r12,%rcx
 11acd39:	sub    %r14,%rcx
 11acd3c:	jae    11ad1ae <tier1_select_known_bits+0xb7e>
 11acd42:	mov    -0x18(%rsp),%rdi
 11acd47:	lea    -0xca6ace(%rip),%rcx        # 506280 <ir_operand_positions>
 11acd4e:	add    %rcx,%rdi
 11acd51:	movzbl (%rdi,%r12,1),%ecx
 11acd56:	mov    -0x10(%rsp),%rdi
 11acd5b:	cmp    $0x1,%ecx
 11acd5e:	je     11acd6e <tier1_select_known_bits+0x73e>
 11acd60:	mov    -0x20(%rsp),%rdi
 11acd65:	test   %ecx,%ecx
 11acd67:	je     11acd6e <tier1_select_known_bits+0x73e>
 11acd69:	mov    -0x58(%rsp),%rdi
 11acd6e:	mov    (%rdi),%ecx
 11acd70:	jmp    11ad213 <tier1_select_known_bits+0xbe3>
 11acd75:	mov    %r14d,%ecx
 11acd78:	and    $0xfffffffe,%ecx
 11acd7b:	mov    %r13,-0x60(%rsp)
 11acd80:	mov    $0x3,%r13d
 11acd86:	mov    %r14,-0x50(%rsp)
 11acd8b:	lea    -0xca6b12(%rip),%r14        # 506280 <ir_operand_positions>
 11acd92:	mov    $0x1,%r15d
 11acd98:	xor    %edi,%edi
 11acd9a:	xor    %ebx,%ebx
 11acd9c:	mov    %r12,-0x78(%rsp)
 11acda1:	mov    %rcx,-0x70(%rsp)
 11acda6:	sub    %r12d,%r13d
 11acda9:	sub    %r12d,%r13d
 11acdac:	mov    %r12d,%ecx
 11acdaf:	neg    %ecx
 11acdb1:	mov    %rcx,-0x40(%rsp)
 11acdb6:	movslq %ecx,%rcx
 11acdb9:	inc    %rcx
 11acdbc:	mov    %rcx,-0x48(%rsp)
 11acdc1:	lea    0x1(%r14,%r9,1),%rcx
 11acdc6:	mov    %rcx,-0x68(%rsp)
 11acdcb:	jmp    11ace19 <tier1_select_known_bits+0x7e9>
 11acdcd:	nopl   (%rax)
 11acdd0:	mov    0x20(%r12),%r14
 11acdd5:	mov    (%r14,%rdx,4),%r14d
 11acdd9:	add    %r13d,%r14d
 11acddc:	mov    -0x78(%rsp),%r12
 11acde1:	lea    (%rbx,%r14,4),%rbx
 11acde5:	mov    (%rbx),%ebx
 11acde7:	movzwl (%rsi,%rbx,2),%r15d
 11acdec:	movzbl %r15b,%ebx
 11acdf0:	cmp    %ebx,%r10d
 11acdf3:	cmova  %r10d,%ebx
 11acdf7:	mov    -0x80(%rsp),%r10
 11acdfc:	shr    $0x8,%r15d
 11ace00:	cmp    %r15d,%r9d
 11ace03:	cmova  %r9d,%r15d
 11ace07:	add    $0x4,%r13d
 11ace0b:	inc    %rdi
 11ace0e:	cmp    -0x70(%rsp),%rdi
 11ace13:	je     11acf7e <tier1_select_known_bits+0x94e>
 11ace19:	mov    %rdi,%rcx
 11ace1c:	cmp    %r12,%rdi
 11ace1f:	jae    11ace50 <tier1_select_known_bits+0x820>
 11ace21:	mov    -0x68(%rsp),%rdi
 11ace26:	movzbl -0x1(%rdi,%rcx,1),%edi
 11ace2b:	test   %edi,%edi
 11ace2d:	je     11ace9f <tier1_select_known_bits+0x86f>
 11ace2f:	cmp    $0x1,%edi
 11ace32:	jne    11acead <tier1_select_known_bits+0x87d>
 11ace34:	lea    0x0(,%rdx,4),%rdi
 11ace3c:	add    0x28(%r10),%rdi
 11ace40:	jmp    11acec0 <tier1_select_known_bits+0x890>
 11ace42:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 11ace50:	mov    0x50(%r10),%rdi
 11ace54:	cmpb   $0x2f,-0x60(%rsp)
 11ace59:	jne    11ace70 <tier1_select_known_bits+0x840>
 11ace5b:	mov    0x20(%r10),%r9
 11ace5f:	mov    (%r9,%rdx,4),%r9d
 11ace63:	lea    -0x2(%r13,%r9,1),%r9d
 11ace68:	lea    (%rdi,%r9,4),%rdi
 11ace6c:	jmp    11acec0 <tier1_select_known_bits+0x890>
 11ace6e:	xchg   %ax,%ax
 11ace70:	mov    0x28(%r10),%r9
 11ace74:	mov    %r10,%r14
 11ace77:	mov    0x90(%r14),%r14
 11ace7e:	mov    (%r9,%rdx,4),%r9d
 11ace82:	lea    (%r9,%r9,8),%r10
 11ace86:	lea    (%r10,%r10,2),%r10
 11ace8a:	add    %r9,%r10
 11ace8d:	mov    -0x40(%rsp),%r9
 11ace92:	add    %ecx,%r9d
 11ace95:	add    (%r14,%r10,1),%r9d
 11ace99:	lea    (%rdi,%r9,4),%rdi
 11ace9d:	jmp    11acec0 <tier1_select_known_bits+0x890>
 11ace9f:	lea    0x0(,%rdx,4),%rdi
 11acea7:	add    0x20(%r10),%rdi
 11aceab:	jmp    11acec0 <tier1_select_known_bits+0x890>
 11acead:	lea    0x0(,%rdx,4),%rdi
 11aceb5:	add    0x30(%r10),%rdi
 11aceb9:	nopl   0x0(%rax)
 11acec0:	mov    (%rdi),%edi
 11acec2:	movzwl (%rsi,%rdi,2),%r9d
 11acec7:	lea    0x1(%rcx),%rdi
 11acecb:	movzbl %r9b,%r10d
 11acecf:	cmp    %r10d,%ebx
 11aced2:	cmova  %ebx,%r10d
 11aced6:	shr    $0x8,%r9d
 11aceda:	cmp    %r9d,%r15d
 11acedd:	cmova  %r15d,%r9d
 11acee1:	cmp    %r12,%rdi
 11acee4:	jae    11acf10 <tier1_select_known_bits+0x8e0>
 11acee6:	mov    -0x68(%rsp),%rbx
 11aceeb:	movzbl (%rbx,%rcx,1),%ebx
 11aceef:	test   %ebx,%ebx
 11acef1:	je     11acf52 <tier1_select_known_bits+0x922>
 11acef3:	cmp    $0x1,%ebx
 11acef6:	jne    11acf68 <tier1_select_known_bits+0x938>
 11acef8:	mov    -0x80(%rsp),%r14
 11acefd:	lea    0x0(,%rdx,4),%rbx
 11acf05:	add    0x28(%r14),%rbx
 11acf09:	jmp    11acde5 <tier1_select_known_bits+0x7b5>
 11acf0e:	xchg   %ax,%ax
 11acf10:	mov    -0x80(%rsp),%r12
 11acf15:	cmpb   $0x2f,-0x60(%rsp)
 11acf1a:	mov    0x50(%r12),%rbx
 11acf1f:	je     11acdd0 <tier1_select_known_bits+0x7a0>
 11acf25:	mov    0x28(%r12),%r14
 11acf2a:	mov    0x90(%r12),%r12
 11acf32:	mov    (%r14,%rdx,4),%r14d
 11acf36:	lea    (%r14,%r14,8),%r15
 11acf3a:	lea    (%r15,%r15,2),%r15
 11acf3e:	add    %r14,%r15
 11acf41:	mov    -0x48(%rsp),%r14
 11acf46:	add    %ecx,%r14d
 11acf49:	add    (%r12,%r15,1),%r14d
 11acf4d:	jmp    11acddc <tier1_select_known_bits+0x7ac>
 11acf52:	mov    -0x80(%rsp),%r14
 11acf57:	lea    0x0(,%rdx,4),%rbx
 11acf5f:	add    0x20(%r14),%rbx
 11acf63:	jmp    11acde5 <tier1_select_known_bits+0x7b5>
 11acf68:	mov    -0x80(%rsp),%r14
 11acf6d:	lea    0x0(,%rdx,4),%rbx
 11acf75:	add    0x30(%r14),%rbx
 11acf79:	jmp    11acde5 <tier1_select_known_bits+0x7b5>
 11acf7e:	testb  $0x1,-0x50(%rsp)
 11acf83:	je     11ac79f <tier1_select_known_bits+0x16f>
 11acf89:	mov    -0x60(%rsp),%r13
 11acf8e:	add    $0x2,%rcx
 11acf92:	mov    %rcx,%rdi
 11acf95:	sub    %r12,%rdi
 11acf98:	jb     11acc1d <tier1_select_known_bits+0x5ed>
 11acf9e:	mov    0x50(%r10),%rcx
 11acfa2:	cmp    $0x2f,%r13b
 11acfa6:	jne    11ad1d3 <tier1_select_known_bits+0xba3>
 11acfac:	mov    0x20(%r10),%r9
 11acfb0:	mov    (%r9,%rdx,4),%r9d
 11acfb4:	lea    0x1(%r9,%rdi,2),%edi
 11acfb9:	lea    (%rcx,%rdi,4),%rcx
 11acfbd:	jmp    11ad211 <tier1_select_known_bits+0xbe1>
 11acfc2:	mov    -0x50(%rsp),%rcx
 11acfc7:	and    $0xfffffffe,%ecx
 11acfca:	lea    (%r14,%r14,1),%edi
 11acfce:	mov    $0x1,%r15d
 11acfd4:	xor    %ebx,%ebx
 11acfd6:	mov    %r14,-0x68(%rsp)
 11acfdb:	mov    %r13,-0x60(%rsp)
 11acfe0:	mov    %rcx,-0x40(%rsp)
 11acfe5:	mov    $0x3,%ecx
 11acfea:	sub    %edi,%ecx
 11acfec:	mov    %r14d,%edi
 11acfef:	neg    %edi
 11acff1:	mov    %rdi,(%rsp)
 11acff5:	movslq %edi,%rdi
 11acff8:	inc    %rdi
 11acffb:	mov    %rdi,-0x8(%rsp)
 11ad000:	lea    -0xca6d87(%rip),%rdi        # 506280 <ir_operand_positions>
 11ad007:	lea    0x1(%rdi,%r9,1),%rdi
 11ad00c:	mov    %rdi,-0x48(%rsp)
 11ad011:	xor    %edi,%edi
 11ad013:	jmp    11ad05d <tier1_select_known_bits+0xa2d>
 11ad015:	mov    -0x78(%rsp),%r14
 11ad01a:	mov    (%r14,%rdx,4),%r14d
 11ad01e:	add    %ecx,%r14d
 11ad021:	mov    -0x60(%rsp),%r13
 11ad026:	lea    (%rbx,%r14,4),%rbx
 11ad02a:	mov    (%rbx),%ebx
 11ad02c:	mov    -0x68(%rsp),%r14
 11ad031:	movzwl (%rsi,%rbx,2),%r15d
 11ad036:	movzbl %r15b,%ebx
 11ad03a:	cmp    %ebx,%r10d
 11ad03d:	cmova  %r10d,%ebx
 11ad041:	shr    $0x8,%r15d
 11ad045:	cmp    %r15d,%r9d
 11ad048:	cmova  %r9d,%r15d
 11ad04c:	add    $0x4,%ecx
 11ad04f:	inc    %rdi
 11ad052:	cmp    -0x40(%rsp),%rdi
 11ad057:	je     11ad193 <tier1_select_known_bits+0xb63>
 11ad05d:	mov    %rdi,%r12
 11ad060:	cmp    %r14,%rdi
 11ad063:	jae    11ad0a0 <tier1_select_known_bits+0xa70>
 11ad065:	mov    -0x48(%rsp),%rdi
 11ad06a:	mov    -0x70(%rsp),%r10
 11ad06f:	movzbl -0x1(%rdi,%r12,1),%r9d
 11ad075:	lea    (%r10,%rdx,4),%rdi
 11ad079:	cmp    $0x1,%r9d
 11ad07d:	je     11ad0ee <tier1_select_known_bits+0xabe>
 11ad07f:	mov    -0x78(%rsp),%rdi
 11ad084:	lea    (%rdi,%rdx,4),%rdi
 11ad088:	test   %r9d,%r9d
 11ad08b:	je     11ad0ee <tier1_select_known_bits+0xabe>
 11ad08d:	mov    -0x58(%rsp),%rdi
 11ad092:	jmp    11ad0ee <tier1_select_known_bits+0xabe>
 11ad094:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 11ad0a0:	mov    -0x80(%rsp),%r14
 11ad0a5:	mov    0x50(%r14),%rdi
 11ad0a9:	cmp    $0x2f,%r13b
 11ad0ad:	jne    11ad0bf <tier1_select_known_bits+0xa8f>
 11ad0af:	mov    -0x78(%rsp),%r9
 11ad0b4:	mov    (%r9,%rdx,4),%r9d
 11ad0b8:	lea    -0x2(%rcx,%r9,1),%r9d
 11ad0bd:	jmp    11ad0e5 <tier1_select_known_bits+0xab5>
 11ad0bf:	mov    -0x70(%rsp),%r9
 11ad0c4:	mov    0x90(%r14),%r14
 11ad0cb:	mov    (%r9,%rdx,4),%r9d
 11ad0cf:	lea    (%r9,%r9,8),%r10
 11ad0d3:	lea    (%r10,%r10,2),%r10
 11ad0d7:	add    %r9,%r10
 11ad0da:	mov    (%rsp),%r9
 11ad0de:	add    %r12d,%r9d
 11ad0e1:	add    (%r14,%r10,1),%r9d
 11ad0e5:	mov    -0x68(%rsp),%r14
 11ad0ea:	lea    (%rdi,%r9,4),%rdi
 11ad0ee:	mov    (%rdi),%edi
 11ad0f0:	movzwl (%rsi,%rdi,2),%r9d
 11ad0f5:	lea    0x1(%r12),%rdi
 11ad0fa:	movzbl %r9b,%r10d
 11ad0fe:	cmp    %r10d,%ebx
 11ad101:	cmova  %ebx,%r10d
 11ad105:	shr    $0x8,%r9d
 11ad109:	cmp    %r9d,%r15d
 11ad10c:	cmova  %r15d,%r9d
 11ad110:	cmp    %r14,%rdi
 11ad113:	jae    11ad150 <tier1_select_known_bits+0xb20>
 11ad115:	mov    -0x48(%rsp),%rbx
 11ad11a:	mov    -0x70(%rsp),%r15
 11ad11f:	movzbl (%rbx,%r12,1),%r14d
 11ad124:	lea    (%r15,%rdx,4),%rbx
 11ad128:	cmp    $0x1,%r14d
 11ad12c:	je     11ad02a <tier1_select_known_bits+0x9fa>
 11ad132:	mov    -0x78(%rsp),%rbx
 11ad137:	lea    (%rbx,%rdx,4),%rbx
 11ad13b:	test   %r14d,%r14d
 11ad13e:	je     11ad02a <tier1_select_known_bits+0x9fa>
 11ad144:	mov    -0x58(%rsp),%rbx
 11ad149:	jmp    11ad02a <tier1_select_known_bits+0x9fa>
 11ad14e:	xchg   %ax,%ax
 11ad150:	mov    %r13,%r14
 11ad153:	mov    -0x80(%rsp),%r13
 11ad158:	mov    0x50(%r13),%rbx
 11ad15c:	cmp    $0x2f,%r14b
 11ad160:	je     11ad015 <tier1_select_known_bits+0x9e5>
 11ad166:	mov    -0x70(%rsp),%r14
 11ad16b:	mov    0x90(%r13),%r13
 11ad172:	mov    (%r14,%rdx,4),%r14d
 11ad176:	lea    (%r14,%r14,8),%r15
 11ad17a:	lea    (%r15,%r15,2),%r15
 11ad17e:	add    %r14,%r15
 11ad181:	mov    -0x8(%rsp),%r14
 11ad186:	add    %r12d,%r14d
 11ad189:	add    0x0(%r13,%r15,1),%r14d
 11ad18e:	jmp    11ad021 <tier1_select_known_bits+0x9f1>
 11ad193:	testb  $0x1,-0x50(%rsp)
 11ad198:	je     11ac79f <tier1_select_known_bits+0x16f>
 11ad19e:	add    $0x2,%r12
 11ad1a2:	mov    %r12,%rcx
 11ad1a5:	sub    %r14,%rcx
 11ad1a8:	jb     11acd42 <tier1_select_known_bits+0x712>
 11ad1ae:	mov    -0x80(%rsp),%r9
 11ad1b3:	mov    0x50(%r9),%rdi
 11ad1b7:	cmp    $0x2f,%r13b
 11ad1bb:	jne    11ad22e <tier1_select_known_bits+0xbfe>
 11ad1bd:	mov    -0x78(%rsp),%r9
 11ad1c2:	mov    (%r9,%rdx,4),%r9d
 11ad1c6:	lea    0x1(%r9,%rcx,2),%ecx
 11ad1cb:	lea    (%rdi,%rcx,4),%rdi
 11ad1cf:	mov    (%rdi),%ecx
 11ad1d1:	jmp    11ad213 <tier1_select_known_bits+0xbe3>
 11ad1d3:	mov    0x28(%r10),%r9
 11ad1d7:	mov    0x90(%r10),%r10
 11ad1de:	mov    (%r9,%rdx,4),%r9d
 11ad1e2:	lea    (%r9,%r9,8),%r14
 11ad1e6:	lea    (%r14,%r14,2),%r14
 11ad1ea:	add    %r9,%r14
 11ad1ed:	add    (%r10,%r14,1),%edi
 11ad1f1:	lea    (%rcx,%rdi,4),%rcx
 11ad1f5:	jmp    11ad211 <tier1_select_known_bits+0xbe1>
 11ad1f7:	lea    0x0(,%rdx,4),%rcx
 11ad1ff:	add    0x20(%r10),%rcx
 11ad203:	jmp    11ad211 <tier1_select_known_bits+0xbe1>
 11ad205:	lea    0x0(,%rdx,4),%rcx
 11ad20d:	add    0x30(%r10),%rcx
 11ad211:	mov    (%rcx),%ecx
 11ad213:	movzwl (%rsi,%rcx,2),%ecx
 11ad217:	movzbl %cl,%edi
 11ad21a:	cmp    %edi,%ebx
 11ad21c:	cmovbe %edi,%ebx
 11ad21f:	shr    $0x8,%ecx
 11ad222:	cmp    %ecx,%r15d
 11ad225:	cmovbe %ecx,%r15d
 11ad229:	jmp    11ac79f <tier1_select_known_bits+0x16f>
 11ad22e:	mov    -0x70(%rsp),%r10
 11ad233:	mov    0x90(%r9),%r9
 11ad23a:	mov    (%r10,%rdx,4),%r10d
 11ad23e:	lea    (%r10,%r10,8),%r14
 11ad242:	lea    (%r14,%r14,2),%r14
 11ad246:	add    %r10,%r14
 11ad249:	add    (%r9,%r14,1),%ecx
 11ad24d:	lea    (%rdi,%rcx,4),%rdi
 11ad251:	mov    (%rdi),%ecx
 11ad253:	jmp    11ad213 <tier1_select_known_bits+0xbe3>
 11ad255:	test   %eax,%eax
 11ad257:	je     11ad26a <tier1_select_known_bits+0xc3a>
 11ad259:	mov    %eax,%edx
 11ad25b:	and    $0x7,%edx
 11ad25e:	cmp    $0x8,%eax
 11ad261:	jae    11ad27c <tier1_select_known_bits+0xc4c>
 11ad263:	xor    %edi,%edi
 11ad265:	jmp    11ad429 <tier1_select_known_bits+0xdf9>
 11ad26a:	add    $0x20,%rsp
 11ad26e:	pop    %rbx
 11ad26f:	pop    %r12
 11ad271:	pop    %r13
 11ad273:	pop    %r14
 11ad275:	pop    %r15
 11ad277:	pop    %rbp
 11ad278:	vzeroupper
 11ad27b:	ret
 11ad27c:	mov    %eax,%r11d
 11ad27f:	and    $0xfffffff8,%r11d
 11ad283:	lea    -0xc57524(%rip),%rbx        # 555d66 <check_binding_benchmark_measure.isolated_names.rel+0x6ee>
 11ad28a:	xor    %edi,%edi
 11ad28c:	jmp    11ad2b0 <tier1_select_known_bits+0xc80>
 11ad28e:	xchg   %ax,%ax
 11ad290:	movzwl %cx,%ecx
 11ad293:	mov    %ecx,%r9d
 11ad296:	shl    $0x8,%r9d
 11ad29a:	or     %ecx,%r9d
 11ad29d:	mov    %r9w,0xe(%rsi,%rdi,2)
 11ad2a3:	add    $0x8,%rdi
 11ad2a7:	cmp    %rdi,%r11
 11ad2aa:	je     11ad420 <tier1_select_known_bits+0xdf0>
 11ad2b0:	movzbl (%r8,%rdi,1),%r9d
 11ad2b5:	mov    $0x40,%cx
 11ad2b9:	mov    $0x40,%r10w
 11ad2be:	dec    %r9b
 11ad2c1:	cmp    $0x9,%r9b
 11ad2c5:	ja     11ad2d0 <tier1_select_known_bits+0xca0>
 11ad2c7:	movzbl %r9b,%r9d
 11ad2cb:	movzbl (%r9,%rbx,1),%r10d
 11ad2d0:	movzwl %r10w,%r9d
 11ad2d4:	mov    %r9d,%r10d
 11ad2d7:	shl    $0x8,%r10d
 11ad2db:	or     %r9d,%r10d
 11ad2de:	mov    %r10w,(%rsi,%rdi,2)
 11ad2e3:	movzbl 0x1(%r8,%rdi,1),%r9d
 11ad2e9:	dec    %r9b
 11ad2ec:	cmp    $0x9,%r9b
 11ad2f0:	ja     11ad2fa <tier1_select_known_bits+0xcca>
 11ad2f2:	movzbl %r9b,%ecx
 11ad2f6:	movzbl (%rcx,%rbx,1),%ecx
 11ad2fa:	movzwl %cx,%ecx
 11ad2fd:	mov    $0x40,%r10w
 11ad302:	mov    %ecx,%r9d
 11ad305:	shl    $0x8,%r9d
 11ad309:	or     %ecx,%r9d
 11ad30c:	mov    $0x40,%cx
 11ad310:	mov    %r9w,0x2(%rsi,%rdi,2)
 11ad316:	movzbl 0x2(%r8,%rdi,1),%r9d
 11ad31c:	dec    %r9b
 11ad31f:	cmp    $0x9,%r9b
 11ad323:	ja     11ad32e <tier1_select_known_bits+0xcfe>
 11ad325:	movzbl %r9b,%r9d
 11ad329:	movzbl (%r9,%rbx,1),%r10d
 11ad32e:	movzwl %r10w,%r9d
 11ad332:	mov    %r9d,%r10d
 11ad335:	shl    $0x8,%r10d
 11ad339:	or     %r9d,%r10d
 11ad33c:	mov    %r10w,0x4(%rsi,%rdi,2)
 11ad342:	movzbl 0x3(%r8,%rdi,1),%r9d
 11ad348:	dec    %r9b
 11ad34b:	cmp    $0x9,%r9b
 11ad34f:	ja     11ad359 <tier1_select_known_bits+0xd29>
 11ad351:	movzbl %r9b,%ecx
 11ad355:	movzbl (%rcx,%rbx,1),%ecx
 11ad359:	movzwl %cx,%ecx
 11ad35c:	mov    $0x40,%r10w
 11ad361:	mov    %ecx,%r9d
 11ad364:	shl    $0x8,%r9d
 11ad368:	or     %ecx,%r9d
 11ad36b:	mov    $0x40,%cx
 11ad36f:	mov    %r9w,0x6(%rsi,%rdi,2)
 11ad375:	movzbl 0x4(%r8,%rdi,1),%r9d
 11ad37b:	dec    %r9b
 11ad37e:	cmp    $0x9,%r9b
 11ad382:	ja     11ad38d <tier1_select_known_bits+0xd5d>
 11ad384:	movzbl %r9b,%r9d
 11ad388:	movzbl (%r9,%rbx,1),%r10d
 11ad38d:	movzwl %r10w,%r9d
 11ad391:	mov    %r9d,%r10d
 11ad394:	shl    $0x8,%r10d
 11ad398:	or     %r9d,%r10d
 11ad39b:	mov    %r10w,0x8(%rsi,%rdi,2)
 11ad3a1:	movzbl 0x5(%r8,%rdi,1),%r9d
 11ad3a7:	dec    %r9b
 11ad3aa:	cmp    $0x9,%r9b
 11ad3ae:	ja     11ad3b8 <tier1_select_known_bits+0xd88>
 11ad3b0:	movzbl %r9b,%ecx
 11ad3b4:	movzbl (%rcx,%rbx,1),%ecx
 11ad3b8:	movzwl %cx,%ecx
 11ad3bb:	mov    $0x40,%r10w
 11ad3c0:	mov    %ecx,%r9d
 11ad3c3:	shl    $0x8,%r9d
 11ad3c7:	or     %ecx,%r9d
 11ad3ca:	mov    $0x40,%cx
 11ad3ce:	mov    %r9w,0xa(%rsi,%rdi,2)
 11ad3d4:	movzbl 0x6(%r8,%rdi,1),%r9d
 11ad3da:	dec    %r9b
 11ad3dd:	cmp    $0x9,%r9b
 11ad3e1:	ja     11ad3ec <tier1_select_known_bits+0xdbc>
 11ad3e3:	movzbl %r9b,%r9d
 11ad3e7:	movzbl (%r9,%rbx,1),%r10d
 11ad3ec:	movzwl %r10w,%r9d
 11ad3f0:	mov    %r9d,%r10d
 11ad3f3:	shl    $0x8,%r10d
 11ad3f7:	or     %r9d,%r10d
 11ad3fa:	mov    %r10w,0xc(%rsi,%rdi,2)
 11ad400:	movzbl 0x7(%r8,%rdi,1),%r9d
 11ad406:	dec    %r9b
 11ad409:	cmp    $0x9,%r9b
 11ad40d:	ja     11ad290 <tier1_select_known_bits+0xc60>
 11ad413:	movzbl %r9b,%ecx
 11ad417:	movzbl (%rcx,%rbx,1),%ecx
 11ad41b:	jmp    11ad290 <tier1_select_known_bits+0xc60>
 11ad420:	test   %rdx,%rdx
 11ad423:	je     11ac72b <tier1_select_known_bits+0xfb>
 11ad429:	lea    (%rsi,%rdi,2),%rcx
 11ad42d:	add    %r8,%rdi
 11ad430:	lea    -0xc576d1(%rip),%r10        # 555d66 <check_binding_benchmark_measure.isolated_names.rel+0x6ee>
 11ad437:	xor    %r9d,%r9d
 11ad43a:	jmp    11ad45e <tier1_select_known_bits+0xe2e>
 11ad43c:	nopl   0x0(%rax)
 11ad440:	movzwl %r11w,%r11d
 11ad444:	mov    %r11d,%ebx
 11ad447:	shl    $0x8,%ebx
 11ad44a:	or     %r11d,%ebx
 11ad44d:	mov    %bx,(%rcx,%r9,2)
 11ad452:	inc    %r9
 11ad455:	cmp    %r9,%rdx
 11ad458:	je     11ac72b <tier1_select_known_bits+0xfb>
 11ad45e:	movzbl (%rdi,%r9,1),%ebx
 11ad463:	mov    $0x40,%r11w
 11ad468:	dec    %bl
 11ad46a:	cmp    $0x9,%bl
 11ad46d:	ja     11ad440 <tier1_select_known_bits+0xe10>
 11ad46f:	movzbl %bl,%r11d
 11ad473:	movzbl (%r11,%r10,1),%r11d
 11ad478:	jmp    11ad440 <tier1_select_known_bits+0xe10>
