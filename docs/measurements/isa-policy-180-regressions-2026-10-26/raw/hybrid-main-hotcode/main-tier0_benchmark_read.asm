
/home/david/buster-fast-bench/codex-180-fix-20261026-main/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

000000000193ba40 <tier0_benchmark_read>:
 193ba40:	55                   	push   %rbp
 193ba41:	41 56                	push   %r14
 193ba43:	53                   	push   %rbx
 193ba44:	48 83 ec 20          	sub    $0x20,%rsp
 193ba48:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 193ba51:	89 d5                	mov    %edx,%ebp
 193ba53:	49 89 f6             	mov    %rsi,%r14
 193ba56:	48 89 fb             	mov    %rdi,%rbx
 193ba59:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
 193ba5e:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 193ba67:	45 85 f6             	test   %r14d,%r14d
 193ba6a:	78 31                	js     193ba9d <tier0_benchmark_read+0x5d>
 193ba6c:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 193ba71:	ba 08 00 00 00       	mov    $0x8,%edx
 193ba76:	44 89 f7             	mov    %r14d,%edi
 193ba79:	e8 42 df e5 fe       	call   7999c0 <read@plt>
 193ba7e:	48 83 f8 08          	cmp    $0x8,%rax
 193ba82:	75 19                	jne    193ba9d <tier0_benchmark_read+0x5d>
 193ba84:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 193ba89:	48 89 43 08          	mov    %rax,0x8(%rbx)
 193ba8d:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 193ba96:	4d 85 f6             	test   %r14,%r14
 193ba99:	79 16                	jns    193bab1 <tier0_benchmark_read+0x71>
 193ba9b:	eb 48                	jmp    193bae5 <tier0_benchmark_read+0xa5>
 193ba9d:	31 c0                	xor    %eax,%eax
 193ba9f:	48 89 43 08          	mov    %rax,0x8(%rbx)
 193baa3:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 193baac:	4d 85 f6             	test   %r14,%r14
 193baaf:	78 34                	js     193bae5 <tier0_benchmark_read+0xa5>
 193bab1:	49 c1 ee 20          	shr    $0x20,%r14
 193bab5:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 193baba:	ba 08 00 00 00       	mov    $0x8,%edx
 193babf:	44 89 f7             	mov    %r14d,%edi
 193bac2:	e8 f9 de e5 fe       	call   7999c0 <read@plt>
 193bac7:	48 83 f8 08          	cmp    $0x8,%rax
 193bacb:	75 18                	jne    193bae5 <tier0_benchmark_read+0xa5>
 193bacd:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 193bad2:	48 89 43 10          	mov    %rax,0x10(%rbx)
 193bad6:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 193badf:	85 ed                	test   %ebp,%ebp
 193bae1:	79 15                	jns    193baf8 <tier0_benchmark_read+0xb8>
 193bae3:	eb 31                	jmp    193bb16 <tier0_benchmark_read+0xd6>
 193bae5:	31 c0                	xor    %eax,%eax
 193bae7:	48 89 43 10          	mov    %rax,0x10(%rbx)
 193baeb:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 193baf4:	85 ed                	test   %ebp,%ebp
 193baf6:	78 1e                	js     193bb16 <tier0_benchmark_read+0xd6>
 193baf8:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 193bafd:	ba 08 00 00 00       	mov    $0x8,%edx
 193bb02:	89 ef                	mov    %ebp,%edi
 193bb04:	e8 b7 de e5 fe       	call   7999c0 <read@plt>
 193bb09:	48 83 f8 08          	cmp    $0x8,%rax
 193bb0d:	75 07                	jne    193bb16 <tier0_benchmark_read+0xd6>
 193bb0f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 193bb14:	eb 02                	jmp    193bb18 <tier0_benchmark_read+0xd8>
 193bb16:	31 c0                	xor    %eax,%eax
 193bb18:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 193bb1d:	bf 04 00 00 00       	mov    $0x4,%edi
 193bb22:	48 89 43 18          	mov    %rax,0x18(%rbx)
 193bb26:	e8 d5 da e5 fe       	call   799600 <clock_gettime@plt>
 193bb2b:	48 69 44 24 08 00 ca 9a 3b 	imul   $0x3b9aca00,0x8(%rsp),%rax
 193bb34:	48 03 44 24 10       	add    0x10(%rsp),%rax
 193bb39:	48 89 03             	mov    %rax,(%rbx)
 193bb3c:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 193bb45:	48 3b 44 24 18       	cmp    0x18(%rsp),%rax
 193bb4a:	75 09                	jne    193bb55 <tier0_benchmark_read+0x115>
 193bb4c:	48 83 c4 20          	add    $0x20,%rsp
 193bb50:	5b                   	pop    %rbx
 193bb51:	41 5e                	pop    %r14
 193bb53:	5d                   	pop    %rbp
 193bb54:	c3                   	ret
 193bb55:	e8 d6 da e5 fe       	call   799630 <__stack_chk_fail@plt>
