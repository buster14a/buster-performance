00000000010bac10 <check_input_run>:
 10bac10:	55                   	push   %rbp
 10bac11:	41 57                	push   %r15
 10bac13:	41 56                	push   %r14
 10bac15:	41 55                	push   %r13
 10bac17:	41 54                	push   %r12
 10bac19:	53                   	push   %rbx
 10bac1a:	48 81 ec 08 08 00 00 	sub    $0x808,%rsp
 10bac21:	62 f1 fd 48 6f 0d 55 	vmovdqa64 -0xc1c1ab(%rip),%zmm1        # 49ea80 <cbuiltin_test_generated.edges+0x3a70>
 10bac28:	3e 3e ff 
 10bac2b:	4c 89 4c 24 38       	mov    %r9,0x38(%rsp)
 10bac30:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
 10bac35:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 10bac39:	c4 e2 79 22 15 fe 40 	vpmovsxbq -0xc1bf02(%rip),%xmm2        # 49ed40 <cbuiltin_test_generated.edges+0x3d30>
 10bac40:	3e ff 
 10bac42:	48 89 f5             	mov    %rsi,%rbp
 10bac45:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 10bac4c:	00 00 
 10bac4e:	48 89 84 24 00 08 00 	mov    %rax,0x800(%rsp)
 10bac55:	00 
 10bac56:	62 f1 fe 48 7f 47 0e 	vmovdqu64 %zmm0,0x380(%rdi)
 10bac5d:	62 f1 fe 48 7f 47 0d 	vmovdqu64 %zmm0,0x340(%rdi)
 10bac64:	62 f1 fe 48 7f 47 0c 	vmovdqu64 %zmm0,0x300(%rdi)
 10bac6b:	62 f1 fe 48 7f 47 0b 	vmovdqu64 %zmm0,0x2c0(%rdi)
