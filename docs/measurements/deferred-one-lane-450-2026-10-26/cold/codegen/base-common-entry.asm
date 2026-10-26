00000000010ba890 <check_input_run>:
 10ba890:	55                   	push   %rbp
 10ba891:	41 57                	push   %r15
 10ba893:	41 56                	push   %r14
 10ba895:	41 55                	push   %r13
 10ba897:	41 54                	push   %r12
 10ba899:	53                   	push   %rbx
 10ba89a:	48 81 ec 08 08 00 00 	sub    $0x808,%rsp
 10ba8a1:	62 f1 fd 48 6f 0d d5 	vmovdqa64 -0xc1be2b(%rip),%zmm1        # 49ea80 <cbuiltin_test_generated.edges+0x3a70>
 10ba8a8:	41 3e ff 
 10ba8ab:	4c 89 4c 24 38       	mov    %r9,0x38(%rsp)
 10ba8b0:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
 10ba8b5:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 10ba8b9:	c4 e2 79 22 15 7e 44 	vpmovsxbq -0xc1bb82(%rip),%xmm2        # 49ed40 <cbuiltin_test_generated.edges+0x3d30>
 10ba8c0:	3e ff 
 10ba8c2:	48 89 f5             	mov    %rsi,%rbp
 10ba8c5:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 10ba8cc:	00 00 
 10ba8ce:	48 89 84 24 00 08 00 	mov    %rax,0x800(%rsp)
 10ba8d5:	00 
 10ba8d6:	62 f1 fe 48 7f 47 0e 	vmovdqu64 %zmm0,0x380(%rdi)
 10ba8dd:	62 f1 fe 48 7f 47 0d 	vmovdqu64 %zmm0,0x340(%rdi)
 10ba8e4:	62 f1 fe 48 7f 47 0c 	vmovdqu64 %zmm0,0x300(%rdi)
 10ba8eb:	62 f1 fe 48 7f 47 0b 	vmovdqu64 %zmm0,0x2c0(%rdi)
