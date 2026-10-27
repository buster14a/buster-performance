
/home/david/buster-fast-bench/codex-180-fix-20261027-align64/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

0000000001560020 <tier0_benchmark_read>:
 1560020:	55                   	push   %rbp
 1560021:	41 56                	push   %r14
 1560023:	53                   	push   %rbx
 1560024:	48 83 ec 20          	sub    $0x20,%rsp
 1560028:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1560031:	89 d5                	mov    %edx,%ebp
 1560033:	49 89 f6             	mov    %rsi,%r14
 1560036:	48 89 fb             	mov    %rdi,%rbx
 1560039:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
 156003e:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 1560047:	45 85 f6             	test   %r14d,%r14d
 156004a:	78 31                	js     156007d <tier0_benchmark_read+0x5d>
 156004c:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 1560051:	ba 08 00 00 00       	mov    $0x8,%edx
 1560056:	44 89 f7             	mov    %r14d,%edi
 1560059:	e8 12 3e 20 ff       	call   763e70 <read@plt>
 156005e:	48 83 f8 08          	cmp    $0x8,%rax
 1560062:	75 19                	jne    156007d <tier0_benchmark_read+0x5d>
 1560064:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1560069:	48 89 43 08          	mov    %rax,0x8(%rbx)
 156006d:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 1560076:	4d 85 f6             	test   %r14,%r14
 1560079:	79 16                	jns    1560091 <tier0_benchmark_read+0x71>
 156007b:	eb 48                	jmp    15600c5 <tier0_benchmark_read+0xa5>
 156007d:	31 c0                	xor    %eax,%eax
 156007f:	48 89 43 08          	mov    %rax,0x8(%rbx)
 1560083:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 156008c:	4d 85 f6             	test   %r14,%r14
 156008f:	78 34                	js     15600c5 <tier0_benchmark_read+0xa5>
 1560091:	49 c1 ee 20          	shr    $0x20,%r14
 1560095:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 156009a:	ba 08 00 00 00       	mov    $0x8,%edx
 156009f:	44 89 f7             	mov    %r14d,%edi
 15600a2:	e8 c9 3d 20 ff       	call   763e70 <read@plt>
 15600a7:	48 83 f8 08          	cmp    $0x8,%rax
 15600ab:	75 18                	jne    15600c5 <tier0_benchmark_read+0xa5>
 15600ad:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 15600b2:	48 89 43 10          	mov    %rax,0x10(%rbx)
 15600b6:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 15600bf:	85 ed                	test   %ebp,%ebp
 15600c1:	79 15                	jns    15600d8 <tier0_benchmark_read+0xb8>
 15600c3:	eb 31                	jmp    15600f6 <tier0_benchmark_read+0xd6>
 15600c5:	31 c0                	xor    %eax,%eax
 15600c7:	48 89 43 10          	mov    %rax,0x10(%rbx)
 15600cb:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 15600d4:	85 ed                	test   %ebp,%ebp
 15600d6:	78 1e                	js     15600f6 <tier0_benchmark_read+0xd6>
 15600d8:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 15600dd:	ba 08 00 00 00       	mov    $0x8,%edx
 15600e2:	89 ef                	mov    %ebp,%edi
 15600e4:	e8 87 3d 20 ff       	call   763e70 <read@plt>
 15600e9:	48 83 f8 08          	cmp    $0x8,%rax
 15600ed:	75 07                	jne    15600f6 <tier0_benchmark_read+0xd6>
 15600ef:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 15600f4:	eb 02                	jmp    15600f8 <tier0_benchmark_read+0xd8>
 15600f6:	31 c0                	xor    %eax,%eax
 15600f8:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 15600fd:	bf 04 00 00 00       	mov    $0x4,%edi
 1560102:	48 89 43 18          	mov    %rax,0x18(%rbx)
 1560106:	e8 a5 39 20 ff       	call   763ab0 <clock_gettime@plt>
 156010b:	48 69 44 24 08 00 ca 9a 3b 	imul   $0x3b9aca00,0x8(%rsp),%rax
 1560114:	48 03 44 24 10       	add    0x10(%rsp),%rax
 1560119:	48 89 03             	mov    %rax,(%rbx)
 156011c:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1560125:	48 3b 44 24 18       	cmp    0x18(%rsp),%rax
 156012a:	75 09                	jne    1560135 <tier0_benchmark_read+0x115>
 156012c:	48 83 c4 20          	add    $0x20,%rsp
 1560130:	5b                   	pop    %rbx
 1560131:	41 5e                	pop    %r14
 1560133:	5d                   	pop    %rbp
 1560134:	c3                   	ret
 1560135:	e8 a6 39 20 ff       	call   763ae0 <__stack_chk_fail@plt>
