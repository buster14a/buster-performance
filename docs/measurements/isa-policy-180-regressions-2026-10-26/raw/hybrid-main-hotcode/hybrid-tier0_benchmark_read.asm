
/home/david/buster-fast-bench/codex-180-fix-20261027-hybrid/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

0000000001905ed0 <tier0_benchmark_read>:
 1905ed0:	55                   	push   %rbp
 1905ed1:	41 56                	push   %r14
 1905ed3:	53                   	push   %rbx
 1905ed4:	48 83 ec 20          	sub    $0x20,%rsp
 1905ed8:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1905ee1:	89 d5                	mov    %edx,%ebp
 1905ee3:	49 89 f6             	mov    %rsi,%r14
 1905ee6:	48 89 fb             	mov    %rdi,%rbx
 1905ee9:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
 1905eee:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 1905ef7:	45 85 f6             	test   %r14d,%r14d
 1905efa:	78 31                	js     1905f2d <tier0_benchmark_read+0x5d>
 1905efc:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 1905f01:	ba 08 00 00 00       	mov    $0x8,%edx
 1905f06:	44 89 f7             	mov    %r14d,%edi
 1905f09:	e8 62 df e5 fe       	call   763e70 <read@plt>
 1905f0e:	48 83 f8 08          	cmp    $0x8,%rax
 1905f12:	75 19                	jne    1905f2d <tier0_benchmark_read+0x5d>
 1905f14:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1905f19:	48 89 43 08          	mov    %rax,0x8(%rbx)
 1905f1d:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 1905f26:	4d 85 f6             	test   %r14,%r14
 1905f29:	79 16                	jns    1905f41 <tier0_benchmark_read+0x71>
 1905f2b:	eb 48                	jmp    1905f75 <tier0_benchmark_read+0xa5>
 1905f2d:	31 c0                	xor    %eax,%eax
 1905f2f:	48 89 43 08          	mov    %rax,0x8(%rbx)
 1905f33:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 1905f3c:	4d 85 f6             	test   %r14,%r14
 1905f3f:	78 34                	js     1905f75 <tier0_benchmark_read+0xa5>
 1905f41:	49 c1 ee 20          	shr    $0x20,%r14
 1905f45:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 1905f4a:	ba 08 00 00 00       	mov    $0x8,%edx
 1905f4f:	44 89 f7             	mov    %r14d,%edi
 1905f52:	e8 19 df e5 fe       	call   763e70 <read@plt>
 1905f57:	48 83 f8 08          	cmp    $0x8,%rax
 1905f5b:	75 18                	jne    1905f75 <tier0_benchmark_read+0xa5>
 1905f5d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1905f62:	48 89 43 10          	mov    %rax,0x10(%rbx)
 1905f66:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 1905f6f:	85 ed                	test   %ebp,%ebp
 1905f71:	79 15                	jns    1905f88 <tier0_benchmark_read+0xb8>
 1905f73:	eb 31                	jmp    1905fa6 <tier0_benchmark_read+0xd6>
 1905f75:	31 c0                	xor    %eax,%eax
 1905f77:	48 89 43 10          	mov    %rax,0x10(%rbx)
 1905f7b:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 1905f84:	85 ed                	test   %ebp,%ebp
 1905f86:	78 1e                	js     1905fa6 <tier0_benchmark_read+0xd6>
 1905f88:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 1905f8d:	ba 08 00 00 00       	mov    $0x8,%edx
 1905f92:	89 ef                	mov    %ebp,%edi
 1905f94:	e8 d7 de e5 fe       	call   763e70 <read@plt>
 1905f99:	48 83 f8 08          	cmp    $0x8,%rax
 1905f9d:	75 07                	jne    1905fa6 <tier0_benchmark_read+0xd6>
 1905f9f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1905fa4:	eb 02                	jmp    1905fa8 <tier0_benchmark_read+0xd8>
 1905fa6:	31 c0                	xor    %eax,%eax
 1905fa8:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 1905fad:	bf 04 00 00 00       	mov    $0x4,%edi
 1905fb2:	48 89 43 18          	mov    %rax,0x18(%rbx)
 1905fb6:	e8 f5 da e5 fe       	call   763ab0 <clock_gettime@plt>
 1905fbb:	48 69 44 24 08 00 ca 9a 3b 	imul   $0x3b9aca00,0x8(%rsp),%rax
 1905fc4:	48 03 44 24 10       	add    0x10(%rsp),%rax
 1905fc9:	48 89 03             	mov    %rax,(%rbx)
 1905fcc:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1905fd5:	48 3b 44 24 18       	cmp    0x18(%rsp),%rax
 1905fda:	75 09                	jne    1905fe5 <tier0_benchmark_read+0x115>
 1905fdc:	48 83 c4 20          	add    $0x20,%rsp
 1905fe0:	5b                   	pop    %rbx
 1905fe1:	41 5e                	pop    %r14
 1905fe3:	5d                   	pop    %rbp
 1905fe4:	c3                   	ret
 1905fe5:	e8 f6 da e5 fe       	call   763ae0 <__stack_chk_fail@plt>
