
/home/david/buster-fast-bench/codex-180-fix-20261027-section64/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

000000000190bba0 <tier0_benchmark_read>:
 190bba0:	55                   	push   %rbp
 190bba1:	41 56                	push   %r14
 190bba3:	53                   	push   %rbx
 190bba4:	48 83 ec 20          	sub    $0x20,%rsp
 190bba8:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 190bbb1:	89 d5                	mov    %edx,%ebp
 190bbb3:	49 89 f6             	mov    %rsi,%r14
 190bbb6:	48 89 fb             	mov    %rdi,%rbx
 190bbb9:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
 190bbbe:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 190bbc7:	45 85 f6             	test   %r14d,%r14d
 190bbca:	78 31                	js     190bbfd <tier0_benchmark_read+0x5d>
 190bbcc:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 190bbd1:	ba 08 00 00 00       	mov    $0x8,%edx
 190bbd6:	44 89 f7             	mov    %r14d,%edi
 190bbd9:	e8 92 82 e5 fe       	call   763e70 <read@plt>
 190bbde:	48 83 f8 08          	cmp    $0x8,%rax
 190bbe2:	75 19                	jne    190bbfd <tier0_benchmark_read+0x5d>
 190bbe4:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 190bbe9:	48 89 43 08          	mov    %rax,0x8(%rbx)
 190bbed:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 190bbf6:	4d 85 f6             	test   %r14,%r14
 190bbf9:	79 16                	jns    190bc11 <tier0_benchmark_read+0x71>
 190bbfb:	eb 48                	jmp    190bc45 <tier0_benchmark_read+0xa5>
 190bbfd:	31 c0                	xor    %eax,%eax
 190bbff:	48 89 43 08          	mov    %rax,0x8(%rbx)
 190bc03:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 190bc0c:	4d 85 f6             	test   %r14,%r14
 190bc0f:	78 34                	js     190bc45 <tier0_benchmark_read+0xa5>
 190bc11:	49 c1 ee 20          	shr    $0x20,%r14
 190bc15:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 190bc1a:	ba 08 00 00 00       	mov    $0x8,%edx
 190bc1f:	44 89 f7             	mov    %r14d,%edi
 190bc22:	e8 49 82 e5 fe       	call   763e70 <read@plt>
 190bc27:	48 83 f8 08          	cmp    $0x8,%rax
 190bc2b:	75 18                	jne    190bc45 <tier0_benchmark_read+0xa5>
 190bc2d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 190bc32:	48 89 43 10          	mov    %rax,0x10(%rbx)
 190bc36:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 190bc3f:	85 ed                	test   %ebp,%ebp
 190bc41:	79 15                	jns    190bc58 <tier0_benchmark_read+0xb8>
 190bc43:	eb 31                	jmp    190bc76 <tier0_benchmark_read+0xd6>
 190bc45:	31 c0                	xor    %eax,%eax
 190bc47:	48 89 43 10          	mov    %rax,0x10(%rbx)
 190bc4b:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 190bc54:	85 ed                	test   %ebp,%ebp
 190bc56:	78 1e                	js     190bc76 <tier0_benchmark_read+0xd6>
 190bc58:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 190bc5d:	ba 08 00 00 00       	mov    $0x8,%edx
 190bc62:	89 ef                	mov    %ebp,%edi
 190bc64:	e8 07 82 e5 fe       	call   763e70 <read@plt>
 190bc69:	48 83 f8 08          	cmp    $0x8,%rax
 190bc6d:	75 07                	jne    190bc76 <tier0_benchmark_read+0xd6>
 190bc6f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 190bc74:	eb 02                	jmp    190bc78 <tier0_benchmark_read+0xd8>
 190bc76:	31 c0                	xor    %eax,%eax
 190bc78:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 190bc7d:	bf 04 00 00 00       	mov    $0x4,%edi
 190bc82:	48 89 43 18          	mov    %rax,0x18(%rbx)
 190bc86:	e8 25 7e e5 fe       	call   763ab0 <clock_gettime@plt>
 190bc8b:	48 69 44 24 08 00 ca 9a 3b 	imul   $0x3b9aca00,0x8(%rsp),%rax
 190bc94:	48 03 44 24 10       	add    0x10(%rsp),%rax
 190bc99:	48 89 03             	mov    %rax,(%rbx)
 190bc9c:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 190bca5:	48 3b 44 24 18       	cmp    0x18(%rsp),%rax
 190bcaa:	75 09                	jne    190bcb5 <tier0_benchmark_read+0x115>
 190bcac:	48 83 c4 20          	add    $0x20,%rsp
 190bcb0:	5b                   	pop    %rbx
 190bcb1:	41 5e                	pop    %r14
 190bcb3:	5d                   	pop    %rbp
 190bcb4:	c3                   	ret
 190bcb5:	e8 26 7e e5 fe       	call   763ae0 <__stack_chk_fail@plt>
